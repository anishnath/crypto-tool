<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Fractal Explorer - Koch Snowflake, Sierpinski Triangle, Mandelbrot (Free)";
    String seoDescription = "Interactive fractal explorer. Visualize Koch snowflake, Sierpinski triangle, fractal trees, Barnsley fern, and Mandelbrot set. Adjust iterations, zoom, and parameters to discover self-similarity.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-math/fractal-explorer.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Fractal Explorer - Koch Snowflake, Sierpinski, Mandelbrot\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Fractal Explorer\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"fractals, Koch snowflake, Sierpinski triangle, Mandelbrot set, fractal dimension, self-similarity, Barnsley fern, fractal tree\">");

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
        <span class="breadcrumb-current">Fractal Explorer</span>
    </nav>

    <div class="viz-header">
        <h1>Fractal Explorer</h1>
        <p class="viz-subtitle">Explore self-similar structures: Koch snowflake, Sierpinski triangle, fractal trees, Barnsley fern, and the Mandelbrot set. Adjust iterations and parameters to see infinite complexity emerge.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Fractal</h3>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-preset="koch">Koch Snowflake</button>
                        <button class="vm-chip" data-preset="sierpinski">Sierpinski Triangle</button>
                        <button class="vm-chip" data-preset="tree">Fractal Tree</button>
                        <button class="vm-chip" data-preset="fern">Barnsley Fern</button>
                        <button class="vm-chip" data-preset="mandelbrot">Mandelbrot Set</button>
                    </div>
                </div>

                <div class="control-group param-group" id="iterations-group">
                    <label>Iterations = <span id="iterations-display">4</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="iterations-slider" min="1" max="8" value="4" step="1">
                        <span class="viz-slider-val" id="iterations-val">4</span>
                    </div>
                </div>

                <div class="control-group param-group" id="branch-angle-group" style="display:none;">
                    <label>Branch Angle = <span id="branch-angle-display">25</span>&deg;</label>
                    <div class="viz-slider-row">
                        <input type="range" id="branch-angle-slider" min="10" max="60" value="25" step="1">
                        <span class="viz-slider-val" id="branch-angle-val">25</span>
                    </div>
                </div>

                <div class="control-group param-group" id="max-iter-group" style="display:none;">
                    <label>Max Iterations = <span id="max-iter-display">50</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="max-iter-slider" min="10" max="200" value="50" step="10">
                        <span class="viz-slider-val" id="max-iter-val">50</span>
                    </div>
                </div>

                <div class="control-group param-group" id="zoom-group" style="display:none;">
                    <label>Zoom = <span id="zoom-display">1.500</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="zoom-slider" min="0.001" max="2" value="1.5" step="0.001">
                        <span class="viz-slider-val" id="zoom-val">1.500</span>
                    </div>
                </div>

                <div class="viz-btn-row">
                    <button class="viz-btn viz-btn-secondary" id="reset-btn">Reset</button>
                </div>
            </div>

            <div class="viz-values">
                <h3>Properties</h3>
                <table>
                    <tr><td>Fractal</td><td id="val-fractal">--</td></tr>
                    <tr><td>Dimension</td><td id="val-dimension">--</td></tr>
                    <tr><td>Segments</td><td id="val-segments">--</td></tr>
                    <tr><td>Property</td><td id="val-property">--</td></tr>
                    <tr><td>Iterations</td><td id="val-iterations">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Math Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Self-Similarity</h3>
                <ul>
                    <li>Fractals are shapes that <span class="formula-highlight">repeat at every scale</span></li>
                    <li>Fractal dimension (Hausdorff) differs from integer dimensions</li>
                    <li><strong>Koch snowflake</strong>: <span class="formula-highlight">D = log4/log3 &asymp; 1.262</span></li>
                    <li><strong>Sierpinski triangle</strong>: <span class="formula-highlight">D = log3/log2 &asymp; 1.585</span></li>
                    <li>Each iteration multiplies complexity &mdash; finite area, infinite perimeter</li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Mandelbrot Set</h3>
                <ul>
                    <li>Defined by the iteration <span class="formula-highlight">z<sub>n+1</sub> = z<sub>n</sub>&sup2; + c</span></li>
                    <li>Points are colored by <strong>escape velocity</strong> &mdash; how fast |z| exceeds 2</li>
                    <li>The boundary has fractal dimension 2</li>
                    <li>Connected with an infinitely complex boundary</li>
                    <li>Zooming reveals infinite detail &mdash; mini copies of the full set appear</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-math/complex-plane.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(59,130,246,0.12);">&#8520;</div>
                <div><h4>Complex Plane</h4><span>Linear Algebra</span></div>
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
{"@context":"https://schema.org","@type":"LearningResource","name":"Fractal Explorer","description":"Interactive fractal explorer. Visualize Koch snowflake, Sierpinski triangle, fractal trees, Barnsley fern, and Mandelbrot set with adjustable iterations and parameters.","url":"https://8gwifi.org/exams/visual-math/fractal-explorer.jsp","educationalLevel":"High School","teaches":"Fractals, self-similarity, Koch snowflake, Sierpinski triangle, Mandelbrot set, fractal dimension, Barnsley fern, fractal trees","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Math Lab","item":"https://8gwifi.org/exams/visual-math/"},{"@type":"ListItem","position":4,"name":"Fractal Explorer"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"What is a fractal?","acceptedAnswer":{"@type":"Answer","text":"A fractal is a geometric shape that exhibits self-similarity \u2014 it looks similar at every level of magnification. Fractals have fractional (non-integer) dimensions. Examples include the Koch snowflake (dimension \u2248 1.262), Sierpinski triangle (dimension \u2248 1.585), coastlines, and tree branching patterns. Fractals are generated by repeating a simple process infinitely, creating structures of infinite complexity from simple rules."}},{"@type":"Question","name":"How is fractal dimension calculated?","acceptedAnswer":{"@type":"Answer","text":"Fractal dimension (Hausdorff dimension) is calculated using the formula D = log(N) / log(S), where N is the number of self-similar pieces and S is the scaling factor. For the Koch snowflake: each segment is replaced by 4 copies scaled by 1/3, so D = log(4)/log(3) \u2248 1.262. For the Sierpinski triangle: 3 copies scaled by 1/2, giving D = log(3)/log(2) \u2248 1.585. These non-integer dimensions capture how the fractal fills space."}},{"@type":"Question","name":"What is the Mandelbrot set?","acceptedAnswer":{"@type":"Answer","text":"The Mandelbrot set is the set of complex numbers c for which the iteration z\u2099\u208a\u2081 = z\u2099\u00b2 + c (starting from z\u2080 = 0) does not diverge to infinity. Points inside the set are typically colored black, while points outside are colored by how quickly they escape (escape velocity). The boundary of the Mandelbrot set is infinitely complex \u2014 zooming in reveals ever more intricate structures, including miniature copies of the whole set."}}]}
</script>

