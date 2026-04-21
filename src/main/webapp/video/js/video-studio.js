/**
 * Video Studio controller — sidebar service switching + transcribe workflow.
 * Uses window.AIProgressBar (deferred) + window.VideoAudioExtract.
 */
(function () {
    'use strict';

    var ctxMeta = document.querySelector('meta[name="ctx"]');
    var CTX = ctxMeta ? ctxMeta.getAttribute('content') : '';
    var ENDPOINT = CTX + '/video-service';
    var MAX_BASE64_BYTES = 33_500_000; // must mirror VideoServiceServlet limit

    // ── Sidebar service switching ────────────────────────────────────
    var sidebarItems = document.querySelectorAll('.vs-sidebar-item');
    var views = document.querySelectorAll('.vs-view');

    sidebarItems.forEach(function (item) {
        item.addEventListener('click', function () {
            if (item.classList.contains('disabled')) return;
            var target = item.getAttribute('data-service');
            sidebarItems.forEach(function (s) { s.classList.remove('active'); });
            item.classList.add('active');
            views.forEach(function (v) {
                v.classList.toggle('active', v.getAttribute('data-service') === target);
            });
            try { history.replaceState(null, '', '#' + target); } catch (e) {}
        });
    });
    // Honour hash on load
    (function () {
        var h = (location.hash || '').replace('#', '');
        if (!h) return;
        var match = document.querySelector('.vs-sidebar-item[data-service="' + h + '"]');
        if (match && !match.classList.contains('disabled')) match.click();
    })();

    // ── Transcribe view ──────────────────────────────────────────────
    (function initTranscribe() {
        var view = document.querySelector('.vs-view[data-service="transcribe"]');
        if (!view) return;

        var dropZone       = view.querySelector('.vs-drop');
        var fileInput      = view.querySelector('.vs-drop-file');
        var preview        = view.querySelector('.vs-preview');
        var previewName    = view.querySelector('.vs-preview-name');
        var previewStats   = view.querySelector('.vs-preview-stats');
        var removeBtn      = view.querySelector('.vs-preview-remove');
        var submitBtn      = view.querySelector('#vs-transcribe-submit');
        var taskSelect     = view.querySelector('#vs-task');
        var languageInput  = view.querySelector('#vs-language');
        var outputFmtSel   = view.querySelector('#vs-output-fmt');
        var progressHost   = view.querySelector('.vs-progress-host');
        var errorBanner    = view.querySelector('.vs-error');
        var output         = view.querySelector('.vs-output');
        var outputBody     = view.querySelector('.vs-output-body');
        var outputMeta     = view.querySelector('.vs-output-meta');
        var copyBtn        = view.querySelector('#vs-output-copy');
        var downloadBtn    = view.querySelector('#vs-output-download');

        var selectedFile = null;
        var lastResult = null;
        var progressBar = null;

        function getProgressBar() {
            if (progressBar) return progressBar;
            if (typeof window.AIProgressBar === 'undefined') return null;
            // Transcribe often takes 1-4 min depending on length — phases tuned for that.
            progressBar = window.AIProgressBar.attach(progressHost, {
                estimatedMs: 180000,
                phases: [
                    { pct: 10, ms: 2000,   label: 'Preparing audio...' },
                    { pct: 25, ms: 12000,  label: 'Starting transcription...' },
                    { pct: 45, ms: 30000,  label: 'Detecting language...' },
                    { pct: 65, ms: 60000,  label: 'Transcribing speech...' },
                    { pct: 82, ms: 120000, label: 'Finishing up...' },
                    { pct: 92, ms: 160000, label: 'Almost done...' }
                ]
            });
            return progressBar;
        }

        function fmtBytes(n) {
            if (n < 1024) return n + ' B';
            if (n < 1024 * 1024) return (n / 1024).toFixed(0) + ' KB';
            return (n / 1024 / 1024).toFixed(1) + ' MB';
        }

        function showError(msg) {
            errorBanner.textContent = msg;
            errorBanner.classList.add('active');
        }
        function clearError() {
            errorBanner.classList.remove('active');
            errorBanner.textContent = '';
        }

        function setFile(file) {
            if (!file) return;
            clearError();

            var mime = (file.type || '').toLowerCase();
            var isVideo = mime.indexOf('video/') === 0;
            var isAudio = mime.indexOf('audio/') === 0;
            if (!isVideo && !isAudio) {
                showError('Unsupported file type. Upload an audio or video file.');
                return;
            }
            // Rough upper bound: cap raw file at 200 MB — even after extraction that may
            // exceed server limits for long videos, but at least we fail fast on absurd uploads.
            if (file.size > 200 * 1024 * 1024) {
                showError('File too large (' + fmtBytes(file.size) + '). Max 200 MB.');
                return;
            }
            selectedFile = file;
            previewName.textContent = file.name;
            previewStats.textContent = (isVideo ? 'Video' : 'Audio') + ' · ' + fmtBytes(file.size);
            preview.classList.add('active');
            dropZone.style.display = 'none';
            submitBtn.disabled = false;
        }

        function resetFile() {
            selectedFile = null;
            preview.classList.remove('active');
            dropZone.style.display = 'block';
            fileInput.value = '';
            submitBtn.disabled = true;
        }

        // Drop zone wiring
        fileInput.addEventListener('change', function (e) {
            if (e.target.files && e.target.files[0]) setFile(e.target.files[0]);
        });
        ['dragenter', 'dragover'].forEach(function (ev) {
            dropZone.addEventListener(ev, function (e) {
                e.preventDefault(); e.stopPropagation();
                dropZone.classList.add('drag-active');
            });
        });
        ['dragleave', 'drop'].forEach(function (ev) {
            dropZone.addEventListener(ev, function (e) {
                e.preventDefault(); e.stopPropagation();
                dropZone.classList.remove('drag-active');
            });
        });
        dropZone.addEventListener('drop', function (e) {
            var f = e.dataTransfer && e.dataTransfer.files && e.dataTransfer.files[0];
            if (f) setFile(f);
        });

        removeBtn.addEventListener('click', resetFile);

        // Submit
        submitBtn.addEventListener('click', function () {
            if (!selectedFile) return;
            clearError();
            output.classList.remove('active');
            submitBtn.disabled = true;
            var pb = getProgressBar();
            if (pb) pb.start();

            if (typeof window.VideoAudioExtract === 'undefined') {
                showError('Audio extractor not loaded. Refresh the page.');
                if (pb) pb.stop(false);
                submitBtn.disabled = false;
                return;
            }

            window.VideoAudioExtract.extract(selectedFile, {
                onProgress: function (pct, label) {
                    // The global progress bar has its own phase ticker; we only log here.
                    // (Could show a tiny sub-status later.)
                }
            }).then(function (audio) {
                if (audio.base64.length > MAX_BASE64_BYTES) {
                    var approxMB = (audio.base64.length * 3 / 4 / 1024 / 1024).toFixed(1);
                    throw new Error('Extracted audio is ' + approxMB + ' MB — max is 25 MB. Try a shorter clip.');
                }
                var payload = {
                    audio: audio.base64,
                    format: audio.format,
                    task: taskSelect.value || 'transcribe'
                };
                var lang = (languageInput.value || '').trim();
                if (lang) payload.language = lang;

                return fetch(ENDPOINT + '?action=transcribe', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(payload)
                }).then(function (resp) {
                    return resp.text().then(function (txt) {
                        var data = {};
                        try { data = txt ? JSON.parse(txt) : {}; } catch (e) {}
                        if (resp.status === 429) {
                            var wait = resp.headers.get('Retry-After') || '60';
                            throw new Error('Rate limit reached. Try again in ' + wait + 's.');
                        }
                        if (!resp.ok || data.error) {
                            throw new Error(data.error || ('Transcription failed (HTTP ' + resp.status + ')'));
                        }
                        return { data: data, audio: audio };
                    });
                });
            }).then(function (r) {
                if (pb) pb.stop(true);
                renderResult(r.data, r.audio);
                submitBtn.disabled = false;
            }).catch(function (err) {
                if (pb) pb.stop(false);
                showError(err.message || String(err));
                submitBtn.disabled = false;
            });
        });

        function renderResult(data, audio) {
            var text = data.text || data.transcription || '';
            var segments = data.segments || null;
            var fmt = outputFmtSel.value || 'txt';

            var rendered;
            if (fmt === 'srt' && segments) rendered = toSrt(segments);
            else if (fmt === 'vtt' && segments) rendered = toVtt(segments);
            else if (fmt === 'json') rendered = JSON.stringify(data, null, 2);
            else rendered = text;

            lastResult = { data: data, text: text, format: fmt, rendered: rendered, audio: audio };
            outputBody.textContent = rendered || '(no output)';
            outputMeta.innerHTML =
                '<span>' + (text.length) + ' chars · ' + (segments ? segments.length : 0) + ' segments' +
                (audio && audio.durationSec ? ' · ' + formatDuration(audio.durationSec) : '') + '</span>' +
                '<span>' + (data.language ? 'Detected: ' + data.language : '') + '</span>';
            output.classList.add('active');
        }

        function formatDuration(sec) {
            var m = Math.floor(sec / 60);
            var s = Math.round(sec % 60);
            return m + ':' + (s < 10 ? '0' : '') + s;
        }

        function pad2(n) { return (n < 10 ? '0' : '') + n; }
        function fmtTime(sec, sep) {
            var h = Math.floor(sec / 3600);
            var m = Math.floor((sec % 3600) / 60);
            var s = Math.floor(sec % 60);
            var ms = Math.round((sec - Math.floor(sec)) * 1000);
            return pad2(h) + ':' + pad2(m) + ':' + pad2(s) + sep + String(ms).padStart(3, '0');
        }
        function toSrt(segments) {
            return segments.map(function (seg, i) {
                return (i + 1) + '\n' +
                       fmtTime(seg.start, ',') + ' --> ' + fmtTime(seg.end, ',') + '\n' +
                       (seg.text || '').trim();
            }).join('\n\n');
        }
        function toVtt(segments) {
            return 'WEBVTT\n\n' + segments.map(function (seg) {
                return fmtTime(seg.start, '.') + ' --> ' + fmtTime(seg.end, '.') + '\n' +
                       (seg.text || '').trim();
            }).join('\n\n');
        }

        copyBtn.addEventListener('click', function () {
            if (!lastResult) return;
            navigator.clipboard.writeText(lastResult.rendered).then(function () {
                var orig = copyBtn.textContent;
                copyBtn.textContent = 'Copied!';
                setTimeout(function () { copyBtn.textContent = orig; }, 1400);
            });
        });

        downloadBtn.addEventListener('click', function () {
            if (!lastResult) return;
            var fmt = lastResult.format;
            var mime = fmt === 'json' ? 'application/json'
                     : fmt === 'srt'  ? 'application/x-subrip'
                     : fmt === 'vtt'  ? 'text/vtt'
                                      : 'text/plain';
            var ext = fmt === 'json' ? 'json' : fmt;
            var base = (selectedFile && selectedFile.name ? selectedFile.name.replace(/\.[^.]+$/, '') : 'transcript');
            var blob = new Blob([lastResult.rendered], { type: mime + ';charset=utf-8' });
            var url = URL.createObjectURL(blob);
            var a = document.createElement('a');
            a.href = url;
            a.download = base + '.' + ext;
            document.body.appendChild(a);
            a.click();
            setTimeout(function () { URL.revokeObjectURL(url); a.remove(); }, 300);
        });
    })();
})();
