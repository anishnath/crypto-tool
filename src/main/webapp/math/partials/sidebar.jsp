<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    Shared sidebar for math/ pages.

    Usage from parent JSP (before include):
        request.setAttribute("activeService", "integral-calculator");
        <jsp:include page="/math/partials/sidebar.jsp" />

    Mark the current tool so its row highlights and its group auto-expands.
    All OTHER groups render collapsed by default (no animation flash on
    load); the inline script below restores the user's manually-opened
    groups from localStorage on hydration.
--%>
<%!
    /* Returns the literal class fragment " collapsed" when the active tool
       does NOT live inside this group, otherwise "".  The keys passed in
       must match the activeService values used by each <a class="ms-item">. */
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
<aside class="ms-sidebar" id="msSidebar" aria-label="Math tools">

    <%-- Header bar with hide chevron (desktop only). On mobile the drawer
         is opened/closed via the msSidebarToggle outside the aside, so this
         chevron is hidden there. --%>
    <div class="ms-sidebar-header">
        <span class="ms-sidebar-title">Math</span>
        <button type="button" class="ms-sidebar-hide-btn" id="msSidebarHideBtn"
                aria-label="Hide sidebar to widen the page" title="Hide sidebar">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                <polyline points="15 6 9 12 15 18"></polyline>
            </svg>
        </button>
    </div>

    <label class="ms-sidebar-search">
        <input type="search" id="msSidebarSearch" placeholder="Search 48+ tools…" autocomplete="off" />
    </label>

    <!-- Home -->
    <div class="ms-group" data-group="home">
        <div class="ms-group-body">
            <a href="<%= ctx %>/math/" class="ms-item <%= "home".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#8962;</span>
                <span class="ms-item-label">All Math Tools</span>
            </a>
            <a href="<%= ctx %>/math/dashboard.jsp" class="ms-item <%= "editor".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#x2211;</span>
                <span class="ms-item-label">Math Editor</span>
            </a>
            <a href="<%= ctx %>/math/worksheet.jsp" class="ms-item <%= "worksheet".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#128218;</span>
                <span class="ms-item-label">Practice Worksheets</span>
            </a>
        </div>
    </div>

    <!-- Everyday Math -->
    <div class="ms-group<%= collapsedCls(activeService, "percentage", "sig-figs", "exponent", "logarithm", "24-game", "collatz", "magic-square", "prime-number", "rubiks-cube", "pocket-cube", "rubik-nxn", "quick-math", "math-memory") %>" data-group="everyday">
        <button class="ms-group-header" type="button">Everyday <span class="ms-group-chevron">&#9662;</span></button>
        <div class="ms-group-body">
            <a href="<%= ctx %>/percentage-calculator.jsp" class="ms-item <%= "percentage".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">%</span> <span class="ms-item-label">Percentage</span>
            </a>
            <a href="<%= ctx %>/significant-figures-calculator.jsp" class="ms-item <%= "sig-figs".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">SF</span> <span class="ms-item-label">Significant Figures</span>
            </a>
            <a href="<%= ctx %>/exponent-calculator.jsp" class="ms-item <%= "exponent".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">x&#8319;</span> <span class="ms-item-label">Exponents</span>
            </a>
            <a href="<%= ctx %>/logarithm-calculator.jsp" class="ms-item <%= "logarithm".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">log</span> <span class="ms-item-label">Logarithm</span>
            </a>
            <a href="<%= ctx %>/24-game-solver.jsp" class="ms-item <%= "24-game".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">24</span> <span class="ms-item-label">24 Game Solver</span>
            </a>
            <a href="<%= ctx %>/collatz-conjecture.jsp" class="ms-item <%= "collatz".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">3n+1</span> <span class="ms-item-label">Collatz Conjecture</span>
            </a>
            <a href="<%= ctx %>/magic-square-generator.jsp" class="ms-item <%= "magic-square".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#9744;</span> <span class="ms-item-label">Magic Square</span>
            </a>
            <a href="<%= ctx %>/prime-number.jsp" class="ms-item <%= "prime-number".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#8473;</span> <span class="ms-item-label">Prime Numbers</span>
            </a>
            <a href="<%= ctx %>/math/rubiks-cube-solver.jsp" class="ms-item <%= "rubiks-cube".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#129513;</span> <span class="ms-item-label">Rubik's Cube (3×3)</span>
            </a>
            <a href="<%= ctx %>/math/pocket-cube-solver.jsp" class="ms-item <%= "pocket-cube".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">2×2</span> <span class="ms-item-label">Pocket Cube (2×2)</span>
            </a>
            <a href="<%= ctx %>/math/rubik-nxn-solver.jsp" class="ms-item <%= "rubik-nxn".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">N×N</span> <span class="ms-item-label">Rubik N×N Solver</span>
            </a>
            <a href="<%= ctx %>/math/quick-math/" class="ms-item <%= "quick-math".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#9889;</span> <span class="ms-item-label">Quick Math</span>
            </a>
            <a href="<%= ctx %>/math/math-memory/" class="ms-item <%= "math-memory".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#129504;</span> <span class="ms-item-label">Math Memory</span>
            </a>
        </div>
    </div>

    <!-- Algebra -->
    <div class="ms-group<%= collapsedCls(activeService, "quadratic", "system-equations", "inequality", "polynomial") %>" data-group="algebra">
        <button class="ms-group-header" type="button">Algebra <span class="ms-group-chevron">&#9662;</span></button>
        <div class="ms-group-body">
            <a href="<%= ctx %>/quadratic-solver.jsp" class="ms-item <%= "quadratic".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">x&#178;</span> <span class="ms-item-label">Quadratic Solver</span>
            </a>
            <%-- linear-equations-solver.jsp absorbed into system-equations-solver.jsp;
                 Cloudflare 301s the old URL. Sidebar shows just the canonical entry. --%>
            <a href="<%= ctx %>/system-equations-solver.jsp" class="ms-item <%= "system-equations".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#123;</span> <span class="ms-item-label">System of Equations</span>
            </a>
            <a href="<%= ctx %>/inequality-solver.jsp" class="ms-item <%= "inequality".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#8804;</span> <span class="ms-item-label">Inequality Solver</span>
            </a>
            <a href="<%= ctx %>/polynomial-calculator.jsp" class="ms-item <%= "polynomial".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">P(x)</span> <span class="ms-item-label">Polynomial</span>
            </a>
        </div>
    </div>

    <!-- Calculus -->
    <div class="ms-group<%= collapsedCls(activeService, "derivative", "integral-calculator", "limit", "series", "vector-calculus", "ode", "pde") %>" data-group="calculus">
        <button class="ms-group-header" type="button">Calculus <span class="ms-group-chevron">&#9662;</span></button>
        <div class="ms-group-body">
            <a href="<%= ctx %>/derivative-calculator.jsp" class="ms-item <%= "derivative".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">d/dx</span> <span class="ms-item-label">Derivative</span>
            </a>
            <a href="<%= ctx %>/integral-calculator.jsp" class="ms-item <%= "integral-calculator".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#8747;</span> <span class="ms-item-label">Integral</span>
            </a>
            <a href="<%= ctx %>/limit-calculator.jsp" class="ms-item <%= "limit".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">lim</span> <span class="ms-item-label">Limit</span>
            </a>
            <a href="<%= ctx %>/series-calculator.jsp" class="ms-item <%= "series".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#931;</span> <span class="ms-item-label">Taylor Series</span>
            </a>
            <a href="<%= ctx %>/vector-calculus-calculator.jsp" class="ms-item <%= "vector-calculus".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#8711;</span> <span class="ms-item-label">Vector Calculus</span>
            </a>
            <a href="<%= ctx %>/ode-solver-calculator.jsp" class="ms-item <%= "ode".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">y'</span> <span class="ms-item-label">ODE Solver</span>
            </a>
            <a href="<%= ctx %>/pde-solver-calculator.jsp" class="ms-item <%= "pde".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#8706;u</span> <span class="ms-item-label">PDE Solver</span>
            </a>
        </div>
    </div>

    <!-- Linear Algebra -->
    <div class="ms-group<%= collapsedCls(activeService, "matrix", "vector") %>" data-group="linear-algebra">
        <button class="ms-group-header" type="button">Linear Algebra <span class="ms-group-chevron">&#9662;</span></button>
        <div class="ms-group-body">
            <a href="<%= ctx %>/math/matrix-calculator.jsp" class="ms-item <%= "matrix".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#119820;</span> <span class="ms-item-label">Matrix Calculator</span>
            </a>
            <a href="<%= ctx %>/vector-calculator.jsp" class="ms-item <%= "vector".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#8407;v</span> <span class="ms-item-label">Vector</span>
            </a>
        </div>
    </div>

    <!-- Exams -->
    <div class="ms-group<%= collapsedCls(activeService, "amc", "aime", "olympiad-practice", "jee-hub", "jee-practice", "jee-mock") %>" data-group="exams">
        <button class="ms-group-header" type="button">Exams <span class="ms-group-chevron">&#9662;</span></button>
        <div class="ms-group-body">
            <a href="<%= ctx %>/math/amc/" class="ms-item <%= "amc".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">AMC</span> <span class="ms-item-label">AMC Mock Test</span>
            </a>
            <a href="<%= ctx %>/math/amc/aime.jsp" class="ms-item <%= "aime".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">AIME</span> <span class="ms-item-label">AIME Mock Test</span>
            </a>
            <a href="<%= ctx %>/math/olympiad/" class="ms-item <%= "olympiad-practice".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#9733;</span> <span class="ms-item-label">Olympiad Practice</span>
            </a>
            <a href="<%= ctx %>/math/iit/" class="ms-item <%= ("jee-hub".equals(activeService) || "jee-mock".equals(activeService)) ? "active" : "" %>">
                <span class="ms-item-icon">JEE</span> <span class="ms-item-label">JEE Mains 2025 Mock</span>
            </a>
            <a href="<%= ctx %>/math/iit/practice.jsp" class="ms-item <%= "jee-practice".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#128214;</span> <span class="ms-item-label">JEE Practice</span>
            </a>
        </div>
    </div>

    <!-- Trigonometry -->
    <div class="ms-group<%= collapsedCls(activeService, "trig-fn", "trig-id", "trig-eq") %>" data-group="trig">
        <button class="ms-group-header" type="button">Trigonometry <span class="ms-group-chevron">&#9662;</span></button>
        <div class="ms-group-body">
            <a href="<%= ctx %>/trigonometric-function-calculator.jsp" class="ms-item <%= "trig-fn".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">sin</span> <span class="ms-item-label">Trig Functions</span>
            </a>
            <a href="<%= ctx %>/trigonometric-identity-calculator.jsp" class="ms-item <%= "trig-id".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">=</span> <span class="ms-item-label">Trig Identities</span>
            </a>
            <a href="<%= ctx %>/trigonometric-equation-solver.jsp" class="ms-item <%= "trig-eq".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#952;</span> <span class="ms-item-label">Trig Equations</span>
            </a>
        </div>
    </div>

    <!-- Statistics -->
    <div class="ms-group<%= collapsedCls(activeService, "summary-stats", "mean-median-mode", "stddev", "variance", "percentile", "z-score", "normal-dist", "binomial-dist", "probability", "confidence", "hypothesis", "t-test", "chi-square", "anova", "correlation", "regression", "sample-size", "effect-size", "std-error", "outlier", "p-value") %>" data-group="statistics">
        <button class="ms-group-header" type="button">Statistics <span class="ms-group-chevron">&#9662;</span></button>
        <div class="ms-group-body">
            <a href="<%= ctx %>/summary-statistics-calculator.jsp" class="ms-item <%= "summary-stats".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#931;</span> <span class="ms-item-label">Summary Stats</span>
            </a>
            <a href="<%= ctx %>/mean-median-mode.jsp" class="ms-item <%= "mean-median-mode".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">x&#772;</span> <span class="ms-item-label">Mean / Median / Mode</span>
            </a>
            <a href="<%= ctx %>/standard-deviation.jsp" class="ms-item <%= "stddev".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#963;</span> <span class="ms-item-label">Standard Deviation</span>
            </a>
            <a href="<%= ctx %>/variance-calculator.jsp" class="ms-item <%= "variance".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#963;&#178;</span> <span class="ms-item-label">Variance</span>
            </a>
            <a href="<%= ctx %>/percentile-calculator.jsp" class="ms-item <%= "percentile".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">%ile</span> <span class="ms-item-label">Percentile</span>
            </a>
            <a href="<%= ctx %>/z-score-calculator.jsp" class="ms-item <%= "z-score".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">Z</span> <span class="ms-item-label">Z-Score</span>
            </a>
            <a href="<%= ctx %>/normal-distribution-calculator.jsp" class="ms-item <%= "normal-dist".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#119977;</span> <span class="ms-item-label">Normal Dist.</span>
            </a>
            <a href="<%= ctx %>/binomial-distribution-calculator.jsp" class="ms-item <%= "binomial-dist".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">B</span> <span class="ms-item-label">Binomial Dist.</span>
            </a>
            <a href="<%= ctx %>/probability-calculator.jsp" class="ms-item <%= "probability".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">P</span> <span class="ms-item-label">Probability</span>
            </a>
            <a href="<%= ctx %>/confidence-interval-calculator.jsp" class="ms-item <%= "confidence".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">CI</span> <span class="ms-item-label">Confidence Interval</span>
            </a>
            <a href="<%= ctx %>/hypothesis-test-calculator.jsp" class="ms-item <%= "hypothesis".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">H&#8320;</span> <span class="ms-item-label">Hypothesis Test</span>
            </a>
            <a href="<%= ctx %>/t-test-calculator.jsp" class="ms-item <%= "t-test".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">t</span> <span class="ms-item-label">T-Test</span>
            </a>
            <a href="<%= ctx %>/chi-square-calculator.jsp" class="ms-item <%= "chi-square".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#967;&#178;</span> <span class="ms-item-label">Chi-Square</span>
            </a>
            <a href="<%= ctx %>/anova-calculator.jsp" class="ms-item <%= "anova".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">F</span> <span class="ms-item-label">ANOVA</span>
            </a>
            <a href="<%= ctx %>/correlation-calculator.jsp" class="ms-item <%= "correlation".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">r</span> <span class="ms-item-label">Correlation</span>
            </a>
            <a href="<%= ctx %>/linear-regression-calculator.jsp" class="ms-item <%= "regression".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#8739;</span> <span class="ms-item-label">Linear Regression</span>
            </a>
            <a href="<%= ctx %>/sample-size-calculator.jsp" class="ms-item <%= "sample-size".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">n</span> <span class="ms-item-label">Sample Size</span>
            </a>
            <a href="<%= ctx %>/effect-size-calculator.jsp" class="ms-item <%= "effect-size".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">d</span> <span class="ms-item-label">Effect Size</span>
            </a>
            <a href="<%= ctx %>/standard-error-calculator.jsp" class="ms-item <%= "std-error".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">SE</span> <span class="ms-item-label">Standard Error</span>
            </a>
            <a href="<%= ctx %>/outlier-detection-calculator.jsp" class="ms-item <%= "outlier".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">!</span> <span class="ms-item-label">Outlier Detection</span>
            </a>
            <a href="<%= ctx %>/p-value-calculator.jsp" class="ms-item <%= "p-value".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">p</span> <span class="ms-item-label">P-Value</span>
            </a>
        </div>
    </div>

    <!-- Graphing -->
    <div class="ms-group<%= collapsedCls(activeService, "graphing") %>" data-group="graphing">
        <button class="ms-group-header" type="button">Graphing <span class="ms-group-chevron">&#9662;</span></button>
        <div class="ms-group-body">
            <a href="<%= ctx %>/graphing-calculator.jsp" class="ms-item <%= "graphing".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#8962;</span> <span class="ms-item-label">Graphing Calculator</span>
            </a>
        </div>
    </div>

    <!-- Control &amp; Signals -->
    <div class="ms-group<%= collapsedCls(activeService, "bode", "laplace", "ztransform", "convolution") %>" data-group="control">
        <button class="ms-group-header" type="button">Control &amp; Signals <span class="ms-group-chevron">&#9662;</span></button>
        <div class="ms-group-body">
            <a href="<%= ctx %>/bode-plot-generator.jsp" class="ms-item <%= "bode".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">H(s)</span> <span class="ms-item-label">Bode Plot</span>
            </a>
            <a href="<%= ctx %>/laplace-transform-calculator.jsp" class="ms-item <%= "laplace".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#8466;</span> <span class="ms-item-label">Laplace Transform</span>
            </a>
            <a href="<%= ctx %>/z-transform-calculator.jsp" class="ms-item <%= "ztransform".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">Z</span> <span class="ms-item-label">Z-Transform</span>
            </a>
            <a href="<%= ctx %>/convolution-calculator.jsp" class="ms-item <%= "convolution".equals(activeService) ? "active" : "" %>">
                <span class="ms-item-icon">&#8727;</span> <span class="ms-item-label">Convolution</span>
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

    // Active item's group auto-expands; others restore from localStorage.
    var STORE_KEY = 'ms.sidebar.collapsed';
    var collapsed = {};
    try { collapsed = JSON.parse(localStorage.getItem(STORE_KEY) || '{}'); } catch (e) {}

    var activeItem = sidebar.querySelector('.ms-item.active');
    var activeGroup = activeItem ? activeItem.closest('.ms-group') : null;
    var activeGroupId = activeGroup ? activeGroup.getAttribute('data-group') : null;

    sidebar.querySelectorAll('.ms-group').forEach(function (g) {
        var id = g.getAttribute('data-group');
        // Home group is header-less and always open.
        if (!g.querySelector('.ms-group-header')) return;
        if (id === activeGroupId) { g.classList.remove('collapsed'); return; }
        // Default state is COLLAPSED — keeps the sidebar tidy on first visit.
        // localStorage only overrides this when the user has explicitly
        // opened a group (stored as `false`).  Stored `true` and missing
        // both collapse, so we just check for the explicit `false`.
        if (collapsed[id] !== false) g.classList.add('collapsed');
    });

    sidebar.querySelectorAll('.ms-group-header').forEach(function (h) {
        h.addEventListener('click', function () {
            var g = h.closest('.ms-group');
            g.classList.toggle('collapsed');
            var id = g.getAttribute('data-group');
            // Persist BOTH states so we can distinguish "user opened this"
            // from "never touched" (default collapsed).
            collapsed[id] = g.classList.contains('collapsed');
            try { localStorage.setItem(STORE_KEY, JSON.stringify(collapsed)); } catch (e) {}
        });
    });

    // Client-side search filter across all items.
    var search = document.getElementById('msSidebarSearch');
    if (search) {
        search.addEventListener('input', function () {
            var q = (search.value || '').trim().toLowerCase();
            sidebar.querySelectorAll('.ms-item').forEach(function (a) {
                var label = a.querySelector('.ms-item-label');
                var text = (label ? label.textContent : '').toLowerCase();
                a.style.display = (!q || text.indexOf(q) !== -1) ? '' : 'none';
            });
            // When searching, expand every group so matches are visible.
            sidebar.querySelectorAll('.ms-group').forEach(function (g) {
                if (q) g.classList.remove('collapsed');
            });
        });
    }

    // Mobile drawer (always) + desktop hide/show via the same toggle button.
    var toggle  = document.getElementById('msSidebarToggle');
    var hideBtn = document.getElementById('msSidebarHideBtn');
    var main    = document.querySelector('.ms-main');
    var SIDEBAR_HIDDEN_KEY = 'math.ms.sidebarHidden';

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
        sidebar.querySelectorAll('.ms-item').forEach(function (a) {
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
