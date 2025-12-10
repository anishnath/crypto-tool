<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- Tutorial Sidebar Component - TypeScript Navigation (8 Modules) --%>
        <% String currentLesson=(String) request.getAttribute("currentLesson"); if (currentLesson==null)
            currentLesson="" ; %>
            <aside class="tutorial-sidebar" id="sidebar">
                <div class="sidebar-header">
                    <div class="sidebar-logo">
                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/typescript-logo.svg"
                            alt="TypeScript" width="32" height="32">
                    </div>
                    <h2 class="sidebar-title">TypeScript Tutorial</h2>
                </div>

                <nav class="sidebar-nav">
                    <%-- Module 1: Getting Started & Basic Types --%>
                        <div class="nav-section">
                            <div class="nav-section-title">Getting Started & Basic Types</div>
                            <ul class="nav-items">
                                <li class="nav-item">
                                    <a href="<%=request.getContextPath()%>/tutorials/typescript/intro.jsp"
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
                                    <a href="<%=request.getContextPath()%>/tutorials/typescript/first-program.jsp"
                                        class="nav-link <%= " first-program".equals(currentLesson) ? "active" : "" %>"
                                        data-lesson="first-program">
                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                            stroke-width="2">
                                            <path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z" />
                                            <polyline points="14 2 14 8 20 8" />
                                        </svg>
                                        <span>First Program</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="<%=request.getContextPath()%>/tutorials/typescript/types-primitives.jsp"
                                        class="nav-link <%= " types-primitives".equals(currentLesson) ? "active" : ""
                                        %>" data-lesson="types-primitives">
                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                            stroke-width="2">
                                            <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
                                            <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
                                        </svg>
                                        <span>Primitive Types</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="<%=request.getContextPath()%>/tutorials/typescript/types-arrays.jsp"
                                        class="nav-link <%= " types-arrays".equals(currentLesson) ? "active" : "" %>"
                                        data-lesson="types-arrays">
                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                            stroke-width="2">
                                            <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                                            <line x1="12" y1="3" x2="12" y2="21" />
                                            <line x1="3" y1="12" x2="21" y2="12" />
                                        </svg>
                                        <span>Arrays & Tuples</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="<%=request.getContextPath()%>/tutorials/typescript/types-enums.jsp"
                                        class="nav-link <%= " types-enums".equals(currentLesson) ? "active" : "" %>"
                                        data-lesson="types-enums">
                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                            stroke-width="2">
                                            <rect x="2" y="7" width="20" height="14" rx="2" ry="2" />
                                            <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16" />
                                        </svg>
                                        <span>Enums</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="<%=request.getContextPath()%>/tutorials/typescript/types-special.jsp"
                                        class="nav-link <%= " types-special".equals(currentLesson) ? "active" : "" %>"
                                        data-lesson="types-special">
                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                            stroke-width="2">
                                            <circle cx="12" cy="12" r="10" />
                                            <line x1="12" y1="8" x2="12" y2="12" />
                                            <line x1="12" y1="16" x2="12.01" y2="16" />
                                        </svg>
                                        <span>Special Types</span>
                                    </a>
                                </li>
                            </ul>
                        </div>

                        <%-- Module 2: Functions & Interfaces --%>
                            <div class="nav-section">
                                <div class="nav-section-title">Functions & Interfaces</div>
                                <ul class="nav-items">
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/typescript/functions-basics.jsp"
                                            class="nav-link <%= " functions-basics".equals(currentLesson) ? "active"
                                            : "" %>" data-lesson="functions-basics">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <path d="M12 20h9" />
                                                <path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z" />
                                            </svg>
                                            <span>Function Types</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/typescript/functions-params.jsp"
                                            class="nav-link <%= " functions-params".equals(currentLesson) ? "active"
                                            : "" %>" data-lesson="functions-params">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71" />
                                                <path
                                                    d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71" />
                                            </svg>
                                            <span>Parameters</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/typescript/functions-overloading.jsp"
                                            class="nav-link <%= " functions-overloading".equals(currentLesson)
                                            ? "active" : "" %>" data-lesson="functions-overloading">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <polyline points="17 1 21 5 17 9" />
                                                <path d="M3 11V9a4 4 0 0 1 4-4h14" />
                                                <polyline points="7 23 3 19 7 15" />
                                                <path d="M21 13v2a4 4 0 0 1-4 4H3" />
                                            </svg>
                                            <span>Function Overloading</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/typescript/interfaces-basics.jsp"
                                            class="nav-link <%= " interfaces-basics".equals(currentLesson) ? "active"
                                            : "" %>" data-lesson="interfaces-basics">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                                                <line x1="9" y1="9" x2="15" y2="9" />
                                                <line x1="9" y1="15" x2="15" y2="15" />
                                            </svg>
                                            <span>Interface Basics</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/typescript/types-aliases.jsp"
                                            class="nav-link <%= " types-aliases".equals(currentLesson) ? "active" : ""
                                            %>" data-lesson="types-aliases">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <polyline points="4 7 4 4 20 4 20 7" />
                                                <line x1="9" y1="20" x2="15" y2="20" />
                                                <line x1="12" y1="4" x2="12" y2="20" />
                                            </svg>
                                            <span>Type Aliases</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/typescript/interfaces-extending.jsp"
                                            class="nav-link <%= " interfaces-extending".equals(currentLesson) ? "active"
                                            : "" %>" data-lesson="interfaces-extending">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <polyline points="22 12 18 12 15 21 9 3 6 12 2 12" />
                                            </svg>
                                            <span>Extending Interfaces</span>
                                        </a>
                                    </li>
                                </ul>
                            </div>

                            <%-- Module 3: Classes & OOP --%>
                                <div class="nav-section">
                                    <div class="nav-section-title">Classes & OOP</div>
                                    <ul class="nav-items">
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/typescript/classes-basics.jsp"
                                                class="nav-link <%= " classes-basics".equals(currentLesson) ? "active"
                                                : "" %>" data-lesson="classes-basics">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <rect x="4" y="4" width="16" height="16" rx="2" ry="2" />
                                                    <rect x="9" y="9" width="6" height="6" />
                                                </svg>
                                                <span>Class Basics</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/typescript/classes-constructor.jsp"
                                                class="nav-link <%= " classes-constructor".equals(currentLesson)
                                                ? "active" : "" %>" data-lesson="classes-constructor">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M12 20h9" />
                                                    <path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z" />
                                                </svg>
                                                <span>Constructors</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/typescript/classes-modifiers.jsp"
                                                class="nav-link <%= " classes-modifiers".equals(currentLesson)
                                                ? "active" : "" %>" data-lesson="classes-modifiers">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
                                                    <path d="M7 11V7a5 5 0 0 1 10 0v4" />
                                                </svg>
                                                <span>Access Modifiers</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/typescript/classes-inheritance.jsp"
                                                class="nav-link <%= " classes-inheritance".equals(currentLesson)
                                                ? "active" : "" %>" data-lesson="classes-inheritance">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <line x1="12" y1="2" x2="12" y2="6" />
                                                    <line x1="12" y1="18" x2="12" y2="22" />
                                                    <line x1="4.93" y1="4.93" x2="7.76" y2="7.76" />
                                                    <line x1="16.24" y1="16.24" x2="19.07" y2="19.07" />
                                                    <line x1="2" y1="12" x2="6" y2="12" />
                                                    <line x1="18" y1="12" x2="22" y2="12" />
                                                </svg>
                                                <span>Inheritance</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/typescript/classes-abstract.jsp"
                                                class="nav-link <%= " classes-abstract".equals(currentLesson) ? "active"
                                                : "" %>" data-lesson="classes-abstract">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path
                                                        d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
                                                </svg>
                                                <span>Abstract Classes</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/typescript/classes-static.jsp"
                                                class="nav-link <%= " classes-static".equals(currentLesson) ? "active"
                                                : "" %>" data-lesson="classes-static">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <polyline points="22 12 18 12 15 21 9 3 6 12 2 12" />
                                                </svg>
                                                <span>Static Members</span>
                                            </a>
                                        </li>
                                    </ul>
                                </div>

                                <%-- Module 4: Advanced Types --%>
                                    <div class="nav-section">
                                        <div class="nav-section-title">Advanced Types</div>
                                        <ul class="nav-items">
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/typescript/advanced-union.jsp"
                                                    class="nav-link <%= " advanced-union".equals(currentLesson)
                                                    ? "active" : "" %>" data-lesson="advanced-union">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <circle cx="12" cy="12" r="3" />
                                                        <path d="M12 1v6m0 6v6m6-12h-6m-6 0h6" />
                                                    </svg>
                                                    <span>Union Types</span>
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/typescript/advanced-intersection.jsp"
                                                    class="nav-link <%= " advanced-intersection".equals(currentLesson)
                                                    ? "active" : "" %>" data-lesson="advanced-intersection">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <circle cx="12" cy="12" r="10" />
                                                        <line x1="2" y1="12" x2="22" y2="12" />
                                                    </svg>
                                                    <span>Intersection Types</span>
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/typescript/advanced-literals.jsp"
                                                    class="nav-link <%= " advanced-literals".equals(currentLesson)
                                                    ? "active" : "" %>" data-lesson="advanced-literals">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <path d="M4 7h16M4 12h16M4 17h10" />
                                                    </svg>
                                                    <span>Literal Types</span>
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/typescript/advanced-guards.jsp"
                                                    class="nav-link <%= " advanced-guards".equals(currentLesson)
                                                    ? "active" : "" %>" data-lesson="advanced-guards">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
                                                    </svg>
                                                    <span>Type Guards</span>
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/typescript/advanced-discriminated.jsp"
                                                    class="nav-link <%= " advanced-discriminated".equals(currentLesson)
                                                    ? "active" : "" %>" data-lesson="advanced-discriminated">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                                                        <polyline points="7 10 12 15 17 10" />
                                                        <line x1="12" y1="15" x2="12" y2="3" />
                                                    </svg>
                                                    <span>Discriminated Unions</span>
                                                </a>
                                            </li>
                                        </ul>
                                    </div>

                                    <%-- Module 5: Generics & Utility Types --%>
                                        <div class="nav-section">
                                            <div class="nav-section-title">Generics & Utility Types</div>
                                            <ul class="nav-items">
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/typescript/generics-intro.jsp"
                                                        class="nav-link <%= " generics-intro".equals(currentLesson)
                                                        ? "active" : "" %>" data-lesson="generics-intro">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <polygon points="12 2 2 7 12 12 22 7 12 2" />
                                                            <polyline points="2 17 12 22 22 17" />
                                                            <polyline points="2 12 12 17 22 12" />
                                                        </svg>
                                                        <span>Generics Intro</span>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/typescript/generics-functions.jsp"
                                                        class="nav-link <%= " generics-functions".equals(currentLesson)
                                                        ? "active" : "" %>" data-lesson="generics-functions">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <path
                                                                d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z" />
                                                            <line x1="4" y1="22" x2="4" y2="15" />
                                                        </svg>
                                                        <span>Generic Functions</span>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/typescript/generics-constraints.jsp"
                                                        class="nav-link <%= "generics-constraints".equals(currentLesson) ? "active" : "" %>"
                                                        data-lesson="generics-constraints">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <path
                                                                d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 1 1-7.778 7.778 5.5 5.5 0 0 1 7.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4" />
                                                        </svg>
                                                        <span>Generic Constraints</span>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/typescript/utility-partial.jsp"
                                                        class="nav-link <%= " utility-partial".equals(currentLesson)
                                                        ? "active" : "" %>" data-lesson="utility-partial">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <path
                                                                d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z" />
                                                            <polyline points="14 2 14 8 20 8" />
                                                        </svg>
                                                        <span>Partial & Required</span>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/typescript/utility-pick.jsp"
                                                        class="nav-link <%= " utility-pick".equals(currentLesson)
                                                        ? "active" : "" %>" data-lesson="utility-pick">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <path d="M9 11l3 3L22 4" />
                                                            <path
                                                                d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11" />
                                                        </svg>
                                                        <span>Pick & Omit</span>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/typescript/utility-record.jsp"
                                                        class="nav-link <%= " utility-record".equals(currentLesson)
                                                        ? "active" : "" %>" data-lesson="utility-record">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z" />
                                                            <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z" />
                                                        </svg>
                                                        <span>Record & Readonly</span>
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>

                                        <%-- Module 6: Type Manipulation --%>
                                            <div class="nav-section">
                                                <div class="nav-section-title">Type Manipulation</div>
                                                <ul class="nav-items">
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/typescript/manipulation-keyof.jsp"
                                                            class="nav-link <%= "manipulation-keyof".equals(currentLesson) ? "active" : ""
                                                            %>" data-lesson="manipulation-keyof">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <path
                                                                    d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 1 1-7.778 7.778 5.5 5.5 0 0 1 7.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4" />
                                                            </svg>
                                                            <span>keyof Operator</span>
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/typescript/manipulation-typeof.jsp"
                                                            class="nav-link <%= "manipulation-typeof".equals(currentLesson) ? "active" : ""
                                                            %>" data-lesson="manipulation-typeof">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <polyline points="16 18 22 12 16 6" />
                                                                <polyline points="8 6 2 12 8 18" />
                                                            </svg>
                                                            <span>typeof Operator</span>
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/typescript/manipulation-indexed.jsp"
                                                            class="nav-link <%= "manipulation-indexed".equals(currentLesson) ? "active" : ""
                                                            %>" data-lesson="manipulation-indexed">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <rect x="3" y="3" width="7" height="7" />
                                                                <rect x="14" y="3" width="7" height="7" />
                                                                <rect x="14" y="14" width="7" height="7" />
                                                                <rect x="3" y="14" width="7" height="7" />
                                                            </svg>
                                                            <span>Indexed Access</span>
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/typescript/manipulation-mapped.jsp"
                                                            class="nav-link <%= "manipulation-mapped".equals(currentLesson) ? "active" : ""
                                                            %>" data-lesson="manipulation-mapped">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <polygon
                                                                    points="1 6 1 22 8 18 16 22 23 18 23 2 16 6 8 2 1 6" />
                                                                <line x1="8" y1="2" x2="8" y2="18" />
                                                                <line x1="16" y1="6" x2="16" y2="22" />
                                                            </svg>
                                                            <span>Mapped Types</span>
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/typescript/manipulation-conditional.jsp"
                                                            class="nav-link <%= "manipulation-conditional".equals(currentLesson) ? "active"
                                                            : "" %>" data-lesson="manipulation-conditional">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <polyline points="20 6 9 17 4 12" />
                                                            </svg>
                                                            <span>Conditional Types</span>
                                                        </a>
                                                    </li>
                                                </ul>
                                            </div>

                                            <%-- Module 7: Modules & Real World --%>
                                                <div class="nav-section">
                                                    <div class="nav-section-title">Modules & Real World</div>
                                                    <ul class="nav-items">
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/typescript/modules-es.jsp"
                                                                class="nav-link <%= " modules-es".equals(currentLesson)
                                                                ? "active" : "" %>" data-lesson="modules-es">
                                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <path
                                                                        d="M13 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9z" />
                                                                    <polyline points="13 2 13 9 20 9" />
                                                                </svg>
                                                                <span>ES Modules</span>
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/typescript/modules-namespaces.jsp"
                                                                class="nav-link <%= "modules-namespaces".equals(currentLesson) ? "active"
                                                                : "" %>" data-lesson="modules-namespaces">
                                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <path
                                                                        d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z" />
                                                                </svg>
                                                                <span>Namespaces</span>
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/typescript/realworld-declarations.jsp"
                                                                class="nav-link <%= "realworld-declarations".equals(currentLesson) ? "active"
                                                                : "" %>" data-lesson="realworld-declarations">
                                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <path
                                                                        d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                                                                    <polyline points="14 2 14 8 20 8" />
                                                                    <line x1="16" y1="13" x2="8" y2="13" />
                                                                    <line x1="16" y1="17" x2="8" y2="17" />
                                                                    <polyline points="10 9 9 9 8 9" />
                                                                </svg>
                                                                <span>Declaration Files</span>
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/typescript/realworld-async.jsp"
                                                                class="nav-link <%= "realworld-async".equals(currentLesson) ? "active" : ""
                                                                %>" data-lesson="realworld-async">
                                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <polyline points="23 4 23 10 17 10" />
                                                                    <polyline points="1 20 1 14 7 14" />
                                                                    <path
                                                                        d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15" />
                                                                </svg>
                                                                <span>Async/Await</span>
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/typescript/realworld-errors.jsp"
                                                                class="nav-link <%= "realworld-errors".equals(currentLesson) ? "active" : ""
                                                                %>" data-lesson="realworld-errors">
                                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <circle cx="12" cy="12" r="10" />
                                                                    <line x1="12" y1="8" x2="12" y2="12" />
                                                                    <line x1="12" y1="16" x2="12.01" y2="16" />
                                                                </svg>
                                                                <span>Error Handling</span>
                                                            </a>
                                                        </li>
                                                    </ul>
                                                </div>

                                                <%-- Module 8: Professional Practices --%>
                                                    <div class="nav-section">
                                                        <div class="nav-section-title">Professional Practices</div>
                                                        <ul class="nav-items">
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/typescript/practices-structure.jsp"
                                                                    class="nav-link <%= "practices-structure".equals(currentLesson)
                                                                    ? "active" : "" %>"
                                                                    data-lesson="practices-structure">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <path
                                                                            d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z" />
                                                                    </svg>
                                                                    <span>Project Structure</span>
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/typescript/practices-strict.jsp"
                                                                    class="nav-link <%= "practices-strict".equals(currentLesson) ? "active"
                                                                    : "" %>" data-lesson="practices-strict">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <path
                                                                            d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
                                                                    </svg>
                                                                    <span>Strict Mode</span>
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/typescript/practices-linting.jsp"
                                                                    class="nav-link <%= "practices-linting".equals(currentLesson) ? "active"
                                                                    : "" %>" data-lesson="practices-linting">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <polyline
                                                                            points="22 12 18 12 15 21 9 3 6 12 2 12" />
                                                                    </svg>
                                                                    <span>Linting & Formatting</span>
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/typescript/practices-testing.jsp"
                                                                    class="nav-link <%= "practices-testing".equals(currentLesson) ? "active"
                                                                    : "" %>" data-lesson="practices-testing">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <polyline points="9 11 12 14 22 4" />
                                                                        <path
                                                                            d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11" />
                                                                    </svg>
                                                                    <span>Testing</span>
                                                                </a>
                                                            </li>
                                                        </ul>
                                                    </div>
                </nav>
            </aside>