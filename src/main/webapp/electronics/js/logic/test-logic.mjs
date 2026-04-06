/* ═══════════════════════════════════════════════════════════
   Logic Simulator — Phase 1 + Phase 2 Tests
   Run: node test-logic.mjs
   ═══════════════════════════════════════════════════════════ */

// Minimal DOM stub for Node.js (components reference document.createElementNS)
const _elStub = {
  setAttribute() {}, getAttribute() { return ''; },
  classList: { add() {}, remove() {} },
  appendChild() {}, insertBefore() {}, remove() {},
  set textContent(v) {}, get textContent() { return ''; },
  set innerHTML(v) {}, get innerHTML() { return ''; },
  dataset: {},
  style: {},
  firstChild: null,
  getBoundingClientRect() { return { left: 0, top: 0, width: 800, height: 600 }; }
};
globalThis.document = {
  createElementNS() { return { ..._elStub, dataset: {} }; },
  createElement() { return { ..._elStub, dataset: {} }; },
  addEventListener() {},
  getElementById() { return _elStub; },
  querySelectorAll() { return []; }
};
globalThis.window = globalThis;
globalThis.requestAnimationFrame = fn => fn();

// Load modules (they attach to window.LogicSim)
await import('./core/value.js');
await import('./core/circuit.js');
await import('./components/gates.js');
await import('./components/pin.js');
await import('./components/clock.js');
await import('./components/wiring.js');
await import('./components/io.js');
await import('./components/memory.js');
await import('./components/arithmetic.js');
await import('./components/displays.js');
await import('./analysis/analyzer.js');
await import('./analysis/synthesize.js');
await import('./analysis/chronogram.js');
await import('./core/project.js');
await import('./core/history.js');
await import('./presets.js');
await import('./io/file-io.js');
await import('./components/ttl/ttl.js');

const L = globalThis.LogicSim;
const { Value, FALSE, TRUE, UNKNOWN, ERROR, Logic, Circuit,
        GATE_TYPES, PIN_TYPES, CLOCK_TYPE, WIRING_TYPES, IO_TYPES,
        MEMORY_TYPES, ARITH_TYPES, DISPLAY_TYPES } = L;

let pass = 0, fail = 0;
function assert(cond, msg) {
  if (cond) { pass++; }
  else { fail++; console.error('  FAIL:', msg); }
}
function section(name) { console.log('\n' + name); }

/* ════════════════ Value System ════════════════ */
section('Value System');

assert(Value.of(FALSE).isFalse(), 'Value.of(FALSE) is false');
assert(Value.of(TRUE).isTrue(), 'Value.of(TRUE) is true');
assert(Value.of(FALSE).toString() === '0', 'FALSE.toString() = "0"');
assert(Value.of(TRUE).toString() === '1', 'TRUE.toString() = "1"');
assert(Value.of(UNKNOWN).toString() === 'X', 'UNKNOWN.toString() = "X"');
assert(Value.of(ERROR).toString() === 'E', 'ERROR.toString() = "E"');

// Multi-bit
const v5 = Value.fromInt(4, 5); // 0101
assert(v5.toString() === '0101', '4-bit 5 = "0101"');
assert(v5.toInt() === 5, '4-bit 5 toInt() = 5');
assert(v5.get(0) === TRUE, 'bit 0 of 5 = TRUE');
assert(v5.get(1) === FALSE, 'bit 1 of 5 = FALSE');
assert(v5.get(2) === TRUE, 'bit 2 of 5 = TRUE');

// Equality
assert(Value.of(TRUE).equals(Value.of(TRUE)), 'TRUE equals TRUE');
assert(!Value.of(TRUE).equals(Value.of(FALSE)), 'TRUE !equals FALSE');
assert(Value.unknown(4).toString() === 'XXXX', 'unknown(4) = "XXXX"');

/* ════════════════ Logic Operations ════════════════ */
section('Logic Operations (single-bit)');

// AND truth table
assert(Logic.and(FALSE, FALSE) === FALSE, '0 AND 0 = 0');
assert(Logic.and(FALSE, TRUE)  === FALSE, '0 AND 1 = 0');
assert(Logic.and(TRUE,  FALSE) === FALSE, '1 AND 0 = 0');
assert(Logic.and(TRUE,  TRUE)  === TRUE,  '1 AND 1 = 1');
assert(Logic.and(UNKNOWN, TRUE) === UNKNOWN, 'X AND 1 = X');
assert(Logic.and(FALSE, UNKNOWN) === FALSE, '0 AND X = 0');  // dominant 0

// OR truth table
assert(Logic.or(FALSE, FALSE) === FALSE, '0 OR 0 = 0');
assert(Logic.or(FALSE, TRUE)  === TRUE,  '0 OR 1 = 1');
assert(Logic.or(TRUE,  FALSE) === TRUE,  '1 OR 0 = 1');
assert(Logic.or(TRUE,  TRUE)  === TRUE,  '1 OR 1 = 1');
assert(Logic.or(TRUE, UNKNOWN) === TRUE, '1 OR X = 1');  // dominant 1
assert(Logic.or(FALSE, UNKNOWN) === UNKNOWN, '0 OR X = X');

// XOR truth table
assert(Logic.xor(FALSE, FALSE) === FALSE, '0 XOR 0 = 0');
assert(Logic.xor(FALSE, TRUE)  === TRUE,  '0 XOR 1 = 1');
assert(Logic.xor(TRUE,  FALSE) === TRUE,  '1 XOR 0 = 1');
assert(Logic.xor(TRUE,  TRUE)  === FALSE, '1 XOR 1 = 0');
assert(Logic.xor(UNKNOWN, TRUE) === UNKNOWN, 'X XOR 1 = X');

// NOT
assert(Logic.not(FALSE) === TRUE, 'NOT 0 = 1');
assert(Logic.not(TRUE)  === FALSE, 'NOT 1 = 0');
assert(Logic.not(UNKNOWN) === UNKNOWN, 'NOT X = X');
assert(Logic.not(ERROR) === ERROR, 'NOT E = E');

/* ════════════════ Multi-bit Operations ════════════════ */
section('Multi-bit Operations');

const a = Value.fromInt(4, 0b1010);
const b = Value.fromInt(4, 0b1100);
assert(a.and(b).toInt() === 0b1000, '1010 AND 1100 = 1000');
assert(a.or(b).toInt()  === 0b1110, '1010 OR  1100 = 1110');
assert(a.xor(b).toInt() === 0b0110, '1010 XOR 1100 = 0110');
assert(a.not().toInt()   === 0b0101, 'NOT 1010 = 0101');

/* ════════════════ Gate Compute Functions ════════════════ */
section('Gate Compute Functions');

function gateCompute(type, ...bits) {
  const inputs = bits.map(b => Value.of(b));
  return GATE_TYPES[type].compute(inputs, { inputs: bits.length })[0].get(0);
}

// AND gate
assert(gateCompute('AND', FALSE, FALSE) === FALSE, 'AND(0,0) = 0');
assert(gateCompute('AND', TRUE,  TRUE)  === TRUE,  'AND(1,1) = 1');
assert(gateCompute('AND', TRUE,  FALSE) === FALSE, 'AND(1,0) = 0');

// OR gate
assert(gateCompute('OR', FALSE, FALSE) === FALSE, 'OR(0,0) = 0');
assert(gateCompute('OR', TRUE,  FALSE) === TRUE,  'OR(1,0) = 1');

// NOT gate
assert(gateCompute('NOT', TRUE) === FALSE, 'NOT(1) = 0');
assert(gateCompute('NOT', FALSE) === TRUE, 'NOT(0) = 1');

// NAND gate
assert(gateCompute('NAND', TRUE, TRUE) === FALSE, 'NAND(1,1) = 0');
assert(gateCompute('NAND', TRUE, FALSE) === TRUE, 'NAND(1,0) = 1');

// NOR gate
assert(gateCompute('NOR', FALSE, FALSE) === TRUE, 'NOR(0,0) = 1');
assert(gateCompute('NOR', TRUE, FALSE) === FALSE, 'NOR(1,0) = 0');

// XOR gate
assert(gateCompute('XOR', TRUE, FALSE) === TRUE,  'XOR(1,0) = 1');
assert(gateCompute('XOR', TRUE, TRUE)  === FALSE, 'XOR(1,1) = 0');

// XNOR gate
assert(gateCompute('XNOR', TRUE, TRUE) === TRUE,  'XNOR(1,1) = 1');
assert(gateCompute('XNOR', TRUE, FALSE) === FALSE, 'XNOR(1,0) = 0');

// 3-input AND
assert(gateCompute('AND', TRUE, TRUE, TRUE) === TRUE, 'AND(1,1,1) = 1');
assert(gateCompute('AND', TRUE, TRUE, FALSE) === FALSE, 'AND(1,1,0) = 0');

// 3-input XOR (odd parity)
assert(gateCompute('XOR', TRUE, TRUE, TRUE) === TRUE, 'XOR(1,1,1) = 1 (odd parity)');
assert(gateCompute('XOR', TRUE, TRUE, FALSE) === FALSE, 'XOR(1,1,0) = 0');

/* ════════════════ Circuit + Propagation ════════════════ */
section('Circuit + Propagation');

const circuit = new Circuit();

// Build: A(input) → AND → Q(output)
//        B(input) →↗
const inA  = circuit.addComponent(PIN_TYPES.INPUT,  -100, -30, { label: 'A', state: FALSE });
const inB  = circuit.addComponent(PIN_TYPES.INPUT,  -100,  30, { label: 'B', state: FALSE });
const gate = circuit.addComponent(GATE_TYPES.AND,      0,   0);
const outQ = circuit.addComponent(PIN_TYPES.OUTPUT,  100,   0, { label: 'Q' });

assert(circuit.components.size === 4, 'Circuit has 4 components');

// Wire: inA.out(0) → gate.in(0)
const w1 = circuit.addWire(inA.id, 0, gate.id, 0);
assert(w1 !== null, 'Wire A→AND created');

// Wire: inB.out(0) → gate.in(1)
const w2 = circuit.addWire(inB.id, 0, gate.id, 1);
assert(w2 !== null, 'Wire B→AND created');

// Wire: gate.out(2) → outQ.in(0)
const w3 = circuit.addWire(gate.id, 2, outQ.id, 0);
assert(w3 !== null, 'Wire AND→Q created');

assert(circuit.wires.size === 3, 'Circuit has 3 wires');

// A=0, B=0 → Q=0
assert(outQ.ports[0].value.isFalse(), 'Q = 0 when A=0, B=0');

// Toggle A to 1
inA.attrs.state = TRUE;
circuit.propagate();
assert(outQ.ports[0].value.isFalse(), 'Q = 0 when A=1, B=0');

// Toggle B to 1
inB.attrs.state = TRUE;
circuit.propagate();
assert(outQ.ports[0].value.isTrue(), 'Q = 1 when A=1, B=1');

// Toggle A back to 0
inA.attrs.state = FALSE;
circuit.propagate();
assert(outQ.ports[0].value.isFalse(), 'Q = 0 when A=0, B=1');

/* ════════════════ Wire direction auto-swap ════════════════ */
section('Wire Direction Auto-Swap');

const circuit2 = new Circuit();
const i1 = circuit2.addComponent(PIN_TYPES.INPUT,  -50, 0, { state: TRUE });
const g2 = circuit2.addComponent(GATE_TYPES.NOT,    50, 0);
// Connect in reverse order: gate input → pin output (should auto-swap)
const wr = circuit2.addWire(g2.id, 0, i1.id, 0);
assert(wr !== null, 'Reverse-direction wire auto-swapped');
assert(wr.fromCompId === i1.id, 'Wire from = input pin (swapped)');

/* ════════════════ Duplicate wire rejection ════════════════ */
section('Duplicate Wire Rejection');

const circuit3 = new Circuit();
const p1 = circuit3.addComponent(PIN_TYPES.INPUT, 0, 0, { state: TRUE });
const p2 = circuit3.addComponent(GATE_TYPES.NOT, 80, 0);
circuit3.addWire(p1.id, 0, p2.id, 0);
const dup = circuit3.addWire(p1.id, 0, p2.id, 0);
assert(dup === null, 'Duplicate wire to same input rejected');

/* ════════════════ Remove component removes wires ════════════════ */
section('Remove Component');

const circuit4 = new Circuit();
const r1 = circuit4.addComponent(PIN_TYPES.INPUT, 0, 0);
const r2 = circuit4.addComponent(GATE_TYPES.NOT, 80, 0);
const r3 = circuit4.addComponent(PIN_TYPES.OUTPUT, 160, 0);
circuit4.addWire(r1.id, 0, r2.id, 0);
circuit4.addWire(r2.id, 1, r3.id, 0);
assert(circuit4.wires.size === 2, '2 wires before remove');
circuit4.removeComponent(r2.id);
assert(circuit4.wires.size === 0, 'Wires removed when component removed');
assert(circuit4.components.size === 2, 'Remaining components: 2');

/* ════════════════ Complex circuit: half adder ════════════════ */
section('Half Adder Circuit');

const ha = new Circuit();
const hA = ha.addComponent(PIN_TYPES.INPUT, -100, -30, { label: 'A', state: FALSE });
const hB = ha.addComponent(PIN_TYPES.INPUT, -100,  30, { label: 'B', state: FALSE });
const xorG = ha.addComponent(GATE_TYPES.XOR, 0, -30);
const andG = ha.addComponent(GATE_TYPES.AND, 0,  30);
const sumQ = ha.addComponent(PIN_TYPES.OUTPUT, 100, -30, { label: 'Sum' });
const carQ = ha.addComponent(PIN_TYPES.OUTPUT, 100,  30, { label: 'Carry' });

ha.addWire(hA.id, 0, xorG.id, 0);
ha.addWire(hB.id, 0, xorG.id, 1);
ha.addWire(hA.id, 0, andG.id, 0);
// NOTE: hA output port already has a wire, but an output can drive multiple inputs
// Actually our model only allows one wire per INPUT port, not per output.
// Let's test: hB → andG input 1
ha.addWire(hB.id, 0, andG.id, 1);
ha.addWire(xorG.id, 2, sumQ.id, 0);
ha.addWire(andG.id, 2, carQ.id, 0);

// A=0, B=0 → Sum=0, Carry=0
assert(sumQ.ports[0].value.isFalse(), 'HA: 0+0 Sum=0');
assert(carQ.ports[0].value.isFalse(), 'HA: 0+0 Carry=0');

// A=1, B=0 → Sum=1, Carry=0
hA.attrs.state = TRUE;
ha.propagate();
assert(sumQ.ports[0].value.isTrue(), 'HA: 1+0 Sum=1');
assert(carQ.ports[0].value.isFalse(), 'HA: 1+0 Carry=0');

// A=0, B=1 → Sum=1, Carry=0
hA.attrs.state = FALSE;
hB.attrs.state = TRUE;
ha.propagate();
assert(sumQ.ports[0].value.isTrue(), 'HA: 0+1 Sum=1');
assert(carQ.ports[0].value.isFalse(), 'HA: 0+1 Carry=0');

