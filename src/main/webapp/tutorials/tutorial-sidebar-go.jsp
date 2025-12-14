<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- Tutorial Sidebar Component - Go Navigation --%>
        <% String currentLesson=(String) request.getAttribute("currentLesson"); if (currentLesson==null)
            currentLesson="" ; %>
            <aside class="tutorial-sidebar" id="sidebar">
                <div class="sidebar-header">
                    <div class="sidebar-logo">
                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/go-logo.svg" alt="Go" width="32"
                            height="32">
                    </div>
                    <h2 class="sidebar-title">Go Tutorial</h2>
                </div>

                <nav class="sidebar-nav">
                    <%-- Module 1: Getting Started --%>
                        <div class="nav-section">
                            <div class="nav-section-title">Getting Started</div>
                            <ul class="nav-items">
                                <li class="nav-item">
                                    <a href="<%=request.getContextPath()%>/tutorials/go/intro.jsp" class="nav-link <%= "intro".equals(currentLesson) ? "active" : "" %>"
                                        data-lesson="intro">
                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                            stroke-width="2">
                                            <circle cx="12" cy="12" r="10" />
                                            <polygon points="10 8 16 12 10 16 10 8" />
                                        </svg>
                                        <span>Introduction to Go</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="<%=request.getContextPath()%>/tutorials/go/hello-world.jsp"
                                        class="nav-link <%= " hello-world".equals(currentLesson) ? "active" : "" %>"
                                        data-lesson="hello-world">
                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                            stroke-width="2">
                                            <path d="M4 7V4h16v3" />
                                            <path d="M9 20h6" />
                                            <path d="M12 4v16" />
                                        </svg>
                                        <span>Setup & Hello World</span>
                                    </a>
                                </li>
                            </ul>
                        </div>

                        <%-- Module 2: Basics --%>
                            <div class="nav-section">
                                <div class="nav-section-title">Basics</div>
                                <ul class="nav-items">
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/go/variables-types.jsp"
                                            class="nav-link <%= " variables-types".equals(currentLesson) ? "active" : ""
                                            %>"
                                            data-lesson="variables-types">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <path d="M4 7V4h16v3" />
                                                <path d="M9 20h6" />
                                                <path d="M12 4v16" />
                                            </svg>
                                            <span>Variables & Types</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/go/constants-operators.jsp"
                                            class="nav-link <%= " constants-operators".equals(currentLesson) ? "active"
                                            : "" %>"
                                            data-lesson="constants-operators">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <path d="M4 4h4v4H4zM14 4h4v4h-4zM4 14h4v4H4z" />
                                                <path d="M14 14h6M14 18h6M17 14v4" />
                                            </svg>
                                            <span>Constants & Operators</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/go/strings.jsp"
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
                                </ul>
                            </div>

                            <%-- Module 3: Control Flow --%>
                                <div class="nav-section">
                                    <div class="nav-section-title">Control Flow</div>
                                    <ul class="nav-items">
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/go/if-switch.jsp"
                                                class="nav-link <%= " if-switch".equals(currentLesson) ? "active" : ""
                                                %>"
                                                data-lesson="if-switch">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <polyline points="16 3 21 3 21 8" />
                                                    <line x1="4" y1="20" x2="21" y2="3" />
                                                    <polyline points="21 16 21 21 16 21" />
                                                    <line x1="15" y1="15" x2="21" y2="21" />
                                                    <line x1="4" y1="4" x2="9" y2="9" />
                                                </svg>
                                                <span>If & Switch</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/go/loops-range.jsp"
                                                class="nav-link <%= " loops-range".equals(currentLesson) ? "active" : ""
                                                %>"
                                                data-lesson="loops-range">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M21 12a9 9 0 1 1-9-9c2.52 0 4.93 1 6.74 2.74L21 8" />
                                                    <path d="M21 3v5h-5" />
                                                </svg>
                                                <span>Loops & Range</span>
                                            </a>
                                        </li>
                                    </ul>
                                </div>

                                <%-- Module 4: Functions --%>
                                    <div class="nav-section">
                                        <div class="nav-section-title">Functions</div>
                                        <ul class="nav-items">
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/go/functions-returns.jsp"
                                                    class="nav-link <%= " functions-returns".equals(currentLesson)
                                                    ? "active" : "" %>"
                                                    data-lesson="functions-returns">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                                                        <path d="M9 9l6 6" />
                                                    </svg>
                                                    <span>Functions & Returns</span>
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/go/closures-defer.jsp"
                                                    class="nav-link <%= " closures-defer".equals(currentLesson)
                                                    ? "active" : "" %>"
                                                    data-lesson="closures-defer">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <polyline points="4 17 10 11 4 5" />
                                                        <line x1="12" y1="19" x2="20" y2="19" />
                                                    </svg>
                                                    <span>Closures & Defer</span>
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/go/panic-recover.jsp"
                                                    class="nav-link <%= " panic-recover".equals(currentLesson)
                                                    ? "active" : "" %>"
                                                    data-lesson="panic-recover">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <circle cx="12" cy="12" r="10"></circle>
                                                        <line x1="15" y1="9" x2="9" y2="15"></line>
                                                        <line x1="9" y1="9" x2="15" y2="15"></line>
                                                    </svg>
                                                    <span>Panic & Recover</span>
                                                </a>
                                            </li>
                                        </ul>
                                    </div>

                                    <%-- Module 5: Data Structures --%>
                                        <div class="nav-section">
                                            <div class="nav-section-title">Data Structures</div>
                                            <ul class="nav-items">
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/go/arrays-slices.jsp"
                                                        class="nav-link <%= " arrays-slices".equals(currentLesson)
                                                        ? "active" : "" %>"
                                                        data-lesson="arrays-slices">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <line x1="8" y1="6" x2="21" y2="6" />
                                                            <line x1="8" y1="12" x2="21" y2="12" />
                                                            <line x1="8" y1="18" x2="21" y2="18" />
                                                            <line x1="3" y1="6" x2="3.01" y2="6" />
                                                            <line x1="3" y1="12" x2="3.01" y2="12" />
                                                            <line x1="3" y1="18" x2="3.01" y2="18" />
                                                        </svg>
                                                        <span>Arrays & Slices</span>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/go/maps.jsp"
                                                        class="nav-link <%= " maps".equals(currentLesson) ? "active"
                                                        : "" %>"
                                                        data-lesson="maps">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
                                                            <path
                                                                d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
                                                        </svg>
                                                        <span>Maps</span>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/go/structs-methods.jsp"
                                                        class="nav-link <%= " structs-methods".equals(currentLesson)
                                                        ? "active" : "" %>"
                                                        data-lesson="structs-methods">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <path
                                                                d="M16.5 9.4l-9-5.19M21 16V8a2 2 0 00-1-1.73l-7-4a2 2 0 00-2 0l-7 4A2 2 0 003 8v8a2 2 0 001 1.73l7 4a2 2 0 002 0l7-4A2 2 0 0021 16z" />
                                                        </svg>
                                                        <span>Structs & Methods</span>
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>

                                        <%-- Module 6: Pointers & Interfaces --%>
                                            <div class="nav-section">
                                                <div class="nav-section-title">Pointers & Interfaces</div>
                                                <ul class="nav-items">
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/go/pointers.jsp"
                                                            class="nav-link <%= " pointers".equals(currentLesson)
                                                            ? "active" : "" %>"
                                                            data-lesson="pointers">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <circle cx="12" cy="12" r="10" />
                                                                <path d="M12 16v-4" />
                                                                <path d="M12 8h.01" />
                                                            </svg>
                                                            <span>Pointers</span>
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/go/interfaces-basics.jsp"
                                                            class="nav-link <%= "interfaces-basics".equals(currentLesson) ? "active" : "" %>"
                                                            data-lesson="interfaces-basics">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <rect x="3" y="3" width="7" height="7" />
                                                                <rect x="14" y="3" width="7" height="7" />
                                                                <rect x="14" y="14" width="7" height="7" />
                                                                <rect x="3" y="14" width="7" height="7" />
                                                            </svg>
                                                            <span>Interfaces Basics</span>
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/go/type-switches.jsp"
                                                            class="nav-link <%= " type-switches".equals(currentLesson)
                                                            ? "active" : "" %>"
                                                            data-lesson="type-switches">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <path d="M12 2L2 7l10 5 10-5-10-5z" />
                                                                <path d="M2 17l10 5 10-5" />
                                                                <path d="M2 12l10 5 10-5" />
                                                            </svg>
                                                            <span>Type Switches</span>
                                                        </a>
                                                    </li>
                                                </ul>
                                            </div>

                                            <%-- Module 7: Error Handling --%>
                                                <div class="nav-section">
                                                    <div class="nav-section-title">Error Handling</div>
                                                    <ul class="nav-items">
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/go/errors-basics.jsp"
                                                                class="nav-link <%= "errors-basics".equals(currentLesson) ? "active" : "" %>"
                                                                data-lesson="errors-basics">
                                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <path
                                                                        d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z">
                                                                    </path>
                                                                    <line x1="12" y1="9" x2="12" y2="13"></line>
                                                                    <line x1="12" y1="17" x2="12.01" y2="17"></line>
                                                                </svg>
                                                                <span>Errors Basics</span>
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/go/errors-wrapping.jsp"
                                                                class="nav-link <%= "errors-wrapping".equals(currentLesson) ? "active" : ""
                                                                %>"
                                                                data-lesson="errors-wrapping">
                                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <polyline points="9 10 4 15 9 20"></polyline>
                                                                    <path d="M20 4v7a4 4 0 0 1-4 4H4"></path>
                                                                </svg>
                                                                <span>Errors Wrapping</span>
                                                            </a>
                                                        </li>
                                                    </ul>
                                                </div>

                                                <%-- Module 8: Concurrency --%>
                                                    <div class="nav-section">
                                                        <div class="nav-section-title">Concurrency</div>
                                                        <ul class="nav-items">
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/go/goroutines.jsp"
                                                                    class="nav-link <%= "goroutines".equals(currentLesson) ? "active" : ""
                                                                    %>"
                                                                    data-lesson="goroutines">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <path
                                                                            d="M21 12a9 9 0 1 1-9-9c2.52 0 4.93 1 6.74 2.74L21 8" />
                                                                        <path d="M21 3v5h-5" />
                                                                    </svg>
                                                                    <span>Goroutines</span>
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/go/channels.jsp"
                                                                    class="nav-link <%= "channels".equals(currentLesson) ? "active" : "" %>"
                                                                    data-lesson="channels">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <path
                                                                            d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71" />
                                                                        <path
                                                                            d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71" />
                                                                    </svg>
                                                                    <span>Channels</span>
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/go/select-patterns.jsp"
                                                                    class="nav-link <%= "select-patterns".equals(currentLesson) ? "active"
                                                                    : "" %>"
                                                                    data-lesson="select-patterns">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <rect x="3" y="3" width="7" height="7" />
                                                                        <rect x="14" y="3" width="7" height="7" />
                                                                        <rect x="14" y="14" width="7" height="7" />
                                                                        <rect x="3" y="14" width="7" height="7" />
                                                                    </svg>
                                                                    <span>Select & Patterns</span>
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/go/sync-context.jsp"
                                                                    class="nav-link <%= "sync-context".equals(currentLesson) ? "active" : ""
                                                                    %>"
                                                                    data-lesson="sync-context">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <circle cx="12" cy="12" r="3" />
                                                                        <path
                                                                            d="M12 1v6m0 6v6m5.2-13.2l-4.2 4.2m0 6l4.2 4.2M1 12h6m6 0h6m-13.2-5.2l4.2 4.2m0 6l-4.2 4.2" />
                                                                    </svg>
                                                                    <span>Sync & Context</span>
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/go/goroutines-waitgroups.jsp"
                                                                    class="nav-link <%= "goroutines-waitgroups".equals(currentLesson)
                                                                    ? "active" : "" %>"
                                                                    data-lesson="goroutines-waitgroups">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <path
                                                                            d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                                                        <circle cx="9" cy="7" r="4" />
                                                                        <path d="M23 21v-2a4 4 0 0 0-3-3.87" />
                                                                        <path d="M16 3.13a4 4 0 0 1 0 7.75" />
                                                                    </svg>
                                                                    <span>Goroutine Coordination</span>
                                                                </a>
                                                            </li>
                                                        </ul>
                                                    </div>

                                                    <%-- Module 9: Packages & Standard Library --%>
                                                        <div class="nav-section">
                                                            <div class="nav-section-title">Packages & Standard Library
                                                            </div>
                                                            <ul class="nav-items">
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/go/packages-modules.jsp"
                                                                        class="nav-link <%= "packages-modules".equals(currentLesson)
                                                                        ? "active" : "" %>"
                                                                        data-lesson="packages-modules">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <path
                                                                                d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
                                                                            <polyline
                                                                                points="3.27 6.96 12 12.01 20.73 6.96" />
                                                                            <line x1="12" y1="22.08" x2="12" y2="12" />
                                                                        </svg>
                                                                        <span>Packages & Modules</span>
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/go/file-io.jsp"
                                                                        class="nav-link <%= "file-io".equals(currentLesson) ? "active" : ""
                                                                        %>"
                                                                        data-lesson="file-io">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <path
                                                                                d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                                                            <path
                                                                                d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                                                                        </svg>
                                                                        <span>File I/O</span>
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/go/json-http.jsp"
                                                                        class="nav-link <%= "json-http".equals(currentLesson) ? "active" : ""
                                                                        %>"
                                                                        data-lesson="json-http">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <circle cx="12" cy="12" r="10" />
                                                                            <line x1="2" y1="12" x2="22" y2="12" />
                                                                            <path
                                                                                d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z" />
                                                                        </svg>
                                                                        <span>JSON & HTTP</span>
                                                                    </a>
                                                                </li>
                                                            </ul>
                                                        </div>

                                                        <%-- Module 10: Advanced & Professional --%>
                                                            <div class="nav-section">
                                                                <div class="nav-section-title">Advanced & Professional
                                                                </div>
                                                                <ul class="nav-items">
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/go/testing.jsp"
                                                                            class="nav-link <%= "testing".equals(currentLesson) ? "active"
                                                                            : "" %>"
                                                                            data-lesson="testing">
                                                                            <svg class="nav-icon" viewBox="0 0 24 24"
                                                                                fill="none" stroke="currentColor"
                                                                                stroke-width="2">
                                                                                <polyline
                                                                                    points="22 12 18 12 15 21 9 3 6 12 2 12" />
                                                                            </svg>
                                                                            <span>Testing</span>
                                                                        </a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/go/benchmarking.jsp"
                                                                            class="nav-link <%= "benchmarking".equals(currentLesson)
                                                                            ? "active" : "" %>"
                                                                            data-lesson="benchmarking">
                                                                            <svg class="nav-icon" viewBox="0 0 24 24"
                                                                                fill="none" stroke="currentColor"
                                                                                stroke-width="2">
                                                                                <path d="M3 3v18h18" />
                                                                                <path d="M18 17V9" />
                                                                                <path d="M13 17V5" />
                                                                                <path d="M8 17v-3" />
                                                                            </svg>
                                                                            <span>Benchmarking</span>
                                                                        </a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/go/best-practices.jsp"
                                                                            class="nav-link <%= "best-practices".equals(currentLesson)
                                                                            ? "active" : "" %>"
                                                                            data-lesson="best-practices">
                                                                            <svg class="nav-icon" viewBox="0 0 24 24"
                                                                                fill="none" stroke="currentColor"
                                                                                stroke-width="2">
                                                                                <path
                                                                                    d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
                                                                                <polyline
                                                                                    points="22 4 12 14.01 9 11.01" />
                                                                            </svg>
                                                                            <span>Best Practices</span>
                                                                        </a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/go/generics-reflection.jsp"
                                                                            class="nav-link <%= "generics-reflection".equals(currentLesson)
                                                                            ? "active" : "" %>"
                                                                            data-lesson="generics-reflection">
                                                                            <svg class="nav-icon" viewBox="0 0 24 24"
                                                                                fill="none" stroke="currentColor"
                                                                                stroke-width="2">
                                                                                <path d="M12 2L2 7l10 5 10-5-10-5z" />
                                                                                <path d="M2 17l10 5 10-5" />
                                                                                <path d="M2 12l10 5 10-5" />
                                                                            </svg>
                                                                            <span>Generics & Reflection</span>
                                                                        </a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/go/memory-management.jsp"
                                                                            class="nav-link <%= "memory-management".equals(currentLesson)
                                                                            ? "active" : "" %>"
                                                                            data-lesson="memory-management">
                                                                            <svg class="nav-icon" viewBox="0 0 24 24"
                                                                                fill="none" stroke="currentColor"
                                                                                stroke-width="2">
                                                                                <path
                                                                                    d="M4 7v10c0 2 1 3 3 3h10c2 0 3-1 3-3V7c0-2-1-3-3-3H7c-2 0-3 1-3 3z" />
                                                                                <path d="M9 7v13M15 7v13" />
                                                                            </svg>
                                                                            <span>Memory Management</span>
                                                                        </a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/go/escape-analysis.jsp"
                                                                            class="nav-link <%= "escape-analysis".equals(currentLesson)
                                                                            ? "active" : "" %>"
                                                                            data-lesson="escape-analysis">
                                                                            <svg class="nav-icon" viewBox="0 0 24 24"
                                                                                fill="none" stroke="currentColor"
                                                                                stroke-width="2">
                                                                                <path
                                                                                    d="M13 2L3 14h9l-1 8 10-12h-9l1-8z" />
                                                                            </svg>
                                                                            <span>Escape Analysis</span>
                                                                        </a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/go/cgo-basics.jsp"
                                                                            class="nav-link <%= "cgo-basics".equals(currentLesson) ? "active"
                                                                            : "" %>"
                                                                            data-lesson="cgo-basics">
                                                                            <svg class="nav-icon" viewBox="0 0 24 24"
                                                                                fill="none" stroke="currentColor"
                                                                                stroke-width="2">
                                                                                <path d="M4 7h16M4 12h16M4 17h16" />
                                                                                <circle cx="4" cy="7" r="1" />
                                                                                <circle cx="4" cy="12" r="1" />
                                                                                <circle cx="4" cy="17" r="1" />
                                                                            </svg>
                                                                            <span>CGO Basics</span>
                                                                        </a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/go/unsafe-package.jsp"
                                                                            class="nav-link <%= "unsafe-package".equals(currentLesson)
                                                                            ? "active" : "" %>"
                                                                            data-lesson="unsafe-package">
                                                                            <svg class="nav-icon" viewBox="0 0 24 24"
                                                                                fill="none" stroke="currentColor"
                                                                                stroke-width="2">
                                                                                <path
                                                                                    d="M12 2L2 12l10 10 10-10L12 2z" />
                                                                                <path d="M12 8v8M8 12h8" />
                                                                            </svg>
                                                                            <span>Unsafe Package</span>
                                                                        </a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/go/compiler-flags.jsp"
                                                                            class="nav-link <%= "compiler-flags".equals(currentLesson)
                                                                            ? "active" : "" %>"
                                                                            data-lesson="compiler-flags">
                                                                            <svg class="nav-icon" viewBox="0 0 24 24"
                                                                                fill="none" stroke="currentColor"
                                                                                stroke-width="2">
                                                                                <path
                                                                                    d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z" />
                                                                                <path
                                                                                    d="M14 2v6h6M16 13H8M16 17H8M10 9H8" />
                                                                            </svg>
                                                                            <span>Compiler & Linker Flags</span>
                                                                        </a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/go/plugins-loading.jsp"
                                                                            class="nav-link <%= "plugins-loading".equals(currentLesson)
                                                                            ? "active" : "" %>"
                                                                            data-lesson="plugins-loading">
                                                                            <svg class="nav-icon" viewBox="0 0 24 24"
                                                                                fill="none" stroke="currentColor"
                                                                                stroke-width="2">
                                                                                <path
                                                                                    d="M12 2v4M12 18v4M4.93 4.93l2.83 2.83M16.24 16.24l2.83 2.83M2 12h4M18 12h4M4.93 19.07l2.83-2.83M16.24 7.76l2.83-2.83" />
                                                                                <circle cx="12" cy="12" r="3" />
                                                                            </svg>
                                                                            <span>Plugins & Dynamic Loading</span>
                                                                        </a>
                                                                    </li>
                                                                </ul>
                                                            </div>
                </nav>
            </aside>