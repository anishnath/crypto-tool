<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Ideal Gas Law Simulator - PV Diagram, Thermodynamics (Free)";
    String seoDescription = "Interactive ideal gas law simulator. Explore isothermal, adiabatic, isobaric, and isochoric processes with PV diagrams. See work, heat, and internal energy changes in real time.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-physics/ideal-gas.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Ideal Gas Law Simulator - PV Diagram, Thermodynamics\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Ideal Gas Law Simulator\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"ideal gas law, PV diagram, isothermal, adiabatic, isobaric, isochoric, thermodynamics, first law, work, heat, physics simulator\">");

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
        <span class="breadcrumb-current">Ideal Gas Law</span>
    </nav>

    <div class="viz-header">
        <h1>Ideal Gas Law / PV Diagram</h1>
        <p class="viz-subtitle">Explore thermodynamic processes on a PV diagram. Switch between isothermal, adiabatic, isobaric, and isochoric processes to see how pressure, volume, and temperature change.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Gas Parameters</h3>

                <div class="control-group">
                    <label>Process</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-process="isothermal">Isothermal</button>
                        <button class="vm-chip" data-process="adiabatic">Adiabatic</button>
                        <button class="vm-chip" data-process="isobaric">Isobaric</button>
                        <button class="vm-chip" data-process="isochoric">Isochoric</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip" data-preset="iso-expand">Isothermal Expand</button>
                        <button class="vm-chip" data-preset="adi-compress">Adiabatic Compress</button>
                        <button class="vm-chip" data-preset="isobar-heat">Isobaric Heating</button>
                        <button class="vm-chip" data-preset="carnot">Carnot Cycle</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>Moles = <span id="n-display">1.0</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="n-slider" min="0.5" max="5" value="1" step="0.5">
                        <span class="viz-slider-val" id="n-val">1.0</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Temperature = <span id="temp-display">300</span> K</label>
                    <div class="viz-slider-row">
                        <input type="range" id="temp-slider" min="200" max="600" value="300" step="10">
                        <span class="viz-slider-val" id="temp-val">300</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Pressure = <span id="press-display">100</span> kPa</label>
                    <div class="viz-slider-row">
                        <input type="range" id="press-slider" min="50" max="500" value="100" step="10">
                        <span class="viz-slider-val" id="press-val">100</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Volume Ratio = <span id="vr-display">2.0</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="vr-slider" min="0.5" max="3.0" value="2.0" step="0.1">
                        <span class="viz-slider-val" id="vr-val">2.0</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Show</label>
                    <div style="display:flex;flex-direction:column;gap:6px;">
                        <label class="viz-checkbox"><input type="checkbox" id="show-molecules"> Molecular animation</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-work" checked> Work area shading</label>
                    </div>
                </div>

                <div class="viz-btn-row">
                    <button class="viz-btn viz-btn-primary" id="run-btn">Run</button>
                    <button class="viz-btn viz-btn-secondary" id="reset-btn">Reset</button>
                </div>
            </div>

            <div class="viz-values">
                <h3>Properties</h3>
                <table>
                    <tr><td>Process</td><td id="val-process">Isothermal</td></tr>
                    <tr><td>n</td><td id="val-n">1.0 mol</td></tr>
                    <tr><td>T (init)</td><td id="val-tinit">300 K</td></tr>
                    <tr><td>T (final)</td><td id="val-tfinal">--</td></tr>
                    <tr><td>P (init)</td><td id="val-pinit">100 kPa</td></tr>
                    <tr><td>P (final)</td><td id="val-pfinal">--</td></tr>
                    <tr><td>V (init)</td><td id="val-vinit">--</td></tr>
                    <tr><td>V (final)</td><td id="val-vfinal">--</td></tr>
                    <tr><td>Work</td><td id="val-work">--</td></tr>
                    <tr><td>Heat</td><td id="val-heat">--</td></tr>
                    <tr><td>&Delta;U</td><td id="val-du">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Physics Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Thermodynamic Formulas</h3>
                <ul>
                    <li>Ideal gas law: <span class="formula-highlight">PV = nRT</span></li>
                    <li>Isothermal work: <span class="formula-highlight">W = nRT ln(V&#8322;/V&#8321;)</span></li>
                    <li>Adiabatic: <span class="formula-highlight">PV&#7508; = const</span></li>
                    <li>First law: <span class="formula-highlight">&Delta;U = Q &minus; W</span></li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Key Concepts</h3>
                <ul>
                    <li><strong>Isothermal</strong>: constant temperature; gas exchanges heat with a reservoir</li>
                    <li><strong>Adiabatic</strong>: no heat exchange; temperature changes during compression/expansion</li>
                    <li><strong>Isobaric</strong>: constant pressure; volume and temperature change proportionally</li>
                    <li><strong>Isochoric</strong>: constant volume; pressure and temperature change proportionally</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-physics/pendulum-shm.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(239,68,68,0.12);">&#9201;</div>
                <div><h4>Pendulum & SHM</h4><span>Mechanics</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-physics/photoelectric-effect.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(168,85,247,0.12);">&#9889;</div>
                <div><h4>Photoelectric Effect</h4><span>Modern Physics</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/function-plotter.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#10548;</div>
                <div><h4>Function Plotter</h4><span>Visual Math</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{"@context":"https://schema.org","@type":"LearningResource","name":"Ideal Gas Law Simulator","description":"Interactive ideal gas law simulator with PV diagrams for isothermal, adiabatic, isobaric, and isochoric processes.","url":"https://8gwifi.org/exams/visual-physics/ideal-gas.jsp","educationalLevel":"High School","teaches":"Ideal gas law, PV diagram, thermodynamic processes, work, heat, first law of thermodynamics","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Physics","item":"https://8gwifi.org/exams/visual-physics/"},{"@type":"ListItem","position":4,"name":"Ideal Gas Law"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"What is the ideal gas law?","acceptedAnswer":{"@type":"Answer","text":"The ideal gas law PV = nRT relates pressure (P), volume (V), temperature (T), and amount of gas (n moles) through the universal gas constant R = 8.314 J/(mol\u00b7K). It accurately describes the behaviour of gases at low pressure and high temperature."}},{"@type":"Question","name":"What is the difference between isothermal and adiabatic processes?","acceptedAnswer":{"@type":"Answer","text":"In an isothermal process, temperature is constant and heat flows between the gas and its surroundings. In an adiabatic process, no heat is exchanged (Q=0), so the temperature changes: the gas cools during expansion and heats during compression. Adiabatic curves are steeper than isothermal curves on a PV diagram."}},{"@type":"Question","name":"What does the area under a PV curve represent?","acceptedAnswer":{"@type":"Answer","text":"The area under the curve on a PV diagram equals the work done by the gas during the process. For expansion (V increases), work is positive (gas does work on surroundings). For compression (V decreases), work is negative (surroundings do work on gas). Isochoric processes have zero work since volume doesn't change."}}]}
