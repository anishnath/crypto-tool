// Drum Machine - 16-step sequencer with multiple drum kits
// Uses Tone.js for audio synthesis and sequencing

// Drum tracks configuration
const tracks = [
    { name: 'Kick', id: 'kick', key: '1' },
    { name: 'Snare', id: 'snare', key: '2' },
    { name: 'Closed HH', id: 'hihat', key: '3' },
    { name: 'Open HH', id: 'openhat', key: '4' },
    { name: 'Clap', id: 'clap', key: '5' },
    { name: 'Tom', id: 'tom', key: '6' },
    { name: 'Crash', id: 'crash', key: '7' },
    { name: 'Rim', id: 'rim', key: '8' }
];

// Kit configurations with different sound parameters
const kitConfigs = {
    acoustic: {
        kick: { pitchDecay: 0.05, octaves: 6, envelope: { attack: 0.001, decay: 0.4, sustain: 0.01, release: 1.4 }, volume: -5 },
        snare: { noise: 'white', envelope: { attack: 0.001, decay: 0.2, sustain: 0 }, volume: -10 },
        hihat: { frequency: 200, envelope: { attack: 0.001, decay: 0.1, release: 0.01 }, volume: -15 },
        openhat: { frequency: 200, envelope: { attack: 0.001, decay: 0.3, release: 0.3 }, volume: -12 },
        clap: { noise: 'white', envelope: { attack: 0.001, decay: 0.15, sustain: 0 }, volume: -8 },
        tom: { pitchDecay: 0.08, octaves: 4, envelope: { attack: 0.001, decay: 0.3, sustain: 0.1, release: 0.8 }, volume: -8, note: 'G1' },
        crash: { frequency: 300, envelope: { attack: 0.001, decay: 1, release: 2 }, volume: -15 },
        rim: { pitchDecay: 0.01, octaves: 2, envelope: { attack: 0.001, decay: 0.1, sustain: 0, release: 0.1 }, volume: -12, note: 'E2' }
    },
    electronic: {
        kick: { pitchDecay: 0.02, octaves: 8, envelope: { attack: 0.001, decay: 0.3, sustain: 0, release: 0.5 }, volume: -3 },
        snare: { noise: 'pink', envelope: { attack: 0.001, decay: 0.15, sustain: 0 }, volume: -8 },
        hihat: { frequency: 400, envelope: { attack: 0.001, decay: 0.05, release: 0.01 }, volume: -18 },
        openhat: { frequency: 400, envelope: { attack: 0.001, decay: 0.2, release: 0.2 }, volume: -15 },
        clap: { noise: 'pink', envelope: { attack: 0.005, decay: 0.1, sustain: 0 }, volume: -6 },
        tom: { pitchDecay: 0.05, octaves: 5, envelope: { attack: 0.001, decay: 0.2, sustain: 0, release: 0.3 }, volume: -6, note: 'A1' },
        crash: { frequency: 500, envelope: { attack: 0.001, decay: 0.5, release: 1 }, volume: -18 },
        rim: { pitchDecay: 0.005, octaves: 3, envelope: { attack: 0.001, decay: 0.05, sustain: 0, release: 0.05 }, volume: -10, note: 'G2' }
    },
    '808': {
        kick: { pitchDecay: 0.08, octaves: 10, envelope: { attack: 0.001, decay: 0.8, sustain: 0.1, release: 2 }, volume: 0 },
        snare: { noise: 'white', envelope: { attack: 0.001, decay: 0.25, sustain: 0.02 }, volume: -6 },
        hihat: { frequency: 300, envelope: { attack: 0.001, decay: 0.08, release: 0.01 }, volume: -16 },
        openhat: { frequency: 300, envelope: { attack: 0.001, decay: 0.4, release: 0.4 }, volume: -14 },
        clap: { noise: 'white', envelope: { attack: 0.01, decay: 0.2, sustain: 0.01 }, volume: -4 },
        tom: { pitchDecay: 0.1, octaves: 6, envelope: { attack: 0.001, decay: 0.5, sustain: 0.1, release: 1 }, volume: -4, note: 'F1' },
        crash: { frequency: 250, envelope: { attack: 0.001, decay: 1.5, release: 2.5 }, volume: -14 },
        rim: { pitchDecay: 0.02, octaves: 2, envelope: { attack: 0.001, decay: 0.08, sustain: 0, release: 0.08 }, volume: -8, note: 'D2' }
    },
    trap: {
        kick: { pitchDecay: 0.1, octaves: 12, envelope: { attack: 0.001, decay: 1, sustain: 0.2, release: 2.5 }, volume: 2 },
        snare: { noise: 'white', envelope: { attack: 0.001, decay: 0.3, sustain: 0.05 }, volume: -4 },
        hihat: { frequency: 500, envelope: { attack: 0.001, decay: 0.04, release: 0.005 }, volume: -20 },
        openhat: { frequency: 500, envelope: { attack: 0.001, decay: 0.15, release: 0.15 }, volume: -18 },
        clap: { noise: 'white', envelope: { attack: 0.02, decay: 0.25, sustain: 0.02 }, volume: -2 },
        tom: { pitchDecay: 0.15, octaves: 8, envelope: { attack: 0.001, decay: 0.6, sustain: 0.15, release: 1.2 }, volume: -2, note: 'E1' },
        crash: { frequency: 350, envelope: { attack: 0.001, decay: 0.8, release: 1.5 }, volume: -16 },
        rim: { pitchDecay: 0.01, octaves: 1, envelope: { attack: 0.001, decay: 0.06, sustain: 0, release: 0.06 }, volume: -10, note: 'F2' }
    }
};

