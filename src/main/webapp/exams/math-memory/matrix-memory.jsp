<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="seo-helper.jsp" %>
        <% String pageKey="matrix-memory" ; String seoTitle=getSEOTitle(pageKey, application); String
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
                        --neon-violet: #8b5cf6;
                        --neon-fuchsia: #d946ef;
                        --arcade-dark: #0f0a1e;
                        --arcade-card: #1a1333;
                        --arcade-border: #2d2255;
                        --glow-violet: 0 0 20px rgba(139, 92, 246, 0.5);
                    }

                    .game-page {
                        background: linear-gradient(135deg, var(--arcade-dark) 0%, #1e1b4b 50%, var(--arcade-dark) 100%);
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
                            radial-gradient(circle at 20% 30%, rgba(139, 92, 246, 0.1) 0%, transparent 40%),
                            radial-gradient(circle at 80% 70%, rgba(217, 70, 239, 0.1) 0%, transparent 40%);
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
                        background: linear-gradient(135deg, var(--neon-violet), var(--neon-fuchsia));
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
                        color: var(--neon-violet);
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
                        color: var(--neon-violet);
                        text-shadow: var(--glow-violet);
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
                        border-color: var(--neon-violet);
                        color: white;
                    }

                    .diff-btn.active {
                        border-color: var(--neon-violet);
                        color: var(--neon-violet);
                        box-shadow: var(--glow-violet);
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
                    }

                    /* Rule Display */
                    .rule-display {
                        text-align: center;
                        margin-bottom: var(--space-6);
                        animation: fadeIn 0.5s ease-out;
                    }

                    .rule-label {
                        font-size: var(--text-sm);
                        color: rgba(255, 255, 255, 0.6);
                        text-transform: uppercase;
                        letter-spacing: 1px;
                        margin-bottom: var(--space-2);
                    }

                    .rule-text {
                        font-size: 1.5rem;
                        font-weight: 700;
                        color: white;
                    }

                    .rule-highlight {
                        color: var(--neon-fuchsia);
                    }

                    /* Grid */
                    .matrix-grid {
                        display: grid !important;
                        gap: 12px;
                        margin: 24px auto;
                        padding: 16px;
                        background: rgba(139, 92, 246, 0.2);
                        border-radius: 12px;
                        border: 2px solid #8b5cf6;
                    }

                    .matrix-cell {
                        width: 60px;
                        height: 60px;
                        background: rgba(139, 92, 246, 0.3);
                        border: 2px solid #8b5cf6;
                        border-radius: 8px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 1.25rem;
                        font-weight: 600;
                        color: white;
                        cursor: pointer;
                        user-select: none;
                    }

                    .matrix-cell.obscured {
                        color: white;
                        background: rgba(139, 92, 246, 0.4);
                        border: 2px dashed #d946ef;
                        font-size: 1.5rem;
                    }

                    .matrix-cell.obscured:hover {
                        background: rgba(139, 92, 246, 0.5);
                        border-color: var(--neon-fuchsia);
                        border-style: solid;
                        color: white;
                        transform: scale(1.08);
                        box-shadow: 0 0 15px rgba(139, 92, 246, 0.5);
                    }

                    .matrix-cell.selected {
                        background: var(--neon-violet);
                        border: 2px solid white;
                        color: white;
                        box-shadow: var(--glow-violet);
                        transform: scale(1.05);
                    }

                    .matrix-cell.selected::after {
                        content: '\2713';
                        font-size: 1.5rem;
                    }

                    /* Correct/Wrong States - ensure visible numbers */
                    .matrix-cell.correct {
                        background: #22c55e;
                        border: 2px solid #22c55e;
                        color: white !important;
                        font-size: 1.25rem;
                    }

                    .matrix-cell.wrong {
                        background: #ef4444;
                        border: 2px solid #ef4444;
                        color: white !important;
                        font-size: 1.25rem;
                        animation: shake 0.4s;
                    }

                    .matrix-cell.missed {
                        border: 2px solid #facc15;
                        color: #facc15 !important;
                        background: rgba(250, 204, 21, 0.2);
                        font-size: 1.25rem;
                    }

                    /* Non-target cells that weren't selected (neutral) */
                    .matrix-cell.neutral {
                        background: rgba(255, 255, 255, 0.05);
                        border: 1px solid var(--arcade-border);
                        color: rgba(255, 255, 255, 0.5);
                        font-size: 1.25rem;
                    }

                    /* Timer */
                    .timer-bar {
                        position: absolute;
                        top: 0;
                        left: 0;
                        right: 0;
                        height: 4px;
                        background: var(--neon-fuchsia);
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
                        border: 2px solid var(--neon-violet);
                        border-radius: var(--radius-full);
                        background: var(--neon-violet);
                        color: white;
                        font-size: 1.2rem;
                        font-weight: 700;
                        cursor: pointer;
                        box-shadow: var(--glow-violet);
                        transition: transform 0.2s;
                    }

                    .action-btn:hover {
                        transform: scale(1.05);
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
                        border: 2px solid var(--neon-fuchsia);
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
                                <span class="game-title-icon">&#128160;</span>
                                <h1>Matrix Memory</h1>
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

                        <!-- Game Area (tex2jax_ignore prevents MathJax conflicts) -->
                        <div class="game-area tex2jax_ignore" id="gameArea">
                            <div class="timer-bar" id="timerBar"></div>

                            <div class="state-message" id="introView">
                                <div class="state-title">Scan the Matrix</div>
                                <p class="state-desc">
                                    A grid of numbers will appear. A rule will be given (e.g., "Odd Numbers").<br>
                                    Memorize the positions of all numbers matching the rule.
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
                        <div style="font-size:4rem; margin-bottom:1rem;">&#127775;</div>
                        <h2 style="font-size:2rem; font-weight:700; color:white; margin-bottom:1rem;">Matrix Mastered!
                        </h2>
                        <div style="font-size:3rem; font-weight:700; color:var(--neon-fuchsia); margin-bottom:0.5rem;"
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
                                easy: { rows: 3, cols: 3, showTime: 3000, points: 100, rules: ['even', 'odd', 'gt5'] },
                                medium: { rows: 4, cols: 4, showTime: 4000, points: 150, rules: ['mult3', 'mult5', 'lt10', 'div2'] },
                                hard: { rows: 5, cols: 5, showTime: 5000, points: 200, rules: ['prime', 'square', 'mult4', 'ends1'] }
                            };

                            // State
                            let difficulty = 'easy';
                            let round = 1;
                            let maxRounds = 10;
                            let score = 0;
                            let streak = 0;
                            let gridData = []; // Array of { val: 5, target: true/false }
                            let currentRule = null;
                            let isMemoryPhase = false;
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
                                const hs = MathMemory.storage.getHighScore('matrix-memory', difficulty);
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
            <div class="state-title">Scan the Matrix</div>
            <p class="state-desc">A grid of numbers will appear. Memorize the positions of all numbers matching the rule.</p>
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
                                // Pick Rule
                                const ruleKey = cfg.rules[Math.floor(Math.random() * cfg.rules.length)];
                                currentRule = getRuleDetails(ruleKey);

                                // Generate Grid
                                const size = cfg.rows * cfg.cols;
                                gridData = [];
                                let targetCount = 0;

                                // Ensure at least 3 targets
                                const minTargets = 3;

                                while (true) {
                                    gridData = [];
                                    targetCount = 0;
                                    for (let i = 0; i < size; i++) {
                                        // Generate numbers roughly appropriate for rule
                                        let val = Math.floor(Math.random() * 50) + 1; // 1-50
                                        // Adjust randomness if needed to force more/less matches?
                                        // For now pure random is okay but might lead to 0 matches.

                                        // Let's force match sometimes
                                        if (targetCount < minTargets && i > size - 4) {
                                            // Try to force generating a matching number
                                            // Simple heuristic: just try 10 times to get a match
                                            for (let k = 0; k < 10; k++) {
                                                val = Math.floor(Math.random() * 50) + 1;
                                                if (currentRule.check(val)) break;
                                            }
                                        }

                                        const isMatch = currentRule.check(val);
                                        if (isMatch) targetCount++;
                                        gridData.push({ val, target: isMatch, selected: false });
                                    }
                                    if (targetCount >= 3) break;
                                }

                                renderStudyPhase();
                            }

                            function getRuleDetails(key) {
                                switch (key) {
                                    case 'even': return { text: "Even Numbers", check: n => n % 2 === 0 };
                                    case 'odd': return { text: "Odd Numbers", check: n => n % 2 !== 0 };
                                    case 'gt5': return { text: "Numbers > 5", check: n => n > 5 };
                                    case 'lt10': return { text: "Numbers < 10", check: n => n < 10 };
                                    case 'mult3': return { text: "Multiples of 3", check: n => n % 3 === 0 };
                                    case 'mult4': return { text: "Multiples of 4", check: n => n % 4 === 0 };
                                    case 'mult5': return { text: "Multiples of 5", check: n => n % 5 === 0 };
                                    case 'div2': return { text: "Numbers Divisible by 2", check: n => n % 2 === 0 }; // same as even
                                    case 'ends1': return { text: "Ends in 1", check: n => n % 10 === 1 };
                                    case 'square': return {
                                        text: "Perfect Squares", check: n => {
                                            const s = Math.sqrt(n); return s === Math.floor(s);
                                        }
                                    };
                                    case 'prime': return { text: "Prime Numbers", check: n => isPrime(n) };
                                    default: return { text: "Any Number", check: () => true };
                                }
                            }

                            function isPrime(num) {
                                if (num <= 1) return false;
                                if (num <= 3) return true;
                                if (num % 2 === 0 || num % 3 === 0) return false;
                                for (let i = 5; i * i <= num; i += 6) {
                                    if (num % i === 0 || num % (i + 2) === 0) return false;
                                }
                                return true;
                            }

                            function renderStudyPhase() {
                                const cfg = CONFIG[difficulty];
                                isMemoryPhase = true;

                                let gridHtml = '<div class="matrix-grid" style="grid-template-columns: repeat(' + cfg.cols + ', 60px); justify-content: center;">';
                                gridData.forEach((cell, idx) => {
                                    gridHtml += '<div class="matrix-cell">' + cell.val + '</div>';
                                });
                                gridHtml += '</div>';

                                const html =
                                    '<div class="rule-display">' +
                                    '<div class="rule-label">Memorize Locations Of</div>' +
                                    '<div class="rule-text"><span class="rule-highlight">' + currentRule.text + '</span></div>' +
                                    '</div>' +
                                    gridHtml;

                                gameArea.innerHTML = html;
                                gameArea.appendChild(timerBar);

                                // Timer
                                timerBar.style.width = '100%';
                                timerBar.style.transition = 'width ' + cfg.showTime + 'ms linear';
                                timerBar.offsetHeight;
                                setTimeout(() => { timerBar.style.width = '0%'; }, 50);

                                setTimeout(() => {
                                    renderActionPhase();
                                }, cfg.showTime);
                            }

                            function renderActionPhase() {
                                isMemoryPhase = false;
                                const cfg = CONFIG[difficulty];

                                // Count how many targets there are
                                const targetCount = gridData.filter(d => d.target).length;

                                console.log('renderActionPhase called, gridData length:', gridData.length, 'cols:', cfg.cols);

                                // Build grid cells with inline styles
                                let cellsHtml = '';
                                for (let i = 0; i < gridData.length; i++) {
                                    cellsHtml += '<div class="matrix-cell obscured" data-idx="' + i + '" style="width:60px;height:60px;background:rgba(139,92,246,0.4);border:2px dashed #d946ef;border-radius:8px;display:flex;align-items:center;justify-content:center;color:white;font-size:1.5rem;cursor:pointer;">?</div>';
                                }

                                // Build complete HTML with inline grid styles
                                const fullHtml =
                                    '<div class="rule-display">' +
                                        '<div class="rule-label">Click cells where you saw</div>' +
                                        '<div class="rule-text"><span class="rule-highlight">' + currentRule.text + '</span></div>' +
                                        '<div style="color:rgba(255,255,255,0.5); font-size:0.85rem; margin-top:0.5rem;">Find all ' + targetCount + ' cells</div>' +
                                    '</div>' +
                                    '<div class="matrix-grid" style="display:grid;grid-template-columns:repeat(' + cfg.cols + ',60px);gap:12px;margin:24px auto;padding:16px;background:rgba(139,92,246,0.2);border:2px solid #8b5cf6;border-radius:12px;">' +
                                        cellsHtml +
                                    '</div>' +
                                    '<button class="action-btn" id="submitBtn" style="margin-top:20px;">Submit</button>';

                                console.log('Setting gameArea innerHTML, length:', fullHtml.length);
                                gameArea.innerHTML = fullHtml;
                                console.log('Grid cells found:', gameArea.querySelectorAll('.matrix-cell').length);

                                // Add click handlers
                                gameArea.querySelectorAll('.matrix-cell').forEach(function(cell) {
                                    cell.addEventListener('click', handleCellClick);
                                });

                                var submitBtn = document.getElementById('submitBtn');
                                if (submitBtn) {
                                    submitBtn.addEventListener('click', checkRound);
                                }
                            }

                            function handleCellClick(e) {
                                if (isMemoryPhase) return;
                                const cell = e.target;
                                const idx = parseInt(cell.dataset.idx);

                                if (cell.classList.contains('selected')) {
                                    cell.classList.remove('selected');
                                    cell.textContent = '?';
                                    gridData[idx].selected = false;
                                } else {
                                    cell.classList.add('selected');
                                    cell.textContent = '';
                                    gridData[idx].selected = true;
                                }
                            }

                            function checkRound() {
                                if (isMemoryPhase) return;

                                // Reveal all
                                const cells = gameArea.querySelectorAll('.matrix-cell');
                                let mistakes = 0;
                                let missed = 0;
                                let correct = 0;

                                cells.forEach((cell, idx) => {
                                    // Remove hidden and selected classes first
                                    cell.classList.remove('obscured', 'selected');
                                    cell.textContent = gridData[idx].val;

                                    const isTarget = gridData[idx].target;
                                    const isSelected = gridData[idx].selected;

                                    if (isTarget && isSelected) {
                                        cell.classList.add('correct');
                                        correct++;
                                    } else if (isTarget && !isSelected) {
                                        cell.classList.add('missed');
                                        missed++;
                                    } else if (!isTarget && isSelected) {
                                        cell.classList.add('wrong');
                                        mistakes++;
                                    } else {
                                        // Non-target, not selected - neutral
                                        cell.classList.add('neutral');
                                    }
                                });

                                // Calculate Score
                                if (mistakes === 0 && missed === 0) {
                                    streak++;
                                    const points = CONFIG[difficulty].points + (streak * 10);
                                    score += points;
                                    MathMemory.ui.showToast('Perfect! +' + points, 'success');
                                } else {
                                    streak = 0;
                                    MathMemory.ui.showToast('Missed ' + missed + ', Wrong ' + mistakes, 'error');
                                }

                                updateStats();

                                // Disable board
                                const submitBtn = gameArea.querySelector('.action-btn');
                                if (submitBtn) submitBtn.remove();

                                setTimeout(() => {
                                    round++;
                                    updateStats();
                                    startRound();
                                }, 2500);
                            }

                            function endGame() {
                                totalGameTime = Math.floor((Date.now() - gameStartTime) / 1000);
                                document.getElementById('finalScore').textContent = score;
                                document.getElementById('finalTime').textContent = 'Time: ' + MathMemory.ui.formatTime(totalGameTime);
                                MathMemory.storage.setHighScore('matrix-memory', difficulty, score);
                                winModal.classList.add('active');
                                if (score > 0) MathMemory.ui.confetti();
                            }

                            function shareScore() {
                                MathMemory.share.share('matrix-memory', 'Matrix Memory', score, difficulty, {
                                    time: totalGameTime,
                                    rounds: maxRounds,
                                    streak: streak
                                });
                                winModal.classList.remove('active');
                            }

                            init();
                        })();
                    </script>