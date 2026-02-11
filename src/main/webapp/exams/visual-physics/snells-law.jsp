<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Snell's Law Simulator - Refraction, TIR, Critical Angle (Free)";
    String seoDescription = "Interactive Snell's Law simulator. Adjust incident angle and refractive indices to visualize refraction, total internal reflection, and critical angle in real time.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-physics/snells-law.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Snell's Law Simulator - Refraction, TIR, Critical Angle\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Snell's Law Simulator\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"snell's law, refraction simulator, total internal reflection, TIR, critical angle, refractive index, optics, physics simulator\">");

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
        <span class="breadcrumb-current">Snell's Law</span>
    </nav>

    <div class="viz-header">
        <h1>Snell's Law / Refraction Simulator</h1>
        <p class="viz-subtitle">Explore how light bends at the interface between two media. Adjust the incident angle and refractive indices to see refraction, total internal reflection, and the critical angle.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Refraction Parameters</h3>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-preset="air-glass">Air &rarr; Glass</button>
                        <button class="vm-chip" data-preset="tir">Total Internal Reflection</button>
                        <button class="vm-chip" data-preset="critical">At Critical Angle</button>
                        <button class="vm-chip" data-preset="diamond">Diamond (Grazing)</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>Incident Angle = <span id="angle-display">30</span>&deg;</label>
                    <div class="viz-slider-row">
                        <input type="range" id="angle-slider" min="0" max="89" value="30" step="1">
                        <span class="viz-slider-val" id="angle-val">30</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>n&#8321; = <span id="n1-display">1.00</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="n1-slider" min="1.0" max="2.5" value="1.0" step="0.01">
                        <span class="viz-slider-val" id="n1-val">1.00</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>n&#8322; = <span id="n2-display">1.50</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="n2-slider" min="1.0" max="2.5" value="1.5" step="0.01">
                        <span class="viz-slider-val" id="n2-val">1.50</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Materials</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip" data-material="air-glass" data-n1="1.00" data-n2="1.52">Air/Glass</button>
                        <button class="vm-chip" data-material="air-water" data-n1="1.00" data-n2="1.33">Air/Water</button>
                        <button class="vm-chip" data-material="water-glass" data-n1="1.33" data-n2="1.52">Water/Glass</button>
                        <button class="vm-chip" data-material="glass-diamond" data-n1="1.52" data-n2="2.42">Glass/Diamond</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>Show</label>
                    <div style="display:flex;flex-direction:column;gap:6px;">
                        <label class="viz-checkbox"><input type="checkbox" id="show-normal" checked> Normal line</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-reflected" checked> Reflected ray</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-labels" checked> Angle labels</label>
                    </div>
                </div>
            </div>

            <div class="viz-values">
                <h3>Properties</h3>
                <table>
                    <tr><td>Incident Angle</td><td id="val-incident">30&deg;</td></tr>
                    <tr><td>n&#8321;</td><td id="val-n1">1.00</td></tr>
                    <tr><td>n&#8322;</td><td id="val-n2">1.50</td></tr>
                    <tr><td>Refracted Angle</td><td id="val-refracted">--</td></tr>
                    <tr><td>Critical Angle</td><td id="val-critical">--</td></tr>
                    <tr><td>TIR?</td><td id="val-tir">--</td></tr>
                    <tr><td>Speed Ratio</td><td id="val-speedratio">--</td></tr>
                    <tr><td>n&#8321;sin&#952;&#8321;</td><td id="val-snell">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Physics Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Snell's Law</h3>
                <ul>
                    <li>Snell's Law: <span class="formula-highlight">n&#8321; sin&theta;&#8321; = n&#8322; sin&theta;&#8322;</span></li>
                    <li>Critical angle: <span class="formula-highlight">&theta;c = arcsin(n&#8322;/n&#8321;)</span> when n&#8321; &gt; n&#8322;</li>
                    <li>Total internal reflection occurs when <span class="formula-highlight">&theta; &gt; &theta;c</span> and light goes from denser to rarer medium</li>
                    <li>Speed in medium: <span class="formula-highlight">v = c/n</span></li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Key Concepts</h3>
                <ul>
                    <li><strong>Refraction</strong> is the bending of light as it passes from one medium to another due to a change in speed</li>
                    <li><strong>Refractive index</strong> (n) measures how much slower light travels in a medium compared to vacuum</li>
                    <li><strong>Total internal reflection</strong> occurs when light hits a boundary at an angle greater than the critical angle, from a denser to a rarer medium</li>
                    <li><strong>Applications</strong> include fiber optics, prisms, lenses, and diamond sparkle</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-physics/lens-ray-diagram.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(249,115,22,0.12);">&#128269;</div>
                <div><h4>Lens Ray Diagram</h4><span>Optics</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-physics/diffraction.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(249,115,22,0.12);">&#127752;</div>
                <div><h4>Diffraction Patterns</h4><span>Optics</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/trig-graphs.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#10548;</div>
                <div><h4>Trig Graphs</h4><span>Visual Math</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{"@context":"https://schema.org","@type":"LearningResource","name":"Snell's Law Simulator","description":"Interactive Snell's Law simulator. Adjust incident angle and refractive indices to visualize refraction, total internal reflection, and critical angle in real time.","url":"https://8gwifi.org/exams/visual-physics/snells-law.jsp","educationalLevel":"High School","teaches":"Snell's law, refraction, total internal reflection, critical angle, refractive index, optics","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Physics","item":"https://8gwifi.org/exams/visual-physics/"},{"@type":"ListItem","position":4,"name":"Snell's Law"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"What is Snell's Law?","acceptedAnswer":{"@type":"Answer","text":"Snell's Law describes how light bends when it passes from one medium to another. It states n\u2081 sin\u03b8\u2081 = n\u2082 sin\u03b8\u2082, where n\u2081 and n\u2082 are the refractive indices and \u03b8\u2081, \u03b8\u2082 are the angles of incidence and refraction measured from the normal."}},{"@type":"Question","name":"What is total internal reflection?","acceptedAnswer":{"@type":"Answer","text":"Total internal reflection (TIR) occurs when light travelling in a denser medium hits the boundary with a less dense medium at an angle greater than the critical angle. Instead of refracting, all the light is reflected back into the denser medium. This principle is used in fiber optics and makes diamonds sparkle."}},{"@type":"Question","name":"How do you calculate the critical angle?","acceptedAnswer":{"@type":"Answer","text":"The critical angle is calculated using \u03b8c = arcsin(n\u2082/n\u2081), where n\u2081 is the refractive index of the denser medium and n\u2082 is that of the less dense medium. For glass (n=1.5) to air (n=1.0), the critical angle is about 41.8\u00b0."}}]}
