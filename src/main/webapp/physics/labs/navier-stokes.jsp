<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<jsp:include page="../../modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="Navier-Stokes Fluid Simulator — Watch Air Flow in Real Time" />
    <jsp:param name="toolCategory" value="Physics" />
    <jsp:param name="toolDescription" value="Simulate incompressible fluid flow using the full Navier-Stokes equations. Watch a fan blow air through a room with advection, viscosity, and pressure. Arrow and particle views. Free, no signup." />
    <jsp:param name="toolUrl" value="physics/labs/navier-stokes.jsp" />
    <jsp:param name="toolKeywords" value="Navier-Stokes simulator, fluid dynamics, CFD simulation, incompressible flow, viscosity, pressure solver, Poisson equation, advection, fluid mechanics, air flow simulation, computational fluid dynamics" />
    <jsp:param name="toolImage" value="logo.png" />
    <jsp:param name="breadcrumbCategoryUrl" value="physics/" />
    <jsp:param name="educationalLevel" value="Undergraduate, Graduate, Fluid Mechanics, CFD" />
    <jsp:param name="teaches" value="Navier-Stokes equations, incompressible flow, advection, viscosity, Poisson equation, pressure correction, Jacobi iteration, staggered grid, upwind scheme, CFD basics" />
    <jsp:param name="faq1q" value="What are the Navier-Stokes equations?" />
    <jsp:param name="faq1a" value="The Navier-Stokes equations describe how fluids move. The momentum equation says that fluid acceleration equals the sum of pressure forces viscous friction and advection (the fluid carrying itself). The continuity equation says the fluid is incompressible so the divergence of velocity is zero. Together they govern everything from weather to airplane wings to blood flow." />
    <jsp:param name="faq2q" value="How does this fluid simulator solve the Navier-Stokes equations?" />
    <jsp:param name="faq2a" value="It uses the fractional-step method. Each timestep has four stages: advection moves velocity using upwind finite differences, viscosity adds Laplacian diffusion, a Jacobi iterative Poisson solver computes pressure to enforce zero divergence, then velocity is corrected by subtracting the pressure gradient. The grid uses the Arakawa C-type staggered layout for accurate pressure-velocity coupling." />
</jsp:include>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;500;600;700&family=DM+Sans:wght@400;500;600&family=Fira+Code:wght@400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=v%>">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=v%>">
<link rel="stylesheet" href="css/labs.css?v=<%=v%>">
<!-- GPT Ads -->
<script async src="https://securepubads.g.doubleclick.net/tag/js/gpt.js" onerror="console.warn('GPT failed')"></script>
<script>
stpd=window.stpd||{que:[]};window.googletag=window.googletag||{cmd:[]};
googletag.cmd.push(function(){
  var w=window.innerWidth;
  if(w>=992)googletag.defineSlot('/147246189,22976055811/8gwifi.org_970x90_hero_desktop',[[970,90],[728,90]],'ad_lab_hero').addService(googletag.pubads());
  else if(w>=768)googletag.defineSlot('/147246189,22976055811/8gwifi.org_728x90_hero_tablet',[[728,90]],'ad_lab_hero').addService(googletag.pubads());
  else googletag.defineSlot('/147246189,22976055811/8gwifi.org_320x100_hero_mobile',[[320,50],[320,100]],'ad_lab_hero').addService(googletag.pubads());
  if(w>=992)googletag.defineSlot('/147246189,22976055811/8gwifi.org_728x90_leaderboard_desktop',[[970,90],[728,90]],'ad_lab_below').addService(googletag.pubads());
  else googletag.defineSlot('/147246189,22976055811/8gwifi.org_320x100_leaderboard_mobile',[[320,100],[320,50]],'ad_lab_below').addService(googletag.pubads());
  if(w>=992)googletag.defineSlot('/147246189,22976055811/8gwifi.org_728x90_anchor_desktop',[[970,90],[728,90]],'ad_lab_sticky').addService(googletag.pubads());
  else googletag.defineSlot('/147246189,22976055811/8gwifi.org_320x100_anchor_mobile',[[320,100],[320,50]],'ad_lab_sticky').addService(googletag.pubads());
  googletag.pubads().disableInitialLoad();googletag.pubads().enableSingleRequest();googletag.pubads().collapseEmptyDivs();googletag.enableServices();
});
</script>
<script>(function(){var s=document.createElement('script');s.src='https://stpd.cloud/saas/5796';s.async=true;s.onerror=function(){};document.head.appendChild(s)})()</script>
<style>
.ad-lab-hero{text-align:center;max-width:970px;margin:0 auto 8px;min-height:50px}
.ad-lab-hero .ad-label,.ad-lab-below .ad-label,.ad-lab-sticky .ad-label{font-size:.55rem;text-transform:uppercase;letter-spacing:.06em;color:var(--lab-text-muted);opacity:.5;margin-bottom:4px}
.ad-lab-below{margin:20px auto 0;padding:12px 0;text-align:center;max-width:970px;min-height:50px;opacity:0;transition:opacity .4s}
.ad-lab-below.ad-loaded{opacity:1}
.ad-lab-sticky{position:fixed;bottom:0;left:0;right:0;z-index:6000;text-align:center;padding:6px 0 8px;background:var(--lab-bg-panel);border-top:1px solid var(--lab-border);box-shadow:0 -2px 12px rgba(0,0,0,.15);transform:translateY(100%);transition:transform .4s;display:none}
.ad-lab-sticky.ad-visible{display:block;transform:translateY(0)}
.ad-lab-sticky.ad-dismissed{transform:translateY(100%);pointer-events:none}
.ad-lab-sticky .ad-close{position:absolute;top:4px;right:12px;width:22px;height:22px;border:1px solid var(--lab-border);border-radius:50%;background:var(--lab-bg-input);color:var(--lab-text-muted);font-size:14px;line-height:20px;text-align:center;cursor:pointer}
</style>
</head>
<body style="background:var(--lab-bg-deep);margin:0;min-height:100vh;">
<%@ include file="../../modern/components/nav-header.jsp" %>
<div class="lab-wrap">
<div class="ad-lab-hero" id="ad_lab_hero"><div class="ad-label">Advertisement</div></div>
  <nav class="lab-crumb">
    <a href="<%=request.getContextPath()%>/">Home</a> /
    <a href="<%=request.getContextPath()%>/physics/">Physics</a> /
    <a href="<%=request.getContextPath()%>/physics/labs/">Labs</a> /
    <span>Navier-Stokes Fluid Sim</span>
  </nav>
  <h1 class="lab-title">Navier-Stokes Fluid Simulator</h1>
  <div id="labTabs"></div>
  <div class="lab-grid">
    <div class="lab-canvas-area" id="canvasArea">
      <div class="lab-canvas-wrap" id="simPanel"><canvas id="simCanvas"></canvas></div>
      <div class="lab-canvas-wrap lab-graph-panel" id="graphPanel">
        <canvas id="graphCanvas" width="600" height="450"></canvas>
        <canvas id="timeCanvas" width="600" height="450" style="display:none;"></canvas>
        <canvas id="energyCanvas" width="600" height="300" style="display:none;"></canvas>
        <canvas id="peWellCanvas" width="600" height="400" style="display:none;"></canvas>
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
  <div class="ad-lab-below" id="ad_lab_below"><div class="ad-label">Advertisement</div></div>
  <div class="lab-related">
    <span>Also try &rarr;</span>
    <a href="<%=request.getContextPath()%>/physics/labs/states-of-matter.jsp">States of Matter</a>
    <a href="<%=request.getContextPath()%>/physics/labs/molecule.jsp">Molecule</a>
    <a href="<%=request.getContextPath()%>/physics/labs/string-wave.jsp">Wave Equation</a>
    <a href="<%=request.getContextPath()%>/physics/labs/">All Physics Labs</a>
  </div>
