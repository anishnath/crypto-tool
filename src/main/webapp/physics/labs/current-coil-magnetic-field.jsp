<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<jsp:include page="../../modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="Current Coil Magnetic Field — Interactive Visualizer" />
    <jsp:param name="toolCategory" value="Physics" />
    <jsp:param name="toolDescription" value="Visualize Bz from a current loop using moving discrete charges and compare pycharge-based results with the analytical Biot-Savart on-axis curve." />
    <jsp:param name="toolUrl" value="physics/labs/current-coil-magnetic-field.jsp" />
    <jsp:param name="toolKeywords" value="current coil magnetic field, biot savart law, magnetic field visualizer, electromagnetism lab, physics simulation" />
    <jsp:param name="toolImage" value="logo.png" />
    <jsp:param name="breadcrumbCategoryUrl" value="physics/" />
</jsp:include>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;500;600;700&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=v%>">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=v%>">
<link rel="stylesheet" href="css/labs.css?v=<%=v%>">

<style>
.coil-canvas { width: 100%; min-height: 420px; }
.axis-canvas { width: 100%; min-height: 420px; background:var(--lab-bg-input); }
.lab-stats-inline { margin: 10px 0 0; font-size: .78rem; color: var(--lab-text-sec); }
.row-inline { display:flex; gap:8px; }
.row-inline .transport-btn { flex:1; }
.preset-wrap { display:flex; flex-wrap:wrap; gap:6px; margin:0 0 10px; }
.preset-btn { border:1px solid var(--lab-border); background:var(--lab-bg-input); color:var(--lab-text); border-radius:999px; padding:5px 10px; font-size:.72rem; cursor:pointer; }
.preset-btn:hover { border-color:var(--lab-accent); color:var(--lab-accent-bright); }
.insight-box { margin-top:10px; background:var(--lab-bg-input); border:1px solid var(--lab-border); border-radius:8px; padding:8px; font-size:.75rem; color:var(--lab-text-sec); line-height:1.4; }
.probe-grid { margin-top:10px; display:grid; grid-template-columns:1fr 1fr; gap:6px; font-size:.72rem; }
.probe-pill { background:var(--lab-bg-input); border:1px solid var(--lab-border); border-radius:8px; padding:6px; color:var(--lab-text-sec); }
.status-row { display:flex; gap:8px; margin-top:10px; }
.status-pill { flex:1; background:var(--lab-bg-input); border:1px solid var(--lab-border); border-radius:8px; padding:6px; font-size:.72rem; color:var(--lab-text-sec); text-align:center; }
.status-pill.good { border-color:rgba(16,185,129,.45); color:#6ee7b7; }
.guide-line { margin-top:8px; font-size:.72rem; color:var(--lab-text-muted); line-height:1.35; }
.tab-panel { display:none; }
.tab-panel.active { display:block; }
</style>
</head>
<body style="background:var(--lab-bg-deep);margin:0;min-height:100vh;">
<%@ include file="../../modern/components/nav-header.jsp" %>

<div class="lab-wrap">
  <nav class="lab-crumb">
    <a href="<%=request.getContextPath()%>/">Home</a> /
    <a href="<%=request.getContextPath()%>/physics/">Physics</a> /
    <a href="<%=request.getContextPath()%>/physics/labs/">Labs</a> /
    <span>Current Coil Magnetic Field</span>
  </nav>

  <h1 class="lab-title">Current Coil Magnetic Field</h1>

  <div class="lab-tabs" id="coilTabs">
    <button class="lab-tab active" data-view="field">Bz Map</button>
    <button class="lab-tab" data-view="axis">Axis Plot</button>
    <button class="lab-tab" data-view="hist">Histograms</button>
  </div>

  <div class="lab-grid">
    <div class="lab-canvas-area">
      <div class="lab-canvas-wrap tab-panel active" data-panel="field">
        <canvas id="fieldCanvas" class="coil-canvas"></canvas>
      </div>
      <div class="lab-canvas-wrap tab-panel" data-panel="axis">
        <canvas id="axisCanvas" class="axis-canvas"></canvas>
      </div>
      <div class="lab-canvas-wrap tab-panel" data-panel="hist">
        <canvas id="histCanvas" class="axis-canvas"></canvas>
      </div>
    </div>

    <div class="lab-sidebar">
      <div class="lab-params" id="coilControls">
        <div class="preset-wrap">
          <button class="preset-btn" data-preset="intro">Intro</button>
          <button class="preset-btn" data-preset="strong">Strong Current</button>
          <button class="preset-btn" data-preset="smooth">Smooth Ring</button>
          <button class="preset-btn" data-preset="coarse">Coarse Charges</button>
        </div>

        <div class="param-row">
          <label class="param-label">Discrete Charges <span class="param-value" data-role="charges-value">30</span></label>
          <input id="numCharges" class="param-slider" type="range" min="8" max="80" step="2" value="30" />
        </div>
        <div class="param-row">
          <label class="param-label">Coil Radius <span class="param-value" data-role="radius-value">1.00 cm</span></label>
          <input id="radius" class="param-slider" type="range" min="0.4" max="3.0" step="0.05" value="1.0" />
        </div>
        <div class="param-row">
          <label class="param-label">Angular Speed ω <span class="param-value" data-role="omega-value">1.00 ×10⁸</span></label>
          <input id="omega" class="param-slider" type="range" min="0.2" max="3.0" step="0.05" value="1.0" />
        </div>
        <div class="param-row">
          <label class="param-label">Grid Resolution <span class="param-value" data-role="grid-value">101</span></label>
          <input id="grid" class="param-slider" type="range" min="61" max="161" step="10" value="101" />
        </div>
        <div class="param-row">
          <label class="param-label">Field Extent <span class="param-value" data-role="extent-value">1.50R</span></label>
          <input id="extentMul" class="param-slider" type="range" min="1.2" max="3.0" step="0.1" value="1.5" />
        </div>
        <div class="param-row">
          <label class="param-label">Animation Speed <span class="param-value" data-role="speed-value">1.00×</span></label>
          <input id="speed" class="param-slider" type="range" min="0.2" max="3.0" step="0.1" value="1.0" />
        </div>

        <div class="param-row">
          <label class="param-label">Probe Position on z-axis <span class="param-value" data-role="probe-value">0.00R</span></label>
          <input id="probeZ" class="param-slider" type="range" min="-5" max="5" step="0.1" value="0" />
        </div>

        <div class="row-inline">
          <button class="transport-btn" id="toggleRun">Pause</button>
          <button class="transport-btn" id="recompute">Apply Now</button>
        </div>
        <div id="simStats" class="lab-stats-inline">Initializing...</div>

        <div class="probe-grid">
          <div class="probe-pill" id="probePy">PyCharge Bz: --</div>
          <div class="probe-pill" id="probeBiot">Biot-Savart Bz: --</div>
          <div class="probe-pill" id="probeErr">Relative error: --</div>
          <div class="probe-pill" id="centerBz">Center Bz: --</div>
        </div>
        <div class="status-row">
          <div class="status-pill" id="matchBadge">Match quality: --</div>
          <div class="status-pill" id="cursorBz">Cursor Bz: --</div>
        </div>
        <div class="insight-box" id="insightBox">Use a preset and move one slider at a time to see how the map and curve react.</div>
        <div class="guide-line" id="guideLine">Creative tip: hover over the heatmap to inspect local Bz and correlate it with the axis curve.</div>
      </div>
    </div>
  </div>

  <section class="lab-info">
    <h2>What You Learn</h2>
    <p>
      This lab helps you connect moving charges to macroscopic current-loop magnetic fields.
      You can see how the <strong>z-component</strong> of magnetic field is distributed in the coil plane,
      and compare the simulated on-axis field with the analytical Biot-Savart result.
      It builds intuition for discretization effects, symmetry, and how field magnitude changes with
      radius, angular speed, and charge count.
    </p>
  </section>

  <div class="lab-related">
    <span>Also try &rarr;</span>
    <a href="<%=request.getContextPath()%>/physics/labs/oscillating-charge.jsp">Oscillating Charge</a>
    <a href="<%=request.getContextPath()%>/physics/labs/molecule.jsp">Molecule</a>
    <a href="<%=request.getContextPath()%>/physics/labs/">All Labs</a>
  </div>
</div>

<script type="module">
import { initCurrentCoilLab } from './js/sims/current-coil-magnetic-field.js';

initCurrentCoilLab({
  fieldCanvas: document.getElementById('fieldCanvas'),
  axisCanvas: document.getElementById('axisCanvas'),
  histCanvas: document.getElementById('histCanvas'),
  tabsContainer: document.getElementById('coilTabs'),
  controls: document.getElementById('coilControls'),
  stats: document.getElementById('simStats'),
  chargesInput: document.getElementById('numCharges'),
  radiusInput: document.getElementById('radius'),
  omegaInput: document.getElementById('omega'),
  gridInput: document.getElementById('grid'),
  extentInput: document.getElementById('extentMul'),
  speedInput: document.getElementById('speed'),
  probeInput: document.getElementById('probeZ'),
  playButton: document.getElementById('toggleRun'),
  recomputeButton: document.getElementById('recompute'),
  insightBox: document.getElementById('insightBox'),
  probePyEl: document.getElementById('probePy'),
  probeBiotEl: document.getElementById('probeBiot'),
  probeErrEl: document.getElementById('probeErr'),
  centerBzEl: document.getElementById('centerBz'),
  matchBadgeEl: document.getElementById('matchBadge'),
  cursorBzEl: document.getElementById('cursorBz'),
  guideLineEl: document.getElementById('guideLine'),
});
</script>
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=v%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
<%@ include file="../../modern/components/analytics.jsp" %>
</body>
</html>
