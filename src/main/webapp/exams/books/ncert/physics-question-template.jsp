<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="physics-config.jsp" %>
<%
    // Helper label: "NCERT Class 12 Physics" (dynamic per class level)
    String ncertLabel = "NCERT " + bookClassLabel + " " + subject;

    // Get question slug from request attribute (set by stub JSP)
    String questionSlug = (String) request.getAttribute("questionSlug");

    // Parse physics question slug to extract question number
    // Regular: q-1-1 -> Question 1.1
    // Additional: add-q-1-1 -> Additional Question 1.1
    // Part 2: q-Q9-1 -> Question Q9.1
    String exerciseNum = "";
    String questionNum = "";
    boolean isMisc = false;
    if (questionSlug != null && questionSlug.startsWith("add-q-")) {
        isMisc = true;
        String remaining = questionSlug.substring(6); // after "add-q-"
        questionNum = remaining.replace("-", ".");
        exerciseNum = "additional";
    } else if (questionSlug != null && questionSlug.startsWith("q-")) {
        String remaining = questionSlug.substring(2); // after "q-"
        questionNum = remaining.replace("-", ".");
        exerciseNum = questionNum; // For physics, exercise num matches question num pattern
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
        String jsonPath = application.getRealPath("/exams/books/ncert/" + bookClass + "/" + bookPart + "/data/ch" + chapterNum + ".json");
        File jsonFile = new File(jsonPath);
        if (jsonFile.exists()) {
            BufferedReader reader = new BufferedReader(new FileReader(jsonFile));
            StringBuilder jsonContent = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                jsonContent.append(line);
            }
            reader.close();

            String json = jsonContent.toString();

            // For physics, search by question_number directly (e.g., "1.1")
            int searchStart = 0;
            while (searchStart < json.length()) {
                int qnIdx = json.indexOf("\"question_number\"", searchStart);
                if (qnIdx == -1) break;

                int qnValStart = json.indexOf("\"", qnIdx + 18) + 1;
                int qnValEnd = json.indexOf("\"", qnValStart);
                String qnValue = json.substring(qnValStart, qnValEnd);

                if (qnValue.equals(questionNum)) {
                    // Verify chapter match
                    int chIdx = json.lastIndexOf("\"chapter\"", qnIdx);
                    boolean chapterMatches = true;
                    if (chIdx != -1 && qnIdx - chIdx < 500) {
                        int chValStart = json.indexOf("\"", chIdx + 10) + 1;
                        int chValEnd = json.indexOf("\"", chValStart);
                        String chValue = json.substring(chValStart, chValEnd);
                        chapterMatches = chValue.contains("Chapter " + chapterNum);
                    }

                    if (chapterMatches) {
                        int qpIdx = json.indexOf("\"question_plain\"", qnIdx);
                        if (qpIdx != -1 && qpIdx < qnIdx + 2000) {
                            int qpValStart = json.indexOf("\"", qpIdx + 17) + 1;
                            int qpValEnd = qpValStart;
                            while (qpValEnd < json.length()) {
                                qpValEnd = json.indexOf("\"", qpValEnd);
                                if (qpValEnd > 0 && json.charAt(qpValEnd - 1) != '\\') {
                                    break;
                                }
                                qpValEnd++;
                            }
                            questionPlainText = json.substring(qpValStart, qpValEnd);
                            questionPlainText = questionPlainText.replace("\\\"", "\"").replace("\\n", " ").replace("\\\\", "\\");
                            break;
                        }
                    }
                }
                searchStart = qnIdx + 1;
            }
        }
    } catch (Exception e) {
        // Silently fail - will use fallback description
    }

    // Build page title and meta description
    String pageTitle;
    String metaDesc;
    String exerciseLabel = isMisc ? "Additional Exercise" : ("Question " + questionNum);

    if (questionPlainText != null && !questionPlainText.isEmpty()) {
        String truncatedQuestion = questionPlainText.length() > 60 ? questionPlainText.substring(0, 60) + "..." : questionPlainText;
        pageTitle = truncatedQuestion + " | " + ncertLabel + " " + chapterName + " " + exerciseLabel + " " + questionNum;

        String questionForMeta = questionPlainText.length() > 120 ? questionPlainText.substring(0, 120) : questionPlainText;
        metaDesc = questionForMeta + " - Step-by-step " + ncertLabel + " " + chapterName + " solution with explanation.";
    } else {
        pageTitle = ncertLabel + " " + exerciseLabel + " " + questionNum + " Solution | " + chapterName;
        metaDesc = "Step-by-step solution for " + ncertLabel + " " + chapterName + " " + exerciseLabel + " " + questionNum + " with hints, detailed explanation and final answer.";
    }

    request.setAttribute("pageTitle", pageTitle);
    request.setAttribute("pageDescription", metaDesc);
    request.setAttribute("canonicalUrl", "https://8gwifi.org/exams/books/ncert/" + bookClass + "/" + bookPart + "/" + chapterSlug + "/" + questionSlug + ".jsp");
