<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="seo-helper.jsp" %>
        <% String pageKey="speed-round" ; String seoTitle=getSEOTitle(pageKey, application); String
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
                        --neon-orange: #f97316;
                        --arcade-dark: #0f0a1e;
                        --arcade-card: #1a1333;
                        --arcade-border: #2d2255;
                        --glow-purple: 0 0 20px rgba(168, 85, 247, 0.5);
                        --glow-cyan: 0 0 20px rgba(34, 211, 238, 0.5);
                        --glow-orange: 0 0 20px rgba(249, 115, 22, 0.5);
                    }

                    .game-page {
                        background: linear-gradient(135deg, var(--arcade-dark) 0%, #2e1a0a 50%, var(--arcade-dark) 100%);
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
                            linear-gradient(rgba(249, 115, 22, 0.03) 1px, transparent 1px),
                            linear-gradient(90deg, rgba(249, 115, 22, 0.03) 1px, transparent 1px);
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
                        background: linear-gradient(135deg, var(--neon-orange), var(--neon-yellow));
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
                        color: var(--neon-orange);
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
                        color: var(--neon-orange);
                        text-shadow: var(--glow-orange);
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
                        box-shadow: var(--glow-orange);
                    }

                    /* Main Container */
                    .speed-container {
                        background: var(--arcade-card);
                        border: 2px solid var(--arcade-border);
                        border-radius: var(--radius-xl);
                        padding: var(--space-6);
                        margin-bottom: var(--space-6);
                        text-align: center;
                        min-height: 350px;
                    }

                    /* Phase Indicator */
                    .phase-indicator {
                        display: flex;
                        justify-content: center;
                        gap: var(--space-4);
                        margin-bottom: var(--space-6);
                    }

                    .phase-badge {
                        padding: var(--space-2) var(--space-4);
                        border-radius: 20px;
                        font-size: var(--text-sm);
                        font-weight: 600;
                        text-transform: uppercase;
                        letter-spacing: 1px;
                        opacity: 0.4;
                        transition: all 0.3s;
                    }

                    .phase-badge.active {
                        opacity: 1;
                    }

                    .phase-solve {
                        background: rgba(249, 115, 22, 0.2);
                        color: var(--neon-orange);
                        border: 1px solid var(--neon-orange);
                    }

                    .phase-recall {
                        background: rgba(34, 211, 238, 0.2);
                        color: var(--neon-cyan);
                        border: 1px solid var(--neon-cyan);
                    }

                    /* Ready State */
                    .ready-state {
                        text-align: center;
                        padding: var(--space-4);
                    }

                    .ready-text {
                        font-size: var(--text-lg);
                        color: rgba(255, 255, 255, 0.7);
                        margin-bottom: var(--space-2);
                    }

                    .ready-description {
                        font-size: var(--text-sm);
                        color: rgba(255, 255, 255, 0.5);
                        margin-bottom: var(--space-6);
                        max-width: 400px;
                        margin-left: auto;
                        margin-right: auto;
                    }

                    .start-btn {
                        padding: var(--space-4) var(--space-8);
                        border: 2px solid var(--neon-orange);
                        border-radius: var(--radius-lg);
                        background: var(--neon-orange);
                        color: #0a0a0a;
                        font-size: var(--text-xl);
                        font-weight: 700;
                        cursor: pointer;
                        transition: all 0.2s;
                    }

                    .start-btn:hover {
                        box-shadow: var(--glow-orange);
                        transform: scale(1.05);
                    }

                    /* Problem Display */
                    .problem-display {
                        display: none;
                    }

                    .problem-display.active {
                        display: block;
                    }

                    .problem-number {
                        font-size: var(--text-sm);
                        color: rgba(255, 255, 255, 0.5);
                        margin-bottom: var(--space-3);
                    }

                    .problem-text {
                        font-size: clamp(2.5rem, 8vw, 4rem);
                        font-weight: 800;
                        color: var(--neon-orange);
                        text-shadow: var(--glow-orange);
                        margin-bottom: var(--space-6);
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
                        border: 3px solid var(--arcade-border);
                        border-radius: var(--radius-lg);
                        padding: var(--space-3);
                        font-size: var(--text-2xl);
                        font-weight: 700;
                        color: white;
                        text-align: center;
                        width: 150px;
                        transition: all 0.2s;
                    }

                    .answer-input:focus {
                        outline: none;
                        border-color: var(--neon-orange);
                        box-shadow: var(--glow-orange);
                    }

                    .answer-input.correct {
                        border-color: var(--neon-green);
                        box-shadow: 0 0 20px rgba(34, 197, 94, 0.5);
                    }

                    .answer-input.wrong {
                        border-color: var(--neon-pink);
                        animation: shake 0.4s ease;
                    }

                    @keyframes shake {

                        0%,
                        100% {
                            transform: translateX(0);
                        }

                        25% {
                            transform: translateX(-10px);
                        }

                        75% {
                            transform: translateX(10px);
                        }
                    }

                    .submit-btn {
                        padding: var(--space-3) var(--space-6);
                        border: 2px solid var(--neon-orange);
                        border-radius: var(--radius-lg);
                        background: var(--neon-orange);
                        color: #0a0a0a;
                        font-size: var(--text-lg);
                        font-weight: 600;
                        cursor: pointer;
                        transition: all 0.2s;
                    }

                    .submit-btn:hover {
                        box-shadow: var(--glow-orange);
                    }

                    .submit-btn:disabled {
                        opacity: 0.5;
                        cursor: not-allowed;
                    }

                    /* Timer Bar */
                    .timer-bar-container {
                        width: 100%;
                        height: 8px;
                        background: var(--arcade-border);
                        border-radius: 4px;
                        overflow: hidden;
                        margin-top: var(--space-4);
                    }

                    .timer-bar {
                        height: 100%;
                        background: linear-gradient(90deg, var(--neon-orange), var(--neon-yellow));
                        border-radius: 4px;
                        transition: width 0.1s linear;
                    }

                    /* Recall Phase */
                    .recall-display {
                        display: none;
                    }

                    .recall-display.active {
                        display: block;
                    }

                    .recall-question {
                        font-size: var(--text-xl);
                        color: white;
                        margin-bottom: var(--space-6);
                    }

                    .recall-question span {
                        color: var(--neon-cyan);
                        font-weight: 700;
                    }

                    /* Problems History */
                    .problems-history {
                        display: flex;
                        flex-wrap: wrap;
                        justify-content: center;
                        gap: var(--space-3);
                        margin-bottom: var(--space-6);
                    }

                    .history-item {
                        background: rgba(255, 255, 255, 0.05);
                        border: 1px solid var(--arcade-border);
                        border-radius: var(--radius-md);
                        padding: var(--space-2) var(--space-3);
                        font-size: var(--text-sm);
                    }

                    .history-item.highlight {
                        border-color: var(--neon-cyan);
                        background: rgba(34, 211, 238, 0.1);
                        color: var(--neon-cyan);
                    }

                    /* Answer Options */
                    .recall-options {
                        display: flex;
                        justify-content: center;
                        gap: var(--space-3);
                        flex-wrap: wrap;
                    }

                    .recall-option {
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

                    .recall-option:hover {
                        border-color: var(--neon-cyan);
                        box-shadow: var(--glow-cyan);
                    }

                    .recall-option.correct {
                        border-color: var(--neon-green);
                        background: rgba(34, 197, 94, 0.3);
                        color: var(--neon-green);
                    }

                    .recall-option.wrong {
                        border-color: var(--neon-pink);
                        background: rgba(236, 72, 153, 0.3);
                        color: var(--neon-pink);
                    }

                    .recall-option:disabled {
                        cursor: not-allowed;
                        opacity: 0.7;
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

                    /* Round indicator */
                    .round-indicator {
                        text-align: center;
                        margin-bottom: var(--space-4);
                        font-size: var(--text-sm);
                        color: rgba(255, 255, 255, 0.5);
                    }

                    .round-indicator span {
                        color: var(--neon-orange);
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

                        .speed-container {
                            padding: var(--space-4);
                        }

                        .answer-input {
                            width: 120px;
                        }

                        .recall-option {
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
                                <span class="game-title-icon">&#128293;</span>
                                <h1>Speed Round</h1>
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
                                <div class="stat-value" id="roundDisplay">1</div>
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

                        <!-- Difficulty Selector -->
                        <div class="difficulty-selector">
                            <button class="diff-btn active" data-difficulty="easy">Easy</button>
                            <button class="diff-btn" data-difficulty="medium">Medium</button>
                            <button class="diff-btn" data-difficulty="hard">Hard</button>
                        </div>

                        <!-- Round Indicator -->
                        <div class="round-indicator">
                            Round <span id="currentRound">1</span> of <span id="totalRounds">5</span>
                        </div>

                        <!-- Main Container -->
                        <div class="speed-container">
                            <!-- Phase Indicator -->
                            <div class="phase-indicator">
                                <span class="phase-badge phase-solve" id="solveBadge">Solve</span>
                                <span class="phase-badge phase-recall" id="recallBadge">Recall</span>
                            </div>

                            <!-- Ready State -->
                            <div class="ready-state" id="readyState">
                                <p class="ready-text">Solve problems fast, then recall your answers!</p>
                                <p class="ready-description">
                                    First, solve a series of math problems quickly.
                                    Then, we'll ask you what answers you gave - test your memory!
                                </p>
                                <button class="start-btn" id="startBtn">Start Round</button>
                            </div>

                            <!-- Problem Display (Solve Phase) -->
                            <div class="problem-display" id="problemDisplay">
                                <div class="problem-number">Problem <span id="problemNum">1</span> of <span
                                        id="totalProblems">5</span></div>
                                <div class="problem-text" id="problemText"></div>
                                <div class="input-area">
                                    <input type="number" class="answer-input" id="answerInput" placeholder="?"
                                        autocomplete="off">
                                    <button class="submit-btn" id="submitBtn">Submit</button>
                                </div>
                                <div class="timer-bar-container">
                                    <div class="timer-bar" id="timerBar"></div>
                                </div>
                            </div>

                            <!-- Recall Display -->
                            <div class="recall-display" id="recallDisplay">
                                <div class="problems-history" id="problemsHistory"></div>
                                <p class="recall-question" id="recallQuestion"></p>
                                <div class="recall-options" id="recallOptions"></div>
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
                            <div class="win-icon">&#128293;</div>
                            <h2 class="win-title">Speed Demon!</h2>
                            <p class="win-subtitle">You completed all rounds!</p>
                            <div id="newRecordText" class="new-record" style="display:none;">&#11088; New High Score!
                            </div>
                            <div class="win-stats">
                                <div class="win-stat">
                                    <div class="win-stat-value" id="finalScore">0</div>
                                    <div class="win-stat-label">Score</div>
                                </div>
                                <div class="win-stat">
                                    <div class="win-stat-value" id="finalSolved">0</div>
                                    <div class="win-stat-label">Solved</div>
                                </div>
                                <div class="win-stat">
                                    <div class="win-stat-value" id="finalRecalled">0</div>
                                    <div class="win-stat-label">Recalled</div>
                                </div>
                            </div>
                            <div style="display: flex; gap: var(--space-3); justify-content: center;">
                                <button class="game-btn"
                                    style="background: var(--neon-orange); border-color: var(--neon-orange); color: #0a0a0a;"
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
                                easy: { problems: 4, recallQuestions: 2, solveTime: 10000, rounds: 5, basePoints: 100, types: ['addition', 'subtraction'] },
                                medium: { problems: 5, recallQuestions: 3, solveTime: 8000, rounds: 5, basePoints: 150, types: ['addition', 'subtraction', 'multiplication'] },
                                hard: { problems: 6, recallQuestions: 4, solveTime: 6000, rounds: 5, basePoints: 200, types: ['addition', 'subtraction', 'multiplication', 'division'] }
                            };

                            // Game State
                            var difficulty = 'easy';
                            var currentRound = 1;
                            var totalRounds = 5;
                            var score = 0;
                            var streak = 0;
                            var bestStreak = 0;
                            var solvedCount = 0;
                            var recalledCount = 0;

                            var problems = [];
                            var userAnswers = [];
                            var currentProblemIndex = 0;
                            var recallQuestionsAsked = 0;
                            var timerInterval = null;
                            var gameStartTime = null;
                            var totalGameTime = 0;

                            // DOM Elements
                            var readyState = document.getElementById('readyState');
                            var problemDisplay = document.getElementById('problemDisplay');
                            var recallDisplay = document.getElementById('recallDisplay');
                            var solveBadge = document.getElementById('solveBadge');
                            var recallBadge = document.getElementById('recallBadge');
                            var answerInput = document.getElementById('answerInput');
                            var submitBtn = document.getElementById('submitBtn');
                            var timerBar = document.getElementById('timerBar');
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
                                        loadHighScore();
                                        resetGame();
                                    });
                                });
                            }

                            function setupEventListeners() {
                                document.getElementById('startBtn').addEventListener('click', startRound);
                                submitBtn.addEventListener('click', submitAnswer);
                                answerInput.addEventListener('keypress', function (e) {
                                    if (e.key === 'Enter') submitAnswer();
                                });
                                document.getElementById('newGameBtn').addEventListener('click', resetGame);
                                document.getElementById('playAgainBtn').addEventListener('click', function () {
                                    winModal.classList.remove('active');
                                    resetGame();
                                });
                                document.getElementById('shareBtn').addEventListener('click', shareScore);
                            }

                            function loadHighScore() {
                                var hs = MathMemory.storage.getHighScore('speed', difficulty);
                                document.getElementById('highScore').textContent = hs > 0 ? hs : '-';
                            }

                            function resetGame() {
                                clearTimers();
                                currentRound = 1;
                                score = 0;
                                streak = 0;
                                bestStreak = 0;
                                solvedCount = 0;
                                recalledCount = 0;
                                totalRounds = CONFIG[difficulty].rounds;
                                gameStartTime = Date.now();
                                totalGameTime = 0;

                                updateDisplay();
                                showReadyState();
                            }

                            function clearTimers() {
                                if (timerInterval) clearInterval(timerInterval);
                            }

                            function updateDisplay() {
                                document.getElementById('scoreDisplay').textContent = score;
                                document.getElementById('roundDisplay').textContent = currentRound;
                                document.getElementById('streakDisplay').textContent = streak;
                                document.getElementById('currentRound').textContent = currentRound;
                                document.getElementById('totalRounds').textContent = totalRounds;
                            }

                            function showReadyState() {
                                readyState.style.display = 'block';
                                problemDisplay.classList.remove('active');
                                recallDisplay.classList.remove('active');
                                solveBadge.classList.remove('active');
                                recallBadge.classList.remove('active');
                                feedback.classList.remove('show');
                            }

                            function startRound() {
                                readyState.style.display = 'none';
                                feedback.classList.remove('show');

                                // Generate problems for this round
                                problems = [];
                                userAnswers = [];
                                currentProblemIndex = 0;
                                recallQuestionsAsked = 0;

                                var types = CONFIG[difficulty].types;
                                var numProblems = CONFIG[difficulty].problems;

                                for (var i = 0; i < numProblems; i++) {
                                    problems.push(MathMemory.problems.getRandom(difficulty, types));
                                }

                                // Start solve phase
                                startSolvePhase();
                            }

                            function startSolvePhase() {
                                solveBadge.classList.add('active');
                                recallBadge.classList.remove('active');
                                problemDisplay.classList.add('active');
                                recallDisplay.classList.remove('active');

                                document.getElementById('totalProblems').textContent = problems.length;
                                showProblem();
                            }

                            function showProblem() {
                                if (currentProblemIndex >= problems.length) {
                                    startRecallPhase();
                                    return;
                                }

                                var problem = problems[currentProblemIndex];
                                document.getElementById('problemNum').textContent = currentProblemIndex + 1;
                                document.getElementById('problemText').textContent = problem.text;

                                answerInput.value = '';
                                answerInput.classList.remove('correct', 'wrong');
                                answerInput.disabled = false;
                                submitBtn.disabled = false;
                                answerInput.focus();

                                // Start timer
                                var solveTime = CONFIG[difficulty].solveTime;
                                var elapsed = 0;
                                timerBar.style.width = '100%';

                                clearTimers();
                                timerInterval = setInterval(function () {
                                    elapsed += 100;
                                    var percent = 100 - (elapsed / solveTime * 100);
                                    timerBar.style.width = percent + '%';

                                    if (elapsed >= solveTime) {
                                        handleTimeout();
                                    }
                                }, 100);
                            }

                            function submitAnswer() {
                                clearTimers();

                                var userAnswer = parseInt(answerInput.value);
                                if (isNaN(userAnswer)) {
                                    answerInput.classList.add('wrong');
                                    setTimeout(function () { answerInput.classList.remove('wrong'); }, 400);
                                    return;
                                }

                                answerInput.disabled = true;
                                submitBtn.disabled = true;

                                var problem = problems[currentProblemIndex];
                                var isCorrect = userAnswer === problem.answer;

                                userAnswers.push({
                                    problem: problem.text,
                                    correctAnswer: problem.answer,
                                    userAnswer: userAnswer,
                                    correct: isCorrect
                                });

                                if (isCorrect) {
                                    answerInput.classList.add('correct');
                                    solvedCount++;
                                    streak++;
                                    if (streak > bestStreak) bestStreak = streak;
                                    score += CONFIG[difficulty].basePoints + (streak * 10);
                                } else {
                                    answerInput.classList.add('wrong');
                                    streak = 0;
                                }

                                updateDisplay();

                                currentProblemIndex++;
                                setTimeout(showProblem, 500);
                            }

                            function handleTimeout() {
                                clearTimers();

                                var problem = problems[currentProblemIndex];
                                userAnswers.push({
                                    problem: problem.text,
                                    correctAnswer: problem.answer,
                                    userAnswer: null,
                                    correct: false
                                });

                                streak = 0;
                                updateDisplay();

                                answerInput.disabled = true;
                                submitBtn.disabled = true;

                                currentProblemIndex++;
                                setTimeout(showProblem, 500);
                            }

                            function startRecallPhase() {
                                solveBadge.classList.remove('active');
                                recallBadge.classList.add('active');
                                problemDisplay.classList.remove('active');
                                recallDisplay.classList.add('active');

                                // Show problems history
                                renderProblemsHistory();

                                // Ask recall questions
                                askRecallQuestion();
                            }

                            function renderProblemsHistory() {
                                var historyEl = document.getElementById('problemsHistory');
                                historyEl.innerHTML = '';

                                userAnswers.forEach(function (item, i) {
                                    var div = document.createElement('div');
                                    div.className = 'history-item';
                                    div.id = 'history-' + i;
                                    div.textContent = '#' + (i + 1) + ': ' + item.problem;
                                    historyEl.appendChild(div);
                                });
                            }

                            function askRecallQuestion() {
                                var numQuestions = CONFIG[difficulty].recallQuestions;

                                if (recallQuestionsAsked >= numQuestions) {
                                    roundComplete();
                                    return;
                                }

                                feedback.classList.remove('show');

                                // Pick a random problem to ask about
                                var randomIndex = Math.floor(Math.random() * userAnswers.length);
                                var item = userAnswers[randomIndex];

                                // Highlight the problem
                                var historyItems = document.querySelectorAll('.history-item');
                                historyItems.forEach(function (el) { el.classList.remove('highlight'); });
                                document.getElementById('history-' + randomIndex).classList.add('highlight');

                                // Ask what answer they gave
                                document.getElementById('recallQuestion').innerHTML =
                                    'What answer did you give for <span>' + item.problem + '</span>?';

                                // Generate options (their answer + some wrong ones)
                                var options = [];
                                if (item.userAnswer !== null) {
                                    options.push(item.userAnswer);
                                }
                                options.push(item.correctAnswer);

                                // Add some distractors
                                while (options.length < 4) {
                                    var distractor = item.correctAnswer + Math.floor(Math.random() * 20) - 10;
                                    if (distractor > 0 && options.indexOf(distractor) === -1) {
                                        options.push(distractor);
                                    }
                                }

                                options = MathMemory.ui.shuffle(options);

                                // Render options
                                var optionsEl = document.getElementById('recallOptions');
                                optionsEl.innerHTML = '';

                                options.forEach(function (opt) {
                                    var btn = document.createElement('button');
                                    btn.className = 'recall-option';
                                    btn.textContent = opt;
                                    btn.onclick = function () {
                                        handleRecallAnswer(opt, item.userAnswer, randomIndex);
                                    };
                                    optionsEl.appendChild(btn);
                                });
                            }

                            function handleRecallAnswer(selected, actualUserAnswer, problemIndex) {
                                // Disable all options
                                var optionBtns = document.querySelectorAll('.recall-option');
                                optionBtns.forEach(function (btn) {
                                    btn.disabled = true;
                                    var val = parseInt(btn.textContent);
                                    if (val === actualUserAnswer) {
                                        btn.classList.add('correct');
                                    } else if (val === selected && selected !== actualUserAnswer) {
                                        btn.classList.add('wrong');
                                    }
                                });

                                var isCorrect = selected === actualUserAnswer;

                                if (isCorrect) {
                                    recalledCount++;
                                    streak++;
                                    if (streak > bestStreak) bestStreak = streak;
                                    var points = CONFIG[difficulty].basePoints + (streak * 15);
                                    score += points;

                                    feedback.textContent = 'Correct! You remembered your answer! +' + points;
                                    feedback.className = 'feedback show correct';
                                } else {
                                    streak = 0;

                                    var msg = actualUserAnswer !== null ?
                                        'Wrong! You actually answered ' + actualUserAnswer :
                                        'Wrong! You didn\'t answer this one (timeout)';
                                    feedback.textContent = msg;
                                    feedback.className = 'feedback show wrong';
                                }

                                updateDisplay();

                                recallQuestionsAsked++;
                                setTimeout(askRecallQuestion, 2000);
                            }

                            function roundComplete() {
                                MathMemory.ui.showToast('Round ' + currentRound + ' Complete!', 'success');

                                if (currentRound >= totalRounds) {
                                    setTimeout(endGame, 1000);
                                } else {
                                    currentRound++;
                                    updateDisplay();
                                    setTimeout(showReadyState, 1500);
                                }
                            }

                            function endGame() {
                                // Calculate total time
                                totalGameTime = Math.floor((Date.now() - gameStartTime) / 1000);

                                // Check high score
                                var isNewRecord = MathMemory.storage.setHighScore('speed', difficulty, score);
                                if (isNewRecord) loadHighScore();

                                // Update stats
                                MathMemory.storage.updateStats('speed', score, bestStreak);

                                // Show win modal
                                document.getElementById('finalScore').textContent = score;
                                document.getElementById('finalSolved').textContent = solvedCount;
                                document.getElementById('finalRecalled').textContent = recalledCount;
                                document.getElementById('newRecordText').style.display = isNewRecord ? 'block' : 'none';

                                winModal.classList.add('active');

                                if (isNewRecord) {
                                    MathMemory.ui.confetti();
                                }
                            }

                            function shareScore() {
                                MathMemory.share.share('speed-round', 'Speed Round', score, difficulty, {
                                    time: totalGameTime,
                                    solved: solvedCount,
                                    recalled: recalledCount,
                                    rounds: totalRounds
                                });
                                winModal.classList.remove('active');
                            }

                            // Start game
                            init();
                        })();
                    </script>

                    <%@ include file="../components/footer.jsp" %>