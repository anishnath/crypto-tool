<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% String seoTitle="Pythagorean Theorem Calculator with Visual Proof - Interactive a²+b²=c² (Free)" ; String
        seoDescription="Interactive Pythagorean theorem calculator with animated visual proof. Drag triangle sides to see a²+b²=c² in action. Calculate missing sides instantly. Free online tool."
        ; String canonicalUrl="https://8gwifi.org/exams/visual-math/pythagorean-theorem.jsp" ; StringBuilder extraHead=new StringBuilder();
        extraHead.append("\n<meta property=\"og:title\" content=\"Pythagorean Theorem Calculator - Visual Proof\">");
        extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
        extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
        extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
        extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
        extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
        extraHead.append("\n<meta name=\"twitter:title\" content=\"Pythagorean Theorem Calculator - Visual Proof\">");
        extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
        extraHead.append("\n<meta name=\"keywords\" content=\"pythagorean theorem calculator, pythagorean theorem, a squared plus b squared equals c squared, right triangle calculator, hypotenuse calculator, pythagorean theorem proof, visual pythagorean theorem, interactive geometry\">");

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
                    <span class="breadcrumb-current">Pythagorean Theorem</span>
                </nav>

                <!-- Header -->
                <div class="viz-header">
                    <h1>Pythagorean Theorem Visualizer</h1>
                    <p class="viz-subtitle">Drag the triangle vertices to explore a²+b²=c². Watch the squares on each
                        side prove the theorem visually in real-time.</p>
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
                            <h3>Controls</h3>

                            <!-- Side A Slider -->
                            <div class="control-group">
                                <label>Side a</label>
                                <div class="viz-slider-row">
                                    <input type="range" id="side-a-slider" min="3" max="12" value="6" step="0.5">
                                    <span class="viz-slider-val" id="side-a-display">6.0</span>
                                </div>
                            </div>

                            <!-- Side B Slider -->
                            <div class="control-group">
                                <label>Side b</label>
                                <div class="viz-slider-row">
                                    <input type="range" id="side-b-slider" min="3" max="12" value="8" step="0.5">
                                    <span class="viz-slider-val" id="side-b-display">8.0</span>
                                </div>
                            </div>

                            <!-- Show/Hide -->
                            <div class="control-group">
                                <label>Show</label>
                                <div class="viz-check-group">
                                    <label class="viz-check">
                                        <input type="checkbox" id="show-squares" checked>
                                        Squares
                                    </label>
                                    <label class="viz-check">
                                        <input type="checkbox" id="show-labels" checked>
                                        Labels
                                    </label>
                                    <label class="viz-check">
                                        <input type="checkbox" id="show-grid">
                                        Grid
                                    </label>
                                </div>
                            </div>

                            <!-- Buttons -->
                            <div class="viz-btn-row">
                                <button class="viz-btn viz-btn-primary" id="famous-btn">3-4-5</button>
                                <button class="viz-btn viz-btn-secondary" id="reset-btn">Reset</button>
                            </div>
                        </div>

                        <!-- Values -->
                        <div class="viz-values">
                            <h3>Calculations</h3>
                            <table>
                                <tr>
                                    <td>a</td>
                                    <td id="val-a">6.0</td>
                                </tr>
                                <tr>
                                    <td>b</td>
                                    <td id="val-b">8.0</td>
                                </tr>
                                <tr>
                                    <td>c</td>
                                    <td id="val-c">10.0</td>
                                </tr>
                                <tr>
                                    <td>a²</td>
                                    <td id="val-a2">36.0</td>
                                </tr>
                                <tr>
                                    <td>b²</td>
                                    <td id="val-b2">64.0</td>
                                </tr>
                                <tr>
                                    <td>c²</td>
                                    <td id="val-c2">100.0</td>
                                </tr>
                                <tr>
                                    <td>a²+b²</td>
                                    <td id="val-sum">100.0</td>
                                </tr>
                                <tr>
                                    <td>Verified</td>
                                    <td id="val-check">✓</td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Ad -->
                <%@ include file="../components/ad-leaderboard.jsp" %>

                    <!-- The Math Section -->
                    <section class="viz-math">
                        <h2>The Math Behind It</h2>
                        <div class="viz-math-grid">
                            <div class="viz-math-col">
                                <h3>The Theorem</h3>
                                <ul>
                                    <li>For any right triangle: <span class="formula-highlight">a² + b² = c²</span></li>
                                    <li><strong>a</strong> and <strong>b</strong> are the legs (sides forming the right
                                        angle)</li>
                                    <li><strong>c</strong> is the hypotenuse (longest side, opposite the right angle)
                                    </li>
                                    <li>Only works for right triangles (one 90° angle)</li>
                                </ul>

                                <h3 style="margin-top: var(--space-4);">Visual Proof</h3>
                                <ul>
                                    <li>The square on side <strong>a</strong> has area a²</li>
                                    <li>The square on side <strong>b</strong> has area b²</li>
                                    <li>The square on the hypotenuse <strong>c</strong> has area c²</li>
                                    <li>The sum of the two smaller squares equals the largest square</li>
                                </ul>
                            </div>

                            <div class="viz-math-col">
                                <h3>Famous Pythagorean Triples</h3>
                                <table class="angles-table">
                                    <thead>
                                        <tr>
                                            <th>a</th>
                                            <th>b</th>
                                            <th>c</th>
                                            <th>Type</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr class="clickable-angle" data-a="3" data-b="4">
                                            <td>3</td>
                                            <td>4</td>
                                            <td>5</td>
                                            <td>Basic</td>
                                        </tr>
                                        <tr class="clickable-angle" data-a="5" data-b="12">
                                            <td>5</td>
                                            <td>12</td>
                                            <td>13</td>
                                            <td>Basic</td>
                                        </tr>
                                        <tr class="clickable-angle" data-a="8" data-b="15">
                                            <td>8</td>
                                            <td>15</td>
                                            <td>17</td>
                                            <td>Basic</td>
                                        </tr>
                                        <tr class="clickable-angle" data-a="7" data-b="24">
                                            <td>7</td>
                                            <td>24</td>
                                            <td>25</td>
                                            <td>Basic</td>
                                        </tr>
                                        <tr class="clickable-angle" data-a="6" data-b="8">
                                            <td>6</td>
                                            <td>8</td>
                                            <td>10</td>
                                            <td>3-4-5 × 2</td>
                                        </tr>
                                        <tr class="clickable-angle" data-a="9" data-b="12">
                                            <td>9</td>
                                            <td>12</td>
                                            <td>15</td>
                                            <td>3-4-5 × 3</td>
                                        </tr>
                                    </tbody>
                                </table>
                                <p
                                    style="font-size: var(--text-xs); color: var(--text-muted); margin-top: var(--space-2);">
                                    Click any row to set that triple</p>
                            </div>
                        </div>
                    </section>

                    <!-- Related -->
    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-math/triangle-solver.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(236,72,153,0.12);">&#9651;</div>
                <div><h4>Triangle Solver</h4><span>Geometry</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/circle-theorems.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(236,72,153,0.12);">&#9675;</div>
                <div><h4>Circle Theorems</h4><span>Geometry</span></div>
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
    "name": "Pythagorean Theorem Visualizer",
    "description": "Interactive visualization showing the Pythagorean theorem a²+b²=c² with visual proof using squares.",
    "url": "https://8gwifi.org/exams/visual-math/pythagorean-theorem.jsp",
    "educationalLevel": "Middle School, High School",
    "teaches": "Pythagorean theorem, right triangle properties, geometric proof",
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
        { "@type": "ListItem", "position": 4, "name": "Pythagorean Theorem" }
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
            "name": "What is the Pythagorean theorem?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The Pythagorean theorem states that in a right triangle, the square of the hypotenuse (c) equals the sum of squares of the other two sides: a² + b² = c². This fundamental relationship only applies to right triangles."
            }
        },
        {
            "@type": "Question",
            "name": "How do you calculate the hypotenuse?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "To find the hypotenuse c, use the formula c = √(a² + b²). Square both legs, add them together, then take the square root of the sum."
            }
        },
        {
            "@type": "Question",
            "name": "What are Pythagorean triples?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Pythagorean triples are sets of three positive integers (a, b, c) that satisfy a² + b² = c². The most famous is 3-4-5. Other examples include 5-12-13, 8-15-17, and multiples of these basic triples."
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
                <script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-pythagorean.js"></script>
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        // Initialize the Pythagorean theorem visualization
                        VisualMath.init('pythagorean', 'viz-canvas', {
                            showSquares: true,
                            showLabels: true,
                            showGrid: false
                        });

                        // Side A slider
                        var sliderA = document.getElementById('side-a-slider');
                        sliderA.addEventListener('input', function () {
                            var val = parseFloat(this.value);
                            document.getElementById('side-a-display').textContent = val.toFixed(1);
                            VisualMath.getState()._setSideA(val);
                        });

                        // Side B slider
                        var sliderB = document.getElementById('side-b-slider');
                        sliderB.addEventListener('input', function () {
                            var val = parseFloat(this.value);
                            document.getElementById('side-b-display').textContent = val.toFixed(1);
                            VisualMath.getState()._setSideB(val);
                        });

                        // Checkboxes
                        document.getElementById('show-squares').addEventListener('change', function () {
                            VisualMath.setState('showSquares', this.checked);
                        });
                        document.getElementById('show-labels').addEventListener('change', function () {
                            VisualMath.setState('showLabels', this.checked);
                        });
                        document.getElementById('show-grid').addEventListener('change', function () {
                            VisualMath.setState('showGrid', this.checked);
                        });

                        // Famous 3-4-5 button
                        document.getElementById('famous-btn').addEventListener('click', function () {
                            sliderA.value = 3;
                            sliderB.value = 4;
                            document.getElementById('side-a-display').textContent = '3.0';
                            document.getElementById('side-b-display').textContent = '4.0';
                            VisualMath.getState()._setSideA(3);
                            VisualMath.getState()._setSideB(4);
                        });

                        // Reset button
                        document.getElementById('reset-btn').addEventListener('click', function () {
                            sliderA.value = 6;
                            sliderB.value = 8;
                            document.getElementById('side-a-display').textContent = '6.0';
                            document.getElementById('side-b-display').textContent = '8.0';
                            VisualMath.getState()._setSideA(6);
                            VisualMath.getState()._setSideB(8);
                            document.getElementById('show-squares').checked = true;
                            document.getElementById('show-labels').checked = true;
                            document.getElementById('show-grid').checked = false;
                            VisualMath.setState('showSquares', true);
                            VisualMath.setState('showLabels', true);
                            VisualMath.setState('showGrid', false);
                        });

                        // Clickable Pythagorean triples
                        document.querySelectorAll('.clickable-angle').forEach(function (row) {
                            row.addEventListener('click', function () {
                                var a = parseFloat(this.getAttribute('data-a'));
                                var b = parseFloat(this.getAttribute('data-b'));
                                sliderA.value = a;
                                sliderB.value = b;
                                document.getElementById('side-a-display').textContent = a.toFixed(1);
                                document.getElementById('side-b-display').textContent = b.toFixed(1);
                                VisualMath.getState()._setSideA(a);
                                VisualMath.getState()._setSideB(b);
                            });
                        });
                    });
                </script>