// Preset patterns
const presets = {
    basic: {
        kick: [1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0],
        snare: [0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0],
        hihat: [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0],
        openhat: [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1],
        clap: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        tom: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        crash: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        rim: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    },
    hiphop: {
        kick: [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
        snare: [0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0],
        hihat: [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0],
        openhat: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        clap: [0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0],
        tom: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        crash: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        rim: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    },
    house: {
        kick: [1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0],
        snare: [0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0],
        hihat: [0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0],
        openhat: [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1],
        clap: [0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0],
        tom: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        crash: [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        rim: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    },
    trap: {
        kick: [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0],
        snare: [0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0],
        hihat: [1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1],
        openhat: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        clap: [0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0],
        tom: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        crash: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        rim: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    },
    dnb: {
        kick: [1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0],
        snare: [0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0],
        hihat: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        openhat: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        clap: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        tom: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        crash: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        rim: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    },
    funk: {
        kick: [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0],
        snare: [0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0],
        hihat: [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0],
        openhat: [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
        clap: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        tom: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
        crash: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        rim: [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0]
    }
};

// State
let pattern = {};
let isPlaying = false;
let currentStep = 0;
let bpm = 120;
let swing = 0;
let currentKit = 'acoustic';
let samplers = {};
let sequence = null;
let trackVolumes = {};
let trackMutes = {};
let tapTimes = [];

// Initialize track volumes and mutes
tracks.forEach(track => {
    trackVolumes[track.id] = 0; // 0 = default (no adjustment)
    trackMutes[track.id] = false;
});

// DOM Elements
const sequencerGrid = document.getElementById('sequencerGrid');
const playBtn = document.getElementById('playBtn');
const bpmInput = document.getElementById('bpmInput');
const kitSelect = document.getElementById('kitSelect');
const swingSlider = document.getElementById('swingSlider');
const swingValue = document.getElementById('swingValue');
const clearBtn = document.getElementById('clearBtn');
const randomBtn = document.getElementById('randomBtn');
const copyBtn = document.getElementById('copyBtn');

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    initPattern();
    initAudio();
    renderSequencer();
    setupEventListeners();
});

function initPattern() {
    tracks.forEach(track => {
        pattern[track.id] = new Array(16).fill(0);
    });
}

async function initAudio() {
    createSamplersForKit(currentKit);
}

function createSamplersForKit(kitName) {
    // Dispose existing samplers
    Object.values(samplers).forEach(sampler => {
        if (sampler && sampler.dispose) {
            sampler.dispose();
        }
    });

    const kit = kitConfigs[kitName];

    samplers = {
        kick: new Tone.MembraneSynth({
            pitchDecay: kit.kick.pitchDecay,
            octaves: kit.kick.octaves,
            oscillator: { type: 'sine' },
            envelope: kit.kick.envelope
        }).toDestination(),

        snare: new Tone.NoiseSynth({
            noise: { type: kit.snare.noise },
            envelope: kit.snare.envelope
        }).toDestination(),

        hihat: new Tone.MetalSynth({
            frequency: kit.hihat.frequency,
            envelope: kit.hihat.envelope,
            harmonicity: 5.1,
            modulationIndex: 32,
            resonance: 4000,
            octaves: 1.5
        }).toDestination(),

        openhat: new Tone.MetalSynth({
            frequency: kit.openhat.frequency,
            envelope: kit.openhat.envelope,
            harmonicity: 5.1,
            modulationIndex: 32,
            resonance: 4000,
            octaves: 1.5
        }).toDestination(),

        clap: new Tone.NoiseSynth({
            noise: { type: kit.clap.noise },
            envelope: kit.clap.envelope
        }).toDestination(),

        tom: new Tone.MembraneSynth({
            pitchDecay: kit.tom.pitchDecay,
            octaves: kit.tom.octaves,
            oscillator: { type: 'sine' },
            envelope: kit.tom.envelope
        }).toDestination(),

        crash: new Tone.MetalSynth({
            frequency: kit.crash.frequency,
            envelope: kit.crash.envelope,
            harmonicity: 3.1,
            modulationIndex: 16,
            resonance: 3000,
            octaves: 1.5
        }).toDestination(),

        rim: new Tone.MembraneSynth({
            pitchDecay: kit.rim.pitchDecay,
            octaves: kit.rim.octaves,
            oscillator: { type: 'square' },
            envelope: kit.rim.envelope
        }).toDestination()
    };

    // Apply base volumes from kit config + user adjustments
    Object.keys(samplers).forEach(trackId => {
        const baseVolume = kit[trackId].volume;
        samplers[trackId].volume.value = baseVolume + trackVolumes[trackId];
    });
}

function renderSequencer() {
    sequencerGrid.innerHTML = '';

    tracks.forEach((track, trackIndex) => {
        // Track label with controls
        const label = document.createElement('div');
        label.className = 'track-label';
        label.innerHTML = `
            <div class="track-label-content">
                <button class="mute-btn ${trackMutes[track.id] ? 'muted' : ''}" data-track="${track.id}" title="Mute (M)">
                    ${trackMutes[track.id] ? '🔇' : '🔊'}
                </button>
                <span class="track-name" title="Press ${track.key} to play">${track.name}</span>
                <input type="range" class="track-volume" data-track="${track.id}"
                       min="-20" max="10" value="${trackVolumes[track.id]}" title="Volume">
            </div>
        `;
        sequencerGrid.appendChild(label);

        // Steps
        for (let step = 0; step < 16; step++) {
            const cell = document.createElement('div');
            cell.className = 'step-cell';
            cell.dataset.track = track.id;
            cell.dataset.step = step;

            // Highlight every 4th step
            if (step % 4 === 0) {
                cell.classList.add('beat-4');
            }

            // Set active state
            if (pattern[track.id][step]) {
                cell.classList.add('active');
            }

            // Click handler
            cell.addEventListener('click', () => toggleStep(track.id, step));

            sequencerGrid.appendChild(cell);
        }
    });

    // Setup track control listeners
    setupTrackControls();
}

function setupTrackControls() {
    // Mute buttons
    document.querySelectorAll('.mute-btn').forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.stopPropagation();
            const trackId = btn.dataset.track;
            trackMutes[trackId] = !trackMutes[trackId];
            btn.classList.toggle('muted', trackMutes[trackId]);
            btn.textContent = trackMutes[trackId] ? '🔇' : '🔊';
        });
    });

    // Volume sliders
    document.querySelectorAll('.track-volume').forEach(slider => {
        slider.addEventListener('input', (e) => {
            const trackId = slider.dataset.track;
            const volumeAdjust = parseInt(e.target.value);
            trackVolumes[trackId] = volumeAdjust;

            // Update sampler volume
            if (samplers[trackId]) {
                const kit = kitConfigs[currentKit];
                const baseVolume = kit[trackId].volume;
                samplers[trackId].volume.value = baseVolume + volumeAdjust;
            }
        });
    });
}

