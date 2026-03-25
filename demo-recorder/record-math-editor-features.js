/**
 * record-math-editor-features.js — Objective Math Quiz (single page)
 *
 * Creates a clean single-page objective quiz with varied formula types:
 *   - Quadratic formula
 *   - Trigonometric identity
 *   - Definite integral
 *   - Matrix determinant
 *   - Limit
 *   - Series sum
 *
 * Usage:
 *   DEMO_URL=http://localhost:8080/mywebapp2_war_exploded node record-math-editor-features.js
 */
const H = require('./helpers');

(async () => {
    console.log('Recording: Objective Math Quiz...');
    const { browser, context, page, outputDir } = await H.launchRecorder('math-editor-features');

    try {
        console.log('[1] Opening editor...');
        await H.openEditor(page);
        await H.longPause(page);

        console.log('[2] Clearing...');
        await H.clearEditor(page);

        // Title
        await page.click('.me-doc-title-input');
        await page.waitForTimeout(200);
        await page.keyboard.press('Meta+a');
        await page.keyboard.type('Mathematics — Objective Quiz', { delay: 40 });
        await page.keyboard.press('Enter');
        await H.beat(page);
        await H.focusEditor(page);

        // ── Header ──────────────────────────────────────────────
        console.log('[3] Header...');
        await H.typeText(page, 'Mathematics Objective Quiz');
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.beat(page);

        await H.pressEnter(page);
        await H.typeText(page, 'Choose the correct answer for each question. Each question carries 1 mark.');
        await H.pause(page);

        // ── Q1: Quadratic Formula ───────────────────────────────
        console.log('[4] Q1 — Quadratic formula...');
        await H.pressEnter(page, 2);
        await H.typeText(page, 'Q1. The solutions of  ');
        await H.insertInlineMath(page, 'ax^2 + bx + c = 0', { setValue: true });
        await H.exitMathField(page);
        await H.typeText(page, '  are given by:');
        await H.beat(page);

        await H.pressEnter(page);
        await H.insertMathBlock(page, 'x = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a}', { setValue: true });
        await H.pause(page);
        await H.exitMathField(page);

        await H.pressEnter(page);
        await H.typeText(page, '(A) True     (B) False     (C) Only when a > 0     (D) Only when b² ≥ 4ac');
        await H.pause(page);

        // ── Q2: Trig Identity ────────────────────────────────────
        console.log('[5] Q2 — Trig identity...');
        await H.pressEnter(page, 2);
        await H.typeText(page, 'Q2. Which identity is correct?');
        await H.beat(page);

        await H.pressEnter(page);
        await H.typeText(page, '(A)  ');
        await H.insertInlineMath(page, '\\sin^2\\theta + \\cos^2\\theta = 1', { setValue: true });
        await H.exitMathField(page);
        await H.beat(page);

        await H.pressEnter(page);
        await H.typeText(page, '(B)  ');
        await H.insertInlineMath(page, '\\sin^2\\theta - \\cos^2\\theta = 1', { setValue: true });
        await H.exitMathField(page);

        await H.pressEnter(page);
        await H.typeText(page, '(C)  ');
        await H.insertInlineMath(page, '\\tan^2\\theta + 1 = \\csc^2\\theta', { setValue: true });
        await H.exitMathField(page);

        await H.pressEnter(page);
        await H.typeText(page, '(D)  ');
        await H.insertInlineMath(page, '1 + \\cot^2\\theta = \\sec^2\\theta', { setValue: true });
        await H.exitMathField(page);
        await H.pause(page);

        // ── Q3: Definite Integral ────────────────────────────────
        console.log('[6] Q3 — Definite integral...');
        await H.pressEnter(page, 2);
        await H.typeText(page, 'Q3. Evaluate:');
        await H.beat(page);

        await H.pressEnter(page);
        await H.insertMathBlock(page, '\\int_0^1 3x^2 \\, dx', { setValue: true });
        await H.pause(page);
        await H.exitMathField(page);

        await H.pressEnter(page);
        await H.typeText(page, '(A) 0     (B) 1     (C) 3     (D) 1/3');
        await H.pause(page);

        // ── Q4: Matrix Determinant ──────────────────────────────
        console.log('[7] Q4 — Matrix determinant...');
        await H.pressEnter(page, 2);
        await H.typeText(page, 'Q4. Find the determinant:');
        await H.beat(page);

        await H.pressEnter(page);
        await H.insertMathBlock(page,
            '\\begin{vmatrix} 2 & 3 \\\\ 1 & 4 \\end{vmatrix}',
            { setValue: true });
        await H.pause(page);
        await H.exitMathField(page);

        await H.pressEnter(page);
        await H.typeText(page, '(A) 5     (B) 8     (C) 11     (D) −1');
        await H.pause(page);

        await H.smoothScroll(page, 300);

        // ── Q5: Limit ────────────────────────────────────────────
        console.log('[8] Q5 — Limit...');
        await H.pressEnter(page, 2);
        await H.typeText(page, 'Q5. Evaluate the limit:');
        await H.beat(page);

        await H.pressEnter(page);
        await H.insertMathBlock(page,
            '\\lim_{x \\to 0} \\frac{\\sin x}{x}',
            { setValue: true });
        await H.pause(page);
        await H.exitMathField(page);

        await H.pressEnter(page);
        await H.typeText(page, '(A) 0     (B) 1     (C) ∞     (D) Does not exist');
        await H.pause(page);

        // ── Q6: Geometric Series ─────────────────────────────────
        console.log('[9] Q6 — Series...');
        await H.pressEnter(page, 2);
        await H.typeText(page, 'Q6. The sum of the infinite geometric series:');
        await H.beat(page);

        await H.pressEnter(page);
        await H.insertMathBlock(page,
            '\\sum_{n=0}^{\\infty} \\left(\\frac{1}{2}\\right)^n',
            { setValue: true });
        await H.pause(page);
        await H.exitMathField(page);

        await H.pressEnter(page);
        await H.typeText(page, '(A) 1     (B) 2     (C) ∞     (D) 1/2');
        await H.pause(page);

        await H.smoothScroll(page, 300);

        // ── Q7: Derivative ───────────────────────────────────────
        console.log('[10] Q7 — Derivative...');
        await H.pressEnter(page, 2);
        await H.typeText(page, 'Q7. Find  ');
        await H.insertInlineMath(page, '\\frac{d}{dx}', { setValue: true });
        await H.exitMathField(page);
        await H.typeText(page, '  of:');
        await H.beat(page);

        await H.pressEnter(page);
        await H.insertMathBlock(page, 'f(x) = e^x \\sin x', { setValue: true });
        await H.pause(page);
        await H.exitMathField(page);

        await H.pressEnter(page);
        await H.typeText(page, '(A)  ');
        await H.insertInlineMath(page, 'e^x(\\sin x + \\cos x)', { setValue: true });
        await H.exitMathField(page);
        await H.typeText(page, '     (B)  ');
        await H.insertInlineMath(page, 'e^x \\cos x', { setValue: true });
        await H.exitMathField(page);
        await H.typeText(page, '     (C)  ');
        await H.insertInlineMath(page, 'e^x(\\sin x - \\cos x)', { setValue: true });
        await H.exitMathField(page);
        await H.typeText(page, '     (D)  ');
        await H.insertInlineMath(page, 'e^x \\sin x', { setValue: true });
        await H.exitMathField(page);
        await H.pause(page);

        // ── Q8: Euler's Identity ─────────────────────────────────
        console.log('[11] Q8 — Euler identity...');
        await H.pressEnter(page, 2);
        await H.typeText(page, 'Q8. Euler\'s identity states:');
        await H.beat(page);

        await H.pressEnter(page);
        await H.insertMathBlock(page, 'e^{i\\pi} + 1 = 0', { setValue: true });
        await H.pause(page);
        await H.exitMathField(page);

        await H.pressEnter(page);
        await H.typeText(page, 'How many fundamental constants appear in this equation?');

        await H.pressEnter(page);
        await H.typeText(page, '(A) 3     (B) 4     (C) 5     (D) 6');
        await H.pause(page);

        await H.smoothScroll(page, 300);

        // ── Final: Scroll through the full quiz ──────────────────
        console.log('[12] Final scroll...');
        await H.longPause(page);

        await page.evaluate(() => {
            const w = document.querySelector('.me-canvas-wrapper');
            if (w) w.scrollTo({ top: 0, behavior: 'smooth' });
        });
        await H.extraPause(page);

        // Slow scroll through the full document
        for (let i = 0; i < 6; i++) {
            await H.smoothScroll(page, 350);
            await H.pause(page);
        }
        await H.longPause(page);

        console.log('Quiz recording complete!');
    } catch (err) {
        console.error('Recording error:', err.message);
        console.error(err.stack);
    }

    console.log('Finishing recording...');
    await H.finishRecording(browser, context, page, outputDir, 'math-editor-features');
})();
