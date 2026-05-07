/**
 * Cubing-guide app — wires the data tables to DOM, mounts the live 3D
 * cube on the active tab, generates "after-state" cube nets per algorithm.
 *
 * Single mounted 3D cube (lazy on first interaction) reused everywhere
 * the user clicks "▶ Play" — keeps the page light.
 *
 * State computation: moves-builder.applyMoves on a solved 3×3 string
 *   → renders via mountCubeNet for static thumbnails
 *   → drives mountCubeNxN.animateMove for the play button
 */

import { buildMoveSet } from '../rubiks-nxn/moves-builder.js';
import { mountCubeNet } from '../rubiks/cube-net.js';
import { mountCubeNxN } from '../rubiks-nxn/cube-3d-nxn.js';
import { applyMoves as apply3cubejs, initSolver } from '../rubiks/solver.js';
import {
    NOTATION, ALG_LIBRARY, LBL_STAGES, CFOP_PHASES, BIG_CUBE_STAGES,
    GLOSSARY, COLOR_SCHEMES,
} from './data.js';

// ── solved-state helpers ──────────────────────────────────────────────
const SOLVED_3 = 'U'.repeat(9) + 'R'.repeat(9) + 'F'.repeat(9)
               + 'D'.repeat(9) + 'L'.repeat(9) + 'B'.repeat(9);
const ms3 = buildMoveSet(3);

/** Apply an algorithm string to solved-3 and return the resulting state.
 *  Works via moves-builder, which handles every notation form (R, Rw,
 *  2Rw, M, x, etc.).  Falls back to identity on parse error. */
function applyAlg(alg) {
    try {
        return ms3.applyMoves(SOLVED_3, alg);
    } catch (e) {
        console.warn('alg apply failed:', alg, e.message);
        return SOLVED_3;
    }
}

// Map our state-string convention (URFDLB) to the cube-net renderer's
// expected face order, which matches.  The renderer reads `state[idx]`
// against PLACEMENTS where `idx` runs over (U, R, F, D, L, B) face
// stickers in face-major row-major order — same as moves-builder.
const FACE_COLOR_MAP = {
    U: '#ffffff', D: '#fde047', F: '#22c55e', B: '#3b82f6', R: '#ef4444', L: '#f97316',
};

// ── tiny helpers ──────────────────────────────────────────────────────
const $ = id => document.getElementById(id);
const el = (tag, attrs = {}, ...children) => {
    const n = document.createElement(tag);
    for (const [k, v] of Object.entries(attrs)) {
        if (k === 'className') n.className = v;
        else if (k === 'html')  n.innerHTML = v;
        else if (k.startsWith('on')) n.addEventListener(k.slice(2), v);
        else n.setAttribute(k, v);
    }
    for (const c of children) {
        if (c == null) continue;
        n.appendChild(typeof c === 'string' ? document.createTextNode(c) : c);
    }
    return n;
};

/** Build a tiny static SVG cube-net thumbnail directly (no mountCubeNet —
 *  that's optimised for full-size live editing, overkill for thumbnails).
 *  Layout: standard cross — U top, L F R B middle row, D bottom. */
function buildNetSvg(state, opts = {}) {
    const N = 3;
    const cell = opts.cell || 12;
    const gap = 1;
    const FF = N * N;
    const FACE_OFFSETS = { U: 0, R: FF, F: 2*FF, D: 3*FF, L: 4*FF, B: 5*FF };
    // (faceLetter, gridRow, gridCol) in the cross net layout
    const LAYOUT = [
        ['U', 0, 1], ['L', 1, 0], ['F', 1, 1], ['R', 1, 2], ['B', 1, 3], ['D', 2, 1],
    ];
    const w = 4 * N * cell + 5 * gap;
    const h = 3 * N * cell + 4 * gap;
    const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
    svg.setAttribute('viewBox', `0 0 ${w} ${h}`);
    svg.setAttribute('width', opts.width || '100%');
    svg.setAttribute('class', 'cg-net-svg');
    for (const [face, gr, gc] of LAYOUT) {
        const baseOff = FACE_OFFSETS[face];
        for (let r = 0; r < N; r++) {
            for (let c = 0; c < N; c++) {
                const x = gc * N * cell + c * cell + (gc + 1) * gap;
                const y = gr * N * cell + r * cell + (gr + 1) * gap;
                const ch = state[baseOff + r * N + c];
                const rect = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
                rect.setAttribute('x', x);
                rect.setAttribute('y', y);
                rect.setAttribute('width',  cell - 0.5);
                rect.setAttribute('height', cell - 0.5);
                rect.setAttribute('rx', 1.5);
                rect.setAttribute('fill', FACE_COLOR_MAP[ch] || '#444');
                rect.setAttribute('stroke', '#1f2937');
                rect.setAttribute('stroke-width', 0.4);
                svg.appendChild(rect);
            }
        }
    }
    return svg;
}

