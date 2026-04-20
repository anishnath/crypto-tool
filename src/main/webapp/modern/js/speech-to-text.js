/**
 * Speech to Text — shared modal component for all tools.
 *
 * Opens a recording modal with mic visualization, timer, and status.
 * Records audio → sends to /ai?action=transcribe → returns text.
 *
 * Usage:
 *   SpeechToText.init({
 *       buttonId: 'my-mic-btn',
 *       aiUrl: '/ctx/ai',
 *       language: 'en',
 *       onResult: function(text, lang, duration) { ... },
 *       onError: function(msg) { ... }
 *   });
 */
;(function(win) {
    'use strict';

    var config = {};
    var overlay = null;
    var els = {};
    var mediaRecorder = null;
    var audioChunks = [];
    var state = 'idle';
    var recordingStart = 0;
    var timerInterval = null;
    var analyser = null;
    var animFrame = null;
    var stream = null;

    var MIME_TYPES = [
        'audio/webm;codecs=opus', 'audio/webm',
        'audio/ogg;codecs=opus', 'audio/ogg',
        'audio/mp4', 'audio/wav'
    ];
    var MAX_DURATION_MS = 300000;
    var maxTimer = null;

    function init(opts) {
        config = {
            aiUrl: opts.aiUrl || '',
            language: opts.language || '',
            onResult: opts.onResult || function() {},
            onError: opts.onError || function() {}
        };

        if (opts.buttonId) {
            var btn = document.getElementById(opts.buttonId);
            if (btn) btn.addEventListener('click', openModal);
        }
    }

    // ═══════════════════════════════════════
    // MODAL
    // ═══════════════════════════════════════

    function createModal() {
        if (overlay) return;
        overlay = document.createElement('div');
        overlay.className = 'stt-overlay';
        overlay.style.display = 'none';
        overlay.innerHTML =
            '<div class="stt-modal">' +
            '  <div class="stt-header">' +
            '    <span class="stt-title">&#127908; Voice to Text</span>' +
            '    <button class="stt-close" data-stt="close">&times;</button>' +
            '  </div>' +
            '  <div class="stt-body">' +
            '    <div class="stt-viz-wrap">' +
            '      <canvas class="stt-viz" width="280" height="80"></canvas>' +
            '    </div>' +
            '    <div class="stt-timer" id="stt-timer">0:00</div>' +
            '    <div class="stt-status" id="stt-status">Click to start recording</div>' +
            '    <div class="stt-btn-row">' +
            '      <button class="stt-record-btn" data-stt="toggle" id="stt-record-btn">' +
            '        <span class="stt-mic-icon">&#127908;</span>' +
            '      </button>' +
            '    </div>' +
            '    <div class="stt-upload-row">' +
            '      <span class="stt-or-divider"><span>or upload audio file</span></span>' +
            '      <label class="stt-upload-label">' +
            '        <input type="file" class="stt-upload-input" accept=".mp3,.wav,.m4a,.webm,.ogg,.flac,audio/*" />' +
            '        <span class="stt-upload-btn">&#128193; Choose File</span>' +
            '        <span class="stt-upload-hint">MP3, WAV, M4A, OGG, FLAC &bull; Max 5MB</span>' +
            '      </label>' +
            '    </div>' +
            '    <div class="stt-result" id="stt-result" style="display:none;">' +
            '      <div class="stt-result-label">Transcription</div>' +
            '      <div class="stt-result-text" id="stt-result-text"></div>' +
            '      <div class="stt-result-actions">' +
            '        <button class="stt-btn-primary" data-stt="use">Insert</button>' +
            '        <button class="stt-btn-secondary" data-stt="retry">Retry</button>' +
            '      </div>' +
            '    </div>' +
            '  </div>' +
            '</div>';

        document.body.appendChild(overlay);

        els.timer = overlay.querySelector('#stt-timer');
        els.status = overlay.querySelector('#stt-status');
        els.recordBtn = overlay.querySelector('#stt-record-btn');
        els.result = overlay.querySelector('#stt-result');
        els.resultText = overlay.querySelector('#stt-result-text');
        els.canvas = overlay.querySelector('.stt-viz');

        overlay.addEventListener('click', function(e) {
            var action = e.target.closest('[data-stt]');
            if (!action) {
                if (e.target === overlay) closeModal();
                return;
            }
            var cmd = action.getAttribute('data-stt');
            if (cmd === 'close') closeModal();
            else if (cmd === 'toggle') toggleRecording();
            else if (cmd === 'use') useResult();
            else if (cmd === 'retry') retryRecording();
        });

        // File upload handler
        var fileInput = overlay.querySelector('.stt-upload-input');
        if (fileInput) {
            fileInput.addEventListener('change', function(e) {
                if (!e.target.files || !e.target.files[0]) return;
                handleAudioFile(e.target.files[0]);
                e.target.value = '';
            });
        }
    }

    var savedCursor = null;

    function openModal() {
        if (!overlay) createModal();
        // Save cursor position before modal steals focus
        if (win.editorInstance) {
            savedCursor = win.editorInstance.getCursor();
        }
        resetUI();
        overlay.style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }

    function closeModal() {
        if (state === 'recording') stopRecording();
        cleanupAudio();
        state = 'idle';
        overlay.style.display = 'none';
        document.body.style.overflow = '';
    }

    function resetUI() {
        state = 'idle';
        els.timer.textContent = '0:00';
        els.status.textContent = 'Click to start recording';
        els.recordBtn.innerHTML = '<span class="stt-mic-icon">&#127908;</span>';
        els.recordBtn.classList.remove('stt-recording', 'stt-disabled');
        els.result.style.display = 'none';
        els.resultText.textContent = '';
        clearCanvas();
    }

    // ═══════════════════════════════════════
    // RECORDING
    // ═══════════════════════════════════════

    function toggleRecording() {
        if (state === 'recording') {
            stopRecording();
        } else if (state === 'idle') {
            startRecording();
        }
    }

    function startRecording() {
        if (state !== 'idle') return;

        if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
            config.onError('Microphone not supported in this browser');
            els.status.textContent = 'Microphone not supported';
            return;
        }

        els.status.textContent = 'Requesting microphone...';

        navigator.mediaDevices.getUserMedia({ audio: true })
            .then(function(s) {
                stream = s;

                // Setup analyser for visualization
                var audioCtx = new (win.AudioContext || win.webkitAudioContext)();
                var source = audioCtx.createMediaStreamSource(stream);
                analyser = audioCtx.createAnalyser();
                analyser.fftSize = 256;
                source.connect(analyser);
                drawViz();

                // Pick MIME type
                var mimeType = '';
                for (var i = 0; i < MIME_TYPES.length; i++) {
                    if (MediaRecorder.isTypeSupported(MIME_TYPES[i])) {
                        mimeType = MIME_TYPES[i];
                        break;
                    }
                }

                var options = mimeType ? { mimeType: mimeType } : {};
                mediaRecorder = new MediaRecorder(stream, options);
                audioChunks = [];

                mediaRecorder.ondataavailable = function(e) {
                    if (e.data && e.data.size > 0) audioChunks.push(e.data);
                };

                mediaRecorder.onstop = function() {
                    cleanupAudio();
                    processAudio();
                };

                mediaRecorder.onerror = function() {
                    cleanupAudio();
                    setState('idle');
                    els.status.textContent = 'Recording error. Try again.';
                };

                mediaRecorder.start(1000);
                recordingStart = Date.now();
                startTimer();
                setState('recording');

                els.status.textContent = 'Listening... click to stop';
                els.recordBtn.innerHTML = '<span class="stt-stop-icon">&#9724;</span>';
                els.recordBtn.classList.add('stt-recording');

                maxTimer = setTimeout(function() {
                    if (state === 'recording') stopRecording();
                }, MAX_DURATION_MS);
            })
            .catch(function(err) {
                if (err.name === 'NotAllowedError') {
                    els.status.textContent = 'Microphone access denied';
                    config.onError('Microphone access denied. Please allow in browser settings.');
                } else {
                    els.status.textContent = 'Could not access microphone. Please try again.';
                    config.onError('Could not access microphone. Please try again.');
                }
            });
    }

    function stopRecording() {
        if (state !== 'recording' || !mediaRecorder) return;
        clearTimeout(maxTimer);
        mediaRecorder.stop();
    }

    function cleanupAudio() {
        if (stream) {
            stream.getTracks().forEach(function(t) { t.stop(); });
            stream = null;
        }
        cancelAnimationFrame(animFrame);
        analyser = null;
        clearInterval(timerInterval);
    }

    // ═══════════════════════════════════════
    // TIMER & VISUALIZATION
    // ═══════════════════════════════════════

    function startTimer() {
        clearInterval(timerInterval);
        timerInterval = setInterval(function() {
            var elapsed = Math.floor((Date.now() - recordingStart) / 1000);
            var min = Math.floor(elapsed / 60);
            var sec = elapsed % 60;
            els.timer.textContent = min + ':' + (sec < 10 ? '0' : '') + sec;
        }, 500);
    }

    function drawViz() {
        if (!analyser || !els.canvas) return;
        var canvas = els.canvas;
        var ctx = canvas.getContext('2d');
        var bufLen = analyser.frequencyBinCount;
        var dataArray = new Uint8Array(bufLen);

        function draw() {
            animFrame = requestAnimationFrame(draw);
            analyser.getByteFrequencyData(dataArray);

            ctx.fillStyle = 'rgba(14, 15, 20, 0.3)';
            ctx.fillRect(0, 0, canvas.width, canvas.height);

            var barWidth = (canvas.width / bufLen) * 2.5;
            var x = 0;
            for (var i = 0; i < bufLen; i++) {
                var barHeight = (dataArray[i] / 255) * canvas.height * 0.9;
                var hue = 250 + (dataArray[i] / 255) * 60; // purple to pink
                ctx.fillStyle = 'hsl(' + hue + ', 80%, 65%)';
                ctx.fillRect(x, canvas.height - barHeight, barWidth - 1, barHeight);
                x += barWidth;
                if (x > canvas.width) break;
            }
        }
        draw();
    }

    function clearCanvas() {
        if (!els.canvas) return;
        var ctx = els.canvas.getContext('2d');
        ctx.fillStyle = '#0e0f14';
        ctx.fillRect(0, 0, els.canvas.width, els.canvas.height);
    }

    // ═══════════════════════════════════════
    // FILE UPLOAD
    // ═══════════════════════════════════════

    var MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    var ALLOWED_AUDIO = /\.(mp3|wav|m4a|webm|ogg|flac)$/i;

    function handleAudioFile(file) {
        if (state === 'recording' || state === 'transcribing') return;

        if (!ALLOWED_AUDIO.test(file.name) && file.type.indexOf('audio') === -1) {
            els.status.textContent = 'Not an audio file. Use MP3, WAV, M4A, OGG, or FLAC.';
            return;
        }
        if (file.size > MAX_FILE_SIZE) {
            els.status.textContent = 'File too large (' + (file.size / 1024 / 1024).toFixed(1) + 'MB). Max 5MB.';
            return;
        }

        // Determine format from extension or MIME
        var ext = (file.name.match(/\.(\w+)$/) || [])[1];
        var format = ext ? ext.toLowerCase() : 'mp3';
        if (file.type.indexOf('wav') !== -1) format = 'wav';
        else if (file.type.indexOf('ogg') !== -1) format = 'ogg';
        else if (file.type.indexOf('webm') !== -1) format = 'webm';
        else if (file.type.indexOf('flac') !== -1) format = 'flac';
        else if (file.type.indexOf('mp4') !== -1 || file.type.indexOf('m4a') !== -1) format = 'm4a';

        setState('transcribing');
        els.status.textContent = 'Transcribing ' + file.name + '...';
        els.recordBtn.innerHTML = '<span class="stt-spinner"></span>';
        els.recordBtn.classList.add('stt-disabled');
        els.result.style.display = 'none';

        var reader = new FileReader();
        reader.onload = function() {
            var base64 = reader.result.split(',')[1];
            if (!base64) {
                setState('idle');
                els.status.textContent = 'Could not read file';
                els.recordBtn.classList.remove('stt-disabled');
                els.recordBtn.innerHTML = '<span class="stt-mic-icon">&#127908;</span>';
                return;
            }
            sendTranscribe(base64, format);
        };
        reader.onerror = function() {
            setState('idle');
            els.status.textContent = 'Failed to read file';
            els.recordBtn.classList.remove('stt-disabled');
            els.recordBtn.innerHTML = '<span class="stt-mic-icon">&#127908;</span>';
        };
        reader.readAsDataURL(file);
    }

    // ═══════════════════════════════════════
    // TRANSCRIPTION
    // ═══════════════════════════════════════

    function processAudio() {
        if (audioChunks.length === 0) {
            setState('idle');
            els.status.textContent = 'No audio recorded. Try again.';
            return;
        }

        setState('transcribing');
        els.status.textContent = 'Transcribing...';
        els.recordBtn.innerHTML = '<span class="stt-spinner"></span>';
        els.recordBtn.classList.remove('stt-recording');
        els.recordBtn.classList.add('stt-disabled');

        var blob = new Blob(audioChunks, { type: audioChunks[0].type || 'audio/webm' });
        audioChunks = [];

        var mimeType = blob.type || '';
        var format = 'webm';
        if (mimeType.indexOf('ogg') !== -1) format = 'ogg';
        else if (mimeType.indexOf('mp4') !== -1 || mimeType.indexOf('m4a') !== -1) format = 'm4a';
        else if (mimeType.indexOf('wav') !== -1) format = 'wav';

        var reader = new FileReader();
        reader.onload = function() {
            var base64 = reader.result.split(',')[1];
            if (!base64) {
                setState('idle');
                els.status.textContent = 'Could not encode audio';
                return;
            }
            sendTranscribe(base64, format);
        };
        reader.onerror = function() {
            setState('idle');
            els.status.textContent = 'Failed to read audio';
        };
        reader.readAsDataURL(blob);
    }

    function sendTranscribe(audioBase64, format) {
        var payload = { audio: audioBase64, format: format };
        if (config.language) payload.language = config.language;

        fetch(config.aiUrl + '?action=transcribe', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        })
        .then(function(res) {
            if (!res.ok) return res.json().then(function(d) { throw new Error(d.error || 'Transcription failed'); });
            return res.json();
        })
        .then(function(data) {
            var text = (data.text || '').trim();
            setState('done');
            if (!text) {
                els.status.textContent = 'No speech detected. Try again.';
                els.recordBtn.classList.remove('stt-disabled');
                els.recordBtn.innerHTML = '<span class="stt-mic-icon">&#127908;</span>';
                setState('idle');
                return;
            }
            showResult(text, data.language || '', data.duration || 0);
        })
        .catch(function(err) {
            setState('idle');
            els.status.textContent = 'Transcription failed. Please try again.';
            els.recordBtn.classList.remove('stt-disabled');
            els.recordBtn.innerHTML = '<span class="stt-mic-icon">&#127908;</span>';
            config.onError('Transcription failed. Please try again.');
        });
    }

    function showResult(text, lang, duration) {
        els.status.textContent = 'Transcription complete' + (lang ? ' (' + lang + ')' : '') + (duration ? ' — ' + duration.toFixed(1) + 's' : '');
        els.resultText.textContent = text;
        els.result.style.display = '';
        els.recordBtn.classList.remove('stt-disabled');
        els.recordBtn.innerHTML = '<span class="stt-mic-icon">&#127908;</span>';
        // Store for use
        overlay._lastText = text;
        overlay._lastLang = lang;
        overlay._lastDuration = duration;
    }

    function useResult() {
        var text = overlay._lastText || '';
        var lang = overlay._lastLang || '';
        var duration = overlay._lastDuration || 0;
        closeModal();
        // Restore cursor and focus before inserting
        if (win.editorInstance && savedCursor) {
            win.editorInstance.setCursor(savedCursor);
            win.editorInstance.focus();
        }
        if (text) config.onResult(text, lang, duration);
    }

    function retryRecording() {
        resetUI();
        startRecording();
    }

    function setState(s) { state = s; }

    function getState() { return state; }

    win.SpeechToText = {
        init: init,
        getState: getState
    };

})(window);
