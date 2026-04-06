/**
 * record-code-runner-bash-tutorial.js — Bash tutorial showcasing the code runner
 *
 * Demonstrates the RunnableCodeBlock feature with Bash:
 *   1. Hello World & variables
 *   2. Conditionals & loops
 *   3. Functions
 *   4. String manipulation & arrays
 *   5. Pipes & text processing
 *   6. Stdin input
 *   7. Export as PDF
 *
 * Usage:
 *   DEMO_URL=http://localhost:8080/mywebapp2_war_exploded node record-code-runner-bash-tutorial.js
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

async function clickStdin(page) {
    const btns = await page.$$('.me-rcb-stdin-btn');
    if (btns.length > 0) await btns[btns.length - 1].click();
    await page.waitForTimeout(400);
}

async function typeStdinInput(page, text) {
    const areas = await page.$$('.me-rcb-stdin-area');
    if (areas.length > 0) {
        const area = areas[areas.length - 1];
        await area.focus();
        await page.waitForTimeout(200);
        await page.keyboard.type(text, { delay: 30 });
    }
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
    console.log('Recording: Bash Tutorial — Code Runner Demo...');
    const { browser, context, page, outputDir } = await H.launchRecorder('code-runner-bash-tutorial', { width: 1280, height: 720 });

    try {
        // ── SETUP ───────────────────────────────────────────
        console.log('[1] Setup...');
        await H.openEditor(page);
        await H.pause(page);
        await H.clearEditor(page);

        await page.click('.me-doc-title-input');
        await page.waitForTimeout(150);
        await page.keyboard.press('Meta+a');
        await page.keyboard.type('Bash Scripting — Write & Run', { delay: 25 });
        await page.keyboard.press('Enter');
        await H.focusEditor(page);

        // ── 1. HELLO WORLD & VARIABLES ──────────────────────
        console.log('[2] Hello World & Variables...');
        await H.typeText(page, 'Hello World & Variables', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.pressEnter(page);

        await H.typeText(page, 'The basics — echo, variables, and quoting:');
        await H.pressEnter(page);

        await insertCodeBlock(page);
        await selectLanguage(page, 'bash');
        await H.beat(page);

        await typeCode(page,
            '#!/bin/bash\n' +
            'echo "Hello, World!"\n' +
            '\n' +
            '# Variables — no spaces around =\n' +
            'name="Bash"\n' +
            'version=5\n' +
            'echo "Welcome to $name version $version"\n' +
            '\n' +
            '# Single vs double quotes\n' +
            'echo \'Single quotes: $name is literal\'\n' +
            'echo "Double quotes: $name is expanded"\n' +
            '\n' +
            '# Command substitution\n' +
            'today=$(date +%Y-%m-%d)\n' +
            'echo "Today is $today"');
        await H.pause(page);

        await clickRun(page);
        await H.pause(page);

        await exitCodeBlock(page);
        await H.smoothScroll(page, 250);

        // ── 2. CONDITIONALS & LOOPS ─────────────────────────
        console.log('[3] Conditionals & Loops...');
        await H.pressEnter(page);
        await H.typeText(page, 'Conditionals & Loops', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.pressEnter(page);

        await H.typeText(page, 'if/elif/else, for loops, and while loops:');
        await H.pressEnter(page);

        await insertCodeBlock(page);
        await selectLanguage(page, 'bash');
        await H.beat(page);

        await typeCode(page,
            '#!/bin/bash\n' +
            '\n' +
            '# If / elif / else\n' +
            'score=85\n' +
            'if [ "$score" -ge 90 ]; then\n' +
            '    echo "Grade: A"\n' +
            'elif [ "$score" -ge 80 ]; then\n' +
            '    echo "Grade: B"\n' +
            'elif [ "$score" -ge 70 ]; then\n' +
            '    echo "Grade: C"\n' +
            'else\n' +
            '    echo "Grade: F"\n' +
            'fi\n' +
            '\n' +
            '# For loop\n' +
            'echo "\\nCounting:"\n' +
            'for i in {1..5}; do\n' +
            '    echo "  $i"\n' +
            'done\n' +
            '\n' +
            '# While loop with arithmetic\n' +
            'echo "\\nPowers of 2:"\n' +
            'n=1\n' +
            'while [ $n -le 128 ]; do\n' +
            '    printf "  %d" $n\n' +
            '    n=$((n * 2))\n' +
            'done\n' +
            'echo ""');
        await H.pause(page);

        await clickRun(page);
        await H.pause(page);

        await exitCodeBlock(page);
        await H.smoothScroll(page, 350);

        // ── 3. FUNCTIONS ────────────────────────────────────
        console.log('[4] Functions...');
        await H.pressEnter(page);
        await H.typeText(page, 'Functions', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.pressEnter(page);

        await H.typeText(page, 'Reusable functions with arguments and return values:');
        await H.pressEnter(page);

        await insertCodeBlock(page);
        await selectLanguage(page, 'bash');
        await H.beat(page);

        await typeCode(page,
            '#!/bin/bash\n' +
            '\n' +
            '# Function with arguments\n' +
            'greet() {\n' +
            '    local name="$1"\n' +
            '    local time="$2"\n' +
            '    echo "Good $time, $name!"\n' +
            '}\n' +
            '\n' +
            'greet "Alice" "morning"\n' +
            'greet "Bob" "evening"\n' +
            '\n' +
            '# Function with return value via echo\n' +
            'factorial() {\n' +
            '    local n=$1\n' +
            '    if [ $n -le 1 ]; then\n' +
            '        echo 1\n' +
            '    else\n' +
            '        local prev=$(factorial $((n - 1)))\n' +
            '        echo $((n * prev))\n' +
            '    fi\n' +
            '}\n' +
            '\n' +
            'for i in 1 2 3 4 5 6 7 8; do\n' +
            '    result=$(factorial $i)\n' +
            '    echo "$i! = $result"\n' +
            'done');
        await H.pause(page);

        await clickRun(page);
        await H.pause(page);

        await exitCodeBlock(page);
        await H.smoothScroll(page, 400);

        // ── 4. STRINGS & ARRAYS ─────────────────────────────
        console.log('[5] Strings & Arrays...');
        await H.pressEnter(page);
        await H.typeText(page, 'Strings & Arrays', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.pressEnter(page);

        await H.typeText(page, 'String operations and array manipulation:');
        await H.pressEnter(page);

        await insertCodeBlock(page);
        await selectLanguage(page, 'bash');
        await H.beat(page);

        await typeCode(page,
            '#!/bin/bash\n' +
            '\n' +
            '# String operations\n' +
            'str="Hello, Bash Scripting!"\n' +
            'echo "String: $str"\n' +
            'echo "Length: ${#str}"\n' +
            'echo "Uppercase: ${str^^}"\n' +
            'echo "Lowercase: ${str,,}"\n' +
            'echo "Substring: ${str:7:4}"\n' +
            'echo "Replace: ${str/Bash/Shell}"\n' +
            '\n' +
            '# Arrays\n' +
            'fruits=("apple" "banana" "cherry" "date" "elderberry")\n' +
            'echo "\\nAll fruits: ${fruits[@]}"\n' +
            'echo "Count: ${#fruits[@]}"\n' +
            'echo "First: ${fruits[0]}"\n' +
            'echo "Last: ${fruits[-1]}"\n' +
            'echo "Slice [1:3]: ${fruits[@]:1:3}"\n' +
            '\n' +
            '# Loop over array\n' +
            'echo "\\nFruits with index:"\n' +
            'for i in "${!fruits[@]}"; do\n' +
            '    echo "  [$i] ${fruits[$i]}"\n' +
            'done');
        await H.pause(page);

        await clickRun(page);
        await H.pause(page);

        await exitCodeBlock(page);
        await H.smoothScroll(page, 400);

        // ── 5. PIPES & TEXT PROCESSING ──────────────────────
        console.log('[6] Pipes & Text Processing...');
        await H.pressEnter(page);
        await H.typeText(page, 'Pipes & Text Processing', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.pressEnter(page);

        await H.typeText(page, 'Chain commands with pipes — the power of Unix:');
        await H.pressEnter(page);

        await insertCodeBlock(page);
        await selectLanguage(page, 'bash');
        await H.beat(page);

        await typeCode(page,
            '#!/bin/bash\n' +
            '\n' +
            '# Create sample data\n' +
            'cat << EOF > /tmp/scores.csv\n' +
            'name,subject,score\n' +
            'Alice,Math,92\n' +
            'Bob,Math,78\n' +
            'Alice,Science,88\n' +
            'Charlie,Math,95\n' +
            'Bob,Science,82\n' +
            'Charlie,Science,91\n' +
            'Alice,English,85\n' +
            'Bob,English,90\n' +
            'Charlie,English,87\n' +
            'EOF\n' +
            '\n' +
            'echo "=== All scores ==="\n' +
            'cat /tmp/scores.csv\n' +
            '\n' +
            'echo "\\n=== Math scores (sorted) ==="\n' +
            'grep "Math" /tmp/scores.csv | sort -t, -k3 -nr\n' +
            '\n' +
            'echo "\\n=== Top scorer per subject ==="\n' +
            'tail -n +2 /tmp/scores.csv | sort -t, -k2,2 -k3,3nr | \\\n' +
            '    awk -F, \'!seen[$2]++ { print $2 ": " $1 " (" $3 ")" }\'');
        await H.pause(page);

        await clickRun(page);
        await H.longPause(page);

        await exitCodeBlock(page);
        await H.smoothScroll(page, 400);

        // ── 6. STDIN INPUT ──────────────────────────────────
        console.log('[7] Stdin input...');
        await H.pressEnter(page);
        await H.typeText(page, 'Reading User Input', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.pressEnter(page);

        await H.typeText(page, 'Toggle stdin to feed input to your script:');
        await H.pressEnter(page);

        await insertCodeBlock(page);
        await selectLanguage(page, 'bash');
        await H.beat(page);

        await typeCode(page,
            '#!/bin/bash\n' +
            '\n' +
            'echo "Enter your name:"\n' +
            'read name\n' +
            'echo "Enter your favorite language:"\n' +
            'read lang\n' +
            '\n' +
            'echo "\\nHello, $name!"\n' +
            'echo "You like $lang — great choice!"\n' +
            '\n' +
            '# Count characters\n' +
            'echo "$name has ${#name} characters"\n' +
            'echo "$lang has ${#lang} characters"');
        await H.pause(page);

        await H.hoverElement(page, '.me-rcb-stdin-btn:last-of-type');
        await H.beat(page);
        await clickStdin(page);
        await H.beat(page);

        await typeStdinInput(page, 'DevOps Engineer\nBash');
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
        console.log('[9] Final scroll...');
        await page.evaluate(() => {
            const w = document.querySelector('.me-canvas-wrapper');
            if (w) w.scrollTo({ top: 0, behavior: 'smooth' });
        });
        await H.longPause(page);
        for (let i = 0; i < 9; i++) {
            await H.smoothScroll(page, 400);
            await page.waitForTimeout(500);
        }
        await H.pause(page);

        console.log('Done!');
    } catch (err) {
        console.error('Recording error:', err.message);
        console.error(err.stack);
    }

    await H.finishRecording(browser, context, page, outputDir, 'code-runner-bash-tutorial');
})();
