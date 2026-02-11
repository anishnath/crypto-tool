<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Regression & Scatter Plot - Least Squares, R-Squared (Free)";
    String seoDescription = "Interactive scatter plot with linear and quadratic regression. Visualize least squares fit, R-squared, correlation coefficient, and residuals. Drag points to explore how data affects the best fit line.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-math/regression-scatter.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Regression & Scatter Plot - Least Squares, R-Squared\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Regression & Scatter Plot\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"linear regression, scatter plot, least squares, R squared, correlation coefficient, residual, best fit line, regression analysis\">");

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
        <span class="breadcrumb-current">Regression &amp; Scatter Plot</span>
    </nav>

    <div class="viz-header">
        <h1>Regression &amp; Scatter Plot</h1>
        <p class="viz-subtitle">Fit a line or curve to data using least squares. See R&sup2;, correlation coefficient, and residuals update in real time. Drag points to explore how data shape affects the fit.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Regression</h3>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-preset="linear">Linear Fit</button>
                        <button class="vm-chip" data-preset="quadratic">Quadratic</button>
                        <button class="vm-chip" data-preset="noisy">Noisy</button>
                        <button class="vm-chip" data-preset="negative">Negative Correlation</button>
                        <button class="vm-chip" data-preset="none">No Correlation</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>Regression Type</label>
                    <div style="display:flex;gap:12px;">
                        <label><input type="radio" name="reg-type" value="linear" checked> Linear</label>
                        <label><input type="radio" name="reg-type" value="quadratic"> Quadratic</label>
                    </div>
                </div>

                <div class="control-group">
                    <label><input type="checkbox" id="show-line-cb" checked> Show regression line</label>
                </div>

                <div class="control-group">
                    <label><input type="checkbox" id="show-residuals-cb"> Show residuals</label>
                </div>

                <div class="control-group">
                    <p class="viz-note">Drag points to change the data</p>
                </div>

                <div class="viz-btn-row">
                    <button class="viz-btn viz-btn-secondary" id="reset-btn">Reset</button>
                </div>
            </div>

            <div class="viz-values">
                <h3>Properties</h3>
                <table>
                    <tr><td>n (points)</td><td id="val-n">--</td></tr>
                    <tr><td>Equation</td><td id="val-equation">--</td></tr>
                    <tr><td>Slope</td><td id="val-slope">--</td></tr>
                    <tr><td>Intercept</td><td id="val-intercept">--</td></tr>
                    <tr><td>R&sup2;</td><td id="val-r2">--</td></tr>
                    <tr><td>r</td><td id="val-r">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Math Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Least Squares</h3>
                <ul>
                    <li>Goal: minimize the <span class="formula-highlight">sum of squared residuals</span> &mdash; &Sigma;(y<sub>i</sub> &minus; &ycirc;<sub>i</sub>)&sup2;</li>
                    <li>Slope: <span class="formula-highlight">m = &Sigma;(x<sub>i</sub> &minus; x&#772;)(y<sub>i</sub> &minus; y&#772;) / &Sigma;(x<sub>i</sub> &minus; x&#772;)&sup2;</span></li>
                    <li>Intercept: <span class="formula-highlight">b = y&#772; &minus; m&middot;x&#772;</span></li>
                    <li>The least squares line passes through (x&#772;, y&#772;)</li>
                    <li>Quadratic fit solves a 3&times;3 normal equation system</li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Goodness of Fit</h3>
                <ul>
                    <li><strong>R&sup2;</strong> = 1 &minus; SS<sub>res</sub>/SS<sub>tot</sub> &mdash; proportion of variance explained</li>
                    <li><span class="formula-highlight">R&sup2; = 1</span> means a perfect fit; <span class="formula-highlight">R&sup2; = 0</span> means no linear relationship</li>
                    <li>Correlation coefficient: <span class="formula-highlight">r = &plusmn;&radic;R&sup2;</span> &mdash; sign matches the slope</li>
                    <li><strong>Residual</strong> = observed &minus; predicted &mdash; vertical distance from point to line</li>
                    <li>Residuals should be randomly scattered for a good fit</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-math/statistics-dashboard.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(147,51,234,0.12);">&#9636;</div>
                <div><h4>Statistics Dashboard</h4><span>Statistics</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/normal-distribution.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(147,51,234,0.12);">&#119977;</div>
                <div><h4>Normal Distribution</h4><span>Statistics</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#8943;</div>
                <div><h4>All Visualizations</h4><span>Browse</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{"@context":"https://schema.org","@type":"LearningResource","name":"Regression & Scatter Plot","description":"Interactive scatter plot with linear and quadratic regression. Visualize least squares fit, R-squared, correlation coefficient, and residuals in real time.","url":"https://8gwifi.org/exams/visual-math/regression-scatter.jsp","educationalLevel":"High School","teaches":"Linear regression, scatter plots, least squares method, R-squared, correlation coefficient, residuals, best fit line","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Math Lab","item":"https://8gwifi.org/exams/visual-math/"},{"@type":"ListItem","position":4,"name":"Regression & Scatter Plot"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"What does R-squared measure?","acceptedAnswer":{"@type":"Answer","text":"R-squared (R\u00b2) measures how well the regression line fits the data. It represents the proportion of variance in the dependent variable that is explained by the independent variable. R\u00b2 = 1 means a perfect fit (all points lie on the line), while R\u00b2 = 0 means the model explains none of the variance. For example, R\u00b2 = 0.85 means 85% of the data's variability is captured by the regression."}},{"@type":"Question","name":"What is the least squares method?","acceptedAnswer":{"@type":"Answer","text":"The least squares method finds the line (or curve) that minimizes the sum of squared residuals \u2014 the squared vertical distances between each data point and the fitted line. For a line y = mx + b, it calculates the slope m = \u03a3(x\u1d62 - x\u0304)(y\u1d62 - \u0233) / \u03a3(x\u1d62 - x\u0304)\u00b2 and intercept b = \u0233 - m\u00b7x\u0304. Squaring ensures positive and negative errors don't cancel out, and it penalizes large errors more heavily."}},{"@type":"Question","name":"How to interpret the correlation coefficient?","acceptedAnswer":{"@type":"Answer","text":"The correlation coefficient r ranges from -1 to +1. A value of r = +1 means a perfect positive linear relationship (both variables increase together). r = -1 means a perfect negative linear relationship (one increases as the other decreases). r = 0 means no linear relationship. Values near \u00b10.7-1.0 indicate strong correlation, \u00b10.4-0.7 moderate, and \u00b10-0.4 weak. Note that correlation does not imply causation."}}]}
