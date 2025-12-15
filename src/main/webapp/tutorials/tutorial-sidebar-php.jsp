<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <%-- Tutorial Sidebar Component - PHP Navigation --%>
                <% String currentLesson=(String) request.getAttribute("currentLesson"); if (currentLesson==null)
                        currentLesson="" ; %>
                        <aside class="tutorial-sidebar" id="sidebar">
                                <div class="sidebar-header">
                                        <div class="sidebar-logo">
                                                <img src="<%=request.getContextPath()%>/tutorials/assets/images/php-logo.svg"
                                                        alt="PHP" width="32" height="32">
                                        </div>
                                        <h2 class="sidebar-title">PHP Tutorial</h2>
                                </div>

                                <nav class="sidebar-nav">
                                        <%-- Module 1: Getting Started --%>
                                                <div class="nav-section">
                                                        <div class="nav-section-title">Getting Started</div>
                                                        <ul class="nav-items">
                                                                <li class="nav-item"><a
                                                                                href="<%=request.getContextPath()%>/tutorials/php/intro.jsp"
                                                                                class="nav-link <%= "intro".equals(currentLesson) ? "active"
                                                                                : "" %>"
                                                                                data-lesson="intro"><svg
                                                                                        class="nav-icon"
                                                                                        viewBox="0 0 24 24" fill="none"
                                                                                        stroke="currentColor"
                                                                                        stroke-width="2">
                                                                                        <circle cx="12" cy="12"
                                                                                                r="10" />
                                                                                        <polygon
                                                                                                points="10 8 16 12 10 16 10 8" />
                                                                                </svg><span>Introduction</span></a></li>
                                                                <li class="nav-item"><a
                                                                                href="<%=request.getContextPath()%>/tutorials/php/installation.jsp"
                                                                                class="nav-link <%= "installation".equals(currentLesson)
                                                                                ? "active" : "" %>"
                                                                                data-lesson="installation"><svg
                                                                                        class="nav-icon"
                                                                                        viewBox="0 0 24 24" fill="none"
                                                                                        stroke="currentColor"
                                                                                        stroke-width="2">
                                                                                        <path
                                                                                                d="M21 16V8a2 2 0 00-1-1.73l-7-4a2 2 0 00-2 0l-7 4A2 2 0 003 8v8a2 2 0 001 1.73l7 4a2 2 0 002 0l7-4A2 2 0 0021 16z" />
                                                                                </svg><span>Installation</span></a></li>
                                                                <li class="nav-item"><a
                                                                                href="<%=request.getContextPath()%>/tutorials/php/first-program.jsp"
                                                                                class="nav-link <%= "first-program".equals(currentLesson)
                                                                                ? "active" : "" %>"
                                                                                data-lesson="first-program"><svg
                                                                                        class="nav-icon"
                                                                                        viewBox="0 0 24 24" fill="none"
                                                                                        stroke="currentColor"
                                                                                        stroke-width="2">
                                                                                        <path
                                                                                                d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z" />
                                                                                        <polyline
                                                                                                points="14 2 14 8 20 8" />
                                                                                </svg><span>First Program</span></a>
                                                                </li>
                                                                <li class="nav-item"><a
                                                                                href="<%=request.getContextPath()%>/tutorials/php/syntax-basics.jsp"
                                                                                class="nav-link <%= "syntax-basics".equals(currentLesson)
                                                                                ? "active" : "" %>"
                                                                                data-lesson="syntax-basics"><svg
                                                                                        class="nav-icon"
                                                                                        viewBox="0 0 24 24" fill="none"
                                                                                        stroke="currentColor"
                                                                                        stroke-width="2">
                                                                                        <polyline
                                                                                                points="16 18 22 12 16 6" />
                                                                                        <polyline
                                                                                                points="8 6 2 12 8 18" />
                                                                                </svg><span>Syntax Basics</span></a>
                                                                </li>
                                                        </ul>
                                                </div>

                                                <%-- Module 2: Variables & Data Types --%>
                                                        <div class="nav-section">
                                                                <div class="nav-section-title">Variables & Data Types
                                                                </div>
                                                                <ul class="nav-items">
                                                                        <li class="nav-item"><a
                                                                                        href="<%=request.getContextPath()%>/tutorials/php/variables-basics.jsp"
                                                                                        class="nav-link <%= "variables-basics".equals(currentLesson)
                                                                                        ? "active" : "" %>"><svg
                                                                                                class="nav-icon"
                                                                                                viewBox="0 0 24 24"
                                                                                                fill="none"
                                                                                                stroke="currentColor"
                                                                                                stroke-width="2">
                                                                                                <path d="M4 7V4h16v3" />
                                                                                                <path d="M9 20h6" />
                                                                                                <path d="M12 4v16" />
                                                                                        </svg><span>Variables</span></a>
                                                                        </li>
                                                                        <li class="nav-item"><a
                                                                                        href="<%=request.getContextPath()%>/tutorials/php/types-overview.jsp"
                                                                                        class="nav-link <%= "types-overview".equals(currentLesson)
                                                                                        ? "active" : "" %>"><svg
                                                                                                class="nav-icon"
                                                                                                viewBox="0 0 24 24"
                                                                                                fill="none"
                                                                                                stroke="currentColor"
                                                                                                stroke-width="2">
                                                                                                <rect x="3" y="3"
                                                                                                        width="7"
                                                                                                        height="7" />
                                                                                                <rect x="14" y="3"
                                                                                                        width="7"
                                                                                                        height="7" />
                                                                                                <rect x="14" y="14"
                                                                                                        width="7"
                                                                                                        height="7" />
                                                                                                <rect x="3" y="14"
                                                                                                        width="7"
                                                                                                        height="7" />
                                                                                        </svg><span>Data
                                                                                                Types</span></a></li>
                                                                        <li class="nav-item"><a
                                                                                        href="<%=request.getContextPath()%>/tutorials/php/types-juggling.jsp"
                                                                                        class="nav-link <%= "types-juggling".equals(currentLesson)
                                                                                        ? "active" : "" %>"><svg
                                                                                                class="nav-icon"
                                                                                                viewBox="0 0 24 24"
                                                                                                fill="none"
                                                                                                stroke="currentColor"
                                                                                                stroke-width="2">
                                                                                                <path
                                                                                                        d="M17 1l4 4-4 4" />
                                                                                                <path
                                                                                                        d="M3 11V9a4 4 0 014-4h14" />
                                                                                                <path
                                                                                                        d="M7 23l-4-4 4-4" />
                                                                                                <path
                                                                                                        d="M21 13v2a4 4 0 01-4 4H3" />
                                                                                        </svg><span>Type
                                                                                                Juggling</span></a></li>
                                                                        <li class="nav-item"><a
                                                                                        href="<%=request.getContextPath()%>/tutorials/php/strings-basics.jsp"
                                                                                        class="nav-link <%= "strings-basics".equals(currentLesson)
                                                                                        ? "active" : "" %>"><svg
                                                                                                class="nav-icon"
                                                                                                viewBox="0 0 24 24"
                                                                                                fill="none"
                                                                                                stroke="currentColor"
                                                                                                stroke-width="2">
                                                                                                <path
                                                                                                        d="M17 6H7c-1.1 0-2 .9-2 2v8c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2z" />
                                                                                                <path
                                                                                                        d="M8 10h8M8 14h5" />
                                                                                        </svg><span>Strings</span></a>
                                                                        </li>
                                                                        <li class="nav-item"><a
                                                                                        href="<%=request.getContextPath()%>/tutorials/php/strings-functions.jsp"
                                                                                        class="nav-link <%= "strings-functions".equals(currentLesson)
                                                                                        ? "active" : "" %>"><svg
                                                                                                class="nav-icon"
                                                                                                viewBox="0 0 24 24"
                                                                                                fill="none"
                                                                                                stroke="currentColor"
                                                                                                stroke-width="2">
                                                                                                <path
                                                                                                        d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z" />
                                                                                                <polyline
                                                                                                        points="14 2 14 8 20 8" />
                                                                                                <line x1="9" y1="15"
                                                                                                        x2="15"
                                                                                                        y2="15" />
                                                                                        </svg><span>String
                                                                                                Functions</span></a>
                                                                        </li>
                                                                        <li class="nav-item"><a
                                                                                        href="<%=request.getContextPath()%>/tutorials/php/constants-basics.jsp"
                                                                                        class="nav-link <%= "constants-basics".equals(currentLesson)
                                                                                        ? "active" : "" %>"><svg
                                                                                                class="nav-icon"
                                                                                                viewBox="0 0 24 24"
                                                                                                fill="none"
                                                                                                stroke="currentColor"
                                                                                                stroke-width="2">
                                                                                                <circle cx="12" cy="12"
                                                                                                        r="10" />
                                                                                                <line x1="12" y1="8"
                                                                                                        x2="12"
                                                                                                        y2="12" />
                                                                                                <line x1="12" y1="16"
                                                                                                        x2="12.01"
                                                                                                        y2="16" />
                                                                                        </svg><span>Constants</span></a>
                                                                        </li>
                                                                </ul>
                                                        </div>

                                                        <%-- Module 3: Operators --%>
                                                                <div class="nav-section">
                                                                        <div class="nav-section-title">Operators</div>
                                                                        <ul class="nav-items">
                                                                                <li class="nav-item"><a
                                                                                                href="<%=request.getContextPath()%>/tutorials/php/operators-arithmetic.jsp"
                                                                                                class="nav-link <%= "operators-arithmetic".equals(currentLesson)
                                                                                                ? "active" : "" %>"><svg
                                                                                                        class="nav-icon"
                                                                                                        viewBox="0 0 24 24"
                                                                                                        fill="none"
                                                                                                        stroke="currentColor"
                                                                                                        stroke-width="2">
                                                                                                        <line x1="12"
                                                                                                                y1="5"
                                                                                                                x2="12"
                                                                                                                y2="19" />
                                                                                                        <line x1="5"
                                                                                                                y1="12"
                                                                                                                x2="19"
                                                                                                                y2="12" />
                                                                                                </svg><span>Arithmetic</span></a>
                                                                                </li>
                                                                                <li class="nav-item"><a
                                                                                                href="<%=request.getContextPath()%>/tutorials/php/operators-assignment.jsp"
                                                                                                class="nav-link <%= "operators-assignment".equals(currentLesson)
                                                                                                ? "active" : "" %>"><svg
                                                                                                        class="nav-icon"
                                                                                                        viewBox="0 0 24 24"
                                                                                                        fill="none"
                                                                                                        stroke="currentColor"
                                                                                                        stroke-width="2">
                                                                                                        <path
                                                                                                                d="M16 18l6-6-6-6" />
                                                                                                        <path
                                                                                                                d="M8 6l-6 6 6 6" />
                                                                                                </svg><span>Assignment</span></a>
                                                                                </li>
                                                                                <li class="nav-item"><a
                                                                                                href="<%=request.getContextPath()%>/tutorials/php/operators-comparison.jsp"
                                                                                                class="nav-link <%= "operators-comparison".equals(currentLesson)
                                                                                                ? "active" : "" %>"><svg
                                                                                                        class="nav-icon"
                                                                                                        viewBox="0 0 24 24"
                                                                                                        fill="none"
                                                                                                        stroke="currentColor"
                                                                                                        stroke-width="2">
                                                                                                        <path
                                                                                                                d="M8 9l4-4 4 4" />
                                                                                                        <path
                                                                                                                d="M16 15l-4 4-4-4" />
                                                                                                </svg><span>Comparison</span></a>
                                                                                </li>
                                                                                <li class="nav-item"><a
                                                                                                href="<%=request.getContextPath()%>/tutorials/php/operators-logical.jsp"
                                                                                                class="nav-link <%= "operators-logical".equals(currentLesson)
                                                                                                ? "active" : "" %>"><svg
                                                                                                        class="nav-icon"
                                                                                                        viewBox="0 0 24 24"
                                                                                                        fill="none"
                                                                                                        stroke="currentColor"
                                                                                                        stroke-width="2">
                                                                                                        <path
                                                                                                                d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z" />
                                                                                                        <line x1="4"
                                                                                                                y1="22"
                                                                                                                x2="4"
                                                                                                                y2="15" />
                                                                                                </svg><span>Logical</span></a>
                                                                                </li>
                                                                                <li class="nav-item"><a
                                                                                                href="<%=request.getContextPath()%>/tutorials/php/operators-increment.jsp"
                                                                                                class="nav-link <%= "operators-increment".equals(currentLesson)
                                                                                                ? "active" : "" %>"><svg
                                                                                                        class="nav-icon"
                                                                                                        viewBox="0 0 24 24"
                                                                                                        fill="none"
                                                                                                        stroke="currentColor"
                                                                                                        stroke-width="2">
                                                                                                        <path
                                                                                                                d="M10 13a5 5 0 007.54.54l3-3a5 5 0 00-7.07-7.07l-1.72 1.71" />
                                                                                                        <path
                                                                                                                d="M14 11a5 5 0 00-7.54-.54l-3 3a5 5 0 007.07 7.07l1.71-1.71" />
                                                                                                </svg><span>Increment/Decrement</span></a>
                                                                                </li>
                                                                                <li class="nav-item"><a
                                                                                                href="<%=request.getContextPath()%>/tutorials/php/operators-array.jsp"
                                                                                                class="nav-link <%= "operators-array".equals(currentLesson)
                                                                                                ? "active" : "" %>"><svg
                                                                                                        class="nav-icon"
                                                                                                        viewBox="0 0 24 24"
                                                                                                        fill="none"
                                                                                                        stroke="currentColor"
                                                                                                        stroke-width="2">
                                                                                                        <line x1="8"
                                                                                                                y1="6"
                                                                                                                x2="21"
                                                                                                                y2="6" />
                                                                                                        <line x1="8"
                                                                                                                y1="12"
                                                                                                                x2="21"
                                                                                                                y2="12" />
                                                                                                        <line x1="8"
                                                                                                                y1="18"
                                                                                                                x2="21"
                                                                                                                y2="18" />
                                                                                                </svg><span>Array</span></a>
                                                                                </li>
                                                                                <li class="nav-item"><a
                                                                                                href="<%=request.getContextPath()%>/tutorials/php/operators-ternary.jsp"
                                                                                                class="nav-link <%= "operators-ternary".equals(currentLesson)
                                                                                                ? "active" : "" %>"><svg
                                                                                                        class="nav-icon"
                                                                                                        viewBox="0 0 24 24"
                                                                                                        fill="none"
                                                                                                        stroke="currentColor"
                                                                                                        stroke-width="2">
                                                                                                        <circle cx="12"
                                                                                                                cy="12"
                                                                                                                r="10" />
                                                                                                        <path
                                                                                                                d="M12 16v-4" />
                                                                                                        <path
                                                                                                                d="M12 8h.01" />
                                                                                                </svg><span>Ternary &
                                                                                                        Null
                                                                                                        Coalescing</span></a>
                                                                                </li>
                                                                        </ul>
                                                                </div>

                                                                <%-- Module 4: Control Structures --%>
                                                                        <div class="nav-section">
                                                                                <div class="nav-section-title">Control
                                                                                        Structures</div>
                                                                                <ul class="nav-items">
                                                                                        <li class="nav-item"><a
                                                                                                        href="<%=request.getContextPath()%>/tutorials/php/control-if.jsp"
                                                                                                        class="nav-link <%= "control-if".equals(currentLesson)
                                                                                                        ? "active" : ""
                                                                                                        %>"><svg class="nav-icon"
                                                                                                                viewBox="0 0 24 24"
                                                                                                                fill="none"
                                                                                                                stroke="currentColor"
                                                                                                                stroke-width="2">
                                                                                                                <polyline
                                                                                                                        points="16 3 21 3 21 8" />
                                                                                                                <line x1="4"
                                                                                                                        y1="20"
                                                                                                                        x2="21"
                                                                                                                        y2="3" />
                                                                                                        </svg><span>If
                                                                                                                Statements</span></a>
                                                                                        </li>
                                                                                        <li class="nav-item"><a
                                                                                                        href="<%=request.getContextPath()%>/tutorials/php/control-switch.jsp"
                                                                                                        class="nav-link <%= "control-switch".equals(currentLesson)
                                                                                                        ? "active" : ""
                                                                                                        %>"><svg class="nav-icon"
                                                                                                                viewBox="0 0 24 24"
                                                                                                                fill="none"
                                                                                                                stroke="currentColor"
                                                                                                                stroke-width="2">
                                                                                                                <rect x="3"
                                                                                                                        y="3"
                                                                                                                        width="7"
                                                                                                                        height="7" />
                                                                                                                <rect x="14"
                                                                                                                        y="3"
                                                                                                                        width="7"
                                                                                                                        height="7" />
                                                                                                                <rect x="14"
                                                                                                                        y="14"
                                                                                                                        width="7"
                                                                                                                        height="7" />
                                                                                                                <rect x="3"
                                                                                                                        y="14"
                                                                                                                        width="7"
                                                                                                                        height="7" />
                                                                                                        </svg><span>Switch
                                                                                                                Statements</span></a>
                                                                                        </li>
                                                                                        <li class="nav-item"><a
                                                                                                        href="<%=request.getContextPath()%>/tutorials/php/loops-while.jsp"
                                                                                                        class="nav-link <%= "loops-while".equals(currentLesson)
                                                                                                        ? "active" : ""
                                                                                                        %>"><svg class="nav-icon"
                                                                                                                viewBox="0 0 24 24"
                                                                                                                fill="none"
                                                                                                                stroke="currentColor"
                                                                                                                stroke-width="2">
                                                                                                                <path
                                                                                                                        d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
                                                                                                        </svg><span>While
                                                                                                                Loops</span></a>
                                                                                        </li>
                                                                                        <li class="nav-item"><a
                                                                                                        href="<%=request.getContextPath()%>/tutorials/php/loops-for.jsp"
                                                                                                        class="nav-link <%= "loops-for".equals(currentLesson)
                                                                                                        ? "active" : ""
                                                                                                        %>"><svg class="nav-icon"
                                                                                                                viewBox="0 0 24 24"
                                                                                                                fill="none"
                                                                                                                stroke="currentColor"
                                                                                                                stroke-width="2">
                                                                                                                <path
                                                                                                                        d="M21 12a9 9 0 11-9-9c2.52 0 4.93 1 6.74 2.74L21 8" />
                                                                                                                <path
                                                                                                                        d="M21 3v5h-5" />
                                                                                                        </svg><span>For
                                                                                                                Loops</span></a>
                                                                                        </li>
                                                                                        <li class="nav-item"><a
                                                                                                        href="<%=request.getContextPath()%>/tutorials/php/loops-foreach.jsp"
                                                                                                        class="nav-link <%= "loops-foreach".equals(currentLesson)
                                                                                                        ? "active" : ""
                                                                                                        %>"><svg class="nav-icon"
                                                                                                                viewBox="0 0 24 24"
                                                                                                                fill="none"
                                                                                                                stroke="currentColor"
                                                                                                                stroke-width="2">
                                                                                                                <polyline
                                                                                                                        points="23 4 23 10 17 10" />
                                                                                                                <path
                                                                                                                        d="M20.49 15a9 9 0 11-2.12-9.36L23 10" />
                                                                                                        </svg><span>Foreach
                                                                                                                Loops</span></a>
                                                                                        </li>
                                                                                        <li class="nav-item"><a
                                                                                                        href="<%=request.getContextPath()%>/tutorials/php/loops-control.jsp"
                                                                                                        class="nav-link <%= "loops-control".equals(currentLesson)
                                                                                                        ? "active" : ""
                                                                                                        %>"><svg class="nav-icon"
                                                                                                                viewBox="0 0 24 24"
                                                                                                                fill="none"
                                                                                                                stroke="currentColor"
                                                                                                                stroke-width="2">
                                                                                                                <rect x="6"
                                                                                                                        y="4"
                                                                                                                        width="4"
                                                                                                                        height="16" />
                                                                                                                <rect x="14"
                                                                                                                        y="4"
                                                                                                                        width="4"
                                                                                                                        height="16" />
                                                                                                        </svg><span>Loop
                                                                                                                Control</span></a>
                                                                                        </li>
                                                                                </ul>
                                                                        </div>

                                                                        <%-- Module 5: Functions --%>
                                                                                <div class="nav-section">
                                                                                        <div class="nav-section-title">
                                                                                                Functions</div>
                                                                                        <ul class="nav-items">
                                                                                                <li class="nav-item"><a
                                                                                                                href="<%=request.getContextPath()%>/tutorials/php/functions-basics.jsp"
                                                                                                                class="nav-link <%= "functions-basics".equals(currentLesson)
                                                                                                                ? "active"
                                                                                                                : ""
                                                                                                                %>"><svg class="nav-icon"
                                                                                                                        viewBox="0 0 24 24"
                                                                                                                        fill="none"
                                                                                                                        stroke="currentColor"
                                                                                                                        stroke-width="2">
                                                                                                                        <rect x="3"
                                                                                                                                y="3"
                                                                                                                                width="18"
                                                                                                                                height="18"
                                                                                                                                rx="2"
                                                                                                                                ry="2" />
                                                                                                                        <path
                                                                                                                                d="M9 9l6 6" />
                                                                                                                </svg><span>Defining
                                                                                                                        Functions</span></a>
                                                                                                </li>
                                                                                                <li class="nav-item"><a
                                                                                                                href="<%=request.getContextPath()%>/tutorials/php/functions-parameters.jsp"
                                                                                                                class="nav-link <%= "functions-parameters".equals(currentLesson)
                                                                                                                ? "active"
                                                                                                                : ""
                                                                                                                %>"><svg class="nav-icon"
                                                                                                                        viewBox="0 0 24 24"
                                                                                                                        fill="none"
                                                                                                                        stroke="currentColor"
                                                                                                                        stroke-width="2">
                                                                                                                        <path
                                                                                                                                d="M12 2L2 7l10 5 10-5-10-5z" />
                                                                                                                        <path
                                                                                                                                d="M2 17l10 5 10-5" />
                                                                                                                        <path
                                                                                                                                d="M2 12l10 5 10-5" />
                                                                                                                </svg><span>Function
                                                                                                                        Parameters</span></a>
                                                                                                </li>
                                                                                                <li class="nav-item"><a
                                                                                                                href="<%=request.getContextPath()%>/tutorials/php/functions-variable.jsp"
                                                                                                                class="nav-link <%= "functions-variable".equals(currentLesson)
                                                                                                                ? "active"
                                                                                                                : ""
                                                                                                                %>"><svg class="nav-icon"
                                                                                                                        viewBox="0 0 24 24"
                                                                                                                        fill="none"
                                                                                                                        stroke="currentColor"
                                                                                                                        stroke-width="2">
                                                                                                                        <polyline
                                                                                                                                points="4 17 10 11 4 5" />
                                                                                                                        <line x1="12"
                                                                                                                                y1="19"
                                                                                                                                x2="20"
                                                                                                                                y2="19" />
                                                                                                                </svg><span>Variable
                                                                                                                        Functions</span></a>
                                                                                                </li>
                                                                                                <li class="nav-item"><a
                                                                                                                href="<%=request.getContextPath()%>/tutorials/php/functions-arrow.jsp"
                                                                                                                class="nav-link <%= "functions-arrow".equals(currentLesson)
                                                                                                                ? "active"
                                                                                                                : ""
                                                                                                                %>"><svg class="nav-icon"
                                                                                                                        viewBox="0 0 24 24"
                                                                                                                        fill="none"
                                                                                                                        stroke="currentColor"
                                                                                                                        stroke-width="2">
                                                                                                                        <line x1="5"
                                                                                                                                y1="12"
                                                                                                                                x2="19"
                                                                                                                                y2="12" />
                                                                                                                        <polyline
                                                                                                                                points="12 5 19 12 12 19" />
                                                                                                                </svg><span>Arrow
                                                                                                                        Functions</span></a>
                                                                                                </li>
                                                                                                <li class="nav-item"><a
                                                                                                                href="<%=request.getContextPath()%>/tutorials/php/functions-variadic.jsp"
                                                                                                                class="nav-link <%= "functions-variadic".equals(currentLesson)
                                                                                                                ? "active"
                                                                                                                : ""
                                                                                                                %>"><svg class="nav-icon"
                                                                                                                        viewBox="0 0 24 24"
                                                                                                                        fill="none"
                                                                                                                        stroke="currentColor"
                                                                                                                        stroke-width="2">
                                                                                                                        <circle cx="12"
                                                                                                                                cy="12"
                                                                                                                                r="1" />
                                                                                                                        <circle cx="19"
                                                                                                                                cy="12"
                                                                                                                                r="1" />
                                                                                                                        <circle cx="5"
                                                                                                                                cy="12"
                                                                                                                                r="1" />
                                                                                                                </svg><span>Variadic
                                                                                                                        Functions</span></a>
                                                                                                </li>
                                                                                                <li class="nav-item"><a
                                                                                                                href="<%=request.getContextPath()%>/tutorials/php/functions-scope.jsp"
                                                                                                                class="nav-link <%= "functions-scope".equals(currentLesson)
                                                                                                                ? "active"
                                                                                                                : ""
                                                                                                                %>"><svg class="nav-icon"
                                                                                                                        viewBox="0 0 24 24"
                                                                                                                        fill="none"
                                                                                                                        stroke="currentColor"
                                                                                                                        stroke-width="2">
                                                                                                                        <circle cx="12"
                                                                                                                                cy="12"
                                                                                                                                r="10" />
                                                                                                                        <line x1="2"
                                                                                                                                y1="12"
                                                                                                                                x2="22"
                                                                                                                                y2="12" />
                                                                                                                </svg><span>Scope
                                                                                                                        &
                                                                                                                        Static</span></a>
                                                                                                </li>
                                                                                        </ul>
                                                                                </div>

                                                                                <%-- Remaining modules abbreviated for
                                                                                        token limit --%>
                                                                                        <div class="nav-section">
                                                                                                <div
                                                                                                        class="nav-section-title">
                                                                                                        Arrays</div>
                                                                                                <ul class="nav-items">
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/arrays-basics.jsp"
                                                                                                                        class="nav-link <%= "arrays-basics".equals(currentLesson)
                                                                                                                        ? "active"
                                                                                                                        : ""
                                                                                                                        %>"><span>Array
                                                                                                                                Basics</span></a>
                                                                                                        </li>
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/arrays-multidimensional.jsp"
                                                                                                                        class="nav-link <%= "arrays-multidimensional".equals(currentLesson)
                                                                                                                        ? "active"
                                                                                                                        : ""
                                                                                                                        %>"><span>Multidimensional
                                                                                                                                Arrays</span></a>
                                                                                                        </li>
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/arrays-functions-basic.jsp"
                                                                                                                        class="nav-link <%= "arrays-functions-basic".equals(currentLesson)
                                                                                                                        ? "active"
                                                                                                                        : ""
                                                                                                                        %>"><span>Array
                                                                                                                                Functions
                                                                                                                                I</span></a>
                                                                                                        </li>
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/arrays-functions-advanced.jsp"
                                                                                                                        class="nav-link <%= "arrays-functions-advanced".equals(currentLesson)
                                                                                                                        ? "active"
                                                                                                                        : ""
                                                                                                                        %>"><span>Array
                                                                                                                                Functions
                                                                                                                                II</span></a>
                                                                                                        </li>
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/arrays-iteration.jsp"
                                                                                                                        class="nav-link <%= "arrays-iteration".equals(currentLesson)
                                                                                                                        ? "active"
                                                                                                                        : ""
                                                                                                                        %>"><span>Array
                                                                                                                                Iteration</span></a>
                                                                                                        </li>
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/arrays-sorting.jsp"
                                                                                                                        class="nav-link <%= "arrays-sorting".equals(currentLesson)
                                                                                                                        ? "active"
                                                                                                                        : ""
                                                                                                                        %>"><span>Array
                                                                                                                                Sorting</span></a>
                                                                                                        </li>
                                                                                                </ul>
                                                                                        </div>

                                                                                        <div class="nav-section">
                                                                                                <div
                                                                                                        class="nav-section-title">
                                                                                                        Object-Oriented
                                                                                                        Programming
                                                                                                </div>
                                                                                                <ul class="nav-items">
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/oop-classes.jsp"
                                                                                                                        class="nav-link <%= "oop-classes".equals(currentLesson)
                                                                                                                        ? "active"
                                                                                                                        : ""
                                                                                                                        %>"><span>Classes
                                                                                                                                &
                                                                                                                                Objects</span></a>
                                                                                                        </li>
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/oop-constructor.jsp"
                                                                                                                        class="nav-link <%= "oop-constructor".equals(currentLesson)
                                                                                                                        ? "active"
                                                                                                                        : ""
                                                                                                                        %>"><span>Constructors
                                                                                                                                &
                                                                                                                                Destructors</span></a>
                                                                                                        </li>
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/oop-access-modifiers.jsp"
                                                                                                                        class="nav-link <%= "oop-access-modifiers".equals(currentLesson)
                                                                                                                        ? "active"
                                                                                                                        : ""
                                                                                                                        %>"><span>Access
                                                                                                                                Modifiers</span></a>
                                                                                                        </li>
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/oop-inheritance.jsp"
                                                                                                                        class="nav-link <%= "oop-inheritance".equals(currentLesson)
                                                                                                                        ? "active"
                                                                                                                        : ""
                                                                                                                        %>"><span>Inheritance</span></a>
                                                                                                        </li>
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/oop-abstract.jsp"
                                                                                                                        class="nav-link <%= "oop-abstract".equals(currentLesson)
                                                                                                                        ? "active"
                                                                                                                        : ""
                                                                                                                        %>"><span>Abstract
                                                                                                                                Classes</span></a>
                                                                                                        </li>
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/oop-interfaces.jsp"
                                                                                                                        class="nav-link <%= "oop-interfaces".equals(currentLesson)
                                                                                                                        ? "active"
                                                                                                                        : ""
                                                                                                                        %>"><span>Interfaces</span></a>
                                                                                                        </li>
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/oop-traits.jsp"
                                                                                                                        class="nav-link <%= "oop-traits".equals(currentLesson)
                                                                                                                        ? "active"
                                                                                                                        : ""
                                                                                                                        %>"><span>Traits</span></a>
                                                                                                        </li>
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/oop-static.jsp"
                                                                                                                        class="nav-link <%= "oop-static".equals(currentLesson)
                                                                                                                        ? "active"
                                                                                                                        : ""
                                                                                                                        %>"><span>Static
                                                                                                                                Members</span></a>
                                                                                                        </li>
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/oop-magic-methods.jsp"
                                                                                                                        class="nav-link <%= "oop-magic-methods".equals(currentLesson)
                                                                                                                        ? "active"
                                                                                                                        : ""
                                                                                                                        %>"><span>Magic
                                                                                                                                Methods</span></a>
                                                                                                        </li>
                                                                                                </ul>
                                                                                        </div>

                                                                                        <div class="nav-section">
                                                                                                <div
                                                                                                        class="nav-section-title">
                                                                                                        Superglobals &
                                                                                                        Forms</div>
                                                                                                <ul class="nav-items">
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/superglobals-overview.jsp"
                                                                                                                        class="nav-link <%= "superglobals-overview".equals(currentLesson)
                                                                                                                        ? "active"
                                                                                                                        : ""
                                                                                                                        %>"><span>Superglobals
                                                                                                                                Overview</span></a>
                                                                                                        </li>
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/forms-get.jsp"
                                                                                                                        class="nav-link <%= "forms-get".equals(currentLesson)
                                                                                                                        ? "active"
                                                                                                                        : ""
                                                                                                                        %>"><span>GET
                                                                                                                                &
                                                                                                                                POST</span></a>
                                                                                                        </li>
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/forms-validation.jsp"
                                                                                                                        class="nav-link <%= "forms-validation".equals(currentLesson)
                                                                                                                        ? "active"
                                                                                                                        : ""
                                                                                                                        %>"><span>Form
                                                                                                                                Validation</span></a>
                                                                                                        </li>
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/sessions-basics.jsp"
                                                                                                                        class="nav-link <%= "sessions-basics".equals(currentLesson)
                                                                                                                        ? "active"
                                                                                                                        : ""
                                                                                                                        %>"><span>Sessions</span></a>
                                                                                                        </li>
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/cookies-basics.jsp"
                                                                                                                        class="nav-link <%= "cookies-basics".equals(currentLesson)
                                                                                                                        ? "active"
                                                                                                                        : ""
                                                                                                                        %>"><span>Cookies</span></a>
                                                                                                        </li>
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/uploads-basics.jsp"
                                                                                                                        class="nav-link <%= "uploads-basics".equals(currentLesson)
                                                                                                                        ? "active"
                                                                                                                        : ""
                                                                                                                        %>"><span>File
                                                                                                                                Uploads</span></a>
                                                                                                        </li>
                                                                                                </ul>
                                                                                        </div>

                                                                                        <div class="nav-section">
                                                                                                <div
                                                                                                        class="nav-section-title">
                                                                                                        File & Directory
                                                                                                        Handling</div>
                                                                                                <ul class="nav-items">
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/files-basics.jsp"
                                                                                                                        class="nav-link <%= "files-basics".equals(currentLesson)
                                                                                                                        ? "active"
                                                                                                                        : ""
                                                                                                                        %>"><span>File
                                                                                                                                Basics</span></a>
                                                                                                        </li>
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/files-advanced.jsp"
                                                                                                                        class="nav-link <%= "files-advanced".equals(currentLesson)
                                                                                                                        ? "active"
                                                                                                                        : ""
                                                                                                                        %>"><span>Advanced
                                                                                                                                File
                                                                                                                                Operations</span></a>
                                                                                                        </li>
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/files-csv.jsp"
                                                                                                                        class="nav-link <%= "files-csv".equals(currentLesson)
                                                                                                                        ? "active"
                                                                                                                        : ""
                                                                                                                        %>"><span>CSV
                                                                                                                                Files</span></a>
                                                                                                        </li>
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/files-json.jsp"
                                                                                                                        class="nav-link <%= "files-json".equals(currentLesson)
                                                                                                                        ? "active"
                                                                                                                        : ""
                                                                                                                        %>"><span>JSON
                                                                                                                                Files</span></a>
                                                                                                        </li>
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/files-permissions.jsp"
                                                                                                                        class="nav-link <%= "files-permissions".equals(currentLesson)
                                                                                                                        ? "active"
                                                                                                                        : ""
                                                                                                                        %>"><span>File
                                                                                                                                Permissions</span></a>
                                                                                                        </li>
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/uploads-basics.jsp"
                                                                                                                        class="nav-link <%= "uploads-basics".equals(currentLesson)
                                                                                                                        ? "active"
                                                                                                                        : ""
                                                                                                                        %>"><span>File
                                                                                                                                Uploads</span></a>
                                                                                                        </li>
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/directories-basics.jsp"
                                                                                                                        class="nav-link <%= "directories-basics".equals(currentLesson)
                                                                                                                        ? "active"
                                                                                                                        : ""
                                                                                                                        %>"><span>Directory
                                                                                                                                Operations</span></a>
                                                                                                        </li>
                                                                                                </ul>
                                                                                        </div>

                                                                                        <div class="nav-section">
                                                                                                <div
                                                                                                        class="nav-section-title">
                                                                                                        Database
                                                                                                        Integration
                                                                                                </div>
                                                                                                <ul class="nav-items">
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/database-mysqli.jsp"
                                                                                                                        class="nav-link <%= 
                                                                                                                        "database-mysqli".equals(currentLesson)
                                                                                                                        ? "active"
                                                                                                                        : ""
                                                                                                                        %>"><span>MySQLi
                                                                                                                                Basics</span></a>
                                                                                                        </li>
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/database-pdo.jsp"
                                                                                                                        class="nav-link <%= "database-pdo".equals(currentLesson)
                                                                                                                        ?
                                                                                                                        "active"
                                                                                                                        : ""
                                                                                                                        %>"><span>PDO
                                                                                                                                Basics</span></a>
                                                                                                        </li>
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/database-security.jsp"
                                                                                                                        class="nav-link <%= "database-security".equals(currentLesson)
                                                                                                                        ? "active"
                                                                                                                        :""
                                                                                                                        %>"><span>Database
                                                                                                                                Security</span></a>
                                                                                                        </li>
                                                                                                </ul>
                                                                                        </div>

                                                                                        <div class="nav-section">
                                                                                                <div
                                                                                                        class="nav-section-title">
                                                                                                        Advanced Topics
                                                                                                </div>
                                                                                                <ul class="nav-items">
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/errors-exceptions.jsp"
                                                                                                                        class="nav-link <%= 
                                                                                                                        "errors-exceptions".equals(currentLesson)
                                                                                                                        ?
                                                                                                                        "active"
                                                                                                                        :
                                                                                                                        ""
                                                                                                                        %>"><span>Errors
                                                                                                                                &
                                                                                                                                Exceptions</span></a>
                                                                                                        </li>
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/regex-basics.jsp"
                                                                                                                        class="nav-link <%= 
                                                                                                                        "regex-basics".equals(currentLesson)
                                                                                                                        ?
                                                                                                                        "active"
                                                                                                                        :
                                                                                                                        ""
                                                                                                                        %>"><span>Regular
                                                                                                                                Expressions</span></a>
                                                                                                        </li>
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/datetime-basics.jsp"
                                                                                                                        class="nav-link <%= 
                                                                                                                        "datetime-basics".equals(currentLesson)
                                                                                                                        ?
                                                                                                                        "active"
                                                                                                                        :
                                                                                                                        ""
                                                                                                                        %>"><span>Date
                                                                                                                                &
                                                                                                                                Time</span></a>
                                                                                                        </li>
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/apis-json.jsp"
                                                                                                                        class="nav-link <%= 
                                                                                                                        "apis-json".equals(currentLesson)
                                                                                                                        ?
                                                                                                                        "active"
                                                                                                                        :
                                                                                                                        ""
                                                                                                                        %>"><span>JSON
                                                                                                                                &
                                                                                                                                APIs</span></a>
                                                                                                        </li>
                                                                                                </ul>
                                                                                        </div>

                                                                                        <div class="nav-section">
                                                                                                <div
                                                                                                        class="nav-section-title">
                                                                                                        Professional
                                                                                                        Practices</div>
                                                                                                <ul class="nav-items">
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/security-practices.jsp"
                                                                                                                        class="nav-link <%= 
                                                                                                                        "security-practices".equals(currentLesson)
                                                                                                                        ?
                                                                                                                        "active"
                                                                                                                        :
                                                                                                                        ""
                                                                                                                        %>"><span>Security
                                                                                                                                Practices</span></a>
                                                                                                        </li>
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/composer-packages.jsp"
                                                                                                                        class="nav-link <%= 
                                                                                                                        "composer-packages".equals(currentLesson)
                                                                                                                        ?
                                                                                                                        "active"
                                                                                                                        :
                                                                                                                        ""
                                                                                                                        %>"><span>Composer
                                                                                                                                &
                                                                                                                                Packages</span></a>
                                                                                                        </li>
                                                                                                        <li
                                                                                                                class="nav-item">
                                                                                                                <a href="<%=request.getContextPath()%>/tutorials/php/testing-deployment.jsp"
                                                                                                                        class="nav-link <%= 
                                                                                                                        "testing-deployment".equals(currentLesson)
                                                                                                                        ?
                                                                                                                        "active"
                                                                                                                        :
                                                                                                                        ""
                                                                                                                        %>"><span>Testing
                                                                                                                                &
                                                                                                                                Deployment</span></a>
                                                                                                        </li>
                                                                                                </ul>
                                                                                        </div>
                                </nav>

                                <%@ include file="ads/ad-sidebar.jsp" %>
                        </aside>