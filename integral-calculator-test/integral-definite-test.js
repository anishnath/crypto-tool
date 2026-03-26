#!/usr/bin/env node
/**
 * Validates definite integral SymPy flow.
 * Run: node integral-definite-test.js
 * Requires: python3, sympy
 */
const { spawn } = require('child_process');
const path = require('path');

const pyScript = path.join(__dirname, 'integral-definite-test.py');
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
    console.log('=== Definite Integral Test ===\n');
    let stdout;
    try {
        stdout = await runPython();
    } catch (e) {
        console.error('  \x1b[31m✗\x1b[0m Could not run Python:', e.message);
        process.exit(1);
    }

    const lines = stdout.trim().split('\n');
    for (const line of lines) {
        const m = line.match(/^DEFinite:(.+)$/);
        if (!m) continue;
        try {
            const d = JSON.parse(m[1]);
            ok(d.numeric != null || d.has_antideriv, d.expr + ' [' + d.a + ',' + d.b + ']: result (numeric or symbolic)');
            ok(d.has_antideriv, d.expr + ': has antiderivative');
            // DontKnowRule integrands (e.g. coth(log(x^(3/2)))) have no steps — expected
            var expectSteps = !d.expr.match(/coth\(log/) && !d.expr.match(/sqrt\(x\*\*2 \+ x \+ 1\)/) && !d.expr.match(/1\/\(1\+x\*\*4\)/)
                && !d.expr.match(/^Mod\(/) && !d.expr.match(/^Max\(/) && !d.expr.match(/^cos\(pi\/2\*cos/);
            ok(!expectSteps || d.has_steps, d.expr + ': has integral_steps');
            if (d.expected_approx !== undefined && d.expected_approx !== null) {
                const eps = 1e-6;
                const match = Math.abs(d.numeric - d.expected_approx) < eps;
                ok(match, d.expr + ': ' + d.numeric + ' ≈ ' + d.expected_approx);
            }
        } catch (e) {
            ok(false, 'Parse DEFinite: ' + e.message);
        }
    }

    console.log('\n' + '='.repeat(50));
    console.log('\x1b[32mPassed:\x1b[0m', passed);
    console.log('\x1b[31mFailed:\x1b[0m', failed);
    process.exit(failed > 0 ? 1 : 0);
}

main();
