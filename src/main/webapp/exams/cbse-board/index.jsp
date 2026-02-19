<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "CBSE Board Practice Tests";
    String seoDescription = "Free CBSE Class 10 practice tests and mock exams. Prepare for your board exams with curated question sets following the latest syllabus and exam pattern.";
    String canonicalUrl = "https://8gwifi.org/exams/cbse-board/";

    request.setAttribute("pageTitle", seoTitle);
    request.setAttribute("pageDescription", seoDescription);
    request.setAttribute("canonicalUrl", canonicalUrl);

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"").append(seoTitle).append("\">\n");
    extraHead.append("<meta property=\"og:description\" content=\"").append(seoDescription).append("\">\n");
    extraHead.append("<meta property=\"og:url\" content=\"").append(canonicalUrl).append("\">\n");
    extraHead.append("<meta property=\"og:type\" content=\"website\">\n");
    extraHead.append("<meta property=\"og:site_name\" content=\"8gwifi.org\">\n");
    extraHead.append("<meta property=\"og:image\" content=\"https://8gwifi.org/exams/images/cbse-board-og.svg\">\n");
    extraHead.append("<meta name=\"twitter:card\" content=\"summary_large_image\">\n");
    extraHead.append("<meta name=\"twitter:title\" content=\"").append(seoTitle).append("\">\n");
    extraHead.append("<meta name=\"twitter:description\" content=\"").append(seoDescription).append("\">\n");
    extraHead.append("<meta name=\"twitter:image\" content=\"https://8gwifi.org/exams/images/cbse-board-og.svg\">\n");
    request.setAttribute("extraHeadContent", extraHead.toString());
%>
<%@ include file="../components/header.jsp" %>

