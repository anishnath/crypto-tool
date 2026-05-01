<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <%--
        24 Game Solver — math-studio shell migration.

        Pure-JS combinatorial search at /js/24-game-solver.js.  No
        MathLive (inputs are integer card values), no AI, no SymPy —
        exhaustive enumeration of expression trees + arithmetic eval.
        All ~700ish lines of compute JS preserved as an external file;
        only the JSP shell changed here.

        Element IDs preserved verbatim so the external JS keeps working:
          game-num1..4, game-target, game-solve-btn, game-random-btn,
          game-hard-btn, game-clear-btn, game-result-content,
          game-empty-state, game-result-actions, game-copy-btn,
          game-share-btn, game-print-btn, plus all .game-chip[data-nums]
    --%>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow,max-image-preview:large,max-snippet:-1">
    <meta name="googlebot" content="index,follow">
    <meta name="author" content="Anish Nath">
    <meta name="context-path" content="<%=request.getContextPath()%>">

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="24 Game Solver with Steps | Free Make 24 Calculator" />
        <jsp:param name="toolDescription" value="Free 24 game solver that finds all solutions instantly. Enter 4 numbers and see every way to make 24 using +, -, x, / with step-by-step breakdowns." />
        <jsp:param name="toolCategory" value="Math" />
        <jsp:param name="toolUrl" value="24-game-solver.jsp" />
        <jsp:param name="toolKeywords" value="24 game solver, 24 game calculator, make 24, 24 card game, 24 puzzle solver, 24 math game, how to make 24 with 4 numbers, 24 game answers, 24 solver online, make 24 with four numbers, 24 point game, math 24 game, 24 game solutions, 24 game strategy, four numbers make 24" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Find all solutions to make 24,Step-by-step solution breakdowns,Random solvable puzzle generator,Hard puzzle challenge mode,Custom target number support,Difficulty rating per puzzle" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What is the 24 game and how do you play it?" />
        <jsp:param name="faq1a" value="The 24 Game is a mathematical card game where players use four numbers and basic arithmetic operations (addition, subtraction, multiplication, division) to make exactly 24. Each number must be used exactly once. Players can use parentheses to change the order of operations. It was invented by Robert Sun in 1988 and is widely used in schools to develop mental math skills." />
        <jsp:param name="faq2q" value="How do you solve 24 with 4 numbers?" />
        <jsp:param name="faq2a" value="To solve the 24 game: first look for factor pairs of 24 (like 3 times 8, 4 times 6, 2 times 12). Try to form one factor from two numbers and the other from the remaining two. If that fails, try chains of operations. Common strategies include making 8 times 3, 6 times 4, or 24 times 1 from your four numbers." />
        <jsp:param name="faq3q" value="Can every set of 4 numbers make 24?" />
        <jsp:param name="faq3a" value="No, not every combination of 4 numbers can make 24. For example, 1,1,1,1 has no solution. With numbers 1 through 9, about 80 percent of four-number combinations are solvable. The hardest commonly cited puzzle is 3,3,8,8 which requires the clever solution 8 divided by (3 minus 8 divided by 3) equals 24." />
        <jsp:param name="faq4q" value="What are the hardest 24 game puzzles?" />
        <jsp:param name="faq4a" value="The hardest 24 game puzzles typically have only one solution and require division or complex nesting. Famous hard puzzles include 3,3,8,8 and 1,5,5,5. These require non-obvious division steps that most players miss. Our solver rates puzzle difficulty based on the number of possible solutions." />
        <jsp:param name="faq5q" value="Is the 24 game good for learning math?" />
        <jsp:param name="faq5a" value="Yes, the 24 game is excellent for developing mental math skills, number sense, and arithmetic fluency. It teaches order of operations, creative problem-solving, and strategic thinking. Many teachers use it as a classroom warm-up activity. Studies show it improves calculation speed and mathematical confidence in students of all ages." />
        <jsp:param name="faq6q" value="What numbers from 1 to 9 are impossible to make 24?" />
        <jsp:param name="faq6a" value="Some four-number combinations from 1 to 9 cannot make 24, such as 1,1,1,1 and 1,1,1,2. With the standard card deck values 1 through 13, about 458 of the 715 possible combinations are solvable. Our solver instantly tells you whether your numbers can make 24 and shows all possible solutions." />
    </jsp:include>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap"></noscript>

    <!-- Shared site CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">

    <!-- Math shell -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css?v=<%=cacheVersion%>">

    <style>
    /* ── 24-game specific styles (preserved from legacy page) ── */
    .game-num-grid { display: grid; grid-template-columns: 1fr 1fr 1fr 1fr; gap: 0.5rem; }
    .game-num-input {
        width: 100%; padding: 0.7rem 0.4rem;
        border: 1.5px solid var(--ms-border, #e2e8f0);
        border-radius: 0.5rem;
        font-size: 1.4rem; font-weight: 700; text-align: center;
        font-family: var(--font-mono);
        background: var(--ms-surface, #fff);
        color: var(--ms-ink, #0f172a);
        transition: border-color 0.15s, box-shadow 0.15s;
    }
    .game-num-input:focus {
        outline: none; border-color: #f59e0b;
        box-shadow: 0 0 0 3px rgba(245,158,11,0.15);
    }
    [data-theme="dark"] .game-num-input {
        background: rgba(255,255,255,0.05);
        border-color: rgba(255,255,255,0.15);
        color: var(--ms-ink, #e2e8f0);
    }
    .game-target-row { display: flex; align-items: center; gap: 0.6rem; }
    .game-target-input {
        width: 80px; padding: 0.55rem 0.5rem;
        border: 1.5px solid var(--ms-border, #e2e8f0);
        border-radius: 0.5rem;
        font-size: 1rem; font-weight: 700; text-align: center;
        font-family: var(--font-mono);
        background: var(--ms-surface, #fff);
        color: var(--ms-ink, #0f172a);
    }
    .game-target-input:focus { outline: none; border-color: #f59e0b; box-shadow: 0 0 0 3px rgba(245,158,11,0.15); }
    [data-theme="dark"] .game-target-input { background: rgba(255,255,255,0.05); border-color: rgba(255,255,255,0.15); color: var(--ms-ink, #e2e8f0); }

    /* Action buttons — primary + 3 secondaries side-by-side */
    .game-primary-btn {
        width: 100%; padding: 0.75rem; font-weight: 600; font-size: 0.95rem;
        border: none; border-radius: 0.5rem; cursor: pointer;
        background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
        color: #fff; transition: opacity .15s;
    }
    .game-primary-btn:hover { opacity: 0.92; }
    .game-btn-row { display: flex; gap: 0.5rem; margin-top: 0.5rem; }
    .game-btn-row > button {
        flex: 1; padding: 0.6rem 0.4rem; font-weight: 600; font-size: 0.78rem;
        border: none; border-radius: 0.5rem; cursor: pointer; color: #fff;
        transition: opacity .15s;
    }
    .game-btn-row > button:hover { opacity: 0.9; }
    .game-btn-green { background: linear-gradient(135deg, #10b981 0%, #059669 100%); }
    .game-btn-rose  { background: linear-gradient(135deg, #f43f5e 0%, #e11d48 100%); }
    .game-btn-clear {
        background: var(--ms-surface-2, #f8fafc) !important;
        color: var(--ms-muted, #475569) !important;
        border: 1px solid var(--ms-border, #e2e8f0) !important;
    }
    .game-btn-clear:hover { background: var(--ms-surface-3, #f1f5f9) !important; }
    [data-theme="dark"] .game-btn-clear {
        background: rgba(255,255,255,0.05) !important;
        color: var(--ms-ink, #e2e8f0) !important;
        border-color: rgba(255,255,255,0.15) !important;
    }

    /* Sample-puzzle chips */
    .game-chip {
        padding: 0.32rem 0.7rem; font-size: 0.72rem;
        font-family: var(--font-mono);
        background: var(--ms-surface-2, #f8fafc);
        border: 1px solid var(--ms-border, #e2e8f0);
        border-radius: 9999px; cursor: pointer; transition: all 0.15s;
        color: var(--ms-ink, #0f172a); white-space: nowrap;
    }
    .game-chip:hover {
        background: linear-gradient(135deg, #f59e0b, #d97706);
        border-color: #f59e0b; color: #fff;
    }
    [data-theme="dark"] .game-chip {
        background: rgba(255,255,255,0.05);
        border-color: rgba(255,255,255,0.15);
        color: var(--ms-ink, #e2e8f0);
    }

    /* Empty-state card animation (kept — pedagogically charming) */
    .game-empty-anim {
        display: flex; align-items: center; justify-content: center;
        gap: 6px; margin: 0 auto 1.25rem; height: 70px;
    }
    .game-card-anim {
        width: 42px; height: 56px;
        background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
        border-radius: 6px;
        display: flex; align-items: center; justify-content: center;
        color: #fff; font-weight: 700; font-size: 1.1rem;
        box-shadow: 0 4px 12px rgba(245,158,11,0.25);
        animation: game-float 2.5s ease-in-out infinite;
    }
    .game-card-anim:nth-child(3) { animation-delay: 0.3s; }
    .game-card-anim:nth-child(5) { animation-delay: 0.6s; }
    .game-card-anim:nth-child(7) { animation-delay: 0.9s; }
    .game-op-anim { font-size: 1rem; font-weight: 700; color: #b45309; animation: game-pulse 2s ease-in-out infinite; }
    .game-op-anim:nth-child(4) { animation-delay: 0.3s; }
    .game-op-anim:nth-child(6) { animation-delay: 0.6s; }
    .game-eq-anim { font-size: 1.25rem; font-weight: 800; color: #10b981; margin-left: 4px; animation: game-pulse 2s ease-in-out infinite 1s; }
    @keyframes game-float { 0%,100% { transform: translateY(0); } 50% { transform: translateY(-8px); } }
    @keyframes game-pulse { 0%,100% { opacity: 0.5; transform: scale(1); } 50% { opacity: 1; transform: scale(1.15); } }

    /* Result panel content */
    .game-stats { display: grid; grid-template-columns: repeat(3, 1fr); gap: 0.5rem; margin-bottom: 1rem; }
    .game-stat {
        background: var(--ms-surface-2, #f8fafc);
        border: 1px solid var(--ms-border, #e2e8f0);
        border-radius: 0.5rem; padding: 0.625rem; text-align: center;
    }
    .game-stat-val { display: block; font-size: 1rem; font-weight: 700; color: #b45309; font-family: var(--font-mono); }
    .game-stat-lbl { font-size: 0.625rem; color: var(--ms-muted, #94a3b8); text-transform: uppercase; letter-spacing: 0.04em; font-weight: 600; }
    .game-diff-impossible { color: var(--ms-muted, #94a3b8); }
    .game-diff-expert { color: #ef4444; }
    .game-diff-hard   { color: #f59e0b; }
    .game-diff-medium { color: #3b82f6; }
    .game-diff-easy   { color: #10b981; }
    [data-theme="dark"] .game-stat { background: rgba(255,255,255,0.05); border-color: rgba(255,255,255,0.15); }
    [data-theme="dark"] .game-stat-val { color: #fbbf24; }

    .game-no-solution {
        background: #fee2e2; color: #991b1b;
        border-left: 4px solid #ef4444;
        padding: 1rem; border-radius: 0 0.5rem 0.5rem 0;
        font-weight: 600; font-size: 0.875rem;
    }
    [data-theme="dark"] .game-no-solution { background: rgba(239,68,68,0.15); color: #fca5a5; }
    .game-warn {
        background: #fef3c7; color: #92400e;
        border-left: 4px solid #f59e0b;
        padding: 0.75rem; border-radius: 0 0.5rem 0.5rem 0;
        font-weight: 600; font-size: 0.875rem;
    }
    [data-theme="dark"] .game-warn { background: rgba(245,158,11,0.15); color: #fcd34d; }
    .game-solution {
        display: flex; gap: 0.75rem; padding: 0.75rem;
        background: var(--ms-surface-2, #f8fafc);
        border: 1px solid var(--ms-border, #e2e8f0);
        border-radius: 0.5rem; margin-bottom: 0.5rem;
        align-items: flex-start;
    }
    .game-solution-num {
        flex-shrink: 0; width: 26px; height: 26px;
        background: linear-gradient(135deg, #f59e0b, #d97706);
        color: #fff; border-radius: 50%;
        display: flex; align-items: center; justify-content: center;
        font-size: 0.6875rem; font-weight: 700; margin-top: 0.125rem;
    }
    .game-solution-body { flex: 1; min-width: 0; }
    .game-solution-expr {
        font-family: var(--font-mono); font-size: 0.95rem;
        font-weight: 700; color: #b45309; word-break: break-word;
    }
    [data-theme="dark"] .game-solution { background: rgba(255,255,255,0.05); border-color: rgba(255,255,255,0.15); }
    [data-theme="dark"] .game-solution-expr { color: #fbbf24; }
    .game-solution-steps { margin-top: 0.5rem; display: flex; flex-direction: column; gap: 0.25rem; }
    .game-step {
        display: flex; align-items: center; gap: 0.5rem;
        font-size: 0.75rem; font-family: var(--font-mono);
        color: var(--ms-muted, #475569);
        padding: 0.25rem 0.5rem;
        background: var(--ms-surface, #fff);
        border-radius: 0.375rem;
    }
    .game-step-badge {
        flex-shrink: 0; width: 18px; height: 18px;
        background: var(--ms-surface-3, #f1f5f9);
        border-radius: 50%; display: flex; align-items: center; justify-content: center;
        font-size: 0.5625rem; font-weight: 700; color: var(--ms-muted, #94a3b8);
    }
    [data-theme="dark"] .game-step { background: rgba(255,255,255,0.03); }
    .game-show-more {
        display: block; width: 100%; padding: 0.625rem;
        border: 1px dashed var(--ms-border, #e2e8f0);
        border-radius: 0.5rem; background: none; color: #b45309;
        font-weight: 600; font-size: 0.8125rem; cursor: pointer;
        font-family: var(--font-sans); transition: all 0.15s;
        margin-top: 0.5rem;
    }
    .game-show-more:hover { background: rgba(245,158,11,0.08); border-color: #f59e0b; }
    [data-theme="dark"] .game-show-more { color: #fbbf24; }

    /* Print mode */
    @media print { body * { visibility: hidden !important; } #printArea, #printArea * { visibility: visible !important; } #printArea { position: absolute; top: 0; left: 0; width: 100%; } }
    .print-grid { border-collapse: collapse; margin: 1rem auto; }
    .print-grid td { border: 2px solid #000; width: 50px; height: 50px; text-align: center; font-size: 1.2rem; font-weight: 600; }
    .print-title { text-align: center; font-size: 1.5rem; font-weight: 700; margin-bottom: 0.5rem; }
    .print-info { text-align: center; color: #666; margin-bottom: 1rem; }
    .print-exercise { margin-top: 1.5rem; padding: 1rem; border: 1px solid #ccc; border-radius: 8px; }
    .print-exercise-blank { display: inline-block; width: 40px; border-bottom: 1px solid #000; margin: 0 4px; }
    .print-footer { text-align: center; color: #999; font-size: 0.8rem; margin-top: 2rem; }

    /* Show actions only after first solve */
    .tool-result-actions { display: none; }
    .tool-result-actions.visible { display: flex; gap: 0.5rem; padding: 1rem 1.25rem; border-top: 1px solid var(--ms-border, #e2e8f0); flex-wrap: wrap; }
    .tool-result-actions .tool-action-btn { flex: 1; min-width: 90px; }

    .game-form-group { margin-bottom: 0.85rem; }
    .game-form-group > label { display: block; font-weight: 500; font-size: 0.8125rem; margin-bottom: 0.4rem; color: var(--ms-ink, #0f172a); }
    [data-theme="dark"] .game-form-group > label { color: var(--ms-ink, #f1f5f9); }
    .game-form-hint { font-size: 0.7rem; color: var(--ms-muted, #94a3b8); margin-top: 0.25rem; }

    /* Edu cards */
    .game-edu-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; margin-top: 1rem; }
    .game-edu-card {
        background: var(--ms-surface-2, #f8fafc);
        border: 1px solid var(--ms-border, #e2e8f0);
        border-radius: 0.5rem; padding: 1.25rem;
    }
    .game-edu-card h4 { font-size: 0.875rem; font-weight: 700; color: var(--ms-ink, #0f172a); margin-bottom: 0.375rem; }
    .game-edu-card p  { font-size: 0.8125rem; color: var(--ms-muted, #475569); line-height: 1.6; margin: 0; }
    [data-theme="dark"] .game-edu-card { background: rgba(255,255,255,0.05); border-color: rgba(255,255,255,0.15); }
    [data-theme="dark"] .game-edu-card h4 { color: var(--ms-ink, #f1f5f9); }
    </style>

    <%@ include file="modern/ads/ad-init.jsp" %>
</head>
<body class="ms-body">

    <%@ include file="modern/components/nav-header.jsp" %>

    <jsp:include page="/math/partials/matter-bg.jsp" />

    <div class="ms-hero">
        <%@ include file="modern/ads/ad-hero-banner.jsp" %>
    </div>

    <main class="ms-main">

        <button type="button" id="msSidebarToggle" class="ms-sidebar-toggle" aria-label="Open math tools menu">
            &#9776; Math tools
        </button>

        <% request.setAttribute("activeService", "24-game"); %>
        <jsp:include page="/math/partials/sidebar.jsp" />

        <section class="ms-workspace">

            <header class="ms-title">
                <nav class="ms-crumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                    <span>/</span>
                    <a href="<%=request.getContextPath()%>/math/">Math</a>
                    <span>/</span>
                    <span aria-current="page">24 Game Solver</span>
                </nav>
                <h1>24 Game Solver &mdash; Find All Ways to Make 24</h1>
            </header>

            <div class="ic-stack">

                <!-- ═══ INPUT HERO ═══ -->
                <div class="ic-hero">
                    <div class="game-form-group">
                        <label for="game-num1">Enter 4 numbers</label>
                        <div class="game-num-grid">
                            <input type="number" class="game-num-input" id="game-num1" value="3" min="1" max="99" placeholder="1" autocomplete="off">
                            <input type="number" class="game-num-input" id="game-num2" value="3" min="1" max="99" placeholder="2" autocomplete="off">
                            <input type="number" class="game-num-input" id="game-num3" value="8" min="1" max="99" placeholder="3" autocomplete="off">
                            <input type="number" class="game-num-input" id="game-num4" value="8" min="1" max="99" placeholder="4" autocomplete="off">
                        </div>
                        <div class="game-form-hint">Standard deck: 1 (Ace) through 13 (King). Any positive integer up to 99 works.</div>
                    </div>

                    <div class="game-form-group">
                        <div class="game-target-row">
                            <label for="game-target" style="margin:0;">Target:</label>
                            <input type="number" class="game-target-input" id="game-target" value="24" min="1" max="999">
                            <span class="game-form-hint" style="margin:0;">(default 24)</span>
                        </div>
                    </div>

                    <button type="button" class="game-primary-btn" id="game-solve-btn">Find solutions</button>
                    <div class="game-btn-row">
                        <button type="button" class="game-btn-green" id="game-random-btn">&#127922; Random</button>
                        <button type="button" class="game-btn-rose"  id="game-hard-btn">&#128293; Hard puzzle</button>
                        <button type="button" class="game-btn-clear" id="game-clear-btn">&#128465; Clear</button>
                    </div>

                    <!-- Headline sample puzzles -->
                    <div class="ic-method-row" style="margin:0.7rem 0 0.25rem;">
                        <span class="ic-method-label">Try one</span>
                        <button type="button" class="game-chip" data-nums="3,3,8,8">3,3,8,8</button>
                        <button type="button" class="game-chip" data-nums="1,2,3,4">1,2,3,4</button>
                        <button type="button" class="game-chip" data-nums="1,5,5,5">1,5,5,5</button>
                        <button type="button" class="game-chip" data-nums="6,6,6,6">6,6,6,6</button>
                        <button type="button" class="game-chip" data-nums="10,10,4,4">10,10,4,4</button>
                    </div>
                    <details class="ic-hero-methods">
                        <summary class="ic-hero-methods-summary"><span>More puzzles</span><svg class="ic-hero-methods-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></summary>
                        <div class="ic-hero-methods-body" style="display:flex;flex-wrap:wrap;gap:0.4rem;">
                            <button type="button" class="game-chip" data-nums="3,3,8,8">Classic 3,3,8,8 (only 1 solution)</button>
                            <button type="button" class="game-chip" data-nums="1,2,3,4">Easy 1,2,3,4</button>
                            <button type="button" class="game-chip" data-nums="1,5,5,5">Tricky 1,5,5,5</button>
                            <button type="button" class="game-chip" data-nums="10,10,4,4">Face cards 10,10,4,4</button>
                            <button type="button" class="game-chip" data-nums="6,6,6,6">All sixes</button>
                            <button type="button" class="game-chip" data-nums="2,2,2,2">All twos</button>
                            <button type="button" class="game-chip" data-nums="7,7,7,7">All sevens</button>
                            <button type="button" class="game-chip" data-nums="9,9,9,9">All nines</button>
                            <button type="button" class="game-chip" data-nums="1,1,1,1">Impossible? 1,1,1,1</button>
                            <button type="button" class="game-chip" data-nums="2,5,7,8">2,5,7,8</button>
                            <button type="button" class="game-chip" data-nums="4,5,6,7">4,5,6,7</button>
                        </div>
                    </details>
                </div>

                <!-- ═══ RESULT CARD ═══ -->
                <div class="ic-result-card">
                    <div class="tool-card tool-result-card">
                        <div class="tool-result-content" id="game-result-content">
                            <div class="tool-empty-state ic-empty-state" id="game-empty-state">
                                <div class="game-empty-anim">
                                    <div class="game-card-anim">3</div>
                                    <div class="game-op-anim">+</div>
                                    <div class="game-card-anim">5</div>
                                    <div class="game-op-anim">&times;</div>
                                    <div class="game-card-anim">2</div>
                                    <div class="game-op-anim">+</div>
                                    <div class="game-card-anim">1</div>
                                    <div class="game-eq-anim">= 24</div>
                                </div>
                                <h3>Enter 4 numbers to solve</h3>
                                <p>Find all ways to make 24 (or any target) using +, &minus;, &times;, &divide; with step-by-step breakdowns.</p>
                            </div>
                        </div>
                        <div class="tool-result-actions" id="game-result-actions">
                            <button type="button" class="tool-action-btn" id="game-copy-btn">&#128203; Copy solutions</button>
                            <button type="button" class="tool-action-btn" id="game-share-btn">&#128279; Share URL</button>
                            <button type="button" class="tool-action-btn" id="game-print-btn" style="background:linear-gradient(135deg,#64748b,#475569);">&#128424; Print worksheet</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- In-content ad (mobile/tablet) -->
            <div class="ms-inline-ad">
                <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
            </div>

            <!-- ════════════ EDUCATIONAL CONTENT (preserved for SEO) ════════════ -->
            <section class="tool-expertise-section" style="margin:2rem 0;">

                <div class="tool-card" style="padding:1.75rem;margin-bottom:1.25rem;">
                    <h2 style="font-size:1.2rem;margin-bottom:0.75rem;">What is the 24 Game?</h2>
                    <p style="line-height:1.7;color:var(--ms-ink-soft,#475569);margin-bottom:0.75rem;">The <strong>24 Game</strong> (also called the <strong>24 Card Game</strong> or <strong>Make 24</strong>) is a classic mathematical puzzle invented by Robert Sun in 1988. Four numbers are drawn from a standard playing card deck (Ace = 1 through King = 13), and the goal is to combine all four using <strong>addition (+), subtraction (&minus;), multiplication (&times;), and division (&divide;)</strong> to get exactly <strong>24</strong>.</p>
                    <p style="line-height:1.7;color:var(--ms-ink-soft,#475569);margin-bottom:0.75rem;">Each number must be used <strong>exactly once</strong>. Parentheses can change the order of operations. The game is widely used in classrooms to develop mental math, number sense, and algebraic thinking.</p>
                    <div class="game-edu-grid">
                        <div class="game-edu-card" style="border-left:3px solid #f59e0b;">
                            <h4>Use all 4 numbers</h4>
                            <p>Every number must be used exactly once. You cannot skip or repeat any number.</p>
                        </div>
                        <div class="game-edu-card" style="border-left:3px solid #fbbf24;">
                            <h4>4 operations only</h4>
                            <p>Addition, subtraction, multiplication, and division. No exponents or other operations.</p>
                        </div>
                        <div class="game-edu-card" style="border-left:3px solid #d97706;">
                            <h4>Parentheses allowed</h4>
                            <p>Use parentheses freely to change the order of operations and group calculations.</p>
                        </div>
                        <div class="game-edu-card" style="border-left:3px solid #b45309;">
                            <h4>Result must be 24</h4>
                            <p>The final answer after all operations must equal exactly 24 (or your custom target).</p>
                        </div>
                    </div>
                </div>

                <div class="tool-card" style="padding:1.75rem;margin-bottom:1.25rem;">
                    <h2 style="font-size:1.2rem;margin-bottom:0.75rem;">Strategies to solve faster</h2>
                    <ol style="line-height:1.9;color:var(--ms-ink-soft,#475569);padding-left:1.25rem;">
                        <li><strong>Look for factor pairs of 24.</strong> &nbsp;24 = 1&times;24, 2&times;12, 3&times;8, 4&times;6. Try to make one factor from two numbers and the other from the remaining two.</li>
                        <li><strong>Try addition / subtraction chains.</strong> &nbsp;If factor pairs don't work, combine three numbers with multiplication and adjust the fourth with addition or subtraction.</li>
                        <li><strong>Don't forget division.</strong> &nbsp;The hardest puzzles often need division. The classic <em>3,3,8,8</em> requires <code>8 &divide; (3 &minus; 8 &divide; 3) = 24</code>.</li>
                        <li><strong>Use this solver to check.</strong> &nbsp;Enter your 4 numbers above and click <strong>Find solutions</strong> &mdash; every possible answer with step-by-step breakdowns.</li>
                    </ol>
                </div>
            </section>

        </section>

        <aside class="ms-rail" aria-label="Advertisements">
            <%@ include file="modern/ads/ad-ide-rail-top.jsp" %>
            <%@ include file="modern/ads/ad-ide-rail-bottom.jsp" %>
        </aside>
    </main>

    <!-- ═══ VISIBLE FAQ (mirrors faqNq/faqNa above) ═══ -->
    <section class="ms-faq-wrap" style="max-width:1440px;margin:2.5rem auto 0;padding:0 1.5rem;">
        <h2 class="ms-faq-title" id="faqs">Frequently asked</h2>
        <div class="ms-faq" aria-label="24 game solver FAQ">
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">What is the 24 game and how do you play it?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">The 24 Game is a mathematical card game where players use four numbers and basic arithmetic operations (+, &minus;, &times;, &divide;) to make exactly 24. Each number must be used exactly once. Parentheses change the order of operations. Invented by Robert Sun in 1988 and widely used in schools to develop mental math.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">How do you solve 24 with 4 numbers?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">First look for factor pairs of 24 (3&times;8, 4&times;6, 2&times;12) &mdash; try to make one factor from two numbers and the other from the remaining two. If that fails, try chains of operations. Common targets: 8&times;3, 6&times;4, 24&times;1.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">Can every set of 4 numbers make 24?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">No. <em>1,1,1,1</em> for example has no solution. With numbers 1&ndash;9 about 80% of four-number combinations are solvable. The hardest commonly cited is <em>3,3,8,8</em> requiring <code>8 &divide; (3 &minus; 8 &divide; 3) = 24</code>.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">What are the hardest 24 game puzzles?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">The hardest puzzles typically have only one solution and require division or complex nesting. Famous examples: <em>3,3,8,8</em> and <em>1,5,5,5</em>. Our solver rates difficulty by solution count: Expert (1&ndash;2), Hard (3&ndash;5), Medium (6&ndash;12), Easy (13+).</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">Is the 24 game good for learning math?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">Yes &mdash; it's excellent for mental math, number sense, and arithmetic fluency. It teaches order of operations, creative problem-solving, and strategic thinking. Many teachers use it as a classroom warm-up.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">What numbers from 1&ndash;9 are impossible to make 24?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">Some four-number combinations from 1&ndash;9 cannot make 24, such as <em>1,1,1,1</em> and <em>1,1,1,2</em>. With cards 1&ndash;13, about 458 of the 715 possible combinations are solvable. Our solver tells you instantly.</div></div>
        </div>
    </section>

    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <footer class="page-footer">
        <div class="footer-content">
            <p class="footer-text">&copy; 2026 8gwifi.org &mdash; Free Online Tools</p>
            <div class="footer-links">
                <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
                <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
                <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
            </div>
        </div>
    </footer>

    <%-- External JS — pure JavaScript combinatorial search.  All
         element IDs above (.game-num1..4, game-target, game-*-btn,
         game-result-content, .game-chip[data-nums]) are read by this
         file unchanged from the legacy page. --%>
    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/js/24-game-solver.js?v=<%=cacheVersion%>" defer></script>

    <script>
    // ── ms-faq accordion (math-studio FAQ pattern) ──
    document.querySelectorAll('.ms-faq-q').forEach(function (q) {
        q.addEventListener('click', function () { q.closest('.ms-faq-item').classList.toggle('open'); });
    });
    </script>
</body>
</html>
