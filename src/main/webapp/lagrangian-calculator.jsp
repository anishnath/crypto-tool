<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
    request.setAttribute("aiToolId", "math/lagrangian-calculator");
    request.setAttribute("aiRequireSignIn", "true");
%>
<%@ include file="modern/components/ai-assistant-vars.inc.jsp" %>
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

    <meta name="ctx" content="<%=request.getContextPath()%>" />

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdn.jsdelivr.net">
    <link rel="dns-prefetch" href="https://cdn.plot.ly">
    <link rel="dns-prefetch" href="https://d3js.org">

    <!-- SEO -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="AI Lagrangian Mechanics Calculator &mdash; Euler-Lagrange &amp; Hamiltonian" />
        <jsp:param name="toolDescription" value="AI Lagrangian mechanics calculator: describe the system in plain English (&quot;simple pendulum&quot;, &quot;mass on a cone&quot;, &quot;pendulum hanging from a spring&quot;) and AI fills in T, V, coordinates, and initial conditions. Our symbolic engine derives Euler-Lagrange equations, Hamiltonian, conservation laws, runs RK45 integration, and animates the motion. No signup." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="lagrangian-calculator.jsp" />
        <jsp:param name="toolKeywords" value="ai lagrangian calculator, lagrangian mechanics calculator, lagrangian from english, euler-lagrange equation, hamiltonian mechanics, classical mechanics, generalized coordinates, noether theorem, conservation laws, phase portrait, double pendulum, lagrangian from description, ai physics homework" />
        <jsp:param name="toolImage" value="math-studio-og.png" />
        <jsp:param name="toolFeatures" value="AI Describe-in-English (fill T V coordinates and IC from a plain sentence),Euler-Lagrange equations with steps,Hamiltonian and canonical variables,Conservation law detection,Numerical integration (RK45),D3.js system animations,Phase portraits and energy plots,7 preset mechanical systems,Live KaTeX math preview,Dark mode support,Free and no signup required" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="How does the AI input work?" />
        <jsp:param name="faq1a" value="Describe the system in plain English in the ✨ AI assistant (&quot;simple pendulum length 1m&quot;, &quot;pendulum hanging from a spring&quot;, &quot;mass on a cone&quot;). AI writes the six input strings (kinetic energy T, potential energy V, generalized coordinates, parameters, initial conditions, time span). All physics — Euler-Lagrange derivation, Hamiltonian, conservation laws, and RK45 integration — is done by our symbolic engine." />
        <jsp:param name="faq2q" value="What is the Lagrangian in mechanics?" />
        <jsp:param name="faq2a" value="The Lagrangian L is defined as the difference between kinetic energy T and potential energy V: L = T - V. It is a scalar function of generalized coordinates, their time derivatives, and time. The Lagrangian formulation provides an elegant alternative to Newtonian mechanics for deriving equations of motion." />
        <jsp:param name="faq3q" value="What is the Euler-Lagrange equation?" />
        <jsp:param name="faq3a" value="The Euler-Lagrange equation is d/dt(dL/dq_dot) - dL/dq = 0, where q is a generalized coordinate and q_dot is its time derivative. This equation yields the equations of motion for the system. For a system with n degrees of freedom, there are n Euler-Lagrange equations." />
        <jsp:param name="faq4q" value="How is the Hamiltonian related to the Lagrangian?" />
        <jsp:param name="faq4a" value="The Hamiltonian H is obtained from the Lagrangian via a Legendre transformation: H = sum(p_i * q_dot_i) - L, where p_i = dL/dq_dot_i are the conjugate momenta. For conservative systems where L does not depend explicitly on time, H equals the total energy T + V." />
        <jsp:param name="faq5q" value="What is Noether's theorem?" />
        <jsp:param name="faq5a" value="Noether's theorem states that every continuous symmetry of the Lagrangian corresponds to a conserved quantity. For example, time translation symmetry gives conservation of energy, spatial translation symmetry gives conservation of momentum, and rotational symmetry gives conservation of angular momentum." />
        <jsp:param name="faq6q" value="What are generalized coordinates?" />
        <jsp:param name="faq6a" value="Generalized coordinates are any set of independent parameters that completely describe the configuration of a mechanical system. Unlike Cartesian coordinates, they can be angles, distances, or any convenient variables. For a simple pendulum, the angle theta is a natural generalized coordinate instead of x and y." />
        <jsp:param name="faq7q" value="How does the double pendulum exhibit chaos?" />
        <jsp:param name="faq7a" value="The double pendulum is a classic example of a chaotic system. Its equations of motion are nonlinear coupled differential equations. For small oscillations it behaves predictably, but for larger amplitudes, tiny differences in initial conditions lead to dramatically different trajectories over time." />
        <jsp:param name="faq8q" value="What is a phase portrait in mechanics?" />
        <jsp:param name="faq8a" value="A phase portrait plots a system's generalized coordinate q against its conjugate momentum p (or velocity q_dot). Each point represents a complete state of the system. Trajectories in phase space reveal the system's qualitative behavior: closed orbits indicate periodic motion, fixed points indicate equilibria." />
        <jsp:param name="faq9q" value="Is this Lagrangian calculator free?" />
        <jsp:param name="faq9a" value="Yes, this calculator is completely free with no signup required. You get AI natural-language input, symbolic derivation of Euler-Lagrange equations, Hamiltonian mechanics, conservation laws, numerical integration, interactive D3 animations, and Plotly phase portraits." />
    </jsp:include>

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
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/lagrangian-calculator.css?v=<%=cacheVersion%>">

    <%@ include file="modern/components/ai-assistant-head.inc.jsp" %>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">

    <%@ include file="modern/ads/ad-init.jsp" %>

