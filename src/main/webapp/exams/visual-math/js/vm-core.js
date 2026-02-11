/**
 * Visual Math Lab - Core Registry & Utilities
 * https://8gwifi.org/exams/visual-math/
 *
 * Load this first, then load individual viz modules.
 * Each module calls VisualMath.register(name, fn) to register itself.
 */
var VisualMath = (function() {
    'use strict';

    var vizRegistry = {};
    var activeSketch = null;
    var state = {};

    function isDark() {
        return document.documentElement.getAttribute('data-theme') === 'dark';
    }

    function palette() {
        var d = isDark();
        return {
            bg:     d ? [15, 23, 42]    : [255, 255, 255],
            grid:   d ? [51, 65, 85]    : [230, 230, 230],
            axis:   d ? [100, 116, 139] : [180, 180, 180],
            text:   d ? [226, 232, 240] : [30, 30, 30],
            muted:  d ? [148, 163, 184] : [130, 130, 130],
            circle: d ? [148, 163, 184] : [100, 100, 100],
            sin:    [239, 68, 68],
            cos:    [59, 130, 246],
            tan:    [249, 115, 22],
            accent: [99, 102, 241],
            point:  d ? [255, 255, 255] : [30, 30, 30]
        };
    }

    return {
        /** Register a visualization function: fn(p5instance, containerEl, state) */
        register: function(name, fn) {
            vizRegistry[name] = fn;
        },

        /** Launch a full-page visualization (replaces any active one) */
        init: function(type, containerId, params) {
            var container = document.getElementById(containerId);
            if (!container || !vizRegistry[type]) {
                console.warn('VisualMath: unknown type or missing container', type, containerId);
                return null;
            }
            if (activeSketch) {
                activeSketch.remove();
                activeSketch = null;
            }
            state = params || {};
            state._redraw = function() {};
            activeSketch = new p5(function(p) {
                vizRegistry[type](p, container);
            }, container);
            return activeSketch;
        },

        /** Launch a preview sketch (multiple can coexist) */
        preview: function(containerId, type) {
            var container = document.getElementById(containerId);
            if (!container || !vizRegistry[type]) return null;
            return new p5(function(p) {
                vizRegistry[type](p, container);
            }, container);
        },

        getState: function() { return state; },
        setState: function(key, val) { state[key] = val; },
        palette: palette,
        isDark: isDark
    };
})();
