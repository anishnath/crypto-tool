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

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdn.jsdelivr.net">
    <link rel="dns-prefetch" href="https://cdn.plot.ly">

    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/diophantine-solver.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript><link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/diophantine-solver.css?v=<%=cacheVersion%>"></noscript>

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Diophantine Equation Solver &bull; With Steps &amp; Graph" />
        <jsp:param name="toolDescription" value="Free Diophantine equation solver with step-by-step solutions. Solve linear ax+by=c, systems, quadratic (sums of squares, Pell), and modular congruences. Extended Euclidean algorithm, Bezout identity, Chinese Remainder Theorem. No signup." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="diophantine-solver.jsp" />
        <jsp:param name="toolKeywords" value="diophantine equation solver, linear diophantine equation, integer solutions calculator, extended euclidean algorithm, bezout identity, ax+by=c solver, modular arithmetic solver, chinese remainder theorem, pell equation solver, sum of two squares, quadratic diophantine equation, number theory calculator, gcd solver, modular inverse calculator, congruence solver, diophantine equation with steps" />
        <jsp:param name="educationalLevel" value="High School, College" />
        <jsp:param name="teaches" value="Diophantine equations, extended Euclidean algorithm, Bezout identity, greatest common divisor, linear congruences, modular inverse, Chinese Remainder Theorem, Pell equation, sums of squares, number theory, integer solutions" />
        <jsp:param name="howToSteps" value="Select equation type|Choose Linear (ax+by=c), System, Quadratic (x^2+y^2=n), or Modular (ax=b mod m),Enter coefficients|Type the integer coefficients for your equation,Click Solve|Compute integer solutions with step-by-step extended Euclidean algorithm breakdown,View result &amp; graph|See solution lattice points on a graph and export LaTeX or Python code" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Linear Diophantine equation solver (ax+by=c),System of 2 linear Diophantine equations,Quadratic Diophantine: sums of squares and Pell equation,Modular congruence solver with Chinese Remainder Theorem,Step-by-step extended Euclidean algorithm,Bezout identity and GCD computation,General parametric solution display,Integer lattice point graph (Plotly),Copy LaTeX and Download PDF,Built-in Python compiler with SymPy,Quick presets for classic problems,Dark mode support,Free and no signup required" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What is a Diophantine equation?" />
        <jsp:param name="faq1a" value="A Diophantine equation is a polynomial equation where only integer solutions are sought. Named after the ancient Greek mathematician Diophantus of Alexandria, these equations are fundamental in number theory. The simplest form is the linear Diophantine equation ax + by = c, where a, b, c are given integers and we seek integer x, y. Solutions exist if and only if gcd(a,b) divides c." />
        <jsp:param name="faq2q" value="What is the extended Euclidean algorithm?" />
        <jsp:param name="faq2a" value="The extended Euclidean algorithm finds integers x and y such that ax + by = gcd(a,b). It extends the standard Euclidean algorithm by tracking the back-substitution. This gives a particular solution to ax + by = c (when gcd(a,b)|c), and the general solution is x = x0 + (b/d)t, y = y0 - (a/d)t for any integer t, where d = gcd(a,b)." />
        <jsp:param name="faq3q" value="What is Bezout's identity?" />
        <jsp:param name="faq3a" value="Bezout's identity states that for any integers a and b (not both zero), there exist integers x and y such that ax + by = gcd(a,b). The extended Euclidean algorithm constructively finds these Bezout coefficients. This identity is the theoretical foundation for solving linear Diophantine equations and computing modular inverses." />
        <jsp:param name="faq4q" value="When does ax + by = c have integer solutions?" />
        <jsp:param name="faq4a" value="The linear Diophantine equation ax + by = c has integer solutions if and only if gcd(a,b) divides c. If d = gcd(a,b) divides c, then there are infinitely many solutions parameterized by an integer t: x = x0 + (b/d)t, y = y0 - (a/d)t, where (x0, y0) is any particular solution found via the extended Euclidean algorithm." />
        <jsp:param name="faq5q" value="What is a Pell equation?" />
        <jsp:param name="faq5a" value="A Pell equation is x^2 - Dy^2 = 1, where D is a positive non-square integer. It always has infinitely many solutions. The fundamental (smallest positive) solution can be found using continued fractions. All other solutions are generated by the recurrence x_{n+1} = x1*xn + D*y1*yn, y_{n+1} = x1*yn + y1*xn." />
        <jsp:param name="faq6q" value="What is the Chinese Remainder Theorem?" />
        <jsp:param name="faq6a" value="The Chinese Remainder Theorem (CRT) states that if m1, m2, ..., mk are pairwise coprime, then the system of congruences x = a1 (mod m1), x = a2 (mod m2), ..., x = ak (mod mk) has a unique solution modulo M = m1*m2*...*mk. This is used to solve systems of modular equations and has applications in cryptography (RSA) and computer science." />
        <jsp:param name="faq7q" value="How do I find the modular inverse of a?" />
        <jsp:param name="faq7a" value="The modular inverse of a modulo m is an integer x such that ax = 1 (mod m). It exists if and only if gcd(a,m) = 1. You can find it using the extended Euclidean algorithm: solve ax + my = 1, then x (mod m) is the inverse. This calculator automatically computes modular inverses when solving congruences." />
        <jsp:param name="faq8q" value="Is this Diophantine equation solver free?" />
        <jsp:param name="faq8a" value="Yes, completely free with no registration. Features include: step-by-step extended Euclidean algorithm, Bezout identity computation, general parametric solutions, integer lattice point graphs, 4 equation types (linear, system, quadratic, modular), LaTeX export, PDF download, shareable URLs, and a built-in Python compiler with SymPy. All features are available without any paywall." />
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
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css">
    </noscript>

    <%@ include file="modern/ads/ad-init.jsp" %>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">
