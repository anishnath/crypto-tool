<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<jsp:include page="../../modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="Ramp Forces and Motion 3D Simulator — Interactive Physics Lab" />
    <jsp:param name="toolCategory" value="Physics" />
    <jsp:param name="toolDescription" value="3D inclined plane simulation. Push a block along flat ground up a ramp toward a wall. Explore force decomposition, friction, energy conservation. Three.js powered, free, no signup." />
    <jsp:param name="toolUrl" value="physics/labs/ramp.jsp" />
    <jsp:param name="toolKeywords" value="inclined plane simulator, ramp physics, force decomposition, friction, normal force, free body diagram, static friction, kinetic friction, critical angle, 3D physics simulation" />
    <jsp:param name="toolImage" value="logo.png" />
    <jsp:param name="breadcrumbCategoryUrl" value="physics/" />
    <jsp:param name="educationalLevel" value="High School, Undergraduate" />
    <jsp:param name="teaches" value="inclined plane, force decomposition, static friction, kinetic friction, normal force, Newton second law, critical angle, energy conservation" />
    <jsp:param name="hasSteps" value="true" />
    <jsp:param name="howToSteps" value="Set the ramp angle|Use the angle slider to tilt the ramp and watch the 3D scene update,Apply a force|Use the Applied Force slider or quick buttons to push the block,Watch the physics|See if the block reaches the wall or slides back,Toggle force arrows|Check Show Forces to see gravity normal and friction arrows in 3D,View graphs|Switch to Time or Energy tabs to see kinematics and energy data" />
    <jsp:param name="faq1q" value="At what angle does a block start sliding on a ramp?" />
    <jsp:param name="faq1a" value="The critical angle is theta_c equals arctan of mu_s. For mu_s of 0.5 this is about 26.6 degrees. Use the Critical Angle preset to verify." />
    <jsp:param name="faq2q" value="How much force is needed to push a block up a ramp?" />
    <jsp:param name="faq2a" value="You need enough force to overcome gravity along the ramp mg sin theta and friction mu times the normal force. Adjust the Applied Force slider and watch if the block reaches the wall." />
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
  googletag.pubads().disableInitialLoad();googletag.pubads().enableSingleRequest();googletag.pubads().collapseEmptyDivs();googletag.enableServices();
});
</script>
<script>(function(){var s=document.createElement('script');s.src='https://stpd.cloud/saas/5796';s.async=true;s.onerror=function(){};document.head.appendChild(s)})()</script>

<style>
.ad-lab-hero{text-align:center;max-width:970px;margin:0 auto 8px;min-height:50px}
.ad-lab-hero .ad-label,.ad-lab-below .ad-label{font-size:.55rem;text-transform:uppercase;letter-spacing:.06em;color:var(--lab-text-muted);opacity:.5;margin-bottom:4px}
.ad-lab-below{margin:20px auto 0;padding:12px 0;text-align:center;max-width:970px;min-height:50px;opacity:0;transition:opacity .4s}
.ad-lab-below.ad-loaded{opacity:1}

/* ─── Ramp-specific ─── */
#simContainer { width:100%; min-height:500px; border-radius:var(--lab-radius,10px); overflow:hidden; border:1px solid var(--lab-border); }
#simContainer canvas { display:block; }

.ramp-hint {
  margin-top:10px; padding:12px 18px; border-radius:var(--lab-radius,8px);
  background:rgba(139,92,246,0.08); border:1px solid rgba(139,92,246,0.15);
  font:600 clamp(14px,1.7vw,16px) 'DM Sans',sans-serif; color:var(--lab-text);
  display:flex; align-items:center; gap:10px;
}
.ramp-hint span { font-size:clamp(18px,2.2vw,22px); }

