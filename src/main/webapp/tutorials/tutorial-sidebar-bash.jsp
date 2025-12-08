<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- Tutorial Sidebar Component - Bash Navigation for Bash Tutorial lessons Uses currentLesson attribute to highlight active item --%>
<% String currentLesson = (String) request.getAttribute("currentLesson");
   if (currentLesson == null) currentLesson = ""; %>
<aside class="tutorial-sidebar" id="sidebar">
    <div class="sidebar-header">
        <div class="sidebar-logo">
            <img src="<%=request.getContextPath()%>/tutorials/assets/images/bash-logo.svg" alt="Bash" width="32" height="32">
        </div>
        <h2 class="sidebar-title">Bash Tutorial</h2>
    </div>

    <nav class="sidebar-nav">
        <%-- Module 1: Getting Started --%>
        <div class="nav-section">
            <div class="nav-section-title">Getting Started</div>
            <ul class="nav-items">
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/intro.jsp"
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
                    <a href="<%=request.getContextPath()%>/tutorials/bash/first-script.jsp"
                        class="nav-link <%= " first-script".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="first-script">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="16 18 22 12 16 6"></polyline>
                            <polyline points="8 6 2 12 8 18"></polyline>
                        </svg>
                        <span>First Script</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/terminal-basics.jsp"
                        class="nav-link <%= " terminal-basics".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="terminal-basics">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="4 17 10 11 4 5"></polyline>
                            <line x1="12" y1="19" x2="20" y2="19"></line>
                        </svg>
                        <span>Terminal Basics</span>
                    </a>
                </li>
            </ul>
        </div>

        <%-- Module 2: Variables & Environment --%>
        <div class="nav-section">
            <div class="nav-section-title">Variables & Environment</div>
            <ul class="nav-items">
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/variables-basics.jsp"
                        class="nav-link <%= " variables-basics".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="variables-basics">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M4 7V4h16v3" />
                            <path d="M9 20h6" />
                            <path d="M12 4v16" />
                        </svg>
                        <span>Variables</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/variables-expansion.jsp"
                        class="nav-link <%= " variables-expansion".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="variables-expansion">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                            <polyline points="14 2 14 8 20 8"></polyline>
                            <line x1="16" y1="13" x2="8" y2="13"></line>
                            <line x1="16" y1="17" x2="8" y2="17"></line>
                        </svg>
                        <span>Variable Expansion</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/variables-environment.jsp"
                        class="nav-link <%= " variables-environment".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="variables-environment">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10" />
                            <line x1="2" y1="12" x2="22" y2="12" />
                            <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z" />
                        </svg>
                        <span>Environment Variables</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/variables-special.jsp"
                        class="nav-link <%= " variables-special".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="variables-special">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="4 14 10 14 10 20" />
                            <polyline points="20 10 14 10 14 4" />
                            <line x1="14" y1="10" x2="21" y2="3" />
                            <line x1="3" y1="21" x2="10" y2="14" />
                        </svg>
                        <span>Special Variables</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/variables-arrays.jsp"
                        class="nav-link <%= " variables-arrays".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="variables-arrays">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="8" y1="6" x2="21" y2="6" />
                            <line x1="8" y1="12" x2="21" y2="12" />
                            <line x1="8" y1="18" x2="21" y2="18" />
                            <line x1="3" y1="6" x2="3.01" y2="6" />
                            <line x1="3" y1="12" x2="3.01" y2="12" />
                            <line x1="3" y1="18" x2="3.01" y2="18" />
                        </svg>
                        <span>Arrays</span>
                    </a>
                </li>
            </ul>
        </div>

        <%-- Module 3: Strings & Text Processing --%>
        <div class="nav-section">
            <div class="nav-section-title">Strings & Text Processing</div>
            <ul class="nav-items">
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/strings-basics.jsp"
                        class="nav-link <%= " strings-basics".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="strings-basics">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M17 6H7c-1.1 0-2 .9-2 2v8c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2z" />
                            <path d="M8 10h8M8 14h5" />
                        </svg>
                        <span>String Basics</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/strings-manipulation.jsp"
                        class="nav-link <%= " strings-manipulation".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="strings-manipulation">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                        </svg>
                        <span>String Manipulation</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/strings-parameter-expansion.jsp"
                        class="nav-link <%= " strings-parameter-expansion".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="strings-parameter-expansion">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                            <polyline points="14 2 14 8 20 8" />
                            <line x1="16" y1="13" x2="8" y2="13" />
                            <line x1="16" y1="17" x2="8" y2="17" />
                        </svg>
                        <span>Parameter Expansion</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/strings-heredoc.jsp"
                        class="nav-link <%= " strings-heredoc".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="strings-heredoc">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                            <polyline points="14 2 14 8 20 8" />
                            <line x1="16" y1="13" x2="8" y2="13" />
                            <line x1="16" y1="17" x2="8" y2="17" />
                        </svg>
                        <span>Here Documents</span>
                    </a>
                </li>
            </ul>
        </div>

        <%-- Module 4: Operators & Arithmetic --%>
        <div class="nav-section">
            <div class="nav-section-title">Operators & Arithmetic</div>
            <ul class="nav-items">
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/operators-arithmetic.jsp"
                        class="nav-link <%= " operators-arithmetic".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="operators-arithmetic">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="12" y1="5" x2="12" y2="19" />
                            <line x1="5" y1="12" x2="19" y2="12" />
                        </svg>
                        <span>Arithmetic Operations</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/operators-comparison.jsp"
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
                    <a href="<%=request.getContextPath()%>/tutorials/bash/operators-logical.jsp"
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
                    <a href="<%=request.getContextPath()%>/tutorials/bash/operators-file-test.jsp"
                        class="nav-link <%= " operators-file-test".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="operators-file-test">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                            <polyline points="14 2 14 8 20 8" />
                        </svg>
                        <span>File Test Operators</span>
                    </a>
                </li>
            </ul>
        </div>

        <%-- Module 5: Control Flow --%>
        <div class="nav-section">
            <div class="nav-section-title">Control Flow</div>
            <ul class="nav-items">
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/control-if.jsp"
                        class="nav-link <%= " control-if".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="control-if">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
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
                    <a href="<%=request.getContextPath()%>/tutorials/bash/control-case.jsp"
                        class="nav-link <%= " control-case".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="control-case">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M8 9l4-4 4 4" />
                            <path d="M16 15l-4 4-4-4" />
                        </svg>
                        <span>Case Statements</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/loops-for.jsp"
                        class="nav-link <%= " loops-for".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="loops-for">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21 12a9 9 0 1 1-9-9c2.52 0 4.93 1 6.74 2.74L21 8" />
                            <path d="M21 3v5h-5" />
                        </svg>
                        <span>For Loops</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/loops-while.jsp"
                        class="nav-link <%= " loops-while".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="loops-while">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
                        </svg>
                        <span>While & Until Loops</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/loops-control.jsp"
                        class="nav-link <%= " loops-control".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="loops-control">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="6" y="4" width="4" height="16" />
                            <rect x="14" y="4" width="4" height="16" />
                        </svg>
                        <span>Loop Control</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/loops-select.jsp"
                        class="nav-link <%= " loops-select".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="loops-select">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10" />
                            <path d="M12 16v-4" />
                            <path d="M12 8h.01" />
                        </svg>
                        <span>Select Menus</span>
                    </a>
                </li>
            </ul>
        </div>

        <%-- Module 6: Functions --%>
        <div class="nav-section">
            <div class="nav-section-title">Functions</div>
            <ul class="nav-items">
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/functions-basics.jsp"
                        class="nav-link <%= "functions-basics".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="functions-basics">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                            <path d="M9 9l6 6" />
                        </svg>
                        <span>Defining Functions</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/functions-parameters.jsp"
                        class="nav-link <%= "functions-parameters".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="functions-parameters">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M12 2L2 7l10 5 10-5-10-5z" />
                            <path d="M2 17l10 5 10-5" />
                            <path d="M2 12l10 5 10-5" />
                        </svg>
                        <span>Function Parameters</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/functions-return.jsp"
                        class="nav-link <%= "functions-return".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="functions-return">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="9 10 4 15 9 20" />
                            <path d="M20 4v7a4 4 0 0 1-4 4H4" />
                        </svg>
                        <span>Return Values</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/functions-scope.jsp"
                        class="nav-link <%= "functions-scope".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="functions-scope">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10" />
                            <line x1="2" y1="12" x2="22" y2="12" />
                            <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z" />
                        </svg>
                        <span>Function Scope</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/functions-recursive.jsp"
                        class="nav-link <%= "functions-recursive".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="functions-recursive">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="23 4 23 10 17 10" />
                            <path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10" />
                        </svg>
                        <span>Recursive Functions</span>
                    </a>
                </li>
            </ul>
        </div>

        <%-- Module 7: Input & Output --%>
        <div class="nav-section">
            <div class="nav-section-title">Input & Output</div>
            <ul class="nav-items">
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/io-read.jsp"
                        class="nav-link <%= " io-read".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="io-read">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
                            <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
                        </svg>
                        <span>Reading Input</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/io-redirection.jsp"
                        class="nav-link <%= " io-redirection".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="io-redirection">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="4 14 10 14 10 20" />
                            <polyline points="20 10 14 10 14 4" />
                            <line x1="14" y1="10" x2="21" y2="3" />
                            <line x1="3" y1="21" x2="10" y2="14" />
                        </svg>
                        <span>Output Redirection</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/io-pipes.jsp"
                        class="nav-link <%= " io-pipes".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="io-pipes">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="2" y1="12" x2="22" y2="12" />
                            <polyline points="12 2 22 12 12 22" />
                        </svg>
                        <span>Pipes</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/io-heredoc.jsp"
                        class="nav-link <%= " io-heredoc".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="io-heredoc">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                            <polyline points="14 2 14 8 20 8" />
                            <line x1="16" y1="13" x2="8" y2="13" />
                            <line x1="16" y1="17" x2="8" y2="17" />
                        </svg>
                        <span>Here Documents & Here Strings</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/io-process-substitution.jsp"
                        class="nav-link <%= " io-process-substitution".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="io-process-substitution">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="4 14 10 14 10 20" />
                            <polyline points="20 10 14 10 14 4" />
                            <line x1="14" y1="10" x2="21" y2="3" />
                        </svg>
                        <span>Process Substitution</span>
                    </a>
                </li>
            </ul>
        </div>

        <%-- Module 8: File Operations --%>
        <div class="nav-section">
            <div class="nav-section-title">File Operations</div>
            <ul class="nav-items">
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/files-reading.jsp"
                        class="nav-link <%= " files-reading".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="files-reading">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                            <polyline points="14 2 14 8 20 8" />
                            <line x1="16" y1="13" x2="8" y2="13" />
                            <line x1="16" y1="17" x2="8" y2="17" />
                        </svg>
                        <span>File Reading</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/files-writing.jsp"
                        class="nav-link <%= " files-writing".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="files-writing">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                        </svg>
                        <span>File Writing</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/files-manipulation.jsp"
                        class="nav-link <%= " files-manipulation".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="files-manipulation">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                            <polyline points="14 2 14 8 20 8" />
                        </svg>
                        <span>File Manipulation</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/files-testing.jsp"
                        class="nav-link <%= " files-testing".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="files-testing">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M9 11l3 3L22 4" />
                            <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11" />
                        </svg>
                        <span>File Testing</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/files-directories.jsp"
                        class="nav-link <%= " files-directories".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="files-directories">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z" />
                        </svg>
                        <span>Working with Directories</span>
                    </a>
                </li>
            </ul>
        </div>

        <%-- Module 9: Advanced Topics --%>
        <div class="nav-section">
            <div class="nav-section-title">Advanced Topics</div>
            <ul class="nav-items">
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/advanced-regex.jsp"
                        class="nav-link <%= " advanced-regex".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="advanced-regex">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                            <polyline points="14 2 14 8 20 8" />
                        </svg>
                        <span>Regular Expressions</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/advanced-sed.jsp"
                        class="nav-link <%= " advanced-sed".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="advanced-sed">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                        </svg>
                        <span>sed (Stream Editor)</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/advanced-awk.jsp"
                        class="nav-link <%= " advanced-awk".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="advanced-awk">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                            <polyline points="14 2 14 8 20 8" />
                            <line x1="16" y1="13" x2="8" y2="13" />
                        </svg>
                        <span>awk</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/advanced-signals.jsp"
                        class="nav-link <%= " advanced-signals".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="advanced-signals">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" />
                            <circle cx="12" cy="10" r="3" />
                        </svg>
                        <span>Signal Handling</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/advanced-jobs.jsp"
                        class="nav-link <%= " advanced-jobs".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="advanced-jobs">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="3" width="7" height="7" />
                            <rect x="14" y="3" width="7" height="7" />
                            <rect x="14" y="14" width="7" height="7" />
                            <rect x="3" y="14" width="7" height="7" />
                        </svg>
                        <span>Background Jobs</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/advanced-debugging.jsp"
                        class="nav-link <%= " advanced-debugging".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="advanced-debugging">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10" />
                            <line x1="12" y1="8" x2="12" y2="12" />
                            <line x1="12" y1="16" x2="12.01" y2="16" />
                        </svg>
                        <span>Debugging</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/advanced-brace-expansion.jsp"
                        class="nav-link <%= " advanced-brace-expansion".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="advanced-brace-expansion">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="4 14 10 14 10 20" />
                            <polyline points="20 10 14 10 14 4" />
                        </svg>
                        <span>Brace Expansion</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/advanced-parameter-expansion.jsp"
                        class="nav-link <%= " advanced-parameter-expansion".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="advanced-parameter-expansion">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                            <polyline points="14 2 14 8 20 8" />
                        </svg>
                        <span>Parameter Expansion Advanced</span>
                    </a>
                </li>
            </ul>
        </div>

        <%-- Module 10: Professional Practices --%>
        <div class="nav-section">
            <div class="nav-section-title">Professional Practices</div>
            <ul class="nav-items">
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/practices-best-practices.jsp"
                        class="nav-link <%= " practices-best-practices".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="practices-best-practices">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M9 11l3 3L22 4" />
                            <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11" />
                        </svg>
                        <span>Best Practices</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/practices-error-handling.jsp"
                        class="nav-link <%= " practices-error-handling".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="practices-error-handling">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10" />
                            <line x1="12" y1="8" x2="12" y2="12" />
                            <line x1="12" y1="16" x2="12.01" y2="16" />
                        </svg>
                        <span>Error Handling</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/practices-logging.jsp"
                        class="nav-link <%= " practices-logging".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="practices-logging">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="8" y1="6" x2="21" y2="6" />
                            <line x1="8" y1="12" x2="21" y2="12" />
                            <line x1="8" y1="18" x2="21" y2="18" />
                            <line x1="3" y1="6" x2="3.01" y2="6" />
                            <line x1="3" y1="12" x2="3.01" y2="12" />
                            <line x1="3" y1="18" x2="3.01" y2="18" />
                        </svg>
                        <span>Logging</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/practices-configuration.jsp"
                        class="nav-link <%= " practices-configuration".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="practices-configuration">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="3" />
                            <path d="M12 1v6m0 6v6m9-9h-6m-6 0H3m15.364 6.364l-4.243-4.243m-4.242 0L5.636 17.364M18.364 6.636l-4.243 4.243m-4.242 0L5.636 6.636" />
                        </svg>
                        <span>Configuration Files</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/practices-arguments.jsp"
                        class="nav-link <%= " practices-arguments".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="practices-arguments">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="4 17 10 11 4 5" />
                            <line x1="12" y1="19" x2="20" y2="19" />
                        </svg>
                        <span>Command Line Arguments</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/practices-templates.jsp"
                        class="nav-link <%= " practices-templates".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="practices-templates">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                            <line x1="9" y1="3" x2="9" y2="21" />
                        </svg>
                        <span>Script Templates</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/practices-testing.jsp"
                        class="nav-link <%= " practices-testing".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="practices-testing">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M9 11l3 3L22 4" />
                            <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11" />
                        </svg>
                        <span>Testing Scripts</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/tutorials/bash/practices-examples.jsp"
                        class="nav-link <%= " practices-examples".equals(currentLesson) ? "active" : "" %>"
                        data-lesson="practices-examples">
                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="22 12 18 12 15 21 9 3 6 12 2 12" />
                        </svg>
                        <span>Real-World Examples</span>
                    </a>
                </li>
            </ul>
        </div>
    </nav>
</aside>

