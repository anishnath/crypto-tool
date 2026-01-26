<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="seo-helper.jsp" %>
        <% String pageKey="recall" ; String seoTitle=getSEOTitle(pageKey, application); String
            seoDescription=getMetaDescription(pageKey, application); String canonicalUrl=getCanonicalUrl(pageKey,
            application); String extraHead=generateHeadContent(pageKey, application) + generateJsonLd(pageKey, application); request.setAttribute("pageTitle",
            seoTitle); request.setAttribute("pageDescription", seoDescription); request.setAttribute("canonicalUrl",
            canonicalUrl); request.setAttribute("extraHeadContent", extraHead); %>
            <%@ include file="../components/header.jsp" %>

                <!-- Shared CSS -->
                <link rel="stylesheet" href="<%=request.getContextPath()%>/exams/css/math-memory-base.css">

                <!-- Core JS -->
                <script src="<%=request.getContextPath()%>/exams/js/math-memory-core.js"></script>

                <style>
                    :root {
                        --neon-pink: #ec4899;
                        --neon-purple: #ab20fd;
                        --arcade-dark: #0f0a1e;
                        --arcade-card: #1a1333;
                        --arcade-border: #2d2255;
                        --glow-pink: 0 0 20px rgba(236, 72, 153, 0.5);
                    }

                    .game-page {
                        background: linear-gradient(135deg, var(--arcade-dark) 0%, #1a0a2e 50%, var(--arcade-dark) 100%);
                        min-height: 100vh;
                        padding-bottom: var(--space-8);
                    }

                    .game-page::before {
                        content: '';
                        position: fixed;
                        top: 0;
                        left: 0;
                        right: 0;
                        bottom: 0;
                        background-image:
                            radial-gradient(circle at 50% 50%, rgba(236, 72, 153, 0.05) 0%, transparent 50%);
                        pointer-events: none;
                        z-index: 0;
                    }

                    .game-container {
                        position: relative;
                        z-index: 1;
                        max-width: 900px;
                        margin: 0 auto;
                        padding: 0 var(--space-4);
                    }

                    /* Header */
                    .game-header {
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        padding: var(--space-4) 0;
                        flex-wrap: wrap;
                        gap: var(--space-3);
                    }

                    .game-title {
                        display: flex;
                        align-items: center;
                        gap: var(--space-3);
                    }

                    .game-title-icon {
                        font-size: 2rem;
                    }

                    .game-title h1 {
                        font-size: var(--text-2xl);
                        font-weight: 700;
                        background: linear-gradient(135deg, var(--neon-pink), var(--neon-purple));
                        -webkit-background-clip: text;
                        -webkit-text-fill-color: transparent;
                        background-clip: text;
                        margin: 0;
                    }

                    .game-back {
                        display: flex;
                        align-items: center;
                        gap: var(--space-2);
                        color: rgba(255, 255, 255, 0.6);
                        text-decoration: none;
                        font-size: var(--text-sm);
                        transition: color 0.2s;
                    }

                    .game-back:hover {
                        color: var(--neon-pink);
                    }

                    /* Stats Bar */
                    .stats-bar {
                        display: flex;
                        justify-content: center;
                        gap: var(--space-4);
                        margin-bottom: var(--space-6);
                        flex-wrap: wrap;
                    }

                    .stat-item {
                        background: var(--arcade-card);
                        border: 1px solid var(--arcade-border);
                        border-radius: var(--radius-lg);
                        padding: var(--space-3) var(--space-5);
                        text-align: center;
                        min-width: 80px;
                    }

                    .stat-value {
                        font-size: var(--text-2xl);
                        font-weight: 700;
                        color: var(--neon-pink);
                        text-shadow: var(--glow-pink);
                    }

                    .stat-label {
                        font-size: var(--text-xs);
                        color: rgba(255, 255, 255, 0.5);
                        text-transform: uppercase;
                        letter-spacing: 1px;
                    }

                    /* Difficulty Selector */
                    .difficulty-selector {
                        display: flex;
                        justify-content: center;
                        gap: var(--space-3);
                        margin-bottom: var(--space-6);
                    }

                    .diff-btn {
                        padding: var(--space-2) var(--space-4);
                        border: 2px solid var(--arcade-border);
                        border-radius: var(--radius-md);
                        background: var(--arcade-card);
                        color: rgba(255, 255, 255, 0.7);
                        font-size: var(--text-sm);
                        font-weight: 600;
                        cursor: pointer;
                        transition: all 0.2s;
                    }

                    .diff-btn:hover {
                        border-color: var(--neon-pink);
                        color: white;
                    }

                    .diff-btn.active {
                        border-color: var(--neon-pink);
                        color: var(--neon-pink);
                        box-shadow: var(--glow-pink);
                    }

                    /* Game Area */
                    .game-area {
                        background: var(--arcade-card);
                        border: 2px solid var(--arcade-border);
                        border-radius: var(--radius-xl);
                        min-height: 400px;
                        padding: var(--space-6);
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        justify-content: center;
                        position: relative;
                        box-shadow: 0 0 30px rgba(0, 0, 0, 0.2);
                    }

                    /* Numbers Display */
                    .numbers-container {
                        display: flex;
                        flex-wrap: wrap;
                        justify-content: center;
                        gap: var(--space-4);
                        max-width: 700px;
                    }

                    .number-card {
                        width: 80px;
                        height: 80px;
                        background: linear-gradient(135deg, #2d2255, var(--arcade-card));
                        border: 2px solid rgba(236, 72, 153, 0.3);
                        border-radius: var(--radius-lg);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 2rem;
                        font-weight: 700;
                        color: white;
                        transition: transform 0.3s;
                        animation: fadeIn 0.5s ease-out;
                    }

                    .number-card:hover {
                        transform: translateY(-5px);
                        border-color: var(--neon-pink);
                    }

                    /* Question Phase */
                    .question-container {
                        text-align: center;
                        width: 100%;
                    }

                    .question-text {
                        font-size: 1.5rem;
                        color: white;
                        margin-bottom: var(--space-6);
                        font-weight: 600;
                        line-height: 1.4;
                    }

                    .options-grid {
                        display: grid;
                        grid-template-columns: repeat(2, 1fr);
                        gap: var(--space-4);
                        max-width: 500px;
                        margin: 0 auto;
                    }

                    .option-btn {
                        padding: var(--space-4);
                        background: rgba(255, 255, 255, 0.05);
                        border: 2px solid var(--arcade-border);
                        border-radius: var(--radius-lg);
                        color: white;
                        font-size: 1.25rem;
                        font-weight: 600;
                        cursor: pointer;
                        transition: all 0.2s;
                    }

                    .option-btn:hover {
                        background: rgba(236, 72, 153, 0.1);
                        border-color: var(--neon-pink);
                    }

                    .option-btn.correct {
                        background: #22c55e;
                        border-color: #22c55e;
                    }

                    .option-btn.wrong {
                        background: #ef4444;
                        border-color: #ef4444;
                    }

                    /* Timer */
                    .timer-bar {
                        position: absolute;
                        top: 0;
                        left: 0;
                        height: 4px;
                        background: var(--neon-pink);
                        transition: width 1s linear;
                        width: 0%;
                    }

                    /* Ready/States */
                    .state-message {
                        text-align: center;
                    }

                    .state-title {
                        font-size: 2.5rem;
                        color: white;
                        margin-bottom: var(--space-4);
                        font-weight: 800;
                    }

                    .state-desc {
                        color: rgba(255, 255, 255, 0.7);
                        margin-bottom: var(--space-6);
                        font-size: 1.1rem;
                    }

                    .action-btn {
                        padding: var(--space-3) var(--space-8);
                        border: 2px solid var(--neon-pink);
                        border-radius: var(--radius-full);
                        background: var(--neon-pink);
                        color: white;
                        font-size: 1.2rem;
                        font-weight: 700;
                        cursor: pointer;
                        box-shadow: var(--glow-pink);
                        transition: transform 0.2s;
                    }

                    .action-btn:hover {
                        transform: scale(1.05);
                    }

                    @keyframes fadeIn {
                        from {
                            opacity: 0;
                            transform: scale(0.8);
                        }

                        to {
                            opacity: 1;
                            transform: scale(1);
                        }
                    }

                    /* Win Modal */
                    .win-modal {
                        position: fixed;
                        top: 0;
                        left: 0;
                        right: 0;
                        bottom: 0;
                        background: rgba(0, 0, 0, 0.9);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        z-index: 100;
                        opacity: 0;
                        visibility: hidden;
                        transition: all 0.3s;
                    }

                    .win-modal.active {
                        opacity: 1;
                        visibility: visible;
                    }

                    .win-content {
                        background: var(--arcade-card);
                        border: 2px solid var(--neon-pink);
                        border-radius: var(--radius-xl);
                        padding: var(--space-8);
                        text-align: center;
                        max-width: 400px;
                        width: 90%;
                        transform: scale(0.9);
                        transition: transform 0.3s;
                    }

                    .win-modal.active .win-content {
                        transform: scale(1);
                    }

                    /* Ad Containers */
                    .ad-container-top,
                    .ad-container-bottom {
                        display: flex;
                        justify-content: center;
                        margin: var(--space-4) 0;
                    }

                    .desktop-only {
                        display: none;
                    }

                    .mobile-only {
                        display: flex;
                    }

                    @media (min-width: 768px) {
                        .desktop-only {
                            display: flex;
                        }

                        .mobile-only {
                            display: none;
                        }

                        .options-grid {
                            grid-template-columns: repeat(2, 1fr);
                        }
                    }
                </style>

                <div class="game-page">
                    <div class="game-container">
                        <!-- Ad: Top Leaderboard -->
                        <div class="ad-container-top desktop-only">
                            <%@ include file="../components/ad-leaderboard.jsp" %>
                        </div>

                        <!-- Header -->
                        <div class="game-header">
                            <a href="<%=request.getContextPath()%>/exams/math-memory/" class="game-back">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2">
                                    <path d="M19 12H5M12 19l-7-7 7-7" />
                                </svg>
                                Back
                            </a>
                            <div class="game-title">
                                <span class="game-title-icon">&#129505;</span>
                                <h1>Rapid Recall</h1>
                            </div>
                            <div style="width: 60px;"></div>
                        </div>

                        <!-- Stats -->
                        <div class="stats-bar">
                            <div class="stat-item">
                                <div class="stat-value" id="scoreDisplay">0</div>
                                <div class="stat-label">Score</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value" id="roundDisplay">1/10</div>
                                <div class="stat-label">Round</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value" id="streakDisplay">0</div>
                                <div class="stat-label">Streak</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value" id="highScore">-</div>
                                <div class="stat-label">Best</div>
                            </div>
                        </div>

                        <!-- Difficulty -->
                        <div class="difficulty-selector">
                            <button class="diff-btn active" data-difficulty="easy">Easy</button>
                            <button class="diff-btn" data-difficulty="medium">Medium</button>
                            <button class="diff-btn" data-difficulty="hard">Hard</button>
                        </div>

                        <!-- Game Area -->
                        <div class="game-area tex2jax_ignore" id="gameArea">
                            <div class="timer-bar" id="timerBar"></div>

                            <!-- Views are injected here -->
                            <div class="state-message" id="introView">
                                <div class="state-title">Ready to Recall?</div>
                                <p class="state-desc">
                                    Study the numbers shown. Answer the question after they disappear.<br>
                                    Questions can range from "Lowest Number" to "Count of Even Numbers".
                                </p>
                                <button class="action-btn" id="startBtn">Start Game</button>
                            </div>
                        </div>

                        <!-- Mobile Ad -->
                        <div class="ad-container-bottom mobile-only">
                            <%@ include file="../components/ad-leaderboard.jsp" %>
                        </div>
                    </div>
                </div>

                <!-- Win Modal -->
                <div class="win-modal" id="winModal">
                    <div class="win-content">
                        <div style="font-size:4rem; margin-bottom:1rem;">&#127881;</div>
                        <h2 style="font-size:2rem; font-weight:700; color:white; margin-bottom:1rem;">Game Finished!
                        </h2>
                        <div style="font-size:3rem; font-weight:700; color:var(--neon-pink); margin-bottom:0.5rem;"
                            id="finalScore">0</div>
                        <div style="color:#aaa; margin-bottom:2rem;">Total Score</div>
                        <div id="finalTime" style="color:#aaa; margin-bottom:2rem;"></div>
                        <div style="display:flex; gap:var(--space-3); justify-content:center;">
                            <button class="action-btn" id="playAgainBtn">Play Again</button>
                            <button class="game-btn" id="shareBtn">Share</button>
                        </div>
                    </div>
                </div>

                <!-- Toast -->
                <div class="game-toast" id="gameToast"></div>

                <%@ include file="../components/ad-anchor.jsp" %>

                    <script>
                        (function () {
                            // Config
                            const CONFIG = {
                                easy: { count: 4, showTime: 3000, points: 100 },
                                medium: { count: 6, showTime: 4000, points: 150 },
                                hard: { count: 8, showTime: 5000, points: 200 }
                            };

                            // Limits for random numbers
                            const NUM_LIMIT = { easy: 20, medium: 50, hard: 100 };

                            // State
                            let difficulty = 'easy';
                            let round = 1;
                            let maxRounds = 10;
                            let score = 0;
                            let streak = 0;
                            let currentNumbers = [];
                            let currentQuestion = null;
                            let gameStartTime = null;
                            let totalGameTime = 0;

                            // Elements
                            const gameArea = document.getElementById('gameArea');
                            const scoreDisplay = document.getElementById('scoreDisplay');
                            const roundDisplay = document.getElementById('roundDisplay');
                            const streakDisplay = document.getElementById('streakDisplay');
                            const timerBar = document.getElementById('timerBar');
                            const winModal = document.getElementById('winModal');
                            const diffButtons = document.querySelectorAll('.diff-btn');

                            function init() {
                                loadHighScore();

                                diffButtons.forEach(btn => {
                                    btn.addEventListener('click', () => {
                                        diffButtons.forEach(b => b.classList.remove('active'));
                                        btn.classList.add('active');
                                        difficulty = btn.dataset.difficulty;
                                        loadHighScore();
                                        resetGame();
                                    });
                                });

                                document.getElementById('startBtn').addEventListener('click', startGame);
                                document.getElementById('playAgainBtn').addEventListener('click', () => {
                                    winModal.classList.remove('active');
                                    resetGame();
                                    startGame();
                                });
                                document.getElementById('shareBtn').addEventListener('click', shareScore);
                            }

                            function loadHighScore() {
                                const hs = MathMemory.storage.getHighScore('recall', difficulty);
                                document.getElementById('highScore').textContent = hs > 0 ? hs : '-';
                            }

                            function resetGame() {
                                gameStartTime = Date.now();
                                totalGameTime = 0;
                                round = 1;
                                score = 0;
                                streak = 0;
                                updateStats();
                                // Don't clear view if just resetting difficulty in intro, but do if playing again
                                if (gameArea.querySelector('#introView')) return;

                                // Restore intro
                                gameArea.innerHTML = '';
                                const intro = document.createElement('div');
                                intro.className = 'state-message';
                                intro.id = 'introView';
                                intro.innerHTML = `
            <div class="state-title">Ready to Recall?</div>
            <p class="state-desc">Study the numbers shown. Answer the question after they disappear.</p>
            <button class="action-btn" id="startBtnReset">Start Game</button>
        `;
                                gameArea.appendChild(intro);
                                document.getElementById('startBtnReset').addEventListener('click', startGame);
                            }

                            function updateStats() {
                                scoreDisplay.textContent = score;
                                roundDisplay.textContent = round + '/' + maxRounds;
                                streakDisplay.textContent = streak;
                            }

                            function startGame() {
                                round = 1;
                                score = 0;
                                streak = 0;
                                updateStats();
                                startRound();
                            }

                            function startRound() {
                                if (round > maxRounds) {
                                    endGame();
                                    return;
                                }

                                // 1. Generate Numbers
                                const cfg = CONFIG[difficulty];
                                const maxVal = NUM_LIMIT[difficulty];
                                currentNumbers = [];
                                for (let i = 0; i < cfg.count; i++) {
                                    currentNumbers.push(Math.floor(Math.random() * maxVal) + 1);
                                }

                                // 2. Show Numbers View
                                renderNumbers(currentNumbers);

                                // 3. Timer for memorization
                                timerBar.style.width = '100%';
                                timerBar.style.transition = 'width ' + cfg.showTime + 'ms linear';

                                // Force reflow
                                timerBar.offsetHeight;

                                setTimeout(() => { timerBar.style.width = '0%'; }, 50);

                                setTimeout(() => {
                                    generateQuestionAndOptions();
                                }, cfg.showTime);
                            }

                            function renderNumbers(nums) {
                                let html = '<div class="numbers-container">';
                                nums.forEach(n => {
                                    html += '<div class="number-card">' + n + '</div>';
                                });
                                html += '</div>';
                                gameArea.innerHTML = html;
                                gameArea.appendChild(timerBar); // Keep timer bar
                            }

                            function generateQuestionAndOptions() {
                                // Types of questions: Max, Min, Count Even, Count Odd, Was X present?, Position (if ordered?) - let's stick to set properties
                                const types = ['max', 'min', 'count_even', 'count_odd', 'sum'];
                                // Remove 'sum' for hard levels maybe? Or keep it for fewer numbers? Sum is hard for 8 random numbers.
                                // Let's filter types based on difficulty
                                let availTypes = ['max', 'min', 'count_even', 'count_odd'];
                                if (difficulty === 'easy') availTypes.push('sum');

                                // Special: Contains X
                                if (Math.random() > 0.7) availTypes = ['contains'];

                                const type = availTypes[Math.floor(Math.random() * availTypes.length)];

                                let question = "";
                                let answer = 0;
                                let options = [];

                                switch (type) {
                                    case 'max':
                                        question = "What was the LARGEST number?";
                                        answer = Math.max(...currentNumbers);
                                        break;
                                    case 'min':
                                        question = "What was the SMALLEST number?";
                                        answer = Math.min(...currentNumbers);
                                        break;
                                    case 'count_even':
                                        question = "How many EVEN numbers were there?";
                                        answer = currentNumbers.filter(n => n % 2 === 0).length;
                                        break;
                                    case 'count_odd':
                                        question = "How many ODD numbers were there?";
                                        answer = currentNumbers.filter(n => n % 2 !== 0).length;
                                        break;
                                    case 'sum':
                                        question = "What was the SUM of all numbers?";
                                        answer = currentNumbers.reduce((a, b) => a + b, 0);
                                        break;
                                    case 'contains':
                                        // 50% chance to pick a number that was there
                                        const isPresent = Math.random() > 0.5;
                                        if (isPresent) {
                                            answer = currentNumbers[Math.floor(Math.random() * currentNumbers.length)];
                                        } else {
                                            // Pick a number NOT in the set
                                            do {
                                                answer = Math.floor(Math.random() * NUM_LIMIT[difficulty]) + 1;
                                            } while (currentNumbers.includes(answer));
                                        }
                                        question = 'Was the number ' + answer + ' present?';
                                        answer = isPresent ? "Yes" : "No"; // Answer is string here
                                        break;
                                }

                                // Generate Options
                                options = generateOptions(answer, type);

                                renderQuestion(question, options, answer);
                            }

                            function generateOptions(correct, type) {
                                if (type === 'contains') return ["Yes", "No"];

                                let opts = new Set([correct]);
                                while (opts.size < 4) {
                                    let offset = Math.floor(Math.random() * 10) - 5;
                                    if (offset === 0) offset = 1;
                                    let val = correct + offset;

                                    if (type === 'count_even' || type === 'count_odd') {
                                        // Counts are small non-negative integers
                                        val = Math.max(0, val);
                                    } else {
                                        val = Math.max(1, val);
                                    }
                                    opts.add(val);
                                }
                                return Array.from(opts).sort(() => Math.random() - 0.5);
                            }

                            function renderQuestion(text, options, correctAnswer) {
                                let html =
                                    '<div class="question-container">' +
                                    '<div class="timer-bar" style="width:0; opacity:0;"></div>' +
                                    '<div class="question-text">' + text + '</div>' +
                                    '<div class="options-grid">' +
                                    options.map(opt => '<button class="option-btn" data-val="' + opt + '">' + opt + '</button>').join('') +
                                    '</div>' +
                                    '</div>';
                                gameArea.innerHTML = html;

                                // Add listeners
                                gameArea.querySelectorAll('.option-btn').forEach(btn => {
                                    btn.addEventListener('click', () => handleAnswer(btn, correctAnswer));
                                });
                            }

                            function handleAnswer(btn, correct) {
                                const val = btn.dataset.val;
                                // Check if string "Yes"/"No" or number
                                const isCorrect = val == correct; // loose equality for string/number match if data-val converts

                                if (isCorrect) {
                                    btn.classList.add('correct');
                                    streak++;
                                    const points = CONFIG[difficulty].points + (streak * 10);
                                    score += points;
                                    MathMemory.ui.showToast('Correct! +' + points, 'success');
                                } else {
                                    btn.classList.add('wrong');
                                    // Highlight correct
                                    gameArea.querySelectorAll('.option-btn').forEach(b => {
                                        if (b.dataset.val == correct) b.classList.add('correct');
                                    });
                                    streak = 0;
                                    MathMemory.ui.showToast('Wrong!', 'error');
                                }

                                updateStats();

                                // Next round delay
                                setTimeout(() => {
                                    round++;
                                    updateStats();
                                    startRound();
                                }, 1500);
                            }

                            function endGame() {
                                totalGameTime = Math.floor((Date.now() - gameStartTime) / 1000);
                                document.getElementById('finalScore').textContent = score;
                                document.getElementById('finalTime').textContent = 'Time: ' + MathMemory.ui.formatTime(totalGameTime);
                                MathMemory.storage.setHighScore('recall', difficulty, score);
                                winModal.classList.add('active');
                                if (score > 0) MathMemory.ui.confetti();
                            }

                            function shareScore() {
                                MathMemory.share.share('recall', 'Recall', score, difficulty, {
                                    time: totalGameTime,
                                    rounds: maxRounds,
                                    streak: streak
                                });
                                winModal.classList.remove('active');
                            }

                            init();
                        })();
                    </script>