// A=1, B=1 → Sum=0, Carry=1
hA.attrs.state = TRUE;
hB.attrs.state = TRUE;
ha.propagate();
assert(sumQ.ports[0].value.isFalse(), 'HA: 1+1 Sum=0');
assert(carQ.ports[0].value.isTrue(), 'HA: 1+1 Carry=1');

/* ════════════════ Unknown propagation ════════════════ */
section('Unknown Propagation');

const cu = new Circuit();
const uIn = cu.addComponent(PIN_TYPES.INPUT, 0, 0, { state: FALSE });
const uAnd = cu.addComponent(GATE_TYPES.AND, 80, 0);
const uOut = cu.addComponent(PIN_TYPES.OUTPUT, 160, 0);
cu.addWire(uIn.id, 0, uAnd.id, 0);
// Input 1 of AND has no wire → value is X
cu.addWire(uAnd.id, 2, uOut.id, 0);

// AND(0, X) = 0 (dominant zero)
assert(uOut.ports[0].value.isFalse(), 'AND(0, X) = 0 (dominant zero)');

// AND(1, X) = X
uIn.attrs.state = TRUE;
cu.propagate();
assert(uOut.ports[0].value.toString() === 'X', 'AND(1, X) = X');

/* ════════════════ Phase 2: Clock ════════════════ */
section('Clock Component');

const clkC = new Circuit();
const clk = clkC.addComponent(CLOCK_TYPE, 0, 0, { state: FALSE, period: 100 });
const clkOut = clkC.addComponent(PIN_TYPES.OUTPUT, 80, 0);
clkC.addWire(clk.id, 0, clkOut.id, 0);
assert(clkOut.ports[0].value.isFalse(), 'Clock initial = 0');

// Manual toggle
clk.attrs.state = TRUE;
clkC.propagate();
assert(clkOut.ports[0].value.isTrue(), 'Clock after toggle = 1');

clk.attrs.state = FALSE;
clkC.propagate();
assert(clkOut.ports[0].value.isFalse(), 'Clock after toggle back = 0');

/* ════════════════ Phase 2: Constant ════════════════ */
section('Constant Component');

const constC = new Circuit();
const c1 = constC.addComponent(WIRING_TYPES.CONSTANT, 0, 0, { value: TRUE });
const cOut = constC.addComponent(PIN_TYPES.OUTPUT, 80, 0);
constC.addWire(c1.id, 0, cOut.id, 0);
assert(cOut.ports[0].value.isTrue(), 'Constant(1) = 1');

c1.attrs.value = FALSE;
constC.propagate();
assert(cOut.ports[0].value.isFalse(), 'Constant(0) = 0');

c1.attrs.value = UNKNOWN;
constC.propagate();
assert(cOut.ports[0].value.toString() === 'X', 'Constant(X) = X');

/* ════════════════ Phase 2: Probe ════════════════ */
section('Probe Component');

const probeC = new Circuit();
const pIn = probeC.addComponent(PIN_TYPES.INPUT, 0, 0, { state: TRUE });
const probe = probeC.addComponent(WIRING_TYPES.PROBE, 80, 0);
probeC.addWire(pIn.id, 0, probe.id, 0);
assert(probe.ports[0].value.isTrue(), 'Probe shows input value = 1');

pIn.attrs.state = FALSE;
probeC.propagate();
assert(probe.ports[0].value.isFalse(), 'Probe shows input value = 0');

/* ════════════════ Phase 2: LED ════════════════ */
section('LED Component');

const ledC = new Circuit();
const ledIn = ledC.addComponent(PIN_TYPES.INPUT, 0, 0, { state: TRUE });
const led = ledC.addComponent(IO_TYPES.LED, 80, 0);
ledC.addWire(ledIn.id, 0, led.id, 0);
assert(led.ports[0].value.isTrue(), 'LED receives HIGH');

ledIn.attrs.state = FALSE;
ledC.propagate();
assert(led.ports[0].value.isFalse(), 'LED receives LOW');

/* ════════════════ Phase 2: Button ════════════════ */
section('Button Component');

const btnC = new Circuit();
const btn = btnC.addComponent(IO_TYPES.BUTTON, 0, 0);
const btnOut = btnC.addComponent(PIN_TYPES.OUTPUT, 80, 0);
btnC.addWire(btn.id, 0, btnOut.id, 0);
assert(btnOut.ports[0].value.isFalse(), 'Button initial = 0');

// Simulate press
IO_TYPES.BUTTON.onMouseDown(btn, btnC);
assert(btnOut.ports[0].value.isTrue(), 'Button pressed = 1');

// Simulate release
IO_TYPES.BUTTON.onMouseUp(btn, btnC);
assert(btnOut.ports[0].value.isFalse(), 'Button released = 0');

/* ════════════════ Phase 2: Switch ════════════════ */
section('Switch Component');

const swC = new Circuit();
const sw = swC.addComponent(IO_TYPES.SWITCH, 0, 0);
const swOut = swC.addComponent(PIN_TYPES.OUTPUT, 80, 0);
swC.addWire(sw.id, 0, swOut.id, 0);
assert(swOut.ports[0].value.isFalse(), 'Switch initial = OFF');

IO_TYPES.SWITCH.onClick(sw, swC);
assert(swOut.ports[0].value.isTrue(), 'Switch toggled = ON');

IO_TYPES.SWITCH.onClick(sw, swC);
assert(swOut.ports[0].value.isFalse(), 'Switch toggled back = OFF');

/* ════════════════ Phase 2: Tunnel ════════════════ */
section('Tunnel (Source → Target)');

const tunC = new Circuit();
const tSrcIn = tunC.addComponent(PIN_TYPES.INPUT, -80, 0, { state: TRUE });
const tSrc = tunC.addComponent(WIRING_TYPES.TUNNEL_SRC, 0, 0, { name: 'X' });
const tTgt = tunC.addComponent(WIRING_TYPES.TUNNEL_TGT, 100, 0, { name: 'X' });
const tTgtOut = tunC.addComponent(PIN_TYPES.OUTPUT, 180, 0);

tunC.addWire(tSrcIn.id, 0, tSrc.id, 0);
tunC.addWire(tTgt.id, 0, tTgtOut.id, 0);

assert(tTgtOut.ports[0].value.isTrue(), 'Tunnel X: source=1 → target=1');

tSrcIn.attrs.state = FALSE;
tunC.propagate();
assert(tTgtOut.ports[0].value.isFalse(), 'Tunnel X: source=0 → target=0');

// Different name should not match
const tTgt2 = tunC.addComponent(WIRING_TYPES.TUNNEL_TGT, 100, 50, { name: 'Y' });
const tTgtOut2 = tunC.addComponent(PIN_TYPES.OUTPUT, 180, 50);
tunC.addWire(tTgt2.id, 0, tTgtOut2.id, 0);
assert(tTgtOut2.ports[0].value.toString() === 'X', 'Tunnel Y: no source → X (unknown)');

/* ════════════════ Phase 2: Tunnel — stale value after source removal ════════════════ */
section('Tunnel: source removal resets target');

const tunR = new Circuit();
const trSrcIn = tunR.addComponent(PIN_TYPES.INPUT, -80, 0, { state: TRUE });
const trSrc = tunR.addComponent(WIRING_TYPES.TUNNEL_SRC, 0, 0, { name: 'Z' });
const trTgt = tunR.addComponent(WIRING_TYPES.TUNNEL_TGT, 100, 0, { name: 'Z' });
const trOut = tunR.addComponent(PIN_TYPES.OUTPUT, 180, 0);
tunR.addWire(trSrcIn.id, 0, trSrc.id, 0);
tunR.addWire(trTgt.id, 0, trOut.id, 0);
assert(trOut.ports[0].value.isTrue(), 'Tunnel Z: source=1 → target=1');

// Remove the source — target should reset to X
tunR.removeComponent(trSrc.id);
assert(trOut.ports[0].value.toString() === 'X', 'Tunnel Z: source removed → target=X');

/* ════════════════ Phase 2: Tunnel — duplicate source conflict ════════════════ */
section('Tunnel: duplicate sources produce ERROR');

const tunD = new Circuit();
const tdIn1 = tunD.addComponent(PIN_TYPES.INPUT, -80, -20, { state: TRUE });
const tdIn2 = tunD.addComponent(PIN_TYPES.INPUT, -80, 20, { state: FALSE });
const tdSrc1 = tunD.addComponent(WIRING_TYPES.TUNNEL_SRC, 0, -20, { name: 'D' });
const tdSrc2 = tunD.addComponent(WIRING_TYPES.TUNNEL_SRC, 0, 20, { name: 'D' });
const tdTgt = tunD.addComponent(WIRING_TYPES.TUNNEL_TGT, 100, 0, { name: 'D' });
const tdOut = tunD.addComponent(PIN_TYPES.OUTPUT, 180, 0);
tunD.addWire(tdIn1.id, 0, tdSrc1.id, 0);
tunD.addWire(tdIn2.id, 0, tdSrc2.id, 0);
tunD.addWire(tdTgt.id, 0, tdOut.id, 0);
assert(tdOut.ports[0].value.toString() === 'E', 'Tunnel D: 2 sources → ERROR');

// Remove one source — conflict resolves
tunD.removeComponent(tdSrc2.id);
assert(tdOut.ports[0].value.isTrue(), 'Tunnel D: 1 source left → value=1');

/* ════════════════ Phase 2: Complex — Clock + NOT = Oscillator ════════════════ */
section('Clock + NOT (feedback test)');

const oscC = new Circuit();
const oscClk = oscC.addComponent(CLOCK_TYPE, 0, 0, { state: FALSE });
const oscNot = oscC.addComponent(GATE_TYPES.NOT, 80, 0);
const oscLed = oscC.addComponent(IO_TYPES.LED, 160, 0);
oscC.addWire(oscClk.id, 0, oscNot.id, 0);
oscC.addWire(oscNot.id, 1, oscLed.id, 0);
// Clock=0 → NOT=1 → LED=1
assert(oscLed.ports[0].value.isTrue(), 'Clock=0 → NOT → LED=1');

oscClk.attrs.state = TRUE;
oscC.propagate();
assert(oscLed.ports[0].value.isFalse(), 'Clock=1 → NOT → LED=0');

/* ════════════════ Phase 2: Switch → AND ════════════════ */
section('Switch → AND Gate');

const saC = new Circuit();
const sa1 = saC.addComponent(IO_TYPES.SWITCH, -80, -20);
const sa2 = saC.addComponent(IO_TYPES.SWITCH, -80, 20);
const saAnd = saC.addComponent(GATE_TYPES.AND, 0, 0);
const saLed = saC.addComponent(IO_TYPES.LED, 80, 0);
saC.addWire(sa1.id, 0, saAnd.id, 0);
saC.addWire(sa2.id, 0, saAnd.id, 1);
saC.addWire(saAnd.id, 2, saLed.id, 0);

assert(saLed.ports[0].value.isFalse(), '2 switches OFF → AND → LED OFF');

IO_TYPES.SWITCH.onClick(sa1, saC);
assert(saLed.ports[0].value.isFalse(), '1 switch ON → AND → LED OFF');

IO_TYPES.SWITCH.onClick(sa2, saC);
assert(saLed.ports[0].value.isTrue(), '2 switches ON → AND → LED ON');

/* ════════════════ Phase 3: D Flip-Flop ════════════════ */
section('D Flip-Flop');

const dffC = new Circuit();
const dffD   = dffC.addComponent(PIN_TYPES.INPUT, -120, -20, { state: TRUE, label: 'D' });
const dffClk = dffC.addComponent(PIN_TYPES.INPUT, -120,   0, { state: FALSE, label: 'CLK' });
const dffClr = dffC.addComponent(PIN_TYPES.INPUT, -120,  20, { state: FALSE, label: 'CLR' });
const dff    = dffC.addComponent(MEMORY_TYPES.D_FF, 0, 0);
const dffQ   = dffC.addComponent(PIN_TYPES.OUTPUT, 120, -10, { label: 'Q' });
const dffQn  = dffC.addComponent(PIN_TYPES.OUTPUT, 120,  10, { label: 'Qn' });

dffC.addWire(dffD.id, 0, dff.id, 0);    // D → D input
dffC.addWire(dffClk.id, 0, dff.id, 1);  // CLK → CLK input
dffC.addWire(dffClr.id, 0, dff.id, 2);  // CLR → CLR input
dffC.addWire(dff.id, 3, dffQ.id, 0);    // Q output
dffC.addWire(dff.id, 4, dffQn.id, 0);   // Q̄ output

// Initial: Q=0 (no clock edge yet)
assert(dffQ.ports[0].value.isFalse(), 'D-FF: initial Q=0');
assert(dffQn.ports[0].value.isTrue(), 'D-FF: initial Q̄=1');

// Rising edge with D=1 → Q=1
dffClk.attrs.state = TRUE;
dffC.propagate();
assert(dffQ.ports[0].value.isTrue(), 'D-FF: D=1, rising edge → Q=1');
assert(dffQn.ports[0].value.isFalse(), 'D-FF: Q̄=0');

// CLK stays HIGH, change D to 0 — Q should NOT change (no new edge)
dffD.attrs.state = FALSE;
dffC.propagate();
assert(dffQ.ports[0].value.isTrue(), 'D-FF: D=0 but no edge → Q holds 1');

// CLK LOW then HIGH again with D=0 → Q=0
dffClk.attrs.state = FALSE;
dffC.propagate();
dffClk.attrs.state = TRUE;
dffC.propagate();
assert(dffQ.ports[0].value.isFalse(), 'D-FF: D=0, new rising edge → Q=0');

// Async clear while CLK stable
dffD.attrs.state = TRUE;
dffClk.attrs.state = FALSE;
dffC.propagate();
dffClk.attrs.state = TRUE;
dffC.propagate();
assert(dffQ.ports[0].value.isTrue(), 'D-FF: D=1 latched → Q=1');

dffClr.attrs.state = TRUE;
dffC.propagate();
assert(dffQ.ports[0].value.isFalse(), 'D-FF: async CLR → Q=0');

/* ════════════════ Phase 3: D-FF CLR release with CLK HIGH — no spurious capture ════════════════ */
section('D-FF: CLR release while CLK HIGH');

const dffR = new Circuit();
const drD   = dffR.addComponent(PIN_TYPES.INPUT, -120, -20, { state: TRUE });
const drClk = dffR.addComponent(PIN_TYPES.INPUT, -120,   0, { state: FALSE });
const drClr = dffR.addComponent(PIN_TYPES.INPUT, -120,  20, { state: FALSE });
const drFF  = dffR.addComponent(MEMORY_TYPES.D_FF, 0, 0);
const drQ   = dffR.addComponent(PIN_TYPES.OUTPUT, 120, 0);
dffR.addWire(drD.id, 0, drFF.id, 0);
dffR.addWire(drClk.id, 0, drFF.id, 1);
dffR.addWire(drClr.id, 0, drFF.id, 2);
dffR.addWire(drFF.id, 3, drQ.id, 0);

// Latch D=1 on rising edge
drClk.attrs.state = TRUE; dffR.propagate();
assert(drQ.ports[0].value.isTrue(), 'D-FF CLR test: Q=1 after latch');

// Assert CLR while CLK is HIGH
drClr.attrs.state = TRUE; dffR.propagate();
assert(drQ.ports[0].value.isFalse(), 'D-FF CLR test: Q=0 during CLR');

