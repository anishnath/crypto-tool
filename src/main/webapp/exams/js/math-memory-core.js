/**
 * Math Memory Games - Core Module
 * Shared functionality for all memory games
 */

window.MathMemory = window.MathMemory || {};

// ============================================
// CONFIGURATION
// ============================================
MathMemory.config = {
    difficulties: {
        easy: { label: 'Easy', color: '#22c55e', pairs: 6, timeBonus: 1.0 },
        medium: { label: 'Medium', color: '#facc15', pairs: 8, timeBonus: 1.5 },
        hard: { label: 'Hard', color: '#f97316', pairs: 12, timeBonus: 2.0 }
    },
    sounds: {
        enabled: true,
        flip: null,
        match: null,
        wrong: null,
        win: null
    }
};

// ============================================
// STORAGE - High Scores & Settings
// ============================================
MathMemory.storage = {
    prefix: 'math_memory_',

    get: function(key, defaultVal) {
        try {
            const val = localStorage.getItem(this.prefix + key);
            return val !== null ? JSON.parse(val) : defaultVal;
        } catch (e) {
            return defaultVal;
        }
    },

    set: function(key, value) {
        try {
            localStorage.setItem(this.prefix + key, JSON.stringify(value));
        } catch (e) {
            console.warn('Storage not available');
        }
    },

    getHighScore: function(game, difficulty) {
        const scores = this.get('highscores', {});
        return scores[game + '_' + difficulty] || 0;
    },

    setHighScore: function(game, difficulty, score) {
        const scores = this.get('highscores', {});
        const key = game + '_' + difficulty;
        if (score > (scores[key] || 0)) {
            scores[key] = score;
            this.set('highscores', scores);
            return true; // New high score!
        }
        return false;
    },

    getStats: function(game) {
        return this.get('stats_' + game, {
            gamesPlayed: 0,
            totalScore: 0,
            bestStreak: 0
        });
    },

    updateStats: function(game, score, streak) {
        const stats = this.getStats(game);
        stats.gamesPlayed++;
        stats.totalScore += score;
        if (streak > stats.bestStreak) stats.bestStreak = streak;
        this.set('stats_' + game, stats);
    }
};

// ============================================
// MATH PROBLEM GENERATORS
// ============================================
MathMemory.problems = {
    // Addition problems
    addition: function(difficulty) {
        let max = difficulty === 'easy' ? 20 : difficulty === 'medium' ? 50 : 100;
        const a = Math.floor(Math.random() * max) + 1;
        const b = Math.floor(Math.random() * max) + 1;
        return { text: a + ' + ' + b, answer: a + b };
    },

    // Subtraction problems
    subtraction: function(difficulty) {
        let max = difficulty === 'easy' ? 20 : difficulty === 'medium' ? 50 : 100;
        let a = Math.floor(Math.random() * max) + 10;
        let b = Math.floor(Math.random() * a);
        return { text: a + ' - ' + b, answer: a - b };
    },

    // Multiplication problems
    multiplication: function(difficulty) {
        let max = difficulty === 'easy' ? 10 : difficulty === 'medium' ? 12 : 15;
        const a = Math.floor(Math.random() * max) + 2;
        const b = Math.floor(Math.random() * max) + 2;
        return { text: a + ' × ' + b, answer: a * b };
    },

    // Division problems (clean results)
    division: function(difficulty) {
        let max = difficulty === 'easy' ? 10 : difficulty === 'medium' ? 12 : 15;
        const b = Math.floor(Math.random() * max) + 2;
        const answer = Math.floor(Math.random() * max) + 1;
        const a = b * answer;
        return { text: a + ' ÷ ' + b, answer: answer };
    },

    // Squares
    squares: function(difficulty) {
        let max = difficulty === 'easy' ? 10 : difficulty === 'medium' ? 15 : 20;
        const n = Math.floor(Math.random() * max) + 2;
        return { text: n + '²', answer: n * n };
    },

    // Percentage (easy ones)
    percentage: function(difficulty) {
        const percents = difficulty === 'easy' ? [10, 25, 50] : [10, 20, 25, 50, 75];
        const p = percents[Math.floor(Math.random() * percents.length)];
        const bases = [20, 40, 50, 80, 100, 200];
        const base = bases[Math.floor(Math.random() * bases.length)];
        return { text: p + '% of ' + base, answer: (p / 100) * base };
    },

    // Get random problem based on difficulty
    getRandom: function(difficulty, types) {
        types = types || ['addition', 'subtraction', 'multiplication'];
        const type = types[Math.floor(Math.random() * types.length)];
        return this[type](difficulty);
    },

    // Generate unique problem-answer pairs
    generatePairs: function(count, difficulty, types) {
        const pairs = [];
        const usedAnswers = new Set();

        while (pairs.length < count) {
            const problem = this.getRandom(difficulty, types);
            // Ensure unique answers to avoid confusion
            if (!usedAnswers.has(problem.answer)) {
                usedAnswers.add(problem.answer);
                pairs.push(problem);
            }
        }
        return pairs;
    }
};

