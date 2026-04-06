<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<jsp:include page="../modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="Logic Gate Simulator Online — Truth Tables, Karnaugh Maps, Boolean Algebra, Timing Diagrams" />
    <jsp:param name="toolCategory" value="Electronics" />
    <jsp:param name="toolDescription" value="Free browser-based digital logic simulator. Drag-and-drop AND, OR, NOT, NAND, NOR, XOR gates, flip-flops, counters, MUX, decoders, TTL 7400 ICs. Auto-generate truth tables, Karnaugh maps, minimize with Quine-McCluskey, view timing diagrams, build subcircuits. No install required." />
    <jsp:param name="toolUrl" value="electronics/logic-simulator.jsp" />
    <jsp:param name="toolImage" value="logic-simulator.svg" />
    <jsp:param name="toolKeywords" value="logic gate simulator online, logisim online, truth table generator, karnaugh map solver, boolean algebra calculator, digital circuit simulator, logic gates, flip flop simulator, D flip-flop, JK flip-flop, SR latch, binary counter, multiplexer, decoder, 7-segment display, TTL 7400, TTL 7474, Quine-McCluskey, sum of products, timing diagram, subcircuit, half adder, full adder, ALU, combinational logic, sequential logic" />
    <jsp:param name="breadcrumbCategoryUrl" value="electronics/" />
    <jsp:param name="educationalLevel" value="High School, Undergraduate, AP Computer Science, Digital Logic Design, Computer Engineering" />
    <jsp:param name="teaches" value="Boolean algebra, truth tables, Karnaugh maps, logic minimization, combinational circuits, sequential circuits, flip-flops, registers, counters, multiplexers, decoders, binary arithmetic, adders, subtractors, ALU design, TTL IC families, timing analysis, state machines, hierarchical design" />
    <jsp:param name="toolFeatures" value="53 digital logic components: 9 gates 7 wiring 3 I/O 6 memory 6 arithmetic/plexers 5 displays 9 TTL ICs,Auto truth table generation for up to 8 inputs,Karnaugh map visualization for 2 3 4 variables,Quine-McCluskey Boolean minimization with SOP expressions,Expression to circuit synthesis: type A*B+!C and get gates,Timing diagram with signal recording and waveform display,Hierarchical subcircuits: build once reuse everywhere,10 example circuits: half adder full adder SR latch D-FF counter MUX,JSON save/load PNG/SVG export URL sharing,Undo/redo with 40-level history,Dark and light themes" />
    <jsp:param name="faq1q" value="What is this logic gate simulator?" />
    <jsp:param name="faq1a" value="A free browser-based digital logic simulator inspired by Logisim. Drag and drop gates (AND OR NOT NAND NOR XOR), flip-flops (D JK SR T), counters, registers, multiplexers, decoders, 7-segment displays, and TTL 7400-series ICs onto a canvas. Wire them together and the circuit propagates instantly. Generate truth tables, Karnaugh maps, and minimized Boolean expressions automatically. No installation or signup required." />
    <jsp:param name="faq2q" value="What components are available?" />
    <jsp:param name="faq2a" value="53 components across 8 categories. Gates: AND OR NOT NAND NOR XOR XNOR Buffer. Wiring: Input Output Clock Constant Probe Tunnel. I/O: LED Button Switch. Memory: SR D JK T flip-flops 4-bit Register 4-bit Counter. Arithmetic: Full Adder Subtractor Comparator 2:1 MUX 1:2 DEMUX 2:4 Decoder. Displays: 7-Segment Hex Display LED Bar Hex Keypad TTY. TTL: 7400 7402 7404 7408 7432 7486 7474 7447 74138." />
    <jsp:param name="faq3q" value="How does truth table and Karnaugh map generation work?" />
    <jsp:param name="faq3a" value="Click the Analyze button in the toolbar. The simulator enumerates all input combinations (up to 2^8 = 256 rows), propagates each through the circuit, and records the outputs. It displays the truth table, extracts the Sum of Products expression, minimizes it using the Quine-McCluskey algorithm, and renders Karnaugh maps for 2 to 4 variable circuits with proper Gray code ordering." />
    <jsp:param name="faq4q" value="Can I type a Boolean expression and generate a circuit?" />
    <jsp:param name="faq4a" value="Yes. Click Expr to Circuit in the toolbar and type an expression like A*B + !C or AB + A'C using standard notation. The simulator parses it, creates input pins for each variable, generates the necessary AND OR and NOT gates, wires them together, and adds an output pin. Supports implicit AND (AB means A AND B), postfix NOT (A' means NOT A), and parentheses for grouping." />
</jsp:include>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;500;600;700&family=DM+Sans:wght@400;500;600&family=Fira+Code:wght@400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=v%>">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=v%>">
<link rel="stylesheet" href="<%=request.getContextPath()%>/electronics/css/logic-simulator.css?v=<%=v%>">
<!-- STPD banner ad (hero only, no overlay/interstitial) -->
<%@ include file="../setupad.jsp"%>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
</head>
<body>
<%@ include file="../modern/components/nav-header.jsp" %>

<!-- Hero bar + STPD ad OUTSIDE the app container -->
<div class="lg-hero-bar">
  <h1 class="lg-hero-h1">Logic Gate Simulator Online</h1>
  <div class="ad-lg-hero" id="ad_logic_hero">
    <div id="site_8gwifi_org_sidebar_desktop">
      <script>googletag.cmd.push(function(){googletag.display('site_8gwifi_org_sidebar_desktop')});</script>
    </div>
  </div>
</div>

