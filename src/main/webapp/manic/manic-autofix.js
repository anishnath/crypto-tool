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

  function applyFixes(code, check) {
    var src = String(code == null ? '' : code);
    var total = 0;
    for (var pass = 0; pass < 40; pass++) {
      var errs;
      try { errs = check(src) || []; } catch (e) { break; }
      var fixes = [];
      for (var i = 0; i < errs.length; i++) {
        var f = errs[i] && errs[i].fix;
        if (f && f.replacement != null && typeof f.start === 'number') fixes.push(f);
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

  var api = { applyFixes: applyFixes };
  if (typeof module !== 'undefined' && module.exports) module.exports = api;
  else root.ManicAutofix = api;
})(typeof self !== 'undefined' ? self : this);
