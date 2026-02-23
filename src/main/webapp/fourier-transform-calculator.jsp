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

    <!-- Fourier Transform Calculator styles -->
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/fourier-transform-calculator.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript><link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/fourier-transform-calculator.css?v=<%=cacheVersion%>"></noscript>

    <!-- SEO -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Fourier Transform Calculator with Steps - Forward & Inverse | Free" />
        <jsp:param name="toolDescription" value="Free online Fourier transform calculator. Compute forward and inverse Fourier transforms with detailed step-by-step solutions. Features common Fourier pairs table, frequency domain analysis, 2D graph, and built-in Python compiler. No signup required." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="fourier-transform-calculator.jsp" />
        <jsp:param name="toolKeywords" value="fourier transform calculator, inverse fourier transform calculator, fourier transform with steps, frequency domain, signal processing, DFT, convolution theorem, fourier pairs, spectrum analysis" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Forward Fourier transform with steps,Inverse Fourier transform with steps,Common Fourier pairs reference table,Frequency domain analysis,2D function graph,Live KaTeX math preview,Copy LaTeX output,Built-in Python compiler with SymPy,Quick examples for each mode,Dark mode support,Free and no signup required" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What is the Fourier transform?" />
        <jsp:param name="faq1a" value="The Fourier transform decomposes a time-domain signal f(t) into its constituent frequencies, producing a frequency-domain representation F(omega). It is defined as F{f(t)} = integral from -infinity to infinity of f(t)*e^(-2*pi*i*omega*t) dt. It is fundamental in signal processing, physics, and engineering." />
        <jsp:param name="faq2q" value="What is the difference between forward and inverse Fourier transform?" />
        <jsp:param name="faq2a" value="The forward Fourier transform converts a time-domain function f(t) to the frequency domain F(omega). The inverse Fourier transform does the reverse, converting F(omega) back to f(t). Together they allow analysis and synthesis of signals in both domains." />
        <jsp:param name="faq3q" value="What is the frequency domain?" />
        <jsp:param name="faq3a" value="The frequency domain is a representation of a signal in terms of its frequency components rather than time. The Fourier transform maps signals from the time domain to the frequency domain, revealing the amplitude and phase of each frequency present in the signal." />
        <jsp:param name="faq4q" value="What is the difference between Fourier and Laplace transforms?" />
        <jsp:param name="faq4a" value="The Laplace transform uses a complex variable s = sigma + j*omega and integrates from 0 to infinity (one-sided). The Fourier transform uses purely imaginary frequency omega and integrates from -infinity to infinity. The Fourier transform can be seen as a special case of the Laplace transform evaluated on the imaginary axis (s = j*omega)." />
        <jsp:param name="faq5q" value="What is the convolution theorem?" />
        <jsp:param name="faq5a" value="The convolution theorem states that the Fourier transform of a convolution of two functions equals the product of their individual Fourier transforms: F{f*g} = F(omega)*G(omega). This property is fundamental in signal processing and filter design." />
        <jsp:param name="faq6q" value="Is this Fourier transform calculator free?" />
        <jsp:param name="faq6a" value="Yes, this calculator is completely free with no signup required. You get symbolic computation via SymPy, step-by-step solutions, 2D graphs, LaTeX export, and a built-in Python compiler." />
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
            <h1 class="tool-page-title">Fourier Transform Calculator</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/math">Math Tools</a> /
                Fourier Transform Calculator
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">Step-by-Step</span>
            <span class="tool-badge">Forward &amp; Inverse</span>
            <span class="tool-badge">Symbolic CAS</span>
            <span class="tool-badge">Free &middot; No Signup</span>
        </div>
    </div>
</header>

