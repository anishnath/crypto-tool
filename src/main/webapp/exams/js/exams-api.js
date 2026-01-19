/**
 * Exam Platform - API Module
 * Wraps CF Exam Marker servlet API calls
 */

const ExamAPI = (function() {
    'use strict';

    // API base URL - should be set from JSP page
    let API_BASE = window.EXAM_API_BASE || '/CFExamMarkerFunctionality';

    /**
     * Get API URL with action
     */
    function getApiUrl(action, params = {}) {
        const url = new URL(API_BASE, window.location.origin);
        url.searchParams.set('action', action);
        Object.keys(params).forEach(key => {
            if (params[key] !== null && params[key] !== undefined) {
                url.searchParams.set(key, params[key]);
            }
        });
        return url.toString();
    }

    /**
     * Make API request with timeout
     */
    async function apiRequest(url, options = {}) {
        const timeout = options.timeout || 10000; // 10 second default timeout
        
        try {
            // Create abort controller for timeout
            const controller = new AbortController();
            const timeoutId = setTimeout(() => controller.abort(), timeout);
            
            const response = await fetch(url, {
                ...options,
                signal: controller.signal,
                headers: {
                    'Content-Type': 'application/json',
                    ...options.headers
                }
            });
            
            clearTimeout(timeoutId);

            if (!response.ok) {
                const error = await response.json().catch(() => ({ message: 'Request failed' }));
                throw new Error(error.message || `HTTP ${response.status}`);
            }

            return await response.json();
        } catch (error) {
            if (error.name === 'AbortError') {
                console.error('API request timed out:', url);
                throw new Error('Request timed out. Please check your connection and try again.');
            }
            console.error('API request failed:', error, 'URL:', url);
            throw error;
        }
    }

    /**
     * Health check
     */
    async function healthCheck() {
        return apiRequest(getApiUrl('health'));
    }

    /**
     * List exam sets
     */
    async function listSets(filters = {}) {
        const params = {
            exam_type: filters.exam_type || 'CBSE',
            grade: filters.grade || '10',
            subject: filters.subject || 'mathematics',
            test_type: filters.test_type || null,
            chapter_id: filters.chapter_id || null,
            topic_id: filters.topic_id || null
        };
        return apiRequest(getApiUrl('sets', params));
    }

    /**
     * Get single exam set
     */
    async function getSet(setId) {
        return apiRequest(getApiUrl('set', { set_id: setId }));
    }

    /**
     * Get questions for a set
     */
    async function getQuestions(setId) {
        return apiRequest(getApiUrl('questions', { set_id: setId }));
    }

    /**
     * Start new test attempt
     */
    async function startAttempt(setId, userId = null) {
        const body = {
            set_id: setId
        };
        if (userId) {
            body.user_id = userId;
        }
        return apiRequest(getApiUrl('start_attempt'), {
            method: 'POST',
            body: JSON.stringify(body)
        });
    }

    /**
     * Get attempt details
     */
    async function getAttempt(attemptId) {
        return apiRequest(getApiUrl('attempt', { attempt_id: attemptId }));
    }

    /**
     * Save answers
     */
    async function saveAnswers(attemptId, answers) {
        // Filter out invalid question IDs (undefined, null, or empty string)
        const validAnswers = {};
        for (const [questionId, answer] of Object.entries(answers || {})) {
            if (questionId && questionId !== 'undefined' && questionId !== 'null' && questionId.trim() !== '') {
                validAnswers[questionId] = answer;
            } else {
                console.warn('Skipping answer with invalid questionId:', questionId);
            }
        }
        
        // Don't send empty answers object
        if (Object.keys(validAnswers).length === 0) {
            console.warn('No valid answers to save');
            return { success: true, message: 'No valid answers to save' };
        }
        
        return apiRequest(getApiUrl('save_answers', { attempt_id: attemptId }), {
            method: 'POST',
            body: JSON.stringify({ answers: validAnswers })
        });
    }

    /**
     * Submit attempt for grading
     */
    async function submitAttempt(attemptId) {
        return apiRequest(getApiUrl('submit', { attempt_id: attemptId }), {
            method: 'POST'
        });
    }

    /**
     * Get user's test history
     */
    async function getUserAttempts(userId, limit = 20, offset = 0) {
        return apiRequest(getApiUrl('user_attempts', {
            user_id: userId,
            limit: limit,
            offset: offset
        }));
    }

    /**
     * Upsert user (create or update on login)
     * @param {string} userId - User ID (Google sub)
     * @param {string} email - User email
     * @param {string} name - User name
     * @param {string} authProvider - Auth provider (google, email, etc.)
     */
    async function upsertUser(userId, email, name, authProvider = 'google') {
        return apiRequest(getApiUrl('upsert_user'), {
            method: 'POST',
            body: JSON.stringify({
                user_id: userId,
                email: email,
                name: name,
                auth_provider: authProvider
            })
        });
    }

    /**
     * Mark full exam (for subjective questions only)
     * @param {string} attemptId - The attempt ID to save evaluations to (optional)
     * @param {object} answers - Map of question_id to answer
     * @param {array} questions - Array of question objects
     */
    async function markExam(attemptId, answers, questions) {
        const payload = {
            answers: answers,
            questions: questions
        };
        // Include attempt_id if provided - this will save evaluations to DB
        if (attemptId) {
            payload.attempt_id = attemptId;
        }
        return apiRequest(getApiUrl('mark_exam'), {
            method: 'POST',
            body: JSON.stringify(payload),
            timeout: 60000 // 60 second timeout for AI grading
        });
    }

    /**
     * Mark batch (up to 10 subjective questions)
     */
    async function markBatch(questions) {
        return apiRequest(getApiUrl('mark_batch'), {
            method: 'POST',
            body: JSON.stringify({ questions: questions })
        });
    }

    /**
     * List chapters
     */
    async function listChapters(filters = {}) {
        const params = {
            exam_type: filters.exam_type || 'CBSE',
            grade: filters.grade || '10',
            subject: filters.subject || 'mathematics'
        };
        return apiRequest(getApiUrl('chapters', params));
    }

    /**
     * List topics for a chapter
     */
    async function listTopics(chapterId) {
        return apiRequest(getApiUrl('topics', { chapter_id: chapterId }));
    }

    /**
     * Set API base URL (called from JSP)
     */
    function setApiBase(baseUrl) {
        API_BASE = baseUrl;
    }

    // Public API
    return {
        setApiBase,
        healthCheck,
        listSets,
        getSet,
        getQuestions,
        startAttempt,
        getAttempt,
        saveAnswers,
        submitAttempt,
        getUserAttempts,
        upsertUser,
        listChapters,
        listTopics,
        markExam,
        markBatch
    };
})();

// Export for use as module
if (typeof module !== 'undefined' && module.exports) {
    module.exports = ExamAPI;
}

