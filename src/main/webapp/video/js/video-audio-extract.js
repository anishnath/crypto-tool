/**
 * VideoAudioExtract — client-side audio extraction from a video (or already-audio) file.
 *
 * Strategy:
 *   1. If the file is already an audio mime type → pass through, return base64 + format.
 *   2. Otherwise, treat as video: load into a hidden <video>, decode with AudioContext,
 *      mix down to mono 16 kHz (Whisper-optimal), and encode as WAV.
 *
 * Returns:
 *   { base64: string, format: 'webm'|'mp3'|'wav'|..., durationSec: number, sampleRate: number }
 *
 * Usage:
 *   VideoAudioExtract.extract(file, { onProgress: function(pct, label) {} })
 *     .then(function(out) { ... })
 *     .catch(function(err) { ... });
 */
(function (global) {
    'use strict';

    var AUDIO_MIME_TO_FORMAT = {
        'audio/mpeg': 'mp3',
        'audio/mp3': 'mp3',
        'audio/wav': 'wav',
        'audio/x-wav': 'wav',
        'audio/wave': 'wav',
        'audio/m4a': 'm4a',
        'audio/x-m4a': 'm4a',
        'audio/mp4': 'm4a',
        'audio/webm': 'webm',
        'audio/ogg': 'ogg',
        'audio/flac': 'flac',
        'audio/x-flac': 'flac'
    };

    var TARGET_SAMPLE_RATE = 16000; // Whisper works well with 16 kHz mono

    function fileToArrayBuffer(file) {
        return new Promise(function (resolve, reject) {
            var reader = new FileReader();
            reader.onload = function () { resolve(reader.result); };
            reader.onerror = function () { reject(new Error('Failed to read file')); };
            reader.readAsArrayBuffer(file);
        });
    }

    function arrayBufferToBase64(buffer) {
        var bytes = new Uint8Array(buffer);
        var binary = '';
        var chunk = 0x8000;
        for (var i = 0; i < bytes.length; i += chunk) {
            binary += String.fromCharCode.apply(null, bytes.subarray(i, i + chunk));
        }
        return btoa(binary);
    }

    // Resample a Float32 PCM buffer to the target sample rate (simple linear interpolation).
    function resample(input, fromRate, toRate) {
        if (fromRate === toRate) return input;
        var ratio = fromRate / toRate;
        var newLength = Math.round(input.length / ratio);
        var output = new Float32Array(newLength);
        var pos = 0;
        for (var i = 0; i < newLength; i++) {
            var idx = i * ratio;
            var idxLo = Math.floor(idx);
            var idxHi = Math.min(idxLo + 1, input.length - 1);
            var frac = idx - idxLo;
            output[i] = input[idxLo] * (1 - frac) + input[idxHi] * frac;
            pos++;
        }
        return output;
    }

    // Mix all channels down to mono (average).
    function mixToMono(audioBuffer) {
        var channels = audioBuffer.numberOfChannels;
        if (channels === 1) return audioBuffer.getChannelData(0).slice();
        var len = audioBuffer.length;
        var out = new Float32Array(len);
        for (var ch = 0; ch < channels; ch++) {
            var data = audioBuffer.getChannelData(ch);
            for (var i = 0; i < len; i++) out[i] += data[i];
        }
        for (var j = 0; j < len; j++) out[j] /= channels;
        return out;
    }

    // Encode Float32 PCM mono at `sampleRate` to a WAV-formatted ArrayBuffer.
    function encodeWav(samples, sampleRate) {
        var buffer = new ArrayBuffer(44 + samples.length * 2);
        var view = new DataView(buffer);
        writeString(view, 0, 'RIFF');
        view.setUint32(4, 36 + samples.length * 2, true);
        writeString(view, 8, 'WAVE');
        writeString(view, 12, 'fmt ');
        view.setUint32(16, 16, true);              // Sub-chunk size
        view.setUint16(20, 1, true);               // PCM
        view.setUint16(22, 1, true);               // mono
        view.setUint32(24, sampleRate, true);
        view.setUint32(28, sampleRate * 2, true);  // byte rate (sr * blockAlign)
        view.setUint16(32, 2, true);               // block align (channels * bytesPerSample)
        view.setUint16(34, 16, true);              // bits per sample
        writeString(view, 36, 'data');
        view.setUint32(40, samples.length * 2, true);

        var offset = 44;
        for (var i = 0; i < samples.length; i++, offset += 2) {
            var s = Math.max(-1, Math.min(1, samples[i]));
            view.setInt16(offset, s < 0 ? s * 0x8000 : s * 0x7FFF, true);
        }
        return buffer;
    }
    function writeString(view, offset, s) {
        for (var i = 0; i < s.length; i++) view.setUint8(offset + i, s.charCodeAt(i));
    }

    function extract(file, opts) {
        opts = opts || {};
        var onProgress = opts.onProgress || function () {};

        var mime = (file.type || '').toLowerCase();
        var isAudio = mime.indexOf('audio/') === 0;

        // Fast path: already audio in a Whisper-accepted format — send as-is.
        if (isAudio) {
            var format = AUDIO_MIME_TO_FORMAT[mime];
            if (!format) {
                // Best-effort from extension
                var ext = (file.name.split('.').pop() || '').toLowerCase();
                if (AUDIO_MIME_TO_FORMAT['audio/' + ext]) format = ext;
                else format = 'webm'; // Whisper is forgiving; let the server/ffmpeg decide
            }
            onProgress(5, 'Reading audio file...');
            return fileToArrayBuffer(file).then(function (buf) {
                onProgress(90, 'Encoding...');
                var base64 = arrayBufferToBase64(buf);
                onProgress(100, 'Ready');
                return { base64: base64, format: format, durationSec: null, sampleRate: null };
            });
        }

        // Video path: decode → mono 16 kHz → WAV → base64.
        if (typeof AudioContext === 'undefined' && typeof webkitAudioContext === 'undefined') {
            return Promise.reject(new Error('Your browser can\'t process video files here. Please upload an audio file instead.'));
        }
        var Ctx = global.AudioContext || global.webkitAudioContext;

        onProgress(5, 'Reading video...');
        return fileToArrayBuffer(file).then(function (buf) {
            onProgress(25, 'Decoding audio track...');
            var ctx = new Ctx();
            return new Promise(function (resolve, reject) {
                // Safari prefers the callback form
                var decoded = ctx.decodeAudioData(buf, function (audioBuf) {
                    resolve({ ctx: ctx, audioBuf: audioBuf });
                }, function (err) {
                    reject(err || new Error('Could not decode audio track. Is there one in the file?'));
                });
                // Promise-returning impl
                if (decoded && typeof decoded.then === 'function') {
                    decoded.then(function (audioBuf) { resolve({ ctx: ctx, audioBuf: audioBuf }); }, reject);
                }
            });
        }).then(function (r) {
            var audioBuf = r.audioBuf;
            onProgress(55, 'Mixing to mono...');
            var mono = mixToMono(audioBuf);
            onProgress(70, 'Resampling to 16 kHz...');
            var resampled = resample(mono, audioBuf.sampleRate, TARGET_SAMPLE_RATE);
            onProgress(85, 'Encoding WAV...');
            var wav = encodeWav(resampled, TARGET_SAMPLE_RATE);
            var base64 = arrayBufferToBase64(wav);
            onProgress(100, 'Ready');
            try { r.ctx.close(); } catch (e) {}
            return {
                base64: base64,
                format: 'wav',
                durationSec: audioBuf.duration,
                sampleRate: TARGET_SAMPLE_RATE
            };
        });
    }

    global.VideoAudioExtract = { extract: extract };
})(window);
