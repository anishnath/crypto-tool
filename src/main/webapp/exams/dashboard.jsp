<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Set page attributes before including header
    request.setAttribute("pageTitle", "My Dashboard - Practice History");
    request.setAttribute("pageDescription", "View your exam practice history, scores, and performance analytics.");
    request.setAttribute("canonicalUrl", "https://8gwifi.org/exams/dashboard.jsp");
    
    // Get user info from session and set as request attributes (header.jsp will declare variables)
    // Use different variable names to avoid conflicts with header.jsp
    HttpSession dashboardSession = request.getSession(false);
    Object userSubObj = null;
    Object userEmailObj = null;
    String userName = null;
    boolean dashboardIsLoggedIn = false;
    
    if (dashboardSession != null) {
        userSubObj = dashboardSession.getAttribute("oauth_user_sub");
        userEmailObj = dashboardSession.getAttribute("oauth_user_email");
        userName = (String) dashboardSession.getAttribute("oauth_user_name");
        String userSubTemp = (String) userSubObj;
        String userEmailTemp = (String) userEmailObj;
        dashboardIsLoggedIn = (userSubTemp != null && !userSubTemp.isEmpty()) || (userEmailTemp != null && !userEmailTemp.isEmpty());
    }
    
    // Set as request attributes for header.jsp to use (avoids duplicate declarations)
    request.setAttribute("_userSub", userSubObj);
    request.setAttribute("_userEmail", userEmailObj);
    request.setAttribute("_isLoggedIn", Boolean.valueOf(dashboardIsLoggedIn));

    // Redirect to login if not logged in (do this before including header)
    if (!dashboardIsLoggedIn) {
        String dashboardRedirectPath = "/exams/dashboard.jsp";
        response.sendRedirect(request.getContextPath() + "/GoogleOAuthFunctionality?action=login&redirect_path=" + java.net.URLEncoder.encode(dashboardRedirectPath, "UTF-8"));
        return;
    }
%>
<%@ include file="components/header.jsp" %>
<%
    // Get display name (after header include, header.jsp now has userSub and userEmail declared)
    String displayName = "Student";
    if (userName != null && !userName.isEmpty()) {
        displayName = userName.split(" ")[0]; // First name only
    } else {
        // Get userEmail from request attribute (header.jsp set it)
        // Use different variable name to avoid conflict with header.jsp's userEmail
        String userEmailForDisplay = (String) request.getAttribute("_userEmail");
        if (userEmailForDisplay != null && !userEmailForDisplay.isEmpty()) {
            displayName = userEmailForDisplay.split("@")[0];
        }
    }
%>

