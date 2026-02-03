// Ukulele Chord Finder - Interactive chord diagrams with audio
// Standard tuning: G C E A (re-entrant tuning)

// Ukulele chord database (fret positions for G C E A strings)
const ukuleleChords = {
    // Major Chords
    'C': { frets: [0, 0, 0, 3], fingers: [0, 0, 0, 3], notes: ['C', 'E', 'G'] },
    'C#': { frets: [1, 1, 1, 4], fingers: [1, 1, 1, 4], notes: ['C#', 'F', 'G#'] },
    'D': { frets: [2, 2, 2, 0], fingers: [1, 2, 3, 0], notes: ['D', 'F#', 'A'] },
    'D#': { frets: [0, 3, 3, 1], fingers: [0, 3, 4, 1], notes: ['D#', 'G', 'A#'] },
    'E': { frets: [4, 4, 4, 2], fingers: [2, 3, 4, 1], notes: ['E', 'G#', 'B'] },
    'F': { frets: [2, 0, 1, 0], fingers: [2, 0, 1, 0], notes: ['F', 'A', 'C'] },
    'F#': { frets: [3, 1, 2, 1], fingers: [4, 1, 3, 2], notes: ['F#', 'A#', 'C#'] },
    'G': { frets: [0, 2, 3, 2], fingers: [0, 1, 3, 2], notes: ['G', 'B', 'D'] },
    'G#': { frets: [5, 3, 4, 3], fingers: [4, 1, 3, 2], notes: ['G#', 'C', 'D#'] },
    'A': { frets: [2, 1, 0, 0], fingers: [2, 1, 0, 0], notes: ['A', 'C#', 'E'] },
    'A#': { frets: [3, 2, 1, 1], fingers: [4, 3, 1, 2], notes: ['A#', 'D', 'F'] },
    'B': { frets: [4, 3, 2, 2], fingers: [4, 3, 1, 2], notes: ['B', 'D#', 'F#'] },

    // Minor Chords
    'Cm': { frets: [0, 3, 3, 3], fingers: [0, 1, 2, 3], notes: ['C', 'Eb', 'G'] },
    'C#m': { frets: [1, 1, 0, 4], fingers: [1, 2, 0, 4], notes: ['C#', 'E', 'G#'] },
    'Dm': { frets: [2, 2, 1, 0], fingers: [2, 3, 1, 0], notes: ['D', 'F', 'A'] },
    'D#m': { frets: [3, 3, 2, 1], fingers: [3, 4, 2, 1], notes: ['D#', 'F#', 'A#'] },
    'Em': { frets: [0, 4, 3, 2], fingers: [0, 4, 3, 2], notes: ['E', 'G', 'B'] },
    'Fm': { frets: [1, 0, 1, 3], fingers: [1, 0, 2, 4], notes: ['F', 'Ab', 'C'] },
    'F#m': { frets: [2, 1, 2, 0], fingers: [2, 1, 3, 0], notes: ['F#', 'A', 'C#'] },
    'Gm': { frets: [0, 2, 3, 1], fingers: [0, 2, 4, 1], notes: ['G', 'Bb', 'D'] },
    'G#m': { frets: [1, 3, 4, 2], fingers: [1, 3, 4, 2], notes: ['G#', 'B', 'D#'] },
    'Am': { frets: [2, 0, 0, 0], fingers: [2, 0, 0, 0], notes: ['A', 'C', 'E'] },
    'A#m': { frets: [3, 1, 1, 1], fingers: [4, 1, 2, 3], notes: ['A#', 'C#', 'F'] },
    'Bm': { frets: [4, 2, 2, 2], fingers: [4, 1, 2, 3], notes: ['B', 'D', 'F#'] },

    // 7th Chords
    'C7': { frets: [0, 0, 0, 1], fingers: [0, 0, 0, 1], notes: ['C', 'E', 'G', 'Bb'] },
    'D7': { frets: [2, 2, 2, 3], fingers: [1, 2, 3, 4], notes: ['D', 'F#', 'A', 'C'] },
    'E7': { frets: [1, 2, 0, 2], fingers: [1, 3, 0, 4], notes: ['E', 'G#', 'B', 'D'] },
    'F7': { frets: [2, 3, 1, 0], fingers: [2, 4, 1, 0], notes: ['F', 'A', 'C', 'Eb'] },
    'G7': { frets: [0, 2, 1, 2], fingers: [0, 2, 1, 3], notes: ['G', 'B', 'D', 'F'] },
    'A7': { frets: [0, 1, 0, 0], fingers: [0, 1, 0, 0], notes: ['A', 'C#', 'E', 'G'] },
    'B7': { frets: [2, 3, 2, 2], fingers: [1, 4, 2, 3], notes: ['B', 'D#', 'F#', 'A'] },

    // Major 7th
    'Cmaj7': { frets: [0, 0, 0, 2], fingers: [0, 0, 0, 2], notes: ['C', 'E', 'G', 'B'] },
    'Dmaj7': { frets: [2, 2, 2, 4], fingers: [1, 2, 3, 4], notes: ['D', 'F#', 'A', 'C#'] },
    'Gmaj7': { frets: [0, 2, 2, 2], fingers: [0, 1, 2, 3], notes: ['G', 'B', 'D', 'F#'] },
    'Amaj7': { frets: [1, 1, 0, 0], fingers: [1, 2, 0, 0], notes: ['A', 'C#', 'E', 'G#'] },

    // Minor 7th
    'Cm7': { frets: [3, 3, 3, 3], fingers: [1, 2, 3, 4], notes: ['C', 'Eb', 'G', 'Bb'] },
    'Dm7': { frets: [2, 2, 1, 3], fingers: [2, 3, 1, 4], notes: ['D', 'F', 'A', 'C'] },
    'Em7': { frets: [0, 2, 0, 2], fingers: [0, 1, 0, 2], notes: ['E', 'G', 'B', 'D'] },
    'Am7': { frets: [0, 0, 0, 0], fingers: [0, 0, 0, 0], notes: ['A', 'C', 'E', 'G'] },

    // Suspended
    'Csus2': { frets: [0, 2, 3, 3], fingers: [0, 1, 2, 3], notes: ['C', 'D', 'G'] },
    'Csus4': { frets: [0, 0, 1, 3], fingers: [0, 0, 1, 3], notes: ['C', 'F', 'G'] },
    'Dsus2': { frets: [2, 2, 0, 0], fingers: [1, 2, 0, 0], notes: ['D', 'E', 'A'] },
    'Dsus4': { frets: [0, 2, 3, 0], fingers: [0, 1, 3, 0], notes: ['D', 'G', 'A'] },
    'Gsus4': { frets: [0, 2, 3, 3], fingers: [0, 1, 2, 3], notes: ['G', 'C', 'D'] },
    'Asus4': { frets: [2, 2, 0, 0], fingers: [1, 2, 0, 0], notes: ['A', 'D', 'E'] },
};

