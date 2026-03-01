/* hexdump-editor.js — Pure editing logic (no DOM)
   Exposes: window.HexEditor */
(function() {
    'use strict';

    var HexEditor = {};
    var MAX_UNDO = 1000;

    var data = [];           // mutable Array of byte values (0-255)
    var originalData = null;  // Uint8Array snapshot of original
    var undoStack = [];
    var redoStack = [];
    var modifiedSet = new Set();

    /**
     * Initialize editor with data.
     * @param {Uint8Array} inputData
     */
    HexEditor.init = function(inputData) {
        originalData = new Uint8Array(inputData);
        data = [];
        for (var i = 0; i < inputData.length; i++) {
            data[i] = inputData[i];
        }
        undoStack = [];
        redoStack = [];
        modifiedSet = new Set();
    };

    /**
     * Set a byte at index to a new value.
     * @param {number} idx
     * @param {number} val - 0..255
     */
    HexEditor.setByte = function(idx, val) {
        if (idx < 0 || idx >= data.length) return;
        var oldVal = data[idx];
        if (oldVal === val) return;
        pushUndo({ type: 'set', idx: idx, oldVal: oldVal, newVal: val });
        data[idx] = val;
        rebuildModifiedSet();
    };

    /**
     * Insert a byte at position, shifting subsequent bytes right.
     * @param {number} idx
     * @param {number} val - 0..255
     */
    HexEditor.insertByte = function(idx, val) {
        if (idx < 0 || idx > data.length) return;
        pushUndo({ type: 'insert', idx: idx, newVal: val });
        data.splice(idx, 0, val);
        rebuildModifiedSet();
    };

    /**
     * Delete byte at position, shifting subsequent bytes left.
     * @param {number} idx
     */
    HexEditor.deleteByte = function(idx) {
        if (idx < 0 || idx >= data.length) return;
        var oldVal = data[idx];
        pushUndo({ type: 'delete', idx: idx, oldVal: oldVal });
        data.splice(idx, 1);
        rebuildModifiedSet();
    };

    /**
     * Undo last operation.
     * @returns {boolean} true if undo was performed
     */
    HexEditor.undo = function() {
        if (undoStack.length === 0) return false;
        var op = undoStack.pop();
        redoStack.push(op);
        applyReverse(op);
        rebuildModifiedSet();
        return true;
    };

    /**
     * Redo last undone operation.
     * @returns {boolean} true if redo was performed
     */
    HexEditor.redo = function() {
        if (redoStack.length === 0) return false;
        var op = redoStack.pop();
        undoStack.push(op);
        applyForward(op);
        rebuildModifiedSet();
        return true;
    };

    /**
     * Get current data as Uint8Array.
     * @returns {Uint8Array}
     */
    HexEditor.getData = function() {
        return new Uint8Array(data);
    };

    /**
     * Get the current data array length.
     * @returns {number}
     */
    HexEditor.getLength = function() {
        return data.length;
    };

    /**
     * Get byte value at index from current data.
     * @param {number} idx
     * @returns {number}
     */
    HexEditor.getByte = function(idx) {
        return data[idx];
    };

    /**
     * Get original unmodified data.
     * @returns {Uint8Array}
     */
    HexEditor.getOriginal = function() {
        return originalData;
    };

    /**
     * Check if data has been modified.
     * @returns {boolean}
     */
    HexEditor.isModified = function() {
        return undoStack.length > 0 || data.length !== originalData.length;
    };

    /**
     * Get set of indices that differ from original.
     * @returns {Set<number>}
     */
    HexEditor.getModifiedIndices = function() {
        return modifiedSet;
    };

    /**
     * Get edit count (undo stack size).
     * @returns {number}
     */
    HexEditor.getEditCount = function() {
        return undoStack.length;
    };

    /**
     * Check if undo is available.
     * @returns {boolean}
     */
    HexEditor.canUndo = function() {
        return undoStack.length > 0;
    };

    /**
     * Check if redo is available.
     * @returns {boolean}
     */
    HexEditor.canRedo = function() {
        return redoStack.length > 0;
    };

    /**
     * Discard all edits, restore original data.
     */
    HexEditor.reset = function() {
        if (!originalData) return;
        data = [];
        for (var i = 0; i < originalData.length; i++) {
            data[i] = originalData[i];
        }
        undoStack = [];
        redoStack = [];
        modifiedSet = new Set();
    };

    /**
     * Parse a string as a byte value in the given format.
     * @param {string} str - user input
     * @param {string} fmt - 'hex' | 'dec' | 'oct' | 'bin'
     * @returns {number} 0..255 or -1 if invalid
     */
    HexEditor.parseByte = function(str, fmt) {
        str = str.trim();
        if (!str) return -1;
        var val;
        switch (fmt) {
            case 'dec':
                val = parseInt(str, 10);
                break;
            case 'oct':
                val = parseInt(str, 8);
                break;
            case 'bin':
                val = parseInt(str, 2);
                break;
            default: // hex
                val = parseInt(str, 16);
                break;
        }
        if (isNaN(val) || val < 0 || val > 255) return -1;
        return val;
    };

    /**
     * Get max input length for the current format.
     * @param {string} fmt
     * @returns {number}
     */
    HexEditor.getMaxInputLen = function(fmt) {
        switch (fmt) {
            case 'bin': return 8;
            case 'oct': return 3;
            case 'dec': return 3;
            default:    return 2; // hex
        }
    };

    // === Internal helpers ===

    function pushUndo(op) {
        undoStack.push(op);
        if (undoStack.length > MAX_UNDO) {
            undoStack.shift();
        }
        redoStack = []; // clear redo on new edit
    }

    function applyForward(op) {
        switch (op.type) {
            case 'set':
                data[op.idx] = op.newVal;
                break;
            case 'insert':
                data.splice(op.idx, 0, op.newVal);
                break;
            case 'delete':
                data.splice(op.idx, 1);
                break;
        }
    }

    function applyReverse(op) {
        switch (op.type) {
            case 'set':
                data[op.idx] = op.oldVal;
                break;
            case 'insert':
                data.splice(op.idx, 1);
                break;
            case 'delete':
                data.splice(op.idx, 0, op.oldVal);
                break;
        }
    }

    function rebuildModifiedSet() {
        modifiedSet = new Set();
        var len = Math.max(data.length, originalData ? originalData.length : 0);
        for (var i = 0; i < len; i++) {
            if (i >= data.length || i >= originalData.length || data[i] !== originalData[i]) {
                modifiedSet.add(i);
            }
        }
    }

    window.HexEditor = HexEditor;
})();
