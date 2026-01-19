<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%--
    Exam Platform - Header Component

    Usage: <%@ include file="components/header.jsp" %>

    Parameters (set before include):
    - pageTitle: Page title for <title> tag
    - pageDescription: Meta description
    - canonicalUrl: Canonical URL (optional)
    - includePracticeCSS: Set to "true" to include practice.css
--%>
<%
    // Check if user is logged in
    // Use request attributes to avoid duplicate variable declarations when included
    // Only declare variables if they haven't been declared by the including page
    String userSub;
    String userEmail;
    boolean isLoggedIn;
    HttpSession sessionObj;
    String redirectPath;

    // Check if variables are already set as request attributes (by including page)
    Object existingUserSub = request.getAttribute("_userSub");
    Object existingUserEmail = request.getAttribute("_userEmail");
    Boolean existingIsLoggedIn = (Boolean) request.getAttribute("_isLoggedIn");

    if (existingUserSub != null || existingUserEmail != null || existingIsLoggedIn != null) {
        // Variables already set by including page, use them
        userSub = (String) existingUserSub;
        userEmail = (String) existingUserEmail;
        isLoggedIn = (existingIsLoggedIn != null) ? existingIsLoggedIn.booleanValue() :
                     ((userSub != null && !userSub.isEmpty()) || (userEmail != null && !userEmail.isEmpty()));
    } else {
        // Not set by including page, get from session
        sessionObj = request.getSession(false);
        if (sessionObj != null) {
            userSub = (String) sessionObj.getAttribute("oauth_user_sub");
            userEmail = (String) sessionObj.getAttribute("oauth_user_email");

            // Fallback: Check oauth_user_info Map (some OAuth flows only set this)
            if ((userSub == null || userSub.isEmpty()) && (userEmail == null || userEmail.isEmpty())) {
                @SuppressWarnings("unchecked")
                Map<String, Object> userInfo = (Map<String, Object>) sessionObj.getAttribute("oauth_user_info");
                if (userInfo != null) {
                    Object subObj = userInfo.get("sub");
                    if (subObj == null) subObj = userInfo.get("id");
                    if (subObj != null) userSub = subObj.toString();

                    Object emailObj = userInfo.get("email");
                    if (emailObj != null) userEmail = emailObj.toString();
                }
            }

            // User is logged in if either userSub OR userEmail exists
            isLoggedIn = (userSub != null && !userSub.isEmpty()) || (userEmail != null && !userEmail.isEmpty());
            // Store in request attributes for consistency
            request.setAttribute("_isLoggedIn", Boolean.valueOf(isLoggedIn));
            request.setAttribute("_userSub", userSub);
            request.setAttribute("_userEmail", userEmail);
        } else {
            userSub = null;
            userEmail = null;
            isLoggedIn = false;
            request.setAttribute("_isLoggedIn", Boolean.FALSE);
        }
    }
    
    // Build redirect URL from current request
    String currentUrl = request.getRequestURI();
    String queryString = request.getQueryString();
    if (queryString != null && !queryString.isEmpty()) {
        currentUrl += "?" + queryString;
    }
    redirectPath = currentUrl.replace(request.getContextPath(), "");
    if (!redirectPath.startsWith("/")) {
        redirectPath = "/" + redirectPath;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "Practice Exams" %> | 8gwifi.org</title>
    <meta name="description" content="<%= request.getAttribute("pageDescription") != null ? request.getAttribute("pageDescription") : "Practice exams and mock tests for board exam preparation" %>">

    <% if (request.getAttribute("canonicalUrl") != null) { %>
    <link rel="canonical" href="<%= request.getAttribute("canonicalUrl") %>">
    <% } %>

    <!-- Favicon -->
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">

    <!-- Fonts (shared with tutorials) -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">

    <!-- Exam Platform CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/exams/css/exams.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/exams/css/toast.css">
    <% if ("true".equals(request.getAttribute("includePracticeCSS"))) { %>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/exams/css/practice.css">
    <% } %>

    <!-- Theme initialization -->
    <script>
        (function() {
            var theme = localStorage.getItem('exam-theme');
            if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
                document.documentElement.setAttribute('data-theme', 'dark');
            }
        })();
    </script>

    <!-- MathJax for LaTeX rendering -->
    <script>
        window.MathJax = {
            tex: {
                inlineMath: [['$', '$'], ['\\(', '\\)']],
                displayMath: [['$$', '$$'], ['\\[', '\\]']]
            },
            svg: {
                fontCache: 'global'
            }
        };
    </script>
    <script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>

    <!-- Ad Scripts -->
    <%@ include file="ads-head.jsp" %>
