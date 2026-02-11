<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Photoelectric Effect Simulator - Photons, Work Function (Free)";
    String seoDescription = "Interactive photoelectric effect simulator. Adjust wavelength, intensity, and material to explore photon energy, work function, threshold frequency, and electron emission.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-physics/photoelectric-effect.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Photoelectric Effect Simulator - Photons, Work Function\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Photoelectric Effect Simulator\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"photoelectric effect, photon energy, work function, threshold frequency, stopping voltage, Einstein, quantum physics, modern physics simulator\">");

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
        <span class="breadcrumb-current">Photoelectric Effect</span>
    </nav>

    <div class="viz-header">
        <h1>Photoelectric Effect Simulator</h1>
        <p class="viz-subtitle">Shine light on a metal surface and observe electron emission. Explore how wavelength, intensity, and material affect the photoelectric effect &mdash; a cornerstone of quantum physics.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Light & Material</h3>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-preset="uv-cesium">UV on Cesium</button>
                        <button class="vm-chip" data-preset="visible-zinc">Visible on Zinc</button>
                        <button class="vm-chip" data-preset="threshold">Threshold Freq</button>
                        <button class="vm-chip" data-preset="stopping">Stopping Voltage</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>Wavelength = <span id="wl-display">300</span> nm</label>
                    <div class="viz-slider-row">
                        <input type="range" id="wl-slider" min="100" max="700" value="300" step="10">
                        <span class="viz-slider-val" id="wl-val">300</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Intensity = <span id="int-display">5</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="int-slider" min="1" max="10" value="5" step="1">
                        <span class="viz-slider-val" id="int-val">5</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Stopping Voltage = <span id="sv-display">0</span> V</label>
                    <div class="viz-slider-row">
                        <input type="range" id="sv-slider" min="0" max="5" value="0" step="0.1">
                        <span class="viz-slider-val" id="sv-val">0</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Material</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-mat="cesium" data-phi="2.1">Cesium (&phi;=2.1eV)</button>
                        <button class="vm-chip" data-mat="sodium" data-phi="2.3">Sodium (&phi;=2.3eV)</button>
                        <button class="vm-chip" data-mat="zinc" data-phi="4.3">Zinc (&phi;=4.3eV)</button>
                        <button class="vm-chip" data-mat="copper" data-phi="4.7">Copper (&phi;=4.7eV)</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>Show</label>
                    <div style="display:flex;flex-direction:column;gap:6px;">
                        <label class="viz-checkbox"><input type="checkbox" id="show-photons" checked> Photon beam</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-energy"> Energy diagram</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-graph"> KE vs f graph</label>
                    </div>
                </div>

                <div class="viz-btn-row">
                    <button class="viz-btn viz-btn-primary" id="shine-btn">Shine</button>
                    <button class="viz-btn viz-btn-secondary" id="reset-btn">Reset</button>
                </div>
            </div>

            <div class="viz-values">
                <h3>Properties</h3>
                <table>
                    <tr><td>Wavelength</td><td id="val-wavelength">300 nm</td></tr>
                    <tr><td>Frequency</td><td id="val-frequency">--</td></tr>
                    <tr><td>Photon Energy</td><td id="val-photonenergy">--</td></tr>
                    <tr><td>Material</td><td id="val-material">Cesium</td></tr>
                    <tr><td>Work Function</td><td id="val-workfunction">2.1 eV</td></tr>
                    <tr><td>Threshold f</td><td id="val-threshfreq">--</td></tr>
                    <tr><td>Threshold &lambda;</td><td id="val-threshwl">--</td></tr>
                    <tr><td>Max KE</td><td id="val-maxke">--</td></tr>
                    <tr><td>Stopping V</td><td id="val-stoppingv">0 V</td></tr>
                    <tr><td>Emitted?</td><td id="val-emitted">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Physics Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Photoelectric Equations</h3>
                <ul>
                    <li>Photon energy: <span class="formula-highlight">E = hf = hc/&lambda;</span></li>
                    <li>Max kinetic energy: <span class="formula-highlight">KE&#8344;&#8336;&#8339; = hf &minus; &phi;</span></li>
                    <li>Threshold frequency: <span class="formula-highlight">f&#8320; = &phi;/h</span></li>
                    <li>Stopping voltage: <span class="formula-highlight">eV&#8347; = KE&#8344;&#8336;&#8339;</span></li>
                    <li>h = 6.626 &times; 10&#8315;&sup3;&#8308; J&middot;s</li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Key Concepts</h3>
                <ul>
                    <li><strong>Photons</strong> are discrete packets of light energy; each carries energy E = hf</li>
                    <li><strong>Work function</strong> (&phi;) is the minimum energy needed to free an electron from the metal surface</li>
                    <li><strong>Intensity affects count</strong> of emitted electrons, not their maximum kinetic energy</li>
                    <li><strong>Below threshold frequency</strong>, no electrons are emitted regardless of intensity &mdash; this proved light's particle nature</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-physics/diffraction.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(249,115,22,0.12);">&#127752;</div>
                <div><h4>Diffraction Patterns</h4><span>Optics</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-physics/ideal-gas.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(234,179,8,0.12);">&#9832;</div>
                <div><h4>Ideal Gas Law</h4><span>Thermodynamics</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/exp-log.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#10548;</div>
                <div><h4>Exp & Log</h4><span>Visual Math</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{"@context":"https://schema.org","@type":"LearningResource","name":"Photoelectric Effect Simulator","description":"Interactive photoelectric effect simulator. Adjust wavelength, intensity, and material to explore photon energy, work function, threshold frequency, and electron emission.","url":"https://8gwifi.org/exams/visual-physics/photoelectric-effect.jsp","educationalLevel":"High School","teaches":"Photoelectric effect, photon energy, work function, threshold frequency, stopping voltage, quantum physics","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Physics","item":"https://8gwifi.org/exams/visual-physics/"},{"@type":"ListItem","position":4,"name":"Photoelectric Effect"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"What is the photoelectric effect?","acceptedAnswer":{"@type":"Answer","text":"The photoelectric effect is the emission of electrons from a metal surface when light shines on it. Einstein explained it in 1905 by proposing that light consists of photons, each carrying energy E = hf. An electron is emitted only if the photon's energy exceeds the metal's work function (\u03c6)."}},{"@type":"Question","name":"Why doesn't increasing intensity produce higher-energy electrons?","acceptedAnswer":{"@type":"Answer","text":"Increasing intensity means more photons per second, but each photon still carries the same energy (hf). More photons eject more electrons (higher current), but the maximum kinetic energy of each electron depends only on the photon frequency: KE_max = hf \u2212 \u03c6. This was a key proof that light has particle-like properties."}},{"@type":"Question","name":"What is stopping voltage in the photoelectric effect?","acceptedAnswer":{"@type":"Answer","text":"Stopping voltage (V\u209b) is the minimum reverse voltage needed to stop the most energetic emitted electrons from reaching the collector. It directly measures the maximum kinetic energy: eV\u209b = KE_max = hf \u2212 \u03c6. By plotting stopping voltage vs frequency, you can determine Planck's constant (h) and the work function (\u03c6)."}}]}
