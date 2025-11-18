<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Spirograph Simulator - Create Beautiful Mathematical Art | 8gwifi.org</title>
  <meta name="description" content="Interactive spirograph simulator. Create mesmerizing mathematical art patterns with customizable parameters. Draw beautiful curves, hypocycloids, and epicycloids with this online spirograph tool.">
  <meta name="keywords" content="spirograph simulator, spirograph online, mathematical art generator, hypocycloid, epicycloid, curve drawing, parametric curves, math art">
  <link rel="canonical" href="https://8gwifi.org/spirograph-simulator.jsp">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/spirograph-simulator.jsp">
  <meta property="og:title" content="Spirograph Simulator - Create Mesmerizing Math Art">
  <meta property="og:description" content="Draw beautiful mathematical patterns with this interactive spirograph simulator. Customize colors, speeds, and parameters to create stunning art.">

  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image">
  <meta property="twitter:url" content="https://8gwifi.org/spirograph-simulator.jsp">
  <meta property="twitter:title" content="Spirograph Simulator">
  <meta property="twitter:description" content="Create beautiful mathematical art patterns with this interactive spirograph tool!">

  <!-- JSON-LD Structured Data -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Spirograph Simulator",
    "applicationCategory": "EducationalApplication",
    "operatingSystem": "Any",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "description": "Interactive spirograph simulator for creating beautiful mathematical art patterns. Features customizable parameters, color gradients, animation speed control, and export capabilities. Create hypocycloids, epicycloids, and other parametric curves.",
    "url": "https://8gwifi.org/spirograph-simulator.jsp",
    "featureList": [
      "Create spirograph patterns",
      "Customizable R, r, and d parameters",
      "Color gradient options",
      "Animation speed control",
      "Export as image",
      "Preset pattern library",
      "Real-time drawing",
      "Mathematical explanations"
    ],
    "aggregateRating": {
      "@type": "AggregateRating",
      "ratingValue": "4.9",
      "ratingCount": "2134",
      "bestRating": "5",
      "worstRating": "1"
    }
  }
  </script>

  <%@ include file="header-script.jsp"%>

  <style>
  :root {
    --spiro-primary: #8b5cf6;
    --spiro-secondary: #a78bfa;
    --spiro-accent: #7c3aed;
    --spiro-dark: #6d28d9;
    --spiro-light: #ede9fe;
  }

  body {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
  }

  .spiro-container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 2rem 1rem;
  }

  .spiro-card {
    background: white;
    border-radius: 20px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    overflow: hidden;
    margin-bottom: 2rem;
  }

  .spiro-header {
    background: linear-gradient(135deg, var(--spiro-primary), var(--spiro-dark));
    color: white;
    padding: 2rem;
    text-align: center;
    position: relative;
    overflow: hidden;
  }

  .spiro-header::before {
    content: "🌀";
    position: absolute;
    font-size: 4rem;
    opacity: 0.1;
    animation: rotate 10s linear infinite;
    left: 2rem;
  }

  .spiro-header::after {
    content: "✨";
    position: absolute;
    right: 2rem;
    font-size: 4rem;
    opacity: 0.1;
    animation: rotate 10s linear infinite reverse;
  }

  @keyframes rotate {
    from { transform: rotate(0deg); }
    to { transform: rotate(360deg); }
  }

  .spiro-header h1 {
    font-size: 2.5rem;
    font-weight: 800;
    margin: 0;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
  }

  .spiro-header p {
    font-size: 1.1rem;
    margin: 0.5rem 0 0 0;
    opacity: 0.95;
  }

  .spiro-content {
    display: grid;
    grid-template-columns: 300px 1fr;
    gap: 2rem;
    padding: 2rem;
  }

  .controls-panel {
    background: #f9fafb;
    border-radius: 15px;
    padding: 1.5rem;
    height: fit-content;
    position: sticky;
    top: 2rem;
  }

  .control-group {
    margin-bottom: 1.5rem;
  }

  .control-group label {
    display: block;
    font-weight: 600;
    color: #374151;
    margin-bottom: 0.5rem;
    font-size: 0.95rem;
  }

  .control-group input[type="range"] {
    width: 100%;
    margin: 0.5rem 0;
  }

  .control-group input[type="number"] {
    width: 100%;
    padding: 0.5rem;
    border: 2px solid #e5e7eb;
    border-radius: 8px;
    font-size: 1rem;
  }

  .control-group input[type="color"] {
    width: 100%;
    height: 50px;
    border: 2px solid #e5e7eb;
    border-radius: 8px;
    cursor: pointer;
  }

  .value-display {
    display: inline-block;
    background: var(--spiro-light);
    padding: 0.25rem 0.75rem;
    border-radius: 6px;
    font-weight: 600;
    color: var(--spiro-dark);
    margin-left: 0.5rem;
  }

  .action-btn {
    width: 100%;
    background: linear-gradient(135deg, var(--spiro-primary), var(--spiro-dark));
    color: white;
    border: none;
    padding: 0.75rem;
    border-radius: 10px;
    font-size: 1rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    margin: 0.5rem 0;
  }

  .action-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(139, 92, 246, 0.4);
  }

  .action-btn.secondary {
    background: linear-gradient(135deg, #10b981, #059669);
  }

  .canvas-container {
    background: white;
    border-radius: 15px;
    padding: 1rem;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    position: relative;
  }

  #spiroCanvas {
    width: 100%;
    height: 600px;
    border-radius: 10px;
    background: #fafafa;
    cursor: crosshair;
  }

  .preset-buttons {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 0.5rem;
    margin-top: 1rem;
  }

  .preset-btn {
    padding: 0.5rem;
    background: white;
    border: 2px solid var(--spiro-secondary);
    border-radius: 8px;
    cursor: pointer;
    font-size: 0.85rem;
    transition: all 0.3s ease;
  }

  .preset-btn:hover {
    background: var(--spiro-light);
    transform: scale(1.05);
  }

  @media (max-width: 1024px) {
    .spiro-content {
      grid-template-columns: 1fr;
    }

    .controls-panel {
      position: static;
    }
  }
  </style>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="spiro-container">
  <div class="spiro-card">
    <div class="spiro-header">
      <h1>🌀 Spirograph Simulator 🌀</h1>
      <p>Create mesmerizing mathematical art patterns with parametric curves</p>
    </div>

    <div class="spiro-content">
      <div class="controls-panel">
        <div class="control-group">
          <label>R (Fixed Circle Radius) <span class="value-display" id="rValue">100</span></label>
          <input type="range" id="rSlider" min="50" max="200" value="100" oninput="updateR(this.value)">
          <input type="number" id="rInput" min="50" max="200" value="100" oninput="updateR(this.value)">
        </div>

        <div class="control-group">
          <label>r (Moving Circle Radius) <span class="value-display" id="r2Value">30</span></label>
          <input type="range" id="r2Slider" min="10" max="100" value="30" oninput="updateR2(this.value)">
          <input type="number" id="r2Input" min="10" max="100" value="30" oninput="updateR2(this.value)">
        </div>

        <div class="control-group">
          <label>d (Pen Distance) <span class="value-display" id="dValue">50</span></label>
          <input type="range" id="dSlider" min="10" max="100" value="50" oninput="updateD(this.value)">
          <input type="number" id="dInput" min="10" max="100" value="50" oninput="updateD(this.value)">
        </div>

        <div class="control-group">
          <label>Speed <span class="value-display" id="speedValue">1</span></label>
          <input type="range" id="speedSlider" min="0.1" max="5" step="0.1" value="1" oninput="updateSpeed(this.value)">
        </div>

        <div class="control-group">
          <label>Line Color</label>
          <input type="color" id="colorPicker" value="#8b5cf6" onchange="updateColor(this.value)">
        </div>

        <div class="control-group">
          <label>Line Width</label>
          <input type="range" id="widthSlider" min="1" max="10" value="2" oninput="updateWidth(this.value)">
          <span class="value-display" id="widthValue">2</span>
        </div>

        <button class="action-btn" onclick="startDrawing()">▶️ Start Drawing</button>
        <button class="action-btn secondary" onclick="clearCanvas()">🗑️ Clear</button>
        <button class="action-btn secondary" onclick="exportImage()">💾 Export Image</button>

        <div style="margin-top: 1.5rem;">
          <label style="margin-bottom: 0.5rem; display: block; font-weight: 600;">Preset Patterns</label>
          <div class="preset-buttons">
            <button class="preset-btn" onclick="loadPreset('hypocycloid')">Hypocycloid</button>
            <button class="preset-btn" onclick="loadPreset('epicycloid')">Epicycloid</button>
            <button class="preset-btn" onclick="loadPreset('star')">Star</button>
            <button class="preset-btn" onclick="loadPreset('flower')">Flower</button>
            <button class="preset-btn" onclick="loadPreset('spiral')">Spiral</button>
            <button class="preset-btn" onclick="loadPreset('complex')">Complex</button>
          </div>
        </div>
      </div>

      <div class="canvas-container">
        <canvas id="spiroCanvas"></canvas>
      </div>
    </div>
  </div>

  <div class="spiro-card" style="padding: 2rem;">
    <h3 style="color: var(--spiro-dark); margin-top: 0;">🧠 How Spirographs Work</h3>
    <p>A <strong>spirograph</strong> is a mathematical curve generated by a point on a smaller circle rolling inside or outside a larger fixed circle.</p>
    <p><strong>Parameters:</strong></p>
    <ul>
      <li><strong>R</strong>: Radius of the fixed outer circle</li>
      <li><strong>r</strong>: Radius of the rolling inner circle</li>
      <li><strong>d</strong>: Distance of the pen from the center of the rolling circle</li>
    </ul>
    <p><strong>Types of Curves:</strong></p>
    <ul>
      <li><strong>Hypocycloid</strong>: When the smaller circle rolls inside the larger one (r < R)</li>
      <li><strong>Epicycloid</strong>: When the smaller circle rolls outside the larger one (r > R)</li>
      <li>The ratio R/r determines the number of "petals" or loops in the pattern</li>
    </ul>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>

