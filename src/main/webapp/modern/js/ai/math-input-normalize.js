/**
 * Tier-2 input normalization for the Math AI.
 *
 * Teachers and students rarely type "standard" input — they paste unicode math
 * (multiplication sign, minus sign, superscripts, pi), smart quotes, and odd
 * spaces. The in-browser CAS cores are strict parsers and reject these, which
 * used to dead-end the request. This layer runs at the dispatcher BEFORE any
 * solver, deterministically converting messy-but-common notation into
 * engine-ready ASCII, so the fast in-browser path (Tier 1) succeeds more often.
 * Only unambiguous substitutions are applied — no guessing.
 */

// unicode superscript char -> ascii (keys written as \u escapes to keep source ASCII).
const SUPERSCRIPT = {
  '⁰': '0', '¹': '1', '²': '2', '³': '3',
  '⁴': '4', '⁵': '5', '⁶': '6', '⁷': '7',
  '⁸': '8', '⁹': '9', '⁺': '+', '⁻': '-', 'ⁿ': 'n',
};

// Runs of unicode superscripts -> ^(...): x^2, x^(-1), x^(10) from x superscripts.
const SUPERSCRIPT_RUN = /[⁰¹²³⁴-⁹⁺⁻ⁿ]+/g;

/** Convert one messy math string to engine-ready ASCII. Idempotent; ASCII in -> ASCII out. */
export function normalizeMathInput(s) {
  if (typeof s !== 'string' || !s) return s;
  return s
    .replace(/−/g, '-')                                  // minus sign -> hyphen
    .replace(/[×⋅∙·]/g, '*')              // multiplication/dot signs -> *
    .replace(/÷/g, '/')                                  // division sign -> /
    .replace(/[‘’‛]/g, "'")                    // smart single quotes -> '
    .replace(/[“”]/g, '"')                          // smart double quotes -> "
    .replace(/[  -   　]/g, ' ') // exotic spaces -> space
    .replace(/π/g, 'pi')                                 // pi symbol -> pi
    .replace(SUPERSCRIPT_RUN, (run) => {
      const digits = run.split('').map((c) => SUPERSCRIPT[c] || '').join('');
      return digits ? `^(${digits})` : '';
    });
}

// Structural keys whose values are keywords, not math expressions — left untouched.
const SKIP_KEYS = new Set(['action', 'mode', 'op', 'direction', 'tail']);

/** Return a shallow clone of a task with every math-bearing string field normalized. */
export function normalizeTaskInputs(task) {
  if (!task || typeof task !== 'object' || Array.isArray(task)) return task;
  const out = { ...task };
  for (const key of Object.keys(out)) {
    if (SKIP_KEYS.has(key)) continue;
    if (typeof out[key] === 'string') out[key] = normalizeMathInput(out[key]);
  }
  return out;
}
