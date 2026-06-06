#!/usr/bin/env node
/**
 * build-formula-cache.mjs
 *
 * Regenerates chemistry/data/formula-cache.min.json — a local cache the
 * formula-to-molecule page checks BEFORE hitting PubChem, so common lookups
 * are instant. This script is the *only* thing that talks to PubChem to
 * produce the data; the JSP just consumes the JSON.
 *
 * Run (Node 18+, has global fetch):
 *   node chemistry/data/build-formula-cache.mjs
 *   node chemistry/data/build-formula-cache.mjs --merge   # keep existing keys, add/update seeds
 *
 * Each formula is searched on PubChem (async listkey flow) and up to MAX_PER
 * compounds are stored as { cid, smiles, conn } — the same shape the page
 * renders, so a cache hit is identical to a live result.
 */
import { writeFileSync, readFileSync, existsSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';

const PUG = 'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/';
const PROPS = '/property/IsomericSMILES,CanonicalSMILES/JSON';
const MAX_PER = 25;          // cap compounds stored per formula
const REQ_GAP_MS = 300;      // politeness between PubChem requests
const POLL_GAP_MS = 1500;    // listkey poll interval
const POLL_MAX = 40;

// Seed list — what school + college students most commonly search by formula.
// Formulas are stored under the exact string here (so a student typing the same
// gets a cache hit); parenthesised formulas are expanded before querying PubChem.
// Add more and re-run with --merge.
const SEED = [
  // ── elements / standard elemental forms ──
  'H2', 'N2', 'O2', 'F2', 'Cl2', 'Br2', 'I2', 'O3', 'P4', 'S8',

  // ── inorganic acids ──
  'HCl', 'HBr', 'HI', 'HF', 'HNO3', 'HNO2', 'H2SO4', 'H2SO3', 'H2CO3',
  'H3PO4', 'HClO', 'HClO3', 'HClO4', 'HCN', 'H3BO3', 'H2S',

  // ── bases / hydroxides ──
  'NaOH', 'KOH', 'LiOH', 'NH3', 'Ca(OH)2', 'Mg(OH)2', 'Al(OH)3', 'Ba(OH)2',
  'Fe(OH)3', 'Cu(OH)2', 'Zn(OH)2',

  // ── oxides / peroxides ──
  'H2O', 'H2O2', 'CO', 'CO2', 'SO2', 'SO3', 'NO', 'NO2', 'N2O', 'N2O4', 'N2O5',
  'P2O5', 'CaO', 'MgO', 'Na2O', 'K2O', 'Al2O3', 'Fe2O3', 'Fe3O4', 'FeO',
  'CuO', 'Cu2O', 'ZnO', 'SiO2', 'MnO2', 'CrO3', 'PbO', 'PbO2', 'TiO2', 'BaO',

  // ── salts ──
  'NaCl', 'KCl', 'LiCl', 'NaBr', 'KBr', 'KI', 'NaI', 'CaCl2', 'MgCl2', 'BaCl2',
  'AlCl3', 'FeCl3', 'FeCl2', 'CuCl2', 'ZnCl2', 'AgCl', 'NH4Cl',
  'Na2CO3', 'CaCO3', 'NaHCO3', 'K2CO3', 'MgCO3',
  'Na2SO4', 'K2SO4', 'CuSO4', 'FeSO4', 'ZnSO4', 'MgSO4', 'CaSO4', 'BaSO4',
  'Al2(SO4)3', '(NH4)2SO4', 'NaNO3', 'KNO3', 'Ca(NO3)2', 'AgNO3', 'NH4NO3',
  'Na3PO4', 'Ca3(PO4)2', 'KMnO4', 'K2Cr2O7', 'K2CrO4', 'Na2S2O3',
  'NaF', 'CaF2', 'KClO3', 'NaClO', 'CaC2', 'NaCN', 'KCN',

  // ── other inorganic ──
  'PH3', 'SiH4', 'B2H6', 'CS2', 'COCl2', 'HgCl2', 'NaH', 'CaH2',

  // ── hydrocarbons: alkanes / alkenes / alkynes ──
  'CH4', 'C2H6', 'C3H8', 'C4H10', 'C5H12', 'C6H14', 'C7H16', 'C8H18', 'C10H22',
  'C2H4', 'C3H6', 'C4H8', 'C5H10', 'C6H12',
  'C2H2', 'C3H4', 'C4H6',

  // ── aromatics ──
  'C6H6', 'C7H8', 'C8H10', 'C10H8', 'C14H10', 'C6H5Cl', 'C6H5NO2',

  // ── alcohols / polyols ──
  'CH4O', 'C2H6O', 'C3H8O', 'C4H10O', 'C2H6O2', 'C3H8O3',

  // ── aldehydes / ketones ──
  'CH2O', 'C2H4O', 'C3H6O', 'C4H8O', 'C7H6O',

  // ── carboxylic acids ──
  'CH2O2', 'C2H4O2', 'C3H6O2', 'C4H8O2', 'C2H2O4', 'C3H6O3', 'C6H8O7',
  'C7H6O2', 'C7H6O3',

  // ── phenol / amines / amides / nitriles ──
  'C6H6O', 'C6H7N', 'CH5N', 'C2H7N', 'CH4N2O', 'C2H3N', 'C2H5NO2', 'C3H7NO2',

  // ── halogenated organics ──
  'CHCl3', 'CCl4', 'CH2Cl2', 'CH3Cl', 'CH3Br', 'CHI3', 'CHBr3',
  'C2H5Cl', 'C2H4Cl2', 'CF4', 'CCl2F2', 'C14H9Cl5',

  // ── carbohydrates & biomolecules ──
  'C5H10O5', 'C6H12O6', 'C12H22O11', 'C6H10O5', 'C27H46O', 'C6H8O6',

  // ── commonly searched drugs / compounds ──
  'C8H10N4O2', 'C9H8O4', 'C8H9NO2', 'C13H18O2', 'C10H14N2', 'C17H19NO3',
  'C9H13NO3', 'C8H11NO2', 'C16H18N2O4S',

  // ── common reaction products / extra salts (so balanced equations draw instantly) ──
  'MnCl2', 'MnSO4', 'Fe2(SO4)3', 'Cr2(SO4)3', 'CrCl3', 'KHSO4', 'NaHSO4',
  'FeBr3', 'AgBr', 'AgI', 'PbCl2', 'PbI2', 'PbSO4', 'Pb(NO3)2', 'Ba(NO3)2',
  'KHCO3', 'Ca(HCO3)2', 'Na2SO3', 'NaHSO3', 'NaNO2', 'KNO2',
  '(NH4)2CO3', 'NH4HCO3', 'Na2O2', 'Ca(ClO)2', 'SnCl2', 'Hg2Cl2',
  'ZnS', 'CuS', 'FeS', 'PbS', 'Na2S', 'Ag2S', 'Ag2O',
  'ZnCO3', 'CuCO3', 'NaH2PO4', 'Na2HPO4'
];

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

async function getJSON(url) {
  const r = await fetch(url, { headers: { 'User-Agent': '8gwifi.org-cache-builder/1.0', 'Accept': 'application/json' } });
  return r.json();
}

// Expand parenthesised formulas and emit a Hill-ordered flat formula PubChem
// matches, e.g. "Ca(OH)2" → "CaH2O2", "Al2(SO4)3" → "Al2O12S3", "(NH4)2SO4" → "H8N2O4S".
function expandFormula(f) {
  let i = 0;
  function group() {
    const counts = {};
    while (i < f.length) {
      const c = f[i];
      if (c === '(' || c === '[') {
        i++;
        const inner = group();
        let num = ''; while (i < f.length && /\d/.test(f[i])) num += f[i++];
        const mult = num ? parseInt(num, 10) : 1;
        for (const k in inner) counts[k] = (counts[k] || 0) + inner[k] * mult;
      } else if (c === ')' || c === ']') {
        i++; return counts;
      } else if (/[A-Z]/.test(c)) {
        let sym = c; i++;
        if (i < f.length && /[a-z]/.test(f[i])) sym += f[i++];
        let num = ''; while (i < f.length && /\d/.test(f[i])) num += f[i++];
        counts[sym] = (counts[sym] || 0) + (num ? parseInt(num, 10) : 1);
      } else { i++; } // skip ·, dots, +, -, whitespace, charges
    }
    return counts;
  }
  const counts = group();
  const syms = Object.keys(counts);
  let ordered;
  if (counts['C']) {
    ordered = ['C'].concat(counts['H'] ? ['H'] : [], syms.filter((s) => s !== 'C' && s !== 'H').sort());
  } else {
    ordered = syms.sort();
  }
  return ordered.map((s) => s + (counts[s] > 1 ? counts[s] : '')).join('');
}

async function lookup(formula) {
  const q = expandFormula(formula); // PubChem-friendly Hill formula
  let d = await getJSON(PUG + 'formula/' + encodeURIComponent(q) + PROPS);
  let tries = 0;
  while (d && d.Waiting && d.Waiting.ListKey && tries < POLL_MAX) {
    await sleep(POLL_GAP_MS);
    d = await getJSON(PUG + 'listkey/' + d.Waiting.ListKey + PROPS);
    tries++;
  }
  if (d && d.PropertyTable && d.PropertyTable.Properties) {
    return d.PropertyTable.Properties.slice(0, MAX_PER).map((p) => ({
      cid: p.CID,
      smiles: p.SMILES || p.IsomericSMILES || p.ConnectivitySMILES || p.CanonicalSMILES || '',
      conn: p.ConnectivitySMILES || p.CanonicalSMILES || ''
    }));
  }
  return null; // Fault / not found
}

(async () => {
  const dir = dirname(fileURLToPath(import.meta.url));
  const outPath = join(dir, 'formula-cache.min.json');
  const merge = process.argv.includes('--merge');

  const out = {};
  if (merge && existsSync(outPath)) {
    try { Object.assign(out, JSON.parse(readFileSync(outPath, 'utf8')).f || {}); } catch (e) {}
  }

  for (const f of SEED) {
    process.stdout.write('  ' + f.padEnd(12));
    try {
      const r = await lookup(f);
      if (r && r.length) { out[f] = r; console.log('→ ' + r.length); }
      else { console.log('→ (none, kept existing: ' + (out[f] ? out[f].length : 0) + ')'); }
    } catch (e) {
      console.log('→ ERROR ' + (e && e.message ? e.message : e));
    }
    await sleep(REQ_GAP_MS);
  }

  const json = { v: 1, generated: new Date().toISOString().slice(0, 10), f: out };
  writeFileSync(outPath, JSON.stringify(json)); // minified
  console.log('\nWrote ' + Object.keys(out).length + ' formulas → ' + outPath);
})();
