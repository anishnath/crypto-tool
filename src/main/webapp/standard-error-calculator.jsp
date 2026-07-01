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
        <jsp:param name="toolName" value="Standard Error Calculator Online - SE Mean Proportion Free" />
        <jsp:param name="toolDescription" value="Calculate standard error for means proportions and differences. SE of mean SE of proportion difference of means and proportions with margin of error confidence intervals and Python export." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="standard-error-calculator.jsp" />
        <jsp:param name="toolKeywords" value="standard error calculator, SE calculator, standard error of mean, standard error of proportion, margin of error calculator, confidence interval, sampling error, SE of difference, standard error formula" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="SE of mean with margin of error and CI,SE of proportion with normal approximation CI,SE of difference of means for two independent samples,SE of difference of proportions for two samples,90% 95% 99% confidence levels with critical values,Step-by-step KaTeX formulas,Interactive Plotly CI visualization,Python scipy code generation" />
        <jsp:param name="teaches" value="Standard error, sampling distribution, margin of error, confidence intervals, critical values, standard error vs standard deviation" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Choose SE Type|Select SE of mean proportion or difference of means or proportions,Set Confidence Level|Pick 90% or 95% or 99% for margin of error,Enter Parameters|Input standard deviation sample size or proportions,Click Calculate|Get instant SE margin of error and confidence interval,View Chart|See the CI visualized on an interactive Plotly chart,Export Code|Run Python scipy code in the embedded compiler" />
        <jsp:param name="faq1q" value="What is the difference between standard error and standard deviation?" />
        <jsp:param name="faq1a" value="Standard deviation measures the spread of individual data points around the mean. Standard error measures how much a sample statistic like the mean varies across different samples. SE equals SD divided by the square root of the sample size." />
        <jsp:param name="faq2q" value="How does sample size affect standard error?" />
        <jsp:param name="faq2a" value="Standard error decreases as sample size increases proportional to the square root of n. Quadrupling the sample size halves the SE giving more precise estimates." />
        <jsp:param name="faq3q" value="When should I use SE of proportion versus SE of mean?" />
        <jsp:param name="faq3a" value="Use SE of proportion when your data is categorical like yes or no responses and you are estimating a percentage. Use SE of mean when your data is continuous like heights weights or test scores." />
        <jsp:param name="faq4q" value="What is margin of error and how is it calculated?" />
        <jsp:param name="faq4a" value="Margin of error equals the critical value times the standard error. It defines how far the confidence interval extends from the point estimate. A 95% CI uses z equals 1.96 so ME equals 1.96 times SE." />
        <jsp:param name="faq5q" value="How do I interpret the SE of the difference of two means?" />
        <jsp:param name="faq5a" value="The SE of the difference quantifies uncertainty in comparing two group means. It combines the variability from both samples using SE equals square root of s1 squared over n1 plus s2 squared over n2." />
        <jsp:param name="faq6q" value="Why is SE important in hypothesis testing?" />
        <jsp:param name="faq6a" value="SE is used to calculate test statistics like t and z scores. A smaller SE means the sample estimate is more precise making it easier to detect true differences between groups." />
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

    <% request.setAttribute("activeService", "std-error"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <span aria-current="page">Standard Error</span>
            </nav>
            <h1>Standard Error Calculator</h1>
            <p class="ms-subtitle">SE of mean · proportion · difference · CI chart</p>
        </header>

        <div class="ic-stack">

            <div class="ic-hero ic-hero--compact stat-hero" id="stat-hero">
                <div class="ic-hero-top">
                    <button type="button" class="math-ai-tab-btn" id="btnMathAI" title="Math AI — statistics tutor + full math router in chat (Ctrl+Shift+A)">&#10024; AI</button>
                </div>
                <div class="stat-hero-core">
                    <!-- Mode Toggle -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label">SE Type</label>
                                            <div class="stat-mode-toggle" style="display:flex;flex-wrap:wrap;">
                                                <button type="button" class="stat-mode-btn active" data-mode="mean" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">SE of Mean</button>
                                                <button type="button" class="stat-mode-btn" data-mode="proportion" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">SE of Prop</button>
                                                <button type="button" class="stat-mode-btn" data-mode="diffmean" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Diff Means</button>
                                                <button type="button" class="stat-mode-btn" data-mode="diffprop" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Diff Props</button>
                                            </div>
                                        </div>
                    
                                        <!-- Confidence Level -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label">Confidence Level</label>
                                            <div class="ci-conf-pills">
                                                <button type="button" class="se-conf-pill ci-conf-pill" data-conf="90">90%</button>
                                                <button type="button" class="se-conf-pill ci-conf-pill active" data-conf="95">95%</button>
                                                <button type="button" class="se-conf-pill ci-conf-pill" data-conf="99">99%</button>
                                            </div>
                                        </div>
                    
                                        <!-- SE of Mean inputs -->
                                        <div id="se-input-mean">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="se-sd">Standard Deviation (&sigma; or s)</label>
                                                <input type="number" class="stat-input-text" id="se-sd" value="15" step="0.01" min="0.01">
                                                <div class="tool-form-hint">Population or sample standard deviation</div>
                                            </div>
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="se-n">Sample Size (n)</label>
                                                <input type="number" class="stat-input-text" id="se-n" value="36" step="1" min="2">
                                                <div class="tool-form-hint">Number of observations in the sample</div>
                                            </div>
                                        </div>
                    
                                        <!-- SE of Proportion inputs -->
                                        <div id="se-input-proportion" style="display:none;">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="se-p">Sample Proportion (p&#770;)</label>
                                                <input type="number" class="stat-input-text" id="se-p" value="0.60" step="0.01" min="0" max="1">
                                                <div class="tool-form-hint">Proportion between 0 and 1</div>
                                            </div>
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="se-n-prop">Sample Size (n)</label>
                                                <input type="number" class="stat-input-text" id="se-n-prop" value="100" step="1" min="1">
                                            </div>
                                        </div>
                    
                                        <!-- Diff Means inputs -->
                                        <div id="se-input-diffmean" style="display:none;">
                                            <div class="ci-two-sample">
                                                <div class="ci-sample-group">
                                                    <h5>Sample 1</h5>
                                                    <div class="tool-form-group">
                                                        <label class="tool-form-label" for="se-sd1">Std Dev (s&#8321;)</label>
                                                        <input type="number" class="stat-input-text" id="se-sd1" value="10" step="0.01" min="0">
                                                    </div>
                                                    <div class="tool-form-group">
                                                        <label class="tool-form-label" for="se-n1">Size (n&#8321;)</label>
                                                        <input type="number" class="stat-input-text" id="se-n1" value="30" step="1" min="2">
                                                    </div>
                                                </div>
                                                <div class="ci-sample-group">
                                                    <h5>Sample 2</h5>
                                                    <div class="tool-form-group">
                                                        <label class="tool-form-label" for="se-sd2">Std Dev (s&#8322;)</label>
                                                        <input type="number" class="stat-input-text" id="se-sd2" value="12" step="0.01" min="0">
                                                    </div>
                                                    <div class="tool-form-group">
                                                        <label class="tool-form-label" for="se-n2">Size (n&#8322;)</label>
                                                        <input type="number" class="stat-input-text" id="se-n2" value="35" step="1" min="2">
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="tool-form-hint" style="margin-top:0.25rem;">Two independent samples</div>
                                        </div>
                    
                                        <!-- Diff Props inputs -->
                                        <div id="se-input-diffprop" style="display:none;">
                                            <div class="ci-two-sample">
                                                <div class="ci-sample-group">
                                                    <h5>Sample 1</h5>
                                                    <div class="tool-form-group">
                                                        <label class="tool-form-label" for="se-p1">Proportion (p&#8321;)</label>
                                                        <input type="number" class="stat-input-text" id="se-p1" value="0.55" step="0.01" min="0" max="1">
                                                    </div>
                                                    <div class="tool-form-group">
                                                        <label class="tool-form-label" for="se-n1-prop">Size (n&#8321;)</label>
                                                        <input type="number" class="stat-input-text" id="se-n1-prop" value="80" step="1" min="1">
                                                    </div>
                                                </div>
                                                <div class="ci-sample-group">
                                                    <h5>Sample 2</h5>
                                                    <div class="tool-form-group">
                                                        <label class="tool-form-label" for="se-p2">Proportion (p&#8322;)</label>
                                                        <input type="number" class="stat-input-text" id="se-p2" value="0.45" step="0.01" min="0" max="1">
                                                    </div>
                                                    <div class="tool-form-group">
                                                        <label class="tool-form-label" for="se-n2-prop">Size (n&#8322;)</label>
                                                        <input type="number" class="stat-input-text" id="se-n2-prop" value="90" step="1" min="1">
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="tool-form-hint" style="margin-top:0.25rem;">Two independent proportions</div>
                                        </div>
                    
                                        <!-- Buttons -->
                                        <button type="button" class="tool-action-btn" id="se-calc-btn">Calculate Standard Error</button>
                                        <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                                            <button type="button" class="tool-action-btn" id="se-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                                        </div>
                    
                                        <hr class="stat-sep">
                    
                                        <!-- Quick Examples -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label">Quick Examples</label>
                                            <div class="stat-examples">
                                                <button type="button" class="stat-example-chip" data-se-example="survey-mean">Survey Mean</button>
                                                <button type="button" class="stat-example-chip" data-se-example="election-poll">Election Poll</button>
                                                <button type="button" class="stat-example-chip" data-se-example="drug-trial">Drug Trial</button>
                                                <button type="button" class="stat-example-chip" data-se-example="ab-test">A/B Test</button>
                                            </div>
                                        </div>
                                    </div>
                </div>
            </div>

            <div class="ic-result-card">
                <div class="stat-output-tabs">
                                <button type="button" class="stat-output-tab active" data-tab="se-result-panel">Result</button>
                                <button type="button" class="stat-output-tab" data-tab="se-graph-panel">CI Chart</button>
                                <button type="button" class="stat-output-tab" data-tab="se-compiler-panel">Python Compiler</button>
                            </div>
                
                            <div class="stat-panel active" id="se-result-panel">
                                <div class="tool-card tool-result-card">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                                        <h4>Result</h4>
                                    </div>
                                    <div class="tool-result-content" id="se-result-content">
                                        <div class="tool-empty-state">
                                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F4CA;</div>
                                            <h3>Enter parameters and click Calculate</h3>
                                            <p>Compute standard error for means, proportions, or differences.</p>
                                        </div>
                                    </div>
                                    <div class="tool-result-actions" id="se-result-actions"></div>
                                </div>
                            </div>
                
                            <div class="stat-panel" id="se-graph-panel">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><path d="M3 3v18h18"/><path d="M7 16l4-8 4 4 4-6"/></svg>
                                        <h4>CI Visualization</h4>
                                    </div>
                                    <div style="flex:1;padding:1rem;min-height:300px;">
                                        <div id="se-graph-container"></div>
                                    </div>
                                </div>
                            </div>
                
                            <div class="stat-panel" id="se-compiler-panel">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                                        <h4>Python Compiler</h4>
                                    </div>
                                    <div style="flex:1;min-height:0;">
                                        <iframe id="se-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                                    </div>
                                </div>
                            </div>
            </div>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
        </div>

<jsp:include page="modern/components/related-tools.jsp">
<jsp:param name="currentToolUrl" value="standard-error-calculator.jsp"/>
        <jsp:param name="keyword" value="statistics"/>
        <jsp:param name="limit" value="6"/>
</jsp:include>

        <section class="tool-expertise-section ms-below-fold" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
        
                <!-- 1. What Is Standard Error? -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Is Standard Error?</h2>
                    <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">The <strong>standard error</strong> (SE) measures the variability of a sample statistic from sample to sample. It tells you how precisely your sample estimate (mean or proportion) approximates the true population parameter. Smaller SE means greater precision.</p>
        
                    <!-- Animated SVG: sample means clustered around population mean -->
                    <div style="text-align:center;margin:1.5rem 0;">
                        <svg viewBox="0 0 400 100" style="max-width:400px;width:100%;" aria-label="Sample means clustered around population mean">
                            <line x1="30" y1="60" x2="370" y2="60" stroke="var(--border-dark,#cbd5e1)" stroke-width="2"/>
                            <!-- Population mean -->
                            <line x1="200" y1="45" x2="200" y2="75" stroke="#e11d48" stroke-width="3"/>
                            <text x="200" y="90" text-anchor="middle" font-size="11" fill="#e11d48" font-weight="600">&mu;</text>
                            <!-- Sample means scattered around mu -->
                            <circle cx="180" cy="60" r="5" fill="#f43f5e" opacity="0.6" class="stat-anim stat-anim-d1"/>
                            <circle cx="210" cy="60" r="5" fill="#f43f5e" opacity="0.6" class="stat-anim stat-anim-d2"/>
                            <circle cx="195" cy="60" r="5" fill="#f43f5e" opacity="0.6" class="stat-anim stat-anim-d1"/>
                            <circle cx="205" cy="60" r="5" fill="#f43f5e" opacity="0.6" class="stat-anim stat-anim-d3"/>
                            <circle cx="188" cy="60" r="5" fill="#f43f5e" opacity="0.6" class="stat-anim stat-anim-d2"/>
                            <circle cx="215" cy="60" r="5" fill="#f43f5e" opacity="0.6" class="stat-anim stat-anim-d3"/>
                            <circle cx="192" cy="60" r="5" fill="#f43f5e" opacity="0.6" class="stat-anim stat-anim-d1"/>
                            <!-- SE bracket -->
                            <line x1="175" y1="35" x2="225" y2="35" stroke="var(--text-muted,#94a3b8)" stroke-width="1" stroke-dasharray="4"/>
                            <text x="200" y="28" text-anchor="middle" font-size="10" fill="var(--text-muted,#94a3b8)">SE = spread of x&#772; values</text>
                        </svg>
                    </div>
        
                    <div class="stat-edu-grid" style="margin-top:1rem;">
                        <div class="stat-feature-card stat-anim stat-anim-d1">
                            <div style="font-size:1.5rem;">&#x1F4C9;</div>
                            <h4>Sampling Variability</h4>
                            <p>Different samples from the same population yield different statistics. SE quantifies how much these sample estimates typically vary.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d2">
                            <div style="font-size:1.5rem;">&#x1F3AF;</div>
                            <h4>Precision of Estimate</h4>
                            <p>A smaller SE indicates that the sample statistic is a more precise estimate of the population parameter.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d3">
                            <div style="font-size:1.5rem;">&#x1F4CF;</div>
                            <h4>Foundation for CI</h4>
                            <p>Confidence intervals are built from the SE. The margin of error equals the critical value times the standard error.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 2. Standard Error Formulas -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Standard Error Formulas</h2>
        
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>SE of Mean:</strong>&nbsp; SE = &sigma; / &radic;n
                    </div>
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>SE of Proportion:</strong>&nbsp; SE = &radic;(p&#770;(1 &minus; p&#770;) / n)
                    </div>
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>SE of Difference of Means:</strong>&nbsp; SE = &radic;(s&#8321;&sup2; / n&#8321; + s&#8322;&sup2; / n&#8322;)
                    </div>
                    <div class="stat-formula-box">
                        <strong>SE of Difference of Proportions:</strong>&nbsp; SE = &radic;(p&#770;&#8321;(1 &minus; p&#770;&#8321;) / n&#8321; + p&#770;&#8322;(1 &minus; p&#770;&#8322;) / n&#8322;)
                    </div>
        
                    <div class="stat-worked-example" style="margin-top:1rem;">
                        <strong>Worked Example:</strong> A population has SD = 15 and we draw a sample of n = 36. Find the standard error of the mean.
                        <div style="margin-top:0.5rem;padding-left:1rem;border-left:3px solid var(--tool-primary);color:var(--text-secondary);font-size:0.875rem;">
                            SE = &sigma; / &radic;n = 15 / &radic;36 = 15 / 6 = <strong>2.5</strong><br>
                            At 95% confidence (z = 1.96): MoE = 1.96 &times; 2.5 = <strong>4.9</strong>
                        </div>
                    </div>
                </div>
        
                <!-- 3. SE vs Standard Deviation -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">SE vs Standard Deviation</h2>
        
                    <div class="stat-edu-grid">
                        <div class="stat-edu-card stat-anim stat-anim-d1">
                            <h4>&#x1F4CA; Standard Deviation (SD)</h4>
                            <p>Measures the spread of <em>individual data points</em> around the sample mean. It describes variability within a single sample. SD does not depend on sample size.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d2">
                            <h4>&#x1F4C9; Standard Error (SE)</h4>
                            <p>Measures the spread of <em>sample statistics</em> (like the mean) across many samples. It describes how precisely the statistic estimates the population parameter. SE decreases with larger n.</p>
                        </div>
                    </div>
        
                    <div style="margin-top:1rem;padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border-left:3px solid var(--tool-primary);">
                        <p style="margin:0;font-size:0.875rem;color:var(--text-secondary);line-height:1.6;">
                            <strong>Key Relationship:</strong> SE = SD / &radic;n. The standard error is always smaller than the standard deviation (for n &gt; 1). As sample size grows, SE shrinks but SD stays roughly the same.
                        </p>
                    </div>
                </div>
        
                <!-- 4. Margin of Error & Confidence Intervals -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Margin of Error &amp; Confidence Intervals</h2>
        
                    <div class="stat-formula-box" style="margin-bottom:1rem;">
                        <strong>Margin of Error:</strong>&nbsp; ME = z* &times; SE
                    </div>
        
                    <table class="stat-ops-table">
                        <thead><tr><th>Confidence Level</th><th>z* Critical Value</th><th>Multiplier Effect</th></tr></thead>
                        <tbody>
                            <tr><td style="font-weight:600;">90%</td><td>1.645</td><td>Narrower interval, less certainty</td></tr>
                            <tr><td style="font-weight:600;">95%</td><td>1.960</td><td>Standard balance of precision and confidence</td></tr>
                            <tr><td style="font-weight:600;">99%</td><td>2.576</td><td>Wider interval, higher certainty</td></tr>
                        </tbody>
                    </table>
        
                    <!-- CI on number line SVG -->
                    <div style="text-align:center;margin:1.5rem 0;">
                        <svg viewBox="0 0 400 80" style="max-width:400px;width:100%;" aria-label="Confidence interval on a number line">
                            <line x1="30" y1="40" x2="370" y2="40" stroke="var(--border-dark,#cbd5e1)" stroke-width="2"/>
                            <line x1="120" y1="30" x2="120" y2="50" stroke="#e11d48" stroke-width="3" class="stat-anim stat-anim-d1"/>
                            <line x1="280" y1="30" x2="280" y2="50" stroke="#e11d48" stroke-width="3" class="stat-anim stat-anim-d2"/>
                            <line x1="120" y1="40" x2="280" y2="40" stroke="#e11d48" stroke-width="4" opacity="0.3" class="stat-anim stat-anim-d1"/>
                            <circle cx="200" cy="40" r="6" fill="#ef4444" class="stat-anim stat-anim-d3"/>
                            <text x="80" y="65" text-anchor="middle" font-size="10" fill="var(--text-secondary,#475569)">x&#772; &minus; ME</text>
                            <text x="200" y="65" text-anchor="middle" font-size="11" fill="#ef4444" font-weight="600">x&#772;</text>
                            <text x="320" y="65" text-anchor="middle" font-size="10" fill="var(--text-secondary,#475569)">x&#772; + ME</text>
                            <text x="200" y="20" text-anchor="middle" font-size="10" fill="var(--text-muted,#94a3b8)">CI = x&#772; &plusmn; z* &times; SE</text>
                        </svg>
                    </div>
                </div>
        
                <!-- 5. Key Relationships -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Key Relationships</h2>
        
                    <div class="stat-edu-grid">
                        <div class="stat-edu-card stat-anim stat-anim-d1">
                            <h4>&#x1F4C8; Larger n &rarr; Smaller SE</h4>
                            <p>Increasing sample size reduces the standard error. More data means more precise estimates of the population parameter.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d2">
                            <h4>&#x1F4CA; Higher Variability &rarr; Larger SE</h4>
                            <p>Greater population variability (larger SD) increases the standard error. More spread in the data means less precise sample estimates.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d3">
                            <h4>&#x1F4D0; SE &prop; 1 / &radic;n</h4>
                            <p>Standard error is inversely proportional to the square root of the sample size. This is the law of diminishing returns in sampling.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d4">
                            <h4>&#x00D7;4 Rule</h4>
                            <p>To halve the standard error (double the precision), you need to quadruple the sample size. Going from n=100 to n=400 cuts SE in half.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 6. Frequently Asked Questions -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
                    <div class="faq-item">
                        <button class="faq-question">What is the difference between standard error and standard deviation?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Standard deviation measures the spread of individual data points around the mean. Standard error measures how much a sample statistic (like the mean) varies across different samples. SE equals SD divided by the square root of the sample size.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">How does sample size affect standard error?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Standard error decreases as sample size increases, proportional to the square root of n. Quadrupling the sample size halves the SE, giving more precise estimates.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">When should I use SE of proportion versus SE of mean?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Use SE of proportion when your data is categorical (like yes/no responses) and you are estimating a percentage. Use SE of mean when your data is continuous, like heights, weights, or test scores.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What is margin of error and how is it calculated?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Margin of error equals the critical value times the standard error. It defines how far the confidence interval extends from the point estimate. A 95% CI uses z = 1.96, so ME = 1.96 &times; SE.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">How do I interpret the SE of the difference of two means?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">The SE of the difference quantifies uncertainty in comparing two group means. It combines the variability from both samples using SE = &radic;(s<sub>1</sub>&sup2;/n<sub>1</sub> + s<sub>2</sub>&sup2;/n<sub>2</sub>).</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">Why is SE important in hypothesis testing?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">SE is used to calculate test statistics like t and z scores. A smaller SE means the sample estimate is more precise, making it easier to detect true differences between groups.</div>
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
    <script src="<%=request.getContextPath()%>/js/standard-error-core.js?v=<%=v%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/categories-menu.js" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=v%>" defer></script>

<script>window.__MS_STAT_PAGE__ = { key: 'std-error', label: "Standard Error Calculator" };</script>
<%
    request.setAttribute("mathAiButtonId", "btnMathAI");
    request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
    request.setAttribute("mathAiProfileExport", "configureStatisticsMathShell");
%>
<%@ include file="modern/components/math-ai-boot.inc.jsp" %>
</body>
</html>

