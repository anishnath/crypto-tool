<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setAttribute("pageTitle", "NCERT Class 9 Maths Solutions - All Chapters (Free)");
    request.setAttribute("pageDescription",
        "Free NCERT Class 9 Maths solutions for all 15 chapters. Step-by-step answers for Number Systems, Polynomials, Geometry, Statistics & more. CBSE board aligned.");
    request.setAttribute("canonicalUrl", "https://8gwifi.org/exams/books/ncert/class-9/mathematics/");
%>
<%@ include file="../../../../components/header.jsp" %>

<!-- NCERT Books CSS -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/exams/books/ncert/ncert-books.css">

<style>
    .subject-hero {
        padding: var(--space-6) var(--space-4);
        background: linear-gradient(135deg, rgba(99, 102, 241, 0.1) 0%, rgba(139, 92, 246, 0.1) 100%);
        border-radius: var(--radius-xl);
        margin-bottom: var(--space-6);
    }

    .subject-hero h1 {
        font-size: var(--text-3xl);
        font-weight: 800;
        color: var(--text-primary);
        margin-bottom: var(--space-2);
    }

    .subject-hero p {
        font-size: var(--text-base);
        color: var(--text-secondary);
    }

    .subject-stats {
        display: flex;
        gap: var(--space-6);
        margin-top: var(--space-4);
        flex-wrap: wrap;
    }

    .subject-stat {
        display: flex;
        align-items: center;
        gap: var(--space-2);
        color: var(--text-secondary);
        font-size: var(--text-sm);
    }

    .subject-stat strong {
        color: var(--accent);
        font-weight: 700;
    }

    .chapters-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
        gap: var(--space-4);
    }

    .chapter-card {
        background: var(--bg-primary);
        border: 1px solid var(--border-primary);
        border-radius: var(--radius-lg);
        padding: var(--space-5);
        text-decoration: none;
        display: block;
        transition: all 0.2s ease;
    }

    .chapter-card:hover {
        border-color: var(--accent);
        box-shadow: 0 4px 20px rgba(99, 102, 241, 0.12);
        transform: translateY(-2px);
    }

    .chapter-header {
        display: flex;
        align-items: flex-start;
        gap: var(--space-3);
        margin-bottom: var(--space-3);
    }

    .chapter-num {
        width: 40px;
        height: 40px;
        background: linear-gradient(135deg, var(--accent), var(--accent-secondary));
        border-radius: var(--radius-md);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: var(--text-sm);
        font-weight: 700;
        color: white;
        flex-shrink: 0;
    }

    .chapter-title {
        font-size: var(--text-base);
        font-weight: 600;
        color: var(--text-primary);
        line-height: 1.4;
    }

    .chapter-meta {
        display: flex;
        gap: var(--space-4);
        padding-top: var(--space-3);
        border-top: 1px solid var(--border-secondary);
    }

    .chapter-meta-item {
        font-size: var(--text-xs);
        color: var(--text-muted);
    }

    .chapter-meta-item strong {
        color: var(--text-secondary);
    }

    .difficulty-bar {
        display: flex;
        gap: 2px;
        margin-top: var(--space-2);
    }

    .difficulty-segment {
        width: 20px;
        height: 4px;
        background: var(--border-secondary);
        border-radius: 2px;
    }

    .difficulty-segment.filled {
        background: var(--accent);
    }

    .difficulty-segment.filled.medium {
        background: #f59e0b;
    }

    .difficulty-segment.filled.hard {
        background: #ef4444;
    }

    /* Loading state */
    .loading-skeleton {
        background: linear-gradient(90deg, var(--bg-secondary) 25%, var(--bg-tertiary) 50%, var(--bg-secondary) 75%);
        background-size: 200% 100%;
        animation: shimmer 1.5s infinite;
        border-radius: var(--radius-lg);
        height: 120px;
    }

    @keyframes shimmer {
        0% { background-position: 200% 0; }
        100% { background-position: -200% 0; }
    }

    @media (max-width: 640px) {
        .chapters-grid {
            grid-template-columns: 1fr;
        }

        .subject-hero h1 {
            font-size: var(--text-2xl);
        }
    }
</style>

