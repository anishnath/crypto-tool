/**
 * record-math-demo.js — Calculus AUC Demo (~60–90s)
 *
 * Short story of Area Under the Curve:
 *   1. Introduce f(x) = x²
 *   2. Derivative: slope / rate of change
 *   3. Integral: antiderivative
 *   4. Definite integral → AUC
 *   5. Plot the curve to visualize area
 *
 * Usage:
 *   DEMO_URL=http://localhost:8080 node record-math-demo.js
 */
const H = require('./helpers');

(async () => {
    console.log('Recording: Calculus AUC Demo...');
    const { browser, context, page, outputDir } = await H.launchRecorder('math-editor-calculus-auc-demo');

    try {
        // ─── Scene 1: Open Editor ────────────────────────────
        console.log('[1] Opening editor...');
        await H.openEditor(page);
        await H.longPause(page);

        console.log('[2] Clearing default content...');
        await H.clearEditor(page);
        await H.beat(page);

        // ─── Scene 2: Title & Setup ───────────────────────────
        console.log('[3] Scene 2: Title & Introduction...');
        await H.typeText(page, 'Area Under the Curve: A Calculus Story');
        await page.waitForTimeout(400);
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.pause(page);

        await H.pressEnter(page);
        await H.typeText(page, 'Let\'s explore how derivatives and integrals connect to the area under a curve.');
        await H.pause(page);

        // ─── Scene 3: Function ────────────────────────────────
        console.log('[4] Scene 3: Define f(x) = x²...');
        await H.pressEnter(page, 2);
        await H.typeText(page, 'Our function');
        await H.clickToolbarBtn(page, 'Heading 2');
        await H.beat(page);

        await H.pressEnter(page);
        await H.insertMathBlock(page, 'f(x)=x^2');
        await H.longPause(page);
        await H.exitMathField(page);

        // ─── Scene 4: Derivative ──────────────────────────────
        console.log('[5] Scene 4: Derivative (slope)...');
        await H.pressEnter(page);
        await H.typeText(page, 'Derivative — the slope at any point:');
        await H.beat(page);

        await H.pressEnter(page);
        await H.insertMathBlock(page, '\\frac{d}{dx}x^2', { setValue: true });
        await H.pause(page);

        const mathDisplays1 = await page.$$('.me-math-display');
        if (mathDisplays1.length > 0) {
            await mathDisplays1[mathDisplays1.length - 1].click();
            await page.waitForTimeout(800);
        }
        try {
            await H.clickComputeAction(page, 'derivative');
            await H.extraPause(page);  // show 2x
        } catch (_) {}

        await H.exitMathField(page);

        // ─── Scene 5: Integral (antiderivative) ─────────────────
        console.log('[6] Scene 5: Integral (antiderivative)...');
        await H.pressEnter(page);
        await H.typeText(page, 'Integral — the antiderivative:');
        await H.beat(page);

        await H.pressEnter(page);
        await H.insertMathBlock(page, '\\int x^2 \\, dx', { setValue: true });
        await H.pause(page);

        const mathDisplays2 = await page.$$('.me-math-display');
        if (mathDisplays2.length > 0) {
            await mathDisplays2[mathDisplays2.length - 1].click();
            await page.waitForTimeout(800);
        }
        try {
            await H.clickComputeAction(page, 'integrate');
            await H.extraPause(page);  // show x³/3
        } catch (_) {}

        await H.exitMathField(page);

        // ─── Scene 6: Definite integral → AUC ───────────────────
        console.log('[7] Scene 6: Definite integral (AUC)...');
        await H.pressEnter(page);
        await H.typeText(page, 'Area under the curve from 0 to 1:');
        await H.beat(page);

        await H.pressEnter(page);
        await H.insertMathBlock(page, '\\int_0^1 x^2 \\, dx', { setValue: true });
        await H.pause(page);

        const mathDisplays3 = await page.$$('.me-math-display');
        if (mathDisplays3.length > 0) {
            await mathDisplays3[mathDisplays3.length - 1].click();
            await page.waitForTimeout(800);
        }
        try {
            await H.clickComputeAction(page, 'evaluate');
            await H.extraPause(page);  // show 1/3 if supported
        } catch (_) {}

        await H.exitMathField(page);

        // ─── Scene 7: Plot the curve ───────────────────────────
        console.log('[8] Scene 7: Plot y = x²...');
        await H.pressEnter(page, 2);
        await H.typeText(page, 'Visualize the curve');
        await H.clickToolbarBtn(page, 'Heading 2');
        await H.beat(page);

        await H.pressEnter(page);
        await H.typeText(page, 'Right-click to plot the equation:');
        await H.beat(page);

        await H.pressEnter(page);
        await H.insertMathBlock(page, 'y=x^2');
        await H.longPause(page);

        await H.rightClickLastMathField(page);
        await H.longPause(page);

        try {
            await page.waitForSelector('text=Plot This Equation', { timeout: 3000 });
            await page.click('text=Plot This Equation');
            await H.extraPause(page);  // wait for Plotly to render
            await H.extraPause(page);  // extra time for graph
        } catch (e) {
            console.log('Plot menu not found, trying alternatives...');
            await page.keyboard.press('Escape');
            await H.beat(page);
        }

        await H.smoothScroll(page, 400);
        await H.longPause(page);

        // ─── Scene 8: Wrap-up ──────────────────────────────────
        await H.pressEnter(page);
        await H.typeText(page, 'Derivative → slope. Integral → area. That\'s the fundamental theorem.');
        await H.pause(page);

        await H.smoothScroll(page, 300);
        await H.longPause(page);

        // Scroll back to top for final view
        await page.evaluate(() => {
            const wrapper = document.querySelector('.me-canvas-wrapper');
            if (wrapper) wrapper.scrollTo({ top: 0, behavior: 'smooth' });
        });
        await H.extraPause(page);

        console.log('Calculus AUC demo recording complete!');
    } catch (err) {
        console.error('Recording error:', err.message);
        console.error(err.stack);
    }

    console.log('Finishing recording...');
    await H.finishRecording(browser, context, page, outputDir, 'math-editor-calculus-auc-demo');
})();