// ── live 3D cube — one shared instance ─────────────────────────────────
let live3dCube = null;
let live3dHostHadInit = false;

async function ensureLiveCube() {
    if (live3dCube) return live3dCube;
    const host = $('cg-live-cube-host');
    if (!host) return null;
    live3dCube = await mountCubeNxN(host, 3, SOLVED_3);
    live3dHostHadInit = true;
    return live3dCube;
}

/** Reset the live 3D cube to solved, then animate the algorithm. */
async function playAlgOnLiveCube(algStr) {
    const c = await ensureLiveCube();
    if (!c) return;
    // Reset to solved instantly, then animate each move at default speed.
    c.setState(SOLVED_3);
    const tokens = algStr.trim().split(/\s+/).filter(Boolean);
    let state = SOLVED_3;
    for (const t of tokens) {
        try {
            state = ms3.applyMoves(state, [t]);
            await c.animateMove(t, state, 220);
        } catch (e) {
            console.warn('play failed at', t, e.message);
            return;
        }
    }
    // Scroll the live cube into view (helpful when user clicks Play
    // from a tab below the fold).
    $('cg-live-cube-card').scrollIntoView({ behavior: 'smooth', block: 'nearest' });
}

// ── tab switching ─────────────────────────────────────────────────────
function switchTab(tabId) {
    for (const t of document.querySelectorAll('.cg-tab')) {
        t.classList.toggle('active', t.dataset.tab === tabId);
        t.setAttribute('aria-selected', t.dataset.tab === tabId ? 'true' : 'false');
    }
    for (const p of document.querySelectorAll('.cg-tab-panel')) {
        const isActive = p.dataset.tab === tabId;
        p.style.display = isActive ? 'block' : 'none';
        p.setAttribute('aria-hidden', isActive ? 'false' : 'true');
    }
    history.replaceState(null, '', `#tab=${tabId}`);
}

