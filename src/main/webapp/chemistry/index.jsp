<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis());
   String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Chemistry Tools — Structures, Equations & 3D, Free Online" />
        <jsp:param name="toolCategory" value="Chemistry" />
        <jsp:param name="toolDescription" value="A quiet place for chemistry: draw molecules, turn a formula into structures, balance equations, explore the periodic table, electron configuration, Lewis structures, 3D VSEPR geometry, stoichiometry, molarity and more. Free, browser-based, no signup." />
        <jsp:param name="toolUrl" value="chemistry/" />
        <jsp:param name="toolKeywords" value="chemistry tools, online chemistry, molecule drawer, formula to structure, equation balancer, periodic table, electron configuration, Lewis structure, molecular geometry, VSEPR, stoichiometry, molar mass, molarity, dilution, thermochemistry, electrochemistry, SMILES editor" />
        <jsp:param name="toolImage" value="chemistry-studio-og.png" />
        <jsp:param name="toolFeatures" value="Molecule structure editor,Formula to structure,Chemical equation balancer,Periodic table,Electron configuration,Lewis structures,3D VSEPR geometry,Stoichiometry,Molar mass,Molarity and dilution,Thermochemistry,Electrochemistry,Free and instant,No registration" />
        <jsp:param name="faq1q" value="Are these chemistry tools free to use?" />
        <jsp:param name="faq1a" value="Yes, every chemistry tool here is completely free — no registration, no payment, no limits. Use them for homework, exams, or professional work." />
        <jsp:param name="faq2q" value="Do the calculators show step-by-step solutions?" />
        <jsp:param name="faq2a" value="Yes, the calculators show detailed step-by-step working so you understand each formula and calculation, not just the answer." />
        <jsp:param name="faq3q" value="What chemistry topics are covered?" />
        <jsp:param name="faq3a" value="Molecular structure (drawing, formula to structure, Lewis, 3D VSEPR geometry), atomic structure (periodic table, electron configuration, electronegativity), reactions (equation balancing, stoichiometry, molar mass), solutions (molarity, dilution, unit conversion), and energy (thermochemistry, electrochemistry)." />
        <jsp:param name="faq4q" value="Do these tools work on mobile?" />
        <jsp:param name="faq4a" value="Yes. The sidebar collapses into a drawer on narrow screens, layouts stack vertically, and the 3D viewers accept touch gestures." />
    </jsp:include>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "CollectionPage",
        "name": "Chemistry Tools",
        "description": "Free interactive chemistry tools — molecular structure drawing, formula to structure, equation balancing, periodic table, and more.",
        "url": "https://8gwifi.org/chemistry/",
        "mainEntity": {
            "@type": "ItemList",
            "itemListElement": [
                {"@type": "ListItem", "position": 1, "name": "Formula to Molecule", "url": "https://8gwifi.org/chemistry/formula-to-molecule.jsp"},
                {"@type": "ListItem", "position": 2, "name": "Molecule Draw", "url": "https://8gwifi.org/chemistry/molecule-draw.jsp"},
                {"@type": "ListItem", "position": 3, "name": "Lewis Structure Generator", "url": "https://8gwifi.org/lewis-structure-generator.jsp"},
                {"@type": "ListItem", "position": 4, "name": "3D Molecular Geometry", "url": "https://8gwifi.org/molecular-geometry-calculator.jsp"},
                {"@type": "ListItem", "position": 5, "name": "Periodic Table", "url": "https://8gwifi.org/periodic-table.jsp"},
                {"@type": "ListItem", "position": 6, "name": "Electron Configuration", "url": "https://8gwifi.org/electron-configuration-calculator.jsp"},
                {"@type": "ListItem", "position": 7, "name": "Electronegativity & Polarity", "url": "https://8gwifi.org/electronegativity-polarity-checker.jsp"},
                {"@type": "ListItem", "position": 8, "name": "Chemical Equation Balancer", "url": "https://8gwifi.org/chemical-equation-balancer.jsp"},
                {"@type": "ListItem", "position": 9, "name": "Stoichiometry Calculator", "url": "https://8gwifi.org/stoichiometry-calculator.jsp"},
                {"@type": "ListItem", "position": 10, "name": "Molar Mass Calculator", "url": "https://8gwifi.org/molar-mass-calculator.jsp"},
                {"@type": "ListItem", "position": 11, "name": "Molarity & Dilution", "url": "https://8gwifi.org/molarity-dilution-calculator.jsp"},
                {"@type": "ListItem", "position": 12, "name": "Chemistry Unit Converter", "url": "https://8gwifi.org/unit-converter-chemistry.jsp"},
                {"@type": "ListItem", "position": 13, "name": "Thermochemistry Calculator", "url": "https://8gwifi.org/thermochemistry-calculator.jsp"},
                {"@type": "ListItem", "position": 14, "name": "Electrochemistry Calculator", "url": "https://8gwifi.org/electrochemistry-calculator.jsp"},
                {"@type": "ListItem", "position": 15, "name": "Limiting Reagent & Percent Yield Calculator", "url": "https://8gwifi.org/limiting-reagent-calculator.jsp"},
                {"@type": "ListItem", "position": 16, "name": "Net Ionic Equation Calculator", "url": "https://8gwifi.org/net-ionic-equation-calculator.jsp"},
                {"@type": "ListItem", "position": 17, "name": "Empirical & Molecular Formula Calculator", "url": "https://8gwifi.org/empirical-formula-calculator.jsp"},
                {"@type": "ListItem", "position": 18, "name": "Equilibrium & pH Calculator", "url": "https://8gwifi.org/equilibrium-ph-calculator.jsp"}
            ]
        }
    }
    </script>

    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="ctx" content="<%=ctx%>" />

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Instrument+Serif:ital@0;1&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Instrument+Serif:ital@0;1&display=swap"></noscript>

    <link rel="stylesheet" href="<%=ctx%>/modern/css/design-system.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=ctx%>/modern/css/navigation.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=ctx%>/modern/css/dark-mode.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=ctx%>/modern/css/footer.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=ctx%>/modern/css/ads.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=ctx%>/chemistry/css/chemistry-studio.css?v=<%=v%>">

    <%@ include file="../modern/ads/ad-init.jsp" %>
