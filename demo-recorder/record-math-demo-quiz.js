/**
 * record-math-demo-quiz.js — Math Quiz Demo (~75–90s)
 *
 * Builds a multiple-choice math test in the editor:
 *   1. Title + instructions
 *   2. Q1: Derivative (with choices A–D)
 *   3. Q2: Definite integral (with choices A–D)
 *   4. Q3: Simplify expression (with choices, then solve via right-click)
 *   5. Answer key reveal (evaluate / solve to verify)
 *
 * Showcases: headings, numbered lists, inline math, display math,
 *            bold formatting, right-click Evaluate, and plotting.
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
        await H.typeText(page, 'Calculus Quiz');
        await page.waitForTimeout(350);
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.pause(page);

        await H.pressEnter(page);
        await H.typeText(page, 'Choose the correct answer for each question.');
        await H.pause(page);

        // ─── Question 1: Derivative ─────────────────────────────
        console.log('[4] Question 1...');
        await H.pressEnter(page, 2);
        await H.typeText(page, 'Question 1');
        await H.clickToolbarBtn(page, 'Heading 2');
        await H.beat(page);

        await H.pressEnter(page);
        await H.typeText(page, 'Find the derivative of:');
        await H.beat(page);

        await H.pressEnter(page);
        await H.insertMathBlock(page, 'f(x) = x^3 - 6x^2 + 9x + 1', { setValue: true });
        await H.exitMathField(page);
        await H.pause(page);

        // Choices as a list
        await H.pressEnter(page);
        await H.clickToolbarBtn(page, 'Numbered List');
        await H.typeText(page, '3x^2 - 12x + 9', { fast: true });
        await H.pressEnter(page);
        await H.typeText(page, '3x^2 - 6x + 9', { fast: true });
        await H.pressEnter(page);
        await H.typeText(page, 'x^3 - 12x + 9', { fast: true });
        await H.pressEnter(page);
        await H.typeText(page, '3x^2 - 12x + 1', { fast: true });
        await H.pause(page);

        // Exit list
        await H.pressEnter(page, 2);

        // ─── Question 2: Definite Integral ──────────────────────
        console.log('[5] Question 2...');
        await H.typeText(page, 'Question 2');
        await H.clickToolbarBtn(page, 'Heading 2');
        await H.beat(page);

        await H.pressEnter(page);
        await H.typeText(page, 'Evaluate the definite integral:');
        await H.beat(page);

        await H.pressEnter(page);
        await H.insertMathBlock(page, '\\int_0^2 (3x^2 + 2x) \\, dx', { setValue: true });
        await H.exitMathField(page);
        await H.pause(page);

        await H.pressEnter(page);
        await H.clickToolbarBtn(page, 'Numbered List');
        await H.typeText(page, '10', { fast: true });
        await H.pressEnter(page);
        await H.typeText(page, '12', { fast: true });
        await H.pressEnter(page);
        await H.typeText(page, '14', { fast: true });
        await H.pressEnter(page);
        await H.typeText(page, '16', { fast: true });
        await H.pause(page);

        await H.smoothScroll(page, 300);
        await H.beat(page);

        // Exit list
        await H.pressEnter(page, 2);

        // ─── Question 3: Simplify ───────────────────────────────
        console.log('[6] Question 3...');
        await H.typeText(page, 'Question 3');
        await H.clickToolbarBtn(page, 'Heading 2');
        await H.beat(page);

        await H.pressEnter(page);
        await H.typeText(page, 'Simplify:');
        await H.beat(page);

        await H.pressEnter(page);
        await H.insertMathBlock(page, '\\frac{x^2 - 9}{x + 3}', { setValue: true });
        await H.exitMathField(page);
        await H.pause(page);

        await H.pressEnter(page);
        await H.clickToolbarBtn(page, 'Numbered List');
        await H.typeText(page, 'x - 3', { fast: true });
        await H.pressEnter(page);
        await H.typeText(page, 'x + 3', { fast: true });
        await H.pressEnter(page);
        await H.typeText(page, 'x^2 - 3', { fast: true });
        await H.pressEnter(page);
        await H.typeText(page, '(x - 3)(x + 3)', { fast: true });
        await H.pause(page);

        await H.smoothScroll(page, 300);
        await H.beat(page);

        // Exit list
        await H.pressEnter(page, 2);

        // ─── Answer Key: Verify with right-click ────────────────
        console.log('[7] Answer key — verify Q1 with right-click derivative...');
        await H.typeText(page, 'Answer Key');
        await H.clickToolbarBtn(page, 'Heading 2');
        await H.beat(page);

        await H.pressEnter(page);
        await H.typeText(page, 'Q1: Right-click the equation to verify:');
        await H.beat(page);

        await H.pressEnter(page);
        await H.insertMathBlock(page, 'x^3 - 6x^2 + 9x + 1', { setValue: true });
        await H.longPause(page);

        // Right-click → Derivative to show answer is 3x^2 - 12x + 9
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

        await H.smoothScroll(page, 300);
        await H.beat(page);

        // Verify Q2 with right-click evaluate
        console.log('[8] Verify Q2 with evaluate...');
        await H.pressEnter(page);
        await H.typeText(page, 'Q2: Evaluate the integral:');
        await H.beat(page);

        await H.pressEnter(page);
        await H.insertMathBlock(page, '\\int_0^2 (3x^2 + 2x) \\, dx', { setValue: true });
        await H.longPause(page);

        await H.rightClickLastMathField(page);
        await H.longPause(page);
        try {
            await page.waitForSelector('text=Evaluate', { timeout: 3000 });
            await page.click('text=Evaluate');
            await H.extraPause(page);
        } catch (e) {
            await page.keyboard.press('Escape');
            await H.beat(page);
        }
        await H.exitMathField(page);

        await H.smoothScroll(page, 300);
        await H.beat(page);

        // Verify Q3 with right-click simplify
        console.log('[9] Verify Q3 with simplify...');
        await H.pressEnter(page);
        await H.typeText(page, 'Q3: Simplify the expression:');
        await H.beat(page);

        await H.pressEnter(page);
        await H.insertMathBlock(page, '\\frac{x^2 - 9}{x + 3}', { setValue: true });
        await H.longPause(page);

        await H.rightClickLastMathField(page);
        await H.longPause(page);
        try {
            await page.waitForSelector('text=Simplify', { timeout: 3000 });
            await page.click('text=Simplify');
            await H.extraPause(page);
        } catch (e) {
            await page.keyboard.press('Escape');
            await H.beat(page);
        }
        await H.exitMathField(page);

        await H.longPause(page);

        // ─── Wrap-up: scroll to top ─────────────────────────────
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
