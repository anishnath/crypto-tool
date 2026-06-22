(function() {
'use strict';

var aiAbortController = null;
var AI_TIMEOUT_MS = 90000;
var aiBusy = false;

function aiBoot() {
  return window.latexAiBoot || {};
}

function transportOpts() {
  var b = aiBoot();
  var ctx = (typeof CONFIG !== 'undefined' && CONFIG.ctx) ? CONFIG.ctx : '';
  return {
    aiUrl: b.aiUrl || (ctx + '/ai'),
    useGateway: b.useGateway === true,
    userId: b.userId || '',
    toolId: b.toolId || '',
  };
}

function ensureAiAccess() {
  var b = aiBoot();
  if (b.billing && b.billing.requireSignIn && !(b.userId || '')) {
    if (typeof window.showWarningToast === 'function') window.showWarningToast('Sign in to use AI');
    if (window.latexAssistant && typeof window.latexAssistant.open === 'function') {
      window.latexAssistant.open('', false);
    }
    return false;
  }
  return true;
}

function handleAiError(err, onError) {
  if (err && err.name === 'AbortError') return;
  var msg = (err && err.message) ? err.message : 'AI request failed';
  if (err && (err.status === 401 || err.status === 403)) {
    msg = 'Sign in required';
    if (window.latexAssistant && typeof window.latexAssistant.open === 'function') {
      window.latexAssistant.open('', false);
    }
  } else if (err && err.upgrade && typeof window.showWarningToast === 'function') {
    window.showWarningToast(msg);
  }
  onError(msg);
}

// ── LaTeX-specific system prompts (inline flows) ──

var SYSTEM_FIX_ERROR =
    'You are a LaTeX expert. Given a LaTeX compilation error and the surrounding source code, '
  + 'return ONLY the corrected LaTeX code for the affected lines. '
  + 'Do not include markdown fences, explanations, or commentary. '
  + 'Preserve all surrounding code exactly. Only fix the error.';

var SYSTEM_REWRITE =
    'Rewrite the following LaTeX text. Keep ALL LaTeX commands, environments, labels, '
  + 'and references exactly as-is. Only change the natural language content. '
  + 'Return ONLY the rewritten LaTeX. No markdown fences, no explanation.';

var REWRITE_STYLES = {
  formal: ' Rewrite in formal academic English.',
  concise: ' Make the text more concise and direct.',
  expand: ' Expand the text with more detail and explanation.'
};

function buildPayload(systemPrompt, userContent, stream) {
  return {
    messages: [
      { role: 'system', content: systemPrompt },
      { role: 'user', content: userContent }
    ],
    stream: !!stream
  };
}

function streamAI(payload, callbacks) {
  if (!ensureAiAccess()) {
    if (callbacks.onError) callbacks.onError('Sign in required');
    return;
  }
  var T = window.latexAiTransport;
  if (!T || typeof T.streamChat !== 'function') {
    if (callbacks.onError) callbacks.onError('AI transport not ready');
    return;
  }

  if (aiAbortController) aiAbortController.abort();
  aiAbortController = new AbortController();

  var onToken = callbacks.onToken || function() {};
  var onDone  = callbacks.onDone  || function() {};
  var onError = callbacks.onError || function() {};
  var opts = transportOpts();

  var timeoutId = setTimeout(function() {
    aiAbortController.abort();
    onError('Request timed out');
  }, AI_TIMEOUT_MS);

  T.streamChat(opts.aiUrl, payload, {
    useGateway: opts.useGateway,
    userId: opts.userId,
    toolId: opts.toolId,
    signal: aiAbortController.signal,
    onDelta: function(delta) { onToken(delta); }
  })
  .then(function() {
    clearTimeout(timeoutId);
    onDone();
  })
  .catch(function(err) {
    clearTimeout(timeoutId);
    handleAiError(err, onError);
  });
}

function requestAI(payload, callback) {
  if (!ensureAiAccess()) {
    callback('Sign in required', null);
    return;
  }
  var T = window.latexAiTransport;
  if (!T || typeof T.chat !== 'function') {
    callback('AI transport not ready', null);
    return;
  }

  if (aiAbortController) aiAbortController.abort();
  aiAbortController = new AbortController();
  var opts = transportOpts();

  var timeoutId = setTimeout(function() {
    aiAbortController.abort();
    callback('Request timed out', null);
  }, AI_TIMEOUT_MS);

  T.chat(opts.aiUrl, payload, {
    useGateway: opts.useGateway,
    userId: opts.userId,
    toolId: opts.toolId,
    signal: aiAbortController.signal
  })
  .then(function(content) {
    clearTimeout(timeoutId);
    callback(null, content || '');
  })
  .catch(function(err) {
    clearTimeout(timeoutId);
    if (err && err.name === 'AbortError') return;
    handleAiError(err, function(msg) { callback(msg, null); });
  });
}

// ══════════════════════════════════════════════════════════════
// FIX ERROR — non-streaming, replaces broken code
// ══════════════════════════════════════════════════════════════

function fixError(errorMsg, lineNum) {
  if (!ensureAiAccess()) return;
  if (aiBusy) { if (typeof window.showWarningToast === 'function') window.showWarningToast('AI is busy'); return; }
  if (!window.editorInstance) return;
  var cm = window.editorInstance;

  // Extract ~10 lines around the error
  var startLine = Math.max(0, lineNum - 6);
  var endLine = Math.min(cm.lineCount() - 1, lineNum + 5);
  var codeLines = [];
  for (var i = startLine; i <= endLine; i++) {
    codeLines.push(cm.getLine(i));
  }
  var codeContext = codeLines.join('\n');

  // Show loading state on the widget
  var widgets = document.querySelectorAll('.cm-error-widget');
  var targetWidget = null;
  for (var w = 0; w < widgets.length; w++) {
    targetWidget = widgets[w];
  }
  if (targetWidget) {
    var aiBtn = targetWidget.querySelector('.ai-fix-btn');
    if (aiBtn) {
      aiBtn.innerHTML = '<span class="ai-btn-spinner"></span> Fixing...';
      aiBtn.disabled = true;
    }
  }

  var userContent = 'LaTeX compilation error:\n' + errorMsg
    + '\n\nError at line ' + lineNum
    + '\n\nSurrounding code:\n' + codeContext;

  requestAI(buildPayload(SYSTEM_FIX_ERROR, userContent, false), function(err, result) {
    if (err) {
      if (typeof window.showErrorToast === 'function') window.showErrorToast('AI Fix failed: ' + err);
      resetFixButton(targetWidget);
      return;
    }

    if (!result || !result.trim()) {
      if (typeof window.showErrorToast === 'function') window.showErrorToast('AI returned empty fix');
      resetFixButton(targetWidget);
      return;
    }

    // Clean markdown fences if model included them
    result = cleanLatexResponse(result);

    // Replace the code region
    var from = { line: startLine, ch: 0 };
    var to = { line: endLine, ch: cm.getLine(endLine).length };
    cm.replaceRange(result, from, to);

    // Clear error markers for this line
    if (typeof window.clearErrorMarkers === 'function') window.clearErrorMarkers();
    if (typeof window.clearErrorWidgets === 'function') window.clearErrorWidgets();

    if (typeof window.showSuccessToast === 'function') window.showSuccessToast('AI fix applied');
  });
}

function resetFixButton(widget) {
  if (!widget) return;
  var aiBtn = widget.querySelector('.ai-fix-btn');
  if (aiBtn) {
    aiBtn.textContent = '\u2728 AI Fix';
    aiBtn.disabled = false;
  }
}

// ══════════════════════════════════════════════════════════════
// REWRITE SELECTION — streaming diff review (selection popup / toolbar)
// ══════════════════════════════════════════════════════════════

function rewriteSelection(style) {
  var rewriteSystem = SYSTEM_REWRITE + (REWRITE_STYLES[style] || REWRITE_STYLES.formal);
  streamWithDiff(rewriteSystem);
}

// ══════════════════════════════════════════════════════════════
// CANCEL
// ══════════════════════════════════════════════════════════════

function cancelAI() {
  if (aiAbortController) {
    aiAbortController.abort();
    aiAbortController = null;
  }
  aiBusy = false;
  showAIIndicator(false);
}

// ══════════════════════════════════════════════════════════════
// AI INDICATOR (status bar + overlay)
// ══════════════════════════════════════════════════════════════

function showAIIndicator(show) {
  aiBusy = show;

  // Status bar
  var el = document.getElementById('sb-ai-status');
  if (el) {
    if (show) {
      el.textContent = '\u2728 AI generating...';
      el.style.display = '';
    } else {
      el.style.display = 'none';
      el.textContent = '';
    }
  }

  // Editor overlay spinner
  var overlay = document.getElementById('ai-loading-overlay');
  if (!overlay && show) {
    overlay = document.createElement('div');
    overlay.id = 'ai-loading-overlay';
    overlay.className = 'ai-loading-overlay';
    overlay.innerHTML = '<div class="ai-spinner"></div><div class="ai-spinner-text">\u2728 AI generating...</div>'
      + '<button class="ai-spinner-cancel" onclick="cancelAI()">Cancel</button>';
    var editorBody = document.querySelector('.editor-body');
    if (editorBody) editorBody.appendChild(overlay);
  }
  if (overlay) {
    if (show) {
      overlay.classList.add('visible');
    } else {
      overlay.classList.remove('visible');
      setTimeout(function() { if (overlay.parentNode && !overlay.classList.contains('visible')) overlay.parentNode.removeChild(overlay); }, 200);
    }
  }
}

// ══════════════════════════════════════════════════════════════
// HELPERS
// ══════════════════════════════════════════════════════════════

function cleanLatexResponse(text) {
  // Remove markdown code fences if model included them
  text = text.replace(/^```(?:latex|tex)?\s*\n?/i, '');
  text = text.replace(/\n?```\s*$/i, '');
  return text.trim();
}

// Close selection popup on outside click
document.addEventListener('click', function(e) {
  var menu = document.getElementById('ai-rewrite-menu');
  if (menu && menu.classList.contains('visible')) {
    if (!menu.contains(e.target) && !e.target.closest('#btn-ai-rewrite')) {
      menu.classList.remove('visible');
    }
  }
});

// Escape cancels in-progress inline AI generation
document.addEventListener('keydown', function(e) {
  if (e.key === 'Escape' && aiAbortController) {
    cancelAI();
  }
});

// ══════════════════════════════════════════════════════════════
// SELECTION POPUP — floating actions on text selection
// ══════════════════════════════════════════════════════════════

var selPopup = null;
var selPopupDebounce = null;

var SYSTEM_PROOFREAD =
    'You are a proofreader for LaTeX documents. '
  + 'Fix grammar, spelling, punctuation, and awkward phrasing in the selected text. '
  + 'Keep ALL LaTeX commands, environments, math mode, labels, and references exactly as-is. '
  + 'Only correct the natural language. '
  + 'Return ONLY the corrected LaTeX. No markdown fences, no explanation.';

var SYSTEM_SIMPLIFY =
    'Simplify the following LaTeX text. Make it shorter and clearer while preserving the meaning. '
  + 'Keep ALL LaTeX commands, environments, math mode, labels, and references exactly as-is. '
  + 'Return ONLY the simplified LaTeX. No markdown fences, no explanation.';

var SYSTEM_TRANSLATE =
    'Translate the following LaTeX text into TARGET_LANG. '
  + 'Keep ALL LaTeX commands, environments, math mode, labels, and references exactly as-is. '
  + 'Only translate the natural language content. '
  + 'Return ONLY the translated LaTeX. No markdown fences, no explanation.';

function createSelPopup() {
  if (selPopup) return;
  selPopup = document.createElement('div');
  selPopup.className = 'sel-popup';
  selPopup.innerHTML =
    '<button data-sel-action="proofread" title="Fix grammar &amp; spelling">Proofread</button>' +
    '<span class="sel-divider"></span>' +
    '<button data-sel-action="formal" title="Formal academic tone">Formal</button>' +
    '<button data-sel-action="concise" title="Make concise">Concise</button>' +
    '<button data-sel-action="expand" title="Expand with detail">Expand</button>' +
    '<span class="sel-divider"></span>' +
    '<button data-sel-action="simplify" title="Simplify text">Simplify</button>' +
    '<span class="sel-divider"></span>' +
    '<div class="sel-translate-wrap">' +
    '  <button data-sel-action="translate" title="Translate keeping LaTeX">Translate</button>' +
    '  <select class="sel-lang-picker">' +
    '    <option value="Spanish">ES</option><option value="French">FR</option>' +
    '    <option value="German">DE</option><option value="Chinese">ZH</option>' +
    '    <option value="Japanese">JA</option><option value="Portuguese">PT</option>' +
    '    <option value="Hindi">HI</option><option value="Arabic">AR</option>' +
    '  </select>' +
    '</div>' +
    '<span class="sel-divider"></span>' +
    '<button data-sel-action="move-to-file" title="Extract to separate .tex file">Move to File</button>' +
    '<span class="sel-divider sel-mol-sep" style="display:none"></span>' +
    '<div class="sel-mol-wrap" style="display:none;position:relative">' +
    '  <button data-sel-action="render-mol-toggle" class="sel-mol-btn" title="Render molecular structure from \\ce{...}">&#9883; Render <span class="sel-mol-caret">&#9662;</span></button>' +
    '  <div class="sel-mol-menu" role="menu">' +
    '    <button data-sel-action="render-mol" data-mol-mode="lewis" role="menuitem"><b>Lewis dot structure</b><span>electrons & formal charges</span></button>' +
    '    <button data-sel-action="render-mol" data-mol-mode="smiles" role="menuitem"><b>SMILES</b><span>render 2D from SMILES notation</span></button>' +
    '    <button data-sel-action="render-mol" data-mol-mode="3d" role="menuitem"><b>3D geometry</b><span>VSEPR shape, bond angles</span></button>' +
    '  </div>' +
    '</div>' +
    '<span class="sel-divider sel-math-sep" style="display:none"></span>' +
    '<div class="sel-math-wrap" style="display:none;position:relative">' +
    '  <button data-sel-action="solve-math-toggle" class="sel-math-btn" title="Solve this math expression inline">&#931; Solve <span class="sel-math-caret">&#9662;</span></button>' +
    '  <div class="sel-math-menu" role="menu">' +
    '    <button data-sel-action="solve-math" data-math-mode="simple" role="menuitem"><b>Solve</b><span>append &nbsp;= &lt;value&gt; &nbsp;inline</span></button>' +
    '    <button data-sel-action="solve-math" data-math-mode="steps" role="menuitem"><b>Solve with steps</b><span>insert worked solution as align* block</span></button>' +
    '    <button data-sel-action="solve-math" data-math-mode="graph" role="menuitem"><b>Show graph</b><span>pgfplots curve + result info, side-by-side</span></button>' +
    '  </div>' +
    '</div>';

  selPopup.addEventListener('mousedown', function(e) { e.preventDefault(); }); // prevent deselection
  selPopup.addEventListener('click', function(e) {
    var btn = e.target.closest('[data-sel-action]');
    if (!btn) return;
    var action = btn.getAttribute('data-sel-action');

    // Toggle action: keep popup open, just open/close the chem submenu
    if (action === 'render-mol-toggle') {
      e.stopPropagation();
      var wrap = selPopup.querySelector('.sel-mol-wrap');
      if (wrap) wrap.classList.toggle('open');
      return;
    }
    // Toggle the math Solve submenu (Solve / Solve with steps)
    if (action === 'solve-math-toggle') {
      e.stopPropagation();
      var mwrap = selPopup.querySelector('.sel-math-wrap');
      if (mwrap) mwrap.classList.toggle('open');
      return;
    }

    hideSelPopup();
    if (action === 'proofread') doSelAction(SYSTEM_PROOFREAD);
    else if (action === 'formal') rewriteSelection('formal');
    else if (action === 'concise') rewriteSelection('concise');
    else if (action === 'expand') rewriteSelection('expand');
    else if (action === 'simplify') doSelAction(SYSTEM_SIMPLIFY);
    else if (action === 'translate') {
      var lang = selPopup.querySelector('.sel-lang-picker').value || 'Spanish';
      doSelAction(SYSTEM_TRANSLATE.replace('TARGET_LANG', lang));
    }
    else if (action === 'move-to-file') { doMoveToFile(); }
    else if (action === 'render-mol') {
      var mode = btn.getAttribute('data-mol-mode') || 'lewis';
      if (window.ChemInsert && selPopup._chemDetected) {
        window.ChemInsert.render(selPopup._chemDetected, mode);
      }
    }
    else if (action === 'solve-math') {
      var mathMode = btn.getAttribute('data-math-mode') || 'simple';
      if (window.MathInsert && selPopup._mathDetected) {
        window.MathInsert.solve(selPopup._mathDetected, mathMode);
      }
    }
  });

  document.body.appendChild(selPopup);
}

function doSelAction(systemPrompt) {
  streamWithDiff(systemPrompt);
}

// ══════════════════════════════════════════════════════════════
// DIFF REVIEW — stream AI into buffer, show inline diff,
// user accepts or rejects
// ══════════════════════════════════════════════════════════════

var activeDiff = null; // tracks current diff state

function streamWithDiff(systemPrompt) {
  if (!ensureAiAccess()) return;
  if (aiBusy) { if (typeof window.showWarningToast === 'function') window.showWarningToast('AI is busy'); return; }
  var cm = window.editorInstance;
  if (!cm) return;
  var selection = cm.getSelection();
  if (!selection || !selection.trim()) {
    if (typeof window.showWarningToast === 'function') window.showWarningToast('Select text first');
    return;
  }

  // Dismiss any existing diff
  if (activeDiff) dismissDiff(false);

  var from = cm.getCursor('from');
  var to = cm.getCursor('to');
  var originalText = selection;
  var aiBuffer = '';

  // Mark original text as "pending" (dim it)
  var pendingMark = cm.markText(from, to, { className: 'ai-diff-pending' });

  showAIIndicator(true);

  streamAI(buildPayload(systemPrompt, originalText, true), {
    onToken: function(token) {
      aiBuffer += token;
    },
    onDone: function() {
      showAIIndicator(false);
      var aiText = cleanLatexResponse(aiBuffer);
      if (!aiText || aiText === originalText) {
        pendingMark.clear();
        if (typeof window.showSuccessToast === 'function') window.showSuccessToast('No changes needed');
        cm.focus();
        return;
      }
      showInlineDiff(cm, from, to, originalText, aiText, pendingMark);
    },
    onError: function(err) {
      showAIIndicator(false);
      pendingMark.clear();
      if (typeof window.showErrorToast === 'function') window.showErrorToast('AI error: ' + err);
    }
  });
}

function showInlineDiff(cm, from, to, originalText, aiText, pendingMark) {
  // Clear the pending mark
  pendingMark.clear();

  // Strike-through original text (red)
  var originalMark = cm.markText(from, to, { className: 'ai-diff-remove' });

  // Insert AI text right after the original with green highlight
  var insertPos = to;
  var separator = '\n';
  cm.replaceRange(separator + aiText, insertPos);

  // Calculate end of inserted text
  var aiLines = (separator + aiText).split('\n');
  var aiEnd;
  if (aiLines.length === 1) {
    aiEnd = { line: insertPos.line, ch: insertPos.ch + aiLines[0].length };
  } else {
    aiEnd = { line: insertPos.line + aiLines.length - 1, ch: aiLines[aiLines.length - 1].length };
  }
  var aiFrom = { line: insertPos.line, ch: insertPos.ch };
  var aiMark = cm.markText(
    { line: aiFrom.line + 1, ch: 0 },  // skip the separator newline
    aiEnd,
    { className: 'ai-diff-add' }
  );

  // Add Accept/Reject widget below the diff
  var widget = document.createElement('div');
  widget.className = 'ai-diff-actions';
  widget.innerHTML =
    '<button class="ai-diff-accept" data-action="accept">Accept</button>' +
    '<button class="ai-diff-reject" data-action="reject">Reject</button>' +
    '<span class="ai-diff-hint">Ctrl+Enter to accept &middot; Esc to reject</span>';

  var lineWidget = cm.addLineWidget(aiEnd.line, widget, { coverGutter: false, noHScroll: true });

  activeDiff = {
    cm: cm,
    originalText: originalText,
    aiText: aiText,
    originalFrom: from,
    originalTo: to,
    aiFrom: { line: aiFrom.line + 1, ch: 0 },
    aiEnd: aiEnd,
    separator: separator,
    originalMark: originalMark,
    aiMark: aiMark,
    lineWidget: lineWidget,
    widget: widget
  };

  // Wire buttons
  widget.addEventListener('click', function(e) {
    var btn = e.target.closest('[data-action]');
    if (!btn) return;
    if (btn.getAttribute('data-action') === 'accept') dismissDiff(true);
    else dismissDiff(false);
  });

  // Keyboard: Tab=accept, Esc=reject
  cm.addKeyMap(diffKeyMap);
  cm.focus();
}

var diffKeyMap = {
  'Ctrl-Enter': function() { dismissDiff(true); },
  'Cmd-Enter': function() { dismissDiff(true); },
  'Escape': function() { dismissDiff(false); }
};

function dismissDiff(accept) {
  if (!activeDiff) return;
  var d = activeDiff;
  activeDiff = null;

  d.cm.removeKeyMap(diffKeyMap);

  // Read live positions from marks (survive document edits during review)
  var origRange = d.originalMark.find();
  var aiRange = d.aiMark.find();

  d.originalMark.clear();
  d.aiMark.clear();
  d.lineWidget.clear();

  if (!origRange || !aiRange) {
    // Marks were cleared by external edits — just clean up
    if (typeof window.showWarningToast === 'function') window.showWarningToast('Diff lost — text was edited');
    d.cm.focus();
    return;
  }

  if (accept) {
    // Remove original + separator, keep AI text
    d.cm.replaceRange('', origRange.from, aiRange.from);
    if (typeof window.showSuccessToast === 'function') window.showSuccessToast('Change accepted');
  } else {
    // Remove separator + AI text, keep original
    d.cm.replaceRange('', origRange.to, aiRange.to);
    if (typeof window.showSuccessToast === 'function') window.showSuccessToast('Change rejected');
  }

  d.cm.focus();
}

// ── Move to File: extract selection → upload as .tex → replace with \input{} ──

var moveToFileCounter = 0;

function doMoveToFile() {
  var cm = window.editorInstance;
  if (!cm) return;
  var selection = cm.getSelection();
  if (!selection || !selection.trim()) return;

  // Suggest a filename based on content or counter
  moveToFileCounter++;
  var defaultName = 'section-' + moveToFileCounter + '.tex';

  // Try to extract a meaningful name from \section{} or \chapter{}
  var secMatch = selection.match(/\\(?:section|chapter|subsection)\{([^}]{1,40})\}/);
  if (secMatch) {
    defaultName = secMatch[1].toLowerCase()
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-|-$/g, '') + '.tex';
  }

  var filename = prompt('File name for extracted content:', defaultName);
  if (!filename) return;
  filename = filename.trim();
  if (!filename) return;
  if (!/\.tex$/i.test(filename)) filename += '.tex';

  // Validate filename
  if (/[\/\\:*?"<>|]/.test(filename)) {
    if (typeof window.showErrorToast === 'function') window.showErrorToast('Invalid filename');
    return;
  }

  // Capture cursor positions NOW (before async fetch)
  var selFrom = cm.getCursor('from');
  var selTo = cm.getCursor('to');

  // Check for duplicate
  if (window.fileContents && window.fileContents[filename] != null) {
    if (!confirm(filename + ' already exists. Overwrite?')) return;
  }

  // Upload as .tex file
  var blob = new Blob([selection], { type: 'text/plain' });
  var formData = new FormData();
  formData.append('file', blob, filename);

  if (typeof window.showSuccessToast === 'function') window.showSuccessToast('Moving to ' + filename + '...');

  fetch(CONFIG.uploadUrl, {
    method: 'POST',
    body: formData
  })
  .then(function(res) {
    if (!res.ok) return res.json().then(function(d) { throw new Error(d.error || 'Upload failed'); });
    return res.json();
  })
  .then(function(data) {
    var fid = data.fileId;
    var fname = data.filename || filename;

    // Track for compile
    if (fid) {
      if (typeof window.addUploadedFile === 'function') {
        window.addUploadedFile(fid, fname);
      }
    }

    // Replace selection with \input{filename} using pre-captured positions
    var inputCmd = '\\input{' + fname.replace(/\.tex$/i, '') + '}';
    cm.replaceRange(inputCmd, selFrom, selTo);
    cm.focus();

    if (typeof window.showSuccessToast === 'function')
      window.showSuccessToast('Moved to ' + fname + ' — \\input{} inserted');

    // Add to file tree with content
    if (typeof window.addFileToTree === 'function') window.addFileToTree(fname, false, selection);
  })
  .catch(function(err) {
    if (typeof window.showErrorToast === 'function') window.showErrorToast('Move failed: ' + err.message);
  });
}

function showSelPopup(cm) {
  if (!selPopup) createSelPopup();

  // Toggle the chemistry render dropdown based on \ce{...} detection in selection
  var molWrap = selPopup.querySelector('.sel-mol-wrap');
  var molBtn = selPopup.querySelector('.sel-mol-btn');
  var molSep = selPopup.querySelector('.sel-mol-sep');
  var detected = (window.ChemInsert && cm.getSelection())
    ? window.ChemInsert.detect(cm.getSelection())
    : null;
  selPopup._chemDetected = detected;
  // As soon as a \ce{...} is touched, make sure the mhchem package is loaded
  // so the document compiles even if the user never opens the render menu.
  if (detected && window.ChemInsert && typeof window.ChemInsert.ensureMhchem === 'function') {
    try { window.ChemInsert.ensureMhchem(cm); } catch (e) {}
  }
  if (molWrap && molBtn && molSep) {
    molWrap.classList.remove('open'); // always start collapsed
    if (detected) {
      molBtn.innerHTML = '&#9883; Render ' + detected.main + ' <span class="sel-mol-caret">&#9662;</span>';
      molWrap.style.display = '';
      molSep.style.display = '';
    } else {
      molWrap.style.display = 'none';
      molSep.style.display = 'none';
    }
  }

  // Toggle the math Solve dropdown when a \lim_{...} (etc.) is in the selection
  var mathWrap = selPopup.querySelector('.sel-math-wrap');
  var mathBtn = selPopup.querySelector('.sel-math-btn');
  var mathSep = selPopup.querySelector('.sel-math-sep');
  var mathDetected = (window.MathInsert && cm.getSelection())
    ? window.MathInsert.detect(cm.getSelection())
    : null;
  selPopup._mathDetected = mathDetected;
  if (mathWrap && mathBtn && mathSep) {
    mathWrap.classList.remove('open'); // start collapsed
    if (mathDetected) {
      // For matrix ops, show the concrete operation name (determinant /
      // eigenvalues / …) — much more informative than a generic "matrix".
      // For code blocks, the button becomes "▶ Run <Language>" with a
      // multi-file suffix when applicable.
      var label = mathDetected.type === 'limit' ? 'limit' :
                  mathDetected.type === 'integral' ? 'integral' :
                  mathDetected.type === 'derivative' ? 'derivative' :
                  mathDetected.type === 'series' ? 'series' :
                  mathDetected.type === 'matrix'
                    ? ((mathDetected.parsed && mathDetected.parsed.opLabel) || 'matrix')
                    : mathDetected.type === 'code'
                    ? ((mathDetected.parsed && mathDetected.parsed.languageLabel) || 'code')
                    : 'expression';
      var btnPrefix = (mathDetected.type === 'code') ? '&#9654; Run ' : '&#931; Solve ';
      var multiSuffix = (mathDetected.type === 'code' && mathDetected.parsed && mathDetected.parsed.isMulti)
        ? ' <span style="opacity:0.7">(' + mathDetected.parsed.files.length + ' files)</span>'
        : '';
      mathBtn.innerHTML = btnPrefix + label + multiSuffix +
        ' <span class="sel-math-caret">&#9662;</span>';
      mathWrap.style.display = '';
      mathSep.style.display = '';
      // Graph mode: limit/integral/derivative always render (pgfplots curve);
      // matrix renders only when the op + matrix is 2D-visualizable (2x2,
      // numeric, op has geometric meaning). canVisualize2D handles all that.
      // Code blocks have no graph or steps mode — only a single "Run".
      var graphBtn = selPopup.querySelector('[data-sel-action="solve-math"][data-math-mode="graph"]');
      var stepsBtn = selPopup.querySelector('[data-sel-action="solve-math"][data-math-mode="steps"]');
      var simpleBtn = selPopup.querySelector('[data-sel-action="solve-math"][data-math-mode="simple"]');
      var canGraph = true;
      var showSteps = true;
      if (mathDetected.type === 'matrix') {
        canGraph = !!(window.MatrixCalculatorCore
                      && window.MatrixCalculatorCore.canVisualize2D
                      && window.MatrixCalculatorCore.canVisualize2D(mathDetected.parsed));
      } else if (mathDetected.type === 'code') {
        canGraph = false;
        showSteps = false;
        // Re-label the single visible item to "Run" for clarity.
        if (simpleBtn) {
          simpleBtn.innerHTML = '<b>Run</b><span>execute and insert stdout / stderr</span>';
        }
      } else {
        // Restore default Σ Solve label when switching back from a code block.
        if (simpleBtn) {
          simpleBtn.innerHTML = '<b>Solve</b><span>append &nbsp;= &lt;value&gt; &nbsp;inline</span>';
        }
      }
      if (graphBtn) graphBtn.style.display = canGraph ? '' : 'none';
      if (stepsBtn) stepsBtn.style.display = showSteps ? '' : 'none';
    } else {
      mathWrap.style.display = 'none';
      mathSep.style.display = 'none';
    }
  }

  // Position near the selection end
  var cursor = cm.getCursor('to');
  var coords = cm.cursorCoords(cursor, 'page');
  selPopup.style.left = Math.max(8, coords.left - 120) + 'px';
  selPopup.style.top = (coords.bottom + 6) + 'px';
  selPopup.classList.add('visible');
}

function hideSelPopup() {
  if (selPopup) selPopup.classList.remove('visible');
}

function onCursorActivity(cm) {
  clearTimeout(selPopupDebounce);
  selPopupDebounce = setTimeout(function() {
    if (aiBusy) { hideSelPopup(); return; }
    var sel = cm.getSelection();
    if (sel && sel.trim().length > 2) {
      showSelPopup(cm);
    } else {
      hideSelPopup();
    }
  }, 300);
}

// Wire up after editor is ready
function wireSelPopup() {
  var cm = window.editorInstance;
  if (!cm) { setTimeout(wireSelPopup, 200); return; }
  cm.on('cursorActivity', onCursorActivity);
}
wireSelPopup();

// Hide on outside click
document.addEventListener('mousedown', function(e) {
  if (selPopup && selPopup.classList.contains('visible') && !selPopup.contains(e.target)) {
    hideSelPopup();
  }
});

// ══════════════════════════════════════════════════════════════
// VOICE TO LATEX — mic → transcribe → AI convert → insert
// ══════════════════════════════════════════════════════════════

function initVoiceToLatex() {
  if (typeof SpeechToText === 'undefined') return;

  var ctx = (typeof CONFIG !== 'undefined' && CONFIG.ctx) ? CONFIG.ctx : '';
  SpeechToText.init({
    buttonId: 'btn-voice',
    aiUrl: ctx + '/ai',
    onResult: function(text) {
      // Insert transcribed text directly at cursor
      if (!window.editorInstance) return;
      var cm = window.editorInstance;
      cm.replaceRange(text, cm.getCursor());
      cm.focus();
      if (typeof window.showSuccessToast === 'function') window.showSuccessToast('Voice input inserted');
    },
    onError: function(msg) {
      if (typeof window.showErrorToast === 'function') window.showErrorToast(msg);
    }
  });
}

initVoiceToLatex();

// Expose globally (inline flows + compile error widgets)
window.fixError = fixError;
window.rewriteSelection = rewriteSelection;
window.cancelAI = cancelAI;
window.ensureLatexAiAccess = ensureAiAccess;

})();
