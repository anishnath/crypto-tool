// Ear Training - Interval recognition practice
// Uses Tone.js for audio playback

// Intervals configuration
const allIntervals = [
    { name: 'Minor 2nd', semitones: 1, example: 'Jaws theme' },
    { name: 'Major 2nd', semitones: 2, example: 'Happy Birthday' },
    { name: 'Minor 3rd', semitones: 3, example: 'Greensleeves' },
    { name: 'Major 3rd', semitones: 4, example: 'When the Saints' },
    { name: 'Perfect 4th', semitones: 5, example: 'Here Comes the Bride' },
    { name: 'Tritone', semitones: 6, example: 'The Simpsons' },
    { name: 'Perfect 5th', semitones: 7, example: 'Star Wars' },
    { name: 'Minor 6th', semitones: 8, example: 'The Entertainer' },
    { name: 'Major 6th', semitones: 9, example: 'My Bonnie' },
    { name: 'Minor 7th', semitones: 10, example: 'Star Trek' },
    { name: 'Major 7th', semitones: 11, example: 'Take On Me' },
    { name: 'Octave', semitones: 12, example: 'Somewhere Over the Rainbow' }
];

// Difficulty levels
const difficultyLevels = {
    beginner: [2, 4, 5, 7, 12], // Major 2nd, Major 3rd, Perfect 4th, Perfect 5th, Octave
    intermediate: [1, 2, 3, 4, 5, 7, 12], // Add Minor 2nd, Minor 3rd
    advanced: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12] // All intervals
};

// State
let synth = null;
let currentInterval = null;
let score = 0;
let streak = 0;
let bestStreak = 0;
let totalAttempts = 0;
let correctAttempts = 0;
let hasAnswered = false;
let currentDifficulty = 'beginner';
let direction = 'ascending'; // ascending, descending, random
let autoAdvance = true;
let intervals = []; // Active intervals based on difficulty

// DOM Elements
const playBtn = document.getElementById('playBtn');
const replayBtn = document.getElementById('replayBtn');
const nextBtn = document.getElementById('nextBtn');
const answerGrid = document.getElementById('answerGrid');
const feedbackMessage = document.getElementById('feedbackMessage');
const scoreValue = document.getElementById('scoreValue');
const streakValue = document.getElementById('streakValue');
const accuracyValue = document.getElementById('accuracyValue');
const difficultySelect = document.getElementById('difficultySelect');
const directionSelect = document.getElementById('directionSelect');
const autoAdvanceCheckbox = document.getElementById('autoAdvanceCheckbox');
const resetBtn = document.getElementById('resetBtn');

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    loadProgress();
    initAudio();
    updateIntervalsForDifficulty();
    renderAnswerButtons();
    generateNewInterval();
    setupEventListeners();
});

function initAudio() {
    synth = new Tone.Synth({
        oscillator: { type: 'triangle' },
        envelope: {
            attack: 0.005,
            decay: 0.1,
            sustain: 0.3,
            release: 1
        }
    }).toDestination();
}

function setupEventListeners() {
    playBtn.addEventListener('click', playCurrentInterval);

    if (replayBtn) {
        replayBtn.addEventListener('click', playCurrentInterval);
    }

    if (nextBtn) {
        nextBtn.addEventListener('click', () => {
            generateNewInterval();
            playCurrentInterval();
        });
    }

    if (difficultySelect) {
        difficultySelect.addEventListener('change', (e) => {
            currentDifficulty = e.target.value;
            updateIntervalsForDifficulty();
            renderAnswerButtons();
            generateNewInterval();
            saveProgress();
        });
    }

    if (directionSelect) {
        directionSelect.addEventListener('change', (e) => {
            direction = e.target.value;
            saveProgress();
        });
    }

    if (autoAdvanceCheckbox) {
        autoAdvanceCheckbox.addEventListener('change', (e) => {
            autoAdvance = e.target.checked;
            saveProgress();
        });
    }

    if (resetBtn) {
        resetBtn.addEventListener('click', resetProgress);
    }

    // Keyboard shortcuts
    document.addEventListener('keydown', handleKeyPress);
}

function handleKeyPress(e) {
    // Don't trigger if typing in an input
    if (e.target.tagName === 'INPUT' || e.target.tagName === 'SELECT') return;

    // Space or P to play/replay
    if (e.code === 'Space' || e.key === 'p' || e.key === 'P') {
        e.preventDefault();
        playCurrentInterval();
    }

    // N or Enter for next (if answered)
    if ((e.key === 'n' || e.key === 'N' || e.code === 'Enter') && hasAnswered) {
        e.preventDefault();
        generateNewInterval();
        playCurrentInterval();
    }

    // Number keys 1-9 and 0 for quick answers
    if (!hasAnswered && e.key >= '1' && e.key <= '9') {
        const index = parseInt(e.key) - 1;
        if (index < intervals.length) {
            checkAnswer(intervals[index].semitones);
        }
    }
    if (!hasAnswered && e.key === '0' && intervals.length >= 10) {
        checkAnswer(intervals[9].semitones);
    }
}

function updateIntervalsForDifficulty() {
    const allowedSemitones = difficultyLevels[currentDifficulty];
    intervals = allIntervals.filter(i => allowedSemitones.includes(i.semitones));
}

function renderAnswerButtons() {
    answerGrid.innerHTML = '';

    intervals.forEach((interval, index) => {
        const btn = document.createElement('button');
        btn.className = 'answer-btn';
        // Show keyboard shortcut number (1-9, 0 for 10th)
        const shortcutKey = index < 9 ? (index + 1) : (index === 9 ? '0' : '');
        btn.innerHTML = `<span class="answer-key">${shortcutKey}</span> ${interval.name}`;
        btn.dataset.semitones = interval.semitones;
        btn.addEventListener('click', () => checkAnswer(interval.semitones));
        answerGrid.appendChild(btn);
    });
}

