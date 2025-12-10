<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- Tutorial Sidebar Component - Rust Navigation for Rust Tutorial lessons Uses currentLesson attribute to
        highlight active item --%>
        <% String currentLesson=(String) request.getAttribute("currentLesson"); if (currentLesson==null)
            currentLesson="" ; %>
            <aside class="tutorial-sidebar" id="sidebar">
                <div class="sidebar-header">
                    <div class="sidebar-logo">
                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/rust-logo.svg" alt="Rust"
                            width="32" height="32">
                    </div>
                    <h2 class="sidebar-title">Rust Tutorial</h2>
                </div>

                <nav class="sidebar-nav">
                    <%-- Module 1: Getting Started --%>
                        <div class="nav-section">
                            <div class="nav-section-title">Getting Started</div>
                            <ul class="nav-items">
                                <li class="nav-item">
                                    <a href="<%=request.getContextPath()%>/tutorials/rust/intro.jsp"
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
                                    <a href="<%=request.getContextPath()%>/tutorials/rust/installation.jsp"
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
                                    <a href="<%=request.getContextPath()%>/tutorials/rust/hello-world.jsp"
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
                                    <a href="<%=request.getContextPath()%>/tutorials/rust/cargo-basics.jsp"
                                        class="nav-link <%= " cargo-basics".equals(currentLesson) ? "active" : "" %>"
                                        data-lesson="cargo-basics">
                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                            stroke-width="2">
                                            <rect x="1" y="3" width="15" height="13" />
                                            <polygon points="16 8 20 8 23 11 23 16 16 16 16 8" />
                                            <circle cx="5.5" cy="18.5" r="2.5" />
                                            <circle cx="18.5" cy="18.5" r="2.5" />
                                        </svg>
                                        <span>Cargo Basics</span>
                                    </a>
                                </li>
                            </ul>
                        </div>

                        <%-- Module 2: Variables & Data Types --%>
                            <div class="nav-section">
                                <div class="nav-section-title">Variables & Data Types</div>
                                <ul class="nav-items">
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/rust/variables.jsp"
                                            class="nav-link <%= " variables".equals(currentLesson) ? "active" : "" %>"
                                            data-lesson="variables">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <path d="M4 7V4h16v3" />
                                                <path d="M9 20h6" />
                                                <path d="M12 4v16" />
                                            </svg>
                                            <span>Variables & Mutability</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/rust/data-types.jsp"
                                            class="nav-link <%= " data-types".equals(currentLesson) ? "active" : "" %>"
                                            data-lesson="data-types">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <path d="M4 4h4v4H4zM14 4h4v4h-4zM4 14h4v4H4z" />
                                                <path d="M14 14h6M14 18h6M17 14v4" />
                                            </svg>
                                            <span>Data Types</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/rust/strings.jsp"
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
                                        <a href="<%=request.getContextPath()%>/tutorials/rust/type-conversion.jsp"
                                            class="nav-link <%= " type-conversion".equals(currentLesson) ? "active" : ""
                                            %>"
                                            data-lesson="type-conversion">
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
                                        <a href="<%=request.getContextPath()%>/tutorials/rust/functions.jsp"
                                            class="nav-link <%= " functions".equals(currentLesson) ? "active" : "" %>"
                                            data-lesson="functions">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                                                <path d="M9 9l6 6" />
                                            </svg>
                                            <span>Functions</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/rust/comments.jsp"
                                            class="nav-link <%= " comments".equals(currentLesson) ? "active" : "" %>"
                                            data-lesson="comments">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <path
                                                    d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z" />
                                            </svg>
                                            <span>Comments</span>
                                        </a>
                                    </li>
                                </ul>
                            </div>

                            <%-- Module 3: Control Flow --%>
                                <div class="nav-section">
                                    <div class="nav-section-title">Control Flow</div>
                                    <ul class="nav-items">
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/rust/control-if.jsp"
                                                class="nav-link <%= " control-if".equals(currentLesson) ? "active" : ""
                                                %>" data-lesson="control-if">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <polyline points="16 3 21 3 21 8" />
                                                    <line x1="4" y1="20" x2="21" y2="3" />
                                                    <polyline points="21 16 21 21 16 21" />
                                                    <line x1="15" y1="15" x2="21" y2="21" />
                                                    <line x1="4" y1="4" x2="9" y2="9" />
                                                </svg>
                                                <span>if Expressions</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/rust/control-loops.jsp"
                                                class="nav-link <%= " control-loops".equals(currentLesson) ? "active"
                                                : "" %>"
                                                data-lesson="control-loops">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M21 12a9 9 0 1 1-9-9c2.52 0 4.93 1 6.74 2.74L21 8" />
                                                    <path d="M21 3v5h-5" />
                                                </svg>
                                                <span>Loops</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/rust/control-match.jsp"
                                                class="nav-link <%= " control-match".equals(currentLesson) ? "active"
                                                : "" %>" data-lesson="control-match">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <rect x="3" y="3" width="7" height="7" />
                                                    <rect x="14" y="3" width="7" height="7" />
                                                    <rect x="14" y="14" width="7" height="7" />
                                                    <rect x="3" y="14" width="7" height="7" />
                                                </svg>
                                                <span>Pattern Matching</span>
                                            </a>
                                        </li>
                                    </ul>
                                </div>

                                <%-- Module 4: Ownership --%>
                                    <div class="nav-section">
                                        <div class="nav-section-title">Ownership</div>
                                        <ul class="nav-items">
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/rust/ownership.jsp"
                                                    class="nav-link <%= " ownership".equals(currentLesson) ? "active"
                                                    : "" %>" data-lesson="ownership">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
                                                    </svg>
                                                    <span>Ownership Rules</span>
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/rust/borrowing.jsp"
                                                    class="nav-link <%= " borrowing".equals(currentLesson) ? "active"
                                                    : "" %>" data-lesson="borrowing">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <path
                                                            d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71" />
                                                        <path
                                                            d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71" />
                                                    </svg>
                                                    <span>References & Borrowing</span>
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/rust/slices.jsp"
                                                    class="nav-link <%= " slices".equals(currentLesson) ? "active" : ""
                                                    %>" data-lesson="slices">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <line x1="8" y1="6" x2="21" y2="6" />
                                                        <line x1="8" y1="12" x2="21" y2="12" />
                                                        <line x1="8" y1="18" x2="21" y2="18" />
                                                        <line x1="3" y1="6" x2="3.01" y2="6" />
                                                        <line x1="3" y1="12" x2="3.01" y2="12" />
                                                        <line x1="3" y1="18" x2="3.01" y2="18" />
                                                    </svg>
                                                    <span>Slices</span>
                                                </a>
                                            </li>
                                        </ul>
                                    </div>

                                    <%-- Module 5: Structs & Enums --%>
                                        <div class="nav-section">
                                            <div class="nav-section-title">Structs & Enums</div>
                                            <ul class="nav-items">
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/rust/structs.jsp"
                                                        class="nav-link <%= " structs".equals(currentLesson) ? "active"
                                                        : "" %>" data-lesson="structs">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <path
                                                                d="M16.5 9.4l-9-5.19M21 16V8a2 2 0 00-1-1.73l-7-4a2 2 0 00-2 0l-7 4A2 2 0 003 8v8a2 2 0 001 1.73l7 4a2 2 0 002 0l7-4A2 2 0 0021 16z" />
                                                        </svg>
                                                        <span>Structs</span>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/rust/methods.jsp"
                                                        class="nav-link <%= " methods".equals(currentLesson) ? "active"
                                                        : "" %>" data-lesson="methods">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <path
                                                                d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                                            <path
                                                                d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                                                        </svg>
                                                        <span>Methods</span>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/rust/enums.jsp"
                                                        class="nav-link <%= " enums".equals(currentLesson) ? "active"
                                                        : "" %>" data-lesson="enums">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <rect x="3" y="3" width="7" height="7" />
                                                            <rect x="14" y="3" width="7" height="7" />
                                                            <rect x="14" y="14" width="7" height="7" />
                                                            <rect x="3" y="14" width="7" height="7" />
                                                        </svg>
                                                        <span>Enums & Pattern Matching</span>
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>

                                        <%-- Module 6: Collections --%>
                                            <div class="nav-section">
                                                <div class="nav-section-title">Collections</div>
                                                <ul class="nav-items">
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/rust/vectors.jsp"
                                                            class="nav-link <%= " vectors".equals(currentLesson)
                                                            ? "active" : "" %>" data-lesson="vectors">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <line x1="8" y1="6" x2="21" y2="6" />
                                                                <line x1="8" y1="12" x2="21" y2="12" />
                                                                <line x1="8" y1="18" x2="21" y2="18" />
                                                                <line x1="3" y1="6" x2="3.01" y2="6" />
                                                                <line x1="3" y1="12" x2="3.01" y2="12" />
                                                                <line x1="3" y1="18" x2="3.01" y2="18" />
                                                            </svg>
                                                            <span>Vectors</span>
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/rust/hashmaps.jsp"
                                                            class="nav-link <%= " hashmaps".equals(currentLesson)
                                                            ? "active" : "" %>" data-lesson="hashmaps">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
                                                                <path
                                                                    d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
                                                            </svg>
                                                            <span>HashMaps</span>
                                                        </a>
                                                    </li>
                                                </ul>
                                            </div>

                                            <%-- Module 6: Error Handling --%>
                                                <div class="nav-section">
                                                    <div class="nav-section-title">Error Handling</div>
                                                    <ul class="nav-items">
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/rust/panic.jsp"
                                                                class="nav-link <%= " panic".equals(currentLesson)
                                                                ? "active" : "" %>" data-lesson="panic">
                                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <circle cx="12" cy="12" r="10"></circle>
                                                                    <line x1="15" y1="9" x2="9" y2="15"></line>
                                                                    <line x1="9" y1="9" x2="15" y2="15"></line>
                                                                </svg>
                                                                <span>Panic!</span>
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/rust/result.jsp"
                                                                class="nav-link <%= " result".equals(currentLesson)
                                                                ? "active" : "" %>" data-lesson="result">
                                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <path
                                                                        d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z">
                                                                    </path>
                                                                    <line x1="12" y1="9" x2="12" y2="13"></line>
                                                                    <line x1="12" y1="17" x2="12.01" y2="17">
                                                                    </line>
                                                                </svg>
                                                                <span>Result Type</span>
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/rust/error-propagation.jsp"
                                                                class="nav-link <%= "error-propagation".equals(currentLesson) ? "active" : ""
                                                                %>"
                                                                data-lesson="error-propagation">
                                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <polyline points="9 10 4 15 9 20"></polyline>
                                                                    <path d="M20 4v7a4 4 0 0 1-4 4H4"></path>
                                                                </svg>
                                                                <span>Error Propagation</span>
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/rust/custom-errors.jsp"
                                                                class="nav-link <%= "custom-errors".equals(currentLesson) ? "active" : "" %>"
                                                                data-lesson="custom-errors">
                                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <path
                                                                        d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                                                    <path
                                                                        d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                                                                </svg>
                                                                <span>Custom Errors</span>
                                                            </a>
                                                        </li>
                                                    </ul>
                                                </div>

                                                <%-- Module 7: Advanced Topics --%>
                                                    <div class="nav-section">
                                                        <div class="nav-section-title">Advanced Topics
                                                        </div>
                                                        <ul class="nav-items">
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/rust/traits.jsp"
                                                                    class="nav-link <%= " traits".equals(currentLesson)
                                                                    ? "active" : "" %>" data-lesson="traits">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <rect x="3" y="3" width="7" height="7" />
                                                                        <rect x="14" y="3" width="7" height="7" />
                                                                        <rect x="14" y="14" width="7" height="7" />
                                                                        <rect x="3" y="14" width="7" height="7" />
                                                                    </svg>
                                                                    <span>Traits</span>
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/rust/generics.jsp"
                                                                    class="nav-link <%= "generics".equals(currentLesson) ? "active" : "" %>"
                                                                    data-lesson="generics">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <path d="M12 2L2 7l10 5 10-5-10-5z" />
                                                                        <path d="M2 17l10 5 10-5" />
                                                                        <path d="M2 12l10 5 10-5" />
                                                                    </svg>
                                                                    <span>Generics</span>
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/rust/modules.jsp"
                                                                    class="nav-link <%= " modules".equals(currentLesson)
                                                                    ? "active" : "" %>" data-lesson="modules">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <rect x="3" y="3" width="7" height="7" />
                                                                        <rect x="14" y="3" width="7" height="7" />
                                                                        <rect x="14" y="14" width="7" height="7" />
                                                                        <rect x="3" y="14" width="7" height="7" />
                                                                    </svg>
                                                                    <span>Modules</span>
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/rust/packages-crates.jsp"
                                                                    class="nav-link <%= "packages-crates".equals(currentLesson) ? "active"
                                                                    : "" %>" data-lesson="packages-crates">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <path
                                                                            d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
                                                                        <polyline
                                                                            points="3.27 6.96 12 12.01 20.73 6.96" />
                                                                        <line x1="12" y1="22.08" x2="12" y2="12" />
                                                                    </svg>
                                                                    <span>Packages & Crates</span>
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/rust/iterators.jsp"
                                                                    class="nav-link <%= "iterators".equals(currentLesson) ? "active" : "" %>"
                                                                    data-lesson="iterators">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <path
                                                                            d="M21 12a9 9 0 1 1-9-9c2.52 0 4.93 1 6.74 2.74L21 8" />
                                                                        <path d="M21 3v5h-5" />
                                                                    </svg>
                                                                    <span>Iterators</span>
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/rust/closures.jsp"
                                                                    class="nav-link <%= "closures".equals(currentLesson) ? "active" : "" %>"
                                                                    data-lesson="closures">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <polyline points="4 17 10 11 4 5" />
                                                                        <line x1="12" y1="19" x2="20" y2="19" />
                                                                    </svg>
                                                                    <span>Closures</span>
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/rust/smart-pointers.jsp"
                                                                    class="nav-link <%= "smart-pointers".equals(currentLesson) ? "active"
                                                                    : "" %>" data-lesson="smart-pointers">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <circle cx="12" cy="12" r="10" />
                                                                        <path d="M12 16v-4" />
                                                                        <path d="M12 8h.01" />
                                                                    </svg>
                                                                    <span>Smart Pointers</span>
                                                                </a>
                                                            </li>
                                                        </ul>
                                                    </div>
                </nav>
            </aside>