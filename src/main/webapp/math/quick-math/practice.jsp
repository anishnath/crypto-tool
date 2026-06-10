<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*, java.nio.file.*, org.json.*" %>
<%@ include file="seo-helper.jsp" %>
<%
    // Get topic from URL
    String topicParam = request.getParameter("topic");

    // Default SEO values
    String seoTitle = "Mental Math Tricks | Quick Math Practice";
    String seoDescription = "Free interactive mental math practice with step-by-step breakdowns. Multiply, divide, and calculate faster in your head.";
    String seoH1 = "Mental Math Practice";
    String extraHead = "";
    String canonicalUrl = "https://8gwifi.org/math/quick-math/practice.jsp";

    // Load SEO data if topic is present
    org.json.JSONObject topicSEO = null;
    if (topicParam != null && !topicParam.isEmpty()) {
        topicSEO = getTopicSEO(topicParam, application);
    }

    if (topicSEO != null) {
        // Use topic-specific metadata from JSON (new field names)
        seoTitle = topicSEO.optString("seoTitle", seoTitle);
        seoDescription = topicSEO.optString("metaDescription", seoDescription);

        // Get H1 from jsonLD.name or parse from seoTitle
        if (topicSEO.has("jsonLD")) {
            org.json.JSONObject jsonLD = topicSEO.getJSONObject("jsonLD");
            seoH1 = jsonLD.optString("name", seoTitle.split("\\|")[0].trim());
        } else {
            seoH1 = seoTitle.split("\\|")[0].trim();
        }

        // Get canonical URL from JSON
        canonicalUrl = topicSEO.optString("canonical", canonicalUrl + "?topic=" + topicParam);

        // Generate Rich Tags (Social + JSON-LD)
        extraHead = generateSocialTags(topicParam, application);
        extraHead += "\n" + generateJSONLD(topicParam, application);
        extraHead += "\n" + generateBreadcrumbJSONLD(topicParam, seoH1, "");
    }

%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow">
    <title><%= seoTitle %></title>
    <meta name="description" content="<%= seoDescription %>">
    <link rel="canonical" href="<%= canonicalUrl %>">
    <%= extraHead %>
<% if (extraHead == null || extraHead.trim().isEmpty()) { /* no topic-specific social tags — use the branded default */ %>
    <meta property="og:type" content="website">
    <meta property="og:title" content="<%= seoTitle %>">
    <meta property="og:description" content="<%= seoDescription %>">
    <meta property="og:url" content="<%= canonicalUrl %>">
    <meta property="og:image" content="https://8gwifi.org/images/site/quick-math-og.png">
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="<%= seoTitle %>">
    <meta name="twitter:image" content="https://8gwifi.org/images/site/quick-math-og.png">
<% } %>

    <!-- Quick Math tool styles (ported into the math CSS family) -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/quick-math.css">

    <!-- Math studio shell -->
    <%@ include file="/math/partials/studio-head.jsp" %>
</head>

<% request.setAttribute("activeService", "quick-math-practice"); %>
<%@ include file="/math/partials/studio-open.jsp" %>

    <header class="ms-title">
        <nav class="ms-crumbs">
            <a href="<%=request.getContextPath()%>/index.jsp">Home</a><span>/</span>
            <a href="<%=request.getContextPath()%>/math/">Math</a><span>/</span>
            <a href="<%=request.getContextPath()%>/math/quick-math/">Quick Math</a><span>/</span>
            <span aria-current="page"><%= seoH1 %></span>
        </nav>
        <h1><%= seoH1 %></h1>
    </header>

<!-- Load Quick Math Core (split into base + topic bundles) -->
<script src="<%=request.getContextPath()%>/exams/js/quick-math-core-base.js" defer></script>
<script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-addition.js" defer></script>
<script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-multiplication.js" defer></script>
<script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-division.js" defer></script>
<script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-roots.js" defer></script>
<script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-percentages.js" defer></script>
<script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-algebra.js" defer></script>
<script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-probability.js" defer></script>
<script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-trains.js" defer></script>
<script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-streams.js" defer></script>
<script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-alligation.js" defer></script>
<script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-trigonometry.js" defer></script>
<script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-data.js" defer></script>
<script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-series.js" defer></script>
<script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-mensuration.js" defer></script>
<script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-surds.js" defer></script>
<script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-profit.js" defer></script>
<script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-simple-interest.js" defer></script>
<script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-misc.js" defer></script>
<script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-permcomb.js" defer></script>
<script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-advanced.js" defer></script>
<script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-boats-partnership.js" defer></script>
<script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-hcf-sets.js" defer></script>
<script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-number-patterns.js" defer></script>

<!-- Chalk Font -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Caveat:wght@400;600;700&display=swap" rel="stylesheet">

