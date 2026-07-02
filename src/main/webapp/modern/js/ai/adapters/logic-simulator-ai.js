/**
 * AI assistant for electronics/logic-simulator.jsp.
 * Circuit generation uses the legacy JSON schema (index-based wires).
 * Requires window.logicShell from the page (snapshot + apply).
 */
import { VibeCodingAssistant, applyExtractors } from '../assistant-core.js';

const CIRCUIT_JSON_VALIDATE = (o) => Array.isArray(o?.components) && o.components.length > 0;

const LOGIC_COMPONENT_SPEC = `
## Component Types & Port Indices

### Gates
Default 2 inputs. Ports: [in0=0, in1=1, out=2]. For N-input gate use attrs:{"inputs":N} — ports become [in0..inN-1, out=N].
AND, OR, NAND, NOR, XOR, XNOR — 2-input: ports 0,1=in, 2=out. 3-input: ports 0,1,2=in, 3=out.
NOT — ports: [in=0, out=1]
BUFFER — ports: [in=0, out=1]

### I/O Pins
INPUT — [out=0]. attrs:{"label":"A","state":0}
OUTPUT — [in=0]. attrs:{"label":"Q"}
CLOCK — [out=0]. attrs:{"state":0,"period":500}
CONSTANT — [out=0]. attrs:{"value":1} (0=LOW, 1=HIGH)
PROBE — [in=0]

### Interactive
LED — [in=0]. attrs:{"color":"#22c55e"} (green). Other colors: "#ef4444"=red, "#3b82f6"=blue, "#eab308"=yellow
BUTTON — [out=0] (momentary push)
SWITCH — [out=0] (toggle)

### Memory (rising-edge triggered)
SR_FF — [S=0, CLK=1, R=2, Q=3, Q'=4]
D_FF — [D=0, CLK=1, CLR=2, Q=3, Q'=4]
JK_FF — [J=0, CLK=1, K=2, Q=3, Q'=4]
T_FF — [T=0, CLK=1, Q=2, Q'=3]
REGISTER — [D0=0,D1=1,D2=2,D3=3, CLK=4, CLR=5, Q0=6,Q1=7,Q2=8,Q3=9]
COUNTER — [CLK=0, EN=1, CLR=2, Q0=3,Q1=4,Q2=5,Q3=6, OVF=7]

### Arithmetic & Plexers
ADDER — [A=0, B=1, Cin=2, S=3, Cout=4]
SUBTRACTOR — [A=0, B=1, Bin=2, D=3, Bout=4]
COMPARATOR — [A=0, B=1, A>B=2, A=B=3, A<B=4]
MUX — [D0=0, D1=1, SEL=2, Y=3]
DEMUX — [D=0, SEL=1, Y0=2, Y1=3]
DECODER — [A0=0, A1=1, Y0=2, Y1=3, Y2=4, Y3=5]
LUT — programmable truth table. Ports: [in0=0 .. inN-1, out=N]. attrs:{"inputs":N,"table":<int bitmask>}. N=1..6.
  "table" bit i (input read as binary, in0 = LSB) = the output for that input combination.
  2-input: AND=8 (0b1000), OR=14 (0b1110), XOR=6 (0b0110), XNOR=9 (0b1001), NAND=7, NOR=1.
  Prefer ONE LUT over a gate network when the user describes a truth table or an arbitrary combinational function.

### Displays
SEVEN_SEG — [a=0,b=1,c=2,d=3,e=4,f=5,g=6] all inputs
HEX_DISPLAY — [D0=0,D1=1,D2=2,D3=3] all inputs
LED_BAR — [L0-L7] indices 0-7, all inputs
BCD_7SEG_DECODER — 4-bit BCD → 7 segment lines. Ports: [D0=0,D1=1,D2=2,D3=3 (in), a=4,b=5,c=6,d=7,e=8,f=9,g=10 (out)].
  Wire its a..g outputs (ports 4-10) to a SEVEN_SEG's a..g inputs (ports 0-6) to show a digit.

### TTL 7400-Series ICs (14-pin DIP chips)
Real DIP chips with MULTIPLE independent gates. **Port index ≠ pin number — use the exact port indices below.**
GND/VCC are input pins but the simulator ignores power — leave them UNCONNECTED. Using only some gates of a chip is fine.
TTL_7400 (Quad NAND), TTL_7408 (Quad AND), TTL_7432 (Quad OR), TTL_7486 (Quad XOR) — identical layout, 4 gates:
  Gate1: in 0,1 → out 2 | Gate2: in 3,4 → out 5 | Gate3: in 12,11 → out 13 | Gate4: in 9,8 → out 10
TTL_7402 (Quad NOR) — outputs come first on each gate:
  Gate1: in 1,2 → out 0 | Gate2: in 4,5 → out 3 | Gate3: in 13,12 → out 11 | Gate4: in 10,9 → out 8
TTL_7404 (Hex inverter) — 6 inverters, 1 input each:
  Inv1: in 0 → out 1 | Inv2: in 2 → out 3 | Inv3: in 4 → out 5 | Inv4: in 12 → out 13 | Inv5: in 10 → out 11 | Inv6: in 8 → out 9
Do NOT emit TTL_7447, TTL_74138, or TTL_7474. If the user asks for one of those, build the function from discrete gates/DECODER/flip-flops and tell them you substituted.

### Wiring
TUNNEL_SRC — [in=0]. attrs:{"name":"bus_name"} (named bus source — key is "name", NOT "label")
TUNNEL_TGT — [out=0]. attrs:{"name":"bus_name"} (named bus target — receives from matching TUNNEL_SRC with the same "name")

## Wiring Rules
- from/to = zero-based component index. fromPort/toPort = port index within that component
- Wires go from OUTPUT ports to INPUT ports ONLY
- 2-input gate output is port 2. NOT/BUFFER output is port 1. N-input gate output is port N
- INPUT/CLOCK/SWITCH/BUTTON/CONSTANT output = port 0
- OUTPUT/LED/PROBE input = port 0
- One input port receives at most one wire (fan-out from output is OK)

## Layout
- 80px grid. Inputs left x=-160..-80, gates middle x=-40..120, outputs right x=160..240
- Vertical spacing 40-60px. y range -120 to 120. Keep compact`;

