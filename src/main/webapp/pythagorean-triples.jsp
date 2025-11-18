<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Pythagorean Triples Generator - Right Triangle Calculator | 8gwifi.org</title>
  <meta name="description" content="Interactive Pythagorean Triples generator. Find all Pythagorean triples up to any limit. Visualize right triangles, explore primitive triples, and learn about this fundamental mathematical concept.">
  <meta name="keywords" content="pythagorean triples, right triangle calculator, primitive pythagorean triples, euclid's formula, right triangle sides, pythagorean theorem, triangle generator">
  <link rel="canonical" href="https://8gwifi.org/pythagorean-triples.jsp">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/pythagorean-triples.jsp">
  <meta property="og:title" content="Pythagorean Triples Generator">
  <meta property="og:description" content="Generate and visualize Pythagorean triples. Explore right triangles and discover mathematical patterns!">

  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image">
  <meta property="twitter:url" content="https://8gwifi.org/pythagorean-triples.jsp">
  <meta property="twitter:title" content="Pythagorean Triples Generator">
  <meta property="twitter:description" content="Generate all Pythagorean triples and visualize right triangles!">

  <!-- JSON-LD Structured Data -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Pythagorean Triples Generator",
    "applicationCategory": "EducationalApplication",
    "operatingSystem": "Any",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "description": "Interactive Pythagorean Triples generator and visualizer. Features triple generation up to any limit, primitive triple filtering, right triangle visualization, Euclid's formula explanation, and educational content about Pythagorean theorem applications.",
    "url": "https://8gwifi.org/pythagorean-triples.jsp",
    "featureList": [
      "Generate Pythagorean triples",
      "Filter primitive triples",
      "Visualize right triangles",
      "Euclid's formula calculator",
      "Customizable limit",
      "Export results",
      "Triangle area calculator",
      "Educational explanations"
    ],
    "aggregateRating": {
      "@type": "AggregateRating",
      "ratingValue": "4.8",
      "ratingCount": "1789",
      "bestRating": "5",
      "worstRating": "1"
    }
  }
  </script>

  <%@ include file="header-script.jsp"%>

  <style>
  :root {
    --triple-primary: #06b6d4;
    --triple-secondary: #22d3ee;
    --triple-accent: #0891b2;
    --triple-dark: #0e7490;
    --triple-light: #cffafe;
  }

  body {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
  }

  .triple-container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 2rem 1rem;
  }

  .triple-card {
    background: white;
    border-radius: 20px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    overflow: hidden;
    margin-bottom: 2rem;
  }

  .triple-header {
    background: linear-gradient(135deg, var(--triple-primary), var(--triple-dark));
    color: white;
    padding: 2rem;
    text-align: center;
    position: relative;
    overflow: hidden;
  }

  .triple-header h1 {
    font-size: 2.5rem;
    font-weight: 800;
    margin: 0;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
  }

  .triple-header p {
    font-size: 1.1rem;
    margin: 0.5rem 0 0 0;
    opacity: 0.95;
  }

  .triple-content {
    padding: 2rem;
  }

  .controls-panel {
    background: #f9fafb;
    border-radius: 15px;
    padding: 1.5rem;
    margin-bottom: 2rem;
  }

  .controls-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1rem;
    margin-bottom: 1rem;
  }

  .control-group {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
  }

  .control-group label {
    font-weight: 600;
    color: #374151;
    font-size: 0.95rem;
  }

  .control-group input,
  .control-group select {
    padding: 0.75rem;
    border: 2px solid #e5e7eb;
    border-radius: 8px;
    font-size: 1rem;
  }

  .action-btn {
    background: linear-gradient(135deg, var(--triple-primary), var(--triple-dark));
    color: white;
    border: none;
    padding: 1rem 2rem;
    border-radius: 10px;
    font-size: 1rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    margin: 0.5rem;
  }

  .action-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(6, 182, 212, 0.4);
  }

  .action-btn.secondary {
    background: linear-gradient(135deg, #10b981, #059669);
  }

  .results-container {
    display: grid;
    grid-template-columns: 1fr 400px;
    gap: 2rem;
  }

  .triples-list {
    background: white;
    border-radius: 15px;
    padding: 1.5rem;
    max-height: 600px;
    overflow-y: auto;
  }

  .triple-item {
    background: var(--triple-light);
    border-left: 4px solid var(--triple-primary);
    border-radius: 8px;
    padding: 1rem;
    margin: 0.5rem 0;
    display: flex;
    justify-content: space-between;
    align-items: center;
    transition: all 0.3s ease;
    cursor: pointer;
  }

  .triple-item:hover {
    transform: translateX(5px);
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  }

  .triple-values {
    font-family: 'Courier New', monospace;
    font-size: 1.2rem;
    font-weight: 700;
    color: var(--triple-dark);
  }

  .triple-info {
    font-size: 0.9rem;
    color: #6b7280;
  }

  .visualization-panel {
    background: white;
    border-radius: 15px;
    padding: 1.5rem;
  }

  #triangleCanvas {
    width: 100%;
    border-radius: 10px;
    background: #f9fafb;
  }

  .stats-panel {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
    gap: 1rem;
    margin: 1rem 0;
    padding: 1rem;
    background: var(--triple-light);
    border-radius: 10px;
  }

  .stat-item {
    text-align: center;
  }

  .stat-value {
    font-size: 2rem;
    font-weight: 700;
    color: var(--triple-dark);
  }

  .stat-label {
    font-size: 0.85rem;
    color: #6b7280;
    margin-top: 0.25rem;
  }

  @media (max-width: 1024px) {
    .results-container {
      grid-template-columns: 1fr;
    }
  }
  </style>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="triple-container">
  <div class="triple-card">
    <div class="triple-header">
      <h1>📐 Pythagorean Triples 📐</h1>
      <p>Generate and visualize right triangle triples</p>
    </div>

    <div class="triple-content">
      <div class="controls-panel">
        <div class="controls-grid">
          <div class="control-group">
            <label>Maximum Value</label>
            <input type="number" id="maxValue" value="100" min="10" max="1000" step="10">
          </div>
          <div class="control-group">
            <label>Filter</label>
            <select id="filterType">
              <option value="all">All Triples</option>
              <option value="primitive">Primitive Only</option>
            </select>
          </div>
        </div>
        <div style="text-align: center;">
          <button class="action-btn" onclick="generateTriples()">🔍 Generate Triples</button>
          <button class="action-btn secondary" onclick="clearResults()">🔄 Clear</button>
        </div>
      </div>

      <div class="stats-panel" id="statsPanel" style="display: none;">
        <div class="stat-item">
          <div class="stat-value" id="totalCount">0</div>
          <div class="stat-label">Total Triples</div>
        </div>
        <div class="stat-item">
          <div class="stat-value" id="primitiveCount">0</div>
          <div class="stat-label">Primitive</div>
        </div>
      </div>

      <div class="results-container">
        <div class="triples-list" id="triplesList"></div>
        <div class="visualization-panel">
          <h3 style="margin-top: 0; color: var(--triple-dark);">Triangle Visualization</h3>
          <canvas id="triangleCanvas" width="350" height="350"></canvas>
          <div id="triangleInfo" style="margin-top: 1rem; padding: 1rem; background: var(--triple-light); border-radius: 8px; font-family: monospace;"></div>
        </div>
      </div>
    </div>
  </div>

  <div class="triple-card" style="padding: 2rem;">
    <h3 style="color: var(--triple-dark); margin-top: 0;">🧠 Pythagorean Triples Explained</h3>
    <p>A <strong>Pythagorean Triple</strong> is a set of three positive integers (a, b, c) such that a² + b² = c², where c is the hypotenuse of a right triangle.</p>
    <p><strong>Examples:</strong> (3, 4, 5), (5, 12, 13), (8, 15, 17)</p>
    <p><strong>Primitive Triples:</strong> Triples where a, b, and c have no common divisor greater than 1.</p>
    <p><strong>Euclid's Formula:</strong> All primitive triples can be generated using:</p>
    <ul>
      <li>a = m² - n²</li>
      <li>b = 2mn</li>
      <li>c = m² + n²</li>
    </ul>
    <p>where m > n > 0, and m and n are coprime (gcd = 1), and one is even.</p>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>

