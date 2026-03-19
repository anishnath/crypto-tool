/**
 * export-pdf.js — Export Math Editor to PDF via LaTeX compilation
 * Uses CompileServlet, UploadProxyServlet, PDFProxyServlet for pure mathematical PDF output
 */
(function () {
    'use strict';

    var POLL_INTERVAL_MS = 1500;
    var POLL_MAX_ATTEMPTS = 60; // ~90 seconds

    function getCtx() {
        return window.ME_CTX || '';
    }

    function showToast(msg, type) {
        if (window.ToolUtils && window.ToolUtils.showToast) {
            window.ToolUtils.showToast(msg, type === 'error' ? 4000 : 2500);
            return;
        }
        var el = document.createElement('div');
        el.className = 'me-toast me-toast-' + (type || 'info');
        el.textContent = msg;
        el.style.cssText = 'position:fixed;bottom:20px;left:50%;transform:translateX(-50%);padding:10px 20px;border-radius:8px;background:#1e293b;color:#fff;z-index:9999;font-size:14px;';
        document.body.appendChild(el);
        setTimeout(function () {
            if (el.parentNode) el.parentNode.removeChild(el);
        }, 3000);
    }

    /* ── Persistent progress overlay for long-running PDF export ── */
    var _progressOverlay = null;
    var _progressCancelled = false;

    function showProgressOverlay(msg) {
        _progressCancelled = false;
        if (!_progressOverlay) {
            var ov = document.createElement('div');
            ov.id = 'me-pdf-progress-overlay';
            ov.style.cssText = 'position:fixed;inset:0;background:rgba(0,0,0,0.45);z-index:10000;display:flex;align-items:center;justify-content:center;';
            ov.innerHTML =
                '<div style="background:#1e293b;color:#fff;border-radius:12px;padding:28px 32px;min-width:300px;max-width:420px;text-align:center;font-family:inherit;">' +
                '  <div id="me-pdf-progress-spinner" style="margin:0 auto 14px;width:32px;height:32px;border:3px solid rgba(255,255,255,0.2);border-top-color:#60a5fa;border-radius:50%;animation:me-spin 0.8s linear infinite;"></div>' +
                '  <div id="me-pdf-progress-msg" style="font-size:15px;margin-bottom:16px;">Preparing...</div>' +
                '  <button id="me-pdf-progress-cancel" style="background:transparent;border:1px solid rgba(255,255,255,0.3);color:#fff;padding:6px 18px;border-radius:6px;cursor:pointer;font-size:13px;">Cancel</button>' +
                '</div>';
            // spinner keyframes
            if (!document.getElementById('me-spin-style')) {
                var style = document.createElement('style');
                style.id = 'me-spin-style';
                style.textContent = '@keyframes me-spin{to{transform:rotate(360deg)}}';
                document.head.appendChild(style);
            }
            document.body.appendChild(ov);
            _progressOverlay = ov;
            ov.querySelector('#me-pdf-progress-cancel').addEventListener('click', function () {
                _progressCancelled = true;
                hideProgressOverlay();
            });
        }
        _progressOverlay.querySelector('#me-pdf-progress-msg').textContent = msg || 'Preparing...';
        _progressOverlay.style.display = 'flex';
    }

    function updateProgressOverlay(msg) {
        if (_progressOverlay) {
            _progressOverlay.querySelector('#me-pdf-progress-msg').textContent = msg;
        }
    }

    function hideProgressOverlay() {
        if (_progressOverlay) {
            _progressOverlay.style.display = 'none';
        }
    }

    function isProgressCancelled() {
        return _progressCancelled;
    }

    /* ── Error overlay with scrollable compilation log ── */
    function showCompilationError(summary, logText) {
        var ov = document.createElement('div');
        ov.style.cssText = 'position:fixed;inset:0;background:rgba(0,0,0,0.5);z-index:10001;display:flex;align-items:center;justify-content:center;';
        var hasLog = logText && logText.trim().length > 0;
        ov.innerHTML =
            '<div style="background:#1e293b;color:#fff;border-radius:12px;padding:24px 28px;max-width:560px;width:90%;font-family:inherit;">' +
            '  <h3 style="margin:0 0 10px;font-size:16px;color:#f87171;">PDF Export Failed</h3>' +
            '  <p style="margin:0 0 12px;font-size:14px;color:#cbd5e1;">' + escapeHtml(summary) + '</p>' +
            (hasLog
                ? '  <details style="margin-bottom:14px;">' +
                  '    <summary style="cursor:pointer;font-size:13px;color:#93c5fd;">Show compilation log</summary>' +
                  '    <pre style="max-height:220px;overflow:auto;background:#0f172a;padding:10px;border-radius:6px;font-size:12px;margin-top:8px;white-space:pre-wrap;word-break:break-word;color:#e2e8f0;">' + escapeHtml(logText) + '</pre>' +
                  '  </details>'
                : '') +
            '  <button id="me-comp-err-close" style="background:#3b82f6;border:none;color:#fff;padding:7px 20px;border-radius:6px;cursor:pointer;font-size:13px;">Close</button>' +
            '</div>';
        document.body.appendChild(ov);
        ov.querySelector('#me-comp-err-close').addEventListener('click', function () {
            if (ov.parentNode) ov.parentNode.removeChild(ov);
        });
        ov.addEventListener('click', function (e) {
            if (e.target === ov && ov.parentNode) ov.parentNode.removeChild(ov);
        });
    }

    function escapeHtml(str) {
        if (!str) return '';
        return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    }

    function dataUrlToBlob(dataUrl) {
        var arr = dataUrl.split(',');
        var mime = (arr[0].match(/:(.*?);/) || [])[1] || 'image/png';
        var bstr = atob(arr[1] || '');
        var n = bstr.length;
        var u8 = new Uint8Array(n);
        for (var i = 0; i < n; i++) u8[i] = bstr.charCodeAt(i);
        return new Blob([u8], { type: mime });
    }

    function uploadImage(dataUrl, filename, ctx) {
        var blob = dataUrlToBlob(dataUrl);
        var formData = new FormData();
        formData.append('file', blob, filename);

        return fetch(ctx + '/upload', {
            method: 'POST',
            credentials: 'include',
            body: formData
        }).then(function (res) {
            if (!res.ok) {
                return res.json().then(function (data) {
                    throw new Error(data.error || 'Upload failed');
                });
            }
            return res.json();
        });
    }

    function compileLatex(source, fileIds, ctx) {
        var payload = { source: source };
        if (fileIds && fileIds.length > 0) {
            payload.fileIds = fileIds;
        }
        return fetch(ctx + '/compile', {
            method: 'POST',
            credentials: 'include',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        }).then(function (res) {
            if (res.status === 429) {
                return res.json().then(function (data) {
                    throw { rateLimited: true, retryAfter: data.retryAfter || 10 };
                });
            }
            if (!res.ok) {
                return res.json().then(function (data) {
                    var err = new Error(data.error || 'Compilation failed');
                    if (data.log || data.compilationLog || data.output) {
                        err.compilationLog = data.log || data.compilationLog || data.output;
                    }
                    throw err;
                });
            }
            return res.json();
        });
    }

    function pollJobStatus(jobId, ctx) {
        return fetch(ctx + '/jobs/' + jobId + '/status', { credentials: 'include' })
            .then(function (res) { return res.json(); });
    }

    function downloadPdf(jobId, filename, ctx) {
        var url = ctx + '/pdf/' + jobId;
        return fetch(url, { credentials: 'include' }).then(function (res) {
            if (!res.ok) throw new Error('Failed to fetch PDF');
            return res.blob();
        }).then(function (blob) {
            var objectUrl = URL.createObjectURL(blob);
            var a = document.createElement('a');
            a.href = objectUrl;
            a.download = filename || 'document.pdf';
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            URL.revokeObjectURL(objectUrl);
        });
    }

    function exportToPdf() {
        var editor = window.MeEditor;
        var exportLatex = window.MeExportLatex;
        if (!editor || !exportLatex || !exportLatex.docToLatex) {
            showToast('Export not ready', 'error');
            return;
        }

        var ctx = getCtx();
        var titleInput = document.querySelector('.me-doc-title-input');
        var docTitle = titleInput ? titleInput.value.trim() : 'document';
        var baseName = docTitle.replace(/[^a-z0-9]/gi, '_') || 'document';
        var pdfFilename = baseName + '.pdf';

        var json = editor.getJSON();
        var collectCtx = { baseName: baseName, imgCount: 0, imageFiles: [] };
        exportLatex.docToLatex(json, docTitle, collectCtx);

        var imageFiles = collectCtx.imageFiles || [];
        var uploaded = new Array(imageFiles.length);  /* preserve document order — do not use push() */
        var uploadPromises = imageFiles.map(function (item, i) {
            var filename = (baseName.replace(/_/g, '-') + '-' + (i + 1) + '.png');
            return uploadImage(item.dataUrl, filename, ctx).then(function (data) {
                uploaded[i] = { fileId: data.fileId, filename: data.filename || filename };
            });
        });

        showProgressOverlay('Uploading images...');

        Promise.all(uploadPromises)
            .then(function () {
                if (isProgressCancelled()) throw { cancelled: true };
                var uploadedFilenames = uploaded.map(function (u) { return u.filename; });
                var uploadedFileIds = uploaded.map(function (u) { return u.fileId; });
                var latexCtx = { baseName: baseName, imgCount: 0, uploadedFilenames: uploadedFilenames };
                var latex = exportLatex.docToLatex(json, docTitle, latexCtx);

                updateProgressOverlay('Compiling LaTeX...');
                return compileLatex(latex, uploadedFileIds, ctx);
            })
            .then(function (data) {
                if (isProgressCancelled()) throw { cancelled: true };
                if (!data.jobId) throw new Error('No job ID from compiler');
                updateProgressOverlay('Generating PDF — this may take a minute...');
                return pollUntilDone(data.jobId, ctx);
            })
            .then(function (jobId) {
                if (isProgressCancelled()) throw { cancelled: true };
                updateProgressOverlay('Downloading PDF...');
                return downloadPdf(jobId, pdfFilename, ctx).then(function () {
                    hideProgressOverlay();
                    showToast('PDF downloaded!', 'success');
                });
            })
            .catch(function (err) {
                hideProgressOverlay();
                if (err && err.cancelled) return; // user cancelled

                var msg = err && err.message ? String(err.message) : '';
                if (msg.toLowerCase().indexOf('unauthenticated') >= 0 || msg.indexOf('401') >= 0) {
                    if (window.MeExportAuth && window.MeExportAuth.showExportLoginModal) {
                        window.MeExportAuth.showExportLoginModal({ exportType: 'PDF' });
                    } else {
                        showToast('Please login to export as PDF', 'error');
                    }
                } else if (err.rateLimited) {
                    showToast('Rate limited. Retry in ' + err.retryAfter + 's', 'error');
                } else if (err.compilationLog) {
                    // LaTeX compilation error with log details
                    showCompilationError(msg || 'LaTeX compilation failed', err.compilationLog);
                } else {
                    showToast(msg || 'Export failed', 'error');
                }
                console.error('Export PDF error:', err);
            });
    }

    function pollUntilDone(jobId, ctx) {
        var attempts = 0;
        return new Promise(function (resolve, reject) {
            function poll() {
                if (isProgressCancelled()) {
                    reject({ cancelled: true });
                    return;
                }
                attempts++;
                if (attempts > POLL_MAX_ATTEMPTS) {
                    reject(new Error('Compilation timed out'));
                    return;
                }
                pollJobStatus(jobId, ctx).then(function (data) {
                    if (data.status === 'done') {
                        resolve(jobId);
                        return;
                    }
                    if (data.status === 'error') {
                        var errObj = new Error(data.message || 'Compilation error');
                        // Surface compilation log if available
                        if (data.log || data.compilationLog || data.output) {
                            errObj.compilationLog = data.log || data.compilationLog || data.output;
                        }
                        reject(errObj);
                        return;
                    }
                    // Update progress with phase info from server if available
                    if (data.phase) {
                        updateProgressOverlay(data.phase + '...');
                    }
                    setTimeout(poll, POLL_INTERVAL_MS);
                }).catch(reject);
            }
            poll();
        });
    }

    function wireExportButton() {
        var btn = document.querySelector('.me-export-menu-item[data-export="pdf"]');
        if (!btn) return;
        btn.addEventListener('click', function (e) {
            e.preventDefault();
            e.stopPropagation();
            var menu = document.querySelector('.me-export-menu');
            if (menu) menu.classList.remove('show');
            if (window.MeExportAuth && window.MeExportAuth.requireAuthForExport) {
                window.MeExportAuth.requireAuthForExport('pdf', exportToPdf);
            } else {
                exportToPdf();
            }
        });
    }

    document.addEventListener('me:editor-ready', wireExportButton);

    window.MeExportPdf = {
        exportToPdf: exportToPdf
    };

})();
