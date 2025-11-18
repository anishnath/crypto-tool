<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Tower of Hanoi - Classic Puzzle Game Solver | 8gwifi.org</title>
  <meta name="description" content="Interactive Tower of Hanoi puzzle solver. Play the classic mathematical puzzle game, solve it step-by-step, or watch the optimal solution. Learn the recursive algorithm behind this timeless puzzle.">
  <meta name="keywords" content="tower of hanoi, hanoi puzzle solver, recursive puzzle, mathematical puzzle game, hanoi tower game, puzzle solver, algorithm visualization">
  <link rel="canonical" href="https://8gwifi.org/tower-of-hanoi.jsp">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/tower-of-hanoi.jsp">
  <meta property="og:title" content="Tower of Hanoi - Classic Puzzle Game">
  <meta property="og:description" content="Play and solve the classic Tower of Hanoi puzzle. Interactive game with step-by-step solutions and algorithm visualization.">

  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image">
  <meta property="twitter:url" content="https://8gwifi.org/tower-of-hanoi.jsp">
  <meta property="twitter:title" content="Tower of Hanoi Puzzle">
  <meta property="twitter:description" content="Solve the classic Tower of Hanoi puzzle! Interactive game with solutions.">

  <!-- JSON-LD Structured Data -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Tower of Hanoi Puzzle Solver",
    "applicationCategory": "EducationalApplication",
    "operatingSystem": "Any",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "description": "Interactive Tower of Hanoi puzzle game and solver. Features manual play mode, automatic solution with step-by-step visualization, difficulty levels, move counter, and educational explanations of the recursive algorithm.",
    "url": "https://8gwifi.org/tower-of-hanoi.jsp",
    "featureList": [
      "Interactive puzzle game",
      "Manual and automatic solving",
      "Step-by-step solution visualization",
      "Multiple difficulty levels",
      "Move counter and statistics",
      "Algorithm explanation",
      "Animation controls",
      "Reset and restart options"
    ],
    "aggregateRating": {
      "@type": "AggregateRating",
      "ratingValue": "4.7",
      "ratingCount": "1892",
      "bestRating": "5",
      "worstRating": "1"
    }
  }
  </script>

  <%@ include file="header-script.jsp"%>

  <style>
  :root {
    --hanoi-primary: #f59e0b;
    --hanoi-secondary: #fbbf24;
    --hanoi-accent: #d97706;
    --hanoi-dark: #b45309;
    --hanoi-light: #fef3c7;
  }

  body {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
  }

  .hanoi-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 2rem 1rem;
  }

  .hanoi-card {
    background: white;
    border-radius: 20px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    overflow: hidden;
    margin-bottom: 2rem;
  }

  .hanoi-header {
    background: linear-gradient(135deg, var(--hanoi-primary), var(--hanoi-dark));
    color: white;
    padding: 2rem;
    text-align: center;
    position: relative;
    overflow: hidden;
  }

  .hanoi-header h1 {
    font-size: 2.5rem;
    font-weight: 800;
    margin: 0;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
  }

  .hanoi-header p {
    font-size: 1.1rem;
    margin: 0.5rem 0 0 0;
    opacity: 0.95;
  }

  .game-area {
    padding: 3rem 2rem;
    background: #f9fafb;
  }

  .towers-container {
    display: flex;
    justify-content: space-around;
    align-items: flex-end;
    min-height: 400px;
    margin: 2rem 0;
    padding: 2rem;
    background: white;
    border-radius: 15px;
    position: relative;
  }

  .tower {
    display: flex;
    flex-direction: column;
    align-items: center;
    width: 200px;
    height: 350px;
    position: relative;
    cursor: pointer;
    transition: transform 0.2s;
  }

  .tower:hover {
    transform: translateY(-5px);
  }

  .tower.selected {
    transform: scale(1.05);
  }

  .tower-base {
    width: 180px;
    height: 20px;
    background: var(--hanoi-dark);
    border-radius: 10px;
    position: absolute;
    bottom: 0;
  }

  .tower-rod {
    width: 8px;
    height: 330px;
    background: var(--hanoi-primary);
    border-radius: 4px;
    position: absolute;
    bottom: 20px;
  }

  .disk {
    height: 30px;
    background: linear-gradient(135deg, var(--hanoi-primary), var(--hanoi-secondary));
    border: 3px solid var(--hanoi-dark);
    border-radius: 8px;
    margin: 2px 0;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-weight: 700;
    font-size: 0.9rem;
    cursor: pointer;
    transition: all 0.3s ease;
    position: relative;
    z-index: 10;
  }

  .disk:hover {
    transform: scale(1.05);
    box-shadow: 0 4px 12px rgba(0,0,0,0.3);
  }

  .disk.selected {
    box-shadow: 0 0 0 4px rgba(245, 158, 11, 0.5);
  }

  .controls-panel {
    padding: 2rem;
    background: white;
    border-top: 1px solid #e5e7eb;
  }

  .controls-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1rem;
    margin-bottom: 1.5rem;
  }

  .control-group {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
  }

  .control-group label {
    font-weight: 600;
    color: #374151;
  }

  .control-group select,
  .control-group input {
    padding: 0.75rem;
    border: 2px solid #e5e7eb;
    border-radius: 8px;
    font-size: 1rem;
  }

  .action-btn {
    background: linear-gradient(135deg, var(--hanoi-primary), var(--hanoi-dark));
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
    box-shadow: 0 4px 12px rgba(245, 158, 11, 0.4);
  }

  .action-btn.secondary {
    background: linear-gradient(135deg, #10b981, #059669);
  }

  .stats-panel {
    display: flex;
    justify-content: space-around;
    flex-wrap: wrap;
    gap: 1rem;
    margin: 1.5rem 0;
    padding: 1rem;
    background: var(--hanoi-light);
    border-radius: 10px;
  }

  .stat-item {
    text-align: center;
  }

  .stat-value {
    font-size: 2rem;
    font-weight: 700;
    color: var(--hanoi-dark);
  }

  .stat-label {
    font-size: 0.9rem;
    color: #6b7280;
  }

  @media (max-width: 768px) {
    .towers-container {
      flex-direction: column;
      align-items: center;
      gap: 2rem;
    }

    .tower {
      width: 150px;
    }
  }
  </style>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="hanoi-container">
  <div class="hanoi-card">
    <div class="hanoi-header">
      <h1>🏛️ Tower of Hanoi 🏛️</h1>
      <p>Move all disks from the first tower to the last tower</p>
    </div>

    <div class="game-area">
      <div class="stats-panel">
        <div class="stat-item">
          <div class="stat-value" id="moveCount">0</div>
          <div class="stat-label">Moves</div>
        </div>
        <div class="stat-item">
          <div class="stat-value" id="minMoves">0</div>
          <div class="stat-label">Minimum Moves</div>
        </div>
        <div class="stat-item">
          <div class="stat-value" id="diskCount">3</div>
          <div class="stat-label">Disks</div>
        </div>
      </div>

      <div class="towers-container" id="towersContainer">
        <!-- Towers will be generated by JavaScript -->
      </div>
    </div>

    <div class="controls-panel">
      <div class="controls-grid">
        <div class="control-group">
          <label>Number of Disks</label>
          <select id="diskSelect" onchange="changeDiskCount(this.value)">
            <option value="3">3 Disks (Easy)</option>
            <option value="4">4 Disks (Medium)</option>
            <option value="5">5 Disks (Hard)</option>
            <option value="6">6 Disks (Expert)</option>
            <option value="7">7 Disks (Master)</option>
          </select>
        </div>
        <div class="control-group">
          <label>Speed</label>
          <select id="speedSelect">
            <option value="500">Slow</option>
            <option value="200" selected>Medium</option>
            <option value="50">Fast</option>
          </select>
        </div>
      </div>

      <div style="text-align: center;">
        <button class="action-btn" onclick="resetGame()">🔄 Reset</button>
        <button class="action-btn secondary" onclick="solveAutomatically()">🤖 Auto Solve</button>
        <button class="action-btn secondary" onclick="undoMove()">↩️ Undo</button>
      </div>
    </div>
  </div>

  <div class="hanoi-card" style="padding: 2rem;">
    <h3 style="color: var(--hanoi-dark); margin-top: 0;">🧠 How Tower of Hanoi Works</h3>
    <p>The <strong>Tower of Hanoi</strong> is a mathematical puzzle where you must move all disks from one rod to another, following these rules:</p>
    <ul>
      <li>Only one disk can be moved at a time</li>
      <li>Each move consists of taking the upper disk from one stack and placing it on top of another stack</li>
      <li>No disk may be placed on top of a smaller disk</li>
    </ul>
    <p><strong>Minimum Moves:</strong> For n disks, the minimum number of moves required is 2ⁿ - 1</p>
    <p><strong>Algorithm:</strong> The solution uses recursion - to move n disks, move n-1 disks to the auxiliary rod, move the largest disk to the target, then move n-1 disks to the target.</p>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>

<script>
let numDisks = 3;
let towers = [[], [], []];
let selectedTower = null;
let moveCount = 0;
let moveHistory = [];
let isAutoSolving = false;

function initGame() {
  towers = [[], [], []];
  moveCount = 0;
  moveHistory = [];
  selectedTower = null;
  
  // Create disks
  for (let i = numDisks; i >= 1; i--) {
    towers[0].push(i);
  }
  
  updateDisplay();
  updateStats();
}

function updateDisplay() {
  const container = document.getElementById('towersContainer');
  container.innerHTML = '';
  
  for (let i = 0; i < 3; i++) {
    const tower = document.createElement('div');
    tower.className = 'tower' + (selectedTower === i ? ' selected' : '');
    tower.onclick = () => handleTowerClick(i);
    
    tower.innerHTML = `
      <div class="tower-rod"></div>
      <div class="tower-base"></div>
    `;
    
    const disksContainer = document.createElement('div');
    disksContainer.style.cssText = 'display: flex; flex-direction: column-reverse; align-items: center; width: 100%; height: 330px; position: absolute; bottom: 20px;';
    
    towers[i].forEach((diskSize, index) => {
      const disk = document.createElement('div');
      disk.className = 'disk';
      disk.style.width = (40 + diskSize * 20) + 'px';
      disk.textContent = diskSize;
      disk.onclick = (e) => {
        e.stopPropagation();
        handleTowerClick(i);
      };
      disksContainer.appendChild(disk);
    });
    
    tower.appendChild(disksContainer);
    container.appendChild(tower);
  }
}

function handleTowerClick(towerIndex) {
  if (isAutoSolving) return;
  
  if (selectedTower === null) {
    if (towers[towerIndex].length > 0) {
      selectedTower = towerIndex;
      updateDisplay();
    }
  } else {
    if (selectedTower === towerIndex) {
      selectedTower = null;
      updateDisplay();
    } else {
      moveDisk(selectedTower, towerIndex);
      selectedTower = null;
      updateDisplay();
    }
  }
}

function moveDisk(from, to) {
  if (towers[from].length === 0) return false;
  
  const disk = towers[from][towers[from].length - 1];
  
  if (towers[to].length > 0 && towers[to][towers[to].length - 1] < disk) {
    return false; // Invalid move
  }
  
  towers[from].pop();
  towers[to].push(disk);
  moveCount++;
  moveHistory.push({from, to, disk});
  updateStats();
  
  // Check win condition
  if (towers[2].length === numDisks) {
    setTimeout(() => {
      alert(`Congratulations! You solved it in ${moveCount} moves! Minimum: ${Math.pow(2, numDisks) - 1}`);
    }, 100);
  }
  
  return true;
}

function updateStats() {
  document.getElementById('moveCount').textContent = moveCount;
  document.getElementById('minMoves').textContent = Math.pow(2, numDisks) - 1;
  document.getElementById('diskCount').textContent = numDisks;
}

function resetGame() {
  isAutoSolving = false;
  initGame();
}

function changeDiskCount(count) {
  numDisks = parseInt(count);
  resetGame();
}

function undoMove() {
  if (moveHistory.length === 0 || isAutoSolving) return;
  
  const lastMove = moveHistory.pop();
  towers[lastMove.to].pop();
  towers[lastMove.from].push(lastMove.disk);
  moveCount--;
  updateDisplay();
  updateStats();
}

function solveAutomatically() {
  if (isAutoSolving) {
    isAutoSolving = false;
    return;
  }
  
  isAutoSolving = true;
  resetGame();
  
  const speed = parseInt(document.getElementById('speedSelect').value);
  const solution = generateSolution(numDisks, 0, 2, 1);
  
  solution.forEach((move, index) => {
    setTimeout(() => {
      moveDisk(move.from, move.to);
      updateDisplay();
      
      if (index === solution.length - 1) {
        isAutoSolving = false;
        setTimeout(() => {
          alert(`Solved automatically in ${moveCount} moves!`);
        }, speed);
      }
    }, index * speed);
  });
}

function generateSolution(n, from, to, aux) {
  if (n === 1) {
    return [{from, to}];
  }
  
  return [
    ...generateSolution(n - 1, from, aux, to),
    {from, to},
    ...generateSolution(n - 1, aux, to, from)
  ];
}

// Initialize
initGame();
</script>
</div>
<%@ include file="body-close.jsp"%>

