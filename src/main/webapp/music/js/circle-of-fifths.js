// Circle of Fifths - Interactive music theory visualization
// Canvas-based circular diagram with clickable keys

// Music theory data
const majorKeys = ['C', 'G', 'D', 'A', 'E', 'B', 'F#', 'Db', 'Ab', 'Eb', 'Bb', 'F'];
const minorKeys = ['Am', 'Em', 'Bm', 'F#m', 'C#m', 'G#m', 'D#m', 'Bbm', 'Fm', 'Cm', 'Gm', 'Dm'];

// Key signature data (sharps/flats)
const keySignatures = {
    'C': { sharps: 0, flats: 0, desc: 'No sharps or flats' },
    'G': { sharps: 1, flats: 0, desc: '1 sharp (F#)' },
    'D': { sharps: 2, flats: 0, desc: '2 sharps (F#, C#)' },
    'A': { sharps: 3, flats: 0, desc: '3 sharps (F#, C#, G#)' },
    'E': { sharps: 4, flats: 0, desc: '4 sharps (F#, C#, G#, D#)' },
    'B': { sharps: 5, flats: 0, desc: '5 sharps (F#, C#, G#, D#, A#)' },
    'F#': { sharps: 6, flats: 0, desc: '6 sharps (F#, C#, G#, D#, A#, E#)' },
    'Db': { sharps: 0, flats: 5, desc: '5 flats (Bb, Eb, Ab, Db, Gb)' },
    'Ab': { sharps: 0, flats: 4, desc: '4 flats (Bb, Eb, Ab, Db)' },
    'Eb': { sharps: 0, flats: 3, desc: '3 flats (Bb, Eb, Ab)' },
    'Bb': { sharps: 0, flats: 2, desc: '2 flats (Bb, Eb)' },
    'F': { sharps: 0, flats: 1, desc: '1 flat (Bb)' }
};

// Scale notes for each key
const scaleNotes = {
    'C': ['C', 'D', 'E', 'F', 'G', 'A', 'B'],
    'G': ['G', 'A', 'B', 'C', 'D', 'E', 'F#'],
    'D': ['D', 'E', 'F#', 'G', 'A', 'B', 'C#'],
    'A': ['A', 'B', 'C#', 'D', 'E', 'F#', 'G#'],
    'E': ['E', 'F#', 'G#', 'A', 'B', 'C#', 'D#'],
    'B': ['B', 'C#', 'D#', 'E', 'F#', 'G#', 'A#'],
    'F#': ['F#', 'G#', 'A#', 'B', 'C#', 'D#', 'E#'],
    'Db': ['Db', 'Eb', 'F', 'Gb', 'Ab', 'Bb', 'C'],
    'Ab': ['Ab', 'Bb', 'C', 'Db', 'Eb', 'F', 'G'],
    'Eb': ['Eb', 'F', 'G', 'Ab', 'Bb', 'C', 'D'],
    'Bb': ['Bb', 'C', 'D', 'Eb', 'F', 'G', 'A'],
    'F': ['F', 'G', 'A', 'Bb', 'C', 'D', 'E']
};

// Chord progressions (I, ii, iii, IV, V, vi, vii°)
const chordQualities = ['', 'm', 'm', '', '', 'm', 'dim'];

// State
let selectedKey = 'C';
let selectedType = 'major';
let synth = null;
let polySynth = null;

// DOM Elements
const canvas = document.getElementById('circleCanvas');
const ctx = canvas.getContext('2d');
const keyName = document.getElementById('keyName');
const keyType = document.getElementById('keyType');
const keySignature = document.getElementById('keySignature');
const scaleNotesEl = document.getElementById('scaleNotes');
const chordList = document.getElementById('chordList');
const relativeKey = document.getElementById('relativeKey');
const playScaleBtn = document.getElementById('playScaleBtn');
const playProgressionBtn = document.getElementById('playProgressionBtn');

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    initAudio();
    drawCircle();
    updateKeyInfo();
    setupEventListeners();
});

function initAudio() {
    synth = new Tone.Synth({
        oscillator: { type: 'triangle' },
        envelope: {
            attack: 0.005,
            decay: 0.1,
            sustain: 0.3,
            release: 0.8
        }
    }).toDestination();

    // PolySynth for playing chords
    polySynth = new Tone.PolySynth(Tone.Synth, {
        oscillator: { type: 'triangle' },
        envelope: {
            attack: 0.02,
            decay: 0.1,
            sustain: 0.3,
            release: 1
        }
    }).toDestination();
    polySynth.volume.value = -6;
}

function setupEventListeners() {
    canvas.addEventListener('click', handleCanvasClick);
    playScaleBtn.addEventListener('click', playScale);

    if (playProgressionBtn) {
        playProgressionBtn.addEventListener('click', playProgression);
    }

    // Redraw on dark mode change
    const observer = new MutationObserver(() => {
        drawCircle();
    });
    observer.observe(document.documentElement, { attributes: true, attributeFilter: ['class'] });
}