</script>

<%@ include file="vp-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-physics/js/vp-snells-law.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('snells-law', 'viz-canvas', {
        incidentAngle: 30,
        n1: 1.0,
        n2: 1.5,
        showNormal: true,
        showReflected: true,
        showLabels: true
    });
    var state = VisualMath.getState();

    var presets = {
        'air-glass': { angle: 40, n1: 1.0, n2: 1.52 },
        'tir':       { angle: 50, n1: 1.5, n2: 1.0 },
        'critical':  { angle: 42, n1: 1.5, n2: 1.0 },
        'diamond':   { angle: 80, n1: 2.42, n2: 1.0 }
    };

    function syncUI() {
        document.getElementById('angle-slider').value = state.incidentAngle;
        document.getElementById('angle-display').textContent = state.incidentAngle;
        document.getElementById('angle-val').textContent = state.incidentAngle;
        document.getElementById('n1-slider').value = state.n1;
        document.getElementById('n1-display').textContent = state.n1.toFixed(2);
        document.getElementById('n1-val').textContent = state.n1.toFixed(2);
        document.getElementById('n2-slider').value = state.n2;
        document.getElementById('n2-display').textContent = state.n2.toFixed(2);
        document.getElementById('n2-val').textContent = state.n2.toFixed(2);
    }

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var key = this.getAttribute('data-preset');
            var pr = presets[key];
            if (!pr) return;
            state.incidentAngle = pr.angle;
            state.n1 = pr.n1;
            state.n2 = pr.n2;
            syncUI();
            document.querySelectorAll('[data-preset]').forEach(function (b) {
                b.classList.toggle('active', b.getAttribute('data-preset') === key);
            });
            state._redraw();
        });
    });

    document.querySelectorAll('[data-material]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            state.n1 = parseFloat(this.getAttribute('data-n1'));
            state.n2 = parseFloat(this.getAttribute('data-n2'));
            syncUI();
            state._redraw();
        });
    });

    document.getElementById('angle-slider').addEventListener('input', function () {
        state.incidentAngle = parseInt(this.value);
        document.getElementById('angle-display').textContent = this.value;
        document.getElementById('angle-val').textContent = this.value;
        document.querySelectorAll('[data-preset]').forEach(function (b) { b.classList.remove('active'); });
        state._redraw();
    });

    document.getElementById('n1-slider').addEventListener('input', function () {
        state.n1 = parseFloat(this.value);
        document.getElementById('n1-display').textContent = parseFloat(this.value).toFixed(2);
        document.getElementById('n1-val').textContent = parseFloat(this.value).toFixed(2);
        document.querySelectorAll('[data-preset]').forEach(function (b) { b.classList.remove('active'); });
        state._redraw();
    });

    document.getElementById('n2-slider').addEventListener('input', function () {
        state.n2 = parseFloat(this.value);
        document.getElementById('n2-display').textContent = parseFloat(this.value).toFixed(2);
        document.getElementById('n2-val').textContent = parseFloat(this.value).toFixed(2);
        document.querySelectorAll('[data-preset]').forEach(function (b) { b.classList.remove('active'); });
        state._redraw();
    });

    document.getElementById('show-normal').addEventListener('change', function () {
        state.showNormal = this.checked; state._redraw();
    });
    document.getElementById('show-reflected').addEventListener('change', function () {
        state.showReflected = this.checked; state._redraw();
    });
    document.getElementById('show-labels').addEventListener('change', function () {
        state.showLabels = this.checked; state._redraw();
    });
});
</script>
