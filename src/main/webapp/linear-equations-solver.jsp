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
    <meta name="resource-type" content="document">
    <meta name="language" content="en">
    <meta name="author" content="Anish Nath">
    <meta name="context-path" content="<%=request.getContextPath()%>">

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="System of Equations Calculator with Steps" />
        <jsp:param name="toolDescription" value="Free system of equations solver with step-by-step solutions. Solve linear systems using Gaussian elimination, Gauss-Jordan RREF, LU decomposition, Cramer's rule, and matrix inverse. Shows every row operation. Interactive 2D/3D graphs, Python compiler, LaTeX export. Solve up to 10x10 matrices instantly in your browser." />
        <jsp:param name="toolCategory" value="Mathematics" />
        <jsp:param name="toolUrl" value="linear-equations-solver.jsp" />
        <jsp:param name="toolKeywords" value="system of equations calculator, system of equations solver, linear equations solver, gaussian elimination calculator, gauss jordan elimination calculator, RREF calculator, matrix equation solver, solve system of equations step by step, Ax=b solver, cramer's rule calculator, LU decomposition calculator, augmented matrix calculator, least squares calculator, simultaneous equations solver, matrix solver online free" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Solve systems of equations step by step,Gaussian elimination with row operations,Gauss-Jordan RREF calculator,LU decomposition solver,Cramer's rule calculator,Matrix inverse method (x = A^-1 b),Least squares for overdetermined systems,Polynomial system solver (Newton-Raphson),Interactive 2D/3D Plotly graphs,Built-in Python NumPy/SymPy compiler,LaTeX export and shareable URLs,Matrix grid and text input modes,Supports up to 10x10 systems" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="How do I solve a system of equations online?" />
        <jsp:param name="faq1a" value="Enter your coefficient matrix A and constants vector b (or use the matrix grid), select a method like Gaussian elimination, and click Solve. The calculator shows every step: row operations, augmented matrix transformations, and back-substitution. Works for 2x2, 3x3, and systems up to 10x10." />
        <jsp:param name="faq2q" value="What is Gaussian elimination and how does it work?" />
        <jsp:param name="faq2a" value="Gaussian elimination transforms a system of equations into row echelon form using three operations: swapping rows, multiplying a row by a nonzero constant, and adding a multiple of one row to another. Once in row echelon form, back-substitution finds each variable from bottom to top. This calculator shows every row operation with the augmented matrix at each step." />
        <jsp:param name="faq3q" value="What is the difference between Gaussian elimination and Gauss-Jordan?" />
        <jsp:param name="faq3a" value="Gaussian elimination creates zeros below each pivot (row echelon form), then uses back-substitution. Gauss-Jordan goes further, eliminating above and below each pivot to produce reduced row echelon form (RREF), where the solution can be read directly without back-substitution. Both give the same answer; Gauss-Jordan does more work upfront but simplifies the final step." />
        <jsp:param name="faq4q" value="Can this calculator solve overdetermined or underdetermined systems?" />
        <jsp:param name="faq4a" value="Yes. For overdetermined systems (more equations than unknowns), use the Least Squares method to find the best-fit solution minimizing ||Ax-b||. For underdetermined systems (fewer equations), the solver identifies free variables and expresses the solution parametrically. The 2D/3D graph tab visualizes the geometric interpretation." />
        <jsp:param name="faq5q" value="Is this system of equations calculator free?" />
        <jsp:param name="faq5a" value="Yes, completely free with no signup or limits. You get 6 solving methods with detailed steps, interactive 2D/3D graphs, a Python compiler (NumPy, SymPy, SciPy), LaTeX export, and shareable URLs. All computation runs client-side in your browser for instant results and complete privacy." />
    </jsp:include>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdn.plot.ly">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet" media="print" onload="this.media='all'">
    <noscript><link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet"></noscript>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/linear-solver.css?v=<%=cacheVersion%>">

    <%@ include file="modern/ads/ad-init.jsp" %>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">

    <style>
        .tool-action-btn { background: var(--ls-gradient) !important; }
        .tool-badge { background: var(--ls-light); color: var(--ls-tool); }
    </style>
</head>
<body>
<%@ include file="modern/components/nav-header.jsp" %>

<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">System of Equations Calculator</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/index.jsp#mathematics">Mathematics</a> /
                System of Equations Solver
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">Free Online</span>
            <span class="tool-badge">6 Methods</span>
            <span class="tool-badge">Step-by-Step</span>
        </div>
    </div>
</header>

<section class="tool-description-section" style="background:var(--ls-light);">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>Free <strong>system of equations solver</strong> with <strong>step-by-step solutions</strong>. Solve using <strong>Gaussian elimination</strong>, Gauss-Jordan RREF, LU decomposition, Cramer's rule, matrix inverse, and least squares. Shows every row operation. Enter as text, matrix grid, or polynomial equations. Interactive 2D/3D graphs and built-in Python compiler.</p>
        </div>
    </div>
</section>

