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
        <jsp:param name="toolName" value="Trigonometric Function Calculator Online - Unit Circle & Values" />
        <jsp:param name="toolDescription" value="Free trigonometric function calculator with step-by-step solutions. Evaluate sin, cos, tan, csc, sec, cot instantly. Find quadrants, reference angles, coterminal angles with interactive unit circle." />
        <jsp:param name="toolCategory" value="Mathematics" />
        <jsp:param name="toolUrl" value="trigonometric-function-calculator.jsp" />
        <jsp:param name="toolKeywords" value="trigonometric function calculator, trig calculator online, evaluate sin cos tan, unit circle calculator, quadrant calculator, reference angle calculator, coterminal angles, special angle values, ASTC rule, trig values table" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Evaluate all 6 trig functions at any angle,Exact values for special angles (0 30 45 60 90),Quadrant and reference angle finder,Coterminal angle calculator with general formula,Interactive unit circle visualization,Step-by-step solutions with LaTeX,Python SymPy code generation,Degree and radian support" />
        <jsp:param name="teaches" value="Trigonometric functions, unit circle, reference angles, coterminal angles, quadrant signs, ASTC rule, special angle values, radians and degrees" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Enter Expression|Type a trig function like sin(45) cos(pi/3) or tan(60) in the input field,Select Unit|Choose Degrees or Radians using the angle unit toggle,Choose Mode|Select Evaluate to compute values or Quadrant to find quadrant info or Coterminal to find coterminal angles,Click Calculate|Press the Calculate button to see step-by-step solutions with exact values,View Graph|Switch to Graph tab to see the unit circle or function plot visualization,Export Code|Switch to Python tab to get SymPy code you can run in any Python environment" />
        <jsp:param name="faq1q" value="How do I evaluate trig functions at any angle?" />
        <jsp:param name="faq1a" value="Enter the trig function and angle like sin(45) or cos(pi/3). For special angles (0, 30, 45, 60, 90 degrees and their multiples), you get exact values with radicals. For other angles, you get decimal approximations. Toggle between degrees and radians." />
        <jsp:param name="faq2q" value="How do I find the quadrant of an angle?" />
        <jsp:param name="faq2a" value="Switch to Quadrant mode and enter any angle. The calculator normalizes it to 0-360 degrees, tells you the quadrant (Q1-Q4), shows the reference angle, and displays the signs of all 6 trig functions using the ASTC rule (All Students Take Calculus)." />
        <jsp:param name="faq3q" value="What are coterminal angles?" />
        <jsp:param name="faq3a" value="Coterminal angles share the same terminal side on the unit circle. They differ by multiples of 360 degrees (or 2 pi radians). For example 30, 390, and -330 degrees are all coterminal. Our calculator shows 3 positive and 3 negative coterminal angles for any input." />
        <jsp:param name="faq4q" value="What are the exact values of trig functions for special angles?" />
        <jsp:param name="faq4a" value="Special angles (0, 30, 45, 60, 90 degrees) have exact trig values using fractions and square roots. For example sin(30)=1/2, cos(45)=sqrt(2)/2, tan(60)=sqrt(3). This calculator shows all 6 function values for every special angle." />
        <jsp:param name="faq5q" value="What is the ASTC rule for trigonometry?" />
        <jsp:param name="faq5a" value="ASTC stands for All Students Take Calculus. It tells which trig functions are positive in each quadrant: Q1 All positive, Q2 Sine positive, Q3 Tangent positive, Q4 Cosine positive. The reciprocal functions follow: csc with sin, sec with cos, cot with tan." />
        <jsp:param name="faq6q" value="How do I convert between degrees and radians?" />
        <jsp:param name="faq6a" value="To convert degrees to radians multiply by pi/180. To convert radians to degrees multiply by 180/pi. For example 90 degrees = pi/2 radians and pi/3 radians = 60 degrees. Our calculator accepts both units with a single toggle." />
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
                <h1 class="tool-page-title">Trigonometric Function Calculator</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                    Trig Function Calculator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">Step-by-Step</span>
                <span class="tool-badge">3 Modes</span>
                <span class="tool-badge">Unit Circle</span>
                <span class="tool-badge">Free &middot; No Signup</span>
            </div>
        </div>
    </header>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Free online <strong>trig function calculator</strong> with <strong>step-by-step solutions</strong>. Evaluate sin, cos, tan, csc, sec, cot at any angle. Find <strong>quadrants</strong>, <strong>reference angles</strong>, and <strong>coterminal angles</strong> with an interactive <strong>unit circle</strong>. Supports degrees and radians.</p>
            </div>
        </div>
    </section>

    <main class="tool-page-container">
        <!-- ==================== INPUT COLUMN ==================== -->
        <div class="tool-input-column">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;">
                        <text x="2" y="18" font-size="14" font-weight="700" fill="currentColor" font-family="serif" stroke="none">sin</text>
                    </svg>
                    Trig Function Calculator
                </div>
                <div class="tool-card-body">
                    <!-- Mode Toggle -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Mode</label>
                        <div class="trig-mode-toggle">
                            <button type="button" class="trig-mode-btn active" data-mode="evaluate">Evaluate</button>
                            <button type="button" class="trig-mode-btn" data-mode="quadrant">Quadrant</button>
                            <button type="button" class="trig-mode-btn" data-mode="coterminal">Coterminal</button>
                        </div>
                    </div>

                    <!-- Expression Input -->
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="trig-expr">Expression / Angle</label>
                        <input type="text" class="trig-input-text" id="trig-expr" value="sin(45)" autocomplete="off" spellcheck="false" placeholder="e.g. sin(45), 210, pi/3">
                        <div class="tool-form-hint">Evaluate: sin(45), cos(pi/3) &bull; Quadrant/Coterminal: 210, 750</div>
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
                    <button type="button" class="tool-action-btn" id="trig-calc-btn">Calculate</button>
                    <button type="button" class="tool-action-btn" id="trig-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);margin-top:0.5rem;">Clear</button>

                    <hr class="trig-sep">

                    <!-- Quick Examples -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Quick Examples</label>
                        <div class="trig-examples">
                            <button type="button" class="trig-example-chip" data-example="eval-sin45">sin(45&deg;)</button>
                            <button type="button" class="trig-example-chip" data-example="eval-cospi3">cos(&pi;/3)</button>
                            <button type="button" class="trig-example-chip" data-example="eval-tan60">tan(60&deg;)</button>
                            <button type="button" class="trig-example-chip" data-example="quad-210">Quadrant 210&deg;</button>
                            <button type="button" class="trig-example-chip" data-example="coterm-750">Coterminal 750&deg;</button>
                        </div>
                    </div>

                    <!-- Related Tools -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Related Tools</label>
                        <div class="trig-related">
                            <a href="<%=request.getContextPath()%>/trigonometric-identity-calculator.jsp" class="trig-related-link">Trig Identities</a>
                            <a href="<%=request.getContextPath()%>/trigonometric-equation-solver.jsp" class="trig-related-link">Trig Equations</a>
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
                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">sin &theta;</div>
                            <h3>Enter a trig expression and click Calculate</h3>
                            <p>Evaluate trig functions, find quadrants, or calculate coterminal angles.</p>
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
                        <h4>Unit Circle / Graph</h4>
                    </div>
                    <div style="flex:1;min-height:0;padding:0.75rem;">
                        <div id="trig-graph-container"></div>
                        <p id="trig-graph-hint" style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">Calculate to see the graph.</p>
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

        <!-- 1. Understanding Trig Functions -->
        <div class="tool-card trig-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Understanding Trigonometric Functions</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">The six trigonometric functions &mdash; <strong>sine</strong>, <strong>cosine</strong>, <strong>tangent</strong>, <strong>cosecant</strong>, <strong>secant</strong>, and <strong>cotangent</strong> &mdash; relate angles to ratios of sides in a right triangle. On the <strong>unit circle</strong> (a circle with radius 1 centered at the origin), for any angle &theta; the coordinates of the terminal point are (<em>cos &theta;</em>, <em>sin &theta;</em>). These functions are foundational in physics, engineering, signal processing, and navigation.</p>

            <div class="trig-feature-grid">
                <div class="trig-feature-card trig-anim trig-anim-d1">
                    <h4>Primary Functions</h4>
                    <p><strong>sin &theta;</strong> = opposite / hypotenuse<br><strong>cos &theta;</strong> = adjacent / hypotenuse<br><strong>tan &theta;</strong> = opposite / adjacent</p>
                </div>
                <div class="trig-feature-card trig-anim trig-anim-d2">
                    <h4>Reciprocal Functions</h4>
                    <p><strong>csc &theta;</strong> = 1/sin &theta;<br><strong>sec &theta;</strong> = 1/cos &theta;<br><strong>cot &theta;</strong> = 1/tan &theta;</p>
                </div>
                <div class="trig-feature-card trig-anim trig-anim-d3">
                    <h4>Key Relationships</h4>
                    <p>sin&sup2;&theta; + cos&sup2;&theta; = 1<br>tan &theta; = sin &theta; / cos &theta;<br>Period: sin, cos = 2&pi;; tan = &pi;</p>
                </div>
            </div>

            <!-- Animated Sine Wave -->
            <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">The Sine Wave &mdash; The Shape of Sound, Light &amp; Electricity</h3>
            <svg class="trig-wave-animated" viewBox="0 0 500 120" xmlns="http://www.w3.org/2000/svg" style="width:100%;max-width:500px;">
                <rect x="0" y="0" width="500" height="120" rx="8" fill="var(--bg-secondary,#f8fafc)"/>
                <line x1="30" y1="60" x2="480" y2="60" stroke="var(--border,#e2e8f0)" stroke-width="1" stroke-dasharray="4"/>
                <text x="15" y="64" font-size="10" fill="var(--text-muted,#94a3b8)">0</text>
                <text x="10" y="24" font-size="10" fill="var(--text-muted,#94a3b8)">1</text>
                <text x="5" y="104" font-size="10" fill="var(--text-muted,#94a3b8)">&minus;1</text>
                <text x="132" y="76" font-size="9" fill="var(--text-muted,#94a3b8)">&pi;/2</text>
                <text x="245" y="76" font-size="9" fill="var(--text-muted,#94a3b8)">&pi;</text>
                <text x="350" y="76" font-size="9" fill="var(--text-muted,#94a3b8)">3&pi;/2</text>
                <text x="455" y="76" font-size="9" fill="var(--text-muted,#94a3b8)">2&pi;</text>
                <path class="wave-path" d="M30,60 C75,60 90,15 142,15 C195,15 210,60 255,60 C300,60 315,105 367,105 C420,105 435,60 480,60" fill="none" stroke="#7c3aed" stroke-width="2.5" stroke-linecap="round"/>
            </svg>
            <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.6;margin-top:0.5rem;">The sine function oscillates between &minus;1 and 1, completing one full cycle every 2&pi; radians (360&deg;). This wave shape appears everywhere: sound waves, AC electricity, electromagnetic radiation, and pendulum motion.</p>
        </div>

        <!-- 2. The Unit Circle -->
        <div class="tool-card trig-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">The Unit Circle &mdash; Foundation of Trigonometry</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">The <strong>unit circle</strong> is a circle of radius 1 centered at the origin. Every point on it can be written as (cos &theta;, sin &theta;). The unit circle extends trigonometric functions beyond right triangles to <strong>all real angles</strong>, including negative angles and angles greater than 360&deg;.</p>

            <!-- Animated Unit Circle SVG -->
            <svg class="trig-unit-circle-animated" viewBox="0 0 280 280" xmlns="http://www.w3.org/2000/svg" style="display:block;margin:1rem auto;">
                <rect x="0" y="0" width="280" height="280" rx="8" fill="var(--bg-secondary,#f8fafc)"/>
                <circle cx="140" cy="140" r="100" fill="none" stroke="var(--border,#e2e8f0)" stroke-width="1.5"/>
                <line x1="30" y1="140" x2="250" y2="140" stroke="var(--border,#e2e8f0)" stroke-width="0.75"/>
                <line x1="140" y1="30" x2="140" y2="250" stroke="var(--border,#e2e8f0)" stroke-width="0.75"/>
                <!-- Quadrant labels -->
                <text x="185" y="95" font-size="11" fill="var(--text-muted,#94a3b8)" font-weight="600">Q1</text>
                <text x="80" y="95" font-size="11" fill="var(--text-muted,#94a3b8)" font-weight="600">Q2</text>
                <text x="80" y="200" font-size="11" fill="var(--text-muted,#94a3b8)" font-weight="600">Q3</text>
                <text x="185" y="200" font-size="11" fill="var(--text-muted,#94a3b8)" font-weight="600">Q4</text>
                <!-- Special angle dots -->
                <circle cx="240" cy="140" r="3" fill="#7c3aed" opacity="0.5"/><text x="245" y="136" font-size="8" fill="#7c3aed">0&deg;</text>
                <circle cx="227" cy="90" r="3" fill="#7c3aed" opacity="0.5"/><text x="232" y="88" font-size="8" fill="#7c3aed">30&deg;</text>
                <circle cx="211" cy="69" r="3" fill="#7c3aed" opacity="0.5"/><text x="214" y="65" font-size="8" fill="#7c3aed">45&deg;</text>
                <circle cx="190" cy="53" r="3" fill="#7c3aed" opacity="0.5"/><text x="192" y="48" font-size="8" fill="#7c3aed">60&deg;</text>
                <circle cx="140" cy="40" r="3" fill="#7c3aed" opacity="0.5"/><text x="145" y="36" font-size="8" fill="#7c3aed">90&deg;</text>
                <!-- Animated ray -->
                <line class="uc-ray" x1="140" y1="140" x2="240" y2="140" stroke="#7c3aed" stroke-width="2" opacity="0.7"/>
                <circle class="uc-dot" cx="240" cy="140" r="5" fill="#7c3aed"/>
                <!-- Axis labels -->
                <text x="252" y="148" font-size="9" fill="var(--text-secondary,#475569)" font-weight="600">(1,0)</text>
                <text x="130" y="32" font-size="9" fill="var(--text-secondary,#475569)" font-weight="600">(0,1)</text>
                <text x="10" y="148" font-size="9" fill="var(--text-secondary,#475569)" font-weight="600">(&minus;1,0)</text>
                <text x="120" y="264" font-size="9" fill="var(--text-secondary,#475569)" font-weight="600">(0,&minus;1)</text>
            </svg>

            <div class="trig-formula-box">
                For any angle &theta;: &nbsp; x = cos &theta;, &nbsp; y = sin &theta;, &nbsp; tan &theta; = y/x
            </div>

            <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">Degrees vs Radians</h3>
            <p style="color:var(--text-secondary);line-height:1.7;margin-bottom:0.5rem;">Radians measure angles using the arc length on the unit circle. One full revolution = 2&pi; radians = 360&deg;. To convert: <strong>radians = degrees &times; &pi;/180</strong> and <strong>degrees = radians &times; 180/&pi;</strong>.</p>
            <table class="trig-ops-table">
                <thead><tr><th>Degrees</th><th>Radians</th><th>Fraction of Circle</th></tr></thead>
                <tbody>
                    <tr><td>0&deg;</td><td>0</td><td>0</td></tr>
                    <tr><td>30&deg;</td><td>&pi;/6</td><td>1/12</td></tr>
                    <tr><td>45&deg;</td><td>&pi;/4</td><td>1/8</td></tr>
                    <tr><td>60&deg;</td><td>&pi;/3</td><td>1/6</td></tr>
                    <tr><td>90&deg;</td><td>&pi;/2</td><td>1/4</td></tr>
                    <tr><td>180&deg;</td><td>&pi;</td><td>1/2</td></tr>
                    <tr><td>360&deg;</td><td>2&pi;</td><td>1</td></tr>
                </tbody>
            </table>
        </div>

        <!-- 3. Special Angles -->
        <div class="tool-card trig-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Special Angle Values &mdash; The Numbers You Must Know</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">The angles 0&deg;, 30&deg;, 45&deg;, 60&deg;, and 90&deg; produce <strong>exact trig values</strong> using simple fractions and square roots. Memorizing this table is essential for precalculus, calculus, and standardized tests. All other quadrant values can be derived from these using the reference angle and ASTC sign rule.</p>

            <div style="overflow-x:auto;">
                <table class="trig-ops-table">
                    <thead><tr><th>Angle</th><th>sin</th><th>cos</th><th>tan</th><th>csc</th><th>sec</th><th>cot</th></tr></thead>
                    <tbody>
                        <tr><td>0&deg;</td><td>0</td><td>1</td><td>0</td><td>undef</td><td>1</td><td>undef</td></tr>
                        <tr><td>30&deg;</td><td>1/2</td><td>&radic;3/2</td><td>1/&radic;3</td><td>2</td><td>2/&radic;3</td><td>&radic;3</td></tr>
                        <tr><td>45&deg;</td><td>&radic;2/2</td><td>&radic;2/2</td><td>1</td><td>&radic;2</td><td>&radic;2</td><td>1</td></tr>
                        <tr><td>60&deg;</td><td>&radic;3/2</td><td>1/2</td><td>&radic;3</td><td>2/&radic;3</td><td>2</td><td>1/&radic;3</td></tr>
                        <tr><td>90&deg;</td><td>1</td><td>0</td><td>undef</td><td>1</td><td>undef</td><td>0</td></tr>
                    </tbody>
                </table>
            </div>

            <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">Memory Trick &mdash; The &radic;n/2 Pattern</h3>
            <p style="color:var(--text-secondary);line-height:1.7;">For sine values of special angles: sin(0&deg;) = &radic;0/2 = 0, sin(30&deg;) = &radic;1/2 = 1/2, sin(45&deg;) = &radic;2/2, sin(60&deg;) = &radic;3/2, sin(90&deg;) = &radic;4/2 = 1. Notice the pattern under the radical goes 0, 1, 2, 3, 4. The cosine values are the <strong>same sequence reversed</strong>.</p>
        </div>

        <!-- 4. ASTC Rule & Quadrants -->
        <div class="tool-card trig-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">ASTC Rule &mdash; Signs of Trig Functions by Quadrant</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">The mnemonic <strong>&ldquo;All Students Take Calculus&rdquo;</strong> (ASTC) tells you which trig functions are positive in each quadrant. This is critical when evaluating trig functions for angles beyond the first quadrant.</p>

            <div class="trig-feature-grid">
                <div class="trig-feature-card trig-anim trig-anim-d1">
                    <h4>Q1 (0&deg;&ndash;90&deg;) &mdash; All</h4>
                    <p>All 6 trig functions are <strong style="color:#16a34a;">positive</strong>. Both x and y coordinates are positive.</p>
                </div>
                <div class="trig-feature-card trig-anim trig-anim-d2">
                    <h4>Q2 (90&deg;&ndash;180&deg;) &mdash; Sine</h4>
                    <p>Only <strong style="color:#16a34a;">sin</strong> and <strong style="color:#16a34a;">csc</strong> are positive. x is negative, y is positive.</p>
                </div>
                <div class="trig-feature-card trig-anim trig-anim-d3">
                    <h4>Q3 (180&deg;&ndash;270&deg;) &mdash; Tangent</h4>
                    <p>Only <strong style="color:#16a34a;">tan</strong> and <strong style="color:#16a34a;">cot</strong> are positive. Both x and y are negative.</p>
                </div>
                <div class="trig-feature-card trig-anim trig-anim-d4">
                    <h4>Q4 (270&deg;&ndash;360&deg;) &mdash; Cosine</h4>
                    <p>Only <strong style="color:#16a34a;">cos</strong> and <strong style="color:#16a34a;">sec</strong> are positive. x is positive, y is negative.</p>
                </div>
            </div>

            <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">Reference Angles</h3>
            <p style="color:var(--text-secondary);line-height:1.7;">The <strong>reference angle</strong> is the acute angle (&lt; 90&deg;) between the terminal side and the x-axis. It lets you reduce any angle to a first-quadrant problem:</p>
            <div class="trig-worked-example" style="margin-top:0.5rem;">
                <strong>Example:</strong> Evaluate sin(150&deg;)<br>
                <strong>1.</strong> 150&deg; is in Q2 &rarr; reference angle = 180&deg; &minus; 150&deg; = 30&deg;<br>
                <strong>2.</strong> sin(30&deg;) = 1/2<br>
                <strong>3.</strong> In Q2, sine is positive (ASTC: S)<br>
                <strong>4.</strong> sin(150&deg;) = +1/2 &nbsp; &#10003;
            </div>
        </div>

        <!-- 5. Coterminal Angles -->
        <div class="tool-card trig-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Coterminal Angles &mdash; Same Direction, Different Rotations</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">Two angles are <strong>coterminal</strong> if they share the same terminal side on the unit circle. This means they have <strong>identical trig function values</strong>. You find coterminal angles by adding or subtracting full rotations:</p>
            <div class="trig-formula-box">
                &theta;<sub>coterminal</sub> = &theta; + 360&deg; &times; n &nbsp;&nbsp; (or &theta; + 2&pi;n), &nbsp; where n is any integer
            </div>
            <div class="trig-worked-example" style="margin-top:0.75rem;">
                <strong>Example:</strong> Find coterminal angles of 750&deg;<br>
                <strong>1.</strong> Normalize: 750&deg; &minus; 2 &times; 360&deg; = 750&deg; &minus; 720&deg; = 30&deg;<br>
                <strong>2.</strong> Positive: 30&deg; + 360&deg; = 390&deg;, &nbsp; 30&deg; + 720&deg; = 750&deg;, &nbsp; 30&deg; + 1080&deg; = 1110&deg;<br>
                <strong>3.</strong> Negative: 30&deg; &minus; 360&deg; = &minus;330&deg;, &nbsp; 30&deg; &minus; 720&deg; = &minus;690&deg;, &nbsp; 30&deg; &minus; 1080&deg; = &minus;1050&deg;<br>
                <strong>All share:</strong> sin = 1/2, cos = &radic;3/2, tan = 1/&radic;3
            </div>
        </div>

        <!-- 6. FAQ -->
        <div class="tool-card trig-anim" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">How do I evaluate trig functions at any angle?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">Enter the trig function and angle like sin(45) or cos(pi/3). For special angles (0&deg;, 30&deg;, 45&deg;, 60&deg;, 90&deg; and their multiples), you get exact values with radicals. For other angles, you get decimal approximations. Toggle between degrees and radians using the unit button.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">How do I find the quadrant of an angle?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">Switch to Quadrant mode and enter any angle. The calculator normalizes it to 0&ndash;360&deg;, tells you the quadrant (Q1&ndash;Q4), shows the reference angle, and displays the signs of all 6 trig functions using the ASTC rule.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">What are coterminal angles?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">Coterminal angles share the same terminal side on the unit circle. They differ by multiples of 360&deg; (or 2&pi; radians). For example, 30&deg;, 390&deg;, and &minus;330&deg; are all coterminal and have identical trig values.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">What are the exact values for special angles?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">Special angles (0&deg;, 30&deg;, 45&deg;, 60&deg;, 90&deg;) produce exact trig values using fractions and square roots. For example: sin(30&deg;) = 1/2, cos(45&deg;) = &radic;2/2, tan(60&deg;) = &radic;3. This calculator shows all 6 function values for every special angle.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">What is the ASTC rule?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">ASTC stands for &ldquo;All Students Take Calculus.&rdquo; It tells which trig functions are positive in each quadrant: Q1 = All positive, Q2 = Sine (and csc), Q3 = Tangent (and cot), Q4 = Cosine (and sec).</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">How do I convert between degrees and radians?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">To convert degrees to radians: multiply by &pi;/180. To convert radians to degrees: multiply by 180/&pi;. For example, 90&deg; = &pi;/2 radians, and &pi;/3 radians = 60&deg;. Our calculator accepts both units with a single toggle.</div></div>
        </div>
    </section>

    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="trigonometric-function-calculator.jsp"/>
        <jsp:param name="keyword" value="mathematics"/>
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
    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/trig-common.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/trig-graph.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/trig-export.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/trig-evaluator-core.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
</body>
</html>
