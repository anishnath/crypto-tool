<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Permutations & Combinations Calculator - Pascal's Triangle (Free)";
    String seoDescription = "Interactive permutations and combinations visualizer. Explore Pascal's triangle, nPr, nCr calculations. See selection and arrangement visualizations with step-by-step counting.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-math/permutations-combinations.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Permutations &amp; Combinations Calculator - Pascal's Triangle\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Permutations &amp; Combinations Calculator\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"permutations calculator, combinations calculator, nPr nCr, pascal triangle, counting principle, factorial, binomial coefficient, discrete math, probability\">");

    request.setAttribute("pageTitle", seoTitle);
    request.setAttribute("pageDescription", seoDescription);
    request.setAttribute("canonicalUrl", canonicalUrl);
    request.setAttribute("extraHeadContent", extraHead.toString());
    request.setAttribute("skipMathJax", "true");
%>
<%@ include file="../components/header.jsp" %>
<link rel="stylesheet" href="<%=request.getContextPath()%>/exams/visual-math/visual-math.css">

<div class="container">
    <nav class="breadcrumb">
        <a href="<%=request.getContextPath()%>/exams/">Exams</a>
        <span class="breadcrumb-separator">/</span>
        <a href="<%=request.getContextPath()%>/exams/visual-math/">Visual Math</a>
        <span class="breadcrumb-separator">/</span>
        <span class="breadcrumb-current">Permutations &amp; Combinations</span>
    </nav>

    <div class="viz-header">
        <h1>Permutations &amp; Combinations</h1>
        <p class="viz-subtitle">Explore Pascal&rsquo;s triangle, visualize selections (C) and arrangements (P), and see how nPr and nCr are computed step by step.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Counting</h3>

                <div class="control-group">
                    <label>Visualization</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-preset="pascal">Pascal&rsquo;s Triangle</button>
                        <button class="vm-chip" data-preset="selection">Selection (C)</button>
                        <button class="vm-chip" data-preset="arrangement">Arrangement (P)</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>n = <span id="n-display">6</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="n-slider" min="1" max="12" value="6" step="1">
                        <span class="viz-slider-val" id="n-val">6</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>r = <span id="r-display">2</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="r-slider" min="0" max="12" value="2" step="1">
                        <span class="viz-slider-val" id="r-val">2</span>
                    </div>
                </div>

                <p class="control-note" style="font-size:0.85em;color:#64748b;margin:4px 0 0;">Adjust n and r to explore counting</p>
            </div>

            <div class="viz-values">
                <h3>Values</h3>
                <table>
                    <tr><td>n</td><td id="val-n">--</td></tr>
                    <tr><td>r</td><td id="val-r">--</td></tr>
                    <tr><td>P(n,r)</td><td id="val-perm">--</td></tr>
                    <tr><td>C(n,r)</td><td id="val-comb">--</td></tr>
                    <tr><td>n!</td><td id="val-nfact">--</td></tr>
                    <tr><td>P/C ratio</td><td id="val-ratio">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Math Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Permutations</h3>
                <ul>
                    <li>Formula: <span class="formula-highlight">P(n, r) = n! / (n &minus; r)!</span></li>
                    <li><strong>Order matters</strong> &mdash; different arrangements of the same items count separately</li>
                    <li>Multiplication principle: <span class="formula-highlight">n &times; (n&minus;1) &times; &hellip; &times; (n&minus;r+1)</span></li>
                    <li>Special case: P(n, n) = n! &mdash; total arrangements of all items</li>
                    <li>Example: ways to award gold, silver, bronze from 10 athletes = P(10, 3) = 720</li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Combinations</h3>
                <ul>
                    <li>Formula: <span class="formula-highlight">C(n, r) = n! / (r!(n &minus; r)!)</span></li>
                    <li><strong>Order doesn&rsquo;t matter</strong> &mdash; only the selection counts, not the arrangement</li>
                    <li>Pascal&rsquo;s Triangle: <span class="formula-highlight">C(n, r) = C(n&minus;1, r&minus;1) + C(n&minus;1, r)</span></li>
                    <li>Binomial theorem: <span class="formula-highlight">(a + b)<sup>n</sup> = &sum; C(n, k) a<sup>n&minus;k</sup> b<sup>k</sup></span></li>
                    <li>Relationship: <span class="formula-highlight">P(n, r) = C(n, r) &times; r!</span></li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-math/probability-distributions.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(147,51,234,0.12);">&#119977;</div>
                <div><h4>Probability Distributions</h4><span>Statistics</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/venn-diagram.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(249,115,22,0.12);">&#8745;</div>
                <div><h4>Venn Diagram</h4><span>Probability</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#8943;</div>
                <div><h4>All Visualizations</h4><span>Browse</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{"@context":"https://schema.org","@type":"LearningResource","name":"Permutations & Combinations Calculator - Pascal's Triangle","description":"Interactive permutations and combinations visualizer. Explore Pascal's triangle, nPr, nCr calculations with selection and arrangement visualizations.","url":"https://8gwifi.org/exams/visual-math/permutations-combinations.jsp","educationalLevel":"High School","teaches":"Permutations, combinations, Pascal's triangle, nPr, nCr, factorial, binomial coefficient, counting principle","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Math Lab","item":"https://8gwifi.org/exams/visual-math/"},{"@type":"ListItem","position":4,"name":"Permutations & Combinations"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"What is the difference between permutations and combinations?","acceptedAnswer":{"@type":"Answer","text":"Permutations count arrangements where order matters. Combinations count selections where order does not matter. For example, choosing 3 people from 10 for a committee is a combination C(10,3) = 120, but choosing a president, vice-president, and secretary from 10 is a permutation P(10,3) = 720. The relationship is P(n,r) = C(n,r) multiplied by r! because each combination can be arranged in r! ways."}},{"@type":"Question","name":"What are the key properties of Pascal's triangle?","acceptedAnswer":{"@type":"Answer","text":"Pascal's triangle is a triangular array where each entry equals the sum of the two entries directly above it: C(n,r) = C(n-1,r-1) + C(n-1,r). Row n contains the binomial coefficients for (a+b)^n. The triangle is symmetric: C(n,r) = C(n,n-r). Each row sums to 2^n. The diagonals contain natural numbers, triangular numbers, and tetrahedral numbers."}},{"@type":"Question","name":"When should I use permutations versus combinations?","acceptedAnswer":{"@type":"Answer","text":"Use permutations (nPr) when the order or arrangement of selected items matters, such as ranking, seating arrangements, or assigning distinct roles. Use combinations (nCr) when only the selection matters and order is irrelevant, such as choosing a team, selecting lottery numbers, or forming a committee. A helpful test: if swapping two selected items creates a different outcome, use permutations; if it does not, use combinations."}}]}
