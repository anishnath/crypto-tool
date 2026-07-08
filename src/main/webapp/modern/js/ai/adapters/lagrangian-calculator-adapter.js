import { VibeCodingAssistant, applyExtractors } from '../assistant-core.js';

const SYSTEM_PROMPT = `You translate plain-English descriptions of classical mechanics systems into the six inputs of a Lagrangian Mechanics Calculator.
Use [CURRENT CONTEXT] for fields the user already filled in.

The calculator uses SymPy to derive Euler-Lagrange equations, Hamiltonian, conservation laws, and RK45 integration.
YOU DO NOT DO PHYSICS. You only write the strings the user would have typed.

Return ONLY a JSON object:
{
  "name": string,
  "kinetic": string,
  "potential": string,
  "coords": string,
  "params": string,
  "ic": string,
  "tspan": string,
  "confidence": number,
  "notes": string
}

SYNTAX RULES:
- Use dq for time derivative of q (dtheta for coord theta, dx for x).
- Use d<coord>(0)=... in initial conditions.
- Use * for multiplication, ^ for exponentiation, sin, cos, tan, exp, log, sqrt, pi.
- Kinetic energy MUST contain a squared velocity term (e.g. 1/2*m*dx^2).
- Parameters in T or V must appear in "params" with numeric values.
- Every coordinate needs both q(0) and dq(0) in ic.

COMMON SYSTEMS:
- Simple pendulum: T="1/2*m*l^2*dtheta^2", V="-m*g*l*cos(theta)", coords="theta", params="m=1, g=9.8, l=1", ic="theta(0)=0.3, dtheta(0)=0"
- Spring-mass: T="1/2*m*dx^2", V="1/2*k*x^2", coords="x", params="m=1, k=4", ic="x(0)=1, dx(0)=0"

For explain questions: plain English is fine.
For filling the form: return ONLY the JSON object in a \`\`\`json fence or bare JSON.`;

function $(id) {
  return document.getElementById(id);
}

function readField(id) {
  return ($(id)?.value || '').trim();
}

function splitCoords(s) {
  if (!s) return [];
  return s.split(',').map((c) => c.trim()).filter(Boolean);
}

function paramNames(s) {
  if (!s) return [];
  return s.split(',').map((p) => {
    const m = p.match(/^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=/);
    return m ? m[1] : null;
  }).filter(Boolean);
}

function looksLikeExpression(s) {
  if (!s || typeof s !== 'string') return false;
  const t = s.trim();
  if (!t || t.length > 400) return false;
  if (/[<>;]|javascript:|<script/i.test(t)) return false;
  return /[A-Za-z0-9]/.test(t);
}

function validateMechanicsPayload(data) {
  if (!data || typeof data !== 'object') return 'Not an object';
  if (!data.kinetic && !data.potential && !data.coords) {
    return data.notes || 'Not a mechanics system';
  }

  const must = ['kinetic', 'potential', 'coords', 'params', 'ic'];
  for (const k of must) {
    if (!data[k] || typeof data[k] !== 'string' || !data[k].trim()) {
      return `Missing field: ${k}`;
    }
  }
  if (!looksLikeExpression(data.kinetic)) return 'Invalid kinetic energy';
  if (!looksLikeExpression(data.potential)) return 'Invalid potential energy';

  if (!/\bd[A-Za-z_][A-Za-z0-9_]*\s*\^\s*2|\(.*d[A-Za-z_][A-Za-z0-9_]*.*\)\s*\^\s*2|d[A-Za-z_][A-Za-z0-9_]*\s*\*\s*d[A-Za-z_][A-Za-z0-9_]*/.test(data.kinetic)) {
    return 'Kinetic energy missing a squared velocity term (needs like 1/2*m*dq^2)';
  }

  const coords = splitCoords(data.coords);
  if (!coords.length) return 'No coordinates declared';
  if (coords.length > 4) return 'Too many coordinates (max 4)';

  for (const c of coords) {
    if (!/^[A-Za-z_][A-Za-z0-9_]*$/.test(c)) return `Invalid coord name: ${c}`;
    const re = new RegExp(`\\b${c.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}\\b`);
    const dre = new RegExp(`\\bd${c}\\b`);
    if (!re.test(data.kinetic) && !re.test(data.potential) && !dre.test(data.kinetic) && !dre.test(data.potential)) {
      return `Coord "${c}" not used in T or V`;
    }
    const icQ = new RegExp(`\\b${c}\\s*\\(\\s*0\\s*\\)\\s*=`);
    const icDQ = new RegExp(`\\bd${c}\\s*\\(\\s*0\\s*\\)\\s*=`);
    if (!icQ.test(data.ic) || !icDQ.test(data.ic)) {
      return `IC missing ${c}(0) or d${c}(0)`;
    }
  }

  if (data.params.trim() && paramNames(data.params).length === 0) {
    return 'Params malformed (expected name=value pairs)';
  }

  const tspan = (data.tspan || '0, 10').split(',');
  if (tspan.length !== 2 || Number.isNaN(parseFloat(tspan[0])) || Number.isNaN(parseFloat(tspan[1]))) {
    return 'tspan must be two numbers (e.g. "0, 10")';
  }

  return null;
}

