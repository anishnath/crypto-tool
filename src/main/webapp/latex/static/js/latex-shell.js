/**
 * LaTeX editor shell API for VibeCodingAssistant (latex/editor.jsp).
 */
(function () {
  'use strict';

  function getCm() {
    return window.editorInstance || null;
  }

  function getActiveFile() {
    var tab = document.querySelector('.editor-tab.active');
    if (!tab) return 'main.tex';
    return tab.getAttribute('data-file') || tab.textContent.trim() || 'main.tex';
  }

  function getCompileLog() {
    var el = document.getElementById('log-output');
    return el ? (el.textContent || '').trim() : '';
  }

  function hasCompileErrors() {
    var badge = document.getElementById('log-error-badge');
    if (badge && badge.style.display !== 'none') return true;
    var count = document.getElementById('error-count');
    if (count && count.style.display !== 'none') return true;
    var log = getCompileLog();
    return /(^|\n)!/.test(log) || /LaTeX Error/i.test(log);
  }

  window.latexShell = {
    syncEditor: function () { /* CodeMirror is live; no file buffer sync needed */ },

    getSnapshot: function () {
      var cm = getCm();
      var selection = '';
      if (cm) {
        selection = cm.getSelection().trim();
      }
      return {
        activeFile: getActiveFile(),
        engine: 'pdfLaTeX',
        code: cm ? cm.getValue() : '',
        selection: selection,
        compileLog: getCompileLog(),
        hasCompileErrors: hasCompileErrors(),
      };
    },

    applyLatex: function (content, opts) {
      var cm = getCm();
      if (!cm) return { applied: false, error: 'Editor not ready' };

      var code = String(content || '').trim();
      if (!code) return { applied: false, error: 'Empty LaTeX' };

      var mode = (opts && opts.mode) || 'auto';
      if (mode === 'replace-document') {
        cm.setValue(code);
      } else if (mode === 'replace-selection') {
        cm.replaceSelection(code);
      } else if (mode === 'insert-cursor') {
        cm.replaceRange(code, cm.getCursor());
      } else {
        var sel = cm.getSelection();
        if (sel && sel.trim()) cm.replaceSelection(code);
        else cm.replaceRange(code, cm.getCursor());
      }
      cm.focus();
      return { applied: true, mode: mode };
    },
  };
}());
