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

    <!-- Resource Hints -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdn.jsdelivr.net">
    <link rel="dns-prefetch" href="https://cdn.plot.ly">

    <!-- Convolution Calculator styles -->
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/convolution-calculator.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript><link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/convolution-calculator.css?v=<%=cacheVersion%>"></noscript>

    <!-- SEO -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Convolution Calculator with Steps - Continuous & Discrete | Free" />
        <jsp:param name="toolDescription" value="Free online convolution calculator. Compute continuous and discrete convolution with detailed step-by-step solutions. Features symbolic integration via SymPy, interactive graphs, convolution properties table, and built-in Python compiler. No signup required." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="convolution-calculator.jsp" />
        <jsp:param name="toolKeywords" value="convolution calculator, convolution integral, discrete convolution, continuous convolution, signal processing, impulse response, LTI systems, convolution theorem, flip and slide" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Continuous convolution with symbolic integration,Discrete convolution with NumPy,Step-by-step solutions,Convolution properties reference table,Interactive line and stem plots,Continuous and discrete modes,Live KaTeX math preview,Copy LaTeX output,Built-in Python compiler with SymPy,Quick examples for each mode,Dark mode support,Free and no signup required" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What is convolution?" />
        <jsp:param name="faq1a" value="Convolution is a mathematical operation that combines two functions to produce a third function. For continuous signals, it is defined as (f*g)(t) = integral from -infinity to infinity of f(tau)*g(t-tau) dtau. For discrete signals, it is a sum: (x*h)[n] = sum of x[k]*h[n-k]. Convolution describes the output of a linear time-invariant (LTI) system." />
        <jsp:param name="faq2q" value="What is the difference between continuous and discrete convolution?" />
        <jsp:param name="faq2a" value="Continuous convolution uses an integral and works with continuous-time signals like analog waveforms. Discrete convolution uses a summation and works with sequences of numbers, such as digital signals. The underlying concept is the same - flip one signal, slide it across the other, and compute the overlap at each point." />
        <jsp:param name="faq3q" value="What is the convolution theorem?" />
        <jsp:param name="faq3a" value="The convolution theorem states that convolution in the time domain equals multiplication in the frequency domain: F{f*g} = F(omega)*G(omega). This means you can compute convolution by taking Fourier transforms of both signals, multiplying them, and taking the inverse transform. This is often computationally faster than direct convolution." />
        <jsp:param name="faq4q" value="What is an impulse response?" />
        <jsp:param name="faq4a" value="The impulse response h(t) is the output of an LTI system when the input is a Dirac delta function. It completely characterizes the system because the output for any input x(t) can be found by convolving x(t) with h(t): y(t) = x(t) * h(t). This is the foundation of LTI system analysis." />
        <jsp:param name="faq5q" value="How does convolution relate to filtering?" />
        <jsp:param name="faq5a" value="Filtering is essentially convolution. When you apply a filter to a signal, you are convolving the signal with the filter's impulse response. In the frequency domain, this corresponds to multiplying the signal's spectrum by the filter's frequency response. Low-pass, high-pass, and band-pass filters are all implemented through convolution." />
        <jsp:param name="faq6q" value="Is this convolution calculator free?" />
        <jsp:param name="faq6a" value="Yes, this calculator is completely free with no signup required. You get symbolic computation via SymPy for continuous convolution, NumPy for discrete convolution, step-by-step solutions, interactive graphs, and a built-in Python compiler." />
    </jsp:include>

    <!-- Fonts -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>

    <!-- CSS - all async -->
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

    <!-- KaTeX -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">

</head>
<body>
<!-- Navigation -->
<%@ include file="modern/components/nav-header.jsp" %>

<!-- Page Header -->
<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">Convolution Calculator</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/math">Math Tools</a> /
                Convolution Calculator
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">Step-by-Step</span>
            <span class="tool-badge">Continuous &amp; Discrete</span>
            <span class="tool-badge">Symbolic CAS</span>
            <span class="tool-badge">Free &middot; No Signup</span>
        </div>
    </div>
</header>

<!-- Tool Description -->
<section class="tool-description-section">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>Compute <strong>continuous</strong> and <strong>discrete convolution</strong> with <strong>step-by-step solutions</strong>. Features symbolic integration via SymPy, interactive line and stem plots, convolution properties table, and a built-in Python compiler. Essential for signal processing, control systems, and LTI system analysis.</p>
        </div>
    </div>
</section>

