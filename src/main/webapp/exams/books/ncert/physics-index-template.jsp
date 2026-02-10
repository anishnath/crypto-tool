<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="physics-config.jsp" %>
<%
    // Helper labels
    String ncertLabel = "NCERT " + bookClassLabel + " " + subject;
    int chapterCount = chapterMap.size();

    // Build chapter names for meta description
    StringBuilder chNameList = new StringBuilder();
    for (String[] ch : chapterMap.values()) {
        if (chNameList.length() > 0) chNameList.append(", ");
        chNameList.append(ch[1]);
    }

    String pageTitle = ncertLabel + (partLabel.isEmpty() ? "" : " " + partLabel) + " Solutions - All Chapters (Free)";
    String pageDescription = "Free " + ncertLabel + (partLabel.isEmpty() ? "" : " " + partLabel) + " solutions for all " + chapterCount + " chapters. Step-by-step answers for " + chNameList + ". CBSE board aligned.";

    request.setAttribute("pageTitle", pageTitle);
    request.setAttribute("pageDescription", pageDescription);
    request.setAttribute("canonicalUrl", "https://8gwifi.org/exams/books/ncert/" + bookClass + "/" + bookPart + "/");
%>
<%@ include file="../../components/header.jsp" %>

<!-- NCERT Books CSS -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/exams/books/ncert/ncert-books.css">

