<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow">
    <meta name="resource-type" content="document">
    <meta name="language" content="en">
    <meta name="author" content="Anish Nath">
    <meta name="context-path" content="<%=request.getContextPath()%>">

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Percentage Calculator with Steps - All Formulas Free Online" />
        <jsp:param name="toolDescription" value="Free percentage calculator with step-by-step solutions. Find percent of, percent change, increase, decrease, reverse percentage, and discount with tax." />
        <jsp:param name="toolCategory" value="Mathematics" />
        <jsp:param name="toolUrl" value="percentage-calculator.jsp" />
        <jsp:param name="toolKeywords" value="percentage calculator, percent of calculator, percent change calculator, percent increase calculator, percent decrease calculator, discount calculator, reverse percentage, percentage formula, step by step percentage, tax calculator, percentage solver" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Calculate X percent of Y with steps,Find what percent X is of Y,Percent increase and decrease calculator,Percent change from A to B,Reverse percentage - find original price,Discount plus tax simulator with quantity,Chained percentage steps with running total,Built-in Python compiler with 3 templates,LaTeX export and shareable URLs,8 quick example presets,Dark mode support" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="teaches" value="Percentages, percent change, percent increase and decrease, reverse percentage, discount and tax calculations" />
        <jsp:param name="educationalLevel" value="Middle School, High School" />
        <jsp:param name="howToSteps" value="Select a calculation mode|Choose from 8 modes: percent of or what percent or increase or decrease or percent change or reverse percentage or discount simulator or chained steps,Enter your values|Type numbers into the X and Y input fields. For discount mode enter base price and discount and tax percentages,Click Calculate|Press the Calculate button to see the step-by-step solution with KaTeX-rendered formulas,Review steps and export|Read each solution step then copy LaTeX or share the URL or try the Python compiler" />
        <jsp:param name="faq1q" value="How do you calculate a percentage of a number?" />
        <jsp:param name="faq1a" value="To find X percent of Y multiply Y by X divided by 100. For example 25 percent of 200 equals 200 times 25 divided by 100 equals 50. The formula is Result equals X divided by 100 times Y. This calculator shows every step of the computation." />
        <jsp:param name="faq2q" value="How do you calculate percent change between two numbers?" />
        <jsp:param name="faq2a" value="Percent change equals the difference B minus A divided by the original value A times 100. For example going from 120 to 150 gives (150 minus 120) divided by 120 times 100 equals 25 percent increase. A negative result means a decrease." />
        <jsp:param name="faq3q" value="How do you find the original price before a discount?" />
        <jsp:param name="faq3a" value="Divide the final price by 1 minus the discount percentage divided by 100. For example if the final price is 75 after a 25 percent discount the original is 75 divided by 0.75 which equals 100. The formula is Original equals Final divided by (1 minus Discount percent divided by 100)." />
        <jsp:param name="faq4q" value="How do chained percentage steps work?" />
        <jsp:param name="faq4a" value="Each percentage step applies to the running total not the original. For example starting at 100 then plus 10 percent gives 110 then minus 5 percent gives 104.5 then plus 8 percent gives 112.86. Note that plus 10 percent then minus 10 percent does not return to the original because each step uses the current value as its base." />
        <jsp:param name="faq5q" value="Is this percentage calculator free?" />
        <jsp:param name="faq5a" value="Yes 100 percent free with no signup required. Features include 8 calculation modes with step by step KaTeX solutions a discount tax simulator chained steps a Python compiler LaTeX export and shareable URLs. All computation runs in your browser." />
    </jsp:include>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet" media="print" onload="this.media='all'">
    <noscript><link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet"></noscript>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/percentage-calculator.css?v=<%=cacheVersion%>">

    <%@ include file="modern/ads/ad-init.jsp" %>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">

    <style>
        .tool-action-btn { background: var(--pc-gradient) !important; }
        .tool-badge { background: var(--pc-light); color: var(--pc-tool); }
    </style>
</head>
<body>
<%@ include file="modern/components/nav-header.jsp" %>

<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">Percentage Calculator</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/index.jsp#mathematics">Mathematics</a> /
                Percentage Calculator
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">Free Online</span>
            <span class="tool-badge">8 Modes</span>
            <span class="tool-badge">Step-by-Step</span>
        </div>
    </div>
</header>

<section class="tool-description-section" style="background:var(--pc-light);">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>Free <strong>percentage calculator</strong> with <strong>step-by-step solutions</strong> for all common formulas. Calculate percent of, percent change, increase/decrease, reverse percentage, discount with tax, and chained steps. All 8 modes with KaTeX-rendered math.</p>
        </div>
    </div>
