/**
 * record-math-demo-quiz.js — Math Quiz Demo (~45–60s)
 *
 * One clean multiple-choice question with inline-math choices:
 *   1. Title
 *   2. Question with a display-math equation
 *   3. Four choices using inline math (A–D)
 *   4. Right-click the equation → Derivative to verify
 *
 * Usage:
 *   DEMO_URL=http://localhost:8080 node record-math-demo-quiz.js
 */
const H = require('./helpers');

(async () => {
    console.log('Recording: Math Quiz Demo...');
    const { browser, context, page, outputDir } = await H.launchRecorder('math-editor-quiz-demo');

    try {
        console.log('[1] Opening editor...');
        await H.openEditor(page);
        await H.longPause(page);

        console.log('[2] Clearing content...');
        await H.clearEditor(page);
        await H.beat(page);

        // ─── Title ──────────────────────────────────────────────
        console.log('[3] Title...');
        await H.typeText(page, 'Practice Quiz: Derivatives');
        await page.waitForTimeout(350);
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.longPause(page);

        // ─── Question ───────────────────────────────────────────
        console.log('[4] Question...');
        await H.pressEnter(page);
        await H.typeText(page, 'Find the derivative of the following function:');
        await H.pause(page);

        await H.pressEnter(page, 2);
        await H.insertMathBlock(page, 'f(x) = x^3 - 6x^2 + 9x + 1', { setValue: true });
        await H.exitMathField(page);
        await H.longPause(page);

        // ─── Choices with inline math ───────────────────────────
        console.log('[5] Choices with inline math...');

        // A)
        await H.pressEnter(page, 2);
        await H.typeText(page, 'A)  ');
        await H.insertInlineMath(page, '3x^2 - 12x + 9', { setValue: true });
        await H.exitMathField(page);
        await H.pause(page);

        // B)
        await H.pressEnter(page);
        await H.typeText(page, 'B)  ');
        await H.insertInlineMath(page, '3x^2 - 6x + 9', { setValue: true });
        await H.exitMathField(page);
        await H.pause(page);

        // C)
        await H.pressEnter(page);
        await H.typeText(page, 'C)  ');
        await H.insertInlineMath(page, 'x^3 - 12x + 9', { setValue: true });
        await H.exitMathField(page);
        await H.pause(page);

        // D)
        await H.pressEnter(page);
        await H.typeText(page, 'D)  ');
        await H.insertInlineMath(page, '3x^2 - 12x + 1', { setValue: true });
        await H.exitMathField(page);
        await H.longPause(page);

        // ─── Verify: right-click equation → Derivative ──────────
        console.log('[6] Verify via right-click derivative...');

        // Click the original equation (first math-field, index 0)
        await H.clickMathField(page, 0);
        await H.pause(page);

        await H.rightClickLastMathField(page);
        await H.longPause(page);
        try {
            await page.waitForSelector('text=d/dx  Derivative', { timeout: 3000 });
            await page.click('text=d/dx  Derivative');
            await H.extraPause(page);
            await H.extraPause(page);
        } catch (e) {
            await page.keyboard.press('Escape');
            await H.beat(page);
        }
        await H.exitMathField(page);
        await H.longPause(page);

        // ─── Scroll to top for final view ───────────────────────
        await page.evaluate(() => {
            const wrapper = document.querySelector('.me-canvas-wrapper');
            if (wrapper) wrapper.scrollTo({ top: 0, behavior: 'smooth' });
        });
        await H.extraPause(page);

        console.log('Math Quiz demo complete!');
    } catch (err) {
        console.error('Recording error:', err.message);
        console.error(err.stack);
    }

    console.log('Finishing...');
    await H.finishRecording(browser, context, page, outputDir, 'math-editor-quiz-demo');
})();
