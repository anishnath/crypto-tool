<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<jsp:include page="../modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="Electronics Tools — Circuit Simulator, Arduino Emulator & Logic Gate Simulator" />
    <jsp:param name="toolCategory" value="Electronics" />
    <jsp:param name="toolDescription" value="Free online electronics tools. Build analog circuits with 60 components, write Arduino/ESP32 code on virtual hardware, or design digital logic with gates, flip-flops, truth tables, and K-maps. All browser-based, no signup." />
    <jsp:param name="toolUrl" value="electronics/" />
    <jsp:param name="toolKeywords" value="circuit simulator, arduino simulator, logic gate simulator, electronics tools, online circuit builder, arduino emulator, SPICE simulator, digital logic, truth table generator, karnaugh map, flip flop, TTL 7400, logisim online, boolean algebra" />
    <jsp:param name="breadcrumbCategoryUrl" value="electronics/" />
    <jsp:param name="toolFeatures" value="Circuit simulator with 60 components and AI generation,Arduino simulator with 6 boards and 21 components,Logic gate simulator with truth tables and K-maps,53 digital logic components including TTL ICs,Quine-McCluskey Boolean minimization,Timing diagrams and subcircuits,Monaco code editor with compile and run,Serial monitor and oscilloscope,100% browser-based no signup" />
    <jsp:param name="faq1q" value="What electronics tools are available?" />
    <jsp:param name="faq1a" value="Three tools: a Circuit Simulator for analog and digital circuits with 60 components and AI generation, an Arduino Simulator for writing and running code on 6 virtual boards (Uno ESP32 Pico), and a Logic Gate Simulator for designing digital circuits with gates flip-flops TTL ICs truth tables Karnaugh maps and Boolean algebra." />
    <jsp:param name="faq2q" value="Are these tools free?" />
    <jsp:param name="faq2a" value="Yes completely free with no signup required. All three tools run in your browser. The Circuit Simulator has 108 presets and AI generation. The Arduino Simulator compiles via arduino-cli with 33 example sketches. The Logic Gate Simulator includes 53 components 9 TTL ICs 10 preset circuits and Quine-McCluskey minimization." />
</jsp:include>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;500;600;700&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=v%>">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=v%>">

<!-- ItemList Schema -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "CollectionPage",
  "name": "Electronics Tools",
  "description": "Free online circuit simulator and Arduino emulator",
  "url": "https://8gwifi.org/electronics/",
  "mainEntity": {
    "@type": "ItemList",
    "numberOfItems": 3,
    "itemListElement": [
      {"@type":"ListItem","position":1,"name":"Circuit Simulator with AI","url":"https://8gwifi.org/physics/labs/circuit-simulator.jsp"},
      {"@type":"ListItem","position":2,"name":"Arduino & ESP32 Simulator","url":"https://8gwifi.org/electronics/arduino-simulator.jsp"},
      {"@type":"ListItem","position":3,"name":"Logic Gate Simulator","url":"https://8gwifi.org/electronics/logic-simulator.jsp"}
    ]
  }
}
</script>

<!-- GPT Ads -->
<script async src="https://securepubads.g.doubleclick.net/tag/js/gpt.js" onerror="console.warn('GPT failed')"></script>
<script>
stpd=window.stpd||{que:[]};window.googletag=window.googletag||{cmd:[]};
googletag.cmd.push(function(){
  var w=window.innerWidth;
  if(w>=992)googletag.defineSlot('/147246189,22976055811/8gwifi.org_970x90_hero_desktop',[[970,90],[728,90]],'ad_elec_hero').addService(googletag.pubads());
  else if(w>=768)googletag.defineSlot('/147246189,22976055811/8gwifi.org_728x90_hero_tablet',[[728,90]],'ad_elec_hero').addService(googletag.pubads());
  else googletag.defineSlot('/147246189,22976055811/8gwifi.org_320x100_hero_mobile',[[320,50],[320,100]],'ad_elec_hero').addService(googletag.pubads());
  if(w>=992)googletag.defineSlot('/147246189,22976055811/8gwifi.org_728x90_leaderboard_desktop',[[970,90],[728,90]],'ad_elec_below').addService(googletag.pubads());
  else googletag.defineSlot('/147246189,22976055811/8gwifi.org_320x100_leaderboard_mobile',[[320,100],[320,50]],'ad_elec_below').addService(googletag.pubads());
  googletag.pubads().disableInitialLoad();googletag.pubads().enableSingleRequest();googletag.pubads().collapseEmptyDivs();googletag.enableServices();
});
</script>
<script>(function(){var s=document.createElement('script');s.src='https://stpd.cloud/saas/5796';s.async=true;s.onerror=function(){};document.head.appendChild(s)})()</script>

