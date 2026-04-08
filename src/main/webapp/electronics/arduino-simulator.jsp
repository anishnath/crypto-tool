<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<jsp:include page="../modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="AI-Powered Arduino Simulator Online — Generate, Compile & Run Arduino, ESP32, Raspberry Pi Projects" />
    <jsp:param name="toolCategory" value="Electronics" />
    <jsp:param name="toolDescription" value="Free AI-powered Arduino simulator. Describe a project in plain English and AI generates both the code and circuit diagram. Auto-fix compile errors with AI. Supports Arduino Uno, ESP32, Raspberry Pi Pico, and 21 virtual components. Compile via arduino-cli, simulate with avr8js/QEMU. No installation required." />
    <jsp:param name="toolUrl" value="electronics/arduino-simulator.jsp" />
    <jsp:param name="toolImage" value="arduino-simulator.svg" />
    <jsp:param name="toolKeywords" value="ai arduino simulator, ai circuit generator, arduino simulator online, ai arduino code generator, arduino emulator, esp32 simulator, ai fix arduino errors, esp32-c3 emulator, raspberry pi pico simulator, avr simulator, arduino IDE online, virtual arduino, wokwi alternative, circuit simulator, ai electronics, arduino uno simulator, compile arduino online, ai explain arduino code, serial monitor, LED blink, servo control, LCD display, NeoPixel, DHT22 sensor, ai embedded systems" />
    <jsp:param name="breadcrumbCategoryUrl" value="electronics/" />
    <jsp:param name="educationalLevel" value="High School, Undergraduate, AP Physics, Engineering, Maker Education, IoT Development" />
    <jsp:param name="teaches" value="Arduino programming, ESP32 development, embedded systems, microcontroller basics, digital I/O, analog input, PWM output, serial communication, sensor interfacing, motor control, display programming, IoT prototyping, RISC-V architecture" />
    <jsp:param name="toolFeatures" value="AI project generator - describe in English and get code plus circuit diagram,AI error fix - automatically corrects compile errors,AI code explainer - explains code or circuit in plain English,6 board families: Arduino Uno/Nano ESP32 ESP32-C3 ESP32-S3 Raspberry Pi Pico Raspberry Pi 3B,Real CPU emulation: avr8js (16MHz AVR) rp2040js (125MHz ARM) QEMU (160MHz RISC-V and 240MHz Xtensa),Monaco code editor with C++ syntax highlighting and error markers,Compile via arduino-cli with DIO flash mode for ESP32,21 virtual components: LEDs buttons potentiometers servos buzzers LCD OLED 7-segment NeoPixel DHT22 HC-SR04 encoder keypad relay,Serial monitor with baud rate detection and bidirectional I/O,33 example sketches across 9 categories including multi-file projects,Wokwi-compatible diagram.json import/export with live editor sync,Server-side QEMU emulation with SSE streaming for ESP32 boards,Dark and light theme support,URL sharing for sketches" />
    <jsp:param name="faq1q" value="How does the AI Arduino project generator work?" />
    <jsp:param name="faq1a" value="Click the AI button or press Ctrl+Shift+A and describe your project in plain English, for example 'traffic light with 3 LEDs cycling red-yellow-green' or 'servo controlled by potentiometer with angle on LCD'. The AI generates both the complete Arduino sketch and a Wokwi-compatible circuit diagram with components and wiring, then loads everything into the editor and canvas ready to compile and run." />
    <jsp:param name="faq2q" value="Can AI fix my Arduino compile errors?" />
    <jsp:param name="faq2a" value="Yes. When compilation fails, an AI Fix button appears in the toolbar. Click it and the AI reads the error messages and your code, then replaces it with a corrected version. It understands Arduino-specific issues like missing libraries, incorrect pin modes, syntax errors, and type mismatches." />
    <jsp:param name="faq3q" value="What boards and components can I simulate?" />
    <jsp:param name="faq3a" value="6 board families and 21 virtual components. Boards: Arduino Uno, Arduino Nano, Raspberry Pi Pico, ESP32, ESP32-C3, ESP32-S3, Raspberry Pi 3B. Components: LEDs, push buttons, potentiometers, servo motors, buzzers, 7-segment displays, LCD 16x2, OLED SSD1306, NeoPixel, DHT22, HC-SR04 ultrasonic, rotary encoder, membrane keypad, relay, photoresistor, and NTC temperature sensor. The AI can generate circuits using any of these components." />
    <jsp:param name="faq4q" value="Is it free?" />
    <jsp:param name="faq4a" value="Yes, completely free with no signup required. AI code generation, AI error fixing, AI explanations, compilation, simulation, 33 example sketches, multi-file projects, and Wokwi-compatible diagram import/export are all available immediately with no account needed." />
