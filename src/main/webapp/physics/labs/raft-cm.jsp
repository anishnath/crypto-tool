<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<jsp:include page="../../modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="Center of Mass: Person on a Floating Raft — 3D Simulator" />
    <jsp:param name="toolCategory" value="Physics" />
    <jsp:param name="toolDescription" value="A person walks on a floating raft. The center of mass stays fixed. Watch the raft drift as the person walks. Adjust masses and see the effect. Free 3D physics simulation." />
    <jsp:param name="toolUrl" value="physics/labs/raft-cm.jsp" />
    <jsp:param name="toolKeywords" value="center of mass, floating raft, conservation of momentum, Newton third law, person on raft, physics simulation, center of gravity" />
    <jsp:param name="toolImage" value="logo.png" />
    <jsp:param name="breadcrumbCategoryUrl" value="physics/" />
    <jsp:param name="educationalLevel" value="High School, Undergraduate" />
    <jsp:param name="teaches" value="center of mass, momentum conservation, Newton third law, isolated system, mass ratio" />
    <jsp:param name="hasSteps" value="true" />
    <jsp:param name="howToSteps" value="Watch the default|The person walks right and the raft drifts left. The red CM marker stays fixed.,Try Equal Masses|Both move the same distance in opposite directions,Try Light Raft|The raft moves MORE than the person. Surprising!,Check the graph|Switch to Time tab to see position traces. The red CM line is perfectly flat." />
    <jsp:param name="faq1q" value="Why does the raft move when the person walks?" />
    <jsp:param name="faq1a" value="Newton third law. The person pushes the raft backward while walking forward. With no external horizontal forces the center of mass stays fixed so the raft must drift opposite to the person." />
    <jsp:param name="faq2q" value="How much does the raft move?" />
    <jsp:param name="faq2a" value="Delta x raft equals negative m person over m raft times delta x person. A heavier raft moves less. A lighter raft moves more. With equal masses they move the same distance." />
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
<style>
#simContainer{width:100%;min-height:480px;border-radius:var(--lab-radius,10px);overflow:hidden;border:1px solid var(--lab-border)}
#simContainer canvas{display:block}
.raft-readout{display:flex;flex-wrap:wrap;gap:10px 22px;padding:14px 18px;margin-top:10px;background:var(--lab-bg-panel);border:1px solid var(--lab-border);border-radius:var(--lab-radius,8px);font:clamp(13px,1.6vw,15px)/1.5 'Fira Code',monospace;color:var(--lab-text-sec)}
.raft-readout b{color:var(--lab-text);font-size:clamp(14px,1.7vw,16px)}
.raft-readout .ramp-status{width:100%;font:700 clamp(14px,1.6vw,16px) 'DM Sans',sans-serif;margin-top:4px}
.raft-legends{display:flex;flex-direction:column;gap:8px;margin-top:12px}
.raft-legend{display:flex;flex-wrap:wrap;align-items:center;gap:10px 24px;padding:14px 20px;background:var(--lab-bg-surface,var(--lab-bg-panel));border:1px solid var(--lab-border);border-radius:var(--lab-radius,8px);font:600 clamp(14px,1.8vw,16px)/1.4 'DM Sans',sans-serif;color:var(--lab-text);letter-spacing:.01em}
.raft-legend strong{font-size:clamp(14px,1.8vw,16px);font-weight:700;min-width:55px}
.raft-legend span{display:inline-flex;align-items:center;gap:8px;font-size:clamp(14px,1.8vw,16px);font-weight:500}
.raft-legend span::before{content:'';display:inline-block;width:clamp(16px,2vw,20px);height:clamp(16px,2vw,20px);border-radius:4px;flex-shrink:0;box-shadow:0 1px 3px rgba(0,0,0,.2)}
.raft-legend .lg-person::before{background:#DD6633}
.raft-legend .lg-raft::before{background:#A07030}
.raft-legend .lg-water::before{background:#2288BB}
.raft-legend .lg-cm::before{background:#EF4444}
.raft-legend .lg-xperson::before{background:#DD6633}
.raft-legend .lg-xraft::before{background:#704820}
.raft-legend .lg-xcm::before{background:#EF4444}
</style>
</head>
<body style="background:var(--lab-bg-deep);margin:0;min-height:100vh;">
<%@ include file="../../modern/components/nav-header.jsp" %>
<div class="lab-wrap">
  <nav class="lab-crumb">
    <a href="<%=request.getContextPath()%>/">Home</a> /
    <a href="<%=request.getContextPath()%>/physics/">Physics</a> /
    <a href="<%=request.getContextPath()%>/physics/labs/">Labs</a> /
    <span>Center of Mass: Raft</span>
  </nav>
  <h1 class="lab-title">Center of Mass: Person on a Floating Raft</h1>
  <div id="labTabs"></div>
  <div class="lab-grid">
    <div class="lab-canvas-area" id="canvasArea">
      <div class="lab-canvas-wrap" id="simPanel"><div id="simContainer"></div></div>
      <div class="lab-canvas-wrap lab-graph-panel" id="graphPanel">
        <canvas id="timeCanvas" width="600" height="450"></canvas>
      </div>
    </div>
    <div class="lab-sidebar" id="sidebar"></div>
  </div>
  <div class="raft-readout" id="readout"></div>
  <div class="raft-legends">
    <div class="raft-legend">
      <strong>Scene</strong>
      <span class="lg-person">Person</span>
      <span class="lg-raft">Raft</span>
      <span class="lg-water">Water</span>
      <span class="lg-cm">Center of Mass</span>
    </div>
    <div class="raft-legend">
      <strong>Graphs</strong>
      <span class="lg-xperson">Person x</span>
      <span class="lg-xraft">Raft x</span>
      <span class="lg-xcm">CM x (flat!)</span>
    </div>
  </div>
  <section class="lab-info">
    <h2>Center of Mass: Person on a Floating Raft</h2>
    <p>A person walks on a raft floating on frictionless water. With no external horizontal forces, the <strong>center of mass of the system stays fixed</strong>. When the person walks right, the raft drifts left &mdash; and vice versa.</p>
    <h3>Key Equations</h3>
    <p>If the person walks a distance <code>d</code> <strong>on the raft</strong> (relative to the raft):</p>
    <p><code>&Delta;x_raft = &minus;m_person &times; d / (m_person + m_raft)</code></p>
    <p><code>&Delta;x_person_world = m_raft &times; d / (m_person + m_raft)</code></p>
    <p>The raft moves opposite to the person. The total displacement of each is scaled by the other&rsquo;s mass fraction. With <strong>equal masses</strong>, each moves half the distance walked.</p>
    <h3>Why Does This Happen?</h3>
    <ul>
      <li><strong>Newton&rsquo;s 3rd Law:</strong> The person pushes the raft backward; the raft pushes the person forward.</li>
      <li><strong>No external forces:</strong> The water is frictionless, so no horizontal force acts on the system.</li>
      <li><strong>CM conservation:</strong> m<sub>p</sub>&middot;x<sub>p</sub> + m<sub>r</sub>&middot;x<sub>r</sub> = constant.</li>
    </ul>
    <h3>Try These Experiments</h3>
    <ol>
      <li><strong>Equal Masses:</strong> Person and raft move the same distance in opposite directions. The CM is exactly halfway.</li>
      <li><strong>Light Raft:</strong> The raft moves MORE than the person walks! The floor moves out from under you.</li>
      <li><strong>Heavy Raft:</strong> Raft barely moves &mdash; like walking on solid ground.</li>
      <li><strong>Watch the graph:</strong> Switch to Time tab. The red CM line is perfectly flat &mdash; that&rsquo;s conservation in action.</li>
      <li><strong>Person walks back:</strong> When the person returns to center, the raft returns to its starting position. Net displacement = 0.</li>
    </ol>
    <h3>Real-World Applications</h3>
    <ul>
      <li><strong>Astronaut in space station:</strong> Pushing off a wall makes both astronaut and station move.</li>
      <li><strong>Gun recoil:</strong> Bullet goes forward, gun kicks backward. CM of bullet+gun stays at launch point.</li>
      <li><strong>Ice skating pairs:</strong> When one skater pushes the other, both move &mdash; the lighter one faster.</li>
      <li><strong>Rowing a boat:</strong> You push water backward, boat goes forward.</li>
    </ul>
  </section>
  <div class="lab-related">
    <span>Also try &rarr;</span>
    <a href="<%=request.getContextPath()%>/physics/labs/ramp.jsp">Ramp: Forces &amp; Motion</a>
    <a href="<%=request.getContextPath()%>/physics/labs/pulley.jsp">Inclined Plane Pulley</a>
    <a href="<%=request.getContextPath()%>/physics/labs/collide-blocks.jsp">Colliding Blocks</a>
    <a href="<%=request.getContextPath()%>/physics/labs/">All Physics Labs</a>
  </div>
</div>
<script type="module">
import { createRaftSim } from './js/sims/raft-cm.js';
createRaftSim({
  simContainer: document.getElementById('simContainer'),
  sidebar:      document.getElementById('sidebar'),
  readout:      document.getElementById('readout'),
  tabs:         document.getElementById('labTabs'),
  canvasArea:   document.getElementById('canvasArea'),
  timeCanvas:   document.getElementById('timeCanvas'),
});
</script>
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=v%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
<%@ include file="../../modern/components/analytics.jsp" %>
</body>
</html>
