<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Diffraction Simulator - Single Slit, Double Slit, Grating (Free)";
    String seoDescription = "Interactive diffraction simulator. Visualize single slit, double slit, and diffraction grating patterns. Adjust slit width, wavelength, and number of slits to see intensity patterns.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-physics/diffraction.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Diffraction Simulator - Single Slit, Double Slit, Grating\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Diffraction Simulator\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"diffraction, single slit, double slit, diffraction grating, intensity pattern, fringe spacing, wavelength, optics, physics simulator\">");

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
        <span class="breadcrumb-current">Diffraction</span>
    </nav>

    <div class="viz-header">
        <h1>Diffraction Patterns</h1>
        <p class="viz-subtitle">Visualize diffraction patterns from single slits, double slits, and gratings. Adjust slit width, separation, and wavelength to see how the intensity pattern changes.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Diffraction Parameters</h3>

                <div class="control-group">
                    <label>Mode</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-mode="single">Single Slit</button>
                        <button class="vm-chip" data-mode="double">Double Slit</button>
                        <button class="vm-chip" data-mode="grating">Grating</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip" data-preset="single-red">Single Red</button>
                        <button class="vm-chip" data-preset="young">Young's Double</button>
                        <button class="vm-chip" data-preset="narrow">Narrow Single</button>
                        <button class="vm-chip" data-preset="grating50">Grating n=50</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>Slit Width = <span id="sw-display">10</span> &mu;m</label>
                    <div class="viz-slider-row">
                        <input type="range" id="sw-slider" min="1" max="20" value="10" step="1">
                        <span class="viz-slider-val" id="sw-val">10</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Slit Separation = <span id="ss-display">25</span> &mu;m</label>
                    <div class="viz-slider-row">
                        <input type="range" id="ss-slider" min="5" max="50" value="25" step="1">
                        <span class="viz-slider-val" id="ss-val">25</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Wavelength = <span id="wl-display">550</span> nm</label>
                    <div class="viz-slider-row">
                        <input type="range" id="wl-slider" min="380" max="780" value="550" step="10">
                        <span class="viz-slider-val" id="wl-val">550</span>
                    </div>
                </div>

                <div class="control-group" id="nslits-group" style="display:none;">
                    <label>Number of Slits = <span id="ns-display">2</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="ns-slider" min="2" max="100" value="2" step="1">
                        <span class="viz-slider-val" id="ns-val">2</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Show</label>
                    <div style="display:flex;flex-direction:column;gap:6px;">
                        <label class="viz-checkbox"><input type="checkbox" id="show-intensity" checked> Intensity graph</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-color" checked> Wavelength color</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-angles"> Angle markers</label>
                    </div>
                </div>
            </div>

            <div class="viz-values">
                <h3>Properties</h3>
                <table>
                    <tr><td>Mode</td><td id="val-mode">Single Slit</td></tr>
                    <tr><td>Slit Width</td><td id="val-slitwidth">10 &mu;m</td></tr>
                    <tr><td>Separation</td><td id="val-slitsep">25 &mu;m</td></tr>
                    <tr><td>Wavelength</td><td id="val-wavelength">550 nm</td></tr>
                    <tr><td>Central Max</td><td id="val-centralmax">--</td></tr>
                    <tr><td>1st Min Angle</td><td id="val-firstmin">--</td></tr>
                    <tr><td>Fringe Spacing</td><td id="val-fringe">--</td></tr>
                    <tr><td>Resolving Power</td><td id="val-resolving">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Physics Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Diffraction Formulas</h3>
                <ul>
                    <li>Single slit minima: <span class="formula-highlight">a sin&theta; = m&lambda;</span> (m = &plusmn;1, &plusmn;2, &hellip;)</li>
                    <li>Double slit maxima: <span class="formula-highlight">d sin&theta; = m&lambda;</span></li>
                    <li>Single slit intensity: <span class="formula-highlight">I = I&#8320;(sin&beta;/&beta;)&sup2;</span></li>
                    <li>Multi-slit: <span class="formula-highlight">I &prop; (sin(N&delta;/2)/sin(&delta;/2))&sup2;</span></li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Key Concepts</h3>
                <ul>
                    <li><strong>Diffraction</strong> is the bending and spreading of waves around obstacles and through openings</li>
                    <li><strong>Narrower slits</strong> produce wider diffraction patterns because smaller openings cause more spreading</li>
                    <li><strong>Gratings</strong> with many slits produce very sharp, well-defined maxima useful for spectroscopy</li>
                    <li><strong>Young's experiment</strong> (double slit) demonstrated the wave nature of light</li>
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
            <a href="<%=request.getContextPath()%>/exams/visual-physics/snells-law.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(249,115,22,0.12);">&#128269;</div>
                <div><h4>Snell's Law</h4><span>Optics</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/normal-distribution.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#10548;</div>
                <div><h4>Normal Distribution</h4><span>Visual Math</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{"@context":"https://schema.org","@type":"LearningResource","name":"Diffraction Simulator","description":"Interactive diffraction simulator. Visualize single slit, double slit, and diffraction grating patterns with adjustable parameters.","url":"https://8gwifi.org/exams/visual-physics/diffraction.jsp","educationalLevel":"High School","teaches":"Diffraction, single slit, double slit, diffraction grating, intensity pattern, Huygens principle","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Physics","item":"https://8gwifi.org/exams/visual-physics/"},{"@type":"ListItem","position":4,"name":"Diffraction"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"What is the difference between single slit and double slit diffraction?","acceptedAnswer":{"@type":"Answer","text":"Single slit diffraction produces a broad central maximum with progressively weaker side maxima, governed by a sin\u03b8 = m\u03bb. Double slit adds an interference pattern (Young's fringes) modulated by the single slit envelope, with bright fringes at d sin\u03b8 = m\u03bb."}},{"@type":"Question","name":"How does a diffraction grating improve on a double slit?","acceptedAnswer":{"@type":"Answer","text":"A diffraction grating has many equally spaced slits (N >> 2). The principal maxima become much narrower and brighter (intensity \u221d N\u00b2), making them ideal for resolving closely spaced wavelengths in spectroscopy. The more slits, the sharper the spectral lines."}},{"@type":"Question","name":"Why do narrower slits produce wider diffraction patterns?","acceptedAnswer":{"@type":"Answer","text":"The angular position of the first minimum is given by sin\u03b8 = \u03bb/a, where a is the slit width. A narrower slit (smaller a) means a larger angle \u03b8, spreading the diffraction pattern wider. This is a fundamental consequence of the uncertainty principle and Huygens' wavelet model."}}]}
