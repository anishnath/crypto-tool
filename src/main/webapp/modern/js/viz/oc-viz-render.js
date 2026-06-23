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

        var positions = {};
        nodeList.forEach(function (n, i) {
            var x = n.x != null ? n.x : 40 + (i % 4) * 60;
            var y = n.y != null ? n.y : 30 + Math.floor(i / 4) * 50;
            positions[n.id] = { x: x, y: y };
        });
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

        (state.edges || []).forEach(function (e) {
            var a = positions[e.from];
            var b = positions[e.to];
            if (!a || !b) return;
            var line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
            line.setAttribute('class', 'viz-graph-edge');
            line.setAttribute('marker-end', 'url(#' + markerId + ')');
            line.setAttribute('x1', a.x);
            line.setAttribute('y1', a.y);
            line.setAttribute('x2', b.x);
            line.setAttribute('y2', b.y);
            svg.appendChild(line);
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

    function renderStep(container, step) {
        container.innerHTML = '';
        container.className = 'viz-stage';
        if (!step || !step.tracers) {
            container.appendChild(el('div', 'viz-stage-empty', 'Run Visualize to see algorithm steps.'));
            return { line: null };
        }

        var meta = step.meta || {};
        var states = step.tracers || {};
        var prioritized = prioritizeTracerKeys(orderedTracerKeys(step.rootKey, meta, states), meta, states);
        var keys = prioritized.keys;

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
}(typeof window !== 'undefined' ? window : this));