</script>

<%@ include file="viz-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-regression.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    var defaultPoints = [{x:1,y:2.1},{x:2,y:3.8},{x:3,y:5.2},{x:4,y:6.5},{x:5,y:8.1},{x:6,y:9.8},{x:7,y:11.5},{x:8,y:12.9},{x:9,y:14.2},{x:10,y:16.1}];

    VisualMath.init('regression', 'viz-canvas', {
        points: JSON.parse(JSON.stringify(defaultPoints)),
        regType: 'linear',
        showLine: true,
        showResiduals: false
    });
    var state = VisualMath.getState();

    var presets = {
        'linear': {
            regType: 'linear', showLine: true, showResiduals: false,
            points: [{x:1,y:2.1},{x:2,y:3.8},{x:3,y:5.2},{x:4,y:6.5},{x:5,y:8.1},{x:6,y:9.8},{x:7,y:11.5},{x:8,y:12.9},{x:9,y:14.2},{x:10,y:16.1}]
        },
        'quadratic': {
            regType: 'quadratic', showLine: true, showResiduals: false,
            points: [{x:0,y:1},{x:1,y:2.5},{x:2,y:6},{x:3,y:11.5},{x:4,y:19},{x:5,y:28.5},{x:6,y:40},{x:7,y:53.5},{x:8,y:69}]
        },
        'noisy': {
            regType: 'linear', showLine: true, showResiduals: true,
            points: [{x:1,y:3},{x:2,y:5},{x:3,y:4},{x:4,y:7},{x:5,y:6},{x:6,y:9},{x:7,y:8},{x:8,y:11},{x:9,y:10},{x:10,y:13}]
        },
        'negative': {
            regType: 'linear', showLine: true, showResiduals: false,
            points: [{x:1,y:15},{x:2,y:13},{x:3,y:12},{x:4,y:10},{x:5,y:9},{x:6,y:7},{x:7,y:5},{x:8,y:4},{x:9,y:2},{x:10,y:1}]
        },
        'none': {
            regType: 'linear', showLine: true, showResiduals: false,
            points: [{x:1,y:5},{x:2,y:12},{x:3,y:3},{x:4,y:10},{x:5,y:7},{x:6,y:8},{x:7,y:4},{x:8,y:11},{x:9,y:6},{x:10,y:9}]
        }
    };

    function applyPreset(key) {
        var p = presets[key];
        state.regType = p.regType;
        state.showLine = p.showLine;
        state.showResiduals = p.showResiduals;
        state.points = JSON.parse(JSON.stringify(p.points));

        // Sync radio buttons
        document.querySelectorAll('input[name="reg-type"]').forEach(function (r) {
            r.checked = (r.value === p.regType);
        });
        document.getElementById('show-line-cb').checked = p.showLine;
        document.getElementById('show-residuals-cb').checked = p.showResiduals;

        document.querySelectorAll('[data-preset]').forEach(function (btn) {
            btn.classList.toggle('active', btn.getAttribute('data-preset') === key);
        });
        state._redraw();
    }

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () { applyPreset(this.getAttribute('data-preset')); });
    });

    document.querySelectorAll('input[name="reg-type"]').forEach(function (radio) {
        radio.addEventListener('change', function () {
            state.regType = this.value;
            document.querySelectorAll('[data-preset]').forEach(function (btn) { btn.classList.remove('active'); });
            state._redraw();
        });
    });

    document.getElementById('show-line-cb').addEventListener('change', function () {
        state.showLine = this.checked;
        state._redraw();
    });

    document.getElementById('show-residuals-cb').addEventListener('change', function () {
        state.showResiduals = this.checked;
        state._redraw();
    });

    document.getElementById('reset-btn').addEventListener('click', function () {
        applyPreset('linear');
    });
});
</script>
