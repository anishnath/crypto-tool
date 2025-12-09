<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- Tutorial Sidebar Component - Java Navigation for Java Tutorial lessons Uses currentLesson attribute to highlight active item --%>
<% String currentLesson = (String) request.getAttribute("currentLesson");
   if (currentLesson == null) currentLesson = ""; %>
<aside class="tutorial-sidebar" id="sidebar">
    <div class="sidebar-header">
        <div class="sidebar-logo">
            <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-logo.svg" alt="Java" width="32" height="32">
        </div>
        <h2 class="sidebar-title">Java Tutorial</h2>
    </div>

    <nav class="sidebar-nav">
        <%-- Module 1: Getting Started --%>
        <div class="nav-section">
            <div class="nav-section-title">Getting Started</div>
            <ul class="nav-items">
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/intro.jsp"
                        class="nav-link <%= " intro".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="intro">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10" />
                            <polygon points="10 8 16 12 10 16 10 8" />
                        </svg>
                        <span>Introduction</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/first-program.jsp"
                        class="nav-link <%= " first-program".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="first-program">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z" />
                            <path d="M14 2v6h6M16 13H8M16 17H8M10 9H8" />
                        </svg>
                        <span>First Program</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/syntax-basics.jsp"
                        class="nav-link <%= " syntax-basics".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="syntax-basics">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M4 7V4h16v3M4 20h16M9 4v16" />
                        </svg>
                        <span>Syntax Basics</span>
                    </a>
                </li>
            </ul>
        </div>

        <%-- Module 2: Variables & Data Types --%>
        <div class="nav-section">
            <div class="nav-section-title">Variables & Data Types</div>
            <ul class="nav-items">
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/types-primitives.jsp"
                        class="nav-link <%= " types-primitives".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="types-primitives">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M4 4h4v4H4zM14 4h4v4h-4zM4 14h4v4H4z" />
                            <path d="M14 14h6M14 18h6M17 14v4" />
                        </svg>
                        <span>Primitive Types</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/variables-declaration.jsp"
                        class="nav-link <%= " variables-declaration".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="variables-declaration">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M4 7V4h16v3" />
                            <path d="M9 20h6" />
                            <path d="M12 4v16" />
                        </svg>
                        <span>Variables</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/types-casting.jsp"
                        class="nav-link <%= " types-casting".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="types-casting">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M17 1l4 4-4 4" />
                            <path d="M3 11V9a4 4 0 014-4h14" />
                            <path d="M7 23l-4-4 4-4" />
                            <path d="M21 13v2a4 4 0 01-4 4H3" />
                        </svg>
                        <span>Type Casting</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/strings-basics.jsp"
                        class="nav-link <%= " strings-basics".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="strings-basics">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M17 6H7c-1.1 0-2 .9-2 2v8c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2z" />
                            <path d="M8 10h8M8 14h5" />
                        </svg>
                        <span>Strings</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/arrays-basics.jsp"
                        class="nav-link <%= " arrays-basics".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="arrays-basics">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="3" width="18" height="18" rx="2" />
                            <path d="M3 9h18M9 3v18" />
                        </svg>
                        <span>Arrays</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/arrays-multidimensional.jsp"
                        class="nav-link <%= " arrays-multidimensional".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="arrays-multidimensional">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="3" width="7" height="7" />
                            <rect x="14" y="3" width="7" height="7" />
                            <rect x="3" y="14" width="7" height="7" />
                            <rect x="14" y="14" width="7" height="7" />
                        </svg>
                        <span>Multi-dimensional Arrays</span>
                    </a>
                </li>
            </ul>
        </div>

        <%-- Module 3: Operators & Expressions --%>
        <div class="nav-section">
            <div class="nav-section-title">Operators & Expressions</div>
            <ul class="nav-items">
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/operators-arithmetic.jsp"
                        class="nav-link <%= " operators-arithmetic".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="operators-arithmetic">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="12" y1="5" x2="12" y2="19" />
                            <line x1="5" y1="12" x2="19" y2="12" />
                        </svg>
                        <span>Arithmetic Operators</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/operators-comparison.jsp"
                        class="nav-link <%= " operators-comparison".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="operators-comparison">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M8 9l4-4 4 4" />
                            <path d="M16 15l-4 4-4-4" />
                        </svg>
                        <span>Comparison Operators</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/operators-logical.jsp"
                        class="nav-link <%= " operators-logical".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="operators-logical">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z" />
                            <line x1="4" y1="22" x2="4" y2="15" />
                        </svg>
                        <span>Logical Operators</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/operators-bitwise.jsp"
                        class="nav-link <%= " operators-bitwise".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="operators-bitwise">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M2 20h.01" />
                            <path d="M7 20v-4" />
                            <path d="M12 20v-8" />
                            <path d="M17 20V8" />
                            <path d="M22 4v16" />
                        </svg>
                        <span>Bitwise Operators</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/operators-assignment.jsp"
                        class="nav-link <%= " operators-assignment".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="operators-assignment">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M16 18l6-6-6-6" />
                            <path d="M8 6l-6 6 6 6" />
                        </svg>
                        <span>Assignment Operators</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/operators-ternary.jsp"
                        class="nav-link <%= " operators-ternary".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="operators-ternary">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M10 18l6-6-6-6" />
                            <circle cx="12" cy="12" r="10" />
                        </svg>
                        <span>Ternary Operator</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/operators-precedence.jsp"
                        class="nav-link <%= " operators-precedence".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="operators-precedence">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M12 2v20M2 12h20" />
                            <circle cx="12" cy="12" r="2" />
                        </svg>
                        <span>Operator Precedence</span>
                    </a>
                </li>
            </ul>
        </div>

        <%-- Module 4: Control Flow --%>
        <div class="nav-section">
            <div class="nav-section-title">Control Flow</div>
            <ul class="nav-items">
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/control-if.jsp"
                        class="nav-link <%= " control-if".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="control-if">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M9 11l3 3L22 4" />
                            <path d="M21 12v7a2 2 0 01-2 2H5a2 2 0 01-2-2V5a2 2 0 012-2h11" />
                        </svg>
                        <span>If Statements</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/control-switch.jsp"
                        class="nav-link <%= " control-switch".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="control-switch">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="2" y="6" width="20" height="12" rx="2" />
                            <circle cx="8" cy="12" r="1" />
                            <circle cx="12" cy="12" r="1" />
                            <circle cx="16" cy="12" r="1" />
                        </svg>
                        <span>Switch Statements</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/loops-for.jsp"
                        class="nav-link <%= " loops-for".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="loops-for">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21 16V8a2 2 0 00-1-1.73l-7-4a2 2 0 00-2 0l-7 4A2 2 0 003 8v8a2 2 0 001 1.73l7 4a2 2 0 002 0l7-4A2 2 0 0021 16z" />
                            <polyline points="7.5 4.21 12 6.81 16.5 4.21" />
                            <polyline points="7.5 19.79 7.5 14.6 3 12" />
                            <polyline points="21 12 16.5 14.6 16.5 19.79" />
                            <polyline points="3.27 6.96 12 12.01 20.73 6.96" />
                            <line x1="12" y1="22.08" x2="12" y2="12" />
                        </svg>
                        <span>For Loops</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/loops-while.jsp"
                        class="nav-link <%= " loops-while".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="loops-while">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10" />
                            <polyline points="12 6 12 12 16 14" />
                        </svg>
                        <span>While Loops</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/loops-control.jsp"
                        class="nav-link <%= " loops-control".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="loops-control">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10" />
                            <line x1="12" y1="8" x2="12" y2="12" />
                            <line x1="12" y1="16" x2="12.01" y2="16" />
                        </svg>
                        <span>Loop Control</span>
                    </a>
                </li>
            </ul>
        </div>

        <%-- Module 5: Methods & Functions --%>
        <div class="nav-section">
            <div class="nav-section-title">Methods & Functions</div>
            <ul class="nav-items">
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/methods-basics.jsp"
                        class="nav-link <%= " methods-basics".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="methods-basics">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M12 20h9" />
                            <path d="M16.5 3.5a2.121 2.121 0 013 3L7 19l-4 1 1-4L16.5 3.5z" />
                        </svg>
                        <span>Defining Methods</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/methods-parameters.jsp"
                        class="nav-link <%= " methods-parameters".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="methods-parameters">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="3" />
                            <path d="M12 1v6m0 6v6M5.64 5.64l4.24 4.24m4.24 4.24l4.24 4.24M1 12h6m6 0h6M5.64 18.36l4.24-4.24m4.24-4.24l4.24-4.24" />
                        </svg>
                        <span>Method Parameters</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/methods-overloading.jsp"
                        class="nav-link <%= " methods-overloading".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="methods-overloading">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z" />
                            <polyline points="14 2 14 8 20 8" />
                            <line x1="16" y1="13" x2="8" y2="13" />
                            <line x1="16" y1="17" x2="8" y2="17" />
                            <polyline points="10 9 9 9 8 9" />
                        </svg>
                        <span>Method Overloading</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/methods-return.jsp"
                        class="nav-link <%= " methods-return".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="methods-return">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="9 18 15 12 9 6" />
                        </svg>
                        <span>Return Values</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/methods-recursion.jsp"
                        class="nav-link <%= " methods-recursion".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="methods-recursion">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21 16V8a2 2 0 00-1-1.73l-7-4a2 2 0 00-2 0l-7 4A2 2 0 003 8v8a2 2 0 001 1.73l7 4a2 2 0 002 0l7-4A2 2 0 0021 16z" />
                            <polyline points="3.27 6.96 12 12.01 20.73 6.96" />
                            <line x1="12" y1="22.08" x2="12" y2="12" />
                        </svg>
                        <span>Recursion</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/methods-scope.jsp"
                        class="nav-link <%= " methods-scope".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="methods-scope">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
                            <path d="M7 11V7a5 5 0 0110 0v4" />
                        </svg>
                        <span>Method Scope</span>
                    </a>
                </li>
            </ul>
        </div>

        <%-- Module 6: Object-Oriented Programming Basics --%>
        <div class="nav-section">
            <div class="nav-section-title">OOP Basics</div>
            <ul class="nav-items">
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/oop-classes.jsp"
                        class="nav-link <%= " oop-classes".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="oop-classes">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                            <line x1="3" y1="9" x2="21" y2="9" />
                            <line x1="9" y1="21" x2="9" y2="9" />
                        </svg>
                        <span>Classes & Objects</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/oop-constructors.jsp"
                        class="nav-link <%= " oop-constructors".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="oop-constructors">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4" />
                        </svg>
                        <span>Constructors</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/oop-methods.jsp"
                        class="nav-link <%= " oop-methods".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="oop-methods">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M12 20h9" />
                            <path d="M16.5 3.5a2.121 2.121 0 013 3L7 19l-4 1 1-4L16.5 3.5z" />
                        </svg>
                        <span>Methods in Classes</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/oop-access-modifiers.jsp"
                        class="nav-link <%= " oop-access-modifiers".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="oop-access-modifiers">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
                            <path d="M7 11V7a5 5 0 0110 0v4" />
                        </svg>
                        <span>Access Modifiers</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/oop-static.jsp"
                        class="nav-link <%= " oop-static".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="oop-static">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10" />
                            <line x1="12" y1="2" x2="12" y2="6" />
                            <line x1="12" y1="18" x2="12" y2="22" />
                            <line x1="4.93" y1="4.93" x2="7.76" y2="7.76" />
                            <line x1="16.24" y1="16.24" x2="19.07" y2="19.07" />
                            <line x1="2" y1="12" x2="6" y2="12" />
                            <line x1="18" y1="12" x2="22" y2="12" />
                            <line x1="4.93" y1="19.07" x2="7.76" y2="16.24" />
                            <line x1="16.24" y1="7.76" x2="19.07" y2="4.93" />
                        </svg>
                        <span>Static Members</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/oop-final.jsp"
                        class="nav-link <%= " oop-final".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="oop-final">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M22 11.08V12a10 10 0 11-5.93-9.14" />
                            <polyline points="22 4 12 14.01 9 11.01" />
                        </svg>
                        <span>final Keyword</span>
                    </a>
                </li>
            </ul>
        </div>

        <%-- Module 7: Inheritance & Polymorphism --%>
        <div class="nav-section">
            <div class="nav-section-title">Inheritance & Polymorphism</div>
            <ul class="nav-items">
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/inheritance-basics.jsp"
                        class="nav-link <%= " inheritance-basics".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="inheritance-basics">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2" />
                            <circle cx="9" cy="7" r="4" />
                            <path d="M23 21v-2a4 4 0 00-3-3.87M16 3.13a4 4 0 010 7.75" />
                        </svg>
                        <span>Inheritance</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/inheritance-super.jsp"
                        class="nav-link <%= " inheritance-super".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="inheritance-super">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M17 3a2.828 2.828 0 114 4L7.5 20.5 2 22l1.5-5.5L17 3z" />
                        </svg>
                        <span>super Keyword</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/inheritance-overriding.jsp"
                        class="nav-link <%= " inheritance-overriding".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="inheritance-overriding">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z" />
                            <polyline points="14 2 14 8 20 8" />
                            <line x1="12" y1="18" x2="12" y2="12" />
                            <line x1="9" y1="15" x2="15" y2="15" />
                        </svg>
                        <span>Method Overriding</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/inheritance-instanceof.jsp"
                        class="nav-link <%= " inheritance-instanceof".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="inheritance-instanceof">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10" />
                            <path d="M12 6v6l4 2" />
                        </svg>
                        <span>instanceof Operator</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/inheritance-object-class.jsp"
                        class="nav-link <%= " inheritance-object-class".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="inheritance-object-class">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                        </svg>
                        <span>Object Class</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/inheritance-abstract.jsp"
                        class="nav-link <%= " inheritance-abstract".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="inheritance-abstract">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M12 2v20M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6" />
                        </svg>
                        <span>Abstract Classes</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/interfaces-basics.jsp"
                        class="nav-link <%= " interfaces-basics".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="interfaces-basics">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="2" y="6" width="20" height="12" rx="2" />
                            <path d="M12 12h.01M7 12h.01M17 12h.01" />
                        </svg>
                        <span>Interfaces</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/polymorphism-runtime.jsp"
                        class="nav-link <%= " polymorphism-runtime".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="polymorphism-runtime">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
                        </svg>
                        <span>Polymorphism</span>
                    </a>
                </li>
            </ul>
        </div>

        <%-- Module 8: Collections Framework --%>
        <div class="nav-section">
            <div class="nav-section-title">Collections Framework</div>
            <ul class="nav-items">
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/collections-overview.jsp"
                        class="nav-link <%= " collections-overview".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="collections-overview">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21 16V8a2 2 0 00-1-1.73l-7-4a2 2 0 00-2 0l-7 4A2 2 0 003 8v8a2 2 0 001 1.73l7 4a2 2 0 002 0l7-4A2 2 0 0021 16z" />
                        </svg>
                        <span>Collections Overview</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/collections-arraylist.jsp"
                        class="nav-link <%= " collections-arraylist".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="collections-arraylist">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="3" width="18" height="18" rx="2" />
                            <line x1="9" y1="3" x2="9" y2="21" />
                        </svg>
                        <span>ArrayList</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/collections-linkedlist.jsp"
                        class="nav-link <%= " collections-linkedlist".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="collections-linkedlist">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="18" cy="5" r="3" />
                            <circle cx="6" cy="12" r="3" />
                            <circle cx="18" cy="19" r="3" />
                            <line x1="8.59" y1="13.51" x2="15.42" y2="17.49" />
                            <line x1="15.41" y1="6.51" x2="8.59" y2="10.49" />
                        </svg>
                        <span>LinkedList</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/collections-hashset.jsp"
                        class="nav-link <%= " collections-hashset".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="collections-hashset">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="9" cy="12" r="1" />
                            <circle cx="15" cy="12" r="1" />
                            <path d="M8 20v-5a4 4 0 018 0v5" />
                            <path d="M3 20h18" />
                        </svg>
                        <span>HashSet</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/collections-treeset.jsp"
                        class="nav-link <%= " collections-treeset".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="collections-treeset">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21 16V8a2 2 0 00-1-1.73l-7-4a2 2 0 00-2 0l-7 4A2 2 0 003 8v8a2 2 0 001 1.73l7 4a2 2 0 002 0l7-4A2 2 0 0021 16z" />
                            <polyline points="3.27 6.96 12 12.01 20.73 6.96" />
                            <line x1="12" y1="22.08" x2="12" y2="12" />
                        </svg>
                        <span>TreeSet</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/collections-hashmap.jsp"
                        class="nav-link <%= " collections-hashmap".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="collections-hashmap">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="3" width="18" height="18" rx="2" />
                            <path d="M3 9h18M9 3v18" />
                        </svg>
                        <span>HashMap</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/collections-treemap.jsp"
                        class="nav-link <%= " collections-treemap".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="collections-treemap">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21 16V8a2 2 0 00-1-1.73l-7-4a2 2 0 00-2 0l-7 4A2 2 0 003 8v8a2 2 0 001 1.73l7 4a2 2 0 002 0l7-4A2 2 0 0021 16z" />
                        </svg>
                        <span>TreeMap</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/collections-iterators.jsp"
                        class="nav-link <%= " collections-iterators".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="collections-iterators">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="9 18 15 12 9 6" />
                        </svg>
                        <span>Iterators</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/collections-generics.jsp"
                        class="nav-link <%= " collections-generics".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="collections-generics">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="3" width="18" height="18" rx="2" />
                            <line x1="9" y1="9" x2="15" y2="15" />
                            <line x1="15" y1="9" x2="9" y2="15" />
                        </svg>
                        <span>Generics</span>
                    </a>
                </li>
            </ul>
        </div>

        <%-- Module 9: Exception Handling --%>
        <div class="nav-section">
            <div class="nav-section-title">Exception Handling</div>
            <ul class="nav-items">
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/exceptions-basics.jsp"
                        class="nav-link <%= " exceptions-basics".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="exceptions-basics">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10" />
                            <line x1="12" y1="8" x2="12" y2="12" />
                            <line x1="12" y1="16" x2="12.01" y2="16" />
                        </svg>
                        <span>Exception Basics</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/exceptions-try-catch.jsp"
                        class="nav-link <%= " exceptions-try-catch".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="exceptions-try-catch">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
                            <path d="M7 11V7a5 5 0 0110 0v4" />
                        </svg>
                        <span>Try-Catch</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/exceptions-multiple-catch.jsp"
                        class="nav-link <%= " exceptions-multiple-catch".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="exceptions-multiple-catch">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21 16V8a2 2 0 00-1-1.73l-7-4a2 2 0 00-2 0l-7 4A2 2 0 003 8v8a2 2 0 001 1.73l7 4a2 2 0 002 0l7-4A2 2 0 0021 16z" />
                            <polyline points="7.5 4.21 12 6.81 16.5 4.21" />
                            <polyline points="7.5 19.79 7.5 14.6 3 12" />
                        </svg>
                        <span>Multiple Catch Blocks</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/exceptions-finally.jsp"
                        class="nav-link <%= " exceptions-finally".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="exceptions-finally">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M22 11.08V12a10 10 0 11-5.93-9.14" />
                            <polyline points="22 4 12 14.01 9 11.01" />
                        </svg>
                        <span>Finally Block</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/exceptions-throw.jsp"
                        class="nav-link <%= " exceptions-throw".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="exceptions-throw">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10" />
                            <line x1="15" y1="9" x2="9" y2="15" />
                            <line x1="9" y1="9" x2="15" y2="15" />
                        </svg>
                        <span>Throw & Throws</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/exceptions-custom.jsp"
                        class="nav-link <%= " exceptions-custom".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="exceptions-custom">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z" />
                            <polyline points="14 2 14 8 20 8" />
                            <line x1="16" y1="13" x2="8" y2="13" />
                            <line x1="16" y1="17" x2="8" y2="17" />
                        </svg>
                        <span>Custom Exceptions</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/exceptions-best-practices.jsp"
                        class="nav-link <%= " exceptions-best-practices".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="exceptions-best-practices">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z" />
                            <polyline points="14 2 14 8 20 8" />
                            <line x1="12" y1="18" x2="12" y2="12" />
                            <line x1="9" y1="15" x2="15" y2="15" />
                        </svg>
                        <span>Exception Best Practices</span>
                    </a>
                </li>
            </ul>
        </div>

        <%-- Module 10: File I/O & Streams --%>
        <div class="nav-section">
            <div class="nav-section-title">File I/O & Streams</div>
            <ul class="nav-items">
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/io-file.jsp"
                        class="nav-link <%= " io-file".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="io-file">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M13 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V9z" />
                            <polyline points="13 2 13 9 20 9" />
                        </svg>
                        <span>File Operations</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/io-reading.jsp"
                        class="nav-link <%= " io-reading".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="io-reading">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M4 19.5A2.5 2.5 0 016.5 17H20" />
                            <path d="M6.5 2H20v20H6.5A2.5 2.5 0 014 19.5v-15A2.5 2.5 0 016.5 2z" />
                            <line x1="9" y1="7" x2="15" y2="7" />
                            <line x1="9" y1="11" x2="15" y2="11" />
                            <line x1="9" y1="15" x2="13" y2="15" />
                        </svg>
                        <span>Reading Files</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/io-writing.jsp"
                        class="nav-link <%= " io-writing".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="io-writing">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M12 20h9" />
                            <path d="M16.5 3.5a2.121 2.121 0 013 3L7 19l-4 1 1-4L16.5 3.5z" />
                        </svg>
                        <span>Writing Files</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/io-scanner.jsp"
                        class="nav-link <%= " io-scanner".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="io-scanner">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="3" width="18" height="18" rx="2" />
                            <circle cx="8.5" cy="8.5" r="1.5" />
                            <polyline points="21 15 16 10 5 21" />
                        </svg>
                        <span>Scanner Class</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/io-serialization.jsp"
                        class="nav-link <%= " io-serialization".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="io-serialization">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4" />
                            <polyline points="17 8 12 3 7 8" />
                            <line x1="12" y1="3" x2="12" y2="15" />
                        </svg>
                        <span>Serialization</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/io-nio.jsp"
                        class="nav-link <%= " io-nio".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="io-nio">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21 16V8a2 2 0 00-1-1.73l-7-4a2 2 0 00-2 0l-7 4A2 2 0 003 8v8a2 2 0 001 1.73l7 4a2 2 0 002 0l7-4A2 2 0 0021 16z" />
                        </svg>
                        <span>NIO (New I/O)</span>
                    </a>
                </li>
            </ul>
        </div>

        <%-- Module 11: Advanced Topics --%>
        <div class="nav-section">
            <div class="nav-section-title">Advanced Topics</div>
            <ul class="nav-items">
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/advanced-lambda.jsp"
                        class="nav-link <%= " advanced-lambda".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="advanced-lambda">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21 16V8a2 2 0 00-1-1.73l-7-4a2 2 0 00-2 0l-7 4A2 2 0 003 8v8a2 2 0 001 1.73l7 4a2 2 0 002 0l7-4A2 2 0 0021 16z" />
                        </svg>
                        <span>Lambda Expressions</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/advanced-streams.jsp"
                        class="nav-link <%= " advanced-streams".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="advanced-streams">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="22 12 18 12 15 21 9 3 6 12 2 12" />
                        </svg>
                        <span>Streams API</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/advanced-threading.jsp"
                        class="nav-link <%= " advanced-threading".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="advanced-threading">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10" />
                            <polyline points="12 6 12 12 16 14" />
                        </svg>
                        <span>Threading Basics</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/advanced-synchronization.jsp"
                        class="nav-link <%= " advanced-synchronization".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="advanced-synchronization">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
                            <path d="M7 11V7a5 5 0 0110 0v4" />
                        </svg>
                        <span>Synchronization</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/advanced-executors.jsp"
                        class="nav-link <%= " advanced-executors".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="advanced-executors">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
                        </svg>
                        <span>Concurrency Utilities</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/advanced-enums.jsp"
                        class="nav-link <%= " advanced-enums".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="advanced-enums">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10" />
                            <line x1="12" y1="2" x2="12" y2="6" />
                            <line x1="12" y1="18" x2="12" y2="22" />
                            <line x1="4.93" y1="4.93" x2="7.76" y2="7.76" />
                            <line x1="16.24" y1="16.24" x2="19.07" y2="19.07" />
                        </svg>
                        <span>Enums</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/advanced-annotations.jsp"
                        class="nav-link <%= " advanced-annotations".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="advanced-annotations">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4" />
                            <polyline points="17 8 12 3 7 8" />
                            <line x1="12" y1="3" x2="12" y2="15" />
                        </svg>
                        <span>Annotations</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/advanced-reflection.jsp"
                        class="nav-link <%= " advanced-reflection".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="advanced-reflection">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21 16V8a2 2 0 00-1-1.73l-7-4a2 2 0 00-2 0l-7 4A2 2 0 003 8v8a2 2 0 001 1.73l7 4a2 2 0 002 0l7-4A2 2 0 0021 16z" />
                            <polyline points="3.27 6.96 12 12.01 20.73 6.96" />
                        </svg>
                        <span>Reflection</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/advanced-regex.jsp"
                        class="nav-link <%= " advanced-regex".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="advanced-regex">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z" />
                            <polyline points="14 2 14 8 20 8" />
                            <line x1="16" y1="13" x2="8" y2="13" />
                            <line x1="16" y1="17" x2="8" y2="17" />
                        </svg>
                        <span>Regular Expressions</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/advanced-datetime.jsp"
                        class="nav-link <%= " advanced-datetime".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="advanced-datetime">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10" />
                            <polyline points="12 6 12 12 16 14" />
                        </svg>
                        <span>Date & Time API</span>
                    </a>
                </li>
            </ul>
        </div>

        <%-- Module 12: Professional Practices --%>
        <div class="nav-section">
            <div class="nav-section-title">Professional Practices</div>
            <ul class="nav-items">
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/practices-packages.jsp"
                        class="nav-link <%= " practices-packages".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="practices-packages">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21 16V8a2 2 0 00-1-1.73l-7-4a2 2 0 00-2 0l-7 4A2 2 0 003 8v8a2 2 0 001 1.73l7 4a2 2 0 002 0l7-4A2 2 0 0021 16z" />
                        </svg>
                        <span>Code Organization</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/practices-junit.jsp"
                        class="nav-link <%= " practices-junit".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="practices-junit">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M22 11.08V12a10 10 0 11-5.93-9.14" />
                            <polyline points="22 4 12 14.01 9 11.01" />
                        </svg>
                        <span>Unit Testing</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/practices-patterns.jsp"
                        class="nav-link <%= " practices-patterns".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="practices-patterns">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
                        </svg>
                        <span>Design Patterns</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/practices-best-practices.jsp"
                        class="nav-link <%= " practices-best-practices".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="practices-best-practices">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z" />
                            <polyline points="14 2 14 8 20 8" />
                            <line x1="12" y1="18" x2="12" y2="12" />
                            <line x1="9" y1="15" x2="15" y2="15" />
                        </svg>
                        <span>Best Practices</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/practices-build-tools.jsp"
                        class="nav-link <%= " practices-build-tools".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="practices-build-tools">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4" />
                        </svg>
                        <span>Build Tools</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/practices-logging.jsp"
                        class="nav-link <%= " practices-logging".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="practices-logging">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z" />
                            <polyline points="14 2 14 8 20 8" />
                            <line x1="16" y1="13" x2="8" y2="13" />
                            <line x1="16" y1="17" x2="8" y2="17" />
                        </svg>
                        <span>Logging</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/practices-debugging.jsp"
                        class="nav-link <%= " practices-debugging".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="practices-debugging">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10" />
                            <line x1="12" y1="8" x2="12" y2="12" />
                            <line x1="12" y1="16" x2="12.01" y2="16" />
                        </svg>
                        <span>Debugging</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/java/practices-examples.jsp"
                        class="nav-link <%= " practices-examples".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="practices-examples">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
                        </svg>
                        <span>Real-World Examples</span>
                    </a>
                </li>
            </ul>
        </div>
    </nav>
</aside>

<style>
    /* Sidebar logo styling */
    .sidebar-logo {
        display: flex;
        align-items: center;
        justify-content: center;
        margin-bottom: var(--space-2);
    }

    .sidebar-logo img {
        width: 32px;
        height: 32px;
    }

    .sidebar-header {
        display: flex;
        flex-direction: column;
        align-items: center;
        padding: var(--space-4);
        border-bottom: 1px solid var(--border-color);
    }

    .sidebar-title {
        margin: 0;
        font-size: var(--text-lg);
        font-weight: 600;
    }
</style>
