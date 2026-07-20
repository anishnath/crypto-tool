/*
 * manic-editor.js — Monaco editor wired to the `manic-lang` WASM.
 *
 * Ports the throwaway prototype (manic/web/index.html) onto a real Monaco
 * editor: catalog-driven semantic highlighting, live diagnostics with one-click
 * fixes, and context-aware autocomplete — all from the WASM services
 * (tokenize / check / complete), so the editor never drifts from what the
 * renderer accepts.
 *
 * Loading model: Monaco is pulled from cdnjs via its AMD loader (a classic
 * <script> in index.jsp defines window.require); the WASM is a dynamic import.
 * Because only one file/model is visible at a time, we keep a single
 * "active model" token cache that the TokensProvider reads.
 *
 * Exposes window.ManicEditor:
 *   await ManicEditor.boot()                → loads Monaco + WASM, registers 'manic'
 *   ManicEditor.monaco                      → the monaco namespace (after boot)
 *   ManicEditor.setActiveModel(model)       → recompute highlight + markers for it
 *   ManicEditor.onModelChanged(model)       → call from onDidChangeContent
 *   ManicEditor.THEME_DARK / THEME_LIGHT    → theme ids
 */
window.ManicEditor = (function () {
  'use strict';

  var cfg = window.MANIC || {};
  var MONACO_BASE = cfg.monacoBase ||
    'https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.45.0/min/vs';
  var WASM_URL = cfg.wasmUrl; // absolute URL to manic_lang.js (set by index.jsp)

  var THEME_DARK = 'manic-dark';
  var THEME_LIGHT = 'manic-light';

  var monaco = null;
  var wasm = null;

  // Highlight cache for the currently-active model: { lineNumber -> [{startIndex, type}] }.
  var activeCache = {};
  var activeModel = null;
  // Per-model quick-fix data captured on each check(): model -> [{start,len,replacement,label}].
  var modelFixes = new WeakMap();
  var markerTimers = new WeakMap();
  // Called after every check() with (model, errorCount, firstErr) — used to gate Render.
  var diagListener = null;

  // WASM token kind -> Monaco token type (themed below).
  var KIND = {
    builtin: 'builtin', call: 'builtin', keyword: 'keyword', constant: 'constant',
    color: 'color', ease: 'ease', number: 'number', string: 'string',
    variable: 'variable', comment: 'comment'
  };

  /* ── load Monaco (AMD) ─────────────────────────────────────────── */

  function loadMonaco() {
    return new Promise(function (resolve, reject) {
      if (window.monaco && window.monaco.editor) { resolve(window.monaco); return; }
      if (!window.require) { reject(new Error('Monaco AMD loader (loader.min.js) not present')); return; }
      window.require.config({ paths: { vs: MONACO_BASE } });
      window.require(['vs/editor/editor.main'], function () { resolve(window.monaco); });
    });
  }

  /* ── boot ──────────────────────────────────────────────────────── */

  async function boot() {
    monaco = await loadMonaco();
    wasm = await import(WASM_URL);
    await wasm.default(); // instantiate the .wasm (located next to manic_lang.js)
    registerLanguage();
    defineThemes();
    return { monaco: monaco, wasm: wasm };
  }

  /* ── language registration ─────────────────────────────────────── */

  function registerLanguage() {
    monaco.languages.register({ id: 'manic', extensions: ['.manic'], aliases: ['manic', 'Manic'] });

    // Editor niceties (comments/brackets) — highlighting comes from the WASM.
    monaco.languages.setLanguageConfiguration('manic', {
      comments: { lineComment: '//' },
      brackets: [['{', '}'], ['[', ']'], ['(', ')']],
      autoClosingPairs: [
        { open: '{', close: '}' }, { open: '[', close: ']' },
        { open: '(', close: ')' }, { open: '"', close: '"' }
      ],
      surroundingPairs: [
        { open: '{', close: '}' }, { open: '[', close: ']' },
        { open: '(', close: ')' }, { open: '"', close: '"' }
      ]
    });

    // Semantic highlighting via a whole-source tokenizer served per line.
    monaco.languages.setTokensProvider('manic', {
      getInitialState: function () { return new LineState(0); },
      tokenize: function (line, state) {
        var ln = state.line + 1; // 1-based
        var cached = activeCache[ln] || [];
        var tokens = cached.map(function (t) { return { startIndex: t.startIndex, scopes: t.type }; });
        return { tokens: tokens, endState: new LineState(state.line + 1) };
      }
    });

    monaco.languages.registerCompletionItemProvider('manic', {
      triggerCharacters: ['(', ',', ' ', '.', '"'],
      provideCompletionItems: provideCompletions
    });

    monaco.languages.registerCodeActionProvider('manic', {
      provideCodeActions: provideCodeActions
    });
  }

  function LineState(line) { this.line = line; }
  LineState.prototype.clone = function () { return new LineState(this.line); };
  LineState.prototype.equals = function (o) { return !!o && o.line === this.line; };

  function defineThemes() {
    var rules = [
      { token: 'builtin', foreground: '00E6FF' },
      { token: 'keyword', foreground: 'FF2D95' },
      { token: 'constant', foreground: 'FFD166' },
      { token: 'color', foreground: '7CFF6B' },
      { token: 'ease', foreground: '7CFF6B' },
      { token: 'number', foreground: '9BE7FF' },
      { token: 'string', foreground: 'FFD166' },
      { token: 'variable', foreground: 'E0E1F3' },
      { token: 'comment', foreground: '6B6890', fontStyle: 'italic' }
    ];
    monaco.editor.defineTheme(THEME_DARK, {
      base: 'vs-dark', inherit: true, rules: rules,
      colors: { 'editor.background': '#0d0b1a', 'editorLineNumber.foreground': '#3a3358' }
    });
    var lightRules = [
      { token: 'builtin', foreground: '0891b2' },
      { token: 'keyword', foreground: 'be1873' },
      { token: 'constant', foreground: 'b45309' },
      { token: 'color', foreground: '15803d' },
      { token: 'ease', foreground: '15803d' },
      { token: 'number', foreground: '1d4ed8' },
      { token: 'string', foreground: 'b45309' },
      { token: 'variable', foreground: '1f2937' },
      { token: 'comment', foreground: '6b7280', fontStyle: 'italic' }
    ];
    monaco.editor.defineTheme(THEME_LIGHT, {
      base: 'vs', inherit: true, rules: lightRules, colors: {}
    });
  }

  /* ── highlight cache (whole-source tokenize → per line) ────────── */

  function computeLineTokens(text) {
    var perLine = {};
    if (!text) return perLine;
    var toks;
    try { toks = JSON.parse(wasm.tokenize(text)); } catch (e) { return perLine; }
    toks.sort(function (a, b) { return a.start - b.start; });

    // line start offsets for offset→(line,col) mapping
    var lineStarts = [0];
    for (var i = 0; i < text.length; i++) if (text.charCodeAt(i) === 10) lineStarts.push(i + 1);

    for (var j = 0; j < toks.length; j++) {
      var t = toks[j];
      var ln = lineIndexOf(lineStarts, t.start); // 0-based
      var col = t.start - lineStarts[ln];
      var type = KIND[t.kind] || 'variable';
      (perLine[ln + 1] = perLine[ln + 1] || []).push({ startIndex: col, type: type });
    }
    return perLine;
  }

  // last lineStart index <= off (binary search)
  function lineIndexOf(lineStarts, off) {
    var lo = 0, hi = lineStarts.length - 1, ans = 0;
    while (lo <= hi) {
      var mid = (lo + hi) >> 1;
      if (lineStarts[mid] <= off) { ans = mid; lo = mid + 1; } else { hi = mid - 1; }
    }
    return ans;
  }

  // Call BEFORE editor.setModel(model): populates the token cache so Monaco's
  // first tokenization of the model reads the correct tokens. (Re-shown models
  // keep Monaco's own valid per-line cache, so no forced re-tokenize is needed.)
  function setActiveModel(model) {
    activeModel = model;
    activeCache = computeLineTokens(model.getValue());
    refreshMarkers(model, true);
  }

  function onModelChanged(model) {
    if (model === activeModel) activeCache = computeLineTokens(model.getValue());
    // debounce diagnostics — cheaper than per-keystroke
    var prev = markerTimers.get(model);
    if (prev) clearTimeout(prev);
    markerTimers.set(model, setTimeout(function () { refreshMarkers(model, false); }, 220));
  }

  /* ── diagnostics + quick fixes ─────────────────────────────────── */

  function refreshMarkers(model, immediate) {
    if (!model || model.isDisposed()) return;
    var errs;
    try { errs = JSON.parse(wasm.check(model.getValue())); } catch (e) { errs = []; }
    var markers = [];
    var fixes = [];
    var errorCount = 0, firstErr = null;
    for (var i = 0; i < errs.length; i++) {
      var e = errs[i];
      var isWarn = e.severity === 'warning';
      var start = model.getPositionAt(e.start);
      var end = model.getPositionAt(e.start + (e.len || 0));
      markers.push({
        severity: isWarn ? monaco.MarkerSeverity.Warning : monaco.MarkerSeverity.Error,
        message: e.message || 'problem',
        startLineNumber: start.lineNumber, startColumn: start.column,
        endLineNumber: end.lineNumber, endColumn: end.column
      });
      if (!isWarn) {
        errorCount++;
        if (!firstErr) firstErr = { message: e.message || 'problem', line: start.lineNumber };
      }
      if (e.fix) fixes.push(e.fix);
    }
    monaco.editor.setModelMarkers(model, 'manic', markers);
    modelFixes.set(model, fixes);
    // push error state straight to whoever's gating the Render button
    if (typeof diagListener === 'function') {
      try { diagListener(model, errorCount, firstErr); } catch (e2) {}
    }
  }

  function provideCodeActions(model, range, context) {
    var fixes = modelFixes.get(model) || [];
    var actions = [];
    for (var i = 0; i < fixes.length; i++) {
      var f = fixes[i];
      var s = model.getPositionAt(f.start);
      var e = model.getPositionAt(f.start + (f.len || 0));
      actions.push({
        title: f.label || 'Fix',
        kind: 'quickfix',
        edit: {
          edits: [{
            resource: model.uri,
            textEdit: {
              range: {
                startLineNumber: s.lineNumber, startColumn: s.column,
                endLineNumber: e.lineNumber, endColumn: e.column
              },
              text: f.replacement != null ? f.replacement : ''
            },
            versionId: model.getVersionId()
          }]
        }
      });
    }
    // "Fix all" — only compute (multi-pass, up to 40 checks) when there's at
    // least one fixable problem, so clean files pay nothing. Includes removals,
    // since a code action is an explicit user request; replaces the whole doc.
    if (fixes.length) {
      var apply = (typeof ManicAutofix !== 'undefined') && ManicAutofix.applyFixes;
      if (apply) {
        var src = model.getValue();
        var res = apply(src, function (code) {
          try { return JSON.parse(wasm.check(code)); } catch (e) { return []; }
        }, { includeRemovals: true });
        if (res.fixed > 0 && res.code !== src) {
          var full = model.getFullModelRange();
          actions.push({
            title: 'Fix all auto-fixable problems (' + res.fixed + ')',
            kind: 'source.fixAll',
            edit: { edits: [{
              resource: model.uri,
              textEdit: {
                range: {
                  startLineNumber: full.startLineNumber, startColumn: full.startColumn,
                  endLineNumber: full.endLineNumber, endColumn: full.endColumn
                },
                text: res.code
              },
              versionId: model.getVersionId()
            }] }
          });
        }
      }
    }
    return { actions: actions, dispose: function () {} };
  }

  /* ── auto-correct ──────────────────────────────────────────────── */
  // Clean up an AI response before it lands in the editor: apply the checker's
  // MECHANICAL fixes (glued vars → `*`, unknown builtin/colour → nearest name).
  // The apply-loop lives in manic-autofix.js (shared + unit-tested); here we just
  // feed it the WASM check. Returns { code, fixed }.
  function autofix(src, opts) {
    var apply = (typeof ManicAutofix !== 'undefined') && ManicAutofix.applyFixes;
    if (!apply) return { code: String(src == null ? '' : src), fixed: 0 };
    return apply(src, function (code) {
      try { return JSON.parse(wasm.check(code)); } catch (e) { return []; }
    }, opts);
  }

  function errorCount(code) {
    try {
      return (JSON.parse(wasm.check(code)) || [])
        .filter(function (e) { return e.severity !== 'warning'; }).length;
    } catch (e) { return 0; }
  }

  // User-triggered "Auto-fix" on the active model. Unlike the silent post-AI pass,
  // this INCLUDES destructive fixes (stray-token removal) and applies the result
  // as an undoable edit (Ctrl/Cmd+Z reverts it). Returns { fixed, remaining }.
  function autofixActive() {
    var model = activeModel;
    if (!model || model.isDisposed()) return { fixed: 0, remaining: 0 };
    var src = model.getValue();
    var res = autofix(src, { includeRemovals: true });
    if (res.code !== src) {
      // pushEditOperations lands on the undo stack (unlike setValue, which resets it)
      model.pushEditOperations([], [{ range: model.getFullModelRange(), text: res.code }],
        function () { return null; });
    }
    refreshMarkers(model, true);
    return { fixed: res.fixed, remaining: errorCount(res.code) };
  }

  /* ── autocomplete ──────────────────────────────────────────────── */

  var COMPLETION_KIND = null;
  function completionKind(k) {
    if (!COMPLETION_KIND) {
      var K = monaco.languages.CompletionItemKind;
      COMPLETION_KIND = {
        builtin: K.Function, call: K.Function, keyword: K.Keyword,
        color: K.Color, ease: K.Value, constant: K.Constant,
        variable: K.Variable, id: K.Variable, preset: K.Enum, snippet: K.Snippet
      };
    }
    return COMPLETION_KIND[k] != null ? COMPLETION_KIND[k] : monaco.languages.CompletionItemKind.Text;
  }

  function provideCompletions(model, position) {
    var offset = model.getOffsetAt(position);
    var items;
    try { items = JSON.parse(wasm.complete(model.getValue(), offset)); } catch (e) { items = []; }
    var word = model.getWordUntilPosition(position);
    var range = {
      startLineNumber: position.lineNumber, endLineNumber: position.lineNumber,
      startColumn: word.startColumn, endColumn: word.endColumn
    };
    var suggestions = items.map(function (c) {
      return {
        label: c.label,
        kind: completionKind(c.kind),
        insertText: c.insert != null ? c.insert : c.label,
        detail: c.detail || '',
        documentation: c.doc || '',
        range: range
      };
    });
    return { suggestions: suggestions };
  }

  return {
    boot: boot,
    get monaco() { return monaco; },
    get wasm() { return wasm; },
    setActiveModel: setActiveModel,
    onModelChanged: onModelChanged,
    refreshMarkers: refreshMarkers,
    autofix: autofix,
    autofixActive: autofixActive,
    setDiagnosticsListener: function (fn) { diagListener = fn; },
    THEME_DARK: THEME_DARK,
    THEME_LIGHT: THEME_LIGHT
  };
})();