</section>

<main class="tool-page-container">
    <!-- ==================== INPUT COLUMN ==================== -->
    <div class="tool-input-column">
        <div class="tool-card">
            <div class="tool-card-header" style="background:var(--pc-gradient);">Percentage Calculator</div>
            <div class="tool-card-body">

                <!-- Mode Toggle (2 rows of 4) -->
                <div class="tool-form-group" style="margin-bottom:0.75rem;">
                    <label class="tool-form-label">Mode</label>
                    <div class="pc-mode-toggle">
                        <button type="button" class="pc-mode-btn active" data-mode="percentOf">X% of Y</button>
                        <button type="button" class="pc-mode-btn" data-mode="whatPercent">What %</button>
                        <button type="button" class="pc-mode-btn" data-mode="increaseBy">Increase</button>
                        <button type="button" class="pc-mode-btn" data-mode="decreaseBy">Decrease</button>
                        <button type="button" class="pc-mode-btn" data-mode="percentChange">% Change</button>
                        <button type="button" class="pc-mode-btn" data-mode="reversePct">Reverse</button>
                        <button type="button" class="pc-mode-btn" data-mode="discountSim">Discount</button>
                        <button type="button" class="pc-mode-btn" data-mode="chain">Chain</button>
                    </div>
                </div>

                <!-- ===== SIMPLE MODES: percentOf, whatPercent, increaseBy, decreaseBy ===== -->
                <div class="pc-mode-form active" id="pc-form-simple">
                    <div class="tool-form-group">
                        <div class="pc-input-row">
                            <div class="pc-input-group">
                                <label class="pc-input-label" id="pc-x-label" for="pc-x">X (percent/value)</label>
                                <input type="number" class="pc-input" id="pc-x" value="10" step="any">
                            </div>
                            <div class="pc-input-group">
                                <label class="pc-input-label" id="pc-y-label" for="pc-y">Y (base)</label>
                                <input type="number" class="pc-input" id="pc-y" value="200" step="any">
                            </div>
                        </div>
                        <div class="tool-form-hint" id="pc-simple-hint">Calculate X% of Y with step-by-step solution</div>
                    </div>
                </div>

                <!-- ===== PERCENT CHANGE FORM ===== -->
                <div class="pc-mode-form" id="pc-form-percentChange">
                    <div class="tool-form-group">
                        <div class="pc-input-row">
                            <div class="pc-input-group">
                                <label class="pc-input-label" for="pc-a">A (from)</label>
                                <input type="number" class="pc-input" id="pc-a" value="120" step="any">
                            </div>
                            <div class="pc-input-group">
                                <label class="pc-input-label" for="pc-b">B (to)</label>
                                <input type="number" class="pc-input" id="pc-b" value="150" step="any">
                            </div>
                        </div>
                        <div class="tool-form-hint">Percentage change from A to B</div>
                    </div>
                </div>

                <!-- ===== REVERSE PERCENTAGE FORM ===== -->
                <div class="pc-mode-form" id="pc-form-reversePct">
                    <div class="tool-form-group">
                        <div class="pc-input-row">
                            <div class="pc-input-group">
                                <label class="pc-input-label" for="pc-disc-pct">Discount %</label>
                                <input type="number" class="pc-input" id="pc-disc-pct" value="20" step="any">
                            </div>
                            <div class="pc-input-group">
                                <label class="pc-input-label" for="pc-final-price">Final Price</label>
                                <input type="number" class="pc-input" id="pc-final-price" value="80" step="any">
                            </div>
                        </div>
                        <div class="tool-form-hint">Find the original price before discount</div>
                    </div>
                </div>

                <!-- ===== DISCOUNT SIMULATOR FORM ===== -->
                <div class="pc-mode-form" id="pc-form-discountSim">
                    <div class="tool-form-group">
                        <div class="pc-input-row">
                            <div class="pc-input-group">
                                <label class="pc-input-label" for="pc-base-price">Base Price</label>
                                <input type="number" class="pc-input" id="pc-base-price" value="1000" step="any">
                            </div>
                            <div class="pc-input-group">
                                <label class="pc-input-label" for="pc-disc-sim">Discount %</label>
                                <input type="number" class="pc-input" id="pc-disc-sim" value="15" step="any">
                            </div>
                        </div>
                        <div class="pc-input-row">
                            <div class="pc-input-group">
                                <label class="pc-input-label" for="pc-tax-sim">Tax %</label>
                                <input type="number" class="pc-input" id="pc-tax-sim" value="5" step="any">
                            </div>
                            <div class="pc-input-group">
                                <label class="pc-input-label" for="pc-qty">Quantity</label>
                                <input type="number" class="pc-input" id="pc-qty" value="1" step="1" min="1">
                            </div>
                        </div>
                        <div class="tool-form-hint">Full breakdown: discount, tax, and total</div>
                    </div>
                </div>

                <!-- ===== CHAINED STEPS FORM ===== -->
                <div class="pc-mode-form" id="pc-form-chain">
                    <div class="tool-form-group">
                        <div class="pc-input-row">
                            <div class="pc-input-group">
                                <label class="pc-input-label" for="pc-chain-start">Start Value</label>
                                <input type="number" class="pc-input" id="pc-chain-start" value="100" step="any">
                            </div>
                        </div>
                        <div style="margin-top:0.5rem;">
                            <label class="pc-input-label" for="pc-chain-steps">Steps (comma-separated)</label>
                            <input type="text" class="pc-input-text" id="pc-chain-steps" value="+10%, -5%, +8%">
                        </div>
                        <div class="tool-form-hint">Use +X% or -X% for percentage; +X or -X for absolute</div>
                    </div>
                </div>

                <!-- Live Preview -->
                <div class="tool-form-group" style="margin-top:0.75rem;">
                    <label class="tool-form-label">Preview</label>
                    <div class="pc-preview" id="pc-preview"></div>
                </div>

                <!-- Action Buttons -->
                <div style="display:flex;gap:0.5rem;">
                    <button type="button" class="tool-action-btn" id="pc-solve-btn" style="flex:1">Calculate</button>
                    <button type="button" class="tool-action-btn" id="pc-clear-btn" style="flex:0;min-width:60px;background:var(--bg-secondary)!important;color:var(--text-secondary);border:1px solid var(--border)">Clear</button>
                </div>

                <hr style="border:none;border-top:1px solid var(--border);margin:1rem 0">

                <!-- Quick Examples -->
                <div class="tool-form-group">
                    <label class="tool-form-label">Quick Examples</label>
                    <div class="pc-examples">
                        <button type="button" class="pc-example-chip" data-example="pct-of">25% of 200</button>
                        <button type="button" class="pc-example-chip" data-example="what-pct">What %?</button>
                        <button type="button" class="pc-example-chip" data-example="increase">+15%</button>
                        <button type="button" class="pc-example-chip" data-example="decrease">-20%</button>
                        <button type="button" class="pc-example-chip" data-example="change">% Change</button>
                        <button type="button" class="pc-example-chip" data-example="reverse">Reverse</button>
                        <button type="button" class="pc-example-chip" data-example="discount">Discount+Tax</button>
                        <button type="button" class="pc-example-chip" data-example="chain">Chain Steps</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ==================== OUTPUT COLUMN ==================== -->
    <div class="tool-output-column">
        <!-- Tab bar -->
        <div class="pc-output-tabs">
            <button type="button" class="pc-output-tab active" data-panel="result">Result</button>
            <button type="button" class="pc-output-tab" data-panel="python">Python Compiler</button>
        </div>

        <!-- Result Panel -->
        <div class="pc-panel active" id="pc-panel-result">
            <div class="tool-card tool-result-card">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--pc-tool);">
                        <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                    </svg>
                    <h4>Result</h4>
                </div>
                <div class="tool-result-content" id="pc-result-content">
                    <div class="tool-empty-state" id="pc-empty-state">
                        <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">%</div>
                        <h3>Enter values to calculate</h3>
                        <p>Solve any percentage problem with step-by-step solutions.</p>
                    </div>
                </div>
                <div class="tool-result-actions" id="pc-result-actions" style="display:none;gap:0.5rem;padding:1rem;border-top:1px solid var(--border);flex-wrap:wrap">
                    <button type="button" class="tool-action-btn" id="pc-copy-latex-btn">Copy LaTeX</button>
                    <button type="button" class="tool-action-btn" id="pc-share-btn">Share</button>
                </div>
            </div>
        </div>

        <!-- Python Compiler Panel -->
        <div class="pc-panel" id="pc-panel-python">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--pc-tool);">
                        <polygon points="5 3 19 12 5 21 5 3"/>
                    </svg>
                    <h4>Python Compiler</h4>
                    <select id="pc-compiler-template" style="margin-left:auto;padding:0.3rem 0.5rem;border:1px solid var(--border);border-radius:0.375rem;font-size:0.75rem;font-family:var(--font-sans);background:var(--bg-primary);color:var(--text-primary);cursor:pointer;">
                        <option value="basic-pct">Basic Percentage</option>
                        <option value="discount-sim">Discount Simulator</option>
                        <option value="chain-steps">Chain Steps</option>
                    </select>
                </div>
                <div style="flex:1;min-height:0;">
                    <iframe id="pc-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                </div>
            </div>
        </div>
    </div>

    <!-- ==================== ADS COLUMN ==================== -->
    <div class="tool-ads-column">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>
