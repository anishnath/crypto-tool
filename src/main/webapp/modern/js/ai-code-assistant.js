/**
 * AI Code Assistant — reusable chat bar for any code editor tool.
 *
 * Usage:
 *   AICodeAssistant.init({
 *     containerId: 'my-ai-bar',       // where to mount the chat bar
 *     systemPrompt: '...',             // domain-specific system prompt
 *     getCode: function() { ... },     // returns current code from editor
 *     setCode: function(code) { ... }, // injects code into editor
 *     getError: function() { ... },    // optional: returns current error text
 *     onRun: function() { ... },       // optional: trigger run/compile after injection
 *     placeholder: 'Describe what...'  // input placeholder
 *   });
 *
 * The chat bar renders inline (not a modal) and supports:
 *   - Generate from scratch ("create a gear with 20 teeth")
 *   - Modify existing code ("add 4 mounting holes")
 *   - Fix errors ("fix the error" — auto-includes error text)
 *   - Follow-up conversation (keeps last exchange as context)
 *   - Streaming responses with live character count
 *   - Quick-action buttons (customizable)
 */
;(function (win) {
    'use strict';

    var AI_URL = '';
    var instances = {};

    function init(opts) {
        var id = opts.containerId;
        if (!id) return;

        var container = document.getElementById(id);
        if (!container) return;

        // Resolve AI endpoint
        var ctxMeta = document.querySelector('meta[name="ctx"]') || document.querySelector('meta[name="context-path"]');
        AI_URL = (ctxMeta ? ctxMeta.getAttribute('content') : '') + '/ai';

        var state = {
            systemPrompt: opts.systemPrompt || '',
            getCode: opts.getCode || function () { return ''; },
            setCode: opts.setCode || function () {},
            getError: opts.getError || null,
            onRun: opts.onRun || null,
            placeholder: opts.placeholder || 'Ask AI to generate, modify, or fix code\u2026',
            quickActions: opts.quickActions || [],
            busy: false,
            lastUserMsg: '',
            lastAiCode: ''
        };

        instances[id] = state;

        // Build UI
        container.innerHTML = buildHTML(id, state);
        wireEvents(id, state, container);
    }

    function buildHTML(id, state) {
        var quickBtns = '';
        if (state.quickActions.length > 0) {
            quickBtns = '<div class="ai-ca-quick">';
            state.quickActions.forEach(function (a, i) {
                quickBtns += '<button class="ai-ca-quick-btn" data-ai-quick="' + i + '">' + esc(a.label) + '</button>';
            });
            quickBtns += '</div>';
        }

        return '<div class="ai-ca-bar">' +
            quickBtns +
            '<div class="ai-ca-input-row">' +
            '  <input type="text" class="ai-ca-input" id="' + id + '-input" placeholder="' + esc(state.placeholder) + '" autocomplete="off" />' +
            '  <button class="ai-ca-send" id="' + id + '-send" title="Send to AI" disabled>' +
            '    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 2L11 13"/><path d="M22 2L15 22L11 13L2 9L22 2Z"/></svg>' +
            '  </button>' +
            '</div>' +
            '<div class="ai-ca-status" id="' + id + '-status"></div>' +
            '</div>';
    }

    function wireEvents(id, state, container) {
        var input = document.getElementById(id + '-input');
        var sendBtn = document.getElementById(id + '-send');
        var statusEl = document.getElementById(id + '-status');

        // Enable send when input has text
        input.addEventListener('input', function () {
            sendBtn.disabled = !input.value.trim();
        });

        // Send on Enter
        input.addEventListener('keydown', function (e) {
            if (e.key === 'Enter' && !e.shiftKey && !sendBtn.disabled && !state.busy) {
                e.preventDefault();
                doSend();
            }
        });

        sendBtn.addEventListener('click', function () {
            if (!state.busy) doSend();
        });

        // Quick action buttons
        container.querySelectorAll('.ai-ca-quick-btn').forEach(function (btn) {
            btn.addEventListener('click', function () {
                var idx = parseInt(this.getAttribute('data-ai-quick'));
                var action = state.quickActions[idx];
                if (!action) return;

                if (action.prompt) {
                    input.value = action.prompt;
                    sendBtn.disabled = false;
                    doSend();
                } else if (action.action === 'fix-error') {
                    var err = state.getError ? state.getError() : '';
                    input.value = err ? 'Fix this error: ' + err : 'Fix any errors in the code';
                    sendBtn.disabled = false;
                    doSend();
                }
            });
        });

        function doSend() {
            var userMsg = input.value.trim();
            if (!userMsg || state.busy) return;

            state.busy = true;
            state.lastUserMsg = userMsg;
            sendBtn.disabled = true;
            input.disabled = true;
            statusEl.className = 'ai-ca-status loading';
            statusEl.textContent = 'AI is thinking\u2026';

            var currentCode = state.getCode();
            var errorText = state.getError ? state.getError() : '';

            // Build messages
            var messages = [
                { role: 'system', content: state.systemPrompt }
            ];

            // Include current code as context
            if (currentCode && currentCode.trim()) {
                messages.push({
                    role: 'user',
                    content: 'Here is the current code:\n```\n' + currentCode + '\n```'
                });
                messages.push({
                    role: 'assistant',
                    content: 'I see the current code. What would you like me to do?'
                });
            }

            // Include error if user is asking to fix
            var prompt = userMsg;
            if (errorText && /fix|error|bug|broken|wrong|fail/i.test(userMsg)) {
                prompt += '\n\nThe current error is:\n' + errorText;
            }

            messages.push({ role: 'user', content: prompt });

            // Stream request
            fetch(AI_URL, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ messages: messages, stream: true })
            })
            .then(function (res) {
                if (!res.ok) return res.json().then(function (d) { throw new Error(d.error || 'AI failed'); });

                var reader = res.body.getReader();
                var decoder = new TextDecoder();
                var buffer = '';
                var fullResponse = '';

                function processChunk(result) {
                    if (result.done) {
                        finishResponse(fullResponse);
                        return;
                    }
                    buffer += decoder.decode(result.value, { stream: true });
                    var lines = buffer.split('\n');
                    buffer = lines.pop();

                    for (var i = 0; i < lines.length; i++) {
                        var line = lines[i].trim();
                        if (!line) continue;
                        try {
                            var obj = JSON.parse(line);
                            if (obj.message && obj.message.content) {
                                fullResponse += obj.message.content;
                            }
                            if (obj.done === true) {
                                finishResponse(fullResponse);
                                return;
                            }
                        } catch (e) { /* skip */ }
                    }

                    statusEl.textContent = 'Writing\u2026 (' + fullResponse.length + ' chars)';
                    return reader.read().then(processChunk);
                }

                return reader.read().then(processChunk);
            })
            .catch(function (err) {
                statusEl.className = 'ai-ca-status error';
                statusEl.textContent = err.message;
                state.busy = false;
                sendBtn.disabled = false;
                input.disabled = false;
            });

            function finishResponse(text) {
                // Strip markdown fences and think tags
                text = text.replace(/<think>[\s\S]*?<\/think>/g, '');
                var code = text.replace(/^```(?:javascript|js|jscad)?\n?/gm, '').replace(/```\s*$/gm, '').trim();

                // Check if response looks like code (has require/const/function/return)
                var isCode = /(?:require|const |let |var |function |module\.exports|main\s*[=(])/.test(code);

                if (isCode) {
                    state.lastAiCode = code;
                    var injected = false;

                    // Try primary injection (editor open)
                    try {
                        var currentCode = state.getCode();
                        // If getCode returns empty or same default, editor might be closed
                        state.setCode(code);
                        var afterSet = state.getCode();
                        injected = afterSet && afterSet.indexOf(code.substring(0, 40)) !== -1;
                    } catch (e) { injected = false; }

                    if (injected) {
                        if (state.onRun) setTimeout(function () { state.onRun(); }, 300);
                        statusEl.className = 'ai-ca-status success';
                        statusEl.textContent = 'Code updated and running!';
                    } else {
                        // Editor closed — use fallback loader if available
                        if (state.fallbackLoad) {
                            state.fallbackLoad(code);
                            statusEl.className = 'ai-ca-status success';
                            statusEl.textContent = 'Code generated and loaded!';
                        } else {
                            statusEl.className = 'ai-ca-status info';
                            statusEl.innerHTML = 'Code ready — open the editor to see it. <button class="ai-ca-quick-btn" id="' + id + '-copy">Copy code</button>';
                            var copyBtn = document.getElementById(id + '-copy');
                            if (copyBtn) {
                                copyBtn.addEventListener('click', function () {
                                    navigator.clipboard.writeText(state.lastAiCode).then(function () {
                                        copyBtn.textContent = 'Copied!';
                                    });
                                });
                            }
                        }
                    }
                } else {
                    // AI responded with explanation, not code — show it
                    statusEl.className = 'ai-ca-status info';
                    statusEl.innerHTML = '<div class="ai-ca-response">' + escHtml(text) + '</div>';
                }

                state.busy = false;
                sendBtn.disabled = false;
                input.disabled = false;
                input.value = '';
                input.focus();

                // Clear status after delay
                if (isCode) {
                    setTimeout(function () {
                        if (statusEl.className.indexOf('success') !== -1) {
                            statusEl.className = 'ai-ca-status';
                            statusEl.textContent = '';
                        }
                    }, 4000);
                }
            }
        }
    }

    function esc(s) { return String(s || '').replace(/"/g, '&quot;').replace(/</g, '&lt;'); }
    function escHtml(s) {
        return String(s || '').replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
            .replace(/\n/g, '<br>').replace(/`([^`]+)`/g, '<code>$1</code>');
    }

    win.AICodeAssistant = { init: init };

})(window);
