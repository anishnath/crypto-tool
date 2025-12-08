<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Tutorial Sidebar Component
    Navigation for HTML Tutorial lessons
    Uses currentLesson attribute to highlight active item
--%>
<%
    String currentLesson = (String) request.getAttribute("currentLesson");
    if (currentLesson == null) currentLesson = "";
%>
<aside class="tutorial-sidebar" id="sidebar">
    <div class="sidebar-header">
        <div class="sidebar-logo">
            <img src="<%=request.getContextPath()%>/tutorials/assets/images/html-logo.svg" alt="HTML" width="32" height="32">
        </div>
        <h2 class="sidebar-title">HTML Tutorial</h2>
    </div>

    <nav class="sidebar-nav">
        <%-- Module 1: Getting Started --%>
        <div class="nav-section">
            <div class="nav-section-title">Getting Started</div>
            <ul class="nav-items">
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/html/introduction.jsp" class="nav-link <%= "introduction".equals(currentLesson) ? "active" : "" %>" data-lesson="introduction">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"/>
                            <line x1="12" y1="16" x2="12" y2="12"/>
                            <line x1="12" y1="8" x2="12.01" y2="8"/>
                        </svg>
                        <span>Introduction</span>
                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor" style="display: none;" data-status="introduction">
                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                        </svg>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/html/editors.jsp" class="nav-link <%= "editors".equals(currentLesson) ? "active" : "" %>" data-lesson="editors">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="16 18 22 12 16 6"/>
                            <polyline points="8 6 2 12 8 18"/>
                        </svg>
                        <span>Editors</span>
                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor" style="display: none;" data-status="editors">
                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                        </svg>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/html/basic-structure.jsp" class="nav-link <%= "basic-structure".equals(currentLesson) ? "active" : "" %>" data-lesson="basic-structure">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="3" width="18" height="18" rx="2" ry="2"/>
                            <line x1="3" y1="9" x2="21" y2="9"/>
                            <line x1="9" y1="21" x2="9" y2="9"/>
                        </svg>
                        <span>Basic Structure</span>
                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor" style="display: none;" data-status="basic-structure">
                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                        </svg>
                    </a>
                </li>
            </ul>
        </div>

        <%-- Module 2: HTML Basics --%>
        <div class="nav-section">
            <div class="nav-section-title">HTML Basics</div>
            <ul class="nav-items">
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/html/elements.jsp" class="nav-link <%= "elements".equals(currentLesson) ? "active" : "" %>" data-lesson="elements">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M12 2L2 7l10 5 10-5-10-5z"/>
                            <path d="M2 17l10 5 10-5"/>
                            <path d="M2 12l10 5 10-5"/>
                        </svg>
                        <span>Elements</span>
                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor" style="display: none;" data-status="elements">
                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                        </svg>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/html/attributes.jsp" class="nav-link <%= "attributes".equals(currentLesson) ? "active" : "" %>" data-lesson="attributes">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="4" y1="21" x2="4" y2="14"/>
                            <line x1="4" y1="10" x2="4" y2="3"/>
                            <line x1="12" y1="21" x2="12" y2="12"/>
                            <line x1="12" y1="8" x2="12" y2="3"/>
                            <line x1="20" y1="21" x2="20" y2="16"/>
                            <line x1="20" y1="12" x2="20" y2="3"/>
                            <line x1="1" y1="14" x2="7" y2="14"/>
                            <line x1="9" y1="8" x2="15" y2="8"/>
                            <line x1="17" y1="16" x2="23" y2="16"/>
                        </svg>
                        <span>Attributes</span>
                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor" style="display: none;" data-status="attributes">
                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                        </svg>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/html/headings.jsp" class="nav-link <%= "headings".equals(currentLesson) ? "active" : "" %>" data-lesson="headings">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M4 12h8"/>
                            <path d="M4 18V6"/>
                            <path d="M12 18V6"/>
                            <path d="M17 10v8"/>
                            <path d="M21 10v8"/>
                            <path d="M17 14h4"/>
                        </svg>
                        <span>Headings</span>
                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor" style="display: none;" data-status="headings">
                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                        </svg>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/html/paragraphs.jsp" class="nav-link <%= "paragraphs".equals(currentLesson) ? "active" : "" %>" data-lesson="paragraphs">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="17" y1="10" x2="3" y2="10"/>
                            <line x1="21" y1="6" x2="3" y2="6"/>
                            <line x1="21" y1="14" x2="3" y2="14"/>
                            <line x1="17" y1="18" x2="3" y2="18"/>
                        </svg>
                        <span>Paragraphs</span>
                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor" style="display: none;" data-status="paragraphs">
                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                        </svg>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/html/formatting.jsp" class="nav-link <%= "formatting".equals(currentLesson) ? "active" : "" %>" data-lesson="formatting">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="4 7 4 4 20 4 20 7"/>
                            <line x1="9" y1="20" x2="15" y2="20"/>
                            <line x1="12" y1="4" x2="12" y2="20"/>
                        </svg>
                        <span>Formatting</span>
                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor" style="display: none;" data-status="formatting">
                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                        </svg>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/html/comments.jsp" class="nav-link <%= "comments".equals(currentLesson) ? "active" : "" %>" data-lesson="comments">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
                        </svg>
                        <span>Comments</span>
                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor" style="display: none;" data-status="comments">
                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                        </svg>
                    </a>
                </li>
            </ul>
        </div>

        <%-- Module 3: Links & Media --%>
        <div class="nav-section">
            <div class="nav-section-title">Links & Media</div>
            <ul class="nav-items">
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/html/links.jsp" class="nav-link <%= "links".equals(currentLesson) ? "active" : "" %>" data-lesson="links">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"/>
                            <path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"/>
                        </svg>
                        <span>Links</span>
                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor" style="display: none;" data-status="links">
                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                        </svg>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/html/images.jsp" class="nav-link <%= "images".equals(currentLesson) ? "active" : "" %>" data-lesson="images">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="3" width="18" height="18" rx="2" ry="2"/>
                            <circle cx="8.5" cy="8.5" r="1.5"/>
                            <polyline points="21 15 16 10 5 21"/>
                        </svg>
                        <span>Images</span>
                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor" style="display: none;" data-status="images">
                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                        </svg>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/html/audio-video.jsp" class="nav-link <%= "audio-video".equals(currentLesson) ? "active" : "" %>" data-lesson="audio-video">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polygon points="5 3 19 12 5 21 5 3"/>
                        </svg>
                        <span>Audio & Video</span>
                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor" style="display: none;" data-status="audio-video">
                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                        </svg>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/html/iframes.jsp" class="nav-link <%= "iframes".equals(currentLesson) ? "active" : "" %>" data-lesson="iframes">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="2" y="3" width="20" height="14" rx="2" ry="2"/>
                            <line x1="8" y1="21" x2="16" y2="21"/>
                            <line x1="12" y1="17" x2="12" y2="21"/>
                        </svg>
                        <span>Iframes</span>
                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor" style="display: none;" data-status="iframes">
                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                        </svg>
                    </a>
                </li>
            </ul>
        </div>

        <%-- Module 4: Lists & Tables --%>
        <div class="nav-section">
            <div class="nav-section-title">Lists & Tables</div>
            <ul class="nav-items">
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/html/lists.jsp" class="nav-link <%= "lists".equals(currentLesson) ? "active" : "" %>" data-lesson="lists">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="8" y1="6" x2="21" y2="6"/>
                            <line x1="8" y1="12" x2="21" y2="12"/>
                            <line x1="8" y1="18" x2="21" y2="18"/>
                            <line x1="3" y1="6" x2="3.01" y2="6"/>
                            <line x1="3" y1="12" x2="3.01" y2="12"/>
                            <line x1="3" y1="18" x2="3.01" y2="18"/>
                        </svg>
                        <span>Lists</span>
                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor" style="display: none;" data-status="lists">
                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                        </svg>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/html/tables.jsp" class="nav-link <%= "tables".equals(currentLesson) ? "active" : "" %>" data-lesson="tables">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="3" width="18" height="18" rx="2" ry="2"/>
                            <line x1="3" y1="9" x2="21" y2="9"/>
                            <line x1="3" y1="15" x2="21" y2="15"/>
                            <line x1="9" y1="3" x2="9" y2="21"/>
                            <line x1="15" y1="3" x2="15" y2="21"/>
                        </svg>
                        <span>Tables</span>
                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor" style="display: none;" data-status="tables">
                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                        </svg>
                    </a>
                </li>
            </ul>
        </div>

        <%-- Module 5: Forms --%>
        <div class="nav-section">
            <div class="nav-section-title">Forms</div>
            <ul class="nav-items">
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/html/forms.jsp" class="nav-link <%= "forms".equals(currentLesson) ? "active" : "" %>" data-lesson="forms">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                            <polyline points="14 2 14 8 20 8"/>
                            <line x1="16" y1="13" x2="8" y2="13"/>
                            <line x1="16" y1="17" x2="8" y2="17"/>
                            <polyline points="10 9 9 9 8 9"/>
                        </svg>
                        <span>Forms Basics</span>
                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor" style="display: none;" data-status="forms">
                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                        </svg>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/html/input-types.jsp" class="nav-link <%= "input-types".equals(currentLesson) ? "active" : "" %>" data-lesson="input-types">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="3" width="18" height="18" rx="2" ry="2"/>
                            <line x1="3" y1="9" x2="21" y2="9"/>
                        </svg>
                        <span>Input Types</span>
                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor" style="display: none;" data-status="input-types">
                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                        </svg>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/html/form-attributes.jsp" class="nav-link <%= "form-attributes".equals(currentLesson) ? "active" : "" %>" data-lesson="form-attributes">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="3"/>
                            <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"/>
                        </svg>
                        <span>Form Attributes</span>
                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor" style="display: none;" data-status="form-attributes">
                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                        </svg>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/html/form-validation.jsp" class="nav-link <%= "form-validation".equals(currentLesson) ? "active" : "" %>" data-lesson="form-validation">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="9 11 12 14 22 4"/>
                            <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/>
                        </svg>
                        <span>Form Validation</span>
                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor" style="display: none;" data-status="form-validation">
                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                        </svg>
                    </a>
                </li>
            </ul>
        </div>

        <%-- Module 6: Layout & Structure --%>
        <div class="nav-section">
            <div class="nav-section-title">Layout & Structure</div>
            <ul class="nav-items">
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/html/block-inline.jsp" class="nav-link <%= "block-inline".equals(currentLesson) ? "active" : "" %>" data-lesson="block-inline">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="3" width="7" height="7"/>
                            <rect x="14" y="3" width="7" height="7"/>
                            <rect x="14" y="14" width="7" height="7"/>
                            <rect x="3" y="14" width="7" height="7"/>
                        </svg>
                        <span>Block vs Inline</span>
                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor" style="display: none;" data-status="block-inline">
                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                        </svg>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/html/div-span.jsp" class="nav-link <%= "div-span".equals(currentLesson) ? "active" : "" %>" data-lesson="div-span">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="3" width="18" height="18" rx="2" ry="2"/>
                        </svg>
                        <span>Div & Span</span>
                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor" style="display: none;" data-status="div-span">
                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                        </svg>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/html/classes-ids.jsp" class="nav-link <%= "classes-ids".equals(currentLesson) ? "active" : "" %>" data-lesson="classes-ids">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"/>
                            <line x1="7" y1="7" x2="7.01" y2="7"/>
                        </svg>
                        <span>Classes & IDs</span>
                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor" style="display: none;" data-status="classes-ids">
                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                        </svg>
                    </a>
                </li>
            </ul>
        </div>

        <%-- Module 7: Semantic HTML --%>
        <div class="nav-section">
            <div class="nav-section-title">Semantic HTML</div>
            <ul class="nav-items">
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/html/semantic.jsp" class="nav-link <%= "semantic".equals(currentLesson) ? "active" : "" %>" data-lesson="semantic">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polygon points="12 2 2 7 12 12 22 7 12 2"/>
                            <polyline points="2 17 12 22 22 17"/>
                            <polyline points="2 12 12 17 22 12"/>
                        </svg>
                        <span>Semantic Elements</span>
                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor" style="display: none;" data-status="semantic">
                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                        </svg>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/html/page-layout.jsp" class="nav-link <%= "page-layout".equals(currentLesson) ? "active" : "" %>" data-lesson="page-layout">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="3" width="18" height="18" rx="2" ry="2"/>
                            <line x1="3" y1="9" x2="21" y2="9"/>
                            <line x1="9" y1="21" x2="9" y2="9"/>
                        </svg>
                        <span>Page Layout</span>
                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor" style="display: none;" data-status="page-layout">
                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                        </svg>
                    </a>
                </li>
            </ul>
        </div>

        <%-- Module 8: Advanced Topics --%>
        <div class="nav-section">
            <div class="nav-section-title">Advanced Topics</div>
            <ul class="nav-items">
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/html/entities.jsp" class="nav-link <%= "entities".equals(currentLesson) ? "active" : "" %>" data-lesson="entities">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"/>
                            <line x1="12" y1="8" x2="12" y2="12"/>
                            <line x1="12" y1="16" x2="12.01" y2="16"/>
                        </svg>
                        <span>HTML Entities</span>
                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor" style="display: none;" data-status="entities">
                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                        </svg>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/html/meta-seo.jsp" class="nav-link <%= "meta-seo".equals(currentLesson) ? "active" : "" %>" data-lesson="meta-seo">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="11" cy="11" r="8"/>
                            <line x1="21" y1="21" x2="16.65" y2="16.65"/>
                        </svg>
                        <span>Meta Tags & SEO</span>
                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor" style="display: none;" data-status="meta-seo">
                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                        </svg>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/html/accessibility.jsp" class="nav-link <%= "accessibility".equals(currentLesson) ? "active" : "" %>" data-lesson="accessibility">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"/>
                            <circle cx="12" cy="7" r="1"/>
                            <path d="M12 10v7"/>
                            <path d="M8 14l4-2 4 2"/>
                        </svg>
                        <span>Accessibility</span>
                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor" style="display: none;" data-status="accessibility">
                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                        </svg>
                    </a>
                </li>
            </ul>
        </div>

        <%-- Sidebar Ad (Desktop only) --%>
<%--        <div class="sidebar-ad-container" style="padding: var(--space-4); margin-top: var(--space-4);">--%>
<%--            <%@ include file="ads/ad-sidebar.jsp" %>--%>
<%--        </div>--%>
    </nav>
</aside>
