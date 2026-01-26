<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="seo-helper.jsp" %>
        <% String pageKey="equation-echo" ; String seoTitle=getSEOTitle(pageKey, application); String
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
                        --neon-lime: #a3e635;
                        --neon-emerald: #10b981;
                        --arcade-dark: #0f0a1e;
                        --arcade-card: #1a1333;
                        --arcade-border: #2d2255;
                        --glow-lime: 0 0 20px rgba(163, 230, 53, 0.5);
                    }

                    .game-page {
                        background: linear-gradient(135deg, var(--arcade-dark) 0%, #052e16 50%, var(--arcade-dark) 100%);
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
                            linear-gradient(0deg, transparent 24%, rgba(163, 230, 53, .05) 25%, rgba(163, 230, 53, .05) 26%, transparent 27%, transparent 74%, rgba(163, 230, 53, .05) 75%, rgba(163, 230, 53, .05) 76%, transparent 77%, transparent),
                            linear-gradient(90deg, transparent 24%, rgba(163, 230, 53, .05) 25%, rgba(163, 230, 53, .05) 26%, transparent 27%, transparent 74%, rgba(163, 230, 53, .05) 75%, rgba(163, 230, 53, .05) 76%, transparent 77%, transparent);
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
                        background: linear-gradient(135deg, var(--neon-lime), var(--neon-emerald));
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
                        color: var(--neon-lime);
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
                        color: var(--neon-lime);
                        text-shadow: var(--glow-lime);
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
                        border-color: var(--neon-lime);
                        color: white;
                    }

                    .diff-btn.active {
                        border-color: var(--neon-lime);
                        color: var(--neon-lime);
                        box-shadow: var(--glow-lime);
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

                    /* Equation Display */
                    .equation-display {
                        font-size: clamp(2rem, 5vw, 3.5rem);
                        font-weight: 700;
                        color: white;
                        font-family: 'Courier New', monospace;
                        letter-spacing: 2px;
                        margin-bottom: var(--space-8);
                        min-height: 100px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        flex-wrap: wrap;
                        gap: 10px;
                    }

                    .eq-part {
                        padding: 0 5px;
                        transition: all 0.3s;
                        border-bottom: 3px solid transparent;
                    }

                    .eq-hidden {
                        background: rgba(163, 230, 53, 0.2);
                        border-bottom: 3px solid var(--neon-lime);
                        color: transparent;
                        min-width: 60px;
                        text-align: center;
                        cursor: pointer;
                        position: relative;
                    }

                    .eq-hidden.filled {
                        color: var(--neon-lime);
                    }

                    .eq-hidden.active {
                        background: rgba(163, 230, 53, 0.4);
                        box-shadow: 0 0 15px rgba(163, 230, 53, 0.3);
                    }

                    /* Numpad */
                    .input-area {
                        width: 100%;
                        max-width: 400px;
                        animation: fadeInUp 0.3s ease-out;
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
                        background: rgba(163, 230, 53, 0.1);
                        border-color: var(--neon-lime);
                    }

                    .num-btn:active {
                        transform: scale(0.95);
                    }

                    .op-row {
                        display: flex;
                        gap: var(--space-3);
                        margin-top: var(--space-3);
                        justify-content: center;
                    }

                    .op-btn {
                        flex: 1;
                        background: rgba(255, 255, 255, 0.05);
                        border: 1px solid var(--arcade-border);
                        border-radius: var(--radius-lg);
                        padding: var(--space-3);
                        font-size: 1.25rem;
                        font-weight: 600;
                        color: var(--neon-lime);
                        cursor: pointer;
                    }

                    .submit-btn {
                        width: 100%;
                        padding: var(--space-4);
                        background: var(--neon-lime);
                        border: none;
                        border-radius: var(--radius-lg);
                        color: var(--arcade-dark);
                        font-size: 1.25rem;
                        font-weight: 700;
                        cursor: pointer;
                        transition: transform 0.2s;
                        box-shadow: var(--glow-lime);
                        margin-top: var(--space-4);
                    }

                    .submit-btn:hover {
                        transform: scale(1.02);
                    }

                    /* Timer Bar */
                    .timer-container {
                        position: absolute;
                        top: 0;
                        left: 0;
                        right: 0;
                        height: 4px;
                        background: rgba(255, 255, 255, 0.1);
                    }

                    .timer-fill {
                        height: 100%;
                        background: var(--neon-lime);
                        width: 100%;
                        transition: width linear;
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
                        border: 2px solid var(--neon-lime);
                        border-radius: var(--radius-full);
                        background: var(--neon-lime);
                        color: var(--arcade-dark);
                        font-size: 1.2rem;
                        font-weight: 700;
                        cursor: pointer;
                        box-shadow: var(--glow-lime);
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
                        border: 2px solid var(--neon-lime);
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

                        .numpad {
                            grid-template-columns: repeat(3, 1fr);
                        }
                    }

                    @keyframes fadeInUp {
                        from {
                            opacity: 0;
                            transform: translateY(20px);
                        }

                        to {
                            opacity: 1;
                            transform: translateY(0);
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
                                <span class="game-title-icon">&#8747;</span>
                                <h1>Equation Echo</h1>
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
                            <div class="timer-container">
                                <div class="timer-fill" id="timerFill"></div>
                            </div>

                            <div class="state-message" id="introView">
                                <div class="state-title">Restore the Equation</div>
                                <p class="state-desc">
                                    A full math equation will appear. Memorize it.<br>
                                    Parts will vanish. Fill in the missing numbers or operators.
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
                        <div style="font-size:4rem; margin-bottom:1rem;">&#129302;</div>
                        <h2 style="font-size:2rem; font-weight:700; color:white; margin-bottom:1rem;">System Restored!
                        </h2>
                        <div style="font-size:3rem; font-weight:700; color:var(--neon-lime); margin-bottom:0.5rem;"
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
                                easy: { showTime: 3000, points: 100, blanks: 1, type: 'basic' },
                                medium: { showTime: 4000, points: 150, blanks: 2, type: 'complex' },
                                hard: { showTime: 5000, points: 200, blanks: 3, type: 'long' }
                            };

                            // State
                            let difficulty = 'easy';
                            let round = 1;
                            let maxRounds = 10;
                            let score = 0;
                            let streak = 0;
                            let currentEqParts = []; // Array of objects { val: "12", type: "num"/"op", hidden: false, userVal: "" }
                            let activeBlankIndex = -1;
                            let gameStartTime = null;
                            let totalGameTime = 0;

                            // Elements
                            const gameArea = document.getElementById('gameArea');
                            const timerFill = document.getElementById('timerFill');
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
                                const hs = MathMemory.storage.getHighScore('equation-echo', difficulty);
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
                                gameArea.appendChild(timerFill.parentElement);

                                const intro = document.createElement('div');
                                intro.className = 'state-message';
                                intro.id = 'introView';
                                intro.innerHTML = `
            <div class="state-title">Restore the Equation</div>
            <p class="state-desc">A full math equation will appear. Memorize it.</p>
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

                                generateEquation();
                                renderMemorizePhase();
                            }

                            function generateEquation() {
                                // Generate parts array: e.g., ["12", "+", "5", "=", "17"]
                                // Types: basic (A op B = C), complex (A op B op C = D), long ((A op B) op C = D)
                                const cfg = CONFIG[difficulty];
                                let parts = [];

                                if (cfg.type === 'basic') {
                                    const a = Math.floor(Math.random() * 20) + 1;
                                    const b = Math.floor(Math.random() * 20) + 1;
                                    const op = Math.random() > 0.5 ? '+' : '-';
                                    let c = op === '+' ? a + b : a - b;
                                    // Avoid negative for easy
                                    if (c < 0) { parts = [b, '-', a, '=', b - a]; }
                                    else { parts = [a, op, b, '=', c]; }
                                } else if (cfg.type === 'complex') {
                                    const a = Math.floor(Math.random() * 10) + 1;
                                    const b = Math.floor(Math.random() * 10) + 1;
                                    const c = Math.floor(Math.random() * 10) + 1;
                                    const ops = ['+', '-', 'x'];
                                    const op1 = ops[Math.floor(Math.random() * 3)];
                                    // Simple logic
                                    let p1 = a;
                                    let res = 0;
                                    // Construct: A op B + C = D (no parens for medium, stick to + - for safety or simple mult)
                                    // Let's do A op B = C op D? Or A + B + C = D
                                    parts = [a, '+', b, '+', c, '=', a + b + c];
                                    // Add some variety
                                    if (Math.random() > 0.5) { // A x B + C
                                        parts = [a, 'x', b, '+', c, '=', (a * b) + c];
                                    }
                                } else { // Hard/Long
                                    const a = Math.floor(Math.random() * 10) + 1;
                                    const b = Math.floor(Math.random() * 10) + 1;
                                    const c = Math.floor(Math.random() * 5) + 2;
                                    // (A + B) x C = D
                                    const sum = a + b;
                                    const total = sum * c;
                                    parts = ['(', a, '+', b, ')', 'x', c, '=', total];
                                }

                                // Convert to objects
                                currentEqParts = parts.map(p => ({
                                    val: p.toString(),
                                    type: isNaN(parseInt(p)) && p !== '(' && p !== ')' ? 'op' : 'num',
                                    hidden: false,
                                    userVal: ""
                                }));

                                // Select Blanks
                                const indices = []; // Candidate indices (don't hide (, ), or =)
                                currentEqParts.forEach((p, i) => {
                                    if (p.val !== '=' && p.val !== '(' && p.val !== ')') indices.push(i);
                                });

                                // Shuffle and pick
                                indices.sort(() => Math.random() - 0.5);
                                const blankCount = Math.min(cfg.blanks, indices.length);

                                for (let i = 0; i < blankCount; i++) {
                                    currentEqParts[indices[i]].hidden = true;
                                }
                            }

                            function renderMemorizePhase() {
                                const cfg = CONFIG[difficulty];

                                // Show Full Equation
                                let html = '<div class="equation-display">';
                                for (let i = 0; i < currentEqParts.length; i++) {
                                    html += '<div class="eq-part">' + currentEqParts[i].val + '</div>';
                                }
                                html += '</div>';

                                gameArea.innerHTML = html;
                                gameArea.appendChild(timerFill.parentElement);

                                // Timer
                                timerFill.style.width = '100%';
                                timerFill.style.transition = 'width ' + cfg.showTime + 'ms linear';
                                // Force reflow
                                timerFill.offsetHeight;
                                setTimeout(() => { timerFill.style.width = '0%'; }, 50);

                                setTimeout(() => {
                                    renderRecallPhase();
                                }, cfg.showTime);
                            }

                            function renderRecallPhase() {
                                let html = '<div class="equation-display">';
                                let firstHiddenIndex = -1;

                                currentEqParts.forEach((p, i) => {
                                    if (p.hidden) {
                                        if (firstHiddenIndex === -1) firstHiddenIndex = i;
                                        const displayClass = (i === activeBlankIndex) ? 'eq-hidden active' : 'eq-hidden';
                                        const filledClass = p.userVal ? ' filled' : '';
                                        html += '<div class="' + displayClass + filledClass + '" data-idx="' + i + '">' + (p.userVal || '?') + '</div>';
                                    } else {
                                        html += '<div class="eq-part">' + p.val + '</div>';
                                    }
                                });
                                html += '</div>';

                                // Add Numpad
                                let numpadHtml = '';
                                const nums = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0];
                                for (let i = 0; i < nums.length; i++) {
                                    numpadHtml += '<button class="num-btn" data-val="' + nums[i] + '">' + nums[i] + '</button>';
                                }

                                html +=
                                    '<div class="input-area">' +
                                    '<div class="numpad">' +
                                    numpadHtml +
                                    '<button class="num-btn" data-val="back">&#9003;</button>' +
                                    '</div>' +
                                    '<div class="op-row">' +
                                    '<button class="op-btn" data-val="+">+</button>' +
                                    '<button class="op-btn" data-val="-">-</button>' +
                                    '<button class="op-btn" data-val="x">x</button>' +
                                    '</div>' +
                                    '<button class="submit-btn" id="submitBtn">Check</button>' +
                                    '</div>';

                                gameArea.innerHTML = html;
                                gameArea.appendChild(timerFill.parentElement);

                                // Set default active blank
                                if (activeBlankIndex === -1 && firstHiddenIndex !== -1) {
                                    activeBlankIndex = firstHiddenIndex;
                                    // Re-render to show active state immediately? style update instead
                                    const blank = gameArea.querySelector('.eq-hidden[data-idx="' + firstHiddenIndex + '"]');
                                    if (blank) blank.classList.add('active');
                                }

                                // Listeners for blanks
                                gameArea.querySelectorAll('.eq-hidden').forEach(el => {
                                    el.addEventListener('click', () => {
                                        activeBlankIndex = parseInt(el.dataset.idx);
                                        renderRecallPhase(); // Re-render to update active styling
                                    });
                                });

                                // Listeners for inputs
                                gameArea.querySelectorAll('.num-btn, .op-btn').forEach(btn => {
                                    btn.addEventListener('click', () => handleInput(btn.dataset.val));
                                });

                                document.getElementById('submitBtn').addEventListener('click', checkAnswer);
                            }

                            function handleInput(val) {
                                if (activeBlankIndex === -1) return;

                                const part = currentEqParts[activeBlankIndex];

                                if (val === 'back') {
                                    part.userVal = part.userVal.slice(0, -1);
                                } else {
                                    // If expecting operator, overwrite
                                    if (['+', '-', 'x'].includes(val)) {
                                        part.userVal = val;
                                    } else {
                                        // Numbers can be multi-digit
                                        if (part.userVal.length < 3) part.userVal += val;
                                    }
                                }

                                renderRecallPhase();
                            }

                            function checkAnswer() {
                                let allCorrect = true;
                                let filledAll = true;

                                currentEqParts.forEach(p => {
                                    if (p.hidden) {
                                        if (!p.userVal) filledAll = false;
                                        if (p.userVal !== p.val) allCorrect = false;
                                    }
                                });

                                if (!filledAll) {
                                    MathMemory.ui.showToast('Fill all blanks!', 'warning');
                                    return;
                                }

                                if (allCorrect) {
                                    streak++;
                                    const points = CONFIG[difficulty].points + (streak * 10);
                                    score += points;
                                    MathMemory.ui.showToast('Restored! +' + points, 'success');
                                } else {
                                    streak = 0;
                                    MathMemory.ui.showToast('Corrupted Data! Wrong.', 'error');
                                }

                                updateStats();
                                setTimeout(() => {
                                    round++;
                                    activeBlankIndex = -1;
                                    updateStats();
                                    startRound();
                                }, 1500);
                            }

                            function endGame() {
                                totalGameTime = Math.floor((Date.now() - gameStartTime) / 1000);
                                document.getElementById('finalScore').textContent = score;
                                document.getElementById('finalTime').textContent = 'Time: ' + MathMemory.ui.formatTime(totalGameTime);
                                MathMemory.storage.setHighScore('equation-echo', difficulty, score);
                                winModal.classList.add('active');
                                if (score > 0) MathMemory.ui.confetti();
                            }

                            function shareScore() {
                                MathMemory.share.share('equation-echo', 'Equation Echo', score, difficulty, {
                                    time: totalGameTime,
                                    rounds: maxRounds,
                                    streak: streak
                                });
                                winModal.classList.remove('active');
                            }

                            init();
                        })();
                    </script>