<main class="tool-page-container">
    <!-- ==================== INPUT COLUMN ==================== -->
    <div class="tool-input-column">
        <div class="tool-card">
            <div class="tool-card-header" style="background:var(--ls-gradient);">System of Equations</div>
            <div class="tool-card-body">

                <!-- Input Mode Toggle -->
                <div class="tool-form-group" style="margin-bottom:0.5rem;">
                    <label class="tool-form-label">Input Mode</label>
                    <div class="ls-input-mode-toggle">
                        <button type="button" class="ls-input-mode-btn active" data-mode="text">Text</button>
                        <button type="button" class="ls-input-mode-btn" data-mode="grid">Matrix Grid</button>
                        <button type="button" class="ls-input-mode-btn" data-mode="polynomial">Polynomial</button>
                    </div>
                </div>

                <!-- Dimensions (for text/grid) -->
                <div id="ls-dims-section">
                    <div class="tool-form-group">
                        <label class="tool-form-label">Dimensions</label>
                        <div class="ls-dim-row">
                            <input type="number" class="ls-dim-input" id="ls-num-equations" min="1" max="10" value="3" aria-label="Number of equations">
                            <span class="ls-dim-x">equations</span>
                            <span class="ls-dim-x">&times;</span>
                            <input type="number" class="ls-dim-input" id="ls-num-variables" min="1" max="10" value="3" aria-label="Number of variables">
                            <span class="ls-dim-x">variables</span>
                            <button type="button" class="ls-example-chip" id="ls-random-btn" style="margin-left:auto">Random</button>
                        </div>
                        <div class="tool-form-hint" id="ls-system-hint">Square system (m = n)</div>
                    </div>
                </div>

                <!-- Text Input Mode -->
                <div id="ls-text-input">
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="ls-matrix-a">Coefficient Matrix A</label>
                        <textarea class="tool-input" id="ls-matrix-a" rows="4" placeholder="2 1 -1&#10;-3 -1 2&#10;-2 1 2" style="font-family:var(--font-mono);font-size:0.8125rem;resize:vertical"></textarea>
                        <div class="tool-form-hint">One row per line, space or comma separated</div>
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="ls-vector-b">Constants Vector b</label>
                        <textarea class="tool-input" id="ls-vector-b" rows="3" placeholder="8&#10;-11&#10;-3" style="font-family:var(--font-mono);font-size:0.8125rem;resize:vertical"></textarea>
                        <div class="tool-form-hint">One value per line</div>
                    </div>
                </div>

                <!-- Grid Input Mode -->
                <div id="ls-grid-input" style="display:none">
                    <div class="tool-form-group">
                        <label class="tool-form-label">Augmented Matrix [A | b]</label>
                        <div id="ls-matrix-grid" style="overflow-x:auto;padding:0.5rem 0;"></div>
                    </div>
                </div>

                <!-- Polynomial Input Mode -->
                <div id="ls-poly-input" style="display:none">
                    <div class="tool-form-group">
                        <label class="tool-form-label">Number of Variables</label>
                        <select class="ls-method-select" id="ls-poly-vars">
                            <option value="2">2 variables (x, y)</option>
                            <option value="3">3 variables (x, y, z)</option>
                        </select>
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="ls-poly-equations">Equations (one per line)</label>
                        <textarea class="tool-input" id="ls-poly-equations" rows="4" placeholder="x^2 + y^2 = 25&#10;x + y = 7" style="font-family:var(--font-mono);font-size:0.8125rem;resize:vertical"></textarea>
                        <div class="tool-form-hint">Use x, y, z as variables. Supported: +, -, *, ^, parentheses, sqrt(), sin(), cos()</div>
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="ls-poly-guess">Initial Guess</label>
                        <input type="text" class="tool-input" id="ls-poly-guess" placeholder="1, 1" value="1, 1" style="font-family:var(--font-mono);font-size:0.8125rem">
                        <div class="tool-form-hint">Starting point for Newton-Raphson (comma separated). Try different guesses for multiple solutions.</div>
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label">Try an Example</label>
                        <div class="ls-examples">
                            <button type="button" class="ls-example-chip" data-example="poly-circle-line">Circle &cap; Line</button>
                            <button type="button" class="ls-example-chip" data-example="poly-two-parabolas">Two Parabolas</button>
                            <button type="button" class="ls-example-chip" data-example="poly-ellipse-hyperbola">Ellipse &cap; Hyperbola</button>
                            <button type="button" class="ls-example-chip" data-example="poly-3var">3D Surfaces</button>
                            <button type="button" class="ls-example-chip" data-example="poly-trig">Trigonometric</button>
                        </div>
                    </div>
                </div>

                <!-- Method Selector -->
                <div class="tool-form-group">
                    <label class="tool-form-label" for="ls-method">Solution Method</label>
                    <select class="ls-method-select" id="ls-method">
                        <option value="gaussian">Gaussian Elimination</option>
                        <option value="gauss-jordan">Gauss-Jordan (RREF)</option>
                        <option value="lu">LU Decomposition</option>
                        <option value="cramer">Cramer's Rule</option>
                        <option value="inverse">Matrix Inverse</option>
                        <option value="least-squares">Least Squares</option>
                    </select>
                    <div class="tool-form-hint" id="ls-method-hint"></div>
                </div>

                <!-- Action Buttons -->
                <div style="display:flex;gap:0.5rem;">
                    <button type="button" class="tool-action-btn" id="ls-solve-btn" style="flex:1">Solve System</button>
                    <button type="button" class="tool-action-btn" id="ls-clear-btn" style="flex:0;min-width:60px;background:var(--bg-secondary)!important;color:var(--text-secondary);border:1px solid var(--border)">Clear</button>
                </div>

                <hr style="border:none;border-top:1px solid var(--border);margin:1rem 0">

                <!-- Quick Examples -->
                <div class="tool-form-group">
                    <label class="tool-form-label">Quick Examples</label>
                    <div class="ls-examples">
                        <button type="button" class="ls-example-chip" data-example="unique-3x3">3&times;3 Unique</button>
                        <button type="button" class="ls-example-chip" data-example="2d-system">2D System</button>
                        <button type="button" class="ls-example-chip" data-example="overdetermined">Overdetermined</button>
                        <button type="button" class="ls-example-chip" data-example="underdetermined">Underdetermined</button>
                        <button type="button" class="ls-example-chip" data-example="cramer-2x2">Cramer 2&times;2</button>
                        <button type="button" class="ls-example-chip" data-example="lu-3x3">LU 3&times;3</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ==================== OUTPUT COLUMN ==================== -->
    <div class="tool-output-column">
        <!-- Tab bar -->
        <div class="ls-output-tabs">
            <button type="button" class="ls-output-tab active" data-panel="result">Result</button>
            <button type="button" class="ls-output-tab" data-panel="graph">Graph</button>
            <button type="button" class="ls-output-tab" data-panel="python">Python Compiler</button>
        </div>

        <!-- Result Panel -->
        <div class="ls-panel active" id="ls-panel-result">
            <div class="tool-card tool-result-card">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--ls-tool);">
                        <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                    </svg>
                    <h4>Result</h4>
                </div>
                <div class="tool-result-content" id="ls-result-content">
                    <div class="tool-empty-state" id="ls-empty-state">
                        <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">Ax=b</div>
                        <h3>Enter a system of equations</h3>
                        <p>Solve with 6 methods. Step-by-step solutions, interactive graph, Python code.</p>
                    </div>
                </div>
                <div class="tool-result-actions" id="ls-result-actions" style="display:none;gap:0.5rem;padding:1rem;border-top:1px solid var(--border);flex-wrap:wrap">
                    <button type="button" class="tool-action-btn" id="ls-copy-latex-btn">Copy LaTeX</button>
                    <button type="button" class="tool-action-btn" id="ls-share-btn">Share</button>
                </div>
            </div>
            <div id="ls-verify-area"></div>
            <div id="ls-steps-area" style="margin-top:1rem"></div>
        </div>

        <!-- Graph Panel -->
        <div class="ls-panel" id="ls-panel-graph">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--ls-tool);">
                        <line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/>
                    </svg>
                    <h4>Interactive Graph</h4>
                </div>
                <div style="flex:1;min-height:0;padding:0.75rem;">
                    <div id="ls-graph-container"></div>
                    <p id="ls-graph-hint" style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">Solve a system to see its graph. 2D for 2 variables, 3D for 3 variables.</p>
                </div>
            </div>
        </div>

        <!-- Python Compiler Panel -->
        <div class="ls-panel" id="ls-panel-python">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--ls-tool);">
                        <polygon points="5 3 19 12 5 21 5 3"/>
                    </svg>
                    <h4>Python Compiler</h4>
                    <select id="ls-compiler-template" style="margin-left:auto;padding:0.3rem 0.5rem;border:1px solid var(--border);border-radius:0.375rem;font-size:0.75rem;font-family:var(--font-sans);background:var(--bg-primary);color:var(--text-primary);cursor:pointer;">
                        <option value="numpy">NumPy (np.linalg.solve)</option>
                        <option value="sympy">SymPy (linsolve)</option>
                        <option value="scipy">SciPy (linalg)</option>
                    </select>
                </div>
                <div style="flex:1;min-height:0;">
                    <iframe id="ls-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                </div>
            </div>
        </div>
    </div>

    <!-- ==================== ADS COLUMN ==================== -->
    <div class="tool-ads-column">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>
