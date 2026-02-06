<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.FileReader" %>
<%@ page import="java.io.File" %>
<%
    // Chapter slug to data mapping (same as chapter.jsp)
    Map<String, String[]> chapterMap = new HashMap<>();
    chapterMap.put("real-numbers", new String[]{"1", "Real Numbers"});
    chapterMap.put("polynomials", new String[]{"2", "Polynomials"});
    chapterMap.put("pair-of-linear-equations-in-two-variables", new String[]{"3", "Pair of Linear Equations in Two Variables"});
    chapterMap.put("quadratic-equations", new String[]{"4", "Quadratic Equations"});
    chapterMap.put("arithmetic-progressions", new String[]{"5", "Arithmetic Progressions"});
    chapterMap.put("triangles", new String[]{"6", "Triangles"});
    chapterMap.put("coordinate-geometry", new String[]{"7", "Coordinate Geometry"});
    chapterMap.put("introduction-to-trigonometry", new String[]{"8", "Introduction to Trigonometry"});
    chapterMap.put("some-applications-of-trigonometry", new String[]{"9", "Some Applications of Trigonometry"});
    chapterMap.put("circles", new String[]{"10", "Circles"});
    chapterMap.put("areas-related-to-circles", new String[]{"11", "Areas Related to Circles"});
    chapterMap.put("surface-areas-and-volumes", new String[]{"12", "Surface Areas and Volumes"});
    chapterMap.put("statistics", new String[]{"13", "Statistics"});
    chapterMap.put("probability", new String[]{"14", "Probability"});

    // Get question slug from request attribute (set by stub JSP)
    String questionSlug = (String) request.getAttribute("questionSlug");

    // Extract chapter from URL path
    String requestURI = request.getRequestURI();
    String chapterSlug = "";
    String[] pathParts = requestURI.split("/");
    for (int i = 0; i < pathParts.length; i++) {
        if ("mathematics".equals(pathParts[i]) && i + 1 < pathParts.length) {
            chapterSlug = pathParts[i + 1];
            break;
        }
    }

    String[] chapterData = chapterMap.get(chapterSlug);
    String chapterNum = chapterData != null ? chapterData[0] : "1";
    String chapterName = chapterData != null ? chapterData[1] : "Chapter";

    // Parse question slug to extract exercise and question number
    // Format: ex-10-1-q1 -> Exercise 10.1, Q1
    String exerciseNum = "";
    String questionNum = "";
    if (questionSlug != null && questionSlug.startsWith("ex-")) {
        String[] slugParts = questionSlug.substring(3).split("-q");
        if (slugParts.length >= 2) {
            exerciseNum = slugParts[0].replace("-", ".");
            questionNum = "Q" + slugParts[1];
        }
    }

    // Set attributes for JavaScript
    request.setAttribute("chapterSlug", chapterSlug);
    request.setAttribute("chapterNum", chapterNum);
    request.setAttribute("chapterName", chapterName);
    request.setAttribute("questionSlug", questionSlug);
    request.setAttribute("exerciseNum", exerciseNum);
    request.setAttribute("questionNum", questionNum);

    // Read actual question text from JSON for SEO meta description
    String questionPlainText = "";
    try {
        String jsonPath = application.getRealPath("/exams/books/ncert/class-10/mathematics/data/chapters.json");
        File jsonFile = new File(jsonPath);
        if (jsonFile.exists()) {
            BufferedReader reader = new BufferedReader(new FileReader(jsonFile));
            StringBuilder jsonContent = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                jsonContent.append(line);
            }
            reader.close();

            // Build the search pattern for this specific question
            // Format: "exercise": "Exercise X.Y", ... "question_number": "QZ"
            String searchExercise = "Exercise " + exerciseNum;
            String searchQuestion = questionNum;

            String json = jsonContent.toString();

            // Find the question entry by looking for matching exercise and question_number
            int searchStart = 0;
            while (searchStart < json.length()) {
                int exIdx = json.indexOf("\"exercise\"", searchStart);
                if (exIdx == -1) break;

                // Find the exercise value
                int exValStart = json.indexOf("\"", exIdx + 11) + 1;
                int exValEnd = json.indexOf("\"", exValStart);
                String exValue = json.substring(exValStart, exValEnd);

                // Check if this matches our exercise (handle optional text like "(Optional)")
                if (exValue.startsWith(searchExercise)) {
                    // Look for question_number nearby (within 500 chars)
                    int qnIdx = json.indexOf("\"question_number\"", exIdx);
                    if (qnIdx != -1 && qnIdx < exIdx + 500) {
                        int qnValStart = json.indexOf("\"", qnIdx + 18) + 1;
                        int qnValEnd = json.indexOf("\"", qnValStart);
                        String qnValue = json.substring(qnValStart, qnValEnd);

                        if (qnValue.equalsIgnoreCase(searchQuestion)) {
                            // Found the question! Now extract question_plain
                            int qpIdx = json.indexOf("\"question_plain\"", exIdx);
                            if (qpIdx != -1 && qpIdx < exIdx + 2000) {
                                int qpValStart = json.indexOf("\"", qpIdx + 17) + 1;
                                int qpValEnd = qpValStart;
                                // Handle escaped quotes in the value
                                while (qpValEnd < json.length()) {
                                    qpValEnd = json.indexOf("\"", qpValEnd);
                                    if (qpValEnd > 0 && json.charAt(qpValEnd - 1) != '\\') {
                                        break;
                                    }
                                    qpValEnd++;
                                }
                                questionPlainText = json.substring(qpValStart, qpValEnd);
                                // Unescape common escape sequences
                                questionPlainText = questionPlainText.replace("\\\"", "\"").replace("\\n", " ").replace("\\\\", "\\");
                                break;
                            }
                        }
                    }
                }
                searchStart = exIdx + 1;
            }
        }
    } catch (Exception e) {
        // Silently fail - will use fallback description
    }

    // Build page title and meta description
    String pageTitle;
    String metaDesc;

    if (questionPlainText != null && !questionPlainText.isEmpty()) {
        // Use actual question text for better SEO/CTR
        String truncatedQuestion = questionPlainText.length() > 60 ? questionPlainText.substring(0, 60) + "..." : questionPlainText;
        pageTitle = truncatedQuestion + " | NCERT Class 10 " + chapterName + " " + exerciseNum + " " + questionNum;

        // Meta description: question text + context (max ~155 chars for SERP)
        String questionForMeta = questionPlainText.length() > 120 ? questionPlainText.substring(0, 120) : questionPlainText;
        metaDesc = questionForMeta + " - Step-by-step NCERT Class 10 " + chapterName + " solution with explanation.";
    } else {
        // Fallback if JSON parsing fails
        pageTitle = "NCERT Class 10 Maths Exercise " + exerciseNum + " " + questionNum + " Solution | " + chapterName;
        metaDesc = "Step-by-step solution for NCERT Class 10 Mathematics " + chapterName + " Exercise " + exerciseNum + " " + questionNum + " with hints, detailed explanation and final answer.";
    }

    request.setAttribute("pageTitle", pageTitle);
    request.setAttribute("pageDescription", metaDesc);
    request.setAttribute("canonicalUrl", "https://8gwifi.org/exams/books/ncert/class-10/mathematics/" + chapterSlug + "/" + questionSlug + ".jsp");
