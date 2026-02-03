// Music Transpose Tool - Change song keys and transpose chords

// Chromatic scale (sharps)
const chromaticScale = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];

// Enharmonic equivalents (for display)
const enharmonics = {
    'C#': 'Db', 'D#': 'Eb', 'F#': 'Gb', 'G#': 'Ab', 'A#': 'Bb'
};

// Chord pattern regex - matches chords like C, Cm, C7, Cmaj7, etc.
const chordRegex = /\b([A-G][#b]?)(m|maj|min|dim|aug|sus|add)?(\d+|(\d+[#b]?\d*))?(\/(([A-G][#b]?)))?/g;

// DOM Elements
const fromKeySelect = document.getElementById('fromKey');
const toKeySelect = document.getElementById('toKey');
const inputChords = document.getElementById('inputChords');
const outputChords = document.getElementById('outputChords');
const copyBtn = document.getElementById('copyBtn');
const capoSuggestion = document.getElementById('capoSuggestion');
const semitoneButtons = document.querySelectorAll('.semitone-btn');
const exampleCards = document.querySelectorAll('.example-card');

// State
let currentSemitones = 0;

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    setupEventListeners();
    transpose(); // Initial transpose
});

function setupEventListeners() {
    // Key selectors
    fromKeySelect.addEventListener('change', () => {
        updateSemitones();
        transpose();
    });

    toKeySelect.addEventListener('change', () => {
        updateSemitones();
        transpose();
    });

    // Input textarea
    inputChords.addEventListener('input', transpose);

    // Semitone buttons
    semitoneButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            const semitones = parseInt(btn.dataset.semitones);
            transposeBySemitones(semitones);
        });
    });

    // Swap keys button
    const swapBtn = document.getElementById('swapKeys');
    if (swapBtn) {
        swapBtn.addEventListener('click', swapKeys);
    }

    // Copy button
    copyBtn.addEventListener('click', copyToClipboard);

    // Example cards
    exampleCards.forEach(card => {
        card.addEventListener('click', () => {
            const example = card.dataset.example;
            inputChords.value = example;
            transpose();
        });
    });
}

function swapKeys() {
    const fromValue = fromKeySelect.value;
    const toValue = toKeySelect.value;
    fromKeySelect.value = toValue;
    toKeySelect.value = fromValue;
    updateSemitones();
    transpose();
}

function updateSemitones() {
    const fromIndex = chromaticScale.indexOf(fromKeySelect.value);
    const toIndex = chromaticScale.indexOf(toKeySelect.value);
    currentSemitones = (toIndex - fromIndex + 12) % 12;
    updateSemitoneButtons();
    updateCapoSuggestion();
}

function transposeBySemitones(semitones) {
    currentSemitones = semitones;

    // Update key selectors
    const fromIndex = chromaticScale.indexOf(fromKeySelect.value);
    let toIndex = (fromIndex + semitones + 12) % 12;
    if (toIndex < 0) toIndex += 12;

    toKeySelect.value = chromaticScale[toIndex];

    updateSemitoneButtons();
    updateCapoSuggestion();
    transpose();
}

function updateSemitoneButtons() {
    semitoneButtons.forEach(btn => {
        const semitones = parseInt(btn.dataset.semitones);
        btn.classList.toggle('active', semitones === currentSemitones);
    });
}

function updateCapoSuggestion() {
    if (currentSemitones === 0) {
        capoSuggestion.style.display = 'none';
        return;
    }

    const fromKey = fromKeySelect.value;
    const toKey = toKeySelect.value;

    if (currentSemitones > 0 && currentSemitones <= 11) {
        capoSuggestion.textContent = `💡 Tip: Use capo on fret ${currentSemitones} and play ${fromKey} shapes to get ${toKey}`;
        capoSuggestion.style.display = 'block';
    } else {
        capoSuggestion.style.display = 'none';
    }
}

function transpose() {
    const input = inputChords.value;

    if (!input.trim()) {
        outputChords.value = '';
        return;
    }

    // Transpose all chords in the input
    const transposed = input.replace(chordRegex, (match, root, quality, extension, _, __, slash, slashNote) => {
        // Transpose root note
        const transposedRoot = transposeNote(root, currentSemitones);

        // Transpose slash bass note if present
        const transposedSlash = slashNote ? '/' + transposeNote(slashNote, currentSemitones) : '';

        // Reconstruct chord
        return transposedRoot + (quality || '') + (extension || '') + transposedSlash;
    });

    outputChords.value = transposed;
}

function transposeNote(note, semitones) {
    // Normalize note (convert flats to sharps)
    let normalizedNote = note;
    if (note.includes('b')) {
        const flatToSharp = {
            'Db': 'C#', 'Eb': 'D#', 'Gb': 'F#', 'Ab': 'G#', 'Bb': 'A#'
        };
        normalizedNote = flatToSharp[note] || note;
    }

    // Find index in chromatic scale
    const index = chromaticScale.indexOf(normalizedNote);
    if (index === -1) return note; // Return original if not found

    // Calculate new index
    let newIndex = (index + semitones) % 12;
    if (newIndex < 0) newIndex += 12;

    return chromaticScale[newIndex];
}

async function copyToClipboard() {
    const text = outputChords.value;

    if (!text.trim()) {
        return;
    }

    try {
        await navigator.clipboard.writeText(text);

        // Visual feedback
        const originalText = copyBtn.textContent;
        copyBtn.textContent = '✓ Copied!';
        copyBtn.style.background = '#22c55e';

        setTimeout(() => {
            copyBtn.textContent = originalText;
            copyBtn.style.background = '';
        }, 2000);
    } catch (err) {
        console.error('Failed to copy:', err);

        // Fallback: select text
        outputChords.select();
        document.execCommand('copy');

        copyBtn.textContent = '✓ Copied!';
        setTimeout(() => {
            copyBtn.textContent = '📋 Copy';
        }, 2000);
    }
}
