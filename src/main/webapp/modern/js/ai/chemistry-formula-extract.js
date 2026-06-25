/**
 * Extract molecular formulas from Chemistry AI replies for apply-to-editor actions.
 * Expected format (one or more blocks):
 *
 * ```formula
 * H2O
 * charge: 0
 * ```
 *
 * ```json
 * {"formula":"CO2","charge":0}
 * ```
 * or {"formulas":[{"formula":"NH3","charge":0}, ...]}
 */

const FORMULA_FENCE_LANGS = new Set(['formula', 'chem', 'chemistry', 'molecule']);

/** @param {string} line */
function looksLikeFormulaLine(line) {
  const s = String(line || '').trim();
  if (!s || s.length > 64) return false;
  if (/^(charge|name|note)\s*:/i.test(s)) return false;
  return /^[A-Za-z0-9()[\].+\-]+$/.test(s.replace(/\s/g, ''));
}

/**
 * @param {string} content
 * @returns {{ formula: string, charge: number, name?: string } | null}
 */
export function parseFormulaBlockContent(content) {
  const lines = String(content || '')
    .trim()
    .split(/\r?\n/)
    .map((l) => l.trim())
    .filter(Boolean);

  if (!lines.length) return null;

  let formula = '';
  let charge = 0;
  let name = '';

  for (const line of lines) {
    const chargeMatch = line.match(/^charge\s*:\s*([+-]?\d+)/i);
    if (chargeMatch) {
      charge = parseInt(chargeMatch[1], 10);
      if (Number.isNaN(charge)) charge = 0;
      continue;
    }
    const nameMatch = line.match(/^name\s*:\s*(.+)$/i);
    if (nameMatch) {
      name = nameMatch[1].trim();
      continue;
    }
    if (!formula && looksLikeFormulaLine(line)) {
      formula = line.replace(/\s/g, '');
    }
  }

  if (!formula) return null;
  return name ? { formula, charge, name } : { formula, charge };
}

/**
 * @param {unknown} data
 * @returns {{ formula: string, charge: number, name?: string }[]}
 */
function formulasFromJson(data) {
  if (!data || typeof data !== 'object') return [];

  /** @type {{ formula: string, charge: number, name?: string }[]} */
  const out = [];

  const push = (entry) => {
    if (!entry || typeof entry !== 'object') return;
    const formula = String(entry.formula || entry.molecularFormula || '').trim();
    if (!formula || !looksLikeFormulaLine(formula)) return;
    let charge = 0;
    if (entry.charge != null && entry.charge !== '') {
      charge = parseInt(String(entry.charge), 10);
      if (Number.isNaN(charge)) charge = 0;
    }
    const name = entry.name ? String(entry.name).trim() : '';
    out.push(name ? { formula, charge, name } : { formula, charge });
  };

  if (Array.isArray(data.formulas)) {
    data.formulas.forEach(push);
    return out;
  }
  if (Array.isArray(data.molecules)) {
    data.molecules.forEach(push);
    return out;
  }
  if (data.formula || data.molecularFormula) {
    push(data);
  }
  return out;
}

/**
 * @param {string} text
 * @returns {{ formula: string, charge: number, name?: string }[]}
 */
export function extractMolecularFormulas(text) {
  const src = String(text ?? '');
  /** @type {{ formula: string, charge: number, name?: string }[]} */
  const found = [];
  const seen = new Set();

  const add = (entry) => {
    if (!entry?.formula) return;
    const key = `${entry.formula}|${entry.charge ?? 0}`;
    if (seen.has(key)) return;
    seen.add(key);
    found.push(entry);
  };

  const fenceRe = /```([\w#+.-]*)\s*\n([\s\S]*?)```/g;
  let m;
  while ((m = fenceRe.exec(src)) !== null) {
    const lang = (m[1] || '').toLowerCase();
    const body = m[2];

    if (lang === 'json') {
      try {
        formulasFromJson(JSON.parse(body.trim())).forEach(add);
      } catch { /* ignore invalid JSON */ }
      continue;
    }

    if (FORMULA_FENCE_LANGS.has(lang)) {
      const parsed = parseFormulaBlockContent(body);
      if (parsed) add(parsed);
    }
  }

  return found;
}

export function formatFormulaApplyLabel(entry) {
  const ch = Number(entry?.charge) || 0;
  const chPart = ch ? (ch > 0 ? ` (+${ch})` : ` (${ch})`) : '';
  const namePart = entry?.name ? `${entry.name}: ` : '';
  return `${namePart}${entry.formula}${chPart} → Generate`;
}
