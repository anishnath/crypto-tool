<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <%--
        PDE Solver Calculator — math-studio shell (matches integral-calculator).
        Uses ic-stack / ic-hero / ic-result-card / ic-output-tabs / ic-panel /
        ic-hero-cta / ic-hero-methods / ic-worksheet-cta classes throughout
        for visual parity.

        Legacy pde-* IDs preserved verbatim so /modern/js/pde-solver-calculator.js
        continues to work unchanged.  Tab/panel buttons carry both the ic-*
        (styling) and pde-* (legacy JS hook) class names.

        Quick wins landed inline:
          1. PDE chip rail grouped into "Time-evolving / Steady-state /
             Other" categories so first-time students aren't overwhelmed
             by 7 unlabeled chips.
          2. BC dropdown labels expanded with physical meaning
             ("Dirichlet — fixed value at boundary",
              "Neumann — insulated, no flux", etc.)
          3. URL ?mode= auto-fill on page load.
          4. Live equation preview that updates with current parameters
             (replaces the static "Heat: u_t = k u_xx" placeholder).
          5. AI photo scan with PDE-specific extraction prompt.
    --%>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow,max-image-preview:large,max-snippet:-1">
    <meta name="googlebot" content="index,follow">
    <meta name="author" content="Anish Nath">

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="PDE Solver Calculator with Steps + AI Photo Scan" />
        <jsp:param name="toolDescription" value="Free AI PDE solver with step-by-step solutions and photo scan. Solve heat, wave, Laplace, Poisson, transport, and Schr&ouml;dinger equations. Dirichlet, Neumann, Robin boundary conditions. 3D surface plots, contour maps, time animation. Snap a problem from your textbook. 2,000+ practice worksheet problems. No signup." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="pde-solver-calculator.jsp" />
        <jsp:param name="toolKeywords" value="PDE solver, partial differential equation calculator, PDE solver with steps, AI PDE solver, PDE solver scan image, scan PDE problem, photo math PDE, snap PDE problem, heat equation solver, wave equation solver, Laplace equation solver, Poisson equation solver, transport equation solver, advection equation, Schrodinger equation solver, diffusion equation calculator, finite difference PDE, numerical PDE solver, boundary value problem solver, Dirichlet boundary condition, Neumann boundary condition, Robin boundary condition, separation of variables PDE, Fourier series PDE, 2D PDE solver, 3D PDE solver, PDE worksheet, PDE practice problems, PDE worksheet with answers, free PDE solver online, no signup PDE calculator" />
        <jsp:param name="educationalLevel" value="High School, AP Calculus, College, University, Graduate" />
        <jsp:param name="teaches" value="Partial differential equations, heat equation, wave equation, Laplace equation, Poisson equation, transport equation, Schrodinger equation, finite difference methods, boundary conditions, separation of variables, Fourier series, numerical stability, CFL condition, eigenvalue problems, Sturm-Liouville theory, d Alembert formula, Duhamel principle, Green functions" />
        <jsp:param name="howToSteps" value="Snap a photo OR pick PDE type|Click the camera button to scan a problem from a photo or PDF (AI extracts the PDE type and parameters) OR choose Heat, Wave, Laplace, Poisson, Transport, Schrodinger, or 1st-Order from the chip rail.,Set parameters and BCs|Enter coefficients (k, c, L, t_max), domain size, initial condition, and boundary conditions (Dirichlet, Neumann, Robin) from the dropdowns.,Click Solve|Compute the numerical solution with finite difference methods and view the step-by-step breakdown including stability analysis (CFL condition).,View result and visualize|Switch tabs for 3D surface, contour/heatmap, time evolution animation, or the editable Python (NumPy) code." />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="AI photo scan with step-by-step solver,7 PDE types in one page,Heat equation (1D/2D diffusion) solver,Wave equation solver with d Alembert,Laplace equation (steady-state) solver,Poisson equation solver,Transport advection equation solver,Time-independent Schrodinger equation solver,1st-order linear PDE analytical solver (SymPy),Dirichlet Neumann Robin boundary conditions with physical-meaning labels,Step-by-step solution with stability analysis,CFL Courant number,Interactive 3D surface plots,Contour heatmap visualization,Time evolution animation,Copy LaTeX Download PDF Share URL,2000+ PDE practice worksheet problems,Filter by 48 question types and 4 difficulty levels,Built-in Python compiler,Quick presets,Dark mode no signup no limits free forever" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="Can I scan a PDE problem from a photo?" />
        <jsp:param name="faq1a" value="Yes. Click the green Scan button next to the mode chips, upload a photo or PDF of your homework, and our AI extracts the PDE type (heat, wave, Laplace, etc.), the diffusivity / wave speed / domain length, the initial conditions, and the boundary conditions. Pick a problem to fill the form and solve. Works on textbook pages, exam papers, and handwritten work." />
        <jsp:param name="faq2q" value="What is a partial differential equation (PDE)?" />
        <jsp:param name="faq2a" value="A PDE is an equation involving a function of several variables and its partial derivatives. Unlike ODEs, PDEs involve multiple variables. The three classic types: heat equation (diffusion), wave equation (propagation), and Laplace equation (steady-state). PDEs model phenomena in physics, engineering, and finance." />
        <jsp:param name="faq3q" value="What are Dirichlet, Neumann, and Robin boundary conditions?" />
        <jsp:param name="faq3a" value="Dirichlet BCs specify the function value on the boundary (u=g) — fixing the temperature at the rod ends. Neumann BCs specify the derivative (du/dn=g), modeling insulated or flux boundaries (no heat flow). Robin (mixed) BCs combine both (a*u + b*du/dn = g), modeling convective heat transfer where heat loss is proportional to the temperature difference. The dropdown labels in this calculator include the physical interpretation alongside the mathematical name to make the choice obvious." />
        <jsp:param name="faq4q" value="What is the CFL condition and numerical stability?" />
        <jsp:param name="faq4a" value="The CFL (Courant-Friedrichs-Lewy) condition ensures numerical stability in finite difference methods. For the heat equation, stability requires r = k*dt/dx^2 <= 0.5. For the wave equation, the Courant number C = c*dt/dx <= 1. Violating these causes numerical solutions to blow up. This calculator automatically ensures stable parameters." />
        <jsp:param name="faq5q" value="What is separation of variables for PDEs?" />
        <jsp:param name="faq5a" value="Separation of variables assumes the solution is a product of single-variable functions: u(x,t) = X(x)T(t). Substituting separates the PDE into independent ODEs. Combined with boundary conditions, this yields eigenvalues and eigenfunctions, producing Fourier series solutions." />
        <jsp:param name="faq6q" value="What is the heat equation and where is it used?" />
        <jsp:param name="faq6a" value="The heat equation du/dt = k*d2u/dx2 models heat diffusion, chemical concentration spread, and financial option pricing (Black-Scholes). k is thermal diffusivity. Solutions decay toward equilibrium. The equation is parabolic." />
        <jsp:param name="faq7q" value="What is the wave equation and where is it used?" />
        <jsp:param name="faq7a" value="The wave equation d2u/dt2 = c2*d2u/dx2 models vibrating strings, sound waves, electromagnetic waves, and seismic waves. c is the wave speed. D'Alembert's formula gives u(x,t) = f(x-ct) + g(x+ct). The equation is hyperbolic." />
        <jsp:param name="faq8q" value="Is this PDE solver calculator free?" />
        <jsp:param name="faq8a" value="Yes — 100 percent free, no signup, no daily limits. Step-by-step solutions, stability analysis, interactive 3D surfaces, contour plots, time animation, Dirichlet / Neumann / Robin boundary conditions, AI photo scan, 2,000+ practice worksheet problems with answer keys, and a built-in Python compiler." />
        <jsp:param name="faq9q" value="Does this PDE solver include practice worksheets?" />
        <jsp:param name="faq9a" value="Yes. This calculator includes a built-in worksheet generator with over 2,000 PDE practice problems. Filter by 48 question types and 4 difficulty levels (basic, medium, hard, scholar). Each worksheet is randomly generated with a full answer key." />
        <jsp:param name="faq10q" value="What types of PDE problems are in the worksheet?" />
        <jsp:param name="faq10a" value="48 problem types across 4 difficulty levels: classification (basic), separation of variables and Fourier coefficients (medium), full Fourier series solutions (hard), and Sturm-Liouville eigenvalue problems, Green functions, Duhamel principle, biharmonic equations (scholar). All answers verified and rendered in LaTeX." />
    </jsp:include>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdn.jsdelivr.net">
    <link rel="dns-prefetch" href="https://cdn.plot.ly">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap"></noscript>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>">

    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/pde-solver-calculator.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/image-to-math.css?v=<%=cacheVersion%>">

    <style>
    /* PDE-specific shell tweaks — group label styling for the chip rail */
    /* Compact one-line-per-group rail: inline label sits left of chips so
       the whole rail is 3 lines tall instead of 6. */
    .pde-mode-group {
        display: flex;
        align-items: center;
        gap: 0.6rem;
        flex-wrap: wrap;
        margin-bottom: 0.35rem;
    }
    .pde-mode-group:last-child { margin-bottom: 0; }
    .pde-mode-group-label {
        font-size: 0.7rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        color: var(--ms-muted, #94a3b8);
        flex-shrink: 0;
        min-width: 6.5rem;
    }
    .pde-mode-group .pde-mode-toggle { margin: 0; flex-wrap: wrap; }

    /* Compact mode-body sections — replaces the loose stack of full-width
       form-groups with two visually-grouped sub-sections (Parameters /
       Conditions) each holding a compact grid of inputs. */
    .pde-param-section {
        background: var(--ms-panel-bg-soft, #f8fafc);
        border-left: 3px solid var(--ms-accent, #15803d);
        padding: 0.45rem 0.75rem 0.55rem;
        border-radius: 0 6px 6px 0;
        margin-bottom: 0.45rem;
    }
    .pde-param-section-label {
        display: block;
        font-size: 0.66rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.04em;
        color: var(--ms-muted, #94a3b8);
        margin-bottom: 0.35rem;
    }
    .pde-param-grid {
        display: grid;
        gap: 0.4rem 0.55rem;
    }
    .pde-param-grid.cols-3 { grid-template-columns: repeat(3, 1fr); }
    .pde-param-grid.cols-2 { grid-template-columns: repeat(2, 1fr); }
    .pde-param-grid.cols-1 { grid-template-columns: 1fr; }
    .pde-param-grid .tool-form-group { margin: 0; }
    .pde-param-grid .tool-form-label {
        font-size: 0.72rem;
        font-family: var(--ms-font-mono, monospace);
        margin-bottom: 0.18rem;
        color: var(--ms-ink-soft, #475569);
    }
    .pde-param-grid input.tool-input,
    .pde-param-grid select.tool-input {
        padding: 0.4rem 0.55rem;
        font-size: 0.85rem;
        height: 2rem;
    }
    .pde-param-grid select.tool-input {
        font-size: 0.78rem;
    }
    /* Wider field for Linear1's G(x,y) expression — full row. */
    .pde-param-grid.full-row .tool-form-group { grid-column: 1 / -1; }

    /* Busy-spinner for the primary CTA (PDE compute can take 2–5s
       for large grids — students need to see Solve is working). */
    .ic-hero-cta.is-busy {
        opacity: 0.65;
        cursor: progress;
        pointer-events: none;
    }
    .ic-hero-cta.is-busy::after {
        content: '';
        display: inline-block;
        margin-left: 0.6rem;
        width: 12px; height: 12px;
        border: 2px solid rgba(255,255,255,0.4);
        border-top-color: #fff;
        border-radius: 50%;
        animation: pde-cta-spin 0.7s linear infinite;
        vertical-align: middle;
    }
    @keyframes pde-cta-spin { to { transform: rotate(360deg); } }
    </style>

    <%@ include file="modern/ads/ad-init.jsp" %>
</head>
<body class="ms-body">

    <%@ include file="modern/components/nav-header.jsp" %>

    <jsp:include page="/math/partials/matter-bg.jsp" />

    <div class="ms-hero">
        <%@ include file="modern/ads/ad-hero-banner.jsp" %>
    </div>

    <main class="ms-main">

        <button type="button" id="msSidebarToggle" class="ms-sidebar-toggle" aria-label="Open math tools menu">
            &#9776; Math tools
        </button>

        <% request.setAttribute("activeService", "pde"); %>
        <jsp:include page="/math/partials/sidebar.jsp" />

        <section class="ms-workspace">

            <header class="ms-title">
                <nav class="ms-crumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                    <span>/</span>
                    <a href="<%=request.getContextPath()%>/math/">Math</a>
                    <span>/</span>
                    <span aria-current="page">PDE</span>
                </nav>
                <div style="display:flex;align-items:baseline;justify-content:space-between;gap:1rem;flex-wrap:wrap;">
                    <h1 style="margin:0;">PDE Solver Calculator</h1>
                    <a href="#worksheet" id="pde-header-worksheet-link" style="font-size:0.85rem;color:var(--ms-accent,#15803d);text-decoration:none;font-weight:600;border:1px solid var(--ms-accent,#15803d);padding:0.3rem 0.7rem;border-radius:9999px;white-space:nowrap;">&#128221; Practice worksheet</a>
                </div>
            </header>

            <div class="ic-stack">

                <!-- ═══ INPUT HERO ═══ -->
                <div class="ic-hero" id="pde-hero">

                    <!-- Top row: title + Scan button -->
                    <div class="ic-hero-top">
                        <div style="font-size:0.92rem;color:var(--ms-muted);font-weight:600;">Choose a PDE type below.</div>
                        <button type="button" class="ic-image-btn" id="pde-scan-btn" title="Scan PDE problems from image or PDF">&#128247; Scan</button>
                    </div>

                    <!-- Quick win #1: PDE chip rail with category groupings -->
                    <div class="pde-mode-group">
                        <span class="pde-mode-group-label">Time-evolving</span>
                        <div class="pde-mode-toggle">
                            <button type="button" class="pde-mode-btn active" data-mode="heat">Heat</button>
                            <button type="button" class="pde-mode-btn"        data-mode="wave">Wave</button>
                            <button type="button" class="pde-mode-btn"        data-mode="transport">Transport</button>
                        </div>
                    </div>
                    <div class="pde-mode-group">
                        <span class="pde-mode-group-label">Steady-state</span>
                        <div class="pde-mode-toggle">
                            <button type="button" class="pde-mode-btn" data-mode="laplace">Laplace</button>
                            <button type="button" class="pde-mode-btn" data-mode="poisson">Poisson</button>
                        </div>
                    </div>
                    <div class="pde-mode-group">
                        <span class="pde-mode-group-label">Other</span>
                        <div class="pde-mode-toggle">
                            <button type="button" class="pde-mode-btn" data-mode="schrodinger">Schr&ouml;dinger</button>
                            <button type="button" class="pde-mode-btn" data-mode="linear1">1st-Order Linear</button>
                        </div>
                    </div>

                    <!-- ── Heat ── -->
                    <div id="pde-heat-wrap" style="margin-top:0.5rem;">
                        <div class="pde-param-section">
                            <span class="pde-param-section-label">Parameters</span>
                            <div class="pde-param-grid cols-3">
                                <div class="tool-form-group"><label class="tool-form-label" for="pde-heat-k" title="Thermal diffusivity">k</label><input type="text" class="tool-input tool-input-mono" id="pde-heat-k" value="1" title="Thermal diffusivity"></div>
                                <div class="tool-form-group"><label class="tool-form-label" for="pde-heat-L" title="Domain length">L</label><input type="text" class="tool-input tool-input-mono" id="pde-heat-L" value="1" title="Domain length"></div>
                                <div class="tool-form-group"><label class="tool-form-label" for="pde-heat-tmax" title="Maximum simulation time">t<sub>max</sub></label><input type="text" class="tool-input tool-input-mono" id="pde-heat-tmax" value="0.5" title="Max time"></div>
                            </div>
                        </div>
                        <div class="pde-param-section">
                            <span class="pde-param-section-label">Initial &amp; boundary conditions</span>
                            <div class="pde-param-grid cols-2">
                                <div class="tool-form-group">
                                    <label class="tool-form-label" title="Initial condition u(x, 0)">u(x, 0)</label>
                                    <select class="tool-input" id="pde-heat-ic">
                                        <option value="sin">sin(&pi;x/L)</option>
                                        <option value="gauss">Gaussian pulse</option>
                                        <option value="step">Step (half hot)</option>
                                    </select>
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" title="Boundary conditions at x=0 and x=L">BC</label>
                                    <select class="tool-input" id="pde-heat-bc">
                                        <option value="dirichlet">Dirichlet &mdash; cold ends</option>
                                        <option value="neumann">Neumann &mdash; insulated</option>
                                        <option value="robin">Robin &mdash; convective</option>
                                        <option value="periodic">Periodic &mdash; ring</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- ── Wave ── -->
                    <div id="pde-wave-wrap" style="display:none;margin-top:0.5rem;">
                        <div class="pde-param-section">
                            <span class="pde-param-section-label">Parameters</span>
                            <div class="pde-param-grid cols-3">
                                <div class="tool-form-group"><label class="tool-form-label" for="pde-wave-c" title="Wave speed">c</label><input type="text" class="tool-input tool-input-mono" id="pde-wave-c" value="1" title="Wave speed"></div>
                                <div class="tool-form-group"><label class="tool-form-label" for="pde-wave-L" title="Domain length">L</label><input type="text" class="tool-input tool-input-mono" id="pde-wave-L" value="1" title="Domain length"></div>
                                <div class="tool-form-group"><label class="tool-form-label" for="pde-wave-tmax" title="Maximum simulation time">t<sub>max</sub></label><input type="text" class="tool-input tool-input-mono" id="pde-wave-tmax" value="2" title="Max time"></div>
                            </div>
                        </div>
                        <div class="pde-param-section">
                            <span class="pde-param-section-label">Initial &amp; boundary conditions</span>
                            <div class="pde-param-grid cols-2">
                                <div class="tool-form-group">
                                    <label class="tool-form-label" title="Initial displacement u(x, 0)">u(x, 0)</label>
                                    <select class="tool-input" id="pde-wave-ic">
                                        <option value="sin">sin(&pi;x/L)</option>
                                        <option value="gauss">Gaussian pulse</option>
                                        <option value="bump">Triangular bump</option>
                                    </select>
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" title="Boundary conditions">BC</label>
                                    <select class="tool-input" id="pde-wave-bc">
                                        <option value="dirichlet">Dirichlet &mdash; clamped</option>
                                        <option value="neumann">Neumann &mdash; free</option>
                                        <option value="mixed">Mixed</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- ── Laplace ── -->
                    <div id="pde-laplace-wrap" style="display:none;margin-top:0.5rem;">
                        <div class="pde-param-section">
                            <span class="pde-param-section-label">Grid &amp; boundary</span>
                            <div class="pde-param-grid cols-3">
                                <div class="tool-form-group"><label class="tool-form-label" for="pde-laplace-nx" title="Grid points in x">n<sub>x</sub></label><input type="number" class="tool-input" id="pde-laplace-nx" value="20" min="5" max="50"></div>
                                <div class="tool-form-group"><label class="tool-form-label" for="pde-laplace-ny" title="Grid points in y">n<sub>y</sub></label><input type="number" class="tool-input" id="pde-laplace-ny" value="20" min="5" max="50"></div>
                                <div class="tool-form-group" style="grid-column: span 1;">
                                    <label class="tool-form-label" title="Boundary condition">BC</label>
                                    <select class="tool-input" id="pde-laplace-bc">
                                        <option value="dirichlet">Dirichlet &mdash; heated lid</option>
                                        <option value="mixed">Mixed &mdash; hot/cold sides</option>
                                        <option value="neumann_top">Neumann top &mdash; insulated lid</option>
                                        <option value="robin">Robin &mdash; convective lid</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- ── Poisson ── -->
                    <div id="pde-poisson-wrap" style="display:none;margin-top:0.5rem;">
                        <div class="pde-param-section">
                            <span class="pde-param-section-label">Grid</span>
                            <div class="pde-param-grid cols-2">
                                <div class="tool-form-group"><label class="tool-form-label" for="pde-poisson-nx" title="Grid points in x">n<sub>x</sub></label><input type="number" class="tool-input" id="pde-poisson-nx" value="25" min="5" max="50"></div>
                                <div class="tool-form-group"><label class="tool-form-label" for="pde-poisson-ny" title="Grid points in y">n<sub>y</sub></label><input type="number" class="tool-input" id="pde-poisson-ny" value="25" min="5" max="50"></div>
                            </div>
                        </div>
                        <div class="pde-param-section">
                            <span class="pde-param-section-label">Source term &amp; boundary</span>
                            <div class="pde-param-grid cols-2">
                                <div class="tool-form-group">
                                    <label class="tool-form-label" title="Source term f(x, y) on the right-hand side">f(x, y)</label>
                                    <select class="tool-input" id="pde-poisson-source">
                                        <option value="const">Constant &mdash; f = &minus;2</option>
                                        <option value="gaussian">Gaussian peak</option>
                                        <option value="sin">Sinusoidal</option>
                                        <option value="dipole">Dipole &mdash; 2 sources</option>
                                    </select>
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" title="Boundary conditions">BC</label>
                                    <select class="tool-input" id="pde-poisson-bc">
                                        <option value="dirichlet">Dirichlet &mdash; u=0 all edges</option>
                                        <option value="neumann">Neumann &mdash; insulated</option>
                                        <option value="mixed">Mixed</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- ── Transport ── -->
                    <div id="pde-transport-wrap" style="display:none;margin-top:0.5rem;">
                        <div class="pde-param-section">
                            <span class="pde-param-section-label">Parameters</span>
                            <div class="pde-param-grid cols-3">
                                <div class="tool-form-group"><label class="tool-form-label" for="pde-transport-c" title="Advection speed">c</label><input type="text" class="tool-input tool-input-mono" id="pde-transport-c" value="1" title="Advection speed"></div>
                                <div class="tool-form-group"><label class="tool-form-label" for="pde-transport-L" title="Domain length">L</label><input type="text" class="tool-input tool-input-mono" id="pde-transport-L" value="2" title="Domain length"></div>
                                <div class="tool-form-group"><label class="tool-form-label" for="pde-transport-tmax" title="Maximum simulation time">t<sub>max</sub></label><input type="text" class="tool-input tool-input-mono" id="pde-transport-tmax" value="1.5" title="Max time"></div>
                            </div>
                        </div>
                        <div class="pde-param-section">
                            <span class="pde-param-section-label">Initial profile &amp; numerical scheme</span>
                            <div class="pde-param-grid cols-2">
                                <div class="tool-form-group">
                                    <label class="tool-form-label" title="Initial profile u(x, 0)">u(x, 0)</label>
                                    <select class="tool-input" id="pde-transport-ic">
                                        <option value="gauss">Gaussian pulse</option>
                                        <option value="step">Step function</option>
                                        <option value="sin">sin(&pi;x/L)</option>
                                        <option value="square">Square wave</option>
                                    </select>
                                </div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" title="Numerical scheme">Scheme</label>
                                    <select class="tool-input" id="pde-transport-scheme">
                                        <option value="upwind">Upwind &mdash; 1st order</option>
                                        <option value="lax_wendroff">Lax-Wendroff &mdash; 2nd order</option>
                                        <option value="lax_friedrichs">Lax-Friedrichs</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- ── Schrödinger ── -->
                    <div id="pde-schrodinger-wrap" style="display:none;margin-top:0.5rem;">
                        <p class="tool-form-hint" style="margin:0 0 0.5rem;font-size:0.78rem;"><em>&minus;&hbar;&sup2;/2m &middot; d&sup2;&psi;/dx&sup2; + V(x)&psi; = E&psi;</em></p>
                        <div class="pde-param-section">
                            <span class="pde-param-section-label">Well, potential &amp; states</span>
                            <div class="pde-param-grid cols-3">
                                <div class="tool-form-group"><label class="tool-form-label" for="pde-schrodinger-L" title="Well width">L</label><input type="text" class="tool-input tool-input-mono" id="pde-schrodinger-L" value="1" title="Well width"></div>
                                <div class="tool-form-group">
                                    <label class="tool-form-label" title="Potential function V(x)">V(x)</label>
                                    <select class="tool-input" id="pde-schrodinger-potential">
                                        <option value="infinite_well">Infinite well</option>
                                        <option value="harmonic">Harmonic V=&frac12;x&sup2;</option>
                                        <option value="finite_well">Finite well</option>
                                        <option value="double_well">Double well</option>
                                    </select>
                                </div>
                                <div class="tool-form-group"><label class="tool-form-label" for="pde-schrodinger-nstates" title="Number of eigenstates to compute">n</label><input type="number" class="tool-input" id="pde-schrodinger-nstates" value="5" min="1" max="10" title="Number of eigenstates"></div>
                            </div>
                        </div>
                    </div>

                    <!-- ── 1st-Order Linear ── -->
                    <div id="pde-linear1-wrap" style="display:none;margin-top:0.5rem;">
                        <p class="tool-form-hint" style="margin:0 0 0.5rem;font-size:0.78rem;"><em>a&middot;u<sub>x</sub> + b&middot;u<sub>y</sub> + c&middot;u = G(x, y)</em> &mdash; analytical symbolic solver</p>
                        <div class="pde-param-section">
                            <span class="pde-param-section-label">Coefficients</span>
                            <div class="pde-param-grid cols-3">
                                <div class="tool-form-group"><label class="tool-form-label" for="pde-linear1-a" title="Coefficient of u_x">a</label><input type="text" class="tool-input tool-input-mono" id="pde-linear1-a" value="1"></div>
                                <div class="tool-form-group"><label class="tool-form-label" for="pde-linear1-b" title="Coefficient of u_y">b</label><input type="text" class="tool-input tool-input-mono" id="pde-linear1-b" value="1"></div>
                                <div class="tool-form-group"><label class="tool-form-label" for="pde-linear1-c" title="Coefficient of u">c</label><input type="text" class="tool-input tool-input-mono" id="pde-linear1-c" value="1"></div>
                            </div>
                        </div>
                        <div class="pde-param-section">
                            <span class="pde-param-section-label">Right-hand side G(x, y)</span>
                            <div class="pde-param-grid cols-1 full-row">
                                <div class="tool-form-group">
                                    <label class="tool-form-label" for="pde-linear1-g" title="Use x, y, exp, sin, cos">G</label>
                                    <input type="text" class="tool-input tool-input-mono" id="pde-linear1-g" value="0" placeholder="0  |  exp(x+3*y)  |  sin(x)*cos(y)">
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Live equation preview (quick win — single canonical
                         div consumed by both the live updater AND the legacy
                         controller; no more silent shadow div). -->
                    <div class="ic-preview-strip">
                        <span class="ic-preview-label">Equation</span>
                        <span class="ic-preview pde-preview" id="pde-preview"></span>
                    </div>

                    <!-- Primary CTA -->
                    <div class="ic-hero-cta-row">
                        <button type="button" class="ic-hero-cta pde-compute-btn" id="pde-compute-btn">Solve &amp; explain &rarr;</button>
                        <button type="button" class="pde-random-btn" id="pde-random-btn" title="Random preset">&#127922; Random</button>
                    </div>

                    <!-- Headline presets — inline so first-time students see
                         real starting points without clicking an accordion.
                         data-mode + data-params describe the full state. -->
                    <div class="ic-method-row" style="margin:0.4rem 0 0.2rem;">
                        <span class="ic-method-label">Try one</span>
                        <button type="button" class="ic-example-chip" data-pde-headline data-mode="heat"
                                data-params='{"k":"1","L":"1","tmax":"0.5","ic":"sin","bc":"dirichlet"}'
                                title="Heat equation, sin pulse, fixed-cold ends">Heat &mdash; sin&middot;e<sup>&minus;t</sup></button>
                        <button type="button" class="ic-example-chip" data-pde-headline data-mode="wave"
                                data-params='{"c":"1","L":"1","tmax":"2","ic":"gauss","bc":"dirichlet"}'
                                title="Wave equation, Gaussian pulse, fixed ends">Wave &mdash; Gaussian pulse</button>
                        <button type="button" class="ic-example-chip" data-pde-headline data-mode="laplace"
                                data-params='{"nx":"20","ny":"20","bc":"dirichlet"}'
                                title="Laplace, hot lid, cold sides">Laplace &mdash; heated lid</button>
                        <button type="button" class="ic-example-chip" data-pde-headline data-mode="transport"
                                data-params='{"c":"1","L":"2","tmax":"1.5","ic":"gauss","scheme":"upwind"}'
                                title="Transport advection, Gaussian travelling pulse">Transport &mdash; advecting pulse</button>
                    </div>

                    <!-- Quick presets accordion (more) -->
                    <details class="ic-hero-methods" id="pde-presets-wrap">
                        <summary class="ic-hero-methods-summary">
                            <span>More presets</span>
                            <svg class="ic-hero-methods-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                        </summary>
                        <div class="ic-hero-methods-body">
                            <div id="pde-examples"></div>
                        </div>
                    </details>

                </div>

                <!-- ═══ RESULT CARD ═══ -->
                <div class="ic-result-card">
                    <div class="ic-output-tabs pde-output-tabs" role="tablist">
                        <button type="button" class="ic-output-tab pde-output-tab active" data-panel="result"  role="tab" aria-selected="true">Result</button>
                        <button type="button" class="ic-output-tab pde-output-tab"        data-panel="graph"   role="tab" aria-selected="false">3D Surface</button>
                        <button type="button" class="ic-output-tab pde-output-tab"        data-panel="contour" role="tab" aria-selected="false">Contour</button>
                        <button type="button" class="ic-output-tab pde-output-tab"        data-panel="animate" role="tab" aria-selected="false">Animate</button>
                        <button type="button" class="ic-output-tab pde-output-tab"        data-panel="python"  role="tab" aria-selected="false">Python</button>
                    </div>

                    <div class="ic-panel pde-panel active" id="pde-panel-result" role="tabpanel">
                        <div class="tool-card tool-result-card">
                            <div class="tool-result-content" id="pde-result-content">
                                <div class="tool-empty-state ic-empty-state" id="pde-empty-state">
                                    <div class="ic-empty-illustration">&#8706;&sup2;u</div>
                                    <h3>Pick a PDE type and Solve</h3>
                                    <p>Heat, wave, Laplace, Poisson, transport, and Schr&ouml;dinger &mdash; all with steps.</p>
                                </div>
                            </div>

                            <div class="tool-result-actions" id="pde-export-row" style="display:none;">
                                <button type="button" class="tool-action-btn" id="pde-copy-latex-btn">Copy LaTeX</button>
                                <button type="button" class="tool-action-btn" id="pde-share-btn">Share</button>
                                <button type="button" class="tool-action-btn" id="pde-download-pdf-btn">Download PDF</button>
                            </div>

                            <div class="ic-worksheet-cta">
                                <button type="button" class="tool-action-btn" id="pde-worksheet-btn">
                                    Practice PDE Worksheet &mdash; 2,000+ problems
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="ic-panel pde-panel" id="pde-panel-graph" role="tabpanel">
                        <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                            <div style="flex:1;min-height:360px;">
                                <div id="pde-graph-container" style="width:100%;height:100%;min-height:360px;"></div>
                                <p id="pde-graph-hint" style="text-align:center;font-size:0.8rem;color:var(--ms-muted);margin-top:0.5rem;">Solve a PDE to see the surface.</p>
                            </div>
                        </div>
                    </div>

                    <div class="ic-panel pde-panel" id="pde-panel-contour" role="tabpanel">
                        <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                            <div style="flex:1;min-height:360px;">
                                <div id="pde-contour-container" style="width:100%;height:100%;min-height:360px;"></div>
                                <p id="pde-contour-hint" style="text-align:center;font-size:0.8rem;color:var(--ms-muted);margin-top:0.5rem;">Solve a PDE to see the contour plot.</p>
                            </div>
                        </div>
                    </div>

                    <div class="ic-panel pde-panel" id="pde-panel-animate" role="tabpanel">
                        <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                            <div style="flex:1;min-height:0;">
                                <div id="pde-animate-container" style="min-height:360px;"></div>
                                <div class="pde-anim-controls" id="pde-animate-controls" style="display:none;">
                                    <button type="button" class="pde-anim-btn" id="pde-anim-play">&#9654; Play</button>
                                    <button type="button" class="pde-anim-btn" id="pde-anim-pause">&#9646;&#9646; Pause</button>
                                    <input type="range" class="pde-anim-slider" id="pde-anim-slider" min="0" max="1" step="0.01" value="0">
                                    <span class="pde-anim-time" id="pde-anim-time">t=0.00</span>
                                </div>
                                <p id="pde-animate-hint" style="text-align:center;font-size:0.8rem;color:var(--ms-muted);margin-top:0.5rem;">Solve a time-dependent PDE (Heat, Wave, Transport) to see animation.</p>
                            </div>
                        </div>
                    </div>

                    <div class="ic-panel pde-panel" id="pde-panel-python" role="tabpanel">
                        <div class="tool-card" style="height:100%;display:flex;flex-direction:column;padding:0;">
                            <div style="flex:1;min-height:0;">
                                <iframe id="pde-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="ms-inline-ad">
                <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
            </div>

        </section>

        <aside class="ms-rail" aria-label="Advertisements">
            <%@ include file="modern/ads/ad-ide-rail-top.jsp" %>
            <%@ include file="modern/ads/ad-ide-rail-bottom.jsp" %>
        </aside>
    </main>

    <!-- ═══ VISIBLE FAQ ═══ -->
    <section class="ms-faq-wrap" style="max-width:1440px;margin:2.5rem auto 0;padding:0 1.5rem;">
        <h2 class="ms-faq-title" id="faqs">Frequently asked</h2>
        <div class="ms-faq" aria-label="PDE solver FAQ">
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">Can I scan a PDE problem from a photo?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">Yes. Click the green <strong>&#128247; Scan</strong> button next to the mode chips, upload a photo or PDF, and our AI extracts the PDE type (heat, wave, Laplace, etc.), parameters, initial conditions, and boundary conditions.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">What is a partial differential equation (PDE)?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">A PDE involves a function of several variables and its partial derivatives. Three classic types: <strong>heat</strong> (diffusion), <strong>wave</strong> (propagation), <strong>Laplace</strong> (steady-state).</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">What are Dirichlet, Neumann, and Robin boundary conditions?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a"><strong>Dirichlet</strong> fixes the value <em>u = g</em> on the boundary (e.g. temperature held at the rod ends). <strong>Neumann</strong> fixes the derivative <em>du/dn = g</em> (insulated ends, no flux). <strong>Robin</strong> combines both (<em>a&middot;u + b&middot;du/dn = g</em>) for convective heat transfer. Dropdown labels in this calculator include the physical interpretation alongside the mathematical name.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">What is the CFL condition and numerical stability?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">The CFL condition ensures stability in finite difference methods. For heat: <em>r = k&middot;&Delta;t/&Delta;x&sup2; &le; 0.5</em>. For wave: <em>C = c&middot;&Delta;t/&Delta;x &le; 1</em>. Violating these blows up the numerical solution.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">What is separation of variables for PDEs?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">Assume <em>u(x,t) = X(x)&middot;T(t)</em>. Substituting separates the PDE into independent ODEs. Combined with boundary conditions, this yields eigenvalues / eigenfunctions and a Fourier series solution.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">What is the heat equation and where is it used?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a"><em>&part;u/&part;t = k&part;&sup2;u/&part;x&sup2;</em> models heat diffusion, chemical concentration spread, and Black-Scholes option pricing. Parabolic.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">What is the wave equation and where is it used?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a"><em>&part;&sup2;u/&part;t&sup2; = c&sup2;&part;&sup2;u/&part;x&sup2;</em> models vibrating strings, sound waves, electromagnetic radiation, and seismic waves. D'Alembert: <em>u(x,t) = f(x-ct) + g(x+ct)</em>. Hyperbolic.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">Is this PDE solver calculator free?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">Yes &mdash; <strong>100% free, no signup, no daily limits</strong>. Step-by-step solutions, stability analysis, 3D plots, contour, animation, AI photo scan, 2,000+ practice problems, and a Python compiler.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">Does this PDE solver include practice worksheets?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">Yes &mdash; over <strong>2,000 PDE practice problems</strong>. Filter by 48 question types and 4 difficulty levels.</div></div>
            <div class="ms-faq-item"><button type="button" class="ms-faq-q">What types of PDE problems are in the worksheet?<svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg></button><div class="ms-faq-a">48 problem types: classification (basic), separation of variables and Fourier coefficients (medium), full Fourier series (hard), and Sturm-Liouville eigenvalue problems / Green's functions / biharmonic equations (scholar).</div></div>
        </div>
    </section>

    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <footer class="page-footer">
        <div class="footer-content">
            <p class="footer-text">&copy; 2025 8gwifi.org &mdash; Free Online Tools</p>
            <div class="footer-links">
                <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
                <a href="<%=request.getContextPath()%>/math/" class="footer-link">Math</a>
                <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
            </div>
        </div>
    </footer>

    <%--
        Script load order:
          1. math-libs                  — KaTeX, plotly loader, image-to-math, tool-utils, dark-mode, search
          2. pde-solver-calculator.js   — existing controller (unchanged; reads pde-* IDs)
          3. worksheet-engine.js        — practice worksheet
          4. inline scan + worksheet wiring + quick wins (live preview, URL autofill)
    --%>
    <jsp:include page="/math/partials/math-libs.jsp" />

    <script>window.PDE_CALC_CTX = "<%=request.getContextPath()%>";</script>

    <script src="<%=request.getContextPath()%>/js/worksheet-engine.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/pde-solver-calculator.js?v=<%=cacheVersion%>"></script>

    <script>
    // ─────────────────────────────────────────────────────────────────────
    //  Quick win — live equation preview that updates with parameters
    //  Writes into #pde-preview (the consolidated div the legacy
    //  controller may also write to — our handler runs after every
    //  input/change event so it stays current).
    // ─────────────────────────────────────────────────────────────────────
    (function () {
        var preview = document.getElementById('pde-preview');
        if (!preview) return;
        function val(id, fb) { var el = document.getElementById(id); return (el && el.value) || fb; }
        function render() {
            var mode = (document.querySelector('.pde-mode-btn.active') || {}).getAttribute &&
                       document.querySelector('.pde-mode-btn.active').getAttribute('data-mode') || 'heat';
            var html = '';
            switch (mode) {
                case 'heat':
                    html = 'u<sub>t</sub> = ' + val('pde-heat-k', '1') + ' u<sub>xx</sub>' +
                           ' &nbsp;on&nbsp; (0, ' + val('pde-heat-L', '1') + ') &times; (0, ' + val('pde-heat-tmax', '0.5') + ')'; break;
                case 'wave':
                    html = 'u<sub>tt</sub> = (' + val('pde-wave-c', '1') + ')&sup2; u<sub>xx</sub>' +
                           ' &nbsp;on&nbsp; (0, ' + val('pde-wave-L', '1') + ') &times; (0, ' + val('pde-wave-tmax', '2') + ')'; break;
                case 'laplace':
                    html = 'u<sub>xx</sub> + u<sub>yy</sub> = 0 &nbsp;on&nbsp; ' + val('pde-laplace-nx', '20') + '&times;' + val('pde-laplace-ny', '20') + ' grid'; break;
                case 'poisson':
                    html = 'u<sub>xx</sub> + u<sub>yy</sub> = f(x,y) &nbsp;(' +
                           document.getElementById('pde-poisson-source').selectedOptions[0].textContent + ')'; break;
                case 'transport':
                    html = 'u<sub>t</sub> + ' + val('pde-transport-c', '1') + ' u<sub>x</sub> = 0' +
                           ' &nbsp;on&nbsp; (0, ' + val('pde-transport-L', '2') + ')'; break;
                case 'schrodinger':
                    html = '&minus;&hbar;&sup2;/2m &psi;<sub>xx</sub> + V(x)&psi; = E&psi; &nbsp;on (0, ' + val('pde-schrodinger-L', '1') + ')'; break;
                case 'linear1':
                    html = val('pde-linear1-a','1') + ' u<sub>x</sub> + ' + val('pde-linear1-b','1') + ' u<sub>y</sub> + ' +
                           val('pde-linear1-c','1') + ' u = ' + (val('pde-linear1-g','0') || '0'); break;
            }
            preview.innerHTML = html;
        }
        document.querySelectorAll('.pde-mode-btn').forEach(function (b) { b.addEventListener('click', render); });
        document.querySelectorAll('.tool-input').forEach(function (i) { i.addEventListener('input', render); i.addEventListener('change', render); });
        render();
    })();

    // ─────────────────────────────────────────────────────────────────────
    //  Quick win — URL ?mode= auto-fill
    // ─────────────────────────────────────────────────────────────────────
    (function () {
        try {
            var mode = new URL(window.location.href).searchParams.get('mode');
            if (!mode) return;
            var btn = document.querySelector('.pde-mode-btn[data-mode="' + mode + '"]');
            if (btn) btn.click();
        } catch (e) {}
    })();

    // ─────────────────────────────────────────────────────────────────────
    //  AI photo scan — PDE-specific extraction prompt
    // ─────────────────────────────────────────────────────────────────────
    (function () {
        if (typeof ImageToMath === 'undefined') return;
        var CTX = window.PDE_CALC_CTX || '';
        ImageToMath.init({
            buttonId: 'pde-scan-btn',
            aiUrl: CTX + '/ai',
            toolName: 'PDE Solver',
            extractionPrompt:
                'You are a math problem extractor for a PDE solver. The solver supports modes: heat, wave, laplace, poisson, transport, schrodinger, linear1.\n' +
                'Return a JSON array. Each object has:\n' +
                '  - "mode": one of heat | wave | laplace | poisson | transport | schrodinger | linear1\n' +
                '  - "params": mode-specific object: heat→{k,L,tmax,ic,bc}; wave→{c,L,tmax,ic,bc}; laplace→{nx,ny,bc}; poisson→{nx,ny,source,bc}; transport→{c,L,tmax,ic,scheme}; schrodinger→{L,potential,nstates}; linear1→{a,b,c,g}\n' +
                '  - "display": full PDE in LaTeX\n' +
                'Return ONLY valid JSON, no fences. Map "u_t = k u_xx" → heat, "u_tt = c^2 u_xx" → wave, "u_xx + u_yy = 0" → laplace, "u_xx + u_yy = f" → poisson, "u_t + c u_x = 0" → transport, "schrodinger" → schrodinger, "a u_x + b u_y + c u = G" → linear1.',
            onSelect: function (problem) {
                var mode = problem.mode || 'heat';
                var modeBtn = document.querySelector('.pde-mode-btn[data-mode="' + mode + '"]');
                if (modeBtn) modeBtn.click();
                var p = problem.params || {};
                function setVal(id, v) { if (v == null) return; var el = document.getElementById(id); if (el) el.value = v; }
                if (mode === 'heat')      { setVal('pde-heat-k', p.k); setVal('pde-heat-L', p.L); setVal('pde-heat-tmax', p.tmax); setVal('pde-heat-ic', p.ic); setVal('pde-heat-bc', p.bc); }
                else if (mode === 'wave') { setVal('pde-wave-c', p.c); setVal('pde-wave-L', p.L); setVal('pde-wave-tmax', p.tmax); setVal('pde-wave-ic', p.ic); setVal('pde-wave-bc', p.bc); }
                else if (mode === 'laplace')     { setVal('pde-laplace-nx', p.nx); setVal('pde-laplace-ny', p.ny); setVal('pde-laplace-bc', p.bc); }
                else if (mode === 'poisson')     { setVal('pde-poisson-nx', p.nx); setVal('pde-poisson-ny', p.ny); setVal('pde-poisson-source', p.source); setVal('pde-poisson-bc', p.bc); }
                else if (mode === 'transport')   { setVal('pde-transport-c', p.c); setVal('pde-transport-L', p.L); setVal('pde-transport-tmax', p.tmax); setVal('pde-transport-ic', p.ic); setVal('pde-transport-scheme', p.scheme); }
                else if (mode === 'schrodinger') { setVal('pde-schrodinger-L', p.L); setVal('pde-schrodinger-potential', p.potential); setVal('pde-schrodinger-nstates', p.nstates); }
                else if (mode === 'linear1')     { setVal('pde-linear1-a', p.a); setVal('pde-linear1-b', p.b); setVal('pde-linear1-c', p.c); setVal('pde-linear1-g', p.g); }
                setTimeout(function () {
                    var b = document.getElementById('pde-compute-btn'); if (b) b.click();
                }, 250);
            }
        });
    })();

    // ─────────────────────────────────────────────────────────────────────
    //  Quick win — headline preset chips above the accordion
    //  Each chip carries data-mode + data-params (JSON) for full state.
    // ─────────────────────────────────────────────────────────────────────
    (function () {
        var FIELD_MAP = {
            heat:        ['k','L','tmax','ic','bc'],
            wave:        ['c','L','tmax','ic','bc'],
            laplace:     ['nx','ny','bc'],
            poisson:     ['nx','ny','source','bc'],
            transport:   ['c','L','tmax','ic','scheme'],
            schrodinger: ['L','potential','nstates'],
            linear1:     ['a','b','c','g']
        };
        document.querySelectorAll('.ic-example-chip[data-pde-headline]').forEach(function (chip) {
            chip.addEventListener('click', function () {
                var mode = chip.getAttribute('data-mode') || 'heat';
                var params = {};
                try { params = JSON.parse(chip.getAttribute('data-params') || '{}'); } catch (e) {}

                var modeBtn = document.querySelector('.pde-mode-btn[data-mode="' + mode + '"]');
                if (modeBtn) modeBtn.click();

                (FIELD_MAP[mode] || []).forEach(function (key) {
                    if (params[key] == null) return;
                    var el = document.getElementById('pde-' + mode + '-' + key);
                    if (el) {
                        el.value = params[key];
                        el.dispatchEvent(new Event('input', { bubbles: true }));
                        el.dispatchEvent(new Event('change', { bubbles: true }));
                    }
                });

                setTimeout(function () {
                    var b = document.getElementById('pde-compute-btn'); if (b) b.click();
                }, 200);
            });
        });
    })();

    // ─────────────────────────────────────────────────────────────────────
    //  Quick win — .is-busy spinner lock on Solve button
    // ─────────────────────────────────────────────────────────────────────
    (function () {
        var btn = document.getElementById('pde-compute-btn');
        var resultContent = document.getElementById('pde-result-content');
        if (!btn || !resultContent) return;

        var resultObserver = null;
        var safetyTimer = null;

        function unlock() {
            btn.classList.remove('is-busy');
            if (resultObserver) { resultObserver.disconnect(); resultObserver = null; }
            if (safetyTimer) { clearTimeout(safetyTimer); safetyTimer = null; }
        }
        function lock() {
            if (btn.classList.contains('is-busy')) return;
            btn.classList.add('is-busy');
            if ('MutationObserver' in window) {
                resultObserver = new MutationObserver(function () { unlock(); });
                resultObserver.observe(resultContent, { childList: true, subtree: true, characterData: true });
            }
            safetyTimer = setTimeout(unlock, 30000);
        }
        btn.addEventListener('click', lock);
    })();

    // ─────────────────────────────────────────────────────────────────────
    //  Quick win — header "📝 Practice worksheet" mini-link
    // ─────────────────────────────────────────────────────────────────────
    (function () {
        var link = document.getElementById('pde-header-worksheet-link');
        if (!link) return;
        link.addEventListener('click', function (e) {
            e.preventDefault();
            if (typeof WorksheetEngine === 'undefined') return;
            var ctx = (window.PDE_CALC_CTX || '');
            WorksheetEngine.open({
                jsonUrl: ctx + '/worksheet/math/calculus/pde.json',
                title: 'PDEs',
                accentColor: '#0891b2',
                branding: '8gwifi.org',
                defaultCount: 20
            });
        });
    })();

    // ── FAQ accordion ──
    (function () {
        document.querySelectorAll('.ms-faq-q').forEach(function (q) {
            q.addEventListener('click', function () {
                q.closest('.ms-faq-item').classList.toggle('open');
            });
        });
    })();
    </script>
</body>
</html>
