import { VibeCodingAssistant, applyExtractors } from '../assistant-core.js';

const VALID_TYPES = [
  'cartesian', 'parametric', 'polar', 'implicit',
  'equation', 'inequality', 'piecewise', 'surface', 'limit',
];

const PLOT_RULES =
  'Return ONLY a JSON object: {\n'
  + '  "expressions": [ {\n'
  + '      "type": string,\n'
  + '      "expression": string,\n'
  + '      "color": string?,\n'
  + '      "calculus": { "derivative": bool?, "antiderivative": bool?, "integral": {"a": number, "b": number} | null }?,\n'
  + '      "notes": string?\n'
  + '  } ],\n'
  + '  "viewRange": { "xMin": number, "xMax": number, "yMin": number, "yMax": number } ?,\n'
  + '  "confidence": number between 0 and 1,\n'
  + '  "notes": short string\n'
  + '}\n'
  + 'RULES:\n'
  + '- "type" MUST be one of: cartesian, parametric, polar, implicit, equation, inequality, piecewise, surface, limit.\n'
  + '- "expression" uses math.js syntax.\n'
  + '- NEVER compute numerical answers. You emit only expressions; the engine evaluates them.\n'
  + '- For scenes, return multiple entries in "expressions".\n'
  + '- Pick a clean viewRange when default (-10..10) does not show the function well.\n'
  + '- NO markdown, NO code fences, NO prose outside the JSON. Just the JSON object.';

const SYSTEM_PROMPT = `You translate English into plottable expressions for a graphing calculator.
Use [CURRENT CONTEXT] for expressions already on the graph and the current view range.

The user may give a short description ("heart shape") or paste a homework word problem.
You do NOT perform math — Math.js, Nerdamer, and Plotly plot and analyze what you return.

For explain/fix requests: plain English is fine.
For new plots or updates: return ONLY the JSON object described below.

${PLOT_RULES}`;

function $(id) {
  return document.getElementById(id);
}

function normalizeType(t) {
  t = (t || '').toLowerCase().trim();
  if (t === 'equation') return 'implicit';
  return t;
}

