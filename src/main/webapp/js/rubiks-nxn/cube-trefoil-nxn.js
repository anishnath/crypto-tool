/**
 * cube-trefoil-nxn.js — a third cube visualization for the N×N solver.
 *
 * A 2-D "trefoil" projection inspired by Adam White's RubiksCubeControlWpf
 * (https://github.com/AdamWhiteHat/RubiksCubeControlWpf).  Instead of a flat
 * unfolded net or an orbiting 3-D cube, every one of the 6·N² stickers is drawn
 * as a coloured dot, and the dots ride three interleaved families of concentric
 * rings — one family per cube axis.  A face turn slides the affected dots
 * smoothly along their ring, so you can watch the permutation travel between
 * faces — the thing the 3-D cube hides (3 faces always occluded) and the flat
 * net can't show (faces don't connect).
 *
 * GENERALISATION TO N×N.  The original WPF control is 3×3 only (54 hand-placed
 * dots).  The construction generalises cleanly:
 *
 *   • Three ring families, one per axis:
 *       Top  family  = the F↔B axis  (rings = the N slices front→back)
 *       Left family  = the R↔L axis  (rings = the N slices  right→left)
 *       Right family = the U↔D axis  (rings = the N slices    up→down)
 *   • Each family is N concentric circles about a centre; the three centres
 *     sit at the corners of an (up-pointing) equilateral triangle.
 *   • A face is parallel to exactly two axes, so its stickers ride two families.
 *     The face's N×N grid is exactly the N×N grid of intersection points of
 *     those two families' circles — N circles ∩ N circles → N² dots.
 *       U,D → Top∩Left    F,B → Left∩Right    R,L → Top∩Right
 *     Of each circle-pair's two intersections, the one nearer the third family
 *     centre is the front-visible face (U/F/R); the far one is its opposite
 *     (D/B/L).
 *
 * For N=3 this reproduces the WPF layout (green/F up, white/U right, red/R
 * left, blue/B at the bottom flap, etc.).
 *
 * STATE & COLOUR.  The view never owns cube state; it is told the authoritative
 * state string (6·N² chars, face order U R F D L B, each face row-major) and
 * colours every dot from it.  Animation is driven by the move's permutation
 * (the generic engine in moves-builder.js), so dots slide from their before-
 * position to their after-position and land exactly where the post-move state
 * expects them — seamless by construction.  If the engine can't reproduce the
 * caller's post-move state (unknown notation, convention mismatch), the view
 * snaps to it without animating rather than risk a colour "pop".
 *
 * Public API mirrors cube-3d-nxn.js so app.js can drive all three views the
 * same way:  mountTrefoil(host, size, state) → { setState, animateMove,
 * setOnMove, dispose, size }.
 */

import { buildMoveSet } from './moves-builder.js';

const FACE_ORDER = ['U', 'R', 'F', 'D', 'L', 'B'];
const FACE_INDEX = { U: 0, R: 1, F: 2, D: 3, L: 4, B: 5 };
const FACE_COLORS = {
    U: '#ffffff', // white
    R: '#b71234', // red
    F: '#009b48', // green
    D: '#ffd500', // yellow
    L: '#ff5800', // orange
    B: '#0046ad', // blue
};
const SVGNS = 'http://www.w3.org/2000/svg';

