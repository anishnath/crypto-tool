/**
 * Math AI cores runtime bootstrap (ctx + Plotly lazy loader).
 * Bundled at the head of math-ai-cores-engine.js — not loaded separately.
 */
(function () {
  'use strict';

  if (typeof window.MATH_CALC_CTX !== 'string') {
    var meta = document.querySelector('meta[name="ctx"]') || document.querySelector('meta[name="context-path"]');
    var ctx = (meta && meta.content) || '';
    window.MATH_CALC_CTX = ctx;
    window.TRIG_CALC_CTX = ctx;
  } else if (typeof window.TRIG_CALC_CTX !== 'string') {
    window.TRIG_CALC_CTX = window.MATH_CALC_CTX;
  }

  if (typeof window.loadPlotly !== 'function') {
    var __mccPlotlyLoaded = false;
    window.loadPlotly = function loadPlotly(cb) {
      if (__mccPlotlyLoaded || window.Plotly) {
        __mccPlotlyLoaded = true;
        if (cb) cb();
        return;
      }
      var s = document.createElement('script');
      s.src = 'https://cdn.plot.ly/plotly-2.27.0.min.js';
      s.onload = function () {
        __mccPlotlyLoaded = true;
        if (cb) cb();
      };
      document.head.appendChild(s);
    };
  }

  window.__QS_BRIDGE_NO_AUTOSOLVE = true;
})();
