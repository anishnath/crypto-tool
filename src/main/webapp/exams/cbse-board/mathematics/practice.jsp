<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String setParam = request.getParameter("set");
    if (setParam == null || setParam.isEmpty()) {
        setParam = "set-01_full";
    }
    
    // Map old format to API format if needed
    // set-01_full -> cbse-10-math-full-01
    String setId = setParam;
    if (setParam.startsWith("set-") && setParam.contains("_")) {
        // Convert old format to new format
        String number = setParam.replace("set-", "").replace("_full", "");
        try {
            int num = Integer.parseInt(number);
            setId = "cbse-10-math-full-" + String.format("%02d", num);
        } catch (NumberFormatException e) {
            setId = setParam; // Keep original if parsing fails
        }
    }
    
    // Check if user is logged in
    String userSub = null;
    String userEmail = null;
    boolean isLoggedIn = false;
    
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj != null) {
        userSub = (String) sessionObj.getAttribute("oauth_user_sub");
        userEmail = (String) sessionObj.getAttribute("oauth_user_email");
        // User is logged in if either userSub OR userEmail exists (some OAuth flows may only set email)
        isLoggedIn = (userSub != null && !userSub.isEmpty()) || (userEmail != null && !userEmail.isEmpty());
    }
    
    // Build redirect URL from current request
    String currentUrl = request.getRequestURI();
    String queryString = request.getQueryString();
    if (queryString != null && !queryString.isEmpty()) {
        currentUrl += "?" + queryString;
    }
    String redirectPath = currentUrl.replace(request.getContextPath(), "");
    if (!redirectPath.startsWith("/")) {
        redirectPath = "/" + redirectPath;
    }
    
    request.setAttribute("pageTitle", "Practice Test - CBSE Mathematics");
    request.setAttribute("pageDescription", "Take the CBSE Class 10 Mathematics practice test. Timed exam with instant feedback and detailed solutions.");
    request.setAttribute("includePracticeCSS", "true");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= request.getAttribute("pageTitle") %> | 8gwifi.org</title>
    <meta name="description" content="<%= request.getAttribute("pageDescription") %>">

    <!-- Favicon -->
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">

    <!-- Fonts -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">

    <!-- Exam Platform CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/exams/css/exams.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/exams/css/practice.css">

    <!-- Theme initialization -->
    <script>
        (function() {
            var theme = localStorage.getItem('exam-theme');
            if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
                document.documentElement.setAttribute('data-theme', 'dark');
            }
        })();
    </script>

    <!-- MathJax -->
    <script>
        window.MathJax = {
            tex: {
                inlineMath: [['$', '$'], ['\\(', '\\)']],
                displayMath: [['$$', '$$'], ['\\[', '\\]']]
            },
            chtml: {
                scale: 1,
                minScale: 0.5
            },
            startup: {
                typeset: false  // Disable auto-typeset - we call it manually after content loads
            }
        };
    </script>
    <script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js"></script>

    <!-- Ad Scripts -->
    <%@ include file="../../components/ads-head.jsp" %>