function parseMechanicsJson(text) {
  let clean = String(text || '').replace(/```(?:json)?\s*/gi, '').replace(/```/g, '').trim();
  const a = clean.indexOf('{');
  const b = clean.lastIndexOf('}');
  if (a !== -1 && b > a) clean = clean.slice(a, b + 1);
  return JSON.parse(clean);
}

function extractMechanicsPayload(text) {
  const raw = applyExtractors.fencedCode(['json', ''], {
    minLength: 20,
    fallbackTest: /"kinetic"\s*:/,
  })(text);
  const candidate = raw || String(text || '');
  try {
    const parsed = parseMechanicsJson(candidate);
    if (validateMechanicsPayload(parsed)) return null;
    return parsed;
  } catch {
    return null;
  }
}

function applyToForm(data) {
  const fields = {
    kinetic: $('lm-kinetic'),
    potential: $('lm-potential'),
    coords: $('lm-coords'),
    params: $('lm-params'),
    ic: $('lm-ic'),
    tspan: $('lm-tspan'),
  };

  fields.kinetic.value = data.kinetic;
  fields.potential.value = data.potential;
  fields.coords.value = data.coords;
  fields.params.value = data.params;
  fields.ic.value = data.ic;
  fields.tspan.value = data.tspan || '0, 10';

  const sel = $('lm-system-select');
  if (sel) sel.value = 'custom';

  Object.values(fields).forEach((el) => {
    if (!el) return;
    try {
      el.dispatchEvent(new Event('input', { bubbles: true }));
      el.dispatchEvent(new Event('change', { bubbles: true }));
    } catch { /* ignore */ }
  });
}

function readSeedContext() {
  const parts = [];
  const T = readField('lm-kinetic');
  const V = readField('lm-potential');
  const q = readField('lm-coords');
  if (T || V || q) {
    parts.push([
      T ? `Kinetic T: ${T}` : '',
      V ? `Potential V: ${V}` : '',
      q ? `Coordinates: ${q}` : '',
      readField('lm-params') ? `Params: ${readField('lm-params')}` : '',
      readField('lm-ic') ? `IC: ${readField('lm-ic')}` : '',
      readField('lm-tspan') ? `Time span: ${readField('lm-tspan')}` : '',
    ].filter(Boolean).join('\n'));
  }
  const system = $('lm-system-select')?.value;
  if (system && system !== 'custom') parts.push(`Selected preset: ${system}`);
  return parts.join('\n\n');
}

/**
 * Floating AI assistant for the Lagrangian mechanics calculator.
 */
export function lagrangianMechanicsApplyActions() {
  return [
    {
      id: 'lagrangian',
      order: 1,
      label: 'Apply to form',
      extract: extractMechanicsPayload,
      apply: async (data) => {
        const err = validateMechanicsPayload(data);
        if (err) throw new Error(err);
        applyToForm(data);
      },
    },
  ];
}

export function createLagrangianCalculatorAssistant(opts) {
  const { ctx, aiUrl, useGateway, aiRouteMode, aiRouteByTier, userId } = opts;

  return new VibeCodingAssistant({
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
    toolId: opts.toolId || 'math/lagrangian-calculator',
    title: 'Lagrangian AI',
    subtitle: 'Describe a mechanics system — AI fills T, V, coordinates, and ICs.',
    placeholder: 'e.g. simple pendulum length 1m, pendulum hanging from a spring…',
    footerText: 'Ctrl+Shift+A · Apply to form · then click Compute',
    historyTurns: 4,
    systemPrompt: SYSTEM_PROMPT,
    seedContext: () => readSeedContext(),
    getQuickActions: () => {
      const chip = (label, prompt) => ({ label, prompt, sendImmediately: true });
      return [
        chip('Pendulum+spring', 'pendulum hanging from a spring'),
        chip('Cone', 'mass on a frictionless cone, half-angle 30 degrees'),
        chip('Bead on wire', 'bead on a parabolic wire y=x^2'),
        chip('Central force', 'particle in central 1/r^2 potential'),
        chip('Coupled', 'two masses coupled by springs in a line'),
        chip('Driven', 'driven damped harmonic oscillator'),
        { label: 'Explain system', prompt: 'Explain the current Lagrangian system in plain English using the context fields.', sendImmediately: true },
      ];
    },
    applyActions: lagrangianMechanicsApplyActions(),
    getApplyLabel: () => 'Apply to form',
  });
}
