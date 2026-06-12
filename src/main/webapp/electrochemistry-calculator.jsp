<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<jsp:include page="modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="Electrochemistry Calculator" />
    <jsp:param name="toolCategory" value="Chemistry" />
    <jsp:param name="toolDescription" value="Write a redox reaction and get the balanced equation, electrons transferred (n), standard cell potential, Nernst equation, free energy and equilibrium constant. Balancing is verified with chempy." />
    <jsp:param name="toolUrl" value="electrochemistry-calculator.jsp" />
    <jsp:param name="toolKeywords" value="electrochemistry calculator, nernst equation calculator, cell potential calculator, balance redox reaction, standard reduction potential, galvanic cell, faraday law electrolysis, emf calculator, delta G from cell potential, equilibrium constant from E cell" />
    <jsp:param name="toolImage" value="electrochemistry-og.png" />
    <jsp:param name="breadcrumbCategoryUrl" value="chemistry/" />
</jsp:include>

<link rel="stylesheet" href="<%=ctx%>/modern/css/design-system.css">
<link rel="stylesheet" href="<%=ctx%>/modern/css/navigation.css">
<link rel="stylesheet" href="<%=ctx%>/chemistry/css/chemistry-studio.css">
<link rel="stylesheet" href="<%=ctx%>/modern/css/ads.css">
<link rel="stylesheet" href="<%=ctx%>/modern/css/dark-mode.css">
<link rel="stylesheet" href="<%=ctx%>/modern/css/footer.css">
<link rel="stylesheet" href="<%=ctx%>/modern/css/search.css">

