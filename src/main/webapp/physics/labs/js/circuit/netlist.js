/**
 * Netlist I/O helpers.
 *
 *   parseNetlist(text)       text   → { elements: [...] }
 *   formatNetlist(elements)  elements → text          (TODO — for future export)
 *
 * The "netlist" format is the compact one-line-per-element encoding defined in
 * ai-prompt.js (the AI is asked to emit exactly this).  A clean parse produces
 * the same element shape `_deserializeCircuit` already consumes, so both
 * File → Import Circuit and the AI generate flow share one code path.
 *
 *   Line syntax:   <type> <x1> <y1> <x2> <y2> [key=value ...]
 *   Ground:        ground <x> <y>
 *   Blank lines, `#` comments, and prose/fence lines are ignored.
 */

import { PARAM_ALIAS } from './ai-prompt.js';

// Reverse lookup: canonical key → preferred short alias (for formatNetlist).
// When two aliases map to the same canonical key (e.g. `vpinch`→vp and `vp`→peakVoltage
// both live in PARAM_ALIAS), the FIRST entry seen wins — which matches the
// order declared in ai-prompt.js.
const PARAM_ALIAS_REVERSE = (() => {
    const out = {};
    for (const [short, canonical] of Object.entries(PARAM_ALIAS)) {
        if (!(canonical in out)) out[canonical] = short;
    }
    return out;
})();

// Whitelist of known element types — any first token not in this set is
// treated as prose and skipped.  Keep in sync with app.js's _createElement
// switch (and with the COMPONENT TYPES block in ai-prompt.js).
const KNOWN_TYPES = new Set([
    'wire', 'ground',
    'resistor', 'capacitor', 'polarized-cap', 'inductor',
    'switch', 'push-switch', 'spdt-switch', 'fuse', 'lamp',
    'dc-voltage', 'ac-voltage', 'dc-current', 'clock',
    'vcvs', 'vccs', 'ccvs', 'cccs', 'ammeter', 'voltmeter',
    'led', 'seven-seg', 'diode', 'zener',
    'bjt-npn', 'bjt-pnp', 'darlington-npn', 'darlington-pnp',
    'mosfet-n', 'mosfet-p', 'jfet-n', 'jfet-p',
    'opamp', 'comparator', 'schmitt', 'schmitt-inv',
    '555-timer', 'monostable', 'relay',
    'and-gate', 'or-gate', 'nand-gate', 'nor-gate', 'xor-gate', 'not-gate',
    'd-flipflop', 'sr-flipflop', 'jk-flipflop',
    'counter', 'shift-register',
    'mux', 'demux', 'half-adder', 'full-adder',
    'logic-input', 'logic-output',
    'transmission-line', 'vco', 'ideal-switch',
]);

/**
 * Parse netlist text into an elements array suitable for _deserializeCircuit.
 * Throws if zero valid elements are found (so the caller can fall back or
 * surface an error to the user).
 *
 * @param {string} text
 * @returns {{elements: Array<{type:string, x1:number, y1:number, x2:number, y2:number, params:object}>}}
 */
export function parseNetlist(text) {
    if (typeof text !== 'string') throw new Error('parseNetlist: expected a string');

    const elements = [];
    const errors = [];
    let lineNo = 0;

    for (const raw of text.split(/\r?\n/)) {
        lineNo++;
        // Strip `#` end-of-line comments and surrounding whitespace.
        const line = raw.replace(/#.*$/, '').trim();
        if (!line) continue;

        const parts = line.split(/\s+/);
        const type = parts[0];

        // Explicit sentinel from the prompt — let the caller handle it.
        if (type === 'error') {
            throw new Error(`netlist error sentinel on line ${lineNo}: ${line}`);
        }

        // Anything whose first token isn't a known type is treated as prose
        // (model preamble, markdown fence, blank commentary) and silently
        // skipped.  This is the single biggest source of parse robustness.
        if (!KNOWN_TYPES.has(type)) continue;

        let x1, y1, x2, y2, pStart;
        if (type === 'ground') {
            if (parts.length < 3) { errors.push(`L${lineNo}: ground needs x y`); continue; }
            x1 = x2 = Number(parts[1]);
            y1 = y2 = Number(parts[2]);
            pStart = 3;
        } else {
            if (parts.length < 5) { errors.push(`L${lineNo}: ${type} needs x1 y1 x2 y2`); continue; }
            x1 = Number(parts[1]);
            y1 = Number(parts[2]);
            x2 = Number(parts[3]);
            y2 = Number(parts[4]);
            pStart = 5;
        }
        if ([x1, y1, x2, y2].some(Number.isNaN)) {
            errors.push(`L${lineNo}: non-numeric coordinates`);
            continue;
        }

        const params = {};
        for (let i = pStart; i < parts.length; i++) {
            const eq = parts[i].indexOf('=');
            if (eq <= 0) continue;
            const rawKey = parts[i].slice(0, eq).toLowerCase();
            const rawVal = parts[i].slice(eq + 1);
            const key = PARAM_ALIAS[rawKey] || rawKey;
            const num = Number(rawVal);
            // Keep numeric when parseable, otherwise preserve the string
            // (e.g. future enum-style params).
            params[key] = Number.isFinite(num) ? num : rawVal;
        }

        elements.push({ type, x1, y1, x2, y2, params });
    }

    if (elements.length === 0) {
        const detail = errors.length ? ' — ' + errors.slice(0, 3).join('; ') : '';
        throw new Error('No valid netlist elements found' + detail);
    }

    return { elements };
}

/**
 * Format an elements array (same shape produced by _serializeCircuit) back
 * into netlist text.  Used by the File → Export Circuit (Netlist) menu —
 * we let the existing JSON serializer produce the element list, then fold
 * each element down to one line with short param aliases.
 *
 * @param {Array<{type:string, x1:number, y1:number, x2:number, y2:number, params?:object}>} elements
 * @returns {string}
 */
export function formatNetlist(elements) {
    if (!Array.isArray(elements)) throw new Error('formatNetlist: expected an array');

    const lines = [];
    for (const el of elements) {
        if (!el || !el.type) continue;
        const coords = el.type === 'ground'
            ? `${el.x1} ${el.y1}`
            : `${el.x1} ${el.y1} ${el.x2} ${el.y2}`;

        const paramParts = [];
        if (el.params) {
            for (const [canonical, value] of Object.entries(el.params)) {
                if (value == null) continue;
                const short = PARAM_ALIAS_REVERSE[canonical] || canonical;
                paramParts.push(`${short}=${value}`);
            }
        }

        lines.push(paramParts.length
            ? `${el.type} ${coords} ${paramParts.join(' ')}`
            : `${el.type} ${coords}`);
    }
    return lines.join('\n') + '\n';
}
