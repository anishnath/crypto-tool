<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Orbital Mechanics Simulator - Kepler's Laws, Orbits (Free)";
    String seoDescription = "Interactive orbital mechanics simulator. Adjust semi-major axis and eccentricity to explore Kepler's laws, elliptical orbits, vis-viva equation, and escape velocity.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-physics/orbital-mechanics.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Orbital Mechanics Simulator - Kepler's Laws\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Orbital Mechanics Simulator\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"orbital mechanics, Kepler's laws, elliptical orbit, vis-viva, escape velocity, perihelion, aphelion, semi-major axis, eccentricity, physics simulator\">");

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
        <span class="breadcrumb-current">Orbital Mechanics</span>
    </nav>

    <div class="viz-header">
        <h1>Orbital Mechanics Simulator</h1>
        <p class="viz-subtitle">Explore Kepler's laws and orbital dynamics. Adjust semi-major axis and eccentricity to see how orbits change shape, and observe how speed varies with distance from the central body.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Orbit Parameters</h3>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-preset="earth">Earth</button>
                        <button class="vm-chip" data-preset="halley">Comet Halley</button>
                        <button class="vm-chip" data-preset="circular">Circular LEO</button>
                        <button class="vm-chip" data-preset="mars">Mars</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>Semi-major axis = <span id="a-display">1.000</span> AU</label>
                    <div class="viz-slider-row">
                        <input type="range" id="a-slider" min="0.5" max="10" value="1" step="0.1">
                        <span class="viz-slider-val" id="a-val">1.0</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Eccentricity = <span id="e-display">0.017</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="e-slider" min="0" max="0.95" value="0.017" step="0.001">
                        <span class="viz-slider-val" id="e-val">0.017</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Central Mass = <span id="m-display">1.0</span> M&odot;</label>
                    <div class="viz-slider-row">
                        <input type="range" id="m-slider" min="0.5" max="10" value="1" step="0.5">
                        <span class="viz-slider-val" id="m-val">1.0</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Show</label>
                    <div style="display:flex;flex-direction:column;gap:6px;">
                        <label class="viz-checkbox"><input type="checkbox" id="show-velocity" checked> Velocity vector</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-sweep"> Kepler sweep areas</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-field"> Gravitational field</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-trace" checked> Orbit trace</label>
                    </div>
                </div>

                <div class="viz-btn-row">
                    <button class="viz-btn viz-btn-primary" id="play-btn">Play</button>
                    <button class="viz-btn viz-btn-secondary" id="reset-btn">Reset</button>
                </div>
            </div>

            <div class="viz-values">
                <h3>Properties</h3>
                <table>
                    <tr><td>Semi-major axis</td><td id="val-semimajor">1.000 AU</td></tr>
                    <tr><td>Eccentricity</td><td id="val-eccentricity">0.017</td></tr>
                    <tr><td>Period</td><td id="val-period">--</td></tr>
                    <tr><td>Perihelion</td><td id="val-perihelion">--</td></tr>
                    <tr><td>Aphelion</td><td id="val-aphelion">--</td></tr>
                    <tr><td>Distance</td><td id="val-distance">--</td></tr>
                    <tr><td>Speed</td><td id="val-speed">--</td></tr>
                    <tr><td>Escape v</td><td id="val-escape">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Physics Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Orbital Formulas</h3>
                <ul>
                    <li>Vis-viva: <span class="formula-highlight">v&sup2; = GM(2/r &minus; 1/a)</span></li>
                    <li>Kepler's 3rd law: <span class="formula-highlight">T&sup2; = 4&pi;&sup2;a&sup3;/(GM)</span></li>
                    <li>Orbit equation: <span class="formula-highlight">r(&theta;) = a(1&minus;e&sup2;)/(1+e cos&theta;)</span></li>
                    <li>Escape velocity: <span class="formula-highlight">v&#8338; = &radic;(2GM/r)</span></li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Key Concepts</h3>
                <ul>
                    <li><strong>Kepler's 1st law</strong>: orbits are ellipses with the central body at one focus</li>
                    <li><strong>Kepler's 2nd law</strong>: a line from planet to star sweeps equal areas in equal times &mdash; planets move faster near perihelion</li>
                    <li><strong>Kepler's 3rd law</strong>: the square of the period is proportional to the cube of the semi-major axis</li>
                    <li><strong>Eccentricity</strong> determines orbit shape: e=0 is circular, e near 1 is highly elongated</li>
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
            <a href="<%=request.getContextPath()%>/exams/visual-physics/torque-rotation.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(239,68,68,0.12);">&#9854;</div>
                <div><h4>Torque & Rotation</h4><span>Mechanics</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/polar-coordinates.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#10548;</div>
                <div><h4>Polar Coordinates</h4><span>Visual Math</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{"@context":"https://schema.org","@type":"LearningResource","name":"Orbital Mechanics Simulator","description":"Interactive orbital mechanics simulator exploring Kepler's laws, elliptical orbits, vis-viva equation, and escape velocity.","url":"https://8gwifi.org/exams/visual-physics/orbital-mechanics.jsp","educationalLevel":"High School","teaches":"Orbital mechanics, Kepler's laws, elliptical orbits, vis-viva equation, escape velocity, gravitational physics","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Physics","item":"https://8gwifi.org/exams/visual-physics/"},{"@type":"ListItem","position":4,"name":"Orbital Mechanics"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"What are Kepler's three laws of planetary motion?","acceptedAnswer":{"@type":"Answer","text":"1. All planets move in elliptical orbits with the Sun at one focus. 2. A line joining a planet and the Sun sweeps out equal areas in equal time intervals (planets move faster when closer to the Sun). 3. The square of the orbital period is proportional to the cube of the semi-major axis (T\u00b2 \u221d a\u00b3)."}},{"@type":"Question","name":"What is the vis-viva equation?","acceptedAnswer":{"@type":"Answer","text":"The vis-viva equation v\u00b2 = GM(2/r \u2212 1/a) gives the orbital speed at any point in an elliptical orbit. Here r is the current distance from the central body, a is the semi-major axis, G is the gravitational constant, and M is the central body's mass. It shows that speed increases as distance decreases."}},{"@type":"Question","name":"What determines if an orbit is circular or elliptical?","acceptedAnswer":{"@type":"Answer","text":"The eccentricity (e) determines the orbit shape. When e = 0, the orbit is a perfect circle. As e increases toward 1, the orbit becomes more elongated. Earth's orbit has e = 0.017 (nearly circular), while Comet Halley has e = 0.967 (highly elongated). At e = 1, the trajectory becomes parabolic (escape trajectory)."}}]}