</head>
<body class="ms-body lm-page">

<%@ include file="modern/components/nav-header.jsp" %>
<jsp:include page="/math/partials/matter-bg.jsp" />

<div class="ms-hero">
    <%@ include file="modern/ads/ad-hero-banner.jsp" %>
</div>

<main class="ms-main">

    <button type="button" id="msSidebarToggle" class="ms-sidebar-toggle" aria-label="Open math tools menu">
        &#9776; Math tools
    </button>

    <% request.setAttribute("activeService", "lagrangian"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <span aria-current="page">Lagrangian Mechanics</span>
            </nav>
            <h1>Lagrangian Mechanics Calculator</h1>
            <p class="ms-subtitle">Euler-Lagrange &amp; Hamiltonian &middot; RK45 integration &middot; phase portraits &amp; D3 animation</p>
        </header>

        <div class="ic-stack">

            <div class="ic-hero ic-hero--compact lm-hero" id="lm-hero">
                <div class="ic-hero-top">
                    <div class="lm-system-row">
                        <label for="lm-system-select">Preset</label>
                        <select class="lm-system-select" id="lm-system-select" aria-label="Systems library">
                            <option value="custom">Custom System</option>
                            <option value="simple_pendulum">Simple Pendulum</option>
                            <option value="double_pendulum">Double Pendulum</option>
                            <option value="spring_mass">Spring-Mass</option>
                            <option value="kepler">Kepler Orbit</option>
                            <option value="bead_wire">Bead on Wire</option>
                            <option value="coupled_oscillators">Coupled Oscillators</option>
                            <option value="atwood">Atwood Machine</option>
                        </select>
                    </div>
                    <button type="button" class="math-ai-tab-btn" id="btnMathAI" title="Math AI — mechanics tutor + solvers (Ctrl+Shift+A)">&#10024; AI</button>
                </div>

                <div class="lm-hero-core">
                    <div class="lm-fields-grid">
                        <div class="lm-field-compact lm-input-group">
                            <label class="lm-field-label" for="lm-kinetic"><span class="lm-label-icon">T</span> Kinetic</label>
                            <input type="text" class="tool-input tool-input-mono" id="lm-kinetic" placeholder="1/2*m*l^2*dtheta^2" autocomplete="off" spellcheck="false">
                            <span class="lm-validation-hint" id="lm-kinetic-hint"></span>
                        </div>
                        <div class="lm-field-compact lm-input-group">
                            <label class="lm-field-label" for="lm-potential"><span class="lm-label-icon">V</span> Potential</label>
                            <input type="text" class="tool-input tool-input-mono" id="lm-potential" placeholder="-m*g*l*cos(theta)" autocomplete="off" spellcheck="false">
                            <span class="lm-validation-hint" id="lm-potential-hint"></span>
                        </div>
                        <div class="lm-field-compact lm-input-group">
                            <label class="lm-field-label" for="lm-coords"><span class="lm-label-icon">q</span> Coordinates</label>
                            <input type="text" class="tool-input tool-input-mono" id="lm-coords" placeholder="theta or r, theta" autocomplete="off" spellcheck="false">
                            <span class="lm-validation-hint" id="lm-coords-hint"></span>
                        </div>
                        <div class="lm-field-compact lm-input-group">
                            <label class="lm-field-label" for="lm-params"><span class="lm-label-icon">&xi;</span> Parameters</label>
                            <input type="text" class="tool-input tool-input-mono" id="lm-params" placeholder="m=1, g=9.8, l=1" autocomplete="off" spellcheck="false">
                            <span class="lm-validation-hint" id="lm-params-hint"></span>
                        </div>
                        <div class="lm-field-compact lm-input-group">
                            <label class="lm-field-label" for="lm-ic"><span class="lm-label-icon">y&#8320;</span> Initial conditions</label>
                            <input type="text" class="tool-input tool-input-mono" id="lm-ic" placeholder="theta(0)=0.3, dtheta(0)=0" autocomplete="off" spellcheck="false">
                            <span class="lm-validation-hint" id="lm-ic-hint"></span>
                        </div>
                        <div class="lm-field-compact lm-input-group">
                            <label class="lm-field-label" for="lm-tspan"><span class="lm-label-icon">t</span> Time span</label>
                            <input type="text" class="tool-input tool-input-mono" id="lm-tspan" value="0, 10" autocomplete="off" spellcheck="false">
                            <span class="lm-validation-hint" id="lm-tspan-hint"></span>
                        </div>
                    </div>

                    <div class="lm-preview-strip">
                        <span class="lm-preview-label">L = T &minus; V</span>
                        <div class="lm-preview" id="lm-preview">
                            <span style="color:var(--text-muted);font-size:0.8125rem;">Enter T and V above&hellip;</span>
                        </div>
                    </div>

                    <div class="ic-hero-cta-row lm-hero-cta-row">
                        <button type="button" class="ic-hero-cta lm-compute-btn" id="lm-compute-btn">Compute</button>
                        <button type="button" class="lm-random-btn" id="lm-random-btn" title="Random system">&#127922;</button>
                    </div>
                </div>

                <details class="ic-hero-methods" id="lm-syntax-wrap">
                    <summary class="ic-hero-methods-summary">
                        <span>Syntax help</span>
                        <svg class="ic-hero-methods-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                    </summary>
                    <div class="ic-hero-methods-body lm-syntax-body">
                        <strong>Coordinates:</strong> theta, r, x, phi &nbsp; <strong>Velocities:</strong> dtheta, dr, dx<br>
                        <strong>Powers:</strong> x^2, dtheta^2 &nbsp; <strong>Trig:</strong> sin(theta) &nbsp; <strong>Multiply:</strong> m*g*l<br>
                        <strong>Parameters:</strong> m=1, g=9.8, l=1 &nbsp; <strong>IC:</strong> theta(0)=0.3, dtheta(0)=0
                    </div>
                </details>

                <details class="ic-hero-methods" id="lm-notation-wrap">
                    <summary class="ic-hero-methods-summary">
                        <span>Notation guide</span>
                        <svg class="ic-hero-methods-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                    </summary>
                    <div class="ic-hero-methods-body lm-syntax-body">
                        <strong>L</strong> = T &minus; V &nbsp; <strong>p</strong> = &part;L/&part;q&#775; &nbsp; <strong>H</strong> = &Sigma;p<sub>i</sub>q&#775;<sub>i</sub> &minus; L<br>
                        <strong>EOM:</strong> d/dt(&part;L/&part;q&#775;) &minus; &part;L/&part;q = 0
                    </div>
                </details>
            </div>

            <div class="ic-result-card">
                <div class="lm-output-tabs" role="tablist">
                    <button type="button" class="lm-output-tab active" data-panel="steps" role="tab" aria-selected="true">Steps</button>
                    <button type="button" class="lm-output-tab" data-panel="plots" role="tab" aria-selected="false">Plots</button>
                    <button type="button" class="lm-output-tab" data-panel="animation" role="tab" aria-selected="false">Animation</button>
                    <button type="button" class="lm-output-tab" data-panel="hamiltonian" role="tab" aria-selected="false">Hamiltonian</button>
                </div>

                <div class="lm-panel active" id="lm-panel-steps" role="tabpanel">
                    <div class="tool-card tool-result-card">
                        <div class="tool-result-content" id="lm-result-content">
                            <div class="tool-empty-state" id="lm-empty-state">
                                <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#8466;</div>
                                <h3>Enter T and V, then click Compute</h3>
                                <p>Derive Euler-Lagrange equations, Hamiltonian, conservation laws, and numerical solutions.</p>
                            </div>
                        </div>
                        <div class="tool-result-actions" id="lm-result-actions">
                            <button type="button" class="tool-action-btn" id="lm-copy-latex-btn">
                                <span>&#128203;</span> Copy LaTeX
                            </button>
                            <button type="button" class="tool-action-btn" id="lm-share-btn">
                                <span>&#128279;</span> Share
                            </button>
                        </div>
                    </div>
                </div>

                <div class="lm-panel" id="lm-panel-plots" role="tabpanel">
                    <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                        <div class="lm-plot-subtabs" id="lm-plot-subtabs">
                            <button type="button" class="lm-plot-subtab active" data-plot="trajectory">q(t)</button>
                            <button type="button" class="lm-plot-subtab" data-plot="phase">Phase Portrait</button>
                            <button type="button" class="lm-plot-subtab" data-plot="energy">Energy vs Time</button>
                            <button type="button" class="lm-plot-subtab" data-plot="potential">Potential Well</button>
                        </div>
                        <div style="flex:1;min-height:360px;padding:0.75rem;">
                            <div class="lm-graph-container" id="lm-graph-container"></div>
                            <p id="lm-graph-hint" style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">Compute a system to see plots.</p>
                        </div>
                    </div>
                </div>

                <div class="lm-panel" id="lm-panel-animation" role="tabpanel">
                    <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                        <div class="lm-animation-controls" id="lm-animation-controls">
                            <button type="button" class="lm-animation-btn" id="lm-anim-play">&#9654; Play</button>
                            <button type="button" class="lm-animation-btn" id="lm-anim-pause">&#9646;&#9646; Pause</button>
                            <button type="button" class="lm-animation-btn" id="lm-anim-reset">&#8634; Reset</button>
                            <label style="font-size:0.75rem;color:var(--text-secondary);display:flex;align-items:center;gap:0.25rem;">
                                Speed:
                                <input type="range" class="lm-speed-slider" id="lm-speed-slider" min="0.25" max="4" step="0.25" value="1">
                                <span id="lm-speed-label">1x</span>
                            </label>
                            <span class="lm-time-display" id="lm-time-display">t = 0.00 s</span>
                        </div>
                        <div class="lm-animation-svg" id="lm-animation-area">
                            <p style="color:var(--text-muted);font-size:0.8125rem;">Compute a system to see the animation.</p>
                        </div>
                    </div>
                </div>

                <div class="lm-panel" id="lm-panel-hamiltonian" role="tabpanel">
                    <div class="tool-card" style="height:100%;display:flex;flex-direction:column;overflow-y:auto;">
                        <div class="tool-result-header">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                                <rect x="3" y="3" width="18" height="18" rx="2"/>
                                <path d="M9 3v18M3 9h18"/>
                            </svg>
                            <h4>Hamiltonian Mechanics</h4>
                        </div>
                        <div class="lm-hamiltonian-section" id="lm-hamiltonian-content">
                            <p style="color:var(--text-muted);font-size:0.8125rem;">Compute a system to see the Hamiltonian formulation.</p>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <div class="ms-inline-ad">
            <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
        </div>

<!-- ========== BELOW-FOLD EDUCATIONAL CONTENT ========== -->
<section class="tool-expertise-section ms-below-fold" style="max-width: 100%; margin: 2rem 0 0; padding: 0;">

    <!-- What is Lagrangian Mechanics? -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">What is Lagrangian Mechanics?</h2>
        <p style="color: var(--text-secondary); margin-bottom: 0.75rem; line-height: 1.7;">Lagrangian mechanics is a reformulation of classical mechanics introduced by Joseph-Louis Lagrange in 1788. Instead of forces and accelerations (Newton), it uses <strong>energy</strong> as the fundamental quantity. The Lagrangian <strong>L = T &minus; V</strong> (kinetic minus potential energy) encodes all the dynamics of a system.</p>
        <p style="color: var(--text-secondary); margin-bottom: 0; line-height: 1.7;">By applying the <strong>principle of least action</strong> (Hamilton's principle), we derive the <strong>Euler-Lagrange equations</strong> &mdash; the equations of motion &mdash; which are equivalent to Newton's second law but far more powerful for constrained systems, curved geometries, and systems with many degrees of freedom.</p>
    </div>

    <!-- Key Concepts -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 0.5rem; color: var(--text-primary);">Key Concepts</h2>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 1rem; margin-top: 1rem;">
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #7c3aed;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Euler-Lagrange Equation</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">d/dt(&part;L/&part;q&#775;) &minus; &part;L/&part;q = 0. This second-order ODE gives the equation of motion for each generalized coordinate q.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #8b5cf6;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Noether's Theorem</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Every continuous symmetry of the action yields a conservation law. Time invariance &rarr; energy conservation, spatial invariance &rarr; momentum conservation.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #a78bfa;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Hamiltonian Mechanics</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">H = &Sigma;p<sub>i</sub>q&#775;<sub>i</sub> &minus; L. Hamilton's equations q&#775; = &part;H/&part;p and p&#775; = &minus;&part;H/&part;q give first-order equations in phase space.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; border-left: 3px solid #c4b5fd;">
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Generalized Coordinates</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Any independent variables that fully describe a system's configuration. Constraints are built into the coordinates, eliminating constraint forces entirely.</p>
            </div>
        </div>
    </div>

    <!-- Applications -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">Applications</h2>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem;">
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#127912;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Celestial Mechanics</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Kepler orbits, three-body problem, and orbital mechanics are naturally expressed in Lagrangian form with polar coordinates.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#9881;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Robotics</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Multi-link robot arms are modeled with joint angles as generalized coordinates. Lagrangian methods handle complex constraints elegantly.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#128200;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Quantum Mechanics</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">The Lagrangian formulation underlies Feynman's path integral approach and the Standard Model of particle physics.</p>
            </div>
            <div style="background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.5rem; padding: 1.25rem; text-align: center;">
                <div style="font-size:1.5rem;margin-bottom:0.5rem;">&#128218;</div>
                <h4 style="font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.375rem;">Coupled Oscillations</h4>
                <p style="font-size: 0.8125rem; color: var(--text-secondary); line-height: 1.6; margin: 0;">Normal modes of vibration in molecules, crystals, and mechanical systems are found systematically using the Lagrangian approach.</p>
            </div>
        </div>
    </div>

    <!-- FAQ Section -->
    <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem;" id="faqs">Frequently Asked Questions</h2>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the Lagrangian in mechanics?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The Lagrangian L is defined as the difference between kinetic energy T and potential energy V: L = T - V. It is a scalar function of generalized coordinates, their time derivatives, and time. The Lagrangian formulation provides an elegant alternative to Newtonian mechanics for deriving equations of motion.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is the Euler-Lagrange equation?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The Euler-Lagrange equation is d/dt(dL/dq_dot) - dL/dq = 0, where q is a generalized coordinate and q_dot is its time derivative. This equation yields the equations of motion for the system. For a system with n degrees of freedom, there are n Euler-Lagrange equations.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How is the Hamiltonian related to the Lagrangian?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The Hamiltonian H is obtained from the Lagrangian via a Legendre transformation: H = sum(p_i * q_dot_i) - L, where p_i = dL/dq_dot_i are the conjugate momenta. For conservative systems where L does not depend explicitly on time, H equals the total energy T + V.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is Noether's theorem?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Noether's theorem states that every continuous symmetry of the Lagrangian corresponds to a conserved quantity. For example, time translation symmetry gives conservation of energy, spatial translation symmetry gives conservation of momentum, and rotational symmetry gives conservation of angular momentum.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What are generalized coordinates?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Generalized coordinates are any set of independent parameters that completely describe the configuration of a mechanical system. Unlike Cartesian coordinates, they can be angles, distances, or any convenient variables. For a simple pendulum, the angle theta is a natural generalized coordinate instead of x and y.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How does the double pendulum exhibit chaos?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The double pendulum is a classic example of a chaotic system. Its equations of motion are nonlinear coupled differential equations. For small oscillations it behaves predictably, but for larger amplitudes, tiny differences in initial conditions lead to dramatically different trajectories over time.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is a phase portrait in mechanics?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">A phase portrait plots a system's generalized coordinate q against its conjugate momentum p (or velocity q_dot). Each point represents a complete state of the system. Trajectories in phase space reveal the system's qualitative behavior: closed orbits indicate periodic motion, fixed points indicate equilibria.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Is this Lagrangian calculator free?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes, this calculator is completely free with no signup required. You get symbolic derivation of Euler-Lagrange equations, Hamiltonian mechanics, conservation laws, numerical integration, interactive D3 animations, and Plotly phase portraits.</div>
        </div>
    </div>
</section>

<!-- Explore More Math -->
<section style="max-width: 100%; margin: 2rem 0 0; padding: 0;">
    <div class="tool-card" style="padding: 1.5rem 2rem;">
        <h3 style="font-size: 1.15rem; font-weight: 600; margin: 0 0 1rem; display: flex; align-items: center; gap: 0.5rem; color: var(--text-primary);">
            <span style="font-size: 1.3rem;">&#128293;</span> Explore More Math
        </h3>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 1rem;">
            <a href="<%=request.getContextPath()%>/ode-solver-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(124,58,237,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #db2777, #f472b6); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.1rem; font-weight: 700; color: #fff;">y'</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">ODE Solver Calculator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Solve first &amp; second-order ODEs with steps and direction fields</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/inclined-plane-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(124,58,237,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #059669, #10b981); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem; color: #fff;">&#9651;</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Inclined Plane Calculator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Forces, acceleration &amp; friction on inclined planes</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/laplace-transform-calculator.jsp" style="display: flex; align-items: center; gap: 1rem; padding: 1rem; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 0.75rem; text-decoration: none; transition: all 0.2s;" onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(124,58,237,0.15)'" onmouseout="this.style.transform='';this.style.boxShadow=''">
                <div style="width: 3rem; height: 3rem; background: linear-gradient(135deg, #0891b2, #06b6d4); border-radius: 0.625rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 1.4rem; color: #fff;">&#8466;</div>
                <div>
                    <h4 style="font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); margin: 0 0 0.25rem;">Laplace Transform Calculator</h4>
                    <p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Forward &amp; inverse Laplace transforms with steps</p>
                </div>
            </a>
        </div>
    </div>
</section>

<!-- Support Section -->
<%@ include file="modern/components/support-section.jsp" %>

    </section><!-- /.ms-workspace -->

    <aside class="ms-rail" aria-label="Advertisements">
        <%@ include file="modern/ads/ad-ide-rail-top.jsp" %>
        <%@ include file="modern/ads/ad-ide-rail-bottom.jsp" %>
    </aside>
</main>

<%@ include file="modern/ads/ad-sticky-footer.jsp" %>
<%@ include file="modern/components/analytics.jsp" %>

<!-- KaTeX JS -->
<script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>

<!-- Plotly (deferred until plots tab clicked) -->
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

<!-- D3 (deferred until animation tab clicked) -->
<script>
    var __d3Loaded = false;
    function loadD3(cb) {
        if (__d3Loaded) { if (cb) cb(); return; }
        var s = document.createElement('script');
        s.src = 'https://cdn.jsdelivr.net/npm/d3@7/dist/d3.min.js';
        s.onload = function() { __d3Loaded = true; if (cb) cb(); };
        document.head.appendChild(s);
    }
</script>

<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js"></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/search.js" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/categories-menu.js" defer></script>

<script>window.LM_CALC_CTX = "<%=request.getContextPath()%>";</script>
<%@ include file="modern/components/math-calculus-cores.inc.jsp" %>
<script src="<%=request.getContextPath()%>/modern/js/lagrangian-calculator.js"></script>

<%
    request.setAttribute("mathAiButtonId", "btnMathAI");
    request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
    request.setAttribute("mathAiProfileExport", "configureLagrangianMathShell");
%>
<%@ include file="modern/components/math-ai-boot.inc.jsp" %>
<script>
(function () {
    document.querySelectorAll('.faq-question').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var item = btn.closest('.faq-item');
            if (item) item.classList.toggle('open');
        });
    });
})();
</script>

</body>
</html>
