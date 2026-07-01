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
        <jsp:param name="toolName" value="Effect Size Calculator Online - Cohen d Pearson r Eta Squared Free" />
        <jsp:param name="toolDescription" value="Calculate effect sizes including Cohen d Pearson r Eta-squared Odds Ratio and Risk Ratio with confidence intervals interpretation guidelines and visualization." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="effect-size-calculator.jsp" />
        <jsp:param name="toolKeywords" value="effect size calculator, cohen d calculator, pearson r effect size, eta squared calculator, odds ratio calculator, risk ratio calculator, hedges g, statistical effect size, meta-analysis, practical significance" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Cohen d for standardized mean difference,Pearson r from correlation or t-statistic,Eta-squared for ANOVA effect size,Odds Ratio with confidence interval,Risk Ratio with confidence interval,Small medium large interpretation,Interactive Plotly visualization,Python scipy code generation" />
        <jsp:param name="teaches" value="Effect size, Cohen d, Pearson r, Eta-squared, Odds Ratio, Risk Ratio, practical significance, meta-analysis" />
        <jsp:param name="educationalLevel" value="College, University, Graduate" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Choose Effect Size Type|Select Cohen d or Pearson r or Eta-squared or Odds/Risk Ratio,Enter Data|Input group means and SDs or correlation or F-statistic or 2x2 table,Set Confidence Level|Choose 90% or 95% or 99% for confidence interval,Click Calculate|Get effect size with CI interpretation and guidelines,View Visualization|See effect size displayed as overlapping curves or forest plot,Export Code|Run Python scipy code in the embedded compiler" />
        <jsp:param name="faq1q" value="Which effect size should I use?" />
        <jsp:param name="faq1a" value="Use Cohen d for comparing two group means. Use Pearson r for correlations. Use Eta-squared for ANOVA with multiple groups. Use Odds or Risk Ratio for categorical outcomes in 2x2 tables." />
        <jsp:param name="faq2q" value="What is considered a small medium or large effect?" />
        <jsp:param name="faq2a" value="For Cohen d small is 0.2 medium is 0.5 and large is 0.8. For Pearson r small is 0.1 medium is 0.3 and large is 0.5. For Eta-squared small is 0.01 medium is 0.06 and large is 0.14. These are Cohen 1988 benchmarks." />
        <jsp:param name="faq3q" value="Why is effect size important beyond p-value?" />
        <jsp:param name="faq3a" value="P-values only tell you if an effect exists but not how large it is. A tiny effect can be statistically significant with a large enough sample. Effect size quantifies practical significance and allows comparison across studies." />
        <jsp:param name="faq4q" value="What is the difference between Cohen d and Hedges g?" />
        <jsp:param name="faq4a" value="Hedges g applies a small-sample bias correction to Cohen d. For samples larger than about 20 per group the difference is negligible. Use Hedges g when reporting in meta-analyses or with small samples." />
        <jsp:param name="faq5q" value="How do I interpret an Odds Ratio confidence interval?" />
        <jsp:param name="faq5a" value="If the 95% CI for an OR includes 1.0 the association is not statistically significant. An OR of 2.5 with CI 1.2 to 5.2 means the odds are significantly 2.5 times higher in the exposed group." />
        <jsp:param name="faq6q" value="Can I convert between effect size measures?" />
        <jsp:param name="faq6a" value="Yes. Cohen d can be converted to r using r = d divided by the square root of d squared plus 4. Eta-squared can be derived from d using eta squared = d squared divided by d squared plus 4." />
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

    <% request.setAttribute("activeService", "effect-size"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <span aria-current="page">Effect Size</span>
            </nav>
            <h1>Effect Size Calculator</h1>
            <p class="ms-subtitle">Cohen's d · Pearson r · η² · odds ratio</p>
        </header>

        <div class="ic-stack">

            <div class="ic-hero ic-hero--compact stat-hero" id="stat-hero">
                <div class="ic-hero-top">
                    <button type="button" class="math-ai-tab-btn" id="btnMathAI" title="Math AI — statistics tutor + full math router in chat (Ctrl+Shift+A)">&#10024; AI</button>
                </div>
                <div class="stat-hero-core">
                    <!-- Mode Toggle -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label">Effect Size Type</label>
                                            <div class="stat-mode-toggle" style="display:flex;flex-wrap:wrap;">
                                                <button type="button" class="stat-mode-btn active" id="es-mode-cohend" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Cohen's d</button>
                                                <button type="button" class="stat-mode-btn" id="es-mode-pearsonr" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Pearson's r</button>
                                                <button type="button" class="stat-mode-btn" id="es-mode-eta" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">&eta;&sup2; (ANOVA)</button>
                                                <button type="button" class="stat-mode-btn" id="es-mode-odds" style="flex:1;min-width:0;font-size:0.7rem;padding:0.5rem 0.25rem;">Odds/Risk</button>
                                            </div>
                                        </div>
                    
                                        <!-- Confidence Level -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label" for="es-confidence">Confidence Level</label>
                                            <select class="stat-input-text" id="es-confidence" style="width:100%;">
                                                <option value="90">90%</option>
                                                <option value="95" selected>95%</option>
                                                <option value="99">99%</option>
                                            </select>
                                        </div>
                    
                                        <!-- Cohen's d inputs -->
                                        <div id="es-input-cohend">
                                            <div class="es-two-group">
                                                <div>
                                                    <div class="es-group-label">Group 1</div>
                                                    <div class="tool-form-group">
                                                        <label class="tool-form-label" for="es-m1">Mean</label>
                                                        <input type="number" class="stat-input-text" id="es-m1" value="50" step="0.01">
                                                    </div>
                                                    <div class="tool-form-group">
                                                        <label class="tool-form-label" for="es-sd1">SD</label>
                                                        <input type="number" class="stat-input-text" id="es-sd1" value="10" step="0.01" min="0">
                                                    </div>
                                                    <div class="tool-form-group">
                                                        <label class="tool-form-label" for="es-n1">Size</label>
                                                        <input type="number" class="stat-input-text" id="es-n1" value="30" step="1" min="2">
                                                    </div>
                                                </div>
                                                <div>
                                                    <div class="es-group-label">Group 2</div>
                                                    <div class="tool-form-group">
                                                        <label class="tool-form-label" for="es-m2">Mean</label>
                                                        <input type="number" class="stat-input-text" id="es-m2" value="55" step="0.01">
                                                    </div>
                                                    <div class="tool-form-group">
                                                        <label class="tool-form-label" for="es-sd2">SD</label>
                                                        <input type="number" class="stat-input-text" id="es-sd2" value="10" step="0.01" min="0">
                                                    </div>
                                                    <div class="tool-form-group">
                                                        <label class="tool-form-label" for="es-n2">Size</label>
                                                        <input type="number" class="stat-input-text" id="es-n2" value="30" step="1" min="2">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                    
                                        <!-- Pearson's r inputs -->
                                        <div id="es-input-pearsonr" style="display:none;">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="es-r-method">Method</label>
                                                <select class="stat-input-text" id="es-r-method" style="width:100%;">
                                                    <option value="direct">Direct r value</option>
                                                    <option value="ttest">From t-statistic</option>
                                                </select>
                                            </div>
                                            <div id="es-r-direct-panel">
                                                <div class="tool-form-group">
                                                    <label class="tool-form-label" for="es-r">Correlation (r)</label>
                                                    <input type="number" class="stat-input-text" id="es-r" value="0.5" step="0.01" min="-1" max="1">
                                                    <div class="tool-form-hint">Value between &minus;1 and 1</div>
                                                </div>
                                                <div class="tool-form-group">
                                                    <label class="tool-form-label" for="es-r-n">Sample Size (n)</label>
                                                    <input type="number" class="stat-input-text" id="es-r-n" value="50" step="1" min="4">
                                                </div>
                                            </div>
                                            <div id="es-r-ttest-panel" style="display:none;">
                                                <div class="tool-form-group">
                                                    <label class="tool-form-label" for="es-r-t">t-statistic</label>
                                                    <input type="number" class="stat-input-text" id="es-r-t" value="3.5" step="0.01">
                                                </div>
                                                <div class="tool-form-group">
                                                    <label class="tool-form-label" for="es-r-df">Degrees of Freedom (df)</label>
                                                    <input type="number" class="stat-input-text" id="es-r-df" value="48" step="1" min="1">
                                                </div>
                                            </div>
                                        </div>
                    
                                        <!-- Eta-squared inputs -->
                                        <div id="es-input-eta" style="display:none;">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="es-eta-method">Method</label>
                                                <select class="stat-input-text" id="es-eta-method" style="width:100%;">
                                                    <option value="fstat">From F-statistic</option>
                                                    <option value="ss">From SS values</option>
                                                </select>
                                            </div>
                                            <div id="es-eta-fstat-panel">
                                                <div class="tool-form-group">
                                                    <label class="tool-form-label" for="es-eta-f">F-statistic</label>
                                                    <input type="number" class="stat-input-text" id="es-eta-f" value="5.2" step="0.01" min="0">
                                                </div>
                                                <div class="tool-form-group">
                                                    <label class="tool-form-label" for="es-eta-df-between">df Between Groups</label>
                                                    <input type="number" class="stat-input-text" id="es-eta-df-between" value="2" step="1" min="1">
                                                </div>
                                                <div class="tool-form-group">
                                                    <label class="tool-form-label" for="es-eta-df-within">df Within Groups</label>
                                                    <input type="number" class="stat-input-text" id="es-eta-df-within" value="57" step="1" min="1">
                                                </div>
                                            </div>
                                            <div id="es-eta-direct-panel" style="display:none;">
                                                <div class="tool-form-group">
                                                    <label class="tool-form-label" for="es-eta-ss-between">SS Between (SS<sub>B</sub>)</label>
                                                    <input type="number" class="stat-input-text" id="es-eta-ss-between" value="250" step="0.01" min="0">
                                                </div>
                                                <div class="tool-form-group">
                                                    <label class="tool-form-label" for="es-eta-ss-total">SS Total (SS<sub>T</sub>)</label>
                                                    <input type="number" class="stat-input-text" id="es-eta-ss-total" value="800" step="0.01" min="0">
                                                </div>
                                            </div>
                                        </div>
                    
                                        <!-- Odds/Risk Ratio inputs -->
                                        <div id="es-input-odds" style="display:none;">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="es-or-type">Type</label>
                                                <select class="stat-input-text" id="es-or-type" style="width:100%;">
                                                    <option value="or">Odds Ratio (OR)</option>
                                                    <option value="rr">Risk Ratio (RR)</option>
                                                </select>
                                            </div>
                                            <table class="es-table-2x2">
                                                <thead>
                                                    <tr><th></th><th>Exposed</th><th>Not Exposed</th></tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <th>Disease</th>
                                                        <td><input type="number" id="es-or-a" value="20" min="0" step="1"></td>
                                                        <td><input type="number" id="es-or-b" value="10" min="0" step="1"></td>
                                                    </tr>
                                                    <tr>
                                                        <th>No Disease</th>
                                                        <td><input type="number" id="es-or-c" value="30" min="0" step="1"></td>
                                                        <td><input type="number" id="es-or-d" value="40" min="0" step="1"></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                    
                                        <!-- Buttons -->
                                        <button type="button" class="tool-action-btn" id="es-calc-btn">Calculate Effect Size</button>
                                        <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                                            <button type="button" class="tool-action-btn" id="es-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                                        </div>
                    
                                        <hr class="stat-sep">
                    
                                        <!-- Quick Examples -->
                                        <div class="tool-form-group" id="es-examples">
                                            <label class="tool-form-label">Quick Examples</label>
                                            <div class="stat-examples">
                                                <button type="button" class="stat-example-chip" data-example="treatment-effect">Treatment Effect</button>
                                                <button type="button" class="stat-example-chip" data-example="study-correlation">Study Correlation</button>
                                                <button type="button" class="stat-example-chip" data-example="anova-groups">ANOVA Groups</button>
                                                <button type="button" class="stat-example-chip" data-example="clinical-exposure">Clinical Exposure</button>
                                            </div>
                                        </div>
                                    </div>
                </div>
            </div>

            <div class="ic-result-card">
                <div class="stat-output-tabs">
                                <button type="button" class="stat-output-tab active" data-tab="es-result-panel">Result</button>
                                <button type="button" class="stat-output-tab" data-tab="es-graph-panel">Visualization</button>
                                <button type="button" class="stat-output-tab" data-tab="es-compiler-panel">Python Compiler</button>
                            </div>
                
                            <div class="stat-panel active" id="es-result-panel">
                                <div class="tool-card tool-result-card">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                                        <h4>Result</h4>
                                    </div>
                                    <div class="tool-result-content" id="es-result-content">
                                        <div class="tool-empty-state">
                                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F4CA;</div>
                                            <h3>Enter parameters and click Calculate</h3>
                                            <p>Compute effect sizes for Cohen's d, Pearson's r, Eta-squared, or Odds/Risk Ratio.</p>
                                        </div>
                                    </div>
                                    <div class="tool-result-actions" id="es-result-actions"></div>
                                </div>
                            </div>
                
                            <div class="stat-panel" id="es-graph-panel">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><path d="M3 3v18h18"/><path d="M7 16l4-8 4 4 4-6"/></svg>
                                        <h4>Effect Size Visualization</h4>
                                    </div>
                                    <div style="flex:1;padding:1rem;min-height:300px;">
                                        <div id="es-graph-container"></div>
                                    </div>
                                </div>
                            </div>
                
                            <div class="stat-panel" id="es-compiler-panel">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                                        <h4>Python Compiler</h4>
                                    </div>
                                    <div style="flex:1;min-height:0;">
                                        <iframe id="es-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                                    </div>
                                </div>
                            </div>
            </div>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
        </div>

<jsp:include page="modern/components/related-tools.jsp">
<jsp:param name="currentToolUrl" value="effect-size-calculator.jsp"/>
        <jsp:param name="keyword" value="statistics"/>
        <jsp:param name="limit" value="6"/>
</jsp:include>

        <section class="tool-expertise-section ms-below-fold" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
        
                <!-- 1. What Is Effect Size? -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Is Effect Size?</h2>
                    <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;"><strong>Effect size</strong> is a quantitative measure of the magnitude of a phenomenon. Unlike p-values which only indicate whether an effect exists, effect size tells you <em>how large</em> the effect is &mdash; making it essential for practical significance, meta-analysis, and power analysis.</p>
        
                    <div class="stat-edu-grid" style="margin-top:1rem;">
                        <div class="stat-feature-card stat-anim stat-anim-d1">
                            <div style="font-size:1.5rem;">&#x1F3AF;</div>
                            <h4>Practical Significance</h4>
                            <p>Effect size quantifies how meaningful a result is in practice, beyond statistical significance alone.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d2">
                            <div style="font-size:1.5rem;">&#x1F4DA;</div>
                            <h4>Meta-Analysis</h4>
                            <p>Effect sizes allow combining and comparing results across different studies with different scales and sample sizes.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d3">
                            <div style="font-size:1.5rem;">&#x1F50B;</div>
                            <h4>Power Planning</h4>
                            <p>Knowing the expected effect size is essential for calculating the sample size needed to detect it reliably.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 2. Effect Size Measures & Formulas -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Effect Size Measures &amp; Formulas</h2>
        
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>Cohen's d:</strong>&nbsp; d = (M&#8321; &minus; M&#8322;) / SD<sub>pooled</sub>
                        <div class="tool-form-hint">Standardized mean difference between two groups</div>
                    </div>
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>Pearson's r:</strong>&nbsp; r = t / &radic;(t&sup2; + df)
                        <div class="tool-form-hint">Correlation coefficient or converted from t-statistic</div>
                    </div>
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>Eta-squared:</strong>&nbsp; &eta;&sup2; = SS<sub>B</sub> / SS<sub>T</sub>
                        <div class="tool-form-hint">Proportion of variance explained in ANOVA</div>
                    </div>
                    <div class="stat-formula-box">
                        <strong>Odds Ratio:</strong>&nbsp; OR = (a &times; d) / (b &times; c) &nbsp;&nbsp;|&nbsp;&nbsp; <strong>Risk Ratio:</strong>&nbsp; RR = (a/(a+b)) / (c/(c+d))
                        <div class="tool-form-hint">Association measures for 2&times;2 contingency tables</div>
                    </div>
                </div>
        
                <!-- 3. Interpretation Guidelines -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Interpretation Guidelines</h2>
        
                    <table class="stat-ops-table">
                        <thead><tr><th>Measure</th><th>Small</th><th>Medium</th><th>Large</th><th>Very Large</th></tr></thead>
                        <tbody>
                            <tr><td style="font-weight:600;">Cohen's d</td><td>0.2</td><td>0.5</td><td>0.8</td><td>1.2</td></tr>
                            <tr><td style="font-weight:600;">Pearson's r</td><td>0.1</td><td>0.3</td><td>0.5</td><td>0.7</td></tr>
                            <tr><td style="font-weight:600;">Eta-squared (&eta;&sup2;)</td><td>0.01</td><td>0.06</td><td>0.14</td><td>0.20</td></tr>
                            <tr><td style="font-weight:600;">Odds Ratio</td><td>1.5</td><td>2.5</td><td>4.3</td><td>10+</td></tr>
                        </tbody>
                    </table>
        
                    <div style="margin-top:1rem;padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border-left:3px solid var(--warning);">
                        <p style="margin:0;font-size:0.875rem;color:var(--text-secondary);line-height:1.6;">
                            <strong>Note:</strong> These benchmarks are from Cohen (1988) and are general guidelines. The practical significance of an effect size depends on the research context. A &ldquo;small&rdquo; effect can be highly meaningful in some domains.
                        </p>
                    </div>
                </div>
        
                <!-- 4. Why Effect Size Matters -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Why Effect Size Matters</h2>
        
                    <div class="stat-edu-grid">
                        <div class="stat-edu-card stat-anim stat-anim-d1">
                            <h4>&#x1F4C9; Beyond p-values</h4>
                            <p>A statistically significant p-value with a tiny effect size means the result is real but practically meaningless. Effect size tells you whether it matters.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d2">
                            <h4>&#x1F4DD; Publication Standards</h4>
                            <p>APA, CONSORT, and major journals now require effect sizes. Reporting only p-values is increasingly seen as incomplete statistical practice.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d3">
                            <h4>&#x1F50D; Cross-Study Comparison</h4>
                            <p>Effect sizes allow you to compare findings across studies that used different scales, measures, or sample sizes &mdash; essential for systematic reviews.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d4">
                            <h4>&#x1F4CB; Sample Size Planning</h4>
                            <p>Power analysis requires an expected effect size. Knowing whether you expect a small or large effect determines how many participants you need.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 5. Converting Between Measures -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Converting Between Measures</h2>
        
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>d &rarr; r:</strong>&nbsp; r = d / &radic;(d&sup2; + 4)
                        <div class="tool-form-hint">Convert Cohen's d to Pearson's r</div>
                    </div>
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>r &rarr; d:</strong>&nbsp; d = 2r / &radic;(1 &minus; r&sup2;)
                        <div class="tool-form-hint">Convert Pearson's r to Cohen's d</div>
                    </div>
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>d &rarr; &eta;&sup2;:</strong>&nbsp; &eta;&sup2; = d&sup2; / (d&sup2; + 4)
                        <div class="tool-form-hint">Approximate eta-squared from Cohen's d (equal groups)</div>
                    </div>
                    <div class="stat-formula-box">
                        <strong>OR &rarr; d:</strong>&nbsp; d = ln(OR) &times; &radic;3 / &pi;
                        <div class="tool-form-hint">Convert log Odds Ratio to Cohen's d (Hasselblad &amp; Hedges)</div>
                    </div>
        
                    <div class="stat-worked-example" style="margin-top:1rem;">
                        <strong>Worked Example:</strong> Convert Cohen's d = 0.5 to Pearson's r.
                        <div style="margin-top:0.5rem;padding-left:1rem;border-left:3px solid var(--tool-primary);color:var(--text-secondary);font-size:0.875rem;">
                            r = 0.5 / &radic;(0.5&sup2; + 4)<br>
                            r = 0.5 / &radic;(0.25 + 4)<br>
                            r = 0.5 / &radic;4.25<br>
                            r = 0.5 / 2.062 = <strong>0.243</strong>
                        </div>
                    </div>
                </div>
        
                <!-- 6. FAQ -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
                    <div class="faq-item">
                        <button class="faq-question">Which effect size should I use?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Use <strong>Cohen's d</strong> for comparing two group means. Use <strong>Pearson's r</strong> for correlations. Use <strong>Eta-squared</strong> for ANOVA with multiple groups. Use <strong>Odds or Risk Ratio</strong> for categorical outcomes in 2&times;2 tables.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What is considered a small, medium, or large effect?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">For Cohen's d: small is 0.2, medium is 0.5, and large is 0.8. For Pearson's r: small is 0.1, medium is 0.3, and large is 0.5. For Eta-squared: small is 0.01, medium is 0.06, and large is 0.14. These are Cohen (1988) benchmarks.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">Why is effect size important beyond p-value?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">P-values only tell you if an effect exists, but not how large it is. A tiny effect can be statistically significant with a large enough sample. Effect size quantifies practical significance and allows comparison across studies.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What is the difference between Cohen's d and Hedges' g?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Hedges' g applies a small-sample bias correction to Cohen's d. For samples larger than about 20 per group, the difference is negligible. Use Hedges' g when reporting in meta-analyses or with small samples.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">How do I interpret an Odds Ratio confidence interval?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">If the 95% CI for an OR includes 1.0, the association is not statistically significant. An OR of 2.5 with CI [1.2, 5.2] means the odds are significantly 2.5 times higher in the exposed group.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">Can I convert between effect size measures?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Yes. Cohen's d can be converted to r using r = d / &radic;(d&sup2; + 4). Eta-squared can be derived from d using &eta;&sup2; = d&sup2; / (d&sup2; + 4). Odds Ratio can be converted to d using d = ln(OR) &times; &radic;3 / &pi;.</div>
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
    <script src="<%=request.getContextPath()%>/js/effect-size-core.js?v=<%=v%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/categories-menu.js" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=v%>" defer></script>

<script>window.__MS_STAT_PAGE__ = { key: 'effect-size', label: "Effect Size Calculator" };</script>
<%
    request.setAttribute("mathAiButtonId", "btnMathAI");
    request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
    request.setAttribute("mathAiProfileExport", "configureStatisticsMathShell");
%>
<%@ include file="modern/components/math-ai-boot.inc.jsp" %>
</body>
</html>