</script>

<%@ include file="vp-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-physics/js/vp-ideal-gas.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('ideal-gas', 'viz-canvas', {
        process: 'isothermal', moles: 1, tempInit: 300, pressureInit: 100, volRatio: 2.0,
        showMolecules: false, showWork: true
    });
    var state = VisualMath.getState();

    var presets = {
        'iso-expand':   { proc: 'isothermal', n: 1, T: 300, P: 100, vr: 2.0 },
        'adi-compress': { proc: 'adiabatic', n: 1, T: 300, P: 100, vr: 0.5 },
        'isobar-heat':  { proc: 'isobaric', n: 1, T: 300, P: 100, vr: 2.0 },
        'carnot':       { proc: 'isothermal', n: 1, T: 400, P: 200, vr: 2.0 }
    };

    function syncUI() {
        document.getElementById('n-slider').value = state.moles;
        document.getElementById('n-display').textContent = state.moles.toFixed(1);
        document.getElementById('n-val').textContent = state.moles.toFixed(1);
        document.getElementById('temp-slider').value = state.tempInit;
        document.getElementById('temp-display').textContent = state.tempInit;
        document.getElementById('temp-val').textContent = state.tempInit;
        document.getElementById('press-slider').value = state.pressureInit;
        document.getElementById('press-display').textContent = state.pressureInit;
        document.getElementById('press-val').textContent = state.pressureInit;
        document.getElementById('vr-slider').value = state.volRatio;
        document.getElementById('vr-display').textContent = state.volRatio.toFixed(1);
        document.getElementById('vr-val').textContent = state.volRatio.toFixed(1);
        document.querySelectorAll('[data-process]').forEach(function (b) {
            b.classList.toggle('active', b.getAttribute('data-process') === state.process);
        });
    }

    document.querySelectorAll('[data-process]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            state.process = this.getAttribute('data-process');
            syncUI(); state._reset(); state._redraw();
        });
    });

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var key = this.getAttribute('data-preset');
            var pr = presets[key]; if (!pr) return;
            state.process = pr.proc; state.moles = pr.n; state.tempInit = pr.T;
            state.pressureInit = pr.P; state.volRatio = pr.vr;
            syncUI(); state._reset(); state._redraw();
        });
    });

    document.getElementById('n-slider').addEventListener('input', function () {
        state.moles = parseFloat(this.value);
        document.getElementById('n-display').textContent = parseFloat(this.value).toFixed(1);
        document.getElementById('n-val').textContent = parseFloat(this.value).toFixed(1);
        state._reset(); state._redraw();
    });
    document.getElementById('temp-slider').addEventListener('input', function () {
        state.tempInit = parseInt(this.value);
        document.getElementById('temp-display').textContent = this.value;
        document.getElementById('temp-val').textContent = this.value;
        state._reset(); state._redraw();
    });
    document.getElementById('press-slider').addEventListener('input', function () {
        state.pressureInit = parseInt(this.value);
        document.getElementById('press-display').textContent = this.value;
        document.getElementById('press-val').textContent = this.value;
        state._reset(); state._redraw();
    });
    document.getElementById('vr-slider').addEventListener('input', function () {
        state.volRatio = parseFloat(this.value);
        document.getElementById('vr-display').textContent = parseFloat(this.value).toFixed(1);
        document.getElementById('vr-val').textContent = parseFloat(this.value).toFixed(1);
        state._reset(); state._redraw();
    });

    document.getElementById('show-molecules').addEventListener('change', function () { state.showMolecules = this.checked; state._redraw(); });
    document.getElementById('show-work').addEventListener('change', function () { state.showWork = this.checked; state._redraw(); });

    document.getElementById('run-btn').addEventListener('click', function () { state._run(); });
    document.getElementById('reset-btn').addEventListener('click', function () { state._reset(); });
});
</script>
