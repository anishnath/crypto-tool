/**
 * record-math-editor-cheatsheet.js — Fast feature cheat sheet (~60-90s)
 *
 * Speed control: DEMO_SPEED=1.5 for faster, DEMO_SPEED=2 for 2x speed
 *
 * Usage:
 *   DEMO_URL=http://localhost:8080/mywebapp2_war_exploded node record-math-editor-cheatsheet.js
 *   DEMO_URL=http://localhost:8080/mywebapp2_war_exploded DEMO_SPEED=1.5 node record-math-editor-cheatsheet.js
 */
const H = require('./helpers');

(async () => {
    console.log('Recording: Math Editor Cheat Sheet...');
    const { browser, context, page, outputDir } = await H.launchRecorder('math-editor-cheatsheet');

    try {
        console.log('[1] Setup...');
        await H.openEditor(page);
        await H.pause(page);
        await H.clearEditor(page);

        // Title
        await page.click('.me-doc-title-input');
        await page.waitForTimeout(150);
        await page.keyboard.press('Meta+a');
        await page.keyboard.type('Math Editor Cheat Sheet', { delay: 25 });
        await page.keyboard.press('Enter');
        await H.focusEditor(page);

        // ── ALGEBRA ─────────────────────────────────────────
        console.log('[2] Algebra...');
        await H.typeText(page, 'Algebra', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');

        await H.pressEnter(page);
        await H.insertMathBlock(page, 'x^2+2x+1', { setValue: true });
        await H.beat(page);
        await doAction(page, 'factor', 'inline');

        await H.pressEnter(page);
        await H.insertMathBlock(page, 'x^3-6x^2+11x-6', { setValue: true });
        await H.beat(page);
        await doAction(page, 'factor', 'inline');

        await H.pressEnter(page);
        await H.insertMathBlock(page, 'x^2-5x+6=0', { setValue: true });
        await H.beat(page);
        await doAction(page, 'solve', 'inline');

        // ── CALCULUS ────────────────────────────────────────
        console.log('[3] Calculus...');
        await H.pressEnter(page, 2);
        await H.typeText(page, 'Calculus', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');

        // Derivative
        await H.pressEnter(page);
        await H.insertMathBlock(page, 'x^3 \\sin(x)', { setValue: true });
        await H.beat(page);
        await doAction(page, 'derivative', 'below');

        // Integral
        await H.pressEnter(page);
        await H.insertMathBlock(page, '\\int x^2+3x\\,dx', { setValue: true });
        await H.beat(page);
        await doAction(page, 'evaluate', 'below');

        await H.smoothScroll(page, 250);

        // King's Property
        await H.pressEnter(page);
        await H.typeText(page, "King's Property:", { fast: true });
        await H.pressEnter(page);
        await H.insertMathBlock(page,
            '\\int_0^{\\frac{\\pi}{2}} \\frac{\\sin^3(x)}{\\cos^3(x)+\\sin^3(x)}\\,dx',
            { setValue: true });
        await H.pause(page);
        await doAction(page, 'evaluate', 'inline');

        await H.smoothScroll(page, 300);

        // ── ODE ─────────────────────────────────────────────
        console.log('[4] ODE...');
        await H.pressEnter(page, 2);
        await H.typeText(page, 'ODE Solver', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');

        await H.pressEnter(page);
        await H.insertMathBlock(page, "y''+3y'+2y=0", { setValue: true });
        await H.pause(page);

        // Click Solve ODE
        const odeBlocks = await page.$$('.me-math-display');
        if (odeBlocks.length > 0) {
            await odeBlocks[odeBlocks.length - 1].click();
            await page.waitForTimeout(600);
        }
        try {
            const odeBtn = await page.waitForSelector('.me-compute-btn[data-action="solveODE"]', { timeout: 2000 });
            if (odeBtn) {
                await odeBtn.click();
                await H.extraPause(page);
                await H.extraPause(page);
                await dismissPopover(page, 'below');
            }
        } catch (_) { await H.exitMathField(page); }

        await H.smoothScroll(page, 300);

        // ── MATRICES ────────────────────────────────────────
        console.log('[5] Matrices...');
        await H.pressEnter(page, 2);
        await H.typeText(page, 'Matrices', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');

        // Det
        await H.pressEnter(page);
        await H.insertMathBlock(page,
            '\\begin{pmatrix} 2 & 3 \\\\ 1 & 4 \\end{pmatrix}',
            { setValue: true });
        await H.beat(page);
        await doConditionalAction(page, 'matDet', 'inline');

        // Multiply
        await H.pressEnter(page);
        await H.insertMathBlock(page,
            '\\begin{pmatrix} 1 & 2 \\\\ 3 & 4 \\end{pmatrix} \\cdot \\begin{pmatrix} 5 & 6 \\\\ 7 & 8 \\end{pmatrix}',
            { setValue: true });
        await H.beat(page);
        await doAction(page, 'evaluate', 'below');

        await H.smoothScroll(page, 300);

        // ── TRIG / LOG ──────────────────────────────────────
        console.log('[6] Trig...');
        await H.pressEnter(page, 2);
        await H.typeText(page, 'Trig & Log', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');

        await H.pressEnter(page);
        await H.insertMathBlock(page, '\\sin^2(x)+\\cos^2(x)', { setValue: true });
        await H.beat(page);
        await doAction(page, 'simplify', 'inline');

        await H.pressEnter(page);
        await H.insertMathBlock(page, '\\ln(e^3)', { setValue: true });
        await H.beat(page);
        await doAction(page, 'evaluate', 'inline');

        // ── FUNCTION DEF ────────────────────────────────────
        console.log('[7] f(x)=...');
        await H.pressEnter(page, 2);
        await H.typeText(page, 'Function Definition', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');

        await H.pressEnter(page);
        await H.insertMathBlock(page, 'f\\left(x\\right)=x^2-4', { setValue: true });
        await H.beat(page);
        await doAction(page, 'factor', 'inline');

        await H.smoothScroll(page, 300);

        // ── GRAPH ───────────────────────────────────────────
        console.log('[8] Graph...');
        await H.pressEnter(page, 2);
        await H.typeText(page, 'Graphing', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');

        await H.pressEnter(page);
        await H.insertMathBlock(page, 'y=\\sin(x)', { setValue: true });
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

        // ── DELETE BLOCK ────────────────────────────────────
        console.log('[9] Delete...');
        await H.pressEnter(page, 2);
        await H.insertMathBlock(page, 'DELETE\\_ME', { setValue: true });
        await H.exitMathField(page);
        try {
            const allDisplays = await page.$$('.me-math-display');
            const last = allDisplays[allDisplays.length - 1];
            if (last) {
                await H.hoverElement(page, '.me-math-display:last-child');
                await H.pause(page);
                const del = await last.$('.me-math-delete-btn');
                if (del) { await del.click(); await H.beat(page); }
            }
        } catch (_) {}

        // ── FINAL SCROLL ────────────────────────────────────
        console.log('[10] Final...');
        await page.evaluate(() => {
            const w = document.querySelector('.me-canvas-wrapper');
            if (w) w.scrollTo({ top: 0, behavior: 'smooth' });
        });
        await H.longPause(page);
        for (let i = 0; i < 6; i++) {
            await H.smoothScroll(page, 400);
            await page.waitForTimeout(500);
        }
        await H.pause(page);

        console.log('Done!');
    } catch (err) {
        console.error('Recording error:', err.message);
        console.error(err.stack);
    }

    await H.finishRecording(browser, context, page, outputDir, 'math-editor-cheatsheet');
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
            await H.pause(page);
            await dismissPopover(page, popoverBtn);
        }
    } catch (_) {
        await H.exitMathField(page);
    }
}

async function dismissPopover(page, which) {
    try {
        await page.waitForSelector('.me-result-popover', { timeout: 2000 });
        await H.pause(page);
        if (which === 'inline') {
            await page.click('.me-result-popover-btn:first-child');
        } else if (which === 'below') {
            const btns = await page.$$('.me-result-popover-btn');
            if (btns.length >= 2) await btns[1].click();
            else await page.click('.me-result-popover-btn:first-child');
        } else if (which === 'copy') {
            const btns = await page.$$('.me-result-popover-btn');
            if (btns.length >= 3) await btns[2].click();
        }
        await H.beat(page);
    } catch (_) {}
    await H.exitMathField(page);
}