<div class="lg-app" id="logicApp">

  <!-- Toolbar -->
  <div class="lg-toolbar" id="toolbar">
    <div class="lg-tb-group">
      <button class="lg-tb-btn" id="btnFit" title="Fit to content">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M15 3h6v6M9 21H3v-6M21 3l-7 7M3 21l7-7"/></svg>
      </button>
      <button class="lg-tb-btn" id="btnClear" title="Clear all">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 01-2 2H8a2 2 0 01-2-2L5 6"/><path d="M10 11v6"/><path d="M14 11v6"/></svg>
      </button>
      <button class="lg-tb-btn" id="btnUndo" title="Undo (Ctrl+Z)">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="1 4 1 10 7 10"/><path d="M3.51 15a9 9 0 105.64-9.13L1 10"/></svg>
      </button>
      <button class="lg-tb-btn" id="btnRedo" title="Redo (Ctrl+Y)">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="23 4 23 10 17 10"/><path d="M20.49 15a9 9 0 11-5.64-9.13L23 10"/></svg>
      </button>
      <select id="presetSelect" class="lg-tb-select" title="Load example circuit">
        <option value="">Examples...</option>
      </select>
      <button class="lg-tb-btn" id="btnSave" title="Save circuit (JSON)">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 21H5a2 2 0 01-2-2V5a2 2 0 012-2h11l5 5v11a2 2 0 01-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
      </button>
      <button class="lg-tb-btn" id="btnLoad" title="Load circuit (JSON)">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
      </button>
      <button class="lg-tb-btn" id="btnExportPNG" title="Export as PNG">PNG</button>
      <button class="lg-tb-btn" id="btnExportSVG" title="Export as SVG">SVG</button>
      <button class="lg-tb-btn" id="btnShare" title="Share via URL">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="18" cy="5" r="3"/><circle cx="6" cy="12" r="3"/><circle cx="18" cy="19" r="3"/><line x1="8.59" y1="13.51" x2="15.42" y2="17.49"/><line x1="15.41" y1="6.51" x2="8.59" y2="10.49"/></svg>
      </button>
    </div>
    <div class="lg-tb-group" id="gateButtons">
      <!-- Populated by JS -->
    </div>
    <div class="lg-tb-group">
      <button class="lg-tb-btn" id="btnInput" title="Place input pin">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="4" y="4" width="16" height="16" rx="3"/><text x="12" y="16" text-anchor="middle" font-size="11" fill="currentColor" stroke="none" font-weight="600">IN</text></svg>
        <span>Input</span>
      </button>
      <button class="lg-tb-btn" id="btnOutput" title="Place output pin">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="8"/><text x="12" y="16" text-anchor="middle" font-size="10" fill="currentColor" stroke="none" font-weight="600">OUT</text></svg>
        <span>Output</span>
      </button>
    </div>
    <div class="lg-tb-group">
      <button class="lg-tb-btn active" id="btnSimulate" title="Toggle simulation mode (edit vs simulate)">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="5 3 19 12 5 21 5 3"/></svg>
        <span>Simulate</span>
      </button>
      <button class="lg-tb-btn" id="btnAnalyze" title="Analyze circuit (truth table, K-map, expression)">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/></svg>
        <span>Analyze</span>
      </button>
      <button class="lg-tb-btn" id="btnChrono" title="Timing diagram (chronogram)">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 12h4l2-6 2 12 2-6h4"/><line x1="3" y1="18" x2="21" y2="18"/></svg>
        <span>Timing</span>
      </button>
      <button class="lg-tb-btn" id="btnSynthesize" title="Generate circuit from expression">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 5v14M5 12h14"/></svg>
        <span>Expr→Circuit</span>
      </button>
    </div>
  </div>

  <!-- Circuit tabs -->
  <div class="lg-circuit-tabs" id="circuitTabs">
    <button class="lg-circuit-tab active" data-name="main">main</button>
    <button class="lg-tb-btn" id="btnAddCircuit" title="New circuit" style="padding:0 6px;font-size:14px;">+</button>
    <div style="flex:1;"></div>
    <button class="lg-tb-btn" id="btnSaveSubcircuit" title="Save current circuit as subcircuit">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14"><rect x="3" y="3" width="18" height="18" rx="2"/><path d="M9 3v6h6V3"/><path d="M7 15h10"/></svg>
      <span>Save as Sub</span>
    </button>
  </div>

  <!-- Breadcrumb navigation (for drill-down) -->
  <div class="lg-breadcrumb" id="breadcrumb" style="display:none;"></div>

  <!-- Main layout -->
  <div class="lg-main">

    <!-- Library panel -->
    <div class="lg-library" id="libraryPanel">
      <div style="padding:6px 8px;"><input type="text" id="libSearch" class="lg-lib-search" placeholder="Search components..." autocomplete="off"></div>
      <div class="lg-lib-section open" data-section="gates">
        <div class="lg-lib-header lg-collapsible">Gates <span class="lg-chevron"></span></div>
        <div class="lg-lib-body" id="libGates"></div>
      </div>
      <div class="lg-lib-section" data-section="wiring">
        <div class="lg-lib-header lg-collapsible">Wiring <span class="lg-chevron"></span></div>
        <div class="lg-lib-body" id="libWiring"></div>
      </div>
      <div class="lg-lib-section" data-section="io">
        <div class="lg-lib-header lg-collapsible">I/O <span class="lg-chevron"></span></div>
        <div class="lg-lib-body" id="libIO"></div>
      </div>
      <div class="lg-lib-section" data-section="memory">
        <div class="lg-lib-header lg-collapsible">Memory <span class="lg-chevron"></span></div>
        <div class="lg-lib-body" id="libMemory"></div>
      </div>
      <div class="lg-lib-section" data-section="arith">
        <div class="lg-lib-header lg-collapsible">Arithmetic <span class="lg-chevron"></span></div>
        <div class="lg-lib-body" id="libArith"></div>
      </div>
      <div class="lg-lib-section" data-section="plexers">
        <div class="lg-lib-header lg-collapsible">Plexers <span class="lg-chevron"></span></div>
        <div class="lg-lib-body" id="libPlexers"></div>
      </div>
      <div class="lg-lib-section" data-section="displays">
        <div class="lg-lib-header lg-collapsible">Displays <span class="lg-chevron"></span></div>
        <div class="lg-lib-body" id="libDisplays"></div>
      </div>
      <div class="lg-lib-section" data-section="ttl">
        <div class="lg-lib-header lg-collapsible">TTL ICs <span class="lg-chevron"></span></div>
        <div class="lg-lib-body" id="libTTL"></div>
      </div>
      <!-- Ad slot below library (lazy loaded by setupad anchor) -->
    </div>

    <!-- Canvas -->
    <div class="lg-canvas-wrap" id="canvasWrap">
      <svg id="canvasSvg" xmlns="http://www.w3.org/2000/svg"></svg>

      <!-- Help banner -->
      <div class="lg-help-banner" id="helpBanner">Click on canvas to place component. Press Esc to cancel.</div>

      <!-- Zoom controls -->
      <div class="lg-zoom-badge">
        <button class="lg-zoom-btn" id="btnZoomOut" title="Zoom out">−</button>
        <span class="lg-zoom-label" id="zoomLabel">100%</span>
        <button class="lg-zoom-btn" id="btnZoomIn" title="Zoom in">+</button>
      </div>
    </div>

    <!-- Analysis panel (right) -->
    <div class="lg-analysis" id="analysisPanel" style="display:none;">
      <div class="lg-analysis-header">
        <span>Analysis</span>
        <button class="lg-tb-btn" id="btnCloseAnalysis" title="Close">&times;</button>
      </div>
      <div class="lg-analysis-body" id="analysisBody"></div>
    </div>

  </div>

  <!-- Chronogram panel -->
  <div class="lg-chrono" id="chronoPanel" style="display:none;height:160px;">
    <div class="lg-chrono-header">
      <span>Timing Diagram</span>
      <button class="lg-tb-btn" id="btnChronoRecord" title="Record">
        <svg viewBox="0 0 24 24" fill="currentColor" stroke="none" width="12" height="12"><circle cx="12" cy="12" r="6"/></svg>
        <span>Record</span>
      </button>
      <button class="lg-tb-btn" id="btnChronoStep" title="Manual tick">Step</button>
      <button class="lg-tb-btn" id="btnChronoReset" title="Clear history">Clear</button>
      <button class="lg-tb-btn" id="btnChronoClose" title="Close">&times;</button>
    </div>
    <div class="lg-chrono-body" id="chronoBody"></div>
  </div>

  <!-- Status bar -->
  <div class="lg-status">
    <span class="lg-status-item" id="statusComponents">Components: 0</span>
    <span class="lg-status-item" id="statusWires">Wires: 0</span>
    <span class="lg-status-item" id="statusSelected">Selected: none</span>
    <span class="lg-status-item" id="statusMode" style="color:var(--lg-success);font-weight:600;">EDIT</span>
    <span class="lg-status-item" style="margin-left:auto;">
      <kbd>R</kbd> Rotate &nbsp; <kbd>Del</kbd> Delete &nbsp; <kbd>Esc</kbd> Cancel
    </span>
  </div>

