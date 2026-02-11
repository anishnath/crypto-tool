<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Linear Equation Grapher - Slope Intercept y=mx+b Calculator (Free)";
    String seoDescription = "Interactive slope-intercept form grapher. Adjust slope m and y-intercept b to see the line, slope triangle, x-intercept, parallel and perpendicular lines in real time.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-math/linear-equation.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Linear Equation Grapher - y=mx+b\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Linear Equation Grapher - Slope Intercept\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"slope intercept form, y=mx+b, linear equation grapher, slope calculator, y-intercept, x-intercept, parallel lines, perpendicular lines, line graph, algebra\">");

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
        <span class="breadcrumb-current">Linear Equation</span>
    </nav>

    <div class="viz-header">
        <h1>Linear Equation Explorer</h1>
        <p class="viz-subtitle">Drag the slope and intercept sliders. See the slope triangle, intercepts, and equation update in real time.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>y = mx + b</h3>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-preset="default">m=1, b=0</button>
                        <button class="vm-chip" data-preset="horizontal">Horizontal</button>
                        <button class="vm-chip" data-preset="steep">Steep (m=3)</button>
                        <button class="vm-chip" data-preset="negative">Negative slope</button>
                        <button class="vm-chip" data-preset="fraction">m=&frac12;</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>Slope m = <span id="m-display">1.0</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="m-slider" min="-5" max="5" value="1" step="0.1">
                        <span class="viz-slider-val" id="m-val">1.0</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>y-intercept b = <span id="b-display">0.0</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="b-slider" min="-8" max="8" value="0" step="0.1">
                        <span class="viz-slider-val" id="b-val">0.0</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Show</label>
                    <div class="viz-check-group">
                        <label class="viz-check"><input type="checkbox" id="show-parallel"> Parallel line</label>
                        <label class="viz-check"><input type="checkbox" id="show-perpendicular"> Perpendicular line</label>
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
                    <tr><td>Equation</td><td id="val-equation">--</td></tr>
                    <tr><td>Slope</td><td id="val-slope">--</td></tr>
                    <tr><td>y-intercept</td><td id="val-yint">--</td></tr>
                    <tr><td>x-intercept</td><td id="val-xint">--</td></tr>
                    <tr><td>Direction</td><td id="val-direction">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Math Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Slope-Intercept Form</h3>
                <ul>
                    <li>Standard form: <span class="formula-highlight">y = mx + b</span></li>
                    <li><strong>m</strong> = slope = rise / run</li>
                    <li><strong>b</strong> = y-intercept (where line crosses y-axis)</li>
                    <li>x-intercept: set y=0, solve <span class="formula-highlight">x = -b/m</span></li>
                </ul>
                <h3 style="margin-top:var(--space-4);">Slope</h3>
                <ul>
                    <li>Positive slope: line rises left to right</li>
                    <li>Negative slope: line falls left to right</li>
                    <li>Zero slope: horizontal line</li>
                    <li>Undefined slope: vertical line (not a function)</li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Parallel & Perpendicular</h3>
                <ul>
                    <li>Parallel lines have <strong>equal slopes</strong>: m&#8321; = m&#8322;</li>
                    <li>Perpendicular lines: <span class="formula-highlight">m&#8321; &times; m&#8322; = -1</span></li>
                    <li>Perpendicular slope = <span class="formula-highlight">-1/m</span></li>
                </ul>
                <h3 style="margin-top:var(--space-4);">Try This</h3>
                <ul>
                    <li>Set <strong>m=0</strong> &mdash; horizontal line at y=b</li>
                    <li>Set <strong>b=0</strong> &mdash; line passes through origin</li>
                    <li>Toggle <strong>perpendicular</strong> &mdash; see the 90&deg; angle</li>
                    <li>Click <strong>Animate</strong> &mdash; watch the slope rotate</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-math/systems-of-equations.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(168,85,247,0.12);">&#8800;</div>
                <div><h4>Systems of Equations</h4><span>Algebra</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/quadratic.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(168,85,247,0.12);">&#8994;</div>
                <div><h4>Quadratic Explorer</h4><span>Algebra</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#8943;</div>
                <div><h4>All Visualizations</h4><span>Browse</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{"@context":"https://schema.org","@type":"LearningResource","name":"Linear Equation Explorer","description":"Interactive slope-intercept form grapher with slope triangle, intercepts, parallel and perpendicular lines.","url":"https://8gwifi.org/exams/visual-math/linear-equation.jsp","educationalLevel":"Middle School","teaches":"Linear equations, slope-intercept form, slope, y-intercept, parallel and perpendicular lines","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Math Lab","item":"https://8gwifi.org/exams/visual-math/"},{"@type":"ListItem","position":4,"name":"Linear Equation"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"What is slope-intercept form?","acceptedAnswer":{"@type":"Answer","text":"Slope-intercept form is y = mx + b, where m is the slope (rise over run) and b is the y-intercept (the y-value where the line crosses the y-axis). It is the most common way to write linear equations because you can read the slope and intercept directly."}},{"@type":"Question","name":"How do you find the x-intercept from y = mx + b?","acceptedAnswer":{"@type":"Answer","text":"Set y = 0 and solve for x: 0 = mx + b, so x = -b/m. The x-intercept is the point (-b/m, 0). If m = 0 (horizontal line), there is no x-intercept unless b = 0."}},{"@type":"Question","name":"What makes two lines perpendicular?","acceptedAnswer":{"@type":"Answer","text":"Two lines are perpendicular if their slopes multiply to -1, meaning m1 × m2 = -1, or equivalently m2 = -1/m1. For example, lines with slopes 2 and -1/2 are perpendicular and meet at a 90° angle."}}]}