</jsp:include>
<!-- Critical CSS inlined for fast LCP -->
<style>
:root,[data-theme="dark"]{--ard-bg:#111318;--ard-panel:#1a1d24;--ard-panel-deep:#14171c;--ard-border:#2d3139;--ard-text:#e2e8f0;--ard-muted:#64748b;--ard-accent:#06b6d4;--ard-editor-bg:#1e1e1e;--ard-success:#22c55e;--ard-error:#ef4444;--header-height-desktop:72px}
*{box-sizing:border-box;margin:0;padding:0}
body{background:var(--ard-bg);color:var(--ard-text);font-family:'DM Sans',sans-serif;margin:0;overflow:hidden}
.ard-app{display:flex;flex-direction:column;height:100vh;padding-top:var(--header-height-desktop)}
.ard-hero-bar{display:flex;align-items:center;justify-content:space-between;gap:12px;flex-wrap:wrap;flex-shrink:0;max-width:1400px;width:100%;margin:0 auto;padding:6px 12px;border-bottom:1px solid var(--ard-border);background:var(--ard-panel-deep)}
.ard-hero-h1{font:600 15px/1.3 'Sora',sans-serif;color:var(--ard-text);margin:0;white-space:nowrap}
.ard-main{display:flex;flex:1;min-height:0;overflow:hidden}
.ard-editor-side{display:flex;flex-direction:column;flex:1;min-width:0}
</style>

<!-- Fonts: preload then swap -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="preload" as="style" href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700&family=DM+Sans:wght@400;500;600&family=Fira+Code:wght@400;500&display=swap" onload="this.onload=null;this.rel='stylesheet'">
<noscript><link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700&family=DM+Sans:wght@400;500;600&family=Fira+Code:wght@400;500&display=swap" rel="stylesheet"></noscript>

<!-- CSS: defer non-critical, keep arduino-simulator.css as main -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css" media="print" onload="this.media='all'">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css" media="print" onload="this.media='all'">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css" media="print" onload="this.media='all'">
<link rel="stylesheet" href="<%=request.getContextPath()%>/electronics/css/arduino-simulator.css">

<!-- wokwi-elements: defer (not needed for LCP, canvas renders after) -->
<script defer src="https://unpkg.com/@wokwi/elements@0.48.3/dist/wokwi-elements.bundle.js"></script>
<!-- xterm.js: lazy-load (only needed for Pi 3B board) -->
<link rel="stylesheet" href="https://unpkg.com/xterm@5.3.0/css/xterm.css" media="print" onload="this.media='all'">
<script defer src="https://unpkg.com/xterm@5.3.0/lib/xterm.js"></script>
<!-- Theme + search -->
<script defer src="<%=request.getContextPath()%>/modern/js/dark-mode.js"></script>
<script defer src="<%=request.getContextPath()%>/modern/js/search.js"></script>
</head>
<body>
<%@ include file="../modern/components/nav-header.jsp" %>

<div class="ard-app" id="arduinoApp">

  <!-- H1 + top ad banner (collapses on mobile) -->
  <div class="ard-hero-bar">
    <h1 class="ard-hero-h1">Arduino & ESP32 Simulator Online</h1>
    <div class="ad-ard-hero">
      <%@ include file="../setupad.jsp"%>
    </div>
  </div>

  <!-- Mobile Tab Bar -->
  <nav class="ard-mobile-tabs" id="mobileTabs">
    <button class="ard-mtab active" data-tab="code">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/></svg>
      <span>&lt;/&gt; Code</span>
    </button>
    <button class="ard-mtab" data-tab="circuit">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 7V5a2 2 0 00-2-2h-4a2 2 0 00-2 2v2"/></svg>
      <span>Circuit</span>
    </button>
    <button class="ard-mtab" data-tab="serial">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 016.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 014 19.5v-15A2.5 2.5 0 016.5 2z"/></svg>
      <span>Serial</span>
    </button>
  </nav>

  <!-- Main Split Container -->
  <div class="ard-main" id="ardMain">

    <!-- LEFT: Editor Side -->
    <div class="ard-editor-side active" id="editorSide">

      <!-- File Explorer Sidebar -->
      <div class="ard-file-explorer" id="fileExplorer"></div>
      <div class="ard-fe-resize" id="feResize"></div>

      <!-- Editor Main Area -->
      <div style="flex:1;display:flex;flex-direction:column;overflow:hidden;min-width:0;">

      <!-- Editor Toolbar -->
      <div class="ard-editor-toolbar">
        <button class="ard-tb-btn ard-tb-compile" id="btnCompile" title="Compile only — check for errors (Ctrl+B)">
          <svg class="ard-tb-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14.7 6.3a1 1 0 000 1.4l1.6 1.6a1 1 0 001.4 0l3.77-3.77a6 6 0 01-7.94 7.94l-6.91 6.91a2.12 2.12 0 01-3-3l6.91-6.91a6 6 0 017.94-7.94l-3.76 3.76z"/></svg>
          <span>Compile</span>
          <svg class="ard-spinner" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10" stroke-dasharray="31.4 31.4" stroke-linecap="round"/></svg>
        </button>
        <button class="ard-tb-btn ard-tb-run" id="btnRun" title="Compile &amp; Run (Ctrl+Enter)">
          <svg class="ard-tb-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="5 3 19 12 5 21 5 3"/></svg>
          <span>Run</span>
        </button>
        <button class="ard-tb-btn ard-tb-stop" id="btnStop" title="Stop" disabled>
          <svg class="ard-tb-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="6" y="6" width="12" height="12" rx="1"/></svg>
        </button>
        <button class="ard-tb-btn" id="btnReset" title="Reset" disabled>
          <svg class="ard-tb-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 4v6h6"/><path d="M3.51 15a9 9 0 102.13-9.36L1 10"/></svg>
        </button>
        <div class="ard-tb-sep"></div>
        <select class="ard-examples-select" id="examplesSelect" title="Load an example sketch">
          <option value="">&#9733; Examples</option>
        </select>
        <div class="ard-tb-sep"></div>
        <button class="ard-tb-btn ard-tb-ai" id="btnAI" title="AI: Generate project from description (Ctrl+Shift+A)">
          <span>&#10024; AI</span>
        </button>
        <button class="ard-tb-btn ard-tb-aifix" id="btnAIFix" title="AI: Fix compile errors" style="display:none">
          <span>&#128295; Fix</span>
        </button>
        <button class="ard-tb-btn" id="btnAIExplain" title="AI: Explain code or circuit">
          <span>&#128161; Explain</span>
        </button>
        <div class="ard-tb-sep"></div>
        <button class="ard-tb-btn ard-tb-toggle" id="btnOutput"><span>Output</span></button>
        <span class="ard-compile-status" id="compileStatus"></span>
      </div>
      <!-- Error detail bar (shown when console is closed and there's an error) -->
      <div class="ard-error-bar" id="errorBar" style="display:none;"></div>

      <!-- File Tabs -->
      <div class="ard-file-tabs" id="fileTabs">
        <div class="ard-file-tab active">
          <span class="ard-file-tab-name">sketch.ino</span>
        </div>
      </div>

      <!-- Code Editor (Monaco mounts here) -->
      <div class="ard-editor-container" id="editorContainer"></div>

      <!-- Output Console (toggleable) -->
      <div class="ard-output-panel" id="outputPanel" style="display:none;">
        <div class="ard-output-resize" id="outputResize"></div>
        <div class="ard-output-header">
          <span>Output</span>
          <button id="btnOutputClear">Clear</button>
          <button class="ard-output-close" id="btnOutputClose">&times;</button>
        </div>
        <div class="ard-output-content" id="outputContent"></div>
      </div>
      </div><!-- end editor main area -->
    </div>

    <!-- Splitter -->
    <div class="ard-splitter" id="splitter"></div>

    <!-- RIGHT: Simulator Side -->
    <div class="ard-sim-side" id="simSide">

      <!-- Canvas Header -->
      <div class="ard-canvas-header">
        <div class="ard-canvas-header-left">
          <span class="ard-status-dot" id="statusDot"></span>
          <select class="ard-board-select" id="boardSelect">
            <option value="arduino:avr:uno">Arduino Uno</option>
            <option value="arduino:avr:nano">Arduino Nano</option>
            <option value="arduino:avr:mega" disabled title="Coming soon — requires extended port map">Arduino Mega (soon)</option>
            <option value="rp2040:rp2040:rpipico">Raspberry Pi Pico</option>
            <option value="rp2040:rp2040:rpipicow">Raspberry Pi Pico W</option>
            <option value="esp32:esp32:esp32">ESP32</option>
            <option value="esp32:esp32:esp32c3">ESP32-C3</option>
            <option value="esp32:esp32:esp32s3">ESP32-S3</option>
            <option value="pi:pi:raspi3b">Raspberry Pi 3B</option>
          </select>
        </div>
        <div class="ard-canvas-header-right">
          <button class="ard-tb-btn" id="btnZoomIn" title="Zoom in">+</button>
          <button class="ard-tb-btn" id="btnZoomOut" title="Zoom out">&minus;</button>
          <button class="ard-tb-btn" id="btnZoomReset" title="Reset view">100%</button>
          <select class="ard-speed-select" id="speedSelect" title="Simulation speed">
            <option value="0.25">0.25&times;</option>
            <option value="0.5">0.5&times;</option>
            <option value="1" selected>1&times;</option>
            <option value="2">2&times;</option>
            <option value="4">4&times;</option>
            <option value="8">Max</option>
          </select>
          <button class="ard-tb-btn" id="btnAddComponent" title="Add LED, button, sensor, display..."><span>+ Component</span></button>
          <button class="ard-tb-btn ard-tb-toggle" id="btnSerial"><span>Serial</span></button>
          <button class="ard-tb-btn" id="btnTheme">&#9788;</button>
        </div>
      </div>

      <!-- Canvas Area -->
      <div class="ard-canvas-area" id="canvasArea">
        <div class="ard-board-wrap">
          <wokwi-arduino-uno id="arduinoBoard"></wokwi-arduino-uno>
        </div>
        <div class="ard-components-area" id="componentsArea">
          <!-- Components added dynamically by presets / component panel -->
        </div>
        <!-- Wire banner -->
        <div class="ard-wire-banner" id="wireBanner">
          <span>Click a pin to connect</span>
          <button id="wireBannerCancel">Cancel</button>
        </div>
      </div>

      <!-- Serial Monitor -->
      <!-- Pi Terminal (xterm.js) — shown instead of serial monitor when Pi board is active -->
      <div class="ard-serial-panel" id="piTerminalPanel" style="height:300px; display:none;">
        <div class="ard-serial-resize" id="piTerminalResize"></div>
        <div class="ard-serial-header">
          <span class="ard-serial-title">Pi Terminal</span>
          <button id="btnPiTerminalClear">Clear</button>
          <button id="btnPiTerminalCollapse">&#9660;</button>
        </div>
        <div id="piTerminalContainer" style="flex:1;overflow:hidden;"></div>
      </div>

      <div class="ard-serial-panel" id="serialPanel" style="height:200px;">
        <div class="ard-serial-resize" id="serialResize"></div>
        <div class="ard-serial-header">
          <span class="ard-serial-title">Serial Monitor</span>
          <span class="ard-serial-baud" id="serialBaud"></span>
          <button id="btnSerialClear">Clear</button>
          <button id="btnSerialCollapse">&#9660;</button>
        </div>
        <div class="ard-serial-output" id="serialOutput"></div>
        <div class="ard-serial-input-row">
          <input type="text" class="ard-serial-input" id="serialInput" placeholder="Type message..." autocomplete="off">
          <button class="ard-serial-send" id="btnSerialSend">Send</button>
        </div>
      </div>
    </div>
  </div>
</div>

<script type="module">
import { AVRRunner } from '<%=request.getContextPath()%>/electronics/js/arduino/runner.js';
import { BoardBinding } from '<%=request.getContextPath()%>/electronics/js/arduino/bindings/board.js';
// LedBinding managed by ComponentPanel — no direct import needed
import { SerialMonitor } from '<%=request.getContextPath()%>/electronics/js/arduino/ui/serial-monitor.js';
import { ArduinoEditor } from '<%=request.getContextPath()%>/electronics/js/arduino/ui/editor.js';
import { ComponentPanel } from '<%=request.getContextPath()%>/electronics/js/arduino/ui/component-panel.js';
import { SimulatorCanvas } from '<%=request.getContextPath()%>/electronics/js/arduino/ui/canvas.js';
import { SelectionManager } from '<%=request.getContextPath()%>/electronics/js/arduino/ui/selection.js';
import { PinOverlay } from '<%=request.getContextPath()%>/electronics/js/arduino/ui/pin-overlay.js';
import { WireManager } from '<%=request.getContextPath()%>/electronics/js/arduino/ui/wire-manager.js';
import { PRESETS, getPresetsByCategory } from '<%=request.getContextPath()%>/electronics/js/arduino/presets.js';
// RP2040 modules — lazy loaded (only when Pico board is selected)
let _rp2040Modules = null;
async function loadRP2040Modules() {
  if (_rp2040Modules) return _rp2040Modules;
  const [runnerMod, bindingMod, parserMod] = await Promise.all([
    import('<%=request.getContextPath()%>/electronics/js/arduino/rp2040-runner.js'),
    import('<%=request.getContextPath()%>/electronics/js/arduino/bindings/pico-board.js'),
    import('<%=request.getContextPath()%>/electronics/js/arduino/uf2-parser.js'),
  ]);
  await import('<%=request.getContextPath()%>/electronics/js/arduino/ui/pico-board.js');
  _rp2040Modules = {
    RP2040Runner: runnerMod.RP2040Runner,
    PicoBoardBinding: bindingMod.PicoBoardBinding,
    uf2ToFlash: parserMod.uf2ToFlash,
  };
  return _rp2040Modules;
}
// ESP32-C3 modules — lazy loaded (only when ESP32-C3 board is selected)
let _esp32c3Modules = null;
async function loadESP32C3Modules() {
  if (_esp32c3Modules) return _esp32c3Modules;
  const [runnerMod, bindingMod, parserMod] = await Promise.all([
    import('<%=request.getContextPath()%>/electronics/js/arduino/esp32c3-runner.js'),
    import('<%=request.getContextPath()%>/electronics/js/arduino/bindings/esp32c3-board.js'),
    import('<%=request.getContextPath()%>/electronics/js/arduino/bin-parser.js'),
  ]);
  await import('<%=request.getContextPath()%>/electronics/js/arduino/ui/esp32c3-board.js');
  _esp32c3Modules = {
    ESP32C3Runner: runnerMod.ESP32C3Runner,
    ESP32C3BoardBinding: bindingMod.ESP32C3BoardBinding,
    binToFirmware: parserMod.binToFirmware,
    mergedBinToFirmware: parserMod.mergedBinToFirmware,
  };
  return _esp32c3Modules;
}
import { FileManager } from '<%=request.getContextPath()%>/electronics/js/arduino/ui/file-manager.js';
import { FileExplorer } from '<%=request.getContextPath()%>/electronics/js/arduino/ui/file-explorer.js';
import { exportDiagram, importDiagram, downloadDiagram, openDiagramFile } from '<%=request.getContextPath()%>/electronics/js/arduino/ui/diagram.js';
import { DiagramSync } from '<%=request.getContextPath()%>/electronics/js/arduino/ui/diagram-sync.js';
import { PiTerminal } from '<%=request.getContextPath()%>/electronics/js/arduino/ui/pi-terminal.js';
import { AIAssistant } from '<%=request.getContextPath()%>/electronics/js/arduino/ui/ai-assistant.js';

// ── DOM refs ──
const btnCompile = document.getElementById('btnCompile');
const btnRun = document.getElementById('btnRun');
const btnStop = document.getElementById('btnStop');
const btnReset = document.getElementById('btnReset');
const errorBar = document.getElementById('errorBar');
const btnOutput = document.getElementById('btnOutput');
const btnOutputClose = document.getElementById('btnOutputClose');
const btnOutputClear = document.getElementById('btnOutputClear');
const btnSerial = document.getElementById('btnSerial');
const btnTheme = document.getElementById('btnTheme');
const examplesSelect = document.getElementById('examplesSelect');
const compileStatus = document.getElementById('compileStatus');
const outputPanel = document.getElementById('outputPanel');
const outputContent = document.getElementById('outputContent');
const serialPanel = document.getElementById('serialPanel');
const statusDot = document.getElementById('statusDot');
const boardEl = document.getElementById('arduinoBoard');
// ledEl removed — components managed by componentPanel

// ── Editor ──
const editor = new ArduinoEditor(document.getElementById('editorContainer'));
editor.init().catch(err => {
  logOutput('Failed to load code editor: ' + err.message, 'error');
  outputPanel.style.display = 'flex';
  btnOutput.classList.add('active');
});

// ── File Manager + Explorer ──
const fileManager = new FileManager(editor);
editor.onReady(() => fileManager.init());
const fileExplorer = new FileExplorer(document.getElementById('fileExplorer'), fileManager);

// File explorer resize handle
{
  const feResize = document.getElementById('feResize');
  const feEl = document.getElementById('fileExplorer');
  let dragging = false, startX = 0, startW = 0;
  const onStart = (e) => { dragging = true; startX = e.touches ? e.touches[0].clientX : e.clientX; startW = feEl.offsetWidth; e.preventDefault(); };
  const onMove = (e) => { if (!dragging) return; const cx = e.touches ? e.touches[0].clientX : e.clientX; feEl.style.width = Math.max(120, Math.min(400, startW + cx - startX)) + 'px'; };
  const onEnd = () => { dragging = false; };
  feResize.addEventListener('mousedown', onStart);
  feResize.addEventListener('touchstart', onStart, { passive: false });
  document.addEventListener('mousemove', onMove);
  document.addEventListener('touchmove', onMove, { passive: false });
  document.addEventListener('mouseup', onEnd);
  document.addEventListener('touchend', onEnd);
}

// ── Serial Monitor ──
const serialMonitor = new SerialMonitor(
  document.getElementById('serialOutput'),
  {
    inputEl:  document.getElementById('serialInput'),
    sendBtn:  document.getElementById('btnSerialSend'),
    clearBtn: document.getElementById('btnSerialClear'),
    baudEl:   document.getElementById('serialBaud'),
  }
);

// ── Simulator Canvas (pan/zoom/drag) ──
const simCanvas = new SimulatorCanvas(document.getElementById('canvasArea'));

// ── Wire SVG layer (inside the canvas world) ──
const wireSvg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
wireSvg.classList.add('ard-wire-layer');
// No viewBox — SVG coordinates match CSS pixel space of the world div
simCanvas.world.appendChild(wireSvg);

// Wires are modeled as live pin-to-pin connections, so dragging only needs a reroute pass.
simCanvas.onDragMove = () => wireManager.refreshAllWires();
simCanvas.onDragEnd = () => wireManager.refreshAllWires();

// ── Pin Overlay (clickable dots on pins) ──
const pinOverlay = new PinOverlay(simCanvas.world);

// ── Wire Manager ──
const wireManager = new WireManager(wireSvg, pinOverlay);
pinOverlay.onPinClick((compId, pinName, wx, wy) => {
  wireManager.startWire(compId, pinName, wx, wy);
  const creating = wireManager.isCreating;
  wireBanner.classList.toggle('active', creating);
  simCanvas.suppressPan = creating;
});
wireManager.onWireCreated = () => {
  wireBanner.classList.remove('active');
  simCanvas.suppressPan = false;
};

// Update wire preview on mouse move over canvas
document.getElementById('canvasArea').addEventListener('mousemove', (e) => {
  if (wireManager.isCreating) {
    const w = simCanvas.toWorld(e.clientX, e.clientY);
    wireManager.updatePreview(w.x, w.y);
  }
});

// Wire banner cancel
const wireBanner = document.getElementById('wireBanner');
document.getElementById('wireBannerCancel').addEventListener('click', () => {
  wireManager.cancelWire();
  wireBanner.classList.remove('active');
  simCanvas.suppressPan = false;
});

// ── Component Panel ──
const componentPanel = new ComponentPanel(
  document.getElementById('componentsArea'),
  document.getElementById('btnAddComponent'),
  simCanvas
);

// Auto-create pin overlays when components are added/removed
componentPanel.onComponentAdded = (comp) => {
  // Wait a tick for the wokwi element to render
  setTimeout(() => {
    if (comp.element && comp.element.pinInfo) {
      pinOverlay.updateComponent(comp.id, comp.element, comp.wrapper);
      wireManager.refreshAllWires();
    }
  }, 100);
};
componentPanel.onComponentRemoved = (compId) => {
  wireManager.removeWiresForComponent(compId);
  pinOverlay.removeComponent(compId);
};

// ── Selection Manager ──
const selection = new SelectionManager(simCanvas, componentPanel);
selection.onDeleteWire((wireId) => wireManager.removeWire(wireId));
selection.onEscape(() => { wireManager.cancelWire(); wireBanner.classList.remove('active'); simCanvas.suppressPan = false; });

// Wire selection integration
wireManager.onSelectWire((wireId) => selection.selectWire(wireId));

// Click on canvas world to select/deselect components
simCanvas.world.addEventListener('mousedown', (e) => {
  const draggable = simCanvas._findDraggable(e.target);
  if (draggable && draggable.classList.contains('ard-component-item')) {
    selection.selectComponent(draggable);
  } else if (!e.target.closest('.ard-wire-layer') && !e.target.closest('.ard-pin-overlay')) {
    selection.deselect();
  }
});

// Initialize board pin overlay — retry until wokwi element renders pinInfo
function initBoardPins(retries = 10) {
  const boardInner = document.getElementById('arduinoBoard');
  const boardWrap = document.querySelector('.ard-board-wrap');
  if (boardInner && boardInner.pinInfo && boardInner.pinInfo.length > 0) {
    pinOverlay.updateComponent('board', boardInner, boardWrap);
    return;
  }
  if (retries > 0) setTimeout(() => initBoardPins(retries - 1), 300);
}
initBoardPins();

// Load default Blink preset on startup (code + components)
{
  const blink = PRESETS.find(p => p.id === 'blink');
  if (blink) {
    editor.onReady(() => editor.setCode(blink.code));
    componentPanel.loadPreset(blink.components || []);
  } else {
    componentPanel.loadPreset([
      { type: 'led', pin: 13, x: 340, y: 20, attrs: { color: 'green' } },
    ]);
  }
}

// ── diagram.json sync (two-way: editor ↔ canvas) ──
const diagramSync = new DiagramSync(
  fileManager,
  componentPanel,
  wireManager,
  simCanvas,
  () => document.getElementById('arduinoBoard')?.tagName?.toLowerCase() || 'wokwi-arduino-uno',
  async (fqbn) => {
    document.getElementById('boardSelect').value = fqbn;
    await switchBoard(fqbn);
  }
);

// ── Pi Terminal ──
const piTerminal = new PiTerminal(document.getElementById('piTerminalContainer'));
const piTerminalPanel = document.getElementById('piTerminalPanel');

// Toggle between serial monitor and Pi terminal
function _showPiTerminal(show) {
  piTerminalPanel.style.display = show ? 'flex' : 'none';
  serialPanel.style.display = show ? 'none' : 'flex';
  if (show) {
    piTerminal.fit();
  }
}

// Pi terminal panel buttons
document.getElementById('btnPiTerminalClear')?.addEventListener('click', () => piTerminal.clear());
{
  let savedH = '300px';
  document.getElementById('btnPiTerminalCollapse')?.addEventListener('click', () => {
    const collapsed = piTerminalPanel.style.height === '28px';
    if (!collapsed) { savedH = piTerminalPanel.style.height || '300px'; piTerminalPanel.style.height = '28px'; }
    else { piTerminalPanel.style.height = savedH; piTerminal.fit(); }
  });
}

// Pi terminal resize handle
{
  const resize = document.getElementById('piTerminalResize');
  if (resize) {
    let dragging = false, startY = 0, startH = 0;
    const onStart = (e) => { dragging = true; startY = e.touches ? e.touches[0].clientY : e.clientY; startH = piTerminalPanel.offsetHeight; e.preventDefault(); };
    const onMove = (e) => { if (!dragging) return; const cy = e.touches ? e.touches[0].clientY : e.clientY; let h = startH - (cy - startY); h = Math.max(100, Math.min(600, h)); piTerminalPanel.style.height = h + 'px'; piTerminal.fit(); };
    const onEnd = () => { dragging = false; };
    resize.addEventListener('mousedown', onStart);
    resize.addEventListener('touchstart', onStart, { passive: false });
    document.addEventListener('mousemove', onMove);
    document.addEventListener('touchmove', onMove, { passive: false });
    document.addEventListener('mouseup', onEnd);
    document.addEventListener('touchend', onEnd);
  }
}

// ── State ──
let runner = null;
let boardBinding = null;
// ledBinding removed — managed by componentPanel.setRunner()

// ── Splitter (horizontal, editor ↔ simulator) ──
const splitter = document.getElementById('splitter');
const editorSide = document.getElementById('editorSide');
{
  let dragging = false;
  const onStart = (e) => {
    dragging = true;
    document.body.classList.add('ard-dragging');
    e.preventDefault();
  };
  const onMove = (e) => {
    if (!dragging) return;
    const clientX = e.touches ? e.touches[0].clientX : e.clientX;
    const main = document.getElementById('ardMain');
    const rect = main.getBoundingClientRect();
    let pct = ((clientX - rect.left) / rect.width) * 100;
    pct = Math.max(20, Math.min(80, pct));
    editorSide.style.width = pct + '%';
  };
  const onEnd = () => {
    if (dragging) { dragging = false; document.body.classList.remove('ard-dragging'); }
  };
  splitter.addEventListener('mousedown', onStart);
  splitter.addEventListener('touchstart', onStart, { passive: false });
  document.addEventListener('mousemove', onMove);
  document.addEventListener('touchmove', onMove, { passive: false });
  document.addEventListener('mouseup', onEnd);
  document.addEventListener('touchend', onEnd);
}

// ── Serial Resize (vertical) ──
{
  const serialResize = document.getElementById('serialResize');
  let dragging = false, startY = 0, startH = 0;
  const onStart = (e) => {
    dragging = true; startY = e.touches ? e.touches[0].clientY : e.clientY;
    startH = serialPanel.offsetHeight; document.body.classList.add('ard-dragging-v'); e.preventDefault();
  };
  const onMove = (e) => {
    if (!dragging) return;
    const clientY = e.touches ? e.touches[0].clientY : e.clientY;
    let h = startH - (clientY - startY); h = Math.max(80, Math.min(400, h));
    serialPanel.style.height = h + 'px';
  };
  const onEnd = () => { if (dragging) { dragging = false; document.body.classList.remove('ard-dragging-v'); } };
  serialResize.addEventListener('mousedown', onStart);
  serialResize.addEventListener('touchstart', onStart, { passive: false });
  document.addEventListener('mousemove', onMove);
  document.addEventListener('touchmove', onMove, { passive: false });
  document.addEventListener('mouseup', onEnd);
  document.addEventListener('touchend', onEnd);
}

// ── Output Resize (vertical) ──
{
  const outputResize = document.getElementById('outputResize');
  let dragging = false, startY = 0, startH = 0;
  const onStart = (e) => {
    dragging = true; startY = e.touches ? e.touches[0].clientY : e.clientY;
    startH = outputPanel.offsetHeight; document.body.classList.add('ard-dragging-v'); e.preventDefault();
  };
  const onMove = (e) => {
    if (!dragging) return;
    const clientY = e.touches ? e.touches[0].clientY : e.clientY;
    let h = startH - (clientY - startY); h = Math.max(80, Math.min(400, h));
    outputPanel.style.height = h + 'px';
  };
  const onEnd = () => { if (dragging) { dragging = false; document.body.classList.remove('ard-dragging-v'); } };
  outputResize.addEventListener('mousedown', onStart);
  outputResize.addEventListener('touchstart', onStart, { passive: false });
  document.addEventListener('mousemove', onMove);
  document.addEventListener('touchmove', onMove, { passive: false });
  document.addEventListener('mouseup', onEnd);
  document.addEventListener('touchend', onEnd);
}

// ── Output toggle ──
btnOutput.addEventListener('click', () => {
  const open = outputPanel.style.display !== 'none';
  outputPanel.style.display = open ? 'none' : 'flex';
  outputPanel.style.height = outputPanel.style.height || '180px';
  btnOutput.classList.toggle('active', !open);
});
btnOutputClose.addEventListener('click', () => {
  outputPanel.style.display = 'none';
  btnOutput.classList.remove('active');
});
btnOutputClear.addEventListener('click', () => { outputContent.textContent = ''; });

// ── Serial toggle ──
btnSerial.addEventListener('click', () => {
  const open = serialPanel.style.display !== 'none';
  serialPanel.style.display = open ? 'none' : 'flex';
  btnSerial.classList.toggle('active', !open);
});
serialPanel.style.display = 'flex';
btnSerial.classList.add('active');

// ── Serial collapse ──
{
  let savedHeight = '200px';
  document.getElementById('btnSerialCollapse').addEventListener('click', () => {
    const collapsed = serialPanel.style.height === '28px';
    if (!collapsed) {
      savedHeight = serialPanel.style.height || '200px';
      serialPanel.style.height = '28px';
    } else {
      serialPanel.style.height = savedHeight;
    }
  });
}

// ── Theme toggle ──
// Syncs: nav header (dark-mode.js), editor toolbar, canvas header buttons + Monaco
const btnThemeEditor = document.getElementById('btnThemeEditor');
function syncEditorTheme() {
  const isDark = document.documentElement.getAttribute('data-theme') === 'dark';
  editor.setTheme(isDark ? 'vs-dark' : 'vs');
  const icon = isDark ? '\u2606' : '\u263E';
  btnTheme.textContent = icon;
  if (btnThemeEditor) btnThemeEditor.textContent = icon;
}
function toggleTheme() {
  if (window.darkMode) {
    window.darkMode.toggle();
  } else {
    const html = document.documentElement;
    const isDark = html.getAttribute('data-theme') === 'dark';
    html.setAttribute('data-theme', isDark ? 'light' : 'dark');
  }
  syncEditorTheme();
}
btnTheme.addEventListener('click', toggleTheme);
if (btnThemeEditor) btnThemeEditor.addEventListener('click', toggleTheme);
// Sync on page load (respect saved preference from dark-mode.js)
setTimeout(syncEditorTheme, 100);
// Watch for theme changes from nav header button
new MutationObserver(syncEditorTheme).observe(document.documentElement, { attributes: true, attributeFilter: ['data-theme'] });

// ── Mobile tabs ──
document.querySelectorAll('.ard-mtab').forEach(btn => {
  btn.addEventListener('click', () => {
    document.querySelectorAll('.ard-mtab').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    const tab = btn.dataset.tab;
    editorSide.classList.toggle('active', tab === 'code');
    document.getElementById('simSide').classList.toggle('active', tab === 'circuit' || tab === 'serial');
    const canvasArea = document.getElementById('canvasArea');
    if (tab === 'serial') {
      const piMode = isPi(document.getElementById('boardSelect').value);
      if (piMode && piTerminalPanel && piTerminalPanel.style.display !== 'none') {
        piTerminalPanel.style.display = 'flex';
        piTerminalPanel.classList.add('tab-active');
        serialPanel.style.display = 'none';
        requestAnimationFrame(() => piTerminal.fit());
      } else {
        serialPanel.style.display = 'flex';
        serialPanel.classList.add('tab-active');
        piTerminalPanel.style.display = 'none';
      }
      canvasArea.style.display = 'none';
    } else {
      serialPanel.classList.remove('tab-active');
      if (piTerminalPanel) piTerminalPanel.classList.remove('tab-active');
      canvasArea.style.display = '';
    }
  });
});

// ── Compile & Run ──
function logOutput(text, cls) {
  const line = document.createElement('div');
  if (cls) line.className = cls;
  const now = new Date();
  const ts = [now.getHours(), now.getMinutes(), now.getSeconds()].map(n => String(n).padStart(2,'0')).join(':');
  line.textContent = ts + '  ' + text;
  outputContent.appendChild(line);
  outputContent.scrollTop = outputContent.scrollHeight;
}

let isCompiling = false;
let lastCompiledHex = null;
let lastCompileErrors = '';

function updateButtonStates() {
  btnRun.disabled = _isStarting; // Run always enabled except during compile/start
  btnStop.disabled = !runner;
  btnReset.disabled = !runner;
}

/**
 * Compile the sketch. Returns hex string on success, null on failure.
 * @param {boolean} [showPanel=true] - show output panel
 */
async function compile(showPanel = true) {
  if (isCompiling) return null;
  isCompiling = true;

  // Export files for compile (multi-file aware)
  const exportData = fileManager.exportForCompile();

  // UI: show spinner, disable compile
  btnCompile.classList.add('compiling');
  errorBar.style.display = 'none';

  if (showPanel) {
    outputPanel.style.display = 'flex';
    outputPanel.style.height = outputPanel.style.height || '180px';
    btnOutput.classList.add('active');
  }
  outputContent.textContent = '';

  compileStatus.textContent = '\u27F3 Compiling...';
  compileStatus.className = 'ard-compile-status compiling';
  editor.clearErrors();
  logOutput('Compiling ' + fileManager.count + ' file(s) for board: ' + document.getElementById('boardSelect').value);

  const startMs = performance.now();

  try {
    const resp = await fetch('<%=request.getContextPath()%>/api/arduino/compile', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        ...exportData,
        board: document.getElementById('boardSelect').value,
      }),
    });

    const data = await resp.json();
    const elapsed = ((performance.now() - startMs) / 1000).toFixed(1);

    if (!resp.ok || data.success === false) {
      const msg = data.message || 'Compilation failed';
      compileStatus.textContent = '\u2717 Error';
      compileStatus.className = 'ard-compile-status error';
      logOutput(msg, 'error');

      // Show error bar when console is closed
      if (outputPanel.style.display === 'none') {
        errorBar.textContent = msg;
        errorBar.style.display = 'block';
      }

      if (data.errors && data.errors.length) {
        editor.setErrors(data.errors);
        editor.setWarnings(data.warnings || []);
        lastCompileErrors = data.errors.map(e => 'Line ' + (e.line || '?') + ': ' + e.message).join('\n');
        for (const e of data.errors) {
          logOutput('  Line ' + (e.line || '?') + ': ' + e.message, 'error');
        }
        // Show AI Fix button
        document.getElementById('btnAIFix').style.display = '';
      }
      if (data.warnings && data.warnings.length) {
        for (const w of data.warnings) {
          logOutput('  Warning line ' + (w.line || '?') + ': ' + w.message, 'warning');
        }
      }
      if (data.rawOutput) logOutput(data.rawOutput);
      lastCompiledHex = null;
      return null;
    }

    // Success
    lastCompileErrors = '';
    document.getElementById('btnAIFix').style.display = 'none';
    const fmt = data.outputFormat || 'hex';
    lastCompiledHex = data.hex || data.uf2 || data.bin || data.jobId || null;
    logOutput('Compiled in ' + elapsed + 's (' + fmt.toUpperCase() + ')', 'success');
    if (data.programSize) {
      logOutput('Sketch uses ' + data.programSize + ' bytes (' +
        Math.round(data.programSize / (data.maxSize || 32256) * 100) + '%)');
    }
    if (data.warnings && data.warnings.length) {
      editor.setWarnings(data.warnings);
      for (const w of data.warnings) {
        logOutput('  Warning line ' + (w.line || '?') + ': ' + w.message, 'warning');
      }
    }

    compileStatus.textContent = '\u2713 ' + elapsed + 's';
    compileStatus.className = 'ard-compile-status success';
    errorBar.style.display = 'none';

    // Return full response for format-aware handling
    return data;

  } catch (err) {
    compileStatus.textContent = '\u2717 Failed';
    compileStatus.className = 'ard-compile-status error';
    logOutput('Network error: ' + err.message, 'error');
    lastCompiledHex = null;
    return null;
  } finally {
    isCompiling = false;
    btnCompile.classList.remove('compiling');
    updateButtonStates();
  }
}