</head>
<body class="exam-layout">
    <!-- Header -->
    <header class="exam-header">
        <div class="container">
            <div class="header-left">
                <button class="menu-btn" onclick="toggleMobileMenu()" aria-label="Menu">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="3" y1="12" x2="21" y2="12"></line>
                        <line x1="3" y1="6" x2="21" y2="6"></line>
                        <line x1="3" y1="18" x2="21" y2="18"></line>
                    </svg>
                </button>
                <a href="<%=request.getContextPath()%>/exams/" class="logo">
                    <span class="logo-icon">EP</span>
                    <span class="logo-text">ExamPrep</span>
                </a>
            </div>

            <nav class="header-nav">
                <a href="<%=request.getContextPath()%>/exams/">Home</a>
                <% if (isLoggedIn) { %>
                <a href="<%=request.getContextPath()%>/exams/dashboard.jsp">My Dashboard</a>
                <% } %>
                <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                <a href="<%=request.getContextPath()%>/">Tools</a>
            </nav>

            <div class="header-right">

                <% if (isLoggedIn) { %>
                    <!-- Logged in state -->
                    <div class="user-menu" style="display: flex; align-items: center; gap: var(--space-3);">
                        <a href="<%=request.getContextPath()%>/exams/dashboard.jsp" class="btn btn-ghost btn-sm" title="My Dashboard" style="display: flex; align-items: center; gap: var(--space-2);">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="3" y="3" width="7" height="7"></rect>
                                <rect x="14" y="3" width="7" height="7"></rect>
                                <rect x="14" y="14" width="7" height="7"></rect>
                                <rect x="3" y="14" width="7" height="7"></rect>
                            </svg>
                            <span class="hide-mobile"><%= userEmail != null ? userEmail.split("@")[0] : "Dashboard" %></span>
                        </a>
                        <a href="<%=request.getContextPath()%>/GoogleOAuthFunctionality?action=logout&redirect_path=<%=java.net.URLEncoder.encode(redirectPath, "UTF-8")%>" class="btn btn-secondary btn-sm" title="Logout">
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
                
                <button class="theme-toggle" onclick="ExamCore.toggleTheme()" aria-label="Toggle theme">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="sun-icon">
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
                </button>
            </div>
        </div>
    </header>

    <!-- Mobile Menu -->
    <div class="overlay" id="mobileMenuOverlay" onclick="closeMobileMenu()"></div>
    <div class="mobile-menu" id="mobileMenu">
        <div class="mobile-menu-header">
            <span class="logo">
                <span class="logo-icon">EP</span>
                <span>ExamPrep</span>
            </span>
            <button class="menu-btn" onclick="closeMobileMenu()" aria-label="Close menu">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="18" y1="6" x2="6" y2="18"></line>
                    <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
            </button>
        </div>
        <nav class="mobile-menu-nav">
            <a href="<%=request.getContextPath()%>/exams/">Home</a>
            <% if (isLoggedIn) { %>
            <a href="<%=request.getContextPath()%>/exams/dashboard.jsp" style="display: flex; align-items: center; gap: var(--space-2);">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <rect x="3" y="3" width="7" height="7"></rect>
                    <rect x="14" y="3" width="7" height="7"></rect>
                    <rect x="14" y="14" width="7" height="7"></rect>
                    <rect x="3" y="14" width="7" height="7"></rect>
                </svg>
                My Dashboard
            </a>
            <% } %>
            <a href="<%=request.getContextPath()%>/exams/cbse-board/">CBSE Board</a>
            <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
            <a href="<%=request.getContextPath()%>/">Tools</a>
            <div style="margin-top: var(--space-4); padding-top: var(--space-4); border-top: 1px solid var(--border);">
                <% if (isLoggedIn) { %>
                    <div style="padding: var(--space-2); margin-bottom: var(--space-2);">
                        <span style="font-size: var(--text-sm); color: var(--text-secondary);">
                            <%= userEmail != null ? userEmail : "Logged in" %>
                        </span>
                    </div>
                    <a href="<%=request.getContextPath()%>/GoogleOAuthFunctionality?action=logout&redirect_path=<%=java.net.URLEncoder.encode(redirectPath, "UTF-8")%>" class="mobile-menu-link" style="display: flex; align-items: center; gap: var(--space-2);">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                            <polyline points="16 17 21 12 16 7"></polyline>
                            <line x1="21" y1="12" x2="9" y2="12"></line>
                        </svg>
                        Logout
                    </a>
                <% } else { %>
                    <a href="<%=request.getContextPath()%>/GoogleOAuthFunctionality?action=login&redirect_path=<%=java.net.URLEncoder.encode(redirectPath, "UTF-8")%>" class="mobile-menu-link" style="display: flex; align-items: center; gap: var(--space-2);">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M18 21h-10a2 2 0 0 1-2-2v-14a2 2 0 0 1 2-2h7l5 5v11a2 2 0 0 1-2 2z"></path>
                            <polyline points="12 11 12 17"></polyline>
                            <line x1="9" y1="14" x2="15" y2="14"></line>
                        </svg>
                        Login with Google
                    </a>
                <% } %>
            </div>
        </nav>
    </div>

    <!-- Main Content Start -->
    <main class="main-content">