// Note frequencies for GCEA tuning
const stringNotes = {
    'G': 392.00,  // G4
    'C': 261.63,  // C4
    'E': 329.63,  // E4
    'A': 440.00   // A4
};

// Semitone ratios
const semitone = Math.pow(2, 1 / 12);

// State
let currentRoot = 'C';
let currentType = '';
let audioContext = null;
let synth = null;

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    initAudio();
    renderNoteButtons();
    renderChordTypeButtons();
    displayChord('C', '');
    setupEventListeners();
});

function initAudio() {
    try {
        synth = new Tone.PolySynth(Tone.Synth, {
            oscillator: { type: 'triangle' },
            envelope: {
                attack: 0.02,
                decay: 0.3,
                sustain: 0.4,
                release: 1.5
            }
        }).toDestination();
    } catch (e) {
        console.warn('Audio initialization failed:', e);
    }
}

function renderNoteButtons() {
    const container = document.getElementById('rootNoteButtons');
    const notes = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];

    notes.forEach(note => {
        const btn = document.createElement('button');
        btn.className = 'note-btn';
        btn.textContent = note;
        btn.dataset.note = note;
        if (note === 'C') btn.classList.add('active');
        btn.addEventListener('click', () => selectNote(note));
        container.appendChild(btn);
    });
}

