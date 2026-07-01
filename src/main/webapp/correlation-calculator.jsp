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
        <jsp:param name="toolName" value="Correlation Calculator Online - Pearson Spearman R-Squared Free" />
        <jsp:param name="toolDescription" value="Calculate Pearson and Spearman correlation coefficients with R-squared p-value significance test interactive scatter plot and Python export. Free online correlation analysis tool." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="correlation-calculator.jsp" />
        <jsp:param name="toolKeywords" value="correlation calculator, pearson correlation, spearman correlation, r squared calculator, correlation coefficient, scatter plot, p-value correlation, statistical correlation, rank correlation, data analysis" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Pearson linear correlation coefficient,Spearman rank correlation coefficient,Compare Pearson and Spearman side by side,R-squared coefficient of determination,Statistical significance p-value,Interactive Plotly scatter plot with trend line,Step-by-step KaTeX formulas,Python scipy code generation" />
        <jsp:param name="teaches" value="Correlation analysis, Pearson correlation, Spearman rank correlation, coefficient of determination, statistical significance, scatter plots, data relationships" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Choose Method|Select Pearson or Spearman or compare both,Enter X Data|Type or paste values for variable X one per line,Enter Y Data|Type or paste matching Y values one per line,Click Calculate|Get instant correlation coefficient with steps,View Scatter Plot|See the interactive Plotly chart with trend line,Export Code|Run Python scipy code in the embedded compiler" />
        <jsp:param name="faq1q" value="What is the difference between Pearson and Spearman correlation?" />
        <jsp:param name="faq1a" value="Pearson measures linear relationships between continuous variables. Spearman measures monotonic relationships using ranks and is more robust to outliers and non-normal distributions." />
        <jsp:param name="faq2q" value="How do I interpret the correlation coefficient r?" />
        <jsp:param name="faq2a" value="r ranges from -1 to +1. The sign shows direction and the magnitude shows strength. Values above 0.8 are very strong while values below 0.2 are very weak. Always visualize with a scatter plot." />
        <jsp:param name="faq3q" value="Does correlation imply causation?" />
        <jsp:param name="faq3a" value="No. A strong correlation does not prove that one variable causes the other. There could be confounding variables reverse causation or coincidence. Causation requires controlled experiments." />
        <jsp:param name="faq4q" value="What does R-squared tell me?" />
        <jsp:param name="faq4a" value="R-squared is the proportion of variance in Y explained by X. If r equals 0.8 then R-squared equals 0.64 meaning 64 percent of the variation in Y can be attributed to its linear relationship with X." />
        <jsp:param name="faq5q" value="When is a correlation statistically significant?" />
        <jsp:param name="faq5a" value="Significance depends on both the correlation magnitude and sample size. A p-value below 0.05 is the standard threshold. Large samples can make even small correlations statistically significant." />
        <jsp:param name="faq6q" value="What if my data has outliers?" />
        <jsp:param name="faq6a" value="Outliers can dramatically affect Pearson correlation. Use Spearman rank correlation which is robust to outliers or consider removing extreme values after careful investigation." />
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

    <% request.setAttribute("activeService", "correlation"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <span aria-current="page">Correlation</span>
            </nav>
            <h1>Correlation Calculator</h1>
            <p class="ms-subtitle">Pearson r · scatter plot · covariance</p>
        </header>

        <div class="ic-stack">

            <div class="ic-hero ic-hero--compact stat-hero" id="stat-hero">
                <div class="ic-hero-top">
                    <button type="button" class="math-ai-tab-btn" id="btnMathAI" title="Math AI — statistics tutor + full math router in chat (Ctrl+Shift+A)">&#10024; AI</button>
                </div>
                <div class="stat-hero-core">
                    <!-- Mode Toggle -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label">Method</label>
                                            <div class="stat-mode-toggle">
                                                <button type="button" class="stat-mode-btn active" id="corr-mode-pearson">Pearson</button>
                                                <button type="button" class="stat-mode-btn" id="corr-mode-spearman">Spearman</button>
                                                <button type="button" class="stat-mode-btn" id="corr-mode-both">Both</button>
                                            </div>
                                        </div>
                    
                                        <!-- Data inputs -->
                                        <div class="corr-data-grid">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="corr-x-data">Variable X</label>
                                                <textarea class="stat-input-text corr-input" id="corr-x-data" rows="6" placeholder="One value per line&#10;e.g.&#10;10&#10;20&#10;30"></textarea>
                                            </div>
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="corr-y-data">Variable Y</label>
                                                <textarea class="stat-input-text corr-input" id="corr-y-data" rows="6" placeholder="One value per line&#10;e.g.&#10;15&#10;28&#10;35"></textarea>
                                            </div>
                                        </div>
                                        <div class="tool-form-hint">Enter paired data &mdash; X and Y must have the same number of values (min 3)</div>
                    
                                        <!-- Buttons -->
                                        <button type="button" class="tool-action-btn" id="corr-calc-btn">Calculate Correlation</button>
                                        <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                                            <button type="button" class="tool-action-btn" id="corr-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                                        </div>
                    
                                        <hr class="stat-sep">
                    
                                        <!-- Quick Examples -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label">Quick Examples</label>
                                            <div class="stat-examples">
                                                <button type="button" class="stat-example-chip" data-corr-example="positive-strong">Strong +</button>
                                                <button type="button" class="stat-example-chip" data-corr-example="negative-strong">Strong &minus;</button>
                                                <button type="button" class="stat-example-chip" data-corr-example="weak">Weak</button>
                                                <button type="button" class="stat-example-chip" data-corr-example="nonlinear">Non-Linear</button>
                                            </div>
                                        </div>
                                    </div>
                </div>
            </div>

            <div class="ic-result-card">
                <div class="stat-output-tabs">
                                <button type="button" class="stat-output-tab active" data-tab="corr-result-panel">Result</button>
                                <button type="button" class="stat-output-tab" data-tab="corr-graph-panel">Scatter Plot</button>
                                <button type="button" class="stat-output-tab" data-tab="corr-compiler-panel">Python Compiler</button>
                            </div>
                
                            <div class="stat-panel active" id="corr-result-panel">
                                <div class="tool-card tool-result-card">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                                        <h4>Result</h4>
                                    </div>
                                    <div class="tool-result-content" id="corr-result-content">
                                        <div class="tool-empty-state">
                                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F4C8;</div>
                                            <h3>Enter paired data and click Calculate</h3>
                                            <p>Compute Pearson or Spearman correlation with significance testing.</p>
                                        </div>
                                    </div>
                                    <div class="tool-result-actions" id="corr-result-actions"></div>
                                </div>
                            </div>
                
                            <div class="stat-panel" id="corr-graph-panel">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><circle cx="7.5" cy="7.5" r="2"/><circle cx="16.5" cy="16.5" r="2"/><line x1="3" y1="21" x2="21" y2="3" stroke-dasharray="4"/></svg>
                                        <h4>Scatter Plot</h4>
                                    </div>
                                    <div style="flex:1;padding:1rem;min-height:350px;">
                                        <div id="corr-graph-container"></div>
                                    </div>
                                </div>
                            </div>
                
                            <div class="stat-panel" id="corr-compiler-panel">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                                        <h4>Python Compiler</h4>
                                    </div>
                                    <div style="flex:1;min-height:0;">
                                        <iframe id="corr-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                                    </div>
                                </div>
                            </div>
            </div>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
        </div>

<jsp:include page="modern/components/related-tools.jsp">
<jsp:param name="currentToolUrl" value="correlation-calculator.jsp"/>
        <jsp:param name="keyword" value="statistics"/>
        <jsp:param name="limit" value="6"/>
</jsp:include>

        <section class="tool-expertise-section ms-below-fold" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
        
                <!-- 1. What Is Correlation? -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Is Correlation?</h2>
                    <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;"><strong>Correlation</strong> measures the strength and direction of the relationship between two variables. The correlation coefficient (r) ranges from &minus;1 to +1.</p>
                    <div class="stat-edu-grid" style="margin-top:1rem;">
                        <div class="stat-feature-card stat-anim stat-anim-d1">
                            <div style="font-size:1.5rem;">&#x2197;&#xFE0F;</div>
                            <h4>Positive (r &gt; 0)</h4>
                            <p>As X increases, Y tends to increase. Example: study hours and exam scores.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d2">
                            <div style="font-size:1.5rem;">&#x2198;&#xFE0F;</div>
                            <h4>Negative (r &lt; 0)</h4>
                            <p>As X increases, Y tends to decrease. Example: price and demand.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d3">
                            <div style="font-size:1.5rem;">&#x2B55;</div>
                            <h4>Zero (r &asymp; 0)</h4>
                            <p>No linear relationship between X and Y. Points are scattered randomly.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 2. Pearson vs Spearman -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Pearson vs. Spearman Correlation</h2>
                    <table class="stat-ops-table">
                        <thead><tr><th>Property</th><th>Pearson (r)</th><th>Spearman (&rho;)</th></tr></thead>
                        <tbody>
                            <tr><td style="font-weight:600;">Measures</td><td>Linear relationship</td><td>Monotonic relationship</td></tr>
                            <tr><td style="font-weight:600;">Data type</td><td>Continuous, interval/ratio</td><td>Ordinal or continuous</td></tr>
                            <tr><td style="font-weight:600;">Assumptions</td><td>Normal distribution, no outliers</td><td>No distribution assumption</td></tr>
                            <tr><td style="font-weight:600;">Outlier sensitivity</td><td>High &mdash; easily distorted</td><td>Low &mdash; uses ranks</td></tr>
                            <tr><td style="font-weight:600;">Best for</td><td>Linear, well-behaved data</td><td>Ranked data, curves, outliers</td></tr>
                        </tbody>
                    </table>
                </div>
        
                <!-- 3. Strength Table -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Correlation Strength Guide</h2>
                    <table class="stat-ops-table">
                        <thead><tr><th>|r| Value</th><th>Strength</th><th>Meaning</th></tr></thead>
                        <tbody>
                            <tr><td style="font-weight:600;">0.8 &ndash; 1.0</td><td>Very Strong</td><td>Highly predictive relationship</td></tr>
                            <tr><td style="font-weight:600;">0.6 &ndash; 0.79</td><td>Strong</td><td>Notable, meaningful relationship</td></tr>
                            <tr><td style="font-weight:600;">0.4 &ndash; 0.59</td><td>Moderate</td><td>Clear but not dominant</td></tr>
                            <tr><td style="font-weight:600;">0.2 &ndash; 0.39</td><td>Weak</td><td>Minor relationship</td></tr>
                            <tr><td style="font-weight:600;">0.0 &ndash; 0.19</td><td>Very Weak</td><td>Little to no relationship</td></tr>
                        </tbody>
                    </table>
                    <div style="margin-top:1rem;padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border-left:3px solid var(--error);">
                        <p style="margin:0;font-size:0.875rem;color:var(--text-secondary);line-height:1.6;">
                            <strong>Correlation &ne; Causation:</strong> A strong correlation does not prove that one variable causes the other. There may be confounding variables, reverse causation, or coincidence. Always consider context.
                        </p>
                    </div>
                </div>
        
                <!-- 4. FAQ -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
                    <div class="faq-item">
                        <button class="faq-question">What is the difference between Pearson and Spearman correlation?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Pearson measures linear relationships between continuous variables. Spearman measures monotonic relationships using ranks and is more robust to outliers and non-normal distributions.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">How do I interpret the correlation coefficient r?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">r ranges from &minus;1 to +1. The sign shows direction (positive or negative) and the magnitude shows strength. Always visualize with a scatter plot to check for non-linearity or outliers.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">Does correlation imply causation?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">No. Correlation shows that two variables move together, but does not prove one causes the other. Confounding variables, reverse causation, or coincidence can all create spurious correlations.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What does R-squared tell me?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">R&sup2; is the proportion of variance in Y explained by X. If r = 0.8, then R&sup2; = 0.64, meaning 64% of the variation in Y can be attributed to its linear relationship with X.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">When is a correlation statistically significant?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Significance depends on both correlation magnitude and sample size. A p-value below 0.05 is the standard threshold, but large samples can make even small correlations significant &mdash; consider effect size.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What if my data has outliers?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Outliers can dramatically affect Pearson correlation. Use Spearman rank correlation which is robust to outliers, or consider removing extreme values after careful investigation of whether they are genuine data points.</div>
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
    <script src="<%=request.getContextPath()%>/js/correlation-core.js?v=<%=v%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/categories-menu.js" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=v%>" defer></script>

<script>window.__MS_STAT_PAGE__ = { key: 'correlation', label: "Correlation Calculator" };</script>
<%
    request.setAttribute("mathAiButtonId", "btnMathAI");
    request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
    request.setAttribute("mathAiProfileExport", "configureStatisticsMathShell");
%>
<%@ include file="modern/components/math-ai-boot.inc.jsp" %>
</body>
</html>

