/**
 * compute.js — 3-tier math computation engine
 * TipTap-based Math Editor
 *
 * Tier 1: CortexJS Compute Engine (client, connected to MathLive)
 *         expr.simplify(), expr.evaluate(), expr.N(), box([Op,...])
 *
 * Tier 2: Nerdamer (client, lazy-loaded CDN)
 *         nerdamer.solve(), nerdamer.diff(), integrate, expand, factor
 *
 * Tier 3: SymPy (server, via /OneCompilerFunctionality)
 *         Full symbolic CAS — solve, integrate, simplify, factor
 *
 * All tiers lazy-loaded. isUseful() is the only filter (presentation, not math).
 *
 * Three UX layers:
 *   Layer 1: Auto-Result — subtle computed result below block equations
 *   Layer 2: Action Bar  — floating bar with topic-aware math actions
 *   Layer 3: Shift+Enter — appends "= result" inside the math-field
 */
(function () {
    'use strict';

    // =========================================================
    //  TIER 1: CortexJS Compute Engine (lazy ESM import)
    // =========================================================
    var ce = null;
    var ceLoading = null;

    function getCE() {
        if (ce) return Promise.resolve(ce);
        if (ceLoading) return ceLoading;
        ceLoading = import('https://esm.sh/@cortex-js/compute-engine').then(function (mod) {
            ce = new mod.ComputeEngine();
            if (window.MathfieldElement) {
                window.MathfieldElement.computeEngine = ce;
            }
            return ce;
        }).catch(function (err) {
            console.warn('CE failed to load:', err);
            ceLoading = null;
            return null;
        });
        return ceLoading;
    }

    // =========================================================
    //  TIER 2: Nerdamer (lazy script-tag load)
    //  Loads: core → Algebra → Calculus → Solve (sequential)
    // =========================================================
    var nerd = null;
    var nerdLoading = null;
    var NERDAMER_CDN = 'https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/';
    var NERDAMER_MODULES = ['nerdamer.core.min.js', 'Algebra.min.js', 'Calculus.min.js', 'Solve.min.js'];

    var nerdamerFailed = false;

    function getNerdamer() {
        if (nerd) return Promise.resolve(nerd);
        if (nerdLoading) return nerdLoading;
        nerdLoading = loadScriptsSequential(NERDAMER_MODULES.map(function (m) {
            return NERDAMER_CDN + m;
        })).then(function () {
            nerd = window.nerdamer;
            return nerd;
        }).catch(function (err) {
            console.warn('Nerdamer failed to load:', err);
            nerdamerFailed = true;
            nerdLoading = null;
            return null;
        });
        return nerdLoading;
    }

    function loadScriptsSequential(urls) {
        return urls.reduce(function (chain, url) {
            return chain.then(function () {
                return new Promise(function (resolve, reject) {
                    var s = document.createElement('script');
                    s.src = url;
                    s.onload = resolve;
                    s.onerror = function () { reject(new Error('Failed to load: ' + url)); };
                    document.head.appendChild(s);
                });
            });
        }, Promise.resolve());
    }

    // =========================================================
    //  TIER 3: SymPy (server-side via OneCompilerFunctionality)
    // =========================================================
    function runSymPy(code) {
        var ctx = window.ME_CTX || '';
        var controller = new AbortController();
        var timeoutId = setTimeout(function () { controller.abort(); }, 30000);

        return fetch(ctx + '/OneCompilerFunctionality?action=execute', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ language: 'python', version: '3.10', code: code }),
            signal: controller.signal
        })
        .then(function (r) { return r.json(); })
        .then(function (data) {
            clearTimeout(timeoutId);
            var stdout = (data.Stdout || data.stdout || '').trim();
            var stderr = (data.Stderr || data.stderr || '').trim();
            if (!stdout && stderr) return null;
            return stdout;
        })
        .catch(function () {
            clearTimeout(timeoutId);
            return null;
        });
    }

    // =========================================================
    //  LATEX → NERDAMER (uses nerdamer.convertFromLaTeX)
    //  NERDAMER → PYTHON (for SymPy tier)
    // =========================================================

    /** Normalize LaTeX before passing to nerdamer.convertFromLaTeX.
     *  Fixes known gaps: \ln → \log, etc. */
    function normalizeLatexForNerdamer(latex) {
        if (!latex) return '';
        return latex
            .replace(/\\ln\b/g, '\\log');  // nerdamer only understands \log
    }

    /** Convert Nerdamer text to SymPy-compatible Python.
     *  Handles: ^ → **, e^x → exp(x), ln → log, equations → Eq(). */
    function nerdamerToPython(expr) {
        if (!expr) return '';
        // Handle equations: "lhs=rhs" → "Eq(lhs, rhs)"
        var eqParts = expr.split('=');
        if (eqParts.length === 2 && eqParts[0] && eqParts[1]) {
            return 'Eq(' + nerdamerToPython(eqParts[0]) + ', ' + nerdamerToPython(eqParts[1]) + ')';
        }
        return expr
            .replace(/e\^(\([^)]+\))/g, 'exp$1')
            .replace(/e\^([a-zA-Z0-9_]+)/g, 'exp($1)')
            .replace(/\bln\(/g, 'log(')
            .replace(/\^/g, '**')
            .replace(/(\d)([a-zA-Z])/g, '$1*$2')
            .replace(/\)(\()/g, ')*$1')
            .replace(/\)([a-zA-Z])/g, ')*$1');
    }

    /** Build SymPy symbol declarations from expression and variable. */
    function buildSympySymbolsDecl(v, pyExpr) {
        var syms = {};
        syms[v] = true;
        var m = pyExpr.match(/[a-zA-Z_]\w*/g);
        if (m) {
            for (var i = 0; i < m.length; i++) {
                var s = m[i];
                if (/^(sin|cos|tan|log|exp|sqrt|pi|oo|E|I|asin|acos|atan|sec|csc|cot|Abs|factorial|gamma|erf|symbols|Symbol|integrate|diff|solve|simplify|factor|expand|limit|summation|S|Rational|Integer|Float|Integral|Derivative|Sum|Product|Infinity|zoo|nan|true|false|None|True|False|import|from|print|def|return|if|else|for|while|try|except|raise|with|as)$/.test(s)) continue;
                syms[s] = true;
            }
        }
        var names = Object.keys(syms);
        return names.length > 0 ? names.join(', ') + ' = symbols("' + names.join(' ') + '", real=True)' : '';
    }

    // =========================================================
    //  UTILITIES
    // =========================================================

    /** Show a brief toast notification at the bottom of the viewport. */
    function showToast(message, duration) {
        duration = duration || 3000;
        var existing = document.querySelector('.me-compute-toast');
        if (existing) existing.remove();
        var toast = document.createElement('div');
        toast.className = 'me-compute-toast';
        toast.textContent = message;
        toast.style.cssText = 'position:fixed;bottom:24px;left:50%;transform:translateX(-50%);' +
            'background:#1E293B;color:#F8FAFC;padding:8px 18px;border-radius:8px;font-size:13px;' +
            'z-index:100001;box-shadow:0 4px 12px rgba(0,0,0,.15);opacity:0;transition:opacity .2s;' +
            'pointer-events:none;max-width:400px;text-align:center;';
        document.body.appendChild(toast);
        requestAnimationFrame(function () { toast.style.opacity = '1'; });
        setTimeout(function () {
            toast.style.opacity = '0';
            setTimeout(function () { toast.remove(); }, 250);
        }, duration);
    }

    /** Add a spinner overlay to a math node element. */
    function showNodeLoading(mathNodeEl) {
        if (!mathNodeEl) return;
        mathNodeEl.classList.add('me-computing');
        var overlay = document.createElement('div');
        overlay.className = 'me-compute-loading-overlay';
        overlay.innerHTML = '<div class="me-compute-spinner"></div>';
        overlay.style.cssText = 'position:absolute;inset:0;display:flex;align-items:center;' +
            'justify-content:center;background:rgba(255,255,255,.6);border-radius:8px;z-index:10;' +
            'pointer-events:none;';
        var spinnerStyle = 'width:20px;height:20px;border:2px solid #CBD5E1;border-top-color:#3B82F6;' +
            'border-radius:50%;animation:me-spin .6s linear infinite;';
        overlay.firstChild.style.cssText = spinnerStyle;
        // Ensure math node is position:relative for overlay
        var pos = window.getComputedStyle(mathNodeEl).position;
        if (pos === 'static') mathNodeEl.style.position = 'relative';
        mathNodeEl.appendChild(overlay);
        // Inject keyframes if not already present
        if (!document.getElementById('me-spin-keyframes')) {
            var style = document.createElement('style');
            style.id = 'me-spin-keyframes';
            style.textContent = '@keyframes me-spin{to{transform:rotate(360deg)}}';
            document.head.appendChild(style);
        }
    }

    /** Remove the spinner overlay from a math node element. */
    function hideNodeLoading(mathNodeEl) {
        if (!mathNodeEl) return;
        mathNodeEl.classList.remove('me-computing');
        var overlay = mathNodeEl.querySelector('.me-compute-loading-overlay');
        if (overlay) overlay.remove();
    }

    function debounce(fn, ms) {
        var timer = null;
        return function () {
            var args = arguments;
            var ctx = this;
            if (timer) clearTimeout(timer);
            timer = setTimeout(function () { fn.apply(ctx, args); }, ms);
        };
    }

    function readLatex(mf) {
        try { return (mf.getValue ? mf.getValue() : mf.value) || ''; }
        catch (_) { return mf.value || ''; }
    }

    /** Presentation filter — rejects CE/Nerdamer garbage results. */
    function isUseful(result, originalLatex) {
        if (!result || !result.latex) return false;
        var rl = result.latex;
        if (rl === originalLatex) return false;
        if (/\\mathrm\{Nothing\}|\\mathrm\{NaN\}|\\text\{undefined\}/.test(rl)) return false;
        if (rl === 'NaN' || rl === 'undefined') return false;
        if (rl === '\\bot' || rl === '\\top' || rl === 'True' || rl === 'False') return false;
        if (rl === '\\mathrm{True}' || rl === '\\mathrm{False}') return false;
        if (rl === '\u22A5' || rl === '\u22A4') return false;
        if (rl === '\\perp') return false;
        if (/\\mathrm\{(Solve|Integrate|Isolate|Roots|D|Factor|Binomial|Fibonacci)\}/.test(rl)) return false;
        if (/^\\int[\\!\s]/.test(rl)) return false;
        try { if (result.json === 'False' || result.json === 'True') return false; } catch (_) {}
        return true;
    }

    function collectVars(expr) {
        try {
            var vars = expr.freeVariables;
            if (!vars) return [];
            if (Array.isArray(vars)) return vars.slice();
            if (typeof vars.size === 'number') return Array.from(vars);
            if (typeof vars[Symbol.iterator] === 'function') return Array.from(vars);
        } catch (_) {}
        return [];
    }

    function firstVar(expr) {
        var all = collectVars(expr);
        return all.length > 0 ? all[0] : null;
    }

    function getAllVars(mf, engine) {
        var vars = [];
        if (engine) {
            try { vars = collectVars(engine.parse(readLatex(mf))); } catch (_) {}
        }
        if (vars.length === 0) vars = detectVarsFromLatex(readLatex(mf));
        return vars.sort();
    }

    function detectVarsFromLatex(latex) {
        if (!latex) return [];
        var cleaned = latex
            .replace(/\\(frac|sqrt|int|sum|prod|lim|sin|cos|tan|log|ln|exp|cdot|left|right|begin|end|mathrm|text|operatorname)\b/g, '')
            .replace(/\\[a-zA-Z]+/g, '')
            .replace(/[{}()\[\]^_=+\-*/\\|,.:;!<>0-9\s]/g, ' ');
        var tokens = cleaned.split(/\s+/).filter(function (t) { return t.length > 0; });
        var seen = {};
        var result = [];
        for (var i = 0; i < tokens.length; i++) {
            if (/^[a-zA-Z]$/.test(tokens[i]) && !seen[tokens[i]]) {
                if (tokens[i] === 'd' || tokens[i] === 'e' || tokens[i] === 'i') continue;
                seen[tokens[i]] = true;
                result.push(tokens[i]);
            }
        }
        return result;
    }

    function declareVarsReal(engine, expr) {
        var vars = collectVars(expr);
        for (var i = 0; i < vars.length; i++) {
            try { engine.declare(vars[i], 'real'); } catch (_) {}
        }
    }

    // =========================================================
    //  3-TIER ACTION DISPATCHER
    //  CE → Nerdamer → SymPy, each lazy, each wrapped in try/catch.
    //  Returns Promise<{ latex: string } | null>
    // =========================================================

    /** Run a Nerdamer operation, return { latex } or null.
     *  Uses nerdamer.convertFromLaTeX() for input parsing (standard API). */
    function tryNerdamer(action, latex, v) {
        return getNerdamer().then(function (nm) {
            if (!nm) return null;
            var nExpr;
            try { nExpr = nm.convertFromLaTeX(normalizeLatexForNerdamer(latex)).toString(); } catch (_) { return null; }
            if (!nExpr) return null;
            var result, tex;
            try {
                switch (action) {
                    case 'evaluate':
                        result = nm(nExpr);
                        tex = result.toTeX();
                        break;
                    case 'simplify':
                        result = nm('simplify(' + nExpr + ')');
                        tex = result.toTeX();
                        break;
                    case 'expand':
                        result = nm('expand(' + nExpr + ')');
                        tex = result.toTeX();
                        break;
                    case 'factor':
                        result = nm('factor(' + nExpr + ')');
                        tex = result.toTeX();
                        break;
                    case 'solve':
                        if (!v) return null;
                        result = nm.solve(nExpr, v);
                        tex = result.toTeX();
                        break;
                    case 'derivative':
                        if (!v) return null;
                        result = nm.diff(nExpr, v);
                        tex = result.toTeX();
                        break;
                    case 'integrate':
                        if (!v) return null;
                        result = nm('integrate(' + nExpr + ', ' + v + ')');
                        // Reject unevaluated integral
                        var txt = result.text();
                        if (txt && txt.indexOf('integrate(') !== -1) return null;
                        tex = result.toTeX();
                        break;
                    default:
                        return null;
                }
            } catch (_) {
                return null;
            }
            if (!tex) return null;
            return { latex: tex };
        }).catch(function () { return null; });
    }

    /** Run a SymPy operation server-side, return { latex } or null. */
    function trySymPy(action, latex, v) {
        // Convert LaTeX → Nerdamer text → Python
        var nExpr = '';
        if (nerd) {
            try { nExpr = nerd.convertFromLaTeX(normalizeLatexForNerdamer(latex)).toString(); } catch (_) {}
        }
        if (!nExpr) {
            // Fallback: basic LaTeX→text if Nerdamer not loaded yet
            nExpr = latex.replace(/\\frac\{([^}]+)\}\{([^}]+)\}/g, '(($1)/($2))')
                .replace(/\\sqrt\{([^}]+)\}/g, 'sqrt($1)')
                .replace(/\\cdot/g, '*').replace(/\\times/g, '*')
                .replace(/\\left|\\right/g, '').replace(/\{/g, '(').replace(/\}/g, ')')
                .replace(/\\sin/g, 'sin').replace(/\\cos/g, 'cos').replace(/\\tan/g, 'tan')
                .replace(/\\ln/g, 'log').replace(/\\log/g, 'log')
                .replace(/\\pi/g, 'pi').replace(/\\infty/g, 'oo').replace(/\\,/g, '');
        }
        var pyExpr = nerdamerToPython(nExpr);
        if (!pyExpr) return Promise.resolve(null);
        v = v || 'x';
        var symDecl = buildSympySymbolsDecl(v, pyExpr);

        var pyOp;
        switch (action) {
            case 'evaluate':
                pyOp = 'simplify(' + pyExpr + ')';
                break;
            case 'simplify':
                pyOp = 'simplify(' + pyExpr + ')';
                break;
            case 'expand':
                pyOp = 'expand(' + pyExpr + ')';
                break;
            case 'factor':
                pyOp = 'factor(' + pyExpr + ')';
                break;
            case 'solve':
                pyOp = 'solve(' + pyExpr + ', ' + v + ')';
                break;
            case 'derivative':
                pyOp = 'diff(' + pyExpr + ', ' + v + ')';
                break;
            case 'integrate':
                pyOp = 'integrate(' + pyExpr + ', ' + v + ')';
                break;
            default:
                return Promise.resolve(null);
        }

        var code = 'from sympy import *\n' +
            symDecl + '\n' +
            'result = ' + pyOp + '\n' +
            'print("LATEX:" + latex(result))';

        return runSymPy(code).then(function (stdout) {
            if (!stdout) return null;
            var m = stdout.match(/LATEX:([^\n]*)/);
            if (!m || !m[1]) return null;
            var tex = m[1].trim();
            if (!tex) return null;
            return { latex: tex };
        }).catch(function () { return null; });
    }

    /** 3-tier cascade for a single action.
     *  Returns Promise<{ latex, tier }> or null. */
    function computeAction(action, latex, v, engine) {
        // --- Tier 1: CE ---
        var ceResult = null;
        if (engine) {
            try {
                var expr = engine.parse(latex);
                declareVarsReal(engine, expr);

                switch (action) {
                    case 'evaluate':
                        try { ceResult = expr.N(); } catch (_) {}
                        if (!isUseful(ceResult, latex)) {
                            try { ceResult = expr.evaluate(); } catch (_) {}
                        }
                        break;
                    case 'simplify':
                        try { ceResult = expr.simplify(); } catch (_) {}
                        break;
                    case 'expand':
                        try { ceResult = engine.box(['Expand', expr]).evaluate(); } catch (_) {}
                        if (!isUseful(ceResult, latex)) {
                            try { ceResult = engine.box(['ExpandAll', expr]).evaluate(); } catch (_) {}
                        }
                        break;
                    case 'factor':
                        try {
                            ceResult = v
                                ? engine.box(['Factor', expr, v]).evaluate()
                                : engine.box(['Factor', expr]).evaluate();
                        } catch (_) {}
                        break;
                    case 'solve':
                        if (v) {
                            try { ceResult = engine.box(['Solve', expr, v]).evaluate(); } catch (_) {}
                        }
                        break;
                    case 'derivative':
                        if (v) {
                            try { ceResult = engine.box(['D', expr, v]).evaluate(); } catch (_) {}
                            if (ceResult && ceResult.latex) {
                                try {
                                    var s = ceResult.simplify();
                                    if (s && s.latex) ceResult = s;
                                } catch (_) {}
                            }
                        }
                        break;
                    case 'integrate':
                        if (v) {
                            try { ceResult = engine.box(['Integrate', expr, v]).evaluate(); } catch (_) {}
                        }
                        break;
                }
            } catch (_) {}
        }

        if (isUseful(ceResult, latex)) {
            return Promise.resolve({ latex: ceResult.latex, tier: 'ce' });
        }

        // --- Tier 2: Nerdamer ---
        return tryNerdamer(action, latex, v).then(function (nResult) {
            if (nResult && isUseful(nResult, latex)) {
                return { latex: nResult.latex, tier: 'nerdamer' };
            }
            // --- Tier 3: SymPy ---
            // Notify user that we are falling back to the slower server solver
            if (nerdamerFailed) {
                showToast('Using advanced solver \u2014 this may take a moment\u2026', 4000);
            }
            return trySymPy(action, latex, v).then(function (sResult) {
                if (sResult && isUseful(sResult, latex)) {
                    return { latex: sResult.latex, tier: 'sympy' };
                }
                return null;
            });
        });
    }

    // =========================================================
    //  LAYER 1: Auto-Result for Block Math
    //  Shows a subtle "= result" below block equations.
    //  CE-only for speed (auto-result fires on every keystroke).
    // =========================================================
    var AUTO_RESULT_KEY = 'me_auto_result';
    function isAutoResultEnabled() {
        var v = localStorage.getItem(AUTO_RESULT_KEY);
        return v !== 'off';  // on by default
    }
    function setAutoResultEnabled(on) {
        localStorage.setItem(AUTO_RESULT_KEY, on ? 'on' : 'off');
        // Hide all existing auto-results when turning off
        if (!on) {
            document.querySelectorAll('.me-math-result').forEach(function (el) {
                el.style.display = 'none';
            });
        }
    }

    function _updateAutoResult(latex, resultEl) {
        if (!resultEl) return;
        if (!isAutoResultEnabled()) { resultEl.style.display = 'none'; return; }
        if (!latex || !latex.trim()) { resultEl.style.display = 'none'; return; }

        getCE().then(function (engine) {
            if (!engine) { resultEl.style.display = 'none'; return; }
            try {
                var expr = engine.parse(latex);
                declareVarsReal(engine, expr);
                var resultLatex = null;

                try {
                    var num = expr.N();
                    if (isUseful(num, latex) && num.latex.length < latex.length * 3) {
                        resultLatex = num.latex;
                    }
                } catch (_) {}

                if (!resultLatex) {
                    try {
                        var simplified = expr.simplify();
                        if (isUseful(simplified, latex)) resultLatex = simplified.latex;
                    } catch (_) {}
                }

                if (!resultLatex) {
                    try {
                        var evaluated = expr.evaluate();
                        if (isUseful(evaluated, latex)) resultLatex = evaluated.latex;
                    } catch (_) {}
                }

                if (!resultLatex) { resultEl.style.display = 'none'; return; }
                renderResult(resultEl, resultLatex);
            } catch (_) {
                resultEl.style.display = 'none';
            }
        }).catch(function () { resultEl.style.display = 'none'; });
    }

    function renderResult(resultEl, latex) {
        if (!latex) { resultEl.style.display = 'none'; return; }
        var mfResult = resultEl.querySelector('.me-result-mathfield');
        if (!mfResult) {
            resultEl.innerHTML = '';
            resultEl.setAttribute('title', 'Auto-computed result (not part of document, hidden from print)');
            resultEl.setAttribute('aria-label', 'Auto-computed result');

            var eq = document.createElement('span');
            eq.className = 'me-result-equals';
            eq.textContent = '= ';
            eq.setAttribute('aria-hidden', 'true');
            resultEl.appendChild(eq);

            mfResult = document.createElement('math-field');
            mfResult.setAttribute('read-only', '');
            mfResult.className = 'me-result-mathfield';
            resultEl.appendChild(mfResult);

            // Dismiss button to hide this individual result
            var dismiss = document.createElement('button');
            dismiss.className = 'me-result-dismiss';
            dismiss.textContent = '\u00d7';
            dismiss.setAttribute('title', 'Hide this result');
            dismiss.setAttribute('aria-label', 'Dismiss auto-result');
            dismiss.addEventListener('click', function (e) {
                e.stopPropagation();
                resultEl.style.display = 'none';
                resultEl._dismissed = true;
            });
            resultEl.appendChild(dismiss);
        }
        // Don't re-show if user dismissed this specific result
        if (resultEl._dismissed) return;
        mfResult.value = latex;
        resultEl.style.display = 'block';
    }

    // =========================================================
    //  LAYER 3: Inline Evaluate (Shift+Enter)
    //  3-tier: CE → Nerdamer → SymPy
    // =========================================================
    function evaluateInline(mf) {
        var fullLatex = readLatex(mf);
        if (!fullLatex) return;

        var latex = fullLatex.replace(/\s*=\s*[^=]+$/, '').trim();
        if (!latex) latex = fullLatex;

        getCE().then(function (engine) {
            computeAction('evaluate', latex, null, engine).then(function (r) {
                if (r) {
                    mf.value = latex + ' = ' + r.latex;
                    mf.dispatchEvent(new Event('input'));
                }
            });
        });
    }

    // =========================================================
    //  LAYER 2: Math Action Bar
    // =========================================================
    var actionBar = null;
    var currentMathField = null;
    var currentMathNode = null;

    var ACTIONS = [
        { id: 'evaluate',   icon: '=',          label: 'Evaluate',   title: 'Numerical evaluation (N)' },
        { id: 'simplify',   icon: '\u2248',     label: 'Simplify',   title: 'Symbolic simplification' },
        { id: 'expand',     icon: '\u2192',     label: 'Expand',     title: 'Expand products & powers' },
        { id: 'factor',     icon: '( )',        label: 'Factor',     title: 'Factor into irreducibles' },
        { id: 'solve',      icon: 'x\u2080',    label: 'Solve',      title: 'Solve equation for variable' },
        { id: 'derivative', icon: 'd/dx',       label: 'd/dx',       title: 'Symbolic derivative' },
        { id: 'integrate',  icon: '\u222B',     label: 'Integrate',  title: 'Symbolic antiderivative' },
        { id: 'plot',       icon: '\uD83D\uDCC8', label: 'Plot',    title: 'Plot this equation as a graph' }
    ];

    function createActionBar() {
        var bar = document.createElement('div');
        bar.className = 'me-compute-bar';
        bar.setAttribute('role', 'toolbar');
        bar.setAttribute('aria-label', 'Math actions');
        var html = '';
        for (var i = 0; i < ACTIONS.length; i++) {
            var a = ACTIONS[i];
            if (i === 2 || i === 5) html += '<span class="me-compute-sep" aria-hidden="true"></span>';
            // Add separator before Plot button
            if (a.id === 'plot') html += '<span class="me-compute-sep" aria-hidden="true"></span>';
            html += '<button class="me-compute-btn" data-action="' + a.id + '" title="' + a.title + '"' +
                ' role="button" tabindex="0" aria-label="' + a.label + '">' +
                '<span class="me-compute-icon" aria-hidden="true">' + a.icon + '</span> ' + a.label + '</button>';
        }
        bar.innerHTML = html;
        bar.style.display = 'none';
        document.body.appendChild(bar);

        bar.addEventListener('click', function (e) {
            var btn = e.target.closest('.me-compute-btn');
            if (!btn || !currentMathField) return;
            var action = btn.getAttribute('data-action');
            if (action === 'plot') {
                // Handle Plot action directly via MeGraph
                if (window.MeGraph) {
                    window.MeGraph.insertGraph(readLatex(currentMathField), currentMathField);
                }
            } else {
                performAction(action, currentMathField);
            }
        });
        bar.addEventListener('mousedown', function (e) { e.preventDefault(); });
        return bar;
    }

    // =========================================================
    //  PERFORM ACTION — 3-tier cascade
    // =========================================================
    function performAction(action, mf, targetVar) {
        var fullLatex = readLatex(mf);
        if (!fullLatex) return;

        // Strip any previous "= result" before computing
        var latex = fullLatex.replace(/\s*=\s*[^=]+$/, '').trim();
        if (!latex) latex = fullLatex;

        // Show loading state on the triggering button and disable all action buttons
        var clickedBtn = actionBar ? actionBar.querySelector('[data-action="' + action + '"]') : null;
        var allBtns = actionBar ? actionBar.querySelectorAll('.me-compute-btn') : [];
        var origLabel = '';
        if (clickedBtn) {
            origLabel = clickedBtn.innerHTML;
            clickedBtn.innerHTML = '<span class="me-compute-icon" aria-hidden="true">\u23F3</span> Computing\u2026';
            clickedBtn.classList.add('me-btn-loading');
        }
        for (var bi = 0; bi < allBtns.length; bi++) {
            allBtns[bi].disabled = true;
            allBtns[bi].setAttribute('aria-disabled', 'true');
        }

        // Show spinner overlay on the math node
        var mathNodeEl = currentMathNode;
        showNodeLoading(mathNodeEl);

        // Show "Using advanced solver..." if Nerdamer already failed
        var showedSolverMsg = false;
        if (nerdamerFailed) {
            showToast('Using advanced solver \u2014 this may take a moment\u2026', 4000);
            showedSolverMsg = true;
        }

        getCE().then(function (engine) {
            // Determine variable
            var v = targetVar;
            if (!v && engine) {
                try { v = firstVar(engine.parse(latex)); } catch (_) {}
            }
            if (!v) {
                var dv = detectVarsFromLatex(latex);
                if (dv.length > 0) v = dv[0];
            }

            computeAction(action, latex, v, engine).then(function (r) {
                // Restore button states
                if (clickedBtn) {
                    clickedBtn.innerHTML = origLabel;
                    clickedBtn.classList.remove('me-btn-loading');
                }
                for (var bj = 0; bj < allBtns.length; bj++) {
                    allBtns[bj].disabled = false;
                    allBtns[bj].removeAttribute('aria-disabled');
                }
                hideNodeLoading(mathNodeEl);

                if (r) {
                    appendResultToField(mf, latex, r.latex, action, v);
                    if (r.tier === 'sympy' && !showedSolverMsg) {
                        showToast('Computed via advanced solver (SymPy)', 2000);
                    }
                }
            });
        });
    }

    /** Append result to the current math-field (maintains continuity). */
    function appendResultToField(mf, originalLatex, resultLatex, action, v) {
        var vStr = v || 'x';
        var joined;

        switch (action) {
            case 'derivative':
                joined = "\\frac{d}{d" + vStr + "}\\left(" + originalLatex + "\\right) = " + resultLatex;
                break;
            case 'integrate':
                joined = "\\int " + originalLatex + "\\,d" + vStr + " = " + resultLatex;
                break;
            case 'solve':
                joined = originalLatex + " \\Rightarrow " + resultLatex;
                break;
            default:
                // evaluate, simplify, expand, factor
                joined = originalLatex + " = " + resultLatex;
                break;
        }

        mf.value = joined;
        mf.dispatchEvent(new Event('input'));
    }

    // =========================================================
    //  ACTION BAR POSITIONING
    // =========================================================
    function positionActionBar() {
        if (!actionBar || !currentMathNode) return;
        var rect = currentMathNode.getBoundingClientRect();
        actionBar.style.top = (rect.bottom + 4) + 'px';
        actionBar.style.left = (rect.left + rect.width / 2) + 'px';
    }

    function showActionBar(mathNodeEl, mf) {
        if (!actionBar) actionBar = createActionBar();
        currentMathField = mf;
        currentMathNode = mathNodeEl;
        actionBar.classList.add('me-bar-entering');
        actionBar.style.display = 'flex';
        positionActionBar();
        requestAnimationFrame(function () { actionBar.classList.remove('me-bar-entering'); });
    }

    function hideActionBar() {
        if (actionBar) actionBar.style.display = 'none';
        currentMathField = null;
        currentMathNode = null;
    }

    // =========================================================
    //  SELECTION LISTENER
    // =========================================================
    document.addEventListener('me:editor-ready', function () {
        var editor = window.MeEditor;
        if (!editor) return;

        getCE();

        document.addEventListener('me:selection-changed', function (e) {
            var ed = e.detail && e.detail.editor;
            if (!ed) { hideActionBar(); return; }
            var sel = ed.state.selection;
            if (sel.node && (sel.node.type.name === 'mathBlock' || sel.node.type.name === 'mathInline')) {
                try {
                    var domNode = ed.view.nodeDOM(sel.from);
                    if (domNode) {
                        var mf = domNode.querySelector('math-field');
                        if (mf) { showActionBar(domNode, mf); return; }
                    }
                } catch (_) {}
            }
            hideActionBar();
        });

        var wrapper = document.querySelector('.me-canvas-wrapper');
        if (wrapper) {
            wrapper.addEventListener('scroll', function () {
                if (!currentMathNode || !actionBar || actionBar.style.display === 'none') return;
                var rect = currentMathNode.getBoundingClientRect();
                var wRect = wrapper.getBoundingClientRect();
                if (rect.bottom < wRect.top || rect.top > wRect.bottom) hideActionBar();
                else positionActionBar();
            });
        }
    });

    // =========================================================
    //  RIGHT-CLICK CONTEXT MENU (MathLive native menuItems API)
    //  Injects Solve/Evaluate/Simplify/etc. into math-field's
    //  built-in context menu via mf.menuItems.
    // =========================================================

    /** Build MathLive-native menuItems for a math-field.
     *  Called once per math-field in wireMenuItems(). */
    function buildNativeMenuItems(mf) {
        var items = [];

        // --- Solve for each detected variable ---
        var latex = readLatex(mf);
        var vars = ce ? getAllVars(mf, ce) : detectVarsFromLatex(latex);

        for (var i = 0; i < vars.length; i++) {
            (function (v) {
                items.push({
                    label: 'Solve for ' + v,
                    onMenuSelect: function () { performAction('solve', mf, v); }
                });
            })(vars[i]);
        }
        if (vars.length > 0) items.push({ type: 'divider' });

        // --- Core actions ---
        items.push({
            label: 'Evaluate',
            onMenuSelect: function () { performAction('evaluate', mf); }
        });
        items.push({
            label: 'Simplify',
            onMenuSelect: function () { performAction('simplify', mf); }
        });
        items.push({
            label: 'Expand',
            onMenuSelect: function () { performAction('expand', mf); }
        });
        items.push({
            label: 'Factor',
            onMenuSelect: function () { performAction('factor', mf); }
        });

        // --- Calculus per variable ---
        if (vars.length > 0) {
            items.push({ type: 'divider' });

            // Derivative submenu
            if (vars.length === 1) {
                (function (v) {
                    items.push({
                        label: 'd/d' + v + '  Derivative',
                        onMenuSelect: function () { performAction('derivative', mf, v); }
                    });
                })(vars[0]);
            } else {
                var derivSub = [];
                for (var j = 0; j < vars.length; j++) {
                    (function (v) {
                        derivSub.push({
                            label: 'w.r.t. ' + v,
                            onMenuSelect: function () { performAction('derivative', mf, v); }
                        });
                    })(vars[j]);
                }
                items.push({ label: 'Derivative', submenu: derivSub });
            }

            // Integrate submenu
            if (vars.length === 1) {
                (function (v) {
                    items.push({
                        label: '\u222B d' + v + '  Integrate',
                        onMenuSelect: function () { performAction('integrate', mf, v); }
                    });
                })(vars[0]);
            } else {
                var intSub = [];
                for (var k = 0; k < vars.length; k++) {
                    (function (v) {
                        intSub.push({
                            label: 'w.r.t. ' + v,
                            onMenuSelect: function () { performAction('integrate', mf, v); }
                        });
                    })(vars[k]);
                }
                items.push({ label: 'Integrate', submenu: intSub });
            }
        }

        // --- Plot Graph ---
        items.push({ type: 'divider' });
        items.push({
            label: 'Plot This Equation',
            onMenuSelect: function () {
                if (window.MeGraph) {
                    window.MeGraph.insertGraph(readLatex(mf), mf);
                }
            }
        });
        items.push({
            label: 'Plot Multiple Equations...',
            onMenuSelect: function () {
                if (window.MeGraph) {
                    window.MeGraph.showEquationPicker(mf);
                }
            }
        });

        // --- Utility ---
        items.push({ type: 'divider' });
        items.push({
            label: 'Copy LaTeX',
            onMenuSelect: function () {
                var l = readLatex(mf);
                if (l) navigator.clipboard.writeText(l).catch(function () {});
            }
        });
        items.push({
            label: 'Copy MathJSON',
            onMenuSelect: function () {
                getCE().then(function (engine) {
                    if (!engine) return;
                    try {
                        var json = JSON.stringify(engine.parse(readLatex(mf)).json, null, 2);
                        navigator.clipboard.writeText(json).catch(function () {});
                    } catch (_) {}
                });
            }
        });

        return items;
    }

    /** Inject our compute actions into a math-field's native context menu.
     *  Called from tiptap-init.js after math-field is created. */
    function wireMenuItems(mf) {
        try {
            // Get MathLive's default items, prepend ours
            var defaults = mf.menuItems || [];
            // Filter out MathLive's built-in CE items (we provide our own 3-tier versions)
            var filtered = defaults.filter(function (item) {
                return !(item.id && /^ce-/.test(item.id));
            });
            var ours = buildNativeMenuItems(mf);
            mf.menuItems = ours.concat(
                filtered.length > 0 ? [{ type: 'divider' }] : [],
                filtered
            );
        } catch (_) {}
    }

    // =========================================================
    //  EXPOSE GLOBAL API
    // =========================================================
    window.MeCompute = {
        updateAutoResult:  debounce(_updateAutoResult, 500),
        evaluateInline:    evaluateInline,
        performAction:     performAction,
        hideActionBar:     hideActionBar,
        wireMenuItems:     wireMenuItems,
        getCE:             getCE,
        getNerdamer:       getNerdamer,
        showToast:         showToast,
        showNodeLoading:   showNodeLoading,
        hideNodeLoading:   hideNodeLoading,
        isAutoResultEnabled: isAutoResultEnabled,
        setAutoResultEnabled: setAutoResultEnabled
    };

})();
