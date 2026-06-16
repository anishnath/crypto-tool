<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    Shared sidebar for chemistry/ pages — "A quiet place for chemistry".
    Mirrors biology/partials/sidebar.jsp: collapsible groups, client-side
    search, mobile drawer, localStorage-persisted state. Self-contained
    (markup + script); relies on the .cs-* layout from chemistry-studio.css.

    Usage from the parent JSP (before include):
        request.setAttribute("activeService", "formula-to-molecule");
        <jsp:include page="/chemistry/partials/sidebar.jsp" />
--%>
<%!
    private String collapsedCls(String activeService, String... keys) {
        if (activeService == null) return " collapsed";
        for (String k : keys) if (k.equals(activeService)) return "";
        return " collapsed";
    }
    private String activeCls(String activeService, String key) {
        return key.equals(activeService) ? "active" : "";
    }
%>
<%
    String activeService = (String) request.getAttribute("activeService");
    if (activeService == null) activeService = "home";
    String ctx = request.getContextPath();
%>
<aside class="cs-sidebar" id="csSidebar" aria-label="Chemistry tools">

    <div class="cs-sidebar-header">
        <span class="cs-sidebar-title">Chemistry</span>
        <button type="button" class="cs-sidebar-hide-btn" id="csSidebarHideBtn"
                aria-label="Hide sidebar to widen the page" title="Hide sidebar">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                <polyline points="15 6 9 12 15 18"></polyline>
            </svg>
        </button>
    </div>

    <label class="cs-sidebar-search">
        <input type="search" id="csSidebarSearch" placeholder="Search chemistry tools…" autocomplete="off" />
    </label>

    <!-- Home -->
    <div class="cs-group" data-group="home">
        <div class="cs-group-body">
            <a href="<%= ctx %>/chemistry/" class="cs-item <%= activeCls(activeService, "home") %>">
                <span class="cs-item-icon">&#9883;</span>
                <span class="cs-item-label">All Chemistry Tools</span>
            </a>
        </div>
    </div>

    <!-- Structure & Drawing -->
    <div class="cs-group<%= collapsedCls(activeService, "formula-to-molecule", "molecule-draw", "lewis", "geometry") %>" data-group="structure">
        <button class="cs-group-header" type="button">Structure &amp; Drawing <span class="cs-group-chevron">&#9662;</span></button>
        <div class="cs-group-body">
            <a href="<%= ctx %>/chemistry/formula-to-molecule.jsp" class="cs-item <%= activeCls(activeService, "formula-to-molecule") %>">
                <span class="cs-item-icon">&#8594;</span><span class="cs-item-label">Formula → Molecule</span>
            </a>
            <a href="<%= ctx %>/chemistry/molecule-draw.jsp" class="cs-item <%= activeCls(activeService, "molecule-draw") %>">
                <span class="cs-item-icon">&#9187;</span><span class="cs-item-label">Molecule Draw</span>
            </a>
            <a href="<%= ctx %>/lewis-structure-generator.jsp" class="cs-item <%= activeCls(activeService, "lewis") %>">
                <span class="cs-item-icon">&#8226;&#8226;</span><span class="cs-item-label">Lewis Structures</span>
            </a>
            <a href="<%= ctx %>/molecular-geometry-calculator.jsp" class="cs-item <%= activeCls(activeService, "geometry") %>">
                <span class="cs-item-icon">&#9651;</span><span class="cs-item-label">3D Geometry (VSEPR)</span>
            </a>
        </div>
    </div>

    <!-- Atomic & Periodic -->
    <div class="cs-group<%= collapsedCls(activeService, "periodic", "electron-config", "electronegativity") %>" data-group="atomic">
        <button class="cs-group-header" type="button">Atomic &amp; Periodic <span class="cs-group-chevron">&#9662;</span></button>
        <div class="cs-group-body">
            <a href="<%= ctx %>/periodic-table.jsp" class="cs-item <%= activeCls(activeService, "periodic") %>">
                <span class="cs-item-icon">&#9636;</span><span class="cs-item-label">Periodic Table</span>
            </a>
            <a href="<%= ctx %>/electron-configuration-calculator.jsp" class="cs-item <%= activeCls(activeService, "electron-config") %>">
                <span class="cs-item-icon">&#9678;</span><span class="cs-item-label">Electron Configuration</span>
            </a>
            <a href="<%= ctx %>/electronegativity-polarity-checker.jsp" class="cs-item <%= activeCls(activeService, "electronegativity") %>">
                <span class="cs-item-icon">&#948;</span><span class="cs-item-label">Electronegativity &amp; Polarity</span>
            </a>
        </div>
    </div>

    <!-- Reactions & Stoichiometry -->
    <div class="cs-group<%= collapsedCls(activeService, "balancer", "stoichiometry", "molar-mass", "empirical", "limiting", "net-ionic") %>" data-group="reactions">
        <button class="cs-group-header" type="button">Reactions &amp; Stoichiometry <span class="cs-group-chevron">&#9662;</span></button>
        <div class="cs-group-body">
            <a href="<%= ctx %>/chemical-equation-balancer.jsp" class="cs-item <%= activeCls(activeService, "balancer") %>">
                <span class="cs-item-icon">&#9878;</span><span class="cs-item-label">Equation Balancer</span>
            </a>
            <a href="<%= ctx %>/stoichiometry-calculator.jsp" class="cs-item <%= activeCls(activeService, "stoichiometry") %>">
                <span class="cs-item-icon">&#8721;</span><span class="cs-item-label">Stoichiometry</span>
            </a>
            <a href="<%= ctx %>/limiting-reagent-calculator.jsp" class="cs-item <%= activeCls(activeService, "limiting") %>">
                <span class="cs-item-icon">&#9878;%</span><span class="cs-item-label">Limiting Reagent &amp; Yield</span>
            </a>
            <a href="<%= ctx %>/net-ionic-equation-calculator.jsp" class="cs-item <%= activeCls(activeService, "net-ionic") %>">
                <span class="cs-item-icon">&#8651;</span><span class="cs-item-label">Net Ionic Equation</span>
            </a>
            <a href="<%= ctx %>/molar-mass-calculator.jsp" class="cs-item <%= activeCls(activeService, "molar-mass") %>">
                <span class="cs-item-icon">&#8721;m</span><span class="cs-item-label">Molar Mass</span>
            </a>
            <a href="<%= ctx %>/empirical-formula-calculator.jsp" class="cs-item <%= activeCls(activeService, "empirical") %>">
                <span class="cs-item-icon">&#8473;</span><span class="cs-item-label">Empirical &amp; % Composition</span>
            </a>
        </div>
    </div>

    <!-- Solutions & Energy -->
    <div class="cs-group<%= collapsedCls(activeService, "molarity", "unit-converter", "thermo", "electro", "equilibrium") %>" data-group="solutions">
        <button class="cs-group-header" type="button">Solutions &amp; Energy <span class="cs-group-chevron">&#9662;</span></button>
        <div class="cs-group-body">
            <a href="<%= ctx %>/molarity-dilution-calculator.jsp" class="cs-item <%= activeCls(activeService, "molarity") %>">
                <span class="cs-item-icon">&#9219;</span><span class="cs-item-label">Molarity &amp; Dilution</span>
            </a>
            <a href="<%= ctx %>/equilibrium-ph-calculator.jsp" class="cs-item <%= activeCls(activeService, "equilibrium") %>">
                <span class="cs-item-icon">&#8652;</span><span class="cs-item-label">Equilibrium &amp; pH</span>
            </a>
            <a href="<%= ctx %>/unit-converter-chemistry.jsp" class="cs-item <%= activeCls(activeService, "unit-converter") %>">
                <span class="cs-item-icon">&#8644;</span><span class="cs-item-label">Unit Converter</span>
            </a>
            <a href="<%= ctx %>/thermochemistry-calculator.jsp" class="cs-item <%= activeCls(activeService, "thermo") %>">
                <span class="cs-item-icon">&#9832;</span><span class="cs-item-label">Thermochemistry</span>
            </a>
            <a href="<%= ctx %>/electrochemistry-calculator.jsp" class="cs-item <%= activeCls(activeService, "electro") %>">
                <span class="cs-item-icon">&#9889;</span><span class="cs-item-label">Electrochemistry</span>
            </a>
        </div>
    </div>

