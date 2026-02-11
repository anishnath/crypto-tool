<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Collision Simulator - Elastic, Inelastic, Momentum (Free)";
    String seoDescription = "Interactive collision simulator. Explore elastic and inelastic collisions with adjustable masses and velocities. See momentum conservation, kinetic energy changes, and center of mass.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-physics/collisions.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Collision Simulator - Elastic, Inelastic, Momentum\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Collision Simulator\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"collision simulator, elastic collision, inelastic collision, momentum conservation, kinetic energy, center of mass, physics simulator\">");

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
        <span class="breadcrumb-current">Collisions</span>
    </nav>

    <div class="viz-header">
        <h1>Collision Simulator</h1>
        <p class="viz-subtitle">Explore elastic and inelastic collisions. Adjust masses and velocities to observe momentum conservation, energy transfer, and center-of-mass motion.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Collision Parameters</h3>

                <div class="control-group">
                    <label>Mode</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-mode="elastic">Elastic 1D</button>
                        <button class="vm-chip" data-mode="inelastic">Inelastic 1D</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip" data-preset="equal">Equal Mass</button>
                        <button class="vm-chip" data-preset="heavy-light">Heavy &rarr; Light</button>
                        <button class="vm-chip" data-preset="light-heavy">Light &rarr; Heavy</button>
                        <button class="vm-chip" data-preset="headon">Head-On</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>m&#8321; = <span id="m1-display">5</span> kg</label>
                    <div class="viz-slider-row">
                        <input type="range" id="m1-slider" min="1" max="10" value="5" step="1">
                        <span class="viz-slider-val" id="m1-val">5</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>m&#8322; = <span id="m2-display">5</span> kg</label>
                    <div class="viz-slider-row">
                        <input type="range" id="m2-slider" min="1" max="10" value="5" step="1">
                        <span class="viz-slider-val" id="m2-val">5</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>v&#8321; = <span id="v1-display">10</span> m/s</label>
                    <div class="viz-slider-row">
                        <input type="range" id="v1-slider" min="1" max="20" value="10" step="1">
                        <span class="viz-slider-val" id="v1-val">10</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>v&#8322; = <span id="v2-display">0</span> m/s</label>
                    <div class="viz-slider-row">
                        <input type="range" id="v2-slider" min="-10" max="10" value="0" step="1">
                        <span class="viz-slider-val" id="v2-val">0</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Show</label>
                    <div style="display:flex;flex-direction:column;gap:6px;">
                        <label class="viz-checkbox"><input type="checkbox" id="show-momentum" checked> Momentum vectors</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-energy" checked> Energy bars</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-com"> Center of mass</label>
                    </div>
                </div>

                <div class="viz-btn-row">
                    <button class="viz-btn viz-btn-primary" id="launch-btn">Launch</button>
                    <button class="viz-btn viz-btn-secondary" id="reset-btn">Reset</button>
                </div>
            </div>

            <div class="viz-values">
                <h3>Properties</h3>
                <table>
                    <tr><td>Mode</td><td id="val-mode">Elastic 1D</td></tr>
                    <tr><td>m&#8321;</td><td id="val-m1">5 kg</td></tr>
                    <tr><td>m&#8322;</td><td id="val-m2">5 kg</td></tr>
                    <tr><td>v&#8321; before</td><td id="val-v1before">10.0 m/s</td></tr>
                    <tr><td>v&#8322; before</td><td id="val-v2before">0.0 m/s</td></tr>
                    <tr><td>v&#8321; after</td><td id="val-v1after">--</td></tr>
                    <tr><td>v&#8322; after</td><td id="val-v2after">--</td></tr>
                    <tr><td>p total (before)</td><td id="val-pbefore">--</td></tr>
                    <tr><td>p total (after)</td><td id="val-pafter">--</td></tr>
                    <tr><td>KE (before)</td><td id="val-kebefore">--</td></tr>
                    <tr><td>KE (after)</td><td id="val-keafter">--</td></tr>
                    <tr><td>KE lost</td><td id="val-kelost">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Physics Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Collision Formulas</h3>
                <ul>
                    <li>Momentum conservation: <span class="formula-highlight">m&#8321;v&#8321; + m&#8322;v&#8322; = m&#8321;v&#8321;' + m&#8322;v&#8322;'</span></li>
                    <li>Elastic: <span class="formula-highlight">v&#8321;' = ((m&#8321;&minus;m&#8322;)v&#8321; + 2m&#8322;v&#8322;)/(m&#8321;+m&#8322;)</span></li>
                    <li>Perfectly inelastic: <span class="formula-highlight">v' = (m&#8321;v&#8321; + m&#8322;v&#8322;)/(m&#8321;+m&#8322;)</span></li>
                    <li>Kinetic energy: <span class="formula-highlight">KE = &frac12;mv&sup2;</span></li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Key Concepts</h3>
                <ul>
                    <li><strong>Momentum is always conserved</strong> in all collisions (elastic and inelastic) when no external forces act</li>
                    <li><strong>Kinetic energy is conserved</strong> only in perfectly elastic collisions</li>
                    <li><strong>Perfectly inelastic collisions</strong> lose the maximum possible kinetic energy &mdash; the objects stick together</li>
                    <li><strong>Equal-mass elastic collision</strong>: the objects exchange velocities completely</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-physics/projectile-motion.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(239,68,68,0.12);">&#127937;</div>
                <div><h4>Projectile Motion</h4><span>Mechanics</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-physics/inclined-plane.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(239,68,68,0.12);">&#9651;</div>
                <div><h4>Inclined Plane</h4><span>Mechanics</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/vectors-2d.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#10548;</div>
                <div><h4>Vectors 2D</h4><span>Visual Math</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{"@context":"https://schema.org","@type":"LearningResource","name":"Collision Simulator","description":"Interactive collision simulator. Explore elastic and inelastic collisions with adjustable masses and velocities. See momentum conservation, kinetic energy changes, and center of mass.","url":"https://8gwifi.org/exams/visual-physics/collisions.jsp","educationalLevel":"High School","teaches":"Collisions, elastic collision, inelastic collision, momentum conservation, kinetic energy, center of mass","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Physics","item":"https://8gwifi.org/exams/visual-physics/"},{"@type":"ListItem","position":4,"name":"Collisions"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"What is the difference between elastic and inelastic collisions?","acceptedAnswer":{"@type":"Answer","text":"In an elastic collision, both momentum and kinetic energy are conserved. The objects bounce off each other without any energy lost to deformation or heat. In an inelastic collision, momentum is still conserved but kinetic energy is not \u2014 some energy is converted to heat, sound, or deformation. In a perfectly inelastic collision, the objects stick together."}},{"@type":"Question","name":"Is momentum always conserved in collisions?","acceptedAnswer":{"@type":"Answer","text":"Yes, total momentum is always conserved in any collision (elastic or inelastic) as long as no external forces act on the system. This is a direct consequence of Newton's third law \u2014 the forces the objects exert on each other are equal and opposite."}},{"@type":"Question","name":"What happens when equal masses collide elastically?","acceptedAnswer":{"@type":"Answer","text":"When two objects of equal mass undergo a perfectly elastic head-on collision, they exchange velocities. If one is initially at rest, it remains stationary after the collision while the other moves away with the first object's original velocity. This is famously demonstrated by Newton's cradle."}}]}
