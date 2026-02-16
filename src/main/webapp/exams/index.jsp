<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // High-CTR SEO Meta Tags
    String seoTitle = "Free Practice Exams | NCERT Solutions + Visual Math Lab + Physics Tools + Mental Math";
    String seoDescription = "2,711 NCERT solutions, 35 interactive math visualizations, 43 physics solvers, CBSE mock tests + 150+ mental math tricks. 100% free.";
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
    extraHead.append("<meta name=\"keywords\" content=\"NCERT solutions Class 11, NCERT solutions Class 10, NCERT solutions Class 9, CBSE practice exams, mental math tricks, visual math tools, interactive math visualizations, unit circle calculator, matrix calculator, function plotter, competitive exam preparation, SSC math, bank exam quantitative, CAT quant practice, free mock tests, interactive graphs\">\n");

    request.setAttribute("extraHeadContent", extraHead.toString());
%>
<%@ include file="components/header.jsp" %>

            <!-- Hero Section -->
            <section class="hero">
                <div class="container">
                    <h1 class="hero-title">Free Practice Exams, NCERT Solutions, Visual Math Lab, Physics Tools & Mental Math</h1>
                    <p class="hero-subtitle">
                        2,711 NCERT solutions, 35 interactive math visualizations, 43 physics solvers & calculators,
                        CBSE mock tests + 150+ mental math tricks for <strong>SSC, Bank, CAT, GRE</strong>.
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

                        <div class="grid grid-3">
                            <!-- Quick Math Card -->
                            <a href="<%=request.getContextPath()%>/exams/quick-math/"
                                class="card card-clickable board-card featured-card" style="border-color: var(--accent-primary); border-width: 2px;">
                                <div class="featured-badge">Popular</div>
                                <div class="board-card-icon" style="background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white;">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M12 2v20M2 12h20M7 7l10 10M17 7L7 17"></path>
                                    </svg>
                                </div>
                                <h3 class="board-card-title">Quick Math</h3>
                                <p class="board-card-subtitle">Vedic Math & Mental Arithmetic</p>
                                <div class="board-card-meta">
                                    <span class="board-card-badge"
                                        style="background: linear-gradient(135deg, #10b981, #059669); color: white;">150+ Tricks</span>
                                </div>
                                <p class="text-sm text-muted mt-4">SSC • Bank • CAT • GRE</p>
                            </a>

                            <!-- Math Memory Games Card -->
                            <a href="<%=request.getContextPath()%>/exams/math-memory/"
                                class="card card-clickable board-card" style="border-color: #22d3ee; border-width: 2px;">
                                <div class="featured-badge" style="background: linear-gradient(135deg, #06b6d4, #0891b2);">New</div>
                                <div class="board-card-icon" style="background: linear-gradient(135deg, #06b6d4, #0891b2); color: white;">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="3" y="3" width="7" height="7" rx="1"></rect>
                                        <rect x="14" y="3" width="7" height="7" rx="1"></rect>
                                        <rect x="3" y="14" width="7" height="7" rx="1"></rect>
                                        <rect x="14" y="14" width="7" height="7" rx="1"></rect>
                                    </svg>
                                </div>
                                <h3 class="board-card-title">Math Memory</h3>
                                <p class="board-card-subtitle">Brain Training Games</p>
                                <div class="board-card-meta">
                                    <span class="board-card-badge" style="background: linear-gradient(135deg, #a855f7, #7c3aed); color: white;">16 Games</span>
                                </div>
                                <p class="text-sm text-muted mt-4">Memory • Speed • Logic</p>
                            </a>

                            <!-- NCERT Books Card -->
                            <a href="<%=request.getContextPath()%>/exams/books/ncert/"
                                class="card card-clickable board-card" style="border-color: #22c55e; border-width: 2px;">
                                <div class="featured-badge" style="background: linear-gradient(135deg, #22c55e, #16a34a);">New</div>
                                <div class="board-card-icon" style="background: linear-gradient(135deg, #22c55e, #16a34a); color: white;">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                                        <line x1="9" y1="7" x2="15" y2="7"></line>
                                        <line x1="9" y1="11" x2="15" y2="11"></line>
                                    </svg>
                                </div>
                                <h3 class="board-card-title">NCERT Solutions</h3>
                                <p class="board-card-subtitle">Textbook Exercise Solutions</p>
                                <div class="board-card-meta">
                                    <span class="board-card-badge" style="background: linear-gradient(135deg, #22c55e, #16a34a); color: white;">2,711 Questions</span>
                                </div>
                                <p class="text-sm text-muted mt-4">Class 9–12 Mathematics & Physics</p>
                            </a>

                            <!-- Physics Tools Card -->
                            <a href="<%=request.getContextPath()%>/physics/"
                                class="card card-clickable board-card" style="border-color: #f97316; border-width: 2px;">
                                <div class="featured-badge" style="background: linear-gradient(135deg, #f97316, #ea580c);">New</div>
                                <div class="board-card-icon" style="background: linear-gradient(135deg, #f97316, #ea580c); color: white;">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <circle cx="12" cy="12" r="3"></circle>
                                        <path d="M12 1v2M12 21v2M4.22 4.22l1.42 1.42M18.36 18.36l1.42 1.42M1 12h2M21 12h2M4.22 19.78l1.42-1.42M18.36 5.64l1.42-1.42"></path>
                                    </svg>
                                </div>
                                <h3 class="board-card-title">Physics Tools</h3>
                                <p class="board-card-subtitle">Interactive Solvers & Calculators</p>
                                <div class="board-card-meta">
                                    <span class="board-card-badge" style="background: linear-gradient(135deg, #f97316, #ea580c); color: white;">43 Tools</span>
                                </div>
                                <p class="text-sm text-muted mt-4">Mechanics • Optics • Electromagnetism • Waves</p>
                            </a>

                            <!-- Visual Physics Lab Card -->
                            <a href="<%=request.getContextPath()%>/exams/visual-physics/"
                                class="card card-clickable board-card" style="border-color: #10b981; border-width: 2px;">
                                <div class="featured-badge" style="background: linear-gradient(135deg, #10b981, #059669);">New</div>
                                <div class="board-card-icon" style="background: linear-gradient(135deg, #10b981, #059669); color: white;">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <circle cx="12" cy="12" r="3"></circle>
                                        <path d="M12 1v2M12 21v2M4.22 4.22l1.42 1.42M18.36 18.36l1.42 1.42M1 12h2M21 12h2M4.22 19.78l1.42-1.42M18.36 5.64l1.42-1.42"></path>
                                    </svg>
                                </div>
                                <h3 class="board-card-title">Visual Physics Lab</h3>
                                <p class="board-card-subtitle">Interactive Physics Simulations</p>
                                <div class="board-card-meta">
                                    <span class="board-card-badge" style="background: linear-gradient(135deg, #10b981, #059669); color: white;">19 Tools</span>
                                </div>
                                <p class="text-sm text-muted mt-4">Mechanics &bull; Optics &bull; E&amp;M &bull; Waves &bull; Thermo &bull; Modern</p>
                            </a>

                            <!-- Visual Math Lab Card -->
                            <a href="<%=request.getContextPath()%>/exams/visual-math/"
                                class="card card-clickable board-card" style="border-color: #8b5cf6; border-width: 2px;">
                                <div class="featured-badge" style="background: linear-gradient(135deg, #8b5cf6, #6d28d9);">New</div>
                                <div class="board-card-icon" style="background: linear-gradient(135deg, #8b5cf6, #6d28d9); color: white;">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline>
                                    </svg>
                                </div>
                                <h3 class="board-card-title">Visual Math Lab</h3>
                                <p class="board-card-subtitle">Interactive Math Visualizations</p>
                                <div class="board-card-meta">
                                    <span class="board-card-badge" style="background: linear-gradient(135deg, #8b5cf6, #6d28d9); color: white;">35 Tools</span>
                                </div>
                                <p class="text-sm text-muted mt-4">Algebra • Trig • Calculus • Statistics</p>
                            </a>

                            <!-- CBSE Board Card -->
                            <a href="<%=request.getContextPath()%>/exams/cbse-board/"
                                class="card card-clickable board-card">
                                <div class="board-card-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                                    </svg>
                                </div>
                                <h3 class="board-card-title">CBSE Board</h3>
                                <p class="board-card-subtitle">Central Board of Secondary Education</p>
                                <div class="board-card-meta">
                                    <span class="board-card-badge">5 Practice Sets</span>
                                </div>
                                <p class="text-sm text-muted mt-4">Class 10 Mathematics</p>
                            </a>

                            <!-- ICSE Board Card (Coming Soon) -->
                            <div class="card board-card" style="opacity: 0.7;">
                                <div class="board-card-icon" style="background: var(--bg-tertiary);">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                        style="color: var(--text-muted);">
                                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                                    </svg>
                                </div>
                                <h3 class="board-card-title">ICSE Board</h3>
                                <p class="board-card-subtitle">Indian Certificate of Secondary Education</p>
                                <div class="board-card-meta">
                                    <span class="board-card-badge coming-soon">Coming Soon</span>
                                </div>
                                <p class="text-sm text-muted mt-4">Class 10</p>
                            </div>

                            <!-- State Boards Card (Coming Soon) -->
                            <div class="card board-card" style="opacity: 0.7;">
                                <div class="board-card-icon" style="background: var(--bg-tertiary);">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                        style="color: var(--text-muted);">
                                        <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                        <circle cx="12" cy="10" r="3"></circle>
                                    </svg>
                                </div>
                                <h3 class="board-card-title">State Boards</h3>
                                <p class="board-card-subtitle">Various State Education Boards</p>
                                <div class="board-card-meta">
                                    <span class="board-card-badge coming-soon">Coming Soon</span>
                                </div>
                                <p class="text-sm text-muted mt-4">Multiple States</p>
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
    "name": "Free Practice Exams, NCERT Solutions, Visual Math Lab & Mental Math",
    "description": "2,711 NCERT solutions, 35 interactive math visualizations, 43 physics solvers, CBSE mock tests + 150+ mental math tricks.",
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
    "name": "Exam Preparation Resources",
    "description": "Practice exams and mental math training for board exams and competitive tests",
    "numberOfItems": 7,
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
            "position": 6,
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
            "position": 7,
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
                        .featured-card {
                            position: relative;
                            overflow: visible;
                        }
                        .featured-badge {
                            position: absolute;
                            top: -10px;
                            right: 16px;
                            background: linear-gradient(135deg, #f59e0b, #d97706);
                            color: white;
                            font-size: 0.7rem;
                            font-weight: 700;
                            text-transform: uppercase;
                            letter-spacing: 0.5px;
                            padding: 4px 10px;
                            border-radius: 12px;
                            box-shadow: 0 2px 8px rgba(245, 158, 11, 0.4);
                        }
                    </style>

                    <%@ include file="components/footer.jsp" %>