/**
 * record-math-editor-full-showcase.js — Full Math Editor Showcase
 *
 * Each equation: $$ display math → set LaTeX → click action bar button → Append inline.
 * Uses action bar (click math block → buttons appear) — reliable in automation.
 *
 * Usage:
 *   DEMO_URL=http://localhost:8080/mywebapp2_war_exploded node record-math-editor-full-showcase.js
 */
const H = require('./helpers');

(async () => {
    console.log('Recording: Full Math Editor Showcase...');
    const { browser, context, page, outputDir } = await H.launchRecorder(
        'math-editor-full-showcase', { width: 1280, height: 800 });

    try {
        console.log('[1] Setup...');
        await H.openEditor(page);
        await H.pause(page);
        await H.clearEditor(page);

        await page.click('.me-doc-title-input');
        await page.waitForTimeout(150);
        await page.keyboard.press('Meta+a');
        await page.keyboard.type('Math Editor — Showcase', { delay: 25 });
        await page.keyboard.press('Enter');
        await H.focusEditor(page);

        // ══════════════════════════════════════════════════
        //  CALCULUS
        // ══════════════════════════════════════════════════
        console.log('[2] Calculus...');
        await heading(page, 'Calculus');

        await mathAction(page, 'x^3\\sin(x)', 'derivative');
        await mathAction(page, '\\int \\frac{1}{x^2-1}\\,dx', 'evaluate');
        await mathAction(page, '\\int x^2+3x\\,dx', 'evaluate');
        await mathAction(page, '\\int_0^1 3x^2\\,dx', 'evaluate');
        await mathAction(page,
            '\\int_0^{\\frac{\\pi}{2}} \\frac{\\sin^3(x)}{\\cos^3(x)+\\sin^3(x)}\\,dx',
            'evaluate');

        await H.smoothScroll(page, 400);

        // ══════════════════════════════════════════════════
        //  DIFFERENTIAL EQUATIONS
        // ══════════════════════════════════════════════════
        console.log('[3] ODEs...');
        await heading(page, 'Differential Equations');

        await mathConditional(page, "y'+2y=e^x", 'solveODE');
        await mathConditional(page, "y''+\\omega^2 y=0", 'solveODE');

        await H.smoothScroll(page, 400);

        // ══════════════════════════════════════════════════
        //  LIMITS
        // ══════════════════════════════════════════════════
        console.log('[4] Limits...');
        await heading(page, 'Limits');

        await mathConditional(page, '\\lim_{x \\to 0} \\frac{\\sin x}{x}', 'limit');
        await mathConditional(page,
            '\\lim_{x \\to \\infty} \\left(1+\\frac{1}{x}\\right)^x', 'limit');

        await H.smoothScroll(page, 300);

        // ══════════════════════════════════════════════════
        //  SERIES
        // ══════════════════════════════════════════════════
        console.log('[5] Series...');
        await heading(page, 'Series');

        await mathConditional(page, '\\sum_{k=1}^{10} k^2', 'taylor');
        await mathConditional(page, '\\sum_{n=1}^{\\infty} \\frac{1}{n^2}', 'taylor');

        await H.smoothScroll(page, 300);

        // ══════════════════════════════════════════════════
        //  LAPLACE TRANSFORM
        // ══════════════════════════════════════════════════
        console.log('[6] Laplace...');
        await heading(page, 'Laplace Transform');

        await mathConditional(page, '\\mathcal{L}\\{\\sin(t)\\}', 'laplace');

        await H.smoothScroll(page, 300);

        // ══════════════════════════════════════════════════
        //  SYSTEMS + PLOT
        // ══════════════════════════════════════════════════
        console.log('[7] Systems...');
        await heading(page, 'Systems of Equations');

        await mathConditional(page,
            '\\begin{cases} x+y=3 \\\\ 2x-y=0 \\end{cases}', 'solveSys');

        // Plot
        await H.pressEnter(page);
        await H.insertMathBlock(page,
            '\\begin{cases} x^2+y=5 \\\\ 4x-y=2 \\end{cases}',
            { setValue: true });
        await H.pause(page);
        // Use action bar Plot button
        await clickLastMf(page);
        try {
            await H.clickComputeAction(page, 'plot');
            await H.extraPause(page);
            await H.extraPause(page);
        } catch (_) {}
        await H.exitMathField(page);
        await H.smoothScroll(page, 500);

        // ══════════════════════════════════════════════════
        //  MATRICES
        // ══════════════════════════════════════════════════
        console.log('[8] Matrices...');
        await heading(page, 'Matrices');

        await mathConditional(page,
            '\\begin{pmatrix} 2 & 3 \\\\ 1 & 4 \\end{pmatrix}', 'matDet');

        await mathAction(page,
            '\\begin{pmatrix} 1 & 2 \\\\ 3 & 4 \\end{pmatrix} \\cdot \\begin{pmatrix} 5 & 6 \\\\ 7 & 8 \\end{pmatrix}',
            'evaluate');

        await H.smoothScroll(page, 400);

        // ══════════════════════════════════════════════════
        //  GRAPHING
        // ══════════════════════════════════════════════════
        console.log('[9] Graphing...');
        await heading(page, 'Graphing');

        await H.pressEnter(page);
        await H.insertMathBlock(page, 'y=x^3-3x', { setValue: true });
        await H.beat(page);
        await clickLastMf(page);
        try {
            await H.clickComputeAction(page, 'plot');
            await H.extraPause(page);
            await H.extraPause(page);
        } catch (_) {}
        await H.exitMathField(page);
        await H.smoothScroll(page, 500);

        // ══════════════════════════════════════════════════
        //  FUNCTION DEFINITIONS
        // ══════════════════════════════════════════════════
        console.log('[10] Function defs...');
        await heading(page, 'Function Definitions');

        await mathAction(page, 'f\\left(x\\right)=x^2-4', 'factor');
        await mathAction(page, 'f\\left(x\\right)=\\sin(x)\\cdot e^x', 'derivative');

        await H.smoothScroll(page, 300);

        // ══════════════════════════════════════════════════
        //  EXPORT
        // ══════════════════════════════════════════════════
        console.log('[11] Export...');
        try {
            const exportBtn = await page.$('.me-btn-export');
            if (exportBtn) {
                await exportBtn.click();
                await H.pause(page);
                const latexItem = await page.waitForSelector(
                    '.me-export-menu-item[data-export="latex"]', { timeout: 2000 });
                if (latexItem) {
                    await latexItem.click();
                    await H.longPause(page);
                }
            }
        } catch (_) {}

        // ══════════════════════════════════════════════════
        //  FINAL SCROLL
        // ══════════════════════════════════════════════════
        console.log('[12] Final scroll...');
        await page.evaluate(() => {
            const w = document.querySelector('.me-canvas-wrapper');
            if (w) w.scrollTo({ top: 0, behavior: 'smooth' });
        });
        await H.longPause(page);
        for (let i = 0; i < 8; i++) {
            await H.smoothScroll(page, 350);
            await page.waitForTimeout(400);
        }
        await H.pause(page);

        console.log('Done!');
    } catch (err) {
        console.error('Recording error:', err.message);
        console.error(err.stack);
    }

    await H.finishRecording(browser, context, page, outputDir, 'math-editor-full-showcase');
})();

