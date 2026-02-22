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
        <jsp:param name="toolName" value="Chemical Equation Balancer - Free with Steps & Atom Counts" />
        <jsp:param name="toolDescription" value="Free online chemical equation balancer with steps and atom counts. Balance reactions instantly in your browser. Supports parentheses, hydrates, and redox half-reactions. Copy as text or LaTeX. No sign-up required." />
        <jsp:param name="toolCategory" value="Chemistry Tools" />
        <jsp:param name="toolUrl" value="chemical-equation-balancer.jsp" />
        <jsp:param name="toolKeywords" value="chemical equation balancer, balance chemical equations, equation balancer with steps, balance equations online free, atom count checker, chemical reaction balancer, stoichiometry calculator, redox equation balancer, LaTeX chemical equation, balance combustion reaction, balance acid base reaction" />
        <jsp:param name="toolImage" value="chem-balance.png" />
        <jsp:param name="toolFeatures" value="Instant balancing with integer coefficients using matrix method,Step-by-step atom count verification table,Live equation preview with subscript formatting,Reactant and product chips with coefficient adjustment,12 built-in example equations covering all reaction types,Copy balanced equation as text or LaTeX,Export as PNG image,Shareable URL with equation pre-loaded,Redox half-reaction combiner (beta),Searchable database of common reactions,Supports parentheses and hydrate dot notation,Dark mode support" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Enter unbalanced equation|Type a chemical equation like Fe + O2 -> Fe2O3 using + between species and -> or => as the arrow,Click Balance|The tool computes the smallest integer coefficients using Gaussian elimination on the atom matrix,Review results|Check the balanced equation and atom count table to verify every element is conserved on both sides" />
        <jsp:param name="educationalLevel" value="High School, Undergraduate" />
        <jsp:param name="teaches" value="chemical equation balancing, stoichiometry, law of conservation of mass, reaction types, redox reactions, half-reaction method" />
        <jsp:param name="faq1q" value="How does the chemical equation balancer work?" />
        <jsp:param name="faq1a" value="The balancer builds a matrix where each row represents an element and each column represents a species. It then performs Gaussian elimination using exact fraction arithmetic (via math.js) to find the nullspace, which gives the smallest set of integer coefficients that conserve all atoms. This is mathematically rigorous and works for any valid equation." />
        <jsp:param name="faq2q" value="Does it support parentheses and hydrates?" />
        <jsp:param name="faq2a" value="Yes. The parser handles nested parentheses like Ca3(PO4)2 and square brackets. Hydrate notation with the middle dot is also supported, for example CuSO4 dot 5H2O. The formula parser recursively processes groups and multiplies element counts by the subscript outside each group." />
        <jsp:param name="faq3q" value="What arrow formats are accepted?" />
        <jsp:param name="faq3a" value="You can use -> or => or the Unicode arrows (right arrow and double right arrow) or --> or even a single equals sign. The balancer recognizes all common arrow notations used in chemistry textbooks and online resources." />
        <jsp:param name="faq4q" value="Can I balance redox equations?" />
        <jsp:param name="faq4a" value="Yes, there are two ways. For simple redox equations, the atom balance mode works by finding integer coefficients. For complex redox with explicit electron transfer, use the Redox tab to enter oxidation and reduction half-reactions separately. The tool equalizes electrons and combines them into a net ionic equation." />
        <jsp:param name="faq5q" value="How do I copy the balanced equation as LaTeX?" />
        <jsp:param name="faq5a" value="After balancing, click the LaTeX button in the result area. The tool converts the equation to LaTeX notation with subscripts as _{n} and the reaction arrow as rightarrow. The LaTeX string is copied to your clipboard, ready to paste into a document or online LaTeX editor." />
        <jsp:param name="faq6q" value="Is this chemical equation balancer free and private?" />
        <jsp:param name="faq6a" value="Yes, 100 percent free with no signup required. All computation runs entirely in your browser using JavaScript. No data is sent to any server. You can use it offline once the page loads. Features include text copy, LaTeX export, PNG export, and shareable URLs." />
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
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/chemical-equation-balancer.css?v=<%=cacheVersion%>">

    <%@ include file="modern/ads/ad-init.jsp" %>

    <style>
        .tool-action-btn { background: var(--cb-gradient) !important; }
        .tool-badge { background: var(--cb-light); color: var(--cb-tool); }
    </style>
