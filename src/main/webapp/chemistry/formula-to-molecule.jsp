<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<jsp:include page="../modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="Molecular Formula to Structure &amp; 3D Viewer" />
    <jsp:param name="toolCategory" value="Chemistry" />
    <jsp:param name="toolDescription" value="Turn a chemical formula like C6H12O6 into molecules: see 2D &amp; 3D structures, Lewis dot diagrams and SMILES, plus balance equations and predict products." />
    <jsp:param name="toolUrl" value="chemistry/formula-to-molecule.jsp" />
    <jsp:param name="toolKeywords" value="molecular formula to structure, formula to structure, chemical formula to structure, formula to smiles, smiles from formula, draw molecule from formula, structure from molecular formula, molecular structure viewer, 3d molecule viewer online, lewis structure from formula, formula to molecule, what does a molecule look like" />
    <jsp:param name="toolImage" value="formula-to-structure-og.png" />
    <jsp:param name="breadcrumbCategoryUrl" value="chemistry/" />
    <jsp:param name="educationalLevel" value="High School, Undergraduate" />
    <jsp:param name="teaches" value="Molecular structure, Lewis structures, SMILES notation, chemical formulas, balancing equations" />
    <jsp:param name="toolFeatures" value="2D structure from any molecular formula,Interactive 3D molecular model,Lewis dot structure,SMILES output with one-click copy,Balance chemical equations,Predict reaction products,Download structure images" />
    <jsp:param name="hasSteps" value="true" />
    <jsp:param name="howToSteps" value="Enter a formula|Type a molecular formula like C6H12O6 or H2O — or a full equation to balance,See matching structures|Each matching compound appears with its 2D structure and SMILES,Explore in 3D and Lewis|Open the interactive 3D model or the Lewis dot structure for any result,Copy or download|Copy the SMILES string or download the structure image" />
    <jsp:param name="faq1q" value="How do I find a molecule's structure from its chemical formula?" />
    <jsp:param name="faq1a" value="Type a molecular formula such as C6H12O6, C10H14N2 or H2O. The tool instantly shows every matching compound with its 2D structure, an interactive 3D model, the Lewis dot structure, and the SMILES string." />
    <jsp:param name="faq2q" value="Can one molecular formula have more than one structure?" />
    <jsp:param name="faq2a" value="Yes. Many formulas are shared by several compounds called isomers — for example C2H6O is both ethanol and dimethyl ether. The tool lists each matching compound so you can compare them." />
    <jsp:param name="faq3q" value="Can I view and rotate the molecule in 3D?" />
    <jsp:param name="faq3a" value="Yes. Click 3D on any result for an interactive model you can rotate and zoom, switch between ball-and-stick, space-filling and wireframe, toggle hydrogens, animate it, and download it as a PNG image or as coordinates (SDF, JSON, XML)." />
    <jsp:param name="faq4q" value="What is SMILES and how do I copy it?" />
    <jsp:param name="faq4a" value="SMILES is a compact text notation for a molecule's structure. Every result shows its SMILES string with a one-click copy button so you can paste it into other chemistry software." />
    <jsp:param name="faq5q" value="Can it balance chemical equations and predict products?" />
    <jsp:param name="faq5a" value="Yes. Enter a full equation with an equals sign, like Fe + Cl2 = FeCl3, to balance it — or type just the reactants, like C + O2, to predict and balance the products." />
    <jsp:param name="faq6q" value="Is the tool free?" />
    <jsp:param name="faq6a" value="Yes. It is completely free, runs in your browser, and needs no signup." />