// Release CLR while CLK still HIGH — Q must stay 0 (no spurious edge)
drClr.attrs.state = FALSE; dffR.propagate();
assert(drQ.ports[0].value.isFalse(), 'D-FF CLR test: Q=0 after CLR release (no spurious capture)');

/* ════════════════ Phase 3: Counter CLR release — no spurious increment ════════════════ */
section('Counter: CLR release while CLK HIGH');

const ctrR = new Circuit();
const crClk = ctrR.addComponent(PIN_TYPES.INPUT, -80, -16, { state: FALSE });
const crEn  = ctrR.addComponent(PIN_TYPES.INPUT, -80,   0, { state: TRUE });
const crClr = ctrR.addComponent(PIN_TYPES.INPUT, -80,  16, { state: FALSE });
const crCtr = ctrR.addComponent(MEMORY_TYPES.COUNTER, 0, 0);
ctrR.addWire(crClk.id, 0, crCtr.id, 0);
ctrR.addWire(crEn.id, 0, crCtr.id, 1);
ctrR.addWire(crClr.id, 0, crCtr.id, 2);

// Count to 3
crClk.attrs.state = TRUE; ctrR.propagate(); crClk.attrs.state = FALSE; ctrR.propagate();
crClk.attrs.state = TRUE; ctrR.propagate(); crClk.attrs.state = FALSE; ctrR.propagate();
crClk.attrs.state = TRUE; ctrR.propagate(); crClk.attrs.state = FALSE; ctrR.propagate();
assert(crCtr.attrs._val === 3, 'Counter CLR test: count=3');

// CLK goes HIGH, then assert CLR
crClk.attrs.state = TRUE; ctrR.propagate();
assert(crCtr.attrs._val === 4, 'Counter CLR test: count=4');
crClr.attrs.state = TRUE; ctrR.propagate();
assert(crCtr.attrs._val === 0, 'Counter CLR test: cleared to 0');

// Release CLR while CLK still HIGH — must stay 0
crClr.attrs.state = FALSE; ctrR.propagate();
assert(crCtr.attrs._val === 0, 'Counter CLR test: stays 0 after CLR release (no spurious increment)');

/* ════════════════ Phase 3: SR Flip-Flop ════════════════ */
section('SR Flip-Flop');

const srC = new Circuit();
const srS   = srC.addComponent(PIN_TYPES.INPUT, -100, -20, { state: FALSE });
const srClk = srC.addComponent(PIN_TYPES.INPUT, -100,   0, { state: FALSE });
const srR   = srC.addComponent(PIN_TYPES.INPUT, -100,  20, { state: FALSE });
const sr    = srC.addComponent(MEMORY_TYPES.SR_FF, 0, 0);
const srQ   = srC.addComponent(PIN_TYPES.OUTPUT, 100, 0);
srC.addWire(srS.id, 0, sr.id, 0);
srC.addWire(srClk.id, 0, sr.id, 1);
srC.addWire(srR.id, 0, sr.id, 2);
srC.addWire(sr.id, 3, srQ.id, 0);

// Set: S=1, R=0, rising edge → Q=1
srS.attrs.state = TRUE;
srClk.attrs.state = TRUE;
srC.propagate();
assert(srQ.ports[0].value.isTrue(), 'SR-FF: Set → Q=1');

// Reset: S=0, R=1, new edge → Q=0
srS.attrs.state = FALSE;
srR.attrs.state = TRUE;
srClk.attrs.state = FALSE;
srC.propagate();
srClk.attrs.state = TRUE;
srC.propagate();
assert(srQ.ports[0].value.isFalse(), 'SR-FF: Reset → Q=0');

// Invalid: S=1, R=1 → Q=E (error)
srS.attrs.state = TRUE;
srClk.attrs.state = FALSE;
srC.propagate();
srClk.attrs.state = TRUE;
srC.propagate();
assert(srQ.ports[0].value.toString() === 'E', 'SR-FF: S=R=1 → Q=ERROR');

/* ════════════════ Phase 3: JK Flip-Flop ════════════════ */
section('JK Flip-Flop');

const jkC = new Circuit();
const jkJ   = jkC.addComponent(PIN_TYPES.INPUT, -100, -16, { state: FALSE });
const jkClk = jkC.addComponent(PIN_TYPES.INPUT, -100,   0, { state: FALSE });
const jkK   = jkC.addComponent(PIN_TYPES.INPUT, -100,  16, { state: FALSE });
const jk    = jkC.addComponent(MEMORY_TYPES.JK_FF, 0, 0);
const jkQ   = jkC.addComponent(PIN_TYPES.OUTPUT, 100, 0);
jkC.addWire(jkJ.id, 0, jk.id, 0);
jkC.addWire(jkClk.id, 0, jk.id, 1);
jkC.addWire(jkK.id, 0, jk.id, 2);
jkC.addWire(jk.id, 3, jkQ.id, 0);

// J=1,K=0 → Set
jkJ.attrs.state = TRUE;
jkClk.attrs.state = TRUE;
jkC.propagate();
assert(jkQ.ports[0].value.isTrue(), 'JK-FF: J=1,K=0 → Set Q=1');

// J=1,K=1 → Toggle
jkK.attrs.state = TRUE;
jkClk.attrs.state = FALSE; jkC.propagate();
jkClk.attrs.state = TRUE;  jkC.propagate();
assert(jkQ.ports[0].value.isFalse(), 'JK-FF: J=1,K=1 → Toggle Q=0');

// Toggle again
jkClk.attrs.state = FALSE; jkC.propagate();
jkClk.attrs.state = TRUE;  jkC.propagate();
assert(jkQ.ports[0].value.isTrue(), 'JK-FF: Toggle again Q=1');

/* ════════════════ Phase 3: T Flip-Flop ════════════════ */
section('T Flip-Flop');

const tC = new Circuit();
const tT   = tC.addComponent(PIN_TYPES.INPUT, -80, -8, { state: TRUE });
const tClk = tC.addComponent(PIN_TYPES.INPUT, -80,  8, { state: FALSE });
const tf   = tC.addComponent(MEMORY_TYPES.T_FF, 0, 0);
const tQ   = tC.addComponent(PIN_TYPES.OUTPUT, 80, 0);
tC.addWire(tT.id, 0, tf.id, 0);
tC.addWire(tClk.id, 0, tf.id, 1);
tC.addWire(tf.id, 2, tQ.id, 0);

// T=1, first edge → toggle 0→1
tClk.attrs.state = TRUE; tC.propagate();
assert(tQ.ports[0].value.isTrue(), 'T-FF: first toggle → Q=1');

// Second edge → toggle 1→0
tClk.attrs.state = FALSE; tC.propagate();
tClk.attrs.state = TRUE;  tC.propagate();
assert(tQ.ports[0].value.isFalse(), 'T-FF: second toggle → Q=0');

// T=0 → hold
tT.attrs.state = FALSE;
tClk.attrs.state = FALSE; tC.propagate();
tClk.attrs.state = TRUE;  tC.propagate();
assert(tQ.ports[0].value.isFalse(), 'T-FF: T=0, no toggle → Q=0 (hold)');

/* ════════════════ Phase 3: 4-bit Counter ════════════════ */
section('4-bit Counter');

const ctrC = new Circuit();
const ctrClk = ctrC.addComponent(PIN_TYPES.INPUT, -80, -16, { state: FALSE });
const ctrEn  = ctrC.addComponent(PIN_TYPES.INPUT, -80,   0, { state: TRUE });
const ctrClr = ctrC.addComponent(PIN_TYPES.INPUT, -80,  16, { state: FALSE });
const ctr    = ctrC.addComponent(MEMORY_TYPES.COUNTER, 0, 0);
const cQ0    = ctrC.addComponent(PIN_TYPES.OUTPUT, 80, -30);
const cQ1    = ctrC.addComponent(PIN_TYPES.OUTPUT, 80, -10);
const cQ2    = ctrC.addComponent(PIN_TYPES.OUTPUT, 80,  10);
const cQ3    = ctrC.addComponent(PIN_TYPES.OUTPUT, 80,  30);
const cOvf   = ctrC.addComponent(PIN_TYPES.OUTPUT, 80,  50);

ctrC.addWire(ctrClk.id, 0, ctr.id, 0);
ctrC.addWire(ctrEn.id, 0, ctr.id, 1);
ctrC.addWire(ctrClr.id, 0, ctr.id, 2);
ctrC.addWire(ctr.id, 3, cQ0.id, 0);
ctrC.addWire(ctr.id, 4, cQ1.id, 0);
ctrC.addWire(ctr.id, 5, cQ2.id, 0);
ctrC.addWire(ctr.id, 6, cQ3.id, 0);
ctrC.addWire(ctr.id, 7, cOvf.id, 0);

function clockPulse() {
  ctrClk.attrs.state = TRUE;  ctrC.propagate();
  ctrClk.attrs.state = FALSE; ctrC.propagate();
}

// Count 0→1→2→3
assert(ctr.attrs._val === 0, 'Counter initial=0');
clockPulse();
assert(ctr.attrs._val === 1, 'Counter after 1 pulse = 1');
clockPulse();
assert(ctr.attrs._val === 2, 'Counter after 2 pulses = 2');
clockPulse(); clockPulse();
assert(ctr.attrs._val === 4, 'Counter after 4 pulses = 4');

// Count to 15 and check overflow
for (let i = 0; i < 11; i++) clockPulse();
assert(ctr.attrs._val === 15, 'Counter at 15');
assert(cOvf.ports[0].value.isTrue(), 'Counter OVF=1 at 15');

// Wrap to 0
clockPulse();
assert(ctr.attrs._val === 0, 'Counter wraps to 0');
assert(cOvf.ports[0].value.isFalse(), 'Counter OVF=0 after wrap');

// Clear
ctrClr.attrs.state = TRUE; ctrC.propagate();
assert(ctr.attrs._val === 0, 'Counter cleared');
ctrClr.attrs.state = FALSE; ctrC.propagate();

// Disabled (EN=0) — should not count
ctrEn.attrs.state = FALSE;
clockPulse();
assert(ctr.attrs._val === 0, 'Counter disabled → no count');

/* ════════════════ Phase 3: 4-bit Register ════════════════ */
section('4-bit Register');

const regC = new Circuit();
const rD0  = regC.addComponent(PIN_TYPES.INPUT, -100, -40, { state: TRUE });
const rD1  = regC.addComponent(PIN_TYPES.INPUT, -100, -24, { state: FALSE });
const rD2  = regC.addComponent(PIN_TYPES.INPUT, -100,  -8, { state: TRUE });
const rD3  = regC.addComponent(PIN_TYPES.INPUT, -100,   8, { state: FALSE });
const rClk = regC.addComponent(PIN_TYPES.INPUT, -100,  24, { state: FALSE });
const rClr = regC.addComponent(PIN_TYPES.INPUT, -100,  40, { state: FALSE });
const reg  = regC.addComponent(MEMORY_TYPES.REGISTER, 0, 0);
const rQ0  = regC.addComponent(PIN_TYPES.OUTPUT, 100, -24);
const rQ1  = regC.addComponent(PIN_TYPES.OUTPUT, 100,  -8);

regC.addWire(rD0.id, 0, reg.id, 0);
regC.addWire(rD1.id, 0, reg.id, 1);
regC.addWire(rD2.id, 0, reg.id, 2);
regC.addWire(rD3.id, 0, reg.id, 3);
regC.addWire(rClk.id, 0, reg.id, 4);
regC.addWire(rClr.id, 0, reg.id, 5);
regC.addWire(reg.id, 6, rQ0.id, 0);
regC.addWire(reg.id, 7, rQ1.id, 0);

assert(reg.attrs._val === 0, 'Register initial=0');

// Load D=0b0101 = 5 on rising edge
rClk.attrs.state = TRUE; regC.propagate();
assert(reg.attrs._val === 5, 'Register loaded 0101=5');
assert(rQ0.ports[0].value.isTrue(), 'Reg Q0=1 (LSB of 5)');
assert(rQ1.ports[0].value.isFalse(), 'Reg Q1=0');

// Clear
rClr.attrs.state = TRUE; regC.propagate();
assert(reg.attrs._val === 0, 'Register cleared');

/* ════════════════ Phase 4: Full Adder ════════════════ */
section('Full Adder');

function testAdder(a, b, cin, expS, expCout, label) {
  const c = new Circuit();
  const iA = c.addComponent(PIN_TYPES.INPUT, -80, -16, { state: a });
  const iB = c.addComponent(PIN_TYPES.INPUT, -80,   0, { state: b });
  const iC = c.addComponent(PIN_TYPES.INPUT, -80,  16, { state: cin });
  const add = c.addComponent(ARITH_TYPES.ADDER, 0, 0);
  const oS = c.addComponent(PIN_TYPES.OUTPUT, 80, -8);
  const oC = c.addComponent(PIN_TYPES.OUTPUT, 80,  8);
  c.addWire(iA.id, 0, add.id, 0);
  c.addWire(iB.id, 0, add.id, 1);
  c.addWire(iC.id, 0, add.id, 2);
  c.addWire(add.id, 3, oS.id, 0);
  c.addWire(add.id, 4, oC.id, 0);
  assert(oS.ports[0].value.get(0) === expS, 'Adder ' + label + ' S');
  assert(oC.ports[0].value.get(0) === expCout, 'Adder ' + label + ' Cout');
}

testAdder(FALSE, FALSE, FALSE, FALSE, FALSE, '0+0+0');
testAdder(TRUE,  FALSE, FALSE, TRUE,  FALSE, '1+0+0');
testAdder(TRUE,  TRUE,  FALSE, FALSE, TRUE,  '1+1+0');
testAdder(TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  '1+1+1');
testAdder(FALSE, TRUE,  TRUE,  FALSE, TRUE,  '0+1+1');

/* ════════════════ Phase 4: Adder unknown propagation ════════════════ */
section('Adder: unknown input propagation');

{
  const c = new Circuit();
  // A=X (unconnected), B=1, Cin=0
  const iB = c.addComponent(PIN_TYPES.INPUT, -80, 0, { state: TRUE });
  const iC = c.addComponent(PIN_TYPES.INPUT, -80, 16, { state: FALSE });
  const add = c.addComponent(ARITH_TYPES.ADDER, 0, 0);
  const oS = c.addComponent(PIN_TYPES.OUTPUT, 80, -8);
  const oCout = c.addComponent(PIN_TYPES.OUTPUT, 80, 8);
  // Don't wire A — port stays X
  c.addWire(iB.id, 0, add.id, 1);
  c.addWire(iC.id, 0, add.id, 2);
  c.addWire(add.id, 3, oS.id, 0);
  c.addWire(add.id, 4, oCout.id, 0);
  assert(oS.ports[0].value.toString() === 'X', 'Adder: A=X, B=1 → S=X');
  assert(oCout.ports[0].value.toString() === 'X', 'Adder: A=X, B=1 → Cout=X');
}

/* ════════════════ Phase 4: Full Subtractor ════════════════ */
section('Full Subtractor');

