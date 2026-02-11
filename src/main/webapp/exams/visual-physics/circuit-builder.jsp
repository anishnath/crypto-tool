<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Circuit Simulator - Ohm's Law, Series & Parallel Circuits (Free)";
    String seoDescription = "Interactive circuit simulator with Ohm's Law. Build single, series, and parallel resistor circuits. Adjust voltage and resistance to see current flow, voltage drops, and power in real time.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-physics/circuit-builder.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Circuit Simulator - Ohm's Law, Series & Parallel Circuits\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Circuit Simulator - Ohm's Law\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"circuit simulator, Ohm's law, series circuit, parallel circuit, voltage divider, resistor calculator, current flow, voltage drop, Kirchhoff's law, electric circuit, physics simulator\">");

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
        <span class="breadcrumb-current">Circuit Simulator</span>
    </nav>

    <div class="viz-header">
        <h1>Circuit Simulator</h1>
        <p class="viz-subtitle">Explore Ohm's Law with interactive series and parallel resistor circuits. Adjust voltage and resistance to see current, voltage drops, and power update live.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Circuit Configuration</h3>

                <div class="control-group">
                    <label>Circuit Type</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-circuit="single">Single R</button>
                        <button class="vm-chip" data-circuit="series2">Series 2R</button>
                        <button class="vm-chip" data-circuit="series3">Series 3R</button>
                        <button class="vm-chip" data-circuit="parallel2">Parallel 2R</button>
                        <button class="vm-chip" data-circuit="combo">Combo</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>Voltage V = <span id="v-display">12.0</span> V</label>
                    <div class="viz-slider-row">
                        <input type="range" id="v-slider" min="1" max="24" value="12" step="0.5">
                        <span class="viz-slider-val" id="v-val">12.0</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>R&#8321; = <span id="r1-display">10</span> &#8486;</label>
                    <div class="viz-slider-row">
                        <input type="range" id="r1-slider" min="1" max="100" value="10" step="1">
                        <span class="viz-slider-val" id="r1-val">10</span>
                    </div>
                </div>

                <div class="control-group" id="r2-group" style="display:none;">
                    <label>R&#8322; = <span id="r2-display">20</span> &#8486;</label>
                    <div class="viz-slider-row">
                        <input type="range" id="r2-slider" min="1" max="100" value="20" step="1">
                        <span class="viz-slider-val" id="r2-val">20</span>
                    </div>
                </div>

                <div class="control-group" id="r3-group" style="display:none;">
                    <label>R&#8323; = <span id="r3-display">30</span> &#8486;</label>
                    <div class="viz-slider-row">
                        <input type="range" id="r3-slider" min="1" max="100" value="30" step="1">
                        <span class="viz-slider-val" id="r3-val">30</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Show</label>
                    <div class="viz-check-group">
                        <label class="viz-check"><input type="checkbox" id="show-animation" checked> Current Animation</label>
                        <label class="viz-check"><input type="checkbox" id="show-vdrops" checked> Voltage Drops</label>
                    </div>
                </div>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip" data-preset="led">LED Circuit</button>
                        <button class="vm-chip" data-preset="flashlight">Flashlight</button>
                        <button class="vm-chip" data-preset="divider">Voltage Divider</button>
                    </div>
                </div>
            </div>

            <div class="viz-values">
                <h3>Measurements</h3>
                <table>
                    <tr><td>V source</td><td id="val-vsource">--</td></tr>
                    <tr><td>R total</td><td id="val-rtotal">--</td></tr>
                    <tr><td>I total</td><td id="val-itotal">--</td></tr>
                    <tr><td>V across R&#8321;</td><td id="val-vr1">--</td></tr>
                    <tr><td>V across R&#8322;</td><td id="val-vr2">--</td></tr>
                    <tr><td>V across R&#8323;</td><td id="val-vr3">--</td></tr>
                    <tr><td>Power</td><td id="val-ptotal">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Math Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Ohm's Law</h3>
                <ul>
                    <li>Voltage = Current &times; Resistance: <span class="formula-highlight">V = I R</span></li>
                    <li>Current: <span class="formula-highlight">I = V / R</span></li>
                    <li>Resistance: <span class="formula-highlight">R = V / I</span></li>
                </ul>
                <h3 style="margin-top:var(--space-4);">Series Circuits</h3>
                <ul>
                    <li>Total resistance: <span class="formula-highlight">R = R&#8321; + R&#8322; + ...</span></li>
                    <li>Same current flows through all resistors</li>
                    <li>Voltage divides across each resistor proportionally</li>
                </ul>
                <h3 style="margin-top:var(--space-4);">Power</h3>
                <ul>
                    <li><span class="formula-highlight">P = V I = I&sup2;R = V&sup2;/R</span></li>
                    <li>Measured in Watts (W)</li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Parallel Circuits</h3>
                <ul>
                    <li>Total resistance: <span class="formula-highlight">1/R = 1/R&#8321; + 1/R&#8322; + ...</span></li>
                    <li>Same voltage across all branches</li>
                    <li>Current divides among branches</li>
                    <li>Total resistance is always less than the smallest resistor</li>
                </ul>
                <h3 style="margin-top:var(--space-4);">Kirchhoff's Voltage Law</h3>
                <ul>
                    <li>The sum of all voltage drops around a closed loop equals zero</li>
                    <li><span class="formula-highlight">&Sigma;V = 0</span> around any loop</li>
                    <li>V<sub>source</sub> = V<sub>R1</sub> + V<sub>R2</sub> + ... (series)</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-physics/electric-field.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(251,191,36,0.12);">&#9889;</div>
                <div><h4>Electric Field</h4><span>Physics</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-physics/pendulum-shm.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(168,85,247,0.12);">&#128344;</div>
                <div><h4>Pendulum &amp; SHM</h4><span>Physics</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/linear-equation.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#9135;</div>
                <div><h4>Linear Equation</h4><span>Visual Math</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{"@context":"https://schema.org","@type":"LearningResource","name":"Circuit Simulator - Ohm's Law","description":"Interactive circuit simulator for exploring Ohm's Law with series and parallel resistor circuits, voltage drops, current flow animation, and power calculations.","url":"https://8gwifi.org/exams/visual-physics/circuit-builder.jsp","educationalLevel":"High School","teaches":"Ohm's Law, series circuits, parallel circuits, voltage dividers, Kirchhoff's voltage law, electric power","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Physics Lab","item":"https://8gwifi.org/exams/visual-physics/"},{"@type":"ListItem","position":4,"name":"Circuit Simulator"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"What is Ohm's Law and how does it work?","acceptedAnswer":{"@type":"Answer","text":"Ohm's Law states that voltage (V) equals current (I) multiplied by resistance (R): V = IR. It means the current through a conductor is directly proportional to the voltage across it and inversely proportional to its resistance. Double the voltage and current doubles; double the resistance and current halves."}},{"@type":"Question","name":"What is the difference between series and parallel circuits?","acceptedAnswer":{"@type":"Answer","text":"In a series circuit, resistors are connected end-to-end so the same current flows through all of them and the total resistance is the sum of individual resistances (R = R1 + R2 + ...). In a parallel circuit, resistors are connected across the same two nodes so they share the same voltage, and the total resistance is found by 1/R = 1/R1 + 1/R2 + ..., which is always less than the smallest individual resistor."}},{"@type":"Question","name":"What is Kirchhoff's Voltage Law?","acceptedAnswer":{"@type":"Answer","text":"Kirchhoff's Voltage Law (KVL) states that the sum of all voltage differences around any closed loop in a circuit equals zero. In practice this means the voltage supplied by the source equals the sum of all voltage drops across the resistors in a series loop: V_source = V_R1 + V_R2 + V_R3."}}]}
