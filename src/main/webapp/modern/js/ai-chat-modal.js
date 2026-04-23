/**
 * AIChatModal — reusable conversational AI modal.
 *
 *   AIChatModal.open({
 *     // Required
 *     title:        'Circuit Assistant',
 *     ctx:          '/crypto-tool',
 *     systemPrompt: CIRCUIT_CHAT_PROMPT,
 *
 *     // Context injected before EVERY user turn.  Returns whatever
 *     // snapshot of the caller's state the AI should see.  Called
 *     // once per send — re-fetches fresh state each turn.
 *     seedContext: () => formatNetlist(app.serialize().elements),
 *
 *     // Structured-output handlers — fenced code blocks the model may
 *     // emit.  Clicking "Apply" invokes `apply(content)`.  Modal stays
 *     // tool-agnostic; the caller owns what "applying" means.
 *     toolBlocks: {
 *       netlist: {
 *         label: 'Load this circuit',
 *         apply: (content) => app.loadFromElements(parseNetlist(content).elements),
 *       },
 *       // 3D modeler: jscad:  { label: 'Render',   apply: loadCode }
 *       // LaTeX:      latex:  { label: 'Insert',   apply: insertTex }
 *     },
 *
 *     // Optional
 *     subtitle:     'Ask questions about your current circuit.',
 *     placeholder:  'Why is there no current flowing?',
 *     estimatedMs:  240000,        // per-turn AIProgressBar estimate
 *     historyTurns: 4,             // rolling conversation window
 *     footerHtml:   '...',         // bottom note (upgrade link, etc.)
 *     onTurn:       (u, a) => {},
 *     onError:      (msg) => {},
 *   });
 *
 * Depends on: marked.js + DOMPurify (lazy-loaded from CDN on first open),
 *             AIProgressBar (already in the page).
 */
