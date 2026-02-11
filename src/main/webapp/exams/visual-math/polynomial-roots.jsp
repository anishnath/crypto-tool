<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Polynomial Roots Explorer - Drag Roots & See Graph Change (Free)";
    String seoDescription = "Interactive polynomial grapher. Drag roots on the x-axis and watch the curve reshape. See factored form, expanded form, y-intercept, end behavior. Degree 2-5.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-math/polynomial-roots.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Polynomial Roots Explorer - Interactive Grapher\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Polynomial Roots Explorer\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"polynomial roots, polynomial grapher, zeros of polynomial, factor polynomial, polynomial degree, end behavior, leading coefficient, polynomial graph, algebra 2\">");

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
        <span class="breadcrumb-current">Polynomial Roots</span>
    </nav>

    <div class="viz-header">
        <h1>Polynomial Roots Explorer</h1>
        <p class="viz-subtitle">Drag the root points on the x-axis and watch the polynomial reshape. Change the leading coefficient to flip or stretch.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Polynomial</h3>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-preset="cubic">Cubic</button>
                        <button class="vm-chip" data-preset="quadratic">Quadratic</button>
                        <button class="vm-chip" data-preset="quartic">Quartic</button>
                        <button class="vm-chip" data-preset="quintic">Quintic</button>
                        <button class="vm-chip" data-preset="double">Double Root</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>Leading Coefficient a = <span id="a-display">1.0</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="a-slider" min="-3" max="3" value="1" step="0.1">
                        <span class="viz-slider-val" id="a-val">1.0</span>
                    </div>
                </div>

                <div class="viz-btn-row">
                    <button class="viz-btn viz-btn-primary" id="animate-btn">Animate</button>
                    <button class="viz-btn viz-btn-secondary" id="reset-btn">Reset</button>
                </div>

                <p style="font-size:var(--text-sm);color:var(--text-secondary);margin-top:8px;">Drag the colored dots on the x-axis to move roots.</p>
            </div>

            <div class="viz-values">
                <h3>Properties</h3>
                <table>
                    <tr><td>Degree</td><td id="val-degree">--</td></tr>
                    <tr><td>Roots</td><td id="val-roots">--</td></tr>
                    <tr><td>Factored</td><td id="val-factored">--</td></tr>
                    <tr><td>y-intercept</td><td id="val-yint">--</td></tr>
                    <tr><td>Leading a</td><td id="val-leading">--</td></tr>
                    <tr><td>End behavior</td><td id="val-end">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Math Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Polynomial Basics</h3>
                <ul>
                    <li>Factored form: <span class="formula-highlight">f(x) = a(x-r&#8321;)(x-r&#8322;)...(x-r&#8345;)</span></li>
                    <li>Each <strong>r</strong> is a root (zero) where the graph crosses the x-axis</li>
                    <li><strong>Degree n</strong> = number of roots (counting multiplicity)</li>
                    <li><strong>y-intercept</strong> = f(0) = a&middot;(-r&#8321;)(-r&#8322;)...(-r&#8345;)</li>
                </ul>
                <h3 style="margin-top:var(--space-4);">Leading Coefficient</h3>
                <ul>
                    <li><strong>a &gt; 0</strong>: right side goes up</li>
                    <li><strong>a &lt; 0</strong>: graph flips vertically</li>
                    <li><strong>|a| &gt; 1</strong>: graph stretches vertically</li>
                    <li><strong>|a| &lt; 1</strong>: graph compresses vertically</li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>End Behavior</h3>
                <ul>
                    <li><strong>Even degree, a &gt; 0</strong>: both ends go up &uarr;&uarr;</li>
                    <li><strong>Even degree, a &lt; 0</strong>: both ends go down &darr;&darr;</li>
                    <li><strong>Odd degree, a &gt; 0</strong>: left down, right up &darr;&uarr;</li>
                    <li><strong>Odd degree, a &lt; 0</strong>: left up, right down &uarr;&darr;</li>
                </ul>
                <h3 style="margin-top:var(--space-4);">Try This</h3>
                <ul>
                    <li>Drag two roots to the <strong>same spot</strong> &mdash; double root (touches but doesn't cross)</li>
                    <li>Make <strong>a negative</strong> &mdash; entire graph flips</li>
                    <li>Try <strong>Quintic</strong> &mdash; see 4 turning points</li>
                    <li>Click <strong>Animate</strong> &mdash; watch leading coefficient sweep</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-math/quadratic.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(168,85,247,0.12);">&#8994;</div>
                <div><h4>Quadratic Explorer</h4><span>Algebra</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/conic-sections.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(168,85,247,0.12);">&#9676;</div>
                <div><h4>Conic Sections</h4><span>Algebra</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#8943;</div>
                <div><h4>All Visualizations</h4><span>Browse</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{"@context":"https://schema.org","@type":"LearningResource","name":"Polynomial Roots Explorer","description":"Interactive polynomial grapher where you drag roots to reshape the curve. Shows factored form, degree, end behavior, and y-intercept.","url":"https://8gwifi.org/exams/visual-math/polynomial-roots.jsp","educationalLevel":"High School","teaches":"Polynomial roots, factoring, degree, end behavior, leading coefficient","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Math Lab","item":"https://8gwifi.org/exams/visual-math/"},{"@type":"ListItem","position":4,"name":"Polynomial Roots"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"What are the roots of a polynomial?","acceptedAnswer":{"@type":"Answer","text":"Roots (also called zeros) are the x-values where the polynomial equals zero — where the graph crosses or touches the x-axis. A polynomial of degree n has at most n real roots. In factored form f(x) = a(x-r1)(x-r2)..., each ri is a root."}},{"@type":"Question","name":"What is end behavior of a polynomial?","acceptedAnswer":{"@type":"Answer","text":"End behavior describes what happens to f(x) as x approaches positive or negative infinity. It depends on the degree and leading coefficient: even degree with positive leading coefficient means both ends go up; odd degree with positive leading coefficient means left goes down, right goes up."}},{"@type":"Question","name":"What is a double root?","acceptedAnswer":{"@type":"Answer","text":"A double root (multiplicity 2) occurs when a factor appears twice, like (x-3)². At a double root, the graph touches the x-axis but doesn't cross it — it bounces off. Triple roots cause an inflection point at the x-axis."}}]}
</script>

<%@ include file="viz-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-polynomial.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('polynomial', 'viz-canvas', { leading: 1 });
    var state = VisualMath.getState();

    var presets = {
        'cubic':     [-2, 0, 3],
        'quadratic': [-3, 2],
        'quartic':   [-3, -1, 1, 3],
        'quintic':   [-4, -2, 0, 2, 4],
        'double':    [-2, 2, 2]
    };

    function applyPreset(key) {
        state._setRoots(presets[key]);
        document.querySelectorAll('[data-preset]').forEach(function (btn) {
            btn.classList.toggle('active', btn.getAttribute('data-preset') === key);
        });
    }

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () { applyPreset(this.getAttribute('data-preset')); });
    });

    document.getElementById('a-slider').addEventListener('input', function () {
        var v = parseFloat(this.value);
        state.leading = v;
        document.getElementById('a-display').textContent = v.toFixed(1);
        document.getElementById('a-val').textContent = v.toFixed(1);
        state._redraw();
    });

    // Animate: sweep leading coefficient
    var animInterval = null;
    document.getElementById('animate-btn').addEventListener('click', function () {
        var btn = this;
        if (animInterval) { clearInterval(animInterval); animInterval = null; btn.textContent = 'Animate'; btn.classList.remove('viz-btn-secondary'); btn.classList.add('viz-btn-primary'); return; }
        btn.textContent = 'Pause'; btn.classList.add('viz-btn-secondary'); btn.classList.remove('viz-btn-primary');
        state.leading = -3;
        document.getElementById('a-slider').value = -3;
        document.getElementById('a-display').textContent = '-3.0';
        document.getElementById('a-val').textContent = '-3.0';
        animInterval = setInterval(function () {
            var cur = state.leading + 0.05;
            if (Math.abs(cur) < 0.05) cur += 0.05; // skip 0
            if (cur > 3) { clearInterval(animInterval); animInterval = null; btn.textContent = 'Animate'; btn.classList.remove('viz-btn-secondary'); btn.classList.add('viz-btn-primary'); return; }
            state.leading = cur;
            document.getElementById('a-slider').value = cur;
            document.getElementById('a-display').textContent = cur.toFixed(1);
            document.getElementById('a-val').textContent = cur.toFixed(1);
            state._redraw();
        }, 50);
    });

    document.getElementById('reset-btn').addEventListener('click', function () {
        if (animInterval) { clearInterval(animInterval); animInterval = null; }
        var btn = document.getElementById('animate-btn');
        btn.textContent = 'Animate'; btn.classList.remove('viz-btn-secondary'); btn.classList.add('viz-btn-primary');
        state.leading = 1;
        document.getElementById('a-slider').value = 1;
        document.getElementById('a-display').textContent = '1.0';
        document.getElementById('a-val').textContent = '1.0';
        applyPreset('cubic');
    });
});
</script>