%>
<%@ include file="../../../../components/header.jsp" %>

<!-- NCERT Books CSS -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/exams/books/ncert/ncert-books.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<style>
    /* Inter font for math education pages */
    .container, .question-card, .solution-content, .question-page-hero {
        font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    }
    /* Question Page Styles */
    .question-page-hero {
        padding: var(--space-6) var(--space-4);
        background: linear-gradient(135deg, rgba(99, 102, 241, 0.1) 0%, rgba(139, 92, 246, 0.1) 100%);
        border-radius: var(--radius-xl);
        margin-bottom: var(--space-6);
    }

    .question-page-hero h1 {
        font-size: var(--text-xl);
        font-weight: 800;
        color: var(--text-primary);
        margin-bottom: var(--space-2);
        line-height: 1.4;
    }

    .question-meta-bar {
        display: flex;
        gap: var(--space-3);
        flex-wrap: wrap;
        margin-top: var(--space-3);
    }

    .meta-pill {
        padding: var(--space-1) var(--space-3);
        border-radius: var(--radius-full);
        font-size: var(--text-sm);
        font-weight: 500;
    }

    .meta-pill.chapter { background: rgba(99, 102, 241, 0.15); color: #6366f1; }
    .meta-pill.exercise { background: rgba(59, 130, 246, 0.15); color: #3b82f6; }
    .meta-pill.difficulty-easy { background: rgba(34, 197, 94, 0.15); color: #22c55e; }
    .meta-pill.difficulty-medium { background: rgba(245, 158, 11, 0.15); color: #f59e0b; }
    .meta-pill.difficulty-hard { background: rgba(239, 68, 68, 0.15); color: #ef4444; }
    .meta-pill.marks { background: rgba(139, 92, 246, 0.15); color: #8b5cf6; }
    .meta-pill.type { background: var(--bg-secondary); color: var(--text-secondary); }

    /* Dark mode: make pills, hint toggle, and labels more visible */
    [data-theme="dark"] .meta-pill.chapter { background: rgba(99, 102, 241, 0.2); color: #a5b4fc; }
    [data-theme="dark"] .meta-pill.exercise { background: rgba(59, 130, 246, 0.2); color: #93c5fd; }
    [data-theme="dark"] .meta-pill.type { background: rgba(148, 163, 184, 0.15); color: #94a3b8; }
    [data-theme="dark"] .meta-pill.difficulty-easy { background: rgba(34, 197, 94, 0.2); color: #86efac; }
    [data-theme="dark"] .meta-pill.difficulty-medium { background: rgba(245, 158, 11, 0.2); color: #fcd34d; }
    [data-theme="dark"] .meta-pill.difficulty-hard { background: rgba(239, 68, 68, 0.2); color: #fca5a5; }
    [data-theme="dark"] .meta-pill.marks { background: rgba(139, 92, 246, 0.2); color: #c4b5fd; }

    [data-theme="dark"] .hint-toggle {
        color: #fbbf24;
    }

    [data-theme="dark"] .hint-content-text {
        background: rgba(245, 158, 11, 0.12);
        border-left-color: #fbbf24;
        color: #cbd5e1;
    }

    [data-theme="dark"] .answer-label {
        color: #4ade80;
    }

    [data-theme="dark"] .nav-btn {
        background: rgba(99, 102, 241, 0.1);
        border-color: rgba(99, 102, 241, 0.3);
        color: #a5b4fc;
    }

    [data-theme="dark"] .nav-btn:hover {
        background: rgba(99, 102, 241, 0.2);
        border-color: #6366f1;
        color: #c7d2fe;
    }

    /* Question Content Card */
    .question-content-card {
        background: var(--bg-primary);
        border: 1px solid var(--border-primary);
        border-radius: var(--radius-lg);
        margin-bottom: var(--space-6);
        overflow: hidden;
    }

    .question-section {
        padding: var(--space-5);
    }

    .section-label {
        font-size: var(--text-xs);
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        color: var(--text-muted);
        margin-bottom: var(--space-2);
    }

    .question-text-main {
        font-size: var(--text-lg);
        color: var(--text-primary);
        line-height: 1.8;
    }

    /* Hint Section */
    .hint-section {
        padding: var(--space-4) var(--space-5);
        background: rgba(245, 158, 11, 0.08);
        border-top: 1px solid var(--border-secondary);
    }

    .hint-toggle {
        display: flex;
        align-items: center;
        gap: var(--space-2);
        cursor: pointer;
        color: #f59e0b;
        font-weight: 600;
    }

    .hint-toggle:hover { opacity: 0.8; }

    .hint-content-text {
        margin-top: var(--space-3);
        padding: var(--space-3);
        background: rgba(245, 158, 11, 0.1);
        border-left: 3px solid #f59e0b;
        border-radius: var(--radius-sm);
        color: var(--text-secondary);
        font-style: italic;
        display: none;
    }

    .hint-content-text.show { display: block; }

    /* Solution Section */
    .solution-section {
        padding: var(--space-5);
        border-top: 1px solid var(--border-secondary);
        background: var(--bg-secondary);
    }

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
    }

    .solution-step:last-child { margin-bottom: 0; }

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
    }

    .step-text {
        color: var(--text-primary);
        line-height: 1.7;
        font-size: var(--text-base);
        padding-top: 3px;
    }

    /* Answer Box */
    .answer-box {
        background: linear-gradient(135deg, rgba(34, 197, 94, 0.08) 0%, rgba(16, 185, 129, 0.12) 100%);
        border: 1px solid rgba(34, 197, 94, 0.25);
        border-radius: var(--radius-lg);
        padding: var(--space-4);
        position: relative;
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
        font-size: var(--text-lg);
        padding-left: 32px;
        line-height: 1.6;
    }

    /* Navigation */
    .question-nav {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: var(--space-4);
        padding: var(--space-4);
        background: var(--bg-secondary);
        border-radius: var(--radius-lg);
        margin-bottom: var(--space-6);
    }

    .nav-btn {
        display: flex;
        align-items: center;
        gap: var(--space-2);
        padding: var(--space-2) var(--space-4);
        background: var(--bg-primary);
        border: 1px solid var(--border-primary);
        border-radius: var(--radius-md);
        color: var(--text-secondary);
        text-decoration: none;
        font-size: var(--text-sm);
        transition: all 0.2s;
    }

    .nav-btn:hover {
        border-color: var(--accent);
        color: var(--accent);
    }

    .nav-btn.disabled {
        opacity: 0.5;
        pointer-events: none;
    }

    .nav-center {
        text-align: center;
    }

    .nav-center a {
        color: var(--accent);
        text-decoration: none;
        font-weight: 600;
    }

    /* Related Questions */
    .related-questions {
        background: var(--bg-primary);
        border: 1px solid var(--border-primary);
        border-radius: var(--radius-lg);
        padding: var(--space-5);
        margin-bottom: var(--space-6);
    }

    .related-title {
        font-size: var(--text-lg);
        font-weight: 700;
        color: var(--text-primary);
        margin-bottom: var(--space-4);
    }

    .related-list {
        display: flex;
        flex-direction: column;
        gap: var(--space-2);
    }

    .related-item {
        display: flex;
        align-items: center;
        gap: var(--space-3);
        padding: var(--space-3);
        background: var(--bg-secondary);
        border-radius: var(--radius-md);
        text-decoration: none;
        color: var(--text-primary);
        transition: all 0.2s;
    }

    .related-item:hover {
        background: var(--bg-tertiary);
        transform: translateX(4px);
    }

    .related-item-num {
        background: var(--accent);
        color: white;
        font-size: var(--text-xs);
        font-weight: 700;
        padding: 2px 8px;
        border-radius: var(--radius-sm);
    }

    .related-item-text {
        font-size: var(--text-sm);
        color: var(--text-secondary);
        flex: 1;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }

    /* Diagram */
    .diagram-container {
        margin: var(--space-4) 0;
    }

    .diagram-image {
        display: flex;
        justify-content: center;
        padding: var(--space-4);
        background: var(--bg-secondary);
        border-radius: var(--radius-md);
    }

    .svg-diagram {
        max-width: 100%;
        height: auto;
        max-height: 300px;
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

    /* Mobile */
    @media (max-width: 640px) {
        .question-page-hero h1 { font-size: var(--text-lg); }
        .question-nav { flex-direction: column; }
        .nav-btn { width: 100%; justify-content: center; }
    }
</style>

<!-- Breadcrumb -->
<div class="container">
    <nav class="breadcrumb">
        <a href="<%=request.getContextPath()%>/exams/">Exams</a>
        <span class="breadcrumb-separator">/</span>
        <a href="<%=request.getContextPath()%>/exams/books/">Books</a>
        <span class="breadcrumb-separator">/</span>
        <a href="<%=request.getContextPath()%>/exams/books/ncert/">NCERT</a>
        <span class="breadcrumb-separator">/</span>
        <a href="<%=request.getContextPath()%>/exams/books/ncert/class-10/mathematics/">Class 10 Maths</a>
        <span class="breadcrumb-separator">/</span>
        <a href="<%=request.getContextPath()%>/exams/books/ncert/class-10/mathematics/<%= chapterSlug %>/"><%= chapterName %></a>
        <span class="breadcrumb-separator">/</span>
        <span class="breadcrumb-current" id="breadcrumbQuestion">Exercise <%= exerciseNum %> <%= questionNum %></span>
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
        <!-- Ad: Header (Mobile/Tablet) -->
        <div class="mobile-ad-container">
            <%@ include file="../../../../components/ad-leaderboard.jsp" %>
        </div>

        <!-- Question Container -->
        <div id="questionContainer">
            <div class="loading-container">
                <div class="loading-spinner"></div>
                <p>Loading question...</p>
            </div>
        </div>

        <!-- Ad: After Question (Mobile/Tablet) -->
        <div class="mobile-ad-container" style="margin-top: var(--space-6);">
            <%@ include file="../../../../components/ad-leaderboard.jsp" %>
        </div>
    </main>

    <!-- Right Sidebar Ads (Desktop >=992px) -->
    <aside class="ad-sidebar ad-sidebar-right">
        <div class="ad-sidebar-inner">
            <%@ include file="../../../../components/ad-sidebar.jsp" %>
        </div>
    </aside>
</div>

<script>
(function() {
    var CHAPTER_NUM = '<%= chapterNum %>';
    var CHAPTER_NAME = '<%= chapterName.replace("'", "\\'") %>';
    var CHAPTER_SLUG = '<%= chapterSlug %>';
    var QUESTION_SLUG = '<%= questionSlug %>';
    var EXERCISE_NUM = '<%= exerciseNum %>';
    var QUESTION_NUM = '<%= questionNum %>';
    var container = document.getElementById('questionContainer');

    // Load chapter data
    fetch('<%=request.getContextPath()%>/exams/books/ncert/class-10/mathematics/data/chapters.json')
        .then(function(response) { return response.json(); })
        .then(function(data) {
            // Filter questions for this chapter
            var chapterQuestions = data.filter(function(q) {
                var chNum = q.chapter.match(/Chapter (\d+)/);
                return chNum && chNum[1] === CHAPTER_NUM;
            });

            // Find current question by exercise and question number
            var currentIndex = -1;
            var currentQuestion = null;

            // Helper function to build slug from question
            function buildSlug(q) {
                // Remove "Exercise " prefix and any parenthetical notes like "(Optional)"
                var exNum = q.exercise.replace('Exercise ', '').replace(/\s*\([^)]*\)/g, '').replace('.', '-');
                return 'ex-' + exNum + '-' + q.question_number.toLowerCase();
            }

            // Helper: Format text with proper line breaks
            function formatTextWithLineBreaks(text) {
                if (!text) return '';

                // Convert literal \n (backslash + n) to <br> - handles double-escaped JSON
                var formatted = text.replace(/\\n/g, '<br>');

                // Convert actual newline characters to <br>
                formatted = formatted.replace(/\n/g, '<br>');

                // Add line breaks before question part numbers (i), (ii), (iii), (iv), (v), etc.
                // Use whitespace before to distinguish from LaTeX \( which has no space
                // Match: "content (ii)" -> "content<br>(ii)"
                formatted = formatted.replace(/\s+(\(i\))/gi, '<br><br>$1');  // First item gets double break
                formatted = formatted.replace(/\s+(\((?:ii|iii|iv|v|vi|vii|viii|ix|x|xi|xii)\))/gi, '<br>$1');

                // Handle (a), (b), (c), (d) style
                formatted = formatted.replace(/\s+(\(a\))/gi, '<br><br>$1');
                formatted = formatted.replace(/\s+(\([b-z]\))/gi, '<br>$1');

                // Handle numbered items: (1), (2), (3) etc.
                formatted = formatted.replace(/\s+(\(1\))/g, '<br><br>$1');
                formatted = formatted.replace(/\s+(\([2-9]\))/g, '<br>$1');
                formatted = formatted.replace(/\s+(\(\d{2,}\))/g, '<br>$1');

                return formatted;
            }

            for (var i = 0; i < chapterQuestions.length; i++) {
                var q = chapterQuestions[i];
                var slug = buildSlug(q);

                if (slug === QUESTION_SLUG) {
                    currentIndex = i;
                    currentQuestion = q;
                    break;
                }
            }

            if (!currentQuestion) {
                container.innerHTML = '<div class="card" style="text-align:center;padding:var(--space-8);">Question not found.</div>';
                return;
            }

            // Get prev/next questions
            var prevQuestion = currentIndex > 0 ? chapterQuestions[currentIndex - 1] : null;
            var nextQuestion = currentIndex < chapterQuestions.length - 1 ? chapterQuestions[currentIndex + 1] : null;

            // Determine difficulty
            var diffClass = currentQuestion.difficulty < 0.4 ? 'easy' : (currentQuestion.difficulty < 0.7 ? 'medium' : 'hard');
            var diffLabel = currentQuestion.difficulty < 0.4 ? 'Easy' : (currentQuestion.difficulty < 0.7 ? 'Medium' : 'Hard');

            // Update page title with actual question
            var questionText = currentQuestion.question_plain.substring(0, 60);
            document.title = questionText + '... | NCERT Class 10 ' + currentQuestion.exercise + ' ' + currentQuestion.question_number;

            // Update meta description with actual question text (important for SEO)
            var metaDesc = currentQuestion.question_plain.substring(0, 120) +
                           ' - Step-by-step NCERT Class 10 ' + CHAPTER_NAME + ' solution with explanation.';
            var metaTag = document.querySelector('meta[name="description"]');
            if (metaTag) {
                metaTag.setAttribute('content', metaDesc);
            }

            // Build HTML
            var html = '';

            // Hero Section
            html += '<section class="question-page-hero">';
            html += '<h1>' + currentQuestion.question_plain + '</h1>';
            html += '<div class="question-meta-bar">';
            html += '<span class="meta-pill chapter">Chapter ' + CHAPTER_NUM + '</span>';
            html += '<span class="meta-pill exercise">' + currentQuestion.exercise + '</span>';
            html += '<span class="meta-pill type">' + currentQuestion.type + '</span>';
            html += '<span class="meta-pill difficulty-' + diffClass + '">' + diffLabel + '</span>';
            html += '<span class="meta-pill marks">' + currentQuestion.marks + ' Marks</span>';
            html += '</div>';
            html += '</section>';

            // Navigation
            html += '<nav class="question-nav">';
            if (prevQuestion) {
                html += '<a href="' + buildSlug(prevQuestion) + '.jsp" class="nav-btn">';
                html += '<span>&larr;</span> ' + prevQuestion.question_number;
                html += '</a>';
            } else {
                html += '<span class="nav-btn disabled"><span>&larr;</span> Previous</span>';
            }
            html += '<div class="nav-center">';
            html += '<a href="./">All ' + CHAPTER_NAME + ' Questions</a>';
            html += '</div>';
            if (nextQuestion) {
                html += '<a href="' + buildSlug(nextQuestion) + '.jsp" class="nav-btn">';
                html += nextQuestion.question_number + ' <span>&rarr;</span>';
                html += '</a>';
            } else {
                html += '<span class="nav-btn disabled">Next <span>&rarr;</span></span>';
            }
            html += '</nav>';

            // Question Content Card
            html += '<div class="question-content-card">';

            // Question Section
            html += '<div class="question-section">';
            html += '<div class="section-label">Question ' + currentQuestion.question_number + '</div>';
            html += '<div class="question-text-main">' + formatTextWithLineBreaks(currentQuestion.question_latex || currentQuestion.question_plain) + '</div>';
            html += '</div>';

            // Diagram if exists
            if (currentQuestion.visual_content && currentQuestion.visual_content.has_diagram && currentQuestion.visual_content.diagram_svg) {
                html += '<div class="diagram-container" style="padding: 0 var(--space-5);">';
                html += '<div class="diagram-image">';
                html += '<img src="<%=request.getContextPath()%>/exams/books/ncert/class-10/mathematics/diagrams/' + currentQuestion.visual_content.diagram_svg + '" ';
                html += 'alt="' + (currentQuestion.visual_content.diagram_description || 'Diagram') + '" ';
                html += 'loading="lazy" class="svg-diagram">';
                html += '</div>';
                html += '</div>';
            }

            // Hint Section
            if (currentQuestion.hint) {
                html += '<div class="hint-section">';
                html += '<div class="hint-toggle" onclick="toggleHint()">';
                html += '<span>&#128161;</span> <span id="hintToggleText">Show Hint</span>';
                html += '</div>';
                html += '<div class="hint-content-text" id="hintContent">' + formatTextWithLineBreaks(currentQuestion.hint) + '</div>';
                html += '</div>';
            }

            // Solution Section
            html += '<div class="solution-section">';

            if (currentQuestion.solution_steps && currentQuestion.solution_steps.length > 0) {
                html += '<div class="solution-steps-container">';
                html += '<div class="solution-steps-header">';
                html += '<div class="solution-steps-icon">&#9998;</div>';
                html += '<span class="solution-steps-title">Step-by-Step Solution</span>';
                html += '<span class="solution-steps-count">' + currentQuestion.solution_steps.length + ' steps</span>';
                html += '</div>';
                html += '<ul class="solution-steps">';
                currentQuestion.solution_steps.forEach(function(step, idx) {
                    html += '<li class="solution-step">';
                    html += '<span class="step-num">' + (idx + 1) + '</span>';
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
            html += '<div class="answer-text">' + formatTextWithLineBreaks(currentQuestion.correct_answer_latex || currentQuestion.correct_answer_plain) + '</div>';
            html += '</div>';

            html += '</div>'; // solution-section
            html += '</div>'; // question-content-card

            // Related Questions (same exercise)
            var relatedQuestions = chapterQuestions.filter(function(q, idx) {
                return q.exercise === currentQuestion.exercise && idx !== currentIndex;
            }).slice(0, 5);

            if (relatedQuestions.length > 0) {
                html += '<div class="related-questions">';
                html += '<div class="related-title">More Questions from ' + currentQuestion.exercise + '</div>';
                html += '<div class="related-list">';
                relatedQuestions.forEach(function(q) {
                    var slug = buildSlug(q);
                    html += '<a href="' + slug + '.jsp" class="related-item">';
                    html += '<span class="related-item-num">' + q.question_number + '</span>';
                    html += '<span class="related-item-text">' + q.question_plain.substring(0, 80) + (q.question_plain.length > 80 ? '...' : '') + '</span>';
                    html += '</a>';
                });
                html += '</div>';
                html += '</div>';
            }

            container.innerHTML = html;

            // Render MathJax
            if (window.MathJax && window.MathJax.typesetPromise) {
                MathJax.typesetPromise([container]).catch(function(err) {
                    console.log('MathJax error:', err);
                });
            }

            // Inject QAPage Schema for SEO
            injectQASchema(currentQuestion);
        })
        .catch(function(error) {
            console.error('Error loading question:', error);
            container.innerHTML = '<div class="card" style="text-align:center;padding:var(--space-8);color:var(--error);">Error loading question. Please try again.</div>';
        });
})();

function toggleHint() {
    var content = document.getElementById('hintContent');
    var toggleText = document.getElementById('hintToggleText');
    content.classList.toggle('show');
    toggleText.textContent = content.classList.contains('show') ? 'Hide Hint' : 'Show Hint';
}

function injectQASchema(q) {
    // Build clean text versions for schema
    var questionText = (q.question_plain || '')
        .replace(/\\[\(\)\[\]]/g, '')
        .replace(/\\\w+/g, '');

    var answerParts = [];
    if (q.solution_steps && q.solution_steps.length > 0) {
        answerParts = q.solution_steps.map(function(step, i) {
            return 'Step ' + (i + 1) + ': ' + step
                .replace(/\\[\(\)\[\]]/g, '')
                .replace(/\\\w+/g, '');
        });
    }
    var finalAnswer = (q.correct_answer_plain || '')
        .replace(/\\[\(\)\[\]]/g, '')
        .replace(/\\\w+/g, '');
    answerParts.push('Final Answer: ' + finalAnswer);

    var schema = {
        "@context": "https://schema.org",
        "@type": "QAPage",
        "mainEntity": {
            "@type": "Question",
            "name": "NCERT Class 10 Maths " + q.exercise + " " + q.question_number + ": " + questionText.substring(0, 200),
            "text": questionText,
            "answerCount": 1,
            "dateCreated": "2024-01-01",
            "author": {
                "@type": "Organization",
                "name": "NCERT"
            },
            "acceptedAnswer": {
                "@type": "Answer",
                "text": answerParts.join(' '),
                "dateCreated": "2024-01-01",
                "author": {
                    "@type": "Organization",
                    "name": "8gwifi.org"
                },
                "upvoteCount": 10
            }
        }
    };

    // Also add BreadcrumbList schema
    var breadcrumbSchema = {
        "@context": "https://schema.org",
        "@type": "BreadcrumbList",
        "itemListElement": [
            {"@type": "ListItem", "position": 1, "name": "Home", "item": "https://8gwifi.org/"},
            {"@type": "ListItem", "position": 2, "name": "Exams", "item": "https://8gwifi.org/exams/"},
            {"@type": "ListItem", "position": 3, "name": "NCERT", "item": "https://8gwifi.org/exams/books/ncert/"},
            {"@type": "ListItem", "position": 4, "name": "Class 10 Maths", "item": "https://8gwifi.org/exams/books/ncert/class-10/mathematics/"},
            {"@type": "ListItem", "position": 5, "name": "<%= chapterName %>", "item": "https://8gwifi.org/exams/books/ncert/class-10/mathematics/<%= chapterSlug %>/"},
            {"@type": "ListItem", "position": 6, "name": q.exercise + " " + q.question_number}
        ]
    };

    // Inject schemas
    var script1 = document.createElement('script');
    script1.type = 'application/ld+json';
    script1.textContent = JSON.stringify(schema);
    document.head.appendChild(script1);

    var script2 = document.createElement('script');
    script2.type = 'application/ld+json';
    script2.textContent = JSON.stringify(breadcrumbSchema);
    document.head.appendChild(script2);
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
        var leftHidden = !leftSidebar || leftSidebar.offsetHeight === 0 || leftSidebar.offsetWidth === 0 ||
            getComputedStyle(leftSidebar).display === 'none' || getComputedStyle(leftSidebar).visibility === 'hidden';
        var rightHidden = !rightSidebar || rightSidebar.offsetHeight === 0 || rightSidebar.offsetWidth === 0 ||
            getComputedStyle(rightSidebar).display === 'none' || getComputedStyle(rightSidebar).visibility === 'hidden';
        if ((leftHidden || rightHidden) && window.innerWidth >= 1200) {
            layout.style.gridTemplateColumns = '1fr';
            layout.style.maxWidth = '1000px';
            var mainContent = layout.querySelector('.main-content-area');
            if (mainContent) mainContent.style.maxWidth = '100%';
        }
    }
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() { setTimeout(checkAdBlockerLayout, 100); });
    } else { setTimeout(checkAdBlockerLayout, 100); }
    window.addEventListener('resize', checkAdBlockerLayout);
})();
</script>

<%@ include file="../../../../components/footer.jsp" %>
