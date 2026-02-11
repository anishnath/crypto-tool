<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Integration Calculator - Definite Integrals, FTC, Area Under Curve (Free)";
    String seoDescription = "Interactive integration visualizer. Compute definite integrals with shaded area, Fundamental Theorem of Calculus with antiderivative, and area between two curves. Supports x&sup2;, sin(x), cos(x), e^x, &radic;x, x&sup3;-3x.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-math/integration-explorer.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Integration Calculator - Definite Integrals, FTC, Area Under Curve\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Integration Calculator - Definite Integrals &amp; FTC\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"integral calculator, definite integral, area under curve, fundamental theorem of calculus, antiderivative, integration visualizer, area between curves, calculus\">");

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
        <span class="breadcrumb-current">Integration Explorer</span>
    </nav>

    <div class="viz-header">
        <h1>Integration Explorer</h1>
        <p class="viz-subtitle">Visualize definite integrals as shaded area, explore the Fundamental Theorem of Calculus, and compute area between two curves.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Integration</h3>

                <div class="control-group">
                    <label>Function f(x)</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-preset="x2">x&sup2;</button>
                        <button class="vm-chip" data-preset="sinx">sin(x)</button>
                        <button class="vm-chip" data-preset="cosx">cos(x)</button>
                        <button class="vm-chip" data-preset="ex">e<sup>x</sup></button>
                        <button class="vm-chip" data-preset="sqrtx">&radic;x</button>
                        <button class="vm-chip" data-preset="x3-3x">x&sup3;&minus;3x</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>Lower bound a = <span id="lower-display">0.0</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="lower-slider" min="-3" max="5" value="0" step="0.1">
                        <span class="viz-slider-val" id="lower-val">0.0</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Upper bound b = <span id="upper-display">3.0</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="upper-slider" min="-3" max="5" value="3" step="0.1">
                        <span class="viz-slider-val" id="upper-val">3.0</span>
                    </div>
                </div>

                <div class="control-group">
                    <label><input type="checkbox" id="show-ftc"> Show antiderivative F(x)</label>
                </div>

                <div class="control-group">
                    <label>Mode</label>
                    <div style="display:flex;gap:12px;">
                        <label><input type="radio" name="int-mode" value="single" checked> Area under curve</label>
                        <label><input type="radio" name="int-mode" value="between"> Area between curves</label>
                    </div>
                </div>

                <div class="control-group" id="second-func-group" style="display:none;">
                    <label>Second function g(x)</label>
                    <select id="second-func">
                        <option value="linear">x (linear)</option>
                        <option value="zero">0</option>
                        <option value="constant">1 (constant)</option>
                    </select>
                </div>

                <div class="viz-btn-row">
                    <button class="viz-btn viz-btn-primary" id="animate-btn">Animate</button>
                    <button class="viz-btn viz-btn-secondary" id="reset-btn">Reset</button>
                </div>
            </div>

            <div class="viz-values">
                <h3>Values</h3>
                <table>
                    <tr><td>Function</td><td id="val-func">--</td></tr>
                    <tr><td>Bounds</td><td id="val-bounds">--</td></tr>
                    <tr><td>Numerical &int;</td><td id="val-integral">--</td></tr>
                    <tr><td>Exact value</td><td id="val-exact">--</td></tr>
                    <tr><td>Antiderivative</td><td id="val-antideriv">--</td></tr>
                    <tr><td>FTC</td><td id="val-ftc">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Math Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Definite Integrals</h3>
                <ul>
                    <li>Defined as the limit of Riemann sums: <span class="formula-highlight">&int;<sub>a</sub><sup>b</sup> f(x)dx = lim<sub>n&rarr;&infin;</sub> &sum; f(x<sub>i</sub>)&Delta;x</span></li>
                    <li>Notation: <span class="formula-highlight">&int;<sub>a</sub><sup>b</sup> f(x)dx</span> where a is the lower limit and b is the upper limit</li>
                    <li>Geometric meaning: the <strong>signed area</strong> between f(x) and the x-axis from a to b</li>
                    <li>Area above the x-axis is positive; area below is negative</li>
                    <li>Properties: linearity, additivity over intervals, comparison</li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Fundamental Theorem of Calculus</h3>
                <ul>
                    <li><strong>FTC Part 1</strong>: <span class="formula-highlight">d/dx &int;<sub>a</sub><sup>x</sup> f(t)dt = f(x)</span> &mdash; differentiation undoes integration</li>
                    <li><strong>FTC Part 2</strong>: <span class="formula-highlight">&int;<sub>a</sub><sup>b</sup> f(x)dx = F(b) &minus; F(a)</span> where F is any antiderivative of f</li>
                    <li>Connects the two central operations of calculus: differentiation and integration</li>
                    <li><strong>Area between curves</strong>: <span class="formula-highlight">&int;<sub>a</sub><sup>b</sup> |f(x) &minus; g(x)|dx</span></li>
                    <li>When f(x) &ge; g(x) on [a, b], the absolute value can be dropped</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-math/riemann-sum.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(34,197,94,0.12);">&#8747;</div>
                <div><h4>Riemann Sum</h4><span>Calculus</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/derivative.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(34,197,94,0.12);">&#8711;</div>
                <div><h4>Derivative Visualizer</h4><span>Calculus</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#8943;</div>
                <div><h4>All Visualizations</h4><span>Browse</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{"@context":"https://schema.org","@type":"LearningResource","name":"Integration Calculator - Definite Integrals, FTC, Area Under Curve","description":"Interactive integration visualizer. Compute definite integrals with shaded area, Fundamental Theorem of Calculus with antiderivative, and area between two curves.","url":"https://8gwifi.org/exams/visual-math/integration-explorer.jsp","educationalLevel":"High School","teaches":"Definite integrals, Fundamental Theorem of Calculus, antiderivatives, area under curve, area between curves, Riemann sums","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Math Lab","item":"https://8gwifi.org/exams/visual-math/"},{"@type":"ListItem","position":4,"name":"Integration Explorer"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"What is a definite integral and what does it represent geometrically?","acceptedAnswer":{"@type":"Answer","text":"A definite integral of f(x) from a to b, written as the integral from a to b of f(x)dx, represents the signed area between the function and the x-axis over the interval [a, b]. Area above the x-axis counts as positive and area below counts as negative. It is formally defined as the limit of Riemann sums as the number of rectangles approaches infinity."}},{"@type":"Question","name":"What is the Fundamental Theorem of Calculus?","acceptedAnswer":{"@type":"Answer","text":"The Fundamental Theorem of Calculus has two parts. Part 1 states that if F(x) is defined as the integral from a to x of f(t)dt, then F'(x) = f(x), meaning differentiation undoes integration. Part 2 states that the integral from a to b of f(x)dx equals F(b) - F(a), where F is any antiderivative of f. This connects differentiation and integration as inverse operations."}},{"@type":"Question","name":"How do you find the area between two curves?","acceptedAnswer":{"@type":"Answer","text":"To find the area between two curves f(x) and g(x) from a to b, compute the integral from a to b of |f(x) - g(x)|dx. If f(x) is always greater than or equal to g(x) on the interval, you can drop the absolute value and compute the integral of (f(x) - g(x))dx directly. If the curves cross, split the integral at the intersection points."}}]}
