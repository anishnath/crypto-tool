<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow">
    <meta name="googlebot" content="index,follow">
    <meta name="resource-type" content="document">
    <meta name="classification" content="tools">
    <meta name="language" content="en">
    <meta name="author" content="Anish Nath">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdn.jsdelivr.net">
    <link rel="dns-prefetch" href="https://cdn.plot.ly">

    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/pde-solver-calculator.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript><link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/pde-solver-calculator.css?v=<%=cacheVersion%>"></noscript>

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="PDE Solver Calculator &bull; With Steps &amp; 3D Graphs" />
        <jsp:param name="toolDescription" value="Free PDE solver with step-by-step solutions. Solve heat, wave, Laplace, Poisson, transport, and Schr&ouml;dinger equations. Dirichlet, Neumann, Robin boundary conditions. Contour plots, time animation, 3D surfaces. No signup." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="pde-solver-calculator.jsp" />
        <jsp:param name="toolKeywords" value="PDE solver, partial differential equation calculator, PDE solver with steps, heat equation solver, wave equation solver, Laplace equation solver, Poisson equation solver, transport equation, advection equation, Schrodinger equation solver, diffusion equation, finite difference PDE, numerical PDE solver, boundary value problem, Dirichlet boundary condition, Neumann boundary condition, Robin boundary condition, separation of variables, Fourier series PDE, 2D PDE solver, 3D PDE solver" />
        <jsp:param name="educationalLevel" value="High School, College" />
        <jsp:param name="teaches" value="Partial differential equations, heat equation, wave equation, Laplace equation, Poisson equation, transport equation, Schrodinger equation, finite difference methods, boundary conditions, separation of variables, Fourier series, numerical stability, CFL condition" />
        <jsp:param name="howToSteps" value="Select PDE type|Choose Heat, Wave, Laplace, Poisson, Transport, or Schrodinger equation,Set parameters &amp; BCs|Enter coefficients, domain size, initial/boundary conditions (Dirichlet, Neumann, Robin),Click Solve|Compute numerical solution with finite difference methods and view step-by-step breakdown,View result &amp; graph|See 3D surface, contour plot, time animation, stability info, and export options" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Heat equation (1D/2D diffusion) solver with steps,Wave equation solver with steps,Laplace equation (2D steady-state) solver,Poisson equation solver,Transport/advection equation solver,Time-independent Schrodinger equation solver,1st-order linear PDE (SymPy pdsolve),Dirichlet Neumann Robin boundary conditions,Step-by-step solution breakdown,Stability analysis (CFL Courant number),Interactive 3D surface plots,Contour/heatmap visualization,Time evolution animation,Copy LaTeX and Download PDF,Practice worksheet generator,Built-in Python compiler,Quick presets for classic problems,Dark mode support,Free and no signup required" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What is a partial differential equation (PDE)?" />
        <jsp:param name="faq1a" value="A PDE is an equation involving a function of several variables and its partial derivatives. Unlike ODEs (one independent variable), PDEs involve multiple variables. The three classic types: heat equation (diffusion), wave equation (propagation), and Laplace equation (steady-state). PDEs model phenomena in physics, engineering, and finance." />
        <jsp:param name="faq2q" value="What are Dirichlet, Neumann, and Robin boundary conditions?" />
        <jsp:param name="faq2a" value="Dirichlet BCs specify the function value on the boundary (u=g). Neumann BCs specify the derivative (du/dn=g), modeling insulated or flux boundaries. Robin (mixed) BCs combine both (a*u + b*du/dn = g), modeling convective heat transfer. The choice of BC type determines the physical problem being modeled." />
        <jsp:param name="faq3q" value="What is the CFL condition and numerical stability?" />
        <jsp:param name="faq3a" value="The CFL (Courant-Friedrichs-Lewy) condition ensures numerical stability in finite difference methods. For the heat equation, stability requires r = k*dt/dx^2 <= 0.5. For the wave equation, the Courant number C = c*dt/dx <= 1. Violating these conditions causes numerical solutions to blow up. This calculator automatically ensures stable parameters." />
        <jsp:param name="faq4q" value="What is separation of variables for PDEs?" />
        <jsp:param name="faq4a" value="Separation of variables assumes the solution is a product of single-variable functions: u(x,t) = X(x)T(t). Substituting into the PDE separates it into independent ODEs. Combined with boundary conditions, this yields eigenvalues and eigenfunctions, producing Fourier series solutions. It works for linear PDEs on simple domains." />
        <jsp:param name="faq5q" value="What is the heat equation and where is it used?" />
        <jsp:param name="faq5a" value="The heat equation du/dt = k*d2u/dx2 models heat diffusion, chemical concentration spread, and financial option pricing (Black-Scholes). k is thermal diffusivity. Solutions decay toward equilibrium. In physics: heat conduction in rods, plates, and 3D bodies. In biology: population diffusion. The equation is parabolic." />
        <jsp:param name="faq6q" value="What is the wave equation and where is it used?" />
        <jsp:param name="faq6a" value="The wave equation d2u/dt2 = c2*d2u/dx2 models vibrating strings, sound waves, electromagnetic waves, and seismic waves. c is the wave speed. Solutions preserve shape and propagate. D'Alembert's formula gives u(x,t) = f(x-ct) + g(x+ct). The equation is hyperbolic." />
        <jsp:param name="faq7q" value="What is the Poisson equation?" />
        <jsp:param name="faq7a" value="The Poisson equation nabla2(u) = f(x,y) generalizes the Laplace equation with a source term. It models gravitational potential, electrostatic potential with charge density, steady-state heat with internal generation, and pressure in fluid mechanics. When f=0, it reduces to the Laplace equation." />
        <jsp:param name="faq8q" value="Is this PDE solver calculator free?" />
        <jsp:param name="faq8a" value="Yes, completely free with no registration. Includes step-by-step solutions, stability analysis, 3D surface plots, contour plots, time animation, Dirichlet/Neumann/Robin BCs, LaTeX export, PDF download, practice worksheets, and a built-in Python compiler with NumPy and SymPy." />
    </jsp:include>

    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>

    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css">
    </noscript>

    <%@ include file="modern/ads/ad-init.jsp" %>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">