</script>

<%@ include file="viz-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-combinatorics.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('combinatorics', 'viz-canvas', {
        n: 6,
        r: 2,
        vizMode: 'pascal'
    });
    var state = VisualMath.getState();

    var presets = {
        'pascal': { vizMode: 'pascal' },
        'selection': { vizMode: 'selection' },
        'arrangement': { vizMode: 'arrangement' }
    };

    function applyPreset(key) {
        var p = presets[key];
        state.vizMode = p.vizMode;
        document.querySelectorAll('[data-preset]').forEach(function (btn) {
            btn.classList.toggle('active', btn.getAttribute('data-preset') === key);
        });
        state._redraw();
    }

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () { applyPreset(this.getAttribute('data-preset')); });
    });

    document.getElementById('n-slider').addEventListener('input', function () {
        var v = parseInt(this.value);
        state.n = v;
        document.getElementById('n-display').textContent = v;
        document.getElementById('n-val').textContent = v;

        // Clamp r to n
        var rSlider = document.getElementById('r-slider');
        rSlider.max = v;
        if (state.r > v) {
            state.r = v;
            rSlider.value = v;
            document.getElementById('r-display').textContent = v;
            document.getElementById('r-val').textContent = v;
        }
        state._redraw();
    });

    document.getElementById('r-slider').addEventListener('input', function () {
        var v = Math.min(parseInt(this.value), state.n);
        this.value = v;
        state.r = v;
        document.getElementById('r-display').textContent = v;
        document.getElementById('r-val').textContent = v;
        state._redraw();
    });
});
</script>
