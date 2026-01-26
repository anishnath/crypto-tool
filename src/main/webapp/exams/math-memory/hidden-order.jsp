<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="seo-helper.jsp" %>
        <% String pageKey="hidden-order" ; String seoTitle=getSEOTitle(pageKey, application); String
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
                        --neon-blue: #3b82f6;
                        --neon-indigo: #6366f1;
                        --arcade-dark: #0f0a1e;
                        --arcade-card: #1a1333;
                        --arcade-border: #2d2255;
                        --glow-blue: 0 0 20px rgba(59, 130, 246, 0.5);
                    }

                    .game-page {
                        background: linear-gradient(135deg, var(--arcade-dark) 0%, #0c1a2e 50%, var(--arcade-dark) 100%);
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
                            linear-gradient(rgba(59, 130, 246, 0.03) 1px, transparent 1px),
                            linear-gradient(90deg, rgba(59, 130, 246, 0.03) 1px, transparent 1px);
                        background-size: 50px 50px;
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
                        background: linear-gradient(135deg, var(--neon-blue), var(--neon-indigo));
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
                        color: var(--neon-blue);
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
                        color: var(--neon-blue);
                        text-shadow: var(--glow-blue);
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
                        border-color: var(--neon-blue);
                        color: white;
                    }

                    .diff-btn.active {
                        border-color: var(--neon-blue);
                        color: var(--neon-blue);
                        box-shadow: var(--glow-blue);
                    }

                    /* Round Indicator */
                    .round-indicator {
                        text-align: center;
                        margin-bottom: var(--space-4);
                        font-size: var(--text-sm);
                        color: rgba(255, 255, 255, 0.5);
                    }

                    .round-indicator span {
                        color: var(--neon-blue);
                        font-weight: 600;
                    }

                    /* Game Area */
                    .game-area {
                        background: var(--arcade-card);
                        border: 2px solid var(--arcade-border);
                        border-radius: var(--radius-xl);
                        min-height: 400px;
                        position: relative;
                        overflow: hidden;
                        cursor: crosshair;
                    }

                    /* Cells */
                    .number-cell {
                        position: absolute;
                        width: 60px;
                        height: 60px;
                        background: linear-gradient(135deg, #0a1a2e, var(--arcade-card));
                        border: 2px solid var(--neon-blue);
                        border-radius: 50%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: var(--text-xl);
                        font-weight: 700;
                        color: white;
                        cursor: pointer;
                        transition: transform 0.2s, background 0.2s, opacity 0.3s;
                        user-select: none;
                        box-shadow: 0 0 10px rgba(59, 130, 246, 0.3);
                    }

                    .number-cell:hover {
                        transform: scale(1.1);
                        box-shadow: 0 0 20px rgba(59, 130, 246, 0.6);
                    }

                    .number-cell.obscured {
                        color: transparent;
                        background: #2d2255;
                        border-color: #4b5563;
                    }

                    .number-cell.correct {
                        background: var(--neon-blue);
                        border-color: var(--neon-indigo);
                        animation: pop 0.3s ease-out;
                        opacity: 0;
                        pointer-events: none;
                    }

                    .number-cell.wrong {
                        background: #ef4444;
                        border-color: #ef4444;
                        animation: shake 0.4s ease;
                    }

                    @keyframes pop {
                        0% {
                            transform: scale(1);
                            opacity: 1;
                        }

                        100% {
                            transform: scale(1.5);
                            opacity: 0;
                        }
                    }

                    @keyframes shake {

                        0%,
                        100% {
                            transform: translateX(0);
                        }

                        25% {
                            transform: translateX(-5px);
                        }

                        75% {
                            transform: translateX(5px);
                        }
                    }

                    /* Ready State */
                    .ready-state {
                        position: absolute;
                        top: 50%;
                        left: 50%;
                        transform: translate(-50%, -50%);
                        text-align: center;
                        width: 100%;
                    }

                    .ready-text {
                        font-size: var(--text-2xl);
                        color: white;
                        margin-bottom: var(--space-4);
                        font-weight: 700;
                        text-shadow: 0 0 20px rgba(0, 0, 0, 0.5);
                    }

                    .ready-sub {
                        font-size: var(--text-base);
                        color: rgba(255, 255, 255, 0.7);
                        margin-bottom: var(--space-6);
                        max-width: 400px;
                        margin-left: auto;
                        margin-right: auto;
                    }

                    .start-btn {
                        padding: var(--space-4) var(--space-8);
                        border: 2px solid var(--neon-blue);
                        border-radius: var(--radius-lg);
                        background: var(--neon-blue);
                        color: white;
                        font-size: var(--text-xl);
                        font-weight: 700;
                        cursor: pointer;
                        transition: all 0.2s;
                        box-shadow: var(--glow-blue);
                    }

                    .start-btn:hover {
                        transform: scale(1.05);
                    }

                    /* Game Controls */
                    .game-controls {
                        display: flex;
                        justify-content: center;
                        gap: var(--space-4);
                        margin-top: var(--space-6);
                    }

                    /* Win Modal */
                    .win-modal {
                        position: fixed;
                        top: 0;
                        left: 0;
                        right: 0;
                        bottom: 0;
                        background: rgba(0, 0, 0, 0.8);
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
                        border: 2px solid var(--neon-blue);
                        border-radius: var(--radius-xl);
                        padding: var(--space-8);
                        text-align: center;
                        max-width: 400px;
                        width: 90%;
                        box-shadow: 0 0 60px rgba(59, 130, 246, 0.3);
                        transform: scale(0.9);
                        transition: transform 0.3s;
                    }

                    .win-modal.active .win-content {
                        transform: scale(1);
                    }

                    .win-icon {
                        font-size: 4rem;
                        margin-bottom: var(--space-4);
                    }

                    /* Ad Containers */
                    .ad-container-top,
                    .ad-container-bottom {
                        display: flex;
                        justify-content: center;
                        margin: var(--space-4) 0;
                    }

                    .ad-container-top {
                        margin-bottom: var(--space-6);
                    }

                    .ad-container-bottom {
                        margin-top: var(--space-6);
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

                    @media (max-width: 600px) {
                        .game-area {
                            min-height: 300px;
                        }

                        .number-cell {
                            width: 45px;
                            height: 45px;
                            font-size: var(--text-lg);
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
                                <h1>Hidden Order</h1>
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
                                <div class="stat-value" id="levelDisplay">1</div>
                                <div class="stat-label">Level</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value" id="livesDisplay">3</div>
                                <div class="stat-label">Lives</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value" id="highScore">-</div>
                                <div class="stat-label">Best</div>
                            </div>
                        </div>

                        <!-- Difficulty -->
                        <div class="difficulty-selector">
                            <button class="diff-btn active" data-difficulty="easy">Easy (4 nums)</button>
                            <button class="diff-btn" data-difficulty="medium">Medium (6 nums)</button>
                            <button class="diff-btn" data-difficulty="hard">Hard (9 nums)</button>
                        </div>

                        <div class="round-indicator">
                            Level <span id="currentLevel">1</span>
                        </div>

                        <!-- Game Area -->
                        <div class="game-area tex2jax_ignore" id="gameArea">
                            <div class="ready-state" id="readyState">
                                <p class="ready-text">Memorize the Order!</p>
                                <p class="ready-sub">Numbers will appear then fade. Click them in ascending order (1, 2,
                                    3...)</p>
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
                        <div class="win-icon">&#127942;</div>
                        <h2 class="win-title"
                            style="font-size:2rem; font-weight:700; color:var(--neon-blue); margin-bottom:1rem;">Game
                            Over</h2>
                        <p style="color:#aaa; margin-bottom: 2rem;">You reached Level <span id="finalLevel"
                                style="color:white; font-weight:bold;">1</span></p>

                        <div style="display:flex; justify-content:center; gap:2rem; margin-bottom:2rem;">
                            <div>
                                <div style="font-size:2rem; font-weight:700; color:var(--neon-blue);" id="finalScore">0
                                </div>
                                <div style="font-size:0.875rem; color:#666; text-transform:uppercase;">Score</div>
                            </div>
                        </div>

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
                                easy: { count: 4, time: 2000, points: 100 },
                                medium: { count: 6, time: 3000, points: 200 },
                                hard: { count: 9, time: 4000, points: 300 }
                            };

                            // State
                            let difficulty = 'easy';
                            let level = 1;
                            let score = 0;
                            let lives = 3;
                            let currentNumbers = [];
                            let nextExpected = 1;
                            let gameActive = false;
                            let gameStartTime = null;
                            let totalGameTime = 0;

                            // Elements
                            const gameArea = document.getElementById('gameArea');
                            const scoreDisplay = document.getElementById('scoreDisplay');
                            const levelDisplay = document.getElementById('levelDisplay');
                            const livesDisplay = document.getElementById('livesDisplay');
                            const readyState = document.getElementById('readyState');
                            const winModal = document.getElementById('winModal');
                            const diffButtons = document.querySelectorAll('.diff-btn');
                            const startBtn = document.getElementById('startBtn');

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

                                startBtn.addEventListener('click', startGame);
                                document.getElementById('playAgainBtn').addEventListener('click', () => {
                                    winModal.classList.remove('active');
                                    resetGame();
                                });
                                document.getElementById('shareBtn').addEventListener('click', shareScore);
                            }

                            function loadHighScore() {
                                const hs = MathMemory.storage.getHighScore('hidden-order', difficulty);
                                document.getElementById('highScore').textContent = hs > 0 ? hs : '-';
                            }

                            function resetGame() {
                                gameStartTime = Date.now();
                                totalGameTime = 0;
                                level = 1;
                                score = 0;
                                lives = 3;
                                updateStats();
                                readyState.style.display = 'block';
                                gameArea.innerHTML = '';
                                gameArea.appendChild(readyState);
                            }

                            function updateStats() {
                                scoreDisplay.textContent = score;
                                levelDisplay.textContent = level;
                                livesDisplay.textContent = lives;
                                document.getElementById('currentLevel').textContent = level;
                            }

                            function startGame() {
                                gameActive = true;
                                readyState.style.display = 'none';
                                startLevel();
                            }

                            function startLevel() {
                                // Clear board
                                gameArea.innerHTML = '';
                                nextExpected = 1;

                                // Generate numbers
                                const count = CONFIG[difficulty].count + Math.floor((level - 1) / 3); // Increase count every 3 levels slightly? No, stick to config for now but maybe speed up?
                                // Let's actually keep count constant per difficulty but reduce time slightly?
                                const currentCount = Math.min(CONFIG[difficulty].count + Math.floor((level - 1) / 5), 15); // Cap at 15

                                currentNumbers = [];
                                const positions = [];

                                // Generate positions avoiding overlap
                                const padding = 60;
                                const width = gameArea.offsetWidth - padding;
                                const height = gameArea.offsetHeight - padding;

                                for (let i = 1; i <= currentCount; i++) {
                                    let x, y, valid;
                                    let attempts = 0;
                                    do {
                                        valid = true;
                                        x = Math.random() * width;
                                        y = Math.random() * height;

                                        // Check overlap
                                        for (let pos of positions) {
                                            const dx = x - pos.x;
                                            const dy = y - pos.y;
                                            if (Math.sqrt(dx * dx + dy * dy) < 70) {
                                                valid = false;
                                                break;
                                            }
                                        }
                                        attempts++;
                                    } while (!valid && attempts < 100);

                                    if (valid) {
                                        positions.push({ x, y });
                                        createNumberCell(i, x, y);
                                    }
                                }

                                // Hide numbers after delay
                                const timeToMemorize = Math.max(1000, CONFIG[difficulty].time - (level * 100));

                                setTimeout(() => {
                                    if (!gameActive) return;
                                    const cells = document.querySelectorAll('.number-cell');
                                    cells.forEach(cell => cell.classList.add('obscured'));
                                }, timeToMemorize);
                            }

                            function createNumberCell(num, x, y) {
                                const cell = document.createElement('div');
                                cell.className = 'number-cell';
                                cell.textContent = num;
                                cell.style.left = (x + 30) + 'px'; // Center it
                                cell.style.top = (y + 30) + 'px';
                                cell.dataset.num = num;

                                cell.addEventListener('mousedown', (e) => {
                                    e.preventDefault(); // Prevent accidental selection
                                    handleCellClick(cell, num);
                                });

                                gameArea.appendChild(cell);
                            }

                            function handleCellClick(cell, num) {
                                if (!gameActive) return;
                                if (!cell.classList.contains('obscured')) {
                                    // If they click before obscured (optional: allow or ignore? usually wait)
                                    // Let's allow it but it doesn't really matter
                                }

                                if (num === nextExpected) {
                                    // Correct
                                    cell.classList.remove('obscured');
                                    cell.classList.add('correct');
                                    // Play sound?
                                    nextExpected++;

                                    // Level Complete?
                                    const total = document.querySelectorAll('.number-cell').length;
                                    if (nextExpected > total) {
                                        handleLevelComplete();
                                    }
                                } else {
                                    // Wrong
                                    cell.classList.remove('obscured'); // Reveal mistake
                                    cell.classList.add('wrong');
                                    handleMistake();
                                }
                            }

                            function handleLevelComplete() {
                                const bonus = CONFIG[difficulty].points + (level * 10);
                                score += bonus;
                                level++;
                                MathMemory.ui.showToast('Level Complete! +' + bonus, 'success');
                                updateStats();

                                setTimeout(startLevel, 1000);
                            }

                            function handleMistake() {
                                lives--;
                                updateStats();
                                MathMemory.ui.showToast('Wrong! Lives left: ' + lives, 'error');

                                // Show correct order briefly?
                                const cells = document.querySelectorAll('.number-cell');
                                cells.forEach(c => c.classList.remove('obscured'));

                                if (lives <= 0) {
                                    endGame();
                                } else {
                                    gameActive = false;
                                    setTimeout(() => {
                                        gameActive = true;
                                        startLevel(); // Retry level
                                    }, 2000);
                                }
                            }

                            function endGame() {
                                gameActive = false;
                                totalGameTime = Math.floor((Date.now() - gameStartTime) / 1000);
                                document.getElementById('finalScore').textContent = score;
                                document.getElementById('finalLevel').textContent = level;
                                document.getElementById('finalTime').textContent = 'Time: ' + MathMemory.ui.formatTime(totalGameTime);

                                // Check High Score
                                if (MathMemory.storage.setHighScore('hidden-order', difficulty, score)) {
                                    MathMemory.ui.showToast('New High Score!', 'success');
                                }

                                winModal.classList.add('active');
                            }

                            function shareScore() {
                                MathMemory.share.share('hidden-order', 'Hidden Order', score, difficulty, {
                                    time: totalGameTime,
                                    rounds: level,
                                    streak: level
                                });
                                winModal.classList.remove('active');
                            }

                            init();
                        })();
                    </script>