<style>
:root {
  --el-bg: #0B1120;
  --el-surface: #131B2A;
  --el-border: rgba(6,182,212,0.12);
  --el-text: #E2E8F0;
  --el-text2: #94A3B8;
  --el-text3: #64748B;
  --el-accent: #06B6D4;
}
[data-theme="light"] {
  --el-bg: #F0F4F8;
  --el-surface: #FFFFFF;
  --el-border: rgba(6,182,212,0.1);
  --el-text: #1E293B;
  --el-text2: #475569;
  --el-text3: #94A3B8;
}
body { background: var(--el-bg); margin: 0; font-family: 'DM Sans', sans-serif; color: var(--el-text); }
.elec-wrap { max-width: 1000px; margin: 0 auto; padding: 84px 20px 40px; }
@media(max-width:768px) { .elec-wrap { padding-top: 76px; } }

/* Hero */
.elec-hero { text-align: center; padding: 24px 0 20px; }
.elec-hero h1 {
  font-family: 'Sora', sans-serif; font-size: 1.8rem; font-weight: 700; margin: 0 0 8px;
  background: linear-gradient(135deg, #06B6D4, #8B5CF6);
  -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;
}
.elec-hero p { color: var(--el-text2); font-size: 0.95rem; margin: 0 0 16px; max-width: 600px; margin-left: auto; margin-right: auto; }
.elec-stats { display: flex; justify-content: center; gap: 16px; flex-wrap: wrap; }
.elec-stat {
  background: var(--el-surface); border: 1px solid var(--el-border); border-radius: 8px;
  padding: 6px 16px; font-size: 0.78rem; font-weight: 600; color: var(--el-accent);
}

/* Breadcrumb */
.elec-crumb { font-size: 0.75rem; color: var(--el-text3); margin-bottom: 6px; }
.elec-crumb a { color: var(--el-text3); text-decoration: none; }
.elec-crumb a:hover { color: var(--el-accent); }

/* Cards */
.elec-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 16px; margin-top: 20px; }

