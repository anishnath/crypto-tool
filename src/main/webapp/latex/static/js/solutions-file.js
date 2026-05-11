// One file per generated entry — "maximum modularity" mode.
//
// Each click of Σ Solve / Render produces a fresh `solution-NNN.tex`,
// uploaded to the project and added to the file tree. The main document
// accumulates one `\input{solution-NNN}` line per action, stacked just
// above `\end{document}`. The user can reorder by dragging the `\input{}`
// lines, delete an entry by removing both the line and its file, or edit
// individual entries by clicking the file in the tree.
(function () {
  'use strict';

  // Bump this string whenever the per-file logic changes — lets you
  // verify in the console which version of solutions-file.js is loaded.
  var VERSION = 'v2-per-file-2026-05-11';
  console.log('[SolutionsFile] loaded', VERSION);

  var FILE_RE = /^solution-(\d+)\.tex$/i;

  function pad3(n) {
    if (n < 10) return '00' + n;
    if (n < 100) return '0' + n;
    return String(n);
  }

  // Walk window.fileContents (and the DOM file tree as a backstop) to find
  // the next available sequence number. Survives page reloads via project
  // save/restore — when a project is reloaded, fileContents is repopulated
  // and we resume from the highest seen number + 1.
  function nextSequenceNumber() {
    var max = 0;
    if (window.fileContents) {
      for (var name in window.fileContents) {
        if (!window.fileContents.hasOwnProperty(name)) continue;
        var m = name.match(FILE_RE);
        if (m) {
          var n = parseInt(m[1], 10);
          if (n > max) max = n;
        }
      }
    }
    // Also probe the DOM file tree (defensive — covers any path that
    // adds a file without going through fileContents)
    var items = document.querySelectorAll('.file-item[data-file]');
    for (var i = 0; i < items.length; i++) {
      var dm = (items[i].getAttribute('data-file') || '').match(FILE_RE);
      if (dm) {
        var dn = parseInt(dm[1], 10);
        if (dn > max) max = dn;
      }
    }
    return max + 1;
  }

  // Place a fresh `\input{<basename>}` line in the main editor.
  // Strategy:
  //   1. If anchor (caller's selection end) given → insert immediately after
  //      that line. Each entry's `\input{}` ends up right below the equation
  //      it was generated from — reads naturally top-to-bottom.
  //   2. Else fall back to just-before `\end{document}` (stacked at end).
  function appendInputDirective(cm, basename, anchor) {
    if (!cm) return;
    var directive = '\\input{' + basename + '}';

    if (anchor && typeof anchor.line === 'number') {
      var line = anchor.line;
      if (line < 0) line = 0;
      if (line >= cm.lineCount()) line = cm.lineCount() - 1;
      var lineEnd = { line: line, ch: cm.getLine(line).length };
      cm.replaceRange('\n' + directive + '\n', lineEnd, lineEnd);
      return;
    }

    // Fallback: before the last `\end{document}` on its own line
    for (var i = cm.lineCount() - 1; i >= 0; i--) {
      if (/^\s*\\end\{document\}\s*$/.test(cm.getLine(i))) {
        cm.replaceRange(directive + '\n', { line: i, ch: 0 });
        return;
      }
    }
    // Absolute fallback: very end of doc
    var lastLine = cm.lineCount() - 1;
    cm.replaceRange('\n' + directive + '\n',
      { line: lastLine, ch: cm.getLine(lastLine).length });
  }

  // Public API. Signatures:
  //   append(cm, content)                — \input{} placed at end of doc
  //   append(cm, content, { inputAnchor: pos })
  //                                       — \input{} placed right after the
  //                                         line containing pos.line (where
  //                                         the user's selection ended)
  // Returns the new filename so callers can inform the user.
  function append(cm, content, opts) {
    if (!cm || !content) return null;
    opts = opts || {};
    var seq = nextSequenceNumber();
    var basename = 'solution-' + pad3(seq);
    var filename = basename + '.tex';
    console.log('[SolutionsFile] creating', filename, '(seq=' + seq + ')',
                opts.inputAnchor ? '@line ' + opts.inputAnchor.line : '@end');

    // Standalone file — no shared header. Trim leading blank lines so the
    // file starts with the actual content.
    var body = String(content).replace(/^\n+/, '');
    if (!/\n$/.test(body)) body += '\n';

    if (!window.fileContents) window.fileContents = {};
    window.fileContents[filename] = body;

    if (typeof window.addFileToTree === 'function') {
      window.addFileToTree(filename, false, body);
    }
    if (typeof window.reuploadFile === 'function') {
      try { window.reuploadFile(filename, body); } catch (e) {}
    }

    appendInputDirective(cm, basename, opts.inputAnchor);

    // If the user happens to be editing solutions.tex (legacy) or this
    // newly-created file, refresh the editor view
    if (window.editingFile === filename && cm.getValue() !== body) {
      cm.setValue(body);
    }
    return filename;
  }

  // ── Diagnostic + cleanup for the legacy single-file mode ─────────────────
  //
  // Earlier versions of this helper accumulated everything in a single
  // `solutions.tex` file. Projects saved during that period still carry the
  // legacy file in their `fileContents` map; reloading the project re-injects
  // it. cleanupLegacy() removes it from every place it might persist.

  function cleanupLegacy(cm) {
    var removed = [];
    // 1. Remove from in-memory fileContents (the localStorage source-of-truth)
    if (window.fileContents && window.fileContents['solutions.tex'] != null) {
      delete window.fileContents['solutions.tex'];
      removed.push('window.fileContents[solutions.tex]');
    }
    // 2. Remove from the file-tree DOM
    var el = document.querySelector('.file-item[data-file="solutions.tex"]');
    if (el && el.parentNode) {
      el.parentNode.removeChild(el);
      removed.push('file-tree row');
    }
    // 3. Remove from the uploadedFiles registry (used for re-upload on compile)
    if (window.uploadedFiles && window.uploadedFiles.length) {
      for (var i = window.uploadedFiles.length - 1; i >= 0; i--) {
        if (window.uploadedFiles[i].filename === 'solutions.tex') {
          window.uploadedFiles.splice(i, 1);
          removed.push('uploadedFiles entry');
        }
      }
    }
    // 4. Remove the `\input{solutions}` line from the main editor
    var editor = cm || window.editorInstance;
    if (editor && typeof editor.getValue === 'function') {
      var src = editor.getValue();
      var newSrc = src.replace(/^\s*\\input\{solutions(?:\.tex)?\}\s*\n?/gm, '');
      if (newSrc !== src) {
        editor.setValue(newSrc);
        removed.push('\\input{solutions} from main editor');
      }
    }
    // 5. Trigger a project re-save so localStorage forgets it too
    if (typeof window.saveCurrentProject === 'function') {
      try { window.saveCurrentProject(); removed.push('localStorage (via saveCurrentProject)'); } catch (e) {}
    }
    console.log('[SolutionsFile] cleanupLegacy removed:', removed);
    return removed;
  }

  // Diagnostic — runs once when the module loads. Flags any legacy file.
  function diagnose() {
    var has = window.fileContents && window.fileContents['solutions.tex'] != null;
    if (has) {
      console.warn(
        '[SolutionsFile] Legacy solutions.tex detected in this project.\n' +
        '  Length: ' + (window.fileContents['solutions.tex'].length) + ' bytes\n' +
        '  To remove it, run in console:  SolutionsFile.cleanupLegacy()\n' +
        '  (Or right-click the file in the tree → Delete, and remove the' +
        ' \\input{solutions} line from your main file.)');
    } else {
      console.log('[SolutionsFile] No legacy solutions.tex found. New solves create solution-NNN.tex.');
    }
  }
  // Defer diagnose() so it runs after editor + project load complete
  if (typeof window !== 'undefined') {
    if (document.readyState === 'complete' || document.readyState === 'interactive') {
      setTimeout(diagnose, 500);
    } else {
      window.addEventListener('DOMContentLoaded', function () { setTimeout(diagnose, 500); });
    }
  }

  window.SolutionsFile = {
    VERSION: VERSION,
    append: append,
    nextSequenceNumber: nextSequenceNumber,
    pad3: pad3,
    cleanupLegacy: cleanupLegacy,
    diagnose: diagnose
  };
})();
