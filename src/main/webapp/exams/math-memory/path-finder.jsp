<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="seo-helper.jsp" %>
        <% String pageKey="path-finder" ; String seoTitle=getSEOTitle(pageKey, application); String
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
                        --neon-rose: #f43f5e;
                        --neon-sky: #0ea5e9;
                        --arcade-dark: #0f172a;
                        --arcade-card: #1e293b;
                        --arcade-border: #334155;
                        --glow-path: 0 0 20px rgba(244, 63, 94, 0.4);
                    }

                    .game-page {
                        background: var(--arcade-dark);
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
                            linear-gradient(45deg, rgba(14, 165, 233, 0.05) 25%, transparent 25%),
                            linear-gradient(-45deg, rgba(14, 165, 233, 0.05) 25%, transparent 25%),
                            linear-gradient(45deg, transparent 75%, rgba(14, 165, 233, 0.05) 75%),
                            linear-gradient(-45deg, transparent 75%, rgba(14, 165, 233, 0.05) 75%);
                        background-size: 40px 40px;
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
                        background: linear-gradient(135deg, var(--neon-rose), var(--neon-sky));
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
                        color: var(--neon-rose);
                    }

                    /* Stats */
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
                        color: var(--neon-rose);
                        text-shadow: var(--glow-path);
                    }

                    .stat-label {
                        font-size: var(--text-xs);
                        color: rgba(255, 255, 255, 0.5);
                        text-transform: uppercase;
                        letter-spacing: 1px;
                    }

                    /* Difficulty */
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
                        border-color: var(--neon-rose);
                        color: white;
                    }

                    .diff-btn.active {
                        border-color: var(--neon-rose);
                        color: var(--neon-rose);
                        box-shadow: var(--glow-path);
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

                    /* Grid */
                    .path-grid {
                        display: grid;
                        gap: var(--space-2);
                        margin-bottom: var(--space-6);
                    }

                    .grid-cell {
                        background: rgba(255, 255, 255, 0.05);
                        border: 1px solid var(--arcade-border);
                        border-radius: var(--radius-md);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 1.5rem;
                        font-weight: 700;
                        color: white;
                        width: 60px;
                        height: 60px;
                        position: relative;
                        transition: all 0.2s;
                    }

                    .grid-cell.highlight {
                        background: var(--neon-rose);
                        color: white;
                        box-shadow: var(--glow-path);
                        border-color: var(--neon-rose);
                        z-index: 2;
                    }

                    .grid-cell.path-line::after {
                        content: '';
                        position: absolute;
                        background: var(--neon-rose);
                        z-index: 1;
                    }

                    /* Lines for path visualization - simplified as just highlighting cells sequentially */

                    /* Input */
                    .answer-section {
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        gap: var(--space-4);
                        animation: slideUp 0.3s;
                    }

                    .question-text {
                        font-size: 1.25rem;
                        color: white;
                        text-align: center;
                        margin-bottom: var(--space-2);
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
                        border-color: var(--neon-rose);
                    }

                    .submit-btn {
                        padding: var(--space-3) var(--space-6);
                        background: var(--neon-rose);
                        border: none;
                        border-radius: var(--radius-md);
                        color: white;
                        font-size: 1.1rem;
                        font-weight: 700;
                        cursor: pointer;
                        box-shadow: var(--glow-path);
                    }

                    /* Timer Bar */
                    .timer-bar {
                        position: absolute;
                        top: 0;
                        left: 0;
                        right: 0;
                        height: 4px;
                        background: var(--neon-sky);
                        width: 0%;
                    }

                    /* States */
                    .state-title {
                        font-size: 2.5rem;
                        color: white;
                        margin-bottom: var(--space-4);
                        font-weight: 800;
                        text-align: center;
                    }

                    .state-desc {
                        color: rgba(255, 255, 255, 0.7);
                        margin-bottom: var(--space-6);
                        font-size: 1.1rem;
                        max-width: 500px;
                        margin-left: auto;
                        margin-right: auto;
                        text-align: center;
                    }

                    .action-btn {
                        padding: var(--space-3) var(--space-8);
                        border: 2px solid var(--neon-rose);
                        border-radius: var(--radius-full);
                        background: var(--neon-rose);
                        color: white;
                        font-size: 1.2rem;
                        font-weight: 700;
                        cursor: pointer;
                        box-shadow: var(--glow-path);
                        transition: transform 0.2s;
                    }

                    .action-btn:hover {
                        transform: scale(1.05);
                    }

                    @keyframes slideUp {
                        from {
                            transform: translateY(20px);
                            opacity: 0;
                        }

                        to {
                            transform: translateY(0);
                            opacity: 1;
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
                        border: 2px solid var(--neon-rose);
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
                                <span class="game-title-icon">&#10547;</span>
                                <h1>Path Finder</h1>
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

                            <div class="state-desc" id="introView">
                                <div class="state-title">Trace the Path</div>
                                <p>
                                    A path will light up across the grid.<br>
                                    Add up the numbers highlighted along the path.<br>
                                    Enter the total sum.
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
                        <div style="font-size:4rem; margin-bottom:1rem;">&#129517;</div>
                        <h2 style="font-size:2rem; font-weight:700; color:white; margin-bottom:1rem;">Path Completed!
                        </h2>
                        <div style="font-size:3rem; font-weight:700; color:var(--neon-rose); margin-bottom:0.5rem;"
                            id="finalScore">0</div>
                        <div style="color:#aaa; margin-bottom:0.5rem;">Total Score</div>
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
                                easy: { rows: 3, cols: 3, steps: 3, speed: 800, points: 100 },
                                medium: { rows: 4, cols: 4, steps: 5, speed: 600, points: 150 },
                                hard: { rows: 5, cols: 5, steps: 7, speed: 500, points: 200 }
                            };

                            // State
                            let difficulty = 'easy';
                            let round = 1;
                            let maxRounds = 10;
                            let score = 0;
                            let streak = 0;
                            let gridData = [];
                            let pathSeq = []; // Array of {r, c, val}
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
                                document.getElementById('shareBtn').addEventListener('click', shareScore);

                                gameArea.addEventListener('keypress', (e) => {
                                    if (e.key === 'Enter' && e.target.classList.contains('answer-input')) {
                                        checkAnswer();
                                    }
                                });
                            }

                            function loadHighScore() {
                                const hs = MathMemory.storage.getHighScore('path-finder', difficulty);
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
                                intro.className = 'state-desc';
                                intro.id = 'introView';
                                intro.innerHTML = `
            <div class="state-title">Trace the Path</div>
            <p>Add up the numbers highlighted along the path.</p>
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

                                const cfg = CONFIG[difficulty];
                                // Generate Grid
                                gridData = [];
                                for (let r = 0; r < cfg.rows; r++) {
                                    let row = [];
                                    for (let c = 0; c < cfg.cols; c++) {
                                        row.push(Math.floor(Math.random() * 9) + 1); // 1-9
                                    }
                                    gridData.push(row);
                                }

                                // Generate Path
                                pathSeq = [];
                                let currR = Math.floor(Math.random() * cfg.rows);
                                let currC = Math.floor(Math.random() * cfg.cols);
                                pathSeq.push({ r: currR, c: currC, val: gridData[currR][currC] });

                                for (let i = 0; i < cfg.steps - 1; i++) {
                                    // Find valid neighbors
                                    const neighbors = [];
                                    if (currR > 0) neighbors.push({ r: currR - 1, c: currC }); // Up
                                    if (currR < cfg.rows - 1) neighbors.push({ r: currR + 1, c: currC }); // Down
                                    if (currC > 0) neighbors.push({ r: currR, c: currC - 1 }); // Left
                                    if (currC < cfg.cols - 1) neighbors.push({ r: currR, c: currC + 1 }); // Right

                                    // Random move, allow backtracking? Sure, why not, makes it confusing/harder
                                    const next = neighbors[Math.floor(Math.random() * neighbors.length)];
                                    currR = next.r;
                                    currC = next.c;
                                    pathSeq.push({ r: currR, c: currC, val: gridData[currR][currC] });
                                }

                                renderGrid();
                                setTimeout(playPath, 1000);
                            }

                            function renderGrid() {
                                const cfg = CONFIG[difficulty];
                                let html = '<div class="path-grid" style="grid-template-columns: repeat(' + cfg.cols + ', 1fr)">';
                                for (let r = 0; r < cfg.rows; r++) {
                                    for (let c = 0; c < cfg.cols; c++) {
                                        html += '<div class="grid-cell" id="cell-' + r + '-' + c + '">' + gridData[r][c] + '</div>';
                                    }
                                }
                                html += '</div>';

                                gameArea.innerHTML = html;
                                gameArea.appendChild(timerBar);
                            }

                            function playPath() {
                                const cfg = CONFIG[difficulty];
                                let step = 0;

                                const interval = setInterval(() => {
                                    // Clear previous highlight
                                    gameArea.querySelectorAll('.grid-cell').forEach(c => c.classList.remove('highlight'));

                                    if (step >= pathSeq.length) {
                                        clearInterval(interval);
                                        renderInputPhase();
                                        return;
                                    }

                                    const p = pathSeq[step];
                                    const cell = document.getElementById('cell-' + p.r + '-' + p.c);
                                    cell.classList.add('highlight');

                                    step++;
                                }, cfg.speed);
                            }

                            function renderInputPhase() {
                                // Clear highlights
                                gameArea.querySelectorAll('.grid-cell').forEach(c => c.classList.remove('highlight'));

                                const html = `
            <div class="answer-section">
                <div class="question-text">Sum of the Path?</div>
                <input type="number" class="answer-input" id="answerInput" placeholder="Sum" autofocus>
                <button class="submit-btn" id="submitBtn">Check</button>
            </div>
        `;

                                const grid = gameArea.querySelector('.path-grid');
                                // keep grid visible

                                const answerDiv = document.createElement('div');
                                answerDiv.innerHTML = html;
                                gameArea.appendChild(answerDiv);

                                setTimeout(() => document.getElementById('answerInput').focus(), 100);
                                document.getElementById('submitBtn').addEventListener('click', checkAnswer);
                            }

                            function checkAnswer() {
                                const input = document.getElementById('answerInput');
                                if (!input.value) return;

                                const userVal = parseInt(input.value);
                                const correctVal = pathSeq.reduce((acc, curr) => acc + curr.val, 0);

                                if (userVal === correctVal) {
                                    streak++;
                                    const points = CONFIG[difficulty].points + (streak * 10);
                                    score += points;
                                    MathMemory.ui.showToast('Correct! +' + points, 'success');
                                } else {
                                    streak = 0;
                                    MathMemory.ui.showToast('Wrong! Sum was ' + correctVal, 'error');
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
                                MathMemory.storage.setHighScore('path-finder', difficulty, score);
                                winModal.classList.add('active');
                                if (score > 0) MathMemory.ui.confetti();
                            }

                            function shareScore() {
                                MathMemory.share.share('path-finder', 'Path Finder', score, difficulty, {
                                    time: totalGameTime,
                                    rounds: maxRounds,
                                    streak: streak
                                });
                                winModal.classList.remove('active');
                            }

                            init();
                        })();
                    </script>