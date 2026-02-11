<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Matrix Calculator 2x2 3x3 4x4 - Determinant, Inverse, Eigenvalues (Free)";
    String seoDescription = "Interactive matrix calculator for 2x2, 3x3, and 4x4 matrices. Compute determinant, inverse, trace, rank, and eigenvalues. See geometric transformations with animated basis vectors.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-math/matrix-calculator.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Matrix Calculator 2x2 3x3 4x4 - Determinant, Inverse, Eigenvalues\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Matrix Calculator 2x2 3x3 4x4\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"matrix calculator, determinant calculator, eigenvalue calculator, eigenvector, inverse matrix, 2x2 matrix, 3x3 matrix, 4x4 matrix, matrix rank, linear transformation, linear algebra, trace, cofactor expansion\">");

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
        <span class="breadcrumb-current">Matrix Calculator</span>
    </nav>

    <div class="viz-header">
        <h1>Matrix Calculator</h1>
        <p class="viz-subtitle">Compute determinant, inverse, eigenvalues, trace, and rank for 2&times;2, 3&times;3, and 4&times;4 matrices. The 2&times;2 view shows the geometric transformation of the unit square with animated basis vectors.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Matrix [A]</h3>

                <div class="control-group">
                    <label>Matrix Size</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-size="2">2&times;2</button>
                        <button class="vm-chip" data-size="3">3&times;3</button>
                        <button class="vm-chip" data-size="4">4&times;4</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>Presets</label>
                    <div id="preset-container" style="display:flex;flex-wrap:wrap;gap:6px;">
                        <!-- populated by JS -->
                    </div>
                </div>

                <div class="control-group">
                    <label>Matrix entries</label>
                    <div id="matrix-grid" style="display:grid;gap:6px;">
                        <!-- populated by JS -->
                    </div>
                </div>

                <div class="control-group" id="eigenvector-toggle">
                    <label style="display:flex;align-items:center;gap:6px;">
                        <input type="checkbox" id="input-eigenvectors" checked>
                        Show eigenvectors
                    </label>
                </div>
            </div>

            <div class="viz-values">
                <h3>Properties</h3>
                <table>
                    <tr><td>Matrix</td><td id="val-matrix">--</td></tr>
                    <tr><td>Determinant</td><td id="val-det">--</td></tr>
                    <tr><td>Trace</td><td id="val-trace">--</td></tr>
                    <tr><td>Rank</td><td id="val-rank">--</td></tr>
                    <tr><td>Inverse</td><td id="val-inverse">--</td></tr>
                    <tr><td>Eigenvalues</td><td id="val-eigenvalues">--</td></tr>
                    <tr><td>Eigenvectors</td><td id="val-eigenvectors">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Math Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Matrix Operations</h3>
                <ul>
                    <li><strong>Determinant (2&times;2)</strong>: <span class="formula-highlight">det(A) = ad &minus; bc</span></li>
                    <li><strong>Determinant (n&times;n)</strong>: Computed via <span class="formula-highlight">cofactor expansion</span> along the first row</li>
                    <li><strong>Inverse</strong>: <span class="formula-highlight">A&sup1; = (1/det) &middot; adj(A)</span> &mdash; exists only when det &ne; 0</li>
                    <li><strong>Trace</strong>: <span class="formula-highlight">tr(A) = &sum; a<sub>ii</sub></span> &mdash; sum of diagonal entries</li>
                    <li><strong>Rank</strong>: Number of non-zero rows after <span class="formula-highlight">Gaussian elimination</span></li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Eigenvalues &amp; Eigenvectors</h3>
                <ul>
                    <li><strong>Characteristic equation</strong>: <span class="formula-highlight">det(A &minus; &lambda;I) = 0</span></li>
                    <li><strong>2&times;2</strong>: Quadratic formula &mdash; <span class="formula-highlight">&lambda; = (tr &plusmn; &radic;(tr&sup2; &minus; 4&middot;det)) / 2</span></li>
                    <li><strong>3&times;3</strong>: Cubic characteristic polynomial solved via <span class="formula-highlight">Cardano&rsquo;s method</span></li>
                    <li><strong>4&times;4</strong>: <span class="formula-highlight">Faddeev&ndash;LeVerrier</span> algorithm + <span class="formula-highlight">Durand&ndash;Kerner</span> numerical root finding</li>
                    <li>Eigenvectors satisfy <span class="formula-highlight">Av = &lambda;v</span> &mdash; directions only scaled by the matrix</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-math/matrix-transform.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(59,130,246,0.12);">&#9638;</div>
                <div><h4>Matrix Transforms</h4><span>Linear Algebra</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/vectors-2d.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(59,130,246,0.12);">&rarr;</div>
                <div><h4>2D Vectors</h4><span>Linear Algebra</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#8943;</div>
                <div><h4>All Visualizations</h4><span>Browse</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{"@context":"https://schema.org","@type":"LearningResource","name":"Matrix Calculator 2x2 3x3 4x4","description":"Interactive matrix calculator for 2x2, 3x3, and 4x4 matrices. Compute determinant, inverse, trace, rank, and eigenvalues. See geometric transformations with animated basis vectors.","url":"https://8gwifi.org/exams/visual-math/matrix-calculator.jsp","educationalLevel":"High School","teaches":"Matrix operations, determinant, inverse matrix, eigenvalues, eigenvectors, trace, rank, cofactor expansion, linear transformations","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Math Lab","item":"https://8gwifi.org/exams/visual-math/"},{"@type":"ListItem","position":4,"name":"Matrix Calculator"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"What does the determinant of a matrix tell you?","acceptedAnswer":{"@type":"Answer","text":"The determinant measures how a linear transformation scales areas (2D) or volumes (3D). If det(A) = 2, the transformation doubles all areas. A negative determinant reverses orientation. A determinant of zero means the matrix is singular — it collapses space into a lower dimension and has no inverse."}},{"@type":"Question","name":"How are eigenvalues computed for larger matrices?","acceptedAnswer":{"@type":"Answer","text":"For 2\u00d72, eigenvalues come from the quadratic formula on the characteristic polynomial. For 3\u00d73, Cardano's method solves the cubic characteristic equation analytically. For 4\u00d74, the Faddeev\u2013LeVerrier algorithm extracts the characteristic polynomial coefficients, then the Durand\u2013Kerner iterative method finds all four roots numerically."}},{"@type":"Question","name":"When is a matrix invertible?","acceptedAnswer":{"@type":"Answer","text":"A matrix is invertible if and only if its determinant is not zero (equivalently, its rank equals its size). The inverse is computed as A\u207b\u00b9 = (1/det) \u00b7 adj(A), where adj(A) is the adjugate (transpose of the cofactor matrix). This works for any square matrix — 2\u00d72, 3\u00d73, or 4\u00d74."}},{"@type":"Question","name":"What is the rank of a matrix?","acceptedAnswer":{"@type":"Answer","text":"The rank of a matrix is the number of linearly independent rows (or columns). It is computed via Gaussian elimination by counting non-zero pivot rows. A matrix with rank equal to its size is full rank and invertible. A rank-deficient matrix has a non-trivial null space."}}]}