<!-- Main Content -->
<main class="tool-page-container">
    <!-- ========== INPUT COLUMN ========== -->
    <div class="tool-input-column">
        <div class="tool-card">
            <div class="tool-card-header">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;">
                    <path d="M12 2L2 7l10 5 10-5-10-5z"/>
                    <path d="M2 17l10 5 10-5"/>
                    <path d="M2 12l10 5 10-5"/>
                </svg>
                Convolution Calculator
            </div>
            <div class="tool-card-body">
                <!-- Mode toggle -->
                <div class="cv-mode-toggle">
                    <button type="button" class="cv-mode-btn active" data-mode="continuous">(f&ast;g)(t) Continuous</button>
                    <button type="button" class="cv-mode-btn" data-mode="discrete">(x&ast;h)[n] Discrete</button>
                </div>

                <!-- Continuous mode inputs -->
                <div id="cv-cont-wrap">
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="cv-cont-f">f(t) &mdash; first function</label>
                        <input type="text" class="tool-input tool-input-mono" id="cv-cont-f" placeholder="e.g. exp(-t)*Heaviside(t)" autocomplete="off" spellcheck="false">
                        <span class="tool-form-hint">Enter a function of t</span>
                    </div>
                    <div class="cv-operator">&ast;</div>
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="cv-cont-g">g(t) &mdash; second function</label>
                        <input type="text" class="tool-input tool-input-mono" id="cv-cont-g" placeholder="e.g. Heaviside(t)" autocomplete="off" spellcheck="false">
                        <span class="tool-form-hint">Enter a function of t</span>
                    </div>
                </div>

                <!-- Discrete mode inputs -->
                <div id="cv-disc-wrap" style="display:none;">
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="cv-disc-x">x[n] &mdash; input sequence</label>
                        <input type="text" class="tool-input tool-input-mono" id="cv-disc-x" placeholder="e.g. 1,2,3" autocomplete="off" spellcheck="false">
                        <span class="tool-form-hint">Comma-separated values</span>
                    </div>
                    <div class="cv-operator">&ast;</div>
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="cv-disc-h">h[n] &mdash; impulse response</label>
                        <input type="text" class="tool-input tool-input-mono" id="cv-disc-h" placeholder="e.g. 1,1,1" autocomplete="off" spellcheck="false">
                        <span class="tool-form-hint">Comma-separated values</span>
                    </div>
                </div>

                <!-- Live preview -->
                <div class="tool-form-group" style="margin-top:0.875rem;">
                    <label class="tool-form-label">Live Preview</label>
                    <div class="cv-preview" id="cv-preview">
                        <span style="color:var(--text-muted);font-size:0.8125rem;">Enter functions above&hellip;</span>
                    </div>
                </div>

                <!-- Action buttons -->
                <div class="cv-action-row">
                    <button type="button" class="tool-action-btn cv-compute-btn" id="cv-compute-btn">Compute</button>
                    <button type="button" class="cv-random-btn" id="cv-random-btn" title="Random example">&#127922; Random</button>
                </div>

                <hr class="cv-sep">

                <!-- Quick examples -->
                <div class="tool-form-group">
                    <label class="tool-form-label">Quick Examples</label>
                    <div class="cv-examples" id="cv-examples"></div>
                </div>

                <hr class="cv-sep">

                <!-- Convolution Properties (collapsible) -->
                <div id="cv-props-wrap">
                    <button type="button" class="cv-props-toggle" id="cv-props-btn">
                        Convolution Properties
                        <svg class="cv-props-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                    </button>
                    <div class="cv-props-content" id="cv-props-content">
                        <table class="cv-props-table">
                            <thead><tr><th>Property</th><th>Notes</th></tr></thead>
                            <tbody>
                                <tr><td id="cv-prop-formula-0"></td><td id="cv-prop-notes-0"></td></tr>
                                <tr><td id="cv-prop-formula-1"></td><td id="cv-prop-notes-1"></td></tr>
                                <tr><td id="cv-prop-formula-2"></td><td id="cv-prop-notes-2"></td></tr>
                                <tr><td id="cv-prop-formula-3"></td><td id="cv-prop-notes-3"></td></tr>
                                <tr><td id="cv-prop-formula-4"></td><td id="cv-prop-notes-4"></td></tr>
                                <tr><td id="cv-prop-formula-5"></td><td id="cv-prop-notes-5"></td></tr>
                                <tr><td id="cv-prop-formula-6"></td><td id="cv-prop-notes-6"></td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <hr class="cv-sep">

                <!-- Syntax help (collapsible) -->
                <div id="cv-syntax-wrap">
                    <button type="button" class="cv-syntax-toggle" id="cv-syntax-btn">
                        Syntax Help
                        <svg class="cv-syntax-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                    </button>
                    <div class="cv-syntax-content" id="cv-syntax-content">
                        <strong>Continuous mode:</strong><br>
                        exp(-t)*Heaviside(t) &nbsp;&nbsp; sin(t)*Heaviside(t)<br>
                        DiracDelta(t) &nbsp;&nbsp; t*exp(-2*t)*Heaviside(t)<br>
                        Heaviside(t)-Heaviside(t-1) &nbsp; (rectangle pulse)<br>
                        <strong>Multiplication:</strong> Use * explicitly: <code>t*exp(-t)</code><br>
                        <strong>Discrete mode:</strong><br>
                        Comma-separated values: <code>1,2,3</code> or <code>1,-1,1,-1</code><br>
                        No brackets needed, just the values
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ========== OUTPUT COLUMN ========== -->
    <div class="tool-output-column">
        <!-- Tab bar -->
        <div class="cv-output-tabs">
            <button type="button" class="cv-output-tab active" data-panel="result">Result</button>
            <button type="button" class="cv-output-tab" data-panel="graph">Graph</button>
            <button type="button" class="cv-output-tab" data-panel="python">Python Compiler</button>
        </div>

        <!-- Result Panel -->
        <div class="cv-panel active" id="cv-panel-result">
            <div class="tool-card tool-result-card">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                    </svg>
                    <h4>Result</h4>
                </div>
                <div class="tool-result-content" id="cv-result-content">
                    <div class="tool-empty-state" id="cv-empty-state">
                        <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&ast;</div>
                        <h3>Enter functions and click Compute</h3>
                        <p>Compute continuous or discrete convolution with step-by-step solutions.</p>
                    </div>
                </div>
                <div class="tool-result-actions" id="cv-result-actions">
                    <button type="button" class="tool-action-btn" id="cv-copy-latex-btn">
                        <span>&#128203;</span> Copy LaTeX
                    </button>
                    <button type="button" class="tool-action-btn" id="cv-download-pdf-btn">
                        <span>&#128196;</span> Download PDF
                    </button>
                    <button type="button" class="tool-action-btn" id="cv-share-btn">
                        <span>&#128279;</span> Share
                    </button>
                    <button type="button" class="tool-action-btn" id="cv-worksheet-btn">
                        <span>&#128218;</span> Print Worksheet
                    </button>
                </div>
            </div>
        </div>

        <!-- Graph Panel -->
        <div class="cv-panel" id="cv-panel-graph">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/>
                    </svg>
                    <h4>Convolution Output</h4>
                </div>
                <div style="flex:1;min-height:0;padding:0.75rem;">
                    <div id="cv-graph-container"></div>
                    <p id="cv-graph-hint" style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">Compute a convolution to see the output plot.</p>
                </div>
            </div>
        </div>

        <!-- Python Compiler Panel -->
        <div class="cv-panel" id="cv-panel-python">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <polygon points="5 3 19 12 5 21 5 3"/>
                    </svg>
                    <h4>Python Compiler</h4>
                </div>
                <div style="flex:1;min-height:0;">
                    <iframe id="cv-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                </div>
            </div>
        </div>
    </div>

    <!-- ========== ADS COLUMN ========== -->
    <div class="tool-ads-column">
        <%@ include file="modern/ads/ad-three-column.jsp" %>
    </div>
