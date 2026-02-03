// Enhanced Metronome - Minimal Beat Counter + Advanced Features
// Tone.js only

let isPlaying = false;
let bpm = 120;
let beatsPerMeasure = 4;
let subdivision = 1;
let soundType = 'click';
let tapTimes = [];
let accentPattern = []; // Which beats to accent (empty = default first beat)
let currentBeat = 0;

// Audio State
let isAudioInitialized = false;
let metronomeLoop;
let synthHigh, synthLow, drumHat;

// Visual Flash Mode
let visualFlashMode = false;

// Practice Mode
let practiceModeActive = false;
let practiceStartBpm = 60;
let practiceEndBpm = 120;
let practiceDurationMin = 5;
let practiceStartTime = 0;
let practiceInterval = null;

document.addEventListener('DOMContentLoaded', () => {
    initControls();
    setupKeyboardShortcuts();
    setBpm(bpm);
    loadPresets();
    renderAccentPattern();
    loadSettingsFromUrl();
});

// ==========================================
// URL PARAMETER LOADING
// ==========================================
function loadSettingsFromUrl() {
    const urlParams = new URLSearchParams(window.location.search);

    // Load BPM
    if (urlParams.has('bpm')) {
        const urlBpm = parseInt(urlParams.get('bpm'));
        if (urlBpm >= 30 && urlBpm <= 250) {
            setBpm(urlBpm);
        }
    }

    // Load Time Signature
    if (urlParams.has('sig')) {
        const sig = parseInt(urlParams.get('sig'));
        if (sig >= 1 && sig <= 6) {
            beatsPerMeasure = sig;
            document.getElementById('measureSelect').value = sig;
            renderAccentPattern();
        }
    }

    // Load Sound Type
    if (urlParams.has('sound')) {
        const sound = urlParams.get('sound');
        if (['click', 'woodblock', 'drum', 'beep'].includes(sound)) {
            soundType = sound;
            document.getElementById('soundSelect').value = sound;
        }
    }

    // Auto-play if requested
    if (urlParams.has('play') && urlParams.get('play') === 'true') {
        setTimeout(() => togglePlay(), 500);
    }
}

// ==========================================
// AUDIO LOGIC
// ==========================================
async function initAudio() {
    if (isAudioInitialized) return;
    try {
        await Tone.start();
        synthHigh = new Tone.MembraneSynth({ pitchDecay: 0.01, octaves: 4 }).toDestination();
        synthLow = new Tone.MembraneSynth({ pitchDecay: 0.01, octaves: 2 }).toDestination();
        drumHat = new Tone.MetalSynth({
            envelope: { attack: 0.001, decay: 0.05, release: 0.01 },
            harmonicity: 5.1, modulationIndex: 32, resonance: 4000, octave: 1.5
        }).toDestination();
        drumHat.volume.value = -12;
        isAudioInitialized = true;
    } catch (e) {
        console.error('Audio Init Failed', e);
    }
}

function scheduleLoop() {
    try {
        if (metronomeLoop) {
            metronomeLoop.dispose();
            metronomeLoop = null;
        }
        Tone.Transport.bpm.value = bpm;

        const intervalProp = subdivision === 2 ? '8n' : (subdivision === 3 ? '8t' : (subdivision === 4 ? '16n' : '4n'));
        currentBeat = 0;

        metronomeLoop = new Tone.Loop((time) => {
            const totalSubBeats = beatsPerMeasure * subdivision;
            const beatPosition = currentBeat % totalSubBeats;
            const isDownbeat = beatPosition === 0;
            const isMainBeat = beatPosition % subdivision === 0;
            const mainBeatIndex = Math.floor(beatPosition / subdivision);

            // Check if this beat should be accented
            const isAccented = accentPattern.length === 0 ? isDownbeat : accentPattern.includes(mainBeatIndex);

            // Visual Flash Mode
            if (visualFlashMode && isMainBeat) {
                Tone.Draw.schedule(() => flashScreen(isAccented), time);
            }

            // Update Beat Counter
            if (isMainBeat) {
                Tone.Draw.schedule(() => {
                    const beatCounter = document.getElementById('beatCounter');
                    if (beatCounter) {
                        beatCounter.textContent = mainBeatIndex + 1;
                        // Flash effect
                        beatCounter.style.transform = 'scale(1.1)';
                        beatCounter.style.color = isAccented ? '#ef4444' : 'var(--primary)';
                        setTimeout(() => {
                            beatCounter.style.transform = 'scale(1)';
                            beatCounter.style.color = 'var(--text-primary)';
                        }, 100);
                    }
                }, time);
            }

            // Audio
            if (isAccented) triggerSound('high', time);
            else if (isMainBeat) triggerSound('low', time);
            else triggerSound('sub', time);

            currentBeat++;
        }, intervalProp).start(0);
    } catch (e) {
        console.error('Schedule loop error:', e);
    }
}