</main>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/linear-solver-matrix.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/linear-solver-render.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/linear-solver-graph.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/linear-solver-export.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/linear-solver-core.js?v=<%=cacheVersion%>"></script>

<!-- Mobile Ad Fallback -->
<div class="tool-mobile-ad-container">
    <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
</div>

<!-- Related Tools -->
<jsp:include page="modern/components/related-tools.jsp">
    <jsp:param name="currentToolUrl" value="linear-equations-solver.jsp"/>
    <jsp:param name="keyword" value="mathematics"/>
    <jsp:param name="limit" value="6"/>
</jsp:include>

<!-- ========== BELOW-FOLD EDUCATIONAL CONTENT ========== -->
<section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

    <!-- ===== 1. WHAT IS A SYSTEM OF LINEAR EQUATIONS? ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);">What is a System of Linear Equations?</h2>
        <p class="ls-anim" style="color:var(--text-secondary);line-height:1.7;margin-bottom:1rem;">
            A <strong>system of linear equations</strong> is a set of equations where each unknown variable appears only to the first power (no x&sup2;, no xy products). The goal: find values that make <em>every</em> equation true at the same time. We write the entire system compactly as <strong style="color:var(--ls-tool);">Ax = b</strong>.
        </p>

        <!-- Ax = b Animated Breakdown -->
        <div class="ls-concept-hero">
            <div class="ls-concept-block">
                <div class="ls-mini-matrix cols-2 ls-c-A" style="border-color:var(--ls-tool);">
                    <span class="ls-mini-cell">2</span><span class="ls-mini-cell">1</span>
                    <span class="ls-mini-cell">1</span><span class="ls-mini-cell">3</span>
                </div>
                <div class="ls-concept-label ls-c-A">A (coefficients)</div>
            </div>
            <div class="ls-concept-block">
                <div class="ls-concept-symbol ls-c-eq" style="font-size:1.25rem;">&times;</div>
            </div>
            <div class="ls-concept-block">
                <div class="ls-mini-matrix cols-1 ls-c-x" style="border-color:#10b981;">
                    <span class="ls-mini-cell">x</span>
                    <span class="ls-mini-cell">y</span>
                </div>
                <div class="ls-concept-label ls-c-x">x (unknowns)</div>
            </div>
            <div class="ls-concept-block">
                <div class="ls-concept-symbol ls-c-eq">=</div>
            </div>
            <div class="ls-concept-block">
                <div class="ls-mini-matrix cols-1 ls-c-b" style="border-color:#f59e0b;">
                    <span class="ls-mini-cell">5</span>
                    <span class="ls-mini-cell">7</span>
                </div>
                <div class="ls-concept-label ls-c-b">b (constants)</div>
            </div>
        </div>

        <!-- What this really means -->
        <div class="ls-callout ls-callout-insight ls-anim ls-anim-d2">
            <span class="ls-callout-icon">&#128161;</span>
            <div class="ls-callout-text">
                <strong>What this really means:</strong> The matrix equation above is just a compact way of writing
                <span style="font-family:var(--font-mono);color:var(--ls-tool);">2x + 1y = 5</span> and
                <span style="font-family:var(--font-mono);color:var(--ls-tool);">1x + 3y = 7</span>.
                Each row of <strong>A</strong> holds the coefficients of one equation. The vector <strong>b</strong> holds the right-hand-side values. Solving means finding x, y that satisfy both equations simultaneously.
            </div>
        </div>

        <!-- How Solving Works: Process Flow -->
        <h3 style="font-size:1rem;font-weight:700;color:var(--text-primary);margin:1.75rem 0 0.25rem;">How Does Solving Work?</h3>
        <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;margin-bottom:0.5rem;">
            Every method follows the same core idea: systematically eliminate variables until you can read the answer directly.
        </p>

        <div class="ls-process-flow ls-anim">
            <div class="ls-process-step">
                <div class="ls-process-icon">1</div>
                <div class="ls-process-title">Write Ax = b</div>
                <div class="ls-process-desc">Organize equations into matrix form: coefficients, unknowns, constants.</div>
            </div>
            <div class="ls-process-step">
                <div class="ls-process-icon">2</div>
                <div class="ls-process-title">Augmented Matrix</div>
                <div class="ls-process-desc">Combine A and b into [A|b] to work with a single tableau.</div>
            </div>
            <div class="ls-process-step">
                <div class="ls-process-icon">3</div>
                <div class="ls-process-title">Row Operations</div>
                <div class="ls-process-desc">Swap, scale, and combine rows to create zeros below (or above) each pivot.</div>
            </div>
            <div class="ls-process-step">
                <div class="ls-process-icon">4</div>
                <div class="ls-process-title">Read Solution</div>
                <div class="ls-process-desc">Back-substitute from the last row up, or read directly from RREF.</div>
            </div>
        </div>

        <!-- Row Operation Demo -->
        <h3 style="font-size:1rem;font-weight:700;color:var(--text-primary);margin:1.75rem 0 0.5rem;">Row Operations in Action</h3>
        <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;margin-bottom:0.75rem;">
            Row operations transform the augmented matrix without changing the solution. Here's one step of Gaussian elimination &mdash; hover to see the row being eliminated:
        </p>

        <div class="ls-row-op-demo">
            <div class="ls-matrix-box">
                <div style="font-size:0.6875rem;font-weight:600;color:var(--text-muted);margin-bottom:0.375rem;text-align:center;">[A | b]</div>
                <div class="ls-row" style="color:var(--ls-tool);font-weight:600;">
                    <span>&nbsp;2</span><span>&nbsp;1</span><span style="color:var(--text-muted);margin:0 0.25rem;">|</span><span style="color:#f59e0b;">&nbsp;5</span>
                </div>
                <div class="ls-row ls-highlight-row">
                    <span>&nbsp;1</span><span>&nbsp;3</span><span style="color:var(--text-muted);margin:0 0.25rem;">|</span><span style="color:#f59e0b;">&nbsp;7</span>
                </div>
            </div>

            <div class="ls-arrow-animated">
                <div class="ls-op-label">R&#8322; = R&#8322; - &frac12;R&#8321;</div>
                <svg width="36" height="20" viewBox="0 0 36 20"><path d="M2 10h28m-6-6 6 6-6 6" fill="none" stroke="var(--ls-tool)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
            </div>

            <div class="ls-matrix-box">
                <div style="font-size:0.6875rem;font-weight:600;color:var(--text-muted);margin-bottom:0.375rem;text-align:center;">Row Echelon</div>
                <div class="ls-row" style="color:var(--ls-tool);font-weight:600;">
                    <span>&nbsp;2</span><span>&nbsp;1</span><span style="color:var(--text-muted);margin:0 0.25rem;">|</span><span style="color:#f59e0b;">&nbsp;5</span>
                </div>
                <div class="ls-row" style="color:#10b981;font-weight:600;">
                    <span>&nbsp;0</span><span>&nbsp;2.5</span><span style="color:var(--text-muted);margin:0 0.25rem;">|</span><span style="color:#f59e0b;">&nbsp;4.5</span>
                </div>
            </div>
        </div>

        <div class="ls-callout ls-callout-tip ls-anim ls-anim-d3">
            <span class="ls-callout-icon">&#9989;</span>
            <div class="ls-callout-text">
                <strong>Now back-substitute:</strong> From row 2: <span style="font-family:var(--font-mono);">2.5y = 4.5</span> &rarr; <strong>y = 1.8</strong>.
                Plug into row 1: <span style="font-family:var(--font-mono);">2x + 1.8 = 5</span> &rarr; <strong>x = 1.6</strong>.
                That's Gaussian elimination in a nutshell!
            </div>
        </div>
    </div>

    <!-- ===== 2. GEOMETRIC INTERPRETATION ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.5rem;color:var(--text-primary);">Geometric Interpretation: What Does a Solution Look Like?</h2>
        <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;margin-bottom:0.5rem;">
            In 2D, each linear equation is a <strong>line</strong>. Solving means finding where the lines meet.
            In 3D, each equation is a <strong>plane</strong>. There are exactly three possible outcomes:
        </p>

        <div class="ls-geo-viz">
            <!-- Unique Solution: Lines Cross -->
            <div class="ls-geo-card ls-anim ls-anim-d1">
                <div class="ls-geo-canvas">
                    <svg viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg" style="width:100%;height:100%;">
                        <!-- Grid -->
                        <line x1="100" y1="10" x2="100" y2="190" stroke="var(--border)" stroke-width="0.5"/>
                        <line x1="10" y1="100" x2="190" y2="100" stroke="var(--border)" stroke-width="0.5"/>
                        <!-- Line 1: 2x + y = 5 -> y = 5-2x -> at x=0: y=5, x=2.5: y=0 (scaled to grid) -->
                        <line x1="20" y1="30" x2="170" y2="160" stroke="#6366f1" stroke-width="2.5" class="ls-line-draw" stroke-linecap="round"/>
                        <!-- Line 2: x + 3y = 7 -> y = (7-x)/3 -->
                        <line x1="30" y1="170" x2="180" y2="40" stroke="#ef4444" stroke-width="2.5" class="ls-line-draw ls-line-draw-d2" stroke-linecap="round"/>
                        <!-- Intersection point -->
                        <circle cx="112" cy="102" r="0" fill="#6366f1" class="ls-dot-pop"/>
                        <circle cx="112" cy="102" r="4.5" fill="none" stroke="#6366f1" stroke-width="1.5" class="ls-dot-pulse" opacity="0"/>
                        <!-- Labels -->
                        <text x="160" y="170" font-size="11" fill="#6366f1" font-weight="600" font-family="monospace">L&#8321;</text>
                        <text x="172" y="36" font-size="11" fill="#ef4444" font-weight="600" font-family="monospace">L&#8322;</text>
                        <text x="118" y="96" font-size="9" fill="#6366f1" font-weight="600" font-family="sans-serif">(x, y)</text>
                    </svg>
                </div>
                <div class="ls-geo-info" style="border-left:3px solid #6366f1;">
                    <div class="ls-geo-title">One Solution</div>
                    <div class="ls-geo-desc">Lines intersect at exactly one point. det(A) &ne; 0.</div>
                </div>
            </div>

            <!-- No Solution: Parallel Lines -->
            <div class="ls-geo-card ls-anim ls-anim-d3">
                <div class="ls-geo-canvas">
                    <svg viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg" style="width:100%;height:100%;">
                        <line x1="100" y1="10" x2="100" y2="190" stroke="var(--border)" stroke-width="0.5"/>
                        <line x1="10" y1="100" x2="190" y2="100" stroke="var(--border)" stroke-width="0.5"/>
                        <!-- Parallel line 1 -->
                        <line x1="20" y1="40" x2="180" y2="130" stroke="#6366f1" stroke-width="2.5" class="ls-line-draw" stroke-linecap="round"/>
                        <!-- Parallel line 2 (same slope, offset) -->
                        <line x1="20" y1="80" x2="180" y2="170" stroke="#ef4444" stroke-width="2.5" class="ls-line-draw ls-line-draw-d2" stroke-linecap="round"/>
                        <!-- Gap arrows -->
                        <line x1="130" y1="98" x2="130" y2="128" stroke="var(--text-muted)" stroke-width="1" stroke-dasharray="3,2" class="ls-parallel-hint"/>
                        <text x="137" y="116" font-size="9" fill="var(--text-muted)" font-family="sans-serif" class="ls-parallel-hint">gap</text>
                        <text x="172" y="124" font-size="11" fill="#6366f1" font-weight="600" font-family="monospace">L&#8321;</text>
                        <text x="172" y="164" font-size="11" fill="#ef4444" font-weight="600" font-family="monospace">L&#8322;</text>
                    </svg>
                </div>
                <div class="ls-geo-info" style="border-left:3px solid #f59e0b;">
                    <div class="ls-geo-title">No Solution</div>
                    <div class="ls-geo-desc">Parallel lines never meet. The system is inconsistent.</div>
                </div>
            </div>

            <!-- Infinite Solutions: Same Line -->
            <div class="ls-geo-card ls-anim ls-anim-d5">
                <div class="ls-geo-canvas">
                    <svg viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg" style="width:100%;height:100%;">
                        <line x1="100" y1="10" x2="100" y2="190" stroke="var(--border)" stroke-width="0.5"/>
                        <line x1="10" y1="100" x2="190" y2="100" stroke="var(--border)" stroke-width="0.5"/>
                        <!-- Line (drawn thick, then thin on top for "two lines overlapping" effect) -->
                        <line x1="20" y1="40" x2="180" y2="160" stroke="#6366f1" stroke-width="5" stroke-linecap="round" class="ls-line-draw ls-glow-line" opacity="0.4"/>
                        <line x1="20" y1="40" x2="180" y2="160" stroke="#ef4444" stroke-width="2.5" stroke-linecap="round" class="ls-line-draw ls-line-draw-d2" stroke-dasharray="6,4"/>
                        <line x1="20" y1="40" x2="180" y2="160" stroke="#6366f1" stroke-width="2.5" stroke-linecap="round" class="ls-line-draw"/>
                        <!-- Multiple solution dots along line -->
                        <circle cx="60" cy="70" r="3" fill="#10b981" opacity="0" class="ls-dot-pop" style="animation-delay:1.2s;"/>
                        <circle cx="100" cy="100" r="3" fill="#10b981" opacity="0" class="ls-dot-pop" style="animation-delay:1.5s;"/>
                        <circle cx="140" cy="130" r="3" fill="#10b981" opacity="0" class="ls-dot-pop" style="animation-delay:1.8s;"/>
                        <text x="145" y="126" font-size="9" fill="#10b981" font-weight="600" font-family="sans-serif" opacity="0" class="ls-dot-pop" style="animation-delay:2s;">&#8734; points</text>
                    </svg>
                </div>
                <div class="ls-geo-info" style="border-left:3px solid #10b981;">
                    <div class="ls-geo-title">Infinite Solutions</div>
                    <div class="ls-geo-desc">Lines overlap completely. Every point on the line is a solution.</div>
                </div>
            </div>
        </div>

        <div class="ls-callout ls-callout-insight">
            <span class="ls-callout-icon">&#127758;</span>
            <div class="ls-callout-text">
                <strong>In 3D it's the same idea, with planes:</strong> Three planes can meet at a single point (unique), form a line of intersection (infinite), or have no common intersection at all (inconsistent). Try the <strong>Graph tab</strong> above with a 3-variable system to see the 3D plane visualization.
            </div>
        </div>
    </div>

    <!-- ===== 3. REAL-WORLD EXAMPLE ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);">Real-World Example: Mixing Solutions</h2>
        <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;margin-bottom:0;">
            A chemist needs to mix two acid solutions. Solution A is 30% acid, Solution B is 70% acid. She needs 200 mL of a 45% acid mixture. How much of each solution should she use?
        </p>

        <div class="ls-real-world">
            <div class="ls-rw-header">&#129514; Setting Up the System</div>
            <div class="ls-rw-body">
                <div>
                    <p style="margin-bottom:0.75rem;">Let <strong>x</strong> = mL of Solution A, <strong>y</strong> = mL of Solution B.</p>
                    <p style="margin-bottom:0.5rem;"><strong>Total volume:</strong> <span style="font-family:var(--font-mono);color:var(--ls-tool);">x + y = 200</span></p>
                    <p style="margin-bottom:0.5rem;"><strong>Acid balance:</strong> <span style="font-family:var(--font-mono);color:var(--ls-tool);">0.3x + 0.7y = 90</span></p>
                    <p style="font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">(90 = 200 &times; 0.45, the total acid needed)</p>
                </div>
                <div class="ls-rw-matrix">
                    <div style="margin-bottom:0.5rem;font-weight:600;color:var(--text-primary);">Matrix Form</div>
                    <div style="color:var(--ls-tool);font-weight:600;">
                        [ 1 &nbsp;&nbsp; 1 &nbsp;&nbsp;| 200 ]<br>
                        [ 0.3 0.7 | &nbsp;90 ]
                    </div>
                    <div style="margin-top:0.75rem;color:#10b981;font-weight:700;font-size:0.9375rem;">
                        x = 125 mL, y = 75 mL
                    </div>
                </div>
            </div>
        </div>

        <div class="ls-callout ls-callout-tip">
            <span class="ls-callout-icon">&#128073;</span>
            <div class="ls-callout-text">
                <strong>Try it yourself!</strong> Click the <strong>2D System</strong> example above, or enter the matrix
                <span style="font-family:var(--font-mono);">A = [[1, 1], [0.3, 0.7]]</span> and
                <span style="font-family:var(--font-mono);">b = [200, 90]</span> to see the step-by-step solution and graph.
            </div>
        </div>
    </div>

    <!-- ===== 4. METHODS COMPARISON ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.5rem;color:var(--text-primary);">Solution Methods Comparison</h2>
        <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;margin-bottom:0.75rem;">
            All methods find the same answer &mdash; they differ in <em>how</em> they get there and <em>when</em> each is most efficient.
        </p>
        <table class="ls-methods-table">
            <thead>
                <tr><th>Method</th><th>Best For</th><th>Complexity</th><th>Key Idea</th></tr>
            </thead>
            <tbody>
                <tr><td style="font-weight:500;">Gaussian Elimination</td><td>General systems</td><td>O(n&sup3;)</td><td>Create zeros below pivots, then back-substitute</td></tr>
                <tr><td style="font-weight:500;">Gauss-Jordan (RREF)</td><td>Finding all solutions</td><td>O(n&sup3;)</td><td>Create zeros above <em>and</em> below &mdash; read solution directly</td></tr>
                <tr><td style="font-weight:500;">LU Decomposition</td><td>Multiple right-hand sides</td><td>O(n&sup3;)</td><td>Factor A = LU once, solve Ly = b then Ux = y</td></tr>
                <tr><td style="font-weight:500;">Cramer's Rule</td><td>Small systems (n &le; 3)</td><td>O(n! &middot; n)</td><td>x&#7522; = det(A&#7522;) / det(A) using determinants</td></tr>
                <tr><td style="font-weight:500;">Matrix Inverse</td><td>Square systems</td><td>O(n&sup3;)</td><td>Compute A&supmin;&sup1;, then x = A&supmin;&sup1;b</td></tr>
                <tr><td style="font-weight:500;">Least Squares</td><td>Overdetermined (m &gt; n)</td><td>O(mn&sup2;)</td><td>Minimize ||Ax - b||&sup2; via normal equations A&#7488;Ax = A&#7488;b</td></tr>
            </tbody>
        </table>
    </div>

    <!-- ===== 5. TYPES OF SOLUTIONS (expanded) ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Types of Solutions: How to Identify Each</h2>
        <div class="ls-edu-grid">
            <div class="ls-edu-card ls-anim ls-anim-d1" style="border-left:3px solid #6366f1;">
                <h4 style="display:flex;align-items:center;gap:0.375rem;"><span style="color:#6366f1;">&#9679;</span> Unique Solution</h4>
                <p>Exactly one set of values satisfies all equations. Happens when <strong>det(A) &ne; 0</strong> (the rows are linearly independent). The row echelon form has a pivot in every column.</p>
                <div style="font-family:var(--font-mono);font-size:0.75rem;color:var(--ls-tool);margin-top:0.5rem;padding:0.5rem;background:var(--ls-light);border-radius:0.375rem;text-align:center;">
                    [1 * * | *]<br>[0 1 * | *]<br>[0 0 1 | *]
                </div>
            </div>
            <div class="ls-edu-card ls-anim ls-anim-d2" style="border-left:3px solid #f59e0b;">
                <h4 style="display:flex;align-items:center;gap:0.375rem;"><span style="color:#f59e0b;">&#9679;</span> No Solution</h4>
                <p>The equations contradict each other. In row echelon form, you get a row <strong>[0 0 &hellip; 0 | c]</strong> where c &ne; 0 &mdash; this says "0 = c", which is impossible.</p>
                <div style="font-family:var(--font-mono);font-size:0.75rem;color:#f59e0b;margin-top:0.5rem;padding:0.5rem;background:#fef3c7;border-radius:0.375rem;text-align:center;">
                    [1 * * | *]<br>[0 1 * | *]<br>[0 0 0 | 5] &#8592; contradiction!
                </div>
            </div>
            <div class="ls-edu-card ls-anim ls-anim-d3" style="border-left:3px solid #10b981;">
                <h4 style="display:flex;align-items:center;gap:0.375rem;"><span style="color:#10b981;">&#9679;</span> Infinite Solutions</h4>
                <p>Free variables exist because <strong>rank(A) &lt; n</strong>. The solution is parametric: some variables are expressed in terms of free parameters (t, s, &hellip;).</p>
                <div style="font-family:var(--font-mono);font-size:0.75rem;color:#10b981;margin-top:0.5rem;padding:0.5rem;background:#dcfce7;border-radius:0.375rem;text-align:center;">
                    [1 * * | *]<br>[0 0 1 | *]<br>[0 0 0 | 0] &#8592; x&#8322; is free
                </div>
            </div>
            <div class="ls-edu-card ls-anim ls-anim-d4" style="border-left:3px solid #3b82f6;">
                <h4 style="display:flex;align-items:center;gap:0.375rem;"><span style="color:#3b82f6;">&#9679;</span> Least Squares</h4>
                <p>When there are <strong>more equations than unknowns</strong> (overdetermined), no exact solution exists. Least squares finds the x that minimizes the total error ||Ax - b||&sup2;.</p>
                <div style="font-family:var(--font-mono);font-size:0.75rem;color:#3b82f6;margin-top:0.5rem;padding:0.5rem;background:#eff6ff;border-radius:0.375rem;text-align:center;">
                    A&#7488;Ax = A&#7488;b &rarr; x&#770; = best fit
                </div>
            </div>
        </div>
    </div>

    <!-- ===== 6. APPLICATIONS ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Where Linear Systems Appear</h2>
        <div class="ls-edu-grid" style="grid-template-columns:repeat(auto-fit,minmax(200px,1fr));">
            <div class="ls-edu-card ls-anim ls-anim-d1" style="text-align:center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#9889;</div>
                <h4>Circuit Analysis</h4>
                <p>Kirchhoff's voltage and current laws at each node create a linear system. Solve for branch currents and node voltages.</p>
            </div>
            <div class="ls-edu-card ls-anim ls-anim-d2" style="text-align:center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#128202;</div>
                <h4>Data Fitting</h4>
                <p>Least squares regression fits a line or curve to noisy data by solving the normal equations A&#7488;Ax = A&#7488;b.</p>
            </div>
            <div class="ls-edu-card ls-anim ls-anim-d3" style="text-align:center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#127981;</div>
                <h4>Structural Engineering</h4>
                <p>Force and moment equilibrium in trusses and frames produces systems of equations for member forces.</p>
            </div>
            <div class="ls-edu-card ls-anim ls-anim-d4" style="text-align:center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#128187;</div>
                <h4>Computer Graphics</h4>
                <p>3D rotation, projection, ray-plane intersection, and mesh deformation all involve solving linear systems.</p>
            </div>
            <div class="ls-edu-card ls-anim ls-anim-d5" style="text-align:center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#129302;</div>
                <h4>Machine Learning</h4>
                <p>Linear regression, PCA, and neural network weight updates rely on solving or approximating linear systems.</p>
            </div>
            <div class="ls-edu-card ls-anim ls-anim-d6" style="text-align:center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#9878;&#65039;</div>
                <h4>Chemical Balancing</h4>
                <p>Balancing chemical equations (conservation of atoms for each element) is a system of linear equations.</p>
            </div>
        </div>
    </div>

    <!-- FAQ Section -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What types of systems can this solver handle?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">This solver handles square systems (same number of equations and variables), overdetermined systems (more equations than variables, solved via least squares), and underdetermined systems (fewer equations than variables, showing parametric solutions with free variables). It also handles polynomial systems using Newton-Raphson iteration. Systems up to 10&times;10 are supported.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What solution methods are available?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Six methods are available: <strong>Gaussian elimination</strong> (general-purpose with partial pivoting), <strong>Gauss-Jordan</strong> (produces reduced row echelon form), <strong>LU decomposition</strong> (factors A=LU then solves by substitution), <strong>Cramer's rule</strong> (uses determinants, best for small systems), <strong>matrix inverse</strong> (computes x = A&supmin;&sup1;b), and <strong>least squares</strong> (minimizes residual for overdetermined systems).</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How do I enter my system of equations?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Three input modes are available. <strong>Text mode</strong>: enter the coefficient matrix A (one row per line, space-separated) and constants vector b separately. <strong>Grid mode</strong>: click into cells of a visual augmented matrix [A|b]. <strong>Polynomial mode</strong>: enter equations like "x^2 + y^2 = 25" for nonlinear systems solved by Newton-Raphson.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How are the step-by-step solutions generated?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">All step-by-step solutions are computed entirely in your browser (client-side). Each method generates detailed steps: Gaussian elimination shows every row operation and augmented matrix state, Cramer's rule shows each determinant computation, LU decomposition shows L and U matrices with forward/back substitution, and so on. No server calls needed — results are instant.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Is this linear equations solver free?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes, this solver is completely free with no signup required. You get 6 solving methods, step-by-step solutions with augmented matrix visualization, interactive 2D/3D Plotly graphs, a Python compiler with NumPy/SymPy/SciPy templates, LaTeX export, and shareable URLs. All computation runs entirely in your browser for instant results.</div>
        </div>
    </div>