function toggleStep(trackId, step) {
    pattern[trackId][step] = pattern[trackId][step] ? 0 : 1;
    updateStepVisual(trackId, step);
}

function updateStepVisual(trackId, step) {
    const cell = document.querySelector(`[data-track="${trackId}"][data-step="${step}"]`);
    if (cell) {
        cell.classList.toggle('active', pattern[trackId][step] === 1);
    }
}

function setupEventListeners() {
    playBtn.addEventListener('click', togglePlay);

    bpmInput.addEventListener('change', (e) => {
        bpm = parseInt(e.target.value);
        if (sequence) {
            Tone.Transport.bpm.value = bpm;
        }
    });

    kitSelect.addEventListener('change', (e) => {
        currentKit = e.target.value;
        createSamplersForKit(currentKit);
    });

    swingSlider.addEventListener('input', (e) => {
        swing = parseInt(e.target.value);
        swingValue.textContent = `${swing}%`;
        if (sequence) {
            Tone.Transport.swing = swing / 100;
        }
    });

    clearBtn.addEventListener('click', clearPattern);
    randomBtn.addEventListener('click', randomizePattern);
    copyBtn.addEventListener('click', copyPattern);

    // Tap tempo
    const tapBtn = document.getElementById('tapTempoBtn');
    if (tapBtn) {
        tapBtn.addEventListener('click', handleTapTempo);
    }

    // Save/Load pattern
    const saveBtn = document.getElementById('savePatternBtn');
    const loadBtn = document.getElementById('loadPatternBtn');
    if (saveBtn) saveBtn.addEventListener('click', savePattern);
    if (loadBtn) loadBtn.addEventListener('click', loadPattern);

    // Share pattern
    const shareBtn = document.getElementById('sharePatternBtn');
    if (shareBtn) shareBtn.addEventListener('click', sharePattern);

    // Preset buttons
    document.querySelectorAll('.preset-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            const presetName = btn.dataset.preset;
            loadPreset(presetName);
        });
    });

    // Keyboard shortcuts for playing sounds
    document.addEventListener('keydown', handleKeyPress);

    // Load pattern from URL if present
    loadPatternFromURL();
}