</div>

<!-- AdSense bottom bar (visible within viewport, below the app) -->
<div class="lg-adsense-bar">
  <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
  <ins class="adsbygoogle"
       style="display:block"
       data-ad-client="ca-pub-9265938999349914"
       data-ad-slot="6684554088"
       data-ad-format="horizontal"
       data-full-width-responsive="false"></ins>
  <script>(adsbygoogle = window.adsbygoogle || []).push({});</script>
</div>

<!-- Logic simulator scripts -->
<script src="<%=request.getContextPath()%>/electronics/js/logic/core/value.js?v=<%=v%>"></script>
<script src="<%=request.getContextPath()%>/electronics/js/logic/core/circuit.js?v=<%=v%>"></script>
<script src="<%=request.getContextPath()%>/electronics/js/logic/components/gates.js?v=<%=v%>"></script>
<script src="<%=request.getContextPath()%>/electronics/js/logic/components/pin.js?v=<%=v%>"></script>
<script src="<%=request.getContextPath()%>/electronics/js/logic/components/clock.js?v=<%=v%>"></script>
<script src="<%=request.getContextPath()%>/electronics/js/logic/components/wiring.js?v=<%=v%>"></script>
<script src="<%=request.getContextPath()%>/electronics/js/logic/components/io.js?v=<%=v%>"></script>
<script src="<%=request.getContextPath()%>/electronics/js/logic/components/memory.js?v=<%=v%>"></script>
<script src="<%=request.getContextPath()%>/electronics/js/logic/components/arithmetic.js?v=<%=v%>"></script>
<script src="<%=request.getContextPath()%>/electronics/js/logic/components/displays.js?v=<%=v%>"></script>
<script src="<%=request.getContextPath()%>/electronics/js/logic/components/ttl/ttl.js?v=<%=v%>"></script>
<script src="<%=request.getContextPath()%>/electronics/js/logic/core/project.js?v=<%=v%>"></script>
<script src="<%=request.getContextPath()%>/electronics/js/logic/core/history.js?v=<%=v%>"></script>
<script src="<%=request.getContextPath()%>/electronics/js/logic/presets.js?v=<%=v%>"></script>
<script src="<%=request.getContextPath()%>/electronics/js/logic/analysis/analyzer.js?v=<%=v%>"></script>
<script src="<%=request.getContextPath()%>/electronics/js/logic/analysis/synthesize.js?v=<%=v%>"></script>
<script src="<%=request.getContextPath()%>/electronics/js/logic/analysis/chronogram.js?v=<%=v%>"></script>
<script src="<%=request.getContextPath()%>/electronics/js/logic/io/file-io.js?v=<%=v%>"></script>
<script src="<%=request.getContextPath()%>/electronics/js/logic/ui/canvas.js?v=<%=v%>"></script>
<script src="<%=request.getContextPath()%>/electronics/js/logic/ui/wire-manager.js?v=<%=v%>"></script>
<script>
(function () {
  'use strict';
  const L = window.LogicSim;
  const { GATE_TYPES, PIN_TYPES, CLOCK_TYPE, WIRING_TYPES, IO_TYPES, MEMORY_TYPES, ARITH_TYPES, DISPLAY_TYPES, TTL_TYPES, Circuit, Canvas, WireManager } = L;

  /* ── Collect all component types ── */
  const ALL_TYPES = Object.assign({}, GATE_TYPES, PIN_TYPES,
    { CLOCK: CLOCK_TYPE }, WIRING_TYPES, IO_TYPES, MEMORY_TYPES, ARITH_TYPES, DISPLAY_TYPES, TTL_TYPES);

  /* ── Init circuit + canvas ── */
  const circuit = new Circuit();
  const svgEl   = document.getElementById('canvasSvg');
  const canvas  = new Canvas(svgEl, circuit);
  const wireMgr = new WireManager(canvas);
  canvas.wireManager = wireMgr;

  /* Center the view */
  canvas.panX = svgEl.getBoundingClientRect().width / 2;
  canvas.panY = svgEl.getBoundingClientRect().height / 2;
  canvas._updateTransform();

  /* ── Populate library panel ── */
  const libGates  = document.getElementById('libGates');
  const libWiring = document.getElementById('libWiring');

  function makeLibItem(typeDef, container) {
    const div = document.createElement('div');
    div.className = 'lg-lib-item';
    div.dataset.type = typeDef.type;
    div.innerHTML = '<span class="lg-lib-icon">' + gateIcon(typeDef.type) + '</span>' +
                    '<span>' + typeDef.label + '</span>';
    div.addEventListener('click', () => {
      // Toggle active
      document.querySelectorAll('.lg-lib-item.active').forEach(el => el.classList.remove('active'));
      div.classList.add('active');
      canvas.startPlace(typeDef);
      showHelp('Click on canvas to place ' + typeDef.label + '. Shift+click to place multiple. Esc to cancel.');
    });
    container.appendChild(div);
  }

  // Gates
  ['AND','OR','NOT','NAND','NOR','XOR','XNOR','BUFFER'].forEach(t => {
    makeLibItem(GATE_TYPES[t], libGates);
  });
  // Wiring
  makeLibItem(PIN_TYPES.INPUT, libWiring);
  makeLibItem(PIN_TYPES.OUTPUT, libWiring);
  makeLibItem(CLOCK_TYPE, libWiring);
  makeLibItem(WIRING_TYPES.CONSTANT, libWiring);
  makeLibItem(WIRING_TYPES.PROBE, libWiring);
  makeLibItem(WIRING_TYPES.TUNNEL_SRC, libWiring);
  makeLibItem(WIRING_TYPES.TUNNEL_TGT, libWiring);
  // I/O
  const libIO = document.getElementById('libIO');
  makeLibItem(IO_TYPES.LED, libIO);
  makeLibItem(IO_TYPES.BUTTON, libIO);
  makeLibItem(IO_TYPES.SWITCH, libIO);
  // Memory
  const libMem = document.getElementById('libMemory');
  ['SR_FF','D_FF','JK_FF','T_FF','REGISTER','COUNTER'].forEach(t => {
    makeLibItem(MEMORY_TYPES[t], libMem);
  });
  // Arithmetic
  const libArith = document.getElementById('libArith');
  ['ADDER','SUBTRACTOR','COMPARATOR'].forEach(t => makeLibItem(ARITH_TYPES[t], libArith));
  // Plexers
  const libPlex = document.getElementById('libPlexers');
  ['MUX','DEMUX','DECODER'].forEach(t => makeLibItem(ARITH_TYPES[t], libPlex));
  // Displays
  const libDisp = document.getElementById('libDisplays');
  ['SEVEN_SEG','HEX_DISPLAY','LED_BAR','KEYBOARD','TTY'].forEach(t => makeLibItem(DISPLAY_TYPES[t], libDisp));
  // TTL ICs
  const libTTL = document.getElementById('libTTL');
  Object.keys(TTL_TYPES).forEach(t => makeLibItem(TTL_TYPES[t], libTTL));

  /* ── Toolbar gate buttons ── */
  const gateBar = document.getElementById('gateButtons');
  ['AND','OR','NOT','NAND','NOR','XOR'].forEach(t => {
    const btn = document.createElement('button');
    btn.className = 'lg-tb-btn';
    btn.title = GATE_TYPES[t].label;
    btn.innerHTML = gateIcon(t) + '<span>' + t + '</span>';
    btn.addEventListener('click', () => {
      document.querySelectorAll('.lg-lib-item.active').forEach(el => el.classList.remove('active'));
      canvas.startPlace(GATE_TYPES[t]);
      showHelp('Click on canvas to place ' + t + ' gate.');
    });
    gateBar.appendChild(btn);
  });

  /* ── Toolbar: Input / Output buttons ── */
  document.getElementById('btnInput').addEventListener('click', () => {
    canvas.startPlace(PIN_TYPES.INPUT);
    showHelp('Click to place Input Pin. Click it in the circuit to toggle 0/1.');
  });
  document.getElementById('btnOutput').addEventListener('click', () => {
    canvas.startPlace(PIN_TYPES.OUTPUT);
    showHelp('Click to place Output Pin.');
  });

  /* ── Toolbar actions ── */
  document.getElementById('btnFit').addEventListener('click', () => canvas.fitContent());
  document.getElementById('btnClear').addEventListener('click', () => {
    if (circuit.components.size === 0) return;
    if (!confirm('Clear all components and wires?')) return;
    const ids = [...circuit.components.keys()];
    ids.forEach(id => circuit.removeComponent(id));
  });

  /* ── Zoom controls ── */
  document.getElementById('btnZoomIn').addEventListener('click', () => { canvas.zoomIn(); updateZoomLabel(); });
  document.getElementById('btnZoomOut').addEventListener('click', () => { canvas.zoomOut(); updateZoomLabel(); });
  document.getElementById('zoomLabel').addEventListener('click', () => { canvas.zoomReset(); updateZoomLabel(); });

  function updateZoomLabel() {
    document.getElementById('zoomLabel').textContent = Math.round(canvas.zoom * 100) + '%';
  }
  svgEl.addEventListener('wheel', () => requestAnimationFrame(updateZoomLabel));

  /* ── Status bar ── */
  circuit.onChange(() => {
    document.getElementById('statusComponents').textContent = 'Components: ' + circuit.components.size;
    document.getElementById('statusWires').textContent = 'Wires: ' + circuit.wires.size;
  });
  /* Update selection status on render */
  circuit.onChange(() => {
    const n = canvas.selected.size;
    if (n === 0) {
      document.getElementById('statusSelected').textContent = 'Selected: none';
    } else if (n === 1) {
      const id = [...canvas.selected][0];
      const name = circuit.components.get(id)?.type || 'Wire';
      document.getElementById('statusSelected').textContent = 'Selected: ' + name;
    } else {
      document.getElementById('statusSelected').textContent = 'Selected: ' + n + ' items';
    }
  });

  /* ── Help banner ── */
  let helpTimer;
  function showHelp(msg) {
    const el = document.getElementById('helpBanner');
    el.textContent = msg;
    el.classList.add('visible');
    clearTimeout(helpTimer);
    helpTimer = setTimeout(() => el.classList.remove('visible'), 4000);
  }

  /* On Escape, clear library selection + help */
  document.addEventListener('keydown', e => {
    if (e.key === 'Escape') {
      document.querySelectorAll('.lg-lib-item.active').forEach(el => el.classList.remove('active'));
      document.getElementById('helpBanner').classList.remove('visible');
    }
  });

  /* ── Gate mini-icons for library/toolbar ── */
  function gateIcon(type) {
    const sw = 'stroke-width="1.5" stroke="currentColor" fill="none"';
    switch (type) {
      case 'AND':
        return '<svg viewBox="-20 -16 40 32" ' + sw + '><path d="M-12,-12 L0,-12 A12,12 0 0,1 0,12 L-12,12 Z"/></svg>';
      case 'OR':
        return '<svg viewBox="-20 -16 40 32" ' + sw + '><path d="M-12,-12 Q-2,0 -12,12 Q4,12 12,0 Q4,-12 -12,-12"/></svg>';
      case 'NOT':
        return '<svg viewBox="-20 -16 40 32" ' + sw + '><path d="M-12,-10 L8,0 L-12,10 Z"/><circle cx="11" cy="0" r="3"/></svg>';
      case 'NAND':
        return '<svg viewBox="-20 -16 40 32" ' + sw + '><path d="M-12,-12 L0,-12 A12,12 0 0,1 0,12 L-12,12 Z"/><circle cx="14" cy="0" r="3"/></svg>';
      case 'NOR':
        return '<svg viewBox="-20 -16 40 32" ' + sw + '><path d="M-12,-12 Q-2,0 -12,12 Q4,12 12,0 Q4,-12 -12,-12"/><circle cx="14" cy="0" r="3"/></svg>';
      case 'XOR':
        return '<svg viewBox="-20 -16 40 32" ' + sw + '><path d="M-12,-12 Q-2,0 -12,12 Q4,12 12,0 Q4,-12 -12,-12"/><path d="M-15,-12 Q-5,0 -15,12"/></svg>';
      case 'XNOR':
        return '<svg viewBox="-20 -16 40 32" ' + sw + '><path d="M-12,-12 Q-2,0 -12,12 Q4,12 12,0 Q4,-12 -12,-12"/><path d="M-15,-12 Q-5,0 -15,12"/><circle cx="14" cy="0" r="3"/></svg>';
      case 'BUFFER':
        return '<svg viewBox="-20 -16 40 32" ' + sw + '><path d="M-10,-10 L10,0 L-10,10 Z"/></svg>';
      case 'INPUT':
        return '<svg viewBox="-14 -14 28 28" ' + sw + '><rect x="-10" y="-10" width="20" height="20" rx="3"/></svg>';
      case 'OUTPUT':
        return '<svg viewBox="-14 -14 28 28" ' + sw + '><circle cx="0" cy="0" r="10"/></svg>';
      case 'CLOCK':
        return '<svg viewBox="-14 -14 28 28" ' + sw + '><rect x="-10" y="-10" width="20" height="20" rx="3"/><path d="M-5,-1 L-5,-5 L0,-5 L0,5 L5,5 L5,-1"/></svg>';
      case 'CONSTANT':
        return '<svg viewBox="-14 -14 28 28" ' + sw + '><rect x="-8" y="-8" width="16" height="16" rx="2" fill="currentColor" stroke="none" opacity=".3"/><text x="0" y="5" text-anchor="middle" font-size="12" font-weight="700" fill="currentColor" stroke="none">1</text></svg>';
      case 'PROBE':
        return '<svg viewBox="-14 -14 28 28" ' + sw + '><path d="M-8,0 L0,-8 L8,0 L0,8 Z"/></svg>';
      case 'TUNNEL_SRC':
        return '<svg viewBox="-16 -12 32 24" ' + sw + '><path d="M-10,-8 L6,-8 L12,0 L6,8 L-10,8 Z"/></svg>';
      case 'TUNNEL_TGT':
        return '<svg viewBox="-16 -12 32 24" ' + sw + '><path d="M-12,-8 L4,-8 L10,0 L4,8 L-12,8 Z"/></svg>';
      case 'LED':
        return '<svg viewBox="-14 -14 28 28" ' + sw + '><circle cx="0" cy="0" r="9"/><circle cx="0" cy="0" r="5" opacity=".3" fill="currentColor" stroke="none"/></svg>';
      case 'BUTTON':
        return '<svg viewBox="-14 -14 28 28" ' + sw + '><rect x="-10" y="-10" width="20" height="20" rx="3"/><circle cx="0" cy="0" r="5"/></svg>';
      case 'SWITCH':
        return '<svg viewBox="-16 -10 32 20" ' + sw + '><rect x="-12" y="-6" width="24" height="12" rx="6"/><circle cx="-4" cy="0" r="4" fill="currentColor" stroke="none"/></svg>';
      case 'SR_FF': case 'D_FF': case 'JK_FF': case 'T_FF':
        return '<svg viewBox="-16 -14 32 28" ' + sw + '><rect x="-12" y="-10" width="24" height="20" rx="2"/><path d="M-12,-2 L-7,0 L-12,2" fill="none"/><text x="0" y="4" text-anchor="middle" font-size="8" fill="currentColor" stroke="none" font-weight="600">' + type.replace('_FF','') + '</text></svg>';
      case 'REGISTER':
        return '<svg viewBox="-16 -14 32 28" ' + sw + '><rect x="-12" y="-10" width="24" height="20" rx="2"/><text x="0" y="4" text-anchor="middle" font-size="7" fill="currentColor" stroke="none" font-weight="600">REG</text></svg>';
      case 'COUNTER':
        return '<svg viewBox="-16 -14 32 28" ' + sw + '><rect x="-12" y="-10" width="24" height="20" rx="2"/><text x="0" y="4" text-anchor="middle" font-size="7" fill="currentColor" stroke="none" font-weight="600">CTR</text></svg>';
      case 'ADDER':
        return '<svg viewBox="-16 -14 32 28" ' + sw + '><rect x="-12" y="-10" width="24" height="20" rx="2"/><text x="0" y="5" text-anchor="middle" font-size="14" fill="currentColor" stroke="none" font-weight="600">+</text></svg>';
      case 'SUBTRACTOR':
        return '<svg viewBox="-16 -14 32 28" ' + sw + '><rect x="-12" y="-10" width="24" height="20" rx="2"/><text x="0" y="5" text-anchor="middle" font-size="14" fill="currentColor" stroke="none" font-weight="600">\u2212</text></svg>';
      case 'COMPARATOR':
        return '<svg viewBox="-16 -14 32 28" ' + sw + '><rect x="-12" y="-10" width="24" height="20" rx="2"/><text x="0" y="4" text-anchor="middle" font-size="8" fill="currentColor" stroke="none" font-weight="600">CMP</text></svg>';
      case 'MUX':
        return '<svg viewBox="-16 -14 32 28" ' + sw + '><path d="M-10,-10 L10,-6 L10,6 L-10,10 Z"/></svg>';
      case 'DEMUX':
        return '<svg viewBox="-16 -14 32 28" ' + sw + '><path d="M-10,-6 L10,-10 L10,10 L-10,6 Z"/></svg>';
      case 'DECODER':
        return '<svg viewBox="-16 -14 32 28" ' + sw + '><rect x="-12" y="-10" width="24" height="20" rx="2"/><text x="0" y="4" text-anchor="middle" font-size="7" fill="currentColor" stroke="none" font-weight="600">DEC</text></svg>';
      case 'SEVEN_SEG':
        return '<svg viewBox="-8 -12 22 24" ' + sw + '><rect x="-4" y="-8" width="14" height="18" rx="1" fill="none"/><path d="M0,-6 L6,-6" stroke-width="2"/><path d="M7,-5 L7,0" stroke-width="2"/><path d="M7,2 L7,7" stroke-width="2"/><path d="M0,8 L6,8" stroke-width="2"/><path d="M-1,2 L-1,7" stroke-width="2"/><path d="M-1,-5 L-1,0" stroke-width="2"/><path d="M0,1 L6,1" stroke-width="2"/></svg>';
      case 'HEX_DISPLAY':
        return '<svg viewBox="-16 -14 32 28" ' + sw + '><rect x="-12" y="-10" width="24" height="20" rx="2" fill="none"/><text x="0" y="5" text-anchor="middle" font-size="14" fill="currentColor" stroke="none" font-weight="700">A</text></svg>';
      case 'LED_BAR':
        return '<svg viewBox="-8 -14 16 28" ' + sw + '><rect x="-4" y="-10" width="8" height="20" rx="1" fill="none"/><rect x="-2" y="-8" width="4" height="2" rx="0.5" fill="currentColor" stroke="none" opacity=".8"/><rect x="-2" y="-4" width="4" height="2" rx="0.5" fill="currentColor" stroke="none" opacity=".5"/><rect x="-2" y="0" width="4" height="2" rx="0.5" fill="currentColor" stroke="none" opacity=".3"/><rect x="-2" y="4" width="4" height="2" rx="0.5" fill="currentColor" stroke="none" opacity=".15"/></svg>';
      case 'KEYBOARD':
        return '<svg viewBox="-16 -14 32 28" ' + sw + '><rect x="-12" y="-10" width="24" height="20" rx="2"/><text x="0" y="4" text-anchor="middle" font-size="7" fill="currentColor" stroke="none" font-weight="600">KEY</text></svg>';
      case 'TTY':
        return '<svg viewBox="-16 -14 32 28" ' + sw + '><rect x="-12" y="-10" width="24" height="20" rx="2"/><text x="0" y="-2" font-size="5" fill="currentColor" stroke="none" font-family="monospace">Hi_</text><text x="0" y="7" text-anchor="middle" font-size="6" fill="currentColor" stroke="none" font-weight="600">TTY</text></svg>';
      default:
        // TTL ICs — DIP chip icon with part number
        if (type.startsWith('TTL_')) {
          const pn = type.replace('TTL_','');
          return '<svg viewBox="-18 -14 36 28" ' + sw + '><rect x="-14" y="-10" width="28" height="20" rx="1" fill="none"/><path d="M-3,-10 A3,3 0 0,1 3,-10" fill="none"/><text x="0" y="4" text-anchor="middle" font-size="7" fill="currentColor" stroke="none" font-weight="600">' + pn + '</text></svg>';
        }
        return '<svg viewBox="-14 -14 28 28" ' + sw + '><rect x="-10" y="-10" width="20" height="20" rx="3"/></svg>';
    }
  }

  /* ── Analysis panel ── */
  const analysisPanel = document.getElementById('analysisPanel');
  const analysisBody  = document.getElementById('analysisBody');

  document.getElementById('btnAnalyze').addEventListener('click', () => {
    const analyzer = new L.Analyzer(circuit);
    const tt = analyzer.generateTruthTable(8);
    if (!tt) { alert('Add INPUT and OUTPUT pins to analyze.'); return; }
    if (tt.error) { alert(tt.error); return; }

    let html = '';

    // Truth table
    html += '<h3>Truth Table</h3>';
    html += '<table class="lg-tt"><thead><tr>';
    tt.inputNames.forEach(n => { html += '<th>' + n + '</th>'; });
    tt.outputNames.forEach(n => { html += '<th class="tt-sep">' + n + '</th>'; });
    html += '</tr></thead><tbody>';
    tt.rows.forEach(row => {
      html += '<tr>';
      row.in.forEach(v => { html += '<td class="tt-' + v + '">' + v + '</td>'; });
      row.out.forEach((v, i) => { html += '<td class="tt-' + v + (i === 0 ? ' tt-sep' : '') + '">' + v + '</td>'; });
      html += '</tr>';
    });
    html += '</tbody></table>';

    // Expressions per output
    tt.outputNames.forEach((name, oi) => {
      html += '<h3>' + name + ' — Expression</h3>';
      const sop = analyzer.extractSOP(tt, oi);
      html += '<div class="lg-expr-label">SOP (unminimized)</div>';
      html += '<div class="lg-expr">' + _esc(sop) + '</div>';

      const min = analyzer.minimize(tt, oi);
      html += '<div class="lg-expr-label">Minimized (Quine-McCluskey)</div>';
      html += '<div class="lg-expr">' + _esc(min.expr) + '</div>';

      // K-map
      const km = analyzer.generateKMap(tt, oi);
      if (km) {
        html += '<h3>' + name + ' — K-Map</h3>';
        html += '<table class="lg-kmap"><thead><tr><th class="km-header">' +
                km.rowVars.join('') + '\\' + km.colVars.join('') + '</th>';
        km.colLabels.forEach(l => { html += '<th class="km-header">' + l + '</th>'; });
        html += '</tr></thead><tbody>';
        km.grid.forEach((row, ri) => {
          html += '<tr><th class="km-header">' + km.rowLabels[ri] + '</th>';
          row.forEach(v => { html += '<td class="km-' + v + '">' + v + '</td>'; });
          html += '</tr>';
        });
        html += '</tbody></table>';
      }
    });

    analysisBody.innerHTML = html;
    analysisPanel.style.display = 'flex';
  });

  document.getElementById('btnCloseAnalysis').addEventListener('click', () => {
    analysisPanel.style.display = 'none';
  });

  /* Expression → Circuit */
  document.getElementById('btnSynthesize').addEventListener('click', () => {
    const expr = prompt('Boolean expression (e.g., A\u00B7B + \u00ACC):', '');
    if (!expr || !expr.trim()) return;
    L.synthesize(circuit, expr.trim(), 0, 0);
    canvas.fitContent();
  });

  function _esc(s) { return s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }

  /* ── Chronogram (timing diagram) ── */
  const recorder = new L.SignalRecorder(circuit);
  const chronoRenderer = new L.ChronogramRenderer(document.getElementById('chronoBody'));
  const chronoPanel = document.getElementById('chronoPanel');

  // Hook into circuit propagation to sample signals
  circuit.onChange((type) => {
    if (type === 'propagate' && recorder.recording) {
      recorder.sample();
      chronoRenderer.render(recorder);
    }
  });

  document.getElementById('btnChrono').addEventListener('click', () => {
    chronoPanel.style.display = chronoPanel.style.display === 'none' ? 'flex' : 'none';
    if (chronoPanel.style.display === 'flex' && recorder._watched.length === 0) {
      recorder.watchAllPins();
      chronoRenderer.render(recorder);
    }
  });

  document.getElementById('btnChronoRecord').addEventListener('click', function() {
    if (recorder.recording) {
      recorder.stop();
      this.querySelector('span').textContent = 'Record';
      this.classList.remove('active');
    } else {
      if (recorder._watched.length === 0) recorder.watchAllPins();
      recorder.start();
      this.querySelector('span').textContent = 'Stop';
      this.classList.add('active');
      chronoRenderer.render(recorder);
    }
  });

  document.getElementById('btnChronoStep').addEventListener('click', () => {
    if (recorder._watched.length === 0) recorder.watchAllPins();
    // Ensure initial snapshot exists before first manual step
    if (!recorder.recording) recorder.start();
    recorder.recording = true;
    recorder.sample();
    recorder.recording = false; // step = one-shot, don't stay recording
    chronoRenderer.render(recorder);
  });

  document.getElementById('btnChronoReset').addEventListener('click', () => {
    recorder.reset();
    chronoRenderer.render(recorder);
  });

  document.getElementById('btnChronoClose').addEventListener('click', () => {
    chronoPanel.style.display = 'none';
  });

  /* ── Collapsible library sections ── */
  document.querySelectorAll('.lg-lib-header.lg-collapsible').forEach(header => {
    header.addEventListener('click', () => {
      const section = header.parentElement;
      section.classList.toggle('open');
    });
  });

  /* ── Mode toggle: Edit (build) vs Simulate (interact) ── */
  // Circuit ALWAYS propagates. Mode only controls what mouse clicks do.
  let simulating = false;  // start in Edit mode
  const btnSim = document.getElementById('btnSimulate');

  function updateModeUI() {
    btnSim.classList.toggle('active', simulating);
    btnSim.querySelector('span').textContent = simulating ? 'Simulating' : 'Simulate';
    document.getElementById('logicApp').classList.toggle('lg-sim-mode', simulating);

    // In sim mode: dim library (can't place), clear selection
    document.getElementById('libraryPanel').style.pointerEvents = simulating ? 'none' : '';
    document.getElementById('libraryPanel').style.opacity = simulating ? '0.5' : '';
    if (simulating) { canvas.selected.clear(); canvas.cancelPlace(); }
    canvas.render();

    const modeEl = document.getElementById('statusMode');
    modeEl.textContent = simulating ? 'SIMULATE' : 'EDIT';
    modeEl.style.color = simulating ? 'var(--lg-success)' : 'var(--lg-accent)';
  }

  btnSim.addEventListener('click', () => {
    simulating = !simulating;
    updateModeUI();
    showHelp(simulating
      ? 'Simulation mode — click inputs to toggle. Press again to return to editing.'
      : 'Edit mode — place components and draw wires. Click Simulate to test.');
  });

  canvas._isSimulating = () => simulating;
  updateModeUI();

  /* ── Undo/Redo ── */
  const history = new L.History(40);
  history.push(circuit.toJSON()); // initial state

  function saveSnapshot() { history.push(circuit.toJSON()); }

  function restoreSnapshot(json) {
    if (!json) return;
    history.lock();
    const { circuit: restored } = L.Circuit.fromJSON(json, ALL_TYPES);
    canvas.setCircuit(restored);
    canvas.fitContent();
    // Update project reference
    project.circuits.get(project.activeName).circuit = restored;
    history.unlock();
  }

  // Hook: save snapshot before mutations
  circuit.onChange((type) => {
    if (type === 'addComponent' || type === 'removeComponent' ||
        type === 'addWire' || type === 'removeWire') {
      saveSnapshot();
    }
  });

  document.getElementById('btnUndo').addEventListener('click', () => restoreSnapshot(history.undo()));
  document.getElementById('btnRedo').addEventListener('click', () => restoreSnapshot(history.redo()));

  document.addEventListener('keydown', e => {
    if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA' || e.target.tagName === 'SELECT') return;
    if ((e.ctrlKey || e.metaKey) && e.key === 'z' && !e.shiftKey) { e.preventDefault(); restoreSnapshot(history.undo()); }
    if ((e.ctrlKey || e.metaKey) && (e.key === 'y' || (e.key === 'z' && e.shiftKey))) { e.preventDefault(); restoreSnapshot(history.redo()); }
  });

  /* ── Presets ── */
  const presetSelect = document.getElementById('presetSelect');
  const typeShortcuts = Object.assign({}, ALL_TYPES, {
    // Shortcuts for presets
    CLOCK: CLOCK_TYPE,
  });

  L.PRESETS.forEach((p, i) => {
    const opt = document.createElement('option');
    opt.value = i;
    opt.textContent = p.name;
    presetSelect.appendChild(opt);
  });

  presetSelect.addEventListener('change', () => {
    const idx = parseInt(presetSelect.value);
    if (isNaN(idx)) return;
    const preset = L.PRESETS[idx];
    if (!preset) return;
    if (circuit.components.size > 0 && !confirm('Load "' + preset.name + '"? Current circuit will be replaced.')) {
      presetSelect.value = '';
      return;
    }
    // Clear current
    [...circuit.components.keys()].forEach(id => circuit.removeComponent(id));
    // Build preset
    preset.build(circuit, typeShortcuts);
    canvas.fitContent();
    saveSnapshot();
    presetSelect.value = '';
  });

  /* ── Library search ── */
  document.getElementById('libSearch').addEventListener('input', function() {
    const q = this.value.toLowerCase().trim();
    document.querySelectorAll('.lg-lib-item').forEach(el => {
      if (!q) { el.style.display = ''; return; }
      const text = el.textContent.toLowerCase();
      el.style.display = text.includes(q) ? '' : 'none';
    });
  });

  /* ── File I/O ── */
  document.getElementById('btnSave').addEventListener('click', () => {
    L.FileIO.saveJSON(circuit, 'circuit.json');
  });
  document.getElementById('btnLoad').addEventListener('click', () => {
    L.FileIO.loadJSON((err, json, name) => {
      if (err) { alert(err); return; }
      const { circuit: loaded } = L.Circuit.fromJSON(json, ALL_TYPES);
      // Replace current circuit
      const ids = [...circuit.components.keys()];
      ids.forEach(id => circuit.removeComponent(id));
      // Copy loaded into current circuit
      for (const comp of loaded.components.values()) {
        const c = circuit.addComponent(comp.typeDef, comp.x, comp.y, comp.attrs);
        c.rotation = comp.rotation;
      }
      for (const w of loaded.wires.values()) {
        // Remap: loaded component ids to new circuit ids
        // Since we added in same order, we can map by iteration order
      }
      // Simpler: just swap the circuit
      canvas.setCircuit(loaded);
      canvas.fitContent();
    });
  });
  document.getElementById('btnExportPNG').addEventListener('click', () => {
    L.FileIO.exportPNG(svgEl, 'circuit.png');
  });
  document.getElementById('btnExportSVG').addEventListener('click', () => {
    L.FileIO.exportSVG(svgEl, 'circuit.svg');
  });
  document.getElementById('btnShare').addEventListener('click', () => {
    const result = L.FileIO.shareURL(circuit);
    if (result.error) { alert(result.error); return; }
    navigator.clipboard.writeText(result.url).then(() => {
      alert('URL copied to clipboard!');
    }).catch(() => {
      prompt('Copy this URL:', result.url);
    });
  });
  // Load from URL hash on page load
  (function() {
    const hashData = L.FileIO.loadFromHash();
    if (hashData) {
      try {
        const { circuit: loaded } = L.Circuit.fromJSON(hashData, ALL_TYPES);
        canvas.setCircuit(loaded);
        canvas.fitContent();
      } catch(e) { console.warn('Failed to load from URL hash:', e); }
    }
  })();

  /* ── Project + Subcircuits ── */
  const project = new L.Project();
  project.setTypeRegistry(ALL_TYPES);
  project.addCircuit('main', circuit);

  // Tab rendering
  function renderTabs() {
    const tabsEl = document.getElementById('circuitTabs');
    tabsEl.querySelectorAll('.lg-circuit-tab').forEach(el => el.remove());
    const addBtn = document.getElementById('btnAddCircuit');
    project.getCircuitNames().forEach(name => {
      const btn = document.createElement('button');
      btn.className = 'lg-circuit-tab' + (name === project.activeName ? ' active' : '');
      btn.dataset.name = name;
      btn.textContent = name;
      btn.addEventListener('click', () => switchCircuit(name));
      btn.addEventListener('dblclick', () => {
        if (name === 'main') return;
        const newName = prompt('Rename circuit:', name);
        if (newName && newName.trim() && newName !== name) {
          const entry = project.circuits.get(name);
          project.circuits.delete(name);
          project.circuits.set(newName.trim(), entry);
          if (project.activeName === name) project.activeName = newName.trim();
          renderTabs();
        }
      });
      tabsEl.insertBefore(btn, addBtn);
    });
  }

  function switchCircuit(name) {
    project.setActive(name);
    const newCircuit = project.getActive();
    canvas.setCircuit(newCircuit);
    canvas.fitContent();
    renderTabs();
  }

  document.getElementById('btnAddCircuit').addEventListener('click', () => {
    const name = prompt('New circuit name:', 'circuit' + (project.circuits.size));
    if (!name || !name.trim()) return;
    const newC = new L.Circuit();
    project.addCircuit(name.trim(), newC);
    switchCircuit(name.trim());
    renderTabs();
  });

  // Save as subcircuit
  document.getElementById('btnSaveSubcircuit').addEventListener('click', () => {
    const name = prompt('Subcircuit name:', project.activeName === 'main' ? 'MySub' : project.activeName);
    if (!name || !name.trim()) return;
    const def = project.saveAsSubcircuit(name.trim());
    if (!def) {
      alert('Circuit must have at least one INPUT pin and one OUTPUT pin.');
      return;
    }
    // Register the subcircuit type globally
    const compType = def.toComponentType();
    ALL_TYPES[compType.type] = compType;
    // Add to library panel
    let libSub = document.getElementById('libSubcircuits');
    if (!libSub) {
      const header = document.createElement('div');
      header.className = 'lg-lib-header';
      header.textContent = 'Subcircuits';
      document.getElementById('libraryPanel').appendChild(header);
      libSub = document.createElement('div');
      libSub.id = 'libSubcircuits';
      document.getElementById('libraryPanel').appendChild(libSub);
    }
    makeLibItem(compType, libSub);
    alert('Saved "' + name.trim() + '" as subcircuit (' + def.numInputs + ' in, ' + def.numOutputs + ' out).');
  });

  // Drill-down: double-click subcircuit → view inner circuit
  const drillStack = []; // stack of { name, circuit }
  svgEl.addEventListener('dblclick', (e) => {
    const w = canvas.screenToWorld(e.clientX, e.clientY);
    const compId = canvas._hitComponent(w.x, w.y);
    if (!compId) return;
    const comp = canvas.circuit.components.get(compId);
    if (!comp || !comp.typeDef.isSubcircuit || !comp.attrs._inner) return;
    // Push current circuit onto drill stack
    drillStack.push({ name: project.activeName, circuit: canvas.circuit });
    // Switch to inner circuit
    canvas.setCircuit(comp.attrs._inner);
    canvas.fitContent();
    renderBreadcrumb();
  });

  function renderBreadcrumb() {
    const bc = document.getElementById('breadcrumb');
    if (drillStack.length === 0) { bc.style.display = 'none'; return; }
    bc.style.display = 'block';
    let html = '';
    drillStack.forEach((entry, i) => {
      html += '<a data-idx="' + i + '">' + _esc(entry.name) + '</a><span class="sep">&rsaquo;</span>';
    });
    html += '<span style="color:var(--lg-text);font-weight:600;">inner</span>';
    bc.innerHTML = html;
    bc.querySelectorAll('a').forEach(a => {
      a.addEventListener('click', () => {
        const idx = parseInt(a.dataset.idx);
        // Pop back to that level
        const target = drillStack[idx];
        drillStack.length = idx;
        canvas.setCircuit(target.circuit);
        canvas.fitContent();
        renderBreadcrumb();
      });
    });
  }

  renderTabs();

  /* ── Demo: place a default circuit (AND gate with 2 inputs + 1 output) ── */
  (function loadDemo() {
    const a = circuit.addComponent(PIN_TYPES.INPUT,  -120, -40, { label: 'A', state: L.FALSE });
    const b = circuit.addComponent(PIN_TYPES.INPUT,  -120,  40, { label: 'B', state: L.FALSE });
    const g = circuit.addComponent(GATE_TYPES.AND,      0,   0);
    const o = circuit.addComponent(PIN_TYPES.OUTPUT,  120,   0, { label: 'Q' });

    circuit.addWire(a.id, 0, g.id, 0);  // A → AND input 0
    circuit.addWire(b.id, 0, g.id, 1);  // B → AND input 1
    circuit.addWire(g.id, 2, o.id, 0);  // AND output → Q

    canvas.render();
  })();

})();
</script>

