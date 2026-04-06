/**
 * record-code-runner-php-tutorial.js — PHP tutorial showcasing the code runner
 *
 * Usage:
 *   DEMO_URL=http://localhost:8080/mywebapp2_war_exploded node record-code-runner-php-tutorial.js
 */
const H = require('./helpers');

// ── Code Runner Helpers (same as other demos) ───────────────

async function insertCodeBlock(page) {
    await page.evaluate(() => {
        const editor = window.MeEditor;
        if (!editor) return;
        if (editor.isActive('runnableCodeBlock')) {
            const { $from } = editor.state.selection;
            const after = $from.after();
            const docSize = editor.state.doc.content.size;
            if (after >= docSize) {
                editor.chain().insertContentAt(after, { type: 'paragraph' }).setTextSelection(after + 1).run();
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
                    editor.chain().insertContentAt(after, { type: 'paragraph' }).setTextSelection(after + 1).focus().run();
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
    console.log('Recording: PHP Tutorial — Code Runner Demo...');
    const { browser, context, page, outputDir } = await H.launchRecorder('code-runner-php-tutorial', { width: 1280, height: 720 });

    try {
        console.log('[1] Setup...');
        await H.openEditor(page);
        await H.pause(page);
        await H.clearEditor(page);

        await page.click('.me-doc-title-input');
        await page.waitForTimeout(150);
        await page.keyboard.press('Meta+a');
        await page.keyboard.type('PHP Crash Course — Write & Run', { delay: 25 });
        await page.keyboard.press('Enter');
        await H.focusEditor(page);

        // ── 1. HELLO WORLD & VARIABLES ──────────────────────
        console.log('[2] Hello World & Variables...');
        await H.typeText(page, 'Variables & Types', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.pressEnter(page);

        await insertCodeBlock(page);
        await selectLanguage(page, 'php');
        await H.beat(page);

        await typeCode(page,
            '<?php\n' +
            'echo "Hello, PHP!\\n";\n' +
            '\n' +
            '$name = "World";\n' +
            '$year = 2026;\n' +
            '$pi = 3.14159;\n' +
            '$active = true;\n' +
            '\n' +
            'echo "Name: $name\\n";\n' +
            'echo "Year: $year\\n";\n' +
            'echo "Pi: $pi\\n";\n' +
            'echo "Active: " . ($active ? "yes" : "no") . "\\n";\n' +
            'echo "Type of name: " . gettype($name) . "\\n";');
        await H.pause(page);
        await clickRun(page);
        await H.pause(page);

        await exitCodeBlock(page);
        await H.smoothScroll(page, 250);

        // ── 2. ARRAYS & LOOPS ───────────────────────────────
        console.log('[3] Arrays & Loops...');
        await H.pressEnter(page);
        await H.typeText(page, 'Arrays & Loops', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.pressEnter(page);

        await insertCodeBlock(page);
        await selectLanguage(page, 'php');
        await H.beat(page);

        await typeCode(page,
            '<?php\n' +
            '$fruits = ["apple", "banana", "cherry", "date"];\n' +
            '\n' +
            'echo "Fruits:\\n";\n' +
            'foreach ($fruits as $i => $fruit) {\n' +
            '    echo "  [$i] $fruit\\n";\n' +
            '}\n' +
            '\n' +
            '// Associative array\n' +
            '$scores = [\n' +
            '    "Alice" => 92,\n' +
            '    "Bob"   => 78,\n' +
            '    "Carol" => 95,\n' +
            '];\n' +
            '\n' +
            'arsort($scores);\n' +
            'echo "\\nLeaderboard:\\n";\n' +
            'foreach ($scores as $name => $score) {\n' +
            '    echo "  $name: $score\\n";\n' +
            '}');
        await H.pause(page);
        await clickRun(page);
        await H.pause(page);

        await exitCodeBlock(page);
        await H.smoothScroll(page, 300);

        // ── 3. FUNCTIONS & CLOSURES ─────────────────────────
        console.log('[4] Functions...');
        await H.pressEnter(page);
        await H.typeText(page, 'Functions & Closures', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.pressEnter(page);

        await insertCodeBlock(page);
        await selectLanguage(page, 'php');
        await H.beat(page);

        await typeCode(page,
            '<?php\n' +
            'function fibonacci(int $n): array {\n' +
            '    $seq = [0, 1];\n' +
            '    for ($i = 2; $i < $n; $i++) {\n' +
            '        $seq[] = $seq[$i-1] + $seq[$i-2];\n' +
            '    }\n' +
            '    return $seq;\n' +
            '}\n' +
            '\n' +
            'echo "Fibonacci(10): " . implode(", ", fibonacci(10)) . "\\n";\n' +
            '\n' +
            '// Closure with array_map\n' +
            '$numbers = [1, 2, 3, 4, 5];\n' +
            '$squared = array_map(fn($n) => $n ** 2, $numbers);\n' +
            '$evens = array_filter($numbers, fn($n) => $n % 2 === 0);\n' +
            '\n' +
            'echo "Squared: " . implode(", ", $squared) . "\\n";\n' +
            'echo "Evens: " . implode(", ", $evens) . "\\n";\n' +
            'echo "Sum: " . array_sum($numbers) . "\\n";');
        await H.pause(page);
        await clickRun(page);
        await H.pause(page);

        await exitCodeBlock(page);
        await H.smoothScroll(page, 350);

        // ── 4. CLASSES & OOP ────────────────────────────────
        console.log('[5] Classes...');
        await H.pressEnter(page);
        await H.typeText(page, 'Classes & OOP', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.pressEnter(page);

        await insertCodeBlock(page);
        await selectLanguage(page, 'php');
        await H.beat(page);

        await typeCode(page,
            '<?php\n' +
            'class Task {\n' +
            '    public function __construct(\n' +
            '        private string $title,\n' +
            '        private bool $done = false\n' +
            '    ) {}\n' +
            '\n' +
            '    public function complete(): void { $this->done = true; }\n' +
            '    public function isDone(): bool { return $this->done; }\n' +
            '\n' +
            '    public function __toString(): string {\n' +
            '        $check = $this->done ? "x" : " ";\n' +
            '        return "[$check] $this->title";\n' +
            '    }\n' +
            '}\n' +
            '\n' +
            '$tasks = [\n' +
            '    new Task("Learn PHP basics"),\n' +
            '    new Task("Build a REST API"),\n' +
            '    new Task("Write unit tests"),\n' +
            '];\n' +
            '\n' +
            '$tasks[0]->complete();\n' +
            '\n' +
            'echo "Todo List:\\n";\n' +
            'foreach ($tasks as $task) echo "  $task\\n";\n' +
            '\n' +
            '$done = count(array_filter($tasks, fn($t) => $t->isDone()));\n' +
            'echo "\\nProgress: $done/" . count($tasks) . "\\n";');
        await H.pause(page);
        await clickRun(page);
        await H.longPause(page);

        // ── EXPORT AS PDF ───────────────────────────────────
        console.log('[6] Export as PDF...');

        await page.evaluate(() => {
            const w = document.querySelector('.me-canvas-wrapper');
            if (w) w.scrollTo({ top: 0, behavior: 'smooth' });
        });
        await H.longPause(page);

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

        console.log('[6a] Waiting for PDF...');
        await H.extraPause(page);
        await H.extraPause(page);
        await H.extraPause(page);

        const download = await downloadPromise;
        if (download) {
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
            await H.extraPause(page);
        }

        // ── FINAL SCROLL ────────────────────────────────────
        console.log('[7] Final scroll...');
        await page.evaluate(() => {
            const w = document.querySelector('.me-canvas-wrapper');
            if (w) w.scrollTo({ top: 0, behavior: 'smooth' });
        });
        await H.longPause(page);
        for (let i = 0; i < 7; i++) {
            await H.smoothScroll(page, 400);
            await page.waitForTimeout(500);
        }
        await H.pause(page);

        console.log('Done!');
    } catch (err) {
        console.error('Recording error:', err.message);
        console.error(err.stack);
    }

    await H.finishRecording(browser, context, page, outputDir, 'code-runner-php-tutorial');
})();
