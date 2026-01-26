<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="seo-helper.jsp" %>
        <% String pageKey="grid" ; String seoTitle=getSEOTitle(pageKey, application); String
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
                        --glow-green: 0 0 20px rgba(34, 197, 94, 0.5);
                    }

                    .game-page {
                        background: linear-gradient(135deg, var(--arcade-dark) 0%, #0a2e1a 50%, var(--arcade-dark) 100%);
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
                            linear-gradient(rgba(34, 197, 94, 0.03) 1px, transparent 1px),
                            linear-gradient(90deg, rgba(34, 197, 94, 0.03) 1px, transparent 1px);
                        background-size: 50px 50px;
                        pointer-events: none;
                        z-index: 0;
                    }

                    .game-container {
                        position: relative;
                        z-index: 1;
                        max-width: 700px;
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
                        background: linear-gradient(135deg, var(--neon-green), var(--neon-cyan));
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
                        color: var(--neon-green);
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
                        color: var(--neon-green);
                        text-shadow: var(--glow-green);
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
                        border-color: var(--neon-green);
                        color: white;
                    }

                    .diff-btn.active {
                        border-color: var(--neon-green);
                        color: var(--neon-green);
                        box-shadow: var(--glow-green);
                    }

                    /* Grid Container */
                    .grid-container {
                        background: var(--arcade-card);
                        border: 2px solid var(--arcade-border);
                        border-radius: var(--radius-xl);
                        padding: var(--space-6);
                        margin-bottom: var(--space-6);
                        text-align: center;
                    }

                    /* Number Grid */
                    .number-grid {
                        display: grid;
                        gap: var(--space-2);
                        margin: 0 auto var(--space-6);
                        max-width: 400px;
                    }

                    .number-grid.grid-3x3 {
                        grid-template-columns: repeat(3, 1fr);
                    }

                    .number-grid.grid-4x4 {
                        grid-template-columns: repeat(4, 1fr);
                    }

                    .number-grid.grid-5x5 {
                        grid-template-columns: repeat(5, 1fr);
                    }

                    .grid-cell {
                        aspect-ratio: 1;
                        background: linear-gradient(135deg, #0a3a2a, var(--arcade-card));
                        border: 2px solid var(--neon-green);
                        border-radius: var(--radius-lg);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: clamp(1.25rem, 4vw, 2rem);
                        font-weight: 700;
                        color: var(--neon-green);
                        box-shadow: var(--glow-green);
                        transition: all 0.3s;
                    }

                    .grid-cell.obscured {
                        background: linear-gradient(135deg, var(--arcade-card), #251a4a);
                        border-color: var(--arcade-border);
                        color: transparent;
                        box-shadow: none;
                    }

                    .grid-cell.highlight {
                        border-color: var(--neon-cyan);
                        background: linear-gradient(135deg, #0a2a3a, var(--arcade-card));
                        box-shadow: var(--glow-cyan);
                        animation: pulse 0.5s ease;
                    }

                    @keyframes pulse {

                        0%,
                        100% {
                            transform: scale(1);
                        }

                        50% {
                            transform: scale(1.05);
                        }
                    }

                    .grid-cell.correct {
                        border-color: var(--neon-green);
                        background: rgba(34, 197, 94, 0.3);
                    }

                    .grid-cell.wrong {
                        border-color: var(--neon-pink);
                        background: rgba(236, 72, 153, 0.3);
                    }

                    /* Memorize Timer */
                    .memorize-bar {
                        width: 100%;
                        height: 8px;
                        background: var(--arcade-border);
                        border-radius: 4px;
                        overflow: hidden;
                        margin-bottom: var(--space-4);
                    }

                    .memorize-progress {
                        height: 100%;
                        background: linear-gradient(90deg, var(--neon-green), var(--neon-cyan));
                        border-radius: 4px;
                        transition: width 0.1s linear;
                    }

                    /* Phase Display */
                    .phase-display {
                        font-size: var(--text-lg);
                        color: var(--neon-cyan);
                        font-weight: 600;
                        margin-bottom: var(--space-4);
                    }

                    /* Question Area */
                    .question-area {
                        display: none;
                        text-align: center;
                    }

                    .question-area.active {
                        display: block;
                    }

                    .question-text {
                        font-size: var(--text-xl);
                        color: white;
                        margin-bottom: var(--space-4);
                    }

                    .question-text span {
                        color: var(--neon-cyan);
                        font-weight: 700;
                    }

                    /* Answer Options */
                    .answer-options {
                        display: flex;
                        justify-content: center;
                        gap: var(--space-3);
                        flex-wrap: wrap;
                    }

                    .answer-option {
                        padding: var(--space-3) var(--space-6);
                        border: 2px solid var(--arcade-border);
                        border-radius: var(--radius-lg);
                        background: var(--arcade-card);
                        color: white;
                        font-size: var(--text-xl);
                        font-weight: 600;
                        cursor: pointer;
                        transition: all 0.2s;
                        min-width: 80px;
                    }

                    .answer-option:hover {
                        border-color: var(--neon-green);
                        box-shadow: var(--glow-green);
                    }

                    .answer-option.selected {
                        border-color: var(--neon-cyan);
                        background: rgba(34, 211, 238, 0.2);
                    }

                    .answer-option.correct {
                        border-color: var(--neon-green);
                        background: rgba(34, 197, 94, 0.3);
                        color: var(--neon-green);
                    }

                    .answer-option.wrong {
                        border-color: var(--neon-pink);
                        background: rgba(236, 72, 153, 0.3);
                        color: var(--neon-pink);
                    }

                    .answer-option:disabled {
                        cursor: not-allowed;
                        opacity: 0.7;
                    }

                    /* Ready State */
                    .ready-state {
                        text-align: center;
                        padding: var(--space-4);
                    }

                    .ready-text {
                        font-size: var(--text-lg);
                        color: rgba(255, 255, 255, 0.7);
                        margin-bottom: var(--space-4);
                    }

                    .start-btn {
                        padding: var(--space-4) var(--space-8);
                        border: 2px solid var(--neon-green);
                        border-radius: var(--radius-lg);
                        background: var(--neon-green);
                        color: #0a0a0a;
                        font-size: var(--text-xl);
                        font-weight: 700;
                        cursor: pointer;
                        transition: all 0.2s;
                    }

                    .start-btn:hover {
                        box-shadow: var(--glow-green);
                        transform: scale(1.05);
                    }

                    /* Round indicator */
                    .round-indicator {
                        text-align: center;
                        margin-bottom: var(--space-4);
                        font-size: var(--text-sm);
                        color: rgba(255, 255, 255, 0.5);
                    }

                    .round-indicator span {
                        color: var(--neon-green);
                        font-weight: 600;
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

                    /* Feedback */
                    .feedback {
                        margin-top: var(--space-4);
                        padding: var(--space-3) var(--space-6);
                        border-radius: var(--radius-lg);
                        font-size: var(--text-lg);
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
                        flex-wrap: wrap;
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

                        .grid-container {
                            padding: var(--space-4);
                        }

                        .grid-cell {
                            font-size: clamp(1rem, 3vw, 1.5rem);
                        }

                        .answer-option {
                            padding: var(--space-2) var(--space-4);
                            min-width: 60px;
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
                                <span class="game-title-icon">&#127922;</span>
                                <h1>Grid Genius</h1>
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
                                <div class="stat-value" id="levelDisplay">1</div>
                                <div class="stat-label">Level</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value" id="highScore">-</div>
                                <div class="stat-label">Best</div>
                            </div>
                        </div>

                        <!-- Difficulty Selector -->
                        <div class="difficulty-selector">
                            <button class="diff-btn active" data-difficulty="easy">Easy (3x3)</button>
                            <button class="diff-btn" data-difficulty="medium">Medium (4x4)</button>
                            <button class="diff-btn" data-difficulty="hard">Hard (5x5)</button>
                        </div>

                        <!-- Round Indicator -->
                        <div class="round-indicator">
                            Level <span id="currentLevel">1</span> | Questions: <span id="questionsLeft">3</span>
                            remaining
                        </div>

                        <!-- Grid Container -->
                        <div class="grid-container">
                            <!-- Ready State -->
                            <div class="ready-state" id="readyState">
                                <p class="ready-text">Memorize the numbers and their positions!</p>
                                <button class="start-btn" id="startBtn">Start Level</button>
                            </div>

                            <!-- Phase Display -->
                            <div class="phase-display" id="phaseDisplay" style="display:none;"></div>

                            <!-- Memorize Timer -->
                            <div class="memorize-bar" id="memorizeBar" style="display:none;">
                                <div class="memorize-progress" id="memorizeProgress"></div>
                            </div>

                            <!-- Number Grid -->
                            <div class="number-grid grid-3x3" id="numberGrid" style="display:none;"></div>

                            <!-- Question Area -->
                            <div class="question-area" id="questionArea">
                                <p class="question-text" id="questionText"></p>
                                <div class="answer-options" id="answerOptions"></div>
                            </div>

                            <!-- Feedback -->
                            <div class="feedback" id="feedback"></div>
                        </div>

                        <!-- Game Controls -->
                        <div class="game-controls">
                            <button class="game-btn" id="newGameBtn">New Game</button>
                        </div>

                        <!-- Ad: Mobile Leaderboard -->
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
                            <div class="win-icon">&#127922;</div>
                            <h2 class="win-title">Grid Master!</h2>
                            <p class="win-subtitle" id="winSubtitle">Amazing memory skills!</p>
                            <div id="newRecordText" class="new-record" style="display:none;">&#11088; New High Score!
                            </div>
                            <div class="win-stats">
                                <div class="win-stat">
                                    <div class="win-stat-value" id="finalScore">0</div>
                                    <div class="win-stat-label">Score</div>
                                </div>
                                <div class="win-stat">
                                    <div class="win-stat-value" id="finalLevel">0</div>
                                    <div class="win-stat-label">Level</div>
                                </div>
                                <div class="win-stat">
                                    <div class="win-stat-value" id="finalStreak">0</div>
                                    <div class="win-stat-label">Best Streak</div>
                                </div>
                            </div>
                            <div style="display: flex; gap: var(--space-3); justify-content: center;">
                                <button class="game-btn"
                                    style="background: var(--neon-green); border-color: var(--neon-green); color: #0a0a0a;"
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
                                easy: { gridSize: 3, memorizeTime: 5000, questions: 3, basePoints: 100 },
                                medium: { gridSize: 4, memorizeTime: 6000, questions: 4, basePoints: 150 },
                                hard: { gridSize: 5, memorizeTime: 7000, questions: 5, basePoints: 200 }
                            };

                            // Game State
                            var difficulty = 'easy';
                            var level = 1;
                            var score = 0;
                            var streak = 0;
                            var bestStreak = 0;
                            var gridNumbers = [];
                            var questionsRemaining = 0;
                            var memorizeTimer = null;
                            var lives = 3;
                            var gameStartTime = null;
                            var totalGameTime = 0;

                            // DOM Elements
                            var readyState = document.getElementById('readyState');
                            var phaseDisplay = document.getElementById('phaseDisplay');
                            var memorizeBar = document.getElementById('memorizeBar');
                            var memorizeProgress = document.getElementById('memorizeProgress');
                            var numberGrid = document.getElementById('numberGrid');
                            var questionArea = document.getElementById('questionArea');
                            var questionText = document.getElementById('questionText');
                            var answerOptions = document.getElementById('answerOptions');
                            var feedback = document.getElementById('feedback');
                            var winModal = document.getElementById('winModal');
                            var diffButtons = document.querySelectorAll('.diff-btn');

                            // Initialize
                            function init() {
                                loadHighScore();
                                setupDifficultyButtons();
                                setupEventListeners();
                            }

                            function setupDifficultyButtons() {
                                diffButtons.forEach(function (btn) {
                                    btn.addEventListener('click', function () {
                                        diffButtons.forEach(function (b) { b.classList.remove('active'); });
                                        btn.classList.add('active');
                                        difficulty = btn.dataset.difficulty;
                                        updateGridClass();
                                        loadHighScore();
                                        resetGame();
                                    });
                                });
                            }

                            function updateGridClass() {
                                var gridSize = CONFIG[difficulty].gridSize;
                                numberGrid.className = 'number-grid grid-' + gridSize + 'x' + gridSize;
                            }

                            function setupEventListeners() {
                                document.getElementById('startBtn').addEventListener('click', startLevel);
                                document.getElementById('newGameBtn').addEventListener('click', resetGame);
                                document.getElementById('playAgainBtn').addEventListener('click', function () {
                                    winModal.classList.remove('active');
                                    resetGame();
                                });
                                document.getElementById('shareBtn').addEventListener('click', shareScore);
                            }

                            function loadHighScore() {
                                var hs = MathMemory.storage.getHighScore('grid', difficulty);
                                document.getElementById('highScore').textContent = hs > 0 ? hs : '-';
                            }

                            function resetGame() {
                                clearTimers();
                                level = 1;
                                score = 0;
                                streak = 0;
                                bestStreak = 0;
                                lives = 3;
                                gameStartTime = Date.now();
                                totalGameTime = 0;

                                updateDisplay();
                                showReadyState();
                            }

                            function clearTimers() {
                                if (memorizeTimer) clearInterval(memorizeTimer);
                            }

                            function updateDisplay() {
                                document.getElementById('scoreDisplay').textContent = score;
                                document.getElementById('streakDisplay').textContent = streak;
                                document.getElementById('levelDisplay').textContent = level;
                                document.getElementById('currentLevel').textContent = level;
                                document.getElementById('questionsLeft').textContent = questionsRemaining;
                            }

                            function showReadyState() {
                                readyState.style.display = 'block';
                                phaseDisplay.style.display = 'none';
                                memorizeBar.style.display = 'none';
                                numberGrid.style.display = 'none';
                                questionArea.classList.remove('active');
                                feedback.classList.remove('show');
                            }

                            function startLevel() {
                                readyState.style.display = 'none';
                                feedback.classList.remove('show');

                                // Generate grid numbers
                                generateGrid();

                                // Show memorization phase
                                showMemorizationPhase();
                            }

                            function generateGrid() {
                                var gridSize = CONFIG[difficulty].gridSize;
                                var totalCells = gridSize * gridSize;

                                // Generate unique numbers for the grid
                                gridNumbers = [];
                                var usedNumbers = new Set();

                                // Ensure number range is at least as large as cells needed + some buffer
                                var baseMax = 10 + (level * 5);
                                var maxNum = Math.max(baseMax, totalCells + 10);

                                while (gridNumbers.length < totalCells) {
                                    var num = Math.floor(Math.random() * maxNum) + 1;
                                    if (!usedNumbers.has(num)) {
                                        usedNumbers.add(num);
                                        gridNumbers.push(num);
                                    }
                                }
                            }

                            function showMemorizationPhase() {
                                phaseDisplay.style.display = 'block';
                                phaseDisplay.textContent = 'Memorize the numbers!';
                                memorizeBar.style.display = 'block';
                                numberGrid.style.display = 'grid';
                                questionArea.classList.remove('active');

                                // Render grid with numbers visible
                                renderGrid(true);

                                // Start memorization timer
                                var memorizeTime = CONFIG[difficulty].memorizeTime + (level * 500); // More time at higher levels
                                var elapsed = 0;
                                memorizeProgress.style.width = '100%';

                                memorizeTimer = setInterval(function () {
                                    elapsed += 100;
                                    var percent = 100 - (elapsed / memorizeTime * 100);
                                    memorizeProgress.style.width = percent + '%';

                                    if (elapsed >= memorizeTime) {
                                        clearInterval(memorizeTimer);
                                        startQuestionPhase();
                                    }
                                }, 100);
                            }

                            function renderGrid(showNumbers) {
                                var gridSize = CONFIG[difficulty].gridSize;
                                numberGrid.innerHTML = '';

                                for (var i = 0; i < gridNumbers.length; i++) {
                                    var cell = document.createElement('div');
                                    cell.className = 'grid-cell' + (showNumbers ? '' : ' obscured');
                                    cell.textContent = gridNumbers[i];
                                    cell.dataset.index = i;
                                    numberGrid.appendChild(cell);
                                }
                            }

                            function startQuestionPhase() {
                                phaseDisplay.textContent = 'Answer the questions!';
                                memorizeBar.style.display = 'none';

                                // Hide numbers
                                renderGrid(false);

                                questionsRemaining = CONFIG[difficulty].questions;
                                updateDisplay();

                                askQuestion();
                            }

                            function askQuestion() {
                                if (questionsRemaining <= 0) {
                                    levelComplete();
                                    return;
                                }

                                questionArea.classList.add('active');
                                feedback.classList.remove('show');

                                // Generate a question
                                var questionType = Math.random() < 0.5 ? 'position' : 'value';
                                var gridSize = CONFIG[difficulty].gridSize;
                                var randomIndex = Math.floor(Math.random() * gridNumbers.length);
                                var correctAnswer = gridNumbers[randomIndex];

                                var question;
                                var options = [];

                                if (questionType === 'position') {
                                    // What number was at position X?
                                    var row = Math.floor(randomIndex / gridSize) + 1;
                                    var col = (randomIndex % gridSize) + 1;
                                    question = 'What number was at <span>Row ' + row + ', Column ' + col + '</span>?';

                                    // Highlight the cell
                                    var cells = numberGrid.querySelectorAll('.grid-cell');
                                    cells[randomIndex].classList.add('highlight');

                                    // Generate wrong options
                                    options = generateOptions(correctAnswer);
                                } else {
                                    // Where was number X located? (click the cell)
                                    question = 'Click the cell where <span>' + correctAnswer + '</span> was located.';

                                    // For this type, we'll use the grid as options
                                    questionText.innerHTML = question;
                                    answerOptions.innerHTML = '';

                                    var cells = numberGrid.querySelectorAll('.grid-cell');
                                    cells.forEach(function (cell, i) {
                                        cell.style.cursor = 'pointer';
                                        cell.onclick = function () {
                                            handleGridClick(i, randomIndex);
                                        };
                                    });

                                    return;
                                }

                                questionText.innerHTML = question;

                                // Render answer options
                                answerOptions.innerHTML = '';
                                options.forEach(function (opt) {
                                    var btn = document.createElement('button');
                                    btn.className = 'answer-option';
                                    btn.textContent = opt;
                                    btn.onclick = function () { handleAnswer(opt, correctAnswer); };
                                    answerOptions.appendChild(btn);
                                });
                            }

                            function generateOptions(correct) {
                                var options = [correct];
                                while (options.length < 4) {
                                    var offset = Math.floor(Math.random() * 10) - 5;
                                    if (offset === 0) offset = 1;
                                    var wrong = correct + offset;
                                    if (wrong > 0 && options.indexOf(wrong) === -1) {
                                        options.push(wrong);
                                    }
                                }
                                return MathMemory.ui.shuffle(options);
                            }

                            function handleAnswer(selected, correct) {
                                // Disable all options
                                var optionBtns = answerOptions.querySelectorAll('.answer-option');
                                optionBtns.forEach(function (btn) {
                                    btn.disabled = true;
                                    if (parseInt(btn.textContent) === correct) {
                                        btn.classList.add('correct');
                                    } else if (parseInt(btn.textContent) === selected) {
                                        btn.classList.add('wrong');
                                    }
                                });

                                // Remove highlight from grid
                                var cells = numberGrid.querySelectorAll('.grid-cell');
                                cells.forEach(function (c) { c.classList.remove('highlight'); });

                                processAnswer(selected === correct);
                            }

                            function handleGridClick(clickedIndex, correctIndex) {
                                var cells = numberGrid.querySelectorAll('.grid-cell');

                                // Disable further clicks
                                cells.forEach(function (cell) {
                                    cell.style.cursor = 'default';
                                    cell.onclick = null;
                                });

                                // Show result
                                cells[correctIndex].classList.add('correct');
                                cells[correctIndex].classList.remove('obscured');

                                if (clickedIndex !== correctIndex) {
                                    cells[clickedIndex].classList.add('wrong');
                                }

                                processAnswer(clickedIndex === correctIndex);
                            }

                            function processAnswer(isCorrect) {
                                if (isCorrect) {
                                    streak++;
                                    if (streak > bestStreak) bestStreak = streak;

                                    var points = CONFIG[difficulty].basePoints + (level * 20) + (streak * 10);
                                    score += points;

                                    feedback.textContent = 'Correct! +' + points + ' points';
                                    feedback.className = 'feedback show correct';

                                    MathMemory.ui.showToast('Streak: ' + streak + '!', 'success');
                                } else {
                                    streak = 0;
                                    lives--;

                                    feedback.textContent = 'Wrong! Lives remaining: ' + lives;
                                    feedback.className = 'feedback show wrong';

                                    if (lives <= 0) {
                                        setTimeout(gameOver, 1500);
                                        return;
                                    }
                                }

                                questionsRemaining--;
                                updateDisplay();

                                setTimeout(function () {
                                    // Reset grid display
                                    renderGrid(false);
                                    askQuestion();
                                }, 1500);
                            }

                            function levelComplete() {
                                level++;
                                questionsRemaining = CONFIG[difficulty].questions;

                                MathMemory.ui.showToast('Level ' + (level - 1) + ' Complete!', 'success');

                                updateDisplay();

                                // Brief pause then start new level
                                setTimeout(function () {
                                    phaseDisplay.textContent = 'Level ' + level + ' - Get Ready!';
                                    setTimeout(startLevel, 1000);
                                }, 1000);
                            }

                            function gameOver() {
                                // Calculate total time
                                totalGameTime = Math.floor((Date.now() - gameStartTime) / 1000);

                                // Check high score
                                var isNewRecord = MathMemory.storage.setHighScore('grid', difficulty, score);
                                if (isNewRecord) loadHighScore();

                                // Update stats
                                MathMemory.storage.updateStats('grid', score, bestStreak);

                                // Show win modal
                                document.getElementById('finalScore').textContent = score;
                                document.getElementById('finalLevel').textContent = level;
                                document.getElementById('finalStreak').textContent = bestStreak;
                                document.getElementById('newRecordText').style.display = isNewRecord ? 'block' : 'none';
                                document.getElementById('winSubtitle').textContent = 'You reached level ' + level + '!';

                                winModal.classList.add('active');

                                if (isNewRecord) {
                                    MathMemory.ui.confetti();
                                }
                            }

                            function shareScore() {
                                MathMemory.share.share('grid', 'Grid Genius', score, difficulty, {
                                    time: totalGameTime,
                                    level: level,
                                    streak: bestStreak
                                });
                                winModal.classList.remove('active');
                            }

                            // Start game
                            init();
                        })();
                    </script>

                    <%@ include file="../components/footer.jsp" %>