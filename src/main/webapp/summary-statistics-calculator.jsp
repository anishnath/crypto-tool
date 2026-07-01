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
        <jsp:param name="toolName" value="Summary Statistics Calculator Online - Instant Results Free" />
        <jsp:param name="toolDescription" value="Paste your data for instant mean, median, mode, standard deviation, variance, quartiles, skewness and kurtosis. Interactive histogram and box plot included." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="summary-statistics-calculator.jsp" />
        <jsp:param name="toolKeywords" value="summary statistics calculator, descriptive statistics calculator, mean median mode calculator, standard deviation calculator online, variance calculator, quartiles calculator, IQR calculator, skewness kurtosis, data analysis tool, free statistics calculator" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Mean median mode calculation,Standard deviation and variance (sample and population),Quartiles IQR five-number summary,Skewness and kurtosis with interpretation,Frequency distribution table,Interactive Plotly histogram and box plot,Python scipy code generation,LaTeX export and share URL" />
        <jsp:param name="teaches" value="Descriptive statistics, measures of central tendency, measures of dispersion, distribution shape analysis, box plot interpretation, outlier detection" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Enter Data|Paste numbers separated by commas spaces or newlines,Choose Options|Toggle histogram box plot and frequency table,Click Calculate|Get instant descriptive statistics,Review Results|See mean median mode SD variance quartiles,Explore Graph|View interactive histogram and box plot,Export Results|Copy LaTeX share URL or run Python code" />
        <jsp:param name="faq1q" value="What is the difference between sample and population standard deviation?" />
        <jsp:param name="faq1a" value="Sample standard deviation divides by n-1 (Bessel correction) because a sample underestimates variability. Population standard deviation divides by n because you have all data points. Use sample SD when analyzing a subset; use population SD when you have the entire dataset." />
        <jsp:param name="faq2q" value="How do I interpret skewness and kurtosis?" />
        <jsp:param name="faq2a" value="Skewness measures asymmetry: 0 means symmetric, positive means right-skewed (long right tail), negative means left-skewed. Kurtosis measures tail weight: 0 (excess) is normal, positive means heavier tails (leptokurtic), negative means lighter tails (platykurtic). Values between -0.5 and 0.5 are approximately symmetric or normal." />
        <jsp:param name="faq3q" value="What are quartiles and how are they calculated?" />
        <jsp:param name="faq3a" value="Quartiles divide sorted data into four equal parts. Q1 (25th percentile) has 25 percent of data below it. Q2 is the median. Q3 (75th percentile) has 75 percent below. The IQR (Q3 minus Q1) measures the spread of the middle 50 percent and is used for outlier detection." />
        <jsp:param name="faq4q" value="When should I use mean vs median?" />
        <jsp:param name="faq4a" value="Use the mean for symmetric data without outliers since it uses all values efficiently. Use the median for skewed data or data with outliers since it is resistant to extreme values. For example, median income is preferred over mean income because a few billionaires skew the mean upward." />
        <jsp:param name="faq5q" value="What does coefficient of variation tell you?" />
        <jsp:param name="faq5a" value="The coefficient of variation (CV) is the standard deviation divided by the mean, expressed as a percentage. It measures relative variability, allowing you to compare spread between datasets with different units or scales. A CV below 15 percent generally indicates low variability." />
        <jsp:param name="faq6q" value="How do I identify outliers in my data?" />
        <jsp:param name="faq6a" value="The IQR method flags values below Q1 minus 1.5 times IQR or above Q3 plus 1.5 times IQR as outliers. The z-score method flags values more than 2 or 3 standard deviations from the mean. Always investigate outliers before removing them as they may represent real phenomena." />
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

    <% request.setAttribute("activeService", "summary-stats"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <span aria-current="page">Summary Statistics</span>
            </nav>
            <h1>Summary Statistics Calculator</h1>
            <p class="ms-subtitle">Mean · median · mode · SD · quartiles · histogram</p>
        </header>

        <div class="ic-stack">

            <div class="ic-hero ic-hero--compact stat-hero" id="stat-hero">
                <div class="ic-hero-top">
                    <button type="button" class="math-ai-tab-btn" id="btnMathAI" title="Math AI — statistics tutor + full math router in chat (Ctrl+Shift+A)">&#10024; AI</button>
                </div>
                <div class="stat-hero-core">
                    <!-- Data Input -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label" for="stat-data-input">Data Input</label>
                                            <textarea class="stat-input-text" id="stat-data-input" rows="8" placeholder="85, 90, 78, 92, 88, 76, 95, 82, 87, 91, 89, 84, 93, 79, 86" spellcheck="false">85, 90, 78, 92, 88, 76, 95, 82, 87, 91, 89, 84, 93, 79, 86</textarea>
                                            <div class="tool-form-hint">Enter numbers separated by commas, spaces, or newlines</div>
                                        </div>
                    
                                        <!-- Preview -->
                                        <div class="tool-form-group">
                                            <div class="stat-preview" id="stat-preview"><span style="color:var(--text-muted);">Enter data above&hellip;</span></div>
                                        </div>
                    
                                        <!-- Options -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label">Display Options</label>
                                            <div class="stat-checkbox-group">
                                                <label class="stat-checkbox">
                                                    <input type="checkbox" id="stat-chk-histogram" checked>
                                                    Show Histogram
                                                </label>
                                                <label class="stat-checkbox">
                                                    <input type="checkbox" id="stat-chk-boxplot" checked>
                                                    Show Box Plot
                                                </label>
                                                <label class="stat-checkbox">
                                                    <input type="checkbox" id="stat-chk-frequency" checked>
                                                    Show Frequency Table
                                                </label>
                                            </div>
                                        </div>
                    
                                        <!-- Buttons -->
                                        <button type="button" class="tool-action-btn" id="stat-calc-btn">Calculate Statistics</button>
                                        <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                                            <button type="button" class="tool-action-btn" id="stat-random-btn" style="background:var(--bg-secondary);color:var(--tool-primary);border:1.5px solid var(--tool-primary);flex:1;">&#x1F3B2; Random</button>
                                            <button type="button" class="tool-action-btn" id="stat-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                                        </div>
                    
                                        <hr class="stat-sep">
                    
                                        <!-- Quick Examples -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label">Quick Examples</label>
                                            <div class="stat-examples">
                                                <button type="button" class="stat-example-chip" data-example="test-scores">Test Scores</button>
                                                <button type="button" class="stat-example-chip" data-example="heights">Heights (cm)</button>
                                                <button type="button" class="stat-example-chip" data-example="temperatures">Temperatures</button>
                                                <button type="button" class="stat-example-chip" data-example="stock-returns">Stock Returns</button>
                                                <button type="button" class="stat-example-chip" data-example="survey">Survey Data</button>
                                            </div>
                                        </div>
                                    </div>
                </div>
            </div>

            <div class="ic-result-card">
                <div class="stat-output-tabs">
                                <button type="button" class="stat-output-tab active" data-panel="result">Result</button>
                                <button type="button" class="stat-output-tab" data-panel="graph">Graph</button>
                                <button type="button" class="stat-output-tab" data-panel="python">Python Compiler</button>
                            </div>
                
                            <!-- Result Panel -->
                            <div class="stat-panel active" id="stat-panel-result">
                                <div class="tool-card tool-result-card">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                                        <h4>Result</h4>
                                    </div>
                                    <div class="tool-result-content" id="stat-result-content">
                                        <div class="tool-empty-state">
                                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F4CA;</div>
                                            <h3>Enter data and click Calculate</h3>
                                            <p>Paste numbers separated by commas, spaces, or newlines for instant descriptive statistics.</p>
                                        </div>
                                    </div>
                                    <div class="tool-result-actions" id="stat-result-actions"></div>
                                </div>
                            </div>
                
                            <!-- Graph Panel -->
                            <div class="stat-panel" id="stat-panel-graph">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
                                        <h4>Interactive Charts</h4>
                                    </div>
                                    <div style="flex:1;min-height:0;padding:0.75rem;overflow-y:auto;" id="stat-graph-content">
                                        <div class="tool-empty-state"><div style="font-size:2rem;opacity:0.5;">&#x1F4C8;</div><h3>No graph yet</h3><p>Calculate statistics to see interactive charts.</p></div>
                                    </div>
                                </div>
                            </div>
                
                            <!-- Python Compiler Panel -->
                            <div class="stat-panel" id="stat-panel-python">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                                        <h4>Python Compiler</h4>
                                    </div>
                                    <div style="flex:1;min-height:0;">
                                        <iframe id="stat-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                                    </div>
                                </div>
                            </div>
            </div>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
        </div>

<jsp:include page="modern/components/related-tools.jsp">
<jsp:param name="currentToolUrl" value="summary-statistics-calculator.jsp"/>
        <jsp:param name="keyword" value="statistics"/>
        <jsp:param name="limit" value="6"/>
</jsp:include>

        <section class="tool-expertise-section ms-below-fold" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
        
                <!-- 1. What Are Summary Statistics? -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Are Summary Statistics?</h2>
                    <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">Summary statistics (also called <strong>descriptive statistics</strong>) condense a dataset into a handful of meaningful numbers. Instead of looking at hundreds of raw values, you get three key aspects: <em>where</em> the data centers, <em>how spread out</em> it is, and <em>what shape</em> the distribution takes.</p>
        
                    <!-- Animated SVG: Data funnel -->
                    <svg viewBox="0 0 560 120" xmlns="http://www.w3.org/2000/svg" class="stat-data-flow" style="max-width:540px;width:100%;margin:1rem 0;">
                        <rect x="0" y="0" width="560" height="120" rx="8" fill="var(--bg-secondary,#f8fafc)"/>
                        <!-- Data dots flowing in -->
                        <circle class="data-dot" cx="60" cy="30" r="4" fill="#e11d48" style="animation-delay:0s;"/>
                        <circle class="data-dot" cx="100" cy="50" r="4" fill="#e11d48" style="animation-delay:0.3s;"/>
                        <circle class="data-dot" cx="80" cy="70" r="4" fill="#e11d48" style="animation-delay:0.6s;"/>
                        <circle class="data-dot" cx="120" cy="40" r="4" fill="#e11d48" style="animation-delay:0.9s;"/>
                        <circle class="data-dot" cx="50" cy="85" r="4" fill="#e11d48" style="animation-delay:1.2s;"/>
                        <!-- Funnel -->
                        <polygon points="160,15 280,15 250,105 190,105" fill="none" stroke="#e11d48" stroke-width="2"/>
                        <text x="220" y="65" text-anchor="middle" font-size="10" fill="#e11d48" font-weight="600">Analysis</text>
                        <!-- Output labels -->
                        <text x="340" y="35" font-size="11" fill="var(--text-primary,#0f172a)" font-weight="600">Mean = 85.67</text>
                        <text x="340" y="58" font-size="11" fill="var(--text-primary,#0f172a)" font-weight="600">SD = 5.46</text>
                        <text x="340" y="81" font-size="11" fill="var(--text-primary,#0f172a)" font-weight="600">Q1, Q2, Q3</text>
                        <text x="340" y="104" font-size="11" fill="var(--text-primary,#0f172a)" font-weight="600">Skew = &minus;0.12</text>
                    </svg>
        
                    <div class="stat-edu-grid">
                        <div class="stat-feature-card stat-anim stat-anim-d1">
                            <div style="font-size:1.5rem;">&#x1F3AF;</div>
                            <h4>Central Tendency</h4>
                            <p>Mean, median, and mode tell you where the &ldquo;center&rdquo; of your data lies &mdash; the typical or representative value.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d2">
                            <div style="font-size:1.5rem;">&#x2194;&#xFE0F;</div>
                            <h4>Dispersion</h4>
                            <p>Range, variance, standard deviation, and IQR measure how spread out values are around the center.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d3">
                            <div style="font-size:1.5rem;">&#x1F4C8;</div>
                            <h4>Distribution Shape</h4>
                            <p>Skewness and kurtosis reveal whether data is symmetric, skewed, or has heavy/light tails.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 2. Measures of Central Tendency -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Measures of Central Tendency</h2>
        
                    <div class="stat-formula-box">
                        <strong>Mean:</strong>&nbsp; x&#772; = &Sigma;x<sub>i</sub> / n
                    </div>
                    <p style="color:var(--text-secondary);margin:0.5rem 0 0.75rem;line-height:1.7;">The <strong>arithmetic mean</strong> sums all values and divides by the count. It uses every data point, making it sensitive to outliers.</p>
        
                    <div class="stat-formula-box">
                        <strong>Median:</strong>&nbsp; Middle value when data is sorted
                    </div>
                    <p style="color:var(--text-secondary);margin:0.5rem 0 0.75rem;line-height:1.7;">The <strong>median</strong> is the middle value of sorted data. For even n, it averages the two middle values. Resistant to outliers.</p>
        
                    <div class="stat-formula-box">
                        <strong>Mode:</strong>&nbsp; Most frequently occurring value(s)
                    </div>
                    <p style="color:var(--text-secondary);margin:0.5rem 0 1rem;line-height:1.7;">The <strong>mode</strong> is the value that appears most often. Data can be unimodal, bimodal, multimodal, or have no mode.</p>
        
                    <h3 style="font-size:1rem;margin:1rem 0 0.5rem;color:var(--text-primary);">When to Use Each Measure</h3>
                    <table class="stat-ops-table">
                        <thead><tr><th>Measure</th><th>Best For</th><th>Limitation</th></tr></thead>
                        <tbody>
                            <tr><td style="font-family:var(--font-sans);font-weight:500;">Mean</td><td>Symmetric data, no outliers</td><td>Distorted by extreme values</td></tr>
                            <tr><td style="font-family:var(--font-sans);font-weight:500;">Median</td><td>Skewed data, outliers present</td><td>Ignores actual values of extremes</td></tr>
                            <tr><td style="font-family:var(--font-sans);font-weight:500;">Mode</td><td>Categorical data, finding peaks</td><td>May not exist or be unique</td></tr>
                        </tbody>
                    </table>
                </div>
        
                <!-- 3. Measures of Dispersion -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Measures of Dispersion</h2>
        
                    <div class="stat-formula-box">
                        <strong>Variance:</strong>&nbsp; s&sup2; = &Sigma;(x<sub>i</sub> &minus; x&#772;)&sup2; / (n &minus; 1)
                    </div>
                    <div class="stat-formula-box">
                        <strong>Standard Deviation:</strong>&nbsp; s = &radic;s&sup2;
                    </div>
                    <div class="stat-formula-box">
                        <strong>Range:</strong>&nbsp; max &minus; min &nbsp;&nbsp; | &nbsp;&nbsp; <strong>IQR:</strong>&nbsp; Q3 &minus; Q1
                    </div>
        
                    <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">Worked Example</h3>
                    <div class="stat-worked-example">
                        <strong>Data:</strong> [2, 4, 4, 4, 5, 5, 7, 9]<br>
                        <strong>Step 1:</strong> Mean = (2+4+4+4+5+5+7+9)/8 = 40/8 = <span style="color:var(--stat-tool);font-weight:700;">5</span><br>
                        <strong>Step 2:</strong> Deviations from mean: &minus;3, &minus;1, &minus;1, &minus;1, 0, 0, 2, 4<br>
                        <strong>Step 3:</strong> Squared deviations: 9, 1, 1, 1, 0, 0, 4, 16<br>
                        <strong>Step 4:</strong> Sum of squares = 32<br>
                        <strong>Step 5:</strong> Variance (sample) = 32/(8&minus;1) = <span style="color:var(--stat-tool);font-weight:700;">4.5714</span><br>
                        <strong>Step 6:</strong> SD = &radic;4.5714 = <span style="color:var(--stat-tool);font-weight:700;">2.1381</span>
                    </div>
        
                    <!-- Animated bell curve with sigma markers -->
                    <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">The 68&ndash;95&ndash;99.7 Rule (Empirical Rule)</h3>
                    <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">For normally distributed data:</p>
                    <svg viewBox="0 0 560 180" xmlns="http://www.w3.org/2000/svg" class="stat-bell-animated" style="max-width:540px;width:100%;margin:0.5rem 0 1rem;">
                        <rect x="0" y="0" width="560" height="180" rx="8" fill="var(--bg-secondary,#f8fafc)"/>
                        <!-- Bell curve path -->
                        <path class="bell-path" d="M 40,150 C 40,150 80,148 120,140 C 160,130 190,100 220,65 C 240,42 260,22 280,15 C 300,22 320,42 340,65 C 370,100 400,130 440,140 C 480,148 520,150 520,150" fill="none" stroke="#e11d48" stroke-width="2.5"/>
                        <!-- Fill under curve -->
                        <path d="M 40,150 C 40,150 80,148 120,140 C 160,130 190,100 220,65 C 240,42 260,22 280,15 C 300,22 320,42 340,65 C 370,100 400,130 440,140 C 480,148 520,150 520,150 Z" fill="rgba(225,29,72,0.08)"/>
                        <!-- Sigma lines -->
                        <line x1="280" y1="15" x2="280" y2="155" stroke="#94a3b8" stroke-width="1" stroke-dasharray="4,3"/>
                        <line x1="180" y1="80" x2="180" y2="155" stroke="#10b981" stroke-width="1" stroke-dasharray="4,3"/>
                        <line x1="380" y1="80" x2="380" y2="155" stroke="#10b981" stroke-width="1" stroke-dasharray="4,3"/>
                        <line x1="100" y1="142" x2="100" y2="155" stroke="#f59e0b" stroke-width="1" stroke-dasharray="4,3"/>
                        <line x1="460" y1="142" x2="460" y2="155" stroke="#f59e0b" stroke-width="1" stroke-dasharray="4,3"/>
                        <!-- Labels -->
                        <text x="280" y="172" text-anchor="middle" font-size="9" fill="var(--text-muted,#94a3b8)">&mu;</text>
                        <text x="180" y="172" text-anchor="middle" font-size="9" fill="#10b981">&minus;1&sigma;</text>
                        <text x="380" y="172" text-anchor="middle" font-size="9" fill="#10b981">+1&sigma;</text>
                        <text x="100" y="172" text-anchor="middle" font-size="9" fill="#f59e0b">&minus;2&sigma;</text>
                        <text x="460" y="172" text-anchor="middle" font-size="9" fill="#f59e0b">+2&sigma;</text>
                        <!-- Percentage brackets -->
                        <text x="280" y="98" text-anchor="middle" font-size="11" fill="#10b981" font-weight="600">68.3%</text>
                        <text x="280" y="130" text-anchor="middle" font-size="10" fill="#f59e0b" font-weight="500">95.4%</text>
                    </svg>
                </div>
        
                <!-- 4. Understanding Distribution Shape -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Understanding Distribution Shape</h2>
        
                    <h3 style="font-size:1rem;margin:0 0 0.75rem;color:var(--text-primary);">Skewness</h3>
                    <svg viewBox="0 0 560 140" xmlns="http://www.w3.org/2000/svg" style="max-width:540px;width:100%;margin:0.5rem 0 1rem;">
                        <rect x="0" y="0" width="560" height="140" rx="8" fill="var(--bg-secondary,#f8fafc)"/>
                        <!-- Left-skewed -->
                        <path d="M 20,110 C 20,110 40,108 60,95 C 80,75 100,30 130,18 C 145,22 155,50 165,80 C 170,95 175,108 180,110 Z" fill="rgba(225,29,72,0.15)" stroke="#e11d48" stroke-width="1.5"/>
                        <text x="100" y="130" text-anchor="middle" font-size="10" fill="var(--text-primary,#0f172a)" font-weight="600">Left-Skewed</text>
                        <text x="100" y="10" text-anchor="middle" font-size="8" fill="var(--text-muted,#94a3b8)">skew &lt; 0</text>
                        <!-- Symmetric -->
                        <path d="M 210,110 C 210,110 240,105 260,70 C 270,45 275,22 280,18 C 285,22 290,45 300,70 C 320,105 350,110 350,110 Z" fill="rgba(16,185,129,0.15)" stroke="#10b981" stroke-width="1.5"/>
                        <text x="280" y="130" text-anchor="middle" font-size="10" fill="var(--text-primary,#0f172a)" font-weight="600">Symmetric</text>
                        <text x="280" y="10" text-anchor="middle" font-size="8" fill="var(--text-muted,#94a3b8)">skew &asymp; 0</text>
                        <!-- Right-skewed -->
                        <path d="M 380,110 C 385,108 390,95 395,80 C 400,50 410,22 430,18 C 460,30 480,75 500,95 C 520,108 540,110 540,110 Z" fill="rgba(245,158,11,0.15)" stroke="#f59e0b" stroke-width="1.5"/>
                        <text x="460" y="130" text-anchor="middle" font-size="10" fill="var(--text-primary,#0f172a)" font-weight="600">Right-Skewed</text>
                        <text x="460" y="10" text-anchor="middle" font-size="8" fill="var(--text-muted,#94a3b8)">skew &gt; 0</text>
                    </svg>
        
                    <table class="stat-ops-table">
                        <thead><tr><th>|Skewness|</th><th>Interpretation</th></tr></thead>
                        <tbody>
                            <tr><td>&lt; 0.5</td><td style="font-family:var(--font-sans);">Approximately symmetric</td></tr>
                            <tr><td>0.5 &ndash; 1.0</td><td style="font-family:var(--font-sans);">Moderately skewed</td></tr>
                            <tr><td>&gt; 1.0</td><td style="font-family:var(--font-sans);">Highly skewed</td></tr>
                        </tbody>
                    </table>
        
                    <h3 style="font-size:1rem;margin:1.25rem 0 0.75rem;color:var(--text-primary);">Kurtosis</h3>
                    <div class="stat-edu-grid">
                        <div class="stat-edu-card stat-anim stat-anim-d1">
                            <h4>Mesokurtic (k &asymp; 0)</h4>
                            <p>Normal distribution shape. Tails contain roughly the expected proportion of data.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d2">
                            <h4>Leptokurtic (k &gt; 0)</h4>
                            <p>Peaked with heavy tails. More extreme values (outliers) than normal. Example: stock returns.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d3">
                            <h4>Platykurtic (k &lt; 0)</h4>
                            <p>Flat with light tails. Fewer extreme values than normal. Example: uniform-like data.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 5. Quartiles & Box Plots -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Quartiles &amp; Box Plots</h2>
        
                    <!-- Box plot diagram SVG -->
                    <svg viewBox="0 0 560 140" xmlns="http://www.w3.org/2000/svg" style="max-width:540px;width:100%;margin:0.5rem 0 1rem;">
                        <rect x="0" y="0" width="560" height="140" rx="8" fill="var(--bg-secondary,#f8fafc)"/>
                        <!-- Whiskers -->
                        <line x1="80" y1="60" x2="160" y2="60" stroke="var(--text-primary,#0f172a)" stroke-width="1.5"/>
                        <line x1="400" y1="60" x2="480" y2="60" stroke="var(--text-primary,#0f172a)" stroke-width="1.5"/>
                        <!-- Whisker caps -->
                        <line x1="80" y1="45" x2="80" y2="75" stroke="var(--text-primary,#0f172a)" stroke-width="1.5"/>
                        <line x1="480" y1="45" x2="480" y2="75" stroke="var(--text-primary,#0f172a)" stroke-width="1.5"/>
                        <!-- Box -->
                        <rect x="160" y="35" width="240" height="50" fill="rgba(225,29,72,0.15)" stroke="#e11d48" stroke-width="2" rx="3"/>
                        <!-- Median line -->
                        <line x1="280" y1="35" x2="280" y2="85" stroke="#e11d48" stroke-width="2.5"/>
                        <!-- Outlier -->
                        <circle cx="520" cy="60" r="4" fill="none" stroke="#ef4444" stroke-width="1.5"/>
                        <!-- Labels -->
                        <text x="80" y="105" text-anchor="middle" font-size="9" fill="var(--text-muted,#94a3b8)" font-weight="500">Min</text>
                        <text x="160" y="105" text-anchor="middle" font-size="9" fill="#e11d48" font-weight="600">Q1</text>
                        <text x="280" y="105" text-anchor="middle" font-size="9" fill="#e11d48" font-weight="600">Q2 (Median)</text>
                        <text x="400" y="105" text-anchor="middle" font-size="9" fill="#e11d48" font-weight="600">Q3</text>
                        <text x="480" y="105" text-anchor="middle" font-size="9" fill="var(--text-muted,#94a3b8)" font-weight="500">Max</text>
                        <text x="520" y="105" text-anchor="middle" font-size="9" fill="#ef4444" font-weight="500">Outlier</text>
                        <!-- IQR bracket -->
                        <line x1="160" y1="120" x2="400" y2="120" stroke="#e11d48" stroke-width="1"/>
                        <line x1="160" y1="116" x2="160" y2="124" stroke="#e11d48" stroke-width="1"/>
                        <line x1="400" y1="116" x2="400" y2="124" stroke="#e11d48" stroke-width="1"/>
                        <text x="280" y="134" text-anchor="middle" font-size="10" fill="#e11d48" font-weight="600">IQR = Q3 &minus; Q1</text>
                    </svg>
        
                    <div class="stat-formula-box">
                        <strong>Five-Number Summary:</strong>&nbsp; Min, Q1, Median, Q3, Max
                    </div>
                    <div class="stat-formula-box">
                        <strong>Outlier Detection:</strong>&nbsp; value &lt; Q1 &minus; 1.5&times;IQR &nbsp;or&nbsp; value &gt; Q3 + 1.5&times;IQR
                    </div>
        
                    <p style="color:var(--text-secondary);margin:0.75rem 0;line-height:1.7;">The <strong>box plot</strong> (box-and-whisker) visualizes the five-number summary. The box spans Q1 to Q3 (the middle 50% of data), the line inside marks the median, and whiskers extend to the most extreme non-outlier values. Points beyond the fences appear as individual dots.</p>
                </div>
        
                <!-- 6. FAQ -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
                    <div class="faq-item">
                        <button class="faq-question">What is the difference between sample and population standard deviation?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Sample standard deviation divides by n&minus;1 (Bessel&rsquo;s correction) because a sample underestimates variability. Population standard deviation divides by n because you have all data points. Use sample SD (s) when analyzing a subset of a larger population; use population SD (&sigma;) when you have the entire dataset. Our calculator shows both.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">How do I interpret skewness and kurtosis?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Skewness measures asymmetry: 0 means symmetric, positive means right-skewed (long right tail), negative means left-skewed. Kurtosis (excess) measures tail weight: 0 is normal, positive means heavier tails (leptokurtic), negative means lighter tails (platykurtic). Values between &minus;0.5 and 0.5 are approximately symmetric or normal.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What are quartiles and how are they calculated?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Quartiles divide sorted data into four equal parts. Q1 (25th percentile) has 25% of data below it. Q2 is the median. Q3 (75th percentile) has 75% below. The IQR (Q3 &minus; Q1) measures the spread of the middle 50% and is used for outlier detection: any value below Q1 &minus; 1.5&times;IQR or above Q3 + 1.5&times;IQR is flagged.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">When should I use mean vs median?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Use the mean for symmetric data without outliers &mdash; it uses all values efficiently. Use the median for skewed data or data with outliers &mdash; it is resistant to extreme values. For example, median income is preferred over mean income because a few billionaires skew the mean upward significantly.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What does coefficient of variation tell you?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">The coefficient of variation (CV) is the standard deviation divided by the mean, expressed as a percentage. It measures relative variability, allowing you to compare spread between datasets with different units or scales. A CV below 15% generally indicates low variability; above 30% indicates high variability.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">How do I identify outliers in my data?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">The IQR method flags values below Q1 &minus; 1.5&times;IQR or above Q3 + 1.5&times;IQR as outliers (the same rule used in box plots). The z-score method flags values more than 2 or 3 standard deviations from the mean. Always investigate outliers before removing them &mdash; they may represent real phenomena or data entry errors.</div>
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
    <script src="<%=request.getContextPath()%>/js/summary-statistics-core.js?v=<%=v%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/categories-menu.js" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=v%>" defer></script>

<script>window.__MS_STAT_PAGE__ = { key: 'summary-stats', label: "Summary Statistics Calculator" };</script>
<%
    request.setAttribute("mathAiButtonId", "btnMathAI");
    request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
    request.setAttribute("mathAiProfileExport", "configureStatisticsMathShell");
%>
<%@ include file="modern/components/math-ai-boot.inc.jsp" %>
</body>
</html>

