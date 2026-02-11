<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Pulley System Simulator - Mechanical Advantage 2^n, Atwood (Free)";
    String seoDescription = "Interactive pulley system simulator. Explore fixed, movable, and block-and-tackle pulleys with 2^n mechanical advantage. Simulate Atwood machines with acceleration and tension.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-physics/pulley-systems.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Pulley System Simulator - Mechanical Advantage, Atwood Machine\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Pulley System Simulator\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"pulley system, mechanical advantage, block and tackle, Atwood machine, 2^n pulley, fixed pulley, movable pulley, tension, effort force, physics simulator\">");

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
        <a href="<%=request.getContextPath()%>/exams/visual-physics/">Visual Physics</a>
        <span class="breadcrumb-separator">/</span>
        <span class="breadcrumb-current">Pulley Systems</span>
    </nav>

    <div class="viz-header">
        <h1>Pulley Systems</h1>
        <p class="viz-subtitle">Explore how pulleys multiply force. From a simple fixed pulley to block-and-tackle systems with 2<sup>n</sup> mechanical advantage, and the classic Atwood machine for studying acceleration.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Pulley Parameters</h3>

                <div class="control-group">
                    <label>Mode</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-mode="fixed">Fixed</button>
                        <button class="vm-chip" data-mode="movable">Movable</button>
                        <button class="vm-chip" data-mode="block-tackle">Block & Tackle</button>
                        <button class="vm-chip" data-mode="atwood">Atwood</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip" data-preset="simple">Simple Lift</button>
                        <button class="vm-chip" data-preset="double">MA = 4</button>
                        <button class="vm-chip" data-preset="heavy">MA = 8</button>
                        <button class="vm-chip" data-preset="atwood-equal">Atwood Equal</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>Mass (Load) = <span id="mass-display">10</span> kg</label>
                    <div class="viz-slider-row">
                        <input type="range" id="mass-slider" min="1" max="50" value="10" step="1">
                        <span class="viz-slider-val" id="mass-val">10</span>
                    </div>
                </div>

                <div class="control-group" id="mass2-group" style="display:none;">
                    <label>Mass 2 = <span id="mass2-display">5</span> kg</label>
                    <div class="viz-slider-row">
                        <input type="range" id="mass2-slider" min="1" max="50" value="5" step="1">
                        <span class="viz-slider-val" id="mass2-val">5</span>
                    </div>
                </div>

                <div class="control-group" id="npulleys-group" style="display:none;">
                    <label>Stages (n) = <span id="np-display">2</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="np-slider" min="1" max="4" value="2" step="1">
                        <span class="viz-slider-val" id="np-val">2</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Efficiency = <span id="eff-display">100</span>%</label>
                    <div class="viz-slider-row">
                        <input type="range" id="eff-slider" min="50" max="100" value="100" step="5">
                        <span class="viz-slider-val" id="eff-val">100</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Show</label>
                    <div style="display:flex;flex-direction:column;gap:6px;">
                        <label class="viz-checkbox"><input type="checkbox" id="show-forces" checked> Force arrows</label>
                    </div>
                </div>

                <div class="viz-btn-row">
                    <button class="viz-btn viz-btn-primary" id="run-btn">Run</button>
                    <button class="viz-btn viz-btn-secondary" id="reset-btn">Reset</button>
                </div>
            </div>

            <div class="viz-values">
                <h3>Properties</h3>
                <table>
                    <tr><td>Mode</td><td id="val-mode">Fixed Pulley</td></tr>
                    <tr><td>Mass (Load)</td><td id="val-mass">10 kg</td></tr>
                    <tr><td>Weight</td><td id="val-load">98.1 N</td></tr>
                    <tr><td>MA</td><td id="val-ma">1</td></tr>
                    <tr><td>Effort</td><td id="val-effort">--</td></tr>
                    <tr><td>Stages</td><td id="val-numstages">0</td></tr>
                    <tr><td>Efficiency</td><td id="val-efficiency">100%</td></tr>
                    <tr><td>Mass 2</td><td id="val-mass2">--</td></tr>
                    <tr><td>Acceleration</td><td id="val-accel">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Physics Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Pulley Formulas</h3>
                <ul>
                    <li>Mechanical advantage: <span class="formula-highlight">MA = Load / Effort</span></li>
                    <li>Block & tackle: <span class="formula-highlight">MA = 2<sup>n</sup></span> (n stages)</li>
                    <li>Effort with efficiency: <span class="formula-highlight">F = W / (MA &times; &eta;)</span></li>
                    <li>Atwood acceleration: <span class="formula-highlight">a = g(m&sub1; &minus; m&sub2;) / (m&sub1; + m&sub2;)</span></li>
                    <li>Atwood tension: <span class="formula-highlight">T = 2m&sub1;m&sub2;g / (m&sub1; + m&sub2;)</span></li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Key Concepts</h3>
                <ul>
                    <li><strong>Fixed pulley</strong>: changes force direction but MA = 1; you pull with the same force</li>
                    <li><strong>Movable pulley</strong>: MA = 2; you pull with half the force but twice the rope length</li>
                    <li><strong>Block & tackle</strong>: each stage doubles MA giving 2<sup>n</sup>; the trade-off is pulling more rope</li>
                    <li><strong>Atwood machine</strong>: two masses on a string; the difference in weight drives acceleration while the sum determines inertia</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-physics/inclined-plane.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(239,68,68,0.12);">&#9651;</div>
                <div><h4>Inclined Plane</h4><span>Mechanics</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-physics/torque-rotation.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(239,68,68,0.12);">&#9854;</div>
                <div><h4>Torque & Rotation</h4><span>Mechanics</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-physics/collisions.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(239,68,68,0.12);">&#9673;</div>
                <div><h4>Collisions</h4><span>Mechanics</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{"@context":"https://schema.org","@type":"LearningResource","name":"Pulley System Simulator","description":"Interactive pulley system simulator covering fixed, movable, and block-and-tackle pulleys with 2^n mechanical advantage, and Atwood machines.","url":"https://8gwifi.org/exams/visual-physics/pulley-systems.jsp","educationalLevel":"High School","teaches":"Pulley systems, mechanical advantage, block and tackle, Atwood machine, tension, effort force, work-energy theorem","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Physics","item":"https://8gwifi.org/exams/visual-physics/"},{"@type":"ListItem","position":4,"name":"Pulley Systems"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"What is mechanical advantage in a pulley system?","acceptedAnswer":{"@type":"Answer","text":"Mechanical advantage (MA) is the ratio of the load lifted to the effort force applied. A fixed pulley has MA = 1 (it only changes direction). A movable pulley has MA = 2. A block-and-tackle system with n stages has MA = 2^n. The trade-off is that you must pull more rope: distance pulled = MA \u00d7 distance load moves."}},{"@type":"Question","name":"Why does a block-and-tackle system have MA = 2^n?","acceptedAnswer":{"@type":"Answer","text":"Each movable pulley in the system doubles the mechanical advantage. With 1 stage (1 fixed + 1 movable pulley), MA = 2. With 2 stages, MA = 4. With 3 stages, MA = 8. This is because each movable pulley splits the tension between two rope segments supporting it, halving the effort needed at each stage."}},{"@type":"Question","name":"How does an Atwood machine work?","acceptedAnswer":{"@type":"Answer","text":"An Atwood machine consists of two masses connected by a string over a pulley. The heavier mass accelerates downward while the lighter one accelerates upward. The acceleration is a = g(m\u2081 - m\u2082)/(m\u2081 + m\u2082), and the tension is T = 2m\u2081m\u2082g/(m\u2081 + m\u2082). When the masses are nearly equal, the acceleration is very small, making it useful for studying gravity in slow motion."}}]}
