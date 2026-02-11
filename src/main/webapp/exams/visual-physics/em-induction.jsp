<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "EM Induction Simulator - Faraday's Law, Lenz's Law (Free)";
    String seoDescription = "Interactive electromagnetic induction simulator. Push a magnet through a coil, change magnetic field, or rotate a generator to see Faraday's law and Lenz's law in action.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-physics/em-induction.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"EM Induction Simulator - Faraday's Law, Lenz's Law\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"EM Induction Simulator\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"electromagnetic induction, Faraday's law, Lenz's law, magnetic flux, induced EMF, generator, coil, magnet, physics simulator\">");

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
        <span class="breadcrumb-current">EM Induction</span>
    </nav>

    <div class="viz-header">
        <h1>Electromagnetic Induction</h1>
        <p class="viz-subtitle">Explore Faraday's law of electromagnetic induction. Push a magnet through a coil or spin a generator to see how changing magnetic flux induces an EMF and current.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Induction Parameters</h3>

                <div class="control-group">
                    <label>Mode</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-mode="magnet">Magnet through Coil</button>
                        <button class="vm-chip" data-mode="generator">Generator</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip" data-preset="slow">Slow Push</button>
                        <button class="vm-chip" data-preset="fast">Fast Plunge</button>
                        <button class="vm-chip" data-preset="many">Many Turns</button>
                        <button class="vm-chip" data-preset="generator">Generator</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>Speed = <span id="speed-display">5</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="speed-slider" min="1" max="20" value="5" step="1">
                        <span class="viz-slider-val" id="speed-val">5</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Turns = <span id="turns-display">10</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="turns-slider" min="1" max="50" value="10" step="1">
                        <span class="viz-slider-val" id="turns-val">10</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>B Field = <span id="b-display">0.50</span> T</label>
                    <div class="viz-slider-row">
                        <input type="range" id="b-slider" min="0.1" max="2.0" value="0.5" step="0.1">
                        <span class="viz-slider-val" id="b-val">0.50</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Coil Area = <span id="area-display">0.050</span> m&sup2;</label>
                    <div class="viz-slider-row">
                        <input type="range" id="area-slider" min="0.01" max="0.1" value="0.05" step="0.005">
                        <span class="viz-slider-val" id="area-val">0.050</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Show</label>
                    <div style="display:flex;flex-direction:column;gap:6px;">
                        <label class="viz-checkbox"><input type="checkbox" id="show-flux"> Flux arrows</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-current" checked> Induced current</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-graph"> EMF graph</label>
                    </div>
                </div>

                <div class="viz-btn-row">
                    <button class="viz-btn viz-btn-primary" id="push-btn">Push</button>
                    <button class="viz-btn viz-btn-secondary" id="reset-btn">Reset</button>
                </div>
            </div>

            <div class="viz-values">
                <h3>Properties</h3>
                <table>
                    <tr><td>Mode</td><td id="val-mode">Magnet through Coil</td></tr>
                    <tr><td>B Field</td><td id="val-bfield">0.50 T</td></tr>
                    <tr><td>Turns</td><td id="val-turns">10</td></tr>
                    <tr><td>Area</td><td id="val-area">0.050 m&sup2;</td></tr>
                    <tr><td>Flux (&Phi;)</td><td id="val-flux">--</td></tr>
                    <tr><td>d&Phi;/dt</td><td id="val-dphi">--</td></tr>
                    <tr><td>Induced EMF</td><td id="val-emf">--</td></tr>
                    <tr><td>Current Dir.</td><td id="val-currentdir">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Physics Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Induction Formulas</h3>
                <ul>
                    <li>Magnetic flux: <span class="formula-highlight">&Phi; = BA cos&theta;</span></li>
                    <li>Faraday's law: <span class="formula-highlight">EMF = &minus;N d&Phi;/dt</span></li>
                    <li>Motional EMF: <span class="formula-highlight">EMF = BLv</span></li>
                    <li>Generator EMF: <span class="formula-highlight">EMF = NBA&omega; sin(&omega;t)</span></li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Key Concepts</h3>
                <ul>
                    <li><strong>Faraday's law</strong>: a changing magnetic flux through a loop induces an EMF proportional to the rate of change</li>
                    <li><strong>Lenz's law</strong>: the induced current opposes the change that caused it (hence the minus sign)</li>
                    <li><strong>More turns</strong> amplify the induced EMF linearly</li>
                    <li><strong>Generators</strong> convert mechanical rotation into alternating EMF using electromagnetic induction</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-physics/magnetic-field.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#9883;</div>
                <div><h4>Magnetic Field</h4><span>E&amp;M</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-physics/circuit-builder.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#9889;</div>
                <div><h4>Circuit Builder</h4><span>E&amp;M</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/derivative.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#10548;</div>
                <div><h4>Derivative</h4><span>Visual Math</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{"@context":"https://schema.org","@type":"LearningResource","name":"EM Induction Simulator","description":"Interactive electromagnetic induction simulator demonstrating Faraday's law and Lenz's law.","url":"https://8gwifi.org/exams/visual-physics/em-induction.jsp","educationalLevel":"High School","teaches":"Electromagnetic induction, Faraday's law, Lenz's law, magnetic flux, EMF, generator","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Physics","item":"https://8gwifi.org/exams/visual-physics/"},{"@type":"ListItem","position":4,"name":"EM Induction"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"What is Faraday's law of electromagnetic induction?","acceptedAnswer":{"@type":"Answer","text":"Faraday's law states that the induced EMF in a circuit equals the negative rate of change of magnetic flux through the circuit: EMF = \u2212N d\u03a6/dt. The faster the flux changes (faster magnet motion, more turns, stronger field), the greater the induced voltage."}},{"@type":"Question","name":"What is Lenz's law?","acceptedAnswer":{"@type":"Answer","text":"Lenz's law states that the direction of the induced current is such that it opposes the change in magnetic flux that produced it. If you push a north pole toward a coil, the induced current creates a north pole facing the magnet to repel it. This is energy conservation in action."}},{"@type":"Question","name":"How does a generator work?","acceptedAnswer":{"@type":"Answer","text":"A generator converts mechanical energy to electrical energy by rotating a coil in a magnetic field. As the coil rotates, the magnetic flux through it changes sinusoidally, inducing an alternating EMF: EMF = NBA\u03c9 sin(\u03c9t). This is the basis of AC power generation."}}]}
