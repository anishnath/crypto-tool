<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% String seoTitle="Trigonometric Graphs Calculator - Sin Cos Tan Graph Visualizer (Free)" ; String
        seoDescription="Interactive trig graphs visualizer. Adjust amplitude, frequency, phase shift for sin, cos, tan functions. See transformations in real-time. Free graphing calculator."
        ; String canonicalUrl="https://8gwifi.org/exams/visual-math/trig-graphs.jsp" ; StringBuilder extraHead=new StringBuilder();
        extraHead.append("\n<meta property=\"og:title\" content=\"Trig Graphs Visualizer - Interactive Sin Cos Tan\">");
        extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
        extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
        extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
        extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
        extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
        extraHead.append("\n<meta name=\"twitter:title\" content=\"Trig Graphs Visualizer\">");
        extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
        extraHead.append("\n<meta name=\"keywords\" content=\"trig graphs, trigonometric graphs, sin cos tan graph, sine wave, cosine graph, tangent graph, amplitude frequency phase shift, trig function calculator, graphing calculator\">");

        request.setAttribute("pageTitle", seoTitle);
        request.setAttribute("pageDescription", seoDescription);
        request.setAttribute("canonicalUrl", canonicalUrl);
        request.setAttribute("extraHeadContent", extraHead.toString());
    request.setAttribute("skipMathJax", "true");
        %>
        <%@ include file="../components/header.jsp" %>

            <link rel="stylesheet" href="<%=request.getContextPath()%>/exams/visual-math/visual-math.css">

            <div class="container">
                <!-- Breadcrumb -->
                <nav class="breadcrumb">
                    <a href="<%=request.getContextPath()%>/exams/">Exams</a>
                    <span class="breadcrumb-separator">/</span>
                    <a href="<%=request.getContextPath()%>/exams/visual-math/">Visual Math</a>
                    <span class="breadcrumb-separator">/</span>
                    <span class="breadcrumb-current">Trig Graphs</span>
                </nav>

                <!-- Header -->
                <div class="viz-header">
                    <h1>Trigonometric Graphs Visualizer</h1>
                    <p class="viz-subtitle">Explore sin, cos, and tan graphs with adjustable amplitude, frequency, and
                        phase shift. See how transformations affect the wave in real-time.</p>
                </div>

                <!-- Interactive Area -->
                <div class="viz-interactive">
                    <!-- Canvas -->
                    <div class="viz-canvas-wrap">
                        <div id="viz-canvas"></div>
                    </div>

                    <!-- Controls Panel -->
                    <div class="viz-panel">
                        <div class="viz-controls">
                            <h3>Function</h3>

                            <!-- Function Selector -->
                            <div class="control-group">
                                <label>Type</label>
                                <select id="function-select"
                                    style="width: 100%; padding: 8px; border-radius: 6px; border: 1px solid var(--border-primary); background: var(--bg-primary); color: var(--text-primary); font-size: var(--text-sm);">
                                    <option value="sin">sin(x)</option>
                                    <option value="cos">cos(x)</option>
                                    <option value="tan">tan(x)</option>
                                    <option value="all">All Three</option>
                                </select>
                            </div>

                            <!-- Amplitude -->
                            <div class="control-group">
                                <label>Amplitude (A)</label>
                                <div class="viz-slider-row">
                                    <input type="range" id="amplitude-slider" min="0.5" max="3" value="1" step="0.1">
                                    <span class="viz-slider-val" id="amplitude-display">1.0</span>
                                </div>
                            </div>

                            <!-- Frequency -->
                            <div class="control-group">
                                <label>Frequency (B)</label>
                                <div class="viz-slider-row">
                                    <input type="range" id="frequency-slider" min="0.5" max="4" value="1" step="0.1">
                                    <span class="viz-slider-val" id="frequency-display">1.0</span>
                                </div>
                            </div>

                            <!-- Phase Shift -->
                            <div class="control-group">
                                <label>Phase Shift (C)</label>
                                <div class="viz-slider-row">
                                    <input type="range" id="phase-slider" min="-3.14" max="3.14" value="0" step="0.1">
                                    <span class="viz-slider-val" id="phase-display">0.0</span>
                                </div>
                            </div>

                            <!-- Vertical Shift -->
                            <div class="control-group">
                                <label>Vertical Shift (D)</label>
                                <div class="viz-slider-row">
                                    <input type="range" id="vertical-slider" min="-2" max="2" value="0" step="0.1">
                                    <span class="viz-slider-val" id="vertical-display">0.0</span>
                                </div>
                            </div>

                            <!-- Show/Hide -->
                            <div class="control-group">
                                <label>Show</label>
                                <div class="viz-check-group">
                                    <label class="viz-check">
                                        <input type="checkbox" id="show-grid" checked>
                                        Grid
                                    </label>
                                    <label class="viz-check">
                                        <input type="checkbox" id="show-labels" checked>
                                        Labels
                                    </label>
                                </div>
                            </div>

                            <!-- Buttons -->
                            <div class="viz-btn-row">
                                <button class="viz-btn viz-btn-primary" id="reset-btn">Reset</button>
                            </div>
                        </div>

                        <!-- Values -->
                        <div class="viz-values">
                            <h3>Equation</h3>
                            <table>
                                <tr>
                                    <td>Formula</td>
                                    <td id="val-formula">y = sin(x)</td>
                                </tr>
                                <tr>
                                    <td>Period</td>
                                    <td id="val-period">2π</td>
                                </tr>
                                <tr>
                                    <td>Amplitude</td>
                                    <td id="val-amp">1.0</td>
                                </tr>
                                <tr>
                                    <td>Max</td>
                                    <td id="val-max">1.0</td>
                                </tr>
                                <tr>
                                    <td>Min</td>
                                    <td id="val-min">-1.0</td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Ad -->
                <%@ include file="../components/ad-leaderboard.jsp" %>

                    <!-- The Math Section -->
                    <section class="viz-math">
                        <h2>Understanding Trig Transformations</h2>
                        <div class="viz-math-grid">
                            <div class="viz-math-col">
                                <h3>General Form</h3>
                                <ul>
                                    <li>Standard form: <span class="formula-highlight">y = A·sin(B(x - C)) + D</span>
                                    </li>
                                    <li><strong>A</strong> = Amplitude (vertical stretch/compression)</li>
                                    <li><strong>B</strong> = Frequency (horizontal stretch/compression)</li>
                                    <li><strong>C</strong> = Phase shift (horizontal translation)</li>
                                    <li><strong>D</strong> = Vertical shift (vertical translation)</li>
                                </ul>

                                <h3 style="margin-top: var(--space-4);">Key Properties</h3>
                                <ul>
                                    <li>Period = <span class="formula-highlight">2π/B</span></li>
                                    <li>Maximum = <span class="formula-highlight">A + D</span></li>
                                    <li>Minimum = <span class="formula-highlight">-A + D</span></li>
                                    <li>Midline: <span class="formula-highlight">y = D</span></li>
                                </ul>
                            </div>

                            <div class="viz-math-col">
                                <h3>Function Characteristics</h3>
                                <table class="angles-table">
                                    <thead>
                                        <tr>
                                            <th>Function</th>
                                            <th>Period</th>
                                            <th>Range</th>
                                            <th>Zeros</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>sin(x)</td>
                                            <td>2π</td>
                                            <td>[-1, 1]</td>
                                            <td>nπ</td>
                                        </tr>
                                        <tr>
                                            <td>cos(x)</td>
                                            <td>2π</td>
                                            <td>[-1, 1]</td>
                                            <td>π/2 + nπ</td>
                                        </tr>
                                        <tr>
                                            <td>tan(x)</td>
                                            <td>π</td>
                                            <td>(-∞, ∞)</td>
                                            <td>nπ</td>
                                        </tr>
                                    </tbody>
                                </table>

                                <h3 style="margin-top: var(--space-4);">Applications</h3>
                                <ul>
                                    <li>Sound waves and acoustics</li>
                                    <li>Electromagnetic waves</li>
                                    <li>Oscillations and vibrations</li>
                                    <li>Circular motion</li>
                                    <li>Seasonal patterns</li>
                                </ul>
                            </div>
                        </div>
                    </section>

                    <!-- Related -->
    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-math/unit-circle.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(239,68,68,0.12);">&#9675;</div>
                <div><h4>Unit Circle</h4><span>Trigonometry</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/polar-coordinates.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(239,68,68,0.12);">&#10687;</div>
                <div><h4>Polar Coordinates</h4><span>Trigonometry</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#8943;</div>
                <div><h4>All Visualizations</h4><span>Browse</span></div>
            </a>
        </div>
    </section>
            </div>

            <!-- JSON-LD -->
            <script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "LearningResource",
    "name": "Trigonometric Graphs Visualizer",
    "description": "Interactive visualization of sin, cos, tan graphs with adjustable amplitude, frequency, phase shift, and vertical shift.",
    "url": "https://8gwifi.org/exams/visual-math/trig-graphs.jsp",
    "educationalLevel": "High School",
    "teaches": "Trigonometric functions, graph transformations, amplitude, frequency, phase shift",
    "learningResourceType": "Interactive visualization",
    "interactivityType": "active",
    "publisher": {
        "@type": "Organization",
        "name": "8gwifi.org"
    }
}
</script>
            <script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
        { "@type": "ListItem", "position": 1, "name": "Home", "item": "https://8gwifi.org/" },
        { "@type": "ListItem", "position": 2, "name": "Exams", "item": "https://8gwifi.org/exams/" },
        { "@type": "ListItem", "position": 3, "name": "Visual Math Lab", "item": "https://8gwifi.org/exams/visual-math/" },
        { "@type": "ListItem", "position": 4, "name": "Trig Graphs" }
    ]
}
</script>
            <script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
        {
            "@type": "Question",
            "name": "What is amplitude in trigonometric functions?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Amplitude is the vertical distance from the midline to the maximum (or minimum) of the wave. For y = A·sin(x), the amplitude is |A|. It determines how tall or short the wave is."
            }
        },
        {
            "@type": "Question",
            "name": "How do you find the period of a trig function?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The period of y = A·sin(Bx) is 2π/B for sine and cosine, and π/B for tangent. The period is the horizontal distance for one complete cycle of the wave."
            }
        },
        {
            "@type": "Question",
            "name": "What is phase shift in trigonometry?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Phase shift is the horizontal translation of a trig function. For y = sin(x - C), the graph shifts C units to the right. If C is negative, it shifts left."
            }
        }
    ]
}
</script>

