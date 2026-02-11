<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% String seoTitle="Box Plot & Histogram Calculator - Statistics Visualizer (Free)" ; String
        seoDescription="Create box plots and histograms from your data. Calculate quartiles, median, mean, outliers. Free statistics calculator with interactive visualization."
        ; String canonicalUrl="https://8gwifi.org/exams/visual-math/statistics-dashboard.jsp" ; StringBuilder extraHead=new StringBuilder();
        extraHead.append("\n<meta property=\"og:title\" content=\"Box Plot & Histogram Calculator - Statistics\">");
        extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
        extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
        extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
        extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
        extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
        extraHead.append("\n<meta name=\"twitter:title\" content=\"Box Plot & Histogram Calculator\">");
        extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
        extraHead.append("\n<meta name=\"keywords\" content=\"box plot calculator, histogram maker, statistics calculator, quartiles calculator, median calculator, outliers, IQR, data visualization\">");

        request.setAttribute("pageTitle", seoTitle);
        request.setAttribute("pageDescription", seoDescription);
        request.setAttribute("canonicalUrl", canonicalUrl);
        request.setAttribute("extraHeadContent", extraHead.toString());
    request.setAttribute("skipMathJax", "true");
        %>
        <%@ include file="../components/header.jsp" %>

            <link rel="stylesheet" href="<%=request.getContextPath()%>/exams/visual-math/visual-math.css">

            <div class="container">
                <nav class="breadcrumb">
                    <a href="<%=request.getContextPath()%>/exams/">Exams</a>
                    <span class="breadcrumb-separator">/</span>
                    <a href="<%=request.getContextPath()%>/exams/visual-math/">Visual Math</a>
                    <span class="breadcrumb-separator">/</span>
                    <span class="breadcrumb-current">Statistics Dashboard</span>
                </nav>

                <div class="viz-header">
                    <h1>Statistics Dashboard</h1>
                    <p class="viz-subtitle">Visualize your data with box plots and histograms. Calculate quartiles,
                        median, mean, and identify outliers.</p>
                </div>

                <div class="viz-interactive">
                    <div class="viz-canvas-wrap">
                        <div id="viz-canvas"></div>
                    </div>

                    <div class="viz-panel">
                        <div class="viz-controls">
                            <h3>Data Input</h3>

                            <div class="control-group">
                                <label>Enter Data (comma-separated)</label>
                                <textarea id="data-input" rows="4"
                                    placeholder="e.g., 12, 15, 18, 20, 22, 25, 28, 30, 35, 40"
                                    style="width: 100%; padding: 8px; border-radius: 6px; border: 1px solid var(--border-primary); background: var(--bg-primary); color: var(--text-primary); font-family: monospace;"></textarea>
                            </div>

                            <div class="control-group">
                                <label>Visualization</label>
                                <select id="viz-type"
                                    style="width: 100%; padding: 8px; border-radius: 6px; border: 1px solid var(--border-primary); background: var(--bg-primary); color: var(--text-primary);">
                                    <option value="box">Box Plot</option>
                                    <option value="histogram">Histogram</option>
                                    <option value="both">Both</option>
                                </select>
                            </div>

                            <div class="control-group">
                                <label>Histogram Bins</label>
                                <div class="viz-slider-row">
                                    <input type="range" id="bins-slider" min="5" max="20" value="10" step="1">
                                    <span class="viz-slider-val" id="bins-display">10</span>
                                </div>
                            </div>

                            <div class="control-group">
                                <label>Presets</label>
                                <div style="display:flex;flex-wrap:wrap;gap:6px;">
                                    <button class="vm-chip active" data-stat-preset="test-scores">Test Scores</button>
                                    <button class="vm-chip" data-stat-preset="heights">Heights (cm)</button>
                                    <button class="vm-chip" data-stat-preset="temperatures">Temperatures</button>
                                    <button class="vm-chip" data-stat-preset="salaries">Salaries (k)</button>
                                    <button class="vm-chip" data-stat-preset="dice-rolls">100 Dice Rolls</button>
                                </div>
                            </div>

                            <div class="viz-btn-row">
                                <button class="viz-btn viz-btn-primary" id="calculate-btn">Calculate</button>
                            </div>
                        </div>

                        <div class="viz-values">
                            <h3>Statistics</h3>
                            <table>
                                <tr>
                                    <td>Count (n)</td>
                                    <td id="val-count">--</td>
                                </tr>
                                <tr>
                                    <td>Min</td>
                                    <td id="val-min">--</td>
                                </tr>
                                <tr>
                                    <td>Q1</td>
                                    <td id="val-q1">--</td>
                                </tr>
                                <tr>
                                    <td>Median (Q2)</td>
                                    <td id="val-median">--</td>
                                </tr>
                                <tr>
                                    <td>Q3</td>
                                    <td id="val-q3">--</td>
                                </tr>
                                <tr>
                                    <td>Max</td>
                                    <td id="val-max">--</td>
                                </tr>
                                <tr>
                                    <td>Mean</td>
                                    <td id="val-mean">--</td>
                                </tr>
                                <tr>
                                    <td>IQR</td>
                                    <td id="val-iqr">--</td>
                                </tr>
                                <tr>
                                    <td>Outliers</td>
                                    <td id="val-outliers">--</td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>

                <%@ include file="../components/ad-leaderboard.jsp" %>

                    <section class="viz-math">
                        <h2>Understanding Box Plots & Histograms</h2>
                        <div class="viz-math-grid">
                            <div class="viz-math-col">
                                <h3>Box Plot (Box-and-Whisker)</h3>
                                <ul>
                                    <li><strong>Minimum</strong>: Smallest value (excluding outliers)</li>
                                    <li><strong>Q1</strong>: First quartile (25th percentile)</li>
                                    <li><strong>Median (Q2)</strong>: Middle value (50th percentile)</li>
                                    <li><strong>Q3</strong>: Third quartile (75th percentile)</li>
                                    <li><strong>Maximum</strong>: Largest value (excluding outliers)</li>
                                    <li><strong>IQR</strong>: Interquartile Range = Q3 - Q1</li>
                                </ul>

                                <h3 style="margin-top: var(--space-4);">Outlier Detection</h3>
                                <ul>
                                    <li>Lower fence: <span class="formula-highlight">Q1 - 1.5×IQR</span></li>
                                    <li>Upper fence: <span class="formula-highlight">Q3 + 1.5×IQR</span></li>
                                    <li>Values outside fences are outliers</li>
                                </ul>
                            </div>

                            <div class="viz-math-col">
                                <h3>Histogram</h3>
                                <ul>
                                    <li>Shows frequency distribution of data</li>
                                    <li>X-axis: Data values (bins/intervals)</li>
                                    <li>Y-axis: Frequency (count in each bin)</li>
                                    <li>Reveals shape: normal, skewed, bimodal</li>
                                </ul>

                                <h3 style="margin-top: var(--space-4);">Key Measures</h3>
                                <ul>
                                    <li><strong>Mean</strong>: Average = Σx / n</li>
                                    <li><strong>Median</strong>: Middle value when sorted</li>
                                    <li><strong>Range</strong>: Max - Min</li>
                                    <li><strong>Spread</strong>: How dispersed the data is</li>
                                </ul>

                                <h3 style="margin-top: var(--space-4);">Applications</h3>
                                <ul>
                                    <li>Test score analysis</li>
                                    <li>Quality control</li>
                                    <li>Market research</li>
                                    <li>Scientific data analysis</li>
                                </ul>
                            </div>
                        </div>
                    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-math/normal-distribution.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(147,51,234,0.12);">&#119977;</div>
                <div><h4>Normal Distribution</h4><span>Statistics</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/regression-scatter.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(147,51,234,0.12);">&#8226;</div>
                <div><h4>Regression &amp; Scatter</h4><span>Statistics</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#8943;</div>
                <div><h4>All Visualizations</h4><span>Browse</span></div>
            </a>
        </div>
    </section>
            </div>

            <script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "LearningResource",
    "name": "Box Plot & Histogram Calculator",
    "description": "Interactive statistics dashboard for creating box plots and histograms. Calculate quartiles, median, mean, and identify outliers.",
    "url": "https://8gwifi.org/exams/visual-math/statistics-dashboard.jsp",
    "educationalLevel": "High School",
    "teaches": "Box plots, histograms, quartiles, median, outliers, data visualization",
    "learningResourceType": "Interactive calculator",
    "interactivityType": "active",
    "publisher": {"@type": "Organization", "name": "8gwifi.org"}
}
</script>