// ── tab 1: Notation ────────────────────────────────────────────────────
function buildNotationTab() {
    const root = $('cg-tab-notation');
    if (!root) return;
    let activeFilter = 'all';

    const filterRow = el('div', { className: 'cg-filter-row' });
    for (const [key, label] of [
        ['all',      'All'],
        ['face',     'Face turns'],
        ['wide',     'Wide turns'],
        ['inner',    'Inner slices (big)'],
        ['middle',   '3×3 middle (M E S)'],
        ['rotation', 'Cube rotations'],
    ]) {
        const chip = el('button', {
            className: 'cg-chip' + (key === 'all' ? ' active' : ''),
            type: 'button',
            'data-filter': key,
            onclick: () => {
                activeFilter = key;
                for (const c of filterRow.querySelectorAll('.cg-chip')) {
                    c.classList.toggle('active', c.dataset.filter === key);
                }
                renderRows();
            },
        }, label);
        filterRow.appendChild(chip);
    }

    const tableWrap = el('div', { className: 'cg-table-wrap' });
    const table = el('table', { className: 'cg-notation-table' });
    const thead = el('thead', {}, el('tr', {},
        el('th', {}, 'Move'),
        el('th', {}, 'What it does'),
        el('th', {}, 'Cubes'),
        el('th', {}, 'Net (after)'),
        el('th', {}, '')
    ));
    const tbody = el('tbody');
    table.appendChild(thead);
    table.appendChild(tbody);
    tableWrap.appendChild(table);

    function renderRows() {
        tbody.innerHTML = '';
        const filtered = activeFilter === 'all'
            ? NOTATION : NOTATION.filter(n => n.group === activeFilter);
        for (const n of filtered) {
            const tr = el('tr', { id: 'move-' + n.move.replace(/[^A-Za-z0-9]/g, '_') });
            tr.appendChild(el('td', { className: 'cg-move' },
                el('code', {}, n.move),
                n.alias ? el('span', { className: 'cg-alias' }, ' ≡ ' + n.alias) : null,
            ));
            tr.appendChild(el('td', { className: 'cg-meaning' }, n.meaning));
            tr.appendChild(el('td', { className: 'cg-sizes' }, n.sizes + '×' + n.sizes.replace('+', '+')));
            const netCell = el('td', { className: 'cg-net-cell' });
            // Cube rotations aren't visually distinct on a static net (the
            // colours don't change positions on a net diagram, only the
            // viewer's frame does).  Show a placeholder.
            if (n.group === 'rotation') {
                netCell.appendChild(el('span', { className: 'cg-net-skip' }, 'whole-cube tilt'));
            } else {
                const after = applyAlg(n.move);
                netCell.appendChild(buildNetSvg(after, { cell: 9 }));
            }
            tr.appendChild(netCell);
            tr.appendChild(el('td', { className: 'cg-play-cell' },
                el('button', {
                    className: 'cg-play-btn', type: 'button',
                    title: 'Play ' + n.move + ' on the live cube',
                    onclick: () => playAlgOnLiveCube(n.move),
                }, '▶'),
            ));
            tbody.appendChild(tr);
        }
    }

    root.appendChild(filterRow);
    root.appendChild(tableWrap);
    renderRows();
}

// ── tab 2: Beginner LBL ────────────────────────────────────────────────
function buildLblTab() {
    const root = $('cg-tab-beginner');
    if (!root) return;
    for (let i = 0; i < LBL_STAGES.length; i++) {
        const s = LBL_STAGES[i];
        const card = el('div', { className: 'cg-stage-card' });
        card.appendChild(el('h3', { className: 'cg-stage-name' }, s.name));
        card.appendChild(el('p', { className: 'cg-stage-goal' },
            el('strong', {}, 'Goal: '), s.goal));
        card.appendChild(el('p', { className: 'cg-stage-tip' },
            el('strong', {}, 'How: '), s.tip));
        if (s.algs && s.algs.length) {
            const algRow = el('div', { className: 'cg-stage-algs' });
            for (const a of s.algs) {
                algRow.appendChild(el('div', { className: 'cg-stage-alg' },
                    el('span', { className: 'cg-stage-alg-name' }, a.name + ': '),
                    el('code', {}, a.alg),
                    el('button', {
                        className: 'cg-play-btn',
                        type: 'button',
                        onclick: () => playAlgOnLiveCube(a.alg),
                    }, '▶'),
                ));
            }
            card.appendChild(algRow);
        }
        root.appendChild(card);
    }
}

// ── tab 3: Speedcubing CFOP ────────────────────────────────────────────
function buildCfopTab() {
    const root = $('cg-tab-cfop');
    if (!root) return;
    root.appendChild(el('p', { className: 'cg-intro' },
        'CFOP (Cross / F2L / OLL / PLL — also called Fridrich) is the most-used speedcubing method. ',
        'You learn it in stages — start with 2-look OLL + 2-look PLL (16 algs total), then graduate to ',
        'full OLL (57) and full PLL (21) when comfortable.'));
    for (const phase of CFOP_PHASES) {
        const card = el('div', { className: 'cg-stage-card' });
        card.appendChild(el('h3', { className: 'cg-stage-name' }, phase.name));
        card.appendChild(el('p', { className: 'cg-stage-goal' },
            el('strong', {}, 'Goal: '), phase.goal));
        card.appendChild(el('p', { className: 'cg-stage-tip' },
            el('strong', {}, 'Tip: '), phase.tip));
        root.appendChild(card);
    }
    root.appendChild(el('p', { className: 'cg-intro cg-intro-after' },
        'See the ', el('a', { href: '#tab=algs', onclick: (e) => { e.preventDefault(); switchTab('algs'); } }, 'Algorithm library'),
        ' tab for the actual algs (sexy, sune, T-perm, J-perm, etc.) you\'ll need.'));
}

