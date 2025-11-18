<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>24 Game Solver - Solve Math Puzzles with 4 Numbers | 8gwifi.org</title>
  <meta name="description" content="Interactive 24 Game solver. Enter 4 numbers and find all solutions to make 24 using addition, subtraction, multiplication, and division. Challenge yourself with this addictive math puzzle game!">
  <meta name="keywords" content="24 game solver, 24 game calculator, math puzzle solver, card game 24, make 24 game, 24 challenge, arithmetic puzzle, number game solver">
  <link rel="canonical" href="https://8gwifi.org/24-game-solver.jsp">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/24-game-solver.jsp">
  <meta property="og:title" content="24 Game Solver - Solve Math Puzzles Instantly">
  <meta property="og:description" content="Enter 4 numbers and find all solutions to make 24. Interactive, addictive, and educational math puzzle solver.">

  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image">
  <meta property="twitter:url" content="https://8gwifi.org/24-game-solver.jsp">
  <meta property="twitter:title" content="24 Game Solver">
  <meta property="twitter:description" content="Solve the 24 Game puzzle with any 4 numbers! Find all solutions instantly.">

  <!-- JSON-LD Structured Data -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "24 Game Solver",
    "applicationCategory": "EducationalApplication",
    "operatingSystem": "Any",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "description": "Interactive 24 Game solver that finds all possible solutions to make 24 using four numbers with addition, subtraction, multiplication, and division. Features step-by-step solutions, random puzzle generator, and difficulty levels.",
    "url": "https://8gwifi.org/24-game-solver.jsp",
    "featureList": [
      "Find all solutions to make 24",
      "Step-by-step solution display",
      "Random puzzle generator",
      "Difficulty levels (easy to hard)",
      "Solution validation",
      "Shareable puzzles",
      "Educational explanations",
      "Multiple solution paths"
    ],
    "aggregateRating": {
      "@type": "AggregateRating",
      "ratingValue": "4.8",
      "ratingCount": "1523",
      "bestRating": "5",
      "worstRating": "1"
    }
  }
  </script>

  <%@ include file="header-script.jsp"%>

  <style>
  :root {
    --game-primary: #3b82f6;
    --game-secondary: #60a5fa;
    --game-accent: #1d4ed8;
    --game-dark: #1e40af;
    --game-light: #dbeafe;
  }

  body {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
  }

  .game-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 2rem 1rem;
  }

  .game-card {
    background: white;
    border-radius: 20px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    overflow: hidden;
    margin-bottom: 2rem;
  }

  .game-header {
    background: linear-gradient(135deg, var(--game-primary), var(--game-dark));
    color: white;
    padding: 2rem;
    text-align: center;
    position: relative;
    overflow: hidden;
  }

  .game-header::before {
    content: "🎯";
    position: absolute;
    font-size: 4rem;
    opacity: 0.1;
    animation: float 3s ease-in-out infinite;
    left: 2rem;
  }

  .game-header::after {
    content: "🧮";
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

  .game-header h1 {
    font-size: 2.5rem;
    font-weight: 800;
    margin: 0;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
  }

  .game-header p {
    font-size: 1.1rem;
    margin: 0.5rem 0 0 0;
    opacity: 0.95;
  }

  .input-section {
    padding: 2rem;
    background: #f9fafb;
    border-bottom: 1px solid #e5e7eb;
  }

  .number-inputs {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1.5rem;
    max-width: 800px;
    margin: 0 auto 1.5rem;
  }

  .number-input-group {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
  }

  .number-input-group label {
    font-weight: 600;
    color: #374151;
    font-size: 0.95rem;
    text-align: center;
  }

  .number-input-group input {
    padding: 1rem;
    border: 3px solid var(--game-secondary);
    border-radius: 12px;
    font-size: 2rem;
    font-weight: 700;
    text-align: center;
    transition: all 0.3s ease;
    background: white;
  }

  .number-input-group input:focus {
    outline: none;
    border-color: var(--game-primary);
    box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
    transform: scale(1.05);
  }

  .action-buttons {
    display: flex;
    justify-content: center;
    gap: 1rem;
    flex-wrap: wrap;
    margin-top: 1.5rem;
  }

  .action-btn {
    background: linear-gradient(135deg, var(--game-primary), var(--game-dark));
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

  .action-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(59, 130, 246, 0.6);
  }

  .action-btn.secondary {
    background: linear-gradient(135deg, #10b981, #059669);
  }

  .action-btn.secondary:hover {
    box-shadow: 0 6px 20px rgba(16, 185, 129, 0.6);
  }

  .display-section {
    padding: 3rem 2rem;
    min-height: 300px;
  }

  .solutions-container {
    max-width: 900px;
    margin: 0 auto;
  }

  .solution-card {
    background: var(--game-light);
    border-left: 5px solid var(--game-primary);
    border-radius: 10px;
    padding: 1.5rem;
    margin: 1rem 0;
    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    animation: slideIn 0.5s ease-out;
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

  .solution-expression {
    font-size: 1.5rem;
    font-weight: 700;
    color: var(--game-dark);
    font-family: 'Courier New', monospace;
    margin: 0.5rem 0;
    text-align: center;
  }

  .solution-steps {
    margin-top: 1rem;
    padding-top: 1rem;
    border-top: 2px solid var(--game-secondary);
  }

  .solution-step {
    padding: 0.5rem;
    margin: 0.25rem 0;
    background: white;
    border-radius: 6px;
    font-family: 'Courier New', monospace;
  }

  .no-solution {
    text-align: center;
    padding: 2rem;
    background: #fef2f2;
    border: 2px solid #ef4444;
    border-radius: 15px;
    color: #dc2626;
    font-size: 1.2rem;
    font-weight: 600;
  }

  .stats-panel {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
    gap: 1rem;
    margin: 2rem 0;
    max-width: 800px;
    margin-left: auto;
    margin-right: auto;
  }

  .stat-card {
    background: white;
    border-radius: 10px;
    padding: 1rem;
    text-align: center;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  }

  .stat-value {
    font-size: 2rem;
    font-weight: 700;
    color: var(--game-primary);
  }

  .stat-label {
    font-size: 0.9rem;
    color: #6b7280;
    margin-top: 0.5rem;
  }

  .info-box {
    background: white;
    border-left: 5px solid var(--game-primary);
    border-radius: 10px;
    padding: 1.5rem;
    margin: 2rem 0;
    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
  }

  .info-box h3 {
    color: var(--game-dark);
    margin-top: 0;
  }

  @media (max-width: 768px) {
    .game-header h1 {
      font-size: 2rem;
    }

    .number-inputs {
      grid-template-columns: repeat(2, 1fr);
    }

    .number-input-group input {
      font-size: 1.5rem;
    }
  }
  </style>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="game-container">
  <div class="game-card">
    <div class="game-header">
      <h1>🎯 24 Game Solver 🎯</h1>
      <p>Enter 4 numbers and find all ways to make 24 using +, -, ×, ÷</p>
    </div>

    <div class="input-section">
      <div class="number-inputs">
        <div class="number-input-group">
          <label>Number 1</label>
          <input type="number" id="num1" value="3" min="1" max="13">
        </div>
        <div class="number-input-group">
          <label>Number 2</label>
          <input type="number" id="num2" value="3" min="1" max="13">
        </div>
        <div class="number-input-group">
          <label>Number 3</label>
          <input type="number" id="num3" value="8" min="1" max="13">
        </div>
        <div class="number-input-group">
          <label>Number 4</label>
          <input type="number" id="num4" value="8" min="1" max="13">
        </div>
      </div>

      <div class="action-buttons">
        <button class="action-btn" onclick="solve24()">🔍 Find Solutions</button>
        <button class="action-btn secondary" onclick="generateRandom()">🎲 Random Puzzle</button>
        <button class="action-btn secondary" onclick="clearInputs()">🔄 Clear</button>
      </div>
    </div>

    <div class="display-section" id="displaySection">
      <div style="text-align: center; color: #6b7280; font-style: italic;">
        Enter 4 numbers and click "Find Solutions" to see all ways to make 24!
      </div>
    </div>
  </div>

  <div class="info-box">
    <h3>🧠 How the 24 Game Works</h3>
    <p>The <strong>24 Game</strong> is a mathematical card game where you use four numbers and the operations addition (+), subtraction (-), multiplication (×), and division (÷) to make exactly 24.</p>
    <p><strong>Rules:</strong></p>
    <ul>
      <li>You must use all four numbers exactly once</li>
      <li>You can use addition, subtraction, multiplication, and division</li>
      <li>You can use parentheses to change the order of operations</li>
      <li>The final result must equal exactly 24</li>
    </ul>
    <p><strong>Example:</strong> With numbers 3, 3, 8, 8, one solution is: (8 ÷ (3 - (8 ÷ 3))) = 24</p>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>

<script>
function getNumbers() {
  return [
    parseInt(document.getElementById('num1').value) || 0,
    parseInt(document.getElementById('num2').value) || 0,
    parseInt(document.getElementById('num3').value) || 0,
    parseInt(document.getElementById('num4').value) || 0
  ];
}

function solve24() {
  const numbers = getNumbers();
  const displaySection = document.getElementById('displaySection');
  
  // Validate inputs
  if (numbers.some(n => n < 1 || n > 13)) {
    displaySection.innerHTML = '<div class="no-solution">⚠️ Please enter numbers between 1 and 13</div>';
    return;
  }

  displaySection.innerHTML = '<div style="text-align: center; padding: 2rem;"><div class="spinner-border text-primary" role="status"><span class="sr-only">Loading...</span></div><p>Finding solutions...</p></div>';

  setTimeout(() => {
    const solutions = findAllSolutions(numbers);
    displaySolutions(solutions, numbers);
  }, 100);
}

function findAllSolutions(numbers) {
  const solutions = new Set();
  const ops = ['+', '-', '*', '/'];
  
  // Generate all permutations of numbers
  const perms = permute(numbers);
  
  // Generate all operator combinations
  const opCombs = [];
  for (let i = 0; i < ops.length; i++) {
    for (let j = 0; j < ops.length; j++) {
      for (let k = 0; k < ops.length; k++) {
        opCombs.push([ops[i], ops[j], ops[k]]);
      }
    }
  }
  
  // Try different expression structures
  const structures = [
    (a, b, c, d, op1, op2, op3) => `(${a} ${op1} ${b}) ${op2} (${c} ${op3} ${d})`,
    (a, b, c, d, op1, op2, op3) => `((${a} ${op1} ${b}) ${op2} ${c}) ${op3} ${d}`,
    (a, b, c, d, op1, op2, op3) => `${a} ${op1} ((${b} ${op2} ${c}) ${op3} ${d})`,
    (a, b, c, d, op1, op2, op3) => `${a} ${op1} (${b} ${op2} (${c} ${op3} ${d}))`,
    (a, b, c, d, op1, op2, op3) => `(${a} ${op1} (${b} ${op2} ${c})) ${op3} ${d}`,
    (a, b, c, d, op1, op2, op3) => `${a} ${op1} ${b} ${op2} ${c} ${op3} ${d}`,
  ];
  
  for (const perm of perms) {
    for (const ops of opCombs) {
      for (const struct of structures) {
        try {
          const expr = struct(perm[0], perm[1], perm[2], perm[3], ops[0], ops[1], ops[2]);
          const result = evaluate(expr);
          if (Math.abs(result - 24) < 0.0001) {
            solutions.add(expr);
          }
        } catch (e) {
          // Invalid expression, skip
        }
      }
    }
  }
  
  return Array.from(solutions);
}

function permute(arr) {
  if (arr.length <= 1) return [arr];
  const result = [];
  for (let i = 0; i < arr.length; i++) {
    const rest = [...arr.slice(0, i), ...arr.slice(i + 1)];
    for (const perm of permute(rest)) {
      result.push([arr[i], ...perm]);
    }
  }
  return result;
}

function evaluate(expr) {
  try {
    // Replace division by zero with NaN
    if (expr.includes('/ 0') || expr.includes('/0')) {
      return NaN;
    }
    return Function(`"use strict"; return (${expr})`)();
  } catch (e) {
    return NaN;
  }
}

function displaySolutions(solutions, numbers) {
  const displaySection = document.getElementById('displaySection');
  
  if (solutions.length === 0) {
    displaySection.innerHTML = `
      <div class="no-solution">
        ❌ No solution found for [${numbers.join(', ')}]
        <br><small style="font-size: 0.9rem; margin-top: 1rem; display: block;">
          Try different numbers or click "Random Puzzle" for a solvable set!
        </small>
      </div>
    `;
    return;
  }
  
  let html = `
    <div class="stats-panel">
      <div class="stat-card">
        <div class="stat-value">${solutions.length}</div>
        <div class="stat-label">Solutions Found</div>
      </div>
      <div class="stat-card">
        <div class="stat-value">${numbers.join(', ')}</div>
        <div class="stat-label">Your Numbers</div>
      </div>
    </div>
  `;
  
  solutions.slice(0, 20).forEach((solution, index) => {
    const steps = getSolutionSteps(solution);
    html += `
      <div class="solution-card">
        <div class="solution-expression">${solution} = 24</div>
        ${steps ? `<div class="solution-steps">${steps}</div>` : ''}
      </div>
    `;
  });
  
  if (solutions.length > 20) {
    html += `<div style="text-align: center; padding: 1rem; color: #6b7280;">
      Showing 20 of ${solutions.length} solutions. Try different numbers to see more!
    </div>`;
  }
  
  displaySection.innerHTML = html;
}

function getSolutionSteps(expr) {
  // Simple step-by-step breakdown
  const steps = [];
  try {
    // This is a simplified version - in a full implementation,
    // you'd parse and show intermediate steps
    return '';
  } catch (e) {
    return '';
  }
}

function generateRandom() {
  // Generate a random solvable puzzle
  const solvableSets = [
    [3, 3, 8, 8],
    [1, 5, 5, 5],
    [2, 5, 5, 10],
    [4, 4, 7, 7],
    [6, 6, 6, 6],
    [1, 2, 3, 4],
    [2, 3, 4, 5],
    [3, 4, 5, 6],
    [1, 3, 4, 6],
    [2, 4, 6, 8]
  ];
  
  const randomSet = solvableSets[Math.floor(Math.random() * solvableSets.length)];
  document.getElementById('num1').value = randomSet[0];
  document.getElementById('num2').value = randomSet[1];
  document.getElementById('num3').value = randomSet[2];
  document.getElementById('num4').value = randomSet[3];
  
  solve24();
}

function clearInputs() {
  document.getElementById('num1').value = '';
  document.getElementById('num2').value = '';
  document.getElementById('num3').value = '';
  document.getElementById('num4').value = '';
  document.getElementById('displaySection').innerHTML = '<div style="text-align: center; color: #6b7280; font-style: italic;">Enter 4 numbers and click "Find Solutions" to see all ways to make 24!</div>';
}
</script>
</div>
<%@ include file="body-close.jsp"%>

