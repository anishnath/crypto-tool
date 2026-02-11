<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Torque & Rotation Simulator - Moment of Inertia, Angular (Free)";
    String seoDescription = "Interactive torque and rotational motion simulator. Apply forces to levers, spin disks, and observe rolling motion. See torque, moment of inertia, angular acceleration, and angular momentum.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-physics/torque-rotation.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Torque & Rotation Simulator\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Torque & Rotation Simulator\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"torque, rotation, moment of inertia, angular acceleration, angular momentum, rotational kinetic energy, lever, rolling, physics simulator\">");

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
        <span class="breadcrumb-current">Torque & Rotation</span>
    </nav>

    <div class="viz-header">
        <h1>Torque & Rotational Motion</h1>
        <p class="viz-subtitle">Apply forces to levers, spin disks, and observe rolling. Explore how torque creates angular acceleration, and see the connections between linear and rotational dynamics.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Rotation Parameters</h3>

                <div class="control-group">
                    <label>Mode</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-mode="lever">Torque on Lever</button>
                        <button class="vm-chip" data-mode="disk">Spinning Disk</button>
                        <button class="vm-chip" data-mode="rolling">Rolling</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>Force = <span id="force-display">20</span> N</label>
                    <div class="viz-slider-row">
                        <input type="range" id="force-slider" min="1" max="50" value="20" step="1">
                        <span class="viz-slider-val" id="force-val">20</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Lever Arm = <span id="lever-display">0.5</span> m</label>
                    <div class="viz-slider-row">
                        <input type="range" id="lever-slider" min="0.1" max="2.0" value="0.5" step="0.1">
                        <span class="viz-slider-val" id="lever-val">0.5</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Mass = <span id="mass-display">5</span> kg</label>
                    <div class="viz-slider-row">
                        <input type="range" id="mass-slider" min="1" max="20" value="5" step="1">
                        <span class="viz-slider-val" id="mass-val">5</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Force Angle = <span id="fangle-display">90</span>&deg;</label>
                    <div class="viz-slider-row">
                        <input type="range" id="fangle-slider" min="0" max="90" value="90" step="5">
                        <span class="viz-slider-val" id="fangle-val">90</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Show</label>
                    <div style="display:flex;flex-direction:column;gap:6px;">
                        <label class="viz-checkbox"><input type="checkbox" id="show-torque" checked> Torque vector</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-angmom"> Angular momentum</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-inertia"> Moment of inertia</label>
                    </div>
                </div>

                <div class="viz-btn-row">
                    <button class="viz-btn viz-btn-primary" id="apply-btn">Apply</button>
                    <button class="viz-btn viz-btn-secondary" id="reset-btn">Reset</button>
                </div>
            </div>

            <div class="viz-values">
                <h3>Properties</h3>
                <table>
                    <tr><td>Mode</td><td id="val-mode">Torque on Lever</td></tr>
                    <tr><td>Force</td><td id="val-force">20 N</td></tr>
                    <tr><td>Lever Arm</td><td id="val-leverarm">0.5 m</td></tr>
                    <tr><td>Torque</td><td id="val-torque">--</td></tr>
                    <tr><td>I</td><td id="val-inertia">--</td></tr>
                    <tr><td>&alpha;</td><td id="val-alpha">--</td></tr>
                    <tr><td>&omega;</td><td id="val-omega">--</td></tr>
                    <tr><td>L</td><td id="val-angmomentum">--</td></tr>
                    <tr><td>KE (rot)</td><td id="val-rotke">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Physics Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Rotational Dynamics</h3>
                <ul>
                    <li>Torque: <span class="formula-highlight">&tau; = rF sin&theta;</span></li>
                    <li>Newton's 2nd (rotation): <span class="formula-highlight">&tau; = I&alpha;</span></li>
                    <li>Angular momentum: <span class="formula-highlight">L = I&omega;</span></li>
                    <li>Rotational KE: <span class="formula-highlight">KE = &frac12;I&omega;&sup2;</span></li>
                    <li>Disk moment: <span class="formula-highlight">I = &frac12;mr&sup2;</span></li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Key Concepts</h3>
                <ul>
                    <li><strong>Torque</strong> is the rotational equivalent of force &mdash; it depends on force magnitude, lever arm, and the angle between them</li>
                    <li><strong>Moment of inertia</strong> is rotational mass &mdash; how hard it is to change an object's rotation</li>
                    <li><strong>Rolling without slipping</strong>: v = &omega;r connects translational and rotational motion</li>
                    <li><strong>Conservation of angular momentum</strong>: spinning ice skaters speed up when they pull in their arms</li>
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
            <a href="<%=request.getContextPath()%>/exams/visual-physics/orbital-mechanics.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(239,68,68,0.12);">&#127760;</div>
                <div><h4>Orbital Mechanics</h4><span>Mechanics</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/unit-circle.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#10548;</div>
                <div><h4>Unit Circle</h4><span>Visual Math</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{"@context":"https://schema.org","@type":"LearningResource","name":"Torque & Rotation Simulator","description":"Interactive torque and rotational motion simulator covering levers, spinning disks, and rolling.","url":"https://8gwifi.org/exams/visual-physics/torque-rotation.jsp","educationalLevel":"High School","teaches":"Torque, moment of inertia, angular acceleration, angular momentum, rotational kinetic energy, rolling","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Physics","item":"https://8gwifi.org/exams/visual-physics/"},{"@type":"ListItem","position":4,"name":"Torque & Rotation"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"What is torque?","acceptedAnswer":{"@type":"Answer","text":"Torque (\u03c4) is the rotational equivalent of force. It equals the force multiplied by the lever arm (distance from the pivot) and the sine of the angle between them: \u03c4 = rF sin\u03b8. Maximum torque occurs when the force is perpendicular to the lever arm (\u03b8 = 90\u00b0)."}},{"@type":"Question","name":"What is moment of inertia?","acceptedAnswer":{"@type":"Answer","text":"Moment of inertia (I) is the rotational equivalent of mass. It measures an object's resistance to changes in rotational motion. It depends on both the mass and how that mass is distributed relative to the axis of rotation. A solid disk has I = \u00bdmr\u00b2, while a thin ring has I = mr\u00b2."}},{"@type":"Question","name":"How does rolling without slipping work?","acceptedAnswer":{"@type":"Answer","text":"When an object rolls without slipping, its translational velocity v and angular velocity \u03c9 are linked by v = \u03c9r. The total kinetic energy is the sum of translational (\u00bdmv\u00b2) and rotational (\u00bdI\u03c9\u00b2) kinetic energy. This means a rolling disk goes slower than a sliding block down a ramp because energy goes into both forms of motion."}}]}
