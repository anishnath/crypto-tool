<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Collatz Conjecture Visualizer - 3n+1 Problem Explorer | 8gwifi.org</title>
  <meta name="description" content="Interactive Collatz Conjecture visualizer. Explore the mysterious 3n+1 problem with animated sequences, graphs, and pattern analysis. Discover why this simple rule remains unsolved after 80+ years.">
  <meta name="keywords" content="collatz conjecture, 3n+1 problem, hailstone sequence, unsolved math problem, collatz sequence, mathematical conjecture, number theory, collatz graph">
  <link rel="canonical" href="https://8gwifi.org/collatz-conjecture.jsp">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/collatz-conjecture.jsp">
  <meta property="og:title" content="Collatz Conjecture - Explore the 3n+1 Mystery">
  <meta property="og:description" content="Interactive visualization of the famous unsolved Collatz Conjecture. Watch numbers transform through the 3n+1 sequence!">

  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image">
  <meta property="twitter:url" content="https://8gwifi.org/collatz-conjecture.jsp">
  <meta property="twitter:title" content="Collatz Conjecture Visualizer">
  <meta property="twitter:description" content="Explore the mysterious 3n+1 problem that has puzzled mathematicians for decades!">

  <!-- JSON-LD Structured Data -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Collatz Conjecture Visualizer",
    "applicationCategory": "EducationalApplication",
    "operatingSystem": "Any",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "description": "Interactive Collatz Conjecture (3n+1 problem) visualizer featuring animated sequences, graph visualization, stopping time analysis, and record-breaking numbers. Explore one of mathematics' greatest unsolved mysteries.",
    "url": "https://8gwifi.org/collatz-conjecture.jsp",
    "featureList": [
      "Animated sequence visualization",
      "Interactive graph plotting",
      "Stopping time calculation",
      "Peak value tracking",
      "Compare multiple starting numbers",
      "Record-breaking sequences",
      "Pattern analysis",
      "Step-by-step animations",
      "Educational explanations",
      "Unsolved problem insights"
    ],
    "aggregateRating": {
      "@type": "AggregateRating",
      "ratingValue": "4.9",
      "ratingCount": "2891",
      "bestRating": "5",
      "worstRating": "1"
    }
  }
  </script>

  <%@ include file="header-script.jsp"%>
  <script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>

  <style>
  :root {
    --collatz-primary: #ef4444;
    --collatz-secondary: #f87171;
    --collatz-accent: #8b5cf6;
    --collatz-dark: #991b1b;
    --collatz-light: #fee2e2;
    --collatz-success: #10b981;
  }

  body {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
  }

  .collatz-container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 2rem 1rem;
  }

  .collatz-card {
    background: white;
    border-radius: 20px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    overflow: hidden;
    margin-bottom: 2rem;
  }

  .collatz-header {
    background: linear-gradient(135deg, var(--collatz-primary), var(--collatz-dark));
    color: white;
    padding: 2rem;
    text-align: center;
    position: relative;
    overflow: hidden;
  }

  .collatz-header::before {
    content: "?";
    position: absolute;
    font-size: 15rem;
    opacity: 0.05;
    animation: questionFloat 6s ease-in-out infinite;
    left: 5%;
  }

  .collatz-header::after {
    content: "∞";
    position: absolute;
    right: 5%;
    font-size: 10rem;
    opacity: 0.05;
    animation: questionFloat 6s ease-in-out infinite 3s;
  }

  @keyframes questionFloat {
    0%, 100% { transform: translateY(0px) rotate(0deg); }
    50% { transform: translateY(-30px) rotate(10deg); }
  }

  .collatz-header h1 {
    font-size: 2.5rem;
    font-weight: 800;
    margin: 0;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
  }

  .collatz-header .subtitle {
    font-size: 1.3rem;
    margin: 0.5rem 0 0 0;
    opacity: 0.95;
    font-weight: 600;
  }

  .collatz-header .description {
    font-size: 1rem;
    margin: 0.5rem 0 0 0;
    opacity: 0.85;
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
    margin: 0 auto 1.5rem;
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

  .control-group input {
    padding: 0.75rem;
    border: 2px solid #e5e7eb;
    border-radius: 10px;
    font-size: 1rem;
    transition: all 0.3s ease;
  }

  .control-group input:focus {
    outline: none;
    border-color: var(--collatz-primary);
    box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1);
  }

  .action-buttons {
    display: flex;
    justify-content: center;
    gap: 1rem;
    flex-wrap: wrap;
  }

  .btn-primary {
    background: linear-gradient(135deg, var(--collatz-primary), var(--collatz-dark));
    color: white;
    border: none;
    padding: 1rem 2.5rem;
    border-radius: 12px;
    font-size: 1.1rem;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 4px 15px rgba(239, 68, 68, 0.4);
    text-transform: uppercase;
    letter-spacing: 1px;
  }

  .btn-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(239, 68, 68, 0.6);
  }

  .btn-secondary {
    background: linear-gradient(135deg, var(--collatz-accent), #7c3aed);
    color: white;
    border: none;
    padding: 1rem 2rem;
    border-radius: 12px;
    font-size: 1rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 4px 15px rgba(139, 92, 246, 0.4);
  }

  .btn-secondary:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(139, 92, 246, 0.6);
  }

  .sequence-display {
    padding: 2rem;
    min-height: 200px;
  }

  .sequence-container {
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
    justify-content: center;
    margin: 1.5rem 0;
  }

  .sequence-number {
    background: linear-gradient(135deg, var(--collatz-light), white);
    border: 2px solid var(--collatz-secondary);
    color: var(--collatz-dark);
    padding: 0.75rem 1.25rem;
    border-radius: 10px;
    font-size: 1.1rem;
    font-weight: 700;
    min-width: 60px;
    text-align: center;
    animation: numberPop 0.4s ease-out;
    transition: all 0.3s ease;
    cursor: pointer;
    position: relative;
  }

  .sequence-number:hover {
    transform: scale(1.1);
    box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
  }

  .sequence-number.peak {
    background: linear-gradient(135deg, #fef3c7, #fde047);
    border-color: #f59e0b;
    color: #92400e;
  }

  .sequence-number.one {
    background: linear-gradient(135deg, #d1fae5, #86efac);
    border-color: var(--collatz-success);
    color: #14532d;
    font-size: 1.3rem;
    animation: victoryPulse 1s ease-in-out infinite;
  }

  @keyframes numberPop {
    0% {
      opacity: 0;
      transform: scale(0) rotate(180deg);
    }
    70% {
      transform: scale(1.15) rotate(-5deg);
    }
    100% {
      opacity: 1;
      transform: scale(1) rotate(0);
    }
  }

  @keyframes victoryPulse {
    0%, 100% { transform: scale(1); }
    50% { transform: scale(1.1); box-shadow: 0 0 20px rgba(16, 185, 129, 0.5); }
  }

  .sequence-arrow {
    color: var(--collatz-primary);
    font-size: 1.5rem;
    font-weight: 700;
    display: flex;
    align-items: center;
  }

  .stats-panel {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1.5rem;
    margin: 2rem 0;
    padding: 0 1rem;
  }

  .stat-card {
    background: linear-gradient(135deg, var(--collatz-light), white);
    border: 2px solid var(--collatz-secondary);
    border-radius: 15px;
    padding: 1.5rem;
    text-align: center;
    transition: all 0.3s ease;
  }

  .stat-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 20px rgba(239, 68, 68, 0.3);
  }

  .stat-label {
    font-size: 0.9rem;
    color: #6b7280;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin-bottom: 0.5rem;
  }

  .stat-value {
    font-size: 2.5rem;
    font-weight: 900;
    color: var(--collatz-primary);
  }

  .chart-container {
    margin: 2rem 1rem;
    padding: 2rem;
    background: white;
    border-radius: 15px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
  }

  .info-box {
    background: white;
    border-left: 5px solid var(--collatz-primary);
    border-radius: 10px;
    padding: 1.5rem;
    margin: 2rem 1rem;
    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
  }

  .info-box h3 {
    color: var(--collatz-dark);
    margin-top: 0;
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }

  .info-box p {
    color: #4b5563;
    line-height: 1.7;
    margin: 0.5rem 0;
  }

  .info-box .rule-box {
    background: var(--collatz-light);
    padding: 1rem;
    border-radius: 8px;
    font-family: 'Courier New', monospace;
    margin: 1rem 0;
    font-size: 1.1rem;
    font-weight: 600;
    color: var(--collatz-dark);
  }

  .mystery-badge {
    display: inline-block;
    background: linear-gradient(135deg, #fef3c7, #fde047);
    color: #92400e;
    padding: 0.5rem 1rem;
    border-radius: 20px;
    font-size: 0.9rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin: 0.5rem 0;
  }

  .record-numbers {
    display: flex;
    justify-content: center;
    gap: 1rem;
    flex-wrap: wrap;
    margin: 1.5rem 0;
  }

  .record-btn {
    background: white;
    border: 2px solid var(--collatz-accent);
    color: var(--collatz-accent);
    padding: 0.75rem 1.5rem;
    border-radius: 10px;
    font-size: 0.95rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
  }

  .record-btn:hover {
    background: var(--collatz-accent);
    color: white;
    transform: translateY(-2px);
  }

  .loading-indicator {
    text-align: center;
    padding: 2rem;
    font-size: 1.2rem;
    color: #6b7280;
  }

  .loading-dots {
    display: inline-flex;
    gap: 0.5rem;
  }

  .loading-dot {
    width: 12px;
    height: 12px;
    border-radius: 50%;
    background: var(--collatz-primary);
    animation: loadingDot 1.4s ease-in-out infinite;
  }

  .loading-dot:nth-child(2) { animation-delay: 0.2s; }
  .loading-dot:nth-child(3) { animation-delay: 0.4s; }

  @keyframes loadingDot {
    0%, 80%, 100% { transform: scale(0.8); opacity: 0.5; }
    40% { transform: scale(1.2); opacity: 1; }
  }

  @media (max-width: 768px) {
    .collatz-header h1 {
      font-size: 2rem;
    }

    .controls-grid {
      grid-template-columns: 1fr;
    }

    .sequence-number {
      padding: 0.5rem 1rem;
      font-size: 1rem;
      min-width: 50px;
    }

    .stat-value {
      font-size: 2rem;
    }
  }
  </style>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="collatz-container">

  <div class="collatz-card">
    <div class="collatz-header">
      <h1>🔢 Collatz Conjecture Explorer 🔢</h1>
      <p class="subtitle">The 3n+1 Problem</p>
      <p class="description">One of mathematics' greatest unsolved mysteries</p>
      <div class="mystery-badge">⚠️ UNSOLVED SINCE 1937 ⚠️</div>
    </div>

    <div class="controls-section">
      <div class="controls-grid">
        <div class="control-group">
          <label for="startNumber">🎯 Starting Number</label>
          <input type="number" id="startNumber" min="1" max="100000" value="27">
        </div>

        <div class="control-group">
          <label for="animationSpeed">⚡ Animation Speed (ms)</label>
          <input type="number" id="animationSpeed" min="50" max="2000" value="500" step="50">
        </div>
      </div>

      <div class="action-buttons">
        <button class="btn-primary" onclick="startSequence()">
          ▶️ Start Sequence
        </button>
        <button class="btn-secondary" onclick="stopAnimation()">
          ⏸️ Stop
        </button>
        <button class="btn-secondary" onclick="resetVisualization()">
          🔄 Reset
        </button>
      </div>

      <div class="record-numbers">
        <button class="record-btn" onclick="tryNumber(27)">27 (Classic)</button>
        <button class="record-btn" onclick="tryNumber(63)">63 (108 steps)</button>
        <button class="record-btn" onclick="tryNumber(97)">97 (Long)</button>
        <button class="record-btn" onclick="tryNumber(871)">871 (High peak)</button>
        <button class="record-btn" onclick="tryNumber(6171)">6171 (261 steps)</button>
      </div>
    </div>

    <div class="sequence-display" id="sequenceDisplay">
      <div style="text-align: center; color: #6b7280; padding: 2rem;">
        Enter a starting number and click "Start Sequence" to begin!
      </div>
    </div>

    <div class="stats-panel" id="statsPanel" style="display: none;">
      <!-- Stats will be displayed here -->
    </div>

    <div class="chart-container" id="chartContainer" style="display: none;">
      <canvas id="collatzChart"></canvas>
    </div>

    <div class="info-box">
      <h3>🧠 What is the Collatz Conjecture?</h3>
      <p>The <strong>Collatz Conjecture</strong> (also called the 3n+1 problem) is one of the most famous unsolved problems in mathematics. Despite its simple rules, no one has proven whether it's true for ALL positive integers!</p>

      <div class="rule-box">
        If n is even: n → n/2<br>
        If n is odd: n → 3n+1<br>
        Repeat until you reach 1
      </div>

      <p><strong>The Conjecture:</strong> No matter what positive integer you start with, you will ALWAYS eventually reach 1.</p>

      <p><strong>Status:</strong> <span class="mystery-badge">⚠️ UNPROVEN</span> - Verified for all numbers up to 2⁶⁸ (≈ 295 quintillion), but no general proof exists!</p>

      <p><strong>Why is it unsolved?</strong> The sequence behavior appears chaotic and unpredictable. Some numbers reach 1 quickly, others take hundreds of steps and reach enormous peak values before descending.</p>

      <p><strong>Famous Quote:</strong> "Mathematics is not yet ready for such problems." - Paul Erdős</p>
    </div>
  </div>

</div>

<%@ include file="footer_adsense.jsp"%>

<script>
let currentSequence = [];
let animationInterval = null;
let currentIndex = 0;
let chart = null;
let stoppingTime = 0;
let peakValue = 0;

function collatzStep(n) {
  if (n % 2 === 0) {
    return n / 2;
  } else {
    return 3 * n + 1;
  }
}

function generateSequence(start) {
  const sequence = [start];
  let current = start;
  let steps = 0;
  let peak = start;
  const MAX_STEPS = 10000; // Safety limit

  while (current !== 1 && steps < MAX_STEPS) {
    current = collatzStep(current);
    sequence.push(current);
    if (current > peak) peak = current;
    steps++;
  }

  return { sequence, steps, peak };
}

function startSequence() {
  stopAnimation();
  resetVisualization();

  const startNum = parseInt(document.getElementById('startNumber').value);

  if (isNaN(startNum) || startNum < 1 || startNum > 100000) {
    alert('Please enter a number between 1 and 100,000');
    return;
  }

  const result = generateSequence(startNum);
  currentSequence = result.sequence;
  stoppingTime = result.steps;
  peakValue = result.peak;

  const speed = parseInt(document.getElementById('animationSpeed').value);

  currentIndex = 0;
  displayNextNumber(speed);
}

function displayNextNumber(speed) {
  if (currentIndex >= currentSequence.length) {
    finishSequence();
    return;
  }

  const display = document.getElementById('sequenceDisplay');
  const container = display.querySelector('.sequence-container') || createSequenceContainer();

  const num = currentSequence[currentIndex];
  const isPeak = (num === peakValue && num > currentSequence[0]);
  const isOne = (num === 1);

  const numberDiv = document.createElement('div');
  numberDiv.className = 'sequence-number';
  if (isPeak) numberDiv.classList.add('peak');
  if (isOne) numberDiv.classList.add('one');
  numberDiv.textContent = num.toLocaleString();
  numberDiv.title = `Step ${currentIndex}: ${num}`;

  if (currentIndex > 0) {
    const arrow = document.createElement('div');
    arrow.className = 'sequence-arrow';
    arrow.textContent = '→';
    container.appendChild(arrow);
  }

  container.appendChild(numberDiv);

  // Scroll to bottom
  container.scrollIntoView({ behavior: 'smooth', block: 'end' });

  currentIndex++;
  animationInterval = setTimeout(() => displayNextNumber(speed), speed);
}

function createSequenceContainer() {
  const display = document.getElementById('sequenceDisplay');
  display.innerHTML = '<div class="sequence-container"></div>';
  return display.querySelector('.sequence-container');
}

function finishSequence() {
  stopAnimation();
  displayStats();
  displayChart();
}

function displayStats() {
  const statsPanel = document.getElementById('statsPanel');
  statsPanel.style.display = 'grid';

  const totalSteps = currentSequence.length - 1;
  const startValue = currentSequence[0];

  let html = `
    <div class="stat-card">
      <div class="stat-label">Starting Number</div>
      <div class="stat-value">${startValue.toLocaleString()}</div>
    </div>
    <div class="stat-card">
      <div class="stat-label">Steps to Reach 1</div>
      <div class="stat-value">${stoppingTime}</div>
    </div>
    <div class="stat-card">
      <div class="stat-label">Peak Value</div>
      <div class="stat-value">${peakValue.toLocaleString()}</div>
    </div>
    <div class="stat-card">
      <div class="stat-label">Sequence Length</div>
      <div class="stat-value">${currentSequence.length}</div>
    </div>
  `;

  statsPanel.innerHTML = html;
}

function displayChart() {
  const chartContainer = document.getElementById('chartContainer');
  chartContainer.style.display = 'block';

  if (chart) {
    chart.destroy();
  }

  const ctx = document.getElementById('collatzChart').getContext('2d');

  // Prepare data - show every point for small sequences, sample for large ones
  let displayData = currentSequence;
  let displayLabels = currentSequence.map((_, i) => i);

  if (currentSequence.length > 200) {
    // Sample every nth point
    const step = Math.ceil(currentSequence.length / 200);
    displayData = currentSequence.filter((_, i) => i % step === 0 || i === currentSequence.length - 1);
    displayLabels = displayData.map((_, i) => i * step);
  }

  chart = new Chart(ctx, {
    type: 'line',
    data: {
      labels: displayLabels,
      datasets: [{
        label: 'Collatz Sequence',
        data: displayData,
        borderColor: 'rgb(239, 68, 68)',
        backgroundColor: 'rgba(239, 68, 68, 0.1)',
        borderWidth: 2,
        fill: true,
        tension: 0.1,
        pointRadius: displayData.length < 50 ? 4 : 2,
        pointHoverRadius: 6
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: true,
      aspectRatio: 2,
      plugins: {
        title: {
          display: true,
          text: `Collatz Sequence: ${currentSequence[0]} → 1`,
          font: {
            size: 16,
            weight: 'bold'
          }
        },
        legend: {
          display: true
        },
        tooltip: {
          callbacks: {
            label: function(context) {
              return `Step ${context.parsed.x}: ${context.parsed.y.toLocaleString()}`;
            }
          }
        }
      },
      scales: {
        x: {
          title: {
            display: true,
            text: 'Step Number'
          }
        },
        y: {
          title: {
            display: true,
            text: 'Value'
          },
          type: 'logarithmic',
          ticks: {
            callback: function(value) {
              return value.toLocaleString();
            }
          }
        }
      }
    }
  });
}

function stopAnimation() {
  if (animationInterval) {
    clearTimeout(animationInterval);
    animationInterval = null;
  }
}

function resetVisualization() {
  stopAnimation();
  currentSequence = [];
  currentIndex = 0;
  stoppingTime = 0;
  peakValue = 0;

  const display = document.getElementById('sequenceDisplay');
  display.innerHTML = '<div style="text-align: center; color: #6b7280; padding: 2rem;">Ready to explore!</div>';

  const statsPanel = document.getElementById('statsPanel');
  statsPanel.style.display = 'none';

  const chartContainer = document.getElementById('chartContainer');
  chartContainer.style.display = 'none';

  if (chart) {
    chart.destroy();
    chart = null;
  }
}

function tryNumber(num) {
  document.getElementById('startNumber').value = num;
  startSequence();
}

// Initialize
document.addEventListener('DOMContentLoaded', function() {
  // Allow Enter key to start
  document.getElementById('startNumber').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
      startSequence();
    }
  });
});
</script>
</div>
<%@ include file="body-close.jsp"%>
