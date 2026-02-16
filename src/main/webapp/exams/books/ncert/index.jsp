<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setAttribute("pageTitle", "NCERT Solutions - Class 6 to 12 All Subjects (Free)");
    request.setAttribute("pageDescription",
        "Free NCERT solutions for Class 6-12. Step-by-step answers for Mathematics, Science, Physics, Chemistry. All chapters and exercises with detailed explanations.");
    request.setAttribute("canonicalUrl", "https://8gwifi.org/exams/books/ncert/");
%>
<%@ include file="../../components/header.jsp" %>

<!-- NCERT Books CSS -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/exams/books/ncert/ncert-books.css">

<style>
    /* Page-specific styles only */
    .ncert-hero {
        text-align: center;
        padding: var(--space-8) var(--space-4);
        background: linear-gradient(135deg, rgba(34, 197, 94, 0.1) 0%, rgba(16, 185, 129, 0.1) 100%);
        border-radius: var(--radius-xl);
        margin-bottom: var(--space-8);
    }

    .ncert-hero h1 {
        font-size: var(--text-4xl);
        font-weight: 800;
        color: var(--text-primary);
        margin-bottom: var(--space-3);
    }

    .ncert-hero p {
        font-size: var(--text-lg);
        color: var(--text-secondary);
        max-width: 600px;
        margin: 0 auto;
    }

    .class-section {
        margin-bottom: var(--space-8);
    }

    .class-header {
        display: flex;
        align-items: center;
        gap: var(--space-3);
        margin-bottom: var(--space-4);
    }

    .class-badge {
        background: linear-gradient(135deg, #22c55e, #10b981);
        color: white;
        font-size: var(--text-sm);
        font-weight: 700;
        padding: var(--space-2) var(--space-4);
        border-radius: var(--radius-full);
    }

    .class-title {
        font-size: var(--text-xl);
        font-weight: 700;
        color: var(--text-primary);
    }

    .subjects-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
        gap: var(--space-4);
    }

    .subject-card {
        background: var(--bg-primary);
        border: 1px solid var(--border-primary);
        border-radius: var(--radius-lg);
        padding: var(--space-5);
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: var(--space-4);
        transition: all 0.2s ease;
    }

    .subject-card:hover {
        border-color: #22c55e;
        box-shadow: 0 4px 20px rgba(34, 197, 94, 0.15);
    }

    .subject-icon {
        width: 48px;
        height: 48px;
        border-radius: var(--radius-md);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.5rem;
        flex-shrink: 0;
    }

    .subject-icon.math {
        background: rgba(99, 102, 241, 0.15);
    }

    .subject-icon.science {
        background: rgba(34, 197, 94, 0.15);
    }

    .subject-icon.physics {
        background: rgba(59, 130, 246, 0.15);
    }

    .subject-icon.chemistry {
        background: rgba(249, 115, 22, 0.15);
    }

    .subject-info h3 {
        font-size: var(--text-base);
        font-weight: 600;
        color: var(--text-primary);
        margin-bottom: 4px;
    }

    .subject-info p {
        font-size: var(--text-sm);
        color: var(--text-muted);
    }

    .subject-card.coming-soon {
        opacity: 0.5;
        pointer-events: none;
    }

    .coming-badge {
        font-size: var(--text-xs);
        background: var(--bg-tertiary);
        color: var(--text-muted);
        padding: 2px 6px;
        border-radius: var(--radius-sm);
        margin-left: var(--space-2);
    }

    .features-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: var(--space-4);
        margin-top: var(--space-8);
        padding: var(--space-6);
        background: var(--bg-secondary);
        border-radius: var(--radius-xl);
    }

    .feature-item {
        text-align: center;
        padding: var(--space-4);
    }

    .feature-icon {
        font-size: 2rem;
        margin-bottom: var(--space-2);
    }

    .feature-item h4 {
        font-size: var(--text-sm);
        font-weight: 600;
        color: var(--text-primary);
        margin-bottom: var(--space-1);
    }

    .feature-item p {
        font-size: var(--text-xs);
        color: var(--text-muted);
    }
</style>

