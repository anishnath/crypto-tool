<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Projectile Motion Simulator - Trajectory, Range, Max Height (Free)";
    String seoDescription = "Interactive projectile motion simulator. Adjust launch angle, initial velocity, and gravity to visualize trajectory, range, maximum height, and time of flight in real time.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-physics/projectile-motion.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Projectile Motion Simulator - Trajectory, Range, Max Height\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Projectile Motion Simulator\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"projectile motion, trajectory simulator, range calculator, max height, time of flight, kinematics, physics simulator, launch angle\">");

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
        <span class="breadcrumb-current">Projectile Motion</span>
    </nav>

    <div class="viz-header">
        <h1>Projectile Motion Simulator</h1>
        <p class="viz-subtitle">Launch a projectile and watch its trajectory in real time. Adjust the angle, initial velocity, and gravity to explore range, maximum height, and time of flight.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Launch Parameters</h3>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-preset="max-range">Max Range (45&deg;)</button>
                        <button class="vm-chip" data-preset="high-lob">High Lob (75&deg;)</button>
                        <button class="vm-chip" data-preset="low-drive">Low Drive (15&deg;)</button>
                        <button class="vm-chip" data-preset="mortar">Mortar (60&deg;)</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>Angle = <span id="angle-display">45</span>&deg;</label>
                    <div class="viz-slider-row">
                        <input type="range" id="angle-slider" min="0" max="90" value="45" step="1">
                        <span class="viz-slider-val" id="angle-val">45</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>V&#8320; = <span id="v0-display">25</span> m/s</label>
                    <div class="viz-slider-row">
                        <input type="range" id="v0-slider" min="5" max="50" value="25" step="1">
                        <span class="viz-slider-val" id="v0-val">25</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Gravity</label>
                    <select id="gravity-select" class="viz-select">
                        <option value="9.8" selected>Earth (9.8 m/s&sup2;)</option>
                        <option value="1.6">Moon (1.6 m/s&sup2;)</option>
                        <option value="3.7">Mars (3.7 m/s&sup2;)</option>
                        <option value="24.8">Jupiter (24.8 m/s&sup2;)</option>
                    </select>
                </div>

                <div class="control-group">
                    <label>Show</label>
                    <div style="display:flex;flex-direction:column;gap:6px;">
                        <label class="viz-checkbox"><input type="checkbox" id="show-velocity" checked> Velocity components</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-trail" checked> Trail</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-markers" checked> Markers</label>
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
                    <tr><td>Angle</td><td id="val-angle">45&deg;</td></tr>
                    <tr><td>V&#8320;</td><td id="val-v0">25 m/s</td></tr>
                    <tr><td>V&#8320;&#8339;</td><td id="val-v0x">--</td></tr>
                    <tr><td>V&#8320;&#7527;</td><td id="val-v0y">--</td></tr>
                    <tr><td>Max Height</td><td id="val-maxHeight">--</td></tr>
                    <tr><td>Range</td><td id="val-range">--</td></tr>
                    <tr><td>Time of Flight</td><td id="val-tof">--</td></tr>
                    <tr><td>Current t</td><td id="val-currentT">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Physics Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Kinematics Formulas</h3>
                <ul>
                    <li>Range: <span class="formula-highlight">R = V&#8320;&sup2; sin(2&theta;) / g</span></li>
                    <li>Max Height: <span class="formula-highlight">H = V&#8320;&sup2; sin&sup2;(&theta;) / (2g)</span></li>
                    <li>Time of Flight: <span class="formula-highlight">T = 2V&#8320; sin(&theta;) / g</span></li>
                    <li>Horizontal position: <span class="formula-highlight">x(t) = V&#8320; cos(&theta;) &middot; t</span></li>
                    <li>Vertical position: <span class="formula-highlight">y(t) = V&#8320; sin(&theta;) &middot; t &minus; &frac12;g t&sup2;</span></li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Key Concepts</h3>
                <ul>
                    <li><strong>Independence of axes</strong>: horizontal and vertical motions are independent &mdash; gravity only affects the vertical component</li>
                    <li><strong>45&deg; maximises range</strong> on level ground because sin(2&theta;) peaks at &theta; = 45&deg;</li>
                    <li><strong>Complementary angles</strong> (e.g. 30&deg; and 60&deg;) give the same range but different max heights and flight times</li>
                    <li><strong>Air resistance</strong> is neglected here &mdash; real trajectories are asymmetric and shorter</li>
                    <li><strong>Gravity varies</strong> across celestial bodies, dramatically changing trajectory shape</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-physics/pendulum-shm.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(239,68,68,0.12);">&#9201;</div>
                <div><h4>Pendulum &amp; SHM</h4><span>Oscillations</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-physics/wave-interference.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(34,197,94,0.12);">&#8776;</div>
                <div><h4>Wave Interference</h4><span>Waves</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/parametric-curves.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#10548;</div>
                <div><h4>Parametric Curves</h4><span>Visual Math</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{"@context":"https://schema.org","@type":"LearningResource","name":"Projectile Motion Simulator","description":"Interactive projectile motion simulator. Adjust launch angle, initial velocity, and gravity to visualize trajectory, range, maximum height, and time of flight in real time.","url":"https://8gwifi.org/exams/visual-physics/projectile-motion.jsp","educationalLevel":"High School","teaches":"Projectile motion, kinematics, trajectory, range, maximum height, time of flight, gravity","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Physics","item":"https://8gwifi.org/exams/visual-physics/"},{"@type":"ListItem","position":4,"name":"Projectile Motion"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"What angle gives the maximum range in projectile motion?","acceptedAnswer":{"@type":"Answer","text":"On level ground with no air resistance, a launch angle of 45 degrees maximises the horizontal range. This is because the range formula R = v\u00b2 sin(2\u03b8)/g reaches its maximum when sin(2\u03b8) = 1, which occurs at \u03b8 = 45\u00b0. Complementary angles like 30\u00b0 and 60\u00b0 produce the same range but with different trajectories."}},{"@type":"Question","name":"How does gravity affect projectile motion?","acceptedAnswer":{"@type":"Answer","text":"Gravity determines how quickly the projectile decelerates vertically and falls back to the ground. A weaker gravitational field (like the Moon at 1.6 m/s\u00b2) means the projectile stays in the air longer and travels farther, while stronger gravity (like Jupiter at 24.8 m/s\u00b2) pulls it down faster, reducing both range and maximum height."}},{"@type":"Question","name":"Why are the horizontal and vertical motions independent?","acceptedAnswer":{"@type":"Answer","text":"In ideal projectile motion (no air resistance), the only force acting on the projectile is gravity, which acts vertically downward. This means the horizontal velocity remains constant throughout the flight while the vertical velocity changes due to gravitational acceleration. The two components can be analysed separately and combined to find the trajectory."}}]}