</script>

<%@ include file="vp-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-physics/js/vp-diffraction.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('diffraction', 'viz-canvas', {
        mode: 'single', slitWidth: 10, slitSep: 25, wavelength: 550, numSlits: 2,
        showIntensity: true, showColor: true, showAngles: false
    });
    var state = VisualMath.getState();

    var presets = {
        'single-red': { mode: 'single', sw: 10, ss: 25, wl: 650, ns: 2 },
        'young':      { mode: 'double', sw: 5, ss: 25, wl: 550, ns: 2 },
        'narrow':     { mode: 'single', sw: 3, ss: 25, wl: 550, ns: 2 },
        'grating50':  { mode: 'grating', sw: 5, ss: 20, wl: 550, ns: 50 }
    };

    function syncUI() {
        document.getElementById('sw-slider').value = state.slitWidth;
        document.getElementById('sw-display').textContent = state.slitWidth;
        document.getElementById('sw-val').textContent = state.slitWidth;
        document.getElementById('ss-slider').value = state.slitSep;
        document.getElementById('ss-display').textContent = state.slitSep;
        document.getElementById('ss-val').textContent = state.slitSep;
        document.getElementById('wl-slider').value = state.wavelength;
        document.getElementById('wl-display').textContent = state.wavelength;
        document.getElementById('wl-val').textContent = state.wavelength;
        document.getElementById('ns-slider').value = state.numSlits;
        document.getElementById('ns-display').textContent = state.numSlits;
        document.getElementById('ns-val').textContent = state.numSlits;
        document.getElementById('nslits-group').style.display = state.mode === 'grating' ? '' : 'none';
        document.querySelectorAll('[data-mode]').forEach(function (b) {
            b.classList.toggle('active', b.getAttribute('data-mode') === state.mode);
        });
    }

    document.querySelectorAll('[data-mode]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            state.mode = this.getAttribute('data-mode');
            syncUI(); state._redraw();
        });
    });

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var key = this.getAttribute('data-preset');
            var pr = presets[key]; if (!pr) return;
            state.mode = pr.mode; state.slitWidth = pr.sw;
            state.slitSep = pr.ss; state.wavelength = pr.wl; state.numSlits = pr.ns;
            syncUI(); state._redraw();
        });
    });

    document.getElementById('sw-slider').addEventListener('input', function () {
        state.slitWidth = parseInt(this.value);
        document.getElementById('sw-display').textContent = this.value;
        document.getElementById('sw-val').textContent = this.value;
        state._redraw();
    });
    document.getElementById('ss-slider').addEventListener('input', function () {
        state.slitSep = parseInt(this.value);
        document.getElementById('ss-display').textContent = this.value;
        document.getElementById('ss-val').textContent = this.value;
        state._redraw();
    });
    document.getElementById('wl-slider').addEventListener('input', function () {
        state.wavelength = parseInt(this.value);
        document.getElementById('wl-display').textContent = this.value;
        document.getElementById('wl-val').textContent = this.value;
        state._redraw();
    });
    document.getElementById('ns-slider').addEventListener('input', function () {
        state.numSlits = parseInt(this.value);
        document.getElementById('ns-display').textContent = this.value;
        document.getElementById('ns-val').textContent = this.value;
        state._redraw();
    });

    document.getElementById('show-intensity').addEventListener('change', function () { state.showIntensity = this.checked; state._redraw(); });
    document.getElementById('show-color').addEventListener('change', function () { state.showColor = this.checked; state._redraw(); });
    document.getElementById('show-angles').addEventListener('change', function () { state.showAngles = this.checked; state._redraw(); });
});
</script>
