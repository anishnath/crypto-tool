/**
 * helpers.js — Shared utilities for demo recording scripts
 *
 * Provides human-like typing, pauses, and common editor interactions
 * so the recorded videos look natural and easy to follow.
 */
const { chromium } = require('playwright');
const path = require('path');
const fs = require('fs');
const { execSync } = require('child_process');

// ── Config ──────────────────────────────────────────────────
const BASE_URL = (process.env.DEMO_URL || 'http://localhost:8080').replace(/\/$/, '');
const VIEWPORT = { width: 1920, height: 1080 };
const TYPE_DELAY = 55;          // ms per keystroke (human-like)
const FAST_TYPE_DELAY = 30;     // faster for LaTeX input
const SHORT_PAUSE = 600;        // brief beat
const MEDIUM_PAUSE = 1200;      // let viewer read
const LONG_PAUSE = 2000;        // dramatic pause / let animation finish
const EXTRA_PAUSE = 3000;       // wait for heavy computation / plot render

// ── Browser Launch ──────────────────────────────────────────
async function launchRecorder(videoName) {
    console.log('[launchRecorder] BASE_URL:', BASE_URL);
    const outputDir = path.join(__dirname, 'output');
    if (!fs.existsSync(outputDir)) fs.mkdirSync(outputDir, { recursive: true });

    const browser = await chromium.launch({
        headless: false,           // visible so we capture real rendering
        args: ['--disable-gpu-sandbox']
    });

    const context = await browser.newContext({
        viewport: VIEWPORT,
        recordVideo: {
            dir: outputDir,
            size: VIEWPORT
        },
        // Disable "do you want to leave" prompts
        ignoreHTTPSErrors: true
    });

    const page = await context.newPage();

    // Suppress dialogs
    page.on('dialog', async dialog => await dialog.dismiss());

    return { browser, context, page, outputDir };
}

// ── Teardown & Convert ──────────────────────────────────────
async function finishRecording(browser, context, page, outputDir, videoName) {
    await page.waitForTimeout(LONG_PAUSE);
    const videoPath = await page.video().path();
    await context.close();
    await browser.close();

    // Rename webm to something identifiable
    const webmOut = path.join(outputDir, `${videoName}.webm`);
    if (fs.existsSync(videoPath)) {
        fs.renameSync(videoPath, webmOut);
        console.log(`WebM saved: ${webmOut}`);
    }

    // Convert to MP4 if ffmpeg is available
    const mp4Out = path.join(outputDir, `${videoName}.mp4`);
    try {
        execSync(`ffmpeg -y -i "${webmOut}" -c:v libx264 -preset fast -crf 22 -pix_fmt yuv420p "${mp4Out}"`, { stdio: 'pipe' });
        console.log(`MP4 saved: ${mp4Out}`);
    } catch (e) {
        console.log('ffmpeg not found or failed — .webm file is ready for manual conversion');
        console.log(`  ffmpeg -i "${webmOut}" -c:v libx264 -preset fast -crf 22 -pix_fmt yuv420p "${mp4Out}"`);
    }
}

// ── Navigation ──────────────────────────────────────────────
async function openEditor(page) {
    const url = `${BASE_URL}/math/editor.jsp`;
    console.log('[openEditor] Navigating to:', url);
    await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 30000 });
    console.log('[openEditor] Page loaded, waiting for .ProseMirror...');
    await page.waitForSelector('.ProseMirror', { timeout: 20000 });
    console.log('[openEditor] TipTap ready, waiting for MathLive to load...');
    await page.evaluate(async () => {
        await customElements.whenDefined('math-field');
    });
    await page.waitForTimeout(2000);
    console.log('[openEditor] Editor ready.');
}

// ── Typing Helpers ──────────────────────────────────────────

/** Type text with human-like delay into the focused ProseMirror editor */
async function typeText(page, text, options = {}) {
    const delay = options.fast ? FAST_TYPE_DELAY : TYPE_DELAY;
    await page.keyboard.type(text, { delay });
}

