<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Polar Coordinates Grapher - Rose, Cardioid, Spiral, Lemniscate (Free)";
    String seoDescription = "Interactive polar coordinate plotter. Graph rose curves, cardioids, spirals, lemniscates, lima\u00e7ons. See the curve traced with animated \u03b8 sweep. Adjust parameters in real time.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-math/polar-coordinates.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Polar Coordinates Grapher - Rose, Cardioid, Spiral\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Polar Coordinates Grapher\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"polar coordinates, polar graph, rose curve, cardioid, spiral, lemniscate, limacon, polar equation, r theta graph, trigonometry, precalculus\">");

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
        <span class="breadcrumb-current">Polar Coordinates</span>
    </nav>

    <div class="viz-header">
        <h1>Polar Coordinates Grapher</h1>
        <p class="viz-subtitle">Plot rose curves, cardioids, spirals, lemniscates, and lima&ccedil;ons. Watch the curve trace out as &theta; sweeps from 0 to 2&pi;.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Polar Curve</h3>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-preset="rose3">3-Petal Rose</button>
                        <button class="vm-chip" data-preset="cardioid">Cardioid</button>
                        <button class="vm-chip" data-preset="spiral">Spiral</button>
                        <button class="vm-chip" data-preset="lemniscate">Lemniscate</button>
                        <button class="vm-chip" data-preset="limacon">Lima&ccedil;on</button>
                        <button class="vm-chip" data-preset="circle">Circle</button>
                    </div>
                </div>

                <div class="control-group" id="a-group">
                    <label><span id="a-label">Amplitude a</span> = <span id="a-display">3.0</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="a-slider" min="0.5" max="5" value="3" step="0.1">
                        <span class="viz-slider-val" id="a-val">3.0</span>
                    </div>
                </div>

                <div class="control-group" id="n-group">
                    <label><span id="n-label">Petals n</span> = <span id="n-display">3</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="n-slider" min="1" max="8" value="3" step="1">
                        <span class="viz-slider-val" id="n-val">3</span>
                    </div>
                </div>

                <div class="viz-btn-row">
                    <button class="viz-btn viz-btn-primary" id="animate-btn">Trace</button>
                    <button class="viz-btn viz-btn-secondary" id="reset-btn">Reset</button>
                </div>
            </div>

            <div class="viz-values">
                <h3>Properties</h3>
                <table>
                    <tr><td>Curve</td><td id="val-curve">--</td></tr>
                    <tr><td>Equation</td><td id="val-polar-eq">--</td></tr>
                    <tr><td>Shape</td><td id="val-petals">--</td></tr>
                    <tr><td>Symmetry</td><td id="val-symmetry">--</td></tr>
                    <tr><td>Max r</td><td id="val-max-r">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Math Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Polar Coordinates</h3>
                <ul>
                    <li>A point is described by <span class="formula-highlight">(r, &theta;)</span> &mdash; distance and angle</li>
                    <li>Conversion: <span class="formula-highlight">x = r&middot;cos&theta;</span>, <span class="formula-highlight">y = r&middot;sin&theta;</span></li>
                    <li>Inverse: r = &radic;(x&sup2; + y&sup2;), &theta; = atan2(y, x)</li>
                    <li>Curves are defined as <strong>r = f(&theta;)</strong></li>
                    <li>As &theta; sweeps from 0 to 2&pi;, the curve traces out</li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Common Polar Curves</h3>
                <ul>
                    <li><strong>Rose</strong>: <span class="formula-highlight">r = a&middot;cos(n&theta;)</span> &mdash; n petals (n odd) or 2n petals (n even)</li>
                    <li><strong>Cardioid</strong>: <span class="formula-highlight">r = a(1 + cos&theta;)</span> &mdash; heart-shaped</li>
                    <li><strong>Lemniscate</strong>: <span class="formula-highlight">r&sup2; = a&sup2;&middot;cos(2&theta;)</span> &mdash; figure-eight</li>
                    <li><strong>Spiral</strong>: <span class="formula-highlight">r = a&middot;&theta;</span> (Archimedean) &mdash; expands outward</li>
                    <li><strong>Lima&ccedil;on</strong>: <span class="formula-highlight">r = a + b&middot;cos&theta;</span> &mdash; may have inner loop</li>
                    <li><strong>Circle</strong>: <span class="formula-highlight">r = a</span> &mdash; constant radius</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-math/unit-circle.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(239,68,68,0.12);">&#9675;</div>
                <div><h4>Unit Circle</h4><span>Trigonometry</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/parametric-curves.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(34,197,94,0.12);">&#8734;</div>
                <div><h4>Parametric Curves</h4><span>Calculus</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#8943;</div>
                <div><h4>All Visualizations</h4><span>Browse</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{"@context":"https://schema.org","@type":"LearningResource","name":"Polar Coordinates Grapher","description":"Interactive polar coordinate plotter. Graph rose curves, cardioids, spirals, lemniscates, and limasons with animated theta sweep and adjustable parameters.","url":"https://8gwifi.org/exams/visual-math/polar-coordinates.jsp","educationalLevel":"High School","teaches":"Polar coordinates, polar curves, rose curves, cardioid, lemniscate, spiral, limacon, theta sweep","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Math Lab","item":"https://8gwifi.org/exams/visual-math/"},{"@type":"ListItem","position":4,"name":"Polar Coordinates"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"What is the difference between polar and Cartesian coordinates?","acceptedAnswer":{"@type":"Answer","text":"Cartesian coordinates use (x, y) \u2014 horizontal and vertical distances from the origin. Polar coordinates use (r, \u03b8) \u2014 the distance from the origin and the angle from the positive x-axis. They are related by x = r\u00b7cos\u03b8 and y = r\u00b7sin\u03b8. Polar coordinates are often more natural for curves with rotational symmetry."}},{"@type":"Question","name":"How many petals does a rose curve have?","acceptedAnswer":{"@type":"Answer","text":"For the rose curve r = a\u00b7cos(n\u03b8): if n is odd, the curve has exactly n petals. If n is even, it has 2n petals. For example, r = 3cos(3\u03b8) has 3 petals, while r = 3cos(4\u03b8) has 8 petals. The same rules apply to r = a\u00b7sin(n\u03b8), but the curve is rotated."}},{"@type":"Question","name":"What is a cardioid?","acceptedAnswer":{"@type":"Answer","text":"A cardioid is a heart-shaped polar curve defined by r = a(1 + cos\u03b8) or r = a(1 + sin\u03b8). It passes through the origin and has a single cusp. The name comes from the Greek word for heart. Cardioids are a special case of lima\u00e7ons where the inner loop just disappears."}}]}
