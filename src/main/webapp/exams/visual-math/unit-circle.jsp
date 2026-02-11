<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Unit Circle Chart Calculator - Find Sin, Cos, Tan Values Instantly (Free)";
    String seoDescription = "Interactive unit circle with all special angles. Drag to explore sin, cos, tan values with synchronized wave graphs. Free online tool - no signup needed.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-math/unit-circle.jsp";

    StringBuilder extraHead=new StringBuilder();
        extraHead.append("<meta property=\"og:title\" content=\"Unit Circle Calculator - Interactive Trig Values\">");
    extraHead.append("<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("<meta property=\"og:type\" content=\"website\">");
    extraHead.append("<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("<meta name=\"twitter:title\" content=\"Unit Circle Calculator - Interactive Trig Values\">");
    extraHead.append("<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("<meta name=\"keywords\" content=\"unit circle, unit circle chart, unit circle calculator, unit circle values, sin cos tan, trigonometry calculator, special angles, trig values\">");

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
        <span class="breadcrumb-current">Unit Circle</span>
    </nav>

    <!-- Header -->
    <div class="viz-header">
        <h1>Unit Circle Explorer</h1>
        <p class="viz-subtitle">Drag the point around the circle to see how sin, cos, and tan change. The wave graph on the right traces the function as the angle sweeps.</p>
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

                <!-- Angle Slider -->
                <div class="control-group">
                    <label>Angle</label>
                    <div class="viz-slider-row">
                        <input type="range" id="angle-slider" min="0" max="360" value="45" step="1">
                        <span class="viz-slider-val" id="angle-display">45&deg;</span>
                    </div>
                </div>

                <!-- Show/Hide -->
                <div class="control-group">
                    <label>Show</label>
                    <div class="viz-check-group">
                        <label class="viz-check">
                            <input type="checkbox" id="show-sin" checked>
                            <span class="dot dot-sin"></span> sin
                        </label>
                        <label class="viz-check">
                            <input type="checkbox" id="show-cos" checked>
                            <span class="dot dot-cos"></span> cos
                        </label>
                        <label class="viz-check">
                            <input type="checkbox" id="show-tan">
                            <span class="dot dot-tan"></span> tan
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
                <h3>Live Values</h3>
                <table>
                    <tr><td>&#952;</td><td id="val-angle">45&deg; (&pi;/4)</td></tr>
                    <tr><td class="val-sin">sin &#952;</td><td class="val-sin" id="val-sin">0.7071</td></tr>
                    <tr><td class="val-cos">cos &#952;</td><td class="val-cos" id="val-cos">0.7071</td></tr>
                    <tr><td class="val-tan">tan &#952;</td><td class="val-tan" id="val-tan">1.0000</td></tr>
                    <tr><td>Quadrant</td><td id="val-quadrant">Q1</td></tr>
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
                <h3>Key Formulas</h3>
                <ul>
                    <li>On the unit circle: <span class="formula-highlight">x = cos &#952;, y = sin &#952;</span></li>
                    <li>Pythagorean identity: <span class="formula-highlight">sin&sup2;&#952; + cos&sup2;&#952; = 1</span></li>
                    <li>Tangent: <span class="formula-highlight">tan &#952; = sin &#952; / cos &#952;</span></li>
                    <li>Period: sin and cos repeat every <span class="formula-highlight">2&#960; (360&deg;)</span></li>
                </ul>

                <h3 style="margin-top: var(--space-4);">Quadrant Signs</h3>
                <ul>
                    <li><strong>Q1 (0&deg;-90&deg;)</strong>: All positive</li>
                    <li><strong>Q2 (90&deg;-180&deg;)</strong>: sin +, cos -, tan -</li>
                    <li><strong>Q3 (180&deg;-270&deg;)</strong>: tan +, sin -, cos -</li>
                    <li><strong>Q4 (270&deg;-360&deg;)</strong>: cos +, sin -, tan -</li>
                </ul>
            </div>

            <div class="viz-math-col">
                <h3>Special Angles</h3>
                <table class="angles-table">
                    <thead>
                        <tr><th>&#952;</th><th>rad</th><th>sin</th><th>cos</th><th>tan</th></tr>
                    </thead>
                    <tbody>
                        <tr class="clickable-angle" data-angle="0"><td>0&deg;</td><td>0</td><td>0</td><td>1</td><td>0</td></tr>
                        <tr class="clickable-angle" data-angle="30"><td>30&deg;</td><td>&#960;/6</td><td>1/2</td><td>&#8730;3/2</td><td>1/&#8730;3</td></tr>
                        <tr class="clickable-angle" data-angle="45"><td>45&deg;</td><td>&#960;/4</td><td>&#8730;2/2</td><td>&#8730;2/2</td><td>1</td></tr>
                        <tr class="clickable-angle" data-angle="60"><td>60&deg;</td><td>&#960;/3</td><td>&#8730;3/2</td><td>1/2</td><td>&#8730;3</td></tr>
                        <tr class="clickable-angle" data-angle="90"><td>90&deg;</td><td>&#960;/2</td><td>1</td><td>0</td><td>&infin;</td></tr>
                        <tr class="clickable-angle" data-angle="120"><td>120&deg;</td><td>2&#960;/3</td><td>&#8730;3/2</td><td>-1/2</td><td>-&#8730;3</td></tr>
                        <tr class="clickable-angle" data-angle="180"><td>180&deg;</td><td>&#960;</td><td>0</td><td>-1</td><td>0</td></tr>
                        <tr class="clickable-angle" data-angle="270"><td>270&deg;</td><td>3&#960;/2</td><td>-1</td><td>0</td><td>&infin;</td></tr>
                    </tbody>
                </table>
                <p style="font-size: var(--text-xs); color: var(--text-muted); margin-top: var(--space-2);">Click any row to jump to that angle</p>
            </div>
        </div>
    </section>

    <!-- Related -->
    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-math/trig-graphs.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(239,68,68,0.12);">~</div>
                <div><h4>Trig Graphs</h4><span>Trigonometry</span></div>
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
    "name": "Unit Circle Explorer",
    "description": "Interactive unit circle visualization showing sin, cos, and tan with synchronized wave graphs.",
    "url": "https://8gwifi.org/exams/visual-math/unit-circle.jsp",
    "educationalLevel": "High School",
    "teaches": "Trigonometric functions on the unit circle",
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
        { "@type": "ListItem", "position": 4, "name": "Unit Circle" }
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
            "name": "What is the unit circle?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The unit circle is a circle with radius 1 centered at the origin. Any point on it has coordinates (cos θ, sin θ), making it the foundation for understanding trigonometric functions."
            }
        },
        {
            "@type": "Question",
            "name": "What are the special angles on the unit circle?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The special angles are 0°, 30°, 45°, 60°, 90°, 120°, 135°, 150°, 180°, 210°, 225°, 240°, 270°, 300°, 315°, and 330°. These angles have exact sin, cos, and tan values involving √2, √3, and simple fractions."
            }
        },
        {
            "@type": "Question",
            "name": "How do sin, cos, and tan relate on the unit circle?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "On the unit circle, cos θ is the x-coordinate, sin θ is the y-coordinate, and tan θ = sin θ / cos θ. The Pythagorean identity sin²θ + cos²θ = 1 holds for all angles."
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
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-unit-circle.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Initialize the unit circle visualization
    VisualMath.init('unit-circle', 'viz-canvas', {
        showSin: true,
        showCos: true,
        showTan: false
    });

    // Angle slider
    var slider = document.getElementById('angle-slider');
    slider.addEventListener('input', function() {
        var deg = parseInt(this.value);
        document.getElementById('angle-display').textContent = deg + '\u00B0';
        VisualMath.getState()._setAngle(deg);
    });

    // Checkboxes
    document.getElementById('show-sin').addEventListener('change', function() {
        VisualMath.setState('showSin', this.checked);
    });
    document.getElementById('show-cos').addEventListener('change', function() {
        VisualMath.setState('showCos', this.checked);
    });
    document.getElementById('show-tan').addEventListener('change', function() {
        VisualMath.setState('showTan', this.checked);
    });

    // Animate button
    var animBtn = document.getElementById('animate-btn');
    animBtn.addEventListener('click', function() {
        var isAnim = VisualMath.getState()._toggleAnim();
        animBtn.textContent = isAnim ? 'Pause' : 'Animate';
        animBtn.classList.toggle('viz-btn-secondary', isAnim);
        animBtn.classList.toggle('viz-btn-primary', !isAnim);
    });

    // Reset button
    document.getElementById('reset-btn').addEventListener('click', function() {
        slider.value = 45;
        document.getElementById('angle-display').textContent = '45\u00B0';
        VisualMath.getState()._setAngle(45);
        // Stop animation if running
        if (VisualMath.getState()._isAnimating()) {
            VisualMath.getState()._toggleAnim();
            animBtn.textContent = 'Animate';
            animBtn.classList.remove('viz-btn-secondary');
            animBtn.classList.add('viz-btn-primary');
        }
        // Reset checkboxes
        document.getElementById('show-sin').checked = true;
        document.getElementById('show-cos').checked = true;
        document.getElementById('show-tan').checked = false;
        VisualMath.setState('showSin', true);
        VisualMath.setState('showCos', true);
        VisualMath.setState('showTan', false);
    });

    // Clickable special angles in table
    document.querySelectorAll('.clickable-angle').forEach(function(row) {
        row.addEventListener('click', function() {
            var deg = parseInt(this.getAttribute('data-angle'));
            slider.value = deg;
            document.getElementById('angle-display').textContent = deg + '\u00B0';
            VisualMath.getState()._setAngle(deg);
            // Stop animation
            if (VisualMath.getState()._isAnimating()) {
                VisualMath.getState()._toggleAnim();
                animBtn.textContent = 'Animate';
                animBtn.classList.remove('viz-btn-secondary');
                animBtn.classList.add('viz-btn-primary');
            }
        });
    });
});
</script>