<%@ include file="viz-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-fractals.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('fractals', 'viz-canvas', {
        fractalType: 'koch',
        iterations: 4,
        branchAngle: 25,
        shrinkRatio: 0.7,
        maxIter: 50,
        zoom: 1.5,
        centerX: -0.5,
        centerY: 0,
        fernPoints: 50000
    });
    var state = VisualMath.getState();

    var presets = {
        'koch':       { fractalType: 'koch',       iterations: 4 },
        'sierpinski': { fractalType: 'sierpinski',  iterations: 5 },
        'tree':       { fractalType: 'tree',        iterations: 8, branchAngle: 25, shrinkRatio: 0.7 },
        'fern':       { fractalType: 'fern',        fernPoints: 50000 },
        'mandelbrot': { fractalType: 'mandelbrot',  maxIter: 50, zoom: 1.5, centerX: -0.5, centerY: 0 }
    };

    function showSliderGroup(fractalType) {
        var iterGroup = document.getElementById('iterations-group');
        var angleGroup = document.getElementById('branch-angle-group');
        var maxIterGroup = document.getElementById('max-iter-group');
        var zoomGroup = document.getElementById('zoom-group');

        // Hide all optional groups first
        iterGroup.style.display = 'none';
        angleGroup.style.display = 'none';
        maxIterGroup.style.display = 'none';
        zoomGroup.style.display = 'none';

        // Show groups based on fractal type
        if (fractalType === 'koch' || fractalType === 'sierpinski' || fractalType === 'tree') {
            iterGroup.style.display = '';
        }
        if (fractalType === 'tree') {
            angleGroup.style.display = '';
        }
        if (fractalType === 'mandelbrot') {
            maxIterGroup.style.display = '';
            zoomGroup.style.display = '';
        }
        // fern: no slider groups shown
    }

    function applyPreset(key) {
        var p = presets[key];
        state.fractalType = p.fractalType;

        if (p.iterations !== undefined) {
            state.iterations = p.iterations;
            document.getElementById('iterations-slider').value = p.iterations;
            document.getElementById('iterations-display').textContent = p.iterations;
            document.getElementById('iterations-val').textContent = p.iterations;
        }
        if (p.branchAngle !== undefined) {
            state.branchAngle = p.branchAngle;
            document.getElementById('branch-angle-slider').value = p.branchAngle;
            document.getElementById('branch-angle-display').textContent = p.branchAngle;
            document.getElementById('branch-angle-val').textContent = p.branchAngle;
        }
        if (p.shrinkRatio !== undefined) {
            state.shrinkRatio = p.shrinkRatio;
        }
        if (p.maxIter !== undefined) {
            state.maxIter = p.maxIter;
            document.getElementById('max-iter-slider').value = p.maxIter;
            document.getElementById('max-iter-display').textContent = p.maxIter;
            document.getElementById('max-iter-val').textContent = p.maxIter;
        }
        if (p.zoom !== undefined) {
            state.zoom = p.zoom;
            document.getElementById('zoom-slider').value = p.zoom;
            document.getElementById('zoom-display').textContent = p.zoom.toFixed(3);
            document.getElementById('zoom-val').textContent = p.zoom.toFixed(3);
        }
        if (p.centerX !== undefined) { state.centerX = p.centerX; }
        if (p.centerY !== undefined) { state.centerY = p.centerY; }
        if (p.fernPoints !== undefined) { state.fernPoints = p.fernPoints; }

        showSliderGroup(p.fractalType);

        document.querySelectorAll('[data-preset]').forEach(function (btn) {
            btn.classList.toggle('active', btn.getAttribute('data-preset') === key);
        });
        state._redraw();
    }

    // Initial slider visibility
    showSliderGroup('koch');

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () { applyPreset(this.getAttribute('data-preset')); });
    });

    document.getElementById('iterations-slider').addEventListener('input', function () {
        var v = parseInt(this.value);
        state.iterations = v;
        document.getElementById('iterations-display').textContent = v;
        document.getElementById('iterations-val').textContent = v;
        document.querySelectorAll('[data-preset]').forEach(function (btn) { btn.classList.remove('active'); });
        state._redraw();
    });

    document.getElementById('branch-angle-slider').addEventListener('input', function () {
        var v = parseInt(this.value);
        state.branchAngle = v;
        document.getElementById('branch-angle-display').textContent = v;
        document.getElementById('branch-angle-val').textContent = v;
        document.querySelectorAll('[data-preset]').forEach(function (btn) { btn.classList.remove('active'); });
        state._redraw();
    });

    document.getElementById('max-iter-slider').addEventListener('input', function () {
        var v = parseInt(this.value);
        state.maxIter = v;
        document.getElementById('max-iter-display').textContent = v;
        document.getElementById('max-iter-val').textContent = v;
        document.querySelectorAll('[data-preset]').forEach(function (btn) { btn.classList.remove('active'); });
        state._redraw();
    });

    document.getElementById('zoom-slider').addEventListener('input', function () {
        var v = parseFloat(this.value);
        state.zoom = v;
        document.getElementById('zoom-display').textContent = v.toFixed(3);
        document.getElementById('zoom-val').textContent = v.toFixed(3);
        document.querySelectorAll('[data-preset]').forEach(function (btn) { btn.classList.remove('active'); });
        state._redraw();
    });

    document.getElementById('reset-btn').addEventListener('click', function () {
        applyPreset('koch');
    });
});
</script>