</div>
<div class="ad-lab-sticky" id="adLabSticky">
  <button class="ad-close" onclick="document.getElementById('adLabSticky').classList.add('ad-dismissed');try{localStorage.setItem('ad_lab_sticky_d','1')}catch(e){}">&times;</button>
  <div class="ad-label">Advertisement</div>
  <div id="ad_lab_sticky"></div>
</div>
<script type="module">
import { createLab } from './js/lab.js';
import { NavierStokesSim } from './js/sims/navier-stokes.js';
const lab = createLab(NavierStokesSim, {
  simCanvas: document.getElementById('simCanvas'),
  graphCanvas: document.getElementById('graphCanvas'),
  timeCanvas: document.getElementById('timeCanvas'),
  energyCanvas: document.getElementById('energyCanvas'),
  peWellCanvas: document.getElementById('peWellCanvas'),
  canvasArea: document.getElementById('canvasArea'),
  controls: document.getElementById('controls'),
  transport: document.getElementById('transport'),
  presets: document.getElementById('presets'),
  tabs: document.getElementById('labTabs'),
  varPicker: document.getElementById('varPicker'),
  dataTools: document.getElementById('dataTools'),
});
document.getElementById('labInfo').innerHTML = NavierStokesSim.info || '';
</script>
<script>
(function(){
  if(typeof googletag!=='undefined'&&googletag.cmd)googletag.cmd.push(function(){googletag.display('ad_lab_hero')});
  var below=document.getElementById('ad_lab_below');
  if(below&&'IntersectionObserver'in window){
    var obs=new IntersectionObserver(function(e){e.forEach(function(en){if(en.isIntersecting){if(typeof googletag!=='undefined'&&googletag.cmd)googletag.cmd.push(function(){googletag.display('ad_lab_below');below.classList.add('ad-loaded')});obs.unobserve(below)}})},{rootMargin:'200px'});
    obs.observe(below);
  }
  var sticky=document.getElementById('adLabSticky');
  if(sticky&&!(localStorage.getItem('ad_lab_sticky_d')==='1')){
    window.addEventListener('load',function(){setTimeout(function(){if(typeof googletag!=='undefined'&&googletag.cmd)googletag.cmd.push(function(){googletag.display('ad_lab_sticky');sticky.classList.add('ad-visible')});setTimeout(function(){if(sticky&&!sticky.classList.contains('ad-dismissed'))sticky.classList.add('ad-dismissed')},30000)},window.innerWidth<768?4000:2000)});
  }
})();
</script>
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=v%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
<%@ include file="../../modern/components/analytics.jsp" %>
</body>
</html>