let _isStarting = false;
async function compileAndRun() {
  if (_isStarting) return;
  _isStarting = true;
  btnRun.disabled = true;
  try {
    const board = document.getElementById('boardSelect').value;
    // Pi boards: no compilation — boot the OS directly
    if (isPi(board)) {
      await startPiRunner();
      return;
    }
    const result = await compile(true);
    if (result) await startRunnerFromCompile(result);
  } finally {
    _isStarting = false;
    updateButtonStates();
  }
}

/**
 * Start the appropriate runner based on compile result.
 * @param {object} result - { hex, uf2, outputFormat } from compile response
 */
async function startRunnerFromCompile(result) {
  if (!result) return;
  const fmt = result.outputFormat || (result.uf2 ? 'uf2' : result.bin ? 'bin' : 'hex');

  if (fmt === 'uf2' && result.uf2) {
    try {
      const mods = await loadRP2040Modules();
      const flash = mods.uf2ToFlash(result.uf2);
      await startRP2040Runner(flash, mods);
    } catch (err) {
      logOutput('RP2040 error: ' + err.message, 'error');
    }
  } else if (fmt === 'bin') {
    try {
      // ESP32 boards: use server-side QEMU emulation via SSE streaming
      const board = document.getElementById('boardSelect').value;
      if (result.jobId) {
        // Job-based flow: firmware stays on server, just send jobId
        await startQemuRunner(board, null, result.jobId);
      } else if (result.mergedBin || result.bin) {
        // Legacy fallback: send base64 firmware
        await startQemuRunner(board, result.mergedBin || result.bin, null);
      } else {
        logOutput('No firmware in compile response', 'error');
      }
    } catch (err) {
      logOutput('ESP32-C3 error: ' + err.message, 'error');
    }
  } else if (result.hex) {
    startRunner(result.hex);
  } else {
    logOutput('No runnable binary in compile response.', 'error');
  }
}

