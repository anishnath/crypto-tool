<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- Tutorial Sidebar Component - Lua Navigation for Lua Tutorial lessons Uses currentLesson attribute to highlight
        active item --%>
        <% String currentLesson=(String) request.getAttribute("currentLesson"); if (currentLesson==null)
            currentLesson="" ; %>

            <aside class="tutorial-sidebar" id="sidebar">
                <div class="sidebar-header">
                    <div class="sidebar-logo">
                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/lua-logo.svg" alt="Lua"
                            width="32" height="32">
                    </div>
                    <h2 class="sidebar-title">Lua Tutorial</h2>
                </div>

                <nav class="sidebar-nav">
                    <%-- Module 1: Getting Started --%>
                        <div class="nav-section">
                            <div class="nav-section-title">Getting Started</div>
                            <ul class="nav-items">
                                <li class="nav-item">
                                    <a href="<%=request.getContextPath()%>/tutorials/lua/intro.jsp"
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
                                <li class="nav-item">
                                    <a href="<%=request.getContextPath()%>/tutorials/lua/installation.jsp"
                                        class="nav-link <%= " installation".equals(currentLesson) ? "active" : "" %>"
                                        data-lesson="installation">
                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                            stroke-width="2">
                                            <path
                                                d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
                                            <polyline points="3.27 6.96 12 12.01 20.73 6.96" />
                                            <line x1="12" y1="22.08" x2="12" y2="12" />
                                        </svg>
                                        <span>Installation & Setup</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="<%=request.getContextPath()%>/tutorials/lua/hello-world.jsp"
                                        class="nav-link <%= " hello-world".equals(currentLesson) ? "active" : "" %>"
                                        data-lesson="hello-world">
                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                            stroke-width="2">
                                            <path d="M4 7V4h16v3" />
                                            <path d="M9 20h6" />
                                            <path d="M12 4v16" />
                                        </svg>
                                        <span>Hello World</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="<%=request.getContextPath()%>/tutorials/lua/variables.jsp"
                                        class="nav-link <%= " variables".equals(currentLesson) ? "active" : "" %>"
                                        data-lesson="variables">
                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                            stroke-width="2">
                                            <rect x="3" y="3" width="7" height="7" />
                                            <rect x="14" y="3" width="7" height="7" />
                                            <rect x="14" y="14" width="7" height="7" />
                                            <rect x="3" y="14" width="7" height="7" />
                                        </svg>
                                        <span>Variables & Types</span>
                                    </a>
                                </li>
                            </ul>
                        </div>

                        <%-- Module 2: Operators & Control Flow --%>
                            <div class="nav-section">
                                <div class="nav-section-title">Operators & Control Flow</div>
                                <ul class="nav-items">
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/lua/operators.jsp"
                                            class="nav-link <%= " operators".equals(currentLesson) ? "active" : "" %>"
                                            data-lesson="operators">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <line x1="12" y1="5" x2="12" y2="19" />
                                                <line x1="5" y1="12" x2="19" y2="12" />
                                            </svg>
                                            <span>Operators</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/lua/strings.jsp"
                                            class="nav-link <%= " strings".equals(currentLesson) ? "active" : "" %>"
                                            data-lesson="strings">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <path d="M4 7V4h16v3" />
                                                <path d="M9 20h6" />
                                                <path d="M12 4v16" />
                                            </svg>
                                            <span>Strings</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/lua/conditionals.jsp"
                                            class="nav-link <%= " conditionals".equals(currentLesson) ? "active" : ""
                                            %>"
                                            data-lesson="conditionals">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <polyline points="16 3 21 3 21 8" />
                                                <line x1="4" y1="20" x2="21" y2="3" />
                                                <polyline points="21 16 21 21 16 21" />
                                                <line x1="15" y1="15" x2="21" y2="21" />
                                                <line x1="4" y1="4" x2="9" y2="9" />
                                            </svg>
                                            <span>Conditionals</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/lua/loops.jsp"
                                            class="nav-link <%= " loops".equals(currentLesson) ? "active" : "" %>"
                                            data-lesson="loops">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <path d="M21 12a9 9 0 1 1-9-9c2.52 0 4.93 1 6.74 2.74L21 8" />
                                                <path d="M21 3v5h-5" />
                                            </svg>
                                            <span>Loops</span>
                                        </a>
                                    </li>
                                </ul>
                            </div>

                            <%-- Module 3: Functions --%>
                                <div class="nav-section">
                                    <div class="nav-section-title">Functions</div>
                                    <ul class="nav-items">
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/lua/functions.jsp"
                                                class="nav-link <%= " functions".equals(currentLesson) ? "active" : ""
                                                %>"
                                                data-lesson="functions">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                                                    <path d="M9 9l6 6" />
                                                </svg>
                                                <span>Function Basics</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/lua/closures.jsp"
                                                class="nav-link <%= " closures".equals(currentLesson) ? "active" : ""
                                                %>"
                                                data-lesson="closures">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <polyline points="4 17 10 11 4 5" />
                                                    <line x1="12" y1="19" x2="20" y2="19" />
                                                </svg>
                                                <span>Closures & Scope</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/lua/advanced-functions.jsp"
                                                class="nav-link <%= " advanced-functions".equals(currentLesson)
                                                ? "active" : "" %>"
                                                data-lesson="advanced-functions">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M12 2L2 7l10 5 10-5-10-5z" />
                                                    <path d="M2 17l10 5 10-5" />
                                                    <path d="M2 12l10 5 10-5" />
                                                </svg>
                                                <span>Advanced Functions</span>
                                            </a>
                                        </li>
                                    </ul>
                                </div>

                                <%-- Module 4: Tables --%>
                                    <div class="nav-section">
                                        <div class="nav-section-title">Tables</div>
                                        <ul class="nav-items">
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/lua/tables.jsp"
                                                    class="nav-link <%= " tables".equals(currentLesson) ? "active" : ""
                                                    %>"
                                                    data-lesson="tables">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <rect x="3" y="3" width="7" height="7" />
                                                        <rect x="14" y="3" width="7" height="7" />
                                                        <rect x="14" y="14" width="7" height="7" />
                                                        <rect x="3" y="14" width="7" height="7" />
                                                    </svg>
                                                    <span>Table Basics</span>
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/lua/table-library.jsp"
                                                    class="nav-link <%= " table-library".equals(currentLesson)
                                                    ? "active" : "" %>"
                                                    data-lesson="table-library">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
                                                        <path
                                                            d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
                                                    </svg>
                                                    <span>Table Library</span>
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/lua/metatables.jsp"
                                                    class="nav-link <%= " metatables".equals(currentLesson) ? "active"
                                                    : "" %>"
                                                    data-lesson="metatables">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <path
                                                            d="M16.5 9.4l-9-5.19M21 16V8a2 2 0 00-1-1.73l-7-4a2 2 0 00-2 0l-7 4A2 2 0 003 8v8a2 2 0 001 1.73l7 4a2 2 0 002 0l7-4A2 2 0 0021 16z" />
                                                    </svg>
                                                    <span>Metatables</span>
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/lua/iterators.jsp"
                                                    class="nav-link <%= " iterators".equals(currentLesson) ? "active"
                                                    : "" %>"
                                                    data-lesson="iterators">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <path d="M21 12a9 9 0 1 1-9-9c2.52 0 4.93 1 6.74 2.74L21 8" />
                                                        <path d="M21 3v5h-5" />
                                                    </svg>
                                                    <span>Iterators</span>
                                                </a>
                                            </li>
                                        </ul>
                                    </div>

                                    <%-- Module 5: Object-Oriented Programming --%>
                                        <div class="nav-section">
                                            <div class="nav-section-title">Object-Oriented Programming</div>
                                            <ul class="nav-items">
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/lua/oop-basics.jsp"
                                                        class="nav-link <%= " oop-basics".equals(currentLesson)
                                                        ? "active" : "" %>"
                                                        data-lesson="oop-basics">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <circle cx="12" cy="12" r="10" />
                                                            <path d="M12 16v-4" />
                                                            <path d="M12 8h.01" />
                                                        </svg>
                                                        <span>OOP Basics</span>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/lua/inheritance.jsp"
                                                        class="nav-link <%= " inheritance".equals(currentLesson)
                                                        ? "active" : "" %>"
                                                        data-lesson="inheritance">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <path
                                                                d="M16.5 9.4l-9-5.19M21 16V8a2 2 0 00-1-1.73l-7-4a2 2 0 00-2 0l-7 4A2 2 0 003 8v8a2 2 0 001 1.73l7 4a2 2 0 002 0l7-4A2 2 0 0021 16z" />
                                                        </svg>
                                                        <span>Inheritance</span>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/lua/modules.jsp"
                                                        class="nav-link <%= " modules".equals(currentLesson) ? "active"
                                                        : "" %>"
                                                        data-lesson="modules">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <path
                                                                d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
                                                            <polyline points="3.27 6.96 12 12.01 20.73 6.96" />
                                                            <line x1="12" y1="22.08" x2="12" y2="12" />
                                                        </svg>
                                                        <span>Modules</span>
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>

                                        <%-- Module 6: Modules & Error Handling --%>
                                            <div class="nav-section">
                                                <div class="nav-section-title">Modules & Error Handling</div>
                                                <ul class="nav-items">
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/lua/creating-modules.jsp"
                                                            class="nav-link <%= "creating-modules".equals(currentLesson) ? "active" : "" %>"
                                                            data-lesson="creating-modules">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <path
                                                                    d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
                                                                <polyline points="3.27 6.96 12 12.01 20.73 6.96" />
                                                                <line x1="12" y1="22.08" x2="12" y2="12" />
                                                            </svg>
                                                            <span>Creating Modules</span>
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/lua/error-handling.jsp"
                                                            class="nav-link <%= " error-handling".equals(currentLesson)
                                                            ? "active" : "" %>"
                                                            data-lesson="error-handling">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <path
                                                                    d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z" />
                                                                <line x1="12" y1="9" x2="12" y2="13" />
                                                                <line x1="12" y1="17" x2="12.01" y2="17" />
                                                            </svg>
                                                            <span>Error Handling</span>
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/lua/debugging.jsp"
                                                            class="nav-link <%= " debugging".equals(currentLesson)
                                                            ? "active" : "" %>"
                                                            data-lesson="debugging">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
                                                                <path d="M12 8v4" />
                                                                <path d="M12 16h.01" />
                                                            </svg>
                                                            <span>Debugging</span>
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/lua/best-practices.jsp"
                                                            class="nav-link <%= " best-practices".equals(currentLesson)
                                                            ? "active" : "" %>"
                                                            data-lesson="best-practices">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
                                                                <polyline points="22 4 12 14.01 9 11.01" />
                                                            </svg>
                                                            <span>Best Practices</span>
                                                        </a>
                                                    </li>
                                                </ul>
                                            </div>

                                            <%-- Module 7: Advanced Topics --%>
                                                <div class="nav-section">
                                                    <div class="nav-section-title">Advanced Topics</div>
                                                    <ul class="nav-items">
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/lua/coroutines.jsp"
                                                                class="nav-link <%= " coroutines".equals(currentLesson)
                                                                ? "active" : "" %>"
                                                                data-lesson="coroutines">
                                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <path d="M17 1l4 4-4 4" />
                                                                    <path d="M3 11V9a4 4 0 014-4h14" />
                                                                    <path d="M7 23l-4-4 4-4" />
                                                                    <path d="M21 13v2a4 4 0 01-4 4H3" />
                                                                </svg>
                                                                <span>Coroutines</span>
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/lua/file-io.jsp"
                                                                class="nav-link <%= " file-io".equals(currentLesson)
                                                                ? "active" : "" %>"
                                                                data-lesson="file-io">
                                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <path
                                                                        d="M13 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9z" />
                                                                    <polyline points="13 2 13 9 20 9" />
                                                                </svg>
                                                                <span>File I/O</span>
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/lua/performance.jsp"
                                                                class="nav-link <%= " performance".equals(currentLesson)
                                                                ? "active" : "" %>"
                                                                data-lesson="performance">
                                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <polyline
                                                                        points="22 12 18 12 15 21 9 3 6 12 2 12" />
                                                                </svg>
                                                                <span>Performance</span>
                                                            </a>
                                                        </li>
                                                    </ul>
                                                </div>
                </nav>
            </aside>