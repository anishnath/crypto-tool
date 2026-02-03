// Virtual Piano - Interactive online piano with keyboard controls
// Uses Tone.js for high-quality audio synthesis

// Piano key configuration
const whiteKeys = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];
const blackKeyPositions = [1, 2, 4, 5, 6]; // Positions after C, D, F, G, A

// Keyboard mapping (QWERTY to piano keys)
const keyboardMap = {
    // White keys (C to C)
    'a': 0, 's': 1, 'd': 2, 'f': 3, 'g': 4, 'h': 5, 'j': 6, 'k': 7,
    // Black keys
    'w': 0.5, 'e': 1.5, 't': 3.5, 'y': 4.5, 'u': 5.5
};

// State
let currentOctave = 4;
let synth = null;
let reverb = null;
let isRecording = false;
let recordedNotes = [];
let recordStartTime = null;
let activeNotes = new Set();
let sustainPedal = false;

// DOM Elements
const pianoKeyboard = document.getElementById('pianoKeyboard');
const instrumentSelect = document.getElementById('instrumentSelect');
const octaveSelect = document.getElementById('octaveSelect');
const volumeSlider = document.getElementById('volumeSlider');
const volumeValue = document.getElementById('volumeValue');
const reverbSlider = document.getElementById('reverbSlider');
const reverbValue = document.getElementById('reverbValue');
const recordBtn = document.getElementById('recordBtn');
const playBtn = document.getElementById('playBtn');
const clearBtn = document.getElementById('clearBtn');
const sustainCheckbox = document.getElementById('sustainCheckbox');
const labelsCheckbox = document.getElementById('labelsCheckbox');
const keyboardGuideCheckbox = document.getElementById('keyboardGuideCheckbox');

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    initAudio();
    renderPiano();
    setupEventListeners();
});

function initAudio() {
    // Create reverb effect
    reverb = new Tone.Reverb({
        decay: 2,
        wet: 0
    }).toDestination();

    // Create polyphonic synth with piano-like sound
    synth = new Tone.PolySynth(Tone.Synth, {
        oscillator: { type: 'triangle' },
        envelope: {
            attack: 0.005,
            decay: 0.3,
            sustain: 0.4,
            release: 1.2
        },
        volume: -10
    }).connect(reverb);
}

function renderPiano() {
    pianoKeyboard.innerHTML = '';

    // Render 3 octaves (36 keys total) for better range
    const numOctaves = 3;

    // Keyboard mapping for computer keys
    const keyMap = ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k'];
    const blackKeyMap = ['w', 'e', '', 't', 'y', 'u', ''];

    for (let octave = 0; octave < numOctaves; octave++) {
        for (let i = 0; i < whiteKeys.length; i++) {
            const note = whiteKeys[i];
            const noteOctave = currentOctave + octave;
            const fullNote = `${note}${noteOctave}`;

            // Create white key
            const whiteKey = document.createElement('div');
            whiteKey.className = 'piano-key white-key';
            whiteKey.dataset.note = fullNote;

            // Add label
            const label = document.createElement('div');
            label.className = 'key-label';
            label.textContent = note;
            whiteKey.appendChild(label);

            // Add keyboard guide
            if (octave === 0 && i < keyMap.length) {
                const guide = document.createElement('div');
                guide.className = 'keyboard-guide';
                guide.textContent = keyMap[i].toUpperCase();
                whiteKey.appendChild(guide);
            }

            pianoKeyboard.appendChild(whiteKey);

            // Add black key if applicable
            if (blackKeyPositions.includes(i)) {
                const blackNote = `${note}#${noteOctave}`;
                const blackKey = document.createElement('div');
                blackKey.className = 'piano-key black-key';
                blackKey.dataset.note = blackNote;
                blackKey.style.left = `${(octave * 7 + i) * 60 + 40}px`;

                const blackLabel = document.createElement('div');
                blackLabel.className = 'key-label';
                blackLabel.textContent = `${note}#`;
                blackKey.appendChild(blackLabel);

                // Add keyboard guide for black keys
                if (octave === 0 && blackKeyMap[i]) {
                    const guide = document.createElement('div');
                    guide.className = 'keyboard-guide';
                    guide.textContent = blackKeyMap[i].toUpperCase();
                    blackKey.appendChild(guide);
                }

                pianoKeyboard.appendChild(blackKey);
            }
        }
    }

    // Add click handlers
    document.querySelectorAll('.piano-key').forEach(key => {
        key.addEventListener('mousedown', () => playNote(key.dataset.note, key));
        key.addEventListener('mouseup', () => stopNote(key.dataset.note, key));
        key.addEventListener('mouseleave', () => stopNote(key.dataset.note, key));

        // Touch support
        key.addEventListener('touchstart', (e) => {
            e.preventDefault();
            playNote(key.dataset.note, key);
        });
        key.addEventListener('touchend', (e) => {
            e.preventDefault();
            stopNote(key.dataset.note, key);
        });
    });
}