// ── geometry ────────────────────────────────────────────────────────────────
// Returns { faces:{F:[{r,c,x,y}…]…}, families:{Top:{cx,cy,radii[]},…}, ringStep }
// in a model coordinate space (y grows downward, matching SVG / WPF).
function buildGeometry(N) {
    const s = 30;                       // radial gap between adjacent rings
    const span = Math.max(1, N - 1) * s;
    const Rin = 1.667 * span;           // inner ring radius
    // centroid → family-centre distance.  The three centres sit √3·cd apart, so
    // cd ≈ 1.12·span reproduces the WPF 3×3 spacing (centres ~1.93·span apart,
    // inner radius 1.667·span) and keeps every adjacent inner-circle pair well
    // clear of tangency — at cd ≈ 1.94·span the inner circles fail to meet and
    // near/far intersections collapse onto each other.
    const cd = 1.12 * span;
    const radius = (k) => Rin + k * s;  // ring index 0 (inner) … N-1 (outer)
    const deg = (d) => (d * Math.PI) / 180;
    const P = {
        Top:   { cx: cd * Math.cos(deg(-90)), cy: cd * Math.sin(deg(-90)) },
        Left:  { cx: cd * Math.cos(deg(150)), cy: cd * Math.sin(deg(150)) },
        Right: { cx: cd * Math.cos(deg(30)),  cy: cd * Math.sin(deg(30))  },
    };
    for (const k of Object.keys(P)) {
        P[k].radii = Array.from({ length: N }, (_, i) => radius(i));
    }

    // Intersection of circle(A,Ra) and circle(B,Rb); pick the point nearer (or
    // farther) from third centre C.
    function intersect(A, Ra, B, Rb, C, near) {
        const dx = B.cx - A.cx, dy = B.cy - A.cy;
        const d = Math.hypot(dx, dy) || 1e-9;
        const a = (Ra * Ra - Rb * Rb + d * d) / (2 * d);
        const h = Math.sqrt(Math.max(0, Ra * Ra - a * a));
        const mx = A.cx + (a * dx) / d, my = A.cy + (a * dy) / d;
        const ox = (-dy / d) * h, oy = (dx / d) * h;
        const p1 = { x: mx + ox, y: my + oy };
        const p2 = { x: mx - ox, y: my - oy };
        const d1 = Math.hypot(p1.x - C.cx, p1.y - C.cy);
        const d2 = Math.hypot(p2.x - C.cx, p2.y - C.cy);
        const nearer = d1 < d2 ? p1 : p2;
        const farther = d1 < d2 ? p2 : p1;
        return near ? nearer : farther;
    }

    // (face, r, c) → which two families it rides + ring indices + near/far.
    const M = N - 1;
    function faceMap(face, r, c) {
        switch (face) {
            case 'U': return ['Top', M - r, 'Left',  M - c, 'Right', true];
            case 'D': return ['Top', r,     'Left',  M - c, 'Right', false];
            case 'F': return ['Left', M - c, 'Right', r,     'Top',   true];
            case 'B': return ['Left', c,     'Right', r,     'Top',   false];
            case 'R': return ['Top', c,     'Right', r,     'Left',  true];
            case 'L': return ['Top', M - c, 'Right', r,     'Left',  false];
        }
    }

    const faces = {};
    for (const face of FACE_ORDER) {
        const grid = [];
        for (let r = 0; r < N; r++) {
            for (let c = 0; c < N; c++) {
                const [fa, ia, fb, ib, third, near] = faceMap(face, r, c);
                const p = intersect(P[fa], P[fa].radii[ia], P[fb], P[fb].radii[ib], P[third], near);
                grid.push({ r, c, x: p.x, y: p.y });
            }
        }
        faces[face] = grid;
    }
    return { faces, families: P, ringStep: s };
}

