// Math → solve inline in the LaTeX editor.
//
// v1: limits only. Detects \lim_{...} ... in a CodeMirror selection, calls
// LimitCalculatorCore.solveFromLatex (in /modern/js/limit-calculator-core.js),
// and appends " = <resultLatex>" right after the selection — the original
// expression is preserved.
//
// Future: \int (integral), \frac{d}{dx} (derivative), \sum (series).
(function () {
  'use strict';

  // ── Detection ────────────────────────────────────────────────────────────

  // Find \lim_{...} body in a string. Returns the full matched range +
  // structured fields, or null. Handles nested braces inside the subscript.
  function findLimit(text) {
    if (!text) return null;
    var idx = text.indexOf('\\lim_{');
    if (idx < 0) idx = text.indexOf('\\lim _{');  // tolerate space before `_`
    if (idx < 0) return null;
    // Locate the matching `}` for the subscript
    var braceStart = text.indexOf('{', idx + 4);
    if (braceStart < 0) return null;
    var depth = 1, i = braceStart + 1;
    while (i < text.length && depth > 0) {
      var c = text.charAt(i);
      if (c === '{') depth++;
      else if (c === '}') depth--;
      if (depth === 0) break;
      i++;
    }
    if (depth !== 0) return null;
    // Past the subscript `}`. Body is the rest of the selection (until end
    // of line or `$` boundary). For our editor flow, the user usually
    // selects exactly the limit + body, so we take everything after the
    // closing brace.
    var body = text.substring(i + 1).trim();
    if (!body) return null;
    return { start: idx, end: text.length, raw: text.substring(idx) };
  }

  // Find \int (...) dx in a selection. Returns { start, raw } or null.
  function findIntegral(text) {
    if (!text) return null;
    var idx = text.indexOf('\\int');
    if (idx < 0) return null;
    return { start: idx, end: text.length, raw: text.substring(idx) };
  }

  // Find \frac{d}{dx} ... or \frac{d^n}{dx^n} ... in a selection.
  function findDerivative(text) {
    if (!text) return null;
    // Quick prefix probe; full validation runs in parseLatexDerivative
    var re = /\\frac\s*\{\s*d(?:\^[\d{}]+)?\s*\}\s*\{\s*d[a-zA-Z]/;
    var m = text.match(re);
    if (!m) return null;
    return { start: m.index, end: text.length, raw: text.substring(m.index) };
  }

  // Quick prefilter for a matrix expression — does the selection mention a
  // matrix environment? Full op detection runs in MatrixCalculatorCore.
  function findMatrix(text) {
    if (!text) return null;
    var re = /\\begin\{(?:pmatrix|bmatrix|matrix|vmatrix|Bmatrix|Vmatrix)\}/;
    var m = text.match(re);
    if (!m) return null;
    return { start: 0, end: text.length, raw: text };
  }

  // Quick prefilter for a runnable code block — any \begin{lstlisting}
  // with a [language=…] option. Full parsing (multi-file grouping, alias
  // resolution) runs in CodeRunnerCore.
  function findCode(text) {
    if (!text) return null;
    if (text.indexOf('\\begin{lstlisting}') < 0) return null;
    return { start: 0, end: text.length, raw: text };
  }

  function detect(selection) {
    if (!selection) return null;
    var s = selection.trim()
      .replace(/^\$\$([\s\S]+)\$\$$/, '$1')
      .replace(/^\$([\s\S]+)\$$/, '$1')
      .replace(/^\\\(([\s\S]+)\\\)$/, '$1')
      .replace(/^\\\[([\s\S]+)\\\]$/, '$1')
      .trim();

    // Limit detection (existing path)
    var lim = findLimit(s);
    if (lim) {
      if (window.LimitCalculatorCore && window.LimitCalculatorCore.parseLatexLimit) {
        var parsed = window.LimitCalculatorCore.parseLatexLimit(lim.raw);
        if (parsed) return { type: 'limit', latex: lim.raw, originalSelection: selection, parsed: parsed };
      } else {
        return { type: 'limit', latex: lim.raw, originalSelection: selection };
      }
    }

    // Integral detection
    var intg = findIntegral(s);
    if (intg) {
      if (window.IntegralCalculatorCore && window.IntegralCalculatorCore.parseLatexIntegral) {
        var iparsed = window.IntegralCalculatorCore.parseLatexIntegral(intg.raw);
        if (iparsed) return { type: 'integral', latex: intg.raw, originalSelection: selection, parsed: iparsed };
      } else {
        return { type: 'integral', latex: intg.raw, originalSelection: selection };
      }
    }

    // Derivative detection (\frac{d}{dx}…)
    var der = findDerivative(s);
    if (der) {
      if (window.DerivativeCalculatorCore && window.DerivativeCalculatorCore.parseLatexDerivative) {
        var dparsed = window.DerivativeCalculatorCore.parseLatexDerivative(der.raw);
        if (dparsed) return { type: 'derivative', latex: der.raw, originalSelection: selection, parsed: dparsed };
      } else {
        return { type: 'derivative', latex: der.raw, originalSelection: selection };
      }
    }

    // Matrix detection (\det A, A^{-1}, A^T, A·B, etc. — A is a \begin{…matrix…})
    var mat = findMatrix(s);
    if (mat) {
      if (window.MatrixCalculatorCore && window.MatrixCalculatorCore.parseLatexMatrix) {
        var mparsed = window.MatrixCalculatorCore.parseLatexMatrix(s);
        if (mparsed) return { type: 'matrix', latex: s, originalSelection: selection, parsed: mparsed };
      }
      // No fallback — without the core we can't usefully solve a matrix op
    }

    // Code-block detection (\begin{lstlisting}[language=X]...). Multi-file
    // groups are bundled by CodeRunnerCore.parseLatexCode.
    var code = findCode(s);
    if (code) {
      if (window.CodeRunnerCore && window.CodeRunnerCore.parseLatexCode) {
        var cparsed = window.CodeRunnerCore.parseLatexCode(s);
        if (cparsed) return { type: 'code', latex: s, originalSelection: selection, parsed: cparsed };
      }
    }
    return null;
  }

  // ── Solve + insert ───────────────────────────────────────────────────────

  function toast(kind, msg) {
    var fn = window['show' + kind + 'Toast'];
    if (typeof fn === 'function') fn(msg);
  }

  function solveLimit(detected, mode) {
    if (!window.LimitCalculatorCore || !window.LimitCalculatorCore.solveFromLatex) {
      return { ok: false, error: 'LimitCalculatorCore not loaded' };
    }
    return window.LimitCalculatorCore.solveFromLatex(detected.latex, { withSteps: mode === 'steps' });
  }

  function solveIntegral(detected, mode) {
    if (!window.IntegralCalculatorCore || !window.IntegralCalculatorCore.solveFromLatex) {
      return { ok: false, error: 'IntegralCalculatorCore not loaded' };
    }
    return window.IntegralCalculatorCore.solveFromLatex(detected.latex, { withSteps: mode === 'steps' });
  }

  function solveDerivative(detected, mode) {
    if (!window.DerivativeCalculatorCore || !window.DerivativeCalculatorCore.solveFromLatex) {
      return { ok: false, error: 'DerivativeCalculatorCore not loaded' };
    }
    return window.DerivativeCalculatorCore.solveFromLatex(detected.latex, { withSteps: mode === 'steps' });
  }

  function solveMatrix(detected, mode) {
    if (!window.MatrixCalculatorCore || !window.MatrixCalculatorCore.solveFromLatex) {
      return { ok: false, error: 'MatrixCalculatorCore not loaded' };
    }
    return window.MatrixCalculatorCore.solveFromLatex(detected.latex, { withSteps: mode === 'steps' });
  }

  function solveCode(detected, mode) {
    if (!window.CodeRunnerCore || !window.CodeRunnerCore.solveFromLatex) {
      return { ok: false, error: 'CodeRunnerCore not loaded' };
    }
    return window.CodeRunnerCore.solveFromLatex(detected.latex, {});
  }

  // ── Code output block builder ────────────────────────────────────────
  //
  // Renders the captured stdout / stderr from a code run as a styled LaTeX
  // block. Uses the `listings` package's lstlisting with the project's
  // input / stdout / stderr styles (auto-injected if missing). Both stdout
  // and stderr are shown when present; the metadata strip carries
  // language · duration · exit code.
  function escListing(s) {
    // listings displays content verbatim, so backslashes etc. are fine.
    // Only thing to clean: a stray `\end{lstlisting}` token would close
    // our box early. Replace with a near-identical visually equivalent string.
    return (s || '').replace(/\\end\{lstlisting\}/g, '\\end<<lstlisting>>');
  }

  function buildCodeOutputBlock(parsed, result) {
    var lang = parsed.languageLabel || parsed.language;
    var stdout = result.stdout || '';
    var stderr = result.stderr || '';
    var exit = (typeof result.exitCode === 'number') ? result.exitCode : 0;
    var dur = result.duration ? (result.duration + 's') : '';
    var meta = lang + (dur ? (' \\textperiodcentered\\ ' + dur) : '') +
               ' \\textperiodcentered\\ exit ' + exit;
    var lines = ['', ''];

    var statusColor = (exit === 0) ? 'green!60!black' : 'red!60!black';
    var statusLabel = (exit === 0) ? 'stdout' : ('stderr (exit ' + exit + ')');

    lines.push('\\noindent\\textbf{\\textcolor{' + statusColor +
               '}{$\\blacktriangleright$\\ Run}} ' +
               '\\hfill {\\small\\itshape ' + meta + '}');

    // stdout
    if (stdout) {
      lines.push('\\begin{lstlisting}[style=stdout]');
      lines.push(escListing(stdout.replace(/\s+$/, '')));
      lines.push('\\end{lstlisting}');
    }
    // stderr (if any — shown even when exit==0 if non-empty)
    if (stderr) {
      lines.push('');
      lines.push('\\noindent{\\small\\textbf{\\textcolor{red!70!black}{stderr}}}');
      lines.push('\\begin{lstlisting}[style=stderr]');
      lines.push(escListing(stderr.replace(/\s+$/, '')));
      lines.push('\\end{lstlisting}');
    }
    if (!stdout && !stderr) {
      lines.push('\\noindent{\\small\\itshape (no output)}');
    }
    lines.push('');
    return lines.join('\n');
  }

  // Preamble lines the code output requires.
  // Style definitions are inserted ONCE per project (ensurePreambleLines
  // de-dupes by `\lstdefinestyle{NAME}` prefix match).
  var CODE_PREAMBLE = [
    '\\usepackage{listings}',
    '\\usepackage{xcolor}',
    '\\usepackage{amssymb}',
    '\\lstdefinestyle{input}{basicstyle=\\ttfamily\\small, backgroundcolor=\\color{gray!8}, frame=leftline, framerule=2pt, rulecolor=\\color{blue!60}, xleftmargin=10pt, framexleftmargin=8pt, breaklines=true}',
    '\\lstdefinestyle{stdout}{basicstyle=\\ttfamily\\small, backgroundcolor=\\color{green!5}, frame=leftline, framerule=2pt, rulecolor=\\color{green!60!black}, xleftmargin=10pt, framexleftmargin=8pt, breaklines=true}',
    '\\lstdefinestyle{stderr}{basicstyle=\\ttfamily\\small, backgroundcolor=\\color{red!5}, frame=leftline, framerule=2pt, rulecolor=\\color{red!60!black}, xleftmargin=10pt, framexleftmargin=8pt, breaklines=true}'
  ];

  function appendCodeOutputBlock(cm, anchorMark, detected, result) {
    ensurePreambleLines(cm, CODE_PREAMBLE);
    var anchorPos = anchorMark ? anchorMark.find() : null;
    if (anchorMark) anchorMark.clear();
    var block = buildCodeOutputBlock(detected.parsed, result);
    if (window.SolutionsFile && typeof window.SolutionsFile.append === 'function') {
      return window.SolutionsFile.append(cm,
        '% Run output for ' + (detected.parsed.languageLabel || detected.parsed.language) +
        (detected.parsed.isMulti ? (' (' + detected.parsed.files.length + ' files)') : '') +
        '\n' + block,
        { inputAnchor: anchorPos });
    }
    var pos = anchorPos || cm.getCursor('to');
    var line = pos.line;
    if (line >= cm.lineCount()) line = cm.lineCount() - 1;
    var lineEnd = { line: line, ch: cm.getLine(line).length };
    cm.replaceRange(block, lineEnd, lineEnd);
    cm.focus();
    return null;
  }

  function appendResultInline(cm, anchorMark, detected, resultLatex) {
    var anchorPos = anchorMark ? anchorMark.find() : null;
    if (anchorMark) anchorMark.clear();
    if (!window.SolutionsFile || typeof window.SolutionsFile.append !== 'function') {
      var pos = anchorPos || cm.getCursor('to');
      cm.replaceRange(' = ' + resultLatex, pos, pos);
      cm.focus();
      return null;
    }
    // For matrix ops, display the operation name on the LHS rather than
    // re-emitting the (potentially long) raw matrix expression.
    var lhs;
    if (detected.type === 'matrix' && detected.parsed) {
      var p = detected.parsed;
      lhs = (p.op === 'determinant')  ? '\\det(A)'
          : (p.op === 'inverse')      ? 'A^{-1}'
          : (p.op === 'transpose')    ? 'A^{T}'
          : (p.op === 'trace')        ? '\\mathrm{tr}(A)'
          : (p.op === 'rank')         ? '\\mathrm{rank}(A)'
          : (p.op === 'rref')         ? '\\mathrm{RREF}(A)'
          : (p.op === 'power')        ? ('A^{' + (p.n != null ? p.n : 'n') + '}')
          : (p.op === 'eigenvalues')  ? '\\lambda'
          : (p.op === 'eigenvectors') ? 'v'
          : (p.op === 'charpoly')     ? 'p(\\lambda)'
          : (p.op === 'add')          ? 'A + B'
          : (p.op === 'subtract')     ? 'A - B'
          : (p.op === 'multiply')     ? 'A \\cdot B'
          :                              detected.latex;
      var aBlock = '% A = ' + p.latexA;
      var bBlock = p.latexB ? ('\n% B = ' + p.latexB) : '';
      var content2 = '% Solve (' + (p.opLabel || p.op) + ')\n' +
                     aBlock + bBlock + '\n' +
                     '\\[ ' + lhs + ' = ' + resultLatex + ' \\]\n';
      return window.SolutionsFile.append(cm, content2, { inputAnchor: anchorPos });
    }
    var content =
      '% Solve\n' +
      '\\[ ' + detected.latex + ' = ' + resultLatex + ' \\]\n';
    return window.SolutionsFile.append(cm, content, { inputAnchor: anchorPos });
  }

  // Build a multi-line align* block from the steps array.
  function buildStepsBlock(steps, methodLabel) {
    var lines = [
      '',
      '',
      '\\begin{align*}'
    ];
    var n = steps.length;
    for (var i = 0; i < n; i++) {
      var s = steps[i];
      var title = (s.title || '').replace(/\\/g, '\\textbackslash{}')
                                 .replace(/&/g, '\\&').replace(/%/g, '\\%')
                                 .replace(/_/g, '\\_').replace(/#/g, '\\#');
      lines.push('  &\\text{' + (i + 1) + '. ' + title + ':} \\\\');
      lines.push('  &\\quad ' + (s.latex || '') + (i < n - 1 ? ' \\\\[4pt]' : ''));
    }
    lines.push('\\end{align*}');
    if (methodLabel) lines.push('% method: ' + methodLabel);
    lines.push('');
    return lines.join('\n');
  }

  // Matrix-friendly step formatter. Each step gets its own \[…\] display
  // equation; we can't use align* because the matrix LaTeX itself contains
  // `\\` row separators which would terminate align rows prematurely.
  function buildMatrixStepsBlock(steps, methodLabel) {
    var lines = ['', ''];
    if (methodLabel) lines.push('\\noindent\\textbf{Solution (' + methodLabel + ')}');
    lines.push('\\begin{enumerate}[leftmargin=*, label=\\textbf{\\arabic*.}]');
    var n = steps.length;
    for (var i = 0; i < n; i++) {
      var s = steps[i];
      var title = (s.title || '').replace(/&/g, '\\&').replace(/%/g, '\\%')
                                 .replace(/_/g, '\\_').replace(/#/g, '\\#');
      lines.push('  \\item \\textbf{' + title + '}');
      // Step body as display math — matrix LaTeX with internal `\\` row
      // separators renders correctly here.
      lines.push('  \\[ ' + (s.latex || '') + ' \\]');
    }
    lines.push('\\end{enumerate}');
    lines.push('');
    return lines.join('\n');
  }

  function appendStepsBlock(cm, anchorMark, steps, methodLabel, type) {
    var anchorPos = anchorMark ? anchorMark.find() : null;
    if (anchorMark) anchorMark.clear();
    // Matrix steps need a list-of-display-equations layout (see above);
    // limits/integrals/derivatives use the align* layout.
    var block;
    if (type === 'matrix') {
      // Make sure `enumitem` is in the preamble for [leftmargin=*, label=…]
      ensurePreambleLines(cm, ['\\usepackage{enumitem}']);
      block = buildMatrixStepsBlock(steps, methodLabel);
    } else {
      block = buildStepsBlock(steps, methodLabel);
    }
    if (window.SolutionsFile && typeof window.SolutionsFile.append === 'function') {
      return window.SolutionsFile.append(cm, '% Solve with steps\n' + block,
                                         { inputAnchor: anchorPos });
    }
    var pos = anchorPos || cm.getCursor('to');
    var line = pos.line;
    if (line >= cm.lineCount()) line = cm.lineCount() - 1;
    var lineEnd = { line: line, ch: cm.getLine(line).length };
    cm.replaceRange(block, lineEnd, lineEnd);
    cm.focus();
    return null;
  }

  // ── Preamble injection (pgfplots needs the compat line + the package) ──

  function ensurePreambleLines(cm, lines) {
    var content = cm.getValue();
    var missing = [];
    lines.forEach(function (line) {
      var pkgMatch = line.match(/\\usepackage(?:\[[^\]]*\])?\{([^}]+)\}/);
      if (pkgMatch) {
        var pkgName = pkgMatch[1].replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
        var re = new RegExp(
          '\\\\usepackage(?:\\[[^\\]]*\\])?\\{[^}]*\\b' + pkgName + '\\b[^}]*\\}');
        if (!re.test(content)) missing.push(line);
        return;
      }
      var cmdMatch = line.match(/^\s*(\\\w+)/);
      if (cmdMatch) {
        if (content.indexOf(cmdMatch[1]) < 0) missing.push(line);
        return;
      }
      if (content.indexOf(line) < 0) missing.push(line);
    });
    if (!missing.length) return 0;

    var beginDocLine = -1, lastUsepkgLine = -1;
    for (var i = 0; i < cm.lineCount(); i++) {
      var ln = cm.getLine(i);
      if (beginDocLine < 0 && /\\begin\{document\}/.test(ln)) { beginDocLine = i; break; }
      if (/\\usepackage/.test(ln)) lastUsepkgLine = i;
    }
    if (beginDocLine < 0) return 0;
    var insertLine = (lastUsepkgLine >= 0) ? lastUsepkgLine + 1 : beginDocLine;
    cm.replaceRange(missing.join('\n') + '\n', { line: insertLine, ch: 0 });
    return missing.length;
  }

  // ── Graph block (pgfplots side-by-side: graph left, result info right) ──

  function buildLimitGraphBlock(parsed, result) {
    if (!window.LimitCalculatorCore) return null;
    var LCC = window.LimitCalculatorCore;
    var v = parsed.variable;
    var bodyExpr = parsed.bodyExpr;
    var pointStr = parsed.pointStr;
    var pointNum = LCC.parsePoint(pointStr);
    var resultVal = result.value;
    var resultLatex = LCC.formatValueLatex(resultVal);

    var arrowLatex = v + ' \\to ' + LCC.pointToLatex(pointStr);
    if (parsed.direction === 'right') arrowLatex += '^{+}';
    else if (parsed.direction === 'left') arrowLatex += '^{-}';

    // Pick a sensible plot domain
    var dMin, dMax;
    if (pointNum === Infinity) { dMin = 1; dMax = 50; }
    else if (pointNum === -Infinity) { dMin = -50; dMax = -1; }
    else if (parsed.direction === 'right') { dMin = pointNum + 0.001; dMax = pointNum + 3; }
    else if (parsed.direction === 'left')  { dMin = pointNum - 3;     dMax = pointNum - 0.001; }
    else { dMin = pointNum - 3; dMax = pointNum + 3; }

    // Build plot+marker lines
    var plotLines = ['      \\addplot[blue, thick] {' + bodyExpr + '};'];
    if (isFinite(pointNum) && typeof resultVal === 'number' && isFinite(resultVal)) {
      plotLines.push('      \\addplot[only marks, mark=o, mark size=3pt, red, thick]');
      plotLines.push('        coordinates {(' + pointNum + ', ' + resultVal + ')};');
    }
    if (!isFinite(pointNum) && typeof resultVal === 'number' && isFinite(resultVal)) {
      plotLines.push('      \\addplot[red, dashed, thick, domain=' + dMin + ':' + dMax + ']');
      plotLines.push('        {' + resultVal + '};');
    }

    var bodyForCaption = parsed.bodyLatex;

    return [
      '',
      '',
      '\\begin{figure}[H]',
      '  \\centering',
      '  \\begin{minipage}[c]{0.55\\textwidth}',
      '    \\centering',
      '    \\begin{tikzpicture}',
      '      \\begin{axis}[',
      '        width=\\linewidth, height=6cm,',
      '        xlabel={$' + v + '$}, ylabel={$f(' + v + ')$},',
      '        grid=both, samples=200,',
      '        domain=' + dMin + ':' + dMax + ',',
      '        restrict y to domain=-10:10,',
      '        trig format=rad',
      '      ]'
    ].concat(plotLines).concat([
      '      \\end{axis}',
      '    \\end{tikzpicture}',
      '  \\end{minipage}\\hfill',
      '  \\begin{minipage}[c]{0.42\\textwidth}',
      '    \\small',
      '    \\textbf{Original}\\\\',
      '    $\\displaystyle\\lim_{' + arrowLatex + '} ' + bodyForCaption + '$',
      '    \\par\\vspace{0.5em}',
      '    \\textbf{Method}\\\\',
      '    ' + (result.method || 'Numerical'),
      '    \\par\\vspace{0.5em}',
      '    \\textbf{Limit value}\\\\',
      '    $\\displaystyle ' + resultLatex + '$',
      '  \\end{minipage}',
      '  \\caption{$\\displaystyle\\lim_{' + arrowLatex + '} ' + bodyForCaption + ' = ' + resultLatex + '$}',
      '\\end{figure}',
      ''
    ]).join('\n');
  }

  function buildIntegralGraphBlock(parsed, result) {
    if (!window.IntegralCalculatorCore) return null;
    var ICC = window.IntegralCalculatorCore;
    var v = parsed.variable;
    var bodyExpr = parsed.bodyExpr;
    var bodyForCaption = parsed.bodyLatex;

    var integralLatex = parsed.isDefinite
      ? '\\int_{' + parsed.lower + '}^{' + parsed.upper + '} ' + bodyForCaption + '\\, d' + v
      : '\\int ' + bodyForCaption + '\\, d' + v;

    var dMin, dMax, loExpr = null, hiExpr = null;
    if (parsed.isDefinite) {
      loExpr = ICC.normalizeExpr(ICC.latexBodyToExpr(String(parsed.lower)));
      hiExpr = ICC.normalizeExpr(ICC.latexBodyToExpr(String(parsed.upper)));
      var loNum = ICC.evalBound(parsed.lower);
      var hiNum = ICC.evalBound(parsed.upper);
      if (isFinite(loNum) && isFinite(hiNum)) {
        var pad = Math.max(0.5, (hiNum - loNum) * 0.2);
        dMin = loNum - pad; dMax = hiNum + pad;
      } else { dMin = -3; dMax = 3; }
    } else {
      dMin = -3; dMax = 3;
    }

    var plot = ['      \\addplot[blue, thick] {' + bodyExpr + '};'];
    if (parsed.isDefinite && loExpr && hiExpr) {
      plot.push('      \\addplot[fill=blue!20, draw=blue!60, thick, domain=' + loExpr + ':' + hiExpr + ']');
      plot.push('        {' + bodyExpr + '} \\closedcycle;');
    }

    var rightLabel = parsed.isDefinite ? 'Value' : 'Antiderivative';

    return [
      '',
      '',
      '\\begin{figure}[H]',
      '  \\centering',
      '  \\begin{minipage}[c]{0.55\\textwidth}',
      '    \\centering',
      '    \\begin{tikzpicture}',
      '      \\begin{axis}[',
      '        width=\\linewidth, height=6cm,',
      '        xlabel={$' + v + '$}, ylabel={$f(' + v + ')$},',
      '        grid=both, samples=200,',
      '        domain=' + dMin + ':' + dMax + ',',
      '        restrict y to domain=-10:10,',
      '        trig format=rad,',
      '        axis lines=middle',
      '      ]'
    ].concat(plot).concat([
      '      \\end{axis}',
      '    \\end{tikzpicture}',
      '  \\end{minipage}\\hfill',
      '  \\begin{minipage}[c]{0.42\\textwidth}',
      '    \\small',
      '    \\textbf{Original}\\\\',
      '    $\\displaystyle ' + integralLatex + '$',
      '    \\par\\vspace{0.5em}',
      '    \\textbf{Method}\\\\',
      '    ' + (result.method || 'Integration'),
      '    \\par\\vspace{0.5em}',
      '    \\textbf{' + rightLabel + '}\\\\',
      '    $\\displaystyle ' + result.resultLatex + '$',
      '  \\end{minipage}',
      '  \\caption{$\\displaystyle ' + integralLatex + ' = ' + result.resultLatex + '$}',
      '\\end{figure}',
      ''
    ]).join('\n');
  }

  function buildDerivativeGraphBlock(parsed, result) {
    var v = parsed.variable;
    var bodyExpr = parsed.bodyExpr;
    // We need the derivative as a pgfplots-compatible expression too.
    // nerdamer's text() gives plain expression; if our normalize fails
    // we still have the LaTeX which won't plot — guard.
    var derivExpr = (result.value || '').replace(/\s+/g, '');
    var leftSide = (parsed.order > 1)
      ? '\\frac{d^{' + parsed.order + '}}{d' + v + '^{' + parsed.order + '}}\\left[' + parsed.bodyLatex + '\\right]'
      : '\\frac{d}{d' + v + '}\\left[' + parsed.bodyLatex + '\\right]';

    return [
      '',
      '',
      '\\begin{figure}[H]',
      '  \\centering',
      '  \\begin{minipage}[c]{0.55\\textwidth}',
      '    \\centering',
      '    \\begin{tikzpicture}',
      '      \\begin{axis}[',
      '        width=\\linewidth, height=6cm,',
      '        xlabel={$' + v + '$}, ylabel={value},',
      '        grid=both, samples=200,',
      '        domain=-3:3,',
      '        restrict y to domain=-10:10,',
      '        trig format=rad,',
      '        axis lines=middle,',
      '        legend pos=outer north east',
      '      ]',
      '      \\addplot[blue, thick]   {' + bodyExpr + '};',
      '      \\addlegendentry{$f(' + v + ')$}',
      '      \\addplot[red,  thick, dashed] {' + derivExpr + '};',
      '      \\addlegendentry{$f\'(' + v + ')$}',
      '      \\end{axis}',
      '    \\end{tikzpicture}',
      '  \\end{minipage}\\hfill',
      '  \\begin{minipage}[c]{0.42\\textwidth}',
      '    \\small',
      '    \\textbf{Original}\\\\',
      '    $\\displaystyle f(' + v + ') = ' + parsed.bodyLatex + '$',
      '    \\par\\vspace{0.5em}',
      '    \\textbf{Derivative}\\\\',
      '    $\\displaystyle ' + leftSide + ' = ' + result.resultLatex + '$',
      '    \\par\\vspace{0.5em}',
      '    \\textbf{Method}\\\\',
      '    ' + (result.method || 'Differentiation'),
      '  \\end{minipage}',
      '  \\caption{$\\displaystyle ' + leftSide + ' = ' + result.resultLatex + '$}',
      '\\end{figure}',
      ''
    ].join('\n');
  }

  // ── Matrix graph block (pgfplots geometric overlay) ──────────────────
  //
  // Draws the unit square (dotted gray) plus the image of it under the
  // operation:
  //   determinant / transpose / power → image of A applied to unit square
  //   inverse                         → A applied (solid) + A^-1 applied (dashed)
  //   eigenvectors                    → A applied + eigenvector arrows
  //   multiply                        → B applied (dashed) + (AB) applied
  //   add / subtract                  → A, B, and (A±B) overlaid
  //
  // Right-hand minipage shows A, B (if any), the result, and a one-line
  // geometric caption.
  function buildMatrixGraphBlock(parsed, result) {
    if (!window.MatrixCalculatorCore) return null;
    var MCC = window.MatrixCalculatorCore;
    if (!MCC.canVisualize2D(parsed)) return null;

    var fmt = function (n) {
      if (!isFinite(n)) return '0';
      return Math.abs(n) < 1e-9 ? '0' : (+n.toFixed(4)).toString();
    };
    var pathCoords = function (path) {
      return path.map(function (p) { return '(' + fmt(p[0]) + ',' + fmt(p[1]) + ')'; }).join(' ');
    };

    var A = MCC.cellsToNumericMatrix(parsed.cellsA);
    var B = parsed.cellsB ? MCC.cellsToNumericMatrix(parsed.cellsB) : null;
    var op = parsed.op;
    var sq = MCC.unitSquare();
    var plotLines = [];
    var legend = [];

    // Unit reference shape — same on every viz.
    plotLines.push('      \\addplot[gray, dashed, thick, fill=gray!10, fill opacity=0.35]');
    plotLines.push('        coordinates {' + pathCoords(sq) + '};');
    legend.push('Unit square');

    if (op === 'determinant' || op === 'transpose' || op === 'eigenvectors') {
      var Asq = MCC.transformPath(A, sq);
      var dA = MCC.det2(A);
      var primaryColor = (op === 'determinant' && dA < 0) ? 'red!70!black' : 'green!60!black';
      var primaryFill  = (op === 'determinant' && dA < 0) ? 'red!30'       : 'green!40';
      plotLines.push('      \\addplot[' + primaryColor + ', very thick, fill=' + primaryFill + ', fill opacity=0.45]');
      plotLines.push('        coordinates {' + pathCoords(Asq) + '};');
      legend.push('$A$ applied');

      if (op === 'transpose') {
        var At = [[A[0][0], A[1][0]], [A[0][1], A[1][1]]];
        var Atsq = MCC.transformPath(At, sq);
        plotLines.push('      \\addplot[cyan!60!black, very thick, dashed, fill=cyan!30, fill opacity=0.30]');
        plotLines.push('        coordinates {' + pathCoords(Atsq) + '};');
        legend.push('$A^{T}$ applied');
      }
      if (op === 'eigenvectors') {
        var eig = MCC.eigen2(A);
        if (eig) {
          for (var i = 0; i < 2; i++) {
            var v = eig.vectors[i]; var lam = eig.values[i];
            var color = (i === 0) ? 'orange!80!black' : 'blue!70!black';
            // Eigenvector v_i (length 1.5 for visibility)
            plotLines.push('      \\addplot[' + color + ', ultra thick, -{Latex[length=3mm]}]');
            plotLines.push('        coordinates {(0,0) (' + fmt(v[0]*1.5) + ',' + fmt(v[1]*1.5) + ')};');
            legend.push('$v_{' + (i+1) + '}\\;(\\lambda=' + fmt(lam) + ')$');
            // A v_i = λ v_i — dotted, shows it stays on the same line.
            plotLines.push('      \\addplot[' + color + ', dotted, very thick]');
            plotLines.push('        coordinates {(0,0) (' + fmt(v[0]*lam*1.5) + ',' + fmt(v[1]*lam*1.5) + ')};');
            legend.push('$A v_{' + (i+1) + '}$');
          }
        }
      }
    }
    else if (op === 'inverse') {
      var Asq2 = MCC.transformPath(A, sq);
      plotLines.push('      \\addplot[green!60!black, very thick, fill=green!40, fill opacity=0.40]');
      plotLines.push('        coordinates {' + pathCoords(Asq2) + '};');
      legend.push('$A$ applied');
      var Ainv = MCC.inv2(A);
      if (Ainv) {
        var Aisq = MCC.transformPath(Ainv, sq);
        plotLines.push('      \\addplot[red!70!black, very thick, dashed, fill=red!20, fill opacity=0.25]');
        plotLines.push('        coordinates {' + pathCoords(Aisq) + '};');
        legend.push('$A^{-1}$ applied');
      }
    }
    else if (op === 'multiply') {
      var Bsq = MCC.transformPath(B, sq);
      var ABsq = MCC.transformPath(A, Bsq);
      plotLines.push('      \\addplot[cyan!60!black, very thick, dashed, fill=cyan!30, fill opacity=0.30]');
      plotLines.push('        coordinates {' + pathCoords(Bsq) + '};');
      legend.push('$B$ applied');
      plotLines.push('      \\addplot[green!60!black, very thick, fill=green!40, fill opacity=0.45]');
      plotLines.push('        coordinates {' + pathCoords(ABsq) + '};');
      legend.push('$(AB)$ applied');
    }
    else if (op === 'add' || op === 'subtract') {
      var Asq3 = MCC.transformPath(A, sq);
      var Bsq3 = MCC.transformPath(B, sq);
      var Csq3 = MCC.transformPath(MCC.combine(A, B, op), sq);
      plotLines.push('      \\addplot[green!60!black, thick, fill=green!20, fill opacity=0.25]');
      plotLines.push('        coordinates {' + pathCoords(Asq3) + '};');
      legend.push('$A$ applied');
      plotLines.push('      \\addplot[cyan!60!black, thick, fill=cyan!20, fill opacity=0.25]');
      plotLines.push('        coordinates {' + pathCoords(Bsq3) + '};');
      legend.push('$B$ applied');
      var sumColor = (op === 'add') ? 'violet!70!black' : 'purple!70!black';
      var sumFill  = (op === 'add') ? 'violet!30'      : 'purple!30';
      plotLines.push('      \\addplot[' + sumColor + ', very thick, fill=' + sumFill + ', fill opacity=0.45]');
      plotLines.push('        coordinates {' + pathCoords(Csq3) + '};');
      legend.push(op === 'add' ? '$(A+B)$ applied' : '$(A-B)$ applied');
    }
    else if (op === 'power') {
      // Cap at 4 frames to keep the picture readable.
      var n = Math.max(0, Math.min(Math.abs(parsed.n || 1), 4));
      var current = sq.slice();
      if (n === 0) {
        plotLines.push('      \\addplot[green!60!black, very thick, fill=green!40, fill opacity=0.40]');
        plotLines.push('        coordinates {' + pathCoords(sq) + '};');
        legend.push('$A^{0} = I$');
      } else {
        for (var k = 1; k <= n; k++) {
          current = MCC.transformPath(A, current);
          var opacity = 0.20 + (k / n) * 0.30;
          plotLines.push('      \\addplot[green!' + (40 + k*10) + '!black, very thick, fill=green!' + (40 + k*10) + ', fill opacity=' + opacity.toFixed(2) + ']');
          plotLines.push('        coordinates {' + pathCoords(current) + '};');
          legend.push('$A^{' + k + '}$ applied');
        }
      }
    }

    // Right minipage: matrix + result + geometric caption.
    var caption = '';
    var dA2 = MCC.det2(A);
    if (op === 'determinant')      caption = 'Signed area of the parallelogram $=\\det A=' + fmt(dA2) + '$' + (dA2 < 0 ? '; negative $\\Rightarrow$ orientation reversed.' : '.');
    else if (op === 'inverse')     caption = '$A^{-1}$ undoes $A$: applying both returns the unit square.';
    else if (op === 'transpose')   caption = '$A$ and $A^{T}$ produce different shapes but the same (signed) area, since $\\det(A^{T})=\\det(A)$.';
    else if (op === 'eigenvectors') caption = 'Each eigenvector $v_i$ stays on its own line under $A$; the dotted arrow shows $A v_i = \\lambda_i v_i$.';
    else if (op === 'multiply')    caption = 'Order matters: $B$ is applied first (dashed), then $A$ on top, giving $AB$.';
    else if (op === 'add')         caption = '$(A+B)$ acts on the unit square as the element-wise sum of $A$ and $B$.';
    else if (op === 'subtract')    caption = '$(A-B)$ acts on the unit square as the element-wise difference of $A$ and $B$.';
    else if (op === 'power')       caption = 'Each frame applies $A$ once more; capped at $n=' + Math.min(Math.abs(parsed.n||0), 4) + '$ for readability.';

    var bMatrixLine = B
      ? ', \\quad B = ' + parsed.latexB
      : '';

    var resultLatex = (result && result.resultLatex) ? result.resultLatex : '';

    return [
      '',
      '',
      '\\begin{figure}[H]',
      '  \\centering',
      '  \\begin{minipage}[c]{0.55\\textwidth}',
      '    \\centering',
      '    \\begin{tikzpicture}',
      '      \\begin{axis}[',
      '        width=\\linewidth, height=7cm,',
      '        axis equal image, grid=both,',
      '        axis lines=middle,',
      '        xlabel={$x$}, ylabel={$y$},',
      '        legend style={font=\\tiny, at={(0.5,-0.20)}, anchor=north, legend columns=2}',
      '      ]'
    ].concat(plotLines).concat([
      '      \\legend{' + legend.map(function (s) { return s; }).join(', ') + '}',
      '      \\end{axis}',
      '    \\end{tikzpicture}',
      '  \\end{minipage}\\hfill',
      '  \\begin{minipage}[c]{0.42\\textwidth}',
      '    \\small',
      '    \\textbf{Matrix}\\\\',
      '    $A = ' + parsed.latexA + bMatrixLine + '$',
      '    \\par\\vspace{0.5em}',
      '    \\textbf{Operation}\\\\',
      '    ' + (parsed.opLabel || op),
      '    \\par\\vspace{0.5em}',
      '    \\textbf{Result}\\\\',
      '    $\\displaystyle ' + resultLatex + '$',
      '    \\par\\vspace{0.5em}',
      '    \\textbf{Geometric meaning}\\\\',
      '    ' + caption,
      '  \\end{minipage}',
      '  \\caption{Geometric interpretation of $' + (parsed.opLabel || op) + '$ on the unit square.}',
      '\\end{figure}',
      ''
    ]).join('\n');
  }

  function appendGraphBlock(cm, anchorMark, parsed, result, type) {
    // Auto-inject preamble packages into the MAIN document — they need to
    // be available when solutions.tex compiles via \input{solutions}.
    var preamble = [
      '\\usepackage{pgfplots}',
      '\\pgfplotsset{compat=1.18}',
      '\\usepackage{float}'
    ];
    if (type === 'matrix') {
      // Eigenvector arrows use TikZ's `arrows.meta` library.
      preamble.push('\\usetikzlibrary{arrows.meta}');
    }
    ensurePreambleLines(cm, preamble);
    var anchorPos = anchorMark ? anchorMark.find() : null;
    if (anchorMark) anchorMark.clear();
    var block;
    if (type === 'integral')        block = buildIntegralGraphBlock(parsed, result);
    else if (type === 'derivative') block = buildDerivativeGraphBlock(parsed, result);
    else if (type === 'matrix')     block = buildMatrixGraphBlock(parsed, result);
    else                            block = buildLimitGraphBlock(parsed, result);
    if (!block) return null;
    if (window.SolutionsFile && typeof window.SolutionsFile.append === 'function') {
      return window.SolutionsFile.append(cm, '% Show graph\n' + block,
                                         { inputAnchor: anchorPos });
    }
    var pos = anchorPos || cm.getCursor('to');
    var line = pos.line;
    if (line >= cm.lineCount()) line = cm.lineCount() - 1;
    var lineEnd = { line: line, ch: cm.getLine(line).length };
    cm.replaceRange(block, lineEnd, lineEnd);
    cm.focus();
    return null;
  }

  function solve(detected, mode) {
    mode = mode || 'simple';
    var cm = window.editorInstance;
    if (!cm || !detected) return;

    var anchorMark = cm.setBookmark(cm.getCursor('to'));

    // Compact human-readable form of what we're operating on, used in toasts
    // so the user can verify the right expression was processed.
    function shortLabel() {
      var src = (detected.parsed && detected.parsed.bodyLatex) || detected.latex || '';
      var s = src.replace(/\s+/g, ' ').trim();
      if (s.length > 32) s = s.substring(0, 30) + '…';
      return s;
    }

    function handleResult(solveResult) {
      if (!solveResult || !solveResult.ok) {
        if (anchorMark) anchorMark.clear();
        toast('Error', (solveResult && solveResult.error) || 'Could not solve');
        return;
      }
      var methodNote = solveResult.method ? ' [' + solveResult.method + ']' : '';
      var what = shortLabel();
      var newFile = null;

      // Code runner uses its own output-block builder (stdout / stderr boxes).
      if (detected.type === 'code') {
        newFile = appendCodeOutputBlock(cm, anchorMark, detected, solveResult);
        var p = detected.parsed;
        var label = (p.languageLabel || p.language) +
                    (p.isMulti ? (' · ' + p.files.length + ' files') : '') +
                    ' · exit ' + solveResult.exitCode +
                    (solveResult.duration ? (' · ' + solveResult.duration + 's') : '');
        var toastKind = solveResult.exitCode === 0 ? 'Success' : 'Warning';
        toast(toastKind, '▶ Run: ' + label + (newFile ? ' → ' + newFile : ''));
        return;
      }
      // Matrix ops: use sympySteps in steps mode; no pgfplots graph (matrix
      // visualisations don't translate cleanly to pgfplots) — fall back to
      // the inline result.
      var steps = solveResult.steps && solveResult.steps.length
        ? solveResult.steps
        : (solveResult.sympySteps || []);

      if (mode === 'graph') {
        // Matrix viz reads cells + op from detected.parsed; the second arg
        // is the whole solveResult so the right-hand caption can show the
        // result LaTeX. Limit/integral/derivative cores already package
        // their plot inputs into solveResult.input/.result.
        var graphInput = (detected.type === 'matrix')
          ? detected.parsed
          : solveResult.input;
        var graphResult = (detected.type === 'matrix')
          ? solveResult
          : solveResult.result;
        newFile = appendGraphBlock(cm, anchorMark, graphInput, graphResult, detected.type);
        if (newFile === null && detected.type === 'matrix') {
          // 2D-viz refused (3D matrix, symbolic cells, etc.) — fall back
          // to the inline result so the user still gets *something*.
          newFile = appendResultInline(cm, null, detected, solveResult.resultLatex);
          toast('Warning', 'Geometric viz needs a 2x2 numeric matrix — inserted result instead');
        } else {
          toast('Success', 'Graph: ' + what + methodNote + (newFile ? ' → ' + newFile : ''));
        }
      } else if (mode === 'steps' && steps.length > 0) {
        newFile = appendStepsBlock(cm, anchorMark, steps, solveResult.method, detected.type);
        toast('Success', steps.length + ' steps for: ' + what + methodNote + (newFile ? ' → ' + newFile : ''));
      } else {
        newFile = appendResultInline(cm, anchorMark, detected, solveResult.resultLatex);
        toast('Success', 'Solved: ' + what + methodNote + (newFile ? ' → ' + newFile : ''));
      }
    }

    // For code blocks, anchor on the LAST block in the multi-file group so
    // the output lands after the whole group, not between blocks. The
    // selection's 'to' cursor only sees the user's drag end, which may be
    // before the group's last block.
    if (detected.type === 'code' && detected.parsed && detected.parsed.blocks &&
        detected.parsed.blocks.length) {
      try {
        var selFrom = cm.getCursor('from');
        var selText = cm.getSelection() || '';
        var lastBlock = detected.parsed.blocks[detected.parsed.blocks.length - 1];
        // count newlines in the selection up to and including \end{lstlisting} of last block
        var marker = '\\end{lstlisting}';
        var lastEndIdx = selText.lastIndexOf(marker);
        if (lastEndIdx >= 0) {
          var upTo = selText.substring(0, lastEndIdx + marker.length);
          var newlines = (upTo.match(/\n/g) || []).length;
          var anchorLine = selFrom.line + newlines;
          if (anchorLine < 0) anchorLine = 0;
          if (anchorLine >= cm.lineCount()) anchorLine = cm.lineCount() - 1;
          anchorMark.clear();
          anchorMark = cm.setBookmark({ line: anchorLine, ch: cm.getLine(anchorLine).length });
        }
      } catch (e) { /* fall back to default anchor */ }
    }

    var pending;
    try {
      if (detected.type === 'limit')           pending = solveLimit(detected, mode);
      else if (detected.type === 'integral')   pending = solveIntegral(detected, mode);
      else if (detected.type === 'derivative') pending = solveDerivative(detected, mode);
      else if (detected.type === 'matrix')     pending = solveMatrix(detected, mode);
      else if (detected.type === 'code')       pending = solveCode(detected, mode);
      else { anchorMark.clear(); toast('Error', 'Unknown math type: ' + detected.type); return; }
    } catch (e) {
      anchorMark.clear();
      toast('Error', 'Solve failed: ' + (e && e.message || e));
      return;
    }

    // Promise-based path (integrals): show "Solving…" only if it takes
    // longer than ~700ms. Most nerdamer solves resolve in <100ms, so the
    // user just sees the success toast directly.
    if (pending && typeof pending.then === 'function') {
      var slowTimer = setTimeout(function () {
        toast('Success', 'Solving, this might take a few seconds…');
      }, 700);
      pending.then(function (r) { clearTimeout(slowTimer); handleResult(r); },
                   function (err) {
                     clearTimeout(slowTimer);
                     if (anchorMark) anchorMark.clear();
                     toast('Error', 'Solve failed: ' + (err && err.message || err));
                   });
    } else {
      handleResult(pending);
    }
  }

  window.MathInsert = {
    detect: detect,
    solve: solve
  };
})();