<div class="container main-content">

    <!-- Breadcrumb (Server-side for SEO) -->
    <nav class="breadcrumb" aria-label="Breadcrumb">
        <a href="<%=request.getContextPath()%>/exams/">Exams</a>
        <span class="breadcrumb-separator">/</span>
        <a href="<%=request.getContextPath()%>/exams/quick-math/">Quick Math</a>
        <span class="breadcrumb-separator">/</span>
        <span class="breadcrumb-current" id="crumb-topic"><%= seoH1 %></span>
    </nav>

    <div class="grid layout-grid">
        <%-- Ads handled by the studio shell (ms-rail / hero / sticky) --%>

        <!-- Main Practice Area -->
        <div class="practice-col">

            <!-- Topic intro -->
            <header class="mb-4">
                <h1 id="topic-title" class="section-title"><%= seoH1 %></h1>
                <p id="topic-desc" class="text-secondary"><%= seoDescription %></p>
            </header>

            <!-- Practice game (primary, above the fold) -->
            <div class="card bg-highlight">
                <div class="game-header">
                    <div class="stat-box">
                        <span class="text-sm text-muted">Streak</span>
                        <div id="streak-display" class="stat-value">0</div>
                    </div>
                    <div class="stat-box">
                        <span class="text-muted">Best Streak</span>
                        <div id="best-streak-display" class="stat-value">0</div>
                    </div>
                    <div class="stat-box">
                        <span class="text-muted">Time</span>
                        <div id="timer-display" class="stat-value">0.0s</div>
                    </div>
                    <div class="stat-box">
                        <span class="text-muted">Best Time</span>
                        <div id="best-time-display" class="stat-value stat-best">--</div>
                    </div>
                    <div class="stat-box">
                        <span class="text-muted">Accuracy</span>
                        <div id="accuracy-display" class="stat-value">--</div>
                    </div>
                </div>

                <div class="game-area">
                    <div id="question-text" class="question-display">Ready?</div>

                    <div class="input-group">
                        <input type="text" id="answer-input" class="game-input" placeholder="?"
                               autocomplete="off" autofocus aria-label="Your answer">
                        <button id="check-btn" class="btn btn-primary btn-game">Check</button>
                    </div>

                    <div id="feedback-msg" class="feedback-message" role="status" aria-live="polite"></div>
                </div>

                <!-- Mini Performance Chart -->
                <div class="perf-chart-container">
                    <div class="perf-chart-header">
                        <span class="text-sm text-muted">Last 10 answers</span>
                        <span id="avg-time" class="text-sm text-muted">Avg: --</span>
                    </div>
                    <div class="perf-chart" id="perf-chart">
                        <!-- Bars injected by JS -->
                    </div>
                </div>

                <div class="game-controls mt-4">
                    <button id="next-btn" class="btn btn-secondary btn-sm" style="display:none;">Next Question &rarr;</button>
                    <button id="skip-btn" class="btn btn-secondary btn-sm" type="button" title="New question (resets the timer)">Skip &rarr;</button>
                    <button id="reset-btn" class="btn btn-secondary btn-sm" type="button" title="Restart the session (keeps your best records)">&#8635; Reset</button>
                    <button id="share-btn" class="btn btn-secondary btn-sm" type="button">&#128279; Share result</button>
                    <div id="share-menu" class="share-menu" hidden>
                        <a id="share-x"  class="share-chip" target="_blank" rel="noopener">X / Twitter</a>
                        <a id="share-wa" class="share-chip" target="_blank" rel="noopener">WhatsApp</a>
                        <a id="share-tg" class="share-chip" target="_blank" rel="noopener">Telegram</a>
                        <a id="share-li" class="share-chip" target="_blank" rel="noopener">LinkedIn</a>
                        <button id="share-copy" class="share-chip" type="button">Copy link</button>
                        <button id="share-card" class="share-chip" type="button">&#128247; Result card (PNG)</button>
                    </div>
                </div>
            </div>

            <!-- Worked example (secondary, collapsible) -->
            <details class="card mt-6 learn-details" open>
                <summary class="learn-summary">How it works — see a worked example</summary>
                <div class="learn-section">
                    <div id="visualizer-container" class="visualizer-box">
                        <!-- Visual content injected via JS -->
                    </div>
                </div>
            </details>

        </div>

        <!-- Sidebar -->
        <div class="sidebar-col">
            <div class="card mt-6">
                <h3 class="text-base font-bold mb-2">More Tricks</h3>
                <div id="related-topics" class="related-list">
                    <!-- Injected by JS -->
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .layout-grid {
        display: grid;
        grid-template-columns: 1fr;
        gap: var(--space-6);
    }

    /* Hide left sidebar on mobile/tablet */
    .left-sidebar-col {
        display: none;
    }

    @media (min-width: 992px) {
        .layout-grid {
            grid-template-columns: 3fr 1fr;
        }
    }

    /* 3-column layout on large screens */
    @media (min-width: 1400px) {
        .layout-grid {
            grid-template-columns: 160px minmax(700px, 1fr) 250px;
        }
        .left-sidebar-col {
            display: block;
            position: sticky;
            top: 80px;
            height: fit-content;
        }
    }

    /* Even wider middle on very large screens */
    @media (min-width: 1600px) {
        .layout-grid {
            grid-template-columns: 160px minmax(800px, 1fr) 280px;
        }
    }

    .mb-6 { margin-bottom: var(--space-6); }
    .mb-4 { margin-bottom: var(--space-4); }
    .mb-2 { margin-bottom: var(--space-2); }
    .mt-6 { margin-top: var(--space-6); }

    .visualizer-box {
        background: linear-gradient(to bottom, #2a4a2a 0%, #1e3d1e 50%, #2a4a2a 100%);
        padding: var(--space-6);
        border-radius: var(--radius-lg);
        border: 12px solid #5c4033;
        box-shadow: inset 0 0 60px rgba(0, 0, 0, 0.3), 2px 2px 8px rgba(0, 0, 0, 0.4);
        position: relative;
        overflow: hidden;
    }

    .visualizer-box::before {
        content: '';
        position: absolute;
        top: 0; left: 0; right: 0; bottom: 0;
        background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)'/%3E%3C/svg%3E");
        opacity: 0.03;
        pointer-events: none;
    }

    .visualizer-box .math-visualizer {
        font-family: 'Caveat', cursive;
        color: #f5f5f5;
        text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
    }

    .visualizer-box .step-intro {
        font-size: 1.8rem !important;
        line-height: 1.4;
        color: #f0f0f0;
        margin-bottom: var(--space-4);
    }

    .visualizer-box .step-intro strong {
        color: #ffd54f;
        text-shadow: 0 0 10px rgba(255, 213, 79, 0.5);
    }

    .visualizer-box .example-box {
        background: rgba(255, 255, 255, 0.05);
        border-radius: var(--radius-md);
        padding: var(--space-4);
        margin: var(--space-4) 0;
    }

    .visualizer-box .problem {
        font-size: 2rem;
        font-weight: 700;
        color: #ffffff;
        border-bottom: 2px dashed rgba(255, 255, 255, 0.3);
        padding-bottom: var(--space-2);
        margin-bottom: var(--space-4);
        text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.4);
    }

    .visualizer-box .step {
        font-size: 1.3rem;
        color: #e8e8e8;
        background: rgba(255, 255, 255, 0.08);
        border-left: 4px solid #4fc3f7;
        margin: var(--space-2) 0;
        padding: var(--space-2) var(--space-3);
        border-radius: 0 var(--radius-sm) var(--radius-sm) 0;
    }

    .visualizer-box .step.visible { border-left-color: #81c784; }
    .visualizer-box .step strong { color: #ffd54f; font-weight: 700; }

    .visualizer-box .result {
        font-size: 1.5rem;
        color: #81c784;
        background: rgba(129, 199, 132, 0.15);
        border: 2px solid #81c784;
        text-align: center;
        padding: var(--space-3);
        margin-top: var(--space-4);
    }

    .visualizer-box .result.visible { animation: chalkPop 0.4s ease-out; }

    @keyframes chalkPop {
        0% { transform: scale(0.9); opacity: 0; }
        50% { transform: scale(1.05); }
        100% { transform: scale(1); opacity: 1; }
    }

    .visualizer-box svg text { font-family: 'Caveat', cursive; }
    .visualizer-box svg circle { filter: drop-shadow(2px 2px 2px rgba(0, 0, 0, 0.3)); }

    .visualizer-box .step-controls { border-top-color: rgba(255, 255, 255, 0.2); }
    .visualizer-box .step-counter { color: #b0b0b0; font-family: 'Caveat', cursive; font-size: 1.1rem; }
    .visualizer-box .btn-next { background: #4fc3f7; color: #1a1a1a; font-family: 'Caveat', cursive; font-size: 1.1rem; font-weight: 600; }
    .visualizer-box .btn-next:hover:not(:disabled) { background: #81d4fa; }
    .visualizer-box .btn-restart { background: rgba(255, 255, 255, 0.1); color: #e0e0e0; font-family: 'Caveat', cursive; font-size: 1.1rem; }
    .visualizer-box .btn-restart:hover { background: rgba(255, 255, 255, 0.2); }
    .visualizer-box .kbd-hint { color: #888; font-family: 'Caveat', cursive; font-size: 1rem; }
    .visualizer-box .kbd { background: rgba(255, 255, 255, 0.1); border-color: rgba(255, 255, 255, 0.2); color: #ccc; }
    .visualizer-box .skip-link { color: #888; font-family: 'Caveat', cursive; font-size: 1rem; }

    .bg-highlight {
        background: var(--bg-secondary);
        border: 2px solid var(--accent-light);
    }

    .game-header {
        display: flex;
        justify-content: space-between;
        margin-bottom: var(--space-6);
        padding-bottom: var(--space-4);
        border-bottom: 1px solid var(--border);
    }

    .stat-box { text-align: center; }
    .stat-value { font-size: var(--text-2xl); font-weight: 700; color: var(--accent-primary); line-height: 1; }
    .stat-best { color: var(--success, #22c55e); }

    .perf-chart-container { margin-top: var(--space-4); padding-top: var(--space-4); border-top: 1px solid var(--border); }
    .perf-chart-header { display: flex; justify-content: space-between; margin-bottom: var(--space-2); }
    .perf-chart { display: flex; align-items: flex-end; gap: 4px; height: 50px; padding: var(--space-2) 0; }
    .perf-bar { flex: 1; min-width: 0; background: var(--accent-primary); border-radius: 2px 2px 0 0; transition: height 0.3s ease; position: relative; }
    .perf-bar.fast { background: var(--success, #22c55e); }
    .perf-bar.medium { background: var(--warning, #f59e0b); }
    .perf-bar.slow { background: var(--error, #ef4444); }
    .perf-bar:hover::after { content: attr(data-time); position: absolute; bottom: 100%; left: 50%; transform: translateX(-50%); background: var(--bg-primary); border: 1px solid var(--border); padding: 2px 6px; border-radius: 4px; font-size: 11px; white-space: nowrap; z-index: 10; }
    .perf-empty { flex: 1; height: 4px; background: var(--bg-tertiary); border-radius: 2px; }

    @keyframes pulse {
        0% { transform: scale(1); }
        50% { transform: scale(1.2); color: #22c55e; }
        100% { transform: scale(1); }
    }

    .question-display { font-size: var(--text-4xl); font-weight: 800; text-align: center; margin: var(--space-6) 0; color: var(--text-primary); }
    .input-group { display: flex; gap: var(--space-2); max-width: 400px; margin: 0 auto; }
    .game-input { flex: 1; padding: var(--space-3) var(--space-4); font-size: var(--text-xl); border: 2px solid var(--border); border-radius: var(--radius-md); text-align: center; }
    .game-input:focus { border-color: var(--accent-primary); outline: none; }
    .feedback-message { text-align: center; min-height: 24px; margin-top: var(--space-4); font-weight: 600; }
    .feedback-correct { color: var(--success); }
    .feedback-wrong { color: var(--error); }

    .math-visualizer { text-align: center; }
    .step-intro { font-size: var(--text-lg); margin-bottom: var(--space-4); color: var(--text-primary); }
    .example-box { font-family: var(--font-mono); font-size: var(--text-xl); position: relative; display: inline-block; text-align: left; }
    .problem { font-size: var(--text-2xl); font-weight: 700; color: var(--text-primary); margin-bottom: var(--space-4); padding-bottom: var(--space-2); border-bottom: 2px solid var(--border); }

    .step { font-size: var(--text-base); color: var(--text-secondary); margin: var(--space-3) 0; padding: var(--space-2) var(--space-3); border-left: 3px solid var(--border); background: var(--bg-secondary); border-radius: 0 var(--radius-sm) var(--radius-sm) 0; opacity: 0; transform: translateX(-10px); transition: all 0.4s ease-out; display: none; }
    .step.visible { opacity: 1; transform: translateX(0); display: block; border-left-color: var(--accent-primary); }
    .step strong { color: var(--accent-primary); }

    .result { margin-top: var(--space-4); padding: var(--space-3); font-weight: bold; font-size: var(--text-lg); color: var(--success); background: var(--success-bg, rgba(34, 197, 94, 0.1)); border-radius: var(--radius-md); opacity: 0; transform: scale(0.95); transition: all 0.4s ease-out; display: none; }
    .result.visible { opacity: 1; transform: scale(1); display: block; }

    .step-controls { display: flex; align-items: center; justify-content: center; gap: var(--space-3); margin-top: var(--space-4); padding-top: var(--space-4); border-top: 1px solid var(--border); }
    .step-counter { font-size: var(--text-sm); color: var(--text-muted); min-width: 80px; }
    .btn-step { padding: var(--space-2) var(--space-4); font-size: var(--text-sm); font-weight: 600; border: none; border-radius: var(--radius-md); cursor: pointer; transition: all 0.2s; }
    .btn-next { background: var(--accent-primary); color: white; }
    .btn-next:hover:not(:disabled) { background: var(--accent-dark); transform: translateY(-1px); }
    .btn-next:disabled { background: var(--bg-tertiary); color: var(--text-muted); cursor: not-allowed; }
    .btn-restart { background: var(--bg-tertiary); color: var(--text-secondary); }
    .btn-restart:hover { background: var(--border); }
    .skip-link { font-size: var(--text-sm); color: var(--text-muted); text-decoration: underline; cursor: pointer; }
    .skip-link:hover { color: var(--text-secondary); }
    .kbd-hint { font-size: var(--text-xs); color: var(--text-muted); margin-top: var(--space-2); }
    .kbd { display: inline-block; padding: 2px 6px; background: var(--bg-tertiary); border: 1px solid var(--border); border-radius: 4px; font-family: var(--font-mono); font-size: 11px; }
</style>

<script>
    class StepVisualizer {
        constructor(container) {
            this.container = container;
            this.steps = [];
            this.result = null;
            this.currentStep = 0;
            this.totalSteps = 0;
            this.isComplete = false;
        }

        init(explanationHTML) {
            this.container.innerHTML = explanationHTML + this.buildControls();
            this.steps = Array.from(this.container.querySelectorAll('.step'));
            this.result = this.container.querySelector('.result');
            this.totalSteps = this.steps.length + (this.result ? 1 : 0);
            this.currentStep = 0;
            this.isComplete = false;

            this.nextBtn = this.container.querySelector('.btn-next');
            this.restartBtn = this.container.querySelector('.btn-restart');
            this.counter = this.container.querySelector('.step-counter');
            this.skipLink = this.container.querySelector('.skip-link');

            this.nextBtn?.addEventListener('click', () => this.nextStep());
            this.restartBtn?.addEventListener('click', () => this.restart());
            this.skipLink?.addEventListener('click', () => this.showAll());

            this.keyHandler = (e) => {
                if (e.target.tagName === 'INPUT') return;
                if (e.code === 'Space' || e.code === 'Enter') {
                    e.preventDefault();
                    if (!this.isComplete) this.nextStep();
                }
                if (e.code === 'KeyR') this.restart();
            };
            document.addEventListener('keydown', this.keyHandler);
            this.updateUI();
        }

        buildControls() {
            return '<div class="step-controls"><button class="btn-step btn-restart" title="Restart (R)">↻ Restart</button><span class="step-counter">Step 0 of 0</span><button class="btn-step btn-next">Next Step →</button></div><div class="kbd-hint">Press <span class="kbd">Space</span> for next step, <span class="kbd">R</span> to restart</div><span class="skip-link">Show all steps</span>';
        }

        nextStep() {
            if (this.currentStep < this.steps.length) {
                this.steps[this.currentStep].classList.add('visible');
                this.currentStep++;
            } else if (this.result && this.currentStep === this.steps.length) {
                this.result.classList.add('visible');
                this.currentStep++;
                this.isComplete = true;
            }
            this.updateUI();
        }

        showAll() {
            this.steps.forEach(step => step.classList.add('visible'));
            if (this.result) this.result.classList.add('visible');
            this.currentStep = this.totalSteps;
            this.isComplete = true;
            this.updateUI();
        }

        restart() {
            this.steps.forEach(step => step.classList.remove('visible'));
            if (this.result) this.result.classList.remove('visible');
            this.currentStep = 0;
            this.isComplete = false;
            this.updateUI();
        }

        updateUI() {
            if (this.counter) this.counter.textContent = 'Step ' + this.currentStep + ' of ' + this.totalSteps;
            if (this.nextBtn) {
                this.nextBtn.disabled = this.isComplete;
                this.nextBtn.textContent = this.isComplete ? 'Done ✓' : 'Next Step →';
            }
            if (this.skipLink) this.skipLink.style.display = this.isComplete ? 'none' : 'inline';
        }

        destroy() { document.removeEventListener('keydown', this.keyHandler); }
    }

    document.addEventListener('DOMContentLoaded', () => {
        const urlParams = new URLSearchParams(window.location.search);
        const topicId = urlParams.get('topic');
        const topic = QuickMath.getTopic(topicId);

        if (!topic) {
            window.location.href = 'index.jsp';
            return;
        }

        document.title = topic.title + " - Exams";
        document.getElementById('topic-title').innerText = topic.ctrHeadline || topic.title;
        document.getElementById('topic-desc').innerText = topic.description;
        document.getElementById('crumb-topic').innerText = topic.title;

        const visualizerContainer = document.getElementById('visualizer-container');
        const visualizer = new StepVisualizer(visualizerContainer);
        visualizer.init(topic.explanation || '<p>No visualization available.</p>');

        let currentQuestion = null;
        let streak = 0;
        let isAnswered = false;
        let startTime = null;
        let timerInterval = null;
        let bestTime = null;
        let answerTimes = [];

        const qDisplay = document.getElementById('question-text');
        const ansInput = document.getElementById('answer-input');
        const checkBtn = document.getElementById('check-btn');
        const nextBtn = document.getElementById('next-btn');
        const feedback = document.getElementById('feedback-msg');
        const streakDisplay = document.getElementById('streak-display');
        const timerDisplay = document.getElementById('timer-display');
        const bestTimeDisplay = document.getElementById('best-time-display');
        const perfChart = document.getElementById('perf-chart');
        const avgTimeDisplay = document.getElementById('avg-time');

        const storageKey = 'quickmath-best-' + topicId;
        const savedBest = localStorage.getItem(storageKey);
        if (savedBest) {
            bestTime = parseFloat(savedBest);
            bestTimeDisplay.innerText = bestTime.toFixed(1) + 's';
        }

        // Best streak (persisted) + session accuracy
        let totalAttempts = 0, totalCorrect = 0, bestStreak = 0;
        const bestStreakDisplay = document.getElementById('best-streak-display');
        const accuracyDisplay   = document.getElementById('accuracy-display');
        const streakKey = 'quickmath-beststreak-' + topicId;
        bestStreak = parseInt(localStorage.getItem(streakKey) || '0', 10);
        if (bestStreakDisplay) bestStreakDisplay.innerText = bestStreak;

        function updateAccuracy() {
            if (!accuracyDisplay) return;
            accuracyDisplay.innerText = totalAttempts
                ? Math.round((totalCorrect / totalAttempts) * 100) + '%'
                : '--';
        }

        // Persist the live session per-topic so streak/accuracy/chart survive a
        // reload — cleared only by Reset.
        const sessionKey = 'quickmath-session-' + topicId;
        function saveSession() {
            try {
                localStorage.setItem(sessionKey, JSON.stringify({ streak, totalAttempts, totalCorrect, answerTimes }));
            } catch (e) {}
        }
        (function restoreSession() {
            try {
                const raw = localStorage.getItem(sessionKey);
                if (!raw) return;
                const s = JSON.parse(raw);
                streak = s.streak || 0;
                totalAttempts = s.totalAttempts || 0;
                totalCorrect = s.totalCorrect || 0;
                answerTimes = Array.isArray(s.answerTimes) ? s.answerTimes : [];
                streakDisplay.innerText = streak;
                updateAccuracy();              // chart redraws via renderChart() during init
            } catch (e) {}
        })();

        function startTimer() {
            startTime = performance.now();
            timerInterval = setInterval(() => {
                timerDisplay.innerText = ((performance.now() - startTime) / 1000).toFixed(1) + 's';
            }, 100);
        }

        function stopTimer() {
            if (timerInterval) { clearInterval(timerInterval); timerInterval = null; }
            return (performance.now() - startTime) / 1000;
        }

        function updateBestTime(time) {
            if (bestTime === null || time < bestTime) {
                bestTime = time;
                bestTimeDisplay.innerText = time.toFixed(1) + 's';
                bestTimeDisplay.style.animation = 'none';
                bestTimeDisplay.offsetHeight;
                bestTimeDisplay.style.animation = 'pulse 0.5s ease';
                localStorage.setItem(storageKey, time.toString());
                return true;
            }
            return false;
        }

        function addAnswerTime(time) {
            answerTimes.push(time);
            if (answerTimes.length > 10) answerTimes.shift();
            renderChart();
        }

        function renderChart() {
            if (answerTimes.length === 0) {
                perfChart.innerHTML = Array(10).fill('<div class="perf-empty"></div>').join('');
                avgTimeDisplay.innerText = 'Avg: --';
                return;
            }

            const maxTime = Math.max(...answerTimes);
            const avgTime = answerTimes.reduce((a, b) => a + b, 0) / answerTimes.length;
            avgTimeDisplay.innerText = 'Avg: ' + avgTime.toFixed(1) + 's';

            let html = Array(10 - answerTimes.length).fill('<div class="perf-empty"></div>').join('');
            answerTimes.forEach(t => {
                const heightPct = maxTime > 0 ? Math.max(10, (t / maxTime) * 100) : 10;
                const speedClass = t <= avgTime * 0.7 ? 'fast' : t >= avgTime * 1.3 ? 'slow' : 'medium';
                html += '<div class="perf-bar ' + speedClass + '" style="height: ' + heightPct + '%;" data-time="' + t.toFixed(1) + 's"></div>';
            });
            perfChart.innerHTML = html;
        }

        function loadQuestion() {
            currentQuestion = topic.generateQuestion();
            qDisplay.innerText = currentQuestion.text;
            ansInput.value = '';
            ansInput.focus({ preventScroll: true });
            feedback.innerText = '';
            feedback.className = 'feedback-message';
            isAnswered = false;
            nextBtn.style.display = 'none';
            checkBtn.innerText = 'Check';
            checkBtn.disabled = false;
            timerDisplay.innerText = '0.0s';
            startTimer();
        }

        function handleCheck() {
            if (isAnswered) return;
            const val = ansInput.value;
            if (!val) return;

            const isCorrect = topic.checkAnswer(val, currentQuestion.answer);
            totalAttempts++;

            if (isCorrect) {
                totalCorrect++;
                const solveTime = stopTimer();
                const isNewBest = updateBestTime(solveTime);
                addAnswerTime(solveTime);

                feedback.innerText = 'Correct! ' + solveTime.toFixed(1) + 's' + (isNewBest ? ' - New Best!' : '');
                feedback.className = 'feedback-message feedback-correct';
                streak++;
                streakDisplay.innerText = streak;
                if (streak > bestStreak) {
                    bestStreak = streak;
                    if (bestStreakDisplay) {
                        bestStreakDisplay.innerText = bestStreak;
                        bestStreakDisplay.style.animation = 'none'; bestStreakDisplay.offsetHeight;
                        bestStreakDisplay.style.animation = 'pulse 0.5s ease';
                    }
                    localStorage.setItem(streakKey, bestStreak.toString());
                }
                isAnswered = true;
                checkBtn.disabled = true;

                // Trigger social popup on streak milestones
                if (typeof ExamSocialPopup !== 'undefined') {
                    ExamSocialPopup.checkStreak(streak);
                }

                setTimeout(loadQuestion, 1200);
            } else {
                feedback.innerText = 'Oops! Try again. Remember the rule.';
                feedback.className = 'feedback-message feedback-wrong';
                streak = 0;
                streakDisplay.innerText = streak;
                ansInput.focus({ preventScroll: true });
                ansInput.select();
            }
            updateAccuracy();
            saveSession();
        }

        checkBtn.addEventListener('click', handleCheck);
        ansInput.addEventListener('keypress', (e) => { if (e.key === 'Enter') handleCheck(); });
        renderChart();
        loadQuestion();

        // ---- Skip / Reset controls ----
        function resetSession() {
            streak = 0; streakDisplay.innerText = '0';
            totalAttempts = 0; totalCorrect = 0; updateAccuracy();
            answerTimes = []; renderChart();
            try { localStorage.removeItem(sessionKey); } catch (e) {}
            loadQuestion();   // fresh question, timer reset, input focused
        }
        document.getElementById('skip-btn')?.addEventListener('click', () => loadQuestion());
        document.getElementById('reset-btn')?.addEventListener('click', resetSession);

        // ---- Share result to social channels ----
        (function setupShare() {
            const shareBtn  = document.getElementById('share-btn');
            const shareMenu = document.getElementById('share-menu');
            if (!shareBtn) return;

            const topicName = (document.getElementById('topic-title')?.textContent || 'mental math').trim();
            const pageUrl   = window.location.href.split('#')[0];

            function stats() {
                return {
                    acc:    totalAttempts ? Math.round((totalCorrect / totalAttempts) * 100) : 0,
                    bt:     bestTime != null ? bestTime.toFixed(1) + 's' : '—',
                    streak: streak,
                    best:   bestStreak
                };
            }
            function shareText() {
                const s = stats();
                return 'I’m drilling ' + topicName + ' on 8gwifi.org — 🔥 streak ' + s.streak +
                       ' (best ' + s.best + '), ⚡ best time ' + s.bt + ', 🎯 ' + s.acc + '% accuracy. Try it:';
            }

            function buildLinks() {
                const t = shareText(), u = pageUrl;
                const et = encodeURIComponent(t), eu = encodeURIComponent(u);
                const set = (id, href) => { const a = document.getElementById(id); if (a) a.href = href; };
                set('share-x',  'https://twitter.com/intent/tweet?text=' + et + '&url=' + eu);
                set('share-wa', 'https://wa.me/?text=' + encodeURIComponent(t + ' ' + u));
                set('share-tg', 'https://t.me/share/url?url=' + eu + '&text=' + et);
                set('share-li', 'https://www.linkedin.com/sharing/share-offsite/?url=' + eu);
            }

            // ---- Result-card image (canvas → 1080×1080 PNG) ----
            function roundRect(x, rx, ry, w, h, r) {
                x.beginPath();
                x.moveTo(rx + r, ry);
                x.arcTo(rx + w, ry, rx + w, ry + h, r);
                x.arcTo(rx + w, ry + h, rx, ry + h, r);
                x.arcTo(rx, ry + h, rx, ry, r);
                x.arcTo(rx, ry, rx + w, ry, r);
                x.closePath();
            }
            function drawCard() {
                const W = 1080, H = 1080, cv = document.createElement('canvas');
                cv.width = W; cv.height = H;
                const x = cv.getContext('2d');
                x.fillStyle = '#faf8f4'; x.fillRect(0, 0, W, H);
                x.fillStyle = '#15803d'; x.fillRect(0, 0, W, 156);
                x.textBaseline = 'middle'; x.fillStyle = '#ffffff';
                x.font = '700 50px Inter, system-ui, sans-serif';
                x.fillText('8gwifi · Quick Math', 72, 84);

                x.textBaseline = 'alphabetic'; x.fillStyle = '#1c1917';
                x.font = '800 66px Inter, system-ui, sans-serif';
                const words = topicName.split(' '); let line = ''; const lines = [];
                for (const w of words) {
                    const test = line ? line + ' ' + w : w;
                    if (x.measureText(test).width > W - 144 && line) { lines.push(line); line = w; }
                    else line = test;
                }
                lines.push(line);
                const shown = lines.slice(0, 2);
                shown.forEach((ln, i) => x.fillText(ln, 72, 286 + i * 78));
                x.fillStyle = '#78716c'; x.font = '400 34px Inter, system-ui, sans-serif';
                x.fillText('Mental math speed drill', 72, 286 + shown.length * 78 + 18);

                const s = stats(), top = 524;
                const tiles = [
                    ['🔥', String(s.streak), 'Streak'],
                    ['🏆', String(s.best),   'Best streak'],
                    ['⚡', s.bt,              'Best time'],
                    ['🎯', s.acc + '%',       'Accuracy']
                ];
                tiles.forEach((t, i) => {
                    const tx = 72 + (i % 2) * 484, ty = top + ((i / 2) | 0) * 214, tw = 452, th = 188;
                    x.fillStyle = '#ffffff'; roundRect(x, tx, ty, tw, th, 24); x.fill();
                    x.strokeStyle = 'rgba(28,25,23,0.10)'; x.lineWidth = 2; roundRect(x, tx, ty, tw, th, 24); x.stroke();
                    x.font = '400 46px Inter, system-ui, sans-serif'; x.fillStyle = '#1c1917';
                    x.fillText(t[0], tx + 32, ty + 74);
                    x.font = '800 74px Inter, system-ui, sans-serif'; x.fillStyle = '#15803d';
                    x.fillText(t[1], tx + 104, ty + 86);
                    x.font = '700 28px Inter, system-ui, sans-serif'; x.fillStyle = '#78716c';
                    x.fillText(t[2].toUpperCase(), tx + 34, ty + 142);
                });

                x.fillStyle = '#15803d'; x.font = '600 36px Inter, system-ui, sans-serif';
                x.fillText('Practice free → 8gwifi.org/math/quick-math', 72, 1014);
                return cv;
            }
            async function cardBlob() {
                if (document.fonts && document.fonts.ready) { try { await document.fonts.ready; } catch (e) {} }
                return new Promise(res => drawCard().toBlob(res, 'image/png'));
            }
            function downloadCard(blob) {
                const a = document.createElement('a');
                a.href = URL.createObjectURL(blob);
                a.download = 'quickmath-result.png';
                document.body.appendChild(a); a.click(); document.body.removeChild(a);
                setTimeout(() => URL.revokeObjectURL(a.href), 2000);
            }

            shareBtn.addEventListener('click', async () => {
                const t = shareText(), u = pageUrl;
                // Best path: native share WITH the result-card image (mobile / supported browsers)
                try {
                    const blob = await cardBlob();
                    const file = new File([blob], 'quickmath-result.png', { type: 'image/png' });
                    if (navigator.canShare && navigator.canShare({ files: [file] })) {
                        await navigator.share({ files: [file], text: t + ' ' + u, title: '8gwifi Quick Math' });
                        return;
                    }
                } catch (e) { /* cancelled or unsupported — fall back to the channel menu */ }
                buildLinks();
                shareMenu.hidden = !shareMenu.hidden;
            });

            const copyBtn = document.getElementById('share-copy');
            if (copyBtn) copyBtn.addEventListener('click', () => {
                navigator.clipboard?.writeText(shareText() + ' ' + pageUrl);
                copyBtn.textContent = 'Copied!';
                setTimeout(() => { copyBtn.textContent = 'Copy link'; }, 1500);
            });

            const cardBtn = document.getElementById('share-card');
            if (cardBtn) cardBtn.addEventListener('click', async () => {
                cardBtn.textContent = 'Rendering…';
                try { downloadCard(await cardBlob()); cardBtn.textContent = '📷 Saved!'; }
                catch (e) { cardBtn.textContent = '📷 Result card (PNG)'; }
                setTimeout(() => { cardBtn.textContent = '📷 Result card (PNG)'; }, 1800);
            });
        })();

        // Populate Related Topics
        function loadRelatedTopics() {
            const container = document.getElementById('related-topics');
            if (!container) return;

            const allTopics = QuickMath.topics;
            const currentTopic = topic;
            const related = [];

            console.log('Current topic:', topicId, currentTopic.category, currentTopic.tags);
            console.log('All topics count:', Object.keys(allTopics).length);

            // Find topics with same category or matching tags
            for (const key in allTopics) {
                if (key === topicId) continue; // Skip current
                const t = allTopics[key];

                // Score based on category match and tag overlap
                let score = 0;
                if (t.category === currentTopic.category) score += 2;
                if (currentTopic.tags && t.tags) {
                    const overlap = currentTopic.tags.filter(tag => t.tags.includes(tag)).length;
                    score += overlap;
                }

                if (score > 0) {
                    related.push({ id: key, title: t.title, difficulty: t.difficulty, score });
                }
            }

            console.log('Related topics found:', related.length, related.slice(0, 3));

            // Sort by score (highest first), then shuffle ties, take top 5
            related.sort((a, b) => b.score - a.score || Math.random() - 0.5);
            // Filter to only include topics with valid id and title
            const topRelated = related.filter(t => t.id && t.title).slice(0, 5);

            console.log('Top related:', JSON.stringify(topRelated));

            if (topRelated.length === 0) {
                container.innerHTML = '<p class="text-muted text-sm">No related topics found.</p>';
                return;
            }

            container.innerHTML = topRelated.map(t => {
                console.log('Rendering:', t.id, t.title);
                const title = t.title ? t.title.split('|')[0].trim() : t.id;
                const diff = t.difficulty || 'Beginner';
                return '<a href="practice.jsp?topic=' + t.id + '" class="related-item">' +
                    '<span class="related-title">' + title + '</span>' +
                    '<span class="related-diff ' + diff.toLowerCase() + '">' + diff + '</span>' +
                    '</a>';
            }).join('');
        }

        loadRelatedTopics();
    });
</script>

<style>
.related-list {
    display: flex;
    flex-direction: column;
    gap: var(--space-2);
}

.related-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: var(--space-2);
    padding: var(--space-2) var(--space-3);
    background: var(--bg-secondary);
    border: 1px solid var(--border);
    border-radius: var(--radius-md);
    text-decoration: none;
    color: var(--text-primary);
    font-size: var(--text-sm);
    transition: all 0.2s ease;
}

.related-item:hover {
    border-color: var(--accent-primary);
    background: var(--bg-tertiary);
}

.related-title {
    flex: 1;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.related-diff {
    font-size: var(--text-xs);
    padding: 2px 6px;
    border-radius: var(--radius-sm);
    font-weight: 500;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.related-diff.beginner {
    background: rgba(34, 197, 94, 0.15);
    color: var(--success);
}

.related-diff.intermediate {
    background: rgba(245, 158, 11, 0.15);
    color: var(--warning);
}

.related-diff.advanced {
    background: rgba(239, 68, 68, 0.15);
    color: var(--error);
}
</style>

<%@ include file="/math/partials/studio-close.jsp" %>
