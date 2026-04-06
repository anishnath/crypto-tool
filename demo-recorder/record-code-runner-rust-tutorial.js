/**
 * record-code-runner-rust-tutorial.js — Rust tutorial showcasing the code runner
 *
 * Demonstrates the new RunnableCodeBlock feature:
 *   1. Hello World (auto-detect language, click Run)
 *   2. Variables & ownership
 *   3. Functions & return values
 *   4. Structs + multi-file (add a second file, run both)
 *   5. User input via stdin
 *   6. Final scroll
 *
 * Usage:
 *   DEMO_URL=http://localhost:8080/mywebapp2_war_exploded node record-code-runner-rust-tutorial.js
 *   DEMO_URL=http://localhost:8080/mywebapp2_war_exploded DEMO_SPEED=1.5 node record-code-runner-rust-tutorial.js
 */
const H = require('./helpers');

// ── Code Runner Helpers ─────────────────────────────────────

/** Insert a code block. Ensures cursor is in a fresh paragraph first,
 *  then converts it to a runnableCodeBlock via TipTap API. */
async function insertCodeBlock(page) {
    await page.evaluate(() => {
        const editor = window.MeEditor;
        if (!editor) return;
        // If currently inside a code block, exit first
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
        // Now we should be in a paragraph — convert to code block
        editor.commands.setRunnableCodeBlock();
    });
    await page.waitForTimeout(500);
}

/** Type code into the active code block by setting textContent directly.
 *  Keyboard typing triggers the double-enter-to-exit shortcut on empty lines,
 *  so we set the content programmatically and simulate a typing animation
 *  by revealing the code line-by-line. */
async function typeCode(page, code) {
    await page.evaluate((text) => {
        // Find the focused code block's <code> contentDOM element
        const editor = window.MeEditor;
        if (!editor) return;
        // Insert text content via TipTap command so it's in the document model
        editor.commands.insertContent(text);
    }, code);
    await page.waitForTimeout(400);
}

/** Click the Run button on the last code block */
async function clickRun(page) {
    const runBtns = await page.$$('.me-rcb-run-btn');
    if (runBtns.length > 0) {
        await runBtns[runBtns.length - 1].click();
    }
    // Wait for execution to complete
    await page.waitForTimeout(3000);
}

/** Click the + File button on the last code block header */
async function clickAddFile(page) {
    const addBtns = await page.$$('.me-rcb-add-file-btn');
    if (addBtns.length > 0) {
        await addBtns[addBtns.length - 1].click();
    }
    await page.waitForTimeout(500);
}

/** Click a specific file tab by index on the last code block */
async function clickTab(page, tabIndex) {
    const blocks = await page.$$('.me-rcb');
    if (blocks.length > 0) {
        const lastBlock = blocks[blocks.length - 1];
        const tabs = await lastBlock.$$('.me-rcb-tab');
        if (tabs[tabIndex]) {
            await tabs[tabIndex].click();
        }
    }
    await page.waitForTimeout(400);
}

/** Type into the extra file textarea (for non-primary file tabs) */
async function typeInExtraArea(page, code) {
    const areas = await page.$$('.me-rcb-extra-area');
    if (areas.length > 0) {
        const area = areas[areas.length - 1];
        await area.focus();
        await page.waitForTimeout(200);
        await page.keyboard.type(code, { delay: 18 });
    }
    await page.waitForTimeout(300);
}

/** Toggle the stdin panel on the last code block */
async function clickStdin(page) {
    const btns = await page.$$('.me-rcb-stdin-btn');
    if (btns.length > 0) {
        await btns[btns.length - 1].click();
    }
    await page.waitForTimeout(400);
}

/** Type into the stdin textarea of the last code block */
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

/** Select a language from the dropdown on the last code block */
async function selectLanguage(page, lang) {
    const selects = await page.$$('.me-rcb-lang-select');
    if (selects.length > 0) {
        await selects[selects.length - 1].selectOption(lang);
    }
    await page.waitForTimeout(300);
}