function drawCircle() {
    const width = canvas.width;
    const height = canvas.height;
    const centerX = width / 2;
    const centerY = height / 2;
    const outerRadius = 250;
    const innerRadius = 150;
    const middleRadius = 200;

    // Clear canvas
    ctx.clearRect(0, 0, width, height);

    // Colors
    const isDark = document.documentElement.classList.contains('dark-mode');
    const bgColor = isDark ? '#1e293b' : '#f8fafc';
    const textColor = isDark ? '#e2e8f0' : '#0f172a';
    const borderColor = isDark ? '#475569' : '#cbd5e1';

    // Background
    ctx.fillStyle = bgColor;
    ctx.fillRect(0, 0, width, height);

    // Draw major keys (outer ring)
    for (let i = 0; i < 12; i++) {
        const angle = (i * 30 - 90) * Math.PI / 180;
        const nextAngle = ((i + 1) * 30 - 90) * Math.PI / 180;

        const key = majorKeys[i];
        const isSelected = selectedKey === key && selectedType === 'major';

        // Draw segment
        ctx.beginPath();
        ctx.moveTo(centerX, centerY);
        ctx.arc(centerX, centerY, outerRadius, angle, nextAngle);
        ctx.closePath();

        // Fill
        if (isSelected) {
            const gradient = ctx.createLinearGradient(centerX, centerY - outerRadius, centerX, centerY + outerRadius);
            gradient.addColorStop(0, '#6366f1');
            gradient.addColorStop(1, '#8b5cf6');
            ctx.fillStyle = gradient;
        } else {
            ctx.fillStyle = isDark ? '#334155' : '#e2e8f0';
        }
        ctx.fill();

        // Border
        ctx.strokeStyle = borderColor;
        ctx.lineWidth = 2;
        ctx.stroke();

        // Text
        const textAngle = angle + (nextAngle - angle) / 2;
        const textRadius = (outerRadius + middleRadius) / 2;
        const textX = centerX + Math.cos(textAngle) * textRadius;
        const textY = centerY + Math.sin(textAngle) * textRadius;

        ctx.fillStyle = isSelected ? 'white' : textColor;
        ctx.font = 'bold 20px Inter';
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        ctx.fillText(key, textX, textY);
    }

    // Draw minor keys (inner ring)
    for (let i = 0; i < 12; i++) {
        const angle = (i * 30 - 90) * Math.PI / 180;
        const nextAngle = ((i + 1) * 30 - 90) * Math.PI / 180;

        const key = minorKeys[i];
        const majorKey = key.replace('m', '');
        const isSelected = selectedKey === majorKey && selectedType === 'minor';

        // Draw segment
        ctx.beginPath();
        ctx.moveTo(centerX, centerY);
        ctx.arc(centerX, centerY, middleRadius, angle, nextAngle);
        ctx.closePath();

        // Fill
        if (isSelected) {
            const gradient = ctx.createLinearGradient(centerX, centerY - middleRadius, centerX, centerY + middleRadius);
            gradient.addColorStop(0, '#ec4899');
            gradient.addColorStop(1, '#db2777');
            ctx.fillStyle = gradient;
        } else {
            ctx.fillStyle = isDark ? '#1e293b' : '#f1f5f9';
        }
        ctx.fill();

        // Border
        ctx.strokeStyle = borderColor;
        ctx.lineWidth = 2;
        ctx.stroke();

        // Text
        const textAngle = angle + (nextAngle - angle) / 2;
        const textRadius = (middleRadius + innerRadius) / 2;
        const textX = centerX + Math.cos(textAngle) * textRadius;
        const textY = centerY + Math.sin(textAngle) * textRadius;

        ctx.fillStyle = isSelected ? 'white' : textColor;
        ctx.font = 'bold 16px Inter';
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        ctx.fillText(key, textX, textY);
    }

    // Center circle
    ctx.beginPath();
    ctx.arc(centerX, centerY, innerRadius, 0, 2 * Math.PI);
    ctx.fillStyle = isDark ? '#0f172a' : '#ffffff';
    ctx.fill();
    ctx.strokeStyle = borderColor;
    ctx.lineWidth = 3;
    ctx.stroke();

    // Center text
    ctx.fillStyle = textColor;
    ctx.font = 'bold 24px Inter';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText('Circle of', centerX, centerY - 15);
    ctx.fillText('Fifths', centerX, centerY + 15);
}

function handleCanvasClick(e) {
    const rect = canvas.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;

    const centerX = canvas.width / 2;
    const centerY = canvas.height / 2;
    const outerRadius = 250;
    const innerRadius = 150;
    const middleRadius = 200;

    // Calculate distance from center
    const dx = x - centerX;
    const dy = y - centerY;
    const distance = Math.sqrt(dx * dx + dy * dy);

    // Calculate angle
    let angle = Math.atan2(dy, dx) * 180 / Math.PI + 90;
    if (angle < 0) angle += 360;

    // Determine which segment was clicked
    const segment = Math.floor(angle / 30);

    // Check if click is in outer ring (major) or inner ring (minor)
    if (distance > middleRadius && distance < outerRadius) {
        // Major key clicked
        selectedKey = majorKeys[segment];
        selectedType = 'major';
    } else if (distance > innerRadius && distance < middleRadius) {
        // Minor key clicked
        const minorKey = minorKeys[segment];
        selectedKey = minorKey.replace('m', '');
        selectedType = 'minor';
    }

    drawCircle();
    updateKeyInfo();
}

