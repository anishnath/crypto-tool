/**
 * Exam Platform - Core Module
 * Handles data loading, state management, and utilities
 */

const ExamCore = (function() {
    'use strict';

    // State
    let state = {
        currentSet: null,
        questions: [],
        answers: {},
        markedQuestions: new Set(),
        currentQuestionIndex: 0,
        startTime: null,
        timeRemaining: 0,
        isSubmitted: false
    };

    // Configuration
    const config = {
        storagePrefix: 'exam_',
        autoSaveInterval: 30000 // 30 seconds
    };

    /**
     * Initialize the exam system
     */
    function init(options = {}) {
        Object.assign(config, options);
        loadTheme();
        setupThemeToggle();
    }

    /**
     * Load a practice set from JSON (legacy method)
     */
    async function loadSet(setPath) {
        try {
            const response = await fetch(setPath);
            if (!response.ok) {
                throw new Error(`Failed to load set: ${response.status}`);
            }
            const data = await response.json();
            loadSetData(data);
            return data;
        } catch (error) {
            console.error('Error loading practice set:', error);
            throw error;
        }
    }

    /**
     * Load practice set data directly (for API-loaded data)
     */
    function loadSetData(data) {
        state.currentSet = data;
        state.questions = data.questions || [];
        state.answers = {};
        state.markedQuestions = new Set();
        state.currentQuestionIndex = 0;
        state.isSubmitted = false;

        // Try to restore saved state
        restoreState(data.set_id || data.batch_id);
    }

    /**
     * Get current state
     */
    function getState() {
        return {
            ...state,
            markedQuestions: Array.from(state.markedQuestions)
        };
    }

    /**
     * Save answer for a question
     */
    function saveAnswer(questionId, answer) {
        // Validate questionId - prevent undefined/null keys
        if (!questionId || questionId === 'undefined' || questionId === 'null') {
            console.warn('Attempted to save answer with invalid questionId:', questionId);
            return state.answers;
        }
        
        state.answers[questionId] = answer;
        persistState();
        return state.answers;
    }

    /**
     * Get answer for a question
     */
    function getAnswer(questionId) {
        return state.answers[questionId];
    }

    /**
     * Clear answer for a question
     */
    function clearAnswer(questionId) {
        delete state.answers[questionId];
        persistState();
    }

    /**
     * Toggle mark for review
     */
    function toggleMark(questionId) {
        if (state.markedQuestions.has(questionId)) {
            state.markedQuestions.delete(questionId);
        } else {
            state.markedQuestions.add(questionId);
        }
        persistState();
        return state.markedQuestions.has(questionId);
    }

    /**
     * Check if question is marked
     */
    function isMarked(questionId) {
        return state.markedQuestions.has(questionId);
    }

    /**
     * Navigate to question
     */
    function goToQuestion(index) {
        if (index >= 0 && index < state.questions.length) {
            state.currentQuestionIndex = index;
            return state.questions[index];
        }
        return null;
    }

    /**
     * Get current question
     */
    function getCurrentQuestion() {
        return state.questions[state.currentQuestionIndex];
    }

    /**
     * Get question by ID
     */
    function getQuestionById(questionId) {
        return state.questions.find(q => q.question_id === questionId);
    }

    /**
     * Next question
     */
    function nextQuestion() {
        if (state.currentQuestionIndex < state.questions.length - 1) {
            state.currentQuestionIndex++;
            return getCurrentQuestion();
        }
        return null;
    }

    /**
     * Previous question
     */
    function prevQuestion() {
        if (state.currentQuestionIndex > 0) {
            state.currentQuestionIndex--;
            return getCurrentQuestion();
        }
        return null;
    }

    /**
     * Calculate progress
     */
    function getProgress() {
        const total = state.questions.length;
        const answered = Object.keys(state.answers).length;
        const marked = state.markedQuestions.size;

        return {
            total,
            answered,
            unanswered: total - answered,
            marked,
            percentage: total > 0 ? Math.round((answered / total) * 100) : 0
        };
    }

    /**
     * Calculate results after submission
     */
    function calculateResults() {
        let correct = 0;
        let incorrect = 0;
        let unattempted = 0;
        let totalMarks = 0;
        let obtainedMarks = 0;

        const details = state.questions.map(question => {
            // API format: question.id, Old JSON format: question.question_id
            const questionId = question.id || question.question_id;
            const userAnswer = state.answers[questionId];
            const marks = question.marks || 1;
            totalMarks += marks; // Always add to total marks (for all questions)

            let isCorrect = false;
            let correctAnswer = null;
            let marksAwarded = 0;

            // Check if question is answered
            const isAnswered = userAnswer !== undefined && userAnswer !== null && 
                              String(userAnswer).trim() !== '' && 
                              !(typeof userAnswer === 'object' && Object.keys(userAnswer).length === 0);

            // Handle different question types
            if (question.type === 'MCQ' || question.type === 'Assertion-Reason') {
                // Find correct answer - support multiple formats
                correctAnswer = question.solution?.answer?.correct_option;
                if (question.options) {
                    const correctOption = question.options.find(o => o.is_correct);
                    if (correctOption) {
                        // Support both API format (id) and old format (option_id)
                        correctAnswer = correctOption.id || correctOption.option_id || correctAnswer;
                    }
                }
                // Also check solution.answer format
                if (!correctAnswer && question.solution?.answer) {
                    if (typeof question.solution.answer === 'string') {
                        correctAnswer = question.solution.answer;
                    } else if (question.solution.answer.correct_option) {
                        correctAnswer = question.solution.answer.correct_option;
                    }
                }
                
                if (isAnswered) {
                    // Compare user answer with correct answer (support both formats)
                    const userAnswerStr = String(userAnswer).trim();
                    const correctAnswerStr = String(correctAnswer || '').trim();
                    isCorrect = userAnswerStr === correctAnswerStr && correctAnswerStr !== '';
                    
                    if (isCorrect) {
                        correct++;
                        obtainedMarks += marks;
                        marksAwarded = marks;
                    } else {
                        incorrect++;
                        marksAwarded = 0;
                    }
                } else {
                    unattempted++;
                    marksAwarded = 0;
                }
            } else {
                // For subjective questions (SA, VSA, LA, CaseStudy), we can't auto-grade
                // They will be graded by API if answered, otherwise 0 marks
                correctAnswer = question.solution?.answer || 'See solution';
                isCorrect = null; // Needs API grading
                
                if (isAnswered) {
                    // Will be graded by API, mark as pending
                    marksAwarded = null; // null means pending API grading
                } else {
                    unattempted++;
                    marksAwarded = 0; // No answer = 0 marks
                }
            }

            return {
                questionId,
                userAnswer: isAnswered ? userAnswer : null,
                correctAnswer,
                isCorrect,
                marks,
                marksAwarded,
                maxMarks: marks,
                questionType: question.type
            };
        });

        return {
            total: state.questions.length,
            correct,
            incorrect,
            unattempted,
            totalMarks,
            obtainedMarks,
            percentage: totalMarks > 0 ? Math.round((obtainedMarks / totalMarks) * 100) : 0,
            details
        };
    }

    /**
     * Submit the test
     */
    function submit() {
        state.isSubmitted = true;
        const results = calculateResults();

        // Clear saved state after submission
        clearSavedState();

        return results;
    }

    /**
     * Persist state to localStorage
     */
    function persistState() {
        if (!state.currentSet) return;

        const setId = state.currentSet.set_id || state.currentSet.batch_id;
        const key = config.storagePrefix + setId;

        const saveData = {
            answers: state.answers,
            markedQuestions: Array.from(state.markedQuestions),
            currentQuestionIndex: state.currentQuestionIndex,
            startTime: state.startTime,
            timestamp: Date.now()
        };

        try {
            localStorage.setItem(key, JSON.stringify(saveData));
        } catch (e) {
            console.warn('Could not save state to localStorage:', e);
        }
    }

    /**
     * Restore state from localStorage
     */
    function restoreState(setId) {
        const key = config.storagePrefix + setId;

        try {
            const saved = localStorage.getItem(key);
            if (saved) {
                const data = JSON.parse(saved);

                // Check if saved state is still valid (within 24 hours)
                if (Date.now() - data.timestamp < 24 * 60 * 60 * 1000) {
                    state.answers = data.answers || {};
                    state.markedQuestions = new Set(data.markedQuestions || []);
                    state.currentQuestionIndex = data.currentQuestionIndex || 0;
                    state.startTime = data.startTime;
                    return true;
                } else {
                    // Clear expired state
                    localStorage.removeItem(key);
                }
            }
        } catch (e) {
            console.warn('Could not restore state from localStorage:', e);
        }
        return false;
    }

    /**
     * Clear saved state
     */
    function clearSavedState() {
        if (!state.currentSet) return;

        const setId = state.currentSet.set_id || state.currentSet.batch_id;
        const key = config.storagePrefix + setId;

        try {
            localStorage.removeItem(key);
        } catch (e) {
            console.warn('Could not clear state from localStorage:', e);
        }
    }

    /**
     * Theme management
     */
    function loadTheme() {
        const theme = localStorage.getItem('exam-theme');
        if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
            document.documentElement.setAttribute('data-theme', 'dark');
        }
    }

    function toggleTheme() {
        const isDark = document.documentElement.getAttribute('data-theme') === 'dark';
        document.documentElement.setAttribute('data-theme', isDark ? 'light' : 'dark');
        localStorage.setItem('exam-theme', isDark ? 'light' : 'dark');
    }

    function setupThemeToggle() {
        document.addEventListener('click', function(e) {
            if (e.target.closest('.theme-toggle')) {
                toggleTheme();
            }
        });
    }

    /**
     * Format time for display
     */
    function formatTime(seconds) {
        const hours = Math.floor(seconds / 3600);
        const minutes = Math.floor((seconds % 3600) / 60);
        const secs = seconds % 60;

        if (hours > 0) {
            return `${hours}:${String(minutes).padStart(2, '0')}:${String(secs).padStart(2, '0')}`;
        }
        return `${minutes}:${String(secs).padStart(2, '0')}`;
    }

    /**
     * Escape HTML to prevent XSS
     */
    function escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    // Public API
    return {
        init,
        loadSet,
        loadSetData,
        getState,
        saveAnswer,
        getAnswer,
        clearAnswer,
        toggleMark,
        isMarked,
        goToQuestion,
        getCurrentQuestion,
        getQuestionById,
        nextQuestion,
        prevQuestion,
        getProgress,
        calculateResults,
        submit,
        toggleTheme,
        formatTime,
        escapeHtml
    };
})();

// Export for use as module
if (typeof module !== 'undefined' && module.exports) {
    module.exports = ExamCore;
}