<div class="container">
    <!-- Breadcrumb -->
    <nav class="breadcrumb">
        <a href="<%=request.getContextPath()%>/exams/">Exams</a>
        <span class="breadcrumb-separator">/</span>
        <a href="<%=request.getContextPath()%>/exams/books/">Books</a>
        <span class="breadcrumb-separator">/</span>
        <span class="breadcrumb-current">NCERT Solutions</span>
    </nav>

    <!-- Hero Section -->
    <section class="ncert-hero">
        <h1>NCERT Solutions</h1>
        <p>Step-by-step solutions for all NCERT textbook exercises. Free, detailed explanations with hints and concepts.</p>
    </section>

    <!-- Ad: Header -->
    <%@ include file="../../components/ad-leaderboard.jsp" %>

    <!-- Class 9 Section -->
    <section class="class-section">
        <div class="class-header">
            <span class="class-badge">Class 9</span>
            <h2 class="class-title">Secondary School</h2>
        </div>

        <div class="subjects-grid">
            <a href="<%=request.getContextPath()%>/exams/books/ncert/class-9/mathematics/" class="subject-card">
                <div class="subject-icon math">&#128202;</div>
                <div class="subject-info">
                    <h3>Mathematics</h3>
                    <p>15 Chapters &bull; 244 Questions</p>
                </div>
            </a>

            <div class="subject-card coming-soon">
                <div class="subject-icon science">&#128300;</div>
                <div class="subject-info">
                    <h3>Science <span class="coming-badge">Soon</span></h3>
                    <p>Coming soon</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Class 10 Section -->
    <section class="class-section">
        <div class="class-header">
            <span class="class-badge" style="background: linear-gradient(135deg, #6366f1, #8b5cf6);">Class 10</span>
            <h2 class="class-title">Board Exam Year</h2>
        </div>

        <div class="subjects-grid">
            <a href="<%=request.getContextPath()%>/exams/books/ncert/class-10/mathematics/" class="subject-card">
                <div class="subject-icon math">&#128202;</div>
                <div class="subject-info">
                    <h3>Mathematics</h3>
                    <p>14 Chapters &bull; 354 Questions</p>
                </div>
            </a>

            <div class="subject-card coming-soon">
                <div class="subject-icon science">&#128300;</div>
                <div class="subject-info">
                    <h3>Science <span class="coming-badge">Soon</span></h3>
                    <p>Coming soon</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Class 11 Section -->
    <section class="class-section">
        <div class="class-header">
            <span class="class-badge" style="background: linear-gradient(135deg, #f59e0b, #f97316);">Class 11</span>
            <h2 class="class-title">Higher Secondary - Year 1</h2>
        </div>

        <div class="subjects-grid">
            <a href="<%=request.getContextPath()%>/exams/books/ncert/class-11/mathematics/" class="subject-card">
                <div class="subject-icon math">&#128202;</div>
                <div class="subject-info">
                    <h3>Mathematics</h3>
                    <p>14 Chapters &bull; 529 Questions</p>
                </div>
            </a>

            <a href="<%=request.getContextPath()%>/exams/books/ncert/class-11/physics-part-1/" class="subject-card">
                <div class="subject-icon physics">&#9889;</div>
                <div class="subject-info">
                    <h3>Physics Part 1</h3>
                    <p>7 Chapters &bull; 282 Questions</p>
                </div>
            </a>

            <a href="<%=request.getContextPath()%>/exams/books/ncert/class-11/physics-part-2/" class="subject-card">
                <div class="subject-icon physics">&#9889;</div>
                <div class="subject-info">
                    <h3>Physics Part 2</h3>
                    <p>7 Chapters &bull; 222 Questions</p>
                </div>
            </a>

            <div class="subject-card coming-soon">
                <div class="subject-icon chemistry">&#9878;</div>
                <div class="subject-info">
                    <h3>Chemistry <span class="coming-badge">Soon</span></h3>
                    <p>Coming soon</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Class 12 Section -->
    <section class="class-section">
        <div class="class-header">
            <span class="class-badge" style="background: linear-gradient(135deg, #ef4444, #dc2626);">Class 12</span>
            <h2 class="class-title">Higher Secondary - Year 2</h2>
        </div>

        <div class="subjects-grid">
            <a href="<%=request.getContextPath()%>/exams/books/ncert/class-12/mathematics-part-1/" class="subject-card">
                <div class="subject-icon math">&#128202;</div>
                <div class="subject-info">
                    <h3>Mathematics Part 1</h3>
                    <p>6 Chapters &bull; 413 Questions</p>
                </div>
            </a>

            <a href="<%=request.getContextPath()%>/exams/books/ncert/class-12/mathematics-part-2/" class="subject-card">
                <div class="subject-icon math">&#128202;</div>
                <div class="subject-info">
                    <h3>Mathematics Part 2</h3>
                    <p>7 Chapters &bull; 506 Questions</p>
                </div>
            </a>

            <a href="<%=request.getContextPath()%>/exams/books/ncert/class-12/physics-part-1/" class="subject-card">
                <div class="subject-icon physics">&#9889;</div>
                <div class="subject-info">
                    <h3>Physics Part 1</h3>
                    <p>8 Chapters &bull; 89 Questions</p>
                </div>
            </a>

            <a href="<%=request.getContextPath()%>/exams/books/ncert/class-12/physics-part-2/" class="subject-card">
                <div class="subject-icon physics">&#9889;</div>
                <div class="subject-info">
                    <h3>Physics Part 2</h3>
                    <p>6 Chapters &bull; 72 Questions</p>
                </div>
            </a>

            <div class="subject-card coming-soon">
                <div class="subject-icon chemistry">&#9878;</div>
                <div class="subject-info">
                    <h3>Chemistry <span class="coming-badge">Soon</span></h3>
                    <p>Coming soon</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Features -->
    <section class="features-grid">
        <div class="feature-item">
            <div class="feature-icon">&#128221;</div>
            <h4>Step-by-Step Solutions</h4>
            <p>Detailed explanations for every problem</p>
        </div>
        <div class="feature-item">
            <div class="feature-icon">&#128161;</div>
            <h4>Hints Available</h4>
            <p>Get hints before viewing full solution</p>
        </div>
        <div class="feature-item">
            <div class="feature-icon">&#127919;</div>
            <h4>Difficulty Levels</h4>
            <p>Easy, Medium, Hard indicators</p>
        </div>
        <div class="feature-item">
            <div class="feature-icon">&#128241;</div>
            <h4>Mobile Friendly</h4>
            <p>Study anywhere, anytime</p>
        </div>
    </section>