// ============================================
// SEQUENCE GENERATORS
// ============================================
MathMemory.sequences = {
    // Arithmetic sequence (constant difference)
    arithmetic: function(length, difficulty) {
        const start = Math.floor(Math.random() * 20) + 1;
        const diff = difficulty === 'easy' ?
            [2, 3, 5, 10][Math.floor(Math.random() * 4)] :
            Math.floor(Math.random() * 10) + 2;
        const seq = [];
        for (let i = 0; i < length; i++) {
            seq.push(start + i * diff);
        }
        return { sequence: seq, next: start + length * diff, rule: '+' + diff };
    },

    // Geometric sequence (constant ratio)
    geometric: function(length, difficulty) {
        const start = Math.floor(Math.random() * 5) + 1;
        const ratio = difficulty === 'easy' ? 2 : [2, 3][Math.floor(Math.random() * 2)];
        const seq = [];
        let val = start;
        for (let i = 0; i < length; i++) {
            seq.push(val);
            val *= ratio;
        }
        return { sequence: seq, next: val, rule: '×' + ratio };
    },

    // Square numbers
    squares: function(length) {
        const start = Math.floor(Math.random() * 5) + 1;
        const seq = [];
        for (let i = 0; i < length; i++) {
            seq.push((start + i) * (start + i));
        }
        return { sequence: seq, next: (start + length) * (start + length), rule: 'n²' };
    },

    // Fibonacci-like
    fibonacci: function(length) {
        const a = Math.floor(Math.random() * 5) + 1;
        const b = Math.floor(Math.random() * 5) + 1;
        const seq = [a, b];
        for (let i = 2; i < length; i++) {
            seq.push(seq[i-1] + seq[i-2]);
        }
        return { sequence: seq, next: seq[length-1] + seq[length-2], rule: 'Fib' };
    },

    getRandom: function(length, difficulty) {
        const types = difficulty === 'easy' ?
            ['arithmetic'] :
            ['arithmetic', 'geometric', 'squares'];
        const type = types[Math.floor(Math.random() * types.length)];
        return this[type](length, difficulty);
    }
};

