<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<jsp:include page="../../modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="Free Online Circuit Simulator with AI — Describe a Circuit, Watch It Build" />
    <jsp:param name="toolCategory" value="Physics" />
    <jsp:param name="toolDescription" value="Build circuits with AI: type a description and get a working circuit instantly. Or draw your own with 60 component types. Live animated current flow, voltage colors, oscilloscope. 108 built-in circuits. 100% browser-based, free, no signup." />
    <jsp:param name="toolUrl" value="physics/labs/circuit-simulator.jsp" />
    <jsp:param name="toolKeywords" value="AI circuit generator, circuit simulator online free, AI build circuit, text to circuit, electronic circuit builder, circuit design tool, SPICE simulator, RC circuit, voltage divider, diode rectifier, transistor amplifier, op-amp circuit, logic gate simulator, JFET, Darlington, comparator, Schmitt trigger, Ohm's law, KVL, KCL, oscilloscope" />
    <jsp:param name="toolImage" value="circuit-simulator-og.svg" />
    <jsp:param name="breadcrumbCategoryUrl" value="physics/" />
    <jsp:param name="educationalLevel" value="High School, Undergraduate, AP Physics, IB Physics, Engineering" />
    <jsp:param name="teaches" value="circuit analysis, Ohm's law, Kirchhoff's voltage law, Kirchhoff's current law, voltage dividers, series parallel circuits, RC time constant, RL circuits, RLC resonance, diode rectification, BJT amplifiers, MOSFET switching, op-amp circuits, logic gates, flip-flops, digital electronics" />
    <jsp:param name="toolFeatures" value="AI circuit generator: describe a circuit in plain English and it builds automatically,60 component types: resistors capacitors diodes BJTs MOSFETs JFETs Darlington op-amps comparators Schmitt triggers logic gates flip-flops counters adders,108 built-in example circuits across 19 categories,Live animated current flow dots showing electron direction,Voltage-to-color mapping shows potential at every node,Built-in oscilloscope with auto-scaling waveforms,Newton-Raphson solver for nonlinear circuits,Export as PNG image or shareable URL,Undo/redo with 50-level history,Works on desktop tablet and mobile browsers" />
    <jsp:param name="hasSteps" value="true" />
    <jsp:param name="howToSteps" value="Use AI to build a circuit|Click the AI button in the menu bar and type a description like inverting op-amp with gain -10 then press Generate. The circuit appears on the canvas ready to simulate,Or choose a preset|Click Circuits menu and select from 108 built-in examples like Voltage Divider or Common Emitter Amplifier,Or draw your own|Right-click the canvas or press a shortcut key like r for resistor then click-drag to place components,Connect with wires|Press w for wire mode and click-drag between component terminals to complete the circuit,Watch it simulate|The circuit solves instantly showing animated current dots flowing through wires and voltage colors at every node,Analyze with scope|Click Options then Show Scope or right-click any component and select View in Scope to see voltage and current waveforms,Edit values|Click any component to see its properties in the right panel and change resistance voltage capacitance etc,Export and share|Use File menu to export as PNG image or copy a shareable URL that anyone can open" />
    <jsp:param name="faq1q" value="How does the AI circuit generator work?" />
    <jsp:param name="faq1a" value="Click the AI button in the menu bar and describe any circuit in plain English, like inverting op-amp with gain of -10 or RC low-pass filter with 10k and 100nF. The AI generates a complete working circuit with correct component values and wiring. It supports 60 component types including resistors, capacitors, diodes, BJTs, MOSFETs, JFETs, op-amps, logic gates, flip-flops, counters, and more." />
    <jsp:param name="faq2q" value="What is a circuit simulator?" />
    <jsp:param name="faq2a" value="A circuit simulator lets you build electronic circuits virtually and test them without physical components. You draw resistors capacitors diodes transistors and other parts on a canvas, connect them with wires, and the software solves the circuit equations using Modified Nodal Analysis to show you voltages currents and waveforms in real time." />
    <jsp:param name="faq3q" value="What types of circuits can I simulate?" />
    <jsp:param name="faq3a" value="You can simulate DC circuits with resistors and batteries, AC circuits with capacitors and inductors, diode circuits including rectifiers and voltage regulators, transistor amplifiers using BJTs MOSFETs and JFETs, Darlington pairs, op-amp circuits like inverting amplifiers and comparators, Schmitt triggers, 555 timers, and digital logic circuits with gates flip-flops counters shift registers multiplexers and adders. 108 example circuits are built in and AI can generate any circuit you describe." />
    <jsp:param name="faq4q" value="Is this circuit simulator free?" />
    <jsp:param name="faq4a" value="Yes, completely free with no signup required. The simulator and all 108 preset circuits run entirely in your browser. The AI circuit generator is also free with a rate limit of 5 generations per hour. Works on desktop, tablet, and mobile devices." />
    <jsp:param name="faq5q" value="What AI prompts work best for generating circuits?" />
    <jsp:param name="faq5a" value="Be specific about component values and topology. Good examples: LED with 330 ohm resistor powered by 5V, inverting op-amp amplifier with gain of -10, NPN BJT switch driving LED with 10k base resistor, RLC series resonance R=100 L=10mH C=10nF, SR latch using two NAND gates. Simple circuits like filters and dividers generate perfectly. Complex multi-transistor circuits may need minor wiring adjustments." />
    <jsp:param name="faq6q" value="Can I export my circuit as an image or share it?" />
    <jsp:param name="faq6a" value="Yes. Go to File then Export as Image PNG to download a high-resolution screenshot. Use File then Share Circuit URL to get a link that anyone can open to see your exact circuit with all component values preserved. AI-generated circuits can also be exported and shared the same way." />
