/**
 * record-circuit-simulator-demo.js — Circuit Simulator Demo (~90s)
 *
 * Records a demo showcasing the circuit simulator:
 *   1. Open simulator, load a preset (Voltage Divider)
 *   2. Show dots flowing, voltage colors, scope
 *   3. Load a bigger circuit (Common Emitter Amplifier)
 *   4. Build a circuit from scratch (10+ nodes): V → R → LED → R → C → GND
 *   5. Show edit value from info panel
 *   6. Load Power Supply preset (16 elements, 12 nodes)
 *   7. Export as image
 *
 * Usage:
 *   DEMO_URL=http://localhost:8080/mywebapp2_war_exploded node record-circuit-simulator-demo.js
 *   DEMO_URL=https://8gwifi.org node record-circuit-simulator-demo.js
 */
const H = require('./helpers');

const BASE = (process.env.DEMO_URL || 'http://localhost:8080/mywebapp2_war_exploded').replace(/\/$/, '');
const SIM_URL = '/physics/labs/circuit-simulator.jsp';

async function pause(page, ms) { await page.waitForTimeout(ms); }

async function clickMenu(page, menuText) {
  // Click top-level menu button
  const btn = await page.$$(`.circuit-menu-btn`);
  for (const b of btn) {
    const text = await b.textContent();
    if (text.trim() === menuText) { await b.click(); break; }
  }
  await pause(page, 300);
}

async function clickMenuItem(page, itemText) {
  // Click a menu item by text
  await pause(page, 200);
  const items = await page.$$(`.circuit-menu-item`);
  for (const item of items) {
    const text = await item.textContent();
    if (text.includes(itemText)) { await item.click(); break; }
  }
  await pause(page, 300);
}

async function drawComponent(page, canvasSel, x1, y1, x2, y2) {
  const canvas = await page.$(canvasSel);
  const box = await canvas.boundingBox();
  await page.mouse.move(box.x + x1, box.y + y1);
  await pause(page, 100);
  await page.mouse.down();
  await pause(page, 50);
  // Smooth drag
  const steps = 10;
  for (let i = 1; i <= steps; i++) {
    const t = i / steps;
    await page.mouse.move(
      box.x + x1 + (x2 - x1) * t,
      box.y + y1 + (y2 - y1) * t
    );
    await pause(page, 20);
  }
  await page.mouse.up();
  await pause(page, 200);
}

