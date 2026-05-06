/**
 * SVG net renderer for the 5×5 cube — port of {@code rubiks4/cube-net.js}
 * with N=5 (tighter sticker size to keep total layout width similar to
 * the 4×4 / 3×3 nets).
 */

import { FACE_COLORS, FACES, GRID_COLS, GRID_ROWS, PLACEMENTS, TOTAL_STICKERS } from './cube.js';

const STICKER_SIZE = 22;   // 20 cols × 22 = 440 px wide (similar to 4×4's 448)
const STICKER_GAP  = 2;
const RADIUS       = 2.5;
const SVG_NS       = 'http://www.w3.org/2000/svg';

export function mountCubeNet(host, opts = {}) {
    const width = GRID_COLS * STICKER_SIZE;
    const height = GRID_ROWS * STICKER_SIZE;

    const svg = document.createElementNS(SVG_NS, 'svg');
    svg.setAttribute('viewBox', `0 0 ${width} ${height}`);
    svg.setAttribute('width', '100%');
    svg.setAttribute('role', 'img');
    svg.setAttribute('aria-label', "5×5 Rubik's cube unfolded net");
    svg.style.maxWidth = `${width}px`;
    svg.style.display  = 'block';

    const rects = new Array(TOTAL_STICKERS);

    let current = {
        state: opts.state || '',
        editable: !!opts.editable,
        onChange: opts.onChange || null,
        highlightIndices: opts.highlightIndices || [],
    };

    for (const p of PLACEMENTS) {
        const x = p.col * STICKER_SIZE + STICKER_GAP / 2;
        const y = p.row * STICKER_SIZE + STICKER_GAP / 2;
        const size = STICKER_SIZE - STICKER_GAP;
        const rect = document.createElementNS(SVG_NS, 'rect');
        rect.setAttribute('x', x);
        rect.setAttribute('y', y);
        rect.setAttribute('width', size);
        rect.setAttribute('height', size);
        rect.setAttribute('rx', RADIUS);
        rect.setAttribute('ry', RADIUS);
        rect.dataset.index = String(p.index);
        rect.dataset.face = p.face;
        const title = document.createElementNS(SVG_NS, 'title');
        rect.appendChild(title);
        rect.addEventListener('click', () => {
            if (!current.editable || !current.onChange) return;
            const cur = current.state[p.index];
            const next = FACES[(FACES.indexOf(cur) + 1) % FACES.length];
            current.onChange(p.index, next);
        });
        svg.appendChild(rect);
        rects[p.index] = rect;
    }

    host.innerHTML = '';
    host.appendChild(svg);

    function paint() {
        const highlightSet = new Set(current.highlightIndices);
        for (const p of PLACEMENTS) {
            const face = current.state[p.index];
            const fill = FACE_COLORS[face] || '#888';
            const r = rects[p.index];
            r.setAttribute('fill', fill);
            const isHi = highlightSet.has(p.index);
            r.setAttribute('stroke', isHi ? '#000' : '#222');
            r.setAttribute('stroke-width', isHi ? 2 : 0.6);
            r.style.cursor = current.editable ? 'pointer' : '';
            const t = r.firstChild;
            if (t) t.textContent = `${p.face}${p.facePos + 1}: ${face}`;
        }
    }

    paint();

    return {
        el: svg,
        update(patch) {
            current = { ...current, ...patch };
            paint();
        },
    };
}
