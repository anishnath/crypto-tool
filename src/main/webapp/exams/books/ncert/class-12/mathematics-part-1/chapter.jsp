<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%
    // Chapter slug to data mapping
    Map<String, String[]> chapterMap = new HashMap<>();
    // Format: slug -> [chapterNum, chapterName, metaDescription]
    chapterMap.put("relations-and-functions", new String[]{"1", "Relations and Functions", "NCERT Class 12 Maths Chapter 1 Relations and Functions solutions. Types of relations, types of functions, composition of functions, invertible functions, binary operations."});
    chapterMap.put("inverse-trigonometric-functions", new String[]{"2", "Inverse Trigonometric Functions", "NCERT Class 12 Maths Chapter 2 Inverse Trigonometric Functions solutions. Domain, range, principal value branches, properties of inverse trigonometric functions."});
    chapterMap.put("matrices", new String[]{"3", "Matrices", "NCERT Class 12 Maths Chapter 3 Matrices solutions. Types of matrices, operations on matrices, transpose, symmetric and skew-symmetric matrices, elementary operations, invertible matrices."});
    chapterMap.put("determinants", new String[]{"4", "Determinants", "NCERT Class 12 Maths Chapter 4 Determinants solutions. Determinant of a matrix, properties, area of a triangle, minors and cofactors, adjoint and inverse, applications."});
    chapterMap.put("continuity-and-differentiability", new String[]{"5", "Continuity and Differentiability", "NCERT Class 12 Maths Chapter 5 Continuity and Differentiability solutions. Continuity, differentiability, exponential and logarithmic functions, derivatives, second order derivatives, mean value theorem."});
    chapterMap.put("applications-of-derivatives", new String[]{"6", "Applications of Derivatives", "NCERT Class 12 Maths Chapter 6 Applications of Derivatives solutions. Rate of change, increasing and decreasing functions, tangents and normals, approximations, maxima and minima."});

    // Get chapter from URL path
    String requestURI = request.getRequestURI();
    String chapterSlug = "";

    // Extract chapter slug from path like /exams/books/ncert/class-12/mathematics-part-1/relations-and-functions/
    String[] pathParts = requestURI.split("/");
    for (int i = 0; i < pathParts.length; i++) {
        if ("mathematics-part-1".equals(pathParts[i]) && i + 1 < pathParts.length) {
            chapterSlug = pathParts[i + 1];
            break;
        }
    }

    // Remove trailing slash or .jsp
    if (chapterSlug.endsWith("/")) chapterSlug = chapterSlug.substring(0, chapterSlug.length() - 1);
    if (chapterSlug.endsWith(".jsp")) chapterSlug = chapterSlug.substring(0, chapterSlug.length() - 4);

    String[] chapterData = chapterMap.get(chapterSlug);
    String chapterNum = chapterData != null ? chapterData[0] : "1";
    String chapterName = chapterData != null ? chapterData[1] : "Chapter";
    String metaDesc = chapterData != null ? chapterData[2] : "NCERT Class 12 Maths solutions with step-by-step explanations.";

    request.setAttribute("pageTitle", "NCERT Class 12 Maths Chapter " + chapterNum + " " + chapterName + " Solutions");
    request.setAttribute("pageDescription", metaDesc);
    request.setAttribute("canonicalUrl", "https://8gwifi.org/exams/books/ncert/class-12/mathematics-part-1/" + chapterSlug + "/");

    // Pass to JavaScript
    request.setAttribute("chapterSlug", chapterSlug);
    request.setAttribute("chapterNum", chapterNum);
    request.setAttribute("chapterName", chapterName);
%>
<%@ include file="../../../../components/header.jsp" %>

