/**
 * ai-assistant.js — AI assistant for the Math/Document Editor
 *
 * Features:
 *   - AI Write: generate content from description (inserts paragraphs)
 *   - AI Continue: continue writing from context
 *   - AI Rewrite: rewrite selection (formal, concise, expand, fix grammar)
 *   - AI Summarize: condense selected text
 *   - AI Translate: translate selection to another language
 *   - AI Explain Equation: explain a math equation in plain English
 *   - AI Solve Step-by-Step: show worked solution
 *   - AI Generate Problems: create practice problems
 *   - AI Fix Code Error: fix code block errors
 *   - AI Explain Code: explain code block
 *
 * Uses the generic /ai proxy endpoint (AIProxyServlet → Ollama).
 * Results are inserted as TipTap content (paragraphs, headings, math nodes).
 */
(function () {
    'use strict';

    var AI_URL = (window.ME_CTX || '') + '/ai';
    var AI_TIMEOUT_MS = 120000;
    var abortCtrl = null;
    var busy = false;

    // ══════════════════════════════════════════════
    // SYSTEM PROMPTS
    // ══════════════════════════════════════════════

    var SYS_WRITE = 'You are an AI assistant inside a document editor that supports rich text and LaTeX math. '
        + 'The user tells you what they need. Determine the right response: '
        + '- If they want content written: write clear, well-structured text. '
        + '- If they want practice problems: generate numbered problems with equations. Do NOT include solutions or answers unless the user explicitly asks for them. Problems only. '
        + '- If they want an explanation: explain clearly with examples. '
        + '- If they want a proof: write a formal mathematical proof. '
        + '- If they want code: provide the code as plain text. '
        + '\n\nFORMATTING RULES (CRITICAL — the editor does NOT support markdown):\n'
        + '- Do NOT use markdown: no #, no **, no *, no -, no ```, no >.\n'
        + '- For math equations: use $...$ for INLINE math and $$...$$ for DISPLAY math.\n'
        + '- INLINE math ($...$): use for variables, short expressions, or math WITHIN a sentence. Examples: "where $x = 5$", "the derivative $f\'(x)$", "for all $n \\geq 1$".\n'
        + '- DISPLAY math ($$...$$): use for standalone equations, multi-line derivations, systems, matrices, or any equation that should appear centered on its own line. Examples: $$\\int_0^1 x^2 dx = \\frac{1}{3}$$, $$\\begin{cases} x + y = 5 \\\\ 2x - y = 1 \\end{cases}$$.\n'
        + '- NEVER put display math ($$) inside a sentence. NEVER put a standalone equation as inline ($).\n'
        + '- For lists: use plain "1." "2." "3." numbering or "a)" "b)" lettering. Do NOT use "- " or "* " bullets.\n'
        + '- For emphasis: just write naturally. Do not wrap words in ** or *.\n'
        + '- Separate sections with blank lines. Use plain text labels like "Solution:" or "Step 1:" instead of headings.\n'
        + '- Write directly — no meta-commentary like "Here is..." or "Sure, I\'ll write...".';

    var SYS_CONTINUE = 'You are a writing assistant. Continue the document naturally from where it left off. '
        + 'Match the tone, style, and topic of the existing content. '
        + 'Do NOT use markdown formatting (no #, no **, no *, no -, no ```). '
        + 'Use $...$ for inline math (within sentences) and $$...$$ for display math (standalone equations, on their own line). Never put $$...$$ inside a sentence. '
        + 'Write 2-3 paragraphs. No meta-commentary.';

    var NO_MD = ' Do NOT use markdown formatting (no #, no **, no *, no -, no ```, no >). Use $...$ for inline math (within a sentence) and $$...$$ for display math (standalone on its own line). Never put $$...$$ inside a sentence.';

    var SYS_REWRITE = {
        formal: 'Rewrite the following text in formal academic English. '
            + 'Keep all LaTeX math ($...$, $$...$$) intact. Only change the natural language. Return ONLY the rewritten text.' + NO_MD,
        concise: 'Make the following text more concise and direct. Remove unnecessary words. '
            + 'Keep all LaTeX math intact. Return ONLY the rewritten text.' + NO_MD,
        expand: 'Expand the following text with more detail, examples, and explanation. '
            + 'Keep all LaTeX math intact. Return ONLY the expanded text.' + NO_MD,
        grammar: 'Fix all grammar, spelling, and punctuation errors in the following text. '
            + 'Keep all LaTeX math ($...$, $$...$$) exactly as-is. Only fix natural language errors. Return ONLY the corrected text.' + NO_MD
    };

    var SYS_SUMMARIZE = 'Summarize the following text into a concise paragraph. '
        + 'Preserve any key math equations (in LaTeX $...$). Return ONLY the summary.' + NO_MD;

    var SYS_TRANSLATE = 'Translate the following text to {LANG}. '
        + 'Keep all LaTeX math ($...$, $$...$$) exactly as-is. Only translate the natural language. Return ONLY the translation.' + NO_MD;

    var SYS_EXPLAIN_EQUATION = 'You are a math teacher. Explain the following LaTeX equation in plain English. '
        + 'Describe what it represents, what each variable/term means, and when it is used. '
        + 'Keep it concise — 2-3 short paragraphs. Use $...$ for inline math references.' + NO_MD;

    var SYS_SOLVE_STEPS = 'You are a math tutor. Solve the following equation step by step. '
        + 'Show each intermediate step clearly. Use $$...$$ for standalone display equations (each step on its own line). Use $...$ for inline math references within sentences. '
        + 'Label each step as "Step 1:", "Step 2:", etc. Separate steps with blank lines.' + NO_MD;

    var SYS_GENERATE_PROBLEMS = 'You are a math teacher. Generate practice problems based on the user request. '
        + 'Number each problem as "1)", "2)", "3)". '
        + 'Use $...$ for inline math (variables, short expressions within a sentence like "where $x > 0$"). '
        + 'Use $$...$$ for display math (standalone equations, systems, matrices — each on its own line). '
        + 'Never put $$...$$ inside a sentence. Never use $...$ for a standalone equation. '
        + 'IMPORTANT: Do NOT include solutions, answers, or hints unless the user explicitly asks for them. Generate ONLY the problem statements. '
        + 'If the user asks for solutions, include them after all problems under a "Solutions" label.' + NO_MD;

    var SYS_FIX_CODE = 'You are a programming expert. The user\'s code produced an error. '
        + 'Fix the code and return ONLY the corrected code. No markdown fences. No explanation.';

    var SYS_EXPLAIN_CODE = 'You are a programming teacher. Explain the following code clearly. '
        + 'Describe what it does, the algorithm used, and any notable patterns. '
        + 'Keep it concise — 2-3 paragraphs.' + NO_MD;

    // ══════════════════════════════════════════════
    // CORE: request + stream
    // ══════════════════════════════════════════════

    function request(systemPrompt, userContent, callback) {
        if (busy) { showToast('AI is busy'); return; }
        busy = true;

        if (abortCtrl) abortCtrl.abort();
        abortCtrl = new AbortController();
        var timeoutId = setTimeout(function () { abortCtrl.abort(); callback('Request timed out', null); }, AI_TIMEOUT_MS);

        fetch(AI_URL, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                messages: [
                    { role: 'system', content: systemPrompt },
                    { role: 'user', content: userContent }
                ],
                stream: false
            }),
            signal: abortCtrl.signal
        })
        .then(function (res) {
            if (!res.ok) return res.json().then(function (d) { throw new Error(d.error || 'Failed'); });
            return res.json();
        })
        .then(function (data) {
            clearTimeout(timeoutId);
            busy = false;
            var content = (data.message && data.message.content) ? data.message.content : '';
            callback(null, stripThinkTags(content));
        })
        .catch(function (err) {
            clearTimeout(timeoutId);
            busy = false;
            if (err.name === 'AbortError') return;
            callback(err.message || 'AI request failed', null);
        });
    }

    function streamToCallback(systemPrompt, userContent, onToken, onDone, onError) {
        if (busy) { showToast('AI is busy'); return; }
        busy = true;

        if (abortCtrl) abortCtrl.abort();
        abortCtrl = new AbortController();
        var timeoutId = setTimeout(function () { abortCtrl.abort(); onError('Request timed out'); }, AI_TIMEOUT_MS);

        fetch(AI_URL, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                messages: [
                    { role: 'system', content: systemPrompt },
                    { role: 'user', content: userContent }
                ],
                stream: true
            }),
            signal: abortCtrl.signal
        })
        .then(function (res) {
            if (!res.ok) return res.json().then(function (d) { throw new Error(d.error || 'Failed'); });
            var reader = res.body.getReader();
            var decoder = new TextDecoder();
            var buffer = '';

            function processChunk(result) {
                if (result.done) return;
                buffer += decoder.decode(result.value, { stream: true });
                var lines = buffer.split('\n');
                buffer = lines.pop();
                for (var i = 0; i < lines.length; i++) {
                    var line = lines[i].trim();
                    if (!line) continue;
                    try {
                        var obj = JSON.parse(line);
                        if (obj.message && obj.message.content) onToken(obj.message.content);
                        if (obj.done === true) return;
                    } catch (e) { /* skip */ }
                }
                return reader.read().then(processChunk);
            }
            return reader.read().then(processChunk);
        })
        .then(function () { clearTimeout(timeoutId); busy = false; onDone(); })
        .catch(function (err) {
            clearTimeout(timeoutId); busy = false;
            if (err.name === 'AbortError') return;
            onError(err.message || 'AI request failed');
        });
    }

    // ══════════════════════════════════════════════
    // HELPERS: TipTap content insertion
    // ══════════════════════════════════════════════

    // Strip Qwen <think>...</think> reasoning blocks from AI output
    function stripThinkTags(text) {
        if (!text) return text;
        // Remove closed <think>...</think> blocks
        var cleaned = text.replace(/<think>[\s\S]*?<\/think>/g, '');
        // If an unclosed <think> remains (still streaming), hide everything after it
        var openIdx = cleaned.indexOf('<think>');
        if (openIdx !== -1) cleaned = cleaned.substring(0, openIdx);
        return cleaned.trim();
    }

    function getEditor() { return window.MeEditor; }

    function getSelectedText() {
        var editor = getEditor();
        if (!editor) return '';
        var { from, to } = editor.state.selection;
        return editor.state.doc.textBetween(from, to, '\n');
    }

    function getDocContext(charLimit) {
        var editor = getEditor();
        if (!editor) return '';
        var text = editor.state.doc.textContent;
        return text.substring(Math.max(0, text.length - (charLimit || 2000)));
    }

    function insertContentAtCursor(markdown) {
        var editor = getEditor();
        if (!editor) return;
        // Convert markdown-style content to TipTap-insertable text
        // TipTap handles plain text insertion; for rich content we use insertContent
        editor.chain().focus().insertContent(markdownToTiptap(markdown)).run();
    }

    function replaceSelection(text) {
        var editor = getEditor();
        if (!editor) return;
        text = stripThinkTags(text);
        var { from, to } = editor.state.selection;
        // Delete selection first, then use insertAIContent to parse math nodes
        editor.chain().focus().deleteRange({ from: from, to: to }).run();
        insertAIContent(text);
    }

    /**
     * Convert simple markdown to TipTap-compatible content.
     * Handles: paragraphs, $$...$$ display math, $...$ inline math, **bold**, *italic*
     */
    function markdownToTiptap(md) {
        if (!md) return '';
        // For now, insert as plain text — TipTap will handle line breaks
        // Math equations in $..$ or $$...$$ will need to be manually inserted
        // TODO: parse markdown blocks and create proper TipTap nodes
        return md;
    }

    // ── Streaming progress overlay ──
    // Instead of fighting ProseMirror's DOM, show a floating preview
    // that updates with streaming tokens, then insert via TipTap API at the end.

    var streamOverlay = null;

    function showStreamOverlay() {
        if (!streamOverlay) {
            streamOverlay = document.createElement('div');
            streamOverlay.className = 'me-ai-stream-overlay';
            streamOverlay.innerHTML =
                '<div class="me-ai-stream-header">' +
                '  <span>&#10024; AI generating...</span>' +
                '  <button onclick="MeAI.cancel()" class="me-ai-stream-cancel">Cancel</button>' +
                '</div>' +
                '<div class="me-ai-stream-body" id="meAiStreamBody"></div>';
            document.body.appendChild(streamOverlay);
        }
        document.getElementById('meAiStreamBody').textContent = '';
        streamOverlay.style.display = '';
    }

    function updateStreamOverlay(text) {
        var body = document.getElementById('meAiStreamBody');
        if (body) {
            body.textContent = stripThinkTags(text);
            body.scrollTop = body.scrollHeight;
        }
    }

    function hideStreamOverlay() {
        if (streamOverlay) streamOverlay.style.display = 'none';
    }

    /**
     * Insert AI response into TipTap editor as proper nodes.
     * Handles: $$...$$ → mathBlock nodes, $...$ → mathInline nodes,
     * plain text → paragraph nodes. No markdown parsing needed since
     * we instructed the AI to avoid markdown.
     */
    function insertAIContent(text) {
        var editor = getEditor();
        if (!editor) return;
        text = stripThinkTags(text);
        if (!text || !text.trim()) return;

        var content = [];

        // Split into blocks by double newline
        var blocks = text.split(/\n\n+/);

        for (var i = 0; i < blocks.length; i++) {
            var block = blocks[i].trim();
            if (!block) continue;

            // Check if block contains any $$...$$ (display math)
            if (/\$\$[\s\S]+?\$\$/.test(block)) {
                // Split the block around $$...$$ patterns. This handles:
                //   "text before $$ latex $$ text after"
                //   "$$ latex $$"  (pure display math)
                //   "text $$ latex1 $$ middle $$ latex2 $$ tail"
                var segments = block.split(/(\$\$[\s\S]+?\$\$)/);
                for (var s = 0; s < segments.length; s++) {
                    var seg = segments[s].trim();
                    if (!seg) continue;

                    var dmMatch = seg.match(/^\$\$([\s\S]+?)\$\$$/);
                    if (dmMatch) {
                        // This segment is a display math block
                        content.push({
                            type: 'mathBlock',
                            attrs: { latex: dmMatch[1].trim() }
                        });
                    } else {
                        // Text segment (may contain inline $...$)
                        var inlineContent = parseInlineMath(seg);
                        if (inlineContent.length) {
                            content.push({
                                type: 'paragraph',
                                content: inlineContent
                            });
                        }
                    }
                }
                continue;
            }

            // No display math — paragraph with possible inline math $...$
            var inlineContent = parseInlineMath(block);
            content.push({
                type: 'paragraph',
                content: inlineContent
            });
        }

        if (content.length > 0) {
            editor.chain().focus().insertContent(content).run();
        }
    }

    /**
     * Parse a text block for inline math $...$ and return TipTap content array.
     * Produces text nodes and mathInline nodes.
     */
    function parseInlineMath(text) {
        var parts = [];
        // Match $...$ but not $$...$$ (negative lookahead/lookbehind)
        var re = /(?<!\$)\$(?!\$)([^$]+?)\$(?!\$)/g;
        var lastIndex = 0;
        var match;

        while ((match = re.exec(text)) !== null) {
            // Text before the math
            if (match.index > lastIndex) {
                parts.push({ type: 'text', text: text.substring(lastIndex, match.index) });
            }
            // Inline math node
            parts.push({
                type: 'mathInline',
                attrs: { latex: match[1] }
            });
            lastIndex = match.index + match[0].length;
        }

        // Remaining text
        if (lastIndex < text.length) {
            parts.push({ type: 'text', text: text.substring(lastIndex) });
        }

        if (parts.length === 0 && text.trim()) {
            parts.push({ type: 'text', text: text });
        }

        return parts;
    }

    function showToast(msg, duration) {
        if (window.MeCompute && window.MeCompute.showToast) {
            window.MeCompute.showToast(msg, duration || 3000);
        }
    }

    // ══════════════════════════════════════════════
    // AI ACTIONS
    // ══════════════════════════════════════════════

    /** AI Write — generate content from description (streaming) */
    function aiWrite(description) {
        if (!description) {
            description = prompt('What should AI write?');
            if (!description) return;
        }
        showStreamOverlay();
        var accumulated = '';
        streamToCallback(SYS_WRITE, description,
            function (token) { accumulated += token; updateStreamOverlay(accumulated); },
            function () { hideStreamOverlay(); insertAIContent(accumulated); showToast('AI content inserted'); },
            function (err) { hideStreamOverlay(); showToast('AI error: ' + err, 5000); }
        );
    }

    /** AI Continue — continue from existing content (streaming) */
    function aiContinue() {
        var context = getDocContext(2000);
        if (!context.trim()) { showToast('Document is empty'); return; }
        showStreamOverlay();
        var accumulated = '';
        streamToCallback(SYS_CONTINUE, 'Continue from this context:\n\n' + context,
            function (token) { accumulated += token; updateStreamOverlay(accumulated); },
            function () { hideStreamOverlay(); insertAIContent(accumulated); showToast('AI content inserted'); },
            function (err) { hideStreamOverlay(); showToast('AI error: ' + err, 5000); }
        );
    }

    /** AI Rewrite — rewrite selected text */
    function aiRewrite(style) {
        var sel = getSelectedText();
        if (!sel.trim()) { showToast('Select text to rewrite'); return; }
        var sys = SYS_REWRITE[style] || SYS_REWRITE.formal;
        showToast('AI rewriting (' + style + ')...');
        request(sys, sel, function (err, result) {
            if (err) { showToast('AI error: ' + err, 5000); return; }
            replaceSelection(result);
            showToast('AI rewrite applied');
        });
    }

    /** AI Summarize — condense selected text */
    function aiSummarize() {
        var sel = getSelectedText();
        if (!sel.trim()) { showToast('Select text to summarize'); return; }
        showToast('AI summarizing...');
        request(SYS_SUMMARIZE, sel, function (err, result) {
            if (err) { showToast('AI error: ' + err, 5000); return; }
            insertAIContent(result);
            showToast('AI summary inserted');
        });
    }

    /** AI Translate — translate selected text */
    function aiTranslate(lang) {
        if (!lang) {
            lang = prompt('Translate to which language?', 'Spanish');
            if (!lang) return;
        }
        var sel = getSelectedText();
        if (!sel.trim()) { showToast('Select text to translate'); return; }
        var sys = SYS_TRANSLATE.replace('{LANG}', lang);
        showToast('AI translating to ' + lang + '...');
        request(sys, sel, function (err, result) {
            if (err) { showToast('AI error: ' + err, 5000); return; }
            insertAIContent(result);
            showToast('AI translation inserted');
        });
    }

    /** AI Explain Equation — explain LaTeX math (streaming) */
    function aiExplainEquation(latex) {
        if (!latex) { showToast('No equation to explain'); return; }
        showStreamOverlay();
        var accumulated = '';
        streamToCallback(SYS_EXPLAIN_EQUATION, latex,
            function (token) { accumulated += token; updateStreamOverlay(accumulated); },
            function () { hideStreamOverlay(); insertAIContent(accumulated); showToast('AI explanation inserted'); },
            function (err) { hideStreamOverlay(); showToast('AI error: ' + err, 5000); }
        );
    }

    /** AI Solve Step-by-Step (streaming) */
    function aiSolveSteps(latex) {
        if (!latex) { showToast('No equation to solve'); return; }
        showStreamOverlay();
        var accumulated = '';
        streamToCallback(SYS_SOLVE_STEPS, 'Solve: ' + latex,
            function (token) { accumulated += token; updateStreamOverlay(accumulated); },
            function () { hideStreamOverlay(); insertAIContent(accumulated); showToast('AI solution inserted'); },
            function (err) { hideStreamOverlay(); showToast('AI error: ' + err, 5000); }
        );
    }

    /** AI Generate Practice Problems (streaming) */
    function aiGenerateProblems(topic) {
        if (!topic) {
            topic = prompt('What type of problems? (e.g. "integration by parts", "quadratic equations")');
            if (!topic) return;
        }
        showStreamOverlay();
        var accumulated = '';
        streamToCallback(SYS_GENERATE_PROBLEMS, topic,
            function (token) { accumulated += token; updateStreamOverlay(accumulated); },
            function () { hideStreamOverlay(); insertAIContent(accumulated); showToast('AI problems inserted'); },
            function (err) { hideStreamOverlay(); showToast('AI error: ' + err, 5000); }
        );
    }

    /** AI Fix Code Error */
    function aiFixCode(code, error, language, onResult) {
        if (!code) { showToast('No code to fix'); return; }
        showToast('AI fixing code...');
        var userContent = 'Language: ' + (language || 'unknown') + '\n\nError:\n' + (error || 'unknown') + '\n\nCode:\n' + code;
        request(SYS_FIX_CODE, userContent, function (err, result) {
            if (err) { showToast('AI error: ' + err, 5000); return; }
            // Clean markdown fences
            result = result.replace(/^```[a-zA-Z]*\s*\n?/i, '').replace(/\n?```\s*$/i, '').trim();
            showToast('AI fix ready');
            if (typeof onResult === 'function') onResult(result);
        });
    }

    /** AI Explain Code */
    function aiExplainCode(code, language) {
        if (!code) { showToast('No code to explain'); return; }
        showToast('AI explaining code...');
        var userContent = 'Language: ' + (language || 'unknown') + '\n\nCode:\n' + code;
        request(SYS_EXPLAIN_CODE, userContent, function (err, result) {
            if (err) { showToast('AI error: ' + err, 5000); return; }
            insertAIContent(result);
            showToast('AI explanation inserted');
        });
    }

    /** Cancel any in-progress AI request */
    function cancel() {
        if (abortCtrl) { abortCtrl.abort(); abortCtrl = null; }
        busy = false;
        showToast('AI cancelled');
    }

    // ══════════════════════════════════════════════
    // AI PROMPT MODAL
    // ══════════════════════════════════════════════

    function showPrompt() {
        var modal = document.getElementById('meAiModal');
        if (!modal) {
            modal = document.createElement('div');
            modal.id = 'meAiModal';
            modal.className = 'me-ai-modal-overlay';
            modal.innerHTML =
                '<div class="me-ai-modal">' +
                '  <div class="me-ai-modal-header">' +
                '    <span>&#10024; AI Assistant</span>' +
                '    <button class="me-ai-modal-close" onclick="MeAI.hidePrompt()">&times;</button>' +
                '  </div>' +
                '  <div class="me-ai-modal-body">' +
                '    <textarea id="meAiInput" class="me-ai-input" rows="3" placeholder="Tell AI what you need...\ne.g. &quot;5 integration practice problems&quot; or &quot;explain the chain rule&quot; or &quot;write an intro about neural networks&quot;"></textarea>' +
                '    <div class="me-ai-actions">' +
                '      <button class="me-ai-action-btn" onclick="MeAI.write(document.getElementById(\'meAiInput\').value); MeAI.hidePrompt();">&#10024; Go</button>' +
                '      <button class="me-ai-action-btn secondary" onclick="MeAI.hidePrompt();">Cancel</button>' +
                '    </div>' +
                '    <div class="me-ai-hint">Enter to go &middot; Esc to close &middot; Or type /ai in the editor</div>' +
                '  </div>' +
                '</div>';
            modal.addEventListener('click', function (e) { if (e.target === modal) hidePrompt(); });
            document.body.appendChild(modal);

            document.getElementById('meAiInput').addEventListener('keydown', function (e) {
                if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault();
                    var val = this.value.trim();
                    if (val) { aiWrite(val); hidePrompt(); }
                }
                if (e.key === 'Escape') hidePrompt();
            });
        }
        modal.style.display = 'flex';
        var input = document.getElementById('meAiInput');
        if (input) { input.value = ''; input.focus(); }
    }

    function hidePrompt() {
        var modal = document.getElementById('meAiModal');
        if (modal) modal.style.display = 'none';
        var editor = getEditor();
        if (editor) editor.commands.focus();
    }

    // ══════════════════════════════════════════════
    // AI SELECTION POPUP (appears when text is selected)
    // ══════════════════════════════════════════════

    var selPopup = null;

    function showSelectionPopup() {
        var sel = window.getSelection();
        if (!sel || !sel.rangeCount || sel.isCollapsed) { hideSelectionPopup(); return; }
        var text = getSelectedText();
        if (!text || text.trim().length < 5) { hideSelectionPopup(); return; }

        if (!selPopup) {
            selPopup = document.createElement('div');
            selPopup.className = 'me-ai-sel-popup';
            selPopup.innerHTML =
                '<button onclick="MeAI.rewrite(\'formal\')" title="Formal">&#127891; Formal</button>' +
                '<button onclick="MeAI.rewrite(\'concise\')" title="Concise">&#9986; Concise</button>' +
                '<button onclick="MeAI.rewrite(\'expand\')" title="Expand">&#128214; Expand</button>' +
                '<button onclick="MeAI.rewrite(\'grammar\')" title="Fix Grammar">&#9998; Grammar</button>' +
                '<button onclick="MeAI.summarize()" title="Summarize">&#128221; Sum</button>' +
                '<button onclick="MeAI.translate()" title="Translate">&#127760; Translate</button>';
            document.body.appendChild(selPopup);
        }

        var rect = sel.getRangeAt(0).getBoundingClientRect();
        selPopup.style.display = 'flex';
        selPopup.style.top = (rect.top - 40) + 'px';
        selPopup.style.left = Math.max(8, rect.left + (rect.width / 2) - 150) + 'px';
    }

    function hideSelectionPopup() {
        if (selPopup) selPopup.style.display = 'none';
    }

    // Listen for selection changes in the editor
    document.addEventListener('me:editor-ready', function () {
        document.addEventListener('selectionchange', function () {
            // Small delay to let selection settle
            setTimeout(function () {
                var active = document.activeElement;
                var canvas = document.querySelector('.me-canvas');
                if (canvas && canvas.contains(active)) {
                    showSelectionPopup();
                } else {
                    hideSelectionPopup();
                }
            }, 200);
        });
    });

    // Hide on click outside
    document.addEventListener('mousedown', function (e) {
        if (selPopup && !selPopup.contains(e.target)) {
            hideSelectionPopup();
        }
    });

    // Keyboard shortcut: Ctrl+Shift+A
    document.addEventListener('keydown', function (e) {
        if ((e.ctrlKey || e.metaKey) && e.shiftKey && (e.key === 'A' || e.key === 'a')) {
            e.preventDefault();
            showPrompt();
        }
        if (e.key === 'Escape' && busy) {
            cancel();
        }
    });

    // ══════════════════════════════════════════════
    // EXPOSE GLOBAL API
    // ══════════════════════════════════════════════

    window.MeAI = {
        write: aiWrite,
        continue: aiContinue,
        rewrite: aiRewrite,
        summarize: aiSummarize,
        translate: aiTranslate,
        explainEquation: aiExplainEquation,
        solveSteps: aiSolveSteps,
        generateProblems: aiGenerateProblems,
        fixCode: aiFixCode,
        explainCode: aiExplainCode,
        cancel: cancel,
        showPrompt: showPrompt,
        hidePrompt: hidePrompt,
        isBusy: function () { return busy; }
    };

})();
