/**
 * record-math-demo-trig-sub.js — Trig Substitution Worked Example (~90s)
 *
 * Records a full calculus worked solution in the math editor:
 *   Example: Determine integral of 1/sqrt(1-x^2) dx
 *   Solution via trig substitution x = sin(theta)
 *
 * Showcases: bold/italic formatting, inline math within text,
 *            display math blocks, multi-line aligned derivation.
 *
 * Usage:
 *   DEMO_URL=http://localhost:8080 node record-math-demo-trig-sub.js
 */
const H = require('./helpers');

/** Exit math field and ensure cursor is at end of document */
async function exitAndContinue(page) {
    await H.exitMathField(page);
    await H.moveCursorToEnd(page);
}

(async () => {
    console.log('Recording: Trig Substitution Demo...');
    const { browser, context, page, outputDir } = await H.launchRecorder('math-editor-trig-sub-demo');

    try {
        console.log('[1] Opening editor...');
        await H.openEditor(page);
        await H.longPause(page);

        console.log('[2] Clearing content...');
        await H.clearEditor(page);
        await H.beat(page);

        // ─── Example statement ──────────────────────────────────
        console.log('[3] Example statement...');

        // "Example." in bold
        await H.clickToolbarBtn(page, 'Bold');
        await H.typeText(page, 'Example.');
        await H.clickToolbarBtn(page, 'Bold');
        await H.typeText(page, ' Determine ');
        await H.insertInlineMath(page, '\\int \\frac{1}{\\sqrt{1-x^2}} \\, dx', { setValue: true });
        await exitAndContinue(page);
        await H.typeText(page, '.');
        await H.longPause(page);

        // ─── Solution intro ─────────────────────────────────────
        console.log('[4] Solution intro...');
        await H.pressEnter(page, 2);
        await H.moveCursorToEnd(page);

        // "Solution." in italic
        await H.clickToolbarBtn(page, 'Italic');
        await H.typeText(page, 'Solution.');
        await H.clickToolbarBtn(page, 'Italic');
        await H.typeText(page, ' Using the substitution ');
        await H.insertInlineMath(page, 'x = \\sin\\theta', { setValue: true });
        await exitAndContinue(page);
        await H.typeText(page, ' ');
        await H.insertInlineMath(page, '\\left( -\\frac{\\pi}{2} < \\theta < \\frac{\\pi}{2} \\right)', { setValue: true });
        await exitAndContinue(page);
        await H.typeText(page, ', we have');
        await H.pause(page);

        // ─── dx/dtheta = cos theta ─────────────────────────────
        console.log('[5] dx/dtheta...');
        await H.pressEnter(page, 2);
        await H.moveCursorToEnd(page);
        await H.insertMathBlock(page, '\\frac{dx}{d\\theta} = \\cos\\theta', { setValue: true });
        await exitAndContinue(page);
        await H.pause(page);

        // ─── "and" + cos theta identity ─────────────────────────
        console.log('[6] cos theta identity...');
        await H.pressEnter(page);
        await H.moveCursorToEnd(page);
        await H.typeText(page, 'and');
        await H.pressEnter(page, 2);
        await H.moveCursorToEnd(page);
        await H.insertMathBlock(page, '\\cos\\theta = \\sqrt{1 - \\sin^2\\theta} = \\sqrt{1 - x^2} > 0.', { setValue: true });
        await exitAndContinue(page);
        await H.pause(page);

        await H.smoothScroll(page, 300);
        await H.beat(page);

        // ─── "Thus," + aligned derivation ───────────────────────
        console.log('[7] Aligned derivation...');
        await H.pressEnter(page);
        await H.moveCursorToEnd(page);
        await H.typeText(page, 'Thus,');
        await H.pause(page);

        await H.pressEnter(page, 2);
        await H.moveCursorToEnd(page);
        await H.insertMathBlock(page,
            '\\begin{aligned}' +
            '\\int \\frac{1}{\\sqrt{1-x^2}} \\, dx ' +
            '&= \\int \\frac{1}{\\sqrt{1-x^2}} \\cdot \\frac{dx}{d\\theta} \\, d\\theta \\\\' +
            '&= \\int \\frac{1}{\\cos\\theta} \\cdot \\cos\\theta \\, d\\theta \\\\' +
            '&= \\int 1 \\, d\\theta \\\\' +
            '&= \\theta + C \\\\' +
            '&= \\sin^{-1} x + C,' +
            '\\end{aligned}',
            { setValue: true });
        await exitAndContinue(page);
        await H.extraPause(page);

        await H.smoothScroll(page, 350);
        await H.beat(page);

        // ─── Closing explanation ────────────────────────────────
        console.log('[8] Closing...');
        await H.pressEnter(page, 2);
        await H.moveCursorToEnd(page);
        await H.typeText(page, 'where the last step holds because');
        await H.pause(page);

        await H.pressEnter(page, 2);
        await H.moveCursorToEnd(page);
        await H.insertMathBlock(page,
            'x = \\sin\\theta \\quad \\left( -\\frac{\\pi}{2} < \\theta < \\frac{\\pi}{2} \\right) ' +
            '\\implies \\theta = \\sin^{-1} x.',
            { setValue: true });
        await exitAndContinue(page);
        await H.longPause(page);
        await H.longPause(page);

        // ─── Scroll to top for final view ───────────────────────
        await page.evaluate(() => {
            const wrapper = document.querySelector('.me-canvas-wrapper');
            if (wrapper) wrapper.scrollTo({ top: 0, behavior: 'smooth' });
        });
        await H.extraPause(page);

        console.log('Trig substitution demo complete!');
    } catch (err) {
        console.error('Recording error:', err.message);
        console.error(err.stack);
    }

    console.log('Finishing...');
    await H.finishRecording(browser, context, page, outputDir, 'math-editor-trig-sub-demo');
})();