function startRunner(hex) {
  stopRunner();

  runner = new AVRRunner(hex);

  const currentBoard = document.getElementById('arduinoBoard');
  boardBinding = new BoardBinding(currentBoard, runner);
  boardBinding.attach();

  serialMonitor.clear();
  serialMonitor.attach(runner);
  componentPanel.setRunner(runner);

  runner.speed = parseFloat(document.getElementById('speedSelect').value);
  runner.start();

  statusDot.classList.add('running');
  btnRun.disabled = false;
  btnRun.classList.add('running');
  btnRun.querySelector('span').textContent = 'Running';
  updateButtonStates();
}

async function startRP2040Runner(flashImage, mods) {
  stopRunner();
  if (!mods) mods = await loadRP2040Modules();

  runner = new mods.RP2040Runner(flashImage);

  const currentBoard = document.getElementById('arduinoBoard');
  if (currentBoard.tagName.toLowerCase() === 'pico-board') {
    boardBinding = new mods.PicoBoardBinding(currentBoard, runner);
  } else {
    boardBinding = new BoardBinding(currentBoard, runner);
  }
  boardBinding.attach();

  serialMonitor.clear();
  serialMonitor.attach(runner);
  componentPanel.setRunner(runner);

  runner.speed = parseFloat(document.getElementById('speedSelect').value);
  runner.start();

  statusDot.classList.add('running');
  btnRun.disabled = false;
  btnRun.classList.add('running');
  btnRun.querySelector('span').textContent = 'Running';
  updateButtonStates();
}