function testSub(a, b, bin, expD, expBout, label) {
  const c = new Circuit();
  const iA = c.addComponent(PIN_TYPES.INPUT, -80, -16, { state: a });
  const iB = c.addComponent(PIN_TYPES.INPUT, -80,   0, { state: b });
  const iC = c.addComponent(PIN_TYPES.INPUT, -80,  16, { state: bin });
  const sub = c.addComponent(ARITH_TYPES.SUBTRACTOR, 0, 0);
  const oD = c.addComponent(PIN_TYPES.OUTPUT, 80, -8);
  const oB = c.addComponent(PIN_TYPES.OUTPUT, 80,  8);
  c.addWire(iA.id, 0, sub.id, 0);
  c.addWire(iB.id, 0, sub.id, 1);
  c.addWire(iC.id, 0, sub.id, 2);
  c.addWire(sub.id, 3, oD.id, 0);
  c.addWire(sub.id, 4, oB.id, 0);
  assert(oD.ports[0].value.get(0) === expD, 'Sub ' + label + ' D');
  assert(oB.ports[0].value.get(0) === expBout, 'Sub ' + label + ' Bout');
}

testSub(FALSE, FALSE, FALSE, FALSE, FALSE, '0-0-0');
testSub(TRUE,  FALSE, FALSE, TRUE,  FALSE, '1-0-0');
testSub(FALSE, TRUE,  FALSE, TRUE,  TRUE,  '0-1-0'); // borrow
testSub(TRUE,  TRUE,  FALSE, FALSE, FALSE, '1-1-0');
testSub(FALSE, FALSE, TRUE,  TRUE,  TRUE,  '0-0-1'); // borrow
testSub(TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  '1-1-1'); // borrow

/* ════════════════ Phase 4: Comparator ════════════════ */
section('Comparator');

function testCmp(a, b, expGt, expEq, expLt, label) {
  const c = new Circuit();
  const iA = c.addComponent(PIN_TYPES.INPUT, -80, -8, { state: a });
  const iB = c.addComponent(PIN_TYPES.INPUT, -80,  8, { state: b });
  const cmp = c.addComponent(ARITH_TYPES.COMPARATOR, 0, 0);
  const oGt = c.addComponent(PIN_TYPES.OUTPUT, 80, -16);
  const oEq = c.addComponent(PIN_TYPES.OUTPUT, 80,   0);
  const oLt = c.addComponent(PIN_TYPES.OUTPUT, 80,  16);
  c.addWire(iA.id, 0, cmp.id, 0);
  c.addWire(iB.id, 0, cmp.id, 1);
  c.addWire(cmp.id, 2, oGt.id, 0);
  c.addWire(cmp.id, 3, oEq.id, 0);
  c.addWire(cmp.id, 4, oLt.id, 0);
  assert(oGt.ports[0].value.get(0) === expGt, 'CMP ' + label + ' A>B');
  assert(oEq.ports[0].value.get(0) === expEq, 'CMP ' + label + ' A=B');
  assert(oLt.ports[0].value.get(0) === expLt, 'CMP ' + label + ' A<B');
}

testCmp(FALSE, FALSE, FALSE, TRUE,  FALSE, '0 vs 0');
testCmp(TRUE,  FALSE, TRUE,  FALSE, FALSE, '1 vs 0');
testCmp(FALSE, TRUE,  FALSE, FALSE, TRUE,  '0 vs 1');
testCmp(TRUE,  TRUE,  FALSE, TRUE,  FALSE, '1 vs 1');

/* ════════════════ Phase 4: 2:1 MUX ════════════════ */
section('2:1 MUX');

const muxC = new Circuit();
const mD0  = muxC.addComponent(PIN_TYPES.INPUT, -80, -16, { state: TRUE });
const mD1  = muxC.addComponent(PIN_TYPES.INPUT, -80,   0, { state: FALSE });
const mSel = muxC.addComponent(PIN_TYPES.INPUT, -80,  16, { state: FALSE });
const mux  = muxC.addComponent(ARITH_TYPES.MUX, 0, 0);
const mY   = muxC.addComponent(PIN_TYPES.OUTPUT, 80, 0);
muxC.addWire(mD0.id, 0, mux.id, 0);
muxC.addWire(mD1.id, 0, mux.id, 1);
muxC.addWire(mSel.id, 0, mux.id, 2);
muxC.addWire(mux.id, 3, mY.id, 0);

assert(mY.ports[0].value.isTrue(), 'MUX SEL=0 → D0=1');
mSel.attrs.state = TRUE; muxC.propagate();
assert(mY.ports[0].value.isFalse(), 'MUX SEL=1 → D1=0');
mD1.attrs.state = TRUE; muxC.propagate();
assert(mY.ports[0].value.isTrue(), 'MUX SEL=1, D1=1 → Y=1');

/* ════════════════ Phase 4: 1:2 DEMUX ════════════════ */
section('1:2 DEMUX');

const dxC = new Circuit();
const dxD   = dxC.addComponent(PIN_TYPES.INPUT, -80, -8, { state: TRUE });
const dxSel = dxC.addComponent(PIN_TYPES.INPUT, -80,  8, { state: FALSE });
const dmux  = dxC.addComponent(ARITH_TYPES.DEMUX, 0, 0);
const dxY0  = dxC.addComponent(PIN_TYPES.OUTPUT, 80, -8);
const dxY1  = dxC.addComponent(PIN_TYPES.OUTPUT, 80,  8);
dxC.addWire(dxD.id, 0, dmux.id, 0);
dxC.addWire(dxSel.id, 0, dmux.id, 1);
dxC.addWire(dmux.id, 2, dxY0.id, 0);
dxC.addWire(dmux.id, 3, dxY1.id, 0);

assert(dxY0.ports[0].value.isTrue(), 'DEMUX SEL=0 → Y0=D=1');
assert(dxY1.ports[0].value.isFalse(), 'DEMUX SEL=0 → Y1=0');
dxSel.attrs.state = TRUE; dxC.propagate();
assert(dxY0.ports[0].value.isFalse(), 'DEMUX SEL=1 → Y0=0');
assert(dxY1.ports[0].value.isTrue(), 'DEMUX SEL=1 → Y1=D=1');

/* ════════════════ Phase 4: 2:4 Decoder ════════════════ */
section('2:4 Decoder');

const decC = new Circuit();
const decA0 = decC.addComponent(PIN_TYPES.INPUT, -80, -8, { state: FALSE });
const decA1 = decC.addComponent(PIN_TYPES.INPUT, -80,  8, { state: FALSE });
const dec   = decC.addComponent(ARITH_TYPES.DECODER, 0, 0);
const decY0 = decC.addComponent(PIN_TYPES.OUTPUT, 80, -24);
const decY1 = decC.addComponent(PIN_TYPES.OUTPUT, 80,  -8);
const decY2 = decC.addComponent(PIN_TYPES.OUTPUT, 80,   8);
const decY3 = decC.addComponent(PIN_TYPES.OUTPUT, 80,  24);
decC.addWire(decA0.id, 0, dec.id, 0);
decC.addWire(decA1.id, 0, dec.id, 1);
decC.addWire(dec.id, 2, decY0.id, 0);
decC.addWire(dec.id, 3, decY1.id, 0);
decC.addWire(dec.id, 4, decY2.id, 0);
decC.addWire(dec.id, 5, decY3.id, 0);

// Address 0 → Y0=1
assert(decY0.ports[0].value.isTrue(), 'DEC addr=0 → Y0=1');
assert(decY1.ports[0].value.isFalse(), 'DEC addr=0 → Y1=0');

// Address 1 (A0=1)
decA0.attrs.state = TRUE; decC.propagate();
assert(decY0.ports[0].value.isFalse(), 'DEC addr=1 → Y0=0');
assert(decY1.ports[0].value.isTrue(), 'DEC addr=1 → Y1=1');

// Address 3 (A0=1, A1=1)
decA1.attrs.state = TRUE; decC.propagate();
assert(decY3.ports[0].value.isTrue(), 'DEC addr=3 → Y3=1');
assert(decY2.ports[0].value.isFalse(), 'DEC addr=3 → Y2=0');

// Address 2 (A0=0, A1=1)
decA0.attrs.state = FALSE; decC.propagate();
assert(decY2.ports[0].value.isTrue(), 'DEC addr=2 → Y2=1');

/* ════════════════ Phase 5: 7-Segment Display ════════════════ */
section('7-Segment Display');

{
  const c = new Circuit();
  // Drive segments a, b, c ON (top, top-right, bottom-right) = digit "7"
  const segs = [];
  for (let i = 0; i < 7; i++) {
    segs.push(c.addComponent(PIN_TYPES.INPUT, -80, -24 + i * 8, { state: i < 3 ? TRUE : FALSE }));
  }
  const disp = c.addComponent(DISPLAY_TYPES.SEVEN_SEG, 0, 0);
  for (let i = 0; i < 7; i++) c.addWire(segs[i].id, 0, disp.id, i);

  assert(disp.ports[0].value.isTrue(), '7-seg: segment a ON');
  assert(disp.ports[1].value.isTrue(), '7-seg: segment b ON');
  assert(disp.ports[2].value.isTrue(), '7-seg: segment c ON');
  assert(disp.ports[3].value.isFalse(), '7-seg: segment d OFF');
}

/* ════════════════ Phase 5: Hex Display ════════════════ */
section('Hex Display');

{
  // Input 0101 = 5 → should decode to "5"
  const c = new Circuit();
  const d0 = c.addComponent(PIN_TYPES.INPUT, -80, -12, { state: TRUE });
  const d1 = c.addComponent(PIN_TYPES.INPUT, -80,  -4, { state: FALSE });
  const d2 = c.addComponent(PIN_TYPES.INPUT, -80,   4, { state: TRUE });
  const d3 = c.addComponent(PIN_TYPES.INPUT, -80,  12, { state: FALSE });
  const hex = c.addComponent(DISPLAY_TYPES.HEX_DISPLAY, 0, 0);
  c.addWire(d0.id, 0, hex.id, 0);
  c.addWire(d1.id, 0, hex.id, 1);
  c.addWire(d2.id, 0, hex.id, 2);
  c.addWire(d3.id, 0, hex.id, 3);

  assert(hex.ports[0].value.isTrue(), 'Hex: D0=1 received');
  assert(hex.ports[2].value.isTrue(), 'Hex: D2=1 received');
  // Verify component exists and has 4 ports
  assert(hex.ports.length === 4, 'Hex display has 4 input ports');
}

/* ════════════════ Phase 5: LED Bar ════════════════ */
section('LED Bar Graph');

{
  const c = new Circuit();
  const inputs = [];
  for (let i = 0; i < 8; i++) {
    inputs.push(c.addComponent(PIN_TYPES.INPUT, -80, -28 + i * 8, { state: i % 2 === 0 ? TRUE : FALSE }));
  }
  const bar = c.addComponent(DISPLAY_TYPES.LED_BAR, 0, 0);
  for (let i = 0; i < 8; i++) c.addWire(inputs[i].id, 0, bar.id, i);

  assert(bar.ports[0].value.isTrue(), 'LED Bar: port 0 ON');
  assert(bar.ports[1].value.isFalse(), 'LED Bar: port 1 OFF');
  assert(bar.ports[4].value.isTrue(), 'LED Bar: port 4 ON');
  assert(bar.ports.length === 8, 'LED Bar has 8 ports');
}

/* ════════════════ Phase 5: Hex Keyboard ════════════════ */
section('Hex Keyboard');

{
  const c = new Circuit();
  const kb = c.addComponent(DISPLAY_TYPES.KEYBOARD, 0, 0);
  const d0 = c.addComponent(PIN_TYPES.OUTPUT, 80, -16);
  const d1 = c.addComponent(PIN_TYPES.OUTPUT, 80, -8);
  const d2 = c.addComponent(PIN_TYPES.OUTPUT, 80, 0);
  const d3 = c.addComponent(PIN_TYPES.OUTPUT, 80, 8);
  const valid = c.addComponent(PIN_TYPES.OUTPUT, 80, 16);
  c.addWire(kb.id, 0, d0.id, 0);
  c.addWire(kb.id, 1, d1.id, 0);
  c.addWire(kb.id, 2, d2.id, 0);
  c.addWire(kb.id, 3, d3.id, 0);
  c.addWire(kb.id, 4, valid.id, 0);

  // No key pressed
  assert(valid.ports[0].value.isFalse(), 'Keyboard: no key → VALID=0');

  // Press key 0xA (1010)
  kb.attrs._key = 10;
  c.propagate();
  assert(valid.ports[0].value.isTrue(), 'Keyboard: key A → VALID=1');
  assert(d0.ports[0].value.isFalse(), 'Keyboard: A bit0 = 0');
  assert(d1.ports[0].value.isTrue(), 'Keyboard: A bit1 = 1');
  assert(d2.ports[0].value.isFalse(), 'Keyboard: A bit2 = 0');
  assert(d3.ports[0].value.isTrue(), 'Keyboard: A bit3 = 1');

  // Press key 0x5 (0101)
  kb.attrs._key = 5;
  c.propagate();
  assert(d0.ports[0].value.isTrue(), 'Keyboard: 5 bit0 = 1');
  assert(d1.ports[0].value.isFalse(), 'Keyboard: 5 bit1 = 0');
  assert(d2.ports[0].value.isTrue(), 'Keyboard: 5 bit2 = 1');
  assert(d3.ports[0].value.isFalse(), 'Keyboard: 5 bit3 = 0');
}

/* ════════════════ Phase 5: TTY Display ════════════════ */
section('TTY Display');

{
  const c = new Circuit();
  const dataPins = [];
  // ASCII 'H' = 72 = 0b1001000
  const hBits = [0, 0, 0, 1, 0, 0, 1]; // D0-D6 for 'H' (72)
  for (let i = 0; i < 7; i++) {
    dataPins.push(c.addComponent(PIN_TYPES.INPUT, -120, -24 + i * 8, { state: hBits[i] ? TRUE : FALSE }));
  }
  const clk = c.addComponent(PIN_TYPES.INPUT, -120, 32, { state: FALSE });
  const tty = c.addComponent(DISPLAY_TYPES.TTY, 0, 0);
  for (let i = 0; i < 7; i++) c.addWire(dataPins[i].id, 0, tty.id, i);
  c.addWire(clk.id, 0, tty.id, 7);

  assert(tty.attrs._text === '', 'TTY: initial empty');

  // Clock pulse → capture 'H'
  clk.attrs.state = TRUE; c.propagate();
  assert(tty.attrs._text === 'H', 'TTY: captured "H"');

  // Another pulse with same data → 'HH'
  clk.attrs.state = FALSE; c.propagate();
  clk.attrs.state = TRUE; c.propagate();
  assert(tty.attrs._text === 'HH', 'TTY: captured "HH"');

  // Change to 'i' = 105 = 0b1101001
  const iBits = [1, 0, 0, 1, 0, 1, 1];
  for (let j = 0; j < 7; j++) dataPins[j].attrs.state = iBits[j] ? TRUE : FALSE;
  clk.attrs.state = FALSE; c.propagate();
  clk.attrs.state = TRUE; c.propagate();
  assert(tty.attrs._text === 'HHi', 'TTY: captured "HHi"');

  // Click to clear
  DISPLAY_TYPES.TTY.onClick(tty, c);
  assert(tty.attrs._text === '', 'TTY: cleared');
}