</main>

<!-- Mobile Ad Fallback -->
<div class="tool-mobile-ad-container">
    <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
</div>

<!-- Related Tools -->
<jsp:include page="modern/components/related-tools.jsp">
    <jsp:param name="currentToolUrl" value="convolution-calculator.jsp"/>
    <jsp:param name="keyword" value="calculus"/>
    <jsp:param name="limit" value="6"/>
</jsp:include>

<!-- ========== BELOW-FOLD EDUCATIONAL CONTENT ========== -->
<section class="tool-expertise-section" style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">

    <!-- What is Convolution? -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">What is Convolution?</h2>
        <p style="color: var(--text-secondary); margin-bottom: 0.75rem; line-height: 1.7;">Convolution is a fundamental mathematical operation that combines two functions to produce a third function expressing how the shape of one is modified by the other. For continuous signals, it is defined as <strong>(f&ast;g)(t) = &int;<sub>&minus;&infin;</sub><sup>&infin;</sup> f(&tau;) g(t&minus;&tau;) d&tau;</strong>.</p>
        <p style="color: var(--text-secondary); margin-bottom: 0; line-height: 1.7;">For discrete signals, convolution is a summation: <strong>(x&ast;h)[n] = &Sigma;<sub>k</sub> x[k] &middot; h[n&minus;k]</strong>. In both cases, one function is flipped and slid across the other, computing the overlap at each position. Convolution is the key operation in linear time-invariant (LTI) systems.</p>
    </div>

    <!-- Key Properties -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 0.5rem; color: var(--text-primary);">Key Properties</h2>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 1rem; margin-top: 1rem;">
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #d97706;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Commutativity</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">f&ast;g = g&ast;f. The order of the functions does not matter. You can convolve in either direction.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #f59e0b;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Convolution Theorem</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">F{f&ast;g} = F(&omega;)&middot;G(&omega;). Convolution in time equals multiplication in frequency, enabling fast computation via FFT.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #b45309;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Identity Element</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">f&ast;&delta; = f. Convolving any function with the Dirac delta returns the original function unchanged.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #fbbf24;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Distributivity</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">f&ast;(g+h) = f&ast;g + f&ast;h. Convolution distributes over addition, like multiplication.</p>
            </div>
        </div>
    </div>

    <!-- Applications -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">Applications</h2>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem;">
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#128225;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Signal Processing</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Filter design, echo/reverb effects, noise removal, and system response analysis.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#128444;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Image Processing</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Blur, sharpen, edge detection, and feature extraction using 2D convolution kernels.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#127922;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Probability</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">The PDF of the sum of independent random variables is the convolution of their individual PDFs.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#9881;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Control Systems</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">System output = input convolved with impulse response. Foundation of LTI system theory.</p>
            </div>
        </div>
    </div>

    <!-- FAQ Section -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem;" id="faqs">Frequently Asked Questions</h2>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is convolution?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Convolution is a mathematical operation that combines two functions to produce a third function. For continuous signals, it is defined as (f*g)(t) = integral from -infinity to infinity of f(tau)*g(t-tau) dtau. For discrete signals, it is a sum: (x*h)[n] = sum of x[k]*h[n-k]. Convolution describes the output of a linear time-invariant (LTI) system.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the difference between continuous and discrete convolution?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Continuous convolution uses an integral and works with continuous-time signals like analog waveforms. Discrete convolution uses a summation and works with sequences of numbers, such as digital signals. The underlying concept is the same - flip one signal, slide it across the other, and compute the overlap at each point.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the convolution theorem?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The convolution theorem states that convolution in the time domain equals multiplication in the frequency domain: F{f*g} = F(omega)*G(omega). This means you can compute convolution by taking Fourier transforms of both signals, multiplying them, and taking the inverse transform. This is often computationally faster than direct convolution.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is an impulse response?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The impulse response h(t) is the output of an LTI system when the input is a Dirac delta function. It completely characterizes the system because the output for any input x(t) can be found by convolving x(t) with h(t): y(t) = x(t) * h(t). This is the foundation of LTI system analysis.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How does convolution relate to filtering?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Filtering is essentially convolution. When you apply a filter to a signal, you are convolving the signal with the filter's impulse response. In the frequency domain, this corresponds to multiplying the signal's spectrum by the filter's frequency response. Low-pass, high-pass, and band-pass filters are all implemented through convolution.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Is this convolution calculator free?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes, this calculator is completely free with no signup required. You get symbolic computation via SymPy for continuous convolution, NumPy for discrete convolution, step-by-step solutions, interactive graphs, and a built-in Python compiler.</div>
        </div>
    </div>
