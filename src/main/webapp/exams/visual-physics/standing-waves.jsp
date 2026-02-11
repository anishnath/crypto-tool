<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Standing Waves Simulator - Harmonics, Nodes, Resonance (Free)";
    String seoDescription = "Interactive standing waves simulator. Explore harmonics on strings, open pipes, and closed pipes. See nodes, antinodes, wavelength, and frequency for each harmonic mode.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-physics/standing-waves.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Standing Waves Simulator - Harmonics, Nodes, Resonance\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Standing Waves Simulator\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"standing waves, harmonics, nodes, antinodes, resonance, string vibration, open pipe, closed pipe, fundamental frequency, physics simulator\">");

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
        <span class="breadcrumb-current">Standing Waves</span>
    </nav>

    <div class="viz-header">
        <h1>Standing Waves & Harmonics</h1>
        <p class="viz-subtitle">Visualize standing wave patterns on strings and in pipes. Select harmonics to see nodes, antinodes, wavelength, and frequency for each resonant mode.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Wave Parameters</h3>

                <div class="control-group">
                    <label>Mode</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-mode="string">Fixed String</button>
                        <button class="vm-chip" data-mode="open">Open Pipe</button>
                        <button class="vm-chip" data-mode="closed">Closed Pipe</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip" data-preset="fundamental">Fundamental</button>
                        <button class="vm-chip" data-preset="guitar3">Guitar 3rd</button>
                        <button class="vm-chip" data-preset="organ2">Open Organ 2nd</button>
                        <button class="vm-chip" data-preset="closed3">Closed 3rd</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>Harmonic n = <span id="harmonic-display">1</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="harmonic-slider" min="1" max="8" value="1" step="1">
                        <span class="viz-slider-val" id="harmonic-val">1</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Length = <span id="length-display">1.00</span> m</label>
                    <div class="viz-slider-row">
                        <input type="range" id="length-slider" min="0.5" max="3.0" value="1.0" step="0.05">
                        <span class="viz-slider-val" id="length-val">1.00</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Wave Speed = <span id="speed-display">340</span> m/s</label>
                    <div class="viz-slider-row">
                        <input type="range" id="speed-slider" min="100" max="500" value="340" step="10">
                        <span class="viz-slider-val" id="speed-val">340</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Show</label>
                    <div style="display:flex;flex-direction:column;gap:6px;">
                        <label class="viz-checkbox"><input type="checkbox" id="show-labels"> Node/antinode labels</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-envelope"> Envelope</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-animate" checked> Animate</label>
                    </div>
                </div>

                <div class="viz-btn-row">
                    <button class="viz-btn viz-btn-primary" id="play-btn">Pause</button>
                    <button class="viz-btn viz-btn-secondary" id="reset-btn">Reset</button>
                </div>
            </div>

            <div class="viz-values">
                <h3>Properties</h3>
                <table>
                    <tr><td>Mode</td><td id="val-mode">Fixed String</td></tr>
                    <tr><td>Harmonic</td><td id="val-harmonic">1</td></tr>
                    <tr><td>Length</td><td id="val-length">1.00 m</td></tr>
                    <tr><td>Wavelength</td><td id="val-wavelength">--</td></tr>
                    <tr><td>Frequency</td><td id="val-frequency">--</td></tr>
                    <tr><td>Wave Speed</td><td id="val-speed">340 m/s</td></tr>
                    <tr><td>Nodes</td><td id="val-nodes">--</td></tr>
                    <tr><td>Antinodes</td><td id="val-antinodes">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Physics Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Standing Wave Formulas</h3>
                <ul>
                    <li>Fixed string / open pipe: <span class="formula-highlight">&lambda; = 2L/n, f = nv/(2L)</span></li>
                    <li>Closed pipe (odd n only): <span class="formula-highlight">&lambda; = 4L/n, f = nv/(4L)</span></li>
                    <li>Standing wave equation: <span class="formula-highlight">y(x,t) = 2A sin(kx) cos(&omega;t)</span></li>
                    <li>Nodes occur at <span class="formula-highlight">sin(kx) = 0</span></li>
                    <li>Antinodes occur at <span class="formula-highlight">|sin(kx)| = 1</span></li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Key Concepts</h3>
                <ul>
                    <li><strong>Standing waves</strong> form when two identical waves travel in opposite directions and interfere, creating fixed nodes and antinodes</li>
                    <li><strong>Harmonics</strong> are the resonant frequencies at which standing waves form: n=1 is the fundamental, n=2 the second harmonic, etc.</li>
                    <li><strong>Closed pipes</strong> only support odd harmonics because one end is a node and the other is an antinode</li>
                    <li><strong>Musical instruments</strong> produce specific harmonics depending on their boundary conditions</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-physics/wave-interference.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(34,197,94,0.12);">&#8776;</div>
                <div><h4>Wave Interference</h4><span>Waves</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-physics/doppler-effect.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(34,197,94,0.12);">&#128266;</div>
                <div><h4>Doppler Effect</h4><span>Waves</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/trig-graphs.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#10548;</div>
                <div><h4>Trig Graphs</h4><span>Visual Math</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{"@context":"https://schema.org","@type":"LearningResource","name":"Standing Waves Simulator","description":"Interactive standing waves simulator. Explore harmonics on strings, open pipes, and closed pipes. See nodes, antinodes, wavelength, and frequency for each harmonic mode.","url":"https://8gwifi.org/exams/visual-physics/standing-waves.jsp","educationalLevel":"High School","teaches":"Standing waves, harmonics, nodes, antinodes, resonance, string vibration, open pipe, closed pipe, fundamental frequency","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Physics","item":"https://8gwifi.org/exams/visual-physics/"},{"@type":"ListItem","position":4,"name":"Standing Waves"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"What is a standing wave?","acceptedAnswer":{"@type":"Answer","text":"A standing wave is a wave pattern that appears to stand still, formed by the superposition of two waves travelling in opposite directions with the same frequency and amplitude. Fixed points called nodes have zero displacement, while antinodes vibrate with maximum amplitude."}},{"@type":"Question","name":"Why do closed pipes only produce odd harmonics?","acceptedAnswer":{"@type":"Answer","text":"A closed pipe has a displacement node at the closed end and an antinode at the open end. This boundary condition means the pipe length must equal an odd number of quarter wavelengths (L = n\u03bb/4 where n = 1, 3, 5...), so only odd harmonics are supported."}},{"@type":"Question","name":"How do harmonics relate to musical instruments?","acceptedAnswer":{"@type":"Answer","text":"Musical instruments produce standing waves at their resonant frequencies. The fundamental (1st harmonic) determines the pitch, while higher harmonics (overtones) contribute to the timbre or tone quality. String instruments support all harmonics, while wind instruments with one closed end produce only odd harmonics."}}]}