/**
 * QEMU-backed runner for ESP32 boards.
 * Starts a server-side QEMU instance and streams serial/GPIO events via SSE.
 */
let _qemuSessionId = null;
let _qemuEventSource = null;

async function startQemuRunner(board, firmwareB64, jobId) {
  stopRunner();

  // Generate a unique session ID
  _qemuSessionId = 'sim-' + Date.now() + '-' + Math.random().toString(36).slice(2, 8);

  logOutput('Starting QEMU simulation (' + board + ')...');

  // 1. Start QEMU instance on server
  const startBody = { id: _qemuSessionId, board };
  if (jobId) startBody.jobId = jobId;
  else if (firmwareB64) startBody.firmware = firmwareB64;

  let startData;
  try {
    const startResp = await fetch('<%=request.getContextPath()%>/api/arduino/simulate/start', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(startBody),
    });
    if (!startResp.ok) throw new Error('Server returned ' + startResp.status);
    startData = await startResp.json();
  } catch (err) {
    logOutput('Simulation service unavailable: ' + err.message, 'error');
    compileStatus.textContent = '\u2717 Service unavailable';
    compileStatus.className = 'ard-compile-status error';
    return;
  }
  if (!startData.success) {
    logOutput('Simulation start failed: ' + (startData.error || 'unknown'), 'error');
    compileStatus.textContent = '\u2717 ' + (startData.error || 'Start failed');
    compileStatus.className = 'ard-compile-status error';
    return;
  }

  // Create a lightweight runner shim so the UI (serial monitor, buttons) works
  // MUST be created BEFORE connecting SSE stream so serialMonitor.attach() wires onSerial first.
  runner = {
    running: true,
    speed: 1,
    onSerial: null,
    _pinChangeListeners: [],
    addPinChangeListener(fn) {
      this._pinChangeListeners.push(fn);
      return () => { const i = this._pinChangeListeners.indexOf(fn); if (i >= 0) this._pinChangeListeners.splice(i, 1); };
    },
    addPwmChangeListener() { return () => {}; },
    setPinState() {},
    setADCValue() {},
    start() { this.running = true; },
    pause() { this.running = false; },
    stop() {
      this.running = false;
      if (_qemuEventSource) { _qemuEventSource.close(); _qemuEventSource = null; }
      if (_qemuSessionId) {
        fetch('<%=request.getContextPath()%>/api/arduino/simulate/stop', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ id: _qemuSessionId }),
        }).catch(() => {});
        _qemuSessionId = null;
      }
    },
    reset() { /* QEMU restart not implemented yet */ },
    // Serial input (user types in serial monitor)
    usart: {
      writeByte(b) {
        if (!_qemuSessionId) return;
        fetch('<%=request.getContextPath()%>/api/arduino/simulate/input', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ id: _qemuSessionId, data: String.fromCharCode(b) }),
        }).catch(() => {});
      }
    },
    vRef: 3.3,
  };

  // Wire up board binding — wokwi-esp32-devkit-v1 for all ESP32 variants
  const currentBoard = document.getElementById('arduinoBoard');
  const fqbn = document.getElementById('boardSelect').value;
  // LED pin differs by variant: GPIO2 (ESP32), GPIO8 (C3), GPIO48 (S3)
  const ledPin = fqbn.includes('esp32c3') ? 8 : fqbn.includes('esp32s3') ? 48 : 2;
  boardBinding = {
    attach() {
      currentBoard.ledPower = true;
      this._unsub = runner.addPinChangeListener((pin, high) => {
        if (pin === ledPin) currentBoard.led1 = high;
      });
    },
    detach() {
      if (this._unsub) this._unsub();
      currentBoard.ledPower = false;
      currentBoard.led1 = false;
    },
  };
  boardBinding.attach();

  serialMonitor.clear();
  serialMonitor.attach(runner);
  componentPanel.setRunner(runner);

  // 2. Connect SSE stream AFTER serialMonitor.attach() has wired runner.onSerial
  _qemuEventSource = new EventSource(
    '<%=request.getContextPath()%>/api/arduino/simulate/stream?id=' + encodeURIComponent(_qemuSessionId)
  );

  // Filter out QEMU crash dumps from serial output so users see clean output
  let _qemuCrashFilter = false;

  _qemuEventSource.onmessage = (event) => {
    try {
      const ev = JSON.parse(event.data);
      if (ev.type === 'serial_output' && ev.data?.data) {
        const text = ev.data.data;
        // Detect start of crash dump and suppress everything after it
        if (text.includes('Guru Meditation Error') || text.includes('Core  0 register dump')) {
          _qemuCrashFilter = true;
          // Show a clean message instead
          if (runner.onSerial) {
            const msg = '\n[Simulation ended — watchdog timeout]\n';
            for (const ch of msg) runner.onSerial(ch);
          }
          return;
        }
        if (_qemuCrashFilter) return; // suppress crash dump lines
        if (runner.onSerial) {
          for (const ch of text) runner.onSerial(ch);
        }
      } else if (ev.type === 'gpio_change' && ev.data) {
        for (const fn of runner._pinChangeListeners) fn(ev.data.pin, !!ev.data.state);
      } else if (ev.type === 'system') {
        const evt = ev.data?.event || '';
        const bootMessages = {
          booting:         '\u23F3 Starting emulator...',
          booted:          '\u2705 Connected to emulator',
          boot_reset:      '\u27F3 ESP32 reset...',
          boot_loading:    '\u27F3 Loading firmware...',
          boot_entry:      '\u27F3 Entering application...',
          boot_setup:      '\u2705 Running setup()',
          boot_kernel:     '\u27F3 Loading Linux kernel...',
          boot_smp:        '\u27F3 Starting CPU cores...',
          boot_network:    '\u27F3 Initializing network...',
          boot_sdcard:     '\u27F3 Reading SD card...',
          boot_filesystem: '\u27F3 Mounting filesystem...',
          boot_systemd:    '\u27F3 Starting services...',
          boot_login:      '\u2705 Login prompt ready',
          boot_ready:      '\u2705 Raspberry Pi is ready!',
        };
        if (evt === 'exited') {
          compileStatus.textContent = '';
          compileStatus.className = 'ard-compile-status';
          stopRunner(); updateButtonStates();
        } else if (bootMessages[evt]) {
          compileStatus.textContent = bootMessages[evt];
          compileStatus.className = 'ard-compile-status compiling';
          if (evt.startsWith('boot_setup') || evt === 'boot_login' || evt === 'boot_ready') {
            compileStatus.className = 'ard-compile-status success';
            btnRun.querySelector('span').textContent = 'Running';
          }
        }
      } else if (ev.type === 'error') {
        logOutput('Error: ' + (ev.data?.message || ''), 'error');
        compileStatus.textContent = '\u2717 Error';
        compileStatus.className = 'ard-compile-status error';
      }
    } catch (e) {}
  };

  _qemuEventSource.onerror = () => {
    logOutput('Simulation stream disconnected', 'error');
    compileStatus.textContent = '\u2717 Disconnected';
    compileStatus.className = 'ard-compile-status error';
    stopRunner();
    updateButtonStates();
  };

  statusDot.classList.add('running');
  btnRun.disabled = false;
  btnRun.classList.add('running');
  btnRun.querySelector('span').textContent = 'Booting...';
  updateButtonStates();
  logOutput('Simulation started (id: ' + _qemuSessionId + ')');
}