// ── Helpers ──────────────────────────────────────────────────

async function heading(page, text) {
    await H.pressEnter(page, 2);
    await H.typeText(page, text, { fast: true });
    await H.clickToolbarBtn(page, 'Heading 1');
    await H.beat(page);
}

/** Click last math-field to trigger action bar */
async function clickLastMf(page) {
    const blocks = await page.$$('.me-math-display');
    if (blocks.length > 0) {
        await blocks[blocks.length - 1].click();
        await page.waitForTimeout(800);
    }
}

/**
 * Insert math block → click standard action bar button → Append inline.
 * For: evaluate, simplify, factor, expand, derivative, integrate
 */
async function mathAction(page, latex, action) {
    await H.pressEnter(page);
    await H.insertMathBlock(page, latex, { setValue: true });
    await H.beat(page);
    await clickLastMf(page);
    try {
        await H.clickComputeAction(page, action);
        await H.pause(page);
        await appendInline(page);
    } catch (e) {
        console.log('  Action "' + action + '" failed: ' + e.message.substring(0, 40));
        await H.exitMathField(page);
    }
}

/**
 * Insert math block → click CONDITIONAL action bar button → Append inline.
 * For: solveODE, solvePDE, limit, taylor, laplace, solveSys, matDet, etc.
 * These buttons only appear when the expression type is detected.
 */
async function mathConditional(page, latex, action) {
    await H.pressEnter(page);
    await H.insertMathBlock(page, latex, { setValue: true });
    await H.pause(page);

    // Click the math-field directly to ensure selectNode fires
    const mfs = await page.$$('math-field.me-mathfield-live');
    if (mfs.length > 0) {
        await mfs[mfs.length - 1].click();
        await page.waitForTimeout(1500);
    }

    try {
        const btn = await page.waitForSelector(
            `.me-compute-btn[data-action="${action}"]:not([style*="display: none"])`,
            { timeout: 5000 });
        if (btn) {
            await btn.click();
            // SymPy actions need more time
            if (['solveODE', 'solvePDE', 'laplace', 'limit', 'taylor', 'solveSys', 'matEig', 'matRREF', 'matRank'].includes(action)) {
                await H.extraPause(page);
                await H.extraPause(page);
            } else {
                await H.extraPause(page);
            }
            await appendInline(page);
        }
    } catch (e) {
        console.log('  Conditional "' + action + '" not found');
        // Fallback: try standard evaluate
        try {
            await H.clickComputeAction(page, 'evaluate');
            await H.pause(page);
            await appendInline(page);
        } catch (_) {
            await H.exitMathField(page);
        }
    }
}

/** Click "Append inline" in popover (always first button) */
async function appendInline(page) {
    try {
        await page.waitForSelector('.me-result-popover', { timeout: 5000 });
        await H.pause(page);
        await page.click('.me-result-popover-btn:first-child');
        await H.beat(page);
    } catch (_) {}
    await H.exitMathField(page);
}