.ramp-force-bar {
  display:flex; align-items:center; gap:12px; padding:14px 18px;
  background:var(--lab-bg-panel); border:1px solid var(--lab-border);
  border-radius:var(--lab-radius,8px); margin-top:10px;
}
.ramp-force-label { font:700 clamp(14px,1.6vw,16px) 'DM Sans',sans-serif; color:#E86A00; white-space:nowrap; min-width:42px; }

.ramp-readout {
  display:flex; flex-wrap:wrap; gap:10px 22px; padding:14px 18px; margin-top:10px;
  background:var(--lab-bg-panel); border:1px solid var(--lab-border);
  border-radius:var(--lab-radius,8px);
  font:clamp(13px,1.6vw,15px)/1.5 'Fira Code',monospace; color:var(--lab-text-sec);
}
.ramp-readout b { color:var(--lab-text); font-size:clamp(14px,1.7vw,16px); }
.ramp-readout .ramp-status { width:100%; font:700 clamp(14px,1.6vw,16px) 'DM Sans',sans-serif; margin-top:4px; }

.ramp-legends { display:flex; flex-direction:column; gap:8px; margin-top:12px; }
.ramp-legend {
  display:flex; flex-wrap:wrap; align-items:center;
  gap:10px 24px; padding:14px 20px;
  background:var(--lab-bg-surface,var(--lab-bg-panel));
  border:1px solid var(--lab-border);
  border-radius:var(--lab-radius,8px);
  font:600 clamp(14px,1.8vw,16px)/1.4 'DM Sans',sans-serif;
  color:var(--lab-text);
  letter-spacing:0.01em;
}
.ramp-legend strong {
  font-size:clamp(14px,1.8vw,16px); font-weight:700;
  min-width:60px; color:var(--lab-text);
}
.ramp-legend span {
  display:inline-flex; align-items:center; gap:8px;
  font-size:clamp(14px,1.8vw,16px); font-weight:500;
  color:var(--lab-text);
}
.ramp-legend span::before {
  content:''; display:inline-block;
  width:clamp(16px,2vw,20px); height:clamp(16px,2vw,20px);
  border-radius:4px; flex-shrink:0;
  box-shadow:0 1px 3px rgba(0,0,0,0.2);
}
/* Scene objects */
.ramp-legend .lg-scene-ground::before{background:#6AAA50}
.ramp-legend .lg-scene-ramp::before{background:#C07828}
.ramp-legend .lg-scene-wall::before{background:#B85A30}
.ramp-legend .lg-scene-crate::before{background:#D4881C}
/* Force arrows */
.ramp-legend .lg-grav::before{background:#2255EE}
.ramp-legend .lg-norm::before{background:#EEEE00;border:1px solid #999}
.ramp-legend .lg-app::before{background:#F97316}
.ramp-legend .lg-fric::before{background:#EE3333}
.ramp-legend .lg-decomp::before{background:#6699FF}
.ramp-legend .lg-vel::before{background:#10B981}
.ramp-legend .lg-acc::before{background:#F59E0B}
/* Graph lines */
.ramp-legend .lg-g-pos::before{background:#8B5CF6}
.ramp-legend .lg-g-vel::before{background:#06B6D4}
.ramp-legend .lg-g-acc::before{background:#F59E0B}
.ramp-legend .lg-g-force::before{background:#EF4444}
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
    <span>Ramp: Forces &amp; Motion</span>
  </nav>

  <h1 class="lab-title">Ramp: Forces &amp; Motion</h1>

  <!-- Tabs -->
  <div id="labTabs"></div>

  <div class="lab-grid">
    <!-- Canvas area: Three.js sim + graph canvases -->
    <div class="lab-canvas-area" id="canvasArea">
      <div class="lab-canvas-wrap" id="simPanel">
        <div id="simContainer"></div>
      </div>
      <div class="lab-canvas-wrap lab-graph-panel" id="graphPanel">
        <canvas id="timeCanvas" width="600" height="450"></canvas>
        <canvas id="energyCanvas" width="600" height="300" style="display:none;"></canvas>
      </div>
    </div>

    <!-- Sidebar -->
    <div class="lab-sidebar" id="sidebar"></div>
  </div>

  <!-- Interaction hint -->
  <div class="ramp-hint">
    <span>\uD83D\uDC46</span> <strong>Crate:</strong> click &amp; drag to push (release = let go) &nbsp;|&nbsp; <strong>Ramp:</strong> click &amp; drag up/down to change angle
  </div>

  <!-- Force bar + readout below grid -->
  <div id="forceBar"></div>
  <div class="ramp-readout" id="readout"></div>

  <!-- Legends -->
  <div class="ramp-legends">
    <div class="ramp-legend">
      <strong>Scene</strong>
      <span class="lg-scene-ground">Ground</span>
      <span class="lg-scene-ramp" id="lgRamp">Ramp (wood)</span>
      <span class="lg-scene-wall">Wall (brick)</span>
      <span class="lg-scene-crate" id="lgCrate">Crate</span>
    </div>
    <div class="ramp-legend">
      <strong>Forces</strong>
      <span class="lg-grav">Weight (mg)</span>
      <span class="lg-norm">Normal (N)</span>
      <span class="lg-app">Applied (F)</span>
      <span class="lg-fric">Friction (f)</span>
      <span class="lg-decomp">mg components</span>
      <span class="lg-vel">Velocity (v)</span>
      <span class="lg-acc">Acceleration (a)</span>
    </div>
    <div class="ramp-legend">
      <strong>Graphs</strong>
      <span class="lg-g-pos">Position s</span>
      <span class="lg-g-vel">Velocity v</span>
      <span class="lg-g-acc">Acceleration a</span>
      <span class="lg-g-force">Net Force &Sigma;F</span>
    </div>
  </div>

  <section class="lab-info">
    <h2>Ramp: Forces &amp; Motion</h2>
    <p>Push a block along flat ground toward an inclined ramp. Does it reach the wall at the top? Explore how angle, mass, friction, and applied force determine the outcome.</p>

    <h3>Topics</h3>
    <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(140px,1fr));gap:8px;margin:12px 0;">
      <div style="padding:10px;border-radius:8px;background:rgba(139,92,246,0.1);border:1px solid rgba(139,92,246,0.2);">
        <strong style="color:#8B5CF6;">Force</strong>
        <p style="font-size:13px;margin-top:4px;">How forces combine on an incline &mdash; gravity decomposition, normal force, friction.</p>
      </div>
      <div style="padding:10px;border-radius:8px;background:rgba(6,182,212,0.1);border:1px solid rgba(6,182,212,0.2);">
        <strong style="color:#06B6D4;">Position</strong>
        <p style="font-size:13px;margin-top:4px;">Where the block is along the path &mdash; ground vs ramp vs wall.</p>
      </div>
      <div style="padding:10px;border-radius:8px;background:rgba(245,158,11,0.1);border:1px solid rgba(245,158,11,0.2);">
        <strong style="color:#F59E0B;">Velocity</strong>
        <p style="font-size:13px;margin-top:4px;">How fast and in which direction &mdash; sign tells uphill vs downhill.</p>
      </div>
      <div style="padding:10px;border-radius:8px;background:rgba(239,68,68,0.1);border:1px solid rgba(239,68,68,0.2);">
        <strong style="color:#EF4444;">Acceleration</strong>
        <p style="font-size:13px;margin-top:4px;">Rate of velocity change &mdash; directly proportional to net force (Newton&rsquo;s 2nd law).</p>
      </div>
    </div>

    <h3>Sample Learning Goals</h3>
    <ul>
      <li>Predict, qualitatively, how an external force will affect the speed and direction of an object&rsquo;s motion.</li>
      <li>Explain the effects with the help of a free body diagram.</li>
      <li>Use free body diagrams to draw position, velocity, acceleration and force graphs &mdash; and vice versa.</li>
      <li>Explain how the graphs relate to one another.</li>
      <li>Given a scenario or a graph, sketch all four graphs.</li>
    </ul>

    <h3>The Experiment</h3>
    <p>The block starts on flat ground. Apply a horizontal force to accelerate it. When it reaches the ramp base, its momentum carries it uphill &mdash; but gravity and friction fight back. Adjust parameters to find the minimum force needed to reach the wall.</p>

    <h3>Force Decomposition</h3>
    <p>On the ramp, the horizontal applied force and gravity both decompose into components along and perpendicular to the surface:</p>
    <ul>
      <li><strong>Gravity along ramp:</strong> <code>mg sin &theta;</code> &mdash; pulls the block downhill</li>
      <li><strong>Gravity into surface:</strong> <code>mg cos &theta;</code> &mdash; contributes to normal force</li>
      <li><strong>Applied along ramp:</strong> <code>F cos &theta;</code> &mdash; pushes uphill</li>
      <li><strong>Applied into surface:</strong> <code>F sin &theta;</code> &mdash; increases normal force (and friction!)</li>
    </ul>
    <p>Normal force: <code>N = mg cos &theta; + F sin &theta;</code></p>
    <p>Toggle <strong>"mg Decomposition"</strong> to see the light-blue decomposition arrows in 3D.</p>

    <h3>Friction: Static vs Kinetic</h3>
    <ul>
      <li><strong>Static friction</strong> adjusts to prevent motion: <code>|f<sub>s</sub>| &le; &mu;<sub>s</sub> &middot; N</code>. The readout shows what % of max static friction is used.</li>
      <li><strong>Kinetic friction</strong> acts once sliding: <code>f<sub>k</sub> = &mu;<sub>k</sub> &middot; N</code>. Since &mu;<sub>k</sub> &lt; &mu;<sub>s</sub>, once it starts moving, less force is needed to keep it going.</li>
    </ul>

    <h3>Critical Angle: <code>&theta;<sub>c</sub> = arctan(&mu;<sub>s</sub>)</code></h3>
    <p>The steepest angle at which the block stays still (no applied force). With &mu;<sub>s</sub>=0.5, this is arctan(0.5) &asymp; 26.6&deg;. Try the <strong>"Critical &theta;"</strong> preset.</p>

    <h3>How the Graphs Relate</h3>
    <ul>
      <li><strong>Force &rarr; Acceleration:</strong> <code>a = &Sigma;F / m</code> &mdash; the acceleration graph is just the force graph divided by mass. They have the same shape.</li>
      <li><strong>Acceleration &rarr; Velocity:</strong> Acceleration is the slope of velocity. Constant acceleration &rarr; velocity is a straight line.</li>
      <li><strong>Velocity &rarr; Position:</strong> Velocity is the slope of position. Constant velocity &rarr; position is a straight line. Changing velocity &rarr; position is a curve.</li>
      <li><strong>When &Sigma;F = 0:</strong> Acceleration = 0, velocity is constant, position changes linearly (or stays still if v = 0).</li>
    </ul>

    <h3>Try These Experiments</h3>
    <ol>
      <li><strong>Minimum force to reach the wall:</strong> Set angle=30&deg;, &mu;<sub>k</sub>=0.3. What&rsquo;s the smallest applied force that gets the block to the wall? Watch the Time graph to see v go to zero just as it arrives.</li>
      <li><strong>Frictionless slide:</strong> &ldquo;Frictionless&rdquo; preset. On the ramp, <code>a = g sin &theta;</code>. At 30&deg;, that&rsquo;s &asymp; 4.9 m/s&sup2;. Verify on the graph.</li>
      <li><strong>Mass doesn&rsquo;t matter:</strong> Frictionless ramp, change mass 1&ndash;50 kg. Acceleration stays the same! (Mass cancels in <code>a = g sin &theta;</code>.)</li>
      <li><strong>Read the graphs:</strong> Apply force 50N, switch to Time tab. When the block is on flat ground, the acceleration graph is constant. When it hits the ramp, acceleration drops (gravity opposes). When it stops, acceleration may flip sign. Sketch what you expect first, then check.</li>
      <li><strong>Energy conservation:</strong> Switch to Energy tab. Without friction: KE + PE = constant (green line is flat). With friction: total energy decreases &mdash; the gap is heat from friction.</li>
    </ol>
  </section>

  <div class="lab-related">
    <span>Also try &rarr;</span>
    <a href="<%=request.getContextPath()%>/physics/labs/pendulum.jsp">Simple Pendulum</a>
    <a href="<%=request.getContextPath()%>/physics/labs/spring.jsp">Spring Oscillator</a>
    <a href="<%=request.getContextPath()%>/physics/labs/collide-blocks.jsp">Colliding Blocks</a>
    <a href="<%=request.getContextPath()%>/physics/labs/brachistochrone.jsp">Brachistochrone</a>
    <a href="<%=request.getContextPath()%>/physics/">All Physics Tools</a>
  </div>

  <div class="ad-lab-below" id="ad_lab_below"><div class="ad-label">Advertisement</div></div>
</div>

<script type="module">
import { createRampSim } from './js/sims/ramp.js';

createRampSim({
  simContainer: document.getElementById('simContainer'),
  sidebar:      document.getElementById('sidebar'),
  forceBar:     document.getElementById('forceBar'),
  readout:      document.getElementById('readout'),
  tabs:         document.getElementById('labTabs'),
  canvasArea:   document.getElementById('canvasArea'),
  timeCanvas:   document.getElementById('timeCanvas'),
  energyCanvas: document.getElementById('energyCanvas'),
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
