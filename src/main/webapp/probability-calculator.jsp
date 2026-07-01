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
        <jsp:param name="toolName" value="Probability Calculator Online - Bayes Theorem &amp; Conditional Free" />
        <jsp:param name="toolDescription" value="Calculate basic probability, conditional probability P(A|B), Bayes theorem posterior, and AND/OR/NOT for multiple events. Step-by-step KaTeX formulas and Python export." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="probability-calculator.jsp" />
        <jsp:param name="toolKeywords" value="probability calculator, bayes theorem calculator, conditional probability calculator, AND OR probability, complement probability, independent events, mutually exclusive, joint probability, posterior probability, odds calculator" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Basic probability favorable over total,Conditional probability P(A given B),Bayes theorem posterior probability,Multiple events AND OR NOT,Independent and mutually exclusive,Step-by-step KaTeX formulas,Python code generation,Odds for and against" />
        <jsp:param name="teaches" value="Probability theory, conditional probability, Bayes theorem, independent events, mutually exclusive events, complement rule, addition rule, multiplication rule" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Choose Mode|Select Basic or Conditional or Bayes or Multiple Events,Enter Values|Input probabilities or outcome counts,Click Calculate|Get instant results with step-by-step formulas,Review Steps|See KaTeX formula derivation,Read Interpretation|Understand what the result means,Export Code|Run Python code in the embedded compiler" />
        <jsp:param name="faq1q" value="What is the difference between independent and mutually exclusive events?" />
        <jsp:param name="faq1a" value="Independent events do not affect each other so P(A and B) equals P(A) times P(B). Mutually exclusive events cannot both occur so P(A and B) equals 0. Two events can be independent but not mutually exclusive and vice versa." />
        <jsp:param name="faq2q" value="How does Bayes theorem work?" />
        <jsp:param name="faq2a" value="Bayes theorem updates a prior probability P(A) based on new evidence B. The posterior P(A given B) equals P(B given A) times P(A) divided by P(B). It is widely used in medical testing spam filtering and machine learning." />
        <jsp:param name="faq3q" value="What is conditional probability?" />
        <jsp:param name="faq3a" value="Conditional probability P(A given B) is the probability of A occurring given that B has already occurred. The formula is P(A and B) divided by P(B). It narrows the sample space to only outcomes where B is true." />
        <jsp:param name="faq4q" value="How do I calculate P(A OR B)?" />
        <jsp:param name="faq4a" value="Use the addition rule P(A or B) equals P(A) plus P(B) minus P(A and B). For mutually exclusive events P(A and B) is zero so it simplifies to P(A) plus P(B). Always subtract the overlap to avoid double counting." />
        <jsp:param name="faq5q" value="What are odds versus probability?" />
        <jsp:param name="faq5a" value="Probability is favorable outcomes divided by total outcomes ranging from 0 to 1. Odds for are favorable to unfavorable such as 3 to 2. Convert odds to probability by dividing favorable by the sum of favorable plus unfavorable." />
        <jsp:param name="faq6q" value="Why does Bayes theorem give surprising results for medical tests?" />
        <jsp:param name="faq6a" value="When a disease is rare the prior P(A) is very low. Even with a highly accurate test the false positives from the large healthy population can outnumber the true positives. This is the base rate fallacy and Bayes theorem correctly accounts for it." />
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

    <% request.setAttribute("activeService", "probability"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <span aria-current="page">Probability</span>
            </nav>
            <h1>Probability Calculator</h1>
            <p class="ms-subtitle">Combinatorics · conditional · Bayes · unions</p>
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
                                                <button type="button" class="stat-mode-btn active" id="prob-mode-basic" style="flex:1;min-width:0;font-size:0.75rem;padding:0.5rem 0.25rem;">Basic</button>
                                                <button type="button" class="stat-mode-btn" id="prob-mode-conditional" style="flex:1;min-width:0;font-size:0.75rem;padding:0.5rem 0.25rem;">Conditional</button>
                                                <button type="button" class="stat-mode-btn" id="prob-mode-bayes" style="flex:1;min-width:0;font-size:0.75rem;padding:0.5rem 0.25rem;">Bayes</button>
                                                <button type="button" class="stat-mode-btn" id="prob-mode-multiple" style="flex:1;min-width:0;font-size:0.75rem;padding:0.5rem 0.25rem;">Multiple</button>
                                            </div>
                                        </div>
                    
                                        <!-- Basic inputs -->
                                        <div id="prob-input-basic">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="prob-favorable">Favorable Outcomes</label>
                                                <input type="number" class="stat-input-text prob-input" id="prob-favorable" value="3" min="0" step="1" style="height:auto;padding:0.5rem 0.75rem;">
                                            </div>
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="prob-total">Total Outcomes</label>
                                                <input type="number" class="stat-input-text prob-input" id="prob-total" value="6" min="1" step="1" style="height:auto;padding:0.5rem 0.75rem;">
                                                <div class="tool-form-hint">P(A) = favorable / total</div>
                                            </div>
                                        </div>
                    
                                        <!-- Conditional inputs -->
                                        <div id="prob-input-conditional" style="display:none;">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="prob-a-and-b">P(A &cap; B) &mdash; Joint Probability</label>
                                                <input type="number" class="stat-input-text prob-input" id="prob-a-and-b" value="0.15" min="0" max="1" step="0.01" style="height:auto;padding:0.5rem 0.75rem;">
                                            </div>
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="prob-b">P(B) &mdash; Probability of B</label>
                                                <input type="number" class="stat-input-text prob-input" id="prob-b" value="0.30" min="0.001" max="1" step="0.01" style="height:auto;padding:0.5rem 0.75rem;">
                                                <div class="tool-form-hint">P(A|B) = P(A &cap; B) / P(B)</div>
                                            </div>
                                        </div>
                    
                                        <!-- Bayes inputs -->
                                        <div id="prob-input-bayes" style="display:none;">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="prob-prior-a">P(A) &mdash; Prior Probability</label>
                                                <input type="number" class="stat-input-text prob-input" id="prob-prior-a" value="0.01" min="0" max="1" step="0.01" style="height:auto;padding:0.5rem 0.75rem;">
                                                <div class="tool-form-hint">e.g. disease prevalence</div>
                                            </div>
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="prob-b-given-a">P(B|A) &mdash; Sensitivity / Likelihood</label>
                                                <input type="number" class="stat-input-text prob-input" id="prob-b-given-a" value="0.95" min="0" max="1" step="0.01" style="height:auto;padding:0.5rem 0.75rem;">
                                                <div class="tool-form-hint">Probability of evidence given A is true</div>
                                            </div>
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="prob-b-given-not-a">P(B|&not;A) &mdash; False Positive Rate</label>
                                                <input type="number" class="stat-input-text prob-input" id="prob-b-given-not-a" value="0.05" min="0" max="1" step="0.01" style="height:auto;padding:0.5rem 0.75rem;">
                                                <div class="tool-form-hint">Probability of evidence given A is false</div>
                                            </div>
                                        </div>
                    
                                        <!-- Multiple Events inputs -->
                                        <div id="prob-input-multiple" style="display:none;">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="prob-pa">P(A)</label>
                                                <input type="number" class="stat-input-text prob-input" id="prob-pa" value="0.60" min="0" max="1" step="0.01" style="height:auto;padding:0.5rem 0.75rem;">
                                            </div>
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="prob-pb">P(B)</label>
                                                <input type="number" class="stat-input-text prob-input" id="prob-pb" value="0.40" min="0" max="1" step="0.01" style="height:auto;padding:0.5rem 0.75rem;">
                                            </div>
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="prob-relation">Events Relationship</label>
                                                <select class="prob-select prob-input" id="prob-relation">
                                                    <option value="independent">Independent (unrelated)</option>
                                                    <option value="mutually-exclusive">Mutually Exclusive</option>
                                                </select>
                                            </div>
                                        </div>
                    
                                        <!-- Buttons -->
                                        <button type="button" class="tool-action-btn" id="prob-calc-btn">Calculate Probability</button>
                                        <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                                            <button type="button" class="tool-action-btn" id="prob-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                                        </div>
                    
                                        <hr class="stat-sep">
                    
                                        <!-- Quick Examples -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label">Quick Examples</label>
                                            <div class="stat-examples">
                                                <button type="button" class="stat-example-chip" data-prob-example="dice">Dice Roll</button>
                                                <button type="button" class="stat-example-chip" data-prob-example="medical">Medical Test</button>
                                                <button type="button" class="stat-example-chip" data-prob-example="cards">Card Draw</button>
                                                <button type="button" class="stat-example-chip" data-prob-example="weather">Weather</button>
                                            </div>
                                        </div>
                                    </div>
                </div>
            </div>

            <div class="ic-result-card">
                <div class="stat-output-tabs">
                                <button type="button" class="stat-output-tab active" data-tab="prob-result-panel">Result</button>
                                <button type="button" class="stat-output-tab" data-tab="prob-compiler-panel">Python Compiler</button>
                            </div>
                
                            <div class="stat-panel active" id="prob-result-panel">
                                <div class="tool-card tool-result-card">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                                        <h4>Result</h4>
                                    </div>
                                    <div class="tool-result-content" id="prob-result-content">
                                        <div class="tool-empty-state">
                                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F3B2;</div>
                                            <h3>Enter values and click Calculate</h3>
                                            <p>Compute probability using basic rules, conditional probability, or Bayes&rsquo; theorem.</p>
                                        </div>
                                    </div>
                                    <div class="tool-result-actions" id="prob-result-actions"></div>
                                </div>
                            </div>
                
                            <div class="stat-panel" id="prob-compiler-panel">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                                        <h4>Python Compiler</h4>
                                    </div>
                                    <div style="flex:1;min-height:0;">
                                        <iframe id="prob-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                                    </div>
                                </div>
                            </div>
            </div>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
        </div>

<jsp:include page="modern/components/related-tools.jsp">
<jsp:param name="currentToolUrl" value="probability-calculator.jsp"/>
        <jsp:param name="keyword" value="statistics"/>
        <jsp:param name="limit" value="6"/>
</jsp:include>

        <section class="tool-expertise-section ms-below-fold" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
        
                <!-- 1. Probability Fundamentals -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Probability Fundamentals</h2>
                    <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;"><strong>Probability</strong> measures the likelihood of an event occurring, expressed as a number between 0 (impossible) and 1 (certain). It is the foundation of statistics, machine learning, and decision-making.</p>
        
                    <div class="stat-formula-box">
                        <strong>Basic Probability:</strong>&nbsp; P(A) = Favorable Outcomes / Total Outcomes
                    </div>
        
                    <div class="stat-edu-grid" style="margin-top:1rem;">
                        <div class="stat-feature-card stat-anim stat-anim-d1">
                            <div style="font-size:1.5rem;">&#x1F3B2;</div>
                            <h4>Complement Rule</h4>
                            <p>P(&not;A) = 1 &minus; P(A). The probability an event does <em>not</em> happen.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d2">
                            <div style="font-size:1.5rem;">&#x2795;</div>
                            <h4>Addition Rule (OR)</h4>
                            <p>P(A &cup; B) = P(A) + P(B) &minus; P(A &cap; B). Subtract the overlap.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d3">
                            <div style="font-size:1.5rem;">&#x2716;&#xFE0F;</div>
                            <h4>Multiplication Rule (AND)</h4>
                            <p>P(A &cap; B) = P(A) &times; P(B|A). For independent events: P(A) &times; P(B).</p>
                        </div>
                    </div>
                </div>
        
                <!-- 2. Conditional Probability & Bayes -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Conditional Probability &amp; Bayes&rsquo; Theorem</h2>
        
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>Conditional:</strong>&nbsp; P(A|B) = P(A &cap; B) / P(B)
                    </div>
                    <div class="stat-formula-box">
                        <strong>Bayes&rsquo; Theorem:</strong>&nbsp; P(A|B) = P(B|A) &times; P(A) / [P(B|A) &times; P(A) + P(B|&not;A) &times; P(&not;A)]
                    </div>
        
                    <div class="stat-worked-example" style="margin-top:1rem;">
                        <strong>Medical Test Example:</strong> A disease affects 1% of the population. A test has 95% sensitivity and 5% false positive rate. If you test positive, what is the probability you have the disease?
                        <div style="margin-top:0.5rem;padding-left:1rem;border-left:3px solid var(--tool-primary);color:var(--text-secondary);font-size:0.875rem;">
                            P(Disease) = 0.01, P(+|Disease) = 0.95, P(+|Healthy) = 0.05<br>
                            P(+) = 0.95 &times; 0.01 + 0.05 &times; 0.99 = 0.059<br>
                            P(Disease|+) = (0.95 &times; 0.01) / 0.059 = <strong>0.161 (16.1%)</strong><br>
                            Despite a &ldquo;95% accurate&rdquo; test, there is only a 16% chance of having the disease!
                        </div>
                    </div>
                </div>
        
                <!-- 3. Key Concepts -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Independent vs. Mutually Exclusive Events</h2>
        
                    <table class="stat-ops-table">
                        <thead><tr><th>Property</th><th>Independent Events</th><th>Mutually Exclusive Events</th></tr></thead>
                        <tbody>
                            <tr><td style="font-weight:600;">Definition</td><td>One event does not affect the other</td><td>Events cannot both occur</td></tr>
                            <tr><td style="font-weight:600;">P(A &cap; B)</td><td>P(A) &times; P(B)</td><td>0</td></tr>
                            <tr><td style="font-weight:600;">P(A &cup; B)</td><td>P(A) + P(B) &minus; P(A)P(B)</td><td>P(A) + P(B)</td></tr>
                            <tr><td style="font-weight:600;">Example</td><td>Coin flip and die roll</td><td>Drawing a red or blue ball</td></tr>
                            <tr><td style="font-weight:600;">Can both occur?</td><td>Yes</td><td>No</td></tr>
                        </tbody>
                    </table>
                </div>
        
                <!-- 4. Applications -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Real-World Applications</h2>
                    <div class="stat-edu-grid">
                        <div class="stat-edu-card stat-anim stat-anim-d1">
                            <h4>Medical Diagnosis</h4>
                            <p>Bayes&rsquo; theorem updates disease probability after test results, accounting for base rates and test accuracy.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d2">
                            <h4>Spam Filtering</h4>
                            <p>Na&iuml;ve Bayes classifiers compute the probability an email is spam given the words it contains.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d3">
                            <h4>Insurance &amp; Risk</h4>
                            <p>Actuaries use conditional probabilities to assess risk and calculate premium rates.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d4">
                            <h4>Games &amp; Sports</h4>
                            <p>Poker odds, win probability given the current game state, expected value of bets.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 5. FAQ -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
                    <div class="faq-item">
                        <button class="faq-question">What is the difference between independent and mutually exclusive events?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Independent events do not affect each other, so P(A &cap; B) = P(A) &times; P(B). Mutually exclusive events cannot both occur, so P(A &cap; B) = 0. These are different concepts: two events can be independent but not mutually exclusive, and vice versa.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">How does Bayes&rsquo; theorem work?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Bayes&rsquo; theorem updates a prior probability P(A) based on new evidence B. The posterior P(A|B) = P(B|A) &times; P(A) / P(B). It is widely used in medical testing, spam filtering, and machine learning.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What is conditional probability?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Conditional probability P(A|B) is the probability of event A occurring given that B has already occurred. The formula is P(A &cap; B) / P(B). It narrows the sample space to only outcomes where B is true.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">How do I calculate P(A OR B)?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Use the addition rule: P(A &cup; B) = P(A) + P(B) &minus; P(A &cap; B). For mutually exclusive events, P(A &cap; B) = 0, so it simplifies to P(A) + P(B). Always subtract the overlap to avoid double-counting.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What are odds versus probability?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Probability is favorable outcomes divided by total outcomes, ranging from 0 to 1. Odds are favorable to unfavorable (e.g., 3:2). Convert odds to probability: p = favorable / (favorable + unfavorable).</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">Why does Bayes&rsquo; theorem give surprising results for medical tests?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">When a disease is rare (low prior), even a highly accurate test produces many false positives from the large healthy population. This is the base rate fallacy. Bayes&rsquo; theorem correctly accounts for it, showing the posterior can be much lower than expected.</div>
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
    <script src="<%=request.getContextPath()%>/js/probability-calculator-core.js?v=<%=v%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/categories-menu.js" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=v%>" defer></script>

<script>window.__MS_STAT_PAGE__ = { key: 'probability', label: "Probability Calculator" };</script>
<%
    request.setAttribute("mathAiButtonId", "btnMathAI");
    request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
    request.setAttribute("mathAiProfileExport", "configureStatisticsMathShell");
%>
<%@ include file="modern/components/math-ai-boot.inc.jsp" %>
</body>
</html>