</script>

<%@ include file="vp-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-physics/js/vp-collisions.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('collisions', 'viz-canvas', {
        mode: 'elastic', m1: 5, m2: 5, v1: 10, v2: 0,
        showMomentum: true, showEnergy: true, showCOM: false
    });
    var state = VisualMath.getState();

    var presets = {
        'equal':       { m1: 2, m2: 2, v1: 10, v2: 0 },
        'heavy-light': { m1: 8, m2: 2, v1: 10, v2: 0 },
        'light-heavy': { m1: 2, m2: 8, v1: 10, v2: 0 },
        'headon':      { m1: 5, m2: 5, v1: 10, v2: -10 }
    };

    function syncUI() {
        document.getElementById('m1-slider').value = state.m1;
        document.getElementById('m1-display').textContent = state.m1;
        document.getElementById('m1-val').textContent = state.m1;
        document.getElementById('m2-slider').value = state.m2;
        document.getElementById('m2-display').textContent = state.m2;
        document.getElementById('m2-val').textContent = state.m2;
        document.getElementById('v1-slider').value = state.v1;
        document.getElementById('v1-display').textContent = state.v1;
        document.getElementById('v1-val').textContent = state.v1;
        document.getElementById('v2-slider').value = state.v2;
        document.getElementById('v2-display').textContent = state.v2;
        document.getElementById('v2-val').textContent = state.v2;
    }

    document.querySelectorAll('[data-mode]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            state.mode = this.getAttribute('data-mode');
            document.querySelectorAll('[data-mode]').forEach(function (b) {
                b.classList.toggle('active', b.getAttribute('data-mode') === state.mode);
            });
            state._reset(); state._redraw();
        });
    });

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var key = this.getAttribute('data-preset');
            var pr = presets[key]; if (!pr) return;
            state.m1 = pr.m1; state.m2 = pr.m2; state.v1 = pr.v1; state.v2 = pr.v2;
            syncUI(); state._reset(); state._redraw();
        });
    });

    ['m1', 'm2'].forEach(function (k) {
        document.getElementById(k + '-slider').addEventListener('input', function () {
            state[k] = parseInt(this.value);
            document.getElementById(k + '-display').textContent = this.value;
            document.getElementById(k + '-val').textContent = this.value;
            state._reset(); state._redraw();
        });
    });

    ['v1', 'v2'].forEach(function (k) {
        document.getElementById(k + '-slider').addEventListener('input', function () {
            state[k] = parseInt(this.value);
            document.getElementById(k + '-display').textContent = this.value;
            document.getElementById(k + '-val').textContent = this.value;
            state._reset(); state._redraw();
        });
    });

    document.getElementById('show-momentum').addEventListener('change', function () { state.showMomentum = this.checked; state._redraw(); });
    document.getElementById('show-energy').addEventListener('change', function () { state.showEnergy = this.checked; state._redraw(); });
    document.getElementById('show-com').addEventListener('change', function () { state.showCOM = this.checked; state._redraw(); });

    document.getElementById('launch-btn').addEventListener('click', function () { state._launch(); });
    document.getElementById('reset-btn').addEventListener('click', function () { state._reset(); });
});
</script>