function validateExpressionItem(item) {
  if (!item || typeof item !== 'object') return 'Not an object';
  const type = (item.type || '').toLowerCase().trim();
  if (!VALID_TYPES.includes(type)) return `Invalid type: ${type}`;
  const expr = (item.expression || '').trim();
  if (!expr) return 'Empty expression';
  if (expr.length > 300) return 'Expression too long';
  if (/[<>;{}]|javascript:|<script/i.test(expr)) return 'Suspicious characters';
  if (type === 'parametric' && expr.indexOf(',') === -1) return 'Parametric needs "x(t), y(t)"';
  if (type === 'surface' && !/[xy]/i.test(expr)) return 'Surface needs x and/or y';
  if ((type === 'equation' || type === 'implicit') && expr.indexOf('=') === -1) return 'Equation needs "="';
  if (type === 'limit' && !/lim\s*\(/i.test(expr)) return 'Limit needs lim(expr, var, approach) form';
  const parseable = ['cartesian', 'polar', 'inequality'];
  if (parseable.includes(type) && typeof window.math !== 'undefined' && window.math.parse) {
    try {
      window.math.parse(expr.replace(/\btheta\b/g, 'x'));
    } catch (e) {
      return `math.parse rejected: ${e.message || 'syntax error'}`;
    }
  }
  return null;
}

function validatePlotPayload(data) {
  if (!data || typeof data !== 'object') return 'Not an object';
  const exprs = data.expressions;
  if (!Array.isArray(exprs) || !exprs.length) return 'No expressions';
  if (exprs.length > 6) return 'Too many expressions';
  for (let i = 0; i < exprs.length; i++) {
    const err = validateExpressionItem(exprs[i]);
    if (err) return `Expression ${i + 1}: ${err}`;
  }
  return null;
}

function parsePlotJson(text) {
  let clean = String(text || '').replace(/```(?:json)?\s*/gi, '').replace(/```/g, '').trim();
  const start = clean.indexOf('{');
  const end = clean.lastIndexOf('}');
  if (start !== -1 && end !== -1 && end > start) clean = clean.slice(start, end + 1);
  return JSON.parse(clean);
}

function extractPlotPayload(text) {
  const raw = applyExtractors.fencedCode(['json', ''], {
    minLength: 12,
    fallbackTest: /"expressions"\s*:\s*\[/,
  })(text);
  const candidate = raw || String(text || '');
  try {
    const parsed = parsePlotJson(candidate);
    if (validatePlotPayload(parsed)) return null;
    return parsed;
  } catch {
    return null;
  }
}

function applyViewRange(r) {
  if (!r) return;
  try {
    if (typeof r.xMin === 'number') $('xMin').value = r.xMin;
    if (typeof r.xMax === 'number') $('xMax').value = r.xMax;
    if (typeof r.yMin === 'number') $('yMin').value = r.yMin;
    if (typeof r.yMax === 'number') $('yMax').value = r.yMax;
  } catch { /* ignore */ }
}

function applyCalculusToggles(id, calc) {
  if (!calc) return;
  if (calc.derivative) {
    const cb = $(`show-derivative-${id}`);
    if (cb && typeof window.toggleDerivative === 'function') {
      cb.checked = true;
      window.toggleDerivative(id);
    }
  }
  if (calc.antiderivative) {
    const cbA = $(`show-antiderivative-${id}`);
    if (cbA && typeof window.toggleAntiderivative === 'function') {
      cbA.checked = true;
      window.toggleAntiderivative(id);
    }
  }
  if (calc.integral && typeof calc.integral.a === 'number' && typeof calc.integral.b === 'number') {
    const boundA = $(`integration-a-${id}`);
    const boundB = $(`integration-b-${id}`);
    const cbI = $(`show-integration-${id}`);
    if (boundA) boundA.value = calc.integral.a;
    if (boundB) boundB.value = calc.integral.b;
    if (cbI && typeof window.toggleIntegration === 'function') {
      cbI.checked = true;
      window.toggleIntegration(id);
    }
  }
}

function shouldClearFirst() {
  const el = $('gc-ai-clear-first');
  return !el || el.checked;
}

function applyPlot(data) {
  if (!data || !Array.isArray(data.expressions)) {
    throw new Error('No expressions to plot.');
  }

  if (shouldClearFirst() && typeof window.gcClearAll === 'function') {
    try { window.gcClearAll(); } catch { /* ignore */ }
  }

  applyViewRange(data.viewRange);

  const usesCalculus = data.expressions.some((e) =>
    e?.calculus && (e.calculus.derivative || e.calculus.antiderivative || e.calculus.integral));
  if (usesCalculus && typeof window.gcShowFTCHelper === 'function') {
    try { window.gcShowFTCHelper(); } catch { /* ignore */ }
  }

  data.expressions.forEach((item) => {
    try {
      const type = normalizeType(item.type);
      const value = item.expression;
      if (typeof window.addExpression === 'function') window.addExpression();
      const items = document.querySelectorAll('[id^=expr-item-]');
      const last = items[items.length - 1];
      if (!last) return;
      const id = parseInt(last.id.replace('expr-item-', ''), 10);

      const typeSel = $(`type-${id}`);
      if (typeSel) {
        typeSel.value = type;
        if (typeof window.updateExpressionType === 'function') window.updateExpressionType(id);
      }
      if (typeof window.loadSample === 'function') {
        window.loadSample(id, value);
      } else {
        const input = $(`expr-${id}`);
        if (input) {
          input.value = value;
          if (typeof window.updateExpressionValue === 'function') window.updateExpressionValue(id);
        }
      }
      if (item.color) {
        const c = $(`color-${id}`);
        if (c) {
          c.value = item.color;
          if (typeof window.updateExpressionColor === 'function') window.updateExpressionColor(id);
        }
      }
      if (item.calculus && type === 'cartesian') applyCalculusToggles(id, item.calculus);
    } catch (e) {
      console.warn('[GraphingAI] could not apply expression', e);
    }
  });

  if (typeof window.updateGraph === 'function') {
    try { window.updateGraph(); } catch { /* ignore */ }
  }
}

function collectEngineFacts() {
  const facts = { expressions: [] };
  if (typeof window.engine === 'undefined' || !window.engine || !Array.isArray(window.engine.expressions)) {
    return facts;
  }

  facts.expressions = window.engine.expressions
    .filter((e) => e && e.expression && e.visible !== false)
    .map((e) => {
      const item = { type: e.type, expression: e.expression };
      if (e.color) item.color = e.color;
      if (e.limitResult != null) item.limitResult = e.limitResult;
      if (e.integralValue != null) item.integralValue = e.integralValue;
      if (e.intersections) item.intersections = e.intersections;
      if (e.type === 'cartesian' && typeof window.nerdamer === 'function') {
        const features = {};
        try {
          const zeros = window.nerdamer(`solve(${e.expression}, x)`).toString();
          if (zeros && zeros !== '[]') features.zeros = zeros;
        } catch { /* skip */ }
        try {
          const derivative = window.nerdamer(`diff(${e.expression}, x)`).toString();
          if (derivative) features.derivative = derivative;
        } catch { /* skip */ }
        if (Object.keys(features).length) item.engineFeatures = features;
      }
      return item;
    });

  try {
    facts.viewRange = {
      xMin: parseFloat($('xMin').value),
      xMax: parseFloat($('xMax').value),
      yMin: parseFloat($('yMin').value),
      yMax: parseFloat($('yMax').value),
    };
  } catch { /* ignore */ }

  return facts;
}

function readCurrentExpressions() {
  const facts = collectEngineFacts();
  if (!facts.expressions.length) return '';
  return `Current plotted expressions:\n${JSON.stringify(facts, null, 2)}`;
}

/**
 * Floating AI assistant for the graphing calculator.
 */
export function createGraphingCalculatorAssistant(opts) {
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
    toolId: opts.toolId || 'math/graphing-calculator',
    title: 'Graphing AI',
    subtitle: 'Describe graphs in English — our engine plots, differentiates, and integrates.',
    placeholder: 'e.g. heart shape, Gaussian mean 3, projectile at 45°, sin(x) with derivative…',
    footerText: 'Ctrl+Shift+A · Apply plots to calculator · AI never computes values',
    historyTurns: 4,
    systemPrompt: SYSTEM_PROMPT,
    seedContext: () => readCurrentExpressions(),
    getQuickActions: () => {
      const chip = (label, prompt) => ({ label, prompt, sendImmediately: true });
      const facts = collectEngineFacts();
      const actions = [
        chip('Heart', 'heart shape parametric curve'),
        chip('Gaussian', 'Gaussian bell curve'),
        chip('3D saddle', '3D saddle surface z = x^2 - y^2'),
        chip('Derivative', 'show sin(x) with its derivative'),
        chip('Integral', 'area under x^2 from 0 to 2 with shading'),
        chip('Projectile', 'projectile at 20 m/s and 45 degrees, plot trajectory'),
      ];
      if (facts.expressions.length) {
        actions.push({
          label: 'Explain plot',
          prompt: `Explain what the current graph shows. Use ONLY these engine-computed facts:\n${JSON.stringify(facts, null, 2)}`,
          sendImmediately: true,
        });
      }
      return actions;
    },
    applyActions: [
      {
        id: 'plot',
        order: 1,
        label: 'Plot expressions',
        extract: extractPlotPayload,
        apply: async (data) => {
          const err = validatePlotPayload(data);
          if (err) throw new Error(`AI output rejected: ${err}`);
          applyPlot(data);
        },
      },
    ],
    getApplyLabel: () => 'Plot expressions',
  });
}