// ── module ───────────────────────────────────────────────────────────────────
export function mountTrefoil(host, size, state) {
    const N = size;
    const geo = buildGeometry(N);
    const engine = buildMoveSet(N);     // generic permutation engine for this size
    const TOTAL = 6 * N * N;

    // bounding box (+ padding) over every dot → viewBox
    let minX = Infinity, minY = Infinity, maxX = -Infinity, maxY = -Infinity;
    for (const face of FACE_ORDER) {
        for (const d of geo.faces[face]) {
            if (d.x < minX) minX = d.x; if (d.x > maxX) maxX = d.x;
            if (d.y < minY) minY = d.y; if (d.y > maxY) maxY = d.y;
        }
    }
    const dotR = Math.max(2.0, geo.ringStep * 0.30);
    const pad = dotR * 2.4;
    minX -= pad; minY -= pad; maxX += pad; maxY += pad;

    host.innerHTML = '';
    const svg = document.createElementNS(SVGNS, 'svg');
    svg.setAttribute('viewBox', `${minX} ${minY} ${maxX - minX} ${maxY - minY}`);
    svg.setAttribute('width', '100%');
    svg.setAttribute('height', '100%');
    svg.setAttribute('preserveAspectRatio', 'xMidYMid meet');
    svg.style.display = 'block';
    svg.style.touchAction = 'manipulation';

    // 1) ring guide-circles (the rails the dots slide along)
    const ringLayer = document.createElementNS(SVGNS, 'g');
    ringLayer.setAttribute('fill', 'none');
    ringLayer.setAttribute('stroke', 'currentColor');
    ringLayer.setAttribute('stroke-width', String(Math.max(0.5, dotR * 0.10)));
    ringLayer.setAttribute('opacity', '0.25');
    for (const fam of ['Top', 'Left', 'Right']) {
        const P = geo.families[fam];
        for (const rad of P.radii) {
            const c = document.createElementNS(SVGNS, 'circle');
            c.setAttribute('cx', P.cx); c.setAttribute('cy', P.cy); c.setAttribute('r', rad);
            ringLayer.appendChild(c);
        }
    }
    svg.appendChild(ringLayer);

    // 2) sticker dots — `dots[j]` is the element currently occupying home slot j,
    //    home[j] is that slot's fixed position.  A move permutes `dots` so the
    //    invariant "dots[j] sits at home[j] showing the current colour" holds.
    const dotLayer = document.createElementNS(SVGNS, 'g');
    svg.appendChild(dotLayer);
    const dots = new Array(TOTAL);
    const home = new Array(TOTAL);
    for (const face of FACE_ORDER) {
        const base = FACE_INDEX[face] * N * N;
        for (const d of geo.faces[face]) {
            const j = base + d.r * N + d.c;
            const el = document.createElementNS(SVGNS, 'circle');
            el.setAttribute('cx', d.x); el.setAttribute('cy', d.y); el.setAttribute('r', dotR);
            el.setAttribute('stroke', 'rgba(0,0,0,0.35)');
            el.setAttribute('stroke-width', String(dotR * 0.12));
            dotLayer.appendChild(el);
            dots[j] = el;
            home[j] = { x: d.x, y: d.y };
        }
    }
    host.appendChild(svg);

    let curState = state;
    function paint(s) {
        curState = s;
        for (let j = 0; j < TOTAL; j++) {
            dots[j].setAttribute('cx', home[j].x);
            dots[j].setAttribute('cy', home[j].y);
            dots[j].setAttribute('fill', FACE_COLORS[s[j]] || '#888');
        }
    }
    paint(state);

    // pre-compute, per dot, the family centre of the ring it rides (for arc
    // animation).  A dot rides two families; for a turn about a given centre we
    // arc only those dots equidistant (same ring) from it — decided per move.
    function ringCentreFor(jFrom, jTo) {
        // choose the family centre that keeps |from| ≈ |to| (i.e. both on one of
        // its circles); else null → straight-line move (face-rotation dots).
        let best = null, bestErr = Infinity;
        for (const fam of ['Top', 'Left', 'Right']) {
            const P = geo.families[fam];
            const rf = Math.hypot(home[jFrom].x - P.cx, home[jFrom].y - P.cy);
            const rt = Math.hypot(home[jTo].x - P.cx, home[jTo].y - P.cy);
            const err = Math.abs(rf - rt);
            if (err < bestErr) { bestErr = err; best = P; }
        }
        return bestErr <= geo.ringStep * 0.5 ? best : null;
    }

    // ── animation engine ──────────────────────────────────────────────────────
    let raf = 0;
    let finishCurrent = null;      // flush the running tween to its end state

    function setState(s) {
        if (finishCurrent) finishCurrent();
        paint(s);
    }

    function animateMove(move, after, durMs) {
        if (finishCurrent) finishCurrent();
        const before = curState;
        const perm = engine.permFor(move);
        // engine convention check: newState[i] = before[perm[i]].  Only animate
        // when that reproduces the caller's authoritative post-move state.
        if (!perm) { paint(after); return Promise.resolve(); }
        let consistent = true;
        for (let i = 0; i < TOTAL; i++) {
            if (before[perm[i]] !== after[i]) { consistent = false; break; }
        }
        if (!consistent) { paint(after); return Promise.resolve(); }

        // inverse: sticker colour at position i moves to position inv[i].
        const inv = new Array(TOTAL);
        for (let i = 0; i < TOTAL; i++) inv[perm[i]] = i;

        // build motion tracks for every dot that actually moves
        const tracks = [];
        for (let i = 0; i < TOTAL; i++) {
            const to = inv[i];
            if (to === i) continue;
            const a = home[i], b = home[to];
            const C = ringCentreFor(i, to);
            if (C) {
                const r = Math.hypot(a.x - C.cx, a.y - C.cy);
                const a0 = Math.atan2(a.y - C.cy, a.x - C.cx);
                const a1 = Math.atan2(b.y - C.cy, b.x - C.cx);
                let delta = a1 - a0;
                delta = Math.atan2(Math.sin(delta), Math.cos(delta)); // short way
                tracks.push({ el: dots[i], kind: 'arc', cx: C.cx, cy: C.cy, r, a0, delta });
            } else {
                tracks.push({ el: dots[i], kind: 'lin', x0: a.x, y0: a.y, x1: b.x, y1: b.y });
            }
        }

        const dur = Math.max(60, durMs || 220);
        const ease = (t) => (t < 0.5 ? 2 * t * t : 1 - Math.pow(-2 * t + 2, 2) / 2);

        return new Promise((resolve) => {
            const start = (typeof performance !== 'undefined' ? performance.now() : 0);
            let done = false;
            const finish = () => {
                if (done) return; done = true;
                if (raf) { cancelAnimationFrame(raf); raf = 0; }
                finishCurrent = null;
                // relabel: the element that slid into slot inv[i] now owns it.
                const next = new Array(TOTAL);
                for (let j = 0; j < TOTAL; j++) next[j] = dots[perm[j]];
                for (let j = 0; j < TOTAL; j++) dots[j] = next[j];
                paint(after);          // snaps to exact home positions + colours
                resolve();
            };
            finishCurrent = finish;
            const frame = (now) => {
                const t = ease(Math.min(1, (now - start) / dur));
                for (const tk of tracks) {
                    if (tk.kind === 'arc') {
                        const a = tk.a0 + tk.delta * t;
                        tk.el.setAttribute('cx', tk.cx + tk.r * Math.cos(a));
                        tk.el.setAttribute('cy', tk.cy + tk.r * Math.sin(a));
                    } else {
                        tk.el.setAttribute('cx', tk.x0 + (tk.x1 - tk.x0) * t);
                        tk.el.setAttribute('cy', tk.y0 + (tk.y1 - tk.y0) * t);
                    }
                }
                if (t >= 1) { finish(); return; }
                raf = requestAnimationFrame(frame);
            };
            raf = requestAnimationFrame(frame);
        });
    }

    function dispose() {
        if (finishCurrent) finishCurrent();
        if (raf) cancelAnimationFrame(raf);
        host.innerHTML = '';
    }

    return {
        size: N,
        setState,
        animateMove,
        setOnMove() {},   // no drag-to-turn in this view (the 3-D cube owns that)
        dispose,
    };
}