</div>

<!-- JSON-LD Structured Data -->
<script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "CollectionPage",
    "name": "NCERT Solutions",
    "description": "Free NCERT solutions for Class 6-12 with step-by-step explanations.",
    "url": "https://8gwifi.org/exams/books/ncert/",
    "publisher": {
        "@type": "Organization",
        "name": "8gwifi.org"
    },
    "mainEntity": {
        "@type": "ItemList",
        "itemListElement": [
            {
                "@type": "ListItem",
                "position": 1,
                "name": "Class 9 Mathematics",
                "url": "https://8gwifi.org/exams/books/ncert/class-9/mathematics/"
            },
            {
                "@type": "ListItem",
                "position": 2,
                "name": "Class 10 Mathematics",
                "url": "https://8gwifi.org/exams/books/ncert/class-10/mathematics/"
            },
            {
                "@type": "ListItem",
                "position": 3,
                "name": "Class 11 Mathematics",
                "url": "https://8gwifi.org/exams/books/ncert/class-11/mathematics/"
            },
            {
                "@type": "ListItem",
                "position": 4,
                "name": "Class 11 Physics Part 1",
                "url": "https://8gwifi.org/exams/books/ncert/class-11/physics-part-1/"
            },
            {
                "@type": "ListItem",
                "position": 5,
                "name": "Class 11 Physics Part 2",
                "url": "https://8gwifi.org/exams/books/ncert/class-11/physics-part-2/"
            },
            {
                "@type": "ListItem",
                "position": 6,
                "name": "Class 12 Mathematics Part 1",
                "url": "https://8gwifi.org/exams/books/ncert/class-12/mathematics-part-1/"
            },
            {
                "@type": "ListItem",
                "position": 7,
                "name": "Class 12 Mathematics Part 2",
                "url": "https://8gwifi.org/exams/books/ncert/class-12/mathematics-part-2/"
            },
            {
                "@type": "ListItem",
                "position": 8,
                "name": "Class 12 Physics Part 1",
                "url": "https://8gwifi.org/exams/books/ncert/class-12/physics-part-1/"
            },
            {
                "@type": "ListItem",
                "position": 9,
                "name": "Class 12 Physics Part 2",
                "url": "https://8gwifi.org/exams/books/ncert/class-12/physics-part-2/"
            }
        ]
    }
}
</script>

<%@ include file="../../components/footer.jsp" %>
