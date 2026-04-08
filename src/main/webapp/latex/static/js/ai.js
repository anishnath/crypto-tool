(function() {
'use strict';

var AI_URL = CONFIG.ctx + '/ai';
var aiAbortController = null;

// ── LaTeX-specific system prompts (client-side, not in servlet) ──

var SYSTEM_FIX_ERROR =
    'You are a LaTeX expert. Given a LaTeX compilation error and the surrounding source code, '
  + 'return ONLY the corrected LaTeX code for the affected lines. '
  + 'Do not include markdown fences, explanations, or commentary. '
  + 'Preserve all surrounding code exactly. Only fix the error.';

var SYSTEM_NL_TO_LATEX =
    'Convert the user\'s natural language description into LaTeX code. '
  + 'Return ONLY valid LaTeX code. No markdown fences, no explanation, no commentary. '
  + 'If the description implies math, wrap in appropriate math environment. '
  + 'If it implies a structure (table, figure, list), use the correct LaTeX environment.';

var SYSTEM_REWRITE =
    'Rewrite the following LaTeX text. Keep ALL LaTeX commands, environments, labels, '
  + 'and references exactly as-is. Only change the natural language content. '
  + 'Return ONLY the rewritten LaTeX. No markdown fences, no explanation.';

var REWRITE_STYLES = {
  formal: ' Rewrite in formal academic English.',
  concise: ' Make the text more concise and direct.',
  expand: ' Expand the text with more detail and explanation.'
};

// Build Ollama-compatible payload with system + user messages
function buildPayload(systemPrompt, userContent, stream) {
  return {
    messages: [
      { role: 'system', content: systemPrompt },
      { role: 'user', content: userContent }
    ],
    stream: !!stream
  };
}

// ══════════════════════════════════════════════════════════════
// NDJSON STREAMING READER
// Reads fetch response body as NDJSON, calls onToken for each
// content delta, onDone when stream ends.
// ══════════════════════════════════════════════════════════════

function streamAI(payload, callbacks) {
  if (aiAbortController) aiAbortController.abort();
  aiAbortController = new AbortController();

  var onToken  = callbacks.onToken  || function() {};
  var onDone   = callbacks.onDone   || function() {};
  var onError  = callbacks.onError  || function() {};

  fetch(AI_URL, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
    signal: aiAbortController.signal
  })
  .then(function(res) {
    if (!res.ok) {
      return res.json().then(function(data) {
        throw new Error(data.error || 'AI request failed (' + res.status + ')');
      });
    }
    return readNDJSON(res.body, onToken);
  })
  .then(function() {
    onDone();
  })
  .catch(function(err) {
    if (err.name === 'AbortError') return;
    onError(err.message || 'AI request failed');
  });
}

function readNDJSON(body, onToken) {
  var reader = body.getReader();
  var decoder = new TextDecoder();
  var buffer = '';

  function processChunk(result) {
    if (result.done) return;

    buffer += decoder.decode(result.value, { stream: true });
    var lines = buffer.split('\n');
    buffer = lines.pop(); // keep incomplete last line in buffer

    for (var i = 0; i < lines.length; i++) {
      var line = lines[i].trim();
      if (!line) continue;
      try {
        var obj = JSON.parse(line);
        if (obj.message && obj.message.content) {
          onToken(obj.message.content);
        }
        if (obj.done === true) return;
      } catch (e) {
        // skip malformed lines
      }
    }

    return reader.read().then(processChunk);
  }

  return reader.read().then(processChunk);
}

// ══════════════════════════════════════════════════════════════
// NON-STREAMING REQUEST
// ══════════════════════════════════════════════════════════════

function requestAI(payload, callback) {
  if (aiAbortController) aiAbortController.abort();
  aiAbortController = new AbortController();

  payload.stream = false;

  fetch(AI_URL, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
    signal: aiAbortController.signal
  })
  .then(function(res) {
    if (!res.ok) {
      return res.json().then(function(data) {
        throw new Error(data.error || 'AI request failed (' + res.status + ')');
      });
    }
    return res.json();
  })
  .then(function(data) {
    var content = '';
    if (data.message && data.message.content) {
      content = data.message.content;
    }
    callback(null, content);
  })
  .catch(function(err) {
    callback(err.message || 'AI request failed', null);
  });
}

// ══════════════════════════════════════════════════════════════
// FIX ERROR — non-streaming, replaces broken code
// ══════════════════════════════════════════════════════════════