/**
 * Pi 3 runner — boots Raspberry Pi OS in QEMU. No compilation needed.
 * Uses /api/arduino/simulate/pi/ endpoints (proxied to Go API /api/pi-simulate/).
 */
async function startPiRunner() {
  // Pi simulation is temporarily at capacity — show friendly message
  compileStatus.textContent = '\u23F3 Pi machines are busy';
  compileStatus.className = 'ard-compile-status compiling';
  logOutput('All Raspberry Pi machines are currently occupied. Please try again in a few minutes.', 'warning');
  logOutput('Tip: ESP32 and Arduino boards are available immediately — select one from the board dropdown.');
  setTimeout(() => {
    compileStatus.textContent = '';
    compileStatus.className = 'ard-compile-status';
  }, 5000);
  return;

  // ── Original Pi boot code (re-enable when Pi QEMU image is ready) ──
  stopRunner();

  _qemuSessionId = 'pi-' + Date.now() + '-' + Math.random().toString(36).slice(2, 8);

  compileStatus.textContent = '\u23F3 Booting Raspberry Pi...';
  compileStatus.className = 'ard-compile-status compiling';
  logOutput('Starting Raspberry Pi 3B...');

  // 1. Start Pi QEMU instance
  let startData;
  try {
    const startResp = await fetch('<%=request.getContextPath()%>/api/arduino/simulate/pi/start', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ id: _qemuSessionId }),
    });
    if (!startResp.ok) throw new Error('Server returned ' + startResp.status);
    startData = await startResp.json();
  } catch (err) {
    logOutput('Pi simulation service unavailable: ' + err.message, 'error');
    compileStatus.textContent = '\u2717 Service unavailable';
    compileStatus.className = 'ard-compile-status error';
    return;
  }
  if (!startData.success) {
    logOutput('Pi start failed: ' + (startData.error || 'unknown'), 'error');
    compileStatus.textContent = '\u2717 ' + (startData.error || 'Start failed');
    compileStatus.className = 'ard-compile-status error';
    return;
  }

  // 2. Runner shim (same as ESP32 but serial input goes to Pi endpoints)
  runner = {
    running: true,
    speed: 1,
    onSerial: null,
    _pinChangeListeners: [],
    addPinChangeListener(fn) {
      this._pinChangeListeners.push(fn);
      return () => { const i = this._pinChangeListeners.indexOf(fn); if (i >= 0) this._pinChangeListeners.splice(i, 1); };
    },
    addPwmChangeListener() { return () => {}; },
    setPinState() {},
    setADCValue() {},
    start() { this.running = true; },
    pause() { this.running = false; },
    stop() {
      this.running = false;
      if (_qemuEventSource) { _qemuEventSource.close(); _qemuEventSource = null; }
      if (_qemuSessionId) {
        fetch('<%=request.getContextPath()%>/api/arduino/simulate/pi/stop', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ id: _qemuSessionId }),
        }).catch(() => {});
        _qemuSessionId = null;
      }
    },
    reset() {},
    usart: {
      writeByte(b) {
        if (!_qemuSessionId) return;
        fetch('<%=request.getContextPath()%>/api/arduino/simulate/pi/input', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ id: _qemuSessionId, data: String.fromCharCode(b) }),
        }).catch(() => {});
      }
    },
    vRef: 3.3,
  };

  // 4. Open xterm.js terminal (instead of serial monitor for Pi)
  _showPiTerminal(true);
  piTerminal.open();
  // Defer fit() — browser needs one frame to paint the container at its real size
  requestAnimationFrame(() => piTerminal.fit());

  // Wire keyboard input → QEMU
  piTerminal.onInput = (data) => {
    if (!_qemuSessionId) return;
    fetch('<%=request.getContextPath()%>/api/arduino/simulate/pi/input', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ id: _qemuSessionId, data }),
    }).catch(() => {});
  };

  // 5. SSE → xterm + boot progress
  // 5. Connect SSE AFTER terminal is open and onmessage handler is ready
  _qemuEventSource = new EventSource(
    '<%=request.getContextPath()%>/api/arduino/simulate/pi/stream?id=' + encodeURIComponent(_qemuSessionId)
  );

  _qemuEventSource.onmessage = (event) => {
    try {
      const ev = JSON.parse(event.data);
      if (ev.type === 'serial_output' && ev.data?.data) {
        piTerminal.write(ev.data.data);
      } else if (ev.type === 'gpio_change' && ev.data) {
        for (const fn of runner._pinChangeListeners) fn(ev.data.pin, !!ev.data.state);
      } else if (ev.type === 'system') {
        const evt = ev.data?.event || '';
        const bootMessages = {
          booting: '\u23F3 Starting Raspberry Pi...',
          booted: '\u2705 Connected',
          boot_kernel: '\u27F3 Loading Linux kernel...',
          boot_smp: '\u27F3 Starting CPU cores...',
          boot_network: '\u27F3 Initializing network...',
          boot_sdcard: '\u27F3 Reading SD card...',
          boot_filesystem: '\u27F3 Mounting filesystem...',
          boot_systemd: '\u27F3 Starting services...',
          boot_login: '\u2705 Login prompt ready',
          boot_ready: '\u2705 Raspberry Pi is ready!',
        };
        if (evt === 'exited') {
          compileStatus.textContent = '';
          compileStatus.className = 'ard-compile-status';
          stopRunner(); updateButtonStates();
        } else if (bootMessages[evt]) {
          compileStatus.textContent = bootMessages[evt];
          const bootDone = evt.includes('login') || evt.includes('ready');
          compileStatus.className = bootDone ? 'ard-compile-status success' : 'ard-compile-status compiling';
          if (bootDone) {
            btnRun.querySelector('span').textContent = 'Running';
            piTerminal.focus();
          }
        }
      } else if (ev.type === 'error') {
        logOutput('Error: ' + (ev.data?.message || ''), 'error');
        compileStatus.textContent = '\u2717 Error';
        compileStatus.className = 'ard-compile-status error';
      }
    } catch (e) {}
  };

  _qemuEventSource.onerror = () => {
    logOutput('Pi stream disconnected', 'error');
    compileStatus.textContent = '\u2717 Disconnected';
    compileStatus.className = 'ard-compile-status error';
    stopRunner();
    updateButtonStates();
  };

  // 6. Board binding
  const currentBoard = document.getElementById('arduinoBoard');
  boardBinding = {
    attach() { currentBoard.ledPower = true; },
    detach() { currentBoard.ledPower = false; },
  };
  boardBinding.attach();

  statusDot.classList.add('running');
  btnRun.disabled = false;
  btnRun.classList.add('running');
  btnRun.querySelector('span').textContent = 'Booting Pi...';
  updateButtonStates();
}

function stopRunner() {
  if (!runner) return;
  runner.stop();
  if (boardBinding) boardBinding.detach();
  serialMonitor.detach();
  componentPanel.detachAll();
  // Close Pi terminal only if it was active
  if (piTerminalPanel.style.display !== 'none') {
    piTerminal.close();
    _showPiTerminal(false);
  }
  runner = null;
  boardBinding = null;

  statusDot.classList.remove('running');
  btnRun.classList.remove('running');
  btnRun.querySelector('span').textContent = 'Run';
  // Component visuals reset by componentPanel.detachAll()
}

// Compile button — compile only, check errors
btnCompile.addEventListener('click', () => compile(true));

// Run button — compile (if needed) and start simulation
btnRun.addEventListener('click', () => {
  if (runner && runner.running) {
    runner.pause();
    statusDot.classList.remove('running');
    btnRun.querySelector('span').textContent = 'Resume';
    btnRun.classList.remove('running');
  } else if (runner && !runner.running) {
    runner.start();
    statusDot.classList.add('running');
    btnRun.querySelector('span').textContent = 'Running';
    btnRun.classList.add('running');
  } else {
    compileAndRun();
  }
});

btnStop.addEventListener('click', () => {
  stopRunner();
  updateButtonStates();
});

btnReset.addEventListener('click', () => {
  if (runner) {
    runner.reset();
    serialMonitor.clear();
  }
});

// ── Examples (from presets.js) ──
{
  // Populate dropdown with grouped presets
  const groups = getPresetsByCategory();
  examplesSelect.innerHTML = '<option value="">Examples...</option>';
  for (const [category, presets] of Object.entries(groups)) {
    const optgroup = document.createElement('optgroup');
    optgroup.label = category;
    for (const p of presets) {
      const opt = document.createElement('option');
      opt.value = p.id;
      opt.textContent = p.title;
      optgroup.appendChild(opt);
    }
    examplesSelect.appendChild(optgroup);
  }

  examplesSelect.addEventListener('change', async () => {
    const selectedId = examplesSelect.value;
    if (!selectedId) return;
    logOutput('Loading preset: ' + selectedId);
    const preset = PRESETS.find(p => p.id === selectedId);
    if (preset) {
      // Switch board to match preset (default to Uno for AVR presets)
      const targetBoard = preset.board || 'arduino:avr:uno';
      const boardSelect = document.getElementById('boardSelect');
      if (boardSelect.value !== targetBoard) {
        boardSelect.value = targetBoard;
        await switchBoard(targetBoard);
        logOutput('Board switched to ' + boardSelect.options[boardSelect.selectedIndex].text + ' for this preset');
      }
      stopRunner();
      wireManager.clear();
      selection.deselect();

      // Load files: multi-file presets have files[], single-file have just code
      if (preset.files && preset.files.length) {
        const allFiles = [{ name: 'sketch.ino', content: preset.code }, ...preset.files];
        fileManager.loadFiles(allFiles);
      } else {
        fileManager.loadFiles([{ name: 'sketch.ino', content: preset.code }]);
      }

      // Load circuit: diagram takes priority over components[]
      if (preset.diagram && preset.diagram.parts) {
        // Import diagram (creates components + wires)
        await importDiagram(preset.diagram, componentPanel, wireManager, simCanvas, async () => {}).catch(e => console.error('Diagram import failed:', e));
      } else {
        componentPanel.loadPreset(preset.components || []);
      }

      // Show description in output
      if (preset.description) {
        logOutput(preset.title + ': ' + preset.description);
      }
    }
    examplesSelect.value = '';
  });
}

