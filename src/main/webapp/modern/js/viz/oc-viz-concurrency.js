/**
 * Concurrency (swim-lane) renderer.
 *
 * Consumes the Go engine's event log: { kind:"concurrency", lanes, events, stdout }.
 * Draws a sequence/swim-lane diagram — one lifeline per goroutine, send↔recv
 * messages as arrows (matched by chan+pair), and blocked intervals as shaded
 * segments (a *-start with no completion = parked / deadlocked).
 *
 * Each event is one playback step; the existing OcViz player drives it. The
 * renderer paints cumulative state up to the current event index.
 */
(function (global) {
    'use strict';

    var LANE_W = 150;
    var MARGIN_X = 34;
    var HEADER_H = 46;
    var TOP_PAD = 16;
    var ROW_H = 26;
    var BOTTOM_PAD = 28;

    var COLORS = {
        send: '#f59e0b',
        'send-start': '#f59e0b',
        recv: '#60a5fa',
        'recv-start': '#60a5fa',
        'go-start': '#34d399',
        'go-end': '#6b7280',
        'main-start': '#34d399',
        'main-end': '#6b7280',
        close: '#f472b6'
    };

    function isConcurrency(data) {
        return !!(data && (data.kind === 'concurrency' || (data.concurrency)));
    }

    // Accepts either the response wrapper {concurrency:{…}} or the log object.
    function buildConcSteps(input) {
        var log = (input && input.kind === 'concurrency') ? input : (input && input.concurrency) || input || {};
        var events = (log.events || []).slice();
        var lanes = (log.lanes || []).slice().sort(function (a, b) { return a.lane - b.lane; });

        // Precompute send/recv arrows (matched FIFO by chan+pair).
        var byKey = {};
        events.forEach(function (e, i) {
            if (e.type === 'send' || e.type === 'recv') {
                var key = e.chan + '#' + e.pair;
                byKey[key] = byKey[key] || {};
                byKey[key][e.type] = { idx: i, lane: e.lane, val: e.val };
            }
        });
        var arrows = [];
        Object.keys(byKey).forEach(function (k) {
            var p = byKey[k];
            if (p.send && p.recv) {
                arrows.push({
                    fromLane: p.send.lane,
                    toLane: p.recv.lane,
                    value: p.recv.val != null && p.recv.val !== '' ? p.recv.val : p.send.val,
                    atIndex: Math.max(p.send.idx, p.recv.idx),
                    chan: k.split('#')[0]
                });
            }
        });

        // Precompute blocked intervals per lane (start → its completion, or open).
        var open = {};
        var blocks = [];
        events.forEach(function (e, i) {
            if (e.type === 'send-start' || e.type === 'recv-start') {
                open[e.lane] = { startIdx: i, type: e.type };
            } else if (e.type === 'send' || e.type === 'recv') {
                var o = open[e.lane];
                if (o) { blocks.push({ lane: e.lane, startIdx: o.startIdx, endIdx: i, type: o.type }); delete open[e.lane]; }
            }
        });
        Object.keys(open).forEach(function (l) {
            blocks.push({ lane: parseInt(l, 10), startIdx: open[l].startIdx, endIdx: null, type: open[l].type });
        });

        return {
            kind: 'concurrency',
            lanes: lanes,
            events: events,
            stdout: log.stdout || [],
            arrows: arrows,
            blocks: blocks,
            steps: events // one event per playback step
        };
    }

    function laneCol(model, laneIdx) {
        for (var i = 0; i < model.lanes.length; i++) {
            if (model.lanes[i].lane === laneIdx) return i;
        }
        return laneIdx;
    }

    function laneX(model, laneIdx) {
        return MARGIN_X + laneCol(model, laneIdx) * LANE_W + LANE_W / 2;
    }

    function eventY(k) {
        return HEADER_H + TOP_PAD + k * ROW_H;
    }

    function esc(s) {
        return String(s == null ? '' : s).replace(/[&<>"]/g, function (c) {
            return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c];
        });
    }

    function laneStatus(model, laneIdx, index) {
        var last = null;
        for (var i = 0; i <= index && i < model.events.length; i++) {
            if (model.events[i].lane === laneIdx) last = model.events[i];
        }
        if (!last) return 'idle';
        if (last.type === 'go-end' || last.type === 'main-end') return 'done';
        // open block straddling current index → blocked
        for (var b = 0; b < model.blocks.length; b++) {
            var blk = model.blocks[b];
            if (blk.lane === laneIdx && blk.startIdx <= index && (blk.endIdx === null || blk.endIdx > index)) {
                return 'blocked';
            }
        }
        return 'running';
    }

    function renderConcStep(stage, model, index) {
        if (!stage) return;
        if (!model.events.length) {
            stage.innerHTML = '<div class="viz-stage-empty">No concurrency events were captured.</div>';
            return;
        }
        index = Math.max(0, Math.min(index, model.events.length - 1));

        var width = MARGIN_X * 2 + model.lanes.length * LANE_W;
        var height = HEADER_H + TOP_PAD + model.events.length * ROW_H + BOTTOM_PAD;
        var parts = [];
        parts.push('<svg class="viz-conc-svg" width="' + width + '" height="' + height +
            '" viewBox="0 0 ' + width + ' ' + height + '" xmlns="http://www.w3.org/2000/svg">');
        parts.push('<defs><marker id="vcArrow" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto">' +
            '<path d="M0,0 L7,3 L0,6 Z" fill="#cbd5e1"/></marker></defs>');

        // Lifelines + lane headers + status.
        model.lanes.forEach(function (ln) {
            var x = laneX(model, ln.lane);
            var status = laneStatus(model, ln.lane, index);
            parts.push('<line x1="' + x + '" y1="' + HEADER_H + '" x2="' + x + '" y2="' + (height - BOTTOM_PAD + 8) +
                '" class="viz-conc-life"/>');
            parts.push('<rect x="' + (x - LANE_W / 2 + 8) + '" y="8" width="' + (LANE_W - 16) + '" height="30" rx="6" class="viz-conc-head viz-conc-head-' + status + '"/>');
            parts.push('<text x="' + x + '" y="27" class="viz-conc-lane-label">' + esc(ln.label) + '</text>');
        });

        // Blocked intervals (only the portion realized by the current index).
        model.blocks.forEach(function (blk) {
            if (blk.startIdx > index) return;
            var endRow = blk.endIdx === null ? index : Math.min(blk.endIdx, index);
            if (endRow <= blk.startIdx) return;
            var x = laneX(model, blk.lane);
            var y0 = eventY(blk.startIdx);
            var y1 = eventY(endRow);
            var stillBlocked = (blk.endIdx === null || blk.endIdx > index);
            parts.push('<rect x="' + (x - 5) + '" y="' + y0 + '" width="10" height="' + (y1 - y0) +
                '" rx="4" class="viz-conc-block' + (stillBlocked ? ' viz-conc-block-open' : '') + '"/>');
        });

        // Message arrows (send → recv) realized by the current index.
        model.arrows.forEach(function (a) {
            if (a.atIndex > index) return;
            var x1 = laneX(model, a.fromLane);
            var x2 = laneX(model, a.toLane);
            var y = eventY(a.atIndex);
            var cls = a.atIndex === index ? 'viz-conc-msg viz-conc-msg-active' : 'viz-conc-msg';
            parts.push('<line x1="' + x1 + '" y1="' + y + '" x2="' + x2 + '" y2="' + y + '" class="' + cls + '" marker-end="url(#vcArrow)"/>');
            var midX = (x1 + x2) / 2;
            var label = esc(a.chan) + (a.value != null && a.value !== '' ? ' ' + esc(a.value) : '');
            parts.push('<text x="' + midX + '" y="' + (y - 5) + '" class="viz-conc-msg-label">' + label + '</text>');
        });

        // Event dots up to current index.
        for (var k = 0; k <= index; k++) {
            var e = model.events[k];
            var x = laneX(model, e.lane);
            var y = eventY(k);
            var color = COLORS[e.type] || '#94a3b8';
            var isStart = e.type.indexOf('-start') >= 0 && e.type !== 'go-start' && e.type !== 'main-start';
            var r = (k === index) ? 6 : 4;
            if (k === index) {
                parts.push('<circle cx="' + x + '" cy="' + y + '" r="11" class="viz-conc-pulse"/>');
            }
            parts.push('<circle cx="' + x + '" cy="' + y + '" r="' + r + '" fill="' + color +
                '"' + (isStart ? ' fill-opacity="0.35" stroke="' + color + '"' : '') + '/>');
        }

        // Current-event caption to the right.
        var cur = model.events[index];
        var capY = eventY(index);
        var capText = describe(cur);
        parts.push('<text x="' + (width - 6) + '" y="' + (capY + 4) + '" class="viz-conc-caption" text-anchor="end">' + esc(capText) + '</text>');

        parts.push('</svg>');

        stage.innerHTML =
            '<div class="viz-conc-wrap">' + parts.join('') + '</div>' +
            legendHtml();

        // Auto-scroll the active row into view within the stage.
        var wrap = stage.querySelector('.viz-conc-wrap');
        if (wrap) {
            var targetTop = capY - wrap.clientHeight / 2;
            wrap.scrollTop = Math.max(0, targetTop);
        }
    }

    function describe(e) {
        switch (e.type) {
            case 'send-start': return 'send → ' + e.chan + (e.val ? ' (' + e.val + ')' : '') + ' …';
            case 'send': return 'sent → ' + e.chan;
            case 'recv-start': return 'recv ← ' + e.chan + ' …';
            case 'recv': return 'received ' + (e.val ? e.val + ' ' : '') + '← ' + e.chan;
            case 'go-start': return 'goroutine started';
            case 'go-end': return 'goroutine finished';
            case 'main-start': return 'main started';
            case 'main-end': return 'main finished';
            case 'close': return 'close(' + e.chan + ')';
            default: return e.type;
        }
    }

    function legendHtml() {
        return '<div class="viz-conc-legend">' +
            '<span><i style="background:#f59e0b"></i> send</span>' +
            '<span><i style="background:#60a5fa"></i> receive</span>' +
            '<span><i class="vc-leg-block"></i> blocked / waiting</span>' +
            '<span><i style="background:#34d399"></i> start</span>' +
            '</div>';
    }

    global.OcViz = global.OcViz || {};
    global.OcViz.isConcurrency = isConcurrency;
    global.OcViz.buildConcSteps = buildConcSteps;
    global.OcViz.renderConcStep = renderConcStep;
}(typeof window !== 'undefined' ? window : this));
