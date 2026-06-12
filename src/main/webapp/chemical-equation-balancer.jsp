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

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/chemical-equation-balancer.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/chemistry/css/chemistry-studio.css">

    <%@ include file="modern/ads/ad-init.jsp" %>

    <style>
        /* FULL CHEMISTRY-STUDIO MIGRATION — remap the cb-* (pink) palette to the
           studio indigo + paper tokens and host the balancer in the stacked
           layout (.ic-stack → .ic-hero input + result/collapsible cards). This
           <style> loads after chemical-equation-balancer.css so it wins. */
        body.cs-body{
            --cb-tool: var(--cs-accent);
            --cb-tool-dark: var(--cs-accent-hover);
            --cb-gradient: linear-gradient(135deg, var(--cs-accent) 0%, var(--cs-accent-hover) 100%);
            --cb-light: var(--cs-accent-soft);
            --primary: var(--cs-accent);
            --bg-primary: var(--cs-panel-bg);
            --bg-secondary: var(--cs-panel-bg-soft);
            --bg-tertiary: var(--cs-panel-bg-soft);
            --bg-hover: var(--cs-accent-softer);
            --card: var(--cs-panel-bg);
            --text-primary: var(--cs-ink);
            --foreground: var(--cs-ink);
            --text-secondary: var(--cs-ink-soft);
            --text-muted: var(--cs-muted);
            --border: var(--cs-line);
        }
        /* Input hero */
        .ic-hero .cb-input, .ic-hero .cb-add-input { width:100%; padding:0.6rem 0.85rem; border:1.5px solid var(--cs-line-strong); border-radius:var(--cs-radius-sm); background:var(--cs-panel-bg-soft); color:var(--cs-ink); font:15px var(--cs-font-mono); }
        .ic-hero .cb-input:focus, .ic-hero .cb-add-input:focus { outline:none; border-color:var(--cs-accent); background:var(--cs-panel-bg); box-shadow:var(--cs-ring); }
        .ic-hero .cb-input-label { color:var(--cs-muted); font:600 0.74rem var(--cs-font-sans); text-transform:uppercase; letter-spacing:0.05em; }
        .ic-hero .cb-input-hint, .ic-hero .cb-chips-title { color:var(--cs-muted); }
        .ic-hero .cb-eq-preview { font:1.2rem var(--cs-font-serif); color:var(--cs-ink); margin:0.15rem 0 0.4rem; }
        /* Compact hero: one prominent equation field, Balance inline, rest collapsed */
        .ic-hero .cb-input-label { display:block; margin:0 0 0.4rem; }
        .ic-hero .cb-eq-row { display:flex; gap:0.5rem; align-items:stretch; flex-wrap:wrap; }
        .ic-hero .cb-eq-row .cb-input { flex:1 1 240px; min-width:0; margin:0; }
        .ic-hero .cb-eq-row .tool-action-btn { flex:0 0 auto; }
        .ic-hero .cb-input-hint { margin:0 0 0.7rem; }
        .ic-hero .cb-options-compact { display:flex; flex-wrap:wrap; gap:0.4rem 1rem; margin:0; font-size:0.8rem; }
        .ic-hero .cb-options-compact .cb-option { color:var(--cs-ink-soft); }
        details.cb-hero-collapse { border:1px solid var(--cs-line); border-radius:var(--cs-radius-sm); background:var(--cs-panel-bg-soft); margin-top:0.6rem; }
        details.cb-hero-collapse > summary { list-style:none; cursor:pointer; padding:0.55rem 0.8rem; font:600 0.76rem var(--cs-font-sans); color:var(--cs-ink); display:flex; align-items:center; gap:0.5rem; user-select:none; }
        details.cb-hero-collapse > summary::-webkit-details-marker { display:none; }
        details.cb-hero-collapse > summary::after { content:"\25be"; margin-left:auto; opacity:0.55; transition:transform .15s; }
        details.cb-hero-collapse[open] > summary::after { transform:rotate(180deg); }
        details.cb-hero-collapse[open] > summary { border-bottom:1px solid var(--cs-line); }
        .cb-hero-collapse-body { padding:0.7rem 0.8rem 0.85rem; }
        .ic-hero .cb-hero-collapse-body .cb-chips-section { margin-bottom:0.7rem; }
        .ic-hero .cb-hero-collapse-body .cb-chips-section:last-child { margin-bottom:0; }
        .ic-hero .tool-action-btn { background:var(--cs-accent) !important; color:#fff; border:1px solid var(--cs-accent); border-radius:var(--cs-radius-pill); box-shadow:none; width:auto; margin-top:0; padding:0.6rem 1.1rem; font:600 0.85rem var(--cs-font-sans); }
        .ic-hero .tool-action-btn:hover { background:var(--cs-accent-hover) !important; transform:translateY(-1px); opacity:1; }
        .ic-hero #cb-reset-btn { background:var(--cs-panel-bg-soft) !important; color:var(--cs-ink-soft) !important; border:1px solid var(--cs-line-strong) !important; }
        .ic-hero .cb-example-chip, .ic-hero .cb-add-btn, .ic-hero .cb-random-btn, .ic-hero .cb-worksheet-btn { border:1px solid var(--cs-line-strong); border-radius:var(--cs-radius-pill); background:var(--cs-panel-bg); color:var(--cs-ink); cursor:pointer; }
        .ic-hero .cb-example-chip:hover, .ic-hero .cb-add-btn:hover, .ic-hero .cb-random-btn:hover, .ic-hero .cb-worksheet-btn:hover { border-color:var(--cs-accent); background:var(--cs-accent-softer); color:var(--cs-accent); }
        /* Result + collapsible cards */
        .cb-result-stack { display:flex; flex-direction:column; gap:0.85rem; min-width:0; }
        .cb-result-stack > .cb-panel { display:block; }
        .cb-result-stack .tool-card, .cb-result-stack .tool-result-card { background:var(--cs-panel-bg); border:1px solid var(--cs-line); border-radius:var(--cs-radius-lg); box-shadow:var(--cs-shadow-sm); }
        .cb-result-stack .tool-result-header svg { color:var(--cs-accent) !important; }
        .cb-result-stack .tool-result-header h4 { font:600 0.72rem var(--cs-font-sans); text-transform:uppercase; letter-spacing:0.08em; color:var(--cs-muted); margin:0; }
        details.cb-collapse { border:1px solid var(--cs-line); border-radius:var(--cs-radius-lg); background:var(--cs-panel-bg); box-shadow:var(--cs-shadow-sm); }
        details.cb-collapse > summary { list-style:none; cursor:pointer; padding:1rem 1.25rem; font:600 0.85rem var(--cs-font-sans); color:var(--cs-ink); display:flex; align-items:center; gap:0.5rem; }
        details.cb-collapse > summary::-webkit-details-marker { display:none; }
        details.cb-collapse > summary::after { content:"\25be"; margin-left:auto; opacity:0.55; transition:transform .15s; }
        details.cb-collapse[open] > summary::after { transform:rotate(180deg); }
        details.cb-collapse[open] > summary { border-bottom:1px solid var(--cs-line); }
        /* Structure diagram (ported from formula-to-molecule) */
        .cb-figure { padding:0 1.25rem 1.1rem; }
        .cb-figure-head { display:flex; align-items:center; justify-content:space-between; gap:0.75rem; padding:0.6rem 0 0.4rem; }
        .cb-figure-head .cb-figure-lbl { font:600 0.7rem var(--cs-font-sans); text-transform:uppercase; letter-spacing:0.06em; color:var(--cs-muted); }
        .cb-figure img { max-width:100%; border:1px solid var(--cs-line); border-radius:var(--cs-radius); background:#fff; }
        .cb-figure-dl { border:1px solid var(--cs-line-strong); background:var(--cs-panel-bg); color:var(--cs-ink-soft); border-radius:var(--cs-radius-pill); padding:0.3rem 0.8rem; font:600 0.72rem var(--cs-font-sans); cursor:pointer; }
        .cb-figure-dl:hover { border-color:var(--cs-accent); color:var(--cs-accent); }
        .cb-figure-note { font-size:0.75rem; color:var(--cs-muted); margin:0.4rem 0 0; }
        .cb-figure-spin { display:inline-block; width:13px; height:13px; border:2px solid var(--cs-line-strong); border-top-color:var(--cs-accent); border-radius:50%; animation:cb-spin 0.7s linear infinite; vertical-align:-2px; margin-right:0.4rem; }
        @keyframes cb-spin { to { transform:rotate(360deg); } }
    </style>
</head>
<body class="cs-body">
<%@ include file="modern/components/nav-header.jsp" %>

<div class="cs-hero">
    <%@ include file="modern/ads/ad-hero-banner.jsp" %>
</div>

<main class="cs-main">
    <button type="button" id="csSidebarToggle" class="cs-sidebar-toggle" aria-label="Open chemistry tools menu">&#9776; Chemistry tools</button>
    <% request.setAttribute("activeService", "balancer"); %>
    <jsp:include page="/chemistry/partials/sidebar.jsp" />

    <section class="cs-workspace">

<!-- Slim studio title -->
<div class="cs-title">
    <nav class="cs-crumbs" aria-label="Breadcrumb">
        <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
        <a href="<%=request.getContextPath()%>/chemistry/">Chemistry</a> /
        <span aria-current="page">Equation Balancer</span>
    </nav>
    <h1>Chemical Equation Balancer</h1>
</div>

<div class="ic-stack">
    <!-- ==================== INPUT (hero) ==================== -->
    <div class="ic-hero">

                <!-- Equation input — the one field that matters, Balance inline -->
                <label class="cb-input-label" for="cb-eq">Unbalanced equation</label>
                <div class="cb-eq-row">
                    <input type="text" class="cb-input" id="cb-eq" placeholder="e.g., C3H8 + O2 -> CO2 + H2O" value="Fe + O2 -> Fe2O3">
                    <button type="button" class="tool-action-btn" id="cb-balance-btn">Balance</button>
                    <button type="button" class="tool-action-btn" id="cb-reset-btn" title="Clear">Reset</button>
                </div>
                <div class="cb-eq-preview" id="cb-eqPreview"></div>
                <div class="cb-input-hint">Use spaces around <code>+</code> and <code>-&gt;</code> (or <code>=&gt;</code>) as the arrow.</div>

                <div class="cb-options cb-options-compact">
                    <label class="cb-option"><input type="checkbox" id="cb-optAuto" checked> Auto</label>
                    <label class="cb-option"><input type="checkbox" id="cb-optHide1" checked> Hide 1</label>
                    <label class="cb-option"><input type="checkbox" id="cb-optFrac"> Fractions</label>
                </div>

                <!-- Edit species (collapsed) -->
                <details class="cb-hero-collapse">
                    <summary>Reactants &amp; products</summary>
                    <div class="cb-hero-collapse-body">
                        <div class="cb-chips-section">
                            <div class="cb-chips-title">Reactants</div>
                            <div class="cb-chip-bar" id="cb-chipsLeft"></div>
                            <div class="cb-add-row">
                                <input type="text" class="cb-add-input" id="cb-addLeft" placeholder="Add reactant">
                                <button type="button" class="cb-add-btn" id="cb-addLeftBtn">Add</button>
                            </div>
                        </div>
                        <div class="cb-chips-section">
                            <div class="cb-chips-title">Products</div>
                            <div class="cb-chip-bar" id="cb-chipsRight"></div>
                            <div class="cb-add-row">
                                <input type="text" class="cb-add-input" id="cb-addRight" placeholder="Add product">
                                <button type="button" class="cb-add-btn" id="cb-addRightBtn">Add</button>
                            </div>
                        </div>
                    </div>
                </details>

                <!-- Quick examples (collapsed) -->
                <details class="cb-hero-collapse">
                    <summary>Quick examples</summary>
                    <div class="cb-hero-collapse-body">
                        <div style="margin-bottom:0.5rem;"><button type="button" class="cb-random-btn" id="cb-random-btn" title="Load random equation">&#127922; Random</button></div>
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
                </details>

                <!-- Worksheet generator (collapsed) -->
                <details class="cb-hero-collapse">
                    <summary>Worksheet generator</summary>
                    <div class="cb-hero-collapse-body">
                        <p style="font-size:0.75rem;color:var(--cs-muted);margin:0 0 0.5rem;">Generate a printable worksheet with random equations and an answer key.</p>
                        <div style="display:flex;gap:0.5rem;align-items:center;">
                            <select id="cb-worksheet-count" style="padding:0.35rem 0.5rem;font-size:0.8125rem;border:1px solid var(--cs-line-strong);border-radius:0.375rem;background:var(--cs-panel-bg-soft);color:var(--cs-ink);">
                                <option value="5">5 questions</option>
                                <option value="10" selected>10 questions</option>
                                <option value="15">15 questions</option>
                                <option value="20">20 questions</option>
                            </select>
                            <button type="button" class="cb-worksheet-btn" id="cb-worksheet-btn">Print Worksheet</button>
                        </div>
                    </div>
                </details>
    </div>

    <!-- ==================== OUTPUT (result + collapsibles) ==================== -->
    <div class="cb-result-stack">

        <!-- Result -->
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
                <!-- 2D structure diagram — rendered after a successful balance -->
                <div class="cb-figure" id="cb-figure" hidden></div>
                <!-- History -->
                <div class="cb-history" id="cb-history-section">
                    <div class="cb-history-title">History</div>
                    <div class="cb-history-list" id="cb-historyList"></div>
                    <button type="button" class="cb-history-clear" id="cb-historyClear">Clear history</button>
                </div>
            </div>
        </div>

        <!-- Redox half-reaction combiner (collapsed) -->
        <details class="cb-collapse">
            <summary>&#8651; Redox half-reaction combiner <span style="font-weight:400;color:var(--cs-muted);">(beta)</span></summary>
            <div style="padding:0 1.25rem 1.25rem;">
                <p style="font-size:0.8125rem;color:var(--cs-muted);margin:0 0 0.75rem;">Enter balanced half-reactions with electrons (e-). The tool equalizes electrons and combines into a net reaction.</p>
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
                    <button type="button" class="tool-action-btn" id="cb-redox-reset" style="flex:0;min-width:60px;background:var(--cs-panel-bg-soft)!important;color:var(--cs-ink-soft);border:1px solid var(--cs-line-strong)">Reset</button>
                </div>
                <div id="cb-redoxResult"></div>
            </div>
        </details>

        <!-- Reaction database (collapsed) -->
        <details class="cb-collapse">
            <summary>&#128218; Reaction database</summary>
            <div style="padding:0 1.25rem 1.25rem;">
                <input type="text" class="cb-search-input" id="cb-db-search" placeholder="Search by type, formula, or equation...">
                <div class="cb-db-table-wrap">
                    <table class="cb-db-table">
                        <thead>
                            <tr><th>Type</th><th>Unbalanced</th><th>Balanced</th></tr>
                        </thead>
                        <tbody id="cb-db-body"></tbody>
                    </table>
                </div>
            </div>
        </details>

    </div>
</div>

<!-- In-content ad (mobile; hidden ≥1280px when the side rail takes over) -->
<div class="cs-inline-ad">
    <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
</div>

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


    </section>

    <aside class="cs-rail" aria-label="Advertisements">
        <%@ include file="/modern/ads/ad-ide-rail-top.jsp" %>
        <%@ include file="/modern/ads/ad-ide-rail-bottom.jsp" %>
    </aside>
</main>

<%--<!-- Support Section -->--%>
<%--<%@ include file="modern/components/support-section.jsp" %>--%>

<%@ include file="modern/ads/ad-sticky-footer.jsp" %>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/search.js" defer></script>

<!-- Core Scripts -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/mathjs/14.0.1/math.min.js"></script>
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js"></script>
<script src="<%=request.getContextPath()%>/js/chemical-equation-balancer-render.js"></script>
<script src="<%=request.getContextPath()%>/js/chemical-equation-balancer-core.js"></script>

<!-- 2D structure diagram — ports the formula-to-molecule pipeline (OpenChemLib +
     PubChem proxy). Observer-driven & fully additive: if it fails, balancing is
     unaffected. Renders a downloadable textbook figure under the balanced equation. -->
<script type="module">
(async function () {
  const CTX = '<%=request.getContextPath()%>';
  const PROXY = CTX + '/chemistry/formula-lookup.jsp';
  const CACHE_URL = CTX + '/chemistry/data/formula-cache.min.json';
  const DIATOMIC = { O2:'O=O', N2:'N#N', H2:'[H][H]', F2:'FF', Cl2:'ClCl', Br2:'BrBr', I2:'II', O3:'[O-][O+]=O' };

  const figure = document.getElementById('cb-figure');
  const resultContent = document.getElementById('cb-result-content');
  if (!figure || !resultContent) return;

  let OCL = null, CACHE = null;
  const partCache = {};
  try { OCL = await import('https://esm.sh/openchemlib@9.21.0'); if (OCL.default) OCL = OCL.default; } catch (e) { /* structures unavailable */ }
  try { CACHE = await (await fetch(CACHE_URL)).json(); } catch (e) { CACHE = {}; }

  const sleep = (ms) => new Promise(r => setTimeout(r, ms));
  const SUB = '₀₁₂₃₄₅₆₇₈₉';
  function sub(s){ return String(s).replace(/[0-9]/g, d => SUB[+d]); }
  function prettyFormula(f){ return f.replace(/([A-Za-z\)\]])(\d+)/g, (_, a, n) => a + sub(n)); }
  function labelOf(n, sp){ return (n > 1 ? n + ' ' : '') + prettyFormula(sp); }

  function cacheGet(f){ return CACHE && CACHE[f] ? CACHE[f] : null; }
  function smilesOf(p){ return p.SMILES || p.IsomericSMILES || p.ConnectivitySMILES || p.CanonicalSMILES || ''; }
  function splitPart(part){ const m = String(part).match(/^([A-Z][a-z]?)(\d*)$/); return m ? { sym:m[1], n:m[2] ? +m[2] : 1 } : null; }
  async function callProxy(params){ const r = await fetch(PROXY + '?' + new URLSearchParams(params).toString(), { headers:{ 'Accept':'application/json' } }); return r.json(); }
  async function resolveData(data){ let t = 0; while (data && data.Waiting && data.Waiting.ListKey && t < 20){ await sleep(1600); data = await callProxy({ action:'listkey', listkey:data.Waiting.ListKey }); t++; } return data; }

  async function resolvePartSmiles(part){
    if (partCache[part] !== undefined) return partCache[part];
    let smi = null;
    const cached = cacheGet(part);
    if (cached && cached[0] && cached[0].smiles) smi = cached[0].smiles;
    else if (DIATOMIC[part]) smi = DIATOMIC[part];
    else {
      const sp = splitPart(part);
      if (sp && sp.n === 1) smi = '[' + sp.sym + ']';
      else { try { let d = await resolveData(await callProxy({ action:'formula', formula:part })); const list = d && d.PropertyTable && d.PropertyTable.Properties; if (list && list.length) smi = smilesOf(list[0]); } catch (e) {} }
    }
    partCache[part] = smi;
    return smi;
  }
  function svgFor(smi, w, h){ if (!OCL || !smi) return null; try { return OCL.Molecule.fromSmiles(smi).toSVG(w || 150, h || 120, null, { suppressChiralText:true, autoCrop:true }); } catch (e) { return null; } }
  function svgStrToImage(svgStr){ return new Promise((res) => { const url = URL.createObjectURL(new Blob([svgStr], { type:'image/svg+xml' })); const img = new Image(); img.onload = () => { URL.revokeObjectURL(url); res(img); }; img.onerror = () => { URL.revokeObjectURL(url); res(null); }; img.src = url; }); }

  async function composeCanvas(items){
    const structW = 150, structH = 120, tileW = structW + 22, opW = 52, top = 18, labelGap = 26, H = top + structH + labelGap + 14, S = 2;
    const imgs = await Promise.all(items.map(it => it.svg ? svgStrToImage(it.svg) : Promise.resolve(null)));
    let W = 22; items.forEach(it => { W += it.op ? opW : tileW; }); W += 22;
    const cv = document.createElement('canvas'); cv.width = W * S; cv.height = H * S;
    const ctx = cv.getContext('2d'); ctx.scale(S, S);
    ctx.fillStyle = '#ffffff'; ctx.fillRect(0, 0, W, H);
    ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
    let x = 22;
    items.forEach((it, i) => {
      if (it.op){ ctx.fillStyle = it.op === '→' ? '#6d5efc' : '#475569'; ctx.font = '600 30px "Segoe UI", system-ui, sans-serif'; ctx.fillText(it.op, x + opW / 2, top + structH / 2); x += opW; }
      else { const cx = x + tileW / 2; if (imgs[i]) ctx.drawImage(imgs[i], x + 11, top, structW, structH); else { ctx.fillStyle = '#0f172a'; ctx.font = 'bold 26px "Fira Code", monospace'; ctx.fillText(it.label, cx, top + structH / 2); } ctx.fillStyle = '#0f172a'; ctx.font = '600 18px "Fira Code", monospace'; ctx.fillText(it.label, cx, top + structH + labelGap); x += tileW; }
    });
    return cv;
  }

  function parseBalanced(str){
    const parts = str.split(/\s*[→⇒]\s*/);
    if (parts.length !== 2) return null;
    function side(t){ return t.split(/\s+\+\s+/).map(tok => { const m = tok.trim().match(/^(\d+)?\s*(.+)$/); return m ? { n: m[1] ? +m[1] : 1, sp: m[2].replace(/\s+/g, '') } : null; }).filter(Boolean); }
    const reac = side(parts[0]), prod = side(parts[1]);
    return (reac.length && prod.length) ? { reac, prod } : null;
  }

  let lastKey = '', lastCanvas = null, busy = false;
  async function render(){
    if (busy) return;
    const ok = resultContent.querySelector('.cb-balanced-eq');
    const balanced = resultContent.dataset.balanced || '';
    if (!ok || !balanced){ figure.hidden = true; return; }
    if (balanced === lastKey) return;
    lastKey = balanced;
    const parsed = parseBalanced(balanced);
    if (!parsed){ figure.hidden = true; return; }
    busy = true;
    figure.hidden = false;
    figure.innerHTML = '<div class="cb-figure-note"><span class="cb-figure-spin"></span>Drawing structures…</div>';
    try {
      const items = [];
      for (let i = 0; i < parsed.reac.length; i++){ if (i) items.push({ op:'+' }); const r = parsed.reac[i]; items.push({ label: labelOf(r.n, r.sp), svg: svgFor(await resolvePartSmiles(r.sp)) }); }
      items.push({ op:'→' });
      for (let i = 0; i < parsed.prod.length; i++){ if (i) items.push({ op:'+' }); const p = parsed.prod[i]; items.push({ label: labelOf(p.n, p.sp), svg: svgFor(await resolvePartSmiles(p.sp)) }); }
      lastCanvas = await composeCanvas(items);
      figure.innerHTML =
        '<div class="cb-figure-head"><span class="cb-figure-lbl">Reaction diagram</span>' +
        '<button type="button" class="cb-figure-dl" id="cb-figure-dl">⬇ Download PNG</button></div>' +
        '<img alt="Balanced reaction diagram" src="' + lastCanvas.toDataURL('image/png') + '">' +
        '<p class="cb-figure-note">2D structures from PubChem / OpenChemLib. Species without a structure show as their formula.</p>';
      const dl = document.getElementById('cb-figure-dl');
      if (dl) dl.addEventListener('click', () => { lastCanvas.toBlob(b => { const u = URL.createObjectURL(b); const a = document.createElement('a'); a.href = u; a.download = 'reaction-diagram.png'; a.click(); URL.revokeObjectURL(u); }); });
    } catch (e){ figure.hidden = true; }
    busy = false;
  }

  let timer = null;
  const obs = new MutationObserver(() => { clearTimeout(timer); timer = setTimeout(render, 200); });
  obs.observe(resultContent, { childList:true, subtree:true, attributes:true, attributeFilter:['data-balanced'] });
  setTimeout(render, 400);   // catch the initial auto-balance
})();
</script>

<%@ include file="modern/components/analytics.jsp" %>
</body>
</html>
