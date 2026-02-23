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

    <!-- Bode Plot Generator styles -->
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/bode-plot-generator.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript><link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/bode-plot-generator.css?v=<%=cacheVersion%>"></noscript>

    <!-- SEO -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Bode Plot Generator with Steps - Magnitude & Phase | Free Online Tool" />
        <jsp:param name="toolDescription" value="Free online Bode plot generator. Plot magnitude and phase diagrams for any transfer function H(s) with step-by-step analysis. Features zeros/poles identification, common transfer functions table, interactive Plotly graphs, and built-in Python compiler. No signup required." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="bode-plot-generator.jsp" />
        <jsp:param name="toolKeywords" value="bode plot generator, bode plot calculator, transfer function plotter, magnitude plot, phase plot, frequency response, control systems, bode diagram, gain margin, phase margin, stability analysis" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Bode magnitude and phase plots,Transfer function analysis with steps,Zeros and poles identification,Common transfer functions table,Interactive dual-subplot Plotly graphs,Zeros-Poles-Gain input mode,Live KaTeX math preview,Copy LaTeX output,Built-in Python compiler with SymPy,Quick examples for each mode,Dark mode support,Free and no signup required" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What is a Bode plot?" />
        <jsp:param name="faq1a" value="A Bode plot is a graphical representation of a system's frequency response. It consists of two plots: the magnitude plot showing |H(jw)| in decibels versus log frequency, and the phase plot showing the phase angle of H(jw) in degrees versus log frequency. Bode plots are essential for analyzing stability and performance of control systems." />
        <jsp:param name="faq2q" value="How do you read a Bode plot?" />
        <jsp:param name="faq2a" value="On a Bode plot, the x-axis is frequency on a logarithmic scale. The magnitude plot (top) shows gain in dB - positive values mean amplification, negative values mean attenuation. The phase plot (bottom) shows phase shift in degrees. Key features include the -3dB bandwidth, gain crossover frequency, and phase margin." />
        <jsp:param name="faq3q" value="What is gain and phase margin?" />
        <jsp:param name="faq3a" value="Gain margin is the amount of gain increase (in dB) needed to make the system unstable, measured at the phase crossover frequency (where phase = -180 degrees). Phase margin is the additional phase lag needed for instability, measured at the gain crossover frequency (where magnitude = 0 dB). Both should be positive for a stable system." />
        <jsp:param name="faq4q" value="How does pole location affect the Bode plot?" />
        <jsp:param name="faq4a" value="Each pole contributes -20 dB/decade slope to the magnitude plot and -90 degrees to the phase. A pole at s = -a creates a corner frequency at w = a, where the magnitude starts rolling off. Complex conjugate poles can create a resonance peak near the natural frequency, with the peak height depending on the damping ratio." />
        <jsp:param name="faq5q" value="Bode plot vs Nyquist plot?" />
        <jsp:param name="faq5a" value="A Bode plot shows magnitude and phase separately as functions of frequency on two subplots. A Nyquist plot shows the frequency response as a single curve in the complex plane (real vs imaginary parts). Bode plots are easier to sketch by hand and read gain/phase margins, while Nyquist plots are better for analyzing encirclement-based stability criteria." />
        <jsp:param name="faq6q" value="Is this Bode plot tool free?" />
        <jsp:param name="faq6a" value="Yes, this Bode plot generator is completely free with no signup required. You get symbolic computation via SymPy, step-by-step analysis, interactive Plotly graphs, LaTeX export, and a built-in Python compiler." />
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
            <h1 class="tool-page-title">Bode Plot Generator</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/math">Math Tools</a> /
                Bode Plot Generator
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">Step-by-Step</span>
            <span class="tool-badge">Magnitude &amp; Phase</span>
            <span class="tool-badge">Symbolic CAS</span>
            <span class="tool-badge">Free &middot; No Signup</span>
        </div>
    </div>
</header>

