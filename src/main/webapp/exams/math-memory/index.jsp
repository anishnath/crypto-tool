<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="seo-helper.jsp" %>
        <% String pageKey="index" ; String seoTitle=getSEOTitle(pageKey, application); String
            seoDescription=getMetaDescription(pageKey, application); String canonicalUrl=getCanonicalUrl(pageKey,
            application); String extraHead=generateHeadContent(pageKey, application) + generateJsonLd(pageKey, application); request.setAttribute("pageTitle",
            seoTitle); request.setAttribute("pageDescription", seoDescription); request.setAttribute("canonicalUrl",
            canonicalUrl); request.setAttribute("extraHeadContent", extraHead); %>
            <%@ include file="../components/header.jsp" %>

                <!-- Neon Arcade Theme Styles -->
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
                        --glow-pink: 0 0 20px rgba(236, 72, 153, 0.5);
                        --neon-blue: #3b82f6;
                        --neon-indigo: #6366f1;
                        --neon-gold: #fbbf24;
                        --neon-red: #ef4444;
                        --neon-lime: #a3e635;
                        --neon-emerald: #10b981;
                        --neon-teal: #2dd4bf;
                        --neon-sapphire: #3b82f6;
                        --neon-violet: #8b5cf6;
                        --neon-fuchsia: #d946ef;
                        --neon-green: #22c55e;
                        --neon-dark: #052e16;
                        --neon-orange: #f97316;
                        --neon-cyan: #06b6d4;
                        --neon-solar: #f59e0b;
                        --neon-flame: #ef4444;
                        --neon-rose: #f43f5e;
                        --neon-sky: #0ea5e9;
                        --neon-indigo: #6366f1;
                        --neon-purple: #a855f7;
                    }

                    .memory-page {
                        background: linear-gradient(135deg, var(--arcade-dark) 0%, #1a0a2e 50%, var(--arcade-dark) 100%);
                        min-height: 100vh;
                        padding-bottom: var(--space-8);
                    }

                    /* Animated background grid */
                    .memory-page::before {
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

                    .memory-container {
                        position: relative;
                        z-index: 1;
                        max-width: 1200px;
                        margin: 0 auto;
                        padding: 0 var(--space-4);
                    }

                    /* Hero Section */
                    .memory-hero {
                        text-align: center;
                        padding: var(--space-8) 0;
                    }

                    .memory-hero-title {
                        font-size: clamp(2rem, 5vw, 3.5rem);
                        font-weight: 800;
                        background: linear-gradient(135deg, var(--neon-cyan), var(--neon-purple), var(--neon-pink));
                        -webkit-background-clip: text;
                        -webkit-text-fill-color: transparent;
                        background-clip: text;
                        margin-bottom: var(--space-4);
                        text-shadow: var(--glow-purple);
                        letter-spacing: -1px;
                    }

                    .memory-hero-subtitle {
                        font-size: var(--text-lg);
                        color: rgba(255, 255, 255, 0.7);
                        max-width: 600px;
                        margin: 0 auto;
                        line-height: 1.6;
                    }

                    /* Stats Bar */
                    .memory-stats {
                        display: flex;
                        justify-content: center;
                        gap: var(--space-6);
                        margin: var(--space-6) 0;
                        flex-wrap: wrap;
                    }

                    .memory-stat {
                        text-align: center;
                        padding: var(--space-3) var(--space-5);
                        background: var(--arcade-card);
                        border: 1px solid var(--arcade-border);
                        border-radius: var(--radius-lg);
                    }

                    .memory-stat-value {
                        font-size: var(--text-2xl);
                        font-weight: 700;
                        color: var(--neon-cyan);
                        text-shadow: var(--glow-cyan);
                    }

                    .memory-stat-label {
                        font-size: var(--text-sm);
                        color: rgba(255, 255, 255, 0.5);
                        text-transform: uppercase;
                        letter-spacing: 1px;
                    }

                    /* Games Grid */
                    .games-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                        gap: var(--space-5);
                        margin-top: var(--space-6);
                    }

                    /* Game Card */
                    .game-card {
                        background: var(--arcade-card);
                        border: 2px solid var(--arcade-border);
                        border-radius: var(--radius-xl);
                        padding: var(--space-6);
                        text-decoration: none;
                        color: white;
                        position: relative;
                        overflow: hidden;
                        transition: all 0.3s ease;
                        display: flex;
                        flex-direction: column;
                    }

                    .game-card::before {
                        content: '';
                        position: absolute;
                        top: 0;
                        left: 0;
                        right: 0;
                        height: 3px;
                        background: linear-gradient(90deg, var(--card-accent), transparent);
                        opacity: 0;
                        transition: opacity 0.3s ease;
                    }

                    .game-card:hover {
                        transform: translateY(-4px);
                        border-color: var(--card-accent);
                        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3), var(--card-glow);
                    }

                    .game-card:hover::before {
                        opacity: 1;
                    }

                    /* Card accent colors */
                    .game-card[data-game="match"] {
                        --card-accent: var(--neon-purple);
                        --card-glow: var(--glow-purple);
                    }

                    .game-card[data-game="sequence"] {
                        --card-accent: var(--neon-cyan);
                        --card-glow: var(--glow-cyan);
                    }

                    .game-card[data-game="flash"] {
                        --card-accent: var(--neon-pink);
                        --card-glow: var(--glow-pink);
                    }

                    .game-card[data-game="grid"] {
                        --card-accent: var(--neon-green);
                        --card-glow: 0 0 20px rgba(34, 197, 94, 0.5);
                    }

                    .game-card[data-game="speed"] {
                        --card-accent: var(--neon-orange);
                        --card-glow: 0 0 20px rgba(249, 115, 22, 0.5);
                    }

                    .game-card[data-game="hidden-order"] {
                        --card-accent: var(--neon-blue);
                        --card-glow: 0 0 20px rgba(59, 130, 246, 0.5);
                    }

                    .game-card[data-game="recall"] {
                        --card-accent: var(--neon-pink);
                        --card-glow: var(--glow-pink);
                    }

                    .game-card[data-game="mental-trail"] {
                        --card-accent: var(--neon-gold);
                        --card-glow: 0 0 20px rgba(251, 191, 36, 0.5);
                    }

                    .game-card[data-game="equation-echo"] {
                        --card-accent: var(--neon-lime);
                        --card-glow: 0 0 20px rgba(163, 230, 53, 0.5);
                    }

                    .game-card[data-game="symbol-sums"] {
                        --card-accent: var(--neon-teal);
                        --card-glow: 0 0 20px rgba(45, 212, 191, 0.5);
                    }

                    .game-card[data-game="matrix-memory"] {
                        --card-accent: var(--neon-violet);
                        --card-glow: 0 0 20px rgba(139, 92, 246, 0.5);
                    }

                    .game-card[data-game="binary-blitz"] {
                        --card-accent: var(--neon-green);
                        --card-glow: 0 0 20px rgba(34, 197, 94, 0.5);
                    }

                    .game-card[data-game="color-code"] {
                        --card-accent: var(--neon-cyan);
                        --card-glow: 0 0 20px rgba(6, 182, 212, 0.5);
                    }

                    .game-card[data-game="spin-logic"] {
                        --card-accent: var(--neon-solar);
                        --card-glow: 0 0 20px rgba(245, 158, 11, 0.5);
                    }

                    .game-card[data-game="path-finder"] {
                        --card-accent: var(--neon-rose);
                        --card-glow: 0 0 20px rgba(244, 63, 94, 0.5);
                    }

                    .game-card[data-game="shape-count"] {
                        --card-accent: var(--neon-indigo);
                        --card-glow: 0 0 20px rgba(99, 102, 241, 0.5);
                    }

                    .game-card-icon {
                        width: 64px;
                        height: 64px;
                        border-radius: var(--radius-lg);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 2rem;
                        margin-bottom: var(--space-4);
                        background: linear-gradient(135deg, var(--card-accent), transparent);
                        border: 1px solid var(--card-accent);
                        box-shadow: var(--card-glow);
                    }

                    .game-card-title {
                        font-size: var(--text-xl);
                        font-weight: 700;
                        color: white;
                        margin-bottom: var(--space-2);
                    }

                    .game-card-desc {
                        font-size: var(--text-sm);
                        color: rgba(255, 255, 255, 0.6);
                        line-height: 1.6;
                        flex: 1;
                    }

                    .game-card-meta {
                        display: flex;
                        align-items: center;
                        gap: var(--space-3);
                        margin-top: var(--space-4);
                        padding-top: var(--space-4);
                        border-top: 1px solid var(--arcade-border);
                    }

                    .game-card-difficulty {
                        font-size: var(--text-xs);
                        padding: 4px 10px;
                        border-radius: 20px;
                        font-weight: 600;
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                    }

                    .difficulty-easy {
                        background: rgba(34, 197, 94, 0.2);
                        color: var(--neon-green);
                        border: 1px solid var(--neon-green);
                    }

                    .difficulty-medium {
                        background: rgba(250, 204, 21, 0.2);
                        color: var(--neon-yellow);
                        border: 1px solid var(--neon-yellow);
                    }

                    .difficulty-hard {
                        background: rgba(249, 115, 22, 0.2);
                        color: var(--neon-orange);
                        border: 1px solid var(--neon-orange);
                    }

                    .difficulty-expert {
                        background: rgba(236, 72, 153, 0.2);
                        color: var(--neon-pink);
                        border: 1px solid var(--neon-pink);
                    }

                    .game-card-play {
                        margin-left: auto;
                        display: flex;
                        align-items: center;
                        gap: var(--space-2);
                        font-size: var(--text-sm);
                        font-weight: 600;
                        color: var(--card-accent);
                    }

                    .game-card-play svg {
                        transition: transform 0.2s ease;
                    }

                    .game-card:hover .game-card-play svg {
                        transform: translateX(4px);
                    }

                    /* Coming Soon Badge */
                    .coming-soon-badge {
                        position: absolute;
                        top: var(--space-4);
                        right: var(--space-4);
                        background: rgba(255, 255, 255, 0.1);
                        color: rgba(255, 255, 255, 0.5);
                        font-size: var(--text-xs);
                        padding: 4px 10px;
                        border-radius: 20px;
                        font-weight: 600;
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                    }

                    .game-card.coming-soon {
                        opacity: 0.6;
                        pointer-events: none;
                    }

                    /* How It Works Section */
                    .how-it-works {
                        margin-top: var(--space-10);
                        padding: var(--space-8);
                        background: var(--arcade-card);
                        border: 1px solid var(--arcade-border);
                        border-radius: var(--radius-xl);
                    }

                    .section-title {
                        font-size: var(--text-2xl);
                        font-weight: 700;
                        color: white;
                        text-align: center;
                        margin-bottom: var(--space-6);
                    }

                    .benefits-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                        gap: var(--space-4);
                    }

                    .benefit-item {
                        text-align: center;
                        padding: var(--space-4);
                    }

                    .benefit-icon {
                        font-size: 2.5rem;
                        margin-bottom: var(--space-3);
                    }

                    .benefit-title {
                        font-size: var(--text-base);
                        font-weight: 600;
                        color: white;
                        margin-bottom: var(--space-2);
                    }

                    .benefit-desc {
                        font-size: var(--text-sm);
                        color: rgba(255, 255, 255, 0.5);
                    }

                    /* Responsive */
                    @media (max-width: 640px) {
                        .memory-hero {
                            padding: var(--space-6) 0;
                        }

                        .games-grid {
                            grid-template-columns: 1fr;
                        }

                        .game-card {
                            padding: var(--space-5);
                        }

                        .game-card-icon {
                            width: 56px;
                            height: 56px;
                            font-size: 1.5rem;
                        }

                        .memory-stats {
                            gap: var(--space-3);
                        }

                        .memory-stat {
                            padding: var(--space-2) var(--space-4);
                        }
                    }

                    /* Layout with Sidebar */
                    .memory-layout {
                        display: grid;
                        grid-template-columns: 1fr;
                        gap: var(--space-6);
                    }

                    .memory-sidebar {
                        display: none;
                    }

                    @media (min-width: 1200px) {
                        .memory-layout {
                            grid-template-columns: 1fr 300px;
                        }

                        .memory-sidebar {
                            display: block;
                            position: sticky;
                            top: 80px;
                            height: fit-content;
                        }
                    }

                    /* Ad Container */
                    .ad-container-centered {
                        display: flex;
                        justify-content: center;
                        margin: var(--space-6) 0;
                    }

                    /* Override dark theme for this page */
                    .memory-page,
                    .memory-page .exam-footer {
                        background: transparent;
                    }

                    .memory-page .exam-footer {
                        border-top: 1px solid var(--arcade-border);
                        margin-top: var(--space-8);
                    }

                    /* Ad slot styling for dark theme */
                    .memory-page .ad-slot {
                        background: var(--arcade-card);
                        border: 1px solid var(--arcade-border);
                        border-radius: var(--radius-lg);
                    }
                </style>

                <div class="memory-page">
                    <div class="memory-container">
                        <!-- Hero Section -->
                        <section class="memory-hero">
                            <h1 class="memory-hero-title">Math Memory Games</h1>
                            <p class="memory-hero-subtitle">
                                Train your brain with number puzzles. Boost mental calculation,
                                pattern recognition, and recall speed.
                            </p>

                            <div class="memory-stats">
                                <div class="memory-stat">
                                    <div class="memory-stat-value">16</div>
                                    <div class="memory-stat-label">Game Modes</div>
                                </div>
                                <div class="memory-stat">
                                    <div class="memory-stat-value">3</div>
                                    <div class="memory-stat-label">Difficulty Levels</div>
                                </div>
                                <div class="memory-stat">
                                    <div class="memory-stat-value">100%</div>
                                    <div class="memory-stat-label">Free</div>
                                </div>
                            </div>
                        </section>

                        <!-- Ad: Leaderboard -->
                        <div class="ad-container-centered">
                            <%@ include file="../components/ad-leaderboard.jsp" %>
                        </div>

                        <!-- Breadcrumb -->
                        <nav class="breadcrumb" aria-label="Breadcrumb" style="margin-bottom: var(--space-4);">
                            <a href="<%=request.getContextPath()%>/exams/"
                                style="color: rgba(255,255,255,0.6);">Exams</a>
                            <span class="breadcrumb-separator" style="color: rgba(255,255,255,0.3);">/</span>
                            <span style="color: var(--neon-cyan);">Math Memory</span>
                        </nav>

                        <!-- Main Layout with Sidebar -->
                        <div class="memory-layout">
                            <div class="memory-main">
                                <!-- Games Grid -->
                                <div class="games-grid">
                                    <!-- Match Master -->
                                    <a href="<%=request.getContextPath()%>/exams/math-memory/match.jsp"
                                        class="game-card" data-game="match">
                                        <div class="game-card-icon">&#127183;</div>
                                        <h2 class="game-card-title">Match Master</h2>
                                        <p class="game-card-desc">
                                            Classic memory card game with a math twist. Match problems to their
                                            answers. Test your recall and calculation skills.
                                        </p>
                                        <div class="game-card-meta">
                                            <span class="game-card-difficulty difficulty-easy">Easy → Hard</span>
                                            <span class="game-card-play">
                                                Play
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M5 12h14M12 5l7 7-7 7" />
                                                </svg>
                                            </span>
                                        </div>
                                    </a>

                                    <!-- Sequence Solver -->
                                    <a href="<%=request.getContextPath()%>/exams/math-memory/sequence.jsp"
                                        class="game-card" data-game="sequence">
                                        <div class="game-card-icon">&#128290;</div>
                                        <h2 class="game-card-title">Sequence Solver</h2>
                                        <p class="game-card-desc">
                                            Remember number patterns and continue the sequence.
                                            Trains pattern recognition and working memory.
                                        </p>
                                        <div class="game-card-meta">
                                            <span class="game-card-difficulty difficulty-medium">Medium</span>
                                            <span class="game-card-play">
                                                Play
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M5 12h14M12 5l7 7-7 7" />
                                                </svg>
                                            </span>
                                        </div>
                                    </a>

                                    <!-- Flash Math -->
                                    <a href="<%=request.getContextPath()%>/exams/math-memory/flash.jsp"
                                        class="game-card" data-game="flash">
                                        <div class="game-card-icon">&#9889;</div>
                                        <h2 class="game-card-title">Flash Math</h2>
                                        <p class="game-card-desc">
                                            See the problem, it vanishes, type the answer.
                                            Builds mental calculation speed under pressure.
                                        </p>
                                        <div class="game-card-meta">
                                            <span class="game-card-difficulty difficulty-medium">Medium</span>
                                            <span class="game-card-play">
                                                Play
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M5 12h14M12 5l7 7-7 7" />
                                                </svg>
                                            </span>
                                        </div>
                                    </a>

                                    <!-- Grid Genius -->
                                    <a href="<%=request.getContextPath()%>/exams/math-memory/grid.jsp" class="game-card"
                                        data-game="grid">
                                        <div class="game-card-icon">&#127922;</div>
                                        <h2 class="game-card-title">Grid Genius</h2>
                                        <p class="game-card-desc">
                                            Memorize number positions in a grid, then answer questions.
                                            Ultimate spatial memory challenge.
                                        </p>
                                        <div class="game-card-meta">
                                            <span class="game-card-difficulty difficulty-hard">Hard</span>
                                            <span class="game-card-play">
                                                Play
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M5 12h14M12 5l7 7-7 7" />
                                                </svg>
                                            </span>
                                        </div>
                                    </a>

                                    <!-- Speed Round -->
                                    <a href="<%=request.getContextPath()%>/exams/math-memory/speed-round.jsp"
                                        class="game-card" data-game="speed">
                                        <div class="game-card-icon">&#128293;</div>
                                        <h2 class="game-card-title">Speed Round</h2>
                                        <p class="game-card-desc">
                                            Solve multiple problems, then recall specific answers.
                                            Tests attention and recall under time pressure.
                                        </p>
                                        <div class="game-card-meta">
                                            <span class="game-card-difficulty difficulty-expert">Expert</span>
                                            <span class="game-card-play">
                                                Play
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M5 12h14M12 5l7 7-7 7" />
                                                </svg>
                                            </span>
                                        </div>
                                    </a>

                                    <!-- Hidden Order -->
                                    <a href="<%=request.getContextPath()%>/exams/math-memory/hidden-order.jsp"
                                        class="game-card" data-game="hidden-order">
                                        <div class="game-card-icon">&#128302;</div>
                                        <h2 class="game-card-title">Hidden Order</h2>
                                        <p class="game-card-desc">
                                            Memorize the position of numbers as they vanish.
                                            Click them in ascending order. Classic working memory test.
                                        </p>
                                        <div class="game-card-meta">
                                            <span class="game-card-difficulty difficulty-hard">Hard</span>
                                            <span class="game-card-play">
                                                Play
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M5 12h14M12 5l7 7-7 7" />
                                                </svg>
                                            </span>
                                        </div>
                                    </a>

                                    <!-- Rapid Recall -->
                                    <a href="<%=request.getContextPath()%>/exams/math-memory/recall.jsp"
                                        class="game-card" data-game="recall">
                                        <div class="game-card-icon">&#129505;</div>
                                        <h2 class="game-card-title">Rapid Recall</h2>
                                        <p class="game-card-desc">
                                            Study a set of numbers, then answer specific questions.
                                            Tests detailed memory and processing.
                                        </p>
                                        <div class="game-card-meta">
                                            <span class="game-card-difficulty difficulty-medium">Medium</span>
                                            <span class="game-card-play">
                                                Play
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M5 12h14M12 5l7 7-7 7" />
                                                </svg>
                                            </span>
                                        </div>
                                    </a>

                                    <!-- Mental Trail -->
                                    <a href="<%=request.getContextPath()%>/exams/math-memory/mental-trail.jsp"
                                        class="game-card" data-game="mental-trail">
                                        <div class="game-card-icon">&#129699;</div>
                                        <h2 class="game-card-title">Mental Trail</h2>
                                        <p class="game-card-desc">
                                            Follow a stream of math operations starting from a number.
                                            Hold the running total in your head.
                                        </p>
                                        <div class="game-card-meta">
                                            <span class="game-card-difficulty difficulty-hard">Hard</span>
                                            <span class="game-card-play">
                                                Play
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M5 12h14M12 5l7 7-7 7" />
                                                </svg>
                                            </span>
                                        </div>
                                    </a>

                                    <!-- Equation Echo -->
                                    <a href="<%=request.getContextPath()%>/exams/math-memory/equation-echo.jsp"
                                        class="game-card" data-game="equation-echo">
                                        <div class="game-card-icon">&#8747;</div>
                                        <h2 class="game-card-title">Equation Echo</h2>
                                        <p class="game-card-desc">
                                            Restore missing numbers or operators from equations.
                                            chunk complex math information.
                                        </p>
                                        <div class="game-card-meta">
                                            <span class="game-card-difficulty difficulty-medium">Medium</span>
                                            <span class="game-card-play">
                                                Play
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M5 12h14M12 5l7 7-7 7" />
                                                </svg>
                                            </span>
                                        </div>
                                    </a>

                                    <!-- Symbol Sums -->
                                    <a href="<%=request.getContextPath()%>/exams/math-memory/symbol-sums.jsp"
                                        class="game-card" data-game="symbol-sums">
                                        <div class="game-card-icon">&#128302;</div>
                                        <h2 class="game-card-title">Symbol Sums</h2>
                                        <p class="game-card-desc">
                                            Decipher symbols by remembering their assigned values.
                                            Tests associative memory and math.
                                        </p>
                                        <div class="game-card-meta">
                                            <span class="game-card-difficulty difficulty-hard">Hard</span>
                                            <span class="game-card-play">
                                                Play
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M5 12h14M12 5l7 7-7 7" />
                                                </svg>
                                            </span>
                                        </div>
                                    </a>

                                    <!-- Matrix Memory -->
                                    <a href="<%=request.getContextPath()%>/exams/math-memory/matrix-memory.jsp"
                                        class="game-card" data-game="matrix-memory">
                                        <div class="game-card-icon">&#128160;</div>
                                        <h2 class="game-card-title">Matrix Memory</h2>
                                        <p class="game-card-desc">
                                            Scan the grid and memorize locations of numbers matching the rule (e.g.
                                            Primes).
                                            Selective attention speed test.
                                        </p>
                                        <div class="game-card-meta">
                                            <span class="game-card-difficulty difficulty-hard">Hard</span>
                                            <span class="game-card-play">
                                                Play
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M5 12h14M12 5l7 7-7 7" />
                                                </svg>
                                            </span>
                                        </div>
                                    </a>

                                    <!-- Binary Blitz -->
                                    <a href="<%=request.getContextPath()%>/exams/math-memory/binary-blitz.jsp"
                                        class="game-card" data-game="binary-blitz">
                                        <div class="game-card-icon">&#10100;</div>
                                        <h2 class="game-card-title">Binary Blitz</h2>
                                        <p class="game-card-desc">
                                            Memorize and reconstruct patterns of bits (0s and 1s).
                                            Hack the mainframe with your memory.
                                        </p>
                                        <div class="game-card-meta">
                                            <span class="game-card-difficulty difficulty-medium">Medium</span>
                                            <span class="game-card-play">
                                                Play
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M5 12h14M12 5l7 7-7 7" />
                                                </svg>
                                            </span>
                                        </div>
                                    </a>

                                    <!-- Color Code -->
                                    <a href="<%=request.getContextPath()%>/exams/math-memory/color-code.jsp"
                                        class="game-card" data-game="color-code">
                                        <div class="game-card-icon">&#127912;</div>
                                        <h2 class="game-card-title">Color Code</h2>
                                        <p class="game-card-desc">
                                            Synesthetic memory challenge. Memorize color-number pairs
                                            and decode the sequence.
                                        </p>
                                        <div class="game-card-meta">
                                            <span class="game-card-difficulty difficulty-medium">Medium</span>
                                            <span class="game-card-play">
                                                Play
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M5 12h14M12 5l7 7-7 7" />
                                                </svg>
                                            </span>
                                        </div>
                                    </a>

                                    <!-- Spin Logic -->
                                    <a href="<%=request.getContextPath()%>/exams/math-memory/spin-logic.jsp"
                                        class="game-card" data-game="spin-logic">
                                        <div class="game-card-icon">&#9881;</div>
                                        <h2 class="game-card-title">Spin Logic</h2>
                                        <p class="game-card-desc">
                                            Mentally rotate a number grid and recall positions.
                                            Tests spatial visualization skills.
                                        </p>
                                        <div class="game-card-meta">
                                            <span class="game-card-difficulty difficulty-hard">Hard</span>
                                            <span class="game-card-play">
                                                Play
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M5 12h14M12 5l7 7-7 7" />
                                                </svg>
                                            </span>
                                        </div>
                                    </a>

                                    <!-- Path Finder -->
                                    <a href="<%=request.getContextPath()%>/exams/math-memory/path-finder.jsp"
                                        class="game-card" data-game="path-finder">
                                        <div class="game-card-icon">&#10547;</div>
                                        <h2 class="game-card-title">Path Finder</h2>
                                        <p class="game-card-desc">
                                            Follow a lighting path across the grid and calculate the total sum
                                            of the numbers.
                                        </p>
                                        <div class="game-card-meta">
                                            <span class="game-card-difficulty difficulty-medium">Medium</span>
                                            <span class="game-card-play">
                                                Play
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M5 12h14M12 5l7 7-7 7" />
                                                </svg>
                                            </span>
                                        </div>
                                    </a>

                                    <!-- Shape Count -->
                                    <a href="<%=request.getContextPath()%>/exams/math-memory/shape-count.jsp"
                                        class="game-card" data-game="shape-count">
                                        <div class="game-card-icon">&#9650;</div>
                                        <h2 class="game-card-title">Shape Count</h2>
                                        <p class="game-card-desc">
                                            Filter visual chaos. Sum the numbers inside specific shapes
                                            (e.g. Triangles) only.
                                        </p>
                                        <div class="game-card-meta">
                                            <span class="game-card-difficulty difficulty-hard">Hard</span>
                                            <span class="game-card-play">
                                                Play
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M5 12h14M12 5l7 7-7 7" />
                                                </svg>
                                            </span>
                                        </div>
                                    </a>
                                </div>
                            </div><!-- /memory-main -->

                            <!-- Sidebar with Ads (Desktop) -->
                            <aside class="memory-sidebar">
                                <%@ include file="../components/ad-sidebar.jsp" %>
                            </aside>
                        </div><!-- /memory-layout -->

                        <!-- How It Works -->
                        <section class="how-it-works">
                            <h2 class="section-title">Why Train Your Math Memory?</h2>
                            <div class="benefits-grid">
                                <div class="benefit-item">
                                    <div class="benefit-icon">&#129504;</div>
                                    <h3 class="benefit-title">Boost Brain Power</h3>
                                    <p class="benefit-desc">Strengthen neural pathways for faster mental math</p>
                                </div>
                                <div class="benefit-item">
                                    <div class="benefit-icon">&#9889;</div>
                                    <h3 class="benefit-title">Speed Up Recall</h3>
                                    <p class="benefit-desc">Train your brain to retrieve answers instantly</p>
                                </div>
                                <div class="benefit-item">
                                    <div class="benefit-icon">&#127919;</div>
                                    <h3 class="benefit-title">Improve Focus</h3>
                                    <p class="benefit-desc">Build concentration and attention span</p>
                                </div>
                                <div class="benefit-item">
                                    <div class="benefit-icon">&#128200;</div>
                                    <h3 class="benefit-title">Track Progress</h3>
                                    <p class="benefit-desc">See your scores improve over time</p>
                                </div>
                            </div>
                        </section>

                        <!-- Ad: Footer Leaderboard -->
                        <div class="ad-container-centered" style="margin-top: var(--space-8);">
                            <%@ include file="../components/ad-leaderboard.jsp" %>
                        </div>

                    </div>
                </div>

                <!-- JSON-LD Structured Data -->
                <script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "WebPage",
    "name": "Math Memory Games - Brain Training",
    "description": "Free math memory games to boost mental calculation and recall. Match problems, memorize sequences, grid challenges.",
    "url": "https://8gwifi.org/exams/math-memory/",
    "isPartOf": {
        "@type": "WebSite",
        "name": "8gwifi.org",
        "url": "https://8gwifi.org"
    }
}
</script>

                <script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "ItemList",
    "name": "Math Memory Games",
    "numberOfItems": 16,
    "itemListElement": [
        {"@type": "ListItem", "position": 1, "name": "Match Master", "url": "https://8gwifi.org/exams/math-memory/match.jsp"},
        {"@type": "ListItem", "position": 2, "name": "Sequence Solver", "url": "https://8gwifi.org/exams/math-memory/sequence.jsp"},
        {"@type": "ListItem", "position": 3, "name": "Flash Math", "url": "https://8gwifi.org/exams/math-memory/flash.jsp"},
        {"@type": "ListItem", "position": 4, "name": "Grid Genius", "url": "https://8gwifi.org/exams/math-memory/grid.jsp"},
        {"@type": "ListItem", "position": 5, "name": "Speed Round", "url": "https://8gwifi.org/exams/math-memory/speed-round.jsp"},
        {"@type": "ListItem", "position": 6, "name": "Hidden Order", "url": "https://8gwifi.org/exams/math-memory/hidden-order.jsp"},
        {"@type": "ListItem", "position": 7, "name": "Rapid Recall", "url": "https://8gwifi.org/exams/math-memory/recall.jsp"},
        {"@type": "ListItem", "position": 8, "name": "Mental Trail", "url": "https://8gwifi.org/exams/math-memory/mental-trail.jsp"},
        {"@type": "ListItem", "position": 9, "name": "Equation Echo", "url": "https://8gwifi.org/exams/math-memory/equation-echo.jsp"},
        {"@type": "ListItem", "position": 10, "name": "Symbol Sums", "url": "https://8gwifi.org/exams/math-memory/symbol-sums.jsp"},
        {"@type": "ListItem", "position": 11, "name": "Matrix Memory", "url": "https://8gwifi.org/exams/math-memory/matrix-memory.jsp"},
        {"@type": "ListItem", "position": 12, "name": "Binary Blitz", "url": "https://8gwifi.org/exams/math-memory/binary-blitz.jsp"},
        {"@type": "ListItem", "position": 13, "name": "Color Code", "url": "https://8gwifi.org/exams/math-memory/color-code.jsp"},
        {"@type": "ListItem", "position": 14, "name": "Spin Logic", "url": "https://8gwifi.org/exams/math-memory/spin-logic.jsp"},
        {"@type": "ListItem", "position": 15, "name": "Path Finder", "url": "https://8gwifi.org/exams/math-memory/path-finder.jsp"},
        {"@type": "ListItem", "position": 16, "name": "Shape Count", "url": "https://8gwifi.org/exams/math-memory/shape-count.jsp"}
    ]
}
</script>

                <%@ include file="../components/footer.jsp" %>