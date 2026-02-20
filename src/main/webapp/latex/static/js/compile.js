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

function showToast(message, type) {
  var container = ensureToastContainer();
  var toast = document.createElement('div');
  toast.className = 'toast ' + (type || 'info');
  toast.textContent = message;
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

// ── Main compile ──
function triggerCompile() {
  clearTimeout(debounceTimer);
  stopMonitoring();

  var source = window.getEditorContent();
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

  setCompileStatus('Compiling...', 'compiling');
  showPDFLoading(true);
  clearErrorMarkers();
  if (typeof window.clearErrorWidgets === 'function') window.clearErrorWidgets();
  clearLogPanel();

  var compileBtn = document.getElementById('btn-compile');
  if (compileBtn) compileBtn.classList.add('compiling');
  updateCompileButton();

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

  setCompileStatus('\u2715 Error', 'error');
  showPDFLoading(false);

  var msg = data.message || data.error || 'Compilation failed';
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
    var fname = data.filename || file.name;
    var fid = data.fileId;

    appendLogLine('Uploaded: ' + fname + (fid ? ' (id: ' + fid.substring(0, 8) + '...)' : ''), 'success');
    showSuccessToast('File uploaded: ' + fname);

    // Track for compile
    if (fid) {
      uploadedFiles.push({ fileId: fid, filename: fname });
    }

    // Add to file tree with insert action for images
    addFileToTree(fname, isImage);

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

function addFileToTree(filename, isImage) {
  var fileList = document.getElementById('file-list');
  if (!fileList) return;

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

  item.onclick = function() { selectFile(item); };
  fileList.appendChild(item);
}

function selectFile(el) {
  var items = document.querySelectorAll('.file-item');
  for (var i = 0; i < items.length; i++) items[i].classList.remove('active');
  el.classList.add('active');
}

function newFile() {
  var name = prompt('File name:', 'new-file.tex');
  if (name) addFileToTree(name, false);
}

function formatFileSize(bytes) {
  if (bytes < 1024) return bytes + ' B';
  if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + ' KB';
  return (bytes / (1024 * 1024)).toFixed(1) + ' MB';
}

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

})();
