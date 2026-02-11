<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Lens & Mirror Ray Diagram Maker - Convex, Concave, Image Formation (Free)";
    String seoDescription = "Interactive lens and mirror ray diagram tool. Visualize convex lens, concave lens, concave mirror, and convex mirror image formation. Adjust object distance and focal length in real-time.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-physics/lens-ray-diagram.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Lens & Mirror Ray Diagram Maker - Image Formation\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Lens & Mirror Ray Diagram Maker\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"lens ray diagram, mirror ray diagram, convex lens, concave lens, concave mirror, convex mirror, image formation, focal length, object distance, magnification, optics simulator, physics visualizer\">");

    request.setAttribute("pageTitle", seoTitle);
    request.setAttribute("pageDescription", seoDescription);
    request.setAttribute("canonicalUrl", canonicalUrl);
    request.setAttribute("extraHeadContent", extraHead.toString());
    request.setAttribute("skipMathJax", "true");
%>
<%@ include file="../components/header.jsp" %>
<link rel="stylesheet" href="<%=request.getContextPath()%>/exams/visual-math/visual-math.css">

<div class="container">
    <!-- Breadcrumb -->
    <nav class="breadcrumb">
        <a href="<%=request.getContextPath()%>/exams/">Exams</a>
        <span class="breadcrumb-separator">/</span>
        <a href="<%=request.getContextPath()%>/exams/visual-physics/">Visual Physics</a>
        <span class="breadcrumb-separator">/</span>
        <span class="breadcrumb-current">Lens & Mirror Ray Diagram</span>
    </nav>

    <!-- Header -->
    <div class="viz-header">
        <h1>Lens & Mirror Ray Diagram</h1>
        <p class="viz-subtitle">Explore image formation by convex lenses, concave lenses, concave mirrors, and convex mirrors. Adjust object distance and focal length to see how the image changes in real-time.</p>
    </div>

    <!-- Interactive Area -->
    <div class="viz-interactive">
        <!-- Canvas -->
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <!-- Controls Panel -->
        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Optics</h3>

                <!-- Type Chips -->
                <div class="control-group">
                    <label>Type</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-type="convex-lens">Convex Lens</button>
                        <button class="vm-chip" data-type="concave-lens">Concave Lens</button>
                        <button class="vm-chip" data-type="concave-mirror">Concave Mirror</button>
                        <button class="vm-chip" data-type="convex-mirror">Convex Mirror</button>
                    </div>
                </div>

                <!-- Object Distance Slider -->
                <div class="control-group">
                    <label>Object Distance (u)</label>
                    <div class="viz-slider-row">
                        <input type="range" id="u-slider" min="5" max="60" value="30" step="1">
                        <span class="viz-slider-val" id="u-display">30</span>
                    </div>
                </div>

                <!-- Focal Length Slider -->
                <div class="control-group">
                    <label>Focal Length (f)</label>
                    <div class="viz-slider-row">
                        <input type="range" id="f-slider" min="5" max="30" value="15" step="1">
                        <span class="viz-slider-val" id="f-display">15</span>
                    </div>
                </div>

                <!-- Show/Hide Checkboxes -->
                <div class="control-group">
                    <label>Show</label>
                    <div class="viz-check-group">
                        <label class="viz-check">
                            <input type="checkbox" id="show-rays" checked>
                            Rays
                        </label>
                        <label class="viz-check">
                            <input type="checkbox" id="show-focal" checked>
                            Focal Points
                        </label>
                        <label class="viz-check">
                            <input type="checkbox" id="show-image" checked>
                            Image
                        </label>
                    </div>
                </div>

                <!-- Presets -->
                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip" data-preset="at-2f">Object at 2F</button>
                        <button class="vm-chip" data-preset="at-f">Object at F</button>
                        <button class="vm-chip" data-preset="between">Between F & Lens</button>
                        <button class="vm-chip" data-preset="infinity">Object at &infin;</button>
                    </div>
                </div>
            </div>

            <!-- Values -->
            <div class="viz-values">
                <h3>Properties</h3>
                <table>
                    <tr><td>Object Distance (u)</td><td id="val-u">&mdash;</td></tr>
                    <tr><td>Focal Length (f)</td><td id="val-f">&mdash;</td></tr>
                    <tr><td>Image Distance (v)</td><td id="val-v">&mdash;</td></tr>
                    <tr><td>Magnification (m)</td><td id="val-mag">&mdash;</td></tr>
                    <tr><td>Image Type</td><td id="val-imageType">&mdash;</td></tr>
                    <tr><td>Image Size</td><td id="val-imageSize">&mdash;</td></tr>
                </table>
            </div>
        </div>
    </div>

    <!-- Ad -->
    <%@ include file="../components/ad-leaderboard.jsp" %>

    <!-- The Math Section -->
    <section class="viz-math">
        <h2>The Math Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Lens Formula</h3>
                <ul>
                    <li>Thin lens equation: <span class="formula-highlight">1/v - 1/u = 1/f</span></li>
                    <li>For convex lens: f is positive</li>
                    <li>For concave lens: f is negative</li>
                    <li>Magnification: <span class="formula-highlight">m = v / u</span></li>
                    <li>|m| > 1 means enlarged image; |m| < 1 means diminished</li>
                </ul>

                <h3 style="margin-top: var(--space-4);">Mirror Formula</h3>
                <ul>
                    <li>Mirror equation: <span class="formula-highlight">1/v + 1/u = 1/f</span></li>
                    <li>For concave mirror: f is positive</li>
                    <li>For convex mirror: f is negative</li>
                    <li>Magnification: <span class="formula-highlight">m = -v / u</span></li>
                </ul>
            </div>

            <div class="viz-math-col">
                <h3>Sign Convention (New Cartesian)</h3>
                <ul>
                    <li>All distances are measured from the optical centre (lens) or pole (mirror)</li>
                    <li>Distances in the direction of incident light are <strong>positive</strong></li>
                    <li>Distances against the direction of incident light are <strong>negative</strong></li>
                    <li>Heights above the principal axis are <strong>positive</strong></li>
                    <li>Heights below the principal axis are <strong>negative</strong></li>
                </ul>

                <h3 style="margin-top: var(--space-4);">Image Characteristics</h3>
                <ul>
                    <li>m positive &rarr; erect (virtual) image</li>
                    <li>m negative &rarr; inverted (real) image</li>
                    <li>Real image: formed on opposite side (lens) or same side (mirror)</li>
                    <li>Virtual image: cannot be captured on a screen</li>
                </ul>
            </div>
        </div>
    </section>

    <!-- Related Visualizations -->
    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-physics/electric-field.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(239,68,68,0.12);">&#9889;</div>
                <div><h4>Electric Field</h4><span>Physics</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-physics/wave-interference.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(59,130,246,0.12);">&#8776;</div>
                <div><h4>Wave Interference</h4><span>Physics</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/trig-graphs.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(16,185,129,0.12);">&#8767;</div>
                <div><h4>Trig Graphs</h4><span>Visual Math</span></div>
            </a>
        </div>
    </section>
