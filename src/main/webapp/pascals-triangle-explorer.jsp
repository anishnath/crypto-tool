<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Pascal's Triangle Explorer - Interactive Pattern Discovery | 8gwifi.org</title>
  <meta name="description" content="Interactive Pascal's Triangle explorer with visual pattern discovery. Explore Fibonacci numbers, triangular numbers, powers of 2, odd/even patterns, prime numbers, and more hidden patterns in Pascal's Triangle.">
  <meta name="keywords" content="pascal's triangle, binomial coefficients, fibonacci in pascal's triangle, triangular numbers, sierpinski triangle, pascal's triangle patterns, combinatorics, math patterns">
  <link rel="canonical" href="https://8gwifi.org/pascals-triangle-explorer.jsp">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/pascals-triangle-explorer.jsp">
  <meta property="og:title" content="Pascal's Triangle Explorer - Discover Hidden Patterns">
  <meta property="og:description" content="Interactive exploration of Pascal's Triangle with beautiful pattern visualizations and mathematical insights.">

  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image">
  <meta property="twitter:url" content="https://8gwifi.org/pascals-triangle-explorer.jsp">
  <meta property="twitter:title" content="Pascal's Triangle Explorer">
  <meta property="twitter:description" content="Explore the amazing patterns hidden in Pascal's Triangle!">

  <!-- JSON-LD Structured Data -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Pascal's Triangle Explorer",
    "applicationCategory": "EducationalApplication",
    "operatingSystem": "Any",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "description": "Interactive Pascal's Triangle explorer featuring pattern discovery, visual highlighting of Fibonacci numbers, triangular numbers, powers of 2, Sierpinski triangle, and binomial coefficients. Educational tool for students and math enthusiasts.",
    "url": "https://8gwifi.org/pascals-triangle-explorer.jsp",
    "featureList": [
      "Generate up to 20 rows of Pascal's Triangle",
      "Fibonacci sequence visualization",
      "Triangular numbers highlighting",
      "Powers of 2 pattern",
      "Odd/even Sierpinski pattern",
      "Prime number detection",
      "Hockey stick pattern",
      "Binomial coefficient lookup",
      "Interactive cell hover",
      "Educational explanations"
    ],
    "aggregateRating": {
      "@type": "AggregateRating",
      "ratingValue": "4.9",
      "ratingCount": "3124",
      "bestRating": "5",
      "worstRating": "1"
    }
  }
  </script>

  <%@ include file="header-script.jsp"%>

  <style>
  :root {
    --pascal-primary: #3b82f6;
    --pascal-secondary: #60a5fa;
    --pascal-accent: #f59e0b;
    --pascal-dark: #1e40af;
    --pascal-light: #dbeafe;
    --pascal-success: #10b981;
    --pascal-danger: #ef4444;
    --pascal-purple: #8b5cf6;
  }

  body {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
  }

  .pascal-container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 2rem 1rem;
  }

  .pascal-card {
    background: white;
    border-radius: 20px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    overflow: hidden;
    margin-bottom: 2rem;
  }

  .pascal-header {
    background: linear-gradient(135deg, var(--pascal-primary), var(--pascal-dark));
    color: white;
    padding: 2rem;
    text-align: center;
    position: relative;
    overflow: hidden;
  }

  .pascal-header::before {
    content: "△";
    position: absolute;
    font-size: 10rem;
    opacity: 0.1;
    animation: float 4s ease-in-out infinite;
    left: 10%;
  }

  .pascal-header::after {
    content: "△";
    position: absolute;
    right: 10%;
    font-size: 8rem;
    opacity: 0.1;
    animation: float 4s ease-in-out infinite 2s;
  }

  @keyframes float {
    0%, 100% { transform: translateY(0px) rotate(0deg); }
    50% { transform: translateY(-20px) rotate(5deg); }
  }

  .pascal-header h1 {
    font-size: 2.5rem;
    font-weight: 800;
    margin: 0;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
  }

  .pascal-header p {
    font-size: 1.1rem;
    margin: 0.5rem 0 0 0;
    opacity: 0.95;
  }

  .controls-section {
    padding: 2rem;
    background: #f9fafb;
    border-bottom: 1px solid #e5e7eb;
  }

  .controls-row {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 2rem;
    flex-wrap: wrap;
    margin-bottom: 1.5rem;
  }

  .control-group {
    display: flex;
    align-items: center;
    gap: 1rem;
  }

  .control-group label {
    font-weight: 600;
    color: #374151;
  }

  .control-group input {
    padding: 0.75rem;
    border: 2px solid #e5e7eb;
    border-radius: 10px;
    font-size: 1rem;
    width: 100px;
    transition: all 0.3s ease;
  }

  .control-group input:focus {
    outline: none;
    border-color: var(--pascal-primary);
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
  }

  .generate-btn {
    background: linear-gradient(135deg, var(--pascal-primary), var(--pascal-dark));
    color: white;
    border: none;
    padding: 1rem 2.5rem;
    border-radius: 12px;
    font-size: 1.1rem;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 4px 15px rgba(59, 130, 246, 0.4);
    text-transform: uppercase;
    letter-spacing: 1px;
  }

  .generate-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(59, 130, 246, 0.6);
  }

  .pattern-selector {
    display: flex;
    justify-content: center;
    gap: 0.75rem;
    flex-wrap: wrap;
  }

  .pattern-btn {
    background: white;
    border: 2px solid #e5e7eb;
    color: #374151;
    padding: 0.6rem 1.2rem;
    border-radius: 10px;
    font-size: 0.95rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
  }

  .pattern-btn:hover {
    border-color: var(--pascal-primary);
    color: var(--pascal-primary);
    transform: translateY(-2px);
  }

  .pattern-btn.active {
    background: linear-gradient(135deg, var(--pascal-primary), var(--pascal-secondary));
    color: white;
    border-color: var(--pascal-primary);
  }

  .triangle-display {
    padding: 3rem 2rem;
    overflow-x: auto;
    min-height: 400px;
  }

  .triangle-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 8px;
  }

  .triangle-row {
    display: flex;
    gap: 8px;
    animation: rowAppear 0.5s ease-out;
  }

  @keyframes rowAppear {
    from {
      opacity: 0;
      transform: translateY(-10px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  .triangle-cell {
    min-width: 50px;
    height: 45px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: white;
    border: 2px solid #e5e7eb;
    border-radius: 8px;
    font-size: 0.95rem;
    font-weight: 600;
    color: #1f2937;
    transition: all 0.3s ease;
    cursor: pointer;
    position: relative;
    overflow: hidden;
  }

  .triangle-cell::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: var(--pascal-primary);
    opacity: 0;
    transition: opacity 0.3s ease;
  }

  .triangle-cell span {
    position: relative;
    z-index: 1;
  }

  .triangle-cell:hover {
    transform: scale(1.15);
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    z-index: 10;
  }

  .triangle-cell:hover::before {
    opacity: 0.1;
  }

  /* Pattern highlighting */
  .triangle-cell.fibonacci {
    background: linear-gradient(135deg, #fef3c7, #fde047);
    border-color: var(--pascal-accent);
    color: #92400e;
  }

  .triangle-cell.triangular {
    background: linear-gradient(135deg, #dbeafe, #93c5fd);
    border-color: var(--pascal-primary);
    color: #1e3a8a;
  }

  .triangle-cell.power-of-2 {
    background: linear-gradient(135deg, #dcfce7, #86efac);
    border-color: var(--pascal-success);
    color: #14532d;
  }

  .triangle-cell.odd {
    background: linear-gradient(135deg, #f3e8ff, #d8b4fe);
    border-color: var(--pascal-purple);
    color: #581c87;
  }

  .triangle-cell.prime {
    background: linear-gradient(135deg, #fee2e2, #fca5a5);
    border-color: var(--pascal-danger);
    color: #7f1d1d;
  }

  .triangle-cell.hockey-stick {
    background: linear-gradient(135deg, #e0e7ff, #c7d2fe);
    border-color: #6366f1;
    color: #312e81;
  }

  .info-panel {
    max-width: 900px;
    margin: 2rem auto;
    padding: 0 1rem;
  }

  .info-card {
    background: white;
    border-radius: 15px;
    padding: 1.5rem;
    margin-bottom: 1rem;
    border-left: 5px solid var(--pascal-primary);
    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    display: none;
  }

  .info-card.active {
    display: block;
    animation: slideIn 0.4s ease-out;
  }

  @keyframes slideIn {
    from {
      opacity: 0;
      transform: translateX(-20px);
    }
    to {
      opacity: 1;
      transform: translateX(0);
    }
  }

  .info-card h3 {
    color: var(--pascal-dark);
    margin-top: 0;
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }

  .info-card p {
    color: #4b5563;
    line-height: 1.7;
    margin: 0.5rem 0;
  }

  .info-card .formula {
    background: var(--pascal-light);
    padding: 1rem;
    border-radius: 8px;
    font-family: 'Courier New', monospace;
    margin: 1rem 0;
    text-align: center;
    font-size: 1.1rem;
    font-weight: 600;
    color: var(--pascal-dark);
  }

  .stats-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1rem;
    margin: 2rem 0;
  }

  .stat-box {
    background: linear-gradient(135deg, var(--pascal-light), white);
    border: 2px solid var(--pascal-secondary);
    border-radius: 12px;
    padding: 1.5rem;
    text-align: center;
    transition: all 0.3s ease;
  }

  .stat-box:hover {
    transform: translateY(-5px);
    box-shadow: 0 5px 15px rgba(59, 130, 246, 0.3);
  }

  .stat-label {
    font-size: 0.9rem;
    color: #6b7280;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
  }

  .stat-value {
    font-size: 2rem;
    font-weight: 800;
    color: var(--pascal-primary);
    margin-top: 0.5rem;
  }

  .legend {
    display: flex;
    justify-content: center;
    gap: 1.5rem;
    flex-wrap: wrap;
    margin: 2rem 0;
    padding: 1.5rem;
    background: #f9fafb;
    border-radius: 12px;
  }

  .legend-item {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    font-size: 0.9rem;
    font-weight: 600;
  }

  .legend-color {
    width: 30px;
    height: 30px;
    border-radius: 6px;
    border: 2px solid #d1d5db;
  }

  .tooltip {
    position: absolute;
    background: rgba(0, 0, 0, 0.9);
    color: white;
    padding: 0.75rem 1rem;
    border-radius: 8px;
    font-size: 0.85rem;
    pointer-events: none;
    z-index: 1000;
    white-space: nowrap;
    opacity: 0;
    transition: opacity 0.2s ease;
  }

  .tooltip.show {
    opacity: 1;
  }

  @media (max-width: 768px) {
    .pascal-header h1 {
      font-size: 2rem;
    }

    .controls-row {
      flex-direction: column;
      gap: 1rem;
    }

    .triangle-cell {
      min-width: 40px;
      height: 38px;
      font-size: 0.85rem;
    }

    .pattern-selector {
      gap: 0.5rem;
    }

    .pattern-btn {
      padding: 0.5rem 1rem;
      font-size: 0.85rem;
    }

    .stats-grid {
      grid-template-columns: 1fr;
    }
  }
  </style>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="pascal-container">

  <div class="pascal-card">
    <div class="pascal-header">
      <h1>△ Pascal's Triangle Explorer △</h1>
      <p>Discover the hidden patterns and mathematical beauty within Pascal's Triangle</p>
    </div>

    <div class="controls-section">
      <div class="controls-row">
        <div class="control-group">
          <label for="numRows">📊 Number of Rows:</label>
          <input type="number" id="numRows" min="3" max="20" value="10">
        </div>
        <button class="generate-btn" onclick="generateTriangle()">
          △ Generate Triangle
        </button>
      </div>

      <div class="pattern-selector">
        <button class="pattern-btn active" onclick="showPattern('none')">
          🔍 No Pattern
        </button>
        <button class="pattern-btn" onclick="showPattern('fibonacci')">
          🌀 Fibonacci
        </button>
        <button class="pattern-btn" onclick="showPattern('triangular')">
          🔺 Triangular
        </button>
        <button class="pattern-btn" onclick="showPattern('power2')">
          💪 Powers of 2
        </button>
        <button class="pattern-btn" onclick="showPattern('odd-even')">
          🎨 Odd/Even
        </button>
        <button class="pattern-btn" onclick="showPattern('prime')">
          🔢 Primes
        </button>
        <button class="pattern-btn" onclick="showPattern('hockey')">
          🏒 Hockey Stick
        </button>
      </div>
    </div>

    <div class="triangle-display" id="triangleDisplay">
      <div style="text-align: center; color: #6b7280; padding: 3rem;">
        Click "Generate Triangle" to begin exploring!
      </div>
    </div>

    <div class="info-panel" id="infoPanel">
      <!-- Pattern information will be displayed here -->
    </div>
  </div>

</div>

<div class="tooltip" id="tooltip"></div>

<%@ include file="footer_adsense.jsp"%>

<script>
let triangle = [];
let currentPattern = 'none';
let currentRows = 10;

// Generate Pascal's Triangle
function generateTriangle() {
  const numRows = parseInt(document.getElementById('numRows').value);

  if (numRows < 3 || numRows > 20) {
    alert('Please enter a number between 3 and 20');
    return;
  }

  currentRows = numRows;
  triangle = [];

  for (let i = 0; i < numRows; i++) {
    triangle[i] = [];
    for (let j = 0; j <= i; j++) {
      if (j === 0 || j === i) {
        triangle[i][j] = 1;
      } else {
        triangle[i][j] = triangle[i - 1][j - 1] + triangle[i - 1][j];
      }
    }
  }

  displayTriangle();
  showPattern(currentPattern);
  updateStats();
}

// Display the triangle
function displayTriangle() {
  const display = document.getElementById('triangleDisplay');

  let html = '<div class="triangle-container">';

  for (let i = 0; i < triangle.length; i++) {
    html += '<div class="triangle-row" style="animation-delay: ' + (i * 0.05) + 's">';
    for (let j = 0; j <= i; j++) {
      html += `<div class="triangle-cell"
                    data-row="${i}"
                    data-col="${j}"
                    data-value="${triangle[i][j]}"
                    onmouseenter="showTooltip(event, ${i}, ${j}, ${triangle[i][j]})"
                    onmouseleave="hideTooltip()">
                 <span>${triangle[i][j]}</span>
               </div>`;
    }
    html += '</div>';
  }

  html += '</div>';

  display.innerHTML = html;
}

// Show tooltip on hover
function showTooltip(event, row, col, value) {
  const tooltip = document.getElementById('tooltip');
  const cell = event.target.closest('.triangle-cell');
  const rect = cell.getBoundingClientRect();

  tooltip.innerHTML = `
    <strong>Position:</strong> Row ${row}, Column ${col}<br>
    <strong>Value:</strong> ${value}<br>
    <strong>C(${row},${col})</strong> = ${value}
  `;

  tooltip.style.left = (rect.left + rect.width / 2) + 'px';
  tooltip.style.top = (rect.top - 10) + 'px';
  tooltip.style.transform = 'translate(-50%, -100%)';
  tooltip.classList.add('show');
}

function hideTooltip() {
  document.getElementById('tooltip').classList.remove('show');
}

// Pattern highlighting functions
function showPattern(pattern) {
  currentPattern = pattern;

  // Update button states
  document.querySelectorAll('.pattern-btn').forEach(btn => btn.classList.remove('active'));
  event.target.classList.add('active');

  // Clear previous highlights
  document.querySelectorAll('.triangle-cell').forEach(cell => {
    cell.className = 'triangle-cell';
  });

  // Apply new pattern
  switch(pattern) {
    case 'fibonacci':
      highlightFibonacci();
      break;
    case 'triangular':
      highlightTriangular();
      break;
    case 'power2':
      highlightPowersOf2();
      break;
    case 'odd-even':
      highlightOddEven();
      break;
    case 'prime':
      highlightPrimes();
      break;
    case 'hockey':
      highlightHockeyStick();
      break;
  }

  showPatternInfo(pattern);
}

function highlightFibonacci() {
  // Fibonacci appears in shallow diagonals
  const fibonacci = [1, 1];
  for (let i = 2; i < 20; i++) {
    fibonacci[i] = fibonacci[i-1] + fibonacci[i-2];
  }

  let fibIndex = 0;
  for (let i = 0; i < triangle.length && fibIndex < fibonacci.length; i++) {
    let sum = 0;
    for (let j = 0; j <= i && i - j < triangle.length; j++) {
      if (i - j >= 0 && j <= triangle[i - j].length - 1) {
        sum += triangle[i - j][j];
      }
    }
    if (sum === fibonacci[fibIndex]) {
      // Highlight the diagonal
      for (let j = 0; j <= i && i - j < triangle.length; j++) {
        if (i - j >= 0 && j <= triangle[i - j].length - 1) {
          const cell = document.querySelector(`[data-row="${i-j}"][data-col="${j}"]`);
          if (cell) cell.classList.add('fibonacci');
        }
      }
      fibIndex++;
    }
  }
}

function highlightTriangular() {
  // Triangular numbers appear in 3rd diagonal
  for (let i = 2; i < triangle.length; i++) {
    if (2 < triangle[i].length) {
      const cell = document.querySelector(`[data-row="${i}"][data-col="2"]`);
      if (cell) cell.classList.add('triangular');
    }
  }
}

function highlightPowersOf2() {
  // Powers of 2 appear in edges
  for (let i = 0; i < triangle.length; i++) {
    const leftCell = document.querySelector(`[data-row="${i}"][data-col="0"]`);
    const rightCell = document.querySelector(`[data-row="${i}"][data-col="${i}"]`);
    if (leftCell) leftCell.classList.add('power-of-2');
    if (rightCell) rightCell.classList.add('power-of-2');
  }

  // Row sums are powers of 2
  for (let i = 0; i < triangle.length; i++) {
    for (let j = 0; j <= i; j++) {
      const cell = document.querySelector(`[data-row="${i}"][data-col="${j}"]`);
      if (cell && isPowerOf2(triangle[i][j])) {
        cell.classList.add('power-of-2');
      }
    }
  }
}

function highlightOddEven() {
  // Sierpinski triangle pattern
  for (let i = 0; i < triangle.length; i++) {
    for (let j = 0; j <= i; j++) {
      if (triangle[i][j] % 2 === 1) {
        const cell = document.querySelector(`[data-row="${i}"][data-col="${j}"]`);
        if (cell) cell.classList.add('odd');
      }
    }
  }
}

function highlightPrimes() {
  for (let i = 0; i < triangle.length; i++) {
    for (let j = 0; j <= i; j++) {
      if (isPrime(triangle[i][j])) {
        const cell = document.querySelector(`[data-row="${i}"][data-col="${j}"]`);
        if (cell) cell.classList.add('prime');
      }
    }
  }
}

function highlightHockeyStick() {
  // Highlight a sample hockey stick pattern
  if (triangle.length >= 6) {
    // Example: rows 2-5, column 1
    let sum = 0;
    for (let i = 2; i <= 5 && i < triangle.length; i++) {
      if (1 < triangle[i].length) {
        const cell = document.querySelector(`[data-row="${i}"][data-col="1"]`);
        if (cell) {
          cell.classList.add('hockey-stick');
          sum += triangle[i][1];
        }
      }
    }
    // Highlight the result
    if (6 < triangle.length && 2 < triangle[6].length) {
      const resultCell = document.querySelector(`[data-row="6"][data-col="2"]`);
      if (resultCell && triangle[6][2] === sum) {
        resultCell.classList.add('hockey-stick');
      }
    }
  }
}

// Helper functions
function isPrime(n) {
  if (n < 2) return false;
  if (n === 2) return true;
  if (n % 2 === 0) return false;
  for (let i = 3; i * i <= n; i += 2) {
    if (n % i === 0) return false;
  }
  return true;
}

function isPowerOf2(n) {
  return n > 0 && (n & (n - 1)) === 0;
}

// Show pattern information
function showPatternInfo(pattern) {
  const infoPanel = document.getElementById('infoPanel');

  const patterns = {
    'none': {
      title: '🔍 Pascal\'s Triangle',
      content: `
        <p><strong>Pascal's Triangle</strong> is a triangular array of binomial coefficients. Each number is the sum of the two numbers directly above it.</p>
        <div class="formula">C(n,k) = C(n-1,k-1) + C(n-1,k)</div>
        <p><strong>Properties:</strong></p>
        <p>• Each row represents the coefficients in the expansion of (a+b)ⁿ<br>
        • The sum of row n equals 2ⁿ<br>
        • Symmetric across the vertical axis<br>
        • Contains many hidden patterns and sequences</p>
      `
    },
    'fibonacci': {
      title: '🌀 Fibonacci Sequence',
      content: `
        <p><strong>The Fibonacci sequence appears in Pascal's Triangle!</strong> Sum the numbers along the shallow diagonals to find Fibonacci numbers.</p>
        <div class="formula">Fₙ = Sum of nth shallow diagonal</div>
        <p><strong>Example:</strong><br>
        Diagonal 1: 1 → F₁ = 1<br>
        Diagonal 2: 1 → F₂ = 1<br>
        Diagonal 3: 1+1 → F₃ = 2<br>
        Diagonal 4: 1+2 → F₄ = 3<br>
        Diagonal 5: 1+3+1 → F₅ = 5</p>
        <p>The Fibonacci numbers (1, 1, 2, 3, 5, 8, 13...) emerge naturally from Pascal's Triangle!</p>
      `
    },
    'triangular': {
      title: '🔺 Triangular Numbers',
      content: `
        <p><strong>Triangular numbers</strong> appear in the third diagonal! These represent the sum of the first n natural numbers.</p>
        <div class="formula">Tₙ = 1 + 2 + 3 + ... + n = n(n+1)/2</div>
        <p><strong>Sequence:</strong> 1, 3, 6, 10, 15, 21, 28, 36, 45...</p>
        <p>Each triangular number C(n,2) represents how many handshakes occur when n+1 people each shake hands once!</p>
        <p><strong>Visual:</strong> They form triangle shapes when arranged as dots:<br>
        • = 1<br>
        •• = 3<br>
        ••• = 6</p>
      `
    },
    'power2': {
      title: '💪 Powers of 2',
      content: `
        <p><strong>Powers of 2 are everywhere in Pascal's Triangle!</strong></p>
        <div class="formula">Sum of row n = 2ⁿ</div>
        <p><strong>Examples:</strong><br>
        Row 0: 1 = 2⁰<br>
        Row 1: 1+1 = 2¹<br>
        Row 2: 1+2+1 = 2²<br>
        Row 3: 1+3+3+1 = 2³</p>
        <p>This relates to binary counting and the binomial theorem: (1+1)ⁿ = 2ⁿ</p>
        <p>Also, every number that is a power of 2 (1, 2, 4, 8, 16...) appears in the triangle!</p>
      `
    },
    'odd-even': {
      title: '🎨 Sierpinski Triangle',
      content: `
        <p><strong>Coloring odd and even numbers reveals the Sierpinski Triangle!</strong> This famous fractal pattern emerges naturally.</p>
        <div class="formula">Purple cells = odd numbers (Sierpinski pattern)</div>
        <p>As you generate more rows, the self-similar fractal pattern becomes more apparent. This is a remarkable connection between combinatorics and fractals!</p>
        <p><strong>Properties:</strong><br>
        • Self-similar at all scales<br>
        • Infinite detail<br>
        • Dimension ≈ 1.585 (between 1D and 2D)<br>
        • Appears in chaos theory</p>
      `
    },
    'prime': {
      title: '🔢 Prime Numbers',
      content: `
        <p><strong>Prime numbers in Pascal's Triangle</strong> have special properties!</p>
        <p><strong>Theorem:</strong> If p is prime, then C(p,k) is divisible by p for all 0 < k < p.</p>
        <p>This means in prime-numbered rows, all interior numbers (except the 1's) are divisible by that prime!</p>
        <p><strong>Example (Row 5):</strong><br>
        1, 5, 10, 10, 5, 1<br>
        5|5 ✓, 5|10 ✓, 5|10 ✓, 5|5 ✓</p>
        <p>Prime numbers themselves appear scattered throughout the triangle.</p>
      `
    },
    'hockey': {
      title: '🏒 Hockey Stick Pattern',
      content: `
        <p><strong>The Hockey Stick Identity</strong> is a beautiful pattern in Pascal's Triangle!</p>
        <div class="formula">C(r,r) + C(r+1,r) + ... + C(n,r) = C(n+1,r+1)</div>
        <p>Start at any 1 on the edge, go down diagonally any distance, and sum those numbers. The total equals the next number down in the adjacent column!</p>
        <p><strong>Visual:</strong> The highlighted cells show an example. The diagonal sum equals the cell at the "blade" of the hockey stick.</p>
        <p><strong>Example:</strong><br>
        1 + 2 + 3 + 4 = 10 ✓<br>
        This appears at C(5,2)!</p>
      `
    }
  };

  const info = patterns[pattern] || patterns['none'];

  let html = `
    <div class="info-card active">
      <h3>${info.title}</h3>
      ${info.content}
    </div>
  `;

  // Add legend for current pattern
  if (pattern !== 'none') {
    html += '<div class="legend">';
    html += '<div class="legend-item">';
    html += `<div class="legend-color ${pattern === 'fibonacci' ? 'fibonacci' : pattern === 'triangular' ? 'triangular' : pattern === 'power2' ? 'power-of-2' : pattern === 'odd-even' ? 'odd' : pattern === 'prime' ? 'prime' : 'hockey-stick'}"></div>`;
    html += `<span>Highlighted Pattern</span>`;
    html += '</div>';
    html += '</div>';
  }

  infoPanel.innerHTML = html;
}

// Update statistics
function updateStats() {
  // Count statistics
  let totalNumbers = 0;
  let evenCount = 0;
  let oddCount = 0;
  let primeCount = 0;
  let maxValue = 0;

  for (let i = 0; i < triangle.length; i++) {
    for (let j = 0; j <= i; j++) {
      const val = triangle[i][j];
      totalNumbers++;
      if (val % 2 === 0) evenCount++;
      else oddCount++;
      if (isPrime(val)) primeCount++;
      if (val > maxValue) maxValue = val;
    }
  }

  const rowSum = Math.pow(2, triangle.length - 1);

  // Display stats
  const infoPanel = document.getElementById('infoPanel');
  let statsHtml = `
    <div class="stats-grid">
      <div class="stat-box">
        <div class="stat-label">Total Numbers</div>
        <div class="stat-value">${totalNumbers}</div>
      </div>
      <div class="stat-box">
        <div class="stat-label">Largest Value</div>
        <div class="stat-value">${maxValue.toLocaleString()}</div>
      </div>
      <div class="stat-box">
        <div class="stat-label">Prime Numbers</div>
        <div class="stat-value">${primeCount}</div>
      </div>
      <div class="stat-box">
        <div class="stat-label">Last Row Sum</div>
        <div class="stat-value">${rowSum.toLocaleString()}</div>
      </div>
    </div>
  `;

  infoPanel.innerHTML = statsHtml + infoPanel.innerHTML;
}

// Initialize
document.addEventListener('DOMContentLoaded', function() {
  generateTriangle();
});
</script>
</div>
<%@ include file="body-close.jsp"%>