// ── tab 4: Big cubes (4×4+) ────────────────────────────────────────────
function buildBigCubeTab() {
    const root = $('cg-tab-bigcube');
    if (!root) return;
    root.appendChild(el('p', { className: 'cg-intro' },
        '4×4 and larger cubes use the ', el('strong', {}, 'reduction method'), ': solve all the centres, ',
        'pair the edges, then the cube becomes a "virtual 3×3" you can solve with normal CFOP/LBL. ',
        'There\'s one twist — ', el('strong', {}, 'parity'), ' — two end-game cases that look impossible on a 3×3.'));
    for (const stage of BIG_CUBE_STAGES) {
        const card = el('div', { className: 'cg-stage-card' });
        card.appendChild(el('h3', { className: 'cg-stage-name' }, stage.name));
        card.appendChild(el('p', { className: 'cg-stage-goal' },
            el('strong', {}, 'Goal: '), stage.goal));
        card.appendChild(el('p', { className: 'cg-stage-tip' },
            el('strong', {}, 'How: '), stage.tip));
        root.appendChild(card);
    }
}

// ── tab 5: Algorithm library ───────────────────────────────────────────
function buildAlgLibTab() {
    const root = $('cg-tab-algs');
    if (!root) return;

    const allTags = ['all', ...new Set(ALG_LIBRARY.flatMap(a => a.tags))];
    let activeTag = 'all';
    let searchTerm = '';

    const controls = el('div', { className: 'cg-controls' });
    const search = el('input', {
        type: 'search',
        placeholder: 'Search by name, alg, or tag…',
        className: 'cg-search',
        oninput: (e) => { searchTerm = e.target.value.toLowerCase(); render(); },
    });
    controls.appendChild(search);

    const tagRow = el('div', { className: 'cg-filter-row' });
    for (const t of allTags) {
        const chip = el('button', {
            className: 'cg-chip' + (t === 'all' ? ' active' : ''),
            type: 'button',
            'data-tag': t,
            onclick: () => {
                activeTag = t;
                for (const c of tagRow.querySelectorAll('.cg-chip')) {
                    c.classList.toggle('active', c.dataset.tag === t);
                }
                render();
            },
        }, t);
        tagRow.appendChild(chip);
    }

    const grid = el('div', { className: 'cg-alg-grid' });

    function render() {
        grid.innerHTML = '';
        const filtered = ALG_LIBRARY.filter(a => {
            if (activeTag !== 'all' && !a.tags.includes(activeTag)) return false;
            if (searchTerm) {
                const hay = (a.name + ' ' + a.alg + ' ' + a.tags.join(' ')).toLowerCase();
                if (!hay.includes(searchTerm)) return false;
            }
            return true;
        });
        if (filtered.length === 0) {
            grid.appendChild(el('div', { className: 'cg-empty' }, 'No algorithms match.'));
            return;
        }
        for (const a of filtered) {
            const card = el('div', { className: 'cg-alg-card' });
            const head = el('div', { className: 'cg-alg-head' });
            head.appendChild(el('h4', { className: 'cg-alg-name' }, a.name));
            head.appendChild(el('button', {
                className: 'cg-play-btn cg-play-btn-lg',
                type: 'button',
                title: 'Play this algorithm on the live cube',
                onclick: () => playAlgOnLiveCube(a.alg),
            }, '▶'));
            card.appendChild(head);
            card.appendChild(el('code', { className: 'cg-alg-notation' }, a.alg));
            card.appendChild(el('p', { className: 'cg-alg-purpose' }, a.purpose));
            const after = applyAlg(a.alg);
            card.appendChild(buildNetSvg(after, { cell: 10 }));
            const tagRow = el('div', { className: 'cg-alg-tags' });
            for (const t of a.tags) tagRow.appendChild(el('span', { className: 'cg-tag' }, t));
            card.appendChild(tagRow);
            grid.appendChild(card);
        }
    }

    root.appendChild(controls);
    root.appendChild(tagRow);
    root.appendChild(grid);
    render();
}

