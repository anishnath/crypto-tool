<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // High-CTR SEO Meta Tags
    String seoTitle = "150+ Free Math & Physics Tools — Solve, Visualize, Practice";
    String seoDescription = "Instant step-by-step solvers for algebra, calculus & physics. 35 interactive visual labs, 2,700+ practice problems, and 150 mental math tricks. No signup, 100% free.";
    String canonicalUrl = "https://8gwifi.org/exams/";

    request.setAttribute("pageTitle", seoTitle);
    request.setAttribute("pageDescription", seoDescription);
    request.setAttribute("canonicalUrl", canonicalUrl);

    // Build extra head content
    StringBuilder extraHead = new StringBuilder();

    // Open Graph
    extraHead.append("<meta property=\"og:title\" content=\"").append(seoTitle).append("\">\n");
    extraHead.append("<meta property=\"og:description\" content=\"").append(seoDescription).append("\">\n");
    extraHead.append("<meta property=\"og:url\" content=\"").append(canonicalUrl).append("\">\n");
    extraHead.append("<meta property=\"og:type\" content=\"website\">\n");
    extraHead.append("<meta property=\"og:site_name\" content=\"8gwifi.org\">\n");

    // Twitter Card
    extraHead.append("<meta name=\"twitter:card\" content=\"summary_large_image\">\n");
    extraHead.append("<meta name=\"twitter:title\" content=\"").append(seoTitle).append("\">\n");
    extraHead.append("<meta name=\"twitter:description\" content=\"").append(seoDescription).append("\">\n");

    // Keywords
    extraHead.append("<meta name=\"keywords\" content=\"free math calculator, physics solver, interactive math visualizations, mental math tricks, step-by-step solutions, unit circle calculator, matrix calculator, function plotter, math practice problems, physics simulations, brain training games, free mock tests, interactive graphs, algebra calculator, calculus solver\">\n");

    request.setAttribute("extraHeadContent", extraHead.toString());
