/**
 * record-integral-calculator-demo.js — Integral Calculator demo
 *
 * Three high-level techniques (each: expression → Integrate → Show Steps):
 *   1) Integration by parts
 *   2) u-substitution
 *   3) Definite integral (evaluation at bounds)
 *
 * Usage (Tomcat must be running):
 *   DEMO_URL=http://localhost:8080/your-context node record-integral-calculator-demo.js
 *
 * Output: demo-recorder/output/integral-calculator-demo.webm (+ .mp4 if ffmpeg)
 *
 * Viewport: default matches helpers.js — width 1920, height 1080 (Playwright video size).
 * Override: DEMO_VIEWPORT=1280x720 npm run demo:integral
 */
const H = require('./helpers');

const INTEGRATE_TIMEOUT_MS = parseInt(process.env.INTEGRATE_TIMEOUT_MS || '120000', 10);

/** Default from helpers.js; override with DEMO_VIEWPORT=WxH (e.g. 1280x720). */
function getRecordingViewport() {
    var raw = (process.env.DEMO_VIEWPORT || '').trim();
    var m = raw.match(/^(\d+)\s*x\s*(\d+)$/i);
    if (m) {
        return { width: parseInt(m[1], 10), height: parseInt(m[2], 10) };
    }
    return H.VIEWPORT;
}

/** Scroll the steps UI into the visible viewport (window + element). Uses instant scroll so the recorder captures it. */
async function scrollStepsPanelIntoView(page) {
    await page.evaluate(function () {
        var area = document.getElementById('ic-steps-area');
        var inner = area && (area.querySelector('.ic-steps-container') || area.firstElementChild);
        var target = inner || area;
        if (!target) return;
        target.scrollIntoView({ block: 'center', inline: 'nearest', behavior: 'instant' });
        var r = target.getBoundingClientRect();
        var margin = 48;
        if (r.bottom > window.innerHeight - margin) {
            window.scrollBy(0, r.bottom - window.innerHeight + margin);
        }
        if (r.top < margin) {
            window.scrollBy(0, r.top - margin);
        }
    });
    await page.waitForTimeout(500);
}

async function openIntegralCalculator(page) {
    const url = `${H.BASE_URL}/integral-calculator.jsp`;
    console.log('[openIntegralCalculator]', url);
    await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 45000 });
    await page.waitForSelector('#ic-expr', { timeout: 20000 });
    await page.waitForSelector('#ic-integrate-btn', { timeout: 10000 });
    // Nerdamer / KaTeX
    await page.waitForTimeout(2000);
}

async function setMode(page, mode) {
    await page.click(`.ic-mode-btn[data-mode="${mode}"]`);
    await H.beat(page);
}

async function fillExpression(page, expr) {
    await page.click('#ic-expr');
    await page.keyboard.press(process.platform === 'darwin' ? 'Meta+a' : 'Control+a');
    await page.keyboard.press('Backspace');
    await page.fill('#ic-expr', expr);
    await H.beat(page);
}

async function setBounds(page, lower, upper) {
    await page.fill('#ic-lower', String(lower));
    await page.fill('#ic-upper', String(upper));
    await H.beat(page);
}

/** Close #ic-expr autocomplete so it does not intercept clicks on Integrate (Playwright hits .ic-autocomplete-item). */
async function dismissAutocomplete(page) {
    await page.focus('#ic-expr');
    await page.keyboard.press('Escape');
    await page.waitForTimeout(200);
    await page.evaluate(() => {
        const el = document.getElementById('ic-expr');
        if (el) el.blur();
    });
    await page.waitForTimeout(250);
    await page.waitForFunction(() => {
        const ac = document.getElementById('ic-autocomplete');
        return !ac || !ac.classList.contains('active');
    }, { timeout: 3000 }).catch(() => {});
}

/** Run one integral, wait for result bar, click Show Steps / Show Analysis, pause on steps panel. */
async function integrateAndShowSteps(page, sceneLabel) {
    await dismissAutocomplete(page);
    await page.click('#ic-integrate-btn', { force: true });
    console.log(`  [${sceneLabel}] Waiting for result…`);
    await page.waitForSelector('#ic-result-actions.visible', { timeout: INTEGRATE_TIMEOUT_MS });
    await page.waitForSelector('#ic-steps-btn', { state: 'visible', timeout: 5000 });
    await H.longPause(page);

    await page.evaluate(() => {
        const el = document.getElementById('ic-result-content');
        if (el) el.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    });
    await H.pause(page);

    const stepsBtn = await page.$('#ic-steps-btn');
    if (!stepsBtn) {
        console.warn(`  [${sceneLabel}] No steps button — skipping click`);
        return;
    }
    await stepsBtn.click({ force: true });
    console.log(`  [${sceneLabel}] Show Steps clicked`);

    // Steps are "ready" when: CAS panel exists, or button hidden after fetch, or loading cleared.
    // (App used to leave .loading on the button after success — fixed in integral-calculator.js.)
    try {
        await page.waitForFunction(() => {
            var area = document.getElementById('ic-steps-area');
            if (!area) return false;
            if (area.querySelector('.ic-steps-container')) return true;
            var btn = document.getElementById('ic-steps-btn');
            if (btn && !btn.classList.contains('loading')) return true;
            if (btn && getComputedStyle(btn).display === 'none' && area.innerHTML.length > 20) return true;
            if (area.textContent && area.textContent.trim().length > 15) return true;
            return false;
        }, { timeout: 25000 });
    } catch (e) {
        console.warn(`  [${sceneLabel}] Steps panel wait timed out — continuing (${e.message})`);
    }
    await scrollStepsPanelIntoView(page);
    await H.extraPause(page);
    await H.longPause(page);
}

(async () => {
    var vp = getRecordingViewport();
    console.log('Recording: Integral Calculator demo…');
    console.log('[viewport] Video size:', vp.width + '×' + vp.height, process.env.DEMO_VIEWPORT ? '(DEMO_VIEWPORT)' : '(default helpers.VIEWPORT)');
    const { browser, context, page, outputDir } = await H.launchRecorder('integral-calculator-demo', vp);

    /** High-level integration: by-parts, substitution, definite (two–three variations in one run). */
    const scenes = [
        {
            label: '1 — Integration by parts',
            mode: 'indefinite',
            expr: 'x*e^x'
        },
        {
            label: '2 — u-substitution',
            mode: 'indefinite',
            expr: 'x*e^(x^2)'
        },
        {
            label: '3 — Definite (evaluate at bounds)',
            mode: 'definite',
            expr: 'x*sin(x)',
            lower: '0',
            upper: 'pi/2'
        }
    ];

    try {
        await openIntegralCalculator(page);
        await H.longPause(page);

        for (const s of scenes) {
            console.log(`[Scene] ${s.label}`);
            await setMode(page, s.mode);
            await fillExpression(page, s.expr);
            if (s.mode === 'definite' && s.lower != null && s.upper != null) {
                await setBounds(page, s.lower, s.upper);
            }
            await H.pause(page);
            await integrateAndShowSteps(page, s.label);
            await H.extraPause(page);
        }

        await page.evaluate(() => window.scrollTo({ top: 0, behavior: 'smooth' }));
        await H.longPause(page);

        console.log('Integral calculator demo complete.');
    } catch (err) {
        console.error('Recording error:', err.message);
        console.error(err.stack);
    }

    console.log('Finishing…');
    await H.finishRecording(browser, context, page, outputDir, 'integral-calculator-demo');
})();