/* ════════════════ Phase 6: Truth Table — AND gate ════════════════ */
section('Truth Table: AND gate');

{
  const c = new Circuit();
  const a = c.addComponent(PIN_TYPES.INPUT, -80, -20, { label: 'A', state: FALSE });
  const b = c.addComponent(PIN_TYPES.INPUT, -80,  20, { label: 'B', state: FALSE });
  const g = c.addComponent(GATE_TYPES.AND, 0, 0);
  const q = c.addComponent(PIN_TYPES.OUTPUT, 80, 0, { label: 'Q' });
  c.addWire(a.id, 0, g.id, 0);
  c.addWire(b.id, 0, g.id, 1);
  c.addWire(g.id, 2, q.id, 0);

  const analyzer = new L.Analyzer(c);
  const tt = analyzer.generateTruthTable();
  assert(tt !== null, 'TT: generated');
  assert(tt.numInputs === 2, 'TT: 2 inputs');
  assert(tt.rows.length === 4, 'TT: 4 rows');
  assert(tt.inputNames[0] === 'A', 'TT: input name A');
  assert(tt.inputNames[1] === 'B', 'TT: input name B');
  assert(tt.outputNames[0] === 'Q', 'TT: output name Q');

  // AND truth table: 0,0→0  0,1→0  1,0→0  1,1→1
  assert(tt.rows[0].out[0] === 0, 'TT: 00→0');
  assert(tt.rows[1].out[0] === 0, 'TT: 01→0');
  assert(tt.rows[2].out[0] === 0, 'TT: 10→0');
  assert(tt.rows[3].out[0] === 1, 'TT: 11→1');

  // Verify inputs restored
  assert(a.attrs.state === FALSE, 'TT: input A restored');
}

/* ════════════════ Phase 6: Truth Table — OR gate ════════════════ */
section('Truth Table: OR gate');

{
  const c = new Circuit();
  const a = c.addComponent(PIN_TYPES.INPUT, -80, -20, { label: 'A', state: FALSE });
  const b = c.addComponent(PIN_TYPES.INPUT, -80,  20, { label: 'B', state: FALSE });
  const g = c.addComponent(GATE_TYPES.OR, 0, 0);
  const q = c.addComponent(PIN_TYPES.OUTPUT, 80, 0, { label: 'Q' });
  c.addWire(a.id, 0, g.id, 0);
  c.addWire(b.id, 0, g.id, 1);
  c.addWire(g.id, 2, q.id, 0);

  const analyzer = new L.Analyzer(c);
  const tt = analyzer.generateTruthTable();
  assert(tt.rows[0].out[0] === 0, 'OR TT: 00→0');
  assert(tt.rows[1].out[0] === 1, 'OR TT: 01→1');
  assert(tt.rows[2].out[0] === 1, 'OR TT: 10→1');
  assert(tt.rows[3].out[0] === 1, 'OR TT: 11→1');
}

/* ════════════════ Phase 6: SOP Expression ════════════════ */
section('SOP Expression');

{
  const c = new Circuit();
  const a = c.addComponent(PIN_TYPES.INPUT, -80, -20, { label: 'A', state: FALSE });
  const b = c.addComponent(PIN_TYPES.INPUT, -80,  20, { label: 'B', state: FALSE });
  const g = c.addComponent(GATE_TYPES.AND, 0, 0);
  const q = c.addComponent(PIN_TYPES.OUTPUT, 80, 0, { label: 'Q' });
  c.addWire(a.id, 0, g.id, 0);
  c.addWire(b.id, 0, g.id, 1);
  c.addWire(g.id, 2, q.id, 0);

  const analyzer = new L.Analyzer(c);
  const tt = analyzer.generateTruthTable();
  const sop = analyzer.extractSOP(tt, 0);
  // AND gate: only minterm 11 → "A·B"
  assert(sop === 'A\u00B7B', 'SOP: AND = "A·B", got: ' + sop);
}

/* ════════════════ Phase 6: Quine-McCluskey Minimization ════════════════ */
section('Quine-McCluskey: OR gate');

{
  const c = new Circuit();
  const a = c.addComponent(PIN_TYPES.INPUT, -80, -20, { label: 'A', state: FALSE });
  const b = c.addComponent(PIN_TYPES.INPUT, -80,  20, { label: 'B', state: FALSE });
  const g = c.addComponent(GATE_TYPES.OR, 0, 0);
  const q = c.addComponent(PIN_TYPES.OUTPUT, 80, 0, { label: 'Q' });
  c.addWire(a.id, 0, g.id, 0);
  c.addWire(b.id, 0, g.id, 1);
  c.addWire(g.id, 2, q.id, 0);

  const analyzer = new L.Analyzer(c);
  const tt = analyzer.generateTruthTable();
  const min = analyzer.minimize(tt, 0);
  // OR gate: minterms 01, 10, 11 → minimized to "A + B"
  assert(min.expr === 'B + A' || min.expr === 'A + B', 'QM: OR minimized to A + B, got: ' + min.expr);
}

/* ════════════════ Phase 6: QM — XOR (no simplification) ════════════════ */
section('Quine-McCluskey: XOR');

{
  const c = new Circuit();
  const a = c.addComponent(PIN_TYPES.INPUT, -80, -20, { label: 'A', state: FALSE });
  const b = c.addComponent(PIN_TYPES.INPUT, -80,  20, { label: 'B', state: FALSE });
  const g = c.addComponent(GATE_TYPES.XOR, 0, 0);
  const q = c.addComponent(PIN_TYPES.OUTPUT, 80, 0, { label: 'Q' });
  c.addWire(a.id, 0, g.id, 0);
  c.addWire(b.id, 0, g.id, 1);
  c.addWire(g.id, 2, q.id, 0);

  const analyzer = new L.Analyzer(c);
  const tt = analyzer.generateTruthTable();
  const min = analyzer.minimize(tt, 0);
  // XOR: minterms 01, 10 → cannot simplify beyond 2 terms
  assert(min.primes.length === 2, 'QM: XOR has 2 prime implicants');
}

/* ════════════════ Phase 6: K-Map (2 variables) ════════════════ */
section('K-Map: 2 variables');

{
  const c = new Circuit();
  const a = c.addComponent(PIN_TYPES.INPUT, -80, -20, { label: 'A', state: FALSE });
  const b = c.addComponent(PIN_TYPES.INPUT, -80,  20, { label: 'B', state: FALSE });
  const g = c.addComponent(GATE_TYPES.AND, 0, 0);
  const q = c.addComponent(PIN_TYPES.OUTPUT, 80, 0, { label: 'Q' });
  c.addWire(a.id, 0, g.id, 0);
  c.addWire(b.id, 0, g.id, 1);
  c.addWire(g.id, 2, q.id, 0);

  const analyzer = new L.Analyzer(c);
  const tt = analyzer.generateTruthTable();
  const km = analyzer.generateKMap(tt, 0);
  assert(km !== null, 'K-Map: generated');
  assert(km.grid.length === 2, 'K-Map: 2 rows');
  assert(km.grid[0].length === 2, 'K-Map: 2 cols');
  // AND: only (1,1)=1
  assert(km.grid[0][0] === 0, 'K-Map: (0,0)=0');
  assert(km.grid[0][1] === 0, 'K-Map: (0,1)=0');
  assert(km.grid[1][0] === 0, 'K-Map: (1,0)=0');
  assert(km.grid[1][1] === 1, 'K-Map: (1,1)=1');
}

/* ════════════════ Phase 6: K-Map (3 variables) ════════════════ */
section('K-Map: 3 variables');

{
  // 3-input OR gate: 1 everywhere except 000
  const c = new Circuit();
  const a = c.addComponent(PIN_TYPES.INPUT, -80, -30, { label: 'A', state: FALSE });
  const b = c.addComponent(PIN_TYPES.INPUT, -80,   0, { label: 'B', state: FALSE });
  const cv = c.addComponent(PIN_TYPES.INPUT, -80,  30, { label: 'C', state: FALSE });
  const g1 = c.addComponent(GATE_TYPES.OR, 0, -15, { inputs: 2 });
  const g2 = c.addComponent(GATE_TYPES.OR, 60, 0, { inputs: 2 });
  const q = c.addComponent(PIN_TYPES.OUTPUT, 140, 0, { label: 'Q' });
  c.addWire(a.id, 0, g1.id, 0);
  c.addWire(b.id, 0, g1.id, 1);
  c.addWire(g1.id, 2, g2.id, 0);
  c.addWire(cv.id, 0, g2.id, 1);
  c.addWire(g2.id, 2, q.id, 0);

  const analyzer = new L.Analyzer(c);
  const tt = analyzer.generateTruthTable();
  assert(tt.numInputs === 3, 'K-Map 3v: 3 inputs');
  assert(tt.rows.length === 8, 'K-Map 3v: 8 rows');

  const km = analyzer.generateKMap(tt, 0);
  assert(km !== null, 'K-Map 3v: generated');
  assert(km.grid.length === 2, 'K-Map 3v: 2 rows');
  assert(km.grid[0].length === 4, 'K-Map 3v: 4 cols');
  // Row 0 (A=0): BC=00→0, BC=01→1, BC=11→1, BC=10→1
  assert(km.grid[0][0] === 0, 'K-Map 3v: A=0,BC=00 → 0');
  assert(km.grid[0][1] === 1, 'K-Map 3v: A=0,BC=01 → 1');
}

/* ════════════════ Phase 6: K-Map labels (4 variables) ════════════════ */
section('K-Map: 4 variable labels');

{
  // Build a 4-input circuit (A AND B AND C AND D)
  const c = new Circuit();
  const a = c.addComponent(PIN_TYPES.INPUT, -120, -24, { label: 'A', state: FALSE });
  const b = c.addComponent(PIN_TYPES.INPUT, -120,  -8, { label: 'B', state: FALSE });
  const cv = c.addComponent(PIN_TYPES.INPUT, -120,   8, { label: 'C', state: FALSE });
  const d = c.addComponent(PIN_TYPES.INPUT, -120,  24, { label: 'D', state: FALSE });
  const g1 = c.addComponent(GATE_TYPES.AND, -40, -16);
  const g2 = c.addComponent(GATE_TYPES.AND, -40, 16);
  const g3 = c.addComponent(GATE_TYPES.AND, 40, 0);
  const q = c.addComponent(PIN_TYPES.OUTPUT, 120, 0, { label: 'Q' });
  c.addWire(a.id, 0, g1.id, 0);
  c.addWire(b.id, 0, g1.id, 1);
  c.addWire(cv.id, 0, g2.id, 0);
  c.addWire(d.id, 0, g2.id, 1);
  c.addWire(g1.id, 2, g3.id, 0);
  c.addWire(g2.id, 2, g3.id, 1);
  c.addWire(g3.id, 2, q.id, 0);

  const analyzer = new L.Analyzer(c);
  const tt = analyzer.generateTruthTable();
  const km = analyzer.generateKMap(tt, 0);
  assert(km !== null, 'K-Map 4v: generated');
  assert(km.grid.length === 4, 'K-Map 4v: 4 rows');
  assert(km.grid[0].length === 4, 'K-Map 4v: 4 cols');

  // Verify Gray code labels are correct (MSB first)
  // rowBits = [0,1,3,2] → labels should be "00","01","11","10"
  assert(km.rowLabels[0] === '00', 'K-Map 4v: row 0 label = "00"');
  assert(km.rowLabels[1] === '01', 'K-Map 4v: row 1 label = "01"');
  assert(km.rowLabels[2] === '11', 'K-Map 4v: row 2 label = "11"');
  assert(km.rowLabels[3] === '10', 'K-Map 4v: row 3 label = "10"');
  assert(km.colLabels[0] === '00', 'K-Map 4v: col 0 label = "00"');
  assert(km.colLabels[1] === '01', 'K-Map 4v: col 1 label = "01"');
  assert(km.colLabels[2] === '11', 'K-Map 4v: col 2 label = "11"');
  assert(km.colLabels[3] === '10', 'K-Map 4v: col 3 label = "10"');

  // ABCD all 1 → only cell at row "11" (idx 2), col "11" (idx 2) should be 1
  assert(km.grid[2][2] === 1, 'K-Map 4v: ABCD=1111 cell = 1');
  // All others in row 2 should be 0 except col 2
  assert(km.grid[2][0] === 0, 'K-Map 4v: AB=11,CD=00 = 0');
  assert(km.grid[2][1] === 0, 'K-Map 4v: AB=11,CD=01 = 0');
  assert(km.grid[2][3] === 0, 'K-Map 4v: AB=11,CD=10 = 0');
}

/* ════════════════ Phase 6: Expression Parser ════════════════ */
section('Expression Parser');

{
  const { tokenize, parse, astToString } = L.ExprParser;

  // Simple AND
  let ast = parse(tokenize('A & B'));
  assert(astToString(ast) === 'A\u00B7B', 'Parse: A & B = A·B, got: ' + astToString(ast));

  // OR
  ast = parse(tokenize('A + B'));
  assert(astToString(ast) === 'A + B', 'Parse: A + B');

  // NOT
  ast = parse(tokenize('!A'));
  assert(astToString(ast) === '\u00ACA', 'Parse: !A = ¬A');

  // Complex: A·B + ¬C
  ast = parse(tokenize('A*B + !C'));
  const s = astToString(ast);
  assert(s === 'A\u00B7B + \u00ACC', 'Parse: A*B + !C = A·B + ¬C, got: ' + s);

  // Implicit AND: AB
  ast = parse(tokenize('AB'));
  assert(astToString(ast) === 'A\u00B7B', 'Parse: AB = A·B (implicit AND)');

  // Parentheses: (A+B)·C
  ast = parse(tokenize('(A+B)*C'));
  assert(astToString(ast) === '(A + B)\u00B7C', 'Parse: (A+B)*C');

  // Postfix NOT: A\'
  ast = parse(tokenize("A'"));
  assert(astToString(ast) === '\u00ACA', "Parse: A' = ¬A");
}

/* ════════════════ Phase 6: Synthesize (Expression → Circuit) ════════════════ */
section('Synthesize: A·B + C');

{
  const c = new Circuit();
  const result = L.synthesize(c, 'A*B + C', 0, 0);
  assert(result !== null, 'Synthesize: result not null');
  assert(result.vars.length === 3, 'Synthesize: 3 variables (A, B, C)');

  // Should have INPUT pins, gates, and OUTPUT pin
  let inputCount = 0, outputCount = 0, gateCount = 0;
  for (const comp of c.components.values()) {
    if (comp.type === 'INPUT') inputCount++;
    else if (comp.type === 'OUTPUT') outputCount++;
    else gateCount++;
  }
  assert(inputCount === 3, 'Synthesize: 3 input pins');
  assert(outputCount === 1, 'Synthesize: 1 output pin');
  assert(gateCount >= 2, 'Synthesize: at least 2 gates (AND + OR)');

  // Verify truth table of synthesized circuit
  const analyzer = new L.Analyzer(c);
  const tt = analyzer.generateTruthTable();
  // A·B + C: true when (A=1,B=1) OR C=1
  // Row 0: A=0,B=0,C=0 → 0
  // Row 1: A=0,B=0,C=1 → 1
  // Row 3: A=0,B=1,C=1 → 1
  // Row 6: A=1,B=1,C=0 → 1
  // Row 7: A=1,B=1,C=1 → 1
  assert(tt.rows[0].out[0] === 0, 'Synth TT: 000→0');
  assert(tt.rows[1].out[0] === 1, 'Synth TT: 001→1');
  assert(tt.rows[6].out[0] === 1, 'Synth TT: 110→1');
  assert(tt.rows[7].out[0] === 1, 'Synth TT: 111→1');
}