</main>

<!-- Mobile Ad Fallback -->
<div class="tool-mobile-ad-container">
    <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
</div>

<!-- Related Tools -->
<jsp:include page="modern/components/related-tools.jsp">
    <jsp:param name="currentToolUrl" value="percentage-calculator.jsp"/>
    <jsp:param name="keyword" value="mathematics"/>
    <jsp:param name="limit" value="6"/>
</jsp:include>

<!-- ========== BELOW-FOLD EDUCATIONAL CONTENT ========== -->
<section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

    <!-- ===== 1. WHAT IS PERCENTAGE? ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);">What is a Percentage?</h2>
        <p class="pc-anim" style="color:var(--text-secondary);line-height:1.7;margin-bottom:1rem;">
            A <strong>percentage</strong> is a way of expressing a number as a fraction of 100. The word comes from the Latin <em>per centum</em>, meaning "by the hundred." For example, 25% means 25 out of 100, or 0.25 as a decimal. Percentages are used everywhere &mdash; shopping discounts, exam scores, interest rates, statistics, and data analysis.
        </p>

        <div class="pc-callout pc-callout-insight pc-anim pc-anim-d2">
            <span class="pc-callout-icon">&#128161;</span>
            <div class="pc-callout-text">
                <strong>Key Insight:</strong> Converting between percentages, decimals, and fractions is the foundation of all percentage calculations. To convert X% to a decimal, divide by 100. To convert a decimal to a percentage, multiply by 100.
            </div>
        </div>
    </div>

    <!-- ===== 2. KEY FORMULAS ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.5rem;color:var(--text-primary);">Key Percentage Formulas</h2>
        <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;margin-bottom:0.75rem;">
            These formulas cover all common percentage calculations.
        </p>

        <div class="pc-formulas-grid">
            <div class="pc-edu-card pc-anim pc-anim-d1" style="border-left:3px solid #16a34a;">
                <h4>Percent Of</h4>
                <p>X% of Y = (X/100) &times; Y</p>
                <p style="color:var(--text-muted);font-size:0.6875rem;">25% of 200 = 50</p>
            </div>
            <div class="pc-edu-card pc-anim pc-anim-d1" style="border-left:3px solid #22c55e;">
                <h4>What Percent</h4>
                <p>% = (X/Y) &times; 100</p>
                <p style="color:var(--text-muted);font-size:0.6875rem;">45 is 25% of 180</p>
            </div>
            <div class="pc-edu-card pc-anim pc-anim-d2" style="border-left:3px solid #dc2626;">
                <h4>Percent Change</h4>
                <p>Change = (B&minus;A)/A &times; 100%</p>
                <p style="color:var(--text-muted);font-size:0.6875rem;">120 &rarr; 150 = +25%</p>
            </div>
            <div class="pc-edu-card pc-anim pc-anim-d2" style="border-left:3px solid #7c3aed;">
                <h4>Increase / Decrease</h4>
                <p>Y &times; (1 &plusmn; X/100)</p>
                <p style="color:var(--text-muted);font-size:0.6875rem;">500 + 15% = 575</p>
            </div>
            <div class="pc-edu-card pc-anim pc-anim-d3" style="border-left:3px solid #2563eb;">
                <h4>Reverse Percentage</h4>
                <p>Original = Final &divide; (1 &minus; Disc%/100)</p>
                <p style="color:var(--text-muted);font-size:0.6875rem;">$75 after 25% off &rarr; $100</p>
            </div>
            <div class="pc-edu-card pc-anim pc-anim-d3" style="border-left:3px solid #d97706;">
                <h4>Discount + Tax</h4>
                <p>(Price &minus; Disc) + Tax</p>
                <p style="color:var(--text-muted);font-size:0.6875rem;">Full breakdown with quantity</p>
            </div>
        </div>
    </div>

    <!-- ===== 3. REAL-WORLD USES ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.5rem;color:var(--text-primary);">Real-World Uses</h2>
        <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;margin-bottom:0.75rem;">
            Percentages appear in nearly every aspect of daily life and professional work.
        </p>
        <div class="pc-formulas-grid" style="grid-template-columns:repeat(auto-fit,minmax(260px,1fr));">
            <div class="pc-edu-card" style="border-left:3px solid #16a34a;">
                <h4>Shopping &amp; Finance</h4>
                <p>Sale discounts, tax calculations, tips, interest rates, loan payments, and investment returns all use percentages.</p>
            </div>
            <div class="pc-edu-card" style="border-left:3px solid #2563eb;">
                <h4>Education &amp; Testing</h4>
                <p>Exam scores, grade calculations, GPA conversions, and performance metrics are expressed as percentages.</p>
            </div>
            <div class="pc-edu-card" style="border-left:3px solid #d97706;">
                <h4>Business &amp; Data</h4>
                <p>Profit margins, growth rates, market share, conversion rates, and KPIs rely on percentage calculations.</p>
            </div>
        </div>

        <div class="pc-callout pc-callout-tip pc-anim pc-anim-d3">
            <span class="pc-callout-icon">&#128073;</span>
            <div class="pc-callout-text">
                <strong>Try it!</strong> Use the Chain mode with +10%, -5%, +8% starting from 100 to see how successive percentage changes compound to 112.86 &mdash; not simply 100 + 13%.
            </div>
        </div>
    </div>

    <!-- FAQ Section -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How do you calculate a percentage of a number?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">To find X% of Y, multiply Y by X/100. For example, 25% of 200 = (25/100) &times; 200 = 0.25 &times; 200 = 50. The formula is: Result = (X / 100) &times; Y.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How do you calculate percent change?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Percent change = ((B &minus; A) / A) &times; 100. For example, going from 120 to 150: ((150 &minus; 120) / 120) &times; 100 = 25% increase. A negative result indicates a decrease.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How do you find the original price before a discount?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Original = Final Price &divide; (1 &minus; Discount%/100). For example, if the final price is $75 after a 25% discount: $75 &divide; 0.75 = $100 original price.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Why don't chained percentages add up simply?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Each percentage step applies to the current running total, not the original. +10% then &minus;10% does NOT return to the start. Starting at 100: +10% = 110, then &minus;10% = 99 (not 100). This is because the second step uses 110 as its base.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Is this percentage calculator free?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes, 100% free with no signup required. Features include 8 calculation modes with step-by-step KaTeX solutions, a discount + tax simulator, chained steps, a Python compiler, LaTeX export, and shareable URLs. All computation runs in your browser.</div>
        </div>
    </div>