</script>

<%@ include file="vp-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-physics/js/vp-standing-waves.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('standing-waves', 'viz-canvas', {
        mode: 'string',
        harmonic: 1,
        length: 1.0,
        waveSpeed: 340,
        showLabels: false,
        showEnvelope: false,
        animate: true
    });
    var state = VisualMath.getState();
    var running = true;

    var presets = {
        'fundamental': { mode: 'string', harmonic: 1, length: 1.0, speed: 340 },
        'guitar3':     { mode: 'string', harmonic: 3, length: 0.65, speed: 340 },
        'organ2':      { mode: 'open', harmonic: 2, length: 1.0, speed: 340 },
        'closed3':     { mode: 'closed', harmonic: 3, length: 1.0, speed: 340 }
    };

    function syncUI() {
        document.getElementById('harmonic-slider').value = state.harmonic;
        document.getElementById('harmonic-display').textContent = state.harmonic;
        document.getElementById('harmonic-val').textContent = state.harmonic;
        document.getElementById('length-slider').value = state.length;
        document.getElementById('length-display').textContent = state.length.toFixed(2);
        document.getElementById('length-val').textContent = state.length.toFixed(2);
        document.getElementById('speed-slider').value = state.waveSpeed;
        document.getElementById('speed-display').textContent = state.waveSpeed;
        document.getElementById('speed-val').textContent = state.waveSpeed;

        document.querySelectorAll('[data-mode]').forEach(function (b) {
            b.classList.toggle('active', b.getAttribute('data-mode') === state.mode);
        });
    }

    document.querySelectorAll('[data-mode]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            state.mode = this.getAttribute('data-mode');
            if (state.mode === 'closed' && state.harmonic % 2 === 0) {
                state.harmonic = Math.max(1, state.harmonic - 1);
            }
            syncUI();
            state._redraw();
        });
    });

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var key = this.getAttribute('data-preset');
            var pr = presets[key];
            if (!pr) return;
            state.mode = pr.mode;
            state.harmonic = pr.harmonic;
            state.length = pr.length;
            state.waveSpeed = pr.speed;
            syncUI();
            state._reset();
        });
    });

    document.getElementById('harmonic-slider').addEventListener('input', function () {
        var v = parseInt(this.value);
        if (state.mode === 'closed' && v % 2 === 0) v = Math.max(1, v - 1);
        state.harmonic = v;
        this.value = v;
        document.getElementById('harmonic-display').textContent = v;
        document.getElementById('harmonic-val').textContent = v;
        state._redraw();
    });

    document.getElementById('length-slider').addEventListener('input', function () {
        state.length = parseFloat(this.value);
        document.getElementById('length-display').textContent = parseFloat(this.value).toFixed(2);
        document.getElementById('length-val').textContent = parseFloat(this.value).toFixed(2);
        state._redraw();
    });

    document.getElementById('speed-slider').addEventListener('input', function () {
        state.waveSpeed = parseInt(this.value);
        document.getElementById('speed-display').textContent = this.value;
        document.getElementById('speed-val').textContent = this.value;
        state._redraw();
    });

    document.getElementById('show-labels').addEventListener('change', function () {
        state.showLabels = this.checked; state._redraw();
    });
    document.getElementById('show-envelope').addEventListener('change', function () {
        state.showEnvelope = this.checked; state._redraw();
    });
    document.getElementById('show-animate').addEventListener('change', function () {
        state.animate = this.checked;
        if (this.checked && running) state._play();
    });

    document.getElementById('play-btn').addEventListener('click', function () {
        if (running) { state._pause(); this.textContent = 'Play'; running = false; }
        else { state._play(); this.textContent = 'Pause'; running = true; }
    });
    document.getElementById('reset-btn').addEventListener('click', function () {
        state._reset();
        document.getElementById('play-btn').textContent = 'Pause';
        running = true;
    });
});
</script>