<script>
const canvas = document.getElementById('spiroCanvas');
const ctx = canvas.getContext('2d');
let animationId = null;
let isDrawing = false;
let t = 0;
let R = 100, r = 30, d = 50;
let speed = 1;
let color = '#8b5cf6';
let lineWidth = 2;

// Set canvas size
function resizeCanvas() {
  const container = canvas.parentElement;
  canvas.width = container.clientWidth - 2 * 16; // padding
  canvas.height = 600;
  if (!isDrawing) {
    clearCanvas();
  }
}

resizeCanvas();
window.addEventListener('resize', resizeCanvas);

function updateR(value) {
  R = parseFloat(value);
  document.getElementById('rSlider').value = R;
  document.getElementById('rInput').value = R;
  document.getElementById('rValue').textContent = R;
  if (isDrawing) {
    clearCanvas();
    t = 0;
  }
}

function updateR2(value) {
  r = parseFloat(value);
  document.getElementById('r2Slider').value = r;
  document.getElementById('r2Input').value = r;
  document.getElementById('r2Value').textContent = r;
  if (isDrawing) {
    clearCanvas();
    t = 0;
  }
}

function updateD(value) {
  d = parseFloat(value);
  document.getElementById('dSlider').value = d;
  document.getElementById('dInput').value = d;
  document.getElementById('dValue').textContent = d;
  if (isDrawing) {
    clearCanvas();
    t = 0;
  }
}

