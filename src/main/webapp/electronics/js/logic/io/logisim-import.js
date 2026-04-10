/**
 * Logisim Evolution .circ XML → 8gwifi Logic Simulator JSON converter
 * Parses Logisim XML, maps components, resolves wires via spatial port matching.
 * Supports: gates, pins, memory, arithmetic, plexers, displays, TTL, splitters, subcircuits.
 */
(function(L) {
    'use strict';

    // ── Component type mapping ──
    var TYPE_MAP = {
        // lib 0 — Wiring
        'Pin':           function(a) { return a.type === 'output' ? 'OUTPUT' : 'INPUT'; },
        'Clock':         function() { return 'CLOCK'; },
        'Ground':        function() { return 'CONSTANT'; },
        'Constant':      function() { return 'CONSTANT'; },
        'Power':         function() { return 'CONSTANT'; },
        'Tunnel':        function() { return 'TUNNEL'; },
        'Splitter':      function() { return '_SPLITTER'; },
        'Pull Resistor': function() { return 'PULL_RESISTOR'; },
        'Probe':         function() { return 'PROBE'; },
        'Bit Extender':  function() { return '_SKIP'; },

        // lib 1 — Gates
        'AND Gate':  function() { return 'AND'; },
        'OR Gate':   function() { return 'OR'; },
        'NOT Gate':  function() { return 'NOT'; },
        'NAND Gate': function() { return 'NAND'; },
        'NOR Gate':  function() { return 'NOR'; },
        'XOR Gate':  function() { return 'XOR'; },
        'XNOR Gate': function() { return 'XNOR'; },
        'Buffer':    function() { return 'BUFFER'; },
        'Controlled Buffer': function() { return 'BUFFER'; },
        'Odd Parity': function() { return 'XOR'; },
        'Even Parity': function() { return 'XNOR'; },

        // lib 2 — Plexers
        'Multiplexer':   function() { return 'MUX'; },
        'Demultiplexer': function() { return 'DEMUX'; },
        'Decoder':       function() { return 'DECODER'; },
        'Priority Encoder': function() { return '_SKIP'; },
        'BitSelector':   function() { return '_SKIP'; },

        // lib 3 — Arithmetic
        'Adder':      function() { return 'ADDER'; },
        'Subtractor': function() { return 'SUBTRACTOR'; },
        'Comparator': function() { return 'COMPARATOR'; },
        'Multiplier': function() { return '_SKIP'; },
        'Divider':    function() { return '_SKIP'; },
        'Negator':    function() { return '_SKIP'; },
        'Shifter':    function() { return '_SKIP'; },

        // lib 4 — Memory
        'D Flip-Flop':   function() { return 'D_FF'; },
        'T Flip-Flop':   function() { return 'T_FF'; },
        'J-K Flip-Flop': function() { return 'JK_FF'; },
        'S-R Flip-Flop': function() { return 'SR_FF'; },
        'Register':      function() { return 'REGISTER'; },
        'Counter':       function() { return 'COUNTER'; },
        'RAM':           function() { return '_SKIP'; },
        'ROM':           function() { return '_SKIP'; },
        'Random':        function() { return '_SKIP'; },

        // lib 5 — I/O
        'LED':                  function() { return 'LED'; },
        'Button':               function() { return 'BUTTON'; },
        'DipSwitch':            function() { return 'SWITCH'; },
        '7-Segment Display':    function() { return 'SEVEN_SEG'; },
        'Hex Digit Display':    function() { return 'HEX_DISPLAY'; },
        'LED Matrix':           function() { return '_SKIP'; },
        'TTY':                  function() { return '_SKIP'; },
        'Keyboard':             function() { return '_SKIP'; },
        'Buzzer':               function() { return '_SKIP'; },

        // lib 6 — TTL
        '7400': function() { return 'TTL_7400'; },
        '7402': function() { return 'TTL_7402'; },
        '7404': function() { return 'TTL_7404'; },
        '7408': function() { return 'TTL_7408'; },
        '7432': function() { return 'TTL_7432'; },
        '7486': function() { return 'TTL_7486'; },
        '7474': function() { return 'TTL_7474'; },
        '7447': function() { return 'TTL_7447'; },
        '74138': function() { return 'TTL_74138'; },

        // lib 8 — Base
        'Text': function() { return 'TEXT_LABEL'; },

        // lib 9 — BFH-Praktika
        'BCD_to_7_Segment_decoder': function() { return 'BCD_7SEG_DECODER'; }
    };

    // ── Port offsets from Logisim Evolution source ──

    // Per-gate-type bonus width from Logisim AbstractGate source
    var GATE_BONUS = {
        'AND': 0, 'NAND': 10, 'OR': 10, 'NOR': 10,
        'XOR': 14, 'XNOR': 14, 'BUFFER': 0
    };

    // Exact gate input offset formula from AbstractGate.java getInputOffset()
    function gatePortOffsets(numInputs, facing, gateSize, gateType) {
        var size = gateSize || 30;
        var bonus = (gateType && GATE_BONUS[gateType] !== undefined) ? GATE_BONUS[gateType] : 0;
        var skipStart, skipDist, skipLowerEven;

        if (numInputs <= 3) {
            if (size < 40) {
                skipStart = -5; skipDist = 10; skipLowerEven = 10;
            } else if (size < 60 || numInputs <= 2) {
                skipStart = -10; skipDist = 20; skipLowerEven = 20;
            } else {
                skipStart = -15; skipDist = 30; skipLowerEven = 30;
            }
        } else if (numInputs === 4 && size >= 60) {
            skipStart = -5; skipDist = 20; skipLowerEven = 0;
        } else {
            skipStart = -5; skipDist = 10; skipLowerEven = 10;
        }

        var ports = [];
        for (var i = 0; i < numInputs; i++) {
            var dy;
            if (numInputs % 2 === 1) {
                dy = skipStart * (numInputs - 1) + skipDist * i;
            } else {
                dy = skipStart * numInputs + skipDist * i;
                if (i >= numInputs / 2) dy += skipLowerEven;
                if (numInputs === 4 && size >= 60) dy -= 10;
            }
            var dx = -(size + bonus);
            ports.push({ dx: dx, dy: dy, dir: 'in' });
        }
        ports.push({ dx: 0, dy: 0, dir: 'out' });
        return rotatePorts(ports, facing);
    }

    // NOT gate: from NotGate.java — input at -20 (narrow) or -30 (wide)
    function notPortOffsets(facing, gateSize) {
        var dx = (gateSize && gateSize >= 30) ? -30 : -20;
        return rotatePorts([
            { dx: dx, dy: 0, dir: 'in' },
            { dx: 0, dy: 0, dir: 'out' }
        ], facing);
    }

    // Pin: Pin.java says port at (0,0) but Logisim draws a 20px stub from body to wire connection point.
    // Wires connect at the tip, not the body. So effective port = loc ± 20px in facing direction.
    // Evidence: Pin at (100,100) east-facing, wire starts at (120,100) → +20px.
    // Pin port positions — Logisim Pin.java port is at (0,0) but wires connect at a stub tip.
    // The stub always extends AWAY from the component body (toward the circuit).
    // For pins, loc is at the body, and the wire connects at loc + offset in the facing direction.
    // BUT: output pins face west by convention, so their wire stub goes EAST (toward circuit).
    // The key insight: the wire endpoint relative to loc depends on facing, but Logisim's actual
    // port is at (0,0). The 20px stub is drawn by the renderer, not the port system.
    // So ALL pin ports are at (0,0) relative to loc. The test XML shows wires at (120,100)
    // for a pin at (100,100) — that 20px IS the wire, not the port.
    // The wire (120,100)→(150,105) has its START at a pin and END at a gate port.
    // We need the pin port at (120,100) = loc.x+20 for east-facing input.
    // For west-facing output at loc(260,115), wire ends at (240,115) = loc.x-20.
    // So: facing EAST → dx=+20, facing WEST → dx=-20, NORTH → dy=-20, SOUTH → dy=+20
    function pinPortOffsets(isOutput, facing) {
        var f = facing || 'east';
        var dir = isOutput ? 'in' : 'out';
        switch (f) {
            case 'east':  return [{ dx: 20, dy: 0, dir: dir }];
            case 'west':  return [{ dx: -20, dy: 0, dir: dir }];
            case 'north': return [{ dx: 0, dy: -20, dir: dir }];
            case 'south': return [{ dx: 0, dy: 20, dir: dir }];
            default:      return [{ dx: 20, dy: 0, dir: dir }];
        }
    }

    function clockPortOffsets(facing) {
        var f = facing || 'east';
        switch (f) {
            case 'east':  return [{ dx: 20, dy: 0, dir: 'out' }];
            case 'west':  return [{ dx: -20, dy: 0, dir: 'out' }];
            case 'north': return [{ dx: 0, dy: -20, dir: 'out' }];
            case 'south': return [{ dx: 0, dy: 20, dir: 'out' }];
            default:      return [{ dx: 20, dy: 0, dir: 'out' }];
        }
    }

    // Flip-flops — exact from AbstractFlipFlop.java updatePorts()
    // Classic: 1-input (D_FF, T_FF)
    function ffPortOffsets_1ctrl() {
        return [
            { dx: -40, dy: 20, dir: 'in' },   // D/T
            { dx: -40, dy: 0, dir: 'in' },    // CLK
            { dx: 0, dy: 0, dir: 'out' },     // Q
            { dx: 0, dy: 20, dir: 'out' },    // Q'
            { dx: -10, dy: 30, dir: 'in' },   // Reset
            { dx: -30, dy: 30, dir: 'in' }    // Preset
        ];
    }
    // Classic: 2-input (SR_FF, JK_FF)
    function ffPortOffsets_2ctrl() {
        return [
            { dx: -40, dy: 0, dir: 'in' },    // S/J
            { dx: -40, dy: 20, dir: 'in' },   // R/K
            { dx: -40, dy: 10, dir: 'in' },   // CLK
            { dx: 0, dy: 0, dir: 'out' },     // Q
            { dx: 0, dy: 20, dir: 'out' },    // Q'
            { dx: -10, dy: 30, dir: 'in' },   // Reset
            { dx: -30, dy: 30, dir: 'in' }    // Preset
        ];
    }
    // Modern: 1-input
    function ffModernPorts_1ctrl() {
        return [
            { dx: -10, dy: 10, dir: 'in' },   // D/T
            { dx: -10, dy: 50, dir: 'in' },   // CLK
            { dx: 50, dy: 10, dir: 'out' },   // Q
            { dx: 50, dy: 50, dir: 'out' },   // Q'
            { dx: 20, dy: 60, dir: 'in' },    // Reset
            { dx: 20, dy: 0, dir: 'in' }      // Preset
        ];
    }
    // Modern: 2-input
    function ffModernPorts_2ctrl() {
        return [
            { dx: -10, dy: 10, dir: 'in' },   // S/J
            { dx: -10, dy: 30, dir: 'in' },   // CLK
            { dx: -10, dy: 50, dir: 'in' },   // R/K
            { dx: 50, dy: 10, dir: 'out' },   // Q
            { dx: 50, dy: 50, dir: 'out' },   // Q'
            { dx: 20, dy: 60, dir: 'in' },    // Reset
            { dx: 20, dy: 0, dir: 'in' }      // Preset
        ];
    }

    function registerPorts() {
        return [
            { dx: -30, dy: 0, dir: 'in' },
            { dx: -20, dy: 20, dir: 'in' },
            { dx: -10, dy: 20, dir: 'in' },
            { dx: -30, dy: 10, dir: 'in' },
            { dx: 0, dy: 0, dir: 'out' }
        ];
    }
    function registerModernPorts() {
        return [
            { dx: 0, dy: 30, dir: 'in' },
            { dx: 0, dy: 70, dir: 'in' },
            { dx: 30, dy: 90, dir: 'in' },
            { dx: 0, dy: 50, dir: 'in' },
            { dx: 60, dy: 30, dir: 'out' }
        ];
    }

    function counterPorts() {
        return [
            { dx: -30, dy: 0, dir: 'in' },
            { dx: -20, dy: 20, dir: 'in' },
            { dx: -10, dy: 20, dir: 'in' },
            { dx: -30, dy: -10, dir: 'in' },
            { dx: -20, dy: -20, dir: 'in' },
            { dx: -30, dy: 10, dir: 'in' },
            { dx: 0, dy: 0, dir: 'out' },
            { dx: 0, dy: 10, dir: 'out' }
        ];
    }

    function adderPortOffsets(facing) {
        return rotatePorts([
            { dx: -40, dy: -10, dir: 'in' },
            { dx: -40, dy: 10, dir: 'in' },
            { dx: 0, dy: 0, dir: 'out' },
            { dx: -20, dy: -20, dir: 'in' },
            { dx: -20, dy: 20, dir: 'out' }
        ], facing);
    }

    // Demux — exact from Demultiplexer.java (2 outputs, EAST facing)
    function demuxPorts(facing, numOutputs) {
        numOutputs = numOutputs || 2;
        if (numOutputs === 2) {
            return rotatePorts([
                { dx: 30, dy: -10, dir: 'out' },  // Y0
                { dx: 30, dy: 10, dir: 'out' },   // Y1
                { dx: 20, dy: 20, dir: 'in' },    // select
                { dx: 0, dy: 0, dir: 'in' }       // data input at loc
            ], facing);
        }
        // N outputs
        var ports = [];
        for (var i = 0; i < numOutputs; i++) {
            ports.push({ dx: 40, dy: -Math.floor(numOutputs / 2) * 10 + i * 10, dir: 'out' });
        }
        ports.push({ dx: 20, dy: Math.floor(numOutputs / 2) * 10 + 10, dir: 'in' }); // select
        ports.push({ dx: 0, dy: 0, dir: 'in' }); // data
        return rotatePorts(ports, facing);
    }

    // Decoder — exact from Decoder.java (EAST facing, bottom-left select)
    function decoderPorts(numOutputs, facing) {
        numOutputs = numOutputs || 4;
        if (numOutputs === 2) {
            return rotatePorts([
                { dx: 10, dy: 10, dir: 'out' },
                { dx: 10, dy: 30, dir: 'out' },
                { dx: 0, dy: 0, dir: 'in' }
            ], facing);
        }
        var ports = [];
        for (var i = 0; i < numOutputs; i++) {
            ports.push({ dx: 20, dy: i * 10, dir: 'out' });
        }
        ports.push({ dx: 0, dy: 0, dir: 'in' }); // select
        return rotatePorts(ports, facing);
    }

    // MUX — exact from Multiplexer.java (2 inputs, EAST, wide)
    function muxPorts(facing, numInputs) {
        numInputs = numInputs || 2;
        if (numInputs === 2) {
            return rotatePorts([
                { dx: -30, dy: -10, dir: 'in' },  // D0
                { dx: -30, dy: 10, dir: 'in' },   // D1
                { dx: -20, dy: 20, dir: 'in' },   // select
                { dx: 0, dy: 0, dir: 'out' }      // Y
            ], facing);
        }
        var ports = [];
        for (var i = 0; i < numInputs; i++) {
            ports.push({ dx: -40, dy: -Math.floor(numInputs / 2) * 10 + i * 10, dir: 'in' });
        }
        ports.push({ dx: -20, dy: Math.floor(numInputs / 2) * 10 + 10, dir: 'in' }); // select
        ports.push({ dx: 0, dy: 0, dir: 'out' });
        return rotatePorts(ports, facing);
    }

    function comparatorPorts(facing) {
        return rotatePorts([
            { dx: -40, dy: -10, dir: 'in' },
            { dx: -40, dy: 10, dir: 'in' },
            { dx: 0, dy: -10, dir: 'out' },
            { dx: 0, dy: 0, dir: 'out' },
            { dx: 0, dy: 10, dir: 'out' }
        ], facing);
    }

    // Splitter — exact from SplitterParameters.java
    function splitterPorts(fanout, facing, spacing) {
        var gap = (spacing || 1) * 10;  // default spacing=1 → 10px
        var width = 20;                 // spine length
        var ports = [];

        // Combined bus port at (0,0)
        ports.push({ dx: 0, dy: 0, dir: 'inout' });

        // Split ports — position depends on facing
        // Default: EAST facing, center justify
        var dxEnd0, dyEnd0, ddxEnd, ddyEnd;

        if (facing === 'north' || facing === 'south') {
            var m = (facing === 'north') ? 1 : -1;
            dxEnd0 = gap * Math.floor((fanout + 1) / 2 - 1);
            dyEnd0 = -m * width;
            ddxEnd = -gap;
            ddyEnd = 0;
        } else {
            // east or west
            var m = (facing === 'west') ? -1 : 1;
            dxEnd0 = m * width;
            dyEnd0 = -gap * Math.floor(fanout / 2);
            ddxEnd = 0;
            ddyEnd = gap;
        }

        for (var i = 0; i < fanout; i++) {
            ports.push({
                dx: dxEnd0 + i * ddxEnd,
                dy: dyEnd0 + i * ddyEnd,
                dir: 'inout'
            });
        }

        return ports;  // Don't rotatePorts — facing already accounted for
    }

    // Logisim rotation: base offsets are for EAST facing.
    // WEST: mirror X only (dx → -dx, dy stays)
    // NORTH: rotate 90° CCW (dx→dy, dy→-dx)
    // SOUTH: rotate 90° CW (dx→-dy, dy→dx)
    function rotatePorts(ports, facing) {
        if (!facing || facing === 'east') return ports;
        return ports.map(function(p) {
            var dx = p.dx, dy = p.dy;
            switch (facing) {
                case 'west':  return { dx: -dx, dy: dy, dir: p.dir };
                case 'north': return { dx: dy, dy: -dx, dir: p.dir };
                case 'south': return { dx: -dy, dy: dx, dir: p.dir };
                default: return p;
            }
        });
    }

    // ── XML Helpers ──

    function parseLoc(locStr) {
        var m = locStr.match(/\((-?\d+),\s*(-?\d+)\)/);
        return m ? { x: parseInt(m[1]), y: parseInt(m[2]) } : null;
    }

    function getAttr(compEl, name) {
        var attrs = compEl.querySelectorAll('a');
        for (var i = 0; i < attrs.length; i++) {
            if (attrs[i].getAttribute('name') === name) return attrs[i].getAttribute('val');
        }
        return null;
    }

    function pointKey(x, y) { return x + ',' + y; }

    // ── Port index remapping: Logisim port order → our port order ──
    // Logisim and our simulator have different port orderings for some components.
    // Key: component type. Value: array where remap[logisimIdx] = ourIdx.
    // Only listed for types where the order differs; unlisted types are identity mapped.
    var PORT_REMAP = {
        // Logisim SR_FF classic: [0:S, 1:R, 2:CLK, 3:Q, 4:Q', 5:Reset, 6:Preset]
        // Our SR_FF:             [0:S, 1:CLK, 2:R, 3:Q, 4:Q']
        'SR_FF': [0, 2, 1, 3, 4, -1, -1],

        // Logisim JK_FF classic: [0:J, 1:K, 2:CLK, 3:Q, 4:Q', 5:Reset, 6:Preset]
        // Our JK_FF:             [0:J, 1:CLK, 2:K, 3:Q, 4:Q']
        'JK_FF': [0, 2, 1, 3, 4, -1, -1],

        // Logisim D_FF classic: [0:D, 1:CLK, 2:Q, 3:Q', 4:Reset, 5:Preset]
        // Our D_FF:             [0:D, 1:CLK, 2:CLR, 3:Q, 4:Q']
        'D_FF': [0, 1, 3, 4, 2, -1],

        // Logisim T_FF classic: [0:T, 1:CLK, 2:Q, 3:Q', 4:Reset, 5:Preset]
        // Our T_FF:             [0:T, 1:CLK, 2:Q, 3:Q']
        'T_FF': [0, 1, 2, 3, -1, -1],

        // Logisim Register classic: [0:Q, 1:D, 2:CLK, 3:CLR, 4:EN]
        // Our REGISTER:             [0:D0, 1:D1, 2:D2, 3:D3, 4:CLK, 5:CLR, 6:Q0, 7:Q1, 8:Q2, 9:Q3]
        // NOTE: Logisim register is multi-bit on single port; ours has per-bit ports.
        // Simple remap won't work — this needs special handling. For now, identity.

        // Logisim Counter classic: [0:Q, 1:D, 2:CLK, 3:CLR, 4:LD, 5:UD, 6:EN, 7:CARRY]
        // Our COUNTER:             [0:CLK, 1:EN, 2:CLR, 3:Q0, 4:Q1, 5:Q2, 6:Q3, 7:OVF]
        // Multi-bit mismatch — identity for now.

        // Logisim Adder: [0:A, 1:B, 2:Sum, 3:Cin, 4:Cout]
        // Our ADDER:     [0:A, 1:B, 2:Cin, 3:S, 4:Cout]
        'ADDER': [0, 1, 3, 2, 4],

        // Same layout as Adder
        'SUBTRACTOR': [0, 1, 3, 2, 4],

        // Logisim Demux (2-out): [0:Y0, 1:Y1, 2:SEL, 3:Data]
        // Our DEMUX:             [0:D, 1:SEL, 2:Y0, 3:Y1]
        'DEMUX': [2, 3, 1, 0],

        // Logisim MUX (2-in): [0:D0, 1:D1, 2:SEL, 3:Y]
        // Our MUX:            [0:D0, 1:D1, 2:SEL, 3:Y]
        // Same — no remap needed
    };

    function remapPort(type, logisimPortIdx) {
        var remap = PORT_REMAP[type];
        if (!remap) return logisimPortIdx;
        if (logisimPortIdx >= remap.length) return -1;
        return remap[logisimPortIdx];
    }

    // ── Main Parser ──

    function parseCircuit(xmlStr) {
        var parser = new DOMParser();
        var doc = parser.parseFromString(xmlStr, 'text/xml');

        // Gap 7: Support multiple circuits — parse all, flatten
        var circuitEls = doc.querySelectorAll('circuit');
        if (!circuitEls.length) return { error: 'No <circuit> element found' };

        var mainName = doc.querySelector('main');
        var mainCircuitName = mainName ? mainName.getAttribute('name') : null;

        var allComponents = [];
        var allWires = [];
        var allTunnels = {};
        var totalLogisimComps = 0;
        var totalLogisimWires = 0;
        var warnings = [];

        for (var ci = 0; ci < circuitEls.length; ci++) {
            var result = parseOneCircuit(circuitEls[ci], allComponents.length);
            totalLogisimComps += result.totalComps;
            totalLogisimWires += result.totalWires;

            // Offset subcircuit components to avoid overlap
            if (ci > 0) {
                var offsetX = ci * 400;
                result.components.forEach(function(c) { c.x += offsetX; });
            }

            allComponents = allComponents.concat(result.components);
            allWires = allWires.concat(result.wires);
            warnings = warnings.concat(result.warnings);

            // Merge tunnel groups
            Object.keys(result.tunnels).forEach(function(label) {
                if (!allTunnels[label]) allTunnels[label] = [];
                allTunnels[label] = allTunnels[label].concat(result.tunnels[label]);
            });
        }

        return {
            name: mainCircuitName || circuitEls[0].getAttribute('name') || 'Imported Circuit',
            description: 'Imported from Logisim Evolution (' + circuitEls.length + ' circuit' + (circuitEls.length > 1 ? 's' : '') + ')',
            components: allComponents,
            wires: allWires,
            warnings: warnings,
            stats: {
                totalLogisimComponents: totalLogisimComps,
                mappedComponents: allComponents.length,
                totalLogisimWires: totalLogisimWires,
                resolvedWires: allWires.length,
                tunnelGroups: Object.keys(allTunnels).length,
                circuits: circuitEls.length
            }
        };
    }

    function parseOneCircuit(circuitEl, compIndexOffset) {
        var components = [];
        var tunnels = {};
        var warnings = [];
        var portMap = [];

        var compEls = circuitEl.querySelectorAll('comp');

        for (var i = 0; i < compEls.length; i++) {
            var el = compEls[i];
            var name = el.getAttribute('name');
            var loc = parseLoc(el.getAttribute('loc'));
            if (!loc) continue;

            var facing = getAttr(el, 'facing') || 'east';
            var appearance = getAttr(el, 'appearance') || 'classic';
            var isModern = (appearance === 'logisim_evolution');
            var mapFn = TYPE_MAP[name];

            if (!mapFn) {
                warnings.push('Unsupported: ' + name + ' at ' + el.getAttribute('loc'));
                portMap.push(null);
                continue;
            }

            var isOutputPin = getAttr(el, 'type') === 'output';
            var type = mapFn({ type: getAttr(el, 'type') });

            // Pull Resistor — now a real component
            // (no special handling needed — falls through to normal component creation)

            // Skip unsupported
            if (type === '_SKIP') {
                warnings.push('Skipped: ' + name + ' at ' + el.getAttribute('loc'));
                portMap.push(null);
                continue;
            }

            // Splitter → real SPLITTER component
            if (type === '_SPLITTER') {
                var fanout = parseInt(getAttr(el, 'fanout')) || 2;
                var splitterSpacingVal = parseInt(getAttr(el, 'spacing')) || 1;

                // Create real SPLITTER component
                var splComp = {
                    type: 'SPLITTER',
                    x: Math.round(loc.x * 0.6),
                    y: Math.round(loc.y * 0.6),
                    attrs: { fanout: fanout, mode: 'out' }
                };
                var splCompIdx = components.length;
                components.push(splComp);

                // Compute Logisim port positions for spatial matching
                var splitterPortList = splitterPorts(fanout, facing, splitterSpacingVal);
                var absSplitter = splitterPortList.map(function(p) {
                    return { x: loc.x + p.dx, y: loc.y + p.dy, dir: p.dir };
                });
                // Port 0 = combined (input in our fan-out mode)
                // Ports 1..N = split outputs
                // Override directions: combined = 'in', splits = 'out'
                if (absSplitter.length > 0) absSplitter[0].dir = 'in';
                for (var si = 1; si < absSplitter.length; si++) absSplitter[si].dir = 'out';

                portMap.push({ idx: splCompIdx + compIndexOffset, ports: absSplitter, compType: 'SPLITTER' });
                continue;
            }

            var compAttrs = {};
            var numInputs = parseInt(getAttr(el, 'inputs')) || 2;
            var gateSize = parseInt(getAttr(el, 'size')) || 30;
            var splitterSpacing = parseInt(getAttr(el, 'spacing')) || 1;

            // Gate input count
            if (type === 'AND' || type === 'OR' || type === 'NAND' || type === 'NOR' || type === 'XOR' || type === 'XNOR') {
                if (numInputs !== 2) compAttrs.inputs = numInputs;
            }

            // Labels
            if (type === 'INPUT' || type === 'OUTPUT') {
                var label = getAttr(el, 'label');
                if (label) compAttrs.label = label;
            }

            // Tunnels
            if (type === 'TUNNEL') {
                var tunnelLabel = getAttr(el, 'label') || '';
                // Logisim tunnels are bidirectional — we mark as '_TUNNEL_PENDING'
                // and resolve to SRC or TGT in a second pass after wire analysis.
                type = '_TUNNEL_PENDING';
                compAttrs.label = tunnelLabel;
                if (!tunnels[tunnelLabel]) tunnels[tunnelLabel] = [];
            }

            // Constants
            if (type === 'CONSTANT') {
                compAttrs.value = parseInt(getAttr(el, 'value')) || 0;
            }

            // Clock
            if (type === 'CLOCK') {
                compAttrs.state = 0;
                var highDur = parseInt(getAttr(el, 'highDuration')) || 1;
                var lowDur = parseInt(getAttr(el, 'lowDuration')) || 1;
                compAttrs.period = (highDur + lowDur) * 250;
            }

            // LED color
            if (type === 'LED') {
                var color = getAttr(el, 'color');
                compAttrs.color = color || '#22c55e';
            }

            // Text label
            if (type === 'TEXT_LABEL') {
                compAttrs.text = getAttr(el, 'text') || 'Label';
            }

            // Gap 5: TTL components — pass through, no special attrs needed
            // (TTL_7400 etc. are already in our ALL_TYPES registry)

            var comp = {
                type: type,
                x: Math.round(loc.x * 0.6),
                y: Math.round(loc.y * 0.6),
                attrs: compAttrs
            };

            var compIdx = components.length;
            components.push(comp);

            // Gap 2: Modern appearance flip-flops
            var portOffsets = getPortOffsets(type, numInputs, facing, isOutputPin, isModern, gateSize);
            var absPorts = portOffsets.map(function(p) {
                return { x: loc.x + p.dx, y: loc.y + p.dy, dir: p.dir };
            });
            portMap.push({ idx: compIdx + compIndexOffset, ports: absPorts, compType: type });

            // Track tunnels
            if (type === 'TUNNEL_SRC' || type === 'TUNNEL_TGT' || type === '_TUNNEL_PENDING') {
                tunnels[compAttrs.label].push({
                    compIdx: compIdx + compIndexOffset,
                    localIdx: compIdx,
                    portIdx: 0,
                    type: type
                });
            }
        }

        // ── Parse wires ──
        var wireEls = circuitEl.querySelectorAll('wire');
        var rawWires = [];
        for (var w = 0; w < wireEls.length; w++) {
            var from = parseLoc(wireEls[w].getAttribute('from'));
            var to = parseLoc(wireEls[w].getAttribute('to'));
            if (from && to) rawWires.push({ from: from, to: to });
        }

        // ── Build spatial index ──
        var pointIndex = {};

        for (var c = 0; c < portMap.length; c++) {
            if (!portMap[c]) continue;
            var pm = portMap[c];
            for (var p = 0; p < pm.ports.length; p++) {
                var pt = pm.ports[p];
                var key = pointKey(pt.x, pt.y);
                if (!pointIndex[key]) pointIndex[key] = [];

                if (pt.dir === 'inout') {
                    // Bidirectional (tunnels) — register as both directions
                    pointIndex[key].push({ compIdx: pm.idx, portIdx: p, dir: 'out', type: pm.compType || '' });
                    pointIndex[key].push({ compIdx: pm.idx, portIdx: p, dir: 'in', type: pm.compType || '' });
                } else {
                    pointIndex[key].push({ compIdx: pm.idx, portIdx: p, dir: pt.dir, type: pm.compType || '' });
                }
            }
        }

        // ── Fuzzy matching: connect wire endpoints near (±5px) port positions ──
        var FUZZ = 5;
        for (var rw2 = 0; rw2 < rawWires.length; rw2++) {
            var pts = [rawWires[rw2].from, rawWires[rw2].to];
            for (var pi2 = 0; pi2 < pts.length; pi2++) {
                var wp = pts[pi2];
                var wpKey = pointKey(wp.x, wp.y);
                // If this wire point is already in pointIndex, skip
                if (pointIndex[wpKey]) continue;
                // Search nearby for a port
                for (var fx = -FUZZ; fx <= FUZZ; fx++) {
                    for (var fy = -FUZZ; fy <= FUZZ; fy++) {
                        if (fx === 0 && fy === 0) continue;
                        var nearKey = pointKey(wp.x + fx, wp.y + fy);
                        if (pointIndex[nearKey]) {
                            // Found a nearby port — link this wire point to it
                            if (!pointIndex[wpKey]) pointIndex[wpKey] = [];
                            pointIndex[nearKey].forEach(function(pinfo) {
                                pointIndex[wpKey].push(pinfo);
                            });
                            fx = FUZZ + 1; // break outer
                            break;
                        }
                    }
                }
            }
        }

        // ── BFS net tracing ──
        var adj = {};
        for (var rw = 0; rw < rawWires.length; rw++) {
            var fk = pointKey(rawWires[rw].from.x, rawWires[rw].from.y);
            var tk = pointKey(rawWires[rw].to.x, rawWires[rw].to.y);
            if (!adj[fk]) adj[fk] = [];
            if (!adj[tk]) adj[tk] = [];
            adj[fk].push(tk);
            adj[tk].push(fk);
        }

        var allPoints = {};
        Object.keys(pointIndex).forEach(function(k) { allPoints[k] = true; });
        Object.keys(adj).forEach(function(k) { allPoints[k] = true; });

        var visited = {};
        var nets = [];

        Object.keys(allPoints).forEach(function(startKey) {
            if (visited[startKey]) return;
            var net = [];
            var queue = [startKey];
            var netVisited = {};

            while (queue.length > 0) {
                var curr = queue.shift();
                if (netVisited[curr]) continue;
                netVisited[curr] = true;
                visited[curr] = true;

                if (pointIndex[curr]) {
                    pointIndex[curr].forEach(function(pinfo) {
                        net.push(pinfo);
                    });
                }
                if (adj[curr]) {
                    adj[curr].forEach(function(neighbor) {
                        if (!netVisited[neighbor]) queue.push(neighbor);
                    });
                }
            }
            if (net.length >= 2) nets.push(net);
        });

        // ── Convert nets to wires ──
        var resultWires = [];

        nets.forEach(function(net) {
            var outputs = net.filter(function(p) { return p.dir === 'out'; });
            var inputs = net.filter(function(p) { return p.dir === 'in'; });

            outputs.forEach(function(out) {
                inputs.forEach(function(inp) {
                    if (out.compIdx >= 0 && inp.compIdx >= 0) {
                        var fromP = remapPort(out.type, out.portIdx);
                        var toP = remapPort(inp.type, inp.portIdx);
                        if (fromP >= 0 && toP >= 0) {
                            resultWires.push({
                                from: out.compIdx,
                                fromPort: fromP,
                                to: inp.compIdx,
                                toPort: toP
                            });
                        }
                    }
                });
            });
        });

        // ── Resolve pending tunnels: determine SRC vs TGT ──
        // Check each net: if a tunnel port shares a net with an 'out' port from a real component,
        // the tunnel is receiving → SRC. Otherwise → TGT.
        // For each label group, if some are SRC and some undetermined, make the rest TGT.
        Object.keys(tunnels).forEach(function(label) {
            var group = tunnels[label];
            var hasSrc = false, hasTgt = false;

            group.forEach(function(t) {
                if (t.type !== '_TUNNEL_PENDING') return;

                // Find which net this tunnel is on
                var tunnelOnNet = null;
                for (var ni = 0; ni < nets.length; ni++) {
                    for (var pi = 0; pi < nets[ni].length; pi++) {
                        if (nets[ni][pi].compIdx === t.compIdx) {
                            tunnelOnNet = nets[ni];
                            break;
                        }
                    }
                    if (tunnelOnNet) break;
                }

                if (tunnelOnNet) {
                    // If net has a non-tunnel output port → this tunnel receives → SRC
                    var hasExternalOutput = tunnelOnNet.some(function(p) {
                        return p.dir === 'out' && p.compIdx !== t.compIdx && p.type !== '_TUNNEL_PENDING';
                    });
                    if (hasExternalOutput) {
                        t.type = 'TUNNEL_SRC';
                        hasSrc = true;
                    }
                }
            });

            // Remaining unresolved tunnels with same label → TGT (they emit the signal)
            group.forEach(function(t) {
                if (t.type === '_TUNNEL_PENDING') {
                    t.type = hasSrc ? 'TUNNEL_TGT' : 'TUNNEL_TGT'; // default to TGT
                    hasTgt = true;
                }
            });

            // Update component types
            group.forEach(function(t) {
                if (t.localIdx !== undefined && components[t.localIdx]) {
                    components[t.localIdx].type = t.type;
                    components[t.localIdx].attrs.name = components[t.localIdx].attrs.label;
                }
            });
        });

        return {
            components: components,
            wires: resultWires,
            tunnels: tunnels,
            warnings: warnings,
            totalComps: compEls.length,
            totalWires: rawWires.length
        };
    }

    function getPortOffsets(type, numInputs, facing, isOutputPin, isModern, gateSize) {
        switch (type) {
            case 'AND': case 'OR': case 'NAND': case 'NOR': case 'XOR': case 'XNOR':
                return gatePortOffsets(numInputs, facing, gateSize, type);
            case 'NOT': case 'BUFFER':
                return notPortOffsets(facing, gateSize);
            case 'INPUT':
                return pinPortOffsets(false, facing);
            case 'OUTPUT':
                return pinPortOffsets(true, facing);
            case 'CLOCK':
                return clockPortOffsets(facing);
            case 'CONSTANT':
                return [{ dx: 0, dy: 0, dir: 'out' }];
            case 'PULL_RESISTOR':
                return [{ dx: 0, dy: 0, dir: 'out' }];
            case 'BUTTON': case 'SWITCH':
                return [{ dx: 0, dy: 0, dir: 'out' }];
            case 'LED':
                return [{ dx: 0, dy: 0, dir: 'in' }];
            case 'PROBE':
                return [{ dx: 0, dy: 0, dir: 'in' }];
            case 'TUNNEL_SRC':
                return [{ dx: 0, dy: 0, dir: 'in' }];
            case 'TUNNEL_TGT':
                return [{ dx: 0, dy: 0, dir: 'out' }];
            case '_TUNNEL_PENDING':
                // Bidirectional — register as both so nets can connect through
                return [{ dx: 0, dy: 0, dir: 'inout' }];
            // Gap 2: Modern vs classic flip-flop appearance
            case 'SR_FF': case 'JK_FF':
                return isModern ? ffModernPorts_2ctrl() : ffPortOffsets_2ctrl();
            case 'D_FF': case 'T_FF':
                return isModern ? ffModernPorts_1ctrl() : ffPortOffsets_1ctrl();
            case 'REGISTER':
                return isModern ? registerModernPorts() : registerPorts();
            case 'COUNTER':
                return counterPorts();
            case 'ADDER': case 'SUBTRACTOR':
                return adderPortOffsets(facing);
            case 'COMPARATOR':
                return comparatorPorts(facing);
            case 'MUX':
                return muxPorts(facing);
            case 'DEMUX':
                return demuxPorts(facing);
            case 'DECODER':
                return decoderPorts(4, facing);
            case 'SEVEN_SEG':
                return (function() {
                    var ports = [];
                    for (var i = 0; i < 7; i++) ports.push({ dx: -20, dy: -30 + i * 10, dir: 'in' });
                    return ports;
                })();
            case 'HEX_DISPLAY':
                return (function() {
                    var ports = [];
                    for (var i = 0; i < 4; i++) ports.push({ dx: -20, dy: -15 + i * 10, dir: 'in' });
                    return ports;
                })();
            // Gap 5: TTL ICs — DIP package, 14 pins
            case 'TTL_7400': case 'TTL_7402': case 'TTL_7404':
            case 'TTL_7408': case 'TTL_7432': case 'TTL_7486':
            case 'TTL_7474': case 'TTL_7447': case 'TTL_74138':
                return ttlDipPorts(14, facing);
            case 'BCD_7SEG_DECODER':
                // 4 inputs (D0-D3) left, 7 outputs (a-g) right
                return (function() {
                    var ports = [];
                    for (var i = 0; i < 4; i++) ports.push({ dx: -24, dy: -15 + i * 10, dir: 'in' });
                    for (var j = 0; j < 7; j++) ports.push({ dx: 24, dy: -30 + j * 10, dir: 'out' });
                    return ports;
                })();
            case 'TEXT_LABEL':
                return [];  // no ports
            default:
                return [{ dx: 0, dy: 0, dir: 'out' }];
        }
    }

    // TTL DIP package — pins on left and right edges
    function ttlDipPorts(numPins, facing) {
        var half = numPins / 2;
        var gap = 10;
        var ports = [];
        for (var i = 0; i < half; i++) {
            ports.push({ dx: -20, dy: i * gap, dir: 'inout' });  // left pins (1-7)
        }
        for (var j = half - 1; j >= 0; j--) {
            ports.push({ dx: 20, dy: j * gap, dir: 'inout' });   // right pins (8-14)
        }
        return rotatePorts(ports, facing);
    }

    // ── Public API ──
    L.LogisimImport = {
        parse: parseCircuit
    };

})(window.LogicSim || (window.LogicSim = {}));
