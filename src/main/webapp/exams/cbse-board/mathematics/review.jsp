<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%@ page import="java.util.Map" %>
<%
    // Check attempt_id parameter first
    String attemptIdParam = request.getParameter("attempt_id");
    if (attemptIdParam == null || attemptIdParam.isEmpty()) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Attempt ID is required");
        return;
    }

    // Check if user is logged in
    // Use different variable names to avoid conflicts with header.jsp
    String reviewUserSub = null;
    String reviewUserEmail = null;
    boolean reviewIsLoggedIn = false;

    HttpSession reviewSessionObj = request.getSession(false);
    if (reviewSessionObj != null) {
        // Try oauth_user_sub and oauth_user_email first
        reviewUserSub = (String) reviewSessionObj.getAttribute("oauth_user_sub");
        reviewUserEmail = (String) reviewSessionObj.getAttribute("oauth_user_email");

        // Fallback: Check oauth_user_info Map (some OAuth flows only set this)
        if ((reviewUserSub == null || reviewUserSub.isEmpty()) && (reviewUserEmail == null || reviewUserEmail.isEmpty())) {
            @SuppressWarnings("unchecked")
            Map<String, Object> userInfo = (Map<String, Object>) reviewSessionObj.getAttribute("oauth_user_info");
            if (userInfo != null) {
                // Try to get sub/id from userInfo
                Object subObj = userInfo.get("sub");
                if (subObj == null) subObj = userInfo.get("id");
                if (subObj != null) reviewUserSub = subObj.toString();

                // Try to get email from userInfo
                Object emailObj = userInfo.get("email");
                if (emailObj != null) reviewUserEmail = emailObj.toString();
            }
        }

        // User is logged in if either userSub OR userEmail exists
        reviewIsLoggedIn = (reviewUserSub != null && !reviewUserSub.isEmpty()) || (reviewUserEmail != null && !reviewUserEmail.isEmpty());
    }

    // Build redirect URL for login
    String reviewCurrentUrl = request.getRequestURI();
    String reviewQueryString = request.getQueryString();
    if (reviewQueryString != null && !reviewQueryString.isEmpty()) {
        reviewCurrentUrl += "?" + reviewQueryString;
    }
    String reviewRedirectPath = reviewCurrentUrl.replace(request.getContextPath(), "");
    if (!reviewRedirectPath.startsWith("/")) {
        reviewRedirectPath = "/" + reviewRedirectPath;
    }

    // If not logged in, redirect to login
    if (!reviewIsLoggedIn) {
        response.sendRedirect(request.getContextPath() + "/GoogleOAuthFunctionality?action=login&redirect_path=" +
            java.net.URLEncoder.encode(reviewRedirectPath, "UTF-8"));
        return;
    }

    // Get user ID for ownership verification
    String loggedInUserId = reviewUserSub;
    if (loggedInUserId == null || loggedInUserId.isEmpty()) {
        loggedInUserId = reviewUserEmail;
    }

    // Set page attributes for header.jsp
    request.setAttribute("pageTitle", "Review Test - CBSE Mathematics");
    request.setAttribute("pageDescription", "Review your completed test with answers and solutions.");
    request.setAttribute("includePracticeCSS", "true");
%>
<%@ include file="../../components/header.jsp" %>

