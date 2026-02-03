// BPM Finder - Tap Tempo Calculator
// Accurately detects beats per minute by tapping

let tapTimes = [];
let lastTapTime = null;
let resetTimeout = null;
const MAX_TAP_INTERVAL = 3000; // Reset if no tap for 3 seconds

// DOM Elements
const tapButton = document.getElementById('tapButton');
const bpmValue = document.getElementById('bpmValue');
const tapCount = document.getElementById('tapCount');
const avgBpm = document.getElementById('avgBpm');
const tempoName = document.getElementById('tempoName');
const resetBtn = document.getElementById('resetBtn');

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    setupEventListeners();
});

function setupEventListeners() {
    // Tap button - support both click and keyboard
    tapButton.addEventListener('click', handleTap);

    // Keyboard support (spacebar or any key)
    document.addEventListener('keydown', (e) => {
        if (e.code === 'Space' || e.key === ' ') {
            e.preventDefault();
            handleTap();
        }
    });

    // Reset button
    resetBtn.addEventListener('click', reset);
}

function handleTap() {
    const now = Date.now();

    // Visual feedback
    tapButton.classList.add('tapped');
    setTimeout(() => tapButton.classList.remove('tapped'), 100);

    // Clear reset timeout
    if (resetTimeout) {
        clearTimeout(resetTimeout);
    }

    // Auto-reset if too much time has passed
    if (lastTapTime && (now - lastTapTime) > MAX_TAP_INTERVAL) {
        reset();
    }

    // Record tap time
    tapTimes.push(now);
    lastTapTime = now;

    // Keep only last 16 taps for rolling average
    if (tapTimes.length > 16) {
        tapTimes.shift();
    }

    // Calculate BPM
    calculateBPM();

    // Set auto-reset timeout
    resetTimeout = setTimeout(reset, MAX_TAP_INTERVAL);
}

function calculateBPM() {
    const taps = tapTimes.length;

    // Update tap count
    tapCount.textContent = taps;

    // Need at least 2 taps to calculate BPM
    if (taps < 2) {
        bpmValue.textContent = '0';
        avgBpm.textContent = '0';
        tempoName.textContent = '-';
        return;
    }

    // Calculate intervals between taps
    const intervals = [];
    for (let i = 1; i < tapTimes.length; i++) {
        intervals.push(tapTimes[i] - tapTimes[i - 1]);
    }

    // Calculate average interval
    const avgInterval = intervals.reduce((sum, interval) => sum + interval, 0) / intervals.length;

    // Convert to BPM (60000 ms in a minute)
    const bpm = Math.round(60000 / avgInterval);

    // Calculate overall average (from first to last tap)
    const totalTime = tapTimes[tapTimes.length - 1] - tapTimes[0];
    const overallBpm = Math.round((taps - 1) * 60000 / totalTime);

    // Update display
    bpmValue.textContent = bpm;
    avgBpm.textContent = overallBpm;
    tempoName.textContent = getTempoName(bpm);

    // Animate BPM value
    bpmValue.style.transform = 'scale(1.1)';
    setTimeout(() => {
        bpmValue.style.transform = 'scale(1)';
    }, 100);
}

function getTempoName(bpm) {
    if (bpm < 40) return 'Grave';
    if (bpm < 60) return 'Largo';
    if (bpm < 80) return 'Adagio';
    if (bpm < 100) return 'Andante';
    if (bpm < 120) return 'Moderato';
    if (bpm < 140) return 'Allegro';
    if (bpm < 160) return 'Vivace';
    if (bpm < 200) return 'Presto';
    return 'Prestissimo';
}

function reset() {
    tapTimes = [];
    lastTapTime = null;

    if (resetTimeout) {
        clearTimeout(resetTimeout);
        resetTimeout = null;
    }

    // Reset display
    bpmValue.textContent = '0';
    tapCount.textContent = '0';
    avgBpm.textContent = '0';
    tempoName.textContent = '-';

    // Visual feedback
    resetBtn.style.transform = 'rotate(360deg)';
    setTimeout(() => {
        resetBtn.style.transform = 'rotate(0deg)';
    }, 300);
}

// Smooth transition for BPM value
bpmValue.style.transition = 'transform 0.1s ease';
resetBtn.style.transition = 'transform 0.3s ease';
