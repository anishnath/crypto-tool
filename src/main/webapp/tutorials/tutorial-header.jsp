<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Tutorial Header Component
    Contains: Logo, Menu Button, Progress Bar, Theme Toggle
--%>
<header class="tutorial-header">
    <%-- Left Section --%>
    <div class="header-left">
        <%-- Mobile Menu Button --%>
        <button class="menu-btn" id="menuBtn" onclick="toggleSidebar()" aria-label="Toggle navigation menu">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <line x1="3" y1="6" x2="21" y2="6"/>
                <line x1="3" y1="12" x2="21" y2="12"/>
                <line x1="3" y1="18" x2="21" y2="18"/>
            </svg>
        </button>

        <%-- Logo --%>
        <a href="<%=request.getContextPath()%>/tutorials/" class="logo">
            <div class="logo-icon">
                <?xml version="1.0" encoding="UTF-8"?>
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" width="512" height="512" role="img" aria-labelledby="title desc">
                    <title id="title">8gwifi Logo</title>
                    <desc id="desc">A clean circular mark with 8g monogram and wifi waves</desc>
                    <defs>
                        <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
                            <stop offset="0%" stop-color="#38bdf8"/>
                            <stop offset="100%" stop-color="#0284c7"/>
                        </linearGradient>
                        <filter id="softShadow" x="-20%" y="-20%" width="140%" height="140%">
                            <feDropShadow dx="0" dy="6" stdDeviation="8" flood-color="#0b1324" flood-opacity="0.18"/>
                        </filter>
                    </defs>

                    <!-- Background circle -->
                    <circle cx="256" cy="256" r="224" fill="url(#bg)" filter="url(#softShadow)"/>

                    <!-- Monogram group -->
                    <g fill="#ffffff" transform="translate(0,0)">
                        <!-- 8: two rings -->
                        <g transform="translate(190,170)">
                            <circle cx="0" cy="0" r="52"/>
                            <circle cx="0" cy="0" r="30" fill="url(#bg)"/>
                            <circle cx="0" cy="100" r="52"/>
                            <circle cx="0" cy="100" r="30" fill="url(#bg)"/>
                        </g>

                        <!-- g: ring plus tail -->
                        <g transform="translate(300,210)">
                            <!-- bowl -->
                            <circle cx="0" cy="60" r="56"/>
                            <circle cx="0" cy="60" r="34" fill="url(#bg)"/>
                            <!-- tail -->
                            <rect x="38" y="90" width="18" height="58" rx="9"/>
                            <rect x="8" y="132" width="48" height="18" rx="9"/>
                        </g>

                        <!-- wifi waves -->
                        <g transform="translate(340,120)" fill="none" stroke="#ffffff" stroke-width="14" stroke-linecap="round">
                            <path d="M 0 80 A 80 80 0 0 1 80 160" opacity="0.28"/>
                            <path d="M 0 50 A 50 50 0 0 1 50 100" opacity="0.52"/>
                            <path d="M 0 22 A 22 22 0 0 1 22 44" opacity="0.9"/>
                        </g>
                    </g>

                    <!-- subtle highlight -->
                    <ellipse cx="200" cy="170" rx="140" ry="70" fill="#ffffff" opacity="0.06"/>
                </svg>
            </div>
            <span class="logo-text">8gwifi.org <span style="font-weight: 400; color: var(--text-secondary);">Tutorials</span></span>
        </a>
    </div>

    <%-- Center Section (empty for now, can add search later) --%>
    <div class="header-center">
        <%-- Search can be added here in future --%>
    </div>

    <%-- Right Section --%>
    <div class="header-right">
        <%-- Support & Social Buttons --%>
        <div class="header-social">
            <a href="https://buymeacoffee.com/8gwifi.org"
               target="_blank"
               rel="noopener"
               class="header-btn header-btn-coffee"
               aria-label="Buy me a coffee">
                <span class="btn-icon">☕</span>
                <span class="btn-text">Coffee</span>
            </a>
            <a href="https://twitter.com/anish2good"
               target="_blank"
               rel="noopener"
               class="header-btn header-btn-twitter"
               aria-label="Follow on Twitter">
                <span class="btn-icon">𝕏</span>
                <span class="btn-text">Follow</span>
            </a>
            <button class="header-btn header-btn-share"
                    onclick="openShareMenu()"
                    aria-label="Share this tutorial">
                <span class="btn-icon">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="18" cy="5" r="3"/>
                        <circle cx="6" cy="12" r="3"/>
                        <circle cx="18" cy="19" r="3"/>
                        <line x1="8.59" y1="13.51" x2="15.42" y2="17.49"/>
                        <line x1="15.41" y1="6.51" x2="8.59" y2="10.49"/>
                    </svg>
                </span>
                <span class="btn-text">Share</span>
            </button>
        </div>

        <%-- Progress Indicator --%>
        <div class="header-progress" id="headerProgress">
            <div class="progress-bar">
                <div class="progress-fill" id="progressFill" style="width: 0%"></div>
            </div>
            <span id="progressText">0%</span>
        </div>

        <%-- Theme Toggle --%>
        <button class="theme-toggle" id="themeToggle" onclick="toggleTheme()" aria-label="Toggle dark mode">
            <%-- Sun icon (shown in dark mode) --%>
            <svg class="theme-icon-light" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display: none;">
                <circle cx="12" cy="12" r="5"/>
                <line x1="12" y1="1" x2="12" y2="3"/>
                <line x1="12" y1="21" x2="12" y2="23"/>
                <line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/>
                <line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/>
                <line x1="1" y1="12" x2="3" y2="12"/>
                <line x1="21" y1="12" x2="23" y2="12"/>
                <line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/>
                <line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/>
            </svg>
            <%-- Moon icon (shown in light mode) --%>
            <svg class="theme-icon-dark" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/>
            </svg>
        </button>
    </div>
</header>
