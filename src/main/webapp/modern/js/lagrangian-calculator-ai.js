/**
 * lagrangian-calculator-ai.js
 *
 * AI integration for the Lagrangian Mechanics Calculator.
 *
 * Firewall: AI only writes the 6 input strings (T, V, coords, params, IC, tspan).
 * All physics — Euler-Lagrange derivation, Hamiltonian via Legendre transform,
 * Noether conservation laws, RK45 numerical integration, animations — is done
 * by the existing engine.
 *
 * User flow:
 *   English description → AI call → JSON output → strict validation →
 *   preview card → user confirms → fields filled → existing Solve button
 */
(function () {
    'use strict';

    var CTX = (window.LM_CALC_CTX || '');
    var AI_URL = CTX + '/ai';

    // ---- DOM refs ---------------------------------------------------------
    var $ = function (id) { return document.getElementById(id); };
    var inputEl     = $('lm-ai-input');
    var btnEl       = $('lm-ai-btn');
    var btnLabel    = btnEl && btnEl.querySelector('.lm-ai-go-label');
    var btnSpinner  = btnEl && btnEl.querySelector('.lm-ai-spinner');
    var statusEl    = $('lm-ai-status');
    var previewEl   = $('lm-ai-preview');
    var previewName = $('lm-ai-preview-name');
    var previewList = $('lm-ai-preview-list');
    var previewNote = $('lm-ai-preview-notes');
    var confirmBtn  = $('lm-ai-confirm');
    var cancelBtn   = $('lm-ai-cancel');

    // Form field refs (filled on confirm)
    var fields = {
        kinetic:   $('lm-kinetic'),
        potential: $('lm-potential'),
        coords:    $('lm-coords'),
        params:    $('lm-params'),
        ic:        $('lm-ic'),
        tspan:     $('lm-tspan')
    };

    if (!inputEl || !btnEl) return;  // UI not present on this page

    var currentAbort = null;
    var pending = null;  // parsed & validated JSON ready to apply

    // ---- System prompt ----------------------------------------------------

    var SYS_PROMPT =
        'You translate plain-English descriptions of classical mechanics systems into the six inputs of a Lagrangian Mechanics Calculator. '
        + 'The calculator uses a symbolic engine (SymPy) to derive Euler-Lagrange equations, Hamiltonian, conservation laws, and run RK45 integration. YOU DO NOT DO PHYSICS. You only write the strings the user would have typed themselves.\n\n'
        + 'Return ONLY a JSON object with these fields:\n'
        + '{\n'
        + '  "name": string,           // short label, e.g. "Simple Pendulum"\n'
        + '  "kinetic": string,        // T expression in math.js syntax\n'
        + '  "potential": string,      // V expression in math.js syntax\n'
        + '  "coords": string,         // comma-separated generalized coords, e.g. "theta" or "r, theta"\n'
        + '  "params": string,         // "name=value, name=value", e.g. "m=1, g=9.8, l=1"\n'
        + '  "ic": string,             // initial conditions, "q(0)=..., dq(0)=..."\n'
        + '  "tspan": string,          // "start, end" in seconds, e.g. "0, 10"\n'
        + '  "confidence": number,     // 0 to 1\n'
        + '  "notes": string           // one short sentence (< 120 chars)\n'
        + '}\n\n'
        + 'SYNTAX RULES:\n'
        + '- Use `dq` to mean the time derivative of q. E.g. for coord theta, use `dtheta`. For coord `x`, use `dx`. For coord `theta1`, use `dtheta1`.\n'
        + '- Use `d<coord>(0)=...` in initial conditions. E.g. `theta(0)=0.3, dtheta(0)=0`.\n'
        + '- Use `*` for multiplication, `^` for exponentiation, `sin`, `cos`, `tan`, `exp`, `log` (natural), `sqrt`, `pi`.\n'
        + '- Kinetic energy MUST contain a squared velocity term (e.g. `1/2*m*dx^2`). Never `m*dx` alone.\n'
        + '- Potential energy conventions: gravity `m*g*h`; spring `1/2*k*x^2`; pendulum `-m*g*l*cos(theta)`.\n'
        + '- Parameters used in T or V must also appear in "params" with numeric values. Pick sensible defaults if user did not specify (m=1, g=9.8, l=1, k=1, etc.).\n'
        + '- Every coordinate in "coords" must appear in T or V, and must have initial conditions for both q(0) and dq(0).\n'
        + '- For 2-DOF systems give both coords separated by comma. For rotating / polar systems use `r, theta`.\n\n'
        + 'COMMON SYSTEMS (reference — match the patterns when the user describes similar):\n'
        + '- Simple pendulum: T="1/2*m*l^2*dtheta^2", V="-m*g*l*cos(theta)", coords="theta", params="m=1, g=9.8, l=1", ic="theta(0)=0.3, dtheta(0)=0"\n'
        + '- Spring-mass: T="1/2*m*dx^2", V="1/2*k*x^2", coords="x", params="m=1, k=4", ic="x(0)=1, dx(0)=0"\n'
        + '- Kepler (central force): T="1/2*m*(dr^2 + r^2*dtheta^2)", V="-G*M*m/r", coords="r, theta"\n'
        + '- Bead on parabolic wire y=x^2: T="1/2*m*(1+4*x^2)*dx^2", V="m*g*x^2", coords="x"\n'
        + '- Atwood machine: T="1/2*(m1+m2)*dx^2", V="(m1-m2)*g*x", coords="x"\n'
        + '- Coupled oscillators: T="1/2*m*(dx1^2 + dx2^2)", V with cross-term, coords="x1, x2"\n'
        + '- Double pendulum: use 2 angles; include the coupling cos(theta1-theta2) term in T\n\n'
        + 'If the description does not describe a mechanics system, return {"name":"", "kinetic":"", "potential":"", "coords":"", "params":"", "ic":"", "tspan":"0, 10", "confidence":0, "notes":"Not a mechanics system"}.\n\n'
        + 'NO markdown, NO code fences, NO prose outside the JSON. Just the JSON object.';

    // ---- UI helpers -------------------------------------------------------

    function setBusy(busy) {
        btnEl.disabled = busy;
        if (btnLabel) btnLabel.style.display = busy ? 'none' : '';
        if (btnSpinner) btnSpinner.style.display = busy ? '' : 'none';
    }

    function showStatus(msg, kind) {
        if (!statusEl) return;
        statusEl.textContent = msg;
        statusEl.className = 'lm-ai-status ' + (kind || '');
        statusEl.style.display = '';
    }

    function hideStatus() {
        if (statusEl) { statusEl.style.display = 'none'; statusEl.textContent = ''; }
    }

    function hidePreview() {
        if (previewEl) previewEl.style.display = 'none';
        pending = null;
    }

    // ---- Parsing & validation --------------------------------------------

    function parseAI(text) {
        var clean = text.replace(/```(?:json)?\s*/gi, '').replace(/```/g, '').trim();
        var a = clean.indexOf('{');
        var b = clean.lastIndexOf('}');
        if (a !== -1 && b > a) clean = clean.slice(a, b + 1);
        return JSON.parse(clean);
    }

    // Pull out bare coordinate names (comma-separated, trimmed).
    function splitCoords(s) {
        if (!s) return [];
        return s.split(',').map(function (c) { return c.trim(); }).filter(Boolean);
    }

    // Pull out bare param names from "m=1, g=9.8".
    function paramNames(s) {
        if (!s) return [];
        return s.split(',').map(function (p) {
            var m = p.match(/^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=/);
            return m ? m[1] : null;
        }).filter(Boolean);
    }

    // Basic math-expression sanity. Reject obvious non-math / injection.
    function looksLikeExpression(s) {
        if (!s || typeof s !== 'string') return false;
        var t = s.trim();
        if (!t || t.length > 400) return false;
        if (/[<>;]|javascript:|<script/i.test(t)) return false;
        // Must contain at least one alpha or digit
        if (!/[A-Za-z0-9]/.test(t)) return false;
        return true;
    }

    function validate(data) {
        if (!data || typeof data !== 'object') return 'Not an object';
        // Empty formula = AI declared "not a mechanics system"
        if (!data.kinetic && !data.potential && !data.coords) {
            return data.notes || 'Not a mechanics system';
        }

        var must = ['kinetic', 'potential', 'coords', 'params', 'ic'];
        for (var i = 0; i < must.length; i++) {
            var k = must[i];
            if (!data[k] || typeof data[k] !== 'string' || !data[k].trim()) {
                return 'Missing field: ' + k;
            }
        }
        if (!looksLikeExpression(data.kinetic))   return 'Invalid kinetic energy';
        if (!looksLikeExpression(data.potential)) return 'Invalid potential energy';

        // Kinetic MUST contain a squared velocity term. Catch the typical
        // "m*dx" error where user writes momentum instead of energy.
        if (!/\bd[A-Za-z_][A-Za-z0-9_]*\s*\^\s*2|\(.*d[A-Za-z_][A-Za-z0-9_]*.*\)\s*\^\s*2|d[A-Za-z_][A-Za-z0-9_]*\s*\*\s*d[A-Za-z_][A-Za-z0-9_]*/.test(data.kinetic)) {
            return 'Kinetic energy missing a squared velocity term (needs like 1/2*m*dq^2)';
        }

        // Each coord must appear (as identifier) in T or V.
        var coords = splitCoords(data.coords);
        if (!coords.length) return 'No coordinates declared';
        if (coords.length > 4) return 'Too many coordinates (max 4)';

        for (var j = 0; j < coords.length; j++) {
            var c = coords[j];
            if (!/^[A-Za-z_][A-Za-z0-9_]*$/.test(c)) return 'Invalid coord name: ' + c;
            var re = new RegExp('\\b' + c.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + '\\b');
            if (!re.test(data.kinetic) && !re.test(data.potential)) {
                // Coord must appear in T or V (either the coord itself or its derivative dq)
                var dre = new RegExp('\\bd' + c + '\\b');
                if (!dre.test(data.kinetic) && !dre.test(data.potential)) {
                    return 'Coord "' + c + '" not used in T or V';
                }
            }

            // IC must reference this coord for both position and velocity
            var icQ = new RegExp('\\b' + c + '\\s*\\(\\s*0\\s*\\)\\s*=');
            var icDQ = new RegExp('\\bd' + c + '\\s*\\(\\s*0\\s*\\)\\s*=');
            if (!icQ.test(data.ic) || !icDQ.test(data.ic)) {
                return 'IC missing ' + c + '(0) or d' + c + '(0)';
            }
        }

        // params must be well-formed name=value pairs
        var names = paramNames(data.params);
        if (data.params.trim() && names.length === 0) {
            return 'Params malformed (expected name=value pairs)';
        }

        // tspan: two numbers
        var tspan = (data.tspan || '0, 10').split(',');
        if (tspan.length !== 2 || isNaN(parseFloat(tspan[0])) || isNaN(parseFloat(tspan[1]))) {
            return 'tspan must be two numbers (e.g. "0, 10")';
        }

        return null;
    }

    // ---- Preview rendering ------------------------------------------------

    function escHtml(s) {
        return String(s == null ? '' : s)
            .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    }

    function renderPreview(data) {
        if (!previewList) return;
        previewName.textContent = data.name || 'Custom System';
        var rows = [
            ['T', data.kinetic],
            ['V', data.potential],
            ['q', data.coords],
            ['ξ', data.params],
            ['y₀', data.ic],
            ['t', data.tspan || '0, 10']
        ];
        previewList.innerHTML = rows.map(function (r) {
            return '<dt>' + r[0] + '</dt><dd>' + escHtml(r[1]) + '</dd>';
        }).join('');

        var notes = data.notes || '';
        if (data.confidence != null && data.confidence < 0.5) {
            notes += (notes ? ' · ' : '') + 'low confidence (' + Math.round(data.confidence * 100) + '%)';
        }
        if (previewNote) previewNote.textContent = notes;
        previewEl.style.display = '';
    }

    // ---- Apply to form ----------------------------------------------------

    function applyToForm(data) {
        fields.kinetic.value   = data.kinetic;
        fields.potential.value = data.potential;
        fields.coords.value    = data.coords;
        fields.params.value    = data.params;
        fields.ic.value        = data.ic;
        fields.tspan.value     = data.tspan || '0, 10';

        // Switch system select to "custom" (since this is AI-generated, not a preset)
        var sel = $('lm-system-select');
        if (sel) sel.value = 'custom';

        // Fire input events so the engine's live preview + validation update.
        Object.keys(fields).forEach(function (k) {
            try {
                fields[k].dispatchEvent(new Event('input', { bubbles: true }));
                fields[k].dispatchEvent(new Event('change', { bubbles: true }));
            } catch (e) { /* older browsers */ }
        });
    }

    // ---- Fetch /ai --------------------------------------------------------

    function callAI(userText) {
        if (currentAbort) { try { currentAbort.abort(); } catch (e) {} }
        currentAbort = new AbortController();
        return fetch(AI_URL, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                messages: [
                    { role: 'system', content: SYS_PROMPT },
                    { role: 'user', content: userText }
                ],
                stream: false
            }),
            signal: currentAbort.signal
        }).then(function (r) {
            if (r.status === 429) throw new Error('Rate limit — try again in a minute.');
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

    // ---- Main ask flow ----------------------------------------------------

    function askAI() {
        var desc = inputEl.value.trim();
        if (!desc) { inputEl.focus(); return; }
        if (desc.length > 1000) {
            showStatus('Description too long (max 1000 chars).', 'error');
            return;
        }

        hideStatus();
        hidePreview();
        setBusy(true);

        callAI(desc)
            .then(function (text) {
                if (!text) throw new Error('Empty response from AI.');
                var parsed;
                try { parsed = parseAI(text); }
                catch (e) { throw new Error('AI returned invalid JSON. Try rephrasing.'); }

                var err = validate(parsed);
                if (err) throw new Error(err);

                pending = parsed;
                renderPreview(parsed);
            })
            .catch(function (e) {
                if (e && e.name === 'AbortError') return;
                showStatus(e.message || 'Something went wrong.', 'error');
            })
            .finally(function () {
                setBusy(false);
                currentAbort = null;
            });
    }

    // ---- Public chip helper -----------------------------------------------

    window.lmAiChip = function (prompt) {
        inputEl.value = prompt;
        inputEl.focus();
    };

    // ---- Wire events ------------------------------------------------------

    btnEl.addEventListener('click', askAI);
    inputEl.addEventListener('keydown', function (e) {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            askAI();
        }
    });
    if (confirmBtn) confirmBtn.addEventListener('click', function () {
        if (!pending) return;
        applyToForm(pending);
        hidePreview();
        hideStatus();
    });
    if (cancelBtn) cancelBtn.addEventListener('click', function () {
        hidePreview();
        hideStatus();
    });
})();
