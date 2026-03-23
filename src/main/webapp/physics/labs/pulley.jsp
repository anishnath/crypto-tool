<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<jsp:include page="../../modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="Inclined Plane Pulley Simulator — Two Masses 3D" />
    <jsp:param name="toolCategory" value="Physics" />
    <jsp:param name="toolDescription" value="3D simulation of two masses connected by a rope over a pulley. One mass on an inclined plane, one hanging. Explore tension, friction, acceleration, energy. Free, no signup." />
    <jsp:param name="toolUrl" value="physics/labs/pulley.jsp" />
    <jsp:param name="toolKeywords" value="Atwood machine, inclined plane pulley, two masses, tension, friction, Newton second law, free body diagram, acceleration, physics simulation" />
    <jsp:param name="toolImage" value="logo.png" />
    <jsp:param name="breadcrumbCategoryUrl" value="physics/" />
    <jsp:param name="educationalLevel" value="High School, Undergraduate" />
    <jsp:param name="teaches" value="Newton second law, tension, friction, inclined plane, free body diagram, pulley, coupled systems, energy conservation" />
    <jsp:param name="hasSteps" value="true" />
    <jsp:param name="howToSteps" value="Watch the default|m2 pulls m1 uphill. See force arrows on both masses.,Adjust masses|Change m1 and m2 sliders to see who wins,Try Balanced preset|System is at exact equilibrium. Any small change starts motion.,View graphs|Switch to Time or Energy tabs for kinematics and energy data,Drag a mass|Click and drag either mass to reposition. Release to let physics run." />
    <jsp:param name="faq1q" value="Why is tension not equal to m2 times g?" />
    <jsp:param name="faq1a" value="Because m2 is accelerating. From m2 free body diagram T equals m2 times g minus a. Only when acceleration is zero does T equal m2g. This is the number one mistake in Atwood problems." />
    <jsp:param name="faq2q" value="When does the system not move?" />
    <jsp:param name="faq2a" value="When m2 is in the dead zone between m1 times sin theta minus mu cos theta and m1 times sin theta plus mu cos theta. Static friction adjusts to hold the system in equilibrium." />
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
  googletag.pubads().disableInitialLoad();googletag.pubads().enableSingleRequest();googletag.pubads().collapseEmptyDivs();googletag.enableServices();
});
</script>
<style>
.ad-lab-hero{text-align:center;max-width:970px;margin:0 auto 8px;min-height:50px}
.ad-lab-hero .ad-label{font-size:.55rem;text-transform:uppercase;letter-spacing:.06em;color:var(--lab-text-muted);opacity:.5;margin-bottom:4px}
#simContainer{width:100%;min-height:500px;border-radius:var(--lab-radius,10px);overflow:hidden;border:1px solid var(--lab-border)}
#simContainer canvas{display:block}
.pul-readout{display:flex;flex-wrap:wrap;gap:10px 22px;padding:14px 18px;margin-top:10px;background:var(--lab-bg-panel);border:1px solid var(--lab-border);border-radius:var(--lab-radius,8px);font:clamp(13px,1.6vw,15px)/1.5 'Fira Code',monospace;color:var(--lab-text-sec)}
.pul-readout b{color:var(--lab-text);font-size:clamp(14px,1.7vw,16px)}
.pul-readout .ramp-status{width:100%;font:700 clamp(14px,1.6vw,16px) 'DM Sans',sans-serif;margin-top:4px}
.pul-legends{display:flex;flex-direction:column;gap:8px;margin-top:12px}
.pul-legend{display:flex;flex-wrap:wrap;align-items:center;gap:10px 24px;padding:14px 20px;background:var(--lab-bg-surface,var(--lab-bg-panel));border:1px solid var(--lab-border);border-radius:var(--lab-radius,8px);font:600 clamp(14px,1.8vw,16px)/1.4 'DM Sans',sans-serif;color:var(--lab-text);letter-spacing:.01em}
.pul-legend strong{font-size:clamp(14px,1.8vw,16px);font-weight:700;min-width:55px}
.pul-legend span{display:inline-flex;align-items:center;gap:8px;font-size:clamp(14px,1.8vw,16px);font-weight:500}
.pul-legend span::before{content:'';display:inline-block;width:clamp(16px,2vw,20px);height:clamp(16px,2vw,20px);border-radius:4px;flex-shrink:0;box-shadow:0 1px 3px rgba(0,0,0,.2)}
.pul-legend .lg-m1::before{background:#D45A20}
.pul-legend .lg-m2::before{background:#10B981}
.pul-legend .lg-rope::before{background:#222}
.pul-legend .lg-pulley::before{background:#555566}
.pul-legend .lg-grav::before{background:#2255EE}
.pul-legend .lg-norm::before{background:#BBBB00;border:1px solid #888}
.pul-legend .lg-tension::before{background:#E86A00}
.pul-legend .lg-fric::before{background:#EE3333}
.pul-legend .lg-pos::before{background:#8B5CF6}
.pul-legend .lg-vel::before{background:#06B6D4}
.pul-legend .lg-acc::before{background:#F59E0B}
.pul-hint{margin-top:10px;padding:12px 18px;border-radius:var(--lab-radius,8px);background:rgba(139,92,246,.08);border:1px solid rgba(139,92,246,.15);font:600 clamp(14px,1.7vw,16px) 'DM Sans',sans-serif;color:var(--lab-text);display:flex;align-items:center;gap:10px}
.pul-hint span{font-size:clamp(18px,2.2vw,22px)}
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
    <span>Inclined Plane Pulley</span>
  </nav>
  <h1 class="lab-title">Two Masses &amp; Pulley on Inclined Plane</h1>
  <div id="labTabs"></div>
  <div class="lab-grid">
    <div class="lab-canvas-area" id="canvasArea">
      <div class="lab-canvas-wrap" id="simPanel"><div id="simContainer"></div></div>
      <div class="lab-canvas-wrap lab-graph-panel" id="graphPanel">
        <canvas id="timeCanvas" width="600" height="450"></canvas>
        <canvas id="energyCanvas" width="600" height="400" style="display:none;"></canvas>
      </div>
    </div>
    <div class="lab-sidebar" id="sidebar"></div>
  </div>
  <div class="pul-hint"><span>&#x1F446;</span> <strong>Drag either mass</strong> to reposition. They're connected — one goes up, the other goes down.</div>
  <div class="pul-readout" id="readout"></div>
  <div class="pul-legends">
    <div class="pul-legend">
      <strong>Scene</strong>
      <span class="lg-m1">m&#x2081; (ramp)</span>
      <span class="lg-m2">m&#x2082; (hanging)</span>
      <span class="lg-rope">Rope</span>
      <span class="lg-pulley">Pulley</span>
    </div>
    <div class="pul-legend">
      <strong>Forces</strong>
      <span class="lg-grav">Weight (mg)</span>
      <span class="lg-norm">Normal (N)</span>
      <span class="lg-tension">Tension (T)</span>
      <span class="lg-fric">Friction (f)</span>
    </div>
    <div class="pul-legend">
      <strong>Graphs</strong>
      <span class="lg-pos">Position s</span>
      <span class="lg-vel">Velocity v</span>
      <span class="lg-acc">Acceleration a</span>
    </div>
  </div>
  <section class="lab-info">
    <h2>Two Masses on Inclined Plane with Pulley</h2>
    <p>Mass m&#x2081; (brown) slides along a plane inclined at angle &theta;, connected by a rope over a pulley to mass m&#x2082; (green) hanging vertically. The rope is inextensible and the pulley is frictionless.</p>
    <h3>Key Equations</h3>
    <ul>
      <li><strong>Acceleration (m&#x2081; uphill):</strong> <code>a = g(m&#x2082; &minus; &mu;m&#x2081;cos&theta; &minus; m&#x2081;sin&theta;) / (m&#x2081; + m&#x2082;)</code></li>
      <li><strong>Tension:</strong> <code>T = m&#x2081;m&#x2082;g(1 + &mu;cos&theta; + sin&theta;) / (m&#x2081; + m&#x2082;)</code></li>
      <li><strong>Equilibrium when:</strong> <code>m&#x2081;(sin&theta; &minus; &mu;cos&theta;) &le; m&#x2082; &le; m&#x2081;(sin&theta; + &mu;cos&theta;)</code></li>
    </ul>
    <h3>Common Mistakes</h3>
    <ul>
      <li><strong>T &ne; m&#x2082;g:</strong> When m&#x2082; accelerates downward, T = m&#x2082;(g&minus;a) &lt; m&#x2082;g. When m&#x2081; slides downhill and m&#x2082; accelerates upward, T = m&#x2082;(g+|a|) &gt; m&#x2082;g. Only at equilibrium (a=0) does T = m&#x2082;g.</li>
      <li><strong>Friction flips:</strong> When the system reverses direction, friction on m&#x2081; flips sign. Watch the red arrow change direction!</li>
      <li><strong>Dead zone:</strong> There's a range of m&#x2082; where nothing moves. Static friction adjusts within this range.</li>
    </ul>
    <h3>Try These</h3>
    <ol>
      <li><strong>Balanced preset:</strong> System at exact equilibrium. Increase m&#x2082; by 0.1 kg and watch it start.</li>
      <li><strong>Frictionless:</strong> Pure Atwood on incline. a = g(m&#x2082; &minus; m&#x2081;sin&theta;)/(m&#x2081;+m&#x2082;).</li>
      <li><strong>Equal masses:</strong> On a 30&deg; ramp, who wins? m&#x2082; always wins since sin(30&deg;) = 0.5 &lt; 1.</li>
      <li><strong>Slides Down preset:</strong> m&#x2081; is heavy, gravity pulls it down, m&#x2082; goes up. Watch friction flip!</li>
      <li><strong>Energy tab:</strong> KE + PE + heat = constant. The green line stays flat.</li>
    </ol>
  </section>
  <div class="lab-related">
    <span>Also try &rarr;</span>
    <a href="<%=request.getContextPath()%>/physics/labs/ramp.jsp">Ramp: Forces &amp; Motion</a>
    <a href="<%=request.getContextPath()%>/physics/labs/spring.jsp">Spring Oscillator</a>
    <a href="<%=request.getContextPath()%>/physics/labs/resonance.jsp">Resonance</a>
    <a href="<%=request.getContextPath()%>/physics/labs/">All Physics Labs</a>
  </div>
</div>
<script type="module">
import { createPulleySim } from './js/sims/pulley.js';
createPulleySim({
  simContainer: document.getElementById('simContainer'),
  sidebar:      document.getElementById('sidebar'),
  readout:      document.getElementById('readout'),
  tabs:         document.getElementById('labTabs'),
  canvasArea:   document.getElementById('canvasArea'),
  timeCanvas:   document.getElementById('timeCanvas'),
  energyCanvas: document.getElementById('energyCanvas'),
});
</script>
<script>
(function(){if(typeof googletag!=='undefined'&&googletag.cmd)googletag.cmd.push(function(){googletag.display('ad_lab_hero')})})();
</script>
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=v%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
<%@ include file="../../modern/components/analytics.jsp" %>
</body>
</html>
