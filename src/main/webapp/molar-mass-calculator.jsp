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
        <jsp:param name="toolName" value="FREE Molar Mass Calculator - Chemical Formula Parser & Molecular Weight | 8gwifi.org" />
        <jsp:param name="toolDescription" value="Free online molar mass calculator: Calculate molecular weight, parse chemical formulas, get elemental composition, mass percentages. Supports compounds like H2SO4, Ca(OH)2, hydrates. Educational chemistry tool for students, teachers, lab work." />
        <jsp:param name="toolCategory" value="Chemistry Tools" />
        <jsp:param name="toolUrl" value="molar-mass-calculator.jsp" />
        <jsp:param name="toolKeywords" value="molar mass calculator, molecular weight calculator, chemical formula parser, molecular mass, elemental composition, mass percentage, chemistry calculator, stoichiometry calculator, compound molar mass, molecule weight, chemistry tools, molecular formula calculator, free chemistry calculator" />
        <jsp:param name="toolImage" value="molar-mass-calculator-screenshot.png" />
        <jsp:param name="toolFeatures" value="Real-time molar mass calculation with 500ms debounce,Interactive periodic table with 92 elements (IUPAC 2021),47+ pre-loaded common compounds across 8 categories,Stack-based formula parser supporting parentheses brackets and hydrates,Coefficient support for multiple molecules,Visual elemental composition breakdown with percentage bars,Color-coded element categories,Shareable calculation URLs,Copy results to clipboard,Mobile responsive design,Dark mode support,No registration required" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Enter chemical formula|Type a formula like H2SO4 or Ca(OH)2 or CuSO4 dot 5H2O. Use example chips for quick access,View results|The molar mass and elemental composition appear automatically with percentage breakdown,Explore periodic table|Switch to the Periodic Table tab to click elements and build formulas visually" />
        <jsp:param name="educationalLevel" value="High School, Undergraduate" />
        <jsp:param name="teaches" value="molar mass, molecular weight, elemental composition, stoichiometry, chemical formulas, periodic table" />
        <jsp:param name="faq1q" value="What is molar mass?" />
        <jsp:param name="faq1a" value="Molar mass is the mass of one mole of a substance expressed in grams per mole (g/mol). One mole contains exactly 6.022 times 10 to the 23rd particles (Avogadro number). It allows chemists to convert between mass and amount in chemical reactions." />
        <jsp:param name="faq2q" value="How do I calculate molar mass?" />
        <jsp:param name="faq2a" value="To calculate molar mass: 1) Write the chemical formula, 2) Identify all elements and count their atoms, 3) Find atomic masses from the periodic table, 4) Multiply atomic mass by number of atoms for each element, 5) Add all values. For example H2O equals (2 times 1.008) plus (1 times 15.999) equals 18.015 g/mol." />
        <jsp:param name="faq3q" value="What is the difference between molar mass and molecular weight?" />
        <jsp:param name="faq3a" value="Molar mass is expressed in g/mol and refers to the mass of 1 mole of substance. Molecular weight is expressed in amu (atomic mass units) and refers to the mass of 1 molecule. Numerically they are the same but differ in units and context of use." />
        <jsp:param name="faq4q" value="Can this calculator handle complex formulas?" />
        <jsp:param name="faq4a" value="Yes. This calculator supports complex formulas including parentheses like Ca(OH)2, brackets like [Cu(NH3)4]SO4, hydrates like CuSO4 dot 5H2O, and coefficients like 3H2SO4. It includes 47+ pre-loaded compounds from basic to complex organic molecules." />
        <jsp:param name="faq5q" value="Is this molar mass calculator free?" />
        <jsp:param name="faq5a" value="Yes, 100 percent free with no registration required. All computation runs entirely in your browser using JavaScript. No data is sent to any server. Features include interactive periodic table, 47+ compound library, and real-time calculations." />
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
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/molar-mass-calculator.css?v=<%=cacheVersion%>">

    <%@ include file="modern/ads/ad-init.jsp" %>

    <style>
        .tool-action-btn { background: var(--mm-gradient) !important; }
        .tool-badge { background: var(--mm-light); color: var(--mm-tool); }
    </style>
