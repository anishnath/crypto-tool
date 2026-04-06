/* ═══════════════════════════════════════════════════════════
   Logic Simulator — 4-State Value System
   States: 0 (FALSE), 1 (TRUE), X (UNKNOWN), E (ERROR)
   ═══════════════════════════════════════════════════════════ */
window.LogicSim = window.LogicSim || {};

(function (L) {
  'use strict';

  /* ── Bit-level states ── */
  const FALSE = 0, TRUE = 1, UNKNOWN = 2, ERROR = 3;

  /* ── Single-bit logic ── */
  function and(a, b) {
    if (a === FALSE || b === FALSE) return FALSE;
    if (a === TRUE  && b === TRUE)  return TRUE;
    if (a === ERROR || b === ERROR) return ERROR;
    return UNKNOWN;
  }
  function or(a, b) {
    if (a === TRUE  || b === TRUE)  return TRUE;
    if (a === FALSE && b === FALSE) return FALSE;
    if (a === ERROR || b === ERROR) return ERROR;
    return UNKNOWN;
  }
  function xor(a, b) {
    if (a === ERROR || b === ERROR) return ERROR;
    if (a === UNKNOWN || b === UNKNOWN) return UNKNOWN;
    return a === b ? FALSE : TRUE;
  }
  function not(a) {
    if (a === TRUE)  return FALSE;
    if (a === FALSE) return TRUE;
    if (a === ERROR) return ERROR;
    return UNKNOWN;
  }

  /* ── Multi-bit Value ── */
  class Value {
    /**
     * @param {number} width  - bit count (1–32)
     * @param {number} bits   - value bits
     * @param {number} unk    - unknown mask (1 = unknown, both bits set = error)
     */
    constructor(width, bits, unk) {
      this.width   = width;
      const mask   = width < 32 ? ((1 << width) - 1) >>> 0 : 0xFFFFFFFF;
      this.bits    = (bits | 0) & mask;
      this.unknown = (unk  | 0) & mask;
    }

    /* Singletons */
    static get ZERO()    { return _ZERO; }
    static get ONE()     { return _ONE; }
    static get X()       { return _X; }
    static get E()       { return _E; }

    /* Factories */
    static of(state) {
      switch (state) {
        case FALSE:   return _ZERO;
        case TRUE:    return _ONE;
        case UNKNOWN: return _X;
        default:      return _E;
      }
    }
    static zero(w)    { return new Value(w, 0, 0); }
    static ones(w)    { return new Value(w, (1 << w) - 1, 0); }
    static unknown(w) { return new Value(w, 0, (1 << w) - 1); }
    static fromInt(w, n) { return new Value(w, n, 0); }

    /* Per-bit access */
    get(bit) {
      const b = (this.bits >> bit) & 1;
      const u = (this.unknown >> bit) & 1;
      if (u && b) return ERROR;
      if (u)      return UNKNOWN;
      return b ? TRUE : FALSE;
    }

    /* Predicates (single-bit fast path) */
    isTrue()    { return this.width === 1 && this.bits === 1 && this.unknown === 0; }
    isFalse()   { return this.width === 1 && this.bits === 0 && this.unknown === 0; }
    isKnown()   { return this.unknown === 0; }
    equals(o)   { return o && this.width === o.width && this.bits === o.bits && this.unknown === o.unknown; }

    /* Multi-bit operations — return new Value */
    and(b)  { return _bitwiseOp(this, b, and); }
    or(b)   { return _bitwiseOp(this, b, or); }
    xor(b)  { return _bitwiseOp(this, b, xor); }
    not()   { return _unaryOp(this, not); }

    /* Display */
    toString() {
      if (this.width === 1) return ['0','1','X','E'][this.get(0)];
      let s = '';
      for (let i = this.width - 1; i >= 0; i--) s += ['0','1','X','E'][this.get(i)];
      return s;
    }
    toInt() { return this.unknown ? NaN : this.bits; }

    /* Color for rendering */
    color() {
      if (this.width === 1) {
        const s = this.get(0);
        if (s === TRUE)    return '#22c55e'; // green
        if (s === FALSE)   return '#64748b'; // gray
        if (s === UNKNOWN) return '#3b82f6'; // blue
        return '#ef4444'; // red = error
      }
      if (this.unknown) return '#3b82f6';
      return '#22c55e';
    }
  }

  function _bitwiseOp(a, b, fn) {
    const w = Math.max(a.width, b.width);
    let bits = 0, unk = 0;
    for (let i = 0; i < w; i++) {
      const r = fn(a.get(i), b.get(i));
      if (r === TRUE)    bits |= (1 << i);
      if (r === UNKNOWN) unk  |= (1 << i);
      if (r === ERROR)   { bits |= (1 << i); unk |= (1 << i); }
    }
    return new Value(w, bits, unk);
  }
  function _unaryOp(a, fn) {
    const w = a.width;
    let bits = 0, unk = 0;
    for (let i = 0; i < w; i++) {
      const r = fn(a.get(i));
      if (r === TRUE)    bits |= (1 << i);
      if (r === UNKNOWN) unk  |= (1 << i);
      if (r === ERROR)   { bits |= (1 << i); unk |= (1 << i); }
    }
    return new Value(w, bits, unk);
  }

  const _ZERO = new Value(1, 0, 0);
  const _ONE  = new Value(1, 1, 0);
  const _X    = new Value(1, 0, 1);
  const _E    = new Value(1, 1, 1);

  /* Exports */
  L.Value   = Value;
  L.FALSE   = FALSE;
  L.TRUE    = TRUE;
  L.UNKNOWN = UNKNOWN;
  L.ERROR   = ERROR;
  L.Logic   = { and, or, xor, not };
})(window.LogicSim);