function renderChordTypeButtons() {
    const container = document.getElementById('chordTypeButtons');
    const types = [
        { value: '', label: 'Major' },
        { value: 'm', label: 'Minor' },
        { value: '7', label: '7th' },
        { value: 'maj7', label: 'Maj7' },
        { value: 'm7', label: 'Min7' },
        { value: 'sus2', label: 'Sus2' },
        { value: 'sus4', label: 'Sus4' }
    ];

    types.forEach(type => {
        const btn = document.createElement('button');
        btn.className = 'chord-type-btn';
        btn.textContent = type.label;
        btn.dataset.type = type.value;
        if (type.value === '') btn.classList.add('active');
        btn.addEventListener('click', () => selectChordType(type.value));
        container.appendChild(btn);
    });
}

function selectNote(note) {
    currentRoot = note;
    document.querySelectorAll('.note-btn').forEach(btn => {
        btn.classList.toggle('active', btn.dataset.note === note);
    });
    displayChord(currentRoot, currentType);
}

function selectChordType(type) {
    currentType = type;
    document.querySelectorAll('.chord-type-btn').forEach(btn => {
        btn.classList.toggle('active', btn.dataset.type === type);
    });
    displayChord(currentRoot, currentType);
}

function displayChord(root, type) {
    const chordName = root + type;
    const chord = ukuleleChords[chordName];

    if (!chord) {
        console.warn('Chord not found:', chordName);
        return;
    }

    // Update chord name
    const typeName = type === '' ? 'Major' :
        type === 'm' ? 'Minor' :
            type === '7' ? 'Seventh' :
                type === 'maj7' ? 'Major 7th' :
                    type === 'm7' ? 'Minor 7th' :
                        type === 'sus2' ? 'Suspended 2nd' :
                            type === 'sus4' ? 'Suspended 4th' : type;

    document.getElementById('currentChordName').textContent = `${root} ${typeName}`;
    document.getElementById('chordNotes').textContent = chord.notes.join(' - ');
    document.getElementById('chordFingering').textContent = chord.frets.join(' ');

    // Draw diagram
    drawUkuleleDiagram(chord.frets, chord.fingers);
}