// ============================================
// UI HELPERS
// ============================================
MathMemory.ui = {
    // Format time as MM:SS
    formatTime: function(seconds) {
        const mins = Math.floor(seconds / 60);
        const secs = seconds % 60;
        return mins + ':' + (secs < 10 ? '0' : '') + secs;
    },

    // Calculate score based on time, moves, difficulty
    calculateScore: function(basePoints, timeSeconds, difficulty, bonusMoves) {
        const timeBonus = Math.max(0, 300 - timeSeconds) * 2;
        const diffMultiplier = MathMemory.config.difficulties[difficulty].timeBonus;
        const moveBonus = (bonusMoves || 0) * 10;
        return Math.round((basePoints + timeBonus + moveBonus) * diffMultiplier);
    },

    // Shuffle array (Fisher-Yates)
    shuffle: function(array) {
        const arr = [...array];
        for (let i = arr.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [arr[i], arr[j]] = [arr[j], arr[i]];
        }
        return arr;
    },

    // Show toast notification
    showToast: function(message, type) {
        const toast = document.getElementById('gameToast');
        if (!toast) return;
        toast.textContent = message;
        toast.className = 'game-toast active ' + (type || 'success');
        setTimeout(function() {
            toast.classList.remove('active');
        }, 3000);
    },

    // Trigger confetti effect
    confetti: function() {
        // Simple CSS confetti - can be enhanced
        const container = document.createElement('div');
        container.className = 'confetti-container';
        document.body.appendChild(container);

        for (let i = 0; i < 50; i++) {
            const confetti = document.createElement('div');
            confetti.className = 'confetti-piece';
            confetti.style.left = Math.random() * 100 + '%';
            confetti.style.animationDelay = Math.random() * 2 + 's';
            confetti.style.backgroundColor = ['#a855f7', '#22d3ee', '#ec4899', '#22c55e', '#facc15'][Math.floor(Math.random() * 5)];
            container.appendChild(confetti);
        }

        setTimeout(function() {
            container.remove();
        }, 4000);
    }
};

// ============================================
// SOUND EFFECTS (Optional)
// ============================================
MathMemory.sounds = {
    enabled: true,

    init: function() {
        // Could load sound files here if needed
    },

    play: function(name) {
        if (!this.enabled) return;
        // Placeholder for sound implementation
        // Could use Web Audio API or audio elements
    },

    toggle: function() {
        this.enabled = !this.enabled;
        MathMemory.storage.set('soundEnabled', this.enabled);
        return this.enabled;
    }
};

// ============================================
// TIMER UTILITIES
// ============================================
MathMemory.timer = {
    instance: null,
    seconds: 0,
    callback: null,

    start: function(displayEl, callback) {
        this.stop();
        this.seconds = 0;
        this.callback = callback;
        var self = this;

        this.instance = setInterval(function() {
            self.seconds++;
            if (displayEl) {
                displayEl.textContent = MathMemory.ui.formatTime(self.seconds);
            }
            if (self.callback) {
                self.callback(self.seconds);
            }
        }, 1000);
    },

    stop: function() {
        if (this.instance) {
            clearInterval(this.instance);
            this.instance = null;
        }
    },

    reset: function() {
        this.stop();
        this.seconds = 0;
    },

    getSeconds: function() {
        return this.seconds;
    }
};

// ============================================
// COUNTDOWN TIMER (for timed phases)
// ============================================
MathMemory.countdown = {
    instance: null,

    start: function(durationMs, timerBarEl, onComplete) {
        this.stop();
        var self = this;

        if (timerBarEl) {
            timerBarEl.style.transition = 'none';
            timerBarEl.style.width = '100%';
            timerBarEl.offsetHeight; // Force reflow
            timerBarEl.style.transition = 'width ' + durationMs + 'ms linear';
            setTimeout(function() {
                timerBarEl.style.width = '0%';
            }, 50);
        }

        this.instance = setTimeout(function() {
            if (onComplete) onComplete();
        }, durationMs);
    },

    stop: function() {
        if (this.instance) {
            clearTimeout(this.instance);
            this.instance = null;
        }
    }
};

