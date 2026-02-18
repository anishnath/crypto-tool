<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String cacheVersion = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Math Calculators - Free Online Step-by-Step Solvers" />
        <jsp:param name="toolCategory" value="Mathematics" />
        <jsp:param name="toolDescription" value="22 free math calculators with step-by-step solutions. Percentage, exponents, quadratic equations, logarithms, matrices, calculus, series, and more. All free, no signup." />
        <jsp:param name="toolUrl" value="math/" />
        <jsp:param name="toolKeywords" value="math calculator, online math tools, percentage calculator, exponent calculator, quadratic solver, matrix calculator, integral calculator, derivative calculator, logarithm calculator, series calculator, limit calculator, inequality solver, step by step math, free math solver" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="22 math calculators,Step-by-step KaTeX solutions,Python compiler integration,LaTeX export,Shareable URLs,Dark mode support,Mobile responsive,100% free" />
        <jsp:param name="teaches" value="Arithmetic, algebra, calculus, linear algebra, matrix operations, series and sequences, logarithms, exponents, percentages" />
        <jsp:param name="educationalLevel" value="Middle School, High School, Undergraduate" />
        <jsp:param name="faq1q" value="Are these math calculators free?" />
        <jsp:param name="faq1a" value="Yes all 22 math calculators are completely free with no registration required. Every tool shows step-by-step solutions with KaTeX-rendered formulas and includes a Python compiler for verification." />
        <jsp:param name="faq2q" value="Do the calculators show step-by-step solutions?" />
        <jsp:param name="faq2a" value="Yes every calculator renders detailed step-by-step solutions using KaTeX math notation. Each step explains the formula applied and shows the intermediate calculation so you learn the method not just the answer." />
        <jsp:param name="faq3q" value="What math topics are covered?" />
        <jsp:param name="faq3a" value="We cover everyday math like percentages and significant figures, algebra including quadratic equations linear systems and inequalities, calculus with derivatives integrals and limits, linear algebra with 8 matrix calculators, and more including logarithms exponents and Taylor series." />
    </jsp:include>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- CollectionPage + ItemList Schema -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "CollectionPage",
      "name": "Math Calculators",
      "description": "22 free math calculators with step-by-step solutions covering percentages, algebra, calculus, linear algebra, and more.",
      "url": "https://8gwifi.org/math/",
      "mainEntity": {
        "@type": "ItemList",
        "numberOfItems": 22,
        "itemListElement": [
          {"@type": "ListItem", "position": 1, "name": "Percentage Calculator", "url": "https://8gwifi.org/percentage-calculator.jsp"},
          {"@type": "ListItem", "position": 2, "name": "Exponent Calculator", "url": "https://8gwifi.org/exponent-calculator.jsp"},
          {"@type": "ListItem", "position": 3, "name": "Logarithm Calculator", "url": "https://8gwifi.org/logarithm-calculator.jsp"},
          {"@type": "ListItem", "position": 4, "name": "Significant Figures Calculator", "url": "https://8gwifi.org/significant-figures-calculator.jsp"},
          {"@type": "ListItem", "position": 5, "name": "Quadratic Equation Solver", "url": "https://8gwifi.org/quadratic-solver.jsp"},
          {"@type": "ListItem", "position": 6, "name": "System of Equations Solver", "url": "https://8gwifi.org/linear-equations-solver.jsp"},
          {"@type": "ListItem", "position": 7, "name": "Inequality Solver", "url": "https://8gwifi.org/inequality-solver.jsp"},
          {"@type": "ListItem", "position": 8, "name": "24 Game Solver", "url": "https://8gwifi.org/24-game-solver.jsp"},
          {"@type": "ListItem", "position": 9, "name": "Taylor & Maclaurin Series Calculator", "url": "https://8gwifi.org/series-calculator.jsp"},
          {"@type": "ListItem", "position": 10, "name": "Derivative Calculator", "url": "https://8gwifi.org/derivative-calculator.jsp"},
          {"@type": "ListItem", "position": 11, "name": "Integral Calculator", "url": "https://8gwifi.org/integral-calculator.jsp"},
          {"@type": "ListItem", "position": 12, "name": "Limit Calculator", "url": "https://8gwifi.org/limit-calculator.jsp"},
          {"@type": "ListItem", "position": 13, "name": "Matrix Determinant Calculator", "url": "https://8gwifi.org/matrix-determinant-calculator.jsp"},
          {"@type": "ListItem", "position": 14, "name": "Matrix Multiplication Calculator", "url": "https://8gwifi.org/matrix-multiplication-calculator.jsp"},
          {"@type": "ListItem", "position": 15, "name": "Matrix Inverse Calculator", "url": "https://8gwifi.org/matrix-inverse-calculator.jsp"},
          {"@type": "ListItem", "position": 16, "name": "Matrix Eigenvalue Calculator", "url": "https://8gwifi.org/matrix-eigenvalue-calculator.jsp"},
          {"@type": "ListItem", "position": 17, "name": "Matrix Rank Calculator", "url": "https://8gwifi.org/matrix-rank-calculator.jsp"},
          {"@type": "ListItem", "position": 18, "name": "Matrix Addition Calculator", "url": "https://8gwifi.org/matrix-addition-calculator.jsp"},
          {"@type": "ListItem", "position": 19, "name": "Matrix Power Calculator", "url": "https://8gwifi.org/matrix-power-calculator.jsp"},
          {"@type": "ListItem", "position": 20, "name": "Matrix Transpose Calculator", "url": "https://8gwifi.org/matrix-transpose-calculator.jsp"},
          {"@type": "ListItem", "position": 21, "name": "Matrix Type Classifier", "url": "https://8gwifi.org/matrix-type-classifier.jsp"},
          {"@type": "ListItem", "position": 22, "name": "Polynomial Calculator", "url": "https://8gwifi.org/polynomial-calculator.jsp"}
        ]
      }
    }
    </script>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">

    <%@ include file="../modern/ads/ad-init.jsp" %>

    <style>
        :root {
            --math-primary: #16a34a;
            --math-secondary: #22c55e;
        }

        .math-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem 1.5rem;
        }

        /* Hero */
        .hero {
            background: linear-gradient(135deg, var(--math-primary) 0%, var(--math-secondary) 100%);
            color: white;
            padding: 2.5rem 2rem;
            border-radius: 20px;
            text-align: center;
            margin-bottom: 2.5rem;
            box-shadow: 0 20px 60px rgba(22, 163, 74, 0.25);
        }
        .hero h1 { font-size: 2.25rem; margin: 0 0 0.5rem; font-weight: 800; }
        .hero p { font-size: 1.05rem; opacity: 0.95; margin: 0 0 1.25rem; }
        .hero-stats { display: flex; justify-content: center; gap: 2.5rem; flex-wrap: wrap; }
        .hero-stat { text-align: center; }
        .hero-stat-value { font-size: 1.75rem; font-weight: 800; display: block; }
        .hero-stat-label { font-size: 0.8rem; opacity: 0.85; }

        /* Category */
        .category { margin-bottom: 2.5rem; }
        .category-header {
            display: flex; align-items: center; gap: 0.75rem;
            margin-bottom: 1.25rem; padding-bottom: 0.75rem;
            border-bottom: 2px solid var(--border-color, #e2e8f0);
        }
        .category-icon {
            font-size: 1.5rem; width: 40px; height: 40px;
            display: flex; align-items: center; justify-content: center;
            background: var(--bg-secondary, #f1f5f9); border-radius: 10px;
        }
        .category-header h2 { margin: 0; font-size: 1.35rem; font-weight: 700; color: var(--text-primary, #1e293b); }
        .category-count {
            margin-left: auto; background: var(--bg-secondary, #f1f5f9);
            padding: 0.3rem 0.75rem; border-radius: 20px;
            font-size: 0.8rem; color: var(--text-secondary, #64748b); font-weight: 600;
        }

        /* Grid */
        .tools-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 1.25rem;
        }

        /* Card */
        .tool-card-link {
            background: var(--bg-primary, #fff);
            border: 1px solid var(--border-color, #e2e8f0);
            border-radius: 14px; padding: 1.25rem;
            text-decoration: none; display: block;
            transition: all 0.2s ease; position: relative; overflow: hidden;
        }
        .tool-card-link::before {
            content: ''; position: absolute; top: 0; left: 0; right: 0;
            height: 3px; background: var(--card-accent, var(--math-primary));
            transform: scaleX(0); transition: transform 0.2s ease;
        }
        .tool-card-link:hover {
            transform: translateY(-3px); border-color: var(--math-primary);
            box-shadow: 0 10px 30px rgba(22, 163, 74, 0.12);
        }
        .tool-card-link:hover::before { transform: scaleX(1); }

        .tool-card-header { display: flex; gap: 0.875rem; margin-bottom: 0.625rem; }
        .tool-icon {
            width: 44px; height: 44px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.35rem; flex-shrink: 0; color: #fff; font-weight: 700;
        }
        .tool-card-link h3 { margin: 0; font-size: 1rem; font-weight: 700; color: var(--text-primary, #1e293b); line-height: 1.3; }
        .tool-formula { font-family: 'Times New Roman', Georgia, serif; font-size: 0.8rem; color: var(--text-secondary, #64748b); margin-top: 0.2rem; }
        .tool-card-link p { color: var(--text-secondary, #64748b); margin: 0 0 0.625rem; font-size: 0.875rem; line-height: 1.5; }

        .tool-badges { display: flex; gap: 0.4rem; flex-wrap: wrap; }
        .badge { padding: 0.2rem 0.5rem; border-radius: 5px; font-size: 0.65rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.3px; }
        .badge-steps { background: linear-gradient(135deg, #16a34a, #22c55e); color: white; }
        .badge-python { background: linear-gradient(135deg, #3b82f6, #6366f1); color: white; }
        .badge-graph { background: linear-gradient(135deg, #f59e0b, #ea580c); color: white; }
        .badge-new { background: linear-gradient(135deg, #ec4899, #f43f5e); color: white; }

        /* Ad container between sections */
        .math-ad-slot { margin: 1.5rem 0; text-align: center; }

        /* SEO Content */
        .seo-content {
            background: var(--bg-primary, #fff);
            border: 1px solid var(--border-color, #e2e8f0);
            border-radius: 16px; padding: 2rem; margin-top: 2rem;
        }
        .seo-content h2 { color: var(--text-primary, #1e293b); margin: 0 0 1rem; font-size: 1.4rem; }
        .seo-content h3 { color: var(--text-primary, #1e293b); margin: 1.5rem 0 0.75rem; font-size: 1.1rem; }
        .seo-content p, .seo-content li { color: var(--text-secondary, #64748b); line-height: 1.7; }

        .formula-grid {
            display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
            gap: 0.75rem; margin: 1rem 0;
        }
        .formula-item {
            background: var(--bg-secondary, #f8fafc);
            padding: 0.875rem; border-radius: 10px;
            border-left: 3px solid var(--math-primary);
        }
        .formula-item strong { display: block; color: var(--text-primary, #1e293b); font-size: 0.85rem; margin-bottom: 0.2rem; }
        .formula-item code { font-family: 'Times New Roman', Georgia, serif; font-size: 1.05rem; color: var(--math-primary); }

        /* Scroll animations */
        .math-anim { opacity: 0; transform: translateY(1.5rem); transition: opacity 0.5s ease, transform 0.5s ease; }
        .math-anim.math-visible { opacity: 1; transform: translateY(0); }
        .math-anim-d1 { transition-delay: 0.05s; }
        .math-anim-d2 { transition-delay: 0.1s; }
        .math-anim-d3 { transition-delay: 0.15s; }
        .math-anim-d4 { transition-delay: 0.2s; }
        @media (prefers-reduced-motion: reduce) { .math-anim { opacity: 1; transform: none; transition: none; } }

        /* Responsive */
        @media (max-width: 768px) {
            .math-container { padding: 1rem; }
            .hero { padding: 1.75rem 1.25rem; }
            .hero h1 { font-size: 1.5rem; }
            .hero p { font-size: 0.95rem; }
            .hero-stats { gap: 1.5rem; }
            .hero-stat-value { font-size: 1.4rem; }
            .tools-grid { grid-template-columns: 1fr; }
            .category-header h2 { font-size: 1.15rem; }
        }

        /* Dark mode */
        [data-theme="dark"] {
            --bg-primary: #1e293b; --bg-secondary: #334155;
            --text-primary: #f1f5f9; --text-secondary: #94a3b8;
            --border-color: #475569;
        }
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <main class="math-container">
        <!-- Hero -->
        <section class="hero">
            <h1>Math Calculators</h1>
            <p>Free step-by-step solvers with KaTeX formulas and Python compilers</p>
            <div class="hero-stats">
                <div class="hero-stat">
                    <span class="hero-stat-value">21</span>
                    <span class="hero-stat-label">Calculators</span>
                </div>
                <div class="hero-stat">
                    <span class="hero-stat-value">100%</span>
                    <span class="hero-stat-label">Free</span>
                </div>
                <div class="hero-stat">
                    <span class="hero-stat-value">Step-by-Step</span>
                    <span class="hero-stat-label">KaTeX Solutions</span>
                </div>
            </div>
        </section>

        <!-- ==================== EVERYDAY MATH ==================== -->
        <section class="category">
            <div class="category-header">
                <span class="category-icon">&#128176;</span>
                <h2>Everyday Math</h2>
                <span class="category-count">3 tools</span>
            </div>
            <div class="tools-grid">
                <a href="<%=request.getContextPath()%>/percentage-calculator.jsp" class="tool-card-link math-anim math-anim-d1" style="--card-accent: #16a34a;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #16a34a, #22c55e);">%</div>
                        <div>
                            <h3>Percentage Calculator</h3>
                            <div class="tool-formula">X% of Y, % change, discount + tax</div>
                        </div>
                    </div>
                    <p>8 modes: percent of, what percent, increase/decrease, percent change, reverse, discount simulator, chained steps.</p>
                    <div class="tool-badges">
                        <span class="badge badge-steps">Steps</span>
                        <span class="badge badge-python">Python</span>
                        <span class="badge badge-new">New</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/significant-figures-calculator.jsp" class="tool-card-link math-anim math-anim-d2" style="--card-accent: #0891b2;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #0891b2, #0d9488);">SF</div>
                        <div>
                            <h3>Significant Figures Calculator</h3>
                            <div class="tool-formula">Count, round &amp; convert sig figs</div>
                        </div>
                    </div>
                    <p>Count significant figures, round to N sig figs, and convert between standard and scientific notation.</p>
                    <div class="tool-badges">
                        <span class="badge badge-steps">Steps</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/24-game-solver.jsp" class="tool-card-link math-anim math-anim-d3" style="--card-accent: #ec4899;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #ec4899, #f43f5e);">24</div>
                        <div>
                            <h3>24 Game Solver</h3>
                            <div class="tool-formula">Make 24 from any 4 numbers</div>
                        </div>
                    </div>
                    <p>Find all solutions that combine 4 numbers using +, -, &times;, &divide; to make 24. Step-by-step explanations.</p>
                    <div class="tool-badges">
                        <span class="badge badge-steps">Steps</span>
                    </div>
                </a>
            </div>
        </section>

        <!-- ==================== ALGEBRA ==================== -->
        <section class="category">
            <div class="category-header">
                <span class="category-icon">&#128200;</span>
                <h2>Algebra</h2>
                <span class="category-count">6 tools</span>
            </div>
            <div class="tools-grid">
                <a href="<%=request.getContextPath()%>/exponent-calculator.jsp" class="tool-card-link math-anim math-anim-d1" style="--card-accent: #d97706;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #d97706, #f59e0b);">x<sup>n</sup></div>
                        <div>
                            <h3>Exponent Calculator</h3>
                            <div class="tool-formula">All 8 laws of exponents</div>
                        </div>
                    </div>
                    <p>Calculate powers, apply product/quotient/power rules, handle negative, zero, and fractional exponents with steps.</p>
                    <div class="tool-badges">
                        <span class="badge badge-steps">Steps</span>
                        <span class="badge badge-python">Python</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/logarithm-calculator.jsp" class="tool-card-link math-anim math-anim-d2" style="--card-accent: #0d9488;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #0d9488, #14b8a6);">log</div>
                        <div>
                            <h3>Logarithm Calculator</h3>
                            <div class="tool-formula">log, ln, change of base</div>
                        </div>
                    </div>
                    <p>Compute logarithms with any base, natural log, change of base, and log equations with step-by-step solutions.</p>
                    <div class="tool-badges">
                        <span class="badge badge-steps">Steps</span>
                        <span class="badge badge-python">Python</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/quadratic-solver.jsp" class="tool-card-link math-anim math-anim-d3" style="--card-accent: #7c3aed;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #7c3aed, #a78bfa);">x&sup2;</div>
                        <div>
                            <h3>Quadratic Equation Solver</h3>
                            <div class="tool-formula">ax&sup2; + bx + c = 0</div>
                        </div>
                    </div>
                    <p>Solve with quadratic formula, completing the square, or factoring. Includes discriminant analysis and graph.</p>
                    <div class="tool-badges">
                        <span class="badge badge-steps">Steps</span>
                        <span class="badge badge-graph">Graph</span>
                        <span class="badge badge-python">Python</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/linear-equations-solver.jsp" class="tool-card-link math-anim math-anim-d4" style="--card-accent: #2563eb;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #2563eb, #3b82f6);">Ax=b</div>
                        <div>
                            <h3>System of Equations Solver</h3>
                            <div class="tool-formula">2&times;2, 3&times;3, 4&times;4 systems</div>
                        </div>
                    </div>
                    <p>Solve systems of linear equations using substitution, elimination, or Cramer's rule with detailed steps.</p>
                    <div class="tool-badges">
                        <span class="badge badge-steps">Steps</span>
                        <span class="badge badge-python">Python</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/inequality-solver.jsp" class="tool-card-link math-anim math-anim-d1" style="--card-accent: #dc2626;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #dc2626, #f43f5e);">&ge;</div>
                        <div>
                            <h3>Inequality Solver</h3>
                            <div class="tool-formula">Linear, quadratic, rational inequalities</div>
                        </div>
                    </div>
                    <p>Solve linear, quadratic, and rational inequalities with step-by-step solutions and number line visualization.</p>
                    <div class="tool-badges">
                        <span class="badge badge-steps">Steps</span>
                        <span class="badge badge-graph">Graph</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/polynomial-calculator.jsp" class="tool-card-link math-anim math-anim-d2" style="--card-accent: #0d9488;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #0d9488, #14b8a6);">P(x)</div>
                        <div>
                            <h3>Polynomial Calculator</h3>
                            <div class="tool-formula">Add, subtract, multiply, divide, factor, roots</div>
                        </div>
                    </div>
                    <p>Perform all polynomial operations with step-by-step solutions. Long division, factoring, root finding for any degree.</p>
                    <div class="tool-badges">
                        <span class="badge badge-steps">Steps</span>
                        <span class="badge badge-graph">Graph</span>
                        <span class="badge badge-python">Python</span>
                    </div>
                </a>
            </div>
        </section>

        <!-- Mid-page ad -->
        <div class="math-ad-slot">
            <%@ include file="../modern/ads/ad-in-content-mid.jsp" %>
        </div>

        <!-- ==================== CALCULUS ==================== -->
        <section class="category">
            <div class="category-header">
                <span class="category-icon">&#8747;</span>
                <h2>Calculus</h2>
                <span class="category-count">4 tools</span>
            </div>
            <div class="tools-grid">
                <a href="<%=request.getContextPath()%>/derivative-calculator.jsp" class="tool-card-link math-anim math-anim-d1" style="--card-accent: #059669;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #059669, #10b981);">d/dx</div>
                        <div>
                            <h3>Derivative Calculator</h3>
                            <div class="tool-formula">f'(x), chain rule, product rule</div>
                        </div>
                    </div>
                    <p>Differentiate any function with step-by-step application of differentiation rules. Supports higher-order derivatives.</p>
                    <div class="tool-badges">
                        <span class="badge badge-steps">Steps</span>
                        <span class="badge badge-graph">Graph</span>
                        <span class="badge badge-python">Python</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/integral-calculator.jsp" class="tool-card-link math-anim math-anim-d2" style="--card-accent: #4f46e5;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #4f46e5, #7c3aed);">&int;</div>
                        <div>
                            <h3>Integral Calculator</h3>
                            <div class="tool-formula">&int;f(x)dx, definite &amp; indefinite</div>
                        </div>
                    </div>
                    <p>Compute definite and indefinite integrals with step-by-step solutions using substitution, parts, and partial fractions.</p>
                    <div class="tool-badges">
                        <span class="badge badge-steps">Steps</span>
                        <span class="badge badge-graph">Graph</span>
                        <span class="badge badge-python">Python</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/limit-calculator.jsp" class="tool-card-link math-anim math-anim-d3" style="--card-accent: #9333ea;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #9333ea, #a855f7);">lim</div>
                        <div>
                            <h3>Limit Calculator</h3>
                            <div class="tool-formula">lim f(x) as x &rarr; a</div>
                        </div>
                    </div>
                    <p>Evaluate limits at a point or at infinity. Handles indeterminate forms with L'H&ocirc;pital's rule and step-by-step solutions.</p>
                    <div class="tool-badges">
                        <span class="badge badge-steps">Steps</span>
                        <span class="badge badge-python">Python</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/series-calculator.jsp" class="tool-card-link math-anim math-anim-d4" style="--card-accent: #2563eb;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #2563eb, #3b82f6);">&Sigma;</div>
                        <div>
                            <h3>Taylor &amp; Maclaurin Series</h3>
                            <div class="tool-formula">&Sigma; f<sup>(n)</sup>(a)/n! &middot; (x-a)<sup>n</sup></div>
                        </div>
                    </div>
                    <p>Compute Taylor and Maclaurin series expansions with step-by-step derivatives and convergence analysis.</p>
                    <div class="tool-badges">
                        <span class="badge badge-steps">Steps</span>
                        <span class="badge badge-graph">Graph</span>
                        <span class="badge badge-python">Python</span>
                    </div>
                </a>
            </div>
        </section>

        <!-- ==================== LINEAR ALGEBRA ==================== -->
        <section class="category">
            <div class="category-header">
                <span class="category-icon">&#9638;</span>
                <h2>Linear Algebra (Matrices)</h2>
                <span class="category-count">9 tools</span>
            </div>
            <div class="tools-grid">
                <a href="<%=request.getContextPath()%>/matrix-determinant-calculator.jsp" class="tool-card-link math-anim math-anim-d1" style="--card-accent: #6366f1;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #6366f1, #8b5cf6);">det</div>
                        <div>
                            <h3>Matrix Determinant</h3>
                            <div class="tool-formula">det(A), 2&times;2 to 10&times;10</div>
                        </div>
                    </div>
                    <p>Compute determinants of matrices up to 10&times;10 using cofactor expansion with step-by-step solutions.</p>
                    <div class="tool-badges">
                        <span class="badge badge-steps">Steps</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/matrix-multiplication-calculator.jsp" class="tool-card-link math-anim math-anim-d2" style="--card-accent: #2563eb;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #2563eb, #3b82f6);">A&times;B</div>
                        <div>
                            <h3>Matrix Multiplication</h3>
                            <div class="tool-formula">C = A &times; B</div>
                        </div>
                    </div>
                    <p>Multiply matrices of any compatible dimensions with detailed element-by-element computation steps.</p>
                    <div class="tool-badges">
                        <span class="badge badge-steps">Steps</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/matrix-inverse-calculator.jsp" class="tool-card-link math-anim math-anim-d3" style="--card-accent: #059669;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #059669, #10b981);">A<sup>-1</sup></div>
                        <div>
                            <h3>Matrix Inverse</h3>
                            <div class="tool-formula">A<sup>&minus;1</sup> via Gauss-Jordan</div>
                        </div>
                    </div>
                    <p>Find the inverse matrix using Gauss-Jordan elimination with row operation steps.</p>
                    <div class="tool-badges">
                        <span class="badge badge-steps">Steps</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/matrix-eigenvalue-calculator.jsp" class="tool-card-link math-anim math-anim-d4" style="--card-accent: #d97706;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #d97706, #f59e0b);">&lambda;</div>
                        <div>
                            <h3>Eigenvalue Calculator</h3>
                            <div class="tool-formula">&lambda; &amp; eigenvectors</div>
                        </div>
                    </div>
                    <p>Compute eigenvalues and eigenvectors with characteristic polynomial and step-by-step solutions.</p>
                    <div class="tool-badges">
                        <span class="badge badge-steps">Steps</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/matrix-rank-calculator.jsp" class="tool-card-link math-anim math-anim-d1" style="--card-accent: #dc2626;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #dc2626, #f43f5e);">rank</div>
                        <div>
                            <h3>Matrix Rank</h3>
                            <div class="tool-formula">rank(A) via row echelon</div>
                        </div>
                    </div>
                    <p>Compute matrix rank using row echelon form with step-by-step row operations.</p>
                    <div class="tool-badges">
                        <span class="badge badge-steps">Steps</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/matrix-addition-calculator.jsp" class="tool-card-link math-anim math-anim-d2" style="--card-accent: #0891b2;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #0891b2, #06b6d4);">A+B</div>
                        <div>
                            <h3>Matrix Addition</h3>
                            <div class="tool-formula">A+B, A&minus;B, cA, aA+bB</div>
                        </div>
                    </div>
                    <p>Add, subtract, and scale matrices with element-wise computation steps.</p>
                    <div class="tool-badges">
                        <span class="badge badge-steps">Steps</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/matrix-power-calculator.jsp" class="tool-card-link math-anim math-anim-d3" style="--card-accent: #9333ea;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #9333ea, #a855f7);">A<sup>n</sup></div>
                        <div>
                            <h3>Matrix Power</h3>
                            <div class="tool-formula">A<sup>n</sup> with practice worksheet</div>
                        </div>
                    </div>
                    <p>Compute matrix raised to any power with step-by-step multiplication and practice problems.</p>
                    <div class="tool-badges">
                        <span class="badge badge-steps">Steps</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/matrix-transpose-calculator.jsp" class="tool-card-link math-anim math-anim-d4" style="--card-accent: #4f46e5;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #4f46e5, #6366f1);">A<sup>T</sup></div>
                        <div>
                            <h3>Matrix Transpose</h3>
                            <div class="tool-formula">A<sup>T</sup> with practice worksheet</div>
                        </div>
                    </div>
                    <p>Transpose matrices and verify properties like (AB)<sup>T</sup> = B<sup>T</sup>A<sup>T</sup> with steps.</p>
                    <div class="tool-badges">
                        <span class="badge badge-steps">Steps</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/matrix-type-classifier.jsp" class="tool-card-link math-anim math-anim-d1" style="--card-accent: #be185d;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #be185d, #ec4899);">?</div>
                        <div>
                            <h3>Matrix Type Classifier</h3>
                            <div class="tool-formula">20+ matrix types detected</div>
                        </div>
                    </div>
                    <p>Identify symmetric, orthogonal, diagonal, identity, nilpotent, and 20+ other matrix types.</p>
                    <div class="tool-badges">
                        <span class="badge badge-steps">Steps</span>
                    </div>
                </a>
            </div>
        </section>

        <!-- Bottom ad -->
        <div class="math-ad-slot">
            <%@ include file="../modern/ads/ad-in-content-mid.jsp" %>
        </div>

        <!-- SEO Content -->
        <section class="seo-content">
            <h2>About Our Math Calculators</h2>
            <p>Our math calculators help students, teachers, and professionals solve problems with detailed step-by-step solutions rendered in KaTeX. Each tool includes a built-in Python compiler so you can verify results programmatically.</p>

            <h3>Quick Formula Reference</h3>
            <div class="formula-grid">
                <div class="formula-item">
                    <strong>Percent Of</strong>
                    <code>X% of Y = XY/100</code>
                </div>
                <div class="formula-item">
                    <strong>Quadratic</strong>
                    <code>x = (-b &plusmn; &radic;(b&sup2;-4ac)) / 2a</code>
                </div>
                <div class="formula-item">
                    <strong>Exponent</strong>
                    <code>a<sup>m</sup> &times; a<sup>n</sup> = a<sup>m+n</sup></code>
                </div>
                <div class="formula-item">
                    <strong>Logarithm</strong>
                    <code>log<sub>b</sub>(x) = ln(x)/ln(b)</code>
                </div>
                <div class="formula-item">
                    <strong>Derivative</strong>
                    <code>d/dx [x<sup>n</sup>] = nx<sup>n-1</sup></code>
                </div>
                <div class="formula-item">
                    <strong>Integral</strong>
                    <code>&int;x<sup>n</sup>dx = x<sup>n+1</sup>/(n+1)</code>
                </div>
                <div class="formula-item">
                    <strong>Determinant 2&times;2</strong>
                    <code>ad - bc</code>
                </div>
                <div class="formula-item">
                    <strong>Taylor Series</strong>
                    <code>&Sigma; f<sup>(n)</sup>(a)(x-a)<sup>n</sup>/n!</code>
                </div>
            </div>

            <h3>Features</h3>
            <ul>
                <li><strong>Step-by-Step Solutions:</strong> Every calculator shows detailed solution steps with KaTeX-rendered math notation</li>
                <li><strong>Python Compiler:</strong> Verify results with built-in Python code templates using SymPy</li>
                <li><strong>LaTeX Export:</strong> Copy solutions as LaTeX for use in papers and homework</li>
                <li><strong>Shareable URLs:</strong> Share specific calculations via encoded URL parameters</li>
                <li><strong>Mobile Friendly:</strong> Responsive design works on all devices</li>
                <li><strong>100% Free:</strong> No registration, no payment, no limits</li>
            </ul>

            <h3>For Students</h3>
            <p>Whether you're studying for exams or working through homework, our calculators show you the method, not just the answer. Every step explains which formula or rule is being applied so you learn the underlying mathematics.</p>

            <h3>For Teachers</h3>
            <p>Generate worked examples for class, create practice problems, and demonstrate mathematical concepts with step-by-step breakdowns. The Python compiler lets students verify their work programmatically.</p>
        </section>

        <!-- FAQ (matches schema) -->
        <section class="seo-content" style="margin-top:1.5rem;">
            <h2 id="faqs">Frequently Asked Questions</h2>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    Are these math calculators free?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Yes, all 22 math calculators are completely free with no registration required. Every tool shows step-by-step solutions with KaTeX-rendered formulas and includes a Python compiler for verification.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    Do the calculators show step-by-step solutions?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Yes, every calculator renders detailed step-by-step solutions using KaTeX math notation. Each step explains the formula applied and shows the intermediate calculation, so you learn the method, not just the answer.</div>
            </div>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    What math topics are covered?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">We cover everyday math (percentages, significant figures), algebra (quadratic equations, linear systems, inequalities, exponents, logarithms), calculus (derivatives, integrals, limits, Taylor series), and linear algebra (9 matrix calculators covering determinants, multiplication, inverse, eigenvalues, rank, and more).</div>
            </div>
        </section>
    </main>

    <!-- Footer -->
    <footer class="page-footer">
        <div class="footer-content">
            <p class="footer-text">&copy; 2025 8gwifi.org - Free Online Math Calculators</p>
            <div class="footer-links">
                <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
                <a href="<%=request.getContextPath()%>/physics/" class="footer-link">Physics</a>
                <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
            </div>
        </div>
    </footer>

    <%@ include file="../modern/ads/ad-sticky-footer.jsp" %>

    <!-- Dark mode & search -->
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

    <!-- Scroll animations -->
    <script>
    (function(){
        var els = document.querySelectorAll('.math-anim');
        if (!els.length) return;
        if (!('IntersectionObserver' in window)) {
            for (var i = 0; i < els.length; i++) els[i].classList.add('math-visible');
            return;
        }
        var obs = new IntersectionObserver(function(entries){
            for (var j = 0; j < entries.length; j++) {
                if (entries[j].isIntersecting) {
                    entries[j].target.classList.add('math-visible');
                    obs.unobserve(entries[j].target);
                }
            }
        }, { threshold: 0.1 });
        for (var k = 0; k < els.length; k++) obs.observe(els[k]);
    })();
    </script>

    <!-- FAQ toggle -->
    <script>
    function toggleFaq(btn) {
        var item = btn.parentElement;
        var answer = item.querySelector('.faq-answer');
        var chevron = btn.querySelector('.faq-chevron');
        var isOpen = answer.style.maxHeight && answer.style.maxHeight !== '0px';
        answer.style.maxHeight = isOpen ? '0px' : answer.scrollHeight + 'px';
        answer.style.padding = isOpen ? '0 1rem' : '0.75rem 1rem';
        if (chevron) chevron.style.transform = isOpen ? '' : 'rotate(180deg)';
    }
    </script>

    <%@ include file="../modern/components/analytics.jsp" %>
</body>
</html>