</head>
<body>
<%@ include file="modern/components/nav-header.jsp" %>

<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">PDE Solver Calculator</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/math">Math Tools</a> /
                PDE Solver Calculator
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">7 PDE Types</span>
            <span class="tool-badge">Step-by-Step</span>
            <span class="tool-badge">3D &amp; Animation</span>
            <span class="tool-badge">Free &middot; No Signup</span>
        </div>
    </div>
</header>

<section class="tool-description-section">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>Solve <strong>partial differential equations</strong> with step-by-step solutions: <strong>Heat equation</strong> (diffusion), <strong>Wave equation</strong> (propagation), <strong>Laplace equation</strong> (steady-state), <strong>Poisson equation</strong> (source term), <strong>Transport equation</strong> (advection), <strong>Schr&ouml;dinger equation</strong> (quantum), and <strong>1st-order linear PDE</strong> (SymPy). Supports <strong>Dirichlet, Neumann, Robin</strong> boundary conditions. Interactive 3D surfaces, contour plots, time animation. Built-in Python compiler.</p>
        </div>
    </div>
</section>

<main class="tool-page-container">
    <div class="tool-input-column">
        <div class="tool-card">
            <div class="tool-card-header">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;">
                    <path d="M3 3v18h18"/>
                    <path d="M18 9l-5-5-4 4-3-3"/>
                    <path d="M18 9v9"/>
                </svg>
                PDE Solver
            </div>
            <div class="tool-card-body">
                <div class="pde-mode-toggle">
                    <button type="button" class="pde-mode-btn active" data-mode="heat">Heat</button>
                    <button type="button" class="pde-mode-btn" data-mode="wave">Wave</button>
                    <button type="button" class="pde-mode-btn" data-mode="laplace">Laplace</button>
                    <button type="button" class="pde-mode-btn" data-mode="poisson">Poisson</button>
                    <button type="button" class="pde-mode-btn" data-mode="transport">Transport</button>
                    <button type="button" class="pde-mode-btn" data-mode="schrodinger">Schr&ouml;dinger</button>
                    <button type="button" class="pde-mode-btn" data-mode="linear1">1st Order</button>
                </div>

                <!-- Heat Equation -->
                <div id="pde-heat-wrap">
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="pde-heat-k">Diffusivity k</label>
                        <input type="text" class="tool-input tool-input-mono" id="pde-heat-k" value="1" placeholder="1">
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="pde-heat-L">Domain length L</label>
                        <input type="text" class="tool-input tool-input-mono" id="pde-heat-L" value="1" placeholder="1">
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="pde-heat-tmax">Max time t_max</label>
                        <input type="text" class="tool-input tool-input-mono" id="pde-heat-tmax" value="0.5" placeholder="0.5">
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label">Initial condition u(x,0)</label>
                        <select class="tool-input" id="pde-heat-ic">
                            <option value="sin">sin(&pi;x/L)</option>
                            <option value="gauss">Gaussian pulse</option>
                            <option value="step">Step (half hot)</option>
                        </select>
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label">Boundary conditions</label>
                        <select class="tool-input" id="pde-heat-bc">
                            <option value="dirichlet">Dirichlet: u(0)=0, u(L)=0</option>
                            <option value="neumann">Neumann: du/dx=0 (insulated ends)</option>
                            <option value="robin">Robin: du/dx + u = 0 (convective)</option>
                            <option value="periodic">Periodic: u(0)=u(L)</option>
                        </select>
                    </div>
                </div>

                <!-- Wave Equation -->
                <div id="pde-wave-wrap" style="display:none;">
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="pde-wave-c">Wave speed c</label>
                        <input type="text" class="tool-input tool-input-mono" id="pde-wave-c" value="1" placeholder="1">
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="pde-wave-L">Domain length L</label>
                        <input type="text" class="tool-input tool-input-mono" id="pde-wave-L" value="1" placeholder="1">
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="pde-wave-tmax">Max time t_max</label>
                        <input type="text" class="tool-input tool-input-mono" id="pde-wave-tmax" value="2" placeholder="2">
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label">Initial displacement u(x,0)</label>
                        <select class="tool-input" id="pde-wave-ic">
                            <option value="sin">sin(&pi;x/L)</option>
                            <option value="gauss">Gaussian pulse</option>
                            <option value="bump">Triangular bump</option>
                        </select>
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label">Boundary conditions</label>
                        <select class="tool-input" id="pde-wave-bc">
                            <option value="dirichlet">Dirichlet: u(0)=0, u(L)=0 (fixed ends)</option>
                            <option value="neumann">Neumann: du/dx=0 (free ends)</option>
                            <option value="mixed">Mixed: u(0)=0, du/dx(L)=0</option>
                        </select>
                    </div>
                </div>

                <!-- Laplace Equation -->
                <div id="pde-laplace-wrap" style="display:none;">
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="pde-laplace-nx">Grid size (x)</label>
                        <input type="number" class="tool-input" id="pde-laplace-nx" value="20" min="5" max="50">
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="pde-laplace-ny">Grid size (y)</label>
                        <input type="number" class="tool-input" id="pde-laplace-ny" value="20" min="5" max="50">
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label">Boundary condition</label>
                        <select class="tool-input" id="pde-laplace-bc">
                            <option value="dirichlet">Dirichlet (u=0 sides, u=1 top)</option>
                            <option value="mixed">Mixed (hot left, cold right)</option>
                            <option value="neumann_top">Neumann top (du/dy=0), Dirichlet sides</option>
                            <option value="robin">Robin (a*u + b*du/dn = 1 on top)</option>
                        </select>
                    </div>
                </div>

                <!-- Poisson Equation -->
                <div id="pde-poisson-wrap" style="display:none;">
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="pde-poisson-nx">Grid size (x)</label>
                        <input type="number" class="tool-input" id="pde-poisson-nx" value="25" min="5" max="50">
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="pde-poisson-ny">Grid size (y)</label>
                        <input type="number" class="tool-input" id="pde-poisson-ny" value="25" min="5" max="50">
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label">Source term f(x,y)</label>
                        <select class="tool-input" id="pde-poisson-source">
                            <option value="const">Constant: f = -2</option>
                            <option value="gaussian">Gaussian: f = -100 exp(-50((x-0.5)^2+(y-0.5)^2))</option>
                            <option value="sin">Sinusoidal: f = -2pi^2 sin(pi*x)sin(pi*y)</option>
                            <option value="dipole">Dipole: two point sources</option>
                        </select>
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label">Boundary conditions</label>
                        <select class="tool-input" id="pde-poisson-bc">
                            <option value="dirichlet">Dirichlet: u=0 on all edges</option>
                            <option value="neumann">Neumann: du/dn=0 on all edges</option>
                            <option value="mixed">Mixed: u=0 left/right, du/dy=0 top/bottom</option>
                        </select>
                    </div>
                </div>

                <!-- Transport Equation -->
                <div id="pde-transport-wrap" style="display:none;">
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="pde-transport-c">Advection speed c</label>
                        <input type="text" class="tool-input tool-input-mono" id="pde-transport-c" value="1" placeholder="1">
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="pde-transport-L">Domain length L</label>
                        <input type="text" class="tool-input tool-input-mono" id="pde-transport-L" value="2" placeholder="2">
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="pde-transport-tmax">Max time t_max</label>
                        <input type="text" class="tool-input tool-input-mono" id="pde-transport-tmax" value="1.5" placeholder="1.5">
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label">Initial profile u(x,0)</label>
                        <select class="tool-input" id="pde-transport-ic">
                            <option value="gauss">Gaussian pulse</option>
                            <option value="step">Step function</option>
                            <option value="sin">sin(pi*x/L)</option>
                            <option value="square">Square wave</option>
                        </select>
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label">Scheme</label>
                        <select class="tool-input" id="pde-transport-scheme">
                            <option value="upwind">Upwind (1st order)</option>
                            <option value="lax_wendroff">Lax-Wendroff (2nd order)</option>
                            <option value="lax_friedrichs">Lax-Friedrichs</option>
                        </select>
                    </div>
                </div>

                <!-- Schrodinger Equation -->
                <div id="pde-schrodinger-wrap" style="display:none;">
                    <p class="tool-form-hint" style="margin-bottom:0.75rem;">Time-independent: -&hbar;&sup2;/2m d&sup2;&psi;/dx&sup2; + V(x)&psi; = E&psi;</p>
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="pde-schrodinger-L">Well width L</label>
                        <input type="text" class="tool-input tool-input-mono" id="pde-schrodinger-L" value="1" placeholder="1">
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label">Potential V(x)</label>
                        <select class="tool-input" id="pde-schrodinger-potential">
                            <option value="infinite_well">Infinite square well (V=0 inside)</option>
                            <option value="harmonic">Harmonic oscillator (V=0.5*x^2)</option>
                            <option value="finite_well">Finite square well (V=50 outside)</option>
                            <option value="double_well">Double well potential</option>
                        </select>
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="pde-schrodinger-nstates">Number of eigenstates</label>
                        <input type="number" class="tool-input" id="pde-schrodinger-nstates" value="5" min="1" max="10">
                    </div>
                </div>

                <!-- 1st Order Linear PDE -->
                <div id="pde-linear1-wrap" style="display:none;">
                    <p class="tool-form-hint" style="margin-bottom:0.75rem;">a u<sub>x</sub> + b u<sub>y</sub> + c u = G(x,y). SymPy pdsolve for analytical solution.</p>
                    <div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:0.5rem;">
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="pde-linear1-a">a (coeff of u<sub>x</sub>)</label>
                            <input type="text" class="tool-input tool-input-mono" id="pde-linear1-a" value="1" placeholder="1">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="pde-linear1-b">b (coeff of u<sub>y</sub>)</label>
                            <input type="text" class="tool-input tool-input-mono" id="pde-linear1-b" value="1" placeholder="1">
                        </div>
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="pde-linear1-c">c (coeff of u)</label>
                            <input type="text" class="tool-input tool-input-mono" id="pde-linear1-c" value="1" placeholder="1">
                        </div>
                    </div>
                    <div class="tool-form-group">
                        <label class="tool-form-label" for="pde-linear1-g">G(x,y) right-hand side (0 for homogeneous)</label>
                        <input type="text" class="tool-input tool-input-mono" id="pde-linear1-g" value="0" placeholder="0 or exp(x+3*y)">
                        <span class="tool-form-hint">Use x, y, exp, sin, cos. e.g. 0, exp(x+y), exp(x+3*y)</span>
                    </div>
                </div>

                <div class="pde-preview" id="pde-preview">
                    <span style="color:var(--text-muted);font-size:0.8125rem;">Heat: u_t = k u_xx</span>
                </div>

                <div class="pde-action-row">
                    <button type="button" class="tool-action-btn pde-compute-btn" id="pde-compute-btn">Solve PDE</button>
                    <button type="button" class="pde-random-btn" id="pde-random-btn" title="Random preset">&#127922; Random</button>
                </div>

                <!-- Export Buttons -->
                <div class="pde-export-row" id="pde-export-row" style="display:none;">
                    <button type="button" class="pde-export-btn" id="pde-copy-latex-btn" title="Copy LaTeX">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px;"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 01-2-2V4a2 2 0 012-2h9a2 2 0 012 2v1"/></svg>
                        LaTeX
                    </button>
                    <button type="button" class="pde-export-btn" id="pde-download-pdf-btn" title="Download PDF">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px;"><path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                        PDF
                    </button>
                    <button type="button" class="pde-export-btn" id="pde-worksheet-btn" title="Practice Worksheet">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px;"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                        Worksheet
                    </button>
                    <button type="button" class="pde-export-btn" id="pde-share-btn" title="Share URL">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px;"><circle cx="18" cy="5" r="3"/><circle cx="6" cy="12" r="3"/><circle cx="18" cy="19" r="3"/><line x1="8.59" y1="13.51" x2="15.42" y2="17.49"/><line x1="15.41" y1="6.51" x2="8.59" y2="10.49"/></svg>
                        Share
                    </button>
                </div>

                <hr class="pde-sep">

                <div class="tool-form-group">
                    <label class="tool-form-label">Quick Presets</label>
                    <div class="pde-examples" id="pde-examples"></div>
                </div>

                <!-- Reference Table -->
                <div class="pde-formulas-toggle" id="pde-formulas-toggle">
                    <span>Reference: PDE Classifications</span>
                    <svg class="pde-formulas-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;transition:transform 0.2s;">
                        <polyline points="6 9 12 15 18 9"/>
                    </svg>
                </div>
                <div class="pde-formulas-content" id="pde-formulas-content" style="display:none;">
                    <table class="pde-formulas-table">
                        <thead><tr><th>Type</th><th>Equation</th><th>Method / Application</th></tr></thead>
                        <tbody>
                            <tr><td>Heat (Parabolic)</td><td id="pde-formula-f0"></td><td id="pde-formula-m0"></td></tr>
                            <tr><td>Wave (Hyperbolic)</td><td id="pde-formula-f1"></td><td id="pde-formula-m1"></td></tr>
                            <tr><td>Laplace (Elliptic)</td><td id="pde-formula-f2"></td><td id="pde-formula-m2"></td></tr>
                            <tr><td>Poisson</td><td id="pde-formula-f3"></td><td id="pde-formula-m3"></td></tr>
                            <tr><td>Transport</td><td id="pde-formula-f4"></td><td id="pde-formula-m4"></td></tr>
                            <tr><td>Schr&ouml;dinger</td><td id="pde-formula-f5"></td><td id="pde-formula-m5"></td></tr>
                            <tr><td>1st-Order Linear</td><td id="pde-formula-f6"></td><td id="pde-formula-m6"></td></tr>
                        </tbody>
                    </table>
                </div>

                <!-- Syntax Help -->
                <div class="pde-syntax-toggle" id="pde-syntax-toggle">
                    <span>Syntax Help</span>
                    <svg class="pde-formulas-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;transition:transform 0.2s;">
                        <polyline points="6 9 12 15 18 9"/>
                    </svg>
                </div>
                <div class="pde-syntax-content" id="pde-syntax-content" style="display:none;">
                    <div style="font-size:0.8125rem;color:var(--text-secondary);line-height:1.7;padding:0.75rem;">
                        <p><strong>Numeric modes</strong> (Heat, Wave, Laplace, Poisson, Transport, Schr&ouml;dinger): Select parameters from dropdowns. The solver builds the finite difference code automatically.</p>
                        <p style="margin-top:0.5rem;"><strong>1st-Order Linear</strong>: Enter coefficients a, b, c and the RHS function G(x,y). Use Python syntax: <code>exp(x+y)</code>, <code>sin(x)*cos(y)</code>, <code>x**2 + y</code>. The caret <code>^</code> is converted to <code>**</code> automatically.</p>
                        <p style="margin-top:0.5rem;"><strong>Boundary conditions</strong>: Dirichlet fixes u on boundary. Neumann fixes du/dn (derivative). Robin combines both: a*u + b*du/dn = g. Periodic wraps around.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="tool-output-column">
        <div class="pde-output-tabs">
            <button type="button" class="pde-output-tab active" data-panel="result">Result</button>
            <button type="button" class="pde-output-tab" data-panel="graph">3D Surface</button>
            <button type="button" class="pde-output-tab" data-panel="contour">Contour</button>
            <button type="button" class="pde-output-tab" data-panel="animate">Animate</button>
            <button type="button" class="pde-output-tab" data-panel="python">Python</button>
        </div>

        <div class="pde-panel active" id="pde-panel-result">
            <div class="tool-card tool-result-card">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                    </svg>
                    <h4>Result</h4>
                </div>
                <div class="tool-result-content" id="pde-result-content">
                    <div class="tool-empty-state" id="pde-empty-state">
                        <div class="pde-empty-icon">&#8706;&#178;u</div>
                        <h3>Select a PDE type and click Solve</h3>
                        <p>Solve heat, wave, Laplace, Poisson, transport, and Schr&ouml;dinger equations with step-by-step solutions.</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="pde-panel" id="pde-panel-graph">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/>
                        <line x1="6" y1="20" x2="6" y2="14"/>
                    </svg>
                    <h4>3D Surface</h4>
                </div>
                <div style="flex:1;min-height:0;padding:0.75rem;">
                    <div id="pde-graph-container"></div>
                    <p id="pde-graph-hint" style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">Solve a PDE to see the surface.</p>
                </div>
            </div>
        </div>

        <div class="pde-panel" id="pde-panel-contour">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <rect x="3" y="3" width="18" height="18" rx="2"/>
                        <circle cx="12" cy="12" r="4" opacity="0.5"/>
                        <circle cx="12" cy="12" r="2"/>
                    </svg>
                    <h4>Contour / Heatmap</h4>
                </div>
                <div style="flex:1;min-height:0;padding:0.75rem;">
                    <div id="pde-contour-container"></div>
                    <p id="pde-contour-hint" style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">Solve a PDE to see contour plot.</p>
                </div>
            </div>
        </div>

        <div class="pde-panel" id="pde-panel-animate">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <polygon points="5 3 19 12 5 21 5 3"/>
                    </svg>
                    <h4>Time Animation</h4>
                </div>
                <div style="flex:1;min-height:0;padding:0.75rem;">
                    <div id="pde-animate-container"></div>
                    <div class="pde-anim-controls" id="pde-animate-controls" style="display:none;">
                        <button type="button" class="pde-anim-btn" id="pde-anim-play">&#9654; Play</button>
                        <button type="button" class="pde-anim-btn" id="pde-anim-pause">&#9646;&#9646; Pause</button>
                        <input type="range" class="pde-anim-slider" id="pde-anim-slider" min="0" max="1" step="0.01" value="0">
                        <span class="pde-anim-time" id="pde-anim-time">t=0.00</span>
                    </div>
                    <p id="pde-animate-hint" style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">Solve a time-dependent PDE (Heat, Wave, Transport) to see animation.</p>
                </div>
            </div>
        </div>

        <div class="pde-panel" id="pde-panel-python">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <polygon points="5 3 19 12 5 21 5 3"/>
                    </svg>
                    <h4>Python Compiler</h4>
                </div>
                <div style="flex:1;min-height:0;">
                    <iframe id="pde-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                </div>
            </div>
        </div>
    </div>

    <div class="tool-ads-column">
        <%@ include file="modern/ads/ad-three-column.jsp" %>
    </div>
