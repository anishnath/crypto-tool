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
                    throw new Error(data.error || 'Compilation failed');
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

        showToast('Preparing PDF...', 'info');

        Promise.all(uploadPromises)
            .then(function () {
                var uploadedFilenames = uploaded.map(function (u) { return u.filename; });
                var uploadedFileIds = uploaded.map(function (u) { return u.fileId; });
                var latexCtx = { baseName: baseName, imgCount: 0, uploadedFilenames: uploadedFilenames };
                var latex = exportLatex.docToLatex(json, docTitle, latexCtx);

                showToast('Compiling LaTeX...', 'info');
                return compileLatex(latex, uploadedFileIds, ctx);
            })
            .then(function (data) {
                if (!data.jobId) throw new Error('No job ID from compiler');
                showToast('Compiling PDF...', 'info');
                return pollUntilDone(data.jobId, ctx);
            })
            .then(function (jobId) {
                return downloadPdf(jobId, pdfFilename, ctx).then(function () {
                    showToast('PDF downloaded!', 'success');
                });
            })
            .catch(function (err) {
                var msg = err && err.message ? String(err.message) : '';
                if (msg.toLowerCase().indexOf('unauthenticated') >= 0 || msg.indexOf('401') >= 0) {
                    if (window.MeExportAuth && window.MeExportAuth.showExportLoginModal) {
                        window.MeExportAuth.showExportLoginModal({ exportType: 'PDF' });
                    } else {
                        showToast('Please login to export as PDF', 'error');
                    }
                } else if (err.rateLimited) {
                    showToast('Rate limited. Retry in ' + err.retryAfter + 's', 'error');
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
                        reject(new Error(data.message || 'Compilation error'));
                        return;
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