function triggerSound(type, time) {
    if (!isAudioInitialized) return;
    try {
        if (soundType === 'click') {
            if (type === 'high') synthHigh.triggerAttackRelease("C5", "32n", time);
            else if (type === 'low') synthLow.triggerAttackRelease("G4", "32n", time);
            else synthLow.triggerAttackRelease("G4", "32n", time, 0.2);
        } else if (soundType === 'woodblock') {
            if (type === 'high') synthHigh.triggerAttackRelease("E6", "32n", time);
            else synthLow.triggerAttackRelease("A5", "32n", time);
        } else if (soundType === 'drum') {
            if (type === 'high') synthHigh.triggerAttackRelease("C2", "16n", time);
            else drumHat.triggerAttackRelease("32n", time);
        } else {
            const osc = new Tone.Oscillator(type === 'high' ? 880 : 440, "square").toDestination();
            osc.start(time).stop(time + 0.05);
        }
    } catch (e) { }
}

async function togglePlay() {
    const btn = document.getElementById('playBtn');

    try {
        // Ensure Tone.js is started
        if (Tone.context.state !== 'running') {
            await Tone.start();
            await Tone.context.resume();
        }
        await initAudio();

        if (!isPlaying) {
            isPlaying = true;
            btn.classList.add('is-playing');
            btn.innerHTML = `<svg class="pause-icon" style="width:32px;height:32px;" viewBox="0 0 24 24" fill="currentColor"><path d="M6 19h4V5H6v14zm8-14v14h4V5h-4z"/></svg>`;
            btn.title = "Pause (Space)";

            // Stop transport first if running
            Tone.Transport.stop();
            Tone.Transport.cancel();

            scheduleLoop();
            Tone.Transport.start();
        } else {
            isPlaying = false;
            btn.classList.remove('is-playing');
            btn.innerHTML = `<svg class="play-icon" style="width:32px;height:32px;" viewBox="0 0 24 24" fill="currentColor"><path d="M8 5v14l11-7z"/></svg>`;
            btn.title = "Play (Space)";
            Tone.Transport.stop();
            Tone.Transport.cancel();
            if (metronomeLoop) {
                metronomeLoop.dispose();
                metronomeLoop = null;
            }
        }
    } catch (e) {
        console.error('Metronome error:', e);
    }
}

// ==========================================
// VISUAL FLASH MODE
// ==========================================
function flashScreen(isAccent) {
    const color = isAccent ? '#ef4444' : '#6366f1';
    document.body.style.transition = 'background-color 0.05s';
    document.body.style.backgroundColor = color;
    setTimeout(() => {
        document.body.style.backgroundColor = '';
    }, 100);
}

function toggleVisualFlash() {
    visualFlashMode = !visualFlashMode;
    const btn = document.getElementById('visualFlashBtn');
    if (btn) btn.textContent = visualFlashMode ? '👁️ ON' : '👁️ Flash';
}

// ==========================================
// PRACTICE MODE (Gradual Tempo Increase)
// ==========================================
function togglePracticeMode() {
    const btn = document.getElementById('practiceModeBtn');

    if (!practiceModeActive) {
        // Start Practice Mode
        practiceStartBpm = parseInt(document.getElementById('practiceStart').value) || 60;
        practiceEndBpm = parseInt(document.getElementById('practiceEnd').value) || 120;
        practiceDurationMin = parseInt(document.getElementById('practiceDuration').value) || 5;

        if (practiceStartBpm >= practiceEndBpm) {
            if (window.ToolUtils) {
                ToolUtils.showToast('End BPM must be higher than Start BPM', 3000, 'warning');
            } else {
                alert('End BPM must be higher than Start BPM');
            }
            return;
        }

        practiceModeActive = true;
        practiceStartTime = Date.now();
        btn.textContent = 'Stop';
        btn.style.background = '#ef4444';

        if (window.ToolUtils) {
            ToolUtils.showToast(`Practice Mode: ${practiceStartBpm} → ${practiceEndBpm} BPM over ${practiceDurationMin} min`, 3000, 'info');
        }

        // Set initial BPM
        setBpm(practiceStartBpm);

        // Start if not already playing
        if (!isPlaying) togglePlay();

        // Update BPM gradually
        const totalMs = practiceDurationMin * 60 * 1000;
        const bpmRange = practiceEndBpm - practiceStartBpm;

        practiceInterval = setInterval(() => {
            const elapsed = Date.now() - practiceStartTime;
            const progress = Math.min(elapsed / totalMs, 1);
            const currentTargetBpm = Math.round(practiceStartBpm + (bpmRange * progress));

            setBpm(currentTargetBpm);

            if (progress >= 1) {
                stopPracticeMode();
            }
        }, 1000);

    } else {
        stopPracticeMode();
    }
}

