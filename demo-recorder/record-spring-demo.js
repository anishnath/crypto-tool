/**
 * record-spring-demo.js — Spring Oscillator Deep Demo (~60s)
 *
 * Shows every feature of the spring sim:
 *   1. Sim tab — drag block, watch oscillation, energy bar, clock, trail
 *   2. Adjust sliders — stiffness, damping
 *   3. Presets — Stiff, Soft, Overdamped
 *   4. Phase tab — ellipse/spiral + direction field + current dot
 *   5. Time tab — rolling time series
 *   6. Energy tab — stacked area KE/PE/Total
 *   7. Well tab — PE parabola with rolling dot
 *   8. Export CSV + Screenshot
 *
 * Usage:
 *   DEMO_URL=http://localhost:8080/mywebapp2_war_exploded node record-spring-demo.js
 */
const H = require('./helpers');

const BASE = (process.env.DEMO_URL || 'http://localhost:8080/mywebapp2_war_exploded').replace(/\/$/, '');

async function go(page, path) {
    try {
        await page.goto(BASE + path, { waitUntil: 'domcontentloaded', timeout: 15000 });
    } catch (e) {
        console.log('  ⚠ nav timeout, continuing...');
    }
    try {
        await page.waitForSelector('#simCanvas', { timeout: 8000 });
    } catch (e) {}
    await page.waitForTimeout(1500);
}

async function clickTab(page, tabName) {
    const btn = await page.$(`button[data-tab="${tabName}"]`);
    if (btn) {
        await btn.click();
        await page.waitForTimeout(500);
    }
}

async function clickPreset(page, index) {
    const btn = await page.$(`.preset-btn:nth-child(${index})`);
    if (btn) {
        await btn.click();
        await page.waitForTimeout(500);
    }
}

async function dragOnCanvas(page, fromRatioX, fromRatioY, toRatioX, toRatioY, steps) {
    const canvas = await page.$('#simCanvas');
    if (!canvas) return;
    const box = await canvas.boundingBox();
    if (!box) return;

    const sx = box.x + box.width * fromRatioX;
    const sy = box.y + box.height * fromRatioY;
    const ex = box.x + box.width * toRatioX;
    const ey = box.y + box.height * toRatioY;

    await page.mouse.move(sx, sy);
    await page.waitForTimeout(200);
    await page.mouse.down();
    await page.waitForTimeout(150);

    const n = steps || 25;
    for (let i = 0; i <= n; i++) {
        const t = i / n;
        await page.mouse.move(sx + (ex - sx) * t, sy + (ey - sy) * t);
        await page.waitForTimeout(25);
    }
    await page.mouse.up();
}

async function adjustSlider(page, label, targetRatio) {
    // Find slider by its label text
    const sliders = await page.$$('.param-row');
    for (const row of sliders) {
        const text = await row.textContent();
        if (text && text.includes(label)) {
            const slider = await row.$('input[type="range"]');
            if (slider) {
                const box = await slider.boundingBox();
                if (box) {
                    const x = box.x + box.width * targetRatio;
                    const y = box.y + box.height / 2;
                    await page.mouse.click(x, y);
                    await page.waitForTimeout(300);
                }
            }
            break;
        }
    }
}

(async () => {
    console.log('Recording: Spring Oscillator Deep Demo...');
    const { browser, context, page, outputDir } = await H.launchRecorder('spring-oscillator-demo');

    try {
        // ─── Open Spring ────────────────────────────────────
        console.log('[1] Opening Spring sim...');
        await go(page, '/physics/labs/spring.jsp');
        await page.waitForTimeout(2000); // let it auto-play

        // ─── Scene 1: Watch default oscillation ─────────────
        console.log('[2] Watching default oscillation...');
        await page.waitForTimeout(3000);

        // ─── Scene 2: Drag block far right, release ─────────
        console.log('[3] Dragging block to stretch spring...');
        // Block is roughly at x=0.6 of canvas, y=0.5 (center)
        await dragOnCanvas(page, 0.6, 0.5, 0.85, 0.5, 30);
        await page.waitForTimeout(4000); // watch big oscillation

        // ─── Scene 3: Adjust stiffness slider ───────────────
        console.log('[4] Increasing stiffness...');
        await adjustSlider(page, 'Stiffness', 0.8); // high stiffness
        await page.waitForTimeout(2500); // faster oscillation

        // ─── Scene 4: Increase damping ──────────────────────
        console.log('[5] Adding damping...');
        await adjustSlider(page, 'Damping', 0.4);
        await page.waitForTimeout(3000); // watch amplitude decay

        // ─── Scene 5: Try presets ───────────────────────────
        console.log('[6] Preset: No Damping...');
        await clickPreset(page, 5); // "No Damping"
        await page.waitForTimeout(2500);

        console.log('[6b] Preset: Overdamped...');
        await clickPreset(page, 6); // "Overdamped"
        await page.waitForTimeout(3000); // sluggish return, no oscillation

        console.log('[6c] Preset: Default...');
        await clickPreset(page, 1); // back to default
        await page.waitForTimeout(2000);

        // ─── Scene 6: Phase tab ─────────────────────────────
        console.log('[7] Phase tab — ellipse + direction field...');
        await clickTab(page, 'phase');
        await page.waitForTimeout(4000); // watch ellipse trace + direction arrows

        // ─── Scene 7: Time tab ──────────────────────────────
        console.log('[8] Time tab — rolling time series...');
        await clickTab(page, 'time');
        await page.waitForTimeout(4000); // watch position + velocity lines

        // ─── Scene 8: Energy tab ────────────────────────────
        console.log('[9] Energy tab — stacked area KE/PE/Total...');
        await clickTab(page, 'energy');
        await page.waitForTimeout(4000); // KE and PE oscillate, total flat

        // ─── Scene 9: Well tab ──────────────────────────────
        console.log('[10] Well tab — PE parabola with rolling dot...');
        await clickTab(page, 'well');
        await page.waitForTimeout(4000); // dot rolls in parabolic well

        // ─── Scene 10: Back to Sim, export CSV ──────────────
        console.log('[11] Back to Sim tab...');
        await clickTab(page, 'sim');
        await page.waitForTimeout(1500);

        console.log('[12] Clicking Export CSV...');
        const csvBtn = await page.$('.data-btn:first-child');
        if (csvBtn) {
            await csvBtn.click();
            await page.waitForTimeout(1500);
        }

        console.log('[13] Clicking Screenshot...');
        const shotBtn = await page.$('.data-btn:last-child');
        if (shotBtn) {
            await shotBtn.click();
            await page.waitForTimeout(1500);
        }

        // ─── End ────────────────────────────────────────────
        console.log('[Done] Final pause...');
        await page.waitForTimeout(2000);

    } catch (err) {
        console.error('Demo error:', err.message);
    } finally {
        await page.close();
        const videoPath = await page.video()?.path();
        await context.close();
        await browser.close();

        if (videoPath) {
            console.log('\nRecorded video:', videoPath);
            console.log('Convert to MP4: node convert-to-mp4.js');
        }
    }
})();
