<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String v = String.valueOf(System.currentTimeMillis());
    request.setAttribute("v", v);
    request.setAttribute("aiToolId", "math-ai");
    request.setAttribute("aiRequireSignIn", "true");
%>
<%@ include file="modern/components/ai-assistant-vars.inc.jsp" %>
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
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Normal Distribution Calculator Online - Probability &amp; Percentile Free" />
        <jsp:param name="toolDescription" value="Calculate probabilities, Z-scores, and percentiles for any normal distribution with custom mean and standard deviation. Interactive bell curve, step-by-step formulas, and Python export." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="normal-distribution-calculator.jsp" />
        <jsp:param name="toolKeywords" value="normal distribution calculator, gaussian distribution calculator, bell curve calculator, normal probability calculator, z-score calculator, percentile calculator, standard deviation, inverse normal, range probability, CDF calculator" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="X to probability with left and right tail,Percentile to X inverse normal,Range probability P(a le X le b),Custom mean and standard deviation,Interactive Plotly bell curve,Step-by-step KaTeX formulas,Python scipy code generation,LaTeX export and share URL" />
        <jsp:param name="teaches" value="Normal distribution, Gaussian distribution, bell curve, probability density, cumulative distribution, inverse normal, Z-scores" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Set Parameters|Enter the mean and standard deviation for your distribution,Choose Mode|Select X to Probability or Percentile to X or Range,Enter Values|Input X value or percentile or range bounds,Click Calculate|Get instant probability Z-score and percentile results,View Bell Curve|Explore the interactive shaded normal distribution,Export Results|Copy LaTeX share URL or run Python code" />
        <jsp:param name="faq1q" value="What is a normal distribution?" />
        <jsp:param name="faq1a" value="A normal distribution is a symmetric bell-shaped probability distribution defined by its mean mu and standard deviation sigma. It is the most common distribution in statistics because many natural phenomena follow it due to the Central Limit Theorem." />
        <jsp:param name="faq2q" value="How do I calculate P(X le x) for a normal distribution?" />
        <jsp:param name="faq2a" value="First standardize by computing Z equals x minus mu divided by sigma. Then look up the cumulative distribution function Phi of Z. This gives the left tail probability. For right tail subtract from 1." />
        <jsp:param name="faq3q" value="What is the inverse normal function?" />
        <jsp:param name="faq3a" value="The inverse normal function Phi inverse of p gives the X value such that P of X less than or equal to x equals p. It converts a probability or percentile back to a value on the distribution. For example the 95th percentile of N(100, 15) is about 124.67." />
        <jsp:param name="faq4q" value="How do I find the probability between two values?" />
        <jsp:param name="faq4a" value="Use P of a le X le b equals Phi of Z_b minus Phi of Z_a where Z_a and Z_b are the standardized values. This calculator computes this automatically in Range mode." />
        <jsp:param name="faq5q" value="What is the relationship between normal distribution and Z-scores?" />
        <jsp:param name="faq5a" value="Z-scores standardize any normal distribution to the standard normal N(0, 1). The formula Z equals X minus mu divided by sigma transforms values so they can be compared across different distributions. A Z-score of 2 always means 2 standard deviations above the mean regardless of the original scale." />
        <jsp:param name="faq6q" value="When can I assume data follows a normal distribution?" />
        <jsp:param name="faq6a" value="Data often follows a normal distribution when it results from many small independent effects. Common examples include heights, measurement errors, and test scores. Use normality tests like Shapiro-Wilk or Q-Q plots to verify. The Central Limit Theorem guarantees sample means are approximately normal for large samples." />
    </jsp:include>

    <%@ include file="modern/components/math-studio-shell-head.inc.jsp" %>
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

    <% request.setAttribute("activeService", "normal-dist"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <span aria-current="page">Normal Distribution</span>
            </nav>
            <h1>Normal Distribution Calculator</h1>
            <p class="ms-subtitle">PDF · CDF · inverse · shaded curve</p>
        </header>

        <div class="ic-stack">

            <div class="ic-hero ic-hero--compact stat-hero" id="stat-hero">
                <div class="ic-hero-top">
                    <button type="button" class="math-ai-tab-btn" id="btnMathAI" title="Math AI — statistics tutor + full math router in chat (Ctrl+Shift+A)">&#10024; AI</button>
                </div>
                <div class="stat-hero-core">
                    <!-- Distribution Parameters (always visible) -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label" for="nd-mean">Mean (&mu;)</label>
                                            <input type="number" class="stat-input-text nd-input" id="nd-mean" value="100" step="any" style="height:auto;padding:0.5rem 0.75rem;">
                                        </div>
                                        <div class="tool-form-group">
                                            <label class="tool-form-label" for="nd-stddev">Standard Deviation (&sigma;)</label>
                                            <input type="number" class="stat-input-text nd-input" id="nd-stddev" value="15" step="any" min="0.01" style="height:auto;padding:0.5rem 0.75rem;">
                                        </div>
                    
                                        <hr style="border:none;border-top:1px solid var(--border);margin:0.75rem 0;">
                    
                                        <!-- Mode Toggle -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label">Calculation Mode</label>
                                            <div class="stat-mode-toggle">
                                                <button type="button" class="stat-mode-btn active" id="nd-mode-prob">X&rarr;Prob</button>
                                                <button type="button" class="stat-mode-btn" id="nd-mode-percentile">Pctl&rarr;X</button>
                                                <button type="button" class="stat-mode-btn" id="nd-mode-range">Range</button>
                                            </div>
                                        </div>
                    
                                        <!-- X → Probability inputs -->
                                        <div id="nd-input-prob">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="nd-x-value">X Value</label>
                                                <input type="number" class="stat-input-text nd-input" id="nd-x-value" value="115" step="any" style="height:auto;padding:0.5rem 0.75rem;">
                                                <div class="tool-form-hint">Find the probability for this value</div>
                                            </div>
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="nd-prob-type">Tail Type</label>
                                                <select class="nd-select nd-input" id="nd-prob-type">
                                                    <option value="left">Left tail P(X &le; x)</option>
                                                    <option value="right">Right tail P(X &ge; x)</option>
                                                </select>
                                            </div>
                                        </div>
                    
                                        <!-- Percentile → X inputs -->
                                        <div id="nd-input-percentile" style="display:none;">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="nd-percentile">Percentile (%)</label>
                                                <input type="number" class="stat-input-text nd-input" id="nd-percentile" value="90" step="any" min="0.01" max="99.99" style="height:auto;padding:0.5rem 0.75rem;">
                                                <div class="tool-form-hint">e.g. 90 for the 90th percentile</div>
                                            </div>
                                        </div>
                    
                                        <!-- Range inputs -->
                                        <div id="nd-input-range" style="display:none;">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="nd-range-a">Lower Bound (a)</label>
                                                <input type="number" class="stat-input-text nd-input" id="nd-range-a" value="85" step="any" style="height:auto;padding:0.5rem 0.75rem;">
                                            </div>
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="nd-range-b">Upper Bound (b)</label>
                                                <input type="number" class="stat-input-text nd-input" id="nd-range-b" value="115" step="any" style="height:auto;padding:0.5rem 0.75rem;">
                                                <div class="tool-form-hint">P(a &le; X &le; b)</div>
                                            </div>
                                        </div>
                    
                                        <!-- Buttons -->
                                        <button type="button" class="tool-action-btn" id="nd-calc-btn">Calculate</button>
                                        <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                                            <button type="button" class="tool-action-btn" id="nd-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                                        </div>
                    
                                        <hr class="stat-sep">
                    
                                        <!-- Quick Examples -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label">Quick Examples</label>
                                            <div class="stat-examples">
                                                <button type="button" class="stat-example-chip" data-nd-example="iq">IQ Score</button>
                                                <button type="button" class="stat-example-chip" data-nd-example="sat">SAT Score</button>
                                                <button type="button" class="stat-example-chip" data-nd-example="height">Height Range</button>
                                                <button type="button" class="stat-example-chip" data-nd-example="top10">Top 10%</button>
                                            </div>
                                        </div>
                                    </div>
                </div>
            </div>

            <div class="ic-result-card">
                <div class="stat-output-tabs">
                                <button type="button" class="stat-output-tab active" data-tab="nd-result-panel">Result</button>
                                <button type="button" class="stat-output-tab" data-tab="nd-graph-panel">Normal Curve</button>
                                <button type="button" class="stat-output-tab" data-tab="nd-compiler-panel">Python Compiler</button>
                            </div>
                
                            <div class="stat-panel active" id="nd-result-panel">
                                <div class="tool-card tool-result-card">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                                        <h4>Result</h4>
                                    </div>
                                    <div class="tool-result-content" id="nd-result-content">
                                        <div class="tool-empty-state">
                                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F4CA;</div>
                                            <h3>Enter values and click Calculate</h3>
                                            <p>Find probabilities, percentiles, and Z-scores for your normal distribution.</p>
                                        </div>
                                    </div>
                                    <div class="tool-result-actions" id="nd-result-actions"></div>
                                </div>
                            </div>
                
                            <div class="stat-panel" id="nd-graph-panel">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><path d="M22 12h-4l-3 9L9 3l-3 9H2"/></svg>
                                        <h4>Normal Distribution Curve</h4>
                                    </div>
                                    <div style="flex:1;min-height:0;padding:0.75rem;overflow-y:auto;" id="nd-graph-content">
                                        <div class="tool-empty-state"><div style="font-size:2rem;opacity:0.5;">&#x1F4C8;</div><h3>No graph yet</h3><p>Calculate to see the bell curve.</p></div>
                                    </div>
                                </div>
                            </div>
                
                            <div class="stat-panel" id="nd-compiler-panel">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                                        <h4>Python Compiler</h4>
                                    </div>
                                    <div style="flex:1;min-height:0;">
                                        <iframe id="nd-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                                    </div>
                                </div>
                            </div>
            </div>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
        </div>

<jsp:include page="modern/components/related-tools.jsp">
<jsp:param name="currentToolUrl" value="normal-distribution-calculator.jsp"/>
        <jsp:param name="keyword" value="statistics"/>
        <jsp:param name="limit" value="6"/>
</jsp:include>

        <section class="tool-expertise-section ms-below-fold" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
        
                <!-- 1. What Is Normal Distribution? -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Is the Normal Distribution?</h2>
                    <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">The <strong>normal distribution</strong> (Gaussian distribution) is a symmetric, bell-shaped probability distribution defined by two parameters: the mean (&mu;) and standard deviation (&sigma;). It is the most important distribution in statistics because many natural phenomena follow it.</p>
        
                    <div class="stat-formula-box">
                        <strong>Probability Density Function:</strong>&nbsp; f(x) = (1 / &sigma;&radic;(2&pi;)) &times; e<sup>&minus;(x&minus;&mu;)&sup2; / (2&sigma;&sup2;)</sup>
                    </div>
        
                    <div class="stat-edu-grid" style="margin-top:1rem;">
                        <div class="stat-feature-card stat-anim stat-anim-d1">
                            <div style="font-size:1.5rem;">&#x1F3AF;</div>
                            <h4>Symmetric</h4>
                            <p>Perfectly symmetric about the mean. Mean = median = mode, all at the center.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d2">
                            <div style="font-size:1.5rem;">&#x1F4CF;</div>
                            <h4>Defined by &mu; and &sigma;</h4>
                            <p>&mu; sets the center, &sigma; controls the spread. Larger &sigma; means a flatter, wider bell.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d3">
                            <div style="font-size:1.5rem;">&#x267E;&#xFE0F;</div>
                            <h4>Asymptotic</h4>
                            <p>Tails extend infinitely but approach zero. Total area under the curve equals 1.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 2. The 68-95-99.7 Rule -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">The 68-95-99.7 Rule (Empirical Rule)</h2>
        
                    <!-- Animated SVG Bell Curve -->
                    <div style="text-align:center;margin-bottom:1.5rem;" class="stat-anim stat-anim-d1">
                        <svg viewBox="0 0 500 200" style="max-width:500px;width:100%;" xmlns="http://www.w3.org/2000/svg">
                            <path d="M 30,170 C 60,170 80,168 110,160 C 140,148 160,120 180,80 C 200,45 220,20 250,15 C 280,20 300,45 320,80 C 340,120 360,148 390,160 C 420,168 440,170 470,170" fill="none" stroke="#e11d48" stroke-width="2.5" class="stat-bell-animated"/>
                            <rect x="180" y="70" width="140" height="100" fill="rgba(225,29,72,0.08)" rx="2"/>
                            <text x="250" y="135" text-anchor="middle" fill="#e11d48" font-size="13" font-weight="600" font-family="Inter,sans-serif">68%</text>
                            <rect x="110" y="140" width="280" height="20" fill="rgba(225,29,72,0.05)" rx="2"/>
                            <text x="250" y="155" text-anchor="middle" fill="#be123c" font-size="11" font-family="Inter,sans-serif">95%</text>
                            <rect x="60" y="162" width="380" height="8" fill="rgba(225,29,72,0.03)" rx="1"/>
                            <text x="110" y="188" text-anchor="middle" fill="currentColor" font-size="10" font-family="Inter,sans-serif">&mu;&minus;2&sigma;</text>
                            <text x="180" y="188" text-anchor="middle" fill="currentColor" font-size="10" font-family="Inter,sans-serif">&mu;&minus;1&sigma;</text>
                            <text x="250" y="188" text-anchor="middle" fill="currentColor" font-size="10" font-weight="600" font-family="Inter,sans-serif">&mu;</text>
                            <text x="320" y="188" text-anchor="middle" fill="currentColor" font-size="10" font-family="Inter,sans-serif">&mu;+1&sigma;</text>
                            <text x="390" y="188" text-anchor="middle" fill="currentColor" font-size="10" font-family="Inter,sans-serif">&mu;+2&sigma;</text>
                        </svg>
                    </div>
        
                    <table class="stat-ops-table">
                        <thead><tr><th>Range</th><th>Probability</th><th>Example (IQ: &mu;=100, &sigma;=15)</th></tr></thead>
                        <tbody>
                            <tr><td style="font-weight:600;">&mu; &plusmn; 1&sigma;</td><td>68.27%</td><td>IQ 85 &ndash; 115</td></tr>
                            <tr><td style="font-weight:600;">&mu; &plusmn; 2&sigma;</td><td>95.45%</td><td>IQ 70 &ndash; 130</td></tr>
                            <tr><td style="font-weight:600;">&mu; &plusmn; 3&sigma;</td><td>99.73%</td><td>IQ 55 &ndash; 145</td></tr>
                        </tbody>
                    </table>
                </div>
        
                <!-- 3. Standardization & Z-Scores -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Standardization &amp; Z-Scores</h2>
                    <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">Any normal distribution N(&mu;, &sigma;) can be converted to the <strong>standard normal</strong> N(0, 1) by computing the Z-score:</p>
        
                    <div class="stat-formula-box">
                        <strong>Z = (X &minus; &mu;) / &sigma;</strong>
                    </div>
        
                    <div class="stat-worked-example" style="margin-top:1rem;">
                        <strong>Worked Example:</strong> IQ scores follow N(100, 15). What Z-score corresponds to IQ = 130?
                        <div style="margin-top:0.5rem;padding-left:1rem;border-left:3px solid var(--tool-primary);color:var(--text-secondary);font-size:0.875rem;">
                            Z = (130 &minus; 100) / 15 = 30 / 15 = <strong>2.0</strong><br>
                            &Phi;(2.0) = 0.9772 &rarr; IQ 130 is at the <strong>97.7th percentile</strong>
                        </div>
                    </div>
        
                    <table class="stat-ops-table" style="margin-top:1rem;">
                        <thead><tr><th>Z-Score</th><th>Left Tail P(Z &le; z)</th><th>Percentile</th></tr></thead>
                        <tbody>
                            <tr><td>&minus;2.326</td><td>0.0100</td><td>1st</td></tr>
                            <tr><td>&minus;1.645</td><td>0.0500</td><td>5th</td></tr>
                            <tr><td>0.000</td><td>0.5000</td><td>50th</td></tr>
                            <tr><td>+1.645</td><td>0.9500</td><td>95th</td></tr>
                            <tr><td>+1.960</td><td>0.9750</td><td>97.5th</td></tr>
                            <tr><td>+2.326</td><td>0.9900</td><td>99th</td></tr>
                        </tbody>
                    </table>
                </div>
        
                <!-- 4. Real-World Applications -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Real-World Applications</h2>
                    <div class="stat-edu-grid">
                        <div class="stat-edu-card stat-anim stat-anim-d1">
                            <h4>IQ &amp; Standardized Testing</h4>
                            <p>IQ scores follow N(100, 15). SAT scores approximate N(1060, 195). Z-scores enable comparison across different tests.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d2">
                            <h4>Quality Control</h4>
                            <p>Manufacturing uses normal distribution to set tolerance limits. Six Sigma targets Z = &plusmn;6 for defect rates below 3.4 per million.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d3">
                            <h4>Biological Measurements</h4>
                            <p>Heights, weights, blood pressure, and many biological variables are approximately normally distributed in populations.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d4">
                            <h4>Central Limit Theorem</h4>
                            <p>Sample means approach a normal distribution as n increases, regardless of the population shape. This is the foundation of inferential statistics.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 5. FAQ -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
                    <div class="faq-item">
                        <button class="faq-question">What is a normal distribution?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">A normal distribution (Gaussian distribution) is a symmetric, bell-shaped probability distribution defined by its mean &mu; and standard deviation &sigma;. It is the most common distribution in statistics because many natural phenomena follow it due to the Central Limit Theorem.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">How do I calculate P(X &le; x) for a normal distribution?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">First standardize by computing Z = (x &minus; &mu;) / &sigma;. Then look up the cumulative distribution function &Phi;(Z). This gives the left-tail probability. For the right tail, subtract from 1: P(X &ge; x) = 1 &minus; &Phi;(Z).</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What is the inverse normal function?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">The inverse normal function &Phi;<sup>&minus;1</sup>(p) returns the X value such that P(X &le; x) = p. It converts a probability or percentile back to a value on the distribution. For example, the 95th percentile of N(100, 15) is about 124.67.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">How do I find the probability between two values?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Use P(a &le; X &le; b) = &Phi;(Z<sub>b</sub>) &minus; &Phi;(Z<sub>a</sub>), where Z<sub>a</sub> and Z<sub>b</sub> are the standardized values. This calculator computes it automatically in Range mode.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What is the relationship between normal distribution and Z-scores?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Z-scores standardize any normal distribution to the standard normal N(0, 1). The formula Z = (X &minus; &mu;) / &sigma; transforms values so they can be compared across different distributions. A Z-score of 2 always means 2 standard deviations above the mean, regardless of the original scale.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">When can I assume data follows a normal distribution?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Data often follows a normal distribution when it results from many small, independent effects. Common examples include heights, measurement errors, and test scores. Use normality tests like Shapiro-Wilk or Q-Q plots to verify. The Central Limit Theorem guarantees sample means are approximately normal for large samples.</div>
                    </div>
                </div>
            </section>

        <%@ include file="modern/components/support-section.jsp" %>

    </section><!-- /.ms-workspace -->

    <aside class="ms-rail" aria-label="Advertisements">
        <%@ include file="modern/ads/ad-ide-rail-top.jsp" %>
        <%@ include file="modern/ads/ad-ide-rail-bottom.jsp" %>
    </aside>
</main>

<%@ include file="modern/ads/ad-sticky-footer.jsp" %>
<%@ include file="modern/components/analytics.jsp" %>

<%@ include file="modern/components/math-calculus-cores.inc.jsp" %>
<!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=v%>"></script>
            <script src="<%=request.getContextPath()%>/js/stats-export.js?v=<%=v%>"></script>
    <script src="<%=request.getContextPath()%>/js/normal-distribution-core.js?v=<%=v%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/categories-menu.js" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=v%>" defer></script>

<script>window.__MS_STAT_PAGE__ = { key: 'normal-dist', label: "Normal Distribution Calculator" };</script>
<%
    request.setAttribute("mathAiButtonId", "btnMathAI");
    request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
    request.setAttribute("mathAiProfileExport", "configureStatisticsMathShell");
%>
<%@ include file="modern/components/math-ai-boot.inc.jsp" %>
</body>
</html>

