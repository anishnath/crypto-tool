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
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Sample Size Calculator Online - Survey A/B Test Research Free" />
        <jsp:param name="toolDescription" value="Calculate required sample size for surveys proportions means A/B tests and comparing groups. Confidence level margin of error power analysis finite population correction with interactive chart and Python export." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="sample-size-calculator.jsp" />
        <jsp:param name="toolKeywords" value="sample size calculator, survey sample size, a/b test sample size, statistical power, margin of error, confidence level, research sample size, sample size determination, finite population correction, power analysis calculator" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Survey proportion sample size with finite population correction,Mean estimation sample size,A/B test sample size with power analysis,Two-group mean comparison sample size,Confidence level 90% 95% 99% and custom,Step-by-step KaTeX formulas,Interactive Plotly chart showing size vs margin of error,Python code generation" />
        <jsp:param name="teaches" value="Sample size determination, margin of error, statistical power, confidence intervals, finite population correction, power analysis" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Choose Calculation Type|Select survey or mean estimation or A/B test or comparing means,Set Confidence Level|Pick 90% or 95% or 99% or enter a custom level,Enter Parameters|Input proportion margin of error or effect size and power,Click Calculate|Get required sample size with step-by-step formula,View Chart|See how sample size changes with margin of error or power,Export Code|Run Python code in the embedded compiler" />
        <jsp:param name="faq1q" value="What sample size do I need for a survey?" />
        <jsp:param name="faq1a" value="For a typical survey with 95% confidence and 5% margin of error use p=0.5 for maximum conservatism. This gives about 385 respondents for a large population. Smaller margins need larger samples." />
        <jsp:param name="faq2q" value="Why use p equals 0.5 for proportions?" />
        <jsp:param name="faq2a" value="Using p=0.5 maximizes the product p times 1 minus p which gives the largest possible sample size. This is the most conservative estimate when you do not know the true proportion in advance." />
        <jsp:param name="faq3q" value="Does population size affect sample size?" />
        <jsp:param name="faq3a" value="For large populations sample size depends mainly on confidence and margin of error. Finite population correction matters when sampling more than about 5% of the population reducing the required size." />
        <jsp:param name="faq4q" value="What is statistical power and why does it matter?" />
        <jsp:param name="faq4a" value="Power equals 1 minus beta is the probability of detecting a real effect. 80% power means a 20% chance of missing a true effect. Higher power requires larger samples but gives more reliable results." />
        <jsp:param name="faq5q" value="How do I determine sample size for an A/B test?" />
        <jsp:param name="faq5a" value="You need the baseline conversion rate the minimum detectable effect and desired power. Smaller effects need much larger samples. A 1% improvement from 10% to 11% needs about 15000 per group at 80% power." />
        <jsp:param name="faq6q" value="What if I cannot afford the calculated sample size?" />
        <jsp:param name="faq6a" value="You can accept a wider margin of error lower confidence level or lower power. For A/B tests you can also focus on detecting larger effects only or use sequential testing methods." />
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

    <% request.setAttribute("activeService", "sample-size"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <span aria-current="page">Sample Size</span>
            </nav>
            <h1>Sample Size Calculator</h1>
            <p class="ms-subtitle">Power analysis · margin of error · proportion & mean</p>
        </header>

        <div class="ic-stack">

            <div class="ic-hero ic-hero--compact stat-hero" id="stat-hero">
                <div class="ic-hero-top">
                    <button type="button" class="math-ai-tab-btn" id="btnMathAI" title="Math AI — statistics tutor + full math router in chat (Ctrl+Shift+A)">&#10024; AI</button>
                </div>
                <div class="stat-hero-core">
                    <!-- Mode Toggle -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label">Calculation Type</label>
                                            <div class="stat-mode-toggle" style="display:flex;flex-wrap:wrap;">
                                                <button type="button" class="stat-mode-btn active" id="ss-mode-survey" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Survey</button>
                                                <button type="button" class="stat-mode-btn" id="ss-mode-mean" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Mean</button>
                                                <button type="button" class="stat-mode-btn" id="ss-mode-ab" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">A/B Test</button>
                                                <button type="button" class="stat-mode-btn" id="ss-mode-compare" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Compare</button>
                                            </div>
                                        </div>
                    
                                        <!-- Confidence Level -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label">Confidence Level</label>
                                            <div class="ss-conf-pills">
                                                <button type="button" class="ss-conf-pill" data-conf="90">90%</button>
                                                <button type="button" class="ss-conf-pill active" data-conf="95">95%</button>
                                                <button type="button" class="ss-conf-pill" data-conf="99">99%</button>
                                                <button type="button" class="ss-conf-pill" data-conf="custom">Custom
                                                    <input type="number" class="ss-custom-input" id="ss-custom-conf" value="95" min="50" max="99.99" step="0.1" style="display:none;">
                                                </button>
                                            </div>
                                        </div>
                    
                                        <!-- Survey Proportion inputs (visible by default) -->
                                        <div id="ss-input-survey">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="ss-proportion">Expected Proportion (p)</label>
                                                <input type="number" class="stat-input-text ss-input" id="ss-proportion" value="0.5" step="0.01" min="0" max="1">
                                                <div class="tool-form-hint">Use 0.5 for maximum (most conservative)</div>
                                            </div>
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="ss-margin-error">Margin of Error (E)</label>
                                                <input type="number" class="stat-input-text ss-input" id="ss-margin-error" value="0.05" step="0.001" min="0">
                                                <div class="tool-form-hint">e.g. &plusmn;5% = 0.05</div>
                                            </div>
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="ss-pop-size">Population Size (optional)</label>
                                                <input type="number" class="stat-input-text ss-input" id="ss-pop-size" step="1" min="1">
                                                <div class="tool-form-hint">For finite population correction</div>
                                            </div>
                                        </div>
                    
                                        <!-- Mean Estimation inputs -->
                                        <div id="ss-input-mean" style="display:none;">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="ss-std-dev">Standard Deviation (&sigma;)</label>
                                                <input type="number" class="stat-input-text ss-input" id="ss-std-dev" value="15" step="0.01" min="0">
                                            </div>
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="ss-margin-error-mean">Margin of Error (E)</label>
                                                <input type="number" class="stat-input-text ss-input" id="ss-margin-error-mean" value="5" step="0.01" min="0">
                                            </div>
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="ss-pop-size-mean">Population Size (optional)</label>
                                                <input type="number" class="stat-input-text ss-input" id="ss-pop-size-mean" step="1" min="1">
                                            </div>
                                        </div>
                    
                                        <!-- A/B Test inputs -->
                                        <div id="ss-input-ab" style="display:none;">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="ss-p1">Baseline Proportion (p&#8321;)</label>
                                                <input type="number" class="stat-input-text ss-input" id="ss-p1" value="0.10" step="0.01" min="0" max="1">
                                                <div class="tool-form-hint">Control group rate</div>
                                            </div>
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="ss-p2">Expected Proportion (p&#8322;)</label>
                                                <input type="number" class="stat-input-text ss-input" id="ss-p2" value="0.15" step="0.01" min="0" max="1">
                                                <div class="tool-form-hint">Treatment group rate</div>
                                            </div>
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="ss-power">Statistical Power (%)</label>
                                                <input type="number" class="stat-input-text ss-input" id="ss-power" value="80" step="1" min="50" max="99">
                                                <div class="tool-form-hint">Usually 80% or 90%</div>
                                            </div>
                                        </div>
                    
                                        <!-- Compare Means inputs -->
                                        <div id="ss-input-compare" style="display:none;">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="ss-pooled-sd">Pooled Std Dev (&sigma;)</label>
                                                <input type="number" class="stat-input-text ss-input" id="ss-pooled-sd" value="10" step="0.01" min="0">
                                            </div>
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="ss-effect-size">Effect Size (|&mu;&#8321; &minus; &mu;&#8322;|)</label>
                                                <input type="number" class="stat-input-text ss-input" id="ss-effect-size" value="5" step="0.01" min="0">
                                                <div class="tool-form-hint">Minimum detectable difference</div>
                                            </div>
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="ss-power-means">Statistical Power (%)</label>
                                                <input type="number" class="stat-input-text ss-input" id="ss-power-means" value="80" step="1" min="50" max="99">
                                            </div>
                                        </div>
                    
                                        <!-- Buttons -->
                                        <button type="button" class="tool-action-btn" id="ss-calc-btn">Calculate Sample Size</button>
                                        <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                                            <button type="button" class="tool-action-btn" id="ss-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                                        </div>
                    
                                        <hr class="stat-sep">
                    
                                        <!-- Quick Examples -->
                                        <div class="tool-form-group" id="ss-examples">
                                            <label class="tool-form-label">Quick Examples</label>
                                            <div class="stat-examples">
                                                <button type="button" class="stat-example-chip" data-example="election-poll">Election Poll</button>
                                                <button type="button" class="stat-example-chip" data-example="customer-survey">Customer Survey</button>
                                                <button type="button" class="stat-example-chip" data-example="ab-conversion">A/B Conversion</button>
                                                <button type="button" class="stat-example-chip" data-example="clinical-trial">Clinical Trial</button>
                                            </div>
                                        </div>
                                    </div>
                </div>
            </div>

            <div class="ic-result-card">
                <div class="stat-output-tabs">
                                <button type="button" class="stat-output-tab active" data-tab="ss-result-panel">Result</button>
                                <button type="button" class="stat-output-tab" data-tab="ss-graph-panel">Chart</button>
                                <button type="button" class="stat-output-tab" data-tab="ss-compiler-panel">Python Compiler</button>
                            </div>
                
                            <div class="stat-panel active" id="ss-result-panel">
                                <div class="tool-card tool-result-card">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                                        <h4>Result</h4>
                                    </div>
                                    <div class="tool-result-content" id="ss-result-content">
                                        <div class="tool-empty-state">
                                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F4CA;</div>
                                            <h3>Enter parameters and click Calculate</h3>
                                            <p>Compute required sample size for surveys, A/B tests, and research studies.</p>
                                        </div>
                                    </div>
                                    <div class="tool-result-actions" id="ss-result-actions"></div>
                                </div>
                            </div>
                
                            <div class="stat-panel" id="ss-graph-panel">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><path d="M3 3v18h18"/><path d="M7 16l4-8 4 4 4-6"/></svg>
                                        <h4>Sample Size Visualization</h4>
                                    </div>
                                    <div style="flex:1;padding:1rem;min-height:300px;">
                                        <div id="ss-graph-container"></div>
                                    </div>
                                </div>
                            </div>
                
                            <div class="stat-panel" id="ss-compiler-panel">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                                        <h4>Python Compiler</h4>
                                    </div>
                                    <div style="flex:1;min-height:0;">
                                        <iframe id="ss-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                                    </div>
                                </div>
                            </div>
            </div>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
        </div>

<jsp:include page="modern/components/related-tools.jsp">
<jsp:param name="currentToolUrl" value="sample-size-calculator.jsp"/>
        <jsp:param name="keyword" value="statistics"/>
        <jsp:param name="limit" value="6"/>
</jsp:include>

        <section class="tool-expertise-section ms-below-fold" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
        
                <!-- 1. What Is Sample Size? -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Is Sample Size?</h2>
                    <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;"><strong>Sample size</strong> is the number of observations or respondents needed in a study to draw reliable conclusions about a population. Choosing the right sample size balances statistical rigor with practical constraints like cost and time.</p>
        
                    <!-- Animated SVG: Population to Sample -->
                    <div style="text-align:center;margin:1.5rem 0;">
                        <svg viewBox="0 0 400 80" style="max-width:400px;width:100%;" aria-label="Population to sample illustration">
                            <ellipse cx="100" cy="40" rx="70" ry="30" fill="none" stroke="var(--border-dark,#cbd5e1)" stroke-width="2"/>
                            <text x="100" y="44" text-anchor="middle" font-size="11" fill="var(--text-secondary,#475569)">Population (N)</text>
                            <line x1="175" y1="40" x2="225" y2="40" stroke="#e11d48" stroke-width="2" marker-end="url(#ss-arrow)" class="stat-anim stat-anim-d1"/>
                            <defs><marker id="ss-arrow" markerWidth="8" markerHeight="6" refX="8" refY="3" orient="auto"><polygon points="0 0, 8 3, 0 6" fill="#e11d48"/></marker></defs>
                            <ellipse cx="300" cy="40" rx="55" ry="25" fill="var(--tool-light)" stroke="#e11d48" stroke-width="2" class="stat-anim stat-anim-d2"/>
                            <text x="300" y="44" text-anchor="middle" font-size="11" fill="#e11d48" font-weight="600" class="stat-anim stat-anim-d3">Sample (n)</text>
                        </svg>
                    </div>
        
                    <div class="stat-edu-grid" style="margin-top:1rem;">
                        <div class="stat-feature-card stat-anim stat-anim-d1">
                            <div style="font-size:1.5rem;">&#x1F3AF;</div>
                            <h4>Precision</h4>
                            <p>Larger samples yield narrower confidence intervals and smaller margins of error, giving more precise estimates.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d2">
                            <div style="font-size:1.5rem;">&#x26A1;</div>
                            <h4>Power</h4>
                            <p>Adequate sample size ensures enough statistical power to detect real effects and avoid false negatives.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d3">
                            <div style="font-size:1.5rem;">&#x2696;&#xFE0F;</div>
                            <h4>Efficiency</h4>
                            <p>Too large wastes resources; too small produces unreliable results. Proper calculation finds the optimum.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 2. Sample Size Formulas -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Sample Size Formulas</h2>
        
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>Survey (proportion):</strong>&nbsp; n = z&sup2; &times; p(1&minus;p) / E&sup2;
                        <div style="font-size:0.75rem;color:var(--text-muted);margin-top:0.25rem;">z = critical value, p = expected proportion, E = margin of error</div>
                    </div>
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>Mean estimation:</strong>&nbsp; n = z&sup2; &times; &sigma;&sup2; / E&sup2;
                        <div style="font-size:0.75rem;color:var(--text-muted);margin-top:0.25rem;">&sigma; = population standard deviation, E = margin of error</div>
                    </div>
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>A/B test (two proportions):</strong>&nbsp; n = (z<sub>&alpha;/2</sub> + z<sub>&beta;</sub>)&sup2; &times; [p&#8321;(1&minus;p&#8321;) + p&#8322;(1&minus;p&#8322;)] / (p&#8321;&minus;p&#8322;)&sup2;
                        <div style="font-size:0.75rem;color:var(--text-muted);margin-top:0.25rem;">Per group. z<sub>&beta;</sub> from desired power (e.g. 0.84 for 80%)</div>
                    </div>
                    <div class="stat-formula-box">
                        <strong>Compare means:</strong>&nbsp; n = 2(z<sub>&alpha;/2</sub> + z<sub>&beta;</sub>)&sup2; &times; &sigma;&sup2; / &delta;&sup2;
                        <div style="font-size:0.75rem;color:var(--text-muted);margin-top:0.25rem;">Per group. &delta; = minimum detectable difference</div>
                    </div>
                </div>
        
                <!-- 3. Key Factors -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Key Factors Affecting Sample Size</h2>
        
                    <table class="stat-ops-table">
                        <thead><tr><th>Factor</th><th>Effect on Sample Size</th><th>Explanation</th></tr></thead>
                        <tbody>
                            <tr><td style="font-weight:600;">Confidence Level</td><td>Higher &rarr; larger n</td><td>99% confidence requires more data than 90% for the same precision</td></tr>
                            <tr><td style="font-weight:600;">Margin of Error</td><td>Smaller &rarr; larger n</td><td>Halving the margin of error quadruples the required sample size</td></tr>
                            <tr><td style="font-weight:600;">Variability</td><td>Higher &rarr; larger n</td><td>More variable populations need larger samples to estimate accurately</td></tr>
                            <tr><td style="font-weight:600;">Power</td><td>Higher &rarr; larger n</td><td>90% power needs about 30% more samples than 80% power</td></tr>
                            <tr><td style="font-weight:600;">Effect Size</td><td>Smaller &rarr; larger n</td><td>Detecting small differences requires substantially more observations</td></tr>
                        </tbody>
                    </table>
                </div>
        
                <!-- 4. Statistical Power -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Statistical Power</h2>
                    <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;"><strong>Statistical power</strong> (1 &minus; &beta;) is the probability that a study will detect a true effect when one exists. Under-powered studies waste resources because they are unlikely to produce significant results even when the effect is real.</p>
        
                    <div class="stat-worked-example" style="margin-top:1rem;">
                        <strong>Worked Example:</strong> A/B test with p&#8321;=0.10, p&#8322;=0.12, 95% confidence. Compare 80% vs 90% power.
                        <div style="margin-top:0.5rem;padding-left:1rem;border-left:3px solid var(--tool-primary);color:var(--text-secondary);font-size:0.875rem;">
                            z<sub>0.025</sub> = 1.96<br>
                            80% power: z<sub>&beta;</sub> = 0.842 &rarr; n &asymp; <strong>3,623 per group</strong><br>
                            90% power: z<sub>&beta;</sub> = 1.282 &rarr; n &asymp; <strong>4,862 per group</strong><br>
                            Going from 80% to 90% power increases sample size by ~34%.
                        </div>
                    </div>
        
                    <div style="margin-top:1rem;padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border-left:3px solid var(--warning);">
                        <p style="margin:0;font-size:0.875rem;color:var(--text-secondary);line-height:1.6;">
                            <strong>Rule of thumb:</strong> Use 80% power as a minimum for most studies. Use 90% for confirmatory trials or when the cost of a false negative is high.
                        </p>
                    </div>
                </div>
        
                <!-- 5. Practical Tips -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Practical Tips</h2>
        
                    <div class="stat-edu-grid">
                        <div class="stat-edu-card stat-anim stat-anim-d1">
                            <h4>&#x1F4CB; Surveys</h4>
                            <p>Use p=0.5 when unsure of the true proportion. Apply finite population correction when sampling &gt;5% of the population. Account for expected non-response by inflating the sample size (e.g. divide by expected response rate).</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d2">
                            <h4>&#x1F50D; A/B Tests</h4>
                            <p>Define the minimum detectable effect before starting. Smaller effects need much larger samples. Consider using sequential testing to stop early if the effect is large. Always run the test for the full planned duration.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d3">
                            <h4>&#x1F3E5; Clinical Research</h4>
                            <p>Regulatory agencies typically require 80&ndash;90% power. Account for dropout rates by over-enrolling. Pre-register your sample size calculation. Use interim analyses with appropriate alpha-spending functions.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 6. FAQ -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
                    <div class="faq-item">
                        <button class="faq-question">What sample size do I need for a survey?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">For a typical survey with 95% confidence and 5% margin of error, use p=0.5 for maximum conservatism. This gives about 385 respondents for a large population. Smaller margins need larger samples.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">Why use p equals 0.5 for proportions?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Using p=0.5 maximizes the product p&times;(1&minus;p), which gives the largest possible sample size. This is the most conservative estimate when you do not know the true proportion in advance.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">Does population size affect sample size?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">For large populations, sample size depends mainly on confidence and margin of error. Finite population correction matters when sampling more than about 5% of the population, reducing the required size.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What is statistical power and why does it matter?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Power (1&minus;&beta;) is the probability of detecting a real effect. 80% power means a 20% chance of missing a true effect. Higher power requires larger samples but gives more reliable results.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">How do I determine sample size for an A/B test?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">You need the baseline conversion rate, the minimum detectable effect, and desired power. Smaller effects need much larger samples. A 1% improvement from 10% to 11% needs about 15,000 per group at 80% power.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What if I cannot afford the calculated sample size?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">You can accept a wider margin of error, lower confidence level, or lower power. For A/B tests, you can also focus on detecting larger effects only or use sequential testing methods.</div>
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
    <script src="<%=request.getContextPath()%>/js/sample-size-core.js?v=<%=v%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/categories-menu.js" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=v%>" defer></script>

<script>window.__MS_STAT_PAGE__ = { key: 'sample-size', label: "Sample Size Calculator" };</script>
<%
    request.setAttribute("mathAiButtonId", "btnMathAI");
    request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
    request.setAttribute("mathAiProfileExport", "configureStatisticsMathShell");
%>
<%@ include file="modern/components/math-ai-boot.inc.jsp" %>
</body>
</html>
