<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    Shared sidebar for biology/ pages. Mirrors math/partials/sidebar.jsp
    structure: collapsible groups, client-side search, mobile drawer,
    localStorage-persisted open/closed state.

    Usage from the parent JSP (before include):
        request.setAttribute("activeService", "cell-atlas");
        <jsp:include page="/biology/partials/sidebar.jsp" />
--%>
<%!
    /* Returns " collapsed" when the active tool does NOT belong to this
       group. All other groups stay open. */
    private String collapsedCls(String activeService, String... keys) {
        if (activeService == null) return " collapsed";
        for (String k : keys) if (k.equals(activeService)) return "";
        return " collapsed";
    }
%>
<%
    String activeService = (String) request.getAttribute("activeService");
    if (activeService == null) activeService = "home";
    String ctx = request.getContextPath();
%>
<aside class="bs-sidebar" id="bsSidebar" aria-label="Biology tools">

    <%-- Header bar with collapse chevron (desktop only). On mobile the
         drawer is opened/closed via the bsSidebarToggle outside the
         aside, so this chevron is hidden there. --%>
    <div class="bs-sidebar-header">
        <span class="bs-sidebar-title">Biology</span>
        <button type="button" class="bs-sidebar-hide-btn" id="bsSidebarHideBtn"
                aria-label="Hide sidebar to widen the page" title="Hide sidebar">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                <polyline points="15 6 9 12 15 18"></polyline>
            </svg>
        </button>
    </div>

    <label class="bs-sidebar-search">
        <input type="search" id="bsSidebarSearch" placeholder="Search biology tools…" autocomplete="off" />
    </label>

    <!-- Home -->
    <div class="bs-group" data-group="home">
        <div class="bs-group-body">
            <a href="<%= ctx %>/biology/" class="bs-item <%= "home".equals(activeService) ? "active" : "" %>">
                <span class="bs-item-icon">&#127807;</span>
                <span class="bs-item-label">All Biology Tools</span>
            </a>
        </div>
    </div>

    <!-- Cell Biology -->
    <div class="bs-group<%= collapsedCls(activeService, "cell-atlas") %>" data-group="cell-biology">
        <button class="bs-group-header" type="button">Cell Biology <span class="bs-group-chevron">&#9662;</span></button>
        <div class="bs-group-body">
            <a href="<%= ctx %>/biology/cell-atlas.jsp" class="bs-item <%= "cell-atlas".equals(activeService) ? "active" : "" %>">
                <span class="bs-item-icon">&#9678;</span>
                <span class="bs-item-label">Cell Atlas 3D</span>
            </a>
            <%-- Stubs for upcoming tools so the section communicates direction. --%>
            <span class="bs-item-stub" title="Coming soon">
                <span class="bs-item-icon">DNA</span>
                <span class="bs-item-label">DNA Viewer</span>
                <span class="bs-item-soon">Soon</span>
            </span>
            <span class="bs-item-stub" title="Coming soon">
                <span class="bs-item-icon">&#10070;</span>
                <span class="bs-item-label">Mitosis Walkthrough</span>
                <span class="bs-item-soon">Soon</span>
            </span>
        </div>
    </div>

    <!-- Genetics (stubbed) -->
    <div class="bs-group collapsed" data-group="genetics">
        <button class="bs-group-header" type="button">Genetics <span class="bs-group-chevron">&#9662;</span></button>
        <div class="bs-group-body">
            <span class="bs-item-stub" title="Coming soon">
                <span class="bs-item-icon">G&#x1d63;</span>
                <span class="bs-item-label">Punnett Square</span>
                <span class="bs-item-soon">Soon</span>
            </span>
            <span class="bs-item-stub" title="Coming soon">
                <span class="bs-item-icon">&#x1d4d7;</span>
                <span class="bs-item-label">Hardy-Weinberg</span>
                <span class="bs-item-soon">Soon</span>
            </span>
            <span class="bs-item-stub" title="Coming soon">
                <span class="bs-item-icon">aa</span>
                <span class="bs-item-label">Codon Table</span>
                <span class="bs-item-soon">Soon</span>
            </span>
        </div>
    </div>

    <!-- Anatomy (stubbed) -->
    <div class="bs-group collapsed" data-group="anatomy">
        <button class="bs-group-header" type="button">Anatomy <span class="bs-group-chevron">&#9662;</span></button>
        <div class="bs-group-body">
            <span class="bs-item-stub" title="Coming soon">
                <span class="bs-item-icon">&#9763;</span>
                <span class="bs-item-label">Skeletal Atlas</span>
                <span class="bs-item-soon">Soon</span>
            </span>
            <span class="bs-item-stub" title="Coming soon">
                <span class="bs-item-icon">&#9829;</span>
                <span class="bs-item-label">Heart Cycle</span>
                <span class="bs-item-soon">Soon</span>
            </span>
        </div>
    </div>

    <!-- Ecology (stubbed) -->
    <div class="bs-group collapsed" data-group="ecology">
        <button class="bs-group-header" type="button">Ecology <span class="bs-group-chevron">&#9662;</span></button>
        <div class="bs-group-body">
            <span class="bs-item-stub" title="Coming soon">
                <span class="bs-item-icon">&#x1f33f;</span>
                <span class="bs-item-label">Food Web</span>
                <span class="bs-item-soon">Soon</span>
            </span>
            <span class="bs-item-stub" title="Coming soon">
                <span class="bs-item-icon">N&#x209c;</span>
                <span class="bs-item-label">Population Models</span>
                <span class="bs-item-soon">Soon</span>
            </span>
        </div>
    </div>

