<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="seo-helper.jsp" %>
        <% String pageKey="binary-blitz" ; String seoTitle=getSEOTitle(pageKey, application); String
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
                        --neon-green: #22c55e;
                        --neon-dark: #052e16;
                        --arcade-dark: #000000;
                        --arcade-card: #111;
                        --arcade-border: #333;
                        --glow-green: 0 0 20px rgba(34, 197, 94, 0.5);
                    }

                    .game-page {
                        background: var(--arcade-dark);
                        min-height: 100vh;
                        padding-bottom: var(--space-8);
                        font-family: 'Courier New', monospace;
                    }

                    .game-page::before {
                        content: '';
                        position: fixed;
                        top: 0;
                        left: 0;
                        right: 0;
                        bottom: 0;
                        background-image:
                            linear-gradient(rgba(34, 197, 94, 0.1) 1px, transparent 1px),
                            linear-gradient(90deg, rgba(34, 197, 94, 0.1) 1px, transparent 1px);
                        background-size: 20px 20px;
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
                        border-bottom: 1px solid var(--neon-green);
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
                        color: var(--neon-green);
                        text-shadow: var(--glow-green);
                        margin: 0;
                    }

                    .game-back {
                        display: flex;
                        align-items: center;
                        gap: var(--space-2);
                        color: rgba(34, 197, 94, 0.6);
                        text-decoration: none;
                        font-size: var(--text-sm);
                        transition: color 0.2s;
                    }

                    .game-back:hover {
                        color: var(--neon-green);
                    }

                    /* Stats */
                    .stats-bar {
                        display: flex;
                        justify-content: center;
                        gap: var(--space-4);
                        margin-bottom: var(--space-6);
                        margin-top: var(--space-6);
                    }

                    .stat-item {
                        border: 1px solid var(--neon-green);
                        padding: var(--space-2) var(--space-4);
                        text-align: center;
                        min-width: 80px;
                        background: rgba(34, 197, 94, 0.05);
                    }

                    .stat-value {
                        font-size: 1.5rem;
                        font-weight: 700;
                        color: var(--neon-green);
                    }

                    .stat-label {
                        font-size: 0.75rem;
                        color: rgba(34, 197, 94, 0.7);
                        text-transform: uppercase;
                    }

                    /* Difficulty */
                    .difficulty-selector {
                        display: flex;
                        justify-content: center;
                        gap: var(--space-3);
                        margin-bottom: var(--space-8);
                    }

                    .diff-btn {
                        padding: var(--space-2) var(--space-4);
                        border: 1px solid var(--neon-green);
                        background: transparent;
                        color: var(--neon-green);
                        font-family: 'Courier New', monospace;
                        font-weight: 700;
                        cursor: pointer;
                        transition: all 0.2s;
                    }

                    .diff-btn.active,
                    .diff-btn:hover {
                        background: var(--neon-green);
                        color: black;
                        box-shadow: var(--glow-green);
                    }

                    /* Game Area */
                    .game-area {
                        border: 1px solid var(--neon-green);
                        min-height: 400px;
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        justify-content: center;
                        position: relative;
                        padding: var(--space-4);
                        background: rgba(0, 0, 0, 0.8);
                        box-shadow: inset 0 0 20px rgba(34, 197, 94, 0.1);
                    }

                    /* Bits */
                    .bit-container {
                        display: flex;
                        gap: var(--space-2);
                        margin-bottom: var(--space-8);
                    }

                    .bit {
                        width: 60px;
                        height: 80px;
                        border: 2px solid var(--neon-green);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 2.5rem;
                        color: var(--neon-green);
                        font-weight: 700;
                        cursor: pointer;
                        transition: all 0.2s;
                    }

                    .bit.off {
                        color: rgba(34, 197, 94, 0.2);
                        border-color: rgba(34, 197, 94, 0.2);
                    }

                    .bit.active {
                        background: rgba(34, 197, 94, 0.1);
                        box-shadow: var(--glow-green);
                    }

                    .decimal-display {
                        font-size: 4rem;
                        color: var(--neon-green);
                        text-shadow: var(--glow-green);
                        margin-bottom: var(--space-4);
                    }

                    .prompt-text {
                        font-size: 1.2rem;
                        color: white;
                        margin-bottom: var(--space-6);
                        text-align: center;
                    }

                    .submit-btn {
                        padding: var(--space-3) var(--space-8);
                        background: var(--neon-green);
                        border: none;
                        color: black;
                        font-size: 1.5rem;
                        font-weight: 700;
                        cursor: pointer;
                        font-family: 'Courier New', monospace;
                        box-shadow: var(--glow-green);
                    }

                    .submit-btn:hover {
                        transform: scale(1.05);
                    }

                    /* Timer */
                    .timer-bar {
                        position: absolute;
                        top: 0;
                        left: 0;
                        right: 0;
                        height: 2px;
                        background: var(--neon-green);
                        width: 0%;
                    }

                    /* States */
                    .state-message {
                        text-align: center;
                        color: var(--neon-green);
                    }

                    .state-title {
                        font-size: 2.5rem;
                        margin-bottom: var(--space-4);
                    }

                    .action-btn {
                        padding: var(--space-3) var(--space-8);
                        background: transparent;
                        border: 2px solid var(--neon-green);
                        color: var(--neon-green);
                        font-size: 1.5rem;
                        font-weight: 700;
                        cursor: pointer;
                        font-family: inherit;
                        transition: all 0.2s;
                    }

                    .action-btn:hover {
                        background: var(--neon-green);
                        color: black;
                        box-shadow: var(--glow-green);
                    }

                    /* Modals */
                    .win-modal {
                        position: fixed;
                        top: 0;
                        left: 0;
                        right: 0;
                        bottom: 0;
                        background: rgba(0, 0, 0, 0.95);
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
                        border: 2px solid var(--neon-green);
                        padding: var(--space-8);
                        text-align: center;
                        background: black;
                        box-shadow: var(--glow-green);
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
                                <span class="game-title-icon">&#10100;</span>
                                <h1>Binary Blitz</h1>
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
                                <div class="state-title">Binary Protocol</div>
                                <p class="prompt-text">
                                    A sequence of Bits (0s and 1s) will appear.<br>
                                    Memorize the pattern. Reconstruct it perfectly.
                                </p>
                                <button class="action-btn" id="startBtn">Initialize</button>
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
                        <div style="font-size:4rem; margin-bottom:1rem; color:var(--neon-green)">&#128187;</div>
                        <h2 style="font-size:2rem; font-weight:700; color:white; margin-bottom:1rem;">System Synced</h2>
                        <div style="font-size:3rem; font-weight:700; color:var(--neon-green); margin-bottom:0.5rem;"
                            id="finalScore">0</div>
                        <div style="color:#aaa; margin-bottom:1rem;">Total Score</div>
                        <div id="finalTime" style="color:#aaa; margin-bottom:2rem;"></div>
                        <div style="display:flex; gap:var(--space-3); justify-content:center;">
                            <button class="action-btn" id="playAgainBtn">Reboot</button>
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
                                easy: { bits: 4, showTime: 2000, points: 100 },
                                medium: { bits: 6, showTime: 3000, points: 150 },
                                hard: { bits: 8, showTime: 4000, points: 200 }
                            };

                            // State
                            let difficulty = 'easy';
                            let round = 1;
                            let maxRounds = 10;
                            let score = 0;
                            let streak = 0;
                            let targetPattern = []; // [0, 1, 1, 0]
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
                                const hs = MathMemory.storage.getHighScore('binary-blitz', difficulty);
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
            <div class="state-title">Binary Protocol</div>
            <p class="prompt-text">Memorize the pattern. Reconstruct it perfectly.</p>
            <button class="action-btn" id="startBtnReset">Initialize</button>
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
                                targetPattern = [];
                                for (let i = 0; i < cfg.bits; i++) {
                                    targetPattern.push(Math.random() > 0.5 ? 1 : 0);
                                }

                                renderMemorizePhase();
                            }

                            function renderMemorizePhase() {
                                const cfg = CONFIG[difficulty];

                                let bitsHtml = '';
                                for (let i = 0; i < targetPattern.length; i++) {
                                    bitsHtml += '<div class="bit active">' + targetPattern[i] + '</div>';
                                }

                                let html =
                                    '<div class="prompt-text">Memorize Pattern</div>' +
                                    '<div class="bit-container">' +
                                    bitsHtml +
                                    '</div>';

                                gameArea.innerHTML = html;
                                gameArea.appendChild(timerBar);

                                timerBar.style.width = '100%';
                                timerBar.style.transition = 'width ' + cfg.showTime + 'ms linear';
                                timerBar.offsetHeight;
                                setTimeout(() => { timerBar.style.width = '0%'; }, 50);

                                setTimeout(() => {
                                    renderRecallPhase();
                                }, cfg.showTime);
                            }

                            function renderRecallPhase() {
                                const cfg = CONFIG[difficulty];

                                let bitsHtml = '';
                                for (let i = 0; i < cfg.bits; i++) {
                                    bitsHtml += '<div class="bit off" data-idx="' + i + '">0</div>';
                                }

                                let html =
                                    '<div class="prompt-text">Reconstruct Pattern</div>' +
                                    '<div class="bit-container">' +
                                    bitsHtml +
                                    '</div>' +
                                    '<button class="submit-btn" id="submitBtn">Verify</button>';

                                gameArea.innerHTML = html;

                                // Listeners
                                const bits = gameArea.querySelectorAll('.bit');
                                bits.forEach(bit => {
                                    bit.addEventListener('click', () => {
                                        const val = bit.textContent === '0' ? '1' : '0';
                                        bit.textContent = val;
                                        if (val === '1') {
                                            bit.classList.remove('off');
                                            bit.classList.add('active');
                                        } else {
                                            bit.classList.remove('active');
                                            bit.classList.add('off');
                                        }
                                    });
                                });

                                document.getElementById('submitBtn').addEventListener('click', checkAnswer);
                            }

                            function checkAnswer() {
                                const userBits = Array.from(gameArea.querySelectorAll('.bit')).map(b => parseInt(b.textContent));
                                let correct = true;

                                for (let i = 0; i < userBits.length; i++) {
                                    if (userBits[i] !== targetPattern[i]) {
                                        correct = false;
                                        // Highlight error?
                                    }
                                }

                                if (correct) {
                                    streak++;
                                    const points = CONFIG[difficulty].points + (streak * 10);
                                    score += points;
                                    MathMemory.ui.showToast('Access Granted! +' + points, 'success');
                                } else {
                                    streak = 0;
                                    MathMemory.ui.showToast('Access Denied. Pattern mismtach.', 'error');
                                    // Show correct
                                    const bits = gameArea.querySelectorAll('.bit');
                                    bits.forEach((b, i) => {
                                        if (parseInt(b.textContent) !== targetPattern[i]) {
                                            b.style.borderColor = 'red';
                                            b.style.color = 'red';
                                        }
                                        b.textContent = targetPattern[i]; // Reveal
                                    });
                                }

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
                                MathMemory.storage.setHighScore('binary-blitz', difficulty, score);
                                winModal.classList.add('active');
                                if (score > 0) MathMemory.ui.confetti();
                            }

                            function shareScore() {
                                MathMemory.share.share('binary-blitz', 'Binary Blitz', score, difficulty, {
                                    time: totalGameTime,
                                    rounds: maxRounds,
                                    streak: streak
                                });
                                winModal.classList.remove('active');
                            }

                            init();
                        })();
                    </script>