<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<jsp:include page="../../modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="Oscillating Charge — Electromagnetic Field Animator" />
    <jsp:param name="toolCategory" value="Physics" />
    <jsp:param name="toolDescription" value="Animate electric-field magnitude and direction around a driven oscillating charge. Browser-based CPU simulation powered by the migrated PyCharge JavaScript core." />
    <jsp:param name="toolUrl" value="physics/labs/oscillating-charge.jsp" />
    <jsp:param name="toolKeywords" value="oscillating charge, electromagnetic field animation, lienard-wiechert, electric field, pycharge javascript, physics lab" />
    <jsp:param name="toolImage" value="logo.png" />
    <jsp:param name="breadcrumbCategoryUrl" value="physics/" />
</jsp:include>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;500;600;700&family=DM+Sans:wght@400;500;600&family=Fira+Code:wght@400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=v%>">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=v%>">
<link rel="stylesheet" href="css/labs.css?v=<%=v%>">

<style>
.field-canvas { width: 100%; height: 100%; min-height: 420px; }
.lab-controls-note { font-size: 0.72rem; color: var(--lab-text-muted); margin-top: 8px; line-height: 1.4; }
.row-inline { display: flex; gap: 8px; }
.row-inline .transport-btn { flex: 1; }
.lab-stats-inline { margin: 10px 0 0; font-size: .78rem; color: var(--lab-text-sec); }
</style>
</head>
<body style="background:var(--lab-bg-deep);margin:0;min-height:100vh;">
<%@ include file="../../modern/components/nav-header.jsp" %>

<div class="lab-wrap">
  <nav class="lab-crumb">
    <a href="<%=request.getContextPath()%>/">Home</a> /
    <a href="<%=request.getContextPath()%>/physics/">Physics</a> /
    <a href="<%=request.getContextPath()%>/physics/labs/">Labs</a> /
    <span>Oscillating Charge</span>
  </nav>

  <h1 class="lab-title">Oscillating Charge — E-Field Animation</h1>

  <div class="lab-grid">
    <div class="lab-canvas-area">
      <div class="lab-canvas-wrap">
        <canvas id="fieldCanvas" class="field-canvas"></canvas>
      </div>
    </div>

    <div class="lab-sidebar" id="controlsPanel">
      <div class="lab-params" id="oscControls">
        <div class="param-row">
          <label class="param-label">Amplitude <span class="param-value" data-role="amplitude-value">2.00 nm</span></label>
          <input id="amplitude" class="param-slider" type="range" min="0.5" max="6" step="0.1" value="2.0" />
        </div>

        <div class="param-row">
          <label class="param-label">Angular Frequency ω <span class="param-value" data-role="omega-value">7.50 ×10¹⁶</span></label>
          <input id="omega" class="param-slider" type="range" min="1.0" max="12.0" step="0.1" value="7.5" />
        </div>

        <div class="param-row">
          <label class="param-label">View Limit <span class="param-value" data-role="limit-value">50 nm</span></label>
          <input id="limit" class="param-slider" type="range" min="20" max="90" step="1" value="50" />
        </div>

        <div class="param-row">
          <label class="param-label">Grid Density <span class="param-value" data-role="grid-value">35</span></label>
          <input id="grid" class="param-slider" type="range" min="25" max="55" step="2" value="35" />
        </div>

        <div class="param-row">
          <label class="param-label">Quiver Step <span class="param-value" data-role="stride-value">4</span></label>
          <input id="stride" class="param-slider" type="range" min="2" max="8" step="1" value="4" />
        </div>

        <div class="param-row">
          <label class="param-label">Playback Speed <span class="param-value" data-role="speed-value">0.35×</span></label>
          <input id="speed" class="param-slider" type="range" min="0.1" max="1.5" step="0.05" value="0.35" />
        </div>

        <div class="row-inline">
          <button class="transport-btn" id="toggleRun">Pause</button>
          <button class="transport-btn" id="resetTime">Reset</button>
        </div>

        <div id="simStats" class="lab-stats-inline">Initializing...</div>
        <div class="lab-controls-note">
          Heatmap shows log-scaled |E|. Arrows show local electric-field direction. Red dot is the source charge.
        </div>
      </div>
    </div>
  </div>

  <section class="lab-info">
    <h2>About This Lab</h2>
    <p>
      This lab helps you understand how electromagnetic fields behave around an accelerating charge.
      By changing amplitude and frequency, you can observe how field strength, direction patterns,
      and wave-like propagation change over time. You will build intuition for retarded-time effects,
      inverse-distance field falloff, and the difference between near-field structure and dynamic
      radiation behavior in a visual, interactive way.
    </p>
  </section>

  <div class="lab-related">
    <span>Also try &rarr;</span>
    <a href="<%=request.getContextPath()%>/physics/labs/pendulum.jsp">Pendulum</a>
    <a href="<%=request.getContextPath()%>/physics/labs/string-wave.jsp">Vibrating String</a>
    <a href="<%=request.getContextPath()%>/physics/labs/">All Labs</a>
  </div>
</div>

<script type="module">
import { initOscillatingChargeLab } from './js/sims/oscillating-charge.js';

initOscillatingChargeLab({
  canvas: document.getElementById('fieldCanvas'),
  controls: document.getElementById('oscControls'),
  stats: document.getElementById('simStats'),
  amplitudeInput: document.getElementById('amplitude'),
  omegaInput: document.getElementById('omega'),
  limitInput: document.getElementById('limit'),
  gridInput: document.getElementById('grid'),
  strideInput: document.getElementById('stride'),
  speedInput: document.getElementById('speed'),
  playButton: document.getElementById('toggleRun'),
  resetButton: document.getElementById('resetTime'),
});
</script>
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=v%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
<%@ include file="../../modern/components/analytics.jsp" %>
</body>
</html>
