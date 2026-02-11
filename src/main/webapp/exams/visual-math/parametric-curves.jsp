<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Parametric Curves Explorer - Lissajous, Epicycloid, Astroid, Butterfly (Free)";
    String seoDescription = "Interactive parametric curves plotter. Graph Lissajous figures, epicycloids, astroids, butterfly curves, and hypotrochoids. Trace the path as parameter t sweeps from 0 to 2pi.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-math/parametric-curves.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Parametric Curves Explorer - Lissajous, Epicycloid, Astroid\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Parametric Curves Explorer\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"parametric curves, lissajous curve, epicycloid, astroid, butterfly curve, hypotrochoid, spirograph, parametric equations\">");

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
        <span class="breadcrumb-current">Parametric Curves</span>
    </nav>

    <div class="viz-header">
        <h1>Parametric Curves Explorer</h1>
        <p class="viz-subtitle">Plot Lissajous figures, epicycloids, astroids, butterfly curves, and hypotrochoids. Watch the curve trace as the parameter t sweeps from 0 to 2&pi;.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Parametric Curve</h3>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-preset="lissajous">Lissajous 3:2</button>
                        <button class="vm-chip" data-preset="epicycloid">Epicycloid</button>
                        <button class="vm-chip" data-preset="astroid">Astroid</button>
                        <button class="vm-chip" data-preset="butterfly">Butterfly</button>
                        <button class="vm-chip" data-preset="hypotrochoid">Hypotrochoid</button>
                    </div>
                </div>

                <div class="control-group" id="a-group">
                    <label><span id="a-label">a</span> = <span id="a-display">3</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="a-slider" min="1" max="8" value="3" step="1">
                        <span class="viz-slider-val" id="a-val">3</span>
                    </div>
                </div>

                <div class="control-group" id="b-group">
                    <label><span id="b-label">b</span> = <span id="b-display">2</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="b-slider" min="1" max="7" value="2" step="1">
                        <span class="viz-slider-val" id="b-val">2</span>
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
                    <tr><td>x(t)</td><td id="val-xt">--</td></tr>
                    <tr><td>y(t)</td><td id="val-yt">--</td></tr>
                    <tr><td>Period</td><td id="val-period">--</td></tr>
                    <tr><td>Symmetry</td><td id="val-symmetry">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Math Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Parametric Equations</h3>
                <ul>
                    <li>A curve is defined by separate functions <span class="formula-highlight">x(t)</span> and <span class="formula-highlight">y(t)</span></li>
                    <li>The parameter t usually ranges over <span class="formula-highlight">[0, 2&pi;]</span></li>
                    <li>Each value of t gives a point (x, y) on the curve</li>
                    <li>Lissajous: the ratio <strong>a : b</strong> determines the shape &mdash; rational ratios close the curve</li>
                    <li>Parametric form lets us describe curves that fail the vertical line test</li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Famous Curves</h3>
                <ul>
                    <li><strong>Lissajous</strong>: <span class="formula-highlight">x = sin(at)</span>, <span class="formula-highlight">y = sin(bt)</span> &mdash; frequency ratio a:b determines pattern</li>
                    <li><strong>Epicycloid</strong>: circle of radius b rolling outside a circle of radius a &mdash; produces cusps</li>
                    <li><strong>Astroid</strong>: special epicycloid with <strong>4 cusps</strong>, <span class="formula-highlight">x = a&middot;cos&sup3;t</span></li>
                    <li><strong>Butterfly</strong>: <span class="formula-highlight">r = e<sup>cos t</sup> &minus; 2cos(4t) + sin&sup5;(t/12)</span> in polar form</li>
                    <li><strong>Hypotrochoid</strong>: circle rolling inside another &mdash; the <em>Spirograph</em> principle</li>
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
{"@context":"https://schema.org","@type":"LearningResource","name":"Parametric Curves Explorer","description":"Interactive parametric curves plotter. Graph Lissajous figures, epicycloids, astroids, butterfly curves, and hypotrochoids with animated trace and adjustable parameters.","url":"https://8gwifi.org/exams/visual-math/parametric-curves.jsp","educationalLevel":"High School","teaches":"Parametric equations, Lissajous curves, epicycloid, astroid, butterfly curve, hypotrochoid, spirograph","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Math Lab","item":"https://8gwifi.org/exams/visual-math/"},{"@type":"ListItem","position":4,"name":"Parametric Curves"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"What is a parametric equation?","acceptedAnswer":{"@type":"Answer","text":"A parametric equation defines a curve using a pair of functions x(t) and y(t), where t is an independent parameter. As t varies over an interval, the point (x(t), y(t)) traces out the curve. This allows us to describe curves that cannot be written as y = f(x), including loops and self-intersecting paths."}},{"@type":"Question","name":"What is a Lissajous curve?","acceptedAnswer":{"@type":"Answer","text":"A Lissajous curve (or Lissajous figure) is defined by x = sin(at) and y = sin(bt + \u03b4). The shape depends on the frequency ratio a:b. When a:b is a simple rational number like 1:2 or 3:2, the curve closes into a recognizable pattern. These figures appear on oscilloscopes when two sinusoidal signals are combined."}},{"@type":"Question","name":"How do epicycloids relate to gears?","acceptedAnswer":{"@type":"Answer","text":"An epicycloid is the curve traced by a point on a circle rolling around the outside of another circle. The shape of gear teeth is often based on epicycloid and hypocycloid profiles because these curves ensure smooth, constant-velocity power transmission between meshing gears. The number of cusps equals the ratio of the radii."}}]}
</script>

