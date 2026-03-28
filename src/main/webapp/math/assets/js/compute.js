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
        // Check if nerdamer was already loaded (e.g. by integral-calculator-core.js)
        if (window.nerdamer) { nerd = window.nerdamer; return Promise.resolve(nerd); }
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
    //  OpenChemLib (lazy ESM import for SMILES → molecule)
    // =========================================================
    var oclModule = null;
    function getOCL() {
        if (oclModule) return Promise.resolve(oclModule);
        return import('https://esm.sh/openchemlib@9.21.0').then(function (mod) {
            oclModule = mod.default || mod;
            return oclModule;
        });
    }

    /** Detect if text looks like a SMILES string (no spaces, has uppercase letter, no LaTeX commands) */
    function isSmilesLike(text) {
        if (!text || text.length < 2) return false;
        if (/\s/.test(text)) return false;
        if (/\\[a-zA-Z]/.test(text)) return false; // LaTeX commands like \frac
        if (!/[A-Z]/.test(text)) return false;      // Must have at least one uppercase letter
        return /^[A-Za-z0-9=#()[\]@+\-\\.\/\\\\]+$/.test(text);
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

    // =========================================================
    //  INTEGRAL-AWARE LaTeX PARSER
    //  Detects \int ... dx patterns in LaTeX and extracts:
    //    { integrand, variable, lower, upper, isDefinite }
    //  Then routes through integral-calculator-core.js engine.
    // =========================================================

    /**
     * Parse \int LaTeX into components.
     * Handles: \int f(x)\,dx, \int_{a}^{b} f(x)\,dx, \int f(x) dx
     * Returns { integrand, variable, lower, upper, isDefinite } or null.
     */
    function parseIntegralLatex(latex) {
        if (!latex || !(/\\int/.test(latex))) return null;
        var s = latex.trim();

        // Helper: extract balanced brace content starting at pos (just after opening {)
        function extractBraced(str, pos) {
            var depth = 1, i = pos;
            while (i < str.length && depth > 0) {
                if (str[i] === '{') depth++;
                else if (str[i] === '}') depth--;
                i++;
            }
            return depth === 0 ? { content: str.substring(pos, i - 1), end: i } : null;
        }

        // Extract optional bounds: \int_{lower}^{upper}
        var lower = null, upper = null;
        var intMatch = s.match(/^\\int\s*/);
        if (intMatch) {
            var cursor = intMatch[0].length;
            if (s[cursor] === '_') {
                cursor++; // skip _
                if (s[cursor] === '{') {
                    // Braced lower bound: _{...}
                    var lo = extractBraced(s, cursor + 1);
                    if (lo) { lower = lo.content; cursor = lo.end; }
                } else {
                    // Bare lower bound: _0, _a, _1 (single char/digit)
                    var loMatch = s.substring(cursor).match(/^([a-zA-Z0-9])/);
                    if (loMatch) { lower = loMatch[1]; cursor += loMatch[1].length; }
                }
                // Skip whitespace
                while (cursor < s.length && s[cursor] === ' ') cursor++;
                if (s[cursor] === '^') {
                    cursor++; // skip ^
                    if (s[cursor] === '{') {
                        // Braced upper bound: ^{...}
                        var hi = extractBraced(s, cursor + 1);
                        if (hi) { upper = hi.content; cursor = hi.end; }
                    } else {
                        // Bare upper bound: ^1, ^a
                        var hiMatch = s.substring(cursor).match(/^(\S+)/);
                        if (hiMatch) { upper = hiMatch[1]; cursor += hiMatch[1].length; }
                    }
                }
            }
            s = s.substring(cursor);
        } else {
            // Strip bare \int
            s = s.replace(/^\\int\s*/, '');
        }

        // Extract d<var> from the end: \,dx or \,dt or just dx
        var variable = 'x';
        s = s.replace(/\\[,;!]\s*d([a-zA-Z])\s*$/, function (_, v) { variable = v; return ''; });
        s = s.replace(/\s+d([a-zA-Z])\s*$/, function (_, v) { variable = v; return ''; });
        // Also handle d\theta, d{var}
        s = s.replace(/\\[,;!]\s*d\{([^}]+)\}\s*$/, function (_, v) { variable = v; return ''; });

        // Strip wrapping \left( ... \right) if present
        s = s.replace(/^\\left\(/, '').replace(/\\right\)\s*$/, '');
        s = s.trim();

        if (!s) return null;

        return {
            integrand: s,
            variable: variable,
            lower: lower,
            upper: upper,
            isDefinite: lower !== null && upper !== null
        };
    }

    /**
     * Compute an integral using the integral-calculator-core engine.
     * Uses: normalizeExpr → King's property → nerdamer integrate → SymPy fallback.
     * Returns Promise<{ latex, tier }> or null.
     */
    function computeIntegralViaCoreEngine(integrandLatex, variable, lower, upper, isDefinite) {
        var core = window.IntegralCalculatorCore;
        var nm = window.nerdamer;
        if (!core || !nm) return Promise.resolve(null);

        // Normalize LaTeX before conversion:
        // \sin^{3}(x) → \sin(x)^{3}  (nerdamer doesn't handle trig^n(x) form)
        // Handles both braced ^{3} and bare ^3
        var normLatex = normalizeLatexForNerdamer(integrandLatex)
            .replace(/\\(sin|cos|tan|sec|csc|cot|sinh|cosh|tanh)\^(\{[^}]+\})(\([^)]*\))/g, '\\$1$3^$2')
            .replace(/\\(sin|cos|tan|sec|csc|cot|sinh|cosh|tanh)\^(\d+)(\([^)]*\))/g, '\\$1$3^$2')
            .replace(/\\(sin|cos|tan|sec|csc|cot|sinh|cosh|tanh)\^(\{[^}]+\})([a-zA-Z])/g, '\\$1($3)^$2')
            .replace(/\\(sin|cos|tan|sec|csc|cot|sinh|cosh|tanh)\^(\d+)([a-zA-Z])/g, '\\$1($3)^$2');

        // Convert LaTeX integrand to nerdamer text
        var nExpr;
        try {
            nExpr = nm.convertFromLaTeX(normLatex).toString();
        } catch (_) {
            // Fallback: try treating it as already-text (user may have typed text, not LaTeX)
            nExpr = integrandLatex;
        }
        if (!nExpr) return Promise.resolve(null);

        // Normalize through the core engine
        nExpr = core.normalizeExpr(nExpr);
        var v = variable || 'x';

        // --- King's property check for definite integrals ---
        if (isDefinite) {
            var kings = core.checkKingsProperty(nExpr, v, lower, upper, nm);
            if (kings) {
                return Promise.resolve({
                    latex: kings.exactTeX,
                    tier: 'kings'
                });
            }
        }

        // --- nerdamer integration ---
        try {
            if (isDefinite) {
                // Try definite integral
                var defResult = nm('defint(' + nExpr + ', ' + lower + ', ' + upper + ', ' + v + ')');
                var numVal = parseFloat(defResult.text('decimals'));
                if (isFinite(numVal)) {
                    return Promise.resolve({
                        latex: defResult.toTeX(),
                        tier: 'nerdamer'
                    });
                }
            }

            // Indefinite
            var result = nm('integrate(' + nExpr + ', ' + v + ')');
            var txt = result.text();
            // Reject unresolved integrals
            if (txt && txt.indexOf('integrate(') !== -1) {
                // Fall through to SymPy
            } else {
                var resultTeX = result.toTeX();
                if (isDefinite) {
                    // Evaluate antiderivative at bounds
                    try {
                        var aNum = core.evalBound(lower, nm);
                        var bNum = core.evalBound(upper, nm);
                        var scope = {};
                        scope[v] = bNum;
                        var Fb = parseFloat(nm(txt).evaluate(scope).text('decimals'));
                        scope[v] = aNum;
                        var Fa = parseFloat(nm(txt).evaluate(scope).text('decimals'));
                        if (isFinite(Fb) && isFinite(Fa)) {
                            var val = Fb - Fa;
                            // Try to get exact form
                            var exactTex;
                            try { exactTex = nm(Fb + '-(' + Fa + ')').toTeX(); } catch (_) { exactTex = String(val); }
                            return Promise.resolve({ latex: exactTex + ' \\approx ' + val.toFixed(6), tier: 'nerdamer' });
                        }
                    } catch (_) {}
                } else {
                    return Promise.resolve({ latex: resultTeX + ' + C', tier: 'nerdamer' });
                }
            }
        } catch (_) {}

        // --- SymPy fallback ---
        var pyExpr = nerdamerToPython(nExpr);
        if (!pyExpr) return Promise.resolve(null);

        var symDecl = buildSympySymbolsDecl(v, pyExpr);
        var pyOp;
        if (isDefinite) {
            var pyLower = (lower || '0').replace(/\\infty/g, 'oo').replace(/\\pi/g, 'pi').replace(/\\frac\{([^}]+)\}\{([^}]+)\}/g, '(($1)/($2))');
            var pyUpper = (upper || '1').replace(/\\infty/g, 'oo').replace(/\\pi/g, 'pi').replace(/\\frac\{([^}]+)\}\{([^}]+)\}/g, '(($1)/($2))');
            pyOp = 'integrate(' + pyExpr + ', (' + v + ', ' + pyLower + ', ' + pyUpper + '))';
        } else {
            pyOp = 'integrate(' + pyExpr + ', ' + v + ')';
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
            if (!tex || /^\\int/.test(tex)) return null;  // Reject unevaluated
            return { latex: tex + (isDefinite ? '' : ' + C'), tier: 'sympy' };
        }).catch(function () { return null; });
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
        if (/\\error/.test(rl)) return false;           // CE error marker
        if (/\\blacksquare/.test(rl)) return false;     // CE error square
        if (/1e\+\d+/.test(rl)) return false;           // floating-point noise (huge numbers)
        if (/\d{12,}/.test(rl)) return false;            // enormous integer literals (numeric noise)
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

        // Detect function-definition names: single letter at the START followed by \left( or (
        // before the first = sign. e.g. f\left(x\right)=..., g(t)=...
        // Only look at the LHS of the equation to avoid false positives.
        var funcNames = {};
        var eqIdx = latex.indexOf('=');
        var lhsPart = eqIdx > 0 ? latex.substring(0, eqIdx) : '';
        if (lhsPart) {
            var fnMatch = lhsPart.match(/^([a-zA-Z])\s*\\left\(/) || lhsPart.match(/^([a-zA-Z])\s*\(/);
            if (fnMatch) funcNames[fnMatch[1]] = true;
        }

        var cleaned = latex
            .replace(/\\(frac|sqrt|int|sum|prod|lim|sin|cos|tan|log|ln|exp|cdot|left|right|begin|end|mathrm|text|operatorname)\b/g, '')
            .replace(/\\[a-zA-Z]+/g, '')
            .replace(/[{}()\[\]^_=+\-*/\\|,.:;!<>0-9\s]/g, ' ');
        var tokens = cleaned.split(/\s+/).filter(function (t) { return t.length > 0; });
        var seen = {};
        var result = [];
        for (var i = 0; i < tokens.length; i++) {
            if (/^[a-zA-Z]$/.test(tokens[i]) && !seen[tokens[i]]) {
                // Skip constants and function names
                if (tokens[i] === 'd' || tokens[i] === 'e' || tokens[i] === 'i') continue;
                if (funcNames[tokens[i]]) continue;
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
                        // Reject garbage results: floating-point noise in complex roots,
                        // huge denominators from numeric approximation, or too many solutions
                        // (e.g. sin(x)=0 returns 35 numeric values instead of x=nπ)
                        if (/1e\+\d+/.test(tex) || /\d{10,}/.test(tex)) return null;
                        var solCount = (tex.match(/,/g) || []).length + 1;
                        if (solCount > 10) return null;  // too many numeric roots — let SymPy give closed form
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
        { id: 'solveODE',   icon: 'ODE',        label: 'Solve ODE',  title: 'Solve ordinary differential equation', conditional: true },
        { id: 'solvePDE',   icon: 'PDE',        label: 'Solve PDE',  title: 'Solve partial differential equation', conditional: true },
        { id: 'limit',      icon: 'lim',        label: 'Limit',      title: 'Evaluate limit', conditional: true },
        { id: 'taylor',     icon: 'T\u2099',    label: 'Series',     title: 'Taylor/Maclaurin series expansion', conditional: true },
        { id: 'laplace',    icon: '\u2112',      label: 'Laplace',    title: 'Laplace transform', conditional: true },
        { id: 'solveSys',   icon: '{=}',        label: 'Solve System', title: 'Solve system of equations', conditional: true },
        { id: 'matDet',     icon: '|A|',        label: 'Det',        title: 'Determinant', conditional: true },
        { id: 'matInv',     icon: 'A\u207B\u00B9', label: 'Inverse', title: 'Matrix inverse', conditional: true },
        { id: 'matTrans',   icon: 'A\u1D40',    label: 'Transpose',  title: 'Matrix transpose', conditional: true },
        { id: 'matEig',     icon: '\u03BB',      label: 'Eigen',      title: 'Eigenvalues & eigenvectors', conditional: true },
        { id: 'matRREF',    icon: 'RREF',       label: 'RREF',       title: 'Row echelon form', conditional: true },
        { id: 'matRank',    icon: 'rk',         label: 'Rank',       title: 'Matrix rank', conditional: true },
        { id: 'plot',       icon: '\uD83D\uDCC8', label: 'Plot',    title: 'Plot this equation as a graph' }
    ];

    // =========================================================
    //  ODE/PDE DETECTION
    //  Detects differential equation notation in LaTeX:
    //    ODE: y', y'', dy/dx, d²y/dx², \frac{dy}{dx}
    //    PDE: ∂u/∂x, ∂²u/∂t², \frac{\partial u}{\partial x}
    // =========================================================
    function detectDEType(latex) {
        if (!latex) return null;
        // PDE patterns (check first — more specific)
        if (/\\partial/.test(latex) || /\\frac\{\\partial/.test(latex)) return 'pde';
        // ODE patterns
        if (/y'+|y''+|y'''+/.test(latex)) return 'ode';
        if (/\\frac\{d\^?\{?\d?\}?y\}\{dx/.test(latex)) return 'ode';
        if (/\\frac\{d\^?\{?2\}?y\}\{dx\^?\{?2\}?\}/.test(latex)) return 'ode';
        if (/\\dot\{y\}|\\ddot\{y\}/.test(latex)) return 'ode';
        if (/dy\/dx|d\^2y\/dx\^2/.test(latex)) return 'ode';
        return null;
    }

    /**
     * Solve an ODE via SymPy dsolve.
     * Converts LaTeX to Python, calls dsolve, returns { latex, tier }.
     */
    function solveODE(latex) {
        var nm = window.nerdamer || nerd;
        var pyExpr = '';

        // Try nerdamer convertFromLaTeX → Python
        try {
            pyExpr = nm.convertFromLaTeX(latex.replace(/\\ln\b/g, '\\log')).toString();
            pyExpr = nerdamerToPython(pyExpr);
        } catch (_) {}

        // Fallback: manual LaTeX → Python conversion for common ODE patterns
        if (!pyExpr) {
            pyExpr = latex
                .replace(/\\frac\{d\^?\{?(\d+)\}?y\}\{dx\^?\{?\1\}?\}/g, 'Derivative(y(x), x, $1)')
                .replace(/\\frac\{dy\}\{dx\}/g, "y(x).diff(x)")
                .replace(/y'''/g, 'Derivative(y(x), x, 3)')
                .replace(/y''/g, 'Derivative(y(x), x, 2)')
                .replace(/y'/g, "y(x).diff(x)")
                .replace(/\\dot\{y\}/g, "y(x).diff(x)")
                .replace(/\\ddot\{y\}/g, 'Derivative(y(x), x, 2)')
                .replace(/\\left|\\right/g, '')
                .replace(/\\sin/g, 'sin').replace(/\\cos/g, 'cos').replace(/\\tan/g, 'tan')
                .replace(/\\ln/g, 'log').replace(/\\log/g, 'log')
                .replace(/\\exp/g, 'exp').replace(/\\sqrt/g, 'sqrt')
                .replace(/\{/g, '(').replace(/\}/g, ')')
                .replace(/\^/g, '**');
        }

        // Handle y → y(x) for standalone y
        // \b doesn't work between digit and letter (both \w), so use lookaround
        pyExpr = pyExpr.replace(/([^a-zA-Z])y(?!\()/g, '$1y(x)');  // non-letter + y → y(x)
        pyExpr = pyExpr.replace(/^y(?!\()/g, 'y(x)');              // y at start
        // Insert * for implicit multiplication: 2y(x) → 2*y(x), 2x → 2*x
        pyExpr = pyExpr.replace(/(\d)(y\(x\))/g, '$1*$2');
        pyExpr = pyExpr.replace(/(\d)([a-wz])\b/g, '$1*$2');
        pyExpr = pyExpr.replace(/\)(y\(x\))/g, ')*$1');
        pyExpr = pyExpr.replace(/\)([a-wz])\b/g, ')*$1');

        // Handle equations: lhs=rhs → Eq(lhs, rhs)
        var eqSplit = pyExpr.split('=');
        if (eqSplit.length === 2 && eqSplit[0].trim() && eqSplit[1].trim()) {
            pyExpr = 'Eq(' + eqSplit[0].trim() + ', ' + eqSplit[1].trim() + ')';
        }

        var code = 'from sympy import *\n' +
            'x = symbols("x")\n' +
            'y = Function("y")\n' +
            'ode = ' + pyExpr + '\n' +
            'solution = dsolve(ode, y(x))\n' +
            'print("LATEX:" + latex(solution))';

        return runSymPy(code).then(function (stdout) {
            if (!stdout) return null;
            var m = stdout.match(/LATEX:([^\n]*)/);
            if (!m || !m[1]) return null;
            return { latex: m[1].trim(), tier: 'sympy' };
        }).catch(function () { return null; });
    }

    /**
     * Solve a PDE via SymPy pdsolve.
     */
    function solvePDE(latex) {
        // Manual LaTeX → Python for PDE
        var pyExpr = latex
            .replace(/\\frac\{\\partial\^?\{?(\d+)\}?\s*u\}\{\\partial\s*([a-zA-Z])\^?\{?\1\}?\}/g, 'Derivative(u($2, t), $2, $1)')
            .replace(/\\frac\{\\partial\s*u\}\{\\partial\s*([a-zA-Z])\}/g, 'Derivative(u(x, t), $1)')
            .replace(/\\partial/g, '')
            .replace(/\\left|\\right/g, '')
            .replace(/\\sin/g, 'sin').replace(/\\cos/g, 'cos')
            .replace(/\\ln/g, 'log').replace(/\\exp/g, 'exp')
            .replace(/\{/g, '(').replace(/\}/g, ')')
            .replace(/\^/g, '**');

        pyExpr = pyExpr.replace(/\bu\b(?!\()/g, 'u(x, t)');
        pyExpr = pyExpr.replace(/(\d)(u\(x, t\))/g, '$1*$2');
        pyExpr = pyExpr.replace(/(\d)([a-tv-z])\b/g, '$1*$2');

        // Handle equations
        var pdeSplit = pyExpr.split('=');
        if (pdeSplit.length === 2 && pdeSplit[0].trim() && pdeSplit[1].trim()) {
            pyExpr = 'Eq(' + pdeSplit[0].trim() + ', ' + pdeSplit[1].trim() + ')';
        }

        var code = 'from sympy import *\n' +
            'x, t = symbols("x t")\n' +
            'u = Function("u")\n' +
            'pde = ' + pyExpr + '\n' +
            'try:\n' +
            '    solution = pdsolve(pde)\n' +
            '    print("LATEX:" + latex(solution))\n' +
            'except Exception as e:\n' +
            '    print("ERROR:" + str(e))';

        return runSymPy(code).then(function (stdout) {
            if (!stdout) return null;
            if (stdout.indexOf('ERROR:') === 0) return null;
            var m = stdout.match(/LATEX:([^\n]*)/);
            if (!m || !m[1]) return null;
            return { latex: m[1].trim(), tier: 'sympy' };
        }).catch(function () { return null; });
    }

    // =========================================================
    //  MATRIX ENGINE
    //  Parses \begin{pmatrix/bmatrix/vmatrix}...LaTeX → nerdamer matrix()
    //  Client-side: det, inverse, transpose, multiply, add
    //  Server-side (SymPy): eigenvalues, RREF, rank, LU, QR
    // =========================================================

    /** Detect if LaTeX contains a matrix */
    function isMatrixLatex(latex) {
        if (!latex) return false;
        return /\\begin\{[pbvBV]?matrix\}/.test(latex);
    }

    /**
     * Convert a single matrix LaTeX block → nerdamer matrix(...) text.
     */
    function singleMatrixToNerdamer(body) {
        var rows = body.split(/\\\\|\\cr/).map(function (r) { return r.trim(); }).filter(Boolean);
        var nRows = [];
        for (var i = 0; i < rows.length; i++) {
            var cols = rows[i].split('&').map(function (c) {
                var val = c.trim();
                val = val.replace(/\\frac\{([^}]+)\}\{([^}]+)\}/g, '(($1)/($2))');
                val = val.replace(/\\sqrt\{([^}]+)\}/g, 'sqrt($1)');
                val = val.replace(/\\sin/g, 'sin').replace(/\\cos/g, 'cos').replace(/\\tan/g, 'tan');
                val = val.replace(/\\ln/g, 'log').replace(/\\log/g, 'log');
                val = val.replace(/\\pi/g, 'pi').replace(/\\infty/g, 'Infinity');
                val = val.replace(/\{/g, '(').replace(/\}/g, ')');
                val = val.replace(/\\left|\\right/g, '').replace(/\\[,;!]/g, '');
                return val;
            });
            nRows.push('[' + cols.join(',') + ']');
        }
        return 'matrix(' + nRows.join(',') + ')';
    }

    /**
     * Convert full LaTeX expression (may contain multiple matrices + operators)
     * to nerdamer text. Replaces each \begin{...matrix}...\end{...matrix}
     * with matrix(...) and cleans LaTeX operators.
     */
    function matrixLatexToNerdamer(latex) {
        var result = latex.replace(
            /\\begin\{[pbvBV]?matrix\}([\s\S]*?)\\end\{[pbvBV]?matrix\}/g,
            function (_, body) { return singleMatrixToNerdamer(body); }
        );
        // Clean remaining LaTeX operators
        result = result.replace(/\\cdot/g, '*').replace(/\\times/g, '*');
        result = result.replace(/\\left|\\right/g, '');
        result = result.replace(/\{/g, '(').replace(/\}/g, ')');
        // ^ on a matrix should be matpow — nerdamer does element-wise, so leave it
        // (we'll handle matrix power via SymPy when needed)
        return result;
    }

    /**
     * Convert a single matrix LaTeX block → SymPy Matrix([[...],...])
     */
    function singleMatrixToSymPy(body) {
        var rows = body.split(/\\\\|\\cr/).map(function (r) { return r.trim(); }).filter(Boolean);
        var pyRows = [];
        for (var i = 0; i < rows.length; i++) {
            var cols = rows[i].split('&').map(function (c) {
                var val = c.trim();
                val = val.replace(/\\frac\{([^}]+)\}\{([^}]+)\}/g, 'Rational($1,$2)');
                val = val.replace(/\\sqrt\{([^}]+)\}/g, 'sqrt($1)');
                val = val.replace(/\\sin/g, 'sin').replace(/\\cos/g, 'cos');
                val = val.replace(/\\ln/g, 'log').replace(/\\pi/g, 'pi');
                val = val.replace(/\{/g, '').replace(/\}/g, '');
                val = val.replace(/\\left|\\right/g, '');
                val = val.replace(/\^/g, '**');
                return val;
            });
            pyRows.push('[' + cols.join(', ') + ']');
        }
        return 'Matrix([' + pyRows.join(', ') + '])';
    }

    /**
     * Convert full LaTeX expression → SymPy.
     */
    function matrixLatexToSymPy(latex) {
        var result = latex.replace(
            /\\begin\{[pbvBV]?matrix\}([\s\S]*?)\\end\{[pbvBV]?matrix\}/g,
            function (_, body) { return singleMatrixToSymPy(body); }
        );
        result = result.replace(/\\cdot/g, '*').replace(/\\times/g, '*');
        result = result.replace(/\\left|\\right/g, '');
        result = result.replace(/\{/g, '(').replace(/\}/g, ')');
        result = result.replace(/\^/g, '**');
        return result;
    }

    /**
     * Perform a matrix action via nerdamer (client-side, instant).
     * Returns { latex } or null.
     */
    function matrixViaNerdamer(action, latex) {
        var nm = window.nerdamer || nerd;
        if (!nm) return null;

        var nExpr = matrixLatexToNerdamer(latex);
        if (!nExpr) return null;

        try {
            var result;
            switch (action) {
                case 'matDet':
                    result = nm('determinant(' + nExpr + ')');
                    return { latex: result.toTeX() };
                case 'matInv':
                    result = nm('invert(' + nExpr + ')');
                    return { latex: result.toTeX() };
                case 'matTrans':
                    result = nm('transpose(' + nExpr + ')');
                    return { latex: result.toTeX() };
                case 'matEval':
                    // Evaluate full expression: A*B, A+B, 3A, etc.
                    result = nm(nExpr);
                    return { latex: result.toTeX() };
                default:
                    return null;
            }
        } catch (_) {
            return null;
        }
    }

    /**
     * Perform a matrix action via SymPy (server-side).
     * Handles: eigenvalues, RREF, rank, power, linear system, and fallback.
     */
    function matrixViaSymPy(action, latex) {
        var pyExpr = matrixLatexToSymPy(latex);
        if (!pyExpr) return Promise.resolve(null);

        // Detect symbols used (x, y, z, etc.) for linear system solving
        var symbols = [];
        var symMatch = pyExpr.match(/\b([a-wz])\b/g);
        if (symMatch) {
            var seen = {};
            symMatch.forEach(function (s) {
                if (!seen[s] && !/^(e|i|d)$/.test(s)) { seen[s] = true; symbols.push(s); }
            });
        }
        var symDecl = symbols.length > 0
            ? symbols.join(', ') + ' = symbols("' + symbols.join(' ') + '")\n'
            : '';

        var pyOp;
        switch (action) {
            case 'matDet':
                pyOp = 'A = ' + pyExpr + '\nprint("LATEX:" + latex(A.det()))';
                break;
            case 'matInv':
                pyOp = 'A = ' + pyExpr + '\nprint("LATEX:" + latex(A.inv()))';
                break;
            case 'matTrans':
                pyOp = 'A = ' + pyExpr + '\nprint("LATEX:" + latex(A.T))';
                break;
            case 'matEig':
                pyOp = 'A = ' + pyExpr + '\n' +
                    'evecs = A.eigenvects()\n' +
                    'parts = []\n' +
                    'for val, mult, vecs in evecs:\n' +
                    '    part = r"\\lambda = " + latex(val)\n' +
                    '    if mult > 1: part += r" \\;(\\times " + str(mult) + ")"\n' +
                    '    for v in vecs:\n' +
                    '        part += r", \\; \\mathbf{v} = " + latex(v)\n' +
                    '    parts.append(part)\n' +
                    'print("LATEX:" + r" \\\\[4pt] ".join(parts))';
                break;
            case 'matRREF':
                pyOp = 'A = ' + pyExpr + '\n' +
                    'rref, pivots = A.rref()\n' +
                    'print("LATEX:" + latex(rref) + r" \\quad \\text{pivots: }" + str(list(pivots)))';
                break;
            case 'matRank':
                pyOp = 'A = ' + pyExpr + '\nprint("LATEX:" + str(A.rank()))';
                break;
            case 'matPower':
                // Matrix power: A^n → A**n (proper matrix multiplication)
                pyOp = 'result = ' + pyExpr + '\nprint("LATEX:" + latex(result))';
                break;
            case 'matEval':
                // Evaluate a full matrix expression: A*B, A+B, 3A, A^2, etc.
                pyOp = 'result = ' + pyExpr + '\nprint("LATEX:" + latex(result))';
                break;
            case 'matSolve':
                // Solve Ax = b → find x
                // Detect if it's an equation: ... = ...
                var eqParts = pyExpr.split('=');
                if (eqParts.length === 2) {
                    pyOp = 'A_expr = ' + eqParts[0].trim() + '\n' +
                        'b = ' + eqParts[1].trim() + '\n' +
                        'from sympy import linsolve\n' +
                        'sol = linsolve((A_expr, b))\n' +
                        'print("LATEX:" + latex(sol))';
                } else {
                    return Promise.resolve(null);
                }
                break;
            default:
                return Promise.resolve(null);
        }

        var code = 'from sympy import *\n' + symDecl + pyOp;

        return runSymPy(code).then(function (stdout) {
            if (!stdout) return null;
            var m = stdout.match(/LATEX:([^\n]*)/);
            if (!m || !m[1]) return null;
            return { latex: m[1].trim(), tier: 'sympy' };
        }).catch(function () { return null; });
    }

    /**
     * Perform matrix action: try nerdamer first (instant), fall back to SymPy.
     */
    function performMatrixAction(action, mf) {
        var fullLatex = readLatex(mf);
        if (!fullLatex) return;

        var cBtn = actionBar ? actionBar.querySelector('[data-action="' + action + '"]') : null;
        var aBtns = actionBar ? actionBar.querySelectorAll('.me-compute-btn') : [];
        var oLabel = cBtn ? cBtn.innerHTML : '';
        if (cBtn) {
            cBtn.innerHTML = '<span class="me-compute-icon" aria-hidden="true">\u23F3</span> Computing\u2026';
            cBtn.classList.add('me-btn-loading');
        }
        for (var j = 0; j < aBtns.length; j++) { aBtns[j].disabled = true; }
        showNodeLoading(currentMathNode);

        function onDone(r) {
            if (cBtn) { cBtn.innerHTML = oLabel; cBtn.classList.remove('me-btn-loading'); }
            for (var k = 0; k < aBtns.length; k++) { aBtns[k].disabled = false; }
            hideNodeLoading(currentMathNode);
            if (r) {
                var labels = { matDet: 'det', matInv: 'inverse', matTrans: 'transpose',
                    matEig: 'eigenvalues', matRREF: 'RREF', matRank: 'rank' };
                showResultPopover(mf, r.latex, fullLatex + ' \\Rightarrow ' + r.latex);
            } else {
                showToast('Could not compute — matrix may be singular or invalid', 3000);
            }
        }

        // Try nerdamer first for det/inv/trans/eval (instant, client-side)
        if (action === 'matDet' || action === 'matInv' || action === 'matTrans' || action === 'matEval') {
            var nResult = matrixViaNerdamer(action, fullLatex);
            if (nResult) {
                onDone(nResult);
                return;
            }
        }

        // Fall back to SymPy for everything else (eigenvalues, RREF, rank)
        matrixViaSymPy(action, fullLatex).then(onDone);
    }

    // =========================================================
    //  LIMITS, SERIES, LAPLACE, SYSTEMS — Detection & Solve
    //  All route to SymPy via OneCompiler.
    // =========================================================

    /** Detect \lim notation */
    function isLimitLatex(latex) {
        return /\\lim/.test(latex);
    }

    /** Detect series/sum notation: \sum, \Sigma, Taylor/Maclaurin keywords */
    function isSeriesLatex(latex) {
        return /\\sum/.test(latex) || /\\Sigma/.test(latex);
    }

    /** Detect Laplace transform: \mathcal{L}, L{}, laplace */
    function isLaplaceLatex(latex) {
        return /\\mathcal\{L\}/.test(latex) || /\\mathscr\{L\}/.test(latex) || /\\text\{laplace\}/i.test(latex);
    }

    /** Detect system of equations: multiple lines with = (via \\ or cases environment) */
    function isSystemLatex(latex) {
        if (/\\begin\{cases\}/.test(latex)) return true;
        if (/\\begin\{aligned\}/.test(latex) && (latex.match(/=/g) || []).length >= 2) return true;
        return false;
    }

    /**
     * Evaluate a limit via SymPy.
     * Parses: \lim_{x \to a} f(x)
     */
    function solveLimit(latex) {
        // Extract: \lim_{VAR \to POINT} EXPR
        var m = latex.match(/\\lim\s*_\s*\{?\s*([a-zA-Z])\s*\\to\s*([^}]+)\}?\s*([\s\S]*)/);
        var v = 'x', point = '0', expr = latex.replace(/\\lim.*?\}/, '').trim();
        if (m) { v = m[1]; point = m[2].trim(); expr = m[3].trim(); }

        // Clean LaTeX → Python
        point = point.replace(/\\infty/g, 'oo').replace(/\\pi/g, 'pi').replace(/\{/g, '').replace(/\}/g, '');
        var pyExpr = latexToPython(expr);

        var code = 'from sympy import *\n' +
            v + ' = symbols("' + v + '")\n' +
            'result = limit(' + pyExpr + ', ' + v + ', ' + point + ')\n' +
            'print("LATEX:" + latex(result))';

        return runSymPy(code).then(extractLatexResult).catch(returnNull);
    }

    /**
     * Compute Taylor/Maclaurin series via SymPy.
     * For \sum notation, evaluates the sum. For plain expressions, expands as Taylor around 0.
     */
    function solveSeries(latex) {
        var pyExpr = latexToPython(latex);

        // If it's a \sum, try to evaluate it
        if (/\\sum/.test(latex)) {
            // Parse: \sum_{n=a}^{b} f(n)
            var m = latex.match(/\\sum\s*_\s*\{?\s*([a-zA-Z])\s*=\s*([^}]+)\}\s*\^\s*\{?([^}]+)\}?\s*([\s\S]*)/);
            if (m) {
                var v = m[1], lo = m[2].trim(), hi = m[3].trim(), body = m[4].trim();
                hi = hi.replace(/\\infty/g, 'oo').replace(/\\pi/g, 'pi');
                lo = lo.replace(/\\pi/g, 'pi');
                var pyBody = latexToPython(body);
                var code = 'from sympy import *\n' +
                    v + ' = symbols("' + v + '")\n' +
                    'result = summation(' + pyBody + ', (' + v + ', ' + lo + ', ' + hi + '))\n' +
                    'print("LATEX:" + latex(result))';
                return runSymPy(code).then(extractLatexResult).catch(returnNull);
            }
        }

        // Fallback: Taylor series expansion around 0, 6 terms
        var vars = detectVarsFromLatex(latex);
        var v = vars.length > 0 ? vars[0] : 'x';
        var code = 'from sympy import *\n' +
            v + ' = symbols("' + v + '")\n' +
            'result = series(' + pyExpr + ', ' + v + ', 0, n=6)\n' +
            'print("LATEX:" + latex(result))';

        return runSymPy(code).then(extractLatexResult).catch(returnNull);
    }

    /**
     * Compute Laplace transform via SymPy.
     */
    function solveLaplace(latex) {
        // Strip \mathcal{L}\{ ... \} wrapper
        var inner = latex
            .replace(/\\mathcal\{L\}\s*\\?\{?\s*/, '')
            .replace(/\\mathscr\{L\}\s*\\?\{?\s*/, '')
            .replace(/\}\s*$/, '').trim();
        if (!inner) inner = latex;

        var pyExpr = latexToPython(inner);

        var code = 'from sympy import *\n' +
            't, s = symbols("t s")\n' +
            'f = ' + pyExpr + '\n' +
            'F, a, cond = laplace_transform(f, t, s)\n' +
            'print("LATEX:" + latex(F))';

        return runSymPy(code).then(extractLatexResult).catch(returnNull);
    }

    /**
     * Solve system of equations via SymPy.
     * Parses \begin{cases} or \begin{aligned} with multiple = equations.
     */
    /**
     * Extract equations from \begin{cases} or \begin{aligned} LaTeX.
     */
    function extractSystemEquations(latex) {
        var equations = [];
        if (/\\begin\{cases\}/.test(latex)) {
            var body = latex.match(/\\begin\{cases\}([\s\S]*?)\\end\{cases\}/);
            if (body) {
                equations = body[1].split(/\\\\/).map(function (l) {
                    return l.replace(/&/g, '').replace(/\\text\{.*?\}/g, '').trim();
                }).filter(Boolean);
            }
        } else if (/\\begin\{aligned\}/.test(latex)) {
            var body2 = latex.match(/\\begin\{aligned\}([\s\S]*?)\\end\{aligned\}/);
            if (body2) {
                equations = body2[1].split(/\\\\/).map(function (l) {
                    return l.replace(/&/g, '').trim();
                }).filter(Boolean);
            }
        }
        return equations;
    }

    function solveSystem(latex) {
        var equations = extractSystemEquations(latex);
        if (equations.length < 2) return Promise.resolve(null);

        // Detect all variables
        var allVars = {};
        equations.forEach(function (eq) {
            detectVarsFromLatex(eq).forEach(function (v) { allVars[v] = true; });
        });
        var varList = Object.keys(allVars).sort();
        if (varList.length === 0) return Promise.resolve(null);

        // --- Tier 1: nerdamer.solveEquations (instant, client-side) ---
        var nm = window.nerdamer || nerd;
        if (nm && nm.solveEquations) {
            try {
                // Convert LaTeX equations to nerdamer text (split on = to avoid assignment)
                var nerdEqs = equations.map(function (eq) {
                    try { return eqLatexToNerdamer(eq); }
                    catch (_) { return eq; }
                });
                var sol = nm.solveEquations(nerdEqs, varList);
                if (sol && sol.length > 0) {
                    // Format as LaTeX: x = 1, y = 2
                    var parts = sol.map(function (s) { return s[0] + ' = ' + s[1]; });
                    var resultLatex = parts.join(', \\quad ');
                    // Also get plottable y=f(x) forms from each equation
                    var plotEqs = [];
                    equations.forEach(function (eq) {
                        try {
                            var nExpr = eqLatexToNerdamer(eq);
                            var ySol = nm.solve(nExpr, 'y');
                            if (ySol) {
                                var yText = ySol.text();
                                if (yText && yText !== '[]' && !yText.includes('solve')) {
                                    yText = yText.replace(/^\[/, '').replace(/\]$/, '');
                                    try { yText = nm('expand(' + yText + ')').text(); } catch (_) {}
                                    plotEqs.push('y = ' + yText);
                                }
                            }
                        } catch (_) {}
                    });
                    return Promise.resolve({
                        latex: resultLatex,
                        tier: 'nerdamer',
                        plotEquations: plotEqs.length > 0 ? plotEqs : null
                    });
                }
            } catch (_) {
                // Fall through to SymPy
            }
        }

        // --- Tier 2: SymPy (server, symbolic, all roots) ---
        // Convert each equation to SymPy Eq()
        var pyEqs = equations.map(function (eq) {
            var parts = eq.split('=');
            if (parts.length === 2) {
                return 'Eq(' + latexToPython(parts[0]) + ', ' + latexToPython(parts[1]) + ')';
            }
            return latexToPython(eq);
        });

        // Also solve each equation for y (for plotting)
        var solveForYCode = equations.map(function (eq, i) {
            var parts = eq.split('=');
            if (parts.length === 2) {
                var pyLHS = latexToPython(parts[0]);
                var pyRHS = latexToPython(parts[1]);
                return 'try:\n' +
                    '    _ysol' + i + ' = solve(Eq(' + pyLHS + ', ' + pyRHS + '), y)\n' +
                    '    if _ysol' + i + ': print("PLOT_EQ:y = " + str(_ysol' + i + '[0]))\n' +
                    'except: pass';
            }
            return '';
        }).filter(Boolean).join('\n');

        var code = 'from sympy import *\n' +
            varList.join(', ') + ' = symbols("' + varList.join(' ') + '")\n' +
            'result = solve([' + pyEqs.join(', ') + '], [' + varList.join(', ') + '])\n' +
            'print("LATEX:" + latex(result))\n' +
            solveForYCode;

        return runSymPy(code).then(function (stdout) {
            if (!stdout) return null;
            var m = stdout.match(/LATEX:([^\n]*)/);
            if (!m || !m[1]) return null;

            // Extract plottable y=f(x) forms
            var plotEqs = [];
            var plotMatches = stdout.match(/PLOT_EQ:(.*)/g);
            if (plotMatches) {
                plotMatches.forEach(function (pm) {
                    var eq = pm.replace('PLOT_EQ:', '').trim();
                    if (eq) plotEqs.push(eq);
                });
            }

            return { latex: m[1].trim(), tier: 'sympy', plotEquations: plotEqs };
        }).catch(returnNull);
    }

    /** Quick LaTeX → Python converter (covers common patterns) */
    /** Convert LaTeX equation to nerdamer text, handling = properly.
     *  convertFromLaTeX treats = as assignment (drops LHS), so we split first. */
    function eqLatexToNerdamer(eqLatex) {
        var nm = window.nerdamer || nerd;
        if (!nm) return eqLatex;
        var parts = eqLatex.split('=');
        if (parts.length === 2 && parts[0].trim() && parts[1].trim()) {
            var lhs = nm.convertFromLaTeX(parts[0].trim().replace(/\\ln\b/g, '\\log')).toString();
            var rhs = nm.convertFromLaTeX(parts[1].trim().replace(/\\ln\b/g, '\\log')).toString();
            return lhs + '=(' + rhs + ')';
        }
        return nm.convertFromLaTeX(eqLatex.replace(/\\ln\b/g, '\\log')).toString();
    }

    function latexToPython(latex) {
        if (!latex) return '';
        var nm = window.nerdamer || nerd;
        // Try nerdamer first
        if (nm) {
            try {
                var nExpr = nm.convertFromLaTeX(latex.replace(/\\ln\b/g, '\\log')).toString();
                return nerdamerToPython(nExpr);
            } catch (_) {}
        }
        // Fallback: manual conversion
        return latex
            .replace(/\\frac\{([^}]+)\}\{([^}]+)\}/g, '(($1)/($2))')
            .replace(/\\sqrt\{([^}]+)\}/g, 'sqrt($1)')
            .replace(/\\sin/g, 'sin').replace(/\\cos/g, 'cos').replace(/\\tan/g, 'tan')
            .replace(/\\ln/g, 'log').replace(/\\log/g, 'log')
            .replace(/\\exp/g, 'exp').replace(/\\pi/g, 'pi').replace(/\\infty/g, 'oo')
            .replace(/\\left|\\right/g, '')
            .replace(/\{/g, '(').replace(/\}/g, ')').replace(/\^/g, '**')
            .replace(/\\cdot/g, '*').replace(/\\times/g, '*')
            .replace(/\\[,;!]/g, '').replace(/\\,/g, '');
    }

    /** Extract LATEX: line from SymPy output */
    function extractLatexResult(stdout) {
        if (!stdout) return null;
        var m = stdout.match(/LATEX:([^\n]*)/);
        if (!m || !m[1]) return null;
        return { latex: m[1].trim(), tier: 'sympy' };
    }
    function returnNull() { return null; }

    /**
     * Perform a limit/series/laplace/system action.
     */
    function performSpecialAction(action, mf) {
        var fullLatex = readLatex(mf);
        if (!fullLatex) return;

        var cBtn = actionBar ? actionBar.querySelector('[data-action="' + action + '"]') : null;
        var aBtns = actionBar ? actionBar.querySelectorAll('.me-compute-btn') : [];
        var oLabel = cBtn ? cBtn.innerHTML : '';
        if (cBtn) {
            cBtn.innerHTML = '<span class="me-compute-icon" aria-hidden="true">\u23F3</span> Computing\u2026';
            cBtn.classList.add('me-btn-loading');
        }
        for (var j = 0; j < aBtns.length; j++) { aBtns[j].disabled = true; }
        showNodeLoading(currentMathNode);

        var promise;
        switch (action) {
            case 'limit':   promise = solveLimit(fullLatex); break;
            case 'taylor':  promise = solveSeries(fullLatex); break;
            case 'laplace': promise = solveLaplace(fullLatex); break;
            case 'solveSys': promise = solveSystem(fullLatex); break;
            default: promise = Promise.resolve(null);
        }

        promise.then(function (r) {
            if (cBtn) { cBtn.innerHTML = oLabel; cBtn.classList.remove('me-btn-loading'); }
            for (var k = 0; k < aBtns.length; k++) { aBtns[k].disabled = false; }
            hideNodeLoading(currentMathNode);
            if (r) {
                // For systems, pass plotEquations so popover can offer "Solve & Plot"
                showResultPopover(mf, r.latex, fullLatex + ' = ' + r.latex,
                    r.plotEquations && r.plotEquations.length > 0 ? r.plotEquations : null);
            } else {
                showToast('Could not compute — check the expression syntax', 3000);
            }
        });
    }

    /**
     * Plot a system of equations: extract each equation, solve for y,
     * and render all curves on one graph via MeGraph.renderGraphMulti.
     */
    function plotSystemEquations(latex, mf) {
        var equations = extractSystemEquations(latex);
        if (equations.length < 2) {
            showToast('Need at least 2 equations to plot a system', 2000);
            return;
        }

        var nm = window.nerdamer || nerd;
        var plotEqs = [];

        // Solve each equation for y
        equations.forEach(function (eq) {
            if (!nm) return;
            try {
                var nExpr = eqLatexToNerdamer(eq);
                var ySol = nm.solve(nExpr, 'y');
                if (ySol) {
                    var yText = ySol.text().replace(/^\[/, '').replace(/\]$/, '');
                    if (yText) {
                        try { yText = nm('expand(' + yText + ')').text(); } catch (_) {}
                        plotEqs.push('y = ' + yText.replace(/\*\*/g, '^'));
                    }
                }
            } catch (_) {
                // If can't solve for y, try using the equation as-is (implicit)
                try {
                    plotEqs.push(eqLatexToNerdamer(eq).replace(/\*\*/g, '^'));
                } catch (_) {}
            }
        });

        if (plotEqs.length === 0) {
            showToast('Could not extract plottable equations', 3000);
            return;
        }

        var mathNode = mf ? mf.closest('.me-math-node') : null;
        showNodeLoading(mathNode);
        var labels = plotEqs.join(', ');

        window.MeGraph.renderGraphMulti(plotEqs).then(function (dataUrl) {
            hideNodeLoading(mathNode);
            var editor = window.MeEditor;
            if (editor) {
                editor.commands.setImage({
                    src: dataUrl,
                    alt: 'Graph of ' + labels,
                    title: labels
                });
            }
        }).catch(function (err) {
            hideNodeLoading(mathNode);
            showToast('Could not plot: ' + (err.message || err), 3000);
        });
    }

    function createActionBar() {
        var bar = document.createElement('div');
        bar.className = 'me-compute-bar';
        bar.setAttribute('role', 'toolbar');
        bar.setAttribute('aria-label', 'Math actions');
        var html = '';
        for (var i = 0; i < ACTIONS.length; i++) {
            var a = ACTIONS[i];
            if (i === 2 || i === 5) html += '<span class="me-compute-sep" aria-hidden="true"></span>';
            if (a.id === 'plot') html += '<span class="me-compute-sep" aria-hidden="true"></span>';
            // Conditional buttons (ODE/PDE) are hidden by default, shown when relevant
            var hideStyle = a.conditional ? ' style="display:none"' : '';
            html += '<button class="me-compute-btn" data-action="' + a.id + '" title="' + a.title + '"' +
                ' role="button" tabindex="0" aria-label="' + a.label + '"' + hideStyle + '>' +
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
                var plotLatex = readLatex(currentMathField);
                if (window.MeGraph) {
                    // If it's a system of equations, split into y=f(x) forms and plot all
                    if (isSystemLatex(plotLatex)) {
                        plotSystemEquations(plotLatex, currentMathField);
                    } else {
                        window.MeGraph.insertGraph(plotLatex, currentMathField);
                    }
                }
            } else if (action === 'solveODE' || action === 'solvePDE') {
                performDESolve(action, currentMathField);
            } else if (action === 'limit' || action === 'taylor' || action === 'laplace' || action === 'solveSys') {
                performSpecialAction(action, currentMathField);
            } else if (action.startsWith('mat')) {
                performMatrixAction(action, currentMathField);
            } else {
                performAction(action, currentMathField);
            }
        });
        bar.addEventListener('mousedown', function (e) { e.preventDefault(); });
        return bar;
    }

    /** Show/hide ODE/PDE buttons based on the current expression */
    function updateConditionalActions(latex) {
        if (!actionBar) return;
        var deType = detectDEType(latex);
        var hasMatrix = isMatrixLatex(latex);
        var hasLimit = isLimitLatex(latex);
        var hasSeries = isSeriesLatex(latex);
        var hasLaplace = isLaplaceLatex(latex);
        var hasSystem = isSystemLatex(latex);

        // ODE/PDE
        var odeBtn = actionBar.querySelector('[data-action="solveODE"]');
        var pdeBtn = actionBar.querySelector('[data-action="solvePDE"]');
        if (odeBtn) odeBtn.style.display = deType === 'ode' ? '' : 'none';
        if (pdeBtn) pdeBtn.style.display = deType === 'pde' ? '' : 'none';

        // Limit, Series, Laplace, System
        var specialActions = { limit: hasLimit, taylor: hasSeries, laplace: hasLaplace, solveSys: hasSystem };
        Object.keys(specialActions).forEach(function (id) {
            var btn = actionBar.querySelector('[data-action="' + id + '"]');
            if (btn) btn.style.display = specialActions[id] ? '' : 'none';
        });

        // Matrix
        var matActions = ['matDet', 'matInv', 'matTrans', 'matEig', 'matRREF', 'matRank'];
        for (var i = 0; i < matActions.length; i++) {
            var btn = actionBar.querySelector('[data-action="' + matActions[i] + '"]');
            if (btn) btn.style.display = hasMatrix ? '' : 'none';
        }
    }

    /** Perform ODE/PDE solve action */
    function performDESolve(action, mf) {
        var fullLatex = readLatex(mf);
        if (!fullLatex) return;

        var cBtn = actionBar ? actionBar.querySelector('[data-action="' + action + '"]') : null;
        var aBtns = actionBar ? actionBar.querySelectorAll('.me-compute-btn') : [];
        var oLabel = cBtn ? cBtn.innerHTML : '';
        if (cBtn) {
            cBtn.innerHTML = '<span class="me-compute-icon" aria-hidden="true">\u23F3</span> Solving\u2026';
            cBtn.classList.add('me-btn-loading');
        }
        for (var j = 0; j < aBtns.length; j++) { aBtns[j].disabled = true; }
        showNodeLoading(currentMathNode);

        var solvePromise = action === 'solveODE' ? solveODE(fullLatex) : solvePDE(fullLatex);

        solvePromise.then(function (r) {
            if (cBtn) { cBtn.innerHTML = oLabel; cBtn.classList.remove('me-btn-loading'); }
            for (var k = 0; k < aBtns.length; k++) { aBtns[k].disabled = false; }
            hideNodeLoading(currentMathNode);
            if (r) {
                showResultPopover(mf, r.latex, fullLatex + ' \\Rightarrow ' + r.latex);
                showToast('Solved via SymPy', 2000);
            } else {
                showToast('Could not solve this differential equation', 3000);
            }
        });
    }

    // =========================================================
    //  PERFORM ACTION — 3-tier cascade
    // =========================================================
    function performAction(action, mf, targetVar) {
        var fullLatex = readLatex(mf);
        if (!fullLatex) return;

        // Smart equation handling:
        // - "f(x) = x^2+1" or "y = sin(x)" → extract RHS for computation
        // - "2+2 = 4" (previous result) → strip the "= result", compute on LHS
        // - "x^2+1 = 0" (equation to solve) → keep as-is for solve action
        // - "x^2+1" (no equals) → use as-is
        var latex = fullLatex;
        var eqParts = fullLatex.split('=');
        if (eqParts.length === 2) {
            var lhs = eqParts[0].trim();
            var rhs = eqParts[1].trim();
            // If LHS looks like a function def (f(x), y, g(t)) → compute on the RHS
            if (/^[a-zA-Z]\s*\\left\(/.test(lhs) || /^[a-zA-Z]\s*\(/.test(lhs) || /^[a-zA-Z]$/.test(lhs)) {
                latex = rhs;
            }
            // If this looks like a previous result (LHS has operators, RHS is simpler or a number),
            // and the action is NOT "solve" → strip RHS, compute on LHS only.
            // e.g. "2+2 = 4", "x^2+2x+1 = (x+1)^2"
            else if (action !== 'solve') {
                latex = lhs;
            }
            // For "solve" action, keep the full equation (e.g. "x^2+1 = 0")
        } else if (eqParts.length > 2) {
            // Multiple equals — take the first part (everything before first =)
            latex = eqParts[0].trim();
        }
        if (!latex) latex = fullLatex;

        // --- Matrix-aware routing ---
        // If the expression contains matrices and user clicks Evaluate/Simplify,
        // route through the matrix pipeline instead of the generic CE/nerdamer path.
        if (isMatrixLatex(latex) && (action === 'evaluate' || action === 'simplify')) {
            performMatrixAction('matEval', mf);
            return;
        }

        // --- Integral-aware routing ---
        // If the LaTeX contains \int, parse it and route through integral-calculator-core.
        // This handles: user typed \int x^2+3x dx and clicks Evaluate/Simplify/Integrate.
        // IMPORTANT: original latex (with \int) is preserved for display; only the
        // integrand is extracted for computation.
        var parsed = parseIntegralLatex(latex);
        var originalLatexForDisplay = fullLatex;  // always preserve what the user wrote

        if (parsed) {
            // If user clicked "evaluate"/"simplify"/"integrate" on an \int expression,
            // compute the integral via the core engine.
            var shouldIntegrate = (action === 'evaluate' || action === 'simplify' || action === 'integrate');
            if (shouldIntegrate) {
                // Show loading
                var cBtn = actionBar ? actionBar.querySelector('[data-action="' + action + '"]') : null;
                var aBtns = actionBar ? actionBar.querySelectorAll('.me-compute-btn') : [];
                var oLabel = cBtn ? cBtn.innerHTML : '';
                if (cBtn) {
                    cBtn.innerHTML = '<span class="me-compute-icon" aria-hidden="true">\u23F3</span> Computing\u2026';
                    cBtn.classList.add('me-btn-loading');
                }
                for (var j = 0; j < aBtns.length; j++) { aBtns[j].disabled = true; }
                showNodeLoading(currentMathNode);

                computeIntegralViaCoreEngine(
                    parsed.integrand, parsed.variable,
                    parsed.lower, parsed.upper, parsed.isDefinite
                ).then(function (r) {
                    if (cBtn) { cBtn.innerHTML = oLabel; cBtn.classList.remove('me-btn-loading'); }
                    for (var k = 0; k < aBtns.length; k++) { aBtns[k].disabled = false; }
                    hideNodeLoading(currentMathNode);
                    if (r) {
                        // Use the original \int latex for display so the integral symbol is preserved
                        appendResultToField(mf, originalLatexForDisplay, r.latex, 'evaluate', parsed.variable);
                        if (r.tier === 'kings') showToast("Solved via King\u2019s Property (symmetry)", 2500);
                        else if (r.tier === 'sympy') showToast('Computed via advanced solver (SymPy)', 2000);
                    } else {
                        showToast('Could not evaluate this integral', 3000);
                    }
                });
                return;
            }
            // For other actions (derivative, expand, factor, solve) on an \int expression,
            // extract the integrand for computation. The original \int latex is preserved
            // in originalLatexForDisplay for the result display.
            latex = parsed.integrand;
        }

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
                    appendResultToField(mf, originalLatexForDisplay, r.latex, action, v);
                    if (r.tier === 'sympy' && !showedSolverMsg) {
                        showToast('Computed via advanced solver (SymPy)', 2000);
                    }
                }
            });
        });
    }

    /**
     * Show computation result.
     * Simple expressions (no \int): appends "= result" inline in the math-field.
     * Complex / \int expressions: shows a floating result popover with options
     * to insert inline, insert below, or copy — without touching the original.
     */
    function appendResultToField(mf, originalLatex, resultLatex, action, v) {
        var vStr = v || 'x';

        // Check if the result is essentially the same as the input (no-op)
        // Strip whitespace and compare normalized forms
        var normOrig = originalLatex.replace(/\s+/g, '').replace(/\\left|\\right/g, '');
        var normResult = resultLatex.replace(/\s+/g, '').replace(/\\left|\\right/g, '');
        // Also check the extracted RHS for f(x)= patterns
        var eqParts = normOrig.split('=');
        var origRHS = eqParts.length === 2 ? eqParts[1] : normOrig;
        if (normResult === normOrig || normResult === origRHS) {
            var labels = { simplify: 'Already simplified', expand: 'Already expanded',
                factor: 'Cannot factor further', evaluate: 'Already evaluated' };
            showToast(labels[action] || 'No change', 2000);
            return;
        }

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
                joined = originalLatex + " = " + resultLatex;
                break;
        }

        // Always show result in a floating popover — user decides what to do.
        // Never replace the original expression without user consent.
        showResultPopover(mf, resultLatex, joined);
    }

    // =========================================================
    //  RESULT POPOVER — non-intrusive result display
    //  Shows the computed result with actions: Insert Inline,
    //  Insert Below, Copy LaTeX. Doesn't modify the original.
    // =========================================================
    var resultPopover = null;

    function removeResultPopover() {
        if (resultPopover && resultPopover.parentNode) {
            resultPopover.remove();
        }
        resultPopover = null;
        // Restore action bar if a math node is still selected
        if (actionBar && currentMathNode) {
            actionBar.style.display = 'flex';
            positionActionBar();
        }
    }

    function showResultPopover(mf, resultLatex, fullJoinedLatex, plotEquations) {
        removeResultPopover();

        // Hide action bar while popover is visible — they overlap
        if (actionBar) actionBar.style.display = 'none';

        var pop = document.createElement('div');
        pop.className = 'me-result-popover';

        // Result preview (rendered via a read-only math-field)
        var preview = document.createElement('div');
        preview.className = 'me-result-popover-preview';
        var previewMf = document.createElement('math-field');
        previewMf.setAttribute('read-only', '');
        previewMf.className = 'me-result-popover-math';
        previewMf.value = '= ' + resultLatex;
        preview.appendChild(previewMf);
        pop.appendChild(preview);

        // Action buttons
        var actions = document.createElement('div');
        actions.className = 'me-result-popover-actions';

        var btnInline = document.createElement('button');
        btnInline.className = 'me-result-popover-btn';
        btnInline.textContent = 'Append inline';
        btnInline.title = 'Add result to this equation';
        btnInline.addEventListener('click', function () {
            mf.value = fullJoinedLatex;
            mf.dispatchEvent(new Event('input'));
            removeResultPopover();
        });
        actions.appendChild(btnInline);

        var btnBelow = document.createElement('button');
        btnBelow.className = 'me-result-popover-btn';
        btnBelow.textContent = 'Insert below';
        btnBelow.title = 'Insert result as new equation below';
        btnBelow.addEventListener('click', function () {
            if (window.MeEditor) {
                try {
                    var editor = window.MeEditor;
                    var sel = editor.state.selection;
                    var pos = sel.from;
                    var node = editor.state.doc.nodeAt(pos);
                    var after = pos + (node ? node.nodeSize : 1);
                    var docSize = editor.state.doc.content.size;
                    if (after >= docSize) {
                        editor.chain().focus()
                            .insertContentAt(after, [
                                { type: 'paragraph' },
                                { type: 'mathBlock', attrs: { latex: fullJoinedLatex } }
                            ]).run();
                    } else {
                        editor.chain().focus()
                            .insertContentAt(after, { type: 'mathBlock', attrs: { latex: fullJoinedLatex } })
                            .run();
                    }
                } catch (_) {
                    mf.value = fullJoinedLatex;
                    mf.dispatchEvent(new Event('input'));
                }
            }
            removeResultPopover();
        });
        actions.appendChild(btnBelow);

        var btnCopy = document.createElement('button');
        btnCopy.className = 'me-result-popover-btn me-result-popover-btn-secondary';
        btnCopy.textContent = 'Copy LaTeX';
        btnCopy.title = 'Copy result LaTeX to clipboard';
        btnCopy.addEventListener('click', function () {
            navigator.clipboard.writeText(resultLatex).then(function () {
                btnCopy.textContent = 'Copied!';
                setTimeout(function () { removeResultPopover(); }, 600);
            }).catch(function () {});
        });
        actions.appendChild(btnCopy);

        // "Plot System" button — only if we have plottable y=f(x) equations
        if (plotEquations && plotEquations.length > 0 && window.MeGraph) {
            var btnPlot = document.createElement('button');
            btnPlot.className = 'me-result-popover-btn';
            btnPlot.textContent = '\uD83D\uDCC8 Plot curves';
            btnPlot.title = 'Plot all equations on one graph';
            btnPlot.addEventListener('click', function () {
                removeResultPopover();
                // Convert nerdamer/Python text to LaTeX-style for the graph engine
                // "y = -x^2+5" → "y = -x^2+5" (already valid for graphing engine)
                var latexEqs = plotEquations.map(function (eq) {
                    return eq.replace(/\*\*/g, '^');
                });

                // Directly render multi-equation graph using the existing engine
                var labels = latexEqs.join(', ');
                showToast('Plotting: ' + labels.substring(0, 50) + '...', 2000);

                window.MeGraph.renderGraphMulti(latexEqs).then(function (dataUrl) {
                    // Insert the graph image into the document
                    var editor = window.MeEditor;
                    if (editor) {
                        editor.commands.setImage({
                            src: dataUrl,
                            alt: 'Graph of ' + labels,
                            title: labels
                        });
                    }
                }).catch(function (err) {
                    showToast('Could not plot: ' + (err.message || err), 3000);
                });
            });
            actions.appendChild(btnPlot);
        }

        pop.appendChild(actions);
        document.body.appendChild(pop);
        resultPopover = pop;

        // Position near the math field
        requestAnimationFrame(function () {
            var mfRect = mf.getBoundingClientRect();
            var popRect = pop.getBoundingClientRect();
            var top = mfRect.bottom + 6;
            var left = mfRect.left + (mfRect.width - popRect.width) / 2;
            // Keep on screen
            if (left < 8) left = 8;
            if (left + popRect.width > window.innerWidth - 8) left = window.innerWidth - popRect.width - 8;
            if (top + popRect.height > window.innerHeight - 8) top = mfRect.top - popRect.height - 6;
            pop.style.top = top + 'px';
            pop.style.left = left + 'px';
            pop.style.opacity = '1';
        });

        // Dismiss on click outside
        setTimeout(function () {
            document.addEventListener('click', function dismiss(e) {
                if (pop.contains(e.target)) return;
                removeResultPopover();
                document.removeEventListener('click', dismiss);
            });
        }, 100);

        // Dismiss on Escape
        document.addEventListener('keydown', function escDismiss(e) {
            if (e.key === 'Escape') {
                removeResultPopover();
                document.removeEventListener('keydown', escDismiss);
            }
        });
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
        // Show/hide ODE/PDE buttons based on current expression
        updateConditionalActions(readLatex(mf));
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

        // --- ODE/PDE Solve (only if detected) ---
        var deType = detectDEType(latex);
        if (deType) {
            items.push({ type: 'divider' });
            if (deType === 'ode') {
                items.push({
                    label: '\uD83D\uDD27 Solve ODE',
                    onMenuSelect: function () { performDESolve('solveODE', mf); }
                });
            } else {
                items.push({
                    label: '\uD83D\uDD27 Solve PDE',
                    onMenuSelect: function () { performDESolve('solvePDE', mf); }
                });
            }
        }

        // --- Limit / Series / Laplace / System (only if detected) ---
        if (isLimitLatex(latex)) {
            items.push({ type: 'divider' });
            items.push({
                label: 'lim  Evaluate Limit',
                onMenuSelect: function () { performSpecialAction('limit', mf); }
            });
        }
        if (isSeriesLatex(latex)) {
            items.push({ type: 'divider' });
            items.push({
                label: '\u03A3  Evaluate Sum / Series',
                onMenuSelect: function () { performSpecialAction('taylor', mf); }
            });
        }
        if (isLaplaceLatex(latex)) {
            items.push({ type: 'divider' });
            items.push({
                label: '\u2112  Laplace Transform',
                onMenuSelect: function () { performSpecialAction('laplace', mf); }
            });
        }
        if (isSystemLatex(latex)) {
            items.push({ type: 'divider' });
            items.push({
                label: '{=}  Solve System',
                onMenuSelect: function () { performSpecialAction('solveSys', mf); }
            });
        }

        // --- Matrix Operations (only if matrix detected) ---
        if (isMatrixLatex(latex)) {
            items.push({ type: 'divider' });
            items.push({
                label: '|A| Determinant',
                onMenuSelect: function () { performMatrixAction('matDet', mf); }
            });
            items.push({
                label: 'A\u207B\u00B9 Inverse',
                onMenuSelect: function () { performMatrixAction('matInv', mf); }
            });
            items.push({
                label: 'A\u1D40 Transpose',
                onMenuSelect: function () { performMatrixAction('matTrans', mf); }
            });
            items.push({
                label: '\u03BB Eigenvalues',
                onMenuSelect: function () { performMatrixAction('matEig', mf); }
            });
            items.push({
                label: 'RREF (Row Echelon)',
                onMenuSelect: function () { performMatrixAction('matRREF', mf); }
            });
            items.push({
                label: 'Rank',
                onMenuSelect: function () { performMatrixAction('matRank', mf); }
            });
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

        // --- SMILES / Molecule (only if text looks like SMILES) ---
        if (isSmilesLike(latex)) {
            items.push({ type: 'divider' });
            (function (smiles) {
                items.push({
                    label: '\uD83D\uDD2C Insert Molecule Image',
                    onMenuSelect: function () {
                        var editor = window.MeEditor;
                        if (!editor) return;
                        showToast('Loading molecule...', 2000);
                        getOCL().then(function (OCL) {
                            try {
                                var mol = OCL.Molecule.fromSmiles(smiles);
                                var svg = mol.toSVG(400, 300, null, { autoCrop: true });
                                var formula = mol.getMolecularFormula();
                                var dataUrl = 'data:image/svg+xml;base64,' + btoa(svg);
                                editor.chain().focus('end').insertContent({
                                    type: 'image',
                                    attrs: { src: dataUrl, alt: formula.formula + ' \u2014 ' + formula.absoluteWeight.toFixed(2) + ' g/mol', title: smiles, width: 300 }
                                }).run();
                                showToast('Molecule inserted', 2000);
                            } catch (err) {
                                showToast('Invalid SMILES: ' + (err.message || err), 3000);
                            }
                        }).catch(function (err) {
                            showToast('Failed to load OpenChemLib: ' + (err.message || err), 3000);
                        });
                    }
                });
                items.push({
                    label: '\uD83D\uDD2C Open in Molecule Editor',
                    onMenuSelect: function () {
                        var ctx = window.ME_CTX || '';
                        window.open(ctx + '/chemistry/molecule-draw.jsp?smiles=' + encodeURIComponent(smiles) + '&returnTo=editor', '_blank', 'width=1200,height=800');
                    }
                });
            })(latex);
        }

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
