<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<jsp:include page="../modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="Arduino Simulator — Write, Compile & Run Arduino Code in Your Browser" />
    <jsp:param name="toolCategory" value="Electronics" />
    <jsp:param name="toolDescription" value="Browser-based Arduino simulator. Write Arduino C++ code, compile via arduino-cli, and run on a virtual ATmega328p with real CPU emulation. Interactive LEDs, buttons, potentiometers, servos, LCD, serial monitor. 23 virtual components, 15 example sketches. Powered by avr8js." />
    <jsp:param name="toolUrl" value="electronics/arduino-simulator.jsp" />
    <jsp:param name="toolKeywords" value="arduino simulator online, arduino emulator, avr simulator, arduino IDE online, virtual arduino, wokwi alternative, circuit simulator arduino, arduino uno simulator, compile arduino online, serial monitor, LED blink, analogWrite, servo control, LCD display arduino, potentiometer arduino" />
    <jsp:param name="breadcrumbCategoryUrl" value="electronics/" />
    <jsp:param name="educationalLevel" value="High School, Undergraduate, AP Physics, Engineering, Maker Education" />
    <jsp:param name="teaches" value="Arduino programming, embedded systems, microcontroller basics, digital I/O, analog input, PWM output, serial communication, sensor interfacing, motor control, display programming" />
    <jsp:param name="toolFeatures" value="Real AVR8 CPU emulation via avr8js at 16MHz,Monaco code editor with C++ syntax highlighting and error markers,Compile sketches via arduino-cli (Uno Nano Mega),23 virtual components: LEDs buttons potentiometers servos buzzers LCD OLED 7-segment NeoPixel DHT22 HC-SR04 stepper motor keypad relay shift register,Serial monitor with baud rate detection and send input,15 example sketches across 8 categories,PWM brightness and servo angle visualization,Resizable split-panel IDE layout,Dark and light theme support,Mobile responsive with tab switcher,URL sharing for sketches,Speed control 0.25x to 8x" />
    <jsp:param name="faq1q" value="What is this Arduino simulator?" />
    <jsp:param name="faq1a" value="A browser-based Arduino IDE that lets you write Arduino C++ code, compile it using the real arduino-cli toolchain, and run it on a virtual ATmega328p microcontroller. The CPU emulation is cycle-accurate using avr8js, supporting delay(), millis(), analogWrite(), Serial, and all standard Arduino functions." />
    <jsp:param name="faq2q" value="What components can I simulate?" />
    <jsp:param name="faq2a" value="23 virtual components including LEDs, RGB LEDs, push buttons, potentiometers, slide switches, servo motors, buzzers with Web Audio, 7-segment displays, LCD 16x2 (GPIO and I2C), OLED SSD1306, NeoPixel strips, DHT22 temperature sensor, HC-SR04 ultrasonic sensor, stepper motor, membrane keypad, rotary encoder, relay, 74HC595 shift register, LED bar graph, and photoresistor." />
    <jsp:param name="faq3q" value="How does compilation work?" />
    <jsp:param name="faq3a" value="Your Arduino sketch is sent to our server which runs arduino-cli with the real AVR GCC compiler. The compiled hex file is returned to your browser where it runs on the avr8js CPU emulator. Compilation typically takes 1-3 seconds." />
    <jsp:param name="faq4q" value="Is it free?" />
    <jsp:param name="faq4a" value="Yes completely free with no signup required. The simulator runs entirely in your browser after compilation. 15 example sketches are included and you can write any Arduino code. Rate limited to 10 compilations per hour." />
</jsp:include>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;500;600;700&family=DM+Sans:wght@400;500;600&family=Fira+Code:wght@400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=v%>">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=v%>">
<link rel="stylesheet" href="<%=request.getContextPath()%>/electronics/css/arduino-simulator.css?v=<%=v%>">

<!-- wokwi-elements: component visuals -->
<script src="https://unpkg.com/@wokwi/elements@0.48.3/dist/wokwi-elements.bundle.js"></script>
</head>
<body>
<%@ include file="../modern/components/nav-header.jsp" %>

<div class="ard-app" id="arduinoApp">

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
        <button class="ard-tb-btn ard-tb-compile" id="btnCompile" title="Compile only (check errors)">
          <svg class="ard-tb-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14.7 6.3a1 1 0 000 1.4l1.6 1.6a1 1 0 001.4 0l3.77-3.77a6 6 0 01-7.94 7.94l-6.91 6.91a2.12 2.12 0 01-3-3l6.91-6.91a6 6 0 017.94-7.94l-3.76 3.76z"/></svg>
          <span>Compile</span>
          <svg class="ard-spinner" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10" stroke-dasharray="31.4 31.4" stroke-linecap="round"/></svg>
        </button>
        <button class="ard-tb-btn ard-tb-run" id="btnRun" title="Compile &amp; Run" disabled>
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
        <select class="ard-examples-select" id="examplesSelect">
          <option value="">Examples...</option>
        </select>
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
            <option value="esp32:esp32:esp32c3">ESP32-C3</option>
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
          <button class="ard-tb-btn" id="btnAddComponent"><span>+ Component</span></button>
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