<!-- SEO Content + Footer Ad -->
<div style="max-width:1200px;margin:0 auto;padding:24px 16px;color:var(--lg-text);font:14px/1.7 'DM Sans',sans-serif;">

  <h2 style="font:600 20px/1.3 'Sora',sans-serif;margin:24px 0 12px;">About This Logic Gate Simulator</h2>
  <p>This free online logic gate simulator lets you design and test digital circuits directly in your browser. Inspired by <strong>Logisim</strong>, it provides a modern web-based alternative with no Java installation required. Build circuits with 53 component types across 8 categories, auto-generate truth tables and Karnaugh maps, minimize Boolean expressions with the Quine-McCluskey algorithm, and visualize signal timing.</p>

  <h2 style="font:600 20px/1.3 'Sora',sans-serif;margin:24px 0 12px;">Components</h2>
  <p><strong>Gates:</strong> AND, OR, NOT, NAND, NOR, XOR, XNOR, Buffer &mdash; all with configurable input count.</p>
  <p><strong>Memory:</strong> SR, D, JK, and T flip-flops (edge-triggered with async clear), 4-bit register, 4-bit binary counter with enable and overflow.</p>
  <p><strong>Arithmetic &amp; Plexers:</strong> Full adder, subtractor, comparator, 2:1 MUX, 1:2 DEMUX, 2:4 decoder.</p>
  <p><strong>Displays:</strong> 7-segment display, hex display with auto-decode, 8-bit LED bar, hex keypad, TTY text terminal.</p>
  <p><strong>TTL 7400 Series:</strong> 7400 (NAND), 7402 (NOR), 7404 (NOT), 7408 (AND), 7432 (OR), 7486 (XOR), 7474 (Dual D-FF), 7447 (BCD-to-7-seg), 74138 (3:8 decoder) &mdash; all with accurate DIP pin layouts.</p>

  <h2 style="font:600 20px/1.3 'Sora',sans-serif;margin:24px 0 12px;">Analysis Tools</h2>
  <p><strong>Truth Tables:</strong> Click Analyze to enumerate all 2<sup>n</sup> input combinations (up to 8 inputs) and see outputs for every combination.</p>
  <p><strong>Boolean Expressions:</strong> Automatically extract Sum of Products (SOP) from truth tables, then minimize using the Quine-McCluskey algorithm to find the simplest equivalent expression.</p>
  <p><strong>Karnaugh Maps:</strong> Visual K-map display for 2, 3, or 4 variable circuits with Gray code ordering.</p>
  <p><strong>Timing Diagrams:</strong> Record signal changes over time. Start a clock, toggle inputs, and watch waveforms update in real-time with color-coded HIGH/LOW/unknown states.</p>
  <p><strong>Expression &rarr; Circuit:</strong> Type a Boolean expression like <code>A&middot;B + &not;C</code> and the simulator generates the corresponding gate circuit automatically.</p>

  <h2 style="font:600 20px/1.3 'Sora',sans-serif;margin:24px 0 12px;">Frequently Asked Questions</h2>
  <details style="margin:8px 0;"><summary style="cursor:pointer;font-weight:600;">Is this a replacement for Logisim?</summary><p style="margin:8px 0 0 16px;">It covers the most commonly used Logisim features &mdash; gates, flip-flops, truth tables, K-maps, subcircuits &mdash; in a modern browser-based interface. No Java required. Advanced features like VHDL simulation and FPGA export are not yet supported.</p></details>
  <details style="margin:8px 0;"><summary style="cursor:pointer;font-weight:600;">How many inputs can I analyze?</summary><p style="margin:8px 0 0 16px;">Truth table generation supports up to 8 inputs (256 rows). Karnaugh maps are available for 2, 3, or 4 variables. The Quine-McCluskey minimizer works for any number of inputs.</p></details>
  <details style="margin:8px 0;"><summary style="cursor:pointer;font-weight:600;">Can I save my circuits?</summary><p style="margin:8px 0 0 16px;">Yes. Save as JSON file, export as PNG or SVG image, or share via URL. Circuits are encoded in the URL hash so anyone with the link sees your exact design.</p></details>
  <details style="margin:8px 0;"><summary style="cursor:pointer;font-weight:600;">What are subcircuits?</summary><p style="margin:8px 0 0 16px;">Subcircuits let you build a circuit (e.g., a half adder), save it, then reuse it as a single component in a larger design. Double-click a subcircuit to drill into its internal logic. This enables hierarchical design &mdash; build an ALU from adders, which are built from gates.</p></details>
  <details style="margin:8px 0;"><summary style="cursor:pointer;font-weight:600;">What do the TTL ICs simulate?</summary><p style="margin:8px 0 0 16px;">9 real-world 7400-series TTL ICs with accurate DIP pin layouts: 7400 (quad NAND), 7402 (quad NOR), 7404 (hex inverter), 7408 (quad AND), 7432 (quad OR), 7486 (quad XOR), 7474 (dual D flip-flop with active-low set/clear), 7447 (BCD to 7-segment decoder), and 74138 (3-to-8 line decoder).</p></details>

</div>

<!-- Analytics -->
<%@ include file="../modern/components/analytics.jsp" %>

</body>
</html>
