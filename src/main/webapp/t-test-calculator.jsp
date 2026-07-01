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
        <jsp:param name="toolName" value="T-Test Calculator Online - One Sample Two Sample Paired Welch Free" />
        <jsp:param name="toolDescription" value="Perform one-sample two-sample paired and Welch t-tests. Get t-statistic p-value degrees of freedom critical value confidence interval Cohen d effect size with t-distribution chart and Python scipy export." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="t-test-calculator.jsp" />
        <jsp:param name="toolKeywords" value="t-test calculator, student t test, one sample t test, two sample t test, paired t test, welch t test, t statistic, p value calculator, degrees of freedom, critical value, cohen d effect size, hypothesis testing calculator" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="One-sample t-test vs known mean,Two-sample independent t-test with pooled variance,Paired t-test for before/after data,Welch t-test for unequal variances,P-value and critical value calculation,Cohen d effect size,Confidence interval for mean difference,Interactive Plotly t-distribution chart,Python scipy code generation" />
        <jsp:param name="teaches" value="T-tests, hypothesis testing, p-value, statistical significance, degrees of freedom, effect size, t-distribution" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Choose Test Type|Select one-sample or two-sample or paired or Welch t-test,Enter Data|Paste sample data comma or space separated,Set Parameters|Choose significance level and alternative hypothesis direction,Click Calculate|Get t-statistic p-value CI and effect size instantly,View Distribution|See t-distribution curve with rejection regions,Export Code|Run Python scipy code in the embedded compiler" />
        <jsp:param name="faq1q" value="Which t-test should I use?" />
        <jsp:param name="faq1a" value="Use one-sample to compare a mean to a known value. Use independent two-sample when groups are unrelated with similar variances. Use paired for before/after or matched data. Use Welch when group variances differ or you are unsure about equal variances." />
        <jsp:param name="faq2q" value="What does the p-value tell me?" />
        <jsp:param name="faq2a" value="The p-value is the probability of observing data as extreme as yours if the null hypothesis is true. A small p-value below alpha suggests the data is unlikely under the null so you reject it." />
        <jsp:param name="faq3q" value="What is Cohen d and why does it matter?" />
        <jsp:param name="faq3a" value="Cohen d measures effect size or practical significance. A statistically significant result with tiny d may not be meaningful. Small d is about 0.2 medium about 0.5 and large about 0.8." />
        <jsp:param name="faq4q" value="What are the assumptions of a t-test?" />
        <jsp:param name="faq4a" value="Data should be approximately normal or sample size large enough for CLT. Observations must be independent. Two-sample tests assume equal variances unless using Welch. Paired tests assume the differences are normally distributed." />
        <jsp:param name="faq5q" value="How do I choose between one-tailed and two-tailed?" />
        <jsp:param name="faq5a" value="Use two-tailed when you want to detect a difference in either direction. Use one-tailed only when you have a strong prior hypothesis about the direction of the effect before collecting data." />
        <jsp:param name="faq6q" value="When is a t-test not appropriate?" />
        <jsp:param name="faq6a" value="Avoid t-tests with very small non-normal samples or heavily skewed data. Use non-parametric alternatives like Mann-Whitney U or Wilcoxon signed-rank test. For more than two groups use ANOVA instead." />
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

    <% request.setAttribute("activeService", "t-test"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <span aria-current="page">T-Test</span>
            </nav>
            <h1>T-Test Calculator</h1>
            <p class="ms-subtitle">One-sample · two-sample · paired · Welch · t curve</p>
        </header>

        <div class="ic-stack">

            <div class="ic-hero ic-hero--compact stat-hero" id="stat-hero">
                <div class="ic-hero-top">
                    <button type="button" class="math-ai-tab-btn" id="btnMathAI" title="Math AI — statistics tutor + full math router in chat (Ctrl+Shift+A)">&#10024; AI</button>
                </div>
                <div class="stat-hero-core">
                    <!-- Mode Toggle -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label">Test Type</label>
                                            <div class="stat-mode-toggle" style="display:flex;flex-wrap:wrap;">
                                                <button type="button" class="stat-mode-btn active" id="tt-mode-one" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">One-Sample</button>
                                                <button type="button" class="stat-mode-btn" id="tt-mode-two" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Two-Sample</button>
                                                <button type="button" class="stat-mode-btn" id="tt-mode-paired" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Paired</button>
                                                <button type="button" class="stat-mode-btn" id="tt-mode-welch" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Welch</button>
                                            </div>
                                        </div>
                    
                                        <!-- Shared Controls -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label" for="tt-alpha">Significance Level (&alpha;)</label>
                                            <select class="stat-input-text" id="tt-alpha">
                                                <option value="0.01">0.01</option>
                                                <option value="0.05" selected>0.05</option>
                                                <option value="0.10">0.10</option>
                                            </select>
                                        </div>
                    
                                        <div class="tool-form-group">
                                            <label class="tool-form-label" for="tt-tail">Alternative Hypothesis</label>
                                            <select class="stat-input-text" id="tt-tail">
                                                <option value="two" selected>Two-tailed</option>
                                                <option value="right">Right-tailed</option>
                                                <option value="left">Left-tailed</option>
                                            </select>
                                        </div>
                    
                                        <!-- One-Sample inputs -->
                                        <div id="tt-input-one">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="tt-one-data">Sample Data (comma or space separated)</label>
                                                <textarea class="stat-input-text" id="tt-one-data" rows="3" placeholder="Enter data values">23, 25, 27, 22, 24, 26, 28, 21, 25, 24</textarea>
                                                <div class="tool-form-hint">Raw data values</div>
                                            </div>
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="tt-one-mu">Population Mean (&mu;&#8320;)</label>
                                                <input type="number" class="stat-input-text" id="tt-one-mu" value="25" step="0.01">
                                            </div>
                                        </div>
                    
                                        <!-- Two-Sample inputs -->
                                        <div id="tt-input-two" style="display:none;">
                                            <div class="tt-two-group">
                                                <div>
                                                    <div class="tt-group-label">Group 1</div>
                                                    <div class="tool-form-group">
                                                        <label class="tool-form-label" for="tt-two-data1">Sample Data</label>
                                                        <textarea class="stat-input-text" id="tt-two-data1" rows="3" placeholder="Group 1 data">23, 25, 27, 22, 24, 26</textarea>
                                                    </div>
                                                </div>
                                                <div>
                                                    <div class="tt-group-label">Group 2</div>
                                                    <div class="tool-form-group">
                                                        <label class="tool-form-label" for="tt-two-data2">Sample Data</label>
                                                        <textarea class="stat-input-text" id="tt-two-data2" rows="3" placeholder="Group 2 data">28, 30, 32, 29, 31, 33</textarea>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                    
                                        <!-- Paired inputs -->
                                        <div id="tt-input-paired" style="display:none;">
                                            <div class="tt-two-group">
                                                <div>
                                                    <div class="tt-group-label">Before</div>
                                                    <div class="tool-form-group">
                                                        <label class="tool-form-label" for="tt-paired-before">Sample Data</label>
                                                        <textarea class="stat-input-text" id="tt-paired-before" rows="3" placeholder="Before data">120, 125, 130, 118, 122, 128</textarea>
                                                    </div>
                                                </div>
                                                <div>
                                                    <div class="tt-group-label">After</div>
                                                    <div class="tool-form-group">
                                                        <label class="tool-form-label" for="tt-paired-after">Sample Data</label>
                                                        <textarea class="stat-input-text" id="tt-paired-after" rows="3" placeholder="After data">115, 120, 125, 113, 118, 123</textarea>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                    
                                        <!-- Welch inputs -->
                                        <div id="tt-input-welch" style="display:none;">
                                            <div class="tt-two-group">
                                                <div>
                                                    <div class="tt-group-label">Group 1</div>
                                                    <div class="tool-form-group">
                                                        <label class="tool-form-label" for="tt-welch-data1">Sample Data</label>
                                                        <textarea class="stat-input-text" id="tt-welch-data1" rows="3" placeholder="Group 1 data">23, 25, 27, 22, 24, 26, 25</textarea>
                                                    </div>
                                                </div>
                                                <div>
                                                    <div class="tt-group-label">Group 2</div>
                                                    <div class="tool-form-group">
                                                        <label class="tool-form-label" for="tt-welch-data2">Sample Data</label>
                                                        <textarea class="stat-input-text" id="tt-welch-data2" rows="3" placeholder="Group 2 data">28, 30, 32, 29, 31, 33, 30, 31</textarea>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                    
                                        <!-- Buttons -->
                                        <button type="button" class="tool-action-btn" id="tt-calc-btn">Calculate T-Test</button>
                                        <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                                            <button type="button" class="tool-action-btn" id="tt-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                                        </div>
                    
                                        <hr class="stat-sep">
                    
                                        <!-- Quick Examples -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label">Quick Examples</label>
                                            <div class="stat-examples" id="tt-examples">
                                                <button type="button" class="stat-example-chip" data-example="exam-scores">Exam Scores</button>
                                                <button type="button" class="stat-example-chip" data-example="drug-trial">Drug Trial</button>
                                                <button type="button" class="stat-example-chip" data-example="weight-loss">Weight Loss</button>
                                                <button type="button" class="stat-example-chip" data-example="teaching-methods">Teaching Methods</button>
                                            </div>
                                        </div>
                                    </div>
                </div>
            </div>

            <div class="ic-result-card">
                <div class="stat-output-tabs">
                                <button type="button" class="stat-output-tab active" data-tab="tt-result-panel">Result</button>
                                <button type="button" class="stat-output-tab" data-tab="tt-graph-panel">T-Distribution</button>
                                <button type="button" class="stat-output-tab" data-tab="tt-compiler-panel">Python Compiler</button>
                            </div>
                
                            <div class="stat-panel active" id="tt-result-panel">
                                <div class="tool-card tool-result-card">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                                        <h4>Result</h4>
                                    </div>
                                    <div class="tool-result-content" id="tt-result-content">
                                        <div class="tool-empty-state">
                                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F4CA;</div>
                                            <h3>Enter data and click Calculate</h3>
                                            <p>Perform one-sample, two-sample, paired, or Welch t-tests with full results.</p>
                                        </div>
                                    </div>
                                    <div class="tool-result-actions" id="tt-result-actions"></div>
                                </div>
                            </div>
                
                            <div class="stat-panel" id="tt-graph-panel">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><path d="M3 3v18h18"/><path d="M7 16l4-8 4 4 4-6"/></svg>
                                        <h4>T-Distribution Visualization</h4>
                                    </div>
                                    <div style="flex:1;padding:1rem;min-height:300px;">
                                        <div id="tt-graph-container"></div>
                                    </div>
                                </div>
                            </div>
                
                            <div class="stat-panel" id="tt-compiler-panel">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                                        <h4>Python Compiler</h4>
                                    </div>
                                    <div style="flex:1;min-height:0;">
                                        <iframe id="tt-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                                    </div>
                                </div>
                            </div>
            </div>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
        </div>

<jsp:include page="modern/components/related-tools.jsp">
<jsp:param name="currentToolUrl" value="t-test-calculator.jsp"/>
        <jsp:param name="keyword" value="statistics"/>
        <jsp:param name="limit" value="6"/>
</jsp:include>

        <section class="tool-expertise-section ms-below-fold" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
        
                <!-- 1. What Is a T-Test? -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Is a T-Test?</h2>
                    <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">A <strong>t-test</strong> is a statistical hypothesis test used to determine whether there is a significant difference between the means of one or two groups. It uses the <strong>t-distribution</strong>, which accounts for small sample sizes and unknown population standard deviations.</p>
        
                    <!-- Animated SVG: T-distribution curve -->
                    <div style="text-align:center;margin:1.5rem 0;">
                        <svg viewBox="0 0 400 100" style="max-width:400px;width:100%;" aria-label="T-distribution curve with rejection regions">
                            <line x1="30" y1="80" x2="370" y2="80" stroke="var(--border-dark,#cbd5e1)" stroke-width="2"/>
                            <path d="M30,80 Q80,78 120,70 Q160,45 200,20 Q240,45 280,70 Q320,78 370,80" fill="none" stroke="var(--text-muted,#94a3b8)" stroke-width="2" class="stat-anim stat-anim-d1"/>
                            <path d="M30,80 Q50,79 70,77 L70,80 Z" fill="#e11d48" opacity="0.3" class="stat-anim stat-anim-d2"/>
                            <path d="M330,77 Q350,79 370,80 L330,80 Z" fill="#e11d48" opacity="0.3" class="stat-anim stat-anim-d2"/>
                            <line x1="200" y1="20" x2="200" y2="80" stroke="var(--text-muted,#94a3b8)" stroke-width="1" stroke-dasharray="4"/>
                            <line x1="260" y1="55" x2="260" y2="80" stroke="#e11d48" stroke-width="2" class="stat-anim stat-anim-d3"/>
                            <circle cx="260" cy="55" r="4" fill="#e11d48" class="stat-anim stat-anim-d3"/>
                            <text x="200" y="95" text-anchor="middle" font-size="10" fill="var(--text-muted,#94a3b8)">0</text>
                            <text x="260" y="95" text-anchor="middle" font-size="10" fill="#e11d48" font-weight="600">t</text>
                            <text x="50" y="70" text-anchor="middle" font-size="9" fill="#e11d48">&alpha;/2</text>
                            <text x="350" y="70" text-anchor="middle" font-size="9" fill="#e11d48">&alpha;/2</text>
                        </svg>
                    </div>
        
                    <div class="stat-edu-grid" style="margin-top:1rem;">
                        <div class="stat-feature-card stat-anim stat-anim-d1">
                            <div style="font-size:1.5rem;">&#x1F3AF;</div>
                            <h4>Hypothesis Testing</h4>
                            <p>Compare a sample mean to a known value or compare two group means to determine if the difference is statistically significant.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d2">
                            <div style="font-size:1.5rem;">&#x2705;</div>
                            <h4>Statistical Significance</h4>
                            <p>The p-value tells you the probability of observing your data under the null hypothesis. Small p-values suggest significant results.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d3">
                            <div style="font-size:1.5rem;">&#x1F4CF;</div>
                            <h4>Effect Size</h4>
                            <p>Cohen&rsquo;s d measures the practical significance of the difference. A result can be statistically significant but have a small effect.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 2. Types of T-Tests -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Types of T-Tests</h2>
        
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>One-Sample T-Test:</strong>&nbsp; t = (x&#772; &minus; &mu;&#8320;) / (s / &radic;n)
                        <div style="margin-top:0.375rem;font-size:0.8125rem;color:var(--text-secondary);">Compares a sample mean to a known or hypothesized population mean &mu;&#8320;. Uses n&minus;1 degrees of freedom.</div>
                    </div>
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>Two-Sample T-Test (Pooled):</strong>&nbsp; t = (x&#772;<sub>1</sub> &minus; x&#772;<sub>2</sub>) / (s<sub>p</sub> &times; &radic;(1/n<sub>1</sub> + 1/n<sub>2</sub>))
                        <div style="margin-top:0.375rem;font-size:0.8125rem;color:var(--text-secondary);">Compares means of two independent groups assuming equal variances. s<sub>p</sub> is the pooled standard deviation with n<sub>1</sub>+n<sub>2</sub>&minus;2 degrees of freedom.</div>
                    </div>
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>Paired T-Test:</strong>&nbsp; t = d&#772; / (s<sub>d</sub> / &radic;n)
                        <div style="margin-top:0.375rem;font-size:0.8125rem;color:var(--text-secondary);">Tests whether the mean difference d&#772; of paired observations differs from zero. Uses n&minus;1 degrees of freedom where n is the number of pairs.</div>
                    </div>
                    <div class="stat-formula-box">
                        <strong>Welch&rsquo;s T-Test:</strong>&nbsp; t = (x&#772;<sub>1</sub> &minus; x&#772;<sub>2</sub>) / &radic;(s<sub>1</sub>&sup2;/n<sub>1</sub> + s<sub>2</sub>&sup2;/n<sub>2</sub>)
                        <div style="margin-top:0.375rem;font-size:0.8125rem;color:var(--text-secondary);">Compares means of two independent groups without assuming equal variances. Uses Welch-Satterthwaite approximation for degrees of freedom.</div>
                    </div>
                </div>
        
                <!-- 3. Choosing the Right T-Test -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Choosing the Right T-Test</h2>
        
                    <table class="stat-ops-table">
                        <thead><tr><th>Scenario</th><th>Test Type</th><th>When to Use</th></tr></thead>
                        <tbody>
                            <tr><td>Compare sample mean to a known value</td><td style="font-weight:600;">One-Sample</td><td>Testing if a batch mean equals the specification value</td></tr>
                            <tr><td>Compare two independent groups with similar variances</td><td style="font-weight:600;">Two-Sample</td><td>Treatment vs control, males vs females</td></tr>
                            <tr><td>Before and after measurements on same subjects</td><td style="font-weight:600;">Paired</td><td>Pre-test vs post-test, left eye vs right eye</td></tr>
                            <tr><td>Two independent groups with unequal or unknown variances</td><td style="font-weight:600;">Welch</td><td>Default choice when unsure about equal variances</td></tr>
                        </tbody>
                    </table>
        
                    <div style="margin-top:1rem;padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border-left:3px solid var(--info);">
                        <p style="margin:0;font-size:0.875rem;color:var(--text-secondary);line-height:1.6;">
                            <strong>Tip:</strong> When in doubt, use the <strong>Welch t-test</strong>. It is robust to unequal variances and performs well even when variances are actually equal.
                        </p>
                    </div>
                </div>
        
                <!-- 4. Interpreting Results -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Interpreting Results</h2>
        
                    <div class="stat-edu-grid">
                        <div class="stat-edu-card stat-anim stat-anim-d1">
                            <h4>&#x2705; Significant Result</h4>
                            <p>When p &lt; &alpha;, reject the null hypothesis. The observed difference is unlikely due to random chance alone. Report the t-statistic, df, and p-value.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d2">
                            <h4>&#x274C; Not Significant</h4>
                            <p>When p &ge; &alpha;, fail to reject the null hypothesis. There is insufficient evidence of a significant difference. This does <em>not</em> prove the groups are equal.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d3">
                            <h4>&#x1F4CF; Effect Size (Cohen&rsquo;s d)</h4>
                            <p>Small: d &asymp; 0.2, Medium: d &asymp; 0.5, Large: d &asymp; 0.8. A significant p-value with tiny d may lack practical importance.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d4">
                            <h4>&#x2194;&#xFE0F; Confidence Interval</h4>
                            <p>The CI for the mean difference shows the range of plausible values. If it excludes zero, the result is significant at that confidence level.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 5. Assumptions & When to Use Alternatives -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Assumptions &amp; When to Use Alternatives</h2>
        
                    <div style="margin-bottom:1rem;">
                        <ul style="list-style:none;padding:0;">
                            <li style="padding:0.5rem 0;border-bottom:1px solid var(--border);font-size:0.875rem;color:var(--text-secondary);display:flex;align-items:flex-start;gap:0.5rem;">
                                <span style="color:var(--tool-primary);font-weight:600;flex-shrink:0;">1.</span>
                                <span><strong>Normality:</strong> Data should be approximately normally distributed, or sample size should be large enough (n &ge; 30) for the Central Limit Theorem to apply.</span>
                            </li>
                            <li style="padding:0.5rem 0;border-bottom:1px solid var(--border);font-size:0.875rem;color:var(--text-secondary);display:flex;align-items:flex-start;gap:0.5rem;">
                                <span style="color:var(--tool-primary);font-weight:600;flex-shrink:0;">2.</span>
                                <span><strong>Independence:</strong> Observations must be independent of each other (except in paired tests where pairs are dependent but differences are independent).</span>
                            </li>
                            <li style="padding:0.5rem 0;border-bottom:1px solid var(--border);font-size:0.875rem;color:var(--text-secondary);display:flex;align-items:flex-start;gap:0.5rem;">
                                <span style="color:var(--tool-primary);font-weight:600;flex-shrink:0;">3.</span>
                                <span><strong>Equal Variances:</strong> The two-sample t-test assumes equal variances. Use Welch&rsquo;s t-test if this assumption is violated.</span>
                            </li>
                            <li style="padding:0.5rem 0;font-size:0.875rem;color:var(--text-secondary);display:flex;align-items:flex-start;gap:0.5rem;">
                                <span style="color:var(--tool-primary);font-weight:600;flex-shrink:0;">4.</span>
                                <span><strong>Continuous Data:</strong> T-tests are designed for continuous (interval or ratio) data, not ordinal or categorical data.</span>
                            </li>
                        </ul>
                    </div>
        
                    <div style="padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border-left:3px solid var(--warning);">
                        <p style="margin:0;font-size:0.875rem;color:var(--text-secondary);line-height:1.6;">
                            <strong>Non-parametric alternatives:</strong> If your data violates normality with small samples, consider the <strong>Mann-Whitney U test</strong> (for independent samples) or <strong>Wilcoxon signed-rank test</strong> (for paired samples). For comparing more than two groups, use <strong>ANOVA</strong> instead.
                        </p>
                    </div>
                </div>
        
                <!-- 6. FAQ -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
                    <div class="faq-item">
                        <button class="faq-question">Which t-test should I use?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Use one-sample to compare a mean to a known value. Use independent two-sample when groups are unrelated with similar variances. Use paired for before/after or matched data. Use Welch when group variances differ or you are unsure about equal variances.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What does the p-value tell me?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">The p-value is the probability of observing data as extreme as yours if the null hypothesis is true. A small p-value below alpha suggests the data is unlikely under the null, so you reject it.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What is Cohen&rsquo;s d and why does it matter?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Cohen&rsquo;s d measures effect size, or practical significance. A statistically significant result with tiny d may not be meaningful. Small d is about 0.2, medium about 0.5, and large about 0.8.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What are the assumptions of a t-test?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Data should be approximately normal or sample size large enough for CLT. Observations must be independent. Two-sample tests assume equal variances unless using Welch. Paired tests assume the differences are normally distributed.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">How do I choose between one-tailed and two-tailed?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Use two-tailed when you want to detect a difference in either direction. Use one-tailed only when you have a strong prior hypothesis about the direction of the effect before collecting data.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">When is a t-test not appropriate?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Avoid t-tests with very small non-normal samples or heavily skewed data. Use non-parametric alternatives like Mann-Whitney U or Wilcoxon signed-rank test. For more than two groups, use ANOVA instead.</div>
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
    <script src="<%=request.getContextPath()%>/js/t-test-core.js?v=<%=v%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/categories-menu.js" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=v%>" defer></script>

<script>window.__MS_STAT_PAGE__ = { key: 't-test', label: "T-Test Calculator" };</script>
<%
    request.setAttribute("mathAiButtonId", "btnMathAI");
    request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
    request.setAttribute("mathAiProfileExport", "configureStatisticsMathShell");
%>
<%@ include file="modern/components/math-ai-boot.inc.jsp" %>
</body>
</html>

