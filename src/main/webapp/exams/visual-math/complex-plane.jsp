<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Complex Number Visualizer - Add, Multiply on Argand Plane (Free)";
    String seoDescription = "Interactive complex plane explorer. Drag complex numbers, see addition, subtraction, multiplication, division. View polar form, modulus, argument, and geometric meaning of operations.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-math/complex-plane.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Complex Number Visualizer - Argand Plane\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Complex Number Visualizer\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"complex numbers, argand plane, complex plane, complex addition, complex multiplication, polar form, modulus, argument, conjugate, roots of unity, Euler formula, algebra 2\">");

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
        <span class="breadcrumb-current">Complex Plane</span>
    </nav>

    <div class="viz-header">
        <h1>Complex Number Visualizer</h1>
        <p class="viz-subtitle">Explore complex arithmetic on the Argand plane. Drag z&#8321; and z&#8322; to see addition, multiplication, and more &mdash; geometrically.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Complex Operations</h3>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-preset="add">Add</button>
                        <button class="vm-chip" data-preset="multiply">Multiply</button>
                        <button class="vm-chip" data-preset="conjugate">Conjugate</button>
                        <button class="vm-chip" data-preset="roots">Roots of Unity</button>
                        <button class="vm-chip" data-preset="perpendicular">Perpendicular</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>Operation</label>
                    <div class="viz-check-group">
                        <label class="viz-check"><input type="radio" name="operation" value="add" checked> Add</label>
                        <label class="viz-check"><input type="radio" name="operation" value="subtract"> Subtract</label>
                        <label class="viz-check"><input type="radio" name="operation" value="multiply"> Multiply</label>
                        <label class="viz-check"><input type="radio" name="operation" value="divide"> Divide</label>
                    </div>
                </div>

                <div class="viz-btn-row">
                    <button class="viz-btn viz-btn-primary" id="animate-btn">Animate</button>
                    <button class="viz-btn viz-btn-secondary" id="reset-btn">Reset</button>
                </div>

                <p style="font-size:var(--text-sm);color:var(--text-secondary);margin-top:8px;">Drag z&#8321; and z&#8322; to change values.</p>
            </div>

            <div class="viz-values">
                <h3>Properties</h3>
                <table>
                    <tr><td>z&#8321;</td><td id="val-z1">--</td></tr>
                    <tr><td>z&#8322;</td><td id="val-z2">--</td></tr>
                    <tr><td>z&#8321; polar</td><td id="val-polar1">--</td></tr>
                    <tr><td>z&#8322; polar</td><td id="val-polar2">--</td></tr>
                    <tr><td>Operation</td><td id="val-result-label">--</td></tr>
                    <tr><td>Result</td><td id="val-result">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Math Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Complex Number Basics</h3>
                <ul>
                    <li>Rectangular form: <span class="formula-highlight">z = a + bi</span></li>
                    <li>Modulus: <span class="formula-highlight">|z| = &radic;(a&sup2; + b&sup2;)</span></li>
                    <li>Argument: <span class="formula-highlight">&theta; = atan2(b, a)</span></li>
                    <li>Polar form: <span class="formula-highlight">z = r(cos&theta; + i&middot;sin&theta;)</span></li>
                    <li>Conjugate: <span class="formula-highlight">z&#772; = a - bi</span> (reflect across real axis)</li>
                    <li>Euler: <span class="formula-highlight">e<sup>i&theta;</sup> = cos&theta; + i&middot;sin&theta;</span></li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Operations Geometrically</h3>
                <ul>
                    <li><strong>Addition</strong>: parallelogram rule &mdash; place vectors tip to tail</li>
                    <li><strong>Subtraction</strong>: add the negative &mdash; reverse z&#8322; then add</li>
                    <li><strong>Multiplication</strong>: <strong>multiply moduli, add arguments</strong></li>
                    <li>|z&#8321;z&#8322;| = |z&#8321;|&middot;|z&#8322;|, arg(z&#8321;z&#8322;) = arg(z&#8321;) + arg(z&#8322;)</li>
                    <li><strong>Division</strong>: <strong>divide moduli, subtract arguments</strong></li>
                    <li>|z&#8321;/z&#8322;| = |z&#8321;|/|z&#8322;|, arg(z&#8321;/z&#8322;) = arg(z&#8321;) - arg(z&#8322;)</li>
                </ul>
                <h3 style="margin-top:var(--space-4);">Roots of Unity</h3>
                <ul>
                    <li>nth roots of unity: <span class="formula-highlight">e<sup>2&pi;ik/n</sup></span> for k = 0, 1, ..., n-1</li>
                    <li>Equally spaced points on the unit circle</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-math/polar-coordinates.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(239,68,68,0.12);">&#10687;</div>
                <div><h4>Polar Coordinates</h4><span>Trigonometry</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/vectors-2d.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(59,130,246,0.12);">&rarr;</div>
                <div><h4>2D Vectors</h4><span>Linear Algebra</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#8943;</div>
                <div><h4>All Visualizations</h4><span>Browse</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{"@context":"https://schema.org","@type":"LearningResource","name":"Complex Number Visualizer","description":"Interactive complex plane explorer. Drag complex numbers to see addition, subtraction, multiplication, division with polar form, modulus, and argument.","url":"https://8gwifi.org/exams/visual-math/complex-plane.jsp","educationalLevel":"High School","teaches":"Complex numbers, Argand plane, complex addition, complex multiplication, polar form, modulus, argument, conjugate, roots of unity","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Math Lab","item":"https://8gwifi.org/exams/visual-math/"},{"@type":"ListItem","position":4,"name":"Complex Plane"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"What is the complex plane?","acceptedAnswer":{"@type":"Answer","text":"The complex plane (or Argand plane) is a 2D coordinate system where the horizontal axis represents the real part and the vertical axis represents the imaginary part of a complex number z = a + bi. Every complex number corresponds to a unique point (a, b) on this plane, connecting algebra with geometry."}},{"@type":"Question","name":"Why does multiplying complex numbers rotate them?","acceptedAnswer":{"@type":"Answer","text":"In polar form, z = r(cos\u03b8 + i\u00b7sin\u03b8). When you multiply two complex numbers, you multiply their moduli and add their arguments: |z1\u00b7z2| = |z1|\u00b7|z2| and arg(z1\u00b7z2) = arg(z1) + arg(z2). So multiplying by a complex number with modulus 1 is a pure rotation by its argument angle."}},{"@type":"Question","name":"What are roots of unity?","acceptedAnswer":{"@type":"Answer","text":"The nth roots of unity are the n complex numbers that satisfy z^n = 1. They are given by e^(2\u03c0ik/n) for k = 0, 1, ..., n-1, and are equally spaced around the unit circle. For example, the cube roots of unity are 1, e^(2\u03c0i/3), and e^(4\u03c0i/3) \u2014 three points forming an equilateral triangle on the unit circle."}}]}
