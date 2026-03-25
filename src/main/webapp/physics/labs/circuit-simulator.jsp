<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<jsp:include page="../../modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="Free Online Circuit Simulator — Build & Test Circuits Instantly" />
    <jsp:param name="toolCategory" value="Physics" />
    <jsp:param name="toolDescription" value="Draw electronic circuits and simulate them live in your browser. See animated current flow, voltage colors, and oscilloscope waveforms. 80+ built-in circuits: resistors, capacitors, diodes, BJTs, MOSFETs, op-amps, logic gates. No download, no signup." />
    <jsp:param name="toolUrl" value="physics/labs/circuit-simulator.jsp" />
    <jsp:param name="toolKeywords" value="circuit simulator online free, electronic circuit builder, circuit design tool, SPICE simulator, resistor calculator, RC circuit, voltage divider, diode rectifier, transistor amplifier, op-amp circuit, logic gate simulator, Ohm's law, KVL, KCL, oscilloscope, breadboard simulator" />
    <jsp:param name="toolImage" value="circuit-simulator-og.svg" />
    <jsp:param name="breadcrumbCategoryUrl" value="physics/" />
    <jsp:param name="educationalLevel" value="High School, Undergraduate, AP Physics, IB Physics, Engineering" />
    <jsp:param name="teaches" value="circuit analysis, Ohm's law, Kirchhoff's voltage law, Kirchhoff's current law, voltage dividers, series parallel circuits, RC time constant, RL circuits, RLC resonance, diode rectification, BJT amplifiers, MOSFET switching, op-amp circuits, logic gates, flip-flops, digital electronics" />
    <jsp:param name="toolFeatures" value="Draw circuits by clicking and dragging on a grid,80+ built-in example circuits across 19 categories,Live animated current flow dots showing electron direction,Voltage-to-color mapping shows potential at every node,Built-in oscilloscope with auto-scaling waveforms,37 component types including R C L diodes BJTs MOSFETs op-amps logic gates,Newton-Raphson solver for nonlinear circuits,Export as PNG image or shareable URL,Undo/redo with 50-level history,Works on desktop tablet and mobile browsers" />
    <jsp:param name="hasSteps" value="true" />
    <jsp:param name="howToSteps" value="Choose a circuit|Click Circuits menu and select from 80+ built-in examples like Voltage Divider or Common Emitter Amplifier,Or draw your own|Right-click the canvas or press a shortcut key like r for resistor then click-drag to place components,Connect with wires|Press w for wire mode and click-drag between component terminals to complete the circuit,Watch it simulate|The circuit solves instantly showing animated current dots flowing through wires and voltage colors at every node,Analyze with scope|Right-click any component and select View in Scope to see voltage and current waveforms over time,Edit values|Click any component to see its properties in the right panel and change resistance voltage capacitance etc,Export and share|Use File menu to export as PNG image or copy a shareable URL that anyone can open" />
    <jsp:param name="faq1q" value="What is a circuit simulator?" />
    <jsp:param name="faq1a" value="A circuit simulator lets you build electronic circuits virtually and test them without physical components. You draw resistors capacitors diodes transistors and other parts on a canvas, connect them with wires, and the software solves the circuit equations to show you voltages currents and waveforms in real time." />
    <jsp:param name="faq2q" value="How do I use this free online circuit simulator?" />
    <jsp:param name="faq2a" value="Right-click the canvas or press a keyboard shortcut like r for resistor or v for voltage source. Click and drag on the grid to place the component. Connect components with wires by pressing w. Add a ground with g. The circuit solves automatically showing current flow as animated dots and voltage as color gradients." />
    <jsp:param name="faq3q" value="What types of circuits can I simulate?" />
    <jsp:param name="faq3a" value="You can simulate DC circuits with resistors and batteries, AC circuits with capacitors and inductors, diode circuits including rectifiers and voltage regulators, transistor amplifiers using BJTs and MOSFETs, op-amp circuits like inverting amplifiers and filters, and digital logic circuits with AND OR NAND gates and flip-flops. Over 80 example circuits are built in." />
    <jsp:param name="faq4q" value="Is this circuit simulator free?" />
    <jsp:param name="faq4a" value="Yes, completely free with no signup required. It runs entirely in your browser with no downloads or installations needed. Works on desktop, tablet, and mobile devices." />
    <jsp:param name="faq5q" value="Can I export my circuit as an image?" />
    <jsp:param name="faq5a" value="Yes. Go to File then Export as Image PNG to download a high-resolution screenshot of your circuit. You can also use File then Share Circuit URL to get a link that anyone can open to see your exact circuit." />
    <jsp:param name="faq6q" value="Does this simulator support oscilloscope waveforms?" />
    <jsp:param name="faq6a" value="Yes. Right-click any component and select View in Scope to add voltage and current traces to the built-in oscilloscope panel. It shows real-time waveforms with auto-scaling axes, perfect for visualizing AC signals, RC charging curves, and oscillator outputs." />