<!-- Tool Description -->
<section class="tool-description-section">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>Generate <strong>Bode magnitude and phase plots</strong> for any transfer function H(s) with <strong>step-by-step analysis</strong>. Features zeros/poles identification, common transfer functions reference table, interactive dual-subplot graphs, and a built-in Python compiler. Essential for control systems, filter design, and stability analysis.</p>
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
                Bode Plot Generator
            </div>
            <div class="tool-card-body">
                <!-- Mode toggle -->
                <div class="bp-mode-toggle">
                    <button type="button" class="bp-mode-btn active" data-mode="transfer">H(s) Transfer Function</button>
                    <button type="button" class="bp-mode-btn" data-mode="zpk">Zeros-Poles-Gain</button>
                </div>

                <!-- Transfer function mode input -->
                <div id="bp-tf-wrap">
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="bp-tf-expr">H(s) &mdash; transfer function</label>
                        <input type="text" class="tool-input tool-input-mono" id="bp-tf-expr" placeholder="e.g. 1/(s^2+2*s+1)" autocomplete="off" spellcheck="false">
                        <span class="tool-form-hint">Enter a rational function of s</span>
                    </div>
                </div>

                <!-- ZPK mode input -->
                <div id="bp-zpk-wrap" style="display:none;">
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="bp-zpk-zeros">Zeros (comma-separated)</label>
                        <input type="text" class="tool-input tool-input-mono" id="bp-zpk-zeros" placeholder="e.g. -1, -2" autocomplete="off" spellcheck="false">
                        <span class="tool-form-hint">Leave empty for no zeros</span>
                    </div>
                    <div class="tool-form-group" style="margin-top:0.5rem;">
                        <label class="tool-form-label" for="bp-zpk-poles">Poles (comma-separated)</label>
                        <input type="text" class="tool-input tool-input-mono" id="bp-zpk-poles" placeholder="e.g. 0, -10" autocomplete="off" spellcheck="false">
                        <span class="tool-form-hint">Use j for imaginary: -5+8.66j</span>
                    </div>
                    <div class="tool-form-group" style="margin-top:0.5rem;">
                        <label class="tool-form-label" for="bp-zpk-gain">Gain K</label>
                        <input type="text" class="tool-input tool-input-mono" id="bp-zpk-gain" placeholder="e.g. 10" value="1" autocomplete="off" spellcheck="false">
                    </div>
                </div>

                <!-- Live preview -->
                <div class="tool-form-group" style="margin-top:0.875rem;">
                    <label class="tool-form-label">Live Preview</label>
                    <div class="bp-preview" id="bp-preview">
                        <span style="color:var(--text-muted);font-size:0.8125rem;">Type a transfer function above&hellip;</span>
                    </div>
                </div>

                <!-- Action buttons -->
                <div class="bp-action-row">
                    <button type="button" class="tool-action-btn bp-compute-btn" id="bp-compute-btn">Generate Bode Plot</button>
                    <button type="button" class="bp-random-btn" id="bp-random-btn" title="Random example">&#127922; Random</button>
                </div>

                <hr class="bp-sep">

                <!-- Quick examples -->
                <div class="tool-form-group">
                    <label class="tool-form-label">Quick Examples</label>
                    <div class="bp-examples" id="bp-examples"></div>
                </div>

                <hr class="bp-sep">

                <!-- Common Transfer Functions (collapsible) -->
                <div id="bp-tf-table-wrap">
                    <button type="button" class="bp-tf-toggle" id="bp-tf-btn">
                        Common Transfer Functions
                        <svg class="bp-tf-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                    </button>
                    <div class="bp-tf-content" id="bp-tf-content">
                        <table class="bp-tf-table">
                            <thead><tr><th>System</th><th>H(s)</th><th>Type</th></tr></thead>
                            <tbody>
                                <tr><td id="bp-tf-sys-0"></td><td id="bp-tf-hs-0"></td><td id="bp-tf-type-0"></td></tr>
                                <tr><td id="bp-tf-sys-1"></td><td id="bp-tf-hs-1"></td><td id="bp-tf-type-1"></td></tr>
                                <tr><td id="bp-tf-sys-2"></td><td id="bp-tf-hs-2"></td><td id="bp-tf-type-2"></td></tr>
                                <tr><td id="bp-tf-sys-3"></td><td id="bp-tf-hs-3"></td><td id="bp-tf-type-3"></td></tr>
                                <tr><td id="bp-tf-sys-4"></td><td id="bp-tf-hs-4"></td><td id="bp-tf-type-4"></td></tr>
                                <tr><td id="bp-tf-sys-5"></td><td id="bp-tf-hs-5"></td><td id="bp-tf-type-5"></td></tr>
                                <tr><td id="bp-tf-sys-6"></td><td id="bp-tf-hs-6"></td><td id="bp-tf-type-6"></td></tr>
                                <tr><td id="bp-tf-sys-7"></td><td id="bp-tf-hs-7"></td><td id="bp-tf-type-7"></td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <hr class="bp-sep">

                <!-- Syntax help (collapsible) -->
                <div id="bp-syntax-wrap">
                    <button type="button" class="bp-syntax-toggle" id="bp-syntax-btn">
                        Syntax Help
                        <svg class="bp-syntax-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                    </button>
                    <div class="bp-syntax-content" id="bp-syntax-content">
                        s^2 &nbsp;&nbsp; (s+1)^2 &nbsp;&nbsp; s^3<br>
                        1/(s+1) &nbsp;&nbsp; s/(s^2+1)<br>
                        10*(s+1)/(s*(s+10))<br>
                        <strong>Multiplication:</strong> Use * explicitly: <code>2*s</code> not <code>2s</code><br>
                        <strong>Powers:</strong> <code>s^2</code> or <code>(s+1)^2</code><br>
                        <strong>Grouping:</strong> Use parentheses for clarity
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ========== OUTPUT COLUMN ========== -->
    <div class="tool-output-column">
        <!-- Tab bar -->
        <div class="bp-output-tabs">
            <button type="button" class="bp-output-tab active" data-panel="result">Result</button>
            <button type="button" class="bp-output-tab" data-panel="graph">Bode Plot</button>
            <button type="button" class="bp-output-tab" data-panel="python">Python Compiler</button>
        </div>

        <!-- Result Panel -->
        <div class="bp-panel active" id="bp-panel-result">
            <div class="tool-card tool-result-card">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                    </svg>
                    <h4>Result</h4>
                </div>
                <div class="tool-result-content" id="bp-result-content">
                    <div class="tool-empty-state" id="bp-empty-state">
                        <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">H(s)</div>
                        <h3>Enter a transfer function and click Generate</h3>
                        <p>Generate Bode magnitude and phase plots with step-by-step analysis.</p>
                    </div>
                </div>
                <div class="tool-result-actions" id="bp-result-actions">
                    <button type="button" class="tool-action-btn" id="bp-copy-latex-btn">
                        <span>&#128203;</span> Copy LaTeX
                    </button>
                    <button type="button" class="tool-action-btn" id="bp-download-pdf-btn">
                        <span>&#128196;</span> Download PDF
                    </button>
                    <button type="button" class="tool-action-btn" id="bp-share-btn">
                        <span>&#128279;</span> Share
                    </button>
                    <button type="button" class="tool-action-btn" id="bp-worksheet-btn">
                        <span>&#128218;</span> Print Worksheet
                    </button>
                </div>
            </div>
        </div>

        <!-- Graph Panel -->
        <div class="bp-panel" id="bp-panel-graph">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/>
                    </svg>
                    <h4>Bode Plot &mdash; Magnitude &amp; Phase</h4>
                </div>
                <div style="flex:1;min-height:0;padding:0.75rem;">
                    <div id="bp-graph-container"></div>
                    <p id="bp-graph-hint" style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">Generate a Bode plot to see the magnitude and phase diagrams.</p>
                </div>
            </div>
        </div>

        <!-- Python Compiler Panel -->
        <div class="bp-panel" id="bp-panel-python">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <polygon points="5 3 19 12 5 21 5 3"/>
                    </svg>
                    <h4>Python Compiler</h4>
                </div>
                <div style="flex:1;min-height:0;">
                    <iframe id="bp-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
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
    <jsp:param name="currentToolUrl" value="bode-plot-generator.jsp"/>
    <jsp:param name="keyword" value="calculus"/>
    <jsp:param name="limit" value="6"/>
