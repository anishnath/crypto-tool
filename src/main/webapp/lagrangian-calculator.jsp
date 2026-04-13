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

    <!-- Resource Hints -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdn.jsdelivr.net">
    <link rel="dns-prefetch" href="https://cdn.plot.ly">
    <link rel="dns-prefetch" href="https://d3js.org">

    <!-- Lagrangian Calculator styles -->
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/lagrangian-calculator.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript><link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/lagrangian-calculator.css"></noscript>

    <!-- SEO -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="AI Lagrangian Mechanics Calculator &mdash; Euler-Lagrange &amp; Hamiltonian" />
        <jsp:param name="toolDescription" value="AI Lagrangian mechanics calculator: describe the system in plain English (&quot;simple pendulum&quot;, &quot;mass on a cone&quot;, &quot;pendulum hanging from a spring&quot;) and AI fills in T, V, coordinates, and initial conditions. Our symbolic engine derives Euler-Lagrange equations, Hamiltonian, conservation laws, runs RK45 integration, and animates the motion. No signup." />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolUrl" value="lagrangian-calculator.jsp" />
        <jsp:param name="toolKeywords" value="ai lagrangian calculator, lagrangian mechanics calculator, lagrangian from english, euler-lagrange equation, hamiltonian mechanics, classical mechanics, generalized coordinates, noether theorem, conservation laws, phase portrait, double pendulum, lagrangian from description, ai physics homework" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="AI Describe-in-English (fill T V coordinates and IC from a plain sentence),Euler-Lagrange equations with steps,Hamiltonian and canonical variables,Conservation law detection,Numerical integration (RK45),D3.js system animations,Phase portraits and energy plots,7 preset mechanical systems,Live KaTeX math preview,Dark mode support,Free and no signup required" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="How does the AI input work?" />
        <jsp:param name="faq1a" value="Describe the system in plain English (&quot;simple pendulum length 1m&quot;, &quot;pendulum hanging from a spring&quot;, &quot;mass on a cone&quot;) in the AI box. The AI only writes the six input strings (kinetic energy T, potential energy V, generalized coordinates, parameters, initial conditions, time span). All actual physics &mdash; deriving Euler-Lagrange equations, the Hamiltonian, conservation laws, and running RK45 numerical integration &mdash; is done by our symbolic engine. You review the parsed T/V/coords before clicking Use this, so you can catch any bad AI output before the engine runs." />
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

    <!-- Fonts -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>

    <!-- CSS - all async -->
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/design-system.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/navigation.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/search.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
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

    <!-- KaTeX -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">

</head>
<body>
<!-- Navigation -->
<%@ include file="modern/components/nav-header.jsp" %>

<!-- Page Header -->
<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">AI Lagrangian Mechanics Calculator</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/physics">Physics Tools</a> /
                Lagrangian Mechanics Calculator
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">AI-Powered</span>
            <span class="tool-badge">Step-by-Step</span>
            <span class="tool-badge">Lagrangian &amp; Hamiltonian</span>
            <span class="tool-badge">D3 Animations</span>
            <span class="tool-badge">Free &middot; No Signup</span>
        </div>
    </div>
</header>

<!-- Tool Description -->
<section class="tool-description-section">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p><strong>Describe a system in plain English</strong> (&quot;pendulum hanging from a spring&quot;, &quot;mass on a cone&quot;) and AI fills in the kinetic energy T, potential V, coordinates, and initial conditions &mdash; or type them yourself. Our symbolic engine derives <strong>Euler-Lagrange equations</strong>, the <strong>Hamiltonian</strong>, and <strong>conservation laws</strong>, runs RK45 integration, and animates the motion with phase portraits and energy plots. AI only writes the strings; every calculation is ours.</p>
        </div>
    </div>
</section>

