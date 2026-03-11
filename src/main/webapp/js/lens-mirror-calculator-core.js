/**
 * Lens & Mirror Calculator - Core Orchestration
 * State management, events, drag interaction, integration with Render/Export modules
 */
(function() {
'use strict';

var R = window.LensMirrorRender;
var E = window.LensMirrorExport;

// ==================== State ====================

var state = {
    opticalType: 'converging',
    calcMode: 'find-v',
    f: 10,
    u: -20,
    v: 20,
    h: 5,
    lastResult: null
};

// ==================== Helpers ====================

function $(id) { return document.getElementById(id); }

function val(id, fallback) {
    var el = $(id);
    if (!el) return fallback !== undefined ? fallback : 0;
    var n = parseFloat(el.value);
    return isNaN(n) ? (fallback !== undefined ? fallback : 0) : n;
}

function setInput(id, value) {
    var el = $(id);
    if (el) el.value = value;
}

// ==================== Calculation ====================

function isMirror(type) {
    return type === 'concave-mirror' || type === 'convex-mirror' || type === 'plane-mirror';
}

function calculate() {
    var mode = state.calcMode;
    var f = val('lm-focal', 10);
    var u = val('lm-obj-dist', -20);
    var v = val('lm-img-dist', 20);
    var h = val('lm-obj-height', 5);

    state.f = f;
    state.u = u;
    state.v = v;
    state.h = h;

    var result = {};

    // Plane mirror: special case (f = infinity, v = -u, m = 1)
    if (state.opticalType === 'plane-mirror') {
        if (Math.abs(u) < 0.01) {
            result.error = 'Object distance cannot be zero';
            showOutput(result);
            return;
        }
        v = -u;
        result.f = Infinity;
        result.u = u;
        result.v = v;
        result.m = 1;
        result.h_prime = h;
        result.h = h;
        result.imageType = 'Virtual';
        result.orientation = 'Upright';
        result.size = 'Same Size';
        result.power = 0;
        result.isPlane = true;
        state.lastResult = result;
        showOutput(result);
        return;
    }

    if (mode === 'find-v') {
        if (Math.abs(u) < 0.01) {
            result.error = 'Object distance cannot be zero';
            showOutput(result);
            return;
        }
        var inv_v = (1 / f) + (1 / u);
        if (Math.abs(inv_v) < 0.0001) {
            result.error = 'Image forms at infinity (object at focal point)';
            showOutput(result);
            return;
        }
        v = 1 / inv_v;
        result.v = v;
        result.f = f;
        result.u = u;
    } else if (mode === 'find-u') {
        if (Math.abs(v) < 0.01) {
            result.error = 'Image distance cannot be zero';
            showOutput(result);
            return;
        }
        var inv_u = (1 / v) - (1 / f);
        if (Math.abs(inv_u) < 0.0001) {
            result.error = 'Object at infinity';
            showOutput(result);
            return;
        }
        u = 1 / inv_u;
        result.u = u;
        result.f = f;
        result.v = v;
    } else {
        if (Math.abs(u) < 0.01 || Math.abs(v) < 0.01) {
            result.error = 'Object or image distance cannot be zero';
            showOutput(result);
            return;
        }
        var inv_f = (1 / v) - (1 / u);
        if (Math.abs(inv_f) < 0.0001) {
            result.error = 'Invalid configuration';
            showOutput(result);
            return;
        }
        f = 1 / inv_f;
        result.f = f;
        result.u = u;
        result.v = v;
    }

    result.m = v / u;
    result.h_prime = result.m * h;
    result.h = h;
    result.imageType = v > 0 ? 'Real' : 'Virtual';
    result.orientation = result.m < 0 ? 'Inverted' : 'Upright';
    result.size = Math.abs(result.m) > 1 ? 'Magnified' : (Math.abs(result.m) < 1 ? 'Diminished' : 'Same Size');
    result.power = 1 / (f / 100);

    // Add radius of curvature for mirrors
    if (isMirror(state.opticalType)) {
        result.R = 2 * f;
    }

    state.lastResult = result;
    showOutput(result);
}

function showOutput(result) {
    // Hide empty state
    var empty = $('lm-empty-state');
    if (empty) empty.style.display = 'none';

    // Show actions
    var actions = $('lm-result-actions');
    if (actions && !result.error) actions.style.display = 'flex';

    // Draw Canvas ray diagram
    var canvas = $('lm-diagram');
    if (canvas) R.drawRayDiagram(canvas, result, state.opticalType);

    // Render results
    R.renderResults($('lm-results-container'), result);

    // Render steps
    R.renderSteps($('lm-steps-container'), result, state.calcMode);
}

// ==================== Input Visibility ====================

function updateInputVisibility() {
    var mode = state.calcMode;
    var fGroup = $('lm-group-f');
    var uGroup = $('lm-group-u');
    var vGroup = $('lm-group-v');

    // Plane mirror: only show u and h
    if (state.opticalType === 'plane-mirror') {
        if (fGroup) fGroup.style.display = 'none';
        if (uGroup) uGroup.style.display = '';
        if (vGroup) vGroup.style.display = 'none';
        return;
    }

    if (fGroup) fGroup.style.display = mode !== 'find-f' ? '' : 'none';
    if (uGroup) uGroup.style.display = mode !== 'find-u' ? '' : 'none';
    if (vGroup) vGroup.style.display = (mode === 'find-f' || mode === 'find-u') ? '' : 'none';
}

// ==================== Slider Sync ====================

function syncSlider(inputId, sliderId) {
    var input = $(inputId);
    var slider = $(sliderId);
    if (!input || !slider) return;

    input.addEventListener('input', function() {
        slider.value = input.value;
        calculate();
    });
    slider.addEventListener('input', function() {
        input.value = slider.value;
        calculate();
    });
}

// ==================== Calc Mode Switching ====================

function switchCalcMode(mode) {
    state.calcMode = mode;

    var btns = document.querySelectorAll('.lm-mode-btn');
    for (var i = 0; i < btns.length; i++) {
        btns[i].classList.toggle('active', btns[i].getAttribute('data-mode') === mode);
    }

    updateInputVisibility();
}

// ==================== Presets ====================

function applyPreset(preset) {
    var typeEl = $('lm-type');

    var presets = {
        'conv-real':      { type: 'converging',     f: 10,  u: -30,  h: 5  },
        'conv-virtual':   { type: 'converging',     f: 15,  u: -8,   h: 4  },
        'magnifying':     { type: 'converging',     f: 5,   u: -3,   h: 2  },
        'div-basic':      { type: 'diverging',      f: -15, u: -30,  h: 6  },
        'eyeglasses':     { type: 'diverging',      f: -50, u: -100, h: 10 },
        'plano-convex':   { type: 'plano-convex',   f: 12,  u: -25,  h: 5  },
        'plano-concave':  { type: 'plano-concave',  f: -18, u: -30,  h: 5  },
        'concave-mirror': { type: 'concave-mirror', f: 15,  u: -30,  h: 5  },
        'convex-mirror':  { type: 'convex-mirror',  f: -20, u: -40,  h: 6  },
        'plane-mirror':   { type: 'plane-mirror',   f: 0,   u: -20,  h: 5  }
    };

    var p = presets[preset];
    if (!p) return;

    if (typeEl) typeEl.value = p.type;
    state.opticalType = p.type;
    setInput('lm-focal', p.f);
    setInput('lm-obj-dist', p.u);
    setInput('lm-obj-height', p.h);
    setInput('lm-f-slider', p.f);
    setInput('lm-u-slider', p.u);
    setInput('lm-h-slider', p.h);

    // Plane mirror: hide focal length, force find-v
    var fGroup = $('lm-group-f');
    if (p.type === 'plane-mirror') {
        if (fGroup) fGroup.style.display = 'none';
    } else {
        if (fGroup) fGroup.style.display = '';
    }

    switchCalcMode('find-v');
    calculate();
}

// ==================== Load from URL ====================

function loadFromURL() {
    var shared = E.parseShareUrl();
    if (!shared) return false;

    var typeEl = $('lm-type');
    if (shared.t && typeEl) { typeEl.value = shared.t; state.opticalType = shared.t; }
    if (shared.m) switchCalcMode(shared.m);
    if (shared.f !== undefined) {
        setInput('lm-focal', shared.f);
        setInput('lm-f-slider', shared.f);
    }
    if (shared.u !== undefined) {
        setInput('lm-obj-dist', shared.u);
        setInput('lm-u-slider', shared.u);
    }
    if (shared.v !== undefined) {
        setInput('lm-img-dist', shared.v);
        setInput('lm-v-slider', shared.v);
    }
    if (shared.h !== undefined) {
        setInput('lm-obj-height', shared.h);
        setInput('lm-h-slider', shared.h);
    }

    return true;
}

// ==================== Events ====================

function bindEvents() {
    // Calc mode buttons
    var modeBtns = document.querySelectorAll('.lm-mode-btn');
    for (var i = 0; i < modeBtns.length; i++) {
        (function(btn) {
            btn.addEventListener('click', function() {
                switchCalcMode(btn.getAttribute('data-mode'));
            });
        })(modeBtns[i]);
    }

    // Optical type change
    var typeEl = $('lm-type');
    if (typeEl) {
        typeEl.addEventListener('change', function() {
            state.opticalType = typeEl.value;
            var fGroup = $('lm-group-f');

            // Plane mirror: hide focal length input, force find-v mode
            if (typeEl.value === 'plane-mirror') {
                if (fGroup) fGroup.style.display = 'none';
                switchCalcMode('find-v');
                calculate();
                return;
            }
            if (fGroup && state.calcMode !== 'find-f') fGroup.style.display = '';

            var f = parseFloat($('lm-focal').value) || 10;
            if (typeEl.value === 'diverging' || typeEl.value === 'plano-concave' || typeEl.value === 'convex-mirror') {
                if (f > 0) { setInput('lm-focal', -Math.abs(f)); setInput('lm-f-slider', -Math.abs(f)); }
            } else {
                if (f < 0) { setInput('lm-focal', Math.abs(f)); setInput('lm-f-slider', Math.abs(f)); }
            }
            calculate();
        });
    }

    // Slider sync
    syncSlider('lm-focal', 'lm-f-slider');
    syncSlider('lm-obj-dist', 'lm-u-slider');
    syncSlider('lm-img-dist', 'lm-v-slider');
    syncSlider('lm-obj-height', 'lm-h-slider');

    // Calculate button
    var solveBtn = $('lm-solve-btn');
    if (solveBtn) solveBtn.addEventListener('click', calculate);

    // Share
    var shareBtn = $('lm-share-btn');
    if (shareBtn) {
        shareBtn.addEventListener('click', function() {
            E.copyShareUrl(state);
        });
    }

    // Save PNG
    var pngBtn = $('lm-save-png-btn');
    if (pngBtn) {
        pngBtn.addEventListener('click', function() {
            if (!state.lastResult) return;
            var typeEl = $('lm-type');
            var label = typeEl ? typeEl.options[typeEl.selectedIndex].text : '';
            E.savePNG($('lm-diagram'), state.lastResult, label);
        });
    }

    // Example chips
    var chips = document.querySelectorAll('.lm-example-chip');
    for (var j = 0; j < chips.length; j++) {
        (function(chip) {
            chip.addEventListener('click', function(e) {
                e.preventDefault();
                applyPreset(chip.getAttribute('data-example'));
            });
        })(chips[j]);
    }

}

// ==================== Init ====================

function init() {
    bindEvents();
    updateInputVisibility();

    var loaded = loadFromURL();
    calculate();
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
} else {
    init();
}

})();