/** Type LaTeX into a math-field (MathLive). Assumes a math-field is focused. */
async function typeLatex(page, latex) {
    // MathLive's math-field accepts keyboard input directly
    // We type character by character for visual effect
    for (const char of latex) {
        await page.keyboard.type(char, { delay: FAST_TYPE_DELAY });
        await page.waitForTimeout(10); // tiny gap for MathLive to render
    }
}

/** Set the last math-field's value directly via MathLive API.
 *  Looks cleaner in demos — the rendered equation appears instantly
 *  instead of showing raw LaTeX backslash commands being typed. */
async function setMathValue(page, latex) {
    await page.evaluate((val) => {
        const fields = document.querySelectorAll('math-field.me-mathfield-live');
        const mf = fields[fields.length - 1];
        if (mf) {
            mf.setValue(val);
            mf.dispatchEvent(new Event('input', { bubbles: true }));
        }
    }, latex);
    await page.waitForTimeout(MEDIUM_PAUSE);
}

/** Press Enter to create new paragraph in TipTap */
async function pressEnter(page, count = 1) {
    for (let i = 0; i < count; i++) {
        await page.keyboard.press('Enter');
        await page.waitForTimeout(150);
    }
}

// ── Editor Interactions ─────────────────────────────────────

/** Click a toolbar button by its title attribute (partial match to allow shortcut suffixes) */
async function clickToolbarBtn(page, title) {
    const selector = `.me-toolbar-btn[title*="${title}"], .me-toolbar-btn-math[title*="${title}"]`;
    await page.waitForSelector(selector, { timeout: 5000 });
    await page.click(selector);
    await page.waitForTimeout(SHORT_PAUSE);
}

/** Click a compute action button (evaluate, simplify, solve, etc.) */
async function clickComputeAction(page, action) {
    const selector = `.me-compute-btn[data-action="${action}"]`;
    await page.waitForSelector(selector, { timeout: 8000 });
    await page.click(selector);
    await page.waitForTimeout(LONG_PAUSE); // wait for computation
}

/** Select all content in the editor and delete it */
async function clearEditor(page) {
    await page.click('.ProseMirror', { timeout: 5000 });
    await page.waitForTimeout(300);
    await page.keyboard.press('Meta+a');
    await page.waitForTimeout(200);
    await page.keyboard.press('Backspace');
    await page.waitForTimeout(SHORT_PAUSE);
}

/** Focus the editor canvas */
async function focusEditor(page) {
    await page.click('.ProseMirror');
    await page.waitForTimeout(300);
}

/** Click on a specific math-field (by index, 0-based; -1 = last) */
async function clickMathField(page, index = 0) {
    const fields = await page.$$('math-field.me-mathfield-live');
    const idx = index < 0 ? fields.length + index : index;
    if (fields[idx]) {
        await fields[idx].click();
        await page.waitForTimeout(SHORT_PAUSE);
    }
}

/** Insert a math block via toolbar and type LaTeX.
 *  Pass { setValue: true } to set the LaTeX programmatically instead of
 *  typing it character-by-character — looks cleaner for complex LaTeX
 *  with backslash commands (\sin, \int, etc.) that confuse viewers. */
async function insertMathBlock(page, latex, options = {}) {
    await clickToolbarBtn(page, 'Insert Display Math');
    await page.waitForTimeout(800);
    if (options.setValue) {
        await setMathValue(page, latex);
    } else {
        await typeLatex(page, latex);
        await page.waitForTimeout(MEDIUM_PAUSE);
    }
}

/** Insert inline math via toolbar and type LaTeX.
 *  Pass { setValue: true } to set programmatically for complex LaTeX. */