<style>
    /* ============================================
       REVIEW PAGE STYLES
       ============================================ */
    .review-container {
        max-width: 1000px;
        margin: 0 auto;
        padding: var(--space-6) var(--space-4);
    }

    /* Review Header Card */
    .review-header-card {
        display: flex;
        justify-content: space-between;
        align-items: center;
        background: var(--bg-primary);
        border: 1px solid var(--border);
        border-radius: var(--radius-lg);
        padding: var(--space-6);
        margin-bottom: var(--space-6);
        gap: var(--space-4);
    }

    .review-title {
        font-size: 1.5rem;
        font-weight: 700;
        margin: 0 0 var(--space-2) 0;
        color: var(--text-primary);
    }

    .review-subtitle {
        font-size: 1rem;
        color: var(--text-secondary);
        margin: 0 0 var(--space-3) 0;
    }

    .review-meta {
        display: flex;
        gap: var(--space-4);
        flex-wrap: wrap;
    }

    .review-meta-item {
        display: flex;
        align-items: center;
        gap: var(--space-2);
        color: var(--text-muted);
        font-size: 0.875rem;
    }

    .review-score-circle {
        width: 100px;
        height: 100px;
        border-radius: 50%;
        background: var(--bg-hero);
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        color: white;
        flex-shrink: 0;
    }

    .review-score-value {
        font-size: 1.75rem;
        font-weight: 700;
    }

    .review-score-label {
        font-size: 0.75rem;
        opacity: 0.9;
    }

    /* Summary Stats Bar */
    .review-summary-bar {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: var(--space-3);
        margin-bottom: var(--space-6);
    }

    .summary-stat {
        background: var(--bg-primary);
        border: 1px solid var(--border);
        border-radius: var(--radius-md);
        padding: var(--space-4);
        text-align: center;
    }

    .summary-stat-value {
        font-size: 1.5rem;
        font-weight: 700;
        color: var(--text-primary);
    }

    .summary-stat-value.correct { color: var(--success); }
    .summary-stat-value.incorrect { color: var(--error); }
    .summary-stat-value.unanswered { color: var(--text-muted); }

    .summary-stat-label {
        font-size: 0.75rem;
        color: var(--text-muted);
        text-transform: uppercase;
        letter-spacing: 0.05em;
        margin-top: var(--space-1);
    }

    /* Review Actions */
    .review-actions {
        display: flex;
        gap: var(--space-3);
        margin-bottom: var(--space-6);
        flex-wrap: wrap;
        justify-content: space-between;
        align-items: center;
    }

    .review-actions-left {
        display: flex;
        gap: var(--space-3);
    }

    .review-actions-right {
        display: flex;
        gap: var(--space-2);
    }

    /* Collapsible Question Card */
    .review-question-card {
        background: var(--bg-primary);
        border: 1px solid var(--border);
        border-radius: var(--radius-lg);
        margin-bottom: var(--space-4);
        overflow: hidden;
        transition: box-shadow var(--transition-fast);
    }

    .review-question-card:hover {
        box-shadow: var(--shadow-md);
    }

    .review-question-card.correct {
        border-left: 4px solid var(--success);
    }

    .review-question-card.incorrect {
        border-left: 4px solid var(--error);
    }

    .review-question-card.unanswered {
        border-left: 4px solid var(--text-muted);
    }

    /* Question Header (Clickable) */
    .review-question-header {
        display: flex;
        align-items: center;
        gap: var(--space-3);
        padding: var(--space-4);
        cursor: pointer;
        user-select: none;
        background: var(--bg-secondary);
        transition: background var(--transition-fast);
    }

    .review-question-header:hover {
        background: var(--bg-tertiary);
    }

    .collapse-icon {
        width: 20px;
        height: 20px;
        color: var(--text-muted);
        transition: transform var(--transition-fast);
        flex-shrink: 0;
    }

    .review-question-card.expanded .collapse-icon {
        transform: rotate(90deg);
    }

    .review-question-number {
        font-weight: 600;
        font-size: 0.875rem;
        color: var(--text-primary);
    }

    .review-question-type {
        padding: var(--space-1) var(--space-2);
        background: var(--bg-tertiary);
        border-radius: var(--radius-sm);
        font-size: 0.75rem;
        color: var(--text-secondary);
    }

    .review-question-status {
        display: flex;
        align-items: center;
        gap: var(--space-2);
        margin-left: auto;
        font-size: 0.75rem;
        font-weight: 600;
        padding: var(--space-1) var(--space-3);
        border-radius: var(--radius-full);
    }

    .review-question-status.correct {
        background: var(--success-light);
        color: var(--success-dark);
    }

    .review-question-status.incorrect {
        background: var(--error-light);
        color: var(--error);
    }

    .review-question-status.unanswered {
        background: var(--bg-tertiary);
        color: var(--text-muted);
    }

    .review-question-marks {
        font-size: 0.75rem;
        color: var(--text-muted);
    }

    /* Question Content (Collapsible) */
    .review-question-content {
        display: none;
        padding: var(--space-6);
        border-top: 1px solid var(--border);
    }

    .review-question-card.expanded .review-question-content {
        display: block;
    }

    .review-question-text {
        font-size: 1rem;
        line-height: 1.6;
        color: var(--text-primary);
        margin-bottom: var(--space-4);
    }

    /* Diagram */
    .review-question-diagram {
        margin: var(--space-4) 0;
        text-align: center;
    }

    .review-question-diagram svg {
        max-width: 100%;
        height: auto;
        max-height: 250px;
    }

    /* Answer Section */
    .review-answer-section {
        margin-top: var(--space-4);
        padding: var(--space-4);
        background: var(--bg-secondary);
        border-radius: var(--radius-md);
    }

    .review-answer-section h4 {
        margin: 0 0 var(--space-3) 0;
        font-size: 0.875rem;
        font-weight: 600;
        color: var(--text-primary);
    }

    /* MCQ Options */
    .review-option {
        padding: var(--space-3);
        margin-bottom: var(--space-2);
        border-radius: var(--radius-sm);
        border: 2px solid var(--border);
        background: var(--bg-primary);
        position: relative;
    }

    .review-option:last-child {
        margin-bottom: 0;
    }

    .review-option.correct {
        border-color: var(--success);
        background: var(--success-light);
    }

    .review-option.incorrect {
        border-color: var(--error);
        background: var(--error-light);
    }

    .review-option.correct-not-selected {
        border-color: var(--success);
        border-style: dashed;
        background: rgba(16, 185, 129, 0.05);
    }

    .review-option-mark {
        position: absolute;
        top: var(--space-1);
        right: var(--space-2);
        font-size: 0.625rem;
        font-weight: 600;
        padding: 2px var(--space-2);
        border-radius: var(--radius-sm);
        text-transform: uppercase;
        letter-spacing: 0.03em;
    }

    .review-option-mark.your-correct {
        background: var(--success);
        color: white;
    }

    .review-option-mark.your-incorrect {
        background: var(--error);
        color: white;
    }

    .review-option-mark.correct-answer {
        background: var(--success);
        color: white;
    }

    .review-option-content {
        font-size: 0.875rem;
        color: var(--text-primary);
        padding-right: var(--space-16);
    }

    /* Text Answers */
    .review-answer-box {
        margin-bottom: var(--space-3);
    }

    .review-answer-label {
        font-size: 0.75rem;
        font-weight: 600;
        color: var(--text-muted);
        text-transform: uppercase;
        margin-bottom: var(--space-1);
    }

    .review-answer-value {
        padding: var(--space-3);
        background: var(--bg-primary);
        border-radius: var(--radius-sm);
        white-space: pre-wrap;
        font-size: 0.875rem;
        color: var(--text-primary);
        border: 1px solid var(--border);
    }

    .review-answer-value.not-answered {
        color: var(--text-muted);
        font-style: italic;
    }

    .review-correct-answer {
        margin-top: var(--space-3);
        padding: var(--space-3);
        background: var(--success-light, rgba(16, 185, 129, 0.1));
        border-radius: var(--radius-sm);
        border-left: 4px solid var(--success, #10b981);
        color: var(--text-primary);
    }

    .review-correct-answer .review-answer-label {
        color: var(--success-dark, #065f46);
        font-weight: 700;
    }

    .review-correct-answer > div:last-child {
        color: var(--text-primary);
        font-size: 0.9rem;
        line-height: 1.6;
        margin-top: var(--space-2);
    }

    [data-theme="dark"] .review-correct-answer {
        background: rgba(16, 185, 129, 0.15);
        border-left-color: var(--success, #10b981);
    }

    [data-theme="dark"] .review-correct-answer .review-answer-label {
        color: var(--success, #10b981);
    }

    [data-theme="dark"] .review-correct-answer > div:last-child {
        color: var(--text-primary);
    }

    .review-marks-awarded {
        margin-top: var(--space-3);
        padding: var(--space-2) var(--space-3);
        background: var(--bg-tertiary);
        border-radius: var(--radius-sm);
        font-size: 0.875rem;
        font-weight: 600;
        color: var(--accent-primary);
        display: inline-block;
    }

    .review-confidence {
        font-weight: 400;
        font-size: 0.75rem;
        color: var(--text-muted);
        margin-left: var(--space-2);
    }

    .review-feedback {
        margin-top: var(--space-3);
        padding: var(--space-3);
        background: linear-gradient(135deg, rgba(99, 102, 241, 0.05), rgba(139, 92, 246, 0.05));
        border: 1px solid rgba(99, 102, 241, 0.2);
        border-radius: var(--radius-sm);
        font-size: 0.875rem;
        color: var(--text-secondary);
        line-height: 1.5;
    }

    .review-feedback strong {
        color: var(--accent-primary);
    }

    [data-theme="dark"] .review-feedback {
        background: linear-gradient(135deg, rgba(99, 102, 241, 0.1), rgba(139, 92, 246, 0.1));
        border-color: rgba(99, 102, 241, 0.3);
    }

    /* Not Answered Alert */
    .review-not-answered-alert {
        display: flex;
        align-items: center;
        gap: var(--space-2);
        padding: var(--space-3);
        margin-bottom: var(--space-3);
        background: var(--warning-light, rgba(245, 158, 11, 0.1));
        border: 1px solid var(--warning, #f59e0b);
        border-radius: var(--radius-sm);
        font-size: 0.875rem;
        font-weight: 500;
        color: var(--warning-dark, #b45309);
    }

    .review-not-answered-alert svg {
        flex-shrink: 0;
        color: var(--warning, #f59e0b);
    }

    /* Solution Section */
    .review-solution-section {
        margin-top: var(--space-4);
        padding: var(--space-4);
        background: var(--success-light, rgba(16, 185, 129, 0.1));
        border: 1px solid var(--success, #10b981);
        border-radius: var(--radius-md);
    }

    [data-theme="dark"] .review-solution-section {
        background: rgba(16, 185, 129, 0.12);
        border-color: rgba(16, 185, 129, 0.4);
    }

    .review-solution-section h4 {
        display: flex;
        align-items: center;
        gap: var(--space-2);
        margin: 0 0 var(--space-3) 0;
        font-size: 0.9rem;
        font-weight: 700;
        color: var(--success-dark, #065f46);
    }

    [data-theme="dark"] .review-solution-section h4 {
        color: var(--success, #10b981);
    }

    .review-solution-steps {
        margin: 0;
        padding-left: var(--space-6);
        color: var(--text-primary);
        font-size: 0.875rem;
        line-height: 1.7;
    }

    [data-theme="dark"] .review-solution-steps {
        color: var(--text-primary);
    }

    .review-solution-steps li {
        margin-bottom: var(--space-2);
    }

    /* Sub-questions */
    .review-sub-question {
        margin-bottom: var(--space-4);
        padding-bottom: var(--space-4);
        border-bottom: 1px solid var(--border);
    }

    .review-sub-question:last-child {
        border-bottom: none;
        margin-bottom: 0;
        padding-bottom: 0;
    }

    .review-sub-question h5 {
        font-size: 0.875rem;
        font-weight: 600;
        color: var(--text-primary);
        margin: 0 0 var(--space-2) 0;
    }

    /* Ensure feedback styling applies inside sub-questions */
    .review-sub-question .review-feedback {
        margin-top: var(--space-3);
        padding: var(--space-3);
        background: linear-gradient(135deg, rgba(99, 102, 241, 0.05), rgba(139, 92, 246, 0.05));
        border: 1px solid rgba(99, 102, 241, 0.2);
        border-radius: var(--radius-sm);
        font-size: 0.875rem;
        color: var(--text-secondary);
        line-height: 1.5;
    }

    .review-sub-question .review-feedback strong {
        color: var(--accent-primary);
    }

    [data-theme="dark"] .review-sub-question .review-feedback {
        background: linear-gradient(135deg, rgba(99, 102, 241, 0.1), rgba(139, 92, 246, 0.1));
        border-color: rgba(99, 102, 241, 0.3);
        color: var(--text-primary);
    }

    /* Ensure correct answer is visible in sub-questions */
    .review-sub-question .review-correct-answer {
        margin-top: var(--space-2);
    }

    .review-sub-question .review-correct-answer .review-answer-label {
        color: var(--success-dark, #065f46);
    }

    [data-theme="dark"] .review-sub-question .review-correct-answer .review-answer-label {
        color: var(--success, #10b981);
    }

    /* Responsive */
    @media (max-width: 768px) {
        .review-header-card {
            flex-direction: column;
            text-align: center;
        }

        .review-score-circle {
            order: -1;
        }

        .review-meta {
            justify-content: center;
        }

        .review-summary-bar {
            grid-template-columns: repeat(2, 1fr);
        }

        .review-actions {
            flex-direction: column;
            align-items: stretch;
        }

        .review-actions-left,
        .review-actions-right {
            justify-content: center;
        }

        .review-question-header {
            flex-wrap: wrap;
        }

        .review-question-status {
            margin-left: 0;
            margin-top: var(--space-2);
            width: 100%;
            justify-content: center;
        }
    }
</style>

<div class="review-container">
    <!-- Loading State -->
    <div id="review-loading" class="card" style="text-align: center; padding: var(--space-8);">
        <div class="loading-spinner" style="margin: 0 auto var(--space-4);"></div>
        <p style="color: var(--text-muted);">Loading your test review...</p>
    </div>

    <!-- Error State -->
    <div id="review-error" class="card" style="display: none; text-align: center; padding: var(--space-8);">
        <p style="color: var(--error); margin-bottom: var(--space-4);">Failed to load test review.</p>
        <a href="<%=request.getContextPath()%>/exams/dashboard.jsp" class="btn btn-primary">Go to Dashboard</a>
    </div>

    <!-- Ad: Header Banner (responsive - 728x90 desktop / 336x336 mobile) -->
    <div id="review-ad-header" style="display: none;">
        <%@ include file="../../components/ad-leaderboard.jsp" %>
    </div>

    <!-- Review Content -->
    <div id="review-content" style="display: none;"></div>

    <!-- Ad: Footer Banner (responsive - 728x90 desktop / 336x336 mobile) -->
    <div id="review-ad-footer" style="display: none; margin-top: var(--space-6);">
        <!-- Second leaderboard ad slot for footer - matching index.jsp pattern -->
        <div class="ad-slot" style="margin: var(--space-6) auto; text-align: center; max-width: 728px; min-height: 90px;">
            <!-- Note: Uses refresh pattern since exam_leaderboard slot is already defined -->
            <script type="text/javascript">
                // Trigger ad refresh when footer comes into view
                if (typeof inView !== 'undefined') {
                    inView('#review-ad-footer').once('enter', function() {
                        if (typeof googletag !== 'undefined' && typeof stpd !== 'undefined') {
                            try {
                                if (typeof stpd.refreshAd === 'function') {
                                    stpd.refreshAd('exam_leaderboard');
                                } else if (stpd.que) {
                                    // Queue the call if SetupAds is still loading
                                    stpd.que.push(function() {
                                        if (typeof stpd.refreshAd === 'function') {
                                            stpd.refreshAd('exam_leaderboard');
                                        }
                                    });
                                }
                            } catch(e) {
                                console.debug('Ad refresh error (expected if ad blocker active):', e);
                            }
                        }
                    });
                }
            </script>
        </div>
    </div>
</div>

<!-- Toast Container -->
<div id="toast-container"></div>

<!-- Scripts -->
<script src="<%=request.getContextPath()%>/exams/js/exams-toast.js"></script>
<script src="<%=request.getContextPath()%>/exams/js/exams-api.js"></script>

<script>
    // Configuration
    const API_BASE = '<%=request.getContextPath()%>/CFExamMarkerFunctionality';
    const CONTEXT_PATH = '<%=request.getContextPath()%>';
    const ATTEMPT_ID = '<%= attemptIdParam %>';
    const LOGGED_IN_USER_ID = '<%= loggedInUserId %>';

    // Initialize API
    ExamAPI.setApiBase(API_BASE);

    // Review state
    let attemptData = null;
    let questionsData = null;
    let setData = null;

    /**
     * Load review data
     */
    async function loadReview() {
        try {
            // Load attempt details
            const attemptResponse = await ExamAPI.getAttempt(ATTEMPT_ID);
            if (!attemptResponse.success) {
                throw new Error('Failed to load attempt details');
            }
            attemptData = attemptResponse.attempt;

            // Verify the attempt belongs to the logged-in user
            if (attemptData.user_id && attemptData.user_id !== LOGGED_IN_USER_ID) {
                console.error('Unauthorized: Attempt does not belong to this user');
                document.getElementById('review-loading').style.display = 'none';
                document.getElementById('review-error').innerHTML = `
                    <p style="color: var(--error); margin-bottom: var(--space-4);">
                        <strong>Access Denied</strong><br>
                        This test attempt does not belong to your account.
                    </p>
                    <a href="${CONTEXT_PATH}/exams/dashboard.jsp" class="btn btn-primary">Go to Dashboard</a>
                `;
                document.getElementById('review-error').style.display = 'block';
                return;
            }

            // Load questions
            const questionsResponse = await ExamAPI.getQuestions(attemptData.set_id);
            if (!questionsResponse.success) {
                throw new Error('Failed to load questions');
            }
            questionsData = questionsResponse.questions;

            // Load set details
            const setResponse = await ExamAPI.getSet(attemptData.set_id);
            if (!setResponse.success) {
                throw new Error('Failed to load set details');
            }
            setData = setResponse.set;

            // Track review view
            if (typeof trackReviewView === 'function') {
                trackReviewView(
                    ATTEMPT_ID,
                    attemptData.set_id,
                    attemptData.total_marks_obtained || 0,
                    attemptData.percentage || 0
                );
            }

            // Render review
            renderReview();
        } catch (error) {
            console.error('Failed to load review:', error);
            document.getElementById('review-loading').style.display = 'none';
            document.getElementById('review-error').style.display = 'block';
            if (window.ExamToast) {
                ExamToast.error('Failed to load test review. Please try again.');
            }
        }
    }

    /**
     * Render review interface
     */
    function renderReview() {
        const loadingEl = document.getElementById('review-loading');
        const contentEl = document.getElementById('review-content');
        const errorEl = document.getElementById('review-error');
        const headerAdEl = document.getElementById('review-ad-header');
        const footerAdEl = document.getElementById('review-ad-footer');

        loadingEl.style.display = 'none';
        errorEl.style.display = 'none';
        contentEl.style.display = 'block';

        // Show ads when content loads successfully
        if (headerAdEl) headerAdEl.style.display = 'block';
        if (footerAdEl) footerAdEl.style.display = 'block';

        // Build answers map
        const answersMap = {};
        if (attemptData.answers) {
            attemptData.answers.forEach(answer => {
                const key = answer.sub_part ? `${answer.question_id}_${answer.sub_part}` : answer.question_id;
                answersMap[key] = answer.answer_text;
            });
        }

        // Build evaluations map
        const evaluationsMap = {};
        if (attemptData.evaluations) {
            attemptData.evaluations.forEach(eval => {
                const key = eval.sub_part ? `${eval.question_id}_${eval.sub_part}` : eval.question_id;
                evaluationsMap[key] = eval;
            });
        }

        // Calculate statistics
        const totalMarks = attemptData.total_marks_possible || setData.total_marks || 0;
        const obtainedMarks = attemptData.total_marks_obtained || 0;
        const percentage = totalMarks > 0 ? Math.round((obtainedMarks / totalMarks) * 100) : 0;

        // Count question stats
        let correctCount = 0;
        let incorrectCount = 0;
        let unansweredCount = 0;

        questionsData.forEach(question => {
            const questionId = question.id || question.question_id;
            const questionType = question.type || 'MCQ';

            if (questionType === 'CaseStudy' && question.sub_questions) {
                question.sub_questions.forEach(subQ => {
                    const subKey = `${questionId}_${subQ.part}`;
                    const status = getQuestionStatus(subKey, answersMap, evaluationsMap);
                    if (status === 'correct') correctCount++;
                    else if (status === 'incorrect') incorrectCount++;
                    else unansweredCount++;
                });
            } else {
                const status = getQuestionStatus(questionId, answersMap, evaluationsMap);
                if (status === 'correct') correctCount++;
                else if (status === 'incorrect') incorrectCount++;
                else unansweredCount++;
            }
        });

        // Format date
        const date = new Date(attemptData.started_at);
        const dateStr = date.toLocaleDateString('en-US', {
            month: 'short',
            day: 'numeric',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });

        const timeSpent = attemptData.time_spent_seconds
            ? Math.floor(attemptData.time_spent_seconds / 60) + ' min'
            : '--';

        contentEl.innerHTML = `
            <!-- Header Card -->
            <div class="review-header-card">
                <div class="review-header-content">
                    <h1 class="review-title">Test Review</h1>
                    <p class="review-subtitle">${setData.name || 'Practice Test'}</p>
                    <div class="review-meta">
                        <span class="review-meta-item">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                <line x1="3" y1="10" x2="21" y2="10"></line>
                            </svg>
                            ${dateStr}
                        </span>
                        <span class="review-meta-item">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="12 6 12 12 16 14"></polyline>
                            </svg>
                            ${timeSpent}
                        </span>
                    </div>
                </div>
                <div class="review-score-circle">
                    <div class="review-score-value">${percentage}%</div>
                    <div class="review-score-label">${obtainedMarks}/${totalMarks}</div>
                </div>
            </div>

            <!-- Summary Stats -->
            <div class="review-summary-bar">
                <div class="summary-stat">
                    <div class="summary-stat-value">${questionsData.length}</div>
                    <div class="summary-stat-label">Total Questions</div>
                </div>
                <div class="summary-stat">
                    <div class="summary-stat-value correct">${correctCount}</div>
                    <div class="summary-stat-label">Correct</div>
                </div>
                <div class="summary-stat">
                    <div class="summary-stat-value incorrect">${incorrectCount}</div>
                    <div class="summary-stat-label">Incorrect</div>
                </div>
                <div class="summary-stat">
                    <div class="summary-stat-value unanswered">${unansweredCount}</div>
                    <div class="summary-stat-label">Unanswered</div>
                </div>
            </div>

            <!-- Actions -->
            <div class="review-actions">
                <div class="review-actions-left">
                    <a href="${CONTEXT_PATH}/exams/dashboard.jsp" class="btn btn-secondary btn-sm">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M19 12H5M12 19l-7-7 7-7"></path>
                        </svg>
                        Dashboard
                    </a>
                    <a href="${CONTEXT_PATH}/exams/cbse-board/mathematics/" class="btn btn-primary btn-sm">
                        Try Another Test
                    </a>
                </div>
                <div class="review-actions-right">
                    <button class="btn btn-ghost btn-sm" onclick="expandAll()">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="15 3 21 3 21 9"></polyline>
                            <polyline points="9 21 3 21 3 15"></polyline>
                            <line x1="21" y1="3" x2="14" y2="10"></line>
                            <line x1="3" y1="21" x2="10" y2="14"></line>
                        </svg>
                        Expand All
                    </button>
                    <button class="btn btn-ghost btn-sm" onclick="collapseAll()">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="4 14 10 14 10 20"></polyline>
                            <polyline points="20 10 14 10 14 4"></polyline>
                            <line x1="14" y1="10" x2="21" y2="3"></line>
                            <line x1="3" y1="21" x2="10" y2="14"></line>
                        </svg>
                        Collapse All
                    </button>
                </div>
            </div>

            <!-- Questions -->
            <div class="review-questions">
                ${questionsData.map((question, index) => renderQuestionReview(question, index + 1, answersMap, evaluationsMap)).join('')}
            </div>
        `;

        // Render MathJax
        if (window.MathJax && window.MathJax.typesetPromise) {
            window.MathJax.typesetPromise([contentEl]).catch(err => {
                console.error('MathJax rendering error:', err);
            });
        }
    }

    /**
     * Get question status (correct, incorrect, unanswered)
     */
    function getQuestionStatus(key, answersMap, evaluationsMap) {
        const userAnswer = answersMap[key];
        const evaluation = evaluationsMap[key];

        if (!userAnswer || userAnswer.trim() === '') {
            return 'unanswered';
        }

        if (evaluation) {
            return evaluation.marks_awarded === evaluation.max_marks ? 'correct' : 'incorrect';
        }

        return 'unanswered';
    }

    /**
     * Render single question review
     */
    function renderQuestionReview(question, questionNum, answersMap, evaluationsMap) {
        const questionId = question.id || question.question_id;
        const questionText = question.question?.text_plain || question.question_text || '';
        const questionLatex = question.question?.text_latex || question.question_latex || '';
        const hasDiagram = question.question?.has_diagram || question.has_diagram || false;
        const diagram = question.question?.visual_diagram || question.visual_diagram || null;
        const questionType = question.type || 'MCQ';
        const marks = question.marks || 0;

        // Get status for the question
        const userAnswer = answersMap[questionId] || null;
        const evaluation = evaluationsMap[questionId] || null;

        let status = 'unanswered';
        let statusLabel = 'Not Answered';

        if (questionType === 'CaseStudy') {
            // For case study, determine overall status
            let hasAnswer = false;
            let allCorrect = true;
            if (question.sub_questions) {
                question.sub_questions.forEach(subQ => {
                    const subKey = `${questionId}_${subQ.part}`;
                    if (answersMap[subKey]) hasAnswer = true;
                    const subEval = evaluationsMap[subKey];
                    if (subEval && subEval.marks_awarded !== subEval.max_marks) {
                        allCorrect = false;
                    }
                });
            }
            if (hasAnswer) {
                status = allCorrect ? 'correct' : 'incorrect';
                statusLabel = allCorrect ? 'All Correct' : 'Partial/Incorrect';
            }
        } else {
            if (userAnswer && userAnswer.trim() !== '') {
                if (evaluation) {
                    if (evaluation.marks_awarded === evaluation.max_marks) {
                        status = 'correct';
                        statusLabel = 'Correct';
                    } else {
                        status = 'incorrect';
                        statusLabel = 'Incorrect';
                    }
                } else {
                    status = 'incorrect';
                    statusLabel = 'Answered';
                }
            }
        }

        // Render answer section based on type
        let answerSection = '';
        let solutionSection = '';

        if (questionType === 'MCQ' || questionType === 'Assertion-Reason') {
            answerSection = renderMCQAnswer(question, userAnswer, evaluation);
        } else if (questionType === 'CaseStudy') {
            answerSection = renderCaseStudyAnswer(question, questionId, answersMap, evaluationsMap);
        } else {
            answerSection = renderTextAnswer(question, userAnswer, evaluation);
        }

        // Solution section
        if (question.solution && question.solution.steps && question.solution.steps.length > 0) {
            solutionSection = `
                <div class="review-solution-section">
                    <h4>
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"></circle>
                            <path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"></path>
                            <line x1="12" y1="17" x2="12.01" y2="17"></line>
                        </svg>
                        Solution
                    </h4>
                    <ol class="review-solution-steps">
                        ${question.solution.steps.map(step => `<li>${step}</li>`).join('')}
                    </ol>
                </div>
            `;
        }

        return `
            <div class="review-question-card ${status}" data-question-id="${questionId}">
                <div class="review-question-header" onclick="toggleQuestion(this)">
                    <svg class="collapse-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <polyline points="9 18 15 12 9 6"></polyline>
                    </svg>
                    <span class="review-question-number">Q${questionNum}</span>
                    <span class="review-question-type">${questionType}</span>
                    <span class="review-question-status ${status}">${statusLabel}</span>
                    <span class="review-question-marks">${marks} marks</span>
                </div>
                <div class="review-question-content">
                    <div class="review-question-text">
                        ${questionLatex ? `<div class="math-content">${questionLatex}</div>` : ''}
                        ${questionText && !questionLatex ? `<p>${questionText}</p>` : ''}
                    </div>
                    ${hasDiagram && diagram ? `
                        <div class="review-question-diagram">
                            ${diagram.svg_code || diagram || ''}
                        </div>
                    ` : ''}
                    ${answerSection}
                    ${solutionSection}
                </div>
            </div>
        `;
    }

    /**
     * Render MCQ answer
     */
    function renderMCQAnswer(question, userAnswer, evaluation) {
        const options = question.options || [];
        const correctOption = question.solution?.answer?.correct_option || '';
        const didNotAnswer = !userAnswer || userAnswer.trim() === '';

        // Show "Not Answered" alert if user didn't select any option
        const notAnsweredAlert = didNotAnswer ? `
            <div class="review-not-answered-alert">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="12" y1="8" x2="12" y2="12"></line>
                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                </svg>
                You did not answer this question
            </div>
        ` : '';

        return `
            <div class="review-answer-section">
                <h4>Answer Options</h4>
                ${notAnsweredAlert}
                ${options.map(option => {
                    const optionId = option.id || option.option_id;
                    const optionText = option.text || option.text_plain || '';
                    const isUserChoice = userAnswer === optionId;
                    const isCorrectOption = optionId === correctOption;

                    let optionClass = 'review-option';
                    let markHtml = '';

                    if (isUserChoice && isCorrectOption) {
                        optionClass += ' correct';
                        markHtml = '<span class="review-option-mark your-correct">Your Answer (Correct)</span>';
                    } else if (isUserChoice && !isCorrectOption) {
                        optionClass += ' incorrect';
                        markHtml = '<span class="review-option-mark your-incorrect">Your Answer</span>';
                    } else if (isCorrectOption) {
                        optionClass += ' correct-not-selected';
                        markHtml = '<span class="review-option-mark correct-answer">Correct Answer</span>';
                    }

                    return `
                        <div class="${optionClass}">
                            ${markHtml}
                            <div class="review-option-content">
                                <strong>${optionId}.</strong> ${optionText}
                            </div>
                        </div>
                    `;
                }).join('')}
                ${evaluation ? `
                    <div class="review-marks-awarded">
                        Marks: ${evaluation.marks_awarded}/${evaluation.max_marks}
                    </div>
                ` : (didNotAnswer ? `
                    <div class="review-marks-awarded" style="color: var(--text-muted);">
                        Marks: 0/${question.marks || 0}
                    </div>
                ` : '')}
            </div>
        `;
    }

    /**
     * Render Case Study answer
     */
    function renderCaseStudyAnswer(question, questionId, answersMap, evaluationsMap) {
        const subQuestions = question.sub_questions || [];

        return `
            <div class="review-answer-section">
                <h4>Sub-Questions</h4>
                ${subQuestions.map(subQ => {
                    const subKey = `${questionId}_${subQ.part}`;
                    const subUserAnswer = answersMap[subKey] || null;
                    const subEval = evaluationsMap[subKey] || null;
                    const subCorrectAnswer = subQ.answer?.correct_answer_plain || subQ.solution?.answer || '';
                    const didNotAnswer = !subUserAnswer || subUserAnswer.trim() === '';

                    return `
                        <div class="review-sub-question">
                            <h5>Part ${subQ.part} (${subQ.marks || 0} marks)</h5>
                            ${didNotAnswer ? `
                                <div class="review-not-answered-alert" style="margin-bottom: var(--space-2);">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <line x1="12" y1="8" x2="12" y2="12"></line>
                                        <line x1="12" y1="16" x2="12.01" y2="16"></line>
                                    </svg>
                                    Not answered
                                </div>
                            ` : `
                                <div class="review-answer-box">
                                    <div class="review-answer-label">Your Answer</div>
                                    <div class="review-answer-value">${subUserAnswer}</div>
                                </div>
                            `}
                            ${subCorrectAnswer ? `
                                <div class="review-correct-answer">
                                    <div class="review-answer-label">Correct Answer</div>
                                    <div>${subCorrectAnswer}</div>
                                </div>
                            ` : ''}
                            ${subEval ? `
                                <div class="review-marks-awarded">
                                    Marks: ${subEval.marks_awarded}/${subEval.max_marks}
                                    ${subEval.confidence ? `<span class="review-confidence">(${Math.round(subEval.confidence * 100)}% confidence)</span>` : ''}
                                </div>
                                ${subEval.feedback ? `
                                    <div class="review-feedback">
                                        <strong>AI Feedback:</strong> ${subEval.feedback}
                                    </div>
                                ` : ''}
                            ` : (didNotAnswer ? `
                                <div class="review-marks-awarded" style="color: var(--text-muted);">
                                    Marks: 0/${subQ.marks || 0}
                                </div>
                            ` : '')}
                        </div>
                    `;
                }).join('')}
            </div>
        `;
    }

    /**
     * Render text answer (VSA, SA, LA)
     */
    function renderTextAnswer(question, userAnswer, evaluation) {
        const correctAnswer = question.solution?.answer || '';
        const didNotAnswer = !userAnswer || userAnswer.trim() === '';

        // Show "Not Answered" alert if user didn't provide an answer
        const notAnsweredAlert = didNotAnswer ? `
            <div class="review-not-answered-alert">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="12" y1="8" x2="12" y2="12"></line>
                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                </svg>
                You did not answer this question
            </div>
        ` : '';

        return `
            <div class="review-answer-section">
                <h4>Your Response</h4>
                ${notAnsweredAlert}
                <div class="review-answer-box">
                    <div class="review-answer-label">Your Answer</div>
                    <div class="review-answer-value ${didNotAnswer ? 'not-answered' : ''}">${userAnswer || 'Not answered'}</div>
                </div>
                ${correctAnswer ? `
                    <div class="review-correct-answer">
                        <div class="review-answer-label">Expected Answer</div>
                        <div>${correctAnswer}</div>
                    </div>
                ` : ''}
                ${evaluation ? `
                    <div class="review-marks-awarded">
                        Marks: ${evaluation.marks_awarded}/${evaluation.max_marks}
                        ${evaluation.confidence ? `<span class="review-confidence">(${Math.round(evaluation.confidence * 100)}% confidence)</span>` : ''}
                    </div>
                    ${evaluation.feedback ? `
                        <div class="review-feedback">
                            <strong>AI Feedback:</strong> ${evaluation.feedback}
                        </div>
                    ` : ''}
                ` : (didNotAnswer ? `
                    <div class="review-marks-awarded" style="color: var(--text-muted);">
                        Marks: 0/${question.marks || 0}
                    </div>
                ` : '')}
            </div>
        `;
    }

    /**
     * Toggle question expand/collapse
     */
    function toggleQuestion(headerEl) {
        const card = headerEl.closest('.review-question-card');
        card.classList.toggle('expanded');
    }

    /**
     * Expand all questions
     */
    function expandAll() {
        document.querySelectorAll('.review-question-card').forEach(card => {
            card.classList.add('expanded');
        });
    }

    /**
     * Collapse all questions
     */
    function collapseAll() {
        document.querySelectorAll('.review-question-card').forEach(card => {
            card.classList.remove('expanded');
        });
    }

    // Initialize on page load
    document.addEventListener('DOMContentLoaded', loadReview);
</script>

<%@ include file="../../components/footer.jsp" %>