</section>

<!-- Explore More Math -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h3 style="font-size:1.15rem;font-weight:600;margin:0 0 1rem;display:flex;align-items:center;gap:0.5rem;color:var(--text-primary);">
            Explore More Math Tools
        </h3>
        <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:1rem;">
            <a href="<%=request.getContextPath()%>/integral-calculator.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#4f46e5,#6366f1);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.4rem;color:#fff;">&#8747;</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Integral Calculator</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Step-by-step integration with graphs and PDF export</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/derivative-calculator.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#ec4899,#f472b6);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.2rem;color:#fff;">d/dx</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Derivative Calculator</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Differentiate any function with step-by-step solutions</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/logarithm-calculator.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#0d9488,#14b8a6);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.1rem;color:#fff;">log</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Logarithm Calculator</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Solve, expand, condense log equations with steps</p>
                </div>
            </a>
        </div>
    </div>
</section>

<!-- Support Section -->
<%@ include file="modern/components/support-section.jsp" %>

<!-- Footer -->
<footer class="page-footer">
    <div class="footer-content">
        <p class="footer-text">&copy; 2024 8gwifi.org - Free Online Tools</p>
        <div class="footer-links">
            <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
            <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
            <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
        </div>
    </div>
</footer>

<%@ include file="modern/ads/ad-sticky-footer.jsp" %>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
<script>
// Scroll-triggered animations for educational content
(function(){
    var els = document.querySelectorAll('.ls-anim');
    if (!els.length) return;
    if (!('IntersectionObserver' in window)) {
        els.forEach(function(el){ el.classList.add('ls-visible'); });
        return;
    }
    var obs = new IntersectionObserver(function(entries){
        entries.forEach(function(e){
            if (e.isIntersecting) {
                e.target.classList.add('ls-visible');
                obs.unobserve(e.target);
            }
        });
    }, { threshold: 0.15 });
    els.forEach(function(el){ obs.observe(el); });
})();
</script>
<%@ include file="modern/components/analytics.jsp" %>
</body>
</html>
