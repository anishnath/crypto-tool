(function() {
'use strict';

var debounceTimer = null;
var eventSource = null;
var pollTimer = null;
var DEBOUNCE_MS = 60000; // 60s — auto-recompile only after long idle; use button or Ctrl+Enter for instant
var POLL_INTERVAL_MS = 1500;

window.currentJobId = null;

// ── Uploaded files registry ──
// Each entry: { fileId: "uuid", filename: "photo.png" }
var uploadedFiles = [];

// ── File content cache (for .tex files created via Move to File) ──
// { "section-1.tex": "\\section{Intro}\n..." }
var fileContents = {};

// Collected errors with line numbers for navigation
var collectedErrors = [];

// Toast notification system
var toastContainer = null;

function ensureToastContainer() {
  if (!toastContainer) {
    toastContainer = document.createElement('div');
    toastContainer.className = 'toast-container';
    document.body.appendChild(toastContainer);
  }
  return toastContainer;
}

// Compiler warnings/errors can be thousands of lines — a toast must stay short.
// Keep the first few meaningful lines; the full text still lands in the log panel.
var TOAST_MAX_LINES = 3;
var TOAST_MAX_CHARS = 240;
function trimToastMessage(message) {
  var msg = String(message == null ? '' : message);
  var lines = msg.split(/\r?\n/);
  var kept = [];
  for (var i = 0; i < lines.length && kept.length < TOAST_MAX_LINES; i++) {
    var t = lines[i].trim();
    if (t) kept.push(t);
  }
  var out = kept.join('\n');
  var omittedLines = lines.length - kept.length;
  var truncated = omittedLines > 0;
  if (out.length > TOAST_MAX_CHARS) {
    out = out.slice(0, TOAST_MAX_CHARS).replace(/\s+\S*$/, '') + '…';
    truncated = true;
  }
  if (truncated) {
    out += '\n…(truncated — see the log panel for full output)';
  }
  return out;
}

function showToast(message, type) {
  var container = ensureToastContainer();
  var toast = document.createElement('div');
  toast.className = 'toast ' + (type || 'info');
  toast.style.whiteSpace = 'pre-line';
  toast.textContent = trimToastMessage(message);
  container.appendChild(toast);
  setTimeout(function() {
    if (toast.parentNode) toast.parentNode.removeChild(toast);
  }, 5000);
}

function showErrorToast(message) { showToast(message, 'error'); }
function showSuccessToast(message) { showToast(message, 'success'); }
function showWarningToast(message) { showToast(message, 'warning'); }

// Compile status display
function setCompileStatus(text, type) {
  var el = document.getElementById('compile-status');
  if (!el) return;
  el.textContent = text;
  el.className = 'compile-status ' + (type || '');
}

// Log panel
function clearLogPanel() {
  var el = document.getElementById('log-output');
  if (el) el.innerHTML = '';
  var badge = document.getElementById('log-error-badge');
  if (badge) badge.style.display = 'none';
  collectedErrors = [];
  updateErrorNav();
}

function appendLogLine(text, type, lineNum) {
  var el = document.getElementById('log-output');
  if (!el) return;

  var line = document.createElement('div');
  line.className = 'log-line ' + (type || 'info');

  if (lineNum && (type === 'error' || type === 'warn')) {
    line.classList.add('clickable');
    line.setAttribute('data-line', lineNum);
    line.title = 'Click to jump to line ' + lineNum;
    line.onclick = function() { jumpToLine(lineNum); };
  }

  var prefix = document.createElement('span');
  prefix.className = 'log-prefix';
  if (type === 'error') prefix.textContent = '\u2715';
  else if (type === 'warn') prefix.textContent = '\u26A0';
  else if (type === 'success') prefix.textContent = '\u2713';
  else prefix.textContent = '\u203A';

  var span = document.createElement('span');
  span.className = 'log-text';

  if (lineNum) {
    var lineRef = document.createElement('span');
    lineRef.className = 'log-line-ref';
    lineRef.textContent = 'L' + lineNum;
    span.appendChild(lineRef);
    span.appendChild(document.createTextNode(' ' + text));
  } else {
    span.textContent = text;
  }

  line.appendChild(prefix);
  line.appendChild(span);
  el.appendChild(line);
  el.scrollTop = el.scrollHeight;
}

function jumpToLine(lineNum) {
  if (typeof window.jumpToEditorLine === 'function') {
    window.jumpToEditorLine(lineNum);
  }
}

function toggleLogPanel() {
  var panel = document.getElementById('log-panel');
  var icon = document.getElementById('log-toggle-icon');
  if (panel) {
    panel.classList.toggle('collapsed');
    if (icon) {
      icon.textContent = panel.classList.contains('collapsed') ? '\u25BC expand' : '\u25B2 collapse';
    }
  }
}

// ── pdfLaTeX output parser ──
var pendingErrorMsg = null;

function parseLogLine(rawText) {
  var lineType = 'info';
  var lineNum = null;

  if (rawText.indexOf('!') === 0 || rawText.indexOf('Error') !== -1) {
    lineType = 'error';
    var inputLineMatch = rawText.match(/on input line (\d+)/);
    if (inputLineMatch) lineNum = parseInt(inputLineMatch[1], 10);
    var fileLineMatch = rawText.match(/\.tex:(\d+):/);
    if (fileLineMatch) lineNum = parseInt(fileLineMatch[1], 10);
    if (!lineNum) pendingErrorMsg = rawText;
  }

  var lMatch = rawText.match(/^l\.(\d+)\s/);
  if (lMatch) {
    lineNum = parseInt(lMatch[1], 10);
    lineType = 'error';
    if (pendingErrorMsg) {
      var combinedMsg = pendingErrorMsg;
      pendingErrorMsg = null;
      collectedErrors.push({ line: lineNum, message: combinedMsg, detail: rawText });
      updateErrorNav();
      if (typeof window.markErrorLine === 'function') window.markErrorLine(lineNum, combinedMsg);
      if (typeof window.addErrorWidget === 'function') window.addErrorWidget(lineNum, combinedMsg);
      return { type: lineType, lineNum: lineNum, text: rawText };
    }
    collectedErrors.push({ line: lineNum, message: rawText, detail: rawText });
    updateErrorNav();
    if (typeof window.markErrorLine === 'function') window.markErrorLine(lineNum, rawText);
    if (typeof window.addErrorWidget === 'function') window.addErrorWidget(lineNum, rawText);
  }

  if (rawText.indexOf('Warning') !== -1 || rawText.indexOf('Overfull') !== -1 || rawText.indexOf('Underfull') !== -1) {
    lineType = 'warn';
    var warnLineMatch = rawText.match(/on input line (\d+)/);
    if (warnLineMatch) lineNum = parseInt(warnLineMatch[1], 10);
  }

  return { type: lineType, lineNum: lineNum, text: rawText };
}

function updateErrorNav() {
  var countEl = document.getElementById('error-count');
  var navEl = document.getElementById('error-nav');
  if (countEl) {
    countEl.textContent = collectedErrors.length + ' error' + (collectedErrors.length !== 1 ? 's' : '');
    countEl.style.display = collectedErrors.length > 0 ? '' : 'none';
  }
  if (navEl) {
    navEl.style.display = collectedErrors.length > 0 ? '' : 'none';
  }
  var sbErrors = document.getElementById('sb-errors');
  if (sbErrors) {
    if (collectedErrors.length > 0) {
      sbErrors.textContent = '\u2715 ' + collectedErrors.length + ' error' + (collectedErrors.length !== 1 ? 's' : '');
      sbErrors.style.display = '';
      sbErrors.className = 'sb-item sb-errors';
    } else {
      sbErrors.style.display = 'none';
    }
  }
}

var currentErrorIndex = -1;
function nextError() {
  if (collectedErrors.length === 0) return;
  currentErrorIndex = (currentErrorIndex + 1) % collectedErrors.length;
  jumpToLine(collectedErrors[currentErrorIndex].line);
}
function prevError() {
  if (collectedErrors.length === 0) return;
  currentErrorIndex = (currentErrorIndex - 1 + collectedErrors.length) % collectedErrors.length;
  jumpToLine(collectedErrors[currentErrorIndex].line);
}

var hasCompiledOnce = false;
var isDirty = false;

// Called on editor change — marks dirty + schedules auto-recompile after 60s idle
function onEditorChange() {
  clearTimeout(debounceTimer);

  if (hasCompiledOnce && !isDirty) {
    isDirty = true;
    updateCompileButton();
  }

  if (editingFile) refreshEditingIndicator();

  debounceTimer = setTimeout(triggerCompile, DEBOUNCE_MS);
}

function updateCompileButton() {
  var compileBtn = document.getElementById('btn-compile');
  var btnLabel = document.getElementById('btn-compile-label');
  if (!compileBtn) return;

  if (hasCompiledOnce) {
    if (btnLabel) btnLabel.textContent = isDirty ? 'Recompile' : 'Compiled';
    if (isDirty) {
      compileBtn.classList.add('dirty');
    } else {
      compileBtn.classList.remove('dirty');
    }
  }
}

function stopMonitoring() {
  if (eventSource) { eventSource.close(); eventSource = null; }
  clearTimeout(pollTimer); pollTimer = null;
}

// ── Compile root: main.tex by default; standalone sub-files compile as themselves ──

function isStandaloneLaTeXDocument(source) {
  if (!source || !source.trim()) return false;
  return /\\documentclass(\s|\[|\{)/i.test(source) &&
         /\\begin\s*\{document\}/i.test(source);
}

function syncEditorToFileContents() {
  var cm = window.editorInstance;
  if (!cm || !editingFile) return;
  fileContents[editingFile] = cm.getValue();
}

function getMainTexSource() {
  if (editingFile && mainTexContent != null) return mainTexContent;
  return window.getEditorContent ? window.getEditorContent() : '';
}

/** Which source + label to send to the compiler for the next build. */
function resolveCompileRoot() {
  syncEditorToFileContents();

  var rootFile = 'main.tex';
  var source = getMainTexSource();
  var compilesActiveStandalone = false;

  if (editingFile && editingFile !== 'main.tex') {
    var active = fileContents[editingFile];
    if (active != null && isStandaloneLaTeXDocument(active)) {
      source = active;
      rootFile = editingFile;
      compilesActiveStandalone = true;
    }
  }

  return {
    source: source,
    rootFile: rootFile,
    compilesActiveStandalone: compilesActiveStandalone
  };
}

// ── Main compile ──
function triggerCompile(opts) {
  opts = opts || {};
  clearTimeout(debounceTimer);
  stopMonitoring();
  // Reset retry counter on a fresh user-initiated compile only — the
  // recovery path passes { preserveRetries: true } so its in-flight count
  // survives the retry call.
  if (!opts.preserveRetries) resetMissingRetries();

  syncEditorToFileContents();
  doCompile();
}

function doCompile() {
  var resolved = resolveCompileRoot();
  var source = resolved.source;
  if (!source || !source.trim()) {
    showErrorToast('No LaTeX source to compile');
    return;
  }

  pendingErrorMsg = null;
  currentErrorIndex = -1;
  collectedErrors = [];
  updateErrorNav();

  hasCompiledOnce = true;
  isDirty = false;

  if (resolved.rootFile === 'main.tex') {
    setCompileStatus('Compiling main.tex...', 'compiling');
    if (editingFile && !resolved.compilesActiveStandalone && /\.tex$/i.test(editingFile)) {
      appendLogLine(
        editingFile + ' is not a full document — compiling main.tex (use \\input in main to include it)',
        'info'
      );
    }
  } else {
    setCompileStatus('Compiling ' + resolved.rootFile + '...', 'compiling');
  }

  showPDFLoading(true);
  clearErrorMarkers();
  if (typeof window.clearErrorWidgets === 'function') window.clearErrorWidgets();
  clearLogPanel();

  appendLogLine('Root document: ' + resolved.rootFile, 'info');

  var compileBtn = document.getElementById('btn-compile');
  if (compileBtn) compileBtn.classList.add('compiling');
  updateCompileButton();

  // Re-upload all sub-files from local content to get fresh fileIds.
  var filesToUpload = [];
  for (var fname in fileContents) {
    if (fileContents.hasOwnProperty(fname)) {
      filesToUpload.push(fname);
    }
  }

  if (filesToUpload.length > 0) {
    for (var wi = uploadedFiles.length - 1; wi >= 0; wi--) {
      if (fileContents[uploadedFiles[wi].filename]) {
        uploadedFiles.splice(wi, 1);
      }
    }

    appendLogLine('Syncing ' + filesToUpload.length + ' sub-file(s)...', 'info');
    var pending = filesToUpload.length;
    filesToUpload.forEach(function(f) {
      reuploadFile(f, fileContents[f], function() {
        pending--;
        if (pending <= 0) sendCompile(source, resolved.rootFile);
      });
    });
  } else {
    sendCompile(source, resolved.rootFile);
  }
}

function sendCompile(source, rootFile) {
  rootFile = rootFile || 'main.tex';
  appendLogLine('Sending source to compiler...', 'info');
  if (uploadedFiles.length > 0) {
    appendLogLine('Attaching ' + uploadedFiles.length + ' uploaded file(s)', 'info');
  }

  // Build compile payload — JSON with source + fileIds
  var payload = { source: source };
  if (uploadedFiles.length > 0) {
    payload.fileIds = uploadedFiles.map(function(f) { return f.fileId; });
  }

  fetch(CONFIG.compileUrl, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload)
  })
  .then(function(res) {
    // Handle rate limiting
    if (res.status === 429) {
      return res.json().then(function(data) {
        var wait = data.retryAfter || 10;
        throw { rateLimited: true, message: data.error || 'Rate limited', retryAfter: wait };
      });
    }
    if (!res.ok) {
      return res.json().then(function(data) {
        throw new Error(data.error || 'Compile request failed (' + res.status + ')');
      });
    }
    return res.json();
  })
  .then(function(data) {
    if (!data.jobId) throw new Error('No job ID returned');
    window.currentJobId = data.jobId;
    appendLogLine('Job started: ' + data.jobId, 'info');
    startLogStream(data.jobId);
  })
  .catch(function(err) {
    setCompileStatus('Error', 'error');
    showPDFLoading(false);
    if (compileBtn) compileBtn.classList.remove('compiling');

    if (err.rateLimited) {
      showWarningToast('Too many compiles. Retry in ' + err.retryAfter + 's');
      appendLogLine('Rate limited — wait ' + err.retryAfter + ' seconds before retrying', 'warn');
      // Auto-retry after the wait period
      setTimeout(function() {
        setCompileStatus('Ready', '');
        appendLogLine('Rate limit cleared, you can compile again', 'info');
      }, err.retryAfter * 1000);
    } else {
      showErrorToast(err.message);
      appendLogLine(err.message, 'error');
    }
  });
}

// ── SSE log streaming with fallback to polling ──
function startLogStream(jobId) {
  eventSource = new EventSource(CONFIG.logsUrl + '/' + jobId);

  eventSource.onmessage = function(e) {
    try {
      var msg = JSON.parse(e.data);
      if (msg.line) {
        var parsed = parseLogLine(msg.line);
        appendLogLine(parsed.text, parsed.type, parsed.lineNum);
      }
      if (msg.status === 'done') {
        stopMonitoring();
        onCompileDone(jobId, msg.warning || null);
      }
      if (msg.status === 'error') {
        stopMonitoring();
        onCompileError({ message: msg.message, line: msg.line_number });
      }
    } catch (ex) {
      var parsed = parseLogLine(e.data);
      appendLogLine(parsed.text, parsed.type, parsed.lineNum);
    }
  };

  eventSource.onerror = function() {
    if (eventSource) { eventSource.close(); eventSource = null; }
    appendLogLine('Log stream ended, checking status...', 'info');
    startStatusPolling(jobId);
  };
}

function startStatusPolling(jobId) {
  clearTimeout(pollTimer);
  function poll() {
    fetch(CONFIG.jobsUrl + '/' + jobId + '/status')
      .then(function(res) { return res.json(); })
      .then(function(data) {
        if (data.status === 'done') {
          clearTimeout(pollTimer);
          onCompileDone(jobId, data.warning || null);
        } else if (data.status === 'error') {
          clearTimeout(pollTimer);
          onCompileError({ message: data.message });
        } else if (data.status === 'pending') {
          setCompileStatus('Queued...', 'compiling');
          appendLogLine('Job queued, waiting for compiler...', 'info');
          pollTimer = setTimeout(poll, POLL_INTERVAL_MS);
        } else if (data.status === 'compiling') {
          setCompileStatus('Compiling...', 'compiling');
          pollTimer = setTimeout(poll, POLL_INTERVAL_MS);
        } else {
          pollTimer = setTimeout(poll, POLL_INTERVAL_MS);
        }
      })
      .catch(function(err) {
        appendLogLine('Status check failed: ' + err.message, 'warn');
        pollTimer = setTimeout(poll, POLL_INTERVAL_MS * 2);
      });
  }
  poll();
}

function onCompileDone(jobId, warning) {
  var compileBtn = document.getElementById('btn-compile');
  if (compileBtn) compileBtn.classList.remove('compiling');
  showPDFLoading(false);

  if (warning) {
    setCompileStatus('\u2713 Compiled (with warnings)', 'done');
    appendLogLine('Warning: ' + warning, 'warn');
    showWarningToast(warning);
  } else {
    setCompileStatus('\u2713 Compiled', 'done');
  }
  appendLogLine('Compilation successful', 'success');

  loadPDF(CONFIG.pdfUrl + '/' + jobId);

  // On mobile, auto-switch to preview after successful compilation
  if (typeof window.isMobile === 'function' && window.isMobile()) {
    if (typeof window.showMobilePreview === 'function') window.showMobilePreview();
  }

  var dlBtn = document.getElementById('btn-download-pdf');
  if (dlBtn) dlBtn.disabled = false;

  var badge = document.getElementById('log-error-badge');
  if (badge) {
    if (collectedErrors.length > 0) {
      badge.className = 'log-badge errors';
      badge.textContent = collectedErrors.length + ' error' + (collectedErrors.length !== 1 ? 's' : '');
    } else if (warning) {
      badge.className = 'log-badge errors';
      badge.textContent = 'Warning';
    } else {
      badge.className = 'log-badge ok';
      badge.textContent = '\u2713 Success';
    }
    badge.style.display = '';
  }
}

function onCompileError(data) {
  var compileBtn = document.getElementById('btn-compile');
  if (compileBtn) compileBtn.classList.remove('compiling');

  var msg = data.message || data.error || 'Compilation failed';

  // Self-heal path: if the failure is a stale upload (server TTL expired
  // the file), re-upload from local cache and retry once. tryRecover\u2026
  // returns true when it has started recovery; we then skip the visible
  // error so the user only sees the eventual success or a real failure.
  if (tryRecoverMissingUpload(msg)) {
    setCompileStatus('Recovering\u2026', 'compiling');
    return;
  }

  setCompileStatus('\u2715 Error', 'error');
  showPDFLoading(false);

  appendLogLine(msg, 'error');
  showErrorToast(msg);

  if (data.line) {
    if (typeof window.markErrorLine === 'function') window.markErrorLine(data.line, msg);
    if (typeof window.addErrorWidget === 'function') window.addErrorWidget(data.line, msg);
    collectedErrors.push({ line: data.line, message: msg });
    updateErrorNav();
  }

  var badge = document.getElementById('log-error-badge');
  if (badge) {
    badge.className = 'log-badge errors';
    badge.textContent = collectedErrors.length > 0
      ? collectedErrors.length + ' error' + (collectedErrors.length !== 1 ? 's' : '')
      : 'Error';
    badge.style.display = '';
  }

  if (collectedErrors.length > 0) {
    currentErrorIndex = 0;
    jumpToLine(collectedErrors[0].line);
    var panel = document.getElementById('log-panel');
    if (panel && panel.classList.contains('collapsed')) toggleLogPanel();
  }
}

// ── File upload with validation and figure insertion ──
var ALLOWED_EXTENSIONS = /\.(png|jpg|jpeg|gif|svg|eps|pdf|tex|bib|bst|cls|sty|csv|dat|txt)$/i;
var IMAGE_EXTENSIONS = /\.(png|jpg|jpeg|gif|svg|eps|pdf)$/i;
// Text-like extensions the user can edit in the CodeMirror pane
var EDITABLE_TEXT_EXTENSIONS = /\.(tex|csv|tsv|dat|txt|bib|bst|cls|sty|md|json|yaml|yml|toml|pgf|tikz|sql|log|cfg|ini)$/i;
var MAX_FILE_SIZE = 5 * 1024 * 1024; // 5 MB

function uploadFile(input) {
  if (!input.files || !input.files[0]) return;

  var file = input.files[0];

  // ── Client-side validation ──
  if (!ALLOWED_EXTENSIONS.test(file.name)) {
    showErrorToast('File type not allowed. Use: png, jpg, svg, eps, pdf, tex, bib, cls, sty, csv, txt');
    input.value = '';
    return;
  }

  if (file.size > MAX_FILE_SIZE) {
    showErrorToast('File too large. Maximum size is 5 MB.');
    input.value = '';
    return;
  }

  if (file.size === 0) {
    showErrorToast('File is empty.');
    input.value = '';
    return;
  }

  var formData = new FormData();
  formData.append('file', file);

  var isImage = IMAGE_EXTENSIONS.test(file.name);

  appendLogLine('Uploading ' + file.name + ' (' + formatFileSize(file.size) + ')...', 'info');

  fetch(CONFIG.uploadUrl, {
    method: 'POST',
    body: formData
  })
  .then(function(res) {
    if (!res.ok) {
      return res.json().then(function(data) {
        throw new Error(data.error || 'Upload failed');
      });
    }
    return res.json();
  })
  .then(function(data) {
    if (data.jobId && !data.fileId) {
      throw new Error('Upload returned a compile jobId — check api= in 8gwifi.prop (expected fileId)');
    }
    var fname = data.filename || file.name;
    var fid = data.fileId;
    if (!fid) {
      throw new Error('Upload succeeded but no fileId was returned');
    }

    appendLogLine('Uploaded: ' + fname + ' (id: ' + fid.substring(0, 8) + '...)', 'success');
    showSuccessToast('File uploaded: ' + fname);

    // Track for compile
    if (fid) {
      uploadedFiles.push({ fileId: fid, filename: fname });
    }

    // Add to file tree; keep local text for .bib / .cls / .sty so users can edit in-editor
    if (!isImage && EDITABLE_TEXT_EXTENSIONS.test(fname)) {
      file.text().then(function (text) {
        fileContents[fname] = text;
        addFileToTree(fname, false, text);
      }).catch(function () {
        addFileToTree(fname, isImage);
      });
    } else {
      addFileToTree(fname, isImage);
    }

    // Auto-insert \includegraphics for image files
    if (isImage) {
      promptInsertFigure(fname);
    }
  })
  .catch(function(err) {
    appendLogLine('Upload failed: ' + err.message, 'error');
    showErrorToast('Upload failed: ' + err.message);
  });

  input.value = '';
}

// Show a non-blocking prompt to insert the uploaded image
function promptInsertFigure(filename) {
  var container = ensureToastContainer();
  var toast = document.createElement('div');
  toast.className = 'toast success';
  toast.style.cursor = 'default';

  var msg = document.createElement('div');
  msg.style.marginBottom = '8px';
  msg.textContent = 'Insert "' + filename + '" into document?';

  var btnRow = document.createElement('div');
  btnRow.style.display = 'flex';
  btnRow.style.gap = '6px';

  var btnFigure = document.createElement('button');
  btnFigure.className = 'upload-insert-btn';
  btnFigure.textContent = 'As Figure';
  btnFigure.onclick = function() {
    insertUploadedFigure(filename, true);
    if (toast.parentNode) toast.parentNode.removeChild(toast);
  };

  var btnInline = document.createElement('button');
  btnInline.className = 'upload-insert-btn';
  btnInline.textContent = 'Inline';
  btnInline.onclick = function() {
    insertUploadedFigure(filename, false);
    if (toast.parentNode) toast.parentNode.removeChild(toast);
  };

  var btnSkip = document.createElement('button');
  btnSkip.className = 'upload-insert-btn secondary';
  btnSkip.textContent = 'Skip';
  btnSkip.onclick = function() {
    if (toast.parentNode) toast.parentNode.removeChild(toast);
  };

  btnRow.appendChild(btnFigure);
  btnRow.appendChild(btnInline);
  btnRow.appendChild(btnSkip);
  toast.appendChild(msg);
  toast.appendChild(btnRow);
  container.appendChild(toast);

  // Auto-dismiss after 15s
  setTimeout(function() {
    if (toast.parentNode) toast.parentNode.removeChild(toast);
  }, 15000);
}

function insertUploadedFigure(filename, asFigure) {
  if (typeof window.insertCommand !== 'function') return;

  if (asFigure) {
    var label = filename.replace(/\.[^.]+$/, '').replace(/[^a-zA-Z0-9]/g, '-');
    var tmpl = '\\begin{figure}[htbp]\n' +
               '\\centering\n' +
               '\\includegraphics[width=0.8\\textwidth]{' + filename + '}\n' +
               '\\caption{' + filename + '}\n' +
               '\\label{fig:' + label + '}\n' +
               '\\end{figure}\n';
    window.insertCommand(tmpl);
  } else {
    window.insertCommand('\\includegraphics[width=0.5\\textwidth]{' + filename + '}');
  }
}

function addFileToTree(filename, isImage, content) {
  var fileList = document.getElementById('file-list');
  if (!fileList) return;

  // Store content if provided
  if (content != null) fileContents[filename] = content;

  // Don't add duplicate
  if (fileList.querySelector('[data-file="' + filename + '"]')) return;

  var icon = '\uD83D\uDCC4';
  if (isImage) icon = '\uD83D\uDDBC';

  var item = document.createElement('div');
  item.className = 'file-item';
  item.setAttribute('data-file', filename);

  var iconSpan = document.createElement('span');
  iconSpan.className = 'file-icon';
  iconSpan.textContent = icon;

  var nameSpan = document.createElement('span');
  nameSpan.className = 'file-name';
  nameSpan.textContent = ' ' + filename;

  item.appendChild(iconSpan);
  item.appendChild(nameSpan);

  // For images, add an insert button
  if (isImage) {
    var insertBtn = document.createElement('span');
    insertBtn.className = 'file-insert-btn';
    insertBtn.title = 'Insert \\includegraphics';
    insertBtn.textContent = '+';
    insertBtn.onclick = function(e) {
      e.stopPropagation();
      insertUploadedFigure(filename, true);
    };
    item.appendChild(insertBtn);
  }

  // Actions button (three-dot menu) — except main.tex shows limited options
  var actionsBtn = document.createElement('span');
  actionsBtn.className = 'file-actions-btn';
  actionsBtn.title = 'File actions';
  actionsBtn.textContent = '\u22EE'; // vertical ellipsis ⋮
  actionsBtn.onclick = function(e) {

    e.stopPropagation();
    showFileContextMenu(e, filename, isImage, item);
  };
  item.appendChild(actionsBtn);

  // Also support right-click
  item.addEventListener('contextmenu', function(e) {

    e.preventDefault();
    e.stopPropagation();
    showFileContextMenu(e, filename, isImage, item);
  });

  item.onclick = function() { selectFile(item); };
  fileList.appendChild(item);
}

// ── File context menu: Download / Rename / Delete ──

var fileCtxMenu = null;

function createFileCtxMenu() {
  if (fileCtxMenu) return;
  fileCtxMenu = document.createElement('div');
  fileCtxMenu.className = 'file-ctx-menu';
  fileCtxMenu.innerHTML =
    '<div class="file-ctx-item" data-ctx="download">Download</div>' +
    '<div class="file-ctx-item" data-ctx="rename">Rename</div>' +
    '<div class="file-ctx-divider"></div>' +
    '<div class="file-ctx-item file-ctx-danger" data-ctx="delete">Delete</div>';
  document.body.appendChild(fileCtxMenu);

  fileCtxMenu.addEventListener('click', function(e) {
    var item = e.target.closest('[data-ctx]');
    if (!item) return;
    var action = item.getAttribute('data-ctx');
    var fname = fileCtxMenu._filename;
    var el = fileCtxMenu._element;
    hideFileCtxMenu();
    if (action === 'download') downloadFile(fname);
    else if (action === 'rename') renameFile(fname, el);
    else if (action === 'delete') deleteFile(fname, el);
  });

  document.addEventListener('click', hideFileCtxMenu);
  document.addEventListener('contextmenu', function(e) {
    if (fileCtxMenu && !fileCtxMenu.contains(e.target)) hideFileCtxMenu();
  });
}

function showFileContextMenu(e, filename, isImage, el) {

  createFileCtxMenu();


  var isMain = filename === 'main.tex';
  fileCtxMenu._filename = filename;
  fileCtxMenu._element = el;

  // Disable rename/delete for main.tex
  var items = fileCtxMenu.querySelectorAll('[data-ctx]');
  items.forEach(function(item) {
    var action = item.getAttribute('data-ctx');
    if (action === 'rename' || action === 'delete') {
      item.classList.toggle('file-ctx-disabled', isMain);
    }
  });

  fileCtxMenu.style.left = '-9999px';
  fileCtxMenu.style.top = '-9999px';
  fileCtxMenu.classList.add('visible');

  // Clamp to viewport
  var mw = fileCtxMenu.offsetWidth;
  var mh = fileCtxMenu.offsetHeight;
  var x = Math.min(e.clientX, window.innerWidth - mw - 8);
  var y = Math.min(e.clientY, window.innerHeight - mh - 8);
  fileCtxMenu.style.left = Math.max(4, x) + 'px';
  fileCtxMenu.style.top = Math.max(4, y) + 'px';
}

function hideFileCtxMenu() {
  if (fileCtxMenu) fileCtxMenu.classList.remove('visible');
}

function downloadFile(filename) {
  // Binary images registered via window.imageBlobs (data URLs) — handle first
  if (window.imageBlobs && window.imageBlobs[filename]) {
    var dataUrl = window.imageBlobs[filename];
    var a = document.createElement('a');
    a.href = dataUrl;
    a.download = filename;
    a.click();
    return;
  }

  var content = '';
  if (filename === 'main.tex') {
    content = editingFile ? (mainTexContent || '') : (window.getEditorContent ? window.getEditorContent() : '');
  } else if (editingFile === filename) {
    content = window.editorInstance ? window.editorInstance.getValue() : '';
  } else if (fileContents[filename] != null) {
    content = fileContents[filename];
  } else {
    showWarningToast('No local content to download for ' + filename);
    return;
  }

  var blob = new Blob([content], { type: 'text/plain' });
  var url = URL.createObjectURL(blob);
  var a = document.createElement('a');
  a.href = url;
  a.download = filename;
  a.click();
  setTimeout(function() { URL.revokeObjectURL(url); }, 200);
}

function renameFile(oldName, el) {
  if (oldName === 'main.tex') { showWarningToast('Cannot rename main.tex'); return; }

  var newName = prompt('Rename file:', oldName);
  if (!newName || !newName.trim() || newName === oldName) return;
  newName = newName.trim();
  // Only enforce .tex if original was .tex and user removed extension
  if (/\.tex$/i.test(oldName) && !/\.\w+$/.test(newName)) newName += '.tex';
  if (/[\/\\:*?"<>|]/.test(newName)) { showErrorToast('Invalid filename'); return; }

  // Update fileContents
  if (fileContents[oldName] != null) {
    fileContents[newName] = fileContents[oldName];
    delete fileContents[oldName];
  }

  // Update uploadedFiles
  for (var i = 0; i < uploadedFiles.length; i++) {
    if (uploadedFiles[i].filename === oldName) {
      uploadedFiles[i].filename = newName;
      break;
    }
  }

  // Update \input{} and \include{} references in main.tex
  var oldRef = oldName.replace(/\.tex$/i, '');
  var newRef = newName.replace(/\.tex$/i, '');
  var cm = window.editorInstance;
  if (cm && !editingFile) {
    // Editing main.tex — update live editor
    var src = cm.getValue();
    var updated = src.split('\\input{' + oldRef + '}').join('\\input{' + newRef + '}');
    updated = updated.split('\\include{' + oldRef + '}').join('\\include{' + newRef + '}');
    if (updated !== src) cm.setValue(updated);
  } else if (editingFile && mainTexContent != null) {
    // Editing a sub-file — update saved mainTexContent
    mainTexContent = mainTexContent.split('\\input{' + oldRef + '}').join('\\input{' + newRef + '}');
    mainTexContent = mainTexContent.split('\\include{' + oldRef + '}').join('\\include{' + newRef + '}');
  }

  // If currently editing this file, update editingFile
  if (editingFile === oldName) editingFile = newName;

  // Update DOM
  el.setAttribute('data-file', newName);
  var nameSpan = el.querySelector('.file-name');
  if (nameSpan) nameSpan.textContent = ' ' + newName;

  showSuccessToast('Renamed to ' + newName);
}

function deleteFile(filename, el) {
  if (filename === 'main.tex') { showWarningToast('Cannot delete main.tex'); return; }
  if (!confirm('Delete "' + filename + '"?')) return;

  // If editing this file, switch back first
  if (editingFile === filename) switchBackToMain();

  // Remove from fileContents
  delete fileContents[filename];

  // Remove from uploadedFiles
  for (var i = uploadedFiles.length - 1; i >= 0; i--) {
    if (uploadedFiles[i].filename === filename) {
      uploadedFiles.splice(i, 1);
    }
  }

  // Remove \input{} / \include{} from main.tex
  var ref = filename.replace(/\.tex$/i, '');
  var inputLine = '\\input{' + ref + '}';
  var includeLine = '\\include{' + ref + '}';
  function removeRef(src) {
    return src.split('\n').filter(function(l) { var t = l.trim(); return t !== inputLine && t !== includeLine; }).join('\n');
  }
  var cm = window.editorInstance;
  if (cm && !editingFile) {
    var src = cm.getValue();
    var updated = removeRef(src);
    if (updated !== src) cm.setValue(updated);
  } else if (editingFile && mainTexContent != null) {
    mainTexContent = removeRef(mainTexContent);
  }

  // Remove from DOM
  if (el && el.parentNode) el.parentNode.removeChild(el);

  showSuccessToast('Deleted ' + filename);
}

function selectFile(el) {
  var filename = el.getAttribute('data-file');
  if (!filename) return;

  // Image file — don't select, don't insert on click (use + button or context menu)
  if (IMAGE_EXTENSIONS.test(filename)) return;

  // Only open text-editable files in the editor (tex, csv, bib, etc.)
  if (filename !== 'main.tex' && !EDITABLE_TEXT_EXTENSIONS.test(filename)) return;

  var items = document.querySelectorAll('.file-item');
  for (var i = 0; i < items.length; i++) items[i].classList.remove('active');
  el.classList.add('active');

  if (filename === 'main.tex') {
    if (editingFile) switchBackToMain();
  } else {
    openFileInEditor(filename);
  }

  // On mobile, close the file drawer after selecting
  closeMobileDrawer();
}

// ── File editing: swap editor content, track main.tex ──

var editingFile = null;  // null = main.tex
var mainTexContent = null;

function updateEditorTab(filename) {
  var tab = document.querySelector('#editor-tabs .editor-tab');
  if (tab) {
    tab.textContent = filename;
    tab.setAttribute('data-file', filename);
  }
}

function openFileInEditor(filename) {
  var cm = window.editorInstance;
  if (!cm) return;

  // Already editing this file
  if (editingFile === filename) return;

  var content = fileContents[filename];
  if (content == null) {
    showWarningToast('File content not available locally');
    return;
  }

  // Save current editor content
  if (!editingFile) {
    mainTexContent = cm.getValue();
  } else {
    fileContents[editingFile] = cm.getValue();
  }

  editingFile = filename;
  cm.setValue(content);
  cm.clearHistory();
  cm.focus();

  updateEditorTab(filename);
  updateEditingIndicator();
}

function refreshEditingIndicator() {
  if (typeof updateEditingIndicator === 'function') updateEditingIndicator();
}

function switchBackToMain() {
  var cm = window.editorInstance;
  if (!cm || !editingFile) return;

  // Save current file
  fileContents[editingFile] = cm.getValue();

  // Re-upload the edited content so compile gets the latest
  reuploadFile(editingFile, cm.getValue());

  editingFile = null;
  if (mainTexContent != null) {
    cm.setValue(mainTexContent);
    mainTexContent = null;
  }
  cm.clearHistory();
  cm.focus();

  updateEditorTab('main.tex');
  updateEditingIndicator();

  // Re-select main.tex in tree
  var items = document.querySelectorAll('.file-item');
  items.forEach(function(el) {
    el.classList.toggle('active', el.getAttribute('data-file') === 'main.tex');
  });
}

function reuploadFile(filename, content, cb) {
  var blob = new Blob([content], { type: 'text/plain' });
  var formData = new FormData();
  formData.append('file', blob, filename);

  fetch(CONFIG.uploadUrl, { method: 'POST', body: formData })
    .then(function(res) { return res.json(); })
    .then(function(data) {
      if (data.fileId) {
        for (var i = 0; i < uploadedFiles.length; i++) {
          if (uploadedFiles[i].filename === filename) {
            uploadedFiles[i].fileId = data.fileId;
            if (cb) cb();
            return;
          }
        }
        uploadedFiles.push({ fileId: data.fileId, filename: filename });
      }
      if (cb) cb();
    })
    .catch(function() { if (cb) cb(); });
}

// Re-upload a binary file (PNG, JPG, PDF, etc.) from a data URL kept in
// window.imageBlobs. reuploadFile() can't be used for binaries — it wraps
// content as text/plain which corrupts non-text payloads.
function reuploadBinaryFromDataUrl(filename, dataUrl, cb) {
  fetch(dataUrl)
    .then(function(r) { return r.blob(); })
    .then(function(blob) {
      var formData = new FormData();
      formData.append('file', blob, filename);
      return fetch(CONFIG.uploadUrl, { method: 'POST', body: formData });
    })
    .then(function(res) { return res.json(); })
    .then(function(data) {
      if (data.fileId) {
        var found = false;
        for (var i = 0; i < uploadedFiles.length; i++) {
          if (uploadedFiles[i].filename === filename) {
            uploadedFiles[i].fileId = data.fileId; found = true; break;
          }
        }
        if (!found) uploadedFiles.push({ fileId: data.fileId, filename: filename });
      }
      if (cb) cb(null);
    })
    .catch(function(err) { if (cb) cb(err || new Error('upload failed')); });
}

// ── Missing-upload recovery ──────────────────────────────────────────────
//
// When the user's tab sits idle past the server's upload TTL (default 60
// min), uploaded files are swept from /tmp/latex-jobs/uploads/. The next
// compile then errors with:
//   "failed to copy upload <fileId>: open …: no such file or directory"
// We catch that, look up the filename for the dead fileId, re-upload the
// content from local cache (fileContents for text, window.imageBlobs for
// binaries), and retry the compile once. Three retries max in case
// multiple uploads expired in sequence — the server currently bails on the
// first failure, so each retry recovers one file.
var MISSING_UPLOAD_RE = /failed to copy upload ([0-9a-f-]+):[\s\S]*(?:no such file or directory|ENOENT)/i;
var MAX_MISSING_RETRIES = 5;
var missingRetryCount = 0;

function resetMissingRetries() { missingRetryCount = 0; }

// Returns true if we kicked off recovery (caller should NOT show the error
// toast). Returns false if not recoverable — caller proceeds normally.
function tryRecoverMissingUpload(errorMessage) {
  if (!errorMessage) return false;
  var m = errorMessage.match(MISSING_UPLOAD_RE);
  if (!m) return false;
  var staleId = m[1];

  if (missingRetryCount >= MAX_MISSING_RETRIES) {
    appendLogLine('Gave up after ' + MAX_MISSING_RETRIES +
                  ' upload-recovery attempts — please re-upload manually.', 'error');
    return false;
  }

  // Find the filename associated with this stale fileId
  var entry = null;
  for (var i = 0; i < uploadedFiles.length; i++) {
    if (uploadedFiles[i].fileId === staleId) { entry = uploadedFiles[i]; break; }
  }
  if (!entry) {
    appendLogLine('Server reported stale upload ' + staleId +
                  ' but it is no longer tracked locally — cannot recover.', 'error');
    return false;
  }

  var filename = entry.filename;
  // Remove the dead entry so re-upload doesn't update it in place with the
  // same (still-stale) reference if re-upload fails partway.
  uploadedFiles = uploadedFiles.filter(function(f) { return f.fileId !== staleId; });

  appendLogLine('Upload expired for "' + filename + '" — re-uploading and retrying…', 'info');
  missingRetryCount++;

  function afterRecover(err) {
    if (err) {
      appendLogLine('Recovery upload for "' + filename + '" failed: ' +
                    (err.message || err), 'error');
      showErrorToast('Could not re-upload "' + filename + '"');
      return;
    }
    // Retry compile from the top — triggerCompile() will re-sync text
    // sub-files automatically before sending. preserveRetries keeps the
    // counter we just incremented so successive failures bail eventually.
    setTimeout(function() { triggerCompile({ preserveRetries: true }); }, 50);
  }

  // Pick the right local source. Text sub-files live in fileContents;
  // chemistry / image-to-LaTeX captures live as data URLs in window.imageBlobs.
  if (typeof fileContents !== 'undefined' && fileContents[filename] != null) {
    reuploadFile(filename, fileContents[filename], function() { afterRecover(null); });
    return true;
  }
  if (window.imageBlobs && window.imageBlobs[filename]) {
    reuploadBinaryFromDataUrl(filename, window.imageBlobs[filename], afterRecover);
    return true;
  }

  // No local copy — cannot self-heal.
  appendLogLine('No local copy of "' + filename +
                '" cached in this tab — please re-upload via the file tree.', 'error');
  showErrorToast('Upload "' + filename + '" expired; re-upload it from the file tree.');
  return false;  // surface the original error too so the user sees it in context
}

function updateEditingIndicator() {
  var existing = document.getElementById('editing-indicator');
  if (!editingFile) {
    if (existing) existing.remove();
    return;
  }

  if (!existing) {
    existing = document.createElement('div');
    existing.id = 'editing-indicator';
    existing.className = 'editing-indicator';
    var editorPane = document.querySelector('.editor-pane');
    if (editorPane) editorPane.insertBefore(existing, editorPane.firstChild);
  }

  var activeContent = fileContents[editingFile];
  var cm = window.editorInstance;
  if (cm && editingFile) activeContent = cm.getValue();

  var compileHint = '';
  if (/\.tex$/i.test(editingFile)) {
    if (isStandaloneLaTeXDocument(activeContent)) {
      compileHint = '<span class="ei-hint">Compile builds this file</span>';
    } else {
      compileHint = '<span class="ei-hint">Compile builds main.tex</span>';
    }
  }

  existing.innerHTML =
    '<span class="ei-left">Editing: <strong>' + editingFile + '</strong> ' + compileHint + '</span>' +
    '<button class="ei-back" onclick="switchBackToMain()">&#8592; main.tex</button>';
}

function newFile() {
  var name = prompt('File name:', 'new-file.tex');
  if (!name || !name.trim()) return;
  name = name.trim();
  if (!/\.\w+$/.test(name)) name += '.tex';
  if (/[\/\\:*?"<>|]/.test(name)) { showErrorToast('Invalid filename'); return; }
  // Initialize with empty content so it's editable
  addFileToTree(name, false, '');
  // Open any text-editable file in the editor immediately so the user
  // can paste/type content (covers .tex, .csv, .bib, .dat, .txt, etc.)
  if (EDITABLE_TEXT_EXTENSIONS.test(name) || /\.tex$/i.test(name)) {
    openFileInEditor(name);
  }
}

function formatFileSize(bytes) {
  if (bytes < 1024) return bytes + ' B';
  if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + ' KB';
  return (bytes / (1024 * 1024)).toFixed(1) + ' MB';
}

// Add an uploaded file to the registry (called from ai.js move-to-file)
function addUploadedFile(fileId, filename) {
  uploadedFiles.push({ fileId: fileId, filename: filename });
}

// ── Drag-drop & paste images directly into editor ──

var IMAGE_MIME = /^image\/(png|jpe?g|gif|svg\+xml|webp|bmp)$/;
var dropCounter = 0;  // track dragenter/dragleave nesting

function initEditorImageDrop() {
  var cm = window.editorInstance;
  if (!cm) { setTimeout(initEditorImageDrop, 300); return; }

  var wrapper = cm.getWrapperElement();

  // ── Drag-drop ──
  wrapper.addEventListener('dragenter', function(e) {
    if (!hasImageFile(e.dataTransfer)) return;
    e.preventDefault();
    dropCounter++;
    wrapper.classList.add('image-drop-active');
  });

  wrapper.addEventListener('dragover', function(e) {
    if (!hasImageFile(e.dataTransfer)) return;
    e.preventDefault();
    e.dataTransfer.dropEffect = 'copy';
  });

  wrapper.addEventListener('dragleave', function(e) {
    if (!hasImageFile(e.dataTransfer)) return;
    dropCounter--;
    if (dropCounter <= 0) {
      dropCounter = 0;
      wrapper.classList.remove('image-drop-active');
    }
  });

  wrapper.addEventListener('drop', function(e) {
    dropCounter = 0;
    wrapper.classList.remove('image-drop-active');
    if (!e.dataTransfer || !e.dataTransfer.files || !e.dataTransfer.files.length) return;

    var file = findImageFile(e.dataTransfer.files);
    if (!file) return;

    e.preventDefault();
    e.stopPropagation();

    // Place cursor at drop position
    var coords = cm.coordsChar({ left: e.clientX, top: e.clientY });
    cm.setCursor(coords);

    uploadAndInsertImage(file);
  });

  // ── Paste image from clipboard ──
  wrapper.addEventListener('paste', function(e) {
    if (!e.clipboardData || !e.clipboardData.items) return;
    var items = e.clipboardData.items;
    for (var i = 0; i < items.length; i++) {
      if (IMAGE_MIME.test(items[i].type)) {
        e.preventDefault();
        var file = items[i].getAsFile();
        if (file) uploadAndInsertImage(file);
        return;
      }
    }
  });
}

function hasImageFile(dt) {
  if (!dt || !dt.types) return false;
  if (dt.types.indexOf('Files') === -1) return false;
  // Check items if available
  if (dt.items) {
    for (var i = 0; i < dt.items.length; i++) {
      if (dt.items[i].kind === 'file' && IMAGE_MIME.test(dt.items[i].type)) return true;
    }
  }
  return true; // allow drop, validate on actual drop
}

function findImageFile(files) {
  for (var i = 0; i < files.length; i++) {
    if (IMAGE_MIME.test(files[i].type)) return files[i];
  }
  return null;
}

function uploadAndInsertImage(file) {
  if (file.size > MAX_FILE_SIZE) {
    showErrorToast('Image too large. Maximum 5MB.');
    return;
  }

  var cm = window.editorInstance;
  if (!cm) return;

  // Insert placeholder at cursor
  var cursor = cm.getCursor();
  var placeholder = '% Uploading ' + file.name + '...';
  cm.replaceRange(placeholder + '\n', cursor);
  var placeholderFrom = { line: cursor.line, ch: 0 };
  var placeholderTo = { line: cursor.line, ch: placeholder.length };

  showSuccessToast('Uploading ' + file.name + '...');

  var formData = new FormData();
  formData.append('file', file);

  fetch(CONFIG.uploadUrl, {
    method: 'POST',
    body: formData
  })
  .then(function(res) {
    if (!res.ok) return res.json().then(function(d) { throw new Error(d.error || 'Upload failed'); });
    return res.json();
  })
  .then(function(data) {
    var fname = data.filename || file.name;
    var fid = data.fileId;

    if (fid) addUploadedFile(fid, fname);
    addFileToTree(fname, true);

    // Replace placeholder with \includegraphics
    var label = fname.replace(/\.[^.]+$/, '').replace(/[^a-zA-Z0-9]/g, '-');
    var figureCode =
      '\\begin{figure}[htbp]\n' +
      '\\centering\n' +
      '\\includegraphics[width=0.8\\textwidth]{' + fname + '}\n' +
      '\\caption{' + fname.replace(/\.[^.]+$/, '').replace(/[-_]/g, ' ') + '}\n' +
      '\\label{fig:' + label + '}\n' +
      '\\end{figure}';

    // Find and replace the placeholder line
    var lineContent = cm.getLine(placeholderFrom.line);
    if (lineContent && lineContent.indexOf('% Uploading') === 0) {
      cm.replaceRange(figureCode, placeholderFrom, { line: placeholderFrom.line + 1, ch: 0 });
    } else {
      // Placeholder was edited/moved — just insert at cursor
      cm.replaceRange(figureCode + '\n', cm.getCursor());
    }

    showSuccessToast('Inserted ' + fname);
    appendLogLine('Image uploaded: ' + fname, 'success');
  })
  .catch(function(err) {
    // Remove placeholder on error
    var lineContent = cm.getLine(placeholderFrom.line);
    if (lineContent && lineContent.indexOf('% Uploading') === 0) {
      cm.replaceRange('', placeholderFrom, { line: placeholderFrom.line + 1, ch: 0 });
    }
    showErrorToast('Upload failed: ' + err.message);
    appendLogLine('Image upload failed: ' + err.message, 'error');
  });
}

initEditorImageDrop();

// Expose globally
window.triggerCompile = triggerCompile;
window.onEditorChange = onEditorChange;
window.toggleLogPanel = toggleLogPanel;
window.uploadFile = uploadFile;
window.selectFile = selectFile;
window.newFile = newFile;
window.showErrorToast = showErrorToast;
window.showSuccessToast = showSuccessToast;
window.showWarningToast = showWarningToast;
window.nextError = nextError;
window.prevError = prevError;
window.insertUploadedFigure = insertUploadedFigure;
window.addUploadedFile = addUploadedFile;
window.addFileToTree = addFileToTree;
window.reuploadFile = reuploadFile;
window.switchBackToMain = switchBackToMain;

// ── Mobile file drawer ──
function toggleMobileDrawer() {
  var tree = document.getElementById('file-tree');
  var backdrop = document.getElementById('filetree-backdrop');
  if (!tree) return;
  var isOpen = tree.classList.contains('drawer-open');
  tree.classList.toggle('drawer-open', !isOpen);
  if (backdrop) backdrop.classList.toggle('visible', !isOpen);
}
function closeMobileDrawer() {
  var tree = document.getElementById('file-tree');
  var backdrop = document.getElementById('filetree-backdrop');
  if (tree) tree.classList.remove('drawer-open');
  if (backdrop) backdrop.classList.remove('visible');
}
window.toggleMobileDrawer = toggleMobileDrawer;
window.closeMobileDrawer = closeMobileDrawer;
window.showFileContextMenu = showFileContextMenu;
window.fileContents = fileContents;
window.uploadedFiles = uploadedFiles;
// Exposed for the recovery test harness — also useful from devtools when
// debugging "upload expired" cases manually.
window.isStandaloneLaTeXDocument = isStandaloneLaTeXDocument;
window.resolveCompileRoot = resolveCompileRoot;

})();
