<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "2D Vector Explorer - Addition, Dot Product, Magnitude (Free)";
    String seoDescription = "Interactive 2D vector visualizer. Drag vector tips, see addition (parallelogram), dot product, angle between vectors, magnitude, and projection in real time.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-math/vectors-2d.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"2D Vector Explorer - Addition, Dot Product, Magnitude\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"2D Vector Explorer - Interactive Visualizer\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"2d vector calculator, vector addition, dot product calculator, vector magnitude, angle between vectors, vector projection, parallelogram rule, vector components, linear algebra visualizer\">");

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
        <span class="breadcrumb-current">2D Vectors</span>
    </nav>

    <div class="viz-header">
        <h1>2D Vector Explorer</h1>
        <p class="viz-subtitle">Drag the arrow tips to change vectors. Watch addition, dot product, angle, and projection update in real-time.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Vectors</h3>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-preset="perpendicular">Perpendicular</button>
                        <button class="vm-chip" data-preset="parallel">Parallel</button>
                        <button class="vm-chip" data-preset="opposite">Opposite</button>
                        <button class="vm-chip" data-preset="unit">Unit Vectors</button>
                        <button class="vm-chip" data-preset="angle45">45&deg; Angle</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>Show</label>
                    <div class="viz-check-group">
                        <label class="viz-check">
                            <input type="checkbox" id="show-sum" checked>
                            Sum (parallelogram)
                        </label>
                        <label class="viz-check">
                            <input type="checkbox" id="show-proj">
                            Projection
                        </label>
                    </div>
                </div>

                <div class="viz-btn-row">
                    <button class="viz-btn viz-btn-primary" id="animate-btn">Animate</button>
                    <button class="viz-btn viz-btn-secondary" id="reset-btn">Reset</button>
                </div>

                <p style="font-size:var(--text-sm);color:var(--text-secondary);margin-top:8px;">Drag arrow tips to change vectors.</p>
            </div>

            <div class="viz-values">
                <h3>Properties</h3>
                <table>
                    <tr><td>Vector a</td><td id="val-vec-a">&mdash;</td></tr>
                    <tr><td>Vector b</td><td id="val-vec-b">&mdash;</td></tr>
                    <tr><td>|a|</td><td id="val-mag-a">&mdash;</td></tr>
                    <tr><td>|b|</td><td id="val-mag-b">&mdash;</td></tr>
                    <tr><td>Dot product</td><td id="val-dot">&mdash;</td></tr>
                    <tr><td>Angle</td><td id="val-angle">&mdash;</td></tr>
                    <tr><td>a + b</td><td id="val-sum">&mdash;</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Math Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Vector Basics</h3>
                <ul>
                    <li>A 2D vector <strong>a</strong> = (a&#8339;, a&#7527;) has magnitude and direction</li>
                    <li>Magnitude: <span class="formula-highlight">|a| = &radic;(a&#8339;&sup2; + a&#7527;&sup2;)</span></li>
                    <li>Direction angle: <span class="formula-highlight">&theta; = atan2(a&#7527;, a&#8339;)</span></li>
                    <li>Unit vector: <span class="formula-highlight">&acirc; = a / |a|</span></li>
                    <li>Components: <span class="formula-highlight">a&#8339; = |a| cos&theta;, a&#7527; = |a| sin&theta;</span></li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Operations</h3>
                <ul>
                    <li><strong>Addition:</strong> <span class="formula-highlight">a + b = (a&#8339; + b&#8339;, a&#7527; + b&#7527;)</span></li>
                    <li>Geometrically: place b's tail at a's tip (parallelogram rule)</li>
                    <li><strong>Dot product:</strong> <span class="formula-highlight">a &middot; b = a&#8339;b&#8339; + a&#7527;b&#7527; = |a||b| cos&theta;</span></li>
                    <li>Dot product = 0 means vectors are perpendicular</li>
                    <li><strong>Angle:</strong> <span class="formula-highlight">&theta; = arccos(a &middot; b / (|a| |b|))</span></li>
                    <li><strong>Projection of b onto a:</strong> <span class="formula-highlight">proj = (a &middot; b / |a|&sup2;) a</span></li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-math/matrix-transform.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(59,130,246,0.12);">&#9638;</div>
                <div><h4>Matrix Transforms</h4><span>Linear Algebra</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/matrix-calculator.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(59,130,246,0.12);">&#9638;</div>
                <div><h4>Matrix Calculator</h4><span>Linear Algebra</span></div>
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
    "name": "2D Vector Explorer",
    "description": "Interactive 2D vector visualizer with draggable vectors. See addition, dot product, angle, magnitude, and projection in real time.",
    "url": "https://8gwifi.org/exams/visual-math/vectors-2d.jsp",
    "educationalLevel": "High School",
    "teaches": "2D vectors, vector addition, dot product, magnitude, angle between vectors, and projection",
    "learningResourceType": "Interactive visualization",
    "publisher": { "@type": "Organization", "name": "8gwifi.org" }
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
        { "@type": "ListItem", "position": 4, "name": "2D Vectors" }
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
            "name": "What is a vector?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "A vector is a mathematical object with both magnitude (length) and direction. In 2D, a vector is written as (x, y) representing its horizontal and vertical components. Unlike a scalar (just a number), a vector tells you not only how much but also in which direction. Vectors are used in physics for forces, velocities, and displacements."
            }
        },
        {
            "@type": "Question",
            "name": "What does the dot product tell us?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The dot product a . b = ax*bx + ay*by is a scalar that measures how much two vectors point in the same direction. If the dot product is positive, they point roughly the same way; if negative, they point roughly opposite; if zero, the vectors are perpendicular (at 90 degrees). It also equals |a||b|cos(theta), linking it to the angle between the vectors."
            }
        },
        {
            "@type": "Question",
            "name": "How do you find the angle between two vectors?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Use the formula theta = arccos((a . b) / (|a| * |b|)). First compute the dot product (ax*bx + ay*by), then divide by the product of the magnitudes. Take the inverse cosine (arccos) of the result to get the angle in radians or degrees. The angle is always between 0 and 180 degrees."
            }
        }
    ]
}
</script>