</head>
<body class="cs-body">

<jsp:include page="../modern/components/nav-header.jsp" />

<div class="cs-hero">
    <%@ include file="../modern/ads/ad-hero-banner.jsp" %>
</div>

<main class="cs-main">

    <button type="button" id="csSidebarToggle" class="cs-sidebar-toggle" aria-label="Open chemistry tools menu">
        &#9776; Chemistry tools
    </button>

    <% request.setAttribute("activeService", "home"); %>
    <jsp:include page="/chemistry/partials/sidebar.jsp" />

    <section class="cs-workspace">

        <div class="cs-hero-banner">
            <h1>A quiet place for <em>chemistry</em>.</h1>
            <p>Draw molecules, turn a formula into real structures, balance equations, and explore atoms, geometry, and energy &mdash; all in the browser, no signup.</p>
            <div class="cs-hero-stats">
                <div class="cs-hero-stat"><strong>14</strong>tools</div>
                <div class="cs-hero-stat"><strong>3D</strong>structures</div>
                <div class="cs-hero-stat"><strong>free</strong>no signup</div>
            </div>
        </div>

        <!-- Structure & Drawing -->
        <div style="background: var(--cs-panel-bg); border:1px solid var(--cs-line); border-radius: var(--cs-radius); padding:1.5rem; box-shadow: var(--cs-shadow-sm); margin-bottom:1.25rem;">
            <h2 class="cs-section-title">Structure &amp; drawing</h2>
            <div class="cs-tool-grid">
                <a href="<%=ctx%>/chemistry/formula-to-molecule.jsp" class="cs-tool-card">
                    <span class="cs-tool-card-icon">&#8594;</span>
                    <span><span class="cs-tool-card-title">Formula → Molecule</span>
                          <span class="cs-tool-card-sub">Formula → structures, balance, 3D</span></span>
                </a>
                <a href="<%=ctx%>/chemistry/molecule-draw.jsp" class="cs-tool-card">
                    <span class="cs-tool-card-icon">&#9187;</span>
                    <span><span class="cs-tool-card-title">Molecule Draw</span>
                          <span class="cs-tool-card-sub">SMILES / MOL structure editor</span></span>
                </a>
                <a href="<%=ctx%>/lewis-structure-generator.jsp" class="cs-tool-card">
                    <span class="cs-tool-card-icon">&#8226;&#8226;</span>
                    <span><span class="cs-tool-card-title">Lewis Structures</span>
                          <span class="cs-tool-card-sub">Dot structures + formal charge</span></span>
                </a>
                <a href="<%=ctx%>/molecular-geometry-calculator.jsp" class="cs-tool-card">
                    <span class="cs-tool-card-icon">&#9651;</span>
                    <span><span class="cs-tool-card-title">3D Geometry (VSEPR)</span>
                          <span class="cs-tool-card-sub">Molecular shapes in 3D</span></span>
                </a>
            </div>
        </div>

        <!-- Atomic & Periodic -->
        <div style="background: var(--cs-panel-bg); border:1px solid var(--cs-line); border-radius: var(--cs-radius); padding:1.5rem; box-shadow: var(--cs-shadow-sm); margin-bottom:1.25rem;">
            <h2 class="cs-section-title">Atomic &amp; periodic</h2>
            <div class="cs-tool-grid">
                <a href="<%=ctx%>/periodic-table.jsp" class="cs-tool-card">
                    <span class="cs-tool-card-icon">&#9636;</span>
                    <span><span class="cs-tool-card-title">Periodic Table</span>
                          <span class="cs-tool-card-sub">Interactive element explorer</span></span>
                </a>
                <a href="<%=ctx%>/electron-configuration-calculator.jsp" class="cs-tool-card">
                    <span class="cs-tool-card-icon">&#9678;</span>
                    <span><span class="cs-tool-card-title">Electron Configuration</span>
                          <span class="cs-tool-card-sub">Orbitals &amp; noble-gas notation</span></span>
                </a>
                <a href="<%=ctx%>/electronegativity-polarity-checker.jsp" class="cs-tool-card">
                    <span class="cs-tool-card-icon">&#948;</span>
                    <span><span class="cs-tool-card-title">Electronegativity &amp; Polarity</span>
                          <span class="cs-tool-card-sub">Bond &amp; molecule polarity</span></span>
                </a>
            </div>
        </div>

        <!-- Reactions & Stoichiometry -->
        <div style="background: var(--cs-panel-bg); border:1px solid var(--cs-line); border-radius: var(--cs-radius); padding:1.5rem; box-shadow: var(--cs-shadow-sm); margin-bottom:1.25rem;">
            <h2 class="cs-section-title">Reactions &amp; stoichiometry</h2>
            <div class="cs-tool-grid">
                <a href="<%=ctx%>/chemical-equation-balancer.jsp" class="cs-tool-card">
                    <span class="cs-tool-card-icon">&#9878;</span>
                    <span><span class="cs-tool-card-title">Equation Balancer</span>
                          <span class="cs-tool-card-sub">Balance any reaction</span></span>
                </a>
                <a href="<%=ctx%>/stoichiometry-calculator.jsp" class="cs-tool-card">
                    <span class="cs-tool-card-icon">&#8721;</span>
                    <span><span class="cs-tool-card-title">Stoichiometry</span>
                          <span class="cs-tool-card-sub">Moles, mass, limiting reagent</span></span>
                </a>
                <a href="<%=ctx%>/limiting-reagent-calculator.jsp" class="cs-tool-card">
                    <span class="cs-tool-card-icon">&#37;</span>
                    <span><span class="cs-tool-card-title">Limiting Reagent &amp; Yield</span>
                          <span class="cs-tool-card-sub">Limiting reactant, % yield</span></span>
                </a>
                <a href="<%=ctx%>/net-ionic-equation-calculator.jsp" class="cs-tool-card">
                    <span class="cs-tool-card-icon">&#8651;</span>
                    <span><span class="cs-tool-card-title">Net Ionic Equation</span>
                          <span class="cs-tool-card-sub">Spectators, precipitate</span></span>
                </a>
                <a href="<%=ctx%>/molar-mass-calculator.jsp" class="cs-tool-card">
                    <span class="cs-tool-card-icon">&#9878;m</span>
                    <span><span class="cs-tool-card-title">Molar Mass</span>
                          <span class="cs-tool-card-sub">Molecular weight from formula</span></span>
                </a>
                <a href="<%=ctx%>/empirical-formula-calculator.jsp" class="cs-tool-card">
                    <span class="cs-tool-card-icon">&#8473;</span>
                    <span><span class="cs-tool-card-title">Empirical &amp; % Composition</span>
                          <span class="cs-tool-card-sub">% composition, molecular formula</span></span>
                </a>
            </div>
        </div>

        <%-- In-content ad. --%>
        <div class="cs-inline-ad">
            <%@ include file="../modern/ads/ad-in-content-mid.jsp" %>
        </div>

        <!-- Solutions & Energy -->
        <div style="background: var(--cs-panel-bg); border:1px solid var(--cs-line); border-radius: var(--cs-radius); padding:1.5rem; box-shadow: var(--cs-shadow-sm); margin-bottom:1.25rem;">
            <h2 class="cs-section-title">Solutions &amp; energy</h2>
            <div class="cs-tool-grid">
                <a href="<%=ctx%>/molarity-dilution-calculator.jsp" class="cs-tool-card">
                    <span class="cs-tool-card-icon">&#9219;</span>
                    <span><span class="cs-tool-card-title">Molarity &amp; Dilution</span>
                          <span class="cs-tool-card-sub">C&#8321;V&#8321; = C&#8322;V&#8322;, concentration</span></span>
                </a>
                <a href="<%=ctx%>/equilibrium-ph-calculator.jsp" class="cs-tool-card">
                    <span class="cs-tool-card-icon">&#8652;</span>
                    <span><span class="cs-tool-card-title">Equilibrium &amp; pH</span>
                          <span class="cs-tool-card-sub">Weak acid/base, buffer, Ksp</span></span>
                </a>
                <a href="<%=ctx%>/unit-converter-chemistry.jsp" class="cs-tool-card">
                    <span class="cs-tool-card-icon">&#8644;</span>
                    <span><span class="cs-tool-card-title">Unit Converter</span>
                          <span class="cs-tool-card-sub">Moles, mass, pressure, energy</span></span>
                </a>
                <a href="<%=ctx%>/thermochemistry-calculator.jsp" class="cs-tool-card">
                    <span class="cs-tool-card-icon">&#9832;</span>
                    <span><span class="cs-tool-card-title">Thermochemistry</span>
                          <span class="cs-tool-card-sub">Enthalpy, Hess's law, &Delta;H</span></span>
                </a>
                <a href="<%=ctx%>/electrochemistry-calculator.jsp" class="cs-tool-card">
                    <span class="cs-tool-card-icon">&#9889;</span>
                    <span><span class="cs-tool-card-title">Electrochemistry</span>
                          <span class="cs-tool-card-sub">Cell potential, Nernst</span></span>
                </a>
            </div>
        </div>

        <!-- FAQ -->
        <section class="cs-faq-wrap" style="max-width:100%;margin-top:0;padding:0;">
            <h2 class="cs-faq-title" id="faqs">Frequently asked</h2>
            <div class="cs-faq" aria-label="Chemistry tools FAQ">
                <div class="cs-faq-item">
                    <button class="cs-faq-q" type="button">Are these chemistry tools free?
                        <svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="cs-faq-a">Yes &mdash; every tool is free, browser-only, and needs no signup. Use them for homework, exams, or work, as often as you like.</div>
                </div>
                <div class="cs-faq-item">
                    <button class="cs-faq-q" type="button">What can the Formula → Molecule tool do?
                        <svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="cs-faq-a">Type a molecular formula (e.g. <code>C10H14N2</code>) to look up matching structures, a full equation with <code>=</code> to balance it, or just the reactants and AI predicts the products &mdash; then they're balanced and verified. It also draws 3D structures and exports images.</div>
                </div>
                <div class="cs-faq-item">
                    <button class="cs-faq-q" type="button">Do the tools work on mobile?
                        <svg class="cs-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="cs-faq-a">Yes. The sidebar collapses into a drawer on narrow screens, layouts stack vertically, and the 3D viewers accept rotate / pan / pinch-zoom gestures.</div>
                </div>
            </div>
        </section>

    </section>

    <aside class="cs-rail" aria-label="Advertisements">
        <%@ include file="../modern/ads/ad-ide-rail-top.jsp" %>
        <%@ include file="../modern/ads/ad-ide-rail-bottom.jsp" %>
    </aside>
</main>

<%@ include file="../modern/ads/ad-sticky-footer.jsp" %>
<%@ include file="../modern/components/analytics.jsp" %>

<script src="<%=ctx%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
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

</body>
</html>