// ============================================
// SHARE FUNCTIONALITY
// ============================================
MathMemory.share = {
    baseUrl: 'https://8gwifi.org/exams/math-memory/',

    // Game-specific taglines
    taglines: {
        'match': 'Match problems to answers!',
        'sequence': 'Crack the pattern!',
        'flash': 'Lightning-fast mental math!',
        'grid': 'Test your spatial memory!',
        'speed-round': 'Solve & recall under pressure!',
        'binary-blitz': 'Master binary patterns!',
        'color-code': 'Decode the colors!',
        'spin-logic': 'Mental rotation challenge!',
        'hidden-order': 'Remember the sequence!',
        'path-finder': 'Navigate from memory!',
        'matrix-memory': 'Matrix pattern mastery!',
        'symbol-sums': 'Symbolic arithmetic!',
        'equation-echo': 'Echo the equations!',
        'mental-trail': 'Follow the mental path!',
        'recall': 'Pure number recall!',
        'shape-count': 'Count & remember shapes!'
    },

    // Generate standardized share text
    // extras can include: time, streak, correct, total, level, solved, recalled, custom
    generateText: function(gameKey, gameName, score, difficulty, extras) {
        extras = extras || {};
        var lines = [];

        // Header with game name and difficulty
        lines.push(gameName + ' [' + (difficulty || 'Normal').toUpperCase() + ']');
        lines.push('');

        // Score line
        lines.push('Score: ' + score + ' pts');

        // Time line (if provided)
        if (extras.time !== undefined) {
            lines.push('Time: ' + MathMemory.ui.formatTime(extras.time));
        }

        // Game-specific stats
        if (extras.correct !== undefined && extras.total !== undefined) {
            lines.push('Correct: ' + extras.correct + '/' + extras.total);
        }
        if (extras.level !== undefined) {
            lines.push('Level: ' + extras.level);
        }
        if (extras.streak !== undefined) {
            lines.push('Best Streak: ' + extras.streak);
        }
        if (extras.solved !== undefined) {
            lines.push('Solved: ' + extras.solved);
        }
        if (extras.recalled !== undefined) {
            lines.push('Recalled: ' + extras.recalled);
        }
        if (extras.moves !== undefined) {
            lines.push('Moves: ' + extras.moves);
        }
        if (extras.rounds !== undefined) {
            lines.push('Rounds: ' + extras.rounds);
        }
        // Custom stats line
        if (extras.custom) {
            lines.push(extras.custom);
        }

        lines.push('');

        // Call to action
        var tagline = this.taglines[gameKey] || 'Can you beat my score?';
        lines.push(tagline);
        lines.push('Play: ' + this.baseUrl + gameKey + '.jsp');

        return lines.join('\n');
    },

    // Share via Web Share API or Twitter fallback
    share: function(gameKey, gameName, score, difficulty, extras) {
        var text = this.generateText(gameKey, gameName, score, difficulty, extras);
        var url = this.baseUrl + gameKey + '.jsp';

        if (navigator.share) {
            navigator.share({
                title: gameName + ' - Math Memory Games',
                text: text,
                url: url
            }).catch(function(err) {
                console.log('Share cancelled', err);
            });
        } else {
            // Twitter fallback
            var twitterUrl = 'https://twitter.com/intent/tweet?text=' + encodeURIComponent(text);
            window.open(twitterUrl, '_blank', 'width=550,height=420');
        }
    },

    // Copy score to clipboard
    copyToClipboard: function(gameKey, gameName, score, difficulty, extras) {
        var text = this.generateText(gameKey, gameName, score, difficulty, extras);
        var self = this;

        if (navigator.clipboard) {
            navigator.clipboard.writeText(text).then(function() {
                MathMemory.ui.showToast('Score copied to clipboard!', 'success');
            }).catch(function() {
                self.fallbackCopy(text);
            });
        } else {
            this.fallbackCopy(text);
        }
    },

    fallbackCopy: function(text) {
        var textarea = document.createElement('textarea');
        textarea.value = text;
        textarea.style.position = 'fixed';
        textarea.style.opacity = '0';
        document.body.appendChild(textarea);
        textarea.select();
        try {
            document.execCommand('copy');
            MathMemory.ui.showToast('Score copied to clipboard!', 'success');
        } catch (e) {
            MathMemory.ui.showToast('Could not copy score', 'error');
        }
        document.body.removeChild(textarea);
    }
};