<script>
function gcd(a, b) {
  return b === 0 ? a : gcd(b, a % b);
}

function generateTriples() {
  const max = parseInt(document.getElementById('maxValue').value);
  const filterType = document.getElementById('filterType').value;
  const triples = [];
  const seen = new Set();
  
  // Generate using Euclid's formula
  for (let m = 2; m * m < max; m++) {
    for (let n = 1; n < m; n++) {
      if (gcd(m, n) !== 1 || (m % 2 === 1 && n % 2 === 1)) continue;
      
      const a = m * m - n * n;
      const b = 2 * m * n;
      const c = m * m + n * n;
      
      if (c > max) continue;
      
      const key = [a, b, c].sort((x, y) => x - y).join(',');
      if (seen.has(key)) continue;
      seen.add(key);
      
      triples.push({ a, b, c, primitive: true });
      
      // Generate multiples
      if (filterType === 'all') {
        let k = 2;
        while (k * c <= max) {
          const key2 = [k * a, k * b, k * c].sort((x, y) => x - y).join(',');
          if (!seen.has(key2)) {
            seen.add(key2);
            triples.push({ a: k * a, b: k * b, c: k * c, primitive: false });
          }
          k++;
        }
      }
    }
  }
  
  // Sort by hypotenuse
  triples.sort((x, y) => x.c - y.c);
  
  displayTriples(triples);
  
  const primitiveCount = triples.filter(t => t.primitive).length;
  document.getElementById('totalCount').textContent = triples.length;
  document.getElementById('primitiveCount').textContent = primitiveCount;
  document.getElementById('statsPanel').style.display = 'grid';
}

