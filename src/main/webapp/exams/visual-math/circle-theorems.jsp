<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% String seoTitle="Circle Theorems Calculator - Interactive Inscribed Angle, Central Angle Visualizer (Free)" ;
        String
        seoDescription="Interactive circle theorems explorer. Visualize inscribed angles, central angles, tangent properties, and cyclic quadrilaterals. Free geometry tool with live calculations."
        ; String canonicalUrl="https://8gwifi.org/exams/visual-math/circle-theorems.jsp" ; StringBuilder extraHead=new StringBuilder();
        extraHead.append("\n<meta property=\"og:title\" content=\"Circle Theorems Visualizer - Interactive Geometry\">");
        extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
        extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
        extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
        extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
        extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
        extraHead.append("\n<meta name=\"twitter:title\" content=\"Circle Theorems Visualizer\">");
        extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
        extraHead.append("\n<meta name=\"keywords\" content=\"circle theorems, inscribed angle theorem, central angle theorem, circle geometry, tangent theorem, cyclic quadrilateral, circle calculator, geometry theorems, interactive circle\">");

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
                    <span class="breadcrumb-current">Circle Theorems</span>
                </nav>

                <!-- Header -->
                <div class="viz-header">
                    <h1>Circle Theorems Explorer</h1>
                    <p class="viz-subtitle">Drag points around the circle to explore fundamental circle theorems. Watch
                        angles update in real-time and see the relationships come alive.</p>
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
                            <h3>Theorem</h3>

                            <!-- Theorem Selector -->
                            <div class="control-group">
                                <label>Select Theorem</label>
                                <select id="theorem-select"
                                    style="width: 100%; padding: 8px; border-radius: 6px; border: 1px solid var(--border-primary); background: var(--bg-primary); color: var(--text-primary); font-size: var(--text-sm);">
                                    <option value="inscribed">Inscribed Angle</option>
                                    <option value="central">Central Angle</option>
                                    <option value="semicircle">Angle in Semicircle</option>
                                    <option value="tangent">Tangent-Radius</option>
                                    <option value="cyclic">Cyclic Quadrilateral</option>
                                </select>
                            </div>

                            <!-- Show/Hide -->
                            <div class="control-group">
                                <label>Show</label>
                                <div class="viz-check-group">
                                    <label class="viz-check">
                                        <input type="checkbox" id="show-angles" checked>
                                        Angles
                                    </label>
                                    <label class="viz-check">
                                        <input type="checkbox" id="show-labels" checked>
                                        Labels
                                    </label>
                                    <label class="viz-check">
                                        <input type="checkbox" id="show-arcs">
                                        Arcs
                                    </label>
                                </div>
                            </div>

                            <!-- Buttons -->
                            <div class="viz-btn-row">
                                <button class="viz-btn viz-btn-primary" id="animate-btn">Animate</button>
                                <button class="viz-btn viz-btn-secondary" id="reset-btn">Reset</button>
                            </div>
                        </div>

                        <!-- Values -->
                        <div class="viz-values">
                            <h3>Measurements</h3>
                            <table>
                                <tr>
                                    <td id="label-1">Angle 1</td>
                                    <td id="val-1">--</td>
                                </tr>
                                <tr>
                                    <td id="label-2">Angle 2</td>
                                    <td id="val-2">--</td>
                                </tr>
                                <tr>
                                    <td id="label-3">Relation</td>
                                    <td id="val-3">--</td>
                                </tr>
                                <tr>
                                    <td id="label-4">Arc</td>
                                    <td id="val-4">--</td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Ad -->
                <%@ include file="../components/ad-leaderboard.jsp" %>

                    <!-- The Math Section -->
                    <section class="viz-math">
                        <h2>Circle Theorems Explained</h2>
                        <div class="viz-math-grid">
                            <div class="viz-math-col">
                                <h3>Key Theorems</h3>
                                <ul>
                                    <li><strong>Inscribed Angle:</strong> An angle formed by two chords is half the
                                        central angle subtending the same arc</li>
                                    <li><strong>Central Angle:</strong> Angle at the center is twice the inscribed angle
                                        on the same arc</li>
                                    <li><strong>Semicircle:</strong> Any angle inscribed in a semicircle is a right
                                        angle (90°)</li>
                                    <li><strong>Tangent-Radius:</strong> A tangent to a circle is perpendicular to the
                                        radius at the point of contact</li>
                                    <li><strong>Cyclic Quadrilateral:</strong> Opposite angles sum to 180°</li>
                                </ul>
                            </div>

                            <div class="viz-math-col">
                                <h3>Formulas</h3>
                                <ul>
                                    <li>Inscribed angle: <span class="formula-highlight">θ = α/2</span> (where α is
                                        central angle)</li>
                                    <li>Central angle: <span class="formula-highlight">α = 2θ</span></li>
                                    <li>Arc length: <span class="formula-highlight">s = rθ</span> (θ in radians)</li>
                                    <li>Sector area: <span class="formula-highlight">A = (1/2)r²θ</span></li>
                                    <li>Chord length: <span class="formula-highlight">c = 2r·sin(θ/2)</span></li>
                                </ul>

                                <h3 style="margin-top: var(--space-4);">Applications</h3>
                                <ul>
                                    <li>Navigation and surveying</li>
                                    <li>Architecture and design</li>
                                    <li>Computer graphics</li>
                                    <li>Astronomy and orbital mechanics</li>
                                </ul>
                            </div>
                        </div>
                    </section>

                    <!-- Related -->
    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-math/pythagorean-theorem.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(236,72,153,0.12);">&#9651;</div>
                <div><h4>Pythagorean Theorem</h4><span>Geometry</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/unit-circle.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(239,68,68,0.12);">&#9675;</div>
                <div><h4>Unit Circle</h4><span>Trigonometry</span></div>
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
    "name": "Circle Theorems Explorer",
    "description": "Interactive visualization of circle theorems including inscribed angles, central angles, and tangent properties.",
    "url": "https://8gwifi.org/exams/visual-math/circle-theorems.jsp",
    "educationalLevel": "High School",
    "teaches": "Circle geometry, inscribed angle theorem, central angle theorem, tangent properties",
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
        { "@type": "ListItem", "position": 4, "name": "Circle Theorems" }
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
            "name": "What is the inscribed angle theorem?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The inscribed angle theorem states that an angle inscribed in a circle is half the central angle that subtends the same arc. If the central angle is 60°, the inscribed angle is 30°."
            }
        },
        {
            "@type": "Question",
            "name": "Why is an angle in a semicircle always 90 degrees?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "An angle inscribed in a semicircle is always 90° because it subtends a diameter. The central angle for a diameter is 180°, and by the inscribed angle theorem, the inscribed angle is half of that: 180°/2 = 90°."
            }
        },
        {
            "@type": "Question",
            "name": "What is a cyclic quadrilateral?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "A cyclic quadrilateral is a four-sided polygon where all vertices lie on a circle. The key property is that opposite angles sum to 180 degrees."
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
                <script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-circle-theorems.js"></script>
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        // Initialize the circle theorems visualization
                        VisualMath.init('circle-theorems', 'viz-canvas', {
                            theorem: 'inscribed',
                            showAngles: true,
                            showLabels: true,
                            showArcs: false
                        });

                        // Theorem selector
                        document.getElementById('theorem-select').addEventListener('change', function () {
                            VisualMath.setState('theorem', this.value);
                            VisualMath.getState()._changeTheorem(this.value);
                        });

                        // Checkboxes
                        document.getElementById('show-angles').addEventListener('change', function () {
                            VisualMath.setState('showAngles', this.checked);
                        });
                        document.getElementById('show-labels').addEventListener('change', function () {
                            VisualMath.setState('showLabels', this.checked);
                        });
                        document.getElementById('show-arcs').addEventListener('change', function () {
                            VisualMath.setState('showArcs', this.checked);
                        });

                        // Animate button
                        var animBtn = document.getElementById('animate-btn');
                        animBtn.addEventListener('click', function () {
                            var isAnim = VisualMath.getState()._toggleAnim();
                            animBtn.textContent = isAnim ? 'Pause' : 'Animate';
                            animBtn.classList.toggle('viz-btn-secondary', isAnim);
                            animBtn.classList.toggle('viz-btn-primary', !isAnim);
                        });

                        // Reset button
                        document.getElementById('reset-btn').addEventListener('click', function () {
                            VisualMath.getState()._reset();
                            if (VisualMath.getState()._isAnimating()) {
                                VisualMath.getState()._toggleAnim();
                                animBtn.textContent = 'Animate';
                                animBtn.classList.remove('viz-btn-secondary');
                                animBtn.classList.add('viz-btn-primary');
                            }
                        });
                    });
                </script>