</script>

<%@ include file="vp-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-physics/js/vp-projectile.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('projectile-motion', 'viz-canvas', {
        angle: 45,
        v0: 25,
        gravity: 9.8,
        showVelocity: true,
        showTrail: true,
        showMarkers: true
    });
    var state = VisualMath.getState();

    var presets = {
        'max-range': { angle: 45, v0: 25 },
        'high-lob':  { angle: 75, v0: 25 },
        'low-drive': { angle: 15, v0: 35 },
        'mortar':    { angle: 60, v0: 20 }
    };

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var key = this.getAttribute('data-preset');
            var p = presets[key];
            if (!p) return;

            state.angle = p.angle;
            state.v0 = p.v0;

            document.getElementById('angle-slider').value = p.angle;
            document.getElementById('angle-display').textContent = p.angle;
            document.getElementById('angle-val').textContent = p.angle;

            document.getElementById('v0-slider').value = p.v0;
            document.getElementById('v0-display').textContent = p.v0;
            document.getElementById('v0-val').textContent = p.v0;

            document.querySelectorAll('[data-preset]').forEach(function (b) {
                b.classList.toggle('active', b.getAttribute('data-preset') === key);
            });

            state._reset();
            state._redraw();
        });
    });

    document.getElementById('angle-slider').addEventListener('input', function () {
        var v = parseInt(this.value);
        state.angle = v;
        document.getElementById('angle-display').textContent = v;
        document.getElementById('angle-val').textContent = v;
        document.querySelectorAll('[data-preset]').forEach(function (b) { b.classList.remove('active'); });
        state._reset();
        state._redraw();
    });

    document.getElementById('v0-slider').addEventListener('input', function () {
        var v = parseInt(this.value);
        state.v0 = v;
        document.getElementById('v0-display').textContent = v;
        document.getElementById('v0-val').textContent = v;
        document.querySelectorAll('[data-preset]').forEach(function (b) { b.classList.remove('active'); });
        state._reset();
        state._redraw();
    });

    document.getElementById('gravity-select').addEventListener('change', function () {
        state.gravity = parseFloat(this.value);
        state._reset();
        state._redraw();
    });

    document.getElementById('show-velocity').addEventListener('change', function () {
        state.showVelocity = this.checked;
        state._redraw();
    });

    document.getElementById('show-trail').addEventListener('change', function () {
        state.showTrail = this.checked;
        state._redraw();
    });

    document.getElementById('show-markers').addEventListener('change', function () {
        state.showMarkers = this.checked;
        state._redraw();
    });

    document.getElementById('launch-btn').addEventListener('click', function () {
        state._launch();
    });

    document.getElementById('reset-btn').addEventListener('click', function () {
        state._reset();
    });
});
</script>
