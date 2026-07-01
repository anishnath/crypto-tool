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
        <jsp:param name="toolName" value="Z-Score Calculator Online - Percentile &amp; Probability Free" />
        <jsp:param name="toolDescription" value="Convert raw scores to Z-scores, find probabilities and percentiles on the standard normal distribution. Interactive normal curve, step-by-step formulas, and Python export." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="z-score-calculator.jsp" />
        <jsp:param name="toolKeywords" value="z-score calculator, standard score calculator, z score to percentile, normal distribution calculator, z-table calculator, standard normal, percentile to z-score, probability calculator, standardization, inverse normal" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Raw score to Z-score conversion,Z-score to probability with area types,Percentile to Z-score inverse normal,Z-score to raw score denormalization,Interactive Plotly normal curve,Step-by-step KaTeX formulas,Python scipy code generation,LaTeX export and share URL" />
        <jsp:param name="teaches" value="Z-scores, standard normal distribution, standardization, percentiles, cumulative probability, inverse normal function" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Choose Mode|Select Score to Z or Z to Probability or Percentile to Z or Z to Score,Enter Values|Input your raw score mean and standard deviation or Z-score,Click Calculate|Get instant Z-score percentile and probability results,Review Steps|See step-by-step KaTeX formula derivation,View Normal Curve|Explore the interactive shaded normal distribution,Export Results|Copy LaTeX share URL or run Python code" />
        <jsp:param name="faq1q" value="What is a Z-score and how is it calculated?" />
        <jsp:param name="faq1a" value="A Z-score measures how many standard deviations a value is from the mean. The formula is Z equals x minus mu divided by sigma. A positive Z-score means the value is above the mean and a negative Z-score means it is below the mean. Z equals zero means the value equals the mean." />
        <jsp:param name="faq2q" value="How do I convert a Z-score to a percentile?" />
        <jsp:param name="faq2a" value="Use the standard normal cumulative distribution function. The percentile equals Phi of z times 100 percent where Phi is the CDF. For example Z equals 1.96 corresponds to the 97.5th percentile. This calculator does the lookup automatically." />
        <jsp:param name="faq3q" value="What is the 68-95-99.7 rule?" />
        <jsp:param name="faq3a" value="For normal distributions approximately 68 percent of data falls within plus or minus 1 standard deviation of the mean, 95 percent within plus or minus 2, and 99.7 percent within plus or minus 3. These correspond to Z-score ranges of negative 1 to 1, negative 2 to 2, and negative 3 to 3." />
        <jsp:param name="faq4q" value="What is the difference between left tail and right tail probability?" />
        <jsp:param name="faq4a" value="Left tail probability P of Z less than or equal to z is the area under the normal curve to the left of z. Right tail probability P of Z greater than or equal to z is the area to the right. They always sum to 1. Between plus or minus z gives the central area and outside gives the two tails combined." />
        <jsp:param name="faq5q" value="When should I use Z-scores versus t-scores?" />
        <jsp:param name="faq5a" value="Use Z-scores when the population standard deviation is known or the sample size is large, typically n greater than 30. Use t-scores when the population standard deviation is unknown and the sample is small. The t-distribution has heavier tails and approaches the normal as n increases." />
        <jsp:param name="faq6q" value="Can I use Z-scores with non-normal data?" />
        <jsp:param name="faq6a" value="You can always calculate Z-scores for any data but the probability and percentile interpretations assume normality. For non-normal data consider transforming the data first using log or Box-Cox transformations. The Central Limit Theorem helps when working with sample means of large samples." />
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

    <% request.setAttribute("activeService", "z-score"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <span aria-current="page">Z-Score</span>
            </nav>
            <h1>Z-Score Calculator</h1>
            <p class="ms-subtitle">Standardize · normal CDF · percentile · reverse lookup</p>
        </header>

        <div class="ic-stack">

            <div class="ic-hero ic-hero--compact stat-hero" id="stat-hero">
                <div class="ic-hero-top">
                    <button type="button" class="math-ai-tab-btn" id="btnMathAI" title="Math AI — statistics tutor + full math router in chat (Ctrl+Shift+A)">&#10024; AI</button>
                </div>
                <div class="stat-hero-core">
                    <!-- Mode Toggle -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label">Calculation Mode</label>
                                            <div class="stat-mode-toggle" style="display:flex;flex-wrap:wrap;">
                                                <button type="button" class="stat-mode-btn active" id="zs-mode-score" style="flex:1;min-width:0;font-size:0.75rem;padding:0.5rem 0.25rem;">Score&rarr;Z</button>
                                                <button type="button" class="stat-mode-btn" id="zs-mode-prob" style="flex:1;min-width:0;font-size:0.75rem;padding:0.5rem 0.25rem;">Z&rarr;Prob</button>
                                                <button type="button" class="stat-mode-btn" id="zs-mode-percentile" style="flex:1;min-width:0;font-size:0.75rem;padding:0.5rem 0.25rem;">Pctl&rarr;Z</button>
                                                <button type="button" class="stat-mode-btn" id="zs-mode-reverse" style="flex:1;min-width:0;font-size:0.75rem;padding:0.5rem 0.25rem;">Z&rarr;Score</button>
                                            </div>
                                        </div>
                    
                                        <!-- Score → Z inputs -->
                                        <div id="zs-input-score">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="zs-raw-score">Raw Score (x)</label>
                                                <input type="number" class="stat-input-text zs-input" id="zs-raw-score" value="85" step="any" style="height:auto;padding:0.5rem 0.75rem;">
                                                <div class="tool-form-hint">The value you want to standardize</div>
                                            </div>
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="zs-mean">Mean (&mu;)</label>
                                                <input type="number" class="stat-input-text zs-input" id="zs-mean" value="75" step="any" style="height:auto;padding:0.5rem 0.75rem;">
                                            </div>
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="zs-stddev">Standard Deviation (&sigma;)</label>
                                                <input type="number" class="stat-input-text zs-input" id="zs-stddev" value="10" step="any" min="0.01" style="height:auto;padding:0.5rem 0.75rem;">
                                            </div>
                                        </div>
                    
                                        <!-- Z → Probability inputs -->
                                        <div id="zs-input-prob" style="display:none;">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="zs-z-prob">Z-Score</label>
                                                <input type="number" class="stat-input-text zs-input" id="zs-z-prob" value="1.96" step="any" style="height:auto;padding:0.5rem 0.75rem;">
                                            </div>
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="zs-area-type">Area Type</label>
                                                <select class="zs-select zs-input" id="zs-area-type">
                                                    <option value="left">Left tail P(Z &le; z)</option>
                                                    <option value="right">Right tail P(Z &ge; z)</option>
                                                    <option value="between">Between &plusmn;z</option>
                                                    <option value="outside">Outside &plusmn;z</option>
                                                </select>
                                            </div>
                                        </div>
                    
                                        <!-- Percentile → Z inputs -->
                                        <div id="zs-input-percentile" style="display:none;">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="zs-percentile">Percentile (%)</label>
                                                <input type="number" class="stat-input-text zs-input" id="zs-percentile" value="95" step="any" min="0.01" max="99.99" style="height:auto;padding:0.5rem 0.75rem;">
                                                <div class="tool-form-hint">e.g. 95 for the 95th percentile</div>
                                            </div>
                                        </div>
                    
                                        <!-- Z → Score inputs -->
                                        <div id="zs-input-reverse" style="display:none;">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="zs-z-reverse">Z-Score</label>
                                                <input type="number" class="stat-input-text zs-input" id="zs-z-reverse" value="1.5" step="any" style="height:auto;padding:0.5rem 0.75rem;">
                                            </div>
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="zs-mean-reverse">Mean (&mu;)</label>
                                                <input type="number" class="stat-input-text zs-input" id="zs-mean-reverse" value="100" step="any" style="height:auto;padding:0.5rem 0.75rem;">
                                            </div>
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="zs-stddev-reverse">Standard Deviation (&sigma;)</label>
                                                <input type="number" class="stat-input-text zs-input" id="zs-stddev-reverse" value="15" step="any" min="0.01" style="height:auto;padding:0.5rem 0.75rem;">
                                            </div>
                                        </div>
                    
                                        <!-- Buttons -->
                                        <button type="button" class="tool-action-btn" id="zs-calc-btn">Calculate Z-Score</button>
                                        <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                                            <button type="button" class="tool-action-btn" id="zs-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                                        </div>
                    
                                        <hr class="stat-sep">
                    
                                        <!-- Quick Examples -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label">Quick Examples</label>
                                            <div class="stat-examples">
                                                <button type="button" class="stat-example-chip" data-zs-example="sat">SAT Score</button>
                                                <button type="button" class="stat-example-chip" data-zs-example="iq">IQ Score</button>
                                                <button type="button" class="stat-example-chip" data-zs-example="95ci">95% CI</button>
                                                <button type="button" class="stat-example-chip" data-zs-example="top5">Top 5%</button>
                                            </div>
                                        </div>
                                    </div>
                </div>
            </div>

            <div class="ic-result-card">
                <div class="stat-output-tabs">
                                <button type="button" class="stat-output-tab active" data-tab="zs-result-panel">Result</button>
                                <button type="button" class="stat-output-tab" data-tab="zs-graph-panel">Normal Curve</button>
                                <button type="button" class="stat-output-tab" data-tab="zs-compiler-panel">Python Compiler</button>
                            </div>
                
                            <div class="stat-panel active" id="zs-result-panel">
                                <div class="tool-card tool-result-card">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                                        <h4>Result</h4>
                                    </div>
                                    <div class="tool-result-content" id="zs-result-content">
                                        <div class="tool-empty-state">
                                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F4CA;</div>
                                            <h3>Enter values and click Calculate</h3>
                                            <p>Convert scores to Z-scores, find probabilities, percentiles, and more.</p>
                                        </div>
                                    </div>
                                    <div class="tool-result-actions" id="zs-result-actions"></div>
                                </div>
                            </div>
                
                            <div class="stat-panel" id="zs-graph-panel">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><path d="M22 12h-4l-3 9L9 3l-3 9H2"/></svg>
                                        <h4>Normal Distribution Curve</h4>
                                    </div>
                                    <div style="flex:1;min-height:0;padding:0.75rem;overflow-y:auto;" id="zs-graph-content">
                                        <div class="tool-empty-state"><div style="font-size:2rem;opacity:0.5;">&#x1F4C8;</div><h3>No graph yet</h3><p>Calculate to see the normal curve.</p></div>
                                    </div>
                                </div>
                            </div>
                
                            <div class="stat-panel" id="zs-compiler-panel">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                                        <h4>Python Compiler</h4>
                                    </div>
                                    <div style="flex:1;min-height:0;">
                                        <iframe id="zs-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                                    </div>
                                </div>
                            </div>
            </div>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
        </div>

<jsp:include page="modern/components/related-tools.jsp">
<jsp:param name="currentToolUrl" value="z-score-calculator.jsp"/>
        <jsp:param name="keyword" value="statistics"/>
        <jsp:param name="limit" value="6"/>
</jsp:include>

        <section class="tool-expertise-section ms-below-fold" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
        
                <!-- 1. What Is a Z-Score? -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Is a Z-Score?</h2>
                    <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">A <strong>Z-score</strong> (standard score) measures how many standard deviations a data point is from the mean. It standardizes values from different distributions onto a common scale, making comparisons possible.</p>
        
                    <div class="stat-formula-box">
                        <strong>Z-Score Formula:</strong>&nbsp; Z = (x &minus; &mu;) / &sigma;
                    </div>
        
                    <div class="stat-edu-grid" style="margin-top:1rem;">
                        <div class="stat-feature-card stat-anim stat-anim-d1">
                            <div style="font-size:1.5rem;">&#x2795;</div>
                            <h4>Positive Z</h4>
                            <p>Value is above the mean. Z = 1.5 means 1.5 standard deviations above average.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d2">
                            <div style="font-size:1.5rem;">&#x2796;</div>
                            <h4>Negative Z</h4>
                            <p>Value is below the mean. Z = &minus;2.0 means 2 standard deviations below average.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d3">
                            <div style="font-size:1.5rem;">&#x1F3AF;</div>
                            <h4>Zero Z</h4>
                            <p>Value equals the mean exactly. The 50th percentile on a normal distribution.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 2. The 68-95-99.7 Rule -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">The 68-95-99.7 Rule (Empirical Rule)</h2>
        
                    <!-- Animated SVG Bell Curve -->
                    <div style="text-align:center;margin-bottom:1.5rem;" class="stat-anim stat-anim-d1">
                        <svg viewBox="0 0 500 200" style="max-width:500px;width:100%;" xmlns="http://www.w3.org/2000/svg">
                            <!-- Bell curve path -->
                            <path d="M 30,170 C 60,170 80,168 110,160 C 140,148 160,120 180,80 C 200,45 220,20 250,15 C 280,20 300,45 320,80 C 340,120 360,148 390,160 C 420,168 440,170 470,170" fill="none" stroke="#e11d48" stroke-width="2.5" class="stat-bell-animated"/>
                            <!-- 68% region -->
                            <rect x="180" y="70" width="140" height="100" fill="rgba(225,29,72,0.08)" rx="2"/>
                            <text x="250" y="135" text-anchor="middle" fill="#e11d48" font-size="13" font-weight="600" font-family="Inter,sans-serif">68%</text>
                            <!-- 95% region -->
                            <rect x="110" y="140" width="280" height="20" fill="rgba(225,29,72,0.05)" rx="2"/>
                            <text x="250" y="155" text-anchor="middle" fill="#be123c" font-size="11" font-family="Inter,sans-serif">95%</text>
                            <!-- 99.7% region -->
                            <rect x="60" y="162" width="380" height="8" fill="rgba(225,29,72,0.03)" rx="1"/>
                            <!-- Labels -->
                            <text x="110" y="188" text-anchor="middle" fill="currentColor" font-size="10" font-family="Inter,sans-serif">&minus;2&sigma;</text>
                            <text x="180" y="188" text-anchor="middle" fill="currentColor" font-size="10" font-family="Inter,sans-serif">&minus;1&sigma;</text>
                            <text x="250" y="188" text-anchor="middle" fill="currentColor" font-size="10" font-weight="600" font-family="Inter,sans-serif">&mu;</text>
                            <text x="320" y="188" text-anchor="middle" fill="currentColor" font-size="10" font-family="Inter,sans-serif">+1&sigma;</text>
                            <text x="390" y="188" text-anchor="middle" fill="currentColor" font-size="10" font-family="Inter,sans-serif">+2&sigma;</text>
                        </svg>
                    </div>
        
                    <table class="stat-ops-table">
                        <thead><tr><th>Range</th><th>Z-Score</th><th>% of Data</th><th>Example</th></tr></thead>
                        <tbody>
                            <tr><td style="font-weight:600;">&mu; &plusmn; 1&sigma;</td><td>|Z| &le; 1</td><td>68.27%</td><td>Most values (typical)</td></tr>
                            <tr><td style="font-weight:600;">&mu; &plusmn; 2&sigma;</td><td>|Z| &le; 2</td><td>95.45%</td><td>Nearly all values</td></tr>
                            <tr><td style="font-weight:600;">&mu; &plusmn; 3&sigma;</td><td>|Z| &le; 3</td><td>99.73%</td><td>Virtually all values</td></tr>
                        </tbody>
                    </table>
                </div>
        
                <!-- 3. Common Z-Scores Reference -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Common Z-Scores &amp; Percentiles</h2>
        
                    <table class="stat-ops-table">
                        <thead><tr><th>Z-Score</th><th>Percentile</th><th>Interpretation</th></tr></thead>
                        <tbody>
                            <tr><td>&minus;3.0</td><td>0.13%</td><td>Extremely low</td></tr>
                            <tr><td>&minus;2.0</td><td>2.28%</td><td>Significantly low</td></tr>
                            <tr><td>&minus;1.0</td><td>15.87%</td><td>Below average</td></tr>
                            <tr><td style="font-weight:700;">0.0</td><td style="font-weight:700;">50.00%</td><td style="font-weight:700;">Mean / Average</td></tr>
                            <tr><td>+1.0</td><td>84.13%</td><td>Above average</td></tr>
                            <tr><td>+1.645</td><td>95.00%</td><td>90% CI critical value</td></tr>
                            <tr><td>+1.960</td><td>97.50%</td><td>95% CI critical value</td></tr>
                            <tr><td>+2.0</td><td>97.72%</td><td>Significantly high</td></tr>
                            <tr><td>+2.576</td><td>99.50%</td><td>99% CI critical value</td></tr>
                            <tr><td>+3.0</td><td>99.87%</td><td>Extremely high</td></tr>
                        </tbody>
                    </table>
                </div>
        
                <!-- 4. Real-World Applications -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Real-World Applications</h2>
                    <div class="stat-edu-grid">
                        <div class="stat-edu-card stat-anim stat-anim-d1">
                            <h4>Standardized Testing</h4>
                            <p>SAT, ACT, and IQ scores use Z-scores to rank test-takers against the population and set percentile-based cutoffs.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d2">
                            <h4>Quality Control</h4>
                            <p>Manufacturing uses Six Sigma (Z = &plusmn;6) to maintain defect rates below 3.4 per million.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d3">
                            <h4>Finance &amp; Risk</h4>
                            <p>Stock returns are standardized for risk comparison. Value-at-Risk (VaR) models use Z-scores for tail risk estimation.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d4">
                            <h4>Medical Research</h4>
                            <p>Growth charts, lab results, and BMI use Z-scores to compare patients against age/sex-matched reference populations.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 5. FAQ -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
                    <div class="faq-item">
                        <button class="faq-question">What is a Z-score and how is it calculated?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">A Z-score measures how many standard deviations a value is from the mean. The formula is Z = (x &minus; &mu;) / &sigma;. A positive Z means above the mean, negative means below, and zero means exactly at the mean.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">How do I convert a Z-score to a percentile?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Use the standard normal CDF: Percentile = &Phi;(z) &times; 100%. For example, Z = 1.96 corresponds to the 97.5th percentile. This calculator performs the lookup automatically using jStat.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What is the 68-95-99.7 rule?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">For normal distributions: 68% of data falls within &plusmn;1&sigma;, 95% within &plusmn;2&sigma;, and 99.7% within &plusmn;3&sigma;. These correspond to Z-score ranges of &minus;1 to 1, &minus;2 to 2, and &minus;3 to 3.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What is the difference between left and right tail probability?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Left tail P(Z &le; z) is the area under the curve to the left of z. Right tail P(Z &ge; z) is the area to the right. They always sum to 1. &ldquo;Between &plusmn;z&rdquo; gives the central area, and &ldquo;Outside &plusmn;z&rdquo; gives the combined two-tail area.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">When should I use Z-scores versus t-scores?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Use Z-scores when the population standard deviation is known or n &gt; 30. Use t-scores when &sigma; is unknown and the sample is small. The t-distribution has heavier tails but approaches the normal as n increases.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">Can I use Z-scores with non-normal data?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">You can calculate Z-scores for any data, but the probability and percentile interpretations assume normality. For non-normal data, consider log or Box-Cox transformations first. The Central Limit Theorem helps when working with sample means of large samples.</div>
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
    <script src="<%=request.getContextPath()%>/js/z-score-calculator-core.js?v=<%=v%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/categories-menu.js" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=v%>" defer></script>

<script>window.__MS_STAT_PAGE__ = { key: 'z-score', label: "Z-Score Calculator" };</script>
<%
    request.setAttribute("mathAiButtonId", "btnMathAI");
    request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
    request.setAttribute("mathAiProfileExport", "configureStatisticsMathShell");
%>
<%@ include file="modern/components/math-ai-boot.inc.jsp" %>
</body>
</html>

