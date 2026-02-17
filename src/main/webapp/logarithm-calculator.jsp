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

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Logarithm Calculator | Solve, Simplify, Expand ln log" />
        <jsp:param name="toolDescription" value="Free online logarithm calculator with step-by-step solutions. Solve log equations, simplify, expand, condense, and evaluate. Supports ln, log, log2, log10, any base. Interactive graph, Python SymPy compiler, LaTeX export. Hybrid formula + AI solver. No signup required." />
        <jsp:param name="toolCategory" value="Mathematics" />
        <jsp:param name="toolUrl" value="logarithm-calculator.jsp" />
        <jsp:param name="toolKeywords" value="logarithm calculator, log equation solver, simplify logarithms, expand logarithms, condense logarithms, ln calculator, log10, log2, natural log, logarithmic equations, change of base, log rules, step by step" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Solve log equations step by step,Expand and condense using log rules,Simplify and evaluate expressions,Interactive Plotly graph,Built-in Python SymPy compiler,AI-powered fallback for complex problems,ln log log2 log10 any base,Copy LaTeX and share results,Live KaTeX preview,Dark mode support" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What types of logarithm problems can this calculator solve?" />
        <jsp:param name="faq1a" value="This calculator solves logarithmic equations (log2(x) = 5), simplifies expressions (log(e^2) = 2), expands logarithms using product/quotient/power rules, condenses multiple logs into one, and evaluates to decimal values. It supports natural log (ln), common log (log10), binary log (log2), and any custom base." />
        <jsp:param name="faq2q" value="What is the difference between Solve, Expand, Condense, Simplify, and Evaluate?" />
        <jsp:param name="faq2a" value="Solve finds the variable value in a log equation. Expand breaks a single log into multiple logs using rules. Condense combines multiple logs into one. Simplify reduces to the simplest form. Evaluate computes a decimal result." />
        <jsp:param name="faq3q" value="How does the hybrid solver work?" />
        <jsp:param name="faq3a" value="The calculator first attempts to solve using nerdamer (client-side CAS). It normalizes log bases, eliminates common denominators, and uses algebraic solving. If nerdamer cannot solve, it falls back to AI-powered step-by-step solutions. This gives instant results for standard problems and detailed explanations for complex ones." />
        <jsp:param name="faq4q" value="What is the difference between ln and log?" />
        <jsp:param name="faq4a" value="ln (natural logarithm) is log base e (approximately 2.71828). log typically means log base 10 in everyday use. This calculator accepts both: type ln(x) or log(x) for natural log, and log10(x) for common log base 10. Use log2(x) for binary log or logb(x, base) for any custom base." />
        <jsp:param name="faq5q" value="Is this logarithm calculator free?" />
        <jsp:param name="faq5a" value="This logarithm calculator is completely free with no signup required. You get formula-based solving, AI step-by-step solutions, interactive graphs, a Python SymPy compiler, LaTeX export, and shareable URLs. Most computation runs in your browser for instant results." />
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

    <%@ include file="modern/ads/ad-init.jsp" %>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">

    <style>
        :root { --log-tool:#0d9488; --log-tool-dark:#0f766e; --log-gradient:linear-gradient(135deg,#0d9488 0%,#14b8a6 100%); --log-light:#ccfbf1 }
        [data-theme="dark"] { --log-light:rgba(20,184,166,0.15) }
        .lc-mode-toggle { display:flex; border:1.5px solid var(--border); border-radius:0.5rem; overflow:hidden; margin-bottom:1rem; flex-wrap:wrap; }
        .lc-mode-btn { flex:1; min-width:80px; padding:0.5rem; font-weight:600; font-size:0.75rem; border:none; cursor:pointer; background:var(--bg-secondary); color:var(--text-secondary); transition:all .15s; font-family:var(--font-sans); }
        .lc-mode-btn.active { background:var(--log-gradient); color:#fff; }
        .lc-mode-btn:hover:not(.active) { background:var(--bg-tertiary); }
        .lc-preview { background:var(--bg-secondary); border:1px solid var(--border); border-radius:0.5rem; padding:0.75rem 1rem; min-height:48px; display:flex; align-items:center; justify-content:center; overflow-x:auto; font-size:1.1rem; }
        .lc-preview .katex-display { margin:0; }
        .lc-example-chip { padding:0.3rem 0.6rem; font-size:0.75rem; font-family:var(--font-mono); background:var(--bg-secondary); border:1px solid var(--border); border-radius:9999px; cursor:pointer; transition:all .15s; color:var(--text-secondary); white-space:nowrap; }
        .lc-example-chip:hover { background:var(--log-tool); color:#fff; }
        .lc-examples { display:flex; flex-wrap:wrap; gap:0.375rem; }
        .lc-badge { display:inline-block; padding:0.2rem 0.5rem; border-radius:9999px; font-size:0.65rem; font-weight:600; background:var(--log-light); color:var(--log-tool); margin-left:0.5rem; }
        .lc-error { background:#fef3c7; border:1px solid #f59e0b; border-radius:0.5rem; padding:1rem; color:#92400e; }
        .tool-action-btn { background:var(--log-gradient) !important; }
        .lc-keyboard { background:var(--bg-secondary); border:1px solid var(--border); border-radius:0.5rem; padding:0.5rem; margin-top:0.5rem; }
        .lc-key-row { display:flex; flex-wrap:wrap; gap:0.35rem; margin-bottom:0.35rem; justify-content:center; }
        .lc-key-row:last-child { margin-bottom:0; }
        .lc-key-btn { min-width:2.25rem; padding:0.4rem 0.5rem; font-size:0.75rem; font-family:var(--font-mono); font-weight:600; border:1px solid var(--border); border-radius:0.375rem; background:var(--bg-primary); color:var(--text-primary); cursor:pointer; transition:all .12s; }
        .lc-key-btn:hover { background:var(--log-tool); color:#fff; border-color:var(--log-tool); }
        .lc-key-btn.wide { min-width:3.5rem; font-size:0.7rem; }
        .lc-key-btn.log-fn { background:var(--log-light); color:var(--log-tool); border-color:var(--log-tool); }
        .lc-key-btn.log-fn:hover { background:var(--log-tool); color:#fff; }
        .lc-key-btn.op { background:var(--bg-tertiary); }



        /* ===== Output tabs ===== */
        .lc-output-tabs { display:flex; border:1.5px solid var(--border); border-radius:0.5rem; overflow:hidden; }
        .lc-output-tab { flex:1; padding:0.5rem; font-weight:600; font-size:0.8125rem; border:none; cursor:pointer; background:var(--bg-secondary); color:var(--text-secondary); transition:all .15s; font-family:var(--font-sans); text-align:center; }
        .lc-output-tab.active { background:var(--log-gradient); color:#fff; }
        .lc-output-tab:hover:not(.active) { background:var(--bg-tertiary); }
        [data-theme="dark"] .lc-output-tab { background:var(--bg-tertiary); }
        [data-theme="dark"] .lc-output-tab.active { background:var(--log-gradient); color:#fff; }
        [data-theme="dark"] .lc-output-tab:hover:not(.active) { background:rgba(255,255,255,0.08); }

        .lc-panel { display:none; flex:1; min-height:0; }
        .lc-panel.active { display:flex; flex-direction:column; }
        #lc-panel-result .tool-result-card { flex:1; }
        #lc-panel-graph { min-height:480px; }
        #lc-panel-python { min-height:540px; }

        /* ===== Graph ===== */
        #lc-graph-container { width:100%; min-height:440px; border-radius:var(--radius-md); }
        .js-plotly-plot .plotly .modebar { top:4px !important; right:4px !important; }

        /* ===== Result display ===== */
        .lc-result-label { font-size:0.75rem; font-weight:600; text-transform:uppercase; letter-spacing:0.05em; color:var(--text-muted); margin-bottom:0.25rem; }

        /* ===== Below-fold educational cards ===== */
        .lc-edu-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(240px,1fr)); gap:1rem; margin-top:1rem; }
        .lc-edu-card { background:var(--bg-secondary); border:1px solid var(--border); border-radius:var(--radius-md); padding:1.25rem; }
        .lc-edu-card h4 { font-size:0.875rem; font-weight:700; color:var(--text-primary); margin-bottom:0.375rem; }
        .lc-edu-card p { font-size:0.8125rem; color:var(--text-secondary); line-height:1.6; margin:0; }
        [data-theme="dark"] .lc-edu-card { background:var(--bg-tertiary); border-color:var(--border); }
        .lc-rules-table { width:100%; border-collapse:collapse; font-size:0.8125rem; margin-top:0.75rem; }
        .lc-rules-table th,.lc-rules-table td { padding:0.5rem 0.75rem; text-align:left; border-bottom:1px solid var(--border); }
        .lc-rules-table th { font-weight:600; color:var(--text-primary); background:var(--bg-secondary); }
        .lc-rules-table td { color:var(--text-secondary); font-family:var(--font-mono); font-size:0.75rem; }
        [data-theme="dark"] .lc-rules-table th { background:var(--bg-tertiary); }
        .lc-diagram { max-width:100%; height:auto; display:block; margin:1rem auto; }

        /* ===== FAQ ===== */
        .faq-item { border-bottom:1px solid var(--border); }
        .faq-item:last-child { border-bottom:none; }
        .faq-question { display:flex; align-items:center; justify-content:space-between; width:100%; padding:0.875rem 0; background:none; border:none; font-size:0.875rem; font-weight:600; color:var(--text-primary); cursor:pointer; text-align:left; font-family:var(--font-sans); gap:0.75rem; }
        .faq-answer { display:none; padding:0 0 0.875rem; font-size:0.8125rem; line-height:1.7; color:var(--text-secondary); }
        .faq-item.open .faq-answer { display:block; }
        .faq-chevron { transition:transform 0.2s; flex-shrink:0; }
        .faq-item.open .faq-chevron { transform:rotate(180deg); }
    </style>
</head>
<body>
<%@ include file="modern/components/nav-header.jsp" %>

<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">Logarithm Problem Solver</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/index.jsp#mathematics">Mathematics</a> /
                Logarithm Calculator
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">Hybrid</span>
            <span class="tool-badge">Nerdamer</span>
            <span class="tool-badge">AI Fallback</span>
        </div>
    </div>
</header>

<section class="tool-description-section">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>Solve logarithm problems using <strong>formula-based methods</strong> when possible, with <strong>AI fallback</strong> for complex cases. Supports <code>ln(x)</code>, <code>log(x)</code>, <code>log2(x)</code>, <code>log3(x)</code>, <code>log10(x)</code>, and <code>logb(x,base)</code> for any base. Solve equations, simplify, expand, condense, or evaluate. Live KaTeX preview.</p>
        </div>
    </div>
</section>

<main class="tool-page-container">
    <div class="tool-input-column">
        <div class="tool-card">
            <div class="tool-card-header" style="background:var(--log-gradient);">Logarithm Calculator</div>
            <div class="tool-card-body">
                <div class="lc-mode-toggle">
                    <button type="button" class="lc-mode-btn active" data-mode="solve">Solve</button>
                    <button type="button" class="lc-mode-btn" data-mode="simplify">Simplify</button>
                    <button type="button" class="lc-mode-btn" data-mode="expand">Expand</button>
                    <button type="button" class="lc-mode-btn" data-mode="condense">Condense</button>
                    <button type="button" class="lc-mode-btn" data-mode="evaluate">Evaluate</button>
                </div>

                <div class="tool-form-group">
                    <label class="tool-form-label" for="lc-input">Problem</label>
                    <input type="text" class="tool-input" id="lc-input" placeholder="e.g. log(x)=2  or  log(x)+log(y)  or  log(x^2*y)" autocomplete="off" spellcheck="false" style="font-family:var(--font-mono);font-size:0.9375rem">
                    <div class="lc-keyboard" id="lc-keyboard">
                        <div class="lc-key-row">
                            <button type="button" class="lc-key-btn log-fn wide" data-insert="log(">log(</button>
                            <button type="button" class="lc-key-btn log-fn wide" data-insert="ln(">ln(</button>
                            <button type="button" class="lc-key-btn log-fn wide" data-insert="log2(">log₂(</button>
                            <button type="button" class="lc-key-btn log-fn wide" data-insert="log3(">log₃(</button>
                            <button type="button" class="lc-key-btn log-fn wide" data-insert="log10(">log₁₀(</button>
                            <button type="button" class="lc-key-btn log-fn wide" data-insert="logb(">logb(</button>
                        </div>
                        <div class="lc-key-row">
                            <button type="button" class="lc-key-btn" data-insert="x">x</button>
                            <button type="button" class="lc-key-btn" data-insert="y">y</button>
                            <button type="button" class="lc-key-btn" data-insert="t">t</button>
                            <button type="button" class="lc-key-btn" data-insert="e">e</button>
                            <button type="button" class="lc-key-btn op" data-insert="(">(</button>
                            <button type="button" class="lc-key-btn op" data-insert=")">)</button>
                            <button type="button" class="lc-key-btn op" data-insert="^">^</button>
                            <button type="button" class="lc-key-btn op" data-insert="*">*</button>
                            <button type="button" class="lc-key-btn op" data-insert="/">/</button>
                            <button type="button" class="lc-key-btn op" data-insert="+">+</button>
                            <button type="button" class="lc-key-btn op" data-insert="-">−</button>
                            <button type="button" class="lc-key-btn op" data-insert="=">=</button>
                        </div>
                        <div class="lc-key-row">
                            <button type="button" class="lc-key-btn" data-insert="0">0</button>
                            <button type="button" class="lc-key-btn" data-insert="1">1</button>
                            <button type="button" class="lc-key-btn" data-insert="2">2</button>
                            <button type="button" class="lc-key-btn" data-insert="3">3</button>
                            <button type="button" class="lc-key-btn" data-insert="4">4</button>
                            <button type="button" class="lc-key-btn" data-insert="5">5</button>
                            <button type="button" class="lc-key-btn" data-insert="6">6</button>
                            <button type="button" class="lc-key-btn" data-insert="7">7</button>
                            <button type="button" class="lc-key-btn" data-insert="8">8</button>
                            <button type="button" class="lc-key-btn" data-insert="9">9</button>
                            <button type="button" class="lc-key-btn op" data-insert=".">.</button>
                            <button type="button" class="lc-key-btn wide" data-insert="\b">⌫</button>
                            <button type="button" class="lc-key-btn wide" data-insert="clear">Clear</button>
                        </div>
                    </div>
                </div>

                <div class="tool-form-group">
                    <label class="tool-form-label">Live Preview</label>
                    <div class="lc-preview" id="lc-preview">
                        <span style="color:var(--text-muted);font-size:0.8125rem;">Enter a problem above&hellip;</span>
                    </div>
                </div>

                <div class="tool-form-group">
                    <label class="tool-form-label" for="lc-var">Variable (for solve)</label>
                    <select class="tool-input" id="lc-var" style="padding:0.5rem 0.75rem;cursor:pointer">
                        <option value="x" selected>x</option>
                        <option value="y">y</option>
                        <option value="t">t</option>
                    </select>
                </div>

                <button type="button" class="tool-action-btn" id="lc-solve-btn">Solve</button>

                <hr style="border:none;border-top:1px solid var(--border);margin:1rem 0">

                <div class="tool-form-group">
                    <label class="tool-form-label">Quick Examples</label>
                    <div class="lc-examples">
                        <button type="button" class="lc-example-chip" data-expr="ln(x)=2">ln(x)=2</button>
                        <button type="button" class="lc-example-chip" data-expr="log10(x)=3">log₁₀(x)=3</button>
                        <button type="button" class="lc-example-chip" data-expr="log2(8)">log₂(8)</button>
                        <button type="button" class="lc-example-chip" data-expr="log(x)+log(y)">ln(x)+ln(y)</button>
                        <button type="button" class="lc-example-chip" data-expr="log(x^2*y)">ln(x²y)</button>
                        <button type="button" class="lc-example-chip" data-expr="2*log(x)-log(y)">2ln(x)-ln(y)</button>
                        <button type="button" class="lc-example-chip" data-expr="log(e^2)">ln(e²)</button>
                        <button type="button" class="lc-example-chip" data-expr="log3(x+2)-log3(x)=2">log₃(x+2)-log₃(x)=2</button>
                    </div>
                </div>

                <div class="tool-form-group">
                    <label class="tool-form-label">Syntax</label>
                    <p class="tool-form-hint"><code>ln(x)</code> = natural log &bull; <code>log(x)</code> = natural log (nerdamer convention) &bull; <code>log2(x)</code> = log₂(x) &bull; <code>log10(x)</code> = log₁₀(x) &bull; <code>logb(x,base)</code> = log with any base</p>
                </div>
            </div>
        </div>
    </div>

    <div class="tool-output-column">
        <!-- Tab bar -->
        <div class="lc-output-tabs">
            <button type="button" class="lc-output-tab active" data-panel="result">Result</button>
            <button type="button" class="lc-output-tab" data-panel="graph">Graph</button>
            <button type="button" class="lc-output-tab" data-panel="python">Python Compiler</button>
        </div>

        <!-- Result Panel -->
        <div class="lc-panel active" id="lc-panel-result">
            <div class="tool-card tool-result-card">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--log-tool);">
                        <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                    </svg>
                    <h4>Result</h4>
                </div>
                <div class="tool-result-content" id="lc-result-content">
                    <div class="tool-empty-state" id="lc-empty-state">
                        <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">log</div>
                        <h3>Enter a logarithm problem</h3>
                        <p>Solve equations, simplify, expand, or evaluate. Formula-based first, AI when needed.</p>
                    </div>
                </div>
                <div class="tool-result-actions" id="lc-result-actions" style="display:none;gap:0.5rem;padding:1rem;border-top:1px solid var(--border);flex-wrap:wrap">
                    <button type="button" class="tool-action-btn" id="lc-copy-latex-btn">
                        <span>&#128203;</span> Copy LaTeX
                    </button>
                    <button type="button" class="tool-action-btn" id="lc-copy-text-btn">
                        <span>&#128196;</span> Copy Text
                    </button>
                    <button type="button" class="tool-action-btn" id="lc-share-btn">
                        <span>&#128279;</span> Share
                    </button>
                    <button type="button" class="tool-action-btn" id="lc-steps-btn">Show Steps</button>
                </div>
            </div>
            <div id="lc-steps-area" style="margin-top:1rem"></div>
        </div>

        <!-- Graph Panel -->
        <div class="lc-panel" id="lc-panel-graph">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--log-tool);">
                        <line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/>
                    </svg>
                    <h4>Interactive Graph</h4>
                </div>
                <div style="flex:1;min-height:0;padding:0.75rem;">
                    <div id="lc-graph-container"></div>
                    <p id="lc-graph-hint" style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">Solve a logarithm problem to see its graph.</p>
                </div>
            </div>
        </div>

        <!-- Python Compiler Panel -->
        <div class="lc-panel" id="lc-panel-python">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--log-tool);">
                        <polygon points="5 3 19 12 5 21 5 3"/>
                    </svg>
                    <h4>Python Compiler</h4>
                    <select id="lc-compiler-template" style="margin-left:auto;padding:0.3rem 0.5rem;border:1px solid var(--border);border-radius:0.375rem;font-size:0.75rem;font-family:var(--font-sans);background:var(--bg-primary);color:var(--text-primary);cursor:pointer;">
                        <option value="sympy-solve">SymPy Solve</option>
                        <option value="sympy-simplify">SymPy Simplify</option>
                        <option value="sympy-expand">SymPy Expand</option>
                    </select>
                </div>
                <div style="flex:1;min-height:0;">
                    <iframe id="lc-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                </div>
            </div>
        </div>
    </div>

    <div class="tool-ads-column">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/nerdamer.core.js"></script>
<script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Algebra.js"></script>
<script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Calculus.js"></script>
<script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Solve.js"></script>
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>

<script>
(function() {
'use strict';

// Custom log base: logb(x, base) = log(x)/log(base)
if (typeof nerdamer !== 'undefined') {
    try { nerdamer.setFunction('logb', ['x','b'], 'log(x)/log(b)'); } catch(e) {}
}

var inputEl = document.getElementById('lc-input');
var previewEl = document.getElementById('lc-preview');
var varSelect = document.getElementById('lc-var');
var solveBtn = document.getElementById('lc-solve-btn');
var resultContent = document.getElementById('lc-result-content');
var resultActions = document.getElementById('lc-result-actions');
var emptyState = document.getElementById('lc-empty-state');
var stepsArea = document.getElementById('lc-steps-area');
var stepsBtn = document.getElementById('lc-steps-btn');
var graphHint = document.getElementById('lc-graph-hint');

var currentMode = 'solve';
var lastResult = null;
var lastResultLatex = '';
var lastSolvedBy = null; // 'formula' | 'ai'
var compilerLoaded = false;
var pendingGraph = null;

function findMatchingParen(str, start) {
    var depth = 1, i = start;
    while (depth > 0 && i < str.length) {
        if (str[i] === '(') depth++;
        else if (str[i] === ')') depth--;
        i++;
    }
    return i - 1;
}

function convertLogBases(s) {
    var result = '';
    var i = 0;
    while (i < s.length) {
        var m = s.substr(i).match(/^\blog(\d+)\s*\(/);
        if (m) {
            var base = m[1];
            var start = i + m[0].length;
            var end = findMatchingParen(s, start);
            var inner = s.substring(start, end);
            // Recursively convert any nested logN() inside the inner expression
            inner = convertLogBases(inner);
            result += '(log(' + inner + ')/log(' + base + '))';
            i = end + 1;
        } else {
            result += s[i];
            i++;
        }
    }
    return result;
}

function convertLogb(s) {
    // Convert logb(expr, base) → (log(expr)/log(base))
    var result = '';
    var i = 0;
    while (i < s.length) {
        var m = s.substr(i).match(/^\blogb\s*\(/);
        if (m) {
            var start = i + m[0].length;
            var end = findMatchingParen(s, start);
            var args = s.substring(start, end);
            // Split on comma, respecting parentheses
            var depth = 0, splitIdx = -1;
            for (var j = 0; j < args.length; j++) {
                if (args[j] === '(') depth++;
                else if (args[j] === ')') depth--;
                else if (args[j] === ',' && depth === 0) { splitIdx = j; break; }
            }
            if (splitIdx >= 0) {
                var expr = args.substring(0, splitIdx).trim();
                var base = args.substring(splitIdx + 1).trim();
                result += '(log(' + expr + ')/log(' + base + '))';
            } else {
                // No comma found — pass through as-is
                result += s.substring(i, end + 1);
            }
            i = end + 1;
        } else {
            result += s[i];
            i++;
        }
    }
    return result;
}

function normalizeInput(s) {
    if (!s || !s.trim()) return s;
    s = s.trim();
    s = s.replace(/\bln\s*\(/g, 'log(');
    s = s.replace(/\blog_(\d+)\s*\(/g, function(m,b){ return 'log'+b+'('; });
    s = convertLogb(s);
    s = convertLogBases(s);
    return s;
}

function convertLogFracToSubscript(expr) {
    // Replace (log(inner)/log(base)) with \log_{base}(inner) for proper logₐ(x) display
    var result = expr;
    var out = '';
    var idx = 0;
    while (idx < result.length) {
        var m = result.substr(idx).match(/^\(log\(/);
        if (m) {
            var innerStart = idx + m[0].length;
            var innerEnd = findMatchingParen(result, innerStart);
            if (result.substr(innerEnd + 1, 5) === '/log(') {
                var baseStart = innerEnd + 6;
                var baseEnd = findMatchingParen(result, baseStart);
                var baseStr = result.substring(baseStart, baseEnd);
                // Expect closing paren for outer group after base close paren
                var afterBase = baseEnd + 1;
                if (result[afterBase] === ')') afterBase++;
                if (baseStr) {
                    var inner = result.substring(innerStart, innerEnd);
                    var innerTex;
                    // Recursively convert any nested log fractions in the inner expression
                    var innerConverted = convertLogFracToSubscript(inner);
                    if (/\\log_\{/.test(innerConverted)) {
                        innerTex = innerConverted;
                    } else {
                        try { innerTex = nerdamer(inner).toTeX(); } catch (e) { innerTex = inner.replace(/\*/g, ' \\cdot '); }
                    }
                    out += '\\log_{' + baseStr + '}\\left(' + innerTex + '\\right)';
                    idx = afterBase;
                    continue;
                }
            }
        }
        out += result[idx];
        idx++;
    }
    return out;
}

function exprToLatex(expr) {
    try {
        // First try direct string-level conversion for log(x)/log(base) patterns
        var custom = convertLogFracToSubscript(expr);
        if (/\\log_\{/.test(custom)) {
            // Has subscript logs — clean up any remaining raw parts
            // Use \cdot for multiplication, but drop it before \log (2\log not 2·log)
            custom = custom.replace(/\*(?=\\log)/g, '');
            custom = custom.replace(/\*/g, ' \\cdot ');
            // Convert any remaining plain nerdamer parts
            custom = custom.replace(/log\(([^)]+)\)/g, function(m, inner) {
                try { return '\\ln\\left(' + nerdamer(inner).toTeX() + '\\right)'; }
                catch(e) { return '\\ln(' + inner + ')'; }
            });
            return custom;
        }
        // Fall back to nerdamer toTeX + regex fixups
        var e = nerdamer(expr);
        var tex = e.toTeX();
        var r = tex;
        // Handle all common nerdamer TeX output patterns for log fractions
        r = r.replace(/\\frac\{\\ln\\left\((.+?)\\right\)\}\{\\ln\\left\((.+?)\\right\)\}/g, function(m, num, den) {
            var denNum = den.match(/^(\d+)$/);
            if (denNum) return '\\log_{' + denNum[1] + '}\\left(' + num + '\\right)';
            return m;
        });
        r = r.replace(/\\frac\{\\log\\left\((.+?)\\right\)\}\{\\log\\left\((.+?)\\right\)\}/g, function(m, num, den) {
            var denNum = den.match(/^(\d+)$/);
            if (denNum) return '\\log_{' + denNum[1] + '}\\left(' + num + '\\right)';
            return m;
        });
        r = r.replace(/\\frac\{\\mathrm\{ln\}\\left\((.+?)\\right\)\}\{\\mathrm\{ln\}\\left\((.+?)\\right\)\}/g, function(m, num, den) {
            var denNum = den.match(/^(\d+)$/);
            if (denNum) return '\\log_{' + denNum[1] + '}\\left(' + num + '\\right)';
            return m;
        });
        return r;
    } catch (err) {
        return expr.replace(/\*/g,' \\cdot ').replace(/\^/g,'^{').replace(/(\d)([\w])/g,'$1\\cdot $2');
    }
}

function updatePreview() {
    var s = inputEl.value.trim();
    if (!s) {
        previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Enter a problem above&hellip;</span>';
        return;
    }
    try {
        var norm = normalizeInput(s);
        var latex;
        if (norm.indexOf('=') >= 0) {
            var parts = norm.split('=');
            latex = exprToLatex(parts[0].trim()) + ' = ' + exprToLatex(parts[1].trim());
        } else {
            latex = exprToLatex(norm);
        }
        katex.render(latex, previewEl, { displayMode: true, throwOnError: false });
    } catch (e) {
        previewEl.innerHTML = '<span style="color:var(--text-muted);">' + (s.length > 40 ? s.substring(0,40)+'...' : s) + '</span>';
    }
}

var previewTimer;
inputEl.addEventListener('input', function() {
    clearTimeout(previewTimer);
    previewTimer = setTimeout(updatePreview, 200);
});

document.querySelectorAll('.lc-mode-btn').forEach(function(btn) {
    btn.addEventListener('click', function() {
        currentMode = this.getAttribute('data-mode');
        document.querySelectorAll('.lc-mode-btn').forEach(function(b){ b.classList.remove('active'); });
        this.classList.add('active');
        updatePreview();
    });
});

document.querySelectorAll('.lc-example-chip').forEach(function(chip) {
    chip.addEventListener('click', function() {
        inputEl.value = this.getAttribute('data-expr');
        updatePreview();
        inputEl.focus();
    });
});

function insertAtCursor(str) {
    if (str === 'clear') {
        inputEl.value = '';
        inputEl.focus();
        updatePreview();
        return;
    }
    if (str === '\\b') {
        var val = inputEl.value, start = inputEl.selectionStart, end = inputEl.selectionEnd;
        if (start === end && start > 0) {
            inputEl.value = val.slice(0, start - 1) + val.slice(end);
            inputEl.setSelectionRange(start - 1, start - 1);
        } else if (start !== end) {
            inputEl.value = val.slice(0, start) + val.slice(end);
            inputEl.setSelectionRange(start, start);
        }
        inputEl.focus();
        updatePreview();
        return;
    }
    var val = inputEl.value, start = inputEl.selectionStart || 0, end = inputEl.selectionEnd || start;
    inputEl.value = val.slice(0, start) + str + val.slice(end);
    inputEl.setSelectionRange(start + str.length, start + str.length);
    inputEl.focus();
    updatePreview();
}

document.getElementById('lc-keyboard').addEventListener('click', function(e) {
    var btn = e.target.closest('.lc-key-btn');
    if (btn && btn.dataset.insert) {
        e.preventDefault();
        inputEl.focus();
        insertAtCursor(btn.dataset.insert);
    }
});

function showResult(html, method, solvedBy) {
    lastResult = { html: html, method: method };
    lastSolvedBy = solvedBy;
    resultContent.innerHTML = html;
    resultActions.style.display = 'flex';
    if (emptyState) emptyState.style.display = 'none';
    stepsArea.innerHTML = '';
}

function showError(msg) {
    resultContent.innerHTML = '<div class="lc-error"><h4>Could not solve</h4><p>' + (msg || 'Try rephrasing or use a simpler expression.') + '</p></div>';
    resultActions.style.display = 'none';
    if (emptyState) emptyState.style.display = 'none';
}

// When all log terms share the same base, multiply through by log(base) to eliminate fractions.
// E.g. (log(x)/log(2))+(log(x-2)/log(2))-3  →  log(x)+log(x-2)-3*log(2)
// This gives nerdamer a MUCH simpler equation (product rule → polynomial).
function eliminateLogBase(eq) {
    // Find all /log(N) denominators in the equation
    var baseRe = /\/log\((\d+)\)/g;
    var match, bases = [];
    while ((match = baseRe.exec(eq)) !== null) {
        bases.push(match[1]);
    }
    if (bases.length === 0) return eq; // no base fractions, return as-is
    // Check if all bases are the same
    var allSame = bases.every(function(b) { return b === bases[0]; });
    if (!allSame) return eq; // mixed bases, can't simplify
    var base = bases[0];
    var logBase = 'log(' + base + ')';

    // Strategy: replace each (log(expr)/log(base)) with log(expr),
    // and multiply standalone constants by log(base).
    // Parse into terms: split on + and - while respecting parens.
    // Simpler approach: use nerdamer to multiply through.
    try {
        var multiplied = nerdamer('expand((' + eq + ')*' + logBase + ')').text();
        return multiplied;
    } catch (e) {
        return eq;
    }
}

function tryFormulaSolve() {
    var raw = inputEl.value.trim();
    if (!raw) return null;
    var expr = normalizeInput(raw);
    var v = varSelect.value;

    try {
        if (currentMode === 'solve' && expr.indexOf('=') >= 0) {
            var sides = expr.split('=');
            var lhs = sides[0].trim(), rhs = sides[1].trim();
            var eqRaw = lhs + '-(' + rhs + ')';
            // Try simplified form first (common base elimination), then raw form
            var eqSimplified = eliminateLogBase(eqRaw);
            var sols = null, solText = '';
            var attempts = [eqSimplified];
            if (eqSimplified !== eqRaw) attempts.push(eqRaw);
            for (var ai = 0; ai < attempts.length; ai++) {
                try {
                    sols = nerdamer.solve(attempts[ai], v);
                    solText = sols.text ? sols.text() : String(sols);
                    if (solText && solText !== '[]') break;
                } catch(e) { solText = ''; }
            }
            if (solText && solText !== '[]' && solText.length > 0) {
                var resultExpr = solText.replace(/^\[|\]$/g, '').trim();
                if (resultExpr) {
                    // Handle multiple solutions (e.g. "4,-2" from nerdamer)
                    var solutions = resultExpr.split(',').map(function(s){ return s.trim(); }).filter(Boolean);
                    var latexParts = solutions.map(function(sol) {
                        try { return v + ' = ' + nerdamer(sol).toTeX(); }
                        catch(e) { return v + ' = ' + sol; }
                    });
                    var textParts = solutions.map(function(sol) { return v + ' = ' + sol; });
                    var latex = latexParts.join(' \\quad \\text{or} \\quad ');
                    var resultText = textParts.join('  or  ');
                    return { success: true, result: resultText, latex: latex, method: 'Solve Equation' };
                }
            }
        } else if (currentMode === 'solve' && expr.indexOf('=') < 0) {
            // No equation — try to evaluate the expression (e.g. log2(8) → 3)
            var ev = nerdamer(expr).evaluate();
            var evText = ev.text ? ev.text() : String(ev);
            var num = parseFloat(evText);
            if (!isNaN(num)) {
                return { success: true, result: evText, latex: (ev.toTeX ? ev.toTeX() : evText), method: 'Evaluate', numeric: num };
            }
        } else if (currentMode === 'expand') {
            // Expand: break apart using log rules
            // log(x²y) → 2·log(x) + log(y), log(x/y) → log(x) - log(y)
            var expanded = nerdamer('expand(' + expr + ')');
            var expText = expanded.text();
            if (expText && expText !== expr) {
                return { success: true, result: expText, latex: exprToLatex(expText), method: 'Expand' };
            }
            // Already expanded — return as-is with note
            return { success: true, result: expr, latex: exprToLatex(expr), method: 'Expand (already expanded)' };
        } else if (currentMode === 'condense') {
            // Condense: combine multiple logs into one (opposite of expand)
            // 2·log(x) + log(y) → log(x²·y), log(x) - log(y) → log(x/y)
            var simplified = nerdamer('simplify(' + expr + ')');
            var res = simplified.text();
            if (res && res !== expr) {
                return { success: true, result: res, latex: exprToLatex(res), method: 'Condense' };
            }
            // Already condensed — return as-is with note
            return { success: true, result: expr, latex: exprToLatex(expr), method: 'Condense (already condensed)' };
        } else if (currentMode === 'simplify') {
            // Simplify: reduce to simplest form, try both simplify and evaluate
            // log(e²) → 2, log(1) → 0, log₁₀(1000) → 3
            var simplified = nerdamer('simplify(' + expr + ')');
            var simText = simplified.text();
            // Also try numeric evaluation for cases like log(e^2) → 2
            var evText = '';
            try {
                var ev = nerdamer(expr).evaluate();
                evText = ev.text ? ev.text() : String(ev);
            } catch(e2) {}
            var evNum = parseFloat(evText);
            // Prefer clean numeric result if it exists
            if (!isNaN(evNum) && evNum === Math.round(evNum * 1e10) / 1e10) {
                return { success: true, result: evText, latex: evText, method: 'Simplify', numeric: evNum };
            }
            if (simText && simText !== expr) {
                return { success: true, result: simText, latex: exprToLatex(simText), method: 'Simplify' };
            }
            // Already simple — return as-is
            return { success: true, result: expr, latex: exprToLatex(expr), method: 'Simplify (already simplified)' };
        } else if (currentMode === 'evaluate') {
            // Evaluate: compute to a decimal number
            // log₂(8) → 3, ln(10) → 2.302585...
            var ev = nerdamer(expr).evaluate();
            var evText = ev.text ? ev.text() : String(ev);
            var num = parseFloat(evText);
            if (!isNaN(num) || evText && evText.indexOf('log') === -1) {
                return { success: true, result: evText, latex: (ev.toTeX ? ev.toTeX() : evText), method: 'Evaluate', numeric: num };
            }
        }
    } catch (e) {
        console.warn('Formula solve failed:', e);
    }
    return null;
}

function doSolve() {
    var raw = inputEl.value.trim();
    if (!raw) {
        if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Please enter a problem.', 2000, 'warning');
        return;
    }

    var formulaResult = tryFormulaSolve();

    if (formulaResult && formulaResult.success) {
        lastSolvedBy = 'formula';
        lastResultLatex = formulaResult.latex || '';
        var badge = '<span class="lc-badge">Formula</span>';
        var html = '<div style="text-align:center;padding:1.5rem">';
        html += '<div style="font-size:0.75rem;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:var(--text-muted);margin-bottom:0.5rem">Result ' + badge + '</div>';
        html += '<div id="lc-result-math" style="font-size:1.3rem;margin:1rem 0"></div>';
        html += '<div style="font-size:0.8125rem;color:var(--text-secondary);margin-top:0.5rem">' + formulaResult.method + '</div>';
        html += '</div>';
        resultContent.innerHTML = html;
        try {
            katex.render(formulaResult.latex, document.getElementById('lc-result-math'), { displayMode: true, throwOnError: false });
        } catch (e) {
            document.getElementById('lc-result-math').textContent = formulaResult.result;
        }
        resultActions.style.display = 'flex';
        if (emptyState) emptyState.style.display = 'none';
        stepsArea.innerHTML = '';

        lastResult = { result: formulaResult.result, method: formulaResult.method, raw: raw };

        // Prepare graph with normalized expression
        var normExpr = normalizeInput(raw);
        prepareGraph(normExpr, varSelect.value);
    } else {
        requestAISolve(raw);
    }
}

function requestAISolve(raw) {
    resultContent.innerHTML = '<div style="text-align:center;padding:2rem"><span style="opacity:0.7">⏳</span> Using AI to solve…</div>';
    resultActions.style.display = 'none';

    // Send the user-readable expression (not the normalized nerdamer form)
    // so AI sees "log2(x)+log2(x-2)=3" not "(log(x)/log(2))+(log(x-2)/log(2))=3"
    var payload = {
        operation: 'logarithm',
        expression: raw,
        answer: 'unknown',
        mode: currentMode,
        variable: varSelect.value
    };

    fetch('<%=request.getContextPath()%>/CFExamMarkerFunctionality?action=math_steps', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        if (data.success && data.steps && data.steps.length > 0) {
            lastSolvedBy = 'ai';
            var html = '<div style="padding:1rem">';
            html += '<span class="lc-badge">AI Generated</span>';
            for (var i = 0; i < data.steps.length; i++) {
                html += '<div style="margin:0.75rem 0">';
                html += '<div style="font-size:0.75rem;font-weight:600;color:var(--text-muted);margin-bottom:0.25rem">' + (data.steps[i].title || 'Step '+(i+1)) + '</div>';
                html += '<div id="lc-ai-step-' + i + '" style="font-size:1rem"></div>';
                html += '</div>';
            }
            html += '</div>';
            resultContent.innerHTML = html;
            for (var j = 0; j < data.steps.length; j++) {
                var el = document.getElementById('lc-ai-step-' + j);
                if (el && data.steps[j].latex) {
                    try {
                        katex.render(data.steps[j].latex, el, { displayMode: true, throwOnError: false });
                    } catch (e) { el.textContent = data.steps[j].latex; }
                }
            }
            resultActions.style.display = 'flex';
        } else {
            showError(data.error || 'AI could not solve this problem.');
        }
    })
    .catch(function(err) {
        showError('Network error. Falling back: formula solver did not recognize this. Try: log(x)=2, log(x)+log(y), log(e^2)');
    });
}

solveBtn.addEventListener('click', doSolve);
inputEl.addEventListener('keydown', function(e) {
    if (e.key === 'Enter') doSolve();
});

// ========== Output Tabs ==========
var tabBtns = document.querySelectorAll('.lc-output-tab');
var panels  = document.querySelectorAll('.lc-panel');
tabBtns.forEach(function(btn) {
    btn.addEventListener('click', function() {
        var panel = this.getAttribute('data-panel');
        tabBtns.forEach(function(b) { b.classList.remove('active'); });
        panels.forEach(function(p) { p.classList.remove('active'); });
        this.classList.add('active');
        document.getElementById('lc-panel-' + panel).classList.add('active');

        if (panel === 'graph' && pendingGraph) {
            loadPlotly(function() { renderGraph(pendingGraph); });
        }
        if (panel === 'python' && !compilerLoaded) {
            loadCompilerWithTemplate();
            compilerLoaded = true;
        }
    });
});

// ========== Copy / Share ==========
document.getElementById('lc-copy-latex-btn').addEventListener('click', function() {
    if (typeof ToolUtils !== 'undefined') {
        ToolUtils.copyToClipboard(lastResultLatex || '', 'LaTeX copied!');
    } else {
        navigator.clipboard.writeText(lastResultLatex || '');
    }
});
document.getElementById('lc-copy-text-btn').addEventListener('click', function() {
    var text = (lastResult && lastResult.result) || '';
    if (typeof ToolUtils !== 'undefined') {
        ToolUtils.copyToClipboard(text, 'Copied!');
    } else {
        navigator.clipboard.writeText(text);
    }
});
document.getElementById('lc-share-btn').addEventListener('click', function() {
    var expr = inputEl.value.trim();
    if (!expr) return;
    var url = window.location.origin + window.location.pathname + '?q=' + encodeURIComponent(expr);
    if (typeof ToolUtils !== 'undefined') {
        ToolUtils.copyToClipboard(url, 'Share link copied!');
    } else {
        navigator.clipboard.writeText(url);
    }
});

stepsBtn.addEventListener('click', function() {
    if (!lastResult) return;
    if (lastSolvedBy === 'formula') {
        var steps = [];
        if (lastResult.method === 'Solve Equation') {
            steps.push({ title: 'Rewrite equation', latex: '\\text{Move terms to one side}' });
            steps.push({ title: 'Solve', latex: lastResult.result });
        } else {
            steps.push({ title: lastResult.method, latex: lastResult.result });
        }
        var html = '<div style="border:1px solid var(--border);border-radius:0.5rem;overflow:hidden;margin-top:1rem">';
        html += '<div style="padding:0.75rem 1rem;background:var(--bg-secondary);font-weight:600;font-size:0.875rem">Steps</div>';
        for (var i = 0; i < steps.length; i++) {
            html += '<div style="padding:0.75rem 1rem;border-top:1px solid var(--border);display:flex;gap:0.75rem">';
            html += '<span style="width:24px;height:24px;background:var(--log-tool);color:#fff;border-radius:50%;font-size:0.75rem;font-weight:700;display:flex;align-items:center;justify-content:center">' + (i+1) + '</span>';
            html += '<div id="lc-step-math-' + i + '"></div></div>';
        }
        html += '</div>';
        stepsArea.innerHTML = html;
        for (var k = 0; k < steps.length; k++) {
            var sel = document.getElementById('lc-step-math-' + k);
            if (sel) {
                try { katex.render(steps[k].latex, sel, { displayMode: true, throwOnError: false }); }
                catch (e) { sel.textContent = steps[k].latex; }
            }
        }
    }
});

// ========== Graph ==========
var __plotlyLoaded = false;
function loadPlotly(cb) {
    if (__plotlyLoaded) { if (cb) cb(); return; }
    var s = document.createElement('script');
    s.src = 'https://cdn.plot.ly/plotly-2.27.0.min.js';
    s.onload = function() { __plotlyLoaded = true; if (cb) cb(); };
    document.head.appendChild(s);
}

function prepareGraph(exprStr, v) {
    pendingGraph = { expr: exprStr, v: v };
    if (graphHint) graphHint.style.display = 'none';
    var graphPanel = document.getElementById('lc-panel-graph');
    if (graphPanel.classList.contains('active')) {
        loadPlotly(function() { renderGraph(pendingGraph); });
    }
}

function renderGraph(cfg) {
    if (!window.Plotly) return;
    var container = document.getElementById('lc-graph-container');
    var v = cfg.v;
    var expr = cfg.expr;

    // For equations (has =), plot both sides
    var hasEq = expr.indexOf('=') >= 0;
    var lhsExpr, rhsExpr;
    if (hasEq) {
        var parts = expr.split('=');
        lhsExpr = parts[0].trim();
        rhsExpr = parts[1].trim();
    } else {
        lhsExpr = expr;
    }

    // Determine reasonable x range for log functions (must be > 0)
    var xMin = 0.01, xMax = 20;
    var n = 500;
    var xs = [], ysLhs = [], ysRhs = [];
    var step = (xMax - xMin) / n;

    for (var i = 0; i <= n; i++) {
        var xVal = xMin + i * step;
        xs.push(xVal);
        ysLhs.push(evalAtPoint(lhsExpr, v, xVal));
        if (hasEq) ysRhs.push(evalAtPoint(rhsExpr, v, xVal));
    }

    var traces = [];
    traces.push({
        x: xs, y: ysLhs,
        type: 'scatter', mode: 'lines',
        name: hasEq ? 'LHS: ' + cfg.expr.split('=')[0].trim() : 'f(' + v + ')',
        line: { color: '#0d9488', width: 2.5 }
    });

    if (hasEq) {
        traces.push({
            x: xs, y: ysRhs,
            type: 'scatter', mode: 'lines',
            name: 'RHS: ' + cfg.expr.split('=')[1].trim(),
            line: { color: '#f59e0b', width: 2, dash: 'dash' }
        });
    }

    var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
    var layout = {
        margin: { t: 30, r: 20, b: 40, l: 50 },
        xaxis: { title: v, gridcolor: isDark ? '#334155' : '#e2e8f0', zerolinecolor: isDark ? '#475569' : '#cbd5e1', color: isDark ? '#cbd5e1' : '#475569' },
        yaxis: { gridcolor: isDark ? '#334155' : '#e2e8f0', zerolinecolor: isDark ? '#475569' : '#cbd5e1', color: isDark ? '#cbd5e1' : '#475569' },
        paper_bgcolor: isDark ? '#1e293b' : '#fff',
        plot_bgcolor: isDark ? '#1e293b' : '#fff',
        font: { family: 'Inter, sans-serif', size: 12, color: isDark ? '#cbd5e1' : '#475569' },
        legend: { x: 0, y: 1.12, orientation: 'h', font: { size: 11 } },
        showlegend: true
    };

    Plotly.newPlot(container, traces, layout, { responsive: true, displayModeBar: true, modeBarButtonsToRemove: ['lasso2d', 'select2d'] });
}

function evalAtPoint(exprStr, v, xVal) {
    try {
        var scope = {};
        scope[v] = xVal;
        var val = parseFloat(nerdamer(exprStr).evaluate(scope).text('decimals'));
        if (!isFinite(val) || Math.abs(val) > 1e6) return null;
        return val;
    } catch (e) {
        return null;
    }
}

// ========== Python Compiler ==========
function nerdamerToPython(expr) {
    return expr
        .replace(/e\^(\([^)]+\))/g, 'exp$1')
        .replace(/e\^([a-zA-Z0-9_]+)/g, 'exp($1)')
        .replace(/\^/g, '**');
}

function buildCompilerCode(template) {
    var raw = inputEl.value.trim() || 'log(x)';
    var v = varSelect.value;
    // Convert user input to Python/SymPy form: log(expr, base) syntax
    var pyExpr = raw
        .replace(/\bln\s*\(/g, 'log(')
        .replace(/\blog(\d+)\s*\(([^)]*)\)/g, function(m,b,inner) { return 'log('+inner+','+b+')'; })
        .replace(/\blog_(\d+)\s*\(([^)]*)\)/g, function(m,b,inner) { return 'log('+inner+','+b+')'; })
        .replace(/\blogb\s*\(/g, 'log(');
    pyExpr = nerdamerToPython(pyExpr);

    if (template === 'sympy-solve') {
        var hasEq = raw.indexOf('=') >= 0;
        if (hasEq) {
            var sides = pyExpr.split('=');
            return 'from sympy import *\n\n' + v + ' = symbols(\'' + v + '\')\n\n# Solve: ' + raw + '\nlhs = ' + sides[0].trim() + '\nrhs = ' + sides[1].trim() + '\n\nresult = solve(lhs - rhs, ' + v + ')\nprint("Solutions:")\nfor sol in result:\n    pprint(sol)\nprint("\\nLaTeX:", [latex(s) for s in result])';
        }
        return 'from sympy import *\n\n' + v + ' = symbols(\'' + v + '\')\nexpr = ' + pyExpr + '\n\nresult = simplify(expr)\nprint("Result:")\npprint(result)\nprint("\\nNumeric:", float(result) if result.is_number else "symbolic")';
    } else if (template === 'sympy-simplify') {
        return 'from sympy import *\n\n' + v + ' = symbols(\'' + v + '\')\nexpr = ' + pyExpr.split('=')[0].trim() + '\n\nresult = simplify(expr)\nprint("Simplified:")\npprint(result)\nprint("\\nExpanded:")\npprint(expand_log(expr, force=True))\nprint("\\nLaTeX:", latex(result))';
    } else {
        // sympy-expand
        return 'from sympy import *\n\n' + v + ' = symbols(\'' + v + '\')\nexpr = ' + pyExpr.split('=')[0].trim() + '\n\nexpanded = expand_log(expr, force=True)\nprint("Expanded:")\npprint(expanded)\n\ncondensed = logcombine(expanded, force=True)\nprint("\\nCondensed:")\npprint(condensed)\nprint("\\nLaTeX:", latex(expanded))';
    }
}

function loadCompilerWithTemplate() {
    var template = document.getElementById('lc-compiler-template').value;
    var code = buildCompilerCode(template);
    var b64Code = btoa(unescape(encodeURIComponent(code)));
    var config = JSON.stringify({ lang: 'python', code: b64Code });
    var iframe = document.getElementById('lc-compiler-iframe');
    iframe.src = '<%=request.getContextPath()%>/onecompiler-embed.jsp?c=' + encodeURIComponent(config);
}

document.getElementById('lc-compiler-template').addEventListener('change', function() {
    loadCompilerWithTemplate();
});

var urlParams = new URLSearchParams(window.location.search);
var q = urlParams.get('q') || urlParams.get('expr');
if (q) {
    inputEl.value = decodeURIComponent(q);
    updatePreview();
    setTimeout(doSolve, 300);
}

window.toggleFaq = function(btn) {
    btn.parentElement.classList.toggle('open');
};

})();
</script>

<!-- Mobile Ad Fallback -->
<div class="tool-mobile-ad-container">
    <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
</div>

<!-- Related Tools -->
<jsp:include page="modern/components/related-tools.jsp">
    <jsp:param name="currentToolUrl" value="logarithm-calculator.jsp"/>
    <jsp:param name="keyword" value="mathematics"/>
    <jsp:param name="limit" value="6"/>
</jsp:include>

<!-- ========== BELOW-FOLD EDUCATIONAL CONTENT ========== -->
<section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

    <!-- What is a Logarithm? -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What is a Logarithm?</h2>
        <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">A <strong>logarithm</strong> answers the question: &ldquo;To what exponent must the base <em>b</em> be raised to produce <em>x</em>?&rdquo; If <strong>b<sup>y</sup> = x</strong>, then <strong>log<sub>b</sub>(x) = y</strong>. The three most common bases are: <strong>e &approx; 2.718</strong> (natural log, written ln), <strong>10</strong> (common log, written log), and <strong>2</strong> (binary log, used in computer science).</p>
        <p style="color:var(--text-secondary);margin-bottom:0;line-height:1.7;">Logarithms convert multiplication into addition, division into subtraction, and exponentiation into multiplication &mdash; making them essential in science, engineering, finance, and information theory.</p>

        <!-- Log curve SVG diagram -->
        <svg class="lc-diagram" viewBox="0 0 500 240" xmlns="http://www.w3.org/2000/svg" style="max-width:460px;">
            <defs>
                <linearGradient id="logGrad" x1="0" y1="0" x2="1" y2="0">
                    <stop offset="0%" stop-color="#0d9488" stop-opacity="0.20"/>
                    <stop offset="100%" stop-color="#0d9488" stop-opacity="0.03"/>
                </linearGradient>
            </defs>
            <!-- Axes -->
            <line x1="60" y1="200" x2="480" y2="200" stroke="#94a3b8" stroke-width="1.5"/>
            <line x1="60" y1="20" x2="60" y2="200" stroke="#94a3b8" stroke-width="1.5"/>
            <!-- y=0 reference line -->
            <line x1="60" y1="130" x2="480" y2="130" stroke="#cbd5e1" stroke-width="1" stroke-dasharray="4,4"/>
            <!-- Shaded area under curve (above x-axis only) -->
            <path d="M61,200 L61,130 Q120,130 160,130 L160,130 Q200,100 260,85 Q340,65 420,50 L420,130 L160,130 L61,130 Z" fill="url(#logGrad)" stroke="none"/>
            <!-- log curve: passes through (1,0), rises slowly -->
            <path d="M61,200 Q70,165 80,150 Q100,130 120,120 Q160,100 200,90 Q260,75 320,65 Q380,56 440,50" fill="none" stroke="#0d9488" stroke-width="2.5" stroke-linecap="round"/>
            <!-- Exponential curve for comparison (dashed) -->
            <path d="M60,180 Q120,178 180,170 Q240,155 300,130 Q360,90 400,50" fill="none" stroke="#f59e0b" stroke-width="2" stroke-dasharray="6,4" stroke-linecap="round"/>
            <!-- Point (1, 0) -->
            <circle cx="120" cy="130" r="4" fill="#0d9488"/>
            <!-- Labels -->
            <text x="125" y="145" font-size="11" fill="#0d9488" font-weight="600">(1, 0)</text>
            <text x="442" y="45" font-size="11" fill="#0d9488" font-style="italic">log(x)</text>
            <text x="405" y="45" font-size="11" fill="#f59e0b" font-style="italic">b<tspan baseline-shift="super" font-size="8">x</tspan></text>
            <text x="488" y="205" font-size="12" fill="#94a3b8">x</text>
            <text x="45" y="25" font-size="12" fill="#94a3b8">y</text>
            <text x="65" y="127" font-size="10" fill="#94a3b8">0</text>
            <!-- Asymptote label -->
            <line x1="61" y1="20" x2="61" y2="200" stroke="#ef4444" stroke-width="1" stroke-dasharray="3,3" opacity="0.5"/>
            <text x="15" y="95" font-size="9" fill="#ef4444" font-weight="500">x = 0</text>
        </svg>
    </div>

    <!-- Logarithm Rules -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.5rem;color:var(--text-primary);">Logarithm Rules</h2>
        <table class="lc-rules-table">
            <thead>
                <tr><th style="width:30%;">Rule</th><th style="width:40%;">Formula</th><th>Example</th></tr>
            </thead>
            <tbody>
                <tr><td style="font-family:var(--font-sans);font-weight:500;">Product Rule</td><td>log<sub>b</sub>(MN) = log<sub>b</sub>(M) + log<sub>b</sub>(N)</td><td>log<sub>2</sub>(8&middot;4) = log<sub>2</sub>(8) + log<sub>2</sub>(4) = 3 + 2 = 5</td></tr>
                <tr><td style="font-family:var(--font-sans);font-weight:500;">Quotient Rule</td><td>log<sub>b</sub>(M/N) = log<sub>b</sub>(M) &minus; log<sub>b</sub>(N)</td><td>log<sub>10</sub>(100/10) = 2 &minus; 1 = 1</td></tr>
                <tr><td style="font-family:var(--font-sans);font-weight:500;">Power Rule</td><td>log<sub>b</sub>(M<sup>n</sup>) = n &middot; log<sub>b</sub>(M)</td><td>log<sub>2</sub>(8<sup>2</sup>) = 2 &middot; 3 = 6</td></tr>
                <tr><td style="font-family:var(--font-sans);font-weight:500;">Change of Base</td><td>log<sub>b</sub>(x) = ln(x) / ln(b)</td><td>log<sub>5</sub>(25) = ln(25)/ln(5) = 2</td></tr>
                <tr><td style="font-family:var(--font-sans);font-weight:500;">Identity</td><td>log<sub>b</sub>(b) = 1, &ensp; log<sub>b</sub>(1) = 0</td><td>log<sub>10</sub>(10) = 1, &ensp; ln(1) = 0</td></tr>
                <tr><td style="font-family:var(--font-sans);font-weight:500;">Inverse</td><td>b<sup>log<sub>b</sub>(x)</sup> = x, &ensp; log<sub>b</sub>(b<sup>x</sup>) = x</td><td>2<sup>log<sub>2</sub>(8)</sup> = 8</td></tr>
            </tbody>
        </table>
    </div>

    <!-- Types of Logarithms -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Types of Logarithms</h2>
        <div class="lc-edu-grid">
            <div class="lc-edu-card" style="border-left:3px solid #0d9488;">
                <h4>Natural Logarithm (ln)</h4>
                <p style="font-family:var(--font-mono);font-size:0.75rem;margin-bottom:0.375rem;">ln(x) = log<sub>e</sub>(x), &ensp; e &approx; 2.71828</p>
                <p>Used in calculus, physics, and continuous growth/decay. The derivative of ln(x) is 1/x.</p>
            </div>
            <div class="lc-edu-card" style="border-left:3px solid #14b8a6;">
                <h4>Common Logarithm (log<sub>10</sub>)</h4>
                <p style="font-family:var(--font-mono);font-size:0.75rem;margin-bottom:0.375rem;">log<sub>10</sub>(x) = log(x)</p>
                <p>Used in pH scale, decibels, Richter scale, and engineering. log<sub>10</sub>(1000) = 3.</p>
            </div>
            <div class="lc-edu-card" style="border-left:3px solid #2dd4bf;">
                <h4>Binary Logarithm (log<sub>2</sub>)</h4>
                <p style="font-family:var(--font-mono);font-size:0.75rem;margin-bottom:0.375rem;">log<sub>2</sub>(x) &mdash; bits needed to represent x</p>
                <p>Foundational in computer science: binary search is O(log<sub>2</sub> n), information entropy uses log<sub>2</sub>.</p>
            </div>
            <div class="lc-edu-card" style="border-left:3px solid #99f6e4;">
                <h4>Arbitrary Base (log<sub>b</sub>)</h4>
                <p style="font-family:var(--font-mono);font-size:0.75rem;margin-bottom:0.375rem;">log<sub>b</sub>(x) = ln(x) / ln(b)</p>
                <p>Any positive base &ne; 1. Common in music theory (semitones), number theory, and custom scales.</p>
            </div>
        </div>
    </div>

    <!-- How to Solve Log Equations -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">How to Solve Logarithmic Equations</h2>
        <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">The general strategy for solving logarithmic equations is to isolate the logarithm, then convert from log form to exponential form.</p>
        <div style="background:var(--log-light);border-left:3px solid var(--log-tool);padding:1rem;border-radius:0 var(--radius-md) var(--radius-md) 0;margin-bottom:0.75rem;">
            <p style="color:var(--text-primary);font-weight:600;margin-bottom:0.5rem;font-size:0.875rem;">Step 1: Combine logs on each side using product/quotient rules</p>
            <p style="color:var(--text-primary);font-weight:600;margin-bottom:0.5rem;font-size:0.875rem;">Step 2: Convert to exponential form: log<sub>b</sub>(x) = y &rArr; b<sup>y</sup> = x</p>
            <p style="color:var(--text-primary);font-weight:600;margin:0;font-size:0.875rem;">Step 3: Solve the resulting equation and check for extraneous solutions (arguments must be &gt; 0)</p>
        </div>

        <!-- Solving log equation SVG -->
        <svg class="lc-diagram" viewBox="0 0 500 150" xmlns="http://www.w3.org/2000/svg" style="max-width:460px;">
            <!-- Step boxes -->
            <rect x="10" y="30" width="140" height="60" rx="8" fill="#ccfbf1" stroke="#0d9488" stroke-width="1.5"/>
            <text x="80" y="55" font-size="11" fill="#0d9488" font-weight="600" text-anchor="middle">Log Form</text>
            <text x="80" y="75" font-size="12" fill="#0f766e" font-weight="700" text-anchor="middle" font-family="monospace">log<tspan font-size="9" baseline-shift="sub">b</tspan>(x) = y</text>

            <polygon points="160,60 175,52 175,55 200,55 200,65 175,65 175,68" fill="#0d9488"/>

            <rect x="210" y="30" width="140" height="60" rx="8" fill="#ccfbf1" stroke="#0d9488" stroke-width="1.5"/>
            <text x="280" y="55" font-size="11" fill="#0d9488" font-weight="600" text-anchor="middle">Exponential Form</text>
            <text x="280" y="75" font-size="12" fill="#0f766e" font-weight="700" text-anchor="middle" font-family="monospace">b<tspan font-size="9" baseline-shift="super">y</tspan> = x</text>

            <polygon points="360,60 375,52 375,55 400,55 400,65 375,65 375,68" fill="#0d9488"/>

            <rect x="410" y="30" width="80" height="60" rx="8" fill="#0d9488" stroke="#0f766e" stroke-width="1.5"/>
            <text x="450" y="55" font-size="11" fill="#fff" font-weight="600" text-anchor="middle">Solve</text>
            <text x="450" y="75" font-size="12" fill="#fff" font-weight="700" text-anchor="middle" font-family="monospace">x = ?</text>

            <text x="250" y="125" font-size="10" fill="#94a3b8" text-anchor="middle" font-style="italic">Check: argument of log must be positive</text>
        </svg>
        <p style="color:var(--text-secondary);margin:0;line-height:1.7;font-size:0.875rem;">This calculator automates this process: it first tries algebraic solving via nerdamer (eliminating log fractions, converting to exponential form), and falls back to AI-powered step-by-step solutions for complex cases.</p>
    </div>

    <!-- Applications -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Applications of Logarithms</h2>
        <div class="lc-edu-grid" style="grid-template-columns:repeat(auto-fit,minmax(200px,1fr));">
            <div class="lc-edu-card" style="text-align:center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#127981;</div>
                <h4>Compound Interest</h4>
                <p>How long to double your money? t = ln(2)/ln(1+r). Logarithms solve exponential growth equations.</p>
            </div>
            <div class="lc-edu-card" style="text-align:center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#127880;</div>
                <h4>Decibel Scale</h4>
                <p>Sound intensity: dB = 10 &middot; log<sub>10</sub>(I/I<sub>0</sub>). A logarithmic scale for human perception.</p>
            </div>
            <div class="lc-edu-card" style="text-align:center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#129514;</div>
                <h4>pH Scale</h4>
                <p>pH = &minus;log<sub>10</sub>[H<sup>+</sup>]. Measures acidity on a logarithmic scale from 0 to 14.</p>
            </div>
            <div class="lc-edu-card" style="text-align:center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#128187;</div>
                <h4>Algorithm Complexity</h4>
                <p>Binary search: O(log n). B-trees, merge sort, and many algorithms have logarithmic complexity.</p>
            </div>
        </div>
    </div>

    <!-- FAQ Section -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What types of logarithm problems can this calculator solve?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">This calculator solves logarithmic equations (log&#x2082;(x) = 5), simplifies expressions (log(e&#xB2;) = 2), expands logarithms using product/quotient/power rules, condenses multiple logs into one, and evaluates to decimal values. It supports natural log (ln), common log (log&#x2081;&#x2080;), binary log (log&#x2082;), and any custom base via logb(x, base).</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the difference between Solve, Expand, Condense, Simplify, and Evaluate?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer"><strong>Solve</strong> finds the variable value in a log equation (log&#x2082;(x) = 3 &rarr; x = 8). <strong>Expand</strong> breaks a single log into multiple logs using rules (log(x&sup2;y) &rarr; 2log(x) + log(y)). <strong>Condense</strong> combines multiple logs into one (2log(x) + log(y) &rarr; log(x&sup2;y)). <strong>Simplify</strong> reduces to the simplest form (log(e&sup2;) &rarr; 2). <strong>Evaluate</strong> computes a decimal result (log&#x2082;(10) &rarr; 3.32193).</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How does the hybrid solver work?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The calculator first attempts to solve the problem using nerdamer, a client-side computer algebra system. It normalizes all log bases to the change-of-base formula, eliminates common log denominators, and uses algebraic solving. If nerdamer cannot solve the problem (e.g., transcendental equations with mixed bases), it automatically falls back to AI-powered step-by-step solutions using GPT-4o-mini. This gives you instant results for standard problems and detailed explanations for complex ones.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the difference between ln and log?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer"><strong>ln</strong> (natural logarithm) is log base <em>e</em> (&approx; 2.71828). <strong>log</strong> typically means log base 10 in everyday use, but in pure mathematics and this calculator's internal engine (nerdamer), log means natural log. This calculator accepts both: type <code>ln(x)</code> or <code>log(x)</code> for natural log, and <code>log10(x)</code> for common log base 10.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Is this calculator free? Do I need to sign up?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">This logarithm calculator is completely free with no signup, no account, and no limits. You get formula-based solving, AI-powered step-by-step solutions, an interactive Plotly graph, Python SymPy compiler, LaTeX copy, and shareable URLs. Most computation runs in your browser for instant results.</div>
        </div>
    </div>
</section>

<!-- Explore More Math -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h3 style="font-size:1.15rem;font-weight:600;margin:0 0 1rem;display:flex;align-items:center;gap:0.5rem;color:var(--text-primary);">
            <span style="font-size:1.3rem;">&#128293;</span> Explore More Math
        </h3>
        <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:1rem;">
            <a href="<%=request.getContextPath()%>/exams/quick-math/" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(13,148,136,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#f59e0b,#d97706);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.4rem;">&#9889;</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Quick Math</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">150+ mental math tricks and Vedic math shortcuts for speed calculation</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(13,148,136,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#8b5cf6,#7c3aed);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.4rem;">&#128202;</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Visual Math Lab</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">35 interactive visualizations for algebra, calculus, trigonometry and statistics</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/integral-calculator.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(13,148,136,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#4f46e5,#6366f1);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.4rem;">&#8747;</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Integral Calculator</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Step-by-step integration with graphs, PDF export, and Python SymPy compiler</p>
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
<%@ include file="modern/components/analytics.jsp" %>
</body>
</html>
