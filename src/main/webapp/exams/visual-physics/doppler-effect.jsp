<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Doppler Effect Simulator - Frequency Shift, Wavefronts (Free)";
    String seoDescription = "Interactive Doppler effect simulator. Adjust source and observer speeds to visualize frequency shift, expanding wavefronts, Mach cones, and the sonic boom phenomenon.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-physics/doppler-effect.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Doppler Effect Simulator - Frequency Shift, Wavefronts\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Doppler Effect Simulator\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"doppler effect, frequency shift, wavefronts, mach cone, sonic boom, supersonic, ambulance siren, doppler shift, physics simulator\">");

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
        <span class="breadcrumb-current">Doppler Effect</span>
    </nav>

    <div class="viz-header">
        <h1>Doppler Effect Simulator</h1>
        <p class="viz-subtitle">Watch how a moving source compresses and stretches wavefronts. See the Doppler frequency shift, Mach cone formation, and the transition to supersonic speeds.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Doppler Parameters</h3>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-preset="ambulance">Ambulance</button>
                        <button class="vm-chip" data-preset="supersonic">Supersonic Jet</button>
                        <button class="vm-chip" data-preset="siren">Police Siren</button>
                        <button class="vm-chip" data-preset="both">Both Moving</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>Source Speed = <span id="vs-display">30</span> m/s</label>
                    <div class="viz-slider-row">
                        <input type="range" id="vs-slider" min="0" max="400" value="30" step="5">
                        <span class="viz-slider-val" id="vs-val">30</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Observer Speed = <span id="vo-display">0</span> m/s</label>
                    <div class="viz-slider-row">
                        <input type="range" id="vo-slider" min="-100" max="100" value="0" step="5">
                        <span class="viz-slider-val" id="vo-val">0</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Source Frequency = <span id="f0-display">700</span> Hz</label>
                    <div class="viz-slider-row">
                        <input type="range" id="f0-slider" min="200" max="2000" value="700" step="50">
                        <span class="viz-slider-val" id="f0-val">700</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Show</label>
                    <div style="display:flex;flex-direction:column;gap:6px;">
                        <label class="viz-checkbox"><input type="checkbox" id="show-wavefronts" checked> Wavefronts</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-mach"> Mach cone</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-spectrum"> Frequency spectrum</label>
                    </div>
                </div>

                <div class="viz-btn-row">
                    <button class="viz-btn viz-btn-primary" id="play-btn">Pause</button>
                </div>
            </div>

            <div class="viz-values">
                <h3>Properties</h3>
                <table>
                    <tr><td>f&#8320;</td><td id="val-f0">700 Hz</td></tr>
                    <tr><td>v&#8347;</td><td id="val-vs">30 m/s</td></tr>
                    <tr><td>v&#8338;</td><td id="val-vo">0 m/s</td></tr>
                    <tr><td>v (sound)</td><td id="val-v">340 m/s</td></tr>
                    <tr><td>f (approach)</td><td id="val-fapproach">--</td></tr>
                    <tr><td>f (recede)</td><td id="val-frecede">--</td></tr>
                    <tr><td>Mach</td><td id="val-mach">--</td></tr>
                    <tr><td>&lambda; approach</td><td id="val-lambdaApproach">--</td></tr>
                    <tr><td>&lambda; recede</td><td id="val-lambdaRecede">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Physics Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Doppler Formulas</h3>
                <ul>
                    <li>Observed frequency: <span class="formula-highlight">f = f&#8320;(v + v&#8338;)/(v &minus; v&#8347;)</span></li>
                    <li>Mach number: <span class="formula-highlight">M = v&#8347;/v</span></li>
                    <li>Mach cone half-angle: <span class="formula-highlight">sin(&alpha;) = 1/M</span></li>
                    <li>Approaching wavelength: <span class="formula-highlight">&lambda; = (v &minus; v&#8347;)/f&#8320;</span></li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Key Concepts</h3>
                <ul>
                    <li><strong>Doppler effect</strong>: the change in observed frequency when a source and observer are in relative motion</li>
                    <li><strong>Approaching sources</strong> compress wavefronts, producing a higher observed frequency (blue shift)</li>
                    <li><strong>Receding sources</strong> stretch wavefronts, producing a lower observed frequency (red shift)</li>
                    <li><strong>Sonic boom</strong> occurs when the source exceeds the speed of sound (Mach > 1), creating a shock wave cone</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-physics/standing-waves.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(34,197,94,0.12);">&#127926;</div>
                <div><h4>Standing Waves</h4><span>Waves</span></div>
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
{"@context":"https://schema.org","@type":"LearningResource","name":"Doppler Effect Simulator","description":"Interactive Doppler effect simulator. Adjust source and observer speeds to visualize frequency shift, expanding wavefronts, Mach cones, and the sonic boom phenomenon.","url":"https://8gwifi.org/exams/visual-physics/doppler-effect.jsp","educationalLevel":"High School","teaches":"Doppler effect, frequency shift, wavefronts, Mach number, sonic boom, supersonic","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Physics","item":"https://8gwifi.org/exams/visual-physics/"},{"@type":"ListItem","position":4,"name":"Doppler Effect"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"What is the Doppler effect?","acceptedAnswer":{"@type":"Answer","text":"The Doppler effect is the change in observed frequency (or wavelength) of a wave when the source and observer are moving relative to each other. A familiar example is an ambulance siren sounding higher-pitched as it approaches and lower-pitched as it moves away."}},{"@type":"Question","name":"What happens when a source exceeds the speed of sound?","acceptedAnswer":{"@type":"Answer","text":"When a source moves faster than the speed of sound (Mach > 1), it creates a cone-shaped shock wave called a Mach cone. The half-angle of this cone is given by sin(\u03b1) = 1/M. An observer hears a sudden loud 'sonic boom' when this shock wave passes."}},{"@type":"Question","name":"Does the Doppler effect work with light?","acceptedAnswer":{"@type":"Answer","text":"Yes. The Doppler effect applies to all waves, including light. Approaching light sources appear blue-shifted (higher frequency), while receding sources appear red-shifted (lower frequency). This is fundamental in astronomy for measuring the velocities of stars and galaxies."}}]}
</script>

