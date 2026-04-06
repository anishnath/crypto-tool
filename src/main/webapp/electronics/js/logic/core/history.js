/* ═══════════════════════════════════════════════════════════
   Logic Simulator — Undo/Redo History (Phase 11)
   Snapshot-based: saves circuit JSON before each mutation.
   ═══════════════════════════════════════════════════════════ */
(function (L) {
  'use strict';

  class History {
    constructor(maxSize) {
      this.stack    = [];
      this.index    = -1;
      this.maxSize  = maxSize || 50;
      this._locked  = false; // prevent recording during undo/redo
    }

    /** Save a snapshot (call before mutations) */
    push(circuitJSON) {
      if (this._locked) return;
      // Truncate any redo states
      this.stack.length = this.index + 1;
      this.stack.push(JSON.stringify(circuitJSON));
      if (this.stack.length > this.maxSize) this.stack.shift();
      this.index = this.stack.length - 1;
    }

    /** Undo: return previous snapshot JSON, or null */
    undo() {
      if (this.index <= 0) return null;
      this.index--;
      return JSON.parse(this.stack[this.index]);
    }

    /** Redo: return next snapshot JSON, or null */
    redo() {
      if (this.index >= this.stack.length - 1) return null;
      this.index++;
      return JSON.parse(this.stack[this.index]);
    }

    canUndo() { return this.index > 0; }
    canRedo() { return this.index < this.stack.length - 1; }

    /** Lock/unlock to prevent recording during restore */
    lock()   { this._locked = true; }
    unlock() { this._locked = false; }

    clear() { this.stack = []; this.index = -1; }
  }

  L.History = History;
})(window.LogicSim);
