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
          <div class="ard-component-item" data-comp-id="led13-default">
            <wokwi-led id="led13" color="green"></wokwi-led>
            <span class="ard-component-label">LED D13</span>
          </div>
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
import { LedBinding } from '<%=request.getContextPath()%>/electronics/js/arduino/bindings/led.js';
import { SerialMonitor } from '<%=request.getContextPath()%>/electronics/js/arduino/ui/serial-monitor.js';
import { ArduinoEditor } from '<%=request.getContextPath()%>/electronics/js/arduino/ui/editor.js';
import { ComponentPanel } from '<%=request.getContextPath()%>/electronics/js/arduino/ui/component-panel.js';
import { SimulatorCanvas } from '<%=request.getContextPath()%>/electronics/js/arduino/ui/canvas.js';
import { SelectionManager } from '<%=request.getContextPath()%>/electronics/js/arduino/ui/selection.js';
import { PinOverlay } from '<%=request.getContextPath()%>/electronics/js/arduino/ui/pin-overlay.js';
import { WireManager } from '<%=request.getContextPath()%>/electronics/js/arduino/ui/wire-manager.js';
import { PRESETS, getPresetsByCategory } from '<%=request.getContextPath()%>/electronics/js/arduino/presets.js';
import { RP2040Runner } from '<%=request.getContextPath()%>/electronics/js/arduino/rp2040-runner.js';
import { PicoBoardBinding } from '<%=request.getContextPath()%>/electronics/js/arduino/bindings/pico-board.js';
import { uf2ToFlash } from '<%=request.getContextPath()%>/electronics/js/arduino/uf2-parser.js';
import '<%=request.getContextPath()%>/electronics/js/arduino/ui/pico-board.js';
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
const ledEl = document.getElementById('led13');

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

// Update pin overlay after any component/board drag ends
simCanvas.onDragEnd = (element) => {
  const compId = element.dataset.compId;
  if (compId) {
    const wokwiEl = element.querySelector('[id]');
    if (wokwiEl) pinOverlay.updateComponent(compId, wokwiEl, element);
  } else if (element.classList.contains('ard-board-wrap')) {
    const boardInner = element.querySelector('wokwi-arduino-uno');
    if (boardInner) pinOverlay.updateComponent('board', boardInner, element);
  }
};

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
    }
  }, 100);
};
componentPanel.onComponentRemoved = (compId) => {
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

// Update pin overlay for the default LED and board — retry until pinInfo is available
function initPinOverlays(retries = 10) {
  const boardInner = document.getElementById('arduinoBoard');
  const boardWrap = document.querySelector('.ard-board-wrap');
  const defaultLed = document.getElementById('led13');
  const defaultWrapper = document.querySelector('[data-comp-id="led13-default"]');

  // Check if wokwi elements have rendered their pinInfo
  const boardReady = boardInner && boardInner.pinInfo && boardInner.pinInfo.length > 0;

  if (!boardReady && retries > 0) {
    setTimeout(() => initPinOverlays(retries - 1), 300);
    return;
  }

  if (defaultLed && defaultWrapper) {
    simCanvas.makeDraggable(defaultWrapper);
    simCanvas.placeNearBoard(defaultWrapper, 0);
    pinOverlay.updateComponent('led13-default', defaultLed, defaultWrapper);
  }
  if (boardInner && boardWrap) {
    pinOverlay.updateComponent('board', boardInner, boardWrap);
  }
}
initPinOverlays();

// ── State ──
let runner = null;
let boardBinding = null;
let ledBinding = null;

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
    lastCompiledHex = data.hex || data.uf2 || null;
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
  if (result) startRunnerFromCompile(result);
}

/**
 * Start the appropriate runner based on compile result.
 * @param {object} result - { hex, uf2, outputFormat } from compile response
 */
function startRunnerFromCompile(result) {
  if (!result) return;
  const fmt = result.outputFormat || (result.uf2 ? 'uf2' : 'hex');
  if (fmt === 'uf2' && result.uf2) {
    const flash = uf2ToFlash(result.uf2);
    startRP2040Runner(flash);
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

  ledBinding = new LedBinding(ledEl, runner, 13);
  ledBinding.attach();

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

function startRP2040Runner(flashImage) {
  stopRunner();

  runner = new RP2040Runner(flashImage);

  const currentBoard = document.getElementById('arduinoBoard');
  // Use PicoBoardBinding for Pico boards, BoardBinding for AVR
  if (currentBoard.tagName.toLowerCase() === 'pico-board') {
    boardBinding = new PicoBoardBinding(currentBoard, runner);
  } else {
    boardBinding = new BoardBinding(currentBoard, runner);
  }
  boardBinding.attach();

  // LED_BUILTIN is GPIO25 on Pico — attach LED binding if there's an LED component on pin 25
  // (skip default LED13 binding for Pico)

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

function stopRunner() {
  if (!runner) return;
  runner.stop();
  if (boardBinding) boardBinding.detach();
  if (ledBinding) ledBinding.detach();
  serialMonitor.detach();
  componentPanel.detachAll();
  runner = null;
  boardBinding = null;
  ledBinding = null;

  statusDot.classList.remove('running');
  btnRun.classList.remove('running');
  btnRun.querySelector('span').textContent = 'Run';
  ledEl.value = false;
  ledEl.brightness = 0;
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

  examplesSelect.addEventListener('change', () => {
    const preset = PRESETS.find(p => p.id === examplesSelect.value);
    if (preset) {
      // Switch board if preset specifies one (e.g. Pico presets)
      if (preset.board) {
        const boardSelect = document.getElementById('boardSelect');
        if (boardSelect.value !== preset.board) {
          boardSelect.value = preset.board;
          boardSelect.dispatchEvent(new Event('change'));
        }
      }
      fileManager.switchTo(0);
      editor.setCode(preset.code);
      fileManager.files[0].content = preset.code;
      fileManager.markModified();
      stopRunner();
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
};

/** Check if a board FQBN is RP2040-based */
function isRP2040(fqbn) { return fqbn.startsWith('rp2040:'); }
/** Check if a board FQBN is AVR-based */
function isAVR(fqbn) { return fqbn.startsWith('arduino:avr:'); }

document.getElementById('boardSelect').addEventListener('change', (e) => {
  const fqbn = e.target.value;
  const tag = BOARD_TAGS[fqbn];
  if (!tag) return;

  // Stop simulation
  stopRunner();
  updateButtonStates();

  // Swap board SVG element
  const boardWrap = document.querySelector('.ard-board-wrap');
  const oldBoard = boardWrap.querySelector('[id="arduinoBoard"]');

  // Remove old pin overlay for board
  pinOverlay.removeComponent('board');

  // Create new board element
  const newBoard = document.createElement(tag);
  newBoard.id = 'arduinoBoard';

  // Replace old with new
  if (oldBoard) oldBoard.remove();
  boardWrap.appendChild(newBoard);

  // Update references
  // boardEl is const — we need to update the bindings to use the new element
  // Wait for wokwi element to render, then re-init pin overlay
  const waitForBoard = (retries = 10) => {
    const el = document.getElementById('arduinoBoard');
    if (el && el.pinInfo && el.pinInfo.length > 0) {
      pinOverlay.updateComponent('board', el, boardWrap);
      return;
    }
    if (retries > 0) setTimeout(() => waitForBoard(retries - 1), 200);
  };
  waitForBoard();

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