</script>

<%@ include file="vp-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-physics/js/vp-orbital-mechanics.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('orbital-mechanics', 'viz-canvas', {
        semiMajor: 1, eccentricity: 0.017, centralMass: 1,
        showVelocity: true, showSweep: false, showField: false, showTrace: true
    });
    var state = VisualMath.getState();

    var presets = {
        'earth':    { a: 1, e: 0.017, m: 1 },
        'halley':   { a: 5, e: 0.967, m: 1 },
        'circular': { a: 1, e: 0, m: 1 },
        'mars':     { a: 1.524, e: 0.093, m: 1 }
    };

    function syncUI() {
        document.getElementById('a-slider').value = state.semiMajor;
        document.getElementById('a-display').textContent = state.semiMajor.toFixed(3);
        document.getElementById('a-val').textContent = state.semiMajor.toFixed(1);
        document.getElementById('e-slider').value = state.eccentricity;
        document.getElementById('e-display').textContent = state.eccentricity.toFixed(3);
        document.getElementById('e-val').textContent = state.eccentricity.toFixed(3);
        document.getElementById('m-slider').value = state.centralMass;
        document.getElementById('m-display').textContent = state.centralMass.toFixed(1);
        document.getElementById('m-val').textContent = state.centralMass.toFixed(1);
    }

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var key = this.getAttribute('data-preset');
            var pr = presets[key]; if (!pr) return;
            state.semiMajor = pr.a; state.eccentricity = pr.e; state.centralMass = pr.m;
            syncUI();
            document.querySelectorAll('[data-preset]').forEach(function (b) {
                b.classList.toggle('active', b.getAttribute('data-preset') === key);
            });
            state._reset(); state._redraw();
        });
    });

    document.getElementById('a-slider').addEventListener('input', function () {
        state.semiMajor = parseFloat(this.value);
        document.getElementById('a-display').textContent = parseFloat(this.value).toFixed(3);
        document.getElementById('a-val').textContent = parseFloat(this.value).toFixed(1);
        state._redraw();
    });
    document.getElementById('e-slider').addEventListener('input', function () {
        state.eccentricity = parseFloat(this.value);
        document.getElementById('e-display').textContent = parseFloat(this.value).toFixed(3);
        document.getElementById('e-val').textContent = parseFloat(this.value).toFixed(3);
        state._redraw();
    });
    document.getElementById('m-slider').addEventListener('input', function () {
        state.centralMass = parseFloat(this.value);
        document.getElementById('m-display').textContent = parseFloat(this.value).toFixed(1);
        document.getElementById('m-val').textContent = parseFloat(this.value).toFixed(1);
        state._redraw();
    });

    document.getElementById('show-velocity').addEventListener('change', function () { state.showVelocity = this.checked; state._redraw(); });
    document.getElementById('show-sweep').addEventListener('change', function () { state.showSweep = this.checked; state._redraw(); });
    document.getElementById('show-field').addEventListener('change', function () { state.showField = this.checked; state._redraw(); });
    document.getElementById('show-trace').addEventListener('change', function () { state.showTrace = this.checked; state._redraw(); });

    document.getElementById('play-btn').addEventListener('click', function () {
        state._play();
        this.textContent = 'Pause';
        var self = this;
        this.onclick = function () { state._pause(); self.textContent = 'Play'; self.onclick = arguments.callee; };
    });
    document.getElementById('reset-btn').addEventListener('click', function () { state._reset(); });
});
</script>