/* ════════════════ Phase 6: QM — 3-variable minimization ════════════════ */
section('QM: 3-variable minimize');

{
  // f(A,B,C) = Σ(1,3,5,7) = C (all odd minterms)
  const c = new Circuit();
  const a = c.addComponent(PIN_TYPES.INPUT, -80, -30, { label: 'A', state: FALSE });
  const b = c.addComponent(PIN_TYPES.INPUT, -80,   0, { label: 'B', state: FALSE });
  const cv = c.addComponent(PIN_TYPES.INPUT, -80,  30, { label: 'C', state: FALSE });
  // Wire C directly to output
  const q = c.addComponent(PIN_TYPES.OUTPUT, 80, 0, { label: 'Q' });
  c.addWire(cv.id, 0, q.id, 0);

  const analyzer = new L.Analyzer(c);
  const tt = analyzer.generateTruthTable();
  const min = analyzer.minimize(tt, 0);
  // Should minimize to just "C"
  assert(min.expr === 'C', 'QM 3v: Σ(1,3,5,7) minimizes to C, got: ' + min.expr);
  assert(min.primes.length === 1, 'QM 3v: 1 prime implicant');
}

/* ════════════════ Phase 7: Signal Recorder ════════════════ */
section('Signal Recorder: basic recording');

{
  const c = new Circuit();
  const a = c.addComponent(PIN_TYPES.INPUT, -80, -20, { label: 'A', state: FALSE });
  const g = c.addComponent(GATE_TYPES.NOT, 0, 0);
  const q = c.addComponent(PIN_TYPES.OUTPUT, 80, 0, { label: 'Q' });
  c.addWire(a.id, 0, g.id, 0);
  c.addWire(g.id, 1, q.id, 0);

  const rec = new L.SignalRecorder(c);
  rec.watchAllPins();
  assert(rec._watched.length === 2, 'Recorder: 2 signals watched (A, Q)');

  rec.start();
  assert(rec.recording === true, 'Recorder: recording started');

  // Initial sample
  const sigs = rec.getSignals();
  assert(sigs.length === 2, 'Recorder: 2 signals');
  assert(sigs[0].history.length === 1, 'Recorder: A has initial sample');
  assert(sigs[0].history[0].value === FALSE, 'Recorder: A initial = 0');

  // Toggle A → 1
  a.attrs.state = TRUE;
  c.propagate();
  rec.sample();
  const aSig = rec.getSignals().find(s => s.name === 'A');
  assert(aSig.history.length === 2, 'Recorder: A has 2 entries after toggle');
  assert(aSig.history[1].value === TRUE, 'Recorder: A second entry = 1');

  // Q should have changed too (NOT gate inverts)
  const qSig = rec.getSignals().find(s => s.name === 'Q');
  assert(qSig.history.length === 2, 'Recorder: Q has 2 entries');
  assert(qSig.history[0].value === TRUE, 'Recorder: Q initial = 1 (NOT of 0)');
  assert(qSig.history[1].value === FALSE, 'Recorder: Q after A=1 → 0');
}

/* ════════════════ Phase 7: Recorder RLE compression ════════════════ */
section('Signal Recorder: RLE (no duplicate entries)');

{
  const c = new Circuit();
  const a = c.addComponent(PIN_TYPES.INPUT, -80, 0, { label: 'X', state: FALSE });
  const q = c.addComponent(PIN_TYPES.OUTPUT, 80, 0, { label: 'Y' });
  c.addWire(a.id, 0, q.id, 0);

  const rec = new L.SignalRecorder(c);
  rec.watchAllPins();
  rec.start();

  // Sample multiple times without changing value
  rec.sample(); rec.sample(); rec.sample();
  const xSig = rec.getSignals().find(s => s.name === 'X');
  assert(xSig.history.length === 1, 'RLE: no duplicate entries for same value');

  // Change value
  a.attrs.state = TRUE; c.propagate();
  rec.sample();
  assert(xSig.history.length === 2, 'RLE: new entry on value change');
}

/* ════════════════ Phase 7: Recorder with clock ════════════════ */
section('Signal Recorder: clock toggles');

{
  const c = new Circuit();
  const clk = c.addComponent(PIN_TYPES.INPUT, -80, 0, { label: 'CLK', state: FALSE });
  const q = c.addComponent(PIN_TYPES.OUTPUT, 80, 0, { label: 'OUT' });
  c.addWire(clk.id, 0, q.id, 0);

  const rec = new L.SignalRecorder(c);
  rec.watchAllPins();
  rec.start();

  // Simulate 4 clock cycles
  for (let i = 0; i < 4; i++) {
    clk.attrs.state = TRUE; c.propagate(); rec.sample();
    clk.attrs.state = FALSE; c.propagate(); rec.sample();
  }

  const clkSig = rec.getSignals().find(s => s.name === 'CLK');
  // Initial(0) + 8 toggles = 9 entries (0,1,0,1,0,1,0,1,0)
  assert(clkSig.history.length === 9, 'Clock: 9 history entries for 4 cycles, got ' + clkSig.history.length);
  assert(clkSig.history[0].value === FALSE, 'Clock: starts LOW');
  assert(clkSig.history[1].value === TRUE, 'Clock: first HIGH');
  assert(clkSig.history[8].value === FALSE, 'Clock: ends LOW');
}

/* ════════════════ Phase 7: Recorder stop/reset ════════════════ */
section('Signal Recorder: stop and reset');

{
  const c = new Circuit();
  const a = c.addComponent(PIN_TYPES.INPUT, -80, 0, { label: 'S', state: FALSE });
  const q = c.addComponent(PIN_TYPES.OUTPUT, 80, 0, { label: 'T' });
  c.addWire(a.id, 0, q.id, 0);

  const rec = new L.SignalRecorder(c);
  rec.watchAllPins();
  rec.start();
  a.attrs.state = TRUE; c.propagate(); rec.sample();
  rec.stop();

  // After stop, sample should not record
  a.attrs.state = FALSE; c.propagate(); rec.sample();
  const sSig = rec.getSignals().find(s => s.name === 'S');
  assert(sSig.history.length === 2, 'Stop: no new entries after stop');

  // Reset clears everything (signals + watched list)
  rec.reset();
  assert(rec.getSignals().length === 0, 'Reset: signals cleared');
  assert(rec._watched.length === 0, 'Reset: watched list cleared');
  assert(rec.tick === 0, 'Reset: tick = 0');
}

/* ════════════════ Phase 8: Subcircuit — half adder as subcircuit ════════════════ */
section('Subcircuit: half adder');

{
  // Build a type registry with all component types
  const typeReg = Object.assign({}, GATE_TYPES, PIN_TYPES,
    { CLOCK: CLOCK_TYPE }, WIRING_TYPES, IO_TYPES, MEMORY_TYPES, ARITH_TYPES, DISPLAY_TYPES);

  // Build a half-adder circuit
  const haC = new Circuit();
  const haA = haC.addComponent(PIN_TYPES.INPUT, -80, -20, { label: 'A', state: FALSE });
  const haB = haC.addComponent(PIN_TYPES.INPUT, -80,  20, { label: 'B', state: FALSE });
  const haXor = haC.addComponent(GATE_TYPES.XOR, 0, -20);
  const haAnd = haC.addComponent(GATE_TYPES.AND, 0,  20);
  const haSum = haC.addComponent(PIN_TYPES.OUTPUT, 80, -20, { label: 'Sum' });
  const haCar = haC.addComponent(PIN_TYPES.OUTPUT, 80,  20, { label: 'Carry' });
  haC.addWire(haA.id, 0, haXor.id, 0);
  haC.addWire(haB.id, 0, haXor.id, 1);
  haC.addWire(haA.id, 0, haAnd.id, 0);
  haC.addWire(haB.id, 0, haAnd.id, 1);
  haC.addWire(haXor.id, 2, haSum.id, 0);
  haC.addWire(haAnd.id, 2, haCar.id, 0);

  // Create subcircuit definition
  const haDef = new L.SubcircuitDef('HalfAdder', haC.toJSON(), typeReg);
  assert(haDef.numInputs === 2, 'SubDef: 2 inputs');
  assert(haDef.numOutputs === 2, 'SubDef: 2 outputs');

  // Create component type from definition
  const haType = haDef.toComponentType();
  assert(haType.type === 'SUB_HalfAdder', 'SubType: name = SUB_HalfAdder');

  // Use it in a parent circuit
  const parent = new Circuit();
  const pA = parent.addComponent(PIN_TYPES.INPUT, -100, -20, { label: 'X', state: FALSE });
  const pB = parent.addComponent(PIN_TYPES.INPUT, -100,  20, { label: 'Y', state: FALSE });
  const sub = parent.addComponent(haType, 0, 0);
  const pSum = parent.addComponent(PIN_TYPES.OUTPUT, 100, -10, { label: 'S' });
  const pCar = parent.addComponent(PIN_TYPES.OUTPUT, 100,  10, { label: 'C' });

  parent.addWire(pA.id, 0, sub.id, 0);  // X → A input
  parent.addWire(pB.id, 0, sub.id, 1);  // Y → B input
  // Outputs sorted alphabetically: port 2=Carry, port 3=Sum
  parent.addWire(sub.id, 2, pCar.id, 0); // Carry output
  parent.addWire(sub.id, 3, pSum.id, 0); // Sum output

  // Test: 0+0 = S=0, C=0
  assert(pSum.ports[0].value.isFalse(), 'Sub HA: 0+0 Sum=0');
  assert(pCar.ports[0].value.isFalse(), 'Sub HA: 0+0 Carry=0');

  // Test: 1+0 = S=1, C=0
  pA.attrs.state = TRUE;
  parent.propagate();
  assert(pSum.ports[0].value.isTrue(), 'Sub HA: 1+0 Sum=1');
  assert(pCar.ports[0].value.isFalse(), 'Sub HA: 1+0 Carry=0');

  // Test: 1+1 = S=0, C=1
  pB.attrs.state = TRUE;
  parent.propagate();
  assert(pSum.ports[0].value.isFalse(), 'Sub HA: 1+1 Sum=0');
  assert(pCar.ports[0].value.isTrue(), 'Sub HA: 1+1 Carry=1');

  // Test: 0+1 = S=1, C=0
  pA.attrs.state = FALSE;
  parent.propagate();
  assert(pSum.ports[0].value.isTrue(), 'Sub HA: 0+1 Sum=1');
  assert(pCar.ports[0].value.isFalse(), 'Sub HA: 0+1 Carry=0');
}

/* ════════════════ Phase 8: Project — multi-circuit ════════════════ */
section('Project: multi-circuit management');

{
  const proj = new L.Project();
  const typeReg = Object.assign({}, GATE_TYPES, PIN_TYPES);
  proj.setTypeRegistry(typeReg);

  const mainC = new Circuit();
  proj.addCircuit('main', mainC);
  assert(proj.getCircuitNames().length === 1, 'Project: 1 circuit');
  assert(proj.getActive() === mainC, 'Project: main is active');

  // Add second circuit
  const subC = new Circuit();
  proj.addCircuit('adder', subC);
  assert(proj.getCircuitNames().length === 2, 'Project: 2 circuits');

  // Switch
  proj.setActive('adder');
  assert(proj.activeName === 'adder', 'Project: switched to adder');
  assert(proj.getActive() === subC, 'Project: adder is active');

  // Switch back
  proj.setActive('main');
  assert(proj.getActive() === mainC, 'Project: back to main');
}

/* ════════════════ Phase 8: Subcircuit with sequential logic (D-FF inside) ════════════════ */
section('Subcircuit: sequential (D-FF)');

{
  const typeReg = Object.assign({}, GATE_TYPES, PIN_TYPES, MEMORY_TYPES);

  // Build inner circuit: D-FF with CLR=0
  const inner = new Circuit();
  const iD = inner.addComponent(PIN_TYPES.INPUT, -80, -16, { label: 'D', state: FALSE });
  const iClk = inner.addComponent(PIN_TYPES.INPUT, -80, 0, { label: 'CLK', state: FALSE });
  const iClr = inner.addComponent(PIN_TYPES.INPUT, -80, 16, { label: 'CLR', state: FALSE });
  const iFF = inner.addComponent(MEMORY_TYPES.D_FF, 0, 0);
  const iQ = inner.addComponent(PIN_TYPES.OUTPUT, 80, 0, { label: 'Q' });
  inner.addWire(iD.id, 0, iFF.id, 0);
  inner.addWire(iClk.id, 0, iFF.id, 1);
  inner.addWire(iClr.id, 0, iFF.id, 2);
  inner.addWire(iFF.id, 3, iQ.id, 0);

  const def = new L.SubcircuitDef('DFF', inner.toJSON(), typeReg);
  assert(def.numInputs === 3, 'DFF sub: 3 inputs');
  assert(def.numOutputs === 1, 'DFF sub: 1 output');

  const dffType = def.toComponentType();
  const parent = new Circuit();
  const pD = parent.addComponent(PIN_TYPES.INPUT, -100, -16, { label: 'D', state: TRUE });
  const pClk = parent.addComponent(PIN_TYPES.INPUT, -100, 0, { label: 'CLK', state: FALSE });
  const pClr = parent.addComponent(PIN_TYPES.INPUT, -100, 16, { label: 'CLR', state: FALSE });
  const pSub = parent.addComponent(dffType, 0, 0);
  const pQ = parent.addComponent(PIN_TYPES.OUTPUT, 100, 0, { label: 'Q' });
  // Inner inputs sorted alphabetically: CLK=0, CLR=1, D=2
  parent.addWire(pClk.id, 0, pSub.id, 0);
  parent.addWire(pClr.id, 0, pSub.id, 1);
  parent.addWire(pD.id, 0, pSub.id, 2);
  parent.addWire(pSub.id, 3, pQ.id, 0);

  // Initial: Q=0
  assert(pQ.ports[0].value.isFalse(), 'DFF sub: initial Q=0');

  // Rising edge with D=1 → Q=1
  pClk.attrs.state = TRUE; parent.propagate();
  assert(pQ.ports[0].value.isTrue(), 'DFF sub: D=1 edge → Q=1');

  // State persists: CLK back to 0, Q stays 1
  pClk.attrs.state = FALSE; parent.propagate();
  assert(pQ.ports[0].value.isTrue(), 'DFF sub: Q holds 1');

  // New edge with D=0 → Q=0
  pD.attrs.state = FALSE;
  pClk.attrs.state = TRUE; parent.propagate();
  assert(pQ.ports[0].value.isFalse(), 'DFF sub: D=0 edge → Q=0');
}

/* ════════════════ Phase 8: Circuit.fromJSON roundtrip ════════════════ */
section('Circuit.fromJSON roundtrip');