async function insertInlineMath(page, latex, options = {}) {
    await clickToolbarBtn(page, 'Insert Inline Math');
    await page.waitForTimeout(800);
    if (options.setValue) {
        await setMathValue(page, latex);
    } else {
        await typeLatex(page, latex);
        await page.waitForTimeout(MEDIUM_PAUSE);
    }
}

/** Exit math-field back to TipTap text (press Escape or Enter) */
async function exitMathField(page) {
    await page.keyboard.press('Escape');
    await page.waitForTimeout(400);
}

/** Trigger slash menu by pressing / at start of empty line */
async function openSlashMenu(page) {
    await page.keyboard.press('/');
    await page.waitForTimeout(SHORT_PAUSE);
}

/** Select slash menu item by visible text */
async function selectSlashItem(page, label) {
    await page.click(`.me-slash-item:has-text("${label}")`);
    await page.waitForTimeout(SHORT_PAUSE);
}

/** Scroll the editor smoothly to show content */
async function smoothScroll(page, amount = 300) {
    await page.evaluate((px) => {
        const wrapper = document.querySelector('.me-canvas-wrapper');
        if (wrapper) wrapper.scrollBy({ top: px, behavior: 'smooth' });
    }, amount);
    await page.waitForTimeout(800);
}

/** Move mouse to element (for visual hover effect in recording) */
async function hoverElement(page, selector) {
    const el = await page.$(selector);
    if (el) {
        const box = await el.boundingBox();
        if (box) {
            await page.mouse.move(box.x + box.width / 2, box.y + box.height / 2, { steps: 15 });
            await page.waitForTimeout(SHORT_PAUSE);
        }
    }
}

/** Right-click on the last math-field to open context menu */
async function rightClickLastMathField(page) {
    const fields = await page.$$('math-field.me-mathfield-live');
    if (fields.length > 0) {
        const last = fields[fields.length - 1];
        await last.click({ button: 'right' });
        await page.waitForTimeout(MEDIUM_PAUSE);
    }
}

/** Move cursor to end of document via TipTap commands */
async function moveCursorToEnd(page) {
    await page.evaluate(() => {
        const editor = window.MeEditor;
        if (editor) {
            editor.commands.focus('end');
        }
    });
    await page.waitForTimeout(300);
}

/** Exit a list (numbered/bullet) by lifting the list item via TipTap */
async function exitList(page) {
    // Press Enter on an empty list item to exit, then ensure cursor is at end
    await page.keyboard.press('Enter');
    await page.waitForTimeout(150);
    await page.keyboard.press('Enter');
    await page.waitForTimeout(150);
    // Use TipTap API to ensure we're out of any list and at the document end
    await page.evaluate(() => {
        const editor = window.MeEditor;
        if (editor) {
            // Lift out of any list context
            try { editor.commands.liftListItem('listItem'); } catch (_) {}
            editor.commands.focus('end');
        }
    });
    await page.waitForTimeout(400);
}

// ── Pauses (named for readability) ──────────────────────────
async function beat(page) { await page.waitForTimeout(SHORT_PAUSE); }
async function pause(page) { await page.waitForTimeout(MEDIUM_PAUSE); }
async function longPause(page) { await page.waitForTimeout(LONG_PAUSE); }
async function extraPause(page) { await page.waitForTimeout(EXTRA_PAUSE); }

module.exports = {
    BASE_URL, VIEWPORT, TYPE_DELAY, FAST_TYPE_DELAY,
    SHORT_PAUSE, MEDIUM_PAUSE, LONG_PAUSE, EXTRA_PAUSE,
    launchRecorder, finishRecording, openEditor,
    typeText, typeLatex, setMathValue, pressEnter,
    clickToolbarBtn, clickComputeAction,
    clearEditor, focusEditor, clickMathField,
    insertMathBlock, insertInlineMath, exitMathField,
    openSlashMenu, selectSlashItem,
    smoothScroll, hoverElement, rightClickLastMathField,
    moveCursorToEnd, exitList,
    beat, pause, longPause, extraPause
};