<div class="container">
    <!-- Breadcrumb -->
    <nav class="breadcrumb">
        <a href="<%=request.getContextPath()%>/exams/">Exams</a>
        <span class="breadcrumb-separator">/</span>
        <span class="breadcrumb-current">My Dashboard</span>
    </nav>

    <!-- Page Header -->
    <header class="dashboard-header">
        <div class="dashboard-welcome">
            <h1 class="dashboard-title">Welcome back, <%= displayName %>!</h1>
            <p class="dashboard-subtitle">Track your progress and review your practice history</p>
        </div>
        <a href="<%=request.getContextPath()%>/exams/cbse-board/mathematics/" class="btn btn-primary">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polygon points="5 3 19 12 5 21 5 3"></polygon>
            </svg>
            Start Practice
        </a>
    </header>

    <!-- Stats Cards -->
    <section class="stats-grid" id="stats-grid">
        <div class="stat-card">
            <div class="stat-icon" style="background: var(--accent-light); color: var(--accent-primary);">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                    <polyline points="14 2 14 8 20 8"></polyline>
                </svg>
            </div>
            <div class="stat-content">
                <div class="stat-value" id="stat-total-attempts">--</div>
                <div class="stat-label">Total Attempts</div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon" style="background: var(--success-light); color: var(--success);">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                    <polyline points="22 4 12 14.01 9 11.01"></polyline>
                </svg>
            </div>
            <div class="stat-content">
                <div class="stat-value" id="stat-completed">--</div>
                <div class="stat-label">Completed</div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon" style="background: var(--warning-light); color: var(--warning);">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"></circle>
                    <polyline points="12 6 12 12 16 14"></polyline>
                </svg>
            </div>
            <div class="stat-content">
                <div class="stat-value" id="stat-in-progress">--</div>
                <div class="stat-label">In Progress</div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon" style="background: var(--info-light); color: var(--info);">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polyline points="23 6 13.5 15.5 8.5 10.5 1 18"></polyline>
                    <polyline points="17 6 23 6 23 12"></polyline>
                </svg>
            </div>
            <div class="stat-content">
                <div class="stat-value" id="stat-avg-score">--%</div>
                <div class="stat-label">Average Score</div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon" style="background: var(--success-light); color: var(--success-dark);">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                </svg>
            </div>
            <div class="stat-content">
                <div class="stat-value" id="stat-best-score">--%</div>
                <div class="stat-label">Best Score</div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon" style="background: var(--accent-light); color: var(--accent-primary);">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"></circle>
                    <polyline points="12 6 12 12 16 14"></polyline>
                </svg>
            </div>
            <div class="stat-content">
                <div class="stat-value" id="stat-total-time">--</div>
                <div class="stat-label">Total Time</div>
            </div>
        </div>
    </section>

    <!-- Charts Section -->
    <section class="charts-section">
        <div class="chart-card chart-card-wide">
            <div class="chart-header">
                <h3 class="chart-title">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <polyline points="23 6 13.5 15.5 8.5 10.5 1 18"></polyline>
                        <polyline points="17 6 23 6 23 12"></polyline>
                    </svg>
                    Performance Over Time
                </h3>
            </div>
            <div class="chart-body">
                <canvas id="performanceChart" height="250"></canvas>
                <div class="chart-empty" id="performance-empty" style="display: none;">
                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="var(--text-muted)" stroke-width="1.5">
                        <polyline points="23 6 13.5 15.5 8.5 10.5 1 18"></polyline>
                        <polyline points="17 6 23 6 23 12"></polyline>
                    </svg>
                    <p>Complete more tests to see your progress chart</p>
                </div>
            </div>
        </div>

        <div class="chart-card">
            <div class="chart-header">
                <h3 class="chart-title">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M21.21 15.89A10 10 0 1 1 8 2.83"></path>
                        <path d="M22 12A10 10 0 0 0 12 2v10z"></path>
                    </svg>
                    Score Distribution
                </h3>
            </div>
            <div class="chart-body">
                <canvas id="scoreDistributionChart" height="220"></canvas>
                <div class="chart-empty" id="distribution-empty" style="display: none;">
                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="var(--text-muted)" stroke-width="1.5">
                        <path d="M21.21 15.89A10 10 0 1 1 8 2.83"></path>
                        <path d="M22 12A10 10 0 0 0 12 2v10z"></path>
                    </svg>
                    <p>No data yet</p>
                </div>
            </div>
        </div>

        <div class="chart-card">
            <div class="chart-header">
                <h3 class="chart-title">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="18" y1="20" x2="18" y2="10"></line>
                        <line x1="12" y1="20" x2="12" y2="4"></line>
                        <line x1="6" y1="20" x2="6" y2="14"></line>
                    </svg>
                    By Question Type
                </h3>
            </div>
            <div class="chart-body">
                <canvas id="questionTypeChart" height="220"></canvas>
                <div class="chart-empty" id="qtype-empty" style="display: none;">
                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="var(--text-muted)" stroke-width="1.5">
                        <line x1="18" y1="20" x2="18" y2="10"></line>
                        <line x1="12" y1="20" x2="12" y2="4"></line>
                        <line x1="6" y1="20" x2="6" y2="14"></line>
                    </svg>
                    <p>No data yet</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Ad Slot -->
    <%@ include file="components/ad-leaderboard.jsp" %>

    <!-- Recent Attempts Table -->
    <section class="attempts-section">
        <div class="section-header">
            <h2 class="section-title">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"></circle>
                    <polyline points="12 6 12 12 16 14"></polyline>
                </svg>
                Recent Attempts
            </h2>
            <div class="section-actions">
                <select id="filter-subject" class="filter-select">
                    <option value="">All Subjects</option>
                    <option value="mathematics">Mathematics</option>
                </select>
                <select id="filter-status" class="filter-select">
                    <option value="">All Status</option>
                    <option value="completed">Completed</option>
                    <option value="in_progress">In Progress</option>
                </select>
            </div>
        </div>

        <!-- Loading State -->
        <div id="attempts-loading" class="card" style="text-align: center; padding: var(--space-8);">
            <div class="loading-spinner" style="margin: 0 auto var(--space-4);"></div>
            <p class="text-muted">Loading your practice history...</p>
        </div>

        <!-- Empty State -->
        <div id="attempts-empty" class="card" style="text-align: center; padding: var(--space-12); display: none;">
            <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="var(--text-muted)" stroke-width="1.5" style="margin: 0 auto var(--space-4);">
                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                <polyline points="14 2 14 8 20 8"></polyline>
                <line x1="16" y1="13" x2="8" y2="13"></line>
                <line x1="16" y1="17" x2="8" y2="17"></line>
            </svg>
            <h3 style="color: var(--text-primary); margin-bottom: var(--space-2);">No Practice History Yet</h3>
            <p class="text-muted" style="margin-bottom: var(--space-6);">Start your first practice test to see your history here.</p>
            <a href="<%=request.getContextPath()%>/exams/cbse-board/mathematics/" class="btn btn-primary">
                Start Your First Practice
            </a>
        </div>

        <!-- Attempts Table -->
        <div id="attempts-table-container" class="table-container" style="display: none;">
            <table class="attempts-table">
                <thead>
                    <tr>
                        <th>Practice Set</th>
                        <th>Date</th>
                        <th>Score</th>
                        <th>Time Taken</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody id="attempts-tbody">
                    <!-- Populated by JavaScript -->
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div id="attempts-pagination" class="pagination" style="display: none;">
            <button class="btn btn-secondary btn-sm" id="prev-page" disabled>
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polyline points="15 18 9 12 15 6"></polyline>
                </svg>
                Previous
            </button>
            <span class="pagination-info" id="pagination-info">Page 1 of 1</span>
            <button class="btn btn-secondary btn-sm" id="next-page" disabled>
                Next
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polyline points="9 18 15 12 9 6"></polyline>
                </svg>
            </button>
        </div>
    </section>
