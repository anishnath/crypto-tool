#!/usr/bin/env node
/**
 * Validates SymPy output format (RESULT=, EXPR=, RULES=) for all integrands
 * from integral-test.js. Run: node integral-sympy-test.js
 * Requires: python3, sympy
 */
const { spawn } = require('child_process');
const path = require('path');

const pyScript = path.join(__dirname, 'integral-sympy-test.py');
let passed = 0, failed = 0;

function ok(cond, msg) {
    if (cond) { passed++; return; }
    failed++;
    console.log('  \x1b[31m✗\x1b[0m', msg);
}

function parseSympyOutput(stdout) {
    const resultMatch = stdout.match(/RESULT=(.*?)(?:\n|$)/s);
    const exprMatch = stdout.match(/EXPR=([\s\S]*?)(?=\nRULES|$)/);
    const rulesMatch = stdout.match(/RULES=([\s\S]*?)(?=\nRESULT|\nRULES|$)/s);
    const resultLatex = resultMatch && resultMatch[1] ? resultMatch[1].trim() : '';
    const exprLatex = exprMatch ? exprMatch[1].trim() : '';
    const rulesStr = rulesMatch ? rulesMatch[1].trim() : '';
    const rules = (rulesStr.match(/\w+Rule/g) || []).filter((r, i, a) => a.indexOf(r) === i);
    return { resultLatex, exprLatex, rulesStr, rules };
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
    console.log('=== SymPy Validation (all integral-test.js integrands) ===\n');
    let stdout;
    try {
        stdout = await runPython();
    } catch (e) {
        console.error('  \x1b[31m✗\x1b[0m Could not run Python:', e.message);
        console.log('  Install: pip install sympy');
        process.exit(1);
    }

    const blocks = stdout.split(/=== Test \d+:/).filter(Boolean);
    let total = 0;
    const failedExprs = [];

    for (let i = 0; i < blocks.length; i++) {
        const block = blocks[i];
        if (block.trim().startsWith('#')) continue;  // Skip trailing # Valid line
        const p = parseSympyOutput(block);
        const exprLabel = block.split('===')[0].trim().split('\n')[0] || 'expr' + (i + 1);
        total++;
        const hasResult = p.resultLatex.length > 0 && !p.resultLatex.includes('Integral(');
        const hasExpr = p.exprLatex.length > 0;
        const hasRules = p.rulesStr.length > 0 && p.rulesStr !== 'None';
        if (hasResult && hasExpr && hasRules) {
            passed++;
            if (total <= 5 || total % 15 === 0) {
                console.log('  \x1b[32m✓\x1b[0m', exprLabel);
            }
        } else {
            failed++;
            failedExprs.push({ expr: exprLabel, hasResult, hasExpr, hasRules });
            console.log('  \x1b[31m✗\x1b[0m', exprLabel, '(R:' + hasResult + ' E:' + hasExpr + ' Ru:' + hasRules + ')');
        }
    }

    // Summary: show any failed in detail
    if (failedExprs.length > 0 && failedExprs.length <= 10) {
        console.log('\n  Failed:', failedExprs.map(f => f.expr).join(', '));
    }
    console.log('\n' + '='.repeat(50));
    console.log('\x1b[32mPassed:\x1b[0m', passed);
    console.log('\x1b[31mFailed:\x1b[0m', failed);
    console.log('Total:', total);
    process.exit(failed > 0 ? 1 : 0);
}

main();
