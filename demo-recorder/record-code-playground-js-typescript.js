/**
 * record-code-playground-js-typescript.js
 *
 * Social-media clip for the Polyglot Code Playground (/code-playground/):
 * binary search in JavaScript and TypeScript side by side, "Run all", stop
 * when both outcomes land. Aimed at JS devs picking up TypeScript.
 *
 * Usage:
 *   DEMO_URL=http://localhost:8080/mywebapp2_war_exploded node record-code-playground-js-typescript.js
 *   DEMO_URL=http://localhost:8080/mywebapp2_war_exploded DEMO_SPEED=1.4 node record-code-playground-js-typescript.js
 */
const H = require('./helpers');

const SPEED = parseFloat(process.env.DEMO_SPEED || '1');
const LINE_REVEAL = Math.round(70 / SPEED); // per-line "typing" cadence

// ── Programs (both print "Found 9 at index 4") ──────────────
const JS = [
  'function binarySearch(arr, target) {',
  '  let lo = 0, hi = arr.length - 1;',
  '  while (lo <= hi) {',
  '    const mid = (lo + hi) >> 1;',
  '    if (arr[mid] === target) return mid;',
  '    if (arr[mid] < target) lo = mid + 1;',
  '    else hi = mid - 1;',
  '  }',
  '  return -1;',
  '}',
  '',
  'const nums = [1, 3, 5, 7, 9, 11, 13, 15];',
  'const target = 9;',
  'console.log(`Found ${target} at index ${binarySearch(nums, target)}`);',
].join('\n');

// Same algorithm, now with types doing the talking: a generic signature,
// annotated locals, an explicit return type.
const TS = [
  'function binarySearch<T>(arr: T[], target: T): number {',
  '  let lo = 0, hi = arr.length - 1;',
  '  while (lo <= hi) {',
  '    const mid: number = (lo + hi) >> 1;',
  '    if (arr[mid] === target) return mid;',
  '    if (arr[mid] < target) lo = mid + 1;',
  '    else hi = mid - 1;',
  '  }',
  '  return -1;',
  '}',
  '',
  'const nums: number[] = [1, 3, 5, 7, 9, 11, 13, 15];',
  'const target: number = 9;',
  'const idx: number = binarySearch(nums, target);',
  'console.log(`Found ${target} at index ${idx}`);',
].join('\n');

// ── Playground helpers ──────────────────────────────────────

/** Resolve the two pane iframes (left, right) as Playwright Frames. */
async function getPaneFrames(page) {
  await page.waitForFunction(() => document.querySelectorAll('.pane iframe').length >= 2, { timeout: 20000 });
  const handles = await page.$$('.pane iframe');
  const frames = [];
  for (const h of handles) frames.push(await h.contentFrame());
  return frames;
}

/** Wait until the embed's Monaco editor exists and its starter template loaded. */
async function waitEditorReady(frame) {
  await frame.waitForFunction(
    () => window.editor && typeof window.editor.setValue === 'function'
          && window.editor.getModel && window.editor.getValue().length > 0,
    { timeout: 30000 }
  );
}

/** Reveal code line-by-line into a pane's Monaco editor (typing-like, but reliable). */
async function revealCode(page, frame, code) {
  const lines = code.split('\n');
  let acc = '';
  await frame.evaluate(() => window.editor.setValue(''));
  for (const line of lines) {
    acc += (acc ? '\n' : '') + line;
    await frame.evaluate((t) => {
      window.editor.setValue(t);
      const last = window.editor.getModel().getLineCount();
      window.editor.revealLine(last);
      window.editor.setPosition({ lineNumber: last, column: 1 });
    }, acc);
    await page.waitForTimeout(LINE_REVEAL);
  }
}

/** Wait until a pane has produced real output (not the placeholder / "Executing…"). */
async function waitForOutput(frame) {
  await frame.waitForFunction(() => {
    const panel = document.getElementById('outputPanel');
    const el = document.getElementById('outputContent');
    if (!panel || panel.classList.contains('hidden') || !el) return false;
    return el.classList.contains('success') || el.classList.contains('error');
  }, { timeout: 90000 });
}

// ── Main Recording ──────────────────────────────────────────

(async () => {
  console.log('Recording: Code Playground — binary search, JavaScript vs TypeScript, run all...');
  const { browser, context, page, outputDir } = await H.launchRecorder(
    'code-playground-js-typescript', { width: 1280, height: 720 }
  );

  try {
    const url = `${H.BASE_URL}/code-playground/?panes=javascript,typescript`;
    console.log('[1] Open playground:', url);
    await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 30000 });

    const [left, right] = await getPaneFrames(page);
    console.log('[2] Waiting for both editors...');
    await waitEditorReady(left);
    await waitEditorReady(right);
    await H.pause(page);

    console.log('[3] Writing JavaScript binary search (left — the familiar one)...');
    await revealCode(page, left, JS);
    await H.beat(page);

    console.log('[4] Writing TypeScript binary search (right — same code, with types)...');
    await revealCode(page, right, TS);
    await H.pause(page);

    console.log('[5] Run all...');
    await H.hoverElement(page, '#runAllBtn');
    await page.click('#runAllBtn');

    console.log('[6] Waiting for both outcomes...');
    await Promise.all([waitForOutput(left), waitForOutput(right)]);
    console.log('[7] Both panes produced output — holding, then stop.');
    await H.longPause(page);
    await H.extraPause(page);

    console.log('Done!');
  } catch (err) {
    console.error('Recording error:', err.message);
    console.error(err.stack);
  }

  await H.finishRecording(browser, context, page, outputDir, 'code-playground-js-typescript');
})();