.elec-card {
  display: flex; flex-direction: column; padding: 24px;
  background: var(--el-surface); border: 1px solid var(--el-border); border-radius: 14px;
  text-decoration: none; transition: all 0.25s; position: relative; overflow: hidden;
}
.elec-card:hover {
  border-color: var(--el-accent); box-shadow: 0 4px 24px rgba(6,182,212,0.15); transform: translateY(-3px);
}
.elec-card-header { display: flex; align-items: center; gap: 12px; margin-bottom: 12px; }
.elec-card-icon {
  width: 52px; height: 52px; border-radius: 12px; flex-shrink: 0;
  display: flex; align-items: center; justify-content: center;
}
.elec-card-icon svg { width: 28px; height: 28px; }
.elec-card-title { font-family: 'Sora', sans-serif; font-size: 1.15rem; font-weight: 700; color: var(--el-text); margin: 0; }
.elec-card-subtitle { font-size: 0.78rem; color: var(--el-accent); font-weight: 600; margin: 2px 0 0; }
.elec-card-desc { font-size: 0.85rem; color: var(--el-text2); line-height: 1.5; margin: 0 0 14px; }
.elec-card-features { display: flex; flex-wrap: wrap; gap: 6px; }
.elec-feature {
  font-size: 0.65rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.03em;
  padding: 2px 8px; border-radius: 4px;
}
.feat-components { background: rgba(6,182,212,0.12); color: #22D3EE; }
.feat-ai { background: rgba(139,92,246,0.12); color: #A78BFA; }
.feat-presets { background: rgba(245,158,11,0.12); color: #FBBF24; }
.feat-code { background: rgba(34,197,94,0.12); color: #34D399; }
.feat-serial { background: rgba(236,72,153,0.12); color: #F472B6; }
.feat-new { background: #06B6D4; color: #fff; }

/* Related */
.elec-related {
  display: flex; gap: 10px; flex-wrap: wrap; align-items: center;
  margin-top: 28px; font-size: 0.75rem; color: var(--el-text3);
}
.elec-related a {
  padding: 5px 12px; background: var(--el-surface); border: 1px solid var(--el-border);
  border-radius: 8px; text-decoration: none; font-size: 0.78rem; font-weight: 500;
  color: var(--el-text); transition: all 0.15s;
}
.elec-related a:hover { border-color: var(--el-accent); color: #22D3EE; }

/* Ad */
.ad-elec { text-align: center; max-width: 970px; margin: 0 auto; min-height: 50px; }
.ad-elec .ad-label { font-size: .55rem; text-transform: uppercase; letter-spacing: .06em; color: var(--el-text3); opacity: .5; margin-bottom: 4px; }
</style>
</head>
<body>
<%@ include file="../modern/components/nav-header.jsp" %>

<div class="elec-wrap">

<!-- Hero Ad -->
<div class="ad-elec" id="ad_elec_hero"><div class="ad-label">Advertisement</div></div>

<nav class="elec-crumb">
  <a href="<%=request.getContextPath()%>/">Home</a> /
  <span>Electronics</span>
</nav>

<section class="elec-hero">
  <h1>Electronics Tools</h1>
  <p>Design analog circuits with AI, run Arduino/ESP32 code on virtual hardware, build digital logic with truth tables &amp; K-maps &mdash; all in your browser</p>
  <div class="elec-stats">
    <span class="elec-stat">3 Tools</span>
    <span class="elec-stat">130+ Components</span>
    <span class="elec-stat">100% Free</span>
    <span class="elec-stat">No Signup</span>
  </div>
</section>

<!-- Tool Cards -->
<div class="elec-grid">

  <!-- Circuit Simulator -->
  <a href="<%=request.getContextPath()%>/physics/labs/circuit-simulator.jsp" class="elec-card">
    <div class="elec-card-header">
      <div class="elec-card-icon" style="background:linear-gradient(135deg,#06b6d4,#8b5cf6);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2">
          <line x1="2" y1="12" x2="6" y2="12"/>
          <polyline points="6,12 8,8 10,16 12,8 14,16 16,12"/>
          <line x1="16" y1="12" x2="22" y2="12"/>
          <circle cx="4" cy="12" r="1.5" fill="#06b6d4" stroke="none"/>
          <circle cx="20" cy="12" r="1.5" fill="#06b6d4" stroke="none"/>
        </svg>
      </div>
      <div>
        <h2 class="elec-card-title">Circuit Simulator</h2>
        <div class="elec-card-subtitle">with AI Generation</div>
      </div>
    </div>
    <p class="elec-card-desc">
      Build electronic circuits with 60 component types &mdash; resistors, capacitors, diodes, BJTs, MOSFETs, op-amps, logic gates, flip-flops, and more. Describe a circuit in plain English and AI builds it instantly. Live current animation, voltage colors, oscilloscope.
    </p>
    <div class="elec-card-features">
      <span class="elec-feature feat-components">60 Components</span>
      <span class="elec-feature feat-ai">AI Generator</span>
      <span class="elec-feature feat-presets">108 Presets</span>
      <span class="elec-feature feat-components">Oscilloscope</span>
    </div>
  </a>

  <!-- Arduino Simulator -->
  <a href="<%=request.getContextPath()%>/electronics/arduino-simulator.jsp" class="elec-card">
    <div class="elec-card-header">
      <div class="elec-card-icon" style="background:linear-gradient(135deg,#22c55e,#06b6d4);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2">
          <rect x="3" y="5" width="18" height="14" rx="2"/>
          <circle cx="7" cy="9" r="1" fill="#22c55e" stroke="none"/>
          <line x1="10" y1="9" x2="18" y2="9" stroke-width="1.5"/>
          <line x1="10" y1="12" x2="16" y2="12" stroke-width="1.5"/>
          <line x1="10" y1="15" x2="14" y2="15" stroke-width="1.5"/>
        </svg>
      </div>
      <div>
        <h2 class="elec-card-title">Arduino & ESP32 Simulator</h2>
        <div class="elec-card-subtitle">6 Boards &bull; Real CPU Emulation</div>
      </div>
    </div>
    <p class="elec-card-desc">
      Write Arduino C++ code, compile with arduino-cli, and run on virtual hardware &mdash; Arduino Uno/Nano (avr8js), Raspberry Pi Pico (rp2040js), ESP32/C3/S3 (QEMU). 21 interactive components, serial monitor, diagram.json support.
    </p>
    <div class="elec-card-features">
      <span class="elec-feature feat-code">Code Editor</span>
      <span class="elec-feature feat-components">21 Components</span>
      <span class="elec-feature feat-serial">Serial Monitor</span>
      <span class="elec-feature feat-presets">33 Sketches</span>
    </div>
  </a>

  <!-- Logic Gate Simulator -->
  <a href="<%=request.getContextPath()%>/electronics/logic-simulator.jsp" class="elec-card">
    <div class="elec-card-header">
      <div class="elec-card-icon" style="background:linear-gradient(135deg,#a78bfa,#ec4899);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2">
          <path d="M4 6h6a6 6 0 010 12H4z"/>
          <circle cx="17" cy="12" r="2"/>
          <line x1="19" y1="12" x2="22" y2="12"/>
          <line x1="1" y1="9" x2="4" y2="9"/>
          <line x1="1" y1="15" x2="4" y2="15"/>
        </svg>
      </div>
      <div>
        <h2 class="elec-card-title">Logic Gate Simulator</h2>
        <div class="elec-card-subtitle">Digital Logic &bull; Truth Tables &bull; K-Maps</div>
      </div>
    </div>
    <p class="elec-card-desc">
      Drag-and-drop AND, OR, NOT, NAND gates, flip-flops, counters, MUX, decoders, and 9 TTL ICs. Auto-generate truth tables, Karnaugh maps, minimize with Quine-McCluskey. Timing diagrams, subcircuits, expression-to-circuit synthesis.
    </p>
    <div class="elec-card-features">
      <span class="elec-feature feat-components">53 Components</span>
      <span class="elec-feature feat-ai">Truth Tables</span>
      <span class="elec-feature feat-presets">K-Maps</span>
      <span class="elec-feature feat-code">9 TTL ICs</span>
      <span class="elec-feature feat-new">New</span>
    </div>
  </a>

</div>

<!-- Below-content Ad -->
<div class="ad-elec" style="margin-top:24px;opacity:0;transition:opacity .4s;" id="ad_elec_below">
  <div class="ad-label">Advertisement</div>
</div>

<div class="elec-related">
  <span>Also try &rarr;</span>
  <a href="<%=request.getContextPath()%>/physics/labs/">Physics Labs (33 Sims)</a>
  <a href="<%=request.getContextPath()%>/physics/">All Physics Tools</a>
  <a href="<%=request.getContextPath()%>/chemistry/">Chemistry Tools</a>
  <a href="<%=request.getContextPath()%>/tutorials/dsa/">DSA Tutorials</a>
</div>

</div>

<script>
(function(){
  if(typeof googletag!=='undefined'&&googletag.cmd)googletag.cmd.push(function(){googletag.display('ad_elec_hero')});
  var below=document.getElementById('ad_elec_below');
  if(below&&'IntersectionObserver'in window){
    var obs=new IntersectionObserver(function(e){e.forEach(function(en){if(en.isIntersecting){if(typeof googletag!=='undefined'&&googletag.cmd)googletag.cmd.push(function(){googletag.display('ad_elec_below');below.style.opacity='1'});obs.unobserve(below)}})},{rootMargin:'200px'});
    obs.observe(below);
  }
})();
</script>
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=v%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
<%@ include file="../modern/components/analytics.jsp" %>
</body>
</html>