</script>

<%@ include file="vp-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-physics/js/vp-circuit.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('circuit-builder', 'viz-canvas', {
        circuitType: 'single',
        voltage: 12,
        r1: 10,
        r2: 20,
        r3: 30,
        showAnimation: true,
        showVdrops: true
    });
    var state = VisualMath.getState();

    /* --- helpers --- */
    var typesWithR2 = { series2: true, series3: true, parallel2: true, combo: true };
    var typesWithR3 = { series3: true, combo: true };

    function updateSliderVisibility(type) {
        document.getElementById('r2-group').style.display = typesWithR2[type] ? '' : 'none';
        document.getElementById('r3-group').style.display = typesWithR3[type] ? '' : 'none';
    }

    function setSlider(id, val) {
        var el = document.getElementById(id + '-slider');
        el.value = val;
        var formatted = (parseFloat(val) % 1 === 0) ? parseInt(val, 10) : parseFloat(val).toFixed(1);
        var display = document.getElementById(id + '-display');
        var valSpan = document.getElementById(id + '-val');
        if (display) display.textContent = formatted;
        if (valSpan) valSpan.textContent = formatted;
    }

    function activateCircuitChip(type) {
        document.querySelectorAll('[data-circuit]').forEach(function (btn) {
            btn.classList.toggle('active', btn.getAttribute('data-circuit') === type);
        });
    }

    function clearPresetChips() {
        document.querySelectorAll('[data-preset]').forEach(function (btn) {
            btn.classList.remove('active');
        });
    }

    /* --- circuit type chips --- */
    document.querySelectorAll('[data-circuit]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var type = this.getAttribute('data-circuit');
            state.circuitType = type;
            activateCircuitChip(type);
            updateSliderVisibility(type);
            clearPresetChips();
            state._redraw();
        });
    });

    /* --- sliders --- */
    function bindSlider(id, prop, decimals) {
        document.getElementById(id + '-slider').addEventListener('input', function () {
            var v = parseFloat(this.value);
            state[prop] = v;
            var formatted = decimals ? v.toFixed(1) : parseInt(v, 10);
            var display = document.getElementById(id + '-display');
            var valSpan = document.getElementById(id + '-val');
            if (display) display.textContent = formatted;
            if (valSpan) valSpan.textContent = formatted;
            clearPresetChips();
            state._redraw();
        });
    }
    bindSlider('v', 'voltage', true);
    bindSlider('r1', 'r1', false);
    bindSlider('r2', 'r2', false);
    bindSlider('r3', 'r3', false);

    /* --- checkboxes --- */
    document.getElementById('show-animation').addEventListener('change', function () {
        state.showAnimation = this.checked;
    });
    document.getElementById('show-vdrops').addEventListener('change', function () {
        state.showVdrops = this.checked;
        state._redraw();
    });

    /* --- presets --- */
    var presets = {
        led:        { circuit: 'single',  v: 2,  r1: 330 },
        flashlight: { circuit: 'single',  v: 3,  r1: 5 },
        divider:    { circuit: 'series2', v: 12, r1: 10, r2: 10 }
    };

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var key = this.getAttribute('data-preset');
            var p = presets[key];
            if (!p) return;

            state.circuitType = p.circuit;
            state.voltage = p.v;
            state.r1 = p.r1;
            if (p.r2 !== undefined) state.r2 = p.r2;
            if (p.r3 !== undefined) state.r3 = p.r3;

            activateCircuitChip(p.circuit);
            updateSliderVisibility(p.circuit);
            setSlider('v', p.v);
            setSlider('r1', p.r1);
            if (p.r2 !== undefined) setSlider('r2', p.r2);
            if (p.r3 !== undefined) setSlider('r3', p.r3);

            document.querySelectorAll('[data-preset]').forEach(function (b) {
                b.classList.toggle('active', b.getAttribute('data-preset') === key);
            });

            state._redraw();
        });
    });

    /* --- initial visibility --- */
    updateSliderVisibility(state.circuitType);
});
</script>