</jsp:include>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;500;600;700&family=DM+Sans:wght@400;500;600&family=Fira+Code:wght@400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=v%>">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=v%>">

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
/* Ad units */
.ad-lab-hero{text-align:center;max-width:970px;margin:0 auto;min-height:50px;flex-shrink:0}
.ad-lab-hero .ad-label,.ad-lab-below .ad-label,.ad-lab-sticky .ad-label{font-size:.55rem;text-transform:uppercase;letter-spacing:.06em;color:var(--ckt-muted);opacity:.5;margin-bottom:2px}
.ad-lab-below{margin:0 auto;padding:8px 0;text-align:center;max-width:970px;min-height:50px;opacity:0;transition:opacity .4s;flex-shrink:0}
.ad-lab-below.ad-loaded{opacity:1}
.ad-lab-sticky{position:fixed;bottom:0;left:0;right:0;z-index:6000;text-align:center;padding:6px 0 8px;background:var(--ckt-panel);border-top:1px solid var(--ckt-border);box-shadow:0 -2px 12px rgba(0,0,0,.15);transform:translateY(100%);transition:transform .4s;display:none}
.ad-lab-sticky.ad-visible{display:block;transform:translateY(0)}
.ad-lab-sticky.ad-dismissed{transform:translateY(100%);pointer-events:none}
.ad-lab-sticky .ad-close{position:absolute;top:4px;right:12px;width:22px;height:22px;border:1px solid var(--ckt-border);border-radius:50%;background:var(--ckt-bg);color:var(--ckt-muted);font-size:14px;line-height:20px;text-align:center;cursor:pointer}

