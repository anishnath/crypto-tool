<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    Exam Platform Analytics Component
    Includes Google Analytics 4 (GA4) and StatCounter
    Enhanced event tracking for exam platform interactions
    
    Usage: <%@ include file="components/exam-analytics.jsp" %>
    
    Enhanced Tracking:
    - Practice set views
    - Test starts and submissions
    - Question interactions
    - Review views
    - Dashboard views
    - Login/logout events
    - Performance metrics
--%>

<!-- Google Analytics 4 (GA4) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-FQ2QT10GDP" onerror="console.warn('Google Analytics failed to load')"></script>
<script>
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());
    
    // GA4 Configuration
    gtag('config', 'G-FQ2QT10GDP', {
        'page_path': window.location.pathname,
        'page_title': document.title,
        'send_page_view': true
    });

    // ============================================
    // EXAM PLATFORM EVENT TRACKING FUNCTIONS
    // ============================================

    // Track Practice Set View
    function trackPracticeSetView(setId, setName, examType, grade, subject) {
        gtag('event', 'practice_set_view', {
            'set_id': setId,
            'set_name': setName,
            'exam_type': examType,
            'grade': grade,
            'subject': subject,
            'event_category': 'Exam',
            'event_label': setName || setId
        });
    }

    // Track Test Start
    function trackTestStart(setId, attemptId, examType, grade, subject) {
        gtag('event', 'test_start', {
            'set_id': setId,
            'attempt_id': attemptId,
            'exam_type': examType,
            'grade': grade,
            'subject': subject,
            'event_category': 'Exam',
            'event_label': setId
        });
    }

    // Track Test Submission
    function trackTestSubmit(setId, attemptId, score, totalMarks, percentage, timeSpent) {
        gtag('event', 'test_submit', {
            'set_id': setId,
            'attempt_id': attemptId,
            'score': score,
            'total_marks': totalMarks,
            'percentage': percentage,
            'time_spent_seconds': timeSpent,
            'event_category': 'Exam',
            'event_label': setId,
            'value': percentage
        });
    }

    // Track Question Answer
    function trackQuestionAnswer(setId, questionId, questionType, isCorrect, marksAwarded) {
        gtag('event', 'question_answer', {
            'set_id': setId,
            'question_id': questionId,
            'question_type': questionType,
            'is_correct': isCorrect,
            'marks_awarded': marksAwarded,
            'event_category': 'Exam',
            'event_label': questionId
        });
    }

    // Track Review View
    function trackReviewView(attemptId, setId, score, percentage) {
        gtag('event', 'review_view', {
            'attempt_id': attemptId,
            'set_id': setId,
            'score': score,
            'percentage': percentage,
            'event_category': 'Exam',
            'event_label': attemptId
        });
    }

    // Track Dashboard View
    function trackDashboardView(userId, totalAttempts, avgScore) {
        gtag('event', 'dashboard_view', {
            'user_id': userId,
            'total_attempts': totalAttempts,
            'avg_score': avgScore,
            'event_category': 'Exam',
            'event_label': 'Dashboard'
        });
    }

    // Track Login
    function trackLogin(method) {
        gtag('event', 'login', {
            'method': method || 'google_oauth',
            'event_category': 'User',
            'event_label': method || 'google_oauth'
        });
    }

    // Track Logout
    function trackLogout() {
        gtag('event', 'logout', {
            'event_category': 'User',
            'event_label': 'Logout'
        });
    }

    // Track Practice Set List View
    function trackPracticeSetListView(examType, grade, subject, setCount) {
        gtag('event', 'practice_set_list_view', {
            'exam_type': examType,
            'grade': grade,
            'subject': subject,
            'set_count': setCount,
            'event_category': 'Exam',
            'event_label': examType + ' ' + grade + ' ' + subject
        });
    }

    // Track Navigation
    function trackNavigation(fromPage, toPage) {
        gtag('event', 'navigation', {
            'from_page': fromPage,
            'to_page': toPage,
            'event_category': 'Navigation',
            'event_label': fromPage + ' -> ' + toPage
        });
    }

    // Track Error
    function trackExamError(errorType, errorMessage, page) {
        gtag('event', 'exception', {
            'description': errorMessage,
            'fatal': false,
            'error_type': errorType,
            'page': page,
            'event_category': 'Error',
            'event_label': errorType
        });
    }

    // ============================================
    // AUTO-TRACKING ON PAGE LOAD
    // ============================================

    document.addEventListener('DOMContentLoaded', function() {
        const path = window.location.pathname;
        
        // Track practice set list view
        if (path.includes('/exams/cbse-board/mathematics/') && 
            path.endsWith('/mathematics/') || path.endsWith('/mathematics/index.jsp')) {
            // Extract exam details from path
            const examType = 'CBSE';
            const grade = '10';
            const subject = 'mathematics';
            
            // Try to get set count from page (if available)
            setTimeout(function() {
                const setCountEl = document.getElementById('sets-count');
                const setCount = setCountEl ? parseInt(setCountEl.textContent) || 0 : 0;
                trackPracticeSetListView(examType, grade, subject, setCount);
            }, 2000); // Wait for sets to load
        }
        
        // Track dashboard view
        if (path.includes('/exams/dashboard.jsp')) {
            // Try to get user stats (if available)
            setTimeout(function() {
                const totalAttemptsEl = document.getElementById('total-attempts');
                const avgScoreEl = document.getElementById('avg-score');
                const totalAttempts = totalAttemptsEl ? parseInt(totalAttemptsEl.textContent) || 0 : 0;
                const avgScore = avgScoreEl ? parseFloat(avgScoreEl.textContent) || 0 : 0;
                trackDashboardView('logged_in_user', totalAttempts, avgScore);
            }, 2000);
        }
        
        // Track practice page view (will be enhanced when test starts)
        if (path.includes('/practice.jsp')) {
            const urlParams = new URLSearchParams(window.location.search);
            const setId = urlParams.get('set') || 'unknown';
            trackPracticeSetView(setId, setId, 'CBSE', '10', 'mathematics');
        }
        
        // Track review page view
        if (path.includes('/review.jsp')) {
            const urlParams = new URLSearchParams(window.location.search);
            const attemptId = urlParams.get('attempt_id') || 'unknown';
            trackReviewView(attemptId, 'unknown', 0, 0);
        }
    });

    // ============================================
    // PERFORMANCE TRACKING
    // ============================================

    window.addEventListener('load', function() {
        if ('performance' in window && 'timing' in window.performance) {
            const perfData = window.performance.timing;
            const pageLoadTime = perfData.loadEventEnd - perfData.navigationStart;
            
            gtag('event', 'page_load_time', {
                'value': pageLoadTime,
                'event_category': 'Performance',
                'event_label': window.location.pathname,
                'non_interaction': true
            });
        }
    });
</script>

<!-- StatCounter Analytics -->
<script type="text/javascript">
    var sc_project=9638240;
    var sc_invisible=1;
    var sc_security="c4db7f3d";
    var sc_https=1;
    var sc_remove_link=1;
</script>
<script type="text/javascript"
        src="https://cdn.jsdelivr.net/gh/anishnath/crypto-tool@master/src/main/webapp/js/statcounter/counter/counter.js"
        async
        onerror="console.warn('StatCounter failed to load')"></script>
<noscript>
    <div class="statcounter">
        <a title="Web Analytics" 
           href="https://statcounter.com/" 
           target="_blank"
           rel="noopener">
            <img class="statcounter"
                 src="https://c.statcounter.com/9638240/0/c4db7f3d/1/"
                 alt="Web Analytics"
                 referrerPolicy="no-referrer-when-downgrade">
        </a>
    </div>
</noscript>
<!-- End of StatCounter Code -->

