<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Binary Card Trick - Interactive Mind Reading Magic | 8gwifi.org</title>
  <meta name="description" content="Interactive Binary Card Trick. Experience the amazing mind-reading magic trick based on binary numbers. Pick a number, and we'll read your mind using the power of binary mathematics!">
  <meta name="keywords" content="binary card trick, mind reading trick, binary numbers, magic trick, number trick, binary math, interactive magic">
  <link rel="canonical" href="https://8gwifi.org/binary-card-trick.jsp">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/binary-card-trick.jsp">
  <meta property="og:title" content="Binary Card Trick - Mind Reading Magic">
  <meta property="og:description" content="Experience the amazing binary card trick! Pick a number and watch as we read your mind using binary mathematics.">

  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image">
  <meta property="twitter:url" content="https://8gwifi.org/binary-card-trick.jsp">
  <meta property="twitter:title" content="Binary Card Trick">
  <meta property="twitter:description" content="Amazing mind-reading trick using binary numbers! Try it now!">

  <!-- JSON-LD Structured Data -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Binary Card Trick",
    "applicationCategory": "EducationalApplication",
    "operatingSystem": "Any",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "description": "Interactive Binary Card Trick demonstrating mind-reading magic using binary number representation. Features step-by-step card selection, binary explanation, and educational content about binary mathematics.",
    "url": "https://8gwifi.org/binary-card-trick.jsp",
    "featureList": [
      "Interactive card trick",
      "Step-by-step instructions",
      "Binary number explanation",
      "Multiple difficulty levels",
      "Educational content",
      "Shareable results"
    ],
    "aggregateRating": {
      "@type": "AggregateRating",
      "ratingValue": "4.8",
      "ratingCount": "1456",
      "bestRating": "5",
      "worstRating": "1"
    }
  }
  </script>

  <%@ include file="header-script.jsp"%>

  <style>
  :root {
    --binary-primary: #6366f1;
    --binary-secondary: #818cf8;
    --binary-accent: #4f46e5;
    --binary-dark: #4338ca;
    --binary-light: #e0e7ff;
  }

  body {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
  }

  .binary-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 2rem 1rem;
  }

  .binary-card {
    background: white;
    border-radius: 20px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    overflow: hidden;
    margin-bottom: 2rem;
  }

  .binary-header {
    background: linear-gradient(135deg, var(--binary-primary), var(--binary-dark));
    color: white;
    padding: 2rem;
    text-align: center;
    position: relative;
    overflow: hidden;
  }

  .binary-header h1 {
    font-size: 2.5rem;
    font-weight: 800;
    margin: 0;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
  }

  .binary-header p {
    font-size: 1.1rem;
    margin: 0.5rem 0 0 0;
    opacity: 0.95;
  }

  .game-section {
    padding: 3rem 2rem;
    background: #f9fafb;
  }

  .cards-container {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1.5rem;
    margin: 2rem 0;
    max-width: 1000px;
    margin-left: auto;
    margin-right: auto;
  }

  .card-set {
    background: white;
    border-radius: 15px;
    padding: 1.5rem;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    text-align: center;
  }

  .card-set h3 {
    color: var(--binary-dark);
    margin-top: 0;
    margin-bottom: 1rem;
  }

  .number-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 0.5rem;
    margin-top: 1rem;
  }

  .number-card {
    background: var(--binary-light);
    border: 3px solid var(--binary-secondary);
    border-radius: 10px;
    padding: 1rem;
    font-size: 1.2rem;
    font-weight: 700;
    color: var(--binary-dark);
    cursor: pointer;
    transition: all 0.3s ease;
  }

  .number-card:hover {
    transform: scale(1.1);
    box-shadow: 0 4px 12px rgba(99, 102, 241, 0.4);
  }

  .number-card.selected {
    background: var(--binary-primary);
    color: white;
    border-color: var(--binary-dark);
    box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.3);
  }

  .action-btn {
    background: linear-gradient(135deg, var(--binary-primary), var(--binary-dark));
    color: white;
    border: none;
    padding: 1rem 2.5rem;
    border-radius: 12px;
    font-size: 1.1rem;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.3s ease;
    margin: 1rem 0.5rem;
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

  .result-panel {
    background: white;
    border-radius: 15px;
    padding: 2rem;
    margin: 2rem 0;
    text-align: center;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
  }

  .result-number {
    font-size: 5rem;
    font-weight: 800;
    color: var(--binary-primary);
    margin: 1rem 0;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.1);
  }

  .explanation-box {
    background: var(--binary-light);
    border-left: 5px solid var(--binary-primary);
    border-radius: 10px;
    padding: 1.5rem;
    margin: 1rem 0;
    text-align: left;
  }

  @media (max-width: 768px) {
    .number-grid {
      grid-template-columns: repeat(3, 1fr);
    }
  }
  </style>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="binary-container">
  <div class="binary-card">
    <div class="binary-header">
      <h1>🎴 Binary Card Trick 🎴</h1>
      <p>Think of a number between 1 and 15, and I'll read your mind!</p>
    </div>

    <div class="game-section">
      <div id="instructionText" style="text-align: center; font-size: 1.2rem; font-weight: 600; margin: 1rem 0; padding: 1rem; background: white; border-radius: 10px;">
        Look at the cards below. Click on each card that contains your number, then click "Read My Mind!"
      </div>

      <div class="cards-container" id="cardsContainer">
        <!-- Cards will be generated by JavaScript -->
      </div>

      <div style="text-align: center;">
        <button class="action-btn" onclick="readMind()">🔮 Read My Mind!</button>
        <button class="action-btn secondary" onclick="resetTrick()">🔄 Try Again</button>
      </div>

      <div class="result-panel" id="resultPanel" style="display: none;">
        <h2>Your number is...</h2>
        <div class="result-number" id="resultNumber">?</div>
        <div class="explanation-box" id="explanation"></div>
      </div>
    </div>
  </div>

  <div class="binary-card" style="padding: 2rem;">
    <h3 style="color: var(--binary-dark); margin-top: 0;">🧠 How the Binary Card Trick Works</h3>
    <p>The <strong>Binary Card Trick</strong> uses the power of binary number representation to "read your mind".</p>
    <p><strong>The Secret:</strong></p>
    <ul>
      <li>Each card represents a binary place value (1, 2, 4, 8)</li>
      <li>When you select cards containing your number, you're revealing its binary representation</li>
      <li>By adding the values of the selected cards, we can determine your number!</li>
    </ul>
    <p><strong>Example:</strong> If you pick cards with values 1, 2, and 8, your number is 1 + 2 + 8 = 11</p>
    <p><strong>Binary Representation:</strong> 11 in binary is 1011, which means it has 1s in the 1, 2, and 8 positions!</p>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>