</jsp:include>
<!-- Fonts: preload then swap (non-blocking) -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="preload" as="style" href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700&family=DM+Sans:wght@400;500;600&family=Fira+Code:wght@400;500&display=swap" onload="this.onload=null;this.rel='stylesheet'">
<noscript><link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700&family=DM+Sans:wght@400;500;600&family=Fira+Code:wght@400;500&display=swap" rel="stylesheet"></noscript>

<!-- CSS: defer non-critical nav/theme -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=v%>" media="print" onload="this.media='all'">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=v%>" media="print" onload="this.media='all'">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ai-vision-modal.css?v=<%=v%>" media="print" onload="this.media='all'">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ai-progress-bar.css?v=<%=v%>" media="print" onload="this.media='all'">

<!-- GPT Ads: defer to after LCP -->
<script>
window.googletag=window.googletag||{cmd:[]};
window.addEventListener('load',function(){
  var g=document.createElement('script');g.src='https://securepubads.g.doubleclick.net/tag/js/gpt.js';g.async=true;document.head.appendChild(g);
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
  var s=document.createElement('script');s.src='https://stpd.cloud/saas/5796';s.async=true;document.head.appendChild(s);
});
</script>

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
.circuit-menu-ai{color:#c7d2fe;background:linear-gradient(135deg,rgba(99,102,241,.2),rgba(139,92,246,.2));border:1px solid rgba(99,102,241,.3);border-radius:4px;padding:3px 10px;font-weight:600}
.circuit-menu-ai:hover{background:linear-gradient(135deg,rgba(99,102,241,.35),rgba(139,92,246,.35));color:#e0e7ff}
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
/* AI panel — hidden by default, opened from menu bar "🤖 AI" button */
.ckt-ai-panel{display:none;flex-direction:column;flex-shrink:0}
.ckt-ai-panel.open{display:flex}
.ckt-ai-bar{display:flex;align-items:center;gap:8px;padding:4px 12px;background:linear-gradient(90deg,rgba(99,102,241,.08),rgba(6,182,212,.08));border-bottom:1px solid var(--ckt-border);flex-shrink:0;height:36px;font:12px 'DM Sans',sans-serif}
.ckt-ai-input{flex:1;min-width:0;padding:4px 10px;border:1px solid rgba(99,102,241,.3);border-radius:6px;background:rgba(0,0,0,.2);color:var(--ckt-text);font:12px 'DM Sans',sans-serif;outline:none;transition:border-color .2s}
.ckt-ai-input:focus{border-color:#6366f1}
.ckt-ai-input::placeholder{color:var(--ckt-muted);font-size:11px}
.ckt-ai-btn{padding:4px 14px;border:none;border-radius:6px;background:#6366f1;color:#fff;font:600 12px 'DM Sans',sans-serif;cursor:pointer;white-space:nowrap;transition:background .15s}
.ckt-ai-btn:hover{background:#4f46e5}
.ckt-ai-btn:disabled{opacity:.5;cursor:wait}
.ckt-ai-img-btn{padding:4px 8px;border:1px solid rgba(99,102,241,.35);border-radius:6px;background:transparent;color:#a5b4fc;font-size:14px;cursor:pointer;line-height:1;transition:all .15s}
.ckt-ai-img-btn:hover{background:rgba(99,102,241,.15);color:#c7d2fe;border-color:#6366f1}
.ckt-ai-progress-slot{padding:0 12px}
.ckt-ai-progress-slot:empty{display:none}
/* Stage-2 overlay shown after vision completes, while text→netlist runs */
.ckt-stage2{position:fixed;inset:0;background:rgba(8,10,14,.72);display:none;align-items:center;justify-content:center;z-index:1000;backdrop-filter:blur(2px)}
.ckt-stage2.open{display:flex}
.ckt-stage2-card{width:min(92vw,480px);background:#151821;border:1px solid rgba(99,102,241,.3);border-radius:12px;padding:22px;box-shadow:0 20px 60px rgba(0,0,0,.5);color:var(--ckt-text);font:13px 'DM Sans',sans-serif}
.ckt-stage2-step{font-size:11px;text-transform:uppercase;letter-spacing:.08em;color:#a5b4fc;margin-bottom:6px}
.ckt-stage2-title{font:600 16px 'Sora',sans-serif;margin:0 0 4px}
.ckt-stage2-subtitle{color:var(--ckt-muted);margin:0 0 14px;font-size:12px}
.ckt-stage2-desc{background:rgba(99,102,241,.06);border:1px solid rgba(99,102,241,.15);border-radius:6px;padding:10px 12px;font-size:12px;line-height:1.45;color:#cbd5e1;max-height:110px;overflow:auto;margin-bottom:14px}
.ckt-stage2-progress{margin-bottom:14px}
.ckt-stage2-actions{display:flex;justify-content:flex-end}
.ckt-stage2-cancel{padding:6px 14px;border:1px solid rgba(148,163,184,.3);border-radius:6px;background:transparent;color:var(--ckt-muted);font:500 12px 'DM Sans',sans-serif;cursor:pointer}
.ckt-stage2-cancel:hover{color:#ef4444;border-color:#ef4444}
/* Unlock / contact notice (AI bar + stage-2 overlay use the same look) */
.ckt-ai-upsell{padding:3px 12px;background:rgba(99,102,241,.05);border-bottom:1px solid var(--ckt-border);color:var(--ckt-muted);font:11px 'DM Sans',sans-serif;display:flex;align-items:center;gap:6px}
.ckt-ai-upsell a{color:#a5b4fc;text-decoration:none;font-weight:500}
.ckt-ai-upsell a:hover{color:#c7d2fe;text-decoration:underline}
.ckt-stage2-upsell{margin-top:4px;padding:8px 10px;background:rgba(99,102,241,.06);border:1px solid rgba(99,102,241,.15);border-radius:6px;font-size:11px;color:var(--ckt-muted)}
.ckt-stage2-upsell a{color:#a5b4fc;text-decoration:none;font-weight:500}
.ckt-stage2-upsell a:hover{text-decoration:underline}
.ckt-ai-close{padding:2px 8px;border:none;background:transparent;color:var(--ckt-muted);font-size:16px;cursor:pointer;line-height:1}
.ckt-ai-close:hover{color:#ef4444}
.ckt-ai-status{font-size:11px;white-space:nowrap;flex-shrink:0;min-width:0;overflow:hidden;text-overflow:ellipsis}
.ckt-ai-status.loading{color:#a78bfa}
.ckt-ai-status.success{color:#22c55e}
.ckt-ai-status.error{color:#ef4444}
.ckt-ai-status.warning{color:#f59e0b}
.ckt-ai-examples{display:flex;align-items:center;gap:6px;padding:3px 12px;background:rgba(99,102,241,.04);border-bottom:1px solid var(--ckt-border);flex-shrink:0;overflow-x:auto;scrollbar-width:none}
.ckt-ai-examples::-webkit-scrollbar{display:none}
.ckt-ai-examples-label{color:var(--ckt-muted);font:11px 'DM Sans',sans-serif;white-space:nowrap;flex-shrink:0}
.ckt-ai-chip{padding:2px 10px;border:1px solid rgba(99,102,241,.25);border-radius:12px;background:transparent;color:#a5b4fc;font:11px 'DM Sans',sans-serif;cursor:pointer;white-space:nowrap;transition:all .15s;flex-shrink:0}
.ckt-ai-chip:hover{background:rgba(99,102,241,.15);border-color:#6366f1;color:#c7d2fe}
/* Canvas toast notification */
.ckt-toast{position:absolute;top:12px;left:50%;transform:translateX(-50%) translateY(-20px);padding:8px 20px;border-radius:8px;font:600 13px 'DM Sans',sans-serif;z-index:200;opacity:0;transition:opacity .3s,transform .3s;pointer-events:none;white-space:nowrap;max-width:90%;overflow:hidden;text-overflow:ellipsis;box-shadow:0 4px 16px rgba(0,0,0,.3)}
.ckt-toast.show{opacity:1;transform:translateX(-50%) translateY(0)}
.ckt-toast-success{background:rgba(22,163,74,.9);color:#fff;border:1px solid #22c55e}
.ckt-toast-warning{background:rgba(180,83,9,.9);color:#fff;border:1px solid #f59e0b}
.ckt-toast-error{background:rgba(185,28,28,.9);color:#fff;border:1px solid #ef4444}
.ckt-toast-info{background:rgba(30,41,59,.9);color:#e2e8f0;border:1px solid #475569}
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
/* Mobile component bar — vertical strip on left side of canvas */
.ckt-mobile-bar{display:none;position:absolute;top:4px;left:4px;flex-direction:column;background:var(--ckt-panel);border:1px solid var(--ckt-border);border-radius:8px;padding:3px;gap:2px;z-index:50;box-shadow:0 2px 12px rgba(0,0,0,.25);overflow-y:auto;max-height:calc(100% - 8px)}
.ckt-mobile-bar button{width:32px;height:32px;border:1px solid var(--ckt-border);border-radius:5px;background:transparent;color:var(--ckt-text);font:bold 13px sans-serif;cursor:pointer;flex-shrink:0;transition:background .15s}
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
  .ckt-ai-examples{display:none}
  .ckt-ai-input{font-size:16px}
  .ckt-ai-bar{height:auto;padding:6px 8px}
  .circuit-menu-ai{font-size:11px;padding:4px 6px}
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
    <h1>Circuit Simulator with AI</h1>
    <p>Describe a circuit and AI builds it, or draw your own with 60 components. Live current animation, voltage colors, oscilloscope. <strong>108 built-in circuits</strong> &amp; <strong>AI generator</strong>. <a href="#" id="cktLearnMore">How to use &darr;</a></p>
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

  <!-- AI Circuit Generator (panel hidden by default) -->
  <div class="ckt-ai-panel" id="aiPanel">
    <div class="ckt-ai-bar" id="aiBar">
      <input type="text" class="ckt-ai-input" id="aiInput" placeholder="Describe a circuit... e.g. &quot;inverting op-amp with gain -10&quot;" maxlength="500" autocomplete="off">
      <button class="ckt-ai-btn" id="aiGenerate">Generate</button>
      <button class="ckt-ai-img-btn" id="aiFromImage" title="Upload a circuit image (schematic, sketch, photo)" aria-label="Generate from image">📷</button>
      <button class="ckt-ai-close" id="aiClose" title="Close">&times;</button>
      <span class="ckt-ai-status" id="aiStatus"></span>
    </div>
    <div class="ckt-ai-progress-slot" id="aiProgressSlot"></div>
    <div class="ckt-ai-examples" id="aiExamples">
      <span class="ckt-ai-examples-label">Try:</span>
      <button class="ckt-ai-chip" data-prompt="LED with 330 ohm resistor powered by 5V">LED Circuit</button>
      <button class="ckt-ai-chip" data-prompt="Voltage divider with 10k and 5k resistors, 9V battery">Voltage Divider</button>
      <button class="ckt-ai-chip" data-prompt="RC low-pass filter, R=10k, C=100nF, AC source at 1kHz">RC Filter</button>
      <button class="ckt-ai-chip" data-prompt="Inverting op-amp amplifier with gain of -10, 1kHz AC input">Op-Amp Inverter</button>
      <button class="ckt-ai-chip" data-prompt="NPN BJT switch driving LED, base through 10k from 5V, Vcc=9V">BJT Switch</button>
      <button class="ckt-ai-chip" data-prompt="Half-wave rectifier with diode, 100uF smoothing cap, 1k load">Rectifier</button>
      <button class="ckt-ai-chip" data-prompt="Zener regulator: 12V input, 5.1V zener, 470 ohm series resistor">Zener Regulator</button>
      <button class="ckt-ai-chip" data-prompt="RLC series resonance: R=100, L=10mH, C=10nF, AC source">RLC Resonance</button>
      <button class="ckt-ai-chip" data-prompt="SR latch using two cross-coupled NAND gates">SR Latch</button>
      <button class="ckt-ai-chip" data-prompt="D flip-flop with 2Hz clock input">D Flip-Flop</button>
    </div>
    <div class="ckt-ai-upsell">
      <span>💎 Want higher limits / faster AI? Contact</span>
      <a href="https://x.com/anish2good" target="_blank" rel="noopener noreferrer">@anish2good on X</a>
    </div>
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

<!-- Stage-2 overlay: shown after vision completes, while qwen builds the netlist -->
<div class="ckt-stage2" id="stage2Overlay" role="dialog" aria-modal="true" aria-labelledby="stage2Title">
  <div class="ckt-stage2-card">
    <div class="ckt-stage2-step">Step 2 of 2</div>
    <h3 class="ckt-stage2-title" id="stage2Title">Building circuit from image…</h3>
    <p class="ckt-stage2-subtitle">Translating the description into a simulator netlist. Typical time ~4 min.</p>
    <div class="ckt-stage2-desc" id="stage2Desc"></div>
    <div class="ckt-stage2-progress" id="stage2ProgressSlot"></div>
    <div class="ckt-stage2-upsell">
      💎 Want higher limits / faster AI? Contact
      <a href="https://x.com/anish2good" target="_blank" rel="noopener noreferrer">@anish2good on X</a>.
    </div>
    <div class="ckt-stage2-actions">
      <button type="button" class="ckt-stage2-cancel" id="stage2Cancel">Hide</button>
    </div>
  </div>
</div>

<script type="module">
import { CircuitApp } from './js/circuit/ui/app.js';
import { AI_SYSTEM_PROMPT, buildUserPrompt, CIRCUIT_VISION_PROMPT, buildVisionUserPrompt } from './js/circuit/ai-prompt.js';
import { parseNetlist } from './js/circuit/netlist.js';
import { validateCircuitInput } from './js/circuit/validation.js';
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

// ── Canvas Toast Notification ──
function showCanvasToast(message, type, duration) {
  const existing = document.getElementById('cktToast');
  if (existing) existing.remove();
  const toast = document.createElement('div');
  toast.id = 'cktToast';
  toast.className = 'ckt-toast ckt-toast-' + (type || 'info');
  toast.textContent = message;
  const canvasWrap = document.querySelector('.ckt-canvas-wrap');
  if (canvasWrap) canvasWrap.appendChild(toast);
  else document.body.appendChild(toast);
  requestAnimationFrame(() => toast.classList.add('show'));
  setTimeout(() => {
    toast.classList.remove('show');
    setTimeout(() => toast.remove(), 300);
  }, duration || 4000);
}

// ── AI Circuit Generator ──
const aiPanel = document.getElementById('aiPanel');
const aiClose = document.getElementById('aiClose');
const aiInput = document.getElementById('aiInput');
const aiBtn = document.getElementById('aiGenerate');
const aiImgBtn = document.getElementById('aiFromImage');
const aiStatus = document.getElementById('aiStatus');
const aiProgressSlot = document.getElementById('aiProgressSlot');
const stage2Overlay = document.getElementById('stage2Overlay');
const stage2Desc = document.getElementById('stage2Desc');
const stage2ProgressSlot = document.getElementById('stage2ProgressSlot');
const stage2Cancel = document.getElementById('stage2Cancel');
const AI_CTX = '<%=request.getContextPath()%>';

// Close button
aiClose.addEventListener('click', () => {
  aiPanel.classList.remove('open');
});

function setAiStatus(text, cls) {
  aiStatus.textContent = text;
  aiStatus.className = 'ckt-ai-status' + (cls ? ' ' + cls : '');
}

// Shared stage-2: description → elements (throws user-facing errors).
// Used by both the text-prompt path and the image → vision → text chain.
async function descriptionToElements(desc) {
  const resp = await fetch(AI_CTX + '/ai', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      stream: false,
      messages: [
        { role: 'system', content: AI_SYSTEM_PROMPT },
        { role: 'user',   content: buildUserPrompt(desc) },
      ],
    }),
  });

  if (resp.status === 429) throw new Error('Rate limit — try again later');
  if (resp.status === 401) throw new Error('Auth error — please reload');
  if (!resp.ok) {
    const data = await resp.json().catch(() => ({}));
    throw new Error(data.error || 'Server error (' + resp.status + ')');
  }

  const data = await resp.json();
  const content = (data?.message?.content ?? data?.response ?? '').trim();
  if (!content) throw new Error('Empty response from AI');
  if (/^error\s+unclear_request\b/i.test(content)) {
    throw new Error('AI could not understand the request — try rewording');
  }

  let elements;
  try {
    elements = parseNetlist(content).elements;
  } catch (err) {
    console.error('netlist parse failed. raw content:\n' + content);
    throw new Error('Could not parse AI output — try rewording');
  }

  // Auto-insert source / ground if missing.
  const types = elements.map(e => e.type);
  if (!types.some(t => ['dc-voltage','ac-voltage','dc-current','clock'].includes(t))) {
    elements.unshift({ type: 'dc-voltage', x1: 0, y1: 6, x2: 0, y2: 0, params: { voltage: 5 } });
  }
  if (!types.includes('ground')) {
    let maxY = 0;
    for (const e of elements) { maxY = Math.max(maxY, e.y1 || 0, e.y2 || 0); }
    elements.push({ type: 'ground', x1: 0, y1: maxY, x2: 0, y2: maxY });
  }
  return elements;
}

// Phases for the text → netlist call.  Typical cold-start is ~4 min, warm
// runs are 10–30 s — AIProgressBar will complete smoothly either way because
// the fill clamps at 95 % until success triggers the jump to 100 %.
const CIRCUIT_PROGRESS_PHASES = [
  { pct: 10, ms: 3000,   label: 'Sending description...' },
  { pct: 25, ms: 20000,  label: 'Planning circuit...' },
  { pct: 45, ms: 60000,  label: 'Placing components...' },
  { pct: 65, ms: 120000, label: 'Wiring connections...' },
  { pct: 80, ms: 180000, label: 'Finalizing netlist...' },
  { pct: 90, ms: 220000, label: 'Almost done...' },
];
const CIRCUIT_PROGRESS_ESTIMATE_MS = 240000; // 4 min

function attachCircuitProgress() {
  if (!window.AIProgressBar || !aiProgressSlot) return null;
  const bar = window.AIProgressBar.attach(aiProgressSlot, {
    estimatedMs: CIRCUIT_PROGRESS_ESTIMATE_MS,
    phases: CIRCUIT_PROGRESS_PHASES,
  });
  bar.start();
  return bar;
}

// Opens the centered "Step 2 of 2" overlay with the same AIProgressBar so the
// user sees continuity between the vision modal closing and the circuit
// appearing.  Returns a handle mirroring AIProgressBar: {stop, destroy}.
function openStage2Overlay(description) {
  if (!stage2Overlay) return null;
  if (stage2Desc) {
    const preview = (description || '').slice(0, 280);
    stage2Desc.textContent = preview + ((description || '').length > 280 ? '…' : '');
  }
  // Clear any residue from a previous run.
  if (stage2ProgressSlot) stage2ProgressSlot.innerHTML = '';
  stage2Overlay.classList.add('open');

  let bar = null;
  if (window.AIProgressBar && stage2ProgressSlot) {
    bar = window.AIProgressBar.attach(stage2ProgressSlot, {
      estimatedMs: CIRCUIT_PROGRESS_ESTIMATE_MS,
      phases: CIRCUIT_PROGRESS_PHASES,
    });
    bar.start();
  }
  return {
    stop: (ok) => { if (bar) bar.stop(ok); },
    destroy: () => {
      if (bar) bar.destroy();
      stage2Overlay.classList.remove('open');
    },
  };
}

// "Hide" just dismisses the overlay — the underlying fetch keeps running,
// the result still loads into the simulator when it arrives.
if (stage2Cancel) {
  stage2Cancel.addEventListener('click', () => stage2Overlay.classList.remove('open'));
}

// Text path — user types a description.
async function generateCircuit() {
  const desc = aiInput.value.trim();
  if (!desc) { setAiStatus('Enter a description', 'error'); return; }

  const valErr = validateCircuitInput(desc);
  if (valErr) { setAiStatus(valErr, 'error'); return; }

  aiBtn.disabled = true;
  aiInput.disabled = true;
  if (aiImgBtn) aiImgBtn.disabled = true;
  setAiStatus('Generating circuit...', 'loading');

  const progress = attachCircuitProgress();
  const t0 = Date.now();
  try {
    const elements = await descriptionToElements(desc);
    app.loadFromElements(elements);
    const time = ((Date.now() - t0) / 1000).toFixed(1) + 's';
    const statusMsg = 'Circuit (' + elements.length + ' elements) in ' + time;
    setAiStatus('✓ ' + statusMsg, 'success');
    showCanvasToast('✓ ' + statusMsg, 'success', 3000);
    if (progress) progress.stop(true);
  } catch (e) {
    console.error('AI circuit error:', e);
    if (e.name === 'TypeError' && String(e.message).includes('fetch')) {
      setAiStatus('Network error — check connection', 'error');
    } else {
      setAiStatus(e.message || 'Unknown error', 'error');
    }
    if (progress) progress.stop(false);
  } finally {
    if (progress) setTimeout(() => progress.destroy(), 1500);
    aiBtn.disabled = false;
    aiInput.disabled = false;
    if (aiImgBtn) aiImgBtn.disabled = false;
    aiInput.focus();
  }
}

// Image path — opens AIVisionModal (gemma vision), chains to qwen text model
// to produce the netlist.  Mirrors the video/captions + 3D-modeler pattern:
// phased AIProgressBar timer, server-chosen model, no client-side model field.
function generateFromImage() {
  if (typeof window.AIVisionModal === 'undefined') {
    setAiStatus('Image module still loading — try again in a moment', 'error');
    return;
  }
  // Two-stage UX: vision ~2 min + circuit ~4 min = ~6 min total.
  // Use shorter vision phases than the AIVisionModal default (6 min), then
  // hand off to the same 4-min AIProgressBar the text path uses.
  window.AIVisionModal.open({
    title: 'Image to Circuit',
    subtitle: 'Upload a schematic, sketch, or photo — AI will rebuild it as a simulator circuit. Typical total time ~6 min.',
    ctx: AI_CTX,
    systemPrompt: CIRCUIT_VISION_PROMPT,
    userPrompt: buildVisionUserPrompt(),
    estimatedMs: 120000,
    footerHtml: '💎 Want higher limits / faster AI? Contact <a href="https://x.com/anish2good" target="_blank" rel="noopener noreferrer">@anish2good on X</a>.',
    phases: [
      { pct: 12, ms: 3000,   label: 'Uploading image...' },
      { pct: 28, ms: 15000,  label: 'Reading components...' },
      { pct: 50, ms: 40000,  label: 'Tracing connections...' },
      { pct: 70, ms: 75000,  label: 'Describing circuit...' },
      { pct: 88, ms: 105000, label: 'Almost done...' },
    ],
    // Vision description is prose, not code — don't strip anything.
    cleanCode: (raw) => (raw || '').trim(),
    onResult: async (description) => {
      // Vision models often wrap the sentinel (backticks, quotes, periods).
      // Treat any short response containing `not_a_circuit` as the sentinel.
      const trimmed = (description || '').trim();
      if (trimmed.length < 50 && /not_a_circuit/i.test(trimmed)) {
        setAiStatus('Image does not appear to be a circuit', 'error');
        showCanvasToast('This image does not look like a circuit', 'warning', 5000);
        return;
      }

      // Stage 2: text → netlist.  Show the centered overlay so the user sees
      // continuity after the vision modal closes (they get to read the
      // description while the circuit is being built).
      aiBtn.disabled = true;
      aiInput.disabled = true;
      if (aiImgBtn) aiImgBtn.disabled = true;
      setAiStatus('Building circuit from image...', 'loading');

      const progress = openStage2Overlay(description);
      const t0 = Date.now();
      try {
        const elements = await descriptionToElements(description);
        app.loadFromElements(elements);
        const time = ((Date.now() - t0) / 1000).toFixed(1) + 's';
        const statusMsg = 'Circuit (' + elements.length + ' elements) in ' + time;
        setAiStatus('✓ ' + statusMsg, 'success');
        showCanvasToast('✓ Circuit from image ready', 'success', 3000);
        if (progress) progress.stop(true);
      } catch (err) {
        console.error('image→circuit stage 2 error:', err);
        setAiStatus(err.message || 'Failed to build circuit', 'error');
        if (progress) progress.stop(false);
      } finally {
        if (progress) setTimeout(() => progress.destroy(), 1500);
        aiBtn.disabled = false;
        aiInput.disabled = false;
        if (aiImgBtn) aiImgBtn.disabled = false;
      }
    },
    onError: (msg) => {
      setAiStatus(msg, 'error');
    },
  });
}

aiBtn.addEventListener('click', generateCircuit);
aiInput.addEventListener('keydown', (e) => {
  if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); generateCircuit(); }
});
if (aiImgBtn) aiImgBtn.addEventListener('click', generateFromImage);

// Example chips — click to fill input (user presses Enter or Generate to submit)
document.querySelectorAll('.ckt-ai-chip').forEach(chip => {
  chip.addEventListener('click', () => {
    aiInput.value = chip.dataset.prompt;
    aiInput.focus();
    aiInput.select();
    setAiStatus('Press Enter or click Generate', '');
  });
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
  var sticky=document.getElementById('adLabSticky');
  if(sticky&&!(localStorage.getItem('ad_lab_sticky_d')==='1')){
    window.addEventListener('load',function(){setTimeout(function(){if(typeof googletag!=='undefined'&&googletag.cmd)googletag.cmd.push(function(){googletag.display('ad_lab_sticky');sticky.classList.add('ad-visible')});setTimeout(function(){if(sticky&&!sticky.classList.contains('ad-dismissed'))sticky.classList.add('ad-dismissed')},30000)},window.innerWidth<768?4000:2000)});
  }
})();
</script>
<script src="<%=request.getContextPath()%>/modern/js/ai-progress-bar.js?v=<%=v%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/ai-vision-modal.js?v=<%=v%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
<%@ include file="../../modern/components/analytics.jsp" %>
</body>
</html>
