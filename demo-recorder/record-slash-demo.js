/**
 * record-slash-demo.js — Slash Commands & Formatting Demo (~40s)
 *
 * Shows:
 *   1. Slash menu (/) for quick block insertion
 *   2. Headings, lists, tables, code blocks, blockquotes
 *   3. Toolbar formatting: bold, italic, alignment
 *   4. Keyboard shortcuts (Ctrl+B, Ctrl+I, etc.)
 *
 * Usage:
 *   DEMO_URL=http://localhost:8080 node record-slash-demo.js
 */
const H = require('./helpers');

(async () => {
    console.log('Recording: Slash Commands & Formatting Demo...');
    const { browser, context, page, outputDir } = await H.launchRecorder('slash-commands-demo');

    try {
        await H.openEditor(page);
        await H.longPause(page);
        await H.clearEditor(page);
        await H.beat(page);

        // ─── Scene 1: Slash Menu — Heading ───────────────────
        // Type / to open slash menu
        await H.openSlashMenu(page);
        await H.pause(page);

        // Select Heading 1
        await H.selectSlashItem(page, 'Heading 1');
        await H.typeText(page, 'Slash Commands Quick Guide');
        await H.pause(page);

        // ─── Scene 2: Paragraph with formatting ─────────────
        await H.pressEnter(page);
        await H.typeText(page, 'Type ');
        await H.beat(page);

        // Bold with Ctrl+B
        await page.keyboard.down('Meta');
        await page.keyboard.press('b');
        await page.keyboard.up('Meta');
        await H.typeText(page, '/');
        await page.keyboard.down('Meta');
        await page.keyboard.press('b');
        await page.keyboard.up('Meta');
        await H.typeText(page, ' at the start of any empty line to see all available blocks.');
        await H.pause(page);

        // ─── Scene 3: Slash Menu — Bullet List ──────────────
        await H.pressEnter(page, 2);
        await H.openSlashMenu(page);
        await H.pause(page);
        await H.selectSlashItem(page, 'Bullet List');

        await H.typeText(page, 'Math equations (inline & block)');
        await H.pressEnter(page);
        await H.typeText(page, 'Tables with math support');
        await H.pressEnter(page);
        await H.typeText(page, 'Code blocks for algorithms');
        await H.pressEnter(page);
        await H.typeText(page, 'Drawings and diagrams');
        await H.pause(page);

        // Exit list with double Enter
        await H.pressEnter(page, 2);

        // ─── Scene 4: Slash Menu — Heading 2 ────────────────
        await H.openSlashMenu(page);
        await H.beat(page);
        await H.selectSlashItem(page, 'Heading 2');
        await H.typeText(page, 'Rich Text Formatting');
        await H.pause(page);

        // ─── Scene 5: Bold, Italic, Underline via toolbar ───
        await H.pressEnter(page);
        await H.typeText(page, 'Select text and click toolbar buttons: ');

        // Type "bold" and make it bold
        await H.typeText(page, 'bold');
        // Select the word "bold" (Shift+Left x4)
        for (let i = 0; i < 4; i++) {
            await page.keyboard.press('Shift+ArrowLeft');
        }
        await H.clickToolbarBtn(page, 'Bold');
        await page.keyboard.press('End'); // move to end
        await H.typeText(page, ', ');

        // Type "italic" and make it italic
        await H.typeText(page, 'italic');
        for (let i = 0; i < 6; i++) {
            await page.keyboard.press('Shift+ArrowLeft');
        }
        await H.clickToolbarBtn(page, 'Italic');
        await page.keyboard.press('End');
        await H.typeText(page, ', ');

        // Type "underline" and make it underline
        await H.typeText(page, 'underline');
        for (let i = 0; i < 9; i++) {
            await page.keyboard.press('Shift+ArrowLeft');
        }
        await H.clickToolbarBtn(page, 'Underline');
        await page.keyboard.press('End');
        await H.typeText(page, '.');
        await H.pause(page);

        // ─── Scene 6: Slash Menu — Table ─────────────────────
        await H.pressEnter(page, 2);
        await H.openSlashMenu(page);
        await H.beat(page);
        await H.selectSlashItem(page, 'Table');
        await H.pause(page);

        // Fill table cells
        await H.typeText(page, 'Function');
        await page.keyboard.press('Tab');
        await H.typeText(page, 'Derivative');
        await page.keyboard.press('Tab');
        await H.typeText(page, 'Integral');
        await page.keyboard.press('Tab');
        await H.beat(page);

        // Row 2
        await H.typeText(page, 'sin(x)');
        await page.keyboard.press('Tab');
        await H.typeText(page, 'cos(x)');
        await page.keyboard.press('Tab');
        await H.typeText(page, '-cos(x)');
        await page.keyboard.press('Tab');
        await H.beat(page);

        // Row 3
        await H.typeText(page, 'e^x');
        await page.keyboard.press('Tab');
        await H.typeText(page, 'e^x');
        await page.keyboard.press('Tab');
        await H.typeText(page, 'e^x');
        await H.longPause(page);

        // Move out of table
        await page.keyboard.press('Escape');
        await page.keyboard.press('ArrowDown');
        await page.keyboard.press('ArrowDown');

        // ─── Scene 7: Slash Menu — Code Block ────────────────
        await H.pressEnter(page, 2);
        await H.openSlashMenu(page);
        await H.beat(page);
        await H.selectSlashItem(page, 'Code Block');
        await H.beat(page);

        await H.typeText(page, '# Newton\'s method\ndef newton(f, df, x0, tol=1e-8):\n    while abs(f(x0)) > tol:\n        x0 = x0 - f(x0) / df(x0)\n    return x0', { fast: true });
        await H.longPause(page);

        // ─── Scene 8: Slash Menu — Blockquote ────────────────
        // Move out of code block
        await page.keyboard.press('ArrowDown');
        await H.pressEnter(page, 2);

        await H.openSlashMenu(page);
        await H.beat(page);
        await H.selectSlashItem(page, 'Blockquote');
        await H.typeText(page, '"Mathematics is the queen of the sciences." — Carl Friedrich Gauss');
        await H.longPause(page);

        // ─── Scene 9: Slash Menu — Divider ───────────────────
        await H.pressEnter(page, 2);
        await H.openSlashMenu(page);
        await H.beat(page);
        await H.selectSlashItem(page, 'Divider');
        await H.pause(page);

        // ─── Scene 10: Math Block via Slash ──────────────────
        await H.pressEnter(page);
        await H.openSlashMenu(page);
        await H.beat(page);
        await H.selectSlashItem(page, 'Math Block');
        await page.waitForTimeout(800);

        await H.typeLatex(page, 'E=mc^2');
        await H.longPause(page);

        // ─── Scene 11: Show final document ───────────────────
        // Scroll to top
        await page.evaluate(() => {
            const wrapper = document.querySelector('.me-canvas-wrapper');
            if (wrapper) wrapper.scrollTo({ top: 0, behavior: 'smooth' });
        });
        await H.extraPause(page);

        // Slowly scroll through the whole document
        for (let i = 0; i < 5; i++) {
            await H.smoothScroll(page, 200);
        }
        await H.longPause(page);

        console.log('Slash commands demo recording complete!');
    } catch (err) {
        console.error('Recording error:', err.message);
    }

    await H.finishRecording(browser, context, page, outputDir, 'slash-commands-demo');
})();
