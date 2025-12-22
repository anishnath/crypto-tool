<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- Tutorial Sidebar Component - DSA Navigation --%>
        <% String currentLesson=(String) request.getAttribute("currentLesson"); if (currentLesson==null)
            currentLesson="" ; %>
            <aside class="tutorial-sidebar" id="sidebar">
                <div class="sidebar-header">
                    <div class="sidebar-logo">
                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/dsa-logo.svg" alt="DSA"
                            width="32" height="32">
                    </div>
                    <h2 class="sidebar-title">DSA Tutorial</h2>
                </div>

                <nav class="sidebar-nav">
                    <%-- Module 1: Introduction & Fundamentals --%>
                        <div class="nav-section">
                            <div class="nav-section-title">Introduction & Fundamentals</div>
                            <ul class="nav-items">
                                <li class="nav-item">
                                    <a href="<%=request.getContextPath()%>/tutorials/dsa/intro.jsp"
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
                                    <a href="<%=request.getContextPath()%>/tutorials/dsa/complexity.jsp"
                                        class="nav-link <%= " complexity".equals(currentLesson) ? "active" : "" %>"
                                        data-lesson="complexity">
                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                            stroke-width="2">
                                            <path d="M3 3v18h18" />
                                            <path d="M18 17l-5-5-4 4-4-4" />
                                        </svg>
                                        <span>Time & Space Complexity</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="<%=request.getContextPath()%>/tutorials/dsa/algorithm-analysis.jsp"
                                        class="nav-link <%= " algorithm-analysis".equals(currentLesson) ? "active" : ""
                                        %>"
                                        data-lesson="algorithm-analysis">
                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                            stroke-width="2">
                                            <path d="M12 2L2 7l10 5 10-5-10-5z" />
                                            <path d="M2 17l10 5 10-5" />
                                            <path d="M2 12l10 5 10-5" />
                                        </svg>
                                        <span>Algorithm Analysis</span>
                                    </a>
                                </li>
                            </ul>
                        </div>

                        <%-- Module 2: Arrays & Strings --%>
                            <div class="nav-section">
                                <div class="nav-section-title">Arrays & Strings</div>
                                <ul class="nav-items">
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/dsa/array-basics.jsp"
                                            class="nav-link <%= " array-basics".equals(currentLesson) ? "active" : ""
                                            %>"
                                            data-lesson="array-basics">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <rect x="3" y="3" width="7" height="7" />
                                                <rect x="14" y="3" width="7" height="7" />
                                                <rect x="14" y="14" width="7" height="7" />
                                                <rect x="3" y="14" width="7" height="7" />
                                            </svg>
                                            <span>Array Fundamentals</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/dsa/two-pointers.jsp"
                                            class="nav-link <%= " two-pointers".equals(currentLesson) ? "active" : ""
                                            %>"
                                            data-lesson="two-pointers">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <path d="M8 9l4-4 4 4" />
                                                <path d="M16 15l-4 4-4-4" />
                                            </svg>
                                            <span>Two Pointers</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/dsa/sliding-window.jsp"
                                            class="nav-link <%= " sliding-window".equals(currentLesson) ? "active" : ""
                                            %>"
                                            data-lesson="sliding-window">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <rect x="2" y="6" width="20" height="12" rx="2" />
                                                <path d="M12 6v12" />
                                            </svg>
                                            <span>Sliding Window</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<%=request.getContextPath()%>/tutorials/dsa/string-basics.jsp"
                                            class="nav-link <%= " string-basics".equals(currentLesson) ? "active" : ""
                                            %>"
                                            data-lesson="string-basics">
                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2">
                                                <path d="M4 7h16M4 12h16M4 17h10" />
                                            </svg>
                                            <span>String Manipulation</span>
                                        </a>
                                    </li>
                                </ul>
                            </div>

                            <%-- Module 3: Sorting Algorithms --%>
                                <div class="nav-section">
                                    <div class="nav-section-title">Sorting Algorithms</div>
                                    <ul class="nav-items">
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/dsa/bubble-sort.jsp"
                                                class="nav-link <%= " bubble-sort".equals(currentLesson) ? "active" : ""
                                                %>"
                                                data-lesson="bubble-sort">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <circle cx="12" cy="12" r="10" />
                                                    <path d="M8 12h8" />
                                                    <path d="M12 8v8" />
                                                </svg>
                                                <span>Bubble Sort</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/dsa/selection-sort.jsp"
                                                class="nav-link <%= " selection-sort".equals(currentLesson) ? "active"
                                                : "" %>"
                                                data-lesson="selection-sort">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M9 11l3 3L22 4" />
                                                    <path d="M21 12v7a2 2 0 01-2 2H5a2 2 0 01-2-2V5a2 2 0 012-2h11" />
                                                </svg>
                                                <span>Selection Sort</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/dsa/insertion-sort.jsp"
                                                class="nav-link <%= " insertion-sort".equals(currentLesson) ? "active"
                                                : "" %>"
                                                data-lesson="insertion-sort">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M16 18l6-6-6-6" />
                                                    <path d="M8 6l-6 6 6 6" />
                                                </svg>
                                                <span>Insertion Sort</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/dsa/merge-sort.jsp"
                                                class="nav-link <%= " merge-sort".equals(currentLesson) ? "active" : ""
                                                %>"
                                                data-lesson="merge-sort">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M12 2L2 7l10 5 10-5-10-5z" />
                                                    <path d="M2 17l10 5 10-5" />
                                                    <path d="M2 12l10 5 10-5" />
                                                </svg>
                                                <span>Merge Sort</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/dsa/quick-sort.jsp"
                                                class="nav-link <%= " quick-sort".equals(currentLesson) ? "active" : ""
                                                %>"
                                                data-lesson="quick-sort">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <polyline points="4 17 10 11 4 5" />
                                                    <line x1="12" y1="19" x2="20" y2="19" />
                                                </svg>
                                                <span>Quick Sort</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/dsa/heap-sort.jsp"
                                                class="nav-link <%= " heap-sort".equals(currentLesson) ? "active" : ""
                                                %>"
                                                data-lesson="heap-sort">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M12 2L2 7l10 5 10-5-10-5z" />
                                                    <path d="M2 17l10 5 10-5" />
                                                    <path d="M2 12l10 5 10-5" />
                                                </svg>
                                                <span>Heap Sort</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/dsa/counting-sort.jsp"
                                                class="nav-link <%= " counting-sort".equals(currentLesson) ? "active"
                                                : "" %>"
                                                data-lesson="counting-sort">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M4 7h16M4 12h16M4 17h10" />
                                                </svg>
                                                <span>Counting Sort</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/dsa/radix-sort.jsp"
                                                class="nav-link <%= " radix-sort".equals(currentLesson) ? "active" : ""
                                                %>"
                                                data-lesson="radix-sort">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <rect x="3" y="3" width="7" height="7" />
                                                    <rect x="14" y="3" width="7" height="7" />
                                                    <rect x="14" y="14" width="7" height="7" />
                                                    <rect x="3" y="14" width="7" height="7" />
                                                </svg>
                                                <span>Radix Sort</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<%=request.getContextPath()%>/tutorials/dsa/tim-sort.jsp"
                                                class="nav-link <%= " tim-sort".equals(currentLesson) ? "active" : ""
                                                %>"
                                                data-lesson="tim-sort">
                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <polygon points="12 2 2 7 12 12 22 7 12 2" />
                                                    <polyline points="2 17 12 22 22 17" />
                                                    <polyline points="2 12 12 17 22 12" />
                                                </svg>
                                                <span>Tim Sort</span>
                                            </a>
                                        </li>
                                    </ul>
                                </div>

                                <%-- Module 4: Searching Algorithms --%>
                                    <div class="nav-section">
                                        <div class="nav-section-title">Searching Algorithms</div>
                                        <ul class="nav-items">
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/dsa/binary-search.jsp"
                                                    class="nav-link <%= " binary-search".equals(currentLesson)
                                                    ? "active" : "" %>"
                                                    data-lesson="binary-search">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <path d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                                                    </svg>
                                                    <span>Binary Search</span>
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/dsa/linear-search.jsp"
                                                    class="nav-link <%= " linear-search".equals(currentLesson)
                                                    ? "active" : "" %>"
                                                    data-lesson="linear-search">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <circle cx="11" cy="11" r="8" />
                                                        <path d="M21 21l-4.35-4.35" />
                                                    </svg>
                                                    <span>Linear Search</span>
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/dsa/binary-search-variants.jsp"
                                                    class="nav-link <%= " binary-search-variants".equals(currentLesson)
                                                    ? "active" : "" %>"
                                                    data-lesson="binary-search-variants">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <path
                                                            d="M9 3v2m6-2v2M9 19v2m6-2v2M5 9H3m2 6H3m18-6h-2m2 6h-2M7 19h10a2 2 0 002-2V7a2 2 0 00-2-2H7a2 2 0 00-2 2v10a2 2 0 002 2zM9 9h6v6H9V9z" />
                                                    </svg>
                                                    <span>Binary Search Variants</span>
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/dsa/interpolation-search.jsp"
                                                    class="nav-link <%= " interpolation-search".equals(currentLesson)
                                                    ? "active" : "" %>"
                                                    data-lesson="interpolation-search">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <path d="M3 3v18h18" />
                                                        <path d="M7 12l4-7 4 14 4-7" />
                                                    </svg>
                                                    <span>Interpolation Search</span>
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="<%=request.getContextPath()%>/tutorials/dsa/exponential-search.jsp"
                                                    class="nav-link <%= " exponential-search".equals(currentLesson)
                                                    ? "active" : "" %>"
                                                    data-lesson="exponential-search">
                                                    <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <path d="M3 20l6-6 4 4 8-8" />
                                                        <path d="M21 12v-8h-8" />
                                                    </svg>
                                                    <span>Exponential Search</span>
                                                </a>
                                            </li>
                                        </ul>
                                    </div>

                                    <%-- Module 5: Linked Lists --%>
                                        <div class="nav-section">
                                            <div class="nav-section-title">Linked Lists</div>
                                            <ul class="nav-items">
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/dsa/linked-list-basics.jsp"
                                                        class="nav-link <%= " linked-list-basics".equals(currentLesson)
                                                        ? "active" : "" %>"
                                                        data-lesson="linked-list-basics">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <path
                                                                d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71" />
                                                            <path
                                                                d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71" />
                                                        </svg>
                                                        <span>Singly Linked List</span>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/dsa/linked-list-reversal.jsp"
                                                        class="nav-link <%= "linked-list-reversal".equals(currentLesson) ? "active" : "" %>"
                                                        data-lesson="linked-list-reversal">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <path d="M3 7h18M3 12h18M3 17h18" />
                                                            <path d="M21 7l-4-4m0 8l4-4" />
                                                        </svg>
                                                        <span>Reversal</span>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/dsa/linked-list-cycle.jsp"
                                                        class="nav-link <%= " linked-list-cycle".equals(currentLesson)
                                                        ? "active" : "" %>"
                                                        data-lesson="linked-list-cycle">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <path
                                                                d="M21 12a9 9 0 11-9-9c2.52 0 4.93 1 6.74 2.74L21 8" />
                                                            <path d="M21 3v5h-5" />
                                                        </svg>
                                                        <span>Cycle Detection</span>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/dsa/linked-list-two-pointers.jsp"
                                                        class="nav-link <%= "linked-list-two-pointers".equals(currentLesson) ? "active" : ""
                                                        %>"
                                                        data-lesson="linked-list-two-pointers">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <circle cx="9" cy="12" r="1" />
                                                            <circle cx="15" cy="12" r="1" />
                                                            <path d="M3 12h18" />
                                                        </svg>
                                                        <span>Two Pointers</span>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/dsa/doubly-linked-list.jsp"
                                                        class="nav-link <%= " doubly-linked-list".equals(currentLesson)
                                                        ? "active" : "" %>"
                                                        data-lesson="doubly-linked-list">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <path d="M17 12H7m10 0l-4-4m4 4l-4 4M7 12l4-4m-4 4l4 4" />
                                                        </svg>
                                                        <span>Doubly Linked List</span>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/dsa/circular-linked-list.jsp"
                                                        class="nav-link <%= "circular-linked-list".equals(currentLesson) ? "active" : "" %>"
                                                        data-lesson="circular-linked-list">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <circle cx="12" cy="12" r="9" />
                                                            <path d="M12 3v6m0 6v6" />
                                                        </svg>
                                                        <span>Circular Linked List</span>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="<%=request.getContextPath()%>/tutorials/dsa/linked-list-advanced.jsp"
                                                        class="nav-link <%= "linked-list-advanced".equals(currentLesson) ? "active" : "" %>"
                                                        data-lesson="linked-list-advanced">
                                                        <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <path d="M12 2L2 7l10 5 10-5-10-5z" />
                                                            <path d="M2 17l10 5 10-5M2 12l10 5 10-5" />
                                                        </svg>
                                                        <span>Advanced Problems</span>
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>

                                        <%-- Module 6: Stacks & Queues --%>
                                            <div class="nav-section">
                                                <div class="nav-section-title">Stacks & Queues</div>
                                                <ul class="nav-items">
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/dsa/stack-basics.jsp"
                                                            class="nav-link <%= " stack-basics".equals(currentLesson)
                                                            ? "active" : "" %>"
                                                            data-lesson="stack-basics">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <rect x="3" y="3" width="18" height="4" />
                                                                <rect x="3" y="10" width="18" height="4" />
                                                                <rect x="3" y="17" width="18" height="4" />
                                                            </svg>
                                                            <span>Stack Basics</span>
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/dsa/stack-applications.jsp"
                                                            class="nav-link <%= "stack-applications".equals(currentLesson) ? "active" : ""
                                                            %>"
                                                            data-lesson="stack-applications">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <path d="M12 2L2 7l10 5 10-5-10-5z" />
                                                                <path d="M2 17l10 5 10-5M2 12l10 5 10-5" />
                                                            </svg>
                                                            <span>Stack Applications</span>
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/dsa/queue-basics.jsp"
                                                            class="nav-link <%= " queue-basics".equals(currentLesson)
                                                            ? "active" : "" %>"
                                                            data-lesson="queue-basics">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <path d="M17 1l4 4-4 4" />
                                                                <path d="M3 11V9a4 4 0 014-4h14" />
                                                                <path d="M7 23l-4-4 4-4" />
                                                                <path d="M21 13v2a4 4 0 01-4 4H3" />
                                                            </svg>
                                                            <span>Queue Basics</span>
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/dsa/queue-variations.jsp"
                                                            class="nav-link <%= "queue-variations".equals(currentLesson) ? "active" : "" %>"
                                                            data-lesson="queue-variations">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <circle cx="12" cy="12" r="10" />
                                                                <path d="M12 6v6l4 2" />
                                                            </svg>
                                                            <span>Queue Variations</span>
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="<%=request.getContextPath()%>/tutorials/dsa/stack-queue-combined.jsp"
                                                            class="nav-link <%= "stack-queue-combined".equals(currentLesson) ? "active" : ""
                                                            %>"
                                                            data-lesson="stack-queue-combined">
                                                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <path d="M12 2L2 7l10 5 10-5-10-5z" />
                                                                <path d="M2 17l10 5 10-5M2 12l10 5 10-5" />
                                                            </svg>
                                                            <span>Combined Problems</span>
                                                        </a>
                                                    </li>
                                                </ul>
                                            </div>

                                            <%-- Module 7: Hashing --%>
                                                <div class="nav-section">
                                                    <div class="nav-section-title">Hashing</div>
                                                    <ul class="nav-items">
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/dsa/hash-tables.jsp"
                                                                class="nav-link <%= " hash-tables".equals(currentLesson)
                                                                ? "active" : "" %>"
                                                                data-lesson="hash-tables">
                                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <rect x="3" y="3" width="7" height="7" />
                                                                    <rect x="14" y="3" width="7" height="7" />
                                                                    <rect x="14" y="14" width="7" height="7" />
                                                                    <rect x="3" y="14" width="7" height="7" />
                                                                </svg>
                                                                <span>Hash Tables</span>
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/dsa/hash-maps-sets.jsp"
                                                                class="nav-link <%= "hash-maps-sets".equals(currentLesson) ? "active" : ""
                                                                %>"
                                                                data-lesson="hash-maps-sets">
                                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <circle cx="9" cy="9" r="7" />
                                                                    <circle cx="15" cy="15" r="7" />
                                                                </svg>
                                                                <span>Hash Maps & Sets</span>
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="<%=request.getContextPath()%>/tutorials/dsa/advanced-hashing.jsp"
                                                                class="nav-link <%= "advanced-hashing".equals(currentLesson) ? "active" : ""
                                                                %>"
                                                                data-lesson="advanced-hashing">
                                                                <svg class="nav-icon" viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <path d="M12 2L2 7l10 5 10-5-10-5z" />
                                                                    <path d="M2 17l10 5 10-5M2 12l10 5 10-5" />
                                                                </svg>
                                                                <span>Advanced Hashing</span>
                                                            </a>
                                                        </li>
                                                    </ul>
                                                </div>

                                                <%-- Module 8: Trees --%>
                                                    <div class="nav-section">
                                                        <div class="nav-section-title">Trees</div>
                                                        <ul class="nav-items">
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/dsa/binary-tree.jsp"
                                                                    class="nav-link <%= "binary-tree".equals(currentLesson) ? "active" : ""
                                                                    %>"
                                                                    data-lesson="binary-tree">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <path d="M12 2L2 7l10 5 10-5-10-5z" />
                                                                        <path d="M2 17l10 5 10-5" />
                                                                    </svg>
                                                                    <span>Binary Tree Basics</span>
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/dsa/tree-traversals.jsp"
                                                                    class="nav-link <%= "tree-traversals".equals(currentLesson) ? "active"
                                                                    : "" %>"
                                                                    data-lesson="tree-traversals">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <path
                                                                            d="M21 12a9 9 0 11-9-9c2.52 0 4.93 1 6.74 2.74L21 8" />
                                                                        <path d="M21 3v5h-5" />
                                                                    </svg>
                                                                    <span>Tree Traversals</span>
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/dsa/binary-search-tree.jsp"
                                                                    class="nav-link <%= "binary-search-tree".equals(currentLesson) ? "active"
                                                                    : "" %>"
                                                                    data-lesson="binary-search-tree">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <circle cx="12" cy="12" r="10" />
                                                                        <line x1="2" y1="12" x2="22" y2="12" />
                                                                    </svg>
                                                                    <span>Binary Search Tree</span>
                                                                </a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="<%=request.getContextPath()%>/tutorials/dsa/tree-problems.jsp"
                                                                    class="nav-link <%= "tree-problems".equals(currentLesson) ? "active" : ""
                                                                    %>"
                                                                    data-lesson="tree-problems">
                                                                    <svg class="nav-icon" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <path d="M12 2L2 7l10 5 10-5-10-5z" />
                                                                        <path d="M2 17l10 5 10-5M2 12l10 5 10-5" />
                                                                    </svg>
                                                                    <span>Tree Problems</span>
                                                                </a>
                                                            </li>
                                                        </ul>
                                                    </div>

                                                    <%-- Module 9: Advanced Trees --%>
                                                        <div class="nav-section">
                                                            <div class="nav-section-title">Advanced Trees</div>
                                                            <ul class="nav-items">
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/dsa/heaps.jsp"
                                                                        class="nav-link <%= "heaps".equals(currentLesson) ? "active" : "" %>"
                                                                        data-lesson="heaps">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <path d="M12 2L2 7l10 5 10-5-10-5z" />
                                                                            <path d="M2 17l10 5 10-5" />
                                                                        </svg>
                                                                        <span>Heaps</span>
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/dsa/heap-applications.jsp"
                                                                        class="nav-link <%= "heap-applications".equals(currentLesson)
                                                                        ? "active" : "" %>"
                                                                        data-lesson="heap-applications">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <path d="M12 2v20M2 12h20" />
                                                                        </svg>
                                                                        <span>Heap Applications</span>
                                                                    </a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a href="<%=request.getContextPath()%>/tutorials/dsa/tries.jsp"
                                                                        class="nav-link <%= "tries".equals(currentLesson) ? "active" : "" %>"
                                                                        data-lesson="tries">
                                                                        <svg class="nav-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <path d="M12 2v8M12 10l-4 4M12 10l4 4" />
                                                                        </svg>
                                                                        <span>Tries</span>
                                                                    </a>
                                                                </li>
                                                            </ul>
                                                        </div>

                                                        <%-- Module 10: Graphs --%>
                                                            <div class="nav-section">
                                                                <div class="nav-section-title">Graphs</div>
                                                                <ul class="nav-items">
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/dsa/graph-representation.jsp"
                                                                            class="nav-link <%= "graph-representation".equals(currentLesson)
                                                                            ? "active" : "" %>"
                                                                            data-lesson="graph-representation">
                                                                            <svg class="nav-icon" viewBox="0 0 24 24"
                                                                                fill="none" stroke="currentColor"
                                                                                stroke-width="2">
                                                                                <rect x="3" y="3" width="7" height="7" />
                                                                                <rect x="14" y="3" width="7" height="7" />
                                                                                <rect x="14" y="14" width="7" height="7" />
                                                                                <rect x="3" y="14" width="7" height="7" />
                                                                            </svg>
                                                                            <span>Graph Representation</span>
                                                                        </a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/dsa/bfs.jsp"
                                                                            class="nav-link <%= "bfs".equals(currentLesson) ? "active" : ""
                                                                            %>"
                                                                            data-lesson="bfs">
                                                                            <svg class="nav-icon" viewBox="0 0 24 24"
                                                                                fill="none" stroke="currentColor"
                                                                                stroke-width="2">
                                                                                <path
                                                                                    d="M21 12a9 9 0 1 1-9-9c2.52 0 4.93 1 6.74 2.74L21 8" />
                                                                                <path d="M21 3v5h-5" />
                                                                            </svg>
                                                                            <span>BFS</span>
                                                                        </a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/dsa/dfs.jsp"
                                                                            class="nav-link <%= "dfs".equals(currentLesson) ? "active" : ""
                                                                            %>"
                                                                            data-lesson="dfs">
                                                                            <svg class="nav-icon" viewBox="0 0 24 24"
                                                                                fill="none" stroke="currentColor"
                                                                                stroke-width="2">
                                                                                <path
                                                                                    d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
                                                                            </svg>
                                                                            <span>DFS</span>
                                                                        </a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a href="<%=request.getContextPath()%>/tutorials/dsa/topological-sort.jsp"
                                                                            class="nav-link <%= "topological-sort".equals(currentLesson) ? "active" : ""
                                                                            %>"
                                                                            data-lesson="topological-sort">
                                                                            <svg class="nav-icon" viewBox="0 0 24 24"
                                                                                fill="none" stroke="currentColor"
                                                                                stroke-width="2">
                                                                                <path d="M4 7h16M4 12h16M4 17h10" />
                                                                            </svg>
                                                                            <span>Topological Sort</span>
                                                                        </a>
                                                                    </li>
                                                                </ul>
                                                            </div>

                                                            <%-- Module 11: Advanced Graphs --%>
                                                                <div class="nav-section">
                                                                    <div class="nav-section-title">Advanced Graphs</div>
                                                                    <ul class="nav-items">
                                                                        <li class="nav-item">
                                                                            <a href="<%=request.getContextPath()%>/tutorials/dsa/dijkstra.jsp"
                                                                                class="nav-link <%= "dijkstra".equals(currentLesson) ? "active" : "" %>"
                                                                                data-lesson="dijkstra">
                                                                                <svg class="nav-icon" viewBox="0 0 24 24"
                                                                                    fill="none" stroke="currentColor"
                                                                                    stroke-width="2">
                                                                                    <path d="M21 12a9 9 0 1 1-9-9c2.52 0 4.93 1 6.74 2.74L21 8" />
                                                                                    <path d="M21 3v5h-5" />
                                                                                </svg>
                                                                                <span>Dijkstra's Algorithm</span>
                                                                            </a>
                                                                        </li>
                                                                        <li class="nav-item">
                                                                            <a href="<%=request.getContextPath()%>/tutorials/dsa/bellman-ford.jsp"
                                                                                class="nav-link <%= "bellman-ford".equals(currentLesson) ? "active" : "" %>"
                                                                                data-lesson="bellman-ford">
                                                                                <svg class="nav-icon" viewBox="0 0 24 24"
                                                                                    fill="none" stroke="currentColor"
                                                                                    stroke-width="2">
                                                                                    <circle cx="12" cy="12" r="10" />
                                                                                    <path d="M12 6v6l4 2" />
                                                                                </svg>
                                                                                <span>Bellman-Ford</span>
                                                                            </a>
                                                                        </li>
                                                                        <li class="nav-item">
                                                                            <a href="<%=request.getContextPath()%>/tutorials/dsa/mst.jsp"
                                                                                class="nav-link <%= "mst".equals(currentLesson) ? "active" : "" %>"
                                                                                data-lesson="mst">
                                                                                <svg class="nav-icon" viewBox="0 0 24 24"
                                                                                    fill="none" stroke="currentColor"
                                                                                    stroke-width="2">
                                                                                    <path d="M12 2L2 7l10 5 10-5-10-5z" />
                                                                                    <path d="M2 17l10 5 10-5" />
                                                                                </svg>
                                                                                <span>Minimum Spanning Tree</span>
                                                                            </a>
                                                                        </li>
                                                                        <li class="nav-item">
                                                                            <a href="<%=request.getContextPath()%>/tutorials/dsa/advanced-graphs.jsp"
                                                                                class="nav-link <%= "advanced-graphs".equals(currentLesson) ? "active" : "" %>"
                                                                                data-lesson="advanced-graphs">
                                                                                <svg class="nav-icon" viewBox="0 0 24 24"
                                                                                    fill="none" stroke="currentColor"
                                                                                    stroke-width="2">
                                                                                    <circle cx="18" cy="5" r="3" />
                                                                                    <circle cx="6" cy="12" r="3" />
                                                                                    <circle cx="18" cy="19" r="3" />
                                                                                    <line x1="8.59" y1="13.51" x2="15.42" y2="17.49" />
                                                                                    <line x1="15.41" y1="6.51" x2="8.59" y2="10.49" />
                                                                                </svg>
                                                                                <span>Advanced Graphs</span>
                                                                            </a>
                                                                        </li>
                                                                    </ul>
                                                                </div>

                                                                <%-- Module 12 & 13: Dynamic Programming --%>
                                                                    <div class="nav-section">
                                                                        <div class="nav-section-title">Dynamic Programming
                                                                        </div>
                                                                        <ul class="nav-items">
                                                                            <li class="nav-item">
                                                                                <a href="<%=request.getContextPath()%>/tutorials/dsa/dp-fundamentals.jsp"
                                                                                    class="nav-link <%= "dp-fundamentals".equals(currentLesson)
                                                                                    ? "active" : "" %>"
                                                                                    data-lesson="dp-fundamentals">
                                                                                    <svg class="nav-icon"
                                                                                        viewBox="0 0 24 24" fill="none"
                                                                                        stroke="currentColor"
                                                                                        stroke-width="2">
                                                                                        <polyline
                                                                                            points="23 4 23 10 17 10" />
                                                                                        <path
                                                                                            d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10" />
                                                                                    </svg>
                                                                                    <span>DP Fundamentals</span>
                                                                                </a>
                                                                            </li>
                                                                            <li class="nav-item">
                                                                                <a href="<%=request.getContextPath()%>/tutorials/dsa/dp-problems.jsp"
                                                                                    class="nav-link <%= "dp-problems".equals(currentLesson)
                                                                                    ? "active" : "" %>"
                                                                                    data-lesson="dp-problems">
                                                                                    <svg class="nav-icon"
                                                                                        viewBox="0 0 24 24" fill="none"
                                                                                        stroke="currentColor"
                                                                                        stroke-width="2">
                                                                                        <rect x="3" y="3" width="7" height="7" />
                                                                                        <rect x="14" y="3" width="7" height="7" />
                                                                                        <rect x="14" y="14" width="7" height="7" />
                                                                                        <rect x="3" y="14" width="7" height="7" />
                                                                                    </svg>
                                                                                    <span>DP Problems</span>
                                                                                </a>
                                                                            </li>
                                                                            <li class="nav-item">
                                                                                <a href="<%=request.getContextPath()%>/tutorials/dsa/dp-advanced.jsp"
                                                                                    class="nav-link <%= "dp-advanced".equals(currentLesson)
                                                                                    ? "active" : "" %>"
                                                                                    data-lesson="dp-advanced">
                                                                                    <svg class="nav-icon"
                                                                                        viewBox="0 0 24 24" fill="none"
                                                                                        stroke="currentColor"
                                                                                        stroke-width="2">
                                                                                        <path d="M12 2L2 7l10 5 10-5-10-5z" />
                                                                                        <path d="M2 17l10 5 10-5M2 12l10 5 10-5" />
                                                                                    </svg>
                                                                                    <span>Advanced DP</span>
                                                                                </a>
                                                                            </li>
                                                                        </ul>
                                                                    </div>
                </nav>
            </aside>