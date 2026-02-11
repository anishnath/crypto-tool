<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Inclined Plane Simulator - Forces, Friction, FBD (Free)";
    String seoDescription = "Interactive inclined plane simulator. Adjust angle, mass, and friction to see free body diagrams, force components, normal force, and acceleration on a ramp.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-physics/inclined-plane.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Inclined Plane Simulator - Forces, Friction, FBD\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Inclined Plane Simulator\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"inclined plane, free body diagram, FBD, normal force, friction, mgsin, mgcos, acceleration, ramp physics, forces simulator\">");

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
        <span class="breadcrumb-current">Inclined Plane</span>
    </nav>

    <div class="viz-header">
        <h1>Inclined Plane & Forces Simulator</h1>
        <p class="viz-subtitle">Explore forces on an inclined plane. See the free body diagram, force components, friction, and whether the block will slide or remain in equilibrium.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Ramp Parameters</h3>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-preset="frictionless">Frictionless 45&deg;</button>
                        <button class="vm-chip" data-preset="equilibrium">Static Equilibrium</button>
                        <button class="vm-chip" data-preset="steep">Steep + Friction</button>
                        <button class="vm-chip" data-preset="just-sliding">Just Sliding</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>Angle = <span id="angle-display">30</span>&deg;</label>
                    <div class="viz-slider-row">
                        <input type="range" id="angle-slider" min="5" max="80" value="30" step="1">
                        <span class="viz-slider-val" id="angle-val">30</span>
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
                    <label>&mu; = <span id="mu-display">0.20</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="mu-slider" min="0" max="1" value="0.2" step="0.05">
                        <span class="viz-slider-val" id="mu-val">0.20</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Show</label>
                    <div style="display:flex;flex-direction:column;gap:6px;">
                        <label class="viz-checkbox"><input type="checkbox" id="show-fbd" checked> Free Body Diagram</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-components"> Force components</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-accel"> Acceleration</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-animate"> Animate slide</label>
                    </div>
                </div>

                <div class="viz-btn-row">
                    <button class="viz-btn viz-btn-primary" id="release-btn">Release</button>
                    <button class="viz-btn viz-btn-secondary" id="reset-btn">Reset</button>
                </div>
            </div>

            <div class="viz-values">
                <h3>Properties</h3>
                <table>
                    <tr><td>Angle</td><td id="val-angle">30&deg;</td></tr>
                    <tr><td>Mass</td><td id="val-mass">5 kg</td></tr>
                    <tr><td>Weight</td><td id="val-weight">--</td></tr>
                    <tr><td>Normal Force</td><td id="val-normal">--</td></tr>
                    <tr><td>mg sin&theta;</td><td id="val-mgsin">--</td></tr>
                    <tr><td>mg cos&theta;</td><td id="val-mgcos">--</td></tr>
                    <tr><td>Friction</td><td id="val-friction">--</td></tr>
                    <tr><td>Net Force</td><td id="val-netforce">--</td></tr>
                    <tr><td>Acceleration</td><td id="val-accel">--</td></tr>
                    <tr><td>Will it slide?</td><td id="val-slide">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Physics Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Force Equations</h3>
                <ul>
                    <li>Component along ramp: <span class="formula-highlight">F&#8214; = mg sin&theta;</span></li>
                    <li>Normal force: <span class="formula-highlight">N = mg cos&theta;</span></li>
                    <li>Friction force: <span class="formula-highlight">f = &mu;N = &mu;mg cos&theta;</span></li>
                    <li>Net acceleration: <span class="formula-highlight">a = g(sin&theta; &minus; &mu;cos&theta;)</span></li>
                    <li>Slides when: <span class="formula-highlight">tan&theta; &gt; &mu;</span></li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Key Concepts</h3>
                <ul>
                    <li><strong>Resolving forces</strong>: weight is decomposed into components parallel and perpendicular to the surface</li>
                    <li><strong>Normal force</strong> is the surface's push-back, always perpendicular to the ramp</li>
                    <li><strong>Static friction</strong> prevents motion up to a maximum value &mu;N; beyond that the block accelerates</li>
                    <li><strong>The critical angle</strong> where tan&theta; = &mu; is the steepest angle for static equilibrium</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-physics/collisions.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(239,68,68,0.12);">&#9898;</div>
                <div><h4>Collisions</h4><span>Mechanics</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-physics/projectile-motion.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(239,68,68,0.12);">&#127937;</div>
                <div><h4>Projectile Motion</h4><span>Mechanics</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/trig-graphs.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#10548;</div>
                <div><h4>Trig Graphs</h4><span>Visual Math</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{"@context":"https://schema.org","@type":"LearningResource","name":"Inclined Plane Simulator","description":"Interactive inclined plane simulator. Adjust angle, mass, and friction to see free body diagrams, force components, normal force, and acceleration on a ramp.","url":"https://8gwifi.org/exams/visual-physics/inclined-plane.jsp","educationalLevel":"High School","teaches":"Inclined plane, free body diagram, normal force, friction, force components, Newton's second law","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Physics","item":"https://8gwifi.org/exams/visual-physics/"},{"@type":"ListItem","position":4,"name":"Inclined Plane"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"How do you find the acceleration on an inclined plane?","acceptedAnswer":{"@type":"Answer","text":"The acceleration of an object on an inclined plane is a = g(sin\u03b8 \u2212 \u03bccos\u03b8), where \u03b8 is the angle of inclination, g is gravitational acceleration (9.8 m/s\u00b2), and \u03bc is the coefficient of friction. If this value is negative, the object does not slide."}},{"@type":"Question","name":"When does a block start sliding on an inclined plane?","acceptedAnswer":{"@type":"Answer","text":"A block begins to slide when the component of gravity along the ramp (mg sin\u03b8) exceeds the maximum static friction force (\u03bcmg cos\u03b8). This happens when tan\u03b8 > \u03bc, i.e. when the angle exceeds arctan(\u03bc)."}},{"@type":"Question","name":"What is a free body diagram?","acceptedAnswer":{"@type":"Answer","text":"A free body diagram (FBD) is a simplified drawing showing all forces acting on an object. For an object on an inclined plane, the FBD typically shows weight (mg downward), normal force (perpendicular to surface), and friction (along the surface opposing motion)."}}]}
