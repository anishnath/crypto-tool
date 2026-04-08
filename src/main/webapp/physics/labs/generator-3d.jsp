<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<jsp:include page="../../modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="3D AC Generator & Motor — Interactive Electromagnetic Induction" />
    <jsp:param name="toolCategory" value="Physics" />
    <jsp:param name="toolDescription" value="3D interactive AC/DC generator and motor simulation. Orbit the rotating coil, see magnetic field lines, current flow particles, real-time EMF waveform. Supports 3-phase, RL load, DC motor mode. Free." />
    <jsp:param name="toolUrl" value="physics/labs/generator-3d.jsp" />
    <jsp:param name="toolKeywords" value="3D generator, electromagnetic induction, Faraday law, rotating coil, magnetic field, AC generator, DC motor, commutator, three phase, interactive physics" />
    <jsp:param name="toolImage" value="logo.png" />
    <jsp:param name="breadcrumbCategoryUrl" value="physics/" />
    <jsp:param name="educationalLevel" value="High School, Undergraduate, AP Physics, Electrical Engineering" />
    <jsp:param name="teaches" value="electromagnetic induction, Faraday's law, AC generator, DC motor, commutator, 3-phase, RL load, back-EMF, torque" />
    <jsp:param name="faq1q" value="How does a 3D generator simulation help learn electromagnetic induction?" />
    <jsp:param name="faq1a" value="A 3D simulation lets you orbit around the generator and see the coil rotating inside the magnetic field from any angle. You can see the magnetic field lines passing through the coil, watch current flow particles move along the wires, and observe how the coil normal vector rotates relative to the field. This spatial understanding is difficult to get from 2D diagrams alone." />
    <jsp:param name="faq2q" value="What is the difference between the 2D and 3D generator simulations?" />
    <jsp:param name="faq2a" value="Both use the same physics equations. The 2D version focuses on graphs and quantitative analysis with Bode plots and time series. The 3D version provides spatial intuition by showing the actual geometry of the rotating coil between magnetic poles with orbit camera controls current flow animation and real-time readouts." />
</jsp:include>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;500;600;700&family=DM+Sans:wght@400;500;600&family=Fira+Code:wght@400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=v%>">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=v%>">
<link rel="stylesheet" href="css/labs.css?v=<%=v%>">

<script type="importmap">
{ "imports": {
    "three": "https://cdn.jsdelivr.net/npm/three@0.170.0/build/three.module.js",
    "three/addons/": "https://cdn.jsdelivr.net/npm/three@0.170.0/examples/jsm/"
} }
</script>

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
  googletag.pubads().disableInitialLoad();googletag.pubads().enableSingleRequest();googletag.pubads().collapseEmptyDivs();googletag.enableServices();
});
</script>
<script>(function(){var s=document.createElement('script');s.src='https://stpd.cloud/saas/5796';s.async=true;s.onerror=function(){};document.head.appendChild(s)})()</script>

<style>
.ad-lab-hero{text-align:center;max-width:970px;margin:0 auto 8px;min-height:50px}
.ad-lab-hero .ad-label,.ad-lab-below .ad-label{font-size:.55rem;text-transform:uppercase;letter-spacing:.06em;color:var(--lab-text-muted);opacity:.5;margin-bottom:4px}
.ad-lab-below{margin:20px auto 0;padding:12px 0;text-align:center;max-width:970px;min-height:50px;opacity:0;transition:opacity .4s}
.ad-lab-below.ad-loaded{opacity:1}

#simContainer { width:100%; min-height:480px; border-radius:var(--lab-radius,10px); overflow:hidden; border:1px solid var(--lab-border); }
#simContainer canvas { display:block; }

.gen3d-readout {
  display:flex; flex-wrap:wrap; gap:8px 18px; padding:12px 16px; margin-top:10px;
  background:var(--lab-bg-panel); border:1px solid var(--lab-border);
  border-radius:var(--lab-radius,8px);
  font:clamp(12px,1.5vw,14px)/1.5 'Fira Code',monospace; color:var(--lab-text-sec);
}
.gen3d-readout b { color:var(--lab-text); font-size:clamp(13px,1.6vw,15px); }

