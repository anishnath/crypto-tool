/**
 * AIVisionModal — reusable "upload image → get code" modal.
 * Posts to /ai?action=vision (AIProxyServlet handleVision). Server chooses model.
 *
 * Usage:
 *   AIVisionModal.open({
 *     title:        'Image to JSCAD',          // required
 *     subtitle:     'Upload a sketch...',      // optional
 *     ctx:          '/crypto-tool',            // context path (required)
 *     systemPrompt: 'You are a JSCAD...',      // required
 *     userPrompt:   'Convert this image...',   // optional
 *     estimatedMs:  240000,                    // optional, default ~4 min
 *     phases:       [...]                      // optional, custom progress phases
 *     cleanCode:    function(raw) {...},       // optional post-processor
 *     onResult:     function(code, data) {},   // required — receives cleaned text
 *     onError:      function(msg) {}           // optional
 *   });
 */
(function (global) {
    'use strict';

    var MAX_SIZE = 10 * 1024 * 1024; // 10MB (matches AIProxyServlet limit)
    var DEFAULT_ESTIMATED_MS = 360000; // 6 min — matches AIProxyServlet vision timeout
    var DEFAULT_PHASES = [
        { pct: 10, ms: 5000,   label: 'Uploading image...' },
        { pct: 22, ms: 30000,  label: 'Waiting in queue...' },
        { pct: 38, ms: 75000,  label: 'Analyzing image...' },
        { pct: 55, ms: 150000, label: 'Identifying structure...' },
        { pct: 72, ms: 225000, label: 'Generating code...' },
        { pct: 85, ms: 300000, label: 'Refining output...' },
        { pct: 92, ms: 340000, label: 'Almost done...' }
    ];

    var modalEl = null;
    var cfg = null;
    var imageB64 = null;
    var progressTimer = null;
    var busy = false;
    var abortCtl = null;

    function $(sel) { return modalEl.querySelector(sel); }

    function buildModal() {
        if (modalEl) return;

        modalEl = document.createElement('div');
        modalEl.className = 'aivm-backdrop';
        modalEl.setAttribute('role', 'dialog');
        modalEl.setAttribute('aria-modal', 'true');
        modalEl.innerHTML =
            '<div class="aivm-modal">'
          +   '<div class="aivm-header">'
          +     '<div class="aivm-header-text">'
          +       '<h3 class="aivm-title"></h3>'
          +       '<p class="aivm-subtitle"></p>'
          +     '</div>'
          +     '<button type="button" class="aivm-close" aria-label="Close">&times;</button>'
          +   '</div>'
          +   '<div class="aivm-body">'
          +     '<label class="aivm-dropzone">'
          +       '<svg class="aivm-dropzone-icon" width="42" height="42" fill="currentColor" viewBox="0 0 16 16" aria-hidden="true">'
          +         '<path d="M6.002 5.5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0z"/>'
          +         '<path d="M2.002 1a2 2 0 0 0-2 2v10a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V3a2 2 0 0 0-2-2h-12zm12 1a1 1 0 0 1 1 1v6.5l-3.777-1.947a.5.5 0 0 0-.577.093l-3.71 3.71-2.66-1.772a.5.5 0 0 0-.63.062L1.002 12V3a1 1 0 0 1 1-1h12z"/>'
          +       '</svg>'
          +       '<p><strong>Drop an image</strong>, paste (Ctrl/Cmd+V), or <span class="aivm-choose-link">browse</span></p>'
          +       '<p class="aivm-dropzone-hint">PNG, JPG, WebP — up to 10MB</p>'
          +       '<input type="file" class="aivm-file-input" accept="image/*" />'
          +     '</label>'
          +     '<div class="aivm-preview" style="display:none">'
          +       '<img class="aivm-preview-img" alt="Selected image preview" />'
          +       '<div class="aivm-preview-meta">'
          +         '<span class="aivm-filename"></span>'
          +         '<button type="button" class="aivm-remove">Remove</button>'
          +       '</div>'
          +     '</div>'
          +     '<div class="aivm-progress" style="display:none">'
          +       '<div class="aivm-progress-text">'
          +         '<span class="aivm-progress-label"><span class="aivm-spinner"></span>Analyzing...</span>'
          +         '<span class="aivm-progress-time">~4 min</span>'
          +       '</div>'
          +       '<div class="aivm-progress-bar"><div class="aivm-progress-fill"></div></div>'
          +     '</div>'
          +     '<div class="aivm-error" style="display:none"></div>'
          +   '</div>'
          +   '<div class="aivm-footer">'
          +     '<button type="button" class="aivm-btn aivm-cancel">Cancel</button>'
          +     '<button type="button" class="aivm-btn aivm-btn-primary aivm-analyze" disabled>Analyze</button>'
          +   '</div>'
          + '</div>';
        document.body.appendChild(modalEl);

        $('.aivm-file-input').addEventListener('change', function (e) {
            var f = e.target.files && e.target.files[0];
            if (f) handleFile(f);
        });

        // Drag & drop
        var dz = $('.aivm-dropzone');
        ['dragenter', 'dragover'].forEach(function (ev) {
            dz.addEventListener(ev, function (e) {
                e.preventDefault(); e.stopPropagation();
                dz.classList.add('drag-active');
            });
        });
        ['dragleave', 'drop'].forEach(function (ev) {
            dz.addEventListener(ev, function (e) {
                e.preventDefault(); e.stopPropagation();
                dz.classList.remove('drag-active');
            });
        });
        dz.addEventListener('drop', function (e) {
            var f = e.dataTransfer && e.dataTransfer.files && e.dataTransfer.files[0];
            if (f) handleFile(f);
        });

        $('.aivm-remove').addEventListener('click', function (e) {
            e.preventDefault();
            resetToDropzone();
        });

        $('.aivm-close').addEventListener('click', tryClose);
        $('.aivm-cancel').addEventListener('click', tryClose);
        modalEl.addEventListener('click', function (e) {
            if (e.target === modalEl) tryClose();
        });

        $('.aivm-analyze').addEventListener('click', runAnalysis);

        // Global paste — only consumes when modal is open
        document.addEventListener('paste', function (e) {
            if (!modalEl || !modalEl.classList.contains('open') || busy) return;
            var items = e.clipboardData && e.clipboardData.items;
            if (!items) return;
            for (var i = 0; i < items.length; i++) {
                if (items[i].type && items[i].type.indexOf('image/') === 0) {
                    var blob = items[i].getAsFile();
                    if (blob) {
                        e.preventDefault();
                        handleFile(blob);
                    }
                    return;
                }
            }
        });

        // Esc to close
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape' && modalEl.classList.contains('open')) tryClose();
        });
    }

    function handleFile(file) {
        if (!file.type || file.type.indexOf('image/') !== 0) {
            showError('Not an image file. Please upload PNG, JPG, or WebP.');
            return;
        }
        if (file.size > MAX_SIZE) {
            showError('Image too large (' + (file.size / 1024 / 1024).toFixed(1) + 'MB). Max is 10MB.');
            return;
        }
        clearError();
        var reader = new FileReader();
        reader.onload = function (ev) {
            var dataUrl = ev.target.result;
            imageB64 = dataUrl.split(',')[1];
            $('.aivm-preview-img').src = dataUrl;
            $('.aivm-filename').textContent =
                (file.name || 'pasted image') + ' · ' + (file.size / 1024).toFixed(0) + ' KB';
            $('.aivm-dropzone').style.display = 'none';
            $('.aivm-preview').style.display = 'block';
            $('.aivm-analyze').disabled = false;
        };
        reader.onerror = function () { showError('Failed to read file.'); };
        reader.readAsDataURL(file);
    }

    function resetToDropzone() {
        imageB64 = null;
        clearError();
        $('.aivm-preview').style.display = 'none';
        $('.aivm-dropzone').style.display = 'block';
        $('.aivm-file-input').value = '';
        $('.aivm-analyze').disabled = true;
    }

    function showError(msg) {
        var el = $('.aivm-error');
        el.textContent = msg;
        el.style.display = 'block';
    }
    function clearError() {
        var el = $('.aivm-error');
        el.style.display = 'none';
        el.textContent = '';
    }

    function tryClose() {
        if (busy) {
            if (global.confirm('Analysis in progress. Cancel and close?')) {
                if (abortCtl) { try { abortCtl.abort(); } catch (e) {} }
                cleanup();
                modalEl.classList.remove('open');
            }
            return;
        }
        cleanup();
        modalEl.classList.remove('open');
    }

    function cleanup() {
        if (progressTimer) { clearInterval(progressTimer); progressTimer = null; }
        busy = false;
        abortCtl = null;
        $('.aivm-progress').style.display = 'none';
        $('.aivm-progress-fill').style.width = '0%';
        $('.aivm-cancel').textContent = 'Cancel';
        $('.aivm-analyze').disabled = !imageB64;
    }

    function formatRemaining(ms) {
        if (ms <= 0) return 'almost done';
        if (ms < 60000) return '~' + Math.max(1, Math.ceil(ms / 1000)) + 's';
        var m = Math.ceil(ms / 60000);
        return m === 1 ? '~1 min' : '~' + m + ' min';
    }

    function startProgress(phases, estimatedMs) {
        var progEl  = $('.aivm-progress');
        var fillEl  = $('.aivm-progress-fill');
        var labelEl = $('.aivm-progress-label');
        var timeEl  = $('.aivm-progress-time');
        progEl.style.display = 'block';
        fillEl.style.transition = 'none';
        fillEl.style.width = '0%';
        var startTime = Date.now();

        function labelHTML(txt) { return '<span class="aivm-spinner"></span>' + txt; }

        progressTimer = setInterval(function () {
            var elapsed = Date.now() - startTime;
            var pct = 0, label = phases[0].label;
            for (var i = phases.length - 1; i >= 0; i--) {
                if (elapsed >= phases[i].ms) {
                    pct = phases[i].pct;
                    label = phases[i].label;
                    if (i < phases.length - 1) {
                        var next = phases[i + 1];
                        var frac = (elapsed - phases[i].ms) / (next.ms - phases[i].ms);
                        pct += (next.pct - pct) * Math.min(frac, 1);
                    }
                    break;
                }
            }
            if (elapsed < phases[0].ms) {
                pct = (elapsed / phases[0].ms) * phases[0].pct;
                label = phases[0].label;
            }
            fillEl.style.transition = 'width 1s linear';
            fillEl.style.width = Math.min(pct, 95) + '%';
            labelEl.innerHTML = labelHTML(label);
            timeEl.textContent = formatRemaining(estimatedMs - elapsed);
        }, 1000);
    }

    function stopProgress(success) {
        if (progressTimer) { clearInterval(progressTimer); progressTimer = null; }
        if (!success) return;
        var fillEl = $('.aivm-progress-fill');
        var labelEl = $('.aivm-progress-label');
        var timeEl = $('.aivm-progress-time');
        fillEl.style.transition = 'width 0.3s ease';
        fillEl.style.width = '100%';
        labelEl.textContent = 'Done!';
        timeEl.textContent = '';
    }

    function defaultClean(raw) {
        if (!raw) return '';
        return raw
            .replace(/^```[a-zA-Z]*\s*\n?/gm, '')
            .replace(/\n?```\s*$/gm, '')
            .replace(/<think>[\s\S]*?<\/think>/g, '')
            .trim();
    }

    function runAnalysis() {
        if (!imageB64 || busy) return;
        busy = true;
        clearError();
        $('.aivm-analyze').disabled = true;
        $('.aivm-cancel').textContent = 'Cancel request';

        var phases = (cfg.phases && cfg.phases.length) ? cfg.phases : DEFAULT_PHASES;
        var estimatedMs = cfg.estimatedMs || DEFAULT_ESTIMATED_MS;
        startProgress(phases, estimatedMs);

        var messages = [];
        if (cfg.systemPrompt) messages.push({ role: 'system', content: cfg.systemPrompt });
        messages.push({ role: 'user', content: cfg.userPrompt || 'Analyze this image and generate the requested output.' });

        var url = (cfg.ctx || '') + '/ai?action=vision';
        abortCtl = (typeof AbortController !== 'undefined') ? new AbortController() : null;

        // Note: no `model` field — server defaults to gemma4:latest
        var body = JSON.stringify({
            image: imageB64,
            stream: false,
            messages: messages
        });

        fetch(url, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: body,
            signal: abortCtl ? abortCtl.signal : undefined
        })
        .then(function (resp) {
            return resp.text().then(function (txt) {
                var data;
                try { data = txt ? JSON.parse(txt) : {}; } catch (e) { data = { error: 'Malformed response' }; }
                return { ok: resp.ok, status: resp.status, data: data, headers: resp.headers };
            });
        })
        .then(function (r) {
            if (r.status === 429) {
                var wait = r.headers.get('Retry-After') || '60';
                throw new Error('Rate limit reached. Try again in ' + wait + 's.');
            }
            if (!r.ok || r.data.error) {
                throw new Error(r.data.error || r.data.message || 'Analysis failed (HTTP ' + r.status + ')');
            }
            var raw = '';
            if (r.data.message && r.data.message.content) raw = r.data.message.content;
            else if (r.data.response) raw = r.data.response;
            if (!raw) throw new Error('No content returned from model');

            var cleaner = cfg.cleanCode || defaultClean;
            var cleaned = cleaner(raw);
            stopProgress(true);
            setTimeout(function () {
                var result = cleaned;
                var rawData = r.data;
                cleanup();
                modalEl.classList.remove('open');
                if (typeof cfg.onResult === 'function') {
                    try { cfg.onResult(result, rawData); } catch (e) { console.error('[AIVisionModal] onResult error:', e); }
                }
            }, 600);
        })
        .catch(function (err) {
            if (err && err.name === 'AbortError') { cleanup(); return; }
            stopProgress(false);
            var msg = (err && err.message) ? err.message : String(err);
            showError(msg);
            if (typeof cfg.onError === 'function') {
                try { cfg.onError(msg); } catch (e) { console.error('[AIVisionModal] onError error:', e); }
            }
            busy = false;
            $('.aivm-analyze').disabled = !imageB64;
            $('.aivm-cancel').textContent = 'Close';
        });
    }

    function open(config) {
        buildModal();
        cfg = config || {};
        resetToDropzone();
        cleanup();

        $('.aivm-title').textContent = cfg.title || 'Image to Code';
        var sub = $('.aivm-subtitle');
        if (cfg.subtitle) { sub.textContent = cfg.subtitle; sub.style.display = 'block'; }
        else { sub.textContent = ''; sub.style.display = 'none'; }

        $('.aivm-progress-time').textContent = formatRemaining(cfg.estimatedMs || DEFAULT_ESTIMATED_MS);
        modalEl.classList.add('open');
    }

    global.AIVisionModal = { open: open };
})(window);