</head>
<body>
<%@ include file="modern/components/nav-header.jsp" %>

<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">Diophantine Equation Solver</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/math">Math Tools</a> /
                Diophantine Equation Solver
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">4 Equation Types</span>
            <span class="tool-badge">Step-by-Step</span>
            <span class="tool-badge">Integer Solutions</span>
            <span class="tool-badge">Free &middot; No Signup</span>
        </div>
    </div>
</header>

<section class="tool-description-section">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>Solve <strong>Diophantine equations</strong> with step-by-step solutions: <strong>Linear</strong> (ax+by=c) via extended Euclidean algorithm, <strong>Systems</strong> of two linear Diophantine equations, <strong>Quadratic</strong> (sums of squares x&sup2;+y&sup2;=n, Pell equation x&sup2;&minus;Dy&sup2;=1), and <strong>Modular congruences</strong> (ax&equiv;b mod m) with Chinese Remainder Theorem. Interactive integer lattice graphs. Built-in Python compiler with SymPy.</p>
        </div>
    </div>
</section>

<main class="tool-page-container">
    <div class="tool-input-column">
        <div class="tool-card">
            <div class="tool-card-header">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;">
                    <circle cx="12" cy="12" r="10"/>
                    <path d="M8 12h8M12 8v8"/>
                </svg>
                Diophantine Solver
            </div>
            <div class="tool-card-body">
                <div class="dio-mode-toggle">
                    <button type="button" class="dio-mode-btn active" data-mode="linear">Linear (ax+by=c)</button>
                    <button type="button" class="dio-mode-btn" data-mode="system">System</button>
                    <button type="button" class="dio-mode-btn" data-mode="quadratic">Quadratic</button>
                    <button type="button" class="dio-mode-btn" data-mode="modular">Modular</button>
                </div>

                <!-- Linear: ax + by = c -->
                <div id="dio-linear-wrap">
                    <div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:0.5rem;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="dio-linear-a">a</label>
                            <input type="text" class="tool-input tool-input-mono" id="dio-linear-a" value="6" placeholder="6">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="dio-linear-b">b</label>
                            <input type="text" class="tool-input tool-input-mono" id="dio-linear-b" value="9" placeholder="9">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="dio-linear-c">c</label>
                            <input type="text" class="tool-input tool-input-mono" id="dio-linear-c" value="15" placeholder="15">
                        </div>
                    </div>
                    <span class="tool-form-hint">Find integer x, y such that ax + by = c</span>
                </div>

                <!-- System: ax+by=c, dx+ey=f -->
                <div id="dio-system-wrap" style="display:none;">
                    <p class="tool-form-hint" style="margin-bottom:0.75rem;">Equation 1: a<sub>1</sub>x + b<sub>1</sub>y = c<sub>1</sub></p>
                    <div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:0.5rem;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="dio-sys-a1">a<sub>1</sub></label>
                            <input type="text" class="tool-input tool-input-mono" id="dio-sys-a1" value="2" placeholder="2">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="dio-sys-b1">b<sub>1</sub></label>
                            <input type="text" class="tool-input tool-input-mono" id="dio-sys-b1" value="3" placeholder="3">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="dio-sys-c1">c<sub>1</sub></label>
                            <input type="text" class="tool-input tool-input-mono" id="dio-sys-c1" value="7" placeholder="7">
                        </div>
                    </div>
                    <p class="tool-form-hint" style="margin-top:0.75rem;margin-bottom:0.75rem;">Equation 2: a<sub>2</sub>x + b<sub>2</sub>y = c<sub>2</sub></p>
                    <div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:0.5rem;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="dio-sys-a2">a<sub>2</sub></label>
                            <input type="text" class="tool-input tool-input-mono" id="dio-sys-a2" value="4" placeholder="4">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="dio-sys-b2">b<sub>2</sub></label>
                            <input type="text" class="tool-input tool-input-mono" id="dio-sys-b2" value="5" placeholder="5">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="dio-sys-c2">c<sub>2</sub></label>
                            <input type="text" class="tool-input tool-input-mono" id="dio-sys-c2" value="11" placeholder="11">
                        </div>
                    </div>
                    <span class="tool-form-hint">Find integer x, y satisfying both equations simultaneously</span>
                </div>

                <!-- Quadratic -->
                <div id="dio-quadratic-wrap" style="display:none;">
                    <div class="tool-form-group">
                        <label class="tool-form-label">Equation type</label>
                        <select class="tool-input" id="dio-quad-type">
                            <option value="sum_squares">Sum of squares: x&sup2; + y&sup2; = n</option>
                            <option value="pell">Pell equation: x&sup2; &minus; Dy&sup2; = 1</option>
                            <option value="general">General: ax&sup2; + bxy + cy&sup2; = n</option>
                        </select>
                    </div>
                    <div id="dio-quad-sum-wrap">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="dio-quad-n">n</label>
                            <input type="text" class="tool-input tool-input-mono" id="dio-quad-n" value="50" placeholder="50">
                        </div>
                    </div>
                    <div id="dio-quad-pell-wrap" style="display:none;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="dio-quad-D">D (positive, non-square)</label>
                            <input type="text" class="tool-input tool-input-mono" id="dio-quad-D" value="2" placeholder="2">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="dio-quad-pell-count">Number of solutions</label>
                            <input type="number" class="tool-input" id="dio-quad-pell-count" value="8" min="1" max="20">
                        </div>
                    </div>
                    <div id="dio-quad-general-wrap" style="display:none;">
                        <div style="display:grid;grid-template-columns:1fr 1fr 1fr 1fr;gap:0.5rem;">
                            <div class="tool-form-group">
                                <label class="tool-form-label" for="dio-quad-ga">a</label>
                                <input type="text" class="tool-input tool-input-mono" id="dio-quad-ga" value="1" placeholder="1">
                            </div>
                            <div class="tool-form-group">
                                <label class="tool-form-label" for="dio-quad-gb">b (xy coeff)</label>
                                <input type="text" class="tool-input tool-input-mono" id="dio-quad-gb" value="0" placeholder="0">
                            </div>
                            <div class="tool-form-group">
                                <label class="tool-form-label" for="dio-quad-gc">c</label>
                                <input type="text" class="tool-input tool-input-mono" id="dio-quad-gc" value="1" placeholder="1">
                            </div>
                            <div class="tool-form-group">
                                <label class="tool-form-label" for="dio-quad-gn">n</label>
                                <input type="text" class="tool-input tool-input-mono" id="dio-quad-gn" value="25" placeholder="25">
                            </div>
                        </div>
                        <span class="tool-form-hint">ax&sup2; + bxy + cy&sup2; = n</span>
                    </div>
                </div>

                <!-- Modular: ax ≡ b (mod m) -->
                <div id="dio-modular-wrap" style="display:none;">
                    <div class="tool-form-group">
                        <label class="tool-form-label">Congruence type</label>
                        <select class="tool-input" id="dio-mod-type">
                            <option value="single">Single: ax &equiv; b (mod m)</option>
                            <option value="system">System (CRT): x &equiv; a<sub>i</sub> (mod m<sub>i</sub>)</option>
                        </select>
                    </div>
                    <div id="dio-mod-single-wrap">
                        <div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:0.5rem;">
                            <div class="tool-form-group">
                                <label class="tool-form-label" for="dio-mod-a">a</label>
                                <input type="text" class="tool-input tool-input-mono" id="dio-mod-a" value="7" placeholder="7">
                            </div>
                            <div class="tool-form-group">
                                <label class="tool-form-label" for="dio-mod-b">b</label>
                                <input type="text" class="tool-input tool-input-mono" id="dio-mod-b" value="3" placeholder="3">
                            </div>
                            <div class="tool-form-group">
                                <label class="tool-form-label" for="dio-mod-m">m</label>
                                <input type="text" class="tool-input tool-input-mono" id="dio-mod-m" value="15" placeholder="15">
                            </div>
                        </div>
                        <span class="tool-form-hint">Find x such that ax &equiv; b (mod m)</span>
                    </div>
                    <div id="dio-mod-system-wrap" style="display:none;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="dio-mod-remainders">Remainders a<sub>i</sub> (comma-separated)</label>
                            <input type="text" class="tool-input tool-input-mono" id="dio-mod-remainders" value="2, 3, 1" placeholder="2, 3, 1">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="dio-mod-moduli">Moduli m<sub>i</sub> (comma-separated, pairwise coprime)</label>
                            <input type="text" class="tool-input tool-input-mono" id="dio-mod-moduli" value="3, 5, 7" placeholder="3, 5, 7">
                        </div>
                        <span class="tool-form-hint">Chinese Remainder Theorem: x &equiv; a<sub>i</sub> (mod m<sub>i</sub>)</span>
                    </div>
                </div>

                <div class="dio-preview" id="dio-preview">
                    <span style="color:var(--text-muted);font-size:0.8125rem;">6x + 9y = 15</span>
                </div>

                <div class="dio-action-row">
                    <button type="button" class="tool-action-btn dio-compute-btn" id="dio-compute-btn">Solve</button>
                    <button type="button" class="dio-random-btn" id="dio-random-btn" title="Random preset">&#127922; Random</button>
                </div>

                <!-- Export Buttons -->
                <div class="dio-export-row" id="dio-export-row" style="display:none;">
                    <button type="button" class="dio-export-btn" id="dio-copy-latex-btn" title="Copy LaTeX">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px;"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 01-2-2V4a2 2 0 012-2h9a2 2 0 012 2v1"/></svg>
                        LaTeX
                    </button>
                    <button type="button" class="dio-export-btn" id="dio-download-pdf-btn" title="Download PDF">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px;"><path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                        PDF
                    </button>
                    <button type="button" class="dio-export-btn" id="dio-share-btn" title="Share URL">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px;"><circle cx="18" cy="5" r="3"/><circle cx="6" cy="12" r="3"/><circle cx="18" cy="19" r="3"/><line x1="8.59" y1="13.51" x2="15.42" y2="17.49"/><line x1="15.41" y1="6.51" x2="8.59" y2="10.49"/></svg>
                        Share
                    </button>
                </div>

                <hr class="dio-sep">

                <div class="tool-form-group">
                    <label class="tool-form-label">Quick Presets</label>
                    <div class="dio-examples" id="dio-examples"></div>
                </div>

                <!-- Reference Table -->
                <div class="dio-formulas-toggle" id="dio-formulas-toggle">
                    <span>Reference: Diophantine Equations</span>
                    <svg class="dio-formulas-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;transition:transform 0.2s;">
                        <polyline points="6 9 12 15 18 9"/>
                    </svg>
                </div>
                <div class="dio-formulas-content" id="dio-formulas-content" style="display:none;">
                    <table class="dio-formulas-table">
                        <thead><tr><th>Type</th><th>Equation</th><th>Method</th></tr></thead>
                        <tbody>
                            <tr><td>Linear</td><td id="dio-formula-f0"></td><td id="dio-formula-m0"></td></tr>
                            <tr><td>System</td><td id="dio-formula-f1"></td><td id="dio-formula-m1"></td></tr>
                            <tr><td>Sum of Squares</td><td id="dio-formula-f2"></td><td id="dio-formula-m2"></td></tr>
                            <tr><td>Pell</td><td id="dio-formula-f3"></td><td id="dio-formula-m3"></td></tr>
                            <tr><td>Congruence</td><td id="dio-formula-f4"></td><td id="dio-formula-m4"></td></tr>
                            <tr><td>CRT System</td><td id="dio-formula-f5"></td><td id="dio-formula-m5"></td></tr>
                        </tbody>
                    </table>
                </div>

                <!-- Syntax Help -->
                <div class="dio-syntax-toggle" id="dio-syntax-toggle">
                    <span>Syntax Help</span>
                    <svg class="dio-formulas-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;transition:transform 0.2s;">
                        <polyline points="6 9 12 15 18 9"/>
                    </svg>
                </div>
                <div class="dio-syntax-content" id="dio-syntax-content" style="display:none;">
                    <div style="font-size:0.8125rem;color:var(--text-secondary);line-height:1.7;padding:0.75rem;">
                        <p><strong>Linear mode</strong>: Enter integers a, b, c. The solver finds all integer (x, y) satisfying ax + by = c using the extended Euclidean algorithm.</p>
                        <p style="margin-top:0.5rem;"><strong>System mode</strong>: Enter two equations. The solver checks if a common integer solution (x, y) exists using Cramer-like integer methods.</p>
                        <p style="margin-top:0.5rem;"><strong>Quadratic mode</strong>: Choose sum of squares (x&sup2;+y&sup2;=n), Pell (x&sup2;&minus;Dy&sup2;=1), or general quadratic form. Brute-force search and SymPy.</p>
                        <p style="margin-top:0.5rem;"><strong>Modular mode</strong>: Solve ax&equiv;b (mod m), or use CRT for systems of congruences. Comma-separated remainders and moduli.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="tool-output-column">
        <div class="dio-output-tabs">
            <button type="button" class="dio-output-tab active" data-panel="result">Result</button>
            <button type="button" class="dio-output-tab" data-panel="graph">Graph</button>
            <button type="button" class="dio-output-tab" data-panel="python">Python</button>
        </div>

        <div class="dio-panel active" id="dio-panel-result">
            <div class="tool-card tool-result-card">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                    </svg>
                    <h4>Result</h4>
                </div>
                <div class="tool-result-content" id="dio-result-content">
                    <div class="tool-empty-state" id="dio-empty-state">
                        <div class="dio-empty-icon">ax+by=c</div>
                        <h3>Select an equation type and click Solve</h3>
                        <p>Solve linear, quadratic, and modular Diophantine equations with step-by-step solutions.</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="dio-panel" id="dio-panel-graph">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/>
                        <line x1="6" y1="20" x2="6" y2="14"/>
                    </svg>
                    <h4>Integer Solutions Graph</h4>
                </div>
                <div style="flex:1;min-height:0;padding:0.75rem;">
                    <div id="dio-graph-container"></div>
                    <p id="dio-graph-hint" style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">Solve an equation to see integer solution points.</p>
                </div>
            </div>
        </div>

        <div class="dio-panel" id="dio-panel-python">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <polygon points="5 3 19 12 5 21 5 3"/>
                    </svg>
                    <h4>Python Compiler</h4>
                </div>
                <div style="flex:1;min-height:0;">
                    <iframe id="dio-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                </div>
            </div>
        </div>
    </div>

    <div class="tool-ads-column">
        <%@ include file="modern/ads/ad-three-column.jsp" %>
    </div>