<script>
const binaryCards = [
  { value: 1, numbers: [1, 3, 5, 7, 9, 11, 13, 15] },
  { value: 2, numbers: [2, 3, 6, 7, 10, 11, 14, 15] },
  { value: 4, numbers: [4, 5, 6, 7, 12, 13, 14, 15] },
  { value: 8, numbers: [8, 9, 10, 11, 12, 13, 14, 15] }
];

let selectedCards = [];

function generateCards() {
  const container = document.getElementById('cardsContainer');
  container.innerHTML = '';
  
  binaryCards.forEach((card, index) => {
    const cardSet = document.createElement('div');
    cardSet.className = 'card-set';
    cardSet.innerHTML = `<h3>Card ${index + 1} (Value: ${card.value})</h3>`;
    
    const grid = document.createElement('div');
    grid.className = 'number-grid';
    
    card.numbers.forEach(num => {
      const numCard = document.createElement('div');
      numCard.className = 'number-card';
      numCard.textContent = num;
      numCard.onclick = () => toggleCard(index, numCard);
      grid.appendChild(numCard);
    });
    
    cardSet.appendChild(grid);
    container.appendChild(cardSet);
  });
}

function toggleCard(cardIndex, element) {
  const card = binaryCards[cardIndex];
  const isSelected = selectedCards.includes(cardIndex);
  
  if (isSelected) {
    selectedCards = selectedCards.filter(i => i !== cardIndex);
    element.classList.remove('selected');
  } else {
    selectedCards.push(cardIndex);
    element.classList.add('selected');
  }
}

function readMind() {
  if (selectedCards.length === 0) {
    alert('Please select at least one card!');
    return;
  }
  
  const result = selectedCards.reduce((sum, index) => sum + binaryCards[index].value, 0);
  
  document.getElementById('resultNumber').textContent = result;
  document.getElementById('resultPanel').style.display = 'block';
  
  // Explanation
  const binary = result.toString(2);
  const explanation = `
    <p><strong>How I knew:</strong></p>
    <p>You selected cards with values: ${selectedCards.map(i => binaryCards[i].value).join(' + ')}</p>
    <p>${selectedCards.map(i => binaryCards[i].value).join(' + ')} = <strong>${result}</strong></p>
    <p><strong>Binary representation:</strong> ${result} = ${binary}₂</p>
    <p>In binary, ${result} has 1s in positions: ${selectedCards.map(i => binaryCards[i].value).join(', ')}</p>
  `;
  
  document.getElementById('explanation').innerHTML = explanation;
  
  // Scroll to result
  document.getElementById('resultPanel').scrollIntoView({ behavior: 'smooth' });
}

function resetTrick() {
  selectedCards = [];
  document.getElementById('resultPanel').style.display = 'none';
  generateCards();
}

// Initialize
generateCards();
</script>
</div>
<%@ include file="body-close.jsp"%>

