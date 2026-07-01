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
        <jsp:param name="toolName" value="P-Value Calculator Online - Z T Chi-Square F Test Free" />
        <jsp:param name="toolDescription" value="Calculate p-values from Z-score t-statistic chi-square and F-test statistics. One-tailed and two-tailed tests with distribution visualization and Python export." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="p-value-calculator.jsp" />
        <jsp:param name="toolKeywords" value="p-value calculator, p value, statistical significance, z-score to p-value, t-test p-value, chi-square p-value, f-test p-value, hypothesis testing, one-tailed test, two-tailed test" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Z-test p-value from Z-score,T-test p-value with degrees of freedom,Chi-square test p-value,F-test p-value with numerator and denominator df,Left-tailed right-tailed and two-tailed tests,Significance level classification,Interactive Plotly distribution visualization,Python scipy code generation" />
        <jsp:param name="teaches" value="P-values, statistical significance, hypothesis testing, Z-distribution, t-distribution, chi-square distribution, F-distribution, one-tailed vs two-tailed tests" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Choose Test Type|Select Z-test T-test Chi-square or F-test,Set Tail Type|Pick left-tailed two-tailed or right-tailed test,Enter Test Statistic|Input your Z t chi-square or F value and degrees of freedom,Click Calculate|Get instant p-value with significance classification,View Distribution|See the distribution curve with shaded rejection region,Export Code|Run Python scipy code in the embedded compiler" />
        <jsp:param name="faq1q" value="What is a p-value and how do I interpret it?" />
        <jsp:param name="faq1a" value="A p-value is the probability of observing results at least as extreme as the data assuming the null hypothesis is true. A small p-value like less than 0.05 provides evidence against the null hypothesis. It is NOT the probability that the null hypothesis is true." />
        <jsp:param name="faq2q" value="When should I use one-tailed versus two-tailed test?" />
        <jsp:param name="faq2a" value="Use a one-tailed test when you have a directional hypothesis like the mean is greater than a value. Use two-tailed when you test for any difference in either direction. The choice must be made before looking at the data." />
        <jsp:param name="faq3q" value="Which distribution should I use for my test?" />
        <jsp:param name="faq3a" value="Use Z for large samples with known sigma. Use t for small samples with unknown sigma. Use chi-square for goodness of fit and independence tests. Use F for comparing variances or ANOVA." />
        <jsp:param name="faq4q" value="What are common significance levels?" />
        <jsp:param name="faq4a" value="The most common is alpha equals 0.05 or 95 percent confidence. For high stakes decisions use 0.01. For exploratory research 0.10 is sometimes used. The threshold should be chosen before conducting the test." />
        <jsp:param name="faq5q" value="Does a small p-value prove practical significance?" />
        <jsp:param name="faq5a" value="No. Statistical significance does not equal practical significance. A large sample can produce a tiny p-value for a trivially small effect. Always report effect sizes alongside p-values to assess real-world importance." />
        <jsp:param name="faq6q" value="What are common misconceptions about p-values?" />
        <jsp:param name="faq6a" value="Common mistakes include thinking p is the probability H0 is true or that 1 minus p is the probability H1 is true or that a non-significant result proves no effect exists. The p-value only measures evidence against H0 under the assumption H0 is true." />
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

    <% request.setAttribute("activeService", "p-value"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <span aria-current="page">P-Value</span>
            </nav>
            <h1>P-Value Calculator</h1>
            <p class="ms-subtitle">Z · t · χ² · F tests · distribution shading</p>
        </header>

        <div class="ic-stack">

            <div class="ic-hero ic-hero--compact stat-hero" id="stat-hero">
                <div class="ic-hero-top">
                    <button type="button" class="math-ai-tab-btn" id="btnMathAI" title="Math AI — statistics tutor + full math router in chat (Ctrl+Shift+A)">&#10024; AI</button>
                </div>
                <div class="stat-hero-core">
                    <!-- Test Type Toggle -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label">Test Type</label>
                                            <div class="stat-mode-toggle" style="display:flex;flex-wrap:wrap;">
                                                <button type="button" class="stat-mode-btn active" data-mode="z" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Z-Test</button>
                                                <button type="button" class="stat-mode-btn" data-mode="t" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">T-Test</button>
                                                <button type="button" class="stat-mode-btn" data-mode="chi" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Chi-Square</button>
                                                <button type="button" class="stat-mode-btn" data-mode="f" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">F-Test</button>
                                            </div>
                                        </div>
                    
                                        <!-- Tail Type Toggle -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label">Tail Type</label>
                                            <div class="stat-mode-toggle" style="display:flex;">
                                                <button type="button" class="stat-mode-btn" data-tail="left" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Left</button>
                                                <button type="button" class="stat-mode-btn active" data-tail="two" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Two-Tailed</button>
                                                <button type="button" class="stat-mode-btn" data-tail="right" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Right</button>
                                            </div>
                                        </div>
                    
                                        <!-- Z-Test inputs -->
                                        <div id="pv-input-z">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="pv-z-score">Z-Score</label>
                                                <input type="number" class="stat-input-text" id="pv-z-score" value="1.96" step="0.01">
                                                <div class="tool-form-hint">Standard normal test statistic</div>
                                            </div>
                                        </div>
                    
                                        <!-- T-Test inputs -->
                                        <div id="pv-input-t" style="display:none;">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="pv-t-stat">T-Statistic</label>
                                                <input type="number" class="stat-input-text" id="pv-t-stat" value="2.5" step="0.01">
                                            </div>
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="pv-t-df">Degrees of Freedom</label>
                                                <input type="number" class="stat-input-text" id="pv-t-df" value="20" step="1" min="1">
                                                <div class="tool-form-hint">Typically n &minus; 1 for one-sample t-test</div>
                                            </div>
                                        </div>
                    
                                        <!-- Chi-Square inputs -->
                                        <div id="pv-input-chi" style="display:none;">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="pv-chi-stat">&chi;&sup2; Statistic</label>
                                                <input type="number" class="stat-input-text" id="pv-chi-stat" value="5.99" step="0.01" min="0">
                                            </div>
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="pv-chi-df">Degrees of Freedom</label>
                                                <input type="number" class="stat-input-text" id="pv-chi-df" value="2" step="1" min="1">
                                                <div class="tool-form-hint">Number of categories minus 1</div>
                                            </div>
                                        </div>
                    
                                        <!-- F-Test inputs -->
                                        <div id="pv-input-f" style="display:none;">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="pv-f-stat">F-Statistic</label>
                                                <input type="number" class="stat-input-text" id="pv-f-stat" value="3.5" step="0.01" min="0">
                                            </div>
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="pv-f-df1">DF Numerator</label>
                                                <input type="number" class="stat-input-text" id="pv-f-df1" value="3" step="1" min="1">
                                                <div class="tool-form-hint">Between-group degrees of freedom</div>
                                            </div>
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="pv-f-df2">DF Denominator</label>
                                                <input type="number" class="stat-input-text" id="pv-f-df2" value="20" step="1" min="1">
                                                <div class="tool-form-hint">Within-group degrees of freedom</div>
                                            </div>
                                        </div>
                    
                                        <!-- Buttons -->
                                        <button type="button" class="tool-action-btn" id="pv-calc-btn">Calculate P-Value</button>
                                        <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                                            <button type="button" class="tool-action-btn" id="pv-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                                        </div>
                    
                                        <hr class="stat-sep">
                    
                                        <!-- Quick Examples -->
                                        <div class="tool-form-group" id="pv-examples">
                                            <label class="tool-form-label">Quick Examples</label>
                                            <div class="stat-examples">
                                                <button type="button" class="stat-example-chip" data-example="z-critical">Z = 1.96</button>
                                                <button type="button" class="stat-example-chip" data-example="t-small">T-Test (df=20)</button>
                                                <button type="button" class="stat-example-chip" data-example="chi-gof">Chi-Square GOF</button>
                                                <button type="button" class="stat-example-chip" data-example="f-anova">F-Test (ANOVA)</button>
                                            </div>
                                        </div>
                                    </div>
                </div>
            </div>

            <div class="ic-result-card">
                <div class="stat-output-tabs">
                                <button type="button" class="stat-output-tab active" data-tab="pv-result-panel">Result</button>
                                <button type="button" class="stat-output-tab" data-tab="pv-graph-panel">Distribution</button>
                                <button type="button" class="stat-output-tab" data-tab="pv-compiler-panel">Python Compiler</button>
                            </div>
                
                            <div class="stat-panel active" id="pv-result-panel">
                                <div class="tool-card tool-result-card">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                                        <h4>Result</h4>
                                    </div>
                                    <div class="tool-result-content" id="pv-result-content">
                                        <div class="tool-empty-state">
                                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F4CA;</div>
                                            <h3>Enter parameters and click Calculate</h3>
                                            <p>Compute p-values for Z, T, Chi-square, or F test statistics.</p>
                                        </div>
                                    </div>
                                    <div class="tool-result-actions" id="pv-result-actions"></div>
                                </div>
                            </div>
                
                            <div class="stat-panel" id="pv-graph-panel">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><path d="M3 3v18h18"/><path d="M7 16l4-8 4 4 4-6"/></svg>
                                        <h4>Distribution Visualization</h4>
                                    </div>
                                    <div style="flex:1;padding:1rem;min-height:300px;">
                                        <div id="pv-graph-container"></div>
                                    </div>
                                </div>
                            </div>
                
                            <div class="stat-panel" id="pv-compiler-panel">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                                        <h4>Python Compiler</h4>
                                    </div>
                                    <div style="flex:1;min-height:0;">
                                        <iframe id="pv-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                                    </div>
                                </div>
                            </div>
            </div>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
        </div>

<jsp:include page="modern/components/related-tools.jsp">
<jsp:param name="currentToolUrl" value="p-value-calculator.jsp"/>
        <jsp:param name="keyword" value="statistics"/>
        <jsp:param name="limit" value="6"/>
</jsp:include>

        <section class="tool-expertise-section ms-below-fold" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
        
                <!-- 1. What Is a P-Value? -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Is a P-Value?</h2>
                    <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">A <strong>p-value</strong> is the probability of observing a test statistic at least as extreme as the one computed from sample data, assuming the null hypothesis (H&#8320;) is true. It is a fundamental concept in <strong>hypothesis testing</strong> and helps researchers decide whether to reject H&#8320;.</p>
        
                    <!-- Animated SVG: Bell curve with shaded tails -->
                    <div style="text-align:center;margin:1.5rem 0;">
                        <svg viewBox="0 0 400 120" style="max-width:420px;width:100%;" aria-label="Bell curve with shaded rejection region">
                            <!-- Axis -->
                            <line x1="20" y1="100" x2="380" y2="100" stroke="var(--border-dark,#cbd5e1)" stroke-width="1.5"/>
                            <!-- Bell curve -->
                            <path d="M20,100 Q60,98 100,90 Q140,60 160,35 Q180,12 200,8 Q220,12 240,35 Q260,60 300,90 Q340,98 380,100" fill="none" stroke="var(--text-secondary,#475569)" stroke-width="2.5" class="stat-anim stat-anim-d1"/>
                            <!-- Right tail shading -->
                            <path d="M300,90 Q340,98 380,100 L380,100 L300,100 Z" fill="#e11d48" opacity="0.3" class="stat-anim stat-anim-d2"/>
                            <!-- Left tail shading -->
                            <path d="M20,100 Q60,98 100,90 L100,100 L20,100 Z" fill="#e11d48" opacity="0.3" class="stat-anim stat-anim-d2"/>
                            <!-- Critical value markers -->
                            <line x1="100" y1="90" x2="100" y2="105" stroke="#e11d48" stroke-width="2" stroke-dasharray="3,2" class="stat-anim stat-anim-d3"/>
                            <line x1="300" y1="90" x2="300" y2="105" stroke="#e11d48" stroke-width="2" stroke-dasharray="3,2" class="stat-anim stat-anim-d3"/>
                            <!-- Labels -->
                            <text x="200" y="75" text-anchor="middle" font-size="10" fill="var(--text-muted,#94a3b8)">Fail to reject H&#8320;</text>
                            <text x="55" y="88" text-anchor="middle" font-size="9" fill="#e11d48" font-weight="600">p/2</text>
                            <text x="345" y="88" text-anchor="middle" font-size="9" fill="#e11d48" font-weight="600">p/2</text>
                            <text x="100" y="116" text-anchor="middle" font-size="9" fill="var(--text-secondary,#475569)">&minus;z*</text>
                            <text x="300" y="116" text-anchor="middle" font-size="9" fill="var(--text-secondary,#475569)">+z*</text>
                            <text x="200" y="116" text-anchor="middle" font-size="9" fill="var(--text-muted,#94a3b8)">0</text>
                        </svg>
                    </div>
        
                    <div class="stat-edu-grid" style="margin-top:1rem;">
                        <div class="stat-feature-card stat-anim stat-anim-d1">
                            <div style="font-size:1.5rem;">&#x1F4CF;</div>
                            <h4>Probability Measure</h4>
                            <p>The p-value quantifies how likely observed data (or more extreme) would occur if H&#8320; were true. Ranges from 0 to 1.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d2">
                            <div style="font-size:1.5rem;">&#x2696;&#xFE0F;</div>
                            <h4>Evidence Against H&#8320;</h4>
                            <p>A smaller p-value provides stronger evidence against the null hypothesis. It does NOT measure the probability that H&#8320; is true.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d3">
                            <div style="font-size:1.5rem;">&#x1F3AF;</div>
                            <h4>Decision Tool</h4>
                            <p>Compare p-value to significance level &alpha;. If p &le; &alpha;, reject H&#8320;. Common thresholds: 0.05, 0.01, 0.10.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 2. P-Value Interpretation Guide -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">P-Value Interpretation Guide</h2>
                    <p style="color:var(--text-secondary);margin-bottom:1.25rem;line-height:1.7;">The significance of a p-value depends on the chosen &alpha; level. Below are commonly used thresholds and their interpretations.</p>
        
                    <div class="stat-edu-grid" style="grid-template-columns:repeat(auto-fit,minmax(200px,1fr));">
                        <div class="stat-feature-card stat-anim stat-anim-d1" style="border-left:4px solid #10b981;">
                            <h4 style="color:#10b981;">p &lt; 0.001</h4>
                            <p><strong>Highly Significant</strong> &mdash; Very strong evidence against the null hypothesis. Often denoted with *** in research papers.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d2" style="border-left:4px solid #3b82f6;">
                            <h4 style="color:#3b82f6;">p &lt; 0.05</h4>
                            <p><strong>Significant</strong> &mdash; Sufficient evidence to reject H&#8320; at the standard 5% level. The most common threshold in science.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d3" style="border-left:4px solid #f59e0b;">
                            <h4 style="color:#f59e0b;">p &lt; 0.10</h4>
                            <p><strong>Marginal</strong> &mdash; Weak evidence against H&#8320;. Sometimes called &ldquo;trending toward significance.&rdquo; Use with caution.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d4" style="border-left:4px solid #94a3b8;">
                            <h4 style="color:#94a3b8;">p &ge; 0.10</h4>
                            <p><strong>Not Significant</strong> &mdash; Insufficient evidence to reject H&#8320;. Does not prove H&#8320; is true, only that data is consistent with it.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 3. Test Distributions -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Test Distributions</h2>
        
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>Z-Test:</strong>&nbsp; p = P(Z &ge; |z|) for standard normal. Used when &sigma; is known or n is large (&ge;30).
                    </div>
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>T-Test:</strong>&nbsp; p = P(T &ge; |t|) with df = n &minus; 1. Used when &sigma; is unknown and sample is small.
                    </div>
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>Chi-Square:</strong>&nbsp; p = P(&chi;&sup2; &ge; x&sup2;) with df = k &minus; 1. Used for goodness-of-fit and independence tests.
                    </div>
                    <div class="stat-formula-box">
                        <strong>F-Test:</strong>&nbsp; p = P(F &ge; f) with df&#8321; and df&#8322;. Used for ANOVA and comparing two variances.
                    </div>
        
                    <table class="stat-ops-table" style="margin-top:1.25rem;">
                        <thead><tr><th>Distribution</th><th>Parameters</th><th>Common Use</th></tr></thead>
                        <tbody>
                            <tr><td style="font-weight:600;">Z (Normal)</td><td>None (standard)</td><td>Large samples, known &sigma;, proportions</td></tr>
                            <tr><td style="font-weight:600;">t (Student&rsquo;s)</td><td>df = n &minus; 1</td><td>Small samples, unknown &sigma;</td></tr>
                            <tr><td style="font-weight:600;">&chi;&sup2; (Chi-square)</td><td>df = k &minus; 1</td><td>Categorical data, goodness-of-fit</td></tr>
                            <tr><td style="font-weight:600;">F (Fisher)</td><td>df&#8321;, df&#8322;</td><td>ANOVA, variance comparison</td></tr>
                        </tbody>
                    </table>
                </div>
        
                <!-- 4. One-Tailed vs Two-Tailed Tests -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">One-Tailed vs Two-Tailed Tests</h2>
        
                    <div style="display:grid;grid-template-columns:1fr 1fr;gap:1.5rem;margin:1.5rem 0;">
                        <!-- One-Tailed SVG -->
                        <div style="text-align:center;">
                            <svg viewBox="0 0 200 100" style="max-width:200px;width:100%;" aria-label="One-tailed test with right tail shaded">
                                <line x1="10" y1="85" x2="190" y2="85" stroke="var(--border-dark,#cbd5e1)" stroke-width="1"/>
                                <path d="M10,85 Q30,83 55,75 Q80,50 90,30 Q95,15 100,10 Q105,15 110,30 Q120,50 145,75 Q170,83 190,85" fill="none" stroke="var(--text-secondary,#475569)" stroke-width="2" class="stat-anim stat-anim-d1"/>
                                <path d="M145,75 Q170,83 190,85 L190,85 L145,85 Z" fill="#e11d48" opacity="0.35" class="stat-anim stat-anim-d2"/>
                                <text x="100" y="98" text-anchor="middle" font-size="9" fill="var(--text-secondary,#475569)">One-Tailed (right)</text>
                                <text x="168" y="72" text-anchor="middle" font-size="8" fill="#e11d48" font-weight="600">&alpha;</text>
                            </svg>
                        </div>
                        <!-- Two-Tailed SVG -->
                        <div style="text-align:center;">
                            <svg viewBox="0 0 200 100" style="max-width:200px;width:100%;" aria-label="Two-tailed test with both tails shaded">
                                <line x1="10" y1="85" x2="190" y2="85" stroke="var(--border-dark,#cbd5e1)" stroke-width="1"/>
                                <path d="M10,85 Q30,83 55,75 Q80,50 90,30 Q95,15 100,10 Q105,15 110,30 Q120,50 145,75 Q170,83 190,85" fill="none" stroke="var(--text-secondary,#475569)" stroke-width="2" class="stat-anim stat-anim-d1"/>
                                <path d="M145,75 Q170,83 190,85 L190,85 L145,85 Z" fill="#e11d48" opacity="0.35" class="stat-anim stat-anim-d2"/>
                                <path d="M10,85 Q30,83 55,75 L55,85 L10,85 Z" fill="#e11d48" opacity="0.35" class="stat-anim stat-anim-d2"/>
                                <text x="100" y="98" text-anchor="middle" font-size="9" fill="var(--text-secondary,#475569)">Two-Tailed</text>
                                <text x="32" y="72" text-anchor="middle" font-size="8" fill="#e11d48" font-weight="600">&alpha;/2</text>
                                <text x="168" y="72" text-anchor="middle" font-size="8" fill="#e11d48" font-weight="600">&alpha;/2</text>
                            </svg>
                        </div>
                    </div>
        
                    <div class="stat-edu-grid">
                        <div class="stat-edu-card stat-anim stat-anim-d1">
                            <h4>One-Tailed (Directional)</h4>
                            <p>Tests for an effect in a <em>specific direction</em> (e.g., mean is <strong>greater than</strong> or <strong>less than</strong> a value). All &alpha; is concentrated in one tail, giving more power for that direction.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d2">
                            <h4>Two-Tailed (Non-directional)</h4>
                            <p>Tests for any difference in <em>either direction</em>. The &alpha; is split between both tails (&alpha;/2 each). More conservative but appropriate when the direction is not pre-specified.</p>
                        </div>
                    </div>
        
                    <div style="margin-top:1rem;padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border-left:3px solid var(--warning);">
                        <p style="margin:0;font-size:0.875rem;color:var(--text-secondary);line-height:1.6;">
                            <strong>Important:</strong> The choice between one-tailed and two-tailed tests must be made <em>before</em> looking at the data. Choosing after seeing results inflates the false positive rate.
                        </p>
                    </div>
                </div>
        
                <!-- 5. Common Misconceptions -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Common Misconceptions About P-Values</h2>
        
                    <div class="stat-edu-grid">
                        <div class="stat-edu-card stat-anim stat-anim-d1">
                            <h4>&#x274C; &ldquo;P is the probability H&#8320; is true&rdquo;</h4>
                            <p><strong>Incorrect.</strong> The p-value is the probability of the <em>data</em> (or more extreme) given H&#8320; is true. It is P(data | H&#8320;), not P(H&#8320; | data). Bayesian methods are needed for the latter.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d2">
                            <h4>&#x274C; &ldquo;1 &minus; p = probability H&#8321; is true&rdquo;</h4>
                            <p><strong>Incorrect.</strong> A p-value of 0.03 does not mean there is a 97% chance the alternative is true. The p-value tells you about the data under H&#8320;, not the probability of any hypothesis.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d3">
                            <h4>&#x274C; &ldquo;Not significant = no effect&rdquo;</h4>
                            <p><strong>Incorrect.</strong> Failure to reject H&#8320; does not prove H&#8320;. It may simply mean the sample size was too small to detect the effect. &ldquo;Absence of evidence is not evidence of absence.&rdquo;</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d4">
                            <h4>&#x2705; Correct Interpretation</h4>
                            <p><strong>Correct:</strong> &ldquo;Assuming H&#8320; is true, the probability of observing a test statistic as extreme as or more extreme than the one observed is p.&rdquo; Always interpret in context.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 6. Frequently Asked Questions -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
                    <div class="faq-item">
                        <button class="faq-question">What is a p-value and how do I interpret it?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">A p-value is the probability of observing results at least as extreme as the data, assuming the null hypothesis is true. A small p-value (e.g., less than 0.05) provides evidence against the null hypothesis. It is <em>not</em> the probability that the null hypothesis is true.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">When should I use one-tailed versus two-tailed test?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Use a one-tailed test when you have a directional hypothesis (e.g., the mean is greater than a value). Use two-tailed when you test for any difference in either direction. The choice must be made before looking at the data.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">Which distribution should I use for my test?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Use Z for large samples with known &sigma;. Use t for small samples with unknown &sigma;. Use chi-square for goodness-of-fit and independence tests. Use F for comparing variances or ANOVA.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What are common significance levels?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">The most common is &alpha; = 0.05 (95% confidence). For high-stakes decisions, use 0.01. For exploratory research, 0.10 is sometimes used. The threshold should be chosen before conducting the test.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">Does a small p-value prove practical significance?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">No. Statistical significance does not equal practical significance. A large sample can produce a tiny p-value for a trivially small effect. Always report effect sizes alongside p-values to assess real-world importance.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What are common misconceptions about p-values?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Common mistakes include thinking p is the probability H&#8320; is true, or that 1 &minus; p is the probability H&#8321; is true, or that a non-significant result proves no effect exists. The p-value only measures evidence against H&#8320; under the assumption H&#8320; is true.</div>
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
    <script src="<%=request.getContextPath()%>/js/p-value-core.js?v=<%=v%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/categories-menu.js" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=v%>" defer></script>

<script>window.__MS_STAT_PAGE__ = { key: 'p-value', label: "P-Value Calculator" };</script>
<%
    request.setAttribute("mathAiButtonId", "btnMathAI");
    request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
    request.setAttribute("mathAiProfileExport", "configureStatisticsMathShell");
%>
<%@ include file="modern/components/math-ai-boot.inc.jsp" %>
</body>
</html>