.gen3d-legend {
  display:flex; flex-wrap:wrap; align-items:center; gap:8px 20px; padding:10px 16px; margin-top:8px;
  background:var(--lab-bg-surface,var(--lab-bg-panel)); border:1px solid var(--lab-border);
  border-radius:var(--lab-radius,8px);
  font:500 clamp(12px,1.5vw,14px)/1.4 'DM Sans',sans-serif; color:var(--lab-text);
}
.gen3d-legend span { display:inline-flex; align-items:center; gap:6px; }
.gen3d-legend span::before {
  content:''; display:inline-block; width:14px; height:14px; border-radius:3px;
  box-shadow:0 1px 2px rgba(0,0,0,0.2);
}
.gen3d-legend .lg-npole::before { background:#DC2626; }
.gen3d-legend .lg-spole::before { background:#2563EB; }
.gen3d-legend .lg-coil::before { background:#06B6D4; }
.gen3d-legend .lg-normal::before { background:#22C55E; }
.gen3d-legend .lg-field::before { background:#FF4444; opacity:0.5; }
.gen3d-legend .lg-current::before { background:#FCD34D; }
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
    <span>3D Generator</span>
  </nav>

  <h1 class="lab-title">3D AC Generator & Motor</h1>

  <div class="lab-grid">
    <div class="lab-canvas-area">
      <div class="lab-canvas-wrap">
        <div id="simContainer"></div>
      </div>
    </div>
    <div class="lab-sidebar" id="sidebar"></div>
  </div>

  <div class="gen3d-readout" id="readout"></div>

  <div class="gen3d-legend">
    <span class="lg-npole">N Pole</span>
    <span class="lg-spole">S Pole</span>
    <span class="lg-coil">Coil</span>
    <span class="lg-normal">Normal (n̂)</span>
    <span class="lg-field">B Field</span>
    <span class="lg-current">Current Flow</span>
  </div>

  <section class="lab-info">
    <h2>3D AC Generator & Motor</h2>
    <p>A 3D interactive simulation of a rotating coil in a magnetic field. Orbit the camera to view from any angle.
    The same physics as the <a href="generator.jsp">2D generator</a>, but with spatial 3D visualization.</p>

    <h3>What You See</h3>
    <ul>
      <li><strong style="color:#DC2626;">Red block (N)</strong> and <strong style="color:#2563EB;">blue block (S)</strong>: magnetic pole pieces</li>
      <li><strong style="color:#FF4444;">Red arrows</strong>: magnetic field lines B from N to S</li>
      <li><strong style="color:#06B6D4;">Cyan rectangle</strong>: the rotating coil — edges change color to show current direction</li>
      <li><strong style="color:#22C55E;">Green arrow</strong>: coil normal vector n̂ — when aligned with B, flux is maximum</li>
      <li><strong style="color:#FCD34D;">Yellow dots</strong>: current flow particles — speed and brightness indicate current magnitude</li>
      <li><strong>Semi-transparent green face</strong>: brightness indicates flux through the coil</li>
    </ul>

    <h3>Controls</h3>
    <ul>
      <li><strong>Orbit:</strong> Click and drag to rotate the camera around the generator</li>
      <li><strong>Zoom:</strong> Scroll to zoom in/out</li>
      <li><strong>Pan:</strong> Right-click drag to pan</li>
      <li><strong>Sliders:</strong> Adjust field strength, turns, area, speed, load, and mode</li>
      <li><strong>Presets:</strong> Quick-switch between AC, DC, 3-phase, motor, and more</li>
    </ul>

    <h3>Try These</h3>
    <ol>
      <li><strong>Orbit to side view:</strong> See the coil edge-on at θ=90° — maximum EMF, zero flux.</li>
      <li><strong>Orbit to front view:</strong> See the coil face-on at θ=0° — zero EMF, maximum flux.</li>
      <li><strong>Watch current particles:</strong> They flow faster when current is high, dim when current is low.</li>
      <li><strong>DC Motor preset:</strong> Watch the coil spin up from rest under its own torque.</li>
      <li><strong>Change RPM:</strong> Faster rotation = higher peak EMF (visible in readout).</li>
    </ol>

    <p>For graphs (time series, phase plots, waveforms), see the <a href="generator.jsp">2D generator simulation</a>.</p>
  </section>

  <div class="lab-related">
    <span>Also try &rarr;</span>
    <a href="<%=request.getContextPath()%>/physics/labs/generator.jsp">2D Generator (with graphs)</a>
    <a href="<%=request.getContextPath()%>/physics/labs/circuit-simulator.jsp">Circuit Simulator</a>
    <a href="<%=request.getContextPath()%>/physics/labs/resonance.jsp">Resonance 3D</a>
    <a href="<%=request.getContextPath()%>/physics/labs/">All Physics Labs</a>
  </div>

  <div class="ad-lab-below" id="ad_lab_below"><div class="ad-label">Advertisement</div></div>
</div>

<script type="module">
import { createGenerator3D } from './js/sims/generator-3d.js';

createGenerator3D({
  simContainer: document.getElementById('simContainer'),
  sidebar:      document.getElementById('sidebar'),
  readout:      document.getElementById('readout'),
});
</script>

<script>
(function(){
  if(typeof googletag!=='undefined'&&googletag.cmd)googletag.cmd.push(function(){googletag.display('ad_lab_hero')});
  var below=document.getElementById('ad_lab_below');
  if(below&&'IntersectionObserver'in window){
    var obs=new IntersectionObserver(function(e){e.forEach(function(en){if(en.isIntersecting){if(typeof googletag!=='undefined'&&googletag.cmd)googletag.cmd.push(function(){googletag.display('ad_lab_below');below.classList.add('ad-loaded')});obs.unobserve(below)}})},{rootMargin:'200px'});
    obs.observe(below);
  }
})();
</script>
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=v%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
<%@ include file="../../modern/components/analytics.jsp" %>
</body>
</html>