(function (global) {
    'use strict';

    // Lazy-load state.
    var markedReady = null;   // Promise<void>
    var modalEl = null;
    var cfg = null;
    var history = [];         // [{ role, content }]
    var busy = false;
    var abortCtl = null;

    // ── CDN loader ──────────────────────────────────────────────────────────
    function loadScript(src, integrity) {
        return new Promise(function (resolve, reject) {
            var s = document.createElement('script');
            s.src = src;
            if (integrity) { s.integrity = integrity; s.crossOrigin = 'anonymous'; }
            s.onload = resolve;
            s.onerror = function () { reject(new Error('Failed to load ' + src)); };
            document.head.appendChild(s);
        });
    }
    function ensureMarked() {
        if (markedReady) return markedReady;
        markedReady = Promise.all([
            loadScript('https://cdn.jsdelivr.net/npm/marked@12.0.2/marked.min.js'),
            loadScript('https://cdn.jsdelivr.net/npm/dompurify@3.1.6/dist/purify.min.js'),
        ]).then(function () {
            if (global.marked && typeof global.marked.setOptions === 'function') {
                global.marked.setOptions({
                    gfm: true,
                    breaks: true,
                    headerIds: false,
                    mangle: false,
                });
            }
        });
        return markedReady;
    }

    // ── DOM ────────────────────────────────────────────────────────────────
    function $(sel) { return modalEl.querySelector(sel); }
    function build() {
        if (modalEl) return;
        modalEl = document.createElement('div');
        modalEl.className = 'aicm-backdrop';
        modalEl.setAttribute('role', 'dialog');
        modalEl.setAttribute('aria-modal', 'true');
        modalEl.innerHTML =
              '<div class="aicm-modal">'
            +   '<div class="aicm-header">'
            +     '<div class="aicm-header-text">'
            +       '<h3 class="aicm-title"></h3>'
            +       '<p class="aicm-subtitle"></p>'
            +     '</div>'
            +     '<div class="aicm-header-actions">'
            +       '<button type="button" class="aicm-icon-btn aicm-reset" title="Clear conversation">New</button>'
            +       '<button type="button" class="aicm-icon-btn aicm-close" aria-label="Close">&times;</button>'
            +     '</div>'
            +   '</div>'
            +   '<div class="aicm-messages" aria-live="polite"></div>'
            +   '<div class="aicm-progress-slot"></div>'
            +   '<div class="aicm-input-row">'
            +     '<textarea class="aicm-input" rows="1"></textarea>'
            +     '<button type="button" class="aicm-send">Send</button>'
            +   '</div>'
            +   '<div class="aicm-footer"></div>'
            + '</div>';
        document.body.appendChild(modalEl);

        $('.aicm-close').addEventListener('click', close);
        $('.aicm-reset').addEventListener('click', reset);
        modalEl.addEventListener('click', function (e) { if (e.target === modalEl) close(); });

        var input = $('.aicm-input');
        input.addEventListener('input', autoGrow);
        input.addEventListener('keydown', function (e) {
            if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); send(); }
            if (e.key === 'Escape') close();
        });
        $('.aicm-send').addEventListener('click', send);
    }

    function autoGrow() {
        var t = this;
        t.style.height = 'auto';
        t.style.height = Math.min(t.scrollHeight, 140) + 'px';
    }

    // ── Message rendering ──────────────────────────────────────────────────
    function escHtml(s) {
        return String(s).replace(/[&<>"']/g, function (c) {
            return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
        });
    }

    function appendMessage(role, rawText, opts) {
        opts = opts || {};
        var list = $('.aicm-messages');
        var wrap = document.createElement('div');
        wrap.className = 'aicm-msg ' + role;
        if (opts.streaming) wrap.classList.add('streaming');
        wrap.innerHTML =
              '<span class="aicm-msg-role">' + role + '</span>'
            + '<div class="aicm-msg-content"></div>';
        list.appendChild(wrap);
        var contentEl = wrap.querySelector('.aicm-msg-content');

        if (role === 'user' || role === 'system') {
            contentEl.textContent = rawText || '';
        } else {
            // Assistant: markdown (lazy-rendered if marked isn't ready yet).
            renderAssistantText(contentEl, rawText || '');
        }
        list.scrollTop = list.scrollHeight;
        return { wrap: wrap, contentEl: contentEl };
    }

    function renderAssistantText(contentEl, text) {
        if (global.marked && global.DOMPurify) {
            var html = global.marked.parse(text);
            contentEl.innerHTML = global.DOMPurify.sanitize(html);
            injectToolActions(contentEl);
        } else {
            // Fallback while marked loads: show plain text, upgrade on ready.
            contentEl.textContent = text;
            ensureMarked().then(function () {
                var html = global.marked.parse(text);
                contentEl.innerHTML = global.DOMPurify.sanitize(html);
                injectToolActions(contentEl);
            });
        }
    }

    // Scan a freshly-rendered assistant message for code blocks that match a
    // registered toolBlock, and append an "Apply" button below each.
    //
    // Matching is tag-first, content-fallback:
    //   1. If the <code> has class="language-netlist" (or any toolBlock key)
    //      → that tool.
    //   2. Otherwise, if the caller provided tool.detect(content), run it.
    //      Lets tools claim untagged or mis-tagged fences that LOOK right.
    function injectToolActions(contentEl) {
        if (!cfg || !cfg.toolBlocks) return;
        var codes = contentEl.querySelectorAll('pre > code');
        codes.forEach(function (codeEl) {
            var pre = codeEl.parentNode;
            // Avoid double-injection on re-renders.
            if (pre.nextSibling && pre.nextSibling.classList
                && pre.nextSibling.classList.contains('aicm-tool-action')) return;

            var content = codeEl.textContent || '';
            if (!content.trim()) return;

            var match = /language-([a-z0-9_-]+)/i.exec(codeEl.className || '');
            var taggedLang = match ? match[1].toLowerCase() : null;
            var tool = null, toolKey = null;

            // 1. Exact language match
            if (taggedLang && cfg.toolBlocks[taggedLang]) {
                tool = cfg.toolBlocks[taggedLang]; toolKey = taggedLang;
            }
            // 2. Content sniff via tool.detect
            if (!tool) {
                for (var key in cfg.toolBlocks) {
                    var candidate = cfg.toolBlocks[key];
                    if (typeof candidate.detect === 'function') {
                        try {
                            if (candidate.detect(content)) { tool = candidate; toolKey = key; break; }
                        } catch (e) { /* bad detector — ignore */ }
                    }
                }
            }
            if (!tool || typeof tool.apply !== 'function') return;

            var bar = document.createElement('div');
            bar.className = 'aicm-tool-action';
            var btn = document.createElement('button');
            btn.type = 'button';
            btn.textContent = tool.label || ('Apply ' + toolKey);
            btn.addEventListener('click', function () {
                try {
                    tool.apply(content);
                    btn.textContent = '✓ applied';
                    btn.classList.add('applied');
                    btn.disabled = true;
                } catch (err) {
                    btn.textContent = 'Failed: ' + (err.message || err);
                }
            });
            bar.appendChild(btn);
            pre.parentNode.insertBefore(bar, pre.nextSibling);
        });
    }

    // ── Progress bar per turn ──────────────────────────────────────────────
    var progress = null;
    function startProgress() {
        stopProgress(false);
        if (!global.AIProgressBar) return;
        var slot = $('.aicm-progress-slot');
        slot.innerHTML = '';
        progress = global.AIProgressBar.attach(slot, {
            estimatedMs: cfg.estimatedMs || 240000,
            phases: [
                { pct: 12, ms: 2000,   label: 'Sending…' },
                { pct: 25, ms: 12000,  label: 'Thinking…' },
                { pct: 45, ms: 45000,  label: 'Writing reply…' },
                { pct: 65, ms: 90000,  label: 'Refining…' },
                { pct: 82, ms: 150000, label: 'Finalising…' },
                { pct: 92, ms: 210000, label: 'Almost done…' },
            ],
        });
        progress.start();
    }
    function stopProgress(ok) {
        if (progress) { progress.stop(!!ok); setTimeout(function () { if (progress) { progress.destroy(); progress = null; } }, 1200); }
    }

    // ── History + fetch ────────────────────────────────────────────────────
    function buildMessages(userText) {
        var msgs = [{ role: 'system', content: cfg.systemPrompt }];

        // Rolling history window (last N user+assistant pairs)
        var maxPairs = cfg.historyTurns || 4;
        var recent = history.slice(-maxPairs * 2);
        for (var i = 0; i < recent.length; i++) msgs.push(recent[i]);

        // Inject fresh state snapshot + user question on the final turn.
        var state = '';
        if (typeof cfg.seedContext === 'function') {
            try { state = cfg.seedContext() || ''; } catch (e) { state = ''; }
        }
        var composed = state
            ? '[CURRENT CIRCUIT]\n' + state + '\n\n[QUESTION]\n' + userText
            : userText;
        msgs.push({ role: 'user', content: composed });
        return msgs;
    }

    async function send() {
        if (busy) return;
        var input = $('.aicm-input');
        var text = (input.value || '').trim();
        if (!text) return;

        input.value = '';
        input.style.height = 'auto';
        busy = true;
        $('.aicm-send').disabled = true;

        appendMessage('user', text);
        history.push({ role: 'user', content: text });
        var assistantHandle = appendMessage('assistant', '', { streaming: true });

        startProgress();

        try {
            var payload = {
                stream: !!cfg.stream || true,  // default streaming on
                messages: buildMessages(text),
            };
            abortCtl = (typeof AbortController !== 'undefined') ? new AbortController() : null;
            var resp = await fetch((cfg.ctx || '') + '/ai', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload),
                signal: abortCtl ? abortCtl.signal : undefined,
            });

            if (!resp.ok) {
                var errText = await resp.text().catch(function () { return ''; });
                var errMsg;
                try { errMsg = (JSON.parse(errText).error) || 'Server error ' + resp.status; }
                catch (e)  { errMsg = 'Server error ' + resp.status; }
                throw new Error(errMsg);
            }

            // Streaming NDJSON from Ollama (AIProxyServlet.forwardStreaming
            // returns application/x-ndjson).  Each line is a JSON object with
            // either { message: { content: "..." } } or { response: "..." }.
            var ct = resp.headers.get('Content-Type') || '';
            var fullText = '';
            if (ct.indexOf('ndjson') !== -1 && resp.body && resp.body.getReader) {
                var reader = resp.body.getReader();
                var decoder = new TextDecoder();
                var buffer = '';
                while (true) {
                    var chunk = await reader.read();
                    if (chunk.done) break;
                    buffer += decoder.decode(chunk.value, { stream: true });
                    var lines = buffer.split('\n');
                    buffer = lines.pop();
                    for (var i = 0; i < lines.length; i++) {
                        var line = lines[i].trim();
                        if (!line) continue;
                        try {
                            var obj = JSON.parse(line);
                            var delta = (obj.message && obj.message.content) || obj.response || '';
                            if (delta) {
                                fullText += delta;
                                renderAssistantText(assistantHandle.contentEl, fullText);
                                $('.aicm-messages').scrollTop = $('.aicm-messages').scrollHeight;
                            }
                        } catch (e) { /* malformed line — ignore */ }
                    }
                }
            } else {
                // Non-streaming fallback.
                var data = await resp.json();
                fullText = (data && data.message && data.message.content) || data.response || '';
                renderAssistantText(assistantHandle.contentEl, fullText);
            }

            assistantHandle.wrap.classList.remove('streaming');
            history.push({ role: 'assistant', content: fullText });
            stopProgress(true);

            if (typeof cfg.onTurn === 'function') {
                try { cfg.onTurn(text, fullText); } catch (e) { /* caller error */ }
            }
        } catch (err) {
            if (err && err.name === 'AbortError') {
                assistantHandle.wrap.remove();
            } else {
                assistantHandle.wrap.classList.remove('streaming');
                assistantHandle.contentEl.textContent = '';
                appendMessage('system', (err && err.message) || 'Request failed');
                if (typeof cfg.onError === 'function') {
                    try { cfg.onError(err.message || String(err)); } catch (e) {}
                }
            }
            stopProgress(false);
        } finally {
            busy = false;
            $('.aicm-send').disabled = false;
            $('.aicm-input').focus();
            abortCtl = null;
        }
    }

    // ── Reset / close ──────────────────────────────────────────────────────
    function reset() {
        history = [];
        $('.aicm-messages').innerHTML = '';
        appendMessage('system', 'Conversation cleared. Current state will be re-read on your next question.');
    }

    function close() {
        if (abortCtl) { try { abortCtl.abort(); } catch (e) {} }
        if (modalEl) modalEl.classList.remove('open');
    }

    // ── Public open() ──────────────────────────────────────────────────────
    function open(config) {
        build();
        // Preserve history only when the same tool re-opens its chat.
        var sameTool = cfg && config && cfg.title === config.title && cfg.ctx === config.ctx;
        cfg = config || {};
        if (!sameTool) history = [];

        $('.aicm-title').textContent = cfg.title || 'AI Assistant';
        var sub = $('.aicm-subtitle');
        if (cfg.subtitle) { sub.textContent = cfg.subtitle; sub.style.display = 'block'; }
        else { sub.textContent = ''; sub.style.display = 'none'; }

        $('.aicm-input').setAttribute('placeholder', cfg.placeholder || 'Ask a question…');

        var footer = $('.aicm-footer');
        if (cfg.footerHtml) footer.innerHTML = cfg.footerHtml;
        else footer.innerHTML = '';

        // Render any retained history.
        var list = $('.aicm-messages');
        list.innerHTML = '';
        if (history.length === 0) {
            appendMessage('system', sameTool
                ? 'Continuing previous chat.'
                : 'Ask a question — the AI will see your current state on each message.');
        } else {
            for (var i = 0; i < history.length; i++) {
                appendMessage(history[i].role, history[i].content);
            }
        }

        modalEl.classList.add('open');
        ensureMarked();  // warm up the renderer
        setTimeout(function () { $('.aicm-input').focus(); }, 50);
    }

    global.AIChatModal = { open: open, close: close, reset: reset };
})(window);