// ── Keyboard shortcuts ──
document.addEventListener('keydown', (e) => {
  if (e.ctrlKey || e.metaKey) {
    if (e.key === 'Enter') {
      e.preventDefault();
      if (!runner) compileAndRun();
    } else if (e.key === 's' || e.key === 'S') {
      e.preventDefault(); // prevent browser save dialog
      // Save current editor content to file manager and clear modified dots
      fileManager.files[fileManager.activeIndex].content = editor.getCode();
      fileManager.markAllSaved();
      compileStatus.textContent = 'Saved';
      compileStatus.className = 'ard-compile-status success';
      setTimeout(() => { compileStatus.textContent = ''; compileStatus.className = 'ard-compile-status'; }, 1500);
    } else if (e.key === 'b' || e.key === 'B') {
      e.preventDefault();
      compile(true); // Ctrl+B = compile only
    }
  }
});

// Initial button states
updateButtonStates();

// ── AI Assistant ──
const aiAssistant = new AIAssistant({
  ctx: '<%=request.getContextPath()%>',
  getCode: () => editor.getCode(),
  setCode: (code) => {
    // Update sketch.ino content without resetting the file list
    // (loadFiles would destroy diagram.json during streaming)
    fileManager.files[0].content = code;
    if (fileManager.activeIndex === 0) {
      editor.setCode(code);
    }
  },
  getSelection: () => {
    const m = editor._editor;
    return m ? m.getModel().getValueInRange(m.getSelection()) : '';
  },
  getBoard: () => document.getElementById('boardSelect').value,
  loadPreset: async (preset) => {
    const targetBoard = preset.board || 'arduino:avr:uno';
    const boardSelect = document.getElementById('boardSelect');
    if (boardSelect.value !== targetBoard) {
      boardSelect.value = targetBoard;
      await switchBoard(targetBoard);
    }
    stopRunner();
    wireManager.clear();
    selection.deselect();

    // Build file list: always sketch.ino, add diagram.json if AI generated a circuit
    const files = [{ name: 'sketch.ino', content: preset.code }];
    if (preset.diagram && preset.diagram.parts) {
      files.push({ name: 'diagram.json', content: JSON.stringify(preset.diagram, null, 2) });
    }
    fileManager.loadFiles(files);

    // Import diagram onto canvas
    if (preset.diagram && preset.diagram.parts) {
      try {
        const result = await importDiagram(preset.diagram, componentPanel, wireManager, simCanvas, async (fqbn) => {
          boardSelect.value = fqbn;
          await switchBoard(fqbn);
        });
        if (result.errors && result.errors.length) {
          for (const err of result.errors) {
            logOutput('  ⚠ Diagram: ' + err, 'warning');
          }
        }
        logOutput('  Canvas: ' + result.partsLoaded + ' components, ' + result.wiresLoaded + ' wires loaded');
      } catch (e) {
        logOutput('Circuit import failed: ' + e.message, 'warning');
      }
    }
  },
  getErrors: () => lastCompileErrors,
  getDiagram: () => exportDiagram(componentPanel, wireManager),
  logOutput: (text, replace) => {
    if (replace) {
      // Replace last line (for streaming updates)
      const last = outputContent.lastElementChild;
      if (last && last.dataset.aiStream) {
        last.textContent = text;
        outputContent.scrollTop = outputContent.scrollHeight;
        return;
      }
    }
    const line = document.createElement('div');
    if (replace) line.dataset.aiStream = '1';
    line.textContent = text;
    outputContent.appendChild(line);
    outputContent.scrollTop = outputContent.scrollHeight;
    // Ensure output panel is visible
    outputPanel.style.display = 'flex';
    outputPanel.style.height = outputPanel.style.height || '180px';
    btnOutput.classList.add('active');
  }
});

// Wire AI toolbar buttons
document.getElementById('btnAI').addEventListener('click', () => aiAssistant.openPrompt());
document.getElementById('btnAIFix').addEventListener('click', () => aiAssistant.fix());
document.getElementById('btnAIExplain').addEventListener('click', () => aiAssistant.explain());

// ── Board Switcher ──
const BOARD_TAGS = {
  'arduino:avr:uno':  'wokwi-arduino-uno',
  'arduino:avr:nano': 'wokwi-arduino-nano',
  'arduino:avr:mega': 'wokwi-arduino-mega',
  'rp2040:rp2040:rpipico':  'pico-board',
  'rp2040:rp2040:rpipicow': 'pico-board',
  'esp32:esp32:esp32c3':    'wokwi-esp32-devkit-v1',
  'esp32:esp32:esp32':      'wokwi-esp32-devkit-v1',
  'esp32:esp32:esp32s3':    'wokwi-esp32-devkit-v1',
  'pi:pi:raspi3b':          'pi3-board',
};

/** Check if a board FQBN is RP2040-based */
function isRP2040(fqbn) { return fqbn.startsWith('rp2040:'); }
/** Check if a board FQBN is AVR-based */
function isAVR(fqbn) { return fqbn.startsWith('arduino:avr:'); }
/** Check if a board FQBN is ESP32-family (any variant) */
function isESP32(fqbn) { return fqbn.startsWith('esp32:'); }
/** Check if a board FQBN is ESP32-C3 specifically */
function isESP32C3(fqbn) { return fqbn === 'esp32:esp32:esp32c3'; }
/** Check if a board FQBN is Raspberry Pi */
function isPi(fqbn) { return fqbn.startsWith('pi:'); }

/**
 * Switch the board element on the canvas.
 * Async: pre-loads custom element modules for RP2040/ESP32-C3 before creating the element.
 * @param {string} fqbn - board FQBN
 */
async function switchBoard(fqbn) {
  const tag = BOARD_TAGS[fqbn];
  if (!tag) return;

  // Pre-load custom element definitions for boards with lazy-loaded elements.
  if (isRP2040(fqbn)) await loadRP2040Modules();
  if (isPi(fqbn)) await import('<%=request.getContextPath()%>/electronics/js/arduino/ui/pi3-board.js');

  // Stop simulation and clear stale compile result
  stopRunner();
  lastCompiledHex = null;
  updateButtonStates();

  // Swap board SVG element
  const boardWrap = document.querySelector('.ard-board-wrap');
  const oldBoard = boardWrap.querySelector('[id="arduinoBoard"]');

  // Remove old pin overlay for board
  pinOverlay.removeComponent('board');
  wireManager.refreshAllWires();

  // Create new board element
  const newBoard = document.createElement(tag);
  newBoard.id = 'arduinoBoard';

  // Replace old with new
  if (oldBoard) oldBoard.remove();
  boardWrap.appendChild(newBoard);

  // Wait for element to render, then re-init pin overlay
  const waitForBoard = (retries = 10) => {
    const el = document.getElementById('arduinoBoard');
    if (el && el.pinInfo && el.pinInfo.length > 0) {
      pinOverlay.updateComponent('board', el, boardWrap);
      wireManager.refreshAllWires();
      return;
    }
    if (retries > 0) setTimeout(() => waitForBoard(retries - 1), 200);
  };
  waitForBoard();

  // Pi boards: hide compile button, change Run label; show for others
  const piMode = isPi(fqbn);
  btnCompile.style.display = piMode ? 'none' : '';
  btnRun.querySelector('span').textContent = piMode ? 'Boot Pi' : 'Run';
  // Show a hint in the editor for Pi (only if editor is empty or has default code)
  if (piMode) {
    editor.onReady(() => {
      const code = editor.getCode().trim();
      if (!code || code.startsWith('void setup') || code.startsWith('//')) {
        editor.setCode('// Raspberry Pi 3B — click "Boot Pi" to start.\n// The Pi runs Raspberry Pi OS. Use the Serial Monitor as a terminal.\n// Type Linux commands (ls, echo, python3, etc.)\n');
      }
    });
  }
}

document.getElementById('boardSelect').addEventListener('change', async (e) => {
  const fqbn = e.target.value;
  const boardName = e.target.options[e.target.selectedIndex].text;
  await switchBoard(fqbn);

  // Auto-load matching starter preset so code matches the board.
  // Find the first preset that targets this board (or default Blink for AVR).
  const matchingPreset = PRESETS.find(p => p.board === fqbn)
    || (fqbn.startsWith('arduino:avr:') ? PRESETS.find(p => p.id === 'blink') : null);

  if (matchingPreset) {
    // If user hasn't modified the code (still a preset), auto-switch
    const currentCode = editor.getCode().trim();
    const isDefaultCode = PRESETS.some(p => p.code.trim() === currentCode)
      || currentCode === '' || currentCode.startsWith('//');

    if (isDefaultCode) {
      stopRunner();
      wireManager.clear();
      if (matchingPreset.files && matchingPreset.files.length) {
        fileManager.loadFiles([{ name: 'sketch.ino', content: matchingPreset.code }, ...matchingPreset.files]);
      } else {
        fileManager.loadFiles([{ name: 'sketch.ino', content: matchingPreset.code }]);
      }
      if (matchingPreset.diagram && matchingPreset.diagram.parts) {
        importDiagram(matchingPreset.diagram, componentPanel, wireManager, simCanvas, async () => {}).catch(() => {});
      } else {
        componentPanel.loadPreset(matchingPreset.components || []);
      }
      logOutput('Switched to ' + boardName + ' — loaded "' + matchingPreset.title + '" example');
    } else {
      logOutput('Switched to ' + boardName + ' — your code was kept. Check pin numbers match the new board.', 'warning');
    }
  } else {
    logOutput('Switched to ' + boardName);
  }
});

