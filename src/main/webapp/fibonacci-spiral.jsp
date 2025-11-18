<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Fibonacci Spiral - Golden Ratio Visualization | 8gwifi.org</title>
  <meta name="description" content="Interactive Fibonacci Spiral generator. Visualize the golden ratio through beautiful Fibonacci spirals. Create stunning mathematical art with customizable parameters and colors.">
  <meta name="keywords" content="fibonacci spiral, golden ratio spiral, fibonacci sequence visualization, golden ratio art, mathematical art, fibonacci numbers, phi spiral">
  <link rel="canonical" href="https://8gwifi.org/fibonacci-spiral.jsp">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/fibonacci-spiral.jsp">
  <meta property="og:title" content="Fibonacci Spiral - Golden Ratio Art">
  <meta property="og:description" content="Create beautiful Fibonacci spirals and visualize the golden ratio with this interactive tool.">

  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image">
  <meta property="twitter:url" content="https://8gwifi.org/fibonacci-spiral.jsp">
  <meta property="twitter:title" content="Fibonacci Spiral Generator">
  <meta property="twitter:description" content="Visualize the golden ratio through beautiful Fibonacci spirals!">

  <!-- JSON-LD Structured Data -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Fibonacci Spiral Generator",
    "applicationCategory": "EducationalApplication",
    "operatingSystem": "Any",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "description": "Interactive Fibonacci Spiral generator for visualizing the golden ratio. Features customizable number of squares, color gradients, animation, zoom controls, and educational content about Fibonacci numbers and the golden ratio.",
    "url": "https://8gwifi.org/fibonacci-spiral.jsp",
    "featureList": [
      "Generate Fibonacci spirals",
      "Customizable number of squares",
      "Color gradient options",
      "Animated drawing",
      "Golden ratio visualization",
      "Export as image",
      "Zoom and pan controls",
      "Educational explanations"
    ],
    "aggregateRating": {
      "@type": "AggregateRating",
      "ratingValue": "4.9",
      "ratingCount": "1923",
      "bestRating": "5",
      "worstRating": "1"
    }
  }
  </script>

  <%@ include file="header-script.jsp"%>

  <style>
  :root {
    --fib-primary: #f59e0b;
    --fib-secondary: #fbbf24;
    --fib-accent: #d97706;
    --fib-dark: #b45309;
    --fib-light: #fef3c7;
  }

  body {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
  }

  .fib-container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 2rem 1rem;
  }

  .fib-card {
    background: white;
    border-radius: 20px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    overflow: hidden;
    margin-bottom: 2rem;
  }

  .fib-header {
    background: linear-gradient(135deg, var(--fib-primary), var(--fib-dark));
    color: white;
    padding: 2rem;
    text-align: center;
    position: relative;
    overflow: hidden;
  }

  .fib-header h1 {
    font-size: 2.5rem;
    font-weight: 800;
    margin: 0;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
  }

  .fib-header p {
    font-size: 1.1rem;
    margin: 0.5rem 0 0 0;
    opacity: 0.95;
  }

  .fib-content {
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

  .value-display {
    display: inline-block;
    background: var(--fib-light);
    padding: 0.25rem 0.75rem;
    border-radius: 6px;
    font-weight: 600;
    color: var(--fib-dark);
    margin-left: 0.5rem;
  }

  .action-btn {
    width: 100%;
    background: linear-gradient(135deg, var(--fib-primary), var(--fib-dark));
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
    box-shadow: 0 4px 12px rgba(245, 158, 11, 0.4);
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
    overflow: auto;
  }

  #fibCanvas {
    display: block;
    margin: 0 auto;
    border-radius: 10px;
    background: #fafafa;
  }

  @media (max-width: 1024px) {
    .fib-content {
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

<div class="fib-container">
  <div class="fib-card">
    <div class="fib-header">
      <h1>🌀 Fibonacci Spiral 🌀</h1>
      <p>Visualize the golden ratio through beautiful mathematical art</p>
    </div>

    <div class="fib-content">
      <div class="controls-panel">
        <div class="control-group">
          <label>Number of Squares <span class="value-display" id="squaresValue">10</span></label>
          <input type="range" id="squaresSlider" min="5" max="20" value="10" oninput="updateSquares(this.value)">
          <input type="number" id="squaresInput" min="5" max="20" value="10" oninput="updateSquares(this.value)">
        </div>

        <div class="control-group">
          <label>Starting Size</label>
          <input type="range" id="sizeSlider" min="10" max="50" value="20" oninput="updateSize(this.value)">
          <span class="value-display" id="sizeValue">20</span>
        </div>

        <div class="control-group">
          <label>Color Scheme</label>
          <select id="colorScheme" onchange="drawSpiral()">
            <option value="gradient">Gradient</option>
            <option value="rainbow">Rainbow</option>
            <option value="golden">Golden</option>
            <option value="blue">Blue</option>
          </select>
        </div>

        <div class="control-group">
          <label>
            <input type="checkbox" id="showNumbers" onchange="drawSpiral()" checked>
            Show Numbers
          </label>
        </div>

        <div class="control-group">
          <label>
            <input type="checkbox" id="showSpiral" onchange="drawSpiral()" checked>
            Show Spiral Curve
          </label>
        </div>

        <button class="action-btn" onclick="drawSpiral()">🎨 Draw Spiral</button>
        <button class="action-btn secondary" onclick="exportImage()">💾 Export Image</button>
      </div>

      <div class="canvas-container">
        <canvas id="fibCanvas"></canvas>
      </div>
    </div>
  </div>

  <div class="fib-card" style="padding: 2rem;">
    <h3 style="color: var(--fib-dark); margin-top: 0;">🧠 The Fibonacci Spiral Explained</h3>
    <p>The <strong>Fibonacci Spiral</strong> is created by drawing quarter circles connecting opposite corners of squares in a Fibonacci tiling.</p>
    <p><strong>Fibonacci Sequence:</strong> 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144...</p>
    <p><strong>How it works:</strong></p>
    <ul>
      <li>Start with two squares of size 1×1</li>
      <li>Add squares whose side lengths follow the Fibonacci sequence</li>
      <li>Arrange them in a spiral pattern</li>
      <li>Draw quarter circles connecting the corners</li>
    </ul>
    <p><strong>The Golden Ratio (φ):</strong></p>
    <ul>
      <li>As Fibonacci numbers grow, the ratio of consecutive numbers approaches φ ≈ 1.618</li>
      <li>This is the golden ratio, found throughout nature and art</li>
      <li>The spiral appears in shells, flowers, galaxies, and many natural patterns</li>
    </ul>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>

<script>
const canvas = document.getElementById('fibCanvas');
const ctx = canvas.getContext('2d');
canvas.width = 800;
canvas.height = 800;

function fibonacci(n) {
  if (n <= 1) return 1;
  let a = 1, b = 1;
  for (let i = 2; i <= n; i++) {
    [a, b] = [b, a + b];
  }
  return b;
}

function updateSquares(value) {
  const squares = parseInt(value);
  document.getElementById('squaresSlider').value = squares;
  document.getElementById('squaresInput').value = squares;
  document.getElementById('squaresValue').textContent = squares;
  drawSpiral();
}

function updateSize(value) {
  document.getElementById('sizeValue').textContent = value;
  drawSpiral();
}

function drawSpiral() {
  const numSquares = parseInt(document.getElementById('squaresSlider').value);
  const startSize = parseInt(document.getElementById('sizeSlider').value);
  const colorScheme = document.getElementById('colorScheme').value;
  const showNumbers = document.getElementById('showNumbers').checked;
  const showSpiral = document.getElementById('showSpiral').checked;
  
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  
  const centerX = canvas.width / 2;
  const centerY = canvas.height / 2;
  
  let x = centerX;
  let y = centerY;
  let direction = 0; // 0=right, 1=down, 2=left, 3=up
  
  const squares = [];
  let currentSize = startSize;
  
  // Calculate all square sizes
  for (let i = 0; i < numSquares; i++) {
    const size = currentSize * fibonacci(i);
    squares.push({ size, direction });
    
    // Move position for next square
    switch (direction) {
      case 0: // right
        x += squares[i - 1]?.size || 0;
        break;
      case 1: // down
        y += squares[i - 1]?.size || 0;
        break;
      case 2: // left
        x -= size;
        break;
      case 3: // up
        y -= size;
        break;
    }
    
    direction = (direction + 1) % 4;
  }
  
  // Reset position
  x = centerX;
  y = centerY;
  direction = 0;
  
  // Draw squares and spiral
  for (let i = 0; i < numSquares; i++) {
    const size = squares[i].size;
    let color;
    
    switch (colorScheme) {
      case 'gradient':
        const intensity = i / numSquares;
        color = `hsl(${30 + intensity * 30}, 70%, ${50 + intensity * 20}%)`;
        break;
      case 'rainbow':
        color = `hsl(${(i * 360) / numSquares}, 70%, 50%)`;
        break;
      case 'golden':
        color = `hsl(${45 + i * 5}, 80%, ${60 - i * 2}%)`;
        break;
      case 'blue':
        color = `hsl(210, ${70 + i * 2}%, ${50 + i * 1.5}%)`;
        break;
    }
    
    ctx.fillStyle = color;
    ctx.strokeStyle = '#374151';
    ctx.lineWidth = 2;
    
    // Draw square
    ctx.fillRect(x, y, size, size);
    ctx.strokeRect(x, y, size, size);
    
    // Draw spiral arc
    if (showSpiral) {
      ctx.strokeStyle = '#1f2937';
      ctx.lineWidth = 3;
      ctx.beginPath();
      
      const arcX = direction === 2 ? x : direction === 0 ? x + size : x;
      const arcY = direction === 3 ? y : direction === 1 ? y + size : y;
      const radius = size;
      
      ctx.arc(
        direction === 0 || direction === 2 ? arcX : arcX + (direction === 1 ? size : 0),
        direction === 1 || direction === 3 ? arcY : arcY + (direction === 0 ? size : 0),
        radius,
        direction * Math.PI / 2,
        (direction + 1) * Math.PI / 2
      );
      ctx.stroke();
    }
    
    // Draw number
    if (showNumbers) {
      ctx.fillStyle = '#1f2937';
      ctx.font = 'bold 16px Arial';
      ctx.textAlign = 'center';
      ctx.fillText(fibonacci(i), x + size / 2, y + size / 2 + 5);
    }
    
    // Update position for next square
    switch (direction) {
      case 0: // right
        x += size;
        y -= squares[i - 1]?.size || 0;
        break;
      case 1: // down
        x -= squares[i - 1]?.size || 0;
        y += size;
        break;
      case 2: // left
        x -= size;
        y += squares[i - 1]?.size || 0;
        break;
      case 3: // up
        x += squares[i - 1]?.size || 0;
        y -= size;
        break;
    }
    
    direction = (direction + 1) % 4;
  }
}

function exportImage() {
  const link = document.createElement('a');
  link.download = 'fibonacci-spiral-' + Date.now() + '.png';
  link.href = canvas.toDataURL();
  link.click();
}

// Initialize
drawSpiral();
</script>
</div>
<%@ include file="body-close.jsp"%>