<%@ include file="viz-ads.jsp" %>
            <%@ include file="../components/footer.jsp" %>

                <!-- p5.js + Visual Math -->
                <script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
                <script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
                <script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-trig-graphs.js"></script>
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        VisualMath.init('trig-graphs', 'viz-canvas', {
                            funcType: 'sin',
                            amplitude: 1,
                            frequency: 1,
                            phase: 0,
                            vertical: 0,
                            showGrid: true,
                            showLabels: true
                        });

                        // Function selector
                        document.getElementById('function-select').addEventListener('change', function () {
                            VisualMath.setState('funcType', this.value);
                        });

                        // Amplitude slider
                        var ampSlider = document.getElementById('amplitude-slider');
                        ampSlider.addEventListener('input', function () {
                            var val = parseFloat(this.value);
                            document.getElementById('amplitude-display').textContent = val.toFixed(1);
                            VisualMath.setState('amplitude', val);
                        });

                        // Frequency slider
                        var freqSlider = document.getElementById('frequency-slider');
                        freqSlider.addEventListener('input', function () {
                            var val = parseFloat(this.value);
                            document.getElementById('frequency-display').textContent = val.toFixed(1);
                            VisualMath.setState('frequency', val);
                        });

                        // Phase slider
                        var phaseSlider = document.getElementById('phase-slider');
                        phaseSlider.addEventListener('input', function () {
                            var val = parseFloat(this.value);
                            document.getElementById('phase-display').textContent = val.toFixed(1);
                            VisualMath.setState('phase', val);
                        });

                        // Vertical slider
                        var vertSlider = document.getElementById('vertical-slider');
                        vertSlider.addEventListener('input', function () {
                            var val = parseFloat(this.value);
                            document.getElementById('vertical-display').textContent = val.toFixed(1);
                            VisualMath.setState('vertical', val);
                        });

                        // Checkboxes
                        document.getElementById('show-grid').addEventListener('change', function () {
                            VisualMath.setState('showGrid', this.checked);
                        });
                        document.getElementById('show-labels').addEventListener('change', function () {
                            VisualMath.setState('showLabels', this.checked);
                        });

                        // Reset button
                        document.getElementById('reset-btn').addEventListener('click', function () {
                            ampSlider.value = 1;
                            freqSlider.value = 1;
                            phaseSlider.value = 0;
                            vertSlider.value = 0;
                            document.getElementById('amplitude-display').textContent = '1.0';
                            document.getElementById('frequency-display').textContent = '1.0';
                            document.getElementById('phase-display').textContent = '0.0';
                            document.getElementById('vertical-display').textContent = '0.0';
                            document.getElementById('function-select').value = 'sin';
                            VisualMath.setState('amplitude', 1);
                            VisualMath.setState('frequency', 1);
                            VisualMath.setState('phase', 0);
                            VisualMath.setState('vertical', 0);
                            VisualMath.setState('funcType', 'sin');
                        });
                    });
                </script>