// ── Zoom buttons ──
document.getElementById('btnZoomIn').addEventListener('click', () => {
  simCanvas.zoom = Math.min(3, simCanvas.zoom * 1.2);
  simCanvas._applyTransform();
});
document.getElementById('btnZoomOut').addEventListener('click', () => {
  simCanvas.zoom = Math.max(0.3, simCanvas.zoom / 1.2);
  simCanvas._applyTransform();
});
document.getElementById('btnZoomReset').addEventListener('click', () => {
  simCanvas.zoom = 1; simCanvas.pan = { x: 0, y: 0 };
  simCanvas._applyTransform();
});

// ── Speed control ──
const speedSelect = document.getElementById('speedSelect');
speedSelect.addEventListener('change', () => {
  const speed = parseFloat(speedSelect.value);
  if (runner) runner.speed = speed;
});

// ── URL sharing (sketch in hash) ──
function encodeSketchToHash() {
  const code = editor.getCode();
  const compressed = btoa(unescape(encodeURIComponent(code)));
  window.location.hash = 'sketch=' + compressed;
  // Copy URL to clipboard
  const status = document.getElementById('compileStatus');
  if (navigator.clipboard && navigator.clipboard.writeText) {
    navigator.clipboard.writeText(window.location.href).then(() => {
      status.textContent = 'URL copied!';
      status.className = 'ard-compile-status success';
      setTimeout(() => { status.textContent = ''; status.className = 'ard-compile-status'; }, 2000);
    }).catch(() => {
      status.textContent = 'URL updated (copy from address bar)';
      status.className = 'ard-compile-status';
      setTimeout(() => { status.textContent = ''; }, 3000);
    });
  } else {
    status.textContent = 'URL updated (copy from address bar)';
    status.className = 'ard-compile-status';
    setTimeout(() => { status.textContent = ''; }, 3000);
  }
}

function loadSketchFromHash() {
  const hash = window.location.hash;
  if (!hash.startsWith('#sketch=')) return;
  try {
    const compressed = hash.substring(8);
    const code = decodeURIComponent(escape(atob(compressed)));
    if (code.length > 0) {
      editor.onReady(() => editor.setCode(code));
    }
  } catch (e) {
    console.warn('Failed to load sketch from URL:', e);
  }
}

// Load sketch from URL on page load
loadSketchFromHash();

// Share button — add to canvas header (reuse theme button pattern)
const shareBtn = document.createElement('button');
shareBtn.className = 'ard-tb-btn';
shareBtn.title = 'Share sketch URL';
shareBtn.innerHTML = '<span>Share</span>';
shareBtn.addEventListener('click', encodeSketchToHash);
document.getElementById('btnTheme').before(shareBtn);

// ── Diagram import/export buttons ──
const diagramExportBtn = document.createElement('button');
diagramExportBtn.className = 'ard-tb-btn';
diagramExportBtn.title = 'Export circuit as diagram.json (Wokwi-compatible)';
diagramExportBtn.innerHTML = '<span>\u2B07 Diagram</span>';
diagramExportBtn.addEventListener('click', () => {
  const boardEl = document.getElementById('arduinoBoard');
  const boardTag = boardEl?.tagName?.toLowerCase() || 'wokwi-arduino-uno';
  const boardPos = { x: 0, y: 0 };
  const diagram = exportDiagram(boardTag, 'board', boardPos, componentPanel.components, wireManager.wires);
  downloadDiagram(diagram);
  compileStatus.textContent = 'Diagram exported';
  compileStatus.className = 'ard-compile-status success';
  setTimeout(() => { compileStatus.textContent = ''; compileStatus.className = 'ard-compile-status'; }, 2000);
});
document.getElementById('btnTheme').before(diagramExportBtn);

const diagramImportBtn = document.createElement('button');
diagramImportBtn.className = 'ard-tb-btn';
diagramImportBtn.title = 'Import diagram.json (Wokwi-compatible)';
diagramImportBtn.innerHTML = '<span>\u2B06 Diagram</span>';
diagramImportBtn.addEventListener('click', async () => {
  const diagram = await openDiagramFile();
  if (!diagram) return;
  compileStatus.textContent = '\u27F3 Loading diagram...';
  compileStatus.className = 'ard-compile-status compiling';
  const result = await importDiagram(diagram, componentPanel, wireManager, simCanvas, async (fqbn) => {
    document.getElementById('boardSelect').value = fqbn;
    await switchBoard(fqbn);
  });
  if (result.errors.length) {
    logOutput('Diagram import: ' + result.errors.join('; '), 'warning');
  }
  compileStatus.textContent = '\u2713 Loaded ' + result.partsLoaded + ' parts, ' + result.wiresLoaded + ' wires';
  compileStatus.className = 'ard-compile-status success';
  setTimeout(() => { compileStatus.textContent = ''; compileStatus.className = 'ard-compile-status'; }, 3000);
});
document.getElementById('btnTheme').before(diagramImportBtn);
</script>

<!-- SEO Content + Footer Ads (below the simulator fold) -->
<div style="max-width:1200px;margin:0 auto;padding:24px 16px;color:var(--ard-text);font:14px/1.7 'DM Sans',sans-serif;">

  <!-- Footer Ad -->
  <div style="text-align:center;margin:16px 0;">
    <%@ include file="../footer_adsense.jsp"%>
  </div>

  <h2 style="font:600 20px/1.3 'Sora',sans-serif;margin:24px 0 12px;">About This Arduino Simulator</h2>
  <p>This free online Arduino simulator lets you write, compile, and run Arduino C++ code directly in your browser. No software installation required. Supports 6 board families: <strong>Arduino Uno</strong>, <strong>Arduino Nano</strong>, <strong>Raspberry Pi Pico</strong>, <strong>ESP32</strong>, <strong>ESP32-C3</strong>, <strong>ESP32-S3</strong>, and <strong>Raspberry Pi 3B</strong>.</p>

  <h2 style="font:600 20px/1.3 'Sora',sans-serif;margin:24px 0 12px;">How It Works</h2>
  <p><strong>Arduino Uno/Nano:</strong> Your sketch compiles to AVR machine code using the real <code>arduino-cli</code> toolchain. The compiled hex runs on a cycle-accurate ATmega328p emulator (<a href="https://github.com/niccolocastelli/avr8js" rel="noopener">avr8js</a>) at 16MHz in your browser. All 21 virtual components (LEDs, buttons, potentiometers, servos, LCD, OLED, sensors) are interactive.</p>
  <p><strong>Raspberry Pi Pico:</strong> Compiled UF2 firmware runs on an RP2040 emulator (<a href="https://github.com/niccolocastelli/rp2040js" rel="noopener">rp2040js</a>) at 125MHz in your browser. Supports GPIO, ADC, PWM, and UART.</p>
  <p><strong>ESP32 / ESP32-C3 / ESP32-S3:</strong> Sketches compile with DIO flash mode and run on <a href="https://github.com/niccolocastelli/qemu" rel="noopener">Espressif's QEMU</a> on our server. Serial output and GPIO pin changes stream to your browser in real-time via SSE. A compile-time GPIO bridge visualizes <code>digitalWrite()</code> calls as LED state changes.</p>

  <h2 style="font:600 20px/1.3 'Sora',sans-serif;margin:24px 0 12px;">Supported Components</h2>
  <p>21 virtual components with live SVG rendering: LED (red/green/yellow/RGB), push button, potentiometer, slide potentiometer, slide switch, servo motor, buzzer (Web Audio), relay, NeoPixel, 7-segment display, rotary encoder, membrane keypad, LCD 16x2, OLED SSD1306, DHT22 temperature sensor, HC-SR04 ultrasonic sensor, NTC temperature sensor, and photoresistor (LDR). Components are powered by <a href="https://github.com/niccolocastelli/wokwi-elements" rel="noopener">wokwi-elements</a> (MIT licensed).</p>

  <h2 style="font:600 20px/1.3 'Sora',sans-serif;margin:24px 0 12px;">Features</h2>
  <ul style="padding-left:20px;">
    <li>Monaco code editor with C++ syntax highlighting and compile error markers</li>
    <li>33 example sketches across 9 categories (Basics, Input, Analog, Serial, Servo, Buzzer, RGB, Projects, ESP32)</li>
    <li>Multi-file project support (header files, libraries)</li>
    <li>Wokwi-compatible <code>diagram.json</code> import/export with live two-way editor sync</li>
    <li>Serial monitor with bidirectional I/O</li>
    <li>xterm.js Linux terminal for Raspberry Pi</li>
    <li>Dark and light theme</li>
    <li>Mobile responsive with tab switcher</li>
    <li>URL sharing for sketches</li>
    <li>Keyboard shortcuts: Ctrl+Enter (Run), Ctrl+B (Compile), Ctrl+S (Save)</li>
  </ul>

  <h2 style="font:600 20px/1.3 'Sora',sans-serif;margin:24px 0 12px;">Frequently Asked Questions</h2>
  <details style="margin:8px 0;"><summary style="cursor:pointer;font-weight:600;">Is this simulator free?</summary><p style="margin:8px 0 0 16px;">Yes, completely free with no signup required. Arduino and Pico simulations run in your browser. ESP32 simulations use shared server resources with automatic 10-minute timeout.</p></details>
  <details style="margin:8px 0;"><summary style="cursor:pointer;font-weight:600;">Can I use my own Arduino libraries?</summary><p style="margin:8px 0 0 16px;">The compile server includes popular libraries (Servo, Wire, SPI, Adafruit NeoPixel, DHT, LiquidCrystal, U8g2, FastLED, and more). You can also use multi-file projects with custom header files.</p></details>
  <details style="margin:8px 0;"><summary style="cursor:pointer;font-weight:600;">How is this different from Wokwi?</summary><p style="margin:8px 0 0 16px;">This simulator supports ESP32 via real QEMU emulation (not just browser-side), Raspberry Pi Pico, and Raspberry Pi 3B. It uses the same wokwi-elements for component visuals and supports Wokwi's diagram.json format for circuit interchange.</p></details>
  <details style="margin:8px 0;"><summary style="cursor:pointer;font-weight:600;">Why does my ESP32 sketch crash after 14 seconds?</summary><p style="margin:8px 0 0 16px;">ESP32-C3 QEMU has a watchdog timer limitation. ESP32 (Xtensa) runs indefinitely. The crash dump is filtered from the serial monitor.</p></details>

</div>

<!-- Analytics -->
<%@ include file="../modern/components/analytics.jsp" %>

</body>
</html>