(async () => {
  console.log('Recording: Circuit Simulator Demo...');
  console.log('BASE_URL:', BASE);
  // Tall viewport: enough for menu+toolbar+canvas+scope all visible
  const { browser, context, page, outputDir } = await H.launchRecorder('circuit-simulator-demo', {
    width: 1440, height: 900
  });

  try {
    // ─── Setup: Hide nav/ad to maximize visible area ────
    console.log('[0] Setup: maximizing visible area...');
    await page.goto(BASE + SIM_URL, { waitUntil: 'domcontentloaded', timeout: 20000 });
    await pause(page, 2000);

    // Inject CSS overrides to guarantee all panels visible in recording
    await page.addStyleTag({ content: `
      /* Kill the fixed nav and all ads */
      .modern-nav, #ad_lab_hero, #ad_lab_below, #adLabSticky, .ckt-header { display: none !important; }

      /* Remove top padding from hidden nav */
      .ckt-app { padding-top: 0 !important; height: 100vh !important; }

      /* CRITICAL: Don't let canvas eat all space — use grid layout instead of flex */
      .ckt-app {
        display: grid !important;
        grid-template-rows: auto auto 1fr 180px !important;  /* menu, toolbar, canvas, scope */
      }

      /* Canvas + info side by side */
      .ckt-main {
        display: flex !important;
        flex: none !important;
        overflow: hidden !important;
        min-height: 0 !important;
      }

      /* Info panel always visible */
      .ckt-info {
        display: block !important;
        width: 240px !important;
        min-width: 240px !important;
      }

      /* Scope always visible with fixed height */
      #scopeWrap {
        display: block !important;
        height: 180px !important;
        min-height: 180px !important;
      }

      /* Canvas fills remaining space in .ckt-main */
      .ckt-canvas-wrap {
        flex: 1 !important;
        min-height: 0 !important;
      }
    `});
    await pause(page, 300);

    // Force resize event so canvas recalculates dimensions
    await page.evaluate(() => window.dispatchEvent(new Event('resize')));
    await pause(page, 500);

    // ─── Scene 1: Open with blank canvas ────────────────
    console.log('[1] Showing blank simulator...');
    await pause(page, 2000);

    // ─── Scene 2: Load Voltage Divider preset ───────────
    console.log('[2] Loading Voltage Divider...');
    await clickMenu(page, 'Circuits');
    await pause(page, 600);
    await clickMenuItem(page, 'Basics');
    await pause(page, 500);
    await clickMenuItem(page, 'Voltage Divider');
    await pause(page, 1000);

    // Click a resistor to show info panel
    const canvas = await page.$('#circuitCanvas');
    const box = await canvas.boundingBox();
    await page.mouse.click(box.x + box.width * 0.4, box.y + box.height * 0.3);
    await pause(page, 3000);  // show: dots + voltage colors + scope + info panel

    // ─── Scene 3: Load RC Circuit (shows scope waveform) ─
    console.log('[3] Loading RC Circuit (scope demo)...');
    await clickMenu(page, 'Circuits');
    await pause(page, 600);
    await clickMenuItem(page, 'AC Circuits');
    await pause(page, 500);
    await clickMenuItem(page, 'RC Circuit');
    await pause(page, 4000);  // scope shows charging curve

    // ─── Scene 4: Load Common Emitter (BJT) ─────────────
    console.log('[4] Loading Common Emitter...');
    await clickMenu(page, 'Circuits');
    await pause(page, 600);
    await clickMenuItem(page, 'Transistors');
    await pause(page, 500);
    await clickMenuItem(page, 'Common Emitter');
    await pause(page, 1000);
    // Click the BJT to show its properties
    await page.mouse.click(box.x + box.width * 0.45, box.y + box.height * 0.35);
    await pause(page, 3000);

    // ─── Scene 5: Load Power Supply (big circuit) ───────
    console.log('[5] Loading Power Supply (16 elements)...');
    await clickMenu(page, 'Circuits');
    await pause(page, 600);
    await clickMenuItem(page, 'Complex');
    await pause(page, 500);
    await clickMenuItem(page, 'Power Supply');
    await pause(page, 4000);

    // ─── Scene 6: Build from scratch ────────────────────
    console.log('[6] Building circuit from scratch...');

    // New blank
    await clickMenu(page, 'File');
    await pause(page, 300);
    await clickMenuItem(page, 'New Blank');
    await pause(page, 1000);

    // Place voltage source: press 'v', drag
    console.log('  Placing voltage source...');
    await page.keyboard.press('v');
    await pause(page, 500);
    await drawComponent(page, '#circuitCanvas', 200, 400, 200, 200);
    await pause(page, 500);

    // Place resistor: press 'r', drag
    console.log('  Placing resistor...');
    await page.keyboard.press('r');
    await pause(page, 500);
    await drawComponent(page, '#circuitCanvas', 200, 200, 350, 200);
    await pause(page, 500);

    // Place LED: right-click → draw menu
    console.log('  Placing LED...');
    await page.keyboard.press('d');  // diode shortcut
    await pause(page, 500);
    await drawComponent(page, '#circuitCanvas', 350, 200, 500, 200);
    await pause(page, 500);

    // Place another resistor
    console.log('  Placing second resistor...');
    await page.keyboard.press('r');
    await pause(page, 500);
    await drawComponent(page, '#circuitCanvas', 500, 200, 650, 200);
    await pause(page, 500);

    // Place capacitor
    console.log('  Placing capacitor...');
    await page.keyboard.press('c');
    await pause(page, 500);
    await drawComponent(page, '#circuitCanvas', 650, 200, 650, 400);
    await pause(page, 500);

    // Wire: bottom of cap to bottom of V source
    console.log('  Placing wires...');
    await page.keyboard.press('w');
    await pause(page, 500);
    await drawComponent(page, '#circuitCanvas', 650, 400, 200, 400);
    await pause(page, 500);

    // Ground
    console.log('  Placing ground...');
    await page.keyboard.press('g');
    await pause(page, 500);
    {
      const c = await page.$('#circuitCanvas');
      const b = await c.boundingBox();
      await page.mouse.click(b.x + 200, b.y + 400);
    }
    await pause(page, 500);

    // Escape back to select mode
    await page.keyboard.press('Escape');
    await pause(page, 3000);  // watch the circuit solve with dots

    // ─── Scene 7: Click element, show info panel ─────────
    console.log('[7] Showing info panel with editable properties...');
    {
      const c = await page.$('#circuitCanvas');
      const b = await c.boundingBox();
      await page.mouse.click(b.x + 350, b.y + 200);
    }
    await pause(page, 2000);

    // ─── Scene 8: Zoom to fit ───────────────────────────
    console.log('[8] Zoom to fit...');
    await page.keyboard.press('f');
    await pause(page, 2000);

    // ─── Scene 9: Load R-2R DAC (complex, 14 nodes) ────
    console.log('[9] Loading R-2R DAC...');
    await clickMenu(page, 'Circuits');
    await pause(page, 600);
    await clickMenuItem(page, 'Complex');
    await pause(page, 500);
    await clickMenuItem(page, 'R-2R Ladder');
    await pause(page, 1000);
    {
      const c = await page.$('#circuitCanvas');
      const b = await c.boundingBox();
      await page.mouse.click(b.x + b.width * 0.3, b.y + b.height * 0.3);
    }
    await pause(page, 3000);

    // ─── Scene 10: Stop/Start simulation ────────────────
    console.log('[10] Stop and start...');
    await page.keyboard.press(' ');  // stop — dots freeze
    await pause(page, 2000);
    await page.keyboard.press(' ');  // start — dots resume
    await pause(page, 2000);

    // ─── Scene 11: Export as image ──────────────────────
    console.log('[11] Export as image...');
    await clickMenu(page, 'File');
    await pause(page, 500);
    await clickMenuItem(page, 'Export as Image');
    await pause(page, 2000);

    // Final hold
    await pause(page, 2000);

    console.log('Demo recording complete.');
  } catch (err) {
    console.error('Error during recording:', err);
  } finally {
    // Get the video path from Playwright BEFORE closing
    const videoPath = await page.video().path();
    await page.close();
    await context.close();
    await browser.close();

    // Rename to a proper filename
    const fs = require('fs');
    const path = require('path');
    if (videoPath && fs.existsSync(videoPath)) {
      const dest = path.join(outputDir, 'circuit-simulator-demo.webm');
      // Remove old file if exists
      if (fs.existsSync(dest)) fs.unlinkSync(dest);
      fs.renameSync(videoPath, dest);
      console.log(`\nVideo saved: ${dest}`);
      console.log('Convert to MP4: node convert-to-mp4.js');
    } else {
      console.log('Warning: video file not found at', videoPath);
    }
  }
})();