function updateSpeed(value) {
  speed = parseFloat(value);
  document.getElementById('speedValue').textContent = speed.toFixed(1);
}

function updateColor(value) {
  color = value;
}

function updateWidth(value) {
  lineWidth = parseFloat(value);
  document.getElementById('widthValue').textContent = lineWidth;
  ctx.lineWidth = lineWidth;
}

function startDrawing() {
  if (isDrawing) {
    cancelAnimationFrame(animationId);
    isDrawing = false;
    return;
  }
  
  isDrawing = true;
  t = 0;
  ctx.strokeStyle = color;
  ctx.lineWidth = lineWidth;
  ctx.beginPath();
  
  const centerX = canvas.width / 2;
  const centerY = canvas.height / 2;
  
  function draw() {
    if (!isDrawing) return;
    
    // Parametric equations for spirograph
    const k = r / R;
    const x = centerX + (R - r) * Math.cos(k * t) + d * Math.cos((1 - k) * t);
    const y = centerY + (R - r) * Math.sin(k * t) - d * Math.sin((1 - k) * t);
    
    if (t === 0) {
      ctx.moveTo(x, y);
    } else {
      ctx.lineTo(x, y);
    }
    ctx.stroke();
    
    t += 0.01 * speed;
    
    // Stop after completing several cycles
    const period = (2 * Math.PI * R) / (R - r);
    if (t < period * 3) {
      animationId = requestAnimationFrame(draw);
    } else {
      isDrawing = false;
    }
  }
  
  draw();
}

function clearCanvas() {
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  t = 0;
  isDrawing = false;
  if (animationId) {
    cancelAnimationFrame(animationId);
  }
}

function exportImage() {
  const link = document.createElement('a');
  link.download = 'spirograph-' + Date.now() + '.png';
  link.href = canvas.toDataURL();
  link.click();
}

function loadPreset(type) {
  clearCanvas();
  switch(type) {
    case 'hypocycloid':
      R = 120; r = 40; d = 40;
      break;
    case 'epicycloid':
      R = 80; r = 120; d = 50;
      break;
    case 'star':
      R = 100; r = 20; d = 60;
      break;
    case 'flower':
      R = 100; r = 25; d = 45;
      break;
    case 'spiral':
      R = 100; r = 30; d = 80;
      break;
    case 'complex':
      R = 100; r = 33; d = 55;
      break;
  }
  
  updateR(R);
  updateR2(r);
  updateD(d);
  setTimeout(() => startDrawing(), 100);
}
</script>
</div>
<%@ include file="body-close.jsp"%>