<%@ include file="viz-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>

<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-vectors.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('vectors', 'viz-canvas', { ax: 3, ay: 2, bx: 1, by: 4, showSum: true, showDot: false });
    var state = VisualMath.getState();

    var presets = {
        'perpendicular': { ax: 3, ay: 0, bx: 0, by: 3 },
        'parallel':      { ax: 3, ay: 2, bx: 1.5, by: 1 },
        'opposite':      { ax: 3, ay: 2, bx: -3, by: -2 },
        'unit':          { ax: 1, ay: 0, bx: 0, by: 1 },
        'angle45':       { ax: 3, ay: 0, bx: 3, by: 3 }
    };

    function applyPreset(key) {
        var p = presets[key];
        state.ax = p.ax; state.ay = p.ay;
        state.bx = p.bx; state.by = p.by;

        document.querySelectorAll('[data-preset]').forEach(function (btn) {
            btn.classList.toggle('active', btn.getAttribute('data-preset') === key);
        });

        state._redraw();
    }

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () { applyPreset(this.getAttribute('data-preset')); });
    });

    // Show checkboxes
    document.getElementById('show-sum').addEventListener('change', function () {
        state.showSum = this.checked;
        state._redraw();
    });
    document.getElementById('show-proj').addEventListener('change', function () {
        state.showDot = this.checked;
        state._redraw();
    });

    // Animate — rotate vector b around origin
    var animInterval = null;
    var animBtn = document.getElementById('animate-btn');
    animBtn.addEventListener('click', function () {
        if (animInterval) {
            clearInterval(animInterval);
            animInterval = null;
            animBtn.textContent = 'Animate';
            animBtn.classList.remove('viz-btn-secondary');
            animBtn.classList.add('viz-btn-primary');
            return;
        }
        animBtn.textContent = 'Pause';
        animBtn.classList.add('viz-btn-secondary');
        animBtn.classList.remove('viz-btn-primary');

        var bMag = Math.sqrt(state.bx * state.bx + state.by * state.by) || 3;
        var theta = 0;

        animInterval = setInterval(function () {
            theta += 0.03;
            if (theta > 2 * Math.PI) {
                clearInterval(animInterval); animInterval = null;
                animBtn.textContent = 'Animate';
                animBtn.classList.remove('viz-btn-secondary');
                animBtn.classList.add('viz-btn-primary');
                return;
            }
            state.bx = bMag * Math.cos(theta);
            state.by = bMag * Math.sin(theta);
            state._redraw();
        }, 50);
    });

    // Reset
    document.getElementById('reset-btn').addEventListener('click', function () {
        if (animInterval) { clearInterval(animInterval); animInterval = null; }
        animBtn.textContent = 'Animate';
        animBtn.classList.remove('viz-btn-secondary');
        animBtn.classList.add('viz-btn-primary');

        document.getElementById('show-sum').checked = true;
        document.getElementById('show-proj').checked = false;
        state.showSum = true;
        state.showDot = false;

        applyPreset('perpendicular');
    });
});
</script>