function drawUkuleleDiagram(frets, fingers) {
    const canvas = document.getElementById('ukuleleCanvas');
    const ctx = canvas.getContext('2d');
    const width = canvas.width;
    const height = canvas.height;

    // Clear canvas
    ctx.clearRect(0, 0, width, height);

    // Colors
    const isDark = document.documentElement.classList.contains('dark-mode');
    const lineColor = isDark ? '#64748b' : '#475569';
    const dotColor = isDark ? '#6366f1' : '#4f46e5';
    const textColor = isDark ? '#e2e8f0' : '#0f172a';

    // Dimensions
    const padding = 40;
    const stringSpacing = (width - 2 * padding) / 3;
    const fretHeight = 60;
    const numFrets = 5;

    // Find highest fret to determine starting position
    const maxFret = Math.max(...frets.filter(f => f > 0));
    const startFret = maxFret > 4 ? maxFret - 3 : 0;

    // Draw fret position indicator
    if (startFret > 0) {
        ctx.fillStyle = textColor;
        ctx.font = 'bold 14px Inter';
        ctx.textAlign = 'right';
        ctx.fillText(`${startFret}fr`, padding - 10, padding + fretHeight);
    }

    // Draw strings (vertical lines)
    ctx.strokeStyle = lineColor;
    ctx.lineWidth = 2;
    for (let i = 0; i < 4; i++) {
        const x = padding + i * stringSpacing;
        ctx.beginPath();
        ctx.moveTo(x, padding);
        ctx.lineTo(x, padding + numFrets * fretHeight);
        ctx.stroke();
    }

    // Draw frets (horizontal lines)
    for (let i = 0; i <= numFrets; i++) {
        const y = padding + i * fretHeight;
        ctx.lineWidth = i === 0 && startFret === 0 ? 4 : 2;
        ctx.beginPath();
        ctx.moveTo(padding, y);
        ctx.lineTo(padding + 3 * stringSpacing, y);
        ctx.stroke();
    }

    // Draw string labels
    ctx.fillStyle = textColor;
    ctx.font = '12px Inter';
    ctx.textAlign = 'center';
    const stringNames = ['G', 'C', 'E', 'A'];
    stringNames.forEach((name, i) => {
        const x = padding + i * stringSpacing;
        ctx.fillText(name, x, padding - 15);
    });

    // Draw finger positions
    frets.forEach((fret, stringIndex) => {
        const x = padding + stringIndex * stringSpacing;

        if (fret === 0) {
            // Open string - draw circle above nut
            ctx.strokeStyle = dotColor;
            ctx.lineWidth = 2;
            ctx.beginPath();
            ctx.arc(x, padding - 5, 8, 0, 2 * Math.PI);
            ctx.stroke();
        } else {
            // Fretted note - draw filled circle
            const displayFret = fret - startFret;
            if (displayFret >= 0 && displayFret <= numFrets) {
                const y = padding + (displayFret - 0.5) * fretHeight;

                // Draw dot
                ctx.fillStyle = dotColor;
                ctx.beginPath();
                ctx.arc(x, y, 12, 0, 2 * Math.PI);
                ctx.fill();

                // Draw finger number
                if (fingers[stringIndex] > 0) {
                    ctx.fillStyle = 'white';
                    ctx.font = 'bold 14px Inter';
                    ctx.textAlign = 'center';
                    ctx.textBaseline = 'middle';
                    ctx.fillText(fingers[stringIndex], x, y);
                }
            }
        }
    });
}

function setupEventListeners() {
    // Play chord button
    document.getElementById('playChordBtn').addEventListener('click', playCurrentChord);

    // Progression buttons
    document.querySelectorAll('.progression-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            const progression = btn.dataset.progression.split(',');
            playProgression(progression);
        });
    });

    // Dark mode listener
    const observer = new MutationObserver(() => {
        displayChord(currentRoot, currentType);
    });
    observer.observe(document.documentElement, { attributes: true, attributeFilter: ['class'] });
}

function playCurrentChord() {
    if (!synth) return;

    const chordName = currentRoot + currentType;
    const chord = ukuleleChords[chordName];
    if (!chord) return;

    const frequencies = chord.frets.map((fret, i) => {
        const stringName = ['G', 'C', 'E', 'A'][i];
        const baseFreq = stringNotes[stringName];
        return baseFreq * Math.pow(semitone, fret);
    });

    synth.triggerAttackRelease(frequencies, '2n');
}

async function playProgression(chordNames) {
    if (!synth) return;

    for (const chordName of chordNames) {
        const chord = ukuleleChords[chordName.trim()];
        if (!chord) continue;

        // Update display
        const root = chordName.replace(/[^A-G#]/g, '');
        const type = chordName.replace(root, '');
        selectNote(root);
        selectChordType(type);

        // Play chord
        const frequencies = chord.frets.map((fret, i) => {
            const stringName = ['G', 'C', 'E', 'A'][i];
            const baseFreq = stringNotes[stringName];
            return baseFreq * Math.pow(semitone, fret);
        });

        synth.triggerAttackRelease(frequencies, '1n');
        await new Promise(resolve => setTimeout(resolve, 1000));
    }
}
