<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // SEO: Exams landing page – currently focused on CBSE Class 10 Maths,
    // with other boards coming soon.
    request.setAttribute("pageTitle", "Practice Exams & CBSE Class 10 Maths Mock Tests");
    request.setAttribute(
        "pageDescription",
        "Free CBSE Class 10 Maths practice exams and mock tests with detailed solutions. " +
        "More boards (ICSE, State Boards) coming soon."
    );
    request.setAttribute("canonicalUrl", "https://8gwifi.org/exams/");
%>
<%@ include file="components/header.jsp" %>

<!-- Hero Section -->
<section class="hero">
    <div class="container">
        <h1 class="hero-title">Practice Exams & CBSE Class 10 Maths Mock Tests</h1>
        <p class="hero-subtitle">
            Prepare for your board exams with curated practice sets, detailed solutions, and instant feedback
        </p>
    </div>
</section>

<!-- Ad: Header Banner -->
<%@ include file="components/ad-leaderboard.jsp" %>

<!-- Main Content -->
<section class="page-section">
    <div class="container">
        <h2 class="section-title">Select Your Exam Board</h2>
        <p class="section-subtitle">
            Start with CBSE Class 10 Maths practice sets today. ICSE and State board subjects are coming soon.
        </p>

        <div class="grid grid-3">
            <!-- CBSE Board Card -->
            <a href="<%=request.getContextPath()%>/exams/cbse-board/" class="card card-clickable board-card">
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
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="color: var(--text-muted);">
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
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="color: var(--text-muted);">
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
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="var(--success)" stroke-width="2" style="vertical-align: middle; margin-right: 8px;">
                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                        <polyline points="22 4 12 14.01 9 11.01"></polyline>
                    </svg>
                    Board-Aligned Questions
                </h3>
                <p class="text-secondary">Questions follow the exact pattern of board exams with proper marking scheme and question types (MCQ, VSA, SA, LA, Case Study).</p>
            </div>

            <div class="card">
                <h3 style="margin-bottom: var(--space-3); color: var(--text-primary);">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="var(--accent-primary)" stroke-width="2" style="vertical-align: middle; margin-right: 8px;">
                        <circle cx="12" cy="12" r="10"></circle>
                        <path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"></path>
                        <line x1="12" y1="17" x2="12.01" y2="17"></line>
                    </svg>
                    Detailed Solutions
                </h3>
                <p class="text-secondary">Every question comes with step-by-step solutions to help you understand the concept and improve your problem-solving skills.</p>
            </div>

            <div class="card">
                <h3 style="margin-bottom: var(--space-3); color: var(--text-primary);">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="var(--warning)" stroke-width="2" style="vertical-align: middle; margin-right: 8px;">
                        <circle cx="12" cy="12" r="10"></circle>
                        <polyline points="12 6 12 12 16 14"></polyline>
                    </svg>
                    Timed Practice
                </h3>
                <p class="text-secondary">Practice with a timer to simulate real exam conditions and improve your time management skills.</p>
            </div>

            <div class="card">
                <h3 style="margin-bottom: var(--space-3); color: var(--text-primary);">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="var(--info)" stroke-width="2" style="vertical-align: middle; margin-right: 8px;">
                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                        <polyline points="14 2 14 8 20 8"></polyline>
                        <line x1="16" y1="13" x2="8" y2="13"></line>
                        <line x1="16" y1="17" x2="8" y2="17"></line>
                        <polyline points="10 9 9 9 8 9"></polyline>
                    </svg>
                    Progress Tracking
                </h3>
                <p class="text-secondary">Track your progress, mark questions for review, and see your score breakdown by question type.</p>
            </div>
        </div>
    </div>
</section>

<!-- Ad: Footer Banner -->
<%@ include file="components/ad-leaderboard.jsp" %>

<!-- Stats Section -->
<section class="page-section">
    <div class="container">
        <div class="grid" style="grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: var(--space-4);">
            <div class="card text-center">
                <div style="font-size: var(--text-3xl); font-weight: 700; color: var(--accent-primary);">5+</div>
                <div class="text-muted text-sm">Practice Sets</div>
            </div>
            <div class="card text-center">
                <div style="font-size: var(--text-3xl); font-weight: 700; color: var(--accent-primary);">180+</div>
                <div class="text-muted text-sm">Questions</div>
            </div>
            <div class="card text-center">
                <div style="font-size: var(--text-3xl); font-weight: 700; color: var(--success);">100%</div>
                <div class="text-muted text-sm">Free</div>
            </div>
            <div class="card text-center">
                <div style="font-size: var(--text-3xl); font-weight: 700; color: var(--accent-primary);">24/7</div>
                <div class="text-muted text-sm">Access</div>
            </div>
        </div>
    </div>
</section>

<!-- Structured Data -->
<script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "WebPage",
    "name": "Practice Exams & CBSE Class 10 Maths Mock Tests",
    "description": "Free CBSE Class 10 Maths practice exams and mock tests. More boards (ICSE, State Boards) coming soon.",
    "url": "https://8gwifi.org/exams/",
    "provider": {
        "@type": "Organization",
        "name": "8gwifi.org",
        "url": "https://8gwifi.org"
    },
    "mainEntity": {
        "@type": "ItemList",
        "itemListElement": [
            {
                "@type": "ListItem",
                "position": 1,
                "item": {
                    "@type": "Course",
                    "name": "CBSE Class 10 Mathematics Practice",
                    "description": "Practice sets and mock tests for CBSE Class 10 Mathematics board exam",
                    "provider": {
                        "@type": "Organization",
                        "name": "8gwifi.org"
                    }
                }
            }
        ]
    }
}
</script>

<%@ include file="components/footer.jsp" %>