</script>

<%@ include file="vp-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-physics/js/vp-torque-rotation.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('torque-rotation', 'viz-canvas', {
        mode: 'lever', force: 20, leverArm: 0.5, mass: 5, forceAngle: 90,
        showTorque: true, showAngMomentum: false, showInertia: false
    });
    var state = VisualMath.getState();

    document.querySelectorAll('[data-mode]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            state.mode = this.getAttribute('data-mode');
            document.querySelectorAll('[data-mode]').forEach(function (b) {
                b.classList.toggle('active', b.getAttribute('data-mode') === state.mode);
            });
            state._reset(); state._redraw();
        });
    });

    document.getElementById('force-slider').addEventListener('input', function () {
        state.force = parseInt(this.value);
        document.getElementById('force-display').textContent = this.value;
        document.getElementById('force-val').textContent = this.value;
        state._redraw();
    });
    document.getElementById('lever-slider').addEventListener('input', function () {
        state.leverArm = parseFloat(this.value);
        document.getElementById('lever-display').textContent = parseFloat(this.value).toFixed(1);
        document.getElementById('lever-val').textContent = parseFloat(this.value).toFixed(1);
        state._redraw();
    });
    document.getElementById('mass-slider').addEventListener('input', function () {
        state.mass = parseInt(this.value);
        document.getElementById('mass-display').textContent = this.value;
        document.getElementById('mass-val').textContent = this.value;
        state._redraw();
    });
    document.getElementById('fangle-slider').addEventListener('input', function () {
        state.forceAngle = parseInt(this.value);
        document.getElementById('fangle-display').textContent = this.value;
        document.getElementById('fangle-val').textContent = this.value;
        state._redraw();
    });

    document.getElementById('show-torque').addEventListener('change', function () { state.showTorque = this.checked; state._redraw(); });
    document.getElementById('show-angmom').addEventListener('change', function () { state.showAngMomentum = this.checked; state._redraw(); });
    document.getElementById('show-inertia').addEventListener('change', function () { state.showInertia = this.checked; state._redraw(); });

    document.getElementById('apply-btn').addEventListener('click', function () { state._apply(); });
    document.getElementById('reset-btn').addEventListener('click', function () { state._reset(); });
});
</script>