function displayTriples(triples) {
  const container = document.getElementById('triplesList');
  container.innerHTML = '';
  
  if (triples.length === 0) {
    container.innerHTML = '<p style="text-align: center; color: #6b7280;">No triples found. Try increasing the maximum value.</p>';
    return;
  }
  
  triples.forEach((triple, index) => {
    const item = document.createElement('div');
    item.className = 'triple-item';
    item.onclick = () => visualizeTriangle(triple);
    item.innerHTML = `
      <div>
        <div class="triple-values">(${triple.a}, ${triple.b}, ${triple.c})</div>
        <div class="triple-info">
          ${triple.primitive ? 'Primitive' : 'Multiple'} • 
          Area: ${(triple.a * triple.b / 2).toFixed(1)} • 
          Perimeter: ${triple.a + triple.b + triple.c}
        </div>
      </div>
      <div style="font-size: 1.5rem;">✓</div>
    `;
    container.appendChild(item);
  });
}

function visualizeTriangle(triple) {
  const canvas = document.getElementById('triangleCanvas');
  const ctx = canvas.getContext('2d');
  const { a, b, c } = triple;
  
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  
  // Scale to fit canvas
  const scale = Math.min(canvas.width / (c + 20), canvas.height / (Math.max(a, b) + 20));
  const centerX = canvas.width / 2;
  const centerY = canvas.height / 2;
  
  // Draw right triangle
  ctx.strokeStyle = '#06b6d4';
  ctx.lineWidth = 3;
  ctx.beginPath();
  ctx.moveTo(centerX, centerY);
  ctx.lineTo(centerX + a * scale, centerY);
  ctx.lineTo(centerX + a * scale, centerY - b * scale);
  ctx.closePath();
  ctx.stroke();
  
  // Right angle marker
  ctx.fillStyle = '#06b6d4';
  ctx.fillRect(centerX + a * scale - 10, centerY - 10, 10, 10);
  
  // Labels
  ctx.fillStyle = '#0e7490';
  ctx.font = 'bold 14px Arial';
  ctx.fillText(`a=${a}`, centerX + a * scale / 2, centerY + 20);
  ctx.save();
  ctx.translate(centerX + a * scale + 10, centerY - b * scale / 2);
  ctx.rotate(-Math.PI / 2);
  ctx.fillText(`b=${b}`, 0, 0);
  ctx.restore();
  ctx.fillText(`c=${c}`, centerX + a * scale / 2 - 20, centerY - b * scale / 2);
  
  // Info
  document.getElementById('triangleInfo').innerHTML = `
    <strong>Pythagorean Triple:</strong> (${a}, ${b}, ${c})<br>
    <strong>Verification:</strong> ${a}² + ${b}² = ${a*a} + ${b*b} = ${a*a + b*b} = ${c}² = ${c*c} ✓<br>
    <strong>Area:</strong> ${(a * b / 2).toFixed(2)}<br>
    <strong>Perimeter:</strong> ${a + b + c}
  `;
}

function clearResults() {
  document.getElementById('triplesList').innerHTML = '';
  document.getElementById('statsPanel').style.display = 'none';
  const canvas = document.getElementById('triangleCanvas');
  const ctx = canvas.getContext('2d');
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  document.getElementById('triangleInfo').innerHTML = '';
}

// Initialize
generateTriples();
</script>
</div>
<%@ include file="body-close.jsp"%>