</section>

<!-- Explore More Math -->
<section style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">
    <div class="tool-card" style="padding: 1.5rem 2rem;">
        <h3 style="font-size: 1.15rem; font-weight: 600; margin: 0 0 1rem; display: flex; align-items: center; gap: 0.5rem; color: var(--text-primary);">
            <span style="font-size: 1.3rem;">&#128293;</span> Explore More Math
        </h3>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 1rem;">
            <a href="<%=request.getContextPath()%>/fourier-transform-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(217,119,6,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #7c3aed, #a855f7); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem; color: #fff;">&#8497;</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Fourier Transform Calculator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Forward &amp; inverse Fourier transforms for signal analysis</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/laplace-transform-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(217,119,6,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #0891b2, #06b6d4); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem; color: #fff;">&#8466;</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Laplace Transform Calculator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Forward &amp; inverse Laplace transforms with steps and ROC</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/bode-plot-generator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(217,119,6,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #dc2626, #ef4444); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.1rem; font-weight: 700; color: #fff;">H(s)</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Bode Plot Generator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Magnitude &amp; phase plots for transfer functions</p>
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
<%@ include file="modern/components/analytics.jsp" %>

<!-- KaTeX JS -->
<script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>

<!-- Plotly (deferred until graph tab clicked) -->
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

<script>window.CV_CALC_CTX = "<%=request.getContextPath()%>";</script>
<script src="<%=request.getContextPath()%>/modern/js/convolution-calculator.js?v=<%=cacheVersion%>"></script>

</body>
</html>