</script>

<%@ include file="vp-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-physics/js/vp-pulley-systems.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('pulley-systems', 'viz-canvas', {
        mode: 'fixed', mass: 10, mass2: 5, numPulleys: 2, efficiency: 100,
        showForces: true
    });
    var state = VisualMath.getState();

    var presets = {
        'simple':       { mode: 'fixed', mass: 10, mass2: 5, np: 1, eff: 100 },
        'double':       { mode: 'block-tackle', mass: 20, mass2: 5, np: 2, eff: 100 },
        'heavy':        { mode: 'block-tackle', mass: 40, mass2: 5, np: 3, eff: 90 },
        'atwood-equal': { mode: 'atwood', mass: 10, mass2: 9, np: 1, eff: 100 }
    };

    function syncUI() {
        document.getElementById('mass-slider').value = state.mass;
        document.getElementById('mass-display').textContent = state.mass;
        document.getElementById('mass-val').textContent = state.mass;
        document.getElementById('mass2-slider').value = state.mass2;
        document.getElementById('mass2-display').textContent = state.mass2;
        document.getElementById('mass2-val').textContent = state.mass2;
        document.getElementById('np-slider').value = state.numPulleys;
        document.getElementById('np-display').textContent = state.numPulleys;
        document.getElementById('np-val').textContent = state.numPulleys;
        document.getElementById('eff-slider').value = state.efficiency;
        document.getElementById('eff-display').textContent = state.efficiency;
        document.getElementById('eff-val').textContent = state.efficiency;
        document.getElementById('mass2-group').style.display = state.mode === 'atwood' ? '' : 'none';
        document.getElementById('npulleys-group').style.display = state.mode === 'block-tackle' ? '' : 'none';
        document.querySelectorAll('[data-mode]').forEach(function (b) {
            b.classList.toggle('active', b.getAttribute('data-mode') === state.mode);
        });
    }

    document.querySelectorAll('[data-mode]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            state.mode = this.getAttribute('data-mode');
            syncUI(); state._reset(); state._redraw();
        });
    });

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var key = this.getAttribute('data-preset');
            var pr = presets[key]; if (!pr) return;
            state.mode = pr.mode; state.mass = pr.mass; state.mass2 = pr.mass2;
            state.numPulleys = pr.np; state.efficiency = pr.eff;
            syncUI(); state._reset(); state._redraw();
        });
    });

    document.getElementById('mass-slider').addEventListener('input', function () {
        state.mass = parseInt(this.value);
        document.getElementById('mass-display').textContent = this.value;
        document.getElementById('mass-val').textContent = this.value;
        state._redraw();
    });
    document.getElementById('mass2-slider').addEventListener('input', function () {
        state.mass2 = parseInt(this.value);
        document.getElementById('mass2-display').textContent = this.value;
        document.getElementById('mass2-val').textContent = this.value;
        state._redraw();
    });
    document.getElementById('np-slider').addEventListener('input', function () {
        state.numPulleys = parseInt(this.value);
        document.getElementById('np-display').textContent = this.value;
        document.getElementById('np-val').textContent = this.value;
        state._reset(); state._redraw();
    });
    document.getElementById('eff-slider').addEventListener('input', function () {
        state.efficiency = parseInt(this.value);
        document.getElementById('eff-display').textContent = this.value;
        document.getElementById('eff-val').textContent = this.value;
        state._redraw();
    });

    document.getElementById('show-forces').addEventListener('change', function () { state.showForces = this.checked; state._redraw(); });

    document.getElementById('run-btn').addEventListener('click', function () { state._run(); });
    document.getElementById('reset-btn').addEventListener('click', function () { state._reset(); });

    syncUI();
});
</script>
