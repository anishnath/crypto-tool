<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="seo-helper.jsp" %>
        <% String pageKey="match" ; String seoTitle=getSEOTitle(pageKey, application); String
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
                        --neon-purple: #a855f7;
                        --neon-cyan: #22d3ee;
                        --neon-pink: #ec4899;
                        --neon-green: #22c55e;
                        --neon-yellow: #facc15;
                        --arcade-dark: #0f0a1e;
                        --arcade-card: #1a1333;
                        --arcade-border: #2d2255;
                        --glow-purple: 0 0 20px rgba(168, 85, 247, 0.5);
                        --glow-cyan: 0 0 20px rgba(34, 211, 238, 0.5);
                    }

                    .game-page {
                        background: linear-gradient(135deg, var(--arcade-dark) 0%, #1a0a2e 50%, var(--arcade-dark) 100%);
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
                            linear-gradient(rgba(168, 85, 247, 0.03) 1px, transparent 1px),
                            linear-gradient(90deg, rgba(168, 85, 247, 0.03) 1px, transparent 1px);
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
                        background: linear-gradient(135deg, var(--neon-purple), var(--neon-cyan));
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
                        color: var(--neon-cyan);
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
                        min-width: 100px;
                    }

                    .stat-value {
                        font-size: var(--text-2xl);
                        font-weight: 700;
                        color: var(--neon-cyan);
                        text-shadow: var(--glow-cyan);
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
                        border-color: var(--neon-purple);
                        color: white;
                    }

                    .diff-btn.active {
                        border-color: var(--neon-cyan);
                        color: var(--neon-cyan);
                        box-shadow: var(--glow-cyan);
                    }

                    /* Card Grid */
                    .card-grid {
                        display: grid;
                        gap: var(--space-3);
                        justify-content: center;
                        margin: 0 auto;
                    }

                    .card-grid.easy {
                        grid-template-columns: repeat(4, 1fr);
                        max-width: 500px;
                    }

                    .card-grid.medium {
                        grid-template-columns: repeat(4, 1fr);
                        max-width: 600px;
                    }

                    .card-grid.hard {
                        grid-template-columns: repeat(6, 1fr);
                        max-width: 750px;
                    }

                    /* Memory Card */
                    .memory-card {
                        aspect-ratio: 1;
                        perspective: 1000px;
                        cursor: pointer;
                    }

                    .memory-card-inner {
                        position: relative;
                        width: 100%;
                        height: 100%;
                        transition: transform 0.5s;
                        transform-style: preserve-3d;
                    }

                    .memory-card.flipped .memory-card-inner {
                        transform: rotateY(180deg);
                    }

                    .memory-card.matched .memory-card-inner {
                        transform: rotateY(180deg);
                    }

                    .memory-card.matched {
                        pointer-events: none;
                    }

                    .card-face {
                        position: absolute;
                        width: 100%;
                        height: 100%;
                        backface-visibility: hidden;
                        border-radius: var(--radius-lg);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-weight: 700;
                        border: 2px solid var(--arcade-border);
                    }

                    .card-front {
                        background: linear-gradient(135deg, var(--arcade-card), #251a4a);
                        color: var(--neon-purple);
                        font-size: 2rem;
                    }

                    .card-front::after {
                        content: '?';
                    }

                    .card-back {
                        background: var(--arcade-card);
                        transform: rotateY(180deg);
                        padding: var(--space-2);
                        text-align: center;
                        word-break: break-word;
                    }

                    .card-back.problem {
                        background: linear-gradient(135deg, #2d1a5e, var(--arcade-card));
                        border-color: var(--neon-purple);
                        color: white;
                        font-size: clamp(0.875rem, 2vw, 1.25rem);
                    }

                    .card-back.answer {
                        background: linear-gradient(135deg, #0a2a3a, var(--arcade-card));
                        border-color: var(--neon-cyan);
                        color: var(--neon-cyan);
                        font-size: clamp(1.25rem, 3vw, 1.75rem);
                    }

                    .memory-card.matched .card-back {
                        border-color: var(--neon-green);
                        box-shadow: 0 0 20px rgba(34, 197, 94, 0.4);
                    }

                    .memory-card.matched .card-back.problem,
                    .memory-card.matched .card-back.answer {
                        background: linear-gradient(135deg, #0a3a2a, var(--arcade-card));
                    }

                    /* Wrong match animation */
                    .memory-card.wrong .memory-card-inner {
                        animation: shake 0.4s ease;
                    }

                    @keyframes shake {

                        0%,
                        100% {
                            transform: rotateY(180deg) translateX(0);
                        }

                        25% {
                            transform: rotateY(180deg) translateX(-5px);
                        }

                        75% {
                            transform: rotateY(180deg) translateX(5px);
                        }
                    }

                    /* Game Controls */
                    .game-controls {
                        display: flex;
                        justify-content: center;
                        gap: var(--space-4);
                        margin-top: var(--space-6);
                    }

                    .game-btn {
                        padding: var(--space-3) var(--space-6);
                        border: 2px solid var(--neon-purple);
                        border-radius: var(--radius-lg);
                        background: transparent;
                        color: var(--neon-purple);
                        font-size: var(--text-base);
                        font-weight: 600;
                        cursor: pointer;
                        transition: all 0.2s;
                    }

                    .game-btn:hover {
                        background: var(--neon-purple);
                        color: white;
                        box-shadow: var(--glow-purple);
                    }

                    .game-btn.primary {
                        background: var(--neon-cyan);
                        border-color: var(--neon-cyan);
                        color: #0a0a0a;
                    }

                    .game-btn.primary:hover {
                        box-shadow: var(--glow-cyan);
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
                        border: 2px solid var(--neon-green);
                        border-radius: var(--radius-xl);
                        padding: var(--space-8);
                        text-align: center;
                        max-width: 400px;
                        width: 90%;
                        box-shadow: 0 0 60px rgba(34, 197, 94, 0.3);
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

                    .win-title {
                        font-size: var(--text-2xl);
                        font-weight: 700;
                        color: var(--neon-green);
                        margin-bottom: var(--space-2);
                    }

                    .win-subtitle {
                        color: rgba(255, 255, 255, 0.6);
                        margin-bottom: var(--space-6);
                    }

                    .win-stats {
                        display: flex;
                        justify-content: center;
                        gap: var(--space-6);
                        margin-bottom: var(--space-6);
                    }

                    .win-stat {
                        text-align: center;
                    }

                    .win-stat-value {
                        font-size: var(--text-2xl);
                        font-weight: 700;
                        color: var(--neon-cyan);
                    }

                    .win-stat-label {
                        font-size: var(--text-sm);
                        color: rgba(255, 255, 255, 0.5);
                    }

                    .new-record {
                        background: linear-gradient(135deg, var(--neon-yellow), var(--neon-orange));
                        -webkit-background-clip: text;
                        -webkit-text-fill-color: transparent;
                        background-clip: text;
                        font-weight: 700;
                        margin-bottom: var(--space-4);
                    }

                    /* Toast */
                    .game-toast {
                        position: fixed;
                        bottom: 100px;
                        left: 50%;
                        transform: translateX(-50%) translateY(20px);
                        background: var(--arcade-card);
                        border: 1px solid var(--arcade-border);
                        border-radius: var(--radius-lg);
                        padding: var(--space-3) var(--space-6);
                        color: white;
                        font-weight: 500;
                        opacity: 0;
                        visibility: hidden;
                        transition: all 0.3s;
                        z-index: 50;
                    }

                    .game-toast.active {
                        opacity: 1;
                        visibility: visible;
                        transform: translateX(-50%) translateY(0);
                    }

                    .game-toast.success {
                        border-left: 3px solid var(--neon-green);
                    }

                    .game-toast.error {
                        border-left: 3px solid var(--neon-pink);
                    }

                    /* Confetti */
                    .confetti-container {
                        position: fixed;
                        top: 0;
                        left: 0;
                        right: 0;
                        bottom: 0;
                        pointer-events: none;
                        z-index: 200;
                        overflow: hidden;
                    }

                    .confetti-piece {
                        position: absolute;
                        width: 10px;
                        height: 10px;
                        top: -10px;
                        animation: confetti-fall 3s ease-out forwards;
                    }

                    @keyframes confetti-fall {
                        to {
                            top: 100vh;
                            transform: rotate(720deg) translateX(100px);
                            opacity: 0;
                        }
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

                    /* Responsive visibility */
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

                    /* Responsive */
                    @media (max-width: 600px) {
                        .card-grid.easy {
                            grid-template-columns: repeat(3, 1fr);
                        }

                        .card-grid.medium {
                            grid-template-columns: repeat(4, 1fr);
                        }

                        .card-grid.hard {
                            grid-template-columns: repeat(4, 1fr);
                        }

                        .stats-bar {
                            gap: var(--space-2);
                        }

                        .stat-item {
                            padding: var(--space-2) var(--space-3);
                            min-width: 70px;
                        }

                        .stat-value {
                            font-size: var(--text-xl);
                        }
                    }
                </style>

                <div class="game-page">
                    <div class="game-container">
                        <!-- Ad: Top Leaderboard (Desktop) -->
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
                                <span class="game-title-icon">&#127183;</span>
                                <h1>Match Master</h1>
                            </div>
                            <div style="width: 60px;"></div>
                        </div>

                        <!-- Stats Bar -->
                        <div class="stats-bar">
                            <div class="stat-item">
                                <div class="stat-value" id="movesCount">0</div>
                                <div class="stat-label">Moves</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value" id="matchesCount">0</div>
                                <div class="stat-label">Matches</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value" id="timerDisplay">0:00</div>
                                <div class="stat-label">Time</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value" id="highScore">-</div>
                                <div class="stat-label">Best</div>
                            </div>
                        </div>

                        <!-- Difficulty Selector -->
                        <div class="difficulty-selector">
                            <button class="diff-btn active" data-difficulty="easy">Easy (6 pairs)</button>
                            <button class="diff-btn" data-difficulty="medium">Medium (8 pairs)</button>
                            <button class="diff-btn" data-difficulty="hard">Hard (12 pairs)</button>
                        </div>

                        <!-- Card Grid -->
                        <div class="card-grid easy" id="cardGrid">
                            <!-- Cards generated by JS -->
                        </div>

                        <!-- Game Controls -->
                        <div class="game-controls">
                            <button class="game-btn" id="restartBtn">Restart</button>
                        </div>

                        <!-- Ad: Mobile Leaderboard (shown below game) -->
                        <div class="ad-container-bottom mobile-only">
                            <%@ include file="../components/ad-leaderboard.jsp" %>
                        </div>
                    </div>
                </div>

                <!-- Mobile Anchor Ad -->
                <%@ include file="../components/ad-anchor.jsp" %>

                    <!-- Win Modal -->
                    <div class="win-modal" id="winModal">
                        <div class="win-content">
                            <div class="win-icon">&#127942;</div>
                            <h2 class="win-title">You Win!</h2>
                            <p class="win-subtitle">All pairs matched!</p>
                            <div id="newRecordText" class="new-record" style="display:none;">&#11088; New High Score!
                            </div>
                            <div class="win-stats">
                                <div class="win-stat">
                                    <div class="win-stat-value" id="finalMoves">0</div>
                                    <div class="win-stat-label">Moves</div>
                                </div>
                                <div class="win-stat">
                                    <div class="win-stat-value" id="finalTime">0:00</div>
                                    <div class="win-stat-label">Time</div>
                                </div>
                                <div class="win-stat">
                                    <div class="win-stat-value" id="finalScore">0</div>
                                    <div class="win-stat-label">Score</div>
                                </div>
                            </div>
                            <div style="display: flex; gap: var(--space-3); justify-content: center;">
                                <button class="game-btn primary" id="playAgainBtn">Play Again</button>
                                <button class="game-btn" id="shareBtn">Share</button>
                            </div>
                        </div>
                    </div>

                    <!-- Toast -->
                    <div class="game-toast" id="gameToast"></div>

                    <script>
                        (function () {
                            // Game State
                            let difficulty = 'easy';
                            let cards = [];
                            let flippedCards = [];
                            let matchedPairs = 0;
                            let moves = 0;
                            let totalPairs = 6;
                            let gameStarted = false;
                            let timer = null;
                            let seconds = 0;
                            let isLocked = false;

                            // DOM Elements
                            const cardGrid = document.getElementById('cardGrid');
                            const movesDisplay = document.getElementById('movesCount');
                            const matchesDisplay = document.getElementById('matchesCount');
                            const timerDisplay = document.getElementById('timerDisplay');
                            const highScoreDisplay = document.getElementById('highScore');
                            const winModal = document.getElementById('winModal');
                            const diffButtons = document.querySelectorAll('.diff-btn');

                            // Initialize
                            function init() {
                                loadHighScore();
                                setupDifficultyButtons();
                                createGame();

                                document.getElementById('restartBtn').addEventListener('click', createGame);
                                document.getElementById('playAgainBtn').addEventListener('click', function () {
                                    winModal.classList.remove('active');
                                    createGame();
                                });
                                document.getElementById('shareBtn').addEventListener('click', shareScore);
                            }

                            function setupDifficultyButtons() {
                                diffButtons.forEach(function (btn) {
                                    btn.addEventListener('click', function () {
                                        diffButtons.forEach(function (b) { b.classList.remove('active'); });
                                        btn.classList.add('active');
                                        difficulty = btn.dataset.difficulty;
                                        loadHighScore();
                                        createGame();
                                    });
                                });
                            }

                            function loadHighScore() {
                                const score = MathMemory.storage.getHighScore('match', difficulty);
                                highScoreDisplay.textContent = score > 0 ? score : '-';
                            }

                            function createGame() {
                                // Reset state
                                stopTimer();
                                seconds = 0;
                                moves = 0;
                                matchedPairs = 0;
                                flippedCards = [];
                                gameStarted = false;
                                isLocked = false;

                                // Update UI
                                movesDisplay.textContent = '0';
                                matchesDisplay.textContent = '0';
                                timerDisplay.textContent = '0:00';

                                // Set pairs based on difficulty
                                totalPairs = MathMemory.config.difficulties[difficulty].pairs;

                                // Update grid class
                                cardGrid.className = 'card-grid ' + difficulty;

                                // Generate problem-answer pairs
                                const types = difficulty === 'easy' ?
                                    ['addition', 'subtraction'] :
                                    ['addition', 'subtraction', 'multiplication'];

                                const pairs = MathMemory.problems.generatePairs(totalPairs, difficulty, types);

                                // Create card data (problem + answer for each pair)
                                cards = [];
                                pairs.forEach(function (pair, index) {
                                    cards.push({ id: index, type: 'problem', text: pair.text, pairId: index });
                                    cards.push({ id: index, type: 'answer', text: pair.answer.toString(), pairId: index });
                                });

                                // Shuffle cards
                                cards = MathMemory.ui.shuffle(cards);

                                // Render cards
                                renderCards();
                            }

                            function renderCards() {
                                cardGrid.innerHTML = '';

                                cards.forEach(function (card, index) {
                                    var cardEl = document.createElement('div');
                                    cardEl.className = 'memory-card';
                                    cardEl.dataset.index = index;
                                    cardEl.innerHTML =
                                        '<div class="memory-card-inner">' +
                                        '<div class="card-face card-front"></div>' +
                                        '<div class="card-face card-back ' + card.type + '">' + card.text + '</div>' +
                                        '</div>';

                                    cardEl.addEventListener('click', function () { flipCard(cardEl, index); });
                                    cardGrid.appendChild(cardEl);
                                });
                            }

                            function flipCard(cardEl, index) {
                                // Ignore if locked, already flipped, or matched
                                if (isLocked) return;
                                if (cardEl.classList.contains('flipped')) return;
                                if (cardEl.classList.contains('matched')) return;
                                if (flippedCards.length >= 2) return;

                                // Start timer on first flip
                                if (!gameStarted) {
                                    gameStarted = true;
                                    startTimer();
                                }

                                // Flip the card
                                cardEl.classList.add('flipped');
                                flippedCards.push({ el: cardEl, card: cards[index] });

                                // Check for match when 2 cards flipped
                                if (flippedCards.length === 2) {
                                    moves++;
                                    movesDisplay.textContent = moves;
                                    checkMatch();
                                }
                            }

                            function checkMatch() {
                                var card1 = flippedCards[0];
                                var card2 = flippedCards[1];

                                // Match if same pairId but different type (problem vs answer)
                                var isMatch = card1.card.pairId === card2.card.pairId &&
                                    card1.card.type !== card2.card.type;

                                if (isMatch) {
                                    // Mark as matched
                                    card1.el.classList.add('matched');
                                    card2.el.classList.add('matched');
                                    matchedPairs++;
                                    matchesDisplay.textContent = matchedPairs;
                                    flippedCards = [];

                                    // Check win
                                    if (matchedPairs === totalPairs) {
                                        setTimeout(handleWin, 500);
                                    }
                                } else {
                                    // Wrong match - shake and flip back
                                    isLocked = true;
                                    card1.el.classList.add('wrong');
                                    card2.el.classList.add('wrong');

                                    setTimeout(function () {
                                        card1.el.classList.remove('flipped', 'wrong');
                                        card2.el.classList.remove('flipped', 'wrong');
                                        flippedCards = [];
                                        isLocked = false;
                                    }, 1000);
                                }
                            }

                            function startTimer() {
                                timer = setInterval(function () {
                                    seconds++;
                                    timerDisplay.textContent = MathMemory.ui.formatTime(seconds);
                                }, 1000);
                            }

                            function stopTimer() {
                                if (timer) {
                                    clearInterval(timer);
                                    timer = null;
                                }
                            }

                            function handleWin() {
                                stopTimer();

                                // Calculate score
                                var basePoints = totalPairs * 100;
                                var perfectMoves = totalPairs; // Best case: find each pair in one try
                                var bonusMoves = Math.max(0, (totalPairs * 2) - moves); // Bonus for fewer moves
                                var score = MathMemory.ui.calculateScore(basePoints, seconds, difficulty, bonusMoves);

                                // Check high score
                                var isNewRecord = MathMemory.storage.setHighScore('match', difficulty, score);
                                if (isNewRecord) {
                                    loadHighScore();
                                }

                                // Update stats
                                MathMemory.storage.updateStats('match', score, matchedPairs);

                                // Show win modal
                                document.getElementById('finalMoves').textContent = moves;
                                document.getElementById('finalTime').textContent = MathMemory.ui.formatTime(seconds);
                                document.getElementById('finalScore').textContent = score;
                                document.getElementById('newRecordText').style.display = isNewRecord ? 'block' : 'none';

                                winModal.classList.add('active');

                                // Confetti!
                                if (isNewRecord) {
                                    MathMemory.ui.confetti();
                                }
                            }

                            function shareScore() {
                                var finalScore = document.getElementById('finalScore').textContent;
                                MathMemory.share.share('match', 'Match Master', finalScore, difficulty, {
                                    time: seconds,
                                    moves: moves,
                                    custom: 'Pairs: ' + totalPairs
                                });
                                winModal.classList.remove('active');
                            }

                            // Start game
                            init();
                        })();
                    </script>

                    <%@ include file="../components/footer.jsp" %>