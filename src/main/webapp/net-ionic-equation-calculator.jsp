<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<jsp:include page="modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="Net Ionic Equation &amp; Precipitation Calculator" />
    <jsp:param name="toolCategory" value="Chemistry" />
    <jsp:param name="toolDescription" value="Enter a reaction and get the balanced molecular, complete ionic, and net ionic equations — with predicted states (aq/s/l/g), the precipitate, and the spectator ions. Balanced with chempy and classified with standard solubility rules." />
    <jsp:param name="toolUrl" value="net-ionic-equation-calculator.jsp" />
    <jsp:param name="toolKeywords" value="net ionic equation calculator, complete ionic equation, molecular equation, will a precipitate form, precipitation reaction calculator, spectator ions, solubility rules, double replacement reaction" />
    <jsp:param name="toolImage" value="net-ionic-og.png" />
    <jsp:param name="breadcrumbCategoryUrl" value="chemistry/" />
    <jsp:param name="teaches" value="net ionic equations, complete ionic equations, spectator ions, precipitation reactions, solubility rules, double-replacement reactions" />
    <jsp:param name="educationalLevel" value="High School, Undergraduate" />
    <jsp:param name="hasSteps" value="true" />
    <jsp:param name="howToSteps" value="Write the reaction|Type the molecular equation, e.g. AgNO3 + NaCl = AgCl + NaNO3 (it is balanced for you),Predict states|Each compound is labelled aqueous (aq), solid precipitate (s), liquid (l), or gas (g) using solubility rules,Write the complete ionic equation|Soluble strong electrolytes are split into their ions,Cancel spectators|Ions that appear unchanged on both sides are removed to give the net ionic equation" />
    <jsp:param name="faq1q" value="How do you write a net ionic equation?" />
    <jsp:param name="faq1a" value="First balance the molecular equation and assign states. Split every soluble strong electrolyte (aqueous salts, strong acids, strong bases) into its ions to get the complete ionic equation. Then cancel the spectator ions — those identical on both sides — and what remains is the net ionic equation." />
    <jsp:param name="faq2q" value="What is a spectator ion?" />
    <jsp:param name="faq2a" value="A spectator ion appears unchanged on both sides of the complete ionic equation. It does not take part in the actual chemical change, so it is cancelled out and does not appear in the net ionic equation." />
    <jsp:param name="faq3q" value="How do I know if a precipitate forms?" />
    <jsp:param name="faq3a" value="Apply the solubility rules to each product. If a product is insoluble in water it forms a solid precipitate (s). For example, most chlorides are soluble, but AgCl, PbCl2, and Hg2Cl2 are not — so mixing Ag+ with Cl- gives a precipitate." />
    <jsp:param name="faq4q" value="Why are strong acids split but weak acids are not?" />
    <jsp:param name="faq4a" value="Strong acids and strong bases ionize completely in water, so they are written as separate ions. Weak acids (like acetic acid) and weak bases ionize only slightly, so they stay together as molecules in ionic equations. Water, gases, and solids are also written in molecular form." />
    <jsp:param name="faq5q" value="What is the difference between complete and net ionic equations?" />
    <jsp:param name="faq5a" value="The complete (total) ionic equation shows every dissolved strong electrolyte as separate ions. The net ionic equation shows only the species that actually change — it is the complete ionic equation with the spectator ions removed." />
    <jsp:param name="faq6q" value="Is this net ionic equation calculator free?" />
    <jsp:param name="faq6a" value="Yes. It is free, needs no signup, balances with the open-source chempy library, and predicts states with the standard solubility rules." />
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
    .nie-eq-label { font:600 0.78rem var(--cs-font-sans); text-transform:uppercase; letter-spacing:0.06em; color:var(--cs-muted); margin:0 0 0.45rem; }
    .nie-eq-row { display:flex; gap:0.5rem; align-items:stretch; flex-wrap:wrap; }
    .nie-eq-input { flex:1 1 280px; min-width:0; min-height:48px; padding:0.7rem 0.95rem; border:1.5px solid var(--cs-line-strong); border-radius:var(--cs-radius); background:var(--cs-panel-bg-soft); color:var(--cs-ink); font:16px var(--cs-font-mono); transition:border-color var(--cs-transition), box-shadow var(--cs-transition); }
    .nie-eq-input:focus { outline:none; border-color:var(--cs-accent); background:var(--cs-panel-bg); box-shadow:var(--cs-ring); }
    .nie-hint { font-size:0.78rem; color:var(--cs-muted); line-height:1.55; margin:0.6rem 0 0; }
    .nie-hint code { font:12px var(--cs-font-mono); background:var(--cs-panel-bg-soft); padding:1px 5px; border-radius:4px; color:var(--cs-ink-soft); }
    .nie-btn { display:inline-flex; align-items:center; gap:0.4rem; padding:0.6rem 1.25rem; border-radius:var(--cs-radius-pill); background:var(--cs-accent); color:#fff; border:1px solid var(--cs-accent); font:600 0.85rem var(--cs-font-sans); cursor:pointer; transition:background var(--cs-transition), transform 0.1s var(--cs-ease); }
    .nie-btn:hover { background:var(--cs-accent-hover); transform:translateY(-1px); } .nie-btn:disabled { opacity:0.6; cursor:wait; transform:none; }
    .nie-cta { margin-top:1rem; }
    .nie-ex { background:none; border:1px solid var(--cs-line-strong); color:var(--cs-ink-soft); border-radius:var(--cs-radius-pill); padding:0.35rem 0.7rem; font:500 12px var(--cs-font-mono); cursor:pointer; }
    .nie-ex:hover { border-color:var(--cs-accent); color:var(--cs-accent); background:var(--cs-accent-softer); }
    .nie-chips { display:flex; flex-wrap:wrap; gap:0.4rem; margin-top:0.85rem; }
    .nie-preview { margin-top:0.55rem; min-height:1.5em; font:1.25rem var(--cs-font-serif); color:var(--cs-ink); }
    .nie-preview .op { color:var(--cs-accent); margin:0 0.3rem; }

    .nie-card { background:var(--cs-panel-bg); border:1px solid var(--cs-line); border-radius:var(--cs-radius-lg); box-shadow:var(--cs-shadow-sm); padding:1.5rem; overflow:hidden; }
    .nie-card-head { display:flex; align-items:center; gap:0.5rem; margin:0 0 1rem; }
    .nie-card-head h2 { margin:0; font:600 0.72rem var(--cs-font-sans); text-transform:uppercase; letter-spacing:0.08em; color:var(--cs-muted); }
    .nie-share { margin-left:auto; border:1px solid var(--cs-line-strong); background:var(--cs-panel-bg); color:var(--cs-ink-soft); border-radius:var(--cs-radius-pill); padding:0.3rem 0.85rem; font:600 0.72rem var(--cs-font-sans); cursor:pointer; }
    .nie-share:hover { border-color:var(--cs-accent); color:var(--cs-accent); }
    .nie-step { margin:0 0 1.1rem; }
    .nie-step .lab { font:600 0.66rem var(--cs-font-sans); text-transform:uppercase; letter-spacing:0.07em; color:var(--cs-muted); margin:0 0 0.35rem; }
    .nie-eqn { font:1.18rem var(--cs-font-serif); color:var(--cs-ink); line-height:1.9; }
    .nie-eqn.net { font-size:1.35rem; padding:0.7rem 0.9rem; background:var(--cs-accent-softer); border:1px solid var(--cs-accent-ring); border-left:3px solid var(--cs-accent); border-radius:var(--cs-radius); }
    .nie-eqn .op { color:var(--cs-accent); margin:0 0.3rem; } .nie-eqn .coef { color:var(--cs-muted); }
    .nie-eqn .st { font:0.66em var(--cs-font-sans); color:var(--cs-muted); vertical-align:0.1em; margin-left:1px; }
    .nie-eqn .ppt { color:var(--cs-accent); font-weight:600; } .nie-eqn .ppt .st { color:var(--cs-accent); }
    .nie-eqn .spec { text-decoration:line-through; text-decoration-color:#ef4444; text-decoration-thickness:2px; opacity:0.5; }
    .nie-callout { padding:0.8rem 1rem; border-radius:var(--cs-radius); font:0.92rem var(--cs-font-sans); color:var(--cs-ink); margin-top:0.2rem; }
    .nie-callout.ppt { background:var(--cs-accent-softer); border:1px solid var(--cs-accent-ring); } .nie-callout.ppt b { color:var(--cs-accent); }
    .nie-callout.none { background:var(--cs-panel-bg-soft); border:1px dashed var(--cs-line-strong); color:var(--cs-ink-soft); }
    .nie-spect { font:0.85rem var(--cs-font-sans); color:var(--cs-ink-soft); margin-top:0.8rem; }
    .nie-spect span { font-family:var(--cs-font-mono); }
    .nie-warn { padding:0.7rem 0.95rem; border-radius:var(--cs-radius); background:#fef7ed; border:1px solid #fdba74; color:#9a3412; font-size:0.85rem; margin-top:0.9rem; }
    [data-theme="dark"] .nie-warn { background:rgba(251,146,60,0.08); border-color:rgba(251,146,60,0.3); color:#fdba74; }
    .nie-err { padding:1rem 1.1rem; border-radius:var(--cs-radius); background:#fef7ed; border:1px solid #fdba74; color:#9a3412; font-size:0.9rem; }
    [data-theme="dark"] .nie-err { background:rgba(251,146,60,0.08); border-color:rgba(251,146,60,0.3); color:#fdba74; }
    .nie-spin { display:inline-block; width:13px; height:13px; border:2px solid rgba(255,255,255,0.45); border-top-color:#fff; border-radius:50%; animation:nie-spin 0.7s linear infinite; }
    @keyframes nie-spin { to { transform:rotate(360deg); } }

    .pt-seo { display:flex; flex-direction:column; gap:1rem; margin-top:1.25rem; }
    .pt-seo-card { background:var(--cs-panel-bg); border:1px solid var(--cs-line); border-radius:var(--cs-radius-lg); box-shadow:var(--cs-shadow-sm); padding:1.5rem 1.6rem; }
    .pt-seo-card h2 { font:400 1.4rem var(--cs-font-serif); color:var(--cs-ink); margin:0 0 0.6rem; }
    .pt-seo-card p, .pt-seo-card li { color:var(--cs-ink-soft); font-size:0.93rem; line-height:1.7; }
    .pt-seo-card ol, .pt-seo-card ul { margin:0.4rem 0 0; padding-left:1.2rem; }
    .pt-seo-card code { font:0.86em var(--cs-font-mono); background:var(--cs-panel-bg-soft); padding:1px 5px; border-radius:4px; color:var(--cs-ink-soft); }
    table.nie-rules { width:100%; border-collapse:collapse; margin-top:0.7rem; font-size:0.86rem; }
    table.nie-rules th, table.nie-rules td { text-align:left; padding:0.4rem 0.6rem; border-bottom:1px solid var(--cs-line); vertical-align:top; }
    table.nie-rules th { font:600 0.64rem var(--cs-font-sans); text-transform:uppercase; letter-spacing:0.04em; color:var(--cs-muted); }
    table.nie-rules td:first-child { color:var(--cs-ink); font-weight:600; }
</style>
</head>
<body class="cs-body">
<%@ include file="modern/components/nav-header.jsp" %>

<div class="cs-hero">
    <%@ include file="modern/ads/ad-hero-banner.jsp" %>
</div>

<main class="cs-main">
    <button type="button" id="csSidebarToggle" class="cs-sidebar-toggle" aria-label="Open chemistry tools menu">&#9776; Chemistry tools</button>
    <% request.setAttribute("activeService", "net-ionic"); %>
    <jsp:include page="/chemistry/partials/sidebar.jsp" />

    <section class="cs-workspace">

<div class="cs-title">
    <nav class="cs-crumbs" aria-label="Breadcrumb">
        <a href="<%=ctx%>/index.jsp">Home</a> /
        <a href="<%=ctx%>/chemistry/">Chemistry</a> /
        <span aria-current="page">Net Ionic Equation</span>
    </nav>
    <h1>Net Ionic Equation &amp; Precipitation Calculator</h1>
</div>

<div class="ic-stack">

    <div class="ic-hero">
        <p class="nie-eq-label">Molecular reaction</p>
        <div class="nie-eq-row">
            <input type="text" class="nie-eq-input" id="nieEq" spellcheck="false" autocomplete="off" placeholder="e.g. AgNO3 + NaCl = AgCl + NaNO3" value="AgNO3 + NaCl = AgCl + NaNO3">
        </div>
        <div class="nie-preview" id="niePreview"></div>
        <p class="nie-hint">Write reactants <code>=</code> products (it is balanced for you). States are predicted from solubility rules. Strong acids/bases and soluble salts are split into ions; weak acids, water, gases, and solids stay molecular.</p>

        <div class="nie-chips">
            <button type="button" class="nie-ex" data-eq="AgNO3 + NaCl = AgCl + NaNO3">AgCl precipitate</button>
            <button type="button" class="nie-ex" data-eq="BaCl2 + Na2SO4 = BaSO4 + NaCl">BaSO₄</button>
            <button type="button" class="nie-ex" data-eq="Pb(NO3)2 + KI = PbI2 + KNO3">PbI₂ (golden rain)</button>
            <button type="button" class="nie-ex" data-eq="HCl + NaOH = NaCl + H2O">acid + base</button>
            <button type="button" class="nie-ex" data-eq="Na2CO3 + CaCl2 = CaCO3 + NaCl">CaCO₃</button>
            <button type="button" class="nie-ex" data-eq="HC2H3O2 + NaOH = NaC2H3O2 + H2O">weak acid</button>
        </div>

        <div class="nie-cta"><button type="button" class="nie-btn" id="nieSolve">&#9878; Write net ionic equation</button></div>
    </div>

    <div class="nie-card" id="nieResultCard" style="display:none;">
        <div class="nie-card-head"><span style="color:var(--cs-accent);">&#8651;</span><h2>Result</h2><button type="button" id="nieShareBtn" class="nie-share" style="display:none;">&#128279; Share</button></div>
        <div id="nieResultBody"></div>
    </div>

    <div class="cs-inline-ad">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <section class="pt-seo">
        <div class="pt-seo-card">
            <h2>The three equations — and how to get the net one</h2>
            <ol>
                <li><strong>Molecular equation:</strong> balanced, with everyone written as full compounds and a state in parentheses.</li>
                <li><strong>Complete (total) ionic equation:</strong> every <em>aqueous strong electrolyte</em> (soluble salts, strong acids, strong bases) is split into its ions. Solids (s), liquids (l), gases (g), and weak acids stay together.</li>
                <li><strong>Net ionic equation:</strong> cancel the <strong>spectator ions</strong> — the ones identical on both sides — and you are left with the species that actually react.</li>
            </ol>
            <p>Mixing two soluble salts is a <strong>double-replacement</strong> reaction; it only "happens" if a product is an insoluble <strong>precipitate</strong>, a gas, or water. If every product is soluble, all ions are spectators and there is <em>no reaction</em>.</p>
        </div>
        <div class="pt-seo-card">
            <h2>Solubility rules (used by this calculator)</h2>
            <table class="nie-rules">
                <thead><tr><th>Soluble</th><th>Main exceptions (insoluble)</th></tr></thead>
                <tbody>
                    <tr><td>Group 1 (Li⁺, Na⁺, K⁺, Rb⁺, Cs⁺) &amp; NH₄⁺ salts</td><td>none</td></tr>
                    <tr><td>Nitrates NO₃⁻, acetates C₂H₃O₂⁻, chlorates ClO₃⁻, perchlorates ClO₄⁻</td><td>none</td></tr>
                    <tr><td>Chlorides, bromides, iodides (Cl⁻, Br⁻, I⁻)</td><td>Ag⁺, Pb²⁺, Hg₂²⁺</td></tr>
                    <tr><td>Sulfates SO₄²⁻</td><td>Ba²⁺, Sr²⁺, Pb²⁺, Ca²⁺, Ag⁺, Hg²⁺</td></tr>
                </tbody>
                <thead><tr><th>Insoluble</th><th>Main exceptions (soluble)</th></tr></thead>
                <tbody>
                    <tr><td>Carbonates CO₃²⁻, phosphates PO₄³⁻, sulfites SO₃²⁻, chromates CrO₄²⁻</td><td>Group 1 &amp; NH₄⁺</td></tr>
                    <tr><td>Sulfides S²⁻</td><td>Group 1, Group 2 &amp; NH₄⁺</td></tr>
                    <tr><td>Hydroxides OH⁻</td><td>Group 1, NH₄⁺, and Ba²⁺/Sr²⁺/Ca²⁺</td></tr>
                </tbody>
            </table>
        </div>
        <div class="pt-seo-card">
            <h2 class="cs-faq-title" id="faqs" style="font-family:var(--cs-font-serif);">Frequently asked</h2>
            <div class="cs-faq" aria-label="Net ionic equation FAQ">
                <div class="cs-faq-item"><button class="cs-faq-q" type="button">How do you write a net ionic equation?<svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                    <div class="cs-faq-a">Balance the molecular equation, assign states, split soluble strong electrolytes into ions (the complete ionic equation), then cancel the spectator ions.</div></div>
                <div class="cs-faq-item"><button class="cs-faq-q" type="button">What is a spectator ion?<svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                    <div class="cs-faq-a">An ion that is identical on both sides and takes no part in the change — it is cancelled and does not appear in the net ionic equation.</div></div>
                <div class="cs-faq-item"><button class="cs-faq-q" type="button">How do I know if a precipitate forms?<svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                    <div class="cs-faq-a">Apply the solubility rules to each product; an insoluble product is the solid precipitate (s).</div></div>
                <div class="cs-faq-item"><button class="cs-faq-q" type="button">Why are weak acids not split?<svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                    <div class="cs-faq-a">Weak acids and bases ionize only slightly, so they stay molecular. Only strong acids/bases and soluble salts are written as ions.</div></div>
                <div class="cs-faq-item"><button class="cs-faq-q" type="button">Is it free?<svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                    <div class="cs-faq-a">Yes — free, no signup, balanced with chempy and classified with standard solubility rules.</div></div>
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
  function sub(f) { return String(f).replace(/(\d+)/g, '<sub>$1</sub>'); }

  var elEq = $('nieEq'), elPrev = $('niePreview');
  function renderPreview() {
    var p = parseEquation(elEq.value);
    elPrev.innerHTML = p ? (p.reac.map(sub).join(' <span class="op">+</span> ') + ' <span class="op">→</span> ' + p.prod.map(sub).join(' <span class="op">+</span> ')) : '';
  }
  elEq.addEventListener('input', renderPreview);
  document.addEventListener('click', function (e) {
    var c = e.target.closest('.nie-ex'); if (!c) return;
    elEq.value = c.getAttribute('data-eq'); renderPreview();
  });

  // ── Python engine (chempy balance + solubility rules) — validated locally ──
  function buildCode(p) {
    var ENGINE = [
'import json, re',
'from chempy import balance_stoichiometry, Substance',
'from chempy.util.periodic import symbols as _SYM',
'ELEMENT_SET=set(_SYM)',
'',
'POLY = {  # polyatomic anion -> charge',
' \'C2H3O2\':-1,\'CH3COO\':-1,\'CH3CO2\':-1,\'NO3\':-1,\'NO2\':-1,\'OH\':-1,\'CN\':-1,\'SCN\':-1,\'MnO4\':-1,',
' \'ClO4\':-1,\'ClO3\':-1,\'ClO2\':-1,\'ClO\':-1,\'HCO3\':-1,\'HSO4\':-1,\'HSO3\':-1,\'H2PO4\':-1,',
' \'SO4\':-2,\'SO3\':-2,\'CO3\':-2,\'CrO4\':-2,\'Cr2O7\':-2,\'C2O4\':-2,\'S2O3\':-2,\'SiO3\':-2,\'HPO4\':-2,',
' \'PO4\':-3,\'PO3\':-3,\'BO3\':-3,\'AsO4\':-3,',
'}',
'MONO_AN = {\'F\':-1,\'Cl\':-1,\'Br\':-1,\'I\':-1,\'O\':-2,\'S\':-2}',
'FIXED_CAT = {\'H\':1,\'Li\':1,\'Na\':1,\'K\':1,\'Rb\':1,\'Cs\':1,\'Ag\':1,\'NH4\':1,',
' \'Be\':2,\'Mg\':2,\'Ca\':2,\'Sr\':2,\'Ba\':2,\'Zn\':2,\'Cd\':2,\'Ni\':2,',
' \'Al\':3,\'Ga\':3}',
'STRONG_ACID = {\'HCl\',\'HBr\',\'HI\',\'HNO3\',\'HClO4\',\'HClO3\',\'H2SO4\'}',
'STRONG_BASE = {\'LiOH\',\'NaOH\',\'KOH\',\'RbOH\',\'CsOH\',\'Ca(OH)2\',\'Sr(OH)2\',\'Ba(OH)2\'}',
'WEAK_BASE = {\'NH4OH\',\'NH3H2O\'}',
'GASES = {\'CO2\',\'O2\',\'H2\',\'N2\',\'Cl2\',\'F2\',\'Br2\',\'I2\',\'SO2\',\'SO3\',\'NO\',\'NO2\',\'N2O\',\'NH3\',\'H2S\',\'CO\',\'O3\'}',
'LIQUID = {\'H2O\'}',
'',
'def split_salt(f):',
'    """Return (cat, cat_n, cat_q, an, an_n, an_q) or None."""',
'    s = f',
'    # cation',
'    if s.startswith(\'(NH4)\'):',
'        m = re.match(r\'^\\(NH4\\)(\\d*)\', s); cat=\'NH4\'; cat_n=int(m.group(1) or 1); rest=s[m.end():]',
'    elif s.startswith(\'NH4\'):',
'        cat=\'NH4\'; cat_n=1; rest=s[3:]',
'    else:',
'        m = re.match(r\'^([A-Z][a-z]?)(\\d*)\', s)',
'        if not m: return None',
'        cat=m.group(1); cat_n=int(m.group(2) or 1); rest=s[m.end():]',
'    if not rest: return None',
'    # anion',
'    an=None; an_n=1',
'    mp = re.match(r\'^\\(([A-Za-z0-9]+)\\)(\\d*)$\', rest)',
'    if mp:',
'        an=mp.group(1); an_n=int(mp.group(2) or 1)',
'    else:',
'        for a in sorted(POLY, key=len, reverse=True):',
'            mm = re.match(r\'^\'+re.escape(a)+r\'(\\d*)$\', rest)',
'            if mm: an=a; an_n=int(mm.group(1) or 1); break',
'        if an is None:',
'            mm = re.match(r\'^([A-Z][a-z]?)(\\d*)$\', rest)',
'            if mm and mm.group(1) in MONO_AN: an=mm.group(1); an_n=int(mm.group(2) or 1)',
'    if an is None: return None',
'    an_q = POLY.get(an, MONO_AN.get(an))',
'    if an_q is None: return None',
'    # cation charge',
'    if cat in FIXED_CAT: cat_q = FIXED_CAT[cat]',
'    else:',
'        tot = an_n*abs(an_q)',
'        if tot % cat_n != 0: return None',
'        cat_q = tot//cat_n',
'    return (cat, cat_n, cat_q, an, an_n, an_q)',
'',
'def soluble(cat, an):',
'    if cat in (\'Li\',\'Na\',\'K\',\'Rb\',\'Cs\',\'NH4\'): return True',
'    if an in (\'NO3\',\'ClO3\',\'ClO4\',\'C2H3O2\',\'CH3COO\',\'CH3CO2\',\'NO2\',\'HCO3\'): return True',
'    if an in (\'Cl\',\'Br\',\'I\'): return cat not in (\'Ag\',\'Pb\',\'Hg\',\'Hg2\',\'Cu1\')',
'    if an == \'SO4\': return cat not in (\'Ba\',\'Sr\',\'Pb\',\'Ca\',\'Ag\',\'Hg\',\'Hg2\')',
'    if an == \'OH\': return cat in (\'Ba\',\'Sr\',\'Ca\')  # group1+NH4 already returned True',
'    if an==\'S\': return cat in (\'Be\',\'Mg\',\'Ca\',\'Sr\',\'Ba\')  # sulfides: group1+NH4 already soluble; group2 soluble too',
'    if an in (\'CO3\',\'PO4\',\'SO3\',\'CrO4\',\'C2O4\',\'SiO3\',\'BO3\',\'AsO4\',\'PO3\'): return False',
'    return True  # default soluble (flagged upstream)',
'',
'def ion(sym, q):',
'    s = \'+\' if q>0 else \'-\'',
'    n = abs(q)',
'    return sym + (s if n==1 else s+str(n)) if False else sym + ((\'^%d%s\'%(n,s)) if n>1 else (\'^\'+s))',
'',
'def classify(f):',
'    if f in LIQUID: return (\'l\', None)',
'    if f in GASES:  return (\'g\', None)',
'    if f in WEAK_BASE: return (\'aq\', None)            # aqueous ammonia: weak base, stays molecular',
'    me = re.match(r\'^([A-Z][a-z]?)(\\d*)$\', f)',
'    if me and me.group(1) in ELEMENT_SET: return (\'s\', None)  # free element (metal / nonmetal solid) - does not ionize',
'    if f in STRONG_ACID:',
'        sp = split_salt(\'H\'+f[1:]) if False else None',
'        # treat as H+ + anion',
'        an = f[1:]',
'        if f==\'H2SO4\': an=\'SO4\'',
'        anq = POLY.get(an, MONO_AN.get(an, -1))',
'        nH = 2 if f==\'H2SO4\' else 1',
'        return (\'aq\', [(\'H\', 1, nH), (an, anq, 1)])',
'    if f in STRONG_BASE:',
'        sp = split_salt(f)',
'        if sp: ',
'            cat,cn,cq,a,an_n,aq = sp',
'            return (\'aq\', [(cat,cq,cn),(a,aq,an_n)])',
'    sp = split_salt(f)',
'    if sp:',
'        cat,cn,cq,a,an_n,aq = sp',
'        if cat==\'H\':            # acid; strong acids handled above -> this is a WEAK acid: stays molecular',
'            return (\'aq\', None)',
'        if soluble(cat,a):',
'            return (\'aq\', [(cat,cq,cn),(a,aq,an_n)])',
'        else:',
'            return (\'s\', None)',
'    return (\'aq?\', None)  # unknown — molecular, uncertain',
'',
'def run(P):',
'    reac=P[\'reac\']; prod=P[\'prod\']',
'    try:',
'        r,p = balance_stoichiometry(set(reac), set(prod))',
'        rl=[(k,int(r[k])) for k in r if int(r[k])]',
'        pl=[(k,int(p[k])) for k in p if int(p[k])]',
'        species = rl+pl',
'        states={}; ions_of={}',
'        for f,_ in species:',
'            st,io = classify(f); states[f]=st; ions_of[f]=io',
'        # complete ionic: expand aqueous; collect ion species with multiplicity',
'        from collections import Counter',
'        def expand(side):',
'            full=[]  # list of (token_str, mult) for display',
'            ionbag=Counter()',
'            for f,c in side:',
'                if ions_of[f]:',
'                    for (sym,q,sub) in ions_of[f]:',
'                        m=c*sub',
'                        full.append((sym,q,m)); ionbag[(sym,q)]+=m',
'                else:',
'                    full.append((f,None,c)); ionbag[(f,None)]+=c',
'            return full, ionbag',
'        lfull,lbag = expand(rl)',
'        rfull,rbag = expand(pl)',
'        # spectators = ions present same on both sides (as ions, q not None)',
'        spectators=set()',
'        for key in list(lbag):',
'            sym,q=key',
'            if q is None: continue',
'            common=min(lbag[key], rbag.get(key,0))',
'            if common>0: spectators.add(key)',
'        # net ionic: subtract common multiplicities',
'        def net(bag):',
'            out=[]',
'            for key,m in bag.items():',
'                sym,q=key',
'                if q is not None:',
'                    rem=m-min(lbag[key],rbag.get(key,0))',
'                    if rem>0: out.append((sym,q,rem))',
'                else:',
'                    out.append((sym,q,m))',
'            return out',
'        lnet=net(lbag); rnet=net(rbag)',
'        precipitates=[f for f,_ in pl if states[f]==\'s\']',
'        out={\'ok\':True,',
'             \'molecular\':{\'r\':rl,\'p\':pl},',
'             \'states\':states,',
'             \'complete\':{\'r\':lfull,\'p\':rfull},',
'             \'net\':{\'r\':lnet,\'p\':rnet},',
'             \'spectators\':sorted([\'%s%+d\'%(s,q) for (s,q) in spectators]),',
'             \'precipitates\':precipitates,',
'             \'reaction_occurs\': bool(lnet and rnet)}',
'        return out',
'    except Exception as e:',
'        return {\'ok\':False,\'error\':type(e).__name__+\': \'+str(e)}',
'',
'',
'P = json.loads(r"""__PAYLOAD__""")',
'print("RESULT:"+json.dumps(run(P)))'
    ].join('\n');
    return ENGINE.replace('__PAYLOAD__', JSON.stringify(p));
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

  var card = $('nieResultCard'), bodyEl = $('nieResultBody'), btn = $('nieSolve');
  btn.addEventListener('click', function () {
    var p = parseEquation(elEq.value);
    card.style.display = ''; btn.disabled = true; var old = btn.innerHTML; btn.innerHTML = '<span class="nie-spin"></span> Solving…';
    if (!p) { bodyEl.innerHTML = '<div class="nie-err"><strong>Type a reaction</strong> with <code>=</code> separating reactants and products.</div>'; btn.disabled = false; btn.innerHTML = old; return; }
    bodyEl.innerHTML = '<p class="nie-hint">Balancing &amp; applying solubility rules…</p>';
    run(p).then(function (res) {
      if (!res.ok) { bodyEl.innerHTML = '<div class="nie-err"><strong>Could not solve.</strong> ' + esc(res.error || '') + '</div>'; return; }
      render(res);
    }).catch(function (e) { bodyEl.innerHTML = '<div class="nie-err"><strong>Backend error.</strong> ' + esc(e.message || e) + '</div>'; })
      .then(function () { btn.disabled = false; btn.innerHTML = old; });
  });

  var ST = { s:'(s)', l:'(l)', g:'(g)', aq:'(aq)', 'aq?':'(aq?)' };
  function chg(q) { var n = Math.abs(q), s = q > 0 ? '+' : '−'; return '<sup>' + (n > 1 ? n : '') + s + '</sup>'; }

  // molecular side: [ [formula, coef], ... ]
  function molSide(side, states) {
    return side.map(function (x) {
      var f = x[0], c = x[1], st = states[f], cls = (st === 's') ? ' class="ppt"' : '';
      return '<span' + cls + '>' + (c > 1 ? '<span class="coef">' + c + '</span> ' : '') + sub(f) + '<span class="st">' + (ST[st] || '') + '</span></span>';
    }).join('<span class="op">+</span>');
  }
  // ionic side: [ [sym, q|null, mult], ... ]. spect = Set of spectator keys to strike through.
  function ionSide(side, states, spect) {
    if (!side.length) return '<span style="color:var(--cs-muted)">(nothing)</span>';
    return side.map(function (t) {
      var symf = t[0], q = t[1], m = t[2];
      var pre = (m > 1 ? '<span class="coef">' + m + '</span> ' : '');
      if (q === null) { var st = states[symf]; var cls = (st === 's') ? ' class="ppt"' : ''; return '<span' + cls + '>' + pre + sub(symf) + '<span class="st">' + (ST[st] || '') + '</span></span>'; }
      var key = symf + (q > 0 ? '+' + q : '' + q);
      var strike = (spect && spect.has(key)) ? ' class="spec"' : '';
      return '<span' + strike + '>' + pre + sub(symf) + chg(q) + '<span class="st">(aq)</span></span>';
    }).join('<span class="op">+</span>');
  }
  function eqn(side1, side2, states, fn, netCls, spect) {
    return '<div class="nie-eqn' + (netCls ? ' net' : '') + '">' + fn(side1, states, spect) + ' <span class="op">→</span> ' + fn(side2, states, spect) + '</div>';
  }

  function render(res) {
    $('nieShareBtn').style.display = '';
    var spect = new Set(res.spectators || []);
    var h = '';
    h += '<div class="nie-step"><p class="lab">1 · Balanced molecular equation</p>' + eqn(res.molecular.r, res.molecular.p, res.states, molSide) + '</div>';
    h += '<div class="nie-step"><p class="lab">2 · Complete ionic equation' + (spect.size ? ' <span style="font-weight:400;text-transform:none;letter-spacing:0;">— spectator ions struck out</span>' : '') + '</p>' + eqn(res.complete.r, res.complete.p, res.states, ionSide, false, spect) + '</div>';

    if (res.reaction_occurs && (res.net.r.length || res.net.p.length)) {
      h += '<div class="nie-step"><p class="lab">3 · Net ionic equation</p>' + eqn(res.net.r, res.net.p, res.states, ionSide, true) + '</div>';
      if (res.precipitates && res.precipitates.length)
        h += '<div class="nie-callout ppt">Solid formed: <b>' + res.precipitates.map(function (f) { return sub(f); }).join(', ') + '</b> (insoluble — a precipitate, or a metal deposited in a single-replacement reaction).</div>';
      else
        h += '<div class="nie-callout ppt">No precipitate — the driving force is forming a gas, water, or a weak electrolyte.</div>';
    } else {
      h += '<div class="nie-step"><p class="lab">3 · Net ionic equation</p><div class="nie-callout none"><b>No reaction.</b> Every product is soluble, so all ions stay in solution as spectators — there is no net ionic equation.</div></div>';
    }

    if (res.spectators && res.spectators.length) {
      h += '<div class="nie-spect">Spectator ions: ' + res.spectators.map(function (s) {
        var mm = s.match(/^([A-Za-z0-9]+?)([+-]\d+)$/);
        if (!mm) return '<span>' + esc(s) + '</span>';
        return '<span>' + sub(mm[1]) + chg(parseInt(mm[2], 10)) + '</span>';
      }).join(', ') + '</div>';
    }

    var unknown = Object.keys(res.states).filter(function (k) { return res.states[k] === 'aq?'; });
    if (unknown.length)
      h += '<div class="nie-warn">⚠ Could not confidently classify ' + unknown.map(sub).join(', ') + ' (it may not be a simple aqueous-ionic species). Treat the ionic split for these with care.</div>';

    bodyEl.innerHTML = h;
  }

  // ── share ──
  $('nieShareBtn').addEventListener('click', function () {
    if (typeof ToolUtils === 'undefined' || !ToolUtils.shareResult) return;
    ToolUtils.shareResult(elEq.value, { paramName:'eq', encode:true, copyToClipboard:true, showSupportPopup:true, toolName:'Net Ionic Equation Calculator' });
  });
  function loadFromUrl() {
    var q = new URLSearchParams(location.search), eq = q.get('eq'); if (!eq) return;
    if (q.get('enc') === 'base64') { try { eq = decodeURIComponent(escape(atob(eq))); } catch (e) { return; } }
    elEq.value = eq; renderPreview(); btn.click();
  }

  function esc(s) { return String(s).replace(/[&<>"]/g, function (c) { return { '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;' }[c]; }); }
  document.querySelectorAll('.cs-faq-q').forEach(function (b) { b.addEventListener('click', function () { var it = b.closest('.cs-faq-item'); if (it) it.classList.toggle('open'); }); });
  renderPreview();
  loadFromUrl();
})();
</script>
</body>
</html>
