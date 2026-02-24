/**
 * Lagrangian Mechanics Calculator - DOM/UI logic
 * Computes Euler-Lagrange equations, Hamiltonian, conservation laws via SymPy on OneCompiler.
 * Requires: KaTeX (loaded by JSP)
 * Context path: set window.LM_CALC_CTX before load
 */
(function() {
    'use strict';

    // ========== DOM References ==========
    var systemSelect  = document.getElementById('lm-system-select');
    var kineticInput  = document.getElementById('lm-kinetic');
    var potentialInput = document.getElementById('lm-potential');
    var coordsInput   = document.getElementById('lm-coords');
    var paramsInput   = document.getElementById('lm-params');
    var icInput       = document.getElementById('lm-ic');
    var tspanInput    = document.getElementById('lm-tspan');
    var previewEl     = document.getElementById('lm-preview');
    var computeBtn    = document.getElementById('lm-compute-btn');
    var resultContent = document.getElementById('lm-result-content');
    var resultActions = document.getElementById('lm-result-actions');
    var emptyState    = document.getElementById('lm-empty-state');
    var graphHint     = document.getElementById('lm-graph-hint');
    var hamiltonianContent = document.getElementById('lm-hamiltonian-content');

    var lastResultLatex = '';
    var pendingPlotData = null;
    var currentPlotType = 'trajectory';
    var animationsLoaded = false;
    var currentSystemType = 'custom';

    // ========== Systems Library ==========
    var SYSTEMS = {
        simple_pendulum: {
            T: '1/2*m*l^2*dtheta^2',
            V: '-m*g*l*cos(theta)',
            coords: 'theta',
            params: 'm=1, g=9.8, l=1',
            ic: 'theta(0)=0.3, dtheta(0)=0',
            tspan: '0, 10',
            animationType: 'pendulum'
        },
        double_pendulum: {
            T: '1/2*m1*l1^2*dtheta1^2 + 1/2*m2*(l1^2*dtheta1^2 + l2^2*dtheta2^2 + 2*l1*l2*dtheta1*dtheta2*cos(theta1 - theta2))',
            V: '-(m1+m2)*g*l1*cos(theta1) - m2*g*l2*cos(theta2)',
            coords: 'theta1, theta2',
            params: 'm1=1, m2=1, l1=1, l2=1, g=9.8',
            ic: 'theta1(0)=2.0, dtheta1(0)=0, theta2(0)=2.0, dtheta2(0)=0',
            tspan: '0, 10',
            animationType: 'double_pendulum'
        },
        spring_mass: {
            T: '1/2*m*dx^2',
            V: '1/2*k*x^2',
            coords: 'x',
            params: 'm=1, k=4',
            ic: 'x(0)=1, dx(0)=0',
            tspan: '0, 10',
            animationType: 'spring_mass'
        },
        kepler: {
            T: '1/2*m*(dr^2 + r^2*dtheta^2)',
            V: '-G*M*m/r',
            coords: 'r, theta',
            params: 'm=1, G=1, M=1',
            ic: 'r(0)=1, dr(0)=0, theta(0)=0, dtheta(0)=1.1',
            tspan: '0, 15',
            animationType: 'kepler'
        },
        bead_wire: {
            T: '1/2*m*(1 + 4*a^2*x^2)*dx^2',
            V: 'm*g*a*x^2',
            coords: 'x',
            params: 'm=1, g=9.8, a=1',
            ic: 'x(0)=0.5, dx(0)=0',
            tspan: '0, 10',
            animationType: 'custom'
        },
        coupled_oscillators: {
            T: '1/2*m*(dx1^2 + dx2^2)',
            V: '1/2*k1*x1^2 + 1/2*k2*(x2 - x1)^2 + 1/2*k3*x2^2',
            coords: 'x1, x2',
            params: 'm=1, k1=4, k2=2, k3=4',
            ic: 'x1(0)=1, dx1(0)=0, x2(0)=0, dx2(0)=0',
            tspan: '0, 15',
            animationType: 'coupled'
        },
        atwood: {
            T: '1/2*(m1+m2)*dx^2',
            V: '(m1-m2)*g*x',
            coords: 'x',
            params: 'm1=2, m2=1, g=9.8',
            ic: 'x(0)=0, dx(0)=0',
            tspan: '0, 5',
            animationType: 'custom'
        }
    };

    // ========== Utility Functions ==========
    function escapeHtml(str) {
        var div = document.createElement('div');
        div.appendChild(document.createTextNode(str));
        return div.innerHTML;
    }

    function normalizeExpr(expr) {
        if (!expr || typeof expr !== 'string') return expr;
        var s = expr.trim();
        s = s.replace(/\u00b2/g, '^2').replace(/\u00b3/g, '^3')
             .replace(/\u03c0/g, 'pi')
             .replace(/\u00b7/g, '*').replace(/\u22c5/g, '*')
             .replace(/\u2212/g, '-').replace(/\u00d7/g, '*');
        return s;
    }

    function exprToPython(expr) {
        var py = (expr || '').trim()
            .replace(/e\^(\([^)]+\))/g, 'exp$1')
            .replace(/e\^([a-zA-Z0-9_]+)/g, 'exp($1)')
            .replace(/\^/g, '**')
            .replace(/(\d)([a-zA-Z])/g, '$1*$2')
            .replace(/\)(\()/g, ')*$1')
            .replace(/\)([a-zA-Z])/g, ')*$1');
        py = py.replace(/\bln\(/g, 'log(');
        return py;
    }

    function exprToLatex(expr) {
        if (!expr) return '';
        return expr
            .replace(/\*\*/g, '^')
            .replace(/\*/g, ' \\cdot ')
            .replace(/sqrt\(([^)]+)\)/g, '\\sqrt{$1}')
            .replace(/sin\(/g, '\\sin(')
            .replace(/cos\(/g, '\\cos(')
            .replace(/tan\(/g, '\\tan(')
            .replace(/exp\(([^)]+)\)/g, 'e^{$1}')
            .replace(/\^([a-zA-Z0-9]+)/g, '^{$1}')
            .replace(/\^(\([^)]+\))/g, '^{$1}')
            .replace(/dtheta(\d+)/g, '\\dot{\\theta}_{$1}')
            .replace(/dtheta(?!\d)/g, '\\dot{\\theta}')
            .replace(/dphi/g, '\\dot{\\phi}')
            .replace(/dr(?![a-zA-Z])/g, '\\dot{r}')
            .replace(/dx(\d+)/g, '\\dot{x}_{$1}')
            .replace(/dx(?!\d)/g, '\\dot{x}')
            .replace(/\btheta(\d+)/g, function(m, d, off, s) { return off > 0 && s[off-1] === '\\' ? m : '\\theta_{' + d + '}'; })
            .replace(/\btheta(?![_0-9{])/g, function(m, off, s) { return off > 0 && s[off-1] === '\\' ? m : '\\theta'; })
            .replace(/\bphi\b/g, function(m, off, s) { return off > 0 && s[off-1] === '\\' ? m : '\\phi'; });
    }

    function prepareLatexForKatex(latex) {
        if (!latex || typeof latex !== 'string') return latex;
        latex = latex.replace(/\\\\/g, '\\');
        var hasLatex = /\\|[\^_]|\{[^}]*\}/.test(latex);
        if (!hasLatex) {
            return '\\text{' + latex.replace(/\\/g, '\\\\').replace(/}/g, '\\}') + '}';
        }
        return latex;
    }

    function parseCoords(str) {
        return (str || '').split(',').map(function(s) { return s.trim(); }).filter(Boolean);
    }

    function parseParams(str) {
        var params = {};
        (str || '').split(',').forEach(function(pair) {
            var parts = pair.split('=');
            if (parts.length === 2) {
                params[parts[0].trim()] = parseFloat(parts[1].trim());
            }
        });
        return params;
    }

    function parseIC(str) {
        var ics = {};
        (str || '').split(',').forEach(function(pair) {
            var m = pair.trim().match(/^(\w+)\(0\)\s*=\s*([^\s,]+)/);
            if (m) {
                ics[m[1]] = parseFloat(m[2]);
            }
        });
        return ics;
    }

    // ========== Input Validation ==========
    function setValidation(inputEl, hintId, isValid, msg) {
        var hint = document.getElementById(hintId);
        inputEl.classList.remove('lm-valid', 'lm-invalid');
        if (hint) {
            hint.classList.remove('visible', 'error', 'ok');
            hint.textContent = '';
        }
        if (!inputEl.value.trim()) return; // empty = neutral
        if (isValid) {
            inputEl.classList.add('lm-valid');
            if (hint && msg) { hint.textContent = msg; hint.classList.add('visible', 'ok'); }
        } else {
            inputEl.classList.add('lm-invalid');
            if (hint && msg) { hint.textContent = msg; hint.classList.add('visible', 'error'); }
        }
    }

    function validateExpr(expr) {
        if (!expr) return { valid: false, msg: '' };
        // Check balanced parentheses
        var depth = 0;
        for (var i = 0; i < expr.length; i++) {
            if (expr[i] === '(') depth++;
            if (expr[i] === ')') depth--;
            if (depth < 0) return { valid: false, msg: 'Unmatched closing parenthesis' };
        }
        if (depth !== 0) return { valid: false, msg: 'Unmatched opening parenthesis (' + depth + ' unclosed)' };
        // Check for empty parens
        if (/\(\s*\)/.test(expr)) return { valid: false, msg: 'Empty parentheses found' };
        // Check for consecutive operators
        if (/[+\-*/^]{2,}/.test(expr.replace(/\*\*/g, '^^').replace(/\^\^/g, '**'))) return { valid: false, msg: 'Consecutive operators detected' };
        // Check for valid characters
        if (/[^\w\s+\-*/^().,]/.test(expr)) return { valid: false, msg: 'Invalid character detected' };
        return { valid: true, msg: '' };
    }

    function validateCoords(str) {
        if (!str) return { valid: false, msg: '' };
        var parts = str.split(',').map(function(s) { return s.trim(); }).filter(Boolean);
        if (parts.length === 0) return { valid: false, msg: 'Enter at least one coordinate' };
        for (var i = 0; i < parts.length; i++) {
            if (!/^[a-zA-Z]\w*$/.test(parts[i])) return { valid: false, msg: '"' + parts[i] + '" is not a valid name' };
        }
        return { valid: true, msg: parts.length + ' coordinate(s)' };
    }

    function validateParams(str) {
        if (!str) return { valid: true, msg: '' };
        var parts = str.split(',').filter(function(s) { return s.trim(); });
        for (var i = 0; i < parts.length; i++) {
            if (!/^\s*[a-zA-Z]\w*\s*=\s*[\d.eE+\-]+\s*$/.test(parts[i])) {
                return { valid: false, msg: 'Invalid: "' + parts[i].trim() + '". Use name=value' };
            }
        }
        return { valid: true, msg: parts.length + ' parameter(s)' };
    }

    function validateIC(str) {
        if (!str) return { valid: true, msg: '' };
        var parts = str.split(',').filter(function(s) { return s.trim(); });
        for (var i = 0; i < parts.length; i++) {
            if (!/^\s*\w+\(0\)\s*=\s*[\d.eE+\-]+\s*$/.test(parts[i])) {
                return { valid: false, msg: 'Invalid: "' + parts[i].trim() + '". Use q(0)=value' };
            }
        }
        return { valid: true, msg: parts.length + ' condition(s)' };
    }

    function validateTspan(str) {
        if (!str) return { valid: false, msg: 'Enter start, end' };
        var parts = str.split(',').map(function(s) { return parseFloat(s.trim()); });
        if (parts.length !== 2 || isNaN(parts[0]) || isNaN(parts[1])) return { valid: false, msg: 'Use format: start, end' };
        if (parts[1] <= parts[0]) return { valid: false, msg: 'End must be > start' };
        return { valid: true, msg: (parts[1] - parts[0]) + 's span' };
    }

    function runAllValidation() {
        var v;
        v = validateExpr(kineticInput.value.trim());
        setValidation(kineticInput, 'lm-kinetic-hint', v.valid, v.msg);
        v = validateExpr(potentialInput.value.trim());
        setValidation(potentialInput, 'lm-potential-hint', v.valid, v.msg);
        v = validateCoords(coordsInput.value.trim());
        setValidation(coordsInput, 'lm-coords-hint', v.valid, v.msg);
        v = validateParams(paramsInput.value.trim());
        setValidation(paramsInput, 'lm-params-hint', v.valid, v.msg);
        v = validateIC(icInput.value.trim());
        setValidation(icInput, 'lm-ic-hint', v.valid, v.msg);
        v = validateTspan(tspanInput.value.trim());
        setValidation(tspanInput, 'lm-tspan-hint', v.valid, v.msg);
    }

    // Debounced validation on input
    var validationTimer = null;
    [kineticInput, potentialInput, coordsInput, paramsInput, icInput, tspanInput].forEach(function(el) {
        if (!el) return;
        el.addEventListener('input', function() {
            clearTimeout(validationTimer);
            validationTimer = setTimeout(runAllValidation, 300);
        });
    });

    // ========== FAQ ==========
    window.toggleFaq = function(btn) {
        btn.parentElement.classList.toggle('open');
    };

    // ========== System Select ==========
    systemSelect.addEventListener('change', function() {
        var key = this.value;
        currentSystemType = key;
        if (key === 'custom') return;
        var sys = SYSTEMS[key];
        if (!sys) return;
        kineticInput.value = sys.T;
        potentialInput.value = sys.V;
        coordsInput.value = sys.coords;
        paramsInput.value = sys.params;
        icInput.value = sys.ic;
        tspanInput.value = sys.tspan;
        updatePreview();
        runAllValidation();
    });

    // ========== Output Tabs ==========
    var tabBtns = document.querySelectorAll('.lm-output-tab');
    var panels  = document.querySelectorAll('.lm-panel');
    tabBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var panel = this.getAttribute('data-panel');
            tabBtns.forEach(function(b) { b.classList.remove('active'); });
            panels.forEach(function(p) { p.classList.remove('active'); });
            this.classList.add('active');
            document.getElementById('lm-panel-' + panel).classList.add('active');

            if (panel === 'plots' && pendingPlotData) {
                loadPlotly(function() { renderCurrentPlot(); });
            }
            if (panel === 'animation' && pendingPlotData && !animationsLoaded) {
                loadD3(function() {
                    var s = document.createElement('script');
                    s.src = (window.LM_CALC_CTX || '') + '/modern/js/lagrangian-animations.js?v=' + Date.now();
                    s.onload = function() {
                        animationsLoaded = true;
                        startAnimation();
                    };
                    document.head.appendChild(s);
                });
            } else if (panel === 'animation' && pendingPlotData && animationsLoaded) {
                startAnimation();
            }
        });
    });

    // ========== Plot Sub-tabs ==========
    var plotSubtabs = document.querySelectorAll('.lm-plot-subtab');
    plotSubtabs.forEach(function(btn) {
        btn.addEventListener('click', function() {
            plotSubtabs.forEach(function(b) { b.classList.remove('active'); });
            this.classList.add('active');
            currentPlotType = this.getAttribute('data-plot');
            if (pendingPlotData) {
                loadPlotly(function() { renderCurrentPlot(); });
            }
        });
    });

    // ========== Collapsible Toggles ==========
    function setupToggle(btnId, contentId) {
        var btn = document.getElementById(btnId);
        var content = document.getElementById(contentId);
        if (!btn || !content) return;
        btn.addEventListener('click', function() {
            content.classList.toggle('open');
            var chevron = btn.querySelector('svg');
            if (chevron) chevron.style.transform = content.classList.contains('open') ? 'rotate(180deg)' : '';
        });
    }
    setupToggle('lm-syntax-btn', 'lm-syntax-content');
    setupToggle('lm-notation-btn', 'lm-notation-content');

    // ========== Random Button ==========
    document.getElementById('lm-random-btn').addEventListener('click', function() {
        var keys = Object.keys(SYSTEMS);
        var key = keys[Math.floor(Math.random() * keys.length)];
        systemSelect.value = key;
        currentSystemType = key;
        var sys = SYSTEMS[key];
        kineticInput.value = sys.T;
        potentialInput.value = sys.V;
        coordsInput.value = sys.coords;
        paramsInput.value = sys.params;
        icInput.value = sys.ic;
        tspanInput.value = sys.tspan;
        updatePreview();
        runAllValidation();
    });

    // ========== Live Preview ==========
    var previewTimer = null;
    function bindPreviewInput(el) {
        if (!el) return;
        el.addEventListener('input', function() {
            clearTimeout(previewTimer);
            previewTimer = setTimeout(updatePreview, 200);
        });
    }
    bindPreviewInput(kineticInput);
    bindPreviewInput(potentialInput);

    function updatePreview() {
        try {
            var T = normalizeExpr(kineticInput.value.trim());
            var V = normalizeExpr(potentialInput.value.trim());
            if (!T && !V) {
                previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Enter T and V above\u2026</span>';
                return;
            }
            var tLatex = T ? exprToLatex(T) : '?';
            var vLatex = V ? exprToLatex(V) : '?';
            var latex = 'L = ' + tLatex + ' - \\left(' + vLatex + '\\right)';
            katex.render(latex, previewEl, { displayMode: true, throwOnError: false });
        } catch (e) {
            previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Invalid expression</span>';
        }
    }

    // ========== Build SymPy Code ==========
    function buildSympyCode() {
        var T_raw = normalizeExpr(kineticInput.value.trim());
        var V_raw = normalizeExpr(potentialInput.value.trim());
        var coordStr = coordsInput.value.trim();
        var paramStr = paramsInput.value.trim();
        var icStr = icInput.value.trim();
        var tspanStr = tspanInput.value.trim();

        var coords = parseCoords(coordStr);
        var params = parseParams(paramStr);
        var ics = parseIC(icStr);
        var tspan = tspanStr.split(',').map(function(s) { return parseFloat(s.trim()); });
        if (tspan.length < 2) tspan = [0, 10];

        var T_py = exprToPython(T_raw);
        var V_py = exprToPython(V_raw);

        var code = '';
        code += 'import sympy as sp\n';
        code += 'from sympy import symbols, Function, cos, sin, tan, sqrt, exp, log, pi, Rational, simplify, diff, latex, solve\n';
        code += 'import json\n';
        code += 'import numpy as np\n';
        code += 'from scipy.integrate import solve_ivp\n\n';

        code += 't = symbols("t")\n';

        // Declare parameters
        var paramNames = Object.keys(params);
        if (paramNames.length > 0) {
            code += paramNames.join(', ') + ' = symbols("' + paramNames.join(' ') + '", positive=True)\n';
        }

        // Declare generalized coords as Functions of t
        coords.forEach(function(q) {
            code += q + ' = Function("' + q + '")(t)\n';
        });
        code += '\n';

        // Build velocity symbol replacements
        // In the user's expression, dtheta -> Derivative(theta(t), t)
        var velReplacements = [];
        coords.forEach(function(q) {
            velReplacements.push({ from: 'd' + q, to: q + '.diff(t)' });
        });

        // Build T and V expressions with velocity replacements
        var T_expr = T_py;
        var V_expr = V_py;
        velReplacements.forEach(function(r) {
            // Replace d<coord> with <coord>.diff(t) — handle **2 etc
            var regex = new RegExp('\\b' + r.from + '\\b', 'g');
            T_expr = T_expr.replace(regex, '(' + r.to + ')');
            V_expr = V_expr.replace(regex, '(' + r.to + ')');
        });

        code += 'T = ' + T_expr + '\n';
        code += 'V = ' + V_expr + '\n';
        code += 'L = T - V\n';
        code += 'L = sp.expand(L)\n\n';

        code += 'print("LAGRANGIAN:" + latex(L))\n\n';

        // Euler-Lagrange equations
        code += 'coords = [' + coords.map(function(q) { return q; }).join(', ') + ']\n';
        code += 'eoms = []\n';
        code += 'momenta = []\n';
        code += 'steps_data = []\n';
        code += 'steps_data.append({"title": "Lagrangian", "latex": "L = " + latex(L)})\n\n';

        code += 'for q in coords:\n';
        code += '    dq = q.diff(t)\n';
        code += '    # Partial derivatives\n';
        code += '    dL_dq = diff(L, q)\n';
        code += '    dL_ddq = diff(L, dq)\n';
        code += '    dt_dL_ddq = diff(dL_ddq, t)\n';
        code += '    eom = sp.simplify(dt_dL_ddq - dL_dq)\n';
        code += '    eoms.append(eom)\n';
        code += '    p = dL_ddq\n';
        code += '    momenta.append(p)\n';
        code += '    qname = str(q).replace("(t)", "")\n';
        code += '    steps_data.append({"title": "dL/d" + qname, "latex": "\\\\frac{\\\\partial L}{\\\\partial " + latex(q) + "} = " + latex(dL_dq)})\n';
        code += '    steps_data.append({"title": "dL/d" + qname + "_dot", "latex": "\\\\frac{\\\\partial L}{\\\\partial " + latex(dq) + "} = " + latex(dL_ddq)})\n';
        code += '    steps_data.append({"title": "d/dt(dL/d" + qname + "_dot)", "latex": "\\\\frac{d}{dt}\\\\frac{\\\\partial L}{\\\\partial " + latex(dq) + "} = " + latex(dt_dL_ddq)})\n';
        code += '    steps_data.append({"title": "EOM for " + qname, "latex": latex(eom) + " = 0"})\n';
        code += '    steps_data.append({"title": "Conjugate momentum p_" + qname, "latex": "p_{" + qname + "} = " + latex(p)})\n\n';

        // Print EOM
        code += 'eom_strs = []\n';
        code += 'for i, q in enumerate(coords):\n';
        code += '    eom_strs.append(latex(eoms[i]) + " = 0")\n';
        code += 'print("EOM:" + json.dumps(eom_strs))\n\n';

        // Print momenta
        code += 'mom_strs = []\n';
        code += 'for i, q in enumerate(coords):\n';
        code += '    qname = str(q).replace("(t)", "")\n';
        code += '    mom_strs.append("p_{" + qname + "} = " + latex(momenta[i]))\n';
        code += 'print("MOMENTA:" + json.dumps(mom_strs))\n\n';

        // Hamiltonian
        code += '# Hamiltonian\n';
        code += 'H = sum(momenta[i] * coords[i].diff(t) for i in range(len(coords))) - L\n';
        code += 'H = sp.simplify(H)\n';
        code += 'print("HAMILTONIAN:" + latex(H))\n';
        code += 'steps_data.append({"title": "Hamiltonian", "latex": "H = " + latex(H)})\n\n';

        // Conservation laws
        code += '# Conservation laws\n';
        code += 'conservation = []\n';
        code += 'for i, q in enumerate(coords):\n';
        code += '    qname = str(q).replace("(t)", "")\n';
        code += '    dL_dq_val = diff(L, q)\n';
        code += '    if sp.simplify(dL_dq_val) == 0:\n';
        code += '        conservation.append({"coord": qname, "type": "cyclic", "conserved": "p_" + qname})\n';
        code += '# Check if L depends explicitly on t\n';
        code += 'dL_dt = diff(L, t)\n';
        code += 'for q in coords:\n';
        code += '    dL_dt = dL_dt.subs(q.diff(t, 2), 0)  # remove accelerations for check\n';
        code += 'if sp.simplify(dL_dt) == 0:\n';
        code += '    conservation.append({"coord": "t", "type": "time_invariant", "conserved": "H (energy)"})\n';
        code += 'print("CONSERVATION:" + json.dumps(conservation))\n\n';

        // Hamilton's equations
        code += '# Hamilton equations (symbolic)\n';
        code += 'ham_eqs = []\n';
        code += 'for i, q in enumerate(coords):\n';
        code += '    qname = str(q).replace("(t)", "")\n';
        code += '    ham_eqs.append({"q": qname, "qdot": latex(coords[i].diff(t)), "pdot": latex(-diff(L, coords[i]))})\n';
        code += 'print("HAM_EQS:" + json.dumps(ham_eqs))\n\n';

        // Numerical integration
        code += '# Numerical integration\n';
        code += 'try:\n';
        // We need to solve for second derivatives
        code += '    # Solve EOM for accelerations\n';
        code += '    accels = [q.diff(t, 2) for q in coords]\n';
        code += '    eom_eqs = [sp.Eq(eom, 0) for eom in eoms]\n';
        code += '    accel_sol = solve(eom_eqs, accels)\n';
        code += '    if not isinstance(accel_sol, dict):\n';
        code += '        accel_sol = {}\n';
        code += '        for i, a in enumerate(accels):\n';
        code += '            try:\n';
        code += '                sol = solve(eoms[i], a)\n';
        code += '                if sol:\n';
        code += '                    accel_sol[a] = sol[0]\n';
        code += '            except:\n';
        code += '                pass\n\n';

        // Build numerical function
        code += '    # Parameter substitution\n';
        code += '    param_subs = {' + paramNames.map(function(p) { return p + ': ' + params[p]; }).join(', ') + '}\n';

        code += '    # Build numerical RHS\n';
        code += '    from sympy import lambdify\n';
        code += '    # State: [q1, q2, ..., dq1, dq2, ...]\n';
        code += '    n = len(coords)\n';
        code += '    q_syms = []\n';
        code += '    dq_syms = []\n';
        code += '    for q in coords:\n';
        code += '        qname = str(q).replace("(t)", "")\n';
        code += '        q_syms.append(sp.Symbol(qname))\n';
        code += '        dq_syms.append(sp.Symbol("d" + qname))\n';
        code += '    all_syms = q_syms + dq_syms\n\n';

        code += '    accel_exprs = []\n';
        code += '    for i, q in enumerate(coords):\n';
        code += '        a = accels[i]\n';
        code += '        if a in accel_sol:\n';
        code += '            expr = accel_sol[a]\n';
        code += '        else:\n';
        code += '            expr = sp.Integer(0)\n';
        code += '        # Substitute params\n';
        code += '        expr = expr.subs(param_subs)\n';
        code += '        # Replace Function(t) with Symbol\n';
        code += '        for j, c in enumerate(coords):\n';
        code += '            expr = expr.subs(c.diff(t), dq_syms[j])\n';
        code += '            expr = expr.subs(c, q_syms[j])\n';
        code += '        accel_exprs.append(expr)\n\n';

        code += '    accel_funcs = [lambdify(all_syms, ae, modules="numpy") for ae in accel_exprs]\n\n';

        code += '    def rhs(t_val, y):\n';
        code += '        derivs = list(y[n:])  # velocities\n';
        code += '        args = list(y)\n';
        code += '        for af in accel_funcs:\n';
        code += '            derivs.append(float(af(*args)))\n';
        code += '        return derivs\n\n';

        // Initial conditions
        code += '    # Initial conditions\n';
        code += '    y0 = []\n';
        var allCoords = coords;
        allCoords.forEach(function(q) {
            var qVal = ics[q] !== undefined ? ics[q] : 0;
            code += '    y0.append(' + qVal + ')  # ' + q + '(0)\n';
        });
        allCoords.forEach(function(q) {
            var dqVal = ics['d' + q] !== undefined ? ics['d' + q] : 0;
            code += '    y0.append(' + dqVal + ')  # d' + q + '(0)\n';
        });

        code += '    t_eval = np.linspace(' + tspan[0] + ', ' + tspan[1] + ', 300)\n';
        code += '    sol = solve_ivp(rhs, [' + tspan[0] + ', ' + tspan[1] + '], y0, t_eval=t_eval, method="RK45", max_step=0.01)\n\n';

        code += '    print("NUM_T:" + json.dumps(sol.t.tolist()))\n';
        code += '    # q values\n';
        code += '    q_data = {}\n';
        code += '    for i in range(n):\n';
        code += '        qname = str(coords[i]).replace("(t)", "")\n';
        code += '        q_data[qname] = sol.y[i].tolist()\n';
        code += '    print("NUM_Q:" + json.dumps(q_data))\n';
        code += '    # velocity values\n';
        code += '    p_data = {}\n';
        code += '    for i in range(n):\n';
        code += '        qname = str(coords[i]).replace("(t)", "")\n';
        code += '        p_data["d" + qname] = sol.y[n + i].tolist()\n';
        code += '    print("NUM_P:" + json.dumps(p_data))\n\n';

        // Energy computation
        code += '    # Energy\n';
        code += '    T_expr_num = T.subs(param_subs)\n';
        code += '    V_expr_num = V.subs(param_subs)\n';
        code += '    for j, c in enumerate(coords):\n';
        code += '        T_expr_num = T_expr_num.subs(c.diff(t), dq_syms[j]).subs(c, q_syms[j])\n';
        code += '        V_expr_num = V_expr_num.subs(c.diff(t), dq_syms[j]).subs(c, q_syms[j])\n';
        code += '    T_func = lambdify(all_syms, T_expr_num, modules="numpy")\n';
        code += '    V_func = lambdify(all_syms, V_expr_num, modules="numpy")\n';
        code += '    E_kin = []\n';
        code += '    E_pot = []\n';
        code += '    E_tot = []\n';
        code += '    for k in range(len(sol.t)):\n';
        code += '        args = list(sol.y[:, k])\n';
        code += '        tk = float(T_func(*args))\n';
        code += '        vk = float(V_func(*args))\n';
        code += '        E_kin.append(tk)\n';
        code += '        E_pot.append(vk)\n';
        code += '        E_tot.append(tk + vk)\n';
        code += '    print("NUM_E:" + json.dumps({"T": E_kin, "V": E_pot, "E": E_tot}))\n\n';

        code += 'except Exception as ex:\n';
        code += '    print("NUM_ERROR:" + str(ex))\n\n';

        code += 'print("STEPS:" + json.dumps(steps_data))\n';

        return code;
    }

    // ========== Compute ==========
    computeBtn.addEventListener('click', doCompute);
    kineticInput.addEventListener('keydown', function(e) { if (e.key === 'Enter') doCompute(); });

    var isComputing = false;
    var computeBtnLabel = 'Compute';

    function setComputingState(active) {
        isComputing = active;
        computeBtn.disabled = active;
        if (active) {
            computeBtn.innerHTML = '<span class="lm-spinner" style="width:14px;height:14px;border-width:2px;display:inline-block;vertical-align:middle;margin-right:0.375rem;"></span>Computing\u2026';
            computeBtn.style.opacity = '0.7';
            computeBtn.style.pointerEvents = 'none';
        } else {
            computeBtn.textContent = computeBtnLabel;
            computeBtn.style.opacity = '';
            computeBtn.style.pointerEvents = '';
        }
    }

    function doCompute() {
        if (isComputing) return;

        var T = kineticInput.value.trim();
        var V = potentialInput.value.trim();
        var coords = coordsInput.value.trim();
        if (!T || !V || !coords) {
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Please enter T, V, and coordinates.', 2000, 'warning');
            return;
        }

        // Run validation and block if critical errors
        runAllValidation();
        var vT = validateExpr(T);
        var vV = validateExpr(V);
        var vC = validateCoords(coords);
        if (!vT.valid || !vV.valid || !vC.valid) {
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Fix validation errors before computing.', 2500, 'warning');
            return;
        }

        setComputingState(true);

        // Scroll output into view on mobile
        var outputCol = document.querySelector('.tool-output-column');
        if (outputCol && window.innerWidth <= 900) {
            outputCol.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }

        resultActions.classList.remove('visible');
        resultContent.innerHTML = '<div style="text-align:center;padding:2rem;">' +
            '<div class="lm-spinner" style="width:24px;height:24px;border-width:3px;margin:0 auto 1rem;"></div>' +
            '<p style="color:var(--text-secondary);font-size:0.9375rem;">Computing Euler-Lagrange equations\u2026</p></div>';
        if (emptyState) emptyState.style.display = 'none';

        var code = buildSympyCode();

        var controller = new AbortController();
        var timeoutId = setTimeout(function() { controller.abort(); }, 120000);

        fetch((window.LM_CALC_CTX || '') + '/OneCompilerFunctionality?action=execute', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ language: 'python', version: '3.10', code: code }),
            signal: controller.signal
        })
        .then(function(r) { return r.json(); })
        .then(function(data) {
            clearTimeout(timeoutId);
            setComputingState(false);
            var stdout = (data.Stdout || data.stdout || '').trim();
            var stderr = (data.Stderr || data.stderr || '').trim();

            if (!stdout || (stderr && /error|exception|traceback/i.test(stderr) && !stdout)) {
                showError(stderr || 'Computation failed. Check your expression syntax.');
                return;
            }

            var errMatch = stdout.match(/ERROR:(.+)/);
            if (errMatch) {
                showError(errMatch[1].trim());
                return;
            }

            parseAndShowResult(stdout);
        })
        .catch(function(err) {
            clearTimeout(timeoutId);
            setComputingState(false);
            showError(err.name === 'AbortError' ? 'Request timed out (120s). Try a simpler system.' : err.message);
        });
    }

    // ========== Parse & Display Result ==========
    function parseAndShowResult(stdout) {
        var lagrangianMatch = stdout.match(/LAGRANGIAN:([^\n]*)/);
        var eomMatch = stdout.match(/EOMS?:(\[[\s\S]*?\])(?=\n[A-Z]|$)/);
        var momentaMatch = stdout.match(/MOMENTA:(\[[\s\S]*?\])(?=\n[A-Z]|$)/);
        var hamiltonianMatch = stdout.match(/HAMILTONIAN:([^\n]*)/);
        var conservationMatch = stdout.match(/CONSERVATION:(\[[\s\S]*?\])(?=\n[A-Z]|$)/);
        var hamEqsMatch = stdout.match(/HAM_EQS:(\[[\s\S]*?\])(?=\n[A-Z]|$)/);
        var stepsMatch = stdout.match(/STEPS:(\[[\s\S]*?\])$/m);
        var numTMatch = stdout.match(/NUM_T:(\[[\s\S]*?\])(?=\n|$)/);
        var numQMatch = stdout.match(/NUM_Q:(\{[\s\S]*?\})(?=\n|$)/);
        var numPMatch = stdout.match(/NUM_P:(\{[\s\S]*?\})(?=\n|$)/);
        var numEMatch = stdout.match(/NUM_E:(\{[\s\S]*?\})(?=\n|$)/);

        var lagrangian = lagrangianMatch ? lagrangianMatch[1].trim() : '';
        var eoms = []; try { if (eomMatch) eoms = JSON.parse(eomMatch[1]); } catch(e) {}
        var momenta = []; try { if (momentaMatch) momenta = JSON.parse(momentaMatch[1]); } catch(e) {}
        var hamiltonian = hamiltonianMatch ? hamiltonianMatch[1].trim() : '';
        var conservation = []; try { if (conservationMatch) conservation = JSON.parse(conservationMatch[1]); } catch(e) {}
        var hamEqs = []; try { if (hamEqsMatch) hamEqs = JSON.parse(hamEqsMatch[1]); } catch(e) {}
        var steps = []; try { if (stepsMatch) steps = JSON.parse(stepsMatch[1]); } catch(e) {}
        var numT = []; try { if (numTMatch) numT = JSON.parse(numTMatch[1]); } catch(e) {}
        var numQ = {}; try { if (numQMatch) numQ = JSON.parse(numQMatch[1]); } catch(e) {}
        var numP = {}; try { if (numPMatch) numP = JSON.parse(numPMatch[1]); } catch(e) {}
        var numE = {}; try { if (numEMatch) numE = JSON.parse(numEMatch[1]); } catch(e) {}

        lastResultLatex = 'L = ' + lagrangian;

        // Store for plots and animation
        pendingPlotData = { t: numT, q: numQ, p: numP, e: numE };

        // Show steps tab
        showStepsResult(lagrangian, eoms, momenta, hamiltonian, conservation, steps);

        // Show Hamiltonian tab
        showHamiltonian(hamiltonian, hamEqs, momenta, conservation);

        // If plots tab is active, render
        var plotsPanel = document.getElementById('lm-panel-plots');
        if (plotsPanel.classList.contains('active') && pendingPlotData.t.length > 0) {
            loadPlotly(function() { renderCurrentPlot(); });
        }
        if (graphHint) graphHint.style.display = numT.length > 0 ? 'none' : '';

        // If animation tab active, start
        var animPanel = document.getElementById('lm-panel-animation');
        if (animPanel.classList.contains('active') && pendingPlotData.t.length > 0) {
            if (animationsLoaded) {
                startAnimation();
            } else {
                loadD3(function() {
                    var s = document.createElement('script');
                    s.src = (window.LM_CALC_CTX || '') + '/modern/js/lagrangian-animations.js?v=' + Date.now();
                    s.onload = function() {
                        animationsLoaded = true;
                        startAnimation();
                    };
                    document.head.appendChild(s);
                });
            }
        }

        resultActions.classList.add('visible');

        // Scroll result into view on desktop too
        var resultCard = document.querySelector('#lm-panel-steps .tool-result-card');
        if (resultCard) {
            resultCard.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
            // Also scroll result content to top
            if (resultContent) resultContent.scrollTop = 0;
        }
    }

    // ========== Steps Result ==========
    function showStepsResult(lagrangian, eoms, momenta, hamiltonian, conservation, steps) {
        var html = '<div class="lm-result-math">';

        // Lagrangian
        html += '<div class="lm-result-label">Lagrangian</div>';
        html += '<div id="lm-r-lagrangian" style="font-size:1.1rem;padding:0.5rem 0;"></div>';

        // Equations of Motion
        html += '<div class="lm-result-label" style="margin-top:1rem;">Equations of Motion</div>';
        for (var i = 0; i < eoms.length; i++) {
            html += '<div id="lm-r-eom-' + i + '" style="font-size:1rem;padding:0.25rem 0;"></div>';
        }

        // Conjugate Momenta
        html += '<div class="lm-result-label" style="margin-top:1rem;">Conjugate Momenta</div>';
        for (var j = 0; j < momenta.length; j++) {
            html += '<div id="lm-r-mom-' + j + '" style="font-size:1rem;padding:0.25rem 0;"></div>';
        }

        // Hamiltonian
        html += '<div class="lm-result-label" style="margin-top:1rem;">Hamiltonian</div>';
        html += '<div id="lm-r-hamiltonian" style="font-size:1.1rem;padding:0.5rem 0;"></div>';

        // Conservation Laws
        if (conservation.length > 0) {
            html += '<div class="lm-result-label" style="margin-top:1rem;">Conservation Laws</div>';
            html += '<div style="display:flex;flex-wrap:wrap;gap:0.375rem;padding:0.5rem 0;">';
            for (var c = 0; c < conservation.length; c++) {
                var cl = conservation[c];
                html += '<span class="lm-conservation-badge conserved">';
                html += escapeHtml(cl.conserved) + ' conserved';
                if (cl.type === 'cyclic') html += ' (' + escapeHtml(cl.coord) + ' cyclic)';
                if (cl.type === 'time_invariant') html += ' (time-invariant)';
                html += '</span>';
            }
            html += '</div>';
        }

        // Steps toggle
        html += '<div style="margin-top:1rem;">';
        html += '<button type="button" class="tool-action-btn" id="lm-steps-toggle" style="font-size:0.8125rem;">&#128221; Show Derivation Steps</button>';
        html += '</div>';
        html += '<div id="lm-steps-area"></div>';

        html += '</div>';
        resultContent.innerHTML = html;

        // Render KaTeX
        try { katex.render('L = ' + lagrangian, document.getElementById('lm-r-lagrangian'), { displayMode: true, throwOnError: false }); } catch(e) {}
        for (var ei = 0; ei < eoms.length; ei++) {
            try { katex.render(prepareLatexForKatex(eoms[ei]), document.getElementById('lm-r-eom-' + ei), { displayMode: true, throwOnError: false }); } catch(e) {}
        }
        for (var mi = 0; mi < momenta.length; mi++) {
            try { katex.render(prepareLatexForKatex(momenta[mi]), document.getElementById('lm-r-mom-' + mi), { displayMode: true, throwOnError: false }); } catch(e) {}
        }
        try { katex.render('H = ' + hamiltonian, document.getElementById('lm-r-hamiltonian'), { displayMode: true, throwOnError: false }); } catch(e) {}

        // Steps toggle
        var stepsToggle = document.getElementById('lm-steps-toggle');
        if (stepsToggle) {
            stepsToggle.addEventListener('click', function() {
                renderSteps(steps);
                this.style.display = 'none';
            });
        }
    }

    // ========== Steps ==========
    function renderSteps(steps) {
        var container = document.getElementById('lm-steps-area');
        if (!container || !steps || steps.length === 0) {
            if (container) container.innerHTML = '<div style="padding:0.75rem;font-size:0.8125rem;color:var(--text-muted);">No steps available.</div>';
            return;
        }

        var html = '<div class="lm-steps-container">';
        html += '<div class="lm-steps-header">';
        html += '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;flex-shrink:0;"><path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>';
        html += 'Derivation Steps <span style="font-weight:400;color:var(--text-muted);margin-left:0.25rem;">(' + steps.length + ')</span>';
        html += '<span class="lm-steps-sympy-badge">SymPy CAS</span>';
        html += '</div>';

        for (var i = 0; i < steps.length; i++) {
            html += '<div class="lm-step">';
            html += '<span class="lm-step-num">' + (i + 1) + '</span>';
            html += '<div class="lm-step-body">';
            html += '<div class="lm-step-title">' + escapeHtml(steps[i].title) + '</div>';
            html += '<div class="lm-step-math" id="lm-step-math-' + i + '"></div>';
            html += '</div></div>';
        }
        html += '</div>';
        container.innerHTML = html;

        for (var j = 0; j < steps.length; j++) {
            var el = document.getElementById('lm-step-math-' + j);
            if (el && steps[j].latex) {
                try {
                    katex.render(prepareLatexForKatex(steps[j].latex), el, { displayMode: true, throwOnError: false });
                } catch (e) {
                    el.textContent = steps[j].latex;
                }
            }
        }
    }

    // ========== Hamiltonian Tab ==========
    function showHamiltonian(hamiltonian, hamEqs, momenta, conservation) {
        var html = '';

        // Hamiltonian
        html += '<h4>Hamiltonian</h4>';
        html += '<div class="lm-hamiltonian-math" id="lm-ham-main"></div>';

        // Hamilton's Equations
        if (hamEqs.length > 0) {
            html += '<h4>Hamilton\'s Equations</h4>';
            for (var i = 0; i < hamEqs.length; i++) {
                html += '<div id="lm-ham-eq-' + i + '" class="lm-hamiltonian-math"></div>';
            }
        }

        // Canonical Variables Table
        if (hamEqs.length > 0) {
            html += '<h4>Canonical Variables</h4>';
            html += '<table class="lm-canonical-table">';
            html += '<thead><tr><th>Coordinate q</th><th>Momentum p</th></tr></thead>';
            html += '<tbody>';
            for (var j = 0; j < hamEqs.length; j++) {
                html += '<tr>';
                html += '<td id="lm-can-q-' + j + '"></td>';
                html += '<td id="lm-can-p-' + j + '"></td>';
                html += '</tr>';
            }
            html += '</tbody></table>';
        }

        // Conservation Laws
        if (conservation.length > 0) {
            html += '<h4>Conservation Laws</h4>';
            html += '<div style="display:flex;flex-wrap:wrap;gap:0.375rem;">';
            for (var c = 0; c < conservation.length; c++) {
                var cl = conservation[c];
                html += '<span class="lm-conservation-badge conserved">';
                html += escapeHtml(cl.conserved) + ' conserved';
                html += '</span>';
            }
            html += '</div>';
        }

        hamiltonianContent.innerHTML = html;

        // Render KaTeX
        try { katex.render('H = ' + hamiltonian, document.getElementById('lm-ham-main'), { displayMode: true, throwOnError: false }); } catch(e) {}

        for (var ei = 0; ei < hamEqs.length; ei++) {
            var eq = hamEqs[ei];
            try {
                var eqLatex = '\\dot{' + eq.q + '} = ' + prepareLatexForKatex(eq.qdot) + ', \\quad \\dot{p}_{' + eq.q + '} = ' + prepareLatexForKatex(eq.pdot);
                katex.render(eqLatex, document.getElementById('lm-ham-eq-' + ei), { displayMode: true, throwOnError: false });
            } catch(e) {}

            // Canonical table
            try { katex.render(eq.q, document.getElementById('lm-can-q-' + ei), { throwOnError: false }); } catch(e) {}
            try { katex.render('p_{' + eq.q + '}', document.getElementById('lm-can-p-' + ei), { throwOnError: false }); } catch(e) {}
        }
    }

    // ========== Plots ==========
    function renderCurrentPlot() {
        if (!window.Plotly || !pendingPlotData || !pendingPlotData.t || pendingPlotData.t.length === 0) return;
        var container = document.getElementById('lm-graph-container');
        var isDark = document.documentElement.getAttribute('data-theme') === 'dark';

        var plotColor = '#7c3aed';
        var plotColor2 = '#8b5cf6';
        var gridColor = isDark ? '#334155' : '#e2e8f0';
        var textColor = isDark ? '#cbd5e1' : '#475569';
        var zeroColor = isDark ? '#475569' : '#94a3b8';
        var bgColor = isDark ? '#1e293b' : '#fff';

        var baseLayout = {
            margin: { t: 30, r: 20, b: 50, l: 60 },
            paper_bgcolor: bgColor,
            plot_bgcolor: bgColor,
            font: { family: 'Inter, sans-serif', size: 12, color: textColor }
        };

        function axStyle(title) {
            return {
                title: title,
                gridcolor: gridColor,
                color: textColor,
                zerolinecolor: zeroColor
            };
        }

        var traces = [];
        var layout = Object.assign({}, baseLayout);

        if (currentPlotType === 'trajectory') {
            var qNames = Object.keys(pendingPlotData.q);
            var colors = [plotColor, '#ec4899', '#f59e0b', '#10b981'];
            for (var i = 0; i < qNames.length; i++) {
                traces.push({
                    x: pendingPlotData.t,
                    y: pendingPlotData.q[qNames[i]],
                    type: 'scatter', mode: 'lines',
                    line: { color: colors[i % colors.length], width: 2 },
                    name: qNames[i] + '(t)'
                });
            }
            layout.xaxis = axStyle('t');
            layout.yaxis = axStyle('q(t)');
        } else if (currentPlotType === 'phase') {
            var qNames = Object.keys(pendingPlotData.q);
            var pNames = Object.keys(pendingPlotData.p);
            var colors = [plotColor, '#ec4899', '#f59e0b', '#10b981'];
            for (var i = 0; i < qNames.length && i < pNames.length; i++) {
                traces.push({
                    x: pendingPlotData.q[qNames[i]],
                    y: pendingPlotData.p[pNames[i]],
                    type: 'scatter', mode: 'lines',
                    line: { color: colors[i % colors.length], width: 2 },
                    name: qNames[i] + ' vs d' + qNames[i]
                });
            }
            layout.xaxis = axStyle('q');
            layout.yaxis = axStyle('dq/dt');
        } else if (currentPlotType === 'energy') {
            if (pendingPlotData.e.T) {
                traces.push({
                    x: pendingPlotData.t, y: pendingPlotData.e.T,
                    type: 'scatter', mode: 'lines',
                    line: { color: '#ef4444', width: 2 }, name: 'Kinetic (T)'
                });
                traces.push({
                    x: pendingPlotData.t, y: pendingPlotData.e.V,
                    type: 'scatter', mode: 'lines',
                    line: { color: '#3b82f6', width: 2 }, name: 'Potential (V)'
                });
                traces.push({
                    x: pendingPlotData.t, y: pendingPlotData.e.E,
                    type: 'scatter', mode: 'lines',
                    line: { color: plotColor, width: 2.5, dash: 'dash' }, name: 'Total (E)'
                });
            }
            layout.xaxis = axStyle('t');
            layout.yaxis = axStyle('Energy');
        } else if (currentPlotType === 'potential') {
            // Plot V vs first coordinate
            var qNames = Object.keys(pendingPlotData.q);
            if (qNames.length > 0 && pendingPlotData.e.V) {
                traces.push({
                    x: pendingPlotData.q[qNames[0]],
                    y: pendingPlotData.e.V,
                    type: 'scatter', mode: 'lines',
                    line: { color: '#3b82f6', width: 2 }, name: 'V(' + qNames[0] + ')'
                });
                // Mark current position
                if (pendingPlotData.e.E) {
                    traces.push({
                        x: [pendingPlotData.q[qNames[0]][0]],
                        y: [pendingPlotData.e.V[0]],
                        type: 'scatter', mode: 'markers',
                        marker: { color: plotColor, size: 10 }, name: 'Start'
                    });
                }
            }
            layout.xaxis = axStyle(qNames[0] || 'q');
            layout.yaxis = axStyle('V');
        }

        Plotly.newPlot(container, traces, layout, { responsive: true, displayModeBar: true, modeBarButtonsToRemove: ['lasso2d', 'select2d'] });
    }

    // ========== Animation ==========
    function startAnimation() {
        if (!window.LagrangianAnimations || !pendingPlotData || !pendingPlotData.t || pendingPlotData.t.length === 0) return;

        var sys = SYSTEMS[currentSystemType];
        var animType = sys ? sys.animationType : 'custom';
        var area = document.getElementById('lm-animation-area');

        window.LagrangianAnimations.init({
            container: area,
            type: animType,
            data: pendingPlotData,
            params: parseParams(paramsInput.value)
        });
    }

    // Animation controls
    document.getElementById('lm-anim-play').addEventListener('click', function() {
        if (window.LagrangianAnimations) window.LagrangianAnimations.play();
    });
    document.getElementById('lm-anim-pause').addEventListener('click', function() {
        if (window.LagrangianAnimations) window.LagrangianAnimations.pause();
    });
    document.getElementById('lm-anim-reset').addEventListener('click', function() {
        if (window.LagrangianAnimations) window.LagrangianAnimations.reset();
    });
    document.getElementById('lm-speed-slider').addEventListener('input', function() {
        var speed = parseFloat(this.value);
        document.getElementById('lm-speed-label').textContent = speed + 'x';
        if (window.LagrangianAnimations) window.LagrangianAnimations.setSpeed(speed);
    });

    // ========== Error State ==========
    function showError(msg) {
        resultActions.classList.remove('visible');
        var html = '<div class="lm-error">';
        html += '<h4>Computation Error</h4>';
        html += '<p>' + escapeHtml(msg) + '</p>';
        html += '<ul>';
        html += '<li>Check expression syntax (see Syntax Help)</li>';
        html += '<li>Use explicit multiplication: m*g*l not mgl</li>';
        html += '<li>Use d<var>q</var> for velocity: dtheta, dx, dr</li>';
        html += '<li>Ensure coordinates match those used in T and V</li>';
        html += '<li>Parameters must be defined: m=1, g=9.8</li>';
        html += '</ul>';
        html += '</div>';
        resultContent.innerHTML = html;
        if (emptyState) emptyState.style.display = 'none';
    }

    // ========== Copy LaTeX ==========
    document.getElementById('lm-copy-latex-btn').addEventListener('click', function() {
        if (typeof ToolUtils !== 'undefined') {
            ToolUtils.copyToClipboard(lastResultLatex, 'LaTeX copied!');
        } else {
            navigator.clipboard.writeText(lastResultLatex);
        }
    });

    // ========== Share ==========
    document.getElementById('lm-share-btn').addEventListener('click', function() {
        var url = window.location.href.split('?')[0];
        if (typeof ToolUtils !== 'undefined') {
            ToolUtils.copyToClipboard(url, 'URL copied!');
        } else {
            navigator.clipboard.writeText(url);
        }
    });

})();
