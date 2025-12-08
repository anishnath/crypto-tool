<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% String currentLesson=(String) request.getAttribute("currentLesson"); if (currentLesson==null) { currentLesson=""
        ; } %>
        <nav class="tutorial-sidebar" id="tutorialSidebar">
            <div class="sidebar-header">
                <div class="sidebar-logo">
                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/javascript-logo.svg" alt="JavaScript" width="32" height="32">
                </div>
                <h2 class="sidebar-title">JavaScript Tutorial</h2>
                <button class="btn btn-ghost btn-icon sidebar-close" onclick="toggleSidebar()"
                    aria-label="Close sidebar">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="18" y1="6" x2="6" y2="18" />
                        <line x1="6" y1="6" x2="18" y2="18" />
                    </svg>
                </button>
            </div>

            <div class="sidebar-content">
                <div class="nav-sections">
                    <%-- Module 1: Getting Started --%>
                        <div class="nav-section">
                            <div class="nav-section-title">Getting Started</div>
                            <ul class="nav-items">
                                <li class="nav-item">
                                    <a href="<%=request.getContextPath()%>/tutorials/javascript/introduction.jsp"
                                        class="nav-link <%= " introduction".equals(currentLesson) ? "active" : "" %>"
                                        data-lesson="introduction">
                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                            stroke-width="2">
                                            <circle cx="12" cy="12" r="10" />
                                            <path d="M12 16v-4M12 8h.01" />
                                        </svg>
                                        <span>Introduction</span>
                                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                            style="display: none;" data-status="introduction">
                                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                        </svg>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="<%=request.getContextPath()%>/tutorials/javascript/adding-javascript.jsp"
                                        class="nav-link <%= " adding-javascript".equals(currentLesson) ? "active" : ""
                                        %>"
                                        data-lesson="adding-javascript">
                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                            stroke-width="2">
                                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                                            <polyline points="14 2 14 8 20 8" />
                                            <line x1="12" y1="18" x2="12" y2="12" />
                                            <line x1="9" y1="15" x2="15" y2="15" />
                                        </svg>
                                        <span>Adding JavaScript</span>
                                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                            style="display: none;" data-status="adding-javascript">
                                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                        </svg>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="<%=request.getContextPath()%>/tutorials/javascript/console-debugging.jsp"
                                        class="nav-link <%= " console-debugging".equals(currentLesson) ? "active" : ""
                                        %>"
                                        data-lesson="console-debugging">
                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                            stroke-width="2">
                                            <polyline points="4 17 10 11 4 5" />
                                            <line x1="12" y1="19" x2="20" y2="19" />
                                        </svg>
                                        <span>Console & Debugging</span>
                                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                            style="display: none;" data-status="console-debugging">
                                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                        </svg>
                                    </a>
                                </li>
                            </ul>
                        </div>

                        <%-- Module 2: Fundamentals --%>
                            <div class="nav-section">
                                <div class="nav-section-title">Fundamentals</div>
                                <ul class="nav-items">
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/javascript/variables.jsp"
                                            class="nav-link <%= " variables".equals(currentLesson) ? "active" : "" %>"
                                            data-lesson="variables">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <path
                                                    d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
                                            </svg>
                                            <span>Variables</span>
                                            <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                style="display: none;" data-status="variables">
                                                <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                            </svg>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/javascript/data-types.jsp"
                                            class="nav-link <%= " data-types".equals(currentLesson) ? "active" : "" %>"
                                            data-lesson="data-types">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <path
                                                    d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
                                            </svg>
                                            <span>Data Types</span>
                                            <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                style="display: none;" data-status="data-types">
                                                <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                            </svg>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/javascript/operators.jsp"
                                            class="nav-link <%= " operators".equals(currentLesson) ? "active" : "" %>"
                                            data-lesson="operators">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <path d="M12 19l7-7 3 3-7 7-3-3z" />
                                                <path d="M18 13l-1.5-7.5L2 2l3.5 14.5L13 18l5-5z" />
                                                <path d="M2 2l7.586 7.586" />
                                                <circle cx="11" cy="11" r="2" />
                                            </svg>
                                            <span>Operators</span>
                                            <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                style="display: none;" data-status="operators">
                                                <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                            </svg>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/javascript/strings.jsp"
                                            class="nav-link <%= " strings".equals(currentLesson) ? "active" : "" %>"
                                            data-lesson="strings">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <path d="M4 7V4h16v3" />
                                                <path d="M9 20h6" />
                                                <path d="M12 4v16" />
                                            </svg>
                                            <span>Strings</span>
                                            <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                style="display: none;" data-status="strings">
                                                <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                            </svg>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/javascript/numbers-math.jsp"
                                            class="nav-link <%= " numbers-math".equals(currentLesson) ? "active" : ""
                                            %>"
                                            data-lesson="numbers-math">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <rect x="4" y="4" width="16" height="16" rx="2" ry="2" />
                                                <rect x="9" y="9" width="6" height="6" />
                                                <line x1="9" y1="1" x2="9" y2="4" />
                                                <line x1="15" y1="1" x2="15" y2="4" />
                                                <line x1="9" y1="20" x2="9" y2="23" />
                                                <line x1="15" y1="20" x2="15" y2="23" />
                                                <line x1="20" y1="9" x2="23" y2="9" />
                                                <line x1="20" y1="14" x2="23" y2="14" />
                                                <line x1="1" y1="9" x2="4" y2="9" />
                                                <line x1="1" y1="14" x2="4" y2="14" />
                                            </svg>
                                            <span>Numbers & Math</span>
                                            <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                style="display: none;" data-status="numbers-math">
                                                <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                            </svg>
                                        </a>
                                    </li>
                                </ul>
                            </div>

                            <%-- Placeholder modules --%>
                                <%-- Module 3: Control Flow --%>
                                    <div class="nav-section">
                                        <div class="nav-section-title">Control Flow</div>
                                        <ul class="nav-items">
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/javascript/conditionals.jsp"
                                                    class="nav-link <%= " conditionals".equals(currentLesson) ? "active"
                                                    : "" %>"
                                                    data-lesson="conditionals">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <path d="M6 9l6 6 6-6" />
                                                    </svg>
                                                    <span>Conditionals</span>
                                                    <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                        style="display: none;" data-status="conditionals">
                                                        <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                    </svg>
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/javascript/loops.jsp"
                                                    class="nav-link <%= " loops".equals(currentLesson) ? "active" : ""
                                                    %>"
                                                    data-lesson="loops">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <path
                                                            d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
                                                    </svg>
                                                    <span>Loops</span>
                                                    <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                        style="display: none;" data-status="loops">
                                                        <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                    </svg>
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/javascript/functions.jsp"
                                                    class="nav-link <%= " functions".equals(currentLesson) ? "active"
                                                    : "" %>"
                                                    data-lesson="functions">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <path d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4" />
                                                    </svg>
                                                    <span>Functions</span>
                                                    <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                        style="display: none;" data-status="functions">
                                                        <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                    </svg>
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/javascript/scope-closures.jsp"
                                                    class="nav-link <%= " scope-closures".equals(currentLesson)
                                                    ? "active" : "" %>"
                                                    data-lesson="scope-closures">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                                                        <path d="M9 3v18" />
                                                        <path d="M15 3v18" />
                                                        <path d="M3 9h18" />
                                                        <path d="M3 15h18" />
                                                    </svg>
                                                    <span>Scope & Closures</span>
                                                    <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                        style="display: none;" data-status="scope-closures">
                                                        <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                    </svg>
                                                </a>
                                            </li>
                                        </ul>
                                    </div>

                                    <%-- Module 4: Data Structures --%>
                                        <div class="nav-section">
                                            <div class="nav-section-title">Data Structures</div>
                                            <ul class="nav-items">
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/javascript/arrays.jsp"
                                                        class="nav-link <%= " arrays".equals(currentLesson) ? "active"
                                                        : "" %>"
                                                        data-lesson="arrays">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <path d="M4 6h16M4 10h16M4 14h16M4 18h16" />
                                                        </svg>
                                                        <span>Arrays</span>
                                                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                            style="display: none;" data-status="arrays">
                                                            <path
                                                                d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                        </svg>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/javascript/array-methods.jsp"
                                                        class="nav-link <%= " array-methods".equals(currentLesson)
                                                        ? "active" : "" %>"
                                                        data-lesson="array-methods">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <path d="M12 20h9" />
                                                            <path
                                                                d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z" />
                                                        </svg>
                                                        <span>Array Methods</span>
                                                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                            style="display: none;" data-status="array-methods">
                                                            <path
                                                                d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                        </svg>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/javascript/objects.jsp"
                                                        class="nav-link <%= " objects".equals(currentLesson) ? "active"
                                                        : "" %>"
                                                        data-lesson="objects">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <path
                                                                d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
                                                            <polyline points="3.27 6.96 12 12.01 20.73 6.96" />
                                                            <line x1="12" y1="22.08" x2="12" y2="12" />
                                                        </svg>
                                                        <span>Objects</span>
                                                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                            style="display: none;" data-status="objects">
                                                            <path
                                                                d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                        </svg>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/javascript/object-methods.jsp"
                                                        class="nav-link <%= " object-methods".equals(currentLesson)
                                                        ? "active" : "" %>"
                                                        data-lesson="object-methods">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <circle cx="12" cy="12" r="3" />
                                                            <path
                                                                d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z" />
                                                        </svg>
                                                        <span>Object Methods</span>
                                                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                            style="display: none;" data-status="object-methods">
                                                            <path
                                                                d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                        </svg>
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>

                                        <%-- Module 5: DOM Manipulation --%>
                                            <div class="nav-section">
                                                <div class="nav-section-title">DOM Manipulation</div>
                                                <ul class="nav-items">
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/javascript/dom-selectors.jsp"
                                                            class="nav-link <%= " dom-selectors".equals(currentLesson)
                                                            ? "active" : "" %>"
                                                            data-lesson="dom-selectors">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <circle cx="11" cy="11" r="8" />
                                                                <line x1="21" y1="21" x2="16.65" y2="16.65" />
                                                            </svg>
                                                            <span>Selecting Elements</span>
                                                            <svg class="nav-status" viewBox="0 0 24 24"
                                                                fill="currentColor" style="display: none;"
                                                                data-status="dom-selectors">
                                                                <path
                                                                    d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                            </svg>
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/javascript/dom-modify.jsp"
                                                            class="nav-link <%= " dom-modify".equals(currentLesson)
                                                            ? "active" : "" %>"
                                                            data-lesson="dom-modify">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <path
                                                                    d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                                                <path
                                                                    d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                                                            </svg>
                                                            <span>Modifying Elements</span>
                                                            <svg class="nav-status" viewBox="0 0 24 24"
                                                                fill="currentColor" style="display: none;"
                                                                data-status="dom-modify">
                                                                <path
                                                                    d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                            </svg>
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/javascript/dom-create.jsp"
                                                            class="nav-link <%= " dom-create".equals(currentLesson)
                                                            ? "active" : "" %>"
                                                            data-lesson="dom-create">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <line x1="12" y1="5" x2="12" y2="19" />
                                                                <line x1="5" y1="12" x2="19" y2="12" />
                                                            </svg>
                                                            <span>Creating Elements</span>
                                                            <svg class="nav-status" viewBox="0 0 24 24"
                                                                fill="currentColor" style="display: none;"
                                                                data-status="dom-create">
                                                                <path
                                                                    d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                            </svg>
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/javascript/events.jsp"
                                                            class="nav-link <%= " events".equals(currentLesson)
                                                            ? "active" : "" %>"
                                                            data-lesson="events">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z" />
                                                            </svg>
                                                            <span>Events</span>
                                                            <svg class="nav-status" viewBox="0 0 24 24"
                                                                fill="currentColor" style="display: none;"
                                                                data-status="events">
                                                                <path
                                                                    d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                            </svg>
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/javascript/event-listeners.jsp"
                                                            class="nav-link <%= " event-listeners".equals(currentLesson)
                                                            ? "active" : "" %>"
                                                            data-lesson="event-listeners">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9" />
                                                                <path d="M13.73 21a2 2 0 0 1-3.46 0" />
                                                            </svg>
                                                            <span>Event Listeners</span>
                                                            <svg class="nav-status" viewBox="0 0 24 24"
                                                                fill="currentColor" style="display: none;"
                                                                data-status="event-listeners">
                                                                <path
                                                                    d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                            </svg>
                                                        </a>
                                                    </li>
                                                </ul>
                                            </div>

                                            <%-- Module 6: Advanced Concepts --%>
                                                <div class="nav-section">
                                                    <div class="nav-section-title">Advanced Concepts</div>
                                                    <ul class="nav-items">
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/javascript/this-keyword.jsp"
                                                                class="nav-link <%= "this-keyword".equals(currentLesson) ? "active" : "" %>"
                                                                data-lesson="this-keyword">
                                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <circle cx="12" cy="12" r="10" />
                                                                    <circle cx="12" cy="12" r="3" />
                                                                </svg>
                                                                <span>This Keyword</span>
                                                                <svg class="nav-status" viewBox="0 0 24 24"
                                                                    fill="currentColor" style="display: none;"
                                                                    data-status="this-keyword">
                                                                    <path
                                                                        d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                                </svg>
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/javascript/prototypes.jsp"
                                                                class="nav-link <%= " prototypes".equals(currentLesson)
                                                                ? "active" : "" %>"
                                                                data-lesson="prototypes">
                                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <rect x="2" y="7" width="20" height="14" rx="2"
                                                                        ry="2" />
                                                                    <path
                                                                        d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16" />
                                                                </svg>
                                                                <span>Prototypes</span>
                                                                <svg class="nav-status" viewBox="0 0 24 24"
                                                                    fill="currentColor" style="display: none;"
                                                                    data-status="prototypes">
                                                                    <path
                                                                        d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                                </svg>
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/javascript/classes.jsp"
                                                                class="nav-link <%= " classes".equals(currentLesson)
                                                                ? "active" : "" %>"
                                                                data-lesson="classes">
                                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <path d="M3 21h18" />
                                                                    <path d="M5 21V7l8-4 8 4v14" />
                                                                    <path d="M17 21v-8H7v8" />
                                                                </svg>
                                                                <span>Classes</span>
                                                                <svg class="nav-status" viewBox="0 0 24 24"
                                                                    fill="currentColor" style="display: none;"
                                                                    data-status="classes">
                                                                    <path
                                                                        d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                                </svg>
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/javascript/async-basics.jsp"
                                                                class="nav-link <%= "async-basics".equals(currentLesson) ? "active" : "" %>"
                                                                data-lesson="async-basics">
                                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <circle cx="12" cy="12" r="10" />
                                                                    <polyline points="12 6 12 12 16 14" />
                                                                </svg>
                                                                <span>Async Basics</span>
                                                                <svg class="nav-status" viewBox="0 0 24 24"
                                                                    fill="currentColor" style="display: none;"
                                                                    data-status="async-basics">
                                                                    <path
                                                                        d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                                </svg>
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/javascript/promises.jsp"
                                                                class="nav-link <%= " promises".equals(currentLesson)
                                                                ? "active" : "" %>"
                                                                data-lesson="promises">
                                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <path
                                                                        d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6" />
                                                                    <polyline points="15 3 21 3 21 9" />
                                                                    <line x1="10" y1="14" x2="21" y2="3" />
                                                                </svg>
                                                                <span>Promises</span>
                                                                <svg class="nav-status" viewBox="0 0 24 24"
                                                                    fill="currentColor" style="display: none;"
                                                                    data-status="promises">
                                                                    <path
                                                                        d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                                </svg>
                                                            </a>
                                                        </li>
                                                    </ul>
                                                </div>

                                                <%-- Module 7: Modern JavaScript --%>
                                                    <div class="nav-section">
                                                        <div class="nav-section-title">Modern JavaScript</div>
                                                        <ul class="nav-items">
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/javascript/async-await.jsp"
                                                                    class="nav-link <%= "async-await".equals(currentLesson) ? "active" : ""
                                                                    %>"
                                                                    data-lesson="async-await">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <polyline points="4 17 10 11 4 5" />
                                                                        <line x1="12" y1="19" x2="20" y2="19" />
                                                                    </svg>
                                                                    <span>Async/Await</span>
                                                                    <svg class="nav-status" viewBox="0 0 24 24"
                                                                        fill="currentColor" style="display: none;"
                                                                        data-status="async-await">
                                                                        <path
                                                                            d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                                    </svg>
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/javascript/modules.jsp"
                                                                    class="nav-link <%= " modules".equals(currentLesson)
                                                                    ? "active" : "" %>"
                                                                    data-lesson="modules">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <rect x="3" y="3" width="7" height="7" />
                                                                        <rect x="14" y="3" width="7" height="7" />
                                                                        <rect x="14" y="14" width="7" height="7" />
                                                                        <rect x="3" y="14" width="7" height="7" />
                                                                    </svg>
                                                                    <span>Modules</span>
                                                                    <svg class="nav-status" viewBox="0 0 24 24"
                                                                        fill="currentColor" style="display: none;"
                                                                        data-status="modules">
                                                                        <path
                                                                            d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                                    </svg>
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/javascript/destructuring.jsp"
                                                                    class="nav-link <%= "destructuring".equals(currentLesson) ? "active" : ""
                                                                    %>"
                                                                    data-lesson="destructuring">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <path
                                                                            d="M4 12v8a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-8" />
                                                                        <polyline points="16 6 12 2 8 6" />
                                                                        <line x1="12" y1="2" x2="12" y2="15" />
                                                                    </svg>
                                                                    <span>Destructuring</span>
                                                                    <svg class="nav-status" viewBox="0 0 24 24"
                                                                        fill="currentColor" style="display: none;"
                                                                        data-status="destructuring">
                                                                        <path
                                                                            d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                                    </svg>
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/javascript/array-advanced.jsp"
                                                                    class="nav-link <%= "array-advanced".equals(currentLesson) ? "active"
                                                                    : "" %>"
                                                                    data-lesson="array-advanced">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <path d="M8 6h13" />
                                                                        <path d="M8 12h13" />
                                                                        <path d="M8 18h13" />
                                                                        <path d="M3 6h.01" />
                                                                        <path d="M3 12h.01" />
                                                                        <path d="M3 18h.01" />
                                                                    </svg>
                                                                    <span>Array Advanced</span>
                                                                    <svg class="nav-status" viewBox="0 0 24 24"
                                                                        fill="currentColor" style="display: none;"
                                                                        data-status="array-advanced">
                                                                        <path
                                                                            d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                                    </svg>
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/javascript/string-advanced.jsp"
                                                                    class="nav-link <%= "string-advanced".equals(currentLesson) ? "active"
                                                                    : "" %>"
                                                                    data-lesson="string-advanced">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <path d="M4 7V4h16v3" />
                                                                        <path d="M9 20h6" />
                                                                        <path d="M12 4v16" />
                                                                    </svg>
                                                                    <span>String Advanced</span>
                                                                    <svg class="nav-status" viewBox="0 0 24 24"
                                                                        fill="currentColor" style="display: none;"
                                                                        data-status="string-advanced">
                                                                        <path
                                                                            d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                                    </svg>
                                                                </a>
                                                            </li>
                                                        </ul>
                                                    </div>

                                                    <%-- Module 8: Practical Topics --%>
                                                        <div class="nav-section">
                                                            <div class="nav-section-title">Practical Topics</div>
                                                            <ul class="nav-items">
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/javascript/error-handling.jsp"
                                                                        class="nav-link <%= "error-handling".equals(currentLesson) ? "active"
                                                                        : "" %>"
                                                                        data-lesson="error-handling">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <polygon
                                                                                points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
                                                                        </svg>
                                                                        <span>Error Handling</span>
                                                                        <svg class="nav-status" viewBox="0 0 24 24"
                                                                            fill="currentColor" style="display: none;"
                                                                            data-status="error-handling">
                                                                            <path
                                                                                d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                                        </svg>
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/javascript/json.jsp"
                                                                        class="nav-link <%= "json".equals(currentLesson) ? "active" : "" %>"
                                                                        data-lesson="json">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <path
                                                                                d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                                                                            <polyline points="14 2 14 8 20 8" />
                                                                            <line x1="16" y1="13" x2="8" y2="13" />
                                                                            <line x1="16" y1="17" x2="8" y2="17" />
                                                                            <polyline points="10 9 9 9 8 9" />
                                                                        </svg>
                                                                        <span>JSON</span>
                                                                        <svg class="nav-status" viewBox="0 0 24 24"
                                                                            fill="currentColor" style="display: none;"
                                                                            data-status="json">
                                                                            <path
                                                                                d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                                        </svg>
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/javascript/local-storage.jsp"
                                                                        class="nav-link <%= "local-storage".equals(currentLesson) ? "active"
                                                                        : "" %>"
                                                                        data-lesson="local-storage">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <path
                                                                                d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                                                                            <polyline points="7 10 12 15 17 10" />
                                                                            <line x1="12" y1="15" x2="12" y2="3" />
                                                                        </svg>
                                                                        <span>Local Storage</span>
                                                                        <svg class="nav-status" viewBox="0 0 24 24"
                                                                            fill="currentColor" style="display: none;"
                                                                            data-status="local-storage">
                                                                            <path
                                                                                d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                                        </svg>
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/javascript/best-practices.jsp"
                                                                        class="nav-link <%= "best-practices".equals(currentLesson) ? "active"
                                                                        : "" %>"
                                                                        data-lesson="best-practices">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <path
                                                                                d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
                                                                            <polyline points="22 4 12 14.01 9 11.01" />
                                                                        </svg>
                                                                        <span>Best Practices</span>
                                                                        <svg class="nav-status" viewBox="0 0 24 24"
                                                                            fill="currentColor" style="display: none;"
                                                                            data-status="best-practices">
                                                                            <path
                                                                                d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                                        </svg>
                                                                    </a>
                                                                </li>
                                                            </ul>
                                                        </div>
                </div>

                <%-- Ad Slot: Sidebar (Sticky Bottom) --%>
                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="sidebar" />
                    </jsp:include>
            </div>
        </nav>