<style>
    /* ── Electrochemistry — chemistry studio. Writes like chemistry:
       one equation surface, chempy balances + finds n, JS does the math. ── */
    .ec-eq-label { display:flex; align-items:center; justify-content:space-between; gap:0.75rem; margin-bottom:0.45rem; }
    .ec-eq-label .ec-lbl { font:600 0.78rem var(--cs-font-sans); text-transform:uppercase; letter-spacing:0.06em; color:var(--cs-muted); margin:0; }
    .ec-eq-row { display:flex; gap:0.5rem; align-items:stretch; flex-wrap:wrap; }
    .ec-eq-input {
        flex:1 1 320px; min-width:0; min-height:50px;
        padding:0.7rem 0.95rem;
        border:1.5px solid var(--cs-line-strong); border-radius:var(--cs-radius);
        background:var(--cs-panel-bg-soft); color:var(--cs-ink);
        font:16px var(--cs-font-mono);
        transition:border-color var(--cs-transition), box-shadow var(--cs-transition), background var(--cs-transition);
    }
    .ec-eq-input:focus { outline:none; border-color:var(--cs-accent); background:var(--cs-panel-bg); box-shadow:var(--cs-ring); }

    .ec-cta { flex:0 0 auto; }
    .ec-btn {
        display:inline-flex; align-items:center; gap:0.4rem;
        padding:0.7rem 1.25rem; border-radius:var(--cs-radius-pill);
        background:var(--cs-accent); color:#fff; border:1px solid var(--cs-accent);
        font:600 0.85rem var(--cs-font-sans); cursor:pointer; white-space:nowrap;
        transition:background var(--cs-transition), transform 0.1s var(--cs-ease);
    }
    .ec-btn:hover { background:var(--cs-accent-hover); transform:translateY(-1px); }
    .ec-btn:disabled { opacity:0.6; cursor:wait; transform:none; }

    /* Live pretty preview of the typed equation */
    .ec-preview {
        margin-top:0.6rem; min-height:1.6em;
        font:1.35rem var(--cs-font-serif); color:var(--cs-ink); line-height:1.5;
    }
    .ec-preview .ec-op { color:var(--cs-accent); margin:0 0.35rem; font-weight:600; }
    .ec-preview .ec-muted { color:var(--cs-muted); font-family:var(--cs-font-sans); font-size:0.95rem; }

    .ec-controls { display:flex; flex-wrap:wrap; gap:0.6rem 1rem; align-items:flex-end; margin-top:0.85rem; }
    .ec-field { display:flex; flex-direction:column; gap:0.25rem; }
    .ec-field label { font:600 0.68rem var(--cs-font-sans); text-transform:uppercase; letter-spacing:0.05em; color:var(--cs-muted); }
    .ec-input {
        padding:0.5rem 0.7rem; border:1.5px solid var(--cs-line-strong); border-radius:var(--cs-radius-sm);
        background:var(--cs-panel-bg-soft); color:var(--cs-ink); font:14px var(--cs-font-sans); width:8rem;
        transition:border-color var(--cs-transition), box-shadow var(--cs-transition);
    }
    .ec-input:focus { outline:none; border-color:var(--cs-accent); background:var(--cs-panel-bg); box-shadow:var(--cs-ring); }
    .ec-input.num { text-align:center; }
    .ec-hint { font-size:0.78rem; color:var(--cs-muted); line-height:1.5; margin:0.45rem 0 0; }
    .ec-hint code { font:12px var(--cs-font-mono); background:var(--cs-panel-bg-soft); padding:1px 5px; border-radius:4px; color:var(--cs-ink-soft); }

    /* Collapsibles (examples, E° reference) */
    details.ec-collapse { border:1px solid var(--cs-line); border-radius:var(--cs-radius-sm); background:var(--cs-panel-bg-soft); margin-top:0.85rem; }
    details.ec-collapse > summary { list-style:none; cursor:pointer; padding:0.6rem 0.85rem; font:600 0.8rem var(--cs-font-sans); color:var(--cs-ink); display:flex; align-items:center; gap:0.4rem; }
    details.ec-collapse > summary::-webkit-details-marker { display:none; }
    details.ec-collapse > summary::after { content:"\25be"; margin-left:auto; opacity:0.55; transition:transform .15s; }
    details.ec-collapse[open] > summary::after { transform:rotate(180deg); }
    details.ec-collapse[open] > summary { border-bottom:1px solid var(--cs-line); }
    .ec-collapse-body { padding:0.75rem 0.85rem; }

    .ec-chips { display:flex; flex-wrap:wrap; gap:0.4rem; }
    .ec-chip {
        padding:0.35rem 0.7rem; border:1px solid var(--cs-line-strong); border-radius:var(--cs-radius-pill);
        background:var(--cs-panel-bg); color:var(--cs-ink); font:500 12.5px var(--cs-font-mono); cursor:pointer;
        transition:border-color var(--cs-transition), background var(--cs-transition), color var(--cs-transition);
    }
    .ec-chip:hover { border-color:var(--cs-accent); background:var(--cs-accent-softer); color:var(--cs-accent); }

    /* Result cards */
    .ec-card {
        background:var(--cs-panel-bg); border:1px solid var(--cs-line);
        border-radius:var(--cs-radius-lg); box-shadow:var(--cs-shadow-sm); padding:1.5rem; overflow:hidden;
    }
    .ec-card-head { display:flex; align-items:center; gap:0.5rem; margin:0 0 1rem; }
    .ec-card-head h2 { margin:0; font:600 0.72rem var(--cs-font-sans); text-transform:uppercase; letter-spacing:0.08em; color:var(--cs-muted); }

    .ec-eqn { font:1.5rem var(--cs-font-serif); color:var(--cs-ink); line-height:1.55; text-align:center; padding:0.5rem 0; }
    .ec-eqn .ec-op { color:var(--cs-accent); margin:0 0.4rem; font-weight:600; }
    .ec-eqn .ec-coef { color:var(--cs-muted); }

    .ec-halves { display:grid; grid-template-columns:1fr 1fr; gap:0.75rem; margin-top:1rem; }
    @media(max-width:560px){ .ec-halves { grid-template-columns:1fr; } }
    .ec-half { padding:0.85rem 1rem; border-radius:var(--cs-radius); background:var(--cs-panel-bg-soft); border-left:3px solid var(--cs-accent); }
    .ec-half .ec-half-lbl { font:600 0.66rem var(--cs-font-sans); text-transform:uppercase; letter-spacing:0.06em; color:var(--cs-muted); margin-bottom:0.3rem; }
    .ec-half .ec-half-eq { font:1.05rem var(--cs-font-serif); color:var(--cs-ink); }

    .ec-stats { display:grid; grid-template-columns:repeat(auto-fit,minmax(120px,1fr)); gap:0.75rem; margin-top:1rem; }
    .ec-stat { padding:0.75rem 0.7rem; background:var(--cs-panel-bg-soft); border-radius:var(--cs-radius-sm); border-left:3px solid var(--cs-accent); text-align:center; }
    .ec-stat .ec-stat-lbl { display:block; font:600 0.62rem var(--cs-font-sans); text-transform:uppercase; letter-spacing:0.05em; color:var(--cs-muted); margin-bottom:0.3rem; }
    .ec-stat .ec-stat-val { font:700 1.3rem var(--cs-font-mono); color:var(--cs-accent); }
    .ec-stat .ec-stat-sub { display:block; font:0.7rem var(--cs-font-sans); color:var(--cs-muted); margin-top:0.15rem; }

    .ec-verdict { margin-top:1rem; padding:0.75rem 1rem; border-radius:var(--cs-radius); font:600 0.9rem var(--cs-font-sans); }
    .ec-verdict.go { background:rgba(34,197,94,0.10); color:#15803d; border:1px solid rgba(34,197,94,0.3); }
    .ec-verdict.nogo { background:rgba(239,68,68,0.10); color:#b91c1c; border:1px solid rgba(239,68,68,0.3); }
    [data-theme="dark"] .ec-verdict.go { color:#4ade80; }
    [data-theme="dark"] .ec-verdict.nogo { color:#fca5a5; }

    .ec-err { padding:1rem 1.1rem; border-radius:var(--cs-radius); background:#fef7ed; border:1px solid #fdba74; color:#9a3412; font-size:0.9rem; }
    [data-theme="dark"] .ec-err { background:rgba(251,146,60,0.08); border-color:rgba(251,146,60,0.3); color:#fdba74; }

    /* E° reference table */
    .ec-ref-search { width:100%; margin-bottom:0.6rem; }
    .ec-ref-wrap { max-height:300px; overflow:auto; border:1px solid var(--cs-line); border-radius:var(--cs-radius-sm); }
    table.ec-ref { width:100%; border-collapse:collapse; font-size:0.82rem; }
    table.ec-ref th { position:sticky; top:0; background:var(--cs-panel-bg); text-align:left; padding:0.5rem 0.6rem; font:600 0.66rem var(--cs-font-sans); text-transform:uppercase; letter-spacing:0.04em; color:var(--cs-muted); border-bottom:1px solid var(--cs-line); }
    table.ec-ref td { padding:0.45rem 0.6rem; border-bottom:1px solid var(--cs-line); color:var(--cs-ink); }
    table.ec-ref td.ec-e0 { font-family:var(--cs-font-mono); font-weight:600; color:var(--cs-accent); white-space:nowrap; }
    .ec-ref-fill { display:inline-flex; gap:0.25rem; }
    .ec-ref-fill button { font:600 0.66rem var(--cs-font-sans); padding:2px 7px; border-radius:var(--cs-radius-pill); border:1px solid var(--cs-line-strong); background:var(--cs-panel-bg); color:var(--cs-ink-soft); cursor:pointer; }
    .ec-ref-fill button:hover { border-color:var(--cs-accent); color:var(--cs-accent); background:var(--cs-accent-softer); }

    .ec-spin { display:inline-block; width:13px; height:13px; border:2px solid rgba(255,255,255,0.45); border-top-color:#fff; border-radius:50%; animation:ec-spin 0.7s linear infinite; }
    @keyframes ec-spin { to { transform:rotate(360deg); } }

    sub.ec-s { font-size:0.7em; vertical-align:-0.25em; }
</style>
</head>
<body class="cs-body">
<%@ include file="modern/components/nav-header.jsp" %>

<div class="cs-hero">
    <%@ include file="modern/ads/ad-hero-banner.jsp" %>
</div>

<main class="cs-main">
    <button type="button" id="csSidebarToggle" class="cs-sidebar-toggle" aria-label="Open chemistry tools menu">&#9776; Chemistry tools</button>
    <% request.setAttribute("activeService", "electro"); %>
    <jsp:include page="/chemistry/partials/sidebar.jsp" />

    <section class="cs-workspace">

<!-- Slim studio title -->
<div class="cs-title">
    <nav class="cs-crumbs" aria-label="Breadcrumb">
        <a href="<%=ctx%>/index.jsp">Home</a> /
        <a href="<%=ctx%>/chemistry/">Chemistry</a> /
        <span aria-current="page">Electrochemistry</span>
    </nav>
    <h1>Electrochemistry Calculator</h1>
</div>

<div class="ic-stack">

    <!-- ===== Writing surface ===== -->
    <div class="ic-hero">
        <div class="ec-eq-label">
            <p class="ec-lbl">Write your redox / cell reaction</p>
        </div>
        <div class="ec-eq-row">
            <input type="text" class="ec-eq-input" id="ecEq" spellcheck="false" autocomplete="off"
                   placeholder="Zn + Cu+2 = Zn+2 + Cu">
            <div class="ec-cta">
                <button type="button" class="ec-btn" id="ecAnalyzeBtn">&#9889; Balance &amp; analyze</button>
            </div>
        </div>
        <div class="ec-preview" id="ecPreview"></div>

        <div class="ec-controls">
            <div class="ec-field">
                <label for="ecMedium">Auto-add (for half-balanced redox)</label>
                <select class="ec-input" id="ecMedium" style="width:auto;">
                    <option value="none">none &mdash; I included everything</option>
                    <option value="acidic">acidic &mdash; add H&#8314;/H&#8322;O</option>
                    <option value="basic">basic &mdash; add OH&#8315;/H&#8322;O</option>
                </select>
            </div>
        </div>

        <p class="ec-hint">Separate species with spaces around <code>+</code> and use <code>=</code> (or <code>&rarr;</code>) between sides. Write ions like <code>Cu+2</code>, <code>Cr2O7-2</code>, <code>MnO4-</code> (pretty <code>Cu&sup2;&#8314;</code> works too). Balancing is checked with <strong>chempy</strong>; everything else is computed instantly.</p>

        <details class="ec-collapse">
            <summary>Examples</summary>
            <div class="ec-collapse-body">
                <div class="ec-chips" id="ecExamples">
                    <span class="ec-chip" data-eq="Zn + Cu+2 = Zn+2 + Cu">Daniell cell</span>
                    <span class="ec-chip" data-eq="Mg + Fe+2 = Mg+2 + Fe">Mg | Fe&sup2;&#8314;</span>
                    <span class="ec-chip" data-eq="Fe+2 + Cr2O7-2 + H+ = Fe+3 + Cr+3 + H2O">dichromate + Fe&sup2;&#8314;</span>
                    <span class="ec-chip" data-eq="MnO4- + Fe+2 + H+ = Mn+2 + Fe+3 + H2O">permanganate titration</span>
                    <span class="ec-chip" data-eq="Cu + Ag+ = Cu+2 + Ag">Cu + Ag&#8314;</span>
                    <span class="ec-chip" data-eq="Al + O2 = Al2O3">aluminium + O&#8322;</span>
                    <span class="ec-chip" data-eq-medium="basic" data-eq="MnO4- + I- = MnO2 + I2">MnO&#8324;&#8315; + I&#8315; (basic)</span>
                </div>
            </div>
        </details>

        <details class="ec-collapse">
            <summary>Standard reduction potentials (E&deg;) reference</summary>
            <div class="ec-collapse-body">
                <input type="text" class="ec-input ec-ref-search" id="ecRefSearch" placeholder="Search couple, e.g. Cu, MnO4, halogen…" style="width:100%;">
                <div class="ec-ref-wrap">
                    <table class="ec-ref">
                        <thead><tr><th>Half-reaction (reduction)</th><th>E&deg; (V)</th><th></th></tr></thead>
                        <tbody id="ecRefBody"></tbody>
                    </table>
                </div>
                <p class="ec-hint">Click <strong>cathode</strong> / <strong>anode</strong> to drop a value into the cell-potential fields below.</p>
            </div>
        </details>
    </div>

    <!-- ===== Analysis (balanced + n) ===== -->
    <div class="ec-card" id="ecAnalysisCard" style="display:none;">
        <div class="ec-card-head"><span style="color:var(--cs-accent);">&#9883;</span><h2>Balanced reaction</h2></div>
        <div id="ecAnalysisBody"></div>
    </div>

    <!-- ===== Cell potential + thermodynamics ===== -->
    <div class="ec-card" id="ecCellCard" style="display:none;">
        <div class="ec-card-head"><span style="color:var(--cs-accent);">&#9211;</span><h2>Cell potential &amp; thermodynamics</h2></div>
        <div class="ec-controls">
            <div class="ec-field">
                <label for="ecEcat">E&deg; cathode (reduction, V)</label>
                <input type="number" step="0.01" class="ec-input num" id="ecEcat" placeholder="e.g. 0.34">
            </div>
            <div class="ec-field">
                <label for="ecEan">E&deg; anode (reduction, V)</label>
                <input type="number" step="0.01" class="ec-input num" id="ecEan" placeholder="e.g. -0.76">
            </div>
            <div class="ec-field">
                <label for="ecN">n (electrons)</label>
                <input type="number" step="1" min="1" class="ec-input num" id="ecN" style="width:5rem;">
            </div>
        </div>
        <p class="ec-hint">E&deg;<sub class="ec-s">cell</sub> = E&deg;<sub class="ec-s">cathode</sub> &minus; E&deg;<sub class="ec-s">anode</sub> (both as <em>reduction</em> potentials). Fill from the reference table above if you don't have them.</p>
        <div id="ecCellOut"></div>
    </div>

    <!-- ===== Nernst ===== -->
    <div class="ec-card" id="ecNernstCard" style="display:none;">
        <div class="ec-card-head"><span style="color:var(--cs-accent);">&#8776;</span><h2>Nernst equation (non-standard conditions)</h2></div>
        <div class="ec-controls" id="ecNernstInputs"></div>
        <p class="ec-hint">E = E&deg;<sub class="ec-s">cell</sub> &minus; (RT/nF)&middot;ln Q. Pure solids &amp; liquids (metals, H&#8322;O) are fixed at activity 1. Set concentrations (mol/L) or gas pressures (atm).</p>
        <div id="ecNernstOut"></div>
    </div>

    <!-- ===== Faraday / electrolysis (independent) ===== -->
    <details class="ec-collapse" id="ecFaradayWrap" style="border-radius:var(--cs-radius-lg);">
        <summary style="padding:1rem 1.25rem;">&#9211; Electrolysis &mdash; Faraday's laws (mass deposited / gas evolved)</summary>
        <div class="ec-collapse-body" style="padding:1.25rem;">
            <div class="ec-controls">
                <div class="ec-field">
                    <label for="ecFdSpecies">Deposited species</label>
                    <input type="text" class="ec-input" id="ecFdSpecies" placeholder="Cu, Ag, Al, H2, O2…" style="width:9rem;">
                </div>
                <div class="ec-field">
                    <label for="ecFdN">electrons / ion (n)</label>
                    <input type="number" class="ec-input num" id="ecFdN" min="1" value="2" style="width:6rem;">
                </div>
                <div class="ec-field">
                    <label for="ecFdI">Current I (A)</label>
                    <input type="number" class="ec-input num" id="ecFdI" step="0.01" placeholder="e.g. 2">
                </div>
                <div class="ec-field">
                    <label for="ecFdT">Time</label>
                    <div style="display:flex;gap:0.3rem;">
                        <input type="number" class="ec-input num" id="ecFdT" step="0.1" placeholder="e.g. 30" style="width:5.5rem;">
                        <select class="ec-input" id="ecFdTUnit" style="width:auto;">
                            <option value="60">min</option>
                            <option value="1">sec</option>
                            <option value="3600">hr</option>
                        </select>
                    </div>
                </div>
            </div>
            <p class="ec-hint">m = (Q&middot;M)/(n&middot;F), Q = I&middot;t, mol e&#8315; = Q/F. Molar mass M is looked up from the formula. For a gas, the volume at STP (22.414 L/mol) is shown too.</p>
            <div id="ecFaradayOut"></div>
        </div>
    </details>

    <div class="cs-inline-ad">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <!-- Visible FAQ -->
    <section class="cs-faq-wrap" style="max-width:100%;margin-top:0.5rem;padding:0;">
        <h2 class="cs-faq-title" id="faqs">Frequently asked</h2>
        <div class="cs-faq" aria-label="Electrochemistry FAQ">
            <div class="cs-faq-item">
                <button class="cs-faq-q" type="button">How do I find the number of electrons transferred (n)?
                    <svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="cs-faq-a">Write the reaction and click <strong>Balance &amp; analyze</strong>. chempy balances it and the tool reads each element's oxidation-state change to report <strong>n</strong> automatically. You can override n if your reaction is unusual.</div>
            </div>
            <div class="cs-faq-item">
                <button class="cs-faq-q" type="button">How is the cell potential calculated?
                    <svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="cs-faq-a">E&deg;<sub>cell</sub> = E&deg;<sub>cathode</sub> &minus; E&deg;<sub>anode</sub>, with both values as standard <em>reduction</em> potentials. From E&deg;<sub>cell</sub> the tool also gives &Delta;G&deg; = &minus;nFE&deg; and K = e^(nFE&deg;/RT).</div>
            </div>
            <div class="cs-faq-item">
                <button class="cs-faq-q" type="button">Can it balance redox reactions in acidic or basic solution?
                    <svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="cs-faq-a">Yes. Either include H&#8314;/H&#8322;O (or OH&#8315;) yourself, or set the <strong>Auto-add</strong> option to acidic or basic and the balancer adds them.</div>
            </div>
            <div class="cs-faq-item">
                <button class="cs-faq-q" type="button">What is the Nernst equation used for?
                    <svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
                <div class="cs-faq-a">It gives the cell potential at non-standard concentrations/temperature: E = E&deg;<sub>cell</sub> &minus; (RT/nF)&middot;ln Q. Enter the species' concentrations and the tool computes Q and E.</div>
            </div>
        </div>
    </section>

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

  // ── Standard reduction potentials (V), reduction form ───────────────
  var POTENTIALS = {
    'F2/F-':      { eq:'F₂ + 2e⁻ → 2F⁻', E0:2.87 },
    'H2O2/H2O':   { eq:'H₂O₂ + 2H⁺ + 2e⁻ → 2H₂O', E0:1.78 },
    'MnO4-/Mn2+': { eq:'MnO₄⁻ + 8H⁺ + 5e⁻ → Mn²⁺ + 4H₂O', E0:1.51 },
    'PbO2/Pb2+':  { eq:'PbO₂ + 4H⁺ + 2e⁻ → Pb²⁺ + 2H₂O', E0:1.46 },
    'Cl2/Cl-':    { eq:'Cl₂ + 2e⁻ → 2Cl⁻', E0:1.36 },
    'Cr2O7/Cr3+': { eq:'Cr₂O₇²⁻ + 14H⁺ + 6e⁻ → 2Cr³⁺ + 7H₂O', E0:1.33 },
    'O2/H2O':     { eq:'O₂ + 4H⁺ + 4e⁻ → 2H₂O', E0:1.23 },
    'MnO2/Mn2+':  { eq:'MnO₂ + 4H⁺ + 2e⁻ → Mn²⁺ + 2H₂O', E0:1.23 },
    'Br2/Br-':    { eq:'Br₂ + 2e⁻ → 2Br⁻', E0:1.07 },
    'NO3-/NO':    { eq:'NO₃⁻ + 4H⁺ + 3e⁻ → NO + 2H₂O', E0:0.96 },
    'Ag+/Ag':     { eq:'Ag⁺ + e⁻ → Ag', E0:0.80 },
    'Fe3+/Fe2+':  { eq:'Fe³⁺ + e⁻ → Fe²⁺', E0:0.77 },
    'I2/I-':      { eq:'I₂ + 2e⁻ → 2I⁻', E0:0.54 },
    'Cu2+/Cu':    { eq:'Cu²⁺ + 2e⁻ → Cu', E0:0.34 },
    'Sn4+/Sn2+':  { eq:'Sn⁴⁺ + 2e⁻ → Sn²⁺', E0:0.15 },
    'H+/H2':      { eq:'2H⁺ + 2e⁻ → H₂', E0:0.00 },
    'Pb2+/Pb':    { eq:'Pb²⁺ + 2e⁻ → Pb', E0:-0.13 },
    'Sn2+/Sn':    { eq:'Sn²⁺ + 2e⁻ → Sn', E0:-0.14 },
    'Ni2+/Ni':    { eq:'Ni²⁺ + 2e⁻ → Ni', E0:-0.25 },
    'Co2+/Co':    { eq:'Co²⁺ + 2e⁻ → Co', E0:-0.28 },
    'Fe2+/Fe':    { eq:'Fe²⁺ + 2e⁻ → Fe', E0:-0.44 },
    'Cr3+/Cr':    { eq:'Cr³⁺ + 3e⁻ → Cr', E0:-0.74 },
    'Zn2+/Zn':    { eq:'Zn²⁺ + 2e⁻ → Zn', E0:-0.76 },
    'Mn2+/Mn':    { eq:'Mn²⁺ + 2e⁻ → Mn', E0:-1.18 },
    'Al3+/Al':    { eq:'Al³⁺ + 3e⁻ → Al', E0:-1.66 },
    'Mg2+/Mg':    { eq:'Mg²⁺ + 2e⁻ → Mg', E0:-2.37 },
    'Na+/Na':     { eq:'Na⁺ + e⁻ → Na', E0:-2.71 },
    'Ca2+/Ca':    { eq:'Ca²⁺ + 2e⁻ → Ca', E0:-2.87 },
    'K+/K':       { eq:'K⁺ + e⁻ → K', E0:-2.93 },
    'Li+/Li':     { eq:'Li⁺ + e⁻ → Li', E0:-3.05 }
  };

  // ── Atomic weights for Faraday molar mass ───────────────────────────
  var AW = { H:1.008, Li:6.94, Be:9.012, B:10.81, C:12.011, N:14.007, O:15.999, F:18.998,
    Na:22.99, Mg:24.305, Al:26.982, Si:28.085, P:30.974, S:32.06, Cl:35.45, K:39.098,
    Ca:40.078, Cr:51.996, Mn:54.938, Fe:55.845, Co:58.933, Ni:58.693, Cu:63.546, Zn:65.38,
    Br:79.904, Ag:107.868, Sn:118.71, I:126.904, Ba:137.327, Pt:195.084, Au:196.967, Pb:207.2 };

  var F = 96485, R = 8.314, T0 = 298.15;

  // ── Pretty rendering (sub counts, sup charges, e-, arrows) ──────────
  var SUBD = '₀₁₂₃₄₅₆₇₈₉';
  var SUPD = '⁰¹²³⁴⁵⁶⁷⁸⁹';
  function sub(s){ return String(s).replace(/[0-9]/g, function(d){ return SUBD[+d]; }); }
  function supCharge(sign, num){ var n = num ? String(num).replace(/[0-9]/g, function(d){ return SUPD[+d]; }) : ''; return n + (sign === '+' ? '⁺' : '⁻'); }
  function prettySp(sp){
    if (sp === 'e-' || sp === 'e') return 'e⁻';
    var m = sp.match(/^(.+?)([+-])(\d*)$/);
    var core = sp, chg = '';
    if (m){ core = m[1]; chg = supCharge(m[2], m[3]); }
    core = core.replace(/[0-9]+/g, function(d){ return sub(d); });
    return core + chg;
  }
  function sideHtml(arr){
    return arr.map(function(x){ return '<span class="ec-coef">' + (x.n > 1 ? x.n + ' ' : '') + '</span>' + prettySp(x.sp); }).join('<span class="ec-op">+</span>');
  }

  // ── Normalisation: pretty → ascii chempy form ───────────────────────
  // Charges come from SUPERSCRIPT chars, counts from SUBSCRIPT/normal digits.
  // Convert charges first (²⁺ → +2, ⁻ → -) so we never confuse a subscript
  // count like the 4 in MnO4⁻ with a charge magnitude.
  var _SUP = { '⁰':'0','¹':'1','²':'2','³':'3','⁴':'4','⁵':'5','⁶':'6','⁷':'7','⁸':'8','⁹':'9' };
  var _SUB = { '₀':'0','₁':'1','₂':'2','₃':'3','₄':'4','₅':'5','₆':'6','₇':'7','₈':'8','₉':'9' };
  function toAscii(str){
    var s = String(str).replace(/·/g, '.').replace(/[—−]/g, '-');
    s = s.replace(/([⁰¹²³⁴⁵⁶⁷⁸⁹]*)([⁺⁻])/g, function(_m, digs, sign){
      var num = digs.replace(/[⁰¹²³⁴⁵⁶⁷⁸⁹]/g, function(c){ return _SUP[c]; });
      return (sign === '⁺' ? '+' : '-') + num;        // ²⁺ → +2 ; ⁺ → +
    });
    s = s.replace(/[⁰¹²³⁴⁵⁶⁷⁸⁹]/g, function(c){ return _SUP[c]; });
    s = s.replace(/[₀₁₂₃₄₅₆₇₈₉]/g, function(c){ return _SUB[c]; });
    s = s.replace(/→|⟶|->|=>/g, '=');
    return s;
  }
  function cleanSpecies(tok){
    tok = tok.trim().replace(/\s+/g, '');
    if (!tok) return '';
    tok = tok.replace(/^\d+(?=[A-Za-z(])/, '');     // strip leading coefficient
    if (/^e[-]?$/.test(tok)) return 'e-';
    return tok;                                      // already chempy form (Cu+2, MnO4-)
  }
  function parseEquation(raw){
    var s = toAscii(raw).trim();
    if (s.indexOf('=') === -1) return null;
    var parts = s.split('=');
    if (parts.length !== 2) return null;
    function side(t){ return t.split(/\s+\+\s+/).map(cleanSpecies).filter(Boolean); }
    var reac = side(parts[0]), prod = side(parts[1]);
    if (!reac.length || !prod.length) return null;
    return { reac:reac, prod:prod };
  }

  // ── Live preview ────────────────────────────────────────────────────
  var elEq = document.getElementById('ecEq');
  var elPreview = document.getElementById('ecPreview');
  function renderPreview(){
    var p = parseEquation(elEq.value);
    if (!p){ elPreview.innerHTML = elEq.value.trim() ? '<span class="ec-muted">Use “=” between the two sides, e.g. Zn + Cu+2 = Zn+2 + Cu</span>' : ''; return; }
    var L = p.reac.map(prettySp).join(' <span class="ec-op">+</span> ');
    var Rr = p.prod.map(prettySp).join(' <span class="ec-op">+</span> ');
    elPreview.innerHTML = L + ' <span class="ec-op">→</span> ' + Rr;
  }
  elEq.addEventListener('input', renderPreview);

  // ── chempy runner ───────────────────────────────────────────────────
  function buildCode(reac, prod, medium){
    return [
'import json',
'from chempy import balance_stoichiometry, Substance',
'from chempy.util import periodic',
'reac = ' + JSON.stringify(reac),
'prod = ' + JSON.stringify(prod),
'medium = ' + JSON.stringify(medium),
'add = {"acidic":["H+","H2O"],"basic":["OH-","H2O"],"none":[]}[medium]',
'rset = set(reac) | set(add)',
'pset = set(prod) | set(add)',
'G1=set("Li Na K Rb Cs".split()); G2=set("Be Mg Ca Sr Ba".split())',
'def cc_charge(sp):',
'    s=Substance.from_formula(sp); comp=dict(s.composition); ch=comp.pop(0,0)',
'    return ({periodic.symbols[z-1]:n for z,n in comp.items()}, ch)',
'def ox(sp):',
'    cc,ch=cc_charge(sp)',
'    if len(cc)==1:',
'        (el,n),=cc.items(); return {el: ch/float(n)}',
'    o={}',
'    for el in cc:',
'        if el in G1: o[el]=1',
'        elif el in G2: o[el]=2',
'        elif el=="F": o[el]=-1',
'    if "H" in cc and "H" not in o: o["H"]=1',
'    if "O" in cc and "O" not in o: o["O"]=-2',
'    for h in ("Cl","Br","I"):',
'        if h in cc and h not in o and "O" not in cc and "F" not in cc: o[h]=-1',
'    unk=[el for el in cc if el not in o]',
'    known=sum(o[el]*cc[el] for el in o)',
'    if len(unk)==1:',
'        o[unk[0]]=(ch-known)/float(cc[unk[0]]); return o',
'    if len(unk)==0:',
'        return o if abs(known-ch)<1e-9 else None',
'    return None',
'try:',
'    r,p=balance_stoichiometry(rset,pset)',
'    rl=[{"sp":k,"n":int(r[k])} for k in r if int(r[k])!=0]',
'    pl=[{"sp":k,"n":int(p[k])} for k in p if int(p[k])!=0]',
'    rkeys=set(x["sp"] for x in rl)',
'    delta={}; rst={}; pst={}; good=True',
'    for it in rl+pl:',
'        o=ox(it["sp"])',
'        if o is None: good=False; break',
'        cc,_=cc_charge(it["sp"]); isR=it["sp"] in rkeys; sgn=-1 if isR else 1',
'        for el,v in o.items():',
'            delta[el]=delta.get(el,0)+sgn*it["n"]*cc[el]*v',
'            (rst if isR else pst).setdefault(el,set()).add(round(v,3))',
'    n=None; changes=[]',
'    if good:',
'        tot=sum(abs(v) for v in delta.values()); nn=tot/2.0',
'        if abs(nn-round(nn))<1e-6 and round(nn)>0: n=int(round(nn))',
'        for el,v in delta.items():',
'            if abs(v)>1e-9:',
'                changes.append({"el":el,"d":round(v,3),"frm":sorted(rst.get(el,set())),"to":sorted(pst.get(el,set()))})',
'    res={"ok":True,"reactants":rl,"products":pl,"n":n,"changes":changes}',
'except Exception as e:',
'    res={"ok":False,"error":type(e).__name__+": "+str(e)}',
'print("RESULT:"+json.dumps(res))'
    ].join('\n');
  }
  function runChempy(reac, prod, medium){
    return fetch(RUN + '?action=execute', {
      method:'POST', headers:{'Content-Type':'application/json'},
      body: JSON.stringify({ language:'python', version:'3.11', code: buildCode(reac, prod, medium) })
    }).then(function(r){ return r.json(); }).then(function(data){
      var out = (data.Stdout || data.stdout || data.Output || '').toString().trim();
      var m = out.match(/RESULT:(\{[\s\S]*\})/);
      if (!m) throw new Error((data.Stderr || data.stderr || out || 'No output from chempy').toString().slice(0, 400));
      return JSON.parse(m[1]);
    });
  }

  var current = null;

  // ── Analyze ─────────────────────────────────────────────────────────
  var btn = document.getElementById('ecAnalyzeBtn');
  var aCard = document.getElementById('ecAnalysisCard');
  var aBody = document.getElementById('ecAnalysisBody');
  function analyze(){
    var p = parseEquation(elEq.value);
    aCard.style.display = '';
    if (!p){ aBody.innerHTML = '<div class="ec-err">Write a reaction with “=”, species separated by spaces around “+”. Example: <code>Zn + Cu+2 = Zn+2 + Cu</code></div>'; return; }
    var medium = document.getElementById('ecMedium').value;
    btn.disabled = true; var old = btn.innerHTML; btn.innerHTML = '<span class="ec-spin"></span> Balancing…';
    aBody.innerHTML = '<div class="ec-hint">Balancing with chempy…</div>';
    runChempy(p.reac, p.prod, medium).then(function(res){
      if (!res.ok){ aBody.innerHTML = '<div class="ec-err"><strong>Could not balance.</strong> ' + esc(res.error || '') + '<br>Check formulas/charges, or set Auto-add to acidic/basic if H⁺/H₂O are missing.</div>'; current = null; hide('ecCellCard','ecNernstCard'); return; }
      current = res;
      renderAnalysis(res);
      buildCell(res); buildNernst(res);
    }).catch(function(e){
      aBody.innerHTML = '<div class="ec-err"><strong>Backend error.</strong> ' + esc(e.message || e) + '</div>';
    }).then(function(){ btn.disabled = false; btn.innerHTML = old; });
  }
  btn.addEventListener('click', analyze);
  elEq.addEventListener('keydown', function(e){ if (e.key === 'Enter'){ e.preventDefault(); analyze(); } });

  function fmtOx(x){ if (x === 0) return '0'; var s = (x > 0 ? '+' : '−') + (Math.round(Math.abs(x) * 100) / 100); return s.replace(/\.0+$/, ''); }
  function changeText(c){ return '<strong>' + c.el + '</strong>: ' + (c.frm || []).map(fmtOx).join('/') + ' → ' + (c.to || []).map(fmtOx).join('/'); }
  function renderAnalysis(res){
    var html = '<div class="ec-eqn">' + sideHtml(res.reactants) + ' <span class="ec-op">→</span> ' + sideHtml(res.products) + '</div>';
    var ox = (res.changes || []).filter(function(c){ return c.d > 0; });
    var red = (res.changes || []).filter(function(c){ return c.d < 0; });
    if (ox.length || red.length){
      html += '<div class="ec-halves">';
      html += '<div class="ec-half"><div class="ec-half-lbl">Oxidation (anode) — loses e⁻</div><div class="ec-half-eq">' +
              (ox.map(changeText).join('<br>') || '—') + '</div></div>';
      html += '<div class="ec-half"><div class="ec-half-lbl">Reduction (cathode) — gains e⁻</div><div class="ec-half-eq">' +
              (red.map(changeText).join('<br>') || '—') + '</div></div>';
      html += '</div>';
    } else if (res.n == null){
      html += '<p class="ec-hint">No oxidation-state change was detected (or it couldn’t be assigned automatically). If this is a redox reaction, set <strong>n</strong> manually below; if it isn’t a redox reaction there is no cell potential.</p>';
    }
    html += '<div class="ec-stats"><div class="ec-stat"><span class="ec-stat-lbl">Electrons transferred (n)</span><span class="ec-stat-val">' +
            (res.n != null ? res.n : '—') + '</span><span class="ec-stat-sub">' + (res.n != null ? 'total e⁻ in balanced equation' : 'set manually below') + '</span></div></div>';
    aBody.innerHTML = html;
  }

  // ── Cell potential + thermo (instant JS) ────────────────────────────
  var cellCard = document.getElementById('ecCellCard');
  function buildCell(res){
    cellCard.style.display = '';
    var nIn = document.getElementById('ecN');
    if (res.n != null) nIn.value = res.n;
    tryAutofillE(res);
    computeCell();
  }
  ['ecEcat','ecEan','ecN'].forEach(function(id){ document.getElementById(id).addEventListener('input', function(){ computeCell(); computeNernst(); }); });
  function computeCell(){
    var out = document.getElementById('ecCellOut');
    var ecat = parseFloat(document.getElementById('ecEcat').value);
    var ean  = parseFloat(document.getElementById('ecEan').value);
    var n    = parseInt(document.getElementById('ecN').value, 10);
    if (isNaN(ecat) || isNaN(ean)){ out.innerHTML = '<p class="ec-hint">Enter both standard reduction potentials to get E°cell, ΔG° and K.</p>'; return; }
    var ecell = ecat - ean;
    var html = '<div class="ec-stats">';
    html += stat('E°cell', ecell.toFixed(3) + ' V', 'E°cathode − E°anode');
    if (!isNaN(n) && n > 0){
      var dG = -n * F * ecell;
      var K = Math.exp((n * F * ecell) / (R * T0));
      html += stat('ΔG°', fmtSig(dG / 1000, 4) + ' kJ/mol', '−nFE°cell');
      html += stat('K', fmtK(K), 'at 298.15 K');
    }
    html += '</div>';
    var spont = ecell > 0;
    html += '<div class="ec-verdict ' + (spont ? 'go' : 'nogo') + '">' +
            (spont ? '✓ Spontaneous as written (galvanic): E°cell > 0, ΔG° < 0.'
                   : '✗ Non-spontaneous as written: E°cell < 0 — the reverse reaction is spontaneous (or it needs an external supply).') + '</div>';
    out.innerHTML = html;
  }

  // Index of MONATOMIC couples (element + the two oxidation states) from the
  // table. Auto-fill is only attempted for these — polyatomic couples (MnO4⁻,
  // Cr2O7²⁻ …) are ambiguous to match, so we leave those blank rather than
  // guess a chemically wrong E°. Built once.
  var MONO = {};
  (function(){
    function parseMono(s){
      var m = s.match(/^([A-Z][a-z]?)(\d*)([+-])?$/);
      if (!m) return null;
      var ch = m[3] ? (m[3] === '+' ? 1 : -1) * (m[2] ? +m[2] : 1) : 0;
      return { el:m[1], ch:ch };
    }
    for (var k in POTENTIALS){
      var pr = k.split('/'), a = parseMono(pr[0]), b = parseMono(pr[1]);
      if (!a || !b || a.el !== b.el) continue;
      (MONO[a.el] = MONO[a.el] || []).push({ hi:Math.max(a.ch, b.ch), lo:Math.min(a.ch, b.ch), E0:POTENTIALS[k].E0 });
    }
  })();
  function lookupCouple(el, hi, lo){
    var arr = MONO[el]; if (!arr) return null;
    for (var i = 0; i < arr.length; i++){ if (Math.abs(arr[i].hi - hi) < 0.01 && Math.abs(arr[i].lo - lo) < 0.01) return arr[i].E0; }
    return null;
  }
  function tryAutofillE(res){
    try {
      var ec = document.getElementById('ecEcat'), ea = document.getElementById('ecEan');
      (res.changes || []).forEach(function(c){
        if (!c.frm || !c.to || c.frm.length !== 1 || c.to.length !== 1) return; // only clean monatomic couples
        var hi = Math.max(c.frm[0], c.to[0]), lo = Math.min(c.frm[0], c.to[0]);
        var E0 = lookupCouple(c.el, hi, lo);
        if (E0 == null) return;
        if (c.d < 0 && !ec.value) ec.value = E0;   // element reduced → cathode
        if (c.d > 0 && !ea.value) ea.value = E0;   // element oxidised → anode (its reduction potential)
      });
    } catch (e) {}
  }

  // ── Nernst (instant JS) ─────────────────────────────────────────────
  var nernstCard = document.getElementById('ecNernstCard');
  var GAS = { 'H2':1,'O2':1,'N2':1,'F2':1,'Cl2':1,'Br2':1,'I2':1,'O3':1,'CO2':1,'NO':1,'NO2':1,'SO2':1 };
  // Only aqueous ions and gases appear in Q; pure solids & liquids (metals,
  // H2O, neutral solids like Al2O3) are fixed at activity 1.
  function isActive(sp){
    if (/[+-]\d*$/.test(sp)) return true;   // aqueous ion
    if (GAS[sp]) return true;               // gas → partial pressure
    return false;                           // neutral solid / liquid
  }
  function buildNernst(res){
    var inputs = document.getElementById('ecNernstInputs');
    var species = [];
    res.reactants.forEach(function(x){ species.push({ sp:x.sp, n:x.n, side:'r' }); });
    res.products.forEach(function(x){ species.push({ sp:x.sp, n:x.n, side:'p' }); });
    var active = species.filter(function(s){ return isActive(s.sp); });
    if (!active.length){ nernstCard.style.display = 'none'; return; }
    nernstCard.style.display = '';
    var html = '<div class="ec-field"><label for="ecTemp">T (K)</label><input type="number" class="ec-input num" id="ecTemp" value="298.15" step="1"></div>';
    active.forEach(function(s){
      html += '<div class="ec-field"><label>' + (GAS[s.sp] ? 'P ' : '[') + prettySp(s.sp) + (GAS[s.sp] ? ' (atm)' : '] (M)') + '</label>' +
              '<input type="number" class="ec-input num ec-nernst-c" data-n="' + s.n + '" data-side="' + s.side + '" value="1" step="0.01" min="0"></div>';
    });
    inputs.innerHTML = html;
    inputs.querySelectorAll('input').forEach(function(el){ el.addEventListener('input', computeNernst); });
    computeNernst();
  }
  function computeNernst(){
    var out = document.getElementById('ecNernstOut');
    if (!out || nernstCard.style.display === 'none') return;
    var ecat = parseFloat(document.getElementById('ecEcat').value);
    var ean  = parseFloat(document.getElementById('ecEan').value);
    var n    = parseInt(document.getElementById('ecN').value, 10);
    var tEl  = document.getElementById('ecTemp');
    var T    = tEl ? (parseFloat(tEl.value) || T0) : T0;
    var Q = 1, ok = true;
    document.querySelectorAll('.ec-nernst-c').forEach(function(el){
      var c = parseFloat(el.value), coef = parseInt(el.getAttribute('data-n'), 10) || 1;
      if (isNaN(c) || c <= 0){ ok = false; return; }
      Q *= Math.pow(c, (el.getAttribute('data-side') === 'p' ? 1 : -1) * coef);
    });
    if (isNaN(ecat) || isNaN(ean) || isNaN(n) || n <= 0){ out.innerHTML = '<p class="ec-hint">Set E° values and n above to compute E from the Nernst equation.</p>'; return; }
    if (!ok){ out.innerHTML = '<p class="ec-hint">Enter positive concentrations/pressures.</p>'; return; }
    var ecell = ecat - ean;
    var rtnf = (R * T) / (n * F);
    var E = ecell - rtnf * Math.log(Q);
    out.innerHTML = '<div class="ec-stats">' +
      stat('Q', fmtSig(Q, 4), 'reaction quotient') +
      stat('RT/nF', rtnf.toFixed(5) + ' V', 'T = ' + T + ' K') +
      stat('E (cell)', E.toFixed(3) + ' V', 'Nernst, non-standard') +
      '</div>';
  }

  // ── Faraday / electrolysis (instant JS) ─────────────────────────────
  function molarMass(formula){
    var f = toAscii(formula).replace(/[+-]\d*$/, '').replace(/\s+/g, '');
    var re = /([A-Z][a-z]?)(\d*)/g, m, mass = 0, any = false;
    while ((m = re.exec(f)) !== null){
      if (!m[1]) continue;
      if (!(m[1] in AW)) return null;
      mass += AW[m[1]] * (m[2] ? parseInt(m[2], 10) : 1); any = true;
    }
    return any ? mass : null;
  }
  ['ecFdSpecies','ecFdN','ecFdI','ecFdT','ecFdTUnit'].forEach(function(id){ var el = document.getElementById(id); el.addEventListener('input', computeFaraday); el.addEventListener('change', computeFaraday); });
  function computeFaraday(){
    var out = document.getElementById('ecFaradayOut');
    var sp = document.getElementById('ecFdSpecies').value.trim();
    var n  = parseInt(document.getElementById('ecFdN').value, 10);
    var I  = parseFloat(document.getElementById('ecFdI').value);
    var t  = parseFloat(document.getElementById('ecFdT').value);
    var tu = parseFloat(document.getElementById('ecFdTUnit').value) || 1;
    if (isNaN(I) || isNaN(t) || isNaN(n) || n <= 0){ out.innerHTML = '<p class="ec-hint">Enter current, time and electrons per ion.</p>'; return; }
    var Q = I * t * tu, molE = Q / F;
    var html = '<div class="ec-stats">' + stat('Charge Q', fmtSig(Q, 5) + ' C', 'I × t') + stat('mol e⁻', fmtSig(molE, 4), 'Q / F');
    if (sp){
      var M = molarMass(sp);
      if (M == null){ html += stat('mass', '—', 'unknown formula'); }
      else {
        var molSub = molE / n, mass = molSub * M;
        html += stat('mol ' + sp, fmtSig(molSub, 4), 'mol e⁻ / n');
        html += stat('mass', fmtSig(mass, 4) + ' g', M.toFixed(2) + ' g/mol');
        if (GAS[toAscii(sp)]) html += stat('V at STP', fmtSig(molSub * 22.414, 4) + ' L', '22.414 L/mol');
      }
    }
    html += '</div>';
    out.innerHTML = html;
  }

  // ── Reference table ─────────────────────────────────────────────────
  function renderRef(filter){
    var body = document.getElementById('ecRefBody');
    var q = (filter || '').toLowerCase();
    var keys = Object.keys(POTENTIALS).sort(function(a, b){ return POTENTIALS[b].E0 - POTENTIALS[a].E0; });
    var rows = '';
    keys.forEach(function(k){
      var d = POTENTIALS[k];
      if (q && k.toLowerCase().indexOf(q) === -1 && d.eq.toLowerCase().indexOf(q) === -1) return;
      rows += '<tr><td>' + d.eq + '</td><td class="ec-e0">' + d.E0.toFixed(2) + '</td>' +
              '<td><span class="ec-ref-fill"><button type="button" data-v="' + d.E0 + '" data-f="cat">cathode</button>' +
              '<button type="button" data-v="' + d.E0 + '" data-f="an">anode</button></span></td></tr>';
    });
    body.innerHTML = rows || '<tr><td colspan="3" style="color:var(--cs-muted);padding:1rem;">No match.</td></tr>';
  }
  document.getElementById('ecRefBody').addEventListener('click', function(e){
    var b = e.target.closest('button'); if (!b) return;
    var fld = b.getAttribute('data-f') === 'cat' ? 'ecEcat' : 'ecEan';
    cellCard.style.display = '';
    document.getElementById(fld).value = b.getAttribute('data-v');
    computeCell(); computeNernst();
    if (typeof ToolUtils !== 'undefined' && ToolUtils.showToast) ToolUtils.showToast('Filled E° ' + (fld === 'ecEcat' ? 'cathode' : 'anode'), 1400, 'success');
  });
  document.getElementById('ecRefSearch').addEventListener('input', function(){ renderRef(this.value); });

  // ── Examples ────────────────────────────────────────────────────────
  document.getElementById('ecExamples').addEventListener('click', function(e){
    var c = e.target.closest('.ec-chip'); if (!c) return;
    elEq.value = c.getAttribute('data-eq');
    var med = c.getAttribute('data-eq-medium'); document.getElementById('ecMedium').value = med || 'none';
    renderPreview(); analyze();
  });

  // ── FAQ accordion ───────────────────────────────────────────────────
  document.querySelectorAll('.cs-faq-q').forEach(function(b){
    b.addEventListener('click', function(){ var it = b.closest('.cs-faq-item'); if (it) it.classList.toggle('open'); });
  });

  // ── helpers ─────────────────────────────────────────────────────────
  function stat(lbl, val, sb){ return '<div class="ec-stat"><span class="ec-stat-lbl">' + lbl + '</span><span class="ec-stat-val">' + val + '</span>' + (sb ? '<span class="ec-stat-sub">' + sb + '</span>' : '') + '</div>'; }
  function hide(){ for (var i = 0; i < arguments.length; i++){ var el = document.getElementById(arguments[i]); if (el) el.style.display = 'none'; } }
  function esc(s){ return String(s).replace(/[&<>"]/g, function(c){ return { '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;' }[c]; }); }
  function fmtSig(x, sig){ if (!isFinite(x)) return '∞'; if (x === 0) return '0'; var a = Math.abs(x); if (a >= 1e5 || a < 1e-3) return x.toExponential(Math.max(0, sig - 1)); return (+x.toPrecision(sig)).toString(); }
  function fmtK(K){ if (!isFinite(K)) return '∞'; if (K >= 1e6 || (K < 1e-3 && K > 0)) return K.toExponential(2); return (+K.toPrecision(4)).toString(); }

  renderRef('');
  renderPreview();
})();
</script>
</body>
</html>