</head>
<body>
<%@ include file="modern/components/nav-header.jsp" %>

<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">Chemical Equation Balancer</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/lewis-structure-generator.jsp">Chemistry Tools</a> /
                Equation Balancer
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">Atom Balance</span>
            <span class="tool-badge">Redox</span>
            <span class="tool-badge">LaTeX Export</span>
            <span class="tool-badge">12 Examples</span>
        </div>
    </div>
</header>

<section class="tool-description-section" style="background:var(--cb-light);">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>Free <strong>chemical equation balancer</strong> with <strong>step-by-step atom counts</strong>. Enter any reaction to get the smallest <strong>integer coefficients</strong> instantly. Supports <strong>parentheses</strong>, <strong>hydrates</strong>, and <strong>redox half-reactions</strong>. Copy results as <strong>text</strong>, <strong>LaTeX</strong>, or <strong>PNG</strong>.</p>
        </div>
    </div>
</section>

<main class="tool-page-container">
    <!-- ==================== INPUT COLUMN ==================== -->
    <div class="tool-input-column">
        <div class="tool-card">
            <div class="tool-card-header" style="background:var(--cb-gradient);">Balance Equation</div>
            <div class="tool-card-body">

                <!-- Equation Input -->
                <div style="margin-bottom:0.75rem;">
                    <label class="cb-input-label" for="cb-eq">Unbalanced Equation</label>
                    <input type="text" class="cb-input" id="cb-eq" placeholder="e.g., C3H8 + O2 -> CO2 + H2O" value="Fe + O2 -> Fe2O3">
                    <div class="cb-input-hint">Use + between species and -&gt; or =&gt; as the reaction arrow.</div>
                    <div class="cb-eq-preview" id="cb-eqPreview"></div>
                </div>

                <!-- Options -->
                <div class="cb-options">
                    <label class="cb-option"><input type="checkbox" id="cb-optAuto" checked> Auto balance</label>
                    <label class="cb-option"><input type="checkbox" id="cb-optHide1" checked> Hide 1</label>
                    <label class="cb-option"><input type="checkbox" id="cb-optFrac"> Fractions</label>
                </div>

                <!-- Reactant Chips -->
                <div class="cb-chips-section">
                    <div class="cb-chips-title">Reactants</div>
                    <div class="cb-chip-bar" id="cb-chipsLeft"></div>
                    <div class="cb-add-row">
                        <input type="text" class="cb-add-input" id="cb-addLeft" placeholder="Add reactant">
                        <button type="button" class="cb-add-btn" id="cb-addLeftBtn">Add</button>
                    </div>
                </div>

                <!-- Product Chips -->
                <div class="cb-chips-section">
                    <div class="cb-chips-title">Products</div>
                    <div class="cb-chip-bar" id="cb-chipsRight"></div>
                    <div class="cb-add-row">
                        <input type="text" class="cb-add-input" id="cb-addRight" placeholder="Add product">
                        <button type="button" class="cb-add-btn" id="cb-addRightBtn">Add</button>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div style="display:flex;gap:0.5rem;margin-top:0.75rem;">
                    <button type="button" class="tool-action-btn" id="cb-balance-btn" style="flex:1">Balance</button>
                    <button type="button" class="tool-action-btn" id="cb-reset-btn" style="flex:0;min-width:60px;background:var(--bg-secondary)!important;color:var(--text-secondary);border:1px solid var(--border)">Reset</button>
                </div>

                <hr style="border:none;border-top:1px solid var(--border);margin:1rem 0">

                <!-- Quick Examples -->
                <div style="margin-bottom:0.75rem;">
                    <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:0.375rem;">
                        <label class="cb-input-label" style="margin-bottom:0;">Quick Examples</label>
                        <button type="button" class="cb-random-btn" id="cb-random-btn" title="Load random equation">&#127922; Random</button>
                    </div>
                    <div class="cb-examples">
                        <button type="button" class="cb-example-chip" data-eq="C3H8 + O2 -> CO2 + H2O">Combustion</button>
                        <button type="button" class="cb-example-chip" data-eq="Fe + O2 -> Fe2O3">Oxidation</button>
                        <button type="button" class="cb-example-chip" data-eq="Ca(OH)2 + H3PO4 -> Ca3(PO4)2 + H2O">Acid-Base</button>
                        <button type="button" class="cb-example-chip" data-eq="CuSO4.5H2O -> CuSO4 + H2O">Hydrate</button>
                        <button type="button" class="cb-example-chip" data-eq="Zn + HCl -> ZnCl2 + H2">Single Repl.</button>
                        <button type="button" class="cb-example-chip" data-eq="AgNO3 + NaCl -> AgCl + NaNO3">Double Repl.</button>
                        <button type="button" class="cb-example-chip" data-eq="KClO3 -> KCl + O2">Decomposition</button>
                        <button type="button" class="cb-example-chip" data-eq="H2 + O2 -> H2O">Synthesis</button>
                        <button type="button" class="cb-example-chip" data-eq="HCl + NaOH -> NaCl + H2O">Neutralization</button>
                        <button type="button" class="cb-example-chip" data-eq="CO2 + H2O -> C6H12O6 + O2">Photosynthesis</button>
                        <button type="button" class="cb-example-chip" data-eq="Al2(SO4)3 + Ca(OH)2 -> Al(OH)3 + CaSO4">Polyatomic</button>
                        <button type="button" class="cb-example-chip" data-eq="BaCl2 + Al2(SO4)3 -> BaSO4 + AlCl3">Precipitation</button>
                    </div>
                </div>

                <hr style="border:none;border-top:1px solid var(--border);margin:0.75rem 0">

                <!-- Worksheet Generator -->
                <div>
                    <label class="cb-input-label">Worksheet Generator</label>
                    <p style="font-size:0.75rem;color:var(--text-muted);margin:0 0 0.5rem;">Generate a printable worksheet with random equations and an answer key.</p>
                    <div style="display:flex;gap:0.5rem;align-items:center;">
                        <select id="cb-worksheet-count" style="padding:0.35rem 0.5rem;font-size:0.8125rem;border:1px solid var(--border);border-radius:0.375rem;background:var(--bg-primary);color:var(--text-primary);">
                            <option value="5">5 questions</option>
                            <option value="10" selected>10 questions</option>
                            <option value="15">15 questions</option>
                            <option value="20">20 questions</option>
                        </select>
                        <button type="button" class="cb-worksheet-btn" id="cb-worksheet-btn">Print Worksheet</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ==================== OUTPUT COLUMN ==================== -->
    <div class="tool-output-column">
        <!-- Tab bar -->
        <div class="cb-output-tabs">
            <button type="button" class="cb-output-tab active" data-panel="result">Result</button>
            <button type="button" class="cb-output-tab" data-panel="redox">Redox</button>
            <button type="button" class="cb-output-tab" data-panel="database">Database</button>
            <button type="button" class="cb-output-tab" data-panel="learn">Learn</button>
        </div>

        <!-- Result Panel -->
        <div class="cb-panel active" id="cb-panel-result">
            <div class="tool-card tool-result-card">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--cb-tool);">
                        <path d="M4 6h16M4 12h16M4 18h16"/>
                    </svg>
                    <h4>Balanced Equation</h4>
                </div>
                <div class="tool-result-content" id="cb-result-content">
                    <div class="tool-empty-state" id="cb-empty-state">
                        <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#8652;</div>
                        <h3>Enter an equation</h3>
                        <p>Type a chemical equation above to balance it automatically.</p>
                    </div>
                </div>
                <!-- History -->
                <div class="cb-history" id="cb-history-section">
                    <div class="cb-history-title">History</div>
                    <div class="cb-history-list" id="cb-historyList"></div>
                    <button type="button" class="cb-history-clear" id="cb-historyClear">Clear history</button>
                </div>
            </div>
        </div>

        <!-- Redox Panel -->
        <div class="cb-panel" id="cb-panel-redox">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--cb-tool);">
                        <path d="M7 16V4m0 0L3 8m4-4l4 4M17 8v12m0 0l4-4m-4 4l-4-4"/>
                    </svg>
                    <h4>Redox Half-Reaction Combiner (Beta)</h4>
                </div>
                <div style="padding:0.75rem;">
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin-bottom:0.75rem;">Enter balanced half-reactions with electrons (e-). The tool equalizes electrons and combines into a net reaction.</p>

                    <div class="cb-redox-group">
                        <label class="cb-redox-label" for="cb-halfOx">Oxidation Half-Reaction</label>
                        <input type="text" class="cb-redox-input" id="cb-halfOx" placeholder="e.g., Fe2+ -> Fe3+ + e-" value="Fe2+ -> Fe3+ + e-">
                    </div>
                    <div class="cb-redox-group">
                        <label class="cb-redox-label" for="cb-halfRed">Reduction Half-Reaction</label>
                        <input type="text" class="cb-redox-input" id="cb-halfRed" placeholder="e.g., MnO4- + 8H+ + 5e- -> Mn2+ + 4H2O" value="MnO4- + 8H+ + 5e- -> Mn2+ + 4H2O">
                    </div>
                    <div class="cb-redox-group">
                        <label class="cb-redox-label" for="cb-redoxMedia">Medium</label>
                        <select class="cb-medium-select" id="cb-redoxMedia">
                            <option value="acidic">Acidic (H+, H2O)</option>
                            <option value="basic">Basic (OH-, H2O)</option>
                        </select>
                    </div>
                    <div style="display:flex;gap:0.5rem;margin-top:0.75rem;">
                        <button type="button" class="tool-action-btn" id="cb-redox-combine" style="flex:1">Combine Half-Reactions</button>
                        <button type="button" class="tool-action-btn" id="cb-redox-reset" style="flex:0;min-width:60px;background:var(--bg-secondary)!important;color:var(--text-secondary);border:1px solid var(--border)">Reset</button>
                    </div>
                    <div id="cb-redoxResult"></div>
                </div>
            </div>
        </div>

        <!-- Database Panel -->
        <div class="cb-panel" id="cb-panel-database">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--cb-tool);">
                        <ellipse cx="12" cy="5" rx="9" ry="3"/><path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"/><path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"/>
                    </svg>
                    <h4>Reaction Database</h4>
                </div>
                <div style="padding:0.75rem;">
                    <input type="text" class="cb-search-input" id="cb-db-search" placeholder="Search by type, formula, or equation...">
                    <div class="cb-db-table-wrap">
                        <table class="cb-db-table">
                            <thead>
                                <tr>
                                    <th>Type</th>
                                    <th>Unbalanced</th>
                                    <th>Balanced</th>
                                </tr>
                            </thead>
                            <tbody id="cb-db-body"></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Learn Panel -->
        <div class="cb-panel" id="cb-panel-learn">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--cb-tool);">
                        <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"/><path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"/>
                    </svg>
                    <h4>Learn: Balancing Equations</h4>
                </div>
                <div class="cb-learn-section">
                    <h4>What Is a Chemical Equation?</h4>
                    <p>A chemical equation represents a reaction using chemical formulas. Reactants appear on the left and products on the right, separated by an arrow (&rarr;). Balancing ensures the <strong>law of conservation of mass</strong> is met: every atom on the left must appear on the right.</p>

                    <h4>How to Balance (Quick Steps)</h4>
                    <ol>
                        <li>Write the unbalanced equation with correct formulas.</li>
                        <li>Count atoms of each element on both sides.</li>
                        <li>Add integer coefficients to equalize atom counts.</li>
                        <li>Balance metals first, then non-metals, then H and O last.</li>
                        <li>Reduce to the smallest whole-number ratio.</li>
                    </ol>

                    <h4>Common Reaction Types</h4>
                    <ul>
                        <li><strong>Combustion:</strong> Hydrocarbon + O&#8322; &rarr; CO&#8322; + H&#8322;O</li>
                        <li><strong>Acid-Base:</strong> Acid + Base &rarr; Salt + Water</li>
                        <li><strong>Redox:</strong> Electron transfer changes oxidation states</li>
                        <li><strong>Synthesis:</strong> A + B &rarr; AB</li>
                        <li><strong>Decomposition:</strong> AB &rarr; A + B</li>
                        <li><strong>Single Replacement:</strong> A + BC &rarr; AC + B</li>
                        <li><strong>Double Replacement:</strong> AB + CD &rarr; AD + CB</li>
                    </ul>

                    <h4>Redox Primer</h4>
                    <p>Redox reactions involve electron transfer. Balance using the half-reaction method: split into oxidation and reduction half-reactions, balance atoms and charge separately, equalize electrons, then combine.</p>
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
    <jsp:param name="currentToolUrl" value="chemical-equation-balancer.jsp"/>
    <jsp:param name="keyword" value="chemistry"/>
    <jsp:param name="limit" value="6"/>
