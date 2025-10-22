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
     * Generate data for Cartesian plot (y = f(x))
     */
    generateCartesian(expression, xMin = -10, xMax = 10, numPoints = 500) {
        try {
            // Validate expression
            if (!expression || typeof expression !== 'string' || expression.trim() === '') {
                return null;
            }

            const x = [];
            const y = [];
            const step = (xMax - xMin) / numPoints;

            // Compile expression once
            const compiledExpr = math.compile(expression);

            for (let i = 0; i <= numPoints; i++) {
                const xVal = xMin + i * step;

                try {
                    const yVal = compiledExpr.evaluate({ x: xVal });
                    if (typeof yVal === 'number' && isFinite(yVal)) {
                        x.push(xVal);
                        y.push(yVal);
                    } else {
                        // Add discontinuity
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

            const compiledExpr = math.compile(expression);
            const step = (xMax - xMin) / numPoints;
            let area = 0;

            // Trapezoidal rule: Area = h/2 * (y0 + 2*y1 + 2*y2 + ... + 2*yn-1 + yn)
            for (let i = 0; i <= numPoints; i++) {
                const x = xMin + i * step;
                try {
                    const y = compiledExpr.evaluate({ x });
                    if (isFinite(y)) {
                        if (i === 0 || i === numPoints) {
                            area += y;
                        } else {
                            area += 2 * y;
                        }
                    }
                } catch (e) {
                    // Skip invalid points
                }
            }

            area = (area * step) / 2;

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

            const compiledExpr = math.compile(expression);

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
     * Calculate tangent line at specific point
     */
    calculateTangent(expression, xPoint, xMin = -10, xMax = 10) {
        try {
            const compiledExpr = math.compile(expression);
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

            const xCompiled = math.compile(xExpr.trim());
            const yCompiled = math.compile(yExpr.trim());

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

            const compiledExpr = math.compile(expression);

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
    generateImplicit(expression, xMin = -10, xMax = 10, yMin = -10, yMax = 10, resolution = 200) {
        try {
            // Parse expression like "x^2 + y^2 = 25" into left and right parts
            let leftExpr, rightExpr;

            if (expression.includes('=')) {
                const parts = expression.split('=');
                leftExpr = parts[0].trim();
                rightExpr = parts[1].trim();
            } else {
                // Assume it equals 0
                leftExpr = expression.trim();
                rightExpr = '0';
            }

            const leftCompiled = math.compile(leftExpr);
            const rightCompiled = math.compile(rightExpr);

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
                        const diff = leftVal - rightVal;

                        xRow.push(xVal);
                        yRow.push(yVal);
                        zRow.push(diff);
                    } catch (e) {
                        xRow.push(xVal);
                        yRow.push(yVal);
                        zRow.push(NaN);
                    }
                }

                x.push(xRow);
                y.push(yRow);
                z.push(zRow);
            }

            return { x, y, z };
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
                            const compiled = math.compile(expression);
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

            // Replace 'and' with '&&' and 'or' with '||'
            let cond = condition.replace(/\band\b/g, '&&').replace(/\bor\b/g, '||');

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

            const leftCompiled = math.compile(leftExpr.trim());
            const rightCompiled = math.compile(rightExpr.trim());

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
            const compiled1 = math.compile(expr1);
            const compiled2 = math.compile(expr2);
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

        switch (expr.type) {
            case 'cartesian': {
                // Substitute parameters if they exist
                let expression = expr.expression;
                if (expr.parameters) {
                    Object.keys(expr.parameters).forEach(param => {
                        const regex = new RegExp(`\\b${param}\\b`, 'g');
                        expression = expression.replace(regex, expr.parameters[param]);
                    });
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
                        connectgaps: false
                    }];

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
                }
                break;
            }

            case 'implicit': {
                const data = this.generateImplicit(expr.expression, xMin, xMax, yMin, yMax);
                if (data) {
                    trace = {
                        x: data.x,
                        y: data.y,
                        z: data.z,
                        type: 'contour',
                        name: expr.expression,
                        colorscale: [[0, expr.color], [0.5, 'white'], [1, expr.color]],
                        showscale: false,
                        contours: {
                            start: 0,
                            end: 0,
                            size: 0.1,
                            coloring: 'lines'
                        },
                        line: {
                            width: 3,
                            color: expr.color
                        }
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

            case 'parametric': {
                const [xExpr, yExpr] = expr.expression.split(',').map(e => e.trim());
                const data = this.generateParametric(xExpr, yExpr);
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
                const data = this.generatePolar(expr.expression);
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
                const match = expr.expression.match(/(.+?)(>=|<=|>|<|=)(.+)/);
                if (match) {
                    const data = this.generateInequality(
                        match[1].trim(),
                        match[2],
                        match[3].trim(),
                        xMin, xMax, yMin, yMax
                    );
                    if (data) {
                        trace = {
                            x: data.x,
                            y: data.y,
                            z: data.z,
                            type: 'contour',
                            name: expr.expression,
                            colorscale: [[0, 'rgba(0,0,0,0)'], [1, expr.color]],
                            showscale: false,
                            contours: {
                                start: 0.5,
                                end: 1,
                                size: 0.5
                            },
                            opacity: 0.3
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
                const data = this.parseTableData(expr.expression);
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
        }

        return trace;
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
            if (expr.visible) {
                const trace = this.createTrace(expr, { xMin, xMax, yMin, yMax });

                if (trace) {
                    if (Array.isArray(trace)) {
                        traces.push(...trace);
                    } else {
                        traces.push(trace);
                    }
                }
            }
        }

        const layout = {
            title: '',
            xaxis: {
                title: 'x',
                range: [xMin, xMax],
                zeroline: true,
                showgrid: showGrid,
                gridcolor: '#e0e0e0'
            },
            yaxis: {
                title: 'y',
                range: [yMin, yMax],
                zeroline: true,
                showgrid: showGrid,
                gridcolor: '#e0e0e0',
                scaleanchor: 'x'
            },
            showlegend: showLegend,
            legend: {
                x: 1,
                xanchor: 'right',
                y: 1
            },
            hovermode: 'closest',
            plot_bgcolor: '#fafafa',
            paper_bgcolor: 'white'
        };

        const config = {
            responsive: true,
            displayModeBar: true,
            modeBarButtonsToRemove: ['lasso2d', 'select2d'],
            displaylogo: false
        };

        Plotly.newPlot(this.containerId, traces, layout, config);
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

    // Try to load from URL first
    loadFromURL();

    // If nothing loaded from URL, add default expression
    if (engine.expressions.length === 0) {
        addExpression();
    }

    // Update graph
    updateGraph();
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

        <select class="plot-type-select" id="type-${expr.id}" onchange="updateExpressionType(${expr.id})">
            <option value="cartesian">Cartesian (y = f(x))</option>
            <option value="parametric">Parametric (x(t), y(t))</option>
            <option value="polar">Polar (r(θ))</option>
            <option value="implicit">Implicit (x²+y²=25)</option>
            <option value="piecewise">Piecewise Function</option>
            <option value="inequality">Inequality</option>
            <option value="table">Table Data</option>
            <option value="statistics">Regression Analysis</option>
            <option value="distribution">Statistical Distribution</option>
        </select>

        <div class="controls">
            <input type="color" class="color-picker" id="color-${expr.id}"
                   value="${expr.color}" onchange="updateExpressionColor(${expr.id})">
            <div class="form-check form-check-inline ms-2">
                <input class="form-check-input" type="checkbox" id="show-derivative-${expr.id}" onchange="toggleDerivative(${expr.id})">
                <label class="form-check-label" for="show-derivative-${expr.id}" style="font-size: 12px;">Show f'(x)</label>
            </div>
            <div class="form-check form-check-inline ms-2">
                <input class="form-check-input" type="checkbox" id="show-integration-${expr.id}" onchange="toggleIntegration(${expr.id})">
                <label class="form-check-label" for="show-integration-${expr.id}" style="font-size: 12px;">Show ∫ Area</label>
            </div>
        </div>
        <div id="integration-controls-${expr.id}" style="display: none;" class="mt-2">
            <small class="text-muted">Integration bounds:</small>
            <div class="d-flex gap-2">
                <input type="number" class="form-control form-control-sm" id="integration-a-${expr.id}" placeholder="a" value="-2" step="0.5" oninput="updateIntegrationBounds(${expr.id})">
                <input type="number" class="form-control form-control-sm" id="integration-b-${expr.id}" placeholder="b" value="2" step="0.5" oninput="updateIntegrationBounds(${expr.id})">
            </div>
        </div>

        <div id="input-container-${expr.id}"></div>
        <div id="sliders-container-${expr.id}"></div>
    `;

    container.appendChild(div);
    expressionElements[expr.id] = div;

    createInputForType(expr.id, 'cartesian');
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
                       placeholder="e.g., x^2 or sin(x)" value="${currentValue}"
                       oninput="updateExpressionValue(${id})"
                       onchange="updateExpressionValue(${id})">
                <div class="preview-label">Preview:</div>
                <div class="math-preview" id="math-preview-${id}"></div>
                <div class="mt-2">
                    <small class="text-muted">Trigonometric:</small><br>
                    <button class="btn btn-sm btn-outline-secondary mt-1" onclick="loadSample(${id}, 'sin(x)')">sin(x)</button>
                    <button class="btn btn-sm btn-outline-secondary mt-1 ms-1" onclick="loadSample(${id}, 'cos(x)')">cos(x)</button>
                    <button class="btn btn-sm btn-outline-secondary mt-1 ms-1" onclick="loadSample(${id}, 'tan(x)')">tan(x)</button>
                    <button class="btn btn-sm btn-outline-secondary mt-1 ms-1" onclick="loadSample(${id}, 'cos(x)*sin(x)')">cos·sin</button>
                </div>
                <div class="mt-2">
                    <small class="text-muted">Polynomials:</small><br>
                    <button class="btn btn-sm btn-outline-secondary mt-1" onclick="loadSample(${id}, 'x^2')">x²</button>
                    <button class="btn btn-sm btn-outline-secondary mt-1 ms-1" onclick="loadSample(${id}, 'x^3')">x³</button>
                    <button class="btn btn-sm btn-outline-secondary mt-1 ms-1" onclick="loadSample(${id}, 'x^3 - 3*x^2 + 2*x')">Cubic</button>
                    <button class="btn btn-sm btn-outline-secondary mt-1 ms-1" onclick="loadSample(${id}, 'x^4 - 5*x^2 + 4')">x⁴</button>
                </div>
                <div class="mt-2">
                    <small class="text-muted">Other:</small><br>
                    <button class="btn btn-sm btn-outline-secondary mt-1" onclick="loadSample(${id}, 'sqrt(x)')">√x</button>
                    <button class="btn btn-sm btn-outline-secondary mt-1 ms-1" onclick="loadSample(${id}, 'abs(x)')">|x|</button>
                    <button class="btn btn-sm btn-outline-secondary mt-1 ms-1" onclick="loadSample(${id}, '1/x')">1/x</button>
                    <button class="btn btn-sm btn-outline-secondary mt-1 ms-1" onclick="loadSample(${id}, 'exp(x)')">eˣ</button>
                    <button class="btn btn-sm btn-outline-secondary mt-1 ms-1" onclick="loadSample(${id}, 'log(x)')">ln(x)</button>
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
                <div class="mt-2">
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'cos(t), sin(t)')">Circle</button>
                    <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadSample(${id}, 't*cos(t), t*sin(t)')">Spiral</button>
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
                <div class="mt-2">
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, '2 + 2*cos(theta)')">Heart</button>
                    <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadSample(${id}, '1 + cos(theta)')">Cardioid</button>
                    <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadSample(${id}, 'theta')">Spiral</button>
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
    updateGraph();
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
        previewElement.innerHTML = '<span style="color: #999;">Type an expression...</span>';
        return;
    }

    try {
        const latex = convertToLaTeX(expression);
        katex.render('y = ' + latex, previewElement, {
            throwOnError: false,
            displayMode: true  // Changed to true for better fraction display
        });
    } catch (error) {
        previewElement.innerHTML = `<span style="color: #666;">${expression}</span>`;
    }
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

    // Render math preview for cartesian expressions
    const expr = engine.expressions.find(e => e.id === id);
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

// Initialize when page loads
window.addEventListener('DOMContentLoaded', initGraph);

// Add event listeners for range changes
['xMin', 'xMax', 'yMin', 'yMax'].forEach(id => {
    window.addEventListener('DOMContentLoaded', () => {
        document.getElementById(id).addEventListener('change', updateGraph);
    });
});

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

    if (traceModeActive) {
        button.classList.remove('btn-secondary');
        button.classList.add('btn-success');
        button.innerHTML = '<i class="fas fa-crosshairs"></i> Trace Mode: ON';
        enableTraceMode();
    } else {
        button.classList.remove('btn-success');
        button.classList.add('btn-secondary');
        button.innerHTML = '<i class="fas fa-crosshairs"></i> Trace Mode';
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
                const compiledExpr = math.compile(expr.expression);
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
        const compiled = math.compile(expression);
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

    // Encode data to base64
    const jsonString = JSON.stringify(data);
    const base64 = btoa(jsonString);

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
        const jsonString = atob(decodeURIComponent(dataParam));
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
