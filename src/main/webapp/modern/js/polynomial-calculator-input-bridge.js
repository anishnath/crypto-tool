/**
 * Polynomial Calculator — MathLive input bridge.
 *
 * Reads from the visible MathLive surfaces (P(x) primary + optional Q(x)
 * secondary) and writes into the legacy hidden text inputs (#poly-p1,
 * #poly-p2, #poly-eval-x) so the unmodified polynomial-calculator-core.js
 * can drive its existing flow.
 *
 * Public surface:
 *   window.PolynomialInputBridge.normalize(s)
 *   window.PolynomialInputBridge.applyExample({ p1, p2?, evalX?, mode })
 *   window.PolynomialInputBridge.syncToLegacy({ p1, p2, evalX, mode })
 */
(function () {
'use strict';

// ===== Normalization =====
//
// Same shape as the quadratic bridge: defang LaTeX-y leftovers from
// MathLive's ascii-math, make implicit multiplication explicit. nerdamer
// (used by the legacy core) is OK with most of these, but a single
// normalize keeps the contract obvious.
function normalize(raw) {
    if (raw == null) return '';
    var s = String(raw);

    s = s.replace(/\\cdot/g, '*');
    s = s.replace(/\\times/g, '*');
    s = s.replace(/\\div/g, '/');
    s = s.replace(/\\left/g, '');
    s = s.replace(/\\right/g, '');
    s = s.replace(/\\:/g, ' ');
    s = s.replace(/\\,/g, ' ');
    s = s.replace(/\\;/g, ' ');
    s = s.replace(/\\!/g, '');

    var prev;
    do { prev = s; s = s.replace(/\{([^{}]*)\}/g, '($1)'); } while (s !== prev);

    s = s.replace(/²/g, '^2').replace(/³/g, '^3').replace(/⁴/g, '^4').replace(/⁵/g, '^5');
    s = s.replace(/π/g, 'pi').replace(/×/g, '*').replace(/·/g, '*');
    s = s.replace(/−/g, '-').replace(/–/g, '-').replace(/—/g, '-');

    // Implicit multiplication.
    s = s.replace(/(\d)([a-zA-Z(])/g, '$1*$2');
    s = s.replace(/\)([a-zA-Z0-9(])/g, ')*$1');

    return s.replace(/\s+/g, ' ').trim();
}

// Native input setter that bypasses any property hook, used to write into
// the legacy text inputs without re-entering math-input-setup's listener.
var nativeInputValueSetter = (function () {
    try {
        var d = Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, 'value');
        return d && typeof d.set === 'function' ? d.set : null;
    } catch (e) { return null; }
})();
function setVal(id, v) {
    var el = document.getElementById(id);
    if (!el) return;
    if (nativeInputValueSetter && el.tagName === 'INPUT') {
        nativeInputValueSetter.call(el, v == null ? '' : String(v));
    } else {
        el.value = v == null ? '' : String(v);
    }
    el.dispatchEvent(new Event('input', { bubbles: true }));
    el.dispatchEvent(new Event('change', { bubbles: true }));
}

// Equation detector — when the user types an equation like
//   x^5 + 9x = 10x^3
// in the P field for a unary operation (factor/roots/expand), rearrange
// to standard form: (LHS) - (RHS). Roots of f(x) = 0 are exactly the
// solutions of LHS = RHS, so this preserves intent.
//
// Returns { expr, rearranged: bool } so callers can show a notice.
function detectEquation(raw, mode) {
    var s = String(raw || '');
    if (!s || s.indexOf('=') < 0) return { expr: s, rearranged: false };
    var unary = { factor: 1, roots: 1, expand: 1 };
    if (!unary[mode]) return { expr: s, rearranged: false };
    // Split on first '=' (treat extras as part of the RHS, harmless).
    var idx = s.indexOf('=');
    var lhs = s.slice(0, idx).trim();
    var rhs = s.slice(idx + 1).trim();
    if (!lhs || !rhs) return { expr: s, rearranged: false };
    return { expr: '(' + lhs + ') - (' + rhs + ')', rearranged: true };
}

// Push parsed values into the legacy hidden state, then click the right
// mode button so the core's switchMode runs and the panes show/hide.
// Returns the resolved state (with rearrangement applied) so the caller
// can surface a "Rearranged to LHS - RHS = 0" notice if it wants.
function syncToLegacy(state) {
    if (!state) return null;
    var p1 = state.p1 || '';
    var rearranged = false;
    if (state.mode) {
        var det = detectEquation(p1, state.mode);
        p1 = det.expr;
        rearranged = det.rearranged;
    }
    setVal('poly-p1', normalize(p1));
    if (state.p2 !== undefined) setVal('poly-p2', normalize(state.p2 || ''));
    if (state.evalX !== undefined) setVal('poly-eval-x', String(state.evalX || ''));
    if (state.mode) {
        var btn = document.querySelector('.poly-mode-btn[data-mode="' + state.mode + '"]');
        if (btn) btn.click();
    }
    return { resolvedP1: p1, rearranged: rearranged };
}

// Seed the visible MathLive fields from an example (chip click, scan).
// The mode pill is updated by syncToLegacy via .click() on the matching
// hidden mode button — its handler is mirrored by the wiring IIFE below.
function applyExample(ex) {
    if (!ex) return;
    var mf1 = document.getElementById('ic-mathfield');
    var mf2 = document.getElementById('ic-mathfield2');
    var ex1 = document.getElementById('ic-expr');
    var evalIn = document.getElementById('poly-bridge-eval-x');

    if (ex1) ex1.value = ex.p1 || '';
    if (mf1 && typeof mf1.setValue === 'function') {
        try { mf1.setValue(ex.p1 || '', { format: 'ascii-math' }); } catch (e) {}
    }
    if (ex1) ex1.dispatchEvent(new Event('input', { bubbles: true }));

    // Q is a math-field with no plain-text twin; push value directly and
    // fire the input event so the wiring updates CTA enable-state.
    if (mf2 && typeof mf2.setValue === 'function') {
        try { mf2.setValue(ex.p2 || '', { format: 'ascii-math' }); } catch (e) {}
        try { mf2.dispatchEvent(new Event('input', { bubbles: true })); } catch (e) {}
    }

    if (evalIn) {
        evalIn.value = ex.evalX != null ? String(ex.evalX) : '';
        evalIn.dispatchEvent(new Event('input', { bubbles: true }));
    }

    // Switch to the example's mode (pill click on the visible bridge bar
    // — the wiring IIFE forwards it to the hidden legacy mode button).
    if (ex.mode) {
        var pill = document.querySelector('.poly-bridge-op[data-mode="' + ex.mode + '"]');
        if (pill) pill.click();
    }
}

// Reset all visible inputs and re-show the empty state with chips. Bound
// from the wiring IIFE to a "Clear" button next to the CTA.
function clearAll() {
    var mf1 = document.getElementById('ic-mathfield');
    var mf2 = document.getElementById('ic-mathfield2');
    var ex1 = document.getElementById('ic-expr');
    var evalIn = document.getElementById('poly-bridge-eval-x');
    if (mf1 && typeof mf1.setValue === 'function') { try { mf1.setValue(''); } catch (e) {} }
    if (mf2 && typeof mf2.setValue === 'function') { try { mf2.setValue(''); } catch (e) {} }
    if (ex1) { ex1.value = ''; ex1.dispatchEvent(new Event('input', { bubbles: true })); }
    if (evalIn) { evalIn.value = ''; evalIn.dispatchEvent(new Event('input', { bubbles: true })); }

    // Hide result actions, restore empty state.
    var actions = document.getElementById('poly-result-actions');
    if (actions) actions.style.display = 'none';
    var empty = document.getElementById('poly-empty-state');
    if (empty) empty.style.display = '';
    var content = document.getElementById('poly-result-content');
    if (content) {
        // Wipe any previously-rendered result HTML except the empty-state node.
        Array.prototype.slice.call(content.children).forEach(function (child) {
            if (child !== empty) child.remove();
        });
    }
    var stepsArea = document.getElementById('poly-steps-area');
    if (stepsArea) stepsArea.innerHTML = '';

    // Reset to default mode.
    var addPill = document.querySelector('.poly-bridge-op[data-mode="add"]');
    if (addPill) addPill.click();
}

window.PolynomialInputBridge = {
    normalize: normalize,
    syncToLegacy: syncToLegacy,
    applyExample: applyExample,
    clearAll: clearAll,
    detectEquation: detectEquation
};

})();