function setupEventListeners() {
    // Instrument selector
    instrumentSelect.addEventListener('change', changeInstrument);

    // Octave selector
    octaveSelect.addEventListener('change', (e) => {
        currentOctave = parseInt(e.target.value);
        renderPiano();
    });

    // Volume control
    volumeSlider.addEventListener('input', (e) => {
        const volume = parseInt(e.target.value);
        volumeValue.textContent = `${volume}%`;
        synth.volume.value = Tone.gainToDb(volume / 100);
    });

    // Reverb control
    reverbSlider.addEventListener('input', (e) => {
        const reverbAmount = parseInt(e.target.value);
        reverbValue.textContent = `${reverbAmount}%`;
        if (reverb) {
            reverb.wet.value = reverbAmount / 100;
        }
    });

    // Recording controls
    recordBtn.addEventListener('click', toggleRecording);
    playBtn.addEventListener('click', playRecording);
    clearBtn.addEventListener('click', clearRecording);

    // Sustain pedal
    sustainCheckbox.addEventListener('change', (e) => {
        sustainPedal = e.target.checked;
    });

    // Labels toggle
    labelsCheckbox.addEventListener('change', (e) => {
        if (e.target.checked) {
            pianoKeyboard.classList.remove('hide-labels');
        } else {
            pianoKeyboard.classList.add('hide-labels');
        }
    });

    // Keyboard guide toggle
    keyboardGuideCheckbox.addEventListener('change', (e) => {
        if (e.target.checked) {
            pianoKeyboard.classList.add('show-keyboard-guide');
        } else {
            pianoKeyboard.classList.remove('show-keyboard-guide');
        }
    });

    // Keyboard controls
    document.addEventListener('keydown', handleKeyDown);
    document.addEventListener('keyup', handleKeyUp);
}

function handleKeyDown(e) {
    // Prevent repeat events
    if (e.repeat) return;

    const key = e.key.toLowerCase();

    // Octave controls
    if (key === 'z') {
        if (currentOctave > 2) {
            currentOctave--;
            octaveSelect.value = currentOctave;
            renderPiano();
        }
        return;
    }
    if (key === 'x') {
        if (currentOctave < 6) {
            currentOctave++;
            octaveSelect.value = currentOctave;
            renderPiano();
        }
        return;
    }

    // Sustain pedal
    if (key === ' ') {
        e.preventDefault();
        sustainPedal = true;
        sustainCheckbox.checked = true;
        return;
    }

    // Play note
    if (key in keyboardMap) {
        const keyIndex = keyboardMap[key];
        const note = getNoteFromIndex(keyIndex);
        if (note) {
            const keyElement = findKeyElement(note);
            if (keyElement && !activeNotes.has(note)) {
                playNote(note, keyElement);
            }
        }
    }
}