// ============================================
// AD CONFIGURATION
// ============================================
MathMemory.ads = {
    // Default ad slots - can be overridden per game
    slots: {
        leaderboard: '/21849154601,23072437879/8gwifi_728x90_Leaderboard',
        anchor: '/21849154601,23072437879/8gwifi_Anchor'
    },

    // Per-game ad configuration
    games: {
        'match': { enabled: true, showInterstitial: false },
        'sequence': { enabled: true, showInterstitial: false },
        'flash': { enabled: true, showInterstitial: false },
        'grid': { enabled: true, showInterstitial: false },
        'speed-round': { enabled: true, showInterstitial: false },
        'binary-blitz': { enabled: true, showInterstitial: false },
        'color-code': { enabled: true, showInterstitial: false },
        'equation-echo': { enabled: true, showInterstitial: false },
        'hidden-order': { enabled: true, showInterstitial: false },
        'matrix-memory': { enabled: true, showInterstitial: false },
        'mental-trail': { enabled: true, showInterstitial: false },
        'path-finder': { enabled: true, showInterstitial: false },
        'recall': { enabled: true, showInterstitial: false },
        'shape-count': { enabled: true, showInterstitial: false },
        'spin-logic': { enabled: true, showInterstitial: false },
        'symbol-sums': { enabled: true, showInterstitial: false }
    },

    // Check if ads are enabled for a game
    isEnabled: function(gameKey) {
        return this.games[gameKey] ? this.games[gameKey].enabled : true;
    },

    // Refresh ads (call after game completes)
    refresh: function() {
        if (typeof googletag !== 'undefined' && googletag.pubads) {
            googletag.pubads().refresh();
        }
    }
};

// ============================================
// GAME UTILITIES
// ============================================
MathMemory.game = {
    // Standard game configuration template
    createConfig: function(options) {
        return {
            gameKey: options.gameKey || 'unknown',
            gameName: options.gameName || 'Unknown Game',
            maxRounds: options.maxRounds || 10,
            difficulties: {
                easy: Object.assign({ points: 100 }, options.easy || {}),
                medium: Object.assign({ points: 150 }, options.medium || {}),
                hard: Object.assign({ points: 200 }, options.hard || {})
            }
        };
    },

    // Initialize common game elements
    initCommon: function(config) {
        var self = this;
        var state = {
            difficulty: 'easy',
            round: 1,
            score: 0,
            streak: 0,
            highScore: 0
        };

        // Load high score
        state.highScore = MathMemory.storage.getHighScore(config.gameKey, state.difficulty);

        return state;
    },

    // Update stats display
    updateStatsDisplay: function(state, config) {
        var scoreEl = document.getElementById('scoreDisplay');
        var roundEl = document.getElementById('roundDisplay');
        var streakEl = document.getElementById('streakDisplay');
        var highScoreEl = document.getElementById('highScore');

        if (scoreEl) scoreEl.textContent = state.score;
        if (roundEl) roundEl.textContent = state.round + '/' + config.maxRounds;
        if (streakEl) streakEl.textContent = state.streak;
        if (highScoreEl) highScoreEl.textContent = state.highScore > 0 ? state.highScore : '-';
    },

    // Calculate points with streak bonus
    calculatePoints: function(basePoints, streak, timeBonus) {
        timeBonus = timeBonus || 0;
        return basePoints + (streak * 10) + timeBonus;
    },

    // Handle correct answer
    onCorrect: function(state, config, message) {
        state.streak++;
        var points = this.calculatePoints(config.difficulties[state.difficulty].points, state.streak);
        state.score += points;
        MathMemory.ui.showToast(message || ('Correct! +' + points), 'success');
        return points;
    },

    // Handle wrong answer
    onWrong: function(state, message) {
        state.streak = 0;
        MathMemory.ui.showToast(message || 'Wrong!', 'error');
    },

    // End game
    endGame: function(state, config) {
        // Stop any timers
        MathMemory.timer.stop();
        MathMemory.countdown.stop();

        // Save high score
        var isNewRecord = MathMemory.storage.setHighScore(config.gameKey, state.difficulty, state.score);
        if (isNewRecord) {
            state.highScore = state.score;
        }

        // Update stats
        MathMemory.storage.updateStats(config.gameKey, state.score, state.streak);

        // Refresh ads
        MathMemory.ads.refresh();

        return isNewRecord;
    }
};