</script>

<%@ include file="vp-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-physics/js/vp-em-induction.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('em-induction', 'viz-canvas', {
        mode: 'magnet', magnetSpeed: 5, turns: 10, coilArea: 0.05, bField: 0.5,
        showFlux: false, showCurrent: true, showGraph: false
    });
    var state = VisualMath.getState();

    var presets = {
        'slow':      { mode: 'magnet', speed: 3, turns: 10, b: 0.5, area: 0.05 },
        'fast':      { mode: 'magnet', speed: 18, turns: 10, b: 0.5, area: 0.05 },
        'many':      { mode: 'magnet', speed: 5, turns: 40, b: 0.5, area: 0.05 },
        'generator': { mode: 'generator', speed: 5, turns: 20, b: 1.0, area: 0.05 }
    };

    function syncUI() {
        document.getElementById('speed-slider').value = state.magnetSpeed;
        document.getElementById('speed-display').textContent = state.magnetSpeed;
        document.getElementById('speed-val').textContent = state.magnetSpeed;
        document.getElementById('turns-slider').value = state.turns;
        document.getElementById('turns-display').textContent = state.turns;
        document.getElementById('turns-val').textContent = state.turns;
        document.getElementById('b-slider').value = state.bField;
        document.getElementById('b-display').textContent = state.bField.toFixed(2);
        document.getElementById('b-val').textContent = state.bField.toFixed(2);
        document.getElementById('area-slider').value = state.coilArea;
        document.getElementById('area-display').textContent = state.coilArea.toFixed(3);
        document.getElementById('area-val').textContent = state.coilArea.toFixed(3);
        document.querySelectorAll('[data-mode]').forEach(function (b) {
            b.classList.toggle('active', b.getAttribute('data-mode') === state.mode);
        });
    }

    document.querySelectorAll('[data-mode]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            state.mode = this.getAttribute('data-mode');
            syncUI(); state._reset(); state._redraw();
        });
    });

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var key = this.getAttribute('data-preset');
            var pr = presets[key]; if (!pr) return;
            state.mode = pr.mode; state.magnetSpeed = pr.speed;
            state.turns = pr.turns; state.bField = pr.b; state.coilArea = pr.area;
            syncUI(); state._reset();
            if (pr.mode === 'generator') state._play();
        });
    });

    document.getElementById('speed-slider').addEventListener('input', function () {
        state.magnetSpeed = parseInt(this.value);
        document.getElementById('speed-display').textContent = this.value;
        document.getElementById('speed-val').textContent = this.value;
    });
    document.getElementById('turns-slider').addEventListener('input', function () {
        state.turns = parseInt(this.value);
        document.getElementById('turns-display').textContent = this.value;
        document.getElementById('turns-val').textContent = this.value;
        state._redraw();
    });
    document.getElementById('b-slider').addEventListener('input', function () {
        state.bField = parseFloat(this.value);
        document.getElementById('b-display').textContent = parseFloat(this.value).toFixed(2);
        document.getElementById('b-val').textContent = parseFloat(this.value).toFixed(2);
        state._redraw();
    });
    document.getElementById('area-slider').addEventListener('input', function () {
        state.coilArea = parseFloat(this.value);
        document.getElementById('area-display').textContent = parseFloat(this.value).toFixed(3);
        document.getElementById('area-val').textContent = parseFloat(this.value).toFixed(3);
        state._redraw();
    });

    document.getElementById('show-flux').addEventListener('change', function () { state.showFlux = this.checked; state._redraw(); });
    document.getElementById('show-current').addEventListener('change', function () { state.showCurrent = this.checked; state._redraw(); });
    document.getElementById('show-graph').addEventListener('change', function () { state.showGraph = this.checked; state._redraw(); });

    document.getElementById('push-btn').addEventListener('click', function () {
        if (state.mode === 'generator') { state._play(); }
        else { state._push(); }
    });
    document.getElementById('reset-btn').addEventListener('click', function () { state._reset(); });
});
</script>
