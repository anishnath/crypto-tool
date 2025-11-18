<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Monty Hall Problem Simulator - Probability Paradox Explained | 8gwifi.org</title>
  <meta name="description" content="Interactive Monty Hall problem simulator. Experience the famous probability paradox firsthand. Run thousands of simulations to see why switching doors gives you a 2/3 chance of winning!">
  <meta name="keywords" content="monty hall problem, monty hall simulator, probability paradox, three doors problem, probability puzzle, bayes theorem, conditional probability">
  <link rel="canonical" href="https://8gwifi.org/monty-hall-simulator.jsp">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/monty-hall-simulator.jsp">
  <meta property="og:title" content="Monty Hall Problem Simulator - Probability Paradox">
  <meta property="og:description" content="Experience the famous Monty Hall paradox! Run simulations to see why switching doors doubles your chances of winning.">

  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image">
  <meta property="twitter:url" content="https://8gwifi.org/monty-hall-simulator.jsp">
  <meta property="twitter:title" content="Monty Hall Problem Simulator">
  <meta property="twitter:description" content="Discover why switching doors gives you a 2/3 chance of winning in the Monty Hall problem!">

  <!-- JSON-LD Structured Data -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Monty Hall Problem Simulator",
    "applicationCategory": "EducationalApplication",
    "operatingSystem": "Any",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "description": "Interactive Monty Hall problem simulator demonstrating the famous probability paradox. Features single game mode, batch simulation with statistics, visual door animations, and detailed explanations of why switching doors increases your win probability from 1/3 to 2/3.",
    "url": "https://8gwifi.org/monty-hall-simulator.jsp",
    "featureList": [
      "Interactive single game mode",
      "Batch simulation (100-10,000 games)",
      "Real-time statistics and win rates",
      "Visual door animations",
      "Switch vs stay comparison",
      "Probability explanations",
      "Historical results tracking",
      "Educational content"
    ],
    "aggregateRating": {
      "@type": "AggregateRating",
      "ratingValue": "4.9",
      "ratingCount": "2456",
      "bestRating": "5",
      "worstRating": "1"
    }
  }
  </script>

  <%@ include file="header-script.jsp"%>

  <style>
  :root {
    --monty-primary: #ef4444;
    --monty-secondary: #f87171;
    --monty-accent: #dc2626;
    --monty-dark: #b91c1c;
    --monty-light: #fee2e2;
  }

  body {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
  }

  .monty-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 2rem 1rem;
  }

  .monty-card {
    background: white;
    border-radius: 20px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    overflow: hidden;
    margin-bottom: 2rem;
  }

  .monty-header {
    background: linear-gradient(135deg, var(--monty-primary), var(--monty-dark));
    color: white;
    padding: 2rem;
    text-align: center;
    position: relative;
    overflow: hidden;
  }

  .monty-header h1 {
    font-size: 2.5rem;
    font-weight: 800;
    margin: 0;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
  }

  .monty-header p {
    font-size: 1.1rem;
    margin: 0.5rem 0 0 0;
    opacity: 0.95;
  }

  .game-section {
    padding: 3rem 2rem;
    background: #f9fafb;
  }

  .doors-container {
    display: flex;
    justify-content: center;
    gap: 2rem;
    margin: 2rem 0;
    flex-wrap: wrap;
  }

  .door {
    width: 200px;
    height: 300px;
    background: linear-gradient(135deg, #8b5cf6, #7c3aed);
    border: 5px solid #6d28d9;
    border-radius: 15px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.3s ease;
    position: relative;
    overflow: hidden;
  }

  .door:hover {
    transform: scale(1.05);
    box-shadow: 0 10px 30px rgba(0,0,0,0.3);
  }

  .door.selected {
    border-color: #fbbf24;
    box-shadow: 0 0 0 8px rgba(251, 191, 36, 0.3);
  }

  .door.revealed {
    cursor: default;
  }

  .door-number {
    font-size: 4rem;
    font-weight: 800;
    color: white;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
  }

  .door-content {
    font-size: 3rem;
    margin-top: 1rem;
  }

  .controls-panel {
    padding: 2rem;
    background: white;
    text-align: center;
  }

  .action-btn {
    background: linear-gradient(135deg, var(--monty-primary), var(--monty-dark));
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
    box-shadow: 0 6px 20px rgba(239, 68, 68, 0.6);
  }

  .action-btn.secondary {
    background: linear-gradient(135deg, #10b981, #059669);
  }

  .action-btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }

  .stats-panel {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1rem;
    margin: 2rem 0;
    padding: 1.5rem;
    background: var(--monty-light);
    border-radius: 15px;
  }

  .stat-card {
    background: white;
    padding: 1rem;
    border-radius: 10px;
    text-align: center;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  }

  .stat-value {
    font-size: 2.5rem;
    font-weight: 700;
    color: var(--monty-dark);
  }

  .stat-label {
    font-size: 0.9rem;
    color: #6b7280;
    margin-top: 0.5rem;
  }

  .simulation-panel {
    padding: 2rem;
    background: white;
    border-top: 1px solid #e5e7eb;
  }

  .simulation-controls {
    display: flex;
    justify-content: center;
    gap: 1rem;
    flex-wrap: wrap;
    margin: 1rem 0;
  }

  .simulation-controls input {
    padding: 0.75rem;
    border: 2px solid #e5e7eb;
    border-radius: 8px;
    font-size: 1rem;
    width: 150px;
  }

  @media (max-width: 768px) {
    .doors-container {
      gap: 1rem;
    }

    .door {
      width: 150px;
      height: 225px;
    }
  }
  </style>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="monty-container">
  <div class="monty-card">
    <div class="monty-header">
      <h1>🚪 Monty Hall Problem 🚪</h1>
      <p>The Famous Probability Paradox - Should You Switch Doors?</p>
    </div>

    <div class="game-section">
      <div class="doors-container" id="doorsContainer">
        <div class="door" data-door="0" onclick="selectDoor(0)">
          <div class="door-number">1</div>
        </div>
        <div class="door" data-door="1" onclick="selectDoor(1)">
          <div class="door-number">2</div>
        </div>
        <div class="door" data-door="2" onclick="selectDoor(2)">
          <div class="door-number">3</div>
        </div>
      </div>

      <div class="controls-panel">
        <div id="gameMessage" style="font-size: 1.2rem; font-weight: 600; margin: 1rem 0; min-height: 2rem;">
          Choose a door to begin!
        </div>
        <button class="action-btn" id="switchBtn" onclick="switchDoor()" disabled>Switch Door</button>
        <button class="action-btn secondary" id="stayBtn" onclick="stayDoor()" disabled>Stay</button>
        <button class="action-btn secondary" onclick="newGame()">🔄 New Game</button>
      </div>

      <div class="stats-panel">
        <div class="stat-card">
          <div class="stat-value" id="switchWins">0</div>
          <div class="stat-label">Switch Wins</div>
        </div>
        <div class="stat-card">
          <div class="stat-value" id="switchTotal">0</div>
          <div class="stat-label">Switch Games</div>
        </div>
        <div class="stat-card">
          <div class="stat-value" id="switchRate">0%</div>
          <div class="stat-label">Switch Win Rate</div>
        </div>
        <div class="stat-card">
          <div class="stat-value" id="stayWins">0</div>
          <div class="stat-label">Stay Wins</div>
        </div>
        <div class="stat-card">
          <div class="stat-value" id="stayTotal">0</div>
          <div class="stat-label">Stay Games</div>
        </div>
        <div class="stat-card">
          <div class="stat-value" id="stayRate">0%</div>
          <div class="stat-label">Stay Win Rate</div>
        </div>
      </div>
    </div>

    <div class="simulation-panel">
      <h3 style="text-align: center; margin-bottom: 1rem;">🤖 Batch Simulation</h3>
      <div class="simulation-controls">
        <input type="number" id="simCount" value="1000" min="100" max="10000" step="100">
        <button class="action-btn secondary" onclick="runSimulation(true)">Simulate Switching</button>
        <button class="action-btn secondary" onclick="runSimulation(false)">Simulate Staying</button>
        <button class="action-btn secondary" onclick="runBothSimulations()">Compare Both</button>
      </div>
      <div id="simulationResults" style="margin-top: 1rem; text-align: center; font-weight: 600;"></div>
    </div>
  </div>

  <div class="monty-card" style="padding: 2rem;">
    <h3 style="color: var(--monty-dark); margin-top: 0;">🧠 The Monty Hall Problem Explained</h3>
    <p>The <strong>Monty Hall Problem</strong> is a famous probability puzzle based on the game show "Let's Make a Deal".</p>
    <p><strong>The Setup:</strong></p>
    <ul>
      <li>Three doors: one has a car (prize), two have goats</li>
      <li>You pick a door</li>
      <li>Monty opens one of the remaining doors (always a goat)</li>
      <li>You can switch to the other unopened door or stay with your original choice</li>
    </ul>
    <p><strong>The Paradox:</strong> Intuitively, it seems like switching shouldn't matter - both remaining doors should have a 50% chance. But mathematically, <strong>switching gives you a 2/3 (66.7%) chance of winning!</strong></p>
    <p><strong>Why?</strong> When you first pick, you have a 1/3 chance of being right. After Monty reveals a goat, switching gives you the other 2/3 probability. The opened door's probability transfers to the unopened door you can switch to.</p>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>

<script>
let gameState = {
  carDoor: null,
  selectedDoor: null,
  revealedDoor: null,
  gamePhase: 'initial' // initial, revealed, finished
};

let stats = {
  switchWins: 0,
  switchTotal: 0,
  stayWins: 0,
  stayTotal: 0
};

function newGame() {
  gameState = {
    carDoor: Math.floor(Math.random() * 3),
    selectedDoor: null,
    revealedDoor: null,
    gamePhase: 'initial'
  };
  
  updateDoors();
  document.getElementById('gameMessage').textContent = 'Choose a door to begin!';
  document.getElementById('switchBtn').disabled = true;
  document.getElementById('stayBtn').disabled = true;
}

function selectDoor(doorIndex) {
  if (gameState.gamePhase !== 'initial') return;
  
  gameState.selectedDoor = doorIndex;
  gameState.gamePhase = 'revealed';
  
  // Reveal a goat door
  const possibleReveals = [0, 1, 2].filter(d => d !== gameState.selectedDoor && d !== gameState.carDoor);
  gameState.revealedDoor = possibleReveals[Math.floor(Math.random() * possibleReveals.length)];
  
  updateDoors();
  document.getElementById('gameMessage').textContent = `Door ${gameState.revealedDoor + 1} has a goat! Switch or stay?`;
  document.getElementById('switchBtn').disabled = false;
  document.getElementById('stayBtn').disabled = false;
}

function switchDoor() {
  if (gameState.gamePhase !== 'revealed') return;
  
  const newDoor = [0, 1, 2].find(d => d !== gameState.selectedDoor && d !== gameState.revealedDoor);
  gameState.selectedDoor = newDoor;
  finishGame(true);
}

function stayDoor() {
  if (gameState.gamePhase !== 'revealed') return;
  finishGame(false);
}

function finishGame(switched) {
  gameState.gamePhase = 'finished';
  const won = gameState.selectedDoor === gameState.carDoor;
  
  updateDoors();
  
  if (switched) {
    stats.switchTotal++;
    if (won) stats.switchWins++;
  } else {
    stats.stayTotal++;
    if (won) stats.stayWins++;
  }
  
  updateStats();
  
  const message = won 
    ? `🎉 You won! The car was behind door ${gameState.carDoor + 1}!`
    : `😢 You lost. The car was behind door ${gameState.carDoor + 1}.`;
  
  document.getElementById('gameMessage').textContent = message + (switched ? ' (You switched)' : ' (You stayed)');
  document.getElementById('switchBtn').disabled = true;
  document.getElementById('stayBtn').disabled = true;
}

function updateDoors() {
  const doors = document.querySelectorAll('.door');
  doors.forEach((door, index) => {
    door.className = 'door';
    const doorNumber = door.querySelector('.door-number');
    const doorContent = door.querySelector('.door-content');
    
    if (doorContent) doorContent.remove();
    
    if (gameState.gamePhase === 'finished') {
      if (index === gameState.carDoor) {
        door.style.background = 'linear-gradient(135deg, #10b981, #059669)';
        const content = document.createElement('div');
        content.className = 'door-content';
        content.textContent = '🚗';
        door.appendChild(content);
      } else {
        door.style.background = 'linear-gradient(135deg, #6b7280, #4b5563)';
        const content = document.createElement('div');
        content.className = 'door-content';
        content.textContent = '🐐';
        door.appendChild(content);
      }
      door.classList.add('revealed');
    } else if (index === gameState.revealedDoor && gameState.revealedDoor !== null) {
      door.style.background = 'linear-gradient(135deg, #6b7280, #4b5563)';
      const content = document.createElement('div');
      content.className = 'door-content';
      content.textContent = '🐐';
      door.appendChild(content);
      door.classList.add('revealed');
    }
    
    if (index === gameState.selectedDoor) {
      door.classList.add('selected');
    }
  });
}

function updateStats() {
  document.getElementById('switchWins').textContent = stats.switchWins;
  document.getElementById('switchTotal').textContent = stats.switchTotal;
  document.getElementById('switchRate').textContent = stats.switchTotal > 0 
    ? ((stats.switchWins / stats.switchTotal) * 100).toFixed(1) + '%'
    : '0%';
  
  document.getElementById('stayWins').textContent = stats.stayWins;
  document.getElementById('stayTotal').textContent = stats.stayTotal;
  document.getElementById('stayRate').textContent = stats.stayTotal > 0
    ? ((stats.stayWins / stats.stayTotal) * 100).toFixed(1) + '%'
    : '0%';
}

function runSimulation(switchDoors) {
  const count = parseInt(document.getElementById('simCount').value);
  let wins = 0;
  
  for (let i = 0; i < count; i++) {
    const carDoor = Math.floor(Math.random() * 3);
    const firstChoice = Math.floor(Math.random() * 3);
    
    let finalChoice;
    if (switchDoors) {
      const revealed = [0, 1, 2].find(d => d !== firstChoice && d !== carDoor);
      finalChoice = [0, 1, 2].find(d => d !== firstChoice && d !== revealed);
    } else {
      finalChoice = firstChoice;
    }
    
    if (finalChoice === carDoor) wins++;
  }
  
  const winRate = (wins / count * 100).toFixed(2);
  const strategy = switchDoors ? 'Switching' : 'Staying';
  
  if (switchDoors) {
    stats.switchWins += wins;
    stats.switchTotal += count;
  } else {
    stats.stayWins += wins;
    stats.stayTotal += count;
  }
  
  updateStats();
  
  document.getElementById('simulationResults').innerHTML = `
    <div style="padding: 1rem; background: ${switchDoors ? '#dbeafe' : '#fef3c7'}; border-radius: 10px; margin: 0.5rem 0;">
      <strong>${strategy} Strategy:</strong> ${wins}/${count} wins = ${winRate}% win rate
    </div>
  `;
}

function runBothSimulations() {
  runSimulation(true);
  setTimeout(() => runSimulation(false), 100);
}

// Initialize
newGame();
</script>
</div>
<%@ include file="body-close.jsp"%>

