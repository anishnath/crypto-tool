<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<jsp:include page="modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="Stoichiometry Calculator" />
    <jsp:param name="toolCategory" value="Chemistry" />
    <jsp:param name="toolDescription" value="Free stoichiometry calculator: convert grams ↔ moles ↔ molecules/atoms, find the limiting reactant, calculate theoretical, actual and percent yield, and solve mole/mass/volume problems directly from a balanced equation." />
    <jsp:param name="toolUrl" value="stoichiometry-calculator.jsp" />
    <jsp:param name="toolKeywords" value="stoichiometry calculator, mole calculator, grams to moles, moles to grams, limiting reactant calculator, percent yield calculator, theoretical yield, mole ratio, gas at STP, stoichiometry from equation" />
    <jsp:param name="toolImage" value="stoichiometry.png" />
    <jsp:param name="breadcrumbCategoryUrl" value="chemistry/" />
    <jsp:param name="teaches" value="stoichiometry, mole conversions, Avogadro's number, limiting reactant, percent yield, mole ratios, gas volume at STP" />
    <jsp:param name="educationalLevel" value="High School, Undergraduate" />
    <jsp:param name="hasSteps" value="true" />
    <jsp:param name="howToSteps" value="Pick a tab|Choose mole conversions, limiting reactant, percent yield, or solving from a balanced equation,Enter what you know|Type your amounts (grams, moles, molecules, or litres at STP) and molar masses,Calculate|The tool shows the answer with the full worked steps you can copy" />
    <jsp:param name="faq1q" value="What is stoichiometry?" />
    <jsp:param name="faq1a" value="Stoichiometry is the calculation of the amounts of reactants and products in a chemical reaction. It uses the balanced equation's mole ratios together with molar masses to convert between mass, moles, particles, and gas volume." />
    <jsp:param name="faq2q" value="How do you convert grams to moles?" />
    <jsp:param name="faq2a" value="Divide the mass in grams by the molar mass: moles = grams ÷ molar mass. For example, 18 g of water (molar mass 18.015 g/mol) is 18 ÷ 18.015 ≈ 1.00 mol." />
    <jsp:param name="faq3q" value="What is a limiting reactant?" />
    <jsp:param name="faq3a" value="The limiting reactant is the one that runs out first and therefore caps how much product can form. Convert each reactant to moles, divide by its coefficient, and the smallest result is limiting; the others are in excess." />
    <jsp:param name="faq4q" value="How do you calculate percent yield?" />
    <jsp:param name="faq4a" value="Percent yield = (actual yield ÷ theoretical yield) × 100. The theoretical yield is the maximum predicted by stoichiometry; the actual yield is what you obtain. A value below 100% is normal due to losses and side reactions." />
    <jsp:param name="faq5q" value="How many litres is one mole of gas at STP?" />
    <jsp:param name="faq5a" value="At STP (0°C and 1 atm) one mole of any ideal gas occupies 22.4 litres. So 2 moles of H₂ is 2 × 22.4 = 44.8 L." />
    <jsp:param name="faq6q" value="Is this stoichiometry calculator free?" />
    <jsp:param name="faq6a" value="Yes. It is completely free and needs no signup. The From Equation tab auto-balances using the open-source chempy library with exact molar masses; the other tabs run instantly in your browser." />
</jsp:include>

<link rel="stylesheet" href="<%=ctx%>/modern/css/design-system.css">
<link rel="stylesheet" href="<%=ctx%>/modern/css/navigation.css">
<link rel="stylesheet" href="<%=ctx%>/chemistry/css/chemistry-studio.css">
<link rel="stylesheet" href="<%=ctx%>/modern/css/ads.css">
<link rel="stylesheet" href="<%=ctx%>/modern/css/dark-mode.css">
<link rel="stylesheet" href="<%=ctx%>/modern/css/footer.css">
<link rel="stylesheet" href="<%=ctx%>/modern/css/search.css">

<%@ include file="modern/ads/ad-init.jsp" %>

