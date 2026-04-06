/**
 * record-logic-simulator-demo.js — Logic Gate Simulator Demo (~90s)
 *
 * Flow:
 *   1. Blank canvas → load AND Truth Table preset
 *   2. Simulate mode — toggle inputs, see output change
 *   3. Load XOR from NAND preset → Analyze (truth table + K-map)
 *   4. Load 4-bit Counter → timing diagram with clock
 *   5. AI generation — type description, get circuit
 *   6. Expression → Circuit
 *
 * Usage:
 *   DEMO_URL=http://localhost:8080/mywebapp2_war_exploded node record-logic-simulator-demo.js
 *   DEMO_URL=https://8gwifi.org node record-logic-simulator-demo.js
 */
const H = require('./helpers');

const BASE = (process.env.DEMO_URL || 'http://localhost:8080/mywebapp2_war_exploded').replace(/\/$/, '');
const SIM_URL = '/electronics/logic-simulator.jsp';

async function pause(page, ms) { await page.waitForTimeout(ms); }

async function clickCanvas(page, svgBox, xPct, yPct) {
  await page.mouse.click(svgBox.x + svgBox.width * xPct, svgBox.y + svgBox.height * yPct);
  await pause(page, 400);
}

(async () => {
  console.log('Recording: Logic Gate Simulator Demo...');
  console.log('BASE_URL:', BASE);

  const { browser, context, page, outputDir } = await H.launchRecorder('logic-simulator-demo', {
    width: 1440, height: 900
  });

  // Auto-accept all dialogs
  page.on('dialog', async dialog => {
    try {
      if (dialog.type() === 'prompt') await dialog.accept('A*B + !C');
      else await dialog.accept();
    } catch (e) { /* already handled */ }
  });

  try {
    // ─── Setup ────────────────────────────────────────────
    console.log('[0] Loading simulator...');
    await page.goto(BASE + SIM_URL, { waitUntil: 'domcontentloaded', timeout: 20000 });
    await pause(page, 3000);

    // Hide nav/ads for clean recording
    await page.addStyleTag({ content: `
      .modern-nav, .lg-hero-bar, .lg-adsense-bar, .lg-circuit-tabs, .lg-breadcrumb { display: none !important; }
      .lg-app { height: 100vh !important; }
    `});
    await page.evaluate(() => window.dispatchEvent(new Event('resize')));
    await pause(page, 500);

    const svg = await page.$('#canvasSvg');
    const box = await svg.boundingBox();

    // ─── Scene 1: Load AND Truth Table preset ─────────────
    console.log('[1] Loading AND Truth Table preset...');
    await page.selectOption('#presetSelect', { index: 10 }); // AND Truth Table
    await pause(page, 2000);

    // ─── Scene 2: Simulate — toggle inputs ────────────────
    console.log('[2] Simulate mode — toggling inputs...');
    await page.click('#btnSimulate');
    await pause(page, 1000);

    // Toggle A (left side, upper)
    console.log('  Toggle A...');
    await clickCanvas(page, box, 0.3, 0.4);
    await pause(page, 1500);

    // Toggle B (left side, lower)
    console.log('  Toggle B...');
    await clickCanvas(page, box, 0.3, 0.6);
    await pause(page, 1500);

    // Toggle A again — now both ON → output ON
    console.log('  Toggle A again (both ON)...');
    await clickCanvas(page, box, 0.3, 0.4);
    await pause(page, 2000);

    // Back to edit
    await page.click('#btnSimulate');
    await pause(page, 1000);

    // ─── Scene 3: Load XOR from NAND + Analyze ────────────
    console.log('[3] Loading XOR from NAND...');
    await page.selectOption('#presetSelect', { index: 8 }); // XOR from NAND
    await pause(page, 2000);

    console.log('  Opening Analysis panel...');
    await page.click('#btnAnalyze');
    await pause(page, 3000);

    // Scroll to show K-map
    await page.evaluate(() => {
      const body = document.getElementById('analysisBody');
      if (body) body.scrollTop = body.scrollHeight / 3;
    });
    await pause(page, 2000);

    // Scroll more to show minimized expression
    await page.evaluate(() => {
      const body = document.getElementById('analysisBody');
      if (body) body.scrollTop = body.scrollHeight;
    });
    await pause(page, 2000);

    // Close analysis
    await page.click('#btnCloseAnalysis');
    await pause(page, 1000);

    // ─── Scene 4: Load 4-bit Counter + timing diagram ─────
    console.log('[4] Loading 4-bit Counter...');
    await page.selectOption('#presetSelect', { index: 5 }); // Counter
    await pause(page, 2000);

    // Simulate mode
    await page.click('#btnSimulate');
    await pause(page, 500);

    // Open timing + start recording
    console.log('  Opening timing diagram + recording...');
    await page.click('#btnChrono');
    await pause(page, 500);
    await page.click('#btnChronoRecord');
    await pause(page, 500);

    // Start clock (click it)
    console.log('  Starting clock...');
    await clickCanvas(page, box, 0.25, 0.35);
    await pause(page, 6000); // Watch counter count + waveforms

    // Stop clock
    await clickCanvas(page, box, 0.25, 0.35);
    await pause(page, 1000);

    // Stop recording
    await page.click('#btnChronoRecord');
    await pause(page, 2000);

    // Close chrono + back to edit
    await page.click('#btnChronoClose');
    await page.click('#btnSimulate');
    await pause(page, 1000);

    // ─── Scene 5: AI Generation ───────────────────────────
    console.log('[5] AI Circuit Generation...');
    await page.click('#btnAI');
    await pause(page, 1000);

    // Click an example chip first
    console.log('  Clicking example chip...');
    const chip = await page.$('.lg-ai-chip');
    if (chip) await chip.click();
    await pause(page, 500);

    // Clear and type custom description
    await page.fill('#aiInput', '');
    await page.type('#aiInput', 'half adder with XOR for sum and AND for carry', { delay: 40 });
    await pause(page, 1000);

    // Generate
    console.log('  Generating...');
    await page.click('#aiGenerate');
    await pause(page, 8000); // Wait for AI

    // Close AI panel
    await page.click('#aiClose');
    await pause(page, 1000);

    // ─── Scene 6: Expression → Circuit ────────────────────
    console.log('[6] Expression → Circuit...');
    await page.click('#btnSynthesize');
    await pause(page, 3000);

    // ─── Scene 7: Final fit ───────────────────────────────
    console.log('[7] Final fit...');
    await page.click('#btnFit');
    await pause(page, 3000);

    console.log('Demo recording complete.');
  } catch (err) {
    console.error('Error during recording:', err);
  } finally {
    const videoPath = await page.video().path();
    await page.close();
    await context.close();
    await browser.close();

    const fs = require('fs');
    const path = require('path');
    if (videoPath && fs.existsSync(videoPath)) {
      const dest = path.join(outputDir, 'logic-simulator-demo.webm');
      if (fs.existsSync(dest)) fs.unlinkSync(dest);
      fs.renameSync(videoPath, dest);
      console.log(`\nVideo saved: ${dest}`);
      console.log('Convert to MP4: node convert-to-mp4.js');
    } else {
      console.log('Warning: video file not found at', videoPath);
    }
  }
})();
