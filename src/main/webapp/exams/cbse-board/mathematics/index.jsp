<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // SEO: This page is dedicated to CBSE Class 10 Maths practice sets
    request.setAttribute("pageTitle", "CBSE Class 10 Maths Practice Papers & Mock Tests (Free)");
    request.setAttribute(
        "pageDescription",
        "Free CBSE Class 10 Maths practice papers and full-length mock tests with detailed solutions. " +
        "Each set follows the latest CBSE board exam pattern with MCQ, VSA, SA, LA and Case Study questions."
    );
    request.setAttribute("canonicalUrl", "https://8gwifi.org/exams/cbse-board/mathematics/");
%>
<%@ include file="../../components/header.jsp" %>

<!-- Dashboard CSS for progress card styles -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/exams/css/dashboard.css">

<div class="container">
    <!-- Breadcrumb -->
    <nav class="breadcrumb">
        <a href="<%=request.getContextPath()%>/exams/">Exams</a>
        <span class="breadcrumb-separator">/</span>
        <a href="<%=request.getContextPath()%>/exams/cbse-board/">CBSE Board</a>
        <span class="breadcrumb-separator">/</span>
        <span class="breadcrumb-current">Mathematics Practice Sets</span>
    </nav>

    <!-- Page Header -->
    <header style="margin-bottom: var(--space-6);">
        <a href="<%=request.getContextPath()%>/exams/cbse-board/" class="back-link">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polyline points="15 18 9 12 15 6"></polyline>
            </svg>
            Back to CBSE Board
        </a>
        <h1 style="font-size: var(--text-3xl); font-weight: 700; color: var(--text-primary); margin-bottom: var(--space-2);">
            Class 10 Mathematics
        </h1>
        <p style="font-size: var(--text-lg); color: var(--text-secondary);">
            Practice sets following the CBSE board exam pattern
        </p>
    </header>

    <!-- Ad: Header Banner -->
    <%@ include file="../../components/ad-leaderboard.jsp" %>

    <!-- Your Progress Card (for logged-in users) -->
    <% if (isLoggedIn) { %>
    <section id="progress-section" class="subject-progress-card" style="display: none;">
        <div class="subject-progress-header">
            <h3 class="subject-progress-title">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polyline points="23 6 13.5 15.5 8.5 10.5 1 18"></polyline>
                    <polyline points="17 6 23 6 23 12"></polyline>
                </svg>
                Your Progress in Mathematics
            </h3>
            <a href="<%=request.getContextPath()%>/exams/dashboard.jsp" class="btn btn-secondary btn-sm">
                View Dashboard
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polyline points="9 18 15 12 9 6"></polyline>
                </svg>
            </a>
        </div>
        <div class="subject-progress-stats">
            <div class="progress-stat-mini">
                <div class="progress-stat-mini-value" id="progress-attempts">--</div>
                <div class="progress-stat-mini-label">Attempts</div>
            </div>
            <div class="progress-stat-mini">
                <div class="progress-stat-mini-value" id="progress-completed">--</div>
                <div class="progress-stat-mini-label">Completed</div>
            </div>
            <div class="progress-stat-mini">
                <div class="progress-stat-mini-value" id="progress-avg">--%</div>
                <div class="progress-stat-mini-label">Avg Score</div>
            </div>
            <div class="progress-stat-mini">
                <div class="progress-stat-mini-value" id="progress-best">--%</div>
                <div class="progress-stat-mini-label">Best Score</div>
            </div>
        </div>
    </section>
    <% } %>

    <!-- Practice Sets Grid -->
    <section class="page-section" style="padding-top: var(--space-4);">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: var(--space-6);">
            <h2 class="section-title" style="margin-bottom: 0;">Available Practice Sets</h2>
            <span class="text-muted text-sm" id="sets-count">Loading...</span>
        </div>

        <!-- Loading State -->
        <div id="sets-loading" class="card" style="text-align: center; padding: var(--space-8);">
            <div class="loading-spinner" style="margin: 0 auto var(--space-4);"></div>
            <p class="text-muted">Loading practice sets...</p>
        </div>

        <!-- Error State -->
        <div id="sets-error" class="card" style="text-align: center; padding: var(--space-8); display: none;">
            <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="var(--error)" stroke-width="2" style="margin: 0 auto var(--space-4);">
                <circle cx="12" cy="12" r="10"></circle>
                <line x1="12" y1="8" x2="12" y2="12"></line>
                <line x1="12" y1="16" x2="12.01" y2="16"></line>
            </svg>
            <h3 style="color: var(--error); margin-bottom: var(--space-2);">Failed to Load Sets</h3>
            <p class="text-muted" id="sets-error-message">Could not load practice sets. Please try again.</p>
            <button class="btn btn-primary mt-4" onclick="loadPracticeSets()">Retry</button>
        </div>

        <!-- Sets Grid (populated by JavaScript) -->
        <div class="grid grid-2" id="sets-grid" style="display: none;">
            <!-- Sets will be populated here by JavaScript -->
        </div>
    </section>

    <!-- Ad: Footer Banner -->
    <%@ include file="../../components/ad-leaderboard.jsp" %>

    <!-- Instructions Card -->
    <section class="page-section">
        <div class="card" style="background: var(--info-light); border-color: var(--info);">
            <h3 style="color: var(--info); margin-bottom: var(--space-4); display: flex; align-items: center; gap: var(--space-2);">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="12" y1="16" x2="12" y2="12"></line>
                    <line x1="12" y1="8" x2="12.01" y2="8"></line>
                </svg>
                How to Use Practice Sets
            </h3>
            <ol style="padding-left: var(--space-6); color: var(--text-secondary);">
                <li style="margin-bottom: var(--space-2);">Click on any practice set to start</li>
                <li style="margin-bottom: var(--space-2);">Navigate between questions using the navigator panel or Previous/Next buttons</li>
                <li style="margin-bottom: var(--space-2);">Use "Mark for Review" to flag questions you want to revisit</li>
                <li style="margin-bottom: var(--space-2);">Your progress is automatically saved - you can continue later</li>
                <li style="margin-bottom: var(--space-2);">Click "Submit" when you're done to see your results and solutions</li>
            </ol>
        </div>
    </section>
