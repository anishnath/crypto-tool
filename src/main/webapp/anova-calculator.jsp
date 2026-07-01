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
        <jsp:param name="toolName" value="ANOVA Calculator Online - One-Way Analysis of Variance Free" />
        <jsp:param name="toolDescription" value="One-way ANOVA calculator. Compare means of multiple groups with F-statistic p-value ANOVA table eta-squared effect size box plots and Python scipy export." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="anova-calculator.jsp" />
        <jsp:param name="toolKeywords" value="anova calculator, analysis of variance, one-way anova, f-test, f-statistic, compare group means, sum of squares, mean square, eta squared, post-hoc test" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="One-way ANOVA with dynamic group management,F-statistic and p-value calculation,Complete ANOVA table with SS df MS,Eta-squared effect size with interpretation,Per-group descriptive statistics,Interactive Plotly box plots and F-distribution,Step-by-step KaTeX formulas,Python scipy f_oneway code generation" />
        <jsp:param name="teaches" value="Analysis of variance, F-test, between-group variance, within-group variance, sum of squares, mean squares, eta-squared, effect size, post-hoc tests" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Enter Group Data|Type or paste numbers for each group separated by commas,Add Groups|Click Add Group to compare more than 3 groups,Set Alpha|Choose significance level 0.01 or 0.05 or 0.10,Click Calculate|Get F-statistic p-value and ANOVA table instantly,View Box Plots|Compare group distributions with interactive charts,Export Code|Run Python scipy f_oneway code in the compiler" />
        <jsp:param name="faq1q" value="What is one-way ANOVA used for?" />
        <jsp:param name="faq1a" value="One-way ANOVA tests whether the means of three or more independent groups are significantly different. It compares between-group variance to within-group variance using the F-statistic. If significant at least one group mean differs from the others." />
        <jsp:param name="faq2q" value="What are the assumptions of ANOVA?" />
        <jsp:param name="faq2a" value="ANOVA assumes independence of observations normal distribution within each group and homogeneity of variances across groups. ANOVA is robust to moderate violations of normality especially with larger sample sizes." />
        <jsp:param name="faq3q" value="What do I do after a significant ANOVA result?" />
        <jsp:param name="faq3a" value="A significant ANOVA tells you at least one group differs but not which ones. Use post-hoc tests like Tukey HSD to find specific pairwise differences while controlling the family-wise error rate." />
        <jsp:param name="faq4q" value="How do I interpret eta-squared?" />
        <jsp:param name="faq4a" value="Eta-squared measures the proportion of total variance explained by group membership. Guidelines are 0.01 is small 0.06 is medium and 0.14 is large. It helps assess practical significance beyond the p-value." />
        <jsp:param name="faq5q" value="What is the difference between one-way and two-way ANOVA?" />
        <jsp:param name="faq5a" value="One-way ANOVA has one independent variable or factor. Two-way ANOVA has two factors and can test for interaction effects between them. This calculator performs one-way ANOVA." />
        <jsp:param name="faq6q" value="What if ANOVA assumptions are violated?" />
        <jsp:param name="faq6a" value="If normality is violated consider the Kruskal-Wallis non-parametric test. If variances are unequal use Welch ANOVA. For small samples consider bootstrapping or exact permutation tests." />
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

    <% request.setAttribute("activeService", "anova"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <span aria-current="page">ANOVA</span>
            </nav>
            <h1>ANOVA Calculator</h1>
            <p class="ms-subtitle">One-way ANOVA · F-statistic · group charts</p>
        </header>

        <div class="ic-stack">

            <div class="ic-hero ic-hero--compact stat-hero" id="stat-hero">
                <div class="ic-hero-top">
                    <button type="button" class="math-ai-tab-btn" id="btnMathAI" title="Math AI — statistics tutor + full math router in chat (Ctrl+Shift+A)">&#10024; AI</button>
                </div>
                <div class="stat-hero-core">
                    <!-- Groups Container -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label">Group Data</label>
                                            <div class="tool-form-hint" style="margin-bottom:0.5rem;">Enter numbers separated by commas, spaces, or newlines</div>
                                            <div id="av-groups-container">
                                                <!-- JS replaces this on init via renderGroupInputs() -->
                                                <div class="av-group-box">
                                                    <div class="av-group-header"><h5>Group 1</h5></div>
                                                    <textarea class="stat-textarea" id="av-group-0" rows="3" placeholder="Enter values separated by commas or spaces">23, 25, 27, 22, 24</textarea>
                                                </div>
                                                <div class="av-group-box">
                                                    <div class="av-group-header"><h5>Group 2</h5></div>
                                                    <textarea class="stat-textarea" id="av-group-1" rows="3" placeholder="Enter values separated by commas or spaces">28, 30, 32, 29, 31</textarea>
                                                </div>
                                                <div class="av-group-box">
                                                    <div class="av-group-header"><h5>Group 3</h5></div>
                                                    <textarea class="stat-textarea" id="av-group-2" rows="3" placeholder="Enter values separated by commas or spaces">33, 35, 37, 34, 36</textarea>
                                                </div>
                                            </div>
                                        </div>
                    
                                        <!-- Add Group Button -->
                                        <button type="button" id="av-add-group-btn" style="background:var(--bg-secondary);color:var(--tool-primary);border:1.5px solid var(--tool-primary);width:100%;padding:0.5rem;border-radius:0.5rem;font-weight:600;font-size:0.8125rem;cursor:pointer;margin-bottom:0.75rem;font-family:var(--font-sans);">+ Add Group</button>
                    
                                        <!-- Significance Level -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label" for="av-alpha">Significance Level (&alpha;)</label>
                                            <select class="stat-input-text" id="av-alpha" style="min-height:auto;padding:0.5rem 0.75rem;">
                                                <option value="0.01">0.01 (99% confidence)</option>
                                                <option value="0.05" selected>0.05 (95% confidence)</option>
                                                <option value="0.10">0.10 (90% confidence)</option>
                                            </select>
                                        </div>
                    
                                        <!-- Buttons -->
                                        <button type="button" class="tool-action-btn" id="av-calc-btn">Calculate ANOVA</button>
                                        <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                                            <button type="button" class="tool-action-btn" id="av-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                                        </div>
                    
                                        <hr class="stat-sep">
                    
                                        <!-- Quick Examples -->
                                        <div class="tool-form-group" id="av-examples">
                                            <label class="tool-form-label">Quick Examples</label>
                                            <div class="stat-examples">
                                                <button type="button" class="stat-example-chip" data-example="teaching-methods">Teaching Methods</button>
                                                <button type="button" class="stat-example-chip" data-example="fertilizers">Fertilizers</button>
                                                <button type="button" class="stat-example-chip" data-example="medications">Medications</button>
                                                <button type="button" class="stat-example-chip" data-example="no-difference">No Difference</button>
                                            </div>
                                        </div>
                                    </div>
                </div>
            </div>

            <div class="ic-result-card">
                <div class="stat-output-tabs">
                                <button type="button" class="stat-output-tab active" data-tab="av-result-panel">Result</button>
                                <button type="button" class="stat-output-tab" data-tab="av-graph-panel">Charts</button>
                                <button type="button" class="stat-output-tab" data-tab="av-compiler-panel">Python Compiler</button>
                            </div>
                
                            <div class="stat-panel active" id="av-result-panel">
                                <div class="tool-card tool-result-card">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                                        <h4>Result</h4>
                                    </div>
                                    <div class="tool-result-content" id="av-result-content">
                                        <div class="tool-empty-state">
                                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F4CA;</div>
                                            <h3>Enter group data and click Calculate</h3>
                                            <p>Compare means of multiple groups with one-way ANOVA.</p>
                                        </div>
                                    </div>
                                    <div class="tool-result-actions" id="av-result-actions"></div>
                                </div>
                            </div>
                
                            <div class="stat-panel" id="av-graph-panel">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><path d="M3 3v18h18"/><path d="M7 16l4-8 4 4 4-6"/></svg>
                                        <h4>Box Plots &amp; F-Distribution</h4>
                                    </div>
                                    <div style="flex:1;padding:1rem;min-height:300px;">
                                        <div id="av-graph-container"></div>
                                    </div>
                                </div>
                            </div>
                
                            <div class="stat-panel" id="av-compiler-panel">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                                        <h4>Python Compiler</h4>
                                    </div>
                                    <div style="flex:1;min-height:0;">
                                        <iframe id="av-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                                    </div>
                                </div>
                            </div>
            </div>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
        </div>

<jsp:include page="modern/components/related-tools.jsp">
<jsp:param name="currentToolUrl" value="anova-calculator.jsp"/>
        <jsp:param name="keyword" value="statistics"/>
        <jsp:param name="limit" value="6"/>
</jsp:include>

        <section class="tool-expertise-section ms-below-fold" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
        
                <!-- 1. What Is ANOVA? -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Is ANOVA?</h2>
                    <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;"><strong>Analysis of Variance</strong> (ANOVA) is a statistical method that tests whether the means of three or more groups are significantly different. Instead of running multiple t-tests, ANOVA compares the variance <em>between</em> groups to the variance <em>within</em> groups using a single F-test.</p>
        
                    <!-- Animated SVG: Group comparison -->
                    <div style="text-align:center;margin:1.5rem 0;">
                        <svg viewBox="0 0 400 100" style="max-width:400px;width:100%;" aria-label="Three groups with different means">
                            <line x1="30" y1="80" x2="370" y2="80" stroke="var(--border-dark,#cbd5e1)" stroke-width="1.5"/>
                            <!-- Group 1 -->
                            <circle cx="100" cy="50" r="20" fill="#e11d48" opacity="0.15" class="stat-anim stat-anim-d1"/>
                            <circle cx="100" cy="50" r="4" fill="#e11d48" class="stat-anim stat-anim-d1"/>
                            <text x="100" y="92" text-anchor="middle" font-size="10" fill="var(--text-secondary)">Group 1</text>
                            <!-- Group 2 -->
                            <circle cx="200" cy="40" r="20" fill="#f59e0b" opacity="0.15" class="stat-anim stat-anim-d2"/>
                            <circle cx="200" cy="40" r="4" fill="#f59e0b" class="stat-anim stat-anim-d2"/>
                            <text x="200" y="92" text-anchor="middle" font-size="10" fill="var(--text-secondary)">Group 2</text>
                            <!-- Group 3 -->
                            <circle cx="300" cy="30" r="20" fill="#3b82f6" opacity="0.15" class="stat-anim stat-anim-d3"/>
                            <circle cx="300" cy="30" r="4" fill="#3b82f6" class="stat-anim stat-anim-d3"/>
                            <text x="300" y="92" text-anchor="middle" font-size="10" fill="var(--text-secondary)">Group 3</text>
                            <!-- Grand mean line -->
                            <line x1="60" y1="40" x2="340" y2="40" stroke="var(--text-muted,#94a3b8)" stroke-width="1" stroke-dasharray="4,3"/>
                            <text x="355" y="43" font-size="9" fill="var(--text-muted,#94a3b8)">x&#772;</text>
                        </svg>
                    </div>
        
                    <div class="stat-edu-grid" style="margin-top:1rem;">
                        <div class="stat-feature-card stat-anim stat-anim-d1">
                            <div style="font-size:1.5rem;">&#x1F4CA;</div>
                            <h4>Compare Multiple Groups</h4>
                            <p>Test whether 3 or more group means differ significantly in a single test, avoiding multiple comparison problems.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d2">
                            <div style="font-size:1.5rem;">&#x1F4C8;</div>
                            <h4>F-Statistic</h4>
                            <p>The ratio of between-group variance to within-group variance. A large F indicates the group means are spread apart more than expected by chance.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d3">
                            <div style="font-size:1.5rem;">&#x1F504;</div>
                            <h4>Beyond T-Tests</h4>
                            <p>Running multiple t-tests inflates Type I error. ANOVA controls the overall error rate while testing all groups simultaneously.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 2. ANOVA Table Explained -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">ANOVA Table Explained</h2>
                    <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">The ANOVA table summarizes the decomposition of total variance into between-group and within-group components.</p>
        
                    <table class="stat-ops-table">
                        <thead>
                            <tr><th>Source</th><th>SS</th><th>df</th><th>MS</th><th>F</th></tr>
                        </thead>
                        <tbody>
                            <tr><td style="font-weight:600;">Between</td><td>SSB</td><td>k &minus; 1</td><td>MSB</td><td>F = MSB / MSW</td></tr>
                            <tr><td style="font-weight:600;">Within</td><td>SSW</td><td>N &minus; k</td><td>MSW</td><td></td></tr>
                            <tr><td style="font-weight:600;">Total</td><td>SST</td><td>N &minus; 1</td><td></td><td></td></tr>
                        </tbody>
                    </table>
        
                    <div style="margin-top:1rem;padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;border-left:3px solid var(--info);">
                        <p style="margin:0;font-size:0.875rem;color:var(--text-secondary);line-height:1.6;">
                            <strong>Key:</strong> k = number of groups, N = total number of observations. SST = SSB + SSW. The F-statistic follows an F-distribution with (k&minus;1, N&minus;k) degrees of freedom.
                        </p>
                    </div>
                </div>
        
                <!-- 3. Key Formulas -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Key Formulas</h2>
        
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>Sum of Squares Between (SSB):</strong>&nbsp; SSB = &sum; n<sub>i</sub>(x&#772;<sub>i</sub> &minus; x&#772;)<sup>2</sup>
                    </div>
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>Sum of Squares Within (SSW):</strong>&nbsp; SSW = &sum;&sum; (x<sub>ij</sub> &minus; x&#772;<sub>i</sub>)<sup>2</sup>
                    </div>
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>Mean Squares:</strong>&nbsp; MSB = SSB / (k &minus; 1) &nbsp;&nbsp;&nbsp; MSW = SSW / (N &minus; k)
                    </div>
                    <div class="stat-formula-box">
                        <strong>F-Statistic:</strong>&nbsp; F = MSB / MSW
                    </div>
        
                    <div class="stat-worked-example" style="margin-top:1rem;">
                        <strong>Worked Example:</strong> Three groups: A = {4, 5, 6}, B = {8, 9, 7}, C = {5, 6, 4}. Grand mean x&#772; = 6.0.
                        <div style="margin-top:0.5rem;padding-left:1rem;border-left:3px solid var(--tool-primary);color:var(--text-secondary);font-size:0.875rem;">
                            x&#772;<sub>A</sub> = 5, x&#772;<sub>B</sub> = 8, x&#772;<sub>C</sub> = 5<br>
                            SSB = 3(5&minus;6)&sup2; + 3(8&minus;6)&sup2; + 3(5&minus;6)&sup2; = 3 + 12 + 3 = <strong>18</strong><br>
                            SSW = (1+0+1) + (0+1+1) + (1+0+1) = <strong>6</strong><br>
                            MSB = 18 / 2 = 9, &nbsp; MSW = 6 / 6 = 1<br>
                            F = 9 / 1 = <strong>9.0</strong>, &nbsp; df = (2, 6), &nbsp; p = 0.0156
                        </div>
                    </div>
                </div>
        
                <!-- 4. Effect Size: Eta-Squared -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Effect Size: Eta-Squared</h2>
                    <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">Eta-squared (&eta;&sup2;) measures how much of the total variance in the data is explained by group membership. It complements the p-value by indicating <em>practical</em> significance.</p>
        
                    <div class="stat-formula-box" style="margin-bottom:1rem;">
                        <strong>&eta;&sup2; = SSB / SST</strong> &nbsp;&mdash;&nbsp; proportion of variance explained by between-group differences
                    </div>
        
                    <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:0.75rem;margin-bottom:1.25rem;">
                        <div style="text-align:center;padding:0.75rem;background:var(--bg-secondary);border-radius:0.5rem;border-top:3px solid #10b981;">
                            <div style="font-weight:700;font-size:1rem;color:#10b981;">0.01</div>
                            <div style="font-size:0.75rem;color:var(--text-secondary);margin-top:0.25rem;">Small effect</div>
                        </div>
                        <div style="text-align:center;padding:0.75rem;background:var(--bg-secondary);border-radius:0.5rem;border-top:3px solid #f59e0b;">
                            <div style="font-weight:700;font-size:1rem;color:#f59e0b;">0.06</div>
                            <div style="font-size:0.75rem;color:var(--text-secondary);margin-top:0.25rem;">Medium effect</div>
                        </div>
                        <div style="text-align:center;padding:0.75rem;background:var(--bg-secondary);border-radius:0.5rem;border-top:3px solid #e11d48;">
                            <div style="font-weight:700;font-size:1rem;color:#e11d48;">0.14</div>
                            <div style="font-size:0.75rem;color:var(--text-secondary);margin-top:0.25rem;">Large effect</div>
                        </div>
                    </div>
        
                    <!-- SVG: Pie chart showing between vs within variance -->
                    <div style="text-align:center;margin:1rem 0;">
                        <svg viewBox="0 0 200 160" style="max-width:220px;width:100%;" aria-label="Pie chart showing between-group and within-group variance proportions">
                            <!-- Within-group (larger slice) -->
                            <circle cx="100" cy="75" r="55" fill="var(--bg-tertiary,#f1f5f9)" stroke="var(--border,#e2e8f0)" stroke-width="1"/>
                            <!-- Between-group slice (~30%) -->
                            <path d="M100,75 L100,20 A55,55 0 0,1 147.5,101.5 Z" fill="#e11d48" opacity="0.7" class="stat-anim stat-anim-d1"/>
                            <!-- Labels -->
                            <text x="125" y="55" font-size="9" fill="#e11d48" font-weight="600">SSB</text>
                            <text x="68" y="95" font-size="9" fill="var(--text-secondary)" font-weight="600">SSW</text>
                            <!-- Legend -->
                            <rect x="30" y="145" width="10" height="10" rx="2" fill="#e11d48" opacity="0.7"/>
                            <text x="44" y="154" font-size="9" fill="var(--text-secondary)">Between (&eta;&sup2;)</text>
                            <rect x="120" y="145" width="10" height="10" rx="2" fill="var(--bg-tertiary,#f1f5f9)" stroke="var(--border)" stroke-width="0.5"/>
                            <text x="134" y="154" font-size="9" fill="var(--text-secondary)">Within</text>
                        </svg>
                    </div>
                </div>
        
                <!-- 5. Assumptions & Alternatives -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Assumptions &amp; Alternatives</h2>
        
                    <div class="stat-edu-grid">
                        <div class="stat-feature-card stat-anim stat-anim-d1">
                            <div style="font-size:1.5rem;">&#x1F517;</div>
                            <h4>Independence</h4>
                            <p>Observations must be independent within and across groups. Random sampling or random assignment satisfies this.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d2">
                            <div style="font-size:1.5rem;">&#x1F4C9;</div>
                            <h4>Normality</h4>
                            <p>Data within each group should be approximately normally distributed. ANOVA is robust to moderate violations, especially with larger samples.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d3">
                            <div style="font-size:1.5rem;">&#x2696;&#xFE0F;</div>
                            <h4>Homogeneity of Variances</h4>
                            <p>Group variances should be roughly equal. Use Levene&rsquo;s test to check. If violated, consider Welch ANOVA.</p>
                        </div>
                    </div>
        
                    <div style="margin-top:1.25rem;padding:1rem;background:var(--bg-secondary);border-radius:0.5rem;">
                        <h4 style="font-size:0.875rem;font-weight:600;color:var(--text-primary);margin-bottom:0.5rem;">Alternatives &amp; Post-Hoc Tests</h4>
                        <div style="display:grid;grid-template-columns:1fr 1fr;gap:0.75rem;font-size:0.8125rem;color:var(--text-secondary);line-height:1.6;">
                            <div>
                                <strong style="color:var(--text-primary);">Non-parametric:</strong><br>
                                Kruskal-Wallis test (no normality assumption)
                            </div>
                            <div>
                                <strong style="color:var(--text-primary);">Unequal variances:</strong><br>
                                Welch ANOVA (robust to heteroscedasticity)
                            </div>
                            <div>
                                <strong style="color:var(--text-primary);">Pairwise comparisons:</strong><br>
                                Tukey HSD (controls family-wise error rate)
                            </div>
                            <div>
                                <strong style="color:var(--text-primary);">Conservative correction:</strong><br>
                                Bonferroni (&alpha; / number of comparisons)
                            </div>
                        </div>
                    </div>
                </div>
        
                <!-- 6. Frequently Asked Questions -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
                    <div class="faq-item">
                        <button class="faq-question">What is one-way ANOVA used for?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">One-way ANOVA tests whether the means of three or more independent groups are significantly different. It compares between-group variance to within-group variance using the F-statistic. If the result is significant, at least one group mean differs from the others.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What are the assumptions of ANOVA?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">ANOVA assumes independence of observations, normal distribution within each group, and homogeneity of variances across groups. ANOVA is robust to moderate violations of normality, especially with larger sample sizes.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What do I do after a significant ANOVA result?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">A significant ANOVA tells you at least one group differs, but not which ones. Use post-hoc tests like Tukey HSD to find specific pairwise differences while controlling the family-wise error rate.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">How do I interpret eta-squared?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Eta-squared measures the proportion of total variance explained by group membership. Guidelines: 0.01 is a small effect, 0.06 is medium, and 0.14 is large. It helps assess practical significance beyond the p-value.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What is the difference between one-way and two-way ANOVA?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">One-way ANOVA has one independent variable (factor). Two-way ANOVA has two factors and can test for interaction effects between them. This calculator performs one-way ANOVA.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What if ANOVA assumptions are violated?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">If normality is violated, consider the Kruskal-Wallis non-parametric test. If variances are unequal, use Welch ANOVA. For small samples, consider bootstrapping or exact permutation tests.</div>
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
    <script src="<%=request.getContextPath()%>/js/anova-core.js?v=<%=v%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/categories-menu.js" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=v%>" defer></script>

<script>window.__MS_STAT_PAGE__ = { key: 'anova', label: "ANOVA Calculator" };</script>
<%
    request.setAttribute("mathAiButtonId", "btnMathAI");
    request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
    request.setAttribute("mathAiProfileExport", "configureStatisticsMathShell");
%>
<%@ include file="modern/components/math-ai-boot.inc.jsp" %>
</body>
</html>
