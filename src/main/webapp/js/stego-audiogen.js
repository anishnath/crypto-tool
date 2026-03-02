/**
 * Steganography Tool - Audio Cover Generator Module
 * Auto-generate synthetic WAV covers for LSB steganography
 * Similar to StegoImageGen but for audio.
 */
(function(global) {
'use strict';

var TYPES = [
    { id: 'tone', name: 'Sine Tone', icon: 'tone' },
    { id: 'noise', name: 'Noise', icon: 'noise' },
    { id: 'mixed', name: 'Tone + Noise', icon: 'mixed' },
    { id: 'chords', name: 'Chord', icon: 'chords' }
];

/**
 * Create WAV buffer from PCM samples (16-bit mono).
 * samples: Int16Array or array of -32768..32767
 */
function createWAVBuffer(samples, sampleRate) {
    sampleRate = sampleRate || 44100;
    if (!(samples instanceof Int16Array)) {
        samples = new Int16Array(samples);
    }
    var dataSize = samples.length * 2;
    var buffer = new ArrayBuffer(44 + dataSize);
    var view = new DataView(buffer);

    view.setUint8(0, 0x52); view.setUint8(1, 0x49); view.setUint8(2, 0x46); view.setUint8(3, 0x46);
    view.setUint32(4, 36 + dataSize, true);
    view.setUint8(8, 0x57); view.setUint8(9, 0x41); view.setUint8(10, 0x56); view.setUint8(11, 0x45);

    view.setUint8(12, 0x66); view.setUint8(13, 0x6D); view.setUint8(14, 0x74); view.setUint8(15, 0x20);
    view.setUint32(16, 16, true);
    view.setUint16(20, 1, true);
    view.setUint16(22, 1, true);
    view.setUint32(24, sampleRate, true);
    view.setUint32(28, sampleRate * 2, true);
    view.setUint16(32, 2, true);
    view.setUint16(34, 16, true);

    view.setUint8(36, 0x64); view.setUint8(37, 0x61); view.setUint8(38, 0x74); view.setUint8(39, 0x61);
    view.setUint32(40, dataSize, true);

    for (var i = 0; i < samples.length; i++) {
        view.setInt16(44 + i * 2, samples[i], true);
    }
    return buffer;
}

/**
 * Generate sine tone at frequency for duration seconds.
 */
function generateTone(freq, duration, sampleRate, amplitude) {
    sampleRate = sampleRate || 44100;
    amplitude = (amplitude != null) ? amplitude : 0.3;
    var numSamples = Math.floor(duration * sampleRate);
    var samples = new Int16Array(numSamples);
    for (var i = 0; i < numSamples; i++) {
        var t = i / sampleRate;
        samples[i] = Math.floor(Math.sin(2 * Math.PI * freq * t) * amplitude * 32767);
    }
    return samples;
}

/**
 * Generate white noise.
 */
function generateNoise(duration, sampleRate, amplitude, rng) {
    sampleRate = sampleRate || 44100;
    amplitude = (amplitude != null) ? amplitude : 0.2;
    rng = rng || Math.random;
    var numSamples = Math.floor(duration * sampleRate);
    var samples = new Int16Array(numSamples);
    for (var i = 0; i < numSamples; i++) {
        samples[i] = Math.floor((rng() * 2 - 1) * amplitude * 32767);
    }
    return samples;
}

/**
 * Generate tone + noise mix.
 */
function generateMixed(freq, duration, sampleRate, rng) {
    var tone = generateTone(freq, duration, sampleRate, 0.25);
    var noise = generateNoise(duration, sampleRate, 0.15, rng);
    var samples = new Int16Array(tone.length);
    for (var i = 0; i < samples.length; i++) {
        var v = tone[i] + noise[i];
        samples[i] = Math.max(-32768, Math.min(32767, v));
    }
    return samples;
}

/**
 * Generate chord (multiple frequencies).
 */
function generateChords(duration, sampleRate) {
    sampleRate = sampleRate || 44100;
    var freqs = [262, 330, 392];
    var numSamples = Math.floor(duration * sampleRate);
    var samples = new Int16Array(numSamples);
    var amp = 0.2 / freqs.length;
    for (var i = 0; i < numSamples; i++) {
        var t = i / sampleRate;
        var v = 0;
        for (var j = 0; j < freqs.length; j++) {
            v += Math.sin(2 * Math.PI * freqs[j] * t);
        }
        samples[i] = Math.floor(v * amp * 32767);
    }
    return samples;
}

function mulberry32(seed) {
    return function() {
        var t = seed += 0x6D2B79F5;
        t = Math.imul(t ^ t >>> 15, t | 1);
        t ^= t + Math.imul(t ^ t >>> 7, t | 61);
        return ((t ^ t >>> 14) >>> 0) / 4294967296;
    };
}

/**
 * Generate a cover WAV of the specified type.
 * opts: { seed?: number, rng?: () => number } for reproducible generation.
 */
function generate(type, durationSeconds, sampleRate, opts) {
    durationSeconds = durationSeconds || 3;
    sampleRate = sampleRate || 44100;
    var rng = (opts && opts.rng) || ((opts && opts.seed != null) ? mulberry32(opts.seed) : null);
    rng = rng || Math.random;

    var samples;
    switch (type) {
        case 'tone':
            var freq = 440 + Math.floor(rng() * 200);
            samples = generateTone(freq, durationSeconds, sampleRate);
            break;
        case 'noise':
            samples = generateNoise(durationSeconds, sampleRate, undefined, rng);
            break;
        case 'mixed':
            var f = 440 + Math.floor(rng() * 200);
            samples = generateMixed(f, durationSeconds, sampleRate, rng);
            break;
        case 'chords':
            samples = generateChords(durationSeconds, sampleRate);
            break;
        default:
            samples = generateTone(440, durationSeconds, sampleRate);
    }

    var buffer = createWAVBuffer(samples, sampleRate);
    return {
        buffer: buffer,
        duration: durationSeconds,
        sampleRate: sampleRate
    };
}

/**
 * Return available generator types.
 */
function getTypes() {
    return TYPES.slice();
}

var target = (typeof window !== 'undefined' ? window : global);
target.StegoAudioGen = {
    generate: generate,
    getTypes: getTypes
};

})(typeof window !== 'undefined' ? window : (typeof global !== 'undefined' ? global : this));
