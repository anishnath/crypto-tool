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
        <jsp:param name="toolName" value="Chi-Square Calculator Online - Independence Goodness of Fit Free" />
        <jsp:param name="toolDescription" value="Perform chi-square test of independence and goodness of fit. Compute chi-square statistic expected frequencies p-value degrees of freedom critical value Cramers V with distribution chart and Python scipy export." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="chi-square-calculator.jsp" />
        <jsp:param name="toolKeywords" value="chi-square calculator, chi square test, test of independence, goodness of fit, contingency table calculator, chi-square statistic, expected frequency, cramers v, categorical data analysis, chi-square distribution" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Chi-square test of independence with contingency table,Goodness of fit test for categorical distributions,Dynamic 2x2 to 5x5 contingency table,Expected frequency calculation,P-value and critical value,Cramers V effect size,Cell contribution analysis,Interactive Plotly chi-square distribution chart,Python scipy code generation" />
        <jsp:param name="teaches" value="Chi-square test, contingency tables, categorical data analysis, expected frequencies, goodness of fit, Cramers V" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Choose Test Type|Select test of independence or goodness of fit,Enter Data|Fill contingency table or enter observed and expected frequencies,Set Significance Level|Choose alpha at 0.01 or 0.05 or 0.10,Click Calculate|Get chi-square statistic p-value df and effect size,View Distribution|See chi-square distribution with rejection region,Export Code|Run Python scipy code in the embedded compiler" />
        <jsp:param name="faq1q" value="When should I use a chi-square test?" />
        <jsp:param name="faq1a" value="Use chi-square test of independence to check if two categorical variables are associated. Use goodness of fit to test if observed frequencies match an expected distribution like equal proportions or Mendelian ratios." />
        <jsp:param name="faq2q" value="What are expected frequencies and how are they calculated?" />
        <jsp:param name="faq2a" value="For independence tests expected frequency equals row total times column total divided by grand total. For goodness of fit it is total times the hypothesized proportion for each category." />
        <jsp:param name="faq3q" value="What does Cramers V measure?" />
        <jsp:param name="faq3a" value="Cramers V measures the strength of association between categorical variables ranging from 0 to 1. Values around 0.1 are small 0.3 medium and 0.5 or above large effect sizes." />
        <jsp:param name="faq4q" value="What is the minimum sample size for chi-square?" />
        <jsp:param name="faq4a" value="The rule of thumb is that expected frequencies should be at least 5 in 80 percent of cells and no cell should have expected frequency below 1. With very small expected counts consider Fisher exact test." />
        <jsp:param name="faq5q" value="Can I use chi-square for continuous data?" />
        <jsp:param name="faq5a" value="No chi-square tests are for categorical or count data only. For continuous data use t-tests ANOVA or correlation. You can bin continuous data into categories but this loses information." />
        <jsp:param name="faq6q" value="What if my contingency table has more than two variables?" />
        <jsp:param name="faq6a" value="Standard chi-square tests handle two variables. For three or more variables use log-linear models or stratified analysis like the Cochran-Mantel-Haenszel test." />
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

    <% request.setAttribute("activeService", "chi-square"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <span aria-current="page">Chi-Square</span>
            </nav>
            <h1>Chi-Square Calculator</h1>
            <p class="ms-subtitle">Goodness of fit · independence · χ² distribution</p>
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
                                                <button type="button" class="stat-mode-btn active" id="chi-mode-independence" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Independence</button>
                                                <button type="button" class="stat-mode-btn" id="chi-mode-goodness" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Goodness of Fit</button>
                                            </div>
                                        </div>
                    
                                        <!-- Significance Level -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label" for="chi-alpha">Significance Level (&alpha;)</label>
                                            <select class="stat-input-text" id="chi-alpha" style="width:100%;padding:0.5rem;border:1.5px solid var(--border);border-radius:0.5rem;font-size:0.8125rem;font-family:var(--font-sans);background:var(--bg-primary);color:var(--text-primary);">
                                                <option value="0.01">0.01</option>
                                                <option value="0.05" selected>0.05</option>
                                                <option value="0.10">0.10</option>
                                            </select>
                                        </div>
                    
                                        <!-- Independence inputs -->
                                        <div id="chi-input-independence">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label">Table Dimensions</label>
                                                <div class="chi-dim-grid">
                                                    <div>
                                                        <label class="tool-form-label" for="chi-num-rows" style="font-size:0.6875rem;color:var(--text-secondary);">Rows</label>
                                                        <select class="stat-input-text" id="chi-num-rows" style="width:100%;padding:0.5rem;border:1.5px solid var(--border);border-radius:0.5rem;font-size:0.8125rem;font-family:var(--font-sans);background:var(--bg-primary);color:var(--text-primary);">
                                                            <option value="2" selected>2 rows</option>
                                                            <option value="3">3 rows</option>
                                                            <option value="4">4 rows</option>
                                                            <option value="5">5 rows</option>
                                                        </select>
                                                    </div>
                                                    <div>
                                                        <label class="tool-form-label" for="chi-num-cols" style="font-size:0.6875rem;color:var(--text-secondary);">Columns</label>
                                                        <select class="stat-input-text" id="chi-num-cols" style="width:100%;padding:0.5rem;border:1.5px solid var(--border);border-radius:0.5rem;font-size:0.8125rem;font-family:var(--font-sans);background:var(--bg-primary);color:var(--text-primary);">
                                                            <option value="2" selected>2 columns</option>
                                                            <option value="3">3 columns</option>
                                                            <option value="4">4 columns</option>
                                                            <option value="5">5 columns</option>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="tool-form-group">
                                                <div id="chi-table-container" class="chi-table-wrap"></div>
                                                <div class="tool-form-hint">Enter observed frequencies in each cell</div>
                                            </div>
                                        </div>
                    
                                        <!-- Goodness of Fit inputs -->
                                        <div id="chi-input-goodness" style="display:none;">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="chi-observed">Observed Frequencies</label>
                                                <textarea class="stat-input-text" id="chi-observed" rows="2" style="width:100%;padding:0.5rem;border:1.5px solid var(--border);border-radius:0.5rem;font-size:0.8125rem;font-family:var(--font-sans);background:var(--bg-primary);color:var(--text-primary);resize:vertical;">30, 20, 25, 25</textarea>
                                                <div class="tool-form-hint">Comma or space separated counts</div>
                                            </div>
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="chi-expected">Expected Frequencies (optional)</label>
                                                <textarea class="stat-input-text" id="chi-expected" rows="2" style="width:100%;padding:0.5rem;border:1.5px solid var(--border);border-radius:0.5rem;font-size:0.8125rem;font-family:var(--font-sans);background:var(--bg-primary);color:var(--text-primary);resize:vertical;">25, 25, 25, 25</textarea>
                                                <div class="tool-form-hint">Leave blank for equal expected frequencies</div>
                                            </div>
                                        </div>
                    
                                        <!-- Buttons -->
                                        <button type="button" class="tool-action-btn" id="chi-calc-btn">Calculate Chi-Square</button>
                                        <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                                            <button type="button" class="tool-action-btn" id="chi-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                                        </div>
                    
                                        <hr class="stat-sep">
                    
                                        <!-- Quick Examples -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label">Quick Examples</label>
                                            <div class="stat-examples" id="chi-examples">
                                                <button type="button" class="stat-example-chip" data-example="gender-product">Gender &amp; Product</button>
                                                <button type="button" class="stat-example-chip" data-example="survey-3x3">Survey 3x3</button>
                                                <button type="button" class="stat-example-chip" data-example="dice-roll">Dice Roll</button>
                                                <button type="button" class="stat-example-chip" data-example="coin-flip">Coin Flip</button>
                                            </div>
                                        </div>
                                    </div>
                </div>
            </div>

            <div class="ic-result-card">
                <div class="stat-output-tabs">
                                <button type="button" class="stat-output-tab active" data-tab="chi-result-panel">Result</button>
                                <button type="button" class="stat-output-tab" data-tab="chi-graph-panel">Distribution</button>
                                <button type="button" class="stat-output-tab" data-tab="chi-compiler-panel">Python Compiler</button>
                            </div>
                
                            <div class="stat-panel active" id="chi-result-panel">
                                <div class="tool-card tool-result-card">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                                        <h4>Result</h4>
                                    </div>
                                    <div class="tool-result-content" id="chi-result-content">
                                        <div class="tool-empty-state">
                                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F4CA;</div>
                                            <h3>Enter data and click Calculate</h3>
                                            <p>Compute chi-square statistic, p-value, degrees of freedom, and effect size.</p>
                                        </div>
                                    </div>
                                    <div class="tool-result-actions" id="chi-result-actions"></div>
                                </div>
                            </div>
                
                            <div class="stat-panel" id="chi-graph-panel">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><path d="M3 3v18h18"/><path d="M7 16l4-8 4 4 4-6"/></svg>
                                        <h4>Chi-Square Distribution</h4>
                                    </div>
                                    <div style="flex:1;padding:1rem;min-height:300px;">
                                        <div id="chi-graph-container"></div>
                                    </div>
                                </div>
                            </div>
                
                            <div class="stat-panel" id="chi-compiler-panel">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                                        <h4>Python Compiler</h4>
                                    </div>
                                    <div style="flex:1;min-height:0;">
                                        <iframe id="chi-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                                    </div>
                                </div>
                            </div>
            </div>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
        </div>

<jsp:include page="modern/components/related-tools.jsp">
<jsp:param name="currentToolUrl" value="chi-square-calculator.jsp"/>
        <jsp:param name="keyword" value="statistics"/>
        <jsp:param name="limit" value="6"/>
</jsp:include>

        <section class="tool-expertise-section ms-below-fold" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
        
                <!-- 1. What Is a Chi-Square Test? -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Is a Chi-Square Test?</h2>
                    <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">A <strong>chi-square test</strong> (&chi;&sup2;) is a statistical hypothesis test used to determine whether there is a significant association between categorical variables or whether observed frequencies differ from expected frequencies. It is one of the most widely used non-parametric tests in statistics.</p>
        
                    <!-- Animated SVG: Contingency table illustration -->
                    <div style="text-align:center;margin:1.5rem 0;">
                        <svg viewBox="0 0 400 120" style="max-width:400px;width:100%;" aria-label="Chi-square test illustration showing observed vs expected">
                            <rect x="30" y="10" width="160" height="100" rx="6" fill="none" stroke="var(--border-dark,#cbd5e1)" stroke-width="1.5"/>
                            <text x="110" y="30" text-anchor="middle" font-size="11" fill="var(--text-secondary,#475569)" font-weight="600">Observed (O)</text>
                            <text x="70" y="55" text-anchor="middle" font-size="18" fill="#e11d48" font-weight="700" class="stat-anim stat-anim-d1">30</text>
                            <text x="150" y="55" text-anchor="middle" font-size="18" fill="#e11d48" font-weight="700" class="stat-anim stat-anim-d2">20</text>
                            <text x="70" y="90" text-anchor="middle" font-size="18" fill="#e11d48" font-weight="700" class="stat-anim stat-anim-d3">10</text>
                            <text x="150" y="90" text-anchor="middle" font-size="18" fill="#e11d48" font-weight="700" class="stat-anim stat-anim-d4">40</text>
                            <line x1="110" y1="38" x2="110" y2="105" stroke="var(--border,#e2e8f0)" stroke-width="1"/>
                            <line x1="35" y1="68" x2="185" y2="68" stroke="var(--border,#e2e8f0)" stroke-width="1"/>
                            <text x="220" y="65" text-anchor="middle" font-size="22" fill="var(--text-muted,#94a3b8)" font-weight="700">vs</text>
                            <rect x="250" y="10" width="140" height="100" rx="6" fill="none" stroke="var(--border-dark,#cbd5e1)" stroke-width="1.5"/>
                            <text x="320" y="30" text-anchor="middle" font-size="11" fill="var(--text-secondary,#475569)" font-weight="600">Expected (E)</text>
                            <text x="290" y="55" text-anchor="middle" font-size="18" fill="var(--info,#3b82f6)" font-weight="700" class="stat-anim stat-anim-d2">24</text>
                            <text x="355" y="55" text-anchor="middle" font-size="18" fill="var(--info,#3b82f6)" font-weight="700" class="stat-anim stat-anim-d3">26</text>
                            <text x="290" y="90" text-anchor="middle" font-size="18" fill="var(--info,#3b82f6)" font-weight="700" class="stat-anim stat-anim-d4">16</text>
                            <text x="355" y="90" text-anchor="middle" font-size="18" fill="var(--info,#3b82f6)" font-weight="700" class="stat-anim stat-anim-d1">34</text>
                            <line x1="320" y1="38" x2="320" y2="105" stroke="var(--border,#e2e8f0)" stroke-width="1"/>
                            <line x1="255" y1="68" x2="385" y2="68" stroke="var(--border,#e2e8f0)" stroke-width="1"/>
                        </svg>
                    </div>
        
                    <div class="stat-edu-grid" style="margin-top:1rem;">
                        <div class="stat-feature-card stat-anim stat-anim-d1">
                            <div style="font-size:1.5rem;">&#x1F4CA;</div>
                            <h4>Categorical Analysis</h4>
                            <p>Analyze relationships between categorical variables such as gender, preference, treatment group, or survey response.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d2">
                            <div style="font-size:1.5rem;">&#x1F504;</div>
                            <h4>Expected vs Observed</h4>
                            <p>Compare what you observed in your data against what you would expect under the null hypothesis of no association.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d3">
                            <div style="font-size:1.5rem;">&#x2705;</div>
                            <h4>Statistical Significance</h4>
                            <p>Determine if the difference between observed and expected frequencies is large enough to reject the null hypothesis.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 2. Chi-Square Formula -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Chi-Square Formula</h2>
        
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>Chi-Square Statistic:</strong>&nbsp; &chi;&sup2; = &Sigma; (O &minus; E)&sup2; / E
                    </div>
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>Expected Frequency (Independence):</strong>&nbsp; E<sub>ij</sub> = (Row Total<sub>i</sub> &times; Column Total<sub>j</sub>) / Grand Total
                    </div>
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>Degrees of Freedom (Independence):</strong>&nbsp; df = (r &minus; 1)(c &minus; 1)
                    </div>
                    <div class="stat-formula-box">
                        <strong>Degrees of Freedom (Goodness of Fit):</strong>&nbsp; df = k &minus; 1 &nbsp;(k = number of categories)
                    </div>
        
                    <div class="stat-worked-example" style="margin-top:1rem;">
                        <strong>Worked Example:</strong> Gender &amp; Product Preference (2&times;2 contingency table)
                        <div style="margin-top:0.5rem;padding-left:1rem;border-left:3px solid var(--tool-primary);color:var(--text-secondary);font-size:0.875rem;">
                            Observed: [[30, 10], [20, 40]]&nbsp;&nbsp; Grand Total = 100<br>
                            E<sub>11</sub> = (40 &times; 50) / 100 = 20, &nbsp; E<sub>12</sub> = (40 &times; 50) / 100 = 20<br>
                            E<sub>21</sub> = (60 &times; 50) / 100 = 30, &nbsp; E<sub>22</sub> = (60 &times; 50) / 100 = 30<br>
                            &chi;&sup2; = (30&minus;20)&sup2;/20 + (10&minus;20)&sup2;/20 + (20&minus;30)&sup2;/30 + (40&minus;30)&sup2;/30 = 5 + 5 + 3.33 + 3.33 = <strong>16.67</strong><br>
                            df = (2&minus;1)(2&minus;1) = 1, &nbsp; p-value &lt; 0.001 &rarr; <strong>Reject H&#8320;</strong>
                        </div>
                    </div>
                </div>
        
                <!-- 3. Interpreting Results -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Interpreting Results</h2>
        
                    <div class="stat-edu-grid">
                        <div class="stat-edu-card stat-anim stat-anim-d1">
                            <h4>&#x274C; Reject H&#8320;</h4>
                            <p>When p-value &lt; &alpha;, the observed frequencies differ significantly from expected. There is a statistically significant association between the variables.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d2">
                            <h4>&#x2705; Fail to Reject H&#8320;</h4>
                            <p>When p-value &ge; &alpha;, there is insufficient evidence to conclude an association. The observed differences could be due to chance.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d3">
                            <h4>&#x1F4CF; Effect Size (Cram&eacute;r&rsquo;s V)</h4>
                            <p>Measures strength of association: V &asymp; 0.1 is small, V &asymp; 0.3 is medium, and V &ge; 0.5 indicates a large effect size.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d4">
                            <h4>&#x1F3AF; Practical Significance</h4>
                            <p>A statistically significant result may not be practically meaningful. Always consider effect size, sample size, and real-world context alongside the p-value.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 4. Assumptions & Limitations -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Assumptions &amp; Limitations</h2>
        
                    <ul style="color:var(--text-secondary);font-size:0.875rem;line-height:1.8;padding-left:1.25rem;">
                        <li><strong>Independence:</strong> Observations must be independent of each other. Each subject contributes to only one cell.</li>
                        <li><strong>Sample size rule:</strong> Expected frequencies should be at least 5 in 80% of cells, and no cell should have an expected frequency below 1.</li>
                        <li><strong>Categorical data:</strong> Variables must be categorical (nominal or ordinal). Chi-square is not appropriate for continuous data.</li>
                        <li><strong>Random sampling:</strong> Data should be obtained through random sampling from the population of interest.</li>
                    </ul>
        
                    <div style="margin-top:1rem;padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border-left:3px solid var(--warning);">
                        <p style="margin:0;font-size:0.875rem;color:var(--text-secondary);line-height:1.6;">
                            <strong>Tip:</strong> When expected frequencies are too small (especially in 2&times;2 tables), use <strong>Fisher&rsquo;s exact test</strong> instead. For ordinal data with a natural ordering, consider the Cochran-Armitage trend test.
                        </p>
                    </div>
                </div>
        
                <!-- 5. Applications -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Applications</h2>
        
                    <table class="stat-ops-table">
                        <thead><tr><th>Field</th><th>Example Use Case</th></tr></thead>
                        <tbody>
                            <tr><td style="font-weight:600;">Medicine</td><td>Test whether treatment outcome is associated with patient group</td></tr>
                            <tr><td style="font-weight:600;">Marketing</td><td>Analyze if product preference differs by demographic segment</td></tr>
                            <tr><td style="font-weight:600;">Genetics</td><td>Test if observed genotype ratios match Mendelian expected ratios</td></tr>
                            <tr><td style="font-weight:600;">Education</td><td>Determine if pass/fail rates differ across teaching methods</td></tr>
                            <tr><td style="font-weight:600;">Quality Control</td><td>Check if defect rates are independent of production line</td></tr>
                            <tr><td style="font-weight:600;">Social Sciences</td><td>Examine if voting preference is related to age group or region</td></tr>
                        </tbody>
                    </table>
                </div>
        
                <!-- 6. FAQ -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
                    <div class="faq-item">
                        <button class="faq-question">When should I use a chi-square test?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Use a chi-square test of independence to check if two categorical variables are associated. Use a goodness of fit test to determine if observed frequencies match an expected distribution, such as equal proportions or Mendelian ratios.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What are expected frequencies and how are they calculated?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">For independence tests, the expected frequency equals row total times column total divided by the grand total. For goodness of fit, it is the total count times the hypothesized proportion for each category.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What does Cram&eacute;r&rsquo;s V measure?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Cram&eacute;r&rsquo;s V measures the strength of association between categorical variables, ranging from 0 (no association) to 1 (perfect association). Values around 0.1 are considered small, 0.3 medium, and 0.5 or above large effect sizes.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What is the minimum sample size for chi-square?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">The rule of thumb is that expected frequencies should be at least 5 in 80% of cells and no cell should have an expected frequency below 1. With very small expected counts, consider Fisher&rsquo;s exact test instead.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">Can I use chi-square for continuous data?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">No, chi-square tests are for categorical or count data only. For continuous data, use t-tests, ANOVA, or correlation. You can bin continuous data into categories, but this loses information.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What if my contingency table has more than two variables?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Standard chi-square tests handle two variables. For three or more variables, use log-linear models or stratified analysis like the Cochran-Mantel-Haenszel test.</div>
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
    <script src="<%=request.getContextPath()%>/js/chi-square-core.js?v=<%=v%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/categories-menu.js" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=v%>" defer></script>

<script>window.__MS_STAT_PAGE__ = { key: 'chi-square', label: "Chi-Square Calculator" };</script>
<%
    request.setAttribute("mathAiButtonId", "btnMathAI");
    request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
    request.setAttribute("mathAiProfileExport", "configureStatisticsMathShell");
%>
<%@ include file="modern/components/math-ai-boot.inc.jsp" %>
</body>
</html>
