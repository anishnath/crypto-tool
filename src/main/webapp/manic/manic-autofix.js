/* manic auto-correct — pure fix-application loop, shared by the editor and its
 * test. Given source + a `check` function (source -> array of diagnostics, each
 * optionally carrying `fix{start,len,replacement}`), apply every mechanical fix
 * (glued `*`, nearest name, …) and return { code, fixed }.
 *
 * Fixes are applied from the END of the file backwards so earlier byte offsets
 * stay valid, overlaps within a pass are skipped, and the whole thing repeats
 * because one fix can reveal the next: `check` bails on the first expand error,
 * so a line with many glued names (a loop body) heals one fix per pass. The pass
 * cap is only a runaway backstop — the loop exits the moment a pass applies no
 * fix, which is the normal terminal case.
 *
 * Works in the browser (window.ManicAutofix) and in Node (module.exports) so it
 * can be unit-tested without Monaco or the WASM.
 */
(function (root) {
  'use strict';

  // ---- syntactic normalizers -------------------------------------------------
  // Some mistakes can't be expressed as a check() offset-fix because they break
  // LEXING (parsing halts before the argument is even seen), so check() can only
  // report the first one with no clickable fix. `equation`/`rewrite` take their
  // math as a STRING, and a common model slip is leaving it BARE — either LaTeX
  // (`\frac12`, `\cdots`) which is a lex error, or a plain number/operator/
  // expression (`1`, `+`, `S=1+2+3`) which is the wrong slot. We wrap every such
  // bare argument in backticks up front, textually, so the whole file heals in one
  // shot instead of whack-a-mole. Backticks are raw, so all backslashes survive.

  // A lone identifier might be a `let` variable holding the string — never wrap it.
  function looksBare(content) {
    var s = content.trim();
    if (!s) return false;
    if (s.charAt(0) === '`' || s.charAt(0) === '"') return false; // already a string
    if (/^[A-Za-z_]\w*$/.test(s)) return false;                    // a bare variable ref
    return true;
  }

  // Peel a trailing numeric arg (equation `size`, or rewrite `dur[, ease]`) off the
  // middle so we wrap only the math content, not the whole tail.
  function splitTail(mid, isRewrite) {
    var re = isRewrite
      ? /^([\s\S]*?)(\s*,\s*[0-9.]+\s*(?:,\s*[A-Za-z_]\w*\s*)?)$/
      : /^([\s\S]*?)(\s*,\s*[0-9.]+\s*)$/;
    var m = re.exec(mid);
    return m ? [m[1], m[2]] : [mid, ''];
  }

  var EQ_LINE = /^(\s*equation\s*\(\s*[A-Za-z_]\w*\s*,\s*\([^()]*\)\s*,\s*)([\s\S]*?)(\)\s*;?\s*)$/;
  var RW_LINE = /^(\s*rewrite\s*\(\s*[A-Za-z_]\w*\s*,\s*)([\s\S]*?)(\)\s*;?\s*)$/;

  function wrapLatexLine(line) {
    var isRewrite = false;
    var m = EQ_LINE.exec(line);
    if (!m) { m = RW_LINE.exec(line); isRewrite = true; }
    if (!m) return line;
    var pre = m[1], parts = splitTail(m[2], isRewrite), post = m[3];
    var content = parts[0].trim();
    if (!looksBare(content)) return line;
    return pre + '`' + content + '`' + parts[1] + post;
  }

  // Wrap bare `equation`/`rewrite` math arguments in backticks (idempotent).
  function wrapBareLatex(code) {
    return String(code == null ? '' : code)
      .split('\n')
      .map(wrapLatexLine)
      .join('\n');
  }

  // opts.includeRemovals (default true): when false, DESTRUCTIVE fixes — those
  // whose replacement is empty, i.e. they delete code (a stray-token removal) —
  // are skipped. The silent post-AI auto-apply passes false so it only ever does
  // safe replacements (glued `*`, typos); the user-triggered "Auto-fix" leaves it
  // true so an explicit click can also strip garbage.
  function applyFixes(code, check, opts) {
    var src = String(code == null ? '' : code);
    var includeRemovals = !opts || opts.includeRemovals !== false;
    var total = 0;
    // Syntactic pre-pass: wrap bare equation/rewrite LaTeX (heals lex errors that
    // check() can't offset-fix). Non-destructive, so it runs even in the silent
    // post-AI pass. Count it toward `fixed` when it changes anything.
    if (!opts || opts.wrapLatex !== false) {
      var wrapped = wrapBareLatex(src);
      if (wrapped !== src) { total++; src = wrapped; }
    }
    for (var pass = 0; pass < 40; pass++) {
      var errs;
      try { errs = check(src) || []; } catch (e) { break; }
      var fixes = [];
      for (var i = 0; i < errs.length; i++) {
        var f = errs[i] && errs[i].fix;
        if (!f || f.replacement == null || typeof f.start !== 'number') continue;
        if (!includeRemovals && f.replacement === '') continue; // skip destructive removals
        fixes.push(f);
      }
      if (!fixes.length) break;
      fixes.sort(function (a, b) { return b.start - a.start; }); // last → first
      var applied = 0, guard = Infinity;
      for (var j = 0; j < fixes.length; j++) {
        var fx = fixes[j], end = fx.start + (fx.len || 0);
        if (fx.start < 0 || end > src.length || end > guard) continue; // OOB or overlaps a fix already applied
        src = src.slice(0, fx.start) + fx.replacement + src.slice(end);
        guard = fx.start;
        applied++;
      }
      total += applied;
      if (!applied) break;
    }
    return { code: src, fixed: total };
  }

  var api = { applyFixes: applyFixes, wrapBareLatex: wrapBareLatex };
  if (typeof module !== 'undefined' && module.exports) module.exports = api;
  else root.ManicAutofix = api;
})(typeof self !== 'undefined' ? self : this);
