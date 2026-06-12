<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<jsp:include page="modern/components/seo-tool-page.jsp">
    <jsp:param name="toolName" value="Interactive Periodic Table of Elements" />
    <jsp:param name="toolCategory" value="Chemistry" />
    <jsp:param name="toolDescription" value="Explore all 118 elements on a fast interactive periodic table. Click any element for its properties — atomic mass, electron configuration, electronegativity, melting and boiling points and more — colour the table by 20 periodic trends, view a 3D atom model, compare elements side by side, and search instantly." />
    <jsp:param name="toolUrl" value="periodic-table.jsp" />
    <jsp:param name="toolKeywords" value="periodic table, interactive periodic table, periodic table of elements, element properties, electron configuration, atomic mass, electronegativity, periodic trends, atomic radius, ionization energy, element families, electron blocks, bohr model, chemistry reference" />
    <jsp:param name="toolImage" value="periodic-table-og.png" />
    <jsp:param name="breadcrumbCategoryUrl" value="chemistry/" />
    <jsp:param name="teaches" value="periodic table, chemical elements, electron configuration, periodic trends, atomic structure, element families, electron blocks" />
    <jsp:param name="educationalLevel" value="High School, Undergraduate" />
    <jsp:param name="hasSteps" value="true" />
    <jsp:param name="howToSteps" value="Find an element|Click any of the 118 elements on the table, or type a name, symbol or atomic number in the search box,Read its properties|The panel shows atomic mass, electron configuration, electronegativity, melting and boiling points, density and more — plus an animated 3D atom model,Visualise a trend|Use the Color by control (or the / key) to shade the whole table by atomic radius, electronegativity, ionization energy and 17 other properties,Compare elements|Turn on Compare and pin up to four elements to see their Bohr models and key properties side by side" />
    <jsp:param name="faq1q" value="What is the periodic table?" />
    <jsp:param name="faq1a" value="The periodic table arranges all 118 known chemical elements by increasing atomic number into rows called periods and columns called groups. Elements in the same group share similar chemical behaviour because they have the same number of valence electrons. This interactive version lets you click any element for its full properties and colour the whole table by any periodic trend." />
    <jsp:param name="faq2q" value="How do I read the periodic table?" />
    <jsp:param name="faq2a" value="Each cell shows the element's atomic number (the number of protons) and its chemical symbol. Across a period from left to right the atomic number increases by one each step; down a group from top to bottom elements gain an electron shell. Metals sit on the left and centre, non-metals on the upper right, and the metalloids form the staircase between them." />
    <jsp:param name="faq3q" value="What are periodic trends?" />
    <jsp:param name="faq3a" value="Periodic trends are repeating patterns in element properties. Atomic radius increases down a group and decreases across a period, while electronegativity and ionization energy do the opposite. Pick any property in the Color by control to shade the table from low (blue) to high (red) and see the trend at a glance." />
    <jsp:param name="faq4q" value="What do the element families and electron blocks mean?" />
    <jsp:param name="faq4a" value="Families such as alkali metals, halogens and noble gases group elements with similar chemistry, while the s, p, d and f blocks tell you which electron sub-shell the outermost electrons occupy. Click any family or block below the table to highlight its elements and read a description." />
    <jsp:param name="faq5q" value="Can I compare elements or see a 3D atom?" />
    <jsp:param name="faq5a" value="Yes. Selecting an element shows an animated 3D atom model with the nucleus and electrons orbiting in their shells. Turn on Compare mode to pin up to four elements and view their Bohr diagrams and key properties side by side, with the highest value in each row highlighted." />
    <jsp:param name="faq6q" value="Is the interactive periodic table free?" />
    <jsp:param name="faq6a" value="Yes. It is completely free, runs entirely in your browser, needs no signup, and works on both desktop and mobile." />
</jsp:include>

<link rel="stylesheet" href="<%=ctx%>/modern/css/design-system.css">
<link rel="stylesheet" href="<%=ctx%>/modern/css/navigation.css">
<link rel="stylesheet" href="<%=ctx%>/chemistry/css/chemistry-studio.css">
<link rel="stylesheet" href="<%=ctx%>/modern/css/ads.css">
<link rel="stylesheet" href="<%=ctx%>/modern/css/dark-mode.css">
<link rel="stylesheet" href="<%=ctx%>/modern/css/footer.css">
<link rel="stylesheet" href="<%=ctx%>/modern/css/search.css">