/** Exit code block to create a new paragraph below via TipTap API */
async function exitCodeBlock(page) {
    await page.evaluate(() => {
        const editor = window.MeEditor;
        if (!editor) return;
        // Find the end of the current code block and insert a paragraph after it
        const { $from } = editor.state.selection;
        // Walk up to find the runnableCodeBlock node boundary
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
                    // Check if the next node is a paragraph we can enter
                    editor.chain()
                        .setTextSelection(after)
                        .focus()
                        .run();
                }
                return;
            }
        }
        // Fallback: just move to end and insert paragraph
        editor.commands.focus('end');
    });
    await page.waitForTimeout(400);
}

// ── Main Recording ──────────────────────────────────────────

(async () => {
    console.log('Recording: Rust Tutorial — Code Runner Demo...');
    const { browser, context, page, outputDir } = await H.launchRecorder('code-runner-rust-tutorial', { width: 1280, height: 720 });

    try {
        // ── SETUP ───────────────────────────────────────────
        console.log('[1] Setup...');
        await H.openEditor(page);
        await H.pause(page);
        await H.clearEditor(page);

        // Title
        await page.click('.me-doc-title-input');
        await page.waitForTimeout(150);
        await page.keyboard.press('Meta+a');
        await page.keyboard.type('Rust Tutorial — Write & Run', { delay: 25 });
        await page.keyboard.press('Enter');
        await H.focusEditor(page);

        // ── 1. HELLO WORLD ──────────────────────────────────
        console.log('[2] Hello World...');
        await H.typeText(page, 'Hello World', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.pressEnter(page);

        await H.typeText(page, "Let's start with the classic. Insert a code block and type:");
        await H.pressEnter(page);

        await insertCodeBlock(page);
        await H.beat(page);

        // Type the Rust code — auto-detect should kick in
        await typeCode(page,
            'fn main() {\n' +
            '    println!("Hello, world!");\n' +
            '}');
        await H.pause(page);

        // Wait for auto-detect to recognize Rust
        await page.waitForTimeout(1500);
        await H.beat(page);

        // Click Run
        await clickRun(page);
        await H.pause(page);

        // Exit and continue
        await exitCodeBlock(page);
        await H.smoothScroll(page, 250);

        // ── 2. VARIABLES & OWNERSHIP ────────────────────────
        console.log('[3] Variables & Ownership...');
        await H.pressEnter(page);
        await H.typeText(page, 'Variables & Ownership', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.pressEnter(page);

        await H.typeText(page, "Rust's ownership system prevents data races at compile time:");
        await H.pressEnter(page);

        await insertCodeBlock(page);
        await selectLanguage(page, 'rust');
        await H.beat(page);

        await typeCode(page,
            'fn main() {\n' +
            '    let name = String::from("Rust");\n' +
            '    let greeting = format!("Hello, {}!", name);\n' +
            '    println!("{}", greeting);\n' +
            '\n' +
            '    // Ownership: name is still valid here\n' +
            '    println!("Language: {}", name);\n' +
            '\n' +
            '    // Move semantics\n' +
            '    let moved = name;\n' +
            '    println!("Moved: {}", moved);\n' +
            '    // println!("{}", name); // ERROR: value used after move\n' +
            '}');
        await H.pause(page);

        await clickRun(page);
        await H.pause(page);

        await exitCodeBlock(page);
        await H.smoothScroll(page, 350);

        // ── 3. FUNCTIONS ────────────────────────────────────
        console.log('[4] Functions...');
        await H.pressEnter(page);
        await H.typeText(page, 'Functions & Pattern Matching', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.pressEnter(page);

        await H.typeText(page, 'Rust functions with match expressions:');
        await H.pressEnter(page);

        await insertCodeBlock(page);
        await selectLanguage(page, 'rust');
        await H.beat(page);

        await typeCode(page,
            'fn fizzbuzz(n: u32) -> String {\n' +
            '    match (n % 3, n % 5) {\n' +
            '        (0, 0) => String::from("FizzBuzz"),\n' +
            '        (0, _) => String::from("Fizz"),\n' +
            '        (_, 0) => String::from("Buzz"),\n' +
            '        _      => n.to_string(),\n' +
            '    }\n' +
            '}\n' +
            '\n' +
            'fn main() {\n' +
            '    for i in 1..=20 {\n' +
            '        println!("{:>2}: {}", i, fizzbuzz(i));\n' +
            '    }\n' +
            '}');
        await H.pause(page);

        await clickRun(page);
        await H.pause(page);

        await exitCodeBlock(page);
        await H.smoothScroll(page, 400);

        // ── 4. MULTI-FILE: STRUCTS ──────────────────────────
        console.log('[5] Multi-file structs...');
        await H.pressEnter(page);
        await H.typeText(page, 'Multi-File: Structs & Modules', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.pressEnter(page);

        await H.typeText(page, 'The editor supports multiple files. Click "+ File" to add one:');
        await H.pressEnter(page);

        await insertCodeBlock(page);
        await selectLanguage(page, 'rust');
        await H.beat(page);

        // Type main.rs content
        await typeCode(page,
            'mod point;\n' +
            'use point::Point;\n' +
            '\n' +
            'fn main() {\n' +
            '    let a = Point::new(3.0, 4.0);\n' +
            '    let b = Point::new(6.0, 8.0);\n' +
            '    println!("A = {}", a);\n' +
            '    println!("B = {}", b);\n' +
            '    println!("Distance = {:.2}", a.distance_to(&b));\n' +
            '}');
        await H.pause(page);

        // Add a second file
        await H.hoverElement(page, '.me-rcb-add-file-btn:last-of-type');
        await H.beat(page);
        await clickAddFile(page);
        await H.pause(page);

        // Now we're on the second file tab — type into the extra area
        await typeInExtraArea(page,
            'use std::fmt;\n' +
            '\n' +
            'pub struct Point {\n' +
            '    x: f64,\n' +
            '    y: f64,\n' +
            '}\n' +
            '\n' +
            'impl Point {\n' +
            '    pub fn new(x: f64, y: f64) -> Self {\n' +
            '        Point { x, y }\n' +
            '    }\n' +
            '\n' +
            '    pub fn distance_to(&self, other: &Point) -> f64 {\n' +
            '        ((self.x - other.x).powi(2) + (self.y - other.y).powi(2)).sqrt()\n' +
            '    }\n' +
            '}\n' +
            '\n' +
            'impl fmt::Display for Point {\n' +
            '    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {\n' +
            '        write!(f, "({}, {})", self.x, self.y)\n' +
            '    }\n' +
            '}');
        await H.pause(page);

        // Switch back to main.rs tab to show it
        await clickTab(page, 0);
        await H.beat(page);

        // Run the multi-file project
        await clickRun(page);
        await H.longPause(page);

        await exitCodeBlock(page);
        await H.smoothScroll(page, 400);

        // ── 5. STDIN INPUT ──────────────────────────────────
        console.log('[6] Stdin input...');
        await H.pressEnter(page);
        await H.typeText(page, 'Reading User Input', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.pressEnter(page);

        await H.typeText(page, 'Toggle stdin to provide input to your program:');
        await H.pressEnter(page);

        await insertCodeBlock(page);
        await selectLanguage(page, 'rust');
        await H.beat(page);

        await typeCode(page,
            'use std::io;\n' +
            '\n' +
            'fn main() {\n' +
            '    let mut input = String::new();\n' +
            '    io::stdin().read_line(&mut input).unwrap();\n' +
            '    let name = input.trim();\n' +
            '    println!("Hello, {}! Welcome to Rust.", name);\n' +
            '\n' +
            '    let mut num_input = String::new();\n' +
            '    io::stdin().read_line(&mut num_input).unwrap();\n' +
            '    let n: u32 = num_input.trim().parse().unwrap();\n' +
            '    println!("{} squared = {}", n, n * n);\n' +
            '}');
        await H.pause(page);

        // Toggle stdin
        await H.hoverElement(page, '.me-rcb-stdin-btn:last-of-type');
        await H.beat(page);
        await clickStdin(page);
        await H.beat(page);

        // Type stdin values
        await typeStdinInput(page, 'Rustacean\n42');
        await H.pause(page);

        // Run
        await clickRun(page);
        await H.longPause(page);

        await exitCodeBlock(page);
        await H.smoothScroll(page, 300);

        // ── 6. BONUS: ITERATORS ─────────────────────────────
        console.log('[7] Iterators...');
        await H.pressEnter(page);
        await H.typeText(page, 'Iterators & Closures', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.pressEnter(page);

        await H.typeText(page, "Rust's zero-cost iterators are powerful:");
        await H.pressEnter(page);

        await insertCodeBlock(page);
        await selectLanguage(page, 'rust');
        await H.beat(page);

        await typeCode(page,
            'fn main() {\n' +
            '    let numbers = vec![1, 2, 3, 4, 5, 6, 7, 8, 9, 10];\n' +
            '\n' +
            '    let sum_of_squares: i32 = numbers.iter()\n' +
            '        .filter(|&&x| x % 2 == 0)\n' +
            '        .map(|&x| x * x)\n' +
            '        .sum();\n' +
            '\n' +
            '    println!("Even numbers: {:?}",\n' +
            '        numbers.iter().filter(|&&x| x % 2 == 0).collect::<Vec<_>>());\n' +
            '    println!("Sum of their squares: {}", sum_of_squares);\n' +
            '\n' +
            '    // Chained transforms\n' +
            '    let words = vec!["hello", "world", "from", "rust"];\n' +
            '    let result: String = words.iter()\n' +
            '        .map(|w| {\n' +
            '            let mut c = w.chars();\n' +
            '            match c.next() {\n' +
            '                None => String::new(),\n' +
            '                Some(f) => f.to_uppercase().to_string() + c.as_str(),\n' +
            '            }\n' +
            '        })\n' +
            '        .collect::<Vec<_>>()\n' +
            '        .join(" ");\n' +
            '    println!("{}", result);\n' +
            '}');
        await H.pause(page);

        await clickRun(page);
        await H.longPause(page);

        // ── EXPORT AS PDF ────────────────────────────────────
        console.log('[8] Export as PDF...');

        // Scroll back to top first
        await page.evaluate(() => {
            const w = document.querySelector('.me-canvas-wrapper');
            if (w) w.scrollTo({ top: 0, behavior: 'smooth' });
        });
        await H.longPause(page);

        // Bypass auth: mock checkSession to return logged-in
        await page.evaluate(() => {
            if (!window.MathAPI) window.MathAPI = {};
            window.MathAPI.checkSession = function () {
                return Promise.resolve({ logged_in: true, user_id: 'demo-user' });
            };
        });

        // Intercept the PDF download — capture the blob URL and open it in a new tab
        // instead of triggering a file download (which doesn't show in the recording)
        const downloadPromise = page.waitForEvent('download', { timeout: 120000 }).catch(() => null);

        // Click Export dropdown, then Export as PDF
        await page.click('.me-btn-export');
        await page.waitForTimeout(400);
        await page.click('.me-export-menu-item[data-export="pdf"]');
        await H.beat(page);

        // Wait for the PDF export progress overlay
        console.log('[8a] Waiting for PDF compilation...');
        await H.extraPause(page);
        await H.extraPause(page);
        await H.extraPause(page);

        // Wait for download to complete
        const download = await downloadPromise;
        if (download) {
            console.log('[8b] PDF downloaded, opening...');
            // Save the PDF locally and open it in the browser
            const pdfPath = await download.path();
            if (pdfPath) {
                const pdfPage = await context.newPage();
                await pdfPage.goto('file://' + pdfPath);
                await H.longPause(pdfPage);
                await H.extraPause(pdfPage);
                // Scroll through the PDF
                for (let i = 0; i < 3; i++) {
                    await pdfPage.keyboard.press('Space');
                    await page.waitForTimeout(800);
                }
                await H.longPause(pdfPage);
                await pdfPage.close();
            }
        } else {
            console.log('[8b] No download captured — PDF may have failed or timed out');
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

    await H.finishRecording(browser, context, page, outputDir, 'code-runner-rust-tutorial');
})();