// ── tab 6: Glossary & color schemes ────────────────────────────────────
function buildGlossaryTab() {
    const root = $('cg-tab-glossary');
    if (!root) return;

    // Color schemes first (visual)
    root.appendChild(el('h3', { className: 'cg-section-h' }, 'Color schemes'));
    const schemeGrid = el('div', { className: 'cg-scheme-grid' });
    for (const sch of COLOR_SCHEMES) {
        const card = el('div', { className: 'cg-scheme-card' });
        card.appendChild(el('h4', {}, sch.name));
        card.appendChild(el('p', { className: 'cg-scheme-common' }, sch.common));
        const layoutRow = el('div', { className: 'cg-scheme-layout' });
        for (const [face, color] of Object.entries(sch.layout)) {
            const swatch = el('div', { className: 'cg-scheme-swatch' });
            swatch.appendChild(el('div', {
                className: 'cg-scheme-color',
                style: 'background:' + colorNameToHex(color) + ';',
            }));
            swatch.appendChild(el('div', { className: 'cg-scheme-label' }, face + ' = ' + color));
            layoutRow.appendChild(swatch);
        }
        card.appendChild(layoutRow);
        card.appendChild(el('p', { className: 'cg-scheme-mnemonic' },
            el('strong', {}, 'Memory: '), sch.mnemonic));
        schemeGrid.appendChild(card);
    }
    root.appendChild(schemeGrid);

    // Glossary
    root.appendChild(el('h3', { className: 'cg-section-h' }, 'Cubing glossary'));
    const dl = el('dl', { className: 'cg-glossary' });
    for (const g of GLOSSARY) {
        dl.appendChild(el('dt', {}, g.term));
        dl.appendChild(el('dd', {}, g.def));
    }
    root.appendChild(dl);

    // Sources
    root.appendChild(el('h3', { className: 'cg-section-h' }, 'Sources & further reading'));
    const sources = el('ul', { className: 'cg-sources' });
    for (const [text, url] of [
        ['WCA Regulations',          'https://www.worldcubeassociation.org/regulations/'],
        ['WCA Notation — Meep',      'https://meep.cubing.net/wcanotation.html'],
        ['Speedsolving Wiki — NxNxN Notation', 'https://speedsolving.com/wiki/index.php/Notation'],
        ['Cubelelo — Notation Guide','https://www.cubelelo.com/blogs/cubing/understanding-rubik-s-cube-notation-for-every-wca-puzzle'],
    ]) {
        sources.appendChild(el('li', {},
            el('a', { href: url, target: '_blank', rel: 'noopener' }, text)));
    }
    root.appendChild(sources);
}

function colorNameToHex(c) {
    return ({
        White: '#ffffff', Yellow: '#fde047', Green: '#22c55e',
        Blue: '#3b82f6', Red: '#ef4444', Orange: '#f97316',
    })[c] || '#ccc';
}

// ── boot ───────────────────────────────────────────────────────────────
function boot() {
    buildNotationTab();
    buildLblTab();
    buildCfopTab();
    buildBigCubeTab();
    buildAlgLibTab();
    buildGlossaryTab();

    for (const t of document.querySelectorAll('.cg-tab')) {
        t.addEventListener('click', () => switchTab(t.dataset.tab));
    }
    // Pre-init cubejs in the background — first 3×3 alg play uses it.
    initSolver().catch(() => {});

    // Open the tab from the URL fragment (#tab=algs etc.).
    const m = /#tab=(\w+)/.exec(location.hash);
    switchTab(m ? m[1] : 'notation');
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', boot);
} else {
    boot();
}
