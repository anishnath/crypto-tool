<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<jsp:include page="../../modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="States of Matter — Molecular Dynamics 3D Simulator" />
    <jsp:param name="toolCategory" value="Physics" />
    <jsp:param name="toolDescription" value="Watch molecules form a solid, liquid, or gas. Add or remove heat to drive phase changes. See the Lennard-Jones potential, pressure-temperature relationships, and molecular forces in real time. Free, no signup." />
    <jsp:param name="toolUrl" value="physics/labs/states-of-matter.jsp" />
    <jsp:param name="toolKeywords" value="states of matter, solid liquid gas, molecular dynamics, Lennard-Jones potential, phase change, intermolecular forces, kinetic theory, thermostat, pressure temperature" />
    <jsp:param name="toolImage" value="logo.png" />
    <jsp:param name="breadcrumbCategoryUrl" value="physics/" />
    <jsp:param name="educationalLevel" value="High School, Undergraduate" />
    <jsp:param name="teaches" value="states of matter, phase changes, Lennard-Jones potential, intermolecular forces, kinetic energy, temperature, pressure, molecular model" />
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

<!-- No Three.js needed — this sim uses 2D canvas via the engine -->
<style>
/* Standard engine sim — no custom container styles needed */
.som-readout{display:flex;flex-wrap:wrap;gap:10px 22px;padding:14px 18px;margin-top:10px;background:var(--lab-bg-panel);border:1px solid var(--lab-border);border-radius:var(--lab-radius,8px);font:clamp(13px,1.6vw,15px)/1.5 'Fira Code',monospace;color:var(--lab-text-sec)}
.som-readout b{color:var(--lab-text);font-size:clamp(14px,1.7vw,16px)}
.som-readout .ramp-status{width:100%;font:700 clamp(14px,1.6vw,16px) 'DM Sans',sans-serif;margin-top:4px}
.som-legends{display:flex;flex-direction:column;gap:8px;margin-top:12px}
.som-legend{display:flex;flex-wrap:wrap;align-items:center;gap:10px 24px;padding:14px 20px;background:var(--lab-bg-surface,var(--lab-bg-panel));border:1px solid var(--lab-border);border-radius:var(--lab-radius,8px);font:600 clamp(14px,1.8vw,16px)/1.4 'DM Sans',sans-serif;color:var(--lab-text);letter-spacing:.01em}
.som-legend strong{font-size:clamp(14px,1.8vw,16px);font-weight:700;min-width:55px}
.som-legend span{display:inline-flex;align-items:center;gap:8px;font-weight:500}
.som-legend span::before{content:'';display:inline-block;width:clamp(16px,2vw,20px);height:clamp(16px,2vw,20px);border-radius:50%;flex-shrink:0;box-shadow:0 1px 3px rgba(0,0,0,.2)}
.som-legend .lg-cold::before{background:#3B82F6}
.som-legend .lg-med::before{background:#22C55E}
.som-legend .lg-hot::before{background:#EF4444}
.som-legend .lg-bond::before{background:#445566;border-radius:2px;height:3px;width:20px}
.som-legend .lg-heat::before{background:linear-gradient(90deg,#2266EE,#444,#EE4422);border-radius:3px}
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
    <span>States of Matter</span>
  </nav>
  <h1 class="lab-title">States of Matter</h1>
  <div id="labTabs"></div>
  <div class="lab-grid">
    <div class="lab-canvas-area" id="canvasArea">
      <div class="lab-canvas-wrap" id="simPanel">
        <canvas id="simCanvas"></canvas>
      </div>
      <div class="lab-canvas-wrap lab-graph-panel" id="graphPanel">
        <canvas id="timeCanvas" width="600" height="450" style="display:none;"></canvas>
      </div>
    </div>
    <div class="lab-sidebar">
      <div id="transport"></div>
      <div id="controls"></div>
      <div id="presets"></div>
      <div id="dataTools"></div>
    </div>
  </div>
  <section class="lab-info" id="labInfo"></section>
  <div class="som-legends">
    <div class="som-legend">
      <strong>Particles</strong>
      <span class="lg-cold">Slow (cold)</span>
      <span class="lg-med">Medium</span>
      <span class="lg-hot">Fast (hot)</span>
      <span class="lg-bond">Bonds</span>
      <span class="lg-heat">Heat bar</span>
    </div>
  </div>
  <section class="lab-info">
    <h2>States of Matter</h2>
    <p>Watch molecules interact via the <strong>Lennard-Jones potential</strong> to form solids, liquids, and gases. Add or remove heat to drive phase transitions.</p>
    <h3>Learning Goals</h3>
    <ul>
      <li>Describe a molecular model for solids, liquids, and gases.</li>
      <li>Extend this model to phase changes.</li>
      <li>Describe how heating or cooling changes molecular behavior.</li>
      <li>Describe how changing volume affects temperature, pressure, and state.</li>
      <li>Interpret graphs of interatomic potential.</li>
      <li>Describe how forces relate to the interaction potential.</li>
      <li>Describe the physical meaning of &epsilon; and &sigma; in the Lennard-Jones potential.</li>
    </ul>
    <h3>The Lennard-Jones Potential</h3>
    <p><code>V(r) = 4&epsilon;[(&sigma;/r)&sup1;&sup2; &minus; (&sigma;/r)&sup6;]</code></p>
    <ul>
      <li><strong>&epsilon;</strong> = well depth (bond strength). Higher &epsilon; → harder to separate molecules → higher boiling point.</li>
      <li><strong>&sigma;</strong> = particle diameter. Where V(r) crosses zero.</li>
      <li><strong>r &lt; &sigma;</strong>: strong repulsion (particles can&rsquo;t overlap)</li>
      <li><strong>r &asymp; 1.12&sigma;</strong>: equilibrium (minimum energy)</li>
      <li><strong>r &gt; 2.5&sigma;</strong>: effectively zero (cutoff)</li>
    </ul>
    <h3>Try These</h3>
    <ol>
      <li><strong>Solid preset:</strong> Particles vibrate in place. Notice the lattice structure and bonds between neighbours.</li>
      <li><strong>Melt It preset:</strong> Gentle heat turns a solid into a liquid. Watch the lattice break apart and particles begin to flow.</li>
      <li><strong>Boil It preset:</strong> More heat turns a liquid into a gas. Particles fly free and fill the container.</li>
      <li><strong>Cool it down:</strong> Drag the heater left (&ldquo;❄ Cool&rdquo;) to remove energy. Watch gas condense, then freeze.</li>
      <li><strong>Compare Neon vs Water:</strong> Both are at similar temperatures, but neon is a gas while water stays liquid. Why? Water&rsquo;s &epsilon; (bond strength) is 4&times; higher.</li>
      <li><strong>Compress:</strong> Drag the lid down or lower the volume slider. Pressure rises as you crowd molecules together.</li>
      <li><strong>Pump molecules:</strong> Drag the pump handle down to inject 3 molecules per stroke. More molecules = more pressure.</li>
      <li><strong>Make it explode!</strong> Use &ldquo;Build Pressure&rdquo; preset, then pump + heat + compress. If pressure stays high for 1 second, the lid blows off! This is why pressure vessels need relief valves.</li>
      <li><strong>Return lid:</strong> After an explosion, click the yellow &ldquo;Return Lid&rdquo; button. Escaped molecules are removed.</li>
    </ol>
  </section>
  <div class="lab-related">
    <span>Also try &rarr;</span>
    <a href="<%=request.getContextPath()%>/physics/labs/molecule.jsp">Molecule Simulator</a>
    <a href="<%=request.getContextPath()%>/physics/labs/resonance.jsp">Resonance</a>
    <a href="<%=request.getContextPath()%>/physics/labs/">All Physics Labs</a>
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
import { StatesOfMatterSim } from './js/sims/states-of-matter.js';

const lab = createLab(StatesOfMatterSim, {
  simCanvas:    document.getElementById('simCanvas'),
  timeCanvas:   document.getElementById('timeCanvas'),
  canvasArea:   document.getElementById('canvasArea'),
  controls:     document.getElementById('controls'),
  transport:    document.getElementById('transport'),
  presets:      document.getElementById('presets'),
  tabs:         document.getElementById('labTabs'),
  dataTools:    document.getElementById('dataTools'),
});
document.getElementById('labInfo').innerHTML = StatesOfMatterSim.info || '';
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
