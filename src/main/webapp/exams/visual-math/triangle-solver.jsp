<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% String seoTitle="Triangle Solver Calculator - Law of Sines, Law of Cosines (Free SSS SAS ASA)" ; String
        seoDescription="Solve any triangle with law of sines and cosines. Calculate missing sides and angles. Supports SSS, SAS, ASA, AAS, SSA cases. Free triangle calculator with visualization."
        ; String canonicalUrl="https://8gwifi.org/exams/visual-math/triangle-solver.jsp" ; StringBuilder extraHead=new StringBuilder();
        extraHead.append("\n<meta property=\"og:title\" content=\"Triangle Solver - Law of Sines & Cosines Calculator\">");
        extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
        extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
        extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
        extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
        extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
        extraHead.append("\n<meta name=\"twitter:title\" content=\"Triangle Solver Calculator\">");
        extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
        extraHead.append("\n<meta name=\"keywords\" content=\"triangle solver, law of sines, law of cosines, triangle calculator, SSS SAS ASA AAS, solve triangle, triangle area, missing angle calculator\">");

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
                    <span class="breadcrumb-current">Triangle Solver</span>
                </nav>

                <div class="viz-header">
                    <h1>Triangle Solver Calculator</h1>
                    <p class="viz-subtitle">Solve any triangle using law of sines and cosines. Enter 3 known values
                        (sides or angles) and calculate all missing measurements.</p>
                </div>

                <div class="viz-interactive">
                    <div class="viz-canvas-wrap">
                        <div id="viz-canvas"></div>
                    </div>

                    <div class="viz-panel">
                        <div class="viz-controls">
                            <h3>Input Values</h3>

                            <div class="control-group">
                                <label>Presets</label>
                                <div style="display:flex;flex-wrap:wrap;gap:6px;">
                                    <button class="vm-chip active" data-preset="345">3-4-5 Right</button>
                                    <button class="vm-chip" data-preset="equilateral">Equilateral</button>
                                    <button class="vm-chip" data-preset="isosceles">Isosceles</button>
                                    <button class="vm-chip" data-preset="obtuse">Obtuse</button>
                                    <button class="vm-chip" data-preset="sas">SAS</button>
                                    <button class="vm-chip" data-preset="asa">ASA</button>
                                </div>
                            </div>

                            <div class="control-group">
                                <label>Side a</label>
                                <input type="number" id="input-a" placeholder="Side a" min="0" step="0.1"
                                    style="width: 100%; padding: 8px; border-radius: 6px; border: 1px solid var(--border-primary); background: var(--bg-primary); color: var(--text-primary);">
                            </div>

                            <div class="control-group">
                                <label>Side b</label>
                                <input type="number" id="input-b" placeholder="Side b" min="0" step="0.1"
                                    style="width: 100%; padding: 8px; border-radius: 6px; border: 1px solid var(--border-primary); background: var(--bg-primary); color: var(--text-primary);">
                            </div>

                            <div class="control-group">
                                <label>Side c</label>
                                <input type="number" id="input-c" placeholder="Side c" min="0" step="0.1"
                                    style="width: 100%; padding: 8px; border-radius: 6px; border: 1px solid var(--border-primary); background: var(--bg-primary); color: var(--text-primary);">
                            </div>

                            <div class="control-group">
                                <label>Angle A (degrees)</label>
                                <input type="number" id="input-A" placeholder="Angle A" min="0" max="180" step="1"
                                    style="width: 100%; padding: 8px; border-radius: 6px; border: 1px solid var(--border-primary); background: var(--bg-primary); color: var(--text-primary);">
                            </div>

                            <div class="control-group">
                                <label>Angle B (degrees)</label>
                                <input type="number" id="input-B" placeholder="Angle B" min="0" max="180" step="1"
                                    style="width: 100%; padding: 8px; border-radius: 6px; border: 1px solid var(--border-primary); background: var(--bg-primary); color: var(--text-primary);">
                            </div>

                            <div class="control-group">
                                <label>Angle C (degrees)</label>
                                <input type="number" id="input-C" placeholder="Angle C" min="0" max="180" step="1"
                                    style="width: 100%; padding: 8px; border-radius: 6px; border: 1px solid var(--border-primary); background: var(--bg-primary); color: var(--text-primary);">
                            </div>

                            <div class="viz-btn-row">
                                <button class="viz-btn viz-btn-primary" id="solve-btn">Solve</button>
                                <button class="viz-btn viz-btn-secondary" id="clear-btn">Clear</button>
                            </div>
                        </div>

                        <div class="viz-values">
                            <h3>Results</h3>
                            <table>
                                <tr>
                                    <td>Case</td>
                                    <td id="val-case">--</td>
                                </tr>
                                <tr>
                                    <td>Area</td>
                                    <td id="val-area">--</td>
                                </tr>
                                <tr>
                                    <td>Perimeter</td>
                                    <td id="val-perimeter">--</td>
                                </tr>
                                <tr>
                                    <td>Type</td>
                                    <td id="val-type">--</td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>

                <%@ include file="../components/ad-leaderboard.jsp" %>

                    <section class="viz-math">
                        <h2>Triangle Solving Methods</h2>
                        <div class="viz-math-grid">
                            <div class="viz-math-col">
                                <h3>Law of Sines</h3>
                                <ul>
                                    <li>Formula: <span class="formula-highlight">a/sin(A) = b/sin(B) = c/sin(C)</span>
                                    </li>
                                    <li>Use when: You know 2 angles and 1 side (AAS, ASA)</li>
                                    <li>Or: 2 sides and 1 non-included angle (SSA - ambiguous case)</li>
                                </ul>

                                <h3 style="margin-top: var(--space-4);">Law of Cosines</h3>
                                <ul>
                                    <li><span class="formula-highlight">c² = a² + b² - 2ab·cos(C)</span></li>
                                    <li>Use when: You know 3 sides (SSS)</li>
                                    <li>Or: 2 sides and included angle (SAS)</li>
                                </ul>
                            </div>

                            <div class="viz-math-col">
                                <h3>Triangle Cases</h3>
                                <ul>
                                    <li><strong>SSS</strong>: Three sides known</li>
                                    <li><strong>SAS</strong>: Two sides and included angle</li>
                                    <li><strong>ASA</strong>: Two angles and included side</li>
                                    <li><strong>AAS</strong>: Two angles and non-included side</li>
                                    <li><strong>SSA</strong>: Two sides and non-included angle (ambiguous)</li>
                                </ul>

                                <h3 style="margin-top: var(--space-4);">Area Formulas</h3>
                                <ul>
                                    <li>Heron's: <span class="formula-highlight">√(s(s-a)(s-b)(s-c))</span></li>
                                    <li>SAS: <span class="formula-highlight">(1/2)ab·sin(C)</span></li>
                                    <li>Base×Height: <span class="formula-highlight">(1/2)bh</span></li>
                                </ul>
                            </div>
                        </div>
                    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-math/pythagorean-theorem.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(236,72,153,0.12);">&#9651;</div>
                <div><h4>Pythagorean Theorem</h4><span>Geometry</span></div>
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

            <script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "LearningResource",
    "name": "Triangle Solver Calculator",
    "description": "Solve any triangle using law of sines and cosines. Calculate missing sides, angles, area, and perimeter.",
    "url": "https://8gwifi.org/exams/visual-math/triangle-solver.jsp",
    "educationalLevel": "High School",
    "teaches": "Law of sines, law of cosines, triangle solving, trigonometry",
    "learningResourceType": "Interactive calculator",
    "interactivityType": "active",
    "publisher": {"@type": "Organization", "name": "8gwifi.org"}
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
        { "@type": "ListItem", "position": 4, "name": "Triangle Solver" }
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
            "name": "What is the law of sines?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The law of sines states that a/sin(A) = b/sin(B) = c/sin(C), where a, b, c are the sides of a triangle and A, B, C are the opposite angles. It is used to solve triangles when you know two angles and one side (ASA, AAS) or two sides and a non-included angle (SSA)."
            }
        },
        {
            "@type": "Question",
            "name": "What is the law of cosines?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The law of cosines states that c² = a² + b² - 2ab·cos(C). It generalizes the Pythagorean theorem to any triangle. Use it when you know three sides (SSS) or two sides and the included angle (SAS)."
            }
        },
        {
            "@type": "Question",
            "name": "What is the ambiguous case (SSA)?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The SSA (two sides and a non-included angle) case is called ambiguous because it can produce zero, one, or two valid triangles. This happens because the given angle's opposite side may reach the other side at two different points, creating two possible triangles."
            }
        }
    ]
}
</script>