</section>

<!-- Explore More Math -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h3 style="font-size:1.15rem;font-weight:600;margin:0 0 1rem;display:flex;align-items:center;gap:0.5rem;color:var(--text-primary);">
            Explore More Math Tools
        </h3>
        <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:1rem;">
            <a href="<%=request.getContextPath()%>/exponent-calculator.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#d97706,#f59e0b);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.1rem;color:#fff;font-weight:700;">x<sup>n</sup></div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Exponent Calculator</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">All 8 laws of exponents with steps</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/quadratic-solver.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#7c3aed,#a78bfa);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.1rem;color:#fff;font-weight:700;">x&sup2;</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Quadratic Solver</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Solve quadratic equations with 3 methods</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/logarithm-calculator.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#0d9488,#14b8a6);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.1rem;color:#fff;font-weight:700;">log</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Logarithm Calculator</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Compute logs with step-by-step solutions</p>
                </div>
            </a>
        </div>
    </div>
</section>

<!-- Support Section -->
<%@ include file="modern/components/support-section.jsp" %>

<!-- Footer -->
<footer class="page-footer">
    <div class="footer-content">
        <p class="footer-text">&copy; 2024 8gwifi.org - Free Online Tools</p>
        <div class="footer-links">
            <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
            <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
            <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
        </div>
    </div>
</footer>

<%@ include file="modern/ads/ad-sticky-footer.jsp" %>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

<!-- Scroll-triggered animations -->
<script>
(function(){
    var els = document.querySelectorAll('.pc-anim');
    if (!els.length) return;
    if (!('IntersectionObserver' in window)) {
        for (var i = 0; i < els.length; i++) els[i].classList.add('pc-visible');
        return;
    }
    var obs = new IntersectionObserver(function(entries){
        for (var j = 0; j < entries.length; j++) {
            if (entries[j].isIntersecting) {
                entries[j].target.classList.add('pc-visible');
                obs.unobserve(entries[j].target);
            }
        }
    }, { threshold: 0.15 });
    for (var k = 0; k < els.length; k++) obs.observe(els[k]);
})();
</script>

<!-- Core Scripts -->
<script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/percentage-calculator-render.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/percentage-calculator-export.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/percentage-calculator-core.js?v=<%=cacheVersion%>"></script>

<%@ include file="modern/components/analytics.jsp" %>
</body>
</html>