</script>

<%@ include file="viz-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-linear.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('linear', 'viz-canvas', { m: 1, b: 0, showSlope: true, showParallel: false, showPerpendicular: false });
    var state = VisualMath.getState();

    var presets = {
        'default':    { m: 1, b: 0 },
        'horizontal': { m: 0, b: 3 },
        'steep':      { m: 3, b: -2 },
        'negative':   { m: -1.5, b: 4 },
        'fraction':   { m: 0.5, b: 1 }
    };

    function applyPreset(key) {
        var p = presets[key];
        state.m = p.m; state.b = p.b;
        setSlider('m', p.m); setSlider('b', p.b);
        document.querySelectorAll('[data-preset]').forEach(function (btn) {
            btn.classList.toggle('active', btn.getAttribute('data-preset') === key);
        });
        state._redraw();
    }

    function setSlider(id, val) {
        document.getElementById(id + '-slider').value = val;
        document.getElementById(id + '-display').textContent = val.toFixed(1);
        document.getElementById(id + '-val').textContent = val.toFixed(1);
    }

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () { applyPreset(this.getAttribute('data-preset')); });
    });

    function bindSlider(id, prop) {
        document.getElementById(id + '-slider').addEventListener('input', function () {
            var v = parseFloat(this.value);
            state[prop] = v;
            document.getElementById(id + '-display').textContent = v.toFixed(1);
            document.getElementById(id + '-val').textContent = v.toFixed(1);
            document.querySelectorAll('[data-preset]').forEach(function (btn) { btn.classList.remove('active'); });
            state._redraw();
        });
    }
    bindSlider('m', 'm');
    bindSlider('b', 'b');

    document.getElementById('show-parallel').addEventListener('change', function () {
        state.showParallel = this.checked;
        state._redraw();
    });
    document.getElementById('show-perpendicular').addEventListener('change', function () {
        state.showPerpendicular = this.checked;
        state._redraw();
    });

    // Animate: rotate slope from -5 to 5
    var animInterval = null;
    document.getElementById('animate-btn').addEventListener('click', function () {
        var btn = this;
        if (animInterval) { clearInterval(animInterval); animInterval = null; btn.textContent = 'Animate'; btn.classList.remove('viz-btn-secondary'); btn.classList.add('viz-btn-primary'); return; }
        btn.textContent = 'Pause'; btn.classList.add('viz-btn-secondary'); btn.classList.remove('viz-btn-primary');
        state.m = -5; setSlider('m', -5);
        animInterval = setInterval(function () {
            var cur = state.m + 0.1;
            if (cur > 5) { clearInterval(animInterval); animInterval = null; btn.textContent = 'Animate'; btn.classList.remove('viz-btn-secondary'); btn.classList.add('viz-btn-primary'); return; }
            state.m = cur; setSlider('m', cur); state._redraw();
        }, 50);
    });

    document.getElementById('reset-btn').addEventListener('click', function () {
        if (animInterval) { clearInterval(animInterval); animInterval = null; }
        document.getElementById('animate-btn').textContent = 'Animate';
        document.getElementById('animate-btn').classList.remove('viz-btn-secondary');
        document.getElementById('animate-btn').classList.add('viz-btn-primary');
        applyPreset('default');
        document.getElementById('show-parallel').checked = false;
        document.getElementById('show-perpendicular').checked = false;
        state.showParallel = false; state.showPerpendicular = false;
        state._redraw();
    });
});
</script>