</div>

<!-- JSON-LD: LearningResource -->
<script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "LearningResource",
    "name": "Lens & Mirror Ray Diagram Maker",
    "description": "Interactive ray diagram tool for convex lens, concave lens, concave mirror, and convex mirror. Visualize image formation with adjustable object distance and focal length.",
    "url": "https://8gwifi.org/exams/visual-physics/lens-ray-diagram.jsp",
    "educationalLevel": "High School",
    "teaches": "Lens formula, mirror formula, image formation, magnification, convex lens, concave lens, concave mirror, convex mirror",
    "learningResourceType": "Interactive visualization",
    "interactivityType": "active",
    "publisher": { "@type": "Organization", "name": "8gwifi.org" }
}
</script>

<!-- JSON-LD: BreadcrumbList -->
<script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
        { "@type": "ListItem", "position": 1, "name": "Home", "item": "https://8gwifi.org/" },
        { "@type": "ListItem", "position": 2, "name": "Exams", "item": "https://8gwifi.org/exams/" },
        { "@type": "ListItem", "position": 3, "name": "Visual Physics", "item": "https://8gwifi.org/exams/visual-physics/" },
        { "@type": "ListItem", "position": 4, "name": "Lens & Mirror Ray Diagram" }
    ]
}
</script>

<!-- JSON-LD: FAQPage -->
<script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
        {
            "@type": "Question",
            "name": "What is the difference between a convex lens and a concave lens?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "A convex lens is thicker at the centre and converges parallel light rays to a focal point. It can form both real and virtual images depending on object position. A concave lens is thinner at the centre and diverges light rays; it always forms virtual, erect, and diminished images regardless of where the object is placed."
            }
        },
        {
            "@type": "Question",
            "name": "How do you find the image distance using the lens formula?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Use the thin lens equation 1/v - 1/u = 1/f. Rearrange to get 1/v = 1/f + 1/u, then v = 1/(1/f + 1/u). Remember to apply the sign convention: for a convex lens, f is positive and u is negative (object on the left). If v is positive, the image is real and on the opposite side; if negative, the image is virtual and on the same side as the object."
            }
        },
        {
            "@type": "Question",
            "name": "What happens when an object is placed at the focal point of a convex lens?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "When an object is placed at the focal point (u = f) of a convex lens, the refracted rays emerge parallel and never converge. The image is formed at infinity. In practice, this means no image is formed on a screen. This principle is used in spotlights and collimated beam projectors."
            }
        }
    ]
}
</script>

