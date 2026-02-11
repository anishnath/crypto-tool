<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% String seoTitle="Interactive Math Visualizations - Algebra, Trig, Calculus, Statistics, 3D Shapes (Free)" ;
        String
        seoDescription="Free interactive math tools: Venn diagrams, matrix calculator, integration explorer, permutations & combinations, parametric curves, slope fields, limits, distributions, regression, fractals. 35 visualizations to build intuition."
        ; String canonicalUrl="https://8gwifi.org/exams/visual-math/" ; StringBuilder extraHead=new StringBuilder();
        extraHead.append("<meta property=\"og:title\" content=\"Visual Math Lab - Free Interactive Visualizations\">");
        extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
        extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
        extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
        extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
        extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
        extraHead.append("\n<meta name=\"twitter:title\" content=\"Visual Math Lab - Interactive Math Tools\">");
        extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
        extraHead.append("\n<meta name=\"keywords\" content=\"linear equation grapher, systems of equations solver, polynomial roots explorer, exponential logarithm graph, pythagorean theorem calculator, circle theorems, unit circle calculator, riemann sum calculator, matrix transformation visualizer, taylor series calculator, function plotter, central limit theorem simulator, normal distribution calculator, derivative visualizer, quadratic equation grapher, parametric curves, probability distributions, limits continuity, slope fields ODE, regression scatter plot, fractal explorer, venn diagram maker, matrix calculator eigenvalues, integral calculator, permutations combinations calculator, interactive math, math visualization, online math tools\">");

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
                    <span class="breadcrumb-current">Visual Math Lab</span>
                </nav>

                <!-- Hero -->
                <section class="vm-hero">
                    <h1>Visual Math Lab</h1>
                    <p>Interactive visualizations to build mathematical intuition. Drag, explore, and discover.</p>
                </section>

                <!-- Ad -->
                <%@ include file="../components/ad-leaderboard.jsp" %>

                    <!-- Filters -->
                    <div class="vm-filters">
                        <button class="vm-chip active" data-filter="all">All</button>
                        <button class="vm-chip" data-filter="trig">Trigonometry</button>
                        <button class="vm-chip" data-filter="calc">Calculus</button>
                        <button class="vm-chip" data-filter="linalg">Linear Algebra</button>
                        <button class="vm-chip" data-filter="algebra">Algebra</button>
                        <button class="vm-chip" data-filter="prob">Probability</button>
                        <button class="vm-chip" data-filter="geometry">Geometry</button>
                        <button class="vm-chip" data-filter="stat">Statistics</button>
                        <button class="vm-chip" data-filter="3d-geom">3D Geometry</button>
                    </div>

                    <!-- Card Grid -->
                    <div class="vm-grid" id="viz-grid">

                        <!-- 1. Unit Circle - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/unit-circle.jsp" class="vm-card"
                            data-category="trig">
                            <div class="vm-card-preview" id="preview-unit-circle"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag trig">Trigonometry</span>
                                <h3>Unit Circle Explorer</h3>
                                <p class="vm-card-desc">Drag a point around the circle. See sin, cos, and tan come alive
                                    with synchronized wave graphs.</p>
                            </div>
                        </a>

                        <!-- 2. Riemann Sums - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/riemann-sum.jsp" class="vm-card"
                            data-category="calc">
                            <div class="vm-card-preview" id="preview-riemann"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag calc">Calculus</span>
                                <h3>Riemann Sum Explorer</h3>
                                <p class="vm-card-desc">Watch rectangles approximate the area under a curve. Adjust the
                                    count and see convergence in real-time.</p>
                            </div>
                        </a>

                        <!-- 3. Matrix Transform - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/matrix-transform.jsp" class="vm-card"
                            data-category="linalg">
                            <div class="vm-card-preview" id="preview-matrix"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag linalg">Linear Algebra</span>
                                <h3>Matrix Transformer</h3>
                                <p class="vm-card-desc">Apply 2x2 matrices to shapes. See rotation, shear, scaling, and
                                    reflection happen live.</p>
                            </div>
                        </a>

                        <!-- 4. Taylor Series - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/taylor-series.jsp" class="vm-card"
                            data-category="calc">
                            <div class="vm-card-preview" id="preview-taylor"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag calc">Calculus</span>
                                <h3>Taylor Series Builder</h3>
                                <p class="vm-card-desc">Add terms one by one. Watch the polynomial approximate sin, cos,
                                    and e^x.</p>
                            </div>
                        </a>

                        <!-- 5. Function Plotter - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/function-plotter.jsp" class="vm-card"
                            data-category="algebra">
                            <div class="vm-card-preview" id="preview-function"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag algebra">Algebra</span>
                                <h3>Function Plotter</h3>
                                <p class="vm-card-desc">Type any function, see it graphed live. Plot up to 3 functions
                                    with hover crosshair.</p>
                            </div>
                        </a>

                        <!-- 6. Central Limit Theorem - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/central-limit-theorem.jsp"
                            class="vm-card" data-category="prob">
                            <div class="vm-card-preview" id="preview-clt"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag prob">Probability</span>
                                <h3>Central Limit Theorem</h3>
                                <p class="vm-card-desc">Roll dice, draw from any distribution. Watch the sample mean
                                    become normal.</p>
                            </div>
                        </a>

                        <!-- 7. Normal Distribution - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/normal-distribution.jsp"
                            class="vm-card" data-category="prob">
                            <div class="vm-card-preview" id="preview-normal"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag prob">Probability</span>
                                <h3>Normal Distribution</h3>
                                <p class="vm-card-desc">Calculate z-scores, shade areas, and find probabilities under
                                    the bell curve with adjustable mean and standard deviation.</p>
                            </div>
                        </a>

                        <!-- 8. Derivative Visualizer - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/derivative.jsp" class="vm-card"
                            data-category="calc">
                            <div class="vm-card-preview" id="preview-derivative"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag calc">Calculus</span>
                                <h3>Derivative Visualizer</h3>
                                <p class="vm-card-desc">Move a point along any curve. See the tangent line, slope value,
                                    and optional f'(x) curve update live.</p>
                            </div>
                        </a>

                        <!-- 9. Quadratic Explorer - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/quadratic.jsp" class="vm-card"
                            data-category="algebra">
                            <div class="vm-card-preview" id="preview-quadratic"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag algebra">Algebra</span>
                                <h3>Quadratic Explorer</h3>
                                <p class="vm-card-desc">Adjust a, b, c and watch the parabola reshape. See vertex,
                                    roots, discriminant, and vertex form live.</p>
                            </div>
                        </a>

                        <!-- 10. Pythagorean Theorem - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/pythagorean-theorem.jsp"
                            class="vm-card" data-category="geometry">
                            <div class="vm-card-preview" id="preview-pythagorean"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag geometry">Geometry</span>
                                <h3>Pythagorean Theorem</h3>
                                <p class="vm-card-desc">Drag triangle vertices to explore a²+b²=c². Watch squares on
                                    each side prove the theorem visually.</p>
                            </div>
                        </a>

                        <!-- 11. Circle Theorems - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/circle-theorems.jsp" class="vm-card"
                            data-category="geometry">
                            <div class="vm-card-preview" id="preview-circle-theorems"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag geometry">Geometry</span>
                                <h3>Circle Theorems</h3>
                                <p class="vm-card-desc">Explore inscribed angles, central angles, tangents, and cyclic
                                    quadrilaterals. Drag points to see theorems in action.</p>
                            </div>
                        </a>

                        <!-- 12. Trig Graphs - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/trig-graphs.jsp" class="vm-card"
                            data-category="trig">
                            <div class="vm-card-preview" id="preview-trig-graphs"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag trig">Trigonometry</span>
                                <h3>Trig Graphs</h3>
                                <p class="vm-card-desc">Visualize sin, cos, tan with adjustable amplitude, frequency,
                                    phase shift. See transformations in real-time.</p>
                            </div>
                        </a>

                        <!-- 13. Triangle Solver - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/triangle-solver.jsp" class="vm-card"
                            data-category="trig">
                            <div class="vm-card-preview" id="preview-triangle-solver"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag trig">Trigonometry</span>
                                <h3>Triangle Solver</h3>
                                <p class="vm-card-desc">Solve any triangle using law of sines and cosines. Enter 3
                                    values (SSS, SAS, ASA, AAS) and calculate all sides and angles.</p>
                            </div>
                        </a>

                        <!-- 14. Statistics Dashboard - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/statistics-dashboard.jsp"
                            class="vm-card" data-category="stat">
                            <div class="vm-card-preview" id="preview-statistics"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag stat">Statistics</span>
                                <h3>Statistics Dashboard</h3>
                                <p class="vm-card-desc">Create box plots and histograms. Calculate quartiles, median,
                                    mean, IQR, and identify outliers from your data.</p>
                            </div>
                        </a>

                        <!-- 15. 3D Shapes - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/3d-shapes.jsp" class="vm-card"
                            data-category="3d-geom">
                            <div class="vm-card-preview" id="preview-3d-shapes"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag 3d-geom">3D Geometry</span>
                                <h3>3D Shape Calculator</h3>
                                <p class="vm-card-desc">Calculate volume and surface area of 11 shapes including cube, sphere, torus, tetrahedron. Interactive 3D with rotation.</p>
                            </div>
                        </a>

                        <!-- 16. Linear Equation - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/linear-equation.jsp" class="vm-card"
                            data-category="algebra">
                            <div class="vm-card-preview" id="preview-linear"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag algebra">Algebra</span>
                                <h3>Linear Equation Explorer</h3>
                                <p class="vm-card-desc">Adjust slope m and y-intercept b. See the slope triangle, intercepts, parallel and perpendicular lines update live.</p>
                            </div>
                        </a>

                        <!-- 17. Systems of Equations - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/systems-of-equations.jsp" class="vm-card"
                            data-category="algebra">
                            <div class="vm-card-preview" id="preview-systems"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag algebra">Algebra</span>
                                <h3>Systems of Equations</h3>
                                <p class="vm-card-desc">Graph two lines and find their intersection. Explore one solution, no solution (parallel), and infinite solutions.</p>
                            </div>
                        </a>

                        <!-- 18. Polynomial Roots - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/polynomial-roots.jsp" class="vm-card"
                            data-category="algebra">
                            <div class="vm-card-preview" id="preview-polynomial"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag algebra">Algebra</span>
                                <h3>Polynomial Roots Explorer</h3>
                                <p class="vm-card-desc">Drag roots on the x-axis and watch the polynomial reshape. See factored form, end behavior, and degree 2-5.</p>
                            </div>
                        </a>

                        <!-- 19. Exponential & Log - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/exp-log.jsp" class="vm-card"
                            data-category="algebra">
                            <div class="vm-card-preview" id="preview-exp-log"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag algebra">Algebra</span>
                                <h3>Exponential & Log Explorer</h3>
                                <p class="vm-card-desc">Visualize y=a^x and y=log_a(x) side by side. Adjust the base, see growth vs decay and the reflection across y=x.</p>
                            </div>
                        </a>

                        <!-- 20. Conic Sections - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/conic-sections.jsp" class="vm-card"
                            data-category="geometry">
                            <div class="vm-card-preview" id="preview-conics"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag geometry">Geometry</span>
                                <h3>Conic Sections Explorer</h3>
                                <p class="vm-card-desc">Explore ellipses, hyperbolas, parabolas, and circles. See foci, vertices, eccentricity, asymptotes, and directrices.</p>
                            </div>
                        </a>

                        <!-- 21. Transformations - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/transformations.jsp" class="vm-card"
                            data-category="geometry">
                            <div class="vm-card-preview" id="preview-transformations"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag geometry">Geometry</span>
                                <h3>Geometric Transformations</h3>
                                <p class="vm-card-desc">Apply translations, rotations, reflections, and dilations to shapes. See original and transformed figures with mapping rules.</p>
                            </div>
                        </a>

                        <!-- 22. 2D Vectors - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/vectors-2d.jsp" class="vm-card"
                            data-category="linalg">
                            <div class="vm-card-preview" id="preview-vectors"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag linalg">Linear Algebra</span>
                                <h3>2D Vector Explorer</h3>
                                <p class="vm-card-desc">Drag vector tips to explore addition, dot product, magnitude, angle, and projection. Parallelogram rule visualized.</p>
                            </div>
                        </a>

                        <!-- 23. Sequences & Series - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/sequences-series.jsp" class="vm-card"
                            data-category="algebra">
                            <div class="vm-card-preview" id="preview-sequences"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag algebra">Algebra</span>
                                <h3>Sequences & Series</h3>
                                <p class="vm-card-desc">Compare arithmetic and geometric sequences. See terms as bars, partial sums, convergence behavior, and nth term formulas.</p>
                            </div>
                        </a>

                        <!-- 24. Complex Plane - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/complex-plane.jsp" class="vm-card"
                            data-category="algebra">
                            <div class="vm-card-preview" id="preview-complex"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag algebra">Algebra</span>
                                <h3>Complex Number Explorer</h3>
                                <p class="vm-card-desc">Drag complex numbers on the Argand plane. See addition, multiplication, polar form, modulus, and argument live.</p>
                            </div>
                        </a>

                        <!-- 25. Polar Coordinates - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/polar-coordinates.jsp" class="vm-card"
                            data-category="trig">
                            <div class="vm-card-preview" id="preview-polar"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag trig">Trigonometry</span>
                                <h3>Polar Coordinates</h3>
                                <p class="vm-card-desc">Graph rose curves, cardioids, spirals, lemniscates. Watch the curve traced with animated &theta; sweep.</p>
                            </div>
                        </a>

                        <!-- 26. Parametric Curves - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/parametric-curves.jsp" class="vm-card"
                            data-category="calc">
                            <div class="vm-card-preview" id="preview-parametric"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag calc">Calculus</span>
                                <h3>Parametric Curves</h3>
                                <p class="vm-card-desc">Trace Lissajous figures, epicycloids, astroids, and butterfly curves. Watch x(t), y(t) sweep out beautiful shapes.</p>
                            </div>
                        </a>

                        <!-- 27. Probability Distributions - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/probability-distributions.jsp" class="vm-card"
                            data-category="prob">
                            <div class="vm-card-preview" id="preview-distributions"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag prob">Probability</span>
                                <h3>Probability Distributions</h3>
                                <p class="vm-card-desc">Compare Binomial, Poisson, Geometric, and Uniform distributions. See PMF bars, mean, variance, and standard deviation.</p>
                            </div>
                        </a>

                        <!-- 28. Limits & Continuity - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/limits-continuity.jsp" class="vm-card"
                            data-category="calc">
                            <div class="vm-card-preview" id="preview-limits"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag calc">Calculus</span>
                                <h3>Limits & Continuity</h3>
                                <p class="vm-card-desc">Explore removable, jump, infinite, and oscillating discontinuities. Visualize the epsilon-delta definition of a limit.</p>
                            </div>
                        </a>

                        <!-- 29. Slope Fields - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/slope-fields.jsp" class="vm-card"
                            data-category="calc">
                            <div class="vm-card-preview" id="preview-slope-fields"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag calc">Calculus</span>
                                <h3>Slope Fields & ODEs</h3>
                                <p class="vm-card-desc">See direction fields for differential equations. Click to place initial conditions and trace solution curves via Euler's method.</p>
                            </div>
                        </a>

                        <!-- 30. Regression & Scatter - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/regression-scatter.jsp" class="vm-card"
                            data-category="stat">
                            <div class="vm-card-preview" id="preview-regression"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag stat">Statistics</span>
                                <h3>Regression & Scatter Plot</h3>
                                <p class="vm-card-desc">Drag data points and watch the least-squares line update live. See R&sup2;, residuals, and correlation coefficient.</p>
                            </div>
                        </a>

                        <!-- 31. Fractal Explorer - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/fractal-explorer.jsp" class="vm-card"
                            data-category="geometry">
                            <div class="vm-card-preview" id="preview-fractals"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag geometry">Geometry</span>
                                <h3>Fractal Explorer</h3>
                                <p class="vm-card-desc">Explore Koch snowflakes, Sierpinski triangles, fractal trees, Barnsley ferns, and the Mandelbrot set with adjustable iterations.</p>
                            </div>
                        </a>

                        <!-- 32. Venn Diagram - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/venn-diagram.jsp" class="vm-card"
                            data-category="geometry">
                            <div class="vm-card-preview" id="preview-venn"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag geometry">Geometry</span>
                                <h3>Venn Diagram Maker</h3>
                                <p class="vm-card-desc">Drag circles to explore set operations: union, intersection, difference, symmetric difference, and complement with element display.</p>
                            </div>
                        </a>

                        <!-- 33. Matrix Calculator - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/matrix-calculator.jsp" class="vm-card"
                            data-category="linalg">
                            <div class="vm-card-preview" id="preview-matrix-calc"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag linalg">Linear Algebra</span>
                                <h3>Matrix Calculator</h3>
                                <p class="vm-card-desc">Compute determinant, inverse, eigenvalues, and eigenvectors of a 2&times;2 matrix. See the unit square transform with basis vectors.</p>
                            </div>
                        </a>

                        <!-- 34. Integration Explorer - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/integration-explorer.jsp" class="vm-card"
                            data-category="calc">
                            <div class="vm-card-preview" id="preview-integration"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag calc">Calculus</span>
                                <h3>Integration Explorer</h3>
                                <p class="vm-card-desc">Visualize definite integrals with shaded area, Fundamental Theorem of Calculus, and area between curves for 6 functions.</p>
                            </div>
                        </a>

                        <!-- 35. Permutations & Combinations - ACTIVE -->
                        <a href="<%=request.getContextPath()%>/exams/visual-math/permutations-combinations.jsp" class="vm-card"
                            data-category="prob">
                            <div class="vm-card-preview" id="preview-combinatorics"></div>
                            <div class="vm-card-body">
                                <span class="vm-card-tag prob">Probability</span>
                                <h3>Permutations & Combinations</h3>
                                <p class="vm-card-desc">Explore Pascal&rsquo;s triangle, nPr and nCr calculations. See selection and arrangement visualizations with counting principles.</p>
                            </div>
                        </a>

                    </div>
            </div>

            <!-- JSON-LD -->
            <script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "CollectionPage",
    "name": "Visual Math Lab",
    "description": "Interactive mathematics visualizations for building intuition. Unit circle, Riemann sums, matrix transformations, and more.",
    "url": "https://8gwifi.org/exams/visual-math/",
    "publisher": {
        "@type": "Organization",
        "name": "8gwifi.org"
    },
    "mainEntity": {
        "@type": "ItemList",
        "itemListElement": [
            {
                "@type": "ListItem",
                "position": 1,
                "name": "Unit Circle Explorer",
                "url": "https://8gwifi.org/exams/visual-math/unit-circle.jsp"
            },
            {
                "@type": "ListItem",
                "position": 2,
                "name": "Riemann Sum Explorer",
                "url": "https://8gwifi.org/exams/visual-math/riemann-sum.jsp"
            },
            {
                "@type": "ListItem",
                "position": 3,
                "name": "Matrix Transformer",
                "url": "https://8gwifi.org/exams/visual-math/matrix-transform.jsp"
            },
            {
                "@type": "ListItem",
                "position": 4,
                "name": "Taylor Series Builder",
                "url": "https://8gwifi.org/exams/visual-math/taylor-series.jsp"
            },
            {
                "@type": "ListItem",
                "position": 5,
                "name": "Function Plotter",
                "url": "https://8gwifi.org/exams/visual-math/function-plotter.jsp"
            },
            {
                "@type": "ListItem",
                "position": 6,
                "name": "Central Limit Theorem",
                "url": "https://8gwifi.org/exams/visual-math/central-limit-theorem.jsp"
            },
            {
                "@type": "ListItem",
                "position": 7,
                "name": "Normal Distribution Calculator",
                "url": "https://8gwifi.org/exams/visual-math/normal-distribution.jsp"
            },
            {
                "@type": "ListItem",
                "position": 8,
                "name": "Derivative Visualizer",
                "url": "https://8gwifi.org/exams/visual-math/derivative.jsp"
            },
            {
                "@type": "ListItem",
                "position": 9,
                "name": "Quadratic Explorer",
                "url": "https://8gwifi.org/exams/visual-math/quadratic.jsp"
            },
            {
                "@type": "ListItem",
                "position": 10,
                "name": "Pythagorean Theorem Visualizer",
                "url": "https://8gwifi.org/exams/visual-math/pythagorean-theorem.jsp"
            },
            {
                "@type": "ListItem",
                "position": 11,
                "name": "Circle Theorems Explorer",
                "url": "https://8gwifi.org/exams/visual-math/circle-theorems.jsp"
            },
            {
                "@type": "ListItem",
                "position": 12,
                "name": "Trig Graphs Visualizer",
                "url": "https://8gwifi.org/exams/visual-math/trig-graphs.jsp"
            },
            {
                "@type": "ListItem",
                "position": 13,
                "name": "Triangle Solver Calculator",
                "url": "https://8gwifi.org/exams/visual-math/triangle-solver.jsp"
            },
            {
                "@type": "ListItem",
                "position": 14,
                "name": "Statistics Dashboard",
                "url": "https://8gwifi.org/exams/visual-math/statistics-dashboard.jsp"
            },
            {
                "@type": "ListItem",
                "position": 15,
                "name": "3D Shape Volume Calculator",
                "url": "https://8gwifi.org/exams/visual-math/3d-shapes.jsp"
            },
            {
                "@type": "ListItem",
                "position": 16,
                "name": "Linear Equation Explorer",
                "url": "https://8gwifi.org/exams/visual-math/linear-equation.jsp"
            },
            {
                "@type": "ListItem",
                "position": 17,
                "name": "Systems of Equations Solver",
                "url": "https://8gwifi.org/exams/visual-math/systems-of-equations.jsp"
            },
            {
                "@type": "ListItem",
                "position": 18,
                "name": "Polynomial Roots Explorer",
                "url": "https://8gwifi.org/exams/visual-math/polynomial-roots.jsp"
            },
            {
                "@type": "ListItem",
                "position": 19,
                "name": "Exponential & Logarithm Explorer",
                "url": "https://8gwifi.org/exams/visual-math/exp-log.jsp"
            },
            {
                "@type": "ListItem",
                "position": 20,
                "name": "Conic Sections Explorer",
                "url": "https://8gwifi.org/exams/visual-math/conic-sections.jsp"
            },
            {
                "@type": "ListItem",
                "position": 21,
                "name": "Geometric Transformations",
                "url": "https://8gwifi.org/exams/visual-math/transformations.jsp"
            },
            {
                "@type": "ListItem",
                "position": 22,
                "name": "2D Vector Explorer",
                "url": "https://8gwifi.org/exams/visual-math/vectors-2d.jsp"
            },
            {
                "@type": "ListItem",
                "position": 23,
                "name": "Sequences & Series Visualizer",
                "url": "https://8gwifi.org/exams/visual-math/sequences-series.jsp"
            },
            {
                "@type": "ListItem",
                "position": 24,
                "name": "Complex Number Explorer",
                "url": "https://8gwifi.org/exams/visual-math/complex-plane.jsp"
            },
            {
                "@type": "ListItem",
                "position": 25,
                "name": "Polar Coordinates Grapher",
                "url": "https://8gwifi.org/exams/visual-math/polar-coordinates.jsp"
            },
            {
                "@type": "ListItem",
                "position": 26,
                "name": "Parametric Curves Explorer",
                "url": "https://8gwifi.org/exams/visual-math/parametric-curves.jsp"
            },
            {
                "@type": "ListItem",
                "position": 27,
                "name": "Probability Distributions",
                "url": "https://8gwifi.org/exams/visual-math/probability-distributions.jsp"
            },
            {
                "@type": "ListItem",
                "position": 28,
                "name": "Limits & Continuity Visualizer",
                "url": "https://8gwifi.org/exams/visual-math/limits-continuity.jsp"
            },
            {
                "@type": "ListItem",
                "position": 29,
                "name": "Slope Fields & ODE Visualizer",
                "url": "https://8gwifi.org/exams/visual-math/slope-fields.jsp"
            },
            {
                "@type": "ListItem",
                "position": 30,
                "name": "Regression & Scatter Plot",
                "url": "https://8gwifi.org/exams/visual-math/regression-scatter.jsp"
            },
            {
                "@type": "ListItem",
                "position": 31,
                "name": "Fractal Explorer",
                "url": "https://8gwifi.org/exams/visual-math/fractal-explorer.jsp"
            },
            {
                "@type": "ListItem",
                "position": 32,
                "name": "Venn Diagram Maker",
                "url": "https://8gwifi.org/exams/visual-math/venn-diagram.jsp"
            },
            {
                "@type": "ListItem",
                "position": 33,
                "name": "Matrix Calculator",
                "url": "https://8gwifi.org/exams/visual-math/matrix-calculator.jsp"
            },
            {
                "@type": "ListItem",
                "position": 34,
                "name": "Integration Explorer",
                "url": "https://8gwifi.org/exams/visual-math/integration-explorer.jsp"
            },
            {
                "@type": "ListItem",
                "position": 35,
                "name": "Permutations & Combinations Calculator",
                "url": "https://8gwifi.org/exams/visual-math/permutations-combinations.jsp"
            }
        ]
    }
}
</script>
            <script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
        { "@type": "ListItem", "position": 1, "name": "Home", "item": "https://8gwifi.org/" },
        { "@type": "ListItem", "position": 2, "name": "Exams", "item": "https://8gwifi.org/exams/" },
        { "@type": "ListItem", "position": 3, "name": "Visual Math Lab" }
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
            "name": "What is the Visual Math Lab?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The Visual Math Lab is a collection of 35 free interactive math visualizations that help students build mathematical intuition. Tools include Venn diagrams, matrix calculator with eigenvalues, integration explorer with FTC, permutations & combinations with Pascal's triangle, parametric curves, slope fields, limits & continuity, probability distributions, regression & scatter plots, fractal explorer, linear equations, systems of equations, polynomial roots, exponential & log, conic sections, complex numbers, polar coordinates, unit circle, trig graphs, derivatives, Riemann sums, Taylor series, matrix transformer, statistics, 3D shapes, and more."
            }
        },
        {
            "@type": "Question",
            "name": "Are these math visualizations free to use?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Yes, all visualizations are completely free. No sign-up required. They work on desktop and mobile browsers with interactive drag, slider, and animation controls."
            }
        },
        {
            "@type": "Question",
            "name": "What math topics are covered?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Topics include algebra (linear equations, systems of equations, polynomial roots, exponential & logarithm, quadratic, sequences & series, function plotter), trigonometry (unit circle, trig graphs, triangle solver, polar coordinates), geometry (Pythagorean theorem, circle theorems, conic sections, transformations, fractals, Venn diagrams), 3D geometry (11-shape volume calculator), statistics (box plots, histograms, regression & scatter plot), calculus (Riemann sums, Taylor series, derivatives, limits & continuity, parametric curves, slope fields & ODEs, integration explorer with FTC), linear algebra (matrix transformations, 2D vectors, complex numbers, matrix calculator with eigenvalues), and probability (Central Limit Theorem, normal distribution, Binomial/Poisson/Geometric distributions, permutations & combinations). 35 interactive visualizations total."
            }
        }
    ]
}
</script>

