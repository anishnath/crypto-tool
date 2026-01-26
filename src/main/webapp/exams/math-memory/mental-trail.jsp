<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="seo-helper.jsp" %>
        <% String pageKey="mental-trail" ; String seoTitle=getSEOTitle(pageKey, application); String
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
                        --neon-gold: #fbbf24;
                        --neon-red: #ef4444;
                        --arcade-dark: #0f0a1e;
                        --arcade-card: #1a1333;
                        --arcade-border: #2d2255;
                        --glow-gold: 0 0 20px rgba(251, 191, 36, 0.5);
                    }

                    .game-page {
                        background: linear-gradient(135deg, var(--arcade-dark) 0%, #1e110a 50%, var(--arcade-dark) 100%);
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
                            repeating-linear-gradient(45deg, rgba(251, 191, 36, 0.03) 0, rgba(251, 191, 36, 0.03) 1px, transparent 0, transparent 50%);
                        background-size: 30px 30px;
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
                        background: linear-gradient(135deg, var(--neon-gold), var(--neon-red));
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
                        color: var(--neon-gold);
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
                        color: var(--neon-gold);
                        text-shadow: var(--glow-gold);
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
                        border-color: var(--neon-gold);
                        color: white;
                    }

                    .diff-btn.active {
                        border-color: var(--neon-gold);
                        color: var(--neon-gold);
                        box-shadow: var(--glow-gold);
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

                    /* Step Display */
                    .step-container {
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        height: 300px;
                        width: 100%;
                    }

                    .step-content {
                        font-size: 6rem;
                        font-weight: 800;
                        color: white;
                        text-shadow: 0 0 30px rgba(251, 191, 36, 0.3);
                        animation: zoomIn 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
                    }

                    .step-operator {
                        color: var(--neon-gold);
                        margin-right: var(--space-4);
                    }

                    .step-number {
                        color: white;
                    }

                    @keyframes zoomIn {
                        from {
                            transform: scale(0.5);
                            opacity: 0;
                        }

                        to {
                            transform: scale(1);
                            opacity: 1;
                        }
                    }

                    @keyframes fadeOut {
                        to {
                            transform: scale(1.2);
                            opacity: 0;
                        }
                    }

                    /* Answer Phase */
                    .answer-phase {
                        text-align: center;
                        width: 100%;
                        max-width: 400px;
                        animation: slideUp 0.4s ease-out;
                    }

                    .answer-label {
                        font-size: 1.5rem;
                        color: white;
                        margin-bottom: var(--space-6);
                    }

                    .numpad {
                        display: grid;
                        grid-template-columns: repeat(3, 1fr);
                        gap: var(--space-3);
                        margin-bottom: var(--space-6);
                    }

                    .num-btn {
                        background: rgba(255, 255, 255, 0.05);
                        border: 1px solid var(--arcade-border);
                        border-radius: var(--radius-lg);
                        padding: var(--space-4);
                        font-size: 1.5rem;
                        font-weight: 600;
                        color: white;
                        cursor: pointer;
                        transition: all 0.1s;
                    }

                    .num-btn:hover {
                        background: rgba(251, 191, 36, 0.1);
                        border-color: var(--neon-gold);
                    }

                    .num-btn:active {
                        transform: scale(0.95);
                    }

                    .answer-display {
                        background: rgba(0, 0, 0, 0.3);
                        border: 2px solid var(--neon-gold);
                        border-radius: var(--radius-lg);
                        padding: var(--space-4);
                        font-size: 2.5rem;
                        font-weight: 700;
                        color: white;
                        margin-bottom: var(--space-6);
                        min-height: 80px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        letter-spacing: 2px;
                    }

                    .submit-btn {
                        width: 100%;
                        padding: var(--space-4);
                        background: var(--neon-gold);
                        border: none;
                        border-radius: var(--radius-lg);
                        color: var(--arcade-dark);
                        font-size: 1.25rem;
                        font-weight: 700;
                        cursor: pointer;
                        transition: transform 0.2s;
                        box-shadow: var(--glow-gold);
                    }

                    .submit-btn:hover {
                        transform: scale(1.02);
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

                    /* Intro/States */
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
                        line-height: 1.6;
                    }

                    .start-btn {
                        padding: var(--space-3) var(--space-8);
                        border: 2px solid var(--neon-gold);
                        border-radius: var(--radius-full);
                        background: var(--neon-gold);
                        color: var(--arcade-dark);
                        font-size: 1.2rem;
                        font-weight: 700;
                        cursor: pointer;
                        box-shadow: var(--glow-gold);
                        transition: transform 0.2s;
                    }

                    .start-btn:hover {
                        transform: scale(1.05);
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
                        border: 2px solid var(--neon-gold);
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

                    /* Progress Bar */
                    .progress-bar-container {
                        position: absolute;
                        top: 0;
                        left: 0;
                        right: 0;
                        height: 6px;
                        background: rgba(255, 255, 255, 0.1);
                    }

                    .progress-bar {
                        height: 100%;
                        background: var(--neon-gold);
                        width: 0%;
                        transition: width 0.3s;
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
                                <span class="game-title-icon">&#129699;</span>
                                <h1>Mental Trail</h1>
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
                            <div class="progress-bar-container">
                                <div class="progress-bar" id="progressBar"></div>
                            </div>

                            <div class="state-message" id="introView">
                                <div class="state-title">Follow the Trail</div>
                                <p class="state-desc">
                                    A starting number will appear, followed by a series of operations.<br>
                                    Keep the running total in your head. Enter the final result.
                                </p>
                                <button class="start-btn" id="startBtn">Start Game</button>
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
                        <div style="font-size:4rem; margin-bottom:1rem;">&#127942;</div>
                        <h2 style="font-size:2rem; font-weight:700; color:white; margin-bottom:1rem;">Trail Completed!
                        </h2>
                        <div style="font-size:3rem; font-weight:700; color:var(--neon-gold); margin-bottom:0.5rem;"
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
                                easy: { steps: 3, speed: 2000, points: 100, ops: ['+', '-'], maxNum: 10 },
                                medium: { steps: 5, speed: 1500, points: 200, ops: ['+', '-', 'x'], maxNum: 15 },
                                hard: { steps: 8, speed: 1200, points: 300, ops: ['+', '-', 'x'], maxNum: 20 }
                            };

                            // State
                            let difficulty = 'easy';
                            let round = 1;
                            let maxRounds = 10;
                            let score = 0;
                            let streak = 0;
                            let currentTotal = 0;
                            let inputBuffer = '';
                            let gameStartTime = null;
                            let totalGameTime = 0;

                            // Elements
                            const gameArea = document.getElementById('gameArea');
                            const scoreDisplay = document.getElementById('scoreDisplay');
                            const roundDisplay = document.getElementById('roundDisplay');
                            const streakDisplay = document.getElementById('streakDisplay');
                            const progressBar = document.getElementById('progressBar');
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
                                const hs = MathMemory.storage.getHighScore('mental-trail', difficulty);
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
                                gameArea.appendChild(progressBar.parentElement); // Restore progress bar container

                                const intro = document.createElement('div');
                                intro.className = 'state-message';
                                intro.id = 'introView';
                                intro.innerHTML = `
            <div class="state-title">Follow the Trail</div>
            <p class="state-desc">A starting number will appear, followed by a series of operations.</p>
            <button class="start-btn" id="startBtnReset">Start Game</button>
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

                                // Generate Trail
                                const cfg = CONFIG[difficulty];
                                let steps = [];

                                // Initial Number
                                let current = Math.floor(Math.random() * cfg.maxNum) + 1;
                                steps.push({ type: 'start', val: current, text: current });

                                for (let i = 0; i < cfg.steps; i++) {
                                    const op = cfg.ops[Math.floor(Math.random() * cfg.ops.length)];
                                    let val = Math.floor(Math.random() * 10) + 1;

                                    // Logic to keep numbers reasonable
                                    if (op === 'x') {
                                        val = Math.floor(Math.random() * 3) + 2; // only x2, x3, x4
                                        // Avoid getting too huge
                                        if (current > 50) {
                                            // Change to subtraction if too big
                                            steps.push({ type: 'op', val: 5, text: '- 5', apply: (x) => x - 5 });
                                            current -= 5;
                                            continue;
                                        }
                                    }
                                    if (op === '-') {
                                        // simple heuristic to avoid negative if desired, or allow them
                                        // Let's allow simple negatives but generally try to keep positive for Easy
                                        if (difficulty === 'easy' && current < val) val = Math.floor(Math.random() * current);
                                    }

                                    let applyFn;
                                    let text = op + ' ' + val;

                                    switch (op) {
                                        case '+': applyFn = (x) => x + val; current += val; break;
                                        case '-': applyFn = (x) => x - val; current -= val; break;
                                        case 'x': applyFn = (x) => x * val; current *= val; break;
                                    }

                                    steps.push({ type: 'op', val: val, text: text, apply: applyFn });
                                }

                                currentTotal = current;
                                playTrail(steps, cfg.speed);
                            }

                            function playTrail(steps, speed) {
                                // Clear area
                                gameArea.innerHTML = '';
                                gameArea.appendChild(progressBar.parentElement);
                                progressBar.style.width = '0%';

                                let i = 0;

                                function showStep() {
                                    if (i >= steps.length) {
                                        showInput();
                                        return;
                                    }

                                    const step = steps[i];
                                    const el = document.createElement('div');
                                    el.className = 'step-container';
                                    el.innerHTML = '<div class="step-content">' + step.text + '</div>';

                                    gameArea.appendChild(el);

                                    // Progress
                                    progressBar.style.width = ((i + 1) / steps.length * 100) + '%';

                                    // Animate out
                                    setTimeout(() => {
                                        el.style.animation = 'fadeOut 0.2s ease-in forwards';
                                        setTimeout(() => {
                                            el.remove();
                                            // Inter-stimulus interval (blank screen)
                                            setTimeout(() => {
                                                i++;
                                                showStep();
                                            }, 200); // 200ms blank
                                        }, 200);
                                    }, speed);
                                }

                                showStep();
                            }

                            function showInput() {
                                inputBuffer = '';
                                gameArea.innerHTML =
                                    '<div class="answer-phase">' +
                                    '<div class="answer-label">What is the result?</div>' +
                                    '<div class="answer-display" id="answerDisplay">?</div>' +
                                    '<div class="numpad">' +
                                    '<button class="num-btn" data-key="1">1</button>' +
                                    '<button class="num-btn" data-key="2">2</button>' +
                                    '<button class="num-btn" data-key="3">3</button>' +
                                    '<button class="num-btn" data-key="4">4</button>' +
                                    '<button class="num-btn" data-key="5">5</button>' +
                                    '<button class="num-btn" data-key="6">6</button>' +
                                    '<button class="num-btn" data-key="7">7</button>' +
                                    '<button class="num-btn" data-key="8">8</button>' +
                                    '<button class="num-btn" data-key="9">9</button>' +
                                    '<button class="num-btn" data-key="-">-</button>' +
                                    '<button class="num-btn" data-key="0">0</button>' +
                                    '<button class="num-btn" data-key="back">&#9003;</button>' +
                                    '</div>' +
                                    '<button class="submit-btn" id="submitAnswer">Submit</button>' +
                                    '</div>';
                                gameArea.appendChild(progressBar.parentElement);

                                document.querySelectorAll('.num-btn').forEach(btn => {
                                    btn.addEventListener('click', () => handleInput(btn.dataset.key));
                                });

                                document.getElementById('submitAnswer').addEventListener('click', checkAnswer);
                            }

                            function handleInput(key) {
                                if (key === 'back') {
                                    inputBuffer = inputBuffer.slice(0, -1);
                                } else {
                                    if (inputBuffer.length < 5) inputBuffer += key;
                                }
                                document.getElementById('answerDisplay').textContent = inputBuffer || '?';
                            }

                            function checkAnswer() {
                                const val = parseInt(inputBuffer);
                                if (isNaN(val)) return;

                                if (val === currentTotal) {
                                    streak++;
                                    const points = CONFIG[difficulty].points + (streak * 10);
                                    score += points;
                                    MathMemory.ui.showToast('Correct! +' + points, 'success');
                                } else {
                                    streak = 0;
                                    MathMemory.ui.showToast('Wrong! It was ' + currentTotal, 'error');
                                }

                                updateStats();

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
                                MathMemory.storage.setHighScore('mental-trail', difficulty, score);
                                winModal.classList.add('active');
                                if (score > 0) MathMemory.ui.confetti();
                            }

                            function shareScore() {
                                MathMemory.share.share('mental-trail', 'Mental Trail', score, difficulty, {
                                    time: totalGameTime,
                                    rounds: maxRounds,
                                    streak: streak
                                });
                                winModal.classList.remove('active');
                            }

                            init();
                        })();
                    </script>