</script>

<%@ include file="vp-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-physics/js/vp-photoelectric.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('photoelectric', 'viz-canvas', {
        wavelength: 300, intensity: 5, stoppingVoltage: 0,
        material: 'Cesium', workFunction: 2.1,
        showPhotons: true, showEnergyDiagram: false, showGraph: false
    });
    var state = VisualMath.getState();

    var presets = {
        'uv-cesium':    { wl: 200, mat: 'Cesium', phi: 2.1, sv: 0 },
        'visible-zinc': { wl: 500, mat: 'Zinc', phi: 4.3, sv: 0 },
        'threshold':    { wl: 590, mat: 'Cesium', phi: 2.1, sv: 0 },
        'stopping':     { wl: 250, mat: 'Cesium', phi: 2.1, sv: 2.5 }
    };

    function syncUI() {
        document.getElementById('wl-slider').value = state.wavelength;
        document.getElementById('wl-display').textContent = state.wavelength;
        document.getElementById('wl-val').textContent = state.wavelength;
        document.getElementById('int-slider').value = state.intensity;
        document.getElementById('int-display').textContent = state.intensity;
        document.getElementById('int-val').textContent = state.intensity;
        document.getElementById('sv-slider').value = state.stoppingVoltage;
        document.getElementById('sv-display').textContent = state.stoppingVoltage;
        document.getElementById('sv-val').textContent = state.stoppingVoltage;
    }

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var key = this.getAttribute('data-preset');
            var pr = presets[key]; if (!pr) return;
            state.wavelength = pr.wl; state.material = pr.mat;
            state.workFunction = pr.phi; state.stoppingVoltage = pr.sv;
            syncUI();
            document.querySelectorAll('[data-preset]').forEach(function (b) {
                b.classList.toggle('active', b.getAttribute('data-preset') === key);
            });
            document.querySelectorAll('[data-mat]').forEach(function (b) {
                b.classList.toggle('active', b.getAttribute('data-mat') === pr.mat.toLowerCase());
            });
            state._reset(); state._redraw();
        });
    });

    document.querySelectorAll('[data-mat]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            state.material = this.getAttribute('data-mat');
            state.material = state.material.charAt(0).toUpperCase() + state.material.slice(1);
            state.workFunction = parseFloat(this.getAttribute('data-phi'));
            document.querySelectorAll('[data-mat]').forEach(function (b) {
                b.classList.toggle('active', b.getAttribute('data-mat') === btn.getAttribute('data-mat'));
            });
            state._redraw();
        });
    });

    document.getElementById('wl-slider').addEventListener('input', function () {
        state.wavelength = parseInt(this.value);
        document.getElementById('wl-display').textContent = this.value;
        document.getElementById('wl-val').textContent = this.value;
        state._redraw();
    });
    document.getElementById('int-slider').addEventListener('input', function () {
        state.intensity = parseInt(this.value);
        document.getElementById('int-display').textContent = this.value;
        document.getElementById('int-val').textContent = this.value;
    });
    document.getElementById('sv-slider').addEventListener('input', function () {
        state.stoppingVoltage = parseFloat(this.value);
        document.getElementById('sv-display').textContent = this.value;
        document.getElementById('sv-val').textContent = this.value;
        state._redraw();
    });

    document.getElementById('show-photons').addEventListener('change', function () { state.showPhotons = this.checked; });
    document.getElementById('show-energy').addEventListener('change', function () { state.showEnergyDiagram = this.checked; state._redraw(); });
    document.getElementById('show-graph').addEventListener('change', function () { state.showGraph = this.checked; state._redraw(); });

    document.getElementById('shine-btn').addEventListener('click', function () { state._shine(); });
    document.getElementById('reset-btn').addEventListener('click', function () { state._reset(); });
});
</script>
