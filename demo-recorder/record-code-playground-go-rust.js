/**
 * record-code-playground-go-rust.js
 *
 * Social-media clip for the Polyglot Code Playground (/code-playground/):
 * binary search in Go and Rust written side by side, "Run all", and stop
 * the moment both outcomes land. Aimed at r/rust.
 *
 * Usage:
 *   DEMO_URL=http://localhost:8080/mywebapp2_war_exploded node record-code-playground-go-rust.js
 *   DEMO_URL=http://localhost:8080/mywebapp2_war_exploded DEMO_SPEED=1.4 node record-code-playground-go-rust.js
 */
const H = require('./helpers');

const SPEED = parseFloat(process.env.DEMO_SPEED || '1');
const LINE_REVEAL = Math.round(70 / SPEED); // per-line "typing" cadence

// ── Programs (both print "Found 9 at index 4") ──────────────
const GO = [
  'package main',
  '',
  'import "fmt"',
  '',
  'func binarySearch(arr []int, target int) int {',
  '\tlo, hi := 0, len(arr)-1',
  '\tfor lo <= hi {',
  '\t\tmid := (lo + hi) / 2',
  '\t\tswitch {',
  '\t\tcase arr[mid] == target:',
  '\t\t\treturn mid',
  '\t\tcase arr[mid] < target:',
  '\t\t\tlo = mid + 1',
  '\t\tdefault:',
  '\t\t\thi = mid - 1',
  '\t\t}',
  '\t}',
  '\treturn -1',
  '}',
  '',
  'func main() {',
  '\tnums := []int{1, 3, 5, 7, 9, 11, 13, 15}',
  '\ttarget := 9',
  '\tif i := binarySearch(nums, target); i >= 0 {',
  '\t\tfmt.Printf("Found %d at index %d\\n", target, i)',
  '\t} else {',
  '\t\tfmt.Printf("%d not found\\n", target)',
  '\t}',
  '}',
].join('\n');

const RUST = [
  'use std::cmp::Ordering;',
  '',
  'fn binary_search(arr: &[i32], target: i32) -> Option<usize> {',
  '    let (mut lo, mut hi) = (0, arr.len());',
  '    while lo < hi {',
  '        let mid = lo + (hi - lo) / 2;',
  '        match arr[mid].cmp(&target) {',
  '            Ordering::Equal => return Some(mid),',
  '            Ordering::Less => lo = mid + 1,',
  '            Ordering::Greater => hi = mid,',
  '        }',
  '    }',
  '    None',
  '}',
  '',
  'fn main() {',
  '    let nums = [1, 3, 5, 7, 9, 11, 13, 15];',
  '    let target = 9;',
  '    match binary_search(&nums, target) {',
  '        Some(i) => println!("Found {target} at index {i}"),',
  '        None => println!("{target} not found"),',
  '    }',
  '}',
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
  console.log('Recording: Code Playground — binary search, Go vs Rust, run all...');
  const { browser, context, page, outputDir } = await H.launchRecorder(
    'code-playground-go-rust', { width: 1280, height: 720 }
  );

  try {
    const url = `${H.BASE_URL}/code-playground/?panes=go,rust`;
    console.log('[1] Open playground:', url);
    await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 30000 });

    const [left, right] = await getPaneFrames(page);
    console.log('[2] Waiting for both editors...');
    await waitEditorReady(left);
    await waitEditorReady(right);
    await H.pause(page);

    console.log('[3] Writing Go binary search (left)...');
    await revealCode(page, left, GO);
    await H.beat(page);

    console.log('[4] Writing Rust binary search (right)...');
    await revealCode(page, right, RUST);
    await H.pause(page);

    console.log('[5] Run all...');
    await H.hoverElement(page, '#runAllBtn');
    await page.click('#runAllBtn');

    console.log('[6] Waiting for both outcomes (Go + Rust compile)...');
    await Promise.all([waitForOutput(left), waitForOutput(right)]);
    console.log('[7] Both panes produced output — holding, then stop.');
    await H.longPause(page);
    await H.extraPause(page);

    console.log('Done!');
  } catch (err) {
    console.error('Recording error:', err.message);
    console.error(err.stack);
  }

  await H.finishRecording(browser, context, page, outputDir, 'code-playground-go-rust');
})();
