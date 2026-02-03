// AI Piano Duet - Play music with Google Magenta AI
// Adapted from CodePen example with improvements

const MIN_NOTE = 48; // C3
const MAX_NOTE = 84; // C6

// Initialize Magenta Music RNN with Improv model
let rnn = new mm.MusicRNN(
    'https://storage.googleapis.com/download.magenta.tensorflow.org/tfjs_checkpoints/music_rnn/chord_pitches_improv'
);
let temperature = 1.1;

// ============ INSTRUMENT DEFINITIONS ============
const instruments = {
    marimba: {
        urls: {
            C3: 'plastic-marimba-c3.mp3',
            'D#3': 'plastic-marimba-ds3.mp3',
            'F#3': 'plastic-marimba-fs3.mp3',
            A3: 'plastic-marimba-a3.mp3',
            C4: 'plastic-marimba-c4.mp3',
            'D#4': 'plastic-marimba-ds4.mp3',
            'F#4': 'plastic-marimba-fs4.mp3',
            A4: 'plastic-marimba-a4.mp3',
            C5: 'plastic-marimba-c5.mp3',
            'D#5': 'plastic-marimba-ds5.mp3',
            'F#5': 'plastic-marimba-fs5.mp3',
            A5: 'plastic-marimba-a5.mp3'
        },
        baseUrl: 'https://s3-us-west-2.amazonaws.com/s.cdpn.io/969699/'
    },
    piano: {
        urls: {
            A0: 'A0.mp3', C1: 'C1.mp3', 'D#1': 'Ds1.mp3', 'F#1': 'Fs1.mp3', A1: 'A1.mp3',
            C2: 'C2.mp3', 'D#2': 'Ds2.mp3', 'F#2': 'Fs2.mp3', A2: 'A2.mp3',
            C3: 'C3.mp3', 'D#3': 'Ds3.mp3', 'F#3': 'Fs3.mp3', A3: 'A3.mp3',
            C4: 'C4.mp3', 'D#4': 'Ds4.mp3', 'F#4': 'Fs4.mp3', A4: 'A4.mp3',
            C5: 'C5.mp3', 'D#5': 'Ds5.mp3', 'F#5': 'Fs5.mp3', A5: 'A5.mp3',
            C6: 'C6.mp3', 'D#6': 'Ds6.mp3', 'F#6': 'Fs6.mp3', A6: 'A6.mp3',
            C7: 'C7.mp3', 'D#7': 'Ds7.mp3', 'F#7': 'Fs7.mp3', A7: 'A7.mp3', C8: 'C8.mp3'
        },
        baseUrl: 'https://tonejs.github.io/audio/salamander/'
    },
    synth: null // Will use Tone.PolySynth
};

let currentInstrument = 'marimba';
let sampler = null;
let polySynth = null;

// Create initial sampler
function createSampler(instrumentName) {
    const inst = instruments[instrumentName];
    if (instrumentName === 'synth') {
        // Use PolySynth for synth sound
        if (polySynth) polySynth.dispose();
        polySynth = new Tone.PolySynth(Tone.Synth, {
            oscillator: { type: 'sine' },
            envelope: { attack: 0.1, decay: 0.3, sustain: 0.8, release: 1.5 }
        }).toDestination();
        polySynth.volume.value = -6;
        return polySynth;
    } else {
        if (sampler) sampler.dispose();
        sampler = new Tone.Sampler({
            urls: inst.urls,
            baseUrl: inst.baseUrl,
            release: 2
        }).toDestination();
        return sampler;
    }
}

sampler = createSampler('marimba');

// ============ DRUM MACHINE ============
let drumsPlaying = false;
let drumPart = null;

const kick = new Tone.MembraneSynth({
    pitchDecay: 0.05,
    octaves: 6,
    oscillator: { type: 'sine' },
    envelope: { attack: 0.001, decay: 0.4, sustain: 0.01, release: 0.4 }
}).toDestination();
kick.volume.value = -8;

const hihat = new Tone.MetalSynth({
    frequency: 250,
    envelope: { attack: 0.001, decay: 0.1, release: 0.01 },
    harmonicity: 5.1,
    modulationIndex: 32,
    resonance: 4000,
    octaves: 1.5
}).toDestination();
hihat.volume.value = -18;

const snare = new Tone.NoiseSynth({
    noise: { type: 'white' },
    envelope: { attack: 0.001, decay: 0.15, sustain: 0, release: 0.1 }
}).toDestination();
snare.volume.value = -12;

