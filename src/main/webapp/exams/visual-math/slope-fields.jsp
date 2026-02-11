<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Slope Fields & ODE Visualizer - Direction Fields, Euler's Method (Free)";
    String seoDescription = "Interactive slope field visualizer for ordinary differential equations. Plot direction fields, trace solution curves with Euler's method, and explore equilibrium points for common ODEs.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-math/slope-fields.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Slope Fields & ODE Visualizer - Direction Fields, Euler's Method\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Slope Fields & ODE Visualizer\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"slope field, direction field, ODE, differential equation, Euler method, initial value problem, phase portrait\">");

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
        <span class="breadcrumb-current">Slope Fields</span>
    </nav>

    <div class="viz-header">
        <h1>Slope Fields &amp; ODE Visualizer</h1>
        <p class="viz-subtitle">Visualize direction fields for ordinary differential equations. Click the canvas to place an initial condition and trace solution curves using Euler&rsquo;s method.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Differential Equation</h3>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-preset="y">dy/dx = y</button>
                        <button class="vm-chip" data-preset="x+y">dy/dx = x + y</button>
                        <button class="vm-chip" data-preset="x-y">dy/dx = x &minus; y</button>
                        <button class="vm-chip" data-preset="sinx">dy/dx = sin(x)</button>
                        <button class="vm-chip" data-preset="xy">dy/dx = x&middot;y</button>
                    </div>
                </div>

                <div class="control-group">
                    <label><input type="checkbox" id="show-solution-cb"> Show solution curve</label>
                </div>

                <div class="control-group">
                    <p class="viz-note">Click on the canvas to place an initial condition point</p>
                </div>

                <div class="viz-btn-row">
                    <button class="viz-btn viz-btn-secondary" id="reset-btn">Reset</button>
                </div>
            </div>

            <div class="viz-values">
                <h3>Properties</h3>
                <table>
                    <tr><td>ODE</td><td id="val-ode">--</td></tr>
                    <tr><td>Solution Type</td><td id="val-solution">--</td></tr>
                    <tr><td>Initial Condition</td><td id="val-ic">--</td></tr>
                    <tr><td>Slope at IC</td><td id="val-slope-ic">--</td></tr>
                    <tr><td>Equilibrium</td><td id="val-equilibrium">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Math Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Slope Fields</h3>
                <ul>
                    <li>A slope field plots <span class="formula-highlight">dy/dx = f(x, y)</span> at many grid points</li>
                    <li>Each short segment shows the slope at that point</li>
                    <li>The direction field reveals solution behavior without solving the ODE</li>
                    <li>Euler&rsquo;s method approximates: <span class="formula-highlight">y<sub>n+1</sub> = y<sub>n</sub> + f(x<sub>n</sub>, y<sub>n</sub>)&middot;&Delta;x</span></li>
                    <li>Smaller step size &Delta;x gives more accurate curves</li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Common ODEs</h3>
                <ul>
                    <li><strong>dy/dx = y</strong>: exponential growth/decay &mdash; <span class="formula-highlight">y = Ce<sup>x</sup></span></li>
                    <li><strong>dy/dx = &minus;y/x</strong>: family of circles centered at the origin</li>
                    <li><strong>dy/dx = x + y</strong>: exponential solutions shifted by linear terms</li>
                    <li><strong>dy/dx = sin(x)</strong>: antiderivative &mdash; <span class="formula-highlight">y = &minus;cos(x) + C</span></li>
                    <li><strong>Equilibrium points</strong>: where <span class="formula-highlight">dy/dx = 0</span> &mdash; solution curves flatten out</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-math/derivative.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(34,197,94,0.12);">&#8711;</div>
                <div><h4>Derivative Visualizer</h4><span>Calculus</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/integration-explorer.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(34,197,94,0.12);">&#8747;</div>
                <div><h4>Integration Explorer</h4><span>Calculus</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#8943;</div>
                <div><h4>All Visualizations</h4><span>Browse</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{"@context":"https://schema.org","@type":"LearningResource","name":"Slope Fields & ODE Visualizer","description":"Interactive slope field visualizer for ordinary differential equations. Plot direction fields, trace solution curves with Euler's method, and explore equilibrium points.","url":"https://8gwifi.org/exams/visual-math/slope-fields.jsp","educationalLevel":"High School","teaches":"Slope fields, direction fields, ordinary differential equations, Euler's method, initial value problems, equilibrium solutions","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Math Lab","item":"https://8gwifi.org/exams/visual-math/"},{"@type":"ListItem","position":4,"name":"Slope Fields"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"What is a slope field?","acceptedAnswer":{"@type":"Answer","text":"A slope field (also called a direction field) is a graphical representation of a first-order differential equation dy/dx = f(x, y). At each point on the grid, a short line segment is drawn with the slope given by f(x, y). The pattern of segments shows how solution curves behave without actually solving the equation. Solution curves follow the direction of the segments."}},{"@type":"Question","name":"How does Euler's method work?","acceptedAnswer":{"@type":"Answer","text":"Euler's method is a numerical technique for approximating solutions to differential equations. Starting from an initial point (x\u2080, y\u2080), it steps forward using the formula y\u2099\u208a\u2081 = y\u2099 + f(x\u2099, y\u2099)\u00b7\u0394x. Each step uses the slope at the current point to estimate the next point. Smaller step sizes produce more accurate approximations but require more computation."}},{"@type":"Question","name":"What are equilibrium solutions?","acceptedAnswer":{"@type":"Answer","text":"Equilibrium solutions (also called constant or steady-state solutions) occur where dy/dx = 0 for all x. At these points the slope field has horizontal segments, and the solution curve is a horizontal line y = c. For example, in dy/dx = y, the equilibrium is y = 0. Equilibrium solutions can be stable (nearby solutions approach them) or unstable (nearby solutions diverge)."}}]}
</script>

<%@ include file="viz-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-slope-fields.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('slope-fields', 'viz-canvas', {
        odeType: 'y',
        showSolution: false,
        solX: null,
        solY: null,
        density: 20
    });
    var state = VisualMath.getState();

    var presets = {
        'y':    { odeType: 'y',    showSolution: false, solX: null, solY: null },
        'x+y':  { odeType: 'x+y',  showSolution: false, solX: null, solY: null },
        'x-y':  { odeType: 'x-y',  showSolution: false, solX: null, solY: null },
        'sinx': { odeType: 'sinx', showSolution: false, solX: null, solY: null },
        'xy':   { odeType: 'xy',   showSolution: false, solX: null, solY: null }
    };

    function applyPreset(key) {
        var p = presets[key];
        state.odeType = p.odeType;
        state.showSolution = p.showSolution;
        state.solX = p.solX;
        state.solY = p.solY;

        document.getElementById('show-solution-cb').checked = false;

        document.querySelectorAll('[data-preset]').forEach(function (btn) {
            btn.classList.toggle('active', btn.getAttribute('data-preset') === key);
        });
        state._redraw();
    }

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () { applyPreset(this.getAttribute('data-preset')); });
    });

    document.getElementById('show-solution-cb').addEventListener('change', function () {
        state.showSolution = this.checked;
        if (!this.checked) {
            state.solX = null;
            state.solY = null;
        }
        state._redraw();
    });

    document.getElementById('reset-btn').addEventListener('click', function () {
        state.showSolution = false;
        state.solX = null;
        state.solY = null;
        document.getElementById('show-solution-cb').checked = false;
        applyPreset('y');
    });
});
</script>
