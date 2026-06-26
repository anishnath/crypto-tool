/**
 * Renders Aquascope "ownership" JSON (rust-ownership viz engine) as two views,
 * modeled on Aquascope's editor (frontend/packages/aquascope-editor):
 *
 *  1. PERMISSIONS (compile-time) — from `permissions[]`:
 *     boundaries[] -> R/W/O markers at use sites (struck when actual<expected);
 *     steps[]      -> permission-step tables (path | event | R W O):
 *       High=+R gained, Low=struck R lost, None+true=plain, None+false=‒.
 *
 *  2. RUNTIME (interpreter / Miri) — from `interpreter` (MTrace), laid out like
 *     Aquascope: a vertical L1..Ln sequence, each step = Stack box + Heap box
 *     with drawn arrows from pointers to their heap allocations. A Vec/String/Box
 *     collapses (simple mode) to a single pointer into the heap.
 *     result.Error PointerUseAfterFree -> "undefined behavior" banner.
 *
 * Engine output: { kind:"ownership",
 *   permissions:[ {Ok:{boundaries,steps,loan_regions}} ],
 *   interpreter:{ Ok:{ steps:[{stack:{frames:[{name,locals:[{name,value,moved_paths}]}]},
 *                              heap:{locations:[MValue]}}], result } } }
 * MValue is serde-tagged {type,value}. (lines/columns 0-indexed.)
 */
