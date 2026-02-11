<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Electric Field Simulator - Field Lines, Charges, Equipotential (Free)";
    String seoDescription = "Interactive electric field simulator. Place positive and negative charges, visualize field lines, equipotential surfaces, field vectors, and test charges in real time.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-physics/electric-field.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Electric Field Simulator - Field Lines, Charges, Equipotential\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Electric Field Simulator\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"electric field simulator, field lines, equipotential lines, Coulomb's law, point charges, superposition principle, electric potential, field vectors, electrostatics visualizer\">");

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
        <span class="breadcrumb-current">Electric Field</span>
    </nav>

    <div class="viz-header">
        <h1>Electric Field Simulator</h1>
        <p class="viz-subtitle">Place positive and negative charges to visualize electric field lines, equipotential surfaces, and the superposition of fields in real time.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Charges</h3>

                <div class="control-group">
                    <label>Add Charge</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="viz-btn viz-btn-primary" id="add-pos1" style="padding:6px 14px;font-size:14px;">+q</button>
                        <button class="viz-btn viz-btn-primary" id="add-neg1" style="padding:6px 14px;font-size:14px;">&minus;q</button>
                        <button class="viz-btn viz-btn-primary" id="add-pos2" style="padding:6px 14px;font-size:14px;">+2q</button>
                        <button class="viz-btn viz-btn-primary" id="add-neg2" style="padding:6px 14px;font-size:14px;">&minus;2q</button>
                    </div>
                </div>

                <div class="control-group">
                    <button class="viz-btn viz-btn-secondary" id="clear-btn" style="width:100%;">Clear All</button>
                </div>

                <div class="control-group">
                    <label>Show</label>
                    <div style="display:flex;flex-direction:column;gap:6px;">
                        <label class="viz-checkbox"><input type="checkbox" id="show-fieldlines" checked> Field Lines</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-equipotential"> Equipotential</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-vectors"> Field Vectors</label>
                        <label class="viz-checkbox"><input type="checkbox" id="show-testcharge"> Test Charge</label>
                    </div>
                </div>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-preset="dipole">Dipole</button>
                        <button class="vm-chip" data-preset="two-positive">Two Positive</button>
                        <button class="vm-chip" data-preset="quadrupole">Quadrupole</button>
                        <button class="vm-chip" data-preset="plates">Parallel Plates</button>
                    </div>
                </div>
            </div>

            <div class="viz-values">
                <h3>Properties</h3>
                <table>
                    <tr><td>Number of Charges</td><td id="val-numCharges">&mdash;</td></tr>
                    <tr><td>Net Charge</td><td id="val-netCharge">&mdash;</td></tr>
                    <tr><td>Field Magnitude</td><td id="val-fieldMag">&mdash;</td></tr>
                    <tr><td>Field Direction</td><td id="val-fieldDir">&mdash;</td></tr>
                    <tr><td>Potential</td><td id="val-potential">&mdash;</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Physics Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Coulomb's Law &amp; Electric Field</h3>
                <ul>
                    <li>Coulomb's Law: <span class="formula-highlight">F = k q&#8321; q&#8322; / r&sup2;</span></li>
                    <li>Electric field of a point charge: <span class="formula-highlight">E = k q / r&sup2;</span></li>
                    <li>Coulomb constant: <span class="formula-highlight">k = 8.99 &times; 10&#8313; N&middot;m&sup2;/C&sup2;</span></li>
                    <li>Direction: field points <strong>away</strong> from positive charges and <strong>toward</strong> negative charges</li>
                    <li>Field lines never cross &mdash; the field has a unique direction at every point</li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Superposition &amp; Potential</h3>
                <ul>
                    <li><strong>Superposition principle:</strong> <span class="formula-highlight">E&#8407;&#8345;&#8339;&#8345; = &Sigma; E&#8407;&#7522;</span> &mdash; fields from multiple charges add as vectors</li>
                    <li>Electric potential: <span class="formula-highlight">V = k q / r</span> (scalar, not a vector)</li>
                    <li>Equipotential lines are perpendicular to field lines at every point</li>
                    <li>No work is done moving a charge along an equipotential surface</li>
                    <li>A <strong>dipole</strong> (equal and opposite charges) produces the classic two-lobed field pattern</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-physics/circuit-builder.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(239,68,68,0.12);">&#9889;</div>
                <div><h4>Circuit Builder</h4><span>Electricity</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-physics/wave-interference.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(34,197,94,0.12);">&#8776;</div>
                <div><h4>Wave Interference</h4><span>Waves</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/vectors-2d.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#10548;</div>
                <div><h4>Vectors 2D</h4><span>Visual Math</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{"@context":"https://schema.org","@type":"LearningResource","name":"Electric Field Simulator","description":"Interactive electric field simulator. Place positive and negative charges, visualize field lines, equipotential surfaces, field vectors, and test charges in real time.","url":"https://8gwifi.org/exams/visual-physics/electric-field.jsp","educationalLevel":"High School","teaches":"Electric fields, Coulomb's law, field lines, equipotential surfaces, superposition principle, electric potential","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Physics","item":"https://8gwifi.org/exams/visual-physics/"},{"@type":"ListItem","position":4,"name":"Electric Field"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"What are electric field lines and what do they represent?","acceptedAnswer":{"@type":"Answer","text":"Electric field lines are imaginary curves that show the direction a positive test charge would move if placed in the field. They originate from positive charges and terminate on negative charges. The density of field lines indicates the field strength \u2014 closer lines mean a stronger field. Field lines never cross because the electric field has a unique direction at every point in space."}},{"@type":"Question","name":"What is an equipotential surface and why is it perpendicular to field lines?","acceptedAnswer":{"@type":"Answer","text":"An equipotential surface is a set of points where the electric potential has the same value. No work is done when moving a charge along an equipotential surface because there is no potential difference. Equipotential surfaces are always perpendicular to electric field lines because the electric field points in the direction of the steepest decrease in potential, which is always normal to surfaces of constant potential."}},{"@type":"Question","name":"How does the superposition principle apply to electric fields?","acceptedAnswer":{"@type":"Answer","text":"The superposition principle states that the total electric field at any point is the vector sum of the individual electric fields produced by each charge. This means you calculate E = kq/r\u00b2 for each charge separately (with direction), then add all the vectors tip-to-tail. This principle works because Maxwell's equations are linear, so solutions can be added together."}}]}
