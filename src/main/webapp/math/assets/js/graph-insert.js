/**
 * graph-insert.js — Insert plotted graphs from math equations
 * Lazy-loads Plotly.js + math.js + graphing engine on first use.
 * Renders to off-screen div, exports as PNG, inserts into TipTap editor.
 *
 * Supports:
 *   - Single equation plot  (right-click → Plot Graph)
 *   - Multi-equation plot   (right-click → Plot All Equations)
 *   - Auto type detection   (cartesian, implicit, polar, parametric)
 */
(function () {
    'use strict';

    var loading = null;
    var COLORS = ['#3B82F6', '#EF4444', '#10B981', '#F59E0B', '#8B5CF6',
                  '#06B6D4', '#EC4899', '#F97316', '#14B8A6', '#6366F1'];

    var PLOTLY_CDN = 'https://cdn.plot.ly/plotly-basic-2.35.2.min.js';
    var MATHJS_CDN = 'https://cdn.jsdelivr.net/npm/mathjs@13.2.0/lib/browser/math.min.js';

    function loadScript(url) {
        return new Promise(function (resolve, reject) {
            if (document.querySelector('script[src="' + url + '"]')) { resolve(); return; }
            var s = document.createElement('script');
            s.src = url;
            s.onload = resolve;
            s.onerror = function () { reject(new Error('Failed: ' + url)); };
            document.head.appendChild(s);
        });
    }

    /** Load Plotly + math.js + graphing engine (once). */
    function ensureDeps() {
        if (loading) return loading;
        var steps = [];

        if (!window.math) {
            steps.push(loadScript(MATHJS_CDN));
        }
        if (!window.Plotly) {
            steps.push(loadScript(PLOTLY_CDN));
        }

        loading = Promise.all(steps).then(function () {
            if (!window.GraphingEngine) {
                window._gcSkipBoot = true;
                var ctx = window.ME_CTX || '';
                return loadScript(ctx + '/js/graphing-tool-engine.js');
            }
        });
        return loading;
    }

    // =========================================================
    //  LaTeX → math.js conversion
    // =========================================================
    function convertLatex(latex) {
        if (!latex) return '';
        if (window.latexToMathJS) return window.latexToMathJS(latex);
        return basicLatexToMathJS(latex);
    }

    function basicLatexToMathJS(latex) {
        if (!latex) return '';
        var s = latex;

        // Fix 1: \sin^{n}(x) → sin(x)^n (trig powers — do BEFORE stripping LaTeX)
        s = s.replace(/\\(sin|cos|tan|sec|csc|cot|sinh|cosh|tanh)\^\{([^}]+)\}\s*(\([^)]+\))/g, '$1$3^($2)');
        s = s.replace(/\\(sin|cos|tan|sec|csc|cot|sinh|cosh|tanh)\^(\d)\s*(\([^)]+\))/g, '$1$3^$2');

        for (var i = 0; i < 5; i++) {
            var prev = s;
            s = s.replace(/\\frac\{([^{}]*)\}\{([^{}]*)\}/g, '(($1)/($2))');
            if (s === prev) break;
        }
        s = s.replace(/\\sqrt\{([^{}]*)\}/g, 'sqrt($1)');
        s = s.replace(/\^\{([^{}]*)\}/g, '^($1)');
        s = s.replace(/_\{[^{}]*\}/g, '');
        s = s.replace(/\\left\|([^|]*?)\\right\|/g, 'abs($1)');
        s = s.replace(/\\left\s*([(\[{])/g, '$1');
        s = s.replace(/\\right\s*([)\]}])/g, '$1');
        s = s.replace(/\\cdot/g, '*').replace(/\\times/g, '*');

        // Fix 2: arcsin/arccos/arctan → asin/acos/atan (math.js names)
        s = s.replace(/\\arcsin/g, 'asin').replace(/\\arccos/g, 'acos').replace(/\\arctan/g, 'atan');
        s = s.replace(/\barcsin\b/g, 'asin').replace(/\barccos\b/g, 'acos').replace(/\barctan\b/g, 'atan');

        // Fix 3: \ln → log (math.js uses log for natural log)
        s = s.replace(/\\ln\b/g, 'log');
        s = s.replace(/\bln\b/g, 'log');

        s = s.replace(/\\(sin|cos|tan|sec|csc|cot|asin|acos|atan|log|exp|abs|sinh|cosh|tanh)\b/g, '$1');
        s = s.replace(/\\pi/g, 'pi').replace(/\\infty/g, 'Infinity');
        s = s.replace(/\\(alpha|beta|gamma|delta|theta|phi|omega|lambda|mu|sigma|tau|epsilon|rho)\b/g, '$1');
        s = s.replace(/\\[a-zA-Z]+/g, '');
        s = s.replace(/\{/g, '(').replace(/\}/g, ')');
        s = s.replace(/\\[,;!]/g, '').replace(/\\ /g, ' ');
        s = s.replace(/\s+/g, ' ').trim();

        // Fix 4: Implicit multiplication — improved to catch xsin, xcos, etc.
        s = s.replace(/(\d)\s*(sin|cos|tan|asin|acos|atan|sinh|cosh|tanh|sec|csc|cot|log|exp|sqrt|abs|ceil|floor|sign|round)\s*\(/gi, '$1*$2(');
        s = s.replace(/([a-zA-Z])\s*(sin|cos|tan|asin|acos|atan|sinh|cosh|tanh|sec|csc|cot|log|exp|sqrt|abs)\s*\(/gi, function(m, letter, fn) {
            var combined = (letter + fn).toLowerCase();
            // Preserve compound function names
            if (['asin','acos','atan','sinh','cosh','tanh','asec','acsc','acot'].includes(combined)) return m;
            return letter + '*' + fn + '(';
        });
        s = s.replace(/(\d)([a-zA-Z])/g, '$1*$2');
        s = s.replace(/\)\s*\(/g, ')*(');
        s = s.replace(/\)\s*(\w)/g, ')*$1');
        return s;
    }

    // =========================================================
    //  Detect expression type from LaTeX
    // =========================================================
    function detectType(latex) {
        if (/[^<>!]=/.test(latex) && /[xy]/.test(latex)) {
            var sides = latex.split(/(?<![<>!])=(?!=)/);
            if (sides.length === 2) {
                var lhs = sides[0].replace(/\\[a-zA-Z]+/g, '').replace(/[{}\s]/g, '').trim();
                var hasX = /x/.test(latex), hasY = /y/.test(latex);
                // If LHS is just "y" or "f(x)" or "g(x)", it's cartesian y = f(x), not implicit
                if (/^y$/.test(lhs) || /^[a-zA-Z]\([a-zA-Z]\)$/.test(lhs)) return 'cartesian';
                if (hasX && hasY) return 'implicit';
            }
        }
        if (/\\?[a-z]+\(t\)/.test(latex) || /,\s*\\?[a-z]+\(t\)/.test(latex)) return 'parametric';
        if (/\\theta|θ/.test(latex)) return 'polar';
        return 'cartesian';
    }

    // =========================================================
    //  Collect all math-field LaTeX from the TipTap document
    // =========================================================
    function collectAllEquations() {
        var editor = window.MeEditor;
        if (!editor) return [];
        var equations = [];
        editor.state.doc.descendants(function (node) {
            if (node.type.name === 'mathBlock' || node.type.name === 'mathInline') {
                var latex = node.attrs.latex;
                if (latex && latex.trim()) {
                    equations.push(latex.trim());
                }
            }
        });
        return equations;
    }

    /** Filter equations that are plottable (contain x, y, t, or theta). */
    function filterPlottable(equations) {
        return equations.filter(function (latex) {
            // Must contain a variable (x, y, t, theta) — skip pure constants like "e = 2.718"
            return /[xyt]/.test(latex) || /\\theta/.test(latex);
        });
    }

    // =========================================================
    //  RENDER GRAPH (multi-equation)
    //  Accepts array of LaTeX strings.
    //  Returns Promise<string> (PNG data URL)
    // =========================================================
    function renderGraphMulti(latexArray) {
        if (!latexArray || latexArray.length === 0) return Promise.reject('No equations');

        return ensureDeps().then(function () {
            // Convert all LaTeX → math.js text
            var exprs = [];
            for (var i = 0; i < latexArray.length; i++) {
                var mathExpr = convertLatex(latexArray[i]);
                if (mathExpr) {
                    exprs.push({
                        text: mathExpr,
                        type: detectType(latexArray[i]),
                        latex: latexArray[i],
                        color: COLORS[i % COLORS.length]
                    });
                }
            }
            if (exprs.length === 0) return Promise.reject('No valid expressions');

            // Create off-screen container
            var container = document.createElement('div');
            container.id = 'me-graph-offscreen-' + Date.now();
            container.style.cssText = 'position:absolute;left:-9999px;top:-9999px;width:600px;height:400px;';
            document.body.appendChild(container);

            var cleanup = function () {
                try { window.Plotly.purge(container); } catch (_) {}
                container.remove();
            };

            try {
                if (window.GraphingEngine) {
                    var engine = new window.GraphingEngine(container.id);
                    for (var j = 0; j < exprs.length; j++) {
                        engine.addExpression(exprs[j].text, exprs[j].type, exprs[j].color);
                    }
                    engine.plot({ xMin: -10, xMax: 10, yMin: -10, yMax: 10, _forceRange: true });
                } else {
                    // Fallback: build traces manually
                    var traces = [];
                    for (var k = 0; k < exprs.length; k++) {
                        var trace = generateSimpleTrace(exprs[k].text, exprs[k].type, exprs[k].color);
                        if (trace) traces.push(trace);
                    }
                    if (traces.length === 0) { cleanup(); return Promise.reject('Cannot plot'); }
                    window.Plotly.newPlot(container, traces, {
                        xaxis: { range: [-10, 10], title: 'x', gridcolor: '#E2E8F0' },
                        yaxis: { range: [-10, 10], title: 'y', gridcolor: '#E2E8F0', scaleanchor: 'x' },
                        margin: { l: 50, r: 30, t: 30, b: 50 },
                        paper_bgcolor: '#FFFFFF',
                        plot_bgcolor: '#FAFBFC',
                        font: { family: 'system-ui, sans-serif', size: 12 },
                        showlegend: exprs.length > 1
                    }, { staticPlot: true });
                }

                return window.Plotly.toImage(container, {
                    format: 'png', width: 600, height: 400, scale: 2
                }).then(function (dataUrl) {
                    cleanup();
                    return dataUrl;
                });
            } catch (err) {
                cleanup();
                return Promise.reject(err);
            }
        });
    }

    /** Single-equation convenience wrapper. */
    function renderGraph(latex) {
        return renderGraphMulti([latex]);
    }

    /** Generate a simple Plotly trace (fallback when engine not loaded). */
    function generateSimpleTrace(expr, type, color) {
        if (!window.math) return null;
        color = color || '#3B82F6';
        var xs = [], ys = [];
        var numPoints = 500;

        if (type === 'cartesian') {
            expr = expr.replace(/^\s*[yf]\s*(?:\([^)]*\))?\s*=\s*/, '');
            var compiled;
            try { compiled = window.math.compile(expr); } catch (_) { return null; }
            for (var i = 0; i <= numPoints; i++) {
                var x = -10 + (20 * i / numPoints);
                try {
                    var y = compiled.evaluate({ x: x, e: Math.E, pi: Math.PI });
                    xs.push(x);
                    ys.push(typeof y === 'number' && isFinite(y) ? y : null);
                } catch (_) { xs.push(x); ys.push(null); }
            }
            return { x: xs, y: ys, type: 'scatter', mode: 'lines',
                     line: { color: color, width: 2.5 }, name: expr };
        }

        if (type === 'polar') {
            expr = expr.replace(/theta/g, 't');
            var cPolar;
            try { cPolar = window.math.compile(expr); } catch (_) { return null; }
            for (var j = 0; j <= numPoints; j++) {
                var theta = 2 * Math.PI * j / numPoints;
                try {
                    var r = cPolar.evaluate({ t: theta, theta: theta, e: Math.E, pi: Math.PI });
                    if (typeof r === 'number' && isFinite(r)) {
                        xs.push(r * Math.cos(theta));
                        ys.push(r * Math.sin(theta));
                    } else { xs.push(null); ys.push(null); }
                } catch (_) { xs.push(null); ys.push(null); }
            }
            return { x: xs, y: ys, type: 'scatter', mode: 'lines',
                     line: { color: color, width: 2.5 }, name: expr };
        }

        if (type === 'implicit') {
            var parts = expr.split('=');
            if (parts.length !== 2) return null;
            var implExpr = '(' + parts[0].trim() + ') - (' + parts[1].trim() + ')';
            var cImpl;
            try { cImpl = window.math.compile(implExpr); } catch (_) { return null; }
            var res = 200;
            var xArr = [], yArr = [], zArr = [];
            for (var iy = 0; iy < res; iy++) {
                var yv = -10 + (20 * iy / (res - 1));
                yArr.push(yv);
                zArr.push([]);
                for (var ix = 0; ix < res; ix++) {
                    var xv = -10 + (20 * ix / (res - 1));
                    if (iy === 0) xArr.push(xv);
                    try {
                        var zv = cImpl.evaluate({ x: xv, y: yv, e: Math.E, pi: Math.PI });
                        zArr[iy].push(typeof zv === 'number' ? zv : 0);
                    } catch (_) { zArr[iy].push(0); }
                }
            }
            return {
                x: xArr, y: yArr, z: zArr, type: 'contour',
                contours: { start: 0, end: 0, size: 0.01, coloring: 'none' },
                line: { color: color, width: 2.5 },
                showscale: false, name: expr
            };
        }

        return null;
    }

    // =========================================================
    //  INSERT GRAPH INTO TIPTAP EDITOR
    // =========================================================

    /** Insert a graph image into the editor at the current position. */
    function insertGraphImage(dataUrl, alt) {
        var editor = window.MeEditor;
        if (!editor || !dataUrl) return;

        var sel = editor.state.selection;
        var insertPos = sel.node ? sel.from + sel.node.nodeSize : sel.to;

        try {
            editor.chain()
                .setTextSelection(insertPos)
                .setImage({ src: dataUrl, alt: alt || 'Graph' })
                .focus().run();
        } catch (_) {
            try {
                editor.chain().focus()
                    .insertContent({ type: 'image', attrs: { src: dataUrl, alt: alt || 'Graph' } })
                    .run();
            } catch (_2) {}
        }
    }

    /** Show a toast via MeCompute if available, otherwise create one inline. */
    function graphToast(message, duration) {
        if (window.MeCompute && window.MeCompute.showToast) {
            window.MeCompute.showToast(message, duration);
        } else {
            // Standalone fallback toast
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
            }, duration || 3000);
        }
    }

    /** Show a loading spinner overlay on a math node. */
    function showGraphLoading(mathNode) {
        if (!mathNode) return;
        mathNode.classList.add('me-graph-loading');
        if (window.MeCompute && window.MeCompute.showNodeLoading) {
            window.MeCompute.showNodeLoading(mathNode);
        } else {
            // Standalone fallback spinner
            var overlay = document.createElement('div');
            overlay.className = 'me-compute-loading-overlay';
            overlay.innerHTML = '<div class="me-graph-spinner-text">Plotting\u2026</div>';
            overlay.style.cssText = 'position:absolute;inset:0;display:flex;align-items:center;' +
                'justify-content:center;background:rgba(255,255,255,.6);border-radius:8px;z-index:10;' +
                'pointer-events:none;';
            overlay.firstChild.style.cssText = 'font-size:13px;color:#3B82F6;font-weight:500;';
            var pos = window.getComputedStyle(mathNode).position;
            if (pos === 'static') mathNode.style.position = 'relative';
            mathNode.appendChild(overlay);
        }
    }

    /** Remove loading spinner overlay from a math node. */
    function hideGraphLoading(mathNode) {
        if (!mathNode) return;
        mathNode.classList.remove('me-graph-loading');
        if (window.MeCompute && window.MeCompute.hideNodeLoading) {
            window.MeCompute.hideNodeLoading(mathNode);
        } else {
            var overlay = mathNode.querySelector('.me-compute-loading-overlay');
            if (overlay) overlay.remove();
        }
    }

    /** Format an error into a user-readable string. */
    function formatGraphError(err) {
        if (!err) return 'Unknown error';
        if (typeof err === 'string') return err;
        if (err.message) return err.message;
        return String(err);
    }

    /** Plot a single equation (from right-click → Plot Graph or action bar).
     *  Also handles system of equations (\begin{cases}...) by splitting
     *  into y=f(x) forms via nerdamer and plotting all curves together. */
    function insertGraphForLatex(latex, mf) {
        var mathNode = mf ? mf.closest('.me-math-node') : null;

        // System of equations: split, solve each for y, plot all
        if (/\\begin\{(cases|aligned)\}/.test(latex)) {
            var nm = window.nerdamer;
            if (!nm) { graphToast('Nerdamer not loaded', 2000); return; }

            var body = latex.match(/\\begin\{(?:cases|aligned)\}([\s\S]*?)\\end\{(?:cases|aligned)\}/);
            if (!body) { graphToast('Could not parse system', 2000); return; }

            var eqs = body[1].split(/\\\\/).map(function (l) {
                return l.replace(/&/g, '').replace(/\\text\{.*?\}/g, '').trim();
            }).filter(Boolean);

            // Convert LaTeX equation to nerdamer text, handling = properly.
            // convertFromLaTeX treats = as assignment (drops LHS), so we split first.
            function eqLatexToNerdamer(eqLatex) {
                var parts = eqLatex.split('=');
                if (parts.length === 2) {
                    var lhs = nm.convertFromLaTeX(parts[0].trim().replace(/\\ln\b/g, '\\log')).toString();
                    var rhs = nm.convertFromLaTeX(parts[1].trim().replace(/\\ln\b/g, '\\log')).toString();
                    return lhs + '=(' + rhs + ')';
                }
                return nm.convertFromLaTeX(eqLatex.replace(/\\ln\b/g, '\\log')).toString();
            }

            var plotEqs = [];
            eqs.forEach(function (eq) {
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
                    // Fallback: use as implicit equation
                    try {
                        plotEqs.push(eqLatexToNerdamer(eq).replace(/\*\*/g, '^'));
                    } catch (_) {}
                }
            });

            if (plotEqs.length === 0) { graphToast('Could not extract plottable equations from system', 3000); return; }

            showGraphLoading(mathNode);
            renderGraphMulti(plotEqs).then(function (dataUrl) {
                hideGraphLoading(mathNode);
                insertGraphImage(dataUrl, 'System: ' + plotEqs.join(', ').substring(0, 100));
            }).catch(function (err) {
                hideGraphLoading(mathNode);
                graphToast('Could not plot system: ' + formatGraphError(err), 4000);
            });
            return;
        }

        // Single equation: plot normally
        showGraphLoading(mathNode);
        renderGraph(latex).then(function (dataUrl) {
            hideGraphLoading(mathNode);
            insertGraphImage(dataUrl, 'Graph of ' + latex.substring(0, 100));
        }).catch(function (err) {
            hideGraphLoading(mathNode);
            var msg = formatGraphError(err);
            console.warn('Graph render failed:', err);
            graphToast('Could not plot: ' + msg, 4000);
        });
    }

    // =========================================================
    //  EQUATION PICKER DIALOG
    //  Shows all equations with checkboxes + color dots + live
    //  LaTeX preview. User picks which to plot.
    // =========================================================
    var pickerOverlay = null;

    function showEquationPicker(mf) {
        var currentLatex = mf ? (mf.getValue ? mf.getValue() : mf.value) || '' : '';
        var all = collectAllEquations();
        var plottable = filterPlottable(all);

        if (plottable.length === 0) {
            graphToast('No plottable equations found in the document', 3000);
            return;
        }

        // Build overlay
        if (pickerOverlay) pickerOverlay.remove();
        pickerOverlay = document.createElement('div');
        pickerOverlay.className = 'me-graph-picker-overlay';

        var dialog = document.createElement('div');
        dialog.className = 'me-graph-picker';

        // Header
        var header = document.createElement('div');
        header.className = 'me-graph-picker-header';
        header.innerHTML = '<span class="me-graph-picker-title">Select Equations to Plot</span>' +
            '<button class="me-graph-picker-close" title="Close">\u2715</button>';
        dialog.appendChild(header);

        // Equation list
        var list = document.createElement('div');
        list.className = 'me-graph-picker-list';

        for (var i = 0; i < plottable.length; i++) {
            (function (idx, latex) {
                var color = COLORS[idx % COLORS.length];
                var isCurrentEq = (latex === currentLatex);

                var row = document.createElement('label');
                row.className = 'me-graph-picker-row';
                if (isCurrentEq) row.classList.add('me-graph-picker-current');

                var cb = document.createElement('input');
                cb.type = 'checkbox';
                cb.checked = isCurrentEq;
                cb.className = 'me-graph-picker-cb';
                cb.dataset.idx = idx;
                row.appendChild(cb);

                var dot = document.createElement('span');
                dot.className = 'me-graph-picker-dot';
                dot.style.background = color;
                row.appendChild(dot);

                // Render equation with a read-only math-field for nice display
                var eqDisplay = document.createElement('math-field');
                eqDisplay.setAttribute('read-only', '');
                eqDisplay.className = 'me-graph-picker-eq';
                eqDisplay.value = latex;
                row.appendChild(eqDisplay);

                list.appendChild(row);
            })(i, plottable[i]);
        }
        dialog.appendChild(list);

        // Footer with actions
        var footer = document.createElement('div');
        footer.className = 'me-graph-picker-footer';

        var selectAllBtn = document.createElement('button');
        selectAllBtn.className = 'me-graph-picker-btn me-graph-picker-btn-secondary';
        selectAllBtn.textContent = 'Select All';
        selectAllBtn.addEventListener('click', function () {
            var cbs = list.querySelectorAll('.me-graph-picker-cb');
            for (var c = 0; c < cbs.length; c++) cbs[c].checked = true;
        });
        footer.appendChild(selectAllBtn);

        var clearBtn = document.createElement('button');
        clearBtn.className = 'me-graph-picker-btn me-graph-picker-btn-secondary';
        clearBtn.textContent = 'Clear';
        clearBtn.addEventListener('click', function () {
            var cbs = list.querySelectorAll('.me-graph-picker-cb');
            for (var c = 0; c < cbs.length; c++) cbs[c].checked = false;
        });
        footer.appendChild(clearBtn);

        var spacer = document.createElement('span');
        spacer.style.flex = '1';
        footer.appendChild(spacer);

        var plotBtn = document.createElement('button');
        plotBtn.className = 'me-graph-picker-btn me-graph-picker-btn-primary';
        plotBtn.textContent = 'Plot Selected';
        plotBtn.addEventListener('click', function () {
            var selected = [];
            var cbs = list.querySelectorAll('.me-graph-picker-cb');
            for (var c = 0; c < cbs.length; c++) {
                if (cbs[c].checked) {
                    selected.push(plottable[parseInt(cbs[c].dataset.idx)]);
                }
            }
            closePicker();
            if (selected.length === 0) return;

            var mathNode = mf ? mf.closest('.me-math-node') : null;
            showGraphLoading(mathNode);

            renderGraphMulti(selected).then(function (dataUrl) {
                hideGraphLoading(mathNode);
                var labels = selected.map(function (l) { return l.substring(0, 30); }).join(', ');
                insertGraphImage(dataUrl, 'Graph of ' + labels);
            }).catch(function (err) {
                hideGraphLoading(mathNode);
                var msg = formatGraphError(err);
                console.warn('Multi-graph render failed:', err);
                graphToast('Could not plot: ' + msg, 4000);
            });
        });
        footer.appendChild(plotBtn);
        dialog.appendChild(footer);

        pickerOverlay.appendChild(dialog);
        document.body.appendChild(pickerOverlay);

        // Close handlers
        header.querySelector('.me-graph-picker-close').addEventListener('click', closePicker);
        pickerOverlay.addEventListener('click', function (e) {
            if (e.target === pickerOverlay) closePicker();
        });
        document.addEventListener('keydown', pickerEscHandler);
    }

    function closePicker() {
        if (pickerOverlay) {
            pickerOverlay.remove();
            pickerOverlay = null;
        }
        document.removeEventListener('keydown', pickerEscHandler);
    }

    function pickerEscHandler(e) {
        if (e.key === 'Escape') closePicker();
    }

    // =========================================================
    //  EXPOSE API
    // =========================================================
    window.MeGraph = {
        insertGraph:        insertGraphForLatex,
        showEquationPicker: showEquationPicker,
        renderGraph:        renderGraph,
        renderGraphMulti:   renderGraphMulti,
        collectAll:         collectAllEquations,
        ensureDeps:         ensureDeps
    };

})();