function stopPracticeMode() {
    practiceModeActive = false;
    if (practiceInterval) {
        clearInterval(practiceInterval);
        practiceInterval = null;
    }
    const btn = document.getElementById('practiceModeBtn');
    if (btn) {
        btn.textContent = 'Start';
        btn.style.background = 'var(--primary)';
    }
}

// ==========================================
// PRESET MANAGEMENT
// ==========================================
function loadPresets() {
    const saved = localStorage.getItem('metronomePresets');
    if (saved) {
        try {
            window.metronomePresets = JSON.parse(saved);
        } catch (e) {
            window.metronomePresets = [];
        }
    } else {
        window.metronomePresets = [];
    }
}

function saveCurrentAsPreset() {
    const name = prompt('Name this preset:', `${bpm} BPM ${beatsPerMeasure}/4`);
    if (!name) return;

    const preset = { name, bpm, beatsPerMeasure, subdivision, soundType };
    window.metronomePresets.push(preset);
    localStorage.setItem('metronomePresets', JSON.stringify(window.metronomePresets));
    alert(`Saved preset: ${name}`);
}

function loadPreset(preset) {
    setBpm(preset.bpm);
    beatsPerMeasure = preset.beatsPerMeasure;
    subdivision = preset.subdivision || 1;
    soundType = preset.soundType || 'click';

    document.getElementById('measureSelect').value = beatsPerMeasure;
    document.getElementById('subdivisionSelect').value = subdivision;
    document.getElementById('soundSelect').value = soundType;

    if (isPlaying) scheduleLoop();
}

function showPresetModal() {
    const modal = document.getElementById('presetModal');
    const list = document.getElementById('presetList');

    if (!window.metronomePresets || window.metronomePresets.length === 0) {
        list.innerHTML = '<p style="color: var(--text-secondary); text-align: center; padding: 2rem;">No saved presets yet. Click "Save" to create one!</p>';
    } else {
        list.innerHTML = '';
        window.metronomePresets.forEach((preset, index) => {
            const card = document.createElement('div');
            card.style.cssText = 'background: var(--surface); border-radius: 8px; padding: 1rem; display: flex; justify-content: space-between; align-items: center; border: 1px solid var(--border);';
            card.innerHTML = `
                <div>
                    <div style="font-weight: 600; color: var(--text-primary);">${preset.name}</div>
                    <div style="font-size: 0.875rem; color: var(--text-secondary); margin-top: 0.25rem;">
                        ${preset.bpm} BPM • ${preset.beatsPerMeasure}/4
                    </div>
                </div>
                <div style="display: flex; gap: 0.5rem;">
                    <button onclick="loadPresetByIndex(${index})" style="background: var(--primary); color: white; border: none; padding: 0.5rem 1rem; border-radius: 6px; cursor: pointer; font-weight: 500;">Load</button>
                    <button onclick="deletePreset(${index})" style="background: #ef4444; color: white; border: none; padding: 0.5rem 1rem; border-radius: 6px; cursor: pointer;">🗑️</button>
                </div>
            `;
            list.appendChild(card);
        });
    }

    modal.style.display = 'flex';
}

function closePresetModal() {
    document.getElementById('presetModal').style.display = 'none';
}

function loadPresetByIndex(index) {
    loadPreset(window.metronomePresets[index]);
    closePresetModal();
}

function deletePreset(index) {
    if (confirm('Delete this preset?')) {
        window.metronomePresets.splice(index, 1);
        localStorage.setItem('metronomePresets', JSON.stringify(window.metronomePresets));
        showPresetModal();
    }
}