%>
<%@ include file="../../components/header.jsp" %>

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
    .meta-pill.has-plot { background: rgba(99, 102, 241, 0.15); color: #6366f1; }

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

    /* p5.js sketch container */
    .p5-sketch-container {
        margin-top: var(--space-4);
        background: var(--bg-secondary);
        border: 1px solid var(--border-primary);
        border-radius: var(--radius-lg);
        overflow: hidden;
    }

    .p5-sketch-header {
        display: flex;
        align-items: center;
        gap: var(--space-2);
        padding: var(--space-2) var(--space-3);
        background: var(--bg-tertiary);
        border-bottom: 1px solid var(--border-secondary);
        font-size: var(--text-sm);
        font-weight: 600;
        color: var(--text-secondary);
    }

    .p5-sketch-target {
        width: 100%;
        display: flex;
        justify-content: center;
    }

    .p5-sketch-target canvas {
        max-width: 100%;
        height: auto !important;
    }

    /* Calculator widget */
    .calc-container {
        margin-top: var(--space-4);
        background: linear-gradient(135deg, rgba(99, 102, 241, 0.04) 0%, rgba(139, 92, 246, 0.06) 100%);
        border: 1px solid rgba(99, 102, 241, 0.2);
        border-radius: var(--radius-lg);
        padding: var(--space-4);
    }

    .calc-header { display: flex; align-items: center; gap: var(--space-2); margin-bottom: var(--space-3); padding-bottom: var(--space-3); border-bottom: 2px solid rgba(99, 102, 241, 0.15); }
    .calc-icon { font-size: 20px; }
    .calc-title { font-size: var(--text-base); font-weight: 700; color: var(--text-primary); }
    .calc-formula { text-align: center; font-size: var(--text-lg); font-weight: 600; color: var(--accent); padding: var(--space-3); background: var(--bg-primary); border-radius: var(--radius-md); margin-bottom: var(--space-4); font-family: 'Georgia', serif; }
    .calc-sliders { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: var(--space-3); margin-bottom: var(--space-4); }
    .calc-slider-group { background: var(--bg-primary); padding: var(--space-3); border-radius: var(--radius-md); border: 1px solid var(--border-secondary); }
    .calc-slider-label { display: flex; justify-content: space-between; align-items: center; margin-bottom: var(--space-2); font-size: var(--text-sm); color: var(--text-secondary); }
    .calc-slider-value { font-weight: 600; color: var(--accent); font-size: var(--text-xs); font-family: 'SF Mono', 'Fira Code', monospace; }
    .calc-range { width: 100%; height: 6px; -webkit-appearance: none; appearance: none; background: var(--border-secondary); border-radius: 3px; outline: none; }
    .calc-range::-webkit-slider-thumb { -webkit-appearance: none; width: 18px; height: 18px; background: linear-gradient(135deg, #6366f1, #8b5cf6); border-radius: 50%; cursor: pointer; border: 2px solid white; box-shadow: 0 2px 6px rgba(99, 102, 241, 0.4); }
    .calc-range::-moz-range-thumb { width: 18px; height: 18px; background: linear-gradient(135deg, #6366f1, #8b5cf6); border-radius: 50%; cursor: pointer; border: 2px solid white; }
    .calc-result-box { background: linear-gradient(135deg, rgba(34, 197, 94, 0.08) 0%, rgba(16, 185, 129, 0.12) 100%); border: 1px solid rgba(34, 197, 94, 0.25); border-radius: var(--radius-lg); padding: var(--space-4); margin-bottom: var(--space-3); position: relative; }
    .calc-result-box::before { content: ''; position: absolute; left: 0; top: 0; bottom: 0; width: 4px; background: linear-gradient(180deg, #22c55e, #10b981); border-radius: 4px 0 0 4px; }
    .calc-result-header { display: flex; align-items: center; gap: var(--space-2); margin-bottom: var(--space-1); }
    .calc-result-icon { width: 22px; height: 22px; background: linear-gradient(135deg, #22c55e, #10b981); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-size: 11px; }
    .calc-result-label { font-size: var(--text-xs); font-weight: 700; color: #16a34a; text-transform: uppercase; letter-spacing: 0.05em; }
    .calc-result-value { font-size: var(--text-xl); font-weight: 700; color: var(--text-primary); padding-left: 30px; font-family: 'SF Mono', 'Fira Code', monospace; }
    .calc-result-direction { font-size: var(--text-sm); color: var(--text-secondary); padding-left: 30px; margin-top: var(--space-1); }
    .calc-plot-wrapper { margin-bottom: var(--space-3); }
    .calc-plot-title { font-size: var(--text-xs); font-weight: 600; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: var(--space-2); }
    .calc-plot-target { width: 100%; min-height: 220px; background: var(--bg-primary); border-radius: var(--radius-md); }
    .calc-reset-row { text-align: center; }
    .calc-reset-btn { padding: var(--space-2) var(--space-4); border: 1px solid var(--border-primary); border-radius: var(--radius-md); background: var(--bg-primary); color: var(--text-muted); font-size: var(--text-xs); cursor: pointer; transition: all 0.2s; }
    .calc-reset-btn:hover { border-color: var(--accent); color: var(--accent); }
    [data-theme="dark"] .calc-result-label { color: #4ade80; }
    [data-theme="dark"] .calc-formula { color: #a5b4fc; }
    [data-theme="dark"] .calc-slider-value { color: #a5b4fc; }

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

    /* Dark mode */
    [data-theme="dark"] .meta-pill.chapter { background: rgba(99, 102, 241, 0.2); color: #a5b4fc; }
    [data-theme="dark"] .meta-pill.exercise { background: rgba(59, 130, 246, 0.2); color: #93c5fd; }
    [data-theme="dark"] .meta-pill.type { background: rgba(148, 163, 184, 0.15); color: #94a3b8; }
    [data-theme="dark"] .meta-pill.difficulty-easy { background: rgba(34, 197, 94, 0.2); color: #86efac; }
    [data-theme="dark"] .meta-pill.difficulty-medium { background: rgba(245, 158, 11, 0.2); color: #fcd34d; }
    [data-theme="dark"] .meta-pill.difficulty-hard { background: rgba(239, 68, 68, 0.2); color: #fca5a5; }
    [data-theme="dark"] .meta-pill.marks { background: rgba(139, 92, 246, 0.2); color: #c4b5fd; }
    [data-theme="dark"] .meta-pill.has-plot { background: rgba(99, 102, 241, 0.2); color: #a5b4fc; }

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

    /* Mobile */
    @media (max-width: 640px) {
        .question-page-hero h1 { font-size: var(--text-lg); }
        .question-nav { flex-direction: column; }
        .nav-btn { width: 100%; justify-content: center; }
        .plot-target { min-height: 250px; }
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
        <a href="<%=request.getContextPath()%>/exams/books/ncert/<%= bookClass %>/<%= bookPart %>/"><%= fullLabel %></a>
        <span class="breadcrumb-separator">/</span>
        <a href="<%=request.getContextPath()%>/exams/books/ncert/<%= bookClass %>/<%= bookPart %>/<%= chapterSlug %>/"><%= chapterName %></a>
        <span class="breadcrumb-separator">/</span>
        <span class="breadcrumb-current" id="breadcrumbQuestion"><%= isMisc ? "Additional" : "Question" %> <%= questionNum %></span>
    </nav>
</div>

<!-- Three Column Layout -->
<div class="three-col-layout">
    <!-- Left Sidebar Ads (Large Desktop >=1400px) -->
    <aside class="ad-sidebar ad-sidebar-left">
        <div class="ad-sidebar-inner">
            <%@ include file="../../components/ad-sidebar-left.jsp" %>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content-area">
        <!-- Ad: Header (Mobile/Tablet) -->
        <div class="mobile-ad-container">
            <%@ include file="../../components/ad-leaderboard.jsp" %>
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
            <%@ include file="../../components/ad-leaderboard.jsp" %>
        </div>
    </main>

    <!-- Right Sidebar Ads (Desktop >=992px) -->
    <aside class="ad-sidebar ad-sidebar-right">
        <div class="ad-sidebar-inner">
            <%@ include file="../../components/ad-sidebar.jsp" %>
        </div>
    </aside>
</div>

<script>
(function() {
    var BOOK_CLASS = '<%= bookClass %>';
    var BOOK_PART = '<%= bookPart %>';
    var NCERT_LABEL = '<%= ncertLabel.replace("'", "\\'") %>';
    var FULL_LABEL = '<%= fullLabel.replace("'", "\\'") %>';
    var CHAPTER_NUM = '<%= chapterNum %>';
    var CHAPTER_NAME = '<%= chapterName.replace("'", "\\'") %>';
    var CHAPTER_SLUG = '<%= chapterSlug %>';
    var QUESTION_SLUG = '<%= questionSlug %>';
    var EXERCISE_NUM = '<%= exerciseNum %>';
    var QUESTION_NUM = '<%= questionNum %>';
    var container = document.getElementById('questionContainer');

    // Load chapter data
    fetch('<%=request.getContextPath()%>/exams/books/ncert/' + BOOK_CLASS + '/' + BOOK_PART + '/data/ch' + CHAPTER_NUM + '.json')
        .then(function(response) { return response.json(); })
        .then(function(chapterQuestions) {

            // Find current question by slug matching
            var currentIndex = -1;
            var currentQuestion = null;

            function buildSlug(q) {
                var qn = q.question_number.replace(/\./g, '-');
                if (q.exercise.toLowerCase().indexOf('additional') > -1 ||
                    q.exercise.toLowerCase().indexOf('hots') > -1) {
                    return 'add-q-' + qn;
                }
                return 'q-' + qn;
            }

            // Helper: Format text with proper line breaks
            function formatTextWithLineBreaks(text) {
                if (!text) return '';

                var formatted = text.replace(/\\n/g, '<br>');
                formatted = formatted.replace(/\n/g, '<br>');

                formatted = formatted.replace(/\s+(\(i\))/gi, '<br><br>$1');
                formatted = formatted.replace(/\s+(\((?:ii|iii|iv|v|vi|vii|viii|ix|x|xi|xii)\))/gi, '<br>$1');

                formatted = formatted.replace(/\s+(\(a\))/gi, '<br><br>$1');
                formatted = formatted.replace(/\s+(\([b-z]\))/gi, '<br>$1');

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
            document.title = questionText + '... | ' + NCERT_LABEL + ' ' + currentQuestion.exercise + ' ' + currentQuestion.question_number;

            // Update meta description
            var metaDesc = currentQuestion.question_plain.substring(0, 120) +
                           ' - Step-by-step ' + NCERT_LABEL + ' ' + CHAPTER_NAME + ' solution with explanation.';
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
            if (currentQuestion.interactive_plot) html += '<span class="meta-pill has-plot">&#128200; Interactive Graph</span>';
            if (currentQuestion.p5_sketch) html += '<span class="meta-pill" style="background:rgba(139,92,246,0.15);color:#8b5cf6;">&#9889; Interactive Diagram</span>';
            if (currentQuestion.calculator) html += '<span class="meta-pill" style="background:rgba(16,185,129,0.15);color:#10b981;">&#129518; Calculator</span>';
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

            // Physical quantities panel (physics-specific)
            if (currentQuestion.physical_quantities) {
                var pq = currentQuestion.physical_quantities;
                html += '<div style="margin:var(--space-4) var(--space-5);padding:var(--space-4);background:rgba(59,130,246,0.06);border:1px solid rgba(59,130,246,0.15);border-radius:var(--radius-lg);">';
                html += '<div style="font-weight:700;font-size:var(--text-sm);color:#3b82f6;margin-bottom:var(--space-3);text-transform:uppercase;letter-spacing:0.05em;">Physical Quantities</div>';
                if (pq.given && pq.given.length > 0) {
                    html += '<div style="margin-bottom:var(--space-3);"><span style="font-weight:600;color:var(--text-primary);font-size:var(--text-sm);">Given:</span>';
                    pq.given.forEach(function(g) { html += '<div style="color:var(--text-secondary);font-size:var(--text-sm);margin-left:var(--space-4);padding:2px 0;line-height:1.6;">' + g + '</div>'; });
                    html += '</div>';
                }
                if (pq.to_find && pq.to_find.length > 0) {
                    html += '<div style="margin-bottom:var(--space-3);"><span style="font-weight:600;color:var(--text-primary);font-size:var(--text-sm);">To Find:</span>';
                    pq.to_find.forEach(function(t) { html += '<div style="color:var(--text-secondary);font-size:var(--text-sm);margin-left:var(--space-4);padding:2px 0;line-height:1.6;">' + t + '</div>'; });
                    html += '</div>';
                }
                if (pq.formulas_used && pq.formulas_used.length > 0) {
                    html += '<div><span style="font-weight:600;color:var(--text-primary);font-size:var(--text-sm);">Formulas Used:</span>';
                    pq.formulas_used.forEach(function(f) { html += '<div style="color:var(--text-secondary);font-size:var(--text-sm);margin-left:var(--space-4);padding:2px 0;line-height:1.6;">' + f + '</div>'; });
                    html += '</div>';
                }
                html += '</div>';
            }

            // Sub-parts notice (physics-specific)
            if (currentQuestion.sub_parts && currentQuestion.sub_parts.length > 0) {
                html += '<div style="margin:var(--space-3) var(--space-5);padding:var(--space-2) var(--space-3);background:var(--bg-secondary);border-radius:var(--radius-sm);font-size:var(--text-sm);color:var(--text-secondary);">';
                html += '<span style="font-weight:600;color:var(--text-primary);">Sub-parts:</span> ' + currentQuestion.sub_parts.join(', ');
                html += '</div>';
            }

            // Diagram if exists
            if (currentQuestion.visual_content && currentQuestion.visual_content.has_diagram && currentQuestion.visual_content.diagram_svg) {
                html += '<div class="diagram-container" style="padding: 0 var(--space-5);">';
                html += '<div class="diagram-image">';
                html += '<img src="<%=request.getContextPath()%>/exams/books/ncert/' + BOOK_CLASS + '/' + BOOK_PART + '/diagrams/' + currentQuestion.visual_content.diagram_svg + '" ';
                html += 'alt="' + (currentQuestion.visual_content.diagram_description || 'Diagram') + '" ';
                html += 'loading="lazy" class="svg-diagram">';
                html += '</div>';
                html += '</div>';
            }

            // p5.js Physics Sketch
            if (currentQuestion.p5_sketch) {
                var sketchSlugs = Array.isArray(currentQuestion.p5_sketch) ? currentQuestion.p5_sketch : [currentQuestion.p5_sketch];
                sketchSlugs.forEach(function(slug, sIdx) {
                    var sketchId = 'questionP5Sketch_' + sIdx;
                    html += '<div class="p5-sketch-container" style="margin: var(--space-4) var(--space-5);">';
                    html += '<div class="p5-sketch-header">&#9889; Interactive Diagram</div>';
                    html += '<div class="p5-sketch-target" id="' + sketchId + '" data-sketch-slug="' + slug + '"></div>';
                    html += '</div>';
                });
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

            // Use solution_steps_latex if available, otherwise fall back to solution_steps
            var displaySteps = currentQuestion.solution_steps_latex || currentQuestion.solution_steps;
            if (displaySteps && displaySteps.length > 0) {
                html += '<div class="solution-steps-container">';
                html += '<div class="solution-steps-header">';
                html += '<div class="solution-steps-icon">&#9998;</div>';
                html += '<span class="solution-steps-title">Step-by-Step Solution</span>';
                html += '<span class="solution-steps-count">' + displaySteps.filter(function(s){ return s && s.trim(); }).length + ' steps</span>';
                html += '</div>';
                html += '<ul class="solution-steps">';
                var stepNum = 0;
                displaySteps.forEach(function(step) {
                    if (!step || !step.trim()) return;
                    stepNum++;
                    html += '<li class="solution-step">';
                    html += '<span class="step-num">' + stepNum + '</span>';
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

            // Interactive Plot (supports string or array of slugs)
            if (currentQuestion.interactive_plot) {
                var plotSlugs = Array.isArray(currentQuestion.interactive_plot) ? currentQuestion.interactive_plot : [currentQuestion.interactive_plot];
                plotSlugs.forEach(function(slug, pIdx) {
                    var plotId = 'questionPlot_' + pIdx;
                    html += '<div class="plot-container">';
                    html += '<div class="plot-header">&#128200; Interactive Graph</div>';
                    html += '<div class="plot-target" id="' + plotId + '" data-plot-slug="' + slug + '"></div>';
                    html += '<div class="plot-legend" id="' + plotId + '_legend"></div>';
                    html += '</div>';
                });
            }

            // Calculator widgets
            if (currentQuestion.calculator) {
                var calcSlugs = Array.isArray(currentQuestion.calculator) ? currentQuestion.calculator : [currentQuestion.calculator];
                calcSlugs.forEach(function(slug, cIdx) {
                    var calcId = 'questionCalc_' + cIdx;
                    html += '<div class="calc-container" id="' + calcId + '" data-calc-slug="' + slug + '"></div>';
                });
            }

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

            // Render interactive plots if present
            if (currentQuestion.interactive_plot) {
                var plotSlugs = Array.isArray(currentQuestion.interactive_plot) ? currentQuestion.interactive_plot : [currentQuestion.interactive_plot];
                var plotFile = '<%=request.getContextPath()%>/exams/books/ncert/' + BOOK_CLASS + '/' + BOOK_PART + '/data/plots/ch' + CHAPTER_NUM + '-plots.json';
                fetch(plotFile)
                    .then(function(r) {
                        if (!r.ok) throw new Error('Plot file not found: ' + r.status);
                        return r.json();
                    })
                    .then(function(plotData) {
                        var script = document.createElement('script');
                        script.src = 'https://unpkg.com/function-plot/dist/function-plot.js';
                        script.onload = function() {
                            plotSlugs.forEach(function(slug, pIdx) {
                                var plotId = 'questionPlot_' + pIdx;
                                var plotEl = document.getElementById(plotId);
                                var config = plotData[slug];
                                if (!plotEl || !config) return;
                                try {
                                    functionPlot({
                                        target: '#' + plotId,
                                        width: plotEl.offsetWidth || 500,
                                        height: 350,
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
                                    });
                                    // Build legend
                                    var legendEl = document.getElementById(plotId + '_legend');
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
                        };
                        document.head.appendChild(script);
                    })
                    .catch(function(err) { console.log('Plot data error:', err); });
            }

            // Render p5.js sketches if present
            if (currentQuestion.p5_sketch) {
                var sketchTargets = container.querySelectorAll('.p5-sketch-target[data-sketch-slug]');
                if (sketchTargets.length > 0) {
                    var sketchFile = '<%=request.getContextPath()%>/exams/books/ncert/' + BOOK_CLASS + '/' + BOOK_PART + '/data/sketches/ch' + CHAPTER_NUM + '-sketches.json';
                    fetch(sketchFile)
                        .then(function(r) {
                            if (!r.ok) throw new Error('Sketch file not found: ' + r.status);
                            return r.json();
                        })
                        .then(function(sketchData) {
                            loadP5(function() {
                                for (var i = 0; i < sketchTargets.length; i++) {
                                    var el = sketchTargets[i];
                                    var slug = el.dataset.sketchSlug;
                                    var config = sketchData[slug];
                                    if (!config) continue;
                                    PhysicsSketches.render(el, config.type, config.params || {});
                                }
                            });
                        })
                        .catch(function(err) { console.log('Sketch data error:', err); });
                }
            }

            // Render calculators if present
            if (currentQuestion.calculator) {
                var calcTargets = container.querySelectorAll('.calc-container[data-calc-slug]');
                if (calcTargets.length > 0) {
                    var calcFile = '<%=request.getContextPath()%>/exams/books/ncert/' + BOOK_CLASS + '/' + BOOK_PART + '/data/calculators/ch' + CHAPTER_NUM + '-calculators.json';
                    fetch(calcFile)
                        .then(function(r) {
                            if (!r.ok) throw new Error('Calculator file not found: ' + r.status);
                            return r.json();
                        })
                        .then(function(calcData) {
                            loadCalculatorsJs(function() {
                                for (var i = 0; i < calcTargets.length; i++) {
                                    var el = calcTargets[i];
                                    var slug = el.dataset.calcSlug;
                                    var config = calcData[slug];
                                    if (!config) continue;
                                    PhysicsCalculators.render(el, config);
                                }
                            });
                        })
                        .catch(function(err) { console.log('Calculator data error:', err); });
                }
            }

            // Inject QAPage Schema for SEO
            injectQASchema(currentQuestion);
        })
        .catch(function(error) {
            console.error('Error loading question:', error);
            container.innerHTML = '<div class="card" style="text-align:center;padding:var(--space-8);color:var(--error);">Error loading question. Please try again.</div>';
        });
})();

// --- p5.js Physics Sketch Support ---
var _p5Loaded = false;
var _physicsSketchesLoaded = false;

function loadP5(callback) {
    if (_p5Loaded && _physicsSketchesLoaded) { callback(); return; }
    if (_p5Loaded && !_physicsSketchesLoaded) {
        var s2 = document.createElement('script');
        s2.src = '<%=request.getContextPath()%>/exams/books/ncert/physics-sketches.js';
        s2.onload = function() { _physicsSketchesLoaded = true; callback(); };
        document.head.appendChild(s2);
        return;
    }
    var s1 = document.createElement('script');
    s1.src = 'https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.4/p5.min.js';
    s1.onload = function() {
        _p5Loaded = true;
        var s2 = document.createElement('script');
        s2.src = '<%=request.getContextPath()%>/exams/books/ncert/physics-sketches.js';
        s2.onload = function() { _physicsSketchesLoaded = true; callback(); };
        document.head.appendChild(s2);
    };
    document.head.appendChild(s1);
}

// --- Calculator Support ---
var _calculatorsJsLoaded = false;
var _functionPlotLoaded = false;

function loadCalculatorsJs(callback) {
    function loadCalcScript() {
        if (_calculatorsJsLoaded) { callback(); return; }
        var s = document.createElement('script');
        s.src = '<%=request.getContextPath()%>/exams/books/ncert/physics-calculators.js';
        s.onload = function() { _calculatorsJsLoaded = true; callback(); };
        document.head.appendChild(s);
    }
    if (_functionPlotLoaded || window.functionPlot) { _functionPlotLoaded = true; loadCalcScript(); return; }
    var fp = document.createElement('script');
    fp.src = 'https://unpkg.com/function-plot/dist/function-plot.js';
    fp.onload = function() { _functionPlotLoaded = true; loadCalcScript(); };
    document.head.appendChild(fp);
}

function toggleHint() {
    var content = document.getElementById('hintContent');
    var toggleText = document.getElementById('hintToggleText');
    content.classList.toggle('show');
    toggleText.textContent = content.classList.contains('show') ? 'Hide Hint' : 'Show Hint';
}

function injectQASchema(q) {
    var BOOK_PART = '<%= bookPart %>';
    var NCERT_LABEL = '<%= ncertLabel.replace("'", "\\'") %>';
    var questionText = (q.question_plain || '')
        .replace(/\\[\(\)\[\]]/g, '')
        .replace(/\\\w+/g, '');

    var answerParts = [];
    var steps = q.solution_steps_latex || q.solution_steps;
    if (steps && steps.length > 0) {
        answerParts = steps.map(function(step, i) {
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
            "name": NCERT_LABEL + " " + q.exercise + " " + q.question_number + ": " + questionText.substring(0, 200),
            "text": questionText,
            "answerCount": 1,
            "dateCreated": "2025-01-01",
            "author": {
                "@type": "Organization",
                "name": "NCERT"
            },
            "acceptedAnswer": {
                "@type": "Answer",
                "text": answerParts.join(' '),
                "dateCreated": "2025-01-01",
                "author": {
                    "@type": "Organization",
                    "name": "8gwifi.org"
                },
                "upvoteCount": 10
            }
        }
    };

    var breadcrumbSchema = {
        "@context": "https://schema.org",
        "@type": "BreadcrumbList",
        "itemListElement": [
            {"@type": "ListItem", "position": 1, "name": "Home", "item": "https://8gwifi.org/"},
            {"@type": "ListItem", "position": 2, "name": "Exams", "item": "https://8gwifi.org/exams/"},
            {"@type": "ListItem", "position": 3, "name": "NCERT", "item": "https://8gwifi.org/exams/books/ncert/"},
            {"@type": "ListItem", "position": 4, "name": "<%= fullLabel %>", "item": "https://8gwifi.org/exams/books/ncert/<%= bookClass %>/<%= bookPart %>/"},
            {"@type": "ListItem", "position": 5, "name": "<%= chapterName %>", "item": "https://8gwifi.org/exams/books/ncert/<%= bookClass %>/<%= bookPart %>/<%= chapterSlug %>/"},
            {"@type": "ListItem", "position": 6, "name": q.exercise + " " + q.question_number}
        ]
    };

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

<%@ include file="../../components/footer.jsp" %>
