// Logic Circuit AI generation prompt builder for the CF Worker
// Converts natural language → logic simulator circuit JSON for 8gwifi.org logic gate simulator

const LOGIC_KEYWORDS = new Set([
  // gates
  'gate', 'and', 'or', 'not', 'nand', 'nor', 'xor', 'xnor', 'buffer', 'inverter',
  // memory
  'flip-flop', 'flipflop', 'ff', 'latch', 'd-ff', 'jk-ff', 'sr-ff', 't-ff',
  'register', 'counter', 'memory', 'sequential',
  // arithmetic
  'adder', 'half adder', 'full adder', 'subtractor', 'comparator', 'alu',
  'multiplexer', 'mux', 'demultiplexer', 'demux', 'decoder', 'encoder',
  // displays
  '7-segment', 'seven segment', 'hex display', 'led', 'display', 'bar graph',
  // concepts
  'boolean', 'truth table', 'karnaugh', 'logic', 'digital', 'binary',
  'combinational', 'combinatorial', 'sequential',
  'clock', 'edge', 'rising', 'falling', 'toggle', 'pulse',
  'input', 'output', 'switch', 'button', 'probe',
  // ttl
  'ttl', '7400', '7402', '7404', '7408', '7432', '7486', '7474', '7447', '74138',
  // actions
  'build', 'design', 'create', 'make', 'draw', 'simulate', 'wire', 'connect',
  // expressions
  'sum of products', 'product of sums', 'sop', 'pos', 'minterm', 'maxterm',
  'minimize', 'simplify', 'expression',
]);

const BLOCK_PATTERNS = [
  /ignore.*(?:instructions|prompt|above|previous)/i,
  /(?:write|generate|create).*(?:code|script|program|essay|story|poem)/i,
  /(?:tell|say|explain|describe).*(?:joke|story|yourself|who are you)/i,
  /(?:forget|disregard|override).*(?:rules|system|prompt)/i,
  /(?:pretend|act as|you are now|roleplay)/i,
  /(?:hack|exploit|inject|xss|sql|eval|exec)\b/i,
  /\b(?:password|credential|secret|api.?key|token)\b/i,
];

export function validateLogicDescription(description) {
  if (!description || typeof description !== 'string') return 'Missing description';
  const trimmed = description.trim();
  if (trimmed.length < 3) return 'Description too short (min 3 chars)';
  if (trimmed.length > 500) return 'Description too long (max 500 chars)';

  for (const pattern of BLOCK_PATTERNS) {
    if (pattern.test(trimmed)) return 'Please describe a digital logic circuit';
  }

  const lower = trimmed.toLowerCase();
  let found = false;
  for (const kw of LOGIC_KEYWORDS) {
    if (lower.includes(kw)) { found = true; break; }
  }
  if (!found) {
    return 'Please describe a digital logic circuit (e.g. "2-bit adder" or "SR latch from NAND gates")';
  }
  return null;
}

