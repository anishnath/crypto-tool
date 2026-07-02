/**
 * DOM renderers for viz tracer snapshots.
 */
(function (global) {
    'use strict';

    function el(tag, cls, text) {
        var node = document.createElement(tag);
        if (cls) node.className = cls;
        if (text != null) node.textContent = text;
        return node;
    }

    function legendEl() {
        var legend = el('div', 'viz-array-legend');
        legend.innerHTML =
            '<span><span class="lg lg-read"></span>reading / comparing</span>' +
            '<span><span class="lg lg-write"></span>just changed</span>';
        return legend;
    }

    function humanizeTitle(title, type) {
        if (!title) {
            return (type || 'Tracer').replace(/Tracer$/, '');
        }
        var m = title.match(/^(?:INT\[\]|int\[\]|list|List|Array):\s*([A-Za-z_][\w$]*)/i);
        if (m) {
            return m[1].replace(/@.*$/, '').toLowerCase();
        }
        if (title.indexOf('@') >= 0) {
            var prefix = title.split('@')[0].replace(/^(?:INT\[\]|int\[\]|list):\s*/i, '').trim();
            if (prefix && /^[A-Za-z_][\w$]*$/.test(prefix)) {
                return prefix.toLowerCase();
            }
        }
        if (/^(Console|Log|Call Stack|Line Tracker)$/i.test(title)) {
            return title;
        }
        return title.replace(/@\d+$/, '').trim();
    }

    function isTracerEmpty(type, state) {
        if (!state) return true;
        switch (type) {
            case 'Array1DTracer':
            case 'Array2DTracer':
                return !state.values || !state.values.length;
            case 'MapTracer':
                return !Object.keys(state.entries || {}).length;
            case 'GraphTracer':
                return !Object.keys(state.nodes || {}).length;
            case 'CallStackTracer':
                return !state.frames || !state.frames.length;
            case 'LogTracer':
                return !state.lines || !state.lines.length;
            case 'MemTracer':
                return !state.snap;
            default:
                return false;
        }
    }

    function dedupeArrayTracers(keys, states) {
        if (keys.length <= 1) return keys;
        var sorted = keys.slice().sort(function (a, b) {
            var la = (states[a] && states[a].values) ? states[a].values.length : 0;
            var lb = (states[b] && states[b].values) ? states[b].values.length : 0;
            if (lb !== la) return lb - la;
            var sa = states[a] && states[a].selected != null ? 1 : 0;
            var sb = states[b] && states[b].selected != null ? 1 : 0;
            return sb - sa;
        });
        var out = [];
        var sigs = {};
        sorted.forEach(function (k) {
            var sig = JSON.stringify(states[k].values || []);
            if (!sigs[sig]) {
                sigs[sig] = true;
                out.push(k);
            }
        });
        return out;
    }

    var MAX_ARRAY_PANELS = 6;

    function arrayActive(st) {
        return st && (st.selected != null || st.lastPatch != null) ? 1 : 0;
    }

    function prioritizeTracerKeys(keys, meta, states) {
        var arrays = [];
        var middle = [];
        var compact = [];

        keys.forEach(function (k) {
            var type = meta[k] && meta[k].type;
            var st = states[k] || {};
            if (!type || isTracerEmpty(type, st)) {
                return;
            }
            if (type === 'Array1DTracer' || type === 'Array2DTracer') {
                arrays.push(k);
            } else if (type === 'LogTracer' || type === 'CallStackTracer') {
                compact.push(k);
            } else {
                middle.push(k);
            }
        });

        // Drop phantom 1-D panels that are really a row of a present 2-D matrix.
        // (Matrix literal init writes each row before the matrix is recognised as 2-D,
        // so each row gets registered as a standalone Array1DTracer.)
        var matrixRowSigs = {};
        arrays.forEach(function (k) {
            if (meta[k] && meta[k].type === 'Array2DTracer') {
                (states[k].values || []).forEach(function (row) {
                    matrixRowSigs[JSON.stringify(row || [])] = true;
                });
            }
        });
        if (Object.keys(matrixRowSigs).length) {
            arrays = arrays.filter(function (k) {
                if (meta[k].type !== 'Array1DTracer') return true;
                return !matrixRowSigs[JSON.stringify(states[k].values || [])];
            });
        }

        var arr = dedupeArrayTracers(arrays, states);
        var hidden = 0;
        // Divide-and-conquer (merge sort, quicksort) spawns many transient sub-arrays.
        // Show only the most relevant — active this step first, then largest — and note the rest.
        if (arr.length > MAX_ARRAY_PANELS) {
            arr = arr.slice().sort(function (a, b) {
                var act = arrayActive(states[b]) - arrayActive(states[a]);
                if (act !== 0) return act;
                var la = (states[a].values || []).length;
                var lb = (states[b].values || []).length;
                return lb - la;
            });
            hidden = arr.length - MAX_ARRAY_PANELS;
            arr = arr.slice(0, MAX_ARRAY_PANELS);
        }

        return { keys: arr.concat(middle).concat(compact), hiddenArrays: hidden };
    }

    function renderArray1D(state, title, opts) {
        opts = opts || {};
        var panel = el('div', 'viz-tracer-panel' + (opts.primary ? ' viz-tracer-primary' : '') + (opts.compact ? ' viz-tracer-compact' : ''));
        panel.appendChild(el('div', 'viz-tracer-title', humanizeTitle(title, 'Array1DTracer')));
        var body = el('div', 'viz-tracer-body');
        var row = el('div', 'viz-array-row viz-array-1d');

        var values = state.values || [];
        if (!values.length) {
            body.appendChild(el('div', 'viz-stage-empty', '(empty array)'));
        } else {
            values.forEach(function (val, idx) {
                var cell = el('div', 'viz-array-cell');
                if (state.selected === idx) cell.classList.add('is-selected');
                if (state.lastPatch === idx) cell.classList.add('is-patched');
                cell.appendChild(el('span', 'viz-idx', String(idx)));
                cell.appendChild(document.createTextNode(formatValue(val)));
                row.appendChild(cell);
            });
            body.appendChild(row);
        }
        panel.appendChild(body);
        if (opts.primary && values.length) {
            panel.appendChild(legendEl());
        }
        return panel;
    }

    function renderArray2D(state, title, opts) {
        opts = opts || {};
        var panel = el('div', 'viz-tracer-panel' + (opts.primary ? ' viz-tracer-primary' : '') + (opts.compact ? ' viz-tracer-compact' : ''));
        panel.appendChild(el('div', 'viz-tracer-title', humanizeTitle(title, 'Array2DTracer')));
        var body = el('div', 'viz-tracer-body');

        var values = state.values || [];
        if (!values.length) {
            body.appendChild(el('div', 'viz-stage-empty', '(empty 2D array)'));
        } else {
            values.forEach(function (rowVals, r) {
                var row = el('div', 'viz-array-row');
                row.style.marginBottom = '6px';
                (rowVals || []).forEach(function (val, c) {
                    var cell = el('div', 'viz-array-cell');
                    var sel = state.selected;
                    var patch = state.lastPatch;
                    if (Array.isArray(sel) && sel[0] === r && sel[1] === c) {
                        cell.classList.add('is-selected');
                    }
                    if (Array.isArray(patch) && patch[0] === r && patch[1] === c) {
                        cell.classList.add('is-patched');
                    }
                    cell.appendChild(el('span', 'viz-idx', r + ',' + c));
                    cell.appendChild(document.createTextNode(formatValue(val)));
                    row.appendChild(cell);
                });
                body.appendChild(row);
            });
        }
        panel.appendChild(body);
        if (opts.primary && values.length) {
            panel.appendChild(legendEl());
        }
        return panel;
    }

    function renderMap(state, title, opts) {
        opts = opts || {};
        var panel = el('div', 'viz-tracer-panel' + (opts.compact ? ' viz-tracer-compact' : ''));
        panel.appendChild(el('div', 'viz-tracer-title', humanizeTitle(title, 'MapTracer')));
        var body = el('div', 'viz-tracer-body');
        var grid = el('div', 'viz-map-grid');
        var keys = Object.keys(state.entries || {});
        if (!keys.length) {
            body.appendChild(el('div', 'viz-stage-empty', '(empty map)'));
        } else {
            keys.forEach(function (k) {
                var entry = el('span', 'viz-map-entry', k + ' → ' + formatValue(state.entries[k]));
                if (state.selected === k) entry.classList.add('is-selected');
                grid.appendChild(entry);
            });
            body.appendChild(grid);
        }
        panel.appendChild(body);
        return panel;
    }

    var graphMarkerSeq = 0;

    var GRAPH_GAPX = 84, GRAPH_GAPY = 78, GRAPH_M = 34;

    // Textbook layout: a path (singly/doubly/circular list) lays out horizontally;
    // a rooted tree lays out tidily (left child left, right child right); anything
    // else (adjacency graphs, DAGs) returns null so the engine's own coords are used.
    function layoutGraph(nodeList, edges) {
        var ids = nodeList.map(function (n) { return n.id; });
        if (!ids.length) return null;
        var idSet = {}; ids.forEach(function (id) { idSet[id] = true; });
        var SEP = ' ';
        var dirOut = {}, dirIndeg = {}, und = {}, pairSet = {};
        ids.forEach(function (id) { dirOut[id] = []; dirIndeg[id] = 0; und[id] = {}; });
        edges.forEach(function (e) {
            if (idSet[e.from] && idSet[e.to]) pairSet[e.from + SEP + e.to] = true;
        });
        edges.forEach(function (e) {
            if (!idSet[e.from] || !idSet[e.to]) return;
            dirOut[e.from].push(e.to);
            // a reverse edge of a bidirectional pair (doubly's prev) isn't a structural parent
            if (!pairSet[e.to + SEP + e.from]) dirIndeg[e.to]++;
            und[e.from][e.to] = true; und[e.to][e.from] = true;
        });
        var pos = {};

        // ── Path (linked list, incl. doubly & circular) ──
        var deg = {}, total = 0;
        ids.forEach(function (id) { deg[id] = Object.keys(und[id]).length; total += deg[id]; });
        var ends = ids.filter(function (id) { return deg[id] === 1; });
        var connected = (function () {           // single connected component?
            var seen = {}, stack = [ids[0]], c = 0;
            while (stack.length) { var u = stack.pop(); if (seen[u]) continue; seen[u] = true; c++; Object.keys(und[u]).forEach(function (v) { if (!seen[v]) stack.push(v); }); }
            return c === ids.length;
        })();
        var maxDeg = ids.reduce(function (m, id) { return Math.max(m, deg[id]); }, 0);
        // A simple path (2 endpoints) is unambiguously a list. A cycle (no endpoints)
        // is only a circular list if every node has exactly one out-edge — otherwise
        // it's a graph (e.g. a triangle a->b,a->c,b->c is a 3-cycle but not a list).
        var allOut1 = ids.every(function (id) { return dirOut[id].length === 1; });
        var isPath = connected && maxDeg <= 2 && (ends.length === 2 || (ends.length === 0 && allOut1));
        if (ids.length === 1) { pos[ids[0]] = { x: GRAPH_M, y: GRAPH_M }; return pos; }
        if (isPath) {
            var start = ends.length ? ends[0] : ids[0];   // ends.length 0 => cycle
            var order = [], seen = {}, cur = start, prev = null;
            while (cur != null && !seen[cur]) {
                seen[cur] = true; order.push(cur);
                var nbrs = Object.keys(und[cur]).filter(function (v) { return v !== prev && !seen[v]; });
                prev = cur; cur = nbrs.length ? nbrs[0] : null;
            }
            if (order.length === ids.length) {
                order.forEach(function (id, i) { pos[id] = { x: GRAPH_M + i * GRAPH_GAPX, y: GRAPH_M + 16 }; });
                return pos;
            }
        }

        // ── Rooted tree (each node ≤1 structural parent, has a root) ──
        var treeLike = ids.every(function (id) { return dirIndeg[id] <= 1; });
        var roots = ids.filter(function (id) { return dirIndeg[id] === 0; });
        if (treeLike && roots.length >= 1) {
            var depth = {}, visited = {}, leaf = 0, ok = true;
            function place(id, d) {
                if (visited[id]) { ok = false; return; }
                visited[id] = true; depth[id] = d;
                // structural children: forward targets not yet placed, with a single parent
                var kids = dirOut[id].filter(function (t) { return !visited[t] && dirIndeg[t] === 1; });
                if (!kids.length) { pos[id] = { x: GRAPH_M + leaf * GRAPH_GAPX, y: GRAPH_M + d * GRAPH_GAPY }; leaf++; return; }
                var mid = Math.floor(kids.length / 2);
                for (var i = 0; i < mid; i++) place(kids[i], d + 1);
                pos[id] = { x: GRAPH_M + leaf * GRAPH_GAPX, y: GRAPH_M + d * GRAPH_GAPY }; leaf++;
                for (var j = mid; j < kids.length; j++) place(kids[j], d + 1);
                var xs = kids.map(function (k) { return pos[k] ? pos[k].x : null; }).filter(function (x) { return x != null; });
                if (xs.length) pos[id].x = (Math.min.apply(null, xs) + Math.max.apply(null, xs)) / 2;
            }
            roots.forEach(function (r) { if (!visited[r]) place(r, 0); });
            if (ok && Object.keys(pos).length === ids.length) return pos;
        }
        return null;  // general graph → use engine coords
    }

    function renderGraph(state, title) {
        var panel = el('div', 'viz-tracer-panel');
        panel.appendChild(el('div', 'viz-tracer-title', title || 'Graph'));
        var body = el('div', 'viz-tracer-body');

        var nodes = state.nodes || {};
        var nodeList = Object.keys(nodes).map(function (k) { return nodes[k]; });
        if (!nodeList.length) {
            body.appendChild(el('div', 'viz-stage-empty', '(empty graph)'));
            panel.appendChild(body);
            return panel;
        }

        var positions = layoutGraph(nodeList, state.edges || []);
        if (!positions) {  // general graph → engine-provided coords
            positions = {};
            nodeList.forEach(function (n, i) {
                var x = n.x != null ? n.x : 40 + (i % 4) * 60;
                var y = n.y != null ? n.y : 30 + Math.floor(i / 4) * 50;
                positions[n.id] = { x: x, y: y };
            });
        }
        var maxX = 0, maxY = 0;
        Object.keys(positions).forEach(function (k) {
            if (positions[k].x > maxX) maxX = positions[k].x;
            if (positions[k].y > maxY) maxY = positions[k].y;
        });
        var w = Math.max(160, maxX + 40);
        var h = Math.max(80, maxY + 40);
        var svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
        svg.setAttribute('class', 'viz-graph-svg');
        svg.setAttribute('viewBox', '0 0 ' + w + ' ' + h);

        var defs = document.createElementNS('http://www.w3.org/2000/svg', 'defs');
        var markerId = 'viz-arrow-' + (++graphMarkerSeq);
        var marker = document.createElementNS('http://www.w3.org/2000/svg', 'marker');
        marker.setAttribute('id', markerId);
        marker.setAttribute('markerWidth', '8');
        marker.setAttribute('markerHeight', '8');
        marker.setAttribute('refX', '6');
        marker.setAttribute('refY', '3');
        marker.setAttribute('orient', 'auto');
        var path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
        path.setAttribute('d', 'M0,0 L0,6 L6,3 z');
        path.setAttribute('fill', '#64748b');
        marker.appendChild(path);
        defs.appendChild(marker);
        svg.appendChild(defs);

        var R = 16;
        var edgeKey = {};
        (state.edges || []).forEach(function (e) { edgeKey[e.from + ' ' + e.to] = true; });
        (state.edges || []).forEach(function (e) {
            var a = positions[e.from];
            var b = positions[e.to];
            if (!a || !b) return;
            var dx = b.x - a.x, dy = b.y - a.y, len = Math.sqrt(dx * dx + dy * dy) || 1;
            var ux = dx / len, uy = dy / len;
            // trim endpoints to the node circle so the arrowhead points *at* the node
            var ax = a.x + ux * R, ay = a.y + uy * R, bx = b.x - ux * R, by = b.y - uy * R;
            var bidir = !!edgeKey[e.to + ' ' + e.from];   // reverse edge exists (doubly's prev)
            var long = len > GRAPH_GAPX * 1.6;            // spans past neighbours (e.g. circular wrap)
            var elEdge;
            if (bidir || long) {
                // curve so opposite edges of a pair separate into two distinct arrows
                var side = bidir ? (e.from < e.to ? 1 : -1) : 1;
                var off = (bidir ? 16 : Math.min(len * 0.22, 46)) * side;
                var mx = (ax + bx) / 2 + (-uy) * off, my = (ay + by) / 2 + ux * off;
                elEdge = document.createElementNS('http://www.w3.org/2000/svg', 'path');
                elEdge.setAttribute('d', 'M' + ax + ',' + ay + ' Q' + mx + ',' + my + ' ' + bx + ',' + by);
                elEdge.setAttribute('fill', 'none');
            } else {
                elEdge = document.createElementNS('http://www.w3.org/2000/svg', 'line');
                elEdge.setAttribute('x1', ax); elEdge.setAttribute('y1', ay);
                elEdge.setAttribute('x2', bx); elEdge.setAttribute('y2', by);
            }
            elEdge.setAttribute('class', 'viz-graph-edge');
            elEdge.setAttribute('marker-end', 'url(#' + markerId + ')');
            svg.appendChild(elEdge);
        });

        nodeList.forEach(function (n) {
            var p = positions[n.id];
            var circle = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
            circle.setAttribute('class', 'viz-graph-node');
            circle.setAttribute('cx', p.x);
            circle.setAttribute('cy', p.y);
            circle.setAttribute('r', 16);
            if (state.selected === n.id) {
                // Inline style overrides the .viz-graph-node stylesheet rule (a plain
                // setAttribute('stroke',…) would be overridden by CSS and never show).
                circle.classList.add('is-selected');
                circle.style.stroke = '#f59e0b';
                circle.style.strokeWidth = '4';
                circle.style.fill = '#78350f';
            }
            svg.appendChild(circle);

            var label = document.createElementNS('http://www.w3.org/2000/svg', 'text');
            label.setAttribute('class', 'viz-graph-node-label');
            label.setAttribute('x', p.x);
            label.setAttribute('y', p.y);
            label.textContent = n.label || n.id;
            svg.appendChild(label);
        });

        body.appendChild(svg);
        panel.appendChild(body);
        return panel;
    }

    function renderCallStack(state, title) {
        var panel = el('div', 'viz-tracer-panel viz-tracer-compact');
        panel.appendChild(el('div', 'viz-tracer-title', humanizeTitle(title, 'CallStackTracer') || 'Call stack'));
        var body = el('div', 'viz-tracer-body');
        var ul = el('ul', 'viz-stack-list');
        var frames = state.frames || [];
        if (!frames.length) {
            body.appendChild(el('div', 'viz-stage-empty', '(empty stack)'));
        } else {
            frames.slice().reverse().forEach(function (f) {
                ul.appendChild(el('li', null, f));
            });
            body.appendChild(ul);
        }
        panel.appendChild(body);
        return panel;
    }

    function renderLog(state, title) {
        var panel = el('div', 'viz-tracer-panel viz-tracer-compact');
        panel.appendChild(el('div', 'viz-tracer-title', humanizeTitle(title, 'LogTracer') || 'Console'));
        var body = el('div', 'viz-tracer-body');
        var pre = el('pre', 'ide-viz-log');
        pre.textContent = (state.lines || []).join('\n') || '(no output yet)';
        body.appendChild(pre);
        panel.appendChild(body);
        return panel;
    }

    function formatValue(v) {
        if (v == null) return 'null';
        if (typeof v === 'object') {
            try { return JSON.stringify(v); } catch (e) { return String(v); }
        }
        return String(v);
    }

    var HEAP_COLORS = ['#4f8cd4', '#36a864', '#e0a830', '#c05686', '#7e57c2', '#17a2b8'];
    function shortAddr(a) { return a ? '…' + String(a).slice(-4) : String(a); }

    // One variable row (scalar / pointer / array cells). Used in Stack, Data and BSS.
    function memVarRow(l, colorOf, labelOf) {
        var row = el('div', 'viz-mem-var' + (l._changed ? ' viz-mem-changed' : ''));
        if (l.addr) row.setAttribute('data-addr', l.addr);
        row.appendChild(el('span', 'viz-mem-name', l.name));
        if (l.escaped) {
            var esc = el('span', 'viz-mem-esc', 'escaped → heap');
            esc.setAttribute('title', 'Escape analysis: the compiler allocated this on the heap because its reference outlives the function.');
            row.appendChild(esc);
        }
        if (l.type === 'array' || l.cells) {
            var cells = el('div', 'viz-mem-cells');
            (l.cells || []).forEach(function (cv, i) {
                var changed = l._changedCells && l._changedCells.indexOf(i) >= 0;
                var c = el('div', 'viz-mem-cell' + (changed ? ' viz-mem-cell-changed' : ''));
                c.appendChild(el('span', 'viz-mem-cidx', i));
                c.appendChild(el('span', 'viz-mem-cval', cv));
                cells.appendChild(c);
            });
            row.appendChild(cells);
            return row;
        }
        if (l.type === 'ptr') {
            var pt = l.points_to, v;
            if (pt === 'null') { v = el('span', 'viz-mem-ptr viz-mem-null', 'null'); }
            else if (pt === 'heap-freed') { v = el('span', 'viz-mem-ptr viz-mem-dangling', '⚠ dangling'); if (l.target) row.setAttribute('data-target', l.target); }
            else if (pt && pt.indexOf('heap') === 0) {
                v = el('span', 'viz-mem-ptr', '→ ' + (labelOf[l.target] || shortAddr(l.target)));
                var c = colorOf[l.target];
                if (c) { v.style.color = c; v.style.borderColor = c; }
                if (l.target) row.setAttribute('data-target', l.target);
            } else if (pt && (pt.indexOf('stack:') === 0 || pt.indexOf('data:') === 0)) {
                v = el('span', 'viz-mem-ptr', '→ ' + pt.slice(pt.indexOf(':') + 1));
                if (l.target) row.setAttribute('data-target', l.target);
            } else if (pt === 'stack' && l.value != null) {
                v = el('span', 'viz-mem-ptr', '→ ' + l.value);   // pointer to a scalar (deref shown)
            } else { v = el('span', 'viz-mem-ptr', shortAddr(l.value)); }
            row.appendChild(v);
            return row;
        }
        row.appendChild(el('span', 'viz-mem-val', l.value));
        return row;
    }

    // Managed (.NET / JVM-style) memory: value types inline on the Stack, reference
    // locals → objects on the managed Heap (synthetic #ids, no addresses), static
    // fields in a Statics segment. Reuses memVarRow + drawMemArrows.
    function renderManagedMem(panel, snap) {
        var heap = snap.heap || [];
        var frames = snap.frames || [];
        var statics = snap.statics || [];
        var colorOf = {}, labelOf = {};
        heap.forEach(function (h, i) { colorOf[h.id] = HEAP_COLORS[i % HEAP_COLORS.length]; labelOf[h.id] = h.id; });

        var body = el('div', 'viz-mem-body viz-mem-layout');

        function segment(cls, name, sub, buildInner, emptyMsg, empty) {
            var seg = el('div', 'viz-mem-seg ' + cls + (empty ? ' is-empty' : ''));
            var hdr = el('div', 'viz-mem-seghdr');
            hdr.appendChild(el('span', 'viz-mem-segname', name));
            if (empty) {
                // collapse empty regions to a thin dim strip — no wasted vertical space
                hdr.appendChild(el('span', 'viz-mem-segempty', emptyMsg || '(empty)'));
                seg.appendChild(hdr);
                return seg;
            }
            if (sub) hdr.appendChild(el('span', 'viz-mem-segsub', sub));
            seg.appendChild(hdr);
            var inner = el('div', 'viz-mem-seginner');
            buildInner(inner);
            seg.appendChild(inner);
            return seg;
        }

        // ── Stack (value types inline, references → heap) ──
        body.appendChild(segment('viz-mem-seg-stack', 'Stack', 'value types & references · call frames',
            function (inner) {
                frames.forEach(function (f) {
                    var fr = el('div', 'viz-mem-frame');
                    fr.appendChild(el('div', 'viz-mem-fn', f.fn + '()'));
                    (f.locals || []).forEach(function (l) { fr.appendChild(memVarRow(l, colorOf, labelOf)); });
                    if (!f.locals || !f.locals.length) fr.appendChild(el('div', 'viz-mem-empty', '(no tracked locals)'));
                    inner.appendChild(fr);
                });
            }, '(no active frames)', !frames.length));

        // ── Managed heap (objects/arrays/strings, GC-managed) ──
        body.appendChild(segment('viz-mem-seg-heap', 'Heap (managed)', 'objects · arrays · strings · GC-managed',
            function (inner) { heap.forEach(function (h) { inner.appendChild(renderHeapObj(h, colorOf, labelOf)); }); },
            '(no objects allocated yet)', !heap.length));

        // ── Statics (static fields — per-type storage) ──
        body.appendChild(segment('viz-mem-seg-data', 'Statics', 'static fields',
            function (inner) { statics.forEach(function (s) { inner.appendChild(memVarRow(s, colorOf, labelOf)); }); },
            '(none)', !statics.length));

        panel.appendChild(body);
        drawMemArrows(panel);
        wireMemHover(panel);
        return panel;
    }

    // One managed heap object: #id header, type, and content (array cells / string
    // value / object fields). Reference fields become arrows via memVarRow.
    function renderHeapObj(h, colorOf, labelOf) {
        var blk = el('div', 'viz-mem-block viz-mem-obj');
        blk.setAttribute('data-addr', h.id);
        if (colorOf[h.id]) blk.style.borderColor = colorOf[h.id];
        var lab = el('span', 'viz-mem-blabel', h.id);
        if (colorOf[h.id]) lab.style.background = colorOf[h.id];
        blk.appendChild(lab);
        blk.appendChild(el('div', 'viz-mem-otype', h.type || 'object'));
        if (h.kind === 'string') {
            blk.appendChild(el('div', 'viz-mem-oval', '"' + (h.value != null ? h.value : '') + '"'));
        } else if (h.kind === 'array') {
            var cells = el('div', 'viz-mem-cells');
            (h.cells || []).forEach(function (cv, i) {
                var changed = h._changedCells && h._changedCells.indexOf(i) >= 0;
                var c = el('div', 'viz-mem-cell' + (changed ? ' viz-mem-cell-changed' : ''));
                c.appendChild(el('span', 'viz-mem-cidx', i));
                c.appendChild(el('span', 'viz-mem-cval', cv));
                cells.appendChild(c);
            });
            blk.appendChild(cells);
        } else {
            (h.fields || []).forEach(function (f) { blk.appendChild(memVarRow(f, colorOf, labelOf)); });
            if (!h.fields || !h.fields.length) blk.appendChild(el('div', 'viz-mem-empty', '(no public fields)'));
        }
        return blk;
    }

    // Memory lens: the classic process address space — Stack / Heap / BSS / Data / Text,
    // high addresses at top. Globals live in Data/BSS, locals+arrays on the Stack, new/malloc
    // in the Heap, with pointer links drawn across segments.
    function renderMem(state, title) {
        var panel = el('div', 'viz-tracer-panel viz-mem');
        var snap = state && state.snap;
        var managed = !!(snap && snap.layout === 'managed');
        panel.appendChild(el('div', 'viz-tracer-title', managed ? 'Managed memory — stack & heap' : 'Process memory layout'));
        if (!snap) { panel.appendChild(el('div', 'viz-stage-empty', '(no memory snapshot for this step)')); return panel; }
        if (managed) return renderManagedMem(panel, snap);

        var heap = snap.heap || [];
        var frames = snap.frames || [];
        var data = snap.data || [];
        var bss = snap.bss || [];
        var colorOf = {}, labelOf = {};
        heap.forEach(function (h, i) { colorOf[h.addr] = HEAP_COLORS[i % HEAP_COLORS.length]; labelOf[h.addr] = 'H' + i; });

        var body = el('div', 'viz-mem-body viz-mem-layout');

        function segment(cls, name, sub, buildInner, emptyMsg, empty) {
            var seg = el('div', 'viz-mem-seg ' + cls + (empty ? ' is-empty' : ''));
            var hdr = el('div', 'viz-mem-seghdr');
            hdr.appendChild(el('span', 'viz-mem-segname', name));
            if (empty) {
                // collapse empty regions to a thin dim strip — no wasted vertical space
                hdr.appendChild(el('span', 'viz-mem-segempty', emptyMsg || '(empty)'));
                seg.appendChild(hdr);
                return seg;
            }
            if (sub) hdr.appendChild(el('span', 'viz-mem-segsub', sub));
            seg.appendChild(hdr);
            var inner = el('div', 'viz-mem-seginner');
            buildInner(inner);
            seg.appendChild(inner);
            return seg;
        }

        body.appendChild(el('div', 'viz-mem-axis', 'high addresses'));

        // ── STACK (grows down) ──
        body.appendChild(segment('viz-mem-seg-stack', 'Stack', 'grows ↓ · locals & call frames',
            function (inner) {
                frames.forEach(function (f) {
                    var fr = el('div', 'viz-mem-frame');
                    fr.appendChild(el('div', 'viz-mem-fn', f.fn + '()'));
                    (f.locals || []).forEach(function (l) { fr.appendChild(memVarRow(l, colorOf, labelOf)); });
                    if (!f.locals || !f.locals.length) fr.appendChild(el('div', 'viz-mem-empty', '(no tracked locals)'));
                    inner.appendChild(fr);
                });
            }, '(no active frames)', !frames.length));

        // ── HEAP (grows up) ──
        body.appendChild(segment('viz-mem-seg-heap', 'Heap', 'grows ↑ · new / malloc',
            function (inner) {
                heap.forEach(function (h) {
                    var blk = el('div', 'viz-mem-block' + (h.freed ? ' viz-mem-block-freed' : ''));
                    blk.style.borderColor = colorOf[h.addr];
                    blk.setAttribute('data-addr', h.addr);
                    var lab = el('span', 'viz-mem-blabel', labelOf[h.addr]);
                    lab.style.background = colorOf[h.addr];
                    blk.appendChild(lab);
                    blk.appendChild(el('span', 'viz-mem-bmeta', shortAddr(h.addr) + ' · ' + h.size + ' B' + (h.freed ? ' · freed' : '')));
                    inner.appendChild(blk);
                });
            }, '(no heap allocations yet)', !heap.length));

        // ── BSS (uninitialised globals) ──
        body.appendChild(segment('viz-mem-seg-bss', 'BSS', 'zero-initialised globals / statics',
            function (inner) { bss.forEach(function (l) { inner.appendChild(memVarRow(l, colorOf, labelOf)); }); },
            '(none)', !bss.length));

        // ── DATA (initialised globals) ──
        body.appendChild(segment('viz-mem-seg-data', 'Data', 'initialised globals / statics',
            function (inner) { data.forEach(function (l) { inner.appendChild(memVarRow(l, colorOf, labelOf)); }); },
            '(none)', !data.length));

        // ── TEXT / .rodata (informational — always a compact strip) ──
        body.appendChild(segment('viz-mem-seg-text', 'Text / .rodata', '',
            null, 'code & read-only constants', true));

        body.appendChild(el('div', 'viz-mem-axis', 'low addresses'));

        panel.appendChild(body);
        drawMemArrows(panel);
        wireMemHover(panel);
        return panel;
    }

    // Progressive enhancement: draw SVG arrows from pointer locals to heap blocks
    // once the panel is laid out. Falls back silently to the color/label links.
    function drawMemArrows(panel) {
        if (typeof requestAnimationFrame !== 'function') return;
        requestAnimationFrame(function () {
            var body = panel.querySelector('.viz-mem-body');
            if (!body) return;
            var pr = body.getBoundingClientRect();
            if (!pr.width) return;
            var svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
            svg.setAttribute('class', 'viz-mem-arrows');
            svg.style.position = 'absolute'; svg.style.left = 0; svg.style.top = 0;
            svg.style.width = pr.width + 'px'; svg.style.height = pr.height + 'px';
            svg.style.pointerEvents = 'none';
            // shared arrowhead marker
            var NS = 'http://www.w3.org/2000/svg';
            var defs = document.createElementNS(NS, 'defs');
            var mk = document.createElementNS(NS, 'marker');
            mk.setAttribute('id', 'vizMemHead'); mk.setAttribute('viewBox', '0 0 8 8');
            mk.setAttribute('refX', '6.5'); mk.setAttribute('refY', '4');
            mk.setAttribute('markerWidth', '5'); mk.setAttribute('markerHeight', '5'); mk.setAttribute('orient', 'auto-start-reverse');
            var mp = document.createElementNS(NS, 'path');
            mp.setAttribute('d', 'M0 0 L8 4 L0 8 z'); mp.setAttribute('class', 'viz-mem-arrowhead');
            mk.appendChild(mp); defs.appendChild(mk); svg.appendChild(defs);
            body.style.position = 'relative';
            var srcs = body.querySelectorAll('[data-target]');
            for (var i = 0; i < srcs.length; i++) {
                var tgt = srcs[i].getAttribute('data-target');
                var blk = body.querySelector('[data-addr="' + (window.CSS && CSS.escape ? CSS.escape(tgt) : tgt) + '"]');
                if (!blk) continue;
                var a = srcs[i].getBoundingClientRect(), b = blk.getBoundingClientRect();
                var x1 = a.right - pr.left, y1 = a.top - pr.top + a.height / 2;
                var d;
                if (b.left - pr.left > x1 + 16) {
                    // target sits to the right — smooth curve into its left edge
                    var lx = b.left - pr.left, ly = b.top - pr.top + b.height / 2;
                    d = 'M' + x1 + ' ' + y1 + ' C' + (x1 + 28) + ' ' + y1 + ' ' + (lx - 28) + ' ' + ly + ' ' + lx + ' ' + ly;
                } else {
                    // same column / below (stack→stack, stack→heap-below): tidy right-side elbow
                    var rx = b.right - pr.left, ry = b.top - pr.top + b.height / 2;
                    var bus = Math.max(x1, rx) + 18;
                    d = 'M' + x1 + ' ' + y1 + ' L' + bus + ' ' + y1 + ' L' + bus + ' ' + ry + ' L' + rx + ' ' + ry;
                }
                var ln = document.createElementNS(NS, 'path');
                ln.setAttribute('d', d);
                ln.setAttribute('class', 'viz-mem-arrow');
                ln.setAttribute('marker-end', 'url(#vizMemHead)');
                var col = blk.style && blk.style.borderColor;
                if (col) ln.style.stroke = col;   // match the target object's colour
                svg.appendChild(ln);
            }
            body.appendChild(svg);
        });
    }

    // Hover a pointer to light up its target object (and hover an object to light
    // up every pointer into it) — makes references and aliasing tangible. No-op
    // in headless (querySelectorAll returns none) so tests are unaffected.
    function wireMemHover(panel) {
        var body = panel.querySelector && panel.querySelector('.viz-mem-body');
        if (!body || typeof body.querySelectorAll !== 'function') return;
        var esc = function (s) { return (window.CSS && CSS.escape) ? CSS.escape(s) : s; };
        var glow = function (sel, on) {
            var els = body.querySelectorAll(sel);
            for (var i = 0; i < els.length; i++) els[i].classList[on ? 'add' : 'remove']('viz-mem-hot');
        };
        var bind = function (elm, sel) {
            if (!elm.addEventListener) return;
            elm.addEventListener('mouseenter', function () { glow(sel, true); elm.classList.add('viz-mem-hot'); });
            elm.addEventListener('mouseleave', function () { glow(sel, false); elm.classList.remove('viz-mem-hot'); });
        };
        var srcs = body.querySelectorAll('[data-target]');
        for (var i = 0; i < srcs.length; i++) bind(srcs[i], '[data-addr="' + esc(srcs[i].getAttribute('data-target')) + '"]');
        var objs = body.querySelectorAll('[data-addr]');
        for (var j = 0; j < objs.length; j++) bind(objs[j], '[data-target="' + esc(objs[j].getAttribute('data-addr')) + '"]');
    }

    function renderTracer(key, meta, state, opts) {
        if (!meta[key]) return null;
        var type = meta[key].type;
        var title = meta[key].title || type;
        opts = opts || {};

        switch (type) {
            case 'Array1DTracer': return renderArray1D(state, title, opts);
            case 'Array2DTracer': return renderArray2D(state, title, opts);
            case 'MapTracer': return renderMap(state, title, opts);
            case 'GraphTracer': return renderGraph(state, title);
            case 'CallStackTracer': return renderCallStack(state, title);
            case 'LogTracer': return renderLog(state, title);
            case 'MemTracer': return renderMem(state, title);
            case 'CodeTracer':
                return null;
            default:
                return null;
        }
    }

    function flattenLayoutChildren(key, meta, states, out) {
        if (!meta[key]) return out;
        var type = meta[key].type;
        var st = states[key] || {};
        if (type === 'VerticalLayout' || type === 'HorizontalLayout') {
            (st.children || []).forEach(function (childKey) {
                if (!childKey || !meta[childKey]) return;
                var childType = meta[childKey].type;
                if (childType === 'VerticalLayout' || childType === 'HorizontalLayout') {
                    flattenLayoutChildren(childKey, meta, states, out);
                } else if (childType !== 'CodeTracer') {
                    out.push(childKey);
                }
            });
            return out;
        }
        if (type !== 'CodeTracer') out.push(key);
        return out;
    }

    function orderedTracerKeys(rootKey, meta, states) {
        if (rootKey && meta[rootKey]) {
            var rootType = meta[rootKey].type;
            var rootState = states[rootKey] || {};
            if ((rootType === 'VerticalLayout' || rootType === 'HorizontalLayout') && rootState.children) {
                return flattenLayoutChildren(rootKey, meta, states, []);
            }
        }
        return Object.keys(states).filter(function (k) {
            return meta[k] && meta[k].type !== 'CodeTracer';
        });
    }

    var memView = false;   // "Structures ⇄ Memory" lens toggle (shared step player)

    function renderStep(container, step) {
        container.innerHTML = '';
        container.className = 'viz-stage';
        if (!step || !step.tracers) {
            container.appendChild(el('div', 'viz-stage-empty', 'Run Visualize to see algorithm steps.'));
            return { line: null };
        }

        var meta = step.meta || {};
        var states = step.tracers || {};

        // Memory lens: render ONLY the memory diagram (its own tab).
        var memKey = Object.keys(meta).filter(function (k) { return meta[k] && meta[k].type === 'MemTracer'; })[0];
        if (memKey && memView) {
            container.appendChild(renderMem(states[memKey] || {}, meta[memKey].title));
            return { line: step.line };
        }
        var prioritized = prioritizeTracerKeys(orderedTracerKeys(step.rootKey, meta, states), meta, states);
        var keys = prioritized.keys.filter(function (k) { return !(meta[k] && meta[k].type === 'MemTracer'); });

        if (!keys.length) {
            container.appendChild(el('div', 'viz-stage-empty', 'No visual tracers in this step.'));
            return { line: step.line };
        }

        var hasPrimary = keys.some(function (k) {
            var t = meta[k] && meta[k].type;
            return t === 'Array1DTracer' || t === 'Array2DTracer';
        });
        if (hasPrimary) {
            container.classList.add('viz-has-primary');
        }

        var primarySet = false;
        keys.forEach(function (k) {
            var type = meta[k] && meta[k].type;
            var opts = {
                primary: !primarySet && (type === 'Array1DTracer' || type === 'Array2DTracer'),
                compact: type === 'LogTracer' || type === 'CallStackTracer'
            };
            if (opts.primary) primarySet = true;
            var node = renderTracer(k, meta, states[k] || {}, opts);
            if (node) container.appendChild(node);
        });

        if (prioritized.hiddenArrays > 0) {
            container.appendChild(el('div', 'viz-hidden-note',
                '+' + prioritized.hiddenArrays + ' more array' +
                (prioritized.hiddenArrays > 1 ? 's' : '') + ' this step (showing active + largest)'));
        }

        return { line: step.line };
    }

    global.OcViz = global.OcViz || {};
    global.OcViz.renderStep = renderStep;
    global.OcViz.setMemView = function (v) { memView = !!v; };
    global.OcViz.getMemView = function () { return memView; };
    // does any step in this trace carry a memory snapshot? (drives the toggle's visibility)
    global.OcViz.traceHasMem = function (steps) {
        return !!(steps && steps.some(function (s) {
            return s && s.meta && Object.keys(s.meta).some(function (k) { return s.meta[k].type === 'MemTracer'; });
        }));
    };
    global.OcViz._layoutGraph = layoutGraph;  // exposed for tests
}(typeof window !== 'undefined' ? window : this));