function createDrumPattern() {
    drumPart = new Tone.Sequence((time, note) => {
        if (note === 'k') kick.triggerAttackRelease('C1', '8n', time);
        if (note === 'h') hihat.triggerAttackRelease('16n', time);
        if (note === 's') snare.triggerAttackRelease('8n', time);
    }, ['k', 'h', ['k', 'h'], 'h', 's', 'h', ['k', 'h'], 'h'], '8n');
}

function toggleDrums() {
    if (drumsPlaying) {
        if (drumPart) drumPart.stop();
        drumsPlaying = false;
    } else {
        if (!drumPart) createDrumPattern();
        drumPart.start(0);
        drumsPlaying = true;
    }
    return drumsPlaying;
}

// ============ RECORDING ============
let isRecording = false;
let recordingStartTime = 0;
let recordedNotes = [];

function startRecording() {
    recordedNotes = [];
    recordingStartTime = Tone.now();
    isRecording = true;
}

function stopRecording() {
    isRecording = false;
}

function recordNote(note, isHuman, velocity = 0.7) {
    if (!isRecording) return;
    recordedNotes.push({
        note: note,
        time: Tone.now() - recordingStartTime,
        isHuman: isHuman,
        velocity: velocity
    });
}

function downloadRecording() {
    if (recordedNotes.length === 0) {
        alert('No notes recorded!');
        return;
    }

    // Create a simple JSON format (could be converted to MIDI with a library)
    const recording = {
        format: 'ai-piano-duet-recording',
        version: '1.0',
        duration: recordedNotes[recordedNotes.length - 1].time,
        bpm: 120,
        notes: recordedNotes
    };

    const blob = new Blob([JSON.stringify(recording, null, 2)], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `ai-piano-duet-${Date.now()}.json`;
    a.click();
    URL.revokeObjectURL(url);
}

// ============ SHEET MUSIC GENERATION ============
function midiToNoteName(midi) {
    const noteNames = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
    const octave = Math.floor(midi / 12) - 1;
    const note = noteNames[midi % 12];
    return { note: note.replace('#', '#'), octave: octave };
}

function midiToVexFlowKey(midi) {
    const { note, octave } = midiToNoteName(midi);
    // VexFlow format: "c/4" for middle C
    return `${note.toLowerCase()}/${octave}`;
}

function quantizeTime(time, bpm = 120) {
    // Quantize to nearest 16th note
    const beatDuration = 60 / bpm;
    const sixteenthNote = beatDuration / 4;
    return Math.round(time / sixteenthNote) * sixteenthNote;
}

function groupNotesIntoBeats(notes, bpm = 120) {
    if (!notes || notes.length === 0) return [];

    const beatDuration = 60 / bpm;
    const beats = [];
    let currentBeat = [];
    let currentBeatStart = 0;

    // Sort by time
    const sortedNotes = [...notes].sort((a, b) => a.time - b.time);

    sortedNotes.forEach(note => {
        const quantizedTime = quantizeTime(note.time, bpm);
        const beatIndex = Math.floor(quantizedTime / beatDuration);
        const beatStart = beatIndex * beatDuration;

        if (beatStart !== currentBeatStart && currentBeat.length > 0) {
            beats.push({ time: currentBeatStart, notes: currentBeat });
            currentBeat = [];
        }

        currentBeatStart = beatStart;
        currentBeat.push(note);
    });

    if (currentBeat.length > 0) {
        beats.push({ time: currentBeatStart, notes: currentBeat });
    }

    return beats;
}

function generateSheetMusic() {
    if (recordedNotes.length === 0) {
        alert('No notes recorded! Record a duet first.');
        return;
    }

    const modal = document.getElementById('sheetMusicModal');
    const container = document.getElementById('sheetMusicContainer');

    // Clear previous content
    container.innerHTML = '';

    // Show modal
    modal.style.display = 'flex';

    try {
        // Check if VexFlow is available
        if (typeof Vex === 'undefined') {
            container.innerHTML = '<p style="color: #ef4444; text-align: center;">Sheet music library not loaded. Please refresh the page.</p>';
            return;
        }

        const VF = Vex.Flow;

        // Create renderer
        const renderer = new VF.Renderer(container, VF.Renderer.Backends.SVG);

        // Calculate width based on number of notes
        const notesPerMeasure = 4;
        const measureWidth = 250;
        const numMeasures = Math.ceil(recordedNotes.length / notesPerMeasure) || 1;
        const width = Math.max(800, numMeasures * measureWidth);

        renderer.resize(width, 250);
        const context = renderer.getContext();

        // Group notes into beats
        const beats = groupNotesIntoBeats(recordedNotes);

        // Create stave notes
        const humanNotes = [];
        const aiNotes = [];

        beats.forEach((beat, index) => {
            beat.notes.forEach(note => {
                const vexKey = midiToVexFlowKey(note.note);
                const staveNote = new VF.StaveNote({
                    keys: [vexKey],
                    duration: 'q',
                    clef: 'treble'
                });

                // Color based on human/AI
                if (note.isHuman) {
                    staveNote.setStyle({ fillStyle: '#3b82f6', strokeStyle: '#3b82f6' });
                    humanNotes.push(staveNote);
                } else {
                    staveNote.setStyle({ fillStyle: '#ec4899', strokeStyle: '#ec4899' });
                    aiNotes.push(staveNote);
                }
            });
        });

        // Combine all notes
        const allNotes = [];
        recordedNotes.slice(0, 16).forEach((note, i) => { // Limit to 16 notes for display
            const vexKey = midiToVexFlowKey(note.note);
            const staveNote = new VF.StaveNote({
                keys: [vexKey],
                duration: 'q',
                clef: 'treble'
            });
            staveNote.setStyle({
                fillStyle: note.isHuman ? '#3b82f6' : '#ec4899',
                strokeStyle: note.isHuman ? '#3b82f6' : '#ec4899'
            });
            allNotes.push(staveNote);
        });

        if (allNotes.length === 0) {
            container.innerHTML = '<p style="text-align: center; color: #64748b;">No notes to display</p>';
            return;
        }

        // Create measures
        const notesPerStave = 4;
        let xPosition = 10;
        const staveWidth = 200;

        for (let i = 0; i < allNotes.length; i += notesPerStave) {
            const measureNotes = allNotes.slice(i, i + notesPerStave);

            // Pad with rests if needed
            while (measureNotes.length < notesPerStave) {
                measureNotes.push(new VF.StaveNote({ keys: ['b/4'], duration: 'qr' }));
            }

            const stave = new VF.Stave(xPosition, 40, staveWidth);

            if (i === 0) {
                stave.addClef('treble').addTimeSignature('4/4');
            }

            stave.setContext(context).draw();

            const voice = new VF.Voice({ num_beats: 4, beat_value: 4 });
            voice.addTickables(measureNotes);

            new VF.Formatter().joinVoices([voice]).format([voice], staveWidth - 50);
            voice.draw(context, stave);

            xPosition += staveWidth;
        }

        // Add note count info
        const info = document.createElement('p');
        info.style.cssText = 'text-align: center; color: #64748b; margin-top: 1rem; font-size: 0.875rem;';
        info.textContent = `Showing ${Math.min(16, recordedNotes.length)} of ${recordedNotes.length} notes recorded`;
        container.appendChild(info);

    } catch (error) {
        console.error('Sheet music generation error:', error);
        container.innerHTML = `<p style="color: #ef4444; text-align: center;">Error generating sheet music: ${error.message}</p>`;
    }
}

function downloadSheetAsPNG() {
    const container = document.getElementById('sheetMusicContainer');
    const svg = container.querySelector('svg');

    if (!svg) {
        alert('No sheet music to download');
        return;
    }

    // Convert SVG to canvas then to PNG
    const svgData = new XMLSerializer().serializeToString(svg);
    const canvas = document.createElement('canvas');
    const ctx = canvas.getContext('2d');
    const img = new Image();

    img.onload = function() {
        canvas.width = img.width * 2;
        canvas.height = img.height * 2;
        ctx.fillStyle = 'white';
        ctx.fillRect(0, 0, canvas.width, canvas.height);
        ctx.drawImage(img, 0, 0, canvas.width, canvas.height);

        const a = document.createElement('a');
        a.download = `ai-piano-duet-sheet-${Date.now()}.png`;
        a.href = canvas.toDataURL('image/png');
        a.click();
    };

    img.src = 'data:image/svg+xml;base64,' + btoa(unescape(encodeURIComponent(svgData)));
}

function downloadAsMidi() {
    if (recordedNotes.length === 0) {
        alert('No notes recorded!');
        return;
    }

    // Simple MIDI file generation (Type 0, single track)
    // This is a basic implementation
    const midiData = [];

    // MIDI Header
    midiData.push(0x4D, 0x54, 0x68, 0x64); // "MThd"
    midiData.push(0x00, 0x00, 0x00, 0x06); // Header length
    midiData.push(0x00, 0x00); // Format type 0
    midiData.push(0x00, 0x01); // Number of tracks
    midiData.push(0x01, 0xE0); // Ticks per quarter note (480)

    // Track chunk
    const trackData = [];

    // Tempo (120 BPM = 500000 microseconds per beat)
    trackData.push(0x00, 0xFF, 0x51, 0x03, 0x07, 0xA1, 0x20);

    // Sort notes by time
    const sortedNotes = [...recordedNotes].sort((a, b) => a.time - b.time);

    let lastTime = 0;
    sortedNotes.forEach(note => {
        const deltaTime = Math.round((note.time - lastTime) * 480); // Convert to ticks
        const deltaByte = deltaTime < 128 ? [deltaTime] : [0x81, deltaTime & 0x7F];

        // Note on
        trackData.push(...deltaByte, 0x90, note.note, Math.round((note.velocity || 0.7) * 127));

        // Note off (after 0.25 seconds)
        trackData.push(0x60, 0x80, note.note, 0x00);

        lastTime = note.time;
    });

    // End of track
    trackData.push(0x00, 0xFF, 0x2F, 0x00);

    // Track header
    midiData.push(0x4D, 0x54, 0x72, 0x6B); // "MTrk"
    const trackLength = trackData.length;
    midiData.push((trackLength >> 24) & 0xFF, (trackLength >> 16) & 0xFF, (trackLength >> 8) & 0xFF, trackLength & 0xFF);
    midiData.push(...trackData);

    const blob = new Blob([new Uint8Array(midiData)], { type: 'audio/midi' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `ai-piano-duet-${Date.now()}.mid`;
    a.click();
    URL.revokeObjectURL(url);
}

// ============ CHORD DISPLAY ============
let humanChordDisplay = document.getElementById('humanChord');
let aiChordDisplay = document.getElementById('aiChord');
let recentAiNotes = [];
let aiNoteTimeout = null;

function updateHumanChordDisplay(chord) {
    if (humanChordDisplay) {
        humanChordDisplay.textContent = chord || '-';
    }
}

function updateAiChordDisplay(note) {
    // Add note to recent AI notes
    recentAiNotes.push({ note: note, time: Date.now() });

    // Remove old notes (older than 500ms)
    const now = Date.now();
    recentAiNotes = recentAiNotes.filter(n => now - n.time < 500);

    // Detect chord from recent notes
    if (recentAiNotes.length > 0) {
        const chords = detectChord(recentAiNotes);
        const chord = _.first(chords) || '-';
        if (aiChordDisplay) {
            aiChordDisplay.textContent = chord;
        }
    }

    // Clear after a delay if no new notes
    clearTimeout(aiNoteTimeout);
    aiNoteTimeout = setTimeout(() => {
        recentAiNotes = [];
        if (aiChordDisplay) {
            aiChordDisplay.textContent = '-';
        }
    }, 800);
}

// Backward compatibility
function updateChordDisplay(chord) {
    updateHumanChordDisplay(chord);
}

// Keyboard setup
let builtInKeyboard = new AudioKeys({ rows: 2 });
let onScreenKeyboardContainer = document.querySelector('.keyboard');
let onScreenKeyboard = buildKeyboard(onScreenKeyboardContainer);
let machinePlayer = buildKeyboard(document.querySelector('.machine-bg .player'));
let humanPlayer = buildKeyboard(document.querySelector('.human-bg .player'));

// State
let currentSeed = [];
let stopCurrentSequenceGenerator;
let synthGain = new Tone.Gain(0.4).toDestination();
let synthFilter = new Tone.Filter(300, 'lowpass').connect(synthGain);
let synthConfig = {
    oscillator: { type: 'fattriangle' },
    envelope: { attack: 3, sustain: 1, release: 1 }
};
let synthsPlaying = {};

// Helper functions
function isAccidental(note) {
    let pc = note % 12;
    return pc === 1 || pc === 3 || pc === 6 || pc === 8 || pc === 10;
}

function buildKeyboard(container) {
    let nAccidentals = _.range(MIN_NOTE, MAX_NOTE + 1).filter(isAccidental).length;
    let keyWidthPercent = 100 / (MAX_NOTE - MIN_NOTE - nAccidentals + 1);
    let keyInnerWidthPercent = 100 / (MAX_NOTE - MIN_NOTE - nAccidentals + 1) - 0.5;
    let gapPercent = keyWidthPercent - keyInnerWidthPercent;
    let accumulatedWidth = 0;

    return _.range(MIN_NOTE, MAX_NOTE + 1).map(note => {
        let accidental = isAccidental(note);
        let key = document.createElement('div');
        key.classList.add('key');

        if (accidental) {
            key.classList.add('accidental');
            key.style.left = `${accumulatedWidth - gapPercent - (keyWidthPercent / 2 - gapPercent) / 2}%`;
            key.style.width = `${keyWidthPercent / 2}%`;
        } else {
            key.style.left = `${accumulatedWidth}%`;
            key.style.width = `${keyInnerWidthPercent}%`;
        }

        container.appendChild(key);
        if (!accidental) accumulatedWidth += keyWidthPercent;
        return key;
    });
}

function getSeedIntervals(seed) {
    let intervals = [];
    for (let i = 0; i < seed.length - 1; i++) {
        let rawInterval = seed[i + 1].time - seed[i].time;
        let measure = _.minBy(['8n', '4n'], subdiv =>
            Math.abs(rawInterval - Tone.Time(subdiv).toSeconds())
        );
        intervals.push(Tone.Time(measure).toSeconds());
    }
    return intervals;
}

function getSequenceLaunchWaitTime(seed) {
    if (seed.length <= 1) return 1;
    let intervals = getSeedIntervals(seed);
    let maxInterval = _.max(intervals);
    return maxInterval * 2;
}

function getSequencePlayIntervalTime(seed) {
    if (seed.length <= 1) return Tone.Time('8n').toSeconds();
    let intervals = getSeedIntervals(seed).sort();
    return _.first(intervals);
}

function detectChord(notes) {
    if (!notes || notes.length === 0) return [];

    try {
        // Get note names from MIDI numbers
        const noteNames = notes.map(n => {
            const noteName = Tonal.Note.fromMidi(n.note);
            return Tonal.Note.pc(noteName); // Get pitch class (e.g., "C", "D#")
        });

        // Remove duplicates and sort
        const uniqueNotes = [...new Set(noteNames)].sort();

        // If only 1-2 notes, just show the notes (not a chord)
        if (uniqueNotes.length < 3) {
            return [uniqueNotes.join(' ')];
        }

        // Try to detect chord using Tonal
        const detected = Tonal.PcSet.modes(uniqueNotes)
            .map((mode, i) => {
                const tonic = uniqueNotes[i];
                const names = Tonal.Dictionary.chord.names(mode);
                return names.length ? tonic + names[0] : null;
            })
            .filter(x => x);

        // If no chord detected, show the notes
        if (detected.length === 0) {
            return [uniqueNotes.join(' ')];
        }

        return detected;
    } catch (e) {
        console.warn('Chord detection error:', e);
        // Fallback: simple chord detection
        return [simpleChordDetect(notes)];
    }
}

// Simple fallback chord detection
function simpleChordDetect(notes) {
    if (!notes || notes.length === 0) return '-';

    const noteNames = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];

    // Get pitch classes
    const pitchClasses = notes.map(n => n.note % 12);
    const uniquePCs = [...new Set(pitchClasses)].sort((a, b) => a - b);

    if (uniquePCs.length === 1) {
        return noteNames[uniquePCs[0]];
    }

    // Check for common chord patterns (relative to first note)
    const root = uniquePCs[0];
    const intervals = uniquePCs.map(pc => (pc - root + 12) % 12);

    // Major: 0, 4, 7
    if (intervals.includes(0) && intervals.includes(4) && intervals.includes(7)) {
        return noteNames[root] + 'M';
    }
    // Minor: 0, 3, 7
    if (intervals.includes(0) && intervals.includes(3) && intervals.includes(7)) {
        return noteNames[root] + 'm';
    }
    // Diminished: 0, 3, 6
    if (intervals.includes(0) && intervals.includes(3) && intervals.includes(6)) {
        return noteNames[root] + 'dim';
    }
    // Augmented: 0, 4, 8
    if (intervals.includes(0) && intervals.includes(4) && intervals.includes(8)) {
        return noteNames[root] + 'aug';
    }
    // Sus4: 0, 5, 7
    if (intervals.includes(0) && intervals.includes(5) && intervals.includes(7)) {
        return noteNames[root] + 'sus4';
    }
    // Sus2: 0, 2, 7
    if (intervals.includes(0) && intervals.includes(2) && intervals.includes(7)) {
        return noteNames[root] + 'sus2';
    }

    // Just show root note if can't identify
    return noteNames[root];
}

function buildNoteSequence(seed) {
    return mm.sequences.quantizeNoteSequence(
        {
            ticksPerQuarter: 220,
            totalTime: seed.length * 0.5,
            quantizationInfo: { stepsPerQuarter: 1 },
            timeSignatures: [{ time: 0, numerator: 4, denominator: 4 }],
            tempos: [{ time: 0, qpm: 120 }],
            notes: seed.map((n, idx) => ({
                pitch: n.note,
                startTime: idx * 0.5,
                endTime: (idx + 1) * 0.5
            }))
        },
        1
    );
}

function startSequenceGenerator(seed) {
    let running = true;
    let lastGenerationTask = Promise.resolve();

    let chords = detectChord(seed);
    let chord = _.first(chords) || 'CM';

    let seedSeq = buildNoteSequence(seed);
    let generatedSequence = Math.random() < 0.7 ? _.clone(seedSeq.notes.map(n => n.pitch)) : [];
    let launchWaitTime = getSequenceLaunchWaitTime(seed);
    let playIntervalTime = getSequencePlayIntervalTime(seed);
    let generationIntervalTime = playIntervalTime / 2;

    function generateNext() {
        if (!running) return;
        if (generatedSequence.length < 10) {
            lastGenerationTask = rnn
                .continueSequence(seedSeq, 20, temperature, [chord])
                .then(genSeq => {
                    generatedSequence = generatedSequence.concat(genSeq.notes.map(n => n.pitch));
                    setTimeout(generateNext, generationIntervalTime * 1000);
                });
        } else {
            setTimeout(generateNext, generationIntervalTime * 1000);
        }
    }

    function consumeNext(time) {
        if (generatedSequence.length) {
            let note = generatedSequence.shift();
            if (note > 0) {
                machineKeyDown(note, time);
            }
        }
    }

    setTimeout(generateNext, launchWaitTime * 1000);
    let consumerId = Tone.Transport.scheduleRepeat(
        consumeNext,
        playIntervalTime,
        Tone.Transport.seconds + launchWaitTime
    );

    return () => {
        running = false;
        Tone.Transport.clear(consumerId);
    };
}

function updateChord({ add = null, remove = null }) {
    if (add) {
        currentSeed.push({ note: add, time: Tone.now() });
    }
    if (remove && _.some(currentSeed, { note: remove })) {
        _.remove(currentSeed, { note: remove });
    }

    // Update chord display immediately
    if (currentSeed.length > 0) {
        const chords = detectChord(currentSeed);
        const chord = _.first(chords) || '-';
        updateChordDisplay(chord);
    } else {
        updateChordDisplay('-');
    }

    if (stopCurrentSequenceGenerator) {
        stopCurrentSequenceGenerator();
        stopCurrentSequenceGenerator = null;
    }
    if (currentSeed.length && !stopCurrentSequenceGenerator) {
        stopCurrentSequenceGenerator = startSequenceGenerator(_.cloneDeep(currentSeed));
    }
}

async function humanKeyDown(note, velocity = 0.7) {
    if (note < MIN_NOTE || note > MAX_NOTE) return;
    // Ensure audio context is started on first interaction
    if (Tone.context.state !== 'running') {
        await Tone.start();
    }
    let freq = Tone.Frequency(note, 'midi');

    // Play sound based on current instrument
    if (currentInstrument === 'synth' && polySynth) {
        polySynth.triggerAttack(freq, Tone.now(), velocity);
    } else if (sampler) {
        sampler.triggerAttack(freq);
    }

    // Also play the background synth for texture
    let synth = new Tone.Synth(synthConfig).connect(synthFilter);
    synthsPlaying[note] = synth;
    synth.triggerAttack(freq, Tone.now(), velocity * 0.3);

    // Record note if recording
    recordNote(note, true, velocity);

    updateChord({ add: note });
    humanPlayer[note - MIN_NOTE].classList.add('down');
    animatePlay(onScreenKeyboard[note - MIN_NOTE], note, true);
}

function humanKeyUp(note) {
    if (note < MIN_NOTE || note > MAX_NOTE) return;

    // Release synth sounds
    if (currentInstrument === 'synth' && polySynth) {
        polySynth.triggerRelease(Tone.Frequency(note, 'midi'));
    }

    if (synthsPlaying[note]) {
        let synth = synthsPlaying[note];
        synth.triggerRelease();
        setTimeout(() => synth.dispose(), 2000);
        synthsPlaying[note] = null;
    }
    updateChord({ remove: note });
    humanPlayer[note - MIN_NOTE].classList.remove('down');
}

function machineKeyDown(note, time) {
    if (note < MIN_NOTE || note > MAX_NOTE) return;

    // Play sound based on current instrument
    if (currentInstrument === 'synth' && polySynth) {
        polySynth.triggerAttackRelease(Tone.Frequency(note, 'midi'), '8n', time);
    } else if (sampler) {
        sampler.triggerAttack(Tone.Frequency(note, 'midi'), time);
    }

    // Record AI note
    recordNote(note, false);

    // Update AI chord display
    updateAiChordDisplay(note);

    animatePlay(onScreenKeyboard[note - MIN_NOTE], note, false);
    animateMachine(machinePlayer[note - MIN_NOTE]);
}

function animatePlay(keyEl, note, isHuman) {
    let sourceColor = isHuman ? '#1E88E5' : '#E91E63';
    let targetColor = isAccidental(note) ? 'black' : 'white';
    keyEl.animate(
        [{ backgroundColor: sourceColor }, { backgroundColor: targetColor }],
        { duration: 700, easing: 'ease-out' }
    );
}

function animateMachine(keyEl) {
    keyEl.animate([{ opacity: 0.9 }, { opacity: 0 }], {
        duration: 700,
        easing: 'ease-out'
    });
}

// Computer keyboard controls
builtInKeyboard.down(note => {
    humanKeyDown(note.note);
    hideUI();
});
builtInKeyboard.up(note => humanKeyUp(note.note));

// MIDI Controls
if (typeof WebMidi !== 'undefined') {
    WebMidi.enable(err => {
        if (err) {
            console.error('WebMidi could not be enabled', err);
            return;
        }
        document.querySelector('.midi-not-supported').style.display = 'none';

    let withInputsMsg = document.querySelector('.midi-supported-with-inputs');
    let noInputsMsg = document.querySelector('.midi-supported-no-inputs');
    let selector = document.querySelector('#midi-inputs');
    let activeInput;

    function onInputsChange() {
        if (WebMidi.inputs.length === 0) {
            withInputsMsg.style.display = 'none';
            noInputsMsg.style.display = 'block';
            onActiveInputChange(null);
        } else {
            noInputsMsg.style.display = 'none';
            withInputsMsg.style.display = 'block';
            while (selector.firstChild) {
                selector.firstChild.remove();
            }
            for (let input of WebMidi.inputs) {
                let option = document.createElement('option');
                option.value = input.id;
                option.innerText = input.name;
                selector.appendChild(option);
            }
            onActiveInputChange(WebMidi.inputs[0].id);
        }
    }

    function onActiveInputChange(id) {
        if (activeInput) {
            activeInput.removeListener();
        }
        let input = WebMidi.getInputById(id);
        if (input) {
            input.addListener('noteon', 'all', e => {
                humanKeyDown(e.note.number, e.velocity);
                hideUI();
            });
            input.addListener('noteoff', 'all', e => humanKeyUp(e.note.number));
            for (let option of Array.from(selector.children)) {
                option.selected = option.value === id;
            }
            activeInput = input;
        }
    }

    onInputsChange();
    WebMidi.addListener('connected', onInputsChange);
    WebMidi.addListener('disconnected', onInputsChange);
    selector.addEventListener('change', evt => onActiveInputChange(evt.target.value));
    });
} else {
    console.log('WebMidi not available - MIDI controller support disabled');
}

// Mouse & touch Controls
let pointedNotes = new Set();

function updateTouchedNotes(evt) {
    let touchedNotes = new Set();
    for (let touch of Array.from(evt.touches)) {
        let element = document.elementFromPoint(touch.clientX, touch.clientY);
        let keyIndex = onScreenKeyboard.indexOf(element);
        if (keyIndex >= 0) {
            touchedNotes.add(MIN_NOTE + keyIndex);
            if (!evt.defaultPrevented) {
                evt.preventDefault();
            }
        }
    }
    for (let note of pointedNotes) {
        if (!touchedNotes.has(note)) {
            humanKeyUp(note);
            pointedNotes.delete(note);
        }
    }
    for (let note of touchedNotes) {
        if (!pointedNotes.has(note)) {
            humanKeyDown(note);
            pointedNotes.add(note);
        }
    }
}

onScreenKeyboard.forEach((noteEl, index) => {
    noteEl.addEventListener('mousedown', evt => {
        humanKeyDown(MIN_NOTE + index);
        pointedNotes.add(MIN_NOTE + index);
        evt.preventDefault();
    });
    noteEl.addEventListener('mouseover', () => {
        if (pointedNotes.size && !pointedNotes.has(MIN_NOTE + index)) {
            humanKeyDown(MIN_NOTE + index);
            pointedNotes.add(MIN_NOTE + index);
        }
    });
});

document.documentElement.addEventListener('mouseup', () => {
    pointedNotes.forEach(n => humanKeyUp(n));
    pointedNotes.clear();
});
document.documentElement.addEventListener('touchstart', updateTouchedNotes);
document.documentElement.addEventListener('touchmove', updateTouchedNotes);
document.documentElement.addEventListener('touchend', updateTouchedNotes);

// Temperature control
const tempSlider = document.querySelector('#temperature');
const tempValue = document.querySelector('#tempValue');
if (tempSlider) {
    tempSlider.addEventListener('input', () => {
        temperature = parseFloat(tempSlider.value);
        if (tempValue) {
            tempValue.textContent = temperature.toFixed(1);
        }
    });
}

// Controls hiding
let container = document.querySelector('.container');

function hideUI() {
    container.classList.add('ui-hidden');
}

let scheduleHideUI = _.debounce(hideUI, 5000);
container.addEventListener('mousemove', () => {
    container.classList.remove('ui-hidden');
    scheduleHideUI();
});
container.addEventListener('touchstart', () => {
    container.classList.remove('ui-hidden');
    scheduleHideUI();
});

// Startup
function generateDummySequence() {
    // Generate a throwaway sequence to get the RNN loaded
    return rnn.continueSequence(
        buildNoteSequence([{ note: 60, time: Tone.now() }]),
        20,
        temperature,
        ['Cm']
    );
}

// Wait for audio buffers and RNN model to load
Promise.all([Tone.loaded(), rnn.initialize()])
    .then(generateDummySequence)
    .then(() => {
        Tone.Transport.start();
        onScreenKeyboardContainer.classList.add('loaded');
        document.querySelector('.loading').remove();
    })
    .catch(err => {
        console.error('Error loading AI model:', err);
        document.querySelector('.loading').innerHTML = 'Error loading AI model. Please refresh the page.';
    });

// Start audio context on user interaction (required by browsers)
StartAudioContext(Tone.context, document.documentElement);

// Additional fallback for audio context
async function ensureAudioStarted() {
    if (Tone.context.state !== 'running') {
        await Tone.start();
    }
}

// Resume audio on any user interaction
['click', 'touchstart', 'keydown'].forEach(event => {
    document.addEventListener(event, ensureAudioStarted, { once: true });
});

// ============ NEW FEATURE CONTROLS ============

// Instrument Selector
const instrumentSelect = document.getElementById('instrumentSelect');
if (instrumentSelect) {
    instrumentSelect.addEventListener('change', async (e) => {
        currentInstrument = e.target.value;
        await Tone.start();

        if (currentInstrument === 'synth') {
            createSampler('synth');
        } else {
            // Show loading state while samples load
            const loadingIndicator = document.createElement('div');
            loadingIndicator.className = 'instrument-loading';
            loadingIndicator.textContent = 'Loading...';
            instrumentSelect.parentNode.appendChild(loadingIndicator);

            createSampler(currentInstrument);

            // Wait for samples to load
            await Tone.loaded();
            loadingIndicator.remove();
        }
    });
}

// Drums Toggle
const drumsToggle = document.getElementById('drumsToggle');
if (drumsToggle) {
    drumsToggle.addEventListener('click', async () => {
        await Tone.start();
        const isPlaying = toggleDrums();
        drumsToggle.textContent = isPlaying ? '🥁 Drums: ON' : '🥁 Drums: OFF';
        drumsToggle.classList.toggle('active', isPlaying);
    });
}

// Recording Controls
const recordBtn = document.getElementById('recordBtn');
const downloadBtn = document.getElementById('downloadBtn');

if (recordBtn) {
    recordBtn.addEventListener('click', async () => {
        await Tone.start();
        if (isRecording) {
            stopRecording();
            recordBtn.textContent = '⏺️ Record';
            recordBtn.classList.remove('recording');
            if (downloadBtn) downloadBtn.disabled = false;
            if (sheetMusicBtn) sheetMusicBtn.disabled = false;
        } else {
            startRecording();
            recordBtn.textContent = '⏹️ Stop';
            recordBtn.classList.add('recording');
            if (downloadBtn) downloadBtn.disabled = true;
            if (sheetMusicBtn) sheetMusicBtn.disabled = true;
        }
    });
}

if (downloadBtn) {
    downloadBtn.addEventListener('click', () => {
        downloadRecording();
    });
}

// Sheet Music Button
const sheetMusicBtn = document.getElementById('sheetMusicBtn');
if (sheetMusicBtn) {
    sheetMusicBtn.addEventListener('click', () => {
        generateSheetMusic();
    });
}

// Sheet Music Modal Controls
const sheetModal = document.getElementById('sheetMusicModal');
const closeSheetModal = document.getElementById('closeSheetModal');
const downloadSheetBtn = document.getElementById('downloadSheetBtn');
const downloadMidiBtn = document.getElementById('downloadMidiBtn');

if (closeSheetModal) {
    closeSheetModal.addEventListener('click', () => {
        sheetModal.style.display = 'none';
    });
}

if (sheetModal) {
    sheetModal.addEventListener('click', (e) => {
        if (e.target === sheetModal) {
            sheetModal.style.display = 'none';
        }
    });
}

if (downloadSheetBtn) {
    downloadSheetBtn.addEventListener('click', downloadSheetAsPNG);
}

if (downloadMidiBtn) {
    downloadMidiBtn.addEventListener('click', downloadAsMidi);
}
