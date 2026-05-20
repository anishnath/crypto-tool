/* exam-engine.js — live mock-test emulator engine for AMC + AIME pages.

   Public API:
       ExamEngine.init({
           rootId:      'xm-root',
           dataBase:    '/math/amc/data',     // contains meta.json, q/, s/
           bucket:      'amc-real',           // or 'aime-real'
           questions:   25,                   // questions per session
           durationMin: 75,
           format:      'mcq',                // 'mcq' | 'free'
           freeRange:   [0, 999],             // for AIME
           title:       'AMC Mock Test',
           subtitle:    '25 questions · 75 minutes · MCQ',
           scoring:     { correct: 6, wrong: 0, unanswered: 1.5, max: 150 }
       });

   Data shape (q-shard): [{ id, fmt: 'mcq'|'free', p, a, ch?, chk?, t? }, ...]
   Data shape (s-shard): [{ id, sol }, ...]                                       */

(function (global) {
    'use strict';

    var ExamEngine = {};

    /* ──────────────────────────────────────────────────────────────────── */
    /* Text → HTML rendering with KaTeX                                     */
    /* ──────────────────────────────────────────────────────────────────── */

    function escHtml(s) {
        return String(s == null ? '' : s)
            .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;').replace(/'/g, '&#39;');
    }

    // Markdown links: [text](url) → <a href="url">text</a>.  Best-effort only;
    // AMC problems use these to link to AoPS wiki definitions.
    function mdLinks(s) {
        return s.replace(/\[([^\]]+)\]\((https?:[^)]+)\)/g, function (_, txt, url) {
            return '<a href="' + escHtml(url) + '" target="_blank" rel="noopener noreferrer">' + escHtml(txt) + '</a>';
        });
    }

    // Pre-rendered Asymptote diagram markers ({{DGM:hash}}) emitted by
    // split_amc.py.  We swap them for an <img> AFTER escHtml runs so the
    // marker survives escaping (no <, >, & in it).
    function dgmMarker(s) {
        return s.replace(/\{\{DGM:([a-f0-9]{16})\}\}/g, function (_, hash) {
            var base = (state && state.opts && state.opts.dataBase) || '';
            return '<img class="xm-diagram" src="' + base + '/dgm/' + hash + '.svg" alt="diagram" loading="lazy">';
        }).replace(/\{\{IMG:([a-f0-9]{16}\.(?:png|jpe?g|gif|svg|webp))\}\}/gi, function (_, fname) {
            // Same pattern for downloaded remote figures.
            var base = (state && state.opts && state.opts.dataBase) || '';
            return '<img class="xm-diagram" src="' + base + '/img/' + fname + '" alt="figure" loading="lazy">';
        });
    }

    // Italic / code markers applied within a single prose token (don't span
    // math).  Bold (**...**) is handled at a higher level so it can span
    // math segments — see renderMath().
    function mdItalicCode(s) {
        s = s.replace(/(^|[\s(])\*(\S[^*\n]*?\S|\S)\*(?=[\s).,;:!?]|$)/g, '$1<em>$2</em>');
        s = s.replace(/(^|[\s(])_(\S[^_\n]*?\S|\S)_(?=[\s).,;:!?]|$)/g, '$1<em>$2</em>');
        s = s.replace(/`([^`\n]+?)`/g, '<code>$1</code>');
        return s;
    }

    // Strip the trailing MCQ choice block (\textbf{(A)} ... \textbf{(E)} ...)
    // from a problem before display, so we don't duplicate it next to .xm-choices.
    var CHOICE_MARKER = /\\(?:textbf|text|mathrm)\s*\{\s*\(?\s*[A-E]\s*\)?\s*\}/;
    function stripChoiceBlock(p) {
        var m = CHOICE_MARKER.exec(p);
        if (!m) return p;
        var cut = p.slice(0, m.index);
        // Drop a trailing inline-math close ($) left over from the cut.
        cut = cut.replace(/\$\s*$/, '');
        // Also drop a trailing line of bare digits/whitespace if it was the
        // intro line right before the choices.
        return cut.trimEnd();
    }

    // Tokenize a mixed text into a stream of math + prose tokens.  Used by
    // renderMath so we can run bold-state tracking ACROSS math segments
    // (a **...** pair can have $..$ in the middle).
    function tokenize(text) {
        var out = [];
        var i = 0, n = text.length;
        while (i < n) {
            if (text[i] === '$' && text[i+1] === '$') {
                var end = text.indexOf('$$', i + 2);
                if (end < 0) { out.push({ type: 'prose', text: text.slice(i) }); break; }
                out.push({ type: 'math', display: true, text: text.slice(i + 2, end) });
                i = end + 2;
            } else if (text[i] === '$') {
                var e2 = text.indexOf('$', i + 1);
                if (e2 < 0) { out.push({ type: 'prose', text: text.slice(i) }); break; }
                out.push({ type: 'math', display: false, text: text.slice(i + 1, e2) });
                i = e2 + 1;
            } else {
                var nxt = text.indexOf('$', i);
                out.push({ type: 'prose', text: nxt < 0 ? text.slice(i) : text.slice(i, nxt) });
                i = nxt < 0 ? n : nxt;
            }
        }
        return out;
    }

    // Render mixed prose + LaTeX into HTML.  Math goes through KaTeX; prose
    // through escHtml + mdLinks + (italic/code) + DGM-marker.  Bold (`**…**`)
    // is processed at the token-stream level so it can span math segments.
    function renderMath(text) {
        if (!text) return '';
        var tokens = tokenize(text);
        var html = '';
        var boldOpen = false;
        for (var t = 0; t < tokens.length; t++) {
            var tok = tokens[t];
            if (tok.type === 'math') {
                html += renderTeX(tok.text, !!tok.display);
                continue;
            }
            // Prose: escape, link, then split on `**` and toggle bold state.
            var p = mdLinks(escHtml(tok.text));
            var parts = p.split('**');
            var prose = '';
            for (var k = 0; k < parts.length; k++) {
                if (k > 0) {
                    prose += boldOpen ? '</strong>' : '<strong>';
                    boldOpen = !boldOpen;
                }
                prose += parts[k];
            }
            html += dgmMarker(mdItalicCode(prose));
        }
        if (boldOpen) html += '</strong>';
        return html;
    }

    function renderTeX(tex, displayMode) {
        if (typeof katex === 'undefined') return escHtml(tex);
        try {
            return katex.renderToString(tex, {
                throwOnError: false,
                displayMode: !!displayMode,
                strict: 'ignore'
            });
        } catch (e) {
            return '<code>' + escHtml(tex) + '</code>';
        }
    }

    /* ──────────────────────────────────────────────────────────────────── */
    /* State                                                                */
    /* ──────────────────────────────────────────────────────────────────── */

    var state = null;   // single-instance engine

    function reset(opts) {
        state = {
            opts: opts,
            phase: 'loading',         // loading | setup | running | results
            meta: null,
            shard: null,              // chosen q-shard
            shardName: null,
            qs: [],                   // active questions for this session
            cur: 0,
            picks: {},                // qIdx → user choice (letter or string)
            flags: {},                // qIdx → bool
            deadline: 0,
            timerId: 0,
            solCache: {},             // shardName → array of {id, sol}
            scoring: opts.scoring,
            solutionClicks: 0,        // counts solution reveals for share-nudge
            shareSuppressed: false,   // user opted out via modal checkbox
            cooldownTickId: 0         // setInterval id for the setup-screen countdown
        };
    }

    /* ──────────────────────────────────────────────────────────────────── */
    /* Local-storage history                                                */
    /* ──────────────────────────────────────────────────────────────────── */

    var HIST_KEY_PREFIX = 'xm.history.';
    var HIST_MAX = 20;

    // Cooldown gate between tests — first attempt is immediate, every
    // subsequent attempt has to wait COOLDOWN_MS after the previous submit.
    // Keyed per-bucket so AMC and AIME don't gate each other.
    var COOLDOWN_KEY_PREFIX = 'xm.cooldown.';
    var COOLDOWN_MS = 5 * 60 * 1000;

    function loadHistory(bucket) {
        try {
            var raw = localStorage.getItem(HIST_KEY_PREFIX + bucket);
            if (!raw) return [];
            var arr = JSON.parse(raw);
            return Array.isArray(arr) ? arr : [];
        } catch (e) { return []; }
    }

    function saveResult(bucket, result) {
        try {
            var hist = loadHistory(bucket);
            hist.unshift(result);
            if (hist.length > HIST_MAX) hist = hist.slice(0, HIST_MAX);
            localStorage.setItem(HIST_KEY_PREFIX + bucket, JSON.stringify(hist));
        } catch (e) {}
    }

    function clearHistory(bucket) {
        try {
            localStorage.removeItem(HIST_KEY_PREFIX + bucket);
            localStorage.removeItem(COOLDOWN_KEY_PREFIX + bucket);
        } catch (e) {}
    }

    function setCooldown(bucket) {
        try { localStorage.setItem(COOLDOWN_KEY_PREFIX + bucket, String(Date.now())); } catch (e) {}
    }

    // Returns remaining cooldown in ms (0 if free to start).
    function cooldownRemaining(bucket) {
        try {
            var raw = localStorage.getItem(COOLDOWN_KEY_PREFIX + bucket);
            if (!raw) return 0;
            var last = parseInt(raw, 10);
            if (!last) return 0;
            var rem = COOLDOWN_MS - (Date.now() - last);
            return rem > 0 ? rem : 0;
        } catch (e) { return 0; }
    }

    /* ──────────────────────────────────────────────────────────────────── */
    /* Share modal — "Help us grow" CTA on submit + every 3rd solution view */
    /* ──────────────────────────────────────────────────────────────────── */

    var X_HANDLE = 'anish2good';

    // Inline brand-icon SVGs — same 24×24 viewBox so they line up in a grid.
    var SHARE_ICONS = {
        x:        '<svg viewBox="0 0 24 24" aria-hidden="true"><path fill="currentColor" d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"/></svg>',
        linkedin: '<svg viewBox="0 0 24 24" aria-hidden="true"><path fill="currentColor" d="M20.45 20.45h-3.55v-5.57c0-1.33-.03-3.04-1.85-3.04-1.85 0-2.14 1.45-2.14 2.94v5.67H9.36V9h3.41v1.56h.05a3.74 3.74 0 0 1 3.37-1.85c3.6 0 4.27 2.37 4.27 5.46v6.28zM5.34 7.43a2.06 2.06 0 1 1 0-4.13 2.06 2.06 0 0 1 0 4.13zM7.12 20.45H3.56V9h3.56v11.45zM22.22 0H1.77C.79 0 0 .77 0 1.73v20.54C0 23.23.79 24 1.77 24h20.45C23.2 24 24 23.23 24 22.27V1.73C24 .77 23.2 0 22.22 0z"/></svg>',
        whatsapp: '<svg viewBox="0 0 24 24" aria-hidden="true"><path fill="currentColor" d="M17.47 14.38c-.3-.15-1.75-.86-2.02-.96-.27-.1-.47-.15-.67.15-.2.3-.77.96-.94 1.16-.17.2-.35.22-.65.07-.3-.15-1.25-.46-2.38-1.46-.88-.78-1.47-1.74-1.64-2.04-.17-.3-.02-.46.13-.61.13-.13.3-.35.45-.52.15-.17.2-.3.3-.5.1-.2.05-.37-.02-.52-.07-.15-.67-1.6-.91-2.2-.24-.58-.49-.5-.67-.5-.17-.01-.37-.01-.57-.01s-.52.07-.79.37c-.27.3-1.03 1-1.03 2.44s1.06 2.84 1.21 3.04c.15.2 2.08 3.17 5.04 4.44.7.3 1.25.48 1.68.62.71.22 1.35.2 1.86.12.57-.08 1.75-.71 2-1.4.25-.7.25-1.29.17-1.41-.07-.12-.27-.2-.57-.35M12.05 21.8h-.04c-1.83 0-3.64-.5-5.21-1.41l-.37-.22-3.88 1.02 1.04-3.78-.24-.39A9.84 9.84 0 0 1 1.97 11.9c0-5.43 4.42-9.85 9.86-9.85 2.63 0 5.1 1.02 6.96 2.89A9.78 9.78 0 0 1 21.7 11.9c0 5.44-4.42 9.87-9.65 9.91M20.52 3.45A11.78 11.78 0 0 0 12.05.07C5.52.07.21 5.39.2 11.91c0 2.09.55 4.13 1.59 5.93L.11 24l6.32-1.66a11.8 11.8 0 0 0 5.62 1.43h.01c6.53 0 11.84-5.31 11.85-11.84a11.79 11.79 0 0 0-3.39-8.48"/></svg>',
        facebook: '<svg viewBox="0 0 24 24" aria-hidden="true"><path fill="currentColor" d="M24 12.07A12 12 0 1 0 10.13 24v-8.44H7.08v-3.49h3.05V9.43c0-3.01 1.79-4.67 4.53-4.67 1.32 0 2.69.23 2.69.23v2.96h-1.52c-1.49 0-1.96.93-1.96 1.87v2.25h3.33l-.53 3.49h-2.8V24A12 12 0 0 0 24 12.07"/></svg>',
        reddit:   '<svg viewBox="0 0 24 24" aria-hidden="true"><path fill="currentColor" d="M12 0a12 12 0 1 0 0 24A12 12 0 0 0 12 0Zm5.01 4.74c.69 0 1.25.56 1.25 1.25a1.25 1.25 0 1 1-2.5.06l-2.6-.55-.8 3.75c1.83.07 3.48.63 4.68 1.49.3-.3.73-.49 1.2-.49.97 0 1.75.79 1.75 1.76 0 .72-.43 1.33-1 1.61.02.18.04.35.04.52 0 2.7-3.13 4.87-7 4.87s-7-2.17-7-4.87c0-.18.01-.36.04-.53A1.75 1.75 0 0 1 4.03 12c0-.97.78-1.75 1.75-1.75.46 0 .9.2 1.2.49 1.21-.88 2.88-1.43 4.75-1.49l.88-4.18a.34.34 0 0 1 .14-.2.35.35 0 0 1 .24-.04l2.91.62a1.21 1.21 0 0 1 1.11-.7ZM9.25 12c-.69 0-1.25.56-1.25 1.25S8.56 14.5 9.25 14.5s1.25-.56 1.25-1.25S9.94 12 9.25 12Zm5.5 0c-.69 0-1.25.56-1.25 1.25s.56 1.25 1.25 1.25S16 13.94 16 13.25 15.44 12 14.75 12Zm-5.47 4c-.09 0-.17.03-.23.09a.33.33 0 0 0 0 .46c.84.85 2.48.91 2.96.91s2.1-.06 2.96-.91a.33.33 0 0 0 .03-.46.33.33 0 0 0-.47 0c-.54.53-1.68.73-2.51.73s-1.98-.2-2.51-.73a.33.33 0 0 0-.23-.09Z"/></svg>',
        close:    '<svg viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><path d="M6 6 18 18M18 6 6 18"/></svg>'
    };

    function buildShareText(ctx) {
        var title = (ctx.title || 'free mock test').replace(/—.*$/, '').trim();
        if (ctx.type === 'submit' && ctx.score != null) {
            return 'Just scored ' + ctx.score + ' / ' + ctx.max +
                   ' on the free ' + title +
                   ' — timed mock with step-by-step solutions. Try it yourself, via @' + X_HANDLE;
        }
        return 'Free ' + title +
               ' — timed mock test with step-by-step solutions, fresh problems each session, via @' + X_HANDLE;
    }

    function openShareModal(ctx, onClose) {
        // ctx: { type: 'submit'|'solution', score?, max?, title? }
        if (state && state.shareSuppressed) { if (onClose) onClose(); return; }

        var existing = document.getElementById('xm-share-host');
        if (existing) existing.remove();

        var url      = window.location.href.split('#')[0];
        var shareTxt = buildShareText(ctx);
        var encTxt   = encodeURIComponent(shareTxt);
        var encUrl   = encodeURIComponent(url);

        var twitter  = 'https://twitter.com/intent/tweet?text=' + encTxt + '&url=' + encUrl;
        var linkedin = 'https://www.linkedin.com/sharing/share-offsite/?url=' + encUrl;
        var facebook = 'https://www.facebook.com/sharer/sharer.php?u=' + encUrl;
        var whatsapp = 'https://wa.me/?text=' + encTxt + '%20' + encUrl;
        var reddit   = 'https://www.reddit.com/submit?url=' + encUrl + '&title=' + encTxt;
        var followX  = 'https://twitter.com/' + X_HANDLE;

        var heading = ctx.type === 'submit' ? 'Nice work — share it?' : 'Enjoying the solutions?';
        var subhead = ctx.type === 'submit'
            ? 'A quick share helps more students find this. Your text is auto-filled when you pick a platform.'
            : 'Pass it along — every share helps more students find this.';
        var closeLabel = ctx.type === 'submit' ? 'See my results' : 'Back to reviewing';

        // Score / breakdown summary panel — only on the post-submit popup.
        var scorePanel = '';
        if (ctx.type === 'submit' && ctx.score != null) {
            var pct = ctx.max > 0 ? Math.round(100 * ctx.score / ctx.max) : 0;
            scorePanel = '' +
                '<div class="xm-share-score">' +
                '  <div class="xm-share-score-num">' + ctx.score +
                       '<span class="xm-share-score-denom"> / ' + ctx.max + '</span></div>' +
                '  <div class="xm-share-score-bar"><div style="width:' + pct + '%"></div></div>' +
                '  <div class="xm-share-score-breakdown">' +
                '    <span><b>' + ctx.correct + '</b> correct</span>' +
                '    <span><b>' + ctx.wrong + '</b> wrong</span>' +
                '    <span><b>' + ctx.skipped + '</b> blank</span>' +
                '    <span class="xm-share-score-time">' + escHtml(ctx.usedTime || '') + '</span>' +
                '  </div>' +
                '</div>';
        }

        function btn(key, label, href) {
            return '<button class="xm-share-icon-btn xs-' + key + '" data-href="' + escHtml(href) + '" type="button" aria-label="Share on ' + escHtml(label) + '">' +
                   '<span class="xm-share-icon">' + SHARE_ICONS[key] + '</span>' +
                   '<span class="xm-share-label">' + escHtml(label) + '</span>' +
                   '</button>';
        }

        var host = document.createElement('div');
        host.id = 'xm-share-host';
        host.innerHTML = '' +
            '<div class="xm-modal-backdrop" id="xm-share-backdrop">' +
            '  <div class="xm-modal xm-share-modal" role="dialog" aria-labelledby="xm-share-heading">' +
            '    <button class="xm-share-x" id="xm-share-close-x" type="button" aria-label="Close">' + SHARE_ICONS.close + '</button>' +
            '    <h3 id="xm-share-heading">' + escHtml(heading) + '</h3>' +
            '    <p>' + escHtml(subhead) + '</p>' +
                  scorePanel +
            '    <div class="xm-share-grid">' +
                  btn('x',        'X',        twitter)  +
                  btn('linkedin', 'LinkedIn', linkedin) +
                  btn('whatsapp', 'WhatsApp', whatsapp) +
                  btn('facebook', 'Facebook', facebook) +
                  btn('reddit',   'Reddit',   reddit)   +
            '    </div>' +
            '    <a class="xm-share-via" href="' + escHtml(followX) + '" target="_blank" rel="noopener noreferrer">' +
                   SHARE_ICONS.x + '<span>via @' + X_HANDLE + '</span>' +
            '    </a>' +
            '    <label class="xm-share-mute">' +
            '      <input type="checkbox" id="xm-share-mute"> Don\'t show again this session' +
            '    </label>' +
            '    <div class="xm-modal-actions">' +
            '      <button class="xm-btn xm-btn-primary" id="xm-share-close" type="button">' + escHtml(closeLabel) + '</button>' +
            '    </div>' +
            '  </div>' +
            '</div>';
        document.body.appendChild(host);

        function dismiss() {
            var mute = document.getElementById('xm-share-mute');
            if (mute && mute.checked && state) state.shareSuppressed = true;
            host.remove();
            if (onClose) onClose();
        }

        host.querySelectorAll('.xm-share-icon-btn[data-href]').forEach(function (b) {
            b.addEventListener('click', function () {
                window.open(b.getAttribute('data-href'), '_blank', 'noopener,noreferrer,width=600,height=540');
            });
        });
        document.getElementById('xm-share-close').addEventListener('click', dismiss);
        document.getElementById('xm-share-close-x').addEventListener('click', dismiss);
        document.getElementById('xm-share-backdrop').addEventListener('click', function (e) {
            if (e.target === e.currentTarget) dismiss();
        });
        // Esc to close
        function onKey(e) {
            if (e.key === 'Escape') { document.removeEventListener('keydown', onKey); dismiss(); }
        }
        document.addEventListener('keydown', onKey);
    }

    /* ──────────────────────────────────────────────────────────────────── */
    /* Fetch helpers                                                        */
    /* ──────────────────────────────────────────────────────────────────── */

    function fetchJson(url) {
        return fetch(url, { credentials: 'same-origin' })
            .then(function (r) {
                if (!r.ok) throw new Error('HTTP ' + r.status + ' for ' + url);
                return r.json();
            });
    }

    function shuffleInPlace(arr) {
        for (var i = arr.length - 1; i > 0; i--) {
            var j = Math.floor(Math.random() * (i + 1));
            var t = arr[i]; arr[i] = arr[j]; arr[j] = t;
        }
        return arr;
    }

    /* ──────────────────────────────────────────────────────────────────── */
    /* Phase: loading → setup                                               */
    /* ──────────────────────────────────────────────────────────────────── */

    function loadMeta() {
        var url = state.opts.dataBase + '/meta.json';
        return fetchJson(url).then(function (m) { state.meta = m; });
    }

    function pickAndLoadShard() {
        var bucket = state.opts.bucket;
        var bk = state.meta.buckets[bucket];
        if (!bk || !bk.q_shards || bk.q_shards.length === 0) {
            throw new Error('No shards for bucket ' + bucket);
        }
        var idx = Math.floor(Math.random() * bk.q_shards.length);
        var s = bk.q_shards[idx];
        state.shardName = s.f;
        var url = state.opts.dataBase + '/q/' + s.f;
        return fetchJson(url).then(function (data) {
            state.shard = data;
        });
    }

    function chooseSessionQuestions() {
        var pool = state.shard.slice();
        shuffleInPlace(pool);
        var want = Math.min(state.opts.questions, pool.length);
        // Prefer the configured format if available
        var fmt = state.opts.format;
        var filtered = pool.filter(function (q) { return q.fmt === fmt; });
        var picked = filtered.slice(0, want);
        // Top up if the shard had fewer of this format than needed
        if (picked.length < want) {
            for (var i = 0; i < pool.length && picked.length < want; i++) {
                if (picked.indexOf(pool[i]) === -1) picked.push(pool[i]);
            }
        }
        state.qs = picked;
    }

    /* ──────────────────────────────────────────────────────────────────── */
    /* Render: setup / running / results                                    */
    /* ──────────────────────────────────────────────────────────────────── */

    function render() {
        var root = document.getElementById(state.opts.rootId);
        if (!root) return;
        if (state.phase === 'loading')  root.innerHTML = renderLoading();
        else if (state.phase === 'setup')   root.innerHTML = renderSetup();
        else if (state.phase === 'running') root.innerHTML = renderRunning();
        else if (state.phase === 'results') root.innerHTML = renderResults();
        wireHandlers();
        if (state.phase === 'running') updateTimerDisplay();
    }

    function renderLoading() {
        return '<div class="xm-card xm-loading">' +
            '<span class="xm-spinner"></span>Preparing your test…' +
            '</div>';
    }

    function renderSetup() {
        var o = state.opts;
        var rem = cooldownRemaining(o.bucket);
        var startSection;
        if (rem > 0) {
            var pct = 100 * (1 - rem / COOLDOWN_MS);
            startSection = '' +
                '<div class="xm-cooldown" id="xm-cooldown">' +
                '  <div class="xm-cooldown-head">' +
                '    <span class="xm-cooldown-icon" aria-hidden="true">&#9203;</span>' +
                '    <div>' +
                '      <div class="xm-cooldown-title">Next test available in <span id="xm-cooldown-time">' +
                          formatMS(rem) + '</span></div>' +
                '      <div class="xm-cooldown-hint">Take a moment — review your last attempt below, or jump to a different exam from the sidebar.</div>' +
                '    </div>' +
                '  </div>' +
                '  <div class="xm-cooldown-bar"><div id="xm-cooldown-fill" style="width:' + pct.toFixed(1) + '%"></div></div>' +
                '  <button class="xm-btn xm-btn-primary xm-cooldown-btn" id="xm-start-btn" disabled>Start Test &rarr;</button>' +
                '</div>';
        } else {
            startSection = '<button class="xm-btn xm-btn-primary" id="xm-start-btn">Start Test &rarr;</button>';
        }

        return '' +
            '<div class="xm-card xm-setup">' +
            '  <h2>' + escHtml(o.title) + '</h2>' +
            '  <p>' + escHtml(o.subtitle) + '</p>' +
            '  <div class="xm-setup-grid">' +
            '    <div class="xm-stat-tile"><span class="xm-stat-num">' + o.questions + '</span><span class="xm-stat-lbl">Questions</span></div>' +
            '    <div class="xm-stat-tile"><span class="xm-stat-num">' + o.durationMin + ' min</span><span class="xm-stat-lbl">Time Limit</span></div>' +
            '    <div class="xm-stat-tile"><span class="xm-stat-num">' + o.scoring.max + '</span><span class="xm-stat-lbl">Max Score</span></div>' +
            '  </div>' +
            '  <p style="font-size:0.85rem; color:var(--ms-muted); max-width:34rem; margin: 0 auto 1rem;">' +
            '    Every session is freshly sampled from a large pool of real past ' +
            escHtml(o.bucket === 'amc-real' ? 'AMC' : 'AIME') + ' problems — take it as many times as you like.' +
            '    Once you start, the timer runs. Submit early or wait for time to expire.' +
            '  </p>' +
                  startSection +
                  renderHistoryBlock() +
            '</div>';
    }

    // mm:ss formatter for cooldown countdown.
    function formatMS(ms) {
        var s = Math.max(0, Math.ceil(ms / 1000));
        var m = Math.floor(s / 60);
        var ss = s % 60;
        return m + ':' + (ss < 10 ? '0' : '') + ss;
    }

    // Render a compact "Your past attempts" block under the Start Test
    // button, sourced from localStorage.  Empty string if no history.
    function renderHistoryBlock() {
        var hist = loadHistory(state.opts.bucket);
        if (!hist.length) return '';
        var max  = state.opts.scoring.max;
        var best = hist.reduce(function (b, h) { return h.points > b ? h.points : b; }, 0);
        var rows = hist.slice(0, 5).map(function (h) {
            var d = new Date(h.ts);
            var date = d.toLocaleDateString(undefined, { month: 'short', day: 'numeric' }) +
                       ' ' + d.toLocaleTimeString(undefined, { hour: '2-digit', minute: '2-digit' });
            var pct = max > 0 ? Math.round(100 * h.points / max) : 0;
            return '<tr>' +
                '<td>' + escHtml(date) + '</td>' +
                '<td>' + h.points + '<span class="xm-hist-denom"> / ' + max + '</span></td>' +
                '<td>' + h.correct + ' ✓ · ' + h.wrong + ' ✗ · ' + h.skipped + ' —</td>' +
                '<td><div class="xm-hist-bar"><div style="width:' + pct + '%"></div></div></td>' +
                '</tr>';
        }).join('');
        return '<div class="xm-history">' +
            '  <div class="xm-history-head">' +
            '    <div>' +
            '      <div class="xm-history-title">Your recent attempts</div>' +
            '      <div class="xm-history-sub">Personal best: ' + best + ' / ' + max + '</div>' +
            '    </div>' +
            '    <button class="xm-btn xm-btn-ghost" id="xm-hist-clear" type="button">Clear history</button>' +
            '  </div>' +
            '  <table>' + rows + '</table>' +
            '</div>';
    }

    function renderRunning() {
        var o = state.opts;
        var q = state.qs[state.cur];
        var qNum = state.cur + 1;
        var total = state.qs.length;
        var pick = state.picks[state.cur];
        var flagged = !!state.flags[state.cur];
        var stripped = q.fmt === 'mcq' ? stripChoiceBlock(q.p) : q.p;

        var body = '';
        if (q.fmt === 'mcq') {
            body = renderMcq(q, pick);
        } else {
            body = renderFree(q, pick, o.freeRange || [0, 999]);
        }

        return '' +
            '<div class="xm-header">' +
            '  <h1 class="xm-header-title">' + escHtml(o.title) + '</h1>' +
            '  <span class="xm-header-meta">Question ' + qNum + ' of ' + total + '</span>' +
            '  <span class="xm-timer" id="xm-timer">--:--</span>' +
            '</div>' +
            '<div class="xm-card" style="margin-top:1rem;">' +
            '  <div class="xm-q-head">' +
            '    <span class="xm-q-num">Q ' + qNum + '</span>' +
            '    <button class="xm-q-flag' + (flagged ? ' flagged' : '') + '" id="xm-flag-btn" type="button">' +
            (flagged ? '&#9873; Flagged' : '&#9872; Flag for review') +
            '    </button>' +
            '  </div>' +
            '  <div class="xm-problem">' + renderMath(stripped) + '</div>' +
                  body +
            '  <div class="xm-nav-row">' +
            '    <button class="xm-btn" id="xm-prev-btn"' + (state.cur === 0 ? ' disabled' : '') + '>&larr; Prev</button>' +
            '    <button class="xm-btn" id="xm-next-btn"' + (state.cur === total - 1 ? ' disabled' : '') + '>Next &rarr;</button>' +
            '    <button class="xm-btn" id="xm-clear-btn" style="margin-left:auto;">Clear answer</button>' +
            '    <button class="xm-btn xm-btn-danger" id="xm-submit-btn">Submit Test</button>' +
            '  </div>' +
            '  <div class="xm-navigator" id="xm-navigator">' + renderNavigator() + '</div>' +
            '  <div class="xm-nav-legend">' +
            '    <span class="lg-current">Current</span>' +
            '    <span class="lg-answered">Answered</span>' +
            '    <span class="lg-flagged">Flagged</span>' +
            '    <span>Blank</span>' +
            '  </div>' +
            '</div>';
    }

    // Render a choice text.  Most AMC choices are pure LaTeX expressions
    // (`\frac{57}{4}`, `2x+1`) without $-delimiters — wrap them in inline
    // math.  But some choices are mixed prose + math (`The value of $X$ is
    // … \begin{array}…`); for those we render as-is so embedded $/$$
    // delimiters parse correctly.
    // Render a short answer string (MCQ letter, AIME integer, or raw LaTeX)
    // safely. Plain letters / digits stay as text; LaTeX commands get KaTeX.
    function renderAnswerInline(a) {
        if (a == null || a === '') return '';
        if (/^[A-E]$/.test(a)) return escHtml(a);
        if (/^-?\d+(?:\.\d+)?$/.test(a)) return escHtml(a);
        // contains a backslash → assume LaTeX
        if (a.indexOf('\\') !== -1) return renderTeX(a, false);
        return escHtml(a);
    }

    function renderChoiceText(txt) {
        if (!txt) return '';
        // Heuristic: choice already contains a $ delimiter OR a display
        // math block → treat as mixed content. Otherwise wrap in $...$.
        if (txt.indexOf('$') !== -1 || /\\begin\{(array|aligned|cases|matrix|pmatrix|bmatrix)\}/.test(txt)) {
            return renderMath(txt);
        }
        return renderMath('$' + txt + '$');
    }

    function renderMcq(q, pick) {
        var letters = (q.chk || 'ABCDE').split('');
        var html = '<div class="xm-choices">';
        for (var i = 0; i < letters.length && i < (q.ch || []).length; i++) {
            var L = letters[i];
            var txt = q.ch[i] || '';
            var selected = (pick === L);
            html += '<label class="xm-choice' + (selected ? ' selected' : '') + '" data-letter="' + L + '">' +
                '<input type="radio" name="xm-mcq" value="' + L + '"' + (selected ? ' checked' : '') + '>' +
                '<span class="xm-choice-letter">(' + L + ')</span>' +
                '<span class="xm-choice-text">' + renderChoiceText(txt) + '</span>' +
                '</label>';
        }
        html += '</div>';
        return html;
    }

    function renderFree(q, pick, range) {
        var lo = range[0], hi = range[1];
        return '<div class="xm-free">' +
            '<label for="xm-free-input">Your answer:</label>' +
            '<input type="number" id="xm-free-input" min="' + lo + '" max="' + hi +
            '" step="1" inputmode="numeric" value="' + (pick != null ? escHtml(pick) : '') + '">' +
            '<span class="xm-free-range">integer ' + lo + '–' + hi + '</span>' +
            '</div>';
    }

    function renderNavigator() {
        var html = '';
        for (var i = 0; i < state.qs.length; i++) {
            var cls = 'xm-nav-pill';
            if (i === state.cur) cls += ' current';
            if (state.picks[i] != null && state.picks[i] !== '') cls += ' answered';
            if (state.flags[i]) cls += ' flagged';
            html += '<button class="' + cls + '" data-idx="' + i + '" type="button">' + (i + 1) + '</button>';
        }
        return html;
    }

    /* ── Results screen ───────────────────────────────────────────────── */

    function renderResults() {
        var o = state.opts;
        var sc = computeScore();
        var tag = scoreTagline(sc);
        return '' +
            '<div class="xm-card xm-results">' +
            '  <div class="xm-results-hero">' +
            '    <div style="font:0.85rem var(--ms-font-mono); color:var(--ms-muted); text-transform:uppercase; letter-spacing:0.08em;">' + escHtml(o.title) + '</div>' +
            '    <div class="xm-score-big">' + sc.points.toFixed(sc.points % 1 === 0 ? 0 : 1) + ' <span class="denom">/ ' + o.scoring.max + '</span></div>' +
            '    <div class="xm-results-tagline">' + escHtml(tag) + '</div>' +
            '    <div class="xm-results-breakdown">' +
            '      <div class="xm-breakdown-tile ok"><span class="xm-breakdown-num">' + sc.correct + '</span><span class="xm-breakdown-lbl">Correct</span></div>' +
            '      <div class="xm-breakdown-tile bad"><span class="xm-breakdown-num">' + sc.wrong + '</span><span class="xm-breakdown-lbl">Wrong</span></div>' +
            '      <div class="xm-breakdown-tile skip"><span class="xm-breakdown-num">' + sc.skipped + '</span><span class="xm-breakdown-lbl">Blank</span></div>' +
            '      <div class="xm-breakdown-tile"><span class="xm-breakdown-num">' + sc.usedTime + '</span><span class="xm-breakdown-lbl">Time used</span></div>' +
            '    </div>' +
            '  </div>' +
            '  <div class="xm-nav-row" style="justify-content:center;">' +
            '    <button class="xm-btn xm-btn-primary" id="xm-retake-btn">Take another test</button>' +
            '    <button class="xm-btn" id="xm-back-btn">Back to math tools</button>' +
            '  </div>' +
            '  <h2 style="margin-top:1.5rem; font:700 1.1rem var(--ms-font-sans);">Review &amp; solutions</h2>' +
            '  <div id="xm-review-list">' + renderReviewList() + '</div>' +
            '</div>';
    }

    function renderReviewList() {
        var html = '';
        for (var i = 0; i < state.qs.length; i++) {
            var q = state.qs[i];
            var pick = state.picks[i];
            var correct = (pick != null && pick !== '' && checkAnswer(q, pick));
            var skipped = (pick == null || pick === '');
            var badgeCls = skipped ? 'skip' : (correct ? 'ok' : 'bad');
            var badgeTxt = skipped ? 'Blank' : (correct ? 'Correct' : 'Wrong');
            // Answer values can be plain letters (MCQ), integers (AIME free),
            // or raw LaTeX expressions (\text{A}, \frac{...}). Render via
            // KaTeX so the latter come out clean instead of literal source.
            var ansLine = 'Your: ' + (skipped ? '—' : renderAnswerInline(String(pick))) +
                          '  ·  Key: ' + renderAnswerInline(String(q.a));
            html += '<div class="xm-review-item" data-idx="' + i + '">' +
                '<div class="xm-review-head">' +
                '  <span class="badge ' + badgeCls + '">' + badgeTxt + '</span>' +
                '  <span class="qnum">Q ' + (i + 1) + '</span>' +
                '  <span class="ans">' + ansLine + '</span>' +
                '</div>' +
                '<div class="xm-review-body">' +
                '  <div class="xm-problem">' + renderMath(q.p) + '</div>' +
                '  <div class="xm-solution-block" data-sol-host="' + i + '">' +
                '    <span class="label">Solution</span>' +
                '    <span class="xm-spinner"></span>Loading solution…' +
                '  </div>' +
                '</div>' +
                '</div>';
        }
        return html;
    }

    /* ──────────────────────────────────────────────────────────────────── */
    /* Score                                                                */
    /* ──────────────────────────────────────────────────────────────────── */

    function checkAnswer(q, pick) {
        if (pick == null || pick === '') return false;
        if (q.fmt === 'mcq') return String(pick).toUpperCase() === String(q.a).toUpperCase();
        // free-response: compare normalized strings
        var a = String(q.a).trim().replace(/^0+(?=\d)/, '');
        var p = String(pick).trim().replace(/^0+(?=\d)/, '');
        return a === p;
    }

    function computeScore() {
        var sc = state.scoring;
        var correct = 0, wrong = 0, skipped = 0;
        for (var i = 0; i < state.qs.length; i++) {
            var pick = state.picks[i];
            if (pick == null || pick === '') skipped++;
            else if (checkAnswer(state.qs[i], pick)) correct++;
            else wrong++;
        }
        var points = correct * sc.correct + wrong * sc.wrong + skipped * sc.unanswered;
        // Cap at max (some configs can exceed max if e.g. all skipped on AMC)
        if (points > sc.max) points = sc.max;
        var used = (state.opts.durationMin * 60) - Math.max(0, Math.floor((state.deadline - Date.now()) / 1000));
        if (used < 0) used = 0;
        if (used > state.opts.durationMin * 60) used = state.opts.durationMin * 60;
        return {
            correct: correct, wrong: wrong, skipped: skipped, points: points,
            usedTime: formatHMS(used)
        };
    }

    function scoreTagline(sc) {
        var max = state.opts.scoring.max;
        var pct = max > 0 ? sc.points / max : 0;
        if (pct >= 0.9)  return 'Outstanding — top-tier mock score.';
        if (pct >= 0.75) return 'Strong showing — competitive range.';
        if (pct >= 0.5)  return 'Solid attempt — review the misses and try again.';
        if (pct >= 0.25) return 'Keep at it — fundamentals come from practice.';
        return 'Plenty of room to grow — try again with a fresh shuffle.';
    }

    /* ──────────────────────────────────────────────────────────────────── */
    /* Timer                                                                */
    /* ──────────────────────────────────────────────────────────────────── */

    function startTimer() {
        state.deadline = Date.now() + state.opts.durationMin * 60 * 1000;
        if (state.timerId) clearInterval(state.timerId);
        state.timerId = setInterval(updateTimerDisplay, 1000);
        updateTimerDisplay();
    }

    function stopTimer() {
        if (state.timerId) { clearInterval(state.timerId); state.timerId = 0; }
    }

    function updateTimerDisplay() {
        var el = document.getElementById('xm-timer');
        if (!el) return;
        var remaining = Math.max(0, Math.floor((state.deadline - Date.now()) / 1000));
        el.textContent = formatHMS(remaining);
        el.classList.remove('warn', 'bad');
        if (remaining <= 60) el.classList.add('bad');
        else if (remaining <= 300) el.classList.add('warn');
        if (remaining <= 0) {
            stopTimer();
            finalizeAndShowResults();
        }
    }

    function formatHMS(s) {
        var h = Math.floor(s / 3600);
        var m = Math.floor((s % 3600) / 60);
        var ss = s % 60;
        function pad(n) { return (n < 10 ? '0' : '') + n; }
        if (h > 0) return h + ':' + pad(m) + ':' + pad(ss);
        return pad(m) + ':' + pad(ss);
    }

    /* ──────────────────────────────────────────────────────────────────── */
    /* Event wiring                                                         */
    /* ──────────────────────────────────────────────────────────────────── */

    function wireHandlers() {
        if (state.phase === 'setup') {
            var s = document.getElementById('xm-start-btn');
            if (s && !s.disabled) s.addEventListener('click', startSession);
            var hc = document.getElementById('xm-hist-clear');
            if (hc) hc.addEventListener('click', function () {
                if (!confirm('Clear all past attempts for this test?')) return;
                clearHistory(state.opts.bucket);
                render();
            });

            // Live cooldown ticker — update countdown + progress bar every
            // second; full re-render once cooldown expires so the disabled
            // button swaps back to an enabled one.
            if (state.cooldownTickId) {
                clearInterval(state.cooldownTickId);
                state.cooldownTickId = 0;
            }
            if (cooldownRemaining(state.opts.bucket) > 0) {
                state.cooldownTickId = setInterval(function () {
                    var rem = cooldownRemaining(state.opts.bucket);
                    if (rem <= 0) {
                        clearInterval(state.cooldownTickId);
                        state.cooldownTickId = 0;
                        if (state.phase === 'setup') render();
                        return;
                    }
                    var t = document.getElementById('xm-cooldown-time');
                    var f = document.getElementById('xm-cooldown-fill');
                    if (t) t.textContent = formatMS(rem);
                    if (f) f.style.width = (100 * (1 - rem / COOLDOWN_MS)).toFixed(1) + '%';
                }, 1000);
            }
        }
        if (state.phase === 'running') {
            wireRunning();
        }
        if (state.phase === 'results') {
            wireResults();
        }
    }

    function wireRunning() {
        var prev = document.getElementById('xm-prev-btn');
        var next = document.getElementById('xm-next-btn');
        var clr  = document.getElementById('xm-clear-btn');
        var sub  = document.getElementById('xm-submit-btn');
        var flg  = document.getElementById('xm-flag-btn');
        if (prev) prev.addEventListener('click', function () { goTo(state.cur - 1); });
        if (next) next.addEventListener('click', function () { goTo(state.cur + 1); });
        if (clr)  clr.addEventListener('click', clearCurrent);
        if (sub)  sub.addEventListener('click', confirmSubmit);
        if (flg)  flg.addEventListener('click', toggleFlag);

        // MCQ choices
        document.querySelectorAll('.xm-choice').forEach(function (el) {
            el.addEventListener('click', function () {
                var letter = el.getAttribute('data-letter');
                state.picks[state.cur] = letter;
                render();
            });
        });

        // Free input
        var inp = document.getElementById('xm-free-input');
        if (inp) {
            inp.addEventListener('input', function () {
                var v = inp.value.trim();
                state.picks[state.cur] = v;
                // Update navigator pill in place, no re-render to keep focus.
                refreshNavigator();
            });
        }

        // Navigator pills
        document.querySelectorAll('.xm-nav-pill').forEach(function (el) {
            el.addEventListener('click', function () {
                var idx = parseInt(el.getAttribute('data-idx'), 10);
                if (!isNaN(idx)) goTo(idx);
            });
        });

        // Keyboard nav
        document.onkeydown = function (e) {
            if (e.target && /input|textarea/i.test(e.target.tagName)) return;
            if (e.key === 'ArrowLeft')  goTo(state.cur - 1);
            else if (e.key === 'ArrowRight') goTo(state.cur + 1);
            else if (state.opts.format === 'mcq' && /^[a-eA-E]$/.test(e.key)) {
                state.picks[state.cur] = e.key.toUpperCase();
                render();
            }
        };
    }

    function wireResults() {
        var rt = document.getElementById('xm-retake-btn');
        var bk = document.getElementById('xm-back-btn');
        if (rt) rt.addEventListener('click', function () {
            reset(state.opts);
            boot();
        });
        if (bk) bk.addEventListener('click', function () {
            window.location.href = (document.querySelector('base') ? '' : '') + '/math/';
        });
        document.querySelectorAll('.xm-review-head').forEach(function (h) {
            h.addEventListener('click', function () {
                var item = h.parentElement;
                var wasOpen = item.classList.contains('open');
                item.classList.toggle('open');
                if (!wasOpen) {
                    var idx = parseInt(item.getAttribute('data-idx'), 10);
                    loadSolutionInto(idx, item.querySelector('[data-sol-host]'));
                }
            });
        });
    }

    function refreshNavigator() {
        var nav = document.getElementById('xm-navigator');
        if (nav) nav.innerHTML = renderNavigator();
        document.querySelectorAll('.xm-nav-pill').forEach(function (el) {
            el.addEventListener('click', function () {
                var idx = parseInt(el.getAttribute('data-idx'), 10);
                if (!isNaN(idx)) goTo(idx);
            });
        });
    }

    function goTo(idx) {
        if (idx < 0 || idx >= state.qs.length) return;
        state.cur = idx;
        render();
    }

    function clearCurrent() {
        delete state.picks[state.cur];
        render();
    }

    function toggleFlag() {
        state.flags[state.cur] = !state.flags[state.cur];
        render();
    }

    /* ──────────────────────────────────────────────────────────────────── */
    /* Submit / finalize                                                    */
    /* ──────────────────────────────────────────────────────────────────── */

    function confirmSubmit() {
        var unanswered = 0;
        for (var i = 0; i < state.qs.length; i++) {
            if (state.picks[i] == null || state.picks[i] === '') unanswered++;
        }
        var msg = unanswered > 0
            ? 'You have ' + unanswered + ' unanswered question' + (unanswered === 1 ? '' : 's') + '. Submit anyway?'
            : 'Submit your test and see results?';
        openModal(msg, 'Submit', function () { finalizeAndShowResults(); });
    }

    function finalizeAndShowResults() {
        stopTimer();
        // Persist the score before opening the share popup so refresh-mid-popup
        // doesn't lose the attempt.
        var sc = computeScore();
        saveResult(state.opts.bucket, {
            ts: Date.now(),
            points: sc.points,
            max: state.opts.scoring.max,
            correct: sc.correct,
            wrong: sc.wrong,
            skipped: sc.skipped,
            usedTime: sc.usedTime,
            title: state.opts.title
        });
        setCooldown(state.opts.bucket);   // gate next attempt by COOLDOWN_MS
        // Open the share popup; results render once it dismisses.
        openShareModal({
            type: 'submit',
            score: sc.points,
            max: state.opts.scoring.max,
            correct: sc.correct,
            wrong: sc.wrong,
            skipped: sc.skipped,
            usedTime: sc.usedTime,
            title: state.opts.title
        }, function () {
            state.phase = 'results';
            render();
        });
    }

    function openModal(message, confirmLabel, onConfirm) {
        var existing = document.getElementById('xm-modal-host');
        if (existing) existing.remove();
        var host = document.createElement('div');
        host.id = 'xm-modal-host';
        host.innerHTML = '' +
            '<div class="xm-modal-backdrop">' +
            '  <div class="xm-modal">' +
            '    <h3>Confirm submission</h3>' +
            '    <p>' + escHtml(message) + '</p>' +
            '    <div class="xm-modal-actions">' +
            '      <button class="xm-btn" id="xm-modal-cancel">Cancel</button>' +
            '      <button class="xm-btn xm-btn-primary" id="xm-modal-ok">' + escHtml(confirmLabel) + '</button>' +
            '    </div>' +
            '  </div>' +
            '</div>';
        document.body.appendChild(host);
        document.getElementById('xm-modal-cancel').addEventListener('click', function () { host.remove(); });
        document.getElementById('xm-modal-ok').addEventListener('click', function () {
            host.remove();
            onConfirm();
        });
    }

    /* ──────────────────────────────────────────────────────────────────── */
    /* Solution lazy-load                                                   */
    /* ──────────────────────────────────────────────────────────────────── */

    var SOLUTION_REVEAL_DELAY = 1500;   // ms — brief pause to keep users on-page
    var SHARE_NUDGE_EVERY     = 3;      // every N-th solution view → share prompt

    function loadSolutionInto(idx, host) {
        if (!host) return;
        if (host.getAttribute('data-loaded') === '1') return;
        if (host.getAttribute('data-loading') === '1') return;
        host.setAttribute('data-loading', '1');

        // Show the "Loading…" state immediately, then reveal after a short
        // delay so users dwell on the review page (boosts CTR / context).
        host.innerHTML =
            '<span class="label">Solution</span>' +
            '<span class="xm-spinner"></span>Loading detailed walkthrough…';

        var q = state.qs[idx];
        var shardName = state.shardName;        // same name in q/ and s/

        var renderAfterDelay = function (sol) {
            setTimeout(function () {
                host.innerHTML =
                    '<span class="label">Solution</span>' +
                    '<div>' + renderMath(sol) + '</div>';
                host.setAttribute('data-loaded', '1');
                host.removeAttribute('data-loading');

                state.solutionClicks = (state.solutionClicks || 0) + 1;
                if (state.solutionClicks > 0 &&
                    state.solutionClicks % SHARE_NUDGE_EVERY === 0 &&
                    !state.shareSuppressed) {
                    openShareModal({ type: 'solution', title: state.opts.title });
                }
            }, SOLUTION_REVEAL_DELAY);
        };

        var doRender = function (sols) {
            var byId = sols.reduce(function (m, x) { m[x.id] = x.sol; return m; }, {});
            renderAfterDelay(byId[q.id] || '(solution unavailable)');
        };
        if (state.solCache[shardName]) {
            doRender(state.solCache[shardName]);
        } else {
            fetchJson(state.opts.dataBase + '/s/' + shardName).then(function (data) {
                state.solCache[shardName] = data;
                doRender(data);
            }).catch(function (e) {
                host.innerHTML = '<span class="label">Solution</span><div class="xm-banner xm-banner-warn">Could not load solution: ' + escHtml(e.message) + '</div>';
                host.removeAttribute('data-loading');
            });
        }
    }

    /* ──────────────────────────────────────────────────────────────────── */
    /* Boot                                                                 */
    /* ──────────────────────────────────────────────────────────────────── */

    function startSession() {
        if (state.cooldownTickId) { clearInterval(state.cooldownTickId); state.cooldownTickId = 0; }
        state.phase = 'running';
        state.cur = 0;
        startTimer();
        render();
    }

    function boot() {
        state.phase = 'loading';
        render();
        loadMeta()
            .then(pickAndLoadShard)
            .then(function () {
                chooseSessionQuestions();
                state.phase = 'setup';
                render();
            })
            .catch(function (e) {
                var root = document.getElementById(state.opts.rootId);
                if (root) {
                    root.innerHTML = '<div class="xm-card"><div class="xm-banner xm-banner-bad">' +
                        'Could not load test data: ' + escHtml(e.message) + '</div></div>';
                }
            });
    }

    ExamEngine.init = function (opts) {
        reset(opts);
        // Wait for KaTeX to be present (loaded by math-libs.jsp).
        if (typeof katex === 'undefined') {
            var tries = 0;
            (function wait() {
                if (typeof katex !== 'undefined' || tries++ > 50) { boot(); return; }
                setTimeout(wait, 100);
            })();
        } else {
            boot();
        }
    };

    global.ExamEngine = ExamEngine;
})(window);
