/**
 * record-math-editor-system-eq.js — System of Equations Demo
 *
 * Simple: write system → right-click Plot → done.
 * Then write individual equations and solve via action bar.
 *
 * Usage:
 *   DEMO_URL=http://localhost:8080/mywebapp2_war_exploded node record-math-editor-system-eq.js
 */
const H = require('./helpers');

(async () => {
    console.log('Recording: System of Equations Demo...');
    const { browser, context, page, outputDir } = await H.launchRecorder('math-editor-system-eq');

    try {
        console.log('[1] Setup...');
        await H.openEditor(page);
        await H.pause(page);
        await H.clearEditor(page);

        await page.click('.me-doc-title-input');
        await page.waitForTimeout(150);
        await page.keyboard.press('Meta+a');
        await page.keyboard.type('System of Equations', { delay: 30 });
        await page.keyboard.press('Enter');
        await H.focusEditor(page);

        // ── Title ───────────────────────────────────────────
        console.log('[2] Title...');
        await H.typeText(page, 'Solve & Plot', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.beat(page);

        // ── Write the system ────────────────────────────────
        console.log('[3] Writing system...');
        await H.pressEnter(page);
        await H.typeText(page, 'Given:');
        await H.pressEnter(page);
        await H.insertMathBlock(page,
            '\\begin{cases} x^2 + y = 5 \\\\ 4x - y = 2 \\end{cases}',
            { setValue: true });
        await H.longPause(page);

        // ── Right-click → Plot This Equation ────────────────
        console.log('[4] Right-click → Plot...');
        await H.rightClickLastMathField(page);
        await H.longPause(page);

        try {
            await page.waitForSelector('text=Plot This Equation', { timeout: 3000 });
            await page.click('text=Plot This Equation');
            console.log('[5] Plotting...');
            await H.extraPause(page);
            await H.extraPause(page);
        } catch (_) {
            console.log('  Plot not found');
            await page.keyboard.press('Escape');
        }

        await H.exitMathField(page);
        await H.smoothScroll(page, 400);
        await H.longPause(page);

        // ── Write individual equations and solve ────────────
        console.log('[6] Individual equations...');
        await H.pressEnter(page, 2);
        await H.typeText(page, 'Solve algebraically:');
        await H.pressEnter(page);

        // Equation 1: x²+y=5 → solve for y
        await H.insertMathBlock(page, 'x^2+y=5', { setValue: true });
        await H.pause(page);

        // Use evaluate action (which strips = and solves)
        try {
            const blocks1 = await page.$$('.me-math-display');
            if (blocks1.length > 0) {
                await blocks1[blocks1.length - 1].click();
                await page.waitForTimeout(1000);
            }
            await H.clickComputeAction(page, 'simplify');
            await H.longPause(page);
            // Dismiss popover
            try {
                await page.waitForSelector('.me-result-popover', { timeout: 2000 });
                await page.click('.me-result-popover-btn:first-child');
                await H.beat(page);
            } catch (_) {}
        } catch (_) {}
        await H.exitMathField(page);

        // Equation 2: 4x-y=2 → factor
        await H.pressEnter(page);
        await H.insertMathBlock(page, '4x-y=2', { setValue: true });
        await H.pause(page);

        try {
            const blocks2 = await page.$$('.me-math-display');
            if (blocks2.length > 0) {
                await blocks2[blocks2.length - 1].click();
                await page.waitForTimeout(1000);
            }
            await H.clickComputeAction(page, 'simplify');
            await H.longPause(page);
            try {
                await page.waitForSelector('.me-result-popover', { timeout: 2000 });
                await page.click('.me-result-popover-btn:first-child');
                await H.beat(page);
            } catch (_) {}
        } catch (_) {}
        await H.exitMathField(page);

        await H.smoothScroll(page, 300);

        // ── Conclusion ──────────────────────────────────────
        await H.pressEnter(page, 2);
        await H.typeText(page, 'The curves intersect at the solution points.');
        await H.pause(page);

        // ── Final scroll ────────────────────────────────────
        console.log('[7] Final scroll...');
        await page.evaluate(() => {
            const w = document.querySelector('.me-canvas-wrapper');
            if (w) w.scrollTo({ top: 0, behavior: 'smooth' });
        });
        await H.longPause(page);
        for (let i = 0; i < 4; i++) {
            await H.smoothScroll(page, 400);
            await page.waitForTimeout(500);
        }
        await H.pause(page);

        console.log('Done!');
    } catch (err) {
        console.error('Recording error:', err.message);
        console.error(err.stack);
    }

    await H.finishRecording(browser, context, page, outputDir, 'math-editor-system-eq');
})();
