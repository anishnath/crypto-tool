/**
 * 8gwifi.org Tutorial Platform - Progress Tracking
 * LocalStorage-based progress management (no login required)
 */

(function() {
    'use strict';

    var STORAGE_KEY = '8gwifi_tutorial_progress';
    var SETTINGS_KEY = '8gwifi_tutorial_settings';

    // Lesson counts per tutorial
    var LESSON_COUNTS = {
        'html': 15,
        'css': 0,
        'javascript': 0,
        'python': 71
    };

    /**
     * TutorialProgress - Progress tracking API
     */
    window.TutorialProgress = {
        /**
         * Get all progress data
         */
        getAll: function() {
            try {
                var data = localStorage.getItem(STORAGE_KEY);
                return data ? JSON.parse(data) : {};
            } catch (e) {
                console.error('Error reading progress:', e);
                return {};
            }
        },

        /**
         * Save all progress data
         */
        saveAll: function(data) {
            try {
                localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
            } catch (e) {
                console.error('Error saving progress:', e);
            }
        },

        /**
         * Mark a lesson as completed
         */
        markComplete: function(tutorial, lessonId, quizScore) {
            var data = this.getAll();

            if (!data[tutorial]) {
                data[tutorial] = {};
            }

            data[tutorial][lessonId] = {
                completed: true,
                quizScore: quizScore || null,
                timestamp: Date.now()
            };

            this.saveAll(data);
        },

        /**
         * Check if a lesson is completed
         */
        isCompleted: function(tutorial, lessonId) {
            var data = this.getAll();
            return data[tutorial] && data[tutorial][lessonId] && data[tutorial][lessonId].completed;
        },

        /**
         * Get progress stats for a tutorial
         */
        getProgress: function(tutorial) {
            var data = this.getAll();
            var tutorialData = data[tutorial] || {};
            var completed = Object.values(tutorialData).filter(function(l) {
                return l && l.completed;
            }).length;

            return {
                completed: completed,
                total: LESSON_COUNTS[tutorial] || 0,
                percent: LESSON_COUNTS[tutorial] ? Math.round((completed / LESSON_COUNTS[tutorial]) * 100) : 0
            };
        },

        /**
         * Get list of completed lesson IDs
         */
        getCompletedLessons: function(tutorial) {
            var data = this.getAll();
            var tutorialData = data[tutorial] || {};

            return Object.keys(tutorialData).filter(function(lessonId) {
                return tutorialData[lessonId] && tutorialData[lessonId].completed;
            });
        },

        /**
         * Get quiz score for a lesson
         */
        getQuizScore: function(tutorial, lessonId) {
            var data = this.getAll();
            if (data[tutorial] && data[tutorial][lessonId]) {
                return data[tutorial][lessonId].quizScore;
            }
            return null;
        },

        /**
         * Reset progress for a tutorial
         */
        resetTutorial: function(tutorial) {
            var data = this.getAll();
            delete data[tutorial];
            this.saveAll(data);
        },

        /**
         * Reset all progress
         */
        resetAll: function() {
            localStorage.removeItem(STORAGE_KEY);
            localStorage.removeItem(SETTINGS_KEY);
        }
    };

    /**
     * TutorialSettings - User settings API
     */
    window.TutorialSettings = {
        /**
         * Get all settings
         */
        getAll: function() {
            try {
                var data = localStorage.getItem(SETTINGS_KEY);
                return data ? JSON.parse(data) : {};
            } catch (e) {
                console.error('Error reading settings:', e);
                return {};
            }
        },

        /**
         * Save all settings
         */
        saveAll: function(data) {
            try {
                localStorage.setItem(SETTINGS_KEY, JSON.stringify(data));
            } catch (e) {
                console.error('Error saving settings:', e);
            }
        },

        /**
         * Get a specific setting
         */
        get: function(key, defaultValue) {
            var settings = this.getAll();
            return settings.hasOwnProperty(key) ? settings[key] : defaultValue;
        },

        /**
         * Set a specific setting
         */
        set: function(key, value) {
            var settings = this.getAll();
            settings[key] = value;
            this.saveAll(settings);
        },

        /**
         * Set last visited lesson
         */
        setLastLesson: function(lessonPath) {
            this.set('lastLesson', lessonPath);
            this.set('lastVisit', Date.now());
        },

        /**
         * Get last visited lesson
         */
        getLastLesson: function() {
            return this.get('lastLesson', null);
        }
    };

    // Alias for convenience
    window.TutorialProgress.setLastLesson = function(lessonPath) {
        TutorialSettings.setLastLesson(lessonPath);
    };

})();
