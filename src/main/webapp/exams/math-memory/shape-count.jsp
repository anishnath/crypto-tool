<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="seo-helper.jsp" %>
        <% String pageKey="shape-count" ; String seoTitle=getSEOTitle(pageKey, application); String
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
                        --neon-indigo: #6366f1;
                        --neon-purple: #a855f7;
                        --arcade-dark: #0f0c29;
                        --arcade-card: #181340;
                        --arcade-border: #302b63;
                        --glow-shape: 0 0 20px rgba(99, 102, 241, 0.4);
                    }

                    .game-page {
                        background: linear-gradient(135deg, var(--arcade-dark) 0%, #24243e 100%);
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
                            radial-gradient(circle at 10% 20%, rgba(99, 102, 241, 0.1) 0%, transparent 40%),
                            radial-gradient(circle at 90% 80%, rgba(168, 85, 247, 0.1) 0%, transparent 40%);
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
                        background: linear-gradient(135deg, var(--neon-indigo), var(--neon-purple));
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
                        color: var(--neon-indigo);
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
                        color: var(--neon-indigo);
                        text-shadow: var(--glow-shape);
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
                        border-color: var(--neon-indigo);
                        color: white;
                    }

                    .diff-btn.active {
                        border-color: var(--neon-indigo);
                        color: var(--neon-indigo);
                        box-shadow: var(--glow-shape);
                    }

                    /* Game Area */
                    .game-area {
                        background: var(--arcade-card);
                        border: 2px solid var(--arcade-border);
                        border-radius: var(--radius-xl);
                        min-height: 500px;
                        padding: var(--space-6);
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        justify-content: center;
                        position: relative;
                        box-shadow: 0 0 30px rgba(0, 0, 0, 0.2);
                        overflow: hidden;
                    }

                    /* Shapes Container */
                    .shapes-container {
                        position: absolute;
                        top: 20px;
                        left: 20px;
                        right: 20px;
                        bottom: 20px;
                        overflow: hidden;
                    }

                    .game-shape {
                        position: absolute;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-weight: 700;
                        font-size: 1.25rem;
                        color: white;
                        box-shadow: 0 0 10px rgba(255, 255, 255, 0.2);
                        transition: transform 0.3s;
                        animation: floatIn 0.5s ease-out;
                    }

                    .shape-circle {
                        border-radius: 50%;
                    }

                    .shape-square {
                        border-radius: 4px;
                    }

                    .shape-triangle {
                        width: 0 !important;
                        height: 0 !important;
                        border-left: 30px solid transparent;
                        border-right: 30px solid transparent;
                        border-bottom: 50px solid;
                        background: transparent !important;
                        box-shadow: none;
                        display: flex;
                        align-items: flex-end;
                        justify-content: center;
                    }

                    .shape-triangle span {
                        transform: translateY(25px);
                        /* Position number inside triangle */
                        font-size: 1rem;
                        position: absolute;
                        width: 60px;
                        text-align: center;
                    }

                    @keyframes floatIn {
                        from {
                            transform: scale(0);
                            opacity: 0;
                        }

                        to {
                            transform: scale(1);
                            opacity: 1;
                        }
                    }

                    /* Input */
                    .answer-section {
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        gap: var(--space-4);
                        animation: slideUp 0.3s;
                        z-index: 10;
                    }

                    .question-text {
                        font-size: 1.5rem;
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
                        border-color: var(--neon-indigo);
                    }

                    .submit-btn {
                        padding: var(--space-3) var(--space-6);
                        background: var(--neon-indigo);
                        border: none;
                        border-radius: var(--radius-md);
                        color: white;
                        font-size: 1.1rem;
                        font-weight: 700;
                        cursor: pointer;
                        box-shadow: var(--glow-shape);
                    }

                    /* Timer Bar */
                    .timer-bar {
                        position: absolute;
                        top: 0;
                        left: 0;
                        right: 0;
                        height: 4px;
                        background: var(--neon-purple);
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
                        border: 2px solid var(--neon-indigo);
                        border-radius: var(--radius-full);
                        background: var(--neon-indigo);
                        color: white;
                        font-size: 1.2rem;
                        font-weight: 700;
                        cursor: pointer;
                        box-shadow: var(--glow-shape);
                        transition: transform 0.2s;
                    }

                    .action-btn:hover {
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
                        border: 2px solid var(--neon-indigo);
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
                                <span class="game-title-icon">&#9650;</span>
                                <h1>Shape Count</h1>
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
                                <div class="state-title">Selective Focus</div>
                                <p>
                                    Shapes with numbers will appear briefly.<br>
                                    Memorize the sum of numbers for specific shapes<br>
                                    (e.g. Sum of Circles).
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
                        <div style="font-size:4rem; margin-bottom:1rem;">&#127919;</div>
                        <h2 style="font-size:2rem; font-weight:700; color:white; margin-bottom:1rem;">Sharp Eye!</h2>
                        <div style="font-size:3rem; font-weight:700; color:var(--neon-indigo); margin-bottom:0.5rem;"
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
                                easy: { count: 5, shapes: ['circle', 'square'], showTime: 2000, points: 100 },
                                medium: { count: 8, shapes: ['circle', 'square', 'triangle'], showTime: 3000, points: 150 },
                                hard: { count: 12, shapes: ['circle', 'square', 'triangle'], showTime: 4000, points: 200 }
                            };

                            // State
                            let difficulty = 'easy';
                            let round = 1;
                            let maxRounds = 10;
                            let score = 0;
                            let streak = 0;
                            let currentShapesLineup = []; // { type: 'circle', val: 5 }
                            let targetShapeType = 'circle';
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
                                const hs = MathMemory.storage.getHighScore('shape-count', difficulty);
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
             <div class="state-title">Selective Focus</div>
            <p>Shapes with numbers will appear briefly. Pay attention to everything.</p>
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
                                // Generate Lineup
                                currentShapesLineup = [];
                                const width = gameArea.clientWidth - 100;
                                const height = gameArea.clientHeight - 100;

                                for (let i = 0; i < cfg.count; i++) {
                                    const type = cfg.shapes[Math.floor(Math.random() * cfg.shapes.length)];
                                    const val = Math.floor(Math.random() * 9) + 1;
                                    const x = Math.floor(Math.random() * width) + 20;
                                    const y = Math.floor(Math.random() * height) + 20;
                                    const color = getRandomColor();

                                    currentShapesLineup.push({ type, val, x, y, color });
                                }

                                // Pick target
                                targetShapeType = cfg.shapes[Math.floor(Math.random() * cfg.shapes.length)];

                                renderStudyPhase();
                            }

                            function getRandomColor() {
                                const colors = ['#f43f5e', '#ec4899', '#d946ef', '#a855f7', '#8b5cf6', '#6366f1', '#3b82f6', '#0ea5e9', '#06b6d4', '#14b8a6', '#10b981', '#84cc16', '#eab308', '#f59e0b', '#f97316', '#ef4444'];
                                return colors[Math.floor(Math.random() * colors.length)];
                            }

                            function renderStudyPhase() {
                                const cfg = CONFIG[difficulty];

                                let html = '<div class="shapes-container">';
                                for (let i = 0; i < currentShapesLineup.length; i++) {
                                    const item = currentShapesLineup[i];
                                    let style = 'left: ' + item.x + 'px; top: ' + item.y + 'px; width: 60px; height: 60px;';
                                    let content = item.val;

                                    if (item.type === 'triangle') {
                                        // Triangles are CSS borders
                                        style = 'left: ' + item.x + 'px; top: ' + item.y + 'px; border-bottom-color: ' + item.color;
                                        content = '<span>' + item.val + '</span>';
                                    } else {
                                        style += 'background: ' + item.color;
                                    }

                                    html += '<div class="game-shape shape-' + item.type + '" style="' + style + '">' + content + '</div>';
                                }
                                html += '</div>';

                                gameArea.innerHTML = html;
                                gameArea.appendChild(timerBar);

                                timerBar.style.width = '100%';
                                timerBar.style.transition = 'width ' + cfg.showTime + 'ms linear';
                                timerBar.offsetHeight;
                                setTimeout(() => { timerBar.style.width = '0%'; }, 50);

                                setTimeout(() => {
                                    renderQuestionPhase();
                                }, cfg.showTime);
                            }

                            function renderQuestionPhase() {
                                gameArea.innerHTML = '';

                                const typeDisplay = targetShapeType.charAt(0).toUpperCase() + targetShapeType.slice(1) + 's';

                                const html =
                                    '<div class="answer-section">' +
                                    '<div class="question-text">' +
                                    'Sum of numbers inside<br>' +
                                    '<span style="color:var(--neon-indigo); font-weight:700">' + typeDisplay + '</span>?' +
                                    '</div>' +
                                    '<input type="number" class="answer-input" id="answerInput" placeholder="Sum" autofocus>' +
                                    '<button class="submit-btn" id="submitBtn">Check</button>' +
                                    '</div>';

                                gameArea.innerHTML = html;
                                setTimeout(() => document.getElementById('answerInput').focus(), 100);
                                document.getElementById('submitBtn').addEventListener('click', checkAnswer);
                            }

                            function checkAnswer() {
                                const input = document.getElementById('answerInput');
                                if (!input.value) return;

                                const userVal = parseInt(input.value);

                                const sum = currentShapesLineup
                                    .filter(item => item.type === targetShapeType)
                                    .reduce((acc, curr) => acc + curr.val, 0);

                                if (userVal === sum) {
                                    streak++;
                                    const points = CONFIG[difficulty].points + (streak * 10);
                                    score += points;
                                    MathMemory.ui.showToast('Correct! +' + points, 'success');
                                } else {
                                    streak = 0;
                                    MathMemory.ui.showToast('Wrong! Sum was ' + sum, 'error');
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
                                MathMemory.storage.setHighScore('shape-count', difficulty, score);
                                winModal.classList.add('active');
                                if (score > 0) MathMemory.ui.confetti();
                            }

                            function shareScore() {
                                MathMemory.share.share('shape-count', 'Shape Count', score, difficulty, {
                                    time: totalGameTime,
                                    rounds: maxRounds,
                                    streak: streak
                                });
                                winModal.classList.remove('active');
                            }

                            init();
                        })();
                    </script>