<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Steiner Funnel Visualizer - 3D Spiral Circuit Animation (Free)";
    String seoDescription = "Interactive 3D visualization of the Steiner Funnel. Watch A(x,n) and B(x,n) Steiner circuits trace helical spirals that form a tapering funnel. Explore how theta=2pi*n/(N+1) places each element, how A and B circuits wind in opposite directions, and how decreasing x builds the cone. Drag to rotate.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-math/steiner-funnel.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Steiner Funnel — 3D Circuit Visualizer\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Steiner Funnel — 3D Circuit Visualizer\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"steiner funnel, steiner circuit, A(x,n), B(x,n), 3D spiral, helix visualization, number theory, parametric helix, steiner system, circuit animation, visual math, interactive mathematics\">");

    request.setAttribute("pageTitle", seoTitle);
    request.setAttribute("pageDescription", seoDescription);
    request.setAttribute("canonicalUrl", canonicalUrl);
    request.setAttribute("extraHeadContent", extraHead.toString());
    request.setAttribute("skipMathJax", "true");
%>
<%@ include file="../components/header.jsp" %>
<link rel="stylesheet" href="<%=request.getContextPath()%>/exams/visual-math/visual-math.css">

<style>
/* ── Steiner Funnel page styles ────────────────────────────────────────── */
.sf-info {
    padding: 12px;
    background: var(--bg-secondary, #f8fafc);
    border-radius: 8px;
    font-size: 13px;
    min-height: 88px;
}

.sf-info-chip {
    display: inline-block;
    padding: 2px 11px;
    border-radius: 999px;
    font-size: 11px;
    font-weight: 700;
    letter-spacing: 0.06em;
    text-transform: uppercase;
    margin-bottom: 10px;
}
.sf-a { background: rgba(14,130,220,0.13); color: #0e82dc; }
.sf-b { background: rgba(220,70,10,0.13);  color: #dc460a; }
[data-theme="dark"] .sf-a { background: rgba(30,200,255,0.15); color: #1ec8ff; }
[data-theme="dark"] .sf-b { background: rgba(255,130,40,0.15); color: #ff8228; }

.sf-info-table { width: 100%; border-collapse: collapse; }
.sf-info-table tr { border-bottom: 1px solid var(--border-primary, #e2e8f0); }
.sf-info-table tr:last-child { border-bottom: none; }
.sf-info-table th {
    padding: 4px 0;
    color: var(--text-secondary, #64748b);
    font-weight: 500;
    text-align: left;
    width: 38%;
}
.sf-info-table td {
    padding: 4px 0;
    color: var(--text-primary, #0f172a);
    font-family: var(--font-mono, monospace);
    font-size: 12px;
}

/* legend */
.sf-legend {
    display: flex;
    gap: 14px;
    margin-top: 12px;
    flex-wrap: wrap;
}
.sf-legend-item {
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 12px;
    color: var(--text-secondary, #64748b);
}
.sf-legend-dot {
    width: 10px; height: 10px;
    border-radius: 50%;
    flex-shrink: 0;
}
.sf-dot-a { background: #0e82dc; }
.sf-dot-b { background: #dc460a; }
[data-theme="dark"] .sf-dot-a { background: #1ec8ff; }
[data-theme="dark"] .sf-dot-b { background: #ff8228; }

/* canvas drag hint */
.sf-drag-hint {
    text-align: center;
    font-size: 11px;
    color: var(--text-secondary, #94a3b8);
    margin-top: 6px;
    pointer-events: none;
    user-select: none;
}
</style>

<div class="container">
    <!-- Breadcrumb -->
    <nav class="breadcrumb">
        <a href="<%=request.getContextPath()%>/exams/">Exams</a>
        <span class="breadcrumb-separator">/</span>
        <a href="<%=request.getContextPath()%>/exams/visual-math/">Visual Math</a>
        <span class="breadcrumb-separator">/</span>
        <span class="breadcrumb-current">Steiner Funnel</span>
    </nav>

    <!-- Title -->
    <div class="viz-header">
        <h1>Steiner Funnel Visualizer</h1>
        <p class="viz-subtitle">
            Watch <strong>A(x,n)</strong> and <strong>B(x,n)</strong> Steiner circuits trace 3-D helices that
            together form a tapering funnel. Each circuit spirals upward at most one full revolution before the
            next begins. <strong>A circuits</strong> wind counter-clockwise; <strong>B circuits</strong> reverse
            direction. Angle &theta;&nbsp;=&nbsp;2&pi;&middot;n&thinsp;/&thinsp;(N+1). Drag to rotate.
        </p>
    </div>

    <!-- Interactive zone -->
    <div class="viz-interactive">

        <!-- 3-D canvas -->
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
            <p class="sf-drag-hint">&#8635; drag to rotate &nbsp;&bull;&nbsp; use controls to customise</p>
        </div>

        <!-- Control panel -->
        <div class="viz-panel">

            <div class="viz-controls">
                <h3>Funnel Parameters</h3>

                <div class="control-group">
                    <label>Circuits &nbsp;<span id="lbl-circuits">8</span></label>
                    <input type="range" id="sl-circuits" min="3" max="14" value="8" step="1">
                </div>

                <div class="control-group">
                    <label>x Max &nbsp;<span id="lbl-xmax">3.0</span></label>
                    <input type="range" id="sl-xmax" min="1.0" max="6.0" value="3.0" step="0.1">
                </div>

                <div class="control-group">
                    <label>x Min &nbsp;<span id="lbl-xmin">0.25</span></label>
                    <input type="range" id="sl-xmin" min="0.05" max="1.5" value="0.25" step="0.05">
                </div>

                <div class="control-group">
                    <label>Anim Speed &nbsp;<span id="lbl-speed">1.2</span></label>
                    <input type="range" id="sl-speed" min="0.3" max="5.0" value="1.2" step="0.1">
                </div>

                <h3 style="margin-top:16px;">Display</h3>
                <div class="viz-check-group">
                    <label class="viz-check">
                        <input type="checkbox" id="chk-a" checked>
                        A Circuits &nbsp;<span style="color:#0e82dc;font-weight:600;">(CCW)</span>
                    </label>
                    <label class="viz-check">
                        <input type="checkbox" id="chk-b" checked>
                        B Circuits &nbsp;<span style="color:#dc460a;font-weight:600;">(CW)</span>
                    </label>
                </div>

                <div class="viz-btn-row" style="margin-top:12px;">
                    <button class="viz-btn viz-btn-primary" id="btn-replay">&#9654; Replay</button>
                    <button class="viz-btn viz-btn-primary"  id="btn-rotate">&#8635; Rotate</button>
                </div>

                <h3 style="margin-top:16px;">Presets</h3>
                <div style="display:flex;flex-wrap:wrap;gap:6px;">
                    <button class="vm-chip active" data-preset="classic">Classic</button>
                    <button class="vm-chip"         data-preset="dense">Dense</button>
                    <button class="vm-chip"         data-preset="sparse">Sparse</button>
                    <button class="vm-chip"         data-preset="fine">Fine</button>
                    <button class="vm-chip"         data-preset="deep">Deep</button>
                </div>

                <div class="sf-legend">
                    <div class="sf-legend-item">
                        <span class="sf-legend-dot sf-dot-a"></span> A(x,n) counter-clockwise
                    </div>
                    <div class="sf-legend-item">
                        <span class="sf-legend-dot sf-dot-b"></span> B(x,n) clockwise
                    </div>
                </div>
            </div><!-- /controls -->

            <div class="viz-values">
                <h3>Active Circuit</h3>
                <div class="sf-info" id="sf-info">
                    <em style="color:var(--text-secondary);font-size:12px;">Animation starting&hellip;</em>
                </div>
            </div>

        </div><!-- /viz-panel -->
    </div><!-- /viz-interactive -->

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <!-- Math explanation -->
    <section class="viz-math">
        <h2>The Steiner Funnel</h2>
        <div class="viz-math-grid">

            <div class="viz-math-col">
                <h3>Circuit Construction</h3>
                <ul>
                    <li>A circuit is characterised by parameter <span class="formula-highlight">x</span> and element count <span class="formula-highlight">N</span></li>
                    <li>Element <em>n</em> is placed at angle: <span class="formula-highlight">&theta; = 2&pi;&thinsp;n&thinsp;/&thinsp;(N+1)</span></li>
                    <li>Both radius and height-rise equal <span class="formula-highlight">x</span></li>
                    <li>3-D position of element <em>n</em>:<br>
                        <span class="formula-highlight">
                            (&thinsp;x&thinsp;cos&theta;,&ensp;x&thinsp;sin&theta;,&ensp;z<sub>base</sub>&thinsp;+&thinsp;x&thinsp;n/(N+1)&thinsp;)
                        </span>
                    </li>
                    <li>Each circuit spans <strong>at most one revolution</strong> (2&pi;)</li>
                    <li>End of circuit &rarr; <em>drop</em> to start of next circuit</li>
                </ul>
            </div>

            <div class="viz-math-col">
                <h3>A and B Functions</h3>
                <ul>
                    <li><strong>A(x, n)</strong>: &theta;&nbsp;=&nbsp;<span class="formula-highlight">+2&pi;&thinsp;n/(N+1)</span> &mdash; counter-clockwise</li>
                    <li><strong>B(x, n)</strong>: &theta;&nbsp;=&nbsp;<span class="formula-highlight">&minus;2&pi;&thinsp;n/(N+1)</span> &mdash; clockwise</li>
                    <li>Both evaluate to value <span class="formula-highlight">m</span> at the top of the circuit</li>
                    <li>Circuits alternate A and B as the funnel descends</li>
                </ul>
                <h3 style="margin-top:16px;">The Funnel Shape</h3>
                <ul>
                    <li><span class="formula-highlight">x</span> decreases with each successive circuit</li>
                    <li>Shrinking radius &amp; height build the tapering <strong>funnel / cone</strong></li>
                    <li>Total height: <span class="formula-highlight">&sum; x<sub>i</sub></span></li>
                    <li>Envelope surface: a cone of revolution</li>
                    <li>A&thinsp;+&thinsp;B alternate to produce a <strong>double-helix</strong> winding</li>
                </ul>
            </div>

        </div>
    </section>

    <!-- Related -->
    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-math/parametric-curves.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#8767;</div>
                <div><h4>Parametric Curves</h4><span>Calculus</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/polar-coordinates.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(239,68,68,0.12);">&#10687;</div>
                <div><h4>Polar Coordinates</h4><span>Trigonometry</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/complex-plane.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(59,130,246,0.12);"><em>i</em></div>
                <div><h4>Complex Plane</h4><span>Algebra</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/3d-shapes.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(16,185,129,0.12);">&#9633;</div>
                <div><h4>3D Shapes</h4><span>Geometry</span></div>
            </a>
        </div>
    </section>

</div><!-- /container -->

<!-- Structured data -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "LearningResource",
  "name": "Steiner Funnel Visualizer",
  "description": "Interactive 3D visualization of Steiner circuits. A(x,n) and B(x,n) functions trace helical spirals — angle theta=2pi*n/(N+1), radius=x — forming a funnel. A circuits wind CCW, B circuits CW.",
  "url": "https://8gwifi.org/exams/visual-math/steiner-funnel.jsp",
  "educationalLevel": "College",
  "teaches": "Steiner circuits, helical geometry, parametric spiral mathematics, 3D visualization",
  "learningResourceType": "Interactive visualization",
  "publisher": { "@type": "Organization", "name": "8gwifi.org" }
}
</script>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    { "@type": "ListItem", "position": 1, "name": "Home",           "item": "https://8gwifi.org/" },
    { "@type": "ListItem", "position": 2, "name": "Exams",          "item": "https://8gwifi.org/exams/" },
    { "@type": "ListItem", "position": 3, "name": "Visual Math Lab","item": "https://8gwifi.org/exams/visual-math/" },
    { "@type": "ListItem", "position": 4, "name": "Steiner Funnel" }
  ]
}
</script>

<%@ include file="viz-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>

<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-steiner-funnel.js"></script>

<script>
document.addEventListener('DOMContentLoaded', function () {

    var presets = {
        classic: { numCircuits: 8,  xMax: 3.0, xMin: 0.25, nMin: 3, nMax: 9,  animSpeed: 1.2 },
        dense:   { numCircuits: 12, xMax: 3.0, xMin: 0.20, nMin: 4, nMax: 12, animSpeed: 1.8 },
        sparse:  { numCircuits: 5,  xMax: 4.5, xMin: 0.50, nMin: 2, nMax: 6,  animSpeed: 1.0 },
        fine:    { numCircuits: 10, xMax: 2.0, xMin: 0.15, nMin: 5, nMax: 10, animSpeed: 0.8 },
        deep:    { numCircuits: 14, xMax: 4.0, xMin: 0.10, nMin: 3, nMax: 14, animSpeed: 2.0 }
    };

    var st = SteinerFunnel.init('viz-canvas', presets.classic);

    // ── sync slider labels from state ──────────────────────────────────────
    function syncLabels() {
        document.getElementById('sl-circuits').value       = st.numCircuits;
        document.getElementById('lbl-circuits').textContent = st.numCircuits;
        document.getElementById('sl-xmax').value           = st.xMax;
        document.getElementById('lbl-xmax').textContent    = st.xMax.toFixed(1);
        document.getElementById('sl-xmin').value           = st.xMin;
        document.getElementById('lbl-xmin').textContent    = st.xMin.toFixed(2);
        document.getElementById('sl-speed').value          = st.animSpeed;
        document.getElementById('lbl-speed').textContent   = st.animSpeed.toFixed(1);
        document.getElementById('chk-a').checked           = st.showA;
        document.getElementById('chk-b').checked           = st.showB;
    }
    syncLabels();

    // ── sliders ────────────────────────────────────────────────────────────
    document.getElementById('sl-circuits').addEventListener('input', function () {
        st.numCircuits = +this.value;
        document.getElementById('lbl-circuits').textContent = this.value;
        if (st._replay) st._replay();
    });
    document.getElementById('sl-xmax').addEventListener('input', function () {
        st.xMax = +this.value;
        document.getElementById('lbl-xmax').textContent = (+this.value).toFixed(1);
        if (st._replay) st._replay();
    });
    document.getElementById('sl-xmin').addEventListener('input', function () {
        st.xMin = +this.value;
        document.getElementById('lbl-xmin').textContent = (+this.value).toFixed(2);
        if (st._replay) st._replay();
    });
    document.getElementById('sl-speed').addEventListener('input', function () {
        st.animSpeed = +this.value;
        document.getElementById('lbl-speed').textContent = (+this.value).toFixed(1);
    });

    // ── checkboxes ─────────────────────────────────────────────────────────
    document.getElementById('chk-a').addEventListener('change', function () { st.showA = this.checked; });
    document.getElementById('chk-b').addEventListener('change', function () { st.showB = this.checked; });

    // ── replay button ──────────────────────────────────────────────────────
    document.getElementById('btn-replay').addEventListener('click', function () {
        if (st._replay) st._replay();
    });

    // ── auto-rotate toggle ─────────────────────────────────────────────────
    var rotBtn = document.getElementById('btn-rotate');
    function updateRotBtn() {
        rotBtn.classList.toggle('viz-btn-primary',   st.autoRotate);
        rotBtn.classList.toggle('viz-btn-secondary', !st.autoRotate);
    }
    updateRotBtn();
    rotBtn.addEventListener('click', function () {
        st.autoRotate = !st.autoRotate;
        updateRotBtn();
    });

    // ── presets ────────────────────────────────────────────────────────────
    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var key = this.getAttribute('data-preset');
            Object.assign(st, presets[key]);
            document.querySelectorAll('[data-preset]').forEach(function (b) {
                b.classList.remove('active');
            });
            this.classList.add('active');
            syncLabels();
            if (st._replay) st._replay();
        });
    });

});
</script>