function handleKeyPress(e) {
    // Don't trigger if typing in an input
    if (e.target.tagName === 'INPUT' || e.target.tagName === 'SELECT') return;

    // Number keys 1-8 play drum sounds
    const key = e.key;
    const track = tracks.find(t => t.key === key);
    if (track && !trackMutes[track.id]) {
        Tone.start();
        playSound(track.id, Tone.now());
        // Visual feedback
        const label = document.querySelector(`[data-track="${track.id}"].mute-btn`)?.parentElement;
        if (label) {
            label.classList.add('key-pressed');
            setTimeout(() => label.classList.remove('key-pressed'), 100);
        }
    }

    // Spacebar for play/stop
    if (e.code === 'Space' && e.target.tagName !== 'BUTTON') {
        e.preventDefault();
        togglePlay();
    }
}

function handleTapTempo() {
    const now = Date.now();

    // Reset if more than 2 seconds since last tap
    if (tapTimes.length > 0 && now - tapTimes[tapTimes.length - 1] > 2000) {
        tapTimes = [];
    }

    tapTimes.push(now);

    // Need at least 2 taps
    if (tapTimes.length >= 2) {
        // Keep last 4 taps
        if (tapTimes.length > 4) {
            tapTimes.shift();
        }

        // Calculate average interval
        let totalInterval = 0;
        for (let i = 1; i < tapTimes.length; i++) {
            totalInterval += tapTimes[i] - tapTimes[i - 1];
        }
        const avgInterval = totalInterval / (tapTimes.length - 1);
        const newBpm = Math.round(60000 / avgInterval);

        // Clamp BPM to valid range
        bpm = Math.max(40, Math.min(240, newBpm));
        bpmInput.value = bpm;

        if (sequence) {
            Tone.Transport.bpm.value = bpm;
        }
    }
}

function savePattern() {
    const data = {
        pattern,
        bpm,
        swing,
        kit: currentKit,
        trackVolumes,
        trackMutes
    };
    localStorage.setItem('drumMachinePattern', JSON.stringify(data));

    const saveBtn = document.getElementById('savePatternBtn');
    if (saveBtn) {
        const originalText = saveBtn.textContent;
        saveBtn.textContent = '✓ Saved!';
        setTimeout(() => {
            saveBtn.textContent = originalText;
        }, 1500);
    }
}

function loadPattern() {
    const saved = localStorage.getItem('drumMachinePattern');
    if (saved) {
        const data = JSON.parse(saved);
        pattern = data.pattern || {};
        bpm = data.bpm || 120;
        swing = data.swing || 0;
        currentKit = data.kit || 'acoustic';
        trackVolumes = data.trackVolumes || {};
        trackMutes = data.trackMutes || {};

        // Update UI
        bpmInput.value = bpm;
        swingSlider.value = swing;
        swingValue.textContent = `${swing}%`;
        kitSelect.value = currentKit;

        // Recreate samplers for loaded kit
        createSamplersForKit(currentKit);

        // Re-render
        renderSequencer();

        const loadBtn = document.getElementById('loadPatternBtn');
        if (loadBtn) {
            const originalText = loadBtn.textContent;
            loadBtn.textContent = '✓ Loaded!';
            setTimeout(() => {
                loadBtn.textContent = originalText;
            }, 1500);
        }
    } else {
        alert('No saved pattern found');
    }
}