</div>

<!-- Chart.js CDN -->
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>

<!-- Dashboard Styles -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/exams/css/dashboard.css">

<!-- Core Scripts -->
<script src="<%=request.getContextPath()%>/exams/js/exams-toast.js"></script>
<script src="<%=request.getContextPath()%>/exams/js/exams-api.js"></script>
<script src="<%=request.getContextPath()%>/exams/js/exams-core.js"></script>

<!-- Dashboard Script -->
<script>
    // Configuration
    const API_BASE = '<%=request.getContextPath()%>/CFExamMarkerFunctionality';
    const CONTEXT_PATH = '<%=request.getContextPath()%>';
    <%
        // Get user ID - prefer userSub, fallback to email
        // The API uses user_id to track attempts, so we need a consistent identifier
        String userIdForJS = (String) request.getAttribute("_userSub");
        if (userIdForJS == null || userIdForJS.isEmpty()) {
            // Fallback to email if sub is not available
            userIdForJS = (String) request.getAttribute("_userEmail");
        }
        if (userIdForJS == null || userIdForJS.isEmpty()) {
            // Last resort: try session directly
            HttpSession sessionForJS = request.getSession(false);
            if (sessionForJS != null) {
                userIdForJS = (String) sessionForJS.getAttribute("oauth_user_sub");
                if (userIdForJS == null || userIdForJS.isEmpty()) {
                    userIdForJS = (String) sessionForJS.getAttribute("oauth_user_email");
                }
            }
        }
    %>
    const USER_ID = '<%= userIdForJS != null ? userIdForJS : "" %>';
    console.log('Dashboard USER_ID:', USER_ID);

    // State
    let allAttempts = [];
    let filteredAttempts = [];
    let currentPage = 1;
    const PAGE_SIZE = 10;

    // Chart instances
    let performanceChart = null;
    let scoreDistributionChart = null;
    let questionTypeChart = null;

    // Initialize API
    ExamAPI.setApiBase(API_BASE);

    // Initialize on DOM ready
    document.addEventListener('DOMContentLoaded', function() {
        ExamCore.init();
        loadDashboardData();
        setupFilters();
    });

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
            // Also use percentage if available
            percentage: attempt.percentage
        };
    }

    /**
     * Load all dashboard data
     */
    async function loadDashboardData() {
        try {
            console.log('Loading dashboard data for user:', USER_ID);

            // Fetch user attempts
            const response = await ExamAPI.getUserAttempts(USER_ID, 100, 0);

            console.log('API response:', response);

            if (response.success && response.attempts) {
                // Normalize the data to expected field names
                allAttempts = response.attempts.map(normalizeAttempt);
                filteredAttempts = [...allAttempts];

                console.log('Normalized attempts:', allAttempts);

                // Update stats
                updateStats();

                // Render charts
                renderCharts();

                // Render attempts table
                renderAttemptsTable();
            } else {
                showEmptyState();
            }
        } catch (error) {
            console.error('Failed to load dashboard data:', error);
            ExamToast.error('Failed to load your practice history. Please try again.');
            showEmptyState();
        }
    }

    /**
     * Update stats cards
     */
    function updateStats() {
        // Completed = submitted, graded, or completed status
        // Submitted means user finished taking the test (may still be pending AI grading)
        const completed = allAttempts.filter(a => 
            a.status === 'completed' || 
            a.status === 'graded' || 
            a.status === 'submitted'
        );
        // In Progress = any attempt that is not completed (includes in_progress, started, null, undefined, or any other status)
        const inProgress = allAttempts.filter(a => 
            a.status !== 'completed' && 
            a.status !== 'graded' && 
            a.status !== 'submitted'
        );

        // Total attempts
        document.getElementById('stat-total-attempts').textContent = allAttempts.length;

        // Completed
        document.getElementById('stat-completed').textContent = completed.length;

        // In Progress
        document.getElementById('stat-in-progress').textContent = inProgress.length;

        // Average score
        if (completed.length > 0) {
            const scores = completed
                .filter(a => a.score !== null && a.total_marks !== null && a.total_marks > 0)
                .map(a => (a.score / a.total_marks) * 100);

            if (scores.length > 0) {
                const avgScore = scores.reduce((a, b) => a + b, 0) / scores.length;
                document.getElementById('stat-avg-score').textContent = Math.round(avgScore) + '%';

                // Best score
                const bestScore = Math.max(...scores);
                document.getElementById('stat-best-score').textContent = Math.round(bestScore) + '%';
            }
        }

        // Total time
        const totalMinutes = allAttempts.reduce((sum, a) => {
            if (a.time_taken_seconds) {
                return sum + Math.round(a.time_taken_seconds / 60);
            }
            return sum;
        }, 0);

        if (totalMinutes >= 60) {
            const hours = Math.floor(totalMinutes / 60);
            const mins = totalMinutes % 60;
            document.getElementById('stat-total-time').textContent = hours + 'h ' + mins + 'm';
        } else {
            document.getElementById('stat-total-time').textContent = totalMinutes + ' min';
        }
    }

    /**
     * Render all charts
     */
    function renderCharts() {
        // Completed includes submitted, graded, and completed status
        const completed = allAttempts.filter(a =>
            (a.status === 'completed' || a.status === 'graded' || a.status === 'submitted') &&
            a.score !== null && a.total_marks !== null
        );

        // Get CSS variables for colors
        const styles = getComputedStyle(document.documentElement);
        const accentColor = styles.getPropertyValue('--accent-primary').trim() || '#6366f1';
        const successColor = styles.getPropertyValue('--success').trim() || '#10b981';
        const warningColor = styles.getPropertyValue('--warning').trim() || '#f59e0b';
        const errorColor = styles.getPropertyValue('--error').trim() || '#ef4444';
        const infoColor = styles.getPropertyValue('--info').trim() || '#3b82f6';
        const textMuted = styles.getPropertyValue('--text-muted').trim() || '#94a3b8';
        const borderColor = styles.getPropertyValue('--border').trim() || '#e2e8f0';

        // Performance over time chart
        if (completed.length >= 2) {
            const sortedAttempts = [...completed].sort((a, b) =>
                new Date(a.started_at) - new Date(b.started_at)
            ).slice(-10); // Last 10 attempts

            const labels = sortedAttempts.map((a, i) => 'Test ' + (i + 1));
            const data = sortedAttempts.map(a => Math.round((a.score / a.total_marks) * 100));

            const ctx = document.getElementById('performanceChart').getContext('2d');
            performanceChart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Score %',
                        data: data,
                        borderColor: accentColor,
                        backgroundColor: accentColor + '20',
                        fill: true,
                        tension: 0.4,
                        pointBackgroundColor: accentColor,
                        pointBorderColor: '#fff',
                        pointBorderWidth: 2,
                        pointRadius: 5,
                        pointHoverRadius: 7
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            backgroundColor: 'rgba(0, 0, 0, 0.8)',
                            padding: 12,
                            titleFont: { size: 14 },
                            bodyFont: { size: 13 },
                            callbacks: {
                                label: function(context) {
                                    return 'Score: ' + context.parsed.y + '%';
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            max: 100,
                            grid: {
                                color: borderColor
                            },
                            ticks: {
                                color: textMuted,
                                callback: function(value) {
                                    return value + '%';
                                }
                            }
                        },
                        x: {
                            grid: {
                                display: false
                            },
                            ticks: {
                                color: textMuted
                            }
                        }
                    }
                }
            });
        } else {
            document.getElementById('performanceChart').style.display = 'none';
            document.getElementById('performance-empty').style.display = 'flex';
        }

        // Score distribution chart (donut)
        if (completed.length > 0) {
            const ranges = {
                'Excellent (90-100%)': 0,
                'Good (70-89%)': 0,
                'Average (50-69%)': 0,
                'Needs Work (<50%)': 0
            };

            completed.forEach(a => {
                const pct = (a.score / a.total_marks) * 100;
                if (pct >= 90) ranges['Excellent (90-100%)']++;
                else if (pct >= 70) ranges['Good (70-89%)']++;
                else if (pct >= 50) ranges['Average (50-69%)']++;
                else ranges['Needs Work (<50%)']++;
            });

            const ctx = document.getElementById('scoreDistributionChart').getContext('2d');
            scoreDistributionChart = new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: Object.keys(ranges),
                    datasets: [{
                        data: Object.values(ranges),
                        backgroundColor: [successColor, infoColor, warningColor, errorColor],
                        borderWidth: 0
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    cutout: '60%',
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                color: textMuted,
                                padding: 15,
                                usePointStyle: true,
                                pointStyle: 'circle'
                            }
                        }
                    }
                }
            });
        } else {
            document.getElementById('scoreDistributionChart').style.display = 'none';
            document.getElementById('distribution-empty').style.display = 'flex';
        }

        // Question type performance (bar chart) - mock data for now
        // In real implementation, this would come from detailed attempt data
        if (completed.length > 0) {
            const ctx = document.getElementById('questionTypeChart').getContext('2d');
            questionTypeChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: ['MCQ', 'VSA', 'SA', 'LA', 'Case Study'],
                    datasets: [{
                        label: 'Avg Score %',
                        data: [78, 72, 65, 58, 62], // Mock data - replace with real data
                        backgroundColor: [
                            accentColor,
                            successColor,
                            infoColor,
                            warningColor,
                            errorColor
                        ],
                        borderRadius: 6
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            max: 100,
                            grid: {
                                color: borderColor
                            },
                            ticks: {
                                color: textMuted,
                                callback: function(value) {
                                    return value + '%';
                                }
                            }
                        },
                        x: {
                            grid: {
                                display: false
                            },
                            ticks: {
                                color: textMuted
                            }
                        }
                    }
                }
            });
        } else {
            document.getElementById('questionTypeChart').style.display = 'none';
            document.getElementById('qtype-empty').style.display = 'flex';
        }
    }

    /**
     * Render attempts table
     */
    function renderAttemptsTable() {
        const loadingEl = document.getElementById('attempts-loading');
        const emptyEl = document.getElementById('attempts-empty');
        const tableContainer = document.getElementById('attempts-table-container');
        const paginationEl = document.getElementById('attempts-pagination');

        loadingEl.style.display = 'none';

        if (filteredAttempts.length === 0) {
            emptyEl.style.display = 'block';
            tableContainer.style.display = 'none';
            paginationEl.style.display = 'none';
            return;
        }

        emptyEl.style.display = 'none';
        tableContainer.style.display = 'block';

        // Sort by date descending
        const sorted = [...filteredAttempts].sort((a, b) =>
            new Date(b.started_at) - new Date(a.started_at)
        );

        // Paginate
        const totalPages = Math.ceil(sorted.length / PAGE_SIZE);
        const start = (currentPage - 1) * PAGE_SIZE;
        const pageItems = sorted.slice(start, start + PAGE_SIZE);

        // Render rows
        const tbody = document.getElementById('attempts-tbody');
        tbody.innerHTML = pageItems.map(attempt => {
            const date = new Date(attempt.started_at);
            const dateStr = date.toLocaleDateString('en-US', {
                month: 'short',
                day: 'numeric',
                year: date.getFullYear() !== new Date().getFullYear() ? 'numeric' : undefined
            });

            // Completed includes submitted, graded, and completed status
            const isCompleted = attempt.status === 'completed' || 
                                attempt.status === 'graded' || 
                                attempt.status === 'submitted';
            const score = isCompleted && attempt.score !== null ?
                attempt.score + '/' + attempt.total_marks : '--';
            const pct = isCompleted && attempt.score !== null && attempt.total_marks > 0 ?
                Math.round((attempt.score / attempt.total_marks) * 100) : null;

            const timeTaken = attempt.time_taken_seconds ?
                Math.round(attempt.time_taken_seconds / 60) + ' min' : '--';

            // Determine status text - submitted means test is done, may be pending AI grading
            let statusClass = isCompleted ? 'status-completed' : 'status-in-progress';
            let statusText = 'In Progress';
            if (isCompleted) {
                if (attempt.status === 'submitted') {
                    statusText = 'Submitted'; // May be pending AI grading
                } else if (attempt.status === 'graded') {
                    statusText = 'Graded'; // Fully graded including AI
                } else {
                    statusText = 'Completed'; // Fully completed
                }
            }

            const actionBtn = isCompleted ?
                '<a href="' + CONTEXT_PATH + '/exams/cbse-board/mathematics/review.jsp?attempt_id=' + attempt.attempt_id + '" class="btn btn-secondary btn-sm">Review</a>' :
                '<a href="' + CONTEXT_PATH + '/exams/cbse-board/mathematics/practice.jsp?set=' + attempt.set_id + '&resume=' + attempt.attempt_id + '" class="btn btn-primary btn-sm">Resume</a>';

            return '<tr>' +
                '<td>' +
                    '<div class="attempt-set-name">' + escapeHtml(attempt.set_name || attempt.set_id) + '</div>' +
                    '<div class="attempt-set-meta">CBSE Class 10 Mathematics</div>' +
                '</td>' +
                '<td>' + dateStr + '</td>' +
                '<td>' +
                    '<div class="attempt-score">' + score + '</div>' +
                    (pct !== null ? '<div class="attempt-score-pct ' + getScoreClass(pct) + '">' + pct + '%</div>' : '') +
                '</td>' +
                '<td>' + timeTaken + '</td>' +
                '<td><span class="status-badge ' + statusClass + '">' + statusText + '</span></td>' +
                '<td>' + actionBtn + '</td>' +
            '</tr>';
        }).join('');

        // Update pagination
        if (totalPages > 1) {
            paginationEl.style.display = 'flex';
            document.getElementById('pagination-info').textContent =
                'Page ' + currentPage + ' of ' + totalPages;
            document.getElementById('prev-page').disabled = currentPage === 1;
            document.getElementById('next-page').disabled = currentPage === totalPages;
        } else {
            paginationEl.style.display = 'none';
        }
    }

    /**
     * Get score class for styling
     */
    function getScoreClass(pct) {
        if (pct >= 80) return 'score-excellent';
        if (pct >= 60) return 'score-good';
        if (pct >= 40) return 'score-average';
        return 'score-low';
    }

    /**
     * Show empty state
     */
    function showEmptyState() {
        document.getElementById('attempts-loading').style.display = 'none';
        document.getElementById('attempts-empty').style.display = 'block';
        document.getElementById('attempts-table-container').style.display = 'none';

        // Show empty charts
        document.getElementById('performanceChart').style.display = 'none';
        document.getElementById('performance-empty').style.display = 'flex';
        document.getElementById('scoreDistributionChart').style.display = 'none';
        document.getElementById('distribution-empty').style.display = 'flex';
        document.getElementById('questionTypeChart').style.display = 'none';
        document.getElementById('qtype-empty').style.display = 'flex';
    }

    /**
     * Setup filter event listeners
     */
    function setupFilters() {
        document.getElementById('filter-subject').addEventListener('change', applyFilters);
        document.getElementById('filter-status').addEventListener('change', applyFilters);

        document.getElementById('prev-page').addEventListener('click', function() {
            if (currentPage > 1) {
                currentPage--;
                renderAttemptsTable();
            }
        });

        document.getElementById('next-page').addEventListener('click', function() {
            const totalPages = Math.ceil(filteredAttempts.length / PAGE_SIZE);
            if (currentPage < totalPages) {
                currentPage++;
                renderAttemptsTable();
            }
        });
    }

    /**
     * Apply filters to attempts
     */
    function applyFilters() {
        const subject = document.getElementById('filter-subject').value;
        const status = document.getElementById('filter-status').value;

        filteredAttempts = allAttempts.filter(a => {
            if (subject && a.subject !== subject) return false;
            // Completed includes submitted, graded, and completed
            if (status === 'completed' && 
                a.status !== 'completed' && 
                a.status !== 'graded' && 
                a.status !== 'submitted') return false;
            // In Progress = any status that is not completed, graded, or submitted
            if (status === 'in_progress' && 
                (a.status === 'completed' || a.status === 'graded' || a.status === 'submitted')) return false;
            return true;
        });

        currentPage = 1;
        renderAttemptsTable();
    }

    /**
     * Escape HTML
     */
    function escapeHtml(text) {
        if (!text) return '';
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
</script>

<%@ include file="components/footer.jsp" %>
