<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Venn Diagram Maker - Union, Intersection, Difference (Free)";
    String seoDescription = "Interactive Venn diagram tool. Visualize set union, intersection, difference, symmetric difference, and complement. Drag circles, enter set elements, see results instantly.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-math/venn-diagram.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Venn Diagram Maker - Union, Intersection, Difference\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Venn Diagram Maker\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"venn diagram maker, set operations, union intersection, set theory, venn diagram calculator, set difference, symmetric difference, complement, discrete math\">");

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
        <span class="breadcrumb-current">Venn Diagram</span>
    </nav>

    <div class="viz-header">
        <h1>Venn Diagram Maker</h1>
        <p class="viz-subtitle">Visualize set union, intersection, difference, symmetric difference, and complement. Enter set elements and drag circles to reposition.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Set Operations</h3>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-preset="union">Union</button>
                        <button class="vm-chip" data-preset="intersection">Intersection</button>
                        <button class="vm-chip" data-preset="diffAB">A\B</button>
                        <button class="vm-chip" data-preset="diffBA">B\A</button>
                        <button class="vm-chip" data-preset="symmetric">Symmetric</button>
                        <button class="vm-chip" data-preset="complement">Complement</button>
                    </div>
                </div>

                <div class="control-group">
                    <label for="input-setA">Set A (comma-separated)</label>
                    <input type="text" id="input-setA" value="1,2,3,4,5" style="width:100%;padding:6px 8px;border:1px solid var(--vm-border,#d1d5db);border-radius:6px;font-size:14px;">
                </div>

                <div class="control-group">
                    <label for="input-setB">Set B (comma-separated)</label>
                    <input type="text" id="input-setB" value="3,4,5,6,7" style="width:100%;padding:6px 8px;border:1px solid var(--vm-border,#d1d5db);border-radius:6px;font-size:14px;">
                </div>

                <p style="font-size:12px;color:#6b7280;margin-top:4px;">Drag circle centers to reposition</p>
            </div>

            <div class="viz-values">
                <h3>Properties</h3>
                <table>
                    <tr><td>Set A</td><td id="val-setA">--</td></tr>
                    <tr><td>Set B</td><td id="val-setB">--</td></tr>
                    <tr><td>|A|</td><td id="val-sizeA">--</td></tr>
                    <tr><td>|B|</td><td id="val-sizeB">--</td></tr>
                    <tr><td>Operation</td><td id="val-operation">--</td></tr>
                    <tr><td>Result</td><td id="val-result">--</td></tr>
                    <tr><td>|Result|</td><td id="val-result-size">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Math Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Set Operations</h3>
                <ul>
                    <li><strong>Union</strong>: <span class="formula-highlight">A &cup; B</span> &mdash; all elements in A or B (or both)</li>
                    <li><strong>Intersection</strong>: <span class="formula-highlight">A &cap; B</span> &mdash; elements in both A and B</li>
                    <li><strong>Difference</strong>: <span class="formula-highlight">A \ B</span> &mdash; elements in A but not in B</li>
                    <li><strong>Symmetric Difference</strong>: <span class="formula-highlight">A &Delta; B</span> &mdash; elements in A or B but not both</li>
                    <li><strong>Complement</strong>: <span class="formula-highlight">A&prime;</span> &mdash; elements in the universal set not in A</li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Properties</h3>
                <ul>
                    <li><strong>Commutative</strong>: <span class="formula-highlight">A &cup; B = B &cup; A</span> and <span class="formula-highlight">A &cap; B = B &cap; A</span></li>
                    <li><strong>Associative</strong>: <span class="formula-highlight">(A &cup; B) &cup; C = A &cup; (B &cup; C)</span></li>
                    <li><strong>Distributive</strong>: <span class="formula-highlight">A &cap; (B &cup; C) = (A &cap; B) &cup; (A &cap; C)</span></li>
                    <li><strong>De Morgan&rsquo;s Laws</strong>: <span class="formula-highlight">(A &cup; B)&prime; = A&prime; &cap; B&prime;</span> and <span class="formula-highlight">(A &cap; B)&prime; = A&prime; &cup; B&prime;</span></li>
                    <li><strong>Cardinality</strong>: <span class="formula-highlight">|A &cup; B| = |A| + |B| &minus; |A &cap; B|</span></li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-math/permutations-combinations.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(249,115,22,0.12);">&#8450;</div>
                <div><h4>Permutations &amp; Combinations</h4><span>Probability</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/probability-distributions.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(147,51,234,0.12);">&#119977;</div>
                <div><h4>Probability Distributions</h4><span>Statistics</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#8943;</div>
                <div><h4>All Visualizations</h4><span>Browse</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{"@context":"https://schema.org","@type":"LearningResource","name":"Venn Diagram Maker","description":"Interactive Venn diagram tool. Visualize set union, intersection, difference, symmetric difference, and complement. Drag circles, enter set elements, see results instantly.","url":"https://8gwifi.org/exams/visual-math/venn-diagram.jsp","educationalLevel":"High School","teaches":"Set theory, Venn diagrams, union, intersection, set difference, symmetric difference, complement, De Morgan's laws","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Math Lab","item":"https://8gwifi.org/exams/visual-math/"},{"@type":"ListItem","position":4,"name":"Venn Diagram"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"What is a Venn diagram used for?","acceptedAnswer":{"@type":"Answer","text":"A Venn diagram uses overlapping circles to show the relationships between sets. The overlapping region represents elements common to both sets (the intersection), while the total area of both circles represents the union. Venn diagrams are widely used in probability, logic, statistics, and computer science to visualize set operations and logical relationships."}},{"@type":"Question","name":"What is the difference between union and intersection?","acceptedAnswer":{"@type":"Answer","text":"Union (A \u222a B) includes all elements that are in set A, set B, or both. Intersection (A \u2229 B) includes only the elements that are in both sets simultaneously. For example, if A = {1,2,3} and B = {2,3,4}, then A \u222a B = {1,2,3,4} and A \u2229 B = {2,3}."}},{"@type":"Question","name":"What is symmetric difference?","acceptedAnswer":{"@type":"Answer","text":"The symmetric difference (A \u25b3 B) contains elements that are in either A or B, but not in both. It equals (A \u222a B) minus (A \u2229 B). For example, if A = {1,2,3} and B = {2,3,4}, then A \u25b3 B = {1,4}. It can also be expressed as (A \\ B) \u222a (B \\ A)."}}]}
</script>

<%@ include file="viz-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-venn.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('venn', 'viz-canvas', {});
    var state = VisualMath.getState();

    var presets = {
        'union':        { operation: 'union' },
        'intersection': { operation: 'intersection' },
        'diffAB':       { operation: 'differenceAB' },
        'diffBA':       { operation: 'differenceBA' },
        'symmetric':    { operation: 'symmetric' },
        'complement':   { operation: 'complement' }
    };

    function applyPreset(key) {
        var p = presets[key];
        state.operation = p.operation;

        document.querySelectorAll('[data-preset]').forEach(function (btn) {
            btn.classList.toggle('active', btn.getAttribute('data-preset') === key);
        });
        state._redraw();
    }

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () { applyPreset(this.getAttribute('data-preset')); });
    });

    function parseSet(str) {
        return str.split(',').map(function (s) { return parseInt(s.trim()); }).filter(function (n) { return !isNaN(n); });
    }

    document.getElementById('input-setA').addEventListener('input', function () {
        state.setA = parseSet(this.value);
        state._redraw();
    });

    document.getElementById('input-setB').addEventListener('input', function () {
        state.setB = parseSet(this.value);
        state._redraw();
    });
});
</script>
