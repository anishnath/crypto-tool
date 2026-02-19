<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow">
    <meta name="googlebot" content="index,follow">
    <meta name="resource-type" content="document">
    <meta name="classification" content="tools">
    <meta name="language" content="en">
    <meta name="author" content="Anish Nath">
    <meta name="context-path" content="<%=request.getContextPath()%>">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdn.jsdelivr.net">
    <link rel="dns-prefetch" href="https://cdn.plot.ly">
    <style>
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
        html{scroll-behavior:smooth;-webkit-text-size-adjust:100%;-webkit-font-smoothing:antialiased;-moz-osx-font-smoothing:grayscale}
        body{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif;font-size:1rem;line-height:1.5;color:#0f172a;background:#fff}
        *:focus-visible{outline:2px solid var(--primary);outline-offset:2px}
        @media(prefers-reduced-motion:reduce){*,*::before,*::after{animation-duration:.01ms!important;transition-duration:.01ms!important}}
        :root,:root[data-theme="light"]{
            --primary:#6366f1;--primary-dark:#4f46e5;--primary-light:#818cf8;--primary-50:#eef2ff;--primary-100:#e0e7ff;
            --bg-primary:#fff;--bg-secondary:#f8fafc;--bg-tertiary:#f1f5f9;--bg-hover:#f8fafc;
            --text-primary:#0f172a;--text-secondary:#475569;--text-muted:#94a3b8;--text-inverse:#fff;
            --border:#e2e8f0;--border-light:#f1f5f9;--border-dark:#cbd5e1;
            --success:#10b981;--warning:#f59e0b;--error:#ef4444;--info:#3b82f6;
            --font-sans:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif;
            --font-mono:'JetBrains Mono','Fira Code','SF Mono',Consolas,monospace;
            --text-xs:0.75rem;--text-sm:0.875rem;--text-base:1rem;--text-lg:1.125rem;--text-xl:1.25rem;--text-2xl:1.5rem;
            --leading-tight:1.25;--leading-normal:1.5;
            --font-normal:400;--font-medium:500;--font-semibold:600;--font-bold:700;
            --space-1:0.25rem;--space-2:0.5rem;--space-3:0.75rem;--space-4:1rem;--space-5:1.25rem;--space-6:1.5rem;--space-8:2rem;--space-10:2.5rem;--space-12:3rem;
            --shadow-sm:0 1px 2px 0 rgba(0,0,0,0.05);--shadow-md:0 4px 6px -1px rgba(0,0,0,0.1),0 2px 4px -2px rgba(0,0,0,0.1);--shadow-lg:0 10px 15px -3px rgba(0,0,0,0.1),0 4px 6px -4px rgba(0,0,0,0.1);
            --radius-sm:0.375rem;--radius-md:0.5rem;--radius-lg:0.75rem;--radius-xl:1rem;--radius-full:9999px;
            --z-dropdown:1000;--z-sticky:1020;--z-fixed:1030;--z-modal-backdrop:1040;--z-modal:1050;
            --transition-fast:150ms ease-in-out;--transition-base:200ms ease-in-out;--transition-slow:300ms ease-in-out;
            --header-height-mobile:64px;--header-height-desktop:72px;--container-max-width:1280px;
            --tool-primary:#7c3aed;--tool-primary-dark:#6d28d9;--tool-gradient:linear-gradient(135deg,#7c3aed 0%,#a78bfa 100%);--tool-light:#ede9fe
        }
        @media(prefers-color-scheme:dark){:root{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b}}
        [data-theme="dark"]{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b;--tool-light:rgba(124,58,237,0.15)}
        [data-theme="dark"] body{background-color:var(--bg-primary);color:var(--text-primary)}
        @media(min-width:768px){:root{--header-height-mobile:72px}}
        .modern-nav{position:fixed;top:0;left:0;right:0;z-index:var(--z-fixed,1030);background:var(--bg-primary,#fff);border-bottom:1px solid var(--border,#e2e8f0);box-shadow:var(--shadow-sm);height:var(--header-height-desktop,72px)}
        .nav-container{max-width:1400px;margin:0 auto;padding:0 var(--space-4,1rem);display:flex;align-items:center;justify-content:space-between;height:100%}
        .nav-logo{display:flex;align-items:center;gap:var(--space-3,0.75rem);text-decoration:none;font-weight:700;font-size:var(--text-lg,1.125rem)}
        .nav-logo img{width:32px;height:32px;border-radius:var(--radius-md,0.5rem)}
        .nav-logo span{background:linear-gradient(135deg,#6366f1 0%,#8b5cf6 50%,#ec4899 100%);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;font-weight:700;letter-spacing:-0.02em}
        [data-theme="dark"] .nav-logo span{background:linear-gradient(135deg,#818cf8 0%,#a78bfa 50%,#f472b6 100%);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text}
        .tool-page-header{background:var(--bg-primary,#fff);border-bottom:1px solid var(--border,#e2e8f0);padding:1.25rem 1.5rem;margin-top:72px}
        .tool-page-header-inner{max-width:1600px;margin:0 auto;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem}
        .tool-page-title{font-size:1.5rem;font-weight:700;color:var(--text-primary,#0f172a);margin:0}
        .tool-page-badges{display:flex;gap:0.5rem;flex-wrap:wrap}
        .tool-badge{display:inline-flex;align-items:center;gap:0.25rem;padding:0.25rem 0.625rem;font-size:0.6875rem;font-weight:500;border-radius:9999px;background:var(--tool-light);color:var(--tool-primary)}
        .tool-breadcrumbs{font-size:0.8125rem;color:var(--text-secondary,#475569);margin-top:0.5rem}
        .tool-breadcrumbs a{color:var(--text-secondary,#475569);text-decoration:none}
        .tool-description-section{background:var(--tool-light);border-bottom:1px solid var(--border,#e2e8f0);padding:1.25rem 1.5rem}
        .tool-description-inner{max-width:1600px;margin:0 auto}
        .tool-description-content p{margin:0;font-size:0.9375rem;line-height:1.6;color:var(--text-secondary,#475569)}
        .tool-page-container{display:grid;grid-template-columns:minmax(320px,400px) minmax(0,1fr) 300px;gap:1.5rem;max-width:1600px;margin:0 auto;padding:1.5rem;min-height:calc(100vh - 180px)}
        @media(max-width:1024px){.tool-page-container{grid-template-columns:minmax(300px,380px) minmax(0,1fr)}.tool-ads-column{display:none}}
        @media(max-width:900px){.tool-page-container{grid-template-columns:1fr;gap:1rem;display:flex;flex-direction:column}.tool-input-column{position:relative;top:auto;max-height:none;overflow-y:visible;order:1}.tool-output-column{display:flex!important;min-height:350px;order:2}.tool-ads-column{order:3}}
        .tool-input-column{position:sticky;top:90px;height:fit-content;max-height:calc(100vh - 110px);overflow-y:auto}
        .tool-output-column{display:flex;flex-direction:column;gap:1rem}
        .tool-ads-column{height:fit-content}
        .tool-card{background:var(--bg-primary,#fff);border:1px solid var(--border,#e2e8f0);border-radius:0.75rem;overflow:hidden;box-shadow:0 1px 3px rgba(0,0,0,0.05)}
        .tool-card-header{background:var(--tool-gradient);color:#fff;padding:0.875rem 1rem;font-weight:600;font-size:0.9375rem;display:flex;align-items:center;gap:0.5rem}
        .tool-card-body{padding:1rem}
        .tool-form-group{margin-bottom:0.875rem}
        .tool-form-label{display:block;font-weight:500;margin-bottom:0.375rem;color:var(--text-primary,#0f172a);font-size:0.8125rem}
        .tool-form-hint{font-size:0.6875rem;color:var(--text-secondary,#475569);margin-top:0.25rem}
        .tool-action-btn{width:100%;padding:0.75rem;font-weight:600;font-size:0.875rem;border:none;border-radius:0.5rem;cursor:pointer;background:var(--tool-gradient);color:#fff;margin-top:0.5rem;transition:opacity .15s,transform .15s}
        .tool-action-btn:hover{opacity:0.9}
        .tool-result-card{display:flex;flex-direction:column;height:100%}
        .tool-result-header{display:flex;align-items:center;gap:0.5rem;padding:1rem 1.25rem;background:var(--bg-secondary,#f8fafc);border-bottom:1px solid var(--border,#e2e8f0);border-radius:0.75rem 0.75rem 0 0}
        .tool-result-header h4{margin:0;font-size:0.95rem;font-weight:600;color:var(--text-primary,#0f172a);flex:1}
        .tool-result-content{flex:1;padding:1.25rem;min-height:300px;overflow-y:auto}
        .tool-result-actions{display:none;gap:0.5rem;padding:1rem 1.25rem;border-top:1px solid var(--border,#e2e8f0);background:var(--bg-secondary,#f8fafc);border-radius:0 0 0.75rem 0.75rem;flex-wrap:wrap}
        .tool-result-actions .tool-action-btn{flex:1;min-width:90px;margin-top:0}
        .tool-empty-state{display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;padding:3rem 1.5rem;color:var(--text-muted,#94a3b8)}
        .tool-empty-state h3{font-size:1rem;font-weight:600;margin-bottom:0.5rem;color:var(--text-secondary,#475569)}
        .tool-empty-state p{font-size:0.875rem;max-width:280px}
        [data-theme="dark"] .tool-page-header{background:var(--bg-secondary,#1e293b)}
        [data-theme="dark"] .tool-card{background:var(--bg-secondary,#1e293b);border-color:var(--border,#334155)}
        [data-theme="dark"] .tool-result-header{background:var(--bg-tertiary,#334155)}
        [data-theme="dark"] .tool-result-actions{background:var(--bg-tertiary,#334155)}
        [data-theme="dark"] .tool-description-section{background:var(--bg-secondary,#1e293b)}
        .sr-only{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border-width:0}
        .faq-item{border-bottom:1px solid var(--border,#e2e8f0)}.faq-item:last-child{border-bottom:none}
        .faq-question{display:flex;align-items:center;justify-content:space-between;width:100%;padding:0.875rem 0;background:none;border:none;font-size:0.875rem;font-weight:600;color:var(--text-primary,#0f172a);cursor:pointer;text-align:left;font-family:var(--font-sans);gap:0.75rem}
        .faq-answer{display:none;padding:0 0 0.875rem;font-size:0.8125rem;line-height:1.7;color:var(--text-secondary)}
        .faq-item.open .faq-answer{display:block}
        .faq-chevron{transition:transform 0.2s;flex-shrink:0}.faq-item.open .faq-chevron{transform:rotate(180deg)}
    </style>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Trigonometric Equation Solver Online - Step-by-Step Solutions" />
        <jsp:param name="toolDescription" value="Free trig equation solver with step-by-step solutions. Solve trigonometric equations, inequalities and simplify expressions. Find general solutions with periodicity, interactive graphs and Python code." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="trigonometric-equation-solver.jsp" />
        <jsp:param name="toolKeywords" value="trigonometric equation solver, solve trig equations online, trig inequality solver, trig simplifier, general solution trig, solve sin cos tan equations, trig equation calculator, simplify trig expressions" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Solve trig equations with step-by-step solutions,Find all solutions in 0 to 2pi with general form,Trig inequality solver with interval notation,Simplify trig expressions using identities,Interactive function graphs with solution markers,Hybrid client-side and AI solving engine,Python SymPy code generation,LaTeX export for homework and papers" />
        <jsp:param name="teaches" value="Solving trigonometric equations, general solutions with periodicity, trig inequalities, simplifying trig expressions, inverse trig functions, factoring trig equations" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Choose Mode|Select Equation to solve trig equations or Inequality for trig inequalities or Simplify to reduce trig expressions,Enter Expression|Type the equation like sin(x)=1/2 or inequality like sin(x)>1/2 or expression like sin(x)^4-cos(x)^4,Select Angle Unit|Choose Degrees or Radians for the output format (not needed for Simplify mode),Click Solve|Press Solve to get step-by-step solutions with general solutions and periodicity,View Graph|Switch to Graph tab to see the function plotted with solution points marked,Export Python|Switch to Python tab to get SymPy code with solve and simplify functions" />
        <jsp:param name="faq1q" value="How do I solve trig equations step by step?" />
        <jsp:param name="faq1a" value="Enter the equation like sin(x)=1/2 or 2cos^2(x)-1=0. For simple forms, solutions are computed instantly. For complex equations, our AI solver provides step-by-step solutions with all solutions in [0, 2pi) and the general solution with periodicity." />
        <jsp:param name="faq2q" value="What is the general solution of a trig equation?" />
        <jsp:param name="faq2a" value="Since trig functions are periodic, equations have infinitely many solutions. The general solution uses +2n pi for sine and cosine or +n pi for tangent, where n is any integer. We show both specific solutions in [0, 2pi) and the general form." />
        <jsp:param name="faq3q" value="Can the solver handle trig inequalities?" />
        <jsp:param name="faq3a" value="Yes switch to Inequality mode and enter inequalities like sin(x)>1/2 or cos(x)<=0. The solver finds critical points, tests intervals, and expresses the solution set in interval notation with periodicity." />
        <jsp:param name="faq4q" value="How does trig simplification work?" />
        <jsp:param name="faq4a" value="Enter any trig expression like (sin^4(x)-cos^4(x))/(sin^2(x)-cos^2(x)). The solver applies Pythagorean, double angle, and other identities step by step to reduce it to the simplest form. It verifies the result by checking a specific angle value." />
        <jsp:param name="faq5q" value="What if my trig equation has no solution?" />
        <jsp:param name="faq5a" value="The solver detects impossible equations like sin(x)=2 (since sine ranges from -1 to 1) and clearly reports No Solution with an explanation of why. It also detects impossible inequalities like sin(x)>2." />
        <jsp:param name="faq6q" value="What trig equation types are supported?" />
        <jsp:param name="faq6a" value="Simple forms like sin(x)=k, cos(x)=k, tan(x)=k. Quadratic forms like 2cos^2(x)-1=0. Multi-function equations like sin(2x)=cos(x). Product equations like sin(x)cos(x)=1/2. And any combination using standard trig notation." />
    </jsp:include>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
    </noscript>
    <%@ include file="modern/ads/ad-init.jsp" %>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/trigonometry-calculator.css?v=<%=cacheVersion%>">
</head>
<body>
    <%@ include file="modern/components/nav-header.jsp" %>

    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">Trigonometric Equation Solver</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                    Trig Equation Solver
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">Step-by-Step</span>
                <span class="tool-badge">3 Modes</span>
                <span class="tool-badge">Graph</span>
                <span class="tool-badge">Free &middot; No Signup</span>
            </div>
        </div>
    </header>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Free online <strong>trig equation solver</strong> with <strong>step-by-step solutions</strong>. Solve <strong>trig equations</strong>, <strong>inequalities</strong>, and <strong>simplify expressions</strong> with general solutions including periodicity. Interactive <strong>function graphs</strong> and <strong>Python code</strong> generation.</p>
            </div>
        </div>
    </section>

    <main class="tool-page-container">
        <!-- ==================== INPUT COLUMN ==================== -->
        <div class="tool-input-column">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;">
                        <text x="1" y="18" font-size="13" font-weight="700" fill="currentColor" font-family="serif" stroke="none">&theta;=</text>
                    </svg>
                    Trig Equation Solver
                </div>
                <div class="tool-card-body">
                    <!-- Mode Toggle -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Mode</label>
                        <div class="trig-mode-toggle">
                            <button type="button" class="trig-mode-btn active" data-mode="solve_equation">Equation</button>
                            <button type="button" class="trig-mode-btn" data-mode="solve_inequality">Inequality</button>
                            <button type="button" class="trig-mode-btn" data-mode="simplify">Simplify</button>
                        </div>
                    </div>

                    <!-- Expression Input -->
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="trig-expr">Expression</label>
                        <input type="text" class="trig-input-text" id="trig-expr" value="" autocomplete="off" spellcheck="false" placeholder="e.g. sin(2*x) = cos(x)">
                        <div class="tool-form-hint">Use standard notation: sin(x), cos(2*x), tan(x)^2</div>
                    </div>

                    <!-- Unit Toggle -->
                    <div class="tool-form-group" id="trig-unit-group">
                        <label class="tool-form-label">Angle Unit</label>
                        <div class="trig-unit-toggle">
                            <button type="button" class="trig-unit-btn active" data-unit="deg">Degrees</button>
                            <button type="button" class="trig-unit-btn" data-unit="rad">Radians</button>
                        </div>
                    </div>

                    <!-- Live Preview -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Preview</label>
                        <div class="trig-preview" id="trig-preview"><span style="color:var(--text-muted);font-size:0.8125rem;">Enter an expression above&hellip;</span></div>
                    </div>

                    <!-- Buttons -->
                    <button type="button" class="tool-action-btn" id="trig-calc-btn">Solve</button>
                    <button type="button" class="tool-action-btn" id="trig-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);margin-top:0.5rem;">Clear</button>

                    <hr class="trig-sep">

                    <!-- Quick Examples -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Quick Examples</label>
                        <div class="trig-examples">
                            <button type="button" class="trig-example-chip" data-example="eq-sin12">sin(x)=1/2</button>
                            <button type="button" class="trig-example-chip" data-example="eq-sin2x">sin(2x)=cos(x)</button>
                            <button type="button" class="trig-example-chip" data-example="eq-2cos">2cos&sup2;(x)-1=0</button>
                            <button type="button" class="trig-example-chip" data-example="ineq-sin">sin(x)&gt;1/2</button>
                            <button type="button" class="trig-example-chip" data-example="simp-sincos">Simplify sin&#8308;-cos&#8308;</button>
                        </div>
                    </div>

                    <!-- Related Tools -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Related Tools</label>
                        <div class="trig-related">
                            <a href="<%=request.getContextPath()%>/trigonometric-function-calculator.jsp" class="trig-related-link">Trig Functions</a>
                            <a href="<%=request.getContextPath()%>/trigonometric-identity-calculator.jsp" class="trig-related-link">Trig Identities</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== OUTPUT COLUMN ==================== -->
        <div class="tool-output-column">
            <div class="trig-output-tabs">
                <button type="button" class="trig-output-tab active" data-panel="result">Result</button>
                <button type="button" class="trig-output-tab" data-panel="graph">Graph</button>
                <button type="button" class="trig-output-tab" data-panel="python">Python</button>
            </div>

            <div class="trig-panel active" id="trig-panel-result">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                        <h4>Result</h4>
                    </div>
                    <div class="tool-result-content" id="trig-result-content">
                        <div class="tool-empty-state" id="trig-empty-state">
                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&theta;=</div>
                            <h3>Enter a trig equation and click Solve</h3>
                            <p>Solve equations, inequalities, or simplify trig expressions.</p>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="trig-result-actions">
                        <button type="button" class="tool-action-btn" id="trig-copy-latex-btn">&#128203; Copy LaTeX</button>
                        <button type="button" class="tool-action-btn" id="trig-share-btn">&#128279; Share</button>
                    </div>
                </div>
            </div>

            <div class="trig-panel" id="trig-panel-graph">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><circle cx="12" cy="12" r="10"/><line x1="12" y1="2" x2="12" y2="22"/><line x1="2" y1="12" x2="22" y2="12"/></svg>
                        <h4>Function Graph</h4>
                    </div>
                    <div style="flex:1;min-height:0;padding:0.75rem;">
                        <div id="trig-graph-container"></div>
                        <p id="trig-graph-hint" style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">Solve an equation to see the graph.</p>
                    </div>
                </div>
            </div>

            <div class="trig-panel" id="trig-panel-python">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        <h4>Python Compiler</h4>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="trig-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== ADS COLUMN ==================== -->
        <div class="tool-ads-column"><%@ include file="modern/ads/ad-three-column.jsp" %></div>
    </main>

    <div class="tool-mobile-ad-container"><%@ include file="modern/ads/ad-in-content-mid.jsp" %></div>

    <!-- ==================== EDUCATIONAL CONTENT ==================== -->
    <section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

        <!-- 1. Solving Trig Equations -->
        <div class="tool-card trig-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">How to Solve Trigonometric Equations</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">A <strong>trigonometric equation</strong> is an equation that contains trig functions of an unknown angle. Unlike identities (true for all angles), trig equations are satisfied only by <strong>specific angle values</strong>. Because trig functions are periodic, most equations have <strong>infinitely many solutions</strong>. The process involves finding all solutions in one period, then expressing the general solution.</p>

            <div class="trig-feature-grid">
                <div class="trig-feature-card trig-anim trig-anim-d1">
                    <h4>Step 1: Isolate</h4>
                    <p>Isolate the trig function on one side. Convert to a single function if possible using identities.</p>
                </div>
                <div class="trig-feature-card trig-anim trig-anim-d2">
                    <h4>Step 2: Solve in [0, 2&pi;)</h4>
                    <p>Use inverse trig functions and the unit circle to find all solutions in one period.</p>
                </div>
                <div class="trig-feature-card trig-anim trig-anim-d3">
                    <h4>Step 3: Generalize</h4>
                    <p>Add the period (2n&pi; for sin/cos, n&pi; for tan) to express all infinite solutions.</p>
                </div>
                <div class="trig-feature-card trig-anim trig-anim-d4">
                    <h4>Step 4: Verify</h4>
                    <p>Substitute solutions back into the original equation. Discard any extraneous roots.</p>
                </div>
            </div>
        </div>

        <!-- 2. Common Solution Methods -->
        <div class="tool-card trig-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Common Solution Methods for Trig Equations</h2>
            <table class="trig-ops-table">
                <thead><tr><th>Method</th><th>When to Use</th><th>Example</th></tr></thead>
                <tbody>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Direct Inverse</td><td>Simple form: sin(x) = k, cos(x) = k, tan(x) = k</td><td>sin(x) = 1/2 &rarr; x = &pi;/6, 5&pi;/6</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Factoring</td><td>Quadratic in trig function or product equals zero</td><td>2cos&sup2;x &minus; cos x &minus; 1 = 0</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Identity Substitution</td><td>Multiple trig functions &mdash; reduce to one function</td><td>sin&sup2;x + sin x = 0 (factor out sin x)</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Double Angle</td><td>Contains 2x terms alongside x terms</td><td>sin(2x) = cos(x) (expand sin(2x))</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Squaring Both Sides</td><td>Mixed functions that can&rsquo;t be reduced (check for extraneous!)</td><td>sin x + cos x = 1</td></tr>
                </tbody>
            </table>

            <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">Worked Example: Solve sin(x) = 1/2</h3>
            <div class="trig-worked-example">
                <strong>1.</strong> Reference angle: arcsin(1/2) = &pi;/6 = 30&deg;<br>
                <strong>2.</strong> sin is positive in Q1 and Q2<br>
                <strong>3.</strong> Solutions in [0, 2&pi;): x = &pi;/6 and x = &pi; &minus; &pi;/6 = 5&pi;/6<br>
                <strong>4.</strong> General solution: <strong>x = &pi;/6 + 2n&pi;</strong> and <strong>x = 5&pi;/6 + 2n&pi;</strong>, n &isin; &integers;<br>
                <strong>Verify:</strong> sin(&pi;/6) = 1/2 &#10003; &nbsp; sin(5&pi;/6) = 1/2 &#10003;
            </div>

            <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">Worked Example: Solve 2cos&sup2;(x) &minus; 1 = 0</h3>
            <div class="trig-worked-example">
                <strong>1.</strong> 2cos&sup2;x = 1 &rarr; cos&sup2;x = 1/2 &rarr; cos x = &plusmn;1/&radic;2 = &plusmn;&radic;2/2<br>
                <strong>2.</strong> cos x = &radic;2/2: x = &pi;/4, 7&pi;/4 (Q1, Q4)<br>
                <strong>3.</strong> cos x = &minus;&radic;2/2: x = 3&pi;/4, 5&pi;/4 (Q2, Q3)<br>
                <strong>4.</strong> General: <strong>x = &pi;/4 + n&pi;/2</strong> &nbsp; (equivalently, x = &pi;/4 + 2n&pi;, x = 3&pi;/4 + 2n&pi;, x = 5&pi;/4 + 2n&pi;, x = 7&pi;/4 + 2n&pi;)
            </div>
        </div>

        <!-- 3. General Solutions -->
        <div class="tool-card trig-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">General Solutions &mdash; Expressing Infinite Solutions</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">Because trig functions repeat, the general solution captures <strong>all solutions at once</strong> using the function&rsquo;s period. Here are the standard forms:</p>

            <div class="trig-formula-box" style="line-height:2;">
                <strong>sin(x) = k</strong> &nbsp;(|k| &le; 1): &nbsp; x = arcsin(k) + 2n&pi; &nbsp;or&nbsp; x = &pi; &minus; arcsin(k) + 2n&pi;<br>
                <strong>cos(x) = k</strong> &nbsp;(|k| &le; 1): &nbsp; x = &plusmn;arccos(k) + 2n&pi;<br>
                <strong>tan(x) = k</strong> &nbsp;(any real k): &nbsp; x = arctan(k) + n&pi;
            </div>

            <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">No Solution Cases</h3>
            <p style="color:var(--text-secondary);line-height:1.7;">Not every trig equation has a solution. Since sine and cosine are bounded between &minus;1 and 1:</p>
            <ul style="color:var(--text-secondary);line-height:2;padding-left:1.25rem;margin:0.5rem 0;">
                <li><strong>sin(x) = 2</strong> &mdash; No solution (|2| &gt; 1)</li>
                <li><strong>cos(x) = &minus;3</strong> &mdash; No solution (|&minus;3| &gt; 1)</li>
                <li><strong>csc(x) = 0.5</strong> &mdash; No solution (|csc| &ge; 1 always)</li>
            </ul>
            <p style="color:var(--text-secondary);line-height:1.7;margin-top:0.5rem;">Our solver automatically detects these cases and reports &ldquo;No Solution&rdquo; with an explanation.</p>
        </div>

        <!-- 4. Trig Inequalities -->
        <div class="tool-card trig-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Solving Trigonometric Inequalities</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">A <strong>trig inequality</strong> asks for the set of all angles where a trig expression is greater than (or less than) a value. The solution is typically one or more <strong>intervals</strong> that repeat with the function&rsquo;s period.</p>

            <ol style="color:var(--text-secondary);line-height:2.2;padding-left:1.25rem;margin:0 0 1rem;">
                <li><strong>Solve the corresponding equation</strong> (replace &gt; with =) to find critical points.</li>
                <li><strong>Plot on the unit circle</strong> or sketch the function graph to identify regions.</li>
                <li><strong>Test a point</strong> in each interval to determine where the inequality holds.</li>
                <li><strong>Write in interval notation</strong> and add periodicity for the general solution.</li>
            </ol>

            <h3 style="font-size:1rem;margin:0.5rem 0 0.5rem;color:var(--text-primary);">Worked Example: sin(x) &gt; 1/2</h3>
            <div class="trig-worked-example">
                <strong>1.</strong> Solve sin(x) = 1/2 &rarr; x = &pi;/6 and x = 5&pi;/6<br>
                <strong>2.</strong> sin(x) &gt; 1/2 between these critical points (where sine curve is above y = 1/2)<br>
                <strong>3.</strong> Test x = &pi;/2: sin(&pi;/2) = 1 &gt; 1/2 &#10003;<br>
                <strong>4.</strong> Solution in [0, 2&pi;): <strong>(&pi;/6, 5&pi;/6)</strong><br>
                <strong>5.</strong> General: <strong>(&pi;/6 + 2n&pi;, &nbsp; 5&pi;/6 + 2n&pi;)</strong>, &nbsp; n &isin; &integers;
            </div>
        </div>

        <!-- 5. Simplifying Trig Expressions -->
        <div class="tool-card trig-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Simplifying Trigonometric Expressions</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">Simplification means rewriting a trig expression in a <strong>more compact equivalent form</strong>. The goal is fewer terms, lower powers, or a single trig function. Common strategies:</p>

            <table class="trig-ops-table">
                <thead><tr><th>Strategy</th><th>Example Before</th><th>Example After</th></tr></thead>
                <tbody>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Pythagorean substitution</td><td>sin&sup2;x + cos&sup2;x + tan&sup2;x</td><td>1 + tan&sup2;x = sec&sup2;x</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Factor difference of squares</td><td>(sin&sup4;x &minus; cos&sup4;x) / (sin&sup2;x &minus; cos&sup2;x)</td><td>1</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Convert to sin/cos</td><td>sec x &middot; sin x</td><td>tan x</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Double angle</td><td>2 sin x cos x</td><td>sin(2x)</td></tr>
                </tbody>
            </table>

            <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">Worked Example: Simplify (sin&sup4;x &minus; cos&sup4;x) / (sin&sup2;x &minus; cos&sup2;x)</h3>
            <div class="trig-worked-example">
                <strong>1.</strong> Numerator is a difference of squares: sin&sup4;x &minus; cos&sup4;x = (sin&sup2;x + cos&sup2;x)(sin&sup2;x &minus; cos&sup2;x)<br>
                <strong>2.</strong> Since sin&sup2;x + cos&sup2;x = 1: numerator = 1 &middot; (sin&sup2;x &minus; cos&sup2;x) = sin&sup2;x &minus; cos&sup2;x<br>
                <strong>3.</strong> (sin&sup2;x &minus; cos&sup2;x) / (sin&sup2;x &minus; cos&sup2;x) = <strong>1</strong><br>
                <strong>Verify:</strong> at x = &pi;/4: ((&radic;2/2)&sup4; &minus; (&radic;2/2)&sup4;) / ((&radic;2/2)&sup2; &minus; (&radic;2/2)&sup2;) = 0/0 (undefined at &pi;/4, try x = &pi;/6):<br>
                &nbsp;&nbsp;Numerator: (1/2)&sup4; &minus; (&radic;3/2)&sup4; = 1/16 &minus; 9/16 = &minus;8/16 = &minus;1/2<br>
                &nbsp;&nbsp;Denominator: (1/2)&sup2; &minus; (&radic;3/2)&sup2; = 1/4 &minus; 3/4 = &minus;1/2<br>
                &nbsp;&nbsp;Result: (&minus;1/2) / (&minus;1/2) = 1 &#10003;
            </div>
        </div>

        <!-- 6. FAQ -->
        <div class="tool-card trig-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">How do I solve trig equations step by step?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">Enter the equation like sin(x)=1/2 or 2cos^2(x)-1=0. For simple forms, solutions are computed client-side instantly. For complex equations, our AI solver provides step-by-step solutions with all solutions in [0, 2&pi;) and the general solution with periodicity.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">What is the general solution of a trig equation?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">Since trig functions are periodic, equations have infinitely many solutions. The general solution uses +2n&pi; for sine and cosine or +n&pi; for tangent, where n is any integer. We show both specific solutions in [0, 2&pi;) and the general form.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">Can the solver handle trig inequalities?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">Yes, switch to Inequality mode and enter inequalities like sin(x)&gt;1/2 or cos(x)&le;0. The solver finds critical points, tests intervals, and expresses the solution set in interval notation with periodicity.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">How does trig simplification work?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">Enter any trig expression. The solver applies Pythagorean, double angle, and other identities step by step. It first attempts a client-side simplification using Nerdamer, then falls back to AI if needed. The final result is verified by evaluating both forms at a specific angle.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">What if my equation has no solution?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">The solver detects impossible equations like sin(x)=2 (since sine ranges from &minus;1 to 1) and impossible inequalities like sin(x)&gt;2. It reports &ldquo;No Solution&rdquo; with an explanation of the function&rsquo;s range.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">What equation types are supported?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">Simple forms (sin(x)=k, cos(x)=k, tan(x)=k), quadratic forms (2cos&sup2;x&minus;1=0), multi-function equations (sin(2x)=cos(x)), product equations (sinx&middot;cosx=1/2), and any combination using standard trig notation. Both degree and radian output formats are supported.</div></div>
        </div>
    </section>

    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="trigonometric-equation-solver.jsp"/>
        <jsp:param name="keyword" value="trigonometry"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <%@ include file="modern/components/support-section.jsp" %>

    <footer class="page-footer"><div class="footer-content"><p class="footer-text">&copy; 2026 8gwifi.org - Free Online Tools</p><div class="footer-links"><a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a><a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a></div></div></footer>

    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <script>
    function toggleFaq(btn){var i=btn.parentElement;var a=i.querySelector('.faq-answer');i.classList.toggle('open');}
    </script>
    <script>
    (function(){var els=document.querySelectorAll('.trig-anim');if(!els.length)return;var io=new IntersectionObserver(function(entries){entries.forEach(function(e){if(e.isIntersecting){e.target.classList.add('trig-visible');io.unobserve(e.target);}});},{threshold:0.15});els.forEach(function(el){io.observe(el);});})();
    </script>
    <script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/nerdamer.core.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Algebra.js"></script>
    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/trig-common.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/trig-graph.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/trig-export.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/trig-equation-core.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
</body>
</html>