// ============================================
// HTML TEMPLATE GENERATORS
// ============================================
MathMemory.templates = {
    // Generate stats bar HTML
    statsBar: function(showMoves) {
        var html = '<div class="stats-bar">';

        if (showMoves) {
            html += '<div class="stat-item"><div class="stat-value" id="movesCount">0</div><div class="stat-label">Moves</div></div>';
        }

        html += '<div class="stat-item"><div class="stat-value" id="scoreDisplay">0</div><div class="stat-label">Score</div></div>';
        html += '<div class="stat-item"><div class="stat-value" id="roundDisplay">1/10</div><div class="stat-label">Round</div></div>';
        html += '<div class="stat-item"><div class="stat-value" id="streakDisplay">0</div><div class="stat-label">Streak</div></div>';
        html += '<div class="stat-item"><div class="stat-value" id="highScore">-</div><div class="stat-label">Best</div></div>';
        html += '</div>';

        return html;
    },

    // Generate difficulty selector HTML
    difficultySelector: function(easyLabel, mediumLabel, hardLabel) {
        return '<div class="difficulty-selector">' +
            '<button class="diff-btn active" data-difficulty="easy">' + (easyLabel || 'Easy') + '</button>' +
            '<button class="diff-btn" data-difficulty="medium">' + (mediumLabel || 'Medium') + '</button>' +
            '<button class="diff-btn" data-difficulty="hard">' + (hardLabel || 'Hard') + '</button>' +
            '</div>';
    },

    // Generate win modal HTML
    winModal: function(config) {
        config = config || {};
        var icon = config.icon || '&#127942;';
        var title = config.title || 'You Win!';
        var subtitle = config.subtitle || 'Great job!';

        return '<div class="win-modal" id="winModal">' +
            '<div class="win-content">' +
            '<div class="win-icon">' + icon + '</div>' +
            '<h2 class="win-title">' + title + '</h2>' +
            '<p class="win-subtitle">' + subtitle + '</p>' +
            '<div id="newRecordText" class="new-record" style="display:none;">&#11088; New High Score!</div>' +
            '<div class="win-stats">' +
            '<div class="win-stat"><div class="win-stat-value" id="finalScore">0</div><div class="win-stat-label">Score</div></div>' +
            '<div class="win-stat"><div class="win-stat-value" id="finalStreak">0</div><div class="win-stat-label">Best Streak</div></div>' +
            '</div>' +
            '<div class="win-actions">' +
            '<button class="game-btn primary" id="playAgainBtn">Play Again</button>' +
            '<button class="game-btn" id="shareBtn">Share</button>' +
            '</div>' +
            '</div>' +
            '</div>';
    },

    // Generate intro view HTML
    introView: function(config) {
        config = config || {};
        return '<div class="state-message" id="introView">' +
            '<div class="state-title">' + (config.title || 'Ready?') + '</div>' +
            '<p class="state-desc">' + (config.description || 'Press start to begin.') + '</p>' +
            '<button class="action-btn" id="startBtn">' + (config.buttonText || 'Start Game') + '</button>' +
            '</div>';
    },

    // Generate back link HTML
    backLink: function(contextPath) {
        return '<a href="' + contextPath + '/exams/math-memory/" class="game-back">' +
            '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">' +
            '<path d="M19 12H5M12 19l-7-7 7-7"/>' +
            '</svg>' +
            'Back' +
            '</a>';
    }
};

// ============================================
// INITIALIZATION
// ============================================
MathMemory.init = function() {
    // Load sound preference
    MathMemory.sounds.enabled = MathMemory.storage.get('soundEnabled', true);
    console.log('MathMemory Core v2.0 initialized');
};

// Auto-init when DOM ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', MathMemory.init);
} else {
    MathMemory.init();
}
