<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Quadratic Equation Explorer - Parabola Grapher & Vertex Calculator (Free)";
    String seoDescription = "Free interactive quadratic equation grapher. Adjust a, b, c and see the parabola, vertex, roots, discriminant, and vertex form update in real-time. Solve ax\u00B2+bx+c=0 visually.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-math/quadratic.jsp";

    StringBuilder extraHead=new StringBuilder();
        extraHead.append("<meta property=\"og:title\" content=\"Quadratic Equation Explorer - Interactive Parabola Grapher\">");
    extraHead.append("<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("<meta property=\"og:type\" content=\"website\">");
    extraHead.append("<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("<meta name=\"twitter:title\" content=\"Quadratic Equation Explorer - Parabola & Vertex Calculator\">");
    extraHead.append("<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("<meta name=\"keywords\" content=\"quadratic equation solver, parabola grapher, vertex calculator, discriminant calculator, quadratic formula, ax2+bx+c, roots of quadratic, vertex form, completing the square, quadratic graph\">");

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
        <span class="breadcrumb-current">Quadratic Explorer</span>
    </nav>

    <div class="viz-header">
        <h1>Quadratic Equation Explorer</h1>
        <p class="viz-subtitle">Drag the sliders for a, b, and c. Watch the parabola reshape, roots move, and the vertex shift in real-time.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>y = ax&sup2; + bx + c</h3>

                <div class="control-group">
                    <label>a = <span id="a-display">1</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="a-slider" min="-5" max="5" value="1" step="0.1">
                        <span class="viz-slider-val" id="a-val">1.0</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>b = <span id="b-display">0</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="b-slider" min="-10" max="10" value="0" step="0.1">
                        <span class="viz-slider-val" id="b-val">0.0</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>c = <span id="c-display">-4</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="c-slider" min="-10" max="10" value="-4" step="0.1">
                        <span class="viz-slider-val" id="c-val">-4.0</span>
                    </div>
                </div>

                <div class="viz-btn-row">
                    <button class="viz-btn viz-btn-primary" id="animate-btn">Animate</button>
                    <button class="viz-btn viz-btn-secondary" id="reset-btn">Reset</button>
                </div>
            </div>

            <div class="viz-values">
                <h3>Properties</h3>
                <table>
                    <tr><td>Vertex</td><td id="val-vertex">&mdash;</td></tr>
                    <tr><td>&Delta;</td><td id="val-disc">&mdash;</td></tr>
                    <tr><td>Roots</td><td id="val-roots">&mdash;</td></tr>
                    <tr><td>y-int</td><td id="val-yint">&mdash;</td></tr>
                    <tr><td>Vertex form</td><td id="val-vertex-form">&mdash;</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Math Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Quadratic Equation</h3>
                <ul>
                    <li>Standard form: <span class="formula-highlight">y = ax&sup2; + bx + c</span></li>
                    <li>Vertex: <span class="formula-highlight">(-b/2a, f(-b/2a))</span></li>
                    <li>Vertex form: <span class="formula-highlight">y = a(x - h)&sup2; + k</span></li>
                    <li>The parabola opens up when a &gt; 0, down when a &lt; 0</li>
                </ul>
                <h3 style="margin-top:var(--space-4);">Quadratic Formula</h3>
                <ul>
                    <li>Roots: <span class="formula-highlight">x = (-b &plusmn; &radic;&Delta;) / 2a</span></li>
                    <li>Discriminant: <span class="formula-highlight">&Delta; = b&sup2; - 4ac</span></li>
                    <li>&Delta; &gt; 0: two distinct real roots</li>
                    <li>&Delta; = 0: one repeated root (vertex touches x-axis)</li>
                    <li>&Delta; &lt; 0: no real roots (parabola doesn't cross x-axis)</li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Try This</h3>
                <ul>
                    <li>Set <strong>a=1, b=0, c=-4</strong> &mdash; roots at x = &plusmn;2</li>
                    <li>Set <strong>c=0</strong> &mdash; the parabola always passes through the origin</li>
                    <li>Set <strong>a=1, b=-2, c=1</strong> &mdash; &Delta;=0, vertex sits on the x-axis</li>
                    <li>Make <strong>a negative</strong> &mdash; the parabola flips upside down</li>
                    <li>Slide <strong>b</strong> &mdash; the vertex traces a parabolic path</li>
                    <li>Try <strong>&Delta; &lt; 0</strong> (e.g., a=1, b=0, c=4) &mdash; no real roots, parabola floats above the x-axis</li>
                </ul>
                <h3 style="margin-top:var(--space-4);">Key Insight</h3>
                <p>The discriminant &Delta; determines everything about the roots. Positive = two intersections with the x-axis, zero = the parabola just touches, negative = it misses entirely.</p>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-math/polynomial-roots.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(168,85,247,0.12);">&#119909;</div>
                <div><h4>Polynomial Roots</h4><span>Algebra</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/function-plotter.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(34,197,94,0.12);">&#119891;</div>
                <div><h4>Function Plotter</h4><span>Calculus</span></div>
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
    "name": "Quadratic Equation Explorer",
    "description": "Interactive quadratic equation grapher showing parabola, vertex, roots, discriminant, y-intercept, and vertex form with adjustable coefficients a, b, c.",
    "url": "https://8gwifi.org/exams/visual-math/quadratic.jsp",
    "educationalLevel": "High School",
    "teaches": "Quadratic equations, parabolas, vertex form, and the discriminant",
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
        { "@type": "ListItem", "position": 4, "name": "Quadratic Explorer" }
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
            "name": "What is the quadratic formula?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The quadratic formula x = (-b +/- sqrt(b^2 - 4ac)) / (2a) gives the roots (solutions) of any quadratic equation ax^2 + bx + c = 0. The discriminant (b^2 - 4ac) determines whether there are two real roots (positive discriminant), one repeated root (zero discriminant), or no real roots (negative discriminant)."
            }
        },
        {
            "@type": "Question",
            "name": "What is vertex form of a quadratic?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Vertex form is y = a(x - h)^2 + k, where (h, k) is the vertex (highest or lowest point) of the parabola. You can convert from standard form by completing the square, or by using h = -b/(2a) and k = f(h). The vertex form makes it easy to read the vertex coordinates and understand transformations."
            }
        },
        {
            "@type": "Question",
            "name": "How does the discriminant affect the graph?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The discriminant (delta = b^2 - 4ac) determines how the parabola intersects the x-axis. When delta > 0, the parabola crosses the x-axis at two points (two real roots). When delta = 0, the vertex touches the x-axis (one repeated root). When delta < 0, the parabola doesn't cross the x-axis at all (no real roots, only complex roots)."
            }
        }
    ]
}
</script>

