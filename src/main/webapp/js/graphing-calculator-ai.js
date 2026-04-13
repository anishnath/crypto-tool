/**
 * graphing-calculator-ai.js
 *
 * AI integration for the Graphing Calculator.
 *
 * Chemistry-firewall principle: AI only produces strings (expressions + types).
 * All math (plotting, evaluation, derivatives, zeros, asymptotes, extrema) is
 * computed by the existing engine (Math.js, Nerdamer, Plotly).
 *
 * Features:
 *   - Plot from English        : "heart shape" → parametric expression
 *   - Homework extraction      : word problem → expression(s) + bounds
 *   - Explain the current plot : engine-computed features → AI narration
 *
 * Requires on the page:
 *   /ai proxy endpoint, the existing GraphingEngine as window.engine,
 *   and helpers: addExpression, updateGraph, loadSample, updateExpressionType,
 *   gcClearAll (from graphing-calculator-presets.js).
 */
(function () {
    'use strict';

    var CTX = (document.querySelector('meta[name="context-path"]') || {}).content || '';
    var AI_URL = CTX + '/ai';

    // Types we accept from the AI
    var VALID_TYPES = [
        'cartesian', 'parametric', 'polar', 'implicit',
        'equation', 'inequality', 'piecewise', 'surface', 'limit'
    ];

    // State for the current AI session
    var currentAbort = null;
    var pendingPlot = null;  // { expressions: [...], viewRange, notes }

    // ---- System prompts ---------------------------------------------------

    var PLOT_RULES =
        'Return ONLY a JSON object: {\n'
        + '  "expressions": [ { "type": string, "expression": string, "color": string?, "notes": string?, "sliders": [{name,min,max,default}]? } ],\n'
        + '  "viewRange": { "xMin": number, "xMax": number, "yMin": number, "yMax": number } ?,\n'
        + '  "confidence": number between 0 and 1,\n'
        + '  "notes": short string\n'
        + '}\n'
        + 'RULES:\n'
        + '- "type" MUST be one of: cartesian, parametric, polar, implicit, equation, inequality, piecewise, surface, limit.\n'
        + '- "expression" uses math.js syntax. Examples:\n'
        + '    cartesian: "sin(x)", "x^2 + 2*x + 1", "exp(-x^2)"\n'
        + '    parametric: "cos(t), sin(t)"      (x(t), y(t) comma-separated)\n'
        + '    polar: "1 + cos(theta)"           (r as function of theta)\n'
        + '    surface: "sin(x)*cos(y)"          (z = f(x,y), both x and y required)\n'
        + '    implicit / equation: "x^2 + y^2 = 25"\n'
        + '    inequality: "y < x^2"\n'
        + '    limit: use form "lim(expr, var, approach)" e.g. "lim(sin(x)/x, x, 0)"\n'
        + '- Use * for multiplication. ^ for exponent. Names: sin, cos, tan, exp, log (natural), sqrt, abs, pi, theta.\n'
        + '- NEVER compute numerical answers. You emit only expressions; the engine evaluates them.\n'
        + '- For scenes (e.g. "circle with tangent line"), return multiple entries in the "expressions" array.\n'
        + '- Pick a clean viewRange when the default (-10..10) does not show the function well (e.g. Gaussian needs smaller y range).\n'
        + '- "confidence" low (< 0.5) if the prompt is ambiguous or could map to many different things.\n'
        + '- NO markdown, NO code fences, NO prose outside the JSON. Just the JSON object.';

    var SYS_PLOT =
        'You translate English descriptions of math graphs into plottable expressions for a graphing calculator. '
        + 'You do NOT perform any math yourself - a separate engine (Math.js, Nerdamer, Plotly) plots and analyzes what you return. '
        + 'Your job: pick the right type and write a clean expression that represents the user\'s idea.\n\n'
        + PLOT_RULES;

    var SYS_HOMEWORK =
        'You extract plottable expressions from a homework problem written in plain English. '
        + 'The user pastes a word problem; you identify what should be graphed and return expressions for a graphing calculator engine to plot. '
        + 'You do NOT solve the problem - only pick expressions.\n\n'
        + 'Additional guidance:\n'
        + '- Physics: projectile → parametric with t as time; oscillation → cartesian with t mapped to x.\n'
        + '- "Area between f and g on [a,b]": return both f and g as cartesian expressions, and hint at bounds in "notes".\n'
        + '- "Trajectory at angle theta, speed v" → parametric: "v*cos(theta)*t, v*sin(theta)*t - 0.5*9.8*t^2" with explicit numbers.\n'
        + '- If the problem asks for a system of equations → return each equation separately.\n\n'
        + PLOT_RULES;

    var SYS_EXPLAIN =
        'You narrate what a plotted math graph shows for a learner. '
        + 'You are given a JSON payload with the expressions being plotted and a "facts" object listing features the engine computed (zeros, extrema, asymptotes, discontinuities, domain, period, etc.). '
        + 'CRITICAL RULES:\n'
        + '- Only narrate features present in "facts". Do NOT invent zeros, extrema, asymptotes, or other mathematical claims.\n'
        + '- If a feature is not in "facts", do not mention it (say nothing rather than guess).\n'
        + '- Be concise (under 200 words). Use plain English. Short sentences.\n'
        + '- Use inline `code` for expressions (e.g. `sin(x)`).\n'
        + '- Structure: one sentence stating what the graph is, then 3-5 bullet-free sentences describing the engine-computed features and their meaning.\n'
        + '- No markdown headings, no fenced code blocks, no meta-commentary.';

    // ---- UI helpers -------------------------------------------------------

    function $(id) { return document.getElementById(id); }

    function setBusy(busy) {
        var tab = currentTab();
        var pane = $('gc-ai-pane-' + tab);
        if (!pane) return;
        var btn = pane.querySelector('.gc-ai-go');
        var label = pane.querySelector('.gc-ai-go-label');
        var spin = pane.querySelector('.gc-ai-spinner');
        if (btn) btn.disabled = busy;
        if (label) label.style.display = busy ? 'none' : '';
        if (spin) spin.style.display = busy ? '' : 'none';
    }

    function showStatus(msg, kind) {
        var el = $('gc-ai-status');
        if (!el) return;
        el.textContent = msg;
        el.className = 'gc-ai-status ' + (kind || '');
        el.style.display = '';
    }

    function hideStatus() {
        var el = $('gc-ai-status');
        if (el) { el.style.display = 'none'; el.textContent = ''; }
    }

    function hidePreview() {
        var el = $('gc-ai-preview');
        if (el) el.style.display = 'none';
        pendingPlot = null;
    }

    function hidePanel() {
        var el = $('gc-ai-panel');
        if (el) el.style.display = 'none';
    }

    function showPanel(title) {
        var panel = $('gc-ai-panel');
        var titleEl = $('gc-ai-panel-title');
        var body = $('gc-ai-panel-body');
        if (!panel || !body) return;
        if (titleEl) titleEl.textContent = title || 'AI';
        body.innerHTML = '<span style="color:var(--text-muted,#94a3b8);">Thinking&hellip;</span>';
        panel.style.display = '';
    }

    function currentTab() {
        var activeTab = document.querySelector('.gc-ai-tab.active');
        return activeTab ? activeTab.getAttribute('data-ai-mode') : 'plot';
    }

    // ---- Validation -------------------------------------------------------

    function validateExpressionItem(item) {
        if (!item || typeof item !== 'object') return 'Not an object';
        var type = (item.type || '').toLowerCase().trim();
        if (VALID_TYPES.indexOf(type) === -1) return 'Invalid type: ' + type;

        var expr = (item.expression || '').trim();
        if (!expr) return 'Empty expression';
        if (expr.length > 300) return 'Expression too long';
        // Block suspicious JS
        if (/[<>;{}]|javascript:|<script/i.test(expr)) return 'Suspicious characters';

        // Type-specific structural checks
        if (type === 'parametric') {
            if (expr.indexOf(',') === -1) return 'Parametric needs "x(t), y(t)"';
        }
        if (type === 'surface') {
            // Must mention at least one of x/y (typically both)
            if (!/[xy]/i.test(expr)) return 'Surface needs x and/or y';
        }
        if (type === 'equation' || type === 'implicit') {
            if (expr.indexOf('=') === -1) return 'Equation needs "="';
        }
        if (type === 'limit') {
            if (!/lim\s*\(/i.test(expr)) return 'Limit needs lim(expr, var, approach) form';
        }

        // Final pass: if math.js is loaded, try parsing Cartesian/polar/etc.
        // (skip for parametric/equation/limit/surface which have non-standard forms)
        var parseable = ['cartesian', 'polar', 'inequality'];
        if (parseable.indexOf(type) !== -1 && typeof window.math !== 'undefined' && window.math.parse) {
            try {
                window.math.parse(expr.replace(/\btheta\b/g, 'x'));  // theta → x for polar
            } catch (e) {
                return 'math.parse rejected: ' + (e.message || 'syntax error');
            }
        }
        return null;  // OK
    }

    function validateResponse(data) {
        if (!data || typeof data !== 'object') return { ok: false, reason: 'Not an object' };
        var exprs = data.expressions;
        if (!Array.isArray(exprs) || !exprs.length) return { ok: false, reason: 'No expressions' };
        if (exprs.length > 6) return { ok: false, reason: 'Too many expressions' };

        for (var i = 0; i < exprs.length; i++) {
            var err = validateExpressionItem(exprs[i]);
            if (err) return { ok: false, reason: 'Expression ' + (i + 1) + ': ' + err };
        }
        return { ok: true };
    }

    function parseAIResponse(text) {
        // Strip markdown fences if AI ignored instructions
        var clean = text.replace(/```(?:json)?\s*/gi, '').replace(/```/g, '').trim();
        // Extract first {...} if there's prose around it
        var start = clean.indexOf('{');
        var end = clean.lastIndexOf('}');
        if (start !== -1 && end !== -1 && end > start) {
            clean = clean.slice(start, end + 1);
        }
        return JSON.parse(clean);
    }

    // ---- Fetch /ai --------------------------------------------------------

    function callAI(messages) {
        if (currentAbort) { try { currentAbort.abort(); } catch (e) { } }
        currentAbort = new AbortController();
        return fetch(AI_URL, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ messages: messages, stream: false }),
            signal: currentAbort.signal
        }).then(function (r) {
            if (r.status === 429) throw new Error('Rate limit &mdash; try again in a minute.');
            if (!r.ok) throw new Error('AI is unavailable (' + r.status + ').');
            return r.json();
        }).then(function (data) {
            var text = '';
            if (data.message && data.message.content) text = data.message.content;
            else if (data.response) text = data.response;
            else if (data.choices && data.choices[0]) {
                text = data.choices[0].message ? data.choices[0].message.content : (data.choices[0].text || '');
            }
            return text.replace(/<think>[\s\S]*?<\/think>/g, '').trim();
        });
    }

    // ---- Build preview UI -------------------------------------------------

    function escHtml(s) {
        return String(s == null ? '' : s)
            .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    }

    function buildPreview(data) {
        var count = data.expressions.length;
        $('gc-ai-preview-count').textContent = count;
        var listEl = $('gc-ai-preview-list');
        listEl.innerHTML = data.expressions.map(function (e) {
            return '<li><span class="gc-ai-type">' + escHtml(e.type) + '</span>'
                + '<code>' + escHtml(e.expression) + '</code></li>';
        }).join('');
        var notesEl = $('gc-ai-preview-notes');
        var notes = data.notes || '';
        if (data.viewRange) {
            var r = data.viewRange;
            notes += (notes ? ' · ' : '') + 'view: x[' + r.xMin + ',' + r.xMax + '] y[' + r.yMin + ',' + r.yMax + ']';
        }
        if (data.confidence != null && data.confidence < 0.5) {
            notes += (notes ? ' · ' : '') + 'low confidence (' + Math.round(data.confidence * 100) + '%)';
        }
        notesEl.textContent = notes;
        $('gc-ai-preview').style.display = '';
    }

    // ---- Apply to engine --------------------------------------------------

    function applyViewRange(r) {
        if (!r) return;
        try {
            if (typeof r.xMin === 'number') $('xMin').value = r.xMin;
            if (typeof r.xMax === 'number') $('xMax').value = r.xMax;
            if (typeof r.yMin === 'number') $('yMin').value = r.yMin;
            if (typeof r.yMax === 'number') $('yMax').value = r.yMax;
        } catch (e) { /* ignore */ }
    }

    // Map our "implicit" alias to the engine's actual type name.
    // The UI labels it as "Equation" in some places; both should work because
    // the engine has both 'implicit' and 'equation' in _mqSupportedTypes.
    function normalizeType(t) {
        t = (t || '').toLowerCase().trim();
        if (t === 'equation') return 'implicit';  // engine prefers implicit
        return t;
    }

    function applyPlot(data, clearFirst) {
        if (!data || !Array.isArray(data.expressions)) return;

        // Optionally clear current expressions so the scene is clean.
        if (clearFirst && typeof window.gcClearAll === 'function') {
            try { window.gcClearAll(); } catch (e) { }
        }

        applyViewRange(data.viewRange);

        // Add each expression via addExpression() then set type + value.
        // Pattern mirrors gcAdd() from graphing-calculator-presets.js.
        data.expressions.forEach(function (item, idx) {
            try {
                var type = normalizeType(item.type);
                var value = item.expression;
                if (typeof window.addExpression === 'function') window.addExpression();
                var items = document.querySelectorAll('[id^=expr-item-]');
                var last = items[items.length - 1];
                if (!last) return;
                var id = parseInt(last.id.replace('expr-item-', ''), 10);

                var typeSel = $('type-' + id);
                if (typeSel) {
                    typeSel.value = type;
                    if (typeof window.updateExpressionType === 'function') {
                        window.updateExpressionType(id);
                    }
                }
                if (typeof window.loadSample === 'function') {
                    window.loadSample(id, value);
                } else {
                    var input = $('expr-' + id);
                    if (input) {
                        input.value = value;
                        if (typeof window.updateExpressionValue === 'function') {
                            window.updateExpressionValue(id);
                        }
                    }
                }
                if (item.color) {
                    var c = $('color-' + id);
                    if (c) {
                        c.value = item.color;
                        if (typeof window.updateExpressionColor === 'function') {
                            window.updateExpressionColor(id);
                        }
                    }
                }
            } catch (e) {
                console.warn('[GraphAI] could not apply expression', idx, e);
            }
        });

        if (typeof window.updateGraph === 'function') {
            try { window.updateGraph(); } catch (e) { }
        }
    }

    // ---- Ask AI: Plot + Homework modes ------------------------------------

    function askPlot(mode) {
        var inputId = mode === 'homework' ? 'gc-ai-hw-input' : 'gc-ai-plot-input';
        var clearFirstId = mode === 'homework' ? 'gc-ai-hw-clear-first' : 'gc-ai-clear-first';
        var inputEl = $(inputId);
        if (!inputEl) return;
        var desc = inputEl.value.trim();
        if (!desc) { inputEl.focus(); return; }
        if (desc.length > 2000) {
            showStatus('Input is too long (max 2000 chars).', 'error');
            return;
        }

        hideStatus();
        hidePreview();
        hidePanel();
        setBusy(true);

        var sys = mode === 'homework' ? SYS_HOMEWORK : SYS_PLOT;

        callAI([
            { role: 'system', content: sys },
            { role: 'user', content: desc }
        ])
            .then(function (text) {
                if (!text) throw new Error('Empty response from AI.');
                var parsed;
                try { parsed = parseAIResponse(text); }
                catch (e) { throw new Error('AI returned invalid JSON. Try rephrasing.'); }

                var check = validateResponse(parsed);
                if (!check.ok) {
                    throw new Error('AI output rejected: ' + check.reason);
                }

                // Stash for preview confirm
                pendingPlot = {
                    data: parsed,
                    clearFirst: !!$(clearFirstId) && $(clearFirstId).checked
                };
                buildPreview(parsed);
            })
            .catch(function (err) {
                if (err && err.name === 'AbortError') return;
                showStatus(err.message || 'Something went wrong.', 'error');
            })
            .finally(function () {
                setBusy(false);
                currentAbort = null;
            });
    }

    // ---- Gather engine-computed facts for "Explain" -----------------------

    // Read the current plot's expressions and ask the engine (Nerdamer) for
    // features we can ground the narration in. We do NOT pass raw expression
    // strings alone; we pass facts the engine produced. If features can't be
    // computed, we just omit them - AI must not invent.
    function collectEngineFacts() {
        var facts = { expressions: [] };
        if (typeof window.engine === 'undefined' || !window.engine || !Array.isArray(window.engine.expressions)) {
            return facts;
        }

        facts.expressions = window.engine.expressions
            .filter(function (e) { return e && e.expression && e.visible !== false; })
            .map(function (e) {
                var item = { type: e.type, expression: e.expression };

                // Engine-computed ranges/values we might have on the expression.
                if (e.color) item.color = e.color;
                if (e.limitResult != null) item.limitResult = e.limitResult;
                if (e.integralValue != null) item.integralValue = e.integralValue;
                if (e.intersections) item.intersections = e.intersections;

                // Try Nerdamer for symbolic features on Cartesian expressions
                if (e.type === 'cartesian' && typeof window.nerdamer === 'function') {
                    var features = {};
                    try {
                        // Zeros via solve (best-effort)
                        var zeros = window.nerdamer('solve(' + e.expression + ', x)').toString();
                        if (zeros && zeros !== '[]') features.zeros = zeros;
                    } catch (err) { /* skip */ }
                    try {
                        var derivative = window.nerdamer('diff(' + e.expression + ', x)').toString();
                        if (derivative) features.derivative = derivative;
                    } catch (err) { /* skip */ }
                    if (Object.keys(features).length) item.engineFeatures = features;
                }

                return item;
            });

        // View range
        try {
            facts.viewRange = {
                xMin: parseFloat($('xMin').value),
                xMax: parseFloat($('xMax').value),
                yMin: parseFloat($('yMin').value),
                yMax: parseFloat($('yMax').value)
            };
        } catch (e) { /* ignore */ }

        return facts;
    }

    function askExplain() {
        var facts = collectEngineFacts();
        if (!facts.expressions.length) {
            showStatus('Nothing plotted yet. Add an expression first.', 'error');
            return;
        }

        hideStatus();
        hidePreview();
        showPanel('Explanation');
        setBusy(true);

        var userMsg = 'Here is what the engine has plotted. Narrate it for a learner using ONLY these facts.\n\n'
            + JSON.stringify(facts, null, 2);

        callAI([
            { role: 'system', content: SYS_EXPLAIN },
            { role: 'user', content: userMsg }
        ])
            .then(function (text) {
                if (!text) throw new Error('Empty response from AI.');
                var body = $('gc-ai-panel-body');
                if (body) {
                    // Render inline code, escape rest
                    var html = escHtml(text).replace(/`([^`\n]+)`/g, '<code>$1</code>');
                    body.innerHTML = html;
                }
            })
            .catch(function (err) {
                if (err && err.name === 'AbortError') return;
                var body = $('gc-ai-panel-body');
                if (body) body.innerHTML = '<span style="color:#dc2626;">' + escHtml(err.message || 'Something went wrong.') + '</span>';
            })
            .finally(function () {
                setBusy(false);
                currentAbort = null;
            });
    }

    // ---- Public API (attached to window) ---------------------------------

    window.gcAiSwitchTab = function (mode) {
        document.querySelectorAll('.gc-ai-tab').forEach(function (t) {
            t.classList.toggle('active', t.getAttribute('data-ai-mode') === mode);
        });
        ['plot', 'homework', 'explain'].forEach(function (m) {
            var pane = $('gc-ai-pane-' + m);
            if (pane) pane.style.display = (m === mode) ? '' : 'none';
        });
        hideStatus();
        hidePreview();
        hidePanel();
    };

    window.gcAiChip = function (prompt) {
        var input = $('gc-ai-plot-input');
        if (input) { input.value = prompt; input.focus(); }
    };

    window.gcAiAsk = function (mode) {
        if (mode === 'explain') askExplain();
        else askPlot(mode);
    };

    window.gcAiApplyPreview = function () {
        if (!pendingPlot) return;
        applyPlot(pendingPlot.data, pendingPlot.clearFirst);
        hidePreview();
        hideStatus();
    };

    window.gcAiClearPreview = hidePreview;
    window.gcAiClosePanel = hidePanel;

    // Enter to submit in the text inputs
    document.addEventListener('DOMContentLoaded', function () {
        var plotInput = $('gc-ai-plot-input');
        if (plotInput) {
            plotInput.addEventListener('keydown', function (e) {
                if (e.key === 'Enter') { e.preventDefault(); askPlot('plot'); }
            });
        }
        var hwInput = $('gc-ai-hw-input');
        if (hwInput) {
            hwInput.addEventListener('keydown', function (e) {
                // Ctrl/Cmd+Enter to submit (Enter allows newlines in textarea)
                if (e.key === 'Enter' && (e.ctrlKey || e.metaKey)) {
                    e.preventDefault();
                    askPlot('homework');
                }
            });
        }
    });
})();
