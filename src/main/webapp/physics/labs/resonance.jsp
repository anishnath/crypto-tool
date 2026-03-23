<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<jsp:include page="../../modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="Resonance Simulator — Driven Damped Oscillator 3D" />
    <jsp:param name="toolCategory" value="Physics" />
    <jsp:param name="toolDescription" value="Interactive 3D resonance simulation. Drive a spring-mass system at different frequencies and watch amplitude peak at resonance. See frequency response curves, phase relationships, transient vs steady-state. Free, no signup." />
    <jsp:param name="toolUrl" value="physics/labs/resonance.jsp" />
    <jsp:param name="toolKeywords" value="resonance simulator, driven harmonic oscillator, natural frequency, driving frequency, damping, Q factor, frequency response, phase response, spring mass system, physics simulation" />
    <jsp:param name="toolImage" value="logo.png" />
    <jsp:param name="breadcrumbCategoryUrl" value="physics/" />
    <jsp:param name="educationalLevel" value="High School, Undergraduate" />
    <jsp:param name="teaches" value="resonance, natural frequency, driving frequency, damping, Q factor, phase lag, transient behavior, steady state, energy transfer" />
    <jsp:param name="hasSteps" value="true" />
    <jsp:param name="howToSteps" value="Watch the default|The sim starts at resonance so you see large amplitude immediately,Change drive frequency|Use the Drive Freq slider to move away from resonance and watch amplitude drop,View frequency response|Switch to Freq tab to see the resonance curve with your current operating point,Try Sweep mode|Click the Sweep button to auto-ramp frequency through resonance,Adjust damping|Increase damping to see the resonance peak flatten and broaden" />
    <jsp:param name="faq1q" value="What is resonance in a spring mass system?" />
    <jsp:param name="faq1a" value="Resonance occurs when the driving frequency equals the natural frequency omega_0 equals sqrt of k over m. At resonance the system absorbs energy most efficiently from the driver and the amplitude peaks. The width of the peak depends on damping." />
    <jsp:param name="faq2q" value="What is the Q factor?" />
    <jsp:param name="faq2a" value="Q or quality factor equals omega_0 times m divided by b. High Q means a sharp narrow resonance peak and long ring time. Low Q means broad flat response. A wine glass has Q around 1000 while a car shock absorber has Q less than 1." />
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

/* Taller 3D canvas */
#simContainer { width:100%; min-height:520px; border-radius:var(--lab-radius,10px); overflow:hidden; border:1px solid var(--lab-border); }
#simContainer canvas { display:block; }

/* Readout bar */
.res-readout {
  display:flex; flex-wrap:wrap; gap:10px 22px; padding:14px 18px; margin-top:10px;
  background:var(--lab-bg-panel); border:1px solid var(--lab-border);
  border-radius:var(--lab-radius,8px);
  font:clamp(13px,1.6vw,15px)/1.5 'Fira Code',monospace; color:var(--lab-text-sec);
}
.res-readout b { color:var(--lab-text); font-size:clamp(14px,1.7vw,16px); }
.res-readout .ramp-status { width:100%; font:700 clamp(14px,1.6vw,16px) 'DM Sans',sans-serif; margin-top:4px; }

