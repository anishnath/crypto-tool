// code-runner-core.js — headless API for the LaTeX editor's ▶ Run.
//
// Mirrors the integral / derivative / limit / matrix cores. Exposes:
//   CodeRunnerCore.parseLatexCode(latex)
//       → { language, version, files:[{name,content}], stdin, compilerArgs,
//           startIdx, endIdx, blocks:[…] }  or  null
//   CodeRunnerCore.solveFromLatex(latex, opts)
//       → Promise<{ ok, stdout, stderr, exitCode, duration, language, files,
//                   input, error }>
//
// Backend contract — identical to the dedicated /online-X-compiler tools
// (see onecompiler.jsp line ~2754): POST /OneCompilerFunctionality?action=execute
// with { language, version?, code|files, input?, compilerArgs? } and consume
// the case-variant fields { Stdout|stdout, Stderr|stderr, ExitCode|exitCode }.
(function () {
  'use strict';

  // Canonical language id → file extension. List matches the dedicated
  // compiler tools' fileExtensions table in /onecompiler.jsp so a Java
  // run from the LaTeX editor and a Java run from /online-java-compiler
  // hit the same backend code path with the same shape.
  var LANGUAGE_EXTENSIONS = {
    'python': '.py', 'java': '.java', 'c': '.c', 'cpp': '.cpp', 'csharp': '.cs',
    'javascript': '.js', 'typescript': '.ts', 'go': '.go', 'rust': '.rs',
    'php': '.php', 'ruby': '.rb', 'swift': '.swift', 'kotlin': '.kt',
    'scala': '.scala', 'r': '.r', 'perl': '.pl', 'lua': '.lua',
    'haskell': '.hs', 'bash': '.sh', 'dart': '.dart'
  };

  // Common aliases users type → canonical id.
  var LANGUAGE_ALIASES = {
    'py': 'python', 'js': 'javascript', 'ts': 'typescript',
    'rb': 'ruby', 'sh': 'bash', 'shell': 'bash', 'zsh': 'bash',
    'c++': 'cpp', 'cxx': 'cpp', 'cs': 'csharp', 'c#': 'csharp',
    'kt': 'kotlin', 'rs': 'rust', 'hs': 'haskell', 'pl': 'perl',
    'node': 'javascript', 'nodejs': 'javascript'
  };

  // Human label for the popup ("Run Java" beats "Run java").
  var LANGUAGE_LABELS = {
    'python': 'Python', 'java': 'Java', 'c': 'C', 'cpp': 'C++',
    'csharp': 'C#', 'javascript': 'JavaScript', 'typescript': 'TypeScript',
    'go': 'Go', 'rust': 'Rust', 'php': 'PHP', 'ruby': 'Ruby',
    'swift': 'Swift', 'kotlin': 'Kotlin', 'scala': 'Scala', 'r': 'R',
    'perl': 'Perl', 'lua': 'Lua', 'haskell': 'Haskell', 'bash': 'Bash',
    'dart': 'Dart'
  };

  function canonicalLanguage(raw) {
    if (!raw) return null;
    var k = String(raw).toLowerCase().trim();
    if (LANGUAGE_EXTENSIONS[k]) return k;
    if (LANGUAGE_ALIASES[k]) return LANGUAGE_ALIASES[k];
    return null;
  }

  function defaultFilename(language, idx) {
    var ext = LANGUAGE_EXTENSIONS[language] || '.txt';
    return (idx === 0) ? ('main' + ext) : ('file' + idx + ext);
  }

  // ── lstlisting parsing ───────────────────────────────────────────────

  // Parse the `[key=value, key2=value2, ...]` option block of an lstlisting.
  // Values may be bare tokens or `{braced}` for values containing commas.
  // Returns a plain key → value object (values are strings; trimmed).
  function parseListingOptions(optsStr) {
    var out = {};
    if (!optsStr) return out;
    var s = optsStr.trim();
    var i = 0, n = s.length;
    while (i < n) {
      // skip whitespace
      while (i < n && /\s/.test(s[i])) i++;
      if (i >= n) break;
      // key
      var keyStart = i;
      while (i < n && s[i] !== '=' && s[i] !== ',') i++;
      var key = s.substring(keyStart, i).trim();
      var val = '';
      if (s[i] === '=') {
        i++; // skip =
        while (i < n && /\s/.test(s[i])) i++;
        if (s[i] === '{') {
          // braced value — collect until matching }
          var depth = 1; i++;
          var valStart = i;
          while (i < n && depth > 0) {
            if (s[i] === '{') depth++;
            else if (s[i] === '}') { depth--; if (depth === 0) break; }
            i++;
          }
          val = s.substring(valStart, i);
          if (s[i] === '}') i++;
        } else {
          var valStart2 = i;
          while (i < n && s[i] !== ',') i++;
          val = s.substring(valStart2, i).trim();
        }
      }
      if (key) out[key.toLowerCase()] = val;
      if (s[i] === ',') i++;
    }
    return out;
  }

  // Find the next `\begin{lstlisting}[opts]...\end{lstlisting}` block at or
  // after `from`. Returns { startIdx, endIdx, opts, body, language, name }
  // or null. The closing tag must be on its own line per listings convention.
  //
  // Two option sources are merged:
  //   1. The `[…]` block on \begin{lstlisting} — only listings-recognized
  //      keys (language, name, style, …) belong here, otherwise the listings
  //      package errors out at compile time.
  //   2. An optional leading `% run: key=val, key2=val2, …` LaTeX comment
  //      on the line directly above. Use this for runtime-only options
  //      (stdin, compilerArgs, version, main) and for language= when
  //      listings doesn't ship a highlighter for that language (e.g.
  //      JavaScript, Go, Rust — runner needs it but listings can't render
  //      it). The comment value wins on key conflicts.
  var RUN_COMMENT_RE = /^[ \t]*%\s*run:\s*([^\n]*)$/m;

  // Parse the `% run: …` payload. Supports shorthand where the first segment
  // is a bare language id ("python", "javascript"), and key=val pairs after:
  //   "python"                        → { language: 'python' }
  //   "python, stdin={42}"            → { language: 'python', stdin: '42' }
  //   "language=go, compilerArgs=-O2" → { language: 'go', compilerArgs: '-O2' }
  function parseRunComment(s) {
    if (!s) return {};
    s = s.trim();
    if (!s) return {};
    var firstComma = s.indexOf(',');
    var firstEqual = s.indexOf('=');
    // If there is no `=`, or the first `,` precedes the first `=`, the
    // first segment is a bare language.
    if (firstEqual < 0 || (firstComma >= 0 && firstComma < firstEqual)) {
      var firstTok = (firstComma >= 0 ? s.substring(0, firstComma) : s).trim();
      var rest = firstComma >= 0 ? s.substring(firstComma + 1) : '';
      var out = parseListingOptions(rest);
      out.language = firstTok;
      return out;
    }
    return parseListingOptions(s);
  }

  function findNextBlock(text, from) {
    var re = /\\begin\{lstlisting\}(?:\[([^\]]*)\])?\s*\n([\s\S]*?)\n[ \t]*\\end\{lstlisting\}/g;
    re.lastIndex = from || 0;
    var m = re.exec(text);
    if (!m) return null;
    var listingOpts = parseListingOptions(m[1] || '');
    // Look up to 3 lines back for `% run: …`
    var precedingStart = Math.max(0, m.index - 400);
    var preceding = text.substring(precedingStart, m.index);
    // last `% run: ...` line before the block (allow blank lines between)
    var commentOpts = {};
    var lines = preceding.split('\n');
    for (var i = lines.length - 1; i >= 0; i--) {
      var ln = lines[i];
      if (/^\s*$/.test(ln)) continue;        // skip blank
      var cm = ln.match(/^[ \t]*%\s*run:\s*(.*)$/);
      if (cm) { commentOpts = parseRunComment(cm[1]); }
      break;  // stop at first non-blank line — must be immediately above
    }
    // Merge: comment wins over listings on conflicts
    var opts = Object.assign({}, listingOpts, commentOpts);
    var lang = canonicalLanguage(opts.language);
    return {
      startIdx: m.index,
      endIdx: re.lastIndex,
      opts: opts,
      body: m[2],
      language: lang,
      name: opts.name || null,
      rawLanguage: opts.language || null
    };
  }

  // Quick pre-filter — is there any lstlisting at all?
  function findCodeBlock(text) {
    if (!text) return null;
    var b = findNextBlock(text, 0);
    if (!b || !b.language) return null;
    return b;
  }

  // Walk forward from the first block, collecting CONSECUTIVE same-language
  // blocks separated only by blank lines / LaTeX comments. The group ends at
  // any of: (a) different language, (b) non-listing/non-comment content,
  // (c) an existing `\input{solution-...}` directive (so we don't loop over
  // a previous run's output), (d) end of text.
  function collectGroup(text, firstBlock) {
    var blocks = [firstBlock];
    var cursor = firstBlock.endIdx;
    var sepRe = /^(?:[ \t]*\n|[ \t]*%[^\n]*\n)+/;
    while (true) {
      var rest = text.slice(cursor);
      var sepMatch = rest.match(sepRe);
      var skipped = sepMatch ? sepMatch[0].length : 0;
      // Bail on an existing \input{solution-...} between blocks
      var betweenText = rest.slice(0, skipped);
      var nextStart = cursor + skipped;
      var nonSpaceAhead = rest.slice(skipped, skipped + 30);
      if (/^\s*\\input\{solution-/.test(nonSpaceAhead)) break;
      var next = findNextBlock(text, nextStart);
      if (!next) break;
      // Reject if the separator section between current end and next start
      // contains any non-comment content (e.g. a paragraph, \section, etc.)
      var sepUpToNext = text.slice(cursor, next.startIdx);
      if (!isOnlyWhitespaceAndComments(sepUpToNext)) break;
      if (next.language !== blocks[0].language) break;
      blocks.push(next);
      cursor = next.endIdx;
    }
    return blocks;
  }

  function isOnlyWhitespaceAndComments(s) {
    // Each line either entirely whitespace or starts with `%` (with optional
    // leading whitespace). LaTeX comments run to end-of-line.
    var lines = s.split('\n');
    for (var i = 0; i < lines.length; i++) {
      var ln = lines[i];
      if (/^\s*$/.test(ln)) continue;
      if (/^\s*%/.test(ln)) continue;
      return false;
    }
    return true;
  }

  // Strip outer math delimiters (no-op for code but symmetric with other cores).
  function stripDelims(s) {
    if (!s) return s;
    return s.trim()
      .replace(/^\$\$([\s\S]+)\$\$$/, '$1')
      .replace(/^\$([\s\S]+)\$$/, '$1');
  }

  // Public parse — given a user selection, find the first runnable lstlisting,
  // gather its adjacent-same-language group, and return a normalized struct.
  function parseLatexCode(rawSelection) {
    var s = stripDelims(rawSelection || '');
    if (!s) return null;
    var first = findCodeBlock(s);
    if (!first) return null;
    var group = collectGroup(s, first);

    // Build files array. Names default to main.<ext>, file1.<ext>, ...
    // and we de-duplicate to keep OneCompiler happy.
    var files = [];
    var seen = {};
    for (var i = 0; i < group.length; i++) {
      var b = group[i];
      var name = b.name || defaultFilename(group[0].language, i);
      // de-dup
      if (seen[name]) {
        var dot = name.lastIndexOf('.');
        var stem = dot >= 0 ? name.slice(0, dot) : name;
        var ext = dot >= 0 ? name.slice(dot) : '';
        var k = 2;
        while (seen[stem + k + ext]) k++;
        name = stem + k + ext;
      }
      seen[name] = true;
      files.push({ name: name, content: b.body });
    }

    // Optional run-time inputs come from the FIRST block's options.
    var opts = group[0].opts || {};
    var compilerArgs = null;
    if (opts.compilerargs) {
      compilerArgs = opts.compilerargs.split(/\s+/).filter(Boolean);
    }

    return {
      language: group[0].language,
      languageLabel: LANGUAGE_LABELS[group[0].language] || group[0].language,
      version: opts.version || null,
      stdin: opts.stdin != null ? opts.stdin : (opts.input != null ? opts.input : null),
      compilerArgs: compilerArgs,
      files: files,
      blocks: group,
      // For UI labels
      isMulti: files.length > 1,
      mainName: (opts.main || (group[0].name || defaultFilename(group[0].language, 0)))
    };
  }

  // ── Backend call ─────────────────────────────────────────────────────

  function ctxPath() {
    if (typeof window !== 'undefined' && window.CONFIG && window.CONFIG.ctx != null) return window.CONFIG.ctx;
    if (typeof window !== 'undefined' && window.__CR_CTX) return window.__CR_CTX;
    return '';
  }

  function solveFromLatex(rawSelection, opts) {
    opts = opts || {};
    var parsed = parseLatexCode(rawSelection);
    if (!parsed) {
      return Promise.resolve({ ok: false, error: 'No runnable code block found in selection' });
    }
    var body = { language: parsed.language };
    if (parsed.version) body.version = parsed.version;
    if (parsed.stdin != null) body.input = parsed.stdin;
    if (parsed.compilerArgs && parsed.compilerArgs.length) body.compilerArgs = parsed.compilerArgs;
    if (parsed.files.length > 1) {
      body.files = parsed.files;
    } else {
      body.code = parsed.files[0].content;
    }
    var startedAt = Date.now();
    return fetch(ctxPath() + '/OneCompilerFunctionality?action=execute', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body)
    })
    .then(function (r) { return r.json(); })
    .then(function (data) {
      // Case-defensive — the dedicated JSP does the same lookup (see
      // onecompiler.jsp line ~2777).
      var stdout = data.Stdout || data.stdout || '';
      var stderr = data.Stderr || data.stderr || '';
      var exitCode = (data.ExitCode !== undefined) ? data.ExitCode
                   : (data.exitCode !== undefined) ? data.exitCode
                   : (data.error ? 1 : 0);
      if (data.error && !stderr) stderr = String(data.error);
      var duration = ((Date.now() - startedAt) / 1000).toFixed(2);
      return {
        ok: true,
        stdout: stdout,
        stderr: stderr,
        exitCode: exitCode,
        duration: duration,
        language: parsed.language,
        languageLabel: parsed.languageLabel,
        files: parsed.files,
        input: parsed
      };
    })
    .catch(function (err) {
      return { ok: false, error: 'Runner network error: ' + (err && err.message || err) };
    });
  }

  if (typeof window !== 'undefined') {
    window.CodeRunnerCore = {
      LANGUAGE_EXTENSIONS: LANGUAGE_EXTENSIONS,
      LANGUAGE_ALIASES: LANGUAGE_ALIASES,
      LANGUAGE_LABELS: LANGUAGE_LABELS,
      canonicalLanguage: canonicalLanguage,
      parseListingOptions: parseListingOptions,
      findNextBlock: findNextBlock,
      findCodeBlock: findCodeBlock,
      collectGroup: collectGroup,
      parseLatexCode: parseLatexCode,
      solveFromLatex: solveFromLatex
    };
  }
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
      parseLatexCode: parseLatexCode,
      solveFromLatex: solveFromLatex,
      canonicalLanguage: canonicalLanguage,
      findCodeBlock: findCodeBlock,
      LANGUAGE_EXTENSIONS: LANGUAGE_EXTENSIONS,
      LANGUAGE_LABELS: LANGUAGE_LABELS
    };
  }
})();
