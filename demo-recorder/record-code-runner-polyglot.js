/**
 * record-code-runner-polyglot.js — All-languages showcase for the Math Editor
 *
 * One recording, six languages: Python, Java, Rust, Bash, Node.js, Lua
 * Each block solves a different math problem to show off the editor's
 * polyglot code-runner in a single, continuous demo.
 *
 * Usage:
 *   DEMO_URL=http://localhost:8080/mywebapp2_war_exploded node record-code-runner-polyglot.js
 *   DEMO_URL=http://localhost:8080/mywebapp2_war_exploded DEMO_SPEED=1.5 node record-code-runner-polyglot.js
 */
const H = require('./helpers');

// ── Code Runner Helpers ─────────────────────────────────────

async function insertCodeBlock(page) {
    await page.evaluate(() => {
        const editor = window.MeEditor;
        if (!editor) return;
        if (editor.isActive('runnableCodeBlock')) {
            const { $from } = editor.state.selection;
            const after = $from.after();
            const docSize = editor.state.doc.content.size;
            if (after >= docSize) {
                editor.chain()
                    .insertContentAt(after, { type: 'paragraph' })
                    .setTextSelection(after + 1)
                    .run();
            } else {
                editor.commands.setTextSelection(after);
            }
        }
        editor.commands.setRunnableCodeBlock();
    });
    await page.waitForTimeout(500);
}

async function typeCode(page, code) {
    await page.evaluate((text) => {
        const editor = window.MeEditor;
        if (editor) editor.commands.insertContent(text);
    }, code);
    await page.waitForTimeout(400);
}

async function clickRun(page) {
    const runBtns = await page.$$('.me-rcb-run-btn');
    if (runBtns.length > 0) await runBtns[runBtns.length - 1].click();
    await page.waitForTimeout(3000);
}

async function selectLanguage(page, lang) {
    const selects = await page.$$('.me-rcb-lang-select');
    if (selects.length > 0) await selects[selects.length - 1].selectOption(lang);
    await page.waitForTimeout(300);
}

async function exitCodeBlock(page) {
    await page.evaluate(() => {
        const editor = window.MeEditor;
        if (!editor) return;
        const { $from } = editor.state.selection;
        for (let depth = $from.depth; depth >= 0; depth--) {
            const node = $from.node(depth);
            if (node.type.name === 'runnableCodeBlock') {
                const after = $from.after(depth);
                const docSize = editor.state.doc.content.size;
                if (after >= docSize) {
                    editor.chain()
                        .insertContentAt(after, { type: 'paragraph' })
                        .setTextSelection(after + 1)
                        .focus()
                        .run();
                } else {
                    editor.chain().setTextSelection(after).focus().run();
                }
                return;
            }
        }
        editor.commands.focus('end');
    });
    await page.waitForTimeout(400);
}

// ── Main Recording ──────────────────────────────────────────

