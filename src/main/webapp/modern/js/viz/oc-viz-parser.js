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

        function snapshot() {
            var snap = {
                line: lastLine,
                rootKey: meta.__rootKey || null,
                tracers: cloneState(states),
                meta: JSON.parse(JSON.stringify(meta))
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
            applyCommand(cmd, meta, states);
            dirty = true;
            if (cmd.method === 'println' && cmd.key && meta[cmd.key] && meta[cmd.key].type === 'CodeTracer') {
                lastLine = cmd.args && cmd.args[0];
            }
        });

        if (dirty) {
            snapshot();
        }

        return {
            steps: dedupeConsecutiveSteps(steps),
            meta: meta,
            rootKey: meta.__rootKey || null
        };
    }

    function dedupeConsecutiveSteps(steps) {
        if (!steps || steps.length < 2) {
            return steps || [];
        }
        var out = [steps[0]];
        for (var i = 1; i < steps.length; i++) {
            if (JSON.stringify(steps[i]) !== JSON.stringify(out[out.length - 1])) {
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
