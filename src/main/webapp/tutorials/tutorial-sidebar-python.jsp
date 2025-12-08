<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- Tutorial Sidebar Component - Python Navigation for Python Tutorial lessons Uses currentLesson attribute to
        highlight active item --%>
        <% String currentLesson=(String) request.getAttribute("currentLesson"); if (currentLesson==null)
            currentLesson="" ; %>
            <aside class="tutorial-sidebar" id="sidebar">
                <div class="sidebar-header">
                    <div class="sidebar-logo">
                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/python-logo.svg" alt="Python"
                            width="32" height="32">
                    </div>
                    <h2 class="sidebar-title">Python Tutorial</h2>
                </div>

                <nav class="sidebar-nav">
                    <%-- Module 1: Getting Started --%>
                        <div class="nav-section">
                            <div class="nav-section-title">Getting Started</div>
                            <ul class="nav-items">
                                <li class="nav-item">
                                    <a href="<%=request.getContextPath()%>/tutorials/python/intro.jsp"
                                        class="nav-link <%= " intro".equals(currentLesson) ? "active" : "" %>"
                                        data-lesson="intro">
                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                            stroke-width="2">
                                            <circle cx="12" cy="12" r="10" />
                                            <polygon points="10 8 16 12 10 16 10 8" />
                                        </svg>
                                        <span>Introduction</span>
                                    </a>
                                </li>
                            </ul>
                        </div>

                        <%-- Module 2: Variables & Data Types --%>
                            <div class="nav-section">
                                <div class="nav-section-title">Variables & Data Types</div>
                                <ul class="nav-items">
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/python/variables.jsp"
                                            class="nav-link <%= " variables".equals(currentLesson) ? "active" : "" %>"
                                            data-lesson="variables">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <path d="M4 7V4h16v3" />
                                                <path d="M9 20h6" />
                                                <path d="M12 4v16" />
                                            </svg>
                                            <span>Variables</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/python/numbers.jsp"
                                            class="nav-link <%= " numbers".equals(currentLesson) ? "active" : "" %>"
                                            data-lesson="numbers">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <path d="M4 4h4v4H4zM14 4h4v4h-4zM4 14h4v4H4z" />
                                                <path d="M14 14h6M14 18h6M17 14v4" />
                                            </svg>
                                            <span>Numbers</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/python/strings.jsp"
                                            class="nav-link <%= " strings".equals(currentLesson) ? "active" : "" %>"
                                            data-lesson="strings">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <path
                                                    d="M17 6H7c-1.1 0-2 .9-2 2v8c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2z" />
                                                <path d="M8 10h8M8 14h5" />
                                            </svg>
                                            <span>Strings</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/python/string-methods.jsp"
                                            class="nav-link <%= " string-methods".equals(currentLesson) ? "active" : ""
                                            %>" data-lesson="string-methods">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z" />
                                                <path d="M14 2v6h6M9 15h6M9 11h6" />
                                            </svg>
                                            <span>String Methods</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/python/booleans.jsp"
                                            class="nav-link <%= " booleans".equals(currentLesson) ? "active" : "" %>"
                                            data-lesson="booleans">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <path d="M9 11l3 3L22 4" />
                                                <path d="M21 12v7a2 2 0 01-2 2H5a2 2 0 01-2-2V5a2 2 0 012-2h11" />
                                            </svg>
                                            <span>Booleans</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/python/type-conversion.jsp"
                                            class="nav-link <%= " type-conversion".equals(currentLesson) ? "active" : ""
                                            %>" data-lesson="type-conversion">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <path d="M17 1l4 4-4 4" />
                                                <path d="M3 11V9a4 4 0 014-4h14" />
                                                <path d="M7 23l-4-4 4-4" />
                                                <path d="M21 13v2a4 4 0 01-4 4H3" />
                                            </svg>
                                            <span>Type Conversion</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/python/none-type.jsp"
                                            class="nav-link <%= " none-type".equals(currentLesson) ? "active" : "" %>"
                                            data-lesson="none-type">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <circle cx="12" cy="12" r="10" />
                                                <line x1="4.93" y1="4.93" x2="19.07" y2="19.07" />
                                            </svg>
                                            <span>None Type</span>
                                        </a>
                                    </li>
                                </ul>
                            </div>

                            <%-- Module 3: Operators --%>
                                <div class="nav-section">
                                    <div class="nav-section-title">Operators</div>
                                    <ul class="nav-items">
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/python/operators-arithmetic.jsp"
                                                class="nav-link <%= " operators-arithmetic".equals(currentLesson)
                                                ? "active" : "" %>" data-lesson="operators-arithmetic">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <line x1="12" y1="5" x2="12" y2="19" />
                                                    <line x1="5" y1="12" x2="19" y2="12" />
                                                </svg>
                                                <span>Arithmetic</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/python/operators-comparison.jsp"
                                                class="nav-link <%= " operators-comparison".equals(currentLesson)
                                                ? "active" : "" %>" data-lesson="operators-comparison">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M8 9l4-4 4 4" />
                                                    <path d="M16 15l-4 4-4-4" />
                                                </svg>
                                                <span>Comparison</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/python/operators-logical.jsp"
                                                class="nav-link <%= " operators-logical".equals(currentLesson)
                                                ? "active" : "" %>" data-lesson="operators-logical">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path
                                                        d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z" />
                                                    <line x1="4" y1="22" x2="4" y2="15" />
                                                </svg>
                                                <span>Logical</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/python/operators-assignment.jsp"
                                                class="nav-link <%= " operators-assignment".equals(currentLesson)
                                                ? "active" : "" %>" data-lesson="operators-assignment">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M16 18l6-6-6-6" />
                                                    <path d="M8 6l-6 6 6 6" />
                                                </svg>
                                                <span>Assignment</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/python/operators-bitwise.jsp"
                                                class="nav-link <%= " operators-bitwise".equals(currentLesson)
                                                ? "active" : "" %>" data-lesson="operators-bitwise">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M2 20h.01" />
                                                    <path d="M7 20v-4" />
                                                    <path d="M12 20v-8" />
                                                    <path d="M17 20V8" />
                                                    <path d="M22 4v16" />
                                                </svg>
                                                <span>Bitwise</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/python/operators-membership.jsp"
                                                class="nav-link <%= " operators-membership".equals(currentLesson)
                                                ? "active" : "" %>" data-lesson="operators-membership">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <circle cx="12" cy="12" r="10" />
                                                    <path d="M12 16v-4" />
                                                    <path d="M12 8h.01" />
                                                </svg>
                                                <span>Membership</span>
                                            </a>
                                        </li>
                                    </ul>
                                </div>

                                <%-- Module 4: Control Flow --%>
                                    <div class="nav-section">
                                        <div class="nav-section-title">Control Flow</div>
                                        <ul class="nav-items">
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/python/control-if.jsp"
                                                    class="nav-link <%= " control-if".equals(currentLesson) ? "active"
                                                    : "" %>" data-lesson="control-if">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <polyline points="16 3 21 3 21 8" />
                                                        <line x1="4" y1="20" x2="21" y2="3" />
                                                        <polyline points="21 16 21 21 16 21" />
                                                        <line x1="15" y1="15" x2="21" y2="21" />
                                                        <line x1="4" y1="4" x2="9" y2="9" />
                                                    </svg>
                                                    <span>If Statements</span>
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/python/control-ternary.jsp"
                                                    class="nav-link <%= " control-ternary".equals(currentLesson)
                                                    ? "active" : "" %>" data-lesson="control-ternary">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <path d="M8 9l4-4 4 4" />
                                                        <path d="M16 15l-4 4-4-4" />
                                                    </svg>
                                                    <span>Ternary Operator</span>
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/python/loops-for.jsp"
                                                    class="nav-link <%= " loops-for".equals(currentLesson) ? "active"
                                                    : "" %>" data-lesson="loops-for">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <path d="M21 12a9 9 0 1 1-9-9c2.52 0 4.93 1 6.74 2.74L21 8" />
                                                        <path d="M21 3v5h-5" />
                                                    </svg>
                                                    <span>For Loops</span>
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/python/loops-while.jsp"
                                                    class="nav-link <%= " loops-while".equals(currentLesson) ? "active"
                                                    : "" %>" data-lesson="loops-while">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
                                                    </svg>
                                                    <span>While Loops</span>
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/python/loops-control.jsp"
                                                    class="nav-link <%= " loops-control".equals(currentLesson)
                                                    ? "active" : "" %>" data-lesson="loops-control">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <rect x="6" y="4" width="4" height="16" />
                                                        <rect x="14" y="4" width="4" height="16" />
                                                    </svg>
                                                    <span>Loop Control</span>
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/python/loops-nested.jsp"
                                                    class="nav-link <%= " loops-nested".equals(currentLesson) ? "active"
                                                    : "" %>" data-lesson="loops-nested">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <rect x="3" y="3" width="7" height="7" />
                                                        <rect x="14" y="3" width="7" height="7" />
                                                        <rect x="14" y="14" width="7" height="7" />
                                                        <rect x="3" y="14" width="7" height="7" />
                                                    </svg>
                                                    <span>Nested Loops</span>
                                                </a>
                                            </li>
                                        </ul>
                                    </div>

                                    <%-- Module 5: Data Structures --%>
                                        <div class="nav-section">
                                            <div class="nav-section-title">Data Structures</div>
                                            <ul class="nav-items">
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/python/lists.jsp"
                                                        class="nav-link <%= " lists".equals(currentLesson) ? "active"
                                                        : "" %>" data-lesson="lists">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <line x1="8" y1="6" x2="21" y2="6" />
                                                            <line x1="8" y1="12" x2="21" y2="12" />
                                                            <line x1="8" y1="18" x2="21" y2="18" />
                                                            <line x1="3" y1="6" x2="3.01" y2="6" />
                                                            <line x1="3" y1="12" x2="3.01" y2="12" />
                                                            <line x1="3" y1="18" x2="3.01" y2="18" />
                                                        </svg>
                                                        <span>Lists</span>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/python/lists-methods.jsp"
                                                        class="nav-link <%= " lists-methods".equals(currentLesson)
                                                        ? "active" : "" %>" data-lesson="lists-methods">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <path
                                                                d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                                            <path
                                                                d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                                                        </svg>
                                                        <span>List Methods</span>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/python/lists-comprehension.jsp"
                                                        class="nav-link <%= " lists-comprehension".equals(currentLesson)
                                                        ? "active" : "" %>" data-lesson="lists-comprehension">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <polyline points="4 14 10 14 10 20" />
                                                            <polyline points="20 10 14 10 14 4" />
                                                            <line x1="14" y1="10" x2="21" y2="3" />
                                                            <line x1="3" y1="21" x2="10" y2="14" />
                                                        </svg>
                                                        <span>List Comprehension</span>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/python/tuples.jsp"
                                                        class="nav-link <%= " tuples".equals(currentLesson) ? "active"
                                                        : "" %>" data-lesson="tuples">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <path
                                                                d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71" />
                                                            <path
                                                                d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71" />
                                                        </svg>
                                                        <span>Tuples</span>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/python/sets.jsp"
                                                        class="nav-link <%= " sets".equals(currentLesson) ? "active"
                                                        : "" %>" data-lesson="sets">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <circle cx="12" cy="12" r="10" />
                                                            <circle cx="12" cy="12" r="4" />
                                                        </svg>
                                                        <span>Sets</span>
                                                    </a>
                                                </li>

                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/python/dictionaries.jsp"
                                                        class="nav-link <%= " dictionaries".equals(currentLesson)
                                                        ? "active" : "" %>" data-lesson="dictionaries">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
                                                            <path
                                                                d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
                                                        </svg>
                                                        <span>Dictionaries</span>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/python/dictionaries-comprehension.jsp"
                                                        class="nav-link <%= "dictionaries-comprehension".equals(currentLesson) ? "active"
                                                        : "" %>" data-lesson="dictionaries-comprehension">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <path
                                                                d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                                                            <polyline points="14 2 14 8 20 8" />
                                                            <line x1="16" y1="13" x2="8" y2="13" />
                                                            <line x1="16" y1="17" x2="8" y2="17" />
                                                            <polyline points="10 9 9 9 8 9" />
                                                        </svg>
                                                        <span>Dict Comprehension</span>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/python/nested-structures.jsp"
                                                        class="nav-link <%= " nested-structures".equals(currentLesson)
                                                        ? "active" : "" %>"
                                                        data-lesson="nested-structures">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <polyline points="9 11 12 14 22 4" />
                                                            <path
                                                                d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11" />
                                                        </svg>
                                                        <span>Nested Structures</span>
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>

                                        <%-- Module 6: Functions --%>
                                            <div class="nav-section">
                                                <div class="nav-section-title">Functions</div>
                                                <ul class="nav-items">
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/python/functions.jsp"
                                                            class="nav-link <%= " functions".equals(currentLesson)
                                                            ? "active" : "" %>" data-lesson="functions">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <rect x="3" y="3" width="18" height="18" rx="2"
                                                                    ry="2" />
                                                                <path d="M9 9l6 6" />
                                                            </svg>
                                                            <span>Defining Functions</span>
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/python/functions-arguments.jsp"
                                                            class="nav-link <%= "functions-arguments".equals(currentLesson) ? "active" : ""
                                                            %>" data-lesson="functions-arguments">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <path d="M12 2L2 7l10 5 10-5-10-5z" />
                                                                <path d="M2 17l10 5 10-5" />
                                                                <path d="M2 12l10 5 10-5" />
                                                            </svg>
                                                            <span>Arguments & Returns</span>
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/python/functions-return.jsp"
                                                            class="nav-link <%= "functions-return".equals(currentLesson) ? "active" : "" %>"
                                                            data-lesson="functions-return">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <polyline points="9 10 4 15 9 20" />
                                                                <path d="M20 4v7a4 4 0 0 1-4 4H4" />
                                                            </svg>
                                                            <span>Return Values</span>
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/python/functions-scope.jsp"
                                                            class="nav-link <%= " functions-scope".equals(currentLesson)
                                                            ? "active" : "" %>" data-lesson="functions-scope">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <circle cx="12" cy="12" r="10" />
                                                                <line x1="2" y1="12" x2="22" y2="12" />
                                                                <path
                                                                    d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z" />
                                                            </svg>
                                                            <span>Variable Scope</span>
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/python/functions-lambda.jsp"
                                                            class="nav-link <%= "functions-lambda".equals(currentLesson) ? "active" : "" %>"
                                                            data-lesson="functions-lambda">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <polyline points="4 17 10 11 4 5" />
                                                                <line x1="12" y1="19" x2="20" y2="19" />
                                                            </svg>
                                                            <span>Lambda Functions</span>
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/python/functions-recursion.jsp"
                                                            class="nav-link <%= "functions-recursion".equals(currentLesson) ? "active" : ""
                                                            %>" data-lesson="functions-recursion">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <polyline points="23 4 23 10 17 10" />
                                                                <path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10" />
                                                            </svg>
                                                            <span>Recursion</span>
                                                        </a>
                                                    </li>
                                                </ul>
                                            </div>

                                            <%-- Module 7: Modules & Packages --%>
                                                <div class="nav-section">
                                                    <div class="nav-section-title">Modules & Packages</div>
                                                    <ul class="nav-items">
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/python/modules.jsp"
                                                                class="nav-link <%= " modules".equals(currentLesson)
                                                                ? "active" : "" %>" data-lesson="modules">
                                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <rect x="3" y="3" width="7" height="7" />
                                                                    <rect x="14" y="3" width="7" height="7" />
                                                                    <rect x="14" y="14" width="7" height="7" />
                                                                    <rect x="3" y="14" width="7" height="7" />
                                                                </svg>
                                                                <span>Modules</span>
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/python/modules-dates.jsp"
                                                                class="nav-link <%= "modules-dates".equals(currentLesson) ? "active" : "" %>"
                                                                data-lesson="modules-dates">
                                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <rect x="3" y="4" width="18" height="18" rx="2"
                                                                        ry="2" />
                                                                    <line x1="16" y1="2" x2="16" y2="6" />
                                                                    <line x1="8" y1="2" x2="8" y2="6" />
                                                                    <line x1="3" y1="10" x2="21" y2="10" />
                                                                </svg>
                                                                <span>Dates</span>
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/python/modules-math.jsp"
                                                                class="nav-link <%= "modules-math".equals(currentLesson) ? "active" : "" %>"
                                                                data-lesson="modules-math">
                                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <circle cx="12" cy="12" r="10" />
                                                                    <path d="M8 12h8" />
                                                                    <path d="M12 8v8" />
                                                                </svg>
                                                                <span>Math</span>
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/python/modules-json.jsp"
                                                                class="nav-link <%= "modules-json".equals(currentLesson) ? "active" : "" %>"
                                                                data-lesson="modules-json">
                                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <path
                                                                        d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                                                                    <polyline points="14 2 14 8 20 8" />
                                                                    <line x1="12" y1="18" x2="12" y2="12" />
                                                                    <line x1="9" y1="15" x2="15" y2="15" />
                                                                </svg>
                                                                <span>JSON</span>
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/python/modules-regex.jsp"
                                                                class="nav-link <%= "modules-regex".equals(currentLesson) ? "active" : "" %>"
                                                                data-lesson="modules-regex">
                                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <path
                                                                        d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                                                                </svg>
                                                                <span>RegEx</span>
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/python/modules-pip.jsp"
                                                                class="nav-link <%= " modules-pip".equals(currentLesson)
                                                                ? "active" : "" %>" data-lesson="modules-pip">
                                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <path
                                                                        d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
                                                                    <polyline points="3.27 6.96 12 12.01 20.73 6.96" />
                                                                    <line x1="12" y1="22.08" x2="12" y2="12" />
                                                                </svg>
                                                                <span>PIP</span>
                                                            </a>
                                                        </li>
                                                    </ul>
                                                </div>

                                                <%-- Module 8: File Handling --%>
                                                    <div class="nav-section">
                                                        <div class="nav-section-title">File Handling</div>
                                                        <ul class="nav-items">
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/python/files-read.jsp"
                                                                    class="nav-link <%= "files-read".equals(currentLesson) ? "active" : ""
                                                                    %>" data-lesson="files-read">
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
                                                                    <span>Reading Files</span>
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/python/files-write.jsp"
                                                                    class="nav-link <%= "files-write".equals(currentLesson) ? "active" : ""
                                                                    %>" data-lesson="files-write">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <path
                                                                            d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                                                        <path
                                                                            d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                                                                    </svg>
                                                                    <span>Writing Files</span>
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/python/files-context.jsp"
                                                                    class="nav-link <%= "files-context".equals(currentLesson) ? "active" : ""
                                                                    %>" data-lesson="files-context">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <path
                                                                            d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                                                                        <polyline points="14 2 14 8 20 8" />
                                                                        <line x1="12" y1="18" x2="12" y2="12" />
                                                                        <line x1="9" y1="15" x2="15" y2="15" />
                                                                    </svg>
                                                                    <span>Context Managers</span>
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/python/files-paths.jsp"
                                                                    class="nav-link <%= "files-paths".equals(currentLesson) ? "active" : ""
                                                                    %>" data-lesson="files-paths">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <polyline points="3 6 5 6 21 6" />
                                                                        <path
                                                                            d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2" />
                                                                    </svg>
                                                                    <span>Working with Paths</span>
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/python/files-csv.jsp"
                                                                    class="nav-link <%= "files-csv".equals(currentLesson) ? "active" : "" %>"
                                                                    data-lesson="files-csv">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <path
                                                                            d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                                                                        <polyline points="14 2 14 8 20 8" />
                                                                        <line x1="8" y1="13" x2="16" y2="13" />
                                                                        <line x1="8" y1="17" x2="16" y2="17" />
                                                                        <line x1="10" y1="9" x2="8" y2="9" />
                                                                    </svg>
                                                                    <span>CSV Files</span>
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/python/files-json.jsp"
                                                                    class="nav-link <%= "files-json".equals(currentLesson) ? "active" : ""
                                                                    %>" data-lesson="files-json">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <path
                                                                            d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                                                                        <polyline points="14 2 14 8 20 8" />
                                                                        <line x1="12" y1="18" x2="12" y2="12" />
                                                                        <line x1="9" y1="15" x2="15" y2="15" />
                                                                    </svg>
                                                                    <span>JSON Files</span>
                                                                </a>
                                                            </li>
                                                        </ul>
                                                    </div>

                                                    <%-- Module 9: Error Handling --%>
                                                        <div class="nav-section">
                                                            <div class="nav-section-title">Error Handling</div>
                                                            <ul class="nav-items">
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/python/errors-basics.jsp"
                                                                        class="nav-link <%= "errors-basics".equals(currentLesson) ? "active"
                                                                        : "" %>" data-lesson="errors-basics">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <circle cx="12" cy="12" r="10"></circle>
                                                                            <line x1="12" y1="8" x2="12" y2="12"></line>
                                                                            <line x1="12" y1="16" x2="12.01" y2="16">
                                                                            </line>
                                                                        </svg>
                                                                        <span>Exceptions</span>
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/python/errors-try-except.jsp"
                                                                        class="nav-link <%= "errors-try-except".equals(currentLesson)
                                                                        ? "active" : "" %>"
                                                                        data-lesson="errors-try-except">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <path
                                                                                d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z">
                                                                            </path>
                                                                            <line x1="12" y1="9" x2="12" y2="13"></line>
                                                                            <line x1="12" y1="17" x2="12.01" y2="17">
                                                                            </line>
                                                                        </svg>
                                                                        <span>Try/Except</span>
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/python/errors-finally.jsp"
                                                                        class="nav-link <%= "errors-finally".equals(currentLesson) ? "active"
                                                                        : "" %>" data-lesson="errors-finally">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <polyline points="9 11 12 14 22 4">
                                                                            </polyline>
                                                                            <path
                                                                                d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11">
                                                                            </path>
                                                                        </svg>
                                                                        <span>Finally & Else</span>
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/python/errors-raise.jsp"
                                                                        class="nav-link <%= "errors-raise".equals(currentLesson) ? "active"
                                                                        : "" %>" data-lesson="errors-raise">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <circle cx="12" cy="12" r="10"></circle>
                                                                            <line x1="15" y1="9" x2="9" y2="15"></line>
                                                                            <line x1="9" y1="9" x2="15" y2="15"></line>
                                                                        </svg>
                                                                        <span>Raising Exceptions</span>
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/python/errors-assert.jsp"
                                                                        class="nav-link <%= "errors-assert".equals(currentLesson) ? "active"
                                                                        : "" %>" data-lesson="errors-assert">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <path
                                                                                d="M22 11.08V12a10 10 0 1 1-5.93-9.14">
                                                                            </path>
                                                                            <polyline points="22 4 12 14.01 9 11.01">
                                                                            </polyline>
                                                                        </svg>
                                                                        <span>Assertions</span>
                                                                    </a>
                                                                </li>
                                                            </ul>
                                                        </div>

                                                        <div class="nav-section">
                                                            <div class="nav-section-title">Object-Oriented Programming
                                                            </div>
                                                            <ul class="nav-items">
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/python/oop-classes.jsp"
                                                                        class="nav-link <%= "oop-classes".equals(currentLesson) ? "active"
                                                                        : "" %>"
                                                                        data-lesson="oop-classes">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <path
                                                                                d="M16.5 9.4l-9-5.19M21 16V8a2 2 0 00-1-1.73l-7-4a2 2 0 00-2 0l-7 4A2 2 0 003 8v8a2 2 0 001 1.73l7 4a2 2 0 002 0l7-4A2 2 0 0021 16z">
                                                                            </path>
                                                                        </svg>
                                                                        <span>Classes & Objects</span>
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/python/oop-methods.jsp"
                                                                        class="nav-link <%= "oop-methods".equals(currentLesson) ? "active"
                                                                        : "" %>"
                                                                        data-lesson="oop-methods">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <circle cx="12" cy="12" r="3"></circle>
                                                                            <path
                                                                                d="M19.4 15a1.65 1.65 0 00.33 1.82l.06.06a2 2 0 010 2.83 2 2 0 01-2.83 0l-.06-.06a1.65 1.65 0 00-1.82-.33 1.65 1.65 0 00-1 1.51V21a2 2 0 01-2 2 2 2 0 01-2-2v-.09A1.65 1.65 0 009 19.4a1.65 1.65 0 00-1.82.33l-.06.06a2 2 0 01-2.83 0 2 2 0 010-2.83l.06-.06a1.65 1.65 0 00.33-1.82 1.65 1.65 0 00-1.51-1H3a2 2 0 01-2-2 2 2 0 012-2h.09A1.65 1.65 0 004.6 9a1.65 1.65 0 00-.33-1.82l-.06-.06a2 2 0 010-2.83 2 2 0 012.83 0l.06.06a1.65 1.65 0 001.82.33H9a1.65 1.65 0 001-1.51V3a2 2 0 012-2 2 2 0 012 2v.09a1.65 1.65 0 001 1.51 1.65 1.65 0 001.82-.33l.06-.06a2 2 0 012.83 0 2 2 0 010 2.83l-.06.06a1.65 1.65 0 00-.33 1.82V9a1.65 1.65 0 001.51 1H21a2 2 0 012 2 2 2 0 01-2 2h-.09a1.65 1.65 0 00-1.51 1z">
                                                                            </path>
                                                                        </svg>
                                                                        <span>Methods</span>
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/python/oop-inheritance.jsp"
                                                                        class="nav-link <%= "oop-inheritance".equals(currentLesson)
                                                                        ? "active" : "" %>"
                                                                        data-lesson="oop-inheritance">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <rect x="3" y="3" width="7" height="7">
                                                                            </rect>
                                                                            <rect x="14" y="3" width="7" height="7">
                                                                            </rect>
                                                                            <rect x="14" y="14" width="7" height="7">
                                                                            </rect>
                                                                            <path d="M10 6.5h4"></path>
                                                                            <path d="M17.5 10v4"></path>
                                                                        </svg>
                                                                        <span>Inheritance</span>
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/python/oop-encapsulation.jsp"
                                                                        class="nav-link <%= "oop-encapsulation".equals(currentLesson)
                                                                        ? "active" : "" %>"
                                                                        data-lesson="oop-encapsulation">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <rect x="3" y="11" width="18" height="11"
                                                                                rx="2" ry="2"></rect>
                                                                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                                                        </svg>
                                                                        <span>Encapsulation</span>
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/python/oop-polymorphism.jsp"
                                                                        class="nav-link <%= "oop-polymorphism".equals(currentLesson)
                                                                        ? "active" : "" %>"
                                                                        data-lesson="oop-polymorphism">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <path
                                                                                d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2">
                                                                            </path>
                                                                            <circle cx="9" cy="7" r="4"></circle>
                                                                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                                                            <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                                                        </svg>
                                                                        <span>Polymorphism</span>
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/python/oop-dunder.jsp"
                                                                        class="nav-link <%= "oop-dunder".equals(currentLesson) ? "active"
                                                                        : "" %>"
                                                                        data-lesson="oop-dunder">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <polyline points="16 18 22 12 16 6">
                                                                            </polyline>
                                                                            <polyline points="8 6 2 12 8 18"></polyline>
                                                                        </svg>
                                                                        <span>Special Methods</span>
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/python/oop-properties.jsp"
                                                                        class="nav-link <%= "oop-properties".equals(currentLesson) ? "active"
                                                                        : "" %>"
                                                                        data-lesson="oop-properties">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <path
                                                                                d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7">
                                                                            </path>
                                                                            <path
                                                                                d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z">
                                                                            </path>
                                                                        </svg>
                                                                        <span>Properties</span>
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/python/oop-abstract.jsp"
                                                                        class="nav-link <%= "oop-abstract".equals(currentLesson) ? "active"
                                                                        : "" %>"
                                                                        data-lesson="oop-abstract">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <path
                                                                                d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z">
                                                                            </path>
                                                                            <path
                                                                                d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z">
                                                                            </path>
                                                                        </svg>
                                                                        <span>Abstract Classes</span>
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/python/oop-dataclass.jsp"
                                                                        class="nav-link <%= "oop-dataclass".equals(currentLesson) ? "active"
                                                                        : "" %>"
                                                                        data-lesson="oop-dataclass">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <path
                                                                                d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z">
                                                                            </path>
                                                                            <polyline points="14 2 14 8 20 8">
                                                                            </polyline>
                                                                            <line x1="16" y1="13" x2="8" y2="13"></line>
                                                                            <line x1="16" y1="17" x2="8" y2="17"></line>
                                                                            <polyline points="10 9 9 9 8 9"></polyline>
                                                                        </svg>
                                                                        <span>Dataclasses</span>
                                                                    </a>
                                                                </li>
                                                            </ul>
                                                        </div>

                                                        <div class="nav-section">
                                                            <div class="nav-section-title">Advanced Topics</div>
                                                            <ul class="nav-items">
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/python/adv-iterators.jsp"
                                                                        class="nav-link <%= "adv-iterators".equals(currentLesson) ? "active"
                                                                        : "" %>"
                                                                        data-lesson="adv-iterators">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <path d="M1 4v6h6"></path>
                                                                            <path d="M3.51 15a9 9 0 1 0 2.13-9.36L1 10">
                                                                            </path>
                                                                        </svg>
                                                                        <span>Iterators</span>
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/python/adv-generators.jsp"
                                                                        class="nav-link <%= "adv-generators".equals(currentLesson) ? "active"
                                                                        : "" %>"
                                                                        data-lesson="adv-generators">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z">
                                                                            </path>
                                                                        </svg>
                                                                        <span>Generators</span>
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/python/adv-decorators.jsp"
                                                                        class="nav-link <%= "adv-decorators".equals(currentLesson) ? "active"
                                                                        : "" %>"
                                                                        data-lesson="adv-decorators">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <circle cx="12" cy="12" r="10"></circle>
                                                                            <path d="M8 14s1.5 2 4 2 4-2 4-2"></path>
                                                                            <line x1="9" y1="9" x2="9.01" y2="9"></line>
                                                                            <line x1="15" y1="9" x2="15.01" y2="9">
                                                                            </line>
                                                                        </svg>
                                                                        <span>Decorators</span>
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/python/adv-context.jsp"
                                                                        class="nav-link <%= "adv-context".equals(currentLesson) ? "active"
                                                                        : "" %>"
                                                                        data-lesson="adv-context">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <path
                                                                                d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z">
                                                                            </path>
                                                                            <polyline points="14 2 14 8 20 8">
                                                                            </polyline>
                                                                            <line x1="16" y1="13" x2="8" y2="13"></line>
                                                                            <line x1="16" y1="17" x2="8" y2="17"></line>
                                                                            <polyline points="10 9 9 9 8 9"></polyline>
                                                                        </svg>
                                                                        <span>Context Managers</span>
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/python/adv-regex.jsp"
                                                                        class="nav-link <%= "adv-regex".equals(currentLesson) ? "active" : ""
                                                                        %>"
                                                                        data-lesson="adv-regex">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <path
                                                                                d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z">
                                                                            </path>
                                                                            <polyline
                                                                                points="3.27 6.96 12 12.01 20.73 6.96">
                                                                            </polyline>
                                                                            <line x1="12" y1="22.08" x2="12" y2="12">
                                                                            </line>
                                                                        </svg>
                                                                        <span>Regular Expressions</span>
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/python/adv-typing.jsp"
                                                                        class="nav-link <%= "adv-typing".equals(currentLesson) ? "active"
                                                                        : "" %>"
                                                                        data-lesson="adv-typing">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <polyline points="4 7 4 4 20 4 20 7">
                                                                            </polyline>
                                                                            <line x1="9" y1="20" x2="15" y2="20"></line>
                                                                            <line x1="12" y1="4" x2="12" y2="20"></line>
                                                                        </svg>
                                                                        <span>Type Hinting</span>
                                                                    </a>
                                                                </li>
                                                            </ul>
                                                        </div>

                                                        <div class="nav-section">
                                                            <div class="nav-section-title">Professional Practices</div>
                                                            <ul class="nav-items">
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/python/prof-venv.jsp"
                                                                        class="nav-link <%= "prof-venv".equals(currentLesson) ? "active" : ""
                                                                        %>"
                                                                        data-lesson="prof-venv">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <path
                                                                                d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z">
                                                                            </path>
                                                                            <polyline
                                                                                points="3.27 6.96 12 12.01 20.73 6.96">
                                                                            </polyline>
                                                                            <line x1="12" y1="22.08" x2="12" y2="12">
                                                                            </line>
                                                                        </svg>
                                                                        <span>Virtual Envs</span>
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/python/prof-testing.jsp"
                                                                        class="nav-link <%= "prof-testing".equals(currentLesson) ? "active"
                                                                        : "" %>"
                                                                        data-lesson="prof-testing">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <path
                                                                                d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z">
                                                                            </path>
                                                                            <polyline points="14 2 14 8 20 8">
                                                                            </polyline>
                                                                            <line x1="16" y1="13" x2="8" y2="13"></line>
                                                                            <line x1="16" y1="17" x2="8" y2="17"></line>
                                                                            <polyline points="10 9 9 9 8 9"></polyline>
                                                                        </svg>
                                                                        <span>Unit Testing</span>
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/python/prof-logging.jsp"
                                                                        class="nav-link <%= "prof-logging".equals(currentLesson) ? "active"
                                                                        : "" %>"
                                                                        data-lesson="prof-logging">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <line x1="8" y1="6" x2="21" y2="6"></line>
                                                                            <line x1="8" y1="12" x2="21" y2="12"></line>
                                                                            <line x1="8" y1="18" x2="21" y2="18"></line>
                                                                            <line x1="3" y1="6" x2="3.01" y2="6"></line>
                                                                            <line x1="3" y1="12" x2="3.01" y2="12">
                                                                            </line>
                                                                            <line x1="3" y1="18" x2="3.01" y2="18">
                                                                            </line>
                                                                        </svg>
                                                                        <span>Logging</span>
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/python/prof-args.jsp"
                                                                        class="nav-link <%= "prof-args".equals(currentLesson) ? "active" : ""
                                                                        %>"
                                                                        data-lesson="prof-args">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <polyline points="4 17 10 11 4 5">
                                                                            </polyline>
                                                                            <line x1="12" y1="19" x2="20" y2="19">
                                                                            </line>
                                                                        </svg>
                                                                        <span>Command Line Args</span>
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/python/prof-sqlite.jsp"
                                                                        class="nav-link <%= "prof-sqlite".equals(currentLesson) ? "active"
                                                                        : "" %>"
                                                                        data-lesson="prof-sqlite">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <path
                                                                                d="M3 3h18v18H3zM21 9H3M21 15H3M12 3v18">
                                                                            </path>
                                                                        </svg>
                                                                        <span>SQLite Database</span>
                                                                    </a>
                                                                </li>
                                                            </ul>
                                                        </div>

                                                        <%-- Sidebar Ad --%>
<%--                                                            <div class="sidebar-ad-container"--%>
<%--                                                                style="padding: var(--space-4); margin-top: var(--space-4);">--%>
<%--                                                                <%@ include file="ads/ad-sidebar.jsp" %>--%>
<%--                                                            </div>--%>
                </nav>
            </aside>

            <style>
                /* Coming soon badge for disabled items */
                .nav-item.disabled .nav-link {
                    opacity: 0.5;
                    cursor: not-allowed;
                    pointer-events: none;
                }

                .coming-soon {
                    margin-left: auto;
                    font-size: var(--text-xs, 0.75rem);
                    padding: 2px 6px;
                    background: var(--bg-tertiary, #f1f5f9);
                    color: var(--text-muted, #94a3b8);
                    border-radius: 4px;
                    font-weight: 500;
                }

                [data-theme="dark"] .coming-soon {
                    background: #333;
                }

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