</script>

<%@ include file="viz-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-polar.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('polar', 'viz-canvas', {
        curveType: 'rose',
        paramA: 3,
        paramN: 3,
        animating: false,
        traceAngle: 0
    });
    var state = VisualMath.getState();

    var presets = {
        'rose3':      { type: 'rose', a: 3, n: 3 },
        'cardioid':   { type: 'cardioid', a: 2, n: 0 },
        'spiral':     { type: 'spiral', a: 1, n: 0 },
        'lemniscate': { type: 'lemniscate', a: 3, n: 0 },
        'limacon':    { type: 'limacon', a: 2, n: 3 },
        'circle':     { type: 'circle', a: 3, n: 0 }
    };

    function updateLabels(curveType) {
        var aLabel = document.getElementById('a-label');
        var nLabel = document.getElementById('n-label');
        var nGroup = document.getElementById('n-group');

        // a-label
        if (curveType === 'circle') {
            aLabel.textContent = 'Radius r';
        } else {
            aLabel.textContent = 'Amplitude a';
        }

        // n-slider visibility and label
        if (curveType === 'rose') {
            nGroup.style.display = '';
            nLabel.textContent = 'Petals n';
        } else if (curveType === 'limacon') {
            nGroup.style.display = '';
            nLabel.textContent = 'b';
        } else {
            nGroup.style.display = 'none';
        }
    }

    function applyPreset(key) {
        var p = presets[key];
        state.curveType = p.type;
        state.paramA = p.a;
        state.paramN = p.n;
        state.animating = false;
        state.traceAngle = 0;

        document.getElementById('a-slider').value = p.a;
        document.getElementById('a-display').textContent = p.a.toFixed(1);
        document.getElementById('a-val').textContent = p.a.toFixed(1);

        document.getElementById('n-slider').value = Math.max(p.n, 1);
        document.getElementById('n-display').textContent = Math.max(p.n, 1);
        document.getElementById('n-val').textContent = Math.max(p.n, 1);

        updateLabels(p.type);

        // Reset animate button
        var animBtn = document.getElementById('animate-btn');
        animBtn.textContent = 'Trace';
        animBtn.classList.remove('viz-btn-secondary');
        animBtn.classList.add('viz-btn-primary');

        document.querySelectorAll('[data-preset]').forEach(function (btn) {
            btn.classList.toggle('active', btn.getAttribute('data-preset') === key);
        });
        state._redraw();
    }

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () { applyPreset(this.getAttribute('data-preset')); });
    });

    document.getElementById('a-slider').addEventListener('input', function () {
        var v = parseFloat(this.value);
        state.paramA = v;
        document.getElementById('a-display').textContent = v.toFixed(1);
        document.getElementById('a-val').textContent = v.toFixed(1);
        document.querySelectorAll('[data-preset]').forEach(function (btn) { btn.classList.remove('active'); });
        state._redraw();
    });

    document.getElementById('n-slider').addEventListener('input', function () {
        var v = parseInt(this.value);
        state.paramN = v;
        document.getElementById('n-display').textContent = v;
        document.getElementById('n-val').textContent = v;
        document.querySelectorAll('[data-preset]').forEach(function (btn) { btn.classList.remove('active'); });
        state._redraw();
    });

    // Animate (Trace): sweep theta from 0 to 2pi
    var animInterval = null;
    document.getElementById('animate-btn').addEventListener('click', function () {
        var btn = this;
        if (animInterval) {
            // Pause
            clearInterval(animInterval);
            animInterval = null;
            state.animating = false;
            btn.textContent = 'Trace';
            btn.classList.remove('viz-btn-secondary');
            btn.classList.add('viz-btn-primary');
            return;
        }
        // Start trace
        btn.textContent = 'Pause';
        btn.classList.add('viz-btn-secondary');
        btn.classList.remove('viz-btn-primary');
        state.animating = true;
        state.traceAngle = 0;
        var maxAngle = (state.curveType === 'spiral') ? 6 * Math.PI : 2 * Math.PI;
        animInterval = setInterval(function () {
            state.traceAngle += 0.03;
            if (state.traceAngle > maxAngle) {
                clearInterval(animInterval);
                animInterval = null;
                state.animating = false;
                btn.textContent = 'Trace';
                btn.classList.remove('viz-btn-secondary');
                btn.classList.add('viz-btn-primary');
                return;
            }
            state._redraw();
        }, 20);
    });

    document.getElementById('reset-btn').addEventListener('click', function () {
        if (animInterval) { clearInterval(animInterval); animInterval = null; }
        state.animating = false;
        state.traceAngle = 0;
        var btn = document.getElementById('animate-btn');
        btn.textContent = 'Trace'; btn.classList.remove('viz-btn-secondary'); btn.classList.add('viz-btn-primary');
        applyPreset('rose3');
    });
});
</script>