<style>
    /* ════════════════════════════════════════════════════════════════
       Periodic Table — a web port of periodic-table-cli (terminal viewer).
       Element data reused verbatim (MIT, © 2022 Spiro Metaxas). Rendered
       as a dark "console" panel embedded in the chemistry studio shell.
       ════════════════════════════════════════════════════════════════ */
    .ptv {
        --ptv-bg:#0c0e13; --ptv-panel:#14171f; --ptv-soft:#1b1f2a;
        --ptv-line:rgba(255,255,255,0.09); --ptv-line2:rgba(255,255,255,0.16);
        --ptv-ink:#dce3ee; --ptv-dim:#828c9a; --ptv-faint:#5a6473;
        --ptv-gold:#ffce4a; --ptv-blue:#54b8ff;
        --ptv-mono:'JetBrains Mono', ui-monospace, 'SF Mono', Menlo, Consolas, monospace;
        background:var(--ptv-bg); color:var(--ptv-ink);
        border:1px solid var(--ptv-line); border-radius:var(--cs-radius-lg);
        box-shadow:var(--cs-shadow-lg); overflow:hidden;
        font-family:var(--ptv-mono); position:relative;
    }
    /* Top bar */
    .ptv-bar { display:flex; align-items:center; gap:0.75rem; flex-wrap:wrap;
        padding:0.7rem 1rem; background:linear-gradient(180deg,var(--ptv-soft),var(--ptv-panel));
        border-bottom:1px solid var(--ptv-line); }
    .ptv-title { font-weight:700; letter-spacing:0.12em; font-size:0.78rem; color:var(--ptv-gold); text-transform:uppercase; display:flex; align-items:center; gap:0.5rem; }
    .ptv-title::before { content:""; width:9px;height:9px;border-radius:50%;background:#ff5f57; box-shadow:16px 0 0 #febc2e, 32px 0 0 #28c840; margin-right:30px; }
    .ptv-spacer { flex:1; }
    .ptv-search { display:flex; align-items:center; gap:0.4rem; background:var(--ptv-bg); border:1px solid var(--ptv-line2); border-radius:var(--cs-radius-pill); padding:0.3rem 0.7rem; }
    .ptv-search input { background:none; border:none; outline:none; color:var(--ptv-ink); font:13px var(--ptv-mono); width:11rem; }
    .ptv-search::before { content:"⌕"; color:var(--ptv-faint); }
    .ptv-mode { display:flex; align-items:center; gap:0.3rem; }
    .ptv-step { background:var(--ptv-bg); border:1px solid var(--ptv-line2); color:var(--ptv-ink); width:26px; height:26px; border-radius:6px; cursor:pointer; font:14px var(--ptv-mono); }
    .ptv-step:hover { border-color:var(--ptv-gold); color:var(--ptv-gold); }
    .ptv-mode-name { min-width:11rem; text-align:center; font-size:0.78rem; color:var(--ptv-blue); }
    .ptv-mode-name b { color:var(--ptv-ink); }

    /* Main split: table | panel */
    .ptv-main { display:grid; grid-template-columns:minmax(0,1fr) 320px; gap:0; }
    @media (max-width:920px){ .ptv-main { grid-template-columns:minmax(0,1fr); } }
    .ptv-left { padding:1rem; border-right:1px solid var(--ptv-line); min-width:0; }
    @media (max-width:920px){ .ptv-left { border-right:none; border-bottom:1px solid var(--ptv-line); } }
    .ptv-side { display:flex; flex-direction:column; min-width:0; background:var(--ptv-panel); }
    /* 3D atom (vanilla Three.js port of atom-animation) */
    .ptv-atom { position:relative; height:230px; flex-shrink:0;
        background:radial-gradient(circle at 50% 45%, rgba(82,184,255,0.10), transparent 60%), #0a0c11;
        border-bottom:1px solid var(--ptv-line); overflow:hidden; cursor:grab; }
    .ptv-atom.grab { cursor:grabbing; }
    .ptv-atom canvas { display:block; width:100%; height:100%; }
    .ptv-atom-cap { position:absolute; left:10px; bottom:8px; font-size:0.6rem; letter-spacing:0.06em; text-transform:uppercase; color:var(--ptv-faint); pointer-events:none; }
    .ptv-atom-cap b { color:var(--ptv-blue); }
    .ptv-gridscroll { overflow-x:auto; padding-bottom:0.35rem; }
    .ptv-grid { display:grid; grid-template-columns:repeat(18, minmax(30px,1fr)); gap:3px; min-width:640px; }

    .ptv-cell { position:relative; aspect-ratio:1; border:1px solid var(--cellc,var(--ptv-line2));
        border-radius:4px; background:var(--cellbg,transparent); cursor:pointer;
        display:flex; flex-direction:column; align-items:center; justify-content:center;
        line-height:1; padding:1px; transition:transform .08s, box-shadow .12s; min-width:0; }
    .ptv-cell .z { position:absolute; top:2px; left:3px; font-size:0.5rem; color:var(--celltext,var(--ptv-dim)); opacity:0.85; }
    .ptv-cell .sym { font-size:0.92rem; font-weight:700; color:var(--celltext,var(--ptv-ink)); }
    .ptv-cell .mini { font-size:0.42rem; color:var(--celltext,var(--ptv-dim)); opacity:0.8; margin-top:1px; min-height:0.42rem; }
    .ptv-cell:hover { transform:translateY(-1px); box-shadow:0 0 0 1px var(--ptv-line2); z-index:2; }
    .ptv-cell.sel { box-shadow:0 0 0 2px var(--ptv-gold), 0 0 14px rgba(255,206,74,0.35); z-index:3; }
    .ptv-cell.sel .sym, .ptv-cell.sel .z { color:#fff; }
    .ptv-cell.dim { opacity:0.18; }
    .ptv-fstub { font-size:0.5rem; color:var(--ptv-faint); display:flex; align-items:center; justify-content:center; border:1px dashed var(--ptv-line2); border-radius:4px; aspect-ratio:1; }
    .ptv-fspacer { grid-column:1/-1; height:6px; }

    /* Browse rows (families + blocks) */
    .ptv-browse { margin-top:0.9rem; display:flex; flex-direction:column; gap:0.5rem; }
    .ptv-browse-row { display:flex; align-items:center; gap:0.35rem; flex-wrap:wrap; }
    .ptv-browse-lbl { font-size:0.6rem; letter-spacing:0.08em; text-transform:uppercase; color:var(--ptv-faint); width:5.5rem; flex-shrink:0; }
    .ptv-tag { font-size:0.66rem; padding:0.18rem 0.5rem; border-radius:var(--cs-radius-pill); border:1px solid var(--tagc,var(--ptv-line2)); color:var(--tagc,var(--ptv-ink)); cursor:pointer; background:transparent; white-space:nowrap; }
    .ptv-tag:hover { background:rgba(255,255,255,0.05); }
    .ptv-tag.on { background:var(--tagc,var(--ptv-blue)); color:#0c0e13; font-weight:700; border-color:var(--tagc,var(--ptv-blue)); }
    .ptv-tag.cur { box-shadow:inset 0 0 0 1.5px var(--ptv-gold); color:var(--ptv-gold); }
    .ptv-results .rtag { font-size:0.58rem; color:var(--ptv-faint); border:1px solid var(--ptv-line2); border-radius:4px; padding:0 4px; text-transform:uppercase; letter-spacing:0.05em; }

    /* Right data panel */
    .ptv-panel { padding:1rem 1.1rem; min-width:0; background:var(--ptv-panel); }
    .ptv-p-sym { display:flex; align-items:baseline; gap:0.6rem; }
    .ptv-p-sym .big { font-size:2.4rem; font-weight:800; color:var(--ptv-gold); line-height:1; }
    .ptv-p-sym .z { font-size:0.8rem; color:var(--ptv-dim); }
    .ptv-p-name { font-size:1.05rem; color:var(--ptv-ink); margin:0.3rem 0 0.1rem; font-weight:600; }
    .ptv-p-fam { font-size:0.72rem; color:var(--famc,var(--ptv-blue)); text-transform:uppercase; letter-spacing:0.06em; }
    .ptv-p-list { margin-top:0.9rem; display:grid; grid-template-columns:1fr; gap:1px; }
    .ptv-p-row { display:flex; justify-content:space-between; gap:0.75rem; padding:0.3rem 0; border-bottom:1px dotted var(--ptv-line); font-size:0.74rem; }
    .ptv-p-row .k { color:var(--ptv-faint); }
    .ptv-p-row .v { color:var(--ptv-ink); text-align:right; font-weight:600; }
    .ptv-p-desc { font-size:0.76rem; color:var(--ptv-dim); line-height:1.6; }
    .ptv-p-desc h4 { color:var(--ptv-gold); font-size:0.78rem; margin:0 0 0.4rem; text-transform:uppercase; letter-spacing:0.05em; }

    /* Footer: mode legend / scale + key hints */
    .ptv-foot { border-top:1px solid var(--ptv-line); padding:0.6rem 1rem; background:var(--ptv-panel); display:flex; align-items:center; gap:1rem; flex-wrap:wrap; }
    .ptv-scale { display:flex; align-items:center; gap:0.4rem; flex-wrap:wrap; font-size:0.66rem; color:var(--ptv-dim); }
    .ptv-scale .bar { width:160px; height:10px; border-radius:5px; border:1px solid var(--ptv-line2); }
    .ptv-sw { display:inline-flex; align-items:center; gap:0.3rem; }
    .ptv-sw i { width:11px; height:11px; border-radius:3px; display:inline-block; }
    .ptv-keys { margin-left:auto; font-size:0.64rem; color:var(--ptv-faint); }
    .ptv-keys kbd { background:var(--ptv-bg); border:1px solid var(--ptv-line2); border-radius:4px; padding:0 4px; color:var(--ptv-dim); font:inherit; }

    /* search dropdown */
    .ptv-results { position:absolute; z-index:20; background:var(--ptv-panel); border:1px solid var(--ptv-line2); border-radius:8px; margin-top:4px; max-height:260px; overflow:auto; box-shadow:var(--cs-shadow-lg); min-width:14rem; }
    .ptv-results button { display:flex; width:100%; gap:0.5rem; align-items:center; background:none; border:none; color:var(--ptv-ink); padding:0.4rem 0.7rem; cursor:pointer; font:0.75rem var(--ptv-mono); text-align:left; }
    .ptv-results button:hover, .ptv-results button.on { background:rgba(255,206,74,0.12); }
    .ptv-results .rz { color:var(--ptv-faint); width:1.8rem; }

    /* Compare mode (opt-in; default browse is untouched) */
    .ptv-cmp-btn { background:var(--ptv-bg); border:1px solid var(--ptv-line2); color:var(--ptv-ink); border-radius:var(--cs-radius-pill); padding:0.3rem 0.8rem; font:600 0.72rem var(--ptv-mono); cursor:pointer; }
    .ptv-cmp-btn:hover { border-color:var(--ptv-gold); color:var(--ptv-gold); }
    .ptv-cmp-btn.on { background:var(--ptv-gold); color:#0c0e13; border-color:var(--ptv-gold); }
    .ptv-cell.pin { box-shadow:0 0 0 2px var(--ptv-blue); z-index:3; }
    .ptv-cell .pinbadge { position:absolute; top:1px; right:3px; font-size:0.5rem; font-weight:700; color:var(--ptv-blue); }
    .ptv-compare { border-top:1px solid var(--ptv-line); background:var(--ptv-panel); padding:0.8rem 1rem 1rem; }
    .ptv-cmp-head { display:flex; align-items:center; justify-content:space-between; gap:0.75rem; margin-bottom:0.7rem; font-size:0.72rem; color:var(--ptv-dim); }
    .ptv-cmp-clear { background:none; border:1px solid var(--ptv-line2); color:var(--ptv-dim); border-radius:var(--cs-radius-pill); padding:0.2rem 0.7rem; cursor:pointer; font:0.66rem var(--ptv-mono); }
    .ptv-cmp-clear:hover { border-color:var(--ptv-gold); color:var(--ptv-gold); }
    .ptv-cmp-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(150px,1fr)); gap:0.7rem; }
    .ptv-cmp-card { border:1px solid var(--ptv-line2); border-radius:10px; background:var(--ptv-bg); padding:0.7rem; }
    .ptv-cmp-card .ch { display:flex; align-items:center; gap:0.5rem; margin-bottom:0.5rem; }
    .ptv-cmp-card .ch .sym { font-size:1.3rem; font-weight:800; line-height:1; }
    .ptv-cmp-card .ch .nm { font-size:0.66rem; color:var(--ptv-dim); line-height:1.3; }
    .ptv-cmp-card .x { margin-left:auto; cursor:pointer; color:var(--ptv-faint); border:none; background:none; font-size:0.85rem; }
    .ptv-cmp-card .x:hover { color:var(--ptv-gold); }
    .ptv-cmp-row { display:flex; justify-content:space-between; gap:0.5rem; font-size:0.64rem; padding:0.16rem 0; border-bottom:1px dotted var(--ptv-line); }
    .ptv-cmp-row .k { color:var(--ptv-faint); }
    .ptv-cmp-row .v { color:var(--ptv-ink); text-align:right; }
    .ptv-cmp-row .v.win { color:#69db7c; font-weight:700; }
    /* 2D Bohr model (lightweight; one per compare card) */
    .ptv-bohr { display:block; margin:0 auto 0.5rem; }
    .ptv-bohr .ring { fill:none; stroke:rgba(255,255,255,0.15); stroke-width:1; }
    .ptv-bohr .nuc { fill:#ff554d; }
    .ptv-bohr .nsym { fill:#fff; font:700 9px var(--ptv-mono); text-anchor:middle; dominant-baseline:central; }
    .ptv-bohr .be { animation:ptv-orbit linear infinite; }
    .ptv-bohr .el { fill:#33ccff; }
    @keyframes ptv-orbit { to { transform:rotate(360deg); } }
    @media (prefers-reduced-motion: reduce){ .ptv-bohr .be { animation:none; } }

    .ptv-note { font-size:0.7rem; color:var(--cs-muted); margin:0.6rem 0 0; }

    /* Below-fold content (light studio context) */
    .pt-seo { display:flex; flex-direction:column; gap:1rem; margin-top:1.25rem; }
    .pt-seo-card { background:var(--cs-panel-bg); border:1px solid var(--cs-line); border-radius:var(--cs-radius-lg); box-shadow:var(--cs-shadow-sm); padding:1.5rem 1.6rem; }
    .pt-seo-card h2 { font:400 1.4rem var(--cs-font-serif); color:var(--cs-ink); margin:0 0 0.6rem; }
    .pt-seo-card h3 { font:600 0.95rem var(--cs-font-sans); color:var(--cs-ink); margin:1rem 0 0.4rem; }
    .pt-seo-card p, .pt-seo-card li { color:var(--cs-ink-soft); font-size:0.93rem; line-height:1.7; }
    .pt-seo-card ul, .pt-seo-card ol { margin:0.4rem 0 0; padding-left:1.2rem; }
    .pt-seo-card li { margin-bottom:0.4rem; }
    .pt-seo-card kbd { background:var(--cs-panel-bg-soft); border:1px solid var(--cs-line-strong); border-radius:4px; padding:0 5px; font:0.8em var(--cs-font-mono); color:var(--cs-ink-soft); }
    .pt-seo-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(220px,1fr)); gap:0.7rem; margin-top:0.6rem; }
    .pt-seo-item { border-left:3px solid var(--sc,var(--cs-accent)); background:var(--cs-panel-bg-soft); border-radius:var(--cs-radius-sm); padding:0.7rem 0.9rem; }
    .pt-seo-item h4 { font:600 0.85rem var(--cs-font-sans); color:var(--cs-ink); margin:0 0 0.3rem; }
    .pt-seo-item p { font-size:0.8rem; color:var(--cs-muted); line-height:1.55; margin:0; }
    .ptv-note a { color:var(--cs-accent); }
</style>
</head>
<body class="cs-body">
<%@ include file="modern/components/nav-header.jsp" %>

<div class="cs-hero">
    <%@ include file="modern/ads/ad-hero-banner.jsp" %>
</div>

<%-- Sidebar auto-hidden on this page (the periodic table wants the width); the
     toggle button still lets the user bring it back. --%>
<main class="cs-main is-sidebar-hidden">
    <button type="button" id="csSidebarToggle" class="cs-sidebar-toggle" aria-label="Open chemistry tools menu">&#9776; Chemistry tools</button>
    <% request.setAttribute("activeService", "periodic"); %>
    <jsp:include page="/chemistry/partials/sidebar.jsp" />

    <section class="cs-workspace">

<div class="cs-title">
    <nav class="cs-crumbs" aria-label="Breadcrumb">
        <a href="<%=ctx%>/index.jsp">Home</a> /
        <a href="<%=ctx%>/chemistry/">Chemistry</a> /
        <span aria-current="page">Periodic Table</span>
    </nav>
    <h1>Interactive Periodic Table of Elements</h1>
</div>

<div class="ic-stack">

    <div class="ptv" id="ptv">
        <div class="ptv-bar">
            <span class="ptv-title">Periodic Table</span>
            <div class="ptv-search" style="position:relative;">
                <input type="text" id="ptSearch" placeholder="search element…" autocomplete="off" spellcheck="false">
                <div id="ptResults" class="ptv-results" hidden></div>
            </div>
            <div class="ptv-spacer"></div>
            <button type="button" class="ptv-cmp-btn" id="ptCompareBtn" title="Compare mode — pin up to 4 elements">&#8862; Compare</button>
            <div class="ptv-mode">
                <button type="button" class="ptv-step" id="ptPrev" title="Previous display (\\)">&#9665;</button>
                <span class="ptv-mode-name">Color by <b id="ptModeName">Families</b></span>
                <button type="button" class="ptv-step" id="ptNext" title="Next display (/)">&#9655;</button>
            </div>
        </div>

        <div class="ptv-main">
            <div class="ptv-left">
                <div class="ptv-gridscroll">
                    <div class="ptv-grid" id="ptGrid" tabindex="0" aria-label="Periodic table grid"></div>
                </div>
                <div class="ptv-browse">
                    <div class="ptv-browse-row"><span class="ptv-browse-lbl">Families</span><span id="ptFamilies"></span></div>
                    <div class="ptv-browse-row"><span class="ptv-browse-lbl">Blocks</span><span id="ptBlocks"></span></div>
                </div>
            </div>
            <div class="ptv-side">
                <div class="ptv-atom" id="ptAtom" aria-hidden="true"></div>
                <div class="ptv-panel" id="ptPanel"></div>
            </div>
        </div>

        <div class="ptv-compare" id="ptCompare" hidden>
            <div class="ptv-cmp-head">
                <span id="ptCmpTitle">Compare — pick up to 4 elements on the table</span>
                <button type="button" class="ptv-cmp-clear" id="ptCmpClear">Clear</button>
            </div>
            <div class="ptv-cmp-grid" id="ptCmpGrid"></div>
        </div>

        <div class="ptv-foot">
            <div class="ptv-scale" id="ptScale"></div>
            <div class="ptv-keys">
                <kbd>&#8592;&#8593;&#8595;&#8594;</kbd> move &nbsp; <kbd>/</kbd> <kbd>\</kbd> color mode &nbsp; <kbd>Esc</kbd> clear
            </div>
        </div>
    </div>

    <%-- Element data adapted from periodic-table-cli (MIT, © 2022 Spiro Metaxas); see js/periodic-table-data.js header. --%>

    <div class="cs-inline-ad">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>

</div>

<!-- ===== Below-the-fold content (SEO / reference) ===== -->
<section class="pt-seo">
    <div class="pt-seo-card">
        <h2>What is the periodic table?</h2>
        <p>The <strong>periodic table of elements</strong> arranges all <strong>118 known chemical elements</strong> by increasing <strong>atomic number</strong> into horizontal rows called <strong>periods</strong> and vertical columns called <strong>groups</strong>. First published by Dmitri Mendeleev in 1869, its power is that elements line up by recurring chemical behaviour: members of the same group have the same number of <strong>valence electrons</strong>, so they react in similar ways. Metals occupy the left and centre, non-metals the upper right, and the <em>metalloids</em> form the staircase between them.</p>
        <h3>How to read it</h3>
        <p>Each cell shows an element's <strong>atomic number</strong> (its proton count) and its one- or two-letter <strong>symbol</strong>. Moving left to right across a period, the atomic number rises by one at each step and a new electron is added to the same outer shell; moving down a group, each element adds a whole new shell. The two detached rows beneath the table are the <strong>lanthanides</strong> (57–71) and <strong>actinides</strong> (89–103), the f-block elements pulled out to keep the chart compact.</p>
    </div>

    <div class="pt-seo-card">
        <h2>Periodic trends you can visualise</h2>
        <p>Use the <strong>Color by</strong> control (or the <kbd>/</kbd> key) to shade the whole table by any of 20 properties, from low (blue) to high (red), so the underlying <strong>periodic trends</strong> jump out:</p>
        <ul>
            <li><strong>Atomic radius</strong> increases down a group (more shells) and decreases across a period (stronger nuclear pull).</li>
            <li><strong>Electronegativity</strong> and <strong>ionization energy</strong> do the opposite — rising across a period and falling down a group.</li>
            <li><strong>Atomic mass, density, melting and boiling points, specific heat</strong> and more each reveal their own pattern across the chart.</li>
        </ul>
    </div>

    <div class="pt-seo-card">
        <h2>Element families</h2>
        <p>Families group elements that behave alike. Click any family below the table to highlight its members.</p>
        <div class="pt-seo-grid" id="ptSeoFamilies"></div>
    </div>

    <div class="pt-seo-card">
        <h2>Electron blocks: s, p, d and f</h2>
        <p>An element's block tells you which electron sub-shell its outermost electrons occupy — a quick guide to its chemistry.</p>
        <div class="pt-seo-grid" id="ptSeoBlocks"></div>
    </div>

    <div class="pt-seo-card">
        <h2>How to use this interactive periodic table</h2>
        <ol>
            <li><strong>Find an element</strong> — click any cell, or type a name, symbol or atomic number in the search box (it also matches families and blocks).</li>
            <li><strong>Read its properties</strong> — the panel lists atomic mass, electron configuration, electronegativity, melting and boiling points, density and more, with an animated <strong>3D atom model</strong>.</li>
            <li><strong>Visualise a trend</strong> — switch the <strong>Color by</strong> mode (or press <kbd>/</kbd> and <kbd>\</kbd>) to recolour the table by any property.</li>
            <li><strong>Compare elements</strong> — turn on <strong>Compare</strong> and pin up to four elements to see their Bohr diagrams and key numbers side by side.</li>
        </ol>
    </div>

    <h2 class="cs-faq-title" id="faqs">Frequently asked questions</h2>
    <div class="cs-faq" aria-label="Periodic table FAQ">
        <div class="cs-faq-item"><button class="cs-faq-q" type="button">What is the periodic table?<svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
            <div class="cs-faq-a">The periodic table arranges all 118 known chemical elements by increasing atomic number into rows called periods and columns called groups. Elements in the same group share similar chemical behaviour because they have the same number of valence electrons.</div></div>
        <div class="cs-faq-item"><button class="cs-faq-q" type="button">How do I read the periodic table?<svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
            <div class="cs-faq-a">Each cell shows the element's atomic number (the proton count) and its chemical symbol. Across a period the atomic number increases by one each step; down a group elements gain an electron shell. Metals sit on the left and centre, non-metals on the upper right, with metalloids on the staircase between them.</div></div>
        <div class="cs-faq-item"><button class="cs-faq-q" type="button">What are periodic trends?<svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
            <div class="cs-faq-a">Periodic trends are repeating patterns in element properties. Atomic radius increases down a group and decreases across a period, while electronegativity and ionization energy do the opposite. Pick any property in the Color by control to shade the table from low (blue) to high (red).</div></div>
        <div class="cs-faq-item"><button class="cs-faq-q" type="button">What do the element families and electron blocks mean?<svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
            <div class="cs-faq-a">Families such as alkali metals, halogens and noble gases group elements with similar chemistry, while the s, p, d and f blocks tell you which electron sub-shell the outermost electrons occupy. Click any family or block below the table to highlight its elements.</div></div>
        <div class="cs-faq-item"><button class="cs-faq-q" type="button">Can I compare elements or see a 3D atom?<svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
            <div class="cs-faq-a">Yes. Selecting an element shows an animated 3D atom model with the nucleus and electrons orbiting in their shells. Compare mode lets you pin up to four elements and view their Bohr diagrams and key properties side by side, highest value highlighted.</div></div>
        <div class="cs-faq-item"><button class="cs-faq-q" type="button">Is the interactive periodic table free?<svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button>
            <div class="cs-faq-a">Yes. It is completely free, runs entirely in your browser, needs no signup, and works on desktop and mobile.</div></div>
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
<script src="<%=ctx%>/js/periodic-table-data.js"></script>
<script>
(function () {
  "use strict";
  var D = window.PT_DATA || { elements: [], families: {}, shells: {} };
  var ELS = D.elements, FAM = D.families || {}, SH = D.shells || {};
  var byZ = {}; ELS.forEach(function (e) { byZ[e.atomicNumber] = e; });

  // ── palettes ────────────────────────────────────────────────────────
  var FAMILY_COLORS = {
    'Alkali metal':'#ff6b6b', 'Alkaline earth metal':'#ffa94d', 'Transition metal':'#ffd43b',
    'Post-transition metal':'#74c0fc', 'Metalloid':'#63e6be', 'Nonmetal':'#69db7c',
    'Halogen':'#a9e34b', 'Noble gas':'#da77f2', 'Lanthanide':'#b197fc', 'Actinide':'#f783ac'
  };
  var BLOCK_COLORS = { 's-shell':'#ff8787', 'p-shell':'#ffd43b', 'd-shell':'#74c0fc', 'f-shell':'#b197fc' };
  // Standard State — predicted states (marked "**" in the data) shown dimmer, like the CLI.
  var STATE_COLORS = { 'Solid':'#e9edf3', 'Solid **':'#828c9a', 'Liquid':'#ff6b6b', 'Liquid **':'#c92a2a', 'Gas':'#54b8ff', 'Gas **':'#3b5bdb' };
  var OCC_COLORS = { 'Natural':'#54b8ff', 'Rare':'#ffd43b', 'Synthetic':'#ff922b' };
  var BOOL_COLORS = { 'Radioactive':'#ff6b6b', 'Stable':'#69db7c' };
  var RAMP = ['#22d3ee','#2dd4bf','#34d399','#a3e635','#fde047','#fbbf24','#fb923c','#f97316','#ef4444'];

  function stripStars(v) { return v == null ? v : String(v).replace(/\s*\*+\s*$/, '').trim(); }
  function num(v) { if (v == null) return null; var m = String(v).match(/-?\d+(\.\d+)?/); return m ? parseFloat(m[0]) : null; }
  function rampColor(t) { if (t == null || isNaN(t)) return null; t = Math.max(0, Math.min(1, t)); return RAMP[Math.round(t * (RAMP.length - 1))]; }

  // ── display modes (20) ──────────────────────────────────────────────
  // Order mirrors periodic-table-cli (STANDARD default, then the 20 toggleable modes).
  var MODES = [
    { key:'standard',    name:'Standard',           type:'standard' },
    { key:'family',      name:'Families',           type:'cat', f:'family',           colors:FAMILY_COLORS },
    { key:'block',       name:'Electron Block',     type:'cat', f:'shell',            colors:BLOCK_COLORS },
    { key:'state',       name:'Standard State',     type:'cat', f:'standardState',    colors:STATE_COLORS },
    { key:'mass',        name:'Atomic Mass',        type:'num', f:'atomicMass' },
    { key:'protons',     name:'Protons',            type:'num', f:'numberOfProtons' },
    { key:'neutrons',    name:'Neutrons',           type:'num', f:'numberOfNeutrons' },
    { key:'electrons',   name:'Electrons',          type:'num', f:'numberOfElectrons' },
    { key:'valence',     name:'Valence Electrons',  type:'num', f:'numberOfValence' },
    { key:'valency',     name:'Valency',            type:'num', f:'valency' },
    { key:'radius',      name:'Atomic Radius',      type:'num', f:'atomicRadius' },
    { key:'density',     name:'Density',            type:'num', f:'density', log:true },
    { key:'eneg',        name:'Electronegativity',  type:'num', f:'electronegativity' },
    { key:'ion',         name:'Ionization Energy',  type:'num', f:'ionizationEnergy' },
    { key:'affinity',    name:'Electron Affinity',  type:'num', f:'electronAffinity' },
    { key:'melt',        name:'Melting Point',      type:'num', f:'meltingPoint' },
    { key:'boil',        name:'Boiling Point',      type:'num', f:'boilingPoint' },
    { key:'heat',        name:'Specific Heat',      type:'num', f:'specificHeat' },
    { key:'radioactive', name:'Radioactivity',      type:'cat', f:'radioactive',      map:function(v){return v?'Radioactive':'Stable';}, colors:BOOL_COLORS },
    { key:'occurrence',  name:'Occurrence',         type:'cat', f:'occurrence',       colors:OCC_COLORS },
    { key:'year',        name:'Year Discovered',    type:'num', f:'yearDiscovered' }
  ];
  var modeIdx = 0;

  // precompute numeric ranges per numeric mode
  MODES.forEach(function (m) {
    if (m.type !== 'num') return;
    var vals = ELS.map(function (e) { return num(e[m.f]); }).filter(function (v) { return v != null; });
    m.min = Math.min.apply(null, vals); m.max = Math.max.apply(null, vals);
  });
  function modeT(m, e) {
    var v = num(e[m.f]); if (v == null) return null;
    if (m.log) { var lo = Math.log(m.min > 0 ? m.min : 1e-6), hi = Math.log(m.max), x = Math.log(v > 0 ? v : 1e-6); return (x - lo) / (hi - lo); }
    return (v - m.min) / (m.max - m.min || 1);
  }
  function catValue(m, e) { var v = e[m.f]; if (m.map) v = m.map(v); if (m.norm) v = m.norm(v); return v; }
  function cellColor(m, e) {
    if (m.type === 'standard') return null;                          // neutral base view
    if (m.type === 'cat') { var c = (m.colors || {})[catValue(m, e)]; return c || '#5a6473'; }
    if (m.key === 'year' && num(e[m.f]) == null) return '#eef2f8';   // "Ancient" → white
    return rampColor(modeT(m, e)) || '#39404d';
  }

  // ── layout / nav grid ───────────────────────────────────────────────
  // rows: 1..7 main, 8 lanthanide strip, 9 actinide strip; cols 1..18
  function posOf(e) {
    if (e.family === 'Lanthanide') return { r:8, c:3 + (e.atomicNumber - 57) };
    if (e.family === 'Actinide')   return { r:9, c:3 + (e.atomicNumber - 89) };
    return { r:e.period, c:e.group };
  }
  var navGrid = {}; // r -> c -> z
  ELS.forEach(function (e) { var p = posOf(e); (navGrid[p.r] = navGrid[p.r] || {})[p.c] = e.atomicNumber; });

  // ── build the grid DOM ──────────────────────────────────────────────
  var grid = document.getElementById('ptGrid');
  function cellHTML(e) {
    return '<div class="ptv-cell" data-z="' + e.atomicNumber + '" role="button" tabindex="-1" title="' + e.name + '" ' +
      'style="grid-column:' + posOf(e).c + ';grid-row:' + (posOf(e).r <= 7 ? posOf(e).r : (posOf(e).r === 8 ? 9 : 10)) + ';">' +
      '<span class="z">' + e.atomicNumber + '</span><span class="sym">' + e.symbol + '</span><span class="mini" data-mini></span></div>';
  }
  function buildGrid() {
    var html = '';
    ELS.forEach(function (e) { html += cellHTML(e); });
    // placeholders linking main table to the f-block strips
    html += '<div class="ptv-fstub" style="grid-column:3;grid-row:6;" data-jump="57">57–71</div>';
    html += '<div class="ptv-fstub" style="grid-column:3;grid-row:7;" data-jump="89">89–103</div>';
    html += '<div class="ptv-fspacer" style="grid-row:8;"></div>';
    grid.innerHTML = html;
  }
  buildGrid();
  var cellEls = {}; grid.querySelectorAll('.ptv-cell').forEach(function (c) { cellEls[c.getAttribute('data-z')] = c; });

  // ── coloring ────────────────────────────────────────────────────────
  function applyMode() {
    var m = MODES[modeIdx];
    document.getElementById('ptModeName').textContent = m.name;
    ELS.forEach(function (e) {
      var c = cellEls[e.atomicNumber]; if (!c) return;
      var col = cellColor(m, e);
      if (col === null) {                                  // standard / neutral
        c.style.setProperty('--cellbg', 'var(--ptv-soft)');
        c.style.setProperty('--cellc', 'var(--ptv-line2)');
        c.style.setProperty('--celltext', 'var(--ptv-ink)');
      } else {
        c.style.setProperty('--cellbg', hexA(col, 0.22));
        c.style.setProperty('--cellc', col);
        c.style.setProperty('--celltext', '#eef2f8');
      }
      // mini value for numeric modes (Ancient years show "anc")
      var mini = c.querySelector('[data-mini]');
      if (m.type === 'num') { var v = num(e[m.f]); mini.textContent = (v == null ? (m.key === 'year' ? 'anc' : '') : trim(v)); }
      else { mini.textContent = ''; }
    });
    renderScale(m);
    applyFocus();
  }
  function hexA(hex, a) {
    var h = hex.replace('#',''); if (h.length === 3) h = h.split('').map(function(x){return x+x;}).join('');
    var r = parseInt(h.slice(0,2),16), g = parseInt(h.slice(2,4),16), b = parseInt(h.slice(4,6),16);
    return 'rgba(' + r + ',' + g + ',' + b + ',' + a + ')';
  }
  function trim(v) { if (Math.abs(v) >= 1000 || (Math.abs(v) < 0.01 && v !== 0)) return v.toPrecision(2); return (+v.toFixed(2)).toString(); }

  // ── focus (family/block highlight) ──────────────────────────────────
  var focusFamily = null, focusBlock = null;
  function applyFocus() {
    ELS.forEach(function (e) {
      var c = cellEls[e.atomicNumber]; if (!c) return;
      var dim = (focusFamily && e.family !== focusFamily) || (focusBlock && e.shell !== focusBlock);
      c.classList.toggle('dim', !!dim);
    });
  }

  // ── browse rows (families + blocks) ─────────────────────────────────
  function renderBrowse() {
    var fhtml = Object.keys(FAMILY_COLORS).map(function (k) {
      return '<button type="button" class="ptv-tag" data-fam="' + esc(k) + '" style="--tagc:' + FAMILY_COLORS[k] + '">' + (FAM[k] && FAM[k].name ? FAM[k].name : k) + '</button>';
    }).join(' ');
    document.getElementById('ptFamilies').innerHTML = fhtml;
    var bhtml = ['s-shell','p-shell','d-shell','f-shell'].map(function (k) {
      return '<button type="button" class="ptv-tag" data-block="' + k + '" style="--tagc:' + BLOCK_COLORS[k] + '">' + (SH[k] && SH[k].name ? SH[k].name : k) + '</button>';
    }).join(' ');
    document.getElementById('ptBlocks').innerHTML = bhtml;
  }
  renderBrowse();

  // ── panel render ────────────────────────────────────────────────────
  var ROWS = [
    ['atomicMass','Atomic mass'], ['electronConfiguration','Electron config'], ['oxidationStates','Oxidation states'],
    ['electronegativity','Electronegativity'], ['atomicRadius','Atomic radius'], ['ionizationEnergy','Ionization energy'],
    ['electronAffinity','Electron affinity'], ['standardState','Standard state'], ['meltingPoint','Melting point'],
    ['boilingPoint','Boiling point'], ['density','Density'], ['specificHeat','Specific heat'],
    ['numberOfProtons','Protons'], ['numberOfNeutrons','Neutrons'], ['numberOfElectrons','Electrons'],
    ['numberOfValence','Valence e⁻'], ['valency','Valency'], ['group','Group'], ['period','Period'],
    ['yearDiscovered','Discovered'], ['occurrence','Occurrence']
  ];
  var panel = document.getElementById('ptPanel');
  function renderElement(z) {
    var e = byZ[z]; if (!e) return;
    var fam = FAMILY_COLORS[e.family] || 'var(--ptv-blue)';
    var rows = ROWS.map(function (r) {
      var val = e[r[0]]; if (val == null || val === '') return '';
      if (r[0] === 'standardState') val = stripStars(val) + (/\*\*/.test(String(e[r[0]])) ? ' (predicted)' : '');
      if (r[0] === 'radioactive') val = val ? 'Yes' : 'No';
      return '<div class="ptv-p-row"><span class="k">' + r[1] + '</span><span class="v">' + esc(String(val)) + '</span></div>';
    }).join('');
    panel.innerHTML =
      '<div class="ptv-p-sym"><span class="big" style="color:' + fam + '">' + e.symbol + '</span><span class="z">#' + e.atomicNumber + '</span></div>' +
      '<div class="ptv-p-name">' + e.name + '</div>' +
      '<div class="ptv-p-fam" style="--famc:' + fam + '">' + (FAM[e.family] && FAM[e.family].name ? FAM[e.family].name : e.family) +
        ' &middot; ' + (SH[e.shell] && SH[e.shell].name ? SH[e.shell].name : e.shell) + (e.radioactive ? ' &middot; ☢ radioactive' : '') + '</div>' +
      '<div class="ptv-p-list">' + rows + '</div>';
    showAtom(e);
  }
  function renderDescription(title, color, desc) {
    panel.innerHTML = '<div class="ptv-p-fam" style="--famc:' + (color || 'var(--ptv-blue)') + '">' + esc(title) + '</div>' +
      '<div class="ptv-p-desc" style="margin-top:0.7rem;"><h4>' + esc(title) + '</h4>' + esc(desc || '') + '</div>';
    hideAtom();
  }
  // 3D atom bridge (the vanilla-Three.js module attaches window.PTAtom when ready)
  function showAtom(e) {
    var req = { protons:e.numberOfProtons, neutrons:e.numberOfNeutrons, electrons:e.numberOfElectrons, sym:e.symbol, name:e.name };
    window.__ptAtomReq = req;
    if (window.PTAtom) window.PTAtom.show(req);
  }
  function hideAtom() { window.__ptAtomReq = null; if (window.PTAtom) window.PTAtom.hide(); }

  // ── scale / legend ──────────────────────────────────────────────────
  function renderScale(m) {
    var el = document.getElementById('ptScale');
    if (m.type === 'standard') {
      el.innerHTML = '<span style="color:var(--ptv-faint)">Standard view — pick an element, or browse a family / block below.</span>';
    } else if (m.type === 'num') {
      var grad = 'linear-gradient(90deg,' + RAMP.join(',') + ')';
      el.innerHTML = '<span>' + trim(m.min) + '</span><span class="bar" style="background:' + grad + '"></span><span>' + trim(m.max) + '</span>' +
        (m.key === 'year' ? '<span class="ptv-sw"><i style="background:#eef2f8"></i>Ancient</span>' : '') +
        '<span style="margin-left:0.5rem;">' + m.name + '</span>';
    } else {                                   // categorical — only the values actually present
      var colors = m.colors || {}, order = Object.keys(colors), present = [];
      ELS.forEach(function (e) { var v = catValue(m, e); if (present.indexOf(v) < 0) present.push(v); });
      present.sort(function (a, b) { return order.indexOf(a) - order.indexOf(b); });
      el.innerHTML = present.map(function (k) {
        return '<span class="ptv-sw"><i style="background:' + (colors[k] || '#5a6473') + '"></i>' + esc(String(k)) + '</span>';
      }).join('');
    }
  }

  // ── selection + keyboard nav ────────────────────────────────────────
  // Mark the selected element's family + block chip (gold), like the CLI browse view.
  function markCurrent(e) {
    document.querySelectorAll('[data-fam]').forEach(function (b) { b.classList.toggle('cur', !!e && b.getAttribute('data-fam') === e.family); });
    document.querySelectorAll('[data-block]').forEach(function (b) { b.classList.toggle('cur', !!e && b.getAttribute('data-block') === e.shell); });
  }
  var selZ = 1, curR = 1, curC = 1;
  function select(z, fromNav) {
    var e = byZ[z]; if (!e) return;
    selZ = z; var p = posOf(e); curR = p.r; curC = p.c;
    Object.keys(cellEls).forEach(function (k) { cellEls[k].classList.toggle('sel', +k === z); });
    focusFamily = null; focusBlock = null; setTagState(); markCurrent(e);
    applyFocus();
    renderElement(z);
    if (fromNav && cellEls[z]) cellEls[z].scrollIntoView({ block:'nearest', inline:'nearest' });
  }
  function move(dr, dc) {
    var r = curR, c = curC;
    for (var i = 0; i < 25; i++) {
      r += dr; c += dc;
      if (r < 1) r = 1; if (r > 9) r = 9; if (c < 1) c = 1; if (c > 18) c = 18;
      if (navGrid[r] && navGrid[r][c]) { select(navGrid[r][c], true); return; }
      if ((dr && (r <= 1 || r >= 9)) && !(navGrid[r] && navGrid[r][c])) { /* keep scanning sideways within row */ }
      if (r === curR && c === curC) break;
    }
    // fallback: nearest in target row
    var dir = dr || dc;
    var rr = curR + dr;
    if (dr && navGrid[rr]) { var cols = Object.keys(navGrid[rr]).map(Number); var best = cols.reduce(function(a,b){return Math.abs(b-curC)<Math.abs(a-curC)?b:a;}, cols[0]); if (best != null) select(navGrid[rr][best], true); }
  }

  // ── families / blocks click ─────────────────────────────────────────
  function setTagState() {
    document.querySelectorAll('[data-fam]').forEach(function (b) { b.classList.toggle('on', b.getAttribute('data-fam') === focusFamily); });
    document.querySelectorAll('[data-block]').forEach(function (b) { b.classList.toggle('on', b.getAttribute('data-block') === focusBlock); });
  }
  function focusFam(k, force) {
    focusFamily = (!force && focusFamily === k) ? null : k; focusBlock = null;
    Object.keys(cellEls).forEach(function (z) { cellEls[z].classList.remove('sel'); });
    markCurrent(null); setTagState(); applyFocus();
    if (focusFamily) renderDescription(FAM[k] && FAM[k].name ? FAM[k].name : k, FAMILY_COLORS[k], FAM[k] && FAM[k].description);
    else renderElement(selZ);
  }
  function focusBlk(k, force) {
    focusBlock = (!force && focusBlock === k) ? null : k; focusFamily = null;
    Object.keys(cellEls).forEach(function (z) { cellEls[z].classList.remove('sel'); });
    markCurrent(null); setTagState(); applyFocus();
    if (focusBlock) renderDescription(SH[k] && SH[k].name ? SH[k].name : k, BLOCK_COLORS[k], SH[k] && SH[k].description);
    else renderElement(selZ);
  }
  document.getElementById('ptFamilies').addEventListener('click', function (e) { var b = e.target.closest('[data-fam]'); if (b) focusFam(b.getAttribute('data-fam')); });
  document.getElementById('ptBlocks').addEventListener('click', function (e) { var b = e.target.closest('[data-block]'); if (b) focusBlk(b.getAttribute('data-block')); });

  // ── grid click ──────────────────────────────────────────────────────
  grid.addEventListener('click', function (e) {
    var stub = e.target.closest('[data-jump]'); if (stub) { select(+stub.getAttribute('data-jump'), true); return; }
    var c = e.target.closest('.ptv-cell'); if (!c) return;
    var z = +c.getAttribute('data-z');
    if (compareMode) togglePin(z); else select(z, false);
  });

  // ── Compare mode (opt-in): pin up to 4 elements, 2D Bohr + property compare ──
  var SHELL_ORDER = [[1,2],[2,2],[2,6],[3,2],[3,6],[4,2],[3,10],[4,6],[5,2],[4,10],[5,6],[6,2],[4,14],[5,10],[6,6],[7,2],[5,14],[6,10],[7,6],[8,2]];
  function shellsOf(n) { var sh = new Array(9).fill(0), left = n; for (var i = 0; i < SHELL_ORDER.length && left > 0; i++) { var e = Math.min(left, SHELL_ORDER[i][1]); sh[SHELL_ORDER[i][0]-1] += e; left -= e; } return sh.filter(function (s) { return s > 0; }); }
  function bohrSVG(e, size) {
    var sh = shellsOf(e.numberOfElectrons), c = size / 2, maxR = size / 2 - 7, nucR = Math.max(8, maxR * 0.18), n = sh.length || 1;
    var rings = '', groups = '';
    for (var i = 0; i < sh.length; i++) {
      var r = nucR + (i + 1) * ((maxR - nucR) / n);
      rings += '<circle class="ring" cx="' + c + '" cy="' + c + '" r="' + r.toFixed(1) + '"/>';
      var dots = '', cnt = sh[i];
      for (var j = 0; j < cnt; j++) { var a = (j / cnt) * 2 * Math.PI; dots += '<circle class="el" cx="' + (c + Math.cos(a) * r).toFixed(1) + '" cy="' + (c + Math.sin(a) * r).toFixed(1) + '" r="2.1"/>'; }
      groups += '<g class="be" style="animation-duration:' + (6 + i * 2.5).toFixed(1) + 's;transform-box:view-box;transform-origin:' + c + 'px ' + c + 'px">' + dots + '</g>';
    }
    return '<svg class="ptv-bohr" width="' + size + '" height="' + size + '" viewBox="0 0 ' + size + ' ' + size + '">' + rings + groups +
      '<circle class="nuc" cx="' + c + '" cy="' + c + '" r="' + nucR.toFixed(1) + '"/><text class="nsym" x="' + c + '" y="' + c + '">' + esc(e.symbol) + '</text></svg>';
  }
  var CMP = [['atomicMass','Atomic mass'],['electronegativity','Electroneg.'],['atomicRadius','Radius'],['ionizationEnergy','Ionization'],['electronAffinity','e⁻ affinity'],['meltingPoint','Melting'],['boilingPoint','Boiling'],['density','Density']];
  var compareMode = false, pinned = [];
  var cmpBtn = document.getElementById('ptCompareBtn'), cmpBox = document.getElementById('ptCompare'),
      cmpGrid = document.getElementById('ptCmpGrid'), cmpTitle = document.getElementById('ptCmpTitle');
  cmpBtn.addEventListener('click', function () {
    compareMode = !compareMode; cmpBtn.classList.toggle('on', compareMode);
    if (!compareMode) { pinned = []; markPins(); cmpBox.hidden = true; }
    else { cmpBox.hidden = false; renderCompare(); }
  });
  document.getElementById('ptCmpClear').addEventListener('click', function () { pinned = []; markPins(); renderCompare(); });
  cmpGrid.addEventListener('click', function (e) { var b = e.target.closest('[data-unpin]'); if (b) togglePin(+b.getAttribute('data-unpin')); });
  function togglePin(z) { var i = pinned.indexOf(z); if (i > -1) pinned.splice(i, 1); else if (pinned.length < 4) pinned.push(z); markPins(); renderCompare(); }
  function markPins() {
    Object.keys(cellEls).forEach(function (k) {
      var c = cellEls[k], idx = pinned.indexOf(+k); c.classList.toggle('pin', idx > -1);
      var b = c.querySelector('.pinbadge');
      if (idx > -1) { if (!b) { b = document.createElement('span'); b.className = 'pinbadge'; c.appendChild(b); } b.textContent = idx + 1; }
      else if (b) { b.remove(); }
    });
  }
  function renderCompare() {
    if (!compareMode) { cmpBox.hidden = true; return; }
    cmpBox.hidden = false;
    cmpTitle.textContent = pinned.length ? ('Comparing ' + pinned.length + ' element' + (pinned.length > 1 ? 's' : '') + ' — highest per row in green') : 'Compare — pick up to 4 elements on the table';
    if (!pinned.length) { cmpGrid.innerHTML = ''; return; }
    var els = pinned.map(function (z) { return byZ[z]; });
    var win = {};
    CMP.forEach(function (p) { var best = null, bz = null; els.forEach(function (e) { var v = num(e[p[0]]); if (v != null && (best == null || v > best)) { best = v; bz = e.atomicNumber; } }); win[p[0]] = bz; });
    cmpGrid.innerHTML = els.map(function (e) {
      var fam = FAMILY_COLORS[e.family] || 'var(--ptv-blue)';
      var rows = CMP.map(function (p) {
        var raw = e[p[0]]; var disp = (raw == null || raw === '') ? '—' : String(raw);
        return '<div class="ptv-cmp-row"><span class="k">' + p[1] + '</span><span class="v' + (win[p[0]] === e.atomicNumber ? ' win' : '') + '">' + esc(disp) + '</span></div>';
      }).join('');
      return '<div class="ptv-cmp-card"><div class="ch"><span class="sym" style="color:' + fam + '">' + e.symbol + '</span>' +
        '<span class="nm">' + e.name + '<br>#' + e.atomicNumber + '</span>' +
        '<button class="x" data-unpin="' + e.atomicNumber + '" title="Remove">&times;</button></div>' +
        bohrSVG(e, 110) + rows + '</div>';
    }).join('');
  }

  // ── keyboard ────────────────────────────────────────────────────────
  function cycle(d) { modeIdx = (modeIdx + d + MODES.length) % MODES.length; applyMode(); }
  document.getElementById('ptNext').addEventListener('click', function () { cycle(1); });
  document.getElementById('ptPrev').addEventListener('click', function () { cycle(-1); });
  grid.addEventListener('keydown', function (e) {
    var k = e.key;
    if (k === 'ArrowUp') { e.preventDefault(); move(-1, 0); }
    else if (k === 'ArrowDown') { e.preventDefault(); move(1, 0); }
    else if (k === 'ArrowLeft') { e.preventDefault(); move(0, -1); }
    else if (k === 'ArrowRight') { e.preventDefault(); move(0, 1); }
    else if (k === '/') { e.preventDefault(); cycle(1); }
    else if (k === '\\') { e.preventDefault(); cycle(-1); }
    else if (k === 'Escape') { focusFamily = null; focusBlock = null; setTagState(); applyFocus(); renderElement(selZ); }
  });

  // ── search ──────────────────────────────────────────────────────────
  var sIn = document.getElementById('ptSearch'), sRes = document.getElementById('ptResults'), sActive = -1, sList = [];
  function doSearch(q) {
    q = q.trim().toLowerCase();
    if (!q) { sRes.hidden = true; return; }
    var res = [];
    ELS.forEach(function (e) {
      if (e.name.toLowerCase().indexOf(q) > -1 || e.symbol.toLowerCase() === q || String(e.atomicNumber) === q)
        res.push({ t:'el', z:e.atomicNumber, sym:e.symbol, label:e.name });
    });
    Object.keys(FAM).forEach(function (k) { var nm = FAM[k].name || k; if (nm.toLowerCase().indexOf(q) > -1 || k.toLowerCase().indexOf(q) > -1) res.push({ t:'fam', key:k, label:nm }); });
    Object.keys(SH).forEach(function (k) { var nm = SH[k].name || k; if (nm.toLowerCase().indexOf(q) > -1 || k.toLowerCase().indexOf(q) > -1) res.push({ t:'block', key:k, label:nm }); });
    sList = res.slice(0, 10);
    if (!sList.length) { sRes.hidden = true; return; }
    sActive = 0;
    sRes.innerHTML = sList.map(function (r, i) {
      var lead = r.t === 'el' ? ('<span class="rz">' + r.z + '</span><b>' + r.sym + '</b> ')
                              : ('<span class="rtag">' + (r.t === 'fam' ? 'family' : 'block') + '</span> ');
      return '<button type="button" data-i="' + i + '" class="' + (i === 0 ? 'on' : '') + '">' + lead + esc(r.label) + '</button>';
    }).join('');
    sRes.hidden = false;
  }
  function chooseResult(r) {
    if (!r) return;
    if (r.t === 'el') select(r.z, true);
    else if (r.t === 'fam') focusFam(r.key, true);
    else focusBlk(r.key, true);
    sRes.hidden = true; sIn.value = '';
  }
  sIn.addEventListener('input', function () { doSearch(this.value); });
  sIn.addEventListener('keydown', function (e) {
    if (sRes.hidden) return;
    if (e.key === 'ArrowDown') { e.preventDefault(); sActive = Math.min(sList.length - 1, sActive + 1); markRes(); }
    else if (e.key === 'ArrowUp') { e.preventDefault(); sActive = Math.max(0, sActive - 1); markRes(); }
    else if (e.key === 'Enter') { e.preventDefault(); chooseResult(sList[sActive]); }
    else if (e.key === 'Escape') { sRes.hidden = true; }
  });
  function markRes() { sRes.querySelectorAll('button').forEach(function (b, i) { b.classList.toggle('on', i === sActive); }); }
  sRes.addEventListener('click', function (e) { var b = e.target.closest('[data-i]'); if (b) chooseResult(sList[+b.getAttribute('data-i')]); });
  document.addEventListener('click', function (e) { if (!e.target.closest('.ptv-search')) sRes.hidden = true; });

  function esc(s) { return String(s).replace(/[&<>"]/g, function (c) { return { '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;' }[c]; }); }

  // ── init ────────────────────────────────────────────────────────────
  // ── below-fold content: family + block descriptions (from PT_DATA) + FAQ ──
  (function () {
    var ff = document.getElementById('ptSeoFamilies'), bb = document.getElementById('ptSeoBlocks');
    if (ff) ff.innerHTML = Object.keys(FAMILY_COLORS).map(function (k) {
      var f = FAM[k] || {}; return '<div class="pt-seo-item" style="--sc:' + FAMILY_COLORS[k] + '"><h4>' + esc(f.name || k) + '</h4><p>' + esc(f.description || '') + '</p></div>';
    }).join('');
    if (bb) bb.innerHTML = ['s-shell','p-shell','d-shell','f-shell'].map(function (k) {
      var s = SH[k] || {}; return '<div class="pt-seo-item" style="--sc:' + BLOCK_COLORS[k] + '"><h4>' + esc(s.name || k) + '</h4><p>' + esc(s.description || '') + '</p></div>';
    }).join('');
    document.querySelectorAll('.cs-faq-q').forEach(function (btn) {
      btn.addEventListener('click', function () { var it = btn.closest('.cs-faq-item'); if (it) it.classList.toggle('open'); });
    });
  })();

  applyMode();
  select(1, false);
})();
</script>

<!-- 3D atom — vanilla Three.js port of atom-animation (matt765, MIT/personal-use).
     Nucleus (Fibonacci-sphere of protons/neutrons) + orbit rings + revolving
     electrons, shells from aufbau filling. Additive: if Three/WebGL is missing
     the periodic table is unaffected. -->
<script type="module">
(async function () {
  var box = document.getElementById('ptAtom');
  if (!box) return;
  var THREE;
  try { THREE = await import('https://esm.sh/three@0.160.0'); } catch (e) { return; }

  // electrons -> shells array via aufbau order (ported from elementUtils.ts)
  var ORDER = [[1,2],[2,2],[2,6],[3,2],[3,6],[4,2],[3,10],[4,6],[5,2],[4,10],[5,6],[6,2],[4,14],[5,10],[6,6],[7,2],[5,14],[6,10],[7,6],[8,2]];
  function shellsOf(n) {
    var sh = new Array(9).fill(0), left = n;
    for (var i = 0; i < ORDER.length && left > 0; i++) { var e = Math.min(left, ORDER[i][1]); sh[ORDER[i][0]-1] += e; left -= e; }
    return sh.filter(function (s) { return s > 0; });
  }

  var W = box.clientWidth || 320, H = box.clientHeight || 230;
  var scene = new THREE.Scene();
  var camera = new THREE.PerspectiveCamera(50, W / H, 0.1, 100);
  var renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
  renderer.setPixelRatio(Math.min(2, window.devicePixelRatio || 1));
  renderer.setSize(W, H);
  box.appendChild(renderer.domElement);
  var cap = document.createElement('div'); cap.className = 'ptv-atom-cap'; box.appendChild(cap);

  scene.add(new THREE.AmbientLight(0xffffff, 0.85));
  var pl = new THREE.PointLight(0xffffff, 0.9); pl.position.set(8, 10, 14); scene.add(pl);

  var atom = new THREE.Group(); atom.rotation.x = 0.5; scene.add(atom);

  var nucleonGeo = new THREE.SphereGeometry(0.22, 24, 24);
  var electronGeo = new THREE.SphereGeometry(0.13, 16, 16);
  var protonMat = new THREE.MeshStandardMaterial({ color: 0xff554d, roughness: 0.4, metalness: 0.2 });
  var neutronMat = new THREE.MeshStandardMaterial({ color: 0xaaaaaa, roughness: 0.4, metalness: 0.2 });
  var electronMat = new THREE.MeshStandardMaterial({ color: 0x33ccff, emissive: 0x33ccff, emissiveIntensity: 0.6 });
  var ringMat = new THREE.MeshBasicMaterial({ color: 0xffffff, transparent: true, opacity: 0.16, side: THREE.DoubleSide });

  var electrons = [], ringGeos = [];
  function clear() {
    atom.clear();
    ringGeos.forEach(function (g) { g.dispose(); }); ringGeos = []; electrons = [];
  }
  function fib(total, R) {                       // golden-angle sphere packing
    var pts = [], phi = Math.PI * (3 - Math.sqrt(5));
    if (total === 1) return [new THREE.Vector3(0, 0, 0)];
    for (var i = 0; i < total; i++) {
      var y = 1 - (i / (total - 1)) * 2, r = Math.sqrt(1 - y * y), t = phi * i;
      pts.push(new THREE.Vector3(Math.cos(t) * r, y, Math.sin(t) * r).multiplyScalar(R));
    }
    return pts;
  }
  function build(p) {
    clear();
    var protons = p.protons || 0, neutrons = p.neutrons || 0, total = protons + neutrons;
    var nucR = 0.42 + 0.17 * Math.cbrt(Math.max(1, total));
    var pos = fib(total, nucR);
    var types = []; for (var i = 0; i < protons; i++) types.push(1); for (var j = 0; j < neutrons; j++) types.push(0);
    for (var k = types.length - 1; k > 0; k--) { var m = Math.floor(Math.random() * (k + 1)); var tmp = types[k]; types[k] = types[m]; types[m] = tmp; }
    pos.forEach(function (v, idx) { var mesh = new THREE.Mesh(nucleonGeo, types[idx] ? protonMat : neutronMat); mesh.position.copy(v); atom.add(mesh); });

    var shells = shellsOf(p.electrons || 0);
    shells.forEach(function (count, i) {
      var radius = nucR + 1.3 + i * 1.15;
      var tg = new THREE.TorusGeometry(radius, 0.012, 10, 80); ringGeos.push(tg);
      atom.add(new THREE.Mesh(tg, ringMat));
      var speed = (1.5 * Math.PI / (i + 1)) * 0.45;
      for (var e = 0; e < count; e++) {
        var mesh2 = new THREE.Mesh(electronGeo, electronMat);
        atom.add(mesh2);
        electrons.push({ mesh: mesh2, radius: radius, speed: speed, angle: (e / count) * Math.PI * 2 + i * 0.6 });
      }
    });

    var outer = nucR + 1.3 + Math.max(0, shells.length - 1) * 1.15;
    camera.position.set(0, outer * 0.35, outer * 2.3 + 3.5);
    camera.lookAt(0, 0, 0);
    cap.innerHTML = '<b>' + (p.sym || '') + '</b> · ' + (p.electrons || 0) + ' e⁻ · ' + shells.length + ' shell' + (shells.length === 1 ? '' : 's');
  }

  // drag to rotate (no OrbitControls dependency)
  var dragging = false, autoR = true, lx = 0, ly = 0;
  box.addEventListener('pointerdown', function (e) { dragging = true; autoR = false; lx = e.clientX; ly = e.clientY; box.classList.add('grab'); box.setPointerCapture(e.pointerId); });
  box.addEventListener('pointermove', function (e) { if (!dragging) return; atom.rotation.y += (e.clientX - lx) * 0.01; atom.rotation.x += (e.clientY - ly) * 0.01; lx = e.clientX; ly = e.clientY; });
  function endDrag() { dragging = false; box.classList.remove('grab'); }
  box.addEventListener('pointerup', endDrag); box.addEventListener('pointercancel', endDrag);

  var last = 0, visible = true;
  function loop(t) {
    requestAnimationFrame(loop);
    var dt = last ? Math.min(0.05, (t - last) / 1000) : 0; last = t;
    if (!visible) return;
    if (autoR && !dragging) atom.rotation.y += dt * 0.25;
    for (var i = 0; i < electrons.length; i++) {
      var el = electrons[i]; el.angle += dt * el.speed;
      el.mesh.position.set(Math.cos(el.angle) * el.radius, Math.sin(el.angle) * el.radius, 0);
    }
    renderer.render(scene, camera);
  }
  requestAnimationFrame(loop);

  if (window.ResizeObserver) {
    new ResizeObserver(function () {
      var w = box.clientWidth, h = box.clientHeight; if (!w || !h) return;
      camera.aspect = w / h; camera.updateProjectionMatrix(); renderer.setSize(w, h);
    }).observe(box);
  }

  window.PTAtom = {
    show: function (p) { visible = true; box.style.display = ''; build(p); },
    hide: function () { box.style.display = 'none'; visible = false; }
  };
  if (window.__ptAtomReq) window.PTAtom.show(window.__ptAtomReq);
})();
</script>
</body>
</html>