<div class="container">
    <!-- Breadcrumb -->
    <nav class="breadcrumb">
        <a href="<%=request.getContextPath()%>/exams/">Exams</a>
        <span class="breadcrumb-separator">/</span>
        <span class="breadcrumb-current">CBSE Board</span>
    </nav>

    <!-- Page Header -->
    <header style="margin-bottom: var(--space-8);">
        <h1 style="font-size: var(--text-3xl); font-weight: 700; color: var(--text-primary); margin-bottom: var(--space-2);">
            CBSE Board Practice Tests
        </h1>
        <p style="font-size: var(--text-lg); color: var(--text-secondary); max-width: 700px;">
            Prepare for your CBSE Class 10 board exams with our comprehensive practice sets. Each set follows the official exam pattern and marking scheme.
        </p>
    </header>

    <!-- Ad: Header Banner -->
    <%@ include file="../components/ad-leaderboard.jsp" %>

    <!-- Subjects Grid -->
    <section class="page-section" style="padding-top: 0;">
        <h2 class="section-title">Available Subjects</h2>

        <div class="grid grid-2">
            <!-- Mathematics -->
            <a href="<%=request.getContextPath()%>/exams/cbse-board/mathematics/" class="card card-clickable">
                <div style="display: flex; align-items: center; gap: var(--space-4);">
                    <div style="width: 56px; height: 56px; background: var(--accent-light); border-radius: var(--radius-lg); display: flex; align-items: center; justify-content: center;">
                        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="var(--accent-primary)" stroke-width="2">
                            <line x1="18" y1="6" x2="6" y2="18"></line>
                            <line x1="6" y1="6" x2="18" y2="18"></line>
                            <line x1="12" y1="3" x2="12" y2="21"></line>
                            <line x1="3" y1="12" x2="21" y2="12"></line>
                        </svg>
                    </div>
                    <div style="flex: 1;">
                        <h3 style="font-size: var(--text-xl); font-weight: 600; color: var(--text-primary); margin-bottom: var(--space-1);">
                            Mathematics
                        </h3>
                        <p style="color: var(--text-secondary); font-size: var(--text-sm); margin-bottom: var(--space-2);">
                            Class 10 - Standard
                        </p>
                        <div style="display: flex; gap: var(--space-4); font-size: var(--text-sm); color: var(--text-muted);">
                            <span>5 Practice Sets</span>
                            <span>180+ Questions</span>
                        </div>
                    </div>
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="var(--text-muted)" stroke-width="2">
                        <polyline points="9 18 15 12 9 6"></polyline>
                    </svg>
                </div>
            </a>

            <!-- Science (Coming Soon) -->
            <div class="card" style="opacity: 0.6;">
                <div style="display: flex; align-items: center; gap: var(--space-4);">
                    <div style="width: 56px; height: 56px; background: var(--bg-tertiary); border-radius: var(--radius-lg); display: flex; align-items: center; justify-content: center;">
                        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="var(--text-muted)" stroke-width="2">
                            <path d="M9 3h6v11H9z"></path>
                            <path d="M4 19.5C4 18.1 5.1 17 6.5 17h11c1.4 0 2.5 1.1 2.5 2.5S18.9 22 17.5 22h-11C5.1 22 4 20.9 4 19.5z"></path>
                        </svg>
                    </div>
                    <div style="flex: 1;">
                        <h3 style="font-size: var(--text-xl); font-weight: 600; color: var(--text-primary); margin-bottom: var(--space-1);">
                            Science
                        </h3>
                        <p style="color: var(--text-secondary); font-size: var(--text-sm); margin-bottom: var(--space-2);">
                            Class 10
                        </p>
                        <span class="board-card-badge coming-soon">Coming Soon</span>
                    </div>
                </div>
            </div>

            <!-- English (Coming Soon) -->
            <div class="card" style="opacity: 0.6;">
                <div style="display: flex; align-items: center; gap: var(--space-4);">
                    <div style="width: 56px; height: 56px; background: var(--bg-tertiary); border-radius: var(--radius-lg); display: flex; align-items: center; justify-content: center;">
                        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="var(--text-muted)" stroke-width="2">
                            <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                            <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                        </svg>
                    </div>
                    <div style="flex: 1;">
                        <h3 style="font-size: var(--text-xl); font-weight: 600; color: var(--text-primary); margin-bottom: var(--space-1);">
                            English
                        </h3>
                        <p style="color: var(--text-secondary); font-size: var(--text-sm); margin-bottom: var(--space-2);">
                            Class 10
                        </p>
                        <span class="board-card-badge coming-soon">Coming Soon</span>
                    </div>
                </div>
            </div>

            <!-- Social Science (Coming Soon) -->
            <div class="card" style="opacity: 0.6;">
                <div style="display: flex; align-items: center; gap: var(--space-4);">
                    <div style="width: 56px; height: 56px; background: var(--bg-tertiary); border-radius: var(--radius-lg); display: flex; align-items: center; justify-content: center;">
                        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="var(--text-muted)" stroke-width="2">
                            <circle cx="12" cy="12" r="10"></circle>
                            <line x1="2" y1="12" x2="22" y2="12"></line>
                            <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"></path>
                        </svg>
                    </div>
                    <div style="flex: 1;">
                        <h3 style="font-size: var(--text-xl); font-weight: 600; color: var(--text-primary); margin-bottom: var(--space-1);">
                            Social Science
                        </h3>
                        <p style="color: var(--text-secondary); font-size: var(--text-sm); margin-bottom: var(--space-2);">
                            Class 10
                        </p>
                        <span class="board-card-badge coming-soon">Coming Soon</span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Exam Pattern Info -->
    <section class="page-section" style="background: var(--bg-primary); margin: 0 calc(var(--space-4) * -1); padding-left: var(--space-4); padding-right: var(--space-4);">
        <h2 class="section-title">CBSE Class 10 Mathematics Exam Pattern</h2>

        <div class="card">
            <table style="width: 100%; border-collapse: collapse; font-size: var(--text-sm);">
                <thead>
                    <tr style="background: var(--bg-tertiary);">
                        <th style="padding: var(--space-3); text-align: left; border-bottom: 1px solid var(--border);">Question Type</th>
                        <th style="padding: var(--space-3); text-align: center; border-bottom: 1px solid var(--border);">No. of Questions</th>
                        <th style="padding: var(--space-3); text-align: center; border-bottom: 1px solid var(--border);">Marks Each</th>
                        <th style="padding: var(--space-3); text-align: center; border-bottom: 1px solid var(--border);">Total Marks</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td style="padding: var(--space-3); border-bottom: 1px solid var(--border);">MCQ / Assertion-Reason</td>
                        <td style="padding: var(--space-3); text-align: center; border-bottom: 1px solid var(--border);">20</td>
                        <td style="padding: var(--space-3); text-align: center; border-bottom: 1px solid var(--border);">1</td>
                        <td style="padding: var(--space-3); text-align: center; border-bottom: 1px solid var(--border);">20</td>
                    </tr>
                    <tr style="background: var(--bg-secondary);">
                        <td style="padding: var(--space-3); border-bottom: 1px solid var(--border);">Very Short Answer (VSA)</td>
                        <td style="padding: var(--space-3); text-align: center; border-bottom: 1px solid var(--border);">5</td>
                        <td style="padding: var(--space-3); text-align: center; border-bottom: 1px solid var(--border);">2</td>
                        <td style="padding: var(--space-3); text-align: center; border-bottom: 1px solid var(--border);">10</td>
                    </tr>
                    <tr>
                        <td style="padding: var(--space-3); border-bottom: 1px solid var(--border);">Short Answer (SA)</td>
                        <td style="padding: var(--space-3); text-align: center; border-bottom: 1px solid var(--border);">6</td>
                        <td style="padding: var(--space-3); text-align: center; border-bottom: 1px solid var(--border);">3</td>
                        <td style="padding: var(--space-3); text-align: center; border-bottom: 1px solid var(--border);">18</td>
                    </tr>
                    <tr style="background: var(--bg-secondary);">
                        <td style="padding: var(--space-3); border-bottom: 1px solid var(--border);">Long Answer (LA)</td>
                        <td style="padding: var(--space-3); text-align: center; border-bottom: 1px solid var(--border);">4</td>
                        <td style="padding: var(--space-3); text-align: center; border-bottom: 1px solid var(--border);">5</td>
                        <td style="padding: var(--space-3); text-align: center; border-bottom: 1px solid var(--border);">20</td>
                    </tr>
                    <tr>
                        <td style="padding: var(--space-3); border-bottom: 1px solid var(--border);">Case Study</td>
                        <td style="padding: var(--space-3); text-align: center; border-bottom: 1px solid var(--border);">3</td>
                        <td style="padding: var(--space-3); text-align: center; border-bottom: 1px solid var(--border);">4</td>
                        <td style="padding: var(--space-3); text-align: center; border-bottom: 1px solid var(--border);">12</td>
                    </tr>
                    <tr style="background: var(--accent-light); font-weight: 600;">
                        <td style="padding: var(--space-3);">Total</td>
                        <td style="padding: var(--space-3); text-align: center;">38</td>
                        <td style="padding: var(--space-3); text-align: center;">-</td>
                        <td style="padding: var(--space-3); text-align: center;">80</td>
                    </tr>
                </tbody>
            </table>
            <p style="margin-top: var(--space-4); font-size: var(--text-sm); color: var(--text-muted);">
                * Duration: 3 hours | Internal choices available in some questions
            </p>
        </div>
    </section>

    <!-- Ad: Footer Banner -->
    <%@ include file="../components/ad-leaderboard.jsp" %>
</div>

<%@ include file="../components/footer.jsp" %>