</main>

<div class="tool-mobile-ad-container">
    <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
</div>

<jsp:include page="modern/components/related-tools.jsp">
    <jsp:param name="currentToolUrl" value="pde-solver-calculator.jsp"/>
    <jsp:param name="keyword" value="differential"/>
    <jsp:param name="limit" value="6"/>
</jsp:include>

<!-- Educational Content -->
<section class="tool-expertise-section" style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">What is a Partial Differential Equation (PDE)?</h2>
        <p style="color: var(--text-secondary); margin-bottom: 0.75rem; line-height: 1.7;">A <strong>PDE</strong> involves a function of several variables and its partial derivatives. The three classic types are: <strong>Heat (diffusion)</strong> &part;u/&part;t = k &part;&sup2;u/&part;x&sup2;, <strong>Wave</strong> &part;&sup2;u/&part;t&sup2; = c&sup2; &part;&sup2;u/&part;x&sup2;, and <strong>Laplace</strong> &part;&sup2;u/&part;x&sup2; + &part;&sup2;u/&part;y&sup2; = 0. This calculator also handles the <strong>Poisson equation</strong> (Laplace with a source term), <strong>Transport equation</strong> (advection), and <strong>Schr&ouml;dinger equation</strong> (quantum mechanics).</p>
    </div>

    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">Boundary Conditions: Dirichlet, Neumann, Robin</h2>
        <p style="color: var(--text-secondary); margin-bottom: 0.75rem; line-height: 1.7;"><strong>Boundary conditions</strong> determine the unique solution to a PDE. <strong>Dirichlet BCs</strong> fix the function value on the boundary (e.g., temperature at the endpoints of a rod). <strong>Neumann BCs</strong> fix the derivative at the boundary (e.g., insulated ends where no heat flows out). <strong>Robin BCs</strong> combine both (e.g., convective heat transfer where heat loss is proportional to temperature difference). The choice of BC models different physical situations.</p>
    </div>

    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">Separation of Variables &amp; Fourier Series</h2>
        <p style="color: var(--text-secondary); margin-bottom: 0.75rem; line-height: 1.7;"><strong>Separation of variables</strong> is the classical method for solving linear PDEs. The idea is to assume u(x,t) = X(x)T(t), which splits the PDE into two ODEs. Combined with boundary conditions, this produces eigenvalues and eigenfunctions. The general solution is then a <strong>Fourier series</strong>: a sum of these eigenfunctions weighted by coefficients determined from the initial condition. For the heat equation on [0,L] with u=0 at both ends, the solution is u(x,t) = &sum; B_n sin(n&pi;x/L) e^(-n&sup2;&pi;&sup2;kt/L&sup2;).</p>
    </div>

    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">Finite Difference Methods &amp; Numerical Stability</h2>
        <p style="color: var(--text-secondary); margin-bottom: 0.75rem; line-height: 1.7;">This calculator uses <strong>finite difference methods</strong> to solve PDEs numerically. The domain is discretized into a grid, and derivatives are approximated by differences between neighboring grid points. For the heat equation, the <strong>stability condition</strong> is r = k&Delta;t/&Delta;x&sup2; &le; 0.5. For the wave equation, the <strong>CFL condition</strong> is C = c&Delta;t/&Delta;x &le; 1. Violating these conditions causes the numerical solution to blow up. The solver automatically chooses stable parameters and reports them in the step-by-step breakdown.</p>
    </div>

    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">PDEs in Physics: Applications</h2>
        <p style="color: var(--text-secondary); margin-bottom: 0.75rem; line-height: 1.7;">PDEs are fundamental in physics. The <strong>heat equation</strong> models thermal conduction in solids and diffusion of chemicals. The <strong>wave equation</strong> describes vibrating strings, sound waves, electromagnetic radiation, and seismic waves. The <strong>Laplace/Poisson equation</strong> governs electrostatic potential, gravitational fields, and steady-state fluid flow. The <strong>Schr&ouml;dinger equation</strong> is the foundation of quantum mechanics, determining wavefunctions and energy levels of particles. The <strong>transport equation</strong> models advection of pollutants, tracer particles, and population migration.</p>
    </div>

    <!-- Visible FAQ Accordion (matches JSON-LD FAQPage schema for CTR) -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);" id="faqs">Frequently Asked Questions</h2>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is a partial differential equation (PDE)?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">A PDE is an equation involving a function of several variables and its partial derivatives. Unlike ODEs (one independent variable), PDEs involve multiple variables. The three classic types: <strong>heat equation</strong> (diffusion), <strong>wave equation</strong> (propagation), and <strong>Laplace equation</strong> (steady-state). PDEs model phenomena in physics, engineering, and finance &mdash; from heat conduction in metals to electromagnetic wave propagation and option pricing in quantitative finance.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What are Dirichlet, Neumann, and Robin boundary conditions?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer"><strong>Dirichlet BCs</strong> specify the function value on the boundary (u=g), for example fixing the temperature at the ends of a rod. <strong>Neumann BCs</strong> specify the derivative (du/dn=g), modeling insulated or flux boundaries where no heat flows out. <strong>Robin (mixed) BCs</strong> combine both (a&middot;u + b&middot;du/dn = g), modeling convective heat transfer where heat loss is proportional to the temperature difference. The choice of BC type determines the physical problem being modeled and the uniqueness of the solution.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the CFL condition and numerical stability?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The CFL (Courant-Friedrichs-Lewy) condition ensures numerical stability in finite difference methods. For the <strong>heat equation</strong>, stability requires r = k&middot;&Delta;t/&Delta;x&sup2; &le; 0.5. For the <strong>wave equation</strong>, the Courant number C = c&middot;&Delta;t/&Delta;x &le; 1. Violating these conditions causes numerical solutions to blow up with exponentially growing errors. This calculator automatically computes stable parameters and reports the stability ratio in the step-by-step breakdown so you can verify the solution is trustworthy.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is separation of variables for PDEs?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer"><strong>Separation of variables</strong> assumes the solution is a product of single-variable functions: u(x,t) = X(x)&middot;T(t). Substituting into the PDE separates it into independent ODEs. Combined with boundary conditions, this yields eigenvalues and eigenfunctions, producing <strong>Fourier series</strong> solutions. For the heat equation on [0,L] with u=0 at both ends, the solution is u(x,t) = &sum; B<sub>n</sub> sin(n&pi;x/L) e<sup>-n&sup2;&pi;&sup2;kt/L&sup2;</sup>. It works for linear PDEs on simple domains like rectangles, circles, and spheres.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the heat equation and where is it used?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The heat equation &part;u/&part;t = k&middot;&part;&sup2;u/&part;x&sup2; models <strong>heat diffusion</strong>, chemical concentration spread, and financial option pricing (Black-Scholes). The parameter k is thermal diffusivity. Solutions decay toward equilibrium over time. In physics: heat conduction in rods, plates, and 3D bodies. In biology: population diffusion. In finance: the Black-Scholes equation for options pricing is a transformed heat equation. The equation is classified as <strong>parabolic</strong>.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the wave equation and where is it used?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The wave equation &part;&sup2;u/&part;t&sup2; = c&sup2;&middot;&part;&sup2;u/&part;x&sup2; models <strong>vibrating strings</strong>, sound waves, electromagnetic waves, and seismic waves. The parameter c is the wave speed. Solutions preserve shape and propagate without decay. D'Alembert's formula gives u(x,t) = f(x-ct) + g(x+ct), representing left- and right-traveling waves. The equation is classified as <strong>hyperbolic</strong>. Applications include musical acoustics, antenna design, earthquake engineering, and fiber optics.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the Poisson equation?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The <strong>Poisson equation</strong> &nabla;&sup2;u = f(x,y) generalizes the Laplace equation by adding a source term. It models gravitational potential with mass distribution, electrostatic potential with charge density, steady-state heat with internal generation, and pressure in incompressible fluid mechanics. When f=0, it reduces to the Laplace equation (&nabla;&sup2;u = 0). The solver uses the <strong>Jacobi iterative method</strong> on a 2D grid with configurable Dirichlet, Neumann, or mixed boundary conditions.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Is this PDE solver calculator free?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes, <strong>completely free</strong> with no registration or signup required. Features include: step-by-step solution breakdowns, numerical stability analysis (CFL/r parameter), interactive 3D surface plots, contour/heatmap visualization, time evolution animation, Dirichlet/Neumann/Robin/Periodic boundary conditions, LaTeX export, PDF download, practice worksheets, shareable URLs, and a built-in Python compiler with NumPy and SymPy. All 7 PDE types are available without any paywall or usage limits.</div>
        </div>
    </div>

    <!-- Explore More Math (Internal Linking for CTR) -->
    <div class="tool-card" style="padding: 1.5rem 2rem; margin-bottom: 1.5rem;">
        <h3 style="font-size: 1.15rem; font-weight: 600; margin: 0 0 1rem; color: var(--text-primary);">Explore More Math &amp; Science Tools</h3>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 1rem;">
            <a href="<%=request.getContextPath()%>/ode-solver-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: border-color 0.15s;">
                <div style="width: 2.5rem; height: 2.5rem; background: linear-gradient(135deg, #db2777, #f472b6); border-radius: 0.5rem; display: flex; align-items: center; justify-content: center; color: #fff; font-weight: 700; font-size: 0.75rem; flex-shrink: 0;">ODE</div>
                <div>
                    <div style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary);">ODE Solver Calculator</div>
                    <div style="font-size: 0.8125rem; color: var(--text-secondary);">1st &amp; 2nd order, direction fields, steps</div>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/derivative-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: border-color 0.15s;">
                <div style="width: 2.5rem; height: 2.5rem; background: linear-gradient(135deg, #7c3aed, #a78bfa); border-radius: 0.5rem; display: flex; align-items: center; justify-content: center; color: #fff; font-weight: 700; font-size: 0.875rem; flex-shrink: 0;">d/dx</div>
                <div>
                    <div style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary);">Derivative Calculator</div>
                    <div style="font-size: 0.8125rem; color: var(--text-secondary);">Symbolic derivatives with steps</div>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/integral-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: border-color 0.15s;">
                <div style="width: 2.5rem; height: 2.5rem; background: linear-gradient(135deg, #059669, #34d399); border-radius: 0.5rem; display: flex; align-items: center; justify-content: center; color: #fff; font-weight: 700; font-size: 1rem; flex-shrink: 0;">&int;</div>
                <div>
                    <div style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary);">Integral Calculator</div>
                    <div style="font-size: 0.8125rem; color: var(--text-secondary);">Definite &amp; indefinite integrals with steps</div>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/lagrangian-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: border-color 0.15s;">
                <div style="width: 2.5rem; height: 2.5rem; background: linear-gradient(135deg, #d97706, #fbbf24); border-radius: 0.5rem; display: flex; align-items: center; justify-content: center; color: #fff; font-weight: 700; font-size: 0.8rem; flex-shrink: 0;">L</div>
                <div>
                    <div style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary);">Lagrangian Calculator</div>
                    <div style="font-size: 0.8125rem; color: var(--text-secondary);">Euler-Lagrange, equations of motion</div>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/vector-calculus-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: border-color 0.15s;">
                <div style="width: 2.5rem; height: 2.5rem; background: linear-gradient(135deg, #2563eb, #60a5fa); border-radius: 0.5rem; display: flex; align-items: center; justify-content: center; color: #fff; font-weight: 700; font-size: 0.8rem; flex-shrink: 0;">&nabla;</div>
                <div>
                    <div style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary);">Vector Calculus Calculator</div>
                    <div style="font-size: 0.8125rem; color: var(--text-secondary);">Gradient, divergence, curl, line integrals</div>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/matrix-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: border-color 0.15s;">
                <div style="width: 2.5rem; height: 2.5rem; background: linear-gradient(135deg, #dc2626, #f87171); border-radius: 0.5rem; display: flex; align-items: center; justify-content: center; color: #fff; font-weight: 700; font-size: 0.75rem; flex-shrink: 0;">[A]</div>
                <div>
                    <div style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary);">Matrix Calculator</div>
                    <div style="font-size: 0.8125rem; color: var(--text-secondary);">Eigenvalues, inverse, determinant, SVD</div>
                </div>
            </a>
        </div>
    </div>
</section>

<%@ include file="modern/components/support-section.jsp" %>

<footer class="page-footer">
    <div class="footer-content">
        <p class="footer-text">&copy; 2025 8gwifi.org - Free Online Tools</p>
        <div class="footer-links">
            <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
            <a href="<%=request.getContextPath()%>/math/" class="footer-link">Math Tools</a>
            <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
        </div>
    </div>
</footer>

<%@ include file="modern/ads/ad-sticky-footer.jsp" %>
<%@ include file="modern/components/analytics.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
<script>
    var __plotlyLoaded = false;
    function loadPlotly(cb) {
        if (__plotlyLoaded) { if (cb) cb(); return; }
        var s = document.createElement('script');
        s.src = 'https://cdn.plot.ly/plotly-2.27.0.min.js';
        s.onload = function() { __plotlyLoaded = true; if (cb) cb(); };
        document.head.appendChild(s);
    }
</script>

<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

<script>window.PDE_CALC_CTX = "<%=request.getContextPath()%>";</script>
<script src="<%=request.getContextPath()%>/modern/js/pde-solver-calculator.js?v=<%=cacheVersion%>"></script>
</body>
</html>
