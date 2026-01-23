/**
 * Quick Math Core Base
 * Defines the global QuickMath object and shared helpers.
 *
 * Topic definitions are split across:
 *  - quick-math-topics-addition.js
 *  - quick-math-topics-multiplication.js
 *  - quick-math-topics-other.js
 *
 * All topic files must be loaded after this base script.
 */

window.QuickMath = window.QuickMath || {
    /**
     * Registry of all quick math topics.
     * Topic files should attach their topic objects to this.
     */
    topics: {},

    /**
     * Get topic by ID
     */
    getTopic: function (id) {
        return this.topics[id] || null;
    },

    /**
     * Get all topics grouped by category
     */
    getTopicsByCategory: function () {
        const grouped = {};
        for (const key in this.topics) {
            const t = this.topics[key];
            if (!grouped[t.category]) grouped[t.category] = [];
            grouped[t.category].push(t);
        }
        return grouped;
    }
};


