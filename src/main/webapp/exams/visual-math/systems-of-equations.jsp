<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Systems of Equations Solver - Graph Two Lines & Find Intersection (Free)";
    String seoDescription = "Graph two linear equations and find their intersection visually. Identify one solution, no solution (parallel), and infinite solutions. Free algebra calculator.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-math/systems-of-equations.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Systems of Equations Solver - Two Lines Intersection\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Systems of Equations Solver\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"systems of equations solver, two equations two unknowns, intersection of lines, simultaneous equations, parallel lines no solution, consistent system, algebra graphing\">");

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
        <span class="breadcrumb-current">Systems of Equations</span>
    </nav>

    <div class="viz-header">
        <h1>Systems of Equations Solver</h1>
        <p class="viz-subtitle">Adjust slopes and intercepts for two lines. Watch the intersection move, disappear (parallel), or merge (same line).</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Two Lines</h3>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-preset="intersect">Intersecting</button>
                        <button class="vm-chip" data-preset="perpendicular">Perpendicular</button>
                        <button class="vm-chip" data-preset="parallel">Parallel</button>
                        <button class="vm-chip" data-preset="same">Same Line</button>
                    </div>
                </div>

                <div class="control-group" style="border-left:3px solid var(--accent-primary,#6366f1);padding-left:10px;">
                    <label>Line 1: m&#8321; = <span id="m1-display">1.0</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="m1-slider" min="-5" max="5" value="1" step="0.1">
                        <span class="viz-slider-val" id="m1-val">1.0</span>
                    </div>
                    <label>b&#8321; = <span id="b1-display">2.0</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="b1-slider" min="-8" max="8" value="2" step="0.1">
                        <span class="viz-slider-val" id="b1-val">2.0</span>
                    </div>
                </div>

                <div class="control-group" style="border-left:3px solid #22c55e;padding-left:10px;">
                    <label>Line 2: m&#8322; = <span id="m2-display">-0.5</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="m2-slider" min="-5" max="5" value="-0.5" step="0.1">
                        <span class="viz-slider-val" id="m2-val">-0.5</span>
                    </div>
                    <label>b&#8322; = <span id="b2-display">-1.0</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="b2-slider" min="-8" max="8" value="-1" step="0.1">
                        <span class="viz-slider-val" id="b2-val">-1.0</span>
                    </div>
                </div>

                <div class="viz-btn-row">
                    <button class="viz-btn viz-btn-primary" id="animate-btn">Animate</button>
                    <button class="viz-btn viz-btn-secondary" id="reset-btn">Reset</button>
                </div>
            </div>

            <div class="viz-values">
                <h3>Solution</h3>
                <table>
                    <tr><td>Equation 1</td><td id="val-eq1">--</td></tr>
                    <tr><td>Equation 2</td><td id="val-eq2">--</td></tr>
                    <tr><td>Case</td><td id="val-case">--</td></tr>
                    <tr><td>Solution</td><td id="val-solution">--</td></tr>
                    <tr><td>Relationship</td><td id="val-relationship">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Math Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Solving Systems</h3>
                <ul>
                    <li>A system of two linear equations: y = m&#8321;x + b&#8321; and y = m&#8322;x + b&#8322;</li>
                    <li>To find intersection: set equal, solve <span class="formula-highlight">m&#8321;x + b&#8321; = m&#8322;x + b&#8322;</span></li>
                    <li>Solution: <span class="formula-highlight">x = (b&#8322; - b&#8321;) / (m&#8321; - m&#8322;)</span></li>
                    <li>Then find y by plugging x back into either equation</li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Three Cases</h3>
                <ul>
                    <li><strong>One solution</strong>: Lines intersect at exactly one point (different slopes)</li>
                    <li><strong>No solution</strong>: Lines are parallel &mdash; same slope, different intercepts</li>
                    <li><strong>Infinite solutions</strong>: Lines are the same &mdash; same slope AND same intercept</li>
                </ul>
                <h3 style="margin-top:var(--space-4);">Try This</h3>
                <ul>
                    <li>Make slopes equal &mdash; watch intersection vanish (parallel)</li>
                    <li>Then match intercepts &mdash; lines merge (infinite solutions)</li>
                    <li>Set <strong>m&#8321; &times; m&#8322; = -1</strong> for perpendicular lines</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-math/linear-equation.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(168,85,247,0.12);">/</div>
                <div><h4>Linear Equation</h4><span>Algebra</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/matrix-transform.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(59,130,246,0.12);">&#9638;</div>
                <div><h4>Matrix Transforms</h4><span>Linear Algebra</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#8943;</div>
                <div><h4>All Visualizations</h4><span>Browse</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{"@context":"https://schema.org","@type":"LearningResource","name":"Systems of Equations Solver","description":"Graph two linear equations and find their intersection point. Shows one solution, no solution, and infinite solutions cases.","url":"https://8gwifi.org/exams/visual-math/systems-of-equations.jsp","educationalLevel":"High School","teaches":"Systems of linear equations, intersection, parallel lines, consistent and inconsistent systems","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Math Lab","item":"https://8gwifi.org/exams/visual-math/"},{"@type":"ListItem","position":4,"name":"Systems of Equations"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"How do you solve a system of two linear equations?","acceptedAnswer":{"@type":"Answer","text":"Set the two equations equal: m1*x + b1 = m2*x + b2, then solve for x = (b2 - b1) / (m1 - m2). Substitute x back into either equation to find y. This works when the slopes are different (one unique solution)."}},{"@type":"Question","name":"When does a system of equations have no solution?","acceptedAnswer":{"@type":"Answer","text":"A system has no solution when the two lines are parallel — they have the same slope but different y-intercepts. Graphically, the lines never cross. Algebraically, you get a contradiction like 0 = 5."}},{"@type":"Question","name":"When does a system have infinite solutions?","acceptedAnswer":{"@type":"Answer","text":"A system has infinitely many solutions when both equations describe the same line — same slope AND same y-intercept. Every point on the line satisfies both equations."}}]}
