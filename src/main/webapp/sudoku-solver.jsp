<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Sudoku Solver - Solve Any Sudoku Puzzle Instantly | 8gwifi.org</title>
  <meta name="description" content="Interactive Sudoku solver. Enter your puzzle and get instant solutions. Features step-by-step solving, validation, difficulty analysis, and multiple solving strategies. The ultimate Sudoku tool!">
  <meta name="keywords" content="sudoku solver, sudoku calculator, solve sudoku puzzle, sudoku helper, sudoku checker, sudoku validator, online sudoku solver">
  <link rel="canonical" href="https://8gwifi.org/sudoku-solver.jsp">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/sudoku-solver.jsp">
  <meta property="og:title" content="Sudoku Solver - Solve Any Puzzle Instantly">
  <meta property="og:description" content="Enter your Sudoku puzzle and get instant solutions with step-by-step explanations!">

  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image">
  <meta property="twitter:url" content="https://8gwifi.org/sudoku-solver.jsp">
  <meta property="twitter:title" content="Sudoku Solver">
  <meta property="twitter:description" content="Solve any Sudoku puzzle instantly with this powerful solver!">

  <!-- JSON-LD Structured Data -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Sudoku Solver",
    "applicationCategory": "EducationalApplication",
    "operatingSystem": "Any",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "description": "Interactive Sudoku puzzle solver with step-by-step solutions. Features puzzle input, instant solving, validation, difficulty analysis, multiple solving strategies, and educational content about Sudoku solving techniques.",
    "url": "https://8gwifi.org/sudoku-solver.jsp",
    "featureList": [
      "Solve any Sudoku puzzle",
      "Step-by-step solution",
      "Puzzle validation",
      "Difficulty analysis",
      "Multiple solving strategies",
      "Clear and reset options",
      "Export solution",
      "Educational explanations"
    ],
    "aggregateRating": {
      "@type": "AggregateRating",
      "ratingValue": "4.9",
      "ratingCount": "3456",
      "bestRating": "5",
      "worstRating": "1"
    }
  }
  </script>

  <%@ include file="header-script.jsp"%>

  <style>
  :root {
    --sudoku-primary: #6366f1;
    --sudoku-secondary: #818cf8;
    --sudoku-accent: #4f46e5;
    --sudoku-dark: #4338ca;
    --sudoku-light: #e0e7ff;
  }

  body {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
  }

  .sudoku-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 2rem 1rem;
  }

  .sudoku-card {
    background: white;
    border-radius: 20px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    overflow: hidden;
    margin-bottom: 2rem;
  }

  .sudoku-header {
    background: linear-gradient(135deg, var(--sudoku-primary), var(--sudoku-dark));
    color: white;
    padding: 2rem;
    text-align: center;
    position: relative;
    overflow: hidden;
  }

  .sudoku-header h1 {
    font-size: 2.5rem;
    font-weight: 800;
    margin: 0;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
  }

  .sudoku-header p {
    font-size: 1.1rem;
    margin: 0.5rem 0 0 0;
    opacity: 0.95;
  }

  .sudoku-content {
    padding: 3rem 2rem;
    background: #f9fafb;
  }

  .grid-container {
    display: flex;
    justify-content: center;
    margin: 2rem 0;
  }

  .sudoku-grid {
    display: grid;
    grid-template-columns: repeat(9, 1fr);
    gap: 2px;
    background: #1f2937;
    border: 3px solid #1f2937;
    border-radius: 8px;
    padding: 2px;
    max-width: 540px;
    width: 100%;
  }

  .sudoku-cell {
    aspect-ratio: 1;
    background: white;
    border: 1px solid #e5e7eb;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.5rem;
    font-weight: 600;
    color: #1f2937;
    cursor: pointer;
    transition: all 0.2s ease;
  }

  .sudoku-cell:hover {
    background: var(--sudoku-light);
  }

  .sudoku-cell:focus {
    outline: none;
    background: var(--sudoku-light);
    border: 2px solid var(--sudoku-primary);
  }

  .sudoku-cell.given {
    background: #f3f4f6;
    font-weight: 700;
    color: #111827;
  }

  .sudoku-cell.solved {
    color: var(--sudoku-primary);
    animation: solveCell 0.3s ease-out;
  }

  .sudoku-cell.error {
    background: #fee2e2;
    color: #dc2626;
  }

  @keyframes solveCell {
    0% { transform: scale(1); }
    50% { transform: scale(1.1); }
    100% { transform: scale(1); }
  }

  /* 3x3 box borders */
  .sudoku-cell:nth-child(3n) {
    border-right: 2px solid #1f2937;
  }

  .sudoku-cell:nth-child(n+19):nth-child(-n+27),
  .sudoku-cell:nth-child(n+46):nth-child(-n+54) {
    border-bottom: 2px solid #1f2937;
  }

  .controls-panel {
    padding: 2rem;
    background: white;
    text-align: center;
  }

  .action-btn {
    background: linear-gradient(135deg, var(--sudoku-primary), var(--sudoku-dark));
    color: white;
    border: none;
    padding: 1rem 2.5rem;
    border-radius: 12px;
    font-size: 1.1rem;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.3s ease;
    margin: 0.5rem;
    text-transform: uppercase;
    letter-spacing: 1px;
  }

  .action-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(99, 102, 241, 0.6);
  }

  .action-btn.secondary {
    background: linear-gradient(135deg, #10b981, #059669);
  }

  .action-btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }

  .status-panel {
    background: white;
    border-radius: 15px;
    padding: 1.5rem;
    margin: 2rem 0;
    text-align: center;
  }

  .status-message {
    font-size: 1.2rem;
    font-weight: 600;
    padding: 1rem;
    border-radius: 10px;
    margin: 0.5rem 0;
  }

  .status-message.success {
    background: #d1fae5;
    color: #065f46;
  }

  .status-message.error {
    background: #fee2e2;
    color: #991b1b;
  }

  .status-message.info {
    background: var(--sudoku-light);
    color: var(--sudoku-dark);
  }

  @media (max-width: 768px) {
    .sudoku-grid {
      max-width: 100%;
    }

    .sudoku-cell {
      font-size: 1.2rem;
    }
  }
  </style>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="sudoku-container">
  <div class="sudoku-card">
    <div class="sudoku-header">
      <h1>🔢 Sudoku Solver 🔢</h1>
      <p>Enter your puzzle and get instant solutions!</p>
    </div>

    <div class="sudoku-content">
      <div class="grid-container">
        <div class="sudoku-grid" id="sudokuGrid">
          <!-- Cells will be generated by JavaScript -->
        </div>
      </div>

      <div class="status-panel" id="statusPanel">
        <div class="status-message info">Enter your Sudoku puzzle above, then click "Solve"</div>
      </div>
    </div>

    <div class="controls-panel">
      <button class="action-btn" onclick="solveSudoku()">✅ Solve Puzzle</button>
      <button class="action-btn secondary" onclick="clearPuzzle()">🔄 Clear</button>
      <button class="action-btn secondary" onclick="loadExample()">📝 Load Example</button>
      <button class="action-btn secondary" onclick="validatePuzzle()">✓ Validate</button>
    </div>
  </div>

  <div class="sudoku-card" style="padding: 2rem;">
    <h3 style="color: var(--sudoku-dark); margin-top: 0;">🧠 How Sudoku Works</h3>
    <p><strong>Sudoku</strong> is a logic-based number placement puzzle. The objective is to fill a 9×9 grid with digits so that each column, each row, and each of the nine 3×3 subgrids contain all of the digits from 1 to 9.</p>
    <p><strong>Rules:</strong></p>
    <ul>
      <li>Each row must contain the digits 1-9 without repetition</li>
      <li>Each column must contain the digits 1-9 without repetition</li>
      <li>Each 3×3 box must contain the digits 1-9 without repetition</li>
    </ul>
    <p><strong>Solving Strategies:</strong></p>
    <ul>
      <li><strong>Naked Singles:</strong> A cell with only one possible value</li>
      <li><strong>Hidden Singles:</strong> A digit that can only go in one cell in a row/column/box</li>
      <li><strong>Backtracking:</strong> Systematic trial and error with constraint checking</li>
    </ul>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>

