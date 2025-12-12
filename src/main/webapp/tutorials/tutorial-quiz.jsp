<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%-- Reusable Quiz Component Parameters: - question: The question text - option1, option2, option3, option4: The
        options (up to 4) - correctAnswer: The index of the correct answer (0-3) - quizId: Unique ID for this quiz --%>
        <% String question=request.getParameter("question"); String[] options=new String[4];
            options[0]=request.getParameter("option1"); options[1]=request.getParameter("option2");
            options[2]=request.getParameter("option3"); options[3]=request.getParameter("option4"); int correctAnswer=0;
            try { correctAnswer=Integer.parseInt(request.getParameter("correctAnswer")); } catch (NumberFormatException
            e) { correctAnswer=0; } String quizId=request.getParameter("quizId"); if (quizId==null) quizId="quiz-" +
            java.util.UUID.randomUUID().toString().substring(0, 8); %>

            <div class="card quiz-container" id="<%= quizId %>">
                <div class="quiz-header">
                    <div class="quiz-icon">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                            stroke-width="2">
                            <circle cx="12" cy="12" r="10" />
                            <path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3" />
                            <line x1="12" y1="17" x2="12.01" y2="17" />
                        </svg>
                    </div>
                    <h3 style="margin: 0;">Quick Quiz</h3>
                </div>

                <p class="quiz-question">
                    <%= question %>
                </p>

                <div class="quiz-options">
                    <% for (int i=0; i < 4; i++) { if (options[i] !=null && !options[i].isEmpty()) { %>
                        <div class="quiz-option" data-question="<%= quizId %>"
                            onclick="checkAnswer('<%= quizId %>', <%= i %>, <%= correctAnswer %>)">
                            <div class="option-marker">
                                <%= (char)('A' + i) %>
                            </div>
                            <div class="option-text">
                                <%= options[i] %>
                            </div>
                            <div class="option-status">
                                <svg class="icon-correct" width="20" height="20" viewBox="0 0 24 24" fill="none"
                                    stroke="currentColor" stroke-width="2" style="display: none;">
                                    <polyline points="20 6 9 17 4 12" />
                                </svg>
                                <svg class="icon-incorrect" width="20" height="20" viewBox="0 0 24 24" fill="none"
                                    stroke="currentColor" stroke-width="2" style="display: none;">
                                    <line x1="18" y1="6" x2="6" y2="18" />
                                    <line x1="6" y1="6" x2="18" y2="18" />
                                </svg>
                            </div>
                        </div>
                        <% } } %>
                </div>

                <div class="quiz-feedback" id="<%= quizId %>-feedback"
                    style="display: none; margin-top: var(--space-4); padding: var(--space-3); border-radius: var(--radius-md); font-size: var(--text-sm);">
                    <!-- Feedback text will be injected here -->
                </div>
            </div>

            <script>
                // Simple wrapper to call the global checkQuizAnswer if it exists
                function checkAnswer(quizId, selectedIndex, correctIndex) {
                    if (typeof window.checkQuizAnswer === 'function') {
                        const isCorrect = window.checkQuizAnswer(quizId, selectedIndex, correctIndex);
                        const feedback = document.getElementById(quizId + '-feedback');

                        // Track quiz answer in analytics
                        if (typeof trackQuizAnswer === 'function') {
                            trackQuizAnswer(quizId, isCorrect);
                        }

                        if (feedback) {
                            feedback.style.display = 'block';
                            if (isCorrect) {
                                feedback.style.background = 'var(--success-light)';
                                feedback.style.color = 'var(--success)';
                                feedback.textContent = 'Correct! Well done.';
                            } else {
                                feedback.style.background = 'var(--error-light)';
                                feedback.style.color = 'var(--error)';
                                feedback.textContent = 'Incorrect. Try again!';
                            }
                        }
                    }
                }
            </script>