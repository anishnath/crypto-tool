/**
 * Physics Formula Calculators — interactive "Try It Yourself" widgets
 * Renders sliders, live computation, and function-plot graph.
 * Usage: PhysicsCalculators.render(containerEl, config)
 *
 * config shape:
 * {
 *   title: "Coulomb's Law Calculator",
 *   formula_display: "F = k × |q₁ × q₂| / r²",
 *   inputs: [ { id, label, unit, default, min, max, step, exponent? } ],
 *   constants: { k: 8.9875e9 },
 *   compute: "k * abs(q1 * q2) / (r * r)",
 *   output: { label, unit, precision },
 *   direction_rule: "q1 * q2 > 0 ? 'Repulsive ↔' : 'Attractive →←'",
 *   plot: { vary, range, points, xLabel, yLabel }
 * }
 */
var PhysicsCalculators = (function() {
    'use strict';

    // Safe math evaluator — only our own JSON configs, not user input
    var mathFns = {
        abs: Math.abs, sqrt: Math.sqrt, cbrt: Math.cbrt,
        sin: Math.sin, cos: Math.cos, tan: Math.tan,
        asin: Math.asin, acos: Math.acos, atan: Math.atan,
        log: Math.log, log10: Math.log10, exp: Math.exp,
        pow: Math.pow, PI: Math.PI, pi: Math.PI,
        e: Math.E, max: Math.max, min: Math.min
    };

    function evaluate(expr, vars) {
        var allVars = {};
        var k;
        for (k in mathFns) allVars[k] = mathFns[k];
        for (k in vars) allVars[k] = vars[k];
        var keys = Object.keys(allVars);
        var vals = keys.map(function(key) { return allVars[key]; });
        try {
            var fn = new Function(keys.join(','), 'return (' + expr + ');');
            return fn.apply(null, vals);
        } catch (e) {
            return NaN;
        }
    }

    // Format number in scientific notation
    function formatSci(val, precision) {
        precision = precision || 4;
        if (val === 0) return '0';
        if (isNaN(val) || !isFinite(val)) return 'undefined';
        var absVal = Math.abs(val);
        if (absVal >= 0.01 && absVal < 10000) {
            return val.toPrecision(precision);
        }
        return val.toExponential(precision);
    }

    // Format slider value for display
    function formatSliderVal(val, input) {
        if (input.exponent) {
            // Show as a × 10^b format
            if (val === 0) return '0 ' + (input.unit || '');
            var exp = Math.floor(Math.log10(Math.abs(val)));
            var mantissa = val / Math.pow(10, exp);
            if (Math.abs(mantissa) < 1) { mantissa *= 10; exp--; }
            if (Math.abs(mantissa) >= 10) { mantissa /= 10; exp++; }
            return mantissa.toFixed(2) + ' × 10' + superscript(exp) + ' ' + (input.unit || '');
        }
        // Normal display
        if (Math.abs(val) >= 0.01 && Math.abs(val) < 10000) {
            // Try to show reasonable decimals
            var decimals = countDecimals(input.step || 0.01);
            return val.toFixed(Math.min(decimals, 4)) + ' ' + (input.unit || '');
        }
        return val.toExponential(2) + ' ' + (input.unit || '');
    }

    function countDecimals(num) {
        var str = String(num);
        if (str.indexOf('e') > -1) {
            var parts = str.split('e');
            return Math.abs(parseInt(parts[1]));
        }
        if (str.indexOf('.') > -1) return str.split('.')[1].length;
        return 0;
    }

    function superscript(n) {
        var sup = { '0': '⁰', '1': '¹', '2': '²', '3': '³', '4': '⁴',
                    '5': '⁵', '6': '⁶', '7': '⁷', '8': '⁸', '9': '⁹', '-': '⁻' };
        return String(n).split('').map(function(c) { return sup[c] || c; }).join('');
    }

    // For exponent-based sliders, we map linearly in log space
    function logSliderToValue(sliderVal, min, max) {
        var logMin = Math.log10(Math.abs(min) || 1e-20);
        var logMax = Math.log10(Math.abs(max) || 1e-20);
        var logVal = logMin + (sliderVal / 1000) * (logMax - logMin);
        var sign = min < 0 ? -1 : 1;
        return sign * Math.pow(10, logVal);
    }

    function valueToLogSlider(val, min, max) {
        var logMin = Math.log10(Math.abs(min) || 1e-20);
        var logMax = Math.log10(Math.abs(max) || 1e-20);
        var logVal = Math.log10(Math.abs(val) || 1e-20);
        return Math.round(((logVal - logMin) / (logMax - logMin)) * 1000);
    }

    // Dark mode helpers
    function isDark() {
        return document.documentElement.getAttribute('data-theme') === 'dark' ||
               window.matchMedia('(prefers-color-scheme: dark)').matches;
    }

    // --- Main render function ---
    function render(containerEl, config) {
        if (!config || !config.inputs || !config.compute) return;

        var constants = config.constants || {};
        var sliders = {};
        var currentValues = {};

        // Initialize values
        config.inputs.forEach(function(inp) {
            currentValues[inp.id] = inp.default;
        });
        for (var ck in constants) {
            currentValues[ck] = constants[ck];
        }

        // Build HTML
        var html = '';

        // Header
        html += '<div class="calc-header">';
        html += '<span class="calc-icon">&#129518;</span>';
        html += '<span class="calc-title">' + (config.title || 'Try It Yourself') + '</span>';
        html += '</div>';

        // Formula display
        if (config.formula_display) {
            html += '<div class="calc-formula">' + config.formula_display + '</div>';
        }

        // Sliders grid
        html += '<div class="calc-sliders">';
        config.inputs.forEach(function(inp) {
            var sliderId = containerEl.id + '_slider_' + inp.id;
            var valId = containerEl.id + '_val_' + inp.id;

            html += '<div class="calc-slider-group">';
            html += '<div class="calc-slider-label">';
            html += '<span>' + inp.label + '</span>';
            html += '<span class="calc-slider-value" id="' + valId + '">' + formatSliderVal(inp.default, inp) + '</span>';
            html += '</div>';

            if (inp.exponent) {
                // Log-scale slider (0-1000 mapped to log range)
                var sliderPos = valueToLogSlider(inp.default, inp.min, inp.max);
                html += '<input type="range" class="calc-range" id="' + sliderId + '"';
                html += ' min="0" max="1000" step="1" value="' + sliderPos + '"';
                html += ' data-input-id="' + inp.id + '" data-log="true"';
                html += ' data-log-min="' + inp.min + '" data-log-max="' + inp.max + '">';
            } else {
                html += '<input type="range" class="calc-range" id="' + sliderId + '"';
                html += ' min="' + inp.min + '" max="' + inp.max + '"';
                html += ' step="' + (inp.step || 0.01) + '" value="' + inp.default + '"';
                html += ' data-input-id="' + inp.id + '">';
            }

            html += '</div>';
        });
        html += '</div>';

        // Result box
        var resultId = containerEl.id + '_result';
        var directionId = containerEl.id + '_direction';
        html += '<div class="calc-result-box" id="' + resultId + '_box">';
        html += '<div class="calc-result-header">';
        html += '<span class="calc-result-icon">&#10003;</span>';
        html += '<span class="calc-result-label">' + (config.output.label || 'Result') + '</span>';
        html += '</div>';
        html += '<div class="calc-result-value" id="' + resultId + '">—</div>';
        if (config.direction_rule) {
            html += '<div class="calc-result-direction" id="' + directionId + '"></div>';
        }
        html += '</div>';

        // Plot container
        if (config.plot) {
            var plotId = containerEl.id + '_plot';
            html += '<div class="calc-plot-wrapper">';
            html += '<div class="calc-plot-title">' + (config.output.label || 'Result') + ' vs ' + (config.plot.xLabel || config.plot.vary) + '</div>';
            html += '<div class="calc-plot-target" id="' + plotId + '"></div>';
            html += '</div>';
        }

        // Reset button
        html += '<div class="calc-reset-row">';
        html += '<button class="calc-reset-btn" id="' + containerEl.id + '_reset">Reset to Original Values</button>';
        html += '</div>';

        containerEl.innerHTML = html;

        // --- Wire up event handlers ---
        function updateResult() {
            var result = evaluate(config.compute, currentValues);
            var resultEl = document.getElementById(resultId);
            if (resultEl) {
                resultEl.textContent = formatSci(result, config.output.precision || 4) + ' ' + (config.output.unit || '');
            }

            // Direction
            if (config.direction_rule) {
                var dirEl = document.getElementById(directionId);
                if (dirEl) {
                    try {
                        dirEl.textContent = evaluate(config.direction_rule, currentValues);
                    } catch (e) {
                        dirEl.textContent = '';
                    }
                }
            }

            // Update plot
            if (config.plot) {
                updatePlot();
            }
        }

        function updatePlot() {
            var plotId = containerEl.id + '_plot';
            var plotEl = document.getElementById(plotId);
            if (!plotEl || !window.functionPlot) return;

            var pc = config.plot;
            var vary = pc.vary;
            var range = pc.range || [0.05, 1.0];
            var pts = pc.points || 50;

            // Build function string by substituting current constant values
            var fnExpr = config.compute;
            for (var k in currentValues) {
                if (k === vary) continue;
                // Replace variable with its current numeric value
                var re = new RegExp('\\b' + k + '\\b', 'g');
                fnExpr = fnExpr.replace(re, '(' + currentValues[k] + ')');
            }
            // Replace our vary variable with 'x' for function-plot
            var reVary = new RegExp('\\b' + vary + '\\b', 'g');
            fnExpr = fnExpr.replace(reVary, 'x');

            // Compute y range by sampling
            var yVals = [];
            var step = (range[1] - range[0]) / pts;
            for (var i = 0; i <= pts; i++) {
                var xv = range[0] + i * step;
                var testVars = {};
                for (var vk in currentValues) testVars[vk] = currentValues[vk];
                testVars[vary] = xv;
                var yv = evaluate(config.compute, testVars);
                if (isFinite(yv)) yVals.push(yv);
            }
            var yMin = Math.min.apply(null, yVals);
            var yMax = Math.max.apply(null, yVals);
            var yPad = (yMax - yMin) * 0.1 || 1;

            try {
                functionPlot({
                    target: '#' + plotId,
                    width: plotEl.offsetWidth || 400,
                    height: 220,
                    grid: true,
                    xAxis: { domain: range, label: pc.xLabel || vary },
                    yAxis: { domain: [Math.max(0, yMin - yPad), yMax + yPad] },
                    data: [{
                        fn: fnExpr,
                        color: '#6366f1',
                        range: range
                    }],
                    annotations: [{
                        x: currentValues[vary],
                        text: vary + ' = ' + formatSci(currentValues[vary], 3)
                    }]
                });
            } catch (e) {
                // function-plot may fail on some expressions
            }
        }

        // Attach slider listeners
        config.inputs.forEach(function(inp) {
            var sliderId = containerEl.id + '_slider_' + inp.id;
            var valId = containerEl.id + '_val_' + inp.id;
            var sliderEl = document.getElementById(sliderId);
            if (!sliderEl) return;

            sliderEl.addEventListener('input', function() {
                var val;
                if (sliderEl.dataset.log === 'true') {
                    val = logSliderToValue(
                        parseFloat(sliderEl.value),
                        parseFloat(sliderEl.dataset.logMin),
                        parseFloat(sliderEl.dataset.logMax)
                    );
                } else {
                    val = parseFloat(sliderEl.value);
                }
                currentValues[inp.id] = val;
                var valEl = document.getElementById(valId);
                if (valEl) valEl.textContent = formatSliderVal(val, inp);
                updateResult();
            });

            sliders[inp.id] = sliderEl;
        });

        // Reset button
        var resetBtn = document.getElementById(containerEl.id + '_reset');
        if (resetBtn) {
            resetBtn.addEventListener('click', function() {
                config.inputs.forEach(function(inp) {
                    currentValues[inp.id] = inp.default;
                    var sliderId = containerEl.id + '_slider_' + inp.id;
                    var valId = containerEl.id + '_val_' + inp.id;
                    var sliderEl = document.getElementById(sliderId);
                    var valEl = document.getElementById(valId);
                    if (sliderEl) {
                        if (sliderEl.dataset.log === 'true') {
                            sliderEl.value = valueToLogSlider(inp.default, inp.min, inp.max);
                        } else {
                            sliderEl.value = inp.default;
                        }
                    }
                    if (valEl) valEl.textContent = formatSliderVal(inp.default, inp);
                });
                updateResult();
            });
        }

        // Initial computation
        updateResult();
    }

    return {
        render: render,
        evaluate: evaluate
    };
})();
