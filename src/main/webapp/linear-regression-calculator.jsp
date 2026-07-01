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
        <jsp:param name="toolName" value="Linear Regression Calculator Online - Slope R-Squared Prediction Free" />
        <jsp:param name="toolDescription" value="Calculate linear regression equation slope intercept R-squared correlation and make predictions. Interactive scatter plot with regression line residual analysis and Python export." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="linear-regression-calculator.jsp" />
        <jsp:param name="toolKeywords" value="linear regression calculator, regression line calculator, r squared calculator, slope intercept calculator, least squares calculator, prediction calculator, scatter plot regression, residual analysis, correlation regression, standard error estimate" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Regression equation y equals a plus bx,Slope and y-intercept calculation,R-squared coefficient of determination,Correlation coefficient,Standard error of estimate,Residual analysis,Interactive Plotly scatter plot with regression line,Prediction from X value,Step-by-step KaTeX formulas,Python scipy code generation" />
        <jsp:param name="teaches" value="Linear regression, least squares method, slope, intercept, R-squared, correlation, residuals, prediction, scatter plots" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Enter Data|Type X Y pairs one per line separated by comma or space,Click Calculate|Get instant regression equation with step-by-step formulas,Review Results|See slope intercept R-squared correlation and standard error,Make Predictions|Enter any X value to predict Y using the fitted model,View Scatter Plot|See the interactive chart with regression line overlay,Export Code|Run Python scipy code in the embedded compiler" />
        <jsp:param name="faq1q" value="What does R-squared tell me about the regression?" />
        <jsp:param name="faq1a" value="R-squared is the proportion of variance in Y explained by the linear model. R-squared of 0.85 means 85 percent of the variation in Y is explained by X. Higher values indicate better fit but always check residuals." />
        <jsp:param name="faq2q" value="What are the assumptions of linear regression?" />
        <jsp:param name="faq2a" value="Linear regression assumes linearity between X and Y independence of observations constant variance of residuals called homoscedasticity and approximately normal residuals. Inspect residual plots to check these." />
        <jsp:param name="faq3q" value="How do I make predictions with the regression equation?" />
        <jsp:param name="faq3a" value="Plug any X value into the equation y equals intercept plus slope times x. Be cautious about extrapolating far beyond the range of your data as the linear relationship may not hold." />
        <jsp:param name="faq4q" value="What if the relationship is not linear?" />
        <jsp:param name="faq4a" value="If residuals show a pattern the relationship may be curved. Consider polynomial regression logarithmic transformation or other nonlinear models. Always visualize data before fitting a linear model." />
        <jsp:param name="faq5q" value="How do I interpret the slope?" />
        <jsp:param name="faq5a" value="The slope b tells you how much Y changes for each one unit increase in X. A slope of 2.5 means Y increases by 2.5 units on average when X increases by 1 unit." />
        <jsp:param name="faq6q" value="What is the standard error of the estimate?" />
        <jsp:param name="faq6a" value="The standard error of estimate measures the average distance between observed Y values and the regression line predictions. Smaller values indicate predictions are closer to actual data points." />
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

    <% request.setAttribute("activeService", "regression"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <span aria-current="page">Linear Regression</span>
            </nav>
            <h1>Linear Regression Calculator</h1>
            <p class="ms-subtitle">Least squares · R² · residual plot · prediction</p>
        </header>

        <div class="ic-stack">

            <div class="ic-hero ic-hero--compact stat-hero" id="stat-hero">
                <div class="ic-hero-top">
                    <button type="button" class="math-ai-tab-btn" id="btnMathAI" title="Math AI — statistics tutor + full math router in chat (Ctrl+Shift+A)">&#10024; AI</button>
                </div>
                <div class="stat-hero-core">
                    <!-- Data input -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label" for="lr-data-input">X, Y Data Pairs (one per line)</label>
                                            <textarea class="stat-input-text lr-input" id="lr-data-input" rows="8" placeholder="Format: x, y&#10;Example:&#10;1, 2&#10;2, 4&#10;3, 5&#10;4, 4&#10;5, 5"></textarea>
                                            <div class="tool-form-hint">Separate X and Y with comma or space. Minimum 2 data points.</div>
                                        </div>
                    
                                        <!-- Buttons -->
                                        <button type="button" class="tool-action-btn" id="lr-calc-btn">Calculate Regression</button>
                                        <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                                            <button type="button" class="tool-action-btn" id="lr-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                                        </div>
                    
                                        <!-- Prediction section (hidden until first calculation) -->
                                        <div class="lr-predict-section" id="lr-predict-section">
                                            <label class="tool-form-label">Make a Prediction</label>
                                            <div class="lr-predict-row">
                                                <span style="font-size:0.8125rem;font-weight:500;white-space:nowrap;">X =</span>
                                                <input type="number" class="stat-input-text lr-input" id="lr-predict-x" step="any" placeholder="Enter X">
                                                <button type="button" class="tool-action-btn" id="lr-predict-btn" style="width:auto;margin:0;padding:0.5rem 0.75rem;font-size:0.75rem;">Predict</button>
                                            </div>
                                            <div id="lr-predict-result"></div>
                                        </div>
                    
                                        <hr class="stat-sep">
                    
                                        <!-- Quick Examples -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label">Quick Examples</label>
                                            <div class="stat-examples">
                                                <button type="button" class="stat-example-chip" data-lr-example="study-hours">Study Hours</button>
                                                <button type="button" class="stat-example-chip" data-lr-example="sales">Ad Sales</button>
                                                <button type="button" class="stat-example-chip" data-lr-example="temperature">Temperature</button>
                                                <button type="button" class="stat-example-chip" data-lr-example="height-weight">Height/Weight</button>
                                            </div>
                                        </div>
                                    </div>
                </div>
            </div>

            <div class="ic-result-card">
                <div class="stat-output-tabs">
                                <button type="button" class="stat-output-tab active" data-tab="lr-result-panel">Result</button>
                                <button type="button" class="stat-output-tab" data-tab="lr-graph-panel">Scatter Plot</button>
                                <button type="button" class="stat-output-tab" data-tab="lr-compiler-panel">Python Compiler</button>
                            </div>
                
                            <div class="stat-panel active" id="lr-result-panel">
                                <div class="tool-card tool-result-card">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                                        <h4>Result</h4>
                                    </div>
                                    <div class="tool-result-content" id="lr-result-content">
                                        <div class="tool-empty-state">
                                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F4C9;</div>
                                            <h3>Enter data and click Calculate</h3>
                                            <p>Compute the regression equation, R&sup2;, correlation, and make predictions.</p>
                                        </div>
                                    </div>
                                    <div class="tool-result-actions" id="lr-result-actions"></div>
                                </div>
                            </div>
                
                            <div class="stat-panel" id="lr-graph-panel">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><line x1="3" y1="21" x2="21" y2="3"/><circle cx="7" cy="17" r="1.5"/><circle cx="12" cy="12" r="1.5"/><circle cx="17" cy="7" r="1.5"/></svg>
                                        <h4>Scatter Plot &amp; Regression Line</h4>
                                    </div>
                                    <div style="flex:1;padding:1rem;min-height:400px;">
                                        <div id="lr-graph-container"></div>
                                    </div>
                                </div>
                            </div>
                
                            <div class="stat-panel" id="lr-compiler-panel">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                                        <h4>Python Compiler</h4>
                                    </div>
                                    <div style="flex:1;min-height:0;">
                                        <iframe id="lr-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                                    </div>
                                </div>
                            </div>
            </div>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
        </div>

<jsp:include page="modern/components/related-tools.jsp">
<jsp:param name="currentToolUrl" value="linear-regression-calculator.jsp"/>
        <jsp:param name="keyword" value="statistics"/>
        <jsp:param name="limit" value="6"/>
</jsp:include>

        <section class="tool-expertise-section ms-below-fold" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
        
                <!-- 1. What Is Linear Regression? -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Is Linear Regression?</h2>
                    <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;"><strong>Linear regression</strong> models the relationship between a dependent variable (Y) and independent variable (X) by fitting the best straight line through the data using the <strong>least squares method</strong>.</p>
        
                    <div class="stat-formula-box">
                        <strong>Regression Equation:</strong>&nbsp; y = a + bx
                    </div>
        
                    <div class="stat-edu-grid" style="margin-top:1rem;">
                        <div class="stat-feature-card stat-anim stat-anim-d1">
                            <div style="font-size:1.5rem;">&#x1F4C8;</div>
                            <h4>Slope (b)</h4>
                            <p>How much Y changes for each 1-unit increase in X. Positive = upward trend, negative = downward.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d2">
                            <div style="font-size:1.5rem;">&#x1F3AF;</div>
                            <h4>Intercept (a)</h4>
                            <p>The predicted value of Y when X = 0. The starting point of the regression line.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d3">
                            <div style="font-size:1.5rem;">&#x1F4CA;</div>
                            <h4>R&sup2; (Fit Quality)</h4>
                            <p>Proportion of variance in Y explained by X. Ranges from 0 (no fit) to 1 (perfect fit).</p>
                        </div>
                    </div>
                </div>
        
                <!-- 2. Key Formulas -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Key Formulas</h2>
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>Slope:</strong>&nbsp; b = &Sigma;[(x<sub>i</sub> &minus; x&#772;)(y<sub>i</sub> &minus; y&#772;)] / &Sigma;(x<sub>i</sub> &minus; x&#772;)&sup2;
                    </div>
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>Intercept:</strong>&nbsp; a = y&#772; &minus; b &times; x&#772;
                    </div>
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>R&sup2;:</strong>&nbsp; R&sup2; = 1 &minus; SS<sub>res</sub> / SS<sub>tot</sub>
                    </div>
                    <div class="stat-formula-box">
                        <strong>Standard Error:</strong>&nbsp; SEE = &radic;[&Sigma;(y<sub>i</sub> &minus; y&#770;<sub>i</sub>)&sup2; / (n &minus; 2)]
                    </div>
                </div>
        
                <!-- 3. R-squared Interpretation -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Understanding R&sup2;</h2>
                    <table class="stat-ops-table">
                        <thead><tr><th>R&sup2; Range</th><th>Interpretation</th><th>Fit Quality</th></tr></thead>
                        <tbody>
                            <tr><td style="font-weight:600;">0.90 &ndash; 1.00</td><td>90&ndash;100% of variance explained</td><td style="color:#10b981;font-weight:600;">Excellent</td></tr>
                            <tr><td style="font-weight:600;">0.70 &ndash; 0.89</td><td>70&ndash;89% of variance explained</td><td style="color:#3b82f6;font-weight:600;">Good</td></tr>
                            <tr><td style="font-weight:600;">0.50 &ndash; 0.69</td><td>50&ndash;69% of variance explained</td><td style="color:#f59e0b;font-weight:600;">Moderate</td></tr>
                            <tr><td style="font-weight:600;">0.00 &ndash; 0.49</td><td>Less than 50% explained</td><td style="color:#ef4444;font-weight:600;">Weak</td></tr>
                        </tbody>
                    </table>
                    <div style="margin-top:1rem;padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border-left:3px solid var(--info);">
                        <p style="margin:0;font-size:0.875rem;color:var(--text-secondary);line-height:1.6;">
                            <strong>Tip:</strong> A high R&sup2; does not guarantee a good model. Always visualize residuals to check for patterns that indicate model violations (non-linearity, heteroscedasticity).
                        </p>
                    </div>
                </div>
        
                <!-- 4. Assumptions -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Assumptions of Linear Regression</h2>
                    <div class="stat-edu-grid">
                        <div class="stat-edu-card stat-anim stat-anim-d1">
                            <h4>Linearity</h4>
                            <p>The relationship between X and Y is approximately linear. Check with a scatter plot.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d2">
                            <h4>Independence</h4>
                            <p>Observations are independent of each other. No autocorrelation in residuals.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d3">
                            <h4>Homoscedasticity</h4>
                            <p>Residuals have constant variance across all X values. Fan-shaped patterns indicate violation.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d4">
                            <h4>Normality</h4>
                            <p>Residuals are approximately normally distributed. Less critical for large samples.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 5. FAQ -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
                    <div class="faq-item">
                        <button class="faq-question">What does R-squared tell me about the regression?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">R&sup2; is the proportion of variance in Y explained by the linear model. An R&sup2; of 0.85 means 85% of the variation in Y is captured by the regression line. Higher is better, but always check residual plots.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What are the assumptions of linear regression?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Linear regression assumes: linearity (X and Y have a linear relationship), independence of observations, homoscedasticity (constant residual variance), and approximately normal residuals. Inspect residual plots to verify.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">How do I make predictions with the regression equation?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Plug any X value into y = a + bx. Be cautious about extrapolating far beyond your data range, as the linear relationship may not hold outside the observed domain.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What if the relationship is not linear?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">If residuals show a curve or pattern, consider polynomial regression, logarithmic transformation, or other nonlinear models. Always visualize your data with a scatter plot first.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">How do I interpret the slope?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">The slope (b) tells you how much Y changes for each 1-unit increase in X. A slope of 2.5 means Y increases by 2.5 units on average when X increases by 1 unit.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What is the standard error of the estimate?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">SEE measures the average distance between observed Y values and predicted values from the regression line. Smaller SEE means the model makes more precise predictions.</div>
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
    <script src="<%=request.getContextPath()%>/js/linear-regression-core.js?v=<%=v%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/categories-menu.js" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=v%>" defer></script>

<script>window.__MS_STAT_PAGE__ = { key: 'regression', label: "Linear Regression Calculator" };</script>
<%
    request.setAttribute("mathAiButtonId", "btnMathAI");
    request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
    request.setAttribute("mathAiProfileExport", "configureStatisticsMathShell");
%>
<%@ include file="modern/components/math-ai-boot.inc.jsp" %>
</body>
</html>