<!-- Tool Description -->
<section class="tool-description-section">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>Compute <strong>forward</strong> and <strong>inverse Fourier transforms</strong> with <strong>detailed step-by-step solutions</strong>. Features a complete Fourier pairs reference table, frequency domain analysis, 2D graphs, and a built-in Python compiler. Essential for signal processing, communications, and image analysis.</p>
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
                Fourier Transform
            </div>
            <div class="tool-card-body">
                <!-- Mode toggle -->
                <div class="ft-mode-toggle">
                    <button type="button" class="ft-mode-btn active" data-mode="forward">&#8497;{f(t)} Forward</button>
                    <button type="button" class="ft-mode-btn" data-mode="inverse">&#8497;&#8315;&#185;{F(&omega;)} Inverse</button>
                </div>

                <!-- Forward mode input -->
                <div id="ft-forward-wrap">
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="ft-forward-expr">f(t) &mdash; time-domain function</label>
                        <input type="text" class="tool-input tool-input-mono" id="ft-forward-expr" placeholder="e.g. exp(-t^2)" autocomplete="off" spellcheck="false">
                        <span class="tool-form-hint">Enter a function of t</span>
                    </div>
                </div>

                <!-- Inverse mode input -->
                <div id="ft-inverse-wrap" style="display:none;">
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="ft-inverse-expr">F(&omega;) &mdash; frequency-domain function</label>
                        <input type="text" class="tool-input tool-input-mono" id="ft-inverse-expr" placeholder="e.g. 1/(1+w^2)" autocomplete="off" spellcheck="false">
                        <span class="tool-form-hint">Enter a function of w (&omega;)</span>
                    </div>
                </div>

                <!-- Live preview -->
                <div class="tool-form-group" style="margin-top:0.875rem;">
                    <label class="tool-form-label">Live Preview</label>
                    <div class="ft-preview" id="ft-preview">
                        <span style="color:var(--text-muted);font-size:0.8125rem;">Type an expression above&hellip;</span>
                    </div>
                </div>

                <!-- Action buttons -->
                <div class="ft-action-row">
                    <button type="button" class="tool-action-btn ft-compute-btn" id="ft-compute-btn">Compute</button>
                    <button type="button" class="ft-random-btn" id="ft-random-btn" title="Random example">&#127922; Random</button>
                </div>

                <hr class="ft-sep">

                <!-- Quick examples -->
                <div class="tool-form-group">
                    <label class="tool-form-label">Quick Examples</label>
                    <div class="ft-examples" id="ft-examples"></div>
                </div>

                <hr class="ft-sep">

                <!-- Common Fourier Pairs (collapsible) -->
                <div id="ft-pairs-wrap">
                    <button type="button" class="ft-pairs-toggle" id="ft-pairs-btn">
                        Common Fourier Pairs
                        <svg class="ft-pairs-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                    </button>
                    <div class="ft-pairs-content" id="ft-pairs-content">
                        <table class="ft-pairs-table">
                            <thead><tr><th>f(t)</th><th>F(&omega;)</th><th>Notes</th></tr></thead>
                            <tbody>
                                <tr><td id="ft-pair-f0"></td><td id="ft-pair-F0"></td><td>Impulse</td></tr>
                                <tr><td id="ft-pair-f1"></td><td id="ft-pair-F1"></td><td>DC signal</td></tr>
                                <tr><td id="ft-pair-f2"></td><td id="ft-pair-F2"></td><td>a &gt; 0</td></tr>
                                <tr><td id="ft-pair-f3"></td><td id="ft-pair-F3"></td><td>a &gt; 0</td></tr>
                                <tr><td id="ft-pair-f4"></td><td id="ft-pair-F4"></td><td>Gaussian</td></tr>
                                <tr><td id="ft-pair-f5"></td><td id="ft-pair-F5"></td><td>Rect&harr;Sinc</td></tr>
                                <tr><td id="ft-pair-f6"></td><td id="ft-pair-F6"></td><td>Sinc&harr;Rect</td></tr>
                                <tr><td id="ft-pair-f7"></td><td id="ft-pair-F7"></td><td>Cosine</td></tr>
                                <tr><td id="ft-pair-f8"></td><td id="ft-pair-F8"></td><td>a &gt; 0</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <hr class="ft-sep">

                <!-- Syntax help (collapsible) -->
                <div id="ft-syntax-wrap">
                    <button type="button" class="ft-syntax-toggle" id="ft-syntax-btn">
                        Syntax Help
                        <svg class="ft-syntax-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                    </button>
                    <div class="ft-syntax-content" id="ft-syntax-content">
                        t^2 &nbsp;&nbsp; w^3 &nbsp;&nbsp; (w+1)^2<br>
                        sin(2*pi*t) &nbsp;&nbsp; cos(pi*t)<br>
                        e^(-3*t) &nbsp;&nbsp; exp(-t^2)<br>
                        Abs(t) &nbsp;&nbsp; Abs(w)<br>
                        Heaviside(t-2) &nbsp;&nbsp; DiracDelta(t)<br>
                        1/(1+w^2) &nbsp;&nbsp; exp(-pi*w^2)<br>
                        <strong>Multiplication:</strong> Use * explicitly: <code>t*exp(-t)</code> not <code>texp(-t)</code><br>
                        <strong>Powers:</strong> <code>t^2</code> or <code>(w+1)^2</code><br>
                        <strong>Constants:</strong> pi, e, I (imaginary unit)
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ========== OUTPUT COLUMN ========== -->
    <div class="tool-output-column">
        <!-- Tab bar -->
        <div class="ft-output-tabs">
            <button type="button" class="ft-output-tab active" data-panel="result">Result</button>
            <button type="button" class="ft-output-tab" data-panel="graph">Graph</button>
            <button type="button" class="ft-output-tab" data-panel="python">Python Compiler</button>
        </div>

        <!-- Result Panel -->
        <div class="ft-panel active" id="ft-panel-result">
            <div class="tool-card tool-result-card">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                    </svg>
                    <h4>Result</h4>
                </div>
                <div class="tool-result-content" id="ft-result-content">
                    <div class="tool-empty-state" id="ft-empty-state">
                        <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#8497;</div>
                        <h3>Enter an expression and click Compute</h3>
                        <p>Compute forward or inverse Fourier transforms with step-by-step solutions.</p>
                    </div>
                </div>
                <div class="tool-result-actions" id="ft-result-actions">
                    <button type="button" class="tool-action-btn" id="ft-copy-latex-btn">
                        <span>&#128203;</span> Copy LaTeX
                    </button>
                    <button type="button" class="tool-action-btn" id="ft-download-pdf-btn">
                        <span>&#128196;</span> Download PDF
                    </button>
                    <button type="button" class="tool-action-btn" id="ft-share-btn">
                        <span>&#128279;</span> Share
                    </button>
                    <button type="button" class="tool-action-btn" id="ft-worksheet-btn">
                        <span>&#128218;</span> Print Worksheet
                    </button>
                </div>
            </div>
        </div>

        <!-- Graph Panel -->
        <div class="ft-panel" id="ft-panel-graph">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/>
                    </svg>
                    <h4>f(t) vs t</h4>
                </div>
                <div style="flex:1;min-height:0;padding:0.75rem;">
                    <div id="ft-graph-container"></div>
                    <p id="ft-graph-hint" style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">Compute a transform to see the time-domain plot.</p>
                </div>
            </div>
        </div>

        <!-- Python Compiler Panel -->
        <div class="ft-panel" id="ft-panel-python">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <polygon points="5 3 19 12 5 21 5 3"/>
                    </svg>
                    <h4>Python Compiler</h4>
                </div>
                <div style="flex:1;min-height:0;">
                    <iframe id="ft-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
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
    <jsp:param name="currentToolUrl" value="fourier-transform-calculator.jsp"/>
    <jsp:param name="keyword" value="calculus"/>
    <jsp:param name="limit" value="6"/>
