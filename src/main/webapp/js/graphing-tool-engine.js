/**
 * Advanced Graphing Tool Engine
 * Reusable JavaScript library using Math.js and Plotly.js
 */

class GraphingEngine {
    constructor(containerId) {
        this.containerId = containerId;
        this.expressions = [];
        this.nextId = 1;
        this.colors = [
            '#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd',
            '#8c564b', '#e377c2', '#7f7f7f', '#bcbd22', '#17becf'
        ];
        this.colorIndex = 0;
        this._sympyPending = 0; // track in-flight SymPy requests
    }

    // ==================== SymPy Fallback Helpers ====================

    /** Convert math expression to Python/SymPy syntax */
    static _toPython(s) {
        if (!s) return '';
        s = s.trim();
        s = s.replace(/\^/g, '**');
        s = s.replace(/(\d)([a-zA-Z])/g, '$1*$2');
        s = s.replace(/\)\s*\(/g, ')*(');
        s = s.replace(/\)\s*([a-zA-Z\d])/g, ')*$1');
        return s;
    }

    /** Execute Python code via OneCompilerFunctionality and return stdout */
    _sympyExec(code) {
        const ctx = (document.querySelector('meta[name="context-path"]') || {}).content || '';
        const controller = new AbortController();
        const timeoutId = setTimeout(() => controller.abort(), 30000);
        return fetch(ctx + '/OneCompilerFunctionality?action=execute', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ language: 'python', version: '3.10', code }),
            signal: controller.signal
        })
        .then(r => r.json())
        .then(data => {
            clearTimeout(timeoutId);
            return (data.Stdout || data.stdout || '').trim();
        })
        .catch(err => {
            clearTimeout(timeoutId);
            console.error('SymPy exec failed:', err);
            return '';
        });
    }

    /** Show/hide SymPy computing indicator */
    _showSympyIndicator(msg) {
        let el = document.getElementById('gc-sympy-indicator');
        if (!el) {
            el = document.createElement('div');
            el.id = 'gc-sympy-indicator';
            el.style.cssText = 'position:absolute;top:12px;left:50%;transform:translateX(-50%);z-index:100;' +
                'background:rgba(99,102,241,0.95);color:#fff;padding:6px 16px;border-radius:20px;font-size:13px;' +
                'font-weight:500;pointer-events:none;transition:opacity 0.3s;box-shadow:0 2px 8px rgba(0,0,0,0.2);';
            const graphDiv = document.getElementById(this.containerId);
            if (graphDiv && graphDiv.parentElement) {
                graphDiv.parentElement.style.position = 'relative';
                graphDiv.parentElement.appendChild(el);
            }
        }
        el.textContent = msg || 'Solving...';
        el.style.opacity = '1';
    }

    _hideSympyIndicator() {
        const el = document.getElementById('gc-sympy-indicator');
        if (el) {
            el.style.opacity = '0';
            setTimeout(() => el.remove(), 300);
        }
    }

    /**
     * Add a new expression to plot
     */
    addExpression(expression, type = 'cartesian', color = null) {
        const expr = {
            id: this.nextId++,
            expression: expression,
            type: type,
            color: color || this.colors[this.colorIndex++ % this.colors.length],
            visible: true,
            data: null
        };

        this.expressions.push(expr);
        return expr;
    }

    /**
     * Update an existing expression
     */
    updateExpression(id, updates) {
        const expr = this.expressions.find(e => e.id === id);
        if (expr) {
            Object.assign(expr, updates);
        }
    }

    /**
     * Remove an expression
     */
    removeExpression(id) {
        this.expressions = this.expressions.filter(e => e.id !== id);
    }

    /**
     * Normalize common user-input patterns into valid math.js syntax.
     *  - ** → ^ (Python-style exponent)
     *  - ln( → log( (natural log alias)
     *  - Strip leading "y =" / "y=" from Cartesian input
     */
    normalizeExpression(expr) {
        if (!expr || typeof expr !== 'string') return expr;
        let s = expr.trim();
        // Unicode math symbols → ASCII equivalents
        s = s.replace(/π/g, 'pi');
        s = s.replace(/√\s*/g, 'sqrt');
        s = s.replace(/²/g, '^2');
        s = s.replace(/³/g, '^3');
        s = s.replace(/⁴/g, '^4');
        s = s.replace(/θ/g, 'theta');
        // |x| absolute value bars → abs(x)
        s = s.replace(/\|([^|]+)\|/g, 'abs($1)');
        // Python-style exponent
        s = s.replace(/\*\*/g, '^');
        // e^(...) → exp(...) when 'e' is Euler's number (not part of a word)
        s = s.replace(/(?<![a-zA-Z])e\^(\()/g, 'exp$1');
        s = s.replace(/(?<![a-zA-Z])e\^([a-zA-Z0-9])/g, 'exp($1)');
        // ln → log  (math.js log is natural log)
        s = s.replace(/\bln\s*\(/g, 'log(');
        // arcsin/arccos/arctan → asin/acos/atan
        s = s.replace(/\barcsin\s*\(/gi, 'asin(');
        s = s.replace(/\barccos\s*\(/gi, 'acos(');
        s = s.replace(/\barctan\s*\(/gi, 'atan(');
        // log10(x) → log(x)/log(10)
        s = s.replace(/\blog10\s*\(([^)]+)\)/gi, '(log($1)/log(10))');
        // digit × opening paren: 2(x+1) → 2*(x+1)
        s = s.replace(/(\d)\s*\(/g, '$1*(');
        // closing paren × opening paren: )(  → )*(
        s = s.replace(/\)\s*\(/g, ')*(');
        // closing paren × digit or letter: )2 → )*2, )x → )*x
        s = s.replace(/\)\s*(\w)/g, ')*$1');
        // digit × known function name: 2sin(x) → 2*sin(x), 3cos(x) → 3*cos(x)
        s = s.replace(/(\d)\s*(sin|cos|tan|asin|acos|atan|sinh|cosh|tanh|sec|csc|cot|log|exp|sqrt|abs|ceil|floor|sign|round)\s*\(/gi,
            '$1*$2(');
        // negative coefficient × letter: -2x → -2*x (handles leading minus)
        s = s.replace(/(^|[+\-*/^(,])\s*(-?\d+\.?\d*)([a-zA-Z])/g, (m, pre, num, letter) => {
            if (/[a-zA-Z]/.test(pre)) return m; // Don't break function names
            return pre + num + '*' + letter;
        });
        // digit × single letter (not part of function): 2x → 2*x, 3y → 3*y
        s = s.replace(/(\d)([a-zA-Z])/g, '$1*$2');
        // Implicit multiplication between adjacent single-letter variables:
        //   xy → x*y,  but not "sin", "cos", "pi", etc.
        s = s.replace(/(?<![a-zA-Z])([a-zA-Z])([a-zA-Z])(?![a-zA-Z(])/g, (m, a, b) => {
            if ((a + b).toLowerCase() === 'pi') return m;
            return a + '*' + b;
        });
        // Function juxtaposition: sin(x)cos(x) → sin(x)*cos(x)
        s = s.replace(/\)\s*(sin|cos|tan|asin|acos|atan|sinh|cosh|tanh|sec|csc|cot|log|exp|sqrt|abs)\s*\(/gi, ')*$1(');
        return s;
    }

    /**
     * Strip "y = " prefix that users often type for Cartesian input.
     */
    stripCartesianPrefix(expr) {
        if (!expr || typeof expr !== 'string') return expr;
        // Strip "y = ", "f(x) = ", "g(x) = " prefixes
        return expr.replace(/^\s*(?:y|f\s*\(\s*x\s*\)|g\s*\(\s*x\s*\))\s*=\s*/i, '');
    }

    /**
     * Generate data for Cartesian plot (y = f(x))
     */
    generateCartesian(expression, xMin = -10, xMax = 10, numPoints = 500) {
        try {
            // Validate expression
            if (!expression || typeof expression !== 'string' || expression.trim() === '') {
                return null;
            }

            let expr = this.normalizeExpression(expression);
            expr = this.stripCartesianPrefix(expr);

            const x = [];
            const y = [];
            const step = (xMax - xMin) / numPoints;

            // Compile expression once
            const compiledExpr = math.compile(expr);

            for (let i = 0; i <= numPoints; i++) {
                const xVal = xMin + i * step;

                try {
                    const yVal = compiledExpr.evaluate({ x: xVal });
                    if (typeof yVal === 'number' && isFinite(yVal)) {
                        x.push(xVal);
                        y.push(yVal);
                    } else {
                        x.push(xVal);
                        y.push(null);
                    }
                } catch (e) {
                    x.push(xVal);
                    y.push(null);
                }
            }

            // Asymptote detection: large jumps with sign change → insert null gap
            const asymptotes = [];
            const yValid = y.filter(v => v !== null && isFinite(v));
            let yRangeMax = -Infinity, yRangeMin = Infinity;
            for (let i = 0; i < yValid.length; i++) {
                if (yValid[i] > yRangeMax) yRangeMax = yValid[i];
                if (yValid[i] < yRangeMin) yRangeMin = yValid[i];
            }
            const yRange = (yValid.length > 0 ? yRangeMax - yRangeMin : 0) || 20;
            const jumpThreshold = yRange * 0.5;
            for (let i = 1; i < y.length; i++) {
                if (y[i] !== null && y[i-1] !== null) {
                    const dy = Math.abs(y[i] - y[i-1]);
                    // Large jump with sign change = likely asymptote
                    if (dy > jumpThreshold && y[i] * y[i-1] < 0) {
                        asymptotes.push((x[i] + x[i-1]) / 2);
                        y[i-1] = null; // break the line
                    }
                }
            }

            return { x, y, asymptotes };
        } catch (error) {
            console.error('Error generating Cartesian plot:', error);
            return null;
        }
    }

    /**
     * Calculate numerical integration (area under curve) using trapezoidal rule
     */
    numericalIntegration(expression, xMin, xMax, numPoints = 1000) {
        try {
            if (!expression || typeof expression !== 'string' || expression.trim() === '') {
                return null;
            }

            // Ensure even number of intervals for Simpson's rule
            if (numPoints % 2 !== 0) numPoints++;
            const compiledExpr = math.compile(this.normalizeExpression(this.stripCartesianPrefix(expression)));
            const step = (xMax - xMin) / numPoints;
            let area = 0;

            // Composite Simpson's 1/3 rule: ∫ ≈ h/3 [f(x0) + 4f(x1) + 2f(x2) + 4f(x3) + ... + f(xn)]
            for (let i = 0; i <= numPoints; i++) {
                const x = xMin + i * step;
                try {
                    const y = compiledExpr.evaluate({ x });
                    if (isFinite(y)) {
                        if (i === 0 || i === numPoints) {
                            area += y;
                        } else if (i % 2 === 1) {
                            area += 4 * y;
                        } else {
                            area += 2 * y;
                        }
                    }
                } catch (e) {
                    // Skip invalid points
                }
            }

            area = (area * step) / 3;

            // Generate points for shading
            const x = [];
            const y = [];
            for (let i = 0; i <= numPoints; i++) {
                const xVal = xMin + i * step;
                try {
                    const yVal = compiledExpr.evaluate({ x: xVal });
                    if (isFinite(yVal)) {
                        x.push(xVal);
                        y.push(yVal);
                    }
                } catch (e) {
                    // Skip
                }
            }

            return { area, x, y };
        } catch (error) {
            console.error('Error calculating integration:', error);
            return null;
        }
    }

    /**
     * Generate Riemann sum rectangles (or trapezoids) for visualisation.
     * @param {string} expression - math expression in x
     * @param {number} a - left bound
     * @param {number} b - right bound
     * @param {number} n - number of subdivisions
     * @param {'left'|'right'|'midpoint'|'trapezoidal'} method
     * @returns {{shapes: Array, area: number}|null}
     */
    generateRiemannSum(expression, a, b, n, method) {
        try {
            if (!expression || typeof expression !== 'string' || expression.trim() === '') return null;
            const compiled = math.compile(this.normalizeExpression(this.stripCartesianPrefix(expression)));
            const dx = (b - a) / n;
            const shapes = []; // each shape: {x: [...], y: [...]}
            let area = 0;

            const f = (xv) => {
                try {
                    const v = compiled.evaluate({ x: xv });
                    return isFinite(v) ? v : 0;
                } catch (_) { return 0; }
            };

            for (let i = 0; i < n; i++) {
                const xi = a + i * dx;
                const xi1 = xi + dx;

                if (method === 'trapezoidal') {
                    const yL = f(xi);
                    const yR = f(xi1);
                    shapes.push({ x: [xi, xi, xi1, xi1, xi], y: [0, yL, yR, 0, 0] });
                    area += (yL + yR) * dx / 2;
                } else {
                    let sampleX;
                    if (method === 'left') sampleX = xi;
                    else if (method === 'right') sampleX = xi1;
                    else /* midpoint */ sampleX = xi + dx / 2;
                    const h = f(sampleX);
                    shapes.push({ x: [xi, xi, xi1, xi1, xi], y: [0, h, h, 0, 0] });
                    area += h * dx;
                }
            }
            return { shapes, area };
        } catch (error) {
            console.error('Error generating Riemann sum:', error);
            return null;
        }
    }

    /**
     * Calculate derivative of expression using numerical differentiation
     */
    generateDerivative(expression, xMin = -10, xMax = 10, numPoints = 500) {
        try {
            if (!expression || typeof expression !== 'string' || expression.trim() === '') {
                return null;
            }

            const x = [];
            const y = [];
            const step = (xMax - xMin) / numPoints;
            const h = 0.001; // Small step for numerical derivative

            const compiledExpr = math.compile(this.normalizeExpression(this.stripCartesianPrefix(expression)));

            for (let i = 0; i <= numPoints; i++) {
                const xVal = xMin + i * step;

                try {
                    // Numerical derivative using central difference: f'(x) ≈ (f(x+h) - f(x-h)) / (2h)
                    const yPlus = compiledExpr.evaluate({ x: xVal + h });
                    const yMinus = compiledExpr.evaluate({ x: xVal - h });
                    const derivative = (yPlus - yMinus) / (2 * h);

                    if (isFinite(derivative)) {
                        x.push(xVal);
                        y.push(derivative);
                    } else {
                        x.push(xVal);
                        y.push(null);
                    }
                } catch (e) {
                    x.push(xVal);
                    y.push(null);
                }
            }

            return { x, y };
        } catch (error) {
            console.error('Error generating derivative:', error);
            return null;
        }
    }

    /**
     * Generate symbolic antiderivative F(x) using Nerdamer
     */
    generateAntiderivative(expression, xMin = -10, xMax = 10, numPoints = 500) {
        try {
            if (typeof nerdamer === 'undefined') return null;
            if (!expression || typeof expression !== 'string' || expression.trim() === '') return null;

            const expr = this.stripCartesianPrefix(this.normalizeExpression(expression));
            const antideriv = nerdamer('integrate(' + expr + ', x)');
            const antiText = antideriv.text();
            if (!antiText) return null;

            const x = [], y = [];
            const step = (xMax - xMin) / numPoints;

            for (let i = 0; i <= numPoints; i++) {
                const xVal = xMin + i * step;
                try {
                    nerdamer.setVar('x', String(xVal));
                    const yVal = parseFloat(nerdamer(antiText).evaluate().text());
                    nerdamer.clearVars();
                    if (isFinite(yVal)) { x.push(xVal); y.push(yVal); }
                    else { x.push(xVal); y.push(null); }
                } catch (_) {
                    nerdamer.clearVars();
                    x.push(xVal); y.push(null);
                }
            }

            return { x, y, symbolic: antiText };
        } catch (error) {
            console.error('Error generating antiderivative:', error);
            return null;
        }
    }

    /**
     * SymPy fallback for antiderivative when Nerdamer fails.
     * Returns a Promise that resolves to { x, y, symbolic } or null.
     */
    generateAntiderivativeSymPy(expression, xMin = -10, xMax = 10, numPoints = 500) {
        const pyExpr = GraphingEngine._toPython(this.stripCartesianPrefix(this.normalizeExpression(expression)));
        const code =
            'from sympy import *\n' +
            'import json\n' +
            'x = symbols("x")\n' +
            'try:\n' +
            '    expr = ' + pyExpr + '\n' +
            '    F = integrate(expr, x)\n' +
            '    sym = str(F)\n' +
            '    xs = [' + xMin + ' + i*' + ((xMax - xMin) / numPoints) + ' for i in range(' + (numPoints + 1) + ')]\n' +
            '    ys = []\n' +
            '    for xv in xs:\n' +
            '        try:\n' +
            '            yv = float(F.subs(x, xv))\n' +
            '            ys.append(yv if abs(yv) < 1e15 else None)\n' +
            '        except: ys.append(None)\n' +
            '    print("ANTI:" + json.dumps({"symbolic": sym, "x": xs, "y": ys}))\n' +
            'except Exception as e:\n' +
            '    print("ERROR:" + str(e))';
        return this._sympyExec(code).then(stdout => {
            const m = stdout.match(/ANTI:([\s\S]*)/);
            if (!m) return null;
            try {
                const data = JSON.parse(m[1].trim());
                return { x: data.x, y: data.y, symbolic: data.symbolic };
            } catch (e) { return null; }
        });
    }

    /**
     * Evaluate a limit using Nerdamer: limit(expr, variable, value)
     */
    evaluateLimit(expression, variable, value) {
        try {
            if (typeof nerdamer === 'undefined') return null;
            const expr = this.normalizeExpression(expression);
            const result = nerdamer('limit(' + expr + ', ' + variable + ', ' + value + ')');
            const text = result.text();
            const numVal = parseFloat(nerdamer(text).evaluate().text());
            return { symbolic: text, numeric: isFinite(numVal) ? numVal : null };
        } catch (error) {
            console.error('Error evaluating limit:', error);
            return null;
        }
    }

    /**
     * SymPy fallback for limit evaluation.
     * Returns a Promise that resolves to { symbolic, numeric } or null.
     */
    evaluateLimitSymPy(expression, variable, value) {
        const pyExpr = GraphingEngine._toPython(this.normalizeExpression(expression));
        // Handle ±infinity
        let pyVal = String(value).trim();
        if (pyVal === 'Infinity' || pyVal === 'inf' || pyVal === '∞') pyVal = 'oo';
        else if (pyVal === '-Infinity' || pyVal === '-inf' || pyVal === '-∞') pyVal = '-oo';
        const code =
            'from sympy import *\n' +
            'import json\n' +
            variable + ' = symbols("' + variable + '")\n' +
            'try:\n' +
            '    expr = ' + pyExpr + '\n' +
            '    L = limit(expr, ' + variable + ', ' + pyVal + ')\n' +
            '    sym = str(L)\n' +
            '    try: num = float(L)\n' +
            '    except: num = None\n' +
            '    print("LIMIT:" + json.dumps({"symbolic": sym, "numeric": num}))\n' +
            'except Exception as e:\n' +
            '    print("ERROR:" + str(e))';
        return this._sympyExec(code).then(stdout => {
            const m = stdout.match(/LIMIT:([\s\S]*)/);
            if (!m) return null;
            try {
                const data = JSON.parse(m[1].trim());
                return { symbolic: data.symbolic, numeric: data.numeric };
            } catch (e) { return null; }
        });
    }

    /**
     * Calculate tangent line at specific point
     */
    calculateTangent(expression, xPoint, xMin = -10, xMax = 10) {
        try {
            const compiledExpr = math.compile(this.normalizeExpression(this.stripCartesianPrefix(expression)));
            const h = 0.001;

            // Calculate y value at point
            const yPoint = compiledExpr.evaluate({ x: xPoint });

            // Calculate derivative (slope) at point
            const yPlus = compiledExpr.evaluate({ x: xPoint + h });
            const yMinus = compiledExpr.evaluate({ x: xPoint - h });
            const slope = (yPlus - yMinus) / (2 * h);

            // Generate tangent line: y - y0 = m(x - x0)
            // y = m(x - x0) + y0
            const x = [xMin, xMax];
            const y = [
                slope * (xMin - xPoint) + yPoint,
                slope * (xMax - xPoint) + yPoint
            ];

            return { x, y, slope, point: { x: xPoint, y: yPoint } };
        } catch (error) {
            console.error('Error calculating tangent:', error);
            return null;
        }
    }

    /**
     * Generate data for Parametric plot (x(t), y(t))
     */
    generateParametric(xExpr, yExpr, tMin = 0, tMax = 2 * Math.PI, numPoints = 500) {
        try {
            // Validate expressions
            if (!xExpr || !yExpr || typeof xExpr !== 'string' || typeof yExpr !== 'string') {
                return null;
            }

            const xCompiled = math.compile(this.normalizeExpression(xExpr.trim()));
            const yCompiled = math.compile(this.normalizeExpression(yExpr.trim()));

            const x = [];
            const y = [];
            const step = (tMax - tMin) / numPoints;

            for (let i = 0; i <= numPoints; i++) {
                const t = tMin + i * step;

                try {
                    const xVal = xCompiled.evaluate({ t: t });
                    const yVal = yCompiled.evaluate({ t: t });

                    if (isFinite(xVal) && isFinite(yVal)) {
                        x.push(xVal);
                        y.push(yVal);
                    }
                } catch (e) {
                    // Skip invalid points
                }
            }

            return { x, y };
        } catch (error) {
            console.error('Error generating Parametric plot:', error);
            return null;
        }
    }

    /**
     * Generate data for Polar plot (r(θ))
     */
    generatePolar(expression, thetaMin = 0, thetaMax = 2 * Math.PI, numPoints = 500) {
        try {
            // Validate expression
            if (!expression || typeof expression !== 'string' || expression.trim() === '') {
                return null;
            }
            // Strip "r = " prefix if present
            let cleaned = expression.replace(/^\s*r\s*=\s*/i, '');
            const compiledExpr = math.compile(this.normalizeExpression(cleaned));

            const x = [];
            const y = [];
            const step = (thetaMax - thetaMin) / numPoints;

            for (let i = 0; i <= numPoints; i++) {
                const theta = thetaMin + i * step;

                try {
                    const r = compiledExpr.evaluate({
                        theta: theta,
                        θ: theta  // Support both theta and θ
                    });

                    if (isFinite(r)) {
                        x.push(r * Math.cos(theta));
                        y.push(r * Math.sin(theta));
                    }
                } catch (e) {
                    // Skip invalid points
                }
            }

            return { x, y };
        } catch (error) {
            console.error('Error generating Polar plot:', error);
            return null;
        }
    }

    /**
     * Generate data for Implicit Functions (e.g., x^2 + y^2 = 25)
     */
    generateImplicit(expression, xMin = -10, xMax = 10, yMin = -10, yMax = 10, resolution = 400) {
        try {
            // Parse expression like "x^2 + y^2 = 25" into left - right = 0
            let leftExpr, rightExpr;

            if (expression.includes('=')) {
                const parts = expression.split('=');
                leftExpr = parts[0].trim();
                rightExpr = parts[1].trim();
            } else {
                leftExpr = expression.trim();
                rightExpr = '0';
            }

            const leftCompiled = math.compile(this.normalizeExpression(leftExpr));
            const rightCompiled = math.compile(this.normalizeExpression(rightExpr));

            const xStep = (xMax - xMin) / resolution;
            const yStep = (yMax - yMin) / resolution;

            // Evaluate f(x,y) = left - right on the grid
            const grid = [];
            for (let i = 0; i <= resolution; i++) {
                const row = [];
                for (let j = 0; j <= resolution; j++) {
                    const xVal = xMin + j * xStep;
                    const yVal = yMin + i * yStep;
                    try {
                        const scope = { x: xVal, y: yVal };
                        const diff = leftCompiled.evaluate(scope) - rightCompiled.evaluate(scope);
                        row.push(isFinite(diff) ? diff : NaN);
                    } catch (_) {
                        row.push(NaN);
                    }
                }
                grid.push(row);
            }

            // Marching squares with line segments — produces connected contour lines.
            // Each cell with a sign change yields one or two line segments.
            // Edge interpolation points (indexed 0-3: bottom, right, top, left):
            const xs = [], ys = [];
            const interp = (v1, v2, p1, p2) => p1 + (p2 - p1) * v1 / (v1 - v2);

            for (let i = 0; i < resolution; i++) {
                for (let j = 0; j < resolution; j++) {
                    const z00 = grid[i][j], z10 = grid[i][j+1];
                    const z01 = grid[i+1][j], z11 = grid[i+1][j+1];
                    if (isNaN(z00) || isNaN(z10) || isNaN(z01) || isNaN(z11)) continue;

                    const x0 = xMin + j * xStep, x1 = x0 + xStep;
                    const y0 = yMin + i * yStep, y1 = y0 + yStep;

                    // Classify corners: 0 = negative, 1 = positive
                    const config = (z00 > 0 ? 1 : 0) | (z10 > 0 ? 2 : 0) |
                                   (z11 > 0 ? 4 : 0) | (z01 > 0 ? 8 : 0);
                    if (config === 0 || config === 15) continue;

                    // Interpolated edge points
                    const bottom = [interp(z00, z10, x0, x1), y0];
                    const right  = [x1, interp(z10, z11, y0, y1)];
                    const top    = [interp(z01, z11, x0, x1), y1];
                    const left   = [x0, interp(z00, z01, y0, y1)];

                    // Marching squares lookup — each config yields 1 or 2 segments
                    const segments = [];
                    switch (config) {
                        case 1: case 14: segments.push([bottom, left]); break;
                        case 2: case 13: segments.push([bottom, right]); break;
                        case 3: case 12: segments.push([left, right]); break;
                        case 4: case 11: segments.push([right, top]); break;
                        case 5: segments.push([bottom, right], [left, top]); break;
                        case 6: case 9:  segments.push([bottom, top]); break;
                        case 7: case 8:  segments.push([left, top]); break;
                        case 10: segments.push([bottom, left], [right, top]); break;
                    }

                    // Add segments separated by null (gap) for Plotly disconnected lines
                    for (const seg of segments) {
                        xs.push(seg[0][0], seg[1][0], null);
                        ys.push(seg[0][1], seg[1][1], null);
                    }
                }
            }

            return xs.length > 0 ? { x: xs, y: ys, mode: 'lines' } : null;
        } catch (error) {
            console.error('Error generating implicit function:', error);
            return null;
        }
    }

    /**
     * Generate data for Piecewise Functions
     */
    generatePiecewise(pieces, xMin = -10, xMax = 10, numPoints = 500) {
        try {
            if (!pieces || pieces.length === 0) {
                return null;
            }

            const x = [];
            const y = [];
            const step = (xMax - xMin) / numPoints;

            for (let i = 0; i <= numPoints; i++) {
                const xVal = xMin + i * step;
                let yVal = null;

                // Find which piece applies to this x value
                for (const piece of pieces) {
                    const { expression, condition } = piece;

                    try {
                        // Evaluate condition
                        const conditionMet = this.evaluateCondition(xVal, condition);

                        if (conditionMet) {
                            const compiled = math.compile(this.normalizeExpression(expression));
                            yVal = compiled.evaluate({ x: xVal });
                            break;
                        }
                    } catch (e) {
                        // Skip
                    }
                }

                if (yVal !== null && isFinite(yVal)) {
                    x.push(xVal);
                    y.push(yVal);
                } else {
                    x.push(xVal);
                    y.push(null);
                }
            }

            return { x, y };
        } catch (error) {
            console.error('Error generating piecewise function:', error);
            return null;
        }
    }

    /**
     * Evaluate piecewise condition (e.g., "x < 0", "x >= -2 and x < 2")
     */
    evaluateCondition(xVal, condition) {
        try {
            if (!condition || condition === 'true' || condition.trim() === '') {
                return true; // Default condition
            }

            // Math.js supports 'and' / 'or' natively; convert '&&' / '||' to those
            let cond = condition.replace(/&&/g, ' and ').replace(/\|\|/g, ' or ');

            // Create a safe evaluation context
            const scope = { x: xVal };
            const compiled = math.compile(cond);
            const result = compiled.evaluate(scope);

            return Boolean(result);
        } catch (e) {
            console.error('Error evaluating condition:', e);
            return false;
        }
    }

    /**
     * Generate data for Inequality (y > f(x), y < f(x), etc.)
     */
    generateInequality(leftExpr, operator, rightExpr, xMin = -10, xMax = 10, yMin = -10, yMax = 10, resolution = 100) {
        try {
            // Validate expressions
            if (!leftExpr || !rightExpr || typeof leftExpr !== 'string' || typeof rightExpr !== 'string') {
                return null;
            }

            const leftCompiled = math.compile(this.normalizeExpression(leftExpr.trim()));
            const rightCompiled = math.compile(this.normalizeExpression(rightExpr.trim()));

            const x = [];
            const y = [];
            const z = [];

            const xStep = (xMax - xMin) / resolution;
            const yStep = (yMax - yMin) / resolution;

            for (let i = 0; i <= resolution; i++) {
                const xRow = [];
                const yRow = [];
                const zRow = [];

                for (let j = 0; j <= resolution; j++) {
                    const xVal = xMin + j * xStep;
                    const yVal = yMin + i * yStep;
                    const scope = { x: xVal, y: yVal };

                    try {
                        const leftVal = leftCompiled.evaluate(scope);
                        const rightVal = rightCompiled.evaluate(scope);

                        let satisfies = false;
                        switch (operator) {
                            case '>': satisfies = leftVal > rightVal; break;
                            case '<': satisfies = leftVal < rightVal; break;
                            case '>=': satisfies = leftVal >= rightVal; break;
                            case '<=': satisfies = leftVal <= rightVal; break;
                            case '=': satisfies = Math.abs(leftVal - rightVal) < 0.1; break;
                        }

                        xRow.push(xVal);
                        yRow.push(yVal);
                        zRow.push(satisfies ? 1 : 0);
                    } catch (e) {
                        xRow.push(xVal);
                        yRow.push(yVal);
                        zRow.push(0);
                    }
                }

                x.push(xRow);
                y.push(yRow);
                z.push(zRow);
            }

            return { x, y, z };
        } catch (error) {
            console.error('Error generating Inequality:', error);
            return null;
        }
    }

    /**
     * Parse table data (comma or newline separated x,y pairs)
     */
    parseTableData(text) {
        try {
            const x = [];
            const y = [];

            // Split by newlines or semicolons
            const rows = text.split(/[\n;]/).filter(r => r.trim());

            for (const row of rows) {
                // Split by comma or space
                const values = row.split(/[,\s]+/).map(v => parseFloat(v.trim()));

                if (values.length >= 2 && isFinite(values[0]) && isFinite(values[1])) {
                    x.push(values[0]);
                    y.push(values[1]);
                }
            }

            return { x, y };
        } catch (error) {
            console.error('Error parsing table data:', error);
            return null;
        }
    }

    /**
     * Statistical Distribution Functions
     */

    // Normal (Gaussian) Distribution PDF
    normalDistribution(x, mean = 0, stdDev = 1) {
        const coefficient = 1 / (stdDev * Math.sqrt(2 * Math.PI));
        const exponent = -Math.pow(x - mean, 2) / (2 * Math.pow(stdDev, 2));
        return coefficient * Math.exp(exponent);
    }

    // Chi-squared Distribution PDF
    chiSquaredDistribution(x, k) {
        if (x <= 0) return 0;
        const numerator = Math.pow(x, k/2 - 1) * Math.exp(-x/2);
        const denominator = Math.pow(2, k/2) * this.gamma(k/2);
        return numerator / denominator;
    }

    // Uniform Distribution PDF
    uniformDistribution(x, a = 0, b = 1) {
        if (x < a || x > b) return 0;
        return 1 / (b - a);
    }

    // Exponential Distribution PDF
    exponentialDistribution(x, lambda = 1) {
        if (x < 0) return 0;
        return lambda * Math.exp(-lambda * x);
    }

    // Binomial Distribution PMF
    binomialDistribution(k, n, p) {
        if (k < 0 || k > n) return 0;
        return this.binomialCoefficient(n, k) * Math.pow(p, k) * Math.pow(1 - p, n - k);
    }

    // Poisson Distribution PMF
    poissonDistribution(k, lambda) {
        if (k < 0) return 0;
        return (Math.pow(lambda, k) * Math.exp(-lambda)) / this.factorial(k);
    }

    // Student's t-distribution PDF
    tDistribution(x, df) {
        const numerator = this.gamma((df + 1) / 2);
        const denominator = Math.sqrt(df * Math.PI) * this.gamma(df / 2);
        const factor = Math.pow(1 + (x * x) / df, -(df + 1) / 2);
        return (numerator / denominator) * factor;
    }

    // Beta Distribution PDF
    betaDistribution(x, alpha, beta) {
        if (x <= 0 || x >= 1) return 0;
        const numerator = Math.pow(x, alpha - 1) * Math.pow(1 - x, beta - 1);
        const denominator = this.betaFunction(alpha, beta);
        return numerator / denominator;
    }

    // Gamma Distribution PDF
    gammaDistribution(x, shape, scale = 1) {
        if (x <= 0) return 0;
        const numerator = Math.pow(x, shape - 1) * Math.exp(-x / scale);
        const denominator = Math.pow(scale, shape) * this.gamma(shape);
        return numerator / denominator;
    }

    // Helper: Factorial
    factorial(n) {
        if (n <= 1) return 1;
        let result = 1;
        for (let i = 2; i <= n; i++) {
            result *= i;
        }
        return result;
    }

    // Helper: Binomial Coefficient
    binomialCoefficient(n, k) {
        return this.factorial(n) / (this.factorial(k) * this.factorial(n - k));
    }

    // Helper: Gamma function (Stirling's approximation)
    gamma(z) {
        if (z === 1) return 1;
        if (z === 0.5) return Math.sqrt(Math.PI);

        // Lanczos approximation
        const g = 7;
        const C = [
            0.99999999999980993,
            676.5203681218851,
            -1259.1392167224028,
            771.32342877765313,
            -176.61502916214059,
            12.507343278686905,
            -0.13857109526572012,
            9.9843695780195716e-6,
            1.5056327351493116e-7
        ];

        if (z < 0.5) {
            return Math.PI / (Math.sin(Math.PI * z) * this.gamma(1 - z));
        }

        z -= 1;
        let x = C[0];
        for (let i = 1; i < g + 2; i++) {
            x += C[i] / (z + i);
        }

        const t = z + g + 0.5;
        return Math.sqrt(2 * Math.PI) * Math.pow(t, z + 0.5) * Math.exp(-t) * x;
    }

    // Helper: Beta function
    betaFunction(alpha, beta) {
        return (this.gamma(alpha) * this.gamma(beta)) / this.gamma(alpha + beta);
    }

    /**
     * Generate 3D surface data for z = f(x,y)
     */
    generateSurface(expression, xMin = -5, xMax = 5, yMin = -5, yMax = 5, resolution = 60) {
        try {
            if (!expression || typeof expression !== 'string') return null;
            let expr = expression.trim().replace(/^\s*z\s*=\s*/i, '');
            const compiled = math.compile(this.normalizeExpression(expr));

            const xArr = [], yArr = [], zGrid = [];
            const xStep = (xMax - xMin) / resolution;
            const yStep = (yMax - yMin) / resolution;

            for (let i = 0; i <= resolution; i++) {
                xArr.push(xMin + i * xStep);
            }
            for (let j = 0; j <= resolution; j++) {
                yArr.push(yMin + j * yStep);
            }

            for (let j = 0; j <= resolution; j++) {
                const row = [];
                for (let i = 0; i <= resolution; i++) {
                    try {
                        const zVal = compiled.evaluate({ x: xArr[i], y: yArr[j] });
                        row.push(typeof zVal === 'number' && isFinite(zVal) ? zVal : null);
                    } catch (_) {
                        row.push(null);
                    }
                }
                zGrid.push(row);
            }

            return { x: xArr, y: yArr, z: zGrid };
        } catch (error) {
            console.error('Error generating surface:', error);
            return null;
        }
    }

    /**
     * Generate distribution data
     */
    generateDistribution(type, params, xMin, xMax, numPoints = 500) {
        const x = [];
        const y = [];

        // For discrete distributions (binomial, poisson)
        if (type === 'binomial' || type === 'poisson') {
            const maxK = type === 'binomial' ? params.n : Math.ceil(params.lambda * 3);
            for (let k = 0; k <= maxK; k++) {
                x.push(k);
                if (type === 'binomial') {
                    y.push(this.binomialDistribution(k, params.n, params.p));
                } else {
                    y.push(this.poissonDistribution(k, params.lambda));
                }
            }
            return { x, y, discrete: true };
        }

        // For continuous distributions
        const step = (xMax - xMin) / numPoints;

        for (let i = 0; i <= numPoints; i++) {
            const xVal = xMin + i * step;
            let yVal = 0;

            switch (type) {
                case 'normal':
                    yVal = this.normalDistribution(xVal, params.mean, params.stdDev);
                    break;
                case 'chi2':
                    yVal = this.chiSquaredDistribution(xVal, params.k);
                    break;
                case 'uniform':
                    yVal = this.uniformDistribution(xVal, params.a, params.b);
                    break;
                case 'exponential':
                    yVal = this.exponentialDistribution(xVal, params.lambda);
                    break;
                case 't':
                    yVal = this.tDistribution(xVal, params.df);
                    break;
                case 'beta':
                    yVal = this.betaDistribution(xVal, params.alpha, params.beta);
                    break;
                case 'gamma':
                    yVal = this.gammaDistribution(xVal, params.shape, params.scale);
                    break;
            }

            // Only add points with valid, non-zero y values (to avoid invisible flat lines)
            if (isFinite(yVal) && yVal > 1e-10) {
                x.push(xVal);
                y.push(yVal);
            }
        }

        return { x, y, discrete: false };
    }

    /**
     * Find intersection points between two expressions
     */
    findIntersections(expr1, expr2, xMin = -10, xMax = 10, tolerance = 0.01) {
        try {
            const compiled1 = math.compile(this.normalizeExpression(this.stripCartesianPrefix(expr1)));
            const compiled2 = math.compile(this.normalizeExpression(this.stripCartesianPrefix(expr2)));
            const intersections = [];
            const numSamples = 1000;
            const step = (xMax - xMin) / numSamples;

            let prevSign = null;

            for (let i = 0; i <= numSamples; i++) {
                const x = xMin + i * step;

                try {
                    const y1 = compiled1.evaluate({ x });
                    const y2 = compiled2.evaluate({ x });
                    const diff = y1 - y2;

                    if (!isFinite(diff)) continue;

                    const currentSign = Math.sign(diff);

                    // Check for sign change (indicates intersection)
                    if (prevSign !== null && prevSign !== currentSign && currentSign !== 0) {
                        // Use bisection method to refine intersection
                        const intersection = this.bisectionMethod(
                            compiled1, compiled2,
                            x - step, x,
                            tolerance
                        );

                        if (intersection) {
                            intersections.push(intersection);
                        }
                    }

                    // Check for exact zero
                    if (Math.abs(diff) < tolerance) {
                        const y = compiled1.evaluate({ x });
                        intersections.push({ x, y });
                    }

                    prevSign = currentSign;
                } catch (e) {
                    // Skip points where evaluation fails
                }
            }

            // Remove duplicate points
            const unique = [];
            for (const point of intersections) {
                const isDuplicate = unique.some(p =>
                    Math.abs(p.x - point.x) < tolerance * 10
                );
                if (!isDuplicate) {
                    unique.push(point);
                }
            }

            return unique;
        } catch (error) {
            console.error('Error finding intersections:', error);
            return [];
        }
    }

    /**
     * Bisection method to refine intersection point
     */
    bisectionMethod(compiled1, compiled2, xLeft, xRight, tolerance) {
        let left = xLeft;
        let right = xRight;
        let iterations = 0;
        const maxIterations = 50;

        while (iterations < maxIterations && (right - left) > tolerance) {
            const mid = (left + right) / 2;

            try {
                const y1Left = compiled1.evaluate({ x: left });
                const y2Left = compiled2.evaluate({ x: left });
                const diffLeft = y1Left - y2Left;

                const y1Mid = compiled1.evaluate({ x: mid });
                const y2Mid = compiled2.evaluate({ x: mid });
                const diffMid = y1Mid - y2Mid;

                if (Math.abs(diffMid) < tolerance) {
                    return { x: mid, y: y1Mid };
                }

                if (Math.sign(diffLeft) !== Math.sign(diffMid)) {
                    right = mid;
                } else {
                    left = mid;
                }
            } catch (e) {
                return null;
            }

            iterations++;
        }

        const x = (left + right) / 2;
        try {
            const y = compiled1.evaluate({ x });
            return { x, y };
        } catch (e) {
            return null;
        }
    }

    /**
     * Calculate statistics for data
     */
    calculateStatistics(x, y) {
        if (!x || !y || x.length === 0 || y.length === 0) {
            return null;
        }

        const n = x.length;

        // Mean
        const meanX = math.mean(x);
        const meanY = math.mean(y);

        // Standard deviation
        const stdX = math.std(x);
        const stdY = math.std(y);

        // Min/Max
        const minX = math.min(x);
        const maxX = math.max(x);
        const minY = math.min(y);
        const maxY = math.max(y);

        // Correlation coefficient (Pearson's r)
        let correlation = 0;
        if (x.length === y.length && x.length > 1) {
            const numerator = x.reduce((sum, xi, i) =>
                sum + (xi - meanX) * (y[i] - meanY), 0);
            const denominator = Math.sqrt(
                x.reduce((sum, xi) => sum + Math.pow(xi - meanX, 2), 0) *
                y.reduce((sum, yi) => sum + Math.pow(yi - meanY, 2), 0)
            );
            correlation = denominator !== 0 ? numerator / denominator : 0;
        }

        // Linear regression (y = mx + b)
        let slope = 0, intercept = 0;
        if (x.length === y.length && x.length > 1) {
            const numerator = x.reduce((sum, xi, i) =>
                sum + (xi - meanX) * (y[i] - meanY), 0);
            const denominator = x.reduce((sum, xi) =>
                sum + Math.pow(xi - meanX, 2), 0);
            slope = denominator !== 0 ? numerator / denominator : 0;
            intercept = meanY - slope * meanX;
        }

        return {
            n,
            meanX: meanX.toFixed(4),
            meanY: meanY.toFixed(4),
            stdX: stdX.toFixed(4),
            stdY: stdY.toFixed(4),
            minX: minX.toFixed(4),
            maxX: maxX.toFixed(4),
            minY: minY.toFixed(4),
            maxY: maxY.toFixed(4),
            correlation: correlation.toFixed(4),
            slope: slope.toFixed(4),
            intercept: intercept.toFixed(4),
            regressionEquation: `y = ${slope.toFixed(4)}x + ${intercept.toFixed(4)}`
        };
    }

    /**
     * Generate regression line
     */
    generateRegression(x, y) {
        const stats = this.calculateStatistics(x, y);
        if (!stats) return null;

        const minX = Math.min(...x);
        const maxX = Math.max(...x);

        const xReg = [minX, maxX];
        const yReg = [
            parseFloat(stats.slope) * minX + parseFloat(stats.intercept),
            parseFloat(stats.slope) * maxX + parseFloat(stats.intercept)
        ];

        return { x: xReg, y: yReg };
    }

    /**
     * Create Plotly trace for an expression
     */
    createTrace(expr, settings = {}) {
        const { xMin = -10, xMax = 10, yMin = -10, yMax = 10 } = settings;

        let trace = null;

        // Normalize the expression into a local variable (don't mutate expr.expression)
        let normalizedExpr = expr.expression;
        if (normalizedExpr && typeof normalizedExpr === 'string') {
            normalizedExpr = this.normalizeExpression(normalizedExpr);
        }

        switch (expr.type) {
            case 'cartesian': {
                // Substitute parameters if they exist
                let expression = normalizedExpr;
                if (expr.parameters) {
                    Object.keys(expr.parameters).forEach(param => {
                        const regex = new RegExp(`\\b${param}\\b`, 'g');
                        expression = expression.replace(regex, expr.parameters[param]);
                    });
                }

                // Detect "x = <constant>" vertical line pattern
                const vertMatch = expression.match(/^\s*x\s*=\s*([+-]?\d+\.?\d*)\s*$/);
                if (vertMatch) {
                    const xConst = parseFloat(vertMatch[1]);
                    trace = [{
                        x: [xConst, xConst],
                        y: [yMin, yMax],
                        type: 'scatter',
                        mode: 'lines',
                        name: expr.expression,
                        line: { color: expr.color, width: 2, dash: 'dash' }
                    }];
                    break;
                }

                const data = this.generateCartesian(expression, xMin, xMax);
                if (data) {
                    trace = [{
                        x: data.x,
                        y: data.y,
                        type: 'scatter',
                        mode: 'lines',
                        name: expr.expression,
                        line: { color: expr.color, width: 2 },
                        connectgaps: false,
                        hovertemplate: 'x = %{x:.4f}<br>y = %{y:.4f}<extra>%{fullData.name}</extra>'
                    }];

                    // Add vertical asymptote lines
                    if (data.asymptotes && data.asymptotes.length > 0) {
                        for (const ax of data.asymptotes) {
                            trace.push({
                                x: [ax, ax], y: [yMin, yMax],
                                type: 'scatter', mode: 'lines',
                                line: { color: '#94a3b8', width: 1, dash: 'dot' },
                                showlegend: false, hoverinfo: 'skip'
                            });
                        }
                    }

                    // Add derivative if enabled
                    if (expr.showDerivative) {
                        const derivData = this.generateDerivative(expression, xMin, xMax);
                        if (derivData) {
                            trace.push({
                                x: derivData.x,
                                y: derivData.y,
                                type: 'scatter',
                                mode: 'lines',
                                name: `f'(${expr.expression})`,
                                line: { color: expr.color, width: 2, dash: 'dash' },
                                connectgaps: false
                            });
                        }
                    }

                    // Add antiderivative F(x) if enabled
                    if (expr.showAntiderivative) {
                        const antiData = this.generateAntiderivative(expression, xMin, xMax);
                        if (antiData) {
                            trace.push({
                                x: antiData.x,
                                y: antiData.y,
                                type: 'scatter',
                                mode: 'lines',
                                name: `F(x) = ∫${expr.expression} dx`,
                                line: { color: expr.color, width: 2, dash: 'dot' },
                                connectgaps: false
                            });
                        } else if (!expr._sympyAntiResolved) {
                            // Queue SymPy fallback for antiderivative
                            expr._sympyAntiNeeded = { expression, xMin, xMax };
                        }
                    }

                    // Add intersection points if they exist
                    if (expr.intersections && expr.intersections.length > 0) {
                        const intersX = expr.intersections.map(p => p.x);
                        const intersY = expr.intersections.map(p => p.y);
                        trace.push({
                            x: intersX,
                            y: intersY,
                            type: 'scatter',
                            mode: 'markers',
                            name: 'Intersections',
                            marker: { color: 'red', size: 10, symbol: 'circle' },
                            showlegend: false
                        });
                    }

                    // Add solution points if they exist
                    if (expr.solutions && expr.solutions.length > 0) {
                        const solX = expr.solutions.map(p => p.x);
                        const solY = expr.solutions.map(p => p.y);
                        trace.push({
                            x: solX,
                            y: solY,
                            type: 'scatter',
                            mode: 'markers',
                            name: 'Solutions',
                            marker: { color: 'green', size: 10, symbol: 'star' },
                            showlegend: false
                        });
                    }

                    // Add integration shading if enabled
                    if (expr.showIntegration && expr.integrationBounds) {
                        const { a, b } = expr.integrationBounds;
                        const integrationData = this.numericalIntegration(expression, a, b);

                        if (integrationData) {
                            // Add shaded area
                            const shadedX = [a, ...integrationData.x, b, a];
                            const shadedY = [0, ...integrationData.y, 0, 0];

                            trace.push({
                                x: shadedX,
                                y: shadedY,
                                type: 'scatter',
                                fill: 'toself',
                                fillcolor: expr.color + '30', // Add transparency
                                line: { width: 0 },
                                name: `Area = ${integrationData.area.toFixed(4)}`,
                                showlegend: true,
                                hoverinfo: 'skip'
                            });
                        }
                    }

                    // Add Riemann sum rectangles/trapezoids if enabled
                    if (expr.showIntegration && expr.integrationBounds && expr.riemannMethod && expr.riemannMethod !== 'none') {
                        const { a, b } = expr.integrationBounds;
                        const rN = expr.riemannN || 10;
                        const riemannData = this.generateRiemannSum(expression, a, b, rN, expr.riemannMethod);
                        if (riemannData) {
                            const methodLabels = { left: 'Left', right: 'Right', midpoint: 'Midpoint', trapezoidal: 'Trap' };
                            riemannData.shapes.forEach((shape, idx) => {
                                trace.push({
                                    x: shape.x,
                                    y: shape.y,
                                    type: 'scatter',
                                    fill: 'toself',
                                    fillcolor: expr.color + '22',
                                    line: { color: expr.color, width: 1 },
                                    showlegend: idx === 0,
                                    name: idx === 0 ? `${methodLabels[expr.riemannMethod]} Riemann (n=${rN}) ≈ ${riemannData.area.toFixed(4)}` : '',
                                    hoverinfo: 'skip'
                                });
                            });
                        }
                    }
                }
                break;
            }

            case 'implicit': {
                const data = this.generateImplicit(normalizedExpr, xMin, xMax, yMin, yMax);
                if (data) {
                    trace = {
                        x: data.x,
                        y: data.y,
                        type: 'scatter',
                        mode: data.mode || 'lines',
                        name: expr.expression,
                        line: { color: expr.color, width: 2 },
                        connectgaps: false,
                        hovertemplate: 'x = %{x:.4f}<br>y = %{y:.4f}<extra>%{fullData.name}</extra>'
                    };
                }
                break;
            }

            case 'piecewise': {
                if (expr.pieces) {
                    const data = this.generatePiecewise(expr.pieces, xMin, xMax);
                    if (data) {
                        trace = {
                            x: data.x,
                            y: data.y,
                            type: 'scatter',
                            mode: 'lines',
                            name: expr.expression || 'Piecewise Function',
                            line: { color: expr.color, width: 2 },
                            connectgaps: false
                        };
                    }
                }
                break;
            }

            case 'surface': {
                if (!_fullPlotlyLoaded) {
                    // Full Plotly not yet loaded — trigger load and re-plot when ready
                    _ensureFullPlotly(function() { updateGraph(); });
                    break;
                }
                const surfData = this.generateSurface(normalizedExpr, xMin, xMax, yMin, yMax);
                if (surfData) {
                    trace = {
                        x: surfData.x, y: surfData.y, z: surfData.z,
                        type: 'surface',
                        name: expr.expression,
                        colorscale: 'Viridis',
                        showscale: true
                    };
                }
                break;
            }

            case 'parametric': {
                // Strip optional "x(t) = " and "y(t) = " prefixes; also support semicolon separator
                const paramParts = normalizedExpr.replace(/;/g, ',').split(',').map(e =>
                    e.trim().replace(/^\s*[xy]\s*\(\s*t\s*\)\s*=\s*/i, '')
                );
                const [xExpr, yExpr] = paramParts;
                const tMin = expr.tMin != null ? expr.tMin : 0;
                const tMax = expr.tMax != null ? expr.tMax : 2 * Math.PI;
                const data = this.generateParametric(xExpr, yExpr, tMin, tMax);
                if (data) {
                    trace = {
                        x: data.x,
                        y: data.y,
                        type: 'scatter',
                        mode: 'lines',
                        name: expr.expression,
                        line: { color: expr.color, width: 2 }
                    };
                }
                break;
            }

            case 'polar': {
                const thetaMin = expr.thetaMin != null ? expr.thetaMin : 0;
                const thetaMax = expr.thetaMax != null ? expr.thetaMax : 2 * Math.PI;
                const numPts = thetaMax - thetaMin > 4 * Math.PI ? 2000 : 500;
                const data = this.generatePolar(normalizedExpr, thetaMin, thetaMax, numPts);
                if (data) {
                    trace = {
                        x: data.x,
                        y: data.y,
                        type: 'scatter',
                        mode: 'lines',
                        name: expr.expression,
                        line: { color: expr.color, width: 2 }
                    };
                }
                break;
            }

            case 'inequality': {
                const match = normalizedExpr.match(/(.+?)(>=|<=|>|<|=)(.+)/);
                if (match) {
                    const data = this.generateInequality(
                        match[1].trim(),
                        match[2],
                        match[3].trim(),
                        xMin, xMax, yMin, yMax
                    );
                    if (data) {
                        // Extract satisfied points from the grid
                        const ixs = [], iys = [];
                        for (let i = 0; i < data.z.length; i++) {
                            for (let j = 0; j < data.z[i].length; j++) {
                                if (data.z[i][j] === 1) {
                                    ixs.push(data.x[i][j]);
                                    iys.push(data.y[i][j]);
                                }
                            }
                        }
                        trace = {
                            x: ixs,
                            y: iys,
                            type: 'scatter',
                            mode: 'markers',
                            name: expr.expression,
                            marker: { color: expr.color, size: 3, opacity: 0.25 },
                            hoverinfo: 'name'
                        };
                    }
                }
                break;
            }

            case 'table': {
                const data = this.parseTableData(expr.expression);
                if (data) {
                    trace = {
                        x: data.x,
                        y: data.y,
                        type: 'scatter',
                        mode: 'markers',
                        name: 'Data Points',
                        marker: { color: expr.color, size: 8 }
                    };
                }
                break;
            }

            case 'statistics': {
                const data = this.parseTableData(normalizedExpr);
                if (data) {
                    const regression = this.generateRegression(data.x, data.y);

                    trace = [{
                        x: data.x,
                        y: data.y,
                        type: 'scatter',
                        mode: 'markers',
                        name: 'Data Points',
                        marker: { color: expr.color, size: 8 }
                    }];

                    if (regression) {
                        trace.push({
                            x: regression.x,
                            y: regression.y,
                            type: 'scatter',
                            mode: 'lines',
                            name: 'Regression Line',
                            line: { color: expr.color, width: 2, dash: 'dash' }
                        });
                    }

                    // Store stats for display
                    expr.stats = this.calculateStatistics(data.x, data.y);
                }
                break;
            }

            case 'distribution': {
                if (expr.distParams) {
                    const data = this.generateDistribution(
                        expr.distParams.type,
                        expr.distParams.params,
                        xMin,
                        xMax
                    );

                    if (data) {
                        trace = {
                            x: data.x,
                            y: data.y,
                            type: 'scatter',
                            mode: data.discrete ? 'markers+lines' : 'lines',
                            name: expr.expression || `${expr.distParams.type} distribution`,
                            line: { color: expr.color, width: 2 }
                        };

                        // Only add marker for discrete distributions
                        if (data.discrete) {
                            trace.marker = { color: expr.color, size: 8 };
                        }
                    }
                }
                break;
            }

            case 'equation': {
                // Use Nerdamer to solve an equation for y, then plot each branch
                if (typeof nerdamer === 'undefined') {
                    // Fallback to implicit contour if Nerdamer not loaded
                    const implData = this.generateImplicit(normalizedExpr, xMin, xMax, yMin, yMax);
                    if (implData) {
                        trace = {
                            x: implData.x, y: implData.y,
                            type: 'scatter', mode: implData.mode || 'lines',
                            name: expr.expression,
                            line: { color: expr.color, width: 2 },
                            connectgaps: false,
                            hovertemplate: 'x = %{x:.4f}<br>y = %{y:.4f}<extra>%{fullData.name}</extra>'
                        };
                    }
                    break;
                }
                trace = this.solveAndPlot(normalizedExpr, expr.color, xMin, xMax);
                // If Nerdamer failed, fall back to implicit contour (no auto SymPy — implicit is sufficient)
                if (!trace) {
                    const implData = this.generateImplicit(normalizedExpr, xMin, xMax, yMin, yMax);
                    if (implData) {
                        trace = {
                            x: implData.x, y: implData.y,
                            type: 'scatter', mode: implData.mode || 'lines',
                            name: expr.expression,
                            line: { color: expr.color, width: 2 },
                            connectgaps: false,
                            hovertemplate: 'x = %{x:.4f}<br>y = %{y:.4f}<extra>%{fullData.name}</extra>'
                        };
                    }
                    // Don't auto-fire SymPy — the implicit plot is visually correct.
                    // SymPy equation solving only triggers via explicit user action (Solve button).
                }
                break;
            }

            case 'limit': {
                // Plot f(x) and annotate the limit point
                const limitExpr = expr.limitExpr || expr.expression;
                if (!limitExpr) break;
                const limitVar = expr.limitVar || 'x';
                const limitVal = expr.limitVal != null ? expr.limitVal : 0;

                // Plot the function
                const normExpr = this.normalizeExpression(limitExpr);
                try {
                    const compiled = math.compile(normExpr);
                    const xs = [], ys = [];
                    const step = (xMax - xMin) / 500;
                    for (let i = 0; i <= 500; i++) {
                        const xv = xMin + i * step;
                        try {
                            const yv = compiled.evaluate({ x: xv });
                            if (typeof yv === 'number' && isFinite(yv)) { xs.push(xv); ys.push(yv); }
                            else { xs.push(xv); ys.push(null); }
                        } catch (_) { xs.push(xv); ys.push(null); }
                    }

                    trace = [{
                        x: xs, y: ys, type: 'scatter', mode: 'lines',
                        name: 'f(x) = ' + limitExpr,
                        line: { color: expr.color, width: 2 },
                        connectgaps: false
                    }];

                    // Evaluate the limit using Nerdamer (with SymPy fallback)
                    let limitResult = this.evaluateLimit(limitExpr, limitVar, limitVal);
                    if (!limitResult && !expr._sympyLimitResolved) {
                        expr._sympyLimitNeeded = { limitExpr, limitVar, limitVal, xMin, xMax, yMin, yMax };
                    }
                    // Use SymPy result if available
                    if (!limitResult && expr._sympyLimitResult) {
                        limitResult = expr._sympyLimitResult;
                        // Keep _sympyLimitResult so it persists across re-plots (pan/zoom)
                    }
                    if (limitResult && limitResult.numeric != null) {
                        const lx = parseFloat(limitVal);
                        const ly = limitResult.numeric;
                        // Add marker at the limit point
                        trace.push({
                            x: [lx], y: [ly], type: 'scatter', mode: 'markers+text',
                            name: `lim → ${limitResult.symbolic}`,
                            marker: { color: expr.color, size: 12, symbol: 'circle-open', line: { width: 3, color: expr.color } },
                            text: [`L = ${limitResult.symbolic}`],
                            textposition: 'top center',
                            textfont: { size: 13, color: expr.color },
                            showlegend: true
                        });
                        // Dashed horizontal line at y = L
                        trace.push({
                            x: [xMin, xMax], y: [ly, ly], type: 'scatter', mode: 'lines',
                            name: `y = ${limitResult.symbolic}`,
                            line: { color: expr.color, width: 1, dash: 'dash' },
                            showlegend: false
                        });
                        // Dashed vertical line at x = a
                        trace.push({
                            x: [lx, lx], y: [yMin, yMax], type: 'scatter', mode: 'lines',
                            name: `x = ${limitVal}`,
                            line: { color: '#94a3b8', width: 1, dash: 'dot' },
                            showlegend: false
                        });
                    }
                } catch (e) {
                    console.error('Limit plot error:', e);
                }
                break;
            }
        }

        return trace;
    }

    /**
     * Solve an equation for y using Nerdamer, return Plotly traces for each branch.
     */
    solveAndPlot(equation, color, xMin, xMax, numPoints = 400) {
        try {
            const parts = equation.split('=');
            if (parts.length !== 2) return null;
            const expr = '(' + parts[0].trim() + ')-(' + parts[1].trim() + ')';

            const ySolved = nerdamer.solve(expr, 'y');
            const yText = ySolved.text().replace(/^\[|\]$/g, '');
            if (!yText) return null;

            const yExprs = yText.split(',').map(s => s.trim()).filter(Boolean);
            const traces = [];

            for (let ve = 0; ve < yExprs.length; ve++) {
                const yExpr = yExprs[ve];
                const xs = [], ys = [];

                // Try Math.js first (100x faster than Nerdamer per-point)
                let compiled = null;
                try {
                    compiled = math.compile(this.normalizeExpression(yExpr));
                } catch (_) {
                    // Math.js can't parse — fall back to Nerdamer per-point
                }

                for (let j = 0; j <= numPoints; j++) {
                    const xv = xMin + (xMax - xMin) * j / numPoints;
                    try {
                        let yv;
                        if (compiled) {
                            yv = compiled.evaluate({ x: xv });
                        } else {
                            nerdamer.setVar('x', String(xv));
                            yv = parseFloat(nerdamer(yExpr).evaluate().text());
                            nerdamer.clearVars();
                        }
                        if (typeof yv === 'number' && isFinite(yv)) { xs.push(xv); ys.push(yv); }
                        else              { xs.push(null); ys.push(null); }
                    } catch (_) {
                        if (!compiled) nerdamer.clearVars();
                        xs.push(null); ys.push(null);
                    }
                }

                const branchSuffix = yExprs.length > 1 ? ` (branch ${ve + 1})` : '';
                traces.push({
                    x: xs, y: ys,
                    type: 'scatter', mode: 'lines',
                    name: equation + branchSuffix,
                    line: { color, width: 2 },
                    connectgaps: false
                });
            }

            return traces.length > 0 ? traces : null;
        } catch (e) {
            console.error('Nerdamer solve failed for:', equation, e);
            return null;
        }
    }

    /**
     * SymPy fallback for equation solving — solves for y and returns plot data.
     * Returns a Promise that resolves to array of Plotly traces or null.
     */
    solveAndPlotSymPy(equation, color, xMin, xMax, numPoints = 400) {
        const parts = equation.split('=');
        if (parts.length !== 2) return Promise.resolve(null);
        const lhs = GraphingEngine._toPython(parts[0].trim());
        const rhs = GraphingEngine._toPython(parts[1].trim());
        const step = (xMax - xMin) / numPoints;
        const code =
            'from sympy import *\n' +
            'import json, math\n' +
            'x, y = symbols("x y")\n' +
            'try:\n' +
            '    eq = (' + lhs + ')-(' + rhs + ')\n' +
            '    sols = solve(eq, y)\n' +
            '    if not sols:\n' +
            '        print("NOSOL")\n' +
            '    else:\n' +
            '        branches = []\n' +
            '        for s in sols:\n' +
            '            xs, ys = [], []\n' +
            '            for i in range(' + (numPoints + 1) + '):\n' +
            '                xv = ' + xMin + ' + i*' + step + '\n' +
            '                try:\n' +
            '                    yv = complex(s.subs(x, xv))\n' +
            '                    if abs(yv.imag) < 1e-10 and abs(yv.real) < 1e15:\n' +
            '                        xs.append(xv); ys.append(yv.real)\n' +
            '                    else:\n' +
            '                        xs.append(xv); ys.append(None)\n' +
            '                except:\n' +
            '                    xs.append(xv); ys.append(None)\n' +
            '            branches.append({"expr": str(s), "x": xs, "y": ys})\n' +
            '        print("EQSOL:" + json.dumps(branches))\n' +
            'except Exception as e:\n' +
            '    print("ERROR:" + str(e))';
        return this._sympyExec(code).then(stdout => {
            const m = stdout.match(/EQSOL:([\s\S]*)/);
            if (!m) return null;
            try {
                const branches = JSON.parse(m[1].trim());
                return branches.map((b, i) => ({
                    x: b.x, y: b.y,
                    type: 'scatter', mode: 'lines',
                    name: equation + (branches.length > 1 ? ` (branch ${i + 1})` : ''),
                    line: { color, width: 2 },
                    connectgaps: false
                }));
            } catch (e) { return null; }
        });
    }

    /**
     * SymPy fallback for symbolic derivative.
     * Returns a Promise that resolves to { x, y, symbolic } or null.
     */
    generateDerivativeSymPy(expression, xMin = -10, xMax = 10, numPoints = 500) {
        const pyExpr = GraphingEngine._toPython(this.stripCartesianPrefix(this.normalizeExpression(expression)));
        const code =
            'from sympy import *\n' +
            'import json\n' +
            'x = symbols("x")\n' +
            'try:\n' +
            '    expr = ' + pyExpr + '\n' +
            '    d = diff(expr, x)\n' +
            '    sym = str(d)\n' +
            '    xs = [' + xMin + ' + i*' + ((xMax - xMin) / numPoints) + ' for i in range(' + (numPoints + 1) + ')]\n' +
            '    ys = []\n' +
            '    for xv in xs:\n' +
            '        try:\n' +
            '            yv = float(d.subs(x, xv))\n' +
            '            ys.append(yv if abs(yv) < 1e15 else None)\n' +
            '        except: ys.append(None)\n' +
            '    print("DERIV:" + json.dumps({"symbolic": sym, "x": xs, "y": ys}))\n' +
            'except Exception as e:\n' +
            '    print("ERROR:" + str(e))';
        return this._sympyExec(code).then(stdout => {
            const m = stdout.match(/DERIV:([\s\S]*)/);
            if (!m) return null;
            try {
                const data = JSON.parse(m[1].trim());
                return { x: data.x, y: data.y, symbolic: data.symbolic };
            } catch (e) { return null; }
        });
    }

    /**
     * Plot all expressions
     */
    plot(settings = {}) {
        const {
            xMin = -10,
            xMax = 10,
            yMin = -10,
            yMax = 10,
            showGrid = true,
            showLegend = true
        } = settings;

        const traces = [];

        for (const expr of this.expressions) {
            if (!expr.visible) continue;

            // Use cached SymPy equation traces if already resolved
            if (expr._sympyResolved && expr._sympyTraces) {
                traces.push(...expr._sympyTraces);
                continue;
            }

            const trace = this.createTrace(expr, { xMin, xMax, yMin, yMax });

            if (trace) {
                if (Array.isArray(trace)) {
                    traces.push(...trace);
                } else {
                    traces.push(trace);
                }
            }

            // Inject cached SymPy antiderivative if resolved
            if (expr._sympyAntiResolved && expr._sympyAntiData) {
                const ad = expr._sympyAntiData;
                traces.push({
                    x: ad.x, y: ad.y,
                    type: 'scatter', mode: 'lines',
                    name: `F(x) = ∫${expr.expression} dx`,
                    line: { color: expr.color, width: 2, dash: 'dot' },
                    connectgaps: false
                });
            }
        }

        const dark = !!(typeof window !== 'undefined' && window.GC_DARK);
        const is3D = traces.some(t => t.type === 'surface');

        let layout;
        if (is3D) {
            layout = {
                margin: { t: 8, r: 8, b: 8, l: 8 },
                scene: {
                    xaxis: { title: 'x', showgrid: showGrid, gridcolor: dark ? '#374151' : '#e0e0e0', color: dark ? '#e5e7eb' : '#111827' },
                    yaxis: { title: 'y', showgrid: showGrid, gridcolor: dark ? '#374151' : '#e0e0e0', color: dark ? '#e5e7eb' : '#111827' },
                    zaxis: { title: 'z', showgrid: showGrid, gridcolor: dark ? '#374151' : '#e0e0e0', color: dark ? '#e5e7eb' : '#111827' },
                    bgcolor: dark ? '#0b1220' : '#fafafa'
                },
                showlegend: showLegend,
                paper_bgcolor: dark ? '#0b0f14' : 'white',
                font: { color: dark ? '#e5e7eb' : '#111827' }
            };
        } else {
            layout = {
                margin: { t: 8, r: 16, b: 32, l: 40 },
                xaxis: {
                    range: [xMin, xMax],
                    zeroline: true,
                    showgrid: showGrid,
                    gridcolor: dark ? '#374151' : '#e0e0e0',
                    color: dark ? '#e5e7eb' : '#111827'
                },
                yaxis: {
                    range: [yMin, yMax],
                    zeroline: true,
                    showgrid: showGrid,
                    gridcolor: dark ? '#374151' : '#e0e0e0',
                    color: dark ? '#e5e7eb' : '#111827',
                    scaleanchor: 'x'
                },
                showlegend: showLegend,
                legend: {
                    x: 1,
                    xanchor: 'right',
                    y: 1,
                    bgcolor: 'rgba(0,0,0,0)',
                    font: { size: 11, color: dark ? '#e5e7eb' : '#111827' }
                },
                hovermode: 'closest',
                plot_bgcolor: dark ? '#0b1220' : '#fafafa',
                paper_bgcolor: dark ? '#0b0f14' : 'white',
                font: { color: dark ? '#e5e7eb' : '#111827' }
            };
        }

        const config = {
            responsive: true,
            displayModeBar: true,
            modeBarButtonsToRemove: is3D ? [] : ['lasso2d', 'select2d'],
            displaylogo: false
        };

        // 3D surface needs full Plotly (not plotly-basic). Lazy-load if needed.
        if (is3D && typeof Plotly.newPlot === 'function' && !Plotly.register) {
            // plotly-basic doesn't have surface — check if it's available
            console.warn('3D surface requires full Plotly. Attempting to load...');
        }

        const graphDiv = document.getElementById(this.containerId);
        if (graphDiv && graphDiv.data) {
            Plotly.react(this.containerId, traces, layout, config);
        } else {
            Plotly.newPlot(this.containerId, traces, layout, config);
        }

        // Trigger draw-on animation for line traces
        if (this._animateNext) {
            this._animateNext = false;
            this._animateTraces(traces, layout, config);
        }

        // SymPy async fallback for expressions that Nerdamer couldn't handle
        this._runSympyFallbacks(settings);
    }

    /**
     * Run SymPy fallbacks for any expressions flagged with _sympyNeeded.
     * Each fallback resolves async, then re-triggers a plot to update traces.
     */
    _runSympyFallbacks(settings) {
        const { xMin = -10, xMax = 10, yMin = -10, yMax = 10 } = settings;
        const promises = [];
        let count = 0;

        for (const expr of this.expressions) {
            if (!expr.visible) continue;

            // Equation solving fallback
            if (expr._sympyNeeded === 'equation' && !expr._sympyInFlight) {
                delete expr._sympyNeeded;
                expr._sympyInFlight = true;
                count++;
                const eqExpr = expr;
                promises.push(this.solveAndPlotSymPy(expr.expression, expr.color, xMin, xMax).then(traces => {
                    eqExpr._sympyInFlight = false;
                    if (traces && traces.length > 0) {
                        eqExpr._sympyTraces = traces;
                        eqExpr._sympyResolved = true;
                    }
                }));
            }

            // Antiderivative fallback
            if (expr._sympyAntiNeeded && !expr._sympyAntiInFlight) {
                const { expression, xMin: aMin, xMax: aMax } = expr._sympyAntiNeeded;
                delete expr._sympyAntiNeeded;
                expr._sympyAntiInFlight = true;
                count++;
                const antiExpr = expr;
                promises.push(this.generateAntiderivativeSymPy(expression, aMin, aMax).then(data => {
                    antiExpr._sympyAntiInFlight = false;
                    if (data) {
                        antiExpr._sympyAntiData = data;
                        antiExpr._sympyAntiResolved = true;
                    }
                }));
            }

            // Limit fallback
            if (expr._sympyLimitNeeded && !expr._sympyLimitInFlight) {
                const { limitExpr, limitVar, limitVal } = expr._sympyLimitNeeded;
                delete expr._sympyLimitNeeded;
                expr._sympyLimitInFlight = true;
                count++;
                const limExpr = expr;
                promises.push(this.evaluateLimitSymPy(limitExpr, limitVar, limitVal).then(result => {
                    limExpr._sympyLimitInFlight = false;
                    if (result) {
                        limExpr._sympyLimitResult = result;
                        limExpr._sympyLimitResolved = true;
                    }
                }));
            }
        }

        if (count === 0) return;
        this._sympyPending += count;
        this._showSympyIndicator('Solving...');

        Promise.all(promises).then(() => {
            this._sympyPending -= count;
            if (this._sympyPending <= 0) {
                this._sympyPending = 0;
                this._hideSympyIndicator();
            }
            // Re-plot with SymPy results
            const hasResults = this.expressions.some(e => e._sympyResolved || e._sympyAntiResolved || e._sympyLimitResolved);
            if (hasResults) {
                this._replotWithSymPy(settings);
            }
        });
    }

    /**
     * Re-plot incorporating SymPy-resolved traces.
     * For equation types, replaces the whole trace set.
     * For antiderivative/limit, adds to the existing createTrace output.
     */
    _replotWithSymPy(settings) {
        const { xMin = -10, xMax = 10, yMin = -10, yMax = 10, showGrid = true, showLegend = true } = settings;
        const traces = [];

        for (const expr of this.expressions) {
            if (!expr.visible) continue;

            // Use SymPy-resolved equation traces (keep data for future re-plots)
            if (expr._sympyResolved && expr._sympyTraces) {
                traces.push(...expr._sympyTraces);
                continue;
            }

            const trace = this.createTrace(expr, { xMin, xMax, yMin, yMax });
            if (trace) {
                if (Array.isArray(trace)) traces.push(...trace);
                else traces.push(trace);
            }

            // Inject SymPy antiderivative data as additional trace (keep data for future re-plots)
            if (expr._sympyAntiResolved && expr._sympyAntiData) {
                const ad = expr._sympyAntiData;
                traces.push({
                    x: ad.x, y: ad.y,
                    type: 'scatter', mode: 'lines',
                    name: `F(x) = ∫${expr.expression} dx`,
                    line: { color: expr.color, width: 2, dash: 'dot' },
                    connectgaps: false
                });
            }
        }

        const dark = !!(typeof window !== 'undefined' && window.GC_DARK);
        const layout = {
            margin: { t: 8, r: 16, b: 32, l: 40 },
            xaxis: { range: [xMin, xMax], zeroline: true, showgrid: showGrid, gridcolor: dark ? '#374151' : '#e0e0e0', color: dark ? '#e5e7eb' : '#111827' },
            yaxis: { range: [yMin, yMax], zeroline: true, showgrid: showGrid, gridcolor: dark ? '#374151' : '#e0e0e0', color: dark ? '#e5e7eb' : '#111827', scaleanchor: 'x' },
            showlegend: showLegend,
            legend: { x: 1, xanchor: 'right', y: 1, bgcolor: 'rgba(0,0,0,0)', font: { size: 11, color: dark ? '#e5e7eb' : '#111827' } },
            hovermode: 'closest',
            plot_bgcolor: dark ? '#0b1220' : '#fafafa',
            paper_bgcolor: dark ? '#0b0f14' : 'white',
            font: { color: dark ? '#e5e7eb' : '#111827' }
        };
        const config = { responsive: true, displayModeBar: true, modeBarButtonsToRemove: ['lasso2d', 'select2d'], displaylogo: false };
        Plotly.react(this.containerId, traces, layout, config);
    }

    /**
     * Animate traces drawing on progressively (curve draw-on effect)
     */
    _animateTraces(fullTraces, layout, config) {
        const lineTraces = [];
        const staticTraces = [];

        fullTraces.forEach((t, i) => {
            if ((t.mode === 'lines' || t.mode === 'markers') && t.x && t.x.length > 10) {
                lineTraces.push({ index: i, trace: t });
            } else {
                staticTraces.push({ index: i, trace: t });
            }
        });

        if (lineTraces.length === 0) return;

        const totalFrames = 60;
        let frame = 0;
        const containerId = this.containerId;

        // Start with empty line traces + all static traces
        const initialTraces = fullTraces.map((t, i) => {
            const lt = lineTraces.find(l => l.index === i);
            if (lt) {
                return Object.assign({}, t, { x: [], y: [] });
            }
            return t;
        });

        Plotly.react(containerId, initialTraces, layout, config);

        const step = () => {
            frame++;
            const progress = frame / totalFrames;
            // Ease-out cubic for smooth deceleration
            const eased = 1 - Math.pow(1 - progress, 3);

            const updatedTraces = fullTraces.map((t, i) => {
                const lt = lineTraces.find(l => l.index === i);
                if (lt) {
                    const len = Math.floor(eased * t.x.length);
                    return Object.assign({}, t, {
                        x: t.x.slice(0, len),
                        y: t.y.slice(0, len)
                    });
                }
                return t;
            });

            Plotly.react(containerId, updatedTraces, layout, config);

            if (frame < totalFrames) {
                requestAnimationFrame(step);
            }
        };

        requestAnimationFrame(step);
    }
}

// Global state
let engine;
let expressionElements = {};
let animationState = {
    isPlaying: false,
    animationId: null,
    paramName: null,
    exprId: null,
    currentValue: -10,
    speed: 0.1
};
let traceModeActive = false;

/**
 * Initialize the graphing engine
 */
function initGraph() {
    if (typeof math === 'undefined') {
        console.error('Math.js not loaded!');
        return;
    }

    if (typeof Plotly === 'undefined') {
        console.error('Plotly.js not loaded!');
        return;
    }

    engine = new GraphingEngine('graph');

    // Prevent sample chip buttons from stealing focus (fixes :focus-within timing)
    const exprList = document.getElementById('expressions-list');
    if (exprList) {
        exprList.addEventListener('mousedown', function(e) {
            if (e.target.closest('.gc-sample-chips')) {
                e.preventDefault();
            }
        });
    }

    // Try to load from URL first
    loadFromURL();

    // If nothing loaded from URL, add default expression
    if (engine.expressions.length === 0) {
        addExpression();
    }

    // Update graph
    updateGraph();

    // Auto-focus the first expression input
    const firstInput = document.querySelector('.expression-input');
    if (firstInput) firstInput.focus();
}

/**
 * Add a new expression input
 */
function addExpression() {
    const expr = engine.addExpression('', 'cartesian');
    createExpressionElement(expr);
}

/**
 * Create UI element for an expression
 */
function createExpressionElement(expr) {
    const container = document.getElementById('expressions-list');

    const div = document.createElement('div');
    div.className = 'expression-item';
    div.id = `expr-item-${expr.id}`;  // Changed to avoid ID conflict

    div.innerHTML = `
        <button class="delete-btn" onclick="deleteExpression(${expr.id})">
            <i class="fas fa-times"></i>
        </button>

        <div id="input-container-${expr.id}"></div>

        <div class="gc-expr-toolbar">
            <input type="color" class="color-picker" id="color-${expr.id}"
                   value="${expr.color}" onchange="updateExpressionColor(${expr.id})">
            <select class="plot-type-select" id="type-${expr.id}" onchange="updateExpressionType(${expr.id})">
                <option value="cartesian">y = f(x)</option>
                <option value="equation">Equation</option>
                <option value="parametric">Parametric</option>
                <option value="polar">Polar</option>
                <option value="inequality">Inequality</option>
                <option value="limit">Limit</option>
                <option value="piecewise">Piecewise</option>
                <option value="implicit">Implicit</option>
                <option value="surface">3D Surface</option>
                <option value="table">Table</option>
                <option value="statistics">Regression</option>
                <option value="distribution">Distribution</option>
            </select>
            <span id="calculus-toggles-${expr.id}" class="gc-calculus-toggles">
                <label class="gc-toggle-label"><input class="form-check-input" type="checkbox" id="show-derivative-${expr.id}" onchange="toggleDerivative(${expr.id})"> f'(x)</label>
                <label class="gc-toggle-label"><input class="form-check-input" type="checkbox" id="show-integration-${expr.id}" onchange="toggleIntegration(${expr.id})"> ∫</label>
                <label class="gc-toggle-label"><input class="form-check-input" type="checkbox" id="show-antiderivative-${expr.id}" onchange="toggleAntiderivative(${expr.id})"> F(x)</label>
            </span>
        </div>
        <div id="integration-controls-${expr.id}" style="display: none;" class="mt-1">
            <div class="d-flex gap-2 align-items-center flex-wrap">
                <small class="text-muted">∫ from</small>
                <input type="number" class="form-control form-control-sm" id="integration-a-${expr.id}" placeholder="a" value="-2" step="0.5" style="width:65px;" oninput="updateIntegrationBounds(${expr.id})">
                <small class="text-muted">to</small>
                <input type="number" class="form-control form-control-sm" id="integration-b-${expr.id}" placeholder="b" value="2" step="0.5" style="width:65px;" oninput="updateIntegrationBounds(${expr.id})">
            </div>
            <div class="d-flex gap-2 align-items-center flex-wrap mt-1">
                <small class="text-muted">Riemann</small>
                <select class="form-select form-select-sm" id="riemann-method-${expr.id}" style="width:auto;" onchange="updateRiemannMethod(${expr.id})">
                    <option value="none">None</option>
                    <option value="left">Left</option>
                    <option value="midpoint">Midpoint</option>
                    <option value="right">Right</option>
                    <option value="trapezoidal">Trapezoidal</option>
                </select>
                <small class="text-muted">n=</small>
                <input type="number" class="form-control form-control-sm" id="riemann-n-${expr.id}" value="10" min="1" max="500" step="1" style="width:60px;" oninput="updateRiemannN(${expr.id})">
            </div>
        </div>
        <div id="sliders-container-${expr.id}"></div>
    `;

    container.appendChild(div);
    expressionElements[expr.id] = div;

    const exprType = expr.type || 'cartesian';
    createInputForType(expr.id, exprType);

    // Hide calculus toggles for non-cartesian types
    if (exprType !== 'cartesian') {
        const calcToggles = document.getElementById(`calculus-toggles-${expr.id}`);
        if (calcToggles) calcToggles.style.display = 'none';
    }
}

/**
 * Create input field based on type
 */
function createInputForType(id, type) {
    const container = document.getElementById(`input-container-${id}`);

    // Get current expression value if it exists
    const expr = engine.expressions.find(e => e.id === id);
    const currentValue = expr && expr.expression ? expr.expression : '';

    container.innerHTML = '';

    switch (type) {
        case 'cartesian':
            container.innerHTML = `
                <input type="text" class="expression-input" id="expr-${id}"
                       placeholder="Type expression: x^2, sin(x), 2x+3y=8 ..." value="${currentValue}"
                       oninput="updateExpressionValue(${id})"
                       onchange="updateExpressionValue(${id})">
                <div class="math-preview" id="math-preview-${id}"></div>
                <div class="gc-sample-chips gc-on-focus">
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'sin(x)')">sin</button>
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'cos(x)')">cos</button>
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'x^2')">x²</button>
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'x^3 - 3*x^2 + 2*x')">cubic</button>
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'exp(x)')">eˣ</button>
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'log(x)')">ln</button>
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'sqrt(x)')">√x</button>
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, '1/(1+exp(-x))')">sigmoid</button>
                </div>
            `;
            break;

        case 'equation':
            container.innerHTML = `
                <input type="text" class="expression-input" id="expr-${id}"
                       placeholder="e.g., 2x + 3y = 8 or x^2 + y^2 = 25" value="${currentValue}"
                       oninput="updateExpressionValue(${id})"
                       onchange="updateExpressionValue(${id})">
                <small class="text-muted">Any equation — solved symbolically</small>
                <div class="gc-sample-chips gc-on-focus">
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, '2x + 3y = 8')">2x+3y=8</button>
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'x^2 + y^2 = 25')">Circle</button>
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'x^2/4 + y^2/9 = 1')">Ellipse</button>
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'x^2 - y^2 = 1')">Hyperbola</button>
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'x*y = 4')">xy=4</button>
                </div>
            `;
            break;

        case 'limit':
            container.innerHTML = `
                <input type="text" class="expression-input" id="expr-${id}"
                       placeholder="e.g., sin(x)/x" value="${currentValue}"
                       oninput="updateLimitExpression(${id})"
                       onchange="updateLimitExpression(${id})">
                <div class="d-flex gap-2 mt-1 align-items-center" style="font-size:0.8rem;">
                    <span style="color:var(--gc-tool);font-weight:600;">lim</span>
                    <span class="text-muted">x →</span>
                    <input type="text" class="form-control form-control-sm" id="limit-val-${id}"
                           placeholder="0" value="0" style="width: 60px; text-align:center;"
                           oninput="updateLimitExpression(${id})"
                           onchange="updateLimitExpression(${id})">
                    <span style="color:var(--gc-tool);font-weight:600;">=</span>
                    <span id="limit-result-${id}" style="color:var(--gc-tool);font-weight:700;">?</span>
                </div>
                <div class="gc-sample-chips gc-on-focus">
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadLimitSample(${id}, 'sin(x)/x', '0')">sin(x)/x</button>
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadLimitSample(${id}, '(exp(x)-1)/x', '0')">(eˣ-1)/x</button>
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadLimitSample(${id}, '(1+1/x)^x', 'Infinity')">(1+1/x)ˣ→∞</button>
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadLimitSample(${id}, '(x^2-1)/(x-1)', '1')">(x²-1)/(x-1)</button>
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadLimitSample(${id}, 'tan(x)/x', '0')">tan(x)/x</button>
                </div>
            `;
            break;

        case 'parametric':
            container.innerHTML = `
                <input type="text" class="expression-input" id="expr-${id}"
                       placeholder="e.g., cos(t), sin(t)" value="${currentValue}"
                       oninput="updateExpressionValue(${id})"
                       onchange="updateExpressionValue(${id})">
                <small class="text-muted">Format: x(t), y(t)</small>
                <div class="d-flex align-items-center gap-2 mt-2">
                    <small class="text-muted">t:</small>
                    <input type="number" class="form-control form-control-sm" id="tmin-${id}" value="0" step="0.1"
                           style="width:70px" onchange="updateParamRange(${id})">
                    <small class="text-muted">to</small>
                    <input type="number" class="form-control form-control-sm" id="tmax-${id}" value="${(2*Math.PI).toFixed(4)}" step="0.1"
                           style="width:70px" onchange="updateParamRange(${id})">
                </div>
                <div class="mt-2">
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'cos(t), sin(t)')">Circle</button>
                    <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadSample(${id}, 't*cos(t), t*sin(t)')">Spiral</button>
                    <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadParamSample(${id}, 't, t^2', -5, 5)">Parabola</button>
                </div>
            `;
            break;

        case 'polar':
            container.innerHTML = `
                <input type="text" class="expression-input" id="expr-${id}"
                       placeholder="e.g., 2 + 2*cos(theta)" value="${currentValue}"
                       oninput="updateExpressionValue(${id})"
                       onchange="updateExpressionValue(${id})">
                <small class="text-muted">Use theta or θ</small>
                <div class="d-flex align-items-center gap-2 mt-2">
                    <small class="text-muted">θ:</small>
                    <input type="number" class="form-control form-control-sm" id="thetamin-${id}" value="0" step="0.1"
                           style="width:70px" onchange="updatePolarRange(${id})">
                    <small class="text-muted">to</small>
                    <input type="number" class="form-control form-control-sm" id="thetamax-${id}" value="${(2*Math.PI).toFixed(4)}" step="0.1"
                           style="width:70px" onchange="updatePolarRange(${id})">
                </div>
                <div class="mt-2">
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, '2 + 2*cos(theta)')">Heart</button>
                    <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadSample(${id}, '1 + cos(theta)')">Cardioid</button>
                    <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadPolarSample(${id}, 'theta', 0, 25.13)">Spiral 4π</button>
                </div>
            `;
            break;

        case 'implicit':
            container.innerHTML = `
                <input type="text" class="expression-input" id="expr-${id}"
                       placeholder="e.g., x^2 + y^2 = 25" value="${currentValue}"
                       oninput="updateExpressionValue(${id})"
                       onchange="updateExpressionValue(${id})">
                <small class="text-muted">Implicit equation in x and y</small>
                <div class="mt-2">
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'x^2 + y^2 = 25')">Circle</button>
                    <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadSample(${id}, 'x^2/16 + y^2/9 = 1')">Ellipse</button>
                    <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadSample(${id}, '(x^2 + y^2 - 1)^3 = x^2*y^3')">Heart</button>
                    <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadSample(${id}, 'x^2 - y^2 = 1')">Hyperbola</button>
                </div>
            `;
            break;

        case 'surface':
            container.innerHTML = `
                <input type="text" class="expression-input" id="expr-${id}"
                       placeholder="e.g., sin(sqrt(x^2 + y^2))" value="${currentValue}"
                       oninput="updateExpressionValue(${id})"
                       onchange="updateExpressionValue(${id})">
                <small class="text-muted">z = f(x, y) — 3D surface plot</small>
                <div class="mt-2">
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'sin(sqrt(x^2 + y^2))')">Ripple</button>
                    <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadSample(${id}, 'x^2 - y^2')">Saddle</button>
                    <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadSample(${id}, 'cos(x) * sin(y)')">Waves</button>
                    <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadSample(${id}, 'exp(-(x^2 + y^2))')">Gaussian</button>
                </div>
            `;
            break;

        case 'piecewise':
            container.innerHTML = `
                <div id="piecewise-pieces-${id}">
                    <div class="mb-2 p-2" style="background: #f8f9fa; border-radius: 4px;">
                        <small class="text-muted"><strong>Piece 1:</strong></small>
                        <input type="text" class="form-control form-control-sm mb-1" id="piece-expr-${id}-0"
                               placeholder="Expression (e.g., x^2)" value="x^2" oninput="updatePiecewise(${id})">
                        <input type="text" class="form-control form-control-sm" id="piece-cond-${id}-0"
                               placeholder="Condition (e.g., x < 0)" value="x < 0" oninput="updatePiecewise(${id})">
                    </div>
                    <div class="mb-2 p-2" style="background: #f8f9fa; border-radius: 4px;">
                        <small class="text-muted"><strong>Piece 2:</strong></small>
                        <input type="text" class="form-control form-control-sm mb-1" id="piece-expr-${id}-1"
                               placeholder="Expression (e.g., sin(x))" value="sin(x)" oninput="updatePiecewise(${id})">
                        <input type="text" class="form-control form-control-sm" id="piece-cond-${id}-1"
                               placeholder="Condition (e.g., x >= 0)" value="x >= 0" oninput="updatePiecewise(${id})">
                    </div>
                </div>
                <button class="btn btn-sm btn-outline-primary mt-1" onclick="addPiecewisePiece(${id})">
                    <i class="fas fa-plus"></i> Add Piece
                </button>
                <div class="mt-2">
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadPiecewiseSample(${id}, 'abs')">|x|</button>
                    <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadPiecewiseSample(${id}, 'step')">Step</button>
                    <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadPiecewiseSample(${id}, 'sawtooth')">Sawtooth</button>
                </div>
            `;
            // Initialize piecewise data
            updatePiecewise(id);
            break;

        case 'inequality':
            container.innerHTML = `
                <input type="text" class="expression-input" id="expr-${id}"
                       placeholder="e.g., y > x^2" value="${currentValue}"
                       oninput="updateExpressionValue(${id})"
                       onchange="updateExpressionValue(${id})">
                <div class="mt-2">
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'y > x^2')">Parabola</button>
                    <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadSample(${id}, 'y < sin(x)')">Sine Wave</button>
                </div>
            `;
            break;

        case 'table':
            container.innerHTML = `
                <textarea class="table-input form-control" id="expr-${id}" rows="4"
                          placeholder="Enter x,y pairs (one per line):&#10;1, 2&#10;2, 4&#10;3, 9"
                          oninput="updateExpressionValue(${id})"
                          onchange="updateExpressionValue(${id})">${currentValue}</textarea>
                <div class="mt-2">
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadTableSample(${id}, 'random')">Random Data</button>
                    <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadTableSample(${id}, 'linear')">Linear Data</button>
                </div>
            `;
            break;

        case 'statistics':
            container.innerHTML = `
                <textarea class="table-input form-control" id="expr-${id}" rows="4"
                          placeholder="Enter x,y pairs for regression:&#10;1, 2&#10;2, 4&#10;3, 9"
                          oninput="updateExpressionValue(${id})"
                          onchange="updateExpressionValue(${id})">${currentValue}</textarea>
                <div class="mt-2">
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadTableSample(${id}, 'regression')">Sample Data</button>
                    <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadTableSample(${id}, 'exponential')">Exponential</button>
                </div>
                <div id="stats-${id}" class="stats-output" style="display:none;"></div>
            `;
            break;

        case 'distribution':
            container.innerHTML = `
                <select class="form-select form-select-sm mb-2" id="dist-type-${id}" onchange="updateDistributionType(${id})">
                    <option value="normal">Normal (Gaussian)</option>
                    <option value="chi2">Chi-Squared (χ²)</option>
                    <option value="uniform">Uniform</option>
                    <option value="exponential">Exponential</option>
                    <option value="binomial">Binomial</option>
                    <option value="poisson">Poisson</option>
                    <option value="t">Student's t</option>
                    <option value="beta">Beta</option>
                    <option value="gamma">Gamma</option>
                </select>
                <div id="dist-params-${id}"></div>
            `;
            updateDistributionType(id);
            break;
    }
}

/**
 * Update distribution type and show appropriate parameter inputs
 */
function updateDistributionType(id) {
    const distType = document.getElementById(`dist-type-${id}`).value;
    const paramsContainer = document.getElementById(`dist-params-${id}`);

    let paramsHTML = '';

    switch (distType) {
        case 'normal':
            paramsHTML = `
                <div class="mb-2">
                    <label class="form-label" style="font-size: 12px;">Mean (μ)</label>
                    <input type="number" class="form-control form-control-sm" id="param-mean-${id}" value="0" step="0.1" oninput="updateDistributionParams(${id})" onchange="updateDistributionParams(${id})">
                </div>
                <div class="mb-2">
                    <label class="form-label" style="font-size: 12px;">Std Dev (σ)</label>
                    <input type="number" class="form-control form-control-sm" id="param-stdDev-${id}" value="1" step="0.1" min="0.01" oninput="updateDistributionParams(${id})" onchange="updateDistributionParams(${id})">
                </div>
            `;
            break;

        case 'chi2':
            paramsHTML = `
                <div class="mb-2">
                    <label class="form-label" style="font-size: 12px;">Degrees of Freedom (k)</label>
                    <input type="number" class="form-control form-control-sm" id="param-k-${id}" value="3" step="1" min="1" oninput="updateDistributionParams(${id})" onchange="updateDistributionParams(${id})">
                </div>
            `;
            break;

        case 'uniform':
            paramsHTML = `
                <div class="mb-2">
                    <label class="form-label" style="font-size: 12px;">Min (a)</label>
                    <input type="number" class="form-control form-control-sm" id="param-a-${id}" value="0" step="0.1" oninput="updateDistributionParams(${id})" onchange="updateDistributionParams(${id})">
                </div>
                <div class="mb-2">
                    <label class="form-label" style="font-size: 12px;">Max (b)</label>
                    <input type="number" class="form-control form-control-sm" id="param-b-${id}" value="1" step="0.1" oninput="updateDistributionParams(${id})" onchange="updateDistributionParams(${id})">
                </div>
            `;
            break;

        case 'exponential':
            paramsHTML = `
                <div class="mb-2">
                    <label class="form-label" style="font-size: 12px;">Rate (λ)</label>
                    <input type="number" class="form-control form-control-sm" id="param-lambda-${id}" value="1" step="0.1" min="0.01" oninput="updateDistributionParams(${id})" onchange="updateDistributionParams(${id})">
                </div>
            `;
            break;

        case 'binomial':
            paramsHTML = `
                <div class="mb-2">
                    <label class="form-label" style="font-size: 12px;">Trials (n)</label>
                    <input type="number" class="form-control form-control-sm" id="param-n-${id}" value="10" step="1" min="1" oninput="updateDistributionParams(${id})" onchange="updateDistributionParams(${id})">
                </div>
                <div class="mb-2">
                    <label class="form-label" style="font-size: 12px;">Probability (p)</label>
                    <input type="number" class="form-control form-control-sm" id="param-p-${id}" value="0.5" step="0.01" min="0" max="1" oninput="updateDistributionParams(${id})" onchange="updateDistributionParams(${id})">
                </div>
            `;
            break;

        case 'poisson':
            paramsHTML = `
                <div class="mb-2">
                    <label class="form-label" style="font-size: 12px;">Rate (λ)</label>
                    <input type="number" class="form-control form-control-sm" id="param-lambda-${id}" value="3" step="0.1" min="0.01" oninput="updateDistributionParams(${id})" onchange="updateDistributionParams(${id})">
                </div>
            `;
            break;

        case 't':
            paramsHTML = `
                <div class="mb-2">
                    <label class="form-label" style="font-size: 12px;">Degrees of Freedom (df)</label>
                    <input type="number" class="form-control form-control-sm" id="param-df-${id}" value="5" step="1" min="1" oninput="updateDistributionParams(${id})" onchange="updateDistributionParams(${id})">
                </div>
            `;
            break;

        case 'beta':
            paramsHTML = `
                <div class="mb-2">
                    <label class="form-label" style="font-size: 12px;">Alpha (α)</label>
                    <input type="number" class="form-control form-control-sm" id="param-alpha-${id}" value="2" step="0.1" min="0.01" oninput="updateDistributionParams(${id})" onchange="updateDistributionParams(${id})">
                </div>
                <div class="mb-2">
                    <label class="form-label" style="font-size: 12px;">Beta (β)</label>
                    <input type="number" class="form-control form-control-sm" id="param-beta-${id}" value="2" step="0.1" min="0.01" oninput="updateDistributionParams(${id})" onchange="updateDistributionParams(${id})">
                </div>
            `;
            break;

        case 'gamma':
            paramsHTML = `
                <div class="mb-2">
                    <label class="form-label" style="font-size: 12px;">Shape (k)</label>
                    <input type="number" class="form-control form-control-sm" id="param-shape-${id}" value="2" step="0.1" min="0.01" oninput="updateDistributionParams(${id})" onchange="updateDistributionParams(${id})">
                </div>
                <div class="mb-2">
                    <label class="form-label" style="font-size: 12px;">Scale (θ)</label>
                    <input type="number" class="form-control form-control-sm" id="param-scale-${id}" value="2" step="0.1" min="0.01" oninput="updateDistributionParams(${id})" onchange="updateDistributionParams(${id})">
                </div>
            `;
            break;
    }

    paramsContainer.innerHTML = paramsHTML;
    updateDistributionParams(id);
}

/**
 * Update distribution parameters and refresh graph
 */
function updateDistributionParams(id) {
    const distTypeElement = document.getElementById(`dist-type-${id}`);

    if (!distTypeElement) {
        console.error('Distribution type element not found for id:', id);
        return;
    }

    const distType = distTypeElement.value;
    const params = {};

    switch (distType) {
        case 'normal':
            params.mean = parseFloat(document.getElementById(`param-mean-${id}`).value);
            params.stdDev = parseFloat(document.getElementById(`param-stdDev-${id}`).value);
            break;
        case 'chi2':
            params.k = parseInt(document.getElementById(`param-k-${id}`).value);
            break;
        case 'uniform':
            params.a = parseFloat(document.getElementById(`param-a-${id}`).value);
            params.b = parseFloat(document.getElementById(`param-b-${id}`).value);
            break;
        case 'exponential':
            params.lambda = parseFloat(document.getElementById(`param-lambda-${id}`).value);
            break;
        case 'binomial':
            params.n = parseInt(document.getElementById(`param-n-${id}`).value);
            params.p = parseFloat(document.getElementById(`param-p-${id}`).value);
            break;
        case 'poisson':
            params.lambda = parseFloat(document.getElementById(`param-lambda-${id}`).value);
            break;
        case 't':
            params.df = parseInt(document.getElementById(`param-df-${id}`).value);
            break;
        case 'beta':
            params.alpha = parseFloat(document.getElementById(`param-alpha-${id}`).value);
            params.beta = parseFloat(document.getElementById(`param-beta-${id}`).value);
            break;
        case 'gamma':
            params.shape = parseFloat(document.getElementById(`param-shape-${id}`).value);
            params.scale = parseFloat(document.getElementById(`param-scale-${id}`).value);
            break;
    }

    engine.updateExpression(id, {
        distParams: { type: distType, params },
        expression: `${distType} distribution`
    });

    updateGraph();
}

/**
 * Load sample data/expression
 */
function loadSample(id, value) {
    const element = document.getElementById(`expr-${id}`);
    if (element) {
        element.value = value;
        updateExpressionValue(id);
    }
}

/** Update parametric t range from UI inputs */
function updateParamRange(id) {
    const expr = engine.expressions.find(e => e.id === id);
    if (!expr) return;
    const tMinEl = document.getElementById(`tmin-${id}`);
    const tMaxEl = document.getElementById(`tmax-${id}`);
    if (tMinEl) expr.tMin = parseFloat(tMinEl.value);
    if (tMaxEl) expr.tMax = parseFloat(tMaxEl.value);
    updateGraph();
}

/** Update polar θ range from UI inputs */
function updatePolarRange(id) {
    const expr = engine.expressions.find(e => e.id === id);
    if (!expr) return;
    const tMinEl = document.getElementById(`thetamin-${id}`);
    const tMaxEl = document.getElementById(`thetamax-${id}`);
    if (tMinEl) expr.thetaMin = parseFloat(tMinEl.value);
    if (tMaxEl) expr.thetaMax = parseFloat(tMaxEl.value);
    updateGraph();
}

/** Load parametric sample with custom t range */
function loadParamSample(id, value, tMin, tMax) {
    const element = document.getElementById(`expr-${id}`);
    if (element) element.value = value;
    const tMinEl = document.getElementById(`tmin-${id}`);
    const tMaxEl = document.getElementById(`tmax-${id}`);
    if (tMinEl) tMinEl.value = tMin;
    if (tMaxEl) tMaxEl.value = tMax;
    const expr = engine.expressions.find(e => e.id === id);
    if (expr) { expr.tMin = tMin; expr.tMax = tMax; }
    updateExpressionValue(id);
}

/** Load polar sample with custom θ range */
function loadPolarSample(id, value, thetaMin, thetaMax) {
    const element = document.getElementById(`expr-${id}`);
    if (element) element.value = value;
    const tMinEl = document.getElementById(`thetamin-${id}`);
    const tMaxEl = document.getElementById(`thetamax-${id}`);
    if (tMinEl) tMinEl.value = thetaMin;
    if (tMaxEl) tMaxEl.value = thetaMax;
    const expr = engine.expressions.find(e => e.id === id);
    if (expr) { expr.thetaMin = thetaMin; expr.thetaMax = thetaMax; }
    updateExpressionValue(id);
}

/**
 * Load sample table data
 */
function loadTableSample(id, type) {
    const element = document.getElementById(`expr-${id}`);
    if (!element) return;

    let sampleData = '';

    switch (type) {
        case 'random':
            // Random scattered data
            for (let i = 1; i <= 10; i++) {
                const x = i;
                const y = Math.round((2 * i + Math.random() * 5) * 10) / 10;
                sampleData += `${x}, ${y}\n`;
            }
            break;

        case 'linear':
            // Perfect linear relationship
            for (let i = 1; i <= 8; i++) {
                sampleData += `${i}, ${i * 2 + 1}\n`;
            }
            break;

        case 'regression':
            // Data with clear linear trend
            sampleData = `1, 2.3
2, 4.1
3, 5.8
4, 7.9
5, 10.2
6, 11.8
7, 14.1
8, 15.9
9, 18.2
10, 20.1`;
            break;

        case 'exponential':
            // Exponential growth pattern
            for (let i = 0; i <= 6; i++) {
                const x = i;
                const y = Math.round(Math.exp(i * 0.5) * 10) / 10;
                sampleData += `${x}, ${y}\n`;
            }
            break;
    }

    element.value = sampleData.trim();
    updateExpressionValue(id);
}

/**
 * Update expression type
 */
function updateExpressionType(id) {
    const type = document.getElementById(`type-${id}`).value;
    engine.updateExpression(id, { type });
    createInputForType(id, type);
    // Show calculus toggles only for cartesian type
    const calcToggles = document.getElementById(`calculus-toggles-${id}`);
    if (calcToggles) calcToggles.style.display = (type === 'cartesian') ? '' : 'none';
    // Show/hide integration controls
    const intControls = document.getElementById(`integration-controls-${id}`);
    if (intControls && type !== 'cartesian') intControls.style.display = 'none';
    // Lazy-load full Plotly for 3D surface
    if (type === 'surface') _ensureFullPlotly(updateGraph);
    else updateGraph();
}

/** Lazy-load full Plotly.js (with gl3d) when 3D surface is needed */
var _fullPlotlyLoaded = false;
function _ensureFullPlotly(cb) {
    if (_fullPlotlyLoaded) { if (cb) cb(); return; }
    // Check if current Plotly already supports surface (full bundle)
    if (typeof Plotly !== 'undefined' && Plotly.PlotSchema && Plotly.PlotSchema.get) {
        try {
            const schema = Plotly.PlotSchema.get();
            if (schema.traces && schema.traces.surface) {
                _fullPlotlyLoaded = true; if (cb) cb(); return;
            }
        } catch(_) {}
    }
    // Load full Plotly
    const script = document.createElement('script');
    script.src = 'https://cdn.plot.ly/plotly-2.27.0.min.js';
    script.onload = function() { _fullPlotlyLoaded = true; if (cb) cb(); };
    script.onerror = function() {
        console.error('Failed to load full Plotly for 3D');
        if (cb) cb();
    };
    document.head.appendChild(script);
}

/**
 * Convert math expression to LaTeX for KaTeX rendering using Math.js
 */
function convertToLaTeX(expression) {
    if (!expression || expression.trim() === '') {
        return '';
    }

    try {
        // Parse the expression using Math.js
        const node = math.parse(expression);

        // Convert to LaTeX using Math.js built-in function
        let latex = node.toTex();

        // Additional formatting improvements
        // Replace cdot with a nicer multiplication symbol
        latex = latex.replace(/\\cdot/g, '\\cdot');

        // Convert common constants
        latex = latex.replace(/\\mathrm\{pi\}/g, '\\pi');
        latex = latex.replace(/\\mathrm\{e\}/g, 'e');

        return latex;
    } catch (error) {
        // Fallback: if parsing fails, do basic conversion
        let latex = expression;

        // Basic conversions
        latex = latex.replace(/\^/g, '^');
        latex = latex.replace(/\*/g, ' \\cdot ');
        latex = latex.replace(/sqrt/g, '\\sqrt');
        latex = latex.replace(/pi/g, '\\pi');
        latex = latex.replace(/theta/g, '\\theta');

        // Common functions
        const funcs = ['sin', 'cos', 'tan', 'log', 'ln', 'exp'];
        funcs.forEach(func => {
            const regex = new RegExp('\\b' + func + '\\b', 'g');
            latex = latex.replace(regex, '\\' + func);
        });

        return latex;
    }
}

/**
 * Render math preview using KaTeX
 */
function renderMathPreview(id, expression) {
    const previewElement = document.getElementById(`math-preview-${id}`);

    if (!previewElement) {
        return;
    }

    if (!expression || expression.trim() === '') {
        previewElement.innerHTML = '';
        return;
    }

    try {
        const latex = convertToLaTeX(expression);
        // Only prepend "y = " for simple f(x) expressions (no = sign already)
        const prefix = expression.includes('=') ? '' : 'y = ';
        katex.render(prefix + latex, previewElement, {
            throwOnError: false,
            displayMode: true
        });
    } catch (error) {
        previewElement.innerHTML = `<span style="color: #666;">${expression}</span>`;
    }
}

/**
 * Auto-detect whether an expression should be cartesian, implicit, or inequality.
 * Returns null if the current type should not be changed.
 */
function autoDetectType(value, currentType) {
    if (!value || typeof value !== 'string') return null;
    const s = value.trim();
    if (!s) return null;

    // Only auto-switch from cartesian (the default type)
    if (currentType !== 'cartesian') return null;

    // Inequality operators (but not <=, >=, != inside other contexts)
    if (/[^<>=!](>=|<=|>(?!=)|<(?!=))[^<>=]/.test(' ' + s + ' ')) return 'inequality';

    // "y = <expr>" where the RHS is a function of x only → stay cartesian
    if (/^\s*y\s*=\s*/i.test(s)) {
        const rhs = s.replace(/^\s*y\s*=\s*/i, '');
        // If RHS contains y, it's an equation needing CAS; otherwise cartesian
        if (/(?<![a-zA-Z])y(?![a-zA-Z])/.test(rhs)) return 'equation';
        return null; // stay cartesian
    }

    // Has "=" AND contains y → equation (Nerdamer solves for y)
    // e.g. "2x + 3y = 8", "x^2 + y^2 = 25"
    if (s.includes('=') && /(?<![a-zA-Z])y(?![a-zA-Z])/.test(s)) return 'equation';

    // Polar: contains "theta" or "θ" (and no comma — not parametric)
    // e.g. "2*cos(theta)", "1 + sin(θ)", "r = 2cos(theta)"
    if (!s.includes(',') && (/(?<![a-zA-Z])theta(?![a-zA-Z])/.test(s) || s.includes('θ'))) {
        return 'polar';
    }

    // Parametric: comma-separated with "t" variable
    // e.g. "cos(t), sin(t)", "t^2, t^3"
    if (s.includes(',') && /(?<![a-zA-Z])t(?![a-zA-Z])/.test(s)) {
        return 'parametric';
    }

    // Contains both x and y but no "=" → surface z = f(x, y)
    // e.g. "sin(x)*cos(y)", "x^2 + y^2", "exp(-(x^2+y^2)/2)"
    if (/(?<![a-zA-Z])x(?![a-zA-Z])/.test(s) && /(?<![a-zA-Z])y(?![a-zA-Z])/.test(s)) {
        return 'surface';
    }

    return null;
}

/**
 * Update expression value
 */
function updateExpressionValue(id) {
    const element = document.getElementById(`expr-${id}`);

    if (!element) {
        console.error('Input element not found for id:', id);
        return;
    }

    const value = element.value;
    engine.updateExpression(id, { expression: value });

    // Auto-detect and switch type if needed
    const expr = engine.expressions.find(e => e.id === id);
    if (expr) {
        const detected = autoDetectType(value, expr.type);
        if (detected && detected !== expr.type) {
            expr.type = detected;
            const typeSel = document.getElementById(`type-${id}`);
            if (typeSel) typeSel.value = detected;
            // Show/hide calculus toggles based on new type
            const calcToggles = document.getElementById(`calculus-toggles-${id}`);
            if (calcToggles) calcToggles.style.display = (detected === 'cartesian') ? '' : 'none';
            // Rebuild the input UI for the new type (but preserve the expression text)
            createInputForType(id, detected);
            // Restore the expression value in the new input
            const newInput = document.getElementById(`expr-${id}`);
            if (newInput && newInput.value !== value) newInput.value = value;
            // Lazy-load full Plotly for 3D surface
            if (detected === 'surface') {
                _ensureFullPlotly(updateGraph);
                return; // updateGraph will be called by _ensureFullPlotly callback
            }
        }
    }

    // Render math preview for cartesian expressions
    if (expr && expr.type === 'cartesian') {
        renderMathPreview(id, value);
        // Detect and create sliders for parameters
        detectAndCreateSliders(id, value);
    }

    // Update stats if statistics type
    if (expr && expr.type === 'statistics' && expr.stats) {
        displayStatistics(id, expr.stats);
    }

    updateGraph();
}

/**
 * Update expression color
 */
function updateExpressionColor(id) {
    const color = document.getElementById(`color-${id}`).value;
    engine.updateExpression(id, { color });
    updateGraph();
}

/**
 * Delete expression
 */
function deleteExpression(id) {
    engine.removeExpression(id);
    const element = expressionElements[id];
    if (element) {
        element.remove();
        delete expressionElements[id];
    }
    updateGraph();
}

/**
 * Display statistics
 */
function displayStatistics(id, stats) {
    const statsDiv = document.getElementById(`stats-${id}`);
    if (statsDiv && stats) {
        statsDiv.style.display = 'block';
        statsDiv.innerHTML = `
            <strong>Statistics:</strong><br>
            n = ${stats.n}<br>
            Mean: (${stats.meanX}, ${stats.meanY})<br>
            Std Dev: (${stats.stdX}, ${stats.stdY})<br>
            Correlation: ${stats.correlation}<br>
            ${stats.regressionEquation}
        `;
    }
}

/**
 * Update the graph
 */
function updateGraph() {
    const xMin = parseFloat(document.getElementById('xMin').value);
    const xMax = parseFloat(document.getElementById('xMax').value);
    const yMin = parseFloat(document.getElementById('yMin').value);
    const yMax = parseFloat(document.getElementById('yMax').value);
    const showGrid = document.getElementById('showGrid').checked;
    const showLegend = document.getElementById('showLegend').checked;

    engine.plot({ xMin, xMax, yMin, yMax, showGrid, showLegend });
}

/**
 * Reset view to default
 */
function resetView() {
    document.getElementById('xMin').value = -10;
    document.getElementById('xMax').value = 10;
    document.getElementById('yMin').value = -10;
    document.getElementById('yMax').value = 10;
    updateGraph();
}

// Initialize: DOM may already be ready if script was loaded async after DOMContentLoaded
function _gcBoot() {
    initGraph();
    ['xMin', 'xMax', 'yMin', 'yMax'].forEach(id => {
        const el = document.getElementById(id);
        if (el) el.addEventListener('change', updateGraph);
    });

    // Start auto-demo if user hasn't typed anything (idle showcase)
    _startAutoDemo();
}
if (document.readyState === 'loading') {
    window.addEventListener('DOMContentLoaded', _gcBoot);
} else {
    _gcBoot();
}

// ============================================
// Auto-Demo Carousel — showcases presets on idle
// Stops permanently on any user interaction
// ============================================
var _autoDemoTimer = null;
var _autoDemoRunning = false;
var _autoDemoIndex = 0;
var _autoDemoCycleTimer = null;

var _autoDemoPresets = [
    'heart', 'butterfly', 'spirograph', 'lissajous',
    'polar_flowers', 'rose_curves', 'golden_spiral', 'deltoid'
];

function _startAutoDemo() {
    // Don't start in embed mode, if URL has shared state, or user already typed something
    if (window.EMBED_MODE) return;
    if (window.location.hash || window.location.search) return;
    var firstInput = document.querySelector('.expression-input');
    if (firstInput && firstInput.value && firstInput.value.trim() !== '') return;

    _autoDemoRunning = true;

    // Show demo badge
    _showDemoBadge();

    // First demo fires after 8 seconds of idle
    _autoDemoTimer = setTimeout(function() {
        if (!_autoDemoRunning) return;
        _runNextDemo();
        // Then cycle every 6 seconds
        _autoDemoCycleTimer = setInterval(function() {
            if (!_autoDemoRunning) { clearInterval(_autoDemoCycleTimer); return; }
            _runNextDemo();
        }, 6000);
    }, 8000);

    // Stop on any user interaction
    var stopEvents = ['keydown', 'mousedown', 'touchstart', 'pointerdown'];
    function stopDemo() {
        _stopAutoDemo();
        stopEvents.forEach(function(ev) { document.removeEventListener(ev, stopDemo, true); });
    }
    stopEvents.forEach(function(ev) { document.addEventListener(ev, stopDemo, true); });
}

function _runNextDemo() {
    if (!_autoDemoRunning || !engine) return;
    var preset = _autoDemoPresets[_autoDemoIndex % _autoDemoPresets.length];
    _autoDemoIndex++;

    // Enable animation for this render
    engine._animateNext = true;

    if (typeof gcQuickPreset === 'function') {
        gcQuickPreset(preset);
    }
}

function _stopAutoDemo() {
    var wasRunning = _autoDemoRunning;
    _autoDemoRunning = false;
    if (_autoDemoTimer) { clearTimeout(_autoDemoTimer); _autoDemoTimer = null; }
    if (_autoDemoCycleTimer) { clearInterval(_autoDemoCycleTimer); _autoDemoCycleTimer = null; }
    _hideDemoBadge();

    // If demo was cycling, reset to clean state so user starts fresh
    if (wasRunning && _autoDemoIndex > 0 && typeof gcClearAll === 'function') {
        gcClearAll();
    }
}

function _showDemoBadge() {
    var existing = document.getElementById('gc-demo-badge');
    if (existing) return;
    var badge = document.createElement('div');
    badge.id = 'gc-demo-badge';
    badge.textContent = 'Auto-Demo — click anywhere to start graphing';
    badge.style.cssText = 'position:absolute;top:8px;left:50%;transform:translateX(-50%);z-index:10;' +
        'background:rgba(37,99,235,0.9);color:#fff;padding:6px 16px;border-radius:20px;' +
        'font-size:13px;font-weight:500;pointer-events:none;opacity:0;transition:opacity 0.5s;';
    var graphDiv = document.getElementById('graph');
    if (graphDiv && graphDiv.parentElement) {
        graphDiv.parentElement.style.position = 'relative';
        graphDiv.parentElement.appendChild(badge);
        requestAnimationFrame(function() { badge.style.opacity = '1'; });
    }
}

function _hideDemoBadge() {
    var badge = document.getElementById('gc-demo-badge');
    if (badge) {
        badge.style.opacity = '0';
        setTimeout(function() { if (badge.parentElement) badge.parentElement.removeChild(badge); }, 500);
    }
}

/**
 * Toggle derivative display for an expression
 */
function toggleDerivative(id) {
    const checkbox = document.getElementById(`show-derivative-${id}`);
    const expr = engine.expressions.find(e => e.id === id);

    if (expr) {
        expr.showDerivative = checkbox.checked;
        updateGraph();
    }
}

/**
 * Toggle integration display for an expression
 */
function toggleIntegration(id) {
    const checkbox = document.getElementById(`show-integration-${id}`);
    const controls = document.getElementById(`integration-controls-${id}`);
    const expr = engine.expressions.find(e => e.id === id);

    if (expr) {
        expr.showIntegration = checkbox.checked;

        if (checkbox.checked) {
            controls.style.display = 'block';
            // Initialize default bounds
            const a = parseFloat(document.getElementById(`integration-a-${id}`).value);
            const b = parseFloat(document.getElementById(`integration-b-${id}`).value);
            expr.integrationBounds = { a, b };
        } else {
            controls.style.display = 'none';
        }

        updateGraph();
    }
}

/**
 * Update integration bounds
 */
function updateIntegrationBounds(id) {
    const a = parseFloat(document.getElementById(`integration-a-${id}`).value);
    const b = parseFloat(document.getElementById(`integration-b-${id}`).value);
    const expr = engine.expressions.find(e => e.id === id);

    if (expr && !isNaN(a) && !isNaN(b)) {
        expr.integrationBounds = { a, b };
        updateGraph();
    }
}

/**
 * Update Riemann sum method for an expression
 */
function updateRiemannMethod(id) {
    const select = document.getElementById(`riemann-method-${id}`);
    const expr = engine.expressions.find(e => e.id === id);
    if (expr && select) {
        expr.riemannMethod = select.value;
        updateGraph();
    }
}

/**
 * Update Riemann sum subdivision count
 */
function updateRiemannN(id) {
    const input = document.getElementById(`riemann-n-${id}`);
    const expr = engine.expressions.find(e => e.id === id);
    if (expr && input) {
        const n = parseInt(input.value, 10);
        if (n > 0 && n <= 500) {
            expr.riemannN = n;
            updateGraph();
        }
    }
}

/**
 * Toggle antiderivative F(x) display for an expression
 */
function toggleAntiderivative(id) {
    const checkbox = document.getElementById(`show-antiderivative-${id}`);
    const expr = engine.expressions.find(e => e.id === id);

    if (expr) {
        expr.showAntiderivative = checkbox.checked;
        updateGraph();
    }
}

/**
 * Update limit expression parameters
 */
function updateLimitExpression(id) {
    const input = document.getElementById(`expr-${id}`);
    const valInput = document.getElementById(`limit-val-${id}`);
    const resultSpan = document.getElementById(`limit-result-${id}`);
    const expr = engine.expressions.find(e => e.id === id);

    if (!expr || !input) return;

    const limitExpr = input.value.trim();
    const limitVal = valInput ? valInput.value.trim() : '0';

    expr.expression = limitExpr;
    expr.limitExpr = limitExpr;
    expr.limitVar = 'x';
    expr.limitVal = limitVal;

    // Evaluate limit and show result (Nerdamer first, then SymPy fallback)
    if (limitExpr) {
        let result = null;
        if (typeof nerdamer !== 'undefined') {
            result = engine.evaluateLimit(limitExpr, 'x', limitVal);
        }
        if (result && resultSpan) {
            resultSpan.textContent = result.symbolic + (result.numeric != null ? ' ≈ ' + result.numeric.toFixed(6) : '');
        } else if (resultSpan) {
            resultSpan.textContent = 'evaluating...';
            engine.evaluateLimitSymPy(limitExpr, 'x', limitVal).then(sympyResult => {
                if (sympyResult && resultSpan) {
                    resultSpan.textContent = sympyResult.symbolic + (sympyResult.numeric != null ? ' ≈ ' + sympyResult.numeric.toFixed(6) : '');
                    // Store for the plot
                    expr._sympyLimitResult = sympyResult;
                    expr._sympyLimitResolved = true;
                    updateGraph();
                } else if (resultSpan) {
                    resultSpan.textContent = '?';
                }
            });
        }
    }

    updateGraph();
}

/**
 * Load a limit sample (expression + approach value)
 */
function loadLimitSample(id, expression, value) {
    const input = document.getElementById(`expr-${id}`);
    const valInput = document.getElementById(`limit-val-${id}`);
    if (input) input.value = expression;
    if (valInput) valInput.value = value;
    updateLimitExpression(id);
}

/**
 * Update piecewise function
 */
function updatePiecewise(id) {
    const pieces = [];
    let pieceIndex = 0;

    // Collect all pieces
    while (true) {
        const exprElem = document.getElementById(`piece-expr-${id}-${pieceIndex}`);
        const condElem = document.getElementById(`piece-cond-${id}-${pieceIndex}`);

        if (!exprElem || !condElem) break;

        const expression = exprElem.value.trim();
        const condition = condElem.value.trim();

        if (expression) {
            pieces.push({ expression, condition });
        }

        pieceIndex++;
    }

    const expr = engine.expressions.find(e => e.id === id);
    if (expr) {
        expr.pieces = pieces;
        expr.expression = `Piecewise (${pieces.length} pieces)`;
        updateGraph();
    }
}

/**
 * Add a new piece to piecewise function
 */
function addPiecewisePiece(id) {
    const container = document.getElementById(`piecewise-pieces-${id}`);

    // Count existing pieces
    let pieceCount = 0;
    while (document.getElementById(`piece-expr-${id}-${pieceCount}`)) {
        pieceCount++;
    }

    const newPiece = document.createElement('div');
    newPiece.className = 'mb-2 p-2';
    newPiece.style.cssText = 'background: #f8f9fa; border-radius: 4px;';
    newPiece.innerHTML = `
        <small class="text-muted"><strong>Piece ${pieceCount + 1}:</strong></small>
        <input type="text" class="form-control form-control-sm mb-1" id="piece-expr-${id}-${pieceCount}"
               placeholder="Expression" oninput="updatePiecewise(${id})">
        <input type="text" class="form-control form-control-sm" id="piece-cond-${id}-${pieceCount}"
               placeholder="Condition" oninput="updatePiecewise(${id})">
    `;

    container.appendChild(newPiece);
}

/**
 * Text-to-Graph: Convert text to equations that draw letters
 */
function textToGraph() {
    const text = prompt('Enter a word to graph (max 6 letters):\n\nSupported: A-Z\nBest results: MATH, CODE, LOVE, HI, YO');
    if (!text) return;

    const word = text.toUpperCase().replace(/[^A-Z]/g, '').substring(0, 6);

    if (word.length === 0) {
        alert('Please enter at least one letter (A-Z)');
        return;
    }

    // Clear existing expressions
    const confirmed = confirm(`This will replace current expressions with "${word}".\n\nContinue?`);
    if (!confirmed) return;

    engine.expressions = [];
    document.getElementById('expressions-list').innerHTML = '';
    expressionElements = {};

    // Generate letter equations
    const letterWidth = 3;
    const letterSpacing = 1;

    for (let i = 0; i < word.length; i++) {
        const letter = word[i];
        const offsetX = i * (letterWidth + letterSpacing);
        addLetterToGraph(letter, offsetX);
    }

    // Adjust view to fit text
    const totalWidth = word.length * (letterWidth + letterSpacing);
    document.getElementById('xMin').value = -2;
    document.getElementById('xMax').value = totalWidth + 2;
    document.getElementById('yMin').value = -1;
    document.getElementById('yMax').value = 8;

    updateGraph();
    alert(`"${word}" has been graphed!\n\nEach letter is made from mathematical equations.`);
}

/**
 * Add a letter to the graph using equations
 */
function addLetterToGraph(letter, offsetX = 0) {
    const x0 = offsetX;
    const w = 3; // width
    const mid = x0 + w/2; // middle x position

    switch (letter) {
        case 'A':
            // V shape
            addCartesian(`2*(x - ${x0})`, `x >= ${x0} and x <= ${mid}`);
            addCartesian(`${2*w} - 2*(x - ${x0})`, `x >= ${mid} and x <= ${x0 + w}`);
            // Crossbar
            addCartesian(`${3}`, `x >= ${x0 + w*0.3} and x <= ${x0 + w*0.7}`);
            break;

        case 'C':
            // Circle with gap (implicit)
            addImplicit(`(x - ${mid})^2 + (y - 3)^2 = 4`);
            break;

        case 'D':
            // Semicircle
            addCartesian(`sqrt(4 - (x - ${x0})^2) + 3`, `x >= ${x0} and x <= ${x0 + 2}`);
            addCartesian(`-sqrt(4 - (x - ${x0})^2) + 3`, `x >= ${x0} and x <= ${x0 + 2}`);
            break;

        case 'E':
            // Three horizontal lines at different heights
            addCartesian(`${6}`, `x >= ${x0} and x <= ${x0 + w}`);
            addCartesian(`${3}`, `x >= ${x0} and x <= ${x0 + w*0.8}`);
            addCartesian(`${0}`, `x >= ${x0} and x <= ${x0 + w}`);
            break;

        case 'H':
            // Two vertical lines with crossbar
            addCartesian(`${x0}`, `x >= ${x0 - 0.1} and x <= ${x0 + 0.1}`);
            addCartesian(`${x0 + w}`, `x >= ${x0 + w - 0.1} and x <= ${x0 + w + 0.1}`);
            addCartesian(`${3}`, `x >= ${x0} and x <= ${x0 + w}`);
            break;

        case 'I':
            // Single vertical line
            addCartesian(`${mid}`, `x >= ${mid - 0.1} and x <= ${mid + 0.1}`);
            break;

        case 'L':
            // L shape
            addCartesian(`${x0}`, `x >= ${x0 - 0.1} and x <= ${x0 + 0.1}`);
            addCartesian(`${0}`, `x >= ${x0} and x <= ${x0 + w}`);
            break;

        case 'M':
            // M shape with peaks
            addCartesian(`2*(x - ${x0})`, `x >= ${x0} and x <= ${x0 + w*0.25}`);
            addCartesian(`${w*0.5} - 2*(x - ${x0})`, `x >= ${x0 + w*0.25} and x <= ${mid}`);
            addCartesian(`2*(x - ${x0}) - ${w*0.5}`, `x >= ${mid} and x <= ${x0 + w*0.75}`);
            addCartesian(`${w*1.5} - 2*(x - ${x0})`, `x >= ${x0 + w*0.75} and x <= ${x0 + w}`);
            break;

        case 'N':
            // Diagonal line
            addCartesian(`2*(x - ${x0})`, `x >= ${x0} and x <= ${x0 + w}`);
            break;

        case 'O':
            // Circle
            addImplicit(`(x - ${mid})^2 + (y - 3)^2 = 4`);
            break;

        case 'T':
            // T shape
            addCartesian(`${6}`, `x >= ${x0} and x <= ${x0 + w}`);
            addCartesian(`${mid}`, `x >= ${mid - 0.1} and x <= ${mid + 0.1}`);
            break;

        case 'U':
            // Parabola
            addCartesian(`0.7*(x - ${mid})^2 + 1`, `x >= ${x0} and x <= ${x0 + w}`);
            break;

        case 'V':
            // V shape
            addCartesian(`${6} - 2*(x - ${x0})`, `x >= ${x0} and x <= ${mid}`);
            addCartesian(`2*(x - ${x0}) - ${w}`, `x >= ${mid} and x <= ${x0 + w}`);
            break;

        case 'W':
            // W shape
            addCartesian(`${6} - 2*(x - ${x0})`, `x >= ${x0} and x <= ${x0 + w*0.25}`);
            addCartesian(`2*(x - ${x0}) - ${w*0.5}`, `x >= ${x0 + w*0.25} and x <= ${mid}`);
            addCartesian(`${w*1.5} - 2*(x - ${x0})`, `x >= ${mid} and x <= ${x0 + w*0.75}`);
            addCartesian(`2*(x - ${x0}) - ${w}`, `x >= ${x0 + w*0.75} and x <= ${x0 + w}`);
            break;

        case 'X':
            // Two diagonals
            addCartesian(`2*(x - ${x0})`, `x >= ${x0} and x <= ${x0 + w}`);
            addCartesian(`${2*w} - 2*(x - ${x0})`, `x >= ${x0} and x <= ${x0 + w}`);
            break;

        case 'Y':
            // Y shape
            addCartesian(`${6} - 2*(x - ${x0})`, `x >= ${x0} and x <= ${mid}`);
            addCartesian(`2*(x - ${x0}) - ${w}`, `x >= ${mid} and x <= ${x0 + w}`);
            addCartesian(`${mid}`, `x >= ${mid - 0.1} and x <= ${mid + 0.1}`);
            break;

        case 'Z':
            // Z shape
            addCartesian(`${6}`, `x >= ${x0} and x <= ${x0 + w}`);
            addCartesian(`${2*w} - 2*(x - ${x0})`, `x >= ${x0} and x <= ${x0 + w}`);
            addCartesian(`${0}`, `x >= ${x0} and x <= ${x0 + w}`);
            break;

        default:
            // Space or unknown
            break;
    }
}

/**
 * Helper: Add a Cartesian expression with optional condition
 */
function addCartesian(expression, condition = null) {
    if (condition) {
        // Use piecewise for conditional expressions
        const expr = engine.addExpression(`Segment`, 'piecewise');
        expr.pieces = [{ expression, condition }];
        createExpressionElement(expr);

        // Update the type dropdown
        setTimeout(() => {
            const typeElem = document.getElementById(`type-${expr.id}`);
            if (typeElem) typeElem.value = 'piecewise';
            updateExpressionType(expr.id);
        }, 10);
    } else {
        const expr = engine.addExpression(expression, 'cartesian');
        createExpressionElement(expr);

        const inputElement = document.getElementById(`expr-${expr.id}`);
        if (inputElement) inputElement.value = expression;
    }
}

/**
 * Helper: Add an implicit function
 */
function addImplicit(expression) {
    const expr = engine.addExpression(expression, 'implicit');
    createExpressionElement(expr);

    setTimeout(() => {
        const inputElement = document.getElementById(`expr-${expr.id}`);
        if (inputElement) inputElement.value = expression;

        const typeElem = document.getElementById(`type-${expr.id}`);
        if (typeElem) typeElem.value = 'implicit';
        updateExpressionType(expr.id);
    }, 10);
}

/**
 * Load piecewise sample functions
 */
function loadPiecewiseSample(id, type) {
    const container = document.getElementById(`piecewise-pieces-${id}`);

    switch (type) {
        case 'abs':
            // Absolute value function
            document.getElementById(`piece-expr-${id}-0`).value = '-x';
            document.getElementById(`piece-cond-${id}-0`).value = 'x < 0';
            document.getElementById(`piece-expr-${id}-1`).value = 'x';
            document.getElementById(`piece-cond-${id}-1`).value = 'x >= 0';
            break;

        case 'step':
            // Step function
            document.getElementById(`piece-expr-${id}-0`).value = '-1';
            document.getElementById(`piece-cond-${id}-0`).value = 'x < 0';
            document.getElementById(`piece-expr-${id}-1`).value = '1';
            document.getElementById(`piece-cond-${id}-1`).value = 'x >= 0';
            break;

        case 'sawtooth':
            // Sawtooth wave
            document.getElementById(`piece-expr-${id}-0`).value = 'x % 2';
            document.getElementById(`piece-cond-${id}-0`).value = 'x >= 0';
            document.getElementById(`piece-expr-${id}-1`).value = '-((-x) % 2)';
            document.getElementById(`piece-cond-${id}-1`).value = 'x < 0';
            break;
    }

    updatePiecewise(id);
}

/**
 * Find and display intersection points
 */
function findIntersections() {
    const cartesianExprs = engine.expressions.filter(e => e.type === 'cartesian' && e.expression && e.visible);

    if (cartesianExprs.length < 2) {
        alert('Please add at least 2 Cartesian expressions to find intersections.');
        return;
    }

    const xMin = parseFloat(document.getElementById('xMin').value);
    const xMax = parseFloat(document.getElementById('xMax').value);

    console.log('Finding intersections between', cartesianExprs.length, 'functions...');

    // Find intersections between all pairs
    for (let i = 0; i < cartesianExprs.length; i++) {
        for (let j = i + 1; j < cartesianExprs.length; j++) {
            const intersections = engine.findIntersections(
                cartesianExprs[i].expression,
                cartesianExprs[j].expression,
                xMin,
                xMax
            );

            if (intersections.length > 0) {
                console.log(`Intersections between "${cartesianExprs[i].expression}" and "${cartesianExprs[j].expression}":`, intersections);

                // Store intersections for display
                if (!cartesianExprs[i].intersections) {
                    cartesianExprs[i].intersections = [];
                }
                cartesianExprs[i].intersections.push(...intersections);
            }
        }
    }

    updateGraph();
}

/**
 * Detect parameters in expression (like a, b, c) and create sliders
 */
function detectAndCreateSliders(id, expression) {
    const slidersContainer = document.getElementById(`sliders-container-${id}`);

    if (!slidersContainer || !expression) {
        return;
    }

    // Find parameters (single letters except x, y, t, e, pi)
    const params = new Set();
    const regex = /\b([a-df-zA-Z])\b/g;
    let match;

    while ((match = regex.exec(expression)) !== null) {
        const param = match[1];
        // Exclude common variables and constants
        if (param !== 'x' && param !== 'y' && param !== 't' && param !== 'e' && param !== 'pi') {
            params.add(param);
        }
    }

    if (params.size === 0) {
        slidersContainer.innerHTML = '';
        return;
    }

    // Create sliders for each parameter
    let slidersHTML = '<div class="mt-2"><small class="text-muted">Parameters:</small></div>';

    params.forEach(param => {
        slidersHTML += `
            <div class="mb-2">
                <label class="form-label" style="font-size: 12px;">
                    ${param} = <span id="param-value-${param}-${id}">1</span>
                </label>
                <input type="range" class="form-range" id="param-${param}-${id}"
                       min="-10" max="10" step="0.1" value="1"
                       oninput="updateParameter(${id}, '${param}', this.value)">
            </div>
        `;
    });

    slidersContainer.innerHTML = slidersHTML;

    // Initialize parameter values in expression
    const expr = engine.expressions.find(e => e.id === id);
    if (expr) {
        if (!expr.parameters) {
            expr.parameters = {};
        }
        params.forEach(param => {
            if (!(param in expr.parameters)) {
                expr.parameters[param] = 1;
            }
        });
    }

    // Add animation controls for first parameter
    if (params.size > 0) {
        const firstParam = Array.from(params)[0];
        slidersHTML = `
            <div class="mt-3 p-2" style="background: #f0f0f0; border-radius: 4px;">
                <small class="text-muted"><strong>Animation Controls</strong></small>
                <div class="d-flex gap-2 mt-2">
                    <button class="btn btn-sm btn-primary" onclick="toggleAnimation(${id}, '${firstParam}')">
                        <i class="fas fa-play" id="anim-icon-${id}-${firstParam}"></i>
                    </button>
                    <select class="form-select form-select-sm" id="anim-speed-${id}-${firstParam}" style="width: auto;">
                        <option value="0.05">Slow</option>
                        <option value="0.1" selected>Normal</option>
                        <option value="0.2">Fast</option>
                    </select>
                    <span class="align-self-center" style="font-size: 11px;">Param: ${firstParam}</span>
                </div>
            </div>
        `;
        slidersContainer.innerHTML += slidersHTML;
    }
}

/**
 * Update parameter value from slider
 */
function updateParameter(id, param, value) {
    const valueSpan = document.getElementById(`param-value-${param}-${id}`);
    if (valueSpan) {
        valueSpan.textContent = parseFloat(value).toFixed(1);
    }

    const expr = engine.expressions.find(e => e.id === id);
    if (expr) {
        if (!expr.parameters) {
            expr.parameters = {};
        }
        expr.parameters[param] = parseFloat(value);
        updateGraph();
    }
}

/**
 * Toggle animation for a parameter
 */
function toggleAnimation(id, param) {
    const icon = document.getElementById(`anim-icon-${id}-${param}`);
    const speedSelect = document.getElementById(`anim-speed-${id}-${param}`);

    if (animationState.isPlaying && animationState.exprId === id && animationState.paramName === param) {
        // Stop animation
        stopAnimation();
        icon.className = 'fas fa-play';
    } else {
        // Stop any existing animation
        if (animationState.isPlaying) {
            stopAnimation();
            // Reset previous icon
            const prevIcon = document.getElementById(`anim-icon-${animationState.exprId}-${animationState.paramName}`);
            if (prevIcon) prevIcon.className = 'fas fa-play';
        }

        // Start new animation
        animationState.isPlaying = true;
        animationState.exprId = id;
        animationState.paramName = param;
        animationState.currentValue = -10;
        animationState.speed = parseFloat(speedSelect.value);
        icon.className = 'fas fa-pause';

        animate();
    }
}

/**
 * Animation loop
 */
function animate() {
    if (!animationState.isPlaying) return;

    const { exprId, paramName, speed } = animationState;

    // Update parameter value
    animationState.currentValue += speed;

    // Loop back to start
    if (animationState.currentValue > 10) {
        animationState.currentValue = -10;
    }

    // Update slider and parameter
    const slider = document.getElementById(`param-${paramName}-${exprId}`);
    if (slider) {
        slider.value = animationState.currentValue;
        updateParameter(exprId, paramName, animationState.currentValue);
    }

    // Continue animation
    animationState.animationId = requestAnimationFrame(animate);
}

/**
 * Stop animation
 */
function stopAnimation() {
    animationState.isPlaying = false;
    if (animationState.animationId) {
        cancelAnimationFrame(animationState.animationId);
        animationState.animationId = null;
    }
}

/**
 * Toggle trace mode
 */
function toggleTraceMode() {
    traceModeActive = !traceModeActive;
    const button = document.querySelector('[onclick="toggleTraceMode()"]');
    if (!button) return;

    if (traceModeActive) {
        button.style.background = 'var(--gc-light)';
        button.style.borderColor = 'var(--gc-tool)';
        button.style.color = 'var(--gc-tool)';
        button.title = 'Trace Mode: ON';
        enableTraceMode();
    } else {
        button.style.background = '';
        button.style.borderColor = '';
        button.style.color = '';
        button.title = 'Trace Mode';
        disableTraceMode();
    }
}

/**
 * Enable trace mode with cursor tracking
 */
function enableTraceMode() {
    const graphDiv = document.getElementById('graph');

    graphDiv.on('plotly_hover', function(data) {
        if (!traceModeActive) return;

        const point = data.points[0];
        if (!point) return;

        const x = point.x;
        const y = point.y;

        // Calculate derivative if it's a function
        let slopeText = '';
        const expr = engine.expressions.find(e => e.expression === point.data.name);

        if (expr && expr.type === 'cartesian') {
            try {
                const compiledExpr = math.compile(engine.normalizeExpression(engine.stripCartesianPrefix(expr.expression)));
                const h = 0.001;
                const yPlus = compiledExpr.evaluate({ x: x + h });
                const yMinus = compiledExpr.evaluate({ x: x - h });
                const slope = (yPlus - yMinus) / (2 * h);

                if (isFinite(slope)) {
                    slopeText = `<br>Slope: ${slope.toFixed(4)}`;
                }
            } catch (e) {
                // Ignore errors
            }
        }

        // Show tooltip with coordinates and slope
        const tooltip = document.getElementById('trace-tooltip');
        if (tooltip) {
            tooltip.innerHTML = `
                <strong>${point.data.name}</strong><br>
                x: ${x.toFixed(4)}<br>
                y: ${y.toFixed(4)}
                ${slopeText}
            `;
            tooltip.style.display = 'block';
        }
    });

    graphDiv.on('plotly_unhover', function() {
        const tooltip = document.getElementById('trace-tooltip');
        if (tooltip) {
            tooltip.style.display = 'none';
        }
    });

    // Create tooltip element if it doesn't exist
    if (!document.getElementById('trace-tooltip')) {
        const tooltip = document.createElement('div');
        tooltip.id = 'trace-tooltip';
        tooltip.style.cssText = `
            position: fixed;
            top: 100px;
            right: 30px;
            background: rgba(0, 0, 0, 0.85);
            color: white;
            padding: 12px;
            border-radius: 6px;
            font-family: 'Courier New', monospace;
            font-size: 13px;
            z-index: 1000;
            display: none;
            box-shadow: 0 4px 8px rgba(0,0,0,0.3);
        `;
        document.body.appendChild(tooltip);
    }
}

/**
 * Disable trace mode
 */
function disableTraceMode() {
    const tooltip = document.getElementById('trace-tooltip');
    if (tooltip) {
        tooltip.style.display = 'none';
    }
}

/**
 * Solve equation (find roots where y = 0 or y = targetY)
 */
function solveEquation() {
    const cartesianExprs = engine.expressions.filter(e => e.type === 'cartesian' && e.expression && e.visible);

    if (cartesianExprs.length === 0) {
        alert('Please add at least one Cartesian expression first!\n\nSteps:\n1. Click "Add Expression"\n2. Enter a function like: x^2 - 4\n3. Click "Solve Equation" again');
        return;
    }

    // Prompt for which expression to solve
    let message = 'Select expression to solve:\n\n';
    cartesianExprs.forEach((expr, index) => {
        message += `${index + 1}. ${expr.expression}\n`;
    });

    const selection = prompt(message + `\nEnter a number between 1 and ${cartesianExprs.length}:`);

    if (selection === null) return; // User cancelled

    const index = parseInt(selection) - 1;

    if (isNaN(index) || index < 0 || index >= cartesianExprs.length) {
        alert(`Invalid selection!\n\nYou entered: "${selection}"\nPlease enter a number between 1 and ${cartesianExprs.length}`);
        return;
    }

    const expr = cartesianExprs[index];

    // Prompt for target y value
    const targetYStr = prompt('Solve for y = ? (default: 0 to find roots)', '0');
    if (targetYStr === null) return;

    const targetY = parseFloat(targetYStr) || 0;

    const xMin = parseFloat(document.getElementById('xMin').value);
    const xMax = parseFloat(document.getElementById('xMax').value);

    // Find solutions
    const solutions = findSolutions(expr.expression, targetY, xMin, xMax);

    if (solutions.length === 0) {
        alert(`No solutions found for ${expr.expression} = ${targetY} in range [${xMin}, ${xMax}]`);
        return;
    }

    // Display solutions
    let resultMsg = `Solutions for ${expr.expression} = ${targetY}:\n\n`;
    solutions.forEach((x, i) => {
        resultMsg += `${i + 1}. x = ${x.toFixed(6)}\n`;
    });

    alert(resultMsg);

    // Mark solutions on graph
    if (!expr.solutions) {
        expr.solutions = [];
    }
    expr.solutions = solutions.map(x => ({ x, y: targetY }));

    updateGraph();
}

/**
 * Find solutions using root-finding algorithm
 */
function findSolutions(expression, targetY, xMin, xMax, tolerance = 0.001) {
    try {
        const compiled = math.compile(engine.normalizeExpression(engine.stripCartesianPrefix(expression)));
        const solutions = [];
        const numSamples = 1000;
        const step = (xMax - xMin) / numSamples;

        let prevSign = null;

        for (let i = 0; i <= numSamples; i++) {
            const x = xMin + i * step;

            try {
                const y = compiled.evaluate({ x });
                const diff = y - targetY;

                if (!isFinite(diff)) continue;

                const currentSign = Math.sign(diff);

                // Check for sign change (indicates crossing)
                if (prevSign !== null && prevSign !== currentSign && currentSign !== 0) {
                    // Use bisection method to refine solution
                    const solution = bisectionSolve(
                        compiled,
                        targetY,
                        x - step,
                        x,
                        tolerance
                    );

                    if (solution !== null) {
                        solutions.push(solution);
                    }
                }

                // Check for exact solution
                if (Math.abs(diff) < tolerance) {
                    solutions.push(x);
                }

                prevSign = currentSign;
            } catch (e) {
                // Skip points where evaluation fails
            }
        }

        // Remove duplicates
        const unique = [];
        for (const sol of solutions) {
            const isDuplicate = unique.some(s => Math.abs(s - sol) < tolerance * 10);
            if (!isDuplicate) {
                unique.push(sol);
            }
        }

        return unique;
    } catch (error) {
        console.error('Error finding solutions:', error);
        return [];
    }
}

/**
 * Bisection method for finding solutions
 */
function bisectionSolve(compiled, targetY, xLeft, xRight, tolerance) {
    let left = xLeft;
    let right = xRight;
    let iterations = 0;
    const maxIterations = 50;

    while (iterations < maxIterations && (right - left) > tolerance) {
        const mid = (left + right) / 2;

        try {
            const yLeft = compiled.evaluate({ x: left });
            const diffLeft = yLeft - targetY;

            const yMid = compiled.evaluate({ x: mid });
            const diffMid = yMid - targetY;

            if (Math.abs(diffMid) < tolerance) {
                return mid;
            }

            if (Math.sign(diffLeft) !== Math.sign(diffMid)) {
                right = mid;
            } else {
                left = mid;
            }
        } catch (e) {
            return null;
        }

        iterations++;
    }

    return (left + right) / 2;
}

/**
 * Export graph as PNG image
 */
function exportAsPNG() {
    Plotly.downloadImage('graph', {
        format: 'png',
        width: 1200,
        height: 800,
        filename: 'graph-' + Date.now()
    });
}

/**
 * Export graph as SVG image
 */
function exportAsSVG() {
    Plotly.downloadImage('graph', {
        format: 'svg',
        width: 1200,
        height: 800,
        filename: 'graph-' + Date.now()
    });
}

/**
 * Save current expression set to localStorage
 */
function saveExpressionSet() {
    const name = prompt('Enter a name for this expression set:');
    if (!name) return;

    const data = {
        name: name,
        timestamp: Date.now(),
        expressions: engine.expressions.map(expr => ({
            expression: expr.expression,
            type: expr.type,
            color: expr.color,
            visible: expr.visible,
            showDerivative: expr.showDerivative,
            showAntiderivative: expr.showAntiderivative,
            limitExpr: expr.limitExpr,
            limitVar: expr.limitVar,
            limitVal: expr.limitVal,
            parameters: expr.parameters,
            distParams: expr.distParams
        })),
        settings: {
            xMin: document.getElementById('xMin').value,
            xMax: document.getElementById('xMax').value,
            yMin: document.getElementById('yMin').value,
            yMax: document.getElementById('yMax').value,
            showGrid: document.getElementById('showGrid').checked,
            showLegend: document.getElementById('showLegend').checked
        }
    };

    // Get existing saved sets
    const saved = JSON.parse(localStorage.getItem('savedExpressionSets') || '[]');
    saved.push(data);
    localStorage.setItem('savedExpressionSets', JSON.stringify(saved));

    alert(`Expression set "${name}" saved successfully!`);
}

/**
 * Load expression set from localStorage
 */
function loadExpressionSet() {
    const saved = JSON.parse(localStorage.getItem('savedExpressionSets') || '[]');

    if (saved.length === 0) {
        alert('No saved expression sets found.');
        return;
    }

    // Create selection dialog
    let message = 'Select an expression set to load:\n\n';
    saved.forEach((set, index) => {
        const date = new Date(set.timestamp).toLocaleString();
        message += `${index + 1}. ${set.name} (${date})\n`;
    });

    const selection = prompt(message + '\nEnter number:');
    const index = parseInt(selection) - 1;

    if (isNaN(index) || index < 0 || index >= saved.length) {
        alert('Invalid selection.');
        return;
    }

    const data = saved[index];

    // Clear current expressions
    engine.expressions = [];
    document.getElementById('expressions-list').innerHTML = '';
    expressionElements = {};

    // Restore expressions
    data.expressions.forEach(exprData => {
        const expr = engine.addExpression(
            exprData.expression,
            exprData.type,
            exprData.color
        );
        expr.visible = exprData.visible;
        expr.showDerivative = exprData.showDerivative;
        expr.showAntiderivative = exprData.showAntiderivative;
        expr.limitExpr = exprData.limitExpr;
        expr.limitVar = exprData.limitVar;
        expr.limitVal = exprData.limitVal;
        expr.parameters = exprData.parameters;
        expr.distParams = exprData.distParams;

        createExpressionElement(expr);

        // Restore input value
        const inputElement = document.getElementById(`expr-${expr.id}`);
        if (inputElement) {
            inputElement.value = exprData.expression || '';
        }

        // Restore checkbox
        if (exprData.showDerivative) {
            const checkbox = document.getElementById(`show-derivative-${expr.id}`);
            if (checkbox) checkbox.checked = true;
        }
    });

    // Restore settings
    if (data.settings) {
        document.getElementById('xMin').value = data.settings.xMin;
        document.getElementById('xMax').value = data.settings.xMax;
        document.getElementById('yMin').value = data.settings.yMin;
        document.getElementById('yMax').value = data.settings.yMax;
        document.getElementById('showGrid').checked = data.settings.showGrid;
        document.getElementById('showLegend').checked = data.settings.showLegend;
    }

    updateGraph();
    alert(`Expression set "${data.name}" loaded successfully!`);
}

/**
 * Delete saved expression sets
 */
function manageSavedSets() {
    const saved = JSON.parse(localStorage.getItem('savedExpressionSets') || '[]');

    if (saved.length === 0) {
        alert('No saved expression sets found.');
        return;
    }

    let message = 'Saved expression sets:\n\n';
    saved.forEach((set, index) => {
        const date = new Date(set.timestamp).toLocaleString();
        message += `${index + 1}. ${set.name} (${date})\n`;
    });

    message += '\nEnter number to delete (or "all" to delete all, or cancel):';
    const selection = prompt(message);

    if (!selection) return;

    if (selection.toLowerCase() === 'all') {
        if (confirm('Are you sure you want to delete ALL saved sets?')) {
            localStorage.removeItem('savedExpressionSets');
            alert('All saved sets deleted.');
        }
    } else {
        const index = parseInt(selection) - 1;
        if (isNaN(index) || index < 0 || index >= saved.length) {
            alert('Invalid selection.');
            return;
        }

        const setName = saved[index].name;
        if (confirm(`Delete expression set "${setName}"?`)) {
            saved.splice(index, 1);
            localStorage.setItem('savedExpressionSets', JSON.stringify(saved));
            alert(`Expression set "${setName}" deleted.`);
        }
    }
}

/**
 * Generate shareable link with URL encoding
 */
function generateShareableLink() {
    const data = {
        expressions: engine.expressions.map(expr => ({
            expression: expr.expression,
            type: expr.type,
            color: expr.color,
            showDerivative: expr.showDerivative,
            showAntiderivative: expr.showAntiderivative,
            showIntegration: expr.showIntegration,
            integrationBounds: expr.integrationBounds,
            riemannMethod: expr.riemannMethod,
            riemannN: expr.riemannN,
            limitExpr: expr.limitExpr,
            limitVar: expr.limitVar,
            limitVal: expr.limitVal,
            parameters: expr.parameters,
            distParams: expr.distParams
        })),
        settings: {
            xMin: document.getElementById('xMin').value,
            xMax: document.getElementById('xMax').value,
            yMin: document.getElementById('yMin').value,
            yMax: document.getElementById('yMax').value
        }
    };

    // Encode data to base64 (handle Unicode via encodeURIComponent)
    const jsonString = JSON.stringify(data);
    const base64 = btoa(unescape(encodeURIComponent(jsonString)));

    // Create URL
    const url = window.location.origin + window.location.pathname + '?data=' + encodeURIComponent(base64);

    // Copy to clipboard
    navigator.clipboard.writeText(url).then(() => {
        alert('Shareable link copied to clipboard!\n\nYou can now paste and share this link.');
    }).catch(err => {
        // Fallback: show URL in prompt
        prompt('Copy this shareable link:', url);
    });
}

/**
 * Load from URL parameter
 */
function loadFromURL() {
    const urlParams = new URLSearchParams(window.location.search);
    const dataParam = urlParams.get('data');

    if (!dataParam) return;

    try {
        const jsonString = decodeURIComponent(escape(atob(decodeURIComponent(dataParam))));
        const data = JSON.parse(jsonString);

        // Clear current expressions
        engine.expressions = [];
        document.getElementById('expressions-list').innerHTML = '';
        expressionElements = {};

        // Restore expressions
        data.expressions.forEach(exprData => {
            const expr = engine.addExpression(
                exprData.expression,
                exprData.type,
                exprData.color
            );
            expr.showDerivative = exprData.showDerivative;
            expr.showAntiderivative = exprData.showAntiderivative;
            expr.limitExpr = exprData.limitExpr;
            expr.limitVar = exprData.limitVar;
            expr.limitVal = exprData.limitVal;
            expr.parameters = exprData.parameters;
            expr.distParams = exprData.distParams;

            createExpressionElement(expr);

            // Restore input value
            const inputElement = document.getElementById(`expr-${expr.id}`);
            if (inputElement) {
                inputElement.value = exprData.expression || '';
            }

            // Restore checkbox
            if (exprData.showDerivative) {
                const checkbox = document.getElementById(`show-derivative-${expr.id}`);
                if (checkbox) checkbox.checked = true;
            }
        });

        // Restore settings
        if (data.settings) {
            document.getElementById('xMin').value = data.settings.xMin;
            document.getElementById('xMax').value = data.settings.xMax;
            document.getElementById('yMin').value = data.settings.yMin;
            document.getElementById('yMax').value = data.settings.yMax;
        }

        updateGraph();
    } catch (error) {
        console.error('Error loading from URL:', error);
    }
}

// ============================================
// Embed Code Generator
// ============================================

/**
 * Show the embed code modal with current graph state
 */
function showEmbedCode() {
    var modal = document.getElementById('gc-embed-modal');
    if (!modal) return;
    modal.style.display = 'flex';
    updateEmbedPreview();
}

/**
 * Build embed iframe code from current expressions and options
 */
function updateEmbedPreview() {
    var output = document.getElementById('embed-code-output');
    if (!output) return;

    var width = document.getElementById('embed-width').value || '800';
    var height = document.getElementById('embed-height').value || '500';
    var showInputs = document.getElementById('embed-opt-inputs').checked;
    var showGrid = document.getElementById('embed-opt-grid').checked;
    var showLegend = document.getElementById('embed-opt-legend').checked;
    var darkTheme = document.getElementById('embed-opt-dark').checked;

    // Build params from current graph state
    var params = [];

    if (engine && engine.expressions && engine.expressions.length > 0) {
        var exprs = [], types = [], colors = [];
        engine.expressions.forEach(function(e) {
            if (e.expression) {
                exprs.push(e.expression);
                types.push(e.type || 'cartesian');
                colors.push(e.color || '#2563eb');
            }
        });
        if (exprs.length > 0) {
            params.push('expr=' + encodeURIComponent(exprs.join('|')));
            params.push('type=' + encodeURIComponent(types.join('|')));
            params.push('color=' + encodeURIComponent(colors.join('|')));
        }
    }

    // Range
    var xMin = document.getElementById('xMin').value;
    var xMax = document.getElementById('xMax').value;
    var yMin = document.getElementById('yMin').value;
    var yMax = document.getElementById('yMax').value;
    if (xMin !== '-10') params.push('xmin=' + xMin);
    if (xMax !== '10') params.push('xmax=' + xMax);
    if (yMin !== '-10') params.push('ymin=' + yMin);
    if (yMax !== '10') params.push('ymax=' + yMax);

    // Options
    if (!showInputs) params.push('inputs=0');
    if (!showGrid) params.push('grid=0');
    if (!showLegend) params.push('legend=0');
    if (darkTheme) params.push('theme=dark');

    var cp = (document.querySelector('meta[name="context-path"]') || {}).content || '';
    var baseUrl = window.location.origin + cp + '/graphing-calculator-embed.jsp';
    var url = baseUrl + (params.length > 0 ? '?' + params.join('&') : '');

    var iframe = '<iframe src="' + url + '" width="' + width + '" height="' + height + '" ' +
        'style="border:1px solid #e5e7eb;border-radius:8px;" ' +
        'allowfullscreen loading="lazy" ' +
        'title="Graphing Calculator - 8gwifi.org"></iframe>';

    output.value = iframe;
}

/**
 * Copy embed code to clipboard
 */
function copyEmbedCode() {
    var output = document.getElementById('embed-code-output');
    if (!output) return;
    output.select();
    document.execCommand('copy');
    var btn = output.parentElement.nextElementSibling.querySelector('button');
    if (btn) {
        var orig = btn.innerHTML;
        btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
        setTimeout(function() { btn.innerHTML = orig; }, 2000);
    }
}