<%@ include file="vp-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>

<!-- p5.js + Visual Math -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-physics/js/vp-lens.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('lens-ray', 'viz-canvas', {
        lensType: 'convex-lens',
        objectDist: 30,
        focalLength: 15,
        objectHeight: 2,
        showRays: true,
        showFocal: true,
        showImage: true
    });
    var state = VisualMath.getState();

    // --- Type chips ---
    document.querySelectorAll('[data-type]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var type = this.getAttribute('data-type');
            document.querySelectorAll('[data-type]').forEach(function (b) {
                b.classList.toggle('active', b.getAttribute('data-type') === type);
            });
            state.lensType = type;
            state._redraw();
        });
    });

    // --- Object Distance slider ---
    var uSlider = document.getElementById('u-slider');
    uSlider.addEventListener('input', function () {
        var val = parseInt(this.value);
        document.getElementById('u-display').textContent = val;
        state.objectDist = val;
        state._redraw();
    });

    // --- Focal Length slider ---
    var fSlider = document.getElementById('f-slider');
    fSlider.addEventListener('input', function () {
        var val = parseInt(this.value);
        document.getElementById('f-display').textContent = val;
        state.focalLength = val;
        state._redraw();
    });

    // --- Show checkboxes ---
    document.getElementById('show-rays').addEventListener('change', function () {
        state.showRays = this.checked;
        state._redraw();
    });
    document.getElementById('show-focal').addEventListener('change', function () {
        state.showFocal = this.checked;
        state._redraw();
    });
    document.getElementById('show-image').addEventListener('change', function () {
        state.showImage = this.checked;
        state._redraw();
    });

    // --- Presets ---
    var presets = {
        'at-2f':    { u: 30, f: 15 },
        'at-f':     { u: 15, f: 15 },
        'between':  { u: 10, f: 15 },
        'infinity': { u: 60, f: 15 }
    };

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var key = this.getAttribute('data-preset');
            var p = presets[key];

            document.querySelectorAll('[data-preset]').forEach(function (b) {
                b.classList.toggle('active', b.getAttribute('data-preset') === key);
            });

            uSlider.value = p.u;
            fSlider.value = p.f;
            document.getElementById('u-display').textContent = p.u;
            document.getElementById('f-display').textContent = p.f;

            state.objectDist = p.u;
            state.focalLength = p.f;
            state._redraw();
        });
    });
});
</script>
