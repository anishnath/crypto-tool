/* ═══════════════════════════════════════════════════════════
   Logic Simulator — Analysis Engine (Phase 6)
   Truth table, SOP/POS expressions, Quine-McCluskey minimize,
   Karnaugh map data generation.
   ═══════════════════════════════════════════════════════════ */
(function (L) {
  'use strict';

  const { Value, FALSE, TRUE, UNKNOWN } = L;

  class Analyzer {
    constructor(circuit) {
      this.circuit = circuit;
    }

    /* ── Find INPUT / OUTPUT pins (sorted by label or creation order) ── */
    getInputs() {
      const list = [];
      for (const c of this.circuit.components.values()) {
        if (c.type === 'INPUT') list.push(c);
      }
      list.sort((a, b) => (a.attrs.label || a.id).localeCompare(b.attrs.label || b.id));
      return list;
    }

    getOutputs() {
      const list = [];
      for (const c of this.circuit.components.values()) {
        if (c.type === 'OUTPUT') list.push(c);
      }
      list.sort((a, b) => (a.attrs.label || a.id).localeCompare(b.attrs.label || b.id));
      return list;
    }

    /* Variable names for inputs */
    varNames(inputs) {
      return inputs.map((c, i) => c.attrs.label || String.fromCharCode(65 + i));
    }

    /* ═══════════ Truth Table ═══════════ */
    generateTruthTable(maxInputs) {
      maxInputs = maxInputs || 10;
      const inputs  = this.getInputs();
      const outputs = this.getOutputs();
      if (inputs.length === 0) return null;
      if (inputs.length > maxInputs) return { error: 'Too many inputs (max ' + maxInputs + ')' };

      const n = inputs.length;
      const names = this.varNames(inputs);
      const outNames = outputs.map((c, i) => c.attrs.label || 'Q' + i);

      // Save original states
      const origStates = inputs.map(c => c.attrs.state);

      const rows = [];
      for (let combo = 0; combo < (1 << n); combo++) {
        // Set input combination (MSB = first input)
        for (let j = 0; j < n; j++) {
          inputs[j].attrs.state = (combo >> (n - 1 - j)) & 1 ? TRUE : FALSE;
        }
        this.circuit.propagate();

        // Record
        const inVals  = [];
        for (let j = 0; j < n; j++) inVals.push((combo >> (n - 1 - j)) & 1);
        const outVals = outputs.map(c => c.ports[0].value.get(0) === TRUE ? 1 : 0);
        rows.push({ in: inVals, out: outVals });
      }

      // Restore
      inputs.forEach((c, i) => { c.attrs.state = origStates[i]; });
      this.circuit.propagate();

      return { inputNames: names, outputNames: outNames, rows, numInputs: n };
    }

    /* ═══════════ SOP Expression (from truth table) ═══════════ */
    extractSOP(tt, outputIdx) {
      if (!tt || tt.error) return '';
      outputIdx = outputIdx || 0;
      const names = tt.inputNames;
      const minterms = [];

      for (let i = 0; i < tt.rows.length; i++) {
        if (tt.rows[i].out[outputIdx] === 1) minterms.push(i);
      }

      if (minterms.length === 0) return '0';
      if (minterms.length === tt.rows.length) return '1';

      // Unminimized SOP
      const terms = minterms.map(m => {
        const parts = [];
        for (let j = 0; j < tt.numInputs; j++) {
          const bit = (m >> (tt.numInputs - 1 - j)) & 1;
          parts.push(bit ? names[j] : '\u00AC' + names[j]);
        }
        return parts.join('\u00B7');
      });
      return terms.join(' + ');
    }

    /* ═══════════ Quine-McCluskey Minimization ═══════════ */
    minimize(tt, outputIdx) {
      if (!tt || tt.error) return { expr: '', primes: [] };
      outputIdx = outputIdx || 0;
      const n = tt.numInputs;
      const names = tt.inputNames;
      const minterms = [];

      for (let i = 0; i < tt.rows.length; i++) {
        if (tt.rows[i].out[outputIdx] === 1) minterms.push(i);
      }

      if (minterms.length === 0) return { expr: '0', primes: [] };
      if (minterms.length === tt.rows.length) return { expr: '1', primes: [] };

      const primes = this._findPrimeImplicants(minterms, n);
      const essential = this._selectEssentialPrimes(primes, minterms, n);

      // Format expression
      const expr = essential.map(p => this._termToString(p, names, n)).join(' + ');
      return { expr: expr || '0', primes: essential };
    }

    _findPrimeImplicants(minterms, numVars) {
      // Represent terms as { bits, mask, minterms }
      let terms = minterms.map(m => ({ bits: m, mask: 0, minterms: [m] }));
      const allPrimes = [];

      while (terms.length > 0) {
        // Group by popcount of unmasked bits
        const groups = new Map();
        for (const t of terms) {
          const pc = _popcount(t.bits & ~t.mask);
          if (!groups.has(pc)) groups.set(pc, []);
          groups.get(pc).push(t);
        }

        const newTerms = [];
        const combined = new Set();
        const seen = new Set();
        const sortedKeys = [...groups.keys()].sort((a, b) => a - b);

        for (let ki = 0; ki < sortedKeys.length - 1; ki++) {
          const g1 = groups.get(sortedKeys[ki]) || [];
          const g2 = groups.get(sortedKeys[ki] + 1) || [];
          for (const t1 of g1) {
            for (const t2 of g2) {
              if (t1.mask !== t2.mask) continue;
              const diff = t1.bits ^ t2.bits;
              if (_popcount(diff) === 1) {
                const key = (t1.bits & ~diff) + '/' + (t1.mask | diff);
                if (!seen.has(key)) {
                  seen.add(key);
                  newTerms.push({
                    bits: t1.bits & ~diff,
                    mask: t1.mask | diff,
                    minterms: [...new Set([...t1.minterms, ...t2.minterms])]
                  });
                }
                combined.add(t1.bits + '/' + t1.mask);
                combined.add(t2.bits + '/' + t2.mask);
              }
            }
          }
        }

        // Uncombined terms are prime implicants
        for (const t of terms) {
          if (!combined.has(t.bits + '/' + t.mask)) allPrimes.push(t);
        }
        terms = newTerms;
      }

      return allPrimes;
    }

    _selectEssentialPrimes(primes, minterms, numVars) {
      if (primes.length === 0) return [];

      const uncovered = new Set(minterms);
      const selected = [];

      // Find essential primes (only prime covering some minterm)
      for (const m of minterms) {
        const covering = primes.filter(p => p.minterms.includes(m));
        if (covering.length === 1) {
          if (!selected.includes(covering[0])) {
            selected.push(covering[0]);
            covering[0].minterms.forEach(cm => uncovered.delete(cm));
          }
        }
      }

      // Greedy cover remaining
      while (uncovered.size > 0) {
        let best = null, bestCount = 0;
        for (const p of primes) {
          if (selected.includes(p)) continue;
          const count = p.minterms.filter(m => uncovered.has(m)).length;
          if (count > bestCount) { best = p; bestCount = count; }
        }
        if (!best) break;
        selected.push(best);
        best.minterms.forEach(m => uncovered.delete(m));
      }

      return selected;
    }

    _termToString(term, names, numVars) {
      const parts = [];
      for (let i = 0; i < numVars; i++) {
        const bitPos = numVars - 1 - i;
        if ((term.mask >> bitPos) & 1) continue; // don't-care
        const bit = (term.bits >> bitPos) & 1;
        parts.push(bit ? names[i] : '\u00AC' + names[i]);
      }
      return parts.length > 0 ? parts.join('\u00B7') : '1';
    }

    /* ═══════════ Karnaugh Map Data ═══════════ */
    generateKMap(tt, outputIdx) {
      if (!tt || tt.error) return null;
      outputIdx = outputIdx || 0;
      const n = tt.numInputs;
      if (n < 2 || n > 4) return null; // K-map only for 2-4 vars

      const names = tt.inputNames;
      const gray2 = [0, 1, 3, 2];
      const gray1 = [0, 1];
      let rowBits, colBits, rowLabels, colLabels, rowVars, colVars;

      if (n === 2) {
        rowBits = gray1; colBits = gray1;
        rowVars = [names[0]]; colVars = [names[1]];
      } else if (n === 3) {
        rowBits = gray1; colBits = gray2;
        rowVars = [names[0]]; colVars = [names[1], names[2]];
      } else { // n === 4
        rowBits = gray2; colBits = gray2;
        rowVars = [names[0], names[1]]; colVars = [names[2], names[3]];
      }

      // Build grid
      const rows = rowBits.length, cols = colBits.length;
      const grid = [];
      for (let r = 0; r < rows; r++) {
        const row = [];
        for (let c = 0; c < cols; c++) {
          let idx;
          if (n === 2)      idx = (rowBits[r] << 1) | colBits[c];
          else if (n === 3) idx = (rowBits[r] << 2) | colBits[c];
          else              idx = (rowBits[r] << 2) | colBits[c];
          row.push(tt.rows[idx].out[outputIdx]);
        }
        grid.push(row);
      }

      // Row/col header labels
      rowLabels = rowBits.map(b => {
        const parts = [];
        for (let i = rowVars.length - 1; i >= 0; i--) parts.push((b >> i) & 1);
        return parts.join('');
      });
      colLabels = colBits.map(b => {
        const parts = [];
        for (let i = colVars.length - 1; i >= 0; i--) parts.push((b >> i) & 1);
        return parts.join('');
      });

      return { grid, rowLabels, colLabels, rowVars, colVars, numVars: n };
    }
  }

  /* ── Utility ── */
  function _popcount(n) {
    n = n - ((n >> 1) & 0x55555555);
    n = (n & 0x33333333) + ((n >> 2) & 0x33333333);
    return (((n + (n >> 4)) & 0x0F0F0F0F) * 0x01010101) >> 24;
  }

  L.Analyzer = Analyzer;
})(window.LogicSim);