function generateNewInterval() {
    // Random interval from current difficulty
    currentInterval = intervals[Math.floor(Math.random() * intervals.length)];
    hasAnswered = false;
    feedbackMessage.textContent = '';
    feedbackMessage.className = 'feedback-message';

    // Hide replay and next buttons
    if (replayBtn) replayBtn.style.display = 'none';
    if (nextBtn) nextBtn.style.display = 'none';

    // Reset button states
    document.querySelectorAll('.answer-btn').forEach(btn => {
        btn.classList.remove('correct', 'incorrect');
        btn.disabled = false;
    });
}

async function playCurrentInterval() {
    if (!synth || !currentInterval) return;

    await Tone.start();

    const baseNote = 'C4';
    const baseFreq = Tone.Frequency(baseNote).toFrequency();
    const semitone = Math.pow(2, 1 / 12);
    const secondFreq = baseFreq * Math.pow(semitone, currentInterval.semitones);

    // Determine direction for this play
    let playDirection = direction;
    if (direction === 'random') {
        playDirection = Math.random() > 0.5 ? 'ascending' : 'descending';
    }

    // Update button text
    playBtn.textContent = '🔊 Playing...';
    playBtn.disabled = true;

    if (playDirection === 'ascending') {
        // Play first note (lower)
        synth.triggerAttackRelease(baseNote, '0.5');
        // Play second note (higher) after delay
        setTimeout(() => {
            synth.triggerAttackRelease(secondFreq, '0.5');
            resetPlayButton();
        }, 600);
    } else {
        // Play first note (higher)
        synth.triggerAttackRelease(secondFreq, '0.5');
        // Play second note (lower) after delay
        setTimeout(() => {
            synth.triggerAttackRelease(baseNote, '0.5');
            resetPlayButton();
        }, 600);
    }
}

function resetPlayButton() {
    setTimeout(() => {
        playBtn.textContent = '🔊 Play Interval';
        playBtn.disabled = false;
    }, 500);
}

function checkAnswer(selectedSemitones) {
    if (hasAnswered) return;

    hasAnswered = true;
    totalAttempts++;

    const isCorrect = selectedSemitones === currentInterval.semitones;

    // Update score
    if (isCorrect) {
        correctAttempts++;
        score += 10 + (streak * 2); // Bonus for streaks
        streak++;
        if (streak > bestStreak) {
            bestStreak = streak;
        }

        feedbackMessage.textContent = `✓ Correct! ${currentInterval.name} (${currentInterval.example})`;
        feedbackMessage.className = 'feedback-message correct';

        // Highlight correct answer
        document.querySelector(`[data-semitones="${selectedSemitones}"]`).classList.add('correct');
    } else {
        streak = 0;

        feedbackMessage.textContent = `✗ Incorrect. That was ${currentInterval.name} (${currentInterval.example})`;
        feedbackMessage.className = 'feedback-message incorrect';

        // Highlight incorrect and correct answers
        document.querySelector(`[data-semitones="${selectedSemitones}"]`).classList.add('incorrect');
        document.querySelector(`[data-semitones="${currentInterval.semitones}"]`).classList.add('correct');
    }

    // Update stats
    updateStats();
    saveProgress();

    // Disable all buttons
    document.querySelectorAll('.answer-btn').forEach(btn => {
        btn.disabled = true;
    });

    // Show replay and next buttons
    if (replayBtn) replayBtn.style.display = 'inline-flex';
    if (nextBtn) nextBtn.style.display = 'inline-flex';

    // Auto-advance if enabled
    if (autoAdvance) {
        setTimeout(() => {
            if (hasAnswered) { // Check if user hasn't manually advanced
                generateNewInterval();
                playCurrentInterval();
            }
        }, 2500);
    }
}

function updateStats() {
    scoreValue.textContent = score;
    streakValue.textContent = streak;

    const accuracy = totalAttempts > 0
        ? Math.round((correctAttempts / totalAttempts) * 100)
        : 0;
    accuracyValue.textContent = `${accuracy}%`;

    // Update best streak if displayed
    const bestStreakEl = document.getElementById('bestStreakValue');
    if (bestStreakEl) {
        bestStreakEl.textContent = bestStreak;
    }
}

function saveProgress() {
    const data = {
        score,
        streak,
        bestStreak,
        totalAttempts,
        correctAttempts,
        currentDifficulty,
        direction,
        autoAdvance
    };
    localStorage.setItem('earTrainingProgress', JSON.stringify(data));
}

function loadProgress() {
    const saved = localStorage.getItem('earTrainingProgress');
    if (saved) {
        const data = JSON.parse(saved);
        score = data.score || 0;
        streak = data.streak || 0;
        bestStreak = data.bestStreak || 0;
        totalAttempts = data.totalAttempts || 0;
        correctAttempts = data.correctAttempts || 0;
        currentDifficulty = data.currentDifficulty || 'beginner';
        direction = data.direction || 'ascending';
        autoAdvance = data.autoAdvance !== undefined ? data.autoAdvance : true;

        // Update UI
        if (difficultySelect) difficultySelect.value = currentDifficulty;
        if (directionSelect) directionSelect.value = direction;
        if (autoAdvanceCheckbox) autoAdvanceCheckbox.checked = autoAdvance;

        updateStats();
    }
}

function resetProgress() {
    if (confirm('Reset all progress? This cannot be undone.')) {
        score = 0;
        streak = 0;
        bestStreak = 0;
        totalAttempts = 0;
        correctAttempts = 0;
        localStorage.removeItem('earTrainingProgress');
        updateStats();
        generateNewInterval();
    }
}