// Load default Blink components on startup
componentPanel.loadPreset([
  { type: 'led', pin: 13, x: 340, y: 20, attrs: { color: 'green' } },
]);

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
btnTheme.addEventListener('click', () => {
  const html = document.documentElement;
  const isDark = html.getAttribute('data-theme') === 'dark';
  html.setAttribute('data-theme', isDark ? 'light' : 'dark');
  editor.setTheme(isDark ? 'vs' : 'vs-dark');
  btnTheme.textContent = isDark ? '\u263E' : '\u2606';
});

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
      serialPanel.style.display = 'flex';
      serialPanel.classList.add('tab-active');
      canvasArea.style.display = 'none';
    } else {
      serialPanel.classList.remove('tab-active');
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

function updateButtonStates() {
  btnRun.disabled = !lastCompiledHex && !runner;
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
  logOutput('Compiling ' + fileManager.count + ' file(s)...');

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
        for (const e of data.errors) {
          logOutput('  Line ' + (e.line || '?') + ': ' + e.message, 'error');
        }
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
    const fmt = data.outputFormat || 'hex';
    lastCompiledHex = data.hex || data.uf2 || data.bin || null;
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

async function compileAndRun() {
  const result = await compile(true);
  if (result) await startRunnerFromCompile(result);
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

  const startResp = await fetch('<%=request.getContextPath()%>/api/arduino/simulate/start', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(startBody),
  });
  const startData = await startResp.json();
  if (!startData.success) {
    logOutput('QEMU start failed: ' + (startData.error || 'unknown'), 'error');
    return;
  }

  // 2. Connect SSE stream for serial/GPIO events
  _qemuEventSource = new EventSource(
    '<%=request.getContextPath()%>/api/arduino/simulate/stream?id=' + encodeURIComponent(_qemuSessionId)
  );

  // Create a lightweight runner shim so the UI (serial monitor, buttons) works
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

  _qemuEventSource.onmessage = (event) => {
    try {
      const ev = JSON.parse(event.data);
      if (ev.type === 'serial_output' && ev.data?.data) {
        // Forward to serial monitor
        if (runner.onSerial) {
          for (const ch of ev.data.data) runner.onSerial(ch);
        }
      } else if (ev.type === 'gpio_change' && ev.data) {
        const pin = ev.data.pin;
        const high = !!ev.data.state;
        for (const fn of runner._pinChangeListeners) fn(pin, high);
      } else if (ev.type === 'system') {
        const evt = ev.data?.event || '';
        if (evt === 'booted') logOutput('QEMU booted', 'success');
        else if (evt === 'exited') { logOutput('QEMU exited'); stopRunner(); updateButtonStates(); }
        else logOutput('QEMU: ' + evt);
      } else if (ev.type === 'error') {
        logOutput('QEMU error: ' + (ev.data?.message || ''), 'error');
      }
    } catch (e) {
      // ignore parse errors
    }
  };

  _qemuEventSource.onerror = () => {
    logOutput('QEMU stream disconnected', 'error');
  };

  // Wire up board binding
  const mods = await loadESP32C3Modules();
  const currentBoard = document.getElementById('arduinoBoard');
  if (currentBoard.tagName.toLowerCase() === 'esp32c3-board') {
    boardBinding = new mods.ESP32C3BoardBinding(currentBoard, runner);
  } else {
    boardBinding = new BoardBinding(currentBoard, runner);
  }
  boardBinding.attach();

  serialMonitor.clear();
  serialMonitor.attach(runner);
  componentPanel.setRunner(runner);

  statusDot.classList.add('running');
  btnRun.disabled = false;
  btnRun.classList.add('running');
  btnRun.querySelector('span').textContent = 'Running';
  updateButtonStates();
  logOutput('QEMU simulation started (id: ' + _qemuSessionId + ')');
}

function stopRunner() {
  if (!runner) return;
  runner.stop();
  if (boardBinding) boardBinding.detach();
  // ledBinding removed — managed by componentPanel
  serialMonitor.detach();
  componentPanel.detachAll();
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
    const preset = PRESETS.find(p => p.id === examplesSelect.value);
    if (preset) {
      // Switch board to match preset (default to Uno for AVR presets)
      const targetBoard = preset.board || 'arduino:avr:uno';
      const boardSelect = document.getElementById('boardSelect');
      if (boardSelect.value !== targetBoard) {
        boardSelect.value = targetBoard;
        await switchBoard(targetBoard);
      }
      stopRunner();
      wireManager.clear();
      selection.deselect();
      fileManager.loadFiles([{ name: 'sketch.ino', content: preset.code }]);
      componentPanel.loadPreset(preset.components || []);
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

// ── Board Switcher ──
const BOARD_TAGS = {
  'arduino:avr:uno':  'wokwi-arduino-uno',
  'arduino:avr:nano': 'wokwi-arduino-nano',
  'arduino:avr:mega': 'wokwi-arduino-mega',
  'rp2040:rp2040:rpipico':  'pico-board',
  'rp2040:rp2040:rpipicow': 'pico-board',
  'esp32:esp32:esp32c3':    'esp32c3-board',
};

/** Check if a board FQBN is RP2040-based */
function isRP2040(fqbn) { return fqbn.startsWith('rp2040:'); }
/** Check if a board FQBN is AVR-based */
function isAVR(fqbn) { return fqbn.startsWith('arduino:avr:'); }
/** Check if a board FQBN is ESP32-C3 */
function isESP32C3(fqbn) { return fqbn === 'esp32:esp32:esp32c3'; }

/**
 * Switch the board element on the canvas.
 * Async: pre-loads custom element modules for RP2040/ESP32-C3 before creating the element.
 * @param {string} fqbn - board FQBN
 */
async function switchBoard(fqbn) {
  const tag = BOARD_TAGS[fqbn];
  if (!tag) return;

  // Pre-load custom element definition so createElement works
  if (isESP32C3(fqbn)) await loadESP32C3Modules();
  else if (isRP2040(fqbn)) await loadRP2040Modules();

  // Stop simulation
  stopRunner();
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
}

document.getElementById('boardSelect').addEventListener('change', async (e) => {
  await switchBoard(e.target.value);
  logOutput('Switched to ' + e.target.options[e.target.selectedIndex].text);
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
</script>
</body>
</html>