</script>

<%@ include file="viz-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-complex.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('complex', 'viz-canvas', {
        re1: 3,
        im1: 2,
        re2: -1,
        im2: 3,
        operation: 'add'
    });
    var state = VisualMath.getState();

    var presets = {
        'add':           { re1: 3, im1: 2, re2: -1, im2: 3, op: 'add' },
        'multiply':      { re1: 2, im1: 1, re2: 0, im2: 2, op: 'multiply' },
        'conjugate':     { re1: 2, im1: 3, re2: 2, im2: -3, op: 'add' },
        'roots':         { re1: 1, im1: 0, re2: -0.5, im2: 0.866, op: 'multiply' },
        'perpendicular': { re1: 3, im1: 1, re2: -1, im2: 3, op: 'add' }
    };

    function setOperationRadio(op) {
        document.querySelectorAll('input[name="operation"]').forEach(function (r) {
            r.checked = (r.value === op);
        });
    }

    function applyPreset(key) {
        var p = presets[key];
        state.re1 = p.re1;
        state.im1 = p.im1;
        state.re2 = p.re2;
        state.im2 = p.im2;
        state.operation = p.op;

        setOperationRadio(p.op);

        document.querySelectorAll('[data-preset]').forEach(function (btn) {
            btn.classList.toggle('active', btn.getAttribute('data-preset') === key);
        });
        state._redraw();
    }

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () { applyPreset(this.getAttribute('data-preset')); });
    });

    document.querySelectorAll('input[name="operation"]').forEach(function (radio) {
        radio.addEventListener('change', function () {
            state.operation = this.value;
            document.querySelectorAll('[data-preset]').forEach(function (btn) { btn.classList.remove('active'); });
            state._redraw();
        });
    });

    // Animate: rotate z2 around a circle of radius 2
    var animInterval = null;
    var animAngle = 0;
    document.getElementById('animate-btn').addEventListener('click', function () {
        var btn = this;
        if (animInterval) { clearInterval(animInterval); animInterval = null; btn.textContent = 'Animate'; btn.classList.remove('viz-btn-secondary'); btn.classList.add('viz-btn-primary'); return; }
        btn.textContent = 'Pause'; btn.classList.add('viz-btn-secondary'); btn.classList.remove('viz-btn-primary');
        animAngle = 0;
        animInterval = setInterval(function () {
            animAngle += 0.03;
            if (animAngle > 2 * Math.PI) { clearInterval(animInterval); animInterval = null; btn.textContent = 'Animate'; btn.classList.remove('viz-btn-secondary'); btn.classList.add('viz-btn-primary'); return; }
            state.re2 = 2 * Math.cos(animAngle);
            state.im2 = 2 * Math.sin(animAngle);
            document.querySelectorAll('[data-preset]').forEach(function (btn2) { btn2.classList.remove('active'); });
            state._redraw();
        }, 30);
    });

    document.getElementById('reset-btn').addEventListener('click', function () {
        if (animInterval) { clearInterval(animInterval); animInterval = null; }
        var btn = document.getElementById('animate-btn');
        btn.textContent = 'Animate'; btn.classList.remove('viz-btn-secondary'); btn.classList.add('viz-btn-primary');
        applyPreset('add');
    });
});
</script>