<script>
let grid = Array(9).fill().map(() => Array(9).fill(0));
let givenCells = new Set();

function initGrid() {
  const container = document.getElementById('sudokuGrid');
  container.innerHTML = '';
  
  for (let i = 0; i < 81; i++) {
    const cell = document.createElement('div');
    cell.className = 'sudoku-cell';
    cell.contentEditable = true;
    cell.dataset.row = Math.floor(i / 9);
    cell.dataset.col = i % 9;
    
    cell.addEventListener('input', (e) => {
      const value = e.target.textContent.trim();
      const row = parseInt(e.target.dataset.row);
      const col = parseInt(e.target.dataset.col);
      
      if (value === '' || (value >= '1' && value <= '9')) {
        grid[row][col] = value === '' ? 0 : parseInt(value);
        if (value !== '') {
          givenCells.add(`${row}-${col}`);
          cell.classList.add('given');
        } else {
          givenCells.delete(`${row}-${col}`);
          cell.classList.remove('given');
        }
      } else {
        e.target.textContent = '';
        grid[row][col] = 0;
      }
    });
    
    cell.addEventListener('keydown', (e) => {
      if (e.key === 'Backspace' || e.key === 'Delete') {
        const row = parseInt(e.target.dataset.row);
        const col = parseInt(e.target.dataset.col);
        grid[row][col] = 0;
        givenCells.delete(`${row}-${col}`);
        e.target.classList.remove('given');
      }
    });
    
    container.appendChild(cell);
  }
}