<div class="container">
    <!-- Breadcrumb -->
    <nav class="breadcrumb">
        <a href="<%=request.getContextPath()%>/exams/">Exams</a>
        <span class="breadcrumb-separator">/</span>
        <a href="<%=request.getContextPath()%>/exams/books/">Books</a>
        <span class="breadcrumb-separator">/</span>
        <a href="<%=request.getContextPath()%>/exams/books/ncert/">NCERT</a>
        <span class="breadcrumb-separator">/</span>
        <span class="breadcrumb-current">Class 9 Mathematics</span>
    </nav>

    <!-- Hero Section -->
    <section class="subject-hero">
        <h1>Class 9 Mathematics</h1>
        <p>NCERT textbook solutions with step-by-step explanations for all exercises</p>
        <div class="subject-stats">
            <div class="subject-stat">
                <span>&#128218;</span>
                <span><strong>15</strong> Chapters</span>
            </div>
            <div class="subject-stat">
                <span>&#128221;</span>
                <span><strong>244</strong> Questions</span>
            </div>
            <div class="subject-stat">
                <span>&#127919;</span>
                <span><strong>CBSE</strong> Aligned</span>
            </div>
        </div>
    </section>

    <!-- Ad: Header -->
    <%@ include file="../../../../components/ad-leaderboard.jsp" %>

    <!-- Chapters Grid -->
    <section class="page-section">
        <h2 class="section-title" style="margin-bottom: var(--space-5);">All Chapters</h2>
        <div class="chapters-grid" id="chaptersGrid">
            <!-- Loading skeletons -->
            <div class="loading-skeleton"></div>
            <div class="loading-skeleton"></div>
            <div class="loading-skeleton"></div>
            <div class="loading-skeleton"></div>
            <div class="loading-skeleton"></div>
            <div class="loading-skeleton"></div>
        </div>
    </section>
</div>

<!-- JSON-LD Structured Data -->
<script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "Course",
    "name": "NCERT Class 9 Mathematics Solutions",
    "description": "Complete solutions for NCERT Class 9 Mathematics textbook with step-by-step explanations.",
    "url": "https://8gwifi.org/exams/books/ncert/class-9/mathematics/",
    "provider": {
        "@type": "Organization",
        "name": "8gwifi.org"
    },
    "educationalLevel": "Class 9",
    "about": {
        "@type": "Thing",
        "name": "Mathematics"
    },
    "hasCourseInstance": {
        "@type": "CourseInstance",
        "courseMode": "online"
    }
}
</script>

<script>
(function() {
    // Chapter data with slugs
    var chapters = [
        { num: 1, name: "Number Systems", slug: "number-systems", questions: 25, exercises: 6 },
        { num: 2, name: "Polynomials", slug: "polynomials", questions: 29, exercises: 5 },
        { num: 3, name: "Coordinate Geometry", slug: "coordinate-geometry", questions: 2, exercises: 1 },
        { num: 4, name: "Linear Equations in Two Variables", slug: "linear-equations-in-two-variables", questions: 6, exercises: 2 },
        { num: 5, name: "Introduction to Euclid's Geometry", slug: "introduction-to-euclids-geometry", questions: 7, exercises: 2 },
        { num: 6, name: "Lines and Angles", slug: "lines-and-angles", questions: 11, exercises: 3 },
        { num: 7, name: "Triangles", slug: "triangles", questions: 26, exercises: 5 },
        { num: 8, name: "Quadrilaterals", slug: "quadrilaterals", questions: 13, exercises: 2 },
        { num: 9, name: "Areas of Parallelograms and Triangles", slug: "areas-of-parallelograms-and-triangles", questions: 31, exercises: 4 },
        { num: 10, name: "Circles", slug: "circles", questions: 20, exercises: 6 },
        { num: 11, name: "Constructions", slug: "constructions", questions: 10, exercises: 2 },
        { num: 12, name: "Heron's Formula", slug: "herons-formula", questions: 6, exercises: 2 },
        { num: 13, name: "Surface Areas and Volumes", slug: "surface-areas-and-volumes", questions: 36, exercises: 9 },
        { num: 14, name: "Statistics", slug: "statistics", questions: 9, exercises: 4 },
        { num: 15, name: "Probability", slug: "probability", questions: 13, exercises: 1 }
    ];

    var basePath = '<%=request.getContextPath()%>/exams/books/ncert/class-9/mathematics/';
    var grid = document.getElementById('chaptersGrid');

    function getDifficultyLevel(questions) {
        if (questions <= 10) return 1;
        if (questions <= 20) return 2;
        return 3;
    }

    function renderChapters() {
        var html = '';
        chapters.forEach(function(ch) {
            var difficulty = getDifficultyLevel(ch.questions);
            html += '<a href="' + basePath + ch.slug + '/" class="chapter-card">' +
                '<div class="chapter-header">' +
                    '<div class="chapter-num">' + ch.num + '</div>' +
                    '<div class="chapter-title">' + ch.name + '</div>' +
                '</div>' +
                '<div class="chapter-meta">' +
                    '<div class="chapter-meta-item"><strong>' + ch.questions + '</strong> Questions</div>' +
                    '<div class="chapter-meta-item"><strong>' + ch.exercises + '</strong> Exercises</div>' +
                '</div>' +
                '<div class="difficulty-bar">' +
                    '<div class="difficulty-segment' + (difficulty >= 1 ? ' filled' : '') + '"></div>' +
                    '<div class="difficulty-segment' + (difficulty >= 2 ? ' filled medium' : '') + '"></div>' +
                    '<div class="difficulty-segment' + (difficulty >= 3 ? ' filled hard' : '') + '"></div>' +
                '</div>' +
            '</a>';
        });
        grid.innerHTML = html;
    }

    // Render immediately
    renderChapters();
})();
</script>

<%@ include file="../../../../components/footer.jsp" %>