</head>
<body class="practice-layout">
    <!-- Minimal Header -->
    <header class="exam-header">
        <div class="container" style="display: flex; align-items: center; justify-content: space-between;">
            <div class="header-left" style="display: flex; align-items: center; gap: var(--space-3);">
                <a href="<%=request.getContextPath()%>/exams/cbse-board/mathematics/" class="btn btn-ghost btn-sm" title="Exit Practice">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <polyline points="15 18 9 12 15 6"></polyline>
                    </svg>
                </a>
                <a href="<%=request.getContextPath()%>/exams/" class="logo">
                    <span class="logo-icon">EP</span>
                    <span class="logo-text">ExamPrep</span>
                </a>
                <span class="practice-title" id="set-title" style="margin-left: var(--space-3); color: var(--text-secondary); font-size: var(--text-sm);">Loading...</span>
            </div>

            <div class="practice-header-center">
                <div class="practice-timer" id="timer-container">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"></circle>
                        <polyline points="12 6 12 12 16 14"></polyline>
                    </svg>
                    <span id="timer-display">--:--</span>
                </div>
            </div>

            <div class="header-right" style="display: flex; align-items: center; gap: var(--space-3);">
                <%
                    // userSub, userEmail, isLoggedIn, and redirectPath are already declared at the top of the file
                    // Just use the existing redirectPath variable
                %>
                
                <% if (isLoggedIn) { %>
                    <!-- Logged in state - show user info -->
                    <div class="user-menu" style="display: flex; align-items: center; gap: var(--space-3);">
                        <span class="user-greeting" style="font-size: var(--text-sm); color: var(--text-secondary);">
                            Hello, <%= userEmail != null ? userEmail.split("@")[0] : (userSub != null ? "User" : "User") %>
                        </span>
                        <a href="<%=request.getContextPath()%>/GoogleOAuthFunctionality?action=logout&redirect_path=<%=java.net.URLEncoder.encode(redirectPath, "UTF-8")%>" class="btn btn-ghost btn-sm" title="Logout">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                                <polyline points="16 17 21 12 16 7"></polyline>
                                <line x1="21" y1="12" x2="9" y2="12"></line>
                            </svg>
                            <span class="hide-mobile">Logout</span>
                        </a>
                    </div>
                <% } else { %>
                    <!-- Not logged in state -->
                    <a href="<%=request.getContextPath()%>/GoogleOAuthFunctionality?action=login&redirect_path=<%=java.net.URLEncoder.encode(redirectPath, "UTF-8")%>" class="btn btn-primary btn-sm" title="Login with Google">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M18 21h-10a2 2 0 0 1-2-2v-14a2 2 0 0 1 2-2h7l5 5v11a2 2 0 0 1-2 2z"></path>
                            <polyline points="12 11 12 17"></polyline>
                            <line x1="9" y1="14" x2="15" y2="14"></line>
                        </svg>
                        <span class="hide-mobile">Login</span>
                    </a>
                <% } %>
                
                <button class="theme-toggle" type="button" id="theme-toggle-btn" aria-label="Toggle theme">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="theme-icon-sun">
                        <circle cx="12" cy="12" r="5"></circle>
                        <line x1="12" y1="1" x2="12" y2="3"></line>
                        <line x1="12" y1="21" x2="12" y2="23"></line>
                        <line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line>
                        <line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line>
                        <line x1="1" y1="12" x2="3" y2="12"></line>
                        <line x1="21" y1="12" x2="23" y2="12"></line>
                        <line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line>
                        <line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line>
                    </svg>
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="theme-icon-moon">
                        <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path>
                    </svg>
                </button>
                <button class="btn btn-success btn-sm" onclick="handleSubmit()">
                    Submit
                </button>
            </div>
        </div>
    </header>

    <!-- Main Practice Area -->
    <div class="practice-main" id="practice-main">
        <!-- Left Navigator (Desktop) -->
        <aside class="practice-navigator">
            <h3 class="navigator-title">Questions</h3>
            <div class="navigator-grid" id="navigator-grid">
                <!-- Populated by JS -->
            </div>
            <div class="navigator-legend">
                <div class="legend-item">
                    <div class="legend-dot current"></div>
                    <span>Current</span>
                </div>
                <div class="legend-item">
                    <div class="legend-dot answered"></div>
                    <span>Answered</span>
                </div>
                <div class="legend-item">
                    <div class="legend-dot marked"></div>
                    <span>Marked</span>
                </div>
                <div class="legend-item">
                    <div class="legend-dot unanswered"></div>
                    <span>Unanswered</span>
                </div>
            </div>
        </aside>

        <!-- Question Content -->
        <div class="practice-content">
            <!-- Ad: Top Banner -->
            <div class="ad-slot" id="practice-ad-top" style="margin-bottom: var(--space-4); min-height: 90px;">
                <%@ include file="../../components/ad-leaderboard.jsp" %>
            </div>

            <!-- Question Container -->
            <div id="question-container">
                <!-- Loading State -->
                <div class="card" style="text-align: center; padding: var(--space-12);">
                    <div class="loading-spinner" style="margin: 0 auto var(--space-4);"></div>
                    <p class="text-muted">Loading practice set...</p>
                </div>
            </div>
        </div>

        <!-- Right Progress Panel (Desktop) -->
        <aside class="practice-progress">
            <div class="progress-section">
                <h3 class="progress-title">Progress</h3>
                <div id="progress-stats">
                    <!-- Populated by JS -->
                </div>
            </div>

            <div class="progress-section">
                <button class="btn btn-success btn-block btn-lg" onclick="handleSubmit()">
                    Submit Test
                </button>
            </div>

            <!-- Sidebar Ad -->
            <%@ include file="../../components/ad-sidebar.jsp" %>
        </aside>
    </div>

    <!-- Mobile Submit Button (always visible on mobile) -->
    <button class="mobile-submit-btn" id="mobile-submit-btn" onclick="handleSubmit()">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <polyline points="9 11 12 14 22 4"></polyline>
            <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path>
        </svg>
        Submit
    </button>

    <!-- Mobile Navigator Toggle -->
    <button class="mobile-nav-toggle" id="mobile-nav-toggle" aria-label="Open question navigator">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <rect x="3" y="3" width="7" height="7"></rect>
            <rect x="14" y="3" width="7" height="7"></rect>
            <rect x="14" y="14" width="7" height="7"></rect>
            <rect x="3" y="14" width="7" height="7"></rect>
        </svg>
    </button>

    <!-- Mobile Navigator (Bottom Sheet) -->
    <div class="overlay" id="navigator-overlay"></div>
    <div class="mobile-navigator" id="mobile-navigator">
        <div class="mobile-navigator-header">
            <span class="mobile-navigator-title">Questions</span>
            <button class="btn btn-ghost btn-sm" id="mobile-nav-close" aria-label="Close navigator">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="18" y1="6" x2="6" y2="18"></line>
                    <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
            </button>
        </div>
        <div class="mobile-navigator-body">
            <div style="margin-bottom: var(--space-4);">
                <div id="mobile-progress-bar" style="display: flex; align-items: center; gap: var(--space-3);">
                    <span class="text-sm text-muted">Progress:</span>
                    <div class="progress-bar" style="flex: 1;">
                        <div class="progress-fill" id="mobile-progress-fill" style="width: 0%;"></div>
                    </div>
                    <span class="text-sm" id="mobile-progress-text">0/0</span>
                </div>
            </div>
            <div class="mobile-navigator-grid" id="mobile-navigator-grid">
                <!-- Populated by JS -->
            </div>
        </div>
        <div class="mobile-navigator-footer">
            <button class="btn btn-success btn-block" onclick="handleSubmit()">
                Submit Test
            </button>
        </div>
    </div>

    <!-- Core JavaScript -->
    <script src="<%=request.getContextPath()%>/exams/js/exams-toast.js"></script>
    <script src="<%=request.getContextPath()%>/exams/js/exams-api.js"></script>
    <script src="<%=request.getContextPath()%>/exams/js/exams-core.js"></script>
    <script src="<%=request.getContextPath()%>/exams/js/exams-practice.js"></script>

    <!-- Practice Initialization -->
    <script>
        // Configuration
        const SET_ID = '<%= setId %>'; // API format: "cbse-10-math-full-01"
        const API_BASE = '<%=request.getContextPath()%>/CFExamMarkerFunctionality';
        const IS_LOGGED_IN = <%= isLoggedIn %>; // Check login status from server
        console.log('Page load - IS_LOGGED_IN:', IS_LOGGED_IN, 'userSub:', '<%= userSub != null ? userSub : "null" %>', 'userEmail:', '<%= userEmail != null ? userEmail : "null" %>');
        const CONTEXT_PATH = '<%=request.getContextPath()%>';
        
        // Duration will be loaded from API
        let DURATION_MINUTES = 90; // Default, will be overridden by API response

        // State
        let practiceData = null;
        let attemptId = null;
        let currentAttempt = null;
        const PENDING_SUBMISSION_KEY = 'exam_pending_submission_' + SET_ID;

        // Initialize API
        ExamAPI.setApiBase(API_BASE);

        // Initialize
        document.addEventListener('DOMContentLoaded', async function() {
            try {
                // Initialize core
                ExamCore.init();

                // Get user ID from session (if available) - prefer userSub, fallback to email
                <%
                    String practiceUserId = userSub;
                    if (practiceUserId == null || practiceUserId.isEmpty()) {
                        practiceUserId = userEmail;
                    }
                %>
                let userId = '<%= practiceUserId != null ? practiceUserId : "" %>' || null;
                console.log('Practice page userId:', userId);
                
                // Check if user just logged in and has pending submission
                const pendingSubmission = localStorage.getItem(PENDING_SUBMISSION_KEY);
                if (pendingSubmission && IS_LOGGED_IN && userId) {
                    try {
                        const submissionData = JSON.parse(pendingSubmission);
                        // If this is the same attempt and set, restore answers
                        if (submissionData.attemptId && submissionData.setId === SET_ID) {
                            ExamToast.success('Welcome back! Your answers have been restored.', { duration: 3000 });
                            // Answers will be restored from API attempt below
                        }
                    } catch (error) {
                        console.warn('Failed to parse pending submission:', error);
                    }
                }

                // Load questions from API
                const questionsResponse = await ExamAPI.getQuestions(SET_ID);
                if (!questionsResponse.success || !questionsResponse.questions) {
                    throw new Error('Failed to load questions');
                }

                // Check for existing attempt from pending submission
                let shouldCreateNewAttempt = true;
                if (pendingSubmission && IS_LOGGED_IN && userId) {
                    try {
                        const submissionData = JSON.parse(pendingSubmission);
                        if (submissionData.attemptId && submissionData.setId === SET_ID) {
                            // Try to use existing attempt
                            attemptId = submissionData.attemptId;
                            shouldCreateNewAttempt = false;
                            
                            // Verify attempt exists and update with user_id if needed
                            try {
                                const existingAttempt = await ExamAPI.getAttempt(attemptId);
                                if (existingAttempt.success && existingAttempt.attempt) {
                                    // Attempt exists, use it
                                    ExamToast.info('Resuming your previous attempt.', { duration: 2000 });
                                } else {
                                    // Attempt doesn't exist, create new one
                                    shouldCreateNewAttempt = true;
                                }
                            } catch (error) {
                                // Attempt doesn't exist, create new one
                                shouldCreateNewAttempt = true;
                            }
                        }
                    } catch (error) {
                        console.warn('Failed to restore pending submission:', error);
                    }
                }
                
                // Start new attempt if needed
                if (shouldCreateNewAttempt) {
                    const attemptResponse = await ExamAPI.startAttempt(SET_ID, userId);
                    if (!attemptResponse.success) {
                        throw new Error('Failed to start attempt');
                    }
                    attemptId = attemptResponse.attempt_id;
                    
                    // Track test start
                    if (typeof trackTestStart === 'function') {
                        trackTestStart(SET_ID, attemptId, 'CBSE', '10', 'mathematics');
                    }
                }

                // Get attempt details
                currentAttempt = await ExamAPI.getAttempt(attemptId);
                if (!currentAttempt.success) {
                    throw new Error('Failed to get attempt details');
                }

                // Get set details
                const setResponse = await ExamAPI.getSet(SET_ID);
                if (!setResponse.success) {
                    throw new Error('Failed to get set details');
                }

                // Prepare practice data from API responses
                practiceData = {
                    set_id: SET_ID,
                    set_name: setResponse.set.name || 'Practice Set',
                    total_questions: questionsResponse.total || questionsResponse.questions.length,
                    total_marks: setResponse.set.total_marks || 80,
                    duration_minutes: setResponse.set.duration_minutes || 90,
                    questions: questionsResponse.questions
                };

                // Update duration from API response
                DURATION_MINUTES = practiceData.duration_minutes;

                // Load into ExamCore (no hardcoded JSON files - all data from API)
                ExamCore.loadSetData(practiceData);

                // Restore saved answers from attempt if any
                if (currentAttempt.attempt && currentAttempt.attempt.answers) {
                    currentAttempt.attempt.answers.forEach(answer => {
                        if (answer.answer_text) {
                            ExamCore.saveAnswer(answer.question_id, answer.answer_text);
                        }
                    });
                }
                
                // If user just logged in and has pending submission, restore answers from localStorage too
                if (pendingSubmission && IS_LOGGED_IN && userId) {
                    try {
                        const submissionData = JSON.parse(pendingSubmission);
                        if (submissionData.attemptId === attemptId && submissionData.answers) {
                            // Restore answers from localStorage (may have newer data)
                            Object.keys(submissionData.answers).forEach(questionId => {
                                ExamCore.saveAnswer(questionId, submissionData.answers[questionId]);
                            });
                            
                            // Save restored answers to API
                            if (Object.keys(submissionData.answers).length > 0) {
                                await ExamAPI.saveAnswers(attemptId, submissionData.answers);
                            }
                            
                            // Clear pending submission
                            localStorage.removeItem(PENDING_SUBMISSION_KEY);
                            
                            ExamToast.success('Your answers have been restored and saved.', { duration: 3000 });
                        }
                    } catch (error) {
                        console.warn('Failed to restore answers from pending submission:', error);
                    }
                }

                // Set up auto-save
                setInterval(async () => {
                    if (attemptId) {
                        try {
                            const currentState = ExamCore.getState();
                            if (!currentState.isSubmitted && Object.keys(currentState.answers).length > 0) {
                                await ExamAPI.saveAnswers(attemptId, currentState.answers);
                                console.log('Auto-saved answers');
                            }
                        } catch (error) {
                            console.warn('Auto-save failed:', error);
                            // Silent failure for auto-save - don't show toast
                        }
                    }
                }, 30000); // Auto-save every 30 seconds

                // Update title
                document.getElementById('set-title').textContent =
                    practiceData.set_name || practiceData.batch_id || 'Practice Set';

                // Initialize practice module
                ExamPractice.init({
                    showInstantFeedback: false,
                    onSubmit: handleResults
                });

                // Start timer with duration from API (not hardcoded)
                ExamPractice.startTimer(practiceData.duration_minutes, function() {
                    alert('Time is up! Your test will be submitted automatically.');
                    handleSubmit();
                });

                // Render first question
                const currentState = ExamCore.getState();
                ExamPractice.renderQuestion(
                    currentState.questions[currentState.currentQuestionIndex],
                    currentState.currentQuestionIndex,
                    currentState.questions.length
                );

                // Update mobile progress
                updateMobileProgress();

            } catch (error) {
                console.error('Failed to load practice set:', error);
                
                // Show toast notification
                ExamToast.error(
                    error.message || 'Failed to load practice set. Please try again.',
                    { duration: 5000 }
                );
                
                document.getElementById('question-container').innerHTML = `
                    <div class="card" style="text-align: center; padding: var(--space-8);">
                        <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="var(--error)" stroke-width="2" style="margin: 0 auto var(--space-4);">
                            <circle cx="12" cy="12" r="10"></circle>
                            <line x1="12" y1="8" x2="12" y2="12"></line>
                            <line x1="12" y1="16" x2="12.01" y2="16"></line>
                        </svg>
                        <h3 style="color: var(--error); margin-bottom: var(--space-2);">Failed to Load</h3>
                        <p class="text-muted">Could not load the practice set. Please try again.</p>
                        <a href="<%=request.getContextPath()%>/exams/cbse-board/mathematics/" class="btn btn-primary mt-4">
                            Back to Practice Sets
                        </a>
                    </div>
                `;
            }
        });

        // Evaluation overlay helper functions
        function showEvaluationOverlay() {
            const overlay = document.getElementById('evaluationOverlay');
            if (overlay) {
                overlay.style.display = 'flex';
                updateEvaluationProgress(0);
            }
        }

        function hideEvaluationOverlay() {
            const overlay = document.getElementById('evaluationOverlay');
            if (overlay) {
                overlay.style.display = 'none';
            }
        }

        function updateEvaluationStatus(message, progress = null) {
            const statusEl = document.getElementById('evaluationStatus');
            if (statusEl) {
                statusEl.textContent = message;
            }
            if (progress !== null) {
                updateEvaluationProgress(progress);
            }
        }

        function updateEvaluationProgress(percent) {
            const progressBar = document.getElementById('evaluationProgressBar');
            if (progressBar) {
                progressBar.style.width = percent + '%';
            }
        }

        // Handle submit
        async function handleSubmit() {
            if (!confirm('Are you sure you want to submit the test? You cannot change your answers after submission.')) {
                return;
            }

            // Check if user is logged in - verify dynamically via API call
            let isLoggedInNow = IS_LOGGED_IN;
            console.log('Initial IS_LOGGED_IN from page load:', IS_LOGGED_IN);
            try {
                // Make a quick check to verify session is still valid
                const sessionCheck = await fetch(CONTEXT_PATH + '/GoogleOAuthFunctionality?action=check_session', {
                    method: 'GET',
                    credentials: 'include',
                    cache: 'no-cache'
                });
                console.log('Session check response status:', sessionCheck.status);
                if (sessionCheck.ok) {
                    const sessionData = await sessionCheck.json();
                    console.log('Session check response:', sessionData);
                    isLoggedInNow = sessionData.logged_in === true;
                    if (!isLoggedInNow && IS_LOGGED_IN) {
                        console.warn('Session expired during test. User was logged in at page load but session is now invalid.');
                    } else if (isLoggedInNow && !IS_LOGGED_IN) {
                        console.warn('Session check shows logged in but page load showed not logged in. Session may have been created after page load.');
                    }
                } else {
                    console.warn('Session check failed with status:', sessionCheck.status);
                }
            } catch (error) {
                console.error('Session check failed:', error);
                // Fall back to page load status
                isLoggedInNow = IS_LOGGED_IN;
            }
            console.log('Final isLoggedInNow:', isLoggedInNow);

            // Check if user is logged in
            if (!isLoggedInNow) {
                // Store submission data before redirecting to login
                const submissionData = {
                    attemptId: attemptId,
                    answers: ExamCore.getState().answers,
                    setId: SET_ID,
                    timestamp: Date.now()
                };
                
                // Save to localStorage
                localStorage.setItem(PENDING_SUBMISSION_KEY, JSON.stringify(submissionData));
                
                // Save answers to API one more time before redirecting
                if (attemptId) {
                    try {
                        await ExamAPI.saveAnswers(attemptId, submissionData.answers);
                    } catch (error) {
                        console.warn('Failed to save answers before login redirect:', error);
                    }
                }
                
                // Show message and redirect to login
                ExamToast.warning('Please login to submit your test. Your answers have been saved.', {
                    duration: 3000,
                    action: 'Login',
                    onAction: () => {
                        // Remove context path from pathname to avoid duplication
                        let redirectPath = window.location.pathname;
                        // Only remove context path if it's not empty (production might be at root)
                        if (CONTEXT_PATH && CONTEXT_PATH !== '' && redirectPath.startsWith(CONTEXT_PATH)) {
                            redirectPath = redirectPath.substring(CONTEXT_PATH.length);
                        }
                        redirectPath = redirectPath + window.location.search;
                        if (!redirectPath.startsWith('/')) {
                            redirectPath = '/' + redirectPath;
                        }
                        // Build OAuth URL - handle empty context path in production
                        const oauthUrl = (CONTEXT_PATH ? CONTEXT_PATH : '') + '/GoogleOAuthFunctionality?action=login&redirect_path=' + 
                            encodeURIComponent(redirectPath);
                        window.location.href = oauthUrl;
                    }
                });
                
                // Auto-redirect after toast
                setTimeout(() => {
                    // Remove context path from pathname to avoid duplication
                    let redirectPath = window.location.pathname;
                    // Only remove context path if it's not empty (production might be at root)
                    if (CONTEXT_PATH && CONTEXT_PATH !== '' && redirectPath.startsWith(CONTEXT_PATH)) {
                        redirectPath = redirectPath.substring(CONTEXT_PATH.length);
                    }
                    redirectPath = redirectPath + window.location.search;
                    if (!redirectPath.startsWith('/')) {
                        redirectPath = '/' + redirectPath;
                    }
                    // Build OAuth URL - handle empty context path in production
                    const oauthUrl = (CONTEXT_PATH ? CONTEXT_PATH : '') + '/GoogleOAuthFunctionality?action=login&redirect_path=' + 
                        encodeURIComponent(redirectPath);
                    window.location.href = oauthUrl;
                }, 3000);
                
                return;
            }

            // Show evaluation overlay
            showEvaluationOverlay();
            updateEvaluationStatus('Saving your answers...', 10);

            try {
                const state = ExamCore.getState();

                // Save all answers before submitting
                if (attemptId) {
                    await ExamAPI.saveAnswers(attemptId, state.answers);
                }
                updateEvaluationStatus('Grading MCQ questions...', 20);

                // Calculate results for all questions (MCQ graded client-side, subjective pending API)
                const mcqResults = ExamCore.calculateResults();
                
                // Separate ALL subjective questions (SA, VSA, LA, CaseStudy) - both answered and unanswered
                const allSubjectiveQuestions = state.questions.filter(q => {
                    const isSubjective = q.type === 'SA' || q.type === 'VSA' || q.type === 'LA' || q.type === 'CaseStudy' ||
                                        (q.type && !['MCQ', 'Assertion-Reason'].includes(q.type));
                    return isSubjective;
                });
                
                // Separate subjective questions that have answers (need API grading)
                const subjectiveQuestionsWithAnswers = allSubjectiveQuestions.filter(q => {
                    const questionId = q.id || q.question_id;
                    const answer = state.answers[questionId];
                    if (!answer) return false;
                    
                    // Check if answer is not empty
                    if (typeof answer === 'string') {
                        return answer.trim() !== '';
                    } else if (typeof answer === 'object') {
                        // For case study, check if any part has answer
                        return Object.keys(answer).length > 0 && 
                               Object.values(answer).some(v => v && String(v).trim() !== '');
                    }
                    return false;
                });
                
                let subjectiveEvaluations = [];
                let subjectiveMarks = 0;
                
                // Only call API for subjective questions that have answers
                if (subjectiveQuestionsWithAnswers.length > 0) {
                    try {
                        updateEvaluationStatus(`AI is grading ${subjectiveQuestionsWithAnswers.length} subjective question(s)...`, 40);
                        
                        // Prepare data for AI grading
                        const subjectiveAnswers = {};
                        subjectiveQuestionsWithAnswers.forEach(q => {
                            const questionId = q.id || q.question_id;
                            const answer = state.answers[questionId];
                            if (answer && questionId) {
                                // For case study, flatten the answer object
                                if (q.type === 'CaseStudy' && typeof answer === 'object') {
                                    Object.keys(answer).forEach(part => {
                                        if (answer[part] && String(answer[part]).trim() !== '') {
                                            subjectiveAnswers[`${questionId}_${part}`] = String(answer[part]);
                                        }
                                    });
                                } else {
                                    subjectiveAnswers[questionId] = String(answer);
                                }
                            }
                        });
                        
                        // Call mark-exam API ONLY for subjective questions with answers
                        // Pass attemptId so evaluations are saved to database
                        const markResponse = await ExamAPI.markExam(attemptId, subjectiveAnswers, subjectiveQuestionsWithAnswers);
                        if (markResponse.success && markResponse.evaluations) {
                            subjectiveEvaluations = markResponse.evaluations;
                            subjectiveMarks = markResponse.total_marks_awarded || 0;
                            updateEvaluationStatus('AI grading completed!', 70);
                        } else {
                            throw new Error(markResponse.message || 'API grading failed');
                        }
                    } catch (error) {
                        console.warn('Failed to grade subjective questions:', error);
                        updateEvaluationStatus('AI grading failed, continuing with MCQ results...', 70);
                        // Set marks to 0 for failed API calls
                        subjectiveMarks = 0;
                    }
                } else {
                    updateEvaluationStatus('No subjective answers to grade', 70);
                }
                
                // Calculate marks for unanswered subjective questions (0 marks)
                const unansweredSubjectiveMarks = allSubjectiveQuestions
                    .filter(q => !subjectiveQuestionsWithAnswers.includes(q))
                    .reduce((sum, q) => sum + (q.marks || 0), 0);
                
                // Submit attempt to API (for record-keeping, but MCQ already graded client-side)
                updateEvaluationStatus('Finalizing your submission...', 85);
                if (attemptId) {
                    try {
                        const submitResponse = await ExamAPI.submitAttempt(attemptId);
                        if (submitResponse.success) {
                            currentAttempt = await ExamAPI.getAttempt(attemptId);
                        }
                    } catch (error) {
                        console.warn('Failed to submit attempt to API:', error);
                        // Continue with results even if API submission fails
                    }
                }
                updateEvaluationStatus('Done! Preparing results...', 100);

                // Calculate total marks - mcqResults.totalMarks already includes ALL questions
                // Ensure we have valid numbers (handle null/undefined)
                const totalMarksAll = mcqResults.totalMarks || 0; // Total marks for all questions
                const mcqMarksObtained = mcqResults.obtainedMarks || 0; // Marks from MCQ questions
                const subjectiveMarksObtained = subjectiveMarks || 0; // Marks from subjective questions (API)
                const obtainedMarksAll = mcqMarksObtained + subjectiveMarksObtained; // Total obtained marks
                
                console.log('Marks calculation:', {
                    totalMarksAll,
                    mcqMarksObtained,
                    subjectiveMarksObtained,
                    obtainedMarksAll,
                    mcqResults: mcqResults
                });
                
                // Update details with subjective evaluations and ensure all questions have marks
                const updatedDetails = mcqResults.details.map(detail => {
                    // Check if this is a subjective question
                    const question = state.questions.find(q => {
                        const qId = q.id || q.question_id;
                        return qId === detail.questionId;
                    });
                    
                    const isSubjective = question && (question.type === 'SA' || question.type === 'VSA' || 
                                                      question.type === 'LA' || question.type === 'CaseStudy' ||
                                                      (question.type && !['MCQ', 'Assertion-Reason'].includes(question.type)));
                    
                    if (isSubjective) {
                        // Check if we have API evaluation for this question
                        const evaluation = subjectiveEvaluations.find(e => {
                            // Match by question_id (might be full ID or just question part)
                            return e.question_id === detail.questionId || 
                                   e.question_id === question.id || 
                                   e.question_id === question.question_id ||
                                   detail.questionId.includes(e.question_id) ||
                                   e.question_id.includes(detail.questionId);
                        });
                        
                        if (evaluation) {
                            // API graded this question
                            return {
                                ...detail,
                                isCorrect: evaluation.marks_awarded > 0 ? true : (evaluation.marks_awarded === 0 ? false : null),
                                marksAwarded: evaluation.marks_awarded,
                                maxMarks: evaluation.max_marks || detail.marks,
                                feedback: evaluation.feedback
                            };
                        } else {
                            // Subjective question but no API evaluation (unanswered or API failed)
                            const hasAnswer = detail.userAnswer !== null && detail.userAnswer !== undefined;
                            return {
                                ...detail,
                                isCorrect: null,
                                marksAwarded: hasAnswer ? null : 0, // null = pending, 0 = no answer
                                maxMarks: detail.marks,
                                feedback: hasAnswer ? 'Grading pending...' : 'Not attempted'
                            };
                        }
                    }
                    // MCQ question - return as is
                    return detail;
                });
                
                // Combine MCQ results (client-side) with subjective results (API)
                const finalResults = {
                    total: mcqResults.total,
                    correct: mcqResults.correct,
                    incorrect: mcqResults.incorrect,
                    unattempted: mcqResults.unattempted,
                    totalMarks: totalMarksAll, // Total marks for all questions
                    obtainedMarks: obtainedMarksAll, // MCQ marks + subjective marks from API
                    percentage: totalMarksAll > 0 ? 
                        Math.round((obtainedMarksAll / totalMarksAll) * 100) : 0,
                    details: updatedDetails,
                    subjectiveEvaluations: subjectiveEvaluations,
                    mcqMarks: mcqResults.obtainedMarks,
                    subjectiveMarks: subjectiveMarks
                };
                
                console.log('Final results:', finalResults);

                // Mark as submitted in ExamCore
                ExamCore.submit();

                // Track test submission
                if (typeof trackTestSubmit === 'function') {
                    const timeSpent = ExamPractice.getTimeSpent ? ExamPractice.getTimeSpent() : 0;
                    trackTestSubmit(
                        SET_ID,
                        attemptId,
                        obtainedMarksAll,
                        totalMarksAll,
                        finalResults.percentage,
                        timeSpent
                    );
                }

                // Hide overlay before showing results
                hideEvaluationOverlay();

                // Show results
                handleResults(finalResults);

                // Clear any pending submission data
                localStorage.removeItem(PENDING_SUBMISSION_KEY);
            } catch (error) {
                console.error('Failed to submit:', error);
                hideEvaluationOverlay();
                ExamToast.error('Failed to submit test. Please try again.', { duration: 5000 });
            }
        }

        // Handle results
        function handleResults(results) {
            console.log('Displaying results:', results); // Debug log
            ExamPractice.stopTimer();

            // Show results
            const mainContent = document.getElementById('practice-main');
            if (!mainContent) {
                console.error('practice-main element not found!');
                return;
            }
            const percentage = (results.percentage || 0);
            const obtainedMarks = (results.obtainedMarks || 0);
            const totalMarks = (results.totalMarks || 0);
            const correct = (results.correct || 0);
            const incorrect = (results.incorrect || 0);
            const unattempted = (results.unattempted || 0);
            
            mainContent.innerHTML = 
                '<div class="results-container animate-fade-in" style="padding-top: var(--space-8);">' +
                    '<div class="results-header">' +
                        '<h1 class="results-title">Test Completed!</h1>' +
                        '<div class="results-score-circle">' +
                            '<div class="results-score-value">' + percentage + '%</div>' +
                            '<div class="results-score-label">' + obtainedMarks + '/' + totalMarks + ' marks</div>' +
                        '</div>' +
                    '</div>' +
                    '<div class="results-breakdown">' +
                        '<h3 class="results-breakdown-title">Score Breakdown</h3>' +
                        '<div class="results-breakdown-grid">' +
                            '<div class="results-breakdown-item">' +
                                '<div class="results-breakdown-value correct">' + correct + '</div>' +
                                '<div class="results-breakdown-label">Correct</div>' +
                            '</div>' +
                            '<div class="results-breakdown-item">' +
                                '<div class="results-breakdown-value incorrect">' + incorrect + '</div>' +
                                '<div class="results-breakdown-label">Incorrect</div>' +
                            '</div>' +
                            '<div class="results-breakdown-item">' +
                                '<div class="results-breakdown-value unattempted">' + unattempted + '</div>' +
                                '<div class="results-breakdown-label">Unattempted</div>' +
                            '</div>' +
                        '</div>' +
                    '</div>' +
                    '<div class="ad-slot" style="margin: var(--space-6) 0;">' +
                        '<!-- Ad can be placed here -->' +
                    '</div>' +
                    '<div class="results-actions">' +
                        '<button class="btn btn-primary btn-lg" onclick="reviewAnswers()">' +
                            '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">' +
                                '<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>' +
                                '<polyline points="14 2 14 8 20 8"></polyline>' +
                                '<line x1="16" y1="13" x2="8" y2="13"></line>' +
                                '<line x1="16" y1="17" x2="8" y2="17"></line>' +
                            '</svg>' +
                            'Review Answers' +
                        '</button>' +
                        '<a href="<%=request.getContextPath()%>/exams/cbse-board/mathematics/" class="btn btn-secondary btn-lg">' +
                            'Try Another Set' +
                        '</a>' +
                    '</div>' +
                '</div>';

            // Hide mobile nav toggle
            const navToggle = document.getElementById('mobile-nav-toggle');
            if (navToggle) navToggle.style.display = 'none';
        }

        // Review answers - redirect to review page
        function reviewAnswers() {
            if (attemptId) {
                const reviewUrl = CONTEXT_PATH + '/exams/cbse-board/mathematics/review.jsp?attempt_id=' + attemptId;
                window.location.href = reviewUrl;
            } else {
                ExamToast.error('Unable to load review. Please try again from the dashboard.');
            }
        }

        // Update mobile progress
        function updateMobileProgress() {
            const progress = ExamCore.getProgress();
            const fill = document.getElementById('mobile-progress-fill');
            const text = document.getElementById('mobile-progress-text');

            if (fill) fill.style.width = progress.percentage + '%';
            if (text) text.textContent = progress.answered + '/' + progress.total;
        }

        // Override navigator update to also update mobile
        const originalUpdate = ExamPractice.updateNavigator;
        ExamPractice.updateNavigator = function() {
            originalUpdate.call(ExamPractice);
            updateMobileProgress();
        };

        // Theme toggle function
        function toggleTheme() {
            console.log('toggleTheme called');
            var html = document.documentElement;
            var currentTheme = html.getAttribute('data-theme');
            console.log('Current theme:', currentTheme);

            if (currentTheme === 'dark') {
                // Switch to light - remove the attribute entirely
                html.removeAttribute('data-theme');
                localStorage.setItem('exam-theme', 'light');
                console.log('Theme changed to: light');
            } else {
                // Switch to dark - set the attribute
                html.setAttribute('data-theme', 'dark');
                localStorage.setItem('exam-theme', 'dark');
                console.log('Theme changed to: dark');
            }
        }

        // Attach theme toggle listener
        (function() {
            var themeBtn = document.getElementById('theme-toggle-btn');
            if (themeBtn) {
                console.log('Theme button found, attaching listener');
                themeBtn.addEventListener('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    console.log('Theme button clicked');
                    toggleTheme();
                });
            } else {
                console.error('Theme button not found!');
            }
        })();

    </script>

    <!-- Evaluation Loading Overlay -->
    <div id="evaluationOverlay" class="evaluation-overlay" style="display: none;">
        <div class="evaluation-modal">
            <div class="evaluation-spinner"></div>
            <h3 class="evaluation-title">Evaluating Your Answers</h3>
            <p id="evaluationStatus" class="evaluation-status">Saving your answers...</p>
            <div class="evaluation-progress">
                <div id="evaluationProgressBar" class="evaluation-progress-bar"></div>
            </div>
            <p class="evaluation-note">Please wait, this may take a few moments.</p>
        </div>
    </div>

    <style>
        .evaluation-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            backdrop-filter: blur(4px);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 10000;
        }
        .evaluation-modal {
            background: var(--surface, #fff);
            border-radius: 16px;
            padding: 2rem;
            text-align: center;
            max-width: 400px;
            width: 90%;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            animation: modalSlideIn 0.3s ease-out;
        }
        @keyframes modalSlideIn {
            from {
                opacity: 0;
                transform: translateY(-20px) scale(0.95);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }
        .evaluation-spinner {
            width: 60px;
            height: 60px;
            border: 4px solid var(--border, #e5e7eb);
            border-top-color: var(--primary, #6366f1);
            border-radius: 50%;
            margin: 0 auto 1.5rem;
            animation: spin 1s linear infinite;
        }
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
        .evaluation-title {
            margin: 0 0 0.5rem;
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary, #111827);
        }
        .evaluation-status {
            margin: 0 0 1rem;
            font-size: 0.95rem;
            color: var(--text-secondary, #6b7280);
        }
        .evaluation-progress {
            height: 6px;
            background: var(--border, #e5e7eb);
            border-radius: 3px;
            overflow: hidden;
            margin-bottom: 1rem;
        }
        .evaluation-progress-bar {
            height: 100%;
            background: linear-gradient(90deg, var(--primary, #6366f1), var(--primary-dark, #4f46e5));
            border-radius: 3px;
            width: 0%;
            transition: width 0.3s ease;
        }
        .evaluation-note {
            margin: 0;
            font-size: 0.85rem;
            color: var(--text-muted, #9ca3af);
        }
        [data-theme="dark"] .evaluation-modal {
            background: var(--surface, #1f2937);
        }
        [data-theme="dark"] .evaluation-title {
            color: var(--text-primary, #f9fafb);
        }
    </style>
</body>
</html>