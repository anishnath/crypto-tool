/*
 * activation-functions.js — interactive activation function explorer.
 *
 * Two side-by-side canvases:
 *   1. Left:  f(x) for each selected activation
 *   2. Right: f'(x) — derivatives, the values backprop actually multiplies
 *
 * Pure JS plotting — no Pyodide, no Chart.js.  Activation math lives in
 * the ACTIVATIONS table; new ones plug in by adding a new entry.
 *
 * Modern theme port of the legacy /activation_function_explorer.jsp.
 */

(function () {
    'use strict';

    // ── Abramowitz & Stegun erf approximation (for exact GELU) ──
    function erf (z) {
        const sign = z >= 0 ? 1 : -1;
        z = Math.abs(z);
        const t = 1 / (1 + 0.3275911 * z);
        const a1 = 0.254829592, a2 = -0.284496736, a3 = 1.421413741,
              a4 = -1.453152027, a5 =  1.061405429;
        const y = 1 - (((((a5 * t + a4) * t + a3) * t + a2) * t + a1) * t) * Math.exp(-z * z);
        return sign * y;
    }

    // ── Activation library ───────────────────────────────────
    // Each entry carries display metadata + numeric f / df.  Derivatives
    // are hand-coded where simple; numerical centered-difference where
    // not (GELU exact, Mish).
    const ACTIVATIONS = {
        identity: {
            label: 'Identity',
            color: '#64748b',
            range: '(−∞, ∞)',
            when: 'Output layer for regression problems.',
            f:  (x)    => x,
            df: (x)    => 1,
            params: [],
        },
        sigmoid: {
            label: 'Sigmoid',
            color: '#0ea5e9',
            range: '(0, 1)',
            when: 'Output for binary classification; rarely a good hidden activation — saturates and zeroes gradients.',
            f:  (x) => 1 / (1 + Math.exp(-Math.max(-60, Math.min(60, x)))),
            df: function (x) { const s = this.f(x); return s * (1 - s); },
            params: [],
        },
        tanh: {
            label: 'Tanh',
            color: '#22c55e',
            range: '(−1, 1)',
            when: 'Hidden activation in older RNNs / LSTM gates. Zero-centered, but still saturates.',
            f:  (x) => Math.tanh(x),
            df: (x) => 1 - Math.tanh(x) ** 2,
            params: [],
        },
        relu: {
            label: 'ReLU',
            color: '#ef4444',
            range: '[0, ∞)',
            when: 'Default hidden activation since AlexNet (2012). Cheap, no saturation for positives.',
            f:  (x) => x > 0 ? x : 0,
            df: (x) => x > 0 ? 1 : 0,
            params: [],
        },
        leakyRelu: {
            label: 'Leaky ReLU',
            color: '#f97316',
            range: '(−∞, ∞)',
            when: 'Fixes "dying ReLU": tiny slope α on the negative side keeps units alive.',
            f:  (x, p) => x > 0 ? x : p.leakyAlpha * x,
            df: (x, p) => x > 0 ? 1 : p.leakyAlpha,
            params: ['leakyAlpha'],
        },
        elu: {
            label: 'ELU',
            color: '#a855f7',
            range: '(−α, ∞)',
            when: 'Smooth negative tail; pushes mean activations toward zero, helping deep nets.',
            f:  (x, p) => x >= 0 ? x : p.eluAlpha * (Math.exp(x) - 1),
            df: (x, p) => x >= 0 ? 1 : p.eluAlpha * Math.exp(x),
            params: ['eluAlpha'],
        },
        gelu: {
            label: 'GELU',
            color: '#14b8a6',
            range: '(−0.17, ∞)',
            when: 'Default in transformers (GPT, BERT, ViT). Smooth, probabilistic gating of x.',
            f: function (x, p) {
                if (p.geluMode === 'tanh') {
                    const c = Math.sqrt(2 / Math.PI);
                    return 0.5 * x * (1 + Math.tanh(c * (x + 0.044715 * x * x * x)));
                }
                return 0.5 * x * (1 + erf(x / Math.SQRT2));
            },
            // Numerical centered-difference — fine for visualization at this scale.
            df: function (x, p) {
                const h = 1e-3;
                return (this.f(x + h, p) - this.f(x - h, p)) / (2 * h);
            },
            params: ['geluMode'],
        },
        swish: {
            label: 'Swish (SiLU)',
            color: '#ec4899',
            range: '(−0.28, ∞)',
            when: 'Google EfficientNet; competitive with GELU at lower compute. Self-gated: x · σ(x).',
            f: (x) => x / (1 + Math.exp(-Math.max(-60, Math.min(60, x)))),
            df: function (x) {
                const s = 1 / (1 + Math.exp(-Math.max(-60, Math.min(60, x))));
                return s + x * s * (1 - s);
            },
            params: [],
        },
        softplus: {
            label: 'Softplus',
            color: '#84cc16',
            range: '(0, ∞)',
            when: 'Smooth approximation of ReLU. Mostly historical — the smoothness costs more than it saves.',
            f:  (x) => Math.log1p(Math.exp(Math.min(60, x))),
            df: (x) => 1 / (1 + Math.exp(-Math.max(-60, Math.min(60, x)))),
            params: [],
        },
        mish: {
            label: 'Mish',
            color: '#06b6d4',
            range: '(−0.31, ∞)',
            when: 'YOLOv4 and successors. Smooth, self-regularizing; small gains over Swish in some vision tasks.',
            f:  (x) => x * Math.tanh(Math.log1p(Math.exp(Math.min(60, x)))),
            df: function (x) {
                const h = 1e-3;
                return (this.f(x + h) - this.f(x - h)) / (2 * h);
            },
            params: [],
        },
    };

    // Public for the math card to enumerate and render entries
    window.AF_ACTIVATIONS = ACTIVATIONS;

    // ── DOM handles ──────────────────────────────────────────
    const els = {
        fnCanvas:    document.getElementById('afFn'),
        dfnCanvas:   document.getElementById('afDfn'),
        fnReadout:   document.getElementById('afFnReadout'),
        dfnReadout:  document.getElementById('afDfnReadout'),
        chips:       document.getElementById('afChips'),
        leakyCtl:    document.getElementById('afLeakyCtl'),
        leakySlider: document.getElementById('afLeaky'),
        leakyValue:  document.getElementById('afLeakyValue'),
        eluCtl:      document.getElementById('afEluCtl'),
        eluSlider:   document.getElementById('afElu'),
        eluValue:    document.getElementById('afEluValue'),
        geluCtl:     document.getElementById('afGeluCtl'),
        geluMode:    document.getElementById('afGeluMode'),
        xmin:        document.getElementById('afXmin'),
        xmax:        document.getElementById('afXmax'),
        ymin:        document.getElementById('afYmin'),
        ymax:        document.getElementById('afYmax'),
        resetBtn:    document.getElementById('afReset'),
    };

    // ── State ────────────────────────────────────────────────
    const DEFAULT_SELECTED = ['sigmoid', 'tanh', 'relu', 'leakyRelu'];
    const state = {
        selected: new Set(DEFAULT_SELECTED),
        params: { leakyAlpha: 0.01, eluAlpha: 1.0, geluMode: 'exact' },
        domain: { xmin: -6, xmax: 6, ymin: -2, ymax: 2 },
    };

    // ── Canvas helpers ───────────────────────────────────────
    function getCanvasCtx (canvas) {
        const dpr = window.devicePixelRatio || 1;
        const rect = canvas.getBoundingClientRect();
        canvas.width  = Math.max(1, Math.floor(rect.width  * dpr));
        canvas.height = Math.max(1, Math.floor(rect.height * dpr));
        const ctx = canvas.getContext('2d');
        ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
        return { ctx, w: rect.width, h: rect.height };
    }
    function isDark () {
        return getComputedStyle(document.body).getPropertyValue('--ms-page-bg').trim() === '#0c0a09';
    }

    // ── Shared axis renderer ─────────────────────────────────
    function drawAxes (ctx, pad, plotW, plotH, xMin, xMax, yMin, yMax, dark) {
        ctx.strokeStyle = dark ? 'rgba(245,245,244,0.20)' : 'rgba(28,25,23,0.20)';
        ctx.lineWidth = 1;
        ctx.beginPath();
        ctx.moveTo(pad.l, pad.t); ctx.lineTo(pad.l, pad.t + plotH);
        ctx.lineTo(pad.l + plotW, pad.t + plotH);
        ctx.stroke();

        // x=0 and y=0 reference lines (when inside the visible domain)
        ctx.strokeStyle = dark ? 'rgba(245,245,244,0.30)' : 'rgba(28,25,23,0.30)';
        ctx.setLineDash([3, 3]);
        ctx.beginPath();
        if (xMin <= 0 && xMax >= 0) {
            const x0 = pad.l + ((0 - xMin) / (xMax - xMin)) * plotW;
            ctx.moveTo(x0, pad.t); ctx.lineTo(x0, pad.t + plotH);
        }
        if (yMin <= 0 && yMax >= 0) {
            const y0 = pad.t + plotH - ((0 - yMin) / (yMax - yMin)) * plotH;
            ctx.moveTo(pad.l, y0); ctx.lineTo(pad.l + plotW, y0);
        }
        ctx.stroke();
        ctx.setLineDash([]);

        // Tick labels
        ctx.fillStyle = dark ? 'rgba(168,162,158,0.95)' : 'rgba(120,113,108,0.95)';
        ctx.font = '500 10px JetBrains Mono, monospace';
        const xRange = xMax - xMin;
        const xStep = niceStep(xRange / 6);
        for (let xv = Math.ceil(xMin / xStep) * xStep; xv <= xMax + 1e-9; xv += xStep) {
            const x = pad.l + ((xv - xMin) / xRange) * plotW;
            ctx.beginPath(); ctx.moveTo(x, pad.t + plotH); ctx.lineTo(x, pad.t + plotH + 4); ctx.stroke();
            ctx.fillText(fmtNum(xv), x - 8, pad.t + plotH + 16);
        }
        const yRange = yMax - yMin;
        const yStep = niceStep(yRange / 6);
        for (let yv = Math.ceil(yMin / yStep) * yStep; yv <= yMax + 1e-9; yv += yStep) {
            const y = pad.t + plotH - ((yv - yMin) / yRange) * plotH;
            ctx.beginPath(); ctx.moveTo(pad.l - 4, y); ctx.lineTo(pad.l, y); ctx.stroke();
            ctx.fillText(fmtNum(yv), 8, y + 3);
        }
    }
    function niceStep (raw) {
        if (raw <= 0) return 1;
        const p = Math.pow(10, Math.floor(Math.log10(raw)));
        const m = raw / p;
        if (m < 1.5) return p;
        if (m < 3)   return 2 * p;
        if (m < 7)   return 5 * p;
        return 10 * p;
    }
    function fmtNum (v) {
        if (Math.abs(v) < 1e-9) return '0';
        const abs = Math.abs(v);
        if (abs >= 100 || abs < 0.01) return v.toExponential(0);
        return v.toFixed(abs < 1 ? 2 : (abs < 10 ? 1 : 0));
    }

    // ── Curve renderer ───────────────────────────────────────
    // Samples N points across [xMin, xMax] for fn(x), draws a line.
    function drawCurve (ctx, pad, plotW, plotH, xMin, xMax, yMin, yMax,
                       fn, params, color, dashPattern) {
        ctx.strokeStyle = color;
        ctx.lineWidth = 2;
        if (dashPattern) ctx.setLineDash(dashPattern); else ctx.setLineDash([]);
        ctx.beginPath();
        const N = 480;
        let started = false;
        for (let i = 0; i < N; i++) {
            const x = xMin + (i / (N - 1)) * (xMax - xMin);
            let y;
            try { y = fn(x, params); } catch (e) { continue; }
            if (!isFinite(y)) continue;
            // Clip y to the visible range with a margin so the line goes
            // off-canvas naturally instead of disappearing abruptly.
            const yClipped = Math.max(yMin - (yMax - yMin), Math.min(yMax + (yMax - yMin), y));
            const px = pad.l + ((x - xMin) / (xMax - xMin)) * plotW;
            const py = pad.t + plotH - ((yClipped - yMin) / (yMax - yMin)) * plotH;
            if (!started) { ctx.moveTo(px, py); started = true; } else ctx.lineTo(px, py);
        }
        ctx.stroke();
        ctx.setLineDash([]);
    }

    // ── Render f(x) panel ────────────────────────────────────
    function drawFunctionPanel () {
        if (!els.fnCanvas) return;
        const { ctx, w, h } = getCanvasCtx(els.fnCanvas);
        const pad = { l: 40, r: 14, t: 18, b: 26 };
        const plotW = w - pad.l - pad.r, plotH = h - pad.t - pad.b;
        const { xmin, xmax, ymin, ymax } = state.domain;
        const dark = isDark();
        drawAxes(ctx, pad, plotW, plotH, xmin, xmax, ymin, ymax, dark);

        // y-axis title
        ctx.fillStyle = dark ? 'rgba(168,162,158,0.95)' : 'rgba(120,113,108,0.95)';
        ctx.font = '500 10px JetBrains Mono, monospace';
        ctx.save();
        ctx.translate(13, pad.t + 6); ctx.rotate(-Math.PI / 2);
        ctx.fillText('f(x)', -16, 0);
        ctx.restore();
        ctx.fillText('x', pad.l + plotW - 10, pad.t + plotH + 18);

        // Curves
        for (const key of state.selected) {
            const a = ACTIVATIONS[key];
            if (!a) continue;
            drawCurve(ctx, pad, plotW, plotH, xmin, xmax, ymin, ymax,
                      a.f.bind(a), state.params, a.color, null);
        }

        if (els.fnReadout) {
            els.fnReadout.innerHTML =
                '<span>' + state.selected.size + ' active</span>' +
                '<span>x ∈ [' + xmin.toFixed(1) + ', ' + xmax.toFixed(1) + ']</span>';
        }
    }

    function drawDerivativePanel () {
        if (!els.dfnCanvas) return;
        const { ctx, w, h } = getCanvasCtx(els.dfnCanvas);
        const pad = { l: 40, r: 14, t: 18, b: 26 };
        const plotW = w - pad.l - pad.r, plotH = h - pad.t - pad.b;
        const { xmin, xmax, ymin, ymax } = state.domain;
        const dark = isDark();
        drawAxes(ctx, pad, plotW, plotH, xmin, xmax, ymin, ymax, dark);

        ctx.fillStyle = dark ? 'rgba(168,162,158,0.95)' : 'rgba(120,113,108,0.95)';
        ctx.font = '500 10px JetBrains Mono, monospace';
        ctx.save();
        ctx.translate(13, pad.t + 6); ctx.rotate(-Math.PI / 2);
        ctx.fillText("f'(x)", -20, 0);
        ctx.restore();
        ctx.fillText('x', pad.l + plotW - 10, pad.t + plotH + 18);

        for (const key of state.selected) {
            const a = ACTIVATIONS[key];
            if (!a) continue;
            drawCurve(ctx, pad, plotW, plotH, xmin, xmax, ymin, ymax,
                      a.df.bind(a), state.params, a.color, [5, 4]);
        }

        if (els.dfnReadout) {
            els.dfnReadout.innerHTML =
                '<span>derivative — dashed</span>' +
                '<span>y ∈ [' + ymin.toFixed(1) + ', ' + ymax.toFixed(1) + ']</span>';
        }
    }

    function redraw () {
        drawFunctionPanel();
        drawDerivativePanel();
    }

    // ── Chip toggles ─────────────────────────────────────────
    function renderChips () {
        if (!els.chips) return;
        const html = Object.entries(ACTIVATIONS).map(([key, a]) => {
            const active = state.selected.has(key);
            return (
                '<button type="button" class="af-chip' + (active ? ' is-active' : '') + '"' +
                ' data-key="' + key + '" style="--af-color:' + a.color + '">' +
                '<span class="af-chip-dot"></span>' + a.label +
                '</button>'
            );
        }).join('');
        els.chips.innerHTML = html;
        els.chips.querySelectorAll('.af-chip').forEach((btn) => {
            btn.addEventListener('click', () => {
                const key = btn.getAttribute('data-key');
                if (state.selected.has(key)) state.selected.delete(key);
                else state.selected.add(key);
                btn.classList.toggle('is-active');
                syncParamVisibility();
                redraw();
            });
        });
    }

    // Show parameter sliders only when their owning activation is selected.
    function syncParamVisibility () {
        const has = (key) => state.selected.has(key);
        if (els.leakyCtl) els.leakyCtl.classList.toggle('is-hidden', !has('leakyRelu'));
        if (els.eluCtl)   els.eluCtl.classList.toggle('is-hidden',   !has('elu'));
        if (els.geluCtl)  els.geluCtl.classList.toggle('is-hidden',  !has('gelu'));
    }

    // ── Wire-up ──────────────────────────────────────────────
    function wireControls () {
        const fmt = () => {
            if (els.leakyValue) els.leakyValue.textContent = state.params.leakyAlpha.toFixed(3);
            if (els.eluValue)   els.eluValue.textContent   = state.params.eluAlpha.toFixed(2);
        };
        if (els.leakySlider) {
            els.leakySlider.addEventListener('input', (e) => {
                state.params.leakyAlpha = parseFloat(e.target.value);
                fmt(); redraw();
            });
        }
        if (els.eluSlider) {
            els.eluSlider.addEventListener('input', (e) => {
                state.params.eluAlpha = parseFloat(e.target.value);
                fmt(); redraw();
            });
        }
        if (els.geluMode) {
            els.geluMode.addEventListener('change', (e) => {
                state.params.geluMode = e.target.value;
                redraw();
            });
        }
        ['xmin', 'xmax', 'ymin', 'ymax'].forEach((k) => {
            const el = els[k]; if (!el) return;
            el.addEventListener('input', () => {
                const v = parseFloat(el.value);
                if (isFinite(v)) state.domain[k] = v;
                redraw();
            });
        });
        if (els.resetBtn) {
            els.resetBtn.addEventListener('click', () => {
                state.selected = new Set(DEFAULT_SELECTED);
                state.params = { leakyAlpha: 0.01, eluAlpha: 1.0, geluMode: 'exact' };
                state.domain = { xmin: -6, xmax: 6, ymin: -2, ymax: 2 };
                if (els.leakySlider) els.leakySlider.value = '0.01';
                if (els.eluSlider)   els.eluSlider.value   = '1.0';
                if (els.geluMode)    els.geluMode.value    = 'exact';
                if (els.xmin) els.xmin.value = '-6';
                if (els.xmax) els.xmax.value = '6';
                if (els.ymin) els.ymin.value = '-2';
                if (els.ymax) els.ymax.value = '2';
                fmt();
                renderChips();
                syncParamVisibility();
                redraw();
            });
        }
        fmt();
    }

    // ── Boot ─────────────────────────────────────────────────
    function boot () {
        if (!els.fnCanvas || !els.dfnCanvas) return;
        renderChips();
        wireControls();
        syncParamVisibility();
        redraw();

        if (window.renderMathInElement) {
            window.renderMathInElement(document.body, {
                delimiters: [
                    { left: '$$', right: '$$', display: true },
                    { left: '$',  right: '$',  display: false },
                ],
                throwOnError: false,
            });
        }

        let resizeTO = null;
        window.addEventListener('resize', () => {
            clearTimeout(resizeTO);
            resizeTO = setTimeout(redraw, 120);
        });

        // Re-theme on dark-mode toggle
        const themeObserver = new MutationObserver(redraw);
        themeObserver.observe(document.documentElement, {
            attributes: true,
            attributeFilter: ['data-theme'],
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', boot);
    } else {
        boot();
    }
})();