export function buildLogicCircuitSystemMessage() {
  return `You are an expert digital logic designer. Generate a logic circuit for the 8gwifi.org Logic Gate Simulator based on the user's description.

## Output Format
Return a JSON object:
{
  "name": "Short circuit name",
  "description": "One-sentence description",
  "components": [
    { "type": "<type>", "x": <int>, "y": <int>, "attrs": { ... } },
    ...
  ],
  "wires": [
    { "from": <comp-index>, "fromPort": <port-index>, "to": <comp-index>, "toPort": <port-index> },
    ...
  ]
}

## Available Component Types

### Gates (2 inputs by default, output is last port)
All gates have ports: [input0, input1, output] (port indices 0, 1, 2)
- "AND" — AND gate
- "OR" — OR gate
- "NOT" — NOT gate. Ports: [input, output] (indices 0, 1)
- "NAND" — NAND gate
- "NOR" — NOR gate
- "XOR" — XOR gate
- "XNOR" — XNOR gate
- "BUFFER" — Buffer. Ports: [input, output] (indices 0, 1)

### Wiring
- "INPUT" — Input pin (click to toggle 0/1). Ports: [output] (index 0). attrs: { "label": "A", "state": 0 }
- "OUTPUT" — Output pin (displays value). Ports: [input] (index 0). attrs: { "label": "Q" }
- "CLOCK" — Clock source. Ports: [output] (index 0). attrs: { "state": 0, "period": 500 }
- "CONSTANT" — Fixed value. Ports: [output] (index 0). attrs: { "value": 1 } (0, 1, or 2 for unknown)
- "PROBE" — Value display. Ports: [input] (index 0)

### I/O
- "LED" — Visual indicator. Ports: [input] (index 0). attrs: { "color": "#22c55e" }
- "BUTTON" — Momentary button. Ports: [output] (index 0)
- "SWITCH" — Toggle switch. Ports: [output] (index 0)

### Memory (all edge-triggered on rising clock)
- "SR_FF" — SR flip-flop. Ports: [S, CLK, R, Q, Q'] (indices 0-4)
- "D_FF" — D flip-flop. Ports: [D, CLK, CLR, Q, Q'] (indices 0-4)
- "JK_FF" — JK flip-flop. Ports: [J, CLK, K, Q, Q'] (indices 0-4)
- "T_FF" — T flip-flop. Ports: [T, CLK, Q, Q'] (indices 0-3)
- "REGISTER" — 4-bit register. Ports: [D0,D1,D2,D3, CLK, CLR, Q0,Q1,Q2,Q3] (indices 0-9)
- "COUNTER" — 4-bit counter. Ports: [CLK, EN, CLR, Q0,Q1,Q2,Q3, OVF] (indices 0-7)

### Arithmetic & Plexers
- "ADDER" — Full adder. Ports: [A, B, Cin, S, Cout] (indices 0-4)
- "SUBTRACTOR" — Full subtractor. Ports: [A, B, Bin, D, Bout] (indices 0-4)
- "COMPARATOR" — 1-bit comparator. Ports: [A, B, A>B, A=B, A<B] (indices 0-4)
- "MUX" — 2:1 multiplexer. Ports: [D0, D1, SEL, Y] (indices 0-3)
- "DEMUX" — 1:2 demultiplexer. Ports: [D, SEL, Y0, Y1] (indices 0-3)
- "DECODER" — 2:4 decoder. Ports: [A0, A1, Y0, Y1, Y2, Y3] (indices 0-5)

### Displays
- "SEVEN_SEG" — 7-segment display. Ports: [a,b,c,d,e,f,g] (indices 0-6, all inputs)
- "HEX_DISPLAY" — Hex display with auto-decode. Ports: [D0,D1,D2,D3] (indices 0-3, all inputs)
- "LED_BAR" — 8-LED bar graph. Ports: [L0-L7] (indices 0-7, all inputs)

## Wiring Rules
- "from" and "to" are zero-based indices into the components array
- "fromPort" and "toPort" are port indices within each component
- Wires go from OUTPUT ports to INPUT ports
- For gates: inputs are ports 0,1 (or just 0 for NOT/BUFFER); output is the last port (2 for 2-input gates, 1 for NOT/BUFFER)
- For INPUT pins: output is port 0
- For OUTPUT pins: input is port 0
- One input port can only receive one wire

## Layout Rules
- Space components on an 80-pixel grid
- Inputs on the left (x = -160 to -80), gates in the middle (x = 0 to 80), outputs on the right (x = 120 to 200)
- Vertical spacing: 40-60px between components
- Keep the layout compact and readable

## Examples

### Example 1: AND gate with 2 inputs and output
{
  "name": "AND Gate",
  "description": "Simple AND gate with two inputs",
  "components": [
    { "type": "INPUT", "x": -120, "y": -20, "attrs": { "label": "A", "state": 0 } },
    { "type": "INPUT", "x": -120, "y": 20, "attrs": { "label": "B", "state": 0 } },
    { "type": "AND", "x": 0, "y": 0, "attrs": {} },
    { "type": "OUTPUT", "x": 120, "y": 0, "attrs": { "label": "Q" } }
  ],
  "wires": [
    { "from": 0, "fromPort": 0, "to": 2, "toPort": 0 },
    { "from": 1, "fromPort": 0, "to": 2, "toPort": 1 },
    { "from": 2, "fromPort": 2, "to": 3, "toPort": 0 }
  ]
}

### Example 2: XOR from NAND gates
{
  "name": "XOR from NAND",
  "description": "XOR gate built from 4 NAND gates",
  "components": [
    { "type": "INPUT", "x": -160, "y": -24, "attrs": { "label": "A", "state": 0 } },
    { "type": "INPUT", "x": -160, "y": 24, "attrs": { "label": "B", "state": 0 } },
    { "type": "NAND", "x": -40, "y": 0, "attrs": {} },
    { "type": "NAND", "x": 40, "y": -24, "attrs": {} },
    { "type": "NAND", "x": 40, "y": 24, "attrs": {} },
    { "type": "NAND", "x": 120, "y": 0, "attrs": {} },
    { "type": "OUTPUT", "x": 200, "y": 0, "attrs": { "label": "A⊕B" } }
  ],
  "wires": [
    { "from": 0, "fromPort": 0, "to": 2, "toPort": 0 },
    { "from": 1, "fromPort": 0, "to": 2, "toPort": 1 },
    { "from": 0, "fromPort": 0, "to": 3, "toPort": 0 },
    { "from": 2, "fromPort": 2, "to": 3, "toPort": 1 },
    { "from": 2, "fromPort": 2, "to": 4, "toPort": 0 },
    { "from": 1, "fromPort": 0, "to": 4, "toPort": 1 },
    { "from": 3, "fromPort": 2, "to": 5, "toPort": 0 },
    { "from": 4, "fromPort": 2, "to": 5, "toPort": 1 },
    { "from": 5, "fromPort": 2, "to": 6, "toPort": 0 }
  ]
}

### Example 3: D flip-flop with clock and LED
{
  "name": "D-FF with LED",
  "description": "D flip-flop with clock, showing Q on LED",
  "components": [
    { "type": "INPUT", "x": -120, "y": -16, "attrs": { "label": "D", "state": 0 } },
    { "type": "CLOCK", "x": -120, "y": 0, "attrs": { "state": 0, "period": 500 } },
    { "type": "CONSTANT", "x": -120, "y": 16, "attrs": { "value": 0 } },
    { "type": "D_FF", "x": 0, "y": 0, "attrs": {} },
    { "type": "LED", "x": 120, "y": -8, "attrs": { "color": "#22c55e" } },
    { "type": "OUTPUT", "x": 120, "y": 8, "attrs": { "label": "Q'" } }
  ],
  "wires": [
    { "from": 0, "fromPort": 0, "to": 3, "toPort": 0 },
    { "from": 1, "fromPort": 0, "to": 3, "toPort": 1 },
    { "from": 2, "fromPort": 0, "to": 3, "toPort": 2 },
    { "from": 3, "fromPort": 3, "to": 4, "toPort": 0 },
    { "from": 3, "fromPort": 4, "to": 5, "toPort": 0 }
  ]
}

## CRITICAL RULES
1. Output ONLY valid JSON — no markdown, no explanation, no code fences
2. Every circuit MUST have at least one INPUT or CLOCK component
3. Every circuit MUST have at least one OUTPUT or LED component
4. All wires must go from an output port to an input port
5. Port indices must match the component's port count
6. Component indices in wires are zero-based into the components array
7. Keep layout compact: x range -200 to 200, y range -100 to 100

Respond with ONLY the JSON object.`;
}

export function buildLogicCircuitPrompt(description) {
  return `Generate a logic circuit for this request:

${description}`;
}
