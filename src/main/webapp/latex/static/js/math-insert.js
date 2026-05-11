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

  function appendResultInline(cm, anchorMark, detected, resultLatex) {
    var anchorPos = anchorMark ? anchorMark.find() : null;
    if (anchorMark) anchorMark.clear();
    if (!window.SolutionsFile || typeof window.SolutionsFile.append !== 'function') {
      var pos = anchorPos || cm.getCursor('to');
      cm.replaceRange(' = ' + resultLatex, pos, pos);
      cm.focus();
      return null;
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

  function appendStepsBlock(cm, anchorMark, steps, methodLabel) {
    var anchorPos = anchorMark ? anchorMark.find() : null;
    if (anchorMark) anchorMark.clear();
    var block = buildStepsBlock(steps, methodLabel);
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

  function appendGraphBlock(cm, anchorMark, parsed, result, type) {
    // Auto-inject preamble packages into the MAIN document — they need to
    // be available when solutions.tex compiles via \input{solutions}.
    ensurePreambleLines(cm, [
      '\\usepackage{pgfplots}',
      '\\pgfplotsset{compat=1.18}',
      '\\usepackage{float}'
    ]);
    var anchorPos = anchorMark ? anchorMark.find() : null;
    if (anchorMark) anchorMark.clear();
    var block;
    if (type === 'integral')        block = buildIntegralGraphBlock(parsed, result);
    else if (type === 'derivative') block = buildDerivativeGraphBlock(parsed, result);
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
      if (mode === 'graph') {
        newFile = appendGraphBlock(cm, anchorMark, solveResult.input, solveResult.result, detected.type);
        toast('Success', 'Graph: ' + what + methodNote + (newFile ? ' → ' + newFile : ''));
      } else if (mode === 'steps' && solveResult.steps && solveResult.steps.length > 0) {
        newFile = appendStepsBlock(cm, anchorMark, solveResult.steps, solveResult.method);
        toast('Success', solveResult.steps.length + ' steps for: ' + what + methodNote + (newFile ? ' → ' + newFile : ''));
      } else {
        newFile = appendResultInline(cm, anchorMark, detected, solveResult.resultLatex);
        toast('Success', 'Solved: ' + what + methodNote + (newFile ? ' → ' + newFile : ''));
      }
    }

    var pending;
    try {
      if (detected.type === 'limit')           pending = solveLimit(detected, mode);
      else if (detected.type === 'integral')   pending = solveIntegral(detected, mode);
      else if (detected.type === 'derivative') pending = solveDerivative(detected, mode);
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