// ==========================================
// ACCENT PATTERN UI
// ==========================================
function renderAccentPattern() {
    const container = document.getElementById('accentPatternSelector');
    if (!container) return;

    container.innerHTML = '';
    for (let i = 0; i < beatsPerMeasure; i++) {
        const btn = document.createElement('button');
        btn.className = 'accent-beat-btn';
        btn.textContent = i + 1;
        btn.dataset.beat = i;
        btn.style.cssText = `
            width: 40px; height: 40px; border-radius: 50%;
            border: 2px solid var(--primary);
            background: ${accentPattern.includes(i) ? 'var(--primary)' : 'transparent'};
            color: ${accentPattern.includes(i) ? 'white' : 'var(--primary)'};
            font-weight: 600; cursor: pointer; transition: all 0.2s;
        `;
        btn.onclick = () => toggleAccent(i);
        container.appendChild(btn);
    }
}

function toggleAccent(beatIndex) {
    const idx = accentPattern.indexOf(beatIndex);
    if (idx > -1) {
        accentPattern.splice(idx, 1);
    } else {
        accentPattern.push(beatIndex);
    }
    accentPattern.sort((a, b) => a - b);
    renderAccentPattern();
}

// ==========================================
// CONTROLS
// ==========================================
function initControls() {
    document.getElementById('tempoRange').addEventListener('input', (e) => setBpm(e.target.value));
    document.getElementById('measureSelect').addEventListener('change', (e) => {
        beatsPerMeasure = parseInt(e.target.value);
        accentPattern = [];
        renderAccentPattern();
        if (isPlaying) scheduleLoop();
    });
    document.getElementById('subdivisionSelect').addEventListener('change', (e) => {
        subdivision = parseInt(e.target.value);
        if (isPlaying) scheduleLoop();
    });
    document.getElementById('soundSelect').addEventListener('change', (e) => soundType = e.target.value);
    document.getElementById('tapBtn').addEventListener('mousedown', handleTap);
    document.getElementById('decreaseTempo').addEventListener('click', () => setBpm(bpm - 1));
    document.getElementById('increaseTempo').addEventListener('click', () => setBpm(bpm + 1));
}

function setBpm(val) {
    let newBpm = parseInt(val);
    if (newBpm < 30) newBpm = 30;
    if (newBpm > 250) newBpm = 250;
    bpm = newBpm;
    if (isPlaying) Tone.Transport.bpm.rampTo(bpm, 0.1);

    document.getElementById('bpmDisplay').textContent = bpm;
    document.getElementById('tempoRange').value = bpm;

    let label = 'Moderato';
    if (val < 60) label = 'Largo';
    else if (val < 76) label = 'Adagio';
    else if (val < 108) label = 'Andante';
    else if (val < 120) label = 'Moderato';
    else if (val < 168) label = 'Allegro';
    else label = 'Presto';
    document.getElementById('bpmLabel').textContent = label;
}

function handleTap() {
    const now = Date.now();
    const btn = document.getElementById('tapBtn');
    btn.classList.add('tapped');
    setTimeout(() => btn.classList.remove('tapped'), 100);
    if (tapTimes.length > 0 && now - tapTimes[tapTimes.length - 1] > 2000) tapTimes = [];
    tapTimes.push(now);
    if (tapTimes.length > 4) tapTimes.shift();
    if (tapTimes.length >= 2) {
        let avg = 0;
        for (let i = 1; i < tapTimes.length; i++) avg += (tapTimes[i] - tapTimes[i - 1]);
        avg /= (tapTimes.length - 1);
        setBpm(Math.round(60000 / avg));
    }
}

function setupKeyboardShortcuts() {
    window.addEventListener('keydown', (e) => {
        if (e.target.tagName === 'INPUT' || e.target.tagName === 'SELECT') return;
        if (e.code === 'Space') { e.preventDefault(); togglePlay(); }
        if (e.code === 'ArrowUp') setBpm(bpm + 1);
        if (e.code === 'ArrowDown') setBpm(bpm - 1);
        if (e.code === 'KeyT') handleTap();
        if (e.code === 'KeyV') toggleVisualFlash();
        if (e.code === 'KeyS') saveCurrentAsPreset();
    });
}

// Global functions for onclick handlers
window.loadPreset = async (p) => { setBpm(p); if (!isPlaying) await togglePlay(); };
window.toggleVisualFlash = toggleVisualFlash;
window.saveCurrentAsPreset = saveCurrentAsPreset;
window.showPresetModal = showPresetModal;
window.closePresetModal = closePresetModal;
window.loadPresetByIndex = loadPresetByIndex;
window.deletePreset = deletePreset;
window.togglePracticeMode = togglePracticeMode;