</jsp:include>

<!-- ========== BELOW-FOLD EDUCATIONAL CONTENT ========== -->
<section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

    <!-- 1. What is a Chemical Equation? -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);display:flex;align-items:center;">
            <span class="cb-section-num">1</span> What is a Chemical Equation?
        </h2>
        <p class="cb-anim" style="color:var(--text-secondary);line-height:1.7;margin-bottom:1rem;">
            A <strong>chemical equation</strong> is a symbolic representation of a chemical reaction. <strong>Reactants</strong> appear on the left side and <strong>products</strong> on the right, separated by an arrow (&rarr;). Each substance is written as a <strong>chemical formula</strong> (e.g., H&#8322;O for water). The <strong>law of conservation of mass</strong> requires that every atom present in the reactants must also appear in the products &mdash; nothing is created or destroyed, only rearranged.
        </p>
        <div class="cb-callout cb-callout-insight cb-anim cb-anim-d1">
            <span class="cb-callout-icon">&#128161;</span>
            <div class="cb-callout-text">
                <strong>Key insight:</strong> Balancing an equation means finding the smallest set of <strong>integer coefficients</strong> that make atom counts equal on both sides. This tool uses <strong>Gaussian elimination</strong> on the atom matrix for a mathematically rigorous solution.
            </div>
        </div>
    </div>

    <!-- 2. How to Balance -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);display:flex;align-items:center;">
            <span class="cb-section-num">2</span> How to Balance Chemical Equations
        </h2>
        <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;margin-bottom:1rem;">
            Follow these four steps for any equation. This is the exact process our balancer automates:
        </p>
        <div class="cb-steps-grid">
            <div class="cb-step-card cb-anim cb-anim-d1">
                <div class="cb-step-num">1</div>
                <h4>Write Formulas</h4>
                <p>Write correct chemical formulas for all reactants and products. Do not change subscripts.</p>
            </div>
            <div class="cb-step-card cb-anim cb-anim-d2">
                <div class="cb-step-num">2</div>
                <h4>Count Atoms</h4>
                <p>Count atoms of each element on both sides. Include atoms inside parentheses.</p>
            </div>
            <div class="cb-step-card cb-anim cb-anim-d3">
                <div class="cb-step-num">3</div>
                <h4>Add Coefficients</h4>
                <p>Place whole-number coefficients before formulas to equalize counts. Start with metals.</p>
            </div>
            <div class="cb-step-card cb-anim cb-anim-d4">
                <div class="cb-step-num">4</div>
                <h4>Verify &amp; Simplify</h4>
                <p>Double-check every element. Reduce coefficients to the smallest whole-number ratio.</p>
            </div>
        </div>
    </div>

    <!-- 3. Common Reaction Types -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);display:flex;align-items:center;">
            <span class="cb-section-num">3</span> Common Reaction Types
        </h2>
        <div class="cb-reaction-grid">
            <div class="cb-reaction-card cb-anim cb-anim-d1" style="border-left:3px solid #ef4444;">
                <h4>Combustion</h4>
                <p>C&#8323;H&#8328; + 5O&#8322; &rarr; 3CO&#8322; + 4H&#8322;O</p>
            </div>
            <div class="cb-reaction-card cb-anim cb-anim-d2" style="border-left:3px solid #3b82f6;">
                <h4>Acid-Base</h4>
                <p>HCl + NaOH &rarr; NaCl + H&#8322;O</p>
            </div>
            <div class="cb-reaction-card cb-anim cb-anim-d3" style="border-left:3px solid #8b5cf6;">
                <h4>Synthesis</h4>
                <p>2H&#8322; + O&#8322; &rarr; 2H&#8322;O</p>
            </div>
            <div class="cb-reaction-card cb-anim cb-anim-d4" style="border-left:3px solid #f59e0b;">
                <h4>Decomposition</h4>
                <p>2KClO&#8323; &rarr; 2KCl + 3O&#8322;</p>
            </div>
            <div class="cb-reaction-card cb-anim cb-anim-d1" style="border-left:3px solid #059669;">
                <h4>Single Replacement</h4>
                <p>Zn + 2HCl &rarr; ZnCl&#8322; + H&#8322;</p>
            </div>
            <div class="cb-reaction-card cb-anim cb-anim-d2" style="border-left:3px solid #ec4899;">
                <h4>Double Replacement</h4>
                <p>AgNO&#8323; + NaCl &rarr; AgCl + NaNO&#8323;</p>
            </div>
        </div>
    </div>

    <!-- 4. Redox Primer -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);display:flex;align-items:center;">
            <span class="cb-section-num">4</span> Redox Reactions Primer
        </h2>
        <p class="cb-anim" style="color:var(--text-secondary);line-height:1.7;margin-bottom:1rem;">
            <strong>Redox</strong> (reduction&ndash;oxidation) reactions involve <strong>electron transfer</strong>. The substance that loses electrons is <strong>oxidized</strong>; the one that gains electrons is <strong>reduced</strong>. Use the <strong>half-reaction method</strong> to balance:
        </p>
        <ol style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;padding-left:1.25rem;margin-bottom:1rem;">
            <li>Split into oxidation and reduction half-reactions</li>
            <li>Balance atoms other than O and H</li>
            <li>Balance O with H&#8322;O and H with H&#8314; (acidic) or OH&#8315; (basic)</li>
            <li>Balance charge with electrons (e&#8315;)</li>
            <li>Equalize electrons between half-reactions and combine</li>
        </ol>
        <div class="cb-callout cb-callout-insight cb-anim cb-anim-d1">
            <span class="cb-callout-icon">&#128073;</span>
            <div class="cb-callout-text">
                <strong>Tip:</strong> Use the Redox tab in our tool to enter your balanced half-reactions directly. It will equalize electrons and produce the net ionic equation automatically.
            </div>
        </div>
    </div>

    <!-- FAQ Section -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>

        <div class="cb-faq-item">
            <button class="cb-faq-question">
                How does the chemical equation balancer work?
                <svg class="cb-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="cb-faq-answer">The balancer builds a matrix where each row represents an element and each column represents a species. It performs Gaussian elimination using exact fraction arithmetic (via math.js) to find the nullspace &mdash; the smallest set of integer coefficients that conserve all atoms. This is mathematically rigorous and works for any valid equation.</div>
        </div>

        <div class="cb-faq-item">
            <button class="cb-faq-question">
                Does it support parentheses and hydrates?
                <svg class="cb-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="cb-faq-answer">Yes. The parser handles nested parentheses like Ca&#8323;(PO&#8324;)&#8322; and square brackets. Hydrate notation with the middle dot (&middot;) is also supported, for example CuSO&#8324;&middot;5H&#8322;O. The formula parser recursively processes groups and multiplies element counts by the subscript.</div>
        </div>

        <div class="cb-faq-item">
            <button class="cb-faq-question">
                What arrow formats are accepted?
                <svg class="cb-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="cb-faq-answer">You can use -&gt; or =&gt; or the Unicode arrows (&rarr; and &rArr;) or --&gt; or even a single equals sign (=). The balancer recognizes all common arrow notations used in chemistry textbooks and online resources.</div>
        </div>

        <div class="cb-faq-item">
            <button class="cb-faq-question">
                Can I balance redox equations?
                <svg class="cb-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="cb-faq-answer">Yes, there are two ways. For simple redox equations, the atom balance mode works by finding integer coefficients. For complex redox with explicit electron transfer, use the Redox tab to enter oxidation and reduction half-reactions separately. The tool equalizes electrons and combines them into a net ionic equation.</div>
        </div>

        <div class="cb-faq-item">
            <button class="cb-faq-question">
                How do I copy the balanced equation as LaTeX?
                <svg class="cb-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="cb-faq-answer">After balancing, click the LaTeX button in the result area. The tool converts the equation to LaTeX notation with subscripts as _{n} and the reaction arrow as \rightarrow. The LaTeX string is copied to your clipboard.</div>
        </div>

        <div class="cb-faq-item">
            <button class="cb-faq-question">
                Is this chemical equation balancer free and private?
                <svg class="cb-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="cb-faq-answer">Yes, 100% free with no signup. All computation runs entirely in your browser using JavaScript. No data is sent to any server. Features include text copy, LaTeX export, PNG export, and shareable URLs.</div>
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
            <a href="<%=request.getContextPath()%>/electron-configuration-calculator.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#dc2626,#ef4444);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.1rem;color:#fff;font-weight:700;">e&#8315;</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Electron Configuration</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Find electron configurations for any element</p>
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

<!-- Core Scripts -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/mathjs/14.0.1/math.min.js"></script>
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/chemical-equation-balancer-render.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/chemical-equation-balancer-core.js?v=<%=cacheVersion%>"></script>

<%@ include file="modern/components/analytics.jsp" %>
</body>
</html>