</head>
<body>
<%@ include file="modern/components/nav-header.jsp" %>

<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">Molar Mass Calculator</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/lewis-structure-generator.jsp">Chemistry Tools</a> /
                Molar Mass Calculator
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">92 Elements</span>
            <span class="tool-badge">47+ Compounds</span>
            <span class="tool-badge">Live Calculation</span>
            <span class="tool-badge">IUPAC 2021</span>
        </div>
    </div>
</header>

<section class="tool-description-section" style="background:var(--mm-light);">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>Free <strong>molar mass calculator</strong> with <strong>elemental composition breakdown</strong>. Enter any chemical formula to get the <strong>molecular weight</strong> instantly. Supports <strong>parentheses</strong>, <strong>brackets</strong>, <strong>hydrates</strong>, and <strong>coefficients</strong>. Includes an <strong>interactive periodic table</strong> and <strong>47+ pre-loaded compounds</strong>.</p>
        </div>
    </div>
</section>

<main class="tool-page-container">
    <!-- ==================== INPUT COLUMN ==================== -->
    <div class="tool-input-column">
        <div class="tool-card">
            <div class="tool-card-header" style="background:var(--mm-gradient);">Calculate Molar Mass</div>
            <div class="tool-card-body">

                <!-- Formula Input -->
                <div style="margin-bottom:0.75rem;">
                    <label class="mm-input-label" for="mm-formula">Chemical Formula</label>
                    <input type="text" class="mm-input" id="mm-formula" placeholder="e.g., H2SO4, Ca(OH)2, CuSO4&middot;5H2O" value="">
                    <div class="mm-input-hint">Supports elements, parentheses, brackets, hydrate dot (&middot;), and leading coefficients.</div>
                    <div class="mm-formula-preview" id="mm-preview"></div>
                </div>

                <!-- Calculate Button -->
                <button type="button" class="tool-action-btn" id="mm-calc-btn" style="width:100%;">Calculate Molar Mass</button>

                <hr style="border:none;border-top:1px solid var(--border);margin:1rem 0">

                <!-- Example Chips -->
                <div style="margin-bottom:0.75rem;">
                    <label class="mm-input-label" style="margin-bottom:0.375rem;">Quick Examples</label>
                    <div class="mm-examples">
                        <button type="button" class="mm-example-chip" data-formula="H2O">H&#8322;O</button>
                        <button type="button" class="mm-example-chip" data-formula="C6H12O6">C&#8326;H&#8321;&#8322;O&#8326;</button>
                        <button type="button" class="mm-example-chip" data-formula="NaCl">NaCl</button>
                        <button type="button" class="mm-example-chip" data-formula="H2SO4">H&#8322;SO&#8324;</button>
                        <button type="button" class="mm-example-chip" data-formula="Ca(OH)2">Ca(OH)&#8322;</button>
                        <button type="button" class="mm-example-chip" data-formula="CuSO4&middot;5H2O">CuSO&#8324;&middot;5H&#8322;O</button>
                    </div>
                </div>

                <hr style="border:none;border-top:1px solid var(--border);margin:0.75rem 0">

                <!-- Action Buttons -->
                <div class="mm-actions">
                    <button type="button" class="mm-action-btn" data-action="share">&#128279; Share</button>
                    <button type="button" class="mm-action-btn" data-action="copy">&#128203; Copy</button>
                    <button type="button" class="mm-action-btn" data-action="print">&#128424; Print</button>
                </div>

                <!-- Recent Calculations -->
                <div class="mm-history" id="mm-history-section" style="display:none;">
                    <div class="mm-history-title">Recent Calculations</div>
                    <div class="mm-history-list" id="mm-history-list"></div>
                    <button type="button" class="mm-history-clear" id="mm-history-clear">Clear history</button>
                </div>
            </div>
        </div>
    </div>

    <!-- ==================== OUTPUT COLUMN ==================== -->
    <div class="tool-output-column">
        <!-- Tab bar -->
        <div class="mm-output-tabs">
            <button type="button" class="mm-output-tab active" data-panel="result">Result</button>
            <button type="button" class="mm-output-tab" data-panel="ptable">Periodic Table</button>
            <button type="button" class="mm-output-tab" data-panel="compounds">Compounds</button>
            <button type="button" class="mm-output-tab" data-panel="learn">Learn</button>
        </div>

        <!-- Result Panel -->
        <div class="mm-panel active" id="mm-panel-result">
            <div class="tool-card tool-result-card">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--mm-tool);">
                        <circle cx="12" cy="12" r="10"/><path d="M8 12h8M12 8v8"/>
                    </svg>
                    <h4>Molar Mass Result</h4>
                </div>
                <div class="tool-result-content">
                    <!-- Empty State -->
                    <div id="mm-empty-state" style="text-align:center;padding:2rem 1rem;">
                        <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#9883;</div>
                        <h3 style="font-size:1rem;color:var(--text-primary);margin:0 0 0.5rem;">Enter a formula</h3>
                        <p style="font-size:0.8125rem;color:var(--text-muted);margin:0;">Type a chemical formula above or click an example chip.</p>
                    </div>

                    <!-- Result Content (hidden until calculation) -->
                    <div id="mm-result-content" style="display:none;">
                        <!-- Mass Card -->
                        <div class="mm-mass-card">
                            <div class="mm-mass-label">Molar Mass</div>
                            <div class="mm-mass-value" id="mm-mass-value">0</div>
                            <div class="mm-mass-unit">g/mol</div>
                            <div class="mm-compound-name" id="mm-compound-label"></div>
                            <div class="mm-formula-display" id="mm-formula-rendered"></div>
                        </div>

                        <!-- Composition Table -->
                        <div class="mm-comp-table-wrap">
                            <table class="mm-comp-table">
                                <thead>
                                    <tr>
                                        <th>Element</th>
                                        <th>Atoms</th>
                                        <th>Atomic Mass</th>
                                        <th>Mass %</th>
                                        <th>Visual</th>
                                    </tr>
                                </thead>
                                <tbody id="mm-comp-tbody"></tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Periodic Table Panel -->
        <div class="mm-panel" id="mm-panel-ptable">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--mm-tool);">
                        <rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/>
                    </svg>
                    <h4>Interactive Periodic Table</h4>
                </div>
                <div style="padding:0.75rem;">
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin-bottom:0.75rem;">Click elements to select them, then build a formula. All 92 elements with IUPAC 2021 atomic masses.</p>
                    <div class="mm-ptable-legend" id="mm-ptable-legend"></div>
                    <div class="mm-ptable-grid" id="mm-ptable"></div>

                    <!-- Selected Elements -->
                    <div id="mm-selected-section" style="display:none;margin-top:0.75rem;">
                        <label class="mm-input-label">Selected Elements</label>
                        <div class="mm-selected-elements" id="mm-selected-elements"></div>
                        <div style="display:flex;gap:0.5rem;">
                            <button type="button" class="tool-action-btn" id="mm-build-btn" style="flex:1;">Build Formula &amp; Calculate</button>
                            <button type="button" class="mm-action-btn" id="mm-clear-sel">Clear</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Compounds Panel -->
        <div class="mm-panel" id="mm-panel-compounds">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--mm-tool);">
                        <ellipse cx="12" cy="5" rx="9" ry="3"/><path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"/><path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"/>
                    </svg>
                    <h4>Common Compounds Library</h4>
                </div>
                <div style="padding:0.75rem;">
                    <input type="text" class="mm-search-input" id="mm-compound-search" placeholder="Search by name, formula, or category...">
                    <div class="mm-compounds-grid" id="mm-compounds-list"></div>
                </div>
            </div>
        </div>

        <!-- Learn Panel -->
        <div class="mm-panel" id="mm-panel-learn">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--mm-tool);">
                        <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"/><path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"/>
                    </svg>
                    <h4>Learn: Molar Mass</h4>
                </div>
                <div class="mm-learn-section">
                    <h4>What Is Molar Mass?</h4>
                    <p><strong>Molar mass</strong> is the mass of one mole of a substance, expressed in <strong>grams per mole (g/mol)</strong>. One mole contains exactly 6.022 &times; 10&sup2;&sup3; particles (Avogadro's number). It allows chemists to convert between mass and amount in chemical reactions.</p>

                    <h4>How to Calculate</h4>
                    <ol>
                        <li>Write the chemical formula of the compound.</li>
                        <li>Identify all elements and count their atoms (including inside parentheses).</li>
                        <li>Look up each element's atomic mass from the periodic table.</li>
                        <li>Multiply atomic mass &times; number of atoms for each element.</li>
                        <li>Add all values to get the total molar mass.</li>
                    </ol>

                    <div class="mm-learn-callout">
                        <strong>Example:</strong> H&#8322;O = (2 &times; 1.008) + (1 &times; 15.999) = <strong>18.015 g/mol</strong>
                    </div>

                    <h4>Molar Mass vs. Molecular Weight</h4>
                    <p><strong>Molar mass</strong> (g/mol) refers to the mass of 1 mole. <strong>Molecular weight</strong> (amu) refers to the mass of 1 molecule. Numerically they are the same &mdash; the difference is in units and context.</p>

                    <h4>Supported Formula Syntax</h4>
                    <ul>
                        <li><strong>Elements:</strong> H, O, C, Na, Fe, etc.</li>
                        <li><strong>Subscripts:</strong> H2O, CO2, C6H12O6</li>
                        <li><strong>Parentheses:</strong> Ca(OH)2, Al2(SO4)3</li>
                        <li><strong>Brackets:</strong> [Cu(NH3)4]SO4</li>
                        <li><strong>Hydrates:</strong> CuSO4&middot;5H2O (use dot)</li>
                        <li><strong>Coefficients:</strong> 3H2SO4 (3 molecules)</li>
                    </ul>

                    <h4>Tips &amp; Common Mistakes</h4>
                    <ul>
                        <li>Don't forget to multiply subscripts inside parentheses: Ca(OH)&#8322; has <strong>2</strong> O and <strong>2</strong> H.</li>
                        <li>Coefficients multiply the entire formula: 3H&#8322;SO&#8324; = 3 &times; 98.079 g/mol.</li>
                        <li>Always use IUPAC 2021 atomic masses for accuracy.</li>
                        <li>Round only at the final step to avoid cumulative errors.</li>
                    </ul>
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
    <jsp:param name="currentToolUrl" value="molar-mass-calculator.jsp"/>
    <jsp:param name="keyword" value="chemistry"/>
    <jsp:param name="limit" value="6"/>
</jsp:include>

<!-- ========== BELOW-FOLD EDUCATIONAL CONTENT ========== -->
<section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

    <!-- 1. What is Molar Mass? -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);display:flex;align-items:center;">
            <span class="mm-section-num">1</span> What is Molar Mass?
        </h2>
        <p class="mm-anim" style="color:var(--text-secondary);line-height:1.7;margin-bottom:1rem;">
            <strong>Molar mass</strong> is the mass of one mole of a substance (chemical element or compound), expressed in <strong>grams per mole (g/mol)</strong>. One mole contains exactly 6.022 &times; 10&sup2;&sup3; particles (Avogadro's number), whether they are atoms, molecules, ions, or electrons. Molar mass allows chemists to convert between <strong>mass</strong> (grams) and <strong>amount</strong> (moles) in chemical reactions.
        </p>
        <div class="mm-callout mm-callout-insight mm-anim mm-anim-d1">
            <span class="mm-callout-icon">&#128161;</span>
            <div class="mm-callout-text">
                <strong>Key insight:</strong> Numerically, molar mass (g/mol) equals molecular weight (amu). The difference is in <strong>units and context</strong>. This calculator uses <strong>IUPAC 2021</strong> standard atomic weights for all 92 elements.
            </div>
        </div>
    </div>

    <!-- 2. How to Calculate -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);display:flex;align-items:center;">
            <span class="mm-section-num">2</span> How to Calculate Molar Mass
        </h2>
        <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;margin-bottom:1rem;">
            Follow these five steps for any compound. This is the exact process our calculator automates:
        </p>
        <div class="mm-steps-grid">
            <div class="mm-step-card mm-anim mm-anim-d1">
                <div class="mm-step-num">1</div>
                <h4>Write Formula</h4>
                <p>Write the correct chemical formula for the compound.</p>
            </div>
            <div class="mm-step-card mm-anim mm-anim-d2">
                <div class="mm-step-num">2</div>
                <h4>Count Atoms</h4>
                <p>Identify all elements and count atoms, including inside parentheses.</p>
            </div>
            <div class="mm-step-card mm-anim mm-anim-d3">
                <div class="mm-step-num">3</div>
                <h4>Look Up Masses</h4>
                <p>Find each element's atomic mass from the periodic table.</p>
            </div>
            <div class="mm-step-card mm-anim mm-anim-d4">
                <div class="mm-step-num">4</div>
                <h4>Multiply</h4>
                <p>Atomic mass &times; number of atoms for each element.</p>
            </div>
            <div class="mm-step-card mm-anim mm-anim-d1">
                <div class="mm-step-num">5</div>
                <h4>Sum Total</h4>
                <p>Add all values to get the molar mass in g/mol.</p>
            </div>
        </div>
    </div>

    <!-- 3. Worked Examples -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);display:flex;align-items:center;">
            <span class="mm-section-num">3</span> Worked Examples
        </h2>

        <div class="mm-example-calc mm-anim mm-anim-d1">
            <strong>Water (H&#8322;O):</strong><br>
            H: 2 &times; 1.008 = 2.016 &nbsp;|&nbsp; O: 1 &times; 15.999 = 15.999<br>
            <strong>Total: <code>18.015 g/mol</code></strong>
        </div>

        <div class="mm-example-calc mm-anim mm-anim-d2">
            <strong>Sulfuric Acid (H&#8322;SO&#8324;):</strong><br>
            H: 2 &times; 1.008 = 2.016 &nbsp;|&nbsp; S: 1 &times; 32.06 = 32.06 &nbsp;|&nbsp; O: 4 &times; 15.999 = 63.996<br>
            <strong>Total: <code>98.072 g/mol</code></strong>
        </div>

        <div class="mm-example-calc mm-anim mm-anim-d3">
            <strong>Calcium Hydroxide Ca(OH)&#8322;:</strong><br>
            Ca: 1 &times; 40.078 = 40.078 &nbsp;|&nbsp; O: 2 &times; 15.999 = 31.998 &nbsp;|&nbsp; H: 2 &times; 1.008 = 2.016<br>
            <strong>Total: <code>74.092 g/mol</code></strong>
        </div>

        <div class="mm-example-calc mm-anim mm-anim-d4">
            <strong>Copper Sulfate Pentahydrate CuSO&#8324;&middot;5H&#8322;O:</strong><br>
            CuSO&#8324;: 63.546 + 32.06 + 63.996 = 159.602 &nbsp;|&nbsp; 5H&#8322;O: 5 &times; 18.015 = 90.075<br>
            <strong>Total: <code>249.677 g/mol</code></strong>
        </div>
    </div>

    <!-- 4. Real-World Applications -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);display:flex;align-items:center;">
            <span class="mm-section-num">4</span> Real-World Applications
        </h2>
        <div style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;">
            <ul style="padding-left:1.25rem;margin:0.5rem 0;">
                <li class="mm-anim mm-anim-d1"><strong>Laboratory preparation:</strong> Weigh precise amounts of reagents for solutions and experiments.</li>
                <li class="mm-anim mm-anim-d2"><strong>Stoichiometry:</strong> Convert between grams and moles to predict reaction yields.</li>
                <li class="mm-anim mm-anim-d3"><strong>Pharmaceutical industry:</strong> Calculate precise drug dosages and active ingredient concentrations.</li>
                <li class="mm-anim mm-anim-d4"><strong>Environmental science:</strong> Measure CO&#8322; emissions and pollutant concentrations.</li>
            </ul>
        </div>
    </div>

    <!-- FAQ Section -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>

        <div class="mm-faq-item">
            <button class="mm-faq-question">
                What is molar mass and why is it important?
                <svg class="mm-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="mm-faq-answer">Molar mass is the mass of one mole of a substance (g/mol). It is essential for converting between mass and moles in chemical calculations, preparing solutions with precise concentrations, and predicting reaction yields in stoichiometry.</div>
        </div>

        <div class="mm-faq-item">
            <button class="mm-faq-question">
                How does this calculator handle hydrates like CuSO&#8324;&middot;5H&#8322;O?
                <svg class="mm-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="mm-faq-answer">The parser treats the dot (&middot;) as a separator. It calculates the anhydrous part (CuSO&#8324; = 159.602 g/mol) and the hydrate part (5H&#8322;O = 90.075 g/mol) then adds them together for the total (249.677 g/mol). All element counts are combined correctly.</div>
        </div>

        <div class="mm-faq-item">
            <button class="mm-faq-question">
                What is the difference between molar mass and molecular weight?
                <svg class="mm-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="mm-faq-answer">Molar mass is expressed in g/mol and refers to the mass of 1 mole. Molecular weight is expressed in amu (atomic mass units) and refers to the mass of 1 molecule. Numerically they are the same &mdash; the difference is in units and context of use. For ionic compounds, the term "formula mass" is preferred.</div>
        </div>

        <div class="mm-faq-item">
            <button class="mm-faq-question">
                Can I use coefficients like 3H&#8322;SO&#8324;?
                <svg class="mm-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="mm-faq-answer">Yes. A leading number is treated as a coefficient that multiplies all element counts. For example, 3H&#8322;SO&#8324; = 3 &times; 98.079 = 294.237 g/mol. This is useful for stoichiometry when calculating total mass of multiple molecules.</div>
        </div>

        <div class="mm-faq-item">
            <button class="mm-faq-question">
                Is this calculator free and does it require an account?
                <svg class="mm-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="mm-faq-answer">Yes, 100% free with no signup. All computation runs entirely in your browser using JavaScript. No data is sent to any server. Features include interactive periodic table, 47+ compound library, shareable URLs, and clipboard copy.</div>
        </div>
    </div>
</section>

<!-- Explore More Chemistry Tools -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h3 style="font-size:1.15rem;font-weight:600;margin:0 0 1rem;display:flex;align-items:center;gap:0.5rem;color:var(--text-primary);">
            Explore More Chemistry Tools
        </h3>
        <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:1rem;">
            <a href="<%=request.getContextPath()%>/chemical-equation-balancer.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#ec4899,#f472b6);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.2rem;color:#fff;">&#8652;</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Chemical Equation Balancer</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Balance equations with steps &amp; atom counts</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/lewis-structure-generator.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#059669,#10b981);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.2rem;color:#fff;">&#9883;</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Lewis Structure Generator</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Draw Lewis structures with VSEPR shapes</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/molecular-geometry-calculator.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#059669,#10b981);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.1rem;color:#fff;font-weight:700;">3D</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">3D Molecular Geometry</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Interactive VSEPR 3D visualizer</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/electronegativity-polarity-checker.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#4f46e5,#818cf8);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.1rem;color:#fff;font-weight:700;">&#916;</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Polarity Checker</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Check EN differences and molecular polarity</p>
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
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/molar-mass-calculator.js?v=<%=cacheVersion%>"></script>
<%@ include file="modern/components/analytics.jsp" %>
</body>
</html>