</script>

<%@ include file="vp-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-physics/js/vp-inclined-plane.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('inclined-plane', 'viz-canvas', {
        angle: 30,
        mass: 5,
        mu: 0.2,
        showFBD: true,
        showComponents: false,
        showAccel: false,
        animate: false
    });
    var state = VisualMath.getState();

    var presets = {
        'frictionless':  { angle: 45, mass: 5, mu: 0 },
        'equilibrium':   { angle: 20, mass: 5, mu: 0.5 },
        'steep':         { angle: 60, mass: 5, mu: 0.2 },
        'just-sliding':  { angle: 30, mass: 5, mu: 0.577 }
    };

    function syncUI() {
        document.getElementById('angle-slider').value = state.angle;
        document.getElementById('angle-display').textContent = state.angle;
        document.getElementById('angle-val').textContent = state.angle;
        document.getElementById('mass-slider').value = state.mass;
        document.getElementById('mass-display').textContent = state.mass;
        document.getElementById('mass-val').textContent = state.mass;
        document.getElementById('mu-slider').value = state.mu;
        document.getElementById('mu-display').textContent = state.mu.toFixed(2);
        document.getElementById('mu-val').textContent = state.mu.toFixed(2);
    }

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var key = this.getAttribute('data-preset');
            var pr = presets[key];
            if (!pr) return;
            state.angle = pr.angle; state.mass = pr.mass; state.mu = pr.mu;
            syncUI();
            document.querySelectorAll('[data-preset]').forEach(function (b) {
                b.classList.toggle('active', b.getAttribute('data-preset') === key);
            });
            state._reset(); state._redraw();
        });
    });

    document.getElementById('angle-slider').addEventListener('input', function () {
        state.angle = parseInt(this.value);
        document.getElementById('angle-display').textContent = this.value;
        document.getElementById('angle-val').textContent = this.value;
        document.querySelectorAll('[data-preset]').forEach(function (b) { b.classList.remove('active'); });
        state._reset(); state._redraw();
    });

    document.getElementById('mass-slider').addEventListener('input', function () {
        state.mass = parseInt(this.value);
        document.getElementById('mass-display').textContent = this.value;
        document.getElementById('mass-val').textContent = this.value;
        state._reset(); state._redraw();
    });

    document.getElementById('mu-slider').addEventListener('input', function () {
        state.mu = parseFloat(this.value);
        document.getElementById('mu-display').textContent = parseFloat(this.value).toFixed(2);
        document.getElementById('mu-val').textContent = parseFloat(this.value).toFixed(2);
        state._reset(); state._redraw();
    });

    document.getElementById('show-fbd').addEventListener('change', function () { state.showFBD = this.checked; state._redraw(); });
    document.getElementById('show-components').addEventListener('change', function () { state.showComponents = this.checked; state._redraw(); });
    document.getElementById('show-accel').addEventListener('change', function () { state.showAccel = this.checked; state._redraw(); });
    document.getElementById('show-animate').addEventListener('change', function () { state.animate = this.checked; });

    document.getElementById('release-btn').addEventListener('click', function () { state._release(); });
    document.getElementById('reset-btn').addEventListener('click', function () { state._reset(); });
});
</script>