{
  const typeReg = Object.assign({}, GATE_TYPES, PIN_TYPES);
  const orig = new Circuit();
  const a = orig.addComponent(PIN_TYPES.INPUT, -80, 0, { label: 'A', state: TRUE });
  const n = orig.addComponent(GATE_TYPES.NOT, 0, 0);
  const q = orig.addComponent(PIN_TYPES.OUTPUT, 80, 0, { label: 'Q' });
  orig.addWire(a.id, 0, n.id, 0);
  orig.addWire(n.id, 1, q.id, 0);

  const json = orig.toJSON();
  const { circuit: clone } = L.Circuit.fromJSON(json, typeReg);

  // Clone should work independently
  const analyzer = new L.Analyzer(clone);
  const tt = analyzer.generateTruthTable();
  assert(tt.rows[0].out[0] === 1, 'Clone: NOT(0) = 1');
  assert(tt.rows[1].out[0] === 0, 'Clone: NOT(1) = 0');
}

/* ════════════════ Phase 9: JSON roundtrip ════════════════ */
section('File I/O: JSON save/load roundtrip');

{
  const typeReg = Object.assign({}, GATE_TYPES, PIN_TYPES);

  // Build a simple circuit
  const c = new Circuit();
  const a = c.addComponent(PIN_TYPES.INPUT, -80, -20, { label: 'A', state: TRUE });
  const b = c.addComponent(PIN_TYPES.INPUT, -80,  20, { label: 'B', state: FALSE });
  const g = c.addComponent(GATE_TYPES.AND, 0, 0);
  const q = c.addComponent(PIN_TYPES.OUTPUT, 80, 0, { label: 'Q' });
  c.addWire(a.id, 0, g.id, 0);
  c.addWire(b.id, 0, g.id, 1);
  c.addWire(g.id, 2, q.id, 0);
  g.rotate(90);

  const json = c.toJSON();
  assert(json.components.length === 4, 'JSON: 4 components serialized');
  assert(json.wires.length === 3, 'JSON: 3 wires serialized');

  // Verify attrs are copies (not live references)
  const inputComp = json.components.find(c => c.type === 'INPUT' && c.attrs.label === 'A');
  assert(inputComp.attrs.state === TRUE, 'JSON: input A state preserved');
  inputComp.attrs.state = FALSE; // mutate the JSON
  assert(a.attrs.state === TRUE, 'JSON: live attrs not affected by JSON mutation');

  // Reconstruct
  const { circuit: clone } = L.Circuit.fromJSON(json, typeReg);
  assert(clone.components.size === 4, 'JSON load: 4 components');
  assert(clone.wires.size === 3, 'JSON load: 3 wires');

  // Verify rotation preserved
  let gateFound = false;
  for (const comp of clone.components.values()) {
    if (comp.type === 'AND') { gateFound = true; assert(comp.rotation === 90, 'JSON load: rotation=90 preserved'); }
  }
  assert(gateFound, 'JSON load: AND gate found');

  // Verify clone is functionally correct
  const analyzer = new L.Analyzer(clone);
  const tt = analyzer.generateTruthTable();
  assert(tt.rows[3].out[0] === 1, 'JSON load: AND(1,1)=1');
  assert(tt.rows[0].out[0] === 0, 'JSON load: AND(0,0)=0');
}

/* ════════════════ Phase 9: URL hash encode/decode ════════════════ */
section('File I/O: URL hash encode/decode');

{
  const c = new Circuit();
  c.addComponent(PIN_TYPES.INPUT, 0, 0, { label: 'X', state: FALSE });
  c.addComponent(PIN_TYPES.OUTPUT, 80, 0, { label: 'Y' });

  const encoded = L.FileIO.encodeToHash(c);
  assert(typeof encoded === 'string', 'URL hash: encoded is string');
  assert(encoded.length > 10, 'URL hash: encoded has content');

  const decoded = L.FileIO.decodeFromHash(encoded);
  assert(decoded !== null, 'URL hash: decoded successfully');
  assert(decoded.components.length === 2, 'URL hash: 2 components roundtripped');

  // Invalid base64
  const bad = L.FileIO.decodeFromHash('!!!invalid!!!');
  assert(bad === null, 'URL hash: invalid input returns null');
}

/* ════════════════ Phase 9: toJSON strips _inner refs ════════════════ */
section('File I/O: toJSON strips subcircuit runtime refs');

{
  const c = new Circuit();
  const comp = c.addComponent(PIN_TYPES.INPUT, 0, 0, { label: 'T', state: FALSE });
  // Simulate subcircuit runtime attrs
  comp.attrs._inner = { fake: 'circuit' };
  comp.attrs._innerIn = [1, 2, 3];
  comp.attrs._innerOut = [4, 5];

  const json = c.toJSON();
  const serialized = json.components[0].attrs;
  assert(!('_inner' in serialized), 'toJSON: _inner stripped');
  assert(!('_innerIn' in serialized), 'toJSON: _innerIn stripped');
  assert(!('_innerOut' in serialized), 'toJSON: _innerOut stripped');
  assert(serialized.label === 'T', 'toJSON: normal attrs preserved');
}

/* ════════════════ Phase 10: TTL 7408 (Quad AND) ════════════════ */
section('TTL 7408: Quad AND gate');

{
  const c = new Circuit();
  const ic = c.addComponent(L.TTL_TYPES.TTL_7408, 0, 0);
  // Pin 1=1A (port 0), Pin 2=1B (port 1), Pin 3=1Y (port 2, output)
  const a = c.addComponent(PIN_TYPES.INPUT, -100, -30, { state: TRUE });
  const b = c.addComponent(PIN_TYPES.INPUT, -100, -18, { state: TRUE });
  const y = c.addComponent(PIN_TYPES.OUTPUT, 100, -30);

  // pinToPort: pin1=port0, pin2=port1, pin3=port2
  c.addWire(a.id, 0, ic.id, 0);  // 1A
  c.addWire(b.id, 0, ic.id, 1);  // 1B
  c.addWire(ic.id, 2, y.id, 0);  // 1Y

  assert(y.ports[0].value.isTrue(), '7408: 1&1=1 (gate 1)');

  a.attrs.state = FALSE; c.propagate();
  assert(y.ports[0].value.isFalse(), '7408: 0&1=0');

  b.attrs.state = FALSE; c.propagate();
  assert(y.ports[0].value.isFalse(), '7408: 0&0=0');
}

/* ════════════════ Phase 10: TTL 7400 (Quad NAND) ════════════════ */
section('TTL 7400: Quad NAND gate');

{
  const c = new Circuit();
  const ic = c.addComponent(L.TTL_TYPES.TTL_7400, 0, 0);
  const a = c.addComponent(PIN_TYPES.INPUT, -100, 0, { state: TRUE });
  const b = c.addComponent(PIN_TYPES.INPUT, -100, 12, { state: TRUE });
  const y = c.addComponent(PIN_TYPES.OUTPUT, 100, 0);
  c.addWire(a.id, 0, ic.id, 0);
  c.addWire(b.id, 0, ic.id, 1);
  c.addWire(ic.id, 2, y.id, 0);

  assert(y.ports[0].value.isFalse(), '7400: NAND(1,1)=0');
  a.attrs.state = FALSE; c.propagate();
  assert(y.ports[0].value.isTrue(), '7400: NAND(0,1)=1');
}

/* ════════════════ Phase 10: TTL 7404 (Hex Inverter) ════════════════ */
section('TTL 7404: Hex Inverter');

{
  const c = new Circuit();
  const ic = c.addComponent(L.TTL_TYPES.TTL_7404, 0, 0);
  // Pin 1=1A (port 0, input), Pin 2=1Y (port 1, output)
  const a = c.addComponent(PIN_TYPES.INPUT, -100, 0, { state: FALSE });
  const y = c.addComponent(PIN_TYPES.OUTPUT, 100, 0);
  c.addWire(a.id, 0, ic.id, 0);  // 1A
  c.addWire(ic.id, 1, y.id, 0);  // 1Y

  assert(y.ports[0].value.isTrue(), '7404: NOT(0)=1');
  a.attrs.state = TRUE; c.propagate();
  assert(y.ports[0].value.isFalse(), '7404: NOT(1)=0');
}

/* ════════════════ Phase 10: TTL 7404 Gate 4 (right-side pins) ════════════════ */
section('TTL 7404: Gate 4 (pin9→pin8, right side)');

{
  const c = new Circuit();
  const ic = c.addComponent(L.TTL_TYPES.TTL_7404, 0, 0);
  // Gate 4: pin9=4A(input), pin8=4Y(output)
  // pinToPort(9,14)=12, pinToPort(8,14)=13
  // But we need the INPUT index for pin9 and the OUTPUT port for pin8
  const a = c.addComponent(PIN_TYPES.INPUT, -100, 0, { state: TRUE });
  const y = c.addComponent(PIN_TYPES.OUTPUT, 100, 0);
  // Port for pin9: portIdx = 7+(14-9) = 12. Port for pin8: portIdx = 7+(14-8) = 13.
  c.addWire(a.id, 0, ic.id, 12);  // pin9 = 4A
  c.addWire(ic.id, 13, y.id, 0);  // pin8 = 4Y

  assert(y.ports[0].value.isFalse(), '7404 gate4: NOT(1)=0');
  a.attrs.state = FALSE; c.propagate();
  assert(y.ports[0].value.isTrue(), '7404 gate4: NOT(0)=1');
}

/* ════════════════ Phase 10: TTL 7402 (correct NOR pinout) ════════════════ */
section('TTL 7402: Quad NOR (correct pinout)');

{
  const c = new Circuit();
  const ic = c.addComponent(L.TTL_TYPES.TTL_7402, 0, 0);
  // Gate 1: pin2=1A(in), pin3=1B(in), pin1=1Y(out)
  // pinToPort: pin2=port1, pin3=port2, pin1=port0
  const a = c.addComponent(PIN_TYPES.INPUT, -100, -12, { state: FALSE });
  const b = c.addComponent(PIN_TYPES.INPUT, -100,   0, { state: FALSE });
  const y = c.addComponent(PIN_TYPES.OUTPUT, 100, 0);
  c.addWire(a.id, 0, ic.id, 1);  // pin2 = 1A
  c.addWire(b.id, 0, ic.id, 2);  // pin3 = 1B
  c.addWire(ic.id, 0, y.id, 0);  // pin1 = 1Y

  assert(y.ports[0].value.isTrue(), '7402: NOR(0,0)=1');
  a.attrs.state = TRUE; c.propagate();
  assert(y.ports[0].value.isFalse(), '7402: NOR(1,0)=0');
  a.attrs.state = FALSE; b.attrs.state = TRUE; c.propagate();
  assert(y.ports[0].value.isFalse(), '7402: NOR(0,1)=0');
}

/* ════════════════ Phase 10: TTL 7408 Gate 3 (right-side, previously broken) ════════════════ */
section('TTL 7408: Gate 3 (pin9,10→pin8)');

{
  const c = new Circuit();
  const ic = c.addComponent(L.TTL_TYPES.TTL_7408, 0, 0);
  // Gate 3: pin9=3A, pin10=3B → pin8=3Y
  // pinToPort: pin9=port12, pin10=port11, pin8=port13
  const a = c.addComponent(PIN_TYPES.INPUT, -100, -12, { state: TRUE });
  const b = c.addComponent(PIN_TYPES.INPUT, -100,   0, { state: TRUE });
  const y = c.addComponent(PIN_TYPES.OUTPUT, 100, 0);
  c.addWire(a.id, 0, ic.id, 12); // pin9 = 3A
  c.addWire(b.id, 0, ic.id, 11); // pin10 = 3B
  c.addWire(ic.id, 13, y.id, 0); // pin8 = 3Y

  assert(y.ports[0].value.isTrue(), '7408 gate3: AND(1,1)=1');
  a.attrs.state = FALSE; c.propagate();
  assert(y.ports[0].value.isFalse(), '7408 gate3: AND(0,1)=0');
}

/* ════════════════ Phase 10: TTL 7474 (Dual D-FF) ════════════════ */
section('TTL 7474: Dual D Flip-Flop');

{
  const c = new Circuit();
  const ic = c.addComponent(L.TTL_TYPES.TTL_7474, 0, 0);
  // FF1: CLR1=pin1(port0), D1=pin2(port1), CLK1=pin3(port2), SET1=pin4(port3)
  //      Q1=pin5(port4), Q1'=pin6(port5)
  const clr = c.addComponent(PIN_TYPES.INPUT, -100, -36, { state: TRUE });  // active LOW, so HIGH=not cleared
  const d   = c.addComponent(PIN_TYPES.INPUT, -100, -24, { state: TRUE });
  const clk = c.addComponent(PIN_TYPES.INPUT, -100, -12, { state: FALSE });
  const set = c.addComponent(PIN_TYPES.INPUT, -100,   0, { state: TRUE });  // active LOW, HIGH=not set
  const q   = c.addComponent(PIN_TYPES.OUTPUT, 100, -36);
  // pin5=Q1 → port index for pin5 on 14-pin DIP: pinToPort(5,14)
  // Left side: pin 1-7 = ports 0-6. So pin5 = port 4.
  // Right side: pin 14=port 7, pin 13=port 8, ..., pin 8=port 13
  c.addWire(clr.id, 0, ic.id, 0);  // CLR1
  c.addWire(d.id, 0, ic.id, 1);    // D1
  c.addWire(clk.id, 0, ic.id, 2);  // CLK1
  c.addWire(set.id, 0, ic.id, 3);  // SET1
  c.addWire(ic.id, 4, q.id, 0);    // Q1

  // Initial: Q=0
  assert(q.ports[0].value.isFalse(), '7474: initial Q1=0');

  // Rising edge with D=1 → Q=1
  clk.attrs.state = TRUE; c.propagate();
  assert(q.ports[0].value.isTrue(), '7474: D=1, rising edge → Q1=1');

  // Active-low clear
  clr.attrs.state = FALSE; c.propagate();
  assert(q.ports[0].value.isFalse(), '7474: CLR\'=LOW → Q1=0');
  clr.attrs.state = TRUE; c.propagate();

  // Active-low set
  set.attrs.state = FALSE; c.propagate();
  assert(q.ports[0].value.isTrue(), '7474: SET\'=LOW → Q1=1');
}

/* ════════════════ Phase 10: TTL 74138 (3:8 Decoder) ════════════════ */
section('TTL 74138: 3-to-8 Decoder');