<!-- NCERT Books CSS -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/exams/books/ncert/ncert-books.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<style>
    /* Inter font for math education pages */
    .container, .question-card, .solution-content, .chapter-hero {
        font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    }
    .chapter-hero {
        padding: var(--space-6) var(--space-4);
        background: linear-gradient(135deg, rgba(99, 102, 241, 0.1) 0%, rgba(139, 92, 246, 0.1) 100%);
        border-radius: var(--radius-xl);
        margin-bottom: var(--space-6);
    }

    .chapter-hero h1 {
        font-size: var(--text-2xl);
        font-weight: 800;
        color: var(--text-primary);
        margin-bottom: var(--space-2);
    }

    .chapter-hero p {
        font-size: var(--text-base);
        color: var(--text-secondary);
    }

    .chapter-stats {
        display: flex;
        gap: var(--space-4);
        margin-top: var(--space-4);
        flex-wrap: wrap;
    }

    .chapter-stat {
        background: var(--bg-primary);
        padding: var(--space-2) var(--space-4);
        border-radius: var(--radius-full);
        font-size: var(--text-sm);
        color: var(--text-secondary);
    }

    .chapter-stat strong {
        color: var(--accent);
    }

    /* Exercise Sections */
    .exercise-section {
        margin-bottom: var(--space-8);
    }

    .exercise-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: var(--space-4);
        background: var(--bg-secondary);
        border-radius: var(--radius-lg);
        margin-bottom: var(--space-4);
        cursor: pointer;
    }

    .exercise-header:hover {
        background: var(--bg-tertiary);
    }

    .exercise-title {
        font-size: var(--text-lg);
        font-weight: 700;
        color: var(--text-primary);
    }

    .exercise-count {
        font-size: var(--text-sm);
        color: var(--text-muted);
        background: var(--bg-primary);
        padding: var(--space-1) var(--space-3);
        border-radius: var(--radius-full);
    }

    /* Question Cards */
    .question-card {
        background: var(--bg-primary);
        border: 1px solid var(--border-primary);
        border-radius: var(--radius-lg);
        margin-bottom: var(--space-4);
        overflow: hidden;
    }

    .question-header {
        display: flex;
        align-items: flex-start;
        gap: var(--space-3);
        padding: var(--space-4);
    }

    .question-num {
        background: var(--accent);
        color: white;
        font-size: var(--text-xs);
        font-weight: 700;
        padding: var(--space-1) var(--space-2);
        border-radius: var(--radius-sm);
        flex-shrink: 0;
    }

    .question-text {
        font-size: var(--text-base);
        color: var(--text-primary);
        line-height: 1.7;
        flex: 1;
    }

    .question-meta {
        display: flex;
        gap: var(--space-3);
        padding: 0 var(--space-4) var(--space-3);
        flex-wrap: wrap;
    }

    .meta-badge {
        font-size: var(--text-xs);
        padding: 2px 8px;
        border-radius: var(--radius-sm);
        background: var(--bg-secondary);
        color: var(--text-muted);
    }

    .meta-badge.type-proof { background: rgba(139, 92, 246, 0.15); color: #8b5cf6; }
    .meta-badge.type-numerical { background: rgba(59, 130, 246, 0.15); color: #3b82f6; }
    .meta-badge.type-mcq { background: rgba(34, 197, 94, 0.15); color: #22c55e; }
    .meta-badge.difficulty-easy { background: rgba(34, 197, 94, 0.15); color: #22c55e; }
    .meta-badge.difficulty-medium { background: rgba(245, 158, 11, 0.15); color: #f59e0b; }
    .meta-badge.difficulty-hard { background: rgba(239, 68, 68, 0.15); color: #ef4444; }
    .meta-badge.has-plot { background: rgba(99, 102, 241, 0.15); color: #6366f1; }

    /* Solution Section */
    .solution-toggle {
        display: flex;
        gap: var(--space-2);
        padding: var(--space-3) var(--space-4);
        border-top: 1px solid var(--border-secondary);
        background: var(--bg-secondary);
    }

    .toggle-btn {
        padding: var(--space-2) var(--space-4);
        border: 1px solid var(--border-primary);
        border-radius: var(--radius-md);
        background: var(--bg-primary);
        color: var(--text-secondary);
        font-size: var(--text-sm);
        cursor: pointer;
        transition: all 0.2s;
        font-weight: 500;
    }

    .toggle-btn:hover {
        border-color: var(--accent);
        color: var(--accent);
    }

    .toggle-btn.active {
        background: var(--accent);
        border-color: var(--accent);
        color: white;
    }

    /* Dark mode */
    [data-theme="dark"] .toggle-btn {
        background: rgba(99, 102, 241, 0.1);
        border-color: rgba(99, 102, 241, 0.3);
        color: #a5b4fc;
    }

    [data-theme="dark"] .toggle-btn:hover {
        background: rgba(99, 102, 241, 0.2);
        border-color: #6366f1;
        color: #c7d2fe;
    }

    [data-theme="dark"] .toggle-btn.active {
        background: #6366f1;
        border-color: #6366f1;
        color: white;
    }

    [data-theme="dark"] .meta-badge {
        background: rgba(148, 163, 184, 0.15);
        color: #94a3b8;
    }

    [data-theme="dark"] .meta-badge.type-proof { background: rgba(139, 92, 246, 0.2); color: #a78bfa; }
    [data-theme="dark"] .meta-badge.type-numerical { background: rgba(59, 130, 246, 0.2); color: #93c5fd; }
    [data-theme="dark"] .meta-badge.type-mcq { background: rgba(34, 197, 94, 0.2); color: #86efac; }
    [data-theme="dark"] .meta-badge.difficulty-easy { background: rgba(34, 197, 94, 0.2); color: #86efac; }
    [data-theme="dark"] .meta-badge.difficulty-medium { background: rgba(245, 158, 11, 0.2); color: #fcd34d; }
    [data-theme="dark"] .meta-badge.difficulty-hard { background: rgba(239, 68, 68, 0.2); color: #fca5a5; }
    [data-theme="dark"] .meta-badge.has-plot { background: rgba(99, 102, 241, 0.2); color: #a5b4fc; }

    [data-theme="dark"] .solution-toggle {
        background: rgba(30, 41, 59, 0.8);
        border-color: rgba(99, 102, 241, 0.15);
    }

    [data-theme="dark"] .view-full-btn {
        background: rgba(99, 102, 241, 0.15);
        border-color: rgba(99, 102, 241, 0.4);
        color: #a5b4fc;
    }

    [data-theme="dark"] .view-full-btn:hover {
        background: #6366f1;
        color: white;
    }

    [data-theme="dark"] .answer-label {
        color: #4ade80;
    }

    [data-theme="dark"] .hint-text {
        background: rgba(245, 158, 11, 0.12);
        border-left-color: #fbbf24;
        color: #cbd5e1;
    }

    .view-full-btn {
        text-decoration: none;
        background: linear-gradient(135deg, rgba(99, 102, 241, 0.1) 0%, rgba(139, 92, 246, 0.1) 100%);
        border-color: var(--accent);
        color: var(--accent);
        margin-left: auto;
    }

    .view-full-btn:hover {
        background: var(--accent);
        color: white;
    }

    .hint-content,
    .solution-content {
        display: none;
        padding: var(--space-4);
        border-top: 1px solid var(--border-secondary);
        background: var(--bg-secondary);
    }

    .hint-content.show,
    .solution-content.show {
        display: block;
    }

    .hint-text {
        color: var(--text-secondary);
        font-style: italic;
        padding: var(--space-3);
        background: rgba(245, 158, 11, 0.1);
        border-left: 3px solid #f59e0b;
        border-radius: var(--radius-sm);
    }

    /* Solution Steps Container */
    .solution-steps-container {
        background: linear-gradient(135deg, rgba(99, 102, 241, 0.05) 0%, rgba(139, 92, 246, 0.08) 100%);
        border: 1px solid rgba(99, 102, 241, 0.2);
        border-radius: var(--radius-lg);
        padding: var(--space-4);
        margin-bottom: var(--space-4);
    }

    .solution-steps-header {
        display: flex;
        align-items: center;
        gap: var(--space-2);
        margin-bottom: var(--space-4);
        padding-bottom: var(--space-3);
        border-bottom: 2px solid rgba(99, 102, 241, 0.2);
    }

    .solution-steps-icon {
        width: 32px;
        height: 32px;
        background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
        border-radius: var(--radius-md);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 16px;
    }

    .solution-steps-title {
        font-size: var(--text-base);
        font-weight: 700;
        color: var(--text-primary);
        letter-spacing: -0.01em;
    }

    .solution-steps-count {
        margin-left: auto;
        font-size: var(--text-xs);
        color: var(--text-muted);
        background: var(--bg-primary);
        padding: 2px 8px;
        border-radius: var(--radius-full);
    }

    .solution-steps {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .solution-step {
        display: flex;
        gap: var(--space-3);
        padding: var(--space-3);
        margin-bottom: var(--space-2);
        background: var(--bg-primary);
        border-radius: var(--radius-md);
        border-left: 3px solid var(--accent);
        transition: transform 0.15s ease, box-shadow 0.15s ease;
    }

    .solution-step:last-child {
        margin-bottom: 0;
    }

    .solution-step:hover {
        transform: translateX(4px);
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
    }

    .step-num {
        width: 28px;
        height: 28px;
        background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
        color: white;
        font-size: var(--text-sm);
        font-weight: 700;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
        box-shadow: 0 2px 4px rgba(99, 102, 241, 0.3);
    }

    .step-text {
        color: var(--text-primary);
        line-height: 1.7;
        font-size: var(--text-sm);
        padding-top: 3px;
    }

    /* Answer Box */
    .answer-box {
        background: linear-gradient(135deg, rgba(34, 197, 94, 0.08) 0%, rgba(16, 185, 129, 0.12) 100%);
        border: 1px solid rgba(34, 197, 94, 0.25);
        border-radius: var(--radius-lg);
        padding: var(--space-4);
        position: relative;
        overflow: hidden;
    }

    .answer-box::before {
        content: '';
        position: absolute;
        left: 0;
        top: 0;
        bottom: 0;
        width: 4px;
        background: linear-gradient(180deg, #22c55e 0%, #10b981 100%);
    }

    .answer-header {
        display: flex;
        align-items: center;
        gap: var(--space-2);
        margin-bottom: var(--space-2);
    }

    .answer-icon {
        width: 24px;
        height: 24px;
        background: linear-gradient(135deg, #22c55e 0%, #10b981 100%);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 12px;
    }

    .answer-label {
        font-size: var(--text-sm);
        font-weight: 700;
        color: #16a34a;
        text-transform: uppercase;
        letter-spacing: 0.05em;
    }

    .answer-text {
        color: var(--text-primary);
        font-weight: 600;
        font-size: var(--text-base);
        padding-left: 32px;
        line-height: 1.6;
    }

    /* Data Tables */
    .data-table-wrapper {
        overflow-x: auto;
        margin: var(--space-3) 0;
        border-radius: var(--radius-md);
        border: 1px solid var(--border-primary);
    }

    .data-table {
        width: 100%;
        border-collapse: collapse;
        font-size: var(--text-sm);
        background: var(--bg-primary);
    }

    .data-table th,
    .data-table td {
        padding: var(--space-2) var(--space-3);
        text-align: left;
        border-bottom: 1px solid var(--border-secondary);
    }

    .data-table th {
        background: linear-gradient(135deg, rgba(99, 102, 241, 0.1) 0%, rgba(139, 92, 246, 0.1) 100%);
        font-weight: 600;
        color: var(--text-primary);
        white-space: nowrap;
    }

    .data-table td {
        color: var(--text-secondary);
    }

    .data-table tr:last-child td {
        border-bottom: none;
    }

    .data-table tr:hover td {
        background: var(--bg-secondary);
    }

    .question-text p {
        margin-bottom: var(--space-2);
    }

    .question-text p:last-child {
        margin-bottom: 0;
    }

    /* Loading */
    .loading-container {
        text-align: center;
        padding: var(--space-8);
    }

    .loading-spinner {
        width: 40px;
        height: 40px;
        border: 3px solid var(--border-secondary);
        border-top-color: var(--accent);
        border-radius: 50%;
        animation: spin 1s linear infinite;
        margin: 0 auto var(--space-4);
    }

    @keyframes spin {
        to { transform: rotate(360deg); }
    }

    /* Diagram Styles */
    .diagram-container {
        margin: 0 var(--space-4) var(--space-3);
    }

    .diagram-image {
        display: flex;
        justify-content: center;
        padding: var(--space-4);
        background: var(--bg-secondary);
        border-radius: var(--radius-md);
        margin-bottom: var(--space-3);
    }

    .svg-diagram {
        max-width: 100%;
        height: auto;
        max-height: 300px;
    }

    @media (prefers-color-scheme: dark) {
        .svg-diagram {
            filter: invert(0.85) hue-rotate(180deg);
        }
    }

    /* Interactive Plot */
    .plot-container {
        margin: var(--space-4) 0;
        padding: var(--space-4);
        background: var(--bg-primary);
        border: 1px solid rgba(99, 102, 241, 0.2);
        border-radius: var(--radius-lg);
    }

    .plot-header {
        display: flex;
        align-items: center;
        gap: var(--space-2);
        margin-bottom: var(--space-3);
        font-size: var(--text-sm);
        font-weight: 600;
        color: var(--accent);
    }

    .plot-target {
        width: 100%;
        min-height: 300px;
    }

    .plot-legend {
        display: flex;
        flex-wrap: wrap;
        gap: var(--space-2) var(--space-4);
        padding: var(--space-3) var(--space-2) 0;
        font-size: var(--text-xs);
        color: var(--text-secondary);
    }

    .plot-legend-item {
        display: flex;
        align-items: center;
        gap: 6px;
    }

    .plot-legend-swatch {
        width: 18px;
        height: 3px;
        border-radius: 2px;
        flex-shrink: 0;
    }

    /* function-plot SVG theme overrides */
    .plot-target .function-plot {
        background: var(--bg-secondary) !important;
        border-radius: var(--radius-md);
    }

    .plot-target text {
        fill: var(--text-secondary) !important;
        font-family: inherit !important;
    }

    .plot-target .tick text {
        fill: var(--text-muted) !important;
        font-size: 11px !important;
    }

    .plot-target .axis path,
    .plot-target .axis line {
        stroke: var(--text-muted) !important;
        stroke-opacity: 0.5 !important;
    }

    .plot-target .top-right-legend text {
        fill: var(--text-primary) !important;
        font-size: 12px !important;
    }

    .plot-target .annotation text {
        fill: var(--text-primary) !important;
        font-weight: 600 !important;
        font-size: 12px !important;
    }

    .plot-target .annotation .line {
        stroke: var(--text-muted) !important;
        stroke-dasharray: 4 4 !important;
    }

    .plot-target .graph-grid .tick line {
        stroke: var(--border, #334155) !important;
        stroke-opacity: 0.3 !important;
    }

    .plot-target .origin {
        stroke: var(--text-muted) !important;
        stroke-opacity: 0.6 !important;
    }

    /* Mobile */
    @media (max-width: 640px) {
        .chapter-hero h1 {
            font-size: var(--text-xl);
        }

        .question-header {
            flex-direction: column;
        }

        .solution-toggle {
            flex-wrap: wrap;
        }

        .svg-diagram {
            max-height: 200px;
        }

        .plot-target {
            min-height: 250px;
        }
    }
</style>

<!-- Breadcrumb (Full Width) -->
<div class="container">
    <nav class="breadcrumb">
        <a href="<%=request.getContextPath()%>/exams/">Exams</a>
        <span class="breadcrumb-separator">/</span>
        <a href="<%=request.getContextPath()%>/exams/books/">Books</a>
        <span class="breadcrumb-separator">/</span>
        <a href="<%=request.getContextPath()%>/exams/books/ncert/">NCERT</a>
        <span class="breadcrumb-separator">/</span>
        <a href="<%=request.getContextPath()%>/exams/books/ncert/class-12/mathematics-part-1/">Class 12 Maths Part 1</a>
        <span class="breadcrumb-separator">/</span>
        <span class="breadcrumb-current"><%= chapterName %></span>
    </nav>
</div>

<!-- Three Column Layout -->
<div class="three-col-layout">
    <!-- Left Sidebar Ads (Large Desktop >=1400px) -->
    <aside class="ad-sidebar ad-sidebar-left">
        <div class="ad-sidebar-inner">
            <%@ include file="../../../../components/ad-sidebar-left.jsp" %>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content-area">
        <!-- Hero Section -->
        <section class="chapter-hero">
            <h1>Chapter <%= chapterNum %>: <%= chapterName %></h1>
            <p>NCERT Class 12 Mathematics Part 1 Solutions</p>
            <div class="chapter-stats" id="chapterStats">
                <span class="chapter-stat">Loading...</span>
            </div>
        </section>

        <!-- Ad: Header (Mobile/Tablet) -->
        <div class="mobile-ad-container">
            <%@ include file="../../../../components/ad-leaderboard.jsp" %>
        </div>

        <!-- Questions Container -->
        <div id="questionsContainer">
            <div class="loading-container">
                <div class="loading-spinner"></div>
                <p>Loading questions...</p>
            </div>
        </div>
    </main>

    <!-- Right Sidebar Ads (Desktop >=992px) -->
    <aside class="ad-sidebar ad-sidebar-right">
        <div class="ad-sidebar-inner">
            <%@ include file="../../../../components/ad-sidebar.jsp" %>
        </div>
    </aside>
</div>

<!-- Noscript fallback for SEO -->
<noscript>
    <div class="seo-content" style="padding: 20px;">
        <h2>NCERT Class 12 Mathematics Part 1 - Chapter <%= chapterNum %>: <%= chapterName %> Solutions</h2>
        <p><%= metaDesc %></p>
        <p>This page contains complete solutions for all exercises in Chapter <%= chapterNum %> (<%= chapterName %>) from NCERT Class 12 Mathematics Part 1 textbook. Each question includes step-by-step solutions, hints, and detailed explanations.</p>

        <h3>Topics Covered in <%= chapterName %>:</h3>
        <ul>
            <li>All exercise questions with detailed solutions</li>
            <li>Step-by-step explanations for each problem</li>
            <li>Important formulas and theorems</li>
        </ul>

        <p><strong>Looking for specific questions?</strong> Enable JavaScript to view all questions with interactive solutions, diagrams, and hints.</p>

        <h3>Related Chapters:</h3>
        <ul>
            <li><a href="/exams/books/ncert/class-12/mathematics-part-1/relations-and-functions/">Chapter 1: Relations and Functions</a></li>
            <li><a href="/exams/books/ncert/class-12/mathematics-part-1/inverse-trigonometric-functions/">Chapter 2: Inverse Trigonometric Functions</a></li>
            <li><a href="/exams/books/ncert/class-12/mathematics-part-1/matrices/">Chapter 3: Matrices</a></li>
            <li><a href="/exams/books/ncert/class-12/mathematics-part-1/determinants/">Chapter 4: Determinants</a></li>
            <li><a href="/exams/books/ncert/class-12/mathematics-part-1/continuity-and-differentiability/">Chapter 5: Continuity and Differentiability</a></li>
            <li><a href="/exams/books/ncert/class-12/mathematics-part-1/applications-of-derivatives/">Chapter 6: Applications of Derivatives</a></li>
        </ul>
    </div>
</noscript>

<!-- JSON-LD Structured Data -->
<script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "Course",
    "name": "NCERT Class 12 Maths Chapter <%= chapterNum %> - <%= chapterName %>",
    "description": "<%= metaDesc %>",
    "url": "https://8gwifi.org/exams/books/ncert/class-12/mathematics-part-1/<%= chapterSlug %>/",
    "provider": {
        "@type": "Organization",
        "name": "8gwifi.org",
        "url": "https://8gwifi.org"
    },
    "educationalLevel": "Class 12",
    "teaches": "<%= chapterName %>",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "audience": {
        "@type": "EducationalAudience",
        "educationalRole": "student"
    },
    "hasCourseInstance": {
        "@type": "CourseInstance",
        "courseMode": "online",
        "courseWorkload": "PT1H"
    }
}
</script>

<script>
(function() {
    var CHAPTER_NUM = '<%= chapterNum %>';
    var CHAPTER_NAME = '<%= chapterName.replace("'", "\\'") %>';
    var container = document.getElementById('questionsContainer');
    var statsContainer = document.getElementById('chapterStats');

    // Helper: Convert pipe-delimited table text to HTML table
    function convertPipeTableToHtml(text) {
        var lines = text.split('\n');
        var result = [];
        var inTable = false;
        var tableRows = [];

        for (var i = 0; i < lines.length; i++) {
            var line = lines[i].trim();

            if (line.indexOf('|') > -1 && line.split('|').length >= 2) {
                if (!inTable) {
                    inTable = true;
                    tableRows = [];
                }
                tableRows.push(line);
            } else {
                if (inTable && tableRows.length > 0) {
                    result.push(buildHtmlTable(tableRows));
                    tableRows = [];
                    inTable = false;
                }
                if (line) {
                    result.push('<p>' + line + '</p>');
                }
            }
        }

        if (inTable && tableRows.length > 0) {
            result.push(buildHtmlTable(tableRows));
        }

        return result.join('');
    }

    // Helper: Build HTML table from pipe-delimited rows
    function buildHtmlTable(rows) {
        var html = '<div class="data-table-wrapper"><table class="data-table">';

        rows.forEach(function(row, idx) {
            var cells = row.split('|').map(function(c) { return c.trim(); }).filter(function(c) { return c !== ''; });
            var tag = idx === 0 ? 'th' : 'td';
            html += '<tr>';
            cells.forEach(function(cell) {
                html += '<' + tag + '>' + cell + '</' + tag + '>';
            });
            html += '</tr>';
        });

        html += '</table></div>';
        return html;
    }

    // Helper: Format text with proper line breaks
    function formatTextWithLineBreaks(text) {
        if (!text) return '';

        var formatted = text.replace(/\\n/g, '<br>');
        formatted = formatted.replace(/\n/g, '<br>');
        formatted = formatted.replace(/([.?!])\s*(\([ivxlcdm]+\))/gi, '$1<br><br>$2');
        formatted = formatted.replace(/([.?!])\s*(\([a-z]\))/gi, '$1<br><br>$2');
        formatted = formatted.replace(/(\([ivxlcdm]+\)[^(]+?)(\([ivxlcdm]+\))/gi, '$1<br>$2');
        formatted = formatted.replace(/(\([a-z]\)[^(]+?)(\([a-z]\))/gi, '$1<br>$2');

        return formatted;
    }

    // Helper: Get question text - use plain text for tabular questions
    function getQuestionText(q) {
        var latex = q.question_latex || '';
        var plain = q.question_plain || '';

        if (latex.indexOf('\\begin{tabular}') > -1) {
            return convertPipeTableToHtml(plain);
        }

        return formatTextWithLineBreaks(latex || plain);
    }

    // Helper: Format answer/solution text
    function formatAnswerText(text) {
        return formatTextWithLineBreaks(text);
    }

    // Helper: Build question slug for individual page URL
    function buildQuestionSlug(q) {
        var exercise = q.exercise;
        if (exercise.toLowerCase().indexOf('miscellaneous') > -1) {
            return 'misc-' + q.question_number.toLowerCase();
        }
        var exNum = exercise.replace('Exercise ', '').replace(/\s*\([^)]*\)/g, '').replace('.', '-');
        return 'ex-' + exNum + '-' + q.question_number.toLowerCase();
    }

    // Load chapter data
    fetch('<%=request.getContextPath()%>/exams/books/ncert/class-12/mathematics-part-1/data/chapters.json')
        .then(function(response) { return response.json(); })
        .then(function(data) {
            // Filter questions for this chapter
            var chapterQuestions = data.filter(function(q) {
                var chNum = q.chapter.match(/Chapter (\d+)/);
                return chNum && chNum[1] === CHAPTER_NUM;
            });

            if (chapterQuestions.length === 0) {
                container.innerHTML = '<div class="card" style="text-align:center;padding:var(--space-8);">No questions found for this chapter.</div>';
                return;
            }

            // Group by exercise
            var exercises = {};
            chapterQuestions.forEach(function(q) {
                var ex = q.exercise || 'Miscellaneous';
                if (!exercises[ex]) exercises[ex] = [];
                exercises[ex].push(q);
            });

            // Update stats
            var exerciseCount = Object.keys(exercises).length;
            statsContainer.innerHTML =
                '<span class="chapter-stat"><strong>' + chapterQuestions.length + '</strong> Questions</span>' +
                '<span class="chapter-stat"><strong>' + exerciseCount + '</strong> Exercises</span>' +
                '<span class="chapter-stat"><strong>NCERT</strong> Book</span>';

            // Render exercises
            var html = '';
            var exerciseKeys = Object.keys(exercises).sort();
            var questionIndex = 0;

            exerciseKeys.forEach(function(exKey, exIdx) {
                var questions = exercises[exKey];

                html += '<section class="exercise-section">';
                html += '<div class="exercise-header" onclick="toggleExercise(this)">';
                html += '<span class="exercise-title">' + exKey + '</span>';
                html += '<span class="exercise-count">' + questions.length + ' questions</span>';
                html += '</div>';
                html += '<div class="exercise-questions">';

                questions.forEach(function(q, qIdx) {
                    var qId = 'q_' + exIdx + '_' + qIdx;
                    var diffClass = q.difficulty < 0.4 ? 'easy' : (q.difficulty < 0.7 ? 'medium' : 'hard');
                    var diffLabel = q.difficulty < 0.4 ? 'Easy' : (q.difficulty < 0.7 ? 'Medium' : 'Hard');
                    var typeClass = q.type.toLowerCase().replace(/\s+/g, '');

                    html += '<div class="question-card">';
                    html += '<div class="question-header">';
                    html += '<span class="question-num">' + q.question_number + '</span>';
                    html += '<div class="question-text">' + getQuestionText(q) + '</div>';
                    html += '</div>';

                    html += '<div class="question-meta">';
                    html += '<span class="meta-badge type-' + typeClass + '">' + q.type + '</span>';
                    html += '<span class="meta-badge difficulty-' + diffClass + '">' + diffLabel + '</span>';
                    html += '<span class="meta-badge">' + q.marks + ' Marks</span>';
                    if (q.interactive_plot) html += '<span class="meta-badge has-plot">&#128200; Interactive Graph</span>';
                    html += '</div>';

                    // Display diagram if question has one
                    if (q.visual_content && q.visual_content.has_diagram) {
                        html += '<div class="diagram-container no-mathjax">';

                        if (q.visual_content.diagram_svg) {
                            html += '<div class="diagram-image">';
                            html += '<img src="<%=request.getContextPath()%>/exams/books/ncert/class-12/mathematics-part-1/diagrams/' + q.visual_content.diagram_svg + '" ';
                            html += 'alt="' + (q.visual_content.diagram_description || 'Diagram') + '" ';
                            html += 'loading="lazy" class="svg-diagram">';
                            html += '</div>';
                        }

                        if (q.visual_content.diagram_description) {
                            html += '<div class="diagram-notice">';
                            html += '<span class="diagram-icon">&#128202;</span>';
                            html += '<div class="diagram-text">';
                            html += '<span class="diagram-label">Figure:</span> ';
                            html += q.visual_content.diagram_description;
                            html += '</div>';
                            html += '</div>';
                        }

                        html += '</div>';
                    }

                    // Build link to individual question page
                    var questionPageUrl = buildQuestionSlug(q) + '.jsp';

                    html += '<div class="solution-toggle">';
                    if (q.hint) {
                        html += '<button class="toggle-btn" onclick="toggleHint(\'' + qId + '\')">Show Hint</button>';
                    }
                    html += '<button class="toggle-btn" onclick="toggleSolution(\'' + qId + '\')">Show Solution</button>';
                    html += '<a href="' + questionPageUrl + '" class="toggle-btn view-full-btn" title="Open dedicated page for this question">View Full Page &rarr;</a>';
                    html += '</div>';

                    if (q.hint) {
                        html += '<div class="hint-content" id="hint_' + qId + '">';
                        html += '<div class="hint-text">' + formatTextWithLineBreaks(q.hint) + '</div>';
                        html += '</div>';
                    }

                    html += '<div class="solution-content" id="sol_' + qId + '">';

                    // Use solution_steps_latex if available, otherwise fall back to solution_steps
                    var displaySteps = q.solution_steps_latex || q.solution_steps;
                    if (displaySteps && displaySteps.length > 0) {
                        html += '<div class="solution-steps-container">';
                        html += '<div class="solution-steps-header">';
                        html += '<div class="solution-steps-icon">&#9998;</div>';
                        html += '<span class="solution-steps-title">Solution Steps</span>';
                        html += '<span class="solution-steps-count">' + displaySteps.length + ' steps</span>';
                        html += '</div>';
                        html += '<ul class="solution-steps">';
                        displaySteps.forEach(function(step, sIdx) {
                            html += '<li class="solution-step">';
                            html += '<span class="step-num">' + (sIdx + 1) + '</span>';
                            html += '<span class="step-text">' + formatTextWithLineBreaks(step) + '</span>';
                            html += '</li>';
                        });
                        html += '</ul>';
                        html += '</div>';
                    }

                    // Answer Box
                    html += '<div class="answer-box">';
                    html += '<div class="answer-header">';
                    html += '<div class="answer-icon">&#10003;</div>';
                    html += '<span class="answer-label">Final Answer</span>';
                    html += '</div>';
                    html += '<div class="answer-text">' + formatAnswerText(q.correct_answer_latex || q.correct_answer_plain) + '</div>';
                    html += '</div>';

                    // Interactive Plot (supports string or array of slugs)
                    if (q.interactive_plot) {
                        var plotSlugs = Array.isArray(q.interactive_plot) ? q.interactive_plot : [q.interactive_plot];
                        plotSlugs.forEach(function(slug, pIdx) {
                            var plotId = 'plot_' + exIdx + '_' + qIdx + '_' + pIdx;
                            html += '<div class="plot-container">';
                            html += '<div class="plot-header">&#128200; Interactive Graph</div>';
                            html += '<div class="plot-target" id="' + plotId + '" data-plot-slug="' + slug + '"></div>';
                            html += '<div class="plot-legend" id="' + plotId + '_legend"></div>';
                            html += '</div>';
                        });
                    }

                    html += '</div>';

                    html += '</div>';

                    questionIndex++;
                    if (questionIndex % 5 === 0 && questionIndex < chapterQuestions.length) {
                        html += '<div style="margin: var(--space-4) 0; text-align: center;">';
                        html += '<div class="ad-placeholder" style="background:var(--bg-secondary);padding:var(--space-4);border-radius:var(--radius-md);color:var(--text-muted);font-size:var(--text-sm);">Advertisement</div>';
                        html += '</div>';
                    }
                });

                html += '</div></section>';
            });

            container.innerHTML = html;

            // Re-render MathJax
            function renderMath() {
                if (window.MathJax && window.MathJax.typesetPromise) {
                    MathJax.typesetPromise([container]).catch(function(err) {
                        console.log('MathJax error:', err);
                    });
                } else {
                    setTimeout(renderMath, 100);
                }
            }

            if (window.MathJax && window.MathJax.startup && window.MathJax.startup.promise) {
                window.MathJax.startup.promise.then(function() {
                    MathJax.typesetPromise([container]).catch(function(err) {
                        console.log('MathJax error:', err);
                    });
                });
            } else {
                renderMath();
            }

            // Generate FAQ Schema for SEO
            generateFAQSchema(chapterQuestions);
        })
        .catch(function(error) {
            console.error('Error loading questions:', error);
            container.innerHTML = '<div class="card" style="text-align:center;padding:var(--space-8);color:var(--error);">Error loading questions. Please try again.</div>';
        });
})();

function toggleExercise(header) {
    var questions = header.nextElementSibling;
    questions.style.display = questions.style.display === 'none' ? 'block' : 'none';
}

function toggleHint(qId) {
    var hint = document.getElementById('hint_' + qId);
    var btn = hint.previousElementSibling.querySelector('button');
    hint.classList.toggle('show');
    btn.textContent = hint.classList.contains('show') ? 'Hide Hint' : 'Show Hint';
    btn.classList.toggle('active');
}

function toggleSolution(qId) {
    var sol = document.getElementById('sol_' + qId);
    var btns = sol.previousElementSibling.previousElementSibling.querySelectorAll('button');
    var btn = btns[btns.length - 1];
    sol.classList.toggle('show');
    btn.textContent = sol.classList.contains('show') ? 'Hide Solution' : 'Show Solution';
    btn.classList.toggle('active');

    if (sol.classList.contains('show')) {
        if (window.MathJax && window.MathJax.typesetPromise) {
            MathJax.typesetPromise([sol]).catch(function(err) {
                console.log('MathJax error:', err);
            });
        }
        // Render any plots inside this solution
        var plotTargets = sol.querySelectorAll('.plot-target[data-plot-slug]');
        if (plotTargets.length > 0) {
            renderPlots(plotTargets);
        }
    }
}

// --- Interactive Plot Support ---
var _plotDataCache = {};
var _functionPlotLoaded = false;

function loadFunctionPlot(callback) {
    if (_functionPlotLoaded) { callback(); return; }
    var script = document.createElement('script');
    script.src = 'https://unpkg.com/function-plot/dist/function-plot.js';
    script.onload = function() { _functionPlotLoaded = true; callback(); };
    document.head.appendChild(script);
}

function getPlotFile() {
    return '<%=request.getContextPath()%>/exams/books/ncert/class-12/mathematics-part-1/data/plots/ch' + '<%= chapterNum %>' + '-plots.json';
}

function renderPlots(targets) {
    var plotFile = getPlotFile();

    function doRender(plotData) {
        targets.forEach(function(el) {
            if (el.dataset.rendered) return;
            var slug = el.dataset.plotSlug;
            var config = plotData[slug];
            if (!config) return;

            loadFunctionPlot(function() {
                try {
                    var plotConfig = {
                        target: '#' + el.id,
                        width: el.offsetWidth || 500,
                        height: 300,
                        grid: true,
                        xAxis: { domain: config.xDomain || [-10, 10] },
                        yAxis: { domain: config.yDomain || [-10, 10] },
                        data: config.data.map(function(d) {
                            var item = { color: d.color || '#6366f1' };
                            if (d.fnType === 'parametric') {
                                item.fnType = 'parametric';
                                item.x = d.x;
                                item.y = d.y;
                                if (d.graphType) item.graphType = d.graphType;
                            } else {
                                item.fn = d.fn;
                                if (d.fnType) item.fnType = d.fnType;
                            }
                            if (d.range) item.range = d.range;
                            if (d.derivative) item.derivative = d.derivative;
                            if (d.skipTip) item.skipTip = d.skipTip;
                            if (d.label) item.attr = { 'data-label': d.label };
                            return item;
                        }),
                        annotations: (config.annotations || []).map(function(a) {
                            return { x: a.x, text: a.text };
                        })
                    };
                    functionPlot(plotConfig);
                    el.dataset.rendered = 'true';
                    // Build legend
                    var legendEl = document.getElementById(el.id + '_legend');
                    if (legendEl) {
                        var legendHtml = '';
                        config.data.forEach(function(d) {
                            if (d.label && !d.skipTip) {
                                legendHtml += '<span class="plot-legend-item">'
                                    + '<span class="plot-legend-swatch" style="background:' + (d.color || '#6366f1') + '"></span>'
                                    + d.label + '</span>';
                            }
                        });
                        legendEl.innerHTML = legendHtml;
                    }
                } catch (e) {
                    console.log('Plot error for ' + slug + ':', e);
                }
            });
        });
    }

    if (_plotDataCache[plotFile]) {
        doRender(_plotDataCache[plotFile]);
    } else {
        fetch(plotFile)
            .then(function(r) {
                if (!r.ok) throw new Error('Plot file not found: ' + r.status);
                return r.json();
            })
            .then(function(data) {
                _plotDataCache[plotFile] = data;
                doRender(data);
            })
            .catch(function(err) { console.log('Plot data load error:', err); });
    }
}

// Generate FAQ Schema for SEO
function generateFAQSchema(questions) {
    var faqItems = questions.map(function(q) {
        var questionText = (q.question_plain || q.question_latex || '')
            .replace(/\\[\(\)\[\]]/g, '')
            .replace(/\\\w+/g, '')
            .substring(0, 500);

        var answerParts = [];
        var steps = q.solution_steps_latex || q.solution_steps;
        if (steps && steps.length > 0) {
            answerParts = steps.map(function(step, i) {
                return 'Step ' + (i + 1) + ': ' + step
                    .replace(/\\[\(\)\[\]]/g, '')
                    .replace(/\\\w+/g, '');
            });
        }
        var finalAnswer = (q.correct_answer_plain || q.correct_answer_latex || '')
            .replace(/\\[\(\)\[\]]/g, '')
            .replace(/\\\w+/g, '');

        answerParts.push('Answer: ' + finalAnswer);

        return {
            "@type": "Question",
            "name": "NCERT Class 12 Maths " + q.exercise + " " + q.question_number + ": " + questionText.substring(0, 100) + (questionText.length > 100 ? '...' : ''),
            "acceptedAnswer": {
                "@type": "Answer",
                "text": answerParts.join(' ')
            }
        };
    });

    var schema = {
        "@context": "https://schema.org",
        "@type": "FAQPage",
        "mainEntity": faqItems.slice(0, 20)
    };

    var script = document.createElement('script');
    script.type = 'application/ld+json';
    script.textContent = JSON.stringify(schema);
    document.head.appendChild(script);
}
</script>

<!-- Ad Blocker Layout Fix -->
<script>
(function() {
    function checkAdBlockerLayout() {
        var leftSidebar = document.querySelector('.ad-sidebar-left');
        var rightSidebar = document.querySelector('.ad-sidebar-right');
        var layout = document.querySelector('.three-col-layout');

        if (!layout) return;

        var leftHidden = !leftSidebar ||
            leftSidebar.offsetHeight === 0 ||
            leftSidebar.offsetWidth === 0 ||
            getComputedStyle(leftSidebar).display === 'none' ||
            getComputedStyle(leftSidebar).visibility === 'hidden';

        var rightHidden = !rightSidebar ||
            rightSidebar.offsetHeight === 0 ||
            rightSidebar.offsetWidth === 0 ||
            getComputedStyle(rightSidebar).display === 'none' ||
            getComputedStyle(rightSidebar).visibility === 'hidden';

        if ((leftHidden || rightHidden) && window.innerWidth >= 1200) {
            layout.style.gridTemplateColumns = '1fr';
            layout.style.maxWidth = '1000px';

            var mainContent = layout.querySelector('.main-content-area');
            if (mainContent) {
                mainContent.style.maxWidth = '100%';
            }
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            setTimeout(checkAdBlockerLayout, 100);
        });
    } else {
        setTimeout(checkAdBlockerLayout, 100);
    }

    window.addEventListener('resize', checkAdBlockerLayout);
})();
</script>

<%@ include file="../../../../components/footer.jsp" %>
