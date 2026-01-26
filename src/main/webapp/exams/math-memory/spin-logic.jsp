<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="seo-helper.jsp" %>
        <% String pageKey="spin-logic" ; String seoTitle=getSEOTitle(pageKey, application); String
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
                        --neon-solar: #f59e0b;
                        --neon-flame: #ef4444;
                        --arcade-dark: #1a1005;
                        --arcade-card: #2d1805;
                        --arcade-border: #4d2805;
                        --glow-solar: 0 0 20px rgba(245, 158, 11, 0.4);
                    }

                    .game-page {
                        background: linear-gradient(135deg, var(--arcade-dark) 0%, #000 100%);
                        min-height: 100vh;
                        padding-bottom: var(--space-8);
                    }

                    .game-page::before {
                        content: '';
                        position: fixed;
                        top: 50%;
                        left: 50%;
                        width: 200vmax;
                        height: 200vmax;
                        background: conic-gradient(from 0deg, transparent 0deg, rgba(245, 158, 11, 0.05) 90deg, transparent 180deg);
                        transform: translate(-50%, -50%);
                        animation: rotateBg 20s linear infinite;
                        pointer-events: none;
                        z-index: 0;
                    }

                    @keyframes rotateBg {
                        from {
                            transform: translate(-50%, -50%) rotate(0deg);
                        }

                        to {
                            transform: translate(-50%, -50%) rotate(360deg);
                        }
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
                        animation: spinIcon 10s linear infinite;
                    }

                    @keyframes spinIcon {
                        to {
                            transform: rotate(360deg);
                        }
                    }

                    .game-title h1 {
                        font-size: var(--text-2xl);
                        font-weight: 700;
                        background: linear-gradient(135deg, var(--neon-solar), var(--neon-flame));
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
                        color: var(--neon-solar);
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
                        color: var(--neon-solar);
                        text-shadow: var(--glow-solar);
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
                        border-color: var(--neon-solar);
                        color: white;
                    }

                    .diff-btn.active {
                        border-color: var(--neon-solar);
                        color: var(--neon-solar);
                        box-shadow: var(--glow-solar);
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
                        overflow: hidden;
                    }

                    /* Grid */
                    .spin-grid {
                        display: grid;
                        gap: var(--space-2);
                        background: rgba(0, 0, 0, 0.3);
                        padding: var(--space-3);
                        border-radius: var(--radius-lg);
                        border: 1px solid var(--arcade-border);
                        transition: all 1s ease-in-out;
                    }

                    .grid-cell {
                        background: rgba(245, 158, 11, 0.1);
                        border: 1px solid rgba(245, 158, 11, 0.2);
                        border-radius: var(--radius-md);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 1.5rem;
                        font-weight: 700;
                        color: white;
                        width: 60px;
                        height: 60px;
                    }

                    .grid-cell.highlight {
                        background: var(--neon-solar);
                        color: black;
                        box-shadow: var(--glow-solar);
                    }

                    /* Operation Displayer */
                    .ops-display {
                        font-size: 1.5rem;
                        color: var(--neon-solar);
                        margin-bottom: var(--space-6);
                        text-align: center;
                        min-height: 60px;
                    }

                    .op-text {
                        animation: fadeIn 0.3s;
                    }

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
                        border-color: var(--neon-solar);
                    }

                    .submit-btn {
                        padding: var(--space-3) var(--space-6);
                        background: var(--neon-solar);
                        border: none;
                        border-radius: var(--radius-md);
                        color: black;
                        font-size: 1.1rem;
                        font-weight: 700;
                        cursor: pointer;
                        box-shadow: var(--glow-solar);
                    }

                    /* Timer Bar */
                    .timer-bar {
                        position: absolute;
                        top: 0;
                        left: 0;
                        right: 0;
                        height: 4px;
                        background: var(--neon-solar);
                        width: 0%;
                    }

                    /* States */
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
                        text-align: center;
                    }

                    .action-btn {
                        padding: var(--space-3) var(--space-8);
                        border: 2px solid var(--neon-solar);
                        border-radius: var(--radius-full);
                        background: var(--neon-solar);
                        color: black;
                        font-size: 1.2rem;
                        font-weight: 700;
                        cursor: pointer;
                        box-shadow: var(--glow-solar);
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

                    @keyframes fadeIn {
                        from {
                            opacity: 0;
                        }

                        to {
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
                        border: 2px solid var(--neon-solar);
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
                                <span class="game-title-icon">&#9881;</span>
                                <h1>Spin Logic</h1>
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
                                <div class="state-title">Mental Rotation</div>
                                <p>
                                    A grid of numbers will appear. Memorize it.<br>
                                    The grid will rotate (90°, 180°, etc) in your mind.<br>
                                    Recall the number at a specific position.
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
                        <div style="font-size:4rem; margin-bottom:1rem;">&#11088;</div>
                        <h2 style="font-size:2rem; font-weight:700; color:white; margin-bottom:1rem;">Rotation Master!</h2>
                        <div style="font-size:3rem; font-weight:700; color:var(--neon-solar); margin-bottom:0.5rem;"
                            id="finalScore">0</div>
                        <div style="color:#aaa; margin-bottom:1rem;">Total Score</div>
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
                                easy: { rows: 2, cols: 2, showTime: 3000, points: 100, rot: ['90° CW'] },
                                medium: { rows: 3, cols: 3, showTime: 4000, points: 150, rot: ['90° CW', '90° CCW', '180°'] },
                                hard: { rows: 4, cols: 4, showTime: 5000, points: 200, rot: ['90° CW', '90° CCW', '180°', '270° CW'] }
                            };

                            // State
                            let difficulty = 'easy';
                            let round = 1;
                            let maxRounds = 10;
                            let score = 0;
                            let streak = 0;
                            let gridData = []; // 2D array
                            let currentRot = '';
                            let targetPos = { r: 0, c: 0 }; // The position we ask about
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

                                // Enter key
                                gameArea.addEventListener('keypress', (e) => {
                                    if (e.key === 'Enter' && e.target.classList.contains('answer-input')) {
                                        checkAnswer();
                                    }
                                });
                            }

                            function loadHighScore() {
                                const hs = MathMemory.storage.getHighScore('spin-logic', difficulty);
                                document.getElementById('highScore').textContent = hs > 0 ? hs : '-';
                            }

                            function resetGame() {
                                round = 1;
                                score = 0;
                                streak = 0;
                                gameStartTime = Date.now();
                                totalGameTime = 0;
                                updateStats();
                                if (gameArea.querySelector('#introView')) return;

                                gameArea.innerHTML = '';
                                gameArea.appendChild(timerBar);

                                const intro = document.createElement('div');
                                intro.className = 'state-desc';
                                intro.id = 'introView';
                                intro.innerHTML = `
            <div class="state-title">Mental Rotation</div>
            <p>A grid of numbers will appear. Memorize it.</p>
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
                                        row.push(Math.floor(Math.random() * 99) + 1);
                                    }
                                    gridData.push(row);
                                }

                                // Pick rotation
                                currentRot = cfg.rot[Math.floor(Math.random() * cfg.rot.length)];

                                // Pick random position to query (on the ROTATED grid)
                                targetPos = {
                                    r: Math.floor(Math.random() * cfg.rows),
                                    c: Math.floor(Math.random() * cfg.cols)
                                };

                                renderStudyPhase();
                            }

                            function renderStudyPhase() {
                                const cfg = CONFIG[difficulty];

                                let gridHtml = '<div class="spin-grid" style="grid-template-columns: repeat(' + cfg.cols + ', 1fr)">';
                                for (let r = 0; r < cfg.rows; r++) {
                                    for (let c = 0; c < cfg.cols; c++) {
                                        gridHtml += '<div class="grid-cell">' + gridData[r][c] + '</div>';
                                    }
                                }
                                gridHtml += '</div>';

                                gameArea.innerHTML = gridHtml;
                                gameArea.appendChild(timerBar);

                                timerBar.style.width = '100%';
                                timerBar.style.transition = 'width ' + cfg.showTime + 'ms linear';
                                timerBar.offsetHeight;
                                setTimeout(() => { timerBar.style.width = '0%'; }, 50);

                                setTimeout(() => {
                                    renderRotationPhase();
                                }, cfg.showTime);
                            }

                            function renderRotationPhase() {
                                const grid = gameArea.querySelector('.spin-grid');

                                // Animate Rotation
                                let deg = 0;
                                if (currentRot === '90° CW') deg = 90;
                                else if (currentRot === '90° CCW') deg = -90;
                                else if (currentRot === '180°') deg = 180;
                                else if (currentRot === '270° CW') deg = 270;

                                // Blur/Fade content?
                                const cells = grid.querySelectorAll('.grid-cell');
                                cells.forEach(c => c.textContent = '?'); // Hide numbers but keep grid

                                grid.style.transform = 'rotate(' + deg + 'deg)';

                                // Show Instruction
                                const ops = document.createElement('div');
                                ops.className = 'ops-display';
                                ops.innerHTML = '<div class="op-text">Rotated ' + currentRot + '</div>';
                                gameArea.insertBefore(ops, grid); // Put before

                                setTimeout(() => {
                                    renderQueryPhase();
                                }, 1500); // 1.5s for rotation mental processing
                            }

                            function renderQueryPhase() {
                                const cfg = CONFIG[difficulty];

                                // We need to visually clean up the rotation for input phase?
                                // Or keep it rotated?
                                // "What number is NOW in top-right?"
                                // If we keep the grid rotated 90deg, "Top-Right" visually is different.
                                // Usually these tests imply: The grid rotates in your head. The question refers to the *new* spatial alignment.
                                // E.g. Visualize the grid rotated. Now look at the top-right position of that mental image.
                                // So we should HIDE the grid completely to force mental image.

                                gameArea.innerHTML = '';

                                const rowName = getRowName(targetPos.r, cfg.rows);
                                const colName = getColName(targetPos.c, cfg.cols);

                                const html =
                                    '<div class="ops-display">' +
                                    '<div class="op-text">Rotated ' + currentRot + '</div>' +
                                    '</div>' +
                                    '<div class="answer-section">' +
                                    '<div class="question-text">' +
                                    'What number is at<br>' +
                                    '<span style="color:var(--neon-solar); font-weight:700">' + rowName + ', ' + colName + '</span>?' +
                                    '</div>' +
                                    '<input type="number" class="answer-input" id="answerInput" placeholder="?" autofocus>' +
                                    '<button class="submit-btn" id="submitBtn">Submit</button>' +
                                    '</div>';

                                gameArea.innerHTML = html;
                                setTimeout(() => document.getElementById('answerInput').focus(), 100);
                                document.getElementById('submitBtn').addEventListener('click', checkAnswer);
                            }

                            function checkAnswer() {
                                const input = document.getElementById('answerInput');
                                if (!input.value) return;

                                const userVal = parseInt(input.value);
                                const correctVal = getCorrectValue();

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
                                }, 1500);
                            }

                            function getCorrectValue() {
                                // Calculate original position (r, c) that ended up at targetPos after rotation
                                // If 90 CW: (r, c) -> (c, rows-1-r)
                                // We know final position (targetPos.r, targetPos.c). We need to reverse map to get original (r, c) to look up in gridData.

                                // Reverse Rotation:
                                // 90 CW -> 90 CCW (-90)
                                // 90 CCW -> 90 CW
                                // 180 -> 180

                                const tr = targetPos.r;
                                const tc = targetPos.c;
                                const rows = CONFIG[difficulty].rows;
                                const cols = CONFIG[difficulty].cols;

                                let origR, origC;

                                if (currentRot === '90° CW') {
                                    // Forward: newR = c, newC = rows - 1 - r
                                    // Reverse (90 CCW): origR = cols - 1 - newC, origC = newR
                                    // Wait, assumes square? Yes, rows=cols usually.
                                    origR = cols - 1 - tc;
                                    origC = tr;
                                } else if (currentRot === '90° CCW') {
                                    // Forward: newR = cols - 1 - c, newC = r
                                    // Reverse (90 CW): origR = newC, origC = rows - 1 - newR
                                    origR = tc;
                                    origC = rows - 1 - tr;
                                } else if (currentRot === '180°') {
                                    // Forward: newR = rows - 1 - r, newC = cols - 1 - c
                                    // Reverse: Same
                                    origR = rows - 1 - tr;
                                    origC = cols - 1 - tc;
                                } else if (currentRot === '270° CW') {
                                    // Same as 90 CCW
                                    // Reverse (90 CW)
                                    origR = tc;
                                    origC = rows - 1 - tr;
                                }

                                return gridData[origR][origC];
                            }

                            function getRowName(r, total) {
                                if (total === 2) return r === 0 ? "Top" : "Bottom";
                                if (total === 3) return r === 0 ? "Top" : r === 1 ? "Middle" : "Bottom";
                                return "Row " + (r + 1);
                            }

                            function getColName(c, total) {
                                if (total === 2) return c === 0 ? "Left" : "Right";
                                if (total === 3) return c === 0 ? "Left" : c === 1 ? "Middle" : "Right";
                                return "Col " + (c + 1);
                            }

                            function endGame() {
                                totalGameTime = Math.floor((Date.now() - gameStartTime) / 1000);
                                document.getElementById('finalScore').textContent = score;
                                document.getElementById('finalTime').textContent = 'Time: ' + MathMemory.ui.formatTime(totalGameTime);
                                MathMemory.storage.setHighScore('spin-logic', difficulty, score);
                                winModal.classList.add('active');
                                if (score > 0) MathMemory.ui.confetti();
                            }

                            function shareScore() {
                                MathMemory.share.share('spin-logic', 'Spin Logic', score, difficulty, {
                                    time: totalGameTime,
                                    rounds: maxRounds,
                                    streak: streak
                                });
                                winModal.classList.remove('active');
                            }

                            init();
                        })();
                    </script>