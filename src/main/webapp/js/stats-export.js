/**
 * StatsExport — LaTeX, share URL, and Python code generation for statistics tools
 * Exposed as window.StatsExport
 */
(function() {
    'use strict';

    var C = window.StatsCommon;

    /* ===== LaTeX ===== */

    function buildLatex(toolName, stats) {
        if (!stats) return '';
        var lines = [];
        lines.push('\\textbf{' + toolName + '}\\\\[4pt]');
        lines.push('n = ' + stats.n + '\\\\');
        lines.push('\\bar{x} = ' + C.fmt(stats.mean) + '\\\\');
        lines.push('\\tilde{x} = ' + C.fmt(stats.median) + '\\\\');
        lines.push('s = ' + C.fmt(stats.sd) + '\\\\');
        lines.push('s^2 = ' + C.fmt(stats.variance) + '\\\\');
        lines.push('\\text{Range} = ' + C.fmt(stats.range) + '\\\\');
        if (stats.cv != null) lines.push('CV = ' + C.fmt(stats.cv, 2) + '\\%\\\\');
        if (stats.sem != null) lines.push('SEM = ' + C.fmt(stats.sem) + '\\\\');
        return lines.join('\n');
    }

    function copyLatex(toolName, stats) {
        var latex = buildLatex(toolName, stats);
        if (window.ToolUtils && window.ToolUtils.copyToClipboard) {
            window.ToolUtils.copyToClipboard(latex);
        } else if (navigator.clipboard) {
            navigator.clipboard.writeText(latex).then(function() {
                showCopyToast('LaTeX copied to clipboard');
            });
        }
    }

    /* ===== Share URL ===== */

    function buildShareUrl(state) {
        try {
            var json = JSON.stringify(state);
            var encoded = btoa(unescape(encodeURIComponent(json)));
            var url = window.location.origin + window.location.pathname + '?d=' + encoded;
            return url;
        } catch (e) {
            return '';
        }
    }

    function parseShareUrl() {
        try {
            var params = new URLSearchParams(window.location.search);
            var d = params.get('d');
            if (!d) return null;
            var json = decodeURIComponent(escape(atob(d)));
            return JSON.parse(json);
        } catch (e) {
            return null;
        }
    }

    function copyShareUrl(state) {
        var url = buildShareUrl(state);
        if (!url) return;
        if (window.ToolUtils && window.ToolUtils.copyToClipboard) {
            window.ToolUtils.copyToClipboard(url);
        } else if (navigator.clipboard) {
            navigator.clipboard.writeText(url).then(function() {
                showCopyToast('Share URL copied to clipboard');
            });
        }
    }

    /* ===== Python Code ===== */

    function buildPythonCode(toolName, data, options) {
        var dataStr = '[' + data.join(', ') + ']';
        var lines = [
            'import numpy as np',
            'from scipy import stats',
            '',
            '# ' + toolName,
            'data = np.array(' + dataStr + ')',
            '',
            '# Descriptive Statistics',
            'n = len(data)',
            'mean = np.mean(data)',
            'median = np.median(data)',
            'std_sample = np.std(data, ddof=1)',
            'std_pop = np.std(data, ddof=0)',
            'variance = np.var(data, ddof=1)',
            'sem = stats.sem(data)',
            'cv = (std_sample / abs(mean)) * 100 if mean != 0 else 0',
            '',
            '# Quartiles',
            'q1 = np.percentile(data, 25)',
            'q3 = np.percentile(data, 75)',
            'iqr = q3 - q1',
            '',
            '# Shape',
            'skewness = stats.skew(data)',
            'kurtosis = stats.kurtosis(data)',
            '',
            'print(f"n = {n}")',
            'print(f"Mean = {mean:.4f}")',
            'print(f"Median = {median:.4f}")',
            'print(f"Std Dev (sample) = {std_sample:.4f}")',
            'print(f"Variance = {variance:.4f}")',
            'print(f"SEM = {sem:.4f}")',
            'print(f"CV = {cv:.2f}%")',
            'print(f"Q1 = {q1:.4f}, Q3 = {q3:.4f}, IQR = {iqr:.4f}")',
            'print(f"Skewness = {skewness:.4f}")',
            'print(f"Kurtosis = {kurtosis:.4f}")',
            'print(f"Range = {np.max(data) - np.min(data):.4f}")',
            'print(f"Five-number summary: {np.min(data):.2f}, {q1:.2f}, {median:.2f}, {q3:.2f}, {np.max(data):.2f}")'
        ];

        if (options && options.histogram) {
            lines.push('');
            lines.push('# Visualization');
            lines.push('import matplotlib.pyplot as plt');
            lines.push('');
            lines.push('fig, axes = plt.subplots(1, 2, figsize=(12, 5))');
            lines.push('');
            lines.push('# Histogram');
            lines.push('axes[0].hist(data, bins="sturges", color="#e11d48", alpha=0.7, edgecolor="white")');
            lines.push('axes[0].set_title("Histogram")');
            lines.push('axes[0].set_xlabel("Value")');
            lines.push('axes[0].set_ylabel("Frequency")');
            lines.push('');
            lines.push('# Box Plot');
            lines.push('axes[1].boxplot(data, vert=True, patch_artist=True,');
            lines.push('    boxprops=dict(facecolor="#fff1f2", edgecolor="#e11d48"),');
            lines.push('    medianprops=dict(color="#e11d48", linewidth=2))');
            lines.push('axes[1].set_title("Box Plot")');
            lines.push('axes[1].set_ylabel("Value")');
            lines.push('');
            lines.push('plt.tight_layout()');
            lines.push('plt.show()');
        }

        return lines.join('\n');
    }

    function getCompilerUrl(template, state, contextPath) {
        var base = (contextPath || '') + '/onecompiler-embed.jsp';
        try {
            var b64Code = btoa(unescape(encodeURIComponent(template)));
            var config = JSON.stringify({ lang: 'python', code: b64Code });
            return base + '?c=' + encodeURIComponent(config);
        } catch (e) {
            return base;
        }
    }

    /* ===== Toast Helper ===== */

    function showCopyToast(msg) {
        if (window.ToolUtils && window.ToolUtils.showToast) {
            window.ToolUtils.showToast(msg, 'success');
        }
    }

    /* ===== Action Buttons Helper ===== */

    /**
     * Render Copy LaTeX + Share + Download buttons into resultActions container.
     * Automatically shows the container on render and hides on clear.
     *
     * @param {HTMLElement} container  — the result-actions div
     * @param {Object} opts
     * @param {string}   opts.toolName       — for popups, e.g. "ANOVA"
     * @param {Function} opts.getLatex       — returns LaTeX string (called on click)
     * @param {Function} opts.getShareState  — returns object to encode in share URL
     * @param {string|Element} opts.resultEl — CSS selector or element to capture as PNG (e.g. '#av-result-content')
     */
    function renderActionButtons(container, opts) {
        if (!container) return;
        opts = opts || {};

        container.innerHTML = '';

        // Copy LaTeX
        if (opts.getLatex) {
            var latexBtn = document.createElement('button');
            latexBtn.type = 'button';
            latexBtn.className = 'tool-action-btn';
            latexBtn.innerHTML = '&#128203; Copy LaTeX';
            latexBtn.addEventListener('click', function() {
                var latex = opts.getLatex();
                if (!latex) return;
                if (window.ToolUtils && window.ToolUtils.copyToClipboard) {
                    window.ToolUtils.copyToClipboard(latex);
                } else if (navigator.clipboard) {
                    navigator.clipboard.writeText(latex);
                    showCopyToast('LaTeX copied');
                }
            });
            container.appendChild(latexBtn);
        }

        // Share
        if (opts.getShareState) {
            var shareBtn = document.createElement('button');
            shareBtn.type = 'button';
            shareBtn.className = 'tool-action-btn';
            shareBtn.innerHTML = '&#128279; Share';
            shareBtn.addEventListener('click', function() {
                var st = opts.getShareState();
                if (st) copyShareUrl(st);
            });
            container.appendChild(shareBtn);
        }

        // Download as PNG (captures result DOM element via ToolUtils.downloadDomAsImage)
        if (opts.resultEl) {
            var dlBtn = document.createElement('button');
            dlBtn.type = 'button';
            dlBtn.className = 'tool-action-btn';
            dlBtn.innerHTML = '&#128247; Download PNG';
            dlBtn.addEventListener('click', function() {
                var TU = window.ToolUtils;
                if (!TU) return;
                var el = typeof opts.resultEl === 'string' ? document.querySelector(opts.resultEl) : opts.resultEl;
                if (!el) return;
                var fname = (opts.toolName || 'result').toLowerCase().replace(/[^a-z0-9]+/g, '-') + '.png';
                if (TU.downloadDomAsImage) {
                    TU.downloadDomAsImage(el, fname, {
                        toolName: opts.toolName,
                        backgroundColor: getComputedStyle(document.documentElement).getPropertyValue('--bg-primary').trim() || '#ffffff'
                    });
                } else if (TU.downloadCanvasAsImage) {
                    TU.downloadCanvasAsImage(el, fname, { toolName: opts.toolName });
                }
            });
            container.appendChild(dlBtn);
        }

        container.style.display = 'flex';
    }

    function hideActionButtons(container) {
        if (!container) return;
        container.innerHTML = '';
        container.style.display = 'none';
    }

    /* ===== Public API ===== */

    window.StatsExport = {
        buildLatex: buildLatex,
        copyLatex: copyLatex,
        buildShareUrl: buildShareUrl,
        parseShareUrl: parseShareUrl,
        copyShareUrl: copyShareUrl,
        buildPythonCode: buildPythonCode,
        getCompilerUrl: getCompilerUrl,
        renderActionButtons: renderActionButtons,
        hideActionButtons: hideActionButtons
    };
})();
