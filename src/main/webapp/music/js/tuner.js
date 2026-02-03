// Online Chromatic Tuner
// Uses Web Audio API and autocorrelation for pitch detection

let audioContext = null;
let analyser = null;
let microphone = null;
let scriptProcessor = null;
let isListening = false;

// Note frequencies (A4 = 440 Hz)
const NOTE_STRINGS = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];

// DOM Elements
let noteDisplay, frequencyDisplay, meterNeedle, tuningStatus, listeningIndicator;
let startBtn, stopBtn;

document.addEventListener('DOMContentLoaded', () => {
    initElements();
    initControls();
});

function initElements() {
    noteDisplay = document.getElementById('noteDisplay');
    frequencyDisplay = document.getElementById('frequencyDisplay');
    meterNeedle = document.getElementById('meterNeedle');
    tuningStatus = document.getElementById('tuningStatus');
    listeningIndicator = document.getElementById('listeningIndicator');
    startBtn = document.getElementById('startBtn');
    stopBtn = document.getElementById('stopBtn');
}

function initControls() {
    startBtn.addEventListener('click', startTuner);
    stopBtn.addEventListener('click', stopTuner);
}

async function startTuner() {
    try {
        // Request microphone access
        const stream = await navigator.mediaDevices.getUserMedia({ audio: true });

        // Create audio context
        audioContext = new (window.AudioContext || window.webkitAudioContext)();
        analyser = audioContext.createAnalyser();
        microphone = audioContext.createMediaStreamSource(stream);
        scriptProcessor = audioContext.createScriptProcessor(4096, 1, 1);

        analyser.fftSize = 4096;

        // Connect nodes
        microphone.connect(analyser);
        analyser.connect(scriptProcessor);
        scriptProcessor.connect(audioContext.destination);

        // Process audio
        scriptProcessor.onaudioprocess = processAudio;

        isListening = true;
        updateUI();

        ToolUtils.showToast('Microphone activated! Play a note.', 'success');
    } catch (error) {
        console.error('Microphone access error:', error);
        ToolUtils.showToast('Microphone access denied. Please allow microphone access.', 'error');
    }
}

function stopTuner() {
    if (scriptProcessor) {
        scriptProcessor.disconnect();
        scriptProcessor.onaudioprocess = null;
    }
    if (microphone) {
        microphone.disconnect();
    }
    if (analyser) {
        analyser.disconnect();
    }
    if (audioContext) {
        audioContext.close();
    }

    isListening = false;
    updateUI();
    resetDisplay();
}

function processAudio() {
    const buffer = new Float32Array(analyser.fftSize);
    analyser.getFloatTimeDomainData(buffer);

    // Detect pitch using autocorrelation
    const pitch = autoCorrelate(buffer, audioContext.sampleRate);

    if (pitch > 0) {
        updateTunerDisplay(pitch);
    }
}

// Autocorrelation pitch detection algorithm
function autoCorrelate(buffer, sampleRate) {
    // Minimum frequency: 80 Hz (low E on bass guitar)
    // Maximum frequency: 1200 Hz (high notes)
    const MIN_SAMPLES = Math.floor(sampleRate / 1200);
    const MAX_SAMPLES = Math.floor(sampleRate / 80);

    let SIZE = buffer.length;
    let sumOfSquares = 0;

    for (let i = 0; i < SIZE; i++) {
        const val = buffer[i];
        sumOfSquares += val * val;
    }

    // Not enough signal
    if (sumOfSquares < 0.001) {
        return -1;
    }

    let r1 = 0;
    let r2 = SIZE - 1;
    const threshold = 0.2;

    // Trim silence from beginning
    for (let i = 0; i < SIZE / 2; i++) {
        if (Math.abs(buffer[i]) < threshold) {
            r1 = i;
            break;
        }
    }

    // Trim silence from end
    for (let i = 1; i < SIZE / 2; i++) {
        if (Math.abs(buffer[SIZE - i]) < threshold) {
            r2 = SIZE - i;
            break;
        }
    }

    buffer = buffer.slice(r1, r2);
    SIZE = buffer.length;

    // Autocorrelation
    const c = new Array(SIZE).fill(0);
    for (let i = 0; i < SIZE; i++) {
        for (let j = 0; j < SIZE - i; j++) {
            c[i] = c[i] + buffer[j] * buffer[j + i];
        }
    }

    let d = 0;
    while (c[d] > c[d + 1]) {
        d++;
    }

    let maxValue = -1;
    let maxIndex = -1;

    for (let i = d; i < SIZE; i++) {
        if (c[i] > maxValue) {
            maxValue = c[i];
            maxIndex = i;
        }
    }

    let T0 = maxIndex;

    // Parabolic interpolation for better accuracy
    const x1 = c[T0 - 1];
    const x2 = c[T0];
    const x3 = c[T0 + 1];

    const a = (x1 + x3 - 2 * x2) / 2;
    const b = (x3 - x1) / 2;

    if (a) {
        T0 = T0 - b / (2 * a);
    }

    return sampleRate / T0;
}

function updateTunerDisplay(frequency) {
    // Get note info
    const noteInfo = getNoteInfo(frequency);

    // Update displays
    noteDisplay.textContent = noteInfo.note;
    frequencyDisplay.textContent = `${frequency.toFixed(1)} Hz`;

    // Update meter needle (-50 to +50 cents = -45deg to +45deg)
    const rotation = (noteInfo.cents / 50) * 45;
    meterNeedle.style.transform = `translateX(-50%) translateY(-50%) rotate(${rotation}deg)`;

    // Update tuning status
    const absCents = Math.abs(noteInfo.cents);
    tuningStatus.className = 'tuning-status';

    if (absCents < 5) {
        tuningStatus.classList.add('in-tune');
        tuningStatus.textContent = '✓ In Tune!';
    } else if (noteInfo.cents < 0) {
        tuningStatus.classList.add('flat');
        tuningStatus.textContent = `♭ Too Flat (${Math.abs(noteInfo.cents).toFixed(0)}¢)`;
    } else {
        tuningStatus.classList.add('sharp');
        tuningStatus.textContent = `♯ Too Sharp (+${noteInfo.cents.toFixed(0)}¢)`;
    }
}

function getNoteInfo(frequency) {
    // Calculate note from frequency
    const noteNum = 12 * (Math.log(frequency / 440) / Math.log(2));
    const noteIndex = Math.round(noteNum) + 69; // MIDI note number
    const noteName = NOTE_STRINGS[noteIndex % 12];
    const octave = Math.floor(noteIndex / 12) - 1;

    // Calculate cents (deviation from perfect pitch)
    const targetFreq = 440 * Math.pow(2, (noteIndex - 69) / 12);
    const cents = 1200 * Math.log(frequency / targetFreq) / Math.log(2);

    return {
        note: `${noteName}${octave}`,
        frequency: frequency,
        cents: cents
    };
}

function updateUI() {
    if (isListening) {
        startBtn.style.display = 'none';
        stopBtn.style.display = 'flex';
        listeningIndicator.classList.add('active');
    } else {
        startBtn.style.display = 'flex';
        stopBtn.style.display = 'none';
        listeningIndicator.classList.remove('active');
    }
}

function resetDisplay() {
    noteDisplay.textContent = '-';
    frequencyDisplay.textContent = '0 Hz';
    meterNeedle.style.transform = 'translateX(-50%) translateY(-50%) rotate(0deg)';
    tuningStatus.className = 'tuning-status';
    tuningStatus.textContent = 'Play a note to start tuning';
}