</script>

<%@ include file="vp-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-physics/js/vp-electric-field.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('electric-field', 'viz-canvas', {
        showFieldLines: true,
        showEquipotential: false,
        showVectors: false,
        showTestCharge: false
    });
    var state = VisualMath.getState();

    // Add charge buttons
    document.getElementById('add-pos1').addEventListener('click', function () {
        state._addCharge(1);
    });
    document.getElementById('add-neg1').addEventListener('click', function () {
        state._addCharge(-1);
    });
    document.getElementById('add-pos2').addEventListener('click', function () {
        state._addCharge(2);
    });
    document.getElementById('add-neg2').addEventListener('click', function () {
        state._addCharge(-2);
    });

    // Clear all
    document.getElementById('clear-btn').addEventListener('click', function () {
        state._clearCharges();
    });

    // Show checkboxes
    document.getElementById('show-fieldlines').addEventListener('change', function () {
        state.showFieldLines = this.checked;
        state._redraw();
    });
    document.getElementById('show-equipotential').addEventListener('change', function () {
        state.showEquipotential = this.checked;
        state._redraw();
    });
    document.getElementById('show-vectors').addEventListener('change', function () {
        state.showVectors = this.checked;
        state._redraw();
    });
    document.getElementById('show-testcharge').addEventListener('change', function () {
        state.showTestCharge = this.checked;
        state._redraw();
    });

    // Preset chips
    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var preset = this.getAttribute('data-preset');
            document.querySelectorAll('[data-preset]').forEach(function (b) {
                b.classList.toggle('active', b.getAttribute('data-preset') === preset);
            });
            state._setPreset(preset);
        });
    });
});
</script>
