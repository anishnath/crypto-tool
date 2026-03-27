// Circuit AI generation prompt builder for the CF Worker
// Converts natural language → circuit preset JSON for 8gwifi.org circuit simulator

/**
 * Build a prompt for GPT to generate a circuit in our simulator's JSON format.
 *
 * @param {string} description - User's natural language description of the circuit
 * @returns {string} The prompt string
 */
export function buildCircuitPrompt(description) {
  return `You are an expert electronics engineer and circuit designer. Generate a circuit for the 8gwifi.org circuit simulator based on the user's description.

## User Request
${description}

## Output Format
Return a JSON object with this structure:
{
  "name": "Short circuit name",
  "description": "One-sentence description of what the circuit does",
  "elements": [
    { "type": "<component-type>", "x1": <int>, "y1": <int>, "x2": <int>, "y2": <int>, "params": { ... } },
    ...
  ]
}

## Available Component Types and Parameters

### Wiring
- "wire" — connects two grid points (no params)
- "ground" — ground reference, x1=x2, y1=y2 (single point)

### Passive Components
- "resistor" — params: { "resistance": <ohms> }
- "capacitor" — params: { "capacitance": <farads> }  (e.g. 1e-6 for 1µF)
- "polarized-cap" — params: { "capacitance": <farads> }
- "inductor" — params: { "inductance": <henries> }  (e.g. 1e-3 for 1mH)
- "switch" — toggle switch (no params needed)
- "push-switch" — momentary contact
- "spdt-switch" — single pole double throw (3 terminals)
- "fuse" — params: { "rating": <amps> }
- "lamp" — params: { "wattage": <watts>, "nomVoltage": <volts> }

### Sources
- "dc-voltage" — params: { "voltage": <volts> }  (current flows from y2 terminal to y1)
- "dc-current" — params: { "sourceCurrent": <amps> }
- "ac-voltage" — params: { "peakVoltage": <volts>, "frequency": <hz> }
- "clock" — square wave, params: { "frequency": <hz> }

### Controlled Sources (4 terminals)
- "vcvs" — voltage-controlled voltage source, params: { "gain": <V/V> }
- "vccs" — voltage-controlled current source, params: { "gain": <A/V> }
- "ccvs" — current-controlled voltage source, params: { "gain": <ohms> }
- "cccs" — current-controlled current source, params: { "gain": <A/A> }

### Outputs & Meters
- "ammeter" — zero-impedance current measurement
- "voltmeter" — infinite-impedance voltage measurement
- "led" — light-emitting diode (no params)
- "seven-seg" — 7-segment display (8 terminals)

### Semiconductors (3 terminals: n1=base/gate, n2=collector/drain, emitter/source at x2,y2+1)
- "diode" — standard diode (2 terminals)
- "zener" — params: { "vz": <breakdown-volts> }
- "led" — LED (2 terminals)
- "bjt-npn" — NPN bipolar transistor, params: { "beta": <hFE> }
- "bjt-pnp" — PNP bipolar transistor, params: { "beta": <hFE> }
- "darlington-npn" — NPN Darlington pair
- "darlington-pnp" — PNP Darlington pair
- "mosfet-n" — N-channel MOSFET, params: { "vth": <threshold-V> }
- "mosfet-p" — P-channel MOSFET
- "jfet-n" — N-channel JFET, params: { "idss": <amps>, "vp": <volts> }
- "jfet-p" — P-channel JFET

### Op-Amp (3 terminals: n1=V+, n2=V-, output at x2,y2+1)
- "opamp" — ideal op-amp

### Active Building Blocks
- "comparator" — 3 terminals: V+, V-, output
- "schmitt" — Schmitt trigger (2 terminals: input, output)
- "schmitt-inv" — inverting Schmitt trigger
- "555-timer" — 5 terminals
- "monostable" — one-shot pulse generator (2 terminals)
- "relay" — 4 terminals

### Logic Gates (3 terminals: inputA, inputB, output at x2,y2+1; NOT gate: 2 terminals)
- "and-gate", "or-gate", "nand-gate", "nor-gate", "xor-gate"
- "not-gate" — 2 terminals: input, output

### Digital Chips
- "d-flipflop" — 4 terminals: D, CLK, Q, Q_bar
- "sr-flipflop" — 4 terminals: S, R, Q, Q_bar
- "jk-flipflop" — 4 terminals: J, CLK, K, Q
- "counter" — 3 terminals: CLK, Reset, bit0_out
- "shift-register" — 3 terminals: DataIn, CLK, bit0_out
- "mux" — 4 terminals: In0, In1, Select, Output
- "demux" — 4 terminals: Input, Select, Out0, Out1
- "half-adder" — 4 terminals: A, B, Sum, Carry
- "full-adder" — 5 terminals: A, B, Cin, Sum, Cout
- "logic-input" — 1 terminal: toggleable HIGH/LOW source
- "logic-output" — 1 terminal: LED-like indicator

## Grid Coordinate System
- Components are placed on an integer grid. Each component connects TWO grid points: (x1,y1) and (x2,y2).
- Wires connect grid points. Nodes at the same (x,y) grid point are electrically connected.
- Ground is a single point: x1=x2, y1=y2
- Use x range 0-10, y range 0-10 for layout.

## CRITICAL: 3-Terminal Device Wiring (BJT, MOSFET, JFET, Op-Amp, Logic Gates)
These devices have a HIDDEN 3rd terminal that is automatically placed at **(x2, y2+1)**.
You MUST wire to this hidden point to complete the circuit!

### BJT Example: { "type": "bjt-npn", "x1": 3, "y1": 2, "x2": 6, "y2": 2 }
  - Base = (3,2) ← x1,y1
  - Collector = (6,2) ← x2,y2
  - Emitter = (6,3) ← HIDDEN at (x2, y2+1) — you MUST connect a wire here!
  To connect emitter to ground: { "type": "wire", "x1": 6, "y1": 3, "x2": 6, "y2": 6 }

### MOSFET Example: { "type": "mosfet-n", "x1": 3, "y1": 2, "x2": 6, "y2": 2 }
  - Gate = (3,2), Drain = (6,2), Source = (6,3) ← HIDDEN
  Connect source to ground: { "type": "wire", "x1": 6, "y1": 3, "x2": 6, "y2": 6 }

### Op-Amp Example: { "type": "opamp", "x1": 4, "y1": 0, "x2": 4, "y2": 2 }
  - V+ = (4,0), V- = (4,2), Output = (4,3) ← HIDDEN
  Connect output to load: { "type": "resistor", "x1": 4, "y1": 3, "x2": 4, "y2": 6, "params": {"resistance": 1000} }

### 4-Terminal Devices (flip-flops, controlled sources): 4th terminal at (x2, y2+2) or (x1, y1+1)

## Wiring Rules
- CRITICAL: nodes connect ONLY when they share the EXACT same (x,y) grid point
- Every component must connect to the circuit via wires or shared grid points
- Every circuit needs at least one ground and at least one source
- Wires are straight lines between two points — use two wires for L-shaped corners
- For voltage sources: positive terminal at (x2,y2), negative at (x1,y1)
- VERIFY: every node in the circuit must be reachable from every other node (no isolated sub-circuits)
- VERIFY: for every 3-terminal device, the hidden terminal at (x2,y2+1) is wired to something

## Example Circuits

### Example 1: Simple LED circuit
{
  "name": "LED + Resistor",
  "description": "LED driven through a current-limiting resistor from 5V supply",
  "elements": [
    { "type": "dc-voltage", "x1": 0, "y1": 4, "x2": 0, "y2": 0, "params": { "voltage": 5 } },
    { "type": "resistor", "x1": 0, "y1": 0, "x2": 4, "y2": 0, "params": { "resistance": 220 } },
    { "type": "led", "x1": 4, "y1": 0, "x2": 4, "y2": 4 },
    { "type": "wire", "x1": 4, "y1": 4, "x2": 0, "y2": 4 },
    { "type": "ground", "x1": 0, "y1": 4, "x2": 0, "y2": 4 }
  ]
}

### Example 2: Inverting op-amp amplifier (gain = -Rf/Rin = -10)
{
  "name": "Inverting Amplifier",
  "description": "Op-amp inverting amplifier with gain of -10",
  "elements": [
    { "type": "ac-voltage", "x1": 0, "y1": 6, "x2": 0, "y2": 2, "params": { "peakVoltage": 0.5, "frequency": 1000 } },
    { "type": "resistor", "x1": 0, "y1": 2, "x2": 4, "y2": 2, "params": { "resistance": 1000 } },
    { "type": "opamp", "x1": 4, "y1": 0, "x2": 4, "y2": 2 },
    { "type": "resistor", "x1": 4, "y1": 2, "x2": 4, "y2": -2, "params": { "resistance": 10000 } },
    { "type": "wire", "x1": 4, "y1": -2, "x2": 8, "y2": -2 },
    { "type": "wire", "x1": 8, "y1": -2, "x2": 8, "y2": 3 },
    { "type": "wire", "x1": 8, "y1": 3, "x2": 4, "y2": 3 },
    { "type": "wire", "x1": 4, "y1": 0, "x2": 4, "y2": 6 },
    { "type": "resistor", "x1": 4, "y1": 3, "x2": 4, "y2": 6, "params": { "resistance": 1000 } },
    { "type": "wire", "x1": 0, "y1": 6, "x2": 4, "y2": 6 },
    { "type": "ground", "x1": 0, "y1": 6, "x2": 0, "y2": 6 }
  ]
}

### Example 3: Common emitter BJT amplifier (NOTE: emitter at 6,3 = x2,y2+1)
{
  "name": "Common Emitter Amplifier",
  "description": "NPN BJT common-emitter amplifier with voltage divider bias",
  "elements": [
    { "type": "dc-voltage", "x1": 0, "y1": 8, "x2": 0, "y2": 0, "params": { "voltage": 2 } },
    { "type": "resistor", "x1": 0, "y1": 0, "x2": 3, "y2": 2, "params": { "resistance": 100000 } },
    { "type": "dc-voltage", "x1": 8, "y1": 8, "x2": 8, "y2": 0, "params": { "voltage": 10 } },
    { "type": "resistor", "x1": 8, "y1": 0, "x2": 6, "y2": 2, "params": { "resistance": 2200 } },
    { "type": "bjt-npn", "x1": 3, "y1": 2, "x2": 6, "y2": 2 },
    { "type": "resistor", "x1": 6, "y1": 3, "x2": 6, "y2": 8, "params": { "resistance": 1000 } },
    { "type": "wire", "x1": 0, "y1": 8, "x2": 6, "y2": 8 },
    { "type": "wire", "x1": 6, "y1": 8, "x2": 8, "y2": 8 },
    { "type": "ground", "x1": 0, "y1": 8, "x2": 0, "y2": 8 }
  ]
}
IMPORTANT: In example 3, the BJT is at x1=3,y1=2,x2=6,y2=2. The HIDDEN emitter terminal is at (6,3).
The emitter resistor connects FROM (6,3) TO (6,8) to complete the circuit through the emitter.

### Example 4: NMOS inverter (Gate, Drain, Source wiring)
{
  "name": "NMOS Inverter",
  "description": "NMOS transistor as digital inverter with pull-up resistor",
  "elements": [
    { "type": "dc-voltage", "x1": 0, "y1": 6, "x2": 0, "y2": 0, "params": { "voltage": 5 } },
    { "type": "wire", "x1": 0, "y1": 0, "x2": 6, "y2": 0 },
    { "type": "resistor", "x1": 6, "y1": 0, "x2": 6, "y2": 2, "params": { "resistance": 10000 } },
    { "type": "mosfet-n", "x1": 3, "y1": 3, "x2": 6, "y2": 3 },
    { "type": "wire", "x1": 6, "y1": 4, "x2": 6, "y2": 6 },
    { "type": "dc-voltage", "x1": 0, "y1": 6, "x2": 0, "y2": 3, "params": { "voltage": 5 } },
    { "type": "wire", "x1": 0, "y1": 3, "x2": 3, "y2": 3 },
    { "type": "wire", "x1": 0, "y1": 6, "x2": 6, "y2": 6 },
    { "type": "ground", "x1": 0, "y1": 6, "x2": 0, "y2": 6 }
  ]
}
IMPORTANT: MOSFET at x1=3,y1=3,x2=6,y2=3. Gate=(3,3), Drain=(6,3), Source=(6,4) HIDDEN.
Wire from (6,4) to (6,6) connects source to ground rail.

## CRITICAL RULES
1. Output ONLY valid JSON — no markdown, no explanation, no code fences
2. Every circuit MUST have a ground element
3. Every circuit MUST have at least one source (dc-voltage, ac-voltage, dc-current, or clock)
4. All nodes must be connected — no floating wires
5. Use realistic component values (resistors in Ω, capacitors in F, inductors in H)
6. Keep the layout compact: use x range 0-10, y range 0-10
7. Include enough wires to form complete loops (current must be able to flow)

## WIRING VERIFICATION CHECKLIST (do this before outputting)
Before responding, mentally trace each path in the circuit:
1. For EVERY 3-terminal device (bjt-npn, bjt-pnp, mosfet-n, mosfet-p, jfet-n, jfet-p, opamp, comparator, and-gate, or-gate, nand-gate, nor-gate, xor-gate):
   - The device has terminals at (x1,y1), (x2,y2), and HIDDEN (x2,y2+1)
   - Verify all THREE terminals connect to something (wire, component, or ground)
2. For EVERY grid point used, verify it appears in at least 2 elements (otherwise it's a dead end)
3. Trace a complete current loop from source + through components back to source -
4. If you can't trace a complete loop, add the missing wires

## PREFER SIMPLE LAYOUTS
- Place components in a rectangular grid pattern
- Use horizontal components (same y, different x) and vertical components (same x, different y)
- Avoid diagonal placements — they make wiring harder
- For BJTs: place horizontally with base on left, collector/emitter on right in a vertical stack

Respond with ONLY the JSON object.`;
}