function handleKeyUp(e) {
    const key = e.key.toLowerCase();

    // Sustain pedal
    if (key === ' ') {
        e.preventDefault();
        sustainPedal = false;
        sustainCheckbox.checked = false;
        // Release all sustained notes
        if (!sustainPedal) {
            activeNotes.forEach(note => {
                const keyElement = findKeyElement(note);
                if (keyElement) {
                    stopNote(note, keyElement);
                }
            });
        }
        return;
    }

    // Stop note
    if (key in keyboardMap) {
        const keyIndex = keyboardMap[key];
        const note = getNoteFromIndex(keyIndex);
        if (note) {
            const keyElement = findKeyElement(note);
            if (keyElement) {
                stopNote(note, keyElement);
            }
        }
    }
}

function getNoteFromIndex(index) {
    const isBlackKey = index % 1 !== 0;

    if (isBlackKey) {
        const whiteIndex = Math.floor(index);
        if (whiteIndex < whiteKeys.length) {
            return `${whiteKeys[whiteIndex]}#${currentOctave}`;
        }
    } else {
        if (index < whiteKeys.length) {
            return `${whiteKeys[index]}${currentOctave}`;
        } else {
            return `${whiteKeys[index - whiteKeys.length]}${currentOctave + 1}`;
        }
    }
    return null;
}

function findKeyElement(note) {
    return document.querySelector(`[data-note="${note}"]`);
}

function playNote(note, keyElement) {
    if (!synth || activeNotes.has(note)) return;

    // Play sound
    synth.triggerAttack(note);
    activeNotes.add(note);

    // Visual feedback
    if (keyElement) {
        keyElement.classList.add('active');
    }

    // Record if recording
    if (isRecording) {
        const timestamp = Date.now() - recordStartTime;
        recordedNotes.push({ note, timestamp, type: 'start' });
    }
}

function stopNote(note, keyElement) {
    if (!synth || !activeNotes.has(note)) return;

    // Don't release if sustain pedal is active
    if (sustainPedal) return;

    // Stop sound
    synth.triggerRelease(note);
    activeNotes.delete(note);

    // Visual feedback
    if (keyElement) {
        keyElement.classList.remove('active');
    }

    // Record if recording
    if (isRecording) {
        const timestamp = Date.now() - recordStartTime;
        recordedNotes.push({ note, timestamp, type: 'stop' });
    }
}

function changeInstrument() {
    const instrument = instrumentSelect.value;

    // Dispose old synth
    if (synth) {
        synth.dispose();
    }

    // Create new synth based on instrument
    switch (instrument) {
        case 'piano':
            synth = new Tone.PolySynth(Tone.Synth, {
                oscillator: { type: 'triangle' },
                envelope: { attack: 0.005, decay: 0.3, sustain: 0.4, release: 1.2 }
            }).connect(reverb);
            break;
        case 'electric-piano':
            synth = new Tone.PolySynth(Tone.FMSynth, {
                harmonicity: 2,
                modulationIndex: 2,
                envelope: { attack: 0.01, decay: 0.2, sustain: 0.3, release: 1 }
            }).connect(reverb);
            break;
        case 'synth':
            synth = new Tone.PolySynth(Tone.Synth, {
                oscillator: { type: 'sawtooth' },
                envelope: { attack: 0.01, decay: 0.2, sustain: 0.6, release: 0.8 }
            }).connect(reverb);
            break;
        case 'organ':
            synth = new Tone.PolySynth(Tone.Synth, {
                oscillator: { type: 'sine' },
                envelope: { attack: 0.001, decay: 0, sustain: 1, release: 0.4 }
            }).connect(reverb);
            break;
        case 'guitar':
            synth = new Tone.PolySynth(Tone.Synth, {
                oscillator: { type: 'triangle' },
                envelope: { attack: 0.01, decay: 0.5, sustain: 0.2, release: 2 }
            }).connect(reverb);
            break;
        case 'strings':
            synth = new Tone.PolySynth(Tone.Synth, {
                oscillator: { type: 'sawtooth' },
                envelope: { attack: 0.3, decay: 0.2, sustain: 0.8, release: 1.5 }
            }).connect(reverb);
            break;
        case 'brass':
            synth = new Tone.PolySynth(Tone.Synth, {
                oscillator: { type: 'square' },
                envelope: { attack: 0.1, decay: 0.2, sustain: 0.7, release: 0.8 }
            }).connect(reverb);
            break;
        case 'bass':
            synth = new Tone.PolySynth(Tone.Synth, {
                oscillator: { type: 'triangle' },
                envelope: { attack: 0.01, decay: 0.3, sustain: 0.5, release: 1 },
                volume: 3
            }).connect(reverb);
            break;
        case 'harpsichord':
            synth = new Tone.PolySynth(Tone.Synth, {
                oscillator: { type: 'square' },
                envelope: { attack: 0.001, decay: 0.3, sustain: 0, release: 0.3 }
            }).connect(reverb);
            break;
    }

    // Apply current volume
    const volume = parseInt(volumeSlider.value);
    synth.volume.value = Tone.gainToDb(volume / 100);
}