</jsp:include>

<!-- ========== BELOW-FOLD EDUCATIONAL CONTENT ========== -->
<section class="tool-expertise-section" style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">

    <!-- What is a Bode Plot? -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">What is a Bode Plot?</h2>
        <p style="color: var(--text-secondary); margin-bottom: 0.75rem; line-height: 1.7;">A Bode plot is a standard way to visualize the frequency response of a linear time-invariant (LTI) system. It consists of two graphs: a <strong>magnitude plot</strong> showing |H(j&omega;)| in decibels (dB) and a <strong>phase plot</strong> showing &angle;H(j&omega;) in degrees, both plotted against frequency &omega; on a logarithmic scale.</p>
        <p style="color: var(--text-secondary); margin-bottom: 0; line-height: 1.7;">Named after Hendrik Bode, these plots are fundamental in control engineering for analyzing system stability, designing compensators, and understanding how systems respond to different input frequencies.</p>
    </div>

    <!-- Key Concepts -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 0.5rem; color: var(--text-primary);">Key Concepts</h2>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 1rem; margin-top: 1rem;">
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #dc2626;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Gain Margin</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">The amount of gain (in dB) that can be added before the system becomes unstable. Measured at the phase crossover frequency where phase = &minus;180&deg;.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #ef4444;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Phase Margin</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">The additional phase lag before instability, measured at the gain crossover frequency where |H| = 0 dB. Positive margins indicate stability.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #b91c1c;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Corner Frequency</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">The frequency at which the asymptotic approximation changes slope. For a pole at s = &minus;a, the corner frequency is &omega; = a rad/s.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #f87171;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Asymptotic Approximation</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Each pole adds &minus;20 dB/decade and &minus;90&deg; phase. Each zero adds +20 dB/decade and +90&deg;. Straight-line approximations simplify hand sketching.</p>
            </div>
        </div>
    </div>

    <!-- Applications -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">Applications</h2>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem;">
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#9881;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Control Systems</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Design PID controllers, analyze loop gain, and determine stability margins for feedback systems.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#128295;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Filter Design</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Visualize low-pass, high-pass, band-pass, and notch filter frequency responses.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#128208;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Stability Analysis</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Determine gain and phase margins to assess closed-loop stability of feedback systems.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#127925;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Audio Engineering</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Analyze equalizer response curves, amplifier frequency characteristics, and speaker crossover networks.</p>
            </div>
        </div>
    </div>

    <!-- FAQ Section -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem;" id="faqs">Frequently Asked Questions</h2>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is a Bode plot?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">A Bode plot is a graphical representation of a system's frequency response. It consists of two plots: the magnitude plot showing |H(jw)| in decibels versus log frequency, and the phase plot showing the phase angle of H(jw) in degrees versus log frequency. Bode plots are essential for analyzing stability and performance of control systems.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How do you read a Bode plot?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">On a Bode plot, the x-axis is frequency on a logarithmic scale. The magnitude plot (top) shows gain in dB - positive values mean amplification, negative values mean attenuation. The phase plot (bottom) shows phase shift in degrees. Key features include the -3dB bandwidth, gain crossover frequency, and phase margin.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is gain and phase margin?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Gain margin is the amount of gain increase (in dB) needed to make the system unstable, measured at the phase crossover frequency (where phase = -180 degrees). Phase margin is the additional phase lag needed for instability, measured at the gain crossover frequency (where magnitude = 0 dB). Both should be positive for a stable system.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How does pole location affect the Bode plot?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Each pole contributes -20 dB/decade slope to the magnitude plot and -90 degrees to the phase. A pole at s = -a creates a corner frequency at w = a, where the magnitude starts rolling off. Complex conjugate poles can create a resonance peak near the natural frequency, with the peak height depending on the damping ratio.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Bode plot vs Nyquist plot?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">A Bode plot shows magnitude and phase separately as functions of frequency on two subplots. A Nyquist plot shows the frequency response as a single curve in the complex plane (real vs imaginary parts). Bode plots are easier to sketch by hand and read gain/phase margins, while Nyquist plots are better for analyzing encirclement-based stability criteria.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Is this Bode plot tool free?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes, this Bode plot generator is completely free with no signup required. You get symbolic computation via SymPy, step-by-step analysis, interactive Plotly graphs, LaTeX export, and a built-in Python compiler.</div>
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
            <a href="<%=request.getContextPath()%>/laplace-transform-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(220,38,38,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #0891b2, #06b6d4); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem; color: #fff;">&#8466;</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Laplace Transform Calculator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Forward &amp; inverse Laplace transforms with steps and ROC</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/fourier-transform-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(220,38,38,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #7c3aed, #a855f7); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem; color: #fff;">&#8497;</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Fourier Transform Calculator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Forward &amp; inverse Fourier transforms for signal analysis</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/convolution-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(220,38,38,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #d97706, #f59e0b); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem; color: #fff;">&ast;</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Convolution Calculator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Continuous &amp; discrete convolution with steps and graphs</p>
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

<script>window.BP_CALC_CTX = "<%=request.getContextPath()%>";</script>
<script src="<%=request.getContextPath()%>/modern/js/bode-plot-generator.js?v=<%=cacheVersion%>"></script>

</body>
</html>
