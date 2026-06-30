<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String v = String.valueOf(System.currentTimeMillis());
    request.setAttribute("aiToolId", "math-ai");
    request.setAttribute("aiRequireSignIn", "true");
%>
<%@ include file="modern/components/ai-assistant-vars.inc.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="ctx" content="<%=request.getContextPath()%>" />
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

    <!-- SEO -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Bode Plot Generator with Steps - Magnitude & Phase | Free Online Tool" />
        <jsp:param name="toolDescription" value="Free online Bode plot generator. Plot magnitude and phase diagrams for any transfer function H(s) with step-by-step analysis. Features zeros/poles identification, common transfer functions table, interactive Plotly graphs, and built-in Python compiler. No signup required." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="bode-plot-generator.jsp" />
        <jsp:param name="toolKeywords" value="bode plot generator, bode plot calculator, transfer function plotter, magnitude plot, phase plot, frequency response, control systems, bode diagram, gain margin, phase margin, stability analysis" />
        <jsp:param name="toolImage" value="math-studio-og.png" />
        <jsp:param name="toolFeatures" value="Bode magnitude and phase plots,Transfer function analysis with steps,Zeros and poles identification,Common transfer functions table,Interactive dual-subplot Plotly graphs,Zeros-Poles-Gain input mode,Live KaTeX math preview,Copy LaTeX output,Built-in Python compiler with SymPy,Quick examples for each mode,Math AI tutor in chat,Dark mode support,Free and no signup required" />
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

    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap"></noscript>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/bode-plot-generator.css?v=<%=v%>">

    <%@ include file="modern/components/math-ai-head.inc.jsp" %>

    <style>
        .ic-hero .math-ai-tab-btn {
            display: inline-flex; align-items: center; gap: 0.35rem;
            padding: 0.35rem 0.75rem; border-radius: 999px; border: 1px solid rgba(99,102,241,0.35);
            background: rgba(99,102,241,0.08); color: var(--ms-text, #1e1b4b); font-size: 0.8125rem;
            font-weight: 600; cursor: pointer; transition: background 0.15s, transform 0.15s, box-shadow 0.15s;
            white-space: nowrap;
        }
        .ic-hero .math-ai-tab-btn:hover {
            background: rgba(99,102,241,0.18); transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(99,102,241,0.15);
        }
        .ic-hero .math-ai-tab-btn[aria-busy="true"] { opacity: 0.75; cursor: wait; }
    </style>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">

    <%@ include file="modern/ads/ad-init.jsp" %>

</head>
<body class="ms-body">

<%@ include file="modern/components/nav-header.jsp" %>
<jsp:include page="/math/partials/matter-bg.jsp" />

<div class="ms-hero">
    <%@ include file="modern/ads/ad-hero-banner.jsp" %>
</div>

<main class="ms-main">

    <button type="button" id="msSidebarToggle" class="ms-sidebar-toggle" aria-label="Open math tools menu">
        &#9776; Math tools
    </button>

    <% request.setAttribute("activeService", "bode"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <span aria-current="page">Bode Plot</span>
            </nav>
            <h1>Bode Plot Generator</h1>
            <p class="ms-subtitle">Magnitude &amp; phase for H(s) &middot; step-by-step analysis &middot; gain &amp; phase margin</p>
        </header>

        <div class="ic-stack">

            <!-- ═══ INPUT HERO (stacked above result — same as Integral/Limit) ═══ -->
            <div class="ic-hero ic-hero--compact" id="bp-hero">
                <div class="ic-hero-top">
                    <div class="bp-mode-toggle" role="radiogroup" aria-label="Input mode">
                        <button type="button" class="bp-mode-btn active" data-mode="transfer" role="radio" aria-checked="true">H(s)</button>
                        <button type="button" class="bp-mode-btn" data-mode="zpk" role="radio" aria-checked="false">ZPK</button>
                    </div>
                    <button type="button" class="math-ai-tab-btn" id="btnMathAI" title="Math AI — Bode tutor + calculus in chat (Ctrl+Shift+A)">&#10024; AI</button>
                </div>

                <div class="bp-hero-core">
                    <!-- Transfer function mode -->
                    <div id="bp-tf-wrap" class="bp-mode-panel">
                        <label class="bp-field-label" for="bp-tf-expr">H(s)</label>
                        <input type="text" class="tool-input tool-input-mono bp-main-input" id="bp-tf-expr" placeholder="e.g. 1/(s^2+2*s+1)" autocomplete="off" spellcheck="false">
                    </div>

                    <!-- ZPK mode -->
                    <div id="bp-zpk-wrap" class="bp-mode-panel" style="display:none;">
                        <div class="bp-zpk-grid">
                            <div class="bp-zpk-field">
                                <label class="bp-field-label" for="bp-zpk-zeros">Zeros</label>
                                <input type="text" class="tool-input tool-input-mono" id="bp-zpk-zeros" placeholder="-1, -2" autocomplete="off" spellcheck="false">
                            </div>
                            <div class="bp-zpk-field">
                                <label class="bp-field-label" for="bp-zpk-poles">Poles</label>
                                <input type="text" class="tool-input tool-input-mono" id="bp-zpk-poles" placeholder="0, -10" autocomplete="off" spellcheck="false">
                            </div>
                            <div class="bp-zpk-field bp-zpk-field--gain">
                                <label class="bp-field-label" for="bp-zpk-gain">Gain K</label>
                                <input type="text" class="tool-input tool-input-mono" id="bp-zpk-gain" placeholder="1" value="1" autocomplete="off" spellcheck="false">
                            </div>
                        </div>
                    </div>

                    <div class="bp-preview-strip">
                        <span class="bp-preview-label">Preview</span>
                        <div class="bp-preview" id="bp-preview">
                            <span class="bp-preview-placeholder">Type above&hellip;</span>
                        </div>
                    </div>

                    <div class="ic-hero-cta-row bp-hero-cta-row">
                        <button type="button" class="ic-hero-cta" id="bp-compute-btn">Generate Bode Plot</button>
                        <button type="button" class="bp-random-btn" id="bp-random-btn" title="Random example">&#127922;</button>
                    </div>
                </div>

                <details class="ic-hero-methods" id="bp-examples-wrap">
                    <summary class="ic-hero-methods-summary">
                        <span>Quick examples</span>
                        <svg class="ic-hero-methods-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                    </summary>
                    <div class="ic-hero-methods-body bp-examples-body">
                        <div class="bp-examples" id="bp-examples"></div>
                    </div>
                </details>

                <details class="ic-hero-methods" id="bp-tf-table-wrap">
                    <summary class="ic-hero-methods-summary">
                        <span>Common transfer functions</span>
                        <svg class="ic-hero-methods-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                    </summary>
                    <div class="ic-hero-methods-body">
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
                </details>

                <details class="ic-hero-methods" id="bp-syntax-wrap">
                    <summary class="ic-hero-methods-summary">
                        <span>Syntax help</span>
                        <svg class="ic-hero-methods-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                    </summary>
                    <div class="ic-hero-methods-body bp-syntax-body">
                        s^2 &nbsp; (s+1)^2 &nbsp; s^3 &nbsp; 1/(s+1) &nbsp; s/(s^2+1) &nbsp; 10*(s+1)/(s*(s+10))<br>
                        <strong>Multiply:</strong> <code>2*s</code> not <code>2s</code> &nbsp; <strong>Powers:</strong> <code>s^2</code> &nbsp; <strong>Imaginary:</strong> <code>-5+8.66j</code>
                    </div>
                </details>
            </div><!-- /.ic-hero -->

            <!-- ═══ RESULT CARD ═══ -->
            <div class="ic-result-card">
                <div class="ic-output-tabs" role="tablist">
                    <button type="button" class="ic-output-tab active" data-panel="result" role="tab" aria-selected="true">Result</button>
                    <button type="button" class="ic-output-tab" data-panel="graph" role="tab" aria-selected="false">Bode Plot</button>
                    <button type="button" class="ic-output-tab" data-panel="python" role="tab" aria-selected="false">Python Compiler</button>
                </div>

                <!-- Result Panel -->
                <div class="ic-panel active" id="bp-panel-result" role="tabpanel">
                    <div class="tool-card tool-result-card">
                        <div class="tool-result-content" id="bp-result-content">
                            <div class="tool-empty-state" id="bp-empty-state">
                                <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">H(s)</div>
                                <h3>Enter a transfer function and click Generate</h3>
                                <p>Generate Bode magnitude and phase plots with step-by-step analysis.</p>
                            </div>
                        </div>
                        <div class="tool-result-actions" id="bp-result-actions">
                            <button type="button" class="tool-action-btn" id="bp-copy-latex-btn">Copy LaTeX</button>
                            <button type="button" class="tool-action-btn" id="bp-download-pdf-btn">Download PDF</button>
                            <button type="button" class="tool-action-btn" id="bp-share-btn">Share</button>
                            <button type="button" class="tool-action-btn" id="bp-worksheet-btn">Print Worksheet</button>
                        </div>
                    </div>
                </div>

                <!-- Graph Panel -->
                <div class="ic-panel" id="bp-panel-graph" role="tabpanel">
                    <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                        <div style="flex:1;min-height:360px;padding:0.75rem;">
                            <div id="bp-graph-container" style="width:100%;height:100%;min-height:360px;"></div>
                            <p id="bp-graph-hint" style="text-align:center;font-size:0.8rem;color:var(--ms-muted);margin-top:0.5rem;">Generate a Bode plot to see the magnitude and phase diagrams.</p>
                        </div>
                    </div>
                </div>

                <!-- Python Compiler Panel -->
                <div class="ic-panel" id="bp-panel-python" role="tabpanel">
                    <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                        <div style="flex:1;min-height:0;">
                            <iframe id="bp-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                        </div>
                    </div>
                </div>
            </div><!-- /.ic-result-card -->
        </div><!-- /.ic-stack -->

        <!-- In-content ad (mobile/tablet) -->
        <div class="ms-inline-ad">
            <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
        </div>

<!-- ========== BELOW-FOLD EDUCATIONAL CONTENT ========== -->
<section class="tool-expertise-section ms-below-fold" style="max-width: 100%; margin: 2rem 0 0; padding: 0;">

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
    <section class="ms-faq-wrap" style="margin-top:1.5rem;">
        <h2 class="ms-faq-title" id="faqs">Frequently asked</h2>
        <div class="ms-faq" aria-label="Bode plot FAQ">

        <div class="ms-faq-item">
            <button type="button" class="ms-faq-q">What is a Bode plot?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
            <div class="ms-faq-a">A Bode plot is a graphical representation of a system's frequency response. It consists of two plots: the magnitude plot showing |H(j&omega;)| in decibels versus log frequency, and the phase plot showing the phase angle of H(j&omega;) in degrees versus log frequency. Bode plots are essential for analyzing stability and performance of control systems.</div>
        </div>

        <div class="ms-faq-item">
            <button type="button" class="ms-faq-q">How do you read a Bode plot?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
            <div class="ms-faq-a">On a Bode plot, the x-axis is frequency on a logarithmic scale. The magnitude plot (top) shows gain in dB — positive values mean amplification, negative values mean attenuation. The phase plot (bottom) shows phase shift in degrees. Key features include the &minus;3 dB bandwidth, gain crossover frequency, and phase margin.</div>
        </div>

        <div class="ms-faq-item">
            <button type="button" class="ms-faq-q">What is gain and phase margin?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
            <div class="ms-faq-a">Gain margin is the amount of gain increase (in dB) needed to make the system unstable, measured at the phase crossover frequency (where phase = &minus;180&deg;). Phase margin is the additional phase lag needed for instability, measured at the gain crossover frequency (where magnitude = 0 dB). Both should be positive for a stable system.</div>
        </div>

        <div class="ms-faq-item">
            <button type="button" class="ms-faq-q">How does pole location affect the Bode plot?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
            <div class="ms-faq-a">Each pole contributes &minus;20 dB/decade slope to the magnitude plot and &minus;90&deg; to the phase. A pole at s = &minus;a creates a corner frequency at &omega; = a, where the magnitude starts rolling off. Complex conjugate poles can create a resonance peak near the natural frequency.</div>
        </div>

        <div class="ms-faq-item">
            <button type="button" class="ms-faq-q">Bode plot vs Nyquist plot?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
            <div class="ms-faq-a">A Bode plot shows magnitude and phase separately as functions of frequency on two subplots. A Nyquist plot shows the frequency response as a single curve in the complex plane. Bode plots are easier to sketch by hand and read gain/phase margins; Nyquist plots suit encirclement-based stability criteria.</div>
        </div>

        <div class="ms-faq-item">
            <button type="button" class="ms-faq-q">Is this Bode plot tool free?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
            <div class="ms-faq-a">Yes — completely free with no signup. You get step-by-step analysis, interactive Plotly graphs, LaTeX export, Math AI tutor, and a built-in Python compiler.</div>
        </div>
        </div>
    </section>
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

    </section><!-- /.ms-workspace -->

    <aside class="ms-rail" aria-label="Advertisements">
        <%@ include file="modern/ads/ad-ide-rail-top.jsp" %>
        <%@ include file="modern/ads/ad-ide-rail-bottom.jsp" %>
    </aside>
</main>

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

<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js"></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/search.js" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/categories-menu.js" defer></script>

<script>window.BP_CALC_CTX = "<%=request.getContextPath()%>";</script>
<script src="<%=request.getContextPath()%>/modern/js/bode-calculator-core.js?v=<%=v%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/bode-plot-generator.js?v=<%=v%>"></script>

<script>
(function () {
    document.querySelectorAll('.ms-faq-q').forEach(function (q) {
        q.addEventListener('click', function () {
            q.closest('.ms-faq-item').classList.toggle('open');
        });
    });
})();
</script>

<%@ include file="modern/components/math-calculus-cores.inc.jsp" %>
<%
    request.setAttribute("mathAiButtonId", "btnMathAI");
    request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
    request.setAttribute("mathAiProfileExport", "configureBodeMathShell");
%>
<%@ include file="modern/components/math-ai-boot.inc.jsp" %>
</body>
</html>