/* ─── Legends: high contrast, large, bold ─── */
.res-legends { display:flex; flex-direction:column; gap:8px; margin-top:12px; }
.res-legend {
  display:flex; flex-wrap:wrap; align-items:center;
  gap:10px 24px; padding:14px 20px;
  background:var(--lab-bg-surface,var(--lab-bg-panel));
  border:1px solid var(--lab-border);
  border-radius:var(--lab-radius,8px);
  font:600 clamp(14px,1.8vw,16px)/1.4 'DM Sans',sans-serif;
  color:var(--lab-text);
  letter-spacing:0.01em;
}
.res-legend strong {
  font-size:clamp(14px,1.8vw,16px); font-weight:700;
  min-width:60px; color:var(--lab-text);
}
.res-legend span {
  display:inline-flex; align-items:center; gap:8px;
  font-size:clamp(14px,1.8vw,16px); font-weight:500;
  color:var(--lab-text);
}
.res-legend span::before {
  content:''; display:inline-block;
  width:clamp(16px,2vw,20px); height:clamp(16px,2vw,20px);
  border-radius:4px; flex-shrink:0;
  box-shadow:0 1px 3px rgba(0,0,0,0.2);
}
/* Scene object colors */
.res-legend .lg-driver::before{background:#E86A00}
.res-legend .lg-spring::before{background:#0891B2}
.res-legend .lg-mass::before{background:#7C3AED}
.res-legend .lg-eq::before{background:#6B7280;border:1px dashed #999}
.res-legend .lg-amp::before{background:#DC2626}
/* Graph line colors */
.res-legend .lg-disp::before{background:#6D28D9}
.res-legend .lg-vel::before{background:#0E7490}
.res-legend .lg-freq::before{background:#E86A00}
.res-legend .lg-phase::before{background:#0E7490}
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
    <span>Resonance</span>
  </nav>

  <h1 class="lab-title">Resonance: Driven Damped Oscillator</h1>

  <div id="labTabs"></div>

  <div class="lab-grid">
    <div class="lab-canvas-area" id="canvasArea">
      <div class="lab-canvas-wrap" id="simPanel">
        <div id="simContainer"></div>
      </div>
      <div class="lab-canvas-wrap lab-graph-panel" id="graphPanel">
        <canvas id="freqCanvas" width="600" height="450"></canvas>
        <canvas id="timeCanvas" width="600" height="450" style="display:none;"></canvas>
        <canvas id="energyCanvas" width="600" height="300" style="display:none;"></canvas>
      </div>
    </div>
    <div class="lab-sidebar" id="sidebar"></div>
  </div>

  <div class="res-readout" id="readout"></div>

  <div class="res-legends">
    <div class="res-legend">
      <strong>Scene</strong>
      <span class="lg-driver">Driver (ω_d)</span>
      <span class="lg-spring">Spring</span>
      <span class="lg-mass">Mass</span>
      <span class="lg-eq">Equilibrium</span>
      <span class="lg-amp">Amplitude (A)</span>
    </div>
    <div class="res-legend">
      <strong>Graphs</strong>
      <span class="lg-disp">Displacement x</span>
      <span class="lg-vel">Velocity v</span>
      <span class="lg-freq">Freq. response A(ω)</span>
      <span class="lg-phase">Phase φ(ω)</span>
    </div>
  </div>

  <section class="lab-info">
    <h2>Resonance</h2>
    <p>One, two, or three spring-mass systems hang from a shared driver that oscillates at frequency ω_d. Each has independent mass, stiffness, and damping &mdash; so each has a different natural frequency ω₀ = √(k/m). When ω_d matches one system's ω₀, <strong>that one resonates wildly</strong> while the others barely move. This is the core insight of resonance: <em>same force, selective response</em>.</p>

    <h3>Sample Learning Goals</h3>
    <ul>
      <li>Explain the conditions required for resonance.</li>
      <li>Identify the variables that affect the natural frequency of a mass-spring system.</li>
      <li>Explain the distinction between driving frequency and natural frequency.</li>
      <li>Explain the distinction between transient and steady-state behavior.</li>
      <li>Identify which variables affect the duration of transient behavior.</li>
      <li>Recognize the phase relationship between driver and oscillator, especially how phase differs above and below resonance.</li>
      <li>Give examples of real-world resonance and explain why understanding it matters.</li>
    </ul>

    <h3>Key Equations</h3>
    <ul>
      <li><strong>ODE:</strong> <code>m&middot;x'' + b&middot;x' + k&middot;x = F₀&middot;cos(ω_d&middot;t)</code></li>
      <li><strong>Natural frequency:</strong> <code>ω₀ = &radic;(k/m)</code></li>
      <li><strong>Q factor:</strong> <code>Q = &radic;(km) / b</code> &mdash; higher Q = sharper resonance peak</li>
      <li><strong>Steady-state amplitude:</strong> <code>A(ω_d) = (F₀/m) / &radic;((ω₀²−ω_d²)² + (2γω_d)²)</code></li>
      <li><strong>Phase lag:</strong> <code>φ = −arctan(2γω_d / (ω₀²−ω_d²))</code></li>
    </ul>

    <h3>The Phase Flip</h3>
    <ul>
      <li><strong>Below resonance (ω_d &lt; ω₀):</strong> Mass moves nearly in phase with driver (φ &asymp; 0&deg;)</li>
      <li><strong>At resonance (ω_d = ω₀):</strong> Mass lags driver by exactly 90&deg;</li>
      <li><strong>Above resonance (ω_d &gt; ω₀):</strong> Mass is nearly anti-phase (φ &asymp; &minus;180&deg;)</li>
    </ul>

    <h3>Try These Experiments</h3>
    <ol>
      <li><strong>Find resonance:</strong> With 1 spring, slowly drag ω_d near ω₀. Watch the amplitude grow.</li>
      <li><strong>Two springs, one resonates:</strong> Switch to "2 springs". Give them different masses. Drive at one's ω₀ &mdash; it goes wild while the other barely moves. <em>Same force, selective response.</em></li>
      <li><strong>Radio Tuner (3 springs):</strong> Use the "Radio Tuner" preset. Three springs with ω₀ = 2, 3.16, and 5. Sweep the driver &mdash; each lights up in turn as ω_d passes through its resonance. This is exactly how a radio tunes stations.</li>
      <li><strong>Same ω₀, Different Q:</strong> Use "Same ω₀, Different Q" preset. Three springs with identical natural frequency but different damping. At resonance, the sharp one (low damping) has huge amplitude while the damped one barely moves. This teaches why Q factor matters.</li>
      <li><strong>Sweep mode:</strong> Click "Sweep" to auto-ramp ω_d. With 3 springs you'll see each peak up sequentially.</li>
      <li><strong>Effect of damping:</strong> Compare "No Damping" (amplitude grows without bound!) vs "Heavy Damping" (barely resonates).</li>
      <li><strong>Transient behavior:</strong> Change ω_d suddenly. The time graph shows messy transient &rarr; smooth steady-state. More damping = faster settling.</li>
      <li><strong>Energy at resonance:</strong> Switch to Energy tab. The green total line shows energy accumulating at resonance until input = dissipation.</li>
    </ol>

    <h3>Real-World Resonance</h3>
    <ul>
      <li><strong>Tacoma Narrows Bridge (1940):</strong> Wind vortices drove the bridge at its natural frequency. Amplitude grew until the bridge collapsed.</li>
      <li><strong>Wine glass shatter:</strong> High-Q resonance. A singer matching the glass's natural frequency pumps energy in faster than damping removes it.</li>
      <li><strong>Car suspension:</strong> Heavily damped (low Q) on purpose &mdash; you don't want resonance when driving over bumps.</li>
      <li><strong>Radio tuning:</strong> An LC circuit has a resonance peak. Tuning the frequency selects one station from the spectrum.</li>
      <li><strong>MRI machines:</strong> Hydrogen nuclei resonate at a specific radio frequency in a magnetic field. The resonance signal creates the image.</li>
      <li><strong>Earthquake engineering:</strong> Buildings are designed so their natural frequency doesn't match typical seismic frequencies.</li>
    </ul>
  </section>

  <div class="lab-related">
    <span>Also try &rarr;</span>
    <a href="<%=request.getContextPath()%>/physics/labs/spring.jsp">Spring Oscillator</a>
    <a href="<%=request.getContextPath()%>/physics/labs/pendulum.jsp">Simple Pendulum</a>
    <a href="<%=request.getContextPath()%>/physics/labs/ramp.jsp">Ramp: Forces &amp; Motion</a>
    <a href="<%=request.getContextPath()%>/physics/labs/">All Physics Labs</a>
  </div>

  <div class="ad-lab-below" id="ad_lab_below"><div class="ad-label">Advertisement</div></div>
</div>

<script type="module">
import { createResonanceSim } from './js/sims/resonance.js';

createResonanceSim({
  simContainer: document.getElementById('simContainer'),
  sidebar:      document.getElementById('sidebar'),
  readout:      document.getElementById('readout'),
  tabs:         document.getElementById('labTabs'),
  canvasArea:   document.getElementById('canvasArea'),
  freqCanvas:   document.getElementById('freqCanvas'),
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