</script>

<%@ include file="viz-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-matrix-calc.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    var currentSize = 2;
    var inputStyle = 'width:100%;padding:5px 4px;border:1px solid var(--vm-border,#d1d5db);border-radius:6px;font-size:13px;text-align:center;';

    // Presets by size
    var presetsBySize = {
        2: {
            'identity':   { m00:1, m01:0, m10:0, m11:1 },
            'rotation':   { m00:0.707, m01:-0.707, m10:0.707, m11:0.707 },
            'shear':      { m00:1, m01:1, m10:0, m11:1 },
            'reflection': { m00:1, m01:0, m10:0, m11:-1 },
            'scale':      { m00:2, m01:0, m10:0, m11:0.5 },
            'custom':     { m00:2, m01:1, m10:0, m11:3 }
        },
        3: {
            'identity':   { m00:1,m01:0,m02:0, m10:0,m11:1,m12:0, m20:0,m21:0,m22:1 },
            'rotation-z': { m00:0.707,m01:-0.707,m02:0, m10:0.707,m11:0.707,m12:0, m20:0,m21:0,m22:1 },
            'scale':      { m00:2,m01:0,m02:0, m10:0,m11:3,m12:0, m20:0,m21:0,m22:0.5 },
            'symmetric':  { m00:2,m01:1,m02:0, m10:1,m11:3,m12:1, m20:0,m21:1,m22:2 },
            'singular':   { m00:1,m01:2,m02:3, m10:4,m11:5,m12:6, m20:7,m21:8,m22:9 },
            'custom':     { m00:1,m01:2,m02:0, m10:0,m11:1,m12:3, m20:2,m21:0,m22:1 }
        },
        4: {
            'identity':   { m00:1,m01:0,m02:0,m03:0, m10:0,m11:1,m12:0,m13:0, m20:0,m21:0,m22:1,m23:0, m30:0,m31:0,m32:0,m33:1 },
            'diagonal':   { m00:2,m01:0,m02:0,m03:0, m10:0,m11:3,m12:0,m13:0, m20:0,m21:0,m22:-1,m23:0, m30:0,m31:0,m32:0,m33:4 },
            'symmetric':  { m00:2,m01:1,m02:0,m03:0, m10:1,m11:3,m12:1,m13:0, m20:0,m21:1,m22:2,m23:1, m30:0,m31:0,m32:1,m33:1 },
            'custom':     { m00:1,m01:0,m02:2,m03:0, m10:0,m11:1,m12:0,m13:3, m20:1,m21:0,m22:1,m23:0, m30:0,m31:2,m32:0,m33:1 }
        }
    };

    var presetLabels = {
        'identity': 'Identity', 'rotation': 'Rotation', 'shear': 'Shear',
        'reflection': 'Reflection', 'scale': 'Scale', 'custom': 'Custom',
        'rotation-z': 'Rotation (Z)', 'symmetric': 'Symmetric',
        'singular': 'Singular', 'diagonal': 'Diagonal'
    };

    // Default matrices per size
    var defaults = {
        2: presetsBySize[2]['custom'],
        3: presetsBySize[3]['custom'],
        4: presetsBySize[4]['custom']
    };

    VisualMath.init('matrix-calc', 'viz-canvas', { m00:2, m01:1, m10:0, m11:3, size:2 });
    var state = VisualMath.getState();

    function buildPresetButtons(n) {
        var container = document.getElementById('preset-container');
        container.innerHTML = '';
        var presets = presetsBySize[n];
        Object.keys(presets).forEach(function (key) {
            var btn = document.createElement('button');
            btn.className = 'vm-chip' + (key === 'custom' ? ' active' : '');
            btn.setAttribute('data-preset', key);
            btn.textContent = presetLabels[key] || key;
            btn.addEventListener('click', function () {
                applyPreset(key);
            });
            container.appendChild(btn);
        });
    }

    function buildGrid(n) {
        var grid = document.getElementById('matrix-grid');
        grid.innerHTML = '';
        grid.style.gridTemplateColumns = 'repeat(' + n + ', 1fr)';
        var vals = defaults[n];
        for (var r = 0; r < n; r++) {
            for (var c = 0; c < n; c++) {
                var key = 'm' + r + c;
                var inp = document.createElement('input');
                inp.type = 'number';
                inp.id = 'input-' + key;
                inp.step = '0.1';
                inp.value = vals[key] !== undefined ? vals[key] : 0;
                inp.setAttribute('style', inputStyle);
                inp.addEventListener('input', (function (k) {
                    return function () {
                        var v = parseFloat(this.value);
                        if (!isNaN(v)) {
                            state[k] = v;
                            document.querySelectorAll('#preset-container [data-preset]').forEach(function (btn) { btn.classList.remove('active'); });
                            state._redraw();
                        }
                    };
                })(key));
                grid.appendChild(inp);
            }
        }
    }

    function applyPreset(key) {
        var presets = presetsBySize[currentSize];
        var p = presets[key];
        if (!p) return;
        for (var k in p) {
            state[k] = p[k];
            var inp = document.getElementById('input-' + k);
            if (inp) inp.value = p[k];
        }
        document.querySelectorAll('#preset-container [data-preset]').forEach(function (btn) {
            btn.classList.toggle('active', btn.getAttribute('data-preset') === key);
        });
        state._redraw();
    }

    function clearStateMatrix() {
        for (var r = 0; r < 4; r++) {
            for (var c = 0; c < 4; c++) {
                delete state['m' + r + c];
            }
        }
    }

    function setSize(n) {
        currentSize = n;
        clearStateMatrix();
        state.size = n;

        // Size buttons
        document.querySelectorAll('[data-size]').forEach(function (btn) {
            btn.classList.toggle('active', parseInt(btn.getAttribute('data-size')) === n);
        });

        // Eigenvector toggle only for 2x2
        document.getElementById('eigenvector-toggle').style.display = n === 2 ? '' : 'none';

        buildPresetButtons(n);
        buildGrid(n);

        // Apply default values to state
        var vals = defaults[n];
        for (var k in vals) { state[k] = vals[k]; }
        state._redraw();
    }

    // Size selector
    document.querySelectorAll('[data-size]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            setSize(parseInt(this.getAttribute('data-size')));
        });
    });

    // Eigenvector checkbox
    document.getElementById('input-eigenvectors').addEventListener('change', function () {
        state.showEigenvectors = this.checked;
        state._redraw();
    });

    // Initialize
    setSize(2);
});
</script>
