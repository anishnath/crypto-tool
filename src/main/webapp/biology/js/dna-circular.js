/*
 * biology/js/dna-circular.js
 *
 * Custom SVG renderer for multi-sequence concentric DNA rings.
 *
 * Seqviz renders one sequence per viewer instance, so stacking
 * multiple sequences vertically gets visually noisy. For 2+
 * sequences in the Linear View's circular or both modes, we replace
 * the stacked seqviz views with a single SVG showing each sequence
 * as a concentric ring — outer = Seq 1, next = Seq 2, etc.
 *
 * Each ring shows:
 *   · A base-color stripe along its circumference (A=red, T=yellow,
 *     G=green, C=blue — same palette as the 3D Helix)
 *   · Position numbers around the outer ring at every 10 bp
 *   · Mismatch positions highlighted with a dark red overlay arc
 *   · Motif matches highlighted with a gold overlay arc
 *   · The sequence's name and length labeled at the top
 *
 * Public API (window.DnaCircular):
 *   DnaCircular.render(container, opts)
 *     opts: { sequences, motif, mismatchPositions, activeKey, onPick }
 *   DnaCircular.clear(container)
 *
 * Pure vanilla — no dependencies beyond DOM + SVG.
 */
(function () {
    "use strict";

    var SVG_NS = "http://www.w3.org/2000/svg";

    var BASE_COLOR = {
        A: "#e74c3c", T: "#f1c40f", G: "#2ecc71", C: "#3498db",
        U: "#f1c40f",
        R: "#9aa0a6", Y: "#9aa0a6", S: "#9aa0a6", W: "#9aa0a6",
        K: "#9aa0a6", M: "#9aa0a6", B: "#9aa0a6", D: "#9aa0a6",
        H: "#9aa0a6", V: "#9aa0a6", N: "#9aa0a6"
    };

    /* polarToCart — converts (radius, degrees-from-12-o-clock-clockwise)
     * to SVG (x, y) in our 600×600 viewBox. */
    function polarToCart(cx, cy, r, angleDeg) {
        var rad = (angleDeg - 90) * Math.PI / 180;
        return { x: cx + r * Math.cos(rad), y: cy + r * Math.sin(rad) };
    }

    /* SVG arc path: a ring sector from `startDeg` to `endDeg` at outer
     * radius `rOut` and inner radius `rIn`. Used for both base-color
     * stripes and overlay highlights. */
    function arcSectorPath(cx, cy, rIn, rOut, startDeg, endDeg) {
        var pA = polarToCart(cx, cy, rOut, startDeg);
        var pB = polarToCart(cx, cy, rOut, endDeg);
        var pC = polarToCart(cx, cy, rIn,  endDeg);
        var pD = polarToCart(cx, cy, rIn,  startDeg);
        var sweep = endDeg - startDeg;
        var largeArc = sweep > 180 ? 1 : 0;
        return [
            "M", pA.x, pA.y,
            "A", rOut, rOut, 0, largeArc, 1, pB.x, pB.y,
            "L", pC.x, pC.y,
            "A", rIn,  rIn,  0, largeArc, 0, pD.x, pD.y,
            "Z"
        ].join(" ");
    }

    function el(tag, attrs, parent) {
        var n = document.createElementNS(SVG_NS, tag);
        if (attrs) Object.keys(attrs).forEach(function (k) {
            n.setAttribute(k, attrs[k]);
        });
        if (parent) parent.appendChild(n);
        return n;
    }

    function clear(container) {
        if (container) container.innerHTML = "";
    }

    /* Render N concentric rings into a fresh SVG inside `container`. */
    function render(container, opts) {
        clear(container);
        opts = opts || {};
        var sequences        = opts.sequences || [];
        var motif            = (opts.motif || "").toUpperCase();
        var mismatchPositions = opts.mismatchPositions || {};  // { seqIdx: [pos, pos] }
        var activeKey        = opts.activeKey || null;          // "s0-bp3"
        var onPick           = opts.onPick || function () {};

        var nSeq = sequences.length;
        if (nSeq === 0) return;

        // SVG layout — square viewBox, all rings inside.
        var VB = 600;
        var cx = VB / 2, cy = VB / 2;
        // Outermost ring radius and inward step. Step shrinks for
        // many-sequence cases so all fit, with a minimum thickness.
        var outerR = 270;
        var step = Math.max(28, Math.min(60, 200 / Math.max(1, nSeq)));
        var ringThickness = Math.max(20, step - 8);

        var svg = el("svg", {
            xmlns: SVG_NS,
            viewBox: "0 0 " + VB + " " + VB,
            class: "dna-circular-svg",
            role: "img",
            "aria-label": "Multi-sequence circular DNA viewer"
        }, container);

        // Subtle radial background ring so the SVG reads as a "plasmid"
        // even before geometry draws. Pure decoration.
        el("circle", {
            cx: cx, cy: cy, r: outerR + 18,
            fill: "none", stroke: "#e6e1d6", "stroke-width": 1
        }, svg);

        // For each sequence, draw a ring at radius rOut.
        sequences.forEach(function (seq, sIdx) {
            if (!seq || seq.length === 0) return;

            var rOut = outerR - sIdx * step;
            var rIn  = rOut - ringThickness;
            if (rIn < 30) return;  // out of room

            // Group per ring so we can attach hover handlers etc.
            var ringG = el("g", { "class": "dna-circular-ring", "data-seq": sIdx }, svg);

            // Step in degrees per base. Force a tiny minimum to avoid
            // sub-pixel arcs when sequences are very long.
            var deg = 360 / seq.length;

            // Faint ring base in case some bases are gaps and leave gaps
            // in the colored stripe — gives the eye a continuous loop.
            el("circle", {
                cx: cx, cy: cy, r: (rOut + rIn) / 2,
                fill: "none", stroke: "#efe9dc", "stroke-width": ringThickness
            }, ringG);

            // Mismatch and motif highlight sets (looked up by position).
            var mismatchSet = {};
            (mismatchPositions[sIdx] || []).forEach(function (p) { mismatchSet[p] = true; });

            var motifSet = {};
            if (motif) {
                var idx = 0;
                while ((idx = seq.indexOf(motif, idx)) !== -1) {
                    for (var k = 0; k < motif.length; k++) motifSet[idx + k] = true;
                    idx += 1;
                }
            }

            // Per-base sector. Each base gets a tiny arc segment colored
            // by its letter; we batch adjacent same-color/-state runs
            // for efficiency on long sequences.
            function emitRun(run) {
                if (run.count === 0) return;
                var startDeg = run.startPos * deg;
                var endDeg = (run.startPos + run.count) * deg;
                // Sub-1° arcs need a slight overdraw to avoid hairline
                // gaps between adjacent runs.
                if (endDeg - startDeg < 0.5) endDeg = startDeg + 0.5;
                el("path", {
                    d: arcSectorPath(cx, cy, rIn, rOut, startDeg, endDeg),
                    fill: run.color,
                    "data-seq": sIdx,
                    "data-bp-start": run.startPos,
                    "data-bp-end": run.startPos + run.count,
                    "class": "dna-circular-base"
                }, ringG);
            }

            var run = { startPos: 0, count: 0, color: null };
            for (var i = 0; i < seq.length; i++) {
                var ch = seq[i];
                // Gap → no fill (transparent), still counted.
                var color;
                if (ch === '-' || ch === '.') color = "transparent";
                else if (motifSet[i])         color = "#f1c40f";       // gold for motif
                else if (mismatchSet[i])      color = "#e74c3c";       // red for mismatch
                else                          color = BASE_COLOR[ch] || "#9aa0a6";

                if (run.color === null) {
                    run.startPos = i; run.count = 1; run.color = color;
                } else if (run.color === color) {
                    run.count++;
                } else {
                    emitRun(run);
                    run = { startPos: i, count: 1, color: color };
                }
            }
            emitRun(run);

            // Active base pair pulse — a small dark outline arc on top
            // of whatever fill the position has.
            if (activeKey) {
                var akMatch = /^s(\d+)-bp(\d+)$/.exec(activeKey);
                if (akMatch && parseInt(akMatch[1], 10) === sIdx) {
                    var bp = parseInt(akMatch[2], 10);
                    if (bp >= 0 && bp < seq.length) {
                        var startDeg = bp * deg;
                        var endDeg = (bp + 1) * deg;
                        if (endDeg - startDeg < 1.5) {
                            // Make the active marker more visible if the
                            // base is a thin slice on a long sequence.
                            var pad = (1.5 - (endDeg - startDeg)) / 2;
                            startDeg -= pad;
                            endDeg += pad;
                        }
                        el("path", {
                            d: arcSectorPath(cx, cy, rIn - 3, rOut + 3, startDeg, endDeg),
                            fill: "none",
                            stroke: "#1c1917",
                            "stroke-width": 2,
                            "stroke-linejoin": "round",
                            "class": "dna-circular-active"
                        }, ringG);
                    }
                }
            }

            // Sequence label at the top of the ring (12 o'clock).
            var labelPos = polarToCart(cx, cy, (rOut + rIn) / 2, 0);
            var labelText = "Seq " + (sIdx + 1) + " · " + seq.length + " bp";
            var labelBg = el("rect", {
                x: labelPos.x - 56,
                y: labelPos.y - 10,
                width: 112,
                height: 20,
                rx: 10,
                fill: "rgba(20,18,14,0.85)",
                "class": "dna-circular-label-bg"
            }, ringG);
            el("text", {
                x: labelPos.x,
                y: labelPos.y + 4,
                "text-anchor": "middle",
                fill: "#fffdf6",
                "font-size": 11,
                "font-weight": 600,
                "font-family": "-apple-system, BlinkMacSystemFont, Inter, sans-serif",
                "class": "dna-circular-label"
            }, ringG).textContent = labelText;
        });

        // Position-number ticks around the outer ring. We render up to
        // 12 evenly spaced labels (so it doesn't get crowded). Uses the
        // first sequence's length as the position scale.
        var refSeq = sequences[0] || "";
        if (refSeq.length > 0) {
            var TICK_COUNT = Math.min(12, refSeq.length);
            for (var t = 0; t < TICK_COUNT; t++) {
                var pos = Math.round(t * refSeq.length / TICK_COUNT);
                var ang = pos * 360 / refSeq.length;
                var tickIn  = polarToCart(cx, cy, outerR + 8,  ang);
                var tickOut = polarToCart(cx, cy, outerR + 14, ang);
                var lbl     = polarToCart(cx, cy, outerR + 30, ang);
                el("line", {
                    x1: tickIn.x, y1: tickIn.y, x2: tickOut.x, y2: tickOut.y,
                    stroke: "#8a8378", "stroke-width": 1
                }, svg);
                if (t > 0) {  // skip "0" at the top so it doesn't overlap the Seq label
                    el("text", {
                        x: lbl.x, y: lbl.y + 4,
                        "text-anchor": "middle",
                        fill: "#8a8378",
                        "font-size": 11,
                        "font-family": "ui-monospace, Menlo, Consolas, monospace"
                    }, svg).textContent = pos;
                }
            }
        }

        // Center text — total info.
        el("text", {
            x: cx, y: cy - 8,
            "text-anchor": "middle",
            fill: "var(--ca-ink, #28231c)",
            "font-size": 14,
            "font-weight": 700,
            "font-family": "-apple-system, BlinkMacSystemFont, Inter, sans-serif"
        }, svg).textContent = nSeq + " sequence" + (nSeq === 1 ? "" : "s");
        el("text", {
            x: cx, y: cy + 12,
            "text-anchor": "middle",
            fill: "#8a8378",
            "font-size": 11,
            "font-family": "-apple-system, BlinkMacSystemFont, Inter, sans-serif"
        }, svg).textContent = "Concentric view";

        // Click delegation: clicking any colored arc activates the base
        // at its center. We use data-bp-start/end as a range.
        svg.addEventListener("click", function (e) {
            var path = e.target.closest("[data-bp-start]");
            if (!path) return;
            var sIdx = parseInt(path.getAttribute("data-seq"), 10);
            var start = parseInt(path.getAttribute("data-bp-start"), 10);
            var end = parseInt(path.getAttribute("data-bp-end"), 10);
            var bp = Math.floor((start + end - 1) / 2);
            onPick("s" + sIdx + "-bp" + bp);
        });
    }

    window.DnaCircular = {
        render: render,
        clear: clear
    };
})();
