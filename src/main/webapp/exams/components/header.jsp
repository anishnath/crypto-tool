<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Map" %>
<%-- Exam Platform - Header Component Usage: <%@ include file="components/header.jsp" %>

    Parameters (set before include):
    - pageTitle: Page title for <title> tag
        - pageDescription: Meta description
        - canonicalUrl: Canonical URL (optional)
        - includePracticeCSS: Set to "true" to include practice.css
        --%>
<% // Check if user is logged in
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
    if (existingUserSub != null || existingUserEmail != null ||
            existingIsLoggedIn != null) {
        // Variables already set by including page, use them
        userSub = (String) existingUserSub;
        userEmail = (String) existingUserEmail;
        isLoggedIn = (existingIsLoggedIn != null) ?
                existingIsLoggedIn.booleanValue() : ((userSub != null && !userSub.isEmpty()) || (userEmail != null &&
                !userEmail.isEmpty()));
    } else { // Not set by including page, get from session
        sessionObj = request.getSession(false);
        if (sessionObj != null) {
            userSub = (String)
                    sessionObj.getAttribute("oauth_user_sub");
            userEmail = (String)
                    sessionObj.getAttribute("oauth_user_email");
            // Fallback: Check oauth_user_info Map (some OAuthflows only set this)
            if ((userSub == null || userSub.isEmpty()) && (userEmail == null ||
                    userEmail.isEmpty())) {
                @SuppressWarnings("unchecked") Map<String, Object> userInfo = (Map<String,
                        Object>) sessionObj.getAttribute("oauth_user_info");
                if (userInfo != null) {
                    Object subObj = userInfo.get("sub");
                    if (subObj == null) subObj = userInfo.get("id");
                    if (subObj != null) userSub = subObj.toString();

                    Object emailObj = userInfo.get("email");
                    if (emailObj != null) userEmail = emailObj.toString();
                }
            }

            // User is logged in if either userSub OR userEmail exists
            isLoggedIn = (userSub != null && !userSub.isEmpty()) || (userEmail != null &&
                    !userEmail.isEmpty());
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
    <title>
        <%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle")
                : "Practice Exams" %> | 8gwifi.org
    </title>
    <meta name="description" content="<%= request.getAttribute("pageDescription") != null ? request.getAttribute("pageDescription") : "Practice exams and mock tests for board exam preparation" %>">

    <% if (request.getAttribute("canonicalUrl") != null) { %>
    <link rel="canonical" href="<%= request.getAttribute("canonicalUrl") %>">
    <% } %>

    <!-- Sitemap -->
    <link rel="sitemap" type="application/xml"
          href="<%=request.getContextPath()%>/sitemap.xml">

    <!-- Favicon -->
    <link rel="icon" type="image/svg+xml"
          href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">

    <!-- Fonts (shared with tutorials) -->
    <link rel="stylesheet"
          href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">

    <!-- Theme initialization (before CSS to avoid flash) -->
    <script>
        (function () {
            var theme = localStorage.getItem('exam-theme');
            if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
                document.documentElement.setAttribute('data-theme', 'dark');
            }
        })();
    </script>

    <!-- Exam Platform CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/exams/css/exams.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/exams/css/toast.css">
    <% if ("true".equals(request.getAttribute("includePracticeCSS"))) { %>
    <link rel="stylesheet"
          href="<%=request.getContextPath()%>/exams/css/practice.css">
    <% } %>

    <!-- Theme toggle -->
    <script>
        // Global theme toggle (available before ExamCore loads)
        function toggleExamTheme() {
            var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
            document.documentElement.setAttribute('data-theme', isDark ? 'light' : 'dark');
            localStorage.setItem('exam-theme', isDark ? 'light' : 'dark');
        }
    </script>

    <!-- MathJax for LaTeX rendering -->
    <script>
        window.MathJax = {
            tex: {
                inlineMath: [['$', '$'], ['\\(', '\\)']],
                displayMath: [['$$', '$$'], ['\\[', '\\]']],
                macros: {
                    cosec: ['\\operatorname{cosec}', 0]
                }
            },
            options: {
                skipHtmlTags: ['script', 'noscript', 'style', 'textarea', 'pre', 'code', 'svg', 'img'],
                ignoreHtmlClass: 'no-mathjax|diagram-container|diagram-image|svg-diagram'
            },
            chtml: {
                scale: 1,
                minScale: 0.5
            },
            startup: {
                pageReady: function() {
                    return MathJax.startup.defaultPageReady();
                }
            }
        };
    </script>
    <script id="MathJax-script" async
            src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js"></script>

    <!-- Analytics -->
     <%@ include file="exam-analytics.jsp" %>

    <!-- Ad Scripts -->
    <%@ include file="ads-head.jsp" %>

    <!-- Extra Head Content (SEO, OpenGraph, etc.) -->
    <%= request.getAttribute("extraHeadContent") != null ?
            request.getAttribute("extraHeadContent") : "" %>
</head>

<body class="exam-layout">
<!-- Header -->
<header class="exam-header">
    <div class="container">
        <div class="header-left">
            <button class="menu-btn" onclick="toggleMobileMenu()" aria-label="Menu">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                     stroke="currentColor" stroke-width="2">
                    <line x1="3" y1="12" x2="21" y2="12"></line>
                    <line x1="3" y1="6" x2="21" y2="6"></line>
                    <line x1="3" y1="18" x2="21" y2="18"></line>
                </svg>
            </button>
            <a href="<%=request.getContextPath()%>/exams/" class="logo">
                <img src="<%=request.getContextPath()%>/images/site/logo.png" alt="8gwifi.org" class="logo-img" width="44" height="44">
                <span class="logo-text">8gwifi.org</span>
            </a>
        </div>

        <nav class="header-nav">
            <a href="<%=request.getContextPath()%>/exams/books/ncert/">NCERT Solutions</a>
            <a href="<%=request.getContextPath()%>/exams/quick-math/">Quick Math</a>
            <a href="<%=request.getContextPath()%>/physics/">Physics</a>
            <a href="<%=request.getContextPath()%>/exams/math-memory/">Math Memory Games</a>
            <a href="<%=request.getContextPath()%>/tutorials/">Learn to Code</a>
            <a href="<%=request.getContextPath()%>/">Tools</a>
            <% if (isLoggedIn) { %>
            <a href="<%=request.getContextPath()%>/exams/dashboard.jsp">Dashboard</a>
            <% } %>
        </nav>

        <div class="header-right">

            <% if (isLoggedIn) { %>
            <!-- Logged in state -->
            <div class="user-menu"
                 style="display: flex; align-items: center; gap: var(--space-3);">
                <a href="<%=request.getContextPath()%>/exams/dashboard.jsp"
                   class="btn btn-ghost btn-sm" title="My Dashboard"
                   style="display: flex; align-items: center; gap: var(--space-2);">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2">
                        <rect x="3" y="3" width="7" height="7"></rect>
                        <rect x="14" y="3" width="7" height="7"></rect>
                        <rect x="14" y="14" width="7" height="7"></rect>
                        <rect x="3" y="14" width="7" height="7"></rect>
                    </svg>
                    <span class="hide-mobile">
                                                        <%= userEmail != null ? userEmail.split("@")[0] : "Dashboard" %>
                                                    </span>
                </a>
                <a href="<%=request.getContextPath()%>/GoogleOAuthFunctionality?action=logout&redirect_path=<%=java.net.URLEncoder.encode(redirectPath, "UTF-8")%>" class="btn btn-secondary btn-sm" title="Logout">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2">
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
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                     stroke="currentColor" stroke-width="2">
                    <path
                            d="M18 21h-10a2 2 0 0 1-2-2v-14a2 2 0 0 1 2-2h7l5 5v11a2 2 0 0 1-2 2z">
                    </path>
                    <polyline points="12 11 12 17"></polyline>
                    <line x1="9" y1="14" x2="15" y2="14"></line>
                </svg>
                <span class="hide-mobile">Login</span>
            </a>
            <% } %>

            <!-- Share Button -->
            <button class="header-share-btn" onclick="window.ExamSocialPopup?.openShareMenu ? ExamSocialPopup.openShareMenu() : (typeof openShareMenu === 'function' ? openShareMenu() : null)" aria-label="Share" title="Share">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="18" cy="5" r="3"/>
                    <circle cx="6" cy="12" r="3"/>
                    <circle cx="18" cy="19" r="3"/>
                    <line x1="8.59" y1="13.51" x2="15.42" y2="17.49"/>
                    <line x1="15.41" y1="6.51" x2="8.59" y2="10.49"/>
                </svg>
            </button>

        <button class="theme-toggle" type="button"
                    aria-label="Toggle theme">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                     stroke="currentColor" stroke-width="2" class="sun-icon">
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

<style>
.header-share-btn {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 36px;
    height: 36px;
    background: transparent;
    border: 1px solid var(--border);
    border-radius: var(--radius-md);
    color: var(--text-secondary);
    cursor: pointer;
    transition: all 0.2s ease;
}

.header-share-btn:hover {
    background: var(--bg-tertiary);
    color: var(--text-primary);
    border-color: var(--accent-primary);
}
</style>

<!-- Mobile Menu -->
<div class="overlay" id="mobileMenuOverlay" onclick="closeMobileMenu()"></div>
<div class="mobile-menu" id="mobileMenu">
    <div class="mobile-menu-header">
                                    <span class="logo">
                                        <img src="<%=request.getContextPath()%>/images/site/logo.png" alt="8gwifi.org" class="logo-img" width="44" height="44">
                                        <span>8gwifi.org</span>
                                    </span>
        <button class="menu-btn" onclick="closeMobileMenu()" aria-label="Close menu">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="2">
                <line x1="18" y1="6" x2="6" y2="18"></line>
                <line x1="6" y1="6" x2="18" y2="18"></line>
            </svg>
        </button>
    </div>
    <nav class="mobile-menu-nav">
        <a href="<%=request.getContextPath()%>/exams/">Home</a>
        <a href="<%=request.getContextPath()%>/exams/books/ncert/">NCERT Solutions</a>
        <a href="<%=request.getContextPath()%>/exams/quick-math/">Quick Math</a>
        <a href="<%=request.getContextPath()%>/physics/">Physics Tools</a>
        <a href="<%=request.getContextPath()%>/exams/math-memory/">Mental Memory</a>
        <a href="<%=request.getContextPath()%>/exams/cbse-board/">CBSE Board</a>
        <a href="<%=request.getContextPath()%>/tutorials/">Learn to Code</a>
        <a href="<%=request.getContextPath()%>/">Tools</a>
        <% if (isLoggedIn) { %>
        <a href="<%=request.getContextPath()%>/exams/dashboard.jsp"
           style="display: flex; align-items: center; gap: var(--space-2);">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="2">
                <rect x="3" y="3" width="7" height="7"></rect>
                <rect x="14" y="3" width="7" height="7"></rect>
                <rect x="14" y="14" width="7" height="7"></rect>
                <rect x="3" y="14" width="7" height="7"></rect>
            </svg>
            Dashboard
        </a>
        <% } %>
        <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" style="display: flex; align-items: center; gap: var(--space-2);">
            <span style="font-weight: 600;">&#120143;</span>
            Follow @anish2good
        </a>
        <a href="https://buymeacoffee.com/8gwifi.org" target="_blank" rel="noopener" style="display: flex; align-items: center; gap: var(--space-2); color: #fbb034;">
            <span>&#9749;</span>
            Buy me a coffee
        </a>
        <div
                style="margin-top: var(--space-4); padding-top: var(--space-4); border-top: 1px solid var(--border);">
            <% if (isLoggedIn) { %>
            <div
                    style="padding: var(--space-2); margin-bottom: var(--space-2);">
                                                        <span
                                                                style="font-size: var(--text-sm); color: var(--text-secondary);">
                                                            <%= userEmail != null ? userEmail : "Logged in" %>
                                                        </span>
            </div>
            <a href="<%=request.getContextPath()%>/GoogleOAuthFunctionality?action=logout&redirect_path=<%=java.net.URLEncoder.encode(redirectPath, "UTF-8")%>" class="mobile-menu-link" style="display: flex;
                                                        align-items: center; gap: var(--space-2);">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                     stroke="currentColor" stroke-width="2">
                    <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                    <polyline points="16 17 21 12 16 7"></polyline>
                    <line x1="21" y1="12" x2="9" y2="12"></line>
                </svg>
                Logout
            </a>
            <% } else { %>
            <a href="<%=request.getContextPath()%>/GoogleOAuthFunctionality?action=login&redirect_path=<%=java.net.URLEncoder.encode(redirectPath, "UTF-8")%>" class="mobile-menu-link" style="display: flex;
                                                            align-items: center; gap: var(--space-2);">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                     stroke="currentColor" stroke-width="2">
                    <path
                            d="M18 21h-10a2 2 0 0 1-2-2v-14a2 2 0 0 1 2-2h7l5 5v11a2 2 0 0 1-2 2z">
                    </path>
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