function buildSystemPrompt() {
  return `You are an expert digital logic designer for the **8gwifi.org Logic Gate Simulator** (Logisim-style browser tool).

Use [CURRENT CONTEXT] as the source of truth for the circuit already on the canvas.

**Response mode**
1. **Build / modify / replace circuit** — user asks to create, generate, add, fix, or change the schematic:
   - Return **one** \`\`\`json fenced block** with the full circuit object (schema below).
   - For edits, return the **complete updated** circuit (not a diff).
2. **Explain / teach / analyze** — user asks how something works, truth tables, K-maps, Boolean algebra, or compares designs:
   - Answer in clear plain language tied to [CURRENT CONTEXT].
   - Do **not** return circuit JSON unless they explicitly ask to change the circuit.

## Circuit JSON schema (generation only)
\`\`\`json
{"name":"Short name","description":"One sentence","components":[{"type":"TYPE","x":<int>,"y":<int>,"attrs":{}}],"wires":[{"from":<idx>,"fromPort":<port>,"to":<idx>,"toPort":<port>}]}
\`\`\`

${LOGIC_COMPONENT_SPEC}

## Examples

### AND gate
{"name":"AND Gate","description":"Simple AND gate with two inputs","components":[{"type":"INPUT","x":-120,"y":-20,"attrs":{"label":"A","state":0}},{"type":"INPUT","x":-120,"y":20,"attrs":{"label":"B","state":0}},{"type":"AND","x":0,"y":0,"attrs":{}},{"type":"OUTPUT","x":120,"y":0,"attrs":{"label":"Q"}}],"wires":[{"from":0,"fromPort":0,"to":2,"toPort":0},{"from":1,"fromPort":0,"to":2,"toPort":1},{"from":2,"fromPort":2,"to":3,"toPort":0}]}

### D flip-flop with clock and LED
{"name":"D-FF + LED","description":"D flip-flop with clock showing Q on LED","components":[{"type":"INPUT","x":-120,"y":-16,"attrs":{"label":"D","state":0}},{"type":"CLOCK","x":-120,"y":0,"attrs":{"state":0,"period":500}},{"type":"CONSTANT","x":-120,"y":16,"attrs":{"value":0}},{"type":"D_FF","x":0,"y":0,"attrs":{}},{"type":"LED","x":120,"y":-8,"attrs":{"color":"#22c55e"}},{"type":"OUTPUT","x":120,"y":8,"attrs":{"label":"Q'"}}],"wires":[{"from":0,"fromPort":0,"to":3,"toPort":0},{"from":1,"fromPort":0,"to":3,"toPort":1},{"from":2,"fromPort":0,"to":3,"toPort":2},{"from":3,"fromPort":3,"to":4,"toPort":0},{"from":3,"fromPort":4,"to":5,"toPort":0}]}

### XOR from 4 NAND gates (multi-level composition — study the wiring carefully)
Boolean identity: Q = (A NAND (A NAND B)) NAND (B NAND (A NAND B)).
Let N1 = A NAND B. Then N2 = A NAND N1, N3 = B NAND N1, Q = N2 NAND N3.
N1's output FANS OUT to BOTH N2 and N3 — do NOT rebuild "A NAND B" a second time, and do NOT wire A,B straight into every gate.
comps: 0=INPUT A, 1=INPUT B, 2=NAND(N1), 3=NAND(N2), 4=NAND(N3), 5=NAND(Q), 6=OUTPUT Q.
{"name":"XOR from NAND","description":"XOR built from four 2-input NAND gates","components":[{"type":"INPUT","x":-160,"y":-40,"attrs":{"label":"A","state":0}},{"type":"INPUT","x":-160,"y":40,"attrs":{"label":"B","state":0}},{"type":"NAND","x":-40,"y":0,"attrs":{}},{"type":"NAND","x":80,"y":-40,"attrs":{}},{"type":"NAND","x":80,"y":40,"attrs":{}},{"type":"NAND","x":160,"y":0,"attrs":{}},{"type":"OUTPUT","x":240,"y":0,"attrs":{"label":"Q"}}],"wires":[{"from":0,"fromPort":0,"to":2,"toPort":0},{"from":1,"fromPort":0,"to":2,"toPort":1},{"from":0,"fromPort":0,"to":3,"toPort":0},{"from":2,"fromPort":2,"to":3,"toPort":1},{"from":1,"fromPort":0,"to":4,"toPort":0},{"from":2,"fromPort":2,"to":4,"toPort":1},{"from":3,"fromPort":2,"to":5,"toPort":0},{"from":4,"fromPort":2,"to":5,"toPort":1},{"from":5,"fromPort":2,"to":6,"toPort":0}]}

### XOR using a 7486 chip (uses Gate 1 of the quad-XOR DIP; other gates + GND/VCC left unconnected)
{"name":"XOR (7486)","description":"XOR from one gate of a 7486 quad-XOR TTL chip","components":[{"type":"INPUT","x":-140,"y":-20,"attrs":{"label":"A","state":0}},{"type":"INPUT","x":-140,"y":20,"attrs":{"label":"B","state":0}},{"type":"TTL_7486","x":0,"y":0,"attrs":{}},{"type":"OUTPUT","x":160,"y":0,"attrs":{"label":"Q"}}],"wires":[{"from":0,"fromPort":0,"to":2,"toPort":0},{"from":1,"fromPort":0,"to":2,"toPort":1},{"from":2,"fromPort":2,"to":3,"toPort":0}]}

## CRITICAL (when returning JSON)
1. Valid JSON inside \`\`\`json — port indices MUST match the spec above
2. Every circuit MUST have at least one INPUT or CLOCK and one OUTPUT or LED
3. All wires: output port → input port only
4. For N-input gates: output port index = N (not 2). Include attrs:{"inputs":N} when N>2
5. **Multi-level circuits (XOR-from-NAND, adders, etc.):** a gate's output is a real signal — route it into the next level and REUSE it (fan-out) instead of rebuilding the same sub-expression. Never create two gates with identical inputs, and never leave a gate with no outgoing wire (every non-OUTPUT gate must feed something).
6. **Before returning, trace the truth table in your head** for every input combination and confirm the OUTPUT matches the requested function. If it doesn't, fix the wiring — do not return a circuit you haven't verified.`;
}

