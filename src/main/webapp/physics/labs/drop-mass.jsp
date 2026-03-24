<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<jsp:include page="../../modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="Dropping a Mass on an Oscillating Mass — Interactive Physics Lab" />
    <jsp:param name="toolCategory" value="Physics" />
    <jsp:param name="toolDescription" value="Watch what happens when you drop a mass onto an oscillating spring-mass system. See momentum conservation, energy loss, frequency change, and equilibrium shift in real time. Free, no signup." />
    <jsp:param name="toolUrl" value="physics/labs/drop-mass.jsp" />
    <jsp:param name="toolKeywords" value="inelastic collision, oscillating mass, spring mass, momentum conservation, drop mass, frequency change, energy loss, SHM, physics simulation" />
    <jsp:param name="toolImage" value="logo.png" />
    <jsp:param name="breadcrumbCategoryUrl" value="physics/" />
    <jsp:param name="educationalLevel" value="High School, Undergraduate" />
    <jsp:param name="teaches" value="inelastic collision, momentum conservation, spring oscillation, frequency change, energy conservation, equilibrium shift" />
    <jsp:param name="faq1q" value="What happens when you drop a mass on an oscillating spring?" />
    <jsp:param name="faq1a" value="The dropped mass collides inelastically with the oscillating mass. They stick together and oscillate at a lower frequency with a new equilibrium position. Momentum is conserved but kinetic energy is lost." />
    <jsp:param name="faq2q" value="Why does the frequency decrease after the collision?" />
    <jsp:param name="faq2a" value="The frequency of a spring-mass system is omega equals square root of k over m. When the mass increases from m1 to m1 plus m2 the frequency decreases because the denominator is larger." />
</jsp:include>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;500;600;700&family=DM+Sans:wght@400;500;600&family=Fira+Code:wght@400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=v%>">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=v%>">
<link rel="stylesheet" href="css/labs.css?v=<%=v%>">
</head>
<body style="background:var(--lab-bg-deep);margin:0;min-height:100vh;">
<%@ include file="../../modern/components/nav-header.jsp" %>

<div class="lab-wrap">
  <nav class="lab-crumb">
    <a href="<%=request.getContextPath()%>/">Home</a> /
    <a href="<%=request.getContextPath()%>/physics/">Physics</a> /
    <a href="<%=request.getContextPath()%>/physics/labs/">Labs</a> /
    <span>Drop Mass on Oscillator</span>
  </nav>

  <h1 class="lab-title">Dropping a Mass on an Oscillating Mass</h1>

  <div id="labTabs"></div>

  <div class="lab-grid">
    <div class="lab-canvas-area" id="canvasArea">
      <div class="lab-canvas-wrap" id="simPanel">
        <canvas id="simCanvas"></canvas>
      </div>
      <div class="lab-canvas-wrap lab-graph-panel" id="graphPanel">
        <canvas id="graphCanvas" width="600" height="450"></canvas>
        <canvas id="timeCanvas" width="600" height="450" style="display:none;"></canvas>
        <canvas id="energyCanvas" width="600" height="300" style="display:none;"></canvas>
      </div>
    </div>

    <div class="lab-sidebar">
      <div id="transport"></div>
      <div id="controls"></div>
      <div id="presets"></div>
      <div id="varPicker"></div>
      <div id="dataTools"></div>
    </div>
  </div>

  <section class="lab-info" id="labInfo"></section>

  <div class="lab-related">
    <span>Also try &rarr;</span>
    <a href="<%=request.getContextPath()%>/physics/labs/spring.jsp">Spring Oscillator</a>
    <a href="<%=request.getContextPath()%>/physics/labs/double-spring.jsp">Double Spring</a>
    <a href="<%=request.getContextPath()%>/physics/labs/collide-blocks.jsp">Colliding Blocks</a>
    <a href="<%=request.getContextPath()%>/physics/labs/">All Physics Labs</a>
  </div>
</div>

<script type="module">
import { createLab } from './js/lab.js';
import { DropMassSim } from './js/sims/drop-mass.js';

const lab = createLab(DropMassSim, {
  simCanvas:    document.getElementById('simCanvas'),
  graphCanvas:  document.getElementById('graphCanvas'),
  timeCanvas:   document.getElementById('timeCanvas'),
  energyCanvas: document.getElementById('energyCanvas'),
  canvasArea:   document.getElementById('canvasArea'),
  controls:     document.getElementById('controls'),
  transport:    document.getElementById('transport'),
  presets:      document.getElementById('presets'),
  tabs:         document.getElementById('labTabs'),
  varPicker:    document.getElementById('varPicker'),
  dataTools:    document.getElementById('dataTools'),
});

document.getElementById('labInfo').innerHTML = DropMassSim.info || '';
</script>
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=v%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
<%@ include file="../../modern/components/analytics.jsp" %>
</body>
</html>
