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
        <jsp:param name="toolName" value="Percentile Calculator Online - Rank, Quartiles &amp; Box Plot Free" />
        <jsp:param name="toolDescription" value="Find percentile rank of any value, calculate value at any percentile, or get full quartile summary with IQR, outlier detection, and interactive box plot." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="percentile-calculator.jsp" />
        <jsp:param name="toolKeywords" value="percentile calculator, percentile rank calculator, quartile calculator, IQR calculator, box plot generator, five number summary, interquartile range, outlier detection, percentile formula, free statistics calculator" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Find percentile rank of any value,Find value at any percentile,Quartiles Q1 Q2 Q3 and IQR,Five-number summary,Interactive Plotly box plot,Outlier detection via IQR fences,Step-by-step KaTeX formulas,Python scipy code generation,LaTeX export and share URL" />
        <jsp:param name="teaches" value="Percentiles, percentile rank, quartiles, interquartile range, five-number summary, box plots, outlier detection" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Enter Data|Paste numbers separated by commas spaces or newlines,Choose Mode|Select Find Rank or Find Value or Full Summary,Set Target|Enter the value or percentile to look up,Click Calculate|Get instant percentile results with steps,View Box Plot|Explore the interactive Plotly box plot,Export Results|Copy LaTeX share URL or run Python code" />
        <jsp:param name="faq1q" value="What is the difference between percentile and percentile rank?" />
        <jsp:param name="faq1a" value="A percentile is a value below which a certain percentage of observations fall. For example the 90th percentile is the value below which 90 percent of data lies. Percentile rank is the reverse: given a specific value it tells you what percentage of the dataset falls below that value." />
        <jsp:param name="faq2q" value="How is the value at a percentile calculated?" />
        <jsp:param name="faq2a" value="Data are sorted in ascending order. The position is calculated as L equals n plus 1 times p divided by 100. If L is a whole number use that position value. If L is fractional interpolate linearly between the two adjacent values. Different software may use slightly different interpolation methods." />
        <jsp:param name="faq3q" value="What are quartiles and how do they relate to percentiles?" />
        <jsp:param name="faq3a" value="Quartiles divide sorted data into four equal parts. Q1 is the 25th percentile and 25 percent of data falls below it. Q2 is the 50th percentile which equals the median. Q3 is the 75th percentile. The interquartile range IQR equals Q3 minus Q1 and measures the spread of the middle 50 percent." />
        <jsp:param name="faq4q" value="How are outliers detected using IQR?" />
        <jsp:param name="faq4a" value="The IQR method flags values as potential outliers if they fall below Q1 minus 1.5 times IQR or above Q3 plus 1.5 times IQR. These boundaries are called fences. Values beyond 3 times IQR from the quartiles are considered extreme outliers. Context matters as not all flagged points are errors." />
        <jsp:param name="faq5q" value="What is a five-number summary?" />
        <jsp:param name="faq5a" value="A five-number summary consists of the minimum Q1 median Q3 and maximum. It provides a concise description of data distribution and is the basis for box plot visualization. Together these five values show center spread and symmetry of the data." />
        <jsp:param name="faq6q" value="Where are percentiles commonly used?" />
        <jsp:param name="faq6a" value="Percentiles are used in standardized testing like SAT and GRE scores, salary and income comparisons, pediatric growth charts for height and weight, network performance monitoring for response time SLAs, and quality control to establish tolerance limits in manufacturing." />
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

    <% request.setAttribute("activeService", "percentile"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <span aria-current="page">Percentile</span>
            </nav>
            <h1>Percentile Calculator</h1>
            <p class="ms-subtitle">Percentile rank · quartiles · box plot</p>
        </header>

        <div class="ic-stack">

            <div class="ic-hero ic-hero--compact stat-hero" id="stat-hero">
                <div class="ic-hero-top">
                    <button type="button" class="math-ai-tab-btn" id="btnMathAI" title="Math AI — statistics tutor + full math router in chat (Ctrl+Shift+A)">&#10024; AI</button>
                </div>
                <div class="stat-hero-core">
                    <!-- Mode Toggle -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label">Calculation Mode</label>
                                            <div class="stat-mode-toggle" style="display:flex;flex-wrap:wrap;">
                                                <button type="button" class="stat-mode-btn active" id="pct-mode-rank" style="flex:1;min-width:0;">Find Rank</button>
                                                <button type="button" class="stat-mode-btn" id="pct-mode-value" style="flex:1;min-width:0;">Find Value</button>
                                                <button type="button" class="stat-mode-btn" id="pct-mode-summary" style="flex:1;min-width:0;">Summary</button>
                                            </div>
                                            <div class="tool-form-hint">Find percentile rank, value at percentile, or full summary</div>
                                        </div>
                    
                                        <!-- Data Input -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label" for="pct-data-input">Data Input</label>
                                            <textarea class="stat-input-text" id="pct-data-input" rows="6" placeholder="85, 90, 78, 92, 88, 76, 95, 82, 87, 91" spellcheck="false">85, 90, 78, 92, 88, 76, 95, 82, 87, 91</textarea>
                                            <div class="tool-form-hint">Enter numbers separated by commas, spaces, or newlines</div>
                                        </div>
                    
                                        <!-- Target Input -->
                                        <div class="tool-form-group" id="pct-target-group">
                                            <label class="tool-form-label" id="pct-target-label" for="pct-target-input">Value to find rank for</label>
                                            <input type="number" class="stat-input-text" id="pct-target-input" value="88" step="any" style="height:auto;padding:0.5rem 0.75rem;">
                                            <div class="tool-form-hint" id="pct-target-hint">What percentile is this value at?</div>
                                        </div>
                    
                                        <!-- Preview -->
                                        <div class="tool-form-group">
                                            <div class="stat-preview" id="pct-preview"><span style="color:var(--text-muted);">Enter data above&hellip;</span></div>
                                        </div>
                    
                                        <!-- Buttons -->
                                        <button type="button" class="tool-action-btn" id="pct-calc-btn">Calculate Percentile</button>
                                        <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                                            <button type="button" class="tool-action-btn" id="pct-random-btn" style="background:var(--bg-secondary);color:var(--tool-primary);border:1.5px solid var(--tool-primary);flex:1;">&#x1F3B2; Random</button>
                                            <button type="button" class="tool-action-btn" id="pct-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                                        </div>
                    
                                        <hr class="stat-sep">
                    
                                        <!-- Quick Examples -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label">Quick Examples</label>
                                            <div class="stat-examples">
                                                <button type="button" class="stat-example-chip" data-example="test-scores">Test Scores</button>
                                                <button type="button" class="stat-example-chip" data-example="salaries">Salaries</button>
                                                <button type="button" class="stat-example-chip" data-example="heights">Heights (cm)</button>
                                                <button type="button" class="stat-example-chip" data-example="response-times">Response Times</button>
                                            </div>
                                        </div>
                                    </div>
                </div>
            </div>

            <div class="ic-result-card">
                <div class="stat-output-tabs">
                                <button type="button" class="stat-output-tab active" data-tab="pct-result-panel">Result</button>
                                <button type="button" class="stat-output-tab" data-tab="pct-graph-panel">Box Plot</button>
                                <button type="button" class="stat-output-tab" data-tab="pct-compiler-panel">Python Compiler</button>
                            </div>
                
                            <div class="stat-panel active" id="pct-result-panel">
                                <div class="tool-card tool-result-card">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                                        <h4>Result</h4>
                                    </div>
                                    <div class="tool-result-content" id="pct-result-content">
                                        <div class="tool-empty-state">
                                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F4CA;</div>
                                            <h3>Enter data and click Calculate</h3>
                                            <p>Find percentile rank, value at percentile, or full quartile summary.</p>
                                        </div>
                                    </div>
                                    <div class="tool-result-actions" id="pct-result-actions"></div>
                                </div>
                            </div>
                
                            <div class="stat-panel" id="pct-graph-panel">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
                                        <h4>Box Plot</h4>
                                    </div>
                                    <div style="flex:1;min-height:0;padding:0.75rem;overflow-y:auto;" id="pct-graph-content">
                                        <div class="tool-empty-state"><div style="font-size:2rem;opacity:0.5;">&#x1F4E6;</div><h3>No graph yet</h3><p>Calculate to see the box plot.</p></div>
                                    </div>
                                </div>
                            </div>
                
                            <div class="stat-panel" id="pct-compiler-panel">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                                        <h4>Python Compiler</h4>
                                    </div>
                                    <div style="flex:1;min-height:0;">
                                        <iframe id="pct-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                                    </div>
                                </div>
                            </div>
            </div>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
        </div>

<jsp:include page="modern/components/related-tools.jsp">
<jsp:param name="currentToolUrl" value="percentile-calculator.jsp"/>
        <jsp:param name="keyword" value="statistics"/>
        <jsp:param name="limit" value="6"/>
</jsp:include>

        <section class="tool-expertise-section ms-below-fold" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
        
                <!-- 1. What Are Percentiles? -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Are Percentiles?</h2>
                    <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">A <strong>percentile</strong> indicates the value below which a given percentage of observations fall. If you score in the 85th percentile on a test, you performed better than 85% of test-takers. Percentiles are essential for comparing individual values to a larger distribution.</p>
        
                    <div class="stat-edu-grid">
                        <div class="stat-feature-card stat-anim stat-anim-d1">
                            <div style="font-size:1.5rem;">&#x1F3AF;</div>
                            <h4>Percentile Rank</h4>
                            <p>Given a specific value, percentile rank tells you what percentage of the dataset falls at or below it.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d2">
                            <div style="font-size:1.5rem;">&#x1F50D;</div>
                            <h4>Value at Percentile</h4>
                            <p>Given a target percentile (e.g., 75th), find the data value that separates the lower p% from the upper.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d3">
                            <div style="font-size:1.5rem;">&#x1F4E6;</div>
                            <h4>Quartiles &amp; Box Plot</h4>
                            <p>Q1, Q2 (median), and Q3 divide data into four equal parts. The box plot visualizes this five-number summary.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 2. Percentile Formulas -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Percentile Formulas</h2>
        
                    <div class="stat-formula-box">
                        <strong>Percentile Rank (midpoint formula):</strong>&nbsp; PR = ((B + 0.5E) / n) &times; 100
                    </div>
                    <p style="color:var(--text-secondary);font-size:0.875rem;margin:0.5rem 0 1rem;">Where B = values below, E = values equal, n = total count</p>
        
                    <div class="stat-formula-box">
                        <strong>Value at Percentile (linear interpolation):</strong>&nbsp; L = (n + 1) &times; p / 100
                    </div>
                    <p style="color:var(--text-secondary);font-size:0.875rem;margin:0.5rem 0 1rem;">If L is fractional, interpolate between x<sub>&lfloor;L&rfloor;</sub> and x<sub>&lceil;L&rceil;</sub></p>
        
                    <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">Worked Example</h3>
                    <div class="stat-worked-example">
                        <strong>Data (sorted):</strong> [12, 15, 18, 22, 25, 28, 30, 35, 40, 45]&ensp;(n=10)<br>
                        <strong>Find:</strong> 75th percentile<br>
                        <strong>Step 1:</strong> L = (10+1) &times; 75/100 = <span style="color:var(--stat-tool);font-weight:700;">8.25</span><br>
                        <strong>Step 2:</strong> x<sub>8</sub> = 35, x<sub>9</sub> = 40<br>
                        <strong>Step 3:</strong> Interpolate: 35 + 0.25 &times; (40 &minus; 35) = <span style="color:var(--stat-tool);font-weight:700;">36.25</span><br>
                        <strong>Result:</strong> The 75th percentile is 36.25
                    </div>
                </div>
        
                <!-- 3. Quartiles, IQR & Outliers -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Quartiles, IQR &amp; Outlier Detection</h2>
        
                    <!-- Animated SVG Box Plot Diagram -->
                    <div style="text-align:center;margin-bottom:1.5rem;" class="stat-anim stat-anim-d1">
                        <svg viewBox="0 0 500 120" style="max-width:500px;width:100%;" xmlns="http://www.w3.org/2000/svg">
                            <!-- Whisker lines -->
                            <line x1="60" y1="60" x2="150" y2="60" stroke="#e11d48" stroke-width="2"/>
                            <line x1="350" y1="60" x2="440" y2="60" stroke="#e11d48" stroke-width="2"/>
                            <!-- Whisker caps -->
                            <line x1="60" y1="45" x2="60" y2="75" stroke="#e11d48" stroke-width="2"/>
                            <line x1="440" y1="45" x2="440" y2="75" stroke="#e11d48" stroke-width="2"/>
                            <!-- Box -->
                            <rect x="150" y="35" width="200" height="50" fill="rgba(225,29,72,0.1)" stroke="#e11d48" stroke-width="2" rx="3"/>
                            <!-- Median -->
                            <line x1="250" y1="35" x2="250" y2="85" stroke="#be123c" stroke-width="3"/>
                            <!-- Outlier -->
                            <circle cx="20" cy="60" r="5" fill="#ef4444" stroke="#b91c1c" stroke-width="1.5"/>
                            <!-- Labels -->
                            <text x="60" y="105" text-anchor="middle" fill="currentColor" font-size="11" font-family="Inter,sans-serif">Min</text>
                            <text x="150" y="105" text-anchor="middle" fill="currentColor" font-size="11" font-weight="600" font-family="Inter,sans-serif">Q1</text>
                            <text x="250" y="105" text-anchor="middle" fill="currentColor" font-size="11" font-weight="600" font-family="Inter,sans-serif">Median</text>
                            <text x="350" y="105" text-anchor="middle" fill="currentColor" font-size="11" font-weight="600" font-family="Inter,sans-serif">Q3</text>
                            <text x="440" y="105" text-anchor="middle" fill="currentColor" font-size="11" font-family="Inter,sans-serif">Max</text>
                            <text x="20" y="105" text-anchor="middle" fill="#ef4444" font-size="10" font-family="Inter,sans-serif">Outlier</text>
                            <text x="250" y="22" text-anchor="middle" fill="currentColor" font-size="10" font-family="Inter,sans-serif">IQR = Q3 &minus; Q1</text>
                            <!-- IQR bracket -->
                            <line x1="150" y1="28" x2="350" y2="28" stroke="var(--text-muted)" stroke-width="1" stroke-dasharray="3,2"/>
                        </svg>
                    </div>
        
                    <div class="stat-formula-box">
                        <strong>IQR:</strong>&nbsp; IQR = Q3 &minus; Q1
                    </div>
                    <div class="stat-formula-box">
                        <strong>Outlier Fences:</strong>&nbsp; Lower = Q1 &minus; 1.5&times;IQR &ensp;|&ensp; Upper = Q3 + 1.5&times;IQR
                    </div>
        
                    <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">Five-Number Summary</h3>
                    <table class="stat-ops-table">
                        <thead><tr><th>Measure</th><th>Percentile</th><th>Description</th></tr></thead>
                        <tbody>
                            <tr><td style="font-weight:600;">Minimum</td><td>0th</td><td>Smallest value in the dataset</td></tr>
                            <tr><td style="font-weight:600;">Q1</td><td>25th</td><td>25% of data falls below this value</td></tr>
                            <tr><td style="font-weight:600;">Median (Q2)</td><td>50th</td><td>The middle value that splits data in half</td></tr>
                            <tr><td style="font-weight:600;">Q3</td><td>75th</td><td>75% of data falls below this value</td></tr>
                            <tr><td style="font-weight:600;">Maximum</td><td>100th</td><td>Largest value in the dataset</td></tr>
                        </tbody>
                    </table>
                </div>
        
                <!-- 4. Common Applications -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Common Applications of Percentiles</h2>
        
                    <div class="stat-edu-grid">
                        <div class="stat-edu-card stat-anim stat-anim-d1">
                            <h4>Standardized Testing</h4>
                            <p>SAT, GRE, and IQ tests report percentile ranks so students can compare performance to the population of test-takers.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d2">
                            <h4>Salary &amp; Income</h4>
                            <p>Income percentiles help compare your salary to industry or national benchmarks. The 50th percentile is the median salary.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d3">
                            <h4>Growth Charts</h4>
                            <p>Pediatricians use percentile charts to track children&rsquo;s height and weight relative to age-matched populations.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d4">
                            <h4>Performance SLAs</h4>
                            <p>Network engineers use P95 or P99 response times to set service-level agreements that account for tail latency.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 5. FAQ -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
                    <div class="faq-item">
                        <button class="faq-question">What is the difference between percentile and percentile rank?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">A percentile is a value below which a certain percentage of observations fall. For example, the 90th percentile is the value below which 90% of data lies. Percentile rank is the reverse: given a specific value, it tells you what percentage of the dataset falls below that value.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">How is the value at a percentile calculated?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Data are sorted in ascending order. The position is calculated as L = (n+1) &times; p/100. If L is a whole number, use that position&rsquo;s value. If L is fractional, interpolate linearly between the two adjacent values. Different software may use slightly different interpolation methods.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What are quartiles and how do they relate to percentiles?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Quartiles divide sorted data into four equal parts. Q1 is the 25th percentile (25% of data falls below it). Q2 is the 50th percentile (the median). Q3 is the 75th percentile. The interquartile range (IQR = Q3 &minus; Q1) measures the spread of the middle 50%.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">How are outliers detected using IQR?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">The IQR method flags values as potential outliers if they fall below Q1 &minus; 1.5&times;IQR or above Q3 + 1.5&times;IQR. These boundaries are called fences. Values beyond 3&times;IQR from the quartiles are considered extreme outliers. Context matters &mdash; not all flagged points are errors.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What is a five-number summary?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">A five-number summary consists of the minimum, Q1, median, Q3, and maximum. It provides a concise description of data distribution and is the basis for box plot visualization. Together these five values show center, spread, and symmetry of the data.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">Where are percentiles commonly used?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Percentiles are used in standardized testing (SAT, GRE), salary and income comparisons, pediatric growth charts, network performance monitoring (P95/P99 response times), and quality control to establish tolerance limits in manufacturing.</div>
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
    <script src="<%=request.getContextPath()%>/js/percentile-calculator-core.js?v=<%=v%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/categories-menu.js" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=v%>" defer></script>

<script>window.__MS_STAT_PAGE__ = { key: 'percentile', label: "Percentile Calculator" };</script>
<%
    request.setAttribute("mathAiButtonId", "btnMathAI");
    request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
    request.setAttribute("mathAiProfileExport", "configureStatisticsMathShell");
%>
<%@ include file="modern/components/math-ai-boot.inc.jsp" %>
</body>
</html>

