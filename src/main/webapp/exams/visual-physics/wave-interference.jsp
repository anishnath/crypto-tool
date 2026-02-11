<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Wave Interference Simulator - Double Slit, Constructive & Destructive (Free)";
    String seoDescription = "Interactive wave interference simulator. Adjust frequency, source separation, and phase difference to visualize constructive and destructive interference, nodal lines, and fringe patterns in real time.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-physics/wave-interference.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Wave Interference Simulator - Constructive & Destructive Patterns\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Wave Interference Simulator\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"wave interference, double slit, constructive interference, destructive interference, nodal lines, fringe pattern, superposition, phase difference, wavelength, physics simulator\">");

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
        <span class="breadcrumb-current">Wave Interference</span>
    </nav>

    <div class="viz-header">
        <h1>Wave Interference Simulator</h1>
        <p class="viz-subtitle">Explore constructive and destructive interference from two coherent sources. Adjust frequency, source separation, and phase difference to see how wavefronts overlap and create interference patterns.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Wave Parameters</h3>

                <div class="control-group">
                    <label>Frequency = <span id="freq-display">4</span> Hz</label>
                    <div class="viz-slider-row">
                        <input type="range" id="freq-slider" min="1" max="10" value="4" step="0.5">
                        <span class="viz-slider-val" id="freq-val">4</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Source Separation = <span id="sep-display">100</span> px</label>
                    <div class="viz-slider-row">
                        <input type="range" id="sep-slider" min="20" max="300" value="100" step="5">
                        <span class="viz-slider-val" id="sep-val">100</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Phase Difference = <span id="phase-display">0</span>&deg;</label>
                    <div class="viz-slider-row">
                        <input type="range" id="phase-slider" min="0" max="6.28" value="0" step="0.1">
                        <span class="viz-slider-val" id="phase-val">0&deg;</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Show</label>
                    <div style="display:flex;flex-direction:column;gap:6px;">
                        <label class="viz-checkbox"><input type="checkbox" id="show-wavefronts"> Wavefronts</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-nodal"> Nodal Lines</label>
                    </div>
                </div>

                <div class="viz-btn-row">
                    <button class="viz-btn viz-btn-primary" id="play-btn">Pause</button>
                </div>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-preset="inphase">In Phase</button>
                        <button class="vm-chip" data-preset="opposite">Opposite Phase</button>
                        <button class="vm-chip" data-preset="wide">Wide Separation</button>
                        <button class="vm-chip" data-preset="close">Close Sources</button>
                    </div>
                </div>
            </div>

            <div class="viz-values">
                <h3>Properties</h3>
                <table>
                    <tr><td>Frequency</td><td id="val-frequency">4 Hz</td></tr>
                    <tr><td>Wavelength</td><td id="val-wavelength">--</td></tr>
                    <tr><td>Wave Speed</td><td id="val-speed">--</td></tr>
                    <tr><td>Separation</td><td id="val-separation">100 px</td></tr>
                    <tr><td>Phase Difference</td><td id="val-phaseDiff">0&deg;</td></tr>
                    <tr><td>Maxima Count</td><td id="val-maxima">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Physics Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Interference Conditions</h3>
                <ul>
                    <li>Path difference: <span class="formula-highlight">&Delta; = d sin(&theta;)</span></li>
                    <li>Constructive (maxima): <span class="formula-highlight">&Delta; = n&lambda;</span> where n = 0, &plusmn;1, &plusmn;2, &hellip;</li>
                    <li>Destructive (minima): <span class="formula-highlight">&Delta; = (n + &frac12;)&lambda;</span></li>
                    <li>Resultant intensity: <span class="formula-highlight">I = 4I&#8320; cos&sup2;(&delta;/2)</span></li>
                    <li>Fringe spacing: <span class="formula-highlight">&Delta;y = &lambda;D / d</span></li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Key Concepts</h3>
                <ul>
                    <li><strong>Superposition</strong>: when two waves meet, their displacements add algebraically &mdash; crests reinforce, crest meets trough cancels</li>
                    <li><strong>Coherence</strong>: stable interference patterns require sources with a constant phase relationship and the same frequency</li>
                    <li><strong>Constructive interference</strong> occurs where the path difference is a whole number of wavelengths, giving maximum amplitude</li>
                    <li><strong>Destructive interference</strong> occurs where the path difference is a half-integer number of wavelengths, giving zero amplitude</li>
                    <li><strong>Nodal lines</strong> radiate outward from between the sources along directions of permanent destructive interference</li>
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
            <a href="<%=request.getContextPath()%>/exams/visual-physics/electric-field.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(234,179,8,0.12);">&#9889;</div>
                <div><h4>Electric Field</h4><span>Electrostatics</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/polar-coordinates.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#10548;</div>
                <div><h4>Polar Coordinates</h4><span>Visual Math</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{"@context":"https://schema.org","@type":"LearningResource","name":"Wave Interference Simulator","description":"Interactive wave interference simulator. Adjust frequency, source separation, and phase difference to visualize constructive and destructive interference, nodal lines, and fringe patterns in real time.","url":"https://8gwifi.org/exams/visual-physics/wave-interference.jsp","educationalLevel":"High School","teaches":"Wave interference, superposition, constructive interference, destructive interference, double slit, nodal lines, fringe spacing, phase difference","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Physics","item":"https://8gwifi.org/exams/visual-physics/"},{"@type":"ListItem","position":4,"name":"Wave Interference"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"What is the difference between constructive and destructive interference?","acceptedAnswer":{"@type":"Answer","text":"Constructive interference occurs when two waves arrive in phase (their crests align), producing a combined wave with greater amplitude. The path difference between the sources equals a whole number of wavelengths (\u0394 = n\u03bb). Destructive interference occurs when two waves arrive out of phase (a crest meets a trough), cancelling each other out. The path difference equals a half-integer number of wavelengths (\u0394 = (n+\u00bd)\u03bb)."}},{"@type":"Question","name":"How does source separation affect the interference pattern?","acceptedAnswer":{"@type":"Answer","text":"Increasing the distance between the two sources (d) decreases the fringe spacing (\u0394y = \u03bbD/d), meaning the bright and dark bands become closer together. More maxima and minima fit into the same observation area. Conversely, bringing the sources closer together produces wider, more spread-out fringes with fewer visible maxima."}},{"@type":"Question","name":"Why does phase difference matter in wave interference?","acceptedAnswer":{"@type":"Answer","text":"Phase difference determines the initial offset between the two waves before they travel to any observation point. When sources are in phase (0\u00b0), the central maximum appears on the perpendicular bisector between them. When sources are in antiphase (180\u00b0), the central line becomes a minimum instead of a maximum, effectively shifting the entire interference pattern by half a fringe spacing."}}]}