(function (global) {
    'use strict';

    var SVGNS = 'http://www.w3.org/2000/svg';
    var PCLASS = { R: 'read', W: 'write', O: 'own' };

    function esc(s) {
        return String(s).replace(/[&<>"]/g, function (c) {
            return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c];
        });
    }
    function vtype(v) { return v && v.type; }

    function okBodies(ownership) {
        var perms = (ownership && ownership.permissions) || ownership || [];
        if (!Array.isArray(perms)) return [];
        return perms.map(function (e) { return e && e.Ok; }).filter(Boolean);
    }

    // interpreter op serializes a Rust Result<MTrace> -> {"Ok":{steps,result}}.
    function normInterp(raw) {
        if (!raw) return null;
        if (Array.isArray(raw)) raw = raw[0];
        if (raw && raw.Ok) raw = raw.Ok;
        return raw && Array.isArray(raw.steps) ? raw : null;
    }

    /* ===================== permissions ===================== */

    function boundaryMarker(bd) {
        var items = [
            { c: 'R', exp: bd.expected.read, act: bd.actual.read },
            { c: 'W', exp: bd.expected.write, act: bd.actual.write },
            { c: 'O', exp: bd.expected.drop, act: bd.actual.drop }
        ].filter(function (i) { return i.exp; });
        if (!items.length) return '';
        var inner = items.map(function (i) {
            var cls = 'own-perm own-' + PCLASS[i.c] + (i.act ? '' : ' own-missing');
            var t = i.c + (i.act ? ' permission held here' : ' permission REQUIRED but missing here');
            return '<span class="' + cls + '" title="' + esc(t) + '">' + i.c + '</span>';
        }).join('');
        return '<span class="own-stack" title="permissions required at this use">' + inner + '</span>';
    }

    function eventGlyphs(diff) {
        var out = [];
        var push = function (cls, g, t) { out.push('<span class="own-evt own-evt-' + cls + '" title="' + esc(t) + '">' + g + '</span>'); };
        if (vtype(diff.path_moved) === 'High') push('move', '⇥', 'value moved away here');
        else if (vtype(diff.path_moved) === 'Low') push('reinit', '↻', 're-initialized after move');
        var lr = vtype(diff.loan_write_refined) === 'None' ? diff.loan_read_refined : diff.loan_write_refined;
        if (vtype(lr) === 'High') push('borrow', '→', 'borrowed here');
        else if (vtype(lr) === 'Low') push('unborrow', '↩', 'borrow released here');
        if (vtype(diff.is_live) === 'High') push('init', '↑', 'initialized here');
        else if (vtype(diff.is_live) === 'Low') push('dead', '↓', 'no longer used here');
        return out.join('');
    }

    function permCell(step, ch) {
        var cls = 'own-perm own-' + PCLASS[ch];
        var t = vtype(step);
        if (t === 'High') return '<td class="own-pc"><span class="own-add">+</span><span class="' + cls + '">' + ch + '</span></td>';
        if (t === 'Low') return '<td class="own-pc"><span class="own-sub"><span class="' + cls + '">' + ch + '</span></span></td>';
        if (step && step.value) return '<td class="own-pc"><span class="' + cls + '">' + ch + '</span></td>';
        return '<td class="own-pc own-na">‒</td>';
    }

    function stepRow(path, diff) {
        var p = diff.permissions || {};
        return '<tr><td class="own-path">' + esc(path) + '</td>' +
            '<td class="own-event">' + eventGlyphs(diff) + '</td>' +
            permCell(p.read, 'R') + permCell(p.write, 'W') + permCell(p.drop, 'O') + '</tr>';
    }

    function stepTablesHtml(step) {
        var tables = (step.state || []).map(function (tbl) {
            var rows = (tbl.state || []).map(function (pair) { return stepRow(pair[0], pair[1]); }).join('');
            return '<table class="own-step-table"><tbody>' + rows + '</tbody></table>';
        }).join('');
        if (!tables) return '';
        return '<span class="own-step-widget"><span class="own-step-toggle" title="toggle">«</span>' +
            '<span class="own-step-box">' + tables + '</span></span>';
    }

    function insertInline(text, markers) {
        if (!markers || !markers.length) return esc(text);
        markers.sort(function (a, b) { return a.col - b.col; });
        var out = '', cur = 0;
        markers.forEach(function (m) {
            var c = Math.max(0, Math.min(m.col, text.length));
            if (c < cur) { out += m.html; return; }
            out += esc(text.slice(cur, c)) + m.html;
            cur = c;
        });
        return out + esc(text.slice(cur));
    }

    function renderPermissions(code, bodies) {
        var lines = String(code || '').replace(/\n$/, '').split('\n');
        var bByLine = {}, sByLine = {};
        bodies.forEach(function (b) {
            (b.boundaries || []).forEach(function (bd) {
                var ln = bd.location.line;
                (bByLine[ln] = bByLine[ln] || []).push({ col: bd.location.column, html: boundaryMarker(bd) });
            });
            (b.steps || []).forEach(function (st) {
                var loc = (st.location && (st.location.end || st.location)) || {};
                var ln = loc.line || 0;
                (sByLine[ln] = sByLine[ln] || []).push(st);
            });
        });

        var rows = lines.map(function (text, i) {
            var c = insertInline(text, bByLine[i]);
            var steps = (sByLine[i] || []).map(stepTablesHtml).join('');
            return '<div class="own-line">' +
                '<span class="own-ln">' + (i + 1) + '</span>' +
                '<span class="own-code">' + c + '</span>' +
                '<span class="own-steps">' + steps + '</span>' +
                '</div>';
        }).join('');

        return '<div class="own-perm-view">' + rows + '</div>' +
            '<div class="own-legend">' +
            '<span><span class="own-perm own-read">R</span><span class="own-perm own-write">W</span><span class="own-perm own-own">O</span> read / write / own</span>' +
            '<span><span class="own-add">+</span>R gained · <span class="own-sub"><span class="own-perm own-read">R</span></span> lost · ‒ absent</span>' +
            '<span><span class="own-evt own-evt-borrow">→</span> borrow · <span class="own-evt own-evt-move">⇥</span> move · <span class="own-evt own-evt-init">↑</span> init</span>' +
            '<span><span class="own-perm own-read own-missing">R</span> required but missing (use-after-move)</span>' +
            '</div>';
    }

    /* ===================== interpreter values ===================== */

    function readField(adt, name) {
        var f = (adt && adt.fields || []).filter(function (x) { return x[0] === name; })[0];
        return f && f[1] && f[1].value;   // returns inner Adt value
    }

    // Heap index a pointer targets, or null.
    function ptrHeapIndex(mvPointer) {
        var seg = mvPointer && mvPointer.path && mvPointer.path.segment;
        if (!seg) return null;
        if (seg.type === 'Heap') return seg.value && seg.value.index;
        if (seg.Heap) return seg.Heap.index;
        return null;
    }

    // First heap pointer reachable inside a value (Vec/String/Box collapse).
    function findHeapPtr(mv) {
        if (!mv || !mv.type) return null;
        if (mv.type === 'Pointer') return ptrHeapIndex(mv.value);
        if (mv.type === 'Adt') {
            var fs = mv.value.fields || [];
            for (var i = 0; i < fs.length; i++) {
                var r = findHeapPtr(fs[i][1]);
                if (r != null) return r;
            }
        }
        if (mv.type === 'Tuple') {
            for (var j = 0; j < (mv.value || []).length; j++) {
                var r2 = findHeapPtr(mv.value[j]);
                if (r2 != null) return r2;
            }
        }
        return null;
    }

    // Inline scalar/compound value (no heap pointer).
    function valueHtml(mv) {
        if (!mv || !mv.type) return '<span class="mv-prim">?</span>';
        var v = mv.value;
        switch (mv.type) {
            case 'Bool': return '<span class="mv-prim">' + (v ? 'true' : 'false') + '</span>';
            case 'Char': return '<span class="mv-prim">\'' + esc(String.fromCharCode(v)) + '\'</span>';
            case 'Uint':
            case 'Int':
            case 'Float': return '<span class="mv-prim">' + esc(String(v)) + '</span>';
            case 'FnPtr': return '<span class="mv-prim">fn</span>';
            case 'Tuple': return '(' + (v || []).map(valueHtml).join(', ') + ')';
            case 'Array': return arrayCells(v);
            case 'Adt': return adtHtml(mv.value);
            case 'Pointer': return '<span class="mv-ptr">•stack</span>';
            case 'Unallocated': return '<span class="mv-freed" title="memory was freed">⌀ freed</span>';
            default: return '<span class="mv-prim">' + esc(mv.type) + '</span>';
        }
    }

    function arrayCells(abbr) {
        if (!abbr) return '<span class="mv-arr"></span>';
        var parts;
        if (abbr.type === 'All') parts = (abbr.value || []).map(valueHtml);
        else parts = ((abbr.value && abbr.value[0]) || []).map(valueHtml)
            .concat(['<span class="mv-ell">…</span>', valueHtml(abbr.value && abbr.value[1])]);
        return '<span class="mv-arr">' +
            parts.map(function (p) { return '<span class="mv-acell">' + p + '</span>'; }).join('') +
            '</span>';
    }

    function adtHtml(a) {
        var head = esc(a.variant || a.name || 'struct');
        var fields = (a.fields || []).map(function (f) {
            return '<span class="mv-field">' + esc(f[0]) + ':</span> ' + cellValue(f[1]);
        });
        if (!fields.length) return '<span class="mv-adt">' + head + '</span>';
        return '<span class="mv-adt">' + head + ' { ' + fields.join(', ') + ' }</span>';
    }

    // A value as it appears in a stack local / struct field: a heap-owning value
    // collapses to a pointer dot; everything else renders inline.
    function cellValue(mv) {
        if (!mv || !mv.type) return '?';
        if (mv.type === 'Unallocated') return '<span class="mv-freed" title="memory was freed">⌀ freed</span>';
        if (mv.type === 'Pointer') {
            var pi = ptrHeapIndex(mv.value);
            return pi != null ? dot(pi) : '<span class="mv-ptr">•</span>';
        }
        if (mv.type === 'Adt' && mv.value.alloc_kind) {
            var hi = findHeapPtr(mv);
            if (hi != null) return dot(hi);
        }
        return valueHtml(mv);
    }

    function dot(heapIdx) {
        return '<span class="mv-dot" data-heap-target="' + heapIdx + '">●</span>';
    }

    /* ===================== interpreter layout ===================== */

    function localsRows(locals) {
        if (!locals || !locals.length) return '<div class="mv-empty-frame">(empty frame)</div>';
        return '<table class="mv-locals"><tbody>' + locals.map(function (l) {
            var moved = (l.moved_paths || []).some(function (p) { return p.length === 0; });
            return '<tr class="mv-local' + (moved ? ' mv-moved' : '') + '">' +
                '<td class="mv-name">' + esc(l.name) + '</td>' +
                '<td class="mv-lval">' + cellValue(l.value) + '</td></tr>';
        }).join('') + '</tbody></table>';
    }

    function frameBox(frame) {
        return '<div class="mv-frame"><div class="mv-frame-name">' + esc(frame.name || 'fn') + '</div>' +
            localsRows(frame.locals) + '</div>';
    }

    function stepLine(step) {
        var frs = step.stack && step.stack.frames || [];
        var top = frs[frs.length - 1];
        var loc = top && top.location && (top.location.start || top.location);
        return loc ? loc.line : null;   // 0-indexed
    }

    function stepHtml(step, i) {
        var frames = (step.stack && step.stack.frames || []).map(frameBox).join('');
        var locs = (step.heap && step.heap.locations) || [];
        var heapBox = locs.length
            ? '<div class="mv-mem mv-heap"><div class="mv-mem-h">Heap</div>' +
                locs.map(function (val, idx) {
                    return '<div class="mv-heap-cell" data-heap="' + idx + '">' + valueHtml(val) + '</div>';
                }).join('') + '</div>'
            : '';
        var ln = stepLine(step);
        var lineTag = ln != null ? '<span class="mv-lk-line">line ' + (ln + 1) + '</span>' : '';
        return '<div class="mv-step"' + (ln != null ? ' data-line="' + (ln + 1) + '"' : '') + '>' +
            '<span class="mv-lk">L' + (i + 1) + '</span>' + lineTag +
            '<div class="mv-step-row">' +
            '<div class="mv-mem mv-stack"><div class="mv-mem-h">Stack</div>' + frames + '</div>' +
            heapBox +
            '</div></div>';
    }

    // Maps each runtime step to the source line it executes at (for editor Lk markers).
    function interpreterStepLines(ownership) {
        var interp = normInterp(ownership && ownership.interpreter);
        if (!interp) return [];
        return interp.steps.map(function (s, i) {
            return { step: i + 1, line: stepLine(s) };
        }).filter(function (x) { return x.line != null; });
    }

    function ubBanner(result) {
        if (!result || result.type !== 'Error') return '';
        var ub = result.value || {};
        var msg = ub.type === 'PointerUseAfterFree'
            ? 'undefined behavior: pointer used after its pointee is freed'
            : 'undefined behavior: ' + esc((ub.value && String(ub.value)) || 'detected');
        return '<div class="own-ub">⚠ ' + msg + '</div>';
    }

    function renderInterpreter(interp) {
        return ubBanner(interp.result) +
            '<div class="mv-steps">' +
            interp.steps.map(stepHtml).join('') +
            '</div>';
    }

    // Draw curved arrows from each pointer dot to its heap cell (per step row).
    function drawArrows(root) {
        if (!root || typeof document === 'undefined' || !document.createElementNS) return;
        root.querySelectorAll('.mv-step-row').forEach(function (row) {
            var prev = row.querySelector('svg.mv-arrows');
            if (prev) prev.parentNode.removeChild(prev);
            var dots = row.querySelectorAll('.mv-dot[data-heap-target]');
            var rb = row.getBoundingClientRect();
            if (!dots.length || !rb.width) return;
            var svg = document.createElementNS(SVGNS, 'svg');
            svg.setAttribute('class', 'mv-arrows');
            svg.setAttribute('width', rb.width);
            svg.setAttribute('height', rb.height);
            svg.innerHTML = '<defs><marker id="mv-ah" markerWidth="7" markerHeight="7" refX="5" refY="3" orient="auto">' +
                '<path d="M0,0 L6,3 L0,6 Z" fill="currentColor"/></marker></defs>';
            dots.forEach(function (d) {
                var target = row.querySelector('.mv-heap-cell[data-heap="' + d.getAttribute('data-heap-target') + '"]');
                if (!target) return;
                var db = d.getBoundingClientRect(), tb = target.getBoundingClientRect();
                var x1 = db.right - rb.left, y1 = db.top + db.height / 2 - rb.top;
                var x2 = tb.left - rb.left - 2, y2 = tb.top + tb.height / 2 - rb.top;
                var p = document.createElementNS(SVGNS, 'path');
                p.setAttribute('d', 'M' + x1 + ',' + y1 + ' C' + (x1 + 46) + ',' + y1 +
                    ' ' + (x2 - 46) + ',' + y2 + ' ' + x2 + ',' + y2);
                p.setAttribute('fill', 'none');
                p.setAttribute('stroke', 'currentColor');
                p.setAttribute('stroke-width', '1.6');
                p.setAttribute('marker-end', 'url(#mv-ah)');
                svg.appendChild(p);
            });
            row.appendChild(svg);
        });
    }

    // Track containers that hold arrows so a single resize listener redraws them.
    var _arrowRoots = [];
    function _redrawAll() { _arrowRoots.forEach(function (r) { if (r.guard()) drawArrows(r.el); }); }
    if (typeof window !== 'undefined') {
        var _rt;
        window.addEventListener('resize', function () { clearTimeout(_rt); _rt = setTimeout(_redrawAll, 120); });
    }
    function scheduleArrows(el, guard) {
        guard = guard || function () { return true; };
        if (!_arrowRoots.some(function (r) { return r.el === el; })) _arrowRoots.push({ el: el, guard: guard });
        if (typeof requestAnimationFrame === 'function') requestAnimationFrame(function () { if (guard()) drawArrows(el); });
        else if (guard()) drawArrows(el);
    }

    /* ===================== permission model (for the editor overlay) ===================== */

    // Just the step tables for one step, without the «-toggle widget wrapper.
    function stepTablesInner(step) {
        return (step.state || []).map(function (tbl) {
            var rows = (tbl.state || []).map(function (pair) { return stepRow(pair[0], pair[1]); }).join('');
            return '<table class="own-step-table"><tbody>' + rows + '</tbody></table>';
        }).join('');
    }

    // Markdown for one step's permission-change table (for a Monaco hover).
    function permToMd(vs, ch) {
        var t = vtype(vs);
        if (t === 'High') return '**+' + ch + '**';
        if (t === 'Low') return '~~' + ch + '~~';
        if (vs && vs.value) return ch;
        return '·';
    }
    function eventMd(diff) {
        var ev = [];
        if (vtype(diff.path_moved) === 'High') ev.push('moved');
        else if (vtype(diff.path_moved) === 'Low') ev.push('re-init');
        var lr = vtype(diff.loan_write_refined) === 'None' ? diff.loan_read_refined : diff.loan_write_refined;
        if (vtype(lr) === 'High') ev.push('borrow');
        else if (vtype(lr) === 'Low') ev.push('borrow ends');
        if (vtype(diff.is_live) === 'High') ev.push('init');
        else if (vtype(diff.is_live) === 'Low') ev.push('no longer used');
        return ev.join(', ');
    }
    function stepMarkdown(step) {
        var rows = [];
        (step.state || []).forEach(function (tbl) {
            (tbl.state || []).forEach(function (pair) {
                var p = (pair[1].permissions) || {};
                rows.push('| `' + pair[0] + '` | ' + (eventMd(pair[1]) || '·') + ' | ' +
                    permToMd(p.read, 'R') + ' | ' + permToMd(p.write, 'W') + ' | ' + permToMd(p.drop, 'O') + ' |');
            });
        });
        if (!rows.length) return '';
        return '**Permissions after this line** &nbsp; _(+gained · ~~lost~~ · · absent)_\n\n' +
            '| path | event | R | W | O |\n|:--|:--|:-:|:-:|:-:|\n' + rows.join('\n');
    }

    // Structured permission data keyed by source position, for painting onto Monaco.
    function permissionModel(ownership) {
        var bodies = okBodies(ownership);
        var boundaries = [], steps = [], borrows = [];
        bodies.forEach(function (b) {
            (b.boundaries || []).forEach(function (bd) {
                var perms = [
                    { c: 'R', cls: 'read', act: bd.actual.read, exp: bd.expected.read },
                    { c: 'W', cls: 'write', act: bd.actual.write, exp: bd.expected.write },
                    { c: 'O', cls: 'own', act: bd.actual.drop, exp: bd.expected.drop }
                ].filter(function (p) { return p.exp; });
                if (!perms.length) return;
                boundaries.push({
                    line: bd.location.line, col: bd.location.column, perms: perms,
                    missing: perms.some(function (p) { return !p.act; })
                });
            });
            (b.steps || []).forEach(function (st) {
                var loc = (st.location && (st.location.end || st.location)) || {};
                var md = stepMarkdown(st);
                if (md) steps.push({ line: loc.line || 0, md: md });
            });
            var regions = b.loan_regions || {};
            Object.keys(regions).forEach(function (k) {
                (regions[k].refined_ranges || []).forEach(function (r) {
                    if (r.start.line === r.end.line) {
                        borrows.push({ line: r.start.line, startCol: r.start.column, endCol: r.end.column });
                    }
                });
            });
        });
        return { boundaries: boundaries, steps: steps, borrows: borrows };
    }

    /* ===================== top-level ===================== */

    // Runtime-only view (stack/heap) for the Ownership pane when permissions are
    // overlaid on the editor instead of duplicated here.
    function renderRuntime(container, ownership) {
        var interp = normInterp(ownership && ownership.interpreter);
        if (!interp || !interp.steps.length) {
            container.innerHTML = '<div class="own-empty">No runtime trace for this program ' +
                '(it may not allocate, or did not compile).</div>';
            return;
        }
        container.innerHTML =
            '<div class="own-sub-h own-pane-cap">Stack &amp; heap as the program runs (Miri). ' +
            'Arrows point from a value to its heap allocation.</div>' +
            renderInterpreter(interp);
        scheduleArrows(container);
    }

    function render(container, code, ownership) {
        var bodies = okBodies(ownership);
        var interp = normInterp(ownership && ownership.interpreter);
        var hasInterp = interp && interp.steps.length;

        if (!bodies.length && !hasInterp) {
            container.innerHTML = '<div class="own-empty">No ownership analysis returned. ' +
                'Aquascope needs code that compiles (a <code>fn main</code>).</div>';
            return;
        }

        var defaultSub = bodies.length ? 'perms' : 'runtime';
        var tabs = '<div class="own-subtabs">' +
            (bodies.length ? '<button type="button" class="own-subtab' + (defaultSub === 'perms' ? ' active' : '') + '" data-own-sub="perms">Permissions</button>' : '') +
            (hasInterp ? '<button type="button" class="own-subtab' + (defaultSub === 'runtime' ? ' active' : '') + '" data-own-sub="runtime">Runtime memory</button>' : '') +
            '</div>';

        var permsPane = bodies.length
            ? '<div class="own-subpane" data-own-pane="perms"' + (defaultSub === 'perms' ? '' : ' hidden') + '>' +
                '<div class="own-sub-h own-pane-cap">What the borrow checker sees — R/W/O permissions at each use.</div>' +
                renderPermissions(code, bodies) + '</div>'
            : '';

        var runtimePane = hasInterp
            ? '<div class="own-subpane" data-own-pane="runtime"' + (defaultSub === 'runtime' ? '' : ' hidden') + '>' +
                '<div class="own-sub-h own-pane-cap">Stack &amp; heap as the program runs (Miri). Arrows point from a value to its heap allocation.</div>' +
                renderInterpreter(interp) + '</div>'
            : '';

        container.innerHTML = tabs + permsPane + runtimePane;

        var runtimeEl = container.querySelector('.own-subpane[data-own-pane="runtime"]');
        var redraw = function () { if (runtimeEl && !runtimeEl.hidden) drawArrows(runtimeEl); };

        // sub-tab switching
        container.querySelectorAll('.own-subtab').forEach(function (t) {
            t.addEventListener('click', function () {
                var name = t.getAttribute('data-own-sub');
                container.querySelectorAll('.own-subtab').forEach(function (x) { x.classList.toggle('active', x === t); });
                container.querySelectorAll('.own-subpane').forEach(function (p) {
                    p.hidden = p.getAttribute('data-own-pane') !== name;
                });
                if (name === 'runtime') redraw();
            });
        });

        // step-table toggles
        container.querySelectorAll('.own-step-toggle').forEach(function (t) {
            t.addEventListener('click', function () {
                var box = t.parentNode.querySelector('.own-step-box');
                var collapsed = t.classList.toggle('collapsed');
                t.textContent = collapsed ? '»' : '«';
                if (box) box.style.display = collapsed ? 'none' : '';
            });
        });

        // initial + responsive arrow draw (only while the runtime pane is visible)
        if (hasInterp) scheduleArrows(runtimeEl, function () { return runtimeEl && !runtimeEl.hidden; });
    }

    global.OcOwnership = {
        render: render,
        renderRuntime: renderRuntime,
        permissionModel: permissionModel,
        interpreterStepLines: interpreterStepLines,
        _okBodies: okBodies,
        _normInterp: normInterp,
        _cellValue: cellValue,
        _renderPermissions: renderPermissions,
        _renderInterpreter: renderInterpreter
    };
}(typeof window !== 'undefined' ? window : this));
