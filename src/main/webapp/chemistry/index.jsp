<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String cacheVersion = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Chemistry Calculators - Free Online Chemistry Tools" />
        <jsp:param name="toolCategory" value="Chemistry" />
        <jsp:param name="toolDescription" value="12 free chemistry calculators with step-by-step solutions. Periodic table, electron configuration, Lewis structures, 3D molecular geometry, equation balancer, stoichiometry, molarity, thermochemistry, and more." />
        <jsp:param name="toolUrl" value="chemistry/" />
        <jsp:param name="toolKeywords" value="chemistry calculator, online chemistry tools, periodic table, electron configuration, Lewis structure, molecular geometry, equation balancer, stoichiometry, molar mass, molarity, dilution, thermochemistry, electrochemistry, VSEPR" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="12 chemistry calculators,Step-by-step solutions,Interactive visualizations,3D molecular viewer,Free and instant results,No registration required,Mobile friendly,Works offline" />
        <jsp:param name="faq1q" value="Are these chemistry calculators free to use?" />
        <jsp:param name="faq1a" value="Yes, all 12 chemistry calculators are completely free. No registration, no payment, no limits. Use them as many times as you need for homework, exams, or professional work." />
        <jsp:param name="faq2q" value="Do the calculators show step-by-step solutions?" />
        <jsp:param name="faq2a" value="Yes, every calculator shows detailed step-by-step solutions explaining each formula and calculation. This helps you understand the chemistry concepts, not just get answers." />
        <jsp:param name="faq3q" value="What chemistry topics are covered?" />
        <jsp:param name="faq3a" value="We cover atomic structure (periodic table, electron configuration, electronegativity), molecular structure (Lewis structures, 3D VSEPR geometry), reactions and stoichiometry (equation balancing, molar mass), solutions (molarity, dilution, unit conversion), and thermodynamics and electrochemistry." />
    </jsp:include>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- ItemList Schema for Calculator Collection -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "CollectionPage",
      "name": "Chemistry Calculators",
      "description": "12 free chemistry calculators with step-by-step solutions covering atomic structure, molecular geometry, stoichiometry, solutions, thermodynamics, and electrochemistry.",
      "url": "https://8gwifi.org/chemistry/",
      "mainEntity": {
        "@type": "ItemList",
        "numberOfItems": 12,
        "itemListElement": [
          {"@type": "ListItem", "position": 1, "name": "Periodic Table", "url": "https://8gwifi.org/periodic-table.jsp"},
          {"@type": "ListItem", "position": 2, "name": "Electron Configuration Calculator", "url": "https://8gwifi.org/electron-configuration-calculator.jsp"},
          {"@type": "ListItem", "position": 3, "name": "Electronegativity & Polarity Checker", "url": "https://8gwifi.org/electronegativity-polarity-checker.jsp"},
          {"@type": "ListItem", "position": 4, "name": "Lewis Structure Generator", "url": "https://8gwifi.org/lewis-structure-generator.jsp"},
          {"@type": "ListItem", "position": 5, "name": "3D Molecular Geometry Calculator", "url": "https://8gwifi.org/molecular-geometry-calculator.jsp"},
          {"@type": "ListItem", "position": 6, "name": "Chemical Equation Balancer", "url": "https://8gwifi.org/chemical-equation-balancer.jsp"},
          {"@type": "ListItem", "position": 7, "name": "Stoichiometry Calculator", "url": "https://8gwifi.org/stoichiometry-calculator.jsp"},
          {"@type": "ListItem", "position": 8, "name": "Molar Mass Calculator", "url": "https://8gwifi.org/molar-mass-calculator.jsp"},
          {"@type": "ListItem", "position": 9, "name": "Molarity & Dilution Calculator", "url": "https://8gwifi.org/molarity-dilution-calculator.jsp"},
          {"@type": "ListItem", "position": 10, "name": "Chemistry Unit Converter", "url": "https://8gwifi.org/unit-converter-chemistry.jsp"},
          {"@type": "ListItem", "position": 11, "name": "Thermochemistry Calculator", "url": "https://8gwifi.org/thermochemistry-calculator.jsp"},
          {"@type": "ListItem", "position": 12, "name": "Electrochemistry Calculator", "url": "https://8gwifi.org/electrochemistry-calculator.jsp"}
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
            --chem-primary: #059669;
            --chem-secondary: #10b981;
        }

        .chem-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem 1.5rem;
        }

        /* Hero Section */
        .hero {
            background: linear-gradient(135deg, #059669 0%, #10b981 100%);
            color: white;
            padding: 2.5rem 2rem;
            border-radius: 20px;
            text-align: center;
            margin-bottom: 2.5rem;
            box-shadow: 0 20px 60px rgba(5, 150, 105, 0.25);
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
            background: var(--card-accent, var(--chem-primary));
            transform: scaleX(0);
            transition: transform 0.2s ease;
        }

        .tool-card:hover {
            transform: translateY(-3px);
            border-color: var(--chem-primary);
            box-shadow: 0 10px 30px rgba(5, 150, 105, 0.12);
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
            background: var(--icon-bg, linear-gradient(135deg, var(--chem-primary), var(--chem-secondary)));
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
        .badge-new { background: linear-gradient(135deg, #d946ef, #a855f7); color: white; }
        .badge-3d { background: linear-gradient(135deg, #3b82f6, #6366f1); color: white; }

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
            border-left: 3px solid var(--chem-primary);
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
            color: var(--chem-primary);
        }

        /* Footer */
        .chem-footer {
            background: var(--bg-primary, #fff);
            border-top: 1px solid var(--border-color, #e2e8f0);
            padding: 1.5rem;
            text-align: center;
            margin-top: 2rem;
        }

        .chem-footer p {
            color: var(--text-secondary, #64748b);
            margin: 0;
            font-size: 0.875rem;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .chem-container { padding: 1rem; }
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

    <main class="chem-container">
        <!-- Hero -->
        <section class="hero">
            <h1>Chemistry Calculators</h1>
            <p>Free tools with step-by-step solutions and interactive visualizations</p>
            <div class="hero-stats">
                <div class="hero-stat">
                    <span class="hero-stat-value">12</span>
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

        <!-- ==================== ATOMIC STRUCTURE & PERIODIC PROPERTIES ==================== -->
        <section class="category">
            <div class="category-header">
                <span class="category-icon">&#x269B;</span>
                <h2>Atomic Structure & Periodic Properties</h2>
                <span class="category-count">3 tools</span>
            </div>
            <div class="tools-grid">
                <a href="<%=request.getContextPath()%>/periodic-table.jsp" class="tool-card" style="--card-accent: #059669;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #059669, #10b981);">&#x269B;</div>
                        <div>
                            <h3>Periodic Table</h3>
                            <div class="tool-formula">118 elements &middot; properties &middot; trends</div>
                        </div>
                    </div>
                    <p>Interactive periodic table with element properties, electron configurations, and periodic trends.</p>
                    <div class="tool-badges">
                        <span class="badge badge-essential">Essential</span>
                        <span class="badge badge-interactive">Interactive</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/electron-configuration-calculator.jsp" class="tool-card" style="--card-accent: #0891b2;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #0891b2, #06b6d4);">e&#x207B;</div>
                        <div>
                            <h3>Electron Configuration</h3>
                            <div class="tool-formula">1s&sup2; 2s&sup2; 2p&#x2076; 3s&sup2;...</div>
                        </div>
                    </div>
                    <p>Generate electron configurations, orbital diagrams, and noble gas notation for any element.</p>
                    <div class="tool-badges">
                        <span class="badge badge-essential">Essential</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/electronegativity-polarity-checker.jsp" class="tool-card" style="--card-accent: #7c3aed;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #7c3aed, #a855f7);">&delta;</div>
                        <div>
                            <h3>Electronegativity & Polarity</h3>
                            <div class="tool-formula">EN = |X&#x2090; &minus; X&#x1d07;|</div>
                        </div>
                    </div>
                    <p>Check bond polarity, electronegativity differences, and predict molecular polarity.</p>
                    <div class="tool-badges">
                        <span class="badge badge-interactive">Interactive</span>
                    </div>
                </a>
            </div>
        </section>

        <!-- ==================== MOLECULAR STRUCTURE ==================== -->
        <section class="category">
            <div class="category-header">
                <span class="category-icon">&#x1F9EA;</span>
                <h2>Molecular Structure</h2>
                <span class="category-count">2 tools</span>
            </div>
            <div class="tools-grid">
                <a href="<%=request.getContextPath()%>/lewis-structure-generator.jsp" class="tool-card" style="--card-accent: #2563eb;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #2563eb, #3b82f6);">&#x1F517;</div>
                        <div>
                            <h3>Lewis Structure Generator</h3>
                            <div class="tool-formula">Octet rule &middot; lone pairs &middot; formal charge</div>
                        </div>
                    </div>
                    <p>Draw Lewis dot structures with bond pairs, lone pairs, formal charges, and resonance structures.</p>
                    <div class="tool-badges">
                        <span class="badge badge-interactive">Interactive</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/molecular-geometry-calculator.jsp" class="tool-card" style="--card-accent: #4f46e5;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #4f46e5, #6366f1);">&#x1F4D0;</div>
                        <div>
                            <h3>3D Molecular Geometry</h3>
                            <div class="tool-formula">VSEPR &middot; bond angles &middot; hybridization</div>
                        </div>
                    </div>
                    <p>Predict molecular shapes using VSEPR theory with interactive 3D visualization and bond angles.</p>
                    <div class="tool-badges">
                        <span class="badge badge-interactive">Interactive</span>
                        <span class="badge badge-3d">3D</span>
                    </div>
                </a>
            </div>
        </section>

        <!-- ==================== REACTIONS & STOICHIOMETRY ==================== -->
        <section class="category">
            <div class="category-header">
                <span class="category-icon">&#x2696;</span>
                <h2>Reactions & Stoichiometry</h2>
                <span class="category-count">3 tools</span>
            </div>
            <div class="tools-grid">
                <a href="<%=request.getContextPath()%>/chemical-equation-balancer.jsp" class="tool-card" style="--card-accent: #d946ef;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #d946ef, #a855f7);">&#x2696;</div>
                        <div>
                            <h3>Chemical Equation Balancer</h3>
                            <div class="tool-formula">Atom matrix &middot; algebraic balancing</div>
                        </div>
                    </div>
                    <p>Balance chemical equations instantly with step-by-step explanation of the balancing process.</p>
                    <div class="tool-badges">
                        <span class="badge badge-new">NEW</span>
                        <span class="badge badge-essential">Steps</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/stoichiometry-calculator.jsp" class="tool-card" style="--card-accent: #059669;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #059669, #10b981);">&#x1F9EA;</div>
                        <div>
                            <h3>Stoichiometry Calculator</h3>
                            <div class="tool-formula">mol = g / M</div>
                        </div>
                    </div>
                    <p>Calculate moles, mass, and limiting reagents with mole ratio conversions.</p>
                    <div class="tool-badges">
                        <span class="badge badge-essential">Essential</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/molar-mass-calculator.jsp" class="tool-card" style="--card-accent: #0891b2;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #0891b2, #06b6d4);">&#x2697;</div>
                        <div>
                            <h3>Molar Mass Calculator</h3>
                            <div class="tool-formula">M = &Sigma;(A&#x1D63; &times; n)</div>
                        </div>
                    </div>
                    <p>Calculate the molar mass of any chemical formula with element-by-element breakdown.</p>
                    <div class="tool-badges">
                        <span class="badge badge-essential">Essential</span>
                    </div>
                </a>
            </div>
        </section>

        <!-- ==================== SOLUTIONS & CONCENTRATIONS ==================== -->
        <section class="category">
            <div class="category-header">
                <span class="category-icon">&#x1F9EA;</span>
                <h2>Solutions & Concentrations</h2>
                <span class="category-count">2 tools</span>
            </div>
            <div class="tools-grid">
                <a href="<%=request.getContextPath()%>/molarity-dilution-calculator.jsp" class="tool-card" style="--card-accent: #059669;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #059669, #10b981);">&#x1F9EA;</div>
                        <div>
                            <h3>Molarity & Dilution</h3>
                            <div class="tool-formula">M&#x2081;V&#x2081; = M&#x2082;V&#x2082;</div>
                        </div>
                    </div>
                    <p>Calculate molarity, perform dilution calculations, and convert between concentration units.</p>
                    <div class="tool-badges">
                        <span class="badge badge-essential">Essential</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/unit-converter-chemistry.jsp" class="tool-card" style="--card-accent: #0d9488;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #0d9488, #14b8a6);">&#x1F504;</div>
                        <div>
                            <h3>Chemistry Unit Converter</h3>
                            <div class="tool-formula">mol, g, L, M conversions</div>
                        </div>
                    </div>
                    <p>Convert between moles, grams, liters, and molarity with support for common chemistry units.</p>
                    <div class="tool-badges">
                        <span class="badge badge-essential">Essential</span>
                    </div>
                </a>
            </div>
        </section>

        <!-- ==================== THERMODYNAMICS & ELECTROCHEMISTRY ==================== -->
        <section class="category">
            <div class="category-header">
                <span class="category-icon">&#x1F525;</span>
                <h2>Thermodynamics & Electrochemistry</h2>
                <span class="category-count">2 tools</span>
            </div>
            <div class="tools-grid">
                <a href="<%=request.getContextPath()%>/thermochemistry-calculator.jsp" class="tool-card" style="--card-accent: #dc2626;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #dc2626, #ea580c);">&#x1F525;</div>
                        <div>
                            <h3>Thermochemistry Calculator</h3>
                            <div class="tool-formula">&Delta;G = &Delta;H &minus; T&Delta;S</div>
                        </div>
                    </div>
                    <p>Calculate enthalpy, entropy, Gibbs free energy, and predict reaction spontaneity.</p>
                    <div class="tool-badges">
                        <span class="badge badge-essential">Essential</span>
                    </div>
                </a>

                <a href="<%=request.getContextPath()%>/electrochemistry-calculator.jsp" class="tool-card" style="--card-accent: #f59e0b;">
                    <div class="tool-card-header">
                        <div class="tool-icon" style="background: linear-gradient(135deg, #f59e0b, #d97706);">&#x1F50B;</div>
                        <div>
                            <h3>Electrochemistry Calculator</h3>
                            <div class="tool-formula">E&deg; = E&deg;&#x1D9C; &minus; E&deg;&#x2090;</div>
                        </div>
                    </div>
                    <p>Calculate cell potential, Nernst equation, Faraday's laws, and galvanic cell properties.</p>
                    <div class="tool-badges">
                        <span class="badge badge-interactive">Interactive</span>
                    </div>
                </a>
            </div>
        </section>

        <!-- SEO Content -->
        <section class="seo-content">
            <h2>About Chemistry Calculators</h2>
            <p>Our chemistry calculators help students, teachers, and professionals solve chemistry problems with detailed step-by-step solutions. From atomic structure to electrochemistry, each tool features interactive visualizations to help understand the underlying concepts.</p>

            <h3>Quick Formula Reference</h3>
            <div class="formula-grid">
                <div class="formula-item">
                    <strong>Molar Mass</strong>
                    <code>M = &Sigma;(A&#x1D63; &times; n)</code>
                </div>
                <div class="formula-item">
                    <strong>Molarity</strong>
                    <code>M = mol / L</code>
                </div>
                <div class="formula-item">
                    <strong>Dilution</strong>
                    <code>M&#x2081;V&#x2081; = M&#x2082;V&#x2082;</code>
                </div>
                <div class="formula-item">
                    <strong>Ideal Gas</strong>
                    <code>PV = nRT</code>
                </div>
                <div class="formula-item">
                    <strong>Gibbs Free Energy</strong>
                    <code>&Delta;G = &Delta;H &minus; T&Delta;S</code>
                </div>
                <div class="formula-item">
                    <strong>Nernst Equation</strong>
                    <code>E = E&deg; &minus; (RT/nF)ln Q</code>
                </div>
                <div class="formula-item">
                    <strong>pH</strong>
                    <code>pH = &minus;log[H&#x207A;]</code>
                </div>
                <div class="formula-item">
                    <strong>Hess's Law</strong>
                    <code>&Delta;H = &Sigma;&Delta;H&#x1DA0;(prod) &minus; &Sigma;&Delta;H&#x1DA0;(react)</code>
                </div>
            </div>

            <h3>Features</h3>
            <ul>
                <li><strong>Step-by-Step Solutions:</strong> Understand the problem-solving process with detailed explanations</li>
                <li><strong>Interactive Visualizations:</strong> See molecular structures, 3D geometry, and reaction diagrams</li>
                <li><strong>3D Molecular Viewer:</strong> Explore molecular shapes with interactive 3D visualization</li>
                <li><strong>Mobile Friendly:</strong> Works seamlessly on all devices</li>
                <li><strong>100% Free:</strong> No registration or payment required</li>
            </ul>

            <h3>For Students</h3>
            <p>Whether you're preparing for exams or doing homework, our calculators help you check your work and learn from step-by-step explanations. Covers atomic structure, molecular geometry, stoichiometry, solutions, thermodynamics, and electrochemistry.</p>

            <h3>For Teachers</h3>
            <p>Use our calculators to create example problems, demonstrate concepts visually in class, and generate practice materials. The interactive visualizations make abstract chemistry concepts tangible.</p>
        </section>
    </main>

    <footer class="chem-footer">
        <p>&copy; 2025 8gwifi.org - Free Online Chemistry Calculators</p>
    </footer>

    <!-- Dark Mode Toggle -->
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

    <%@ include file="../modern/components/analytics.jsp" %>
</body>
</html>
