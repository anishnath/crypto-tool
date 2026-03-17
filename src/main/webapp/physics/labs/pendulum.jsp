<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<jsp:include page="../../modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="Simple Pendulum Simulator — Interactive Physics Lab" />
    <jsp:param name="toolCategory" value="Physics" />
    <jsp:param name="toolDescription" value="Interactive simple pendulum simulation. Drag the bob, adjust gravity, length, mass, and damping. See real-time energy graphs and phase-space plots. Free, no signup." />
    <jsp:param name="toolUrl" value="physics/labs/pendulum.jsp" />
    <jsp:param name="toolKeywords" value="pendulum simulator, simple pendulum, physics simulation, harmonic motion, pendulum period, gravity simulation, interactive physics, pendulum lab" />
    <jsp:param name="toolImage" value="logo.png" />
    <jsp:param name="breadcrumbCategoryUrl" value="physics/" />
    <jsp:param name="educationalLevel" value="High School, Undergraduate" />
    <jsp:param name="teaches" value="Simple harmonic motion, pendulum period, energy conservation, damping, nonlinear oscillations" />
    <jsp:param name="hasSteps" value="true" />
    <jsp:param name="howToSteps" value="Drag the bob|Click and drag the pendulum bob to any angle then release to watch it swing,Adjust parameters|Use the sliders to change gravity and length and mass and damping,Try presets|Click Moon or Jupiter or Zero Damping to see different behaviors instantly,View graphs|Switch to Phase or Time tab to see angle vs velocity or time-series plots" />
    <jsp:param name="faq1q" value="What is the period of a simple pendulum?" />
    <jsp:param name="faq1a" value="For small angles the period is T = 2 pi sqrt(L/g) where L is the length and g is gravitational acceleration. This simulator shows both the small-angle approximation and the full nonlinear behavior for large swings." />
    <jsp:param name="faq2q" value="Why does the pendulum slow down?" />
    <jsp:param name="faq2a" value="Damping represents air resistance and friction at the pivot. Set damping to zero to see perpetual motion with perfect energy conservation. Increase damping to see the amplitude decay exponentially." />
    <jsp:param name="faq3q" value="Can I simulate pendulums on other planets?" />
    <jsp:param name="faq3a" value="Yes. Click the Moon preset for g=1.62 or Jupiter for g=24.79 or drag the gravity slider to any value. Watch how the period and swing behavior change with different gravitational fields." />
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

<!-- Hero Ad -->
<div class="ad-lab-hero" id="ad_lab_hero"><div class="ad-label">Advertisement</div></div>

  <nav class="lab-crumb">
    <a href="<%=request.getContextPath()%>/">Home</a> /
    <a href="<%=request.getContextPath()%>/physics/">Physics</a> /
    <a href="<%=request.getContextPath()%>/physics/labs/">Labs</a> /
    <span>Simple Pendulum</span>
  </nav>

  <h1 class="lab-title">Simple Pendulum</h1>

  <!-- Tabs -->
  <div id="labTabs"></div>

  <div class="lab-grid">

    <!-- Canvas area: sim always visible, graph appears alongside -->
    <div class="lab-canvas-area" id="canvasArea">
      <div class="lab-canvas-wrap" id="simPanel">
        <canvas id="simCanvas"></canvas>
      </div>
      <div class="lab-canvas-wrap lab-graph-panel" id="graphPanel">
        <canvas id="graphCanvas" width="600" height="450"></canvas>
        <canvas id="timeCanvas" width="600" height="450" style="display:none;"></canvas>
        <canvas id="energyCanvas" width="600" height="300" style="display:none;"></canvas>
        <canvas id="peWellCanvas" width="600" height="400" style="display:none;"></canvas>
      </div>
    </div>

    <!-- Sidebar -->
    <div class="lab-sidebar">
      <div id="transport"></div>
      <div id="controls"></div>
      <div id="presets"></div>
      <div id="varPicker"></div>
    </div>

  </div>

  <!-- Educational content -->
  <section class="lab-info" id="labInfo"></section>

  <!-- Cross-links -->
  <div class="lab-related">
    <span>Also try &rarr;</span>
    <a href="<%=request.getContextPath()%>/physics/labs/spring.jsp">Spring Oscillator</a>
    <a href="<%=request.getContextPath()%>/physics/labs/double-spring.jsp">Double Spring</a>
    <a href="<%=request.getContextPath()%>/physics/acceleration-calculator.jsp">Acceleration Calculator</a>
    <a href="<%=request.getContextPath()%>/physics/">All Physics Tools</a>
  </div>

  <!-- Below-content Ad -->
  <div class="ad-lab-below" id="ad_lab_below"><div class="ad-label">Advertisement</div></div>

</div>

<!-- Sticky Footer Ad -->
<div class="ad-lab-sticky" id="adLabSticky">
  <button class="ad-close" onclick="document.getElementById('adLabSticky').classList.add('ad-dismissed');try{localStorage.setItem('ad_lab_sticky_d','1')}catch(e){}">&times;</button>
  <div class="ad-label">Advertisement</div>
  <div id="ad_lab_sticky"></div>
</div>

<script type="module">
import { createLab } from './js/lab.js';
import { PendulumSim } from './js/sims/pendulum.js';

const lab = createLab(PendulumSim, {
  simCanvas:    document.getElementById('simCanvas'),
  graphCanvas:  document.getElementById('graphCanvas'),
  timeCanvas:   document.getElementById('timeCanvas'),
  energyCanvas: document.getElementById('energyCanvas'),
  peWellCanvas: document.getElementById('peWellCanvas'),
  canvasArea:   document.getElementById('canvasArea'),
  controls:     document.getElementById('controls'),
  transport:    document.getElementById('transport'),
  presets:      document.getElementById('presets'),
  tabs:         document.getElementById('labTabs'),
  varPicker:    document.getElementById('varPicker'),
});

document.getElementById('labInfo').innerHTML = PendulumSim.info || '';
</script>

<script>
(function(){
  // Hero ad — immediate
  if(typeof googletag!=='undefined'&&googletag.cmd)googletag.cmd.push(function(){googletag.display('ad_lab_hero')});
  // Below ad — lazy
  var below=document.getElementById('ad_lab_below');
  if(below&&'IntersectionObserver'in window){
    var obs=new IntersectionObserver(function(e){e.forEach(function(en){if(en.isIntersecting){if(typeof googletag!=='undefined'&&googletag.cmd)googletag.cmd.push(function(){googletag.display('ad_lab_below');below.classList.add('ad-loaded')});obs.unobserve(below)}})},{rootMargin:'200px'});
    obs.observe(below);
  }
  // Sticky ad — delayed
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
