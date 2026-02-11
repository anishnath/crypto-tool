<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Magnetic Field Visualizer - Bar Magnet, Wire, Solenoid (Free)";
    String seoDescription = "Interactive magnetic field visualizer. See field lines, compass needles, and iron filing patterns for bar magnets, straight wires, wire loops, and solenoids.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-physics/magnetic-field.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Magnetic Field Visualizer - Bar Magnet, Wire, Solenoid\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Magnetic Field Visualizer\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"magnetic field, bar magnet, solenoid, wire magnetic field, field lines, compass needles, iron filings, electromagnetism, physics simulator\">");

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
        <span class="breadcrumb-current">Magnetic Field</span>
    </nav>

    <div class="viz-header">
        <h1>Magnetic Field Visualizer</h1>
        <p class="viz-subtitle">Explore magnetic fields from different sources. Switch between bar magnets, straight wires, wire loops, and solenoids to see field lines, compass needles, and iron filing patterns.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Field Parameters</h3>

                <div class="control-group">
                    <label>Source</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-source="bar">Bar Magnet</button>
                        <button class="vm-chip" data-source="wire">Straight Wire</button>
                        <button class="vm-chip" data-source="loop">Wire Loop</button>
                        <button class="vm-chip" data-source="solenoid">Solenoid</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>Strength = <span id="strength-display">5</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="strength-slider" min="1" max="10" value="5" step="1">
                        <span class="viz-slider-val" id="strength-val">5</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Current = <span id="current-display">10</span> A</label>
                    <div class="viz-slider-row">
                        <input type="range" id="current-slider" min="1" max="20" value="10" step="1">
                        <span class="viz-slider-val" id="current-val">10</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Show</label>
                    <div style="display:flex;flex-direction:column;gap:6px;">
                        <label class="viz-checkbox"><input type="checkbox" id="show-fieldlines" checked> Field lines</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-compass"> Compass needles</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-vectors"> Field vectors</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-filings"> Iron filings</label>
                    </div>
                </div>
            </div>

            <div class="viz-values">
                <h3>Properties</h3>
                <table>
                    <tr><td>Source</td><td id="val-source">Bar Magnet</td></tr>
                    <tr><td>Strength</td><td id="val-strength">5</td></tr>
                    <tr><td>Current</td><td id="val-current">10 A</td></tr>
                    <tr><td>B at ref</td><td id="val-bat">--</td></tr>
                    <tr><td>Direction</td><td id="val-direction">--</td></tr>
                    <tr><td>Poles</td><td id="val-poles">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Physics Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Magnetic Field Formulas</h3>
                <ul>
                    <li>Straight wire: <span class="formula-highlight">B = &mu;&#8320;I/(2&pi;r)</span></li>
                    <li>Solenoid: <span class="formula-highlight">B = &mu;&#8320;nI</span></li>
                    <li>Wire loop center: <span class="formula-highlight">B = &mu;&#8320;I/(2R)</span></li>
                    <li>Bar magnet: dipole field approximation</li>
                    <li>&mu;&#8320; = 4&pi; &times; 10&sup7; T&middot;m/A</li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Key Concepts</h3>
                <ul>
                    <li><strong>Magnetic field lines</strong> are always closed loops: they go from north to south outside the magnet and south to north inside</li>
                    <li><strong>Right-hand rule</strong>: curl fingers in the direction of current, thumb points along the magnetic field</li>
                    <li><strong>Solenoids</strong> produce a nearly uniform field inside, similar to a bar magnet externally</li>
                    <li><strong>Field strength</strong> decreases with distance; for a wire it drops as 1/r, for a dipole as 1/r&sup3;</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-physics/electric-field.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#9889;</div>
                <div><h4>Electric Field</h4><span>E&amp;M</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-physics/em-induction.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#9883;</div>
                <div><h4>EM Induction</h4><span>E&amp;M</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/polar-coordinates.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#10548;</div>
                <div><h4>Polar Coordinates</h4><span>Visual Math</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{"@context":"https://schema.org","@type":"LearningResource","name":"Magnetic Field Visualizer","description":"Interactive magnetic field visualizer. See field lines, compass needles, and iron filing patterns for bar magnets, straight wires, wire loops, and solenoids.","url":"https://8gwifi.org/exams/visual-physics/magnetic-field.jsp","educationalLevel":"High School","teaches":"Magnetic field, bar magnet, solenoid, wire field, field lines, right-hand rule, electromagnetism","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Physics","item":"https://8gwifi.org/exams/visual-physics/"},{"@type":"ListItem","position":4,"name":"Magnetic Field"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"How do magnetic field lines work?","acceptedAnswer":{"@type":"Answer","text":"Magnetic field lines are continuous closed loops that emerge from the north pole and enter the south pole outside a magnet, and run from south to north inside it. They never cross each other, and their density indicates field strength \u2014 closer lines mean a stronger field."}},{"@type":"Question","name":"What is the right-hand rule for magnetic fields?","acceptedAnswer":{"@type":"Answer","text":"For a straight current-carrying wire: point your right thumb in the direction of current flow, and your curled fingers indicate the direction of the magnetic field (circling the wire). For a solenoid: curl your fingers in the direction of current, and your thumb points toward the north pole."}},{"@type":"Question","name":"How does a solenoid create a uniform magnetic field?","acceptedAnswer":{"@type":"Answer","text":"A solenoid is a tightly wound coil of wire. Inside the solenoid, the magnetic field contributions from each loop add together to create a nearly uniform field (B = \u03bc\u2080nI, where n is turns per unit length). Outside, the field resembles that of a bar magnet and is much weaker."}}]}
</script>

<%@ include file="vp-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-physics/js/vp-magnetic-field.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('magnetic-field', 'viz-canvas', {
        sourceType: 'bar', strength: 5, current: 10,
        showFieldLines: true, showCompass: false, showVectors: false, showFilings: false
    });
    var state = VisualMath.getState();

    document.querySelectorAll('[data-source]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            state.sourceType = this.getAttribute('data-source');
            document.querySelectorAll('[data-source]').forEach(function (b) {
                b.classList.toggle('active', b.getAttribute('data-source') === state.sourceType);
            });
            state._redraw();
        });
    });

    document.getElementById('strength-slider').addEventListener('input', function () {
        state.strength = parseInt(this.value);
        document.getElementById('strength-display').textContent = this.value;
        document.getElementById('strength-val').textContent = this.value;
        state._redraw();
    });

    document.getElementById('current-slider').addEventListener('input', function () {
        state.current = parseInt(this.value);
        document.getElementById('current-display').textContent = this.value;
        document.getElementById('current-val').textContent = this.value;
        state._redraw();
    });

    document.getElementById('show-fieldlines').addEventListener('change', function () { state.showFieldLines = this.checked; state._redraw(); });
    document.getElementById('show-compass').addEventListener('change', function () { state.showCompass = this.checked; state._redraw(); });
    document.getElementById('show-vectors').addEventListener('change', function () { state.showVectors = this.checked; state._redraw(); });
    document.getElementById('show-filings').addEventListener('change', function () { state.showFilings = this.checked; state._redraw(); });
});
</script>
