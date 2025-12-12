<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- Reusable Navigation Component Parameters: - prevLink: URL for previous lesson - prevTitle: Title of previous
        lesson - nextLink: URL for next lesson - nextTitle: Title of next lesson - currentLessonId: ID of current lesson
        (for progress tracking) --%>
        <% String prevLink=request.getParameter("prevLink"); String prevTitle=request.getParameter("prevTitle"); String
            nextLink=request.getParameter("nextLink"); String nextTitle=request.getParameter("nextTitle"); String
            currentLessonId=request.getParameter("currentLessonId"); %>

            <div class="tutorial-nav">
                <div class="nav-left">
                    <% if (prevLink !=null && !prevLink.isEmpty()) { %>
                        <a href="<%= prevLink %>" class="btn btn-secondary nav-btn">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="2">
                                <polyline points="15 18 9 12 15 6" />
                            </svg>
                            <div class="nav-btn-text">
                                <span class="nav-label">Previous</span>
                                <span class="nav-title">
                                    <%= prevTitle %>
                                </span>
                            </div>
                        </a>
                        <% } %>
                </div>

                <div class="nav-center">
                    <% if (currentLessonId !=null && !currentLessonId.isEmpty()) { %>
                        <button class="btn btn-success" onclick="markComplete('<%= currentLessonId %>')">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="2">
                                <polyline points="20 6 9 17 4 12" />
                            </svg>
                            Mark as Complete
                        </button>
                        <% } %>
                </div>

                <div class="nav-right">
                    <% if (nextLink !=null && !nextLink.isEmpty()) { %>
                        <a href="<%= nextLink %>" class="btn btn-primary nav-btn">
                            <div class="nav-btn-text" style="text-align: right;">
                                <span class="nav-label">Next</span>
                                <span class="nav-title">
                                    <%= nextTitle %>
                                </span>
                            </div>
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="2">
                                <polyline points="9 18 15 12 9 6" />
                            </svg>
                        </a>
                        <% } %>
                </div>
            </div>

            <script>
                function markComplete(lessonId) {
                    if (typeof TutorialProgress !== 'undefined') {
                        // Detect tutorial from URL path
                        const path = window.location.pathname;
                        const match = path.match(/\/tutorials\/([^\/]+)\//);
                        const tutorial = match ? match[1] : 'html';

                        TutorialProgress.markComplete(tutorial, lessonId);

                        // Track lesson completion in analytics
                        if (typeof trackLessonComplete === 'function') {
                            trackLessonComplete(lessonId);
                        }

                        // Show feedback
                        const btn = document.querySelector('.nav-center .btn');
                        const originalText = btn.innerHTML;

                        btn.innerHTML = `
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polyline points="20 6 9 17 4 12"/>
                </svg>
                Completed!
            `;
                        btn.disabled = true;

                        // Confetti or animation could go here

                        // Update sidebar immediately
                        if (typeof updateProgressUI === 'function') {
                            updateProgressUI();
                        } else {
                            // Fallback reload to show progress
                            setTimeout(() => location.reload(), 500);
                        }
                    }
                }
            </script>

            <style>
                .tutorial-nav {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-top: var(--space-16);
                    padding-top: var(--space-8);
                    border-top: 1px solid var(--border);
                }

                .nav-btn {
                    display: flex;
                    align-items: center;
                    gap: var(--space-3);
                    padding: var(--space-3) var(--space-4);
                    height: auto;
                }

                .nav-btn-text {
                    display: flex;
                    flex-direction: column;
                    gap: 2px;
                }

                .nav-label {
                    font-size: var(--text-xs);
                    text-transform: uppercase;
                    letter-spacing: 0.05em;
                    opacity: 0.7;
                }

                .nav-title {
                    font-weight: 600;
                }

                @media (max-width: 640px) {
                    .tutorial-nav {
                        flex-direction: column;
                        gap: var(--space-4);
                    }

                    .nav-left,
                    .nav-right,
                    .nav-center {
                        width: 100%;
                    }

                    .nav-btn {
                        width: 100%;
                        justify-content: center;
                    }

                    .nav-btn-text {
                        align-items: center;
                    }
                }
            </style>