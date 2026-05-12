<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Machine Learning Visualized — Interactive ML Algorithms in Your Browser" />
        <jsp:param name="toolCategory" value="Machine Learning" />
        <jsp:param name="toolDescription" value="Watch ML algorithms learn, step by step. Gradient descent, K-means, PCA, perceptron, logistic regression, and neural networks — derived from first principles with interactive visualizations. No signup." />
        <jsp:param name="toolUrl" value="ml/" />
        <jsp:param name="toolKeywords" value="machine learning visualizer, interactive ml, gradient descent animation, k-means visualization, pca demo, perceptron decision boundary, neural network training, ml from scratch, backpropagation visualization, ml visualizations interactive, ml notebooks online" />
        <jsp:param name="toolImage" value="ml-visualized-og.png" />
        <jsp:param name="toolFeatures" value="10 algorithms from first principles,Math derivation alongside code,Watch training converge live,Editable algorithm on every page,Four-chapter curriculum,Dark mode,Mobile responsive,100% free,No signup" />
        <jsp:param name="teaches" value="Gradient descent, activation functions, PCA, K-means clustering, perceptron classification, logistic regression, neural network training, backpropagation, weight visualization" />
        <jsp:param name="educationalLevel" value="Undergraduate, Graduate, Self-study" />
        <jsp:param name="faq1q" value="Where should I start if I'm new to ML?" />
        <jsp:param name="faq1a" value="Begin with Chapter 1: Gradient Descent. Every other algorithm on this site uses gradient descent (or a relative) to actually learn its parameters, so the intuition you build there carries everywhere. Then walk the chapters in order — clustering, linear models, neural networks." />
        <jsp:param name="faq2q" value="Do I need to install anything?" />
        <jsp:param name="faq2a" value="No. Every demo runs entirely in your browser tab — no install, no Jupyter, no Colab, no signup. Open a page, click Run, watch the algorithm train." />
        <jsp:param name="faq3q" value="Can I edit the algorithm?" />
        <jsp:param name="faq3a" value="Yes. Every demo page shows the underlying algorithm in an editable panel. Change a learning rate, a kernel, an init seed, or rewrite the loop entirely — hit Run and watch the visualization update with your version." />
        <jsp:param name="faq4q" value="Why &quot;from first principles&quot;?" />
        <jsp:param name="faq4a" value="The demos implement each algorithm with plain numpy (loops, matrix ops, gradient computations) rather than calling a one-line scikit-learn fit. The goal is to see the math actually executing — every iteration of gradient descent, every centroid reassignment, every weight update — so you build intuition for what the library calls are hiding." />
        <jsp:param name="faq5q" value="How is this different from ml-visualized.com?" />
        <jsp:param name="faq5a" value="The curriculum structure is inspired by ml-visualized.com (four chapters: optimization, clustering, linear models, neural networks), but the interactivity is different. ml-visualized embeds pre-rendered animations; here you can pause, edit the algorithm, drag the starting point, and re-run on your own settings." />
        <jsp:param name="faq6q" value="What's the difference between these demos and the existing ML tools?" />
        <jsp:param name="faq6a" value="The existing tools (NN Architecture Visualizer, Activation Function Explorer, Logistic Regression Calculator, ROC/AUC, ML Pipeline) are utility pages that compute a result or render a diagram. The chapter demos are training visualizations — you watch the algorithm iterate and converge, with editable source so you can experiment." />
    </jsp:include>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="ctx" content="<%=request.getContextPath()%>" />

    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "CollectionPage",
            "name": "Machine Learning Visualized",
            "description": "Interactive ML algorithm demos derived from first principles. Four chapters: optimization, clustering, linear models, neural networks.",
            "url": "https://8gwifi.org/ml/",
            "mainEntity": {
                "@type": "ItemList",
                "numberOfItems": 8,
                "itemListElement": [
                    {"@type": "ListItem", "position": 1, "name": "Neural Network Architecture Visualizer", "url": "https://8gwifi.org/ml/nn-viz.jsp"},
                    {"@type": "ListItem", "position": 2, "name": "Activation Function Explorer", "url": "https://8gwifi.org/activation_function_explorer.jsp"},
                    {"@type": "ListItem", "position": 3, "name": "Logistic Regression Calculator", "url": "https://8gwifi.org/Logistic_Regression.jsp"},
                    {"@type": "ListItem", "position": 4, "name": "ROC & AUC Calculator", "url": "https://8gwifi.org/ROC_AUC.jsp"},
                    {"@type": "ListItem", "position": 5, "name": "ML Pipeline Builder", "url": "https://8gwifi.org/ML_Pipeline.jsp"}
                ]
            }
        }
    </script>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Instrument+Serif:ital@0;1&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=v%>">
    <%-- Reuse math-studio.css verbatim — same .ms-* design system for both
         math and ml sections.  Any tweaks here are layered in the <style>
         block below; no fork. --%>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css?v=<%=v%>">

    <style>
        /* ── ML-specific additions on top of math-studio tokens ──────── */

        /* Hero — same shape as math/index.jsp, recoloured to indigo/violet
           so the ML section reads as a sibling but not identical. */
        .ms-hero-banner {
            position: relative; overflow: hidden;
            background:
                    radial-gradient(circle at 12% 0%, rgba(79, 70, 229, 0.20), transparent 48%),
                    radial-gradient(circle at 88% 100%, rgba(21, 128, 61, 0.10), transparent 50%),
                    var(--ms-panel-bg);
            color: var(--ms-ink);
            padding: 2.25rem 2.25rem 2rem;
            border-radius: var(--ms-radius-lg);
            border: 1px solid var(--ms-line);
            box-shadow: var(--ms-shadow);
        }
        .ms-hero-banner h1 {
            font: 400 2.4rem/1.1 var(--ms-font-serif);
            margin: 0 0 0.4rem;
            letter-spacing: -0.02em;
        }
        .ms-hero-banner h1 em { font-style: italic; color: #4f46e5; }
        [data-theme="dark"] .ms-hero-banner h1 em { color: #a5b4fc; }
        .ms-hero-banner p { font: 1.02rem var(--ms-font-sans); color: var(--ms-ink-soft); margin: 0 0 1.5rem; max-width: 60ch; }
        .ms-hero-stats { display: flex; gap: 2.25rem; flex-wrap: wrap; }
        .ms-hero-stat { font: 500 0.82rem var(--ms-font-sans); color: var(--ms-muted); }
        .ms-hero-stat strong {
            display: block;
            font: 400 1.65rem var(--ms-font-serif);
            color: var(--ms-ink);
            margin-bottom: 2px;
            letter-spacing: -0.015em;
        }

        /* Pyodide status pill — top of workspace */
        .ml-runtime-pill {
            display: inline-flex; align-items: center; gap: 0.55rem;
            padding: 0.4rem 0.85rem;
            margin-bottom: 0.9rem;
            background: var(--ms-panel-bg);
            border: 1px solid var(--ms-line);
            border-radius: var(--ms-radius-pill);
            font: 500 0.78rem var(--ms-font-mono);
            color: var(--ms-muted);
            box-shadow: var(--ms-shadow-sm);
        }
        .ml-runtime-pill .ml-runtime-dot {
            width: 8px; height: 8px; border-radius: 50%;
            background: #94a3b8;
            box-shadow: 0 0 0 3px rgba(148, 163, 184, 0.15);
            transition: background var(--ms-transition), box-shadow var(--ms-transition);
        }
        .ml-runtime-pill[data-state="loading"] .ml-runtime-dot { background: #f59e0b; box-shadow: 0 0 0 3px rgba(245, 158, 11, 0.18); animation: ml-pulse 1.4s ease-in-out infinite; }
        .ml-runtime-pill[data-state="ready"] .ml-runtime-dot { background: #22c55e; box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.18); }
        .ml-runtime-pill[data-state="error"] .ml-runtime-dot { background: #ef4444; box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.18); }
        @keyframes ml-pulse { 0%, 100% { opacity: 1 } 50% { opacity: 0.45 } }

        /* Section heading inside workspace cards */
        .ms-section-title {
            font: 500 1.25rem var(--ms-font-serif);
            color: var(--ms-ink);
            margin: 0 0 1rem;
            letter-spacing: -0.015em;
        }
        .ms-section-title small {
            font: 0.85rem var(--ms-font-sans);
            color: var(--ms-muted);
            margin-left: 0.65rem;
        }

        /* Chapter cards — larger than tool cards, one per chapter */
        .ml-chapter-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 0.85rem;
        }
        .ml-chapter-card {
            display: block;
            padding: 1.15rem 1.2rem 1.2rem;
            background: var(--ms-panel-bg);
            border: 1px solid var(--ms-line);
            border-radius: var(--ms-radius);
            text-decoration: none; color: var(--ms-ink);
            transition: transform var(--ms-transition),
                        border-color var(--ms-transition),
                        box-shadow var(--ms-transition);
            position: relative; overflow: hidden;
        }
        .ml-chapter-card::before {
            content: '';
            position: absolute; inset: 0 0 auto 0; height: 3px;
            background: linear-gradient(90deg, #4f46e5, #818cf8);
            opacity: 0.65;
        }
        .ml-chapter-card:hover {
            transform: translateY(-2px);
            border-color: #818cf8;
            box-shadow: var(--ms-shadow-lg);
        }
        .ml-chapter-eyebrow {
            font: 500 0.72rem var(--ms-font-mono);
            color: #4f46e5;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            margin-bottom: 0.35rem;
        }
        [data-theme="dark"] .ml-chapter-eyebrow { color: #a5b4fc; }
        .ml-chapter-title {
            font: 400 1.35rem var(--ms-font-serif);
            margin: 0 0 0.4rem;
            letter-spacing: -0.015em;
        }
        .ml-chapter-summary {
            font: 0.86rem/1.5 var(--ms-font-sans);
            color: var(--ms-muted);
            margin: 0 0 0.85rem;
        }
        .ml-chapter-meta {
            font: 500 0.74rem var(--ms-font-mono);
            color: var(--ms-muted);
            display: flex; gap: 0.85rem; flex-wrap: wrap;
        }
        .ml-chapter-meta span::before { content: '· '; opacity: 0.55; }
        .ml-chapter-meta span:first-child::before { content: ''; }

        /* Tool card — reused pattern from math/index.jsp, plus "soon" variant */
        .ms-tool-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
            gap: 0.85rem;
        }
        .ms-tool-card {
            display: flex; align-items: center; gap: 0.85rem;
            padding: 1rem 1.1rem;
            background: var(--ms-panel-bg);
            border: 1px solid var(--ms-line);
            border-radius: var(--ms-radius);
            text-decoration: none; color: var(--ms-ink);
            transition: transform var(--ms-transition),
                        border-color var(--ms-transition),
                        box-shadow var(--ms-transition);
            position: relative;
        }
        .ms-tool-card:hover {
            transform: translateY(-2px);
            border-color: var(--ms-accent);
            box-shadow: var(--ms-shadow);
        }
        .ms-tool-card-icon {
            width: 40px; height: 40px; flex-shrink: 0;
            display: inline-flex; align-items: center; justify-content: center;
            border-radius: var(--ms-radius-sm);
            font: 1.05rem var(--ms-font-serif);
            background: var(--ms-accent-soft);
            color: var(--ms-accent);
        }
        .ms-tool-card:hover .ms-tool-card-icon { background: var(--ms-accent); color: #fff; }
        .ms-tool-card-title { font: 600 0.95rem var(--ms-font-sans); display: block; margin-bottom: 2px; }
        .ms-tool-card-sub   { font: 0.8rem var(--ms-font-sans); color: var(--ms-muted); }

        .ms-tool-card.is-soon {
            opacity: 0.7;
            background: var(--ms-panel-bg-soft);
            cursor: not-allowed;
        }
        .ms-tool-card.is-soon:hover { transform: none; border-color: var(--ms-line); box-shadow: var(--ms-shadow-sm); }
        .ms-tool-card.is-soon .ms-tool-card-icon { background: rgba(120, 113, 108, 0.10); color: var(--ms-muted); }

        .ms-tool-pill {
            position: absolute; top: 0.55rem; right: 0.65rem;
            font: 500 0.62rem var(--ms-font-mono);
            text-transform: uppercase; letter-spacing: 0.08em;
            padding: 0.15rem 0.45rem;
            border-radius: var(--ms-radius-pill);
            background: rgba(79, 70, 229, 0.10);
            color: #4f46e5;
        }
        [data-theme="dark"] .ms-tool-pill { background: rgba(165, 180, 252, 0.12); color: #a5b4fc; }
        .ms-tool-pill.is-soon { background: rgba(120, 113, 108, 0.12); color: var(--ms-muted); }

        /* Sidebar item: "soon" disabled row */
        .ms-item-soon {
            opacity: 0.55;
            cursor: not-allowed;
        }
        .ms-item-soon:hover { background: transparent; color: var(--ms-ink); }
        .ms-item-soon:hover .ms-item-icon { background: var(--ms-accent-soft); color: var(--ms-accent); }
        .ms-item-pill {
            margin-left: auto;
            font: 500 0.6rem var(--ms-font-mono);
            text-transform: uppercase; letter-spacing: 0.08em;
            padding: 0.1rem 0.4rem;
            border-radius: var(--ms-radius-pill);
            background: rgba(120, 113, 108, 0.14);
            color: var(--ms-muted);
        }

        /* "How it works" strip */
        .ml-how {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 0.85rem;
        }
        .ml-how-step {
            padding: 1rem 1.1rem;
            background: var(--ms-panel-bg-soft);
            border: 1px solid var(--ms-line);
            border-radius: var(--ms-radius);
        }
        .ml-how-num {
            display: inline-block;
            font: 400 1.1rem var(--ms-font-serif);
            color: #4f46e5;
            margin-bottom: 0.35rem;
        }
        [data-theme="dark"] .ml-how-num { color: #a5b4fc; }
        .ml-how-title { font: 600 0.9rem var(--ms-font-sans); display: block; margin-bottom: 0.25rem; color: var(--ms-ink); }
        .ml-how-body  { font: 0.82rem/1.5 var(--ms-font-sans); color: var(--ms-muted); }
    </style>
    <%@ include file="../modern/ads/ad-init.jsp" %>
</head>
<body class="ms-body">

<jsp:include page="../modern/components/nav-header.jsp" />

<%-- Decorative physics backdrop — reuse math's matter-bg.jsp verbatim --%>
<jsp:include page="/math/partials/matter-bg.jsp" />

<div class="ms-hero">
    <%@ include file="../modern/ads/ad-hero-banner.jsp" %>
</div>

<main class="ms-main">

    <button type="button" id="msSidebarToggle" class="ms-sidebar-toggle" aria-label="Open ML demos menu">
        &#9776; ML demos
    </button>

    <% request.setAttribute("activeService", "home"); %>
    <jsp:include page="/ml/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <!-- Hero -->
        <div class="ms-hero-banner">
            <h1>Machine learning, <em>visualized</em>.</h1>
            <p>Watch algorithms learn, step by step. Gradient descent rolling, K-means snapping, neural nets bending a decision boundary &mdash; every demo derives the math from first principles and shows the algorithm converging iteration by iteration.</p>
            <div class="ms-hero-stats">
                <div class="ms-hero-stat"><strong>10</strong>algorithms</div>
                <div class="ms-hero-stat"><strong>4</strong>chapters</div>
                <div class="ms-hero-stat"><strong>&infin;</strong>tweaks</div>
            </div>
        </div>

        <!-- Chapter cards (4) -->
        <div class="ms-card">
            <h2 class="ms-section-title">Curriculum <small>four chapters, derived from first principles</small></h2>
            <div class="ml-chapter-grid">
                <a href="#ch1" class="ml-chapter-card">
                    <div class="ml-chapter-eyebrow">Chapter 1</div>
                    <h3 class="ml-chapter-title">Optimization</h3>
                    <p class="ml-chapter-summary">How models learn at all. Gradient descent on a loss landscape, parameter updates iteration by iteration.</p>
                    <div class="ml-chapter-meta"><span>2 demos</span><span>~5 min</span></div>
                </a>
                <a href="#ch2" class="ml-chapter-card">
                    <div class="ml-chapter-eyebrow">Chapter 2</div>
                    <h3 class="ml-chapter-title">Clustering &amp; Reduction</h3>
                    <p class="ml-chapter-summary">Unsupervised structure. K-means centroids snapping into place; PCA collapsing dimensions while preserving variance.</p>
                    <div class="ml-chapter-meta"><span>2 demos</span><span>~6 min</span></div>
                </a>
                <a href="#ch3" class="ml-chapter-card">
                    <div class="ml-chapter-eyebrow">Chapter 3</div>
                    <h3 class="ml-chapter-title">Linear Models</h3>
                    <p class="ml-chapter-summary">The first classifiers. Perceptron flipping its boundary on every misclassified point; logistic regression sliding into a smooth sigmoid.</p>
                    <div class="ml-chapter-meta"><span>3 demos</span><span>~8 min</span></div>
                </a>
                <a href="#ch4" class="ml-chapter-card">
                    <div class="ml-chapter-eyebrow">Chapter 4</div>
                    <h3 class="ml-chapter-title">Neural Networks</h3>
                    <p class="ml-chapter-summary">From perceptron to multi-layer. Watch backprop, weight transformations, and function approximation on a 2D toy problem.</p>
                    <div class="ml-chapter-meta"><span>3 demos</span><span>~12 min</span></div>
                </a>
            </div>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="../modern/ads/ad-in-content-mid.jsp" %>
        </div>

        <!-- Chapter 1 -->
        <div class="ms-card" id="ch1">
            <h2 class="ms-section-title">Ch 1 &middot; Optimization <small>how models actually learn</small></h2>
            <div class="ms-tool-grid">
                <a href="<%=request.getContextPath()%>/ml/gradient-descent.jsp" class="ms-tool-card">
                    <span class="ms-tool-pill">new</span>
                    <span class="ms-tool-card-icon">&#8711;</span>
                    <span><span class="ms-tool-card-title">Gradient Descent</span><span class="ms-tool-card-sub">Watch a parameter roll down the loss surface</span></span>
                </a>
                <a href="<%=request.getContextPath()%>/activation_function_explorer.jsp" class="ms-tool-card">
                    <span class="ms-tool-card-icon">&#963;</span>
                    <span><span class="ms-tool-card-title">Activation Functions</span><span class="ms-tool-card-sub">ReLU, sigmoid, tanh, GELU &mdash; live plots</span></span>
                </a>
            </div>
        </div>

        <!-- Chapter 2 -->
        <div class="ms-card" id="ch2">
            <h2 class="ms-section-title">Ch 2 &middot; Clustering &amp; Reduction <small>finding structure without labels</small></h2>
            <div class="ms-tool-grid">
                <a href="<%=request.getContextPath()%>/ml/k-means.jsp" class="ms-tool-card">
                    <span class="ms-tool-pill">new</span>
                    <span class="ms-tool-card-icon">K</span>
                    <span><span class="ms-tool-card-title">K-Means</span><span class="ms-tool-card-sub">Centroids reassign every iteration</span></span>
                </a>
                <a href="<%=request.getContextPath()%>/ml/pca.jsp" class="ms-tool-card">
                    <span class="ms-tool-pill">new</span>
                    <span class="ms-tool-card-icon">&#955;</span>
                    <span><span class="ms-tool-card-title">PCA</span><span class="ms-tool-card-sub">Principal components, variance preserved</span></span>
                </a>
            </div>
        </div>

        <!-- Chapter 3 -->
        <div class="ms-card" id="ch3">
            <h2 class="ms-section-title">Ch 3 &middot; Linear Models <small>the first classifiers</small></h2>
            <div class="ms-tool-grid">
                <span class="ms-tool-card is-soon" title="Demo in progress">
                    <span class="ms-tool-pill is-soon">soon</span>
                    <span class="ms-tool-card-icon">&#10138;</span>
                    <span><span class="ms-tool-card-title">Perceptron</span><span class="ms-tool-card-sub">Decision boundary flips per mistake</span></span>
                </span>
                <a href="<%=request.getContextPath()%>/Logistic_Regression.jsp" class="ms-tool-card">
                    <span class="ms-tool-pill">existing</span>
                    <span class="ms-tool-card-icon">&sigma;</span>
                    <span><span class="ms-tool-card-title">Logistic Regression</span><span class="ms-tool-card-sub">Coefficients, odds, probabilities</span></span>
                </a>
                <a href="<%=request.getContextPath()%>/ROC_AUC.jsp" class="ms-tool-card">
                    <span class="ms-tool-pill">existing</span>
                    <span class="ms-tool-card-icon">ROC</span>
                    <span><span class="ms-tool-card-title">ROC &amp; AUC</span><span class="ms-tool-card-sub">TPR/FPR sweep + AUC score</span></span>
                </a>
            </div>
        </div>

        <!-- Chapter 4 -->
        <div class="ms-card" id="ch4">
            <h2 class="ms-section-title">Ch 4 &middot; Neural Networks <small>and beyond linear</small></h2>
            <div class="ms-tool-grid">
                <span class="ms-tool-card is-soon" title="Demo in progress">
                    <span class="ms-tool-pill is-soon">soon</span>
                    <span class="ms-tool-card-icon">NN</span>
                    <span><span class="ms-tool-card-title">Train an MLP</span><span class="ms-tool-card-sub">Backprop on a 2D classification toy</span></span>
                </span>
                <span class="ms-tool-card is-soon" title="Demo in progress">
                    <span class="ms-tool-pill is-soon">soon</span>
                    <span class="ms-tool-card-icon">W</span>
                    <span><span class="ms-tool-card-title">Weight Visualization</span><span class="ms-tool-card-sub">Per-layer weights over training</span></span>
                </span>
                <a href="<%=request.getContextPath()%>/ml/nn-viz.jsp" class="ms-tool-card">
                    <span class="ms-tool-pill">existing</span>
                    <span class="ms-tool-card-icon">&#9678;</span>
                    <span><span class="ms-tool-card-title">NN Architecture Viz</span><span class="ms-tool-card-sub">FCNN / LeNet / AlexNet, SVG export</span></span>
                </a>
            </div>
        </div>

        <!-- How it works -->
        <div class="ms-card">
            <h2 class="ms-section-title">How to learn here</h2>
            <div class="ml-how">
                <div class="ml-how-step">
                    <span class="ml-how-num">&#x2460;</span>
                    <span class="ml-how-title">From first principles</span>
                    <span class="ml-how-body">Each algorithm is derived step by step, then implemented in plain <code>numpy</code> &mdash; not hidden behind a one-line library call.</span>
                </div>
                <div class="ml-how-step">
                    <span class="ml-how-num">&#x2461;</span>
                    <span class="ml-how-title">Watch it converge</span>
                    <span class="ml-how-body">Every iteration re-renders. Pause, step, rewind. The marker, the centroids, the decision boundary all update live.</span>
                </div>
                <div class="ml-how-step">
                    <span class="ml-how-num">&#x2462;</span>
                    <span class="ml-how-title">Build intuition</span>
                    <span class="ml-how-body">Drag a learning rate, click a starting point, edit the loss. Re-run instantly and feel the algorithm respond to your choices.</span>
                </div>
                <div class="ml-how-step">
                    <span class="ml-how-num">&#x2463;</span>
                    <span class="ml-how-title">Math + code, side by side</span>
                    <span class="ml-how-body">The derivation, the source, and the animation on one page. Read the math, then watch it execute on your data.</span>
                </div>
            </div>
        </div>

        <!-- FAQ -->
        <section class="ms-faq-wrap" style="max-width:100%;margin-top:0;padding:0;">
            <h2 class="ms-faq-title" id="faqs">Frequently asked</h2>
            <div class="ms-faq" aria-label="ML demos FAQ">
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        Where should I start if I&rsquo;m new to ML?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">Begin with <strong>Chapter 1: Gradient Descent</strong>. Every other algorithm on this site uses gradient descent (or a relative) to actually learn its parameters, so the intuition you build there carries everywhere. Then walk the chapters in order &mdash; clustering, linear models, neural networks.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        Do I need to install anything?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">No. Every demo runs entirely in your browser tab &mdash; no install, no Jupyter, no Colab, no signup. Open a page, click <strong>Run</strong>, watch the algorithm train.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        Can I edit the algorithm?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">Yes. Every demo page shows the underlying algorithm in an editable panel. Change a learning rate, a kernel, an init seed, or rewrite the loop entirely &mdash; hit <strong>Run</strong> and watch the visualization update with your version.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        Why &ldquo;from first principles&rdquo;?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">The demos implement each algorithm with plain <code>numpy</code> (loops, matrix ops, gradient computations) rather than calling a one-line <code>sklearn.fit</code>. The goal is to see the math actually executing &mdash; every iteration of gradient descent, every centroid reassignment, every weight update &mdash; so you build intuition for what the library calls are hiding.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        How is this different from ml-visualized.com?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">The curriculum structure is inspired by <strong>ml-visualized.com</strong> (four chapters: optimization, clustering, linear models, neural networks), but the interactivity is different. ml-visualized embeds pre-rendered animations; here you can pause, edit the algorithm, drag the starting point, and re-run on your own settings.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        What&rsquo;s the difference between these demos and the existing ML tools?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">The existing tools (<strong>NN Architecture Visualizer</strong>, <strong>Activation Function Explorer</strong>, <strong>Logistic Regression Calculator</strong>, <strong>ROC/AUC</strong>, <strong>ML Pipeline</strong>) are utility pages that compute a result or render a diagram. The chapter demos are <strong>training visualizations</strong> &mdash; you watch the algorithm iterate and converge, with editable source so you can experiment.</div>
                </div>
            </div>
        </section>

    </section>

    <aside class="ms-rail" aria-label="Advertisements">
        <%@ include file="../modern/ads/ad-ide-rail-top.jsp" %>
        <%@ include file="../modern/ads/ad-ide-rail-bottom.jsp" %>
    </aside>

</main>

<%@ include file="../modern/ads/ad-sticky-footer.jsp" %>
<%@ include file="../modern/components/analytics.jsp" %>

<script>
    document.querySelectorAll('.ms-faq-q').forEach(function (q) {
        q.addEventListener('click', function () {
            q.closest('.ms-faq-item').classList.toggle('open');
        });
    });
</script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
</body>
</html>