<style>
    .st-tabs { display:flex; flex-wrap:wrap; gap:0.4rem; margin:0 0 1rem; }
    .st-tab { border:1px solid var(--cs-line-strong); background:var(--cs-panel-bg); color:var(--cs-ink-soft); border-radius:var(--cs-radius-pill); padding:0.45rem 0.95rem; font:600 0.82rem var(--cs-font-sans); cursor:pointer; transition:all var(--cs-transition); }
    .st-tab:hover { border-color:var(--cs-accent); color:var(--cs-accent); }
    .st-tab.active { background:var(--cs-accent); color:#fff; border-color:var(--cs-accent); }

    .st-lab { display:block; font:600 0.7rem var(--cs-font-sans); text-transform:uppercase; letter-spacing:0.04em; color:var(--cs-muted); margin:0 0 0.35rem; }
    .st-field { margin-bottom:0.9rem; }
    .st-input, .st-select { width:100%; padding:0.6rem 0.85rem; border:1.5px solid var(--cs-line-strong); border-radius:var(--cs-radius-sm); background:var(--cs-panel-bg-soft); color:var(--cs-ink); font:15px var(--cs-font-sans); transition:border-color var(--cs-transition), box-shadow var(--cs-transition); }
    .st-input:focus, .st-select:focus { outline:none; border-color:var(--cs-accent); background:var(--cs-panel-bg); box-shadow:var(--cs-ring); }
    .st-input.mono { font-family:var(--cs-font-mono); }
    .st-preview { margin:0.45rem 0 0; min-height:1.4em; font:1.1rem var(--cs-font-serif); color:var(--cs-ink); }
    .st-preview .conversion-arrow { color:var(--cs-accent); margin:0 0.15rem; }
    .st-row { display:flex; flex-wrap:wrap; gap:0.7rem; }
    .st-row .st-field { flex:1 1 30%; min-width:90px; margin-bottom:0; }
    .st-subhead { font:600 0.78rem var(--cs-font-sans); color:var(--cs-ink); margin:1rem 0 0.5rem; }
    .st-help { font-size:0.78rem; color:var(--cs-muted); margin:0.3rem 0 0; }
    .st-help a { color:var(--cs-accent); }
    .st-btnbar { display:flex; flex-wrap:wrap; gap:0.5rem; margin-top:1rem; }
    .st-btn { display:inline-flex; align-items:center; gap:0.4rem; padding:0.55rem 1.15rem; border-radius:var(--cs-radius-pill); background:var(--cs-accent); color:#fff; border:1px solid var(--cs-accent); font:600 0.82rem var(--cs-font-sans); cursor:pointer; transition:background var(--cs-transition), transform 0.1s var(--cs-ease); }
    .st-btn:hover { background:var(--cs-accent-hover); transform:translateY(-1px); }
    .st-btn-ghost { background:none; color:var(--cs-ink-soft); border:1px solid var(--cs-line-strong); }
    .st-btn-ghost:hover { border-color:var(--cs-accent); color:var(--cs-accent); background:var(--cs-accent-softer); transform:none; }
    .preset-reaction { display:inline-block; padding:0.35rem 0.7rem; margin:0.2rem 0.2rem 0 0; background:var(--cs-accent-softer); border:1px solid var(--cs-accent-ring); border-radius:var(--cs-radius-pill); cursor:pointer; font:500 12px var(--cs-font-mono); color:var(--cs-ink-soft); }
    .preset-reaction:hover { border-color:var(--cs-accent); color:var(--cs-accent); }

    .st-card { background:var(--cs-panel-bg); border:1px solid var(--cs-line); border-radius:var(--cs-radius-lg); box-shadow:var(--cs-shadow-sm); padding:1.4rem; }
    .st-card-head { font:600 0.72rem var(--cs-font-sans); text-transform:uppercase; letter-spacing:0.08em; color:var(--cs-muted); margin:0 0 0.9rem; }
    .st-result { min-height:80px; }
    .st-result:empty::before { content:"Enter values and press Calculate — the worked steps appear here."; color:var(--cs-muted); font-size:0.88rem; }

    /* result HTML emitted by the calc JS (class names preserved, restyled to studio) */
    .result-section { margin-bottom:0.85rem; padding:0.8rem 0.9rem; background:var(--cs-panel-bg-soft); border-radius:var(--cs-radius-sm); border-left:3px solid var(--cs-line-strong); font-size:0.9rem; color:var(--cs-ink); }
    .result-badge { display:inline-block; padding:0.4rem 0.7rem; background:var(--cs-accent-softer); color:var(--cs-accent); border:1px solid var(--cs-accent-ring); border-radius:var(--cs-radius-sm); font-weight:700; font-size:1rem; margin:0.2rem; font-family:var(--cs-font-mono); }
    .formula-badge { font-family:var(--cs-font-mono); background:var(--cs-panel-bg-soft); padding:0.2rem 0.45rem; border-radius:4px; font-size:0.85rem; color:var(--cs-ink-soft); }
    .limiting-reactant { background:rgba(239,68,68,0.07); border-left-color:#ef4444; }
    .excess-reactant { background:rgba(34,197,94,0.08); border-left-color:#22c55e; }
    .conversion-flow { display:flex; align-items:center; gap:0.45rem; flex-wrap:wrap; margin:0.5rem 0; }
    .conversion-arrow { font-size:1.05rem; color:var(--cs-muted); }
    .alert { padding:0.7rem 0.95rem; border-radius:var(--cs-radius-sm); font-size:0.88rem; margin:0.5rem 0 0; }
    .alert-warning { background:#fef7ed; border:1px solid #fdba74; color:#9a3412; }
    .alert-info { background:var(--cs-accent-softer); border:1px solid var(--cs-accent-ring); color:var(--cs-ink); }
    [data-theme="dark"] .alert-warning { background:rgba(251,146,60,0.08); border-color:rgba(251,146,60,0.3); color:#fdba74; }

    .pt-seo { display:flex; flex-direction:column; gap:1rem; margin-top:1.25rem; }
    .pt-seo-card { background:var(--cs-panel-bg); border:1px solid var(--cs-line); border-radius:var(--cs-radius-lg); box-shadow:var(--cs-shadow-sm); padding:1.5rem 1.6rem; }
    .pt-seo-card h2 { font:400 1.4rem var(--cs-font-serif); color:var(--cs-ink); margin:0 0 0.6rem; }
    .pt-seo-card h3 { font:600 0.95rem var(--cs-font-sans); color:var(--cs-ink); margin:1rem 0 0.3rem; }
    .pt-seo-card p, .pt-seo-card li { color:var(--cs-ink-soft); font-size:0.93rem; line-height:1.7; }
    .pt-seo-card ul, .pt-seo-card ol { margin:0.4rem 0 0; padding-left:1.2rem; }
    .pt-seo-card code { font:0.86em var(--cs-font-mono); background:var(--cs-panel-bg-soft); padding:1px 5px; border-radius:4px; color:var(--cs-ink-soft); }
</style>
</head>
<body class="cs-body">
<%@ include file="modern/components/nav-header.jsp" %>

<div class="cs-hero">
    <%@ include file="modern/ads/ad-hero-banner.jsp" %>
</div>

<main class="cs-main">
    <button type="button" id="csSidebarToggle" class="cs-sidebar-toggle" aria-label="Open chemistry tools menu">&#9776; Chemistry tools</button>
    <% request.setAttribute("activeService", "stoichiometry"); %>
    <jsp:include page="/chemistry/partials/sidebar.jsp" />

    <section class="cs-workspace">

<div class="cs-title">
    <nav class="cs-crumbs" aria-label="Breadcrumb">
        <a href="<%=ctx%>/index.jsp">Home</a> /
        <a href="<%=ctx%>/chemistry/">Chemistry</a> /
        <span aria-current="page">Stoichiometry</span>
    </nav>
    <h1>Stoichiometry Calculator</h1>
</div>

<div class="st-tabs" role="tablist">
    <button class="st-tab active" id="tab-convert" role="tab" onclick="switchTab('convert')">Mole Conversions</button>
    <button class="st-tab" id="tab-limiting" role="tab" onclick="switchTab('limiting')">Limiting Reactant</button>
    <button class="st-tab" id="tab-yield" role="tab" onclick="switchTab('yield')">Percent Yield</button>
    <button class="st-tab" id="tab-equation" role="tab" onclick="switchTab('equation')">From Equation</button>
</div>

<div class="ic-stack">

    <!-- Mole Conversions -->
    <div id="sectionConvert">
        <div class="ic-hero">
            <div class="st-field">
                <label class="st-lab" for="conversionType">Conversion</label>
                <select id="conversionType" class="st-select" onchange="updateConversionUI()">
                    <option value="gram-to-mole">Grams → Moles</option>
                    <option value="mole-to-gram">Moles → Grams</option>
                    <option value="mole-to-molecules">Moles → Molecules/Atoms</option>
                    <option value="molecules-to-mole">Molecules/Atoms → Moles</option>
                    <option value="gram-to-molecules">Grams → Molecules/Atoms</option>
                    <option value="molecules-to-gram">Molecules/Atoms → Grams</option>
                </select>
            </div>
            <div class="st-field" id="gramGroup"><label class="st-lab" for="grams">Mass (grams)</label><input type="number" id="grams" class="st-input" placeholder="e.g. 18" step="any"></div>
            <div class="st-field" id="moleGroup" style="display:none;"><label class="st-lab" for="moles">Moles (mol)</label><input type="number" id="moles" class="st-input" placeholder="e.g. 1" step="any"></div>
            <div class="st-field" id="moleculeGroup" style="display:none;"><label class="st-lab" for="molecules">Molecules / Atoms / Formula Units</label><input type="number" id="molecules" class="st-input" placeholder="e.g. 6.022e23" step="any"></div>
            <div class="st-field"><label class="st-lab" for="molarMass">Molar Mass (g/mol)</label><input type="number" id="molarMass" class="st-input" placeholder="e.g. 18.015 (H₂O)" step="any"><p class="st-help">Need it? Use the <a href="<%=ctx%>/molar-mass-calculator.jsp" target="_blank" rel="noopener">Molar Mass Calculator</a>.</p></div>
            <div class="st-btnbar">
                <button class="st-btn" onclick="calculateConversion()">Calculate</button>
                <button class="st-btn-ghost st-btn" onclick="resetConversion()">Reset</button>
                <button class="st-btn-ghost st-btn" onclick="copyConversionResult()">📋 Copy</button>
            </div>
            <p class="st-help" style="margin-top:0.9rem;"><strong>Avogadro:</strong> 6.022 × 10²³ /mol &nbsp;·&nbsp; <code>moles = grams ÷ molar mass</code> &nbsp;·&nbsp; <code>particles = moles × 6.022×10²³</code></p>
        </div>
        <div class="st-card"><div class="st-card-head">Result</div><div id="conversionResult" class="st-result"></div></div>
    </div>

    <!-- Limiting Reactant -->
    <div id="sectionLimiting" style="display:none;">
        <div class="ic-hero">
            <p class="st-help" style="margin-top:0;">Quick examples:</p>
            <div style="margin-bottom:0.4rem;">
                <span class="preset-reaction" onclick="loadLimitingExample('2H2+O2')">2H₂ + O₂ → 2H₂O</span>
                <span class="preset-reaction" onclick="loadLimitingExample('N2+3H2')">N₂ + 3H₂ → 2NH₃</span>
                <span class="preset-reaction" onclick="loadLimitingExample('CH4+2O2')">CH₄ + 2O₂ → CO₂ + 2H₂O</span>
            </div>
            <div class="st-subhead">Reactant 1</div>
            <div class="st-row">
                <div class="st-field"><label class="st-lab" for="r1Coef">Coefficient</label><input type="number" id="r1Coef" class="st-input" value="2" min="1"></div>
                <div class="st-field"><label class="st-lab" for="r1Mass">Mass (g)</label><input type="number" id="r1Mass" class="st-input" placeholder="4" step="any"></div>
                <div class="st-field"><label class="st-lab" for="r1MM">Molar Mass</label><input type="number" id="r1MM" class="st-input" placeholder="2.016" step="any"></div>
            </div>
            <div class="st-subhead">Reactant 2</div>
            <div class="st-row">
                <div class="st-field"><label class="st-lab" for="r2Coef">Coefficient</label><input type="number" id="r2Coef" class="st-input" value="1" min="1"></div>
                <div class="st-field"><label class="st-lab" for="r2Mass">Mass (g)</label><input type="number" id="r2Mass" class="st-input" placeholder="32" step="any"></div>
                <div class="st-field"><label class="st-lab" for="r2MM">Molar Mass</label><input type="number" id="r2MM" class="st-input" placeholder="32" step="any"></div>
            </div>
            <div class="st-btnbar">
                <button class="st-btn" onclick="calculateLimiting()">Find Limiting Reactant</button>
                <button class="st-btn-ghost st-btn" onclick="resetLimiting()">Reset</button>
                <button class="st-btn-ghost st-btn" onclick="copyLimitingResult()">📋 Copy</button>
            </div>
            <p class="st-help" style="margin-top:0.9rem;">Need balancing + auto molar masses + every product's yield? Try the <a href="<%=ctx%>/limiting-reagent-calculator.jsp">chempy Limiting Reagent &amp; Yield tool</a>.</p>
        </div>
        <div class="st-card"><div class="st-card-head">Result</div><div id="limitingResult" class="st-result"></div></div>
    </div>

    <!-- Percent Yield -->
    <div id="sectionYield" style="display:none;">
        <div class="ic-hero">
            <div class="st-field">
                <label class="st-lab" for="yieldCalcType">Calculate</label>
                <select id="yieldCalcType" class="st-select" onchange="updateYieldUI()">
                    <option value="percent">Percent Yield (%)</option>
                    <option value="actual">Actual Yield</option>
                    <option value="theoretical">Theoretical Yield</option>
                </select>
            </div>
            <div class="st-field" id="actualGroup"><label class="st-lab" for="actualYield">Actual Yield (g)</label><input type="number" id="actualYield" class="st-input" placeholder="e.g. 45" step="any"></div>
            <div class="st-field" id="theoreticalGroup"><label class="st-lab" for="theoreticalYield">Theoretical Yield (g)</label><input type="number" id="theoreticalYield" class="st-input" placeholder="e.g. 50" step="any"></div>
            <div class="st-field" id="percentGroup" style="display:none;"><label class="st-lab" for="percentYield">Percent Yield (%)</label><input type="number" id="percentYield" class="st-input" placeholder="e.g. 90" step="any" min="0"></div>
            <div class="st-btnbar">
                <button class="st-btn" onclick="calculateYield()">Calculate</button>
                <button class="st-btn-ghost st-btn" onclick="resetYield()">Reset</button>
                <button class="st-btn-ghost st-btn" onclick="copyYieldResult()">📋 Copy</button>
            </div>
            <p class="st-help" style="margin-top:0.9rem;"><strong>Typical:</strong> lab 50–90% · industrial 80–95% · &gt;100% means impurities or error.</p>
        </div>
        <div class="st-card"><div class="st-card-head">Result</div><div id="yieldResult" class="st-result"></div></div>
    </div>

    <!-- From Equation -->
    <div id="sectionEquation" style="display:none;">
        <div class="ic-hero">
            <div class="st-field"><label class="st-lab" for="equation">Equation <span style="text-transform:none;font-weight:400;color:var(--cs-muted);">(auto-balanced)</span></label><input type="text" id="equation" class="st-input mono" placeholder="e.g. N2 + H2 -> NH3" spellcheck="false" oninput="previewEq()"><div class="st-preview" id="eqPreview"></div><p class="st-help">Spaces optional; <code>-&gt;</code>, <code>=</code> or <code>→</code> all work. <strong>chempy balances it</strong> with exact molar masses — you don't need to balance it yourself.</p></div>
            <div class="st-field"><label class="st-lab" for="knownSubstance">Known substance</label><input type="text" id="knownSubstance" class="st-input mono" placeholder="e.g. H2" spellcheck="false"></div>
            <div class="st-row">
                <div class="st-field"><label class="st-lab" for="knownAmount">Known amount</label><input type="number" id="knownAmount" class="st-input" placeholder="e.g. 4" step="any"></div>
                <div class="st-field"><label class="st-lab" for="knownUnit">Unit</label><select id="knownUnit" class="st-select"><option value="g">grams</option><option value="mol">moles</option><option value="L">litres (gas, STP)</option></select></div>
            </div>
            <div class="st-row">
                <div class="st-field"><label class="st-lab" for="unknownSubstance">Find amount of</label><input type="text" id="unknownSubstance" class="st-input mono" placeholder="e.g. H2O" spellcheck="false"></div>
                <div class="st-field"><label class="st-lab" for="unknownUnit">Desired unit</label><select id="unknownUnit" class="st-select"><option value="g">grams</option><option value="mol">moles</option><option value="L">litres (gas, STP)</option></select></div>
            </div>
            <div class="st-btnbar">
                <button class="st-btn" onclick="calculateFromEquation()">Calculate</button>
                <button class="st-btn-ghost st-btn" onclick="resetEquation()">Reset</button>
                <button class="st-btn-ghost st-btn" onclick="copyEquationResult()">📋 Copy</button>
            </div>
        </div>
        <div class="st-card"><div class="st-card-head">Result</div><div id="equationResult" class="st-result"></div></div>
    </div>

    <div class="cs-inline-ad">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <section class="pt-seo">
        <div class="pt-seo-card">
            <h2>What is stoichiometry?</h2>
            <p>Stoichiometry is the calculation of reactants and products in chemical reactions, using a balanced equation's mole ratios together with molar masses. The universal path is <strong>Grams A → Moles A → Moles B → Grams B</strong>.</p>
            <h3>Key concepts</h3>
            <ul>
                <li><strong>Mole</strong> — 6.022 × 10²³ particles (Avogadro's number)</li>
                <li><strong>Molar mass</strong> — mass of one mole (g/mol)</li>
                <li><strong>Mole ratio</strong> — the coefficient ratio from the balanced equation</li>
                <li><strong>Limiting reactant</strong> — runs out first and caps the product</li>
                <li><strong>Theoretical / actual / percent yield</strong> — predicted max, what you get, and their ratio × 100</li>
                <li><strong>Gas at STP</strong> — 1 mole of any gas = 22.4 L at 0°C, 1 atm</li>
            </ul>
            <h3>Worked example — grams to moles</h3>
            <p>How many moles in 18 g of H₂O (molar mass 18.015 g/mol)? &nbsp;<code>moles = 18 ÷ 18.015 = 0.999 ≈ 1 mol</code></p>
            <h3>Worked example — percent yield</h3>
            <p>Theoretical 50 g, actual 45 g → <code>% yield = (45 ÷ 50) × 100 = 90%</code></p>
        </div>
        <div class="pt-seo-card">
            <h2 class="cs-faq-title" id="faqs" style="font-family:var(--cs-font-serif);">Frequently asked</h2>
            <div class="cs-faq" aria-label="Stoichiometry FAQ">
                <div class="cs-faq-item"><button class="cs-faq-q" type="button">How do you convert grams to moles?<svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                    <div class="cs-faq-a">Divide the mass by the molar mass: moles = grams ÷ molar mass.</div></div>
                <div class="cs-faq-item"><button class="cs-faq-q" type="button">What is a limiting reactant?<svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                    <div class="cs-faq-a">The reactant that runs out first. Convert each to moles, divide by its coefficient, and the smallest result is limiting.</div></div>
                <div class="cs-faq-item"><button class="cs-faq-q" type="button">How do you calculate percent yield?<svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                    <div class="cs-faq-a">Percent yield = (actual ÷ theoretical) × 100.</div></div>
                <div class="cs-faq-item"><button class="cs-faq-q" type="button">How many litres is a mole of gas at STP?<svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                    <div class="cs-faq-a">22.4 L per mole at 0°C and 1 atm.</div></div>
                <div class="cs-faq-item"><button class="cs-faq-q" type="button">Is it free?<svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                    <div class="cs-faq-a">Yes — free, no signup, runs entirely in your browser.</div></div>
            </div>
        </div>
    </section>

</div>

    </section>

    <aside class="cs-rail" aria-label="Advertisements">
        <%@ include file="/modern/ads/ad-ide-rail-top.jsp" %>
        <%@ include file="/modern/ads/ad-ide-rail-bottom.jsp" %>
    </aside>
</main>

<%@ include file="modern/components/support-section.jsp" %>
<%@ include file="modern/ads/ad-sticky-footer.jsp" %>

<script src="<%=ctx%>/modern/js/dark-mode.js" defer></script>
<script src="<%=ctx%>/modern/js/search.js" defer></script>
<script>
const AVOGADRO = 6.022e23;
const STP_VOLUME = 22.4; // L/mol at STP

function switchTab(which){
  const sections = { convert:'sectionConvert', limiting:'sectionLimiting', yield:'sectionYield', equation:'sectionEquation' };
  const tabs = { convert:'tab-convert', limiting:'tab-limiting', yield:'tab-yield', equation:'tab-equation' };
  Object.values(sections).forEach(id => document.getElementById(id).style.display = 'none');
  Object.values(tabs).forEach(id => document.getElementById(id).classList.remove('active'));
  document.getElementById(sections[which] || sections.convert).style.display = 'block';
  document.getElementById(tabs[which] || tabs.convert).classList.add('active');
}

function updateConversionUI(){
  const type = document.getElementById('conversionType').value;
  document.getElementById('gramGroup').style.display = 'none';
  document.getElementById('moleGroup').style.display = 'none';
  document.getElementById('moleculeGroup').style.display = 'none';
  if(type.includes('gram-to')) document.getElementById('gramGroup').style.display = 'block';
  if(type.includes('mole-to-gram') || type.includes('molecules-to-mole')) document.getElementById('moleGroup').style.display = 'block';
  if(type.includes('mole-to-molecules')) document.getElementById('moleGroup').style.display = 'block';
  if(type.includes('molecules-to')) document.getElementById('moleculeGroup').style.display = 'block';
  if(type.includes('to-mole') && !type.includes('gram')) document.getElementById('moleculeGroup').style.display = 'block';
}

function calculateConversion(){
  const type = document.getElementById('conversionType').value;
  const grams = parseFloat(document.getElementById('grams').value);
  const moles = parseFloat(document.getElementById('moles').value);
  const molecules = parseFloat(document.getElementById('molecules').value);
  const MM = parseFloat(document.getElementById('molarMass').value);
  const res = document.getElementById('conversionResult');
  try {
    let result, steps = '';
    if(type === 'gram-to-mole'){
      if(!grams || !MM) throw new Error('Enter grams and molar mass');
      result = grams / MM;
      steps = `<div class="result-section"><strong>Grams → Moles</strong>
        <div class="conversion-flow"><span class="result-badge">${grams} g</span><span class="conversion-arrow">÷ ${MM} g/mol</span><span class="conversion-arrow">→</span><span class="result-badge">${result.toFixed(6)} mol</span></div>
        <div class="mt-2">moles = grams ÷ molar mass = ${grams} ÷ ${MM} = <strong>${result.toFixed(6)} mol</strong></div></div>`;
    } else if(type === 'mole-to-gram'){
      if(!moles || !MM) throw new Error('Enter moles and molar mass');
      result = moles * MM;
      steps = `<div class="result-section"><strong>Moles → Grams</strong>
        <div class="conversion-flow"><span class="result-badge">${moles} mol</span><span class="conversion-arrow">× ${MM} g/mol</span><span class="conversion-arrow">→</span><span class="result-badge">${result.toFixed(6)} g</span></div>
        <div class="mt-2">grams = moles × molar mass = ${moles} × ${MM} = <strong>${result.toFixed(6)} g</strong></div></div>`;
    } else if(type === 'mole-to-molecules'){
      if(!moles) throw new Error('Enter moles');
      result = moles * AVOGADRO;
      steps = `<div class="result-section"><strong>Moles → Molecules/Atoms</strong>
        <div class="conversion-flow"><span class="result-badge">${moles} mol</span><span class="conversion-arrow">× 6.022×10²³</span><span class="conversion-arrow">→</span><span class="result-badge">${result.toExponential(4)} particles</span></div>
        <div class="mt-2">particles = moles × Avogadro = ${moles} × ${AVOGADRO.toExponential(3)} = <strong>${result.toExponential(4)}</strong></div></div>`;
    } else if(type === 'molecules-to-mole'){
      if(!molecules) throw new Error('Enter molecules');
      result = molecules / AVOGADRO;
      steps = `<div class="result-section"><strong>Molecules/Atoms → Moles</strong>
        <div class="conversion-flow"><span class="result-badge">${molecules.toExponential(3)} particles</span><span class="conversion-arrow">÷ 6.022×10²³</span><span class="conversion-arrow">→</span><span class="result-badge">${result.toFixed(6)} mol</span></div>
        <div class="mt-2">moles = particles ÷ Avogadro = ${molecules.toExponential(3)} ÷ ${AVOGADRO.toExponential(3)} = <strong>${result.toFixed(6)} mol</strong></div></div>`;
    } else if(type === 'gram-to-molecules'){
      if(!grams || !MM) throw new Error('Enter grams and molar mass');
      const mol = grams / MM; result = mol * AVOGADRO;
      steps = `<div class="result-section"><strong>Grams → Molecules/Atoms</strong>
        <div class="conversion-flow"><span class="result-badge">${grams} g</span><span class="conversion-arrow">÷ ${MM}</span><span class="conversion-arrow">→</span><span class="result-badge">${mol.toFixed(4)} mol</span><span class="conversion-arrow">× 6.022×10²³</span><span class="conversion-arrow">→</span><span class="result-badge">${result.toExponential(4)}</span></div>
        <div class="mt-2">Step 1: ${grams} ÷ ${MM} = ${mol.toFixed(6)} mol</div><div>Step 2: ${mol.toFixed(6)} × ${AVOGADRO.toExponential(3)} = <strong>${result.toExponential(4)} particles</strong></div></div>`;
    } else if(type === 'molecules-to-gram'){
      if(!molecules || !MM) throw new Error('Enter molecules and molar mass');
      const mol = molecules / AVOGADRO; result = mol * MM;
      steps = `<div class="result-section"><strong>Molecules/Atoms → Grams</strong>
        <div class="conversion-flow"><span class="result-badge">${molecules.toExponential(3)} particles</span><span class="conversion-arrow">÷ 6.022×10²³</span><span class="conversion-arrow">→</span><span class="result-badge">${mol.toFixed(6)} mol</span><span class="conversion-arrow">× ${MM}</span><span class="conversion-arrow">→</span><span class="result-badge">${result.toFixed(6)} g</span></div>
        <div class="mt-2">Step 1: ${molecules.toExponential(3)} ÷ ${AVOGADRO.toExponential(3)} = ${mol.toFixed(6)} mol</div><div>Step 2: ${mol.toFixed(6)} × ${MM} = <strong>${result.toFixed(6)} g</strong></div></div>`;
    }
    res.innerHTML = steps;
    res.dataset.result = `Result: ${result}`;
  } catch(e){ res.innerHTML = `<div class="alert alert-warning">${e.message}</div>`; }
}

function calculateLimiting(){
  const c1 = parseFloat(document.getElementById('r1Coef').value);
  const m1 = parseFloat(document.getElementById('r1Mass').value);
  const mm1 = parseFloat(document.getElementById('r1MM').value);
  const c2 = parseFloat(document.getElementById('r2Coef').value);
  const m2 = parseFloat(document.getElementById('r2Mass').value);
  const mm2 = parseFloat(document.getElementById('r2MM').value);
  const res = document.getElementById('limitingResult');
  try {
    if(!c1 || !m1 || !mm1 || !c2 || !m2 || !mm2) throw new Error('Enter all values');
    const mol1 = m1 / mm1, mol2 = m2 / mm2;
    const ratio1 = mol1 / c1, ratio2 = mol2 / c2;
    let limiting, excess, limitingMol, excessMol, limitingRatio;
    if(ratio1 < ratio2){ limiting = 1; excess = 2; limitingMol = mol1; excessMol = mol2; limitingRatio = ratio1; }
    else if(ratio2 < ratio1){ limiting = 2; excess = 1; limitingMol = mol2; excessMol = mol1; limitingRatio = ratio2; }
    else {
      res.innerHTML = `<div class="result-section"><strong>Neither is limiting — exact stoichiometric amounts.</strong>
        <div class="mt-2">Reactant 1: ${mol1.toFixed(4)} mol ÷ ${c1} = ${ratio1.toFixed(4)}</div><div>Reactant 2: ${mol2.toFixed(4)} mol ÷ ${c2} = ${ratio2.toFixed(4)}</div>
        <div class="mt-2">Equal ratios → both are completely consumed, nothing left over.</div></div>`;
      res.dataset.result = 'Neither limiting — exact stoichiometric ratio'; return;
    }
    const excessUsed = limitingRatio * (limiting === 1 ? c2 : c1);
    const excessLeft = (limiting === 1 ? mol2 : mol1) - excessUsed;
    const excessLeftGrams = excessLeft * (limiting === 1 ? mm2 : mm1);
    res.innerHTML = `
      <div class="result-section limiting-reactant"><strong>🔴 Limiting reactant: Reactant ${limiting}</strong>
        <div class="mt-2">Moles available: ${limitingMol.toFixed(4)} mol</div><div>Normalized ratio: ${limitingRatio.toFixed(4)} (mol ÷ coefficient)</div>
        <div class="mt-2"><strong>This runs out first and caps the product.</strong></div></div>
      <div class="result-section excess-reactant"><strong>🟢 Excess reactant: Reactant ${excess}</strong>
        <div class="mt-2">Moles available: ${excessMol.toFixed(4)} mol</div><div>Moles used: ${excessUsed.toFixed(4)} mol</div>
        <div>Left over: ${excessLeft.toFixed(4)} mol = <strong>${excessLeftGrams.toFixed(4)} g</strong></div></div>
      <div class="result-section"><strong>How it was decided</strong>
        <div class="mt-2">Reactant 1: ${mol1.toFixed(4)} mol ÷ ${c1} = ${ratio1.toFixed(4)}</div><div>Reactant 2: ${mol2.toFixed(4)} mol ÷ ${c2} = ${ratio2.toFixed(4)}</div>
        <div class="mt-2">Smaller ratio → limiting reactant.</div></div>`;
    res.dataset.result = `Limiting: Reactant ${limiting}; ${excessLeftGrams.toFixed(2)} g of Reactant ${excess} left`;
  } catch(e){ res.innerHTML = `<div class="alert alert-warning">${e.message}</div>`; }
}

function updateYieldUI(){
  const type = document.getElementById('yieldCalcType').value;
  document.getElementById('actualGroup').style.display = (type === 'actual') ? 'none' : 'block';
  document.getElementById('theoreticalGroup').style.display = (type === 'theoretical') ? 'none' : 'block';
  document.getElementById('percentGroup').style.display = (type === 'percent') ? 'none' : 'block';
}

function calculateYield(){
  const type = document.getElementById('yieldCalcType').value;
  const actual = parseFloat(document.getElementById('actualYield').value);
  const theoretical = parseFloat(document.getElementById('theoreticalYield').value);
  const percent = parseFloat(document.getElementById('percentYield').value);
  const res = document.getElementById('yieldResult');
  try {
    let result, steps = '';
    if(type === 'percent'){
      if(!actual || !theoretical) throw new Error('Enter actual and theoretical yield');
      result = (actual / theoretical) * 100;
      steps = `<div class="result-section"><strong>Percent Yield</strong>
        <div class="mt-2">% Yield = (Actual ÷ Theoretical) × 100 = (${actual} ÷ ${theoretical}) × 100</div>
        <div class="mt-2"><span class="result-badge">${result.toFixed(2)}%</span></div>
        ${result > 100 ? '<div class="alert alert-warning">⚠️ Above 100% — likely impurities or measurement error.</div>' : ''}
        ${result < 50 ? '<div class="alert alert-info">Low yield — check reaction conditions.</div>' : ''}</div>`;
    } else if(type === 'actual'){
      if(!percent || !theoretical) throw new Error('Enter percent yield and theoretical yield');
      result = (percent / 100) * theoretical;
      steps = `<div class="result-section"><strong>Actual Yield</strong>
        <div class="mt-2">Actual = (% Yield ÷ 100) × Theoretical = (${percent} ÷ 100) × ${theoretical}</div>
        <div class="mt-2"><span class="result-badge">${result.toFixed(4)} g</span></div></div>`;
    } else if(type === 'theoretical'){
      if(!percent || !actual) throw new Error('Enter percent yield and actual yield');
      result = (actual / percent) * 100;
      steps = `<div class="result-section"><strong>Theoretical Yield</strong>
        <div class="mt-2">Theoretical = (Actual ÷ % Yield) × 100 = (${actual} ÷ ${percent}) × 100</div>
        <div class="mt-2"><span class="result-badge">${result.toFixed(4)} g</span></div></div>`;
    }
    res.innerHTML = steps;
    res.dataset.result = `Result: ${result}`;
  } catch(e){ res.innerHTML = `<div class="alert alert-warning">${e.message}</div>`; }
}

/* ── From Equation: chempy auto-balances + live molar masses (server-side) ── */
var RUN_EQ = '<%=ctx%>/OneCompilerFunctionality';
function buildEqCode(P){
  return [
      'import json, re',
      'from chempy import balance_stoichiometry, Substance',
      'STP = 22.4',
      'def species(side):',
      '    out = []',
      '    for term in side.split(\'+\'):',
      '        t = re.sub(r\'^\\d+\', \'\', term.strip().replace(\' \', \'\'))',
      '        if t: out.append(t)',
      '    return out',
      'def run(P):',
      '    eq = P[\'eq\']; known = P[\'known\'].replace(\' \',\'\'); unknown = P[\'unknown\'].replace(\' \',\'\')',
      '    amt = P[\'amt\']; ku = P[\'ku\']; uu = P[\'uu\']',
      '    try:',
      '        s = re.sub(r\'→|⟶|=>|=\', \'->\', eq)',
      '        sides = s.split(\'->\')',
      '        if len(sides) != 2: raise ValueError("Use the format: H2 + O2 -> H2O")',
      '        reac = species(sides[0]); prod = species(sides[1])',
      '        if not reac or not prod: raise ValueError("Enter reactants and products")',
      '        if amt is None or amt < 0: raise ValueError("Enter a non-negative known amount")',
      '        r, p = balance_stoichiometry(set(reac), set(prod))',
      '        coefs = {}',
      '        for k in r: coefs[k] = int(r[k])',
      '        for k in p: coefs[k] = int(p[k])',
      '        if known not in coefs: raise ValueError(\'"%s" is not in the equation\' % known)',
      '        if unknown not in coefs: raise ValueError(\'"%s" is not in the equation\' % unknown)',
      '        mmK = Substance.from_formula(known).mass',
      '        mmU = Substance.from_formula(unknown).mass',
      '        molK = amt/mmK if ku==\'g\' else (amt/STP if ku==\'L\' else amt)',
      '        ratio = coefs[unknown]/coefs[known]',
      '        molU = molK*ratio',
      '        out = molU*mmU if uu==\'g\' else (molU*STP if uu==\'L\' else molU)',
      '        return {"ok":True,',
      '                "reac":[{"sp":k,"n":int(r[k])} for k in r],',
      '                "prod":[{"sp":k,"n":int(p[k])} for k in p],',
      '                "ck":coefs[known],"cu":coefs[unknown],',
      '                "mmK":round(mmK,4),"mmU":round(mmU,4),',
      '                "molK":round(molK,6),"ratio":round(ratio,6),"molU":round(molU,6),',
      '                "out":round(out,4)}',
      '    except Exception as e:',
      '        return {"ok":False,"error":type(e).__name__+": "+str(e)}',
      '',
      'P = json.loads(r"""__PAYLOAD__""")',
      'print("RESULT:"+json.dumps(run(P)))'
  ].join('\n').replace('__PAYLOAD__', JSON.stringify(P));
}
function eqSub(f){ return String(f).replace(/(\d+)/g, '<sub>$1</sub>'); }
function eqSide(arr){ return arr.map(function(x){ return (x.n > 1 ? '<span style="color:var(--cs-muted)">'+x.n+'</span> ' : '') + eqSub(x.sp); }).join(' + '); }

// live echo of the typed equation (just visual confirmation; chempy does the real work)
function previewEq(){
  var el = document.getElementById('eqPreview');
  var parts = document.getElementById('equation').value.replace(/→|⟶|=>|=/g, '->').split('->');
  function side(t){ return t.split('+').map(function(x){ return x.trim().replace(/\s+/g,''); }).filter(Boolean).map(eqSub).join(' <span class="conversion-arrow">+</span> '); }
  el.innerHTML = (parts.length === 2 && parts[0].trim() && parts[1].trim())
    ? side(parts[0]) + ' <span class="conversion-arrow">→</span> ' + side(parts[1]) : '';
}
function friendlyErr(e){
  e = String(e || '');
  if(/ParseException|Expected/.test(e)) return 'Couldn\'t read a formula. Element symbols are case-sensitive — write <code>NH3</code>, <code>CO2</code>, <code>NaCl</code> (not <code>nh3</code>), and separate species with <code>+</code> and <code>-&gt;</code>.';
  if(/not in the equation/.test(e)) return e.replace(/^\w+Error:\s*/, '') + ' — type the known/unknown exactly as they appear in the reaction.';
  if(/balanc|singular|no solution|cannot|Underdetermined|ValueError: .*stoich/i.test(e)) return 'Couldn\'t balance that reaction — check every formula is correct and the reaction is chemically valid (the same elements must appear on both sides).';
  return e.replace(/^\w+Error:\s*/, '');
}

function calculateFromEquation(){
  var res = document.getElementById('equationResult');
  var eq = document.getElementById('equation').value.trim();
  var known = document.getElementById('knownSubstance').value.trim().replace(/\s+/g,'');
  var amt = parseFloat(document.getElementById('knownAmount').value);
  var ku = document.getElementById('knownUnit').value;
  var unknown = document.getElementById('unknownSubstance').value.trim().replace(/\s+/g,'');
  var uu = document.getElementById('unknownUnit').value;
  if(!eq){ res.innerHTML = '<div class="alert alert-warning">Enter an equation — it does not need to be balanced.</div>'; return; }
  if(!known || !unknown){ res.innerHTML = '<div class="alert alert-warning">Enter the known and unknown substances.</div>'; return; }
  if(isNaN(amt)){ res.innerHTML = '<div class="alert alert-warning">Enter the known amount.</div>'; return; }
  if(amt < 0){ res.innerHTML = '<div class="alert alert-warning">The known amount cannot be negative.</div>'; return; }
  var P = { eq:eq, known:known, unknown:unknown, amt:amt, ku:ku, uu:uu };
  res.innerHTML = '<p class="st-help">Balancing &amp; computing with chempy…</p>';
  fetch(RUN_EQ + '?action=execute', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify({ language:'python', version:'3.11', code: buildEqCode(P) }) })
    .then(function(r){ return r.json(); })
    .then(function(d){
      var outTxt = (d.Stdout || d.stdout || d.Output || '').toString();
      var m = outTxt.match(/RESULT:(\{[\s\S]*\})/);
      if(!m) throw new Error((d.Stderr || d.stderr || outTxt || 'No output').toString().slice(0,300));
      var r = JSON.parse(m[1]);
      if(!r.ok){ res.innerHTML = '<div class="alert alert-warning">'+friendlyErr(r.error)+'</div>'; return; }
      renderEq(r, known, unknown, amt, ku, uu);
    })
    .catch(function(e){ res.innerHTML = '<div class="alert alert-warning">Backend error: '+(e.message||e)+'</div>'; });
}

function renderEq(r, known, unknown, amt, ku, uu){
  var res = document.getElementById('equationResult');
  var ul = uu === 'g' ? 'g' : uu === 'L' ? 'L (STP)' : 'mol';
  var knownToMol = ku === 'g' ? amt+' g ÷ '+r.mmK.toFixed(3)+' g/mol' : ku === 'L' ? amt+' L ÷ 22.4 L/mol' : amt+' mol';
  var molToOut = uu === 'g' ? '× '+r.mmU.toFixed(3)+' g/mol' : uu === 'L' ? '× 22.4 L/mol' : '(already moles)';
  var stpNote = (ku === 'L' || uu === 'L') ? '<div class="alert alert-info">Litre values use 22.4 L/mol — valid only for a gas at STP (0°C, 1 atm).</div>' : '';
  res.innerHTML =
    '<div class="result-section"><strong>Balanced by chempy</strong> &nbsp;<span class="formula-badge">✓</span>'
      + '<div class="conversion-flow" style="font-size:1.05rem;margin-top:0.4rem;">'+eqSide(r.reac)+' <span class="conversion-arrow">→</span> '+eqSide(r.prod)+'</div></div>'
    + '<div class="result-section"><strong>'+eqSub(known)+' → '+eqSub(unknown)+'</strong>'
      + '<div class="conversion-flow"><span class="result-badge">'+amt+' '+ku+'</span><span class="conversion-arrow">→</span><span class="result-badge">'+r.out.toFixed(4)+' '+ul+'</span></div></div>'
    + '<div class="result-section"><strong>Steps</strong>'
      + '<div class="mt-2">1 · Known to moles: '+knownToMol+' = <strong>'+r.molK.toFixed(5)+' mol '+known+'</strong></div>'
      + '<div>2 · Mole ratio '+unknown+'/'+known+' = '+r.cu+'/'+r.ck+' = '+r.ratio.toFixed(4)+' → '+r.molK.toFixed(5)+' × '+r.ratio.toFixed(4)+' = <strong>'+r.molU.toFixed(5)+' mol '+unknown+'</strong></div>'
      + '<div>3 · Moles to answer: '+r.molU.toFixed(5)+' '+molToOut+' = <strong>'+r.out.toFixed(4)+' '+ul+'</strong></div></div>'
    + '<div class="result-section"><span class="formula-badge">molar mass '+known+' = '+r.mmK.toFixed(3)+' g/mol</span> <span class="formula-badge">molar mass '+unknown+' = '+r.mmU.toFixed(3)+' g/mol</span></div>'
    + stpNote;
  res.dataset.result = amt+' '+ku+' '+known+' → '+r.out.toFixed(4)+' '+ul+' '+unknown;
}

function loadLimitingExample(type){
  const v = {
    '2H2+O2': [2,4,2.016, 1,32,32],
    'N2+3H2': [1,28,28.014, 3,6,2.016],
    'CH4+2O2':[1,16,16.043, 2,64,32]
  }[type];
  if(!v) return;
  ['r1Coef','r1Mass','r1MM','r2Coef','r2Mass','r2MM'].forEach((id,k) => document.getElementById(id).value = v[k]);
}

function resetConversion(){ ['grams','moles','molecules','molarMass'].forEach(id => document.getElementById(id).value = ''); document.getElementById('conversionResult').innerHTML = ''; }
function resetLimiting(){ ['r1Mass','r1MM','r2Mass','r2MM'].forEach(id => document.getElementById(id).value = ''); document.getElementById('r1Coef').value = 2; document.getElementById('r2Coef').value = 1; document.getElementById('limitingResult').innerHTML = ''; }
function resetYield(){ ['actualYield','theoreticalYield','percentYield'].forEach(id => document.getElementById(id).value = ''); document.getElementById('yieldResult').innerHTML = ''; }
function resetEquation(){ ['equation','knownSubstance','knownAmount','unknownSubstance'].forEach(id => document.getElementById(id).value = ''); document.getElementById('equationResult').innerHTML = ''; }

function copyConversionResult(){ copyToClipboard('conversionResult'); }
function copyLimitingResult(){ copyToClipboard('limitingResult'); }
function copyYieldResult(){ copyToClipboard('yieldResult'); }
function copyEquationResult(){ copyToClipboard('equationResult'); }
function copyToClipboard(id){ const el = document.getElementById(id); const text = el.dataset.result || el.innerText || ''; if(navigator.clipboard && text) navigator.clipboard.writeText(text); }

(function(){
  updateConversionUI();
  updateYieldUI();
  document.querySelectorAll('.cs-faq-q').forEach(function(b){ b.addEventListener('click', function(){ var it = b.closest('.cs-faq-item'); if(it) it.classList.toggle('open'); }); });
})();
</script>
</body>
</html>