</aside>

<div class="bs-sidebar-backdrop" id="bsSidebarBackdrop"></div>

<script>
(function () {
    var sidebar = document.getElementById('bsSidebar');
    var backdrop = document.getElementById('bsSidebarBackdrop');
    if (!sidebar) return;

    var STORE_KEY = 'bs.sidebar.collapsed';
    var collapsed = {};
    try { collapsed = JSON.parse(localStorage.getItem(STORE_KEY) || '{}'); } catch (e) {}

    var activeItem = sidebar.querySelector('.bs-item.active');
    var activeGroup = activeItem ? activeItem.closest('.bs-group') : null;
    var activeGroupId = activeGroup ? activeGroup.getAttribute('data-group') : null;

    sidebar.querySelectorAll('.bs-group').forEach(function (g) {
        var id = g.getAttribute('data-group');
        if (!g.querySelector('.bs-group-header')) return; // home (header-less) always open
        if (id === activeGroupId) { g.classList.remove('collapsed'); return; }
        // Only restore the user's explicit "opened" preference; default
        // collapsed otherwise so first visits aren't overwhelming.
        if (collapsed[id] !== false) g.classList.add('collapsed');
    });

    sidebar.querySelectorAll('.bs-group-header').forEach(function (h) {
        h.addEventListener('click', function () {
            var g = h.closest('.bs-group');
            g.classList.toggle('collapsed');
            var id = g.getAttribute('data-group');
            collapsed[id] = g.classList.contains('collapsed');
            try { localStorage.setItem(STORE_KEY, JSON.stringify(collapsed)); } catch (e) {}
        });
    });

    var search = document.getElementById('bsSidebarSearch');
    if (search) {
        search.addEventListener('input', function () {
            var q = (search.value || '').trim().toLowerCase();
            sidebar.querySelectorAll('.bs-item, .bs-item-stub').forEach(function (el) {
                var label = el.querySelector('.bs-item-label');
                var text = (label ? label.textContent : '').toLowerCase();
                el.style.display = (!q || text.indexOf(q) !== -1) ? '' : 'none';
            });
            sidebar.querySelectorAll('.bs-group').forEach(function (g) {
                if (q) g.classList.remove('collapsed');
            });
        });
    }

    // Mobile drawer (always) + desktop hide/show via the same toggle button.
    var toggle  = document.getElementById('bsSidebarToggle');
    var hideBtn = document.getElementById('bsSidebarHideBtn');
    var main    = document.querySelector('.bs-main');
    var SIDEBAR_HIDDEN_KEY = 'biology.bs.sidebarHidden';

    function safeGet(k)    { try { return localStorage.getItem(k); } catch (e) { return null; } }
    function safeSet(k, v) { try { localStorage.setItem(k, v); } catch (e) {} }

    // Restore the desktop "hidden" state on load. Mobile drawer never
    // sticks across reloads — that would surprise users on a phone.
    if (main && safeGet(SIDEBAR_HIDDEN_KEY) === '1') {
        main.classList.add('is-sidebar-hidden');
    }

    function isMobileLayout() {
        return window.matchMedia && window.matchMedia('(max-width: 1023px)').matches;
    }

    if (toggle && backdrop) {
        function closeDrawer () { sidebar.classList.remove('open'); backdrop.classList.remove('open'); }
        toggle.addEventListener('click', function () {
            if (isMobileLayout()) {
                // Mobile: open the slide-in drawer.
                sidebar.classList.add('open'); backdrop.classList.add('open');
            } else if (main) {
                // Desktop: bring the sidebar column back.
                main.classList.remove('is-sidebar-hidden');
                safeSet(SIDEBAR_HIDDEN_KEY, '0');
            }
        });
        backdrop.addEventListener('click', closeDrawer);
        sidebar.querySelectorAll('.bs-item').forEach(function (a) {
            a.addEventListener('click', closeDrawer);
        });
    }

    if (hideBtn && main) {
        hideBtn.addEventListener('click', function () {
            main.classList.add('is-sidebar-hidden');
            safeSet(SIDEBAR_HIDDEN_KEY, '1');
        });
    }
})();
</script>