function toggleRecording() {
    if (!isRecording) {
        // Start recording
        isRecording = true;
        recordedNotes = [];
        recordStartTime = Date.now();
        recordBtn.classList.add('recording');
        recordBtn.innerHTML = '<span>⏹️</span><span>Stop</span>';
    } else {
        // Stop recording
        isRecording = false;
        recordBtn.classList.remove('recording');
        recordBtn.innerHTML = '<span>⏺️</span><span>Record</span>';

        if (recordedNotes.length > 0) {
            playBtn.style.display = 'flex';
            clearBtn.style.display = 'flex';
            // Show download button
            const downloadBtn = document.getElementById('downloadBtn');
            if (downloadBtn) downloadBtn.style.display = 'flex';
        }
    }
}

async function playRecording() {
    if (recordedNotes.length === 0) return;

    playBtn.disabled = true;
    playBtn.innerHTML = '<span>⏸️</span><span>Playing...</span>';

    const startTime = Tone.now();

    for (const event of recordedNotes) {
        const playTime = startTime + (event.timestamp / 1000);

        if (event.type === 'start') {
            synth.triggerAttack(event.note, playTime);

            // Visual feedback
            setTimeout(() => {
                const keyElement = findKeyElement(event.note);
                if (keyElement) keyElement.classList.add('active');
            }, event.timestamp);
        } else {
            synth.triggerRelease(event.note, playTime);

            // Visual feedback
            setTimeout(() => {
                const keyElement = findKeyElement(event.note);
                if (keyElement) keyElement.classList.remove('active');
            }, event.timestamp);
        }
    }

    // Re-enable button after playback
    const duration = recordedNotes[recordedNotes.length - 1].timestamp;
    setTimeout(() => {
        playBtn.disabled = false;
        playBtn.innerHTML = '<span>▶️</span><span>Play</span>';
    }, duration + 500);
}

function clearRecording() {
    recordedNotes = [];
    playBtn.style.display = 'none';
    clearBtn.style.display = 'none';
    const downloadBtn = document.getElementById('downloadBtn');
    if (downloadBtn) downloadBtn.style.display = 'none';
}

