<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<jsp:include page="modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="Limiting Reagent &amp; Percent Yield Calculator" />
    <jsp:param name="toolCategory" value="Chemistry" />
    <jsp:param name="toolDescription" value="Enter a reaction and the amounts of each reactant to find the limiting reagent, the theoretical yield of any product (in moles and grams), the excess left over, and the percent yield. The equation is balanced and molar masses computed with chempy." />
    <jsp:param name="toolUrl" value="limiting-reagent-calculator.jsp" />
    <jsp:param name="toolKeywords" value="limiting reagent calculator, limiting reactant calculator, percent yield calculator, theoretical yield calculator, excess reagent, stoichiometry calculator, moles to grams reaction, how much product is formed, limiting reagent and percent yield" />
    <jsp:param name="toolImage" value="limiting-reagent-og.png" />
    <jsp:param name="breadcrumbCategoryUrl" value="chemistry/" />
    <jsp:param name="teaches" value="limiting reagent, theoretical yield, percent yield, excess reactant, stoichiometry, mole ratios" />
    <jsp:param name="educationalLevel" value="High School, Undergraduate" />
    <jsp:param name="hasSteps" value="true" />
    <jsp:param name="howToSteps" value="Write the reaction|Type the equation, e.g. N2 + H2 = NH3 (it is balanced automatically),Enter the amounts|Give how much of each reactant you have, in grams or moles,Calculate|The tool converts to moles, divides by the coefficients, and the smallest result is the limiting reagent — it then gives the theoretical yield and the excess left over,Add an actual yield|Optionally enter the actual mass or moles obtained to get the percent yield" />
    <jsp:param name="faq1q" value="How do you find the limiting reagent?" />
    <jsp:param name="faq1a" value="Convert the amount of each reactant to moles, then divide each by its coefficient in the balanced equation. The reactant with the smallest result runs out first and is the limiting reagent — it determines how much product can form. The others are in excess." />
    <jsp:param name="faq2q" value="How do you calculate theoretical yield?" />
    <jsp:param name="faq2a" value="From the limiting reagent, use the mole ratio of the balanced equation to find the moles of product, then multiply by the product's molar mass to get the theoretical yield in grams. For example with H2 limiting in N2 + 3H2 → 2NH3, moles of NH3 = (moles H2 ÷ 3) × 2." />
    <jsp:param name="faq3q" value="What is percent yield?" />
    <jsp:param name="faq3a" value="Percent yield = (actual yield ÷ theoretical yield) × 100. The theoretical yield is the maximum amount of product the limiting reagent could make; the actual yield is what you really obtained. A percent yield below 100% is normal because of side reactions, losses, and incomplete reactions." />
    <jsp:param name="faq4q" value="What is the difference between limiting and excess reagent?" />
    <jsp:param name="faq4a" value="The limiting reagent is completely used up and caps the amount of product. An excess reagent is left over after the reaction finishes. This tool reports how much of each excess reactant remains, in both moles and grams." />
    <jsp:param name="faq5q" value="Can I enter amounts in moles instead of grams?" />
    <jsp:param name="faq5a" value="Yes. Write each amount with its unit, for example N2: 0.5 mol or H2: 3 g. Grams are converted to moles using exact molar masses; moles are used directly." />
    <jsp:param name="faq6q" value="Is this limiting reagent calculator free?" />
    <jsp:param name="faq6a" value="Yes. It is completely free, needs no signup, and balances the equation and computes molar masses with the open-source chempy library." />
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
    .lr-eq-label { font:600 0.78rem var(--cs-font-sans); text-transform:uppercase; letter-spacing:0.06em; color:var(--cs-muted); margin:0 0 0.45rem; }
    .lr-eq-row { display:flex; gap:0.5rem; align-items:stretch; flex-wrap:wrap; }
    .lr-eq-input { flex:1 1 280px; min-width:0; min-height:48px; padding:0.7rem 0.95rem; border:1.5px solid var(--cs-line-strong); border-radius:var(--cs-radius); background:var(--cs-panel-bg-soft); color:var(--cs-ink); font:16px var(--cs-font-mono); transition:border-color var(--cs-transition), box-shadow var(--cs-transition); }
    .lr-eq-input:focus { outline:none; border-color:var(--cs-accent); background:var(--cs-panel-bg); box-shadow:var(--cs-ring); }
    .lr-fields { display:flex; flex-wrap:wrap; gap:0.7rem 1rem; align-items:flex-end; margin-top:0.85rem; }
    .lr-field { display:flex; flex-direction:column; gap:0.3rem; }
    .lr-field label { font:600 0.68rem var(--cs-font-sans); text-transform:uppercase; letter-spacing:0.05em; color:var(--cs-muted); }
    .lr-input, .lr-area, .lr-sel { padding:0.55rem 0.8rem; border:1.5px solid var(--cs-line-strong); border-radius:var(--cs-radius-sm); background:var(--cs-panel-bg-soft); color:var(--cs-ink); font:14px var(--cs-font-sans); transition:border-color var(--cs-transition), box-shadow var(--cs-transition); }
    .lr-input:focus, .lr-area:focus, .lr-sel:focus { outline:none; border-color:var(--cs-accent); background:var(--cs-panel-bg); box-shadow:var(--cs-ring); }
    .lr-input.num { width:7rem; text-align:center; }
    .lr-area { width:100%; min-height:80px; font-family:var(--cs-font-mono); font-size:14px; resize:vertical; }
    .lr-hint { font-size:0.78rem; color:var(--cs-muted); line-height:1.5; margin:0.6rem 0 0; }
    .lr-hint code { font:12px var(--cs-font-mono); background:var(--cs-panel-bg-soft); padding:1px 5px; border-radius:4px; color:var(--cs-ink-soft); }
    .lr-btn { display:inline-flex; align-items:center; gap:0.4rem; padding:0.6rem 1.25rem; border-radius:var(--cs-radius-pill); background:var(--cs-accent); color:#fff; border:1px solid var(--cs-accent); font:600 0.85rem var(--cs-font-sans); cursor:pointer; transition:background var(--cs-transition), transform 0.1s var(--cs-ease); }
    .lr-btn:hover { background:var(--cs-accent-hover); transform:translateY(-1px); } .lr-btn:disabled { opacity:0.6; cursor:wait; transform:none; }
    .lr-cta { margin-top:1rem; }
    .lr-ex { background:none; border:1px solid var(--cs-line-strong); color:var(--cs-ink-soft); border-radius:var(--cs-radius-pill); padding:0.35rem 0.7rem; font:500 12px var(--cs-font-mono); cursor:pointer; }
    .lr-ex:hover { border-color:var(--cs-accent); color:var(--cs-accent); background:var(--cs-accent-softer); }
    .lr-chips { display:flex; flex-wrap:wrap; gap:0.4rem; margin-top:0.85rem; }
    .lr-preview { margin-top:0.55rem; min-height:1.5em; font:1.25rem var(--cs-font-serif); color:var(--cs-ink); }
    .lr-preview .op { color:var(--cs-accent); margin:0 0.3rem; }

    .lr-card { background:var(--cs-panel-bg); border:1px solid var(--cs-line); border-radius:var(--cs-radius-lg); box-shadow:var(--cs-shadow-sm); padding:1.5rem; overflow:hidden; }
    .lr-card-head { display:flex; align-items:center; gap:0.5rem; margin:0 0 1rem; }
    .lr-card-head h2 { margin:0; font:600 0.72rem var(--cs-font-sans); text-transform:uppercase; letter-spacing:0.08em; color:var(--cs-muted); }
    .lr-share { margin-left:auto; border:1px solid var(--cs-line-strong); background:var(--cs-panel-bg); color:var(--cs-ink-soft); border-radius:var(--cs-radius-pill); padding:0.3rem 0.85rem; font:600 0.72rem var(--cs-font-sans); cursor:pointer; }
    .lr-share:hover { border-color:var(--cs-accent); color:var(--cs-accent); }
    .lr-eqn { font:1.4rem var(--cs-font-serif); color:var(--cs-ink); text-align:center; padding:0.4rem 0; }
    .lr-eqn .op { color:var(--cs-accent); margin:0 0.35rem; } .lr-eqn .coef { color:var(--cs-muted); }
    .lr-verdict { margin-top:1rem; padding:0.8rem 1rem; border-radius:var(--cs-radius); background:var(--cs-accent-softer); border:1px solid var(--cs-accent-ring); border-left:3px solid var(--cs-accent); font:0.92rem var(--cs-font-sans); color:var(--cs-ink); }
    .lr-verdict b { color:var(--cs-accent); }
    .lr-stats { display:grid; grid-template-columns:repeat(auto-fit,minmax(130px,1fr)); gap:0.75rem; margin-top:1rem; }
    .lr-stat { padding:0.75rem 0.7rem; background:var(--cs-panel-bg-soft); border-radius:var(--cs-radius-sm); border-left:3px solid var(--cs-accent); text-align:center; }
    .lr-stat .k { display:block; font:600 0.62rem var(--cs-font-sans); text-transform:uppercase; letter-spacing:0.05em; color:var(--cs-muted); margin-bottom:0.3rem; }
    .lr-stat .v { font:700 1.2rem var(--cs-font-mono); color:var(--cs-ink); }
    table.lr-tbl { width:100%; border-collapse:collapse; margin-top:1rem; font-size:0.85rem; }
    table.lr-tbl th { text-align:left; padding:0.45rem 0.6rem; font:600 0.64rem var(--cs-font-sans); text-transform:uppercase; letter-spacing:0.04em; color:var(--cs-muted); border-bottom:1px solid var(--cs-line); }
    table.lr-tbl td { padding:0.45rem 0.6rem; border-bottom:1px dotted var(--cs-line); color:var(--cs-ink); }
    table.lr-tbl td.n { font-family:var(--cs-font-mono); }
    table.lr-tbl tr.lim td { background:var(--cs-accent-softer); }
    .lr-badge { display:inline-block; font:600 0.6rem var(--cs-font-sans); text-transform:uppercase; letter-spacing:0.05em; color:#fff; background:var(--cs-accent); border-radius:var(--cs-radius-pill); padding:1px 7px; }
    .lr-err { padding:1rem 1.1rem; border-radius:var(--cs-radius); background:#fef7ed; border:1px solid #fdba74; color:#9a3412; font-size:0.9rem; }
    [data-theme="dark"] .lr-err { background:rgba(251,146,60,0.08); border-color:rgba(251,146,60,0.3); color:#fdba74; }
    .lr-spin { display:inline-block; width:13px; height:13px; border:2px solid rgba(255,255,255,0.45); border-top-color:#fff; border-radius:50%; animation:lr-spin 0.7s linear infinite; }
    @keyframes lr-spin { to { transform:rotate(360deg); } }

    .pt-seo { display:flex; flex-direction:column; gap:1rem; margin-top:1.25rem; }
    .pt-seo-card { background:var(--cs-panel-bg); border:1px solid var(--cs-line); border-radius:var(--cs-radius-lg); box-shadow:var(--cs-shadow-sm); padding:1.5rem 1.6rem; }
    .pt-seo-card h2 { font:400 1.4rem var(--cs-font-serif); color:var(--cs-ink); margin:0 0 0.6rem; }
    .pt-seo-card p, .pt-seo-card li { color:var(--cs-ink-soft); font-size:0.93rem; line-height:1.7; }
    .pt-seo-card ol { margin:0.4rem 0 0; padding-left:1.2rem; }
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
    <% request.setAttribute("activeService", "limiting"); %>
    <jsp:include page="/chemistry/partials/sidebar.jsp" />

    <section class="cs-workspace">

<div class="cs-title">
    <nav class="cs-crumbs" aria-label="Breadcrumb">
        <a href="<%=ctx%>/index.jsp">Home</a> /
        <a href="<%=ctx%>/chemistry/">Chemistry</a> /
        <span aria-current="page">Limiting Reagent &amp; Yield</span>
    </nav>
    <h1>Limiting Reagent &amp; Percent Yield Calculator</h1>
</div>

<div class="ic-stack">

    <div class="ic-hero">
        <p class="lr-eq-label">Reaction</p>
        <div class="lr-eq-row">
            <input type="text" class="lr-eq-input" id="lrEq" spellcheck="false" autocomplete="off" placeholder="e.g. N2 + H2 = NH3" value="N2 + H2 = NH3">
        </div>
        <div class="lr-preview" id="lrPreview"></div>

        <div class="lr-field" style="width:100%;margin-top:0.85rem;">
            <label for="lrAmt">Amounts of reactants — one per line, <code>species: value g</code> or <code>mol</code></label>
            <textarea class="lr-area" id="lrAmt">N2: 14 g
H2: 3 g</textarea>
        </div>

        <div class="lr-fields">
            <div class="lr-field"><label for="lrTarget">Product to track (optional)</label><input type="text" class="lr-input" id="lrTarget" placeholder="default: first product" style="width:11rem;"></div>
            <div class="lr-field"><label for="lrActual">Actual yield (optional)</label>
                <div style="display:flex;gap:0.3rem;">
                    <input type="number" class="lr-input num" id="lrActual" step="0.0001" placeholder="for % yield" style="width:6.5rem;">
                    <select class="lr-sel" id="lrActualUnit"><option value="g">g</option><option value="mol">mol</option></select>
                </div></div>
        </div>

        <div class="lr-chips">
            <button type="button" class="lr-ex" data-eq="N2 + H2 = NH3" data-amt="N2: 14 g&#10;H2: 3 g">Haber (NH₃)</button>
            <button type="button" class="lr-ex" data-eq="C3H8 + O2 = CO2 + H2O" data-amt="C3H8: 10 g&#10;O2: 10 g">propane combustion</button>
            <button type="button" class="lr-ex" data-eq="Fe2O3 + Al = Fe + Al2O3" data-amt="Fe2O3: 50 g&#10;Al: 25 g">thermite</button>
            <button type="button" class="lr-ex" data-eq="AgNO3 + NaCl = AgCl + NaNO3" data-amt="AgNO3: 0.1 mol&#10;NaCl: 0.05 mol">precipitation</button>
        </div>

        <div class="lr-cta"><button type="button" class="lr-btn" id="lrSolve">&#9878; Find limiting reagent</button></div>
    </div>

    <div class="lr-card" id="lrResultCard" style="display:none;">
        <div class="lr-card-head"><span style="color:var(--cs-accent);">&#9878;</span><h2>Result</h2><button type="button" id="lrShareBtn" class="lr-share" style="display:none;">&#128279; Share</button></div>
        <div id="lrResultBody"></div>
    </div>

    <div class="cs-inline-ad">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <section class="pt-seo">
        <div class="pt-seo-card">
            <h2>Finding the limiting reagent — the method</h2>
            <ol>
                <li><strong>Balance</strong> the equation to get the mole ratios.</li>
                <li><strong>Convert each reactant to moles</strong> (grams ÷ molar mass, or use the moles directly).</li>
                <li><strong>Divide each by its coefficient.</strong> The smallest result is the <strong>limiting reagent</strong> — it runs out first.</li>
                <li><strong>Theoretical yield:</strong> use the limiting reagent's moles and the mole ratio to find moles of product, then × molar mass for grams.</li>
                <li><strong>Percent yield:</strong> (actual ÷ theoretical) × 100. Whatever isn't the limiting reagent is left over in <strong>excess</strong>.</li>
            </ol>
            <p>This tool balances with <strong>chempy</strong> and uses exact molar masses, then shows the limiting reagent, the excess left over, the theoretical yield, and the percent yield.</p>
        </div>
        <div class="pt-seo-card">
            <h2 class="cs-faq-title" id="faqs" style="font-family:var(--cs-font-serif);">Frequently asked</h2>
            <div class="cs-faq" aria-label="Limiting reagent FAQ">
                <div class="cs-faq-item"><button class="cs-faq-q" type="button">How do you find the limiting reagent?<svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                    <div class="cs-faq-a">Convert each reactant to moles, divide by its coefficient in the balanced equation, and the smallest value is the limiting reagent — it caps the product. The rest are in excess.</div></div>
                <div class="cs-faq-item"><button class="cs-faq-q" type="button">How do you calculate theoretical yield?<svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                    <div class="cs-faq-a">From the limiting reagent's moles, apply the mole ratio to get moles of product, then multiply by the product's molar mass for grams.</div></div>
                <div class="cs-faq-item"><button class="cs-faq-q" type="button">What is percent yield?<svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                    <div class="cs-faq-a">Percent yield = (actual yield ÷ theoretical yield) × 100. Below 100% is normal due to losses and side reactions.</div></div>
                <div class="cs-faq-item"><button class="cs-faq-q" type="button">Can I enter moles instead of grams?<svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                    <div class="cs-faq-a">Yes — write the unit, e.g. <code>N2: 0.5 mol</code> or <code>H2: 3 g</code>.</div></div>
                <div class="cs-faq-item"><button class="cs-faq-q" type="button">Is it free?<svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                    <div class="cs-faq-a">Yes — free, no signup, balanced and computed with the open-source chempy library.</div></div>
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

  function cleanSp(t) { return t.trim().replace(/\s+/g, '').replace(/^\d+(?=[A-Za-z(])/, ''); }
  function parseEquation(raw) {
    var s = String(raw).replace(/→|⟶|->|=>/g, '=').trim();
    if (s.indexOf('=') === -1) return null;
    var parts = s.split('='); if (parts.length !== 2) return null;
    function side(t) { return t.split(/\s+\+\s+/).map(cleanSp).filter(Boolean); }
    var reac = side(parts[0]), prod = side(parts[1]);
    return (reac.length && prod.length) ? { reac:reac, prod:prod } : null;
  }
  function pretty(sp) { return String(sp).replace(/(\d+)/g, '<sub>$1</sub>'); }

  var elEq = $('lrEq'), elPrev = $('lrPreview');
  function renderPreview() {
    var p = parseEquation(elEq.value);
    elPrev.innerHTML = p ? (p.reac.map(pretty).join(' <span class="op">+</span> ') + ' <span class="op">→</span> ' + p.prod.map(pretty).join(' <span class="op">+</span> ')) : '';
  }
  elEq.addEventListener('input', renderPreview);

  document.addEventListener('click', function (e) {
    var c = e.target.closest('.lr-ex'); if (!c) return;
    elEq.value = c.getAttribute('data-eq'); $('lrAmt').value = c.getAttribute('data-amt'); $('lrTarget').value = ''; $('lrActual').value = '';
    renderPreview();
  });

  function parseAmounts() {
    var out = {};
    $('lrAmt').value.split('\n').forEach(function (line) {
      var i = line.indexOf(':'); if (i < 0) return;
      var sp = cleanSp(line.slice(0, i)); var rest = line.slice(i + 1).trim();
      var m = rest.match(/-?\d+(\.\d+)?/); if (!sp || !m) return;
      out[sp] = { val: parseFloat(m[0]), unit: /mol/i.test(rest) ? 'mol' : 'g' };
    });
    return out;
  }
  function payloadFor() {
    var p = parseEquation(elEq.value) || { reac:[], prod:[] };
    var pay = { reac:p.reac, prod:p.prod, amounts: parseAmounts(), target: $('lrTarget').value.trim() };
    var av = parseFloat($('lrActual').value);
    if (!isNaN(av)) pay.actual = { val: av, unit: $('lrActualUnit').value };
    return pay;
  }

  // ── Python (chempy: balance + molar masses) — validated locally ─────
  function buildCode(p) {
    return [
'import json',
'from chempy import balance_stoichiometry, Substance',
'P = json.loads(r"""' + JSON.stringify(p) + '""")',
'reac=P["reac"]; prod=P["prod"]; amounts=P["amounts"]',
'target=P.get("target") or (prod[0] if prod else None); actual=P.get("actual")',
'res={}',
'try:',
'    if not reac or not prod: raise ValueError("Write a reaction with = (reactants = products)")',
'    r,p=balance_stoichiometry(set(reac), set(prod))',
'    rl=[{"sp":k,"n":int(r[k])} for k in r if int(r[k])!=0]',
'    pl=[{"sp":k,"n":int(p[k])} for k in p if int(p[k])!=0]',
'    molar={sp: Substance.from_formula(sp).mass for sp in set(list(r)+list(p))}',
'    rcoef={x["sp"]:x["n"] for x in rl}; pcoef={x["sp"]:x["n"] for x in pl}',
'    extents={}; rows=[]',
'    for sp in [x["sp"] for x in rl]:',
'        coef=rcoef[sp]; a=amounts.get(sp)',
'        if not a:',
'            rows.append({"sp":sp,"coef":coef,"given":None,"molar":round(molar[sp],3)}); continue',
'        if a["val"]<=0: raise ValueError("Amount of " + sp + " must be greater than zero")',
'        mol = a["val"]/molar[sp] if a["unit"]=="g" else a["val"]',
'        ext = mol/coef; extents[sp]=ext',
'        rows.append({"sp":sp,"coef":coef,"given":a["val"],"unit":a["unit"],"mol":round(mol,5),"ext":round(ext,5),"molar":round(molar[sp],3)})',
'    if not extents: raise ValueError("Enter at least one reactant amount")',
'    lim=min(extents, key=extents.get); xi=extents[lim]',
'    tcoef=pcoef.get(target) or rcoef.get(target)',
'    if not tcoef: raise ValueError("Product \'" + str(target) + "\' is not in the reaction")',
'    th_mol=xi*tcoef; th_mass=th_mol*molar[target]',
'    for row in rows:',
'        if row.get("mol") is not None:',
'            lm = row["mol"] - xi*row["coef"]',
'            row["used"]=round(xi*row["coef"],5); row["left_mol"]=round(max(0.0, lm),5); row["left_g"]=round(max(0.0, lm)*molar[row["sp"]],4)',
'            row["limiting"]=(row["sp"]==lim)',
'    prod_yield=[{"sp":x["sp"],"mol":round(xi*x["n"],5),"g":round(xi*x["n"]*molar[x["sp"]],4)} for x in pl]',
'    out={"ok":True,"reactants":rl,"products":pl,"limiting":lim,"target":target,',
'         "th_mol":round(th_mol,5),"th_mass":round(th_mass,4),"molar_target":round(molar[target],3),"rows":rows,"prod_yield":prod_yield}',
'    if actual:',
'        if actual["val"]<0: raise ValueError("Actual yield cannot be negative")',
'        am=actual["val"]/molar[target] if actual["unit"]=="g" else actual["val"]',
'        out["actual_mol"]=round(am,5); out["pct_yield"]=(round(100*am/th_mol,2) if th_mol else None)',
'    res=out',
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

  var card = $('lrResultCard'), bodyEl = $('lrResultBody'), btn = $('lrSolve');
  btn.addEventListener('click', function () {
    var p = payloadFor();
    card.style.display = ''; btn.disabled = true; var old = btn.innerHTML; btn.innerHTML = '<span class="lr-spin"></span> Solving…';
    bodyEl.innerHTML = '<p class="lr-hint">Balancing &amp; computing with chempy…</p>';
    run(p).then(function (res) {
      if (!res.ok) { bodyEl.innerHTML = '<div class="lr-err"><strong>Could not solve.</strong> ' + esc(res.error || '') + '</div>'; return; }
      render(res);
    }).catch(function (e) { bodyEl.innerHTML = '<div class="lr-err"><strong>Backend error.</strong> ' + esc(e.message || e) + '</div>'; })
      .then(function () { btn.disabled = false; btn.innerHTML = old; });
  });

  function side(arr) { return arr.map(function (x) { return '<span class="coef">' + (x.n > 1 ? x.n + ' ' : '') + '</span>' + pretty(x.sp); }).join('<span class="op">+</span>'); }
  function stat(k, v) { return '<div class="lr-stat"><span class="k">' + k + '</span><span class="v">' + v + '</span></div>'; }

  function render(res) {
    $('lrShareBtn').style.display = '';
    var h = '<div class="lr-eqn">' + side(res.reactants) + ' <span class="op">→</span> ' + side(res.products) + '</div>';
    h += '<div class="lr-verdict">Limiting reagent: <b>' + pretty(res.limiting) + '</b> — it has the smallest <em>moles ÷ coefficient</em> ratio, so it runs out first and sets the maximum yield.</div>';

    h += '<div class="lr-stats">' + stat('Theoretical yield of ' + pretty(res.target), res.th_mass + ' g') + stat('moles of ' + pretty(res.target), res.th_mol + ' mol') + stat('molar mass ' + pretty(res.target), res.molar_target + ' g/mol');
    if (res.pct_yield != null) h += stat('Percent yield', res.pct_yield + '%');
    h += '</div>';
    if (res.pct_yield != null && res.pct_yield > 100)
      h += '<p class="lr-hint" style="color:#9a3412;">⚠ Percent yield above 100% is physically impossible — re-check the actual yield, the molar mass, or whether the product was fully dried/pure.</p>';

    // ── how the limiting reagent was decided ──
    h += '<p class="lr-eq-label" style="margin-top:1.2rem;">Limiting reagent — the decision</p>';
    h += '<table class="lr-tbl"><thead><tr><th>Reactant</th><th>Coef</th><th>Amount</th><th>Moles</th><th>mol ÷ coef</th><th>Excess left</th><th></th></tr></thead><tbody>';
    h += res.rows.map(function (r) {
      if (r.given == null) return '<tr><td><strong>' + pretty(r.sp) + '</strong></td><td class="n">' + r.coef + '</td><td colspan="4" style="color:var(--cs-muted)">no amount given — assumed in excess</td><td></td></tr>';
      return '<tr class="' + (r.limiting ? 'lim' : '') + '"><td><strong>' + pretty(r.sp) + '</strong></td><td class="n">' + r.coef + '</td><td class="n">' + r.given + ' ' + r.unit + '</td><td class="n">' + r.mol + '</td><td class="n"><strong>' + r.ext + '</strong></td><td class="n">' + (r.limiting ? '0' : r.left_g + ' g') + '</td><td>' + (r.limiting ? '<span class="lr-badge">smallest → limiting</span>' : '') + '</td></tr>';
    }).join('');
    h += '</tbody></table>';

    // ── theoretical yield of every product ──
    if (res.prod_yield && res.prod_yield.length) {
      h += '<p class="lr-eq-label" style="margin-top:1.2rem;">Theoretical yield of every product (at 100% reaction)</p>';
      h += '<table class="lr-tbl"><thead><tr><th>Product</th><th>Moles formed</th><th>Mass</th></tr></thead><tbody>';
      h += res.prod_yield.map(function (p) {
        return '<tr class="' + (p.sp === res.target ? 'lim' : '') + '"><td><strong>' + pretty(p.sp) + '</strong></td><td class="n">' + p.mol + ' mol</td><td class="n">' + p.g + ' g</td></tr>';
      }).join('');
      h += '</tbody></table>';
    }

    h += '<p class="lr-hint">Excess amounts left over and product yields assume the reaction proceeds to completion (100%). Real reactions reach the percent yield shown above.</p>';
    bodyEl.innerHTML = h;
  }

  // ── share (tool-utils) ──────────────────────────────────────────────
  function b64(s) { return btoa(unescape(encodeURIComponent(s))); }
  function unb64(s) { try { return decodeURIComponent(escape(atob(s))); } catch (e) { return ''; } }
  $('lrShareBtn').addEventListener('click', function () {
    if (typeof ToolUtils === 'undefined' || !ToolUtils.shareResult) return;
    var ex = { amt: b64($('lrAmt').value) };
    if ($('lrTarget').value.trim()) ex.t = $('lrTarget').value.trim();
    if ($('lrActual').value) { ex.ay = $('lrActual').value; ex.au = $('lrActualUnit').value; }
    ToolUtils.shareResult(elEq.value, { paramName:'eq', encode:true, extraParams: ex, copyToClipboard:true, showSupportPopup:true, toolName:'Limiting Reagent Calculator' });
  });
  function loadFromUrl() {
    var q = new URLSearchParams(location.search), eq = q.get('eq'); if (!eq) return;
    if (q.get('enc') === 'base64') { try { eq = decodeURIComponent(escape(atob(eq))); } catch (e) { return; } }
    elEq.value = eq;
    if (q.get('amt')) $('lrAmt').value = unb64(q.get('amt'));
    if (q.get('t')) $('lrTarget').value = q.get('t');
    if (q.get('ay')) { $('lrActual').value = q.get('ay'); if (q.get('au')) $('lrActualUnit').value = q.get('au'); }
    renderPreview(); btn.click();
  }

  function esc(s) { return String(s).replace(/[&<>"]/g, function (c) { return { '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;' }[c]; }); }
  document.querySelectorAll('.cs-faq-q').forEach(function (b) { b.addEventListener('click', function () { var it = b.closest('.cs-faq-item'); if (it) it.classList.toggle('open'); }); });
  renderPreview();
  loadFromUrl();
})();
</script>
</body>
</html>