<style>
    .subject-hero {
        padding: var(--space-6) var(--space-4);
        background: linear-gradient(135deg, rgba(59, 130, 246, 0.1) 0%, rgba(99, 102, 241, 0.1) 100%);
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
        color: #3b82f6;
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
        border-color: #3b82f6;
        box-shadow: 0 4px 20px rgba(59, 130, 246, 0.12);
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
        background: linear-gradient(135deg, #3b82f6, #6366f1);
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
        background: #3b82f6;
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

    /* Cross-link banner */
    .cross-link-banner {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: var(--space-4);
        background: var(--bg-secondary);
        border: 1px solid var(--border-primary);
        border-radius: var(--radius-lg);
        margin-bottom: var(--space-6);
        text-decoration: none;
        transition: all 0.2s;
    }

    .cross-link-banner:hover {
        border-color: #3b82f6;
        background: var(--bg-tertiary);
    }

    .cross-link-text {
        font-size: var(--text-sm);
        color: var(--text-secondary);
    }

    .cross-link-text strong {
        color: var(--text-primary);
    }

    .cross-link-arrow {
        font-size: var(--text-lg);
        color: var(--text-muted);
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
        <span class="breadcrumb-current"><%= fullLabel %></span>
    </nav>

    <!-- Hero Section -->
    <section class="subject-hero">
        <h1><%= fullLabel %></h1>
        <p>NCERT textbook solutions with step-by-step explanations, formulas, and physical quantity analysis</p>
        <div class="subject-stats">
            <div class="subject-stat">
                <span>&#128218;</span>
                <span><strong><%= chapterCount %></strong> Chapters</span>
            </div>
            <div class="subject-stat">
                <span>&#128221;</span>
                <span><strong id="totalQuestions">-</strong> Questions</span>
            </div>
            <div class="subject-stat">
                <span>&#127919;</span>
                <span><strong>CBSE</strong> Aligned</span>
            </div>
        </div>
    </section>

    <!-- Cross-link to other part (only if multi-part book) -->
    <% if (bookPart.contains("part-2")) { %>
    <a href="<%=request.getContextPath()%>/exams/books/ncert/<%= bookClass %>/<%= bookPart.replace("part-2", "part-1") %>/" class="cross-link-banner">
        <div class="cross-link-text"><strong><%= subject %> Part 1</strong> - View all Part 1 chapters</div>
        <span class="cross-link-arrow">&rarr;</span>
    </a>
    <% } else if (bookPart.contains("part-1")) { %>
    <a href="<%=request.getContextPath()%>/exams/books/ncert/<%= bookClass %>/<%= bookPart.replace("part-1", "part-2") %>/" class="cross-link-banner">
        <div class="cross-link-text"><strong><%= subject %> Part 2</strong> - View all Part 2 chapters</div>
        <span class="cross-link-arrow">&rarr;</span>
    </a>
    <% } %>

    <!-- Ad: Header -->
    <%@ include file="../../components/ad-leaderboard.jsp" %>

    <!-- Chapters Grid -->
    <section class="page-section">
        <h2 class="section-title" style="margin-bottom: var(--space-5);">All Chapters</h2>
        <div class="chapters-grid" id="chaptersGrid">
            <!-- Loading skeletons -->
            <% for (int sk = 0; sk < chapterCount; sk++) { %>
            <div class="loading-skeleton"></div>
            <% } %>
        </div>
    </section>
</div>

<!-- JSON-LD Structured Data -->
<script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "Course",
    "name": "<%= ncertLabel %><%= partLabel.isEmpty() ? "" : " " + partLabel %> Solutions",
    "description": "<%= pageDescription %>",
    "url": "https://8gwifi.org/exams/books/ncert/<%= bookClass %>/<%= bookPart %>/",
    "provider": {
        "@type": "Organization",
        "name": "8gwifi.org"
    },
    "educationalLevel": "<%= bookClassLabel %>",
    "about": {
        "@type": "Thing",
        "name": "<%= subject %>"
    },
    "hasCourseInstance": {
        "@type": "CourseInstance",
        "courseMode": "online"
    }
}
</script>

<script>
(function() {
    var chapters = [
        <% boolean _first = true; for (java.util.Map.Entry<String, String[]> _e : chapterMap.entrySet()) { if (!_first) { %>,<% } _first = false; %>
        { num: <%= _e.getValue()[0] %>, name: "<%= _e.getValue()[1].replace("\"", "\\\"") %>", slug: "<%= _e.getKey() %>" }
        <% } %>
    ];

    var basePath = '<%=request.getContextPath()%>/exams/books/ncert/<%= bookClass %>/<%= bookPart %>/';
    var grid = document.getElementById('chaptersGrid');

    // Load per-chapter JSON files in parallel
    var chapterNums = chapters.map(function(c) { return c.num; });
    Promise.all(chapterNums.map(function(n) {
        return fetch(basePath + 'data/ch' + n + '.json')
            .then(function(r) { return r.json(); })
            .catch(function() { return []; });
    })).then(function(results) {
        var counts = {};
        var totalQ = 0;
        var exerciseSets = {};
        results.forEach(function(data, idx) {
            var chNum = chapterNums[idx];
            counts[chNum] = data.length;
            totalQ += data.length;
            exerciseSets[chNum] = new Set();
            data.forEach(function(q) {
                exerciseSets[chNum].add(q.exercise);
            });
        });
        var totalEl = document.getElementById('totalQuestions');
        if (totalEl) totalEl.textContent = totalQ;
        renderChapters(counts, exerciseSets);
    }).catch(function() {
        renderChapters({}, {});
    });

    function getDifficultyLevel(questions) {
        if (questions <= 10) return 1;
        if (questions <= 25) return 2;
        return 3;
    }

    function renderChapters(counts, exerciseSets) {
        var html = '';
        chapters.forEach(function(ch) {
            var qCount = counts[ch.num] || 0;
            var exCount = exerciseSets[ch.num] ? exerciseSets[ch.num].size : 0;
            var difficulty = getDifficultyLevel(qCount);
            var hasQuestions = qCount > 0;

            html += '<a href="' + basePath + ch.slug + '/" class="chapter-card"' + (!hasQuestions ? ' style="opacity:0.5"' : '') + '>';
            html += '<div class="chapter-header">';
            html += '<div class="chapter-num">' + ch.num + '</div>';
            html += '<div class="chapter-title">' + ch.name + '</div>';
            html += '</div>';
            html += '<div class="chapter-meta">';
            html += '<div class="chapter-meta-item"><strong>' + (qCount || '-') + '</strong> Questions</div>';
            if (exCount > 0) {
                html += '<div class="chapter-meta-item"><strong>' + exCount + '</strong> Exercises</div>';
            }
            html += '</div>';
            if (qCount > 0) {
                html += '<div class="difficulty-bar">';
                html += '<div class="difficulty-segment' + (difficulty >= 1 ? ' filled' : '') + '"></div>';
                html += '<div class="difficulty-segment' + (difficulty >= 2 ? ' filled medium' : '') + '"></div>';
                html += '<div class="difficulty-segment' + (difficulty >= 3 ? ' filled hard' : '') + '"></div>';
                html += '</div>';
            }
            html += '</a>';
        });
        grid.innerHTML = html;
    }
})();
</script>

<%@ include file="../../components/footer.jsp" %>