// Song Learning Feature
const songs = {
    'happy-birthday': {
        name: 'Happy Birthday',
        notes: [
            { note: 'C4', duration: 0.5 },
            { note: 'C4', duration: 0.5 },
            { note: 'D4', duration: 1 },
            { note: 'C4', duration: 1 },
            { note: 'F4', duration: 1 },
            { note: 'E4', duration: 2 }
        ]
    },
    'twinkle': {
        name: 'Twinkle Twinkle Little Star',
        notes: [
            { note: 'C4', duration: 0.5 },
            { note: 'C4', duration: 0.5 },
            { note: 'G4', duration: 0.5 },
            { note: 'G4', duration: 0.5 },
            { note: 'A4', duration: 0.5 },
            { note: 'A4', duration: 0.5 },
            { note: 'G4', duration: 1 }
        ]
    },
    'mary-lamb': {
        name: 'Mary Had a Little Lamb',
        notes: [
            { note: 'E4', duration: 0.5 },
            { note: 'D4', duration: 0.5 },
            { note: 'C4', duration: 0.5 },
            { note: 'D4', duration: 0.5 },
            { note: 'E4', duration: 0.5 },
            { note: 'E4', duration: 0.5 },
            { note: 'E4', duration: 1 }
        ]
    },
    'jingle-bells': {
        name: 'Jingle Bells',
        notes: [
            { note: 'E4', duration: 0.5 },
            { note: 'E4', duration: 0.5 },
            { note: 'E4', duration: 1 },
            { note: 'E4', duration: 0.5 },
            { note: 'E4', duration: 0.5 },
            { note: 'E4', duration: 1 },
            { note: 'E4', duration: 0.5 },
            { note: 'G4', duration: 0.5 },
            { note: 'C4', duration: 0.5 },
            { note: 'D4', duration: 0.5 },
            { note: 'E4', duration: 2 }
        ]
    },
    'fur-elise': {
        name: 'Für Elise',
        notes: [
            { note: 'E5', duration: 0.3 },
            { note: 'D#5', duration: 0.3 },
            { note: 'E5', duration: 0.3 },
            { note: 'D#5', duration: 0.3 },
            { note: 'E5', duration: 0.3 },
            { note: 'B4', duration: 0.3 },
            { note: 'D5', duration: 0.3 },
            { note: 'C5', duration: 0.3 },
            { note: 'A4', duration: 1 }
        ]
    },
    'ode-to-joy': {
        name: 'Ode to Joy',
        notes: [
            { note: 'E4', duration: 0.5 },
            { note: 'E4', duration: 0.5 },
            { note: 'F4', duration: 0.5 },
            { note: 'G4', duration: 0.5 },
            { note: 'G4', duration: 0.5 },
            { note: 'F4', duration: 0.5 },
            { note: 'E4', duration: 0.5 },
            { note: 'D4', duration: 0.5 }
        ]
    }
};

let currentSong = null;
let currentNoteIndex = 0;

// Setup song card listeners
document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.song-card').forEach(card => {
        card.addEventListener('click', () => {
            const songId = card.dataset.song;
            loadSong(songId, card);
        });
    });

    // Download button
    const downloadBtn = document.getElementById('downloadBtn');
    if (downloadBtn) {
        downloadBtn.addEventListener('click', downloadRecording);
    }
});

function loadSong(songId, cardElement) {
    // Clear previous selection
    document.querySelectorAll('.song-card').forEach(c => c.classList.remove('active'));
    document.querySelectorAll('.piano-key').forEach(k => k.classList.remove('highlight-key'));

    // Set new song
    currentSong = songs[songId];
    currentNoteIndex = 0;
    cardElement.classList.add('active');

    // Highlight first note
    if (currentSong && currentSong.notes.length > 0) {
        highlightNextNote();
    }
}

function highlightNextNote() {
    // Remove previous highlights
    document.querySelectorAll('.piano-key').forEach(k => k.classList.remove('highlight-key'));

    if (!currentSong || currentNoteIndex >= currentSong.notes.length) {
        currentNoteIndex = 0;
        return;
    }

    const nextNote = currentSong.notes[currentNoteIndex];
    const keyElement = findKeyElement(nextNote.note);

    if (keyElement) {
        keyElement.classList.add('highlight-key');

        // Auto-play the note
        setTimeout(() => {
            playNote(nextNote.note, keyElement);
            setTimeout(() => {
                stopNote(nextNote.note, keyElement);
                currentNoteIndex++;

                // Highlight next note after a delay
                setTimeout(() => {
                    highlightNextNote();
                }, nextNote.duration * 500);
            }, nextNote.duration * 400);
        }, 100);
    }
}

// Download Recording Feature
function downloadRecording() {
    if (recordedNotes.length === 0) return;

    // Create a simple MIDI-like text format
    let midiText = 'Virtual Piano Recording\n';
    midiText += `Recorded: ${new Date().toLocaleString()}\n`;
    midiText += `Notes: ${recordedNotes.length}\n\n`;

    recordedNotes.forEach((event, index) => {
        midiText += `${index + 1}. ${event.note} - ${event.type} at ${event.timestamp}ms\n`;
    });

    // Create blob and download
    const blob = new Blob([midiText], { type: 'text/plain' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `piano-recording-${Date.now()}.txt`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
}

