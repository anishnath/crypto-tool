<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setAttribute("pageTitle", "Textbook Solutions - NCERT, ICSE & More");
    request.setAttribute("pageDescription",
        "Free textbook solutions with step-by-step explanations. NCERT solutions for Class 6-12 Mathematics, Science, Physics, Chemistry. Practice exercises and learn concepts.");
    request.setAttribute("canonicalUrl", "https://8gwifi.org/exams/books/");
%>
<%@ include file="../components/header.jsp" %>

<!-- NCERT Books CSS -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/exams/books/ncert/ncert-books.css">

<style>
    /* Page-specific styles only */
    .books-hero {
        text-align: center;
        padding: var(--space-8) var(--space-4);
        background: linear-gradient(135deg, rgba(99, 102, 241, 0.1) 0%, rgba(139, 92, 246, 0.1) 100%);
        border-radius: var(--radius-xl);
        margin-bottom: var(--space-8);
    }

    .books-hero h1 {
        font-size: var(--text-4xl);
        font-weight: 800;
        color: var(--text-primary);
        margin-bottom: var(--space-3);
    }

    .books-hero p {
        font-size: var(--text-lg);
        color: var(--text-secondary);
        max-width: 600px;
        margin: 0 auto;
    }

    .publishers-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
        gap: var(--space-6);
    }

    .publisher-card {
        background: var(--bg-primary);
        border: 1px solid var(--border-primary);
        border-radius: var(--radius-xl);
        padding: var(--space-6);
        transition: all 0.3s ease;
        text-decoration: none;
        display: block;
    }

    .publisher-card:hover {
        border-color: var(--accent);
        box-shadow: 0 8px 30px rgba(99, 102, 241, 0.15);
        transform: translateY(-4px);
    }

    .publisher-logo {
        width: 64px;
        height: 64px;
        background: linear-gradient(135deg, var(--accent), var(--accent-secondary));
        border-radius: var(--radius-lg);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.5rem;
        font-weight: 700;
        color: white;
        margin-bottom: var(--space-4);
    }

    .publisher-card h2 {
        font-size: var(--text-xl);
        font-weight: 700;
        color: var(--text-primary);
        margin-bottom: var(--space-2);
    }

    .publisher-card p {
        color: var(--text-secondary);
        font-size: var(--text-sm);
        margin-bottom: var(--space-4);
        line-height: 1.6;
    }

    .publisher-stats {
        display: flex;
        gap: var(--space-4);
        padding-top: var(--space-4);
        border-top: 1px solid var(--border-secondary);
    }

    .stat {
        text-align: center;
    }

    .stat-value {
        font-size: var(--text-lg);
        font-weight: 700;
        color: var(--accent);
    }

    .stat-label {
        font-size: var(--text-xs);
        color: var(--text-muted);
        text-transform: uppercase;
    }

    .coming-soon {
        opacity: 0.6;
        pointer-events: none;
    }

    .coming-soon .publisher-logo {
        background: var(--bg-tertiary);
        color: var(--text-muted);
    }

    .badge-soon {
        display: inline-block;
        background: var(--bg-tertiary);
        color: var(--text-muted);
        font-size: var(--text-xs);
        padding: 2px 8px;
        border-radius: var(--radius-full);
        margin-left: var(--space-2);
    }
</style>

<div class="container">
    <!-- Breadcrumb -->
    <nav class="breadcrumb">
        <a href="<%=request.getContextPath()%>/exams/">Exams</a>
        <span class="breadcrumb-separator">/</span>
        <span class="breadcrumb-current">Textbook Solutions</span>
    </nav>

    <!-- Hero Section -->
    <section class="books-hero">
        <h1>Textbook Solutions</h1>
        <p>Step-by-step solutions for all exercises. Learn concepts with detailed explanations, interactive graphs, Venn diagrams, and SVG illustrations.</p>
    </section>

    <!-- Ad: Header -->
    <%@ include file="../components/ad-leaderboard.jsp" %>

    <!-- Publishers Grid -->
    <section class="page-section">
        <h2 class="section-title" style="margin-bottom: var(--space-6);">Available Books</h2>

        <div class="publishers-grid">
            <!-- NCERT -->
            <a href="<%=request.getContextPath()%>/exams/books/ncert/" class="publisher-card">
                <div class="publisher-logo">N</div>
                <h2>NCERT</h2>
                <p>National Council of Educational Research and Training textbooks. Official books for CBSE curriculum with interactive graphs, Venn diagrams, and SVG illustrations.</p>
                <div class="publisher-stats">
                    <div class="stat">
                        <div class="stat-value">3</div>
                        <div class="stat-label">Classes</div>
                    </div>
                    <div class="stat">
                        <div class="stat-value">1</div>
                        <div class="stat-label">Subject</div>
                    </div>
                    <div class="stat">
                        <div class="stat-value">1,128</div>
                        <div class="stat-label">Questions</div>
                    </div>
                </div>
            </a>

            <!-- ICSE - Coming Soon -->
            <div class="publisher-card coming-soon">
                <div class="publisher-logo">I</div>
                <h2>ICSE <span class="badge-soon">Coming Soon</span></h2>
                <p>Indian Certificate of Secondary Education textbooks. Comprehensive solutions for ICSE board curriculum.</p>
                <div class="publisher-stats">
                    <div class="stat">
                        <div class="stat-value">-</div>
                        <div class="stat-label">Classes</div>
                    </div>
                    <div class="stat">
                        <div class="stat-value">-</div>
                        <div class="stat-label">Subjects</div>
                    </div>
                    <div class="stat">
                        <div class="stat-value">-</div>
                        <div class="stat-label">Questions</div>
                    </div>
                </div>
            </div>

            <!-- RD Sharma - Coming Soon -->
            <div class="publisher-card coming-soon">
                <div class="publisher-logo">RD</div>
                <h2>RD Sharma <span class="badge-soon">Coming Soon</span></h2>
                <p>Popular mathematics reference books with extensive practice problems for Classes 6-12.</p>
                <div class="publisher-stats">
                    <div class="stat">
                        <div class="stat-value">-</div>
                        <div class="stat-label">Classes</div>
                    </div>
                    <div class="stat">
                        <div class="stat-value">-</div>
                        <div class="stat-label">Subjects</div>
                    </div>
                    <div class="stat">
                        <div class="stat-value">-</div>
                        <div class="stat-label">Questions</div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>

<!-- JSON-LD Structured Data -->
<script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "CollectionPage",
    "name": "Textbook Solutions",
    "description": "Free textbook solutions with step-by-step explanations for NCERT, ICSE and more.",
    "url": "https://8gwifi.org/exams/books/",
    "mainEntity": {
        "@type": "ItemList",
        "itemListElement": [
            {
                "@type": "ListItem",
                "position": 1,
                "name": "NCERT Solutions",
                "url": "https://8gwifi.org/exams/books/ncert/",
                "description": "Class 9, 10 & 11 Mathematics with 1,128 solved questions, interactive graphs, and Venn diagrams"
            }
        ]
    }
}
</script>

<%@ include file="../components/footer.jsp" %>