</script>

<%@ include file="vp-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-physics/js/vp-wave-interference.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('wave-interference', 'viz-canvas', {
        frequency: 4,
        separation: 100,
        phaseDiff: 0,
        showWavefronts: false,
        showNodalLines: false
    });
    var state = VisualMath.getState();
    var running = true;

    var presets = {
        'inphase':  { freq: 4, sep: 100, phase: 0 },
        'opposite': { freq: 4, sep: 100, phase: Math.PI },
        'wide':     { freq: 4, sep: 250, phase: 0 },
        'close':    { freq: 4, sep: 40,  phase: 0 }
    };

    function toDeg(rad) {
        return Math.round(rad * 180 / Math.PI);
    }

    function syncSliders(f, s, p) {
        document.getElementById('freq-slider').value = f;
        document.getElementById('freq-display').textContent = f;
        document.getElementById('freq-val').textContent = f;

        document.getElementById('sep-slider').value = s;
        document.getElementById('sep-display').textContent = s;
        document.getElementById('sep-val').textContent = s;

        var deg = toDeg(p);
        document.getElementById('phase-slider').value = p;
        document.getElementById('phase-display').textContent = deg;
        document.getElementById('phase-val').textContent = deg + '\u00B0';
    }

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var key = this.getAttribute('data-preset');
            var p = presets[key];
            if (!p) return;

            state.frequency = p.freq;
            state.separation = p.sep;
            state.phaseDiff = p.phase;

            syncSliders(p.freq, p.sep, p.phase);

            document.querySelectorAll('[data-preset]').forEach(function (b) {
                b.classList.toggle('active', b.getAttribute('data-preset') === key);
            });

            state._redraw();
        });
    });

    document.getElementById('freq-slider').addEventListener('input', function () {
        var v = parseFloat(this.value);
        state.frequency = v;
        document.getElementById('freq-display').textContent = v;
        document.getElementById('freq-val').textContent = v;
        document.querySelectorAll('[data-preset]').forEach(function (b) { b.classList.remove('active'); });
        state._redraw();
    });

    document.getElementById('sep-slider').addEventListener('input', function () {
        var v = parseInt(this.value);
        state.separation = v;
        document.getElementById('sep-display').textContent = v;
        document.getElementById('sep-val').textContent = v;
        document.querySelectorAll('[data-preset]').forEach(function (b) { b.classList.remove('active'); });
        state._redraw();
    });

    document.getElementById('phase-slider').addEventListener('input', function () {
        var v = parseFloat(this.value);
        state.phaseDiff = v;
        var deg = toDeg(v);
        document.getElementById('phase-display').textContent = deg;
        document.getElementById('phase-val').textContent = deg + '\u00B0';
        document.querySelectorAll('[data-preset]').forEach(function (b) { b.classList.remove('active'); });
        state._redraw();
    });

    document.getElementById('show-wavefronts').addEventListener('change', function () {
        state.showWavefronts = this.checked;
        state._redraw();
    });

    document.getElementById('show-nodal').addEventListener('change', function () {
        state.showNodalLines = this.checked;
        state._redraw();
    });

    document.getElementById('play-btn').addEventListener('click', function () {
        if (running) {
            state._pause();
            this.textContent = 'Play';
            running = false;
        } else {
            state._play();
            this.textContent = 'Pause';
            running = true;
        }
    });
});
</script>