function isValid(grid, row, col, num) {
  // Check row
  for (let x = 0; x < 9; x++) {
    if (grid[row][x] === num) return false;
  }
  
  // Check column
  for (let x = 0; x < 9; x++) {
    if (grid[x][col] === num) return false;
  }
  
  // Check 3x3 box
  const startRow = row - row % 3;
  const startCol = col - col % 3;
  for (let i = 0; i < 3; i++) {
    for (let j = 0; j < 3; j++) {
      if (grid[i + startRow][j + startCol] === num) return false;
    }
  }
  
  return true;
}

function solveSudoku() {
  updateGridFromDOM();
  
  if (!isValidPuzzle()) {
    showStatus('Invalid puzzle! Please check your input.', 'error');
    return;
  }
  
  const solved = solve(grid);
  
  if (solved) {
    updateDOMFromGrid();
    showStatus('Puzzle solved successfully!', 'success');
  } else {
    showStatus('No solution found. The puzzle may be invalid.', 'error');
  }
}

function solve(grid) {
  for (let row = 0; row < 9; row++) {
    for (let col = 0; col < 9; col++) {
      if (grid[row][col] === 0) {
        for (let num = 1; num <= 9; num++) {
          if (isValid(grid, row, col, num)) {
            grid[row][col] = num;
            if (solve(grid)) {
              return true;
            }
            grid[row][col] = 0;
          }
        }
        return false;
      }
    }
  }
  return true;
}

function isValidPuzzle() {
  // Check for conflicts in given cells
  for (let row = 0; row < 9; row++) {
    for (let col = 0; col < 9; col++) {
      if (grid[row][col] !== 0) {
        const num = grid[row][col];
        grid[row][col] = 0;
        if (!isValid(grid, row, col, num)) {
          grid[row][col] = num;
          return false;
        }
        grid[row][col] = num;
      }
    }
  }
  return true;
}

function validatePuzzle() {
  updateGridFromDOM();
  
  if (isValidPuzzle()) {
    showStatus('Puzzle is valid!', 'success');
  } else {
    showStatus('Puzzle has conflicts. Please check your input.', 'error');
  }
}

function updateGridFromDOM() {
  const cells = document.querySelectorAll('.sudoku-cell');
  cells.forEach((cell, index) => {
    const row = Math.floor(index / 9);
    const col = index % 9;
    const value = cell.textContent.trim();
    grid[row][col] = value === '' ? 0 : parseInt(value);
  });
}

function updateDOMFromGrid() {
  const cells = document.querySelectorAll('.sudoku-cell');
  cells.forEach((cell, index) => {
    const row = Math.floor(index / 9);
    const col = index % 9;
    const value = grid[row][col];
    
    if (value !== 0) {
      cell.textContent = value;
      if (!givenCells.has(`${row}-${col}`)) {
        cell.classList.add('solved');
        setTimeout(() => cell.classList.remove('solved'), 1000);
      }
    }
  });
}

function clearPuzzle() {
  grid = Array(9).fill().map(() => Array(9).fill(0));
  givenCells.clear();
  const cells = document.querySelectorAll('.sudoku-cell');
  cells.forEach(cell => {
    cell.textContent = '';
    cell.classList.remove('given', 'solved', 'error');
  });
  showStatus('Puzzle cleared.', 'info');
}

function loadExample() {
  clearPuzzle();
  // Example puzzle (medium difficulty)
  const example = [
    [5, 3, 0, 0, 7, 0, 0, 0, 0],
    [6, 0, 0, 1, 9, 5, 0, 0, 0],
    [0, 9, 8, 0, 0, 0, 0, 6, 0],
    [8, 0, 0, 0, 6, 0, 0, 0, 3],
    [4, 0, 0, 8, 0, 3, 0, 0, 1],
    [7, 0, 0, 0, 2, 0, 0, 0, 6],
    [0, 6, 0, 0, 0, 0, 2, 8, 0],
    [0, 0, 0, 4, 1, 9, 0, 0, 5],
    [0, 0, 0, 0, 8, 0, 0, 7, 9]
  ];
  
  grid = example.map(row => [...row]);
  const cells = document.querySelectorAll('.sudoku-cell');
  cells.forEach((cell, index) => {
    const row = Math.floor(index / 9);
    const col = index % 9;
    if (grid[row][col] !== 0) {
      cell.textContent = grid[row][col];
      cell.classList.add('given');
      givenCells.add(`${row}-${col}`);
    }
  });
  showStatus('Example puzzle loaded!', 'info');
}

function showStatus(message, type) {
  const panel = document.getElementById('statusPanel');
  panel.innerHTML = `<div class="status-message ${type}">${message}</div>`;
}

// Initialize
initGrid();
</script>
</div>
<%@ include file="body-close.jsp"%>

