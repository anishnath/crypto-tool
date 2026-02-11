<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Matrix Transformation Visualizer - 2x2 Matrix Calculator with Graphs (Free)";
    String seoDescription = "Free 2x2 matrix transformation visualizer. See rotation, shear, scaling, reflection live on a grid. Animated basis vectors, determinant display, and 8 presets.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-math/matrix-transform.jsp";

    StringBuilder extraHead=new StringBuilder();
        extraHead.append("<meta property=\"og:title\" content=\"Matrix Transformation Visualizer - 2x2 Calculator\">");
    extraHead.append("<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("<meta property=\"og:type\" content=\"website\">");
    extraHead.append("<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("<meta name=\"twitter:title\" content=\"2x2 Matrix Transformation Visualizer\">");
    extraHead.append("<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("<meta name=\"keywords\" content=\"matrix transformation, 2x2 matrix calculator, linear transformation visualizer, matrix rotation, matrix shear, determinant calculator, basis vectors, linear algebra visualization\">");

    request.setAttribute("pageTitle", seoTitle);
    request.setAttribute("pageDescription", seoDescription);
    request.setAttribute("canonicalUrl", canonicalUrl);
    request.setAttribute("extraHeadContent", extraHead.toString());
    request.setAttribute("skipMathJax", "true");
%>
<%@ include file="../components/header.jsp" %>
<link rel="stylesheet" href="<%=request.getContextPath()%>/exams/visual-math/visual-math.css">

