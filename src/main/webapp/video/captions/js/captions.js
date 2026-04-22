/**
 * Auto-Captions editor — client-side logic.
 *
 * Pipeline:
 *   1. User drops a video file (stays in the browser).
 *   2. We extract its audio track with Web Audio API (video-audio-extract.js).
 *   3. POST that audio to /video-service?action=caption-init which forwards
 *      to WhisperX via /transcribe-x and returns word-level timestamps.
 *   4. Render the video with a canvas overlay that draws the active caption
 *      chunk for the current playhead time. Styles are pure client state —
 *      changing a preset or colour re-renders at 60fps without server calls.
 *   5. On Export, ffmpeg.wasm (loaded lazily) burns the captions into the
 *      video frames via an ASS subtitle script. The output MP4 is a Blob
 *      the user downloads directly — the video never goes to a server.
 */
(function () {
    'use strict';

    // ── Config ────────────────────────────────────────────────────────
    var ctxMeta = document.querySelector('meta[name="ctx"]');
    var CTX = ctxMeta ? ctxMeta.getAttribute('content') : '';
    var INIT_URL = CTX + '/video-service?action=caption-init';
    var MAX_BASE64_BYTES = 33_500_000;  // must mirror VideoServiceServlet limit

    // ── Style presets ─────────────────────────────────────────────────
    // Each preset is a baseline style. The user can override fields via
    // the controls panel; `styleState` below is the merged, live state.
    var PRESETS = {
        'tiktok': {
            name: 'TikTok',
            thumb: 'BOLD',
            font: '"Anton", "Bebas Neue", Impact, sans-serif',
            fontSize: 56,
            weight: '900',
            letterSpacing: '0.02em',
            color: '#ffffff',
            hlColor: '#fde047',
            outline: '#000000',
            outlineWidth: 6,
            shadow: true,
            uppercase: true,
            maxWords: 3,
            position: 'middle',
            highlight: 'pop'
        },
        'podcast': {
            name: 'Podcast',
            thumb: 'Clean',
            font: '"Inter", system-ui, sans-serif',
            fontSize: 34,
            weight: '600',
            letterSpacing: '0',
            color: '#ffffff',
            hlColor: '#22d3ee',
            outline: '#000000',
            outlineWidth: 3,
            shadow: false,
            uppercase: false,
            maxWords: 4,
            position: 'bottom',
            highlight: 'karaoke'
        },
        'minimal': {
            name: 'Minimal',
            thumb: 'minimal',
            font: '"Inter", system-ui, sans-serif',
            fontSize: 28,
            weight: '500',
            letterSpacing: '0',
            color: '#ffffff',
            hlColor: '#ffffff',
            outline: '',
            outlineWidth: 0,
            shadow: true,
            uppercase: false,
            maxWords: 6,
            position: 'bottom',
            highlight: 'off'
        }
    };

    var styleState = Object.assign({}, PRESETS.tiktok);

    // ── Session state ─────────────────────────────────────────────────
    var selectedFile = null;    // original video File
    var videoURL = null;        // object URL for local playback
    var words = [];             // [{word, start, end, score}, ...]
    var chunks = [];            // computed from words + styleState.maxWords
    var currentChunkIdx = -1;
    var initProgressBar = null;
    var exportProgressBar = null;
    var audioDuration = 0;      // WhisperX-reported total audio length
    var editMode = false;
    var dirtyTimer = null;      // debounce for live-updates from edit mode

    // ── DOM handles ───────────────────────────────────────────────────
    var el = {
        fileInput:      document.getElementById('cap-file-input'),
        dropzone:       document.querySelector('#cap-empty .vs-drop'),
        uploadError:    document.getElementById('cap-upload-error'),
        stateEmpty:     document.getElementById('cap-empty'),
        stateLoading:   document.getElementById('cap-loading'),
        loadingName:    document.getElementById('cap-loading-filename'),
        initProgHost:   document.getElementById('cap-init-progress'),
        initError:      document.getElementById('cap-init-error'),
        editor:         document.getElementById('cap-editor'),
        video:          document.getElementById('cap-video'),
        canvas:         document.getElementById('cap-canvas'),
        strip:          document.getElementById('cap-strip'),
        editList:       document.getElementById('cap-edit-list'),
        editToggle:     document.getElementById('cap-edit-toggle'),
        editHint:       document.getElementById('cap-transcript-hint'),
        presets:        document.getElementById('cap-presets'),
        reset:          document.getElementById('cap-reset'),
        exportBtn:      document.getElementById('cap-export'),
        stateExporting: document.getElementById('cap-exporting'),
        exportProgHost: document.getElementById('cap-export-progress'),
        exportMeta:     document.getElementById('cap-export-meta'),
        exportError:    document.getElementById('cap-export-error'),
        exportCancel:   document.getElementById('cap-export-cancel')
    };

    // ── State transitions (show/hide the four states) ────────────────
    function showState(name) {
        el.stateEmpty.hidden     = name !== 'empty';
        el.stateLoading.hidden   = name !== 'loading';
        el.editor.hidden         = name !== 'editor';
        el.stateExporting.hidden = name !== 'exporting';
        announce({
            empty:     'Ready. Drop a video to start.',
            loading:   'Working on your transcript. This usually takes a minute or two.',
            editor:    'Transcript ready. You can pick a style or edit the words.',
            exporting: 'Creating your captioned video. This takes a few minutes.'
        }[name] || '');
    }
    function announce(msg) {
        var live = document.getElementById('cap-live');
        if (live && msg) live.textContent = msg;
    }

    // ── Error helpers ────────────────────────────────────────────────
    // Inline banner: used for upload-stage validation (wrong file type,
    // raw file too big). Sits next to the input so feedback is immediate.
    function showErr(node, msg) { node.textContent = msg; node.classList.add('active'); }
    function clearErr(node) { node.textContent = ''; node.classList.remove('active'); }

    // Modal: used for transcribe/export failures — rate limits, server
    // errors, "too long" clips, network failures. Rate-limit / capacity
    // errors get a "DM on X for higher limits" CTA; others get Close only.
    function showErrorModal(msg, opts) {
        opts = opts || {};
        var modal = document.getElementById('cap-modal');
        if (!modal) { alert(msg); return; }
        document.getElementById('cap-modal-title').textContent = opts.title || 'Something went wrong';
        document.getElementById('cap-modal-body').textContent  = msg || 'An unexpected error occurred.';
        document.getElementById('cap-modal-cta').hidden        = !opts.showX;
        modal.hidden = false;
        // Focus the Close button so Enter/Space dismisses and screen readers
        // announce the dialog content.
        setTimeout(function () {
            var close = document.getElementById('cap-modal-dismiss');
            if (close) close.focus();
        }, 20);
    }
    function hideErrorModal() {
        var modal = document.getElementById('cap-modal');
        if (modal) modal.hidden = true;
    }

    // Modal dismiss wiring — bound once on module init.
    (function bindErrorModal() {
        var modal = document.getElementById('cap-modal');
        if (!modal) return;
        var close = document.getElementById('cap-modal-dismiss');
        if (close) close.addEventListener('click', hideErrorModal);
        modal.addEventListener('click', function (e) { if (e.target === modal) hideErrorModal(); });
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape' && !modal.hidden) hideErrorModal();
        });
    })();

    // ── File selection ───────────────────────────────────────────────
    el.fileInput.addEventListener('change', function (e) {
        var f = e.target.files && e.target.files[0];
        if (f) handleFile(f);
    });
    ['dragenter', 'dragover'].forEach(function (ev) {
        el.dropzone.addEventListener(ev, function (e) {
            e.preventDefault(); e.stopPropagation();
            el.dropzone.classList.add('drag-active');
        });
    });
    ['dragleave', 'drop'].forEach(function (ev) {
        el.dropzone.addEventListener(ev, function (e) {
            e.preventDefault(); e.stopPropagation();
            el.dropzone.classList.remove('drag-active');
        });
    });
    el.dropzone.addEventListener('drop', function (e) {
        var f = e.dataTransfer && e.dataTransfer.files && e.dataTransfer.files[0];
        if (f) handleFile(f);
    });

    function handleFile(file) {
        clearErr(el.uploadError);
        var mime = (file.type || '').toLowerCase();
        if (mime.indexOf('video/') !== 0) {
            showErr(el.uploadError, 'Please upload a video file (MP4, MOV or WebM).');
            return;
        }
        if (file.size > 500 * 1024 * 1024) {
            showErr(el.uploadError, 'Video too large (' + (file.size / 1024 / 1024).toFixed(0) + ' MB). Max 500 MB.');
            return;
        }
        selectedFile = file;

        // Prepare the in-browser video player with a local blob URL.
        if (videoURL) URL.revokeObjectURL(videoURL);
        videoURL = URL.createObjectURL(file);
        el.video.src = videoURL;

        el.loadingName.textContent = file.name + ' · ' + fmtBytes(file.size);
        showState('loading');
        startInitProgress();

        // Early duration check: 16 kHz mono WAV is ~32 KB/s, so 25 MB ≈ 13 min.
        // If we know duration is > ~15 min, fail fast with a helpful error before
        // paying for audio decoding.
        el.video.addEventListener('loadedmetadata', function once() {
            el.video.removeEventListener('loadedmetadata', once);
            if (el.video.duration > 900) {
                stopInitProgress(false);
                showState('empty');
                showErrorModal(
                    'This video is ' + Math.round(el.video.duration / 60) + ' minutes long. ' +
                    'The free limit right now is about 15 minutes — try trimming it first, or ' +
                    'message me on X and I can bump your account limit.',
                    { title: 'Video is a bit long', showX: true }
                );
                return;
            }
            transcribe(file);
        });
    }

    // ── Transcribe (server trip) ──────────────────────────────────────
    function transcribe(file) {
        clearErr(el.initError);
        if (typeof window.VideoAudioExtract === 'undefined') {
            stopInitProgress(false);
            showErr(el.initError, 'Something didn\'t load properly. Please refresh the page and try again.');
            return;
        }
        // Wire extract progress into the mounted AIProgressBar so the user sees
        // real feedback during the 2–20s local decoding step. The extractor
        // emits pct 0..100; we nudge the bar's fill directly.
        var extractOpts = {
            onProgress: function (pct, label) {
                if (!initProgressBar || !initProgressBar.el) return;
                var fill = initProgressBar.el.querySelector('.aipb-fill');
                var msg  = initProgressBar.el.querySelector('.aipb-msg');
                if (fill) fill.style.width = Math.min(25, Math.round(pct * 0.25)) + '%';
                if (msg && label) msg.textContent = label;
            }
        };
        window.VideoAudioExtract.extract(file, extractOpts).then(function (audio) {
            if (audio.base64.length > MAX_BASE64_BYTES) {
                var eTooLong = new Error('This video is too long to transcribe right now. Please try a shorter clip (about 15 minutes or less), or message me on X for higher limits.');
                eTooLong.showX = true;
                throw eTooLong;
            }
            var payload = { audio: audio.base64, format: audio.format, task: 'transcribe' };
            return fetch(INIT_URL, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            });
        }).then(function (resp) {
            return resp.text().then(function (txt) {
                var data = {};
                try { data = txt ? JSON.parse(txt) : {}; } catch (e) {}
                if (resp.status === 429) {
                    var wait = resp.headers.get('Retry-After') || '60';
                    var e429 = new Error('Too many people using the tool right now. Please try again in about ' + wait + ' seconds.');
                    e429.showX = true;                              // let them ping for higher limits
                    throw e429;
                }
                if (!resp.ok || data.error) {
                    var es = new Error(data.error || 'Something went wrong while making the transcript. Please try again in a moment.');
                    // Server-side failures are capacity-adjacent — surface the X CTA.
                    es.showX = true;
                    throw es;
                }
                return data;
            });
        }).then(function (data) {
            words = flattenWords(data.segments || []);
            audioDuration = (typeof data.duration === 'number') ? data.duration : 0;
            if (!words.length) throw new Error('We couldn\'t hear any speech in this video. Make sure the audio track has clear speaking.');
            stopInitProgress(true);
            setTimeout(function () { enterEditor(); }, 600);
        }).catch(function (err) {
            stopInitProgress(false);
            showState('empty');                                     // back to drop zone so retry is obvious
            showErrorModal(err.message || String(err), { showX: err.showX === true });
        });
    }

    // Flatten WhisperX response {segments: [{words:[...]}]} → [{word,start,end,score}, ...]
    function flattenWords(segments) {
        var out = [];
        segments.forEach(function (s) {
            (s.words || []).forEach(function (w) {
                if (typeof w.start !== 'number' || typeof w.end !== 'number') return;
                out.push({
                    word: (w.word || '').trim(),
                    start: w.start,
                    end: w.end,
                    score: typeof w.score === 'number' ? w.score : 1
                });
            });
        });
        return out;
    }

    // ── Chunking (group words into caption "lines" of maxWords each) ─
    function recomputeChunks() {
        chunks = [];
        if (!words.length) return;
        var max = Math.max(1, styleState.maxWords || 3);
        var buf = [];
        for (var i = 0; i < words.length; i++) {
            buf.push(words[i]);
            var w = words[i];
            var next = words[i + 1];
            var gap = next ? (next.start - w.end) : 0;
            var full = buf.length >= max;
            var pause = gap > 0.4; // long silence = hard break
            if (full || pause || !next) {
                chunks.push({
                    start: buf[0].start,
                    end:   buf[buf.length - 1].end,
                    words: buf
                });
                buf = [];
            }
        }
    }

    // ── Editor entry ─────────────────────────────────────────────────
    function enterEditor() {
        recomputeChunks();
        renderStrip();
        renderPresets();
        updateTranscriptHint();
        setupCanvasSizing();
        bindControls();
        showState('editor');
        // Draw the first frame's caption as soon as metadata is available.
        if (el.video.readyState >= 1) { drawCaption(); }
        else { el.video.addEventListener('loadedmetadata', drawCaption, { once: true }); }
    }

    // Transcript strip with clickable word chips
    function renderStrip() {
        el.strip.innerHTML = '';
        var frag = document.createDocumentFragment();
        words.forEach(function (w, i) {
            var s = document.createElement('span');
            s.className = 'cap-word';
            s.textContent = w.word;
            s.dataset.i = String(i);
            s.title = w.start.toFixed(2) + 's';
            s.addEventListener('click', function () {
                el.video.currentTime = w.start;
                el.video.play();
            });
            frag.appendChild(s);
        });
        el.strip.appendChild(frag);
    }

    // ── Editable transcript (replaces the chip strip in edit mode) ───
    //
    // Rows are: [start input] [word input] [end input] [delete].
    // Insert affordances appear between every pair of adjacent rows and an
    // "Append at NNNs" button at the very end if there's audio past the last
    // word (WhisperX's VAD commonly drops silence/low-volume tail — users can
    // reclaim it here by typing the missing words with approximate timings).
    function renderEditList() {
        el.editList.innerHTML = '';
        var frag = document.createDocumentFragment();

        words.forEach(function (w, i) {
            frag.appendChild(buildEditRow(w, i));
            // Insert affordance between this word and the next
            var next = words[i + 1];
            if (next) {
                frag.appendChild(buildInsertAffordance(i, w.end, next.start));
            }
        });

        // Append-at-end button if there's notable audio past the last word
        if (words.length && audioDuration > 0) {
            var last = words[words.length - 1];
            var gap = audioDuration - last.end;
            if (gap > 0.5) frag.appendChild(buildAppendAffordance(last.end, audioDuration));
        }

        el.editList.appendChild(frag);
    }

    function buildEditRow(w, i) {
        var row = document.createElement('div');
        row.className = 'cap-edit-row';
        row.dataset.i = String(i);

        // ▶ play button — the most visible "hear this word" action.
        var play = document.createElement('button');
        play.type = 'button';
        play.className = 'cap-edit-play';
        play.innerHTML = '&#9654;';            // ▶
        play.title = 'Play this word (' + fmtTime(w.start) + ')';
        play.setAttribute('aria-label', 'Play word at ' + fmtTime(w.start));
        play.addEventListener('click', function () {
            playWord(w);
        });

        var tIn = textInput(w.word, 'Word text');

        // Timing inputs live under a compact "times" row (collapsed by default).
        var sIn = numberInput(w.start, 'Start time (seconds)');
        var eIn = numberInput(w.end, 'End time (seconds)');

        var del = document.createElement('button');
        del.type = 'button';
        del.className = 'cap-edit-del';
        del.innerHTML = '&times;';
        del.title = 'Delete word';
        del.setAttribute('aria-label', 'Delete word');

        // Live updates — debounced so typing doesn't chunk-recompute on every key.
        sIn.addEventListener('input', function () { w.start = Number(sIn.value) || 0; scheduleRefresh(); });
        eIn.addEventListener('input', function () { w.end   = Number(eIn.value) || 0; scheduleRefresh(); });
        tIn.addEventListener('input', function () { w.word  = tIn.value; scheduleRefresh(); });

        // Enter in the text field: move to the next row (or append when at the
        // tail). This gives a type → Enter → type rhythm for fast tail-filling.
        tIn.addEventListener('keydown', function (e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                var next = el.editList.querySelector('.cap-edit-row[data-i="' + (i + 1) + '"] input[type="text"]');
                if (next) {
                    next.focus();
                    next.select();
                } else {
                    // at the tail — hit the append-at-end button if present
                    var appendBtn = el.editList.querySelector('.cap-edit-append button');
                    if (appendBtn) appendBtn.click();
                }
            }
        });

        // Focusing the text field seeks the video and highlights the row.
        tIn.addEventListener('focus', function () {
            el.video.currentTime = w.start;
            highlightRow(i);
        });

        del.addEventListener('click', function () {
            words.splice(i, 1);
            finishEditRefresh();
            renderEditList();
        });

        var times = document.createElement('div');
        times.className = 'cap-edit-times';
        var sLabel = document.createElement('span');
        sLabel.className = 'cap-edit-time-label';
        sLabel.textContent = 'start';
        var eLabel = document.createElement('span');
        eLabel.className = 'cap-edit-time-label';
        eLabel.textContent = 'end';
        times.appendChild(sLabel);
        times.appendChild(sIn);
        times.appendChild(eLabel);
        times.appendChild(eIn);

        row.appendChild(play);
        row.appendChild(tIn);
        row.appendChild(del);
        row.appendChild(times);
        return row;
    }

    // Play just this word: seek + play, pause automatically at word.end.
    function playWord(w) {
        if (!w) return;
        el.video.currentTime = Math.max(0, w.start - 0.05);
        var end = Math.max(w.start + 0.2, w.end + 0.1);
        var stopAt = function () {
            if (el.video.currentTime >= end) {
                el.video.pause();
                el.video.removeEventListener('timeupdate', stopAt);
            }
        };
        el.video.addEventListener('timeupdate', stopAt);
        el.video.play();
    }

    // Highlight a row (and scroll it into view if offscreen). Cleared and
    // refreshed as the video plays (see setupEditActiveSync).
    function highlightRow(i) {
        var rows = el.editList.querySelectorAll('.cap-edit-row');
        rows.forEach(function (r) { r.classList.remove('active'); });
        var row = el.editList.querySelector('.cap-edit-row[data-i="' + i + '"]');
        if (!row) return;
        row.classList.add('active');
        // Only auto-scroll when the active row is out of sight; avoid jarring jumps otherwise.
        var list = el.editList;
        var rTop = row.offsetTop, rBot = rTop + row.offsetHeight;
        if (rTop < list.scrollTop || rBot > list.scrollTop + list.clientHeight) {
            list.scrollTop = rTop - list.clientHeight / 2;
        }
    }

    function fmtTime(sec) {
        sec = Math.max(0, sec || 0);
        var m = Math.floor(sec / 60);
        var s = (sec % 60);
        var whole = Math.floor(s);
        var cs = Math.round((s - whole) * 100);
        return m + ':' + (whole < 10 ? '0' : '') + whole + '.' + (cs < 10 ? '0' : '') + cs;
    }

    // Median word duration — sensible default for inserted / appended words.
    function avgWordDuration() {
        if (!words.length) return 0.5;
        var durs = words.map(function (w) { return Math.max(0.05, w.end - w.start); }).sort();
        return durs[Math.floor(durs.length / 2)];
    }

    function buildInsertAffordance(i, prevEnd, nextStart) {
        var wrap = document.createElement('div');
        wrap.className = 'cap-edit-insert';
        var btn = document.createElement('button');
        btn.type = 'button';
        var gap = nextStart - prevEnd;
        btn.textContent = '+ insert at ' + fmtTime((prevEnd + nextStart) / 2) +
                          (gap > 0.5 ? '  (' + gap.toFixed(1) + 's gap)' : '');
        btn.addEventListener('click', function () {
            var mid = (prevEnd + nextStart) / 2;
            // Default span = median word duration, clamped to fit inside the gap.
            var span = Math.min(avgWordDuration(), Math.max(0.15, gap * 0.7));
            var newWord = { word: '...', start: mid - span / 2, end: mid + span / 2, score: 1 };
            words.splice(i + 1, 0, newWord);
            finishEditRefresh();
            renderEditList();
            var newRow = el.editList.querySelector('.cap-edit-row[data-i="' + (i + 1) + '"]');
            var txtIn = newRow && newRow.querySelector('input[type="text"]');
            if (txtIn) { txtIn.focus(); txtIn.select(); }
        });
        wrap.appendChild(btn);
        return wrap;
    }

    function buildAppendAffordance(from, to) {
        var wrap = document.createElement('div');
        wrap.className = 'cap-edit-append';
        var btn = document.createElement('button');
        btn.type = 'button';
        btn.textContent = '+ Add word at end  (' + fmtTime(from) + ' → ' + fmtTime(to) + ')';
        btn.title = 'Fills ' + (to - from).toFixed(1) + 's of audio past the last transcribed word.  Press Enter while typing to append another.';
        btn.addEventListener('click', function () {
            var span = avgWordDuration();
            var start = Math.min(from + 0.2, Math.max(from, to - span - 0.1));
            var end   = Math.min(start + span, to);
            words.push({ word: '...', start: start, end: end, score: 1 });
            finishEditRefresh();
            renderEditList();
            var rows = el.editList.querySelectorAll('.cap-edit-row');
            var last = rows[rows.length - 1];
            var txtIn = last && last.querySelector('input[type="text"]');
            if (txtIn) { txtIn.focus(); txtIn.select(); }
        });
        wrap.appendChild(btn);
        return wrap;
    }

    function numberInput(value, label) {
        var inp = document.createElement('input');
        inp.type = 'number';
        inp.step = '0.01';
        inp.min = '0';
        inp.value = (Number(value) || 0).toFixed(2);
        inp.setAttribute('aria-label', label);
        return inp;
    }
    function textInput(value, label) {
        var inp = document.createElement('input');
        inp.type = 'text';
        inp.value = value || '';
        inp.setAttribute('aria-label', label);
        inp.autocomplete = 'off';
        inp.spellcheck = true;
        return inp;
    }

    // Debounced refresh — recomputes chunks and redraws canvas + strip.
    function scheduleRefresh() {
        if (dirtyTimer) clearTimeout(dirtyTimer);
        dirtyTimer = setTimeout(finishEditRefresh, 200);
    }
    function finishEditRefresh() {
        if (dirtyTimer) { clearTimeout(dirtyTimer); dirtyTimer = null; }
        // Clean up blanks and sort by start time — user may have typed weird values.
        words = words
            .filter(function (w) { return (w.word || '').trim().length > 0; })
            .map(function (w) {
                return {
                    word:  String(w.word).trim(),
                    start: Math.max(0, Number(w.start) || 0),
                    end:   Math.max(0, Number(w.end)   || 0),
                    score: w.score
                };
            })
            .sort(function (a, b) { return a.start - b.start; });
        recomputeChunks();
        renderStrip();
        drawCaption();
        updateTranscriptHint();
    }

    function updateTranscriptHint() {
        if (!el.editHint) return;
        var last = words[words.length - 1];
        var lastEnd = last ? last.end : 0;
        var tail = audioDuration > 0 ? Math.max(0, audioDuration - lastEnd) : 0;
        if (tail > 0.5) {
            el.editHint.textContent = words.length + ' words · ' + tail.toFixed(1) + 's of audio past last word';
        } else {
            el.editHint.textContent = words.length + ' words';
        }
    }

    function setEditMode(on) {
        editMode = !!on;
        el.strip.hidden = editMode;
        el.editList.hidden = !editMode;
        el.editToggle.textContent = editMode ? 'Done editing' : 'Edit transcript';
        el.editToggle.classList.toggle('vs-btn-primary', editMode);
        if (editMode) renderEditList();
    }

    // Preset buttons
    function renderPresets() {
        el.presets.innerHTML = '';
        Object.keys(PRESETS).forEach(function (key) {
            var p = PRESETS[key];
            var b = document.createElement('button');
            b.type = 'button';
            b.className = 'cap-preset' + (styleState === PRESETS[key] ? ' active' : '');
            b.dataset.preset = key;
            b.setAttribute('role', 'radio');
            b.setAttribute('aria-checked', styleState === PRESETS[key] ? 'true' : 'false');
            b.setAttribute('aria-label', p.name + ' caption style');
            var thumb = document.createElement('div');
            thumb.className = 'cap-preset-thumb';
            thumb.textContent = p.thumb;
            thumb.style.fontFamily = p.font;
            thumb.style.fontWeight = p.weight;
            thumb.style.textTransform = p.uppercase ? 'uppercase' : 'none';
            thumb.style.color = p.color;
            thumb.style.textShadow = p.outline
                ? '0 0 ' + p.outlineWidth + 'px ' + p.outline
                : (p.shadow ? '0 2px 4px rgba(0,0,0,0.7)' : 'none');
            var name = document.createElement('div');
            name.className = 'cap-preset-name';
            name.textContent = p.name;
            b.appendChild(thumb);
            b.appendChild(name);
            b.addEventListener('click', function () {
                styleState = Object.assign({}, PRESETS[key]);
                syncControlsToStyle();
                recomputeChunks();
                renderStrip();
                Array.prototype.forEach.call(el.presets.children, function (c) {
                    c.classList.remove('active');
                    c.setAttribute('aria-checked', 'false');
                });
                b.classList.add('active');
                b.setAttribute('aria-checked', 'true');
                drawCaption();
            });
            el.presets.appendChild(b);
        });
    }

    // Reflect current styleState into the radios / swatches / segmented
    function syncControlsToStyle() {
        document.querySelectorAll('input[name="cap-pos"]').forEach(function (r) {
            r.checked = r.value === styleState.position;
        });
        document.querySelectorAll('input[name="cap-hl"]').forEach(function (r) {
            r.checked = r.value === styleState.highlight;
        });
        document.querySelectorAll('.cap-seg-row button').forEach(function (b) {
            b.classList.toggle('active', Number(b.dataset.words) === styleState.maxWords);
        });
        document.querySelectorAll('.cap-swatch-row button[data-color]').forEach(function (b) {
            b.classList.toggle('active', b.dataset.color.toLowerCase() === (styleState.color || '').toLowerCase());
        });
        document.querySelectorAll('.cap-swatch-row button[data-hlcolor]').forEach(function (b) {
            b.classList.toggle('active', b.dataset.hlcolor.toLowerCase() === (styleState.hlColor || '').toLowerCase());
        });
    }

    // Bind control inputs — each change mutates styleState and re-draws.
    function bindControls() {
        document.querySelectorAll('input[name="cap-pos"]').forEach(function (r) {
            r.addEventListener('change', function () { styleState.position = r.value; drawCaption(); });
        });
        document.querySelectorAll('input[name="cap-hl"]').forEach(function (r) {
            r.addEventListener('change', function () { styleState.highlight = r.value; drawCaption(); });
        });
        document.querySelectorAll('.cap-seg-row button').forEach(function (b) {
            b.addEventListener('click', function () {
                styleState.maxWords = Number(b.dataset.words);
                document.querySelectorAll('.cap-seg-row button').forEach(function (x) { x.classList.remove('active'); });
                b.classList.add('active');
                recomputeChunks();
                renderStrip();
                drawCaption();
            });
        });
        document.querySelectorAll('.cap-swatch-row button[data-color]').forEach(function (b) {
            b.addEventListener('click', function () {
                styleState.color = b.dataset.color;
                document.querySelectorAll('.cap-swatch-row button[data-color]').forEach(function (x) { x.classList.remove('active'); });
                b.classList.add('active');
                drawCaption();
            });
        });
        document.querySelectorAll('.cap-swatch-row button[data-hlcolor]').forEach(function (b) {
            b.addEventListener('click', function () {
                styleState.hlColor = b.dataset.hlcolor;
                document.querySelectorAll('.cap-swatch-row button[data-hlcolor]').forEach(function (x) { x.classList.remove('active'); });
                b.classList.add('active');
                drawCaption();
            });
        });

        el.reset.addEventListener('click', resetAll);
        el.exportBtn.addEventListener('click', startExport);
        el.exportCancel.addEventListener('click', cancelExport);
        if (el.editToggle) el.editToggle.addEventListener('click', function () { setEditMode(!editMode); });

        el.video.addEventListener('timeupdate', onTimeUpdate);
        window.addEventListener('resize', function () { setupCanvasSizing(); drawCaption(); });

        // Keyboard shortcuts — only fire when focus isn't on an input/textarea
        document.addEventListener('keydown', function (e) {
            if (el.editor.hidden) return;
            var tag = (e.target && e.target.tagName) || '';
            if (tag === 'INPUT' || tag === 'TEXTAREA' || e.target.isContentEditable) return;
            if (e.key === ' ' || e.code === 'Space') {
                e.preventDefault();
                if (el.video.paused) el.video.play(); else el.video.pause();
            } else if (e.key === 'ArrowRight') {
                e.preventDefault();
                el.video.currentTime = Math.min(el.video.duration || 0, el.video.currentTime + 2);
            } else if (e.key === 'ArrowLeft') {
                e.preventDefault();
                el.video.currentTime = Math.max(0, el.video.currentTime - 2);
            }
        });

        syncControlsToStyle();
    }

    // ── Canvas sizing (match intrinsic video resolution) ─────────────
    function setupCanvasSizing() {
        var vw = el.video.videoWidth || el.video.clientWidth;
        var vh = el.video.videoHeight || el.video.clientHeight;
        if (!vw || !vh) return;
        var dpr = window.devicePixelRatio || 1;
        el.canvas.width  = vw * dpr;
        el.canvas.height = vh * dpr;
        el.canvas.dataset.dpr = String(dpr);
    }
    el.video.addEventListener('loadedmetadata', setupCanvasSizing);

    // ── Render one frame of captions onto the canvas ─────────────────
    function onTimeUpdate() {
        drawCaption();
    }

    function findActiveChunk(t) {
        // Simple linear scan — fine for 99% of clips (< a few hundred chunks).
        for (var i = 0; i < chunks.length; i++) {
            if (t >= chunks[i].start && t <= chunks[i].end + 0.05) return i;
        }
        return -1;
    }

    function drawCaption() {
        var ctx = el.canvas.getContext('2d');
        var W = el.canvas.width, H = el.canvas.height;
        ctx.clearRect(0, 0, W, H);
        if (!chunks.length) return;

        var t = el.video.currentTime;
        var idx = findActiveChunk(t);
        highlightStripWord(t);
        if (editMode) highlightEditRowForTime(t);
        currentChunkIdx = idx;
        if (idx < 0) return;
        var chunk = chunks[idx];

        // Font sizing scales with canvas internal height (which is video height × DPR),
        // so TikTok Bold looks consistent across 720p/1080p sources and hi-DPI screens.
        var dpr = Number(el.canvas.dataset.dpr || 1);
        var fontPx = Math.max(18 * dpr, styleState.fontSize * H / 720);
        ctx.font = styleState.weight + ' ' + fontPx + 'px ' + styleState.font;
        ctx.textBaseline = 'middle';
        ctx.textAlign = 'center';

        // Assemble line text (maybe uppercased)
        var display = chunk.words.map(function (w) {
            return styleState.uppercase ? (w.word || '').toUpperCase() : w.word;
        });
        var line = display.join(' ');

        // Position
        var y;
        if (styleState.position === 'top')      y = H * 0.14;
        else if (styleState.position === 'middle') y = H * 0.5;
        else                                       y = H * 0.82;

        // Word-pop highlight: find the active word in the chunk
        var activeWord = -1;
        if (styleState.highlight !== 'off') {
            for (var i = 0; i < chunk.words.length; i++) {
                if (t >= chunk.words[i].start && t <= chunk.words[i].end + 0.02) {
                    activeWord = i; break;
                }
            }
        }

        // Measure each word for karaoke / pop precision
        var spaceW = ctx.measureText(' ').width;
        var widths = display.map(function (s) { return ctx.measureText(s).width; });
        var totalW = widths.reduce(function (a, b) { return a + b; }, 0) + spaceW * (display.length - 1);
        var startX = (W - totalW) / 2;

        // Outline pass
        if (styleState.outline && styleState.outlineWidth > 0) {
            ctx.strokeStyle = styleState.outline;
            ctx.lineWidth = styleState.outlineWidth;
            ctx.lineJoin = 'round';
            drawLine(ctx, display, widths, spaceW, startX, y, null, 'stroke', activeWord);
        }
        // Shadow (soft)
        if (styleState.shadow) {
            ctx.shadowColor = 'rgba(0,0,0,0.7)';
            ctx.shadowBlur = 6 * dpr;
            ctx.shadowOffsetY = 2 * dpr;
        }
        // Fill pass
        ctx.fillStyle = styleState.color;
        drawLine(ctx, display, widths, spaceW, startX, y, styleState.hlColor, 'fill', activeWord);
        ctx.shadowColor = 'transparent';
        ctx.shadowBlur = 0;
        ctx.shadowOffsetY = 0;
    }

    function drawLine(ctx, display, widths, spaceW, startX, y, hlColor, mode, activeWord) {
        var x = startX;
        for (var i = 0; i < display.length; i++) {
            var isActive = i === activeWord;
            if (mode === 'fill' && isActive && hlColor && styleState.highlight !== 'off') {
                ctx.save();
                ctx.fillStyle = hlColor;
                if (styleState.highlight === 'pop') {
                    ctx.translate(x + widths[i] / 2, y);
                    ctx.scale(1.12, 1.12);
                    ctx.translate(-(x + widths[i] / 2), -y);
                }
                ctx.fillText(display[i], x + widths[i] / 2, y);
                ctx.restore();
            } else if (mode === 'stroke') {
                ctx.strokeText(display[i], x + widths[i] / 2, y);
            } else {
                ctx.fillText(display[i], x + widths[i] / 2, y);
            }
            x += widths[i] + spaceW;
        }
    }

    // Highlight the edit-mode row under the playhead.
    //
    // IMPORTANT: if the user is actively editing a row (focus is in a text or
    // number input), don't touch scroll or active-class. Video timeupdate
    // fires 4×/sec — any sync during editing yanks the view away from what
    // the user is looking at. Clicking a ▶ button still lets the sync run
    // (focus goes to a button, not an input) so playback feedback is intact.
    function highlightEditRowForTime(t) {
        var active = document.activeElement;
        if (active && el.editList.contains(active) && active.tagName === 'INPUT') return;
        var idx = -1;
        for (var i = 0; i < words.length; i++) {
            if (t >= words[i].start && t <= words[i].end + 0.05) { idx = i; break; }
        }
        if (idx < 0) return;
        highlightRow(idx);
    }

    // Highlight the word under the playhead in the transcript strip
    function highlightStripWord(t) {
        var nodes = el.strip.querySelectorAll('.cap-word');
        var activeIdx = -1;
        for (var i = 0; i < words.length; i++) {
            if (t >= words[i].start && t <= words[i].end + 0.02) { activeIdx = i; break; }
        }
        nodes.forEach(function (n) { n.classList.remove('active'); });
        if (activeIdx >= 0 && nodes[activeIdx]) {
            nodes[activeIdx].classList.add('active');
            // auto-scroll transcript strip
            var top = nodes[activeIdx].offsetTop - el.strip.clientHeight / 2;
            if (Math.abs(el.strip.scrollTop - top) > 40) el.strip.scrollTop = top;
        }
    }

    // ── Progress bars for init + export ──────────────────────────────
    function startInitProgress() {
        if (typeof window.AIProgressBar === 'undefined') return;
        initProgressBar = window.AIProgressBar.attach(el.initProgHost, {
            estimatedMs: 90000,
            phases: [
                { pct: 10, ms: 1500,  label: 'Getting your video ready...' },
                { pct: 25, ms: 6000,  label: 'Sending to our studio...' },
                { pct: 45, ms: 20000, label: 'Listening for speech...' },
                { pct: 70, ms: 45000, label: 'Writing the transcript...' },
                { pct: 88, ms: 75000, label: 'Almost done...' }
            ]
        });
        initProgressBar.start();
    }
    function stopInitProgress(success) { if (initProgressBar) initProgressBar.stop(success); }

    // ── Reset ────────────────────────────────────────────────────────
    function resetAll() {
        if (videoURL) { URL.revokeObjectURL(videoURL); videoURL = null; }
        selectedFile = null;
        words = [];
        chunks = [];
        audioDuration = 0;
        setEditMode(false);
        if (el.editList) el.editList.innerHTML = '';
        el.fileInput.value = '';
        el.video.pause();
        el.video.removeAttribute('src');
        el.video.load();
        clearErr(el.uploadError);
        clearErr(el.initError);
        clearErr(el.exportError);
        showState('empty');
    }

    // ── Export hooks (wired up in Task 7 / ffmpeg.wasm module) ───────
    // Placeholder handlers — the real implementations live in the
    // export module (Task 7).  Defining them here keeps the UI wired
    // so a click still gives feedback if Task 7 hasn't loaded yet.
    function startExport() {
        if (typeof window.CaptionExport === 'function') {
            window.CaptionExport({
                file: selectedFile,
                chunks: chunks,
                words: words,
                style: styleState,
                video: el.video,
                ui: {
                    setState: showState,
                    host: el.exportProgHost,
                    meta: el.exportMeta,
                    // Route export errors through the shared modal; export
                    // failures often indicate memory pressure or network, both
                    // worth reaching out about → show the X CTA.
                    error: {
                        show: function (msg) {
                            showState('editor');
                            showErrorModal(msg, { showX: true, title: 'Couldn\'t finish your video' });
                        }
                    },
                    onDone: function () { showState('editor'); }
                }
            });
        } else {
            showErrorModal('The exporter is still loading. Please wait a moment and try again.');
        }
    }
    function cancelExport() {
        if (typeof window.CaptionExportCancel === 'function') window.CaptionExportCancel();
        showState('editor');
    }

    // ── Small helpers ────────────────────────────────────────────────
    function fmtBytes(n) {
        if (n < 1024) return n + ' B';
        if (n < 1024 * 1024) return (n / 1024).toFixed(0) + ' KB';
        return (n / 1024 / 1024).toFixed(1) + ' MB';
    }

    // Start in empty state on page load
    showState('empty');
})();