{
  const c = new Circuit();
  const ic = c.addComponent(L.TTL_TYPES.TTL_74138, 0, 0);
  // 16-pin: left ports 0-7 = pins 1-8, right ports 8-15 = pins 16-9
  // Pin 1=A(port0), Pin 2=B(port1), Pin 3=C(port2)
  // Pin 4=G2A'(port3), Pin 5=G2B'(port4), Pin 6=G1(port5)
  // Pin 15=Y0'(port 8+[16-15]=port9) ... wait let me compute properly
  // Right side: port 8=pin16, port 9=pin15, port 10=pin14, port 11=pin13, port 12=pin12, port 13=pin11, port 14=pin10, port 15=pin9
  // So Y0'=pin15=port9, Y1'=pin14=port10, Y7'=pin7=port6

  const a   = c.addComponent(PIN_TYPES.INPUT, -100, -24, { state: FALSE });
  const b   = c.addComponent(PIN_TYPES.INPUT, -100, -12, { state: FALSE });
  const cv  = c.addComponent(PIN_TYPES.INPUT, -100,   0, { state: FALSE });
  const g2a = c.addComponent(PIN_TYPES.INPUT, -100,  12, { state: FALSE }); // active low → LOW = enabled
  const g2b = c.addComponent(PIN_TYPES.INPUT, -100,  24, { state: FALSE }); // active low
  const g1  = c.addComponent(PIN_TYPES.INPUT, -100,  36, { state: TRUE });  // active high
  const y0  = c.addComponent(PIN_TYPES.OUTPUT, 100, 0);

  c.addWire(a.id, 0, ic.id, 0);    // A
  c.addWire(b.id, 0, ic.id, 1);    // B
  c.addWire(cv.id, 0, ic.id, 2);   // C
  c.addWire(g2a.id, 0, ic.id, 3);  // G2A'
  c.addWire(g2b.id, 0, ic.id, 4);  // G2B'
  c.addWire(g1.id, 0, ic.id, 5);   // G1

  // Y0' = pin 15 → port 9
  c.addWire(ic.id, 9, y0.id, 0);

  // Address 000, enabled → Y0' = LOW (active low = selected)
  assert(y0.ports[0].value.isFalse(), '74138: addr=0, enabled → Y0\'=LOW (selected)');

  // Address 001 → Y0' = HIGH (not selected)
  a.attrs.state = TRUE; c.propagate();
  assert(y0.ports[0].value.isTrue(), '74138: addr=1 → Y0\'=HIGH');

  // Disable (G1=LOW)
  a.attrs.state = FALSE;
  g1.attrs.state = FALSE; c.propagate();
  assert(y0.ports[0].value.isTrue(), '74138: disabled → Y0\'=HIGH');
}

/* ════════════════ Phase 10: Pin↔Port mapping ════════════════ */
section('TTL pin↔port mapping');

{
  const { pinToPort, portToPin } = L.TTL;
  // 14-pin DIP
  assert(pinToPort(1, 14) === 0, 'pin1→port0');
  assert(pinToPort(7, 14) === 6, 'pin7→port6');
  assert(pinToPort(14, 14) === 7, 'pin14→port7 (top-right)');
  assert(pinToPort(8, 14) === 13, 'pin8→port13 (bottom-right)');
  assert(pinToPort(11, 14) === 10, 'pin11→port10');

  assert(portToPin(0, 14) === 1, 'port0→pin1');
  assert(portToPin(6, 14) === 7, 'port6→pin7');
  assert(portToPin(7, 14) === 14, 'port7→pin14');
  assert(portToPin(13, 14) === 8, 'port13→pin8');
}

/* ════════════════ Phase 11: Undo/Redo History ════════════════ */
section('Undo/Redo History');

{
  const h = new L.History(10);
  const c1 = { components: [{ id: 'c1', type: 'INPUT' }], wires: [] };
  const c2 = { components: [{ id: 'c1' }, { id: 'c2' }], wires: [] };
  const c3 = { components: [{ id: 'c1' }, { id: 'c2' }, { id: 'c3' }], wires: [] };

  h.push(c1);
  h.push(c2);
  h.push(c3);
  assert(h.canUndo(), 'History: can undo');
  assert(!h.canRedo(), 'History: cannot redo');

  const u1 = h.undo();
  assert(u1.components.length === 2, 'Undo: restored 2 components');
  assert(h.canRedo(), 'History: can redo after undo');

  const u2 = h.undo();
  assert(u2.components.length === 1, 'Undo again: restored 1 component');
  assert(!h.canUndo(), 'History: cannot undo past beginning');

  const r1 = h.redo();
  assert(r1.components.length === 2, 'Redo: restored 2 components');

  // Push after undo truncates redo stack
  h.push({ components: [{ id: 'x' }], wires: [] });
  assert(!h.canRedo(), 'History: redo truncated after new push');

  // Lock prevents recording
  h.lock();
  h.push({ components: [], wires: [] });
  h.unlock();
  const afterLock = h.undo();
  assert(afterLock.components.length === 2, 'History: locked push was ignored');
}

/* ════════════════ Phase 11: Presets — build all ════════════════ */
section('Presets: build all without error');

const ALL = Object.assign({}, GATE_TYPES, PIN_TYPES,
  { CLOCK: CLOCK_TYPE }, WIRING_TYPES, IO_TYPES, MEMORY_TYPES, ARITH_TYPES, DISPLAY_TYPES);

{
  let buildOK = 0;
  for (const preset of L.PRESETS) {
    const c = new Circuit();
    try {
      preset.build(c, ALL);
      assert(c.components.size > 0, 'Preset "' + preset.name + '": has components');
      buildOK++;
    } catch(e) {
      assert(false, 'Preset "' + preset.name + '" build failed: ' + e.message);
    }
  }
  assert(buildOK === L.PRESETS.length, 'All ' + L.PRESETS.length + ' presets built successfully');
}

/* ════════════════ Preset: Half Adder — full truth table ════════════════ */
section('Preset: Half Adder correctness');

{
  const c = new Circuit();
  L.PRESETS.find(p => p.name === 'Half Adder').build(c, ALL);
  const analyzer = new L.Analyzer(c);
  const tt = analyzer.generateTruthTable();
  assert(tt.numInputs === 2, 'Half Adder: 2 inputs');
  // Outputs sorted alphabetically: Carry, Sum
  const ci = tt.outputNames.indexOf('Carry');
  const si = tt.outputNames.indexOf('Sum');
  assert(ci >= 0 && si >= 0, 'Half Adder: has Carry and Sum outputs');
  // 0+0=S0,C0  0+1=S1,C0  1+0=S1,C0  1+1=S0,C1
  assert(tt.rows[0].out[si] === 0 && tt.rows[0].out[ci] === 0, 'HA: 0+0 = S0,C0');
  assert(tt.rows[1].out[si] === 1 && tt.rows[1].out[ci] === 0, 'HA: 0+1 = S1,C0');
  assert(tt.rows[2].out[si] === 1 && tt.rows[2].out[ci] === 0, 'HA: 1+0 = S1,C0');
  assert(tt.rows[3].out[si] === 0 && tt.rows[3].out[ci] === 1, 'HA: 1+1 = S0,C1');
}

/* ════════════════ Preset: Full Adder — full truth table ════════════════ */
section('Preset: Full Adder correctness');

{
  const c = new Circuit();
  L.PRESETS.find(p => p.name === 'Full Adder').build(c, ALL);
  const analyzer = new L.Analyzer(c);
  const tt = analyzer.generateTruthTable();
  assert(tt.numInputs === 3, 'Full Adder: 3 inputs');
  const ci = tt.outputNames.indexOf('Cout');
  const si = tt.outputNames.indexOf('Sum');
  assert(ci >= 0 && si >= 0, 'Full Adder: has Cout and Sum outputs');
  // Full adder truth table: A+B+Cin
  const expected = [
    [0,0], [1,0], [1,0], [0,1], // Cin=0: 0+0,0+1,1+0,1+1
    [1,0], [0,1], [0,1], [1,1]  // Cin=1: 0+0,0+1,1+0,1+1
  ];
  for (let i = 0; i < 8; i++) {
    assert(tt.rows[i].out[si] === expected[i][0], 'FA row ' + i + ' Sum=' + expected[i][0]);
    assert(tt.rows[i].out[ci] === expected[i][1], 'FA row ' + i + ' Cout=' + expected[i][1]);
  }
}

/* ════════════════ Preset: AND Truth Table ════════════════ */
section('Preset: AND Truth Table correctness');

{
  const c = new Circuit();
  L.PRESETS.find(p => p.name === 'AND Truth Table').build(c, ALL);
  const analyzer = new L.Analyzer(c);
  const tt = analyzer.generateTruthTable();
  assert(tt.numInputs === 2, 'AND: 2 inputs');
  assert(tt.rows[0].out[0] === 0, 'AND: 00→0');
  assert(tt.rows[1].out[0] === 0, 'AND: 01→0');
  assert(tt.rows[2].out[0] === 0, 'AND: 10→0');
  assert(tt.rows[3].out[0] === 1, 'AND: 11→1');
}

/* ════════════════ Preset: 2:1 MUX ════════════════ */
section('Preset: 2:1 MUX correctness');

{
  const c = new Circuit();
  L.PRESETS.find(p => p.name === '2:1 MUX').build(c, ALL);
  const analyzer = new L.Analyzer(c);
  const tt = analyzer.generateTruthTable();
  assert(tt.numInputs === 3, 'MUX: 3 inputs (D0, D1, SEL)');
  // Inputs sorted: D0, D1, SEL (alphabetical)
  // SEL=0→D0, SEL=1→D1
  // Row format: D0,D1,SEL → Y
  // 000→0, 001→0, 010→0, 011→1, 100→1, 101→0, 110→1, 111→1
  const exp = [0, 0, 0, 1, 1, 0, 1, 1];
  for (let i = 0; i < 8; i++) {
    assert(tt.rows[i].out[0] === exp[i], 'MUX row ' + i + ' → ' + exp[i]);
  }
}

/* ════════════════ Preset: XOR from NAND — full truth table ════════════════ */
section('Preset: XOR from NAND correctness');

{
  const c = new Circuit();
  L.PRESETS.find(p => p.name === 'XOR from NAND').build(c, ALL);
  const analyzer = new L.Analyzer(c);
  const tt = analyzer.generateTruthTable();
  assert(tt.numInputs === 2, 'XOR-NAND: 2 inputs');
  assert(tt.rows[0].out[0] === 0, 'XOR-NAND: 00→0');
  assert(tt.rows[1].out[0] === 1, 'XOR-NAND: 01→1');
  assert(tt.rows[2].out[0] === 1, 'XOR-NAND: 10→1');
  assert(tt.rows[3].out[0] === 0, 'XOR-NAND: 11→0');
}

/* ════════════════ Preset: D Flip-Flop — functional test ════════════════ */
section('Preset: D Flip-Flop correctness');

{
  const c = new Circuit();
  L.PRESETS.find(p => p.name === 'D Flip-Flop').build(c, ALL);
  // Find components by label
  const inputs = [...c.components.values()].filter(x => x.type === 'INPUT');
  const outputs = [...c.components.values()].filter(x => x.type === 'OUTPUT');
  const dIn = inputs.find(x => x.attrs.label === 'D');
  const clkIn = inputs.find(x => x.attrs.label === 'CLK');
  const clrIn = inputs.find(x => x.attrs.label === 'CLR');
  const qOut = outputs.find(x => x.attrs.label === 'Q');
  assert(dIn && clkIn && clrIn && qOut, 'D-FF preset: all pins found');

  // Initial: Q=0
  assert(qOut.ports[0].value.isFalse(), 'D-FF preset: initial Q=0');

  // Set D=1, rising edge → Q=1
  dIn.attrs.state = TRUE;
  clkIn.attrs.state = TRUE; c.propagate();
  assert(qOut.ports[0].value.isTrue(), 'D-FF preset: D=1 edge → Q=1');

  // D=0, new edge → Q=0
  dIn.attrs.state = FALSE;
  clkIn.attrs.state = FALSE; c.propagate();
  clkIn.attrs.state = TRUE; c.propagate();
  assert(qOut.ports[0].value.isFalse(), 'D-FF preset: D=0 edge → Q=0');
}

/* ════════════════ Preset: 4-bit Counter — functional test ════════════════ */
section('Preset: 4-bit Counter correctness');

{
  const c = new Circuit();
  L.PRESETS.find(p => p.name === '4-bit Counter').build(c, ALL);
  const ctr = [...c.components.values()].find(x => x.type === 'COUNTER');
  const clk = [...c.components.values()].find(x => x.type === 'CLOCK');
  assert(ctr && clk, 'Counter preset: counter and clock found');

  // Manual clock pulses
  assert(ctr.attrs._val === 0, 'Counter preset: initial=0');
  clk.attrs.state = TRUE; c.propagate();
  clk.attrs.state = FALSE; c.propagate();
  assert(ctr.attrs._val === 1, 'Counter preset: after 1 pulse = 1');
  clk.attrs.state = TRUE; c.propagate();
  clk.attrs.state = FALSE; c.propagate();
  assert(ctr.attrs._val === 2, 'Counter preset: after 2 pulses = 2');
}

/* ════════════════ Preset: 7-Segment Decoder — structure check ════════════════ */
section('Preset: 7-Segment Decoder correctness');

{
  const c = new Circuit();
  L.PRESETS.find(p => p.name === '7-Segment Decoder').build(c, ALL);
  const switches = [...c.components.values()].filter(x => x.type === 'SWITCH');
  const hexDisps = [...c.components.values()].filter(x => x.type === 'HEX_DISPLAY');
  assert(switches.length === 4, '7-Seg preset: 4 switches');
  assert(hexDisps.length === 1, '7-Seg preset: exactly 1 hex display');
  assert(c.wires.size === 4, '7-Seg preset: 4 wires (each switch → display)');
}

/* ════════════════ Preset: SR Latch — functional test ════════════════ */
section('Preset: SR Latch correctness');

{
  const c = new Circuit();
  L.PRESETS.find(p => p.name === 'SR Latch').build(c, ALL);
  const inputs = [...c.components.values()].filter(x => x.type === 'INPUT');
  const outputs = [...c.components.values()].filter(x => x.type === 'OUTPUT');
  const sIn = inputs.find(x => x.attrs.label === 'S');
  const clkIn = inputs.find(x => x.attrs.label === 'CLK');
  const rIn = inputs.find(x => x.attrs.label === 'R');
  const qOut = outputs.find(x => x.attrs.label === 'Q');
  assert(sIn && clkIn && rIn && qOut, 'SR Latch: all pins found');

  // Set: S=1, R=0, rising edge → Q=1
  sIn.attrs.state = TRUE;
  clkIn.attrs.state = TRUE; c.propagate();
  assert(qOut.ports[0].value.isTrue(), 'SR Latch: Set → Q=1');

  // Reset: S=0, R=1, new edge → Q=0
  sIn.attrs.state = FALSE; rIn.attrs.state = TRUE;
  clkIn.attrs.state = FALSE; c.propagate();
  clkIn.attrs.state = TRUE; c.propagate();
  assert(qOut.ports[0].value.isFalse(), 'SR Latch: Reset → Q=0');
}

/* ════════════════ Preset: Clock + LED — structure check ════════════════ */
section('Preset: Clock + LED structure');

{
  const c = new Circuit();
  L.PRESETS.find(p => p.name === 'Clock + LED').build(c, ALL);
  const clk = [...c.components.values()].find(x => x.type === 'CLOCK');
  const led = [...c.components.values()].find(x => x.type === 'LED');
  assert(clk && led, 'Clock+LED: both components exist');
  assert(c.wires.size === 1, 'Clock+LED: 1 wire');
}

/* ════════════════ Summary ════════════════ */
console.log('\n═══════════════════════════════');
console.log(`  ${pass} passed, ${fail} failed`);
console.log('═══════════════════════════════');
process.exit(fail > 0 ? 1 : 0);