</div>

<!-- JavaScript for loading practice sets from API -->
<script src="<%=request.getContextPath()%>/exams/js/exams-toast.js"></script>
<script src="<%=request.getContextPath()%>/exams/js/exams-api.js"></script>
<script>
    // Initialize API
    const API_BASE = '<%=request.getContextPath()%>/CFExamMarkerFunctionality';
    const CONTEXT_PATH = '<%=request.getContextPath()%>';
    const IS_LOGGED_IN = <%= isLoggedIn %>;
    <%
        // Get user ID - prefer userSub, fallback to email for consistency
        String indexUserId = userSub;
        if (indexUserId == null || indexUserId.isEmpty()) {
            indexUserId = userEmail;
        }
    %>
    const USER_ID = '<%= indexUserId != null ? indexUserId : "" %>';
    console.log('Index page USER_ID:', USER_ID, 'IS_LOGGED_IN:', IS_LOGGED_IN);

    ExamAPI.setApiBase(API_BASE);
    console.log('API Base URL:', API_BASE);

    // Store user attempts for rendering
    let userAttempts = [];
    let attemptsBySetId = {};

    /**
     * Normalize attempt data from API to expected format
     * API returns: id, total_marks_obtained, total_marks_possible, time_spent_seconds
     * We expect: attempt_id, score, total_marks, time_taken_seconds
     */
    function normalizeAttempt(attempt) {
        return {
            ...attempt,
            // Map API field names to expected names
            attempt_id: attempt.id,
            score: attempt.total_marks_obtained,
            total_marks: attempt.total_marks_possible,
            time_taken_seconds: attempt.time_spent_seconds,
            percentage: attempt.percentage
        };
    }

    // Load practice sets on page load
    document.addEventListener('DOMContentLoaded', function() {
        console.log('DOM loaded, starting to load practice sets...');
        loadPracticeSets();
    });

    // Fallback: If DOMContentLoaded already fired, load immediately
    if (document.readyState === 'loading') {
        // DOMContentLoaded will fire
    } else {
        // DOM already loaded, load sets immediately
        console.log('DOM already loaded, loading practice sets immediately...');
        loadPracticeSets();
    }

    /**
     * Load practice sets from API
     */
    async function loadPracticeSets() {
        const loadingEl = document.getElementById('sets-loading');
        const errorEl = document.getElementById('sets-error');
        const gridEl = document.getElementById('sets-grid');
        const countEl = document.getElementById('sets-count');

        // Show loading state
        loadingEl.style.display = 'block';
        errorEl.style.display = 'none';
        gridEl.style.display = 'none';

        try {
            console.log('Loading practice sets...');

            // Load sets and user attempts in parallel (if logged in)
            const promises = [
                ExamAPI.listSets({
                    exam_type: 'CBSE',
                    grade: '10',
                    subject: 'mathematics',
                    test_type: 'full'
                })
            ];

            if (IS_LOGGED_IN && USER_ID) {
                promises.push(ExamAPI.getUserAttempts(USER_ID, 100, 0));
            }

            const results = await Promise.all(promises);
            const response = results[0];
            const attemptsResponse = results[1];

            console.log('API response received:', response);

            if (!response) {
                throw new Error('No response from server');
            }

            if (!response.success) {
                throw new Error(response.message || response.error || 'Failed to load practice sets');
            }

            if (!response.sets || response.sets.length === 0) {
                throw new Error('No practice sets found');
            }

            // Process user attempts if available
            if (attemptsResponse && attemptsResponse.success && attemptsResponse.attempts) {
                // Normalize API field names to expected format
                userAttempts = attemptsResponse.attempts.map(normalizeAttempt);

                console.log('Normalized user attempts:', userAttempts);

                // Group attempts by set_id
                attemptsBySetId = {};
                userAttempts.forEach(attempt => {
                    const setId = attempt.set_id;
                    if (!attemptsBySetId[setId]) {
                        attemptsBySetId[setId] = [];
                    }
                    attemptsBySetId[setId].push(attempt);
                });

                // Update progress card
                updateProgressCard();
            }

            // Update count
            countEl.textContent = response.sets.length + ' Set' + (response.sets.length !== 1 ? 's' : '');

            // Render sets
            renderSets(response.sets);

            // Hide loading, show grid
            loadingEl.style.display = 'none';
            gridEl.style.display = 'grid';

        } catch (error) {
            console.error('Failed to load practice sets:', error);

            // Show error state
            loadingEl.style.display = 'none';
            errorEl.style.display = 'block';
            document.getElementById('sets-error-message').textContent =
                error.message || 'Could not load practice sets. Please try again.';

            // Show toast notification (if available)
            if (typeof ExamToast !== 'undefined' && ExamToast.error) {
                ExamToast.error(
                    error.message || 'Failed to load practice sets. Please try again.',
                    {
                        duration: 5000,
                        action: 'Retry',
                        onAction: () => loadPracticeSets()
                    }
                );
            }
        }
    }

    /**
     * Update progress card with user stats
     */
    function updateProgressCard() {
        const progressSection = document.getElementById('progress-section');
        if (!progressSection || userAttempts.length === 0) return;

        // Show progress section
        progressSection.style.display = 'block';

        // Calculate stats
        const completed = userAttempts.filter(a => a.status === 'completed' || a.status === 'graded');

        // Total attempts
        document.getElementById('progress-attempts').textContent = userAttempts.length;

        // Completed
        document.getElementById('progress-completed').textContent = completed.length;

        // Average and best score
        if (completed.length > 0) {
            const scores = completed
                .filter(a => a.score !== null && a.total_marks !== null && a.total_marks > 0)
                .map(a => (a.score / a.total_marks) * 100);

            if (scores.length > 0) {
                const avgScore = scores.reduce((a, b) => a + b, 0) / scores.length;
                document.getElementById('progress-avg').textContent = Math.round(avgScore) + '%';

                const bestScore = Math.max(...scores);
                document.getElementById('progress-best').textContent = Math.round(bestScore) + '%';
            }
        }
    }

    /**
     * Get attempt info for a set
     */
    function getSetAttemptInfo(setId) {
        const attempts = attemptsBySetId[setId] || [];
        if (attempts.length === 0) return null;

        const completed = attempts.filter(a => a.status === 'completed' || a.status === 'graded');
        const inProgress = attempts.filter(a => a.status === 'in_progress' || a.status === 'started');

        let bestScore = null;
        let bestPct = null;

        if (completed.length > 0) {
            const scores = completed
                .filter(a => a.score !== null && a.total_marks !== null && a.total_marks > 0)
                .map(a => ({
                    score: a.score,
                    total: a.total_marks,
                    pct: (a.score / a.total_marks) * 100
                }));

            if (scores.length > 0) {
                const best = scores.reduce((max, s) => s.pct > max.pct ? s : max, scores[0]);
                bestScore = best.score + '/' + best.total;
                bestPct = Math.round(best.pct);
            }
        }

        return {
            totalAttempts: attempts.length,
            completedCount: completed.length,
            inProgressCount: inProgress.length,
            bestScore: bestScore,
            bestPct: bestPct,
            latestInProgress: inProgress.length > 0 ? inProgress[inProgress.length - 1] : null
        };
    }

    /**
     * Render practice sets
     */
    function renderSets(sets) {
        const gridEl = document.getElementById('sets-grid');

        gridEl.innerHTML = sets.map(set => {
            // Map API set ID to practice.jsp format
            // cbse-10-math-full-01 -> set-01_full
            let practiceSetParam = set.id;
            if (set.id && set.id.includes('-full-')) {
                const match = set.id.match(/-full-(\d+)$/);
                if (match) {
                    const num = parseInt(match[1]);
                    const formattedNum = num < 10 ? '0' + num : String(num);
                    practiceSetParam = 'set-' + formattedNum + '_full';
                }
            }

            // Determine difficulty from set data or default
            const difficulty = set.difficulty || 'medium';
            const difficultyClass = difficulty.toLowerCase();

            // Determine test type badge text (pure JavaScript, no JSP EL)
            let badgeText = 'Practice';
            if (set.test_type === 'full') {
                badgeText = 'Full Paper';
            } else if (set.test_type) {
                badgeText = set.test_type;
            }

            // Build HTML using string concatenation to avoid JSP EL conflicts
            const setName = escapeHtml(set.name || 'Practice Set');
            const totalQuestions = set.total_questions || 0;
            const questionText = totalQuestions !== 1 ? 'Questions' : 'Question';
            const duration = set.duration_minutes || 90;
            const totalMarks = set.total_marks || 80;
            const difficultyText = difficulty.charAt(0).toUpperCase() + difficulty.slice(1);

            // Get attempt info for this set
            const attemptInfo = IS_LOGGED_IN ? getSetAttemptInfo(set.id) : null;

            // Build attempt info HTML
            let attemptInfoHtml = '';
            let buttonHtml = '';

            if (attemptInfo) {
                if (attemptInfo.inProgressCount > 0) {
                    // Has in-progress attempt
                    attemptInfoHtml = '<div class="set-attempt-info in-progress">' +
                        '<div class="set-attempt-info-row">' +
                            '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">' +
                                '<circle cx="12" cy="12" r="10"></circle>' +
                                '<polyline points="12 6 12 12 16 14"></polyline>' +
                            '</svg>' +
                            '<span>In Progress - <strong>Resume your attempt</strong></span>' +
                        '</div>' +
                    '</div>';

                    buttonHtml = '<button class="btn btn-warning btn-block mt-4">' +
                        'Resume Practice' +
                        '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">' +
                            '<polyline points="9 18 15 12 9 6"></polyline>' +
                        '</svg>' +
                    '</button>';
                } else if (attemptInfo.completedCount > 0) {
                    // Has completed attempts
                    attemptInfoHtml = '<div class="set-attempt-info has-attempts">' +
                        '<div class="set-attempt-info-row">' +
                            '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">' +
                                '<path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>' +
                                '<polyline points="22 4 12 14.01 9 11.01"></polyline>' +
                            '</svg>' +
                            '<span>' +
                                '<span class="attempt-count">' + attemptInfo.totalAttempts + ' attempt' + (attemptInfo.totalAttempts !== 1 ? 's' : '') + '</span>' +
                                ' | Best: <span class="best-score">' + attemptInfo.bestScore + ' (' + attemptInfo.bestPct + '%)</span>' +
                            '</span>' +
                        '</div>' +
                    '</div>';

                    buttonHtml = '<button class="btn btn-primary btn-block mt-4">' +
                        'Practice Again' +
                        '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">' +
                            '<polyline points="9 18 15 12 9 6"></polyline>' +
                        '</svg>' +
                    '</button>';
                }
            }

            // Default button if no attempt info
            if (!buttonHtml) {
                if (IS_LOGGED_IN) {
                    attemptInfoHtml = '<div class="set-attempt-info">' +
                        '<div class="set-attempt-info-row">' +
                            '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">' +
                                '<polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>' +
                            '</svg>' +
                            '<span>Not attempted yet</span>' +
                        '</div>' +
                    '</div>';
                }

                buttonHtml = '<button class="btn btn-primary btn-block mt-4">' +
                    'Start Practice' +
                    '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">' +
                        '<polyline points="9 18 15 12 9 6"></polyline>' +
                    '</svg>' +
                '</button>';
            }

            return '<a href="' + CONTEXT_PATH + '/exams/cbse-board/mathematics/practice.jsp?set=' + practiceSetParam + '" class="card card-clickable set-card">' +
                '<div class="set-card-header">' +
                    '<h3 class="set-card-title">' + setName + '</h3>' +
                    '<span class="set-card-badge">' + escapeHtml(badgeText) + '</span>' +
                '</div>' +
                '<div class="set-card-meta">' +
                    '<div class="set-card-meta-item">' +
                        '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">' +
                            '<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>' +
                            '<polyline points="14 2 14 8 20 8"></polyline>' +
                        '</svg>' +
                        '<span>' + totalQuestions + ' ' + questionText + '</span>' +
                    '</div>' +
                    '<div class="set-card-meta-item">' +
                        '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">' +
                            '<circle cx="12" cy="12" r="10"></circle>' +
                            '<polyline points="12 6 12 12 16 14"></polyline>' +
                        '</svg>' +
                        '<span>' + duration + ' mins</span>' +
                    '</div>' +
                    '<div class="set-card-meta-item">' +
                        '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">' +
                            '<polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>' +
                        '</svg>' +
                        '<span>' + totalMarks + ' marks</span>' +
                    '</div>' +
                '</div>' +
                '<div style="margin-top: var(--space-3);">' +
                    '<span class="text-sm text-muted">Difficulty:</span>' +
                    '<div class="difficulty-bar ' + difficultyClass + '" style="display: inline-flex; margin-left: var(--space-2);">' +
                        '<span></span><span></span><span></span><span></span><span></span>' +
                    '</div>' +
                    '<span class="text-sm text-muted" style="margin-left: var(--space-2); text-transform: capitalize;">' + escapeHtml(difficultyText) + '</span>' +
                '</div>' +
                attemptInfoHtml +
                buttonHtml +
            '</a>';
        }).join('');
    }

    /**
     * Escape HTML to prevent XSS
     */
    function escapeHtml(text) {
        if (!text) return '';
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
</script>

<!-- Structured Data: CBSE Class 10 Maths Practice Collection -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "CollectionPage",
  "name": "CBSE Class 10 Maths Practice Papers & Mock Tests",
  "description": "Free CBSE Class 10 Mathematics practice sets and mock tests following the latest board exam pattern.",
  "url": "https://8gwifi.org/exams/cbse-board/mathematics/",
  "inLanguage": "en-IN",
  "about": {
    "@type": "Course",
    "name": "CBSE Class 10 Mathematics",
    "educationalLevel": "Class 10",
    "provider": {
      "@type": "Organization",
      "name": "8gwifi.org",
      "url": "https://8gwifi.org"
    }
  }
}
</script>

<%@ include file="../../components/footer.jsp" %>

<%@ include file="../../components/footer.jsp" %>