function updateKeyInfo() {
    const key = selectedKey;
    const isMajor = selectedType === 'major';

    // Update key name
    keyName.textContent = `${key} ${isMajor ? 'Major' : 'Minor'}`;
    keyType.textContent = isMajor ? 'Major Key' : 'Minor Key';

    // Update key signature
    const sigInfo = keySignatures[key];
    if (sigInfo) {
        keySignature.textContent = sigInfo.desc;
    }

    // Update scale notes
    const notes = scaleNotes[key];
    if (notes) {
        if (isMajor) {
            scaleNotesEl.textContent = notes.join(' ');
        } else {
            // Natural minor scale (same as relative major, starting from 6th degree)
            const relativeIndex = majorKeys.indexOf(key);
            const relativeMajor = majorKeys[relativeIndex];
            const majorScale = scaleNotes[relativeMajor];
            const minorScale = [...majorScale.slice(5), ...majorScale.slice(0, 5)];
            scaleNotesEl.textContent = minorScale.join(' ');
        }
    }

    // Update chords in key
    chordList.innerHTML = '';
    if (notes) {
        const scale = isMajor ? notes : [...notes.slice(5), ...notes.slice(0, 5)];
        scale.forEach((note, i) => {
            const quality = isMajor ? chordQualities[i] : chordQualities[(i + 5) % 7];
            const badge = document.createElement('div');
            badge.className = 'chord-badge';
            badge.textContent = note + quality;
            chordList.appendChild(badge);
        });
    }

    // Update relative key
    const relativeIndex = majorKeys.indexOf(key);
    if (isMajor) {
        relativeKey.textContent = minorKeys[relativeIndex];
    } else {
        relativeKey.textContent = `${key} Major`;
    }
}

async function playScale() {
    if (!synth) return;

    playScaleBtn.disabled = true;
    playScaleBtn.textContent = '🔊 Playing...';

    const notes = scaleNotes[selectedKey];
    if (!notes) return;

    const scale = selectedType === 'major' ? notes : [...notes.slice(5), ...notes.slice(0, 5)];
    const octave = 4;

    for (let i = 0; i < scale.length; i++) {
        const note = scale[i] + octave;
        synth.triggerAttackRelease(note, '8n');
        await new Promise(resolve => setTimeout(resolve, 300));
    }

    // Play octave
    const rootNote = scale[0] + (octave + 1);
    synth.triggerAttackRelease(rootNote, '4n');

    setTimeout(() => {
        playScaleBtn.disabled = false;
        playScaleBtn.textContent = '🔊 Play Scale';
    }, 500);
}

// Chord note mappings (root, third, fifth)
function getChordNotes(root, quality, octave) {
    const chromatic = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];

    // Normalize root note
    let normalizedRoot = root;
    const flatToSharp = { 'Db': 'C#', 'Eb': 'D#', 'Gb': 'F#', 'Ab': 'G#', 'Bb': 'A#' };
    if (flatToSharp[root]) normalizedRoot = flatToSharp[root];

    const rootIndex = chromatic.indexOf(normalizedRoot);
    if (rootIndex === -1) return [];

    let intervals;
    if (quality === 'm' || quality === 'min') {
        intervals = [0, 3, 7]; // Minor chord
    } else if (quality === 'dim') {
        intervals = [0, 3, 6]; // Diminished chord
    } else {
        intervals = [0, 4, 7]; // Major chord
    }

    return intervals.map(interval => {
        const noteIndex = (rootIndex + interval) % 12;
        const noteOctave = rootIndex + interval >= 12 ? octave + 1 : octave;
        return chromatic[noteIndex] + noteOctave;
    });
}

async function playProgression() {
    if (!polySynth) return;

    await Tone.start();

    playProgressionBtn.disabled = true;
    playScaleBtn.disabled = true;
    playProgressionBtn.textContent = '🎵 Playing...';

    const notes = scaleNotes[selectedKey];
    if (!notes) return;

    const scale = selectedType === 'major' ? notes : [...notes.slice(5), ...notes.slice(0, 5)];
    const qualities = selectedType === 'major' ? chordQualities : ['m', 'dim', '', 'm', 'm', '', ''];

    // I-IV-V-I progression (indices 0, 3, 4, 0)
    const progressionIndices = [0, 3, 4, 0];
    const octave = 3;

    for (let i = 0; i < progressionIndices.length; i++) {
        const idx = progressionIndices[i];
        const root = scale[idx];
        const quality = qualities[idx];
        const chordNotes = getChordNotes(root, quality, octave);

        polySynth.triggerAttackRelease(chordNotes, '2n');
        await new Promise(resolve => setTimeout(resolve, 600));
    }

    setTimeout(() => {
        playProgressionBtn.disabled = false;
        playScaleBtn.disabled = false;
        playProgressionBtn.textContent = '🎵 Play I-IV-V-I';
    }, 500);
}
