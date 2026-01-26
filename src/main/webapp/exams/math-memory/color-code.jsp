<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="seo-helper.jsp" %>
        <% String pageKey="color-code" ; String seoTitle=getSEOTitle(pageKey, application); String
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
                        --neon-orange: #f97316;
                        --neon-cyan: #06b6d4;
                        --arcade-dark: #0f0a1e;
                        --arcade-card: #1a1333;
                        --arcade-border: #2d2255;
                        --glow-multi: 0 0 20px rgba(255, 255, 255, 0.3);
                    }

                    .game-page {
                        background: linear-gradient(135deg, var(--arcade-dark) 0%, #1c1917 50%, var(--arcade-dark) 100%);
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
                            radial-gradient(circle at 50% 50%, rgba(255, 255, 255, 0.05) 0%, transparent 60%);
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
                        background: linear-gradient(90deg, #ef4444, #f59e0b, #10b981, #3b82f6, #8b5cf6);
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
                        color: white;
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
                        color: var(--neon-cyan);
                        text-shadow: 0 0 10px rgba(6, 182, 212, 0.5);
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
                        border-color: var(--neon-orange);
                        color: white;
                    }

                    .diff-btn.active {
                        border-color: var(--neon-orange);
                        color: var(--neon-orange);
                        box-shadow: 0 0 10px rgba(249, 115, 22, 0.5);
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

                    /* Legend */
                    .color-legend {
                        display: flex;
                        flex-wrap: wrap;
                        justify-content: center;
                        gap: var(--space-4);
                        margin-bottom: var(--space-8);
                    }

                    .color-item {
                        width: 60px;
                        height: 80px;
                        border-radius: var(--radius-lg);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 2rem;
                        font-weight: 800;
                        color: rgba(0, 0, 0, 0.7);
                        border: 2px solid rgba(255, 255, 255, 0.1);
                        transition: all 0.3s;
                    }

                    .color-item.hidden {
                        color: transparent;
                    }

                    /* Challenge */
                    .challenge-seq {
                        display: flex;
                        gap: var(--space-2);
                        margin-bottom: var(--space-6);
                        height: 80px;
                        align-items: center;
                        width: 100%;
                        justify-content: center;
                    }

                    .seq-block {
                        width: 60px;
                        height: 60px;
                        border-radius: var(--radius-md);
                        box-shadow: 0 0 15px rgba(0, 0, 0, 0.5);
                        animation: popIn 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
                    }

                    @keyframes popIn {
                        from {
                            transform: scale(0);
                            opacity: 0;
                        }

                        to {
                            transform: scale(1);
                            opacity: 1;
                        }
                    }

                    /* Keypad */
                    .numpad {
                        display: grid;
                        grid-template-columns: repeat(5, 1fr);
                        gap: var(--space-3);
                        max-width: 400px;
                    }

                    .num-btn {
                        background: rgba(255, 255, 255, 0.1);
                        border: 1px solid var(--arcade-border);
                        border-radius: var(--radius-lg);
                        padding: var(--space-3);
                        font-size: 1.5rem;
                        color: white;
                        cursor: pointer;
                        transition: all 0.1s;
                    }

                    .num-btn:hover {
                        background: rgba(255, 255, 255, 0.2);
                    }

                    .num-btn:active {
                        transform: scale(0.95);
                    }

                    /* Input Display */
                    .code-display {
                        font-size: 2rem;
                        letter-spacing: 5px;
                        color: white;
                        margin-bottom: var(--space-6);
                        min-height: 40px;
                        font-family: 'Courier New', monospace;
                    }

                    /* Timer Bar */
                    .timer-bar {
                        position: absolute;
                        top: 0;
                        left: 0;
                        right: 0;
                        height: 4px;
                        background: linear-gradient(90deg, #ef4444, #f59e0b, #10b981, #3b82f6);
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
                        border: 2px solid var(--neon-cyan);
                        border-radius: var(--radius-full);
                        background: var(--neon-cyan);
                        color: var(--arcade-dark);
                        font-size: 1.2rem;
                        font-weight: 700;
                        cursor: pointer;
                        box-shadow: 0 0 15px rgba(6, 182, 212, 0.5);
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
                        border: 2px solid var(--neon-cyan);
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
                                <span class="game-title-icon">&#127912;</span>
                                <h1>Color Code</h1>
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
                                <div class="state-title">Crack the Color Code</div>
                                <p class="state-desc">
                                    Each number will be assigned a unique color.<br>
                                    Memorize the legend. Then decode the color sequence.
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
                        <h2 style="font-size:2rem; font-weight:700; color:white; margin-bottom:1rem;">Spectrum Solved!</h2>
                        <div style="font-size:3rem; font-weight:700; color:var(--neon-cyan); margin-bottom:0.5rem;"
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
                                easy: { items: 3, seqLen: 3, showTime: 3000, points: 100 },
                                medium: { items: 5, seqLen: 4, showTime: 4000, points: 150 },
                                hard: { items: 7, seqLen: 5, showTime: 5000, points: 200 }
                            };

                            const COLORS = [
                                '#ef4444', '#f97316', '#f59e0b', '#84cc16', '#10b981',
                                '#06b6d4', '#3b82f6', '#8b5cf6', '#d946ef', '#f43f5e'
                            ];

                            // State
                            let difficulty = 'easy';
                            let round = 1;
                            let maxRounds = 10;
                            let score = 0;
                            let streak = 0;
                            let currentMap = []; // Array of { num: 1, color: '#...' }
                            let currentSeq = []; // Array of integers matching currentMap indices
                            let userSeq = '';
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
                            }

                            function loadHighScore() {
                                const hs = MathMemory.storage.getHighScore('color-code', difficulty);
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
                                intro.className = 'state-message';
                                intro.id = 'introView';
                                intro.innerHTML = `
            <div class="state-title">Crack the Color Code</div>
            <p class="state-desc">Each number will be assigned a unique color. Memorize the legend.</p>
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
                                // Generate Map
                                currentMap = [];
                                const usedNums = new Set();
                                const shuffledColors = [...COLORS].sort(() => Math.random() - 0.5).slice(0, cfg.items);

                                for (let i = 0; i < cfg.items; i++) {
                                    let num;
                                    do { num = Math.floor(Math.random() * 9) + 1; } while (usedNums.has(num));
                                    usedNums.add(num);
                                    currentMap.push({ num, color: shuffledColors[i] });
                                }

                                // Generate Target Sequence
                                currentSeq = [];
                                for (let i = 0; i < cfg.seqLen; i++) {
                                    currentSeq.push(currentMap[Math.floor(Math.random() * cfg.items)]);
                                }

                                renderStudyPhase();
                            }

                            function renderStudyPhase() {
                                const cfg = CONFIG[difficulty];

                                let html = '<div class="color-legend">';
                                currentMap.sort((a, b) => a.num - b.num); // nice order for legend? or random?
                                // Random is harder. Sorted is easier. Let's sort by Number for study phase so it's a "Legend".

                                currentMap.forEach(item => {
                                    html += '<div class="color-item" style="background-color: ' + item.color + '">' + item.num + '</div>';
                                });
                                html += '</div>';

                                gameArea.innerHTML = html;
                                gameArea.appendChild(timerBar);

                                timerBar.style.width = '100%';
                                timerBar.style.transition = 'width ' + cfg.showTime + 'ms linear';
                                timerBar.offsetHeight;
                                setTimeout(() => { timerBar.style.width = '0%'; }, 50);

                                setTimeout(() => {
                                    renderActionPhase();
                                }, cfg.showTime);
                            }

                            function renderActionPhase() {
                                // Hide Numbers in Legend
                                const items = gameArea.querySelectorAll('.color-item');
                                items.forEach(item => item.classList.add('hidden'));

                                // Show Challenge Sequence
                                let seqHtml = '';
                                for (let i = 0; i < currentSeq.length; i++) {
                                    seqHtml += '<div class="seq-block" style="background-color:' + currentSeq[i].color + '"></div>';
                                }

                                let numpadHtml = '';
                                for (let n = 0; n <= 9; n++) {
                                    let val = (n === 9) ? 0 : n + 1; // 1-9 then 0? Original code was [1..9, 0]
                                    let displayNum = (n === 9) ? 0 : n + 1;

                                    // Actually original map was [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]
                                    let nu = (n === 9) ? 0 : n + 1;
                                    numpadHtml += '<button class="num-btn" data-val="' + nu + '">' + nu + '</button>';
                                }

                                // Resetting to simple array loop to match original exact logic
                                numpadHtml = '';
                                const keypadNums = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0];
                                for (let i = 0; i < keypadNums.length; i++) {
                                    numpadHtml += '<button class="num-btn" data-val="' + keypadNums[i] + '">' + keypadNums[i] + '</button>';
                                }

                                let html =
                                    '<div class="state-desc" style="margin-bottom:1rem">Decode the Sequence</div>' +
                                    '<div class="challenge-seq">' +
                                    seqHtml +
                                    '</div>' +
                                    '<div class="code-display" id="codeDisplay">_ _ _</div>' +
                                    '<div class="numpad">' +
                                    numpadHtml +
                                    '<button class="num-btn" data-val="back" style="grid-column: span 2">&#9003;</button>' +
                                    '<button class="num-btn" data-val="enter" style="grid-column: span 3; background: var(--neon-cyan); color:black; font-weight:700">Submit</button>' +
                                    '</div>';

                                // Let's keep the legend (hidden numbers) to verify colors if needed? Or remove it to make it harder (Pure recall)?
                                // Let's keep the legend (colors visible, numbers hidden).

                                const legendHtml = gameArea.querySelector('.color-legend').outerHTML;
                                gameArea.innerHTML = legendHtml + html;
                                gameArea.querySelector('.color-legend').querySelectorAll('.color-item').forEach(el => el.classList.add('hidden'));

                                updateDisplay('_');

                                userSeq = '';

                                gameArea.querySelectorAll('.num-btn').forEach(btn => {
                                    btn.addEventListener('click', () => handleInput(btn.dataset.val));
                                });
                            }

                            function updateDisplay() {
                                const len = currentSeq.length;
                                let str = userSeq.split('').join(' ');
                                while (str.length / 2 < len) str += ' _';
                                document.getElementById('codeDisplay').textContent = str;
                            }

                            function handleInput(val) {
                                if (val === 'enter') {
                                    checkAnswer();
                                    return;
                                }

                                if (val === 'back') {
                                    userSeq = userSeq.slice(0, -1);
                                } else {
                                    if (userSeq.length < currentSeq.length) {
                                        userSeq += val;
                                    }
                                }
                                updateDisplay();
                            }

                            function checkAnswer() {
                                if (userSeq.length !== currentSeq.length) return;

                                const correctSeq = currentSeq.map(s => s.num).join('');

                                if (userSeq === correctSeq) {
                                    streak++;
                                    const points = CONFIG[difficulty].points + (streak * 10);
                                    score += points;
                                    MathMemory.ui.showToast('Decoded! +' + points, 'success');
                                } else {
                                    streak = 0;
                                    MathMemory.ui.showToast('Error! Code was ' + correctSeq, 'error');
                                }

                                // Reveal Legend
                                gameArea.querySelectorAll('.color-item').forEach(el => el.classList.remove('hidden'));

                                updateStats();

                                setTimeout(() => {
                                    round++;
                                    updateStats();
                                    startRound();
                                }, 2000);
                            }

                            function endGame() {
                                totalGameTime = Math.floor((Date.now() - gameStartTime) / 1000);
                                document.getElementById('finalScore').textContent = score;
                                document.getElementById('finalTime').textContent = 'Time: ' + MathMemory.ui.formatTime(totalGameTime);
                                MathMemory.storage.setHighScore('color-code', difficulty, score);
                                winModal.classList.add('active');
                                if (score > 0) MathMemory.ui.confetti();
                            }

                            function shareScore() {
                                MathMemory.share.share('color-code', 'Color Code', score, difficulty, {
                                    time: totalGameTime,
                                    rounds: maxRounds,
                                    streak: streak
                                });
                                winModal.classList.remove('active');
                            }

                            init();
                        })();
                    </script>