<%@ include file="viz-ads.jsp" %>
            <%@ include file="../components/footer.jsp" %>

                <script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
                <script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
                <script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-triangle-solver.js"></script>
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        VisualMath.init('triangle-solver', 'viz-canvas', {});

                        var presets = {
                            '345':         { a: 3,    b: 4,    c: 5,    A: null, B: null, C: null,  label: '3-4-5 Right (SSS)' },
                            'equilateral': { a: 6,    b: 6,    c: 6,    A: null, B: null, C: null,  label: 'Equilateral (SSS)' },
                            'isosceles':   { a: 5,    b: 5,    c: 8,    A: null, B: null, C: null,  label: 'Isosceles (SSS)' },
                            'obtuse':      { a: 3,    b: 4,    c: 6,    A: null, B: null, C: null,  label: 'Obtuse Scalene (SSS)' },
                            'sas':         { a: 7,    b: 10,   c: null, A: null, B: null, C: 45,    label: 'SAS — two sides + angle' },
                            'asa':         { a: null,  b: null, c: 12,   A: 50,  B: 60,   C: null,  label: 'ASA — two angles + side' }
                        };

                        function fillInputs(p) {
                            document.getElementById('input-a').value = p.a != null ? p.a : '';
                            document.getElementById('input-b').value = p.b != null ? p.b : '';
                            document.getElementById('input-c').value = p.c != null ? p.c : '';
                            document.getElementById('input-A').value = p.A != null ? p.A : '';
                            document.getElementById('input-B').value = p.B != null ? p.B : '';
                            document.getElementById('input-C').value = p.C != null ? p.C : '';
                        }

                        function loadPreset(key) {
                            var p = presets[key];
                            fillInputs(p);
                            VisualMath.getState()._solve(p.a, p.b, p.c, p.A, p.B, p.C);
                            // Update active chip
                            document.querySelectorAll('[data-preset]').forEach(function (btn) {
                                btn.classList.toggle('active', btn.getAttribute('data-preset') === key);
                            });
                        }

                        // Preset chip clicks
                        document.querySelectorAll('[data-preset]').forEach(function (btn) {
                            btn.addEventListener('click', function () {
                                loadPreset(this.getAttribute('data-preset'));
                            });
                        });

                        document.getElementById('solve-btn').addEventListener('click', function () {
                            var a = parseFloat(document.getElementById('input-a').value) || null;
                            var b = parseFloat(document.getElementById('input-b').value) || null;
                            var c = parseFloat(document.getElementById('input-c').value) || null;
                            var A = parseFloat(document.getElementById('input-A').value) || null;
                            var B = parseFloat(document.getElementById('input-B').value) || null;
                            var C = parseFloat(document.getElementById('input-C').value) || null;
                            // Deactivate preset chips when user solves custom values
                            document.querySelectorAll('[data-preset]').forEach(function (btn) { btn.classList.remove('active'); });
                            VisualMath.getState()._solve(a, b, c, A, B, C);
                        });

                        document.getElementById('clear-btn').addEventListener('click', function () {
                            document.getElementById('input-a').value = '';
                            document.getElementById('input-b').value = '';
                            document.getElementById('input-c').value = '';
                            document.getElementById('input-A').value = '';
                            document.getElementById('input-B').value = '';
                            document.getElementById('input-C').value = '';
                            document.querySelectorAll('[data-preset]').forEach(function (btn) { btn.classList.remove('active'); });
                            VisualMath.getState()._clear();
                        });

                        // Load first preset on page open
                        loadPreset('345');
                    });
                </script>