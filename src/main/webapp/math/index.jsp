<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="AI Math Solver with Steps — Type or Scan a Photo, Free" />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolDescription" value="Free AI math solver with step-by-step answers — type a problem or scan a photo. Algebra, calculus, statistics, matrices and trig, plus 48 calculators and AMC/AIME/JEE exam prep. Runs in your browser." />
        <jsp:param name="toolUrl" value="math/" />
        <jsp:param name="toolKeywords" value="ai math solver, math solver with steps, step by step math solver, solve math by taking a photo, scan math problem, math problem solver, math word problem solver, math homework helper, free math solver no signup, online math calculator, integral calculator, derivative calculator, matrix calculator, quadratic solver, statistics calculator, trigonometry solver, algebra solver, calculus solver, AMC mock test, AIME practice, math olympiad practice, USAMO IMO RMO INMO Putnam, JEE mains mock" />
        <jsp:param name="toolImage" value="math-ai-solver-og.png" />
        <jsp:param name="toolFeatures" value="AI step-by-step math solver,Solve by typing or scanning a photo,Answers verified by a symbolic engine,48 free calculators across every topic,Algebra calculus statistics matrices and trig,AMC AIME Olympiad and JEE exam prep,KaTeX formulas and shareable results,No signup for the calculators" />
        <jsp:param name="teaches" value="arithmetic, algebra, quadratic equations, systems of equations, inequalities, polynomials, calculus, derivatives, integrals, limits, Taylor series, linear algebra, matrices, determinants, eigenvalues, vectors, trigonometry, statistics, probability, word problems, proofs" />
        <jsp:param name="educationalLevel" value="Middle School, High School, AP, Undergraduate, Competition Math" />
        <jsp:param name="faq1q" value="Can I solve a math problem by taking a photo?" />
        <jsp:param name="faq1a" value="Yes. Sign in, open the Math AI, and upload or snap a photo of a typed or handwritten problem. It reads the problem, shows the setup, and solves it step by step — algebra, calculus, statistics, matrices, and more." />
        <jsp:param name="faq2q" value="Is there a free step-by-step math solver?" />
        <jsp:param name="faq2a" value="Yes. Type any problem into the Math AI and it works through the solution step by step. The 48 on-page calculators are free with no signup; the AI chat and photo scan just need a free sign-in." />
        <jsp:param name="faq3q" value="What kind of math can it solve?" />
        <jsp:param name="faq3a" value="Algebra (quadratics, systems, inequalities, polynomials), calculus (derivatives, integrals, limits, Taylor series), linear algebra (matrices, determinants, eigenvalues, vectors), trigonometry, statistics, and everyday math. It also explains proofs and word problems in plain language." />
        <jsp:param name="faq4q" value="Are the answers correct, and does it show the work?" />
        <jsp:param name="faq4a" value="Computed answers come from a symbolic math engine, not a guess, and every step is shown with KaTeX formulas. For problems that cannot be computed symbolically, such as a proof, the AI reasons it out and clearly labels the result as AI-reasoned rather than machine-verified." />
        <jsp:param name="faq5q" value="Do I need to sign up or install anything?" />
        <jsp:param name="faq5a" value="Nothing to install — it runs in your browser. The calculators are free with no account. The AI solver and photo scan need a free sign-in (no Pro required)." />
        <jsp:param name="faq6q" value="Can I practice for math exams?" />
        <jsp:param name="faq6a" value="Yes. There are timed AMC 10/12 and AIME mock tests, JEE Mains 2025 mocks with official scoring, and untimed Olympiad practice (USAMO, IMO, RMO, INMO, Putnam) with step-by-step solutions." />
    </jsp:include>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="ctx" content="<%=request.getContextPath()%>" />

    <!-- CollectionPage + ItemList Schema — ported verbatim from the legacy
         math/index.jsp so Google's "48 items" rich-card stays intact. If
         tools are added/removed, sync BOTH the sidebar partial AND this
         block. -->
    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "CollectionPage",
            "name": "AI Math Solver & Calculators",
            "description": "AI math solver with step-by-step answers — type a problem or scan a photo — covering algebra, calculus, statistics, linear algebra, and trigonometry, plus 48 free calculators and AMC/AIME/JEE/Olympiad exam prep.",
            "url": "https://8gwifi.org/math/",
            "mainEntity": {
                "@type": "ItemList",
                "numberOfItems": 52,
                "itemListElement": [
                    {"@type": "ListItem", "position": 1, "name": "Percentage Calculator", "url": "https://8gwifi.org/percentage-calculator.jsp"},
                    {"@type": "ListItem", "position": 2, "name": "Exponent Calculator", "url": "https://8gwifi.org/exponent-calculator.jsp"},
                    {"@type": "ListItem", "position": 3, "name": "Logarithm Calculator", "url": "https://8gwifi.org/logarithm-calculator.jsp"},
                    {"@type": "ListItem", "position": 4, "name": "Significant Figures Calculator", "url": "https://8gwifi.org/significant-figures-calculator.jsp"},
                    {"@type": "ListItem", "position": 5, "name": "Quadratic Equation Solver", "url": "https://8gwifi.org/quadratic-solver.jsp"},
                    {"@type": "ListItem", "position": 6, "name": "System of Equations Solver", "url": "https://8gwifi.org/linear-equations-solver.jsp"},
                    {"@type": "ListItem", "position": 7, "name": "Systems of Equations Solver — Step-by-Step", "url": "https://8gwifi.org/system-equations-solver.jsp"},
                    {"@type": "ListItem", "position": 8, "name": "Inequality Solver", "url": "https://8gwifi.org/inequality-solver.jsp"},
                    {"@type": "ListItem", "position": 9, "name": "24 Game Solver", "url": "https://8gwifi.org/24-game-solver.jsp"},
                    {"@type": "ListItem", "position": 10, "name": "Taylor & Maclaurin Series Calculator", "url": "https://8gwifi.org/series-calculator.jsp"},
                    {"@type": "ListItem", "position": 11, "name": "Derivative Calculator", "url": "https://8gwifi.org/derivative-calculator.jsp"},
                    {"@type": "ListItem", "position": 12, "name": "Integral Calculator", "url": "https://8gwifi.org/integral-calculator.jsp"},
                    {"@type": "ListItem", "position": 13, "name": "Limit Calculator", "url": "https://8gwifi.org/limit-calculator.jsp"},
                    {"@type": "ListItem", "position": 14, "name": "Matrix Determinant Calculator", "url": "https://8gwifi.org/matrix-determinant-calculator.jsp"},
                    {"@type": "ListItem", "position": 15, "name": "Matrix Multiplication Calculator", "url": "https://8gwifi.org/matrix-multiplication-calculator.jsp"},
                    {"@type": "ListItem", "position": 16, "name": "Matrix Inverse Calculator", "url": "https://8gwifi.org/matrix-inverse-calculator.jsp"},
                    {"@type": "ListItem", "position": 17, "name": "Matrix Eigenvalue Calculator", "url": "https://8gwifi.org/matrix-eigenvalue-calculator.jsp"},
                    {"@type": "ListItem", "position": 18, "name": "Matrix Rank Calculator", "url": "https://8gwifi.org/matrix-rank-calculator.jsp"},
                    {"@type": "ListItem", "position": 19, "name": "Matrix Addition Calculator", "url": "https://8gwifi.org/matrix-addition-calculator.jsp"},
                    {"@type": "ListItem", "position": 20, "name": "Matrix Power Calculator", "url": "https://8gwifi.org/matrix-power-calculator.jsp"},
                    {"@type": "ListItem", "position": 21, "name": "Matrix Transpose Calculator", "url": "https://8gwifi.org/matrix-transpose-calculator.jsp"},
                    {"@type": "ListItem", "position": 22, "name": "Matrix Type Classifier", "url": "https://8gwifi.org/matrix-type-classifier.jsp"},
                    {"@type": "ListItem", "position": 23, "name": "Polynomial Calculator", "url": "https://8gwifi.org/polynomial-calculator.jsp"},
                    {"@type": "ListItem", "position": 24, "name": "Vector Calculator", "url": "https://8gwifi.org/vector-calculator.jsp"},
                    {"@type": "ListItem", "position": 25, "name": "Trig Function Calculator", "url": "https://8gwifi.org/trigonometric-function-calculator.jsp"},
                    {"@type": "ListItem", "position": 26, "name": "Trig Identity Calculator", "url": "https://8gwifi.org/trigonometric-identity-calculator.jsp"},
                    {"@type": "ListItem", "position": 27, "name": "Trig Equation Solver", "url": "https://8gwifi.org/trigonometric-equation-solver.jsp"},
                    {"@type": "ListItem", "position": 28, "name": "Summary Statistics Calculator", "url": "https://8gwifi.org/summary-statistics-calculator.jsp"},
                    {"@type": "ListItem", "position": 29, "name": "Standard Deviation Calculator", "url": "https://8gwifi.org/standard-deviation.jsp"},
                    {"@type": "ListItem", "position": 30, "name": "Mean Median Mode Calculator", "url": "https://8gwifi.org/mean-median-mode.jsp"},
                    {"@type": "ListItem", "position": 31, "name": "Variance Calculator", "url": "https://8gwifi.org/variance-calculator.jsp"},
                    {"@type": "ListItem", "position": 32, "name": "Percentile Calculator", "url": "https://8gwifi.org/percentile-calculator.jsp"},
                    {"@type": "ListItem", "position": 33, "name": "Z-Score Calculator", "url": "https://8gwifi.org/z-score-calculator.jsp"},
                    {"@type": "ListItem", "position": 34, "name": "Normal Distribution Calculator", "url": "https://8gwifi.org/normal-distribution-calculator.jsp"},
                    {"@type": "ListItem", "position": 35, "name": "Binomial Distribution Calculator", "url": "https://8gwifi.org/binomial-distribution-calculator.jsp"},
                    {"@type": "ListItem", "position": 36, "name": "Probability Calculator", "url": "https://8gwifi.org/probability-calculator.jsp"},
                    {"@type": "ListItem", "position": 37, "name": "Confidence Interval Calculator", "url": "https://8gwifi.org/confidence-interval-calculator.jsp"},
                    {"@type": "ListItem", "position": 38, "name": "Hypothesis Test Calculator", "url": "https://8gwifi.org/hypothesis-test-calculator.jsp"},
                    {"@type": "ListItem", "position": 39, "name": "T-Test Calculator", "url": "https://8gwifi.org/t-test-calculator.jsp"},
                    {"@type": "ListItem", "position": 40, "name": "Chi-Square Calculator", "url": "https://8gwifi.org/chi-square-calculator.jsp"},
                    {"@type": "ListItem", "position": 41, "name": "ANOVA Calculator", "url": "https://8gwifi.org/anova-calculator.jsp"},
                    {"@type": "ListItem", "position": 42, "name": "Correlation Calculator", "url": "https://8gwifi.org/correlation-calculator.jsp"},
                    {"@type": "ListItem", "position": 43, "name": "Linear Regression Calculator", "url": "https://8gwifi.org/linear-regression-calculator.jsp"},
                    {"@type": "ListItem", "position": 44, "name": "Sample Size Calculator", "url": "https://8gwifi.org/sample-size-calculator.jsp"},
                    {"@type": "ListItem", "position": 45, "name": "Effect Size Calculator", "url": "https://8gwifi.org/effect-size-calculator.jsp"},
                    {"@type": "ListItem", "position": 46, "name": "Standard Error Calculator", "url": "https://8gwifi.org/standard-error-calculator.jsp"},
                    {"@type": "ListItem", "position": 47, "name": "Outlier Detection Calculator", "url": "https://8gwifi.org/outlier-detection-calculator.jsp"},
                    {"@type": "ListItem", "position": 48, "name": "P-Value Calculator", "url": "https://8gwifi.org/p-value-calculator.jsp"},
                    {"@type": "ListItem", "position": 49, "name": "Graphing Calculator", "url": "https://8gwifi.org/graphing-calculator.jsp"},
                    {"@type": "ListItem", "position": 50, "name": "AMC 10/12 Mock Test", "url": "https://8gwifi.org/math/amc/"},
                    {"@type": "ListItem", "position": 51, "name": "AIME Mock Test", "url": "https://8gwifi.org/math/amc/aime.jsp"},
                    {"@type": "ListItem", "position": 52, "name": "Olympiad Math Practice", "url": "https://8gwifi.org/math/olympiad/"},
                    {"@type": "ListItem", "position": 53, "name": "Quick Math Drills", "url": "https://8gwifi.org/math/quick-math/"},
                    {"@type": "ListItem", "position": 54, "name": "Math Memory Games", "url": "https://8gwifi.org/math/math-memory/"}
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
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css?v=<%=v%>">

    <% request.setAttribute("aiToolId", "math-ai-hub"); %>
    <% request.setAttribute("aiRequireSignIn", "true"); %>
    <%@ include file="../modern/components/ai-assistant-vars.inc.jsp" %>
    <%@ include file="../modern/components/math-ai-head.inc.jsp" %>

    <style>
        /* Index-specific: hero banner + featured-tool cards.
           All tokens come from math-studio.css; no duplication. */
        .ms-hero-banner {
            position: relative; overflow: hidden;
            background:
                    radial-gradient(circle at 10% 0%, rgba(21, 128, 61, 0.18), transparent 45%),
                    radial-gradient(circle at 90% 100%, rgba(79, 70, 229, 0.12), transparent 50%),
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
        .ms-hero-banner h1 em { font-style: italic; color: var(--ms-accent); }
        .ms-hero-banner p { font: 1.02rem var(--ms-font-sans); color: var(--ms-ink-soft); margin: 0 0 1.5rem; max-width: 56ch; }
        .ms-hero-stats { display: flex; gap: 2.25rem; flex-wrap: wrap; }
        .ms-hero-stat { font: 500 0.82rem var(--ms-font-sans); color: var(--ms-muted); }
        .ms-hero-stat strong {
            display: block;
            font: 400 1.65rem var(--ms-font-serif);
            color: var(--ms-ink);
            margin-bottom: 2px;
            letter-spacing: -0.015em;
        }

        .ms-section-title {
            font: 500 1.25rem var(--ms-font-serif);
            color: var(--ms-ink);
            margin: 0 0 1rem;
            letter-spacing: -0.015em;
        }

        .ms-tool-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
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
            font: 1.1rem var(--ms-font-serif);
            background: var(--ms-accent-soft);
            color: var(--ms-accent);
        }
        .ms-tool-card:hover .ms-tool-card-icon {
            background: var(--ms-accent); color: #fff;
        }
        .ms-tool-card-title { font: 600 0.95rem var(--ms-font-sans); display: block; margin-bottom: 2px; }
        .ms-tool-card-sub { font: 0.8rem var(--ms-font-sans); color: var(--ms-muted); }

        /* Math Studio shell around embedded VCA Math AI (same UI as calculator ✨ AI) */
        .ms-ai-shell {
            padding: 0;
            overflow: hidden;
            min-height: min(78vh, 820px);
        }
        .ms-ai-embed {
            min-height: min(78vh, 820px);
        }

        /* .ms-faq-* styles now live in math-studio.css (shared with tool pages) */
    </style>
    <%@ include file="../modern/ads/ad-init.jsp" %>
</head>
<body class="ms-body">

<jsp:include page="../modern/components/nav-header.jsp" />

<!-- Decorative physics backdrop (shared across all math pages) -->
<jsp:include page="/math/partials/matter-bg.jsp" />

<!-- Hero banner ad -->
<div class="ms-hero">
    <%@ include file="../modern/ads/ad-hero-banner.jsp" %>
</div>

<main class="ms-main">

    <!-- Mobile drawer toggle -->
    <button type="button" id="msSidebarToggle" class="ms-sidebar-toggle" aria-label="Open math tools menu">
        &#9776; Math tools
    </button>

    <% request.setAttribute("activeService", "home"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <!-- Math AI — same chat UI as calculator pages (VCA), embedded in Math Studio shell -->
        <div class="ms-card ms-ai-shell" id="mathAiHub">
            <div id="mathAiEmbed" class="ms-ai-embed" aria-label="Math AI chat"></div>
        </div>

        <!-- Hero -->
        <div class="ms-hero-banner">
            <h1>AI Math Solver &mdash; <em>step by step</em></h1>
            <p>Type a problem or <strong>snap a photo</strong> and get a worked, step-by-step solution &mdash; algebra, calculus, statistics, matrices, trig. Plus 48 free calculators and AMC / AIME / JEE exam prep.</p>
            <div class="ms-hero-stats">
                <div class="ms-hero-stat"><strong>AI</strong>step-by-step solver</div>
                <div class="ms-hero-stat"><strong>photo</strong>scan &amp; solve</div>
                <div class="ms-hero-stat"><strong>48</strong>free calculators</div>
            </div>
        </div>

        <!-- Featured tools -->
        <div class="ms-card">
            <h2 class="ms-section-title">Featured</h2>
            <div class="ms-tool-grid">
                <a href="<%=request.getContextPath()%>/integral-calculator.jsp" class="ms-tool-card">
                    <span class="ms-tool-card-icon">&#8747;</span>
                    <span><span class="ms-tool-card-title">Integral Calculator</span><span class="ms-tool-card-sub">Definite, indefinite, by parts</span></span>
                </a>
                <a href="<%=request.getContextPath()%>/derivative-calculator.jsp" class="ms-tool-card">
                    <span class="ms-tool-card-icon">d/dx</span>
                    <span><span class="ms-tool-card-title">Derivative</span><span class="ms-tool-card-sub">Power, product, chain rules</span></span>
                </a>
                <a href="<%=request.getContextPath()%>/quadratic-solver.jsp" class="ms-tool-card">
                    <span class="ms-tool-card-icon">x&#178;</span>
                    <span><span class="ms-tool-card-title">Quadratic Solver</span><span class="ms-tool-card-sub">Formula, factoring, completing</span></span>
                </a>
                <a href="<%=request.getContextPath()%>/matrix-determinant-calculator.jsp" class="ms-tool-card">
                    <span class="ms-tool-card-icon">|A|</span>
                    <span><span class="ms-tool-card-title">Determinant</span><span class="ms-tool-card-sub">Cofactor + row reduction</span></span>
                </a>
                <a href="<%=request.getContextPath()%>/standard-deviation.jsp" class="ms-tool-card">
                    <span class="ms-tool-card-icon">&#963;</span>
                    <span><span class="ms-tool-card-title">Standard Deviation</span><span class="ms-tool-card-sub">Sample &amp; population</span></span>
                </a>
                <a href="<%=request.getContextPath()%>/percentage-calculator.jsp" class="ms-tool-card">
                    <span class="ms-tool-card-icon">%</span>
                    <span><span class="ms-tool-card-title">Percentage</span><span class="ms-tool-card-sub">8 modes, discount, tax</span></span>
                </a>
                <a href="<%=request.getContextPath()%>/graphing-calculator.jsp" class="ms-tool-card">
                    <span class="ms-tool-card-icon">&#8962;</span>
                    <span><span class="ms-tool-card-title">Graphing Calculator</span><span class="ms-tool-card-sub">Plot f(x), roots, extrema</span></span>
                </a>
                <a href="<%=request.getContextPath()%>/math/dashboard.jsp" class="ms-tool-card">
                    <span class="ms-tool-card-icon">&#x2211;</span>
                    <span><span class="ms-tool-card-title">Math Editor</span><span class="ms-tool-card-sub">WYSIWYG + live compute</span></span>
                </a>
            </div>
        </div>

        <!-- Exam-prep row — three landing pages for timed mocks + untimed
             olympiad practice. Kept above-the-fold so users searching
             "free AMC mock" or "olympiad math problems with solutions"
             land here and convert. -->
        <div class="ms-card">
            <h2 class="ms-section-title">Exam Prep</h2>
            <p style="color:var(--ms-muted); margin:0 0 0.85rem; font-size:0.9rem;">
                Timed mock tests and untimed olympiad practice with
                step-by-step solutions.
            </p>
            <div class="ms-tool-grid">
                <a href="<%=request.getContextPath()%>/math/amc/" class="ms-tool-card">
                    <span class="ms-tool-card-icon">AMC</span>
                    <span><span class="ms-tool-card-title">AMC 10 / 12 Mock</span><span class="ms-tool-card-sub">25 MCQ · 75 min · official scoring</span></span>
                </a>
                <a href="<%=request.getContextPath()%>/math/amc/aime.jsp" class="ms-tool-card">
                    <span class="ms-tool-card-icon">AIME</span>
                    <span><span class="ms-tool-card-title">AIME Mock</span><span class="ms-tool-card-sub">15 problems · 3 hr · integer 0–999</span></span>
                </a>
                <a href="<%=request.getContextPath()%>/math/olympiad/" class="ms-tool-card">
                    <span class="ms-tool-card-icon">&#9733;</span>
                    <span><span class="ms-tool-card-title">Olympiad Practice</span><span class="ms-tool-card-sub">USAMO · IMO · RMO · INMO · Putnam</span></span>
                </a>
                <a href="<%=request.getContextPath()%>/math/iit/" class="ms-tool-card">
                    <span class="ms-tool-card-icon">JEE</span>
                    <span><span class="ms-tool-card-title">JEE Mains 2025 Mock</span><span class="ms-tool-card-sub">All 10 shifts · official +4 / −1 scoring</span></span>
                </a>
                <a href="<%=request.getContextPath()%>/math/iit/practice.jsp" class="ms-tool-card">
                    <span class="ms-tool-card-icon">&#128214;</span>
                    <span><span class="ms-tool-card-title">JEE Practice</span><span class="ms-tool-card-sub">Untimed · stepwise solutions</span></span>
                </a>
                <a href="<%=request.getContextPath()%>/math/quick-math/" class="ms-tool-card">
                    <span class="ms-tool-card-icon">&#9889;</span>
                    <span><span class="ms-tool-card-title">Quick Math Drills</span><span class="ms-tool-card-sub">Mental-math speed drills · 30+ topics</span></span>
                </a>
                <a href="<%=request.getContextPath()%>/math/math-memory/" class="ms-tool-card">
                    <span class="ms-tool-card-icon">&#129504;</span>
                    <span><span class="ms-tool-card-title">Math Memory</span><span class="ms-tool-card-sub">16 brain-training memory games</span></span>
                </a>
            </div>
        </div>

        <!-- In-content ad (mobile/tablet only; hidden on desktop where rail shows) -->
        <div class="ms-inline-ad">
            <%@ include file="../modern/ads/ad-in-content-mid.jsp" %>
        </div>

        <!-- Quick category summary -->
        <div class="ms-card">
            <h2 class="ms-section-title">Browse by Category</h2>
            <p style="color:var(--ms-muted); margin:0 0 0.85rem; font-size:0.9rem;">
                Every calculator is one click away in the left sidebar. Quick jumps:
            </p>
            <div class="ms-tool-grid">
                <a href="#" onclick="document.querySelector('.ms-group[data-group=&quot;everyday&quot;] .ms-group-header').click();document.querySelector('.ms-group[data-group=&quot;everyday&quot;]').scrollIntoView({block:'center'});return false" class="ms-tool-card">
                    <span class="ms-tool-card-icon">&#128176;</span>
                    <span><span class="ms-tool-card-title">Everyday</span><span class="ms-tool-card-sub">5 tools</span></span>
                </a>
                <a href="#" onclick="document.querySelector('.ms-group[data-group=&quot;algebra&quot;] .ms-group-header').click();document.querySelector('.ms-group[data-group=&quot;algebra&quot;]').scrollIntoView({block:'center'});return false" class="ms-tool-card">
                    <span class="ms-tool-card-icon">&#916;</span>
                    <span><span class="ms-tool-card-title">Algebra</span><span class="ms-tool-card-sub">5 tools</span></span>
                </a>
                <a href="#" onclick="document.querySelector('.ms-group[data-group=&quot;calculus&quot;] .ms-group-header').click();document.querySelector('.ms-group[data-group=&quot;calculus&quot;]').scrollIntoView({block:'center'});return false" class="ms-tool-card">
                    <span class="ms-tool-card-icon">&#8747;</span>
                    <span><span class="ms-tool-card-title">Calculus</span><span class="ms-tool-card-sub">5 tools</span></span>
                </a>
                <a href="#" onclick="document.querySelector('.ms-group[data-group=&quot;linear-algebra&quot;] .ms-group-header').click();document.querySelector('.ms-group[data-group=&quot;linear-algebra&quot;]').scrollIntoView({block:'center'});return false" class="ms-tool-card">
                    <span class="ms-tool-card-icon">&#119924;</span>
                    <span><span class="ms-tool-card-title">Linear Algebra</span><span class="ms-tool-card-sub">10 tools</span></span>
                </a>
                <a href="#" onclick="document.querySelector('.ms-group[data-group=&quot;statistics&quot;] .ms-group-header').click();document.querySelector('.ms-group[data-group=&quot;statistics&quot;]').scrollIntoView({block:'center'});return false" class="ms-tool-card">
                    <span class="ms-tool-card-icon">&#128202;</span>
                    <span><span class="ms-tool-card-title">Statistics</span><span class="ms-tool-card-sub">21 tools</span></span>
                </a>
                <a href="#" onclick="document.querySelector('.ms-group[data-group=&quot;trig&quot;] .ms-group-header').click();document.querySelector('.ms-group[data-group=&quot;trig&quot;]').scrollIntoView({block:'center'});return false" class="ms-tool-card">
                    <span class="ms-tool-card-icon">sin</span>
                    <span><span class="ms-tool-card-title">Trigonometry</span><span class="ms-tool-card-sub">3 tools</span></span>
                </a>
                <a href="#" onclick="document.querySelector('.ms-group[data-group=&quot;exams&quot;] .ms-group-header').click();document.querySelector('.ms-group[data-group=&quot;exams&quot;]').scrollIntoView({block:'center'});return false" class="ms-tool-card">
                    <span class="ms-tool-card-icon">&#127942;</span>
                    <span><span class="ms-tool-card-title">Exam Prep</span><span class="ms-tool-card-sub">AMC · AIME · Olympiad</span></span>
                </a>
            </div>
        </div>

        <!-- Visible FAQ — keep in sync with faqNq/faqNa jsp:params above.
             Rendered markup reinforces the schema signal. -->
        <section class="ms-faq-wrap" style="max-width:100%;margin-top:0;padding:0;">
            <h2 class="ms-faq-title" id="faqs">Frequently asked</h2>
            <div class="ms-faq" aria-label="Math AI solver FAQ">
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        Can I solve a math problem by taking a photo?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">Yes. Sign in, open the <strong>Math AI</strong>, and upload or snap a photo of a typed or handwritten problem. It reads the problem, shows the setup, and solves it <strong>step by step</strong> &mdash; algebra, calculus, statistics, matrices, and more.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        Is there a free step-by-step math solver?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">Yes. Type any problem into the <strong>Math AI</strong> and it works through the solution step by step. The 48 on-page calculators are <strong>free with no signup</strong>; the AI chat and photo scan just need a free sign-in.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        What kind of math can it solve?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a"><strong>Algebra</strong> (quadratics, systems, inequalities, polynomials), <strong>calculus</strong> (derivatives, integrals, limits, Taylor series), <strong>linear algebra</strong> (matrices, determinants, eigenvalues, vectors), <strong>trigonometry</strong>, <strong>statistics</strong>, and everyday math. It also explains <strong>proofs and word problems</strong> in plain language.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        Are the answers correct, and does it show the work?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">Computed answers come from a <strong>symbolic math engine</strong> &mdash; not a guess &mdash; and every step is shown with KaTeX formulas. For problems that can't be computed symbolically, such as a proof, the AI reasons it out and clearly labels the result as <em>AI-reasoned</em> rather than machine-verified.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        Do I need to sign up or install anything?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">Nothing to install &mdash; it runs in your browser. The <strong>calculators are free with no account</strong>. The AI solver and photo scan need a free sign-in (no Pro required).</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        Can I practice for math exams?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">Yes. Timed <a href="<%=request.getContextPath()%>/math/amc/">AMC&nbsp;10/12</a> and <a href="<%=request.getContextPath()%>/math/amc/aime.jsp">AIME</a> mock tests, <a href="<%=request.getContextPath()%>/math/iit/">JEE Mains 2025</a> mocks with official scoring, and untimed <a href="<%=request.getContextPath()%>/math/olympiad/">Olympiad practice</a> (USAMO, IMO, RMO, INMO, Putnam) with step-by-step solutions.</div>
                </div>
            </div>
        </section>

    </section>

    <!-- Right ad rail (desktop ≥1280px only) -->
    <aside class="ms-rail" aria-label="Advertisements">
        <%@ include file="../modern/ads/ad-ide-rail-top.jsp" %>
        <%@ include file="../modern/ads/ad-ide-rail-bottom.jsp" %>
    </aside>

</main>

<%@ include file="../modern/ads/ad-sticky-footer.jsp" %>
<%@ include file="../modern/components/analytics.jsp" %>

<script>
    // FAQ toggle
    document.querySelectorAll('.ms-faq-q').forEach(function (q) {
        q.addEventListener('click', function () {
            q.closest('.ms-faq-item').classList.toggle('open');
        });
    });
</script>
<%-- dark-mode.js is loaded by math-libs.jsp via the engine boot below (avoid double-load: redeclares DarkMode) --%>
<%@ include file="../modern/components/math-tool-engine-boot.inc.jsp" %>
<%
    request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
    request.setAttribute("mathAiProfileExport", "configureMathHubShell");
    request.setAttribute("mathAiEmbedMountId", "mathAiEmbed");
    request.setAttribute("aiImageUpload", "true");   // enable image scan on the math hub
%>
<%@ include file="../modern/components/math-ai-embedded-boot.inc.jsp" %>
</body>
</html>