<!-- Main Content -->
<main class="tool-page-container">
    <!-- ========== INPUT COLUMN ========== -->
    <div class="tool-input-column">
        <div class="tool-card">
            <div class="tool-card-header">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;">
                    <circle cx="12" cy="12" r="10"/>
                    <path d="M12 6v6l4 2"/>
                </svg>
                Lagrangian Mechanics
            </div>
            <div class="tool-card-body">
                <!-- AI: Describe the system in English -->
                <div class="tool-form-group lm-ai-group">
                    <label class="tool-form-label lm-ai-label">
                        <span class="lm-ai-sparkle">&#x2728;</span> Describe the system (AI)
                    </label>
                    <textarea class="tool-input lm-ai-input" id="lm-ai-input" rows="2"
                        placeholder='e.g., "simple pendulum length 1m", "mass on a cone", "pendulum hanging from a spring"'></textarea>
                    <div class="lm-ai-chip-row">
                        <button type="button" class="lm-ai-chip" onclick="lmAiChip('pendulum hanging from a spring')">pendulum+spring</button>
                        <button type="button" class="lm-ai-chip" onclick="lmAiChip('mass on a frictionless cone, half-angle 30 degrees')">cone</button>
                        <button type="button" class="lm-ai-chip" onclick="lmAiChip('bead on a parabolic wire y=x^2')">bead on wire</button>
                        <button type="button" class="lm-ai-chip" onclick="lmAiChip('particle in central 1/r^2 potential')">central force</button>
                        <button type="button" class="lm-ai-chip" onclick="lmAiChip('two masses coupled by springs in a line')">coupled</button>
                        <button type="button" class="lm-ai-chip" onclick="lmAiChip('driven damped harmonic oscillator')">driven</button>
                    </div>
                    <div class="lm-ai-actions">
                        <button type="button" class="lm-ai-go" id="lm-ai-btn">
                            <span class="lm-ai-go-label">Ask AI</span>
                            <span class="lm-ai-spinner" style="display:none;"></span>
                        </button>
                    </div>
                    <div class="lm-ai-status" id="lm-ai-status" style="display:none;"></div>
                    <div class="lm-ai-preview" id="lm-ai-preview" style="display:none;">
                        <div class="lm-ai-preview-title" id="lm-ai-preview-name">System</div>
                        <dl class="lm-ai-preview-list" id="lm-ai-preview-list"></dl>
                        <div class="lm-ai-preview-notes" id="lm-ai-preview-notes"></div>
                        <div class="lm-ai-preview-actions">
                            <button type="button" class="lm-ai-confirm" id="lm-ai-confirm">Use this &rarr;</button>
                            <button type="button" class="lm-ai-cancel" id="lm-ai-cancel">Cancel</button>
                        </div>
                    </div>
                    <p class="lm-ai-firewall">AI writes T, V, coords, and initial conditions. All physics (Euler-Lagrange, Hamiltonian, conservation laws, integration) is computed by our engine.</p>
                </div>

                <!-- Systems Library -->
                <div class="tool-form-group">
                    <label class="tool-form-label" for="lm-system-select">Systems Library</label>
                    <select class="lm-system-select" id="lm-system-select">
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

                <!-- Kinetic Energy T -->
                <div class="tool-form-group lm-input-group">
                    <label class="tool-form-label" for="lm-kinetic"><span class="lm-label-icon">T</span> Kinetic Energy</label>
                    <input type="text" class="tool-input tool-input-mono" id="lm-kinetic" placeholder="e.g. 1/2*m*l^2*dtheta^2" autocomplete="off" spellcheck="false">
                    <span class="tool-form-hint">Use dq for time derivative of q (e.g. dtheta for &theta;&#775;)</span>
                    <span class="lm-validation-hint" id="lm-kinetic-hint"></span>
                </div>

                <!-- Potential Energy V -->
                <div class="tool-form-group lm-input-group">
                    <label class="tool-form-label" for="lm-potential"><span class="lm-label-icon">V</span> Potential Energy</label>
                    <input type="text" class="tool-input tool-input-mono" id="lm-potential" placeholder="e.g. -m*g*l*cos(theta)" autocomplete="off" spellcheck="false">
                    <span class="lm-validation-hint" id="lm-potential-hint"></span>
                </div>

                <!-- Generalized Coordinates -->
                <div class="tool-form-group lm-input-group">
                    <label class="tool-form-label" for="lm-coords"><span class="lm-label-icon">q</span> Generalized Coordinates</label>
                    <input type="text" class="tool-input tool-input-mono" id="lm-coords" placeholder="e.g. theta or r, theta" autocomplete="off" spellcheck="false">
                    <span class="tool-form-hint">Comma-separated for multiple DOF</span>
                    <span class="lm-validation-hint" id="lm-coords-hint"></span>
                </div>

                <!-- Parameters -->
                <div class="tool-form-group lm-input-group">
                    <label class="tool-form-label" for="lm-params"><span class="lm-label-icon">&xi;</span> Parameters</label>
                    <input type="text" class="tool-input tool-input-mono" id="lm-params" placeholder="e.g. m=1, g=9.8, l=1" autocomplete="off" spellcheck="false">
                    <span class="lm-validation-hint" id="lm-params-hint"></span>
                </div>

                <!-- Initial Conditions -->
                <div class="tool-form-group lm-input-group">
                    <label class="tool-form-label" for="lm-ic"><span class="lm-label-icon">y&#8320;</span> Initial Conditions</label>
                    <input type="text" class="tool-input tool-input-mono" id="lm-ic" placeholder="e.g. theta(0)=0.3, dtheta(0)=0" autocomplete="off" spellcheck="false">
                    <span class="lm-validation-hint" id="lm-ic-hint"></span>
                </div>

                <!-- Time Span -->
                <div class="tool-form-group lm-input-group">
                    <label class="tool-form-label" for="lm-tspan"><span class="lm-label-icon">t</span> Time Span</label>
                    <input type="text" class="tool-input tool-input-mono" id="lm-tspan" value="0, 10" autocomplete="off" spellcheck="false">
                    <span class="lm-validation-hint" id="lm-tspan-hint"></span>
                </div>

                <!-- Live preview -->
                <div class="tool-form-group" style="margin-top:0.875rem;">
                    <label class="tool-form-label">Live Preview: L = T &minus; V</label>
                    <div class="lm-preview" id="lm-preview">
                        <span style="color:var(--text-muted);font-size:0.8125rem;">Enter T and V above&hellip;</span>
                    </div>
                </div>

                <!-- Action buttons -->
                <div class="lm-action-row">
                    <button type="button" class="tool-action-btn lm-compute-btn" id="lm-compute-btn">Compute</button>
                    <button type="button" class="lm-random-btn" id="lm-random-btn" title="Random system">&#127922; Random</button>
                </div>

                <hr class="lm-sep">

                <!-- Syntax help (collapsible) -->
                <div id="lm-syntax-wrap">
                    <button type="button" class="lm-syntax-toggle" id="lm-syntax-btn">
                        Syntax Help
                        <svg class="lm-syntax-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                    </button>
                    <div class="lm-syntax-content" id="lm-syntax-content">
                        <strong>Coordinates:</strong> theta, r, x, phi<br>
                        <strong>Velocities:</strong> dtheta, dr, dx (prefix d for time derivative)<br>
                        <strong>Powers:</strong> x^2, dtheta^2<br>
                        <strong>Trig:</strong> sin(theta), cos(phi)<br>
                        <strong>Multiplication:</strong> Use * explicitly: m*g*l not mgl<br>
                        <strong>Parameters:</strong> m=1, g=9.8, l=1, k=5<br>
                        <strong>Initial conditions:</strong> theta(0)=0.3, dtheta(0)=0
                    </div>
                </div>

                <hr class="lm-sep">

                <!-- Notation Guide (collapsible) -->
                <div id="lm-notation-wrap">
                    <button type="button" class="lm-syntax-toggle" id="lm-notation-btn">
                        Notation Guide
                        <svg class="lm-syntax-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                    </button>
                    <div class="lm-syntax-content" id="lm-notation-content">
                        <strong>L</strong> = Lagrangian = T &minus; V<br>
                        <strong>T</strong> = Kinetic energy<br>
                        <strong>V</strong> = Potential energy<br>
                        <strong>q, q&#775;</strong> = Generalized coordinate, velocity<br>
                        <strong>p</strong> = Conjugate momentum = &part;L/&part;q&#775;<br>
                        <strong>H</strong> = Hamiltonian = &Sigma;p<sub>i</sub>q&#775;<sub>i</sub> &minus; L<br>
                        <strong>EOM</strong> = d/dt(&part;L/&part;q&#775;) &minus; &part;L/&part;q = 0
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ========== OUTPUT COLUMN ========== -->
    <div class="tool-output-column">
        <!-- Tab bar -->
        <div class="lm-output-tabs">
            <button type="button" class="lm-output-tab active" data-panel="steps">Steps</button>
            <button type="button" class="lm-output-tab" data-panel="plots">Plots</button>
            <button type="button" class="lm-output-tab" data-panel="animation">Animation</button>
            <button type="button" class="lm-output-tab" data-panel="hamiltonian">Hamiltonian</button>
        </div>

        <!-- Steps Panel -->
        <div class="lm-panel active" id="lm-panel-steps">
            <div class="tool-card tool-result-card">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);">
                        <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                    </svg>
                    <h4>Euler-Lagrange Derivation</h4>
                </div>
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

        <!-- Plots Panel -->
        <div class="lm-panel" id="lm-panel-plots">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="lm-plot-subtabs" id="lm-plot-subtabs">
                    <button type="button" class="lm-plot-subtab active" data-plot="trajectory">q(t)</button>
                    <button type="button" class="lm-plot-subtab" data-plot="phase">Phase Portrait</button>
                    <button type="button" class="lm-plot-subtab" data-plot="energy">Energy vs Time</button>
                    <button type="button" class="lm-plot-subtab" data-plot="potential">Potential Well</button>
                </div>
                <div style="flex:1;min-height:0;padding:0.75rem;">
                    <div class="lm-graph-container" id="lm-graph-container"></div>
                    <p id="lm-graph-hint" style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">Compute a system to see plots.</p>
                </div>
            </div>
        </div>

        <!-- Animation Panel -->
        <div class="lm-panel" id="lm-panel-animation">
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

        <!-- Hamiltonian Panel -->
        <div class="lm-panel" id="lm-panel-hamiltonian">
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

    <!-- ========== ADS COLUMN ========== -->
    <div class="tool-ads-column">
        <%@ include file="modern/ads/ad-three-column.jsp" %>
    </div>
</main>

<!-- Mobile Ad Fallback -->
<div class="tool-mobile-ad-container">
    <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
</div>

<!-- Related Tools -->
<jsp:include page="modern/components/related-tools.jsp">
    <jsp:param name="currentToolUrl" value="lagrangian-calculator.jsp"/>
    <jsp:param name="keyword" value="physics"/>
    <jsp:param name="limit" value="6"/>
</jsp:include>

<!-- ========== BELOW-FOLD EDUCATIONAL CONTENT ========== -->
<section class="tool-expertise-section" style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">

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

<!-- Explore More Physics -->
<section style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">
    <div class="tool-card" style="padding: 1.5rem 2rem;">
        <h3 style="font-size: 1.15rem; font-weight: 600; margin: 0 0 1rem; display: flex; align-items: center; gap: 0.5rem; color: var(--text-primary);">
            <span style="font-size: 1.3rem;">&#128293;</span> Explore More Physics
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

<!-- Footer -->
<footer class="page-footer">
    <div class="footer-content">
        <p class="footer-text">&copy; 2024 8gwifi.org - Free Online Tools</p>
        <div class="footer-links">
            <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
            <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
            <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
        </div>
    </div>
</footer>

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

<script>window.LM_CALC_CTX = "<%=request.getContextPath()%>";</script>
<script src="<%=request.getContextPath()%>/modern/js/lagrangian-calculator.js"></script>
<script src="<%=request.getContextPath()%>/modern/js/lagrangian-calculator-ai.js" defer></script>

</body>
</html>