<%@ include file="viz-ads.jsp" %>
            <%@ include file="../components/footer.jsp" %>

                <!-- p5.js + Visual Math -->
                <script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
                <script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
                <script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-previews.js"></script>
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        // Launch preview sketches
                        VisualMath.preview('preview-unit-circle', 'unit-circle-preview');
                        VisualMath.preview('preview-riemann', 'riemann-preview');
                        VisualMath.preview('preview-matrix', 'matrix-preview');
                        VisualMath.preview('preview-taylor', 'taylor-preview');
                        VisualMath.preview('preview-function', 'function-preview');
                        VisualMath.preview('preview-clt', 'probability-preview');
                        VisualMath.preview('preview-normal', 'normal-preview');
                        VisualMath.preview('preview-derivative', 'derivative-preview');
                        VisualMath.preview('preview-quadratic', 'quadratic-preview');
                        VisualMath.preview('preview-pythagorean', 'pythagorean-preview');
                        VisualMath.preview('preview-circle-theorems', 'circle-theorems-preview');
                        VisualMath.preview('preview-trig-graphs', 'trig-graphs-preview');
                        VisualMath.preview('preview-triangle-solver', 'triangle-solver-preview');
                        VisualMath.preview('preview-statistics', 'statistics-preview');
                        VisualMath.preview('preview-3d-shapes', '3d-shapes-preview');
                        VisualMath.preview('preview-linear', 'linear-preview');
                        VisualMath.preview('preview-systems', 'systems-preview');
                        VisualMath.preview('preview-polynomial', 'polynomial-preview');
                        VisualMath.preview('preview-exp-log', 'exp-log-preview');
                        VisualMath.preview('preview-conics', 'conics-preview');
                        VisualMath.preview('preview-transformations', 'transformations-preview');
                        VisualMath.preview('preview-vectors', 'vectors-preview');
                        VisualMath.preview('preview-sequences', 'sequences-preview');
                        VisualMath.preview('preview-complex', 'complex-preview');
                        VisualMath.preview('preview-polar', 'polar-preview');
                        VisualMath.preview('preview-parametric', 'parametric-preview');
                        VisualMath.preview('preview-distributions', 'distributions-preview');
                        VisualMath.preview('preview-limits', 'limits-preview');
                        VisualMath.preview('preview-slope-fields', 'slope-fields-preview');
                        VisualMath.preview('preview-regression', 'regression-preview');
                        VisualMath.preview('preview-fractals', 'fractals-preview');
                        VisualMath.preview('preview-venn', 'venn-preview');
                        VisualMath.preview('preview-matrix-calc', 'matrix-calc-preview');
                        VisualMath.preview('preview-integration', 'integration-preview');
                        VisualMath.preview('preview-combinatorics', 'combinatorics-preview');

                        // Filter chips
                        var chips = document.querySelectorAll('.vm-chip');
                        var cards = document.querySelectorAll('.vm-card');

                        chips.forEach(function (chip) {
                            chip.addEventListener('click', function () {
                                chips.forEach(function (c) { c.classList.remove('active'); });
                                chip.classList.add('active');
                                var filter = chip.getAttribute('data-filter');
                                cards.forEach(function (card) {
                                    if (filter === 'all' || card.getAttribute('data-category') === filter) {
                                        card.style.display = '';
                                    } else {
                                        card.style.display = 'none';
                                    }
                                });
                            });
                        });
                    });
                </script>