</jsp:include>

<!-- ========== BELOW-FOLD EDUCATIONAL CONTENT ========== -->
<section class="tool-expertise-section" style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">

    <!-- What is the Fourier Transform? -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">What is the Fourier Transform?</h2>
        <p style="color: var(--text-secondary); margin-bottom: 0.75rem; line-height: 1.7;">The Fourier transform decomposes a time-domain signal f(t) into its constituent frequencies, producing a frequency-domain representation F(&omega;). It is defined as <strong>F{f(t)} = &int;<sub>&minus;&infin;</sub><sup>&infin;</sup> f(t) e<sup>&minus;2&pi;i&omega;t</sup> dt</strong>, where &omega; is the frequency variable.</p>
        <p style="color: var(--text-secondary); margin-bottom: 0; line-height: 1.7;">The Fourier transform is fundamental in signal processing, communications, image analysis, quantum mechanics, and many areas of applied mathematics and engineering.</p>
    </div>

    <!-- Key Properties -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 0.5rem; color: var(--text-primary);">Key Properties</h2>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 1rem; margin-top: 1rem;">
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #7c3aed;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Linearity</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">F{af(t) + bg(t)} = aF(&omega;) + bG(&omega;). The transform distributes over addition and scalar multiplication.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #a855f7;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Time-Shifting</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">F{f(t&minus;t<sub>0</sub>)} = e<sup>&minus;2&pi;i&omega;t<sub>0</sub></sup>F(&omega;). A time delay corresponds to a phase shift in frequency.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #6d28d9;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Frequency-Shifting</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">F{e<sup>2&pi;if<sub>0</sub>t</sup>f(t)} = F(&omega;&minus;f<sub>0</sub>). Modulation in time shifts the spectrum in frequency.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #8b5cf6;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Parseval's Theorem</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">&int;|f(t)|&sup2;dt = &int;|F(&omega;)|&sup2;d&omega;. Total energy is preserved between time and frequency domains.</p>
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
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Analyze frequency content of signals, design filters, and perform spectral analysis for communications systems.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#128444;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Image Processing</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">2D Fourier transforms enable image compression (JPEG), edge detection, and spatial frequency filtering.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#127925;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Audio Analysis</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Spectrograms, pitch detection, audio equalization, and noise reduction all rely on Fourier analysis.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#128241;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Communications</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">OFDM, modulation schemes, bandwidth analysis, and channel characterization use Fourier techniques.</p>
            </div>
        </div>
    </div>

    <!-- FAQ Section -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem;" id="faqs">Frequently Asked Questions</h2>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the Fourier transform?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The Fourier transform decomposes a time-domain signal f(t) into its constituent frequencies, producing a frequency-domain representation F(&omega;). It is defined as F{f(t)} = integral from -infinity to infinity of f(t)*e^(-2*pi*i*omega*t) dt. It is fundamental in signal processing, physics, and engineering.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the difference between forward and inverse Fourier transform?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The forward Fourier transform converts a time-domain function f(t) to the frequency domain F(&omega;). The inverse Fourier transform does the reverse, converting F(&omega;) back to f(t). Together they allow analysis and synthesis of signals in both domains.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the frequency domain?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The frequency domain is a representation of a signal in terms of its frequency components rather than time. The Fourier transform maps signals from the time domain to the frequency domain, revealing the amplitude and phase of each frequency present in the signal.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the difference between Fourier and Laplace transforms?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The Laplace transform uses a complex variable s = &sigma; + j&omega; and integrates from 0 to infinity (one-sided). The Fourier transform uses purely imaginary frequency &omega; and integrates from -infinity to infinity. The Fourier transform can be seen as a special case of the Laplace transform evaluated on the imaginary axis.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the convolution theorem?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The convolution theorem states that the Fourier transform of a convolution of two functions equals the product of their individual Fourier transforms: F{f*g} = F(&omega;)&middot;G(&omega;). This property is fundamental in signal processing and filter design.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Is this Fourier transform calculator free?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes, this calculator is completely free with no signup required. You get symbolic computation via SymPy, step-by-step solutions, 2D graphs, LaTeX export, and a built-in Python compiler.</div>
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
            <a href="<%=request.getContextPath()%>/laplace-transform-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(124,58,237,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #0891b2, #06b6d4); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem; color: #fff;">&#8466;</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Laplace Transform Calculator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Forward &amp; inverse Laplace transforms with steps and ROC</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/integral-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(124,58,237,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #4f46e5, #6366f1); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem; color: #fff;">&#8747;</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Integral Calculator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Solve integrals with step-by-step solutions, graphs, and PDF export</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/z-transform-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(124,58,237,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #059669, #10b981); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem; color: #fff;">Z</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Z-Transform Calculator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Forward &amp; inverse Z-transforms for discrete-time signals</p>
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

<script>window.FT_CALC_CTX = "<%=request.getContextPath()%>";</script>
<script src="<%=request.getContextPath()%>/modern/js/fourier-transform-calculator.js?v=<%=cacheVersion%>"></script>

</body>
</html>