</aside>

<div class="cs-sidebar-backdrop" id="csSidebarBackdrop"></div>

<script>
(function () {
    var sidebar = document.getElementById('csSidebar');
    var backdrop = document.getElementById('csSidebarBackdrop');
    if (!sidebar) return;

    var STORE_KEY = 'chem.sidebar.collapsed';
    var collapsed = {};
    try { collapsed = JSON.parse(localStorage.getItem(STORE_KEY) || '{}'); } catch (e) {}

    var activeItem = sidebar.querySelector('.cs-item.active');
    var activeGroup = activeItem ? activeItem.closest('.cs-group') : null;
    var activeGroupId = activeGroup ? activeGroup.getAttribute('data-group') : null;

    sidebar.querySelectorAll('.cs-group').forEach(function (g) {
        var id = g.getAttribute('data-group');
        if (!g.querySelector('.cs-group-header')) return; // home (header-less) always open
        if (id === activeGroupId) { g.classList.remove('collapsed'); return; }
        if (collapsed[id] !== false) g.classList.add('collapsed');
    });

    sidebar.querySelectorAll('.cs-group-header').forEach(function (h) {
        h.addEventListener('click', function () {
            var g = h.closest('.cs-group');
            g.classList.toggle('collapsed');
            var id = g.getAttribute('data-group');
            collapsed[id] = g.classList.contains('collapsed');
            try { localStorage.setItem(STORE_KEY, JSON.stringify(collapsed)); } catch (e) {}
        });
    });

    var search = document.getElementById('csSidebarSearch');
    if (search) {
        search.addEventListener('input', function () {
            var q = (search.value || '').trim().toLowerCase();
            sidebar.querySelectorAll('.cs-item, .cs-item-stub').forEach(function (el) {
                var label = el.querySelector('.cs-item-label');
                var text = (label ? label.textContent : '').toLowerCase();
                el.style.display = (!q || text.indexOf(q) !== -1) ? '' : 'none';
            });
            sidebar.querySelectorAll('.cs-group').forEach(function (g) {
                if (q) g.classList.remove('collapsed');
            });
        });
    }

    var toggle  = document.getElementById('csSidebarToggle');
    var hideBtn = document.getElementById('csSidebarHideBtn');
    var main    = document.querySelector('.cs-main');
    var SIDEBAR_HIDDEN_KEY = 'chem.bs.sidebarHidden';

    function safeGet(k)    { try { return localStorage.getItem(k); } catch (e) { return null; } }
    function safeSet(k, v) { try { localStorage.setItem(k, v); } catch (e) {} }

    if (main && safeGet(SIDEBAR_HIDDEN_KEY) === '1') main.classList.add('is-sidebar-hidden');

    function isMobileLayout() {
        return window.matchMedia && window.matchMedia('(max-width: 1023px)').matches;
    }

    if (toggle && backdrop) {
        function closeDrawer () { sidebar.classList.remove('open'); backdrop.classList.remove('open'); }
        toggle.addEventListener('click', function () {
            if (isMobileLayout()) {
                sidebar.classList.add('open'); backdrop.classList.add('open');
            } else if (main) {
                main.classList.remove('is-sidebar-hidden');
                safeSet(SIDEBAR_HIDDEN_KEY, '0');
            }
        });
        backdrop.addEventListener('click', closeDrawer);
        sidebar.querySelectorAll('.cs-item').forEach(function (a) { a.addEventListener('click', closeDrawer); });
    }

    if (hideBtn && main) {
        hideBtn.addEventListener('click', function () {
            main.classList.add('is-sidebar-hidden');
            safeSet(SIDEBAR_HIDDEN_KEY, '1');
        });
    }
})();
</script>
