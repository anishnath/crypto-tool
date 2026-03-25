/**
 * record-math-editor-calculus-reddit.js — Calculus-focused demo for r/calculus
 *
 * Pure calculus workflow — no algebra/matrices/trig filler:
 *   1. Derivative (product rule, chain rule)
 *   2. Integral (indefinite + definite)
 *   3. King's Property (the wow moment)
 *   4. ODE solve
 *   5. Plot
 *
 * Usage:
 *   DEMO_URL=http://localhost:8080/mywebapp2_war_exploded node record-math-editor-calculus-reddit.js
 *   DEMO_URL=http://localhost:8080/mywebapp2_war_exploded DEMO_SPEED=1.5 node record-math-editor-calculus-reddit.js
 */
const H = require('./helpers');

(async () => {
    console.log('Recording: Calculus Demo for Reddit...');
    const { browser, context, page, outputDir } = await H.launchRecorder('math-editor-calculus-reddit');

    try {
        console.log('[1] Setup...');
        await H.openEditor(page);
        await H.pause(page);
        await H.clearEditor(page);

        await page.click('.me-doc-title-input');
        await page.waitForTimeout(150);
        await page.keyboard.press('Meta+a');
        await page.keyboard.type('Calculus — Solve In Context', { delay: 25 });
        await page.keyboard.press('Enter');
        await H.focusEditor(page);

        // ── DERIVATIVES ─────────────────────────────────────
        console.log('[2] Derivatives...');
        await H.typeText(page, 'Derivatives', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');

        // Product rule: x²·sin(x)
        await H.pressEnter(page);
        await H.typeText(page, 'Product rule:');
        await H.pressEnter(page);
        await H.insertMathBlock(page, 'f\\left(x\\right)=x^2\\sin(x)', { setValue: true });
        await H.beat(page);
        await doAction(page, 'derivative', 'below');

        // Chain rule: e^(sin(x))
        await H.pressEnter(page);
        await H.typeText(page, 'Chain rule:');
        await H.pressEnter(page);
        await H.insertMathBlock(page, 'f\\left(x\\right)=e^{\\sin(x)}', { setValue: true });
        await H.beat(page);
        await doAction(page, 'derivative', 'below');

        await H.smoothScroll(page, 250);

        // ── INTEGRALS ───────────────────────────────────────
        console.log('[3] Integrals...');
        await H.pressEnter(page, 2);
        await H.typeText(page, 'Integrals', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');

        // Indefinite
        await H.pressEnter(page);
        await H.typeText(page, 'Indefinite:');
        await H.pressEnter(page);
        await H.insertMathBlock(page, '\\int x^2 \\cos(x)\\,dx', { setValue: true });
        await H.beat(page);
        await doAction(page, 'evaluate', 'below');

        await H.smoothScroll(page, 200);

        // Definite
        await H.pressEnter(page);
        await H.typeText(page, 'Definite:');
        await H.pressEnter(page);
        await H.insertMathBlock(page, '\\int_0^{\\pi} \\sin(x)\\,dx', { setValue: true });
        await H.beat(page);
        await doAction(page, 'evaluate', 'inline');

        await H.smoothScroll(page, 200);

        // ── KING'S PROPERTY ─────────────────────────────────
        console.log('[4] King\'s Property...');
        await H.pressEnter(page, 2);
        await H.typeText(page, "King's Property", { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');

        await H.pressEnter(page);
        await H.typeText(page, 'This integral stumps SymPy and Wolfram Alpha for symbolic m.');
        await H.pressEnter(page);
        await H.typeText(page, 'We solve it instantly via symmetry:');

        // sin^3 / (cos^3 + sin^3) on [0, π/2]
        await H.pressEnter(page);
        await H.insertMathBlock(page,
            '\\int_0^{\\frac{\\pi}{2}} \\frac{\\sin^3(x)}{\\cos^3(x)+\\sin^3(x)}\\,dx',
            { setValue: true });
        await H.longPause(page);
        await doAction(page, 'evaluate', 'inline');

        await H.smoothScroll(page, 200);

        // Now symbolic m
        await H.pressEnter(page);
        await H.typeText(page, 'Works for any m:');
        await H.pressEnter(page);
        await H.insertMathBlock(page,
            '\\int_0^{\\frac{\\pi}{2}} \\frac{\\sin^m(x)}{\\cos^m(x)+\\sin^m(x)}\\,dx',
            { setValue: true });
        await H.longPause(page);
        await doAction(page, 'evaluate', 'inline');

        await H.smoothScroll(page, 200);

        // sqrt variant
        await H.pressEnter(page);
        await H.typeText(page, 'Even with square roots:');
        await H.pressEnter(page);
        await H.insertMathBlock(page,
            '\\int_0^{\\frac{\\pi}{2}} \\frac{\\sqrt{\\sin(x)}}{\\sqrt{\\cos(x)}+\\sqrt{\\sin(x)}}\\,dx',
            { setValue: true });
        await H.pause(page);
        await doAction(page, 'evaluate', 'inline');

        await H.smoothScroll(page, 300);

        // ── ODE ─────────────────────────────────────────────
        console.log('[5] ODE...');
        await H.pressEnter(page, 2);
        await H.typeText(page, 'Differential Equations', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');

        // First order
        await H.pressEnter(page);
        await H.typeText(page, 'First order:');
        await H.pressEnter(page);
        await H.insertMathBlock(page, "y'+2y=e^x", { setValue: true });
        await H.pause(page);
        await doConditionalAction(page, 'solveODE', 'below');

        await H.smoothScroll(page, 250);

        // Second order (SHM)
        await H.pressEnter(page);
        await H.typeText(page, 'Simple harmonic motion:');
        await H.pressEnter(page);
        await H.insertMathBlock(page, "y''+\\omega^2 y=0", { setValue: true });
        await H.pause(page);
        await doConditionalAction(page, 'solveODE', 'below');

        await H.smoothScroll(page, 300);

        // ── PLOT ────────────────────────────────────────────
        console.log('[6] Plot...');
        await H.pressEnter(page, 2);
        await H.typeText(page, 'Graph It', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');

        await H.pressEnter(page);
        await H.insertMathBlock(page, 'y=x^3-3x', { setValue: true });
        await H.beat(page);

        const plotBlocks = await page.$$('.me-math-display');
        if (plotBlocks.length > 0) {
            await plotBlocks[plotBlocks.length - 1].click();
            await page.waitForTimeout(600);
        }
        try {
            await H.clickComputeAction(page, 'plot');
            await H.extraPause(page);
        } catch (_) {}
        await H.exitMathField(page);
        await H.smoothScroll(page, 400);
        await H.pause(page);

        // ── FINAL SCROLL ────────────────────────────────────
        console.log('[7] Final scroll...');
        await page.evaluate(() => {
            const w = document.querySelector('.me-canvas-wrapper');
            if (w) w.scrollTo({ top: 0, behavior: 'smooth' });
        });
        await H.longPause(page);
        for (let i = 0; i < 7; i++) {
            await H.smoothScroll(page, 400);
            await page.waitForTimeout(400);
        }
        await H.pause(page);

        console.log('Done!');
    } catch (err) {
        console.error('Recording error:', err.message);
        console.error(err.stack);
    }

    await H.finishRecording(browser, context, page, outputDir, 'math-editor-calculus-reddit');
})();

// ── Helpers ──────────────────────────────────────────────────

async function doAction(page, action, popoverBtn) {
    const blocks = await page.$$('.me-math-display');
    if (blocks.length > 0) {
        await blocks[blocks.length - 1].click();
        await page.waitForTimeout(600);
    }
    try {
        await H.clickComputeAction(page, action);
        await H.pause(page);
        await dismissPopover(page, popoverBtn);
    } catch (_) {
        await H.exitMathField(page);
    }
}

async function doConditionalAction(page, action, popoverBtn) {
    const blocks = await page.$$('.me-math-display');
    if (blocks.length > 0) {
        await blocks[blocks.length - 1].click();
        await page.waitForTimeout(600);
    }
    try {
        const btn = await page.waitForSelector('.me-compute-btn[data-action="' + action + '"]', { timeout: 2000 });
        if (btn) {
            await btn.click();
            await H.extraPause(page);
            await H.extraPause(page);
            await dismissPopover(page, popoverBtn);
        }
    } catch (_) {
        await H.exitMathField(page);
    }
}

async function dismissPopover(page, which) {
    try {
        await page.waitForSelector('.me-result-popover', { timeout: 3000 });
        await H.pause(page);
        if (which === 'inline') {
            await page.click('.me-result-popover-btn:first-child');
        } else if (which === 'below') {
            const btns = await page.$$('.me-result-popover-btn');
            if (btns.length >= 2) await btns[1].click();
            else await page.click('.me-result-popover-btn:first-child');
        }
        await H.beat(page);
    } catch (_) {}
    await H.exitMathField(page);
}
