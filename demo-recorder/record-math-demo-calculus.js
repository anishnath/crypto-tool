/**
 * record-math-demo-calculus.js — Calculus Demo (~75–90s)
 *
 * Showcases Math Editor calculus features via right-click:
 *   1. Title + intro
 *   2. Derivative (right-click → d/dx)
 *   3. Integral (right-click → Integrate)
 *   4. Plot single equation (right-click → Plot This Equation)
 *   5. Plot multiple equations (right-click → Plot Multiple Equations)
 *
 * Usage:
 *   DEMO_URL=http://localhost:8080 node record-math-demo-calculus.js
 */
const H = require('./helpers');

(async () => {
    console.log('Recording: Calculus Demo...');
    const { browser, context, page, outputDir } = await H.launchRecorder('math-editor-calculus-demo');

    try {
        console.log('[1] Opening editor...');
        await H.openEditor(page);
        await H.longPause(page);

        console.log('[2] Clearing content...');
        await H.clearEditor(page);
        await H.beat(page);

        // ─── Scene 1: Title ───────────────────────────────────
        console.log('[3] Title & intro...');
        await H.typeText(page, 'Calculus with the Math Editor');
        await page.waitForTimeout(350);
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.pause(page);

        await H.pressEnter(page);
        await H.typeText(page, 'Right-click any equation for compute and plot options.');
        await H.pause(page);

        // ─── Scene 2: Derivative (right-click) ──────────────────
        console.log('[4] Derivative via right-click...');
        await H.pressEnter(page, 2);
        await H.typeText(page, 'Derivative');
        await H.clickToolbarBtn(page, 'Heading 2');
        await H.beat(page);

        await H.pressEnter(page);
        await H.insertMathBlock(page, 'x^3\\sin(x)', { setValue: true });
        await H.longPause(page);

        await H.rightClickLastMathField(page);
        await H.longPause(page);
        try {
            await page.waitForSelector('text=d/dx  Derivative', { timeout: 3000 });
            await page.click('text=d/dx  Derivative');
            await H.extraPause(page);
        } catch (e) {
            await page.keyboard.press('Escape');
            await H.beat(page);
        }
        await H.exitMathField(page);

        // ─── Scene 3: Integral (right-click) ────────────────────
        console.log('[5] Integral via right-click...');
        await H.pressEnter(page);
        await H.typeText(page, 'Integral:');
        await H.beat(page);

        await H.pressEnter(page);
        await H.insertMathBlock(page, '\\int x^2 e^x \\, dx', { setValue: true });
        await H.pause(page);

        await H.rightClickLastMathField(page);
        await H.longPause(page);
        try {
            await page.waitForSelector('text=∫ dx  Integrate', { timeout: 3000 });
            await page.click('text=∫ dx  Integrate');
            await H.extraPause(page);
        } catch (e) {
            await page.keyboard.press('Escape');
            await H.beat(page);
        }
        await H.exitMathField(page);

        // ─── Scene 4: Plot single (right-click) ──────────────────
        console.log('[6] Plot single equation...');
        await H.pressEnter(page, 2);
        await H.typeText(page, 'Plot');
        await H.clickToolbarBtn(page, 'Heading 2');
        await H.beat(page);

        await H.pressEnter(page);
        await H.insertMathBlock(page, 'y=x^2-4x+3', { setValue: true });
        await H.longPause(page);

        await H.rightClickLastMathField(page);
        await H.longPause(page);
        try {
            await page.waitForSelector('text=Plot This Equation', { timeout: 3000 });
            await page.click('text=Plot This Equation');
            await H.extraPause(page);
            await H.extraPause(page);
        } catch (e) {
            await page.keyboard.press('Escape');
            await H.beat(page);
        }
        await H.smoothScroll(page, 350);
        await H.longPause(page);

        // ─── Scene 5: Plot multiple (right-click) ─────────────────
        console.log('[7] Plot multiple equations...');
        await H.pressEnter(page);
        await H.typeText(page, 'Plot sin and cos:');
        await H.beat(page);

        await H.pressEnter(page);
        await H.insertMathBlock(page, 'y=\\sin(x)', { setValue: true });
        await H.exitMathField(page);
        await H.beat(page);

        await H.pressEnter(page);
        await H.insertMathBlock(page, 'y=\\cos(x)', { setValue: true });
        await H.pause(page);

        await H.rightClickLastMathField(page);
        await H.longPause(page);
        try {
            await page.waitForSelector('text=Plot Multiple Equations', { timeout: 3000 });
            await page.click('text=Plot Multiple Equations');
            await H.longPause(page);

            const selectAll = await page.$('.me-graph-picker-btn-secondary:has-text("Select All")');
            if (selectAll) {
                await selectAll.click();
                await H.pause(page);
            }
            const plotBtn = await page.$('.me-graph-picker-btn-primary');
            if (plotBtn) {
                await plotBtn.click();
                await H.extraPause(page);
                await H.extraPause(page);
            }
        } catch (e) {
            await page.keyboard.press('Escape');
            await H.beat(page);
        }

        await H.smoothScroll(page, 400);
        await H.longPause(page);

        // ─── Wrap-up ───────────────────────────────────────────
        await page.evaluate(() => {
            const wrapper = document.querySelector('.me-canvas-wrapper');
            if (wrapper) wrapper.scrollTo({ top: 0, behavior: 'smooth' });
        });
        await H.extraPause(page);

        console.log('Calculus demo complete!');
    } catch (err) {
        console.error('Recording error:', err.message);
        console.error(err.stack);
    }

    console.log('Finishing...');
    await H.finishRecording(browser, context, page, outputDir, 'math-editor-calculus-demo');
})();
