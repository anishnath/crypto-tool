#!/usr/bin/env node
/**
 * CLI test runner for the Structured Data validation engine.
 *
 * Usage:
 *   node test-structured-data.mjs https://example.com
 *   node test-structured-data.mjs https://8gwifi.org
 *   node test-structured-data.mjs --api http://localhost:7080 https://airhorner.com
 *   node test-structured-data.mjs --json '{"jsonld":[...],"metatags":{...}}'
 *   node test-structured-data.mjs --file response.json
 *   node test-structured-data.mjs --presets           # list all presets
 */

import { readFileSync } from 'fs';
import { createContext, runInNewContext } from 'vm';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __dirname = dirname(fileURLToPath(import.meta.url));

// Load schema.org data and inject it into the engine at parse time
let schemaJson = 'null';
try { schemaJson = readFileSync(join(__dirname, 'schema-org-data.json'), 'utf8'); } catch (e) { /* optional */ }

const code = readFileSync(join(__dirname, 'structured-data-tests.js'), 'utf8');
const patchedCode = code.replace('var schemaData = null;', 'var schemaData = ' + schemaJson + ';');
const sandbox = { module: { exports: {} } };
sandbox.exports = sandbox.module.exports;
runInNewContext(patchedCode, sandbox);
const { runAll, PRESETS, META_PRESETS } = sandbox.module.exports;

// ── Colors (ANSI) ──
const GREEN  = '\x1b[32m';
const RED    = '\x1b[31m';
const YELLOW = '\x1b[33m';
const CYAN   = '\x1b[36m';
const DIM    = '\x1b[2m';
const BOLD   = '\x1b[1m';
const RESET  = '\x1b[0m';

// ── Parse args ──
const args = process.argv.slice(2);
let apiBase = process.env.SD_API || 'http://localhost:7080';
let url = null;
let jsonInput = null;
let fileInput = null;
let showPresets = false;

for (let i = 0; i < args.length; i++) {
    if (args[i] === '--api' && args[i + 1]) { apiBase = args[++i]; }
    else if (args[i] === '--json' && args[i + 1]) { jsonInput = args[++i]; }
    else if (args[i] === '--file' && args[i + 1]) { fileInput = args[++i]; }
    else if (args[i] === '--presets') { showPresets = true; }
    else if (args[i].startsWith('http')) { url = args[i]; }
    else { console.error(`Unknown arg: ${args[i]}`); process.exit(1); }
}

// ── List presets ──
if (showPresets) {
    console.log(`\n${BOLD}Schema Presets (Google Rich Results):${RESET}\n`);
    for (const [key, preset] of Object.entries(PRESETS)) {
        const required = preset.tests.filter(t => !t.warning).map(t => t.prop);
        const recommended = preset.tests.filter(t => t.warning).map(t => t.prop);
        console.log(`  ${CYAN}${preset.name}${RESET}`);
        console.log(`    Types: ${DIM}${preset.types.join(', ')}${RESET}`);
        console.log(`    Required:    ${required.join(', ') || '(none)'}`);
        console.log(`    Recommended: ${DIM}${recommended.join(', ') || '(none)'}${RESET}`);
        if (preset.custom) console.log(`    ${DIM}+ custom checks (FAQ questions, HowTo steps, etc.)${RESET}`);
        console.log();
    }
    console.log(`${BOLD}Meta Tag Presets:${RESET}\n`);
    for (const [key, preset] of Object.entries(META_PRESETS)) {
        const req = preset.tests.filter(t => !t.warning).map(t => t.label);
        const rec = preset.tests.filter(t => t.warning).map(t => t.label);
        console.log(`  ${CYAN}${preset.name}${RESET}`);
        console.log(`    Required:    ${req.join(', ') || '(none)'}`);
        console.log(`    Recommended: ${DIM}${rec.join(', ') || '(none)'}${RESET}`);
        console.log();
    }
    process.exit(0);
}

// ── Get data ──
let data;

if (jsonInput) {
    data = JSON.parse(jsonInput);
} else if (fileInput) {
    const fs = await import('fs');
    data = JSON.parse(fs.readFileSync(fileInput, 'utf8'));
} else if (url) {
    console.log(`\n${DIM}Fetching structured data from ${url}...${RESET}\n`);
    const resp = await fetch(`${apiBase}/api/structured-data/extract`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ url })
    });
    if (!resp.ok) {
        const err = await resp.json().catch(() => ({}));
        console.error(`${RED}API error (${resp.status}): ${err.error || resp.statusText}${RESET}`);
        process.exit(1);
    }
    data = await resp.json();
} else {
    console.error('Usage: node test-structured-data.mjs <URL>');
    console.error('       node test-structured-data.mjs --file response.json');
    console.error('       node test-structured-data.mjs --presets');
    process.exit(1);
}

// ── Run tests ──
const results = runAll(data);

// ── Print detection ──
console.log(`${BOLD}Detected:${RESET}`);
console.log(`  JSON-LD:   ${results.detected.jsonld}`);
console.log(`  Microdata: ${results.detected.microdata}`);
console.log(`  RDFa:      ${results.detected.rdfa}`);
console.log(`  Meta Tags: ${results.detected.metatags}`);
console.log();

// ── Print groups ──
console.log(`${BOLD}Test Results:${RESET}\n`);

for (const group of results.groups) {
    const color = group.failed > 0 ? RED : (group.warnings > 0 ? YELLOW : GREEN);
    console.log(`  ${color}${BOLD}${group.name}${RESET} ${DIM}(${group.source})${RESET} — ${group.pct}% (${group.passed}/${group.total})`);

    for (const test of group.tests) {
        let icon, col;
        if (test.status === 'pass')    { icon = '✓'; col = GREEN; }
        else if (test.status === 'warning') { icon = '▲'; col = YELLOW; }
        else                           { icon = '✗'; col = RED; }

        let valStr = '';
        if (test.passed && test.value != null) {
            let v = typeof test.value === 'object' ? JSON.stringify(test.value) : String(test.value);
            if (v.length > 80) v = v.substring(0, 77) + '…';
            valStr = `  ${DIM}${v}${RESET}`;
        }
        let descStr = test.description && !test.passed ? `\n         ${DIM}↳ ${test.description}${RESET}` : '';
        console.log(`    ${col}${icon}${RESET}  ${test.label}${valStr}${descStr}`);
    }
    console.log();
}

// ── Summary ──
const s = results.summary;
const totalPct = s.total > 0 ? Math.round(s.passed / s.total * 100) : 0;
const sumColor = totalPct >= 80 ? GREEN : (totalPct >= 50 ? YELLOW : RED);

console.log(`${BOLD}Summary:${RESET} ${sumColor}${totalPct}%${RESET} — ${GREEN}${s.passed} passed${RESET}, ${RED}${s.failed} failed${RESET}, ${YELLOW}${s.warnings} warnings${RESET} (${s.total} total)`);
console.log();