</script>

<%@ include file="viz-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-integration.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('integration', 'viz-canvas', {
        funcType: 'x2',
        lower: 0,
        upper: 3,
        mode: 'single',
        showFTC: false,
        secondFunc: 'linear',
        animating: false,
        animBound: 0
    });
    var state = VisualMath.getState();

    var presets = {
        'x2': { funcType: 'x2' },
        'sinx': { funcType: 'sinx' },
        'cosx': { funcType: 'cosx' },
        'ex': { funcType: 'ex' },
        'sqrtx': { funcType: 'sqrtx' },
        'x3-3x': { funcType: 'x3-3x' }
    };

    function applyPreset(key) {
        var p = presets[key];
        state.funcType = p.funcType;
        document.querySelectorAll('[data-preset]').forEach(function (btn) {
            btn.classList.toggle('active', btn.getAttribute('data-preset') === key);
        });
        state._redraw();
    }

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () { applyPreset(this.getAttribute('data-preset')); });
    });

    document.getElementById('lower-slider').addEventListener('input', function () {
        var v = parseFloat(this.value);
        state.lower = v;
        document.getElementById('lower-display').textContent = v.toFixed(1);
        document.getElementById('lower-val').textContent = v.toFixed(1);
        state._redraw();
    });

    document.getElementById('upper-slider').addEventListener('input', function () {
        var v = parseFloat(this.value);
        state.upper = v;
        document.getElementById('upper-display').textContent = v.toFixed(1);
        document.getElementById('upper-val').textContent = v.toFixed(1);
        state._redraw();
    });

    document.getElementById('show-ftc').addEventListener('change', function () {
        state.showFTC = this.checked;
        state._redraw();
    });

    document.querySelectorAll('input[name="int-mode"]').forEach(function (radio) {
        radio.addEventListener('change', function () {
            state.mode = this.value;
            document.getElementById('second-func-group').style.display = (this.value === 'between') ? '' : 'none';
            state._redraw();
        });
    });

    document.getElementById('second-func').addEventListener('change', function () {
        state.secondFunc = this.value;
        state._redraw();
    });

    // Animate: sweep upper bound from lower to upper
    var animInterval = null;
    document.getElementById('animate-btn').addEventListener('click', function () {
        var btn = this;
        if (animInterval) {
            clearInterval(animInterval);
            animInterval = null;
            state.animating = false;
            btn.textContent = 'Animate';
            btn.classList.remove('viz-btn-secondary');
            btn.classList.add('viz-btn-primary');
            return;
        }
        btn.textContent = 'Pause';
        btn.classList.add('viz-btn-secondary');
        btn.classList.remove('viz-btn-primary');
        state.animating = true;
        state.animBound = state.lower;
        var targetUpper = state.upper;
        animInterval = setInterval(function () {
            state.animBound += 0.05;
            if (state.animBound >= targetUpper) {
                state.animBound = targetUpper;
                clearInterval(animInterval);
                animInterval = null;
                state.animating = false;
                btn.textContent = 'Animate';
                btn.classList.remove('viz-btn-secondary');
                btn.classList.add('viz-btn-primary');
            }
            state._redraw();
        }, 20);
    });

    document.getElementById('reset-btn').addEventListener('click', function () {
        if (animInterval) { clearInterval(animInterval); animInterval = null; }
        state.animating = false;
        state.animBound = 0;
        state.funcType = 'x2';
        state.lower = 0;
        state.upper = 3;
        state.mode = 'single';
        state.showFTC = false;
        state.secondFunc = 'linear';

        document.getElementById('lower-slider').value = 0;
        document.getElementById('lower-display').textContent = '0.0';
        document.getElementById('lower-val').textContent = '0.0';
        document.getElementById('upper-slider').value = 3;
        document.getElementById('upper-display').textContent = '3.0';
        document.getElementById('upper-val').textContent = '3.0';
        document.getElementById('show-ftc').checked = false;
        document.querySelector('input[name="int-mode"][value="single"]').checked = true;
        document.getElementById('second-func-group').style.display = 'none';
        document.getElementById('second-func').value = 'linear';

        var btn = document.getElementById('animate-btn');
        btn.textContent = 'Animate';
        btn.classList.remove('viz-btn-secondary');
        btn.classList.add('viz-btn-primary');

        applyPreset('x2');
    });
});
</script>