<%@ include file="viz-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>

<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-quadratic.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    VisualMath.init('quadratic', 'viz-canvas', { a: 1, b: 0, c: -4 });

    var state = VisualMath.getState();

    function bindSlider(id, prop) {
        document.getElementById(id).addEventListener('input', function() {
            var v = parseFloat(this.value);
            state[prop] = v;
            document.getElementById(prop + '-display').textContent = v;
            document.getElementById(prop + '-val').textContent = v.toFixed(1);
            state._redraw();
        });
    }

    bindSlider('a-slider', 'a');
    bindSlider('b-slider', 'b');
    bindSlider('c-slider', 'c');

    // Animate — sweep b from -10 to +10, showing vertex motion
    var animInterval = null;
    var animBtn = document.getElementById('animate-btn');
    animBtn.addEventListener('click', function() {
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

        var bSlider = document.getElementById('b-slider');
        bSlider.value = -10;
        state.b = -10;
        document.getElementById('b-display').textContent = '-10';
        document.getElementById('b-val').textContent = '-10.0';
        state._redraw();

        animInterval = setInterval(function() {
            var cur = parseFloat(bSlider.value);
            if (cur >= 10) {
                clearInterval(animInterval); animInterval = null;
                animBtn.textContent = 'Animate';
                animBtn.classList.remove('viz-btn-secondary');
                animBtn.classList.add('viz-btn-primary');
                return;
            }
            cur = Math.min(10, cur + 0.2);
            bSlider.value = cur;
            state.b = cur;
            document.getElementById('b-display').textContent = cur.toFixed(1);
            document.getElementById('b-val').textContent = cur.toFixed(1);
            state._redraw();
        }, 50);
    });

    // Reset
    document.getElementById('reset-btn').addEventListener('click', function() {
        if (animInterval) { clearInterval(animInterval); animInterval = null; }
        animBtn.textContent = 'Animate';
        animBtn.classList.remove('viz-btn-secondary');
        animBtn.classList.add('viz-btn-primary');

        state.a = 1; state.b = 0; state.c = -4;
        document.getElementById('a-slider').value = 1;
        document.getElementById('a-display').textContent = '1';
        document.getElementById('a-val').textContent = '1.0';
        document.getElementById('b-slider').value = 0;
        document.getElementById('b-display').textContent = '0';
        document.getElementById('b-val').textContent = '0.0';
        document.getElementById('c-slider').value = -4;
        document.getElementById('c-display').textContent = '-4';
        document.getElementById('c-val').textContent = '-4.0';
        state._redraw();
    });
});
</script>
