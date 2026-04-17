/**
 * Image to LaTeX — modal overlay that converts images to LaTeX via OCR.
 *
 * Supports: drag-drop, clipboard paste (Ctrl+V), file picker.
 * Validates: JPEG/PNG/WEBP/GIF/BMP, max 10MB.
 * Calls: /ai?action=ocr with mode=formula|text|table, streams response.
 * Inserts result into the LaTeX editor at cursor position.
 */
(function () {
    'use strict';

    var AI_URL = '';
    var overlay = null;
    var initialized = false;
    var imageData = null;
    var isOpen = false;
    var busy = false;
    var abortCtrl = null;

    var ALLOWED_TYPES = ['image/jpeg', 'image/png', 'image/webp', 'image/gif', 'image/bmp'];
    var MAX_SIZE_BYTES = 10 * 1024 * 1024;

    // ── DOM refs (set during init) ──
    var els = {};

    function init() {
        if (initialized) return;
        var ctx = (window.CONFIG && CONFIG.ctx) ? CONFIG.ctx : '';
        AI_URL = ctx + '/ai?action=ocr';
        createModal();
        setupGlobalListeners();
        initialized = true;
    }

    function createModal() {
        overlay = document.createElement('div');
        overlay.id = 'itl-overlay';
        overlay.className = 'itl-overlay';
        overlay.style.display = 'none';
        overlay.innerHTML =
            '<div class="itl-modal" role="dialog" aria-label="Image to LaTeX">' +
            '  <div class="itl-header">' +
            '    <span class="itl-title">&#128247; Image to LaTeX</span>' +
            '    <button class="itl-close" data-action="close" title="Close (Esc)">&times;</button>' +
            '  </div>' +
            '  <div class="itl-body">' +
            '    <div class="itl-dropzone" data-action="browse">' +
            '      <div class="itl-dropzone-icon">&#128444;</div>' +
            '      <div class="itl-dropzone-text">Drop image, paste (Ctrl+V), or <span class="itl-browse">browse</span></div>' +
            '      <div class="itl-dropzone-hint">JPEG, PNG, WEBP &bull; Max 10MB</div>' +
            '    </div>' +
            '    <input type="file" class="itl-file-input" accept="image/jpeg,image/png,image/webp,image/gif,image/bmp" />' +
            '    <div class="itl-preview" style="display:none;">' +
            '      <img class="itl-preview-img" />' +
            '      <div class="itl-preview-info"></div>' +
            '      <button class="itl-remove" data-action="remove" title="Remove image">&times;</button>' +
            '    </div>' +
            '    <div class="itl-modes">' +
            '      <label class="itl-mode"><input type="radio" name="itl-mode" value="text" checked /> Text + Math</label>' +
            '      <label class="itl-mode"><input type="radio" name="itl-mode" value="formula" /> Formula only</label>' +
            '    </div>' +
            '    <div class="itl-error" style="display:none;"></div>' +
            '    <button class="itl-convert-btn" data-action="convert" disabled>Convert to LaTeX</button>' +
            '    <div class="itl-status" style="display:none;"></div>' +
            '    <div class="itl-result" style="display:none;">' +
            '      <div class="itl-result-label">Result:</div>' +
            '      <pre class="itl-result-code"></pre>' +
            '      <div class="itl-result-actions">' +
            '        <button class="itl-btn-primary" data-action="insert">Insert at Cursor</button>' +
            '        <button class="itl-btn" data-action="copy">Copy</button>' +
            '      </div>' +
            '    </div>' +
            '  </div>' +
            '</div>';

        document.body.insertBefore(overlay, document.body.firstChild);

        // Cache DOM refs
        var modal = overlay.querySelector('.itl-modal');
        els.dropzone = overlay.querySelector('.itl-dropzone');
        els.fileInput = overlay.querySelector('.itl-file-input');
        els.preview = overlay.querySelector('.itl-preview');
        els.previewImg = overlay.querySelector('.itl-preview-img');
        els.previewInfo = overlay.querySelector('.itl-preview-info');
        els.error = overlay.querySelector('.itl-error');
        els.convertBtn = overlay.querySelector('[data-action="convert"]');
        els.status = overlay.querySelector('.itl-status');
        els.result = overlay.querySelector('.itl-result');
        els.resultCode = overlay.querySelector('.itl-result-code');

        // ── Event delegation on the modal ──
        overlay.addEventListener('click', function (e) {
            var action = e.target.getAttribute('data-action') || e.target.closest('[data-action]');
            if (action && typeof action === 'object') action = action.getAttribute('data-action');

            switch (action) {
                case 'close': close(); break;
                case 'browse': els.fileInput.click(); break;
                case 'remove': clearImage(); break;
                case 'convert': doConvert(); break;
                case 'insert': doInsert(); break;
                case 'copy': doCopy(); break;
                default:
                    // Click on backdrop (overlay itself, not modal)
                    if (e.target === overlay) close();
            }
        });

        // File input change
        els.fileInput.addEventListener('change', function (e) {
            if (e.target.files && e.target.files[0]) handleFile(e.target.files[0]);
            e.target.value = '';
        });

        // Drag and drop on dropzone
        els.dropzone.addEventListener('dragover', function (e) {
            e.preventDefault();
            e.stopPropagation();
            els.dropzone.classList.add('dragover');
        });
        els.dropzone.addEventListener('dragleave', function (e) {
            e.preventDefault();
            els.dropzone.classList.remove('dragover');
        });
        els.dropzone.addEventListener('drop', function (e) {
            e.preventDefault();
            e.stopPropagation();
            els.dropzone.classList.remove('dragover');
            if (e.dataTransfer.files && e.dataTransfer.files[0]) handleFile(e.dataTransfer.files[0]);
        });
    }

    // ── Global listeners ──
    function setupGlobalListeners() {
        // Paste (only when modal is open)
        document.addEventListener('paste', function (e) {
            if (!isOpen) return;
            var items = e.clipboardData ? e.clipboardData.items : [];
            for (var i = 0; i < items.length; i++) {
                if (items[i].type.indexOf('image') !== -1) {
                    e.preventDefault();
                    e.stopPropagation();
                    handleFile(items[i].getAsFile());
                    return;
                }
            }
        });

        // Escape key closes modal
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape' && isOpen) {
                e.preventDefault();
                close();
            }
        });
    }

    // ── File handling & validation ──
    function handleFile(file) {
        hideError();

        if (ALLOWED_TYPES.indexOf(file.type) === -1) {
            showError('Unsupported format: ' + (file.type || 'unknown') + '. Use JPEG, PNG, or WEBP.');
            return;
        }
        if (file.size > MAX_SIZE_BYTES) {
            showError('Image too large (' + (file.size / 1024 / 1024).toFixed(1) + 'MB). Maximum is 10MB.');
            return;
        }
        if (file.size < 100) {
            showError('Image file appears empty or corrupt.');
            return;
        }

        var reader = new FileReader();
        reader.onload = function (e) {
            var dataUrl = e.target.result;
            var base64 = dataUrl.split(',')[1];
            if (!base64 || base64.length < 50) { showError('Could not read image data.'); return; }

            imageData = {
                base64: base64,
                dataUrl: dataUrl,
                type: file.type,
                size: file.size,
                name: file.name || 'pasted-image'
            };
            showPreview();
        };
        reader.onerror = function () { showError('Failed to read file.'); };
        reader.readAsDataURL(file);
    }

    function showPreview() {
        els.dropzone.style.display = 'none';
        els.preview.style.display = 'flex';
        els.previewImg.src = imageData.dataUrl;
        els.previewInfo.textContent =
            imageData.name + ' \u2022 ' +
            formatSize(imageData.size) + ' \u2022 ' +
            imageData.type.split('/')[1].toUpperCase();
        els.convertBtn.disabled = false;
        els.result.style.display = 'none';
        els.status.style.display = 'none';
    }

    function clearImage() {
        imageData = null;
        els.dropzone.style.display = '';
        els.preview.style.display = 'none';
        els.previewImg.src = '';
        els.convertBtn.disabled = true;
        els.convertBtn.textContent = 'Convert to LaTeX';
        els.result.style.display = 'none';
        els.status.style.display = 'none';
        hideError();
    }

    function formatSize(bytes) {
        if (bytes < 1024) return bytes + ' B';
        if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(0) + ' KB';
        return (bytes / 1024 / 1024).toFixed(1) + ' MB';
    }

    // ── Convert ──
    function doConvert() {
        if (!imageData || busy) return;
        busy = true;
        hideError();

        // Cancel any previous in-flight request
        if (abortCtrl) abortCtrl.abort();
        abortCtrl = new AbortController();

        els.convertBtn.disabled = true;
        els.convertBtn.textContent = 'Converting\u2026';
        els.status.style.display = 'block';
        els.status.textContent = 'Analyzing image\u2026';
        els.status.className = 'itl-status loading';
        els.result.style.display = 'block';
        els.resultCode.textContent = '';

        var mode = overlay.querySelector('input[name="itl-mode"]:checked').value;

        fetch(AI_URL, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ image: imageData.base64, mode: mode, stream: true }),
            signal: abortCtrl.signal
        })
        .then(function (res) {
            if (!res.ok) return res.json().then(function (d) { throw new Error(d.error || 'OCR failed'); });

            els.status.textContent = 'Recognizing content\u2026';
            var reader = res.body.getReader();
            var decoder = new TextDecoder();
            var buffer = '';
            var hasContent = false;

            function processChunk(result) {
                if (result.done) { finish(hasContent); return; }
                buffer += decoder.decode(result.value, { stream: true });
                var lines = buffer.split('\n');
                buffer = lines.pop();

                for (var i = 0; i < lines.length; i++) {
                    var line = lines[i].trim();
                    if (!line) continue;
                    try {
                        var obj = JSON.parse(line);
                        if (obj.response) {
                            hasContent = true;
                            els.resultCode.textContent += obj.response;
                            els.resultCode.scrollTop = els.resultCode.scrollHeight;
                            els.status.textContent = 'Converting to LaTeX\u2026';
                        }
                        if (obj.done === true) { finish(hasContent); return; }
                    } catch (e) {}
                }
                return reader.read().then(processChunk);
            }
            return reader.read().then(processChunk);
        })
        .catch(function (err) {
            if (err.name === 'AbortError') return; // user cancelled
            showError(err.message);
            els.result.style.display = 'none';
            finish(false);
        });

        function finish(success) {
            busy = false;
            abortCtrl = null;
            els.convertBtn.disabled = false;
            els.convertBtn.textContent = 'Convert to LaTeX';
            if (success) {
                // Post-process: fix common OCR LaTeX issues
                els.resultCode.textContent = fixLatex(els.resultCode.textContent);
                els.status.textContent = 'Done! Review the result below.';
                els.status.className = 'itl-status success';
                setTimeout(function () { els.status.style.display = 'none'; }, 3000);
            } else {
                els.status.style.display = 'none';
            }
        }
    }

    // ── Insert into editor ──
    function doInsert() {
        var code = els.resultCode.textContent;
        if (!code) return;

        var cm = window.editorInstance || window.editor;
        if (cm && cm.getDoc) {
            var doc = cm.getDoc();
            var cursor = doc.getCursor();
            // If cursor is at the default start and doc has content, append at end
            if (cursor.line === 0 && cursor.ch === 0 && doc.lineCount() > 1) {
                var lastLine = doc.lastLine();
                cursor = { line: lastLine, ch: doc.getLine(lastLine).length };
            }
            var prefix = (cursor.line > 0 || cursor.ch > 0) ? '\n' : '';
            doc.replaceRange(prefix + code + '\n', cursor);
            cm.focus();
        }
        close();
    }

    // ── Copy ──
    function doCopy() {
        var code = els.resultCode.textContent;
        if (!code) return;
        navigator.clipboard.writeText(code).then(function () {
            var btn = overlay.querySelector('[data-action="copy"]');
            var original = btn.textContent;
            btn.textContent = 'Copied!';
            setTimeout(function () { btn.textContent = original; }, 2000);
        });
    }

    // ── Post-process OCR output to fix common LaTeX issues ──
    function fixLatex(text) {
        if (!text) return text;

        // Fix display math: lines starting with $$ must end with $$
        var lines = text.split('\n');
        for (var i = 0; i < lines.length; i++) {
            var trimmed = lines[i].trim();
            if (trimmed.length <= 2) continue;
            // Starts with $$
            if (trimmed.charAt(0) === '$' && trimmed.charAt(1) === '$') {
                // Already ends with $$ — OK
                if (trimmed.length >= 4 && trimmed.charAt(trimmed.length - 1) === '$' && trimmed.charAt(trimmed.length - 2) === '$') {
                    continue;
                }
                // Ends with single $ — add one more
                if (trimmed.charAt(trimmed.length - 1) === '$') {
                    lines[i] = lines[i] + '$';
                } else {
                    // No closing $ at all — add $$
                    lines[i] = lines[i] + '$$';
                }
            }
        }
        text = lines.join('\n');

        // Fix unmatched single $ in inline math
        // Count $ per line (ignoring \$ escaped and $$)
        lines = text.split('\n');
        for (var j = 0; j < lines.length; j++) {
            var l = lines[j];
            // Skip display math lines
            if (/^\s*\$\$/.test(l)) continue;
            // Count unescaped single $ (not $$ and not \$)
            var stripped = l.replace(/\\\$/g, '').replace(/\$\$/g, '');
            var count = (stripped.match(/\$/g) || []).length;
            // Odd number of $ means one is unclosed — append one
            if (count > 0 && count % 2 !== 0) {
                lines[j] = l + '$';
            }
        }
        text = lines.join('\n');

        return text;
    }

    // ── UI helpers ──
    function showError(msg) { els.error.textContent = msg; els.error.style.display = 'block'; }
    function hideError() { els.error.style.display = 'none'; }

    function open() {
        if (!initialized) init();
        if (!overlay) { console.error('ITL: overlay not created'); return; }
        isOpen = true;
        clearImage();
        overlay.style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }

    function close() {
        if (abortCtrl) { abortCtrl.abort(); abortCtrl = null; }
        busy = false;
        isOpen = false;
        if (overlay) overlay.style.display = 'none';
        document.body.style.overflow = '';
    }

    // ── Public API ──
    window.toggleImageToLatex = function () {
        if (isOpen) close(); else open();
    };

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