</main>

<div class="tool-mobile-ad-container">
    <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
</div>

<jsp:include page="modern/components/related-tools.jsp">
    <jsp:param name="currentToolUrl" value="diophantine-solver.jsp"/>
    <jsp:param name="keyword" value="algebra"/>
    <jsp:param name="limit" value="6"/>
</jsp:include>

<!-- Educational Content -->
<section class="tool-expertise-section" style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">What is a Diophantine Equation?</h2>
        <p style="color: var(--text-secondary); margin-bottom: 0.75rem; line-height: 1.7;">A <strong>Diophantine equation</strong> is a polynomial equation where only <strong>integer solutions</strong> are sought. Named after Diophantus of Alexandria (circa 250 AD), these equations are central to <strong>number theory</strong>. The simplest form is the <strong>linear Diophantine equation</strong> ax + by = c. A solution exists if and only if gcd(a,b) divides c. The <strong>extended Euclidean algorithm</strong> finds a particular solution, and the general solution is parameterized by an integer t.</p>
    </div>

    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">Extended Euclidean Algorithm &amp; Bezout's Identity</h2>
        <p style="color: var(--text-secondary); margin-bottom: 0.75rem; line-height: 1.7;"><strong>Bezout's identity</strong> states that for any integers a, b (not both zero), there exist integers x, y such that ax + by = gcd(a,b). The <strong>extended Euclidean algorithm</strong> constructively finds these <strong>Bezout coefficients</strong>. Starting from the standard Euclidean algorithm divisions, it back-substitutes to express gcd(a,b) as a linear combination of a and b. This gives a particular solution (x<sub>0</sub>, y<sub>0</sub>), and the general solution is x = x<sub>0</sub> + (b/d)t, y = y<sub>0</sub> &minus; (a/d)t, where d = gcd(a,b).</p>
    </div>

    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">Pell Equations &amp; Continued Fractions</h2>
        <p style="color: var(--text-secondary); margin-bottom: 0.75rem; line-height: 1.7;">The <strong>Pell equation</strong> x&sup2; &minus; Dy&sup2; = 1 (D positive, non-square) always has infinitely many solutions. The <strong>fundamental solution</strong> (smallest positive x<sub>1</sub>, y<sub>1</sub>) can be found via the continued fraction expansion of &radic;D. All other solutions follow the recurrence x<sub>n+1</sub> = x<sub>1</sub>x<sub>n</sub> + Dy<sub>1</sub>y<sub>n</sub>, y<sub>n+1</sub> = x<sub>1</sub>y<sub>n</sub> + y<sub>1</sub>x<sub>n</sub>. Pell equations appear in approximating irrational numbers and in algebraic number theory.</p>
    </div>

    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">Modular Arithmetic &amp; Chinese Remainder Theorem</h2>
        <p style="color: var(--text-secondary); margin-bottom: 0.75rem; line-height: 1.7;">A <strong>linear congruence</strong> ax &equiv; b (mod m) has solutions when gcd(a,m) divides b. The solution is found via the <strong>modular inverse</strong> of a, computed using the extended Euclidean algorithm. The <strong>Chinese Remainder Theorem</strong> (CRT) solves systems of congruences x &equiv; a<sub>i</sub> (mod m<sub>i</sub>) when the moduli are pairwise coprime, giving a unique solution modulo the product of all moduli. CRT is foundational in cryptography (RSA), coding theory, and distributed computing.</p>
    </div>

    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">Sums of Two Squares</h2>
        <p style="color: var(--text-secondary); margin-bottom: 0.75rem; line-height: 1.7;">Fermat's theorem on sums of two squares states that an odd prime p can be expressed as x&sup2; + y&sup2; if and only if p &equiv; 1 (mod 4). More generally, a positive integer n is a sum of two squares if and only if every prime factor of the form 4k+3 appears to an even power in the factorization of n. Finding all representations x&sup2; + y&sup2; = n is a classic algorithmic problem solved by brute-force search or Cornacchia's algorithm.</p>
    </div>

    <!-- Visible FAQ Accordion -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);" id="faqs">Frequently Asked Questions</h2>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is a Diophantine equation?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">A Diophantine equation is a polynomial equation where only <strong>integer solutions</strong> are sought. Named after the ancient Greek mathematician Diophantus of Alexandria, these equations are fundamental in number theory. The simplest form is the linear Diophantine equation ax + by = c, where a, b, c are given integers and we seek integer x, y. Solutions exist if and only if gcd(a,b) divides c.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the extended Euclidean algorithm?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The extended Euclidean algorithm finds integers x and y such that ax + by = gcd(a,b). It extends the standard Euclidean algorithm by tracking the back-substitution. This gives a particular solution to ax + by = c (when gcd(a,b)|c), and the general solution is x = x<sub>0</sub> + (b/d)t, y = y<sub>0</sub> &minus; (a/d)t for any integer t, where d = gcd(a,b).</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is Bezout's identity?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer"><strong>Bezout's identity</strong> states that for any integers a and b (not both zero), there exist integers x and y such that ax + by = gcd(a,b). The extended Euclidean algorithm constructively finds these Bezout coefficients. This identity is the theoretical foundation for solving linear Diophantine equations and computing modular inverses.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                When does ax + by = c have integer solutions?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The linear Diophantine equation ax + by = c has integer solutions if and only if gcd(a,b) divides c. If d = gcd(a,b) divides c, then there are <strong>infinitely many solutions</strong> parameterized by an integer t: x = x<sub>0</sub> + (b/d)t, y = y<sub>0</sub> &minus; (a/d)t, where (x<sub>0</sub>, y<sub>0</sub>) is any particular solution found via the extended Euclidean algorithm.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is a Pell equation?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">A Pell equation is x&sup2; &minus; Dy&sup2; = 1, where D is a positive non-square integer. It always has infinitely many solutions. The fundamental (smallest positive) solution can be found using continued fractions. All other solutions are generated by the recurrence x<sub>n+1</sub> = x<sub>1</sub>x<sub>n</sub> + Dy<sub>1</sub>y<sub>n</sub>, y<sub>n+1</sub> = x<sub>1</sub>y<sub>n</sub> + y<sub>1</sub>x<sub>n</sub>.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the Chinese Remainder Theorem?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The <strong>Chinese Remainder Theorem</strong> (CRT) states that if m<sub>1</sub>, m<sub>2</sub>, &hellip;, m<sub>k</sub> are pairwise coprime, then the system x &equiv; a<sub>1</sub> (mod m<sub>1</sub>), &hellip;, x &equiv; a<sub>k</sub> (mod m<sub>k</sub>) has a unique solution modulo M = m<sub>1</sub>&middot;m<sub>2</sub>&middot;&hellip;&middot;m<sub>k</sub>. This is used to solve systems of modular equations and has applications in cryptography (RSA) and computer science.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How do I find the modular inverse of a?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The modular inverse of a modulo m is an integer x such that ax &equiv; 1 (mod m). It exists if and only if gcd(a,m) = 1. You can find it using the extended Euclidean algorithm: solve ax + my = 1, then x (mod m) is the inverse. This calculator automatically computes modular inverses when solving congruences.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Is this Diophantine equation solver free?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes, <strong>completely free</strong> with no registration or signup required. Features include: step-by-step extended Euclidean algorithm, Bezout identity computation, general parametric solutions, integer lattice point graphs, 4 equation types (linear, system, quadratic, modular), LaTeX export, PDF download, shareable URLs, and a built-in Python compiler with SymPy. All features are available without any paywall or usage limits.</div>
        </div>
    </div>

    <!-- Explore More Math -->
    <div class="tool-card" style="padding: 1.5rem 2rem; margin-bottom: 1.5rem;">
        <h3 style="font-size: 1.15rem; font-weight: 600; margin: 0 0 1rem; color: var(--text-primary);">Explore More Math &amp; Science Tools</h3>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 1rem;">
            <a href="<%=request.getContextPath()%>/polynomial-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: border-color 0.15s;">
                <div style="width: 2.5rem; height: 2.5rem; background: linear-gradient(135deg, #0d9488, #14b8a6); border-radius: 0.5rem; display: flex; align-items: center; justify-content: center; color: #fff; font-weight: 700; font-size: 0.75rem; flex-shrink: 0;">P(x)</div>
                <div>
                    <div style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary);">Polynomial Calculator</div>
                    <div style="font-size: 0.8125rem; color: var(--text-secondary);">Factor, roots, long division with steps</div>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/quadratic-solver.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: border-color 0.15s;">
                <div style="width: 2.5rem; height: 2.5rem; background: linear-gradient(135deg, #7c3aed, #a78bfa); border-radius: 0.5rem; display: flex; align-items: center; justify-content: center; color: #fff; font-weight: 700; font-size: 0.875rem; flex-shrink: 0;">x&sup2;</div>
                <div>
                    <div style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary);">Quadratic Equation Solver</div>
                    <div style="font-size: 0.8125rem; color: var(--text-secondary);">Formula, completing the square, graph</div>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/linear-equations-solver.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: border-color 0.15s;">
                <div style="width: 2.5rem; height: 2.5rem; background: linear-gradient(135deg, #2563eb, #3b82f6); border-radius: 0.5rem; display: flex; align-items: center; justify-content: center; color: #fff; font-weight: 700; font-size: 0.75rem; flex-shrink: 0;">Ax=b</div>
                <div>
                    <div style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary);">System of Equations Solver</div>
                    <div style="font-size: 0.8125rem; color: var(--text-secondary);">2x2, 3x3, 4x4 with steps</div>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/matrix-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: border-color 0.15s;">
                <div style="width: 2.5rem; height: 2.5rem; background: linear-gradient(135deg, #dc2626, #f87171); border-radius: 0.5rem; display: flex; align-items: center; justify-content: center; color: #fff; font-weight: 700; font-size: 0.75rem; flex-shrink: 0;">[A]</div>
                <div>
                    <div style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary);">Matrix Calculator</div>
                    <div style="font-size: 0.8125rem; color: var(--text-secondary);">Eigenvalues, inverse, determinant, SVD</div>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/derivative-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: border-color 0.15s;">
                <div style="width: 2.5rem; height: 2.5rem; background: linear-gradient(135deg, #7c3aed, #a78bfa); border-radius: 0.5rem; display: flex; align-items: center; justify-content: center; color: #fff; font-weight: 700; font-size: 0.875rem; flex-shrink: 0;">d/dx</div>
                <div>
                    <div style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary);">Derivative Calculator</div>
                    <div style="font-size: 0.8125rem; color: var(--text-secondary);">Symbolic derivatives with steps</div>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/integral-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: border-color 0.15s;">
                <div style="width: 2.5rem; height: 2.5rem; background: linear-gradient(135deg, #059669, #34d399); border-radius: 0.5rem; display: flex; align-items: center; justify-content: center; color: #fff; font-weight: 700; font-size: 1rem; flex-shrink: 0;">&int;</div>
                <div>
                    <div style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary);">Integral Calculator</div>
                    <div style="font-size: 0.8125rem; color: var(--text-secondary);">Definite &amp; indefinite integrals with steps</div>
                </div>
            </a>
        </div>
    </div>
</section>

<%@ include file="modern/components/support-section.jsp" %>

<footer class="page-footer">
    <div class="footer-content">
        <p class="footer-text">&copy; 2025 8gwifi.org - Free Online Tools</p>
        <div class="footer-links">
            <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
            <a href="<%=request.getContextPath()%>/math/" class="footer-link">Math Tools</a>
            <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
        </div>
    </div>
</footer>

<%@ include file="modern/ads/ad-sticky-footer.jsp" %>
<%@ include file="modern/components/analytics.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
<script>
    var __plotlyLoaded = false;
    function loadPlotly(cb) {
        if (__plotlyLoaded) { if (cb) cb(); return; }
        var s = document.createElement('script');
        s.src = 'https://cdn.plot.ly/plotly-2.27.0.min.js';
        s.onload = function() { __plotlyLoaded = true; if (cb) cb(); };
        document.head.appendChild(s);
    }
</script>

<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

<script>window.DIO_CALC_CTX = "<%=request.getContextPath()%>";</script>
<script src="<%=request.getContextPath()%>/modern/js/diophantine-solver.js?v=<%=cacheVersion%>"></script>
</body>
</html>