</jsp:include>
<!-- "Quiet place" studio fonts (Inter + Instrument Serif), plus Fira Code for formulas -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Instrument+Serif:ital@0;1&family=Fira+Code:wght@400;500&display=swap" media="print" onload="this.media='all'">
<noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Instrument+Serif:ital@0;1&family=Fira+Code:wght@400;500&display=swap"></noscript>
<!-- Site chrome CSS (styles the shared nav-header). Same bundles as the tool pages. -->
<link rel="stylesheet" href="<%=ctx%>/modern/css/tool-page-bundle.css">
<!-- "A quiet place for chemistry" studio layout (shared sidebar / workspace). -->
<link rel="stylesheet" href="<%=ctx%>/chemistry/css/chemistry-studio.css?v=<%=System.currentTimeMillis()%>">
<link rel="preload" href="<%=ctx%>/modern/css/tool-page-deferred.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
<noscript><link rel="stylesheet" href="<%=ctx%>/modern/css/tool-page-deferred.css"></noscript>
<style>
  /* Map the tool's local tokens onto the shared "quiet place" studio palette
     (defined in biology-studio.css, light + [data-theme=dark]). Keeps this
     tool visually consistent with math/ and biology/. */
  :root{
    --bg: var(--cs-page-bg, #f7f6f3);
    --surface: var(--cs-panel-bg, #fefdfb);
    --surface2: var(--cs-panel-bg-soft, #faf8f4);
    --border: var(--cs-line, rgba(28,25,23,0.08));
    --text: var(--cs-ink, #1c1917);
    --text2: var(--cs-muted, #78716c);
    --accent: var(--cs-accent, #6d5efc);
    --accent2: #2f7d54;
    --danger: #c0392b;
    --radius: var(--cs-radius-sm, 10px);
  }
  *{box-sizing:border-box}
  /* Offset the fixed site nav (72px desktop / 64px mobile) */
  body{margin:0;padding-top:var(--header-height-desktop,72px);font-family:var(--cs-font-sans,'Inter',system-ui,sans-serif);background:var(--bg);color:var(--text);line-height:1.5}
  h1{font-family:var(--cs-font-serif,'Instrument Serif',Georgia,serif);font-weight:600}
  @media (max-width:768px){ body{padding-top:var(--header-height-mobile,64px)} }
  a{color:var(--accent);text-decoration:none}
  a:hover{text-decoration:underline}
  .wrap{max-width:1080px;margin:0 auto;padding:24px 18px 60px}
  .crumb{font-size:.82rem;color:var(--text2);margin-bottom:14px}
  h1{font-size:1.6rem;font-weight:700;margin:0 0 6px}
  .sub{color:var(--text2);font-size:.95rem;margin:0 0 22px;max-width:640px}
  .searchbar{display:flex;gap:10px;flex-wrap:wrap;align-items:center}
  .f-input{flex:1 1 280px;min-width:0;background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);color:var(--text);font-size:1.05rem;padding:13px 15px;font-family:'Fira Code',ui-monospace,monospace;outline:none}
  .f-input:focus{border-color:var(--accent)}
  .f-btn{background:var(--accent);color:#fff;border:none;border-radius:var(--radius);padding:13px 22px;font-size:1rem;font-weight:600;cursor:pointer;white-space:nowrap}
  .f-btn:hover{filter:brightness(1.08)}
  .f-btn:disabled{opacity:.55;cursor:not-allowed}
  .chips{margin:14px 0 4px;display:flex;gap:8px;flex-wrap:wrap;align-items:center}
  .chips .lbl{font-size:.8rem;color:var(--text2)}
  .chip{background:var(--surface2);border:1px solid var(--border);color:var(--text);border-radius:999px;padding:5px 12px;font-size:.82rem;cursor:pointer;font-family:'Fira Code',ui-monospace,monospace}
  .chip:hover{border-color:var(--accent);color:var(--accent)}
  .status{margin:20px 0 0;font-size:.92rem;color:var(--text2);min-height:1.2em}
  .status.err{color:var(--danger)}
  .grid{margin-top:18px;display:grid;grid-template-columns:repeat(auto-fill,minmax(260px,1fr));gap:14px}
  .card{background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:14px;display:flex;flex-direction:column;gap:10px}
  .card .struct{background:#fff;border-radius:8px;min-height:170px;display:flex;align-items:center;justify-content:center;overflow:hidden}
  .card .struct svg{max-width:100%;height:auto}
  .card .struct .fail{color:#64748b;font-size:.8rem;padding:18px}
  .card .cid{font-size:.78rem;color:var(--text2)}
  .card .smi{font-family:'Fira Code',ui-monospace,monospace;font-size:.82rem;word-break:break-all;background:var(--surface2);border:1px solid var(--border);border-radius:8px;padding:8px 10px}
  .card .row{display:flex;gap:8px;flex-wrap:wrap}
  .mini{font-size:.78rem;padding:6px 11px;border-radius:8px;border:1px solid var(--border);background:var(--surface2);color:var(--text);cursor:pointer;text-decoration:none;display:inline-flex;align-items:center;gap:5px}
  .mini:hover{border-color:var(--accent);color:var(--accent);text-decoration:none}
  /* Compound detail popover (PubChem computed properties, on hover / tap ⓘ) */
  .mol-pop{position:fixed;z-index:1200;width:300px;max-width:calc(100vw - 24px);background:var(--surface);border:1px solid var(--border);border-radius:10px;box-shadow:0 10px 30px rgba(0,0,0,.22);padding:12px 14px;font-size:.82rem;color:var(--text);opacity:0;transform:translateY(4px);transition:opacity .12s,transform .12s;pointer-events:none}
  .mol-pop.show{opacity:1;transform:none}
  .mol-pop h4{margin:0 0 2px;font-size:.9rem;font-weight:700;color:var(--text)}
  .mol-pop h4 .formula-sub{font-family:'Fira Code',ui-monospace,monospace}
  .mol-pop .pop-name{font-size:.8rem;color:var(--accent);margin:0 0 8px;word-break:break-word;line-height:1.35}
  .mol-pop table{width:100%;border-collapse:collapse}
  .mol-pop td{padding:2px 0;vertical-align:top}
  .mol-pop td.k{color:var(--text2);padding-right:10px;white-space:nowrap}
  .mol-pop td.v{text-align:right;font-family:'Fira Code',ui-monospace,monospace;word-break:break-all}
  .mol-pop .pop-foot{margin-top:8px;font-size:.7rem;color:var(--text2)}
  .mol-pop .pop-load{display:flex;align-items:center;gap:8px;color:var(--text2)}
  .note{margin-top:26px;font-size:.8rem;color:var(--text2);border-top:1px solid var(--border);padding-top:14px}
  .spin{display:inline-block;width:13px;height:13px;border:2px solid var(--border);border-top-color:var(--accent);border-radius:50%;animation:sp .7s linear infinite;vertical-align:-2px;margin-right:6px}
  @keyframes sp{to{transform:rotate(360deg)}}
  /* Element breakdown banner (computed via Python on OneCompiler) */
  .breakdown{margin:16px 0 0;display:flex;align-items:center;gap:12px;flex-wrap:wrap;background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:12px 16px;font-family:'Fira Code',ui-monospace,monospace;font-size:.95rem}
  .breakdown[hidden]{display:none}
  .breakdown .bd-label{font-size:.72rem;color:var(--text2);font-family:'DM Sans',sans-serif;text-transform:uppercase;letter-spacing:.05em}
  .breakdown .bd-formula{font-weight:700;color:var(--text)}
  .breakdown .bd-arrow{color:var(--text2)}
  .breakdown .bd-note{font-size:.72rem;color:var(--text2);font-family:'DM Sans',sans-serif;font-style:italic;flex-basis:100%;cursor:help}
  .breakdown .bd-parts{color:var(--accent2);font-weight:600}
  /* Balanced-equation result card */
  .eqn-card{grid-column:1 / -1;background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:22px 18px;text-align:center}
  .eqn-line{font-family:'Fira Code',ui-monospace,monospace;font-size:1.35rem;font-weight:600;color:var(--text);line-height:1.9;word-break:break-word}
  .eqn-arrow{color:var(--accent);margin:0 14px;font-weight:700}
  .eqn-actions{margin-top:10px;display:flex;gap:8px;flex-wrap:wrap}
  .eqn-figure{margin-top:18px;background:#fff;border-radius:12px;padding:12px;overflow-x:auto;text-align:center;border:1px solid var(--border)}
  .eqn-figure img{max-width:100%;height:auto;display:inline-block}
  .eqn-species{margin-top:16px;display:flex;flex-wrap:wrap;gap:8px;align-items:center}
  .eqn-species-lbl{font-size:.8rem;color:var(--text2)}
  .eqn-chip{font-family:'Fira Code',ui-monospace,monospace;font-size:.85rem;padding:5px 12px;border:1px solid var(--border);background:var(--surface2);color:var(--text);border-radius:999px;cursor:pointer}
  .eqn-chip:hover{border-color:var(--accent);color:var(--accent)}
  .eqn-note{margin-top:14px;font-size:.8rem;color:var(--text2)}
  .eqn-visual{margin-top:20px;border-top:1px solid var(--border);padding-top:18px}
  .eq-tile-link{cursor:pointer;border-radius:8px;padding:6px;transition:background .15s}
  .eq-tile-link:hover{background:var(--surface2)}
  .eq-tile-link .eq-more{margin-top:4px;font-size:.7rem;color:var(--accent)}
  .eq-back{display:inline-flex;align-items:center;gap:6px;margin-bottom:14px;background:var(--surface2);border:1px solid var(--border);color:var(--text);border-radius:8px;padding:7px 13px;font-size:.85rem;cursor:pointer;font-family:inherit}
  .eq-back:hover{border-color:var(--accent);color:var(--accent)}
  .eq-dl{margin-left:14px;vertical-align:middle}
  .mol3d-modal{max-width:780px}
  .mol3d-viewer{position:relative;width:100%;height:min(58vh,440px);background:#fff;border-radius:10px;overflow:hidden}
  .lewis-modal{max-width:1060px}
  .lewis-frame{width:100%;height:min(74vh,760px);border:1px solid var(--border);border-radius:10px;background:#fff;display:block}
  .m3d-msg{position:absolute;inset:0;display:flex;align-items:center;justify-content:center;color:var(--text2);font-size:.9rem}
  .m3d-toolbar{display:flex;flex-wrap:wrap;gap:14px;align-items:center;margin:6px 0 12px}
  .m3d-styles{display:flex;gap:6px;flex-wrap:wrap}
  .m3d-styles button{font-size:.78rem;padding:6px 11px;border:1px solid var(--border);background:var(--surface2);color:var(--text);border-radius:7px;cursor:pointer}
  .m3d-styles button.active{background:var(--accent);border-color:var(--accent);color:#fff}
  .m3d-toggle{display:inline-flex;align-items:center;gap:5px;font-size:.82rem;color:var(--text2);cursor:pointer}
  .m3d-downloads{display:flex;flex-wrap:wrap;gap:10px 16px;align-items:center;margin-top:14px;font-size:.8rem;color:var(--text2)}
  .m3d-fmt{display:inline-flex;align-items:center;gap:5px}
  .m3d-fmt b{color:var(--text);font-weight:600}
  .m3d-downloads button{font-size:.72rem;padding:4px 9px;border:1px solid var(--border);background:var(--surface2);color:var(--text);border-radius:6px;cursor:pointer}
  .m3d-downloads button:hover{border-color:var(--accent);color:var(--accent)}
  .m3d-img{padding-right:16px;border-right:1px solid var(--border)}
  .m3d-img button{border-color:var(--accent);color:var(--accent)}
  /* Composition equation modal */
  .eq-overlay{position:fixed;inset:0;z-index:1000;background:rgba(5,7,12,.7);backdrop-filter:blur(2px);display:flex;align-items:center;justify-content:center;padding:24px;overflow-y:auto}
  .eq-overlay[hidden]{display:none}
  .eq-modal{position:relative;background:var(--surface);border:1px solid var(--border);border-radius:16px;max-width:1000px;width:100%;margin:auto;padding:26px 24px;box-shadow:0 24px 70px rgba(0,0,0,.5)}
  .eq-close{position:absolute;top:12px;right:14px;width:34px;height:34px;border:none;border-radius:9px;background:var(--surface2);color:var(--text2);font-size:22px;line-height:1;cursor:pointer}
  .eq-close:hover{color:var(--text)}
  .eq-title{font-size:1.15rem;font-weight:700;margin-bottom:18px}
  .eq-title #eq-formula{font-family:'Fira Code',ui-monospace,monospace;color:var(--accent)}
  /* Equation stays on ONE horizontal line; scrolls sideways if long */
  .eq-row{display:flex;align-items:center;justify-content:safe center;gap:10px;flex-wrap:nowrap;overflow-x:auto;overflow-y:hidden;min-height:150px;padding-bottom:8px;scrollbar-width:thin}
  .eq-row::-webkit-scrollbar{height:8px}
  .eq-row::-webkit-scrollbar-thumb{background:var(--border);border-radius:4px}
  .eq-tile{display:flex;flex-direction:column;align-items:center;gap:8px;flex:0 0 auto}
  .eq-figimg{max-width:100%;height:auto;background:#fff;border-radius:10px;margin:auto}
  .eq-op{flex:0 0 auto}
  .eq-tile .eq-struct{background:#fff;border-radius:10px;width:150px;height:120px;display:flex;align-items:center;justify-content:center;overflow:hidden}
  .eq-tile .eq-struct svg{max-width:100%;height:auto}
  .eq-bigformula{font-family:'Fira Code',ui-monospace,monospace;font-size:1.3rem;font-weight:700;color:#334155}
  .eq-cap{font-family:'Fira Code',ui-monospace,monospace;font-size:.9rem;color:var(--text);font-weight:600}
  .eq-op{font-size:1.6rem;color:var(--text2);font-weight:700;padding:0 2px}
  .eq-arrow{font-size:2rem;color:var(--accent)}
  .eq-note{margin-top:18px;font-size:.78rem;color:var(--text2);border-top:1px solid var(--border);padding-top:12px}
</style>

<!-- GPT ad init (head) -->
<%@ include file="/modern/ads/ad-init.jsp" %>
</head>
<body class="cs-body">

<%@ include file="/modern/components/nav-header.jsp" %>

<div class="cs-hero">
  <%@ include file="/modern/ads/ad-hero-banner.jsp" %>
</div>

<main class="cs-main">
  <button type="button" id="csSidebarToggle" class="cs-sidebar-toggle" aria-label="Open chemistry tools menu">&#9776; Chemistry tools</button>
  <% request.setAttribute("activeService", "formula-to-molecule"); %>
  <jsp:include page="/chemistry/partials/sidebar.jsp" />

  <section class="cs-workspace">
<div class="wrap">
  <div class="crumb"><a href="<%=ctx%>/">Home</a> / <a href="<%=ctx%>/chemistry/">Chemistry</a> / Formula to Structure</div>
  <h1>Molecular Formula → Structure</h1>
  <p class="sub">Type a <strong>molecular formula</strong> (e.g. <code>C10H14N2</code>) for structures, a full <strong>equation</strong> with <code>=</code> (e.g. <code>Fe + Cl2 = FeCl3</code>) to balance it, or just the <strong>reactants</strong> (e.g. <code>C + O2</code>) to predict and balance the products. Names, ions/electrons, and hydrates supported.</p>

  <div class="searchbar">
    <input id="formula" class="f-input" type="text" placeholder="e.g. C10H14N2   or   Fe + Cl2 = FeCl3" autocomplete="off" spellcheck="false">
    <button id="searchBtn" class="f-btn">Look up</button>
  </div>
  <div class="chips">
    <span class="lbl">Try:</span>
    <button class="chip" data-f="C10H14N2">C10H14N2</button>
    <button class="chip" data-f="C9H8O4">C9H8O4 (aspirin)</button>
    <button class="chip" data-f="C8H10N4O2">C8H10N4O2 (caffeine)</button>
    <button class="chip" data-f="C6H12O6">C6H12O6 (glucose)</button>
    <button class="chip" data-f="KMnO4 + HCl = KCl + MnCl2 + H2O + Cl2">balance: KMnO₄ + HCl = …</button>
  </div>

  <div id="status" class="status"></div>
  <div id="breakdown" class="breakdown" hidden></div>
  <div id="results" class="grid"></div>

  <p class="note">Lookups for large or uncommon formulas can take a few seconds. This is an early preview.</p>

  <div class="cs-inline-ad" style="margin-top:24px;">
    <%@ include file="/modern/ads/ad-in-content-mid.jsp" %>
  </div>

  <!-- Visible FAQ — mirrors the FAQ JSON-LD emitted by seo-tool-page.jsp above.
       Google requires FAQ structured data to correspond to on-page content. -->
  <section class="cs-faq-wrap" style="max-width:100%;margin-top:28px;padding:0;">
    <h2 class="cs-faq-title" id="faqs">Frequently asked</h2>
    <div class="cs-faq" aria-label="Formula to Structure FAQ">
      <div class="cs-faq-item">
        <button class="cs-faq-q" type="button">How do I find a molecule's structure from its chemical formula?
          <svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
        </button>
        <div class="cs-faq-a">Type a molecular formula such as <code>C6H12O6</code>, <code>C10H14N2</code> or <code>H2O</code>. The tool instantly shows every matching compound with its 2D structure, an interactive 3D model, the Lewis dot structure, and the SMILES string.</div>
      </div>
      <div class="cs-faq-item">
        <button class="cs-faq-q" type="button">Can one molecular formula have more than one structure?
          <svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
        </button>
        <div class="cs-faq-a">Yes. Many formulas are shared by several compounds called isomers &mdash; for example <code>C2H6O</code> is both ethanol and dimethyl ether. The tool lists each matching compound so you can compare them.</div>
      </div>
      <div class="cs-faq-item">
        <button class="cs-faq-q" type="button">Can I view and rotate the molecule in 3D?
          <svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
        </button>
        <div class="cs-faq-a">Yes. Click <strong>3D</strong> on any result for an interactive model you can rotate and zoom, switch between ball-and-stick, space-filling and wireframe, toggle hydrogens, animate it, and download it as a PNG image or as coordinates (SDF, JSON, XML).</div>
      </div>
      <div class="cs-faq-item">
        <button class="cs-faq-q" type="button">What is SMILES and how do I copy it?
          <svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
        </button>
        <div class="cs-faq-a">SMILES is a compact text notation for a molecule's structure. Every result shows its SMILES string with a one-click copy button so you can paste it into other chemistry software.</div>
      </div>
      <div class="cs-faq-item">
        <button class="cs-faq-q" type="button">Can it balance chemical equations and predict products?
          <svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
        </button>
        <div class="cs-faq-a">Yes. Enter a full equation with an equals sign, like <code>Fe + Cl2 = FeCl3</code>, to balance it &mdash; or type just the reactants, like <code>C + O2</code>, to predict and balance the products.</div>
      </div>
      <div class="cs-faq-item">
        <button class="cs-faq-q" type="button">Is the tool free?
          <svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
        </button>
        <div class="cs-faq-a">Yes. It is completely free, runs in your browser, and needs no signup.</div>
      </div>
    </div>
  </section>
  <script>
    (function () {
      document.querySelectorAll('.cs-faq-q').forEach(function (btn) {
        btn.addEventListener('click', function () {
          var item = btn.closest('.cs-faq-item');
          if (item) item.classList.toggle('open');
        });
      });
    })();
  </script>
</div>
  </section>

  <aside class="cs-rail" aria-label="Advertisements">
    <%@ include file="/modern/ads/ad-ide-rail-top.jsp" %>
    <%@ include file="/modern/ads/ad-ide-rail-bottom.jsp" %>
  </aside>
</main>

<!-- Composition equation modal -->
<div class="eq-overlay" id="eq-overlay" hidden>
  <div class="eq-modal">
    <button class="eq-close" id="eq-close" aria-label="Close">&times;</button>
    <div class="eq-title">Composition of <span id="eq-formula"></span>
      <button class="mini eq-dl" id="eq-dl" type="button">⬇ Download image</button>
    </div>
    <div class="eq-row" id="eq-row"></div>
    <p class="eq-note">This is the <em>formal</em> formation-from-elements reaction — each element in its standard state forming the compound. It is the basis of the standard enthalpy of formation (&Delta;H&deg;f) and is correct by atom balance, but it is usually <em>not</em> how the compound is actually synthesised (e.g. Ca(OH)&#8322; is really made from CaO + H&#8322;O, not from Ca + H&#8322; + O&#8322;).</p>
  </div>
</div>

<!-- Interactive 3D structure model (3Dmol.js, PubChem 3D conformer by CID) -->
<div class="eq-overlay" id="mol3d-overlay" hidden>
  <div class="eq-modal mol3d-modal">
    <button class="eq-close" id="mol3d-close" aria-label="Close">&times;</button>
    <div class="eq-title" id="mol3d-title">Interactive Chemical Structure Model</div>
    <div class="m3d-toolbar">
      <div class="m3d-styles" id="m3d-styles">
        <button type="button" data-style="ballstick" class="active">Ball &amp; Stick</button>
        <button type="button" data-style="stick">Sticks</button>
        <button type="button" data-style="line">Wire-Frame</button>
        <button type="button" data-style="sphere">Space-Filling</button>
      </div>
      <label class="m3d-toggle"><input type="checkbox" id="m3d-h" checked> Show Hydrogens</label>
      <label class="m3d-toggle"><input type="checkbox" id="m3d-spin"> Animate</label>
    </div>
    <div id="mol3d-viewer" class="mol3d-viewer"></div>
    <div class="m3d-downloads" id="m3d-downloads">
      <span class="m3d-fmt m3d-img"><b>Image</b> <button type="button" id="m3d-png">⬇ Download PNG</button></span>
      <span class="m3d-dl-label">Coordinates:</span>
      <span class="m3d-fmt"><b>SDF</b> <button type="button" data-dl-fmt="SDF" data-act="save">Save</button> <button type="button" data-dl-fmt="SDF" data-act="display">Display</button></span>
      <span class="m3d-fmt"><b>JSON</b> <button type="button" data-dl-fmt="JSON" data-act="save">Save</button> <button type="button" data-dl-fmt="JSON" data-act="display">Display</button></span>
      <span class="m3d-fmt"><b>XML</b> <button type="button" data-dl-fmt="XML" data-act="save">Save</button> <button type="button" data-dl-fmt="XML" data-act="display">Display</button></span>
      <span class="m3d-fmt"><b>ASNT</b> <button type="button" data-dl-fmt="ASNT" data-act="save">Save</button> <button type="button" data-dl-fmt="ASNT" data-act="display">Display</button></span>
    </div>
    <p class="eq-note">Interactive 3D model — drag to rotate, scroll to zoom. Switch representation, toggle hydrogens, animate, download the view as a PNG image, or grab the coordinates.</p>
  </div>
</div>

<!-- Lewis structure — reuses the Lewis Structures tool (lewis-structure-generator.jsp)
     verbatim via its ?formula= prefill+autorun, embedded in an iframe. No Lewis logic here. -->
<div class="eq-overlay" id="lewis-overlay" hidden>
  <div class="eq-modal lewis-modal">
    <button class="eq-close" id="lewis-close" aria-label="Close">&times;</button>
    <div class="eq-title" id="lewis-title">Lewis Structure</div>
    <iframe id="lewis-frame" class="lewis-frame" title="Lewis structure, VSEPR geometry and formal charges"></iframe>
    <p class="eq-note">Lewis dot structure, VSEPR geometry, bond angles and formal charges. <a id="lewis-openfull" href="<%=ctx%>/lewis-structure-generator.jsp" target="_blank" rel="noopener">Open the full tool ↗</a></p>
  </div>
</div>

<script src="<%=ctx%>/modern/js/tool-utils.js"></script>
<script type="module">
  const PROXY = '<%=ctx%>/chemistry/formula-lookup.jsp';
  const EDITOR = '<%=ctx%>/chemistry/molecule-draw.jsp';
  const RUN = '<%=ctx%>/OneCompilerFunctionality';
  const AI_URL = '<%=ctx%>/ai';
  const CACHE_URL = '<%=ctx%>/chemistry/data/formula-cache.min.json';
  const MAX_RESULTS = 24;

  let OCL = null;
  (async () => {
    try { OCL = await import('https://esm.sh/openchemlib@9.21.0'); if (OCL.default) OCL = OCL.default; }
    catch (e) { console.warn('OpenChemLib failed to load', e); }
  })();

  // Local formula cache (chemistry/data/formula-cache.min.json) — checked before
  // PubChem so common lookups are instant. Built by build-formula-cache.mjs.
  let CACHE = {};
  fetch(CACHE_URL)
    .then((r) => r.json())
    .then((d) => { CACHE = (d && d.f) ? d.f : {}; })
    .catch(() => { CACHE = {}; });
  function cacheGet(formula) { return CACHE && CACHE[formula] ? CACHE[formula] : null; }

  const $ = (id) => document.getElementById(id);
  const sleep = (ms) => new Promise(r => setTimeout(r, ms));
  let busy = false;
  let lastFormula = '';        // the searched formula
  let lastReactants = [];      // [{sp:'Cl2', n:3}, ...] elemental reactants
  let lastProducts = [];       // [{sp:'FeCl3', n:2}]
  const partCache = {};        // species -> resolved SMILES (or null)

  // Standard elemental forms so common parts render without a PubChem round-trip.
  const DIATOMIC = { O2:'O=O', N2:'N#N', H2:'[H][H]', F2:'FF', Cl2:'ClCl', Br2:'BrBr', I2:'II', O3:'[O-][O+]=O' };

  function setStatus(html, isErr) {
    const el = $('status');
    el.className = 'status' + (isErr ? ' err' : '');
    el.innerHTML = html;
  }

  async function callProxy(params) {
    const qs = new URLSearchParams(params).toString();
    const r = await fetch(PROXY + '?' + qs, { headers: { 'Accept': 'application/json' } });
    return r.json();
  }

  async function resolve(data) {
    let tries = 0;
    while (data && data.Waiting && data.Waiting.ListKey && tries < 30) {
      setStatus('<span class="spin"></span>Searching… (' + (tries + 1) + ')');
      await sleep(1600);
      data = await callProxy({ action: 'listkey', listkey: data.Waiting.ListKey });
      tries++;
    }
    return data;
  }

  function smilesOf(p) { return p.SMILES || p.IsomericSMILES || p.ConnectivitySMILES || p.CanonicalSMILES || ''; }

  // ── Balanced formation-from-elements via chempy on OneCompiler ──
  // chempy.balance_stoichiometry handles arbitrary formulas robustly (no
  // hand-rolled balancing). Elements use diatomic standard states; everything
  // else is monatomic to keep coefficients readable (S, P, metals, C).
  function buildFormationCode(formula) {
    return [
      'import json',
      'from chempy import Substance, balance_stoichiometry',
      'from chempy.util import periodic',
      'formula = ' + JSON.stringify(formula),
      'DIA = {"H":"H2","N":"N2","O":"O2","F":"F2","Cl":"Cl2","Br":"Br2","I":"I2"}',
      'try:',
      '    s = Substance.from_formula(formula)',
      '    elems = sorted({periodic.symbols[Z-1] for Z in s.composition if Z > 0})',
      '    reactants = {DIA.get(e, e) for e in elems}',
      '    if reactants == {formula}:',
      '        res = {"ok": True, "elemental": True}  # already an element in its standard state',
      '    else:',
      '        reac, prod = balance_stoichiometry(reactants, {formula})',
      '        def lst(d): return [{"sp": k, "n": int(d[k])} for k in d]',
      '        res = {"ok": True, "reactants": lst(reac), "products": lst(prod)}',
      'except Exception as e:',
      '    res = {"ok": False, "error": type(e).__name__ + ": " + str(e)}',
      'print("RESULT:" + json.dumps(res))'
    ].join('\n');
  }

  // Pretty-print: subscript the digits inside a species (Cl2 → Cl₂); coefficient
  // stays a normal leading number.
  function sub(s) { return String(s).replace(/\d/g, (d) => '₀₁₂₃₄₅₆₇₈₉'[+d]); }
  function fmtSp(coef, sp) { return (coef > 1 ? coef + ' ' : '') + sub(sp); }
  function eqString(reactants, products) {
    const L = reactants.map((r) => fmtSp(r.n, r.sp)).join('  +  ');
    const R = products.map((p) => fmtSp(p.n, p.sp)).join('  +  ');
    return L + '  →  ' + R;
  }

  function computeFormation(formula) {
    const el = $('breakdown');
    el.hidden = false;
    el.innerHTML = '<span class="spin"></span>Balancing formation from elements…';
    fetch(RUN + '?action=execute', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ language: 'python', version: '3.11', code: buildFormationCode(formula) })
    })
    .then((r) => r.json())
    .then((data) => {
      const stdout = (data.Stdout || data.stdout || '').trim();
      const m = stdout.match(/RESULT:(\{[\s\S]*\})/);
      if (!m) { el.hidden = true; return; }
      const res = JSON.parse(m[1]);
      if (res.ok && res.elemental) {
        lastFormula = formula; lastReactants = []; lastProducts = [];
        el.innerHTML = '<span class="bd-label">Element</span>' +
          '<span class="bd-parts">' + sub(formula) + ' is an element in its standard state — no formation equation.</span>';
        return;
      }
      if (!res.ok || !res.reactants || !res.reactants.length) { el.hidden = true; return; }
      lastFormula = formula;
      lastReactants = res.reactants;
      lastProducts = res.products;
      el.innerHTML =
        '<span class="bd-label">Formal formation (&Delta;H&deg;f)</span>' +
        '<span class="bd-parts">' + eqString(res.reactants, res.products) + '</span>' +
        '<span class="bd-note" title="This is the standard enthalpy-of-formation reaction: elements in their standard states forming 1 unit of the compound. It is balanced by atom count, but is generally not how the compound is actually made.">&#9432; atom-balanced formation reaction — not a real synthesis route</span>';
    })
    .catch(() => { el.hidden = true; });
  }

  // ══════════════════════════════════════════════════════════
  //  EQUATION BALANCER  (input contains = or ->)
  //  Preprocess → resolve names via PubChem → chempy.balance_stoichiometry
  // ══════════════════════════════════════════════════════════
  const ABBREV = { Ph: 'C6H5', Et: 'C2H5', Me: 'CH3' };

  function isName(t) {
    if (/\s/.test(t)) return true;                 // multi-word → a name
    return /^[a-z][a-z]+$/.test(t);                // all-lowercase word (water, ozone, sulfur)
  }
  // Formula token → chempy-parseable form (Ph→C6H5, *→.., {±n}→charge suffix).
  function prepFormula(tok) {
    let t = tok.trim();
    for (const k in ABBREV) t = t.replace(new RegExp(k, 'g'), ABBREV[k]);
    t = t.replace(/\*/g, '..');
    t = t.replace(/\{([+-]?\d*)\}/g, (m, g) => g); // {-2}→-2, {+}→+, {+3}→+3
    return t;
  }
  // Split a side on "+" separators — with OR without spaces (C+O2 == C + O2),
  // but never on a "+" that sits inside {…}/[…] (a charge like {+} or {+3}).
  function splitSide(s) {
    const out = []; let cur = '', depth = 0;
    for (let i = 0; i < s.length; i++) {
      const c = s[i];
      if (c === '{' || c === '[') { depth++; cur += c; }
      else if (c === '}' || c === ']') { depth = Math.max(0, depth - 1); cur += c; }
      else if (c === '+' && depth === 0) { if (cur.trim()) out.push(cur.trim()); cur = ''; }
      else cur += c;
    }
    if (cur.trim()) out.push(cur.trim());
    return out;
  }
  async function resolveToken(tok) {
    let t = tok.trim().replace(/^\d+\s*/, ''); // drop any leading coefficient
    if (t === '{-}' || t === 'e-' || t === 'e⁻') return { label: 'e⁻', sp: 'e-' };
    if (isName(t)) {
      try {
        const data = await callProxy({ action: 'name', name: t });
        const p = data && data.PropertyTable && data.PropertyTable.Properties && data.PropertyTable.Properties[0];
        if (p && p.MolecularFormula) return { label: t, sp: p.MolecularFormula, smiles: p.SMILES || p.IsomericSMILES || p.ConnectivitySMILES || p.CanonicalSMILES || '' };
      } catch (e) { /* unresolved */ }
      return { label: t, sp: null };
    }
    return { label: t, sp: prepFormula(t) };
  }

  function buildBalanceCode(reac, prod) {
    return [
      'import json',
      'from chempy import balance_stoichiometry',
      'reac = ' + JSON.stringify(reac),
      'prod = ' + JSON.stringify(prod),
      'try:',
      '    r, p = balance_stoichiometry(set(reac), set(prod))',
      '    res = {"ok": True, "reactants": [{"sp": k, "n": int(r[k])} for k in r], "products": [{"sp": k, "n": int(p[k])} for k in p]}',
      'except Exception as e:',
      '    res = {"ok": False, "error": type(e).__name__ + ": " + str(e)}',
      'print("RESULT:" + json.dumps(res))'
    ].join('\n');
  }
  async function balanceViaChempy(reac, prod) {
    const r = await fetch(RUN + '?action=execute', {
      method: 'POST', headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ language: 'python', version: '3.11', code: buildBalanceCode(reac, prod) })
    });
    const data = await r.json();
    const stdout = (data.Stdout || data.stdout || '').trim();
    const m = stdout.match(/RESULT:(\{[\s\S]*\})/);
    return m ? JSON.parse(m[1]) : null;
  }

  // Pretty: superscript charges, subscript counts, '..'→'·', e- → e⁻
  function sup(s) { return String(s).replace(/\d/g, (d) => '⁰¹²³⁴⁵⁶⁷⁸⁹'[+d]).replace('+', '⁺').replace('-', '⁻'); }
  function prettySp(sp) {
    if (sp === 'e-') return 'e⁻';
    let s = sp.replace(/\.\./g, '·');
    const m = s.match(/^(.+?)([+-]\d*)$/);
    let core = s, chg = '';
    if (m) { core = m[1]; const sign = m[2][0], num = m[2].slice(1); chg = (num ? sup(num) : '') + (sign === '+' ? '⁺' : '⁻'); }
    core = core.replace(/\d+/g, (d) => sub(d));
    return core + chg;
  }
  function sideHtml(arr) {
    return arr.map((x) => (x.n > 1 ? x.n + ' ' : '') + prettySp(x.sp)).join('  +  ');
  }
  // SMILES for a balanced species: ions/electrons have no 2D structure → text tile.
  function speciesSmiles(sp) {
    if (sp === 'e-' || /[+-]\d*$/.test(sp)) return Promise.resolve(null);
    return resolvePartSmiles(sp); // cache → diatomic → atom → PubChem
  }
  // Compose the WHOLE equation as one textbook-style figure (single canvas):
  // structures + coefficients + "+"/"→" laid out on one clean white row.
  async function composeEquationCanvas(items) {
    const structW = 150, structH = 120, tileW = structW + 22, opW = 52, top = 18, labelGap = 26, H = top + structH + labelGap + 14, S = 2;
    const imgs = await Promise.all(items.map((it) => it.svg ? svgStrToImage(it.svg) : Promise.resolve(null)));
    let W = 22; items.forEach((it) => { W += it.op ? opW : tileW; }); W += 22;
    const cv = document.createElement('canvas');
    cv.width = W * S; cv.height = H * S;
    const ctx = cv.getContext('2d'); ctx.scale(S, S);
    ctx.fillStyle = '#ffffff'; ctx.fillRect(0, 0, W, H);
    ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
    let x = 22;
    items.forEach((it, i) => {
      if (it.op) {
        ctx.fillStyle = it.op === '→' ? '#2563eb' : '#475569';
        ctx.font = '600 30px "Segoe UI", system-ui, sans-serif';
        ctx.fillText(it.op, x + opW / 2, top + structH / 2);
        x += opW;
      } else {
        const cx = x + tileW / 2;
        if (imgs[i]) ctx.drawImage(imgs[i], x + 11, top, structW, structH);
        else { ctx.fillStyle = '#0f172a'; ctx.font = 'bold 28px "Fira Code", monospace'; ctx.fillText(it.label, cx, top + structH / 2); }
        ctx.fillStyle = '#0f172a'; ctx.font = '600 18px "Fira Code", monospace'; ctx.fillText(it.label, cx, top + structH + labelGap);
        x += tileW;
      }
    });
    return cv;
  }
  let lastEqCanvas = null;
  async function renderEquation(res, spSmiles, predicted) {
    spSmiles = spSmiles || {};
    async function side(arr) {
      const out = [];
      for (let i = 0; i < arr.length; i++) {
        if (i > 0) out.push({ op: '+' });
        const x = arr[i];
        let smi = spSmiles[x.sp];
        if (smi === undefined) smi = await speciesSmiles(x.sp);
        out.push({ label: (x.n > 1 ? x.n + ' ' : '') + prettySp(x.sp), svg: svgFor(smi, 150, 120), sp: x.sp, neutral: !(x.sp === 'e-' || /[+-]\d*$/.test(x.sp)) });
      }
      return out;
    }
    const L = await side(res.reactants), R = await side(res.products);
    const items = L.concat([{ op: '→' }], R);
    lastEqCanvas = await composeEquationCanvas(items);
    lastEquationText = res.reactants.map((x) => x.sp).join(' + ') + ' = ' + res.products.map((x) => x.sp).join(' + ');
    const chips = items.filter((it) => !it.op && it.neutral)
      .map((it) => '<button class="eqn-chip" data-species="' + encodeURIComponent(it.sp) + '">' + prettySp(it.sp) + '</button>').join('');
    $('results').innerHTML =
      '<div class="eqn-card">' +
        '<div class="eqn-line">' + sideHtml(res.reactants) + '<span class="eqn-arrow">→</span>' + sideHtml(res.products) + '</div>' +
        '<div class="eqn-actions"><button class="mini" data-edit="1" type="button">✎ Edit equation</button> <button class="mini" data-dleq="1" type="button">⬇ Download image</button></div>' +
        '<div class="eqn-figure">' + (lastEqCanvas ? '<img alt="Balanced equation diagram" src="' + lastEqCanvas.toDataURL('image/png') + '">' : '') + '</div>' +
        (chips ? '<div class="eqn-species"><span class="eqn-species-lbl">Explore a species:</span> ' + chips + '</div>' : '') +
        '<div class="eqn-note">' +
          (predicted ? '<strong>Products predicted by AI, then balanced &amp; verified.</strong> ' : '') +
          'Click a species to see all its matches, or Edit to tweak and re-balance — atoms &amp; charge conserved.</div>' +
      '</div>';
    lastEquationHTML = $('results').innerHTML; // for the "back" button after drilling
  }

  // ── AI: predict products for reactants-only input, then verify with chempy ──
  // The LLM only *suggests* products; chempy is the source of truth — if it
  // doesn't atom-balance, we don't trust it.
  async function aiComplete(system, user) {
    for (let attempt = 0; attempt < 4; attempt++) {
      const ctrl = new AbortController();
      const to = setTimeout(() => ctrl.abort(), 45000);
      let txt;
      try {
        const r = await fetch(AI_URL, {
          method: 'POST', headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ messages: [{ role: 'system', content: system }, { role: 'user', content: user }], stream: false }),
          signal: ctrl.signal
        });
        txt = await r.text();
      } finally { clearTimeout(to); }

      let o = null; try { o = JSON.parse(txt); } catch (_) {}
      if (o) {
        if (o.error) {
          // Server rate-limit → wait the suggested time and retry.
          if (/rate limit/i.test(o.error) && attempt < 3) {
            const w = (o.retryAfter || 5);
            setStatus('<span class="spin"></span>AI is busy — retrying in ' + w + 's…');
            await new Promise((res) => setTimeout(res, (w + 1) * 1000));
            continue;
          }
          throw new Error(o.error);
        }
        if (o.message && o.message.content) return o.message.content;
        if (o.content) return o.content;
      }
      // NDJSON fallback (streamed lines)
      let out = '';
      txt.split('\n').forEach((l) => { l = l.trim(); if (!l) return; try { const j = JSON.parse(l); if (j.message && j.message.content) out += j.message.content; } catch (_) {} });
      return out;
    }
    return '';
  }
  function parseAiProducts(text) {
    let t = String(text || '').trim().replace(/⟶|⇌|→|=>|->/g, '=');
    if (t.includes('=')) t = t.split('=').pop();      // if it returned a full equation, keep RHS
    t = t.replace(/[`'"*.:]/g, ' ').split('\n')[0];   // first line, strip noise
    return splitSide(t)
      .map((x) => x.replace(/^\d+\s*/, '').trim())     // drop coefficients
      .filter((x) => /^[A-Za-z0-9()\[\]{}+\-]+$/.test(x) && /[A-Z]/.test(x));
  }
  async function predictReaction(reactTokens) {
    busy = true; $('searchBtn').disabled = true; $('results').innerHTML = ''; $('breakdown').hidden = true;
    setStatus('<span class="spin"></span>Predicting products with AI…');
    try {
      const reacResolved = await Promise.all(reactTokens.map(resolveToken));
      const badR = reacResolved.filter((x) => !x.sp);
      if (badR.length) { setStatus('Could not resolve reactant: ' + badR.map((x) => x.label).join(', ') + '.', true); return; }

      const sys = 'You are a chemistry assistant. Given ONLY the reactants of a chemical reaction, predict the most likely product(s). '
        + 'Reply with ONLY the product chemical formulas separated by " + ". No coefficients, no words, no arrows, no explanation. '
        + 'Example: reactants "C + O2" → reply "CO2".';
      const ai = await aiComplete(sys, 'Reactants: ' + reactTokens.join(' + '));
      const prods = parseAiProducts(ai);
      if (!prods.length) { setStatus('AI couldn’t suggest products. Try the full equation with “=”.', true); return; }

      setStatus('<span class="spin"></span>Checking “' + reactTokens.join(' + ') + ' → ' + prods.join(' + ') + '”…');
      const res = await balanceViaChempy(reacResolved.map((x) => x.sp), prods.map(prepFormula));
      if (!res || !res.ok) {
        // chempy couldn't balance the AI's species → hand it back, editable.
        lastEquationText = reactTokens.join(' + ') + ' = ' + prods.join(' + ');
        $('formula').value = lastEquationText;
        setStatus('AI suggested “' + reactTokens.join(' + ') + ' → ' + prods.join(' + ') + '” but it didn’t balance — edit it and press Look up.', true);
        return;
      }
      const spSmiles = {};
      reacResolved.forEach((x) => { if (x.smiles) spSmiles[x.sp] = x.smiles; });
      await renderEquation(res, spSmiles, true);
      setStatus('Products predicted by AI · balanced & verified ✓');
    } catch (e) {
      setStatus('Prediction failed: ' + (e && e.message ? e.message : 'error') + '.', true);
    } finally {
      busy = false; $('searchBtn').disabled = false;
    }
  }

  async function balanceEquation(input) {
    busy = true;
    $('searchBtn').disabled = true;
    $('results').innerHTML = '';
    $('breakdown').hidden = true;
    setStatus('<span class="spin"></span>Reading equation…');
    try {
      // Normalise every arrow style to "=", then split — spaces optional everywhere.
      const norm = input.replace(/⟶|⇌|→|=>|->/g, '=');
      const sides = norm.split('=').map((s) => s.trim()).filter((s) => s.length);
      if (sides.length !== 2) {
        setStatus('Use one “=” (or “->”) with species on both sides — e.g. C+O2=CO2.', true); return;
      }
      const reacTok = splitSide(sides[0]), prodTok = splitSide(sides[1]);
      if (!reacTok.length || !prodTok.length) { setStatus('Need species on both sides.', true); return; }

      setStatus('<span class="spin"></span>Resolving species…');
      const reac = await Promise.all(reacTok.map(resolveToken));
      const prod = await Promise.all(prodTok.map(resolveToken));
      const bad = reac.concat(prod).filter((x) => !x.sp);
      if (bad.length) { setStatus('Could not resolve: ' + bad.map((x) => x.label).join(', ') + '. Try a chemical formula instead.', true); return; }

      setStatus('<span class="spin"></span>Balancing…');
      const res = await balanceViaChempy(reac.map((x) => x.sp), prod.map((x) => x.sp));
      if (!res || !res.ok) { setStatus('Could not balance this equation' + (res && res.error ? ' (' + res.error + ')' : '') + '. Check it is chemically valid.', true); return; }
      // Reuse SMILES already resolved for name tokens; the rest are looked up on render.
      const spSmiles = {};
      reac.concat(prod).forEach((x) => { if (x.smiles) spSmiles[x.sp] = x.smiles; });
      await renderEquation(res, spSmiles);
      setStatus('Balanced ✓');
    } catch (e) {
      setStatus('Balancing failed: ' + (e && e.message ? e.message : 'error'), true);
    } finally {
      busy = false;
      $('searchBtn').disabled = false;
    }
  }

  function renderResults(props, fromCache) {
    if (typeof hidePop === 'function') hidePop(true);
    const results = $('results');
    results.innerHTML = '';
    const shown = props.slice(0, MAX_RESULTS);
    shown.forEach((p) => {
      const smi = smilesOf(p);
      const conn = p.ConnectivitySMILES || p.CanonicalSMILES || '';
      const cid = p.CID;
      const card = document.createElement('div');
      card.className = 'card';
      card.dataset.cid = cid || '';
      card.dataset.name = (lastFormula || 'molecule') + (cid ? '-' + cid : '');

      let svg = '<div class="fail">No 2D depiction</div>';
      let mf = '';
      if (OCL && smi) {
        try {
          const mol = OCL.Molecule.fromSmiles(smi);
          svg = mol.toSVG(280, 190, null, { suppressChiralText: true, autoCrop: true });
          try { mf = mol.getMolecularFormula().formula || ''; } catch (e) {}
        }
        catch (e) { svg = '<div class="fail">Could not render</div>'; }
      }
      if (!mf) mf = lastFormula || '';

      card.innerHTML =
        '<div class="struct">' + svg + '</div>' +
        '<div class="cid">CID <a href="https://pubchem.ncbi.nlm.nih.gov/compound/' + cid + '" target="_blank" rel="noopener">' + cid + '</a></div>' +
        '<div class="smi"></div>' +
        '<div class="row">' +
          (cid ? '<button class="mini" data-info="1">ⓘ Details</button>' : '') +
          (cid ? '<button class="mini" data-3d="' + cid + '">🧊 3D</button>' : '') +
          (mf ? '<button class="mini" data-lewis="' + encodeURIComponent(mf) + '">•• Lewis</button>' : '') +
          '<button class="mini" data-dl="1">⬇ Image</button>' +
          '<button class="mini" data-comp="' + encodeURIComponent(smi) + '">⚗ View composition</button>' +
          '<button class="mini" data-copy="' + encodeURIComponent(smi) + '">📋 Copy SMILES</button>' +
          '<a class="mini" href="' + EDITOR + '?smiles=' + encodeURIComponent(smi) + '" target="_blank" rel="noopener">✎ Open in editor</a>' +
        '</div>';
      card.querySelector('.smi').textContent = smi || conn || '(none)';
      if (cid) { card.addEventListener('mouseenter', cardEnter); card.addEventListener('mouseleave', cardLeave); }
      results.appendChild(card);
    });

    const more = props.length > shown.length ? ' (showing first ' + shown.length + ' of ' + props.length + ')' : '';
    setStatus('Found <strong>' + props.length + '</strong> compound' + (props.length !== 1 ? 's' : '') + ' for that formula' + more + '.');
  }

  // ── Compound detail popover (PubChem computed properties; hover / tap ⓘ) ──
  // In-memory cache, hydrated from / persisted to localStorage so a CID pulled
  // once is never looked up again (30-day TTL, capped at DETAIL_MAX compounds).
  const detailCache = {};
  const DETAIL_STORE = 'f2m.pubchem.props.v1';
  const DETAIL_TTL = 30 * 24 * 3600 * 1000;
  const DETAIL_MAX = 400;
  function detailStoreRead() { try { return JSON.parse(localStorage.getItem(DETAIL_STORE) || '{}') || {}; } catch (e) { return {}; } }
  function detailStoreWrite(m) { try { localStorage.setItem(DETAIL_STORE, JSON.stringify(m)); } catch (e) {} }
  (function hydrateDetailCache() {
    const m = detailStoreRead(), now = Date.now(); let changed = false;
    for (const cid in m) {
      if (!m[cid] || (now - m[cid].t) > DETAIL_TTL) { delete m[cid]; changed = true; continue; }
      detailCache[cid] = m[cid].d;
    }
    if (changed) detailStoreWrite(m);
  })();
  function detailStoreSave(cid, d) {
    const m = detailStoreRead();
    m[cid] = { t: Date.now(), d: d };
    const keys = Object.keys(m);
    if (keys.length > DETAIL_MAX) {                          // evict the oldest entries
      keys.sort((a, b) => (m[a].t || 0) - (m[b].t || 0));
      for (let i = 0; i < keys.length - DETAIL_MAX; i++) delete m[keys[i]];
    }
    detailStoreWrite(m);
  }
  let popEl = null, popTimer = null, popSticky = false, popCard = null;
  function ensurePop() {
    if (!popEl) { popEl = document.createElement('div'); popEl.className = 'mol-pop'; document.body.appendChild(popEl); }
    return popEl;
  }
  function popSub(f) { return String(f || '').replace(/(\d+)/g, '<sub>$1</sub>'); }
  function escP(s) { return String(s == null ? '' : s).replace(/[&<>"]/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c])); }
  function positionPop(card) {
    const el = ensurePop(), r = card.getBoundingClientRect(), w = 300, gap = 12;
    let left = r.right + gap, top = r.top;
    if (left + w > window.innerWidth - 8) left = r.left - gap - w;                 // flip left
    if (left < 8) { left = Math.min(Math.max(8, r.left), window.innerWidth - w - 8); top = r.bottom + gap; } // drop below
    top = Math.max(8, Math.min(top, window.innerHeight - 8 - el.offsetHeight));
    el.style.left = left + 'px'; el.style.top = top + 'px';
  }
  function renderPop(d, cid) {
    const rows = [
      ['Molar mass', d.MolecularWeight ? d.MolecularWeight + ' g/mol' : '—'],
      ['Exact mass', d.ExactMass ? (+d.ExactMass).toFixed(4) + ' Da' : '—'],
      ['XLogP', d.XLogP != null ? d.XLogP : '—'],
      ['H-bond donors', d.HBondDonorCount != null ? d.HBondDonorCount : '—'],
      ['H-bond acceptors', d.HBondAcceptorCount != null ? d.HBondAcceptorCount : '—'],
      ['Rotatable bonds', d.RotatableBondCount != null ? d.RotatableBondCount : '—'],
      ['TPSA', d.TPSA != null ? d.TPSA + ' Å²' : '—'],
      ['Heavy atoms', d.HeavyAtomCount != null ? d.HeavyAtomCount : '—'],
      ['Formal charge', d.Charge != null ? d.Charge : '—'],
      ['Complexity', d.Complexity != null ? d.Complexity : '—'],
      ['InChIKey', d.InChIKey || '—']
    ];
    ensurePop().innerHTML =
      '<h4><span class="formula-sub">' + popSub(d.MolecularFormula || lastFormula || '') + '</span> · CID ' + escP(cid) + '</h4>' +
      (d.IUPACName ? '<div class="pop-name">' + escP(d.IUPACName) + '</div>' : '') +
      '<table>' + rows.map((r) => '<tr><td class="k">' + r[0] + '</td><td class="v">' + escP(r[1]) + '</td></tr>').join('') + '</table>' +
      '<div class="pop-foot">Source: PubChem · computed properties</div>';
  }
  async function loadDetail(cid) {
    if (detailCache[cid]) return detailCache[cid];
    const r = await fetch(PROXY + '?action=props&cid=' + encodeURIComponent(cid), { headers: { 'Accept': 'application/json' } });
    const j = await r.json();
    const d = j && j.PropertyTable && j.PropertyTable.Properties && j.PropertyTable.Properties[0];
    if (!d) throw new Error('no data');
    detailCache[cid] = d;
    detailStoreSave(cid, d);
    return d;
  }
  async function showPop(card, sticky) {
    const cid = card.dataset.cid;
    if (!cid) return;
    popCard = card; popSticky = !!sticky;
    const el = ensurePop();
    if (detailCache[cid]) renderPop(detailCache[cid], cid);
    else el.innerHTML = '<div class="pop-load"><span class="spin"></span>Loading CID ' + escP(cid) + '…</div>';
    positionPop(card); el.classList.add('show');
    if (!detailCache[cid]) {
      try { const d = await loadDetail(cid); if (popCard === card) { renderPop(d, cid); positionPop(card); } }
      catch (err) { if (popCard === card) el.innerHTML = '<div class="pop-load">Details unavailable right now.</div>'; }
    }
  }
  function hidePop(force) {
    if (popSticky && !force) return;
    popSticky = false; popCard = null;
    if (popEl) popEl.classList.remove('show');
  }
  function cardEnter(e) {
    const card = e.currentTarget; clearTimeout(popTimer);
    if (detailCache[card.dataset.cid]) showPop(card, false);          // already pulled → show instantly, no lookup
    else popTimer = setTimeout(() => showPop(card, false), 200);      // uncached → small delay before the network fetch
  }
  function cardLeave() { clearTimeout(popTimer); if (!popSticky) hidePop(); }

  function onResultsClick(e) {
    const infoBtn = e.target.closest('[data-info]');
    if (infoBtn) {
      const card = infoBtn.closest('.card');
      if (card) { (popSticky && popCard === card) ? hidePop(true) : showPop(card, true); }
      return;
    }
    const copyBtn = e.target.closest('[data-copy]');
    if (copyBtn) {
      const smi = decodeURIComponent(copyBtn.getAttribute('data-copy'));
      if (window.ToolUtils && ToolUtils.copyToClipboard) {
        ToolUtils.copyToClipboard(smi, { toastMessage: 'SMILES copied', toolName: 'Formula to Structure', showSupportPopup: true });
      }
      return;
    }
    const compBtn = e.target.closest('[data-comp]');
    if (compBtn) {
      openComposition(decodeURIComponent(compBtn.getAttribute('data-comp')));
      return;
    }
    const d3 = e.target.closest('[data-3d]');
    if (d3) {
      const card = d3.closest('.card');
      open3D(d3.getAttribute('data-3d'), (card && card.dataset.name) || 'molecule');
      return;
    }
    const dlewis = e.target.closest('[data-lewis]');
    if (dlewis) {
      openLewis(decodeURIComponent(dlewis.getAttribute('data-lewis')));
      return;
    }
    const dl = e.target.closest('[data-dl]');
    if (dl) {
      const card = dl.closest('.card');
      const svgEl = card && card.querySelector('.struct svg');
      if (svgEl) svgElToPng(svgEl, (card.dataset.name || 'molecule') + '.png');
      return;
    }
    if (e.target.closest('[data-edit]')) { editEquation(); return; }
    if (e.target.closest('[data-dleq]')) {
      if (lastEqCanvas) lastEqCanvas.toBlob((b) => triggerDownload(URL.createObjectURL(b), (lastFormula || 'equation') + '.png'));
      return;
    }
    const drill = e.target.closest('[data-species]');
    if (drill) {
      drillSpecies(decodeURIComponent(drill.getAttribute('data-species')));
    }
  }

  // ── 3D viewer (3Dmol.js, fetches the 3D conformer from PubChem by CID) ──
  function load3Dmol() {
    return new Promise((res, rej) => {
      if (window.$3Dmol) return res();
      const s = document.createElement('script');
      s.src = 'https://3Dmol.org/build/3Dmol-min.js';
      s.onload = res; s.onerror = rej;
      document.head.appendChild(s);
    });
  }
  let m3dViewer = null, m3dCid = null, m3dStyle = 'ballstick';
  function m3dStyleObj() {
    if (m3dStyle === 'ballstick') return { stick: { radius: 0.15 }, sphere: { scale: 0.25 } };
    if (m3dStyle === 'stick') return { stick: { radius: 0.18 } };
    if (m3dStyle === 'line') return { line: {} };
    return { sphere: {} }; // space-filling (CPK)
  }
  function m3dApply() {
    if (!m3dViewer) return;
    m3dViewer.setStyle({}, m3dStyleObj());
    if (!$('m3d-h').checked) m3dViewer.setStyle({ elem: 'H' }, {}); // hide hydrogens
    m3dViewer.render();
  }
  async function open3D(cid, label) {
    m3dCid = cid; m3dStyle = 'ballstick';
    document.querySelectorAll('#m3d-styles button').forEach((b) => b.classList.toggle('active', b.getAttribute('data-style') === 'ballstick'));
    $('m3d-h').checked = true; $('m3d-spin').checked = false;
    $('mol3d-title').textContent = 'Interactive Model · ' + label;
    const ov = $('mol3d-overlay'), host = $('mol3d-viewer');
    ov.hidden = false; document.body.classList.add('eq-open');
    host.innerHTML = '<div class="m3d-msg"><span class="spin"></span> Loading 3D model…</div>';
    try {
      await load3Dmol();
      host.innerHTML = '';
      m3dViewer = window.$3Dmol.createViewer(host, { backgroundColor: 'white' });
      window.$3Dmol.download('cid:' + cid, m3dViewer, {}, () => { m3dApply(); m3dViewer.zoomTo(); m3dViewer.render(); });
    } catch (e) {
      m3dViewer = null;
      host.innerHTML = '<div class="m3d-msg fail">3D model unavailable for this compound.</div>';
    }
  }
  function close3D() {
    if (m3dViewer) { try { m3dViewer.spin(false); } catch (_) {} }
    $('mol3d-overlay').hidden = true; document.body.classList.remove('eq-open');
  }

  // ── Lewis structure: open the tested Lewis Structures tool inside an iframe,
  //    prefilled via ?formula= (it auto-runs on load). We never generate Lewis
  //    structures here — this delegates entirely to lewis-structure-generator.jsp.
  const LEWIS_TOOL = '<%=ctx%>/lewis-structure-generator.jsp';
  function openLewis(formula) {
    const frame = $('lewis-frame');
    $('lewis-title').textContent = 'Lewis Structure · ' + formula;
    $('lewis-openfull').href = LEWIS_TOOL + '?formula=' + encodeURIComponent(formula);
    if (frame.getAttribute('data-formula') !== formula) {
      frame.src = LEWIS_TOOL + '?formula=' + encodeURIComponent(formula) + '&embed=1';
      frame.setAttribute('data-formula', formula);
    }
    $('lewis-overlay').hidden = false; document.body.classList.add('eq-open');
  }
  function closeLewis() { $('lewis-overlay').hidden = true; document.body.classList.remove('eq-open'); }
  // Coordinate downloads (PubChem REST 3D records)
  function m3dRecordUrl(fmt) { return 'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/' + m3dCid + '/record/' + fmt + '?record_type=3d'; }
  async function m3dSave(fmt) {
    const ext = { SDF: 'sdf', JSON: 'json', XML: 'xml', ASNT: 'asnt' }[fmt] || 'txt';
    try {
      const r = await fetch(m3dRecordUrl(fmt));
      const t = await r.text();
      triggerDownload(URL.createObjectURL(new Blob([t], { type: 'text/plain' })), m3dCid + '-3d.' + ext);
    } catch (e) { /* network */ }
  }
  function m3dDisplay(fmt) { window.open(m3dRecordUrl(fmt), '_blank', 'noopener'); }
  // Snapshot the current 3D view as a PNG (3Dmol's pngURI; canvas fallback).
  function m3dDownloadImage() {
    if (!m3dViewer) return;
    let uri = '';
    try { m3dViewer.render(); uri = m3dViewer.pngURI(); } catch (e) {}
    if (!uri) {
      try { const cv = $('mol3d-viewer').querySelector('canvas'); if (cv) uri = cv.toDataURL('image/png'); } catch (e) {}
    }
    if (uri) triggerDownload(uri, (m3dCid ? 'molecule-' + m3dCid : 'molecule') + '-3d.png');
  }

  // ── Rasterise an inline <svg> to a PNG download ──
  function svgElToPng(svgEl, filename, scale) {
    scale = scale || 2;
    const clone = svgEl.cloneNode(true);
    const w = svgEl.viewBox && svgEl.viewBox.baseVal && svgEl.viewBox.baseVal.width || svgEl.clientWidth || 300;
    const h = svgEl.viewBox && svgEl.viewBox.baseVal && svgEl.viewBox.baseVal.height || svgEl.clientHeight || 220;
    clone.setAttribute('width', w); clone.setAttribute('height', h);
    const xml = new XMLSerializer().serializeToString(clone);
    const url = URL.createObjectURL(new Blob([xml], { type: 'image/svg+xml' }));
    const img = new Image();
    img.onload = () => {
      const cv = document.createElement('canvas');
      cv.width = w * scale; cv.height = h * scale;
      const ctx = cv.getContext('2d');
      ctx.fillStyle = '#fff'; ctx.fillRect(0, 0, cv.width, cv.height);
      ctx.drawImage(img, 0, 0, cv.width, cv.height);
      URL.revokeObjectURL(url);
      cv.toBlob((blob) => triggerDownload(URL.createObjectURL(blob), filename));
    };
    img.onerror = () => { URL.revokeObjectURL(url); };
    img.src = url;
  }
  function triggerDownload(href, filename) {
    const a = document.createElement('a');
    a.href = href; a.download = filename; document.body.appendChild(a); a.click(); a.remove();
  }

  // ── Composition equation diagram ───────────────────────────
  // Resolve a SMILES for a composition part: standard elemental form,
  // single-atom, else a PubChem lookup of that part's formula.
  function splitPart(part) {
    const m = String(part).match(/^([A-Z][a-z]?)(\d*)$/);
    return m ? { sym: m[1], n: m[2] ? parseInt(m[2], 10) : 1 } : null;
  }
  async function resolvePartSmiles(part) {
    if (partCache[part] !== undefined) return partCache[part];
    let smi = null;
    const cached = cacheGet(part);            // 1) local cache
    if (cached && cached[0] && cached[0].smiles) {
      smi = cached[0].smiles;
    } else if (DIATOMIC[part]) {              // 2) standard elemental form
      smi = DIATOMIC[part];
    } else {
      const sp = splitPart(part);
      if (sp && sp.n === 1) {
        smi = '[' + sp.sym + ']'; // single atom
      } else {
        try {
          let data = await callProxy({ action: 'formula', formula: part });
          data = await resolve(data);
          const list = data && data.PropertyTable && data.PropertyTable.Properties;
          if (list && list.length) smi = smilesOf(list[0]);
        } catch (e) { /* leave null */ }
      }
    }
    partCache[part] = smi;
    return smi;
  }
  function svgFor(smi, w, h) {
    if (!OCL || !smi) return null;
    try { return OCL.Molecule.fromSmiles(smi).toSVG(w || 150, h || 120, null, { suppressChiralText: true, autoCrop: true }); }
    catch (e) { return null; }
  }
  function tile(label, svg) {
    return '<div class="eq-tile"><div class="eq-struct">' +
      (svg || '<span class="eq-bigformula">' + label + '</span>') +
      '</div><div class="eq-cap">' + label + '</div></div>';
  }
  let lastCompCanvas = null; // the merged composition figure (for download)
  async function openComposition(productSmiles) {
    if (!lastReactants.length) return;
    const ov = $('eq-overlay'), row = $('eq-row');
    $('eq-formula').textContent = lastFormula;
    row.innerHTML = '<span class="spin"></span> Building diagram…';
    ov.hidden = false;
    document.body.classList.add('eq-open');

    const items = [];
    for (let i = 0; i < lastReactants.length; i++) {
      if (i > 0) items.push({ op: '+' });
      const r = lastReactants[i];
      const smi = await resolvePartSmiles(r.sp);
      items.push({ label: fmtSp(r.n, r.sp), svg: svgFor(smi) });
    }
    items.push({ op: '→' });
    const prodCoef = (lastProducts[0] && lastProducts[0].n > 1) ? lastProducts[0].n + ' ' : '';
    items.push({ label: prodCoef + sub(lastFormula), svg: svgFor(productSmiles, 170, 140) });

    // One textbook-style merged figure (same composer as the balanced equation).
    lastCompCanvas = await composeEquationCanvas(items);
    row.innerHTML = lastCompCanvas
      ? '<img class="eq-figimg" alt="Formation from elements" src="' + lastCompCanvas.toDataURL('image/png') + '">'
      : '(could not render diagram)';
  }
  function closeComposition() {
    $('eq-overlay').hidden = true;
    document.body.classList.remove('eq-open');
  }

  // SVG string → Image (for canvas composition)
  function svgStrToImage(svgStr) {
    return new Promise((res) => {
      const url = URL.createObjectURL(new Blob([svgStr], { type: 'image/svg+xml' }));
      const img = new Image();
      img.onload = () => { URL.revokeObjectURL(url); res(img); };
      img.onerror = () => { URL.revokeObjectURL(url); res(null); };
      img.src = url;
    });
  }
  function downloadComposition() {
    if (!lastCompCanvas) return;
    lastCompCanvas.toBlob((b) => triggerDownload(URL.createObjectURL(b), (lastFormula || 'composition') + '-formation.png'));
  }

  function handle(data) {
    if (data && data.PropertyTable && data.PropertyTable.Properties && data.PropertyTable.Properties.length) {
      renderResults(data.PropertyTable.Properties);
    } else if (data && data.Fault) {
      $('results').innerHTML = '';
      setStatus('No compounds found for that formula' + (data.Fault.Code ? ' (' + data.Fault.Code + ')' : '') + '.', true);
    } else if (data && data.Waiting) {
      setStatus('Still searching — please try again in a moment.', true);
    } else {
      setStatus('Unexpected response — please try again.', true);
    }
  }

  async function search() {
    if (busy) return;
    const input = $('formula').value.trim();
    if (!input) { setStatus('Enter a formula, or an equation with “=”.', true); return; }

    const norm = input.replace(/⟶|⇌|→|=>|->/g, '=');
    if (norm.includes('=')) {
      const sides = norm.split('=').map((s) => s.trim());
      if (sides.length === 2 && sides[0] && sides[1]) return balanceEquation(input);   // full equation
      if (sides[0] && !sides.slice(1).join('')) return predictReaction(splitSide(sides[0])); // reactants only ("C+O2=")
      setStatus('Use one “=” with reactants on the left and products on the right.', true); return;
    }
    // No "=": multiple reactants joined by "+" → let AI predict products, chempy verify.
    if (/\+/.test(input)) return predictReaction(splitSide(input));
    // Otherwise: a single formula → structure lookup.
    const formula = input;
    if (!/^[A-Za-z0-9()\[\]+\-]{1,80}$/.test(formula)) { setStatus('That doesn’t look like a molecular formula.', true); return; }
    return lookupFormula(formula);
  }

  // The single-formula path: cache → PubChem → multiple compound cards.
  // Reused both by the search box and by drilling into an equation species,
  // so every formula gets the SAME set of images + selection UI.
  async function lookupFormula(formula) {
    busy = true;
    $('searchBtn').disabled = true;
    $('results').innerHTML = '';
    computeFormation(formula); // formation banner, in parallel

    const hit = cacheGet(formula);
    if (hit && hit.length) {
      renderResults(hit.map((e) => ({ CID: e.cid, SMILES: e.smiles, ConnectivitySMILES: e.conn })), true);
      busy = false; $('searchBtn').disabled = false;
      return;
    }
    setStatus('<span class="spin"></span>Searching for <strong>' + formula + '</strong>…');
    try {
      let data = await callProxy({ action: 'formula', formula });
      data = await resolve(data);
      handle(data);
    } catch (e) {
      setStatus('Lookup failed: ' + (e && e.message ? e.message : 'network error') + '.', true);
    } finally {
      busy = false; $('searchBtn').disabled = false;
    }
  }

  // Drill from a balanced-equation species into the full formula flow.
  let lastEquationHTML = '';
  let lastEquationText = '';   // plain "reactants = products" for the Edit box
  function editEquation() {
    if (!lastEquationText) return;
    $('formula').value = lastEquationText;
    $('formula').focus();
    $('formula').select();
    setStatus('Edit the equation and press Look up to re-balance.');
  }
  async function drillSpecies(sp) {
    $('formula').value = sp;
    await lookupFormula(sp);
    const bar = document.createElement('button');
    bar.className = 'eq-back';
    bar.type = 'button';
    bar.innerHTML = '‹ Back to balanced equation';
    bar.addEventListener('click', restoreEquation);
    $('results').insertBefore(bar, $('results').firstChild);
  }
  function restoreEquation() {
    $('breakdown').hidden = true;
    $('results').innerHTML = lastEquationHTML;
    setStatus('Balanced ✓');
  }

  $('searchBtn').addEventListener('click', search);
  $('formula').addEventListener('keydown', (e) => { if (e.key === 'Enter') search(); });
  document.querySelectorAll('.chip').forEach((c) => {
    c.addEventListener('click', () => { $('formula').value = c.getAttribute('data-f'); search(); });
  });
  // Results actions (delegated once — copy / view composition)
  $('results').addEventListener('click', onResultsClick);
  // Dismiss the sticky detail popover on outside-click; drop it on scroll/resize (avoids stale position).
  document.addEventListener('click', (e) => { if (popSticky && !e.target.closest('.mol-pop') && !e.target.closest('[data-info]')) hidePop(true); });
  window.addEventListener('scroll', () => hidePop(true), true);
  window.addEventListener('resize', () => hidePop(true));
  // Composition modal
  $('eq-close').addEventListener('click', closeComposition);
  $('eq-overlay').addEventListener('click', (e) => { if (e.target === $('eq-overlay')) closeComposition(); });
  $('eq-dl').addEventListener('click', downloadComposition);
  // 3D modal
  $('mol3d-close').addEventListener('click', close3D);
  $('mol3d-overlay').addEventListener('click', (e) => { if (e.target === $('mol3d-overlay')) close3D(); });
  // Lewis modal
  $('lewis-close').addEventListener('click', closeLewis);
  $('lewis-overlay').addEventListener('click', (e) => { if (e.target === $('lewis-overlay')) closeLewis(); });
  document.querySelectorAll('#m3d-styles button').forEach((b) => b.addEventListener('click', () => {
    m3dStyle = b.getAttribute('data-style');
    document.querySelectorAll('#m3d-styles button').forEach((x) => x.classList.toggle('active', x === b));
    m3dApply();
  }));
  $('m3d-h').addEventListener('change', m3dApply);
  $('m3d-spin').addEventListener('change', () => { if (m3dViewer) m3dViewer.spin($('m3d-spin').checked ? 'y' : false); });
  $('m3d-png').addEventListener('click', m3dDownloadImage);
  $('m3d-downloads').addEventListener('click', (e) => {
    const btn = e.target.closest('[data-dl-fmt]'); if (!btn) return;
    const fmt = btn.getAttribute('data-dl-fmt');
    if (btn.getAttribute('data-act') === 'save') m3dSave(fmt); else m3dDisplay(fmt);
  });
  document.addEventListener('keydown', (e) => {
    if (e.key !== 'Escape') return;
    if (!$('eq-overlay').hidden) closeComposition();
    if (!$('mol3d-overlay').hidden) close3D();
    if (!$('lewis-overlay').hidden) closeLewis();
  });

  // Optional: ?formula= deep-link
  const initF = new URLSearchParams(location.search).get('formula');
  if (initF) { $('formula').value = initF; search(); }
</script>

<%@ include file="/modern/ads/ad-sticky-footer.jsp" %>
<%@ include file="/modern/components/analytics.jsp" %>

</body>
</html>