%>
<%@ include file="components/header.jsp" %>

            <!-- Hero Section -->
            <section class="hero">
                <div class="container">
                    <h1 class="hero-title">Solve It. See It. Master It.</h1>
                    <p class="hero-subtitle">
                        150+ free math & physics tools &mdash; step-by-step solvers, interactive visual labs,
                        2,700+ practice problems, and mental math tricks. No signup required.
                    </p>
                </div>
            </section>

            <!-- Ad: Header Banner -->
            <%@ include file="components/ad-leaderboard.jsp" %>

                <!-- Main Content -->
                <section class="page-section">
                    <div class="container">
                        <h2 class="section-title">Select Your Path</h2>
                        <p class="section-subtitle">
                            Choose your exam board or sharpen your skills with mental math.
                        </p>

                        <!-- Study & Exam Prep -->
                        <div class="path-group">
                            <div class="path-group-label">Study & Exam Prep</div>
                            <div class="path-list">
                                <a href="<%=request.getContextPath()%>/exams/books/ncert/" class="path-row">
                                    <div class="path-icon" style="background: linear-gradient(135deg, #22c55e, #16a34a);">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                            <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                                            <line x1="9" y1="7" x2="15" y2="7"></line>
                                            <line x1="9" y1="11" x2="15" y2="11"></line>
                                        </svg>
                                    </div>
                                    <div class="path-info">
                                        <div class="path-title">NCERT Solutions</div>
                                        <div class="path-desc">Textbook Exercise Solutions</div>
                                    </div>
                                    <div class="path-meta">
                                        <span class="path-stat">2,711 Questions</span>
                                        <span class="path-tag">Class 9–12</span>
                                    </div>
                                    <svg class="path-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 18l6-6-6-6"/></svg>
                                </a>
                                <a href="<%=request.getContextPath()%>/exams/cbse-board/" class="path-row">
                                    <div class="path-icon" style="background: linear-gradient(135deg, #3b82f6, #2563eb);">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                            <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                                        </svg>
                                    </div>
                                    <div class="path-info">
                                        <div class="path-title">CBSE Board</div>
                                        <div class="path-desc">Central Board of Secondary Education</div>
                                    </div>
                                    <div class="path-meta">
                                        <span class="path-stat">5 Practice Sets</span>
                                        <span class="path-tag">Class 10</span>
                                    </div>
                                    <svg class="path-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 18l6-6-6-6"/></svg>
                                </a>
                            </div>
                        </div>

                        <!-- Calculators & Solvers -->
                        <div class="path-group">
                            <div class="path-group-label">Calculators & Solvers</div>
                            <div class="path-list">
                                <a href="<%=request.getContextPath()%>/math/" class="path-row">
                                    <div class="path-icon" style="background: linear-gradient(135deg, #16a34a, #22c55e);">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <line x1="12" y1="5" x2="12" y2="19"></line>
                                            <line x1="5" y1="12" x2="19" y2="12"></line>
                                            <rect x="3" y="3" width="18" height="18" rx="2"></rect>
                                        </svg>
                                    </div>
                                    <div class="path-info">
                                        <div class="path-title">Math Tools</div>
                                        <div class="path-desc">Step-by-Step Calculators</div>
                                    </div>
                                    <div class="path-meta">
                                        <span class="path-stat">21 Tools</span>
                                        <span class="path-tag">Algebra &bull; Calculus &bull; Linear Algebra</span>
                                    </div>
                                    <svg class="path-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 18l6-6-6-6"/></svg>
                                </a>
                                <a href="<%=request.getContextPath()%>/physics/" class="path-row">
                                    <div class="path-icon" style="background: linear-gradient(135deg, #f97316, #ea580c);">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <circle cx="12" cy="12" r="3"></circle>
                                            <path d="M12 1v2M12 21v2M4.22 4.22l1.42 1.42M18.36 18.36l1.42 1.42M1 12h2M21 12h2M4.22 19.78l1.42-1.42M18.36 5.64l1.42-1.42"></path>
                                        </svg>
                                    </div>
                                    <div class="path-info">
                                        <div class="path-title">Physics Tools</div>
                                        <div class="path-desc">Interactive Solvers & Calculators</div>
                                    </div>
                                    <div class="path-meta">
                                        <span class="path-stat">43 Tools</span>
                                        <span class="path-tag">Mechanics &bull; Optics &bull; E&amp;M &bull; Waves</span>
                                    </div>
                                    <svg class="path-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 18l6-6-6-6"/></svg>
                                </a>
                            </div>
                        </div>

                        <!-- Interactive Labs -->
                        <div class="path-group">
                            <div class="path-group-label">Interactive Labs</div>
                            <div class="path-list">
                                <a href="<%=request.getContextPath()%>/exams/visual-math/" class="path-row">
                                    <div class="path-icon" style="background: linear-gradient(135deg, #8b5cf6, #6d28d9);">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline>
                                        </svg>
                                    </div>
                                    <div class="path-info">
                                        <div class="path-title">Visual Math Lab</div>
                                        <div class="path-desc">Interactive Math Visualizations</div>
                                    </div>
                                    <div class="path-meta">
                                        <span class="path-stat">35 Tools</span>
                                        <span class="path-tag">Algebra &bull; Trig &bull; Calculus &bull; Statistics</span>
                                    </div>
                                    <svg class="path-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 18l6-6-6-6"/></svg>
                                </a>
                                <a href="<%=request.getContextPath()%>/exams/visual-physics/" class="path-row">
                                    <div class="path-icon" style="background: linear-gradient(135deg, #10b981, #059669);">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <circle cx="12" cy="12" r="3"></circle>
                                            <path d="M12 1v2M12 21v2M4.22 4.22l1.42 1.42M18.36 18.36l1.42 1.42M1 12h2M21 12h2M4.22 19.78l1.42-1.42M18.36 5.64l1.42-1.42"></path>
                                        </svg>
                                    </div>
                                    <div class="path-info">
                                        <div class="path-title">Visual Physics Lab</div>
                                        <div class="path-desc">Interactive Physics Simulations</div>
                                    </div>
                                    <div class="path-meta">
                                        <span class="path-stat">19 Tools</span>
                                        <span class="path-tag">Mechanics &bull; Optics &bull; Thermo &bull; Modern</span>
                                    </div>
                                    <svg class="path-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 18l6-6-6-6"/></svg>
                                </a>
                            </div>
                        </div>

                        <!-- Practice & Brain Training -->
                        <div class="path-group">
                            <div class="path-group-label">Practice & Brain Training</div>
                            <div class="path-list">
                                <a href="<%=request.getContextPath()%>/exams/quick-math/" class="path-row path-row--popular">
                                    <div class="path-icon" style="background: linear-gradient(135deg, #6366f1, #8b5cf6);">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M12 2v20M2 12h20M7 7l10 10M17 7L7 17"></path>
                                        </svg>
                                    </div>
                                    <div class="path-info">
                                        <div class="path-title">Quick Math <span class="path-popular-badge">Popular</span></div>
                                        <div class="path-desc">Vedic Math & Mental Arithmetic</div>
                                    </div>
                                    <div class="path-meta">
                                        <span class="path-stat">150+ Tricks</span>
                                        <span class="path-tag">SSC &bull; Bank &bull; CAT &bull; GRE</span>
                                    </div>
                                    <svg class="path-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 18l6-6-6-6"/></svg>
                                </a>
                                <a href="<%=request.getContextPath()%>/exams/math-memory/" class="path-row">
                                    <div class="path-icon" style="background: linear-gradient(135deg, #06b6d4, #0891b2);">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <rect x="3" y="3" width="7" height="7" rx="1"></rect>
                                            <rect x="14" y="3" width="7" height="7" rx="1"></rect>
                                            <rect x="3" y="14" width="7" height="7" rx="1"></rect>
                                            <rect x="14" y="14" width="7" height="7" rx="1"></rect>
                                        </svg>
                                    </div>
                                    <div class="path-info">
                                        <div class="path-title">Math Memory</div>
                                        <div class="path-desc">Brain Training Games</div>
                                    </div>
                                    <div class="path-meta">
                                        <span class="path-stat">16 Games</span>
                                        <span class="path-tag">Memory &bull; Speed &bull; Logic</span>
                                    </div>
                                    <svg class="path-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 18l6-6-6-6"/></svg>
                                </a>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Features Section -->
                <section class="page-section" style="background: var(--bg-primary);">
                    <div class="container">
                        <h2 class="section-title text-center">Why Practice With Us?</h2>

                        <div class="grid grid-2 mt-8">
                            <div class="card">
                                <h3 style="margin-bottom: var(--space-3); color: var(--text-primary);">
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="var(--success)"
                                        stroke-width="2" style="vertical-align: middle; margin-right: 8px;">
                                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                        <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                    </svg>
                                    Board-Aligned Questions
                                </h3>
                                <p class="text-secondary">Questions follow the exact pattern of board exams with proper
                                    marking scheme and question types (MCQ, VSA, SA, LA, Case Study).</p>
                            </div>

                            <div class="card">
                                <h3 style="margin-bottom: var(--space-3); color: var(--text-primary);">
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                        stroke="var(--accent-primary)" stroke-width="2"
                                        style="vertical-align: middle; margin-right: 8px;">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"></path>
                                        <line x1="12" y1="17" x2="12.01" y2="17"></line>
                                    </svg>
                                    Detailed Solutions
                                </h3>
                                <p class="text-secondary">Every question comes with step-by-step solutions to help you
                                    understand the concept and improve your problem-solving skills.</p>
                            </div>

                            <div class="card">
                                <h3 style="margin-bottom: var(--space-3); color: var(--text-primary);">
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="var(--warning)"
                                        stroke-width="2" style="vertical-align: middle; margin-right: 8px;">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <polyline points="12 6 12 12 16 14"></polyline>
                                    </svg>
                                    Timed Practice
                                </h3>
                                <p class="text-secondary">Practice with a timer to simulate real exam conditions and
                                    improve your time management skills.</p>
                            </div>

                            <div class="card">
                                <h3 style="margin-bottom: var(--space-3); color: var(--text-primary);">
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="var(--info)"
                                        stroke-width="2" style="vertical-align: middle; margin-right: 8px;">
                                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                        <polyline points="14 2 14 8 20 8"></polyline>
                                        <line x1="16" y1="13" x2="8" y2="13"></line>
                                        <line x1="16" y1="17" x2="8" y2="17"></line>
                                        <polyline points="10 9 9 9 8 9"></polyline>
                                    </svg>
                                    Progress Tracking
                                </h3>
                                <p class="text-secondary">Track your progress, mark questions for review, and see your
                                    score breakdown by question type.</p>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Ad: Footer Banner -->
                <%@ include file="components/ad-leaderboard.jsp" %>

                    <!-- Stats Section -->
                    <section class="page-section">
                        <div class="container">
                            <div class="grid"
                                style="grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: var(--space-4);">
                                <div class="card text-center">
                                    <div
                                        style="font-size: var(--text-3xl); font-weight: 700; color: var(--accent-primary);">
                                        2,711</div>
                                    <div class="text-muted text-sm">NCERT Solutions</div>
                                </div>
                                <div class="card text-center">
                                    <div
                                        style="font-size: var(--text-3xl); font-weight: 700; color: var(--accent-primary);">
                                        150+</div>
                                    <div class="text-muted text-sm">Math Tricks</div>
                                </div>
                                <div class="card text-center">
                                    <div
                                        style="font-size: var(--text-3xl); font-weight: 700; color: #8b5cf6;">
                                        35</div>
                                    <div class="text-muted text-sm">Visual Math Tools</div>
                                </div>
                                <div class="card text-center">
                                    <div
                                        style="font-size: var(--text-3xl); font-weight: 700; color: #10b981;">
                                        19</div>
                                    <div class="text-muted text-sm">Physics Sims</div>
                                </div>
                                <div class="card text-center">
                                    <div
                                        style="font-size: var(--text-3xl); font-weight: 700; color: #f97316;">
                                        43</div>
                                    <div class="text-muted text-sm">Physics Tools</div>
                                </div>
                                <div class="card text-center">
                                    <div style="font-size: var(--text-3xl); font-weight: 700; color: var(--success);">
                                        100%</div>
                                    <div class="text-muted text-sm">Free Forever</div>
                                </div>
                            </div>
                        </div>
                    </section>

                    <!-- Structured Data: WebPage -->
                    <script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "WebPage",
    "@id": "https://8gwifi.org/exams/",
    "name": "150+ Free Math & Physics Tools — Solve, Visualize, Practice",
    "description": "Instant step-by-step solvers for algebra, calculus and physics. 35 interactive visual labs, 2,700+ practice problems, and 150 mental math tricks. No signup, 100% free.",
    "url": "https://8gwifi.org/exams/",
    "inLanguage": "en",
    "isPartOf": {
        "@type": "WebSite",
        "name": "8gwifi.org",
        "url": "https://8gwifi.org"
    }
}
</script>

                    <!-- Structured Data: ItemList -->
                    <script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "ItemList",
    "name": "Math & Physics Learning Resources",
    "description": "Free calculators, solvers, interactive labs, practice problems, and mental math training for students",
    "numberOfItems": 8,
    "itemListElement": [
        {
            "@type": "ListItem",
            "position": 1,
            "item": {
                "@type": "Course",
                "name": "NCERT Textbook Solutions - Class 9, 10, 11 & 12 Mathematics & Physics",
                "description": "2,711 step-by-step NCERT solutions with interactive graphs, calculators, and physics tools for Class 9–12 Mathematics and Physics",
                "url": "https://8gwifi.org/exams/books/ncert/",
                "provider": {"@type": "Organization", "name": "8gwifi.org"},
                "isAccessibleForFree": true,
                "educationalLevel": "Class 9-12"
            }
        },
        {
            "@type": "ListItem",
            "position": 2,
            "item": {
                "@type": "WebApplication",
                "name": "Physics Tools - Interactive Solvers & Calculators",
                "applicationCategory": "EducationalApplication",
                "description": "43 free interactive physics tools covering mechanics, optics, electromagnetism, waves, thermodynamics, and modern physics",
                "url": "https://8gwifi.org/physics/",
                "provider": {"@type": "Organization", "name": "8gwifi.org"},
                "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"}
            }
        },
        {
            "@type": "ListItem",
            "position": 3,
            "item": {
                "@type": "Course",
                "name": "Quick Math - Mental Arithmetic Mastery",
                "description": "150+ mental math tricks covering Vedic math, speed calculation, and shortcuts for competitive exams",
                "url": "https://8gwifi.org/exams/quick-math/",
                "provider": {"@type": "Organization", "name": "8gwifi.org"},
                "isAccessibleForFree": true,
                "audience": {"@type": "EducationalAudience", "audienceType": "SSC, Bank, CAT, GRE aspirants"}
            }
        },
        {
            "@type": "ListItem",
            "position": 4,
            "item": {
                "@type": "WebApplication",
                "name": "Math Memory Games - Brain Training",
                "applicationCategory": "GameApplication",
                "description": "16 free brain training games to improve working memory, mental calculation, and cognitive skills",
                "url": "https://8gwifi.org/exams/math-memory/",
                "provider": {"@type": "Organization", "name": "8gwifi.org"},
                "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"}
            }
        },
        {
            "@type": "ListItem",
            "position": 5,
            "item": {
                "@type": "WebApplication",
                "name": "Math Tools - Calculators with Step-by-Step Solutions",
                "applicationCategory": "EducationalApplication",
                "description": "21 free math calculators covering percentages, exponents, logarithms, quadratics, derivatives, integrals, matrices, and more with step-by-step KaTeX solutions",
                "url": "https://8gwifi.org/math/",
                "provider": {"@type": "Organization", "name": "8gwifi.org"},
                "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"}
            }
        },
        {
            "@type": "ListItem",
            "position": 6,
            "item": {
                "@type": "WebApplication",
                "name": "Visual Physics Lab - Interactive Physics Simulations",
                "applicationCategory": "EducationalApplication",
                "description": "19 interactive physics simulations covering mechanics, optics, electromagnetism, waves, thermodynamics, and modern physics",
                "url": "https://8gwifi.org/exams/visual-physics/",
                "provider": {"@type": "Organization", "name": "8gwifi.org"},
                "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"}
            }
        },
        {
            "@type": "ListItem",
            "position": 7,
            "item": {
                "@type": "WebApplication",
                "name": "Visual Math Lab - Interactive Math Visualizations",
                "applicationCategory": "EducationalApplication",
                "description": "35 interactive math visualizations covering algebra, trigonometry, calculus, linear algebra, statistics, and geometry",
                "url": "https://8gwifi.org/exams/visual-math/",
                "provider": {"@type": "Organization", "name": "8gwifi.org"},
                "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"}
            }
        },
        {
            "@type": "ListItem",
            "position": 8,
            "item": {
                "@type": "Course",
                "name": "CBSE Class 10 Mathematics Practice",
                "description": "Practice sets and mock tests for CBSE Class 10 Mathematics board exam with detailed solutions",
                "url": "https://8gwifi.org/exams/cbse-board/",
                "provider": {"@type": "Organization", "name": "8gwifi.org"},
                "isAccessibleForFree": true,
                "educationalLevel": "Class 10"
            }
        }
    ]
}
</script>

                    <!-- Structured Data: BreadcrumbList -->
                    <script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
        {"@type": "ListItem", "position": 1, "name": "Home", "item": "https://8gwifi.org/"},
        {"@type": "ListItem", "position": 2, "name": "Exams"}
    ]
}
</script>

                    <!-- Page-specific styles -->
                    <style>
                        .path-group {
                            margin-bottom: var(--space-6);
                        }
                        .path-group-label {
                            font-size: 0.7rem;
                            font-weight: 700;
                            text-transform: uppercase;
                            letter-spacing: 1px;
                            color: var(--text-muted);
                            margin-bottom: var(--space-2);
                            padding-left: 2px;
                        }
                        .path-list {
                            border: 1px solid var(--border);
                            border-radius: var(--radius-lg);
                            overflow: hidden;
                            background: var(--bg-secondary);
                        }
                        .path-row {
                            display: flex;
                            align-items: center;
                            gap: var(--space-4);
                            padding: var(--space-4) var(--space-5);
                            text-decoration: none;
                            color: inherit;
                            transition: background 0.15s ease;
                            border-bottom: 1px solid var(--border);
                        }
                        .path-row:last-child {
                            border-bottom: none;
                        }
                        .path-row:hover {
                            background: var(--bg-tertiary);
                        }
                        .path-row:hover .path-arrow {
                            opacity: 1;
                            transform: translateX(2px);
                        }
                        .path-row--popular {
                            background: color-mix(in srgb, var(--accent-primary) 4%, transparent);
                        }
                        .path-icon {
                            flex-shrink: 0;
                            width: 44px;
                            height: 44px;
                            border-radius: var(--radius-md);
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            color: white;
                        }
                        .path-icon svg {
                            width: 22px;
                            height: 22px;
                        }
                        .path-info {
                            flex: 1;
                            min-width: 0;
                        }
                        .path-title {
                            font-size: var(--text-base);
                            font-weight: 600;
                            color: var(--text-primary);
                            display: flex;
                            align-items: center;
                            gap: var(--space-2);
                        }
                        .path-desc {
                            font-size: var(--text-sm);
                            color: var(--text-muted);
                            margin-top: 1px;
                        }
                        .path-meta {
                            flex-shrink: 0;
                            text-align: right;
                            display: flex;
                            flex-direction: column;
                            gap: 2px;
                        }
                        .path-stat {
                            font-size: var(--text-sm);
                            font-weight: 600;
                            color: var(--text-primary);
                        }
                        .path-tag {
                            font-size: 0.7rem;
                            color: var(--text-muted);
                        }
                        .path-arrow {
                            flex-shrink: 0;
                            width: 18px;
                            height: 18px;
                            color: var(--text-muted);
                            opacity: 0.4;
                            transition: all 0.15s ease;
                        }
                        .path-popular-badge {
                            font-size: 0.6rem;
                            font-weight: 700;
                            text-transform: uppercase;
                            letter-spacing: 0.5px;
                            background: linear-gradient(135deg, #f59e0b, #d97706);
                            color: white;
                            padding: 2px 7px;
                            border-radius: 8px;
                        }

                        /* Mobile: stack meta below info */
                        @media (max-width: 640px) {
                            .path-row {
                                flex-wrap: wrap;
                                gap: var(--space-3);
                                padding: var(--space-3) var(--space-4);
                            }
                            .path-meta {
                                flex-basis: 100%;
                                text-align: left;
                                flex-direction: row;
                                gap: var(--space-2);
                                padding-left: 56px;
                            }
                            .path-tag {
                                display: none;
                            }
                            .path-arrow {
                                display: none;
                            }
                        }
                    </style>

                    <%@ include file="components/footer.jsp" %>