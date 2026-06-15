<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<jsp:include page="modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="Equilibrium &amp; pH Calculator" />
    <jsp:param name="toolCategory" value="Chemistry" />
    <jsp:param name="toolDescription" value="Solve acid-base equilibria rigorously: pH of weak acids and bases, buffer pH and capacity, Ksp solubility with the common-ion effect, and arbitrary equilibrium systems. Includes titration curves and species-distribution diagrams. Powered by chempy + SciPy." />
    <jsp:param name="toolUrl" value="equilibrium-ph-calculator.jsp" />
    <jsp:param name="toolKeywords" value="pH calculator, equilibrium calculator, weak acid pH, weak base pH, buffer calculator, Henderson-Hasselbalch, Ksp calculator, molar solubility, common ion effect, titration curve, percent ionization, pKa, pKb, acid base equilibrium, ICE table" />
    <jsp:param name="toolImage" value="equilibrium-ph-og.png" />
    <jsp:param name="breadcrumbCategoryUrl" value="chemistry/" />
    <jsp:param name="teaches" value="acid-base equilibria, pH and pOH, weak acids and bases, buffers, Henderson-Hasselbalch, solubility product, common ion effect, titration curves" />
    <jsp:param name="educationalLevel" value="High School, Undergraduate" />
    <jsp:param name="hasSteps" value="true" />
    <jsp:param name="howToSteps" value="Pick what you're solving|Choose Weak acid, Weak base, Buffer, Solubility (Ksp) or a Custom equilibrium,Enter the numbers|Type the pKa/pKb/Ksp and concentrations — or click a species in the reference table to fill them,Solve|The tool builds the equilibrium and solves it rigorously (no approximations) for pH, pOH and every species concentration,Read the curves|For acids and bases it also plots the titration curve and the species-distribution diagram" />
    <jsp:param name="faq1q" value="How do you calculate the pH of a weak acid?" />
    <jsp:param name="faq1a" value="For a weak acid HA with acid dissociation constant Ka and concentration C, set up the equilibrium HA = H+ + A- together with water autoionization. This tool solves the full charge-balance equation numerically rather than using the simplified square-root-of-Ka-times-C approximation, so the pH is correct even for very dilute or very weak acids where the approximation fails." />
    <jsp:param name="faq2q" value="What is the Henderson-Hasselbalch equation?" />
    <jsp:param name="faq2a" value="The Henderson-Hasselbalch equation gives buffer pH as pH = pKa + log([A-]/[HA]), where [A-] is the conjugate base concentration and [HA] the weak acid concentration. It is an approximation valid when both concentrations are reasonably large. This tool shows the Henderson-Hasselbalch value alongside the rigorous equilibrium solution so you can see when they agree." />
    <jsp:param name="faq3q" value="How do you find molar solubility from Ksp?" />
    <jsp:param name="faq3a" value="For a salt that dissolves into a cations and b anions, the solubility product is Ksp = (a·s)^a · (b·s)^b, where s is the molar solubility. For example AgCl gives Ksp = s^2 so s = sqrt(Ksp); CaF2 gives Ksp = 4s^3 so s = cube root of Ksp/4. Adding a common ion shifts the equilibrium and lowers solubility — enter a common-ion concentration to see the effect." />
    <jsp:param name="faq4q" value="What is the common ion effect?" />
    <jsp:param name="faq4a" value="The common ion effect is the decrease in solubility of a salt when one of its ions is already present in solution. By Le Chatelier's principle, extra common ion pushes the dissolution equilibrium back toward the solid, so less of the salt dissolves. The Solubility mode lets you add a common-ion concentration and recomputes the reduced molar solubility." />
    <jsp:param name="faq5q" value="What does the species distribution diagram show?" />
    <jsp:param name="faq5a" value="A species-distribution (or alpha) diagram plots the fraction of each acid-base species as a function of pH. For a monoprotic acid it shows the fraction present as HA versus A-: the two curves cross at pH = pKa, where the acid and its conjugate base are equal. It makes buffer regions and titration endpoints easy to see." />
    <jsp:param name="faq6q" value="Is this pH and equilibrium calculator free?" />
    <jsp:param name="faq6a" value="Yes. It is completely free, needs no signup, and the chemistry is solved on the server with the open-source chempy and SciPy libraries for rigorous, textbook-accurate results." />
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
    /* Equilibrium & pH — chemistry studio. chempy + SciPy backend. */
    .eq-modes { display:inline-flex; flex-wrap:wrap; gap:2px; padding:3px; background:var(--cs-panel-bg-soft); border:1px solid var(--cs-line); border-radius:var(--cs-radius-pill); margin-bottom:1.1rem; }
    .eq-mode { border:none; background:transparent; color:var(--cs-muted); font:600 12.5px var(--cs-font-sans); cursor:pointer; padding:6px 14px; border-radius:var(--cs-radius-pill); white-space:nowrap; transition:color var(--cs-transition), background var(--cs-transition); }
    .eq-mode:hover:not(.active) { color:var(--cs-ink); }
    .eq-mode.active { background:var(--cs-panel-bg); color:var(--cs-accent); box-shadow:var(--cs-shadow-sm); }

    .eq-form { display:none; }
    .eq-form.active { display:block; }
    .eq-fields { display:flex; flex-wrap:wrap; gap:0.7rem 1rem; align-items:flex-end; }
    .eq-field { display:flex; flex-direction:column; gap:0.3rem; }
    .eq-field label { font:600 0.68rem var(--cs-font-sans); text-transform:uppercase; letter-spacing:0.05em; color:var(--cs-muted); }
    .eq-input, .eq-area { padding:0.55rem 0.8rem; border:1.5px solid var(--cs-line-strong); border-radius:var(--cs-radius-sm); background:var(--cs-panel-bg-soft); color:var(--cs-ink); font:14px var(--cs-font-sans); transition:border-color var(--cs-transition), box-shadow var(--cs-transition); }
    .eq-input:focus, .eq-area:focus { outline:none; border-color:var(--cs-accent); background:var(--cs-panel-bg); box-shadow:var(--cs-ring); }
    .eq-input.num { width:7rem; text-align:center; }
    .eq-input.name { width:11rem; }
    .eq-area { width:100%; min-height:90px; font-family:var(--cs-font-mono); font-size:13px; resize:vertical; }
    .eq-hint { font-size:0.78rem; color:var(--cs-muted); line-height:1.5; margin:0.6rem 0 0; }
    .eq-hint code { font:12px var(--cs-font-mono); background:var(--cs-panel-bg-soft); padding:1px 5px; border-radius:4px; color:var(--cs-ink-soft); }
    .eq-btn { display:inline-flex; align-items:center; gap:0.4rem; padding:0.6rem 1.25rem; border-radius:var(--cs-radius-pill); background:var(--cs-accent); color:#fff; border:1px solid var(--cs-accent); font:600 0.85rem var(--cs-font-sans); cursor:pointer; transition:background var(--cs-transition), transform 0.1s var(--cs-ease); }
    .eq-btn:hover { background:var(--cs-accent-hover); transform:translateY(-1px); }
    .eq-btn:disabled { opacity:0.6; cursor:wait; transform:none; }
    .eq-cta { margin-top:1rem; }

    details.eq-collapse { border:1px solid var(--cs-line); border-radius:var(--cs-radius-sm); background:var(--cs-panel-bg-soft); margin-top:0.85rem; }
    details.eq-collapse > summary { list-style:none; cursor:pointer; padding:0.6rem 0.85rem; font:600 0.8rem var(--cs-font-sans); color:var(--cs-ink); display:flex; align-items:center; gap:0.4rem; }
    details.eq-collapse > summary::-webkit-details-marker { display:none; }
    details.eq-collapse > summary::after { content:"\25be"; margin-left:auto; opacity:0.55; transition:transform .15s; }
    details.eq-collapse[open] > summary::after { transform:rotate(180deg); }
    .eq-ref-wrap { max-height:260px; overflow:auto; padding:0 0.85rem 0.85rem; }
    table.eq-ref { width:100%; border-collapse:collapse; font-size:0.8rem; }
    table.eq-ref th { position:sticky; top:0; background:var(--cs-panel-bg); text-align:left; padding:0.4rem 0.5rem; font:600 0.64rem var(--cs-font-sans); text-transform:uppercase; color:var(--cs-muted); border-bottom:1px solid var(--cs-line); }
    table.eq-ref td { padding:0.35rem 0.5rem; border-bottom:1px solid var(--cs-line); color:var(--cs-ink); }
    table.eq-ref tr { cursor:pointer; }
    table.eq-ref tr:hover td { background:var(--cs-accent-softer); }
    table.eq-ref .v { font-family:var(--cs-font-mono); color:var(--cs-accent); white-space:nowrap; }

    .eq-card { background:var(--cs-panel-bg); border:1px solid var(--cs-line); border-radius:var(--cs-radius-lg); box-shadow:var(--cs-shadow-sm); padding:1.5rem; overflow:hidden; }
    .eq-card-head { display:flex; align-items:center; gap:0.5rem; margin:0 0 1rem; }
    .eq-card-head h2 { margin:0; font:600 0.72rem var(--cs-font-sans); text-transform:uppercase; letter-spacing:0.08em; color:var(--cs-muted); }
    .eq-share { margin-left:auto; border:1px solid var(--cs-line-strong); background:var(--cs-panel-bg); color:var(--cs-ink-soft); border-radius:var(--cs-radius-pill); padding:0.3rem 0.85rem; font:600 0.72rem var(--cs-font-sans); cursor:pointer; transition:border-color var(--cs-transition), color var(--cs-transition); }
    .eq-share:hover { border-color:var(--cs-accent); color:var(--cs-accent); }
    .eq-ph { display:flex; align-items:baseline; gap:0.6rem; }
    .eq-ph .big { font:800 3rem var(--cs-font-mono); color:var(--cs-accent); line-height:1; }
    .eq-ph .lbl { font:0.85rem var(--cs-font-sans); color:var(--cs-muted); }
    .eq-stats { display:grid; grid-template-columns:repeat(auto-fit,minmax(120px,1fr)); gap:0.75rem; margin-top:1.1rem; }
    .eq-stat { padding:0.75rem 0.7rem; background:var(--cs-panel-bg-soft); border-radius:var(--cs-radius-sm); border-left:3px solid var(--cs-accent); text-align:center; }
    .eq-stat .k { display:block; font:600 0.62rem var(--cs-font-sans); text-transform:uppercase; letter-spacing:0.05em; color:var(--cs-muted); margin-bottom:0.3rem; }
    .eq-stat .v { font:700 1.15rem var(--cs-font-mono); color:var(--cs-ink); }
    .eq-stat .s { display:block; font:0.68rem var(--cs-font-sans); color:var(--cs-muted); margin-top:0.15rem; }
    .eq-plotgrid { display:grid; grid-template-columns:repeat(auto-fit,minmax(300px,1fr)); gap:1rem; }
    .eq-plot { background:var(--cs-panel-bg-soft); border:1px solid var(--cs-line); border-radius:var(--cs-radius); padding:0.6rem; }
    .eq-plot h3 { font:600 0.7rem var(--cs-font-sans); text-transform:uppercase; letter-spacing:0.06em; color:var(--cs-muted); margin:0 0 0.4rem 0.3rem; }
    .eq-plot svg { display:block; width:100%; height:auto; }
    .eq-plot .ax { stroke:var(--cs-line-strong); stroke-width:1; }
    .eq-plot .grid { stroke:var(--cs-line); stroke-width:1; }
    .eq-plot text { fill:var(--cs-muted); font:9px var(--cs-font-sans); }
    .eq-plot .lgd { font:10px var(--cs-font-sans); }
    .eq-verdict { margin-top:1rem; padding:0.75rem 1rem; border-radius:var(--cs-radius); font:0.85rem var(--cs-font-sans); background:var(--cs-accent-softer); border:1px solid var(--cs-accent-ring); border-left:3px solid var(--cs-accent); color:var(--cs-ink-soft); }
    .eq-err { padding:1rem 1.1rem; border-radius:var(--cs-radius); background:#fef7ed; border:1px solid #fdba74; color:#9a3412; font-size:0.9rem; }
    [data-theme="dark"] .eq-err { background:rgba(251,146,60,0.08); border-color:rgba(251,146,60,0.3); color:#fdba74; }
    .eq-spin { display:inline-block; width:13px; height:13px; border:2px solid rgba(255,255,255,0.45); border-top-color:#fff; border-radius:50%; animation:eq-spin 0.7s linear infinite; }
    @keyframes eq-spin { to { transform:rotate(360deg); } }

    .pt-seo { display:flex; flex-direction:column; gap:1rem; margin-top:1.25rem; }
    .pt-seo-card { background:var(--cs-panel-bg); border:1px solid var(--cs-line); border-radius:var(--cs-radius-lg); box-shadow:var(--cs-shadow-sm); padding:1.5rem 1.6rem; }
    .pt-seo-card h2 { font:400 1.4rem var(--cs-font-serif); color:var(--cs-ink); margin:0 0 0.6rem; }
    .pt-seo-card h3 { font:600 0.95rem var(--cs-font-sans); color:var(--cs-ink); margin:1rem 0 0.4rem; }
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
    <% request.setAttribute("activeService", "equilibrium"); %>
    <jsp:include page="/chemistry/partials/sidebar.jsp" />

    <section class="cs-workspace">

<div class="cs-title">
    <nav class="cs-crumbs" aria-label="Breadcrumb">
        <a href="<%=ctx%>/index.jsp">Home</a> /
        <a href="<%=ctx%>/chemistry/">Chemistry</a> /
        <span aria-current="page">Equilibrium &amp; pH</span>
    </nav>
    <h1>Equilibrium &amp; pH Calculator</h1>
</div>

<div class="ic-stack">

    <!-- ===== Input ===== -->
    <div class="ic-hero">
        <div class="eq-modes" id="eqModes">
            <button type="button" class="eq-mode active" data-mode="acid">Weak acid</button>
            <button type="button" class="eq-mode" data-mode="base">Weak base</button>
            <button type="button" class="eq-mode" data-mode="buffer">Buffer</button>
            <button type="button" class="eq-mode" data-mode="ksp">Solubility (Ksp)</button>
            <button type="button" class="eq-mode" data-mode="custom">Custom</button>
        </div>

        <!-- Weak acid -->
        <div class="eq-form active" data-form="acid">
            <div class="eq-fields">
                <div class="eq-field"><label for="aName">Acid name (label only)</label><input type="text" class="eq-input name" id="aName" placeholder="e.g. acetic acid — optional" title="Just a label for the result heading; the pH is computed from pKa and concentration."></div>
                <div class="eq-field"><label for="aPka">pKa</label><input type="number" class="eq-input num" id="aPka" step="0.01" value="4.76"></div>
                <div class="eq-field"><label for="aConc">Concentration (M)</label><input type="number" class="eq-input num" id="aConc" step="0.001" value="0.1"></div>
            </div>
            <p class="eq-hint">Rigorous solve (full charge balance), so it stays correct for dilute, very weak, or strong acids. Click a row in the reference for a pKa. Polyprotic acids: the <code>(1st)</code>/<code>(2nd)</code> entries solve a single step — use <strong>Custom</strong> for the full system.</p>
        </div>

        <!-- Weak base -->
        <div class="eq-form" data-form="base">
            <div class="eq-fields">
                <div class="eq-field"><label for="bName">Base name (label only)</label><input type="text" class="eq-input name" id="bName" placeholder="e.g. ammonia — optional" title="Just a label for the result heading; the pH is computed from pKb and concentration."></div>
                <div class="eq-field"><label for="bPkb">pKb</label><input type="number" class="eq-input num" id="bPkb" step="0.01" value="4.75"></div>
                <div class="eq-field"><label for="bConc">Concentration (M)</label><input type="number" class="eq-input num" id="bConc" step="0.001" value="0.1"></div>
            </div>
            <p class="eq-hint">pKa of the conjugate acid is taken as 14 &minus; pKb.</p>
        </div>

        <!-- Buffer -->
        <div class="eq-form" data-form="buffer">
            <div class="eq-fields">
                <div class="eq-field"><label for="fPka">pKa (weak acid)</label><input type="number" class="eq-input num" id="fPka" step="0.01" value="4.76"></div>
                <div class="eq-field"><label for="fAcid">[acid] (M)</label><input type="number" class="eq-input num" id="fAcid" step="0.001" value="0.1"></div>
                <div class="eq-field"><label for="fBase">[conjugate base] (M)</label><input type="number" class="eq-input num" id="fBase" step="0.001" value="0.1"></div>
            </div>
            <p class="eq-hint">Shows the rigorous pH, the Henderson&ndash;Hasselbalch value, and buffer capacity.</p>
        </div>

        <!-- Solubility -->
        <div class="eq-form" data-form="ksp">
            <div class="eq-fields">
                <div class="eq-field"><label for="kName">Salt name (label only)</label><input type="text" class="eq-input name" id="kName" placeholder="e.g. AgCl — optional" title="Just a label for the result heading; solubility is computed from Ksp and the a/b stoichiometry."></div>
                <div class="eq-field"><label for="kKsp">Ksp</label><input type="text" class="eq-input num" id="kKsp" value="1.8e-10"></div>
                <div class="eq-field"><label for="kA" title="cations per formula unit">cations (a)</label><input type="number" class="eq-input num" id="kA" min="1" value="1" style="width:5rem;"></div>
                <div class="eq-field"><label for="kB" title="anions per formula unit">anions (b)</label><input type="number" class="eq-input num" id="kB" min="1" value="1" style="width:5rem;"></div>
                <div class="eq-field"><label for="kCommon">[common ion] (M)</label><input type="number" class="eq-input num" id="kCommon" step="0.001" value="0"></div>
                <div class="eq-field"><label for="kSide">common ion is</label><select class="eq-input" id="kSide" style="width:auto;"><option value="anion">anion</option><option value="cation">cation</option></select></div>
            </div>
            <p class="eq-hint">For C<sub>a</sub>A<sub>b</sub>: Ksp = (a&middot;s)<sup>a</sup>(b&middot;s)<sup>b</sup>. Add a common-ion concentration to see solubility drop.</p>
        </div>

        <!-- Custom -->
        <div class="eq-form" data-form="custom">
            <div class="eq-field" style="width:100%;"><label for="cEq">Equilibria — one per line, <code>reactants = products; K</code></label>
                <textarea class="eq-area" id="cEq">HOAc = H+ + OAc-; 10**-4.76
H2O = H+ + OH-; 1e-14</textarea></div>
            <div class="eq-field" style="width:100%;margin-top:0.6rem;"><label for="cInit">Initial concentrations (M) — <code>species: value</code></label>
                <textarea class="eq-area" id="cInit" style="min-height:60px;">HOAc: 0.1
H2O: 1</textarea></div>
            <p class="eq-hint">Solved with <strong>chempy.equilibria</strong>. Handles polyprotic systems — add a line per dissociation step.</p>
        </div>

        <div class="eq-cta"><button type="button" class="eq-btn" id="eqSolve">&#9883; Solve</button></div>

        <details class="eq-collapse" id="eqRefBox">
            <summary id="eqRefSummary">pKa reference</summary>
            <div class="eq-ref-wrap"><table class="eq-ref"><thead id="eqRefHead"></thead><tbody id="eqRefBody"></tbody></table></div>
        </details>
    </div>

    <!-- ===== Result ===== -->
    <div class="eq-card" id="eqResultCard" style="display:none;">
        <div class="eq-card-head"><span style="color:var(--cs-accent);">&#8652;</span><h2 id="eqResultTitle">Result</h2><button type="button" id="eqShareBtn" class="eq-share" style="display:none;">&#128279; Share</button></div>
        <div id="eqResultBody"></div>
    </div>

    <div class="cs-inline-ad">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <!-- ===== Below-fold content ===== -->
    <section class="pt-seo">
        <div class="pt-seo-card">
            <h2>Acid–base equilibria, solved properly</h2>
            <p>Most online pH calculators use the shortcut <code>[H⁺] ≈ √(Ka·C)</code>, which quietly breaks for dilute or very weak acids. This tool builds the actual equilibrium — including water autoionization — and solves the full <strong>charge-balance</strong> equation numerically, so the pH is right across the whole range. Behind the scenes it runs <strong>chempy</strong> and <strong>SciPy</strong> on the server.</p>
            <h3>What each mode does</h3>
            <ul>
                <li><strong>Weak acid / base</strong> — pH, pOH, [H⁺], [OH⁻], conjugate concentrations and <strong>% ionization</strong>, plus a titration curve and species-distribution diagram.</li>
                <li><strong>Buffer</strong> — rigorous pH next to the <strong>Henderson–Hasselbalch</strong> estimate, with buffer capacity.</li>
                <li><strong>Solubility (Ksp)</strong> — molar solubility and ion concentrations, with the <strong>common-ion effect</strong>.</li>
                <li><strong>Custom</strong> — write any set of equilibria (polyprotic, complexation…) and solve the whole system at once.</li>
            </ul>
        </div>
        <div class="pt-seo-card">
            <h2 class="cs-faq-title" id="faqs" style="font-family:var(--cs-font-serif);">Frequently asked</h2>
            <div class="cs-faq" aria-label="Equilibrium &amp; pH FAQ">
                <div class="cs-faq-item"><button class="cs-faq-q" type="button">How do you calculate the pH of a weak acid?<svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                    <div class="cs-faq-a">Set up HA = H⁺ + A⁻ with its Ka plus water autoionization, then solve the charge-balance equation numerically. This avoids the √(Ka·C) approximation, so it's accurate even for dilute or very weak acids.</div></div>
                <div class="cs-faq-item"><button class="cs-faq-q" type="button">What is the Henderson–Hasselbalch equation?<svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                    <div class="cs-faq-a">pH = pKa + log([A⁻]/[HA]) for a buffer. It's an approximation valid when both concentrations are sizeable; the tool shows it next to the exact solution.</div></div>
                <div class="cs-faq-item"><button class="cs-faq-q" type="button">How do you find molar solubility from Ksp?<svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                    <div class="cs-faq-a">For a salt giving a cations and b anions, Ksp = (a·s)ᵃ(b·s)ᵇ. AgCl → s = √Ksp; CaF₂ → s = ∛(Ksp/4). A common ion lowers s — enter its concentration to see by how much.</div></div>
                <div class="cs-faq-item"><button class="cs-faq-q" type="button">What does the distribution diagram show?<svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                    <div class="cs-faq-a">The fraction of each species versus pH. For a monoprotic acid the HA and A⁻ curves cross at pH = pKa, which is the centre of the buffer region.</div></div>
                <div class="cs-faq-item"><button class="cs-faq-q" type="button">Is it free?<svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                    <div class="cs-faq-a">Yes — free, no signup, solved with the open-source chempy and SciPy libraries.</div></div>
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
<script src="<%=ctx%>/modern/js/tool-utils.js"></script>
<script>
(function () {
  "use strict";
  var RUN = '<%=ctx%>/OneCompilerFunctionality';

  // ── reference data ─────────────────────────────────────────────────
  var ACIDS = [
    ['Hydrochloric (strong)', 'HCl', -7], ['Sulfuric (1st)', 'HSO4-', -3], ['Phosphoric (1st)', 'H3PO4', 2.15],
    ['Citric (1st)', 'C6H8O7', 3.13], ['Hydrofluoric', 'HF', 3.17], ['Nitrous', 'HNO2', 3.34],
    ['Formic', 'HCOOH', 3.75], ['Lactic', 'C3H6O3', 3.86], ['Benzoic', 'C6H5COOH', 4.20],
    ['Acetic', 'CH3COOH', 4.76], ['Carbonic (1st)', 'H2CO3', 6.35], ['Hypochlorous', 'HClO', 7.53],
    ['Hydrocyanic', 'HCN', 9.21], ['Ammonium', 'NH4+', 9.25], ['Boric', 'H3BO3', 9.24],
    ['Phenol', 'C6H5OH', 9.99], ['Bicarbonate (2nd)', 'HCO3-', 10.33]
  ];
  var BASES = [
    ['Ammonia', 'NH3', 4.75], ['Methylamine', 'CH3NH2', 3.36], ['Ethylamine', 'C2H5NH2', 3.25],
    ['Dimethylamine', '(CH3)2NH', 3.27], ['Trimethylamine', '(CH3)3N', 4.19], ['Pyridine', 'C5H5N', 8.75],
    ['Aniline', 'C6H5NH2', 9.40], ['Hydrazine', 'N2H4', 6.07], ['Urea', 'CH4N2O', 13.9]
  ];
  // [name, formula, Ksp, a(cations), b(anions)]
  var KSP = [
    ['Silver chloride', 'AgCl', 1.8e-10, 1, 1], ['Silver bromide', 'AgBr', 5.4e-13, 1, 1],
    ['Silver iodide', 'AgI', 8.5e-17, 1, 1], ['Barium sulfate', 'BaSO4', 1.1e-10, 1, 1],
    ['Calcium carbonate', 'CaCO3', 3.3e-9, 1, 1], ['Calcium sulfate', 'CaSO4', 4.9e-5, 1, 1],
    ['Calcium fluoride', 'CaF2', 3.5e-11, 1, 2], ['Calcium hydroxide', 'Ca(OH)2', 5.0e-6, 1, 2],
    ['Magnesium hydroxide', 'Mg(OH)2', 5.6e-12, 1, 2], ['Iron(III) hydroxide', 'Fe(OH)3', 2.8e-39, 1, 3],
    ['Lead(II) iodide', 'PbI2', 7.1e-9, 1, 2], ['Lead(II) chloride', 'PbCl2', 1.7e-5, 1, 2],
    ['Aluminium hydroxide', 'Al(OH)3', 3.0e-34, 1, 3], ['Silver chromate', 'Ag2CrO4', 1.1e-12, 2, 1]
  ];

  function $(id) { return document.getElementById(id); }
  var mode = 'acid';

  // ── mode switching ──────────────────────────────────────────────────
  $('eqModes').addEventListener('click', function (e) {
    var b = e.target.closest('[data-mode]'); if (!b) return;
    mode = b.getAttribute('data-mode');
    document.querySelectorAll('.eq-mode').forEach(function (m) { m.classList.toggle('active', m === b); });
    document.querySelectorAll('.eq-form').forEach(function (f) { f.classList.toggle('active', f.getAttribute('data-form') === mode); });
    renderRef();
  });

  // ── reference table per mode ────────────────────────────────────────
  function renderRef() {
    var head = $('eqRefHead'), body = $('eqRefBody'), sum = $('eqRefSummary'), box = $('eqRefBox');
    if (mode === 'acid' || mode === 'buffer') {
      sum.textContent = 'pKa reference (common acids)';
      head.innerHTML = '<tr><th>Acid</th><th>Formula</th><th>pKa</th></tr>';
      body.innerHTML = ACIDS.map(function (a, i) { return '<tr data-ref="acid" data-i="' + i + '"><td>' + a[0] + '</td><td>' + pretty(a[1]) + '</td><td class="v">' + a[2] + '</td></tr>'; }).join('');
      box.style.display = '';
    } else if (mode === 'base') {
      sum.textContent = 'pKb reference (common bases)';
      head.innerHTML = '<tr><th>Base</th><th>Formula</th><th>pKb</th></tr>';
      body.innerHTML = BASES.map(function (a, i) { return '<tr data-ref="base" data-i="' + i + '"><td>' + a[0] + '</td><td>' + pretty(a[1]) + '</td><td class="v">' + a[2] + '</td></tr>'; }).join('');
      box.style.display = '';
    } else if (mode === 'ksp') {
      sum.textContent = 'Ksp reference (sparingly soluble salts)';
      head.innerHTML = '<tr><th>Salt</th><th>Formula</th><th>Ksp</th></tr>';
      body.innerHTML = KSP.map(function (a, i) { return '<tr data-ref="ksp" data-i="' + i + '"><td>' + a[0] + '</td><td>' + pretty(a[1]) + '</td><td class="v">' + a[2].toExponential(1) + '</td></tr>'; }).join('');
      box.style.display = '';
    } else { box.style.display = 'none'; }
  }
  $('eqRefBody').addEventListener('click', function (e) {
    var tr = e.target.closest('[data-ref]'); if (!tr) return;
    var i = +tr.getAttribute('data-i'), t = tr.getAttribute('data-ref');
    if (t === 'acid') {
      if (mode === 'buffer') { $('fPka').value = ACIDS[i][2]; }
      else { $('aName').value = ACIDS[i][0]; $('aPka').value = ACIDS[i][2]; }
    } else if (t === 'base') { $('bName').value = BASES[i][0]; $('bPkb').value = BASES[i][2]; }
    else if (t === 'ksp') { $('kName').value = KSP[i][1]; $('kKsp').value = KSP[i][2].toExponential(2); $('kA').value = KSP[i][3]; $('kB').value = KSP[i][4]; }
  });

  function pretty(f) { return String(f).replace(/(\d+)/g, function (d) { return '<sub>' + d + '</sub>'; }).replace(/\+/g, '⁺').replace(/-/g, '⁻'); }
  function num(v) { var n = parseFloat(v); return isNaN(n) ? null : n; }

  // ── build payload from current mode ─────────────────────────────────
  function payloadFor() {
    if (mode === 'acid') return { mode:'acid', Ka: Math.pow(10, -num($('aPka').value)), C: num($('aConc').value), name: $('aName').value.trim() };
    if (mode === 'base') return { mode:'base', Kb: Math.pow(10, -num($('bPkb').value)), C: num($('bConc').value), name: $('bName').value.trim() };
    if (mode === 'buffer') return { mode:'buffer', Ka: Math.pow(10, -num($('fPka').value)), Ca: num($('fAcid').value), Cb: num($('fBase').value), pKa: num($('fPka').value) };
    if (mode === 'ksp') return { mode:'ksp', Ksp: num($('kKsp').value), a: Math.round(num($('kA').value)), b: Math.round(num($('kB').value)), common: num($('kCommon').value) || 0, side: $('kSide').value, name: $('kName').value.trim() };
    if (mode === 'custom') {
      var eqs = $('cEq').value.split('\n').map(function (s) { return s.trim(); }).filter(Boolean);
      var init = {};
      $('cInit').value.split('\n').forEach(function (line) { var m = line.split(':'); if (m.length === 2) { var k = m[0].trim(), v = parseFloat(m[1]); if (k && !isNaN(v)) init[k] = v; } });
      return { mode:'custom', eqstr: eqs.join('\n'), init: init };
    }
  }

  // ── Python (chempy + SciPy) ─────────────────────────────────────────
  function buildCode(p) {
    return [
'import json, math',
'import numpy as np',
'from scipy.optimize import brentq',
'P = json.loads(r"""' + JSON.stringify(p) + '""")',
'Kw = 1e-14',
'def solve(f, lo=1e-16, hi=1e3):',
'    try:',
'        return brentq(f, lo, hi)',
'    except Exception:',
'        xs = np.logspace(math.log10(lo), math.log10(hi), 800)',
'        v = [f(x) for x in xs]',
'        for i in range(len(xs)-1):',
'            if v[i]==0: return xs[i]',
'            if v[i]*v[i+1] < 0: return brentq(f, xs[i], xs[i+1])',
'        raise',
'def alphas_mono(Ka):',
'    phs = [j*0.1 for j in range(0,141)]',
'    HA=[]; A=[]',
'    for ph in phs:',
'        h=10**(-ph); HA.append(round(h/(h+Ka),4)); A.append(round(Ka/(h+Ka),4))',
'    return {"ph":[round(x,2) for x in phs],"HA":HA,"A":A}',
'res={}',
'try:',
'    m=P["mode"]',
'    if m in ("acid","buffer"):',
'        Ka=P["Ka"]',
'        if m=="acid":',
'            C=P["C"]',
'            f=lambda h: Kw/h + C*Ka/(Ka+h) - h',
'            h=solve(f); A=C*Ka/(Ka+h); HA=C-A',
'            res.update({"pH":-math.log10(h),"pOH":14+math.log10(h),"H":h,"OH":Kw/h,"A":A,"HA":HA,"pct":100*A/C if C else 0})',
'            tit=[]',
'            for k in range(0,81):',
'                phi=k/40.0; Ctot=C/(1+phi); Cb=C*phi/(1+phi)',
'                g=lambda h: Cb + h - Kw/h - Ctot*Ka/(Ka+h)',
'                hh=solve(g); tit.append([round(phi,3), round(-math.log10(hh),3)])',
'            res["titration"]={"data":tit,"xlabel":"vol added / vol acid","kind":"acid"}',
'            res["dist"]=alphas_mono(Ka)',
'        else:',
'            Ca=P["Ca"]; Cb=P["Cb"]; tot=Ca+Cb',
'            f=lambda h: Cb + h - Kw/h - tot*Ka/(Ka+h)',
'            h=solve(f)',
'            hh=P["pKa"]+math.log10(Cb/Ca) if Ca>0 and Cb>0 else None',
'            cap=2.303*((Kw/h)+h + tot*(Ka*h)/((Ka+h)**2))',
'            res.update({"pH":-math.log10(h),"pOH":14+math.log10(h),"H":h,"OH":Kw/h,"HH":hh,"cap":cap,"HA":tot*h/(Ka+h),"A":tot*Ka/(Ka+h)})',
'            res["dist"]=alphas_mono(Ka)',
'    elif m=="base":',
'        Kb=P["Kb"]; C=P["C"]; Ka=Kw/Kb',
'        f=lambda h: C*h/(Ka+h) + h - Kw/h',
'        h=solve(f); BH=C*h/(Ka+h); B=C-BH; oh=Kw/h',
'        res.update({"pH":-math.log10(h),"pOH":14+math.log10(h),"H":h,"OH":oh,"BH":BH,"B":B,"pct":100*BH/C if C else 0})',
'        tit=[]',
'        for k in range(0,81):',
'            phi=k/40.0; Ctot=C/(1+phi); Cacid=C*phi/(1+phi)',
'            g=lambda h: Ctot*h/(Ka+h) + h - Cacid - Kw/h',
'            hh=solve(g); tit.append([round(phi,3), round(-math.log10(hh),3)])',
'        res["titration"]={"data":tit,"xlabel":"vol acid added / vol base","kind":"base"}',
'        res["dist"]={"ph":alphas_mono(Ka)["ph"],"B":alphas_mono(Ka)["A"],"BH":alphas_mono(Ka)["HA"]}',
'    elif m=="ksp":',
'        Ksp=P["Ksp"]; a=P["a"]; b=P["b"]; cc=P["common"]; side=P.get("side","anion")',
'        ce = cc if side=="cation" else 0.0',
'        ae = cc if side=="anion" else 0.0',
'        g=lambda s: ((a*s+ce)**a)*((b*s+ae)**b) - Ksp',
'        smax=(Ksp)**(1.0/(a+b))*10 + 1e-9',
'        s=solve(g, 1e-30, max(smax,1e-3))',
'        res.update({"s":s,"cation":a*s+ce,"anion":b*s+ae,"a":a,"b":b,"common":cc,"side":side})',
'    elif m=="custom":',
'        from chempy.equilibria import EqSystem',
'        from collections import defaultdict',
'        eqsys=EqSystem.from_string(P["eqstr"])',
'        x,sol,sane=eqsys.root(defaultdict(float, P["init"]))',
'        conc={str(s): float(c) for s,c in zip(eqsys.substances, x)}',
'        res["conc"]=conc',
'        if "H+" in conc and conc["H+"]>0: res["pH"]=-math.log10(conc["H+"]); res["pOH"]=14+math.log10(conc["H+"])',
'        res["sane"]=bool(sane)',
'    res["ok"]=True',
'except Exception as e:',
'    res={"ok":False,"error":type(e).__name__+": "+str(e)}',
'print("RESULT:"+json.dumps(res))'
    ].join('\n');
  }

  function run(p) {
    return fetch(RUN + '?action=execute', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify({ language:'python', version:'3.11', code: buildCode(p) }) })
      .then(function (r) { return r.json(); }).then(function (d) {
        var out = (d.Stdout || d.stdout || d.Output || '').toString();
        var m = out.match(/RESULT:(\{[\s\S]*\})/);
        if (!m) throw new Error((d.Stderr || d.stderr || out || 'No output').toString().slice(0, 400));
        return JSON.parse(m[1]);
      });
  }

  // ── solve + render ──────────────────────────────────────────────────
  var card = $('eqResultCard'), bodyEl = $('eqResultBody'), btn = $('eqSolve');
  btn.addEventListener('click', function () {
    var p = payloadFor();
    card.style.display = '';
    btn.disabled = true; var old = btn.innerHTML; btn.innerHTML = '<span class="eq-spin"></span> Solving…';
    bodyEl.innerHTML = '<p class="eq-hint">Solving with chempy + SciPy…</p>';
    run(p).then(function (res) {
      if (!res.ok) { bodyEl.innerHTML = '<div class="eq-err"><strong>Could not solve.</strong> ' + esc(res.error || '') + '</div>'; return; }
      render(p, res);
    }).catch(function (e) { bodyEl.innerHTML = '<div class="eq-err"><strong>Backend error.</strong> ' + esc(e.message || e) + '</div>'; })
      .then(function () { btn.disabled = false; btn.innerHTML = old; });
  });

  function stat(k, v, s) { return '<div class="eq-stat"><span class="k">' + k + '</span><span class="v">' + v + '</span>' + (s ? '<span class="s">' + s + '</span>' : '') + '</div>'; }
  function sci(x) { if (x == null || !isFinite(x)) return '—'; if (x === 0) return '0'; var a = Math.abs(x); return (a >= 1e4 || a < 1e-3) ? x.toExponential(2) : (+x.toPrecision(4)).toString(); }

  function render(p, res) {
    var m = p.mode, html = '';
    $('eqResultTitle').textContent = p.name ? p.name : (m === 'ksp' ? 'Solubility' : m === 'buffer' ? 'Buffer' : m === 'custom' ? 'Equilibrium' : m === 'base' ? 'Weak base' : 'Weak acid');
    $('eqShareBtn').style.display = '';
    if (res.pH != null) {
      html += '<div class="eq-ph"><span class="big">' + res.pH.toFixed(2) + '</span><span class="lbl">pH' + (res.pOH != null ? ' · pOH ' + res.pOH.toFixed(2) : '') + (res.sane === false ? ' · ⚠ check inputs' : '') + '</span></div>';
    }
    html += '<div class="eq-stats">';
    if (m === 'acid' || m === 'buffer') {
      html += stat('[H⁺]', sci(res.H) + ' M') + stat('[OH⁻]', sci(res.OH) + ' M') + stat('[HA]', sci(res.HA) + ' M') + stat('[A⁻]', sci(res.A) + ' M');
      if (m === 'acid') html += stat('% ionization', res.pct.toFixed(2) + '%');
      if (m === 'buffer') { html += stat('H–H pH', res.HH != null ? res.HH.toFixed(2) : '—', 'pKa + log([A⁻]/[HA])'); html += stat('buffer capacity β', sci(res.cap), 'mol/L per pH'); }
    } else if (m === 'base') {
      html += stat('[OH⁻]', sci(res.OH) + ' M') + stat('[H⁺]', sci(res.H) + ' M') + stat('[B]', sci(res.B) + ' M') + stat('[BH⁺]', sci(res.BH) + ' M') + stat('% ionization', res.pct.toFixed(2) + '%');
    } else if (m === 'ksp') {
      html += stat('molar solubility s', sci(res.s) + ' M') + stat('[cation]', sci(res.cation) + ' M') + stat('[anion]', sci(res.anion) + ' M');
      html += '</div><div class="eq-verdict">Ksp = [cation]<sup>a</sup>[anion]<sup>b</sup> with a=' + res.a + ', b=' + res.b + (res.common > 0 ? '. Common ' + (res.side === 'cation' ? 'cation' : 'anion') + ' (' + sci(res.common) + ' M) lowers s by Le Chatelier.' : '.') + '</div>';
      bodyEl.innerHTML = html; return;
    } else if (m === 'custom') {
      var keys = Object.keys(res.conc || {});
      html += keys.map(function (k) { return stat('[' + escSub(k) + ']', sci(res.conc[k]) + ' M'); }).join('');
    }
    html += '</div>';

    // plots
    var plots = '';
    if (res.titration) plots += '<div class="eq-plot"><h3>Titration curve</h3>' + titrationSVG(res.titration) + '</div>';
    if (res.dist) plots += '<div class="eq-plot"><h3>Species distribution</h3>' + distSVG(res.dist, m, res.pH) + '</div>';
    if (plots) html += '<div class="eq-plotgrid" style="margin-top:1rem;">' + plots + '</div>';
    if (res.titration) html += '<p class="eq-hint">Titration curve assumes a strong titrant at the same concentration as the analyte, so the equivalence point sits at 1 (volume added = volume analyte). The distribution curves cross at pH = pKa.</p>';

    bodyEl.innerHTML = html;
  }

  // ── tiny SVG plotters (no chart lib) ────────────────────────────────
  var W = 320, Hh = 200, PADL = 34, PADB = 26, PADT = 8, PADR = 8;
  function sx(x, x0, x1) { return PADL + (x - x0) / (x1 - x0) * (W - PADL - PADR); }
  function sy(y, y0, y1) { return PADT + (1 - (y - y0) / (y1 - y0)) * (Hh - PADT - PADB); }
  function axes(x0, x1, y0, y1, xl, yl, xticks, yticks) {
    var s = '<line class="ax" x1="' + PADL + '" y1="' + sy(y0, y0, y1) + '" x2="' + (W - PADR) + '" y2="' + sy(y0, y0, y1) + '"/>' +
            '<line class="ax" x1="' + PADL + '" y1="' + PADT + '" x2="' + PADL + '" y2="' + sy(y0, y0, y1) + '"/>';
    xticks.forEach(function (t) { var x = sx(t, x0, x1); s += '<line class="grid" x1="' + x + '" y1="' + PADT + '" x2="' + x + '" y2="' + sy(y0, y0, y1) + '"/><text x="' + x + '" y="' + (Hh - PADB + 11) + '" text-anchor="middle">' + t + '</text>'; });
    yticks.forEach(function (t) { var y = sy(t, y0, y1); s += '<line class="grid" x1="' + PADL + '" y1="' + y + '" x2="' + (W - PADR) + '" y2="' + y + '"/><text x="' + (PADL - 4) + '" y="' + (y + 3) + '" text-anchor="end">' + t + '</text>'; });
    s += '<text x="' + ((W + PADL) / 2) + '" y="' + (Hh - 1) + '" text-anchor="middle">' + xl + '</text>';
    return s;
  }
  function poly(pts, x0, x1, y0, y1, color) {
    return '<polyline fill="none" stroke="' + color + '" stroke-width="2" points="' + pts.map(function (p) { return sx(p[0], x0, x1).toFixed(1) + ',' + sy(p[1], y0, y1).toFixed(1); }).join(' ') + '"/>';
  }
  function titrationSVG(t) {
    var x0 = 0, x1 = 2, y0 = 0, y1 = 14;
    var s = '<svg viewBox="0 0 ' + W + ' ' + Hh + '">' + axes(x0, x1, y0, y1, t.xlabel, 'pH', [0, 0.5, 1, 1.5, 2], [0, 7, 14]);
    s += poly(t.data, x0, x1, y0, y1, '#6d5efc');
    s += '<line class="grid" x1="' + sx(1, x0, x1) + '" y1="' + PADT + '" x2="' + sx(1, x0, x1) + '" y2="' + sy(0, y0, y1) + '" stroke="#54b8ff" stroke-dasharray="3 3"/>';
    s += '<text x="' + sx(1, x0, x1) + '" y="' + (PADT + 8) + '" text-anchor="middle" fill="#54b8ff">eq. pt</text></svg>';
    return s;
  }
  function distSVG(d, m, curPh) {
    var x0 = 0, x1 = 14, y0 = 0, y1 = 1, names, cols;
    if (m === 'base') { names = [['B', d.B, '#34d399'], ['BH', d.BH, '#f783ac']]; }
    else { names = [['HA', d.HA, '#f783ac'], ['A⁻', d.A, '#34d399']]; }
    var s = '<svg viewBox="0 0 ' + W + ' ' + Hh + '">' + axes(x0, x1, y0, y1, 'pH', 'fraction', [0, 7, 14], [0, 0.5, 1]);
    var lx = PADL + 6;
    names.forEach(function (n, i) {
      var pts = d.ph.map(function (ph, j) { return [ph, n[1][j]]; });
      s += poly(pts, x0, x1, y0, y1, n[2]);
      s += '<rect x="' + (lx + i * 60) + '" y="' + (PADT + 2) + '" width="9" height="9" fill="' + n[2] + '"/><text class="lgd" x="' + (lx + 12 + i * 60) + '" y="' + (PADT + 10) + '">' + n[0] + '</text>';
    });
    if (curPh != null) s += '<line x1="' + sx(curPh, x0, x1) + '" y1="' + PADT + '" x2="' + sx(curPh, x0, x1) + '" y2="' + sy(0, y0, y1) + '" stroke="#ffce4a" stroke-dasharray="3 3"/>';
    return s + '</svg>';
  }

  function esc(s) { return String(s).replace(/[&<>"]/g, function (c) { return { '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;' }[c]; }); }
  function escSub(s) { return esc(s).replace(/(\d+)/g, '<sub>$1</sub>').replace(/\+/g, '⁺').replace(/-/g, '⁻'); }

  // ── share: encode the current mode + inputs into a URL (tool-utils) ──
  function b64(s) { return btoa(unescape(encodeURIComponent(s))); }
  function unb64(s) { try { return decodeURIComponent(escape(atob(s))); } catch (e) { return ''; } }
  function shareParams() {
    var ex = {};
    if (mode === 'acid') { ex.pka = $('aPka').value; ex.c = $('aConc').value; if ($('aName').value.trim()) ex.name = $('aName').value.trim(); }
    else if (mode === 'base') { ex.pkb = $('bPkb').value; ex.c = $('bConc').value; if ($('bName').value.trim()) ex.name = $('bName').value.trim(); }
    else if (mode === 'buffer') { ex.pka = $('fPka').value; ex.ca = $('fAcid').value; ex.cb = $('fBase').value; }
    else if (mode === 'ksp') { ex.ksp = $('kKsp').value; ex.a = $('kA').value; ex.b = $('kB').value; ex.common = $('kCommon').value; ex.side = $('kSide').value; if ($('kName').value.trim()) ex.name = $('kName').value.trim(); }
    else if (mode === 'custom') { ex.eq = b64($('cEq').value); ex.init = b64($('cInit').value); }
    return ex;
  }
  $('eqShareBtn').addEventListener('click', function () {
    if (typeof ToolUtils === 'undefined' || !ToolUtils.shareResult) return;
    ToolUtils.shareResult(mode, { paramName: 'm', encode: false, extraParams: shareParams(), copyToClipboard: true, showSupportPopup: true, toolName: 'Equilibrium & pH Calculator' });
  });

  // ── load a shared link: fill the inputs from the URL and auto-solve ──
  function loadFromUrl() {
    var q = new URLSearchParams(location.search), m = q.get('m');
    if (!m) return;
    var btn = document.querySelector('.eq-mode[data-mode="' + m + '"]');
    if (btn) btn.click();
    function set(id, v) { if (v != null && v !== '') $(id).value = v; }
    if (m === 'acid') { set('aPka', q.get('pka')); set('aConc', q.get('c')); set('aName', q.get('name')); }
    else if (m === 'base') { set('bPkb', q.get('pkb')); set('bConc', q.get('c')); set('bName', q.get('name')); }
    else if (m === 'buffer') { set('fPka', q.get('pka')); set('fAcid', q.get('ca')); set('fBase', q.get('cb')); }
    else if (m === 'ksp') { set('kKsp', q.get('ksp')); set('kA', q.get('a')); set('kB', q.get('b')); set('kCommon', q.get('common')); set('kSide', q.get('side')); set('kName', q.get('name')); }
    else if (m === 'custom') { if (q.get('eq')) $('cEq').value = unb64(q.get('eq')); if (q.get('init')) $('cInit').value = unb64(q.get('init')); }
    else return;
    $('eqSolve').click();
  }

  // FAQ accordion
  document.querySelectorAll('.cs-faq-q').forEach(function (b) { b.addEventListener('click', function () { var it = b.closest('.cs-faq-item'); if (it) it.classList.toggle('open'); }); });

  renderRef();
  loadFromUrl();
})();
</script>
</body>
</html>
