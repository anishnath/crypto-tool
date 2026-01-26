<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="seo-helper.jsp" %>
        <% String pageKey="sequence" ; String seoTitle=getSEOTitle(pageKey, application); String
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
                        background: linear-gradient(135deg, var(--arcade-dark) 0%, #0a1e2e 50%, var(--arcade-dark) 100%);
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
                            linear-gradient(rgba(34, 211, 238, 0.03) 1px, transparent 1px),
                            linear-gradient(90deg, rgba(34, 211, 238, 0.03) 1px, transparent 1px);
                        background-size: 50px 50px;
                        pointer-events: none;
                        z-index: 0;
                    }

                    .game-container {
                        position: relative;
                        z-index: 1;
                        max-width: 800px;
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
                        background: linear-gradient(135deg, var(--neon-cyan), var(--neon-purple));
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
                        min-width: 80px;
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
                        border-color: var(--neon-cyan);
                        color: white;
                    }

                    .diff-btn.active {
                        border-color: var(--neon-cyan);
                        color: var(--neon-cyan);
                        box-shadow: var(--glow-cyan);
                    }

                    /* Sequence Display */
                    .sequence-container {
                        background: var(--arcade-card);
                        border: 2px solid var(--arcade-border);
                        border-radius: var(--radius-xl);
                        padding: var(--space-8);
                        margin-bottom: var(--space-6);
                        text-align: center;
                    }

                    .sequence-numbers {
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        gap: var(--space-3);
                        flex-wrap: wrap;
                        margin-bottom: var(--space-6);
                    }

                    .seq-num {
                        background: linear-gradient(135deg, #0a2a3a, var(--arcade-card));
                        border: 2px solid var(--neon-cyan);
                        border-radius: var(--radius-lg);
                        min-width: 60px;
                        height: 60px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: var(--text-xl);
                        font-weight: 700;
                        color: var(--neon-cyan);
                        box-shadow: var(--glow-cyan);
                    }

                    .seq-num.mystery {
                        background: linear-gradient(135deg, #2d1a5e, var(--arcade-card));
                        border-color: var(--neon-purple);
                        color: var(--neon-purple);
                        font-size: var(--text-2xl);
                        box-shadow: var(--glow-purple);
                    }

                    .seq-arrow {
                        color: rgba(255, 255, 255, 0.3);
                        font-size: var(--text-xl);
                    }

                    /* Input Area */
                    .input-area {
                        display: flex;
                        justify-content: center;
                        gap: var(--space-3);
                        flex-wrap: wrap;
                    }

                    .answer-input {
                        background: var(--arcade-card);
                        border: 2px solid var(--arcade-border);
                        border-radius: var(--radius-lg);
                        padding: var(--space-3) var(--space-4);
                        font-size: var(--text-xl);
                        font-weight: 600;
                        color: white;
                        text-align: center;
                        width: 120px;
                        transition: all 0.2s;
                    }

                    .answer-input:focus {
                        outline: none;
                        border-color: var(--neon-cyan);
                        box-shadow: var(--glow-cyan);
                    }

                    .answer-input.correct {
                        border-color: var(--neon-green);
                        box-shadow: 0 0 20px rgba(34, 197, 94, 0.5);
                    }

                    .answer-input.wrong {
                        border-color: var(--neon-pink);
                        box-shadow: 0 0 20px rgba(236, 72, 153, 0.5);
                        animation: shake 0.4s ease;
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

                    .submit-btn {
                        padding: var(--space-3) var(--space-6);
                        border: 2px solid var(--neon-cyan);
                        border-radius: var(--radius-lg);
                        background: var(--neon-cyan);
                        color: #0a0a0a;
                        font-size: var(--text-base);
                        font-weight: 600;
                        cursor: pointer;
                        transition: all 0.2s;
                    }

                    .submit-btn:hover {
                        box-shadow: var(--glow-cyan);
                    }

                    .submit-btn:disabled {
                        opacity: 0.5;
                        cursor: not-allowed;
                    }

                    /* Feedback */
                    .feedback {
                        margin-top: var(--space-4);
                        padding: var(--space-3) var(--space-4);
                        border-radius: var(--radius-lg);
                        font-weight: 600;
                        opacity: 0;
                        transition: opacity 0.3s;
                    }

                    .feedback.show {
                        opacity: 1;
                    }

                    .feedback.correct {
                        background: rgba(34, 197, 94, 0.2);
                        border: 1px solid var(--neon-green);
                        color: var(--neon-green);
                    }

                    .feedback.wrong {
                        background: rgba(236, 72, 153, 0.2);
                        border: 1px solid var(--neon-pink);
                        color: var(--neon-pink);
                    }

                    /* Hint */
                    .hint-btn {
                        margin-top: var(--space-4);
                        padding: var(--space-2) var(--space-4);
                        border: 1px solid var(--arcade-border);
                        border-radius: var(--radius-md);
                        background: transparent;
                        color: rgba(255, 255, 255, 0.5);
                        font-size: var(--text-sm);
                        cursor: pointer;
                        transition: all 0.2s;
                    }

                    .hint-btn:hover {
                        border-color: var(--neon-yellow);
                        color: var(--neon-yellow);
                    }

                    .hint-text {
                        margin-top: var(--space-3);
                        font-size: var(--text-sm);
                        color: var(--neon-yellow);
                        opacity: 0;
                        transition: opacity 0.3s;
                    }

                    .hint-text.show {
                        opacity: 1;
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

                    /* Round indicator */
                    .round-indicator {
                        text-align: center;
                        margin-bottom: var(--space-4);
                        font-size: var(--text-sm);
                        color: rgba(255, 255, 255, 0.5);
                    }

                    .round-indicator span {
                        color: var(--neon-cyan);
                        font-weight: 600;
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
                        .stats-bar {
                            gap: var(--space-2);
                        }

                        .stat-item {
                            padding: var(--space-2) var(--space-3);
                            min-width: 65px;
                        }

                        .stat-value {
                            font-size: var(--text-xl);
                        }

                        .seq-num {
                            min-width: 50px;
                            height: 50px;
                            font-size: var(--text-lg);
                        }

                        .sequence-container {
                            padding: var(--space-5);
                        }

                        .answer-input {
                            width: 100px;
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
                                <span class="game-title-icon">&#128290;</span>
                                <h1>Sequence Solver</h1>
                            </div>
                            <div style="width: 60px;"></div>
                        </div>

                        <!-- Stats Bar -->
                        <div class="stats-bar">
                            <div class="stat-item">
                                <div class="stat-value" id="scoreDisplay">0</div>
                                <div class="stat-label">Score</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value" id="streakDisplay">0</div>
                                <div class="stat-label">Streak</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value" id="roundDisplay">1</div>
                                <div class="stat-label">Round</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value" id="highScore">-</div>
                                <div class="stat-label">Best</div>
                            </div>
                        </div>

                        <!-- Difficulty Selector -->
                        <div class="difficulty-selector">
                            <button class="diff-btn active" data-difficulty="easy">Easy</button>
                            <button class="diff-btn" data-difficulty="medium">Medium</button>
                            <button class="diff-btn" data-difficulty="hard">Hard</button>
                        </div>

                        <!-- Round Indicator -->
                        <div class="round-indicator">
                            Round <span id="currentRound">1</span> of <span id="totalRounds">10</span>
                        </div>

                        <!-- Sequence Display -->
                        <div class="sequence-container">
                            <div class="sequence-numbers" id="sequenceDisplay">
                                <!-- Sequence numbers generated by JS -->
                            </div>

                            <div class="input-area">
                                <input type="number" class="answer-input" id="answerInput" placeholder="?"
                                    autocomplete="off">
                                <button class="submit-btn" id="submitBtn">Submit</button>
                            </div>

                            <div class="feedback" id="feedback"></div>

                            <button class="hint-btn" id="hintBtn">Show Hint (-50 pts)</button>
                            <div class="hint-text" id="hintText"></div>
                        </div>

                        <!-- Game Controls -->
                        <div class="game-controls">
                            <button class="game-btn" id="newGameBtn">New Game</button>
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
                            <h2 class="win-title">Game Complete!</h2>
                            <p class="win-subtitle">You solved all sequences!</p>
                            <div id="newRecordText" class="new-record" style="display:none;">&#11088; New High Score!
                            </div>
                            <div class="win-stats">
                                <div class="win-stat">
                                    <div class="win-stat-value" id="finalScore">0</div>
                                    <div class="win-stat-label">Score</div>
                                </div>
                                <div class="win-stat">
                                    <div class="win-stat-value" id="finalCorrect">0</div>
                                    <div class="win-stat-label">Correct</div>
                                </div>
                                <div class="win-stat">
                                    <div class="win-stat-value" id="finalStreak">0</div>
                                    <div class="win-stat-label">Best Streak</div>
                                </div>
                            </div>
                            <div style="display: flex; gap: var(--space-3); justify-content: center;">
                                <button class="game-btn"
                                    style="background: var(--neon-cyan); border-color: var(--neon-cyan); color: #0a0a0a;"
                                    id="playAgainBtn">Play Again</button>
                                <button class="game-btn" id="shareBtn">Share</button>
                            </div>
                        </div>
                    </div>

                    <!-- Toast -->
                    <div class="game-toast" id="gameToast"></div>

                    <script>
                        (function () {
                            // Game Configuration
                            var CONFIG = {
                                easy: { seqLength: 4, rounds: 10, basePoints: 100 },
                                medium: { seqLength: 5, rounds: 10, basePoints: 150 },
                                hard: { seqLength: 6, rounds: 10, basePoints: 200 }
                            };

                            // Game State
                            var difficulty = 'easy';
                            var currentRound = 1;
                            var totalRounds = 10;
                            var score = 0;
                            var streak = 0;
                            var bestStreak = 0;
                            var correctCount = 0;
                            var currentSequence = null;
                            var hintUsed = false;
                            var gameStartTime = null;
                            var totalGameTime = 0;

                            // DOM Elements
                            var sequenceDisplay = document.getElementById('sequenceDisplay');
                            var answerInput = document.getElementById('answerInput');
                            var submitBtn = document.getElementById('submitBtn');
                            var feedback = document.getElementById('feedback');
                            var hintBtn = document.getElementById('hintBtn');
                            var hintText = document.getElementById('hintText');
                            var winModal = document.getElementById('winModal');
                            var diffButtons = document.querySelectorAll('.diff-btn');

                            // Initialize
                            function init() {
                                loadHighScore();
                                setupDifficultyButtons();
                                setupEventListeners();
                                startNewRound();
                            }

                            function setupDifficultyButtons() {
                                diffButtons.forEach(function (btn) {
                                    btn.addEventListener('click', function () {
                                        diffButtons.forEach(function (b) { b.classList.remove('active'); });
                                        btn.classList.add('active');
                                        difficulty = btn.dataset.difficulty;
                                        loadHighScore();
                                        resetGame();
                                    });
                                });
                            }

                            function setupEventListeners() {
                                submitBtn.addEventListener('click', checkAnswer);
                                answerInput.addEventListener('keypress', function (e) {
                                    if (e.key === 'Enter') checkAnswer();
                                });
                                hintBtn.addEventListener('click', showHint);
                                document.getElementById('newGameBtn').addEventListener('click', resetGame);
                                document.getElementById('playAgainBtn').addEventListener('click', function () {
                                    winModal.classList.remove('active');
                                    resetGame();
                                });
                                document.getElementById('shareBtn').addEventListener('click', shareScore);
                            }

                            function loadHighScore() {
                                var hs = MathMemory.storage.getHighScore('sequence', difficulty);
                                document.getElementById('highScore').textContent = hs > 0 ? hs : '-';
                            }

                            function resetGame() {
                                currentRound = 1;
                                score = 0;
                                streak = 0;
                                bestStreak = 0;
                                correctCount = 0;
                                totalRounds = CONFIG[difficulty].rounds;
                                gameStartTime = Date.now();
                                totalGameTime = 0;

                                updateDisplay();
                                startNewRound();
                            }

                            function updateDisplay() {
                                document.getElementById('scoreDisplay').textContent = score;
                                document.getElementById('streakDisplay').textContent = streak;
                                document.getElementById('roundDisplay').textContent = currentRound;
                                document.getElementById('currentRound').textContent = currentRound;
                                document.getElementById('totalRounds').textContent = totalRounds;
                            }

                            function startNewRound() {
                                // Reset UI
                                answerInput.value = '';
                                answerInput.classList.remove('correct', 'wrong');
                                answerInput.disabled = false;
                                submitBtn.disabled = false;
                                feedback.classList.remove('show', 'correct', 'wrong');
                                hintText.classList.remove('show');
                                hintUsed = false;
                                hintBtn.disabled = false;

                                // Generate new sequence
                                var seqLength = CONFIG[difficulty].seqLength;
                                currentSequence = MathMemory.sequences.getRandom(seqLength, difficulty);

                                // Render sequence
                                renderSequence();

                                // Focus input
                                setTimeout(function () { answerInput.focus(); }, 100);
                            }

                            function renderSequence() {
                                var html = '';
                                currentSequence.sequence.forEach(function (num, i) {
                                    if (i > 0) html += '<span class="seq-arrow">&rarr;</span>';
                                    html += '<div class="seq-num">' + num + '</div>';
                                });
                                html += '<span class="seq-arrow">&rarr;</span>';
                                html += '<div class="seq-num mystery">?</div>';

                                sequenceDisplay.innerHTML = html;
                            }

                            function checkAnswer() {
                                var userAnswer = parseInt(answerInput.value);
                                if (isNaN(userAnswer)) {
                                    answerInput.classList.add('wrong');
                                    setTimeout(function () { answerInput.classList.remove('wrong'); }, 400);
                                    return;
                                }

                                var isCorrect = userAnswer === currentSequence.next;

                                if (isCorrect) {
                                    // Correct answer
                                    answerInput.classList.add('correct');
                                    streak++;
                                    if (streak > bestStreak) bestStreak = streak;
                                    correctCount++;

                                    // Calculate points
                                    var points = CONFIG[difficulty].basePoints;
                                    if (!hintUsed) points += 50; // Bonus for no hint
                                    points += streak * 10; // Streak bonus
                                    score += points;

                                    feedback.textContent = 'Correct! +' + points + ' points';
                                    feedback.className = 'feedback show correct';

                                    MathMemory.ui.showToast('Correct! Streak: ' + streak, 'success');
                                } else {
                                    // Wrong answer
                                    answerInput.classList.add('wrong');
                                    streak = 0;

                                    feedback.textContent = 'Wrong! The answer was ' + currentSequence.next + ' (Pattern: ' + currentSequence.rule + ')';
                                    feedback.className = 'feedback show wrong';

                                    MathMemory.ui.showToast('Wrong! The pattern was ' + currentSequence.rule, 'error');
                                }

                                // Disable input
                                answerInput.disabled = true;
                                submitBtn.disabled = true;
                                hintBtn.disabled = true;

                                updateDisplay();

                                // Next round or game over
                                setTimeout(function () {
                                    if (currentRound >= totalRounds) {
                                        endGame();
                                    } else {
                                        currentRound++;
                                        updateDisplay();
                                        startNewRound();
                                    }
                                }, 2000);
                            }

                            function showHint() {
                                if (hintUsed) return;
                                hintUsed = true;
                                hintBtn.disabled = true;

                                // Deduct points
                                score = Math.max(0, score - 50);
                                updateDisplay();

                                // Show hint
                                hintText.textContent = 'Pattern type: ' + getHintText(currentSequence.rule);
                                hintText.classList.add('show');
                            }

                            function getHintText(rule) {
                                if (rule.startsWith('+')) return 'Add ' + rule.substring(1) + ' each time';
                                if (rule.startsWith('\u00d7')) return 'Multiply by ' + rule.substring(1) + ' each time';
                                if (rule === 'n\u00b2') return 'Square numbers (n\u00b2)';
                                if (rule === 'Fib') return 'Each number is the sum of the two before it';
                                return 'Look for a pattern in differences';
                            }

                            function endGame() {
                                // Calculate total time
                                totalGameTime = Math.floor((Date.now() - gameStartTime) / 1000);

                                // Check high score
                                var isNewRecord = MathMemory.storage.setHighScore('sequence', difficulty, score);
                                if (isNewRecord) loadHighScore();

                                // Update stats
                                MathMemory.storage.updateStats('sequence', score, bestStreak);

                                // Show win modal
                                document.getElementById('finalScore').textContent = score;
                                document.getElementById('finalCorrect').textContent = correctCount + '/' + totalRounds;
                                document.getElementById('finalStreak').textContent = bestStreak;
                                document.getElementById('newRecordText').style.display = isNewRecord ? 'block' : 'none';

                                winModal.classList.add('active');

                                if (isNewRecord) {
                                    MathMemory.ui.confetti();
                                }
                            }

                            function shareScore() {
                                MathMemory.share.share('sequence', 'Sequence Solver', score, difficulty, {
                                    time: totalGameTime,
                                    correct: correctCount,
                                    total: totalRounds,
                                    streak: bestStreak
                                });
                                winModal.classList.remove('active');
                            }

                            // Start game
                            init();
                        })();
                    </script>

                    <%@ include file="../components/footer.jsp" %>