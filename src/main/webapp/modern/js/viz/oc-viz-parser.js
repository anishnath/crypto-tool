/**
 * Parse viz command stream into step snapshots for playback.
 */
(function (global) {
    'use strict';

    var TRACER_TYPES = global.OcViz && global.OcViz.TRACER_TYPES;

    function isTracerType(method) {
        if (!TRACER_TYPES) {
            return false;
        }
        return TRACER_TYPES[method];
    }

    function defaultState(type) {
        switch (type) {
            case 'CodeTracer':
                return { line: null };
            case 'Array1DTracer':
                return { values: [], selected: null, lastPatch: null };
            case 'Array2DTracer':
                return { values: [], selected: null, lastPatch: null };
            case 'MapTracer':
                return { entries: {}, selected: null };
            case 'GraphTracer':
                return { nodes: {}, edges: [], selected: null };
            case 'CallStackTracer':
                return { frames: [] };
            case 'LogTracer':
                return { lines: [] };
            case 'MemTracer':
                return { snap: null };
            case 'VerticalLayout':
            case 'HorizontalLayout':
                return { children: [] };
            default:
                return {};
        }
    }

    function cloneState(states) {
        return JSON.parse(JSON.stringify(states));
    }

    function cloneArrayValues(values) {
        if (!values || !values.length) return [];
        return values.map(function (row) {
            return Array.isArray(row) ? row.slice() : row;
        });
    }

    function applyGraphSet(st, data) {
        st.nodes = {};
        st.edges = [];
        if (!data) return;

        var nodeList = [];
        var edgeList = [];
        if (Array.isArray(data)) {
            nodeList = data;
        } else if (typeof data === 'object') {
            nodeList = data.nodes || [];
            edgeList = data.edges || [];
        }

        nodeList.forEach(function (n) {
            if (n && n.id != null) {
                st.nodes[String(n.id)] = {
                    id: String(n.id),
                    label: n.label != null ? String(n.label) : String(n.id),
                    x: n.x,
                    y: n.y
                };
            }
        });
        edgeList.forEach(function (e) {
            if (e && e.from != null && e.to != null) {
                st.edges.push({ from: String(e.from), to: String(e.to) });
            }
        });
    }

    function applyCommand(cmd, meta, states) {
        var key = cmd.key;
        var method = cmd.method;
        var args = cmd.args || [];

        if (isTracerType(method) && key) {
            var title = method;
            if (method !== 'VerticalLayout' && method !== 'HorizontalLayout') {
                title = (typeof args[0] === 'string') ? args[0] : method;
            }
            meta[key] = { type: method, title: title };
            states[key] = defaultState(method);
            if (method === 'VerticalLayout' || method === 'HorizontalLayout') {
                var childArg = args[0];
                states[key].children = Array.isArray(childArg) ? childArg.slice() : args.slice();
            }
            return;
        }

        if (method === 'setRoot') {
            meta.__rootKey = args[0];
            return;
        }

        if (method === 'destroy') {
            if (key) {
                delete states[key];
                delete meta[key];
            }
            return;
        }

        if (!key || !states[key]) {
            return;
        }

        var st = states[key];
        var t = meta[key] && meta[key].type;

        switch (method) {
            case 'println':
                if (t === 'CodeTracer') {
                    st.line = args[0];
                } else if (t === 'LogTracer') {
                    st.lines.push(String(args[0]));
                }
                break;
            case 'set':
                if (t === 'Array1DTracer') {
                    st.values = args[0] ? args[0].slice() : [];
                    st.lastPatch = null;
                } else if (t === 'Array2DTracer') {
                    st.values = cloneArrayValues(args[0] || []);
                    st.lastPatch = null;
                } else if (t === 'MapTracer') {
                    st.entries = {};
                    var entries = args[0] || [];
                    entries.forEach(function (pair) {
                        if (Array.isArray(pair) && pair.length >= 2) {
                            st.entries[String(pair[0])] = pair[1];
                        }
                    });
                } else if (t === 'GraphTracer') {
                    applyGraphSet(st, args[0]);
                }
                break;
            case 'select':
                st.selected = args[0];
                break;
            case 'deselect':
                st.selected = null;
                break;
            case 'patch':
                if (t === 'Array1DTracer' && st.values) {
                    st.values[args[0]] = args[1];
                    st.lastPatch = args[0];
                } else if (t === 'Array2DTracer' && st.values) {
                    var row = args[0];
                    var col = args[1];
                    var val = args[2];
                    if (st.values[row]) {
                        st.values[row][col] = val;
                    }
                    st.lastPatch = [row, col];
                } else if (t === 'MapTracer') {
                    st.entries[String(args[0])] = args[1];
                }
                break;
            case 'depatch':
                st.lastPatch = null;
                break;
            case 'visit':
                if (t === 'GraphTracer') {
                    st.selected = args[0];
                }
                break;
            case 'push':
                if (t === 'CallStackTracer') {
                    st.frames.push(String(args[0]));
                }
                break;
            case 'pop':
                if (t === 'CallStackTracer' && st.frames.length) {
                    st.frames.pop();
                }
                break;
            case 'snap':
                if (t === 'MemTracer') {
                    st.snap = args[0] || null;   // full memory snapshot for this step
                }
                break;
            default:
                break;
        }
    }

    function buildSteps(commands) {
        var meta = {};
        var states = {};
        var steps = [];
        var lastLine = null;
        var dirty = false;
        // Operation counters derived straight from the command stream:
        // a `select` is a read/compare, a `patch` is a write/update. Cumulative
        // per step, so the player can show running totals + empirical Big-O.
        var reads = 0;
        var writes = 0;

        function snapshot() {
            var snap = {
                line: lastLine,
                rootKey: meta.__rootKey || null,
                tracers: cloneState(states),
                meta: JSON.parse(JSON.stringify(meta)),
                reads: reads,
                writes: writes
            };
            steps.push(snap);
            dirty = false;
        }

        if (!commands || !commands.length) {
            snapshot();
            return { steps: steps, meta: meta, rootKey: null };
        }

        commands.forEach(function (cmd) {
            if (cmd.method === 'delay') {
                if (dirty || !steps.length) {
                    snapshot();
                }
                return;
            }
            if (cmd.method === 'select') {
                reads++;
            } else if (cmd.method === 'patch') {
                writes++;
            }
            applyCommand(cmd, meta, states);
            dirty = true;
            if (cmd.method === 'println' && cmd.key && meta[cmd.key] && meta[cmd.key].type === 'CodeTracer') {
                lastLine = cmd.args && cmd.args[0];
            }
        });

        if (dirty) {
            snapshot();
        }

        var finalSteps = dedupeConsecutiveSteps(steps);
        markMemChanges(finalSteps);
        return {
            steps: finalSteps,
            meta: meta,
            rootKey: meta.__rootKey || null
        };
    }

    // ── Memory "what changed this step" diff ─────────────────────────────────
    // Annotates each memory snapshot's vars/cells with _changed / _changedCells
    // by comparing to the previous step's snapshot, so the renderer can highlight
    // exactly what a step modified. Navigation-independent (uses step order).
    function memSnapOf(step) {
        if (!step || !step.meta) return null;
        for (var k in step.meta) {
            if (step.meta[k] && step.meta[k].type === 'MemTracer') {
                return step.tracers[k] && step.tracers[k].snap;
            }
        }
        return null;
    }
    function varSig(v) {
        if (!v) return null;
        if (v.cells) return null; // arrays diffed per-cell
        return (v.value != null ? String(v.value) : '') + '|' + (v.target != null ? v.target : '') + '|' + (v.points_to || '');
    }
    function indexByName(list) {
        var m = {};
        (list || []).forEach(function (v) { if (v && v.name != null) m[v.name] = v; });
        return m;
    }
    function markVar(prevMap, v) {
        var p = prevMap[v.name];
        if (v.cells) {
            var pc = (p && p.cells) || [];
            var ch = [];
            for (var i = 0; i < v.cells.length; i++) {
                if (!p || String(v.cells[i]) !== String(pc[i])) ch.push(i);
            }
            if (ch.length) v._changedCells = ch;
            return;
        }
        if (!p) { v._changed = true; return; }        // newly declared -> highlight
        if (varSig(v) !== varSig(p)) v._changed = true;
    }
    function diffList(prevList, curList) {
        var pm = indexByName(prevList);
        (curList || []).forEach(function (v) { markVar(pm, v); });
    }
    function diffMem(prev, cur) {
        diffList(prev.statics, cur.statics);
        diffList(prev.data, cur.data);
        diffList(prev.bss, cur.bss);
        var pf = prev.frames || [], cf = cur.frames || [];
        for (var i = 0; i < cf.length; i++) {
            if (pf[i]) diffList(pf[i].locals, cf[i].locals);
            else (cf[i].locals || []).forEach(function (v) { markVar({}, v); });
        }
        var ph = {};
        (prev.heap || []).forEach(function (o) { if (o.id != null) ph[o.id] = o; });
        (cur.heap || []).forEach(function (o) {
            var p = ph[o.id];
            if (o.cells) {
                var pc = (p && p.cells) || [];
                var ch = [];
                for (var i = 0; i < o.cells.length; i++) {
                    if (!p || String(o.cells[i]) !== String(pc[i])) ch.push(i);
                }
                if (ch.length) o._changedCells = ch;
            } else if (o.fields) {
                var pfm = indexByName(p && p.fields);
                o.fields.forEach(function (f) { markVar(pfm, f); });
            }
        });
    }
    function markMemChanges(steps) {
        var prev = null;
        for (var i = 0; i < steps.length; i++) {
            var s = memSnapOf(steps[i]);
            if (!s) continue;
            if (prev) diffMem(prev, s);
            prev = s;
        }
    }

    // Compare visual state only (not the op counters), so a step that merely
    // bumps reads/writes without changing what's drawn still collapses exactly
    // as before — counts ride along on the surviving step.
    function stepStateKey(s) {
        return JSON.stringify({ line: s.line, rootKey: s.rootKey, tracers: s.tracers, meta: s.meta });
    }

    function dedupeConsecutiveSteps(steps) {
        if (!steps || steps.length < 2) {
            return steps || [];
        }
        var out = [steps[0]];
        for (var i = 1; i < steps.length; i++) {
            if (stepStateKey(steps[i]) !== stepStateKey(out[out.length - 1])) {
                out.push(steps[i]);
            }
        }
        return out;
    }

    function formatVizLog(commands) {
        if (!commands || !commands.length) {
            return '(no commands)';
        }
        return commands.map(function (c, i) {
            var key = c.key != null ? c.key : '-';
            var args = (c.args || []).map(function (a) {
                if (typeof a === 'object') {
                    try { return JSON.stringify(a); } catch (e) { return String(a); }
                }
                return String(a);
            }).join(', ');
            return (i + 1) + '. [' + key + '] ' + c.method + '(' + args + ')';
        }).join('\n');
    }

    global.OcViz = global.OcViz || {};
    global.OcViz.buildSteps = buildSteps;
    global.OcViz.formatVizLog = formatVizLog;
    global.OcViz.defaultTracerState = defaultState;
}(typeof window !== 'undefined' ? window : this));
