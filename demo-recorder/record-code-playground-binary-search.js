/**
 * record-code-playground-binary-search.js
 *
 * Social-media clip for the Polyglot Code Playground (/code-playground/):
 * two binary-search programs written side by side (Python + JavaScript),
 * "Run all", and stop the moment both outcomes land.
 *
 * Usage:
 *   DEMO_URL=http://localhost:8080/mywebapp2_war_exploded node record-code-playground-binary-search.js
 *   DEMO_URL=http://localhost:8080/mywebapp2_war_exploded DEMO_SPEED=1.4 node record-code-playground-binary-search.js
 */
const H = require('./helpers');

const SPEED = parseFloat(process.env.DEMO_SPEED || '1');
const LINE_REVEAL = Math.round(70 / SPEED); // per-line "typing" cadence

// ── Programs (both print "Found at index 4") ────────────────
const PY = [
  'def binary_search(arr, target):',
  '    lo, hi = 0, len(arr) - 1',
  '    while lo <= hi:',
  '        mid = (lo + hi) // 2',
  '        if arr[mid] == target:',
  '            return mid',
  '        elif arr[mid] < target:',
  '            lo = mid + 1',
  '        else:',
  '            hi = mid - 1',
  '    return -1',
  '',
  'nums = [1, 3, 5, 7, 9, 11, 13, 15]',
  'target = 9',
  'idx = binary_search(nums, target)',
  'print(f"Array:  {nums}")',
  'print(f"Target: {target}")',
  'print(f"Found at index {idx}")',
].join('\n');

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
  'const idx = binarySearch(nums, target);',
  'console.log(`Array:  [${nums}]`);',
  'console.log(`Target: ${target}`);',
  'console.log(`Found at index ${idx}`);',
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
  // start from a clean editor
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
    // embed sets class to "embed-output-content success" / "error" on completion
    return el.classList.contains('success') || el.classList.contains('error');
  }, { timeout: 60000 });
}

// ── Main Recording ──────────────────────────────────────────

(async () => {
  console.log('Recording: Code Playground — binary search, two languages, run all...');
  const { browser, context, page, outputDir } = await H.launchRecorder(
    'code-playground-binary-search', { width: 1280, height: 720 }
  );

  try {
    const url = `${H.BASE_URL}/code-playground/?panes=python,javascript`;
    console.log('[1] Open playground:', url);
    await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 30000 });

    const [left, right] = await getPaneFrames(page);
    console.log('[2] Waiting for both editors...');
    await waitEditorReady(left);
    await waitEditorReady(right);
    await H.pause(page);

    console.log('[3] Writing Python binary search (left)...');
    await revealCode(page, left, PY);
    await H.beat(page);

    console.log('[4] Writing JavaScript binary search (right)...');
    await revealCode(page, right, JS);
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

  await H.finishRecording(browser, context, page, outputDir, 'code-playground-binary-search');
})();
