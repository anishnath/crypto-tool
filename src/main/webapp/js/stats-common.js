/**
 * StatsCommon — Shared computation + UI helpers for all statistics tools
 * Exposed as window.StatsCommon
 */
(function() {
    'use strict';

    /* ===== Parsing ===== */

    /**
     * Parse numbers from text (comma, space, newline, tab separated)
     * @param {string} text
     * @returns {number[]}
     */
    function parseNumbers(text) {
        if (!text || !text.trim()) return [];
        return text.trim()
            .split(/[\s,;\t\n]+/)
            .map(function(s) { return parseFloat(s); })
            .filter(function(n) { return !isNaN(n) && isFinite(n); });
    }

    /* ===== Formatting ===== */

    /**
     * Format number with dp decimal places, strip trailing zeros
     */
    function fmt(n, dp) {
        if (n == null || isNaN(n)) return '—';
        dp = dp != null ? dp : 4;
        var s = n.toFixed(dp);
        // Strip trailing zeros after decimal
        if (s.indexOf('.') !== -1) {
            s = s.replace(/0+$/, '').replace(/\.$/, '');
        }
        return s;
    }

    /**
     * Format as percentage
     */
    function fmtPct(n, dp) {
        dp = dp != null ? dp : 2;
        return fmt(n * 100, dp) + '%';
    }

    /* ===== Computation: Descriptive ===== */

    function computeDescriptive(arr) {
        var n = arr.length;
        if (n === 0) return null;

        var sum = 0;
        var i;
        for (i = 0; i < n; i++) sum += arr[i];
        var mean = sum / n;

        var sorted = arr.slice().sort(function(a, b) { return a - b; });
        var median = computeMedian(sorted);
        var mode = computeMode(arr);

        var min = sorted[0];
        var max = sorted[n - 1];
        var range = max - min;

        // Sample variance (n-1)
        var ssq = 0;
        for (i = 0; i < n; i++) ssq += (arr[i] - mean) * (arr[i] - mean);
        var variance = n > 1 ? ssq / (n - 1) : 0;
        var variancePop = ssq / n;
        var sd = Math.sqrt(variance);
        var sdPop = Math.sqrt(variancePop);
        var sem = n > 0 ? sd / Math.sqrt(n) : 0;
        var cv = mean !== 0 ? (sd / Math.abs(mean)) * 100 : 0;

        return {
            n: n,
            sum: sum,
            mean: mean,
            median: median,
            mode: mode,
            min: min,
            max: max,
            range: range,
            variance: variance,
            variancePop: variancePop,
            sd: sd,
            sdPop: sdPop,
            sem: sem,
            cv: cv,
            sorted: sorted
        };
    }

    function computeMedian(sorted) {
        var n = sorted.length;
        if (n === 0) return 0;
        var mid = Math.floor(n / 2);
        return n % 2 !== 0 ? sorted[mid] : (sorted[mid - 1] + sorted[mid]) / 2;
    }

    function computeMode(arr) {
        var freq = {};
        var maxFreq = 0;
        var i;
        for (i = 0; i < arr.length; i++) {
            var key = String(arr[i]);
            freq[key] = (freq[key] || 0) + 1;
            if (freq[key] > maxFreq) maxFreq = freq[key];
        }
        if (maxFreq === 1) {
            return { modes: [], maxFreq: 1, description: 'No mode (all values unique)' };
        }
        var modes = [];
        for (var k in freq) {
            if (freq.hasOwnProperty(k) && freq[k] === maxFreq) {
                modes.push(parseFloat(k));
            }
        }
        modes.sort(function(a, b) { return a - b; });
        var desc = modes.length === 1 ? 'Unimodal: ' + fmt(modes[0]) :
                   modes.length === 2 ? 'Bimodal: ' + modes.map(function(m) { return fmt(m); }).join(', ') :
                   'Multimodal: ' + modes.map(function(m) { return fmt(m); }).join(', ');
        return { modes: modes, maxFreq: maxFreq, description: desc };
    }

    /* ===== Computation: Quartiles ===== */

    function computeQuartiles(sorted) {
        var n = sorted.length;
        if (n === 0) return null;

        var q1 = computePercentile(sorted, 25);
        var q2 = computePercentile(sorted, 50);
        var q3 = computePercentile(sorted, 75);
        var iqr = q3 - q1;
        var lowerFence = q1 - 1.5 * iqr;
        var upperFence = q3 + 1.5 * iqr;

        var outliers = [];
        for (var i = 0; i < n; i++) {
            if (sorted[i] < lowerFence || sorted[i] > upperFence) {
                outliers.push(sorted[i]);
            }
        }

        return {
            q1: q1,
            q2: q2,
            q3: q3,
            iqr: iqr,
            fiveNumber: [sorted[0], q1, q2, q3, sorted[n - 1]],
            lowerFence: lowerFence,
            upperFence: upperFence,
            outliers: outliers
        };
    }

    function computePercentile(sorted, p) {
        var n = sorted.length;
        if (n === 0) return 0;
        if (n === 1) return sorted[0];

        var pos = (n + 1) * (p / 100);
        if (pos <= 1) return sorted[0];
        if (pos >= n) return sorted[n - 1];

        var lower = Math.floor(pos) - 1;
        var upper = Math.ceil(pos) - 1;
        var frac = pos - Math.floor(pos);
        return sorted[lower] + frac * (sorted[upper] - sorted[lower]);
    }

    /* ===== Computation: Shape ===== */

    function computeShape(arr, mean, sd) {
        if (sd === 0 || arr.length < 3) {
            return {
                skewness: 0,
                excessKurtosis: 0,
                skewnessInterpretation: 'Insufficient data or zero variance',
                kurtosisInterpretation: 'Insufficient data or zero variance'
            };
        }
        var n = arr.length;
        var m3 = 0, m4 = 0;
        for (var i = 0; i < n; i++) {
            var z = (arr[i] - mean) / sd;
            m3 += z * z * z;
            m4 += z * z * z * z;
        }
        var skewness = m3 / n;
        var excessKurtosis = (m4 / n) - 3;

        return {
            skewness: skewness,
            excessKurtosis: excessKurtosis,
            skewnessInterpretation: interpretSkewness(skewness),
            kurtosisInterpretation: interpretKurtosis(excessKurtosis)
        };
    }

    function interpretSkewness(skew) {
        var abs = Math.abs(skew);
        if (abs < 0.5) return 'Approximately symmetric';
        if (abs < 1) return skew > 0 ? 'Moderately right-skewed' : 'Moderately left-skewed';
        return skew > 0 ? 'Highly right-skewed' : 'Highly left-skewed';
    }

    function interpretKurtosis(kurt) {
        if (Math.abs(kurt) < 0.5) return 'Approximately normal (mesokurtic)';
        if (kurt > 0) return 'Heavy-tailed / peaked (leptokurtic)';
        return 'Light-tailed / flat (platykurtic)';
    }

    /* ===== Computation: Frequency Distribution ===== */

    function computeFrequencyDist(sorted, numBins) {
        var n = sorted.length;
        if (n === 0) return [];

        var range = sorted[n - 1] - sorted[0];
        if (range === 0) {
            return [{
                lower: sorted[0], upper: sorted[0], midpoint: sorted[0],
                frequency: n, relativeFreq: 1, cumulativeFreq: n
            }];
        }

        if (!numBins) numBins = Math.ceil(Math.log2(n) + 1); // Sturges' rule
        var binWidth = range / numBins;
        var minVal = sorted[0];

        var bins = [];
        for (var i = 0; i < numBins; i++) {
            var lower = minVal + i * binWidth;
            var upper = minVal + (i + 1) * binWidth;
            bins.push({
                lower: lower,
                upper: upper,
                midpoint: (lower + upper) / 2,
                frequency: 0,
                relativeFreq: 0,
                cumulativeFreq: 0
            });
        }

        // Count frequencies
        for (var j = 0; j < n; j++) {
            var val = sorted[j];
            for (var k = 0; k < bins.length; k++) {
                if (k === bins.length - 1) {
                    if (val >= bins[k].lower && val <= bins[k].upper) { bins[k].frequency++; break; }
                } else {
                    if (val >= bins[k].lower && val < bins[k].upper) { bins[k].frequency++; break; }
                }
            }
        }

        // Relative and cumulative
        var cum = 0;
        for (var b = 0; b < bins.length; b++) {
            bins[b].relativeFreq = bins[b].frequency / n;
            cum += bins[b].frequency;
            bins[b].cumulativeFreq = cum;
        }

        return bins;
    }

    /* ===== UI Helpers ===== */

    function renderKaTeX(el, latex, displayMode) {
        if (window.katex && el) {
            try {
                window.katex.render(latex, el, {
                    displayMode: !!displayMode,
                    throwOnError: false,
                    strict: false
                });
            } catch (e) {
                el.textContent = latex;
            }
        }
    }

    function buildStepDOM(number, desc, latex) {
        var step = document.createElement('div');
        step.className = 'stat-step';

        var numEl = document.createElement('div');
        numEl.className = 'stat-step-number';
        numEl.textContent = number;
        step.appendChild(numEl);

        var content = document.createElement('div');
        content.className = 'stat-step-content';

        if (desc) {
            var descEl = document.createElement('div');
            descEl.className = 'stat-step-desc';
            descEl.textContent = desc;
            content.appendChild(descEl);
        }

        if (latex) {
            var mathEl = document.createElement('div');
            mathEl.className = 'stat-step-math';
            renderKaTeX(mathEl, latex, true);
            content.appendChild(mathEl);
        }

        step.appendChild(content);
        return step;
    }

    function buildStatRow(label, value) {
        var row = document.createElement('div');
        row.className = 'stat-row';

        var lbl = document.createElement('span');
        lbl.className = 'stat-label';
        lbl.textContent = label;
        row.appendChild(lbl);

        var val = document.createElement('span');
        val.className = 'stat-value';
        val.textContent = value;
        row.appendChild(val);

        return row;
    }

    function buildStatSection(title, rows) {
        var section = document.createElement('div');
        section.className = 'stat-section';

        var titleEl = document.createElement('div');
        titleEl.className = 'stat-section-title';
        titleEl.textContent = title;
        section.appendChild(titleEl);

        for (var i = 0; i < rows.length; i++) {
            section.appendChild(rows[i]);
        }
        return section;
    }

    function buildInterpretation(skew, kurt) {
        var isNormal = Math.abs(skew) < 0.5 && Math.abs(kurt) < 0.5;
        var box = document.createElement('div');
        box.className = 'stat-interpretation ' + (isNormal ? 'stat-interpretation-normal' : 'stat-interpretation-warning');

        var html = '<strong>Distribution Interpretation:</strong><br>';
        html += '<strong>Skewness:</strong> ' + interpretSkewness(skew) + ' (' + fmt(skew) + ')<br>';
        html += '<strong>Kurtosis:</strong> ' + interpretKurtosis(kurt) + ' (' + fmt(kurt) + ')';
        box.innerHTML = html;
        return box;
    }

    function showError(container, msg) {
        container.innerHTML = '';
        var err = document.createElement('div');
        err.className = 'stat-error';
        err.innerHTML = '<h4>Error</h4><p>' + escapeHtml(msg) + '</p>';
        container.appendChild(err);
    }

    function showEmpty(container, icon, title, desc) {
        container.innerHTML = '';
        var empty = document.createElement('div');
        empty.className = 'tool-empty-state';
        empty.innerHTML =
            '<div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">' + (icon || '&#x1F4CA;') + '</div>' +
            '<h3>' + escapeHtml(title || 'No results yet') + '</h3>' +
            '<p>' + escapeHtml(desc || 'Enter data and click Calculate') + '</p>';
        container.appendChild(empty);
    }

    function escapeHtml(str) {
        var div = document.createElement('div');
        div.appendChild(document.createTextNode(str));
        return div.innerHTML;
    }

    /* ===== Scroll Reveal Observer ===== */

    function initScrollReveal() {
        if (!('IntersectionObserver' in window)) {
            // Fallback: show all
            var els = document.querySelectorAll('.stat-anim');
            for (var i = 0; i < els.length; i++) els[i].classList.add('stat-visible');
            return;
        }
        var observer = new IntersectionObserver(function(entries) {
            for (var i = 0; i < entries.length; i++) {
                if (entries[i].isIntersecting) {
                    entries[i].target.classList.add('stat-visible');
                    observer.unobserve(entries[i].target);
                }
            }
        }, { threshold: 0.1 });

        var els = document.querySelectorAll('.stat-anim');
        for (var j = 0; j < els.length; j++) {
            observer.observe(els[j]);
        }
    }

    /* ===== Public API ===== */

    window.StatsCommon = {
        parseNumbers: parseNumbers,
        fmt: fmt,
        fmtPct: fmtPct,
        computeDescriptive: computeDescriptive,
        computeQuartiles: computeQuartiles,
        computePercentile: computePercentile,
        computeShape: computeShape,
        computeFrequencyDist: computeFrequencyDist,
        renderKaTeX: renderKaTeX,
        buildStepDOM: buildStepDOM,
        buildStatRow: buildStatRow,
        buildStatSection: buildStatSection,
        buildInterpretation: buildInterpretation,
        showError: showError,
        showEmpty: showEmpty,
        initScrollReveal: initScrollReveal
    };
})();