<style>
    .matrix-input {
        display: inline-grid;
        grid-template-columns: 1fr 1fr;
        gap: 6px;
        padding: 8px;
        background: var(--bg-secondary);
        border-radius: var(--radius-md);
        margin-bottom: var(--space-2);
    }
    .matrix-input input {
        width: 60px;
        padding: 6px 8px;
        text-align: center;
        border: 1px solid var(--border-primary);
        border-radius: var(--radius-sm);
        background: var(--bg-primary);
        color: var(--text-primary);
        font-family: 'JetBrains Mono', monospace;
        font-size: var(--text-sm);
    }
    .matrix-input input:focus {
        border-color: var(--accent-primary, #6366f1);
        outline: none;
    }
    .preset-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 4px;
    }
    .preset-btn {
        padding: 6px 8px;
        border: 1px solid var(--border-primary);
        border-radius: var(--radius-sm);
        background: var(--bg-secondary);
        color: var(--text-primary);
        font-size: var(--text-xs);
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s;
    }
    .preset-btn:hover {
        border-color: var(--accent-primary, #6366f1);
        background: rgba(99,102,241,0.1);
    }
</style>

<div class="container">
    <nav class="breadcrumb">
        <a href="<%=request.getContextPath()%>/exams/">Exams</a>
        <span class="breadcrumb-separator">/</span>
        <a href="<%=request.getContextPath()%>/exams/visual-math/">Visual Math</a>
        <span class="breadcrumb-separator">/</span>
        <span class="breadcrumb-current">Matrix Transformer</span>
    </nav>

    <div class="viz-header">
        <h1>Matrix Transformer</h1>
        <p class="viz-subtitle">Enter a 2&times;2 matrix or pick a preset. Watch the unit square transform with animated basis vectors and a warped grid.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Matrix</h3>

                <div class="control-group">
                    <label>A =</label>
                    <div class="matrix-input">
                        <input type="number" id="mat-a" value="1" step="0.1">
                        <input type="number" id="mat-b" value="0" step="0.1">
                        <input type="number" id="mat-c" value="0" step="0.1">
                        <input type="number" id="mat-d" value="1" step="0.1">
                    </div>
                </div>

                <div class="control-group">
                    <label>Presets</label>
                    <div class="preset-grid">
                        <button class="preset-btn" data-m="0.71,-0.71,0.71,0.71">Rotate 45&deg;</button>
                        <button class="preset-btn" data-m="-1,0,0,1">Reflect Y</button>
                        <button class="preset-btn" data-m="1,0.5,0,1">Shear X</button>
                        <button class="preset-btn" data-m="2,0,0,2">Scale 2&times;</button>
                        <button class="preset-btn" data-m="0,1,1,0">Swap XY</button>
                        <button class="preset-btn" data-m="1,0,0,-1">Reflect X</button>
                        <button class="preset-btn" data-m="0.5,0,0,0.5">Scale &frac12;</button>
                        <button class="preset-btn" data-m="1,0,0,1">Identity</button>
                    </div>
                </div>
            </div>

            <div class="viz-values">
                <h3>Properties</h3>
                <table>
                    <tr><td>det(A)</td><td id="val-det">1.0000</td></tr>
                    <tr><td></td><td id="val-det-meaning" style="font-family:inherit;font-size:var(--text-xs);color:var(--text-muted);">Preserves orientation</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Math Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Linear Transformation</h3>
                <ul>
                    <li>A 2&times;2 matrix maps every point (x,y) to a new point (x',y')</li>
                    <li><span class="formula-highlight">x' = ax + by, y' = cx + dy</span></li>
                    <li>Columns of the matrix are the images of the basis vectors <strong>e&#8321;</strong> and <strong>e&#8322;</strong></li>
                    <li>The red arrow shows where (1,0) lands; blue shows where (0,1) lands</li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Determinant</h3>
                <ul>
                    <li><span class="formula-highlight">det(A) = ad - bc</span></li>
                    <li>|det| = area scale factor of the transformation</li>
                    <li>det &gt; 0: orientation preserved</li>
                    <li>det &lt; 0: orientation flipped (mirror)</li>
                    <li>det = 0: transformation collapses to a line or point</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-math/vectors-2d.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(59,130,246,0.12);">&rarr;</div>
                <div><h4>2D Vectors</h4><span>Linear Algebra</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/matrix-calculator.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(59,130,246,0.12);">&#9638;</div>
                <div><h4>Matrix Calculator</h4><span>Linear Algebra</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#8943;</div>
                <div><h4>All Visualizations</h4><span>Browse</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "LearningResource",
    "name": "Matrix Transformation Visualizer",
    "description": "Interactive 2x2 matrix transformation visualizer with basis vectors, determinant, and animated presets.",
    "url": "https://8gwifi.org/exams/visual-math/matrix-transform.jsp",
    "educationalLevel": "High School",
    "teaches": "2D linear transformations and matrix multiplication",
    "learningResourceType": "Interactive visualization",
    "publisher": { "@type": "Organization", "name": "8gwifi.org" }
}
</script>
<script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
        { "@type": "ListItem", "position": 1, "name": "Home", "item": "https://8gwifi.org/" },
        { "@type": "ListItem", "position": 2, "name": "Exams", "item": "https://8gwifi.org/exams/" },
        { "@type": "ListItem", "position": 3, "name": "Visual Math Lab", "item": "https://8gwifi.org/exams/visual-math/" },
        { "@type": "ListItem", "position": 4, "name": "Matrix Transformer" }
    ]
}
</script>
<script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
        {
            "@type": "Question",
            "name": "What is a matrix transformation?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "A matrix transformation maps every point (x,y) to a new point using a 2x2 matrix. It can represent rotation, scaling, shearing, and reflection — all fundamental operations in linear algebra and computer graphics."
            }
        },
        {
            "@type": "Question",
            "name": "What does the determinant of a 2x2 matrix tell you?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The determinant (ad - bc) tells you how the matrix scales area. |det| is the area scale factor. A positive determinant preserves orientation, negative flips it (mirror), and zero means the transformation collapses space to a line or point."
            }
        },
        {
            "@type": "Question",
            "name": "How do basis vectors work in matrix transformations?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The columns of a 2x2 matrix are where the basis vectors e₁=(1,0) and e₂=(0,1) land after the transformation. This means you can read a matrix's effect directly from its columns."
            }
        }
    ]
}
</script>

<%@ include file="viz-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>

<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-matrix.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    VisualMath.init('matrix-transform', 'viz-canvas', { m: [1, 0, 0, 1] });

    var ids = ['mat-a','mat-b','mat-c','mat-d'];

    function readMatrix() {
        return ids.map(function(id) { return parseFloat(document.getElementById(id).value) || 0; });
    }

    // Matrix inputs
    ids.forEach(function(id) {
        document.getElementById(id).addEventListener('input', function() {
            VisualMath.getState().m = readMatrix();
            VisualMath.getState()._redraw();
        });
    });

    // Preset buttons
    document.querySelectorAll('.preset-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var vals = this.getAttribute('data-m').split(',').map(Number);
            VisualMath.getState()._animateTo(vals);
        });
    });
});
</script>
