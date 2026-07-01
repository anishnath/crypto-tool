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
        <jsp:param name="toolName" value="Outlier Detection Calculator Online - IQR Z-Score MAD Free" />
        <jsp:param name="toolDescription" value="Detect outliers using IQR method Z-score and Modified Z-score MAD. Compare all methods identify consensus outliers with interactive scatter plot and Python export." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="outlier-detection-calculator.jsp" />
        <jsp:param name="toolKeywords" value="outlier detection calculator, outlier calculator, IQR method, z-score outliers, modified z-score, MAD, Tukey fences, box plot outliers, anomaly detection, outlier analysis" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="IQR method with configurable Tukey fence multiplier,Z-score outlier detection with threshold selection,Modified Z-score using median absolute deviation,Compare all three methods with consensus detection,Interactive Plotly scatter plot with outliers highlighted,Data summary statistics with interpretation,Python numpy outlier detection code generation" />
        <jsp:param name="teaches" value="Outlier detection, IQR method, Tukey fences, Z-score, modified Z-score, MAD, robust statistics, data quality" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Enter Data|Paste numbers separated by commas spaces or newlines,Choose Method|Select IQR Z-score Modified Z or Compare All,Set Threshold|Adjust sensitivity with method-specific thresholds,Click Detect|Identify outliers with detailed analysis,View Scatter Plot|See data points with outliers highlighted in red,Export Code|Run Python numpy outlier detection code" />
        <jsp:param name="faq1q" value="Which outlier detection method should I use?" />
        <jsp:param name="faq1a" value="Use IQR with k equals 1.5 for general purpose robust detection. Use Z-score for normally distributed data. Use Modified Z-score MAD for small samples or when you suspect many outliers. Use Compare All to see consensus across methods." />
        <jsp:param name="faq2q" value="What is the IQR method for outlier detection?" />
        <jsp:param name="faq2a" value="The IQR method uses Tukey fences. Values below Q1 minus k times IQR or above Q3 plus k times IQR are outliers. With k equals 1.5 these are mild outliers and k equals 3.0 identifies extreme outliers only." />
        <jsp:param name="faq3q" value="Should I always remove outliers from my data?" />
        <jsp:param name="faq3a" value="No. First investigate whether outliers are data entry errors measurement errors or genuine extreme values. Only remove if they are clearly erroneous. For genuine outliers consider robust statistical methods or analyze with and without them." />
        <jsp:param name="faq4q" value="What is the Modified Z-score and why use it?" />
        <jsp:param name="faq4a" value="The Modified Z-score uses median and MAD instead of mean and standard deviation. The formula is 0.6745 times x minus median divided by MAD. It is more robust because outliers do not affect the median or MAD as they affect the mean and SD." />
        <jsp:param name="faq5q" value="What are common thresholds for outlier detection?" />
        <jsp:param name="faq5a" value="For IQR method k equals 1.5 is standard for mild outliers and 3.0 for extreme. For Z-score an absolute value greater than 3 is typical. For Modified Z-score the recommended threshold is 3.5 by Iglewicz and Hoaglin." />
        <jsp:param name="faq6q" value="How does the Compare All method work?" />
        <jsp:param name="faq6a" value="Compare All runs IQR Z-score and Modified Z-score simultaneously with default thresholds. Consensus outliers are values flagged by all three methods making them strong candidates for investigation or removal." />
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

    <% request.setAttribute("activeService", "outlier"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <span aria-current="page">Outlier Detection</span>
            </nav>
            <h1>Outlier Detection Calculator</h1>
            <p class="ms-subtitle">IQR · Z-score · modified Z · scatter plot</p>
        </header>

        <div class="ic-stack">

            <div class="ic-hero ic-hero--compact stat-hero" id="stat-hero">
                <div class="ic-hero-top">
                    <button type="button" class="math-ai-tab-btn" id="btnMathAI" title="Math AI — statistics tutor + full math router in chat (Ctrl+Shift+A)">&#10024; AI</button>
                </div>
                <div class="stat-hero-core">
                    <!-- Data Input -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label" for="od-data-input">Data</label>
                                            <textarea class="stat-input-text" id="od-data-input" rows="6" style="font-family:var(--font-mono);resize:vertical;">10, 12, 15, 18, 20, 22, 25, 28, 30, 95</textarea>
                                            <div class="tool-form-hint">Enter numbers separated by commas, spaces, or newlines</div>
                                        </div>
                    
                                        <!-- Mode Toggle -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label">Detection Method</label>
                                            <div class="od-mode-toggle">
                                                <button type="button" class="od-mode-btn active" data-mode="iqr">IQR Method</button>
                                                <button type="button" class="od-mode-btn" data-mode="zscore">Z-Score</button>
                                                <button type="button" class="od-mode-btn" data-mode="modified">Modified Z</button>
                                                <button type="button" class="od-mode-btn" data-mode="all">Compare All</button>
                                            </div>
                                        </div>
                    
                                        <!-- IQR Options -->
                                        <div id="od-options-iqr">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="od-iqr-k">IQR Multiplier (k)</label>
                                                <select class="stat-input-text" id="od-iqr-k" style="min-height:auto;padding:0.5rem 0.75rem;">
                                                    <option value="1.5" selected>1.5 (Standard &mdash; Mild Outliers)</option>
                                                    <option value="3.0">3.0 (Extreme Outliers Only)</option>
                                                    <option value="2.0">2.0 (Moderate)</option>
                                                    <option value="1.0">1.0 (Very Sensitive)</option>
                                                </select>
                                            </div>
                                        </div>
                    
                                        <!-- Z-Score Options -->
                                        <div id="od-options-zscore" style="display:none;">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="od-z-threshold">Z-Score Threshold</label>
                                                <select class="stat-input-text" id="od-z-threshold" style="min-height:auto;padding:0.5rem 0.75rem;">
                                                    <option value="2.0">2.0 (Moderate)</option>
                                                    <option value="2.5">2.5</option>
                                                    <option value="3.0" selected>3.0 (Standard)</option>
                                                    <option value="3.5">3.5 (Conservative)</option>
                                                </select>
                                            </div>
                                        </div>
                    
                                        <!-- Modified Z Options -->
                                        <div id="od-options-modified" style="display:none;">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="od-mad-threshold">Modified Z-Score Threshold</label>
                                                <select class="stat-input-text" id="od-mad-threshold" style="min-height:auto;padding:0.5rem 0.75rem;">
                                                    <option value="2.5">2.5 (Moderate)</option>
                                                    <option value="3.0">3.0 (Standard)</option>
                                                    <option value="3.5" selected>3.5 (Conservative &mdash; Recommended)</option>
                                                    <option value="4.0">4.0 (Very Conservative)</option>
                                                </select>
                                            </div>
                                        </div>
                    
                                        <!-- Buttons -->
                                        <button type="button" class="tool-action-btn" id="od-calc-btn">Detect Outliers</button>
                                        <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                                            <button type="button" class="tool-action-btn" id="od-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                                        </div>
                    
                                        <hr class="stat-sep">
                    
                                        <!-- Quick Examples -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label">Quick Examples</label>
                                            <div class="stat-examples">
                                                <button type="button" class="stat-example-chip" data-od-example="test-scores">Test Scores</button>
                                                <button type="button" class="stat-example-chip" data-od-example="temperatures">Temperatures</button>
                                                <button type="button" class="stat-example-chip" data-od-example="salaries">Salaries</button>
                                                <button type="button" class="stat-example-chip" data-od-example="clean-data">Clean Data</button>
                                            </div>
                                        </div>
                                    </div>
                </div>
            </div>

            <div class="ic-result-card">
                <div class="stat-output-tabs">
                                <button type="button" class="stat-output-tab active" data-tab="od-result-panel">Result</button>
                                <button type="button" class="stat-output-tab" data-tab="od-graph-panel">Scatter Plot</button>
                                <button type="button" class="stat-output-tab" data-tab="od-compiler-panel">Python Compiler</button>
                            </div>
                
                            <div class="stat-panel active" id="od-result-panel">
                                <div class="tool-card tool-result-card">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                                        <h4>Result</h4>
                                    </div>
                                    <div class="tool-result-content" id="od-result-content">
                                        <div class="tool-empty-state">
                                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F50D;</div>
                                            <h3>Enter data and click Detect Outliers</h3>
                                            <p>Identify outliers using IQR, Z-score, or Modified Z-score methods.</p>
                                        </div>
                                    </div>
                                    <div class="tool-result-actions" id="od-result-actions"></div>
                                </div>
                            </div>
                
                            <div class="stat-panel" id="od-graph-panel">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><path d="M3 3v18h18"/><path d="M7 16l4-8 4 4 4-6"/></svg>
                                        <h4>Scatter Plot</h4>
                                    </div>
                                    <div style="flex:1;padding:1rem;min-height:300px;">
                                        <div id="od-graph-container"></div>
                                    </div>
                                </div>
                            </div>
                
                            <div class="stat-panel" id="od-compiler-panel">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                                        <h4>Python Compiler</h4>
                                    </div>
                                    <div style="flex:1;min-height:0;">
                                        <iframe id="od-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                                    </div>
                                </div>
                            </div>
            </div>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
        </div>

<jsp:include page="modern/components/related-tools.jsp">
<jsp:param name="currentToolUrl" value="outlier-detection-calculator.jsp"/>
        <jsp:param name="keyword" value="statistics"/>
        <jsp:param name="limit" value="6"/>
</jsp:include>

        <section class="tool-expertise-section ms-below-fold" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
        
                <!-- 1. What Is an Outlier? -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Is an Outlier?</h2>
                    <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">An <strong>outlier</strong> is a data point that differs significantly from other observations. Outliers can arise from measurement errors, data entry mistakes, or genuine extreme values. Detecting them is critical for data quality and accurate statistical analysis.</p>
        
                    <div class="stat-edu-grid" style="margin-top:1rem;">
                        <div class="stat-feature-card stat-anim stat-anim-d1">
                            <div style="font-size:1.5rem;">&#x1F4CA;</div>
                            <h4>Data Quality</h4>
                            <p>Outliers can skew means, inflate standard deviations, and distort regression models. Identifying them improves the reliability of your analysis.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d2">
                            <div style="font-size:1.5rem;">&#x26A0;&#xFE0F;</div>
                            <h4>Error Detection</h4>
                            <p>Many outliers result from typos, sensor malfunctions, or recording errors. Flagging them helps catch mistakes before they propagate.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d3">
                            <div style="font-size:1.5rem;">&#x2B50;</div>
                            <h4>Genuine Extremes</h4>
                            <p>Some outliers are real &mdash; record temperatures, viral posts, or rare events. These may be the most interesting data points to study.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 2. IQR Method (Tukey's Fences) -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">IQR Method (Tukey&rsquo;s Fences)</h2>
        
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>Lower Fence</strong> = Q1 &minus; k &times; IQR &nbsp;&nbsp;&nbsp; <strong>Upper Fence</strong> = Q3 + k &times; IQR
                    </div>
                    <div class="stat-formula-box" style="margin-bottom:1rem;">
                        <strong>IQR</strong> = Q3 &minus; Q1 &nbsp;&nbsp;(Interquartile Range)
                    </div>
        
                    <div class="stat-worked-example" style="margin-bottom:1rem;">
                        <strong>Worked Example:</strong> Data: 2, 4, 5, 7, 8, 9, 10, 12, 50 with k = 1.5
                        <div style="margin-top:0.5rem;padding-left:1rem;border-left:3px solid var(--tool-primary);color:var(--text-secondary);font-size:0.875rem;">
                            Q1 = 4.5, Q3 = 10.5, IQR = 6.0<br>
                            Lower Fence = 4.5 &minus; 1.5 &times; 6 = &minus;4.5<br>
                            Upper Fence = 10.5 + 1.5 &times; 6 = 19.5<br>
                            Outlier: <strong>50</strong> (above upper fence of 19.5)
                        </div>
                    </div>
        
                    <p style="color:var(--text-secondary);font-size:0.875rem;line-height:1.7;margin-bottom:1rem;"><strong>Advantages:</strong> Distribution-free (no normality assumption), robust to extreme values, widely used in exploratory data analysis and box plots.</p>
        
                    <!-- SVG: Box Plot Diagram -->
                    <div style="text-align:center;margin:1.5rem 0;">
                        <svg viewBox="0 0 440 120" style="max-width:440px;width:100%;" aria-label="Box plot diagram showing Q1, Q2, Q3, whiskers, and outlier points">
                            <!-- Axis -->
                            <line x1="20" y1="90" x2="420" y2="90" stroke="var(--border-dark,#cbd5e1)" stroke-width="1.5"/>
                            <!-- Whisker left -->
                            <line x1="60" y1="50" x2="130" y2="50" stroke="var(--text-secondary,#475569)" stroke-width="2"/>
                            <line x1="60" y1="40" x2="60" y2="60" stroke="var(--text-secondary,#475569)" stroke-width="2"/>
                            <!-- Box -->
                            <rect x="130" y="35" width="120" height="30" fill="var(--tool-light)" stroke="#e11d48" stroke-width="2" rx="3"/>
                            <!-- Median line -->
                            <line x1="190" y1="35" x2="190" y2="65" stroke="#e11d48" stroke-width="3"/>
                            <!-- Whisker right -->
                            <line x1="250" y1="50" x2="320" y2="50" stroke="var(--text-secondary,#475569)" stroke-width="2"/>
                            <line x1="320" y1="40" x2="320" y2="60" stroke="var(--text-secondary,#475569)" stroke-width="2"/>
                            <!-- Outlier points -->
                            <circle cx="370" cy="50" r="6" fill="none" stroke="#ef4444" stroke-width="2"/>
                            <circle cx="395" cy="50" r="6" fill="none" stroke="#ef4444" stroke-width="2"/>
                            <!-- Labels -->
                            <text x="60" y="80" text-anchor="middle" font-size="10" fill="var(--text-muted,#94a3b8)">Min</text>
                            <text x="130" y="80" text-anchor="middle" font-size="10" fill="var(--text-secondary,#475569)" font-weight="600">Q1</text>
                            <text x="190" y="80" text-anchor="middle" font-size="10" fill="#e11d48" font-weight="600">Q2</text>
                            <text x="250" y="80" text-anchor="middle" font-size="10" fill="var(--text-secondary,#475569)" font-weight="600">Q3</text>
                            <text x="320" y="80" text-anchor="middle" font-size="10" fill="var(--text-muted,#94a3b8)">Max</text>
                            <text x="382" y="30" text-anchor="middle" font-size="10" fill="#ef4444" font-weight="600">Outliers</text>
                            <!-- Fence labels -->
                            <text x="40" y="105" text-anchor="middle" font-size="9" fill="var(--text-muted,#94a3b8)">Lower Fence</text>
                            <text x="340" y="105" text-anchor="middle" font-size="9" fill="var(--text-muted,#94a3b8)">Upper Fence</text>
                        </svg>
                    </div>
                </div>
        
                <!-- 3. Z-Score Method -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Z-Score Method</h2>
        
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>Z-Score:</strong>&nbsp; Z = (x &minus; &mu;) / &sigma; &nbsp;&nbsp;&nbsp; Outlier if |Z| &gt; threshold
                    </div>
        
                    <p style="color:var(--text-secondary);font-size:0.875rem;line-height:1.7;margin-bottom:0.75rem;">The Z-score measures how many standard deviations a data point is from the mean. A common threshold is |Z| &gt; 3, meaning the value is more than 3 standard deviations away from the average.</p>
        
                    <div style="display:grid;grid-template-columns:1fr 1fr;gap:1rem;margin-top:1rem;">
                        <div style="padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border-left:3px solid var(--success);">
                            <p style="margin:0;font-size:0.8125rem;color:var(--text-secondary);line-height:1.6;">
                                <strong style="color:var(--success);">Pros:</strong> Simple, intuitive, works well for normally distributed data. Easy to interpret &mdash; Z = 2.5 means 2.5 standard deviations from the mean.
                            </p>
                        </div>
                        <div style="padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border-left:3px solid var(--error);">
                            <p style="margin:0;font-size:0.8125rem;color:var(--text-secondary);line-height:1.6;">
                                <strong style="color:var(--error);">Cons:</strong> Sensitive to outliers themselves (masking effect). The mean and SD are pulled toward outliers, making them harder to detect.
                            </p>
                        </div>
                    </div>
                </div>
        
                <!-- 4. Modified Z-Score (MAD) -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Modified Z-Score (MAD)</h2>
        
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>Modified Z-Score:</strong>&nbsp; M = 0.6745 &times; (x &minus; median) / MAD
                    </div>
                    <div class="stat-formula-box" style="margin-bottom:1rem;">
                        <strong>MAD</strong> = median(|x<sub>i</sub> &minus; median(x)|) &nbsp;&nbsp;(Median Absolute Deviation)
                    </div>
        
                    <div style="padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border-left:3px solid var(--info);margin-bottom:1rem;">
                        <p style="margin:0;font-size:0.8125rem;color:var(--text-secondary);line-height:1.6;">
                            <strong>Why 0.6745?</strong> This constant is the 0.75th quantile of the standard normal distribution. It scales the MAD so that it is a consistent estimator of the standard deviation for normally distributed data, making the modified Z-score comparable to the regular Z-score.
                        </p>
                    </div>
        
                    <p style="color:var(--text-secondary);font-size:0.875rem;line-height:1.7;"><strong>Advantages:</strong> Very robust &mdash; the median and MAD are not affected by outliers (unlike mean and SD). Works well with small samples, skewed distributions, and datasets with many outliers. Recommended threshold: 3.5 (Iglewicz &amp; Hoaglin).</p>
                </div>
        
                <!-- 5. Which Method to Choose? -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Which Method to Choose?</h2>
        
                    <table class="stat-ops-table">
                        <thead><tr><th>Scenario</th><th>Recommended Method</th></tr></thead>
                        <tbody>
                            <tr><td>General purpose</td><td style="font-weight:600;">IQR (k = 1.5)</td></tr>
                            <tr><td>Normal distribution assumed</td><td style="font-weight:600;">Z-Score (threshold = 3)</td></tr>
                            <tr><td>Skewed data</td><td style="font-weight:600;">IQR or Modified Z-Score</td></tr>
                            <tr><td>Small sample size</td><td style="font-weight:600;">Modified Z-Score (MAD)</td></tr>
                            <tr><td>Many outliers suspected</td><td style="font-weight:600;">Modified Z-Score (MAD)</td></tr>
                            <tr><td>Conservative detection</td><td style="font-weight:600;">IQR (k = 3.0)</td></tr>
                        </tbody>
                    </table>
        
                    <div style="margin-top:1.25rem;padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border-left:3px solid var(--warning);">
                        <p style="margin:0 0 0.5rem;font-size:0.875rem;font-weight:600;color:var(--text-primary);">What to Do with Outliers</p>
                        <ul style="margin:0;padding-left:1.25rem;font-size:0.8125rem;color:var(--text-secondary);line-height:1.8;">
                            <li><strong>Investigate:</strong> Determine why the value is extreme before taking action</li>
                            <li><strong>Correct:</strong> Fix data entry or measurement errors</li>
                            <li><strong>Remove:</strong> Delete only if clearly erroneous</li>
                            <li><strong>Transform:</strong> Apply log or winsorization to reduce impact</li>
                            <li><strong>Keep:</strong> Retain genuine extreme values and use robust methods</li>
                            <li><strong>Separate Analysis:</strong> Analyze with and without outliers to assess their influence</li>
                        </ul>
                    </div>
                </div>
        
                <!-- 6. Frequently Asked Questions -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
                    <div class="faq-item">
                        <button class="faq-question">Which outlier detection method should I use?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Use IQR with k = 1.5 for general-purpose robust detection. Use Z-score for normally distributed data. Use Modified Z-score (MAD) for small samples or when you suspect many outliers. Use Compare All to see consensus across all three methods.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What is the IQR method for outlier detection?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">The IQR method uses Tukey fences. Values below Q1 &minus; k &times; IQR or above Q3 + k &times; IQR are classified as outliers. With k = 1.5, these are mild outliers; with k = 3.0, only extreme outliers are flagged.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">Should I always remove outliers from my data?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">No. First investigate whether outliers are data entry errors, measurement errors, or genuine extreme values. Only remove if they are clearly erroneous. For genuine outliers, consider robust statistical methods or analyze with and without them.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What is the Modified Z-score and why use it?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">The Modified Z-score uses the median and MAD instead of the mean and standard deviation. The formula is 0.6745 &times; (x &minus; median) / MAD. It is more robust because outliers do not affect the median or MAD the way they affect the mean and SD.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What are common thresholds for outlier detection?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">For the IQR method, k = 1.5 is standard for mild outliers and k = 3.0 for extreme. For Z-score, |Z| &gt; 3 is typical. For Modified Z-score, the recommended threshold is 3.5 (Iglewicz &amp; Hoaglin).</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">How does the Compare All method work?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Compare All runs IQR, Z-score, and Modified Z-score simultaneously with their default thresholds. Consensus outliers are values flagged by all three methods, making them strong candidates for investigation or removal.</div>
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
    <script src="<%=request.getContextPath()%>/js/outlier-detection-core.js?v=<%=v%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/categories-menu.js" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=v%>" defer></script>

<script>window.__MS_STAT_PAGE__ = { key: 'outlier', label: "Outlier Detection Calculator" };</script>
<%
    request.setAttribute("mathAiButtonId", "btnMathAI");
    request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
    request.setAttribute("mathAiProfileExport", "configureStatisticsMathShell");
%>
<%@ include file="modern/components/math-ai-boot.inc.jsp" %>
</body>
</html>
