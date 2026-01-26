<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="seo-helper.jsp" %>
        <% String pageKey="symbol-sums" ; String seoTitle=getSEOTitle(pageKey, application); String
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
                        --neon-teal: #2dd4bf;
                        --neon-sapphire: #3b82f6;
                        --arcade-dark: #0f0a1e;
                        --arcade-card: #1a1333;
                        --arcade-border: #2d2255;
                        --glow-teal: 0 0 20px rgba(45, 212, 191, 0.5);
                    }

                    .game-page {
                        background: linear-gradient(135deg, var(--arcade-dark) 0%, #0c1830 50%, var(--arcade-dark) 100%);
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
                            linear-gradient(rgba(45, 212, 191, 0.05) 1px, transparent 1px),
                            linear-gradient(90deg, rgba(45, 212, 191, 0.05) 1px, transparent 1px),
                            linear-gradient(rgba(45, 212, 191, 0.02) 2px, transparent 2px),
                            linear-gradient(90deg, rgba(45, 212, 191, 0.02) 2px, transparent 2px);
                        background-size: 100px 100px, 100px 100px, 20px 20px, 20px 20px;
                        background-position: -2px -2px, -2px -2px, -1px -1px, -1px -1px;
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
                        background: linear-gradient(135deg, var(--neon-teal), var(--neon-sapphire));
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
                        color: var(--neon-teal);
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
                        color: var(--neon-teal);
                        text-shadow: var(--glow-teal);
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
                        border-color: var(--neon-teal);
                        color: white;
                    }

                    .diff-btn.active {
                        border-color: var(--neon-teal);
                        color: var(--neon-teal);
                        box-shadow: var(--glow-teal);
                    }

                    /* Game Area */
                    .game-area {
                        background: var(--arcade-card);
                        border: 2px solid var(--arcade-border);
                        border-radius: var(--radius-xl);
                        min-height: 450px;
                        padding: var(--space-6);
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        justify-content: center;
                        position: relative;
                        box-shadow: 0 0 30px rgba(0, 0, 0, 0.2);
                    }

                    /* Symbols Legend */
                    .legend-grid {
                        display: flex;
                        flex-wrap: wrap;
                        justify-content: center;
                        gap: var(--space-4);
                        margin-bottom: var(--space-8);
                        max-width: 600px;
                    }

                    .legend-item {
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        background: rgba(255, 255, 255, 0.05);
                        border: 1px solid var(--arcade-border);
                        border-radius: var(--radius-lg);
                        padding: var(--space-3);
                        width: 80px;
                        transition: all 0.3s;
                    }

                    .legend-symbol {
                        font-size: 2.5rem;
                        margin-bottom: var(--space-2);
                    }

                    .legend-value {
                        font-size: 1.5rem;
                        font-weight: 700;
                        color: white;
                        transition: opacity 0.5s;
                    }

                    .legend-item.hidden .legend-value {
                        opacity: 0;
                    }

                    .legend-item.revealed {
                        border-color: var(--neon-teal);
                        box-shadow: var(--glow-teal);
                    }

                    /* Problem Area */
                    .problem-container {
                        text-align: center;
                        animation: slideUp 0.4s ease-out;
                        width: 100%;
                    }

                    .problem-equation {
                        font-size: 3rem;
                        font-weight: 700;
                        color: white;
                        margin-bottom: var(--space-6);
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        gap: var(--space-3);
                        flex-wrap: wrap;
                    }

                    .problem-symbol {
                        /* Larger in equation */
                        transform: scale(1.2);
                    }

                    .problem-op {
                        color: var(--neon-teal);
                    }

                    /* Input */
                    .answer-input-container {
                        display: flex;
                        gap: var(--space-2);
                        justify-content: center;
                    }

                    .answer-input {
                        background: rgba(0, 0, 0, 0.3);
                        border: 2px solid var(--arcade-border);
                        border-radius: var(--radius-md);
                        padding: var(--space-3);
                        font-size: 1.5rem;
                        color: white;
                        width: 150px;
                        text-align: center;
                        outline: none;
                        transition: border-color 0.2s;
                    }

                    .answer-input:focus {
                        border-color: var(--neon-teal);
                    }

                    .submit-btn {
                        padding: var(--space-3) var(--space-6);
                        background: var(--neon-teal);
                        border: none;
                        border-radius: var(--radius-md);
                        color: var(--arcade-dark);
                        font-size: 1.1rem;
                        font-weight: 700;
                        cursor: pointer;
                        transition: transform 0.2s;
                    }

                    .submit-btn:hover {
                        transform: scale(1.05);
                    }

                    /* Timer Bar */
                    .timer-bar {
                        position: absolute;
                        top: 0;
                        left: 0;
                        right: 0;
                        height: 4px;
                        background: var(--neon-teal);
                        width: 0%;
                    }

                    /* States */
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
                        max-width: 500px;
                        margin-left: auto;
                        margin-right: auto;
                    }

                    .action-btn {
                        padding: var(--space-3) var(--space-8);
                        border: 2px solid var(--neon-teal);
                        border-radius: var(--radius-full);
                        background: var(--neon-teal);
                        color: var(--arcade-dark);
                        font-size: 1.2rem;
                        font-weight: 700;
                        cursor: pointer;
                        box-shadow: var(--glow-teal);
                        transition: transform 0.2s;
                    }

                    .action-btn:hover {
                        transform: scale(1.05);
                    }

                    @keyframes slideUp {
                        from {
                            opacity: 0;
                            transform: translateY(20px);
                        }

                        to {
                            opacity: 1;
                            transform: translateY(0);
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
                        border: 2px solid var(--neon-teal);
                        border-radius: var(--radius-xl);
                        padding: var(--space-8);
                        text-align: center;
                        max-width: 400px;
                        width: 90%;
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
                                <span class="game-title-icon">&#128302;</span>
                                <h1>Symbol Sums</h1>
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

                            <div class="state-message" id="introView">
                                <div class="state-title">Decrypt the Symbols</div>
                                <p class="state-desc">
                                    Symbols will be assigned random values. Memorize them.<br>
                                    Then solve equations using only the symbols.
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
                        <div style="font-size:4rem; margin-bottom:1rem;">&#128142;</div>
                        <h2 style="font-size:2rem; font-weight:700; color:white; margin-bottom:1rem;">Decryption
                            Complete!</h2>
                        <div style="font-size:3rem; font-weight:700; color:var(--neon-teal); margin-bottom:0.5rem;"
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
                                easy: { count: 3, showTime: 4000, points: 100, maxVal: 9, ops: ['+'] },
                                medium: { count: 4, showTime: 5000, points: 150, maxVal: 15, ops: ['+', '-'] },
                                hard: { count: 5, showTime: 6000, points: 200, maxVal: 20, ops: ['+', '-', 'x'] }
                            };

                            const SYMBOLS = ['★', '♦', '♠', '♣', '●', '▲', '■', '♥', '☠', '⚡'];

                            // State
                            let difficulty = 'easy';
                            let round = 1;
                            let maxRounds = 10;
                            let score = 0;
                            let streak = 0;
                            let currentMap = {}; // { '★': 5, '♦': 3 }
                            let currentSymbols = [];
                            let gameStartTime = null;
                            let totalGameTime = 0;

                            // Elements
                            const gameArea = document.getElementById('gameArea');
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

                                // Enter key for inputs
                                gameArea.addEventListener('keypress', (e) => {
                                    if (e.key === 'Enter' && e.target.classList.contains('answer-input')) {
                                        checkAnswer();
                                    }
                                });

                                document.getElementById('shareBtn').addEventListener('click', shareScore);
                            }

                            function loadHighScore() {
                                const hs = MathMemory.storage.getHighScore('symbol-sums', difficulty);
                                document.getElementById('highScore').textContent = hs > 0 ? hs : '-';
                            }

                            function resetGame() {
                                gameStartTime = Date.now();
                                totalGameTime = 0;
                                round = 1;
                                score = 0;
                                streak = 0;
                                updateStats();
                                if (gameArea.querySelector('#introView')) return;

                                gameArea.innerHTML = '';
                                gameArea.appendChild(timerBar);

                                const intro = document.createElement('div');
                                intro.className = 'state-message';
                                intro.id = 'introView';
                                intro.innerHTML = `
            <div class="state-title">Decrypt the Symbols</div>
            <p class="state-desc">Symbols will be assigned random values. Memorize them.</p>
            <button class="action-btn" id="startBtnReset">Start Game</button>
        `;
                                gameArea.appendChild(intro);
                                document.getElementById('startBtnReset').addEventListener('click', startGame);
                            }

                            function updateStats() {
                                document.getElementById('scoreDisplay').textContent = score;
                                document.getElementById('roundDisplay').textContent = round + '/' + maxRounds;
                                document.getElementById('streakDisplay').textContent = streak;
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

                                generateValues();
                                renderStudyPhase();
                            }

                            function generateValues() {
                                const cfg = CONFIG[difficulty];
                                // Shuffle symbols
                                const shuffledSyms = [...SYMBOLS].sort(() => Math.random() - 0.5);
                                currentSymbols = shuffledSyms.slice(0, cfg.count);

                                currentMap = {};
                                const valuesUsed = new Set();

                                currentSymbols.forEach(sym => {
                                    let val;
                                    do {
                                        val = Math.floor(Math.random() * cfg.maxVal) + 1;
                                    } while (valuesUsed.has(val));
                                    valuesUsed.add(val);
                                    currentMap[sym] = val;
                                });
                            }

                            function renderStudyPhase() {
                                const cfg = CONFIG[difficulty];

                                let html = '<div class="legend-grid">';
                                for (let i = 0; i < currentSymbols.length; i++) {
                                    const sym = currentSymbols[i];
                                    html +=
                                        '<div class="legend-item">' +
                                        '<div class="legend-symbol">' + sym + '</div>' +
                                        '<div class="legend-value">' + currentMap[sym] + '</div>' +
                                        '</div>';
                                }
                                html += '</div>';

                                gameArea.innerHTML = html;
                                gameArea.appendChild(timerBar);

                                // Timer
                                timerBar.style.width = '100%';
                                timerBar.style.transition = 'width ' + cfg.showTime + 'ms linear';
                                timerBar.offsetHeight;
                                setTimeout(() => { timerBar.style.width = '0%'; }, 50);

                                setTimeout(() => {
                                    renderSolvePhase();
                                }, cfg.showTime);
                            }

                            function renderSolvePhase() {
                                // Hide values in legend
                                const items = gameArea.querySelectorAll('.legend-item');
                                items.forEach(item => item.classList.add('hidden'));

                                // Generate Problem
                                const problem = generateProblem();

                                const problemDiv = document.createElement('div');
                                problemDiv.className = 'problem-container';
                                problemDiv.innerHTML = `
            <div class="problem-equation">
                ${problem.html}
                <div class="problem-op">=</div>
                <div class="problem-symbol">?</div>
            </div>
            <div class="answer-input-container">
                <input type="number" class="answer-input" id="answerInput" placeholder="?" autofocus>
                <button class="submit-btn" id="submitBtn">Solve</button>
            </div>
        `;

                                gameArea.appendChild(problemDiv);

                                // Focus input
                                setTimeout(() => document.getElementById('answerInput').focus(), 100);

                                // Store correct answer on element
                                problemDiv.dataset.correct = problem.answer;

                                document.getElementById('submitBtn').addEventListener('click', checkAnswer);
                            }

                            function generateProblem() {
                                const cfg = CONFIG[difficulty];
                                // Pick 2 or 3 symbols involved
                                const numTerms = (difficulty === 'hard' && Math.random() > 0.5) ? 3 : 2;

                                const terms = [];
                                for (let i = 0; i < numTerms; i++) {
                                    terms.push(currentSymbols[Math.floor(Math.random() * currentSymbols.length)]);
                                }

                                let html = '<div class="problem-symbol">' + terms[0] + '</div>';
                                let answer = currentMap[terms[0]];

                                for (let i = 1; i < numTerms; i++) {
                                    const op = cfg.ops[Math.floor(Math.random() * cfg.ops.length)];
                                    html += '<div class="problem-op">' + (op == 'x' ? '×' : op) + '</div>';
                                    html += '<div class="problem-symbol">' + terms[i] + '</div>';

                                    const val = currentMap[terms[i]];
                                    if (op === '+') answer += val;
                                    else if (op === '-') answer -= val;
                                    else if (op === 'x') answer *= val;
                                }

                                return { html, answer };
                            }

                            function checkAnswer() {
                                const input = document.getElementById('answerInput');
                                if (!input.value) return;

                                const userVal = parseInt(input.value);
                                const correctVal = parseInt(gameArea.querySelector('.problem-container').dataset.correct);

                                // Reveal values
                                gameArea.querySelectorAll('.legend-item').forEach(item => {
                                    item.classList.remove('hidden');
                                    item.classList.add('revealed');
                                });

                                if (userVal === correctVal) {
                                    streak++;
                                    const points = CONFIG[difficulty].points + (streak * 10);
                                    score += points;
                                    MathMemory.ui.showToast('Correct! +' + points, 'success');
                                } else {
                                    streak = 0;
                                    MathMemory.ui.showToast('Wrong! It was ' + correctVal, 'error');
                                }

                                updateStats();

                                setTimeout(() => {
                                    round++;
                                    updateStats();
                                    startRound();
                                }, 2000); // 2s delay to see revealed legend
                            }

                            function endGame() {
                                totalGameTime = Math.floor((Date.now() - gameStartTime) / 1000);
                                document.getElementById('finalScore').textContent = score;
                                document.getElementById('finalTime').textContent = 'Time: ' + MathMemory.ui.formatTime(totalGameTime);
                                MathMemory.storage.setHighScore('symbol-sums', difficulty, score);
                                winModal.classList.add('active');
                                if (score > 0) MathMemory.ui.confetti();
                            }

                            function shareScore() {
                                MathMemory.share.share('symbol-sums', 'Symbol Sums', score, difficulty, {
                                    time: totalGameTime,
                                    rounds: maxRounds,
                                    streak: streak
                                });
                                winModal.classList.remove('active');
                            }

                            init();
                        })();
                    </script>