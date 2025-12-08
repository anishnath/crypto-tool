<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- Tutorial Sidebar Component - CSS Tutorial Navigation for CSS Tutorial lessons Uses currentLesson attribute to
        highlight active item --%>
        <% String currentLesson=(String) request.getAttribute("currentLesson"); if (currentLesson==null)
            currentLesson="" ; %>
            <aside class="tutorial-sidebar" id="sidebar">
                <div class="sidebar-header">
                    <div class="sidebar-logo">
                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/css-logo.svg" alt="CSS" width="32" height="32">
                    </div>
                    <h2 class="sidebar-title">CSS Tutorial</h2>
                </div>

                <nav class="sidebar-nav">
                    <%-- Module 1: Getting Started --%>
                        <div class="nav-section">
                            <div class="nav-section-title">Getting Started</div>
                            <ul class="nav-items">
                                <li class="nav-item">
                                    <a href="<%=request.getContextPath()%>/tutorials/css/index.jsp"
                                        class="nav-link <% if(" introduction".equals(currentLesson)) { %>active<% } %>"
                                            data-lesson="introduction">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <circle cx="12" cy="12" r="10" />
                                                <line x1="12" y1="16" x2="12" y2="12" />
                                                <line x1="12" y1="8" x2="12.01" y2="8" />
                                            </svg>
                                            <span>Introduction</span>
                                            <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                style="display: none;" data-status="introduction">
                                                <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                            </svg>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="<%=request.getContextPath()%>/tutorials/css/adding-css.jsp"
                                        class="nav-link <% if(" adding-css".equals(currentLesson)) { %>active<% } %>"
                                            data-lesson="adding-css">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                                                <polyline points="14 2 14 8 20 8" />
                                            </svg>
                                            <span>Adding CSS</span>
                                            <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                style="display: none;" data-status="adding-css">
                                                <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                            </svg>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="<%=request.getContextPath()%>/tutorials/css/selectors-basics.jsp"
                                        class="nav-link <% if(" selectors-basics".equals(currentLesson)) { %>active<% }
                                            %>" data-lesson="selectors-basics">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <circle cx="11" cy="11" r="8" />
                                                <line x1="21" y1="21" x2="16.65" y2="16.65" />
                                            </svg>
                                            <span>Selectors Basics</span>
                                            <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                style="display: none;" data-status="selectors-basics">
                                                <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                            </svg>
                                    </a>
                                </li>
                            </ul>
                        </div>

                        <%-- Module 2: Text & Fonts --%>
                            <div class="nav-section">
                                <div class="nav-section-title">Text & Fonts</div>
                                <ul class="nav-items">
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/css/colors.jsp"
                                            class="nav-link <% if(" colors".equals(currentLesson)) { %>active<% } %>"
                                                data-lesson="colors">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <circle cx="12" cy="12" r="10" />
                                                    <path d="M12 2a10 10 0 0 1 0 20" />
                                                </svg>
                                                <span>Colors</span>
                                                <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                    style="display: none;" data-status="colors">
                                                    <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                </svg>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/css/text-styling.jsp"
                                            class="nav-link <% if(" text-styling".equals(currentLesson)) { %>active<% }
                                                %>" data-lesson="text-styling">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <polyline points="4 7 4 4 20 4 20 7" />
                                                    <line x1="9" y1="20" x2="15" y2="20" />
                                                    <line x1="12" y1="4" x2="12" y2="20" />
                                                </svg>
                                                <span>Text Styling</span>
                                                <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                    style="display: none;" data-status="text-styling">
                                                    <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                </svg>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/css/text-formatting.jsp"
                                            class="nav-link <% if(" text-formatting".equals(currentLesson)) { %>active<%
                                                } %>" data-lesson="text-formatting">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <line x1="17" y1="10" x2="3" y2="10" />
                                                    <line x1="21" y1="6" x2="3" y2="6" />
                                                    <line x1="21" y1="14" x2="3" y2="14" />
                                                    <line x1="17" y1="18" x2="3" y2="18" />
                                                </svg>
                                                <span>Text Formatting</span>
                                                <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                    style="display: none;" data-status="text-formatting">
                                                    <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                </svg>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/css/google-fonts.jsp"
                                            class="nav-link <% if(" google-fonts".equals(currentLesson)) { %>active<% }
                                                %>" data-lesson="google-fonts">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
                                                    <path
                                                        d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
                                                </svg>
                                                <span>Google Fonts</span>
                                                <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                    style="display: none;" data-status="google-fonts">
                                                    <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                </svg>
                                        </a>
                                    </li>
                                </ul>
                            </div>

                            <%-- Module 3: Box Model --%>
                                <div class="nav-section">
                                    <div class="nav-section-title">Box Model</div>
                                    <ul class="nav-items">
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/css/box-model.jsp"
                                                class="nav-link <% if(" box-model".equals(currentLesson)) { %>active<% }
                                                    %>" data-lesson="box-model">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                                                        <rect x="7" y="7" width="10" height="10" />
                                                    </svg>
                                                    <span>Box Model Basics</span>
                                                    <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                        style="display: none;" data-status="box-model">
                                                        <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                    </svg>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/css/borders.jsp"
                                                class="nav-link <% if(" borders".equals(currentLesson)) { %>active<% }
                                                    %>"
                                                    data-lesson="borders">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                                                    </svg>
                                                    <span>Borders</span>
                                                    <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                        style="display: none;" data-status="borders">
                                                        <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                    </svg>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/css/padding-margin.jsp"
                                                class="nav-link <%= "padding-margin".equals(currentLesson) ? "active"
                                                : "" %>" data-lesson="padding-margin">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <rect x="2" y="2" width="20" height="20" rx="2" />
                                                    <rect x="6" y="6" width="12" height="12" />
                                                </svg>
                                                <span>Padding & Margin</span>
                                                <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                    style="display: none;" data-status="padding-margin">
                                                    <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                </svg>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/css/width-height.jsp"
                                                class="nav-link <%= "width-height".equals(currentLesson) ? "active"
                                                : "" %>" data-lesson="width-height">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path
                                                        d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
                                                </svg>
                                                <span>Width & Height</span>
                                                <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                    style="display: none;" data-status="width-height">
                                                    <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                </svg>
                                            </a>
                                        </li>
                                    </ul>
                                </div>

                                <%-- Module 4: Layout Fundamentals --%>
                                    <div class="nav-section">
                                        <div class="nav-section-title">Layout Fundamentals</div>
                                        <ul class="nav-items">
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/css/display.jsp"
                                                    class="nav-link <% if(" display".equals(currentLesson)) { %>active<%
                                                        } %>" data-lesson="display">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <rect x="3" y="3" width="7" height="7" />
                                                            <rect x="14" y="3" width="7" height="7" />
                                                            <rect x="14" y="14" width="7" height="7" />
                                                            <rect x="3" y="14" width="7" height="7" />
                                                        </svg>
                                                        <span>Display Property</span>
                                                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                            style="display: none;" data-status="display">
                                                            <path
                                                                d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                        </svg>
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/css/position.jsp"
                                                    class="nav-link <%= "position".equals(currentLesson) ? "active"
                                                    : "" %>" data-lesson="position">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" />
                                                        <circle cx="12" cy="10" r="3" />
                                                    </svg>
                                                    <span>Position</span>
                                                    <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                        style="display: none;" data-status="position">
                                                        <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                    </svg>
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/css/float-clear.jsp"
                                                    class="nav-link <%= "float-clear".equals(currentLesson) ? "active"
                                                    : "" %>" data-lesson="float-clear">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <path
                                                            d="M17 3a2.828 2.828 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5L17 3z" />
                                                    </svg>
                                                    <span>Float & Clear</span>
                                                    <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                        style="display: none;" data-status="float-clear">
                                                        <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                    </svg>
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/css/flexbox-basics.jsp"
                                                    class="nav-link <%= "flexbox-basics".equals(currentLesson)
                                                    ? "active" : "" %>" data-lesson="flexbox-basics">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                                                        <line x1="9" y1="3" x2="9" y2="21" />
                                                        <line x1="15" y1="3" x2="15" y2="21" />
                                                    </svg>
                                                    <span>Flexbox Basics</span>
                                                    <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                        style="display: none;" data-status="flexbox-basics">
                                                        <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                    </svg>
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/css/flexbox-advanced.jsp"
                                                    class="nav-link <%= "flexbox-advanced".equals(currentLesson)
                                                    ? "active" : "" %>" data-lesson="flexbox-advanced">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                                                        <line x1="3" y1="9" x2="21" y2="9" />
                                                        <line x1="3" y1="15" x2="21" y2="15" />
                                                        <line x1="9" y1="3" x2="9" y2="21" />
                                                        <line x1="15" y1="3" x2="15" y2="21" />
                                                    </svg>
                                                    <span>Flexbox Advanced</span>
                                                    <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                        style="display: none;" data-status="flexbox-advanced">
                                                        <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                    </svg>
                                                </a>
                                            </li>
                                        </ul>
                                    </div>

                                    <%-- Module 5: Modern Layouts --%>
                                        <div class="nav-section">
                                            <div class="nav-section-title">Modern Layouts</div>
                                            <ul class="nav-items">
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/css/grid-basics.jsp"
                                                        class="nav-link <%= "grid-basics".equals(currentLesson)
                                                        ? "active" : "" %>" data-lesson="grid-basics">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                                                            <line x1="3" y1="9" x2="21" y2="9" />
                                                            <line x1="3" y1="15" x2="21" y2="15" />
                                                            <line x1="9" y1="3" x2="9" y2="21" />
                                                            <line x1="15" y1="3" x2="15" y2="21" />
                                                        </svg>
                                                        <span>CSS Grid Basics</span>
                                                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                            style="display: none;" data-status="grid-basics">
                                                            <path
                                                                d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                        </svg>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/css/grid-areas.jsp"
                                                        class="nav-link <%= "grid-areas".equals(currentLesson)
                                                        ? "active" : "" %>" data-lesson="grid-areas">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <rect x="3" y="3" width="7" height="7" />
                                                            <rect x="14" y="3" width="7" height="7" />
                                                            <rect x="14" y="14" width="7" height="7" />
                                                            <rect x="3" y="14" width="7" height="7" />
                                                        </svg>
                                                        <span>Grid Template Areas</span>
                                                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                            style="display: none;" data-status="grid-areas">
                                                            <path
                                                                d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                        </svg>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/css/grid-advanced.jsp"
                                                        class="nav-link <%= "grid-advanced".equals(currentLesson)
                                                        ? "active" : "" %>" data-lesson="grid-advanced">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <rect x="2" y="2" width="20" height="20" rx="2" />
                                                            <line x1="2" y1="8" x2="22" y2="8" />
                                                            <line x1="2" y1="14" x2="22" y2="14" />
                                                            <line x1="8" y1="2" x2="8" y2="22" />
                                                            <line x1="14" y1="2" x2="14" y2="22" />
                                                        </svg>
                                                        <span>CSS Grid Advanced</span>
                                                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                            style="display: none;" data-status="grid-advanced">
                                                            <path
                                                                d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                        </svg>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/css/responsive-design.jsp"
                                                        class="nav-link <%= "responsive-design".equals(currentLesson)
                                                        ? "active" : "" %>" data-lesson="responsive-design">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <rect x="2" y="3" width="20" height="14" rx="2" ry="2" />
                                                            <line x1="8" y1="21" x2="16" y2="21" />
                                                            <line x1="12" y1="17" x2="12" y2="21" />
                                                        </svg>
                                                        <span>Responsive Design</span>
                                                        <svg class="nav-status" viewBox="0 0 24 24" fill="currentColor"
                                                            style="display: none;" data-status="responsive-design">
                                                            <path
                                                                d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                        </svg>
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>

                                        <%-- Module 6: Styling Elements --%>
                                            <div class="nav-section">
                                                <div class="nav-section-title">Styling Elements</div>
                                                <ul class="nav-items">
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/css/backgrounds.jsp"
                                                            class="nav-link <%= "backgrounds".equals(currentLesson)
                                                            ? "active" : "" %>" data-lesson="backgrounds">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <rect x="3" y="3" width="18" height="18" rx="2"
                                                                    ry="2" />
                                                                <circle cx="8.5" cy="8.5" r="1.5" />
                                                                <polyline points="21 15 16 10 5 21" />
                                                            </svg>
                                                            <span>Backgrounds</span>
                                                            <svg class="nav-status" viewBox="0 0 24 24"
                                                                fill="currentColor" style="display: none;"
                                                                data-status="backgrounds">
                                                                <path
                                                                    d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                            </svg>
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/css/shadows.jsp"
                                                            class="nav-link <%= "shadows".equals(currentLesson)
                                                            ? "active" : "" %>" data-lesson="shadows">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <circle cx="12" cy="12" r="10" />
                                                                <path d="M12 2a10 10 0 0 0 0 20" />
                                                            </svg>
                                                            <span>Shadows</span>
                                                            <svg class="nav-status" viewBox="0 0 24 24"
                                                                fill="currentColor" style="display: none;"
                                                                data-status="shadows">
                                                                <path
                                                                    d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                            </svg>
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/css/transforms.jsp"
                                                            class="nav-link <%= "transforms".equals(currentLesson)
                                                            ? "active" : "" %>" data-lesson="transforms">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <polyline points="22 12 18 12 15 21 9 3 6 12 2 12" />
                                                            </svg>
                                                            <span>Transforms</span>
                                                            <svg class="nav-status" viewBox="0 0 24 24"
                                                                fill="currentColor" style="display: none;"
                                                                data-status="transforms">
                                                                <path
                                                                    d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                            </svg>
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/css/transitions.jsp"
                                                            class="nav-link <%= "transitions".equals(currentLesson)
                                                            ? "active" : "" %>" data-lesson="transitions">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <path d="M21.21 15.89A10 10 0 1 1 8 2.83" />
                                                                <path d="M22 12A10 10 0 0 0 12 2v10z" />
                                                            </svg>
                                                            <span>Transitions</span>
                                                            <svg class="nav-status" viewBox="0 0 24 24"
                                                                fill="currentColor" style="display: none;"
                                                                data-status="transitions">
                                                                <path
                                                                    d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                            </svg>
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/css/animations.jsp"
                                                            class="nav-link <%= "animations".equals(currentLesson)
                                                            ? "active" : "" %>" data-lesson="animations">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <polygon points="5 3 19 12 5 21 5 3" />
                                                            </svg>
                                                            <span>Animations</span>
                                                            <svg class="nav-status" viewBox="0 0 24 24"
                                                                fill="currentColor" style="display: none;"
                                                                data-status="animations">
                                                                <path
                                                                    d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                            </svg>
                                                        </a>
                                                    </li>
                                                </ul>
                                            </div>

                                            <%-- Module 7: Advanced Selectors --%>
                                                <div class="nav-section">
                                                    <div class="nav-section-title">Advanced Selectors</div>
                                                    <ul class="nav-items">
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/css/pseudo-classes.jsp"
                                                                class="nav-link <%= "backgrounds".equals(currentLesson)
                                                                ? "active" : "" %>" data-lesson="pseudo-classes">
                                                                <%-- <a
                                                                    href="<%=request.getContextPath()%>/tutorials/css/pseudo-classes.jsp"
                                                                    --%>
                                                                    <%-- class="nav-link <% if(" --%>
                                                                        <%-- pseudo-classes".equals(currentLesson)) {
                                                                            %>active<% } %>--%>
                                                                                <%-- " data-lesson="
                                                                                    pseudo-classes">--%>
                                                                                    <svg class="nav-icon"
                                                                                        viewBox="0 0 24 24" fill="none"
                                                                                        stroke="currentColor"
                                                                                        stroke-width="2">
                                                                                        <path
                                                                                            d="M12 2L2 7l10 5 10-5-10-5z" />
                                                                                        <path d="M2 17l10 5 10-5" />
                                                                                        <path d="M2 12l10 5 10-5" />
                                                                                    </svg>
                                                                                    <span>Pseudo-classes</span>
                                                                                    <svg class="nav-status"
                                                                                        viewBox="0 0 24 24"
                                                                                        fill="currentColor"
                                                                                        style="display: none;"
                                                                                        data-status="pseudo-classes">
                                                                                        <path
                                                                                            d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                                                    </svg>
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/css/pseudo-elements.jsp"
                                                                class="nav-link <%= "pseudo-elements".equals(currentLesson) ? "active" : ""
                                                                %>" data-lesson="pseudo-elements">
                                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <polygon points="12 2 2 7 12 12 22 7 12 2" />
                                                                    <polyline points="2 17 12 22 22 17" />
                                                                    <polyline points="2 12 12 17 22 12" />
                                                                </svg>
                                                                <span>Pseudo-elements</span>
                                                                <svg class="nav-status" viewBox="0 0 24 24"
                                                                    fill="currentColor" style="display: none;"
                                                                    data-status="pseudo-elements">
                                                                    <path
                                                                        d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                                </svg>
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/css/attribute-selectors.jsp"
                                                                class="nav-link <%= "attribute-selectors".equals(currentLesson) ? "active"
                                                                : "" %>" data-lesson="attribute-selectors">
                                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <rect x="3" y="3" width="18" height="18" rx="2"
                                                                        ry="2" />
                                                                    <line x1="9" y1="9" x2="15" y2="9" />
                                                                    <line x1="9" y1="15" x2="15" y2="15" />
                                                                </svg>
                                                                <span>Attribute Selectors</span>
                                                                <svg class="nav-status" viewBox="0 0 24 24"
                                                                    fill="currentColor" style="display: none;"
                                                                    data-status="attribute-selectors">
                                                                    <path
                                                                        d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                                </svg>
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/css/combinators.jsp"
                                                                class="nav-link <%= "combinators".equals(currentLesson)
                                                                ? "active" : "" %>" data-lesson="combinators">
                                                                <%-- <a
                                                                    href="<%=request.getContextPath()%>/tutorials/css/combinators.jsp"
                                                                    --%>
                                                                    <%-- class="nav-link <% if(" --%>
                                                                        <%-- combinators".equals(currentLesson)) {
                                                                            %>active<% } %>"--%>
                                                                                <%-- data-lesson="combinators">--%>
                                                                                    <svg class="nav-icon"
                                                                                        viewBox="0 0 24 24" fill="none"
                                                                                        stroke="currentColor"
                                                                                        stroke-width="2">
                                                                                        <polyline
                                                                                            points="16 18 22 12 16 6" />
                                                                                        <polyline
                                                                                            points="8 6 2 12 8 18" />
                                                                                    </svg>
                                                                                    <span>Combinators</span>
                                                                                    <svg class="nav-status"
                                                                                        viewBox="0 0 24 24"
                                                                                        fill="currentColor"
                                                                                        style="display: none;"
                                                                                        data-status="combinators">
                                                                                        <path
                                                                                            d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
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
                                                                <a href="<%=request.getContextPath()%>/tutorials/css/css-variables.jsp"
                                                                    class="nav-link <%= "css-variables".equals(currentLesson) ? "active" : ""
                                                                    %>" data-lesson="css-variables">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <line x1="4" y1="21" x2="4" y2="14" />
                                                                        <line x1="4" y1="10" x2="4" y2="3" />
                                                                        <line x1="12" y1="21" x2="12" y2="12" />
                                                                        <line x1="12" y1="8" x2="12" y2="3" />
                                                                        <line x1="20" y1="21" x2="20" y2="16" />
                                                                        <line x1="20" y1="12" x2="20" y2="3" />
                                                                        <line x1="1" y1="14" x2="7" y2="14" />
                                                                        <line x1="9" y1="8" x2="15" y2="8" />
                                                                        <line x1="17" y1="16" x2="23" y2="16" />
                                                                    </svg>
                                                                    <span>CSS Variables</span>
                                                                    <svg class="nav-status" viewBox="0 0 24 24"
                                                                        fill="currentColor" style="display: none;"
                                                                        data-status="css-variables">
                                                                        <path
                                                                            d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                                    </svg>
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/css/css-functions.jsp"
                                                                    class="nav-link <%= "css-functions".equals(currentLesson) ? "active" : ""
                                                                    %>" data-lesson="css-functions">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <path d="M18 20V10" />
                                                                        <path d="M12 20V4" />
                                                                        <path d="M6 20v-6" />
                                                                    </svg>
                                                                    <span>CSS Functions</span>
                                                                    <svg class="nav-status" viewBox="0 0 24 24"
                                                                        fill="currentColor" style="display: none;"
                                                                        data-status="css-functions">
                                                                        <path
                                                                            d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                                    </svg>
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/css/filters-blend.jsp"
                                                                    class="nav-link <%= "filters-blend".equals(currentLesson) ? "active" : ""
                                                                    %>" data-lesson="filters-blend">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <circle cx="12" cy="12" r="3" />
                                                                        <path
                                                                            d="M12 1v6m0 6v6m5.2-13.2l-4.2 4.2m-2.8 2.8l-4.2 4.2M23 12h-6m-6 0H5m13.2 5.2l-4.2-4.2m-2.8-2.8l-4.2-4.2" />
                                                                    </svg>
                                                                    <span>Filters & Blend Modes</span>
                                                                    <svg class="nav-status" viewBox="0 0 24 24"
                                                                        fill="currentColor" style="display: none;"
                                                                        data-status="filters-blend">
                                                                        <path
                                                                            d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
                                                                    </svg>
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/css/best-practices.jsp"
                                                                    class="nav-link <%= "best-practices".equals(currentLesson) ? "active"
                                                                    : "" %>" data-lesson="best-practices">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <polyline points="20 6 9 17 4 12" />
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

                        <%-- Sidebar Ad (Desktop only) --%>
<%--                        <div class="sidebar-ad-container" style="padding: var(--space-4); margin-top: var(--space-4);">--%>
<%--                            <%@ include file="ads/ad-sidebar.jsp" %>--%>
<%--                        </div>--%>
                </nav>
            </aside>