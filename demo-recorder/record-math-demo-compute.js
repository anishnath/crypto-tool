/**
 * record-math-demo-compute.js — Right-Click Compute Demo (~60–75s)
 *
 * Showcases every right-click compute action on a single equation:
 *   1. Title
 *   2. Write an equation
 *   3. Right-click → Evaluate
 *   4. New equation → Right-click → Simplify
 *   5. New equation → Right-click → Solve for x
 *   6. New equation → Right-click → Factor
 *   7. New equation → Right-click → Derivative
 *   8. New equation → Right-click → Integrate
 *
 * Each action: type label, insert math, right-click, pick action, pause to show result.
 *
 * Usage:
 *   DEMO_URL=http://localhost:8080 node record-math-demo-compute.js
 */
const H = require('./helpers');

/**
 * Right-click the last math-field → click a context menu item by label.
 * Falls back to Escape if the item isn't found.
 */
async function rightClickAction(page, menuLabel) {
    await H.rightClickLastMathField(page);
    await H.longPause(page);
    try {
        await page.waitForSelector(`text=${menuLabel}`, { timeout: 3000 });
        await page.click(`text=${menuLabel}`);
        await H.extraPause(page);
    } catch (e) {
        await page.keyboard.press('Escape');
        await H.beat(page);
    }
    await H.exitMathField(page);
}

(async () => {
    console.log('Recording: Right-Click Compute Demo...');
    const { browser, context, page, outputDir } = await H.launchRecorder('math-editor-compute-demo');

    try {
        console.log('[1] Opening editor...');
        await H.openEditor(page);
        await H.longPause(page);

        console.log('[2] Clearing content...');
        await H.clearEditor(page);
        await H.beat(page);

        // ─── Title ──────────────────────────────────────────────
        console.log('[3] Title...');
        await H.typeText(page, 'Right-Click Compute');
        await page.waitForTimeout(350);
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.longPause(page);

        // ─── Evaluate ───────────────────────────────────────────
        console.log('[4] Evaluate...');
        await H.pressEnter(page);
        await H.typeText(page, 'Evaluate');
        await H.clickToolbarBtn(page, 'Heading 2');
        await H.beat(page);

        await H.pressEnter(page);
        await H.insertMathBlock(page, '\\frac{3^4 + 5^2}{7 - 2}', { setValue: true });
        await H.longPause(page);

        await rightClickAction(page, 'Evaluate');
        await H.longPause(page);

        // ─── Simplify ───────────────────────────────────────────
        console.log('[5] Simplify...');
        await H.pressEnter(page);
        await H.typeText(page, 'Simplify');
        await H.clickToolbarBtn(page, 'Heading 2');
        await H.beat(page);

        await H.pressEnter(page);
        await H.insertMathBlock(page, '\\frac{x^2 - 4}{x - 2}', { setValue: true });
        await H.longPause(page);

        await rightClickAction(page, 'Simplify');
        await H.longPause(page);

        await H.smoothScroll(page, 300);
        await H.beat(page);

        // ─── Solve ──────────────────────────────────────────────
        console.log('[6] Solve for x...');
        await H.pressEnter(page);
        await H.typeText(page, 'Solve');
        await H.clickToolbarBtn(page, 'Heading 2');
        await H.beat(page);

        await H.pressEnter(page);
        await H.insertMathBlock(page, 'x^2 - 5x + 6 = 0', { setValue: true });
        await H.longPause(page);

        await rightClickAction(page, 'Solve for x');
        await H.longPause(page);

        await H.smoothScroll(page, 300);
        await H.beat(page);

        // ─── Factor ─────────────────────────────────────────────
        console.log('[7] Factor...');
        await H.pressEnter(page);
        await H.typeText(page, 'Factor');
        await H.clickToolbarBtn(page, 'Heading 2');
        await H.beat(page);

        await H.pressEnter(page);
        await H.insertMathBlock(page, 'x^3 - 6x^2 + 11x - 6', { setValue: true });
        await H.longPause(page);

        await rightClickAction(page, 'Factor');
        await H.longPause(page);

        await H.smoothScroll(page, 300);
        await H.beat(page);

        // ─── Derivative ─────────────────────────────────────────
        console.log('[8] Derivative...');
        await H.pressEnter(page);
        await H.typeText(page, 'Derivative');
        await H.clickToolbarBtn(page, 'Heading 2');
        await H.beat(page);

        await H.pressEnter(page);
        await H.insertMathBlock(page, 'x^3 \\sin(x)', { setValue: true });
        await H.longPause(page);

        await rightClickAction(page, 'd/dx  Derivative');
        await H.longPause(page);

        await H.smoothScroll(page, 300);
        await H.beat(page);

        // ─── Integrate ──────────────────────────────────────────
        console.log('[9] Integrate...');
        await H.pressEnter(page);
        await H.typeText(page, 'Integrate');
        await H.clickToolbarBtn(page, 'Heading 2');
        await H.beat(page);

        await H.pressEnter(page);
        await H.insertMathBlock(page, 'x^2 e^x', { setValue: true });
        await H.longPause(page);

        await rightClickAction(page, '\u222B dx  Integrate');
        await H.longPause(page);

        await H.longPause(page);

        // ─── Scroll to top ──────────────────────────────────────
        await page.evaluate(() => {
            const wrapper = document.querySelector('.me-canvas-wrapper');
            if (wrapper) wrapper.scrollTo({ top: 0, behavior: 'smooth' });
        });
        await H.extraPause(page);

        console.log('Compute demo complete!');
    } catch (err) {
        console.error('Recording error:', err.message);
        console.error(err.stack);
    }

    console.log('Finishing...');
    await H.finishRecording(browser, context, page, outputDir, 'math-editor-compute-demo');
})();