</script>

<%@ include file="viz-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-systems.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('systems', 'viz-canvas', { m1: 1, b1: 2, m2: -0.5, b2: -1 });
    var state = VisualMath.getState();

    var presets = {
        'intersect':     { m1: 1,  b1: 2,  m2: -0.5, b2: -1 },
        'perpendicular': { m1: 2,  b1: -1, m2: -0.5, b2: 3 },
        'parallel':      { m1: 1.5, b1: 3,  m2: 1.5,  b2: -2 },
        'same':          { m1: 1,  b1: 2,  m2: 1,    b2: 2 }
    };

    function applyPreset(key) {
        var p = presets[key];
        state.m1 = p.m1; state.b1 = p.b1; state.m2 = p.m2; state.b2 = p.b2;
        setSlider('m1', p.m1); setSlider('b1', p.b1);
        setSlider('m2', p.m2); setSlider('b2', p.b2);
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
    bindSlider('m1', 'm1'); bindSlider('b1', 'b1');
    bindSlider('m2', 'm2'); bindSlider('b2', 'b2');

    // Animate: sweep m2 from -5 to 5
    var animInterval = null;
    document.getElementById('animate-btn').addEventListener('click', function () {
        var btn = this;
        if (animInterval) { clearInterval(animInterval); animInterval = null; btn.textContent = 'Animate'; btn.classList.remove('viz-btn-secondary'); btn.classList.add('viz-btn-primary'); return; }
        btn.textContent = 'Pause'; btn.classList.add('viz-btn-secondary'); btn.classList.remove('viz-btn-primary');
        state.m2 = -5; setSlider('m2', -5);
        animInterval = setInterval(function () {
            var cur = state.m2 + 0.1;
            if (cur > 5) { clearInterval(animInterval); animInterval = null; btn.textContent = 'Animate'; btn.classList.remove('viz-btn-secondary'); btn.classList.add('viz-btn-primary'); return; }
            state.m2 = cur; setSlider('m2', cur); state._redraw();
        }, 50);
    });

    document.getElementById('reset-btn').addEventListener('click', function () {
        if (animInterval) { clearInterval(animInterval); animInterval = null; }
        var btn = document.getElementById('animate-btn');
        btn.textContent = 'Animate'; btn.classList.remove('viz-btn-secondary'); btn.classList.add('viz-btn-primary');
        applyPreset('intersect');
    });
});
</script>
