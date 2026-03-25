/**
 * record-physics-labs-demo.js — Physics Labs Demo (~90-120s)
 *
 * Records a demo video showcasing the physics labs:
 *   1. Labs index page (overview)
 *   2. Pendulum — drag bob, watch swing, switch to phase tab
 *   3. Double Pendulum — chaos, trail
 *   4. Billiards — break shot
 *   5. Vibrating String — pluck, sine mode
 *   6. Pile — rigid body stacking
 *
 * Usage:
 *   DEMO_URL=http://localhost:8080/mywebapp2_war_exploded node record-physics-labs-demo.js
 *   DEMO_URL=https://8gwifi.org node record-physics-labs-demo.js
 */
const H = require('./helpers');

const BASE = (process.env.DEMO_URL || 'http://localhost:8080/mywebapp2_war_exploded').replace(/\/$/, '');

async function go(page, path) {
    console.log('  → navigating to:', path);
    try {
        await page.goto(BASE + path, { waitUntil: 'domcontentloaded', timeout: 15000 });
    } catch (e) {
        console.log('  ⚠ nav timeout, continuing anyway...');
    }
    // Wait for canvas to appear (sim loaded)
    try {
        await page.waitForSelector('#simCanvas', { timeout: 8000 });
    } catch (e) {
        // index page has no simCanvas — that's fine
    }
    await page.waitForTimeout(1000);
}

(async () => {
    console.log('Recording: Physics Labs Demo...');
    console.log('BASE_URL:', BASE);
    const { browser, context, page, outputDir } = await H.launchRecorder('physics-labs-demo');

    try {
        // ─── Scene 1: Labs Index ────────────────────────────
        console.log('[1] Opening labs index...');
        await go(page, '/physics/labs/');
        await page.waitForTimeout(2000);

        // Scroll slowly to show all categories
        await smoothScroll(page, 400);
        await page.waitForTimeout(1500);
        await smoothScroll(page, 400);
        await page.waitForTimeout(1500);
        await smoothScroll(page, -800); // back to top
        await page.waitForTimeout(1000);

        // ─── Scene 2: Pendulum ──────────────────────────────
        console.log('[2] Opening Pendulum...');
        await go(page, '/physics/labs/pendulum.jsp');
        await page.waitForTimeout(3000); // let sim load and start

        // Drag the bob
        console.log('[2a] Dragging pendulum bob...');
        const simCanvas1 = await page.$('#simCanvas');
        if (simCanvas1) {
            const box = await simCanvas1.boundingBox();
            if (box) {
                // Bob is roughly in the lower-center area
                const startX = box.x + box.width * 0.6;
                const startY = box.y + box.height * 0.7;
                const endX = box.x + box.width * 0.8;
                const endY = box.y + box.height * 0.3;

                await page.mouse.move(startX, startY);
                await page.waitForTimeout(300);
                await page.mouse.down();
                await page.waitForTimeout(200);

                // Slow drag to the side
                const steps = 20;
                for (let i = 0; i <= steps; i++) {
                    const t = i / steps;
                    await page.mouse.move(
                        startX + (endX - startX) * t,
                        startY + (endY - startY) * t
                    );
                    await page.waitForTimeout(30);
                }
                await page.mouse.up();
            }
        }
        await page.waitForTimeout(4000); // watch it swing

        // Click Phase tab
        console.log('[2b] Switching to Phase tab...');
        const phaseTab = await page.$('button[data-tab="phase"]');
        if (phaseTab) await phaseTab.click();
        await page.waitForTimeout(3000);

        // Back to Sim
        const simTab = await page.$('button[data-tab="sim"]');
        if (simTab) await simTab.click();
        await page.waitForTimeout(1000);

        // ─── Scene 3: Double Pendulum (Chaos) ───────────────
        console.log('[3] Opening Double Pendulum...');
        await go(page, '/physics/labs/double-pendulum.jsp');
        await page.waitForTimeout(5000); // let chaos unfold with trail

        // Click a preset
        console.log('[3a] Trying Full Flip preset...');
        const fullFlip = await page.$('.preset-btn:nth-child(3)');
        if (fullFlip) await fullFlip.click();
        await page.waitForTimeout(5000); // watch chaotic motion

        // ─── Scene 4: Billiards ─────────────────────────────
        console.log('[4] Opening Billiards...');
        await go(page, '/physics/labs/billiards.jsp');
        await page.waitForTimeout(5000); // watch break shot play out

        // ─── Scene 5: Vibrating String ──────────────────────
        console.log('[5] Opening Vibrating String...');
        await go(page, '/physics/labs/string-wave.jsp');
        await page.waitForTimeout(4000); // watch pluck vibration

        // Try sine mode
        console.log('[5a] Switching to Sine mode...');
        const sinePreset = await page.$('.preset-btn:nth-child(2)');
        if (sinePreset) await sinePreset.click();
        await page.waitForTimeout(3000);

        // Try pulse
        console.log('[5b] Switching to Pulse...');
        const pulsePreset = await page.$('.preset-btn:nth-child(4)');
        if (pulsePreset) await pulsePreset.click();
        await page.waitForTimeout(4000);

        // ─── Scene 6: Brachistochrone Race ───────────────────
        console.log('[6] Opening Brachistochrone...');
        await go(page, '/physics/labs/brachistochrone.jsp');
        await page.waitForTimeout(6000); // watch the race — cycloid wins

        // ─── Scene 7: Pile ──────────────────────────────────
        console.log('[7] Opening Pile...');
        await go(page, '/physics/labs/pile.jsp');
        await page.waitForTimeout(5000); // watch bodies fall and stack

        // Drag a body and throw it
        console.log('[7a] Dragging a body...');
        const simCanvas7 = await page.$('#simCanvas');
        if (simCanvas7) {
            const box = await simCanvas7.boundingBox();
            if (box) {
                const cx = box.x + box.width * 0.5;
                const cy = box.y + box.height * 0.3;
                await page.mouse.move(cx, cy);
                await page.waitForTimeout(200);
                await page.mouse.down();
                await page.waitForTimeout(100);
                // Fling upward
                for (let i = 0; i < 15; i++) {
                    await page.mouse.move(cx + i * 5, cy - i * 10);
                    await page.waitForTimeout(20);
                }
                await page.mouse.up();
            }
        }
        await page.waitForTimeout(3000);

        // ─── Scene 8: Newton's Cradle ───────────────────────
        console.log('[8] Opening Newton\'s Cradle...');
        await go(page, '/physics/labs/newtons-cradle.jsp');
        await page.waitForTimeout(5000); // watch cradle swing

        // Try 2-ball preset
        const twoball = await page.$('.preset-btn:nth-child(2)');
        if (twoball) await twoball.click();
        await page.waitForTimeout(4000);

        // ─── End ────────────────────────────────────────────
        console.log('[Done] Finishing recording...');
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

// Smooth scroll helper
async function smoothScroll(page, pixels) {
    const steps = Math.abs(Math.round(pixels / 40));
    const dir = pixels > 0 ? 40 : -40;
    for (let i = 0; i < steps; i++) {
        await page.mouse.wheel(0, dir);
        await page.waitForTimeout(50);
    }
}