<%@ include file="viz-ads.jsp" %>
            <%@ include file="../components/footer.jsp" %>

                <script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
                <script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
                <script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-statistics.js"></script>
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        VisualMath.init('statistics', 'viz-canvas', {
                            vizType: 'box',
                            bins: 10
                        });

                        var statPresets = {
                            'test-scores':  { label: 'Test Scores',    data: '45, 52, 58, 62, 65, 68, 70, 72, 74, 75, 78, 80, 82, 84, 85, 88, 90, 92, 95, 98' },
                            'heights':      { label: 'Heights (cm)',   data: '152, 155, 158, 160, 162, 163, 165, 166, 167, 168, 170, 171, 172, 174, 175, 178, 180, 183, 185, 190' },
                            'temperatures': { label: 'Temperatures',   data: '12, 14, 15, 16, 18, 19, 20, 21, 22, 22, 23, 24, 25, 26, 27, 28, 30, 32, 35, 38' },
                            'salaries':     { label: 'Salaries (k)',   data: '32, 35, 38, 40, 42, 45, 48, 50, 52, 55, 58, 60, 65, 70, 75, 80, 90, 105, 120, 150' },
                            'dice-rolls':   { label: '100 Dice Rolls', data: '1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6, 2, 3, 4, 5' }
                        };

                        function loadStatPreset(key) {
                            var p = statPresets[key];
                            document.getElementById('data-input').value = p.data;
                            var nums = p.data.split(',').map(function (x) { return parseFloat(x.trim()); });
                            VisualMath.getState()._setData(nums);
                            document.querySelectorAll('[data-stat-preset]').forEach(function (btn) {
                                btn.classList.toggle('active', btn.getAttribute('data-stat-preset') === key);
                            });
                        }

                        // Preset chip clicks
                        document.querySelectorAll('[data-stat-preset]').forEach(function (btn) {
                            btn.addEventListener('click', function () {
                                loadStatPreset(this.getAttribute('data-stat-preset'));
                            });
                        });

                        document.getElementById('viz-type').addEventListener('change', function () {
                            VisualMath.setState('vizType', this.value);
                            VisualMath.getState()._redraw();
                        });

                        document.getElementById('bins-slider').addEventListener('input', function () {
                            var val = parseInt(this.value);
                            document.getElementById('bins-display').textContent = val;
                            VisualMath.setState('bins', val);
                            VisualMath.getState()._redraw();
                        });

                        document.getElementById('calculate-btn').addEventListener('click', function () {
                            var input = document.getElementById('data-input').value;
                            var data = input.split(',').map(function (x) { return parseFloat(x.trim()); }).filter(function (x) { return !isNaN(x); });
                            if (data.length < 2) {
                                alert('Please enter at least 2 numbers');
                                return;
                            }
                            document.querySelectorAll('[data-stat-preset]').forEach(function (btn) { btn.classList.remove('active'); });
                            VisualMath.getState()._setData(data);
                        });

                        // Load first preset on page open
                        loadStatPreset('test-scores');
                    });
                </script>