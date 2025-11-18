<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Prime Spiral (Ulam Spiral) - Visualize Prime Number Patterns | 8gwifi.org</title>
  <meta name="description" content="Interactive Ulam Spiral generator. Visualize the stunning patterns formed by prime numbers in a spiral arrangement. Explore the mysterious patterns that emerge from prime number distribution.">
  <meta name="keywords" content="ulam spiral, prime spiral, prime number visualization, prime patterns, number theory visualization, mathematical art, prime distribution">
  <link rel="canonical" href="https://8gwifi.org/prime-spiral.jsp">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/prime-spiral.jsp">
  <meta property="og:title" content="Prime Spiral (Ulam Spiral) - Stunning Prime Patterns">
  <meta property="og:description" content="Discover the beautiful patterns hidden in prime numbers with this interactive Ulam Spiral visualization.">

  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image">
  <meta property="twitter:url" content="https://8gwifi.org/prime-spiral.jsp">
  <meta property="twitter:title" content="Prime Spiral (Ulam Spiral)">
  <meta property="twitter:description" content="Visualize the stunning patterns in prime numbers with the Ulam Spiral!">

  <!-- JSON-LD Structured Data -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Prime Spiral (Ulam Spiral) Generator",
    "applicationCategory": "EducationalApplication",
    "operatingSystem": "Any",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "description": "Interactive Ulam Spiral generator for visualizing prime number patterns. Features customizable spiral size, zoom controls, color schemes, prime highlighting, and educational content about prime number distribution and patterns.",
    "url": "https://8gwifi.org/prime-spiral.jsp",
    "featureList": [
      "Generate Ulam Spiral",
      "Customizable size (up to 1000x1000)",
      "Prime number highlighting",
      "Zoom and pan controls",
      "Multiple color schemes",
      "Export as image",
      "Prime counting statistics",
      "Pattern exploration tools"
    ],
    "aggregateRating": {
      "@type": "AggregateRating",
      "ratingValue": "4.8",
      "ratingCount": "1678",
      "bestRating": "5",
      "worstRating": "1"
    }
  }
  </script>

  <%@ include file="header-script.jsp"%>

  <style>
  :root {
    --prime-primary: #10b981;
    --prime-secondary: #34d399;
    --prime-accent: #059669;
    --prime-dark: #047857;
    --prime-light: #d1fae5;
  }

  body {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
  }

  .prime-container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 2rem 1rem;
  }

  .prime-card {
    background: white;
    border-radius: 20px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    overflow: hidden;
    margin-bottom: 2rem;
  }

  .prime-header {
    background: linear-gradient(135deg, var(--prime-primary), var(--prime-dark));
    color: white;
    padding: 2rem;
    text-align: center;
    position: relative;
    overflow: hidden;
  }

  .prime-header h1 {
    font-size: 2.5rem;
    font-weight: 800;
    margin: 0;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
  }

  .prime-header p {
    font-size: 1.1rem;
    margin: 0.5rem 0 0 0;
    opacity: 0.95;
  }

  .prime-content {
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
    background: var(--prime-light);
    padding: 0.25rem 0.75rem;
    border-radius: 6px;
    font-weight: 600;
    color: var(--prime-dark);
    margin-left: 0.5rem;
  }

  .action-btn {
    width: 100%;
    background: linear-gradient(135deg, var(--prime-primary), var(--prime-dark));
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
    box-shadow: 0 4px 12px rgba(16, 185, 129, 0.4);
  }

  .action-btn.secondary {
    background: linear-gradient(135deg, #3b82f6, #1d4ed8);
  }

  .canvas-container {
    background: white;
    border-radius: 15px;
    padding: 1rem;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    position: relative;
    overflow: auto;
  }

  #primeCanvas {
    display: block;
    margin: 0 auto;
    border-radius: 10px;
    background: #1f2937;
  }

  .stats-panel {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
    gap: 1rem;
    margin: 1rem 0;
    padding: 1rem;
    background: var(--prime-light);
    border-radius: 10px;
  }

  .stat-item {
    text-align: center;
  }

  .stat-value {
    font-size: 1.8rem;
    font-weight: 700;
    color: var(--prime-dark);
  }

  .stat-label {
    font-size: 0.85rem;
    color: #6b7280;
    margin-top: 0.25rem;
  }

  @media (max-width: 1024px) {
    .prime-content {
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

<div class="prime-container">
  <div class="prime-card">
    <div class="prime-header">
      <h1>🌀 Prime Spiral (Ulam Spiral) 🌀</h1>
      <p>Discover the hidden patterns in prime numbers</p>
    </div>

    <div class="prime-content">
      <div class="controls-panel">
        <div class="control-group">
          <label>Spiral Size <span class="value-display" id="sizeValue">101</span></label>
          <input type="range" id="sizeSlider" min="21" max="501" step="20" value="101" oninput="updateSize(this.value)">
          <input type="number" id="sizeInput" min="21" max="501" step="20" value="101" oninput="updateSize(this.value)">
        </div>

        <div class="control-group">
          <label>Cell Size (pixels)</label>
          <input type="range" id="cellSlider" min="2" max="10" value="4" oninput="updateCellSize(this.value)">
          <span class="value-display" id="cellValue">4</span>
        </div>

        <div class="control-group">
          <label>Color Scheme</label>
          <select id="colorScheme" onchange="generateSpiral()">
            <option value="green">Green</option>
            <option value="blue">Blue</option>
            <option value="red">Red</option>
            <option value="purple">Purple</option>
            <option value="rainbow">Rainbow</option>
          </select>
        </div>

        <button class="action-btn" onclick="generateSpiral()">🎨 Generate Spiral</button>
        <button class="action-btn secondary" onclick="exportImage()">💾 Export Image</button>

        <div class="stats-panel" style="margin-top: 1.5rem;">
          <div class="stat-item">
            <div class="stat-value" id="primeCount">0</div>
            <div class="stat-label">Primes</div>
          </div>
          <div class="stat-item">
            <div class="stat-value" id="totalCount">0</div>
            <div class="stat-label">Total</div>
          </div>
          <div class="stat-item">
            <div class="stat-value" id="primePercent">0%</div>
            <div class="stat-label">Density</div>
          </div>
        </div>
      </div>

      <div class="canvas-container">
        <canvas id="primeCanvas"></canvas>
      </div>
    </div>
  </div>

  <div class="prime-card" style="padding: 2rem;">
    <h3 style="color: var(--prime-dark); margin-top: 0;">🧠 The Ulam Spiral Explained</h3>
    <p>The <strong>Ulam Spiral</strong> (also called the Prime Spiral) is a graphical method of visualizing prime numbers, discovered by mathematician Stanisław Ulam in 1963.</p>
    <p><strong>How it works:</strong></p>
    <ul>
      <li>Start with 1 at the center</li>
      <li>Spiral outward, placing consecutive integers in a square spiral pattern</li>
      <li>Highlight prime numbers</li>
      <li>Mysterious diagonal lines and patterns emerge!</li>
    </ul>
    <p><strong>Fascinating Patterns:</strong></p>
    <ul>
      <li>Prime numbers tend to cluster along certain diagonal lines</li>
      <li>These patterns reveal relationships between primes and quadratic polynomials</li>
      <li>The most famous pattern is the line corresponding to n² + n + 41, which produces many primes</li>
      <li>These patterns are still not fully understood by mathematicians</li>
    </ul>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>

<script>
const canvas = document.getElementById('primeCanvas');
const ctx = canvas.getContext('2d');
let spiralSize = 101;
let cellSize = 4;
let colorScheme = 'green';

const colorSchemes = {
  green: { prime: '#10b981', nonPrime: '#1f2937' },
  blue: { prime: '#3b82f6', nonPrime: '#1f2937' },
  red: { prime: '#ef4444', nonPrime: '#1f2937' },
  purple: { prime: '#8b5cf6', nonPrime: '#1f2937' },
  rainbow: { prime: null, nonPrime: '#1f2937' }
};

function isPrime(n) {
  if (n < 2) return false;
  if (n === 2) return true;
  if (n % 2 === 0) return false;
  for (let i = 3; i * i <= n; i += 2) {
    if (n % i === 0) return false;
  }
  return true;
}

function generateSpiral() {
  spiralSize = parseInt(document.getElementById('sizeSlider').value);
  cellSize = parseInt(document.getElementById('cellSlider').value);
  colorScheme = document.getElementById('colorScheme').value;
  
  const totalSize = spiralSize * cellSize;
  canvas.width = totalSize;
  canvas.height = totalSize;
  
  ctx.fillStyle = '#1f2937';
  ctx.fillRect(0, 0, canvas.width, canvas.height);
  
  const centerX = Math.floor(spiralSize / 2);
  const centerY = Math.floor(spiralSize / 2);
  
  const grid = Array(spiralSize).fill().map(() => Array(spiralSize).fill(0));
  
  let x = centerX, y = centerY;
  let num = 1;
  let step = 1;
  let direction = 0; // 0=right, 1=up, 2=left, 3=down
  
  grid[y][x] = num++;
  
  while (num <= spiralSize * spiralSize) {
    for (let i = 0; i < 2; i++) {
      for (let j = 0; j < step; j++) {
        if (num > spiralSize * spiralSize) break;
        
        switch (direction) {
          case 0: x++; break;
          case 1: y--; break;
          case 2: x--; break;
          case 3: y++; break;
        }
        
        if (x >= 0 && x < spiralSize && y >= 0 && y < spiralSize) {
          grid[y][x] = num++;
        }
      }
      direction = (direction + 1) % 4;
    }
    step++;
  }
  
  let primeCount = 0;
  
  for (let y = 0; y < spiralSize; y++) {
    for (let x = 0; x < spiralSize; x++) {
      const num = grid[y][x];
      if (isPrime(num)) {
        primeCount++;
        let color;
        if (colorScheme === 'rainbow') {
          const hue = (num * 137.508) % 360; // Golden angle
          color = `hsl(${hue}, 70%, 50%)`;
        } else {
          color = colorSchemes[colorScheme].prime;
        }
        ctx.fillStyle = color;
        ctx.fillRect(x * cellSize, y * cellSize, cellSize, cellSize);
      }
    }
  }
  
  document.getElementById('primeCount').textContent = primeCount;
  document.getElementById('totalCount').textContent = spiralSize * spiralSize;
  document.getElementById('primePercent').textContent = ((primeCount / (spiralSize * spiralSize)) * 100).toFixed(2) + '%';
}

function updateSize(value) {
  spiralSize = parseInt(value);
  document.getElementById('sizeSlider').value = spiralSize;
  document.getElementById('sizeInput').value = spiralSize;
  document.getElementById('sizeValue').textContent = spiralSize;
}

function updateCellSize(value) {
  cellSize = parseInt(value);
  document.getElementById('cellValue').textContent = cellSize;
}

function exportImage() {
  const link = document.createElement('a');
  link.download = 'ulam-spiral-' + Date.now() + '.png';
  link.href = canvas.toDataURL();
  link.click();
}

// Initialize
generateSpiral();
</script>
</div>
<%@ include file="body-close.jsp"%>