:root,[data-theme="dark"]{--ckt-bg:#111318;--ckt-panel:#1a1d24;--ckt-border:#2d3139;--ckt-text:#e2e8f0;--ckt-muted:#64748b;--ckt-accent:#06b6d4}
[data-theme="light"]{--ckt-bg:#f8fafc;--ckt-panel:#ffffff;--ckt-border:#e2e8f0;--ckt-text:#1e293b;--ckt-muted:#64748b;--ckt-accent:#0891b2}
*{box-sizing:border-box;margin:0;padding:0}
body{background:var(--ckt-bg);color:var(--ckt-text);font-family:'DM Sans',sans-serif;margin:0;min-height:100vh}

/* Layout */
.ckt-app{display:flex;flex-direction:column;height:100vh;padding-top:var(--header-height-desktop,72px)}
.ckt-main{display:flex;flex:1;overflow:hidden}
.ckt-canvas-wrap{flex:1;position:relative;overflow:hidden}
.ckt-canvas-wrap canvas{display:block;width:100%;height:100%}
.ckt-info{width:220px;background:var(--ckt-panel);border-left:1px solid var(--ckt-border);padding:12px;overflow-y:auto;font-size:13px}
.ckt-info .info-type{font:600 15px 'Sora',sans-serif;color:var(--ckt-accent);margin-bottom:8px;text-transform:capitalize}
.ckt-info .info-row{display:flex;justify-content:space-between;padding:3px 0;border-bottom:1px solid var(--ckt-border);font-family:'Fira Code',monospace;font-size:12px}
.ckt-info .info-row span:first-child{color:var(--ckt-muted)}
.ckt-info .info-empty{color:var(--ckt-muted);font-style:italic;padding:20px 0;text-align:center}
.ckt-info .info-section{font:600 11px 'Sora',sans-serif;color:var(--ckt-muted);text-transform:uppercase;letter-spacing:.05em;margin:12px 0 4px;padding-top:8px;border-top:1px solid var(--ckt-border)}
.ckt-info .info-section:first-of-type{border-top:none;margin-top:4px}
.ckt-info .info-edit-row{margin:4px 0}
.ckt-info .info-edit-row label{display:block;font-size:11px;color:var(--ckt-muted);margin-bottom:2px}
.ckt-info .info-input-wrap{display:flex;align-items:center;gap:4px}
.ckt-info .info-input{flex:1;padding:4px 6px;border:1px solid var(--ckt-border);border-radius:4px;background:var(--ckt-bg);color:var(--ckt-text);font:12px 'Fira Code',monospace;outline:none;transition:border-color .2s}
.ckt-info .info-input:focus{border-color:var(--ckt-accent)}
.ckt-info .info-unit{font:11px 'Fira Code',monospace;color:var(--ckt-muted);min-width:20px}

/* Menu bar */
.circuit-menu-bar{display:flex;background:var(--ckt-panel);border-bottom:1px solid var(--ckt-border);padding:0 4px;height:32px;align-items:center;gap:0;user-select:none;z-index:100;flex-shrink:0}
.circuit-menu-btn{padding:4px 12px;color:var(--ckt-text);font:500 13px 'DM Sans',sans-serif;cursor:pointer;border-radius:4px;transition:background .15s}
.circuit-menu-btn:hover{background:rgba(255,255,255,.08)}
.circuit-menu-popup{position:fixed;background:var(--ckt-panel);border:1px solid var(--ckt-border);border-radius:6px;padding:4px 0;min-width:200px;box-shadow:0 8px 24px rgba(0,0,0,.5);z-index:1100;font:13px 'DM Sans',sans-serif}
.circuit-menu-item{display:flex;align-items:center;padding:6px 16px;cursor:pointer;gap:12px;color:var(--ckt-text);transition:background .1s}
.circuit-menu-item:hover{background:rgba(6,182,212,.15)}
.circuit-menu-shortcut{margin-left:auto;color:var(--ckt-muted);font-size:11px;font-family:'Fira Code',monospace}
.circuit-menu-divider{height:1px;background:var(--ckt-border);margin:4px 8px}

/* Context menu */
.circuit-ctx-menu{position:fixed;z-index:1100}

/* Page header */
.ckt-header{padding:6px 16px;background:var(--ckt-panel);border-bottom:1px solid var(--ckt-border);flex-shrink:0}
.ckt-header h1{font:700 16px/1.3 'Sora',sans-serif;color:var(--ckt-text);margin:0}
.ckt-header p{font:13px/1.4 'DM Sans',sans-serif;color:var(--ckt-muted);margin:2px 0 0;max-width:800px}
.ckt-header p a{color:var(--ckt-accent);text-decoration:none}
.ckt-header p a:hover{text-decoration:underline}
.ckt-header strong{color:var(--ckt-text);font-weight:600}

/* Toolbar */
.ckt-toolbar{display:flex;align-items:center;gap:8px;padding:4px 12px;background:var(--ckt-panel);border-bottom:1px solid var(--ckt-border);flex-shrink:0;height:34px;font:12px 'DM Sans',sans-serif;overflow-x:auto}
.ckt-tb-btn{padding:3px 10px;border:1px solid var(--ckt-border);border-radius:4px;background:transparent;color:var(--ckt-text);font:600 12px 'DM Sans',sans-serif;cursor:pointer;transition:background .15s;white-space:nowrap}
.ckt-tb-btn:hover{background:rgba(255,255,255,.08)}
.ckt-tb-primary{background:rgba(6,182,212,.15);border-color:var(--ckt-accent);color:var(--ckt-accent)}
.ckt-tb-primary:hover{background:rgba(6,182,212,.25)}
.ckt-tb-primary.stopped{background:rgba(239,68,68,.15);border-color:#ef4444;color:#ef4444}
.ckt-tb-sep{width:1px;height:18px;background:var(--ckt-border);flex-shrink:0}
.ckt-tb-label{color:var(--ckt-muted);font-size:11px;white-space:nowrap}
.ckt-tb-slider{width:80px;accent-color:var(--ckt-accent);cursor:pointer}
.ckt-tb-value{color:var(--ckt-muted);font:11px 'Fira Code',monospace;min-width:30px}
.ckt-tb-info{color:var(--ckt-muted);font:11px 'Fira Code',monospace;margin-left:auto;white-space:nowrap}

/* Scope panel */
.ckt-scope-wrap{position:relative;height:160px;flex-shrink:0;background:#0d1017;border-top:1px solid var(--ckt-border)}
.ckt-scope-wrap canvas{display:block;width:100%;height:100%}
.ckt-scope-splitter{position:absolute;top:-4px;left:0;right:0;height:8px;cursor:row-resize;z-index:10}

/* Mobile floating component bar */
.ckt-mobile-bar{display:none;position:absolute;bottom:10px;left:50%;transform:translateX(-50%);background:var(--ckt-panel);border:1px solid var(--ckt-border);border-radius:10px;padding:4px 6px;gap:2px;z-index:50;box-shadow:0 4px 16px rgba(0,0,0,.3);flex-wrap:nowrap;overflow-x:auto;max-width:95vw}
.ckt-mobile-bar button{width:36px;height:36px;border:1px solid var(--ckt-border);border-radius:6px;background:transparent;color:var(--ckt-text);font:bold 14px sans-serif;cursor:pointer;flex-shrink:0;transition:background .15s}
.ckt-mobile-bar button:active,.ckt-mobile-bar button.active{background:rgba(6,182,212,.2);border-color:var(--ckt-accent);color:var(--ckt-accent)}
.ckt-mobile-bar button[data-cancel]{color:#ef4444;border-color:#ef4444}
@media(max-width:768px){.ckt-mobile-bar{display:flex}}
@media(min-width:769px){.ckt-mobile-bar{display:none !important}}

/* Hint bar */
.ckt-hint{position:absolute;bottom:8px;left:50%;transform:translateX(-50%);background:rgba(0,0,0,.7);color:var(--ckt-muted);padding:4px 14px;border-radius:12px;font:12px 'DM Sans',sans-serif;pointer-events:none;transition:opacity .3s}

/* Responsive */
@media(max-width:768px){
  .ckt-app{padding-top:var(--header-height-mobile,64px)}
  .ckt-header p{display:none}
  .ckt-header h1{font-size:14px}
  .ckt-info{display:none}
  .circuit-menu-btn{padding:4px 8px;font-size:12px}
  .ckt-toolbar{gap:4px;padding:3px 8px}
  .ckt-tb-slider{width:50px}
  .ckt-tb-label{display:none}
  .ckt-tb-info{display:none}
}
</style>
</head>
<body>
<%@ include file="../../modern/components/nav-header.jsp" %>

<div class="ckt-app" id="circuitApp">
  <!-- Hero Ad -->
  <div class="ad-lab-hero" id="ad_lab_hero"><div class="ad-label">Advertisement</div></div>

  <!-- Page header -->
  <div class="ckt-header">
    <h1>Circuit Simulator</h1>
    <p>Draw electronic circuits and simulate them live. Right-click to add components, see current flow as animated dots, voltage as color gradients. <strong>80+ built-in circuits</strong> — from Ohm's law to BJT amplifiers to logic gates. <a href="#" id="cktLearnMore">How to use &darr;</a></p>
  </div>

  <!-- Menu bar injected by menus.js -->
  <!-- Simulation Controls Toolbar -->
  <div class="ckt-toolbar" id="simToolbar">
    <button class="ckt-tb-btn ckt-tb-primary" id="btnRunStop" title="Run / Stop (Space)">■ Stop</button>
    <button class="ckt-tb-btn" id="btnReset" title="Reset simulation">⟲ Reset</button>
    <div class="ckt-tb-sep"></div>
    <label class="ckt-tb-label">Sim Speed</label>
    <input type="range" class="ckt-tb-slider" id="sliderSimSpeed" min="1" max="100" value="50" title="Simulation speed">
    <span class="ckt-tb-value" id="valSimSpeed">50%</span>
    <div class="ckt-tb-sep"></div>
    <label class="ckt-tb-label">Current Speed</label>
    <input type="range" class="ckt-tb-slider" id="sliderCurrentSpeed" min="1" max="100" value="50" title="Current dot animation speed">
    <span class="ckt-tb-value" id="valCurrentSpeed">50%</span>
    <div class="ckt-tb-sep"></div>
    <span class="ckt-tb-info" id="circuitInfo">t = 0.000s</span>
  </div>

  <div class="ckt-main">
    <div class="ckt-canvas-wrap">
      <canvas id="circuitCanvas"></canvas>
      <div class="ckt-hint" id="hint">Right-click or press a key (r, v, w, d...) to add components</div>
      <!-- Mobile floating toolbar (quick component buttons) -->
      <div class="ckt-mobile-bar" id="mobileBar">
        <button data-type="wire" title="Wire">━</button>
        <button data-type="resistor" title="Resistor">R</button>
        <button data-type="capacitor" title="Capacitor">C</button>
        <button data-type="dc-voltage" title="Voltage">V</button>
        <button data-type="ground" title="Ground">⏚</button>
        <button data-type="diode" title="Diode">▷</button>
        <button data-type="led" title="LED">💡</button>
        <button data-type="bjt-npn" title="NPN">T</button>
        <button data-type="opamp" title="Op-Amp">△</button>
        <button data-cancel title="Cancel">✕</button>
      </div>
    </div>
    <div class="ckt-info" id="infoPanel">
      <div class="info-empty">Click an element to see its properties</div>
    </div>
  </div>
  <!-- Scope panel (oscilloscope, hidden until a trace is added) -->
  <div class="ckt-scope-wrap" id="scopeWrap" style="display:none;">
    <div class="ckt-scope-splitter" id="scopeSplitter"></div>
    <canvas id="scopeCanvas"></canvas>
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
import { CircuitApp } from './js/circuit/ui/app.js';
const app = new CircuitApp(document.getElementById('circuitApp'));

// Hide hint after first component placed
const hint = document.getElementById('hint');
const origAdd = app._startAdd.bind(app);
app._startAdd = (type) => { hint.style.opacity = '0'; origAdd(type); };

// Mobile component bar
const mobileBar = document.getElementById('mobileBar');
if (mobileBar) {
  mobileBar.querySelectorAll('button[data-type]').forEach(btn => {
    btn.addEventListener('click', (e) => {
      e.stopPropagation();
      // Deactivate all, activate this one
      mobileBar.querySelectorAll('button').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      app._startAdd(btn.dataset.type);
    });
  });
  mobileBar.querySelector('button[data-cancel]').addEventListener('click', (e) => {
    e.stopPropagation();
    mobileBar.querySelectorAll('button').forEach(b => b.classList.remove('active'));
    app._cancelAdd();
  });
}
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
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
<%@ include file="../../modern/components/analytics.jsp" %>
</body>
</html>