<%@ include file="viz-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-parametric.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('parametric', 'viz-canvas', {
        curveType: 'lissajous',
        paramA: 3,
        paramB: 2,
        animating: false,
        traceT: 0
    });
    var state = VisualMath.getState();

    var presets = {
        'lissajous':    { curveType: 'lissajous',    a: 3, b: 2 },
        'epicycloid':   { curveType: 'epicycloid',    a: 3, b: 1 },
        'astroid':      { curveType: 'astroid',       a: 3, b: 0 },
        'butterfly':    { curveType: 'butterfly',     a: 1, b: 0 },
        'hypotrochoid': { curveType: 'hypotrochoid',  a: 5, b: 2 }
    };

    function updateSliderVisibility(curveType) {
        var bGroup = document.getElementById('b-group');
        if (curveType === 'astroid' || curveType === 'butterfly') {
            bGroup.style.display = 'none';
        } else {
            bGroup.style.display = '';
        }
    }

    function applyPreset(key) {
        var p = presets[key];
        state.curveType = p.curveType;
        state.paramA = p.a;
        state.paramB = p.b;
        state.animating = false;
        state.traceT = 0;

        document.getElementById('a-slider').value = p.a;
        document.getElementById('a-display').textContent = p.a;
        document.getElementById('a-val').textContent = p.a;

        document.getElementById('b-slider').value = Math.max(p.b, 1);
        document.getElementById('b-display').textContent = Math.max(p.b, 1);
        document.getElementById('b-val').textContent = Math.max(p.b, 1);

        updateSliderVisibility(p.curveType);

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
        var v = parseInt(this.value);
        state.paramA = v;
        document.getElementById('a-display').textContent = v;
        document.getElementById('a-val').textContent = v;
        document.querySelectorAll('[data-preset]').forEach(function (btn) { btn.classList.remove('active'); });
        state._redraw();
    });

    document.getElementById('b-slider').addEventListener('input', function () {
        var v = parseInt(this.value);
        state.paramB = v;
        document.getElementById('b-display').textContent = v;
        document.getElementById('b-val').textContent = v;
        document.querySelectorAll('[data-preset]').forEach(function (btn) { btn.classList.remove('active'); });
        state._redraw();
    });

    // Animate (Trace): sweep t from 0 to 2pi
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
        state.traceT = 0;
        var maxT = 2 * Math.PI;
        animInterval = setInterval(function () {
            state.traceT += 0.03;
            if (state.traceT > maxT) {
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
        state.traceT = 0;
        var btn = document.getElementById('animate-btn');
        btn.textContent = 'Trace'; btn.classList.remove('viz-btn-secondary'); btn.classList.add('viz-btn-primary');
        applyPreset('lissajous');
    });
});
</script>