function fixError(errorMsg, lineNum) {
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
// NL → LATEX — streaming, inserts at cursor
// ══════════════════════════════════════════════════════════════

function nlToLatex(description) {
  if (!window.editorInstance || !description || !description.trim()) return;
  var cm = window.editorInstance;
  var insertPos = cm.getCursor();

  // Track where we're inserting so streaming tokens append correctly
  var currentPos = { line: insertPos.line, ch: insertPos.ch };

  showAIIndicator(true);

  streamAI(buildPayload(SYSTEM_NL_TO_LATEX, description, true), {
    onToken: function(token) {
      cm.replaceRange(token, currentPos);
      // Advance position by the inserted text
      var lines = token.split('\n');
      if (lines.length === 1) {
        currentPos = { line: currentPos.line, ch: currentPos.ch + token.length };
      } else {
        currentPos = {
          line: currentPos.line + lines.length - 1,
          ch: lines[lines.length - 1].length
        };
      }
    },
    onDone: function() {
      showAIIndicator(false);
      cm.focus();
      if (typeof window.showSuccessToast === 'function') window.showSuccessToast('LaTeX inserted');
    },
    onError: function(err) {
      showAIIndicator(false);
      if (typeof window.showErrorToast === 'function') window.showErrorToast('AI error: ' + err);
    }
  });
}

// ══════════════════════════════════════════════════════════════
// REWRITE SELECTION — streaming, replaces selection
// ══════════════════════════════════════════════════════════════

function rewriteSelection(style) {
  if (!window.editorInstance) return;
  var cm = window.editorInstance;
  var selection = cm.getSelection();

  if (!selection || !selection.trim()) {
    if (typeof window.showWarningToast === 'function') window.showWarningToast('Select text to rewrite');
    return;
  }

  var from = cm.getCursor('from');
  var to = cm.getCursor('to');

  // Delete selected text first, then stream replacement
  cm.replaceRange('', from, to);
  var currentPos = { line: from.line, ch: from.ch };

  showAIIndicator(true);

  var rewriteSystem = SYSTEM_REWRITE + (REWRITE_STYLES[style] || REWRITE_STYLES.formal);
  streamAI(buildPayload(rewriteSystem, selection, true), {
    onToken: function(token) {
      cm.replaceRange(token, currentPos);
      var lines = token.split('\n');
      if (lines.length === 1) {
        currentPos = { line: currentPos.line, ch: currentPos.ch + token.length };
      } else {
        currentPos = {
          line: currentPos.line + lines.length - 1,
          ch: lines[lines.length - 1].length
        };
      }
    },
    onDone: function() {
      showAIIndicator(false);
      cm.focus();
      if (typeof window.showSuccessToast === 'function') window.showSuccessToast('Rewrite applied');
    },
    onError: function(err) {
      showAIIndicator(false);
      if (typeof window.showErrorToast === 'function') window.showErrorToast('AI error: ' + err);
    }
  });
}

// ══════════════════════════════════════════════════════════════
// CANCEL
// ══════════════════════════════════════════════════════════════

function cancelAI() {
  if (aiAbortController) {
    aiAbortController.abort();
    aiAbortController = null;
  }
  showAIIndicator(false);
}

// ══════════════════════════════════════════════════════════════
// AI PROMPT POPUP — floating input for NL→LaTeX
// ══════════════════════════════════════════════════════════════

var aiPromptVisible = false;

function toggleAIPrompt() {
  var popup = document.getElementById('ai-prompt-popup');
  if (!popup) return;

  aiPromptVisible = !aiPromptVisible;
  if (aiPromptVisible) {
    popup.classList.add('visible');
    var input = document.getElementById('ai-prompt-input');
    if (input) {
      input.value = '';
      input.focus();
    }
  } else {
    popup.classList.remove('visible');
    if (window.editorInstance) window.editorInstance.focus();
  }
}

function submitAIPrompt() {
  var input = document.getElementById('ai-prompt-input');
  if (!input) return;
  var text = input.value.trim();
  if (!text) return;

  toggleAIPrompt(); // close popup
  nlToLatex(text);
}

function handleAIPromptKey(e) {
  if (e.key === 'Enter' && !e.shiftKey) {
    e.preventDefault();
    submitAIPrompt();
  } else if (e.key === 'Escape') {
    toggleAIPrompt();
  }
}

// ══════════════════════════════════════════════════════════════
// REWRITE MENU
// ══════════════════════════════════════════════════════════════

function showRewriteMenu() {
  var cm = window.editorInstance;
  if (!cm) return;

  var selection = cm.getSelection();
  if (!selection || !selection.trim()) {
    if (typeof window.showWarningToast === 'function') window.showWarningToast('Select text to rewrite');
    return;
  }

  var menu = document.getElementById('ai-rewrite-menu');
  if (!menu) return;

  menu.classList.toggle('visible');
}

// ══════════════════════════════════════════════════════════════
// AI INDICATOR (status bar)
// ══════════════════════════════════════════════════════════════

function showAIIndicator(show) {
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

// Close AI prompt on outside click
document.addEventListener('click', function(e) {
  var popup = document.getElementById('ai-prompt-popup');
  if (popup && popup.classList.contains('visible')) {
    if (!popup.contains(e.target) && !e.target.closest('#btn-ai-prompt')) {
      aiPromptVisible = false;
      popup.classList.remove('visible');
    }
  }
  var menu = document.getElementById('ai-rewrite-menu');
  if (menu && menu.classList.contains('visible')) {
    if (!menu.contains(e.target) && !e.target.closest('#btn-ai-rewrite')) {
      menu.classList.remove('visible');
    }
  }
});

// Keyboard shortcuts
document.addEventListener('keydown', function(e) {
  // Ctrl+Shift+A to toggle AI prompt
  if ((e.ctrlKey || e.metaKey) && e.shiftKey && e.key === 'A') {
    e.preventDefault();
    toggleAIPrompt();
    return;
  }
  // Escape to cancel in-progress AI generation
  if (e.key === 'Escape' && aiAbortController) {
    cancelAI();
  }
});

// Expose globally
window.fixError = fixError;
window.nlToLatex = nlToLatex;
window.rewriteSelection = rewriteSelection;
window.cancelAI = cancelAI;
window.toggleAIPrompt = toggleAIPrompt;
window.submitAIPrompt = submitAIPrompt;
window.handleAIPromptKey = handleAIPromptKey;
window.showRewriteMenu = showRewriteMenu;

})();