function sharePattern() {
    const data = {
        p: pattern,
        b: bpm,
        s: swing,
        k: currentKit
    };

    // Compress to base64
    const encoded = btoa(JSON.stringify(data));
    const url = `${window.location.origin}${window.location.pathname}?pattern=${encoded}`;

    navigator.clipboard.writeText(url).then(() => {
        const shareBtn = document.getElementById('sharePatternBtn');
        if (shareBtn) {
            const originalText = shareBtn.textContent;
            shareBtn.textContent = '✓ Link Copied!';
            setTimeout(() => {
                shareBtn.textContent = originalText;
            }, 2000);
        }
    }).catch(err => {
        console.error('Failed to copy:', err);
        // Fallback: show URL in prompt
        prompt('Copy this URL to share your pattern:', url);
    });
}

function loadPatternFromURL() {
    const params = new URLSearchParams(window.location.search);
    const encoded = params.get('pattern');

    if (encoded) {
        try {
            const data = JSON.parse(atob(encoded));
            pattern = data.p || {};
            bpm = data.b || 120;
            swing = data.s || 0;
            currentKit = data.k || 'acoustic';

            // Update UI
            bpmInput.value = bpm;
            swingSlider.value = swing;
            swingValue.textContent = `${swing}%`;
            kitSelect.value = currentKit;

            // Recreate samplers
            createSamplersForKit(currentKit);

            // Re-render
            renderSequencer();
        } catch (e) {
            console.error('Failed to load pattern from URL:', e);
        }
    }
}

function togglePlay() {
    if (!isPlaying) {
        startSequence();
    } else {
        stopSequence();
    }
}

function startSequence() {
    isPlaying = true;
    playBtn.classList.add('playing');
    playBtn.innerHTML = '<span>⏹️</span><span>Stop</span>';

    Tone.Transport.bpm.value = bpm;
    Tone.Transport.swing = swing / 100;

    // Create sequence
    sequence = new Tone.Sequence((time, step) => {
        // Play all active tracks for this step
        tracks.forEach(track => {
            if (pattern[track.id][step]) {
                playSound(track.id, time);
            }
        });

        // Update visual
        Tone.Draw.schedule(() => {
            updateCurrentStep(step);
        }, time);
    }, [...Array(16).keys()], '16n');

    sequence.start(0);
    Tone.Transport.start();
}

function stopSequence() {
    isPlaying = false;
    playBtn.classList.remove('playing');
    playBtn.innerHTML = '<span>▶️</span><span>Play</span>';

    if (sequence) {
        sequence.stop();
        sequence.dispose();
        sequence = null;
    }

    Tone.Transport.stop();
    clearCurrentStep();
}

function playSound(trackId, time) {
    // Check if track is muted
    if (trackMutes[trackId]) return;

    const sampler = samplers[trackId];
    if (!sampler) return;

    const kit = kitConfigs[currentKit];

    switch (trackId) {
        case 'kick':
            sampler.triggerAttackRelease('C1', '8n', time);
            break;
        case 'snare':
            sampler.triggerAttackRelease('8n', time);
            break;
        case 'hihat':
            sampler.triggerAttackRelease('16n', time);
            break;
        case 'openhat':
            sampler.triggerAttackRelease('8n', time);
            break;
        case 'clap':
            sampler.triggerAttackRelease('8n', time);
            break;
        case 'tom':
            sampler.triggerAttackRelease(kit.tom.note || 'G1', '8n', time);
            break;
        case 'crash':
            sampler.triggerAttackRelease('4n', time);
            break;
        case 'rim':
            sampler.triggerAttackRelease(kit.rim.note || 'E2', '16n', time);
            break;
    }
}

function updateCurrentStep(step) {
    clearCurrentStep();
    currentStep = step;

    document.querySelectorAll(`[data-step="${step}"]`).forEach(cell => {
        if (!cell.classList.contains('track-label')) {
            cell.classList.add('current');
        }
    });
}

function clearCurrentStep() {
    document.querySelectorAll('.current').forEach(cell => {
        cell.classList.remove('current');
    });
}

function clearPattern() {
    tracks.forEach(track => {
        pattern[track.id] = new Array(16).fill(0);
    });
    renderSequencer();
}

function randomizePattern() {
    tracks.forEach(track => {
        pattern[track.id] = Array.from({ length: 16 }, () => Math.random() > 0.7 ? 1 : 0);
    });
    renderSequencer();
}

function loadPreset(presetName) {
    const preset = presets[presetName];
    if (preset) {
        pattern = JSON.parse(JSON.stringify(preset));
        renderSequencer();
    }
}

async function copyPattern() {
    const patternString = JSON.stringify(pattern, null, 2);

    try {
        await navigator.clipboard.writeText(patternString);
        copyBtn.textContent = '✓ Copied!';
        setTimeout(() => {
            copyBtn.textContent = '📋 Copy Pattern';
        }, 2000);
    } catch (err) {
        console.error('Failed to copy:', err);
    }
}
