#!/usr/bin/env node
/**
 * Validates that rule_to_steps produces substeps for complex integrals.
 * Run: node integral-substeps-test.js
 * Requires: python3, sympy
 */
const { spawn } = require('child_process');
const path = require('path');

const pyScript = path.join(__dirname, 'integral-substeps-test.py');
let passed = 0, failed = 0;

function ok(cond, msg) {
    if (cond) { passed++; console.log('  \x1b[32m✓\x1b[0m', msg); return; }
    failed++; console.log('  \x1b[31m✗\x1b[0m', msg);
}

function runPython() {
    return new Promise((resolve, reject) => {
        const proc = spawn('python3', [pyScript], { cwd: __dirname });
        let stdout = '', stderr = '';
        proc.stdout.on('data', (d) => { stdout += d.toString(); });
        proc.stderr.on('data', (d) => { stderr += d.toString(); });
        proc.on('close', (code) => {
            if (code !== 0) reject(new Error('Python exit ' + code + ': ' + stderr));
            else resolve(stdout);
        });
    });
}

async function main() {
    console.log('=== Substeps Validation Test ===\n');
    let stdout;
    try {
        stdout = await runPython();
    } catch (e) {
        console.error('  \x1b[31m✗\x1b[0m Could not run Python:', e.message);
        process.exit(1);
    }

    const lines = stdout.trim().split('\n');
    const expectedSubstepTypes = {
        '1/(x**3+1)': { minSteps: 15, mustHave: ['Rewrite', 'Sum rule', 'u-Substitution', 'Reciprocal', 'Arctan'] },
        'x*exp(x)': { minSteps: 3, mustHave: ['Integration by parts', 'Exponential'] },
        'x*sin(x)': { minSteps: 4, mustHave: ['Integration by parts'] },
        'sin(x)**2': { minSteps: 3, mustHave: ['Rewrite', 'Sum rule'] },
        '1/(x**2+1)': { minSteps: 1, mustHave: ['Arctan'] },
        'x**2': { minSteps: 1, mustHave: ['Power rule'] },
    };

    for (const line of lines) {
        const m = line.match(/^SUBSTEPS:(.+)$/);
        if (!m) continue;
        try {
            const data = JSON.parse(m[1]);
            const expect = expectedSubstepTypes[data.expr];
            ok(data.step_count >= data.min_expected,
                data.expr + ': ' + data.step_count + ' steps (expected >= ' + data.min_expected + ')');
            if (expect && expect.mustHave) {
                const titles = new Set(data.titles || []);
                for (const t of expect.mustHave) {
                    ok(titles.has(t), data.expr + ': has substep "' + t + '"');
                }
            }
        } catch (e) {
            ok(false, 'Parse SUBSTEPS: ' + e.message);
        }
    }

    console.log('\n' + '='.repeat(50));
    console.log('\x1b[32mPassed:\x1b[0m', passed);
    console.log('\x1b[31mFailed:\x1b[0m', failed);
    process.exit(failed > 0 ? 1 : 0);
}

main();
