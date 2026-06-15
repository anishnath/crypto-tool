<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<jsp:include page="modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="Empirical &amp; Molecular Formula Calculator" />
    <jsp:param name="toolCategory" value="Chemistry" />
    <jsp:param name="toolDescription" value="Find the empirical formula from percent composition, the molecular formula from a molar mass, and the percent composition of any formula. Includes combustion analysis (CO2 + H2O to formula). Exact atomic weights via chempy." />
    <jsp:param name="toolUrl" value="empirical-formula-calculator.jsp" />
    <jsp:param name="toolKeywords" value="empirical formula calculator, molecular formula calculator, percent composition calculator, mass percent calculator, empirical to molecular formula, combustion analysis calculator, percent composition by mass, find empirical formula from percent composition, molecular formula from molar mass, formula from percent composition" />
    <jsp:param name="toolImage" value="empirical-formula-og.png" />
    <jsp:param name="breadcrumbCategoryUrl" value="chemistry/" />
    <jsp:param name="teaches" value="empirical formula, molecular formula, percent composition, mole ratios, combustion analysis, molar mass" />
    <jsp:param name="educationalLevel" value="High School, Undergraduate" />
    <jsp:param name="hasSteps" value="true" />
    <jsp:param name="howToSteps" value="Pick what you have|Choose Percent composition to a formula, a Formula to its percent composition, or Combustion analysis,Enter your data|Type the element percentages (or grams), a chemical formula, or the combustion masses of CO2 and H2O,Solve|The tool converts to moles, finds the whole-number mole ratio for the empirical formula, and scales to the molecular formula if you give a molar mass,Check the working|Every step is shown — moles, mole ratios and masses — so you can follow the method" />
    <jsp:param name="faq1q" value="How do you find the empirical formula from percent composition?" />
    <jsp:param name="faq1a" value="Assume a 100 gram sample so each percent becomes grams. Divide each element's mass by its atomic weight to get moles. Divide every mole value by the smallest one to get the mole ratio, then multiply to the nearest whole numbers. Those whole numbers are the subscripts of the empirical formula. For example C 40.0%, H 6.7%, O 53.3% gives CH2O." />
    <jsp:param name="faq2q" value="What is the difference between empirical and molecular formula?" />
    <jsp:param name="faq2a" value="The empirical formula is the simplest whole-number ratio of atoms, like CH2O. The molecular formula is the actual number of atoms in a molecule, like C6H12O6 for glucose, and is always a whole-number multiple of the empirical formula. To get it, divide the molar mass by the empirical-formula mass and multiply the subscripts by that factor." />
    <jsp:param name="faq3q" value="How do you calculate percent composition?" />
    <jsp:param name="faq3a" value="For each element, percent by mass = (number of atoms × atomic weight) ÷ molar mass × 100. For water H2O (molar mass 18.02 g/mol): H is 2 × 1.008 ÷ 18.02 = 11.2% and O is 16.00 ÷ 18.02 = 88.8%. The tool parses any formula and shows the molar mass and each element's mass percent." />
    <jsp:param name="faq4q" value="How does combustion analysis find a formula?" />
    <jsp:param name="faq4a" value="When a hydrocarbon (or CHO compound) burns, all carbon ends up in CO2 and all hydrogen in H2O. Moles of C equal moles of CO2; moles of H equal twice the moles of H2O. The mass of oxygen in the original sample is found by difference: sample mass minus the mass of C and H. Convert to moles, take the ratio, and you have the empirical formula." />
    <jsp:param name="faq5q" value="Why are my mole ratios not whole numbers?" />
    <jsp:param name="faq5a" value="After dividing by the smallest number of moles you often get values like 1.5, 1.33 or 1.25. Multiply every ratio by a small integer (2, 3 or 4) to clear the fraction — 1.5 becomes 3 when multiplied by 2, and 1.33 becomes 4 when multiplied by 3. This tool does that automatically and shows the multiplier it used." />
    <jsp:param name="faq6q" value="Is this empirical formula calculator free?" />
    <jsp:param name="faq6a" value="Yes. It is completely free, needs no signup, and uses exact IUPAC atomic weights through the open-source chempy library." />
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
    .fc-modes { display:inline-flex; flex-wrap:wrap; gap:2px; padding:3px; background:var(--cs-panel-bg-soft); border:1px solid var(--cs-line); border-radius:var(--cs-radius-pill); margin-bottom:1.1rem; }
    .fc-mode { border:none; background:transparent; color:var(--cs-muted); font:600 12.5px var(--cs-font-sans); cursor:pointer; padding:6px 14px; border-radius:var(--cs-radius-pill); white-space:nowrap; transition:color var(--cs-transition), background var(--cs-transition); }
    .fc-mode:hover:not(.active) { color:var(--cs-ink); }
    .fc-mode.active { background:var(--cs-panel-bg); color:var(--cs-accent); box-shadow:var(--cs-shadow-sm); }
    .fc-form { display:none; } .fc-form.active { display:block; }
    .fc-fields { display:flex; flex-wrap:wrap; gap:0.7rem 1rem; align-items:flex-end; }
    .fc-field { display:flex; flex-direction:column; gap:0.3rem; }
    .fc-field label { font:600 0.68rem var(--cs-font-sans); text-transform:uppercase; letter-spacing:0.05em; color:var(--cs-muted); }
    .fc-input, .fc-area, .fc-sel { padding:0.55rem 0.8rem; border:1.5px solid var(--cs-line-strong); border-radius:var(--cs-radius-sm); background:var(--cs-panel-bg-soft); color:var(--cs-ink); font:14px var(--cs-font-sans); transition:border-color var(--cs-transition), box-shadow var(--cs-transition); }
    .fc-input:focus, .fc-area:focus, .fc-sel:focus { outline:none; border-color:var(--cs-accent); background:var(--cs-panel-bg); box-shadow:var(--cs-ring); }
    .fc-input.num { width:8rem; text-align:center; }
    .fc-input.big { flex:1 1 240px; min-width:0; font:16px var(--cs-font-mono); }
    .fc-area { width:100%; min-height:96px; font-family:var(--cs-font-mono); font-size:14px; resize:vertical; }
    .fc-hint { font-size:0.78rem; color:var(--cs-muted); line-height:1.5; margin:0.6rem 0 0; }
    .fc-hint code { font:12px var(--cs-font-mono); background:var(--cs-panel-bg-soft); padding:1px 5px; border-radius:4px; color:var(--cs-ink-soft); }
    .fc-btn { display:inline-flex; align-items:center; gap:0.4rem; padding:0.6rem 1.25rem; border-radius:var(--cs-radius-pill); background:var(--cs-accent); color:#fff; border:1px solid var(--cs-accent); font:600 0.85rem var(--cs-font-sans); cursor:pointer; transition:background var(--cs-transition), transform 0.1s var(--cs-ease); }
    .fc-btn:hover { background:var(--cs-accent-hover); transform:translateY(-1px); } .fc-btn:disabled { opacity:0.6; cursor:wait; transform:none; }
    .fc-cta { margin-top:1rem; display:flex; gap:0.5rem; flex-wrap:wrap; }
    .fc-ex { background:none; border:1px solid var(--cs-line-strong); color:var(--cs-ink-soft); border-radius:var(--cs-radius-pill); padding:0.35rem 0.7rem; font:500 12px var(--cs-font-mono); cursor:pointer; }
    .fc-ex:hover { border-color:var(--cs-accent); color:var(--cs-accent); background:var(--cs-accent-softer); }
    .fc-chips { display:flex; flex-wrap:wrap; gap:0.4rem; margin-top:0.6rem; }

    .fc-card { background:var(--cs-panel-bg); border:1px solid var(--cs-line); border-radius:var(--cs-radius-lg); box-shadow:var(--cs-shadow-sm); padding:1.5rem; overflow:hidden; }
    .fc-card-head { display:flex; align-items:center; gap:0.5rem; margin:0 0 1rem; }
    .fc-card-head h2 { margin:0; font:600 0.72rem var(--cs-font-sans); text-transform:uppercase; letter-spacing:0.08em; color:var(--cs-muted); }
    .fc-share { margin-left:auto; border:1px solid var(--cs-line-strong); background:var(--cs-panel-bg); color:var(--cs-ink-soft); border-radius:var(--cs-radius-pill); padding:0.3rem 0.85rem; font:600 0.72rem var(--cs-font-sans); cursor:pointer; }
    .fc-share:hover { border-color:var(--cs-accent); color:var(--cs-accent); }
    .fc-big { font:800 2rem var(--cs-font-mono); color:var(--cs-accent); line-height:1.1; }
    .fc-big sub { font-size:0.66em; }
    .fc-sub { font-size:0.8rem; color:var(--cs-muted); margin-top:0.2rem; }
    .fc-stats { display:grid; grid-template-columns:repeat(auto-fit,minmax(130px,1fr)); gap:0.75rem; margin-top:1.1rem; }
    .fc-stat { padding:0.75rem 0.7rem; background:var(--cs-panel-bg-soft); border-radius:var(--cs-radius-sm); border-left:3px solid var(--cs-accent); text-align:center; }
    .fc-stat .k { display:block; font:600 0.62rem var(--cs-font-sans); text-transform:uppercase; letter-spacing:0.05em; color:var(--cs-muted); margin-bottom:0.3rem; }
    .fc-stat .v { font:700 1.15rem var(--cs-font-mono); color:var(--cs-ink); }
    table.fc-tbl { width:100%; border-collapse:collapse; margin-top:1rem; font-size:0.85rem; }
    table.fc-tbl th { text-align:left; padding:0.45rem 0.6rem; font:600 0.64rem var(--cs-font-sans); text-transform:uppercase; letter-spacing:0.04em; color:var(--cs-muted); border-bottom:1px solid var(--cs-line); }
    table.fc-tbl td { padding:0.45rem 0.6rem; border-bottom:1px dotted var(--cs-line); color:var(--cs-ink); }
    table.fc-tbl td.n { font-family:var(--cs-font-mono); }
    table.fc-tbl .bar { height:6px; border-radius:3px; background:var(--cs-accent); }
    .fc-err { padding:1rem 1.1rem; border-radius:var(--cs-radius); background:#fef7ed; border:1px solid #fdba74; color:#9a3412; font-size:0.9rem; }
    [data-theme="dark"] .fc-err { background:rgba(251,146,60,0.08); border-color:rgba(251,146,60,0.3); color:#fdba74; }
    .fc-spin { display:inline-block; width:13px; height:13px; border:2px solid rgba(255,255,255,0.45); border-top-color:#fff; border-radius:50%; animation:fc-spin 0.7s linear infinite; }
    @keyframes fc-spin { to { transform:rotate(360deg); } }

    .pt-seo { display:flex; flex-direction:column; gap:1rem; margin-top:1.25rem; }
    .pt-seo-card { background:var(--cs-panel-bg); border:1px solid var(--cs-line); border-radius:var(--cs-radius-lg); box-shadow:var(--cs-shadow-sm); padding:1.5rem 1.6rem; }
    .pt-seo-card h2 { font:400 1.4rem var(--cs-font-serif); color:var(--cs-ink); margin:0 0 0.6rem; }
    .pt-seo-card h3 { font:600 0.95rem var(--cs-font-sans); color:var(--cs-ink); margin:1rem 0 0.4rem; }
    .pt-seo-card p, .pt-seo-card li { color:var(--cs-ink-soft); font-size:0.93rem; line-height:1.7; }
    .pt-seo-card ol, .pt-seo-card ul { margin:0.4rem 0 0; padding-left:1.2rem; }
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
    <% request.setAttribute("activeService", "empirical"); %>
    <jsp:include page="/chemistry/partials/sidebar.jsp" />

    <section class="cs-workspace">

<div class="cs-title">
    <nav class="cs-crumbs" aria-label="Breadcrumb">
        <a href="<%=ctx%>/index.jsp">Home</a> /
        <a href="<%=ctx%>/chemistry/">Chemistry</a> /
        <span aria-current="page">Empirical &amp; Molecular Formula</span>
    </nav>
    <h1>Empirical &amp; Molecular Formula Calculator</h1>
</div>

<div class="ic-stack">

    <div class="ic-hero">
        <div class="fc-modes" id="fcModes">
            <button type="button" class="fc-mode active" data-mode="comp">% composition → formula</button>
            <button type="button" class="fc-mode" data-mode="formula">Formula → % composition</button>
            <button type="button" class="fc-mode" data-mode="combust">Combustion analysis</button>
        </div>

        <!-- % composition -> empirical/molecular -->
        <div class="fc-form active" data-form="comp">
            <div class="fc-field" style="width:100%;">
                <label for="cpRows">Elements — one per line, <code>element: value</code></label>
                <textarea class="fc-area" id="cpRows">C: 40.0
H: 6.71
O: 53.29</textarea>
            </div>
            <div class="fc-fields" style="margin-top:0.6rem;">
                <div class="fc-field"><label for="cpUnit">Values are</label>
                    <select class="fc-sel" id="cpUnit"><option value="pct">mass %</option><option value="g">grams</option></select></div>
                <div class="fc-field"><label for="cpMM">Molar mass (g/mol, optional)</label><input type="number" class="fc-input num" id="cpMM" step="0.01" placeholder="for molecular"></div>
            </div>
            <div class="fc-chips">
                <button type="button" class="fc-ex" data-cp="C: 40.0&#10;H: 6.71&#10;O: 53.29" data-mm="180.16">glucose (CH₂O / 180)</button>
                <button type="button" class="fc-ex" data-cp="Na: 32.4&#10;S: 22.6&#10;O: 45.0">sodium sulfate</button>
                <button type="button" class="fc-ex" data-cp="Fe: 69.94&#10;O: 30.06">iron oxide</button>
            </div>
            <p class="fc-hint">Assumes a 100&nbsp;g sample (percent = grams). Give the molar mass to also get the <strong>molecular</strong> formula.</p>
        </div>

        <!-- formula -> % composition -->
        <div class="fc-form" data-form="formula">
            <div class="fc-fields">
                <div class="fc-field" style="flex:1 1 260px;"><label for="fmFormula">Chemical formula</label>
                    <input type="text" class="fc-input big" id="fmFormula" placeholder="e.g. C6H12O6, CaCO3, Fe2(SO4)3" value="H2O"></div>
            </div>
            <div class="fc-chips">
                <button type="button" class="fc-ex" data-fm="C6H12O6">C₆H₁₂O₆</button>
                <button type="button" class="fc-ex" data-fm="H2SO4">H₂SO₄</button>
                <button type="button" class="fc-ex" data-fm="CaCO3">CaCO₃</button>
                <button type="button" class="fc-ex" data-fm="Fe2(SO4)3">Fe₂(SO₄)₃</button>
                <button type="button" class="fc-ex" data-fm="C8H10N4O2">caffeine</button>
            </div>
            <p class="fc-hint">Parentheses and hydrates supported. Returns molar mass and each element's <strong>mass percent</strong>.</p>
        </div>

        <!-- combustion analysis -->
        <div class="fc-form" data-form="combust">
            <div class="fc-fields">
                <div class="fc-field"><label for="cbSample">Sample mass (g)</label><input type="number" class="fc-input num" id="cbSample" step="0.0001" value="0.255"></div>
                <div class="fc-field"><label for="cbCO2">CO₂ produced (g)</label><input type="number" class="fc-input num" id="cbCO2" step="0.0001" value="0.561"></div>
                <div class="fc-field"><label for="cbH2O">H₂O produced (g)</label><input type="number" class="fc-input num" id="cbH2O" step="0.0001" value="0.306"></div>
                <div class="fc-field"><label for="cbMM">Molar mass (optional)</label><input type="number" class="fc-input num" id="cbMM" step="0.01" placeholder="for molecular"></div>
            </div>
            <p class="fc-hint">All C ends up in CO₂, all H in H₂O; remaining mass is taken as <strong>oxygen</strong> (CₓHᵧOᵤ). Moles C = mol CO₂, moles H = 2 × mol H₂O.</p>
        </div>

        <div class="fc-cta"><button type="button" class="fc-btn" id="fcSolve">&#8473; Calculate</button></div>
    </div>

    <div class="fc-card" id="fcResultCard" style="display:none;">
        <div class="fc-card-head"><span style="color:var(--cs-accent);">&#8473;</span><h2 id="fcResultTitle">Result</h2><button type="button" id="fcShareBtn" class="fc-share" style="display:none;">&#128279; Share</button></div>
        <div id="fcResultBody"></div>
    </div>

    <div class="cs-inline-ad">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <section class="pt-seo">
        <div class="pt-seo-card">
            <h2>From percent composition to a formula — the method</h2>
            <ol>
                <li><strong>Percent → grams.</strong> Assume a 100 g sample, so 40.0% C means 40.0 g C.</li>
                <li><strong>Grams → moles.</strong> Divide each mass by the element's atomic weight.</li>
                <li><strong>Moles → ratio.</strong> Divide every mole value by the smallest one.</li>
                <li><strong>Clear fractions.</strong> Multiply by a small integer until the ratios are whole numbers — those are the <strong>empirical</strong> subscripts.</li>
                <li><strong>Empirical → molecular.</strong> Divide the molar mass by the empirical-formula mass and multiply the subscripts by that factor.</li>
            </ol>
            <p>This tool runs every step on the server with the exact IUPAC atomic weights from <strong>chempy</strong>, and shows the moles, mole ratios and the multiplier it used so you can follow along.</p>
        </div>
        <div class="pt-seo-card">
            <h2 class="cs-faq-title" id="faqs" style="font-family:var(--cs-font-serif);">Frequently asked</h2>
            <div class="cs-faq" aria-label="Empirical formula FAQ">
                <div class="cs-faq-item"><button class="cs-faq-q" type="button">How do you find the empirical formula from percent composition?<svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                    <div class="cs-faq-a">Treat each percent as grams (100 g sample), divide by atomic weights to get moles, divide all by the smallest, then multiply to whole numbers. C 40.0%, H 6.7%, O 53.3% → CH₂O.</div></div>
                <div class="cs-faq-item"><button class="cs-faq-q" type="button">What's the difference between empirical and molecular formula?<svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                    <div class="cs-faq-a">Empirical is the simplest whole-number ratio (CH₂O); molecular is the real count (C₆H₁₂O₆ = glucose), always a whole multiple. Divide molar mass by empirical mass for the multiplier.</div></div>
                <div class="cs-faq-item"><button class="cs-faq-q" type="button">How do you calculate percent composition?<svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                    <div class="cs-faq-a">For each element, mass % = (atoms × atomic weight) ÷ molar mass × 100. Water: H = 11.2%, O = 88.8%.</div></div>
                <div class="cs-faq-item"><button class="cs-faq-q" type="button">How does combustion analysis work?<svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                    <div class="cs-faq-a">All carbon becomes CO₂ and all hydrogen becomes H₂O. moles C = mol CO₂, moles H = 2 × mol H₂O, and oxygen mass is the sample mass minus C and H. Convert to moles and take the ratio.</div></div>
                <div class="cs-faq-item"><button class="cs-faq-q" type="button">Is it free?<svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                    <div class="cs-faq-a">Yes — free, no signup, exact atomic weights via the open-source chempy library.</div></div>
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
  function $(id) { return document.getElementById(id); }
  var mode = 'comp';

  $('fcModes').addEventListener('click', function (e) {
    var b = e.target.closest('[data-mode]'); if (!b) return;
    mode = b.getAttribute('data-mode');
    document.querySelectorAll('.fc-mode').forEach(function (m) { m.classList.toggle('active', m === b); });
    document.querySelectorAll('.fc-form').forEach(function (f) { f.classList.toggle('active', f.getAttribute('data-form') === mode); });
  });

  // example chips
  document.addEventListener('click', function (e) {
    var c = e.target.closest('.fc-ex'); if (!c) return;
    if (c.hasAttribute('data-cp')) { $('cpRows').value = c.getAttribute('data-cp'); $('cpMM').value = c.getAttribute('data-mm') || ''; }
    if (c.hasAttribute('data-fm')) { $('fmFormula').value = c.getAttribute('data-fm'); }
  });

  function num(v) { var n = parseFloat(v); return isNaN(n) ? null : n; }
  function pretty(f) { return String(f).replace(/(\d+)/g, '<sub>$1</sub>'); }

  function payloadFor() {
    if (mode === 'comp') {
      var rows = {};
      $('cpRows').value.split('\n').forEach(function (line) { var m = line.split(':'); if (m.length === 2) { var el = m[0].trim(), v = parseFloat(m[1]); if (el && !isNaN(v)) rows[el] = v; } });
      return { mode:'comp', rows: rows, unit: $('cpUnit').value, mm: num($('cpMM').value) };
    }
    if (mode === 'formula') return { mode:'formula', formula: $('fmFormula').value.trim() };
    if (mode === 'combust') return { mode:'combust', sample: num($('cbSample').value), co2: num($('cbCO2').value), h2o: num($('cbH2O').value), mm: num($('cbMM').value) };
  }

  // ── Python (chempy exact atomic weights) ────────────────────────────
  function buildCode(p) {
    return [
'import json',
'from chempy import Substance',
'from chempy.util.periodic import symbols, relative_atomic_masses as MASS',
'AW = {symbols[i]: MASS[i] for i in range(len(symbols))}',
'P = json.loads(r"""' + JSON.stringify(p) + '""")',
'HILL = lambda subs: (["C"] if "C" in subs else []) + (["H"] if "H" in subs else []) + sorted(k for k in subs if k not in ("C","H"))',
'def fstr(subs):',
'    return "".join(el + (str(subs[el]) if subs[el] > 1 else "") for el in HILL(subs))',
'def emass(subs):',
'    return sum(subs[el]*AW[el] for el in subs)',
'def empirical(moles):',
'    items = {el:m for el,m in moles.items() if m > 1e-12}',
'    mn = min(items.values())',
'    ratios = {el: m/mn for el,m in items.items()}',
'    chosen = None; used = 1',
'    for mult in range(1, 9):',
'        sc = {el: r*mult for el,r in ratios.items()}',
'        if all(abs(v-round(v)) <= 0.10 for v in sc.values()) and all(round(v) >= 1 for v in sc.values()):',
'            chosen = {el:int(round(v)) for el,v in sc.items()}; used = mult; break',
'    if chosen is None:',
'        chosen = {el: max(1, int(round(r))) for el,r in ratios.items()}; used = 1',
'    return chosen, ratios, used',
'res = {}',
'try:',
'    m = P["mode"]',
'    if m == "formula":',
'        s = Substance.from_formula(P["formula"])',
'        comp = {k:v for k,v in s.composition.items() if k != 0}',
'        molar = s.mass',
'        rows = []',
'        for z, cnt in sorted(comp.items()):',
'            el = symbols[z-1]; mm = AW[el]; mass = cnt*mm',
'            rows.append({"el":el,"n":cnt,"aw":round(mm,4),"mass":round(mass,4),"pct":round(100*mass/molar,3)})',
'        rows.sort(key=lambda r: -r["pct"])',
'        res.update({"kind":"formula","formula":P["formula"],"molar":round(molar,4),"rows":rows})',
'    elif m == "comp":',
'        rows = P["rows"]',
'        moles = {}',
'        for el,v in rows.items():',
'            if el not in AW: raise ValueError("Unknown element: "+el)',
'            moles[el] = v/AW[el]',
'        subs, ratios, used = empirical(moles)',
'        em = emass(subs); out = {"kind":"comp","empirical":fstr(subs),"emass":round(em,4),"mult":used,',
'               "work":[{"el":el,"amt":round(rows[el],4),"mol":round(moles[el],5),"ratio":round(ratios[el],3)} for el in HILL(subs)]}',
'        if P.get("mm"):',
'            f = max(1, int(round(P["mm"]/em))); mol = {el:subs[el]*f for el in subs}',
'            out.update({"molecular":fstr(mol),"factor":f,"mm":P["mm"]})',
'        res.update(out)',
'    elif m == "combust":',
'        co2=P["co2"]; h2o=P["h2o"]; samp=P["sample"]',
'        molC = co2/44.009; molH = 2*h2o/18.015',
'        massC = molC*12.011; massH = molH*1.008; massO = samp - massC - massH',
'        moles = {"C":molC, "H":molH}',
'        if massO > 1e-4: moles["O"] = massO/15.999',
'        subs, ratios, used = empirical(moles)',
'        em = emass(subs); out = {"kind":"combust","empirical":fstr(subs),"emass":round(em,4),"mult":used,',
'               "massC":round(massC,4),"massH":round(massH,4),"massO":round(max(massO,0),4),',
'               "pctC":round(100*massC/samp,2),"pctH":round(100*massH/samp,2),"pctO":round(100*max(massO,0)/samp,2),',
'               "work":[{"el":el,"amt":None,"mol":round(moles[el],5),"ratio":round(ratios[el],3)} for el in HILL(subs)]}',
'        if P.get("mm"):',
'            f = max(1, int(round(P["mm"]/em))); mol = {el:subs[el]*f for el in subs}',
'            out.update({"molecular":fstr(mol),"factor":f,"mm":P["mm"]})',
'        res.update(out)',
'    res["ok"] = True',
'except Exception as e:',
'    res = {"ok":False,"error":type(e).__name__+": "+str(e)}',
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

  var card = $('fcResultCard'), bodyEl = $('fcResultBody'), btn = $('fcSolve');
  btn.addEventListener('click', function () {
    var p = payloadFor();
    card.style.display = ''; btn.disabled = true; var old = btn.innerHTML; btn.innerHTML = '<span class="fc-spin"></span> Calculating…';
    bodyEl.innerHTML = '<p class="fc-hint">Computing with chempy…</p>';
    run(p).then(function (res) {
      if (!res.ok) { bodyEl.innerHTML = '<div class="fc-err"><strong>Could not calculate.</strong> ' + esc(res.error || '') + '</div>'; return; }
      render(p, res);
    }).catch(function (e) { bodyEl.innerHTML = '<div class="fc-err"><strong>Backend error.</strong> ' + esc(e.message || e) + '</div>'; })
      .then(function () { btn.disabled = false; btn.innerHTML = old; });
  });

  function stat(k, v) { return '<div class="fc-stat"><span class="k">' + k + '</span><span class="v">' + v + '</span></div>'; }

  function render(p, res) {
    $('fcShareBtn').style.display = '';
    var h = '';
    if (res.kind === 'formula') {
      $('fcResultTitle').textContent = res.formula;
      h += '<div class="fc-stats">' + stat('Molar mass', res.molar + ' g/mol') + stat('Formula', '<span class="fc-big" style="font-size:1.3rem">' + pretty(res.formula) + '</span>') + '</div>';
      h += '<table class="fc-tbl"><thead><tr><th>Element</th><th>Atoms</th><th>Atomic wt</th><th>Mass</th><th>Mass %</th><th></th></tr></thead><tbody>';
      h += res.rows.map(function (r) { return '<tr><td><strong>' + r.el + '</strong></td><td class="n">' + r.n + '</td><td class="n">' + r.aw + '</td><td class="n">' + r.mass + '</td><td class="n">' + r.pct + '%</td><td style="width:120px;"><div class="bar" style="width:' + Math.min(100, r.pct) + '%"></div></td></tr>'; }).join('');
      h += '</tbody></table>';
    } else {
      $('fcResultTitle').textContent = res.molecular ? res.molecular : res.empirical;
      h += '<div class="fc-big">' + pretty(res.empirical) + '</div><div class="fc-sub">empirical formula · ' + res.emass + ' g/mol' + (res.mult > 1 ? ' · ratios ×' + res.mult : '') + '</div>';
      if (res.molecular) h += '<div class="fc-big" style="margin-top:0.8rem;">' + pretty(res.molecular) + '</div><div class="fc-sub">molecular formula · molar mass / empirical mass ≈ ' + res.factor + '</div>';
      if (res.kind === 'combust') h += '<div class="fc-stats">' + stat('mass C', res.massC + ' g') + stat('mass H', res.massH + ' g') + stat('mass O', res.massO + ' g') + stat('% C / H / O', res.pctC + ' / ' + res.pctH + ' / ' + res.pctO) + '</div>';
      h += '<table class="fc-tbl"><thead><tr><th>Element</th>' + (res.kind === 'comp' ? '<th>Amount</th>' : '') + '<th>Moles</th><th>÷ smallest</th></tr></thead><tbody>';
      h += res.work.map(function (w) { return '<tr><td><strong>' + w.el + '</strong></td>' + (res.kind === 'comp' ? '<td class="n">' + w.amt + '</td>' : '') + '<td class="n">' + w.mol + '</td><td class="n">' + w.ratio + '</td></tr>'; }).join('');
      h += '</tbody></table>';
    }
    bodyEl.innerHTML = h;
  }

  // ── share (tool-utils) ──────────────────────────────────────────────
  function b64(s) { return btoa(unescape(encodeURIComponent(s))); }
  function unb64(s) { try { return decodeURIComponent(escape(atob(s))); } catch (e) { return ''; } }
  function shareParams() {
    if (mode === 'comp') { var ex = { rows: b64($('cpRows').value), unit: $('cpUnit').value }; if ($('cpMM').value) ex.mm = $('cpMM').value; return ex; }
    if (mode === 'formula') return { f: $('fmFormula').value.trim() };
    return { s: $('cbSample').value, co2: $('cbCO2').value, h2o: $('cbH2O').value, mm: $('cbMM').value };
  }
  $('fcShareBtn').addEventListener('click', function () {
    if (typeof ToolUtils === 'undefined' || !ToolUtils.shareResult) return;
    ToolUtils.shareResult(mode, { paramName: 'm', encode: false, extraParams: shareParams(), copyToClipboard: true, showSupportPopup: true, toolName: 'Empirical Formula Calculator' });
  });
  function loadFromUrl() {
    var q = new URLSearchParams(location.search), m = q.get('m'); if (!m) return;
    var b = document.querySelector('.fc-mode[data-mode="' + m + '"]'); if (b) b.click();
    function set(id, v) { if (v != null && v !== '') $(id).value = v; }
    if (m === 'comp') { if (q.get('rows')) $('cpRows').value = unb64(q.get('rows')); set('cpUnit', q.get('unit')); set('cpMM', q.get('mm')); }
    else if (m === 'formula') { set('fmFormula', q.get('f')); }
    else if (m === 'combust') { set('cbSample', q.get('s')); set('cbCO2', q.get('co2')); set('cbH2O', q.get('h2o')); set('cbMM', q.get('mm')); }
    else return;
    $('fcSolve').click();
  }

  function esc(s) { return String(s).replace(/[&<>"]/g, function (c) { return { '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;' }[c]; }); }
  document.querySelectorAll('.cs-faq-q').forEach(function (b) { b.addEventListener('click', function () { var it = b.closest('.cs-faq-item'); if (it) it.classList.toggle('open'); }); });
  loadFromUrl();
})();
</script>
</body>
</html>
