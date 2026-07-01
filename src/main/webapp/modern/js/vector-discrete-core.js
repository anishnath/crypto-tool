/**
 * Discrete vector ops for Math AI chat (dot, cross, magnitude, projection, …).
 * Uses VecCalcRender pure math when available (same as vector-calculator page).
 */
(function vectorDiscreteCoreModule() {
  'use strict';

  const VECTOR_OPS = new Set([
    'add', 'subtract', 'sub', 'scalar_multiply', 'scale', 'dot', 'dot_product',
    'cross', 'cross_product', 'magnitude', 'mag', 'unit_vector', 'unit', 'angle',
    'projection', 'proj', 'rejection', 'rej', 'area', 'triple_scalar', 'triple',
    'linear_independence', 'indep', 'independence',
  ]);

  const OP_LABELS = {
    add: 'Vector addition',
    subtract: 'Vector subtraction',
    scalar_multiply: 'Scalar multiplication',
    dot_product: 'Dot product',
    cross_product: 'Cross product',
    magnitude: 'Magnitude',
    unit_vector: 'Unit vector',
    angle: 'Angle between vectors',
    projection: 'Projection',
    rejection: 'Rejection',
    area: 'Parallelogram area',
    triple_scalar: 'Triple scalar product',
    linear_independence: 'Linear independence',
  };

  function R() {
    return typeof window !== 'undefined' ? window.VecCalcRender : null;
  }

  function fmt(n) {
    const render = R();
    if (render?.fmt) return render.fmt(n);
    if (typeof n === 'string') return n;
    if (Number.isInteger(n)) return String(n);
    const s = Number(n).toFixed(6);
    return s.replace(/\.?0+$/, '') || '0';
  }

  function vecTeX(v, name) {
    const render = R();
    if (render?.vecTeX) return render.vecTeX(v, name);
    const prefix = name ? `\\vec{${name}} = ` : '';
    if (v.length === 2) {
      return `${prefix}\\begin{pmatrix} ${fmt(v[0])} \\\\ ${fmt(v[1])} \\end{pmatrix}`;
    }
    return `${prefix}\\begin{pmatrix} ${fmt(v[0])} \\\\ ${fmt(v[1])} \\\\ ${fmt(v[2])} \\end{pmatrix}`;
  }

  function normalizeOp(op) {
    let o = String(op || 'dot_product').toLowerCase().replace(/\s+/g, '_');
    if (o === 'sub') o = 'subtract';
    if (o === 'scale' || o === 'scalar') o = 'scalar_multiply';
    if (o === 'dot') o = 'dot_product';
    if (o === 'cross') o = 'cross_product';
    if (o === 'mag' || o === 'norm' || o === 'length') o = 'magnitude';
    if (o === 'unit') o = 'unit_vector';
    if (o === 'proj') o = 'projection';
    if (o === 'rej') o = 'rejection';
    if (o === 'triple' || o === 'scalar_triple') o = 'triple_scalar';
    if (o === 'indep' || o === 'independence') o = 'linear_independence';
    return VECTOR_OPS.has(o) ? o : 'dot_product';
  }

  function parseNum(raw) {
    if (raw == null || raw === '') return NaN;
    if (typeof raw === 'number') return raw;
    const s = String(raw).trim().replace(/,/g, '');
    if (!s) return NaN;
    const n = Number(s);
    return Number.isFinite(n) ? n : NaN;
  }

  function parseVecInput(raw, dim) {
    if (Array.isArray(raw)) {
      const nums = raw.map(parseNum).filter((n) => Number.isFinite(n));
      if (!nums.length) return null;
      if (dim === 2) return nums.slice(0, 2);
      return nums.length >= 3 ? nums.slice(0, 3) : nums.concat([0]).slice(0, 3);
    }
    const s = String(raw || '').trim();
    if (!s) return null;
    if (/\\begin\{(?:pmatrix|bmatrix|matrix)\}/.test(s)) {
      const cells = s.match(/-?\d+(?:\.\d+)?(?:\/\d+)?/g);
      if (!cells) return null;
      const nums = cells.map(parseNum).filter((n) => Number.isFinite(n));
      if (dim === 2) return nums.slice(0, 2);
      return nums.slice(0, 3);
    }
    const bracket = s.match(/^\[\s*([^\]]+)\s*\]$/);
    const inner = bracket ? bracket[1] : s;
    const parts = inner.split(/[,;\s]+/).filter(Boolean);
    const nums = parts.map(parseNum).filter((n) => Number.isFinite(n));
    if (!nums.length) return null;
    if (dim === 2) return nums.slice(0, 2);
    if (nums.length === 2 && dim === 3) return [nums[0], nums[1], 0];
    return nums.slice(0, 3);
  }

  function vecFromTask(task, key, dim) {
    const aliases = {
      a: ['vectorA', 'vecA', 'a'],
      b: ['vectorB', 'vecB', 'b'],
      c: ['vectorC', 'vecC', 'c'],
    };
    const keys = aliases[key] || [key];
    for (let i = 0; i < keys.length; i += 1) {
      const val = task[keys[i]];
      if (val != null && val !== '') {
        const v = parseVecInput(val, dim);
        if (v) return v;
      }
    }
    return null;
  }

  function normalizeVectorTask(task) {
    const t = { ...(task || {}) };
    t.op = normalizeOp(t.op || t.operation || t.mode);
    const dimRaw = t.dim != null ? parseInt(String(t.dim), 10) : null;
    t.dim = dimRaw === 2 ? 2 : 3;
    t.vectorA = vecFromTask(t, 'a', t.dim);
    t.vectorB = vecFromTask(t, 'b', t.dim);
    t.vectorC = vecFromTask(t, 'c', t.dim);
    if (t.scalar == null && t.k != null) t.scalar = t.k;
    if (t.scalar == null && t.scalarK != null) t.scalar = t.scalarK;
    return t;
  }

  function buildLatexFromTask(task) {
    const t = normalizeVectorTask(task);
    const op = t.op;
    const a = t.vectorA;
    const b = t.vectorB;
    const c = t.vectorC;
    const k = parseNum(t.scalar);
    if (!a) return String(t.raw || '').trim();

    const aT = vecTeX(a, 'a');
    const bT = b ? vecTeX(b, 'b') : '';
    const cT = c ? vecTeX(c, 'c') : '';

    switch (op) {
      case 'add': return `${aT} + ${bT}`;
      case 'subtract': return `${aT} - ${bT}`;
      case 'scalar_multiply': return `${fmt(Number.isFinite(k) ? k : 2)} \\cdot ${aT}`;
      case 'dot_product': return `${aT} \\cdot ${bT}`;
      case 'cross_product': return `${aT} \\times ${bT}`;
      case 'magnitude': return `|${aT}|`;
      case 'unit_vector': return `\\hat{a} = \\frac{\\vec{a}}{|\\vec{a}|}`;
      case 'angle': return `\\theta = \\angle(\\vec{a}, \\vec{b})`;
      case 'projection': return `\\mathrm{proj}_{\\vec{a}}\\,\\vec{b}`;
      case 'rejection': return `\\mathrm{rej}_{\\vec{a}}\\,\\vec{b}`;
      case 'area': return t.dim === 3 ? `|\\vec{a} \\times \\vec{b}|` : `|a_x b_y - a_y b_x|`;
      case 'triple_scalar': return `${aT} \\cdot (${bT} \\times ${cT})`;
      case 'linear_independence': return `\\text{Are } ${aT}, ${bT} \\text{ linearly independent?}`;
      default: return aT;
    }
  }

  function needsB(op) {
    return ['add', 'subtract', 'dot_product', 'cross_product', 'angle', 'projection', 'rejection', 'area', 'linear_independence'].includes(op);
  }

  function needsC(op) {
    return op === 'triple_scalar';
  }

  function resultLatex(op, value, type) {
    if (type === 'vector') return vecTeX(value);
    if (type === 'boolean') return value ? '\\text{Linearly independent}' : '\\text{Linearly dependent}';
    if (op === 'angle' && value && typeof value === 'object') {
      return `${fmt(value.degrees)}^\\circ \\; (${fmt(value.radians)} \\text{ rad})`;
    }
    return fmt(value);
  }

  function buildSteps(op, a, b, c, k, dim, computed) {
    const steps = [];
    const push = (title, latex) => steps.push({ title, latex });

    push('Write the vectors', `${vecTeX(a, 'a')}${b ? `, \\quad ${vecTeX(b, 'b')}` : ''}${c ? `, \\quad ${vecTeX(c, 'c')}` : ''}`);

    const render = R();
    if (!render) {
      push('Result', resultLatex(op, computed.value, computed.type));
      return steps;
    }

    if (op === 'dot_product' && b) {
      const terms = [];
      for (let i = 0; i < a.length; i += 1) terms.push(`(${fmt(a[i])})(${fmt(b[i])})`);
      push('Apply dot product formula', `\\vec{a}\\cdot\\vec{b} = ${terms.join(' + ')} = ${fmt(computed.value)}`);
    } else if (op === 'cross_product' && b && dim === 3) {
      const cr = render.cross(a, b);
      push('Compute cross product', `\\vec{a}\\times\\vec{b} = ${vecTeX(cr)}`);
    } else if (op === 'magnitude') {
      push('Apply magnitude formula', `|\\vec{a}| = ${fmt(computed.value)}`);
    } else if (op === 'add' && b) {
      push('Add component-wise', `\\vec{a}+\\vec{b} = ${vecTeX(computed.value)}`);
    } else if (op === 'subtract' && b) {
      push('Subtract component-wise', `\\vec{a}-\\vec{b} = ${vecTeX(computed.value)}`);
    } else if (op === 'scalar_multiply') {
      push('Multiply each component', `${fmt(k)}\\vec{a} = ${vecTeX(computed.value)}`);
    } else if (op === 'projection' && b) {
      push('Project b onto a', `\\mathrm{proj}_{\\vec{a}}\\vec{b} = ${vecTeX(computed.value)}`);
    } else if (op === 'angle' && b) {
      push('Use angle formula', `\\theta = ${resultLatex(op, computed.value, computed.type)}`);
    }

    push('Result', resultLatex(op, computed.value, computed.type));
    return steps;
  }

  function compute(op, a, b, c, k, dim) {
    const render = R();
    if (!render) return { ok: false, error: 'Vector math engine (VecCalcRender) not loaded.' };

    if (needsB(op) && !b) return { ok: false, error: 'This operation requires vector b.' };
    if (needsC(op) && !c) return { ok: false, error: 'Triple scalar product requires vectors a, b, and c.' };

    let value;
    let type = 'scalar';

    switch (op) {
      case 'add':
        value = render.vecAdd(a, b);
        type = 'vector';
        break;
      case 'subtract':
        value = render.vecSub(a, b);
        type = 'vector';
        break;
      case 'scalar_multiply':
        value = render.vecScale(a, Number.isFinite(k) ? k : 2);
        type = 'vector';
        break;
      case 'dot_product':
        value = render.dot(a, b);
        break;
      case 'cross_product':
        if (dim !== 3) return { ok: false, error: 'Cross product requires 3D vectors.' };
        value = render.cross(a, b);
        type = 'vector';
        break;
      case 'magnitude':
        value = render.magnitude(a);
        break;
      case 'unit_vector': {
        const mag = render.magnitude(a);
        if (mag === 0) return { ok: false, error: 'Cannot compute unit vector of the zero vector.' };
        value = render.unitVec(a);
        type = 'vector';
        break;
      }
      case 'angle': {
        const ang = render.angle(a, b);
        if (!ang) return { ok: false, error: 'Cannot compute angle with a zero vector.' };
        value = ang;
        type = 'angle';
        break;
      }
      case 'projection': {
        const p = render.proj(a, b);
        if (!p) return { ok: false, error: 'Cannot project onto the zero vector.' };
        value = p;
        type = 'vector';
        break;
      }
      case 'rejection': {
        const r = render.rej(a, b);
        if (!r) return { ok: false, error: 'Cannot compute rejection with a zero projection vector.' };
        value = r;
        type = 'vector';
        break;
      }
      case 'area':
        value = render.parallelogramArea(a, b);
        break;
      case 'triple_scalar':
        if (dim !== 3) return { ok: false, error: 'Triple scalar product requires 3D vectors.' };
        value = render.tripleScalar(a, b, c);
        break;
      case 'linear_independence':
        value = render.isLinearlyIndependent(a, b);
        type = 'boolean';
        break;
      default:
        return { ok: false, error: `Unsupported vector operation: ${op}` };
    }

    return { ok: true, value, type };
  }

  function solveTask(task, opts) {
    const withSteps = !!(opts && opts.withSteps);
    const t = normalizeVectorTask(task);

    if (!t.vectorA && t.raw) {
      return { ok: false, error: 'Could not parse vector a from the task.' };
    }
    if (!t.vectorA) {
      return { ok: false, error: 'Vector a is required (vectorA or a: [x,y,z]).' };
    }

    const op = t.op;
    const dim = t.dim;
    const a = t.vectorA;
    const b = t.vectorB;
    const c = t.vectorC;
    const k = parseNum(t.scalar);

    const computed = compute(op, a, b, c, k, dim);
    if (!computed.ok) return computed;

    const rl = resultLatex(op, computed.value, computed.type);
    const steps = withSteps ? buildSteps(op, a, b, c, k, dim, computed) : [];

    return {
      ok: true,
      op,
      opLabel: OP_LABELS[op] || 'Vector operation',
      resultLatex: rl,
      method: OP_LABELS[op] || 'Vector calculator',
      steps,
      input: { op, dim, a, b, c, k, value: computed.value, type: computed.type },
      value: computed.value,
      type: computed.type,
    };
  }

  window.VectorDiscreteCore = {
    VECTOR_OPS,
    normalizeOp,
    normalizeVectorTask,
    buildLatexFromTask,
    solveTask,
  };
}());