const QUICK_ACTIONS = [
  { label: 'AND + LED', prompt: 'AND gate with two input switches and LED output', sendImmediately: true },
  { label: 'Half Adder', prompt: 'Half adder with XOR for sum and AND for carry', sendImmediately: true },
  { label: 'XOR from NAND', prompt: 'XOR gate built from 4 NAND gates', sendImmediately: true },
  { label: 'D-FF + Clock', prompt: 'D flip-flop with clock source and LED on Q output', sendImmediately: true },
  { label: '4-bit Counter', prompt: '4-bit binary counter with clock, enable, and 4 LEDs', sendImmediately: true },
  { label: '2:1 MUX', prompt: '2 to 1 multiplexer with select switch and output LED', sendImmediately: true },
  { label: 'Explain circuit', prompt: 'Explain how the current circuit works — no code changes.', sendImmediately: true },
  { label: 'Truth table help', prompt: 'How would I analyze this circuit with the truth table tool? Explain expected inputs/outputs.', sendImmediately: true },
];

/**
 * @param {object} opts — aiAssistantBoot fields; uses window.logicShell
 */
export function createLogicSimulatorAssistant(opts) {
  const { ctx, aiUrl, useGateway, aiRouteMode, aiRouteByTier, userId } = opts;
  const shell = () => window.logicShell;

  const assistant = new VibeCodingAssistant({
    ctx,
    aiUrl,
    useGateway,
    aiRouteMode,
    aiRouteByTier,
    userId,
    billing: {
      enabled: true,
      requireSignIn: opts.billing?.requireSignIn === true,
      ctx,
      userId: userId || '',
      plans: {
        monthly: { name: 'Monthly', priceLabel: '', cadence: 'Billed monthly · cancel anytime' },
        yearly: { name: 'Yearly', priceLabel: '', cadence: 'Billed yearly', badge: 'Best value' },
        features: [
          'Much higher monthly AI limits',
          'Pro chat model tier',
          'No rate-limit waiting between requests',
        ],
      },
    },
    toolId: opts.toolId || 'electronics/logic-simulator',
    title: 'Logic AI',
    subtitle: 'Generate circuits or ask about Boolean logic — uses your current canvas.',
    placeholder: 'e.g. "Half adder with XOR and AND" or "Explain this circuit"',
    footerText: 'Apply loads circuit on canvas · Ctrl+Shift+A',
    historyTurns: 6,
    systemPrompt: buildSystemPrompt(),
    seedContext: () => {
      const snap = shell()?.getSnapshot?.();
      if (!snap) return 'Circuit not ready yet.';
      const lines = [
        `Active circuit: ${snap.circuitName || 'main'}`,
        `Components: ${snap.componentCount}, Wires: ${snap.wireCount}`,
      ];
      if (snap.summary) lines.push(snap.summary);
      if (snap.circuitJson) {
        lines.push('', 'Current circuit (AI JSON format):', snap.circuitJson);
      } else {
        lines.push('', '(Canvas is empty.)');
      }
      return lines.join('\n');
    },
    getQuickActions: () => QUICK_ACTIONS,
    applyActions: [
      {
        id: 'circuit',
        order: 1,
        label: 'Apply circuit to canvas',
        extract: applyExtractors.fencedJson(CIRCUIT_JSON_VALIDATE),
        apply: (payload) => {
          const lg = shell();
          if (!lg) throw new Error('Logic simulator not ready.');
          const result = lg.applyAiCircuit(payload);
          if (!result?.applied) throw new Error(result?.error || 'Could not apply circuit.');
          return result;
        },
      },
    ],
    getApplyLabel: (matched) => {
      const m = matched.find((x) => x.action.id === 'circuit');
      const name = m?.payload?.name;
      return name ? `Apply "${name}" to canvas` : 'Apply circuit to canvas';
    },
  });

  const originalOpen = assistant.open.bind(assistant);
  assistant.open = async function open(prefill, autoSend) {
    await shell()?.refreshSnapshot?.().catch(() => {});
    return originalOpen(prefill, autoSend);
  };

  const originalSend = assistant._send.bind(assistant);
  assistant._send = async function wrappedSend() {
    await shell()?.refreshSnapshot?.().catch(() => {});
    return originalSend();
  };

  return assistant;
}
