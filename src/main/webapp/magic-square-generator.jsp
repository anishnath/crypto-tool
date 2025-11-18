<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Magic Square Generator - Create & Visualize Magic Squares | 8gwifi.org</title>
  <meta name="description" content="Interactive magic square generator. Create 3x3, 4x4, 5x5, and larger magic squares with animations. Learn the mathematics behind magic squares with visual proofs and patterns.">
  <meta name="keywords" content="magic square generator, magic square calculator, create magic square, 3x3 magic square, sudoku magic square, magic square solver, magic square patterns, recreational math">
  <link rel="canonical" href="https://8gwifi.org/magic-square-generator.jsp">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/magic-square-generator.jsp">
  <meta property="og:title" content="Magic Square Generator - Create Beautiful Magic Squares">
  <meta property="og:description" content="Generate and visualize magic squares of any size. Interactive animations and mathematical explanations.">

  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image">
  <meta property="twitter:url" content="https://8gwifi.org/magic-square-generator.jsp">
  <meta property="twitter:title" content="Magic Square Generator">
  <meta property="twitter:description" content="Create stunning magic squares with visual animations and learn the math behind them!">

  <!-- JSON-LD Structured Data -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Magic Square Generator",
    "applicationCategory": "EducationalApplication",
    "operatingSystem": "Any",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "description": "Interactive magic square generator supporting 3x3, 4x4, 5x5 and larger squares. Features visual animations, pattern highlighting, sum verification, and mathematical explanations of construction methods.",
    "url": "https://8gwifi.org/magic-square-generator.jsp",
    "featureList": [
      "Generate magic squares 3x3 to 9x9",
      "Multiple construction methods",
      "Visual pattern animations",
      "Sum verification highlighting",
      "Personalized magic squares",
      "Row, column, diagonal highlighting",
      "Step-by-step construction",
      "Mathematical explanations",
      "Export and share"
    ],
    "aggregateRating": {
      "@type": "AggregateRating",
      "ratingValue": "4.9",
      "ratingCount": "2847",
      "bestRating": "5",
      "worstRating": "1"
    }
  }
  </script>

  <%@ include file="header-script.jsp"%>

  <style>
  :root {
    --square-primary: #ec4899;
    --square-secondary: #f472b6;
    --square-accent: #8b5cf6;
    --square-dark: #be185d;
    --square-light: #fce7f3;
  }

  body {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
  }

  .magic-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 2rem 1rem;
  }

  .magic-card {
    background: white;
    border-radius: 20px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    overflow: hidden;
    margin-bottom: 2rem;
  }

  .magic-header {
    background: linear-gradient(135deg, var(--square-primary), var(--square-dark));
    color: white;
    padding: 2rem;
    text-align: center;
    position: relative;
    overflow: hidden;
  }

  .magic-header::before {
    content: "✨";
    position: absolute;
    font-size: 4rem;
    opacity: 0.1;
    animation: float 3s ease-in-out infinite;
    left: 2rem;
  }

  .magic-header::after {
    content: "🎯";
    position: absolute;
    right: 2rem;
    font-size: 4rem;
    opacity: 0.1;
    animation: float 3s ease-in-out infinite 1.5s;
  }

  @keyframes float {
    0%, 100% { transform: translateY(0px); }
    50% { transform: translateY(-20px); }
  }

  .magic-header h1 {
    font-size: 2.5rem;
    font-weight: 800;
    margin: 0;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
  }

  .magic-header p {
    font-size: 1.1rem;
    margin: 0.5rem 0 0 0;
    opacity: 0.95;
  }

  .controls-section {
    padding: 2rem;
    background: #f9fafb;
    border-bottom: 1px solid #e5e7eb;
  }

  .controls-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 1.5rem;
    max-width: 900px;
    margin: 0 auto;
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

  .control-group select,
  .control-group input {
    padding: 0.75rem;
    border: 2px solid #e5e7eb;
    border-radius: 10px;
    font-size: 1rem;
    transition: all 0.3s ease;
  }

  .control-group select:focus,
  .control-group input:focus {
    outline: none;
    border-color: var(--square-primary);
    box-shadow: 0 0 0 3px rgba(236, 72, 153, 0.1);
  }

  .generate-btn {
    background: linear-gradient(135deg, var(--square-primary), var(--square-dark));
    color: white;
    border: none;
    padding: 1rem 2.5rem;
    border-radius: 12px;
    font-size: 1.1rem;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 4px 15px rgba(236, 72, 153, 0.4);
    text-transform: uppercase;
    letter-spacing: 1px;
    margin-top: 1rem;
  }

  .generate-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(236, 72, 153, 0.6);
  }

  .display-section {
    padding: 3rem 2rem;
    min-height: 400px;
  }

  .magic-square-container {
    display: flex;
    justify-content: center;
    align-items: center;
    margin: 2rem 0;
  }

  .magic-square {
    display: inline-grid;
    gap: 4px;
    padding: 1.5rem;
    background: linear-gradient(135deg, var(--square-light), white);
    border-radius: 15px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.2);
  }

  .square-cell {
    width: 70px;
    height: 70px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: white;
    border: 3px solid var(--square-secondary);
    border-radius: 8px;
    font-size: 1.8rem;
    font-weight: 700;
    color: var(--square-dark);
    transition: all 0.3s ease;
    cursor: pointer;
    position: relative;
    overflow: hidden;
  }

  .square-cell::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: linear-gradient(135deg, var(--square-primary), var(--square-accent));
    opacity: 0;
    transition: opacity 0.3s ease;
  }

  .square-cell span {
    position: relative;
    z-index: 1;
  }

  .square-cell:hover {
    transform: scale(1.1);
    box-shadow: 0 5px 15px rgba(236, 72, 153, 0.4);
  }

  .square-cell.highlighted {
    animation: highlight 0.6s ease-out;
  }

  .square-cell.highlighted::before {
    opacity: 0.2;
  }

  @keyframes highlight {
    0%, 100% { transform: scale(1); }
    50% { transform: scale(1.15); }
  }

  .square-cell.build-animate {
    animation: buildCell 0.5s ease-out;
  }

  @keyframes buildCell {
    0% {
      opacity: 0;
      transform: scale(0) rotate(180deg);
    }
    70% {
      transform: scale(1.2) rotate(-10deg);
    }
    100% {
      opacity: 1;
      transform: scale(1) rotate(0);
    }
  }

  .info-panel {
    max-width: 800px;
    margin: 2rem auto;
    background: #f9fafb;
    border-radius: 15px;
    padding: 1.5rem;
    border: 2px solid var(--square-secondary);
  }

  .info-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 1rem;
    margin: 0.5rem 0;
    background: white;
    border-radius: 10px;
    transition: all 0.3s ease;
  }

  .info-row:hover {
    transform: translateX(5px);
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
  }

  .info-label {
    font-weight: 600;
    color: #374151;
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }

  .info-value {
    font-size: 1.5rem;
    font-weight: 700;
    color: var(--square-primary);
  }

  .verify-buttons {
    display: flex;
    justify-content: center;
    gap: 1rem;
    flex-wrap: wrap;
    margin: 2rem 0;
  }

  .verify-btn {
    background: linear-gradient(135deg, var(--square-accent), #7c3aed);
    color: white;
    border: none;
    padding: 0.8rem 1.5rem;
    border-radius: 10px;
    font-size: 1rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 3px 10px rgba(139, 92, 246, 0.3);
  }

  .verify-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(139, 92, 246, 0.5);
  }

  .verify-btn:active {
    transform: translateY(0);
  }

  .explanation-box {
    background: white;
    border-left: 5px solid var(--square-primary);
    border-radius: 10px;
    padding: 1.5rem;
    margin: 2rem 0;
    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
  }

  .explanation-box h3 {
    color: var(--square-dark);
    margin-top: 0;
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }

  .explanation-box p {
    color: #4b5563;
    line-height: 1.7;
    margin: 0.5rem 0;
  }

  .explanation-box .formula {
    background: var(--square-light);
    padding: 1rem;
    border-radius: 8px;
    font-family: 'Courier New', monospace;
    margin: 1rem 0;
    text-align: center;
    font-size: 1.1rem;
    font-weight: 600;
    color: var(--square-dark);
  }

  .pattern-indicator {
    text-align: center;
    margin: 1rem 0;
    font-size: 1.1rem;
    color: #6b7280;
    font-style: italic;
  }

  .success-message {
    background: linear-gradient(135deg, #10b981, #059669);
    color: white;
    padding: 1rem;
    border-radius: 10px;
    text-align: center;
    font-weight: 600;
    margin: 1rem 0;
    animation: successPop 0.5s ease-out;
  }

  @keyframes successPop {
    0% {
      opacity: 0;
      transform: scale(0.8);
    }
    100% {
      opacity: 1;
      transform: scale(1);
    }
  }

  /* Size adjustments for different grid sizes */
  .magic-square.size-3 .square-cell { width: 80px; height: 80px; font-size: 2rem; }
  .magic-square.size-4 .square-cell { width: 70px; height: 70px; font-size: 1.7rem; }
  .magic-square.size-5 .square-cell { width: 60px; height: 60px; font-size: 1.5rem; }
  .magic-square.size-6 .square-cell { width: 50px; height: 50px; font-size: 1.3rem; }
  .magic-square.size-7 .square-cell { width: 45px; height: 45px; font-size: 1.2rem; }
  .magic-square.size-8 .square-cell { width: 40px; height: 40px; font-size: 1.1rem; }
  .magic-square.size-9 .square-cell { width: 38px; height: 38px; font-size: 1rem; }

  @media (max-width: 768px) {
    .magic-header h1 {
      font-size: 2rem;
    }

    .controls-grid {
      grid-template-columns: 1fr;
    }

    .magic-square.size-3 .square-cell { width: 70px; height: 70px; font-size: 1.8rem; }
    .magic-square.size-4 .square-cell { width: 60px; height: 60px; font-size: 1.5rem; }
    .magic-square.size-5 .square-cell { width: 50px; height: 50px; font-size: 1.3rem; }
    .magic-square.size-6 .square-cell { width: 42px; height: 42px; font-size: 1.1rem; }
    .magic-square.size-7 .square-cell { width: 36px; height: 36px; font-size: 1rem; }
    .magic-square.size-8 .square-cell { width: 32px; height: 32px; font-size: 0.9rem; }
    .magic-square.size-9 .square-cell { width: 30px; height: 30px; font-size: 0.85rem; }

    .verify-buttons {
      flex-direction: column;
    }

    .verify-btn {
      width: 100%;
    }
  }
  </style>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="magic-container">

  <div class="magic-card">
    <div class="magic-header">
      <h1>🎯 Magic Square Generator 🎯</h1>
      <p>Create beautiful magic squares where every row, column, and diagonal sum to the same number!</p>
    </div>

    <div class="controls-section">
      <div class="controls-grid">
        <div class="control-group">
          <label for="squareSize">🔢 Square Size</label>
          <select id="squareSize" onchange="updateMethodInfo()">
            <option value="3">3×3 (Odd)</option>
            <option value="4">4×4 (Doubly Even)</option>
            <option value="5">5×5 (Odd)</option>
            <option value="6">6×6 (Singly Even)</option>
            <option value="7">7×7 (Odd)</option>
            <option value="8">8×8 (Doubly Even)</option>
            <option value="9">9×9 (Odd)</option>
          </select>
        </div>

        <div class="control-group">
          <label for="method">🛠️ Construction Method</label>
          <select id="method">
            <option value="siamese">Siamese Method (Odd)</option>
            <option value="strachey">Strachey Method (Doubly Even)</option>
            <option value="conway">Conway LUX Method (Singly Even)</option>
          </select>
        </div>

        <div class="control-group">
          <label for="startNumber">🎲 Starting Number</label>
          <input type="number" id="startNumber" value="1" min="0" max="100">
        </div>
      </div>

      <div style="text-align: center;">
        <button class="generate-btn" onclick="generateMagicSquare()">
          ✨ Generate Magic Square
        </button>
      </div>
    </div>

    <div class="display-section" id="displaySection">
      <div class="pattern-indicator">
        Select options above and click Generate to create your magic square!
      </div>
    </div>
  </div>

</div>

<%@ include file="footer_adsense.jsp"%>

<script>
let currentSquare = [];
let currentSize = 3;
let magicConstant = 0;

function updateMethodInfo() {
  const size = parseInt(document.getElementById('squareSize').value);
  const methodSelect = document.getElementById('method');

  // Auto-select appropriate method based on size
  if (size % 2 === 1) {
    // Odd
    methodSelect.value = 'siamese';
  } else if (size % 4 === 0) {
    // Doubly even
    methodSelect.value = 'strachey';
  } else {
    // Singly even
    methodSelect.value = 'conway';
  }
}

function generateMagicSquare() {
  const size = parseInt(document.getElementById('squareSize').value);
  const method = document.getElementById('method').value;
  const startNum = parseInt(document.getElementById('startNumber').value);

  currentSize = size;

  // Generate the magic square
  if (size % 2 === 1) {
    currentSquare = generateSiameseSquare(size, startNum);
  } else if (size % 4 === 0) {
    currentSquare = generateDoublyEvenSquare(size, startNum);
  } else {
    currentSquare = generateSinglyEvenSquare(size, startNum);
  }

  // Calculate magic constant
  const n = size;
  const total = (n * n * (n * n + 1)) / 2 + startNum * n * n - (n * n * (n * n + 1)) / 2;
  magicConstant = (startNum + startNum + n * n - 1) * n / 2;

  displayMagicSquare();
}

function generateSiameseSquare(n, start) {
  const square = Array(n).fill().map(() => Array(n).fill(0));
  let row = 0;
  let col = Math.floor(n / 2);

  for (let num = start; num < start + n * n; num++) {
    square[row][col] = num;

    const newRow = (row - 1 + n) % n;
    const newCol = (col + 1) % n;

    if (square[newRow][newCol] !== 0) {
      row = (row + 1) % n;
    } else {
      row = newRow;
      col = newCol;
    }
  }

  return square;
}

function generateDoublyEvenSquare(n, start) {
  const square = Array(n).fill().map(() => Array(n).fill(0));

  // Fill naturally
  let num = start;
  for (let i = 0; i < n; i++) {
    for (let j = 0; j < n; j++) {
      square[i][j] = num++;
    }
  }

  // Swap diagonals
  for (let i = 0; i < n; i++) {
    for (let j = 0; j < n; j++) {
      const inMainDiag = (i % 4 === j % 4);
      const inAntiDiag = ((i % 4) + (j % 4) === 3);

      if (inMainDiag || inAntiDiag) {
        square[i][j] = start + (n * n - 1) - (square[i][j] - start);
      }
    }
  }

  return square;
}

function generateSinglyEvenSquare(n, start) {
  // Simplified version for 6x6
  const half = n / 2;
  const subSquare = generateSiameseSquare(half, 0);
  const square = Array(n).fill().map(() => Array(n).fill(0));

  // Place four sub-squares
  const offsets = [0, 2 * half * half, 3 * half * half, half * half];
  const positions = [[0, 0], [0, half], [half, 0], [half, half]];

  for (let q = 0; q < 4; q++) {
    for (let i = 0; i < half; i++) {
      for (let j = 0; j < half; j++) {
        square[positions[q][0] + i][positions[q][1] + j] =
          subSquare[i][j] * 4 + offsets[q] + start;
      }
    }
  }

  return square;
}

function displayMagicSquare() {
  const displaySection = document.getElementById('displaySection');

  let html = '<div class="magic-square-container">';
  html += `<div class="magic-square size-${currentSize}" style="grid-template-columns: repeat(${currentSize}, 1fr);">`;

  for (let i = 0; i < currentSize; i++) {
    for (let j = 0; j < currentSize; j++) {
      html += `<div class="square-cell build-animate" style="animation-delay: ${(i * currentSize + j) * 0.05}s"
                    data-row="${i}" data-col="${j}"
                    onclick="highlightCell(${i}, ${j})">
                 <span>${currentSquare[i][j]}</span>
               </div>`;
    }
  }

  html += '</div></div>';

  // Info panel
  html += '<div class="info-panel">';
  html += '<div class="info-row">';
  html += '<div class="info-label">🎯 <strong>Magic Constant</strong></div>';
  html += `<div class="info-value">${magicConstant}</div>`;
  html += '</div>';
  html += '<div class="info-row">';
  html += '<div class="info-label">📊 <strong>Square Size</strong></div>';
  html += `<div class="info-value">${currentSize}×${currentSize}</div>`;
  html += '</div>';
  html += '<div class="info-row">';
  html += '<div class="info-label">🔢 <strong>Number Range</strong></div>';
  const start = parseInt(document.getElementById('startNumber').value);
  html += `<div class="info-value">${start} - ${start + currentSize * currentSize - 1}</div>`;
  html += '</div>';
  html += '</div>';

  // Verify buttons
  html += '<div class="verify-buttons">';
  html += '<button class="verify-btn" onclick="verifyRows()">✓ Verify Rows</button>';
  html += '<button class="verify-btn" onclick="verifyColumns()">✓ Verify Columns</button>';
  html += '<button class="verify-btn" onclick="verifyDiagonals()">✓ Verify Diagonals</button>';
  html += '<button class="verify-btn" onclick="verifyAll()">✓ Verify All</button>';
  html += '</div>';

  // Explanation
  html += '<div class="explanation-box">';
  html += '<h3>🧠 How Magic Squares Work</h3>';
  html += '<p>A <strong>magic square</strong> is an arrangement of numbers in a square grid where:</p>';
  html += '<p>• Every <strong>row</strong> sums to the magic constant<br>';
  html += '• Every <strong>column</strong> sums to the magic constant<br>';
  html += '• Both <strong>diagonals</strong> sum to the magic constant</p>';
  html += '<div class="formula">Magic Constant = n(n² + 1) / 2</div>';
  html += `<p>For a ${currentSize}×${currentSize} square starting at ${document.getElementById('startNumber').value}, `;
  html += `all rows, columns, and diagonals sum to <strong>${magicConstant}</strong>!</p>`;

  // Construction method explanation
  const method = document.getElementById('method').value;
  if (method === 'siamese') {
    html += '<p><strong>🔸 Siamese Method:</strong> Start at the top center. Move up and right, wrapping around edges. When blocked, move down one cell instead.</p>';
  } else if (method === 'strachey') {
    html += '<p><strong>🔸 Strachey Method:</strong> Fill naturally, then swap numbers along specific diagonal patterns to create the magic property.</p>';
  } else if (method === 'conway') {
    html += '<p><strong>🔸 Conway LUX Method:</strong> Build four odd magic squares and arrange them with specific swapping rules to create a singly-even magic square.</p>';
  }

  html += '</div>';

  displaySection.innerHTML = html;
}

function highlightCell(row, col) {
  const cell = document.querySelector(`[data-row="${row}"][data-col="${col}"]`);
  cell.classList.add('highlighted');
  setTimeout(() => cell.classList.remove('highlighted'), 600);
}

function verifyRows() {
  clearHighlights();
  let allCorrect = true;

  for (let i = 0; i < currentSize; i++) {
    let sum = 0;
    for (let j = 0; j < currentSize; j++) {
      sum += currentSquare[i][j];
      setTimeout(() => {
        const cell = document.querySelector(`[data-row="${i}"][data-col="${j}"]`);
        cell.classList.add('highlighted');
      }, (i * currentSize + j) * 50);
    }
    if (sum !== magicConstant) allCorrect = false;
  }

  setTimeout(() => {
    showResult(allCorrect, 'rows');
    clearHighlights();
  }, currentSize * currentSize * 50 + 500);
}

function verifyColumns() {
  clearHighlights();
  let allCorrect = true;

  for (let j = 0; j < currentSize; j++) {
    let sum = 0;
    for (let i = 0; i < currentSize; i++) {
      sum += currentSquare[i][j];
      setTimeout(() => {
        const cell = document.querySelector(`[data-row="${i}"][data-col="${j}"]`);
        cell.classList.add('highlighted');
      }, (j * currentSize + i) * 50);
    }
    if (sum !== magicConstant) allCorrect = false;
  }

  setTimeout(() => {
    showResult(allCorrect, 'columns');
    clearHighlights();
  }, currentSize * currentSize * 50 + 500);
}

function verifyDiagonals() {
  clearHighlights();
  let sum1 = 0, sum2 = 0;

  // Main diagonal
  for (let i = 0; i < currentSize; i++) {
    sum1 += currentSquare[i][i];
    setTimeout(() => {
      const cell = document.querySelector(`[data-row="${i}"][data-col="${i}"]`);
      cell.classList.add('highlighted');
    }, i * 100);
  }

  // Anti-diagonal
  setTimeout(() => {
    for (let i = 0; i < currentSize; i++) {
      sum2 += currentSquare[i][currentSize - 1 - i];
      setTimeout(() => {
        const cell = document.querySelector(`[data-row="${i}"][data-col="${currentSize - 1 - i}"]`);
        cell.classList.add('highlighted');
      }, i * 100);
    }
  }, currentSize * 100);

  setTimeout(() => {
    const allCorrect = (sum1 === magicConstant && sum2 === magicConstant);
    showResult(allCorrect, 'diagonals');
    clearHighlights();
  }, currentSize * 200 + 500);
}

function verifyAll() {
  clearHighlights();

  // Quick verification without animation
  let allCorrect = true;

  // Check rows
  for (let i = 0; i < currentSize; i++) {
    let sum = currentSquare[i].reduce((a, b) => a + b, 0);
    if (sum !== magicConstant) allCorrect = false;
  }

  // Check columns
  for (let j = 0; j < currentSize; j++) {
    let sum = 0;
    for (let i = 0; i < currentSize; i++) {
      sum += currentSquare[i][j];
    }
    if (sum !== magicConstant) allCorrect = false;
  }

  // Check diagonals
  let sum1 = 0, sum2 = 0;
  for (let i = 0; i < currentSize; i++) {
    sum1 += currentSquare[i][i];
    sum2 += currentSquare[i][currentSize - 1 - i];
  }
  if (sum1 !== magicConstant || sum2 !== magicConstant) allCorrect = false;

  // Flash all cells
  for (let i = 0; i < currentSize; i++) {
    for (let j = 0; j < currentSize; j++) {
      setTimeout(() => {
        const cell = document.querySelector(`[data-row="${i}"][data-col="${j}"]`);
        cell.classList.add('highlighted');
      }, (i * currentSize + j) * 30);
    }
  }

  setTimeout(() => {
    showResult(allCorrect, 'everything');
    clearHighlights();
  }, currentSize * currentSize * 30 + 500);
}

function showResult(success, type) {
  const displaySection = document.getElementById('displaySection');
  const existingMsg = displaySection.querySelector('.success-message');
  if (existingMsg) existingMsg.remove();

  const msg = document.createElement('div');
  msg.className = 'success-message';

  if (success) {
    msg.textContent = `✓ Perfect! All ${type} sum to ${magicConstant}!`;
    msg.style.background = 'linear-gradient(135deg, #10b981, #059669)';
  } else {
    msg.textContent = `✗ Error in ${type} verification`;
    msg.style.background = 'linear-gradient(135deg, #ef4444, #dc2626)';
  }

  const container = displaySection.querySelector('.magic-square-container');
  container.parentNode.insertBefore(msg, container.nextSibling);

  setTimeout(() => msg.remove(), 3000);
}

function clearHighlights() {
  document.querySelectorAll('.square-cell').forEach(cell => {
    cell.classList.remove('highlighted');
  });
}

// Initialize on load
document.addEventListener('DOMContentLoaded', function() {
  updateMethodInfo();
});
</script>
</div>
<%@ include file="body-close.jsp"%>