(async () => {
    console.log('Recording: Polyglot Math Editor — 6 Languages, 1 Editor...');
    const { browser, context, page, outputDir } = await H.launchRecorder('code-runner-polyglot', { width: 1280, height: 720 });

    try {
        // ── SETUP ───────────────────────────────────────────
        console.log('[1] Setup...');
        await H.openEditor(page);
        await H.pause(page);
        await H.clearEditor(page);

        await page.click('.me-doc-title-input');
        await page.waitForTimeout(150);
        await page.keyboard.press('Meta+a');
        await page.keyboard.type('Math Polyglot — 6 Languages, 1 Editor', { delay: 25 });
        await page.keyboard.press('Enter');
        await H.focusEditor(page);

        // ── INTRO TEXT ──────────────────────────────────────
        await H.typeText(page, 'One editor. Six languages. Write, run, and export — no setup required.', { fast: true });
        await H.pressEnter(page);
        await H.pressEnter(page);

        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        // 1. PYTHON — Fibonacci with memoization
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        console.log('[2] Python — Fibonacci...');
        await H.typeText(page, 'Python — Fibonacci Sequence', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.pressEnter(page);

        await H.typeText(page, 'Generate Fibonacci numbers with memoization and plot the golden ratio convergence:');
        await H.pressEnter(page);

        await insertCodeBlock(page);
        await selectLanguage(page, 'python');
        await H.beat(page);

        await typeCode(page,
            'from functools import lru_cache\n' +
            '\n' +
            '@lru_cache(maxsize=None)\n' +
            'def fib(n):\n' +
            '    if n < 2:\n' +
            '        return n\n' +
            '    return fib(n - 1) + fib(n - 2)\n' +
            '\n' +
            '# Print first 20 Fibonacci numbers\n' +
            'fibs = [fib(i) for i in range(20)]\n' +
            'print("Fibonacci sequence:")\n' +
            'print(fibs)\n' +
            '\n' +
            '# Show golden ratio convergence\n' +
            'print("\\nGolden ratio convergence:")\n' +
            'for i in range(2, 20):\n' +
            '    ratio = fib(i) / fib(i - 1)\n' +
            '    phi = (1 + 5 ** 0.5) / 2\n' +
            '    err = abs(ratio - phi)\n' +
            '    print(f"  fib({i})/fib({i-1}) = {ratio:.10f}  error = {err:.2e}")');
        await H.pause(page);

        await clickRun(page);
        await H.pause(page);

        await exitCodeBlock(page);
        await H.smoothScroll(page, 300);

        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        // 2. JAVA — Matrix multiplication
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        console.log('[3] Java — Matrix multiplication...');
        await H.pressEnter(page);
        await H.typeText(page, 'Java — Matrix Multiplication', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.pressEnter(page);

        await H.typeText(page, 'Multiply two matrices and pretty-print the result:');
        await H.pressEnter(page);

        await insertCodeBlock(page);
        await selectLanguage(page, 'java');
        await H.beat(page);

        await typeCode(page,
            'public class Main {\n' +
            '    static double[][] multiply(double[][] a, double[][] b) {\n' +
            '        int rows = a.length, cols = b[0].length, inner = b.length;\n' +
            '        double[][] result = new double[rows][cols];\n' +
            '        for (int i = 0; i < rows; i++)\n' +
            '            for (int j = 0; j < cols; j++)\n' +
            '                for (int k = 0; k < inner; k++)\n' +
            '                    result[i][j] += a[i][k] * b[k][j];\n' +
            '        return result;\n' +
            '    }\n' +
            '\n' +
            '    static void printMatrix(String label, double[][] m) {\n' +
            '        System.out.println(label);\n' +
            '        for (double[] row : m) {\n' +
            '            StringBuilder sb = new StringBuilder("  [");\n' +
            '            for (int j = 0; j < row.length; j++) {\n' +
            '                if (j > 0) sb.append(", ");\n' +
            '                sb.append(String.format("%6.1f", row[j]));\n' +
            '            }\n' +
            '            sb.append("]");\n' +
            '            System.out.println(sb);\n' +
            '        }\n' +
            '    }\n' +
            '\n' +
            '    public static void main(String[] args) {\n' +
            '        double[][] A = {{1, 2, 3}, {4, 5, 6}};\n' +
            '        double[][] B = {{7, 8}, {9, 10}, {11, 12}};\n' +
            '        double[][] C = multiply(A, B);\n' +
            '\n' +
            '        printMatrix("Matrix A (2x3):", A);\n' +
            '        printMatrix("\\nMatrix B (3x2):", B);\n' +
            '        printMatrix("\\nA x B (2x2):", C);\n' +
            '    }\n' +
            '}');
        await H.pause(page);

        await clickRun(page);
        await H.pause(page);

        await exitCodeBlock(page);
        await H.smoothScroll(page, 400);

        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        // 3. RUST — Sieve of Eratosthenes
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        console.log('[4] Rust — Sieve of Eratosthenes...');
        await H.pressEnter(page);
        await H.typeText(page, 'Rust — Sieve of Eratosthenes', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.pressEnter(page);

        await H.typeText(page, 'Find all primes up to 100 with zero-cost abstractions:');
        await H.pressEnter(page);

        await insertCodeBlock(page);
        await selectLanguage(page, 'rust');
        await H.beat(page);

        await typeCode(page,
            'fn sieve(limit: usize) -> Vec<usize> {\n' +
            '    let mut is_prime = vec![true; limit + 1];\n' +
            '    is_prime[0] = false;\n' +
            '    if limit > 0 { is_prime[1] = false; }\n' +
            '\n' +
            '    let mut p = 2;\n' +
            '    while p * p <= limit {\n' +
            '        if is_prime[p] {\n' +
            '            let mut multiple = p * p;\n' +
            '            while multiple <= limit {\n' +
            '                is_prime[multiple] = false;\n' +
            '                multiple += p;\n' +
            '            }\n' +
            '        }\n' +
            '        p += 1;\n' +
            '    }\n' +
            '\n' +
            '    (0..=limit).filter(|&i| is_prime[i]).collect()\n' +
            '}\n' +
            '\n' +
            'fn main() {\n' +
            '    let primes = sieve(100);\n' +
            '    println!("Primes up to 100 ({} found):", primes.len());\n' +
            '    for (i, p) in primes.iter().enumerate() {\n' +
            '        print!("{:>4}", p);\n' +
            '        if (i + 1) % 10 == 0 { println!(); }\n' +
            '    }\n' +
            '    println!();\n' +
            '\n' +
            '    // Twin primes\n' +
            '    let twins: Vec<_> = primes.windows(2)\n' +
            '        .filter(|w| w[1] - w[0] == 2)\n' +
            '        .map(|w| (w[0], w[1]))\n' +
            '        .collect();\n' +
            '    println!("\\nTwin primes: {:?}", twins);\n' +
            '}');
        await H.pause(page);

        await clickRun(page);
        await H.pause(page);

        await exitCodeBlock(page);
        await H.smoothScroll(page, 400);

        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        // 4. BASH — Collatz conjecture
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        console.log('[5] Bash — Collatz conjecture...');
        await H.pressEnter(page);
        await H.typeText(page, 'Bash — Collatz Conjecture', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.pressEnter(page);

        await H.typeText(page, 'Trace the 3n+1 sequence and find the longest chain under 100:');
        await H.pressEnter(page);

        await insertCodeBlock(page);
        await selectLanguage(page, 'bash');
        await H.beat(page);

        await typeCode(page,
            '#!/bin/bash\n' +
            '\n' +
            'collatz_len() {\n' +
            '    local n=$1 steps=0\n' +
            '    while [ $n -ne 1 ]; do\n' +
            '        if [ $((n % 2)) -eq 0 ]; then\n' +
            '            n=$((n / 2))\n' +
            '        else\n' +
            '            n=$((3 * n + 1))\n' +
            '        fi\n' +
            '        steps=$((steps + 1))\n' +
            '    done\n' +
            '    echo $steps\n' +
            '}\n' +
            '\n' +
            '# Trace the sequence for n=27\n' +
            'echo "Collatz sequence for n=27:"\n' +
            'n=27; seq=""\n' +
            'while [ $n -ne 1 ]; do\n' +
            '    seq="$seq $n ->"\n' +
            '    if [ $((n % 2)) -eq 0 ]; then n=$((n/2)); else n=$((3*n+1)); fi\n' +
            'done\n' +
            'echo "$seq 1"\n' +
            'echo "Steps: $(collatz_len 27)"\n' +
            '\n' +
            '# Find longest chain under 100\n' +
            'echo "\\nTop 5 longest chains (n < 100):"\n' +
            'for i in $(seq 2 99); do\n' +
            '    echo "$i $(collatz_len $i)"\n' +
            'done | sort -k2 -nr | head -5 | while read num steps; do\n' +
            '    echo "  n=$num  steps=$steps"\n' +
            'done');
        await H.pause(page);

        await clickRun(page);
        await H.pause(page);

        await exitCodeBlock(page);
        await H.smoothScroll(page, 400);

        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        // 5. NODE.JS — Monte Carlo Pi estimation
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        console.log('[6] Node.js — Monte Carlo Pi...');
        await H.pressEnter(page);
        await H.typeText(page, 'Node.js — Monte Carlo Pi Estimation', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.pressEnter(page);

        await H.typeText(page, 'Estimate Pi by throwing random darts at a unit square:');
        await H.pressEnter(page);

        await insertCodeBlock(page);
        await selectLanguage(page, 'javascript');
        await H.beat(page);

        await typeCode(page,
            'function estimatePi(samples) {\n' +
            '    let inside = 0;\n' +
            '    for (let i = 0; i < samples; i++) {\n' +
            '        const x = Math.random();\n' +
            '        const y = Math.random();\n' +
            '        if (x * x + y * y <= 1) inside++;\n' +
            '    }\n' +
            '    return (4 * inside) / samples;\n' +
            '}\n' +
            '\n' +
            'console.log("Monte Carlo Pi Estimation");\n' +
            'console.log("========================\\n");\n' +
            '\n' +
            'const trials = [100, 1_000, 10_000, 100_000, 1_000_000];\n' +
            'for (const n of trials) {\n' +
            '    const pi = estimatePi(n);\n' +
            '    const err = Math.abs(pi - Math.PI);\n' +
            '    const pct = ((err / Math.PI) * 100).toFixed(4);\n' +
            '    console.log(\n' +
            '        `  ${n.toLocaleString().padStart(11)} samples → ` +\n' +
            '        `π ≈ ${pi.toFixed(6)}  ` +\n' +
            '        `error: ${err.toFixed(6)} (${pct}%)`\n' +
            '    );\n' +
            '}\n' +
            '\n' +
            'console.log(`\\n  Actual π = ${Math.PI}`);');
        await H.pause(page);

        await clickRun(page);
        await H.pause(page);

        await exitCodeBlock(page);
        await H.smoothScroll(page, 400);

        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        // 6. LUA — Pascal's Triangle
        // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        console.log('[7] Lua — Pascal\'s Triangle...');
        await H.pressEnter(page);
        await H.typeText(page, 'Lua — Pascal\'s Triangle', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.pressEnter(page);

        await H.typeText(page, 'Build and display Pascal\'s triangle with binomial coefficients:');
        await H.pressEnter(page);

        await insertCodeBlock(page);
        await selectLanguage(page, 'lua');
        await H.beat(page);

        await typeCode(page,
            'local rows = 12\n' +
            'local triangle = {}\n' +
            '\n' +
            '-- Build the triangle\n' +
            'for i = 1, rows do\n' +
            '    triangle[i] = {}\n' +
            '    triangle[i][1] = 1\n' +
            '    triangle[i][i] = 1\n' +
            '    for j = 2, i - 1 do\n' +
            '        triangle[i][j] = triangle[i-1][j-1] + triangle[i-1][j]\n' +
            '    end\n' +
            'end\n' +
            '\n' +
            '-- Pretty-print with centering\n' +
            'print("Pascal\'s Triangle (12 rows)")\n' +
            'print(string.rep("=", 50))\n' +
            '\n' +
            'for i = 1, rows do\n' +
            '    local parts = {}\n' +
            '    for j = 1, i do\n' +
            '        parts[#parts + 1] = string.format("%4d", triangle[i][j])\n' +
            '    end\n' +
            '    local line = table.concat(parts, "")\n' +
            '    local pad = string.rep(" ", math.floor((50 - #line) / 2))\n' +
            '    print(pad .. line)\n' +
            'end\n' +
            '\n' +
            '-- Sum of each row = 2^n\n' +
            'print("\\nRow sums (should be powers of 2):")\n' +
            'for i = 1, rows do\n' +
            '    local sum = 0\n' +
            '    for j = 1, i do sum = sum + triangle[i][j] end\n' +
            '    print(string.format("  Row %2d: sum = %d", i, sum))\n' +
            'end');
        await H.pause(page);

        await clickRun(page);
        await H.longPause(page);

        // ── EXPORT AS PDF ───────────────────────────────────
        console.log('[8] Export as PDF...');

        await page.evaluate(() => {
            const w = document.querySelector('.me-canvas-wrapper');
            if (w) w.scrollTo({ top: 0, behavior: 'smooth' });
        });
        await H.longPause(page);

        // Bypass auth
        await page.evaluate(() => {
            if (!window.MathAPI) window.MathAPI = {};
            window.MathAPI.checkSession = function () {
                return Promise.resolve({ logged_in: true, user_id: 'demo-user' });
            };
        });

        const downloadPromise = page.waitForEvent('download', { timeout: 120000 }).catch(() => null);

        await page.click('.me-btn-export');
        await page.waitForTimeout(400);
        await page.click('.me-export-menu-item[data-export="pdf"]');
        await H.beat(page);

        console.log('[8a] Waiting for PDF compilation...');
        await H.extraPause(page);
        await H.extraPause(page);
        await H.extraPause(page);

        const download = await downloadPromise;
        if (download) {
            console.log('[8b] PDF downloaded, opening...');
            const pdfPath = await download.path();
            if (pdfPath) {
                const pdfPage = await context.newPage();
                await pdfPage.goto('file://' + pdfPath);
                await H.longPause(pdfPage);
                await H.extraPause(pdfPage);
                for (let i = 0; i < 3; i++) {
                    await pdfPage.keyboard.press('Space');
                    await page.waitForTimeout(800);
                }
                await H.longPause(pdfPage);
                await pdfPage.close();
            }
        } else {
            console.log('[8b] No download captured');
            await H.extraPause(page);
        }

        // ── FINAL SCROLL ────────────────────────────────────
        console.log('[9] Final scroll — the grand tour...');
        await page.evaluate(() => {
            const w = document.querySelector('.me-canvas-wrapper');
            if (w) w.scrollTo({ top: 0, behavior: 'smooth' });
        });
        await H.longPause(page);
        for (let i = 0; i < 12; i++) {
            await H.smoothScroll(page, 400);
            await page.waitForTimeout(500);
        }
        await H.pause(page);

        console.log('Done!');
    } catch (err) {
        console.error('Recording error:', err.message);
        console.error(err.stack);
    }

    await H.finishRecording(browser, context, page, outputDir, 'code-runner-polyglot');
})();
