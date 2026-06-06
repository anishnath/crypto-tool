/**
 * record-chemistry-formula-to-molecule.js
 *
 * Walks through every functionality of the Chemistry "Formula → Structure"
 * tool (chemistry/formula-to-molecule.jsp), one scene at a time:
 *
 *   1. Formula lookup            — type a molecular formula, get 2D structures
 *   2. Lewis structure (NEW)     — •• Lewis opens the Lewis Structures tool inline
 *   3. Interactive 3D model      — 🧊 3D, switch representation, animate
 *   4. View composition          — ⚗ formation-from-elements figure
 *   5. Copy SMILES               — 📋 copy the SMILES string
 *   6. Balance an equation       — Fe + Cl2 = FeCl3
 *   7. Predict products          — reactants only (C + O2) → balanced products
 *
 * Usage:
 *   DEMO_URL=http://localhost:8080/mywebapp2_war_exploded node record-chemistry-formula-to-molecule.js
 *   DEMO_URL=http://localhost:8080/mywebapp2_war_exploded DEMO_SPEED=1.3 node record-chemistry-formula-to-molecule.js
 */
const H = require('./helpers');

const SPEED = parseFloat(process.env.DEMO_SPEED || '1');
const TYPE_DELAY = Math.round(70 / SPEED);

// ── Page helpers (all selectors belong to formula-to-molecule.jsp itself) ──

/** Type a query into the formula box (clearing whatever is there first). */
async function typeFormula(page, text) {
  await page.click('#formula');
  await page.fill('#formula', '');
  await page.waitForTimeout(H.SHORT_PAUSE);
  await page.type('#formula', text, { delay: TYPE_DELAY });
  await page.waitForTimeout(H.SHORT_PAUSE);
}

/** Press "Look up". */
async function lookUp(page) {
  await H.hoverElement(page, '#searchBtn');
  await page.click('#searchBtn');
}

/** Wait until at least one compound card has rendered. */
async function waitForCards(page) {
  await page.waitForFunction(
    () => document.querySelectorAll('#results .card').length > 0,
    { timeout: 40000 }
  );
  await H.pause(page);
}

/** Wait until a balanced-equation figure card has rendered. */
async function waitForEquation(page) {
  await page.waitForFunction(
    () => document.querySelector('#results .eqn-card img'),
    { timeout: 90000 }
  );
  await H.pause(page);
}

/** Click a per-card action button on the first result card. */
async function clickCardAction(page, dataAttr) {
  const sel = `#results .card [${dataAttr}]`;
  await page.waitForSelector(sel, { timeout: 10000 });
  await H.hoverElement(page, sel);
  await page.click(sel);
}

/** Close whichever modal is open via its × button, then settle. */
async function closeModal(page, closeId) {
  await page.click('#' + closeId);
  await page.waitForTimeout(H.MEDIUM_PAUSE);
}

// ── Main Recording ──────────────────────────────────────────

(async () => {
  console.log('Recording: Chemistry — Formula → Structure, full feature tour...');
  const { browser, context, page, outputDir } = await H.launchRecorder(
    'chemistry-formula-to-molecule', { width: 1440, height: 900 }
  );

  try {
    const url = `${H.BASE_URL}/chemistry/formula-to-molecule.jsp`;
    console.log('[1] Open tool:', url);
    await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 30000 });
    await page.waitForSelector('#formula', { timeout: 20000 });
    // Give OpenChemLib (2D renderer) a moment to load so cards show structures.
    await page.waitForTimeout(2500);
    await H.pause(page);

    // ── Scene 1: formula lookup ──────────────────────────────
    console.log('[2] Look up a molecular formula (C2H6O)...');
    await typeFormula(page, 'C2H6O');
    await lookUp(page);
    await waitForCards(page);
    await H.longPause(page);

    // ── Scene 2: Lewis structure (the new feature) ───────────
    console.log('[3] Lewis structure — open the Lewis Structures tool inline...');
    await clickCardAction(page, 'data-lewis');
    await page.waitForSelector('#lewis-overlay:not([hidden])', { timeout: 10000 });
    // The modal hosts the real Lewis Structures tool in an iframe; wait for it
    // to finish drawing (its p5 canvas appears).
    try {
      const frameEl = await page.waitForSelector('#lewis-frame', { timeout: 10000 });
      const frame = await frameEl.contentFrame();
      await frame.waitForSelector('#lewisCanvasContainer canvas', { timeout: 30000 });
    } catch (e) {
      console.log('   (Lewis canvas wait skipped:', e.message, ')');
    }
    await H.extraPause(page);
    await H.longPause(page);
    await closeModal(page, 'lewis-close');

    // ── Scene 3: interactive 3D model ────────────────────────
    console.log('[4] Interactive 3D model — step through each representation, then animate...');
    await clickCardAction(page, 'data-3d');
    await page.waitForSelector('#mol3d-overlay:not([hidden])', { timeout: 10000 });
    try {
      await page.waitForSelector('#mol3d-viewer canvas', { timeout: 30000 });
    } catch (e) {
      console.log('   (3D canvas wait skipped:', e.message, ')');
    }
    // Let the default Ball & Stick model settle and be seen.
    await H.longPause(page);

    // Walk through the representation tabs, pausing on each so the change
    // is clear without dragging.
    const styles = ['stick', 'line', 'sphere', 'ballstick'];
    for (const s of styles) {
      console.log('     · representation:', s);
      await H.hoverElement(page, `#m3d-styles [data-style="${s}"]`);
      await page.click(`#m3d-styles [data-style="${s}"]`);
      await H.longPause(page);
    }

    // Animate briefly.
    console.log('     · animate');
    await H.hoverElement(page, '#m3d-spin');
    await page.click('#m3d-spin');
    await H.longPause(page);
    await closeModal(page, 'mol3d-close');

    // ── Scene 4: view composition ────────────────────────────
    console.log('[5] View composition — formation-from-elements figure...');
    await clickCardAction(page, 'data-comp');
    await page.waitForSelector('#eq-overlay:not([hidden])', { timeout: 10000 });
    try {
      await page.waitForFunction(() => document.querySelector('#eq-row img'), { timeout: 20000 });
    } catch (e) {
      console.log('   (composition image wait skipped:', e.message, ')');
    }
    await H.extraPause(page);
    await closeModal(page, 'eq-close');

    // ── Scene 5: copy SMILES ─────────────────────────────────
    console.log('[6] Copy SMILES...');
    await clickCardAction(page, 'data-copy');
    await H.longPause(page);          // show the "SMILES copied" toast
    await page.keyboard.press('Escape');
    await H.pause(page);

    // ── Scene 6: balance a full equation ─────────────────────
    console.log('[7] Balance an equation (Fe + Cl2 = FeCl3)...');
    await typeFormula(page, 'Fe + Cl2 = FeCl3');
    await lookUp(page);
    await waitForEquation(page);
    await H.extraPause(page);

    // ── Scene 7: predict products from reactants only ────────
    console.log('[8] Predict products from reactants only (C + O2)...');
    await typeFormula(page, 'C + O2');
    await lookUp(page);
    try {
      await waitForEquation(page);    // AI predict → balance; can take longer
      await H.extraPause(page);
    } catch (e) {
      console.log('   (prediction wait skipped:', e.message, ')');
      await H.longPause(page);
    }

    console.log('Done!');
  } catch (err) {
    console.error('Recording error:', err.message);
    console.error(err.stack);
  }

  await H.finishRecording(browser, context, page, outputDir, 'chemistry-formula-to-molecule');
})();
