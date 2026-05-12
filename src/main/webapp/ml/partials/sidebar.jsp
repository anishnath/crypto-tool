<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    Shared sidebar for ml/ pages — mirrors math/partials/sidebar.jsp.

    Usage from parent JSP (before include):
        request.setAttribute("activeService", "gradient-descent");
        <jsp:include page="/ml/partials/sidebar.jsp" />

    Reuses the .ms-* design system from math-studio.css so the visual
    language stays identical to /math/.  Only the tree content differs:
    four chapters (Optimization, Clustering, Linear Models, Neural Nets)
    instead of math categories.

    Items marked data-soon="true" are planned Pyodide notebooks that
    haven't been built yet — rendered as disabled rows with a "soon"
    pill instead of a clickable link.
--%>
<%!
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
<aside class="ms-sidebar" id="msSidebar" aria-label="Machine learning tools">

    <label class="ms-sidebar-search">
        <input type="search" id="msSidebarSearch" placeholder="Search ML demos…" autocomplete="off" />
    </label>

    <!-- Home -->
    <div class="ms-group" data-group="home">
        <div class="ms-group-body">
            <a href="<%= ctx %>/ml/" class="ms-item <%= "home".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#9783;</span>
                <span class="ms-item-label">All ML Demos</span>
            </a>
            <a href="<%= ctx %>/ml/nn-viz.jsp" class="ms-item <%= "nn-viz".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#128202;</span>
                <span class="ms-item-label">NN Architecture Viz</span>
            </a>
            <a href="<%= ctx %>/ML_Pipeline.jsp" class="ms-item <%= "ml-pipeline".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#8649;</span>
                <span class="ms-item-label">ML Pipeline</span>
            </a>
        </div>
    </div>

    <!-- Optimization -->
    <div class="ms-group<%= collapsedCls(activeService, "gradient-descent", "activation-functions") %>" data-group="ch1-optimization">
        <button class="ms-group-header" type="button">Optimization <span class="ms-group-chevron">&#9662;</span></button>
        <div class="ms-group-body">
            <a href="<%= ctx %>/ml/gradient-descent.jsp" class="ms-item <%= "gradient-descent".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#8711;</span>
                <span class="ms-item-label">Gradient Descent</span>
            </a>
            <a href="<%= ctx %>/activation_function_explorer.jsp" class="ms-item <%= "activation-functions".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#963;</span>
                <span class="ms-item-label">Activation Functions</span>
            </a>
        </div>
    </div>

    <!-- Clustering & Reduction -->
    <div class="ms-group<%= collapsedCls(activeService, "k-means", "pca") %>" data-group="ch2-clustering">
        <button class="ms-group-header" type="button">Clustering &amp; Reduction <span class="ms-group-chevron">&#9662;</span></button>
        <div class="ms-group-body">
            <a href="<%= ctx %>/ml/k-means.jsp" class="ms-item <%= "k-means".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">K</span>
                <span class="ms-item-label">K-Means</span>
            </a>
            <a href="<%= ctx %>/ml/pca.jsp" class="ms-item <%= "pca".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#955;</span>
                <span class="ms-item-label">PCA</span>
            </a>
        </div>
    </div>

    <!-- Linear Models -->
    <div class="ms-group<%= collapsedCls(activeService, "perceptron", "logistic-regression", "roc-auc") %>" data-group="ch3-linear-models">
        <button class="ms-group-header" type="button">Linear Models <span class="ms-group-chevron">&#9662;</span></button>
        <div class="ms-group-body">
            <a href="<%= ctx %>/ml/perceptron.jsp" class="ms-item <%= "perceptron".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#10138;</span>
                <span class="ms-item-label">Perceptron</span>
            </a>
            <a href="<%= ctx %>/Logistic_Regression.jsp" class="ms-item <%= "logistic-regression".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#x222B;&sigma;</span>
                <span class="ms-item-label">Logistic Regression</span>
            </a>
            <a href="<%= ctx %>/ROC_AUC.jsp" class="ms-item <%= "roc-auc".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">ROC</span>
                <span class="ms-item-label">ROC &amp; AUC</span>
            </a>
        </div>
    </div>

    <!-- Neural Networks -->
    <div class="ms-group<%= collapsedCls(activeService, "nn-viz") %>" data-group="ch4-neural-networks">
        <button class="ms-group-header" type="button">Neural Networks <span class="ms-group-chevron">&#9662;</span></button>
        <div class="ms-group-body">
            <a href="<%= ctx %>/ml/nn-viz.jsp" class="ms-item <%= "nn-viz".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#9678;</span>
                <span class="ms-item-label">NN Architecture Viz</span>
            </a>
        </div>
    </div>
</aside>

<div class="ms-sidebar-backdrop" id="msSidebarBackdrop"></div>

<script>
(function () {
    var sidebar = document.getElementById('msSidebar');
    var backdrop = document.getElementById('msSidebarBackdrop');
    if (!sidebar) return;

    var STORE_KEY = 'ml.sidebar.collapsed';
    var collapsed = {};
    try { collapsed = JSON.parse(localStorage.getItem(STORE_KEY) || '{}'); } catch (e) {}

    var activeItem = sidebar.querySelector('.ms-item.active');
    var activeGroup = activeItem ? activeItem.closest('.ms-group') : null;
    var activeGroupId = activeGroup ? activeGroup.getAttribute('data-group') : null;

    sidebar.querySelectorAll('.ms-group').forEach(function (g) {
        var id = g.getAttribute('data-group');
        if (!g.querySelector('.ms-group-header')) return;
        if (id === activeGroupId) { g.classList.remove('collapsed'); return; }
        if (collapsed[id] !== false) g.classList.add('collapsed');
    });

    sidebar.querySelectorAll('.ms-group-header').forEach(function (h) {
        h.addEventListener('click', function () {
            var g = h.closest('.ms-group');
            g.classList.toggle('collapsed');
            var id = g.getAttribute('data-group');
            collapsed[id] = g.classList.contains('collapsed');
            try { localStorage.setItem(STORE_KEY, JSON.stringify(collapsed)); } catch (e) {}
        });
    });

    var search = document.getElementById('msSidebarSearch');
    if (search) {
        search.addEventListener('input', function () {
            var q = (search.value || '').trim().toLowerCase();
            sidebar.querySelectorAll('.ms-item').forEach(function (a) {
                var label = a.querySelector('.ms-item-label');
                var text = (label ? label.textContent : '').toLowerCase();
                a.style.display = (!q || text.indexOf(q) !== -1) ? '' : 'none';
            });
            sidebar.querySelectorAll('.ms-group').forEach(function (g) {
                if (q) g.classList.remove('collapsed');
            });
        });
    }

    var toggle = document.getElementById('msSidebarToggle');
    if (toggle && backdrop) {
        function closeDrawer () { sidebar.classList.remove('open'); backdrop.classList.remove('open'); }
        toggle.addEventListener('click', function () {
            sidebar.classList.add('open'); backdrop.classList.add('open');
        });
        backdrop.addEventListener('click', closeDrawer);
        sidebar.querySelectorAll('.ms-item').forEach(function (a) {
            a.addEventListener('click', closeDrawer);
        });
    }
})();
</script>