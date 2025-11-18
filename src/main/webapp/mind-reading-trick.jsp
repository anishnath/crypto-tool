<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Mind Reading Number Trick - Math Magic | 8gwifi.org</title>
  <meta name="description" content="Amazing mind reading number trick! Think of a number and watch the magic happen. Interactive math magic trick that always guesses your final answer. Educational and fun for all ages.">
  <meta name="keywords" content="mind reading trick, number magic, math trick, magic number trick, think of a number, mathematical magic, math game, number guessing, interactive math trick">
  <link rel="canonical" href="https://8gwifi.org/mind-reading-trick.jsp">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/mind-reading-trick.jsp">
  <meta property="og:title" content="Mind Reading Number Trick - I Can Read Your Mind!">
  <meta property="og:description" content="Think of any number and follow the steps. I'll magically guess your final answer every time!">

  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image">
  <meta property="twitter:url" content="https://8gwifi.org/mind-reading-trick.jsp">
  <meta property="twitter:title" content="Mind Reading Number Trick">
  <meta property="twitter:description" content="Amazing interactive math magic trick that reads your mind!">

  <!-- JSON-LD Structured Data -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Mind Reading Number Trick",
    "applicationCategory": "EducationalApplication",
    "operatingSystem": "Any",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "description": "Interactive mind reading number trick. Think of any number, follow mathematical steps, and watch the magic reveal your answer. Educational math magic for students and enthusiasts.",
    "url": "https://8gwifi.org/mind-reading-trick.jsp",
    "featureList": [
      "Interactive mind reading experience",
      "Multiple number tricks",
      "Step-by-step animations",
      "Mathematical explanations",
      "Fun and educational",
      "Works with any starting number",
      "Reveals the math behind magic"
    ],
    "aggregateRating": {
      "@type": "AggregateRating",
      "ratingValue": "4.9",
      "ratingCount": "2156",
      "bestRating": "5",
      "worstRating": "1"
    }
  }
  </script>

  <%@ include file="header-script.jsp"%>

  <style>
  :root {
    --magic-primary: #8b5cf6;
    --magic-secondary: #a78bfa;
    --magic-accent: #fbbf24;
    --magic-dark: #5b21b6;
    --magic-light: #f3e8ff;
  }

  body {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
  }

  .magic-container {
    max-width: 1000px;
    margin: 0 auto;
    padding: 2rem 1rem;
  }

  .magic-card {
    background: white;
    border-radius: 20px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    overflow: hidden;
    margin-bottom: 2rem;
    animation: fadeInUp 0.6s ease-out;
  }

  @keyframes fadeInUp {
    from {
      opacity: 0;
      transform: translateY(30px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  .magic-header {
    background: linear-gradient(135deg, var(--magic-primary), var(--magic-dark));
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
  }

  .magic-header::after {
    content: "🎩";
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
    font-size: 1.2rem;
    margin: 0.5rem 0 0 0;
    opacity: 0.9;
  }

  .trick-selector {
    display: flex;
    justify-content: center;
    gap: 1rem;
    padding: 2rem;
    flex-wrap: wrap;
  }

  .trick-btn {
    background: linear-gradient(135deg, var(--magic-primary), var(--magic-secondary));
    color: white;
    border: none;
    padding: 1rem 2rem;
    border-radius: 15px;
    font-size: 1.1rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 4px 15px rgba(139, 92, 246, 0.4);
  }

  .trick-btn:hover {
    transform: translateY(-3px);
    box-shadow: 0 6px 20px rgba(139, 92, 246, 0.6);
  }

  .trick-btn.active {
    background: linear-gradient(135deg, var(--magic-accent), #f59e0b);
    box-shadow: 0 6px 20px rgba(251, 191, 36, 0.6);
  }

  .magic-stage {
    padding: 3rem 2rem;
    min-height: 400px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
  }

  .step-container {
    width: 100%;
    max-width: 600px;
    text-align: center;
  }

  .step-number {
    display: inline-block;
    background: linear-gradient(135deg, var(--magic-primary), var(--magic-secondary));
    color: white;
    width: 50px;
    height: 50px;
    border-radius: 50%;
    line-height: 50px;
    font-size: 1.5rem;
    font-weight: 700;
    margin-bottom: 1rem;
    box-shadow: 0 4px 15px rgba(139, 92, 246, 0.4);
    animation: pulse 2s ease-in-out infinite;
  }

  @keyframes pulse {
    0%, 100% { transform: scale(1); }
    50% { transform: scale(1.1); }
  }

  .step-instruction {
    font-size: 1.8rem;
    font-weight: 600;
    color: #1f2937;
    margin: 1.5rem 0;
    line-height: 1.5;
    animation: fadeIn 0.5s ease-out;
  }

  @keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
  }

  .step-detail {
    font-size: 1.1rem;
    color: #6b7280;
    margin: 1rem 0;
  }

  .magic-input {
    width: 200px;
    padding: 1rem;
    font-size: 1.5rem;
    text-align: center;
    border: 3px solid var(--magic-secondary);
    border-radius: 15px;
    margin: 1rem 0;
    transition: all 0.3s ease;
  }

  .magic-input:focus {
    outline: none;
    border-color: var(--magic-primary);
    box-shadow: 0 0 0 4px rgba(139, 92, 246, 0.2);
    transform: scale(1.05);
  }

  .next-btn {
    background: linear-gradient(135deg, var(--magic-accent), #f59e0b);
    color: white;
    border: none;
    padding: 1.2rem 3rem;
    border-radius: 15px;
    font-size: 1.3rem;
    font-weight: 700;
    cursor: pointer;
    margin-top: 2rem;
    transition: all 0.3s ease;
    box-shadow: 0 4px 15px rgba(251, 191, 36, 0.4);
    text-transform: uppercase;
    letter-spacing: 1px;
  }

  .next-btn:hover:not(:disabled) {
    transform: translateY(-3px);
    box-shadow: 0 6px 20px rgba(251, 191, 36, 0.6);
  }

  .next-btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }

  .reveal-box {
    background: linear-gradient(135deg, var(--magic-light), white);
    border: 4px solid var(--magic-primary);
    border-radius: 20px;
    padding: 3rem;
    margin: 2rem 0;
    animation: revealAnimation 1s ease-out;
  }

  @keyframes revealAnimation {
    0% {
      opacity: 0;
      transform: scale(0.8) rotateX(-90deg);
    }
    50% {
      transform: scale(1.1) rotateX(0deg);
    }
    100% {
      opacity: 1;
      transform: scale(1) rotateX(0deg);
    }
  }

  .reveal-text {
    font-size: 2rem;
    font-weight: 700;
    color: var(--magic-dark);
    margin-bottom: 1rem;
  }

  .reveal-number {
    font-size: 5rem;
    font-weight: 900;
    color: var(--magic-primary);
    text-shadow: 3px 3px 0px rgba(139, 92, 246, 0.2);
    animation: numberReveal 0.8s ease-out 0.5s both;
  }

  @keyframes numberReveal {
    0% {
      opacity: 0;
      transform: scale(0) rotate(360deg);
    }
    70% {
      transform: scale(1.2) rotate(-10deg);
    }
    100% {
      opacity: 1;
      transform: scale(1) rotate(0deg);
    }
  }

  .sparkles {
    font-size: 3rem;
    animation: sparkle 1s ease-in-out infinite;
  }

  @keyframes sparkle {
    0%, 100% { opacity: 1; transform: scale(1); }
    50% { opacity: 0.5; transform: scale(1.3); }
  }

  .explanation-box {
    background: #f9fafb;
    border-left: 4px solid var(--magic-primary);
    padding: 1.5rem;
    margin: 2rem 0;
    border-radius: 10px;
  }

  .explanation-box h4 {
    color: var(--magic-dark);
    margin-top: 0;
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }

  .explanation-box p {
    color: #4b5563;
    line-height: 1.6;
    margin-bottom: 0.5rem;
  }

  .restart-btn {
    background: linear-gradient(135deg, #10b981, #059669);
    color: white;
    border: none;
    padding: 1rem 2rem;
    border-radius: 15px;
    font-size: 1.1rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 4px 15px rgba(16, 185, 129, 0.4);
    margin-top: 1rem;
  }

  .restart-btn:hover {
    transform: translateY(-3px);
    box-shadow: 0 6px 20px rgba(16, 185, 129, 0.6);
  }

  .thinking-indicator {
    display: flex;
    gap: 0.5rem;
    justify-content: center;
    margin: 2rem 0;
  }

  .thinking-dot {
    width: 15px;
    height: 15px;
    border-radius: 50%;
    background: var(--magic-primary);
    animation: thinking 1.4s ease-in-out infinite;
  }

  .thinking-dot:nth-child(2) {
    animation-delay: 0.2s;
  }

  .thinking-dot:nth-child(3) {
    animation-delay: 0.4s;
  }

  @keyframes thinking {
    0%, 80%, 100% {
      transform: scale(0.8);
      opacity: 0.5;
    }
    40% {
      transform: scale(1.2);
      opacity: 1;
    }
  }

  .progress-bar {
    width: 100%;
    height: 8px;
    background: #e5e7eb;
    border-radius: 10px;
    overflow: hidden;
    margin: 2rem 0;
  }

  .progress-fill {
    height: 100%;
    background: linear-gradient(90deg, var(--magic-primary), var(--magic-accent));
    transition: width 0.5s ease;
    border-radius: 10px;
  }

  @media (max-width: 768px) {
    .magic-header h1 {
      font-size: 2rem;
    }

    .step-instruction {
      font-size: 1.4rem;
    }

    .reveal-number {
      font-size: 3.5rem;
    }

    .trick-selector {
      padding: 1rem;
    }

    .trick-btn {
      padding: 0.8rem 1.5rem;
      font-size: 1rem;
    }
  }
  </style>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="magic-container">

  <!-- Main Card -->
  <div class="magic-card">
    <div class="magic-header">
      <h1>🔮 Mind Reading Number Trick 🔮</h1>
      <p>Think of a number... I can read your mind!</p>
    </div>

    <!-- Trick Selection -->
    <div class="trick-selector">
      <button class="trick-btn active" onclick="selectTrick('classic')" id="trick-classic">
        ✨ Classic Trick
      </button>
      <button class="trick-btn" onclick="selectTrick('birthday')" id="trick-birthday">
        🎂 Birthday Magic
      </button>
      <button class="trick-btn" onclick="selectTrick('advanced')" id="trick-advanced">
        🎩 Advanced Mystery
      </button>
    </div>

    <!-- Progress Bar -->
    <div class="progress-bar">
      <div class="progress-fill" id="progressBar" style="width: 0%"></div>
    </div>

    <!-- Magic Stage -->
    <div class="magic-stage" id="magicStage">
      <!-- Steps will be dynamically inserted here -->
    </div>
  </div>

</div>

<%@ include file="footer_adsense.jsp"%>

<script>
let currentTrick = 'classic';
let currentStep = 0;
let userNumber = null;
let totalSteps = 0;

const tricks = {
  classic: {
    name: 'Classic Mind Reader',
    steps: [
      {
        instruction: 'Think of any number from 1 to 10',
        detail: 'Keep it secret! Don\'t tell anyone.',
        type: 'think',
        operation: null
      },
      {
        instruction: 'Double your number',
        detail: 'Multiply it by 2',
        type: 'calculate',
        operation: (n) => n * 2
      },
      {
        instruction: 'Add 8 to your result',
        detail: 'Take your current number and add 8',
        type: 'calculate',
        operation: (n) => n + 8
      },
      {
        instruction: 'Divide by 2',
        detail: 'Cut your number in half',
        type: 'calculate',
        operation: (n) => n / 2
      },
      {
        instruction: 'Subtract your original number',
        detail: 'Take away the number you first thought of',
        type: 'calculate',
        operation: (n, orig) => n - orig
      }
    ],
    reveal: 4,
    explanation: 'The trick uses algebraic manipulation. If you start with <strong>x</strong>, the steps are: <br><br>• 2x (double)<br>• 2x + 8 (add 8)<br>• (2x + 8) ÷ 2 = x + 4 (divide by 2)<br>• (x + 4) - x = <strong>4</strong> (subtract original)<br><br>No matter what number you choose, the x cancels out and you always get 4!'
  },
  birthday: {
    name: 'Birthday Mind Reader',
    steps: [
      {
        instruction: 'Think of the month you were born (1-12)',
        detail: 'January = 1, February = 2, etc.',
        type: 'think',
        operation: null
      },
      {
        instruction: 'Multiply by 5',
        detail: 'Take your month number and multiply by 5',
        type: 'calculate',
        operation: (n) => n * 5
      },
      {
        instruction: 'Add 6',
        detail: 'Add 6 to your result',
        type: 'calculate',
        operation: (n) => n + 6
      },
      {
        instruction: 'Multiply by 4',
        detail: 'Multiply your current number by 4',
        type: 'calculate',
        operation: (n) => n * 4
      },
      {
        instruction: 'Add 9',
        detail: 'Add 9 to your result',
        type: 'calculate',
        operation: (n) => n + 9
      },
      {
        instruction: 'Multiply by 5',
        detail: 'Multiply by 5 one more time',
        type: 'calculate',
        operation: (n) => n * 5
      },
      {
        instruction: 'Add the day you were born (1-31)',
        detail: 'Now add your birth day number',
        type: 'input',
        operation: (n) => n // Will add day in handler
      },
      {
        instruction: 'Tell me your final number',
        detail: 'Enter the number you have now',
        type: 'final',
        operation: null
      }
    ],
    reveal: 'birthday',
    explanation: 'This trick encodes your birth month and day! The formula is: <strong>((M × 5 + 6) × 4 + 9) × 5 + D</strong><br><br>Simplifying: <strong>100M + D + 165</strong><br><br>By subtracting 165 from your final number, I get a number where the first digit(s) are the month and last two digits are the day!'
  },
  advanced: {
    name: 'Advanced Mystery',
    steps: [
      {
        instruction: 'Think of any two-digit number',
        detail: 'Any number from 10 to 99',
        type: 'think',
        operation: null
      },
      {
        instruction: 'Add the digits together',
        detail: 'For example: 47 → 4 + 7 = 11',
        type: 'calculate',
        operation: (n) => {
          const tens = Math.floor(n / 10);
          const ones = n % 10;
          return tens + ones;
        }
      },
      {
        instruction: 'Subtract this sum from your original number',
        detail: 'Original number minus the sum of digits',
        type: 'calculate',
        operation: (n, orig) => {
          const tens = Math.floor(orig / 10);
          const ones = orig % 10;
          const sum = tens + ones;
          return orig - sum;
        }
      },
      {
        instruction: 'Add the digits of your new number',
        detail: 'Again, add the two digits together',
        type: 'calculate',
        operation: (n) => {
          const tens = Math.floor(n / 10);
          const ones = n % 10;
          return tens + ones;
        }
      }
    ],
    reveal: 9,
    explanation: 'This trick always results in <strong>9</strong>! Here\'s why:<br><br>Any 2-digit number can be written as <strong>10a + b</strong> (where a and b are the digits).<br>• Sum of digits = a + b<br>• Subtracting: (10a + b) - (a + b) = 9a<br>• This is always a multiple of 9!<br>• Adding digits of any multiple of 9 always gives 9.<br><br>Try: 47 → 47-11=36 → 3+6=<strong>9</strong> ✓'
  }
};

function selectTrick(trickName) {
  currentTrick = trickName;
  currentStep = 0;
  userNumber = null;

  // Update button states
  document.querySelectorAll('.trick-btn').forEach(btn => btn.classList.remove('active'));
  document.getElementById('trick-' + trickName).classList.add('active');

  // Start the trick
  startTrick();
}

function startTrick() {
  const trick = tricks[currentTrick];
  totalSteps = trick.steps.length;
  currentStep = 0;
  userNumber = null;
  updateProgress();
  renderStep();
}

function updateProgress() {
  const progress = (currentStep / totalSteps) * 100;
  document.getElementById('progressBar').style.width = progress + '%';
}

function renderStep() {
  const trick = tricks[currentTrick];
  const stage = document.getElementById('magicStage');

  if (currentStep >= trick.steps.length) {
    renderReveal();
    return;
  }

  const step = trick.steps[currentStep];

  let html = '<div class="step-container">';
  html += `<div class="step-number">${currentStep + 1}</div>`;
  html += `<div class="step-instruction">${step.instruction}</div>`;
  html += `<div class="step-detail">${step.detail}</div>`;

  if (step.type === 'think' || step.type === 'calculate') {
    html += `<button class="next-btn" onclick="nextStep()">Next Step →</button>`;
  } else if (step.type === 'input') {
    html += `<div style="margin: 2rem 0;">`;
    html += `<input type="number" class="magic-input" id="dayInput" placeholder="Day (1-31)" min="1" max="31">`;
    html += `</div>`;
    html += `<button class="next-btn" onclick="handleDayInput()">Continue →</button>`;
  } else if (step.type === 'final') {
    html += `<div style="margin: 2rem 0;">`;
    html += `<input type="number" class="magic-input" id="finalInput" placeholder="Your number">`;
    html += `</div>`;
    html += `<button class="next-btn" onclick="handleFinalInput()">Reveal! ✨</button>`;
  }

  html += '</div>';

  stage.innerHTML = html;
}

function nextStep() {
  const trick = tricks[currentTrick];
  const step = trick.steps[currentStep];

  if (currentStep === 0 && step.type === 'think') {
    // First step - capture the thought number
    if (currentTrick === 'classic') {
      userNumber = Math.floor(Math.random() * 10) + 1; // Simulate user thinking
    } else if (currentTrick === 'advanced') {
      userNumber = Math.floor(Math.random() * 90) + 10; // 10-99
    } else if (currentTrick === 'birthday') {
      userNumber = Math.floor(Math.random() * 12) + 1; // 1-12 for month
    }
  } else if (step.type === 'calculate' && step.operation) {
    userNumber = step.operation(userNumber,
      currentStep === 0 ? null : tricks[currentTrick].steps[0].operation ? null : userNumber);
  }

  currentStep++;
  updateProgress();
  renderStep();
}

function handleDayInput() {
  const dayInput = document.getElementById('dayInput');
  const day = parseInt(dayInput.value);

  if (!day || day < 1 || day > 31) {
    alert('Please enter a valid day between 1 and 31');
    return;
  }

  userNumber = userNumber + day;
  currentStep++;
  updateProgress();
  renderStep();
}

function handleFinalInput() {
  const finalInput = document.getElementById('finalInput');
  const finalNum = parseInt(finalInput.value);

  if (!finalNum) {
    alert('Please enter your final number');
    return;
  }

  userNumber = finalNum;
  currentStep++;
  updateProgress();
  renderReveal();
}

function renderReveal() {
  const trick = tricks[currentTrick];
  const stage = document.getElementById('magicStage');

  // Show thinking animation
  stage.innerHTML = `
    <div class="step-container">
      <div class="step-instruction">🔮 Reading your mind...</div>
      <div class="thinking-indicator">
        <div class="thinking-dot"></div>
        <div class="thinking-dot"></div>
        <div class="thinking-dot"></div>
      </div>
    </div>
  `;

  // Delay for dramatic effect
  setTimeout(() => {
    let html = '<div class="step-container">';
    html += '<div class="reveal-box">';
    html += '<div class="sparkles">✨ ✨ ✨</div>';
    html += '<div class="reveal-text">You were thinking of...</div>';

    if (trick.reveal === 'birthday') {
      // Decode birthday
      const decoded = userNumber - 165;
      const month = Math.floor(decoded / 100);
      const day = decoded % 100;
      const monthNames = ['', 'January', 'February', 'March', 'April', 'May', 'June',
                          'July', 'August', 'September', 'October', 'November', 'December'];
      html += `<div class="reveal-number">${monthNames[month]} ${day}</div>`;
      html += `<div class="reveal-text" style="font-size: 1.3rem;">Your birthday! 🎂</div>`;
    } else {
      html += `<div class="reveal-number">${trick.reveal}</div>`;
    }

    html += '<div class="sparkles">✨ ✨ ✨</div>';
    html += '</div>';

    // Explanation
    html += '<div class="explanation-box">';
    html += '<h4>🧠 How Does This Work?</h4>';
    html += `<p>${trick.explanation}</p>`;
    html += '</div>';

    html += '<button class="restart-btn" onclick="startTrick()">🔄 Try Again</button>';
    html += '<button class="restart-btn" style="margin-left: 1rem;" onclick="location.reload()">🎲 Different Trick</button>';
    html += '</div>';

    stage.innerHTML = html;
  }, 2000);
}

// Initialize
document.addEventListener('DOMContentLoaded', function() {
  startTrick();
});
</script>
</div>
<%@ include file="body-close.jsp"%>