<%@ include file="vp-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-physics/js/vp-doppler-effect.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('doppler-effect', 'viz-canvas', {
        sourceSpeed: 30, observerSpeed: 0, sourceFreq: 700, waveSpeed: 340,
        showWavefronts: true, showMachCone: false, showSpectrum: false
    });
    var state = VisualMath.getState();
    var running = true;

    var presets = {
        'ambulance':  { vs: 30, vo: 0, f: 700 },
        'supersonic': { vs: 400, vo: 0, f: 700 },
        'siren':      { vs: 40, vo: 0, f: 900 },
        'both':       { vs: 50, vo: -20, f: 700 }
    };

    function syncUI() {
        document.getElementById('vs-slider').value = state.sourceSpeed;
        document.getElementById('vs-display').textContent = state.sourceSpeed;
        document.getElementById('vs-val').textContent = state.sourceSpeed;
        document.getElementById('vo-slider').value = state.observerSpeed;
        document.getElementById('vo-display').textContent = state.observerSpeed;
        document.getElementById('vo-val').textContent = state.observerSpeed;
        document.getElementById('f0-slider').value = state.sourceFreq;
        document.getElementById('f0-display').textContent = state.sourceFreq;
        document.getElementById('f0-val').textContent = state.sourceFreq;
    }

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var key = this.getAttribute('data-preset');
            var pr = presets[key]; if (!pr) return;
            state.sourceSpeed = pr.vs; state.observerSpeed = pr.vo; state.sourceFreq = pr.f;
            syncUI();
            document.querySelectorAll('[data-preset]').forEach(function (b) {
                b.classList.toggle('active', b.getAttribute('data-preset') === key);
            });
            state._redraw();
        });
    });

    document.getElementById('vs-slider').addEventListener('input', function () {
        state.sourceSpeed = parseInt(this.value);
        document.getElementById('vs-display').textContent = this.value;
        document.getElementById('vs-val').textContent = this.value;
        document.querySelectorAll('[data-preset]').forEach(function (b) { b.classList.remove('active'); });
        state._redraw();
    });

    document.getElementById('vo-slider').addEventListener('input', function () {
        state.observerSpeed = parseInt(this.value);
        document.getElementById('vo-display').textContent = this.value;
        document.getElementById('vo-val').textContent = this.value;
        state._redraw();
    });

    document.getElementById('f0-slider').addEventListener('input', function () {
        state.sourceFreq = parseInt(this.value);
        document.getElementById('f0-display').textContent = this.value;
        document.getElementById('f0-val').textContent = this.value;
        state._redraw();
    });

    document.getElementById('show-wavefronts').addEventListener('change', function () { state.showWavefronts = this.checked; state._redraw(); });
    document.getElementById('show-mach').addEventListener('change', function () { state.showMachCone = this.checked; state._redraw(); });
    document.getElementById('show-spectrum').addEventListener('change', function () { state.showSpectrum = this.checked; state._redraw(); });

    document.getElementById('play-btn').addEventListener('click', function () {
        if (running) { state._pause(); this.textContent = 'Play'; running = false; }
        else { state._play(); this.textContent = 'Pause'; running = true; }
    });
});
</script>
