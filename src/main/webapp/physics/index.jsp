<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String cacheVersion = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Physics Calculators - Free Online Physics Tools" />
        <jsp:param name="toolCategory" value="Physics" />
        <jsp:param name="toolDescription" value="42 free physics calculators with step-by-step solutions. Calculate velocity, acceleration, force, energy, momentum, optics, waves, AC circuits, and more. Interactive visualizations for better understanding." />
        <jsp:param name="toolUrl" value="physics/" />
        <jsp:param name="toolKeywords" value="physics calculator, online physics tools, velocity calculator, acceleration calculator, force calculator, energy calculator, momentum calculator, kinematics solver, projectile motion, optics calculator, wave calculator, thermodynamics, electromagnetism, AC circuits, electromagnetic waves, modern physics" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="42 physics calculators,Step-by-step solutions,Interactive visualizations,Unit conversions,Free and instant results,No registration required,Mobile friendly,Works offline" />
        <jsp:param name="faq1q" value="Are these physics calculators free to use?" />
        <jsp:param name="faq1a" value="Yes, all 42 physics calculators are completely free. No registration, no payment, no limits. Use them as many times as you need for homework, exams, or professional work." />
        <jsp:param name="faq2q" value="Do the calculators show step-by-step solutions?" />
        <jsp:param name="faq2a" value="Yes, every calculator shows detailed step-by-step solutions explaining each formula and calculation. This helps you understand the physics concepts, not just get answers." />
        <jsp:param name="faq3q" value="What physics topics are covered?" />
        <jsp:param name="faq3a" value="We cover mechanics (kinematics, forces, energy), waves and oscillations, optics (refraction, lenses, mirrors), thermodynamics, electromagnetism (AC circuits, electromagnetic waves), and modern physics (Bohr model, relativity, photoelectric effect)." />
    </jsp:include>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- ItemList Schema for Calculator Collection -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "CollectionPage",
      "name": "Physics Calculators",
      "description": "42 free physics calculators with step-by-step solutions covering mechanics, optics, waves, thermodynamics, electromagnetism, and modern physics.",
      "url": "https://8gwifi.org/physics/",
      "mainEntity": {
        "@type": "ItemList",
        "numberOfItems": 42,
        "itemListElement": [
          {"@type": "ListItem", "position": 1, "name": "Velocity Calculator", "url": "https://8gwifi.org/physics/velocity-calculator.jsp"},
          {"@type": "ListItem", "position": 2, "name": "Acceleration Calculator", "url": "https://8gwifi.org/physics/acceleration-calculator.jsp"},
          {"@type": "ListItem", "position": 3, "name": "Force Calculator", "url": "https://8gwifi.org/physics/force-calculator.jsp"},
          {"@type": "ListItem", "position": 4, "name": "Energy Calculator", "url": "https://8gwifi.org/physics/energy-calculator.jsp"},
          {"@type": "ListItem", "position": 5, "name": "Momentum Calculator", "url": "https://8gwifi.org/physics/momentum-calculator.jsp"},
          {"@type": "ListItem", "position": 6, "name": "Projectile Motion Calculator", "url": "https://8gwifi.org/physics/projectile-motion.jsp"},
          {"@type": "ListItem", "position": 7, "name": "Kinematics Solver", "url": "https://8gwifi.org/physics/kinematics-solver.jsp"},
          {"@type": "ListItem", "position": 8, "name": "Lens Calculator", "url": "https://8gwifi.org/physics/lens-calculator.jsp"},
          {"@type": "ListItem", "position": 9, "name": "Bohr Model Calculator", "url": "https://8gwifi.org/physics/bohr-model.jsp"},
          {"@type": "ListItem", "position": 10, "name": "Thermodynamics Calculator", "url": "https://8gwifi.org/physics/thermodynamics.jsp"},
          {"@type": "ListItem", "position": 11, "name": "AC Circuits Calculator", "url": "https://8gwifi.org/physics/ac-circuits.jsp"},
          {"@type": "ListItem", "position": 12, "name": "Electromagnetic Waves", "url": "https://8gwifi.org/physics/electromagnetic-waves.jsp"}
        ]
      }
    }
    </script>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">

    <style>
        :root {
            --physics-primary: #6366f1;
            --physics-secondary: #8b5cf6;
        }

        .physics-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem 1.5rem;
        }

        /* Hero Section */
        .hero {
            background: linear-gradient(135deg, var(--physics-primary) 0%, var(--physics-secondary) 100%);
            color: white;
            padding: 2.5rem 2rem;
            border-radius: 20px;
            text-align: center;
            margin-bottom: 2.5rem;
            box-shadow: 0 20px 60px rgba(99, 102, 241, 0.25);
        }

        .hero h1 {
            font-size: 2.25rem;
            margin: 0 0 0.5rem;
            font-weight: 800;
        }

        .hero p {
            font-size: 1.05rem;
            opacity: 0.95;
            margin: 0 0 1.25rem;
        }

        .hero-stats {
            display: flex;
            justify-content: center;
            gap: 2.5rem;
            flex-wrap: wrap;
        }

        .hero-stat {
            text-align: center;
        }

        .hero-stat-value {
            font-size: 1.75rem;
            font-weight: 800;
            display: block;
        }

        .hero-stat-label {
            font-size: 0.8rem;
            opacity: 0.85;
        }

        /* Category Section */
        .category {
            margin-bottom: 2.5rem;
        }

        .category-header {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 1.25rem;
            padding-bottom: 0.75rem;
            border-bottom: 2px solid var(--border-color, #e2e8f0);
        }

        .category-icon {
            font-size: 1.5rem;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--bg-secondary, #f1f5f9);
            border-radius: 10px;
        }

        .category-header h2 {
            margin: 0;
            font-size: 1.35rem;
            font-weight: 700;
            color: var(--text-primary, #1e293b);
        }

        .category-count {
            margin-left: auto;
            background: var(--bg-secondary, #f1f5f9);
            padding: 0.3rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            color: var(--text-secondary, #64748b);
            font-weight: 600;
        }

        /* Tools Grid */
        .tools-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 1.25rem;
        }

        /* Tool Card */
        .tool-card {
            background: var(--bg-primary, #fff);
            border: 1px solid var(--border-color, #e2e8f0);
            border-radius: 14px;
            padding: 1.25rem;
            text-decoration: none;
            display: block;
            transition: all 0.2s ease;
            position: relative;
            overflow: hidden;
        }

        .tool-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: var(--card-accent, var(--physics-primary));
            transform: scaleX(0);
            transition: transform 0.2s ease;
        }

        .tool-card:hover {
            transform: translateY(-3px);
            border-color: var(--physics-primary);
            box-shadow: 0 10px 30px rgba(99, 102, 241, 0.12);
        }

        .tool-card:hover::before {
            transform: scaleX(1);
        }

        .tool-card-header {
            display: flex;
            gap: 0.875rem;
            margin-bottom: 0.625rem;
        }

        .tool-icon {
            width: 44px;
            height: 44px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.35rem;
            flex-shrink: 0;
            background: var(--icon-bg, linear-gradient(135deg, var(--physics-primary), var(--physics-secondary)));
        }

        .tool-card h3 {
            margin: 0;
            font-size: 1rem;
            font-weight: 700;
            color: var(--text-primary, #1e293b);
            line-height: 1.3;
        }

        .tool-formula {
            font-family: 'Times New Roman', Georgia, serif;
            font-size: 0.8rem;
            color: var(--text-secondary, #64748b);
            margin-top: 0.2rem;
        }

        .tool-card p {
            color: var(--text-secondary, #64748b);
            margin: 0 0 0.625rem;
            font-size: 0.875rem;
            line-height: 1.5;
        }

        .tool-badges {
            display: flex;
            gap: 0.4rem;
            flex-wrap: wrap;
        }

        .badge {
            padding: 0.2rem 0.5rem;
            border-radius: 5px;
            font-size: 0.65rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        .badge-essential { background: linear-gradient(135deg, #10b981, #14b8a6); color: white; }
        .badge-interactive { background: linear-gradient(135deg, #f59e0b, #ea580c); color: white; }
        .badge-diagrams { background: linear-gradient(135deg, #3b82f6, #6366f1); color: white; }

        /* SEO Content */
        .seo-content {
            background: var(--bg-primary, #fff);
            border: 1px solid var(--border-color, #e2e8f0);
            border-radius: 16px;
            padding: 2rem;
            margin-top: 2rem;
        }

        .seo-content h2 {
            color: var(--text-primary, #1e293b);
            margin: 0 0 1rem;
            font-size: 1.4rem;
        }

        .seo-content h3 {
            color: var(--text-primary, #1e293b);
            margin: 1.5rem 0 0.75rem;
            font-size: 1.1rem;
        }

        .seo-content p, .seo-content li {
            color: var(--text-secondary, #64748b);
            line-height: 1.7;
        }

        .formula-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
            gap: 0.75rem;
            margin: 1rem 0;
        }

        .formula-item {
            background: var(--bg-secondary, #f8fafc);
            padding: 0.875rem;
            border-radius: 10px;
            border-left: 3px solid var(--physics-primary);
        }

        .formula-item strong {
            display: block;
            color: var(--text-primary, #1e293b);
            font-size: 0.85rem;
            margin-bottom: 0.2rem;
        }

        .formula-item code {
            font-family: 'Times New Roman', Georgia, serif;
            font-size: 1.05rem;
            color: var(--physics-primary);
        }

        /* Footer */
        .physics-footer {
            background: var(--bg-primary, #fff);
            border-top: 1px solid var(--border-color, #e2e8f0);
            padding: 1.5rem;
            text-align: center;
            margin-top: 2rem;
        }

        .physics-footer p {
            color: var(--text-secondary, #64748b);
            margin: 0;
            font-size: 0.875rem;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .physics-container { padding: 1rem; }
            .hero { padding: 1.75rem 1.25rem; }
            .hero h1 { font-size: 1.5rem; }
            .hero p { font-size: 0.95rem; }
            .hero-stats { gap: 1.5rem; }
            .hero-stat-value { font-size: 1.4rem; }
            .tools-grid { grid-template-columns: 1fr; }
            .category-header h2 { font-size: 1.15rem; }
        }

        /* Dark mode support */
        [data-theme="dark"] {
            --bg-primary: #1e293b;
            --bg-secondary: #334155;
            --text-primary: #f1f5f9;
            --text-secondary: #94a3b8;
            --border-color: #475569;
        }
    </style>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <main class="physics-container">
        <!-- Hero -->
        <section class="hero">
            <h1>Physics Calculators</h1>
            <p>Free tools with step-by-step solutions and interactive visualizations</p>
            <div class="hero-stats">
                <div class="hero-stat">
                    <span class="hero-stat-value">42</span>
                    <span class="hero-stat-label">Calculators</span>
                </div>
                <div class="hero-stat">
                    <span class="hero-stat-value">100%</span>
                    <span class="hero-stat-label">Free</span>
                </div>
                <div class="hero-stat">
                    <span class="hero-stat-value">Step-by-Step</span>
                    <span class="hero-stat-label">Solutions</span>
                </div>
            </div>
        </section>

        <!-- ==================== FUNDAMENTALS ==================== -->
        <section class="category">
            <div class="category-header">
                <span class="category-icon">📐</span>
                <h2>Fundamentals</h2>
                <span class="category-count">1 tool</span>
            </div>
            <div class="tools-grid">
                <a href="<%=request.getContextPath()%>/physics/units-measurement.jsp" class="tool-card" style="--card-accent: #2563eb;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #2563eb, #4f46e5);">📐</div>
                        <div>
                            <h3>Units and Measurement</h3>
                            <div class="tool-formula">SI units, prefixes, dimensional analysis, significant figures</div>
                        </div>
                    </div>
                    <p>SI base and derived units, unit converter, dimensional analysis, significant figures calculator.</p>
                    <div class="tool-badges">
                        <span class="badge badge-essential">Essential</span>
                    </div>
                </a>
            </div>
        </section>

        <!-- ==================== MECHANICS - MOTION ==================== -->
        <section class="category">
            <div class="category-header">
                <span class="category-icon">🚀</span>
                <h2>Mechanics - Motion</h2>
                <span class="category-count">6 tools</span>
            </div>
            <div class="tools-grid">
                <a href="<%=request.getContextPath()%>/physics/velocity-calculator.jsp" class="tool-card" style="--card-accent: #6366f1;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #6366f1, #8b5cf6);">⚡</div>
                        <div>
                            <h3>Velocity Calculator</h3>
                            <div class="tool-formula">v = d/t, v = u + at</div>
                        </div>
                    </div>
                    <p>Calculate speed and velocity from distance and time with unit conversions.</p>
                    <div class="tool-badges">
                        <span class="badge badge-essential">Essential</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/physics/acceleration-calculator.jsp" class="tool-card" style="--card-accent: #ea580c;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #ea580c, #dc2626);">📈</div>
                        <div>
                            <h3>Acceleration Calculator</h3>
                            <div class="tool-formula">a = (v-u)/t, s = ut + ½at²</div>
                        </div>
                    </div>
                    <p>Calculate acceleration, final velocity, and displacement with kinematic equations.</p>
                    <div class="tool-badges">
                        <span class="badge badge-essential">Essential</span>
                        <span class="badge badge-interactive">Interactive</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/physics/kinematics-solver.jsp" class="tool-card" style="--card-accent: #10b981;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #10b981, #059669);">🧮</div>
                        <div>
                            <h3>Kinematics Solver</h3>
                            <div class="tool-formula">Enter any 3 → Solve all 5</div>
                        </div>
                    </div>
                    <p>Enter any 3 values (u, v, a, s, t) and automatically solve for the rest.</p>
                    <div class="tool-badges">
                        <span class="badge badge-essential">Essential</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/physics/projectile-motion.jsp" class="tool-card" style="--card-accent: #f59e0b;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #f59e0b, #ea580c);">🏹</div>
                        <div>
                            <h3>Projectile Motion</h3>
                            <div class="tool-formula">R = v²sin(2θ)/g, H = v²sin²θ/(2g)</div>
                        </div>
                    </div>
                    <p>Calculate trajectory, range, max height, and flight time with animated visualization.</p>
                    <div class="tool-badges">
                        <span class="badge badge-interactive">Interactive</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/physics/centripetal-force-calculator.jsp" class="tool-card" style="--card-accent: #14b8a6;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #14b8a6, #0d9488);">🔄</div>
                        <div>
                            <h3>Circular Motion</h3>
                            <div class="tool-formula">F = mv²/r, ω = v/r, T = 2πr/v</div>
                        </div>
                    </div>
                    <p>Centripetal force, angular velocity, and period for circular motion.</p>
                    <div class="tool-badges">
                        <span class="badge badge-interactive">Interactive</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/physics/torque-calculator.jsp" class="tool-card" style="--card-accent: #d97706;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #d97706, #b45309);">🔧</div>
                        <div>
                            <h3>Torque Calculator</h3>
                            <div class="tool-formula">τ = rF sin θ, τ = Iα</div>
                        </div>
                    </div>
                    <p>Calculate rotational force (moment) with lever arm visualization.</p>
                    <div class="tool-badges">
                        <span class="badge badge-diagrams">Diagrams</span>
                    </div>
                </a>
            </div>
        </section>

        <!-- ==================== MECHANICS - FORCES ==================== -->
        <section class="category">
            <div class="category-header">
                <span class="category-icon">💪</span>
                <h2>Mechanics - Forces</h2>
                <span class="category-count">4 tools</span>
            </div>
            <div class="tools-grid">
                <a href="<%=request.getContextPath()%>/physics/force-calculator.jsp" class="tool-card" style="--card-accent: #0891b2;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #0891b2, #0e7490);">💪</div>
                        <div>
                            <h3>Force Calculator (F = ma)</h3>
                            <div class="tool-formula">F = ma, W = mg, f = μN</div>
                        </div>
                    </div>
                    <p>Newton's Second Law with free body diagrams, weight, friction, and inclined planes.</p>
                    <div class="tool-badges">
                        <span class="badge badge-essential">Essential</span>
                        <span class="badge badge-diagrams">Diagrams</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/physics/momentum-calculator.jsp" class="tool-card" style="--card-accent: #db2777;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #db2777, #9333ea);">💥</div>
                        <div>
                            <h3>Momentum & Collisions</h3>
                            <div class="tool-formula">p = mv, J = FΔt, m₁u₁ + m₂u₂ = ...</div>
                        </div>
                    </div>
                    <p>Momentum, impulse, elastic and inelastic collisions.</p>
                    <div class="tool-badges">
                        <span class="badge badge-interactive">Interactive</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/physics/spring-force-calculator.jsp" class="tool-card" style="--card-accent: #a855f7;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #a855f7, #7c3aed);">🌀</div>
                        <div>
                            <h3>Spring Force (Hooke's Law)</h3>
                            <div class="tool-formula">F = -kx, PE = ½kx²</div>
                        </div>
                    </div>
                    <p>Spring force and elastic potential energy with animated spring visualization.</p>
                    <div class="tool-badges">
                        <span class="badge badge-interactive">Interactive</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/physics/gravitational-force-calculator.jsp" class="tool-card" style="--card-accent: #4f46e5;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #4f46e5, #7c3aed);">🌌</div>
                        <div>
                            <h3>Gravitational Force</h3>
                            <div class="tool-formula">F = Gm₁m₂/r², v_orbit, v_escape</div>
                        </div>
                    </div>
                    <p>Newton's Universal Gravitation, orbital and escape velocities.</p>
                </a>
            </div>
        </section>

        <!-- ==================== ENERGY & WORK ==================== -->
        <section class="category">
            <div class="category-header">
                <span class="category-icon">🔋</span>
                <h2>Energy & Work</h2>
                <span class="category-count">7 tools</span>
            </div>
            <div class="tools-grid">
                <a href="<%=request.getContextPath()%>/physics/energy-calculator.jsp" class="tool-card" style="--card-accent: #f59e0b;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #f59e0b, #d97706);">🔋</div>
                        <div>
                            <h3>Energy Calculator</h3>
                            <div class="tool-formula">KE = ½mv², PE = mgh, PE = ½kx²</div>
                        </div>
                    </div>
                    <p>Kinetic, gravitational, and elastic potential energy with conservation laws.</p>
                    <div class="tool-badges">
                        <span class="badge badge-essential">Essential</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/physics/work-power.jsp" class="tool-card" style="--card-accent: #0891b2;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #0891b2, #0d9488);">🏋️</div>
                        <div>
                            <h3>Work & Power</h3>
                            <div class="tool-formula">W = Fd cos θ, P = W/t, P = Fv</div>
                        </div>
                    </div>
                    <p>Work by force, work-energy theorem, and power calculations.</p>
                    <div class="tool-badges">
                        <span class="badge badge-essential">Essential</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/physics/electrical-energy.jsp" class="tool-card" style="--card-accent: #2563eb;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #2563eb, #7c3aed);">⚡</div>
                        <div>
                            <h3>Electrical Energy</h3>
                            <div class="tool-formula">E = VIt, E = ½CV², E = ½LI²</div>
                        </div>
                    </div>
                    <p>Electrical energy, power, capacitor and inductor energy, Joule heating.</p>
                </a>

                <a href="<%=request.getContextPath()%>/physics/thermal-energy.jsp" class="tool-card" style="--card-accent: #dc2626;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #dc2626, #ea580c);">🔥</div>
                        <div>
                            <h3>Thermal Energy</h3>
                            <div class="tool-formula">Q = mcΔT, Q = mL, η = W/Q</div>
                        </div>
                    </div>
                    <p>Sensible heat, latent heat, heat engine and Carnot efficiency.</p>
                </a>

                <a href="<%=request.getContextPath()%>/physics/thermodynamics.jsp" class="tool-card" style="--card-accent: #b91c1c;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #b91c1c, #d97706);">🌡️</div>
                        <div>
                            <h3>Thermodynamics</h3>
                            <div class="tool-formula">ΔU = Q − W, C_v, C_p, entropy, v_rms</div>
                        </div>
                    </div>
                    <p>First law, work in processes, specific heats, second law, entropy, kinetic theory.</p>
                    <div class="tool-badges">
                        <span class="badge badge-essential">Essential</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/physics/energy-conversions.jsp" class="tool-card" style="--card-accent: #059669;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #059669, #0284c7);">⚙️</div>
                        <div>
                            <h3>Energy Conversions</h3>
                            <div class="tool-formula">Battery, Motor, Generator, Solar...</div>
                        </div>
                    </div>
                    <p>Energy conversion formulas for common devices and systems.</p>
                </a>

                <a href="<%=request.getContextPath()%>/physics/kinetic-theory.jsp" class="tool-card" style="--card-accent: #22c55e;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #22c55e, #0ea5e9);">💨</div>
                        <div>
                            <h3>Kinetic Theory of Gases</h3>
                            <div class="tool-formula">P = (1/3) ρ v_rms², K.E_avg = (3/2)kT</div>
                        </div>
                    </div>
                    <p>Molecular speeds, pressure from collisions, kinetic energy-temperature relation, mean free path and diffusion.</p>
                    <div class="tool-badges">
                        <span class="badge badge-interactive">Interactive</span>
                    </div>
                </a>
            </div>
        </section>

        <!-- ==================== WAVES & OSCILLATIONS ==================== -->
        <section class="category">
            <div class="category-header">
                <span class="category-icon">🌊</span>
                <h2>Waves & Oscillations</h2>
                <span class="category-count">2 tools</span>
            </div>
            <div class="tools-grid">
                <a href="<%=request.getContextPath()%>/physics/oscillations.jsp" class="tool-card" style="--card-accent: #6366f1;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #6366f1, #ec4899);">🪤</div>
                        <div>
                            <h3>Oscillations & SHM</h3>
                            <div class="tool-formula">x = A sin(ωt + φ), T = 2π√(m/k), T = 2π√(L/g)</div>
                        </div>
                    </div>
                    <p>Simple harmonic motion: displacement, velocity, acceleration, energy, time period.</p>
                    <div class="tool-badges">
                        <span class="badge badge-essential">Essential</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/physics/wave-formulas.jsp" class="tool-card" style="--card-accent: #8b5cf6;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #8b5cf6, #6366f1);">🌊</div>
                        <div>
                            <h3>Wave Formulas</h3>
                            <div class="tool-formula">v = fλ, Doppler, Interference, Beats</div>
                        </div>
                    </div>
                    <p>Wave parameters, standing waves, Doppler effect, interference, and beats.</p>
                    <div class="tool-badges">
                        <span class="badge badge-interactive">Interactive</span>
                    </div>
                </a>
            </div>
        </section>

        <!-- ==================== OPTICS ==================== -->
        <section class="category">
            <div class="category-header">
                <span class="category-icon">🔬</span>
                <h2>Optics</h2>
                <span class="category-count">6 tools</span>
            </div>
            <div class="tools-grid">
                <a href="<%=request.getContextPath()%>/physics/refraction.jsp" class="tool-card" style="--card-accent: #0891b2;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #0891b2, #0d9488);">💧</div>
                        <div>
                            <h3>Refraction of Light</h3>
                            <div class="tool-formula">n₁ sin i = n₂ sin r, sin C = 1/n</div>
                        </div>
                    </div>
                    <p>Snell's law, apparent depth, critical angle, total internal reflection.</p>
                    <div class="tool-badges">
                        <span class="badge badge-diagrams">Ray Diagrams</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/physics/mirrors.jsp" class="tool-card" style="--card-accent: #d97706;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #d97706, #ea580c);">🪞</div>
                        <div>
                            <h3>Mirrors</h3>
                            <div class="tool-formula">1/f = 1/v + 1/u, m = -v/u</div>
                        </div>
                    </div>
                    <p>Spherical mirror formula, focal length, magnification, image analysis.</p>
                    <div class="tool-badges">
                        <span class="badge badge-diagrams">Ray Diagrams</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/physics/lens-calculator.jsp" class="tool-card" style="--card-accent: #06b6d4;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #06b6d4, #3b82f6);">🔬</div>
                        <div>
                            <h3>Lens Calculator</h3>
                            <div class="tool-formula">1/f = 1/v - 1/u, Lens maker</div>
                        </div>
                    </div>
                    <p>Thin lens formula, lens maker equation, combined lenses.</p>
                    <div class="tool-badges">
                        <span class="badge badge-diagrams">Ray Diagrams</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/physics/prism-dispersion.jsp" class="tool-card" style="--card-accent: #7c3aed;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #7c3aed, #9333ea);">🔺</div>
                        <div>
                            <h3>Prism & Dispersion</h3>
                            <div class="tool-formula">δ = i + e - A, ω = (nᵥ - nᵣ)/(n-1)</div>
                        </div>
                    </div>
                    <p>Deviation, minimum deviation, dispersive power, achromatic combination.</p>
                </a>

                <a href="<%=request.getContextPath()%>/physics/wave-optics.jsp" class="tool-card" style="--card-accent: #8b5cf6;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #8b5cf6, #a855f7);">📐</div>
                        <div>
                            <h3>Wave Optics</h3>
                            <div class="tool-formula">β = λD/d, d sin θ = nλ</div>
                        </div>
                    </div>
                    <p>Young's double slit, diffraction grating, single-slit diffraction.</p>
                    <div class="tool-badges">
                        <span class="badge badge-diagrams">Diagrams</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/physics/optical-instruments.jsp" class="tool-card" style="--card-accent: #059669;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #059669, #0d9488);">🔭</div>
                        <div>
                            <h3>Optical Instruments</h3>
                            <div class="tool-formula">Microscope, Telescope, Resolving Power</div>
                        </div>
                    </div>
                    <p>Simple/compound microscope, telescope magnification, resolving power.</p>
                </a>
            </div>
        </section>

        <!-- ==================== MATTER: SOLIDS & FLUIDS ==================== -->
        <section class="category">
            <div class="category-header">
                <span class="category-icon">🔩</span>
                <h2>Matter: Solids & Fluids</h2>
                <span class="category-count">3 tools</span>
            </div>
            <div class="tools-grid">
                <a href="<%=request.getContextPath()%>/physics/solids-elasticity.jsp" class="tool-card" style="--card-accent: #3b82f6;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #3b82f6, #6366f1);">🔩</div>
                        <div>
                            <h3>Elasticity</h3>
                            <div class="tool-formula">σ = F/A, ε = ΔL/L, Y = σ/ε</div>
                        </div>
                    </div>
                    <p>Stress, strain, Young's modulus, bulk modulus, shear modulus.</p>
                    <div class="tool-badges">
                        <span class="badge badge-interactive">Interactive</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/physics/fluids-statics.jsp" class="tool-card" style="--card-accent: #0ea5e9;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #0ea5e9, #06b6d4);">💧</div>
                        <div>
                            <h3>Fluid Statics</h3>
                            <div class="tool-formula">P = ρgh, F_b = ρVg, Pascal's Law</div>
                        </div>
                    </div>
                    <p>Pressure, hydrostatic pressure, buoyancy, Archimedes' principle.</p>
                    <div class="tool-badges">
                        <span class="badge badge-interactive">Interactive</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/physics/fluids-dynamics.jsp" class="tool-card" style="--card-accent: #10b981;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #10b981, #059669);">🌊</div>
                        <div>
                            <h3>Fluid Dynamics</h3>
                            <div class="tool-formula">A₁v₁ = A₂v₂, Bernoulli, Re</div>
                        </div>
                    </div>
                    <p>Continuity, Bernoulli's equation, viscosity, Reynolds number.</p>
                    <div class="tool-badges">
                        <span class="badge badge-interactive">Interactive</span>
                    </div>
                </a>
            </div>
        </section>

        <!-- ==================== ELECTROMAGNETISM ==================== -->
        <section class="category">
            <div class="category-header">
                <span class="category-icon">🧲</span>
                <h2>Electromagnetism</h2>
                <span class="category-count">10 tools</span>
            </div>
            <div class="tools-grid">
                <a href="<%=request.getContextPath()%>/physics/electrostatics.jsp" class="tool-card" style="--card-accent: #2563eb;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #2563eb, #7c3aed);">⚡</div>
                        <div>
                            <h3>Electrostatics</h3>
                            <div class="tool-formula">F = kq₁q₂/r², E, V, C</div>
                        </div>
                    </div>
                    <p>Coulomb's law, electric field and potential, Gauss's law, capacitor formulas.</p>
                    <div class="tool-badges">
                        <span class="badge badge-essential">Essential</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/physics/current-electricity.jsp" class="tool-card" style="--card-accent: #0ea5e9;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #0ea5e9, #f59e0b);">🔌</div>
                        <div>
                            <h3>Current Electricity</h3>
                            <div class="tool-formula">I = Q/t, V = IR, τ = RC</div>
                        </div>
                    </div>
                    <p>Current, resistivity, Ohm's law, cells, bridges, potentiometer, RC circuits.</p>
                    <div class="tool-badges">
                        <span class="badge badge-essential">Essential</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/physics/magnetism.jsp" class="tool-card" style="--card-accent: #9333ea;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #9333ea, #7c3aed);">🧲</div>
                        <div>
                            <h3>Magnetism</h3>
                            <div class="tool-formula">B = μ₀I/(2πr), F = ILB, τ = mB</div>
                        </div>
                    </div>
                    <p>Magnetic field, force on wire, torque, flux, cyclotron motion.</p>
                    <div class="tool-badges">
                        <span class="badge badge-interactive">Interactive</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/physics/electromagnetic-induction.jsp" class="tool-card" style="--card-accent: #4f46e5;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #4f46e5, #ec4899);">🔄</div>
                        <div>
                            <h3>EM Induction & AC</h3>
                            <div class="tool-formula">ε = −dΦ/dt, ε = Bℓv, X_L, X_C</div>
                        </div>
                    </div>
                    <p>Faraday's law, motional emf, inductance, AC reactance, LR & LC transients.</p>
                    <div class="tool-badges">
                        <span class="badge badge-essential">Essential</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/physics/ac-circuits.jsp" class="tool-card" style="--card-accent: #0ea5e9;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #0ea5e9, #7c3aed);">⚡</div>
                        <div>
                            <h3>Alternating Current (AC) Circuits</h3>
                            <div class="tool-formula">V_rms, Z, resonance, P = V_rms I_rms cos φ</div>
                        </div>
                    </div>
                    <p>RMS values, pure R/L/C, series RLC, resonance curves, AC power and transformers with graphs and steps.</p>
                    <div class="tool-badges">
                        <span class="badge badge-interactive">Interactive</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/physics/electromagnetic-waves.jsp" class="tool-card" style="--card-accent: #22c55e;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #22c55e, #0ea5e9);">📡</div>
                        <div>
                            <h3>Electromagnetic Waves</h3>
                            <div class="tool-formula">c = 1/√(μ₀ε₀), I = E₀²/(2μ₀c)</div>
                        </div>
                    </div>
                    <p>Speed of light, E–B relations, intensity &amp; energy density, EM spectrum bands, displacement current and radiation pressure.</p>
                    <div class="tool-badges">
                        <span class="badge badge-interactive">Interactive</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/vector-calculus-calculator.jsp" class="tool-card" style="--card-accent: #0284c7;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #0284c7, #4f46e5);">&#8711;</div>
                        <div>
                            <h3>Vector Calculus Calculator</h3>
                            <div class="tool-formula">&#8711;f, &#8711;&middot;F, &#8711;&times;F</div>
                        </div>
                    </div>
                    <p>Compute gradient, divergence, and curl with step-by-step partial derivatives, 3D visualization, and printable worksheets.</p>
                    <div class="tool-badges">
                        <span class="badge badge-essential">Essential</span>
                        <span class="badge badge-interactive">Interactive</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/laplace-transform-calculator.jsp" class="tool-card" style="--card-accent: #0891b2;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #0891b2, #06b6d4);">&#8466;</div>
                        <div>
                            <h3>Laplace Transform Calculator</h3>
                            <div class="tool-formula">L{f(t)} &harr; F(s), forward &amp; inverse</div>
                        </div>
                    </div>
                    <p>Forward and inverse Laplace transforms with step-by-step solutions, partial fractions, and transfer function analysis.</p>
                    <div class="tool-badges">
                        <span class="badge badge-essential">Essential</span>
                        <span class="badge badge-interactive">Interactive</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/fourier-transform-calculator.jsp" class="tool-card" style="--card-accent: #7c3aed;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #7c3aed, #a855f7);">&#8497;</div>
                        <div>
                            <h3>Fourier Transform Calculator</h3>
                            <div class="tool-formula">F{f(t)} &harr; F(&omega;), forward &amp; inverse</div>
                        </div>
                    </div>
                    <p>Forward and inverse Fourier transforms with step-by-step solutions, frequency domain analysis, and spectrum visualization.</p>
                    <div class="tool-badges">
                        <span class="badge badge-essential">Essential</span>
                        <span class="badge badge-interactive">Interactive</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/z-transform-calculator.jsp" class="tool-card" style="--card-accent: #059669;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #059669, #10b981);">Z</div>
                        <div>
                            <h3>Z-Transform Calculator</h3>
                            <div class="tool-formula">Z{x[n]} &harr; X(z), forward &amp; inverse</div>
                        </div>
                    </div>
                    <p>Forward and inverse Z-transforms with step-by-step solutions, ROC, and discrete stem plot visualization.</p>
                    <div class="tool-badges">
                        <span class="badge badge-essential">Essential</span>
                        <span class="badge badge-interactive">Interactive</span>
                    </div>
                </a>
            </div>
        </section>

        <!-- ==================== MODERN PHYSICS ==================== -->
        <section class="category">
            <div class="category-header">
                <span class="category-icon">⚛️</span>
                <h2>Modern Physics</h2>
                <span class="category-count">7 tools</span>
            </div>
            <div class="tools-grid">
                <a href="<%=request.getContextPath()%>/physics/photoelectric-effect.jsp" class="tool-card" style="--card-accent: #0d9488;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #0d9488, #0891b2);">☀️</div>
                        <div>
                            <h3>Photoelectric Effect</h3>
                            <div class="tool-formula">hν = φ + K_max, V₀ = K_max/e</div>
                        </div>
                    </div>
                    <p>Einstein's equation, stopping potential, work function, threshold wavelength.</p>
                    <div class="tool-badges">
                        <span class="badge badge-essential">Essential</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/physics/matter-waves.jsp" class="tool-card" style="--card-accent: #d97706;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #d97706, #ea580c);">〰️</div>
                        <div>
                            <h3>Matter Waves (de Broglie)</h3>
                            <div class="tool-formula">λ = h/p, λ = h/√(2meV)</div>
                        </div>
                    </div>
                    <p>de Broglie wavelength, phase velocity, group velocity.</p>
                </a>

                <a href="<%=request.getContextPath()%>/physics/bohr-model.jsp" class="tool-card" style="--card-accent: #059669;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #059669, #10b981);">⚛️</div>
                        <div>
                            <h3>Bohr Model</h3>
                            <div class="tool-formula">rₙ = 0.529n²/Z, Eₙ = -13.6Z²/n²</div>
                        </div>
                    </div>
                    <p>Atomic radius, energy levels, Rydberg formula, spectral series.</p>
                    <div class="tool-badges">
                        <span class="badge badge-interactive">Interactive</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/physics/uncertainty-principle.jsp" class="tool-card" style="--card-accent: #6d28d9;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #6d28d9, #7c3aed);">🎲</div>
                        <div>
                            <h3>Uncertainty Principle</h3>
                            <div class="tool-formula">Δx·Δp ≥ ℏ/2, ΔE·Δt ≥ ℏ/2</div>
                        </div>
                    </div>
                    <p>Heisenberg's position-momentum and energy-time uncertainty relations.</p>
                </a>

                <a href="<%=request.getContextPath()%>/physics/special-relativity.jsp" class="tool-card" style="--card-accent: #4f46e5;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #4f46e5, #6d28d9);">🚀</div>
                        <div>
                            <h3>Special Relativity</h3>
                            <div class="tool-formula">γ = 1/√(1-v²/c²), E = γm₀c²</div>
                        </div>
                    </div>
                    <p>Lorentz factor, time dilation, length contraction, relativistic energy.</p>
                    <div class="tool-badges">
                        <span class="badge badge-essential">Essential</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/physics/xrays.jsp" class="tool-card" style="--card-accent: #475569;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #475569, #0ea5e9);">📡</div>
                        <div>
                            <h3>X-Rays</h3>
                            <div class="tool-formula">λ_min = 12400/V, Moseley's Law</div>
                        </div>
                    </div>
                    <p>Cut-off wavelength, Moseley's law, characteristic X-rays.</p>
                </a>

                <a href="<%=request.getContextPath()%>/physics/nuclear-physics.jsp" class="tool-card" style="--card-accent: #be123c;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #be123c, #e11d48);">☢️</div>
                        <div>
                            <h3>Nuclear Physics</h3>
                            <div class="tool-formula">BE = Δm·931.5, N = N₀e^(-λt)</div>
                        </div>
                    </div>
                    <p>Binding energy, mass defect, radioactive decay, half-life, Q-value.</p>
                    <div class="tool-badges">
                        <span class="badge badge-essential">Essential</span>
                    </div>
                </a>
            </div>
        </section>

        <!-- SEO Content -->
        <section class="seo-content">
            <h2>About Physics Calculators</h2>
            <p>Our physics calculators help students, teachers, and professionals solve physics problems with detailed step-by-step solutions. Each calculator features interactive visualizations to help understand the underlying concepts.</p>

            <h3>Quick Formula Reference</h3>
            <div class="formula-grid">
                <div class="formula-item">
                    <strong>Velocity</strong>
                    <code>v = d/t</code>
                </div>
                <div class="formula-item">
                    <strong>Acceleration</strong>
                    <code>a = Δv/Δt</code>
                </div>
                <div class="formula-item">
                    <strong>Force</strong>
                    <code>F = ma</code>
                </div>
                <div class="formula-item">
                    <strong>Kinetic Energy</strong>
                    <code>KE = ½mv²</code>
                </div>
                <div class="formula-item">
                    <strong>Potential Energy</strong>
                    <code>PE = mgh</code>
                </div>
                <div class="formula-item">
                    <strong>Momentum</strong>
                    <code>p = mv</code>
                </div>
                <div class="formula-item">
                    <strong>Wave Speed</strong>
                    <code>v = fλ</code>
                </div>
                <div class="formula-item">
                    <strong>Thin Lens</strong>
                    <code>1/f = 1/v - 1/u</code>
                </div>
            </div>

            <h3>Features</h3>
            <ul>
                <li><strong>Step-by-Step Solutions:</strong> Understand the problem-solving process with detailed explanations</li>
                <li><strong>Interactive Visualizations:</strong> See physics concepts in action with animations</li>
                <li><strong>Unit Conversions:</strong> Automatic SI and Imperial unit support</li>
                <li><strong>Mobile Friendly:</strong> Works seamlessly on all devices</li>
                <li><strong>100% Free:</strong> No registration or payment required</li>
            </ul>

            <h3>For Students</h3>
            <p>Whether you're preparing for exams or doing homework, our calculators help you check your work and learn from step-by-step explanations. Covers mechanics, waves, optics, thermodynamics, electromagnetism, and modern physics.</p>

            <h3>For Teachers</h3>
            <p>Use our calculators to create example problems, demonstrate concepts visually in class, and generate practice materials. The interactive visualizations make abstract concepts tangible.</p>
        </section>
    </main>

    <footer class="physics-footer">
        <p>&copy; 2025 8gwifi.org - Free Online Physics Calculators</p>
    </footer>

    <!-- Dark Mode Toggle -->
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

    <%@ include file="../modern/components/analytics.jsp" %>
</body>
</html>
