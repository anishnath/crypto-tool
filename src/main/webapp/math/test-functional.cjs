/**
 * Phase 3 Math Editor — Functional (headless DOM) Tests
 * Run: node test-functional.cjs
 *
 * Uses jsdom to simulate a real browser DOM environment and tests
 * that the JS modules actually execute and produce correct DOM output.
 */

const fs = require('fs');
const path = require('path');
const { JSDOM } = require('jsdom');

const BASE = __dirname;
const JS = path.join(BASE, 'assets', 'js');
const CSS = path.join(BASE, 'assets', 'css');

function readFile(f) { return fs.readFileSync(f, 'utf8'); }

let pass = 0, fail = 0, errors = [];

function assert(condition, label) {
    if (condition) {
        console.log(`  ✓ ${label}`);
        pass++;
    } else {
        console.log(`  ✗ FAIL: ${label}`);
        fail++;
        errors.push(label);
    }
}

// =========================================================
//  BUILD A MINIMAL editor.jsp DOM IN JSDOM
// =========================================================

const html = `<!DOCTYPE html>
<html><head><style>
/* Inline a few CSS vars so JS doesn't break */
:root {
    --me-background: #f5f5f5; --me-surface: #fff; --me-border: #ddd;
    --me-primary: #2563eb; --me-text-primary: #111; --me-text-muted: #888;
    --me-math-bg: #EFF6FF; --me-transition: 0.15s ease;
}
</style></head>
<body>
<div class="me-editor-page">
  <div class="me-editor-topbar">
    <input class="me-doc-title-input" value="Test Document">
    <span class="me-save-status"><span class="me-save-dot"></span> Saved</span>
  </div>
  <div class="me-toolbar">
    <button class="me-toolbar-btn" title="Bold"><b>B</b></button>
    <button class="me-toolbar-btn" title="Italic"><i>I</i></button>
    <button class="me-toolbar-btn-math" title="Insert Display Math">∑</button>
    <button class="me-toolbar-btn-math" title="Insert Inline Math">√</button>
    <button class="me-toolbar-btn" title="Insert Code Block">&lt;/&gt;</button>
    <button class="me-toolbar-btn" title="Insert Table">⊞</button>
    <button class="me-btn-export">Export</button>
    <div class="me-export-menu" style="display:none;">
      <button data-format="markdown">Markdown</button>
    </div>
  </div>
  <div class="me-canvas-wrapper">
    <div class="me-canvas" contenteditable="true">
      <p>Hello world</p>
    </div>
  </div>
  <div class="me-statusbar">
    <span id="stat-words">0</span> words
    <span id="stat-chars">0</span> chars
    <span id="stat-math">0</span> math
    <button id="zoom-out">-</button>
    <span id="zoom-label">100%</span>
    <button id="zoom-in">+</button>
  </div>
  <div class="me-side-panel">
    <button class="me-panel-tab">Outline</button>
    <button class="me-panel-tab">Comments</button>
    <button class="me-panel-tab">History</button>
    <div class="me-outline-tab"><div class="me-outline-tree"></div></div>
    <div class="me-comments-tab" style="display:none;"></div>
    <div class="me-history-tab" style="display:none;"></div>
  </div>
</div>
</body></html>`;

// =========================================================
//  CREATE JSDOM WITH SCRIPT EXECUTION
// =========================================================

// We need a custom class since jsdom doesn't support web components natively.
// We'll stub math-field as a regular element.

const dom = new JSDOM(html, {
    url: 'http://localhost:8080/math/editor.jsp?id=test123',
    pretendToBeVisual: true,
    runScripts: 'dangerously',
    resources: 'usable',
    beforeParse(window) {
        // Stub MathfieldElement so init() proceeds
        window.MathfieldElement = function() {};
        window.MathfieldElement.fontsDirectory = '';
        window.MathfieldElement.soundsDirectory = null;

        // Stub Range.getBoundingClientRect (not in jsdom)
        if (!window.Range.prototype.getBoundingClientRect) {
            window.Range.prototype.getBoundingClientRect = function() {
                return { top: 100, bottom: 120, left: 50, right: 150, width: 100, height: 20 };
            };
        }

        // Stub Element.scrollIntoView
        window.Element.prototype.scrollIntoView = function() {};

        // Stub execCommand
        window.document.execCommand = function(cmd, ui, val) {
            // Minimal stub: track what was called
            if (!window._execCommands) window._execCommands = [];
            window._execCommands.push({ cmd, val });
            return true;
        };

        // Stub math-field element behavior
        const origCreateElement = window.document.createElement.bind(window.document);
        window.document.createElement = function(tag) {
            var el = origCreateElement(tag);
            if (tag === 'math-field') {
                // Add .value property
                var _val = '';
                Object.defineProperty(el, 'value', {
                    get: function() { return _val; },
                    set: function(v) { _val = v; el.textContent = v; }
                });
                el.insert = function(latex) { _val += latex; el.textContent = _val; };
                el.focus = function() {};
            }
            return el;
        };
    }
});

const { window } = dom;
const { document } = window;

// =========================================================
//  LOAD JS MODULES IN ORDER
// =========================================================

function execScript(file) {
    const code = readFile(file);
    try {
        window.eval(code);
        return true;
    } catch (e) {
        console.error(`  ERROR loading ${path.basename(file)}: ${e.message}`);
        return false;
    }
}

console.log('\n=== Phase 3 Math Editor — Functional Tests ===\n');

// --- Load scripts ---
console.log('0. Script loading');
assert(execScript(path.join(JS, 'editor-core.js')), 'editor-core.js loads without error');
assert(execScript(path.join(JS, 'toolbar.js')), 'toolbar.js loads without error');
assert(execScript(path.join(JS, 'mathlive-init.js')), 'mathlive-init.js loads without error');
assert(execScript(path.join(JS, 'autosave.js')), 'autosave.js loads without error');
assert(execScript(path.join(JS, 'slash-menu.js')), 'slash-menu.js loads without error');

// ======================================================
// 1. Global API objects exist
// ======================================================
console.log('\n1. Global APIs are live objects');
assert(typeof window.MeEditorCore === 'object', 'MeEditorCore is an object');
assert(typeof window.MeStats === 'object', 'MeStats is an object');
assert(typeof window.MeToolbar === 'object', 'MeToolbar is an object');
assert(typeof window.MeMath === 'object', 'MeMath is an object');
assert(typeof window.MeAutosave === 'object', 'MeAutosave is an object');
assert(typeof window.MeSlashMenu === 'object', 'MeSlashMenu is an object');

// ======================================================
// 2. MeEditorCore.getDocId reads URL param
// ======================================================
console.log('\n2. getDocId');
assert(window.MeEditorCore.getDocId() === 'test123', 'getDocId returns "test123" from URL');

// ======================================================
// 3. Stats update
// ======================================================
console.log('\n3. Stats update');
{
    var canvas = document.querySelector('.me-canvas');
    canvas.innerHTML = '<p>Hello world of math</p>';

    // jsdom doesn't support .innerText (returns undefined), so word/char stats
    // will be 0 in this environment. We test only that update() runs and math count works.
    // Word/char counting is verified by static analysis in test-phase3.cjs.
    window.MeStats.update();
    var wordsEl = document.getElementById('stat-words');
    var charsEl = document.getElementById('stat-chars');
    var mathEl = document.getElementById('stat-math');
    assert(wordsEl !== null, 'stat-words element exists');
    assert(charsEl !== null, 'stat-chars element exists');
    assert(mathEl.textContent === '0', `stat-math shows "0" (got "${mathEl.textContent}")`);
    // Note: word/char counts are 0 in jsdom because innerText is unsupported — not a bug
    console.log('  (word/char count skipped: jsdom lacks innerText support)');
}

// ======================================================
// 4. createBlockMath produces correct DOM
// ======================================================
console.log('\n4. createBlockMath');
{
    var blockNode = window.MeMath.createBlockMath('x^2 + y^2 = r^2');
    assert(blockNode.tagName === 'DIV', 'Block math is a <div>');
    assert(blockNode.classList.contains('me-math-node'), 'Has me-math-node class');
    assert(blockNode.classList.contains('me-math-display'), 'Has me-math-display class');
    assert(blockNode.getAttribute('contenteditable') === 'false', 'contenteditable=false');
    assert(blockNode.getAttribute('data-latex') === 'x^2 + y^2 = r^2', 'data-latex stores the LaTeX');
    assert(blockNode.getAttribute('data-display') === 'yes', 'data-display=yes');
    var mf = blockNode.querySelector('math-field');
    assert(mf !== null, 'Contains a <math-field> element');
    assert(mf.hasAttribute('readonly'), 'math-field is readonly');
    assert(mf.classList.contains('me-mathfield-rendered'), 'Has me-mathfield-rendered class');
    assert(mf.value === 'x^2 + y^2 = r^2', 'math-field value matches LaTeX');
}

// ======================================================
// 5. createInlineMath produces correct DOM
// ======================================================
console.log('\n5. createInlineMath');
{
    var inlineNode = window.MeMath.createInlineMath('\\alpha + \\beta');
    assert(inlineNode.tagName === 'SPAN', 'Inline math is a <span>');
    assert(inlineNode.classList.contains('me-math-node'), 'Has me-math-node class');
    assert(inlineNode.classList.contains('me-math-inline'), 'Has me-math-inline class');
    assert(inlineNode.getAttribute('contenteditable') === 'false', 'contenteditable=false');
    assert(inlineNode.getAttribute('data-latex') === '\\alpha + \\beta', 'data-latex stores LaTeX');
    assert(inlineNode.getAttribute('data-display') === 'no', 'data-display=no');
    var mf2 = inlineNode.querySelector('math-field');
    assert(mf2 !== null, 'Contains a <math-field>');
    assert(mf2.hasAttribute('readonly'), 'math-field is readonly');
}

// ======================================================
// 6. Insert block math into canvas and verify stats
// ======================================================
console.log('\n6. Block math insertion + stats');
{
    var canvas = document.querySelector('.me-canvas');
    canvas.innerHTML = '<p>Before math</p>';
    var blockNode = window.MeMath.createBlockMath('E = mc^2');
    canvas.appendChild(blockNode);
    var pAfter = document.createElement('p');
    pAfter.innerHTML = 'After math';
    canvas.appendChild(pAfter);

    window.MeStats.update();
    var mathEl = document.getElementById('stat-math');
    assert(mathEl.textContent === '1', `stat-math shows "1" after block insert (got "${mathEl.textContent}")`);
}

// ======================================================
// 7. Insert inline math into a paragraph
// ======================================================
console.log('\n7. Inline math in paragraph');
{
    var canvas = document.querySelector('.me-canvas');
    canvas.innerHTML = '<p>The value of pi is </p>';
    var p = canvas.querySelector('p');
    var inlineNode = window.MeMath.createInlineMath('\\pi \\approx 3.14');
    p.appendChild(inlineNode);
    p.appendChild(document.createTextNode(' approximately.'));

    window.MeStats.update();
    var mathEl = document.getElementById('stat-math');
    assert(mathEl.textContent === '1', `stat-math counts 1 inline math (got "${mathEl.textContent}")`);

    // Verify the inline node is actually inside the paragraph
    assert(p.querySelector('.me-math-inline') !== null, 'Inline math is inside the <p>');
}

// ======================================================
// 8. Outline updates from headings
// ======================================================
console.log('\n8. Outline panel');
{
    var canvas = document.querySelector('.me-canvas');
    canvas.innerHTML = '<h1>Chapter 1</h1><p>Some text</p><h2>Section 1.1</h2><h3>Sub</h3>';
    window.MeEditorCore.updateOutline();
    var tree = document.querySelector('.me-outline-tree');
    var items = tree.querySelectorAll('.me-outline-item');
    assert(items.length === 3, `Outline has 3 items (got ${items.length})`);
    assert(items[0].classList.contains('level-1'), 'First item is level-1');
    assert(items[0].textContent === 'Chapter 1', 'First item text matches H1');
    assert(items[1].classList.contains('level-2'), 'Second item is level-2');
    assert(items[2].classList.contains('level-3'), 'Third item is level-3');
}

// ======================================================
// 9. Autosave save/load round-trip
// ======================================================
console.log('\n9. Autosave round-trip');
{
    var canvas = document.querySelector('.me-canvas');
    var titleInput = document.querySelector('.me-doc-title-input');
    titleInput.value = 'My Math Document';
    canvas.innerHTML = '<p>Saved content</p>';

    // Save
    window.MeAutosave.save();
    var key = 'matheditor_doc_test123';
    var raw = window.localStorage.getItem(key);
    assert(raw !== null, 'localStorage has saved data');

    var data = JSON.parse(raw);
    assert(data.title === 'My Math Document', `Saved title matches (got "${data.title}")`);
    assert(data.content.includes('Saved content'), 'Saved content includes text');
    assert(data.savedAt !== undefined, 'Saved timestamp exists');

    // Modify and then load
    canvas.innerHTML = '<p>Modified</p>';
    titleInput.value = 'Changed';
    window.MeAutosave.load();
    assert(titleInput.value === 'My Math Document', 'Title restored after load');
    assert(canvas.innerHTML.includes('Saved content'), 'Canvas content restored after load');
}

// ======================================================
// 10. Autosave reinitMathBlocks re-attaches click handlers
// ======================================================
console.log('\n10. reinitMathBlocks');
{
    var canvas = document.querySelector('.me-canvas');
    // Simulate saved HTML with a math node (as it would be in localStorage)
    canvas.innerHTML = '<p>Text</p>' +
        '<div class="me-math-node me-math-display" contenteditable="false" ' +
        'data-latex="x^2" data-display="yes">' +
        '<math-field class="me-mathfield-rendered" readonly>x^2</math-field></div>' +
        '<p>More text</p>';

    window.MeAutosave.reinitMathBlocks();

    var nodes = canvas.querySelectorAll('.me-math-node');
    assert(nodes.length === 1, `Found 1 math node after reinit (got ${nodes.length})`);

    // The node should have a click listener (we can't directly check, but verify it wasn't removed)
    assert(nodes[0].getAttribute('data-latex') === 'x^2', 'Math node data-latex preserved');
    assert(nodes[0].getAttribute('data-display') === 'yes', 'Math node data-display preserved');
}

// ======================================================
// 11. Slash menu open/close/toggle
// ======================================================
console.log('\n11. Slash menu');
{
    assert(typeof window.MeSlashMenu.toggle === 'function', 'MeSlashMenu.toggle is a function');
    assert(typeof window.MeSlashMenu.close === 'function', 'MeSlashMenu.close is a function');
    assert(typeof window.MeSlashMenu.isOpen === 'function', 'MeSlashMenu.isOpen is a function');
    assert(window.MeSlashMenu.isOpen() === false, 'Slash menu starts closed');

    // The menu DOM element should exist
    var slashMenu = document.querySelector('.me-slash-menu');
    assert(slashMenu !== null, 'Slash menu element exists in DOM');
    var items = slashMenu.querySelectorAll('.me-slash-item');
    assert(items.length === 12, `Slash menu has 12 items (got ${items.length})`);
}

// ======================================================
// 12. MeMath API methods are callable
// ======================================================
console.log('\n12. MeMath API callable');
{
    assert(typeof window.MeMath.openDialog === 'function', 'openDialog is a function');
    assert(typeof window.MeMath.insertBlock === 'function', 'insertBlock is a function');
    assert(typeof window.MeMath.insertInline === 'function', 'insertInline is a function');
    assert(typeof window.MeMath.editBlock === 'function', 'editBlock is a function');
    assert(typeof window.MeMath.editInline === 'function', 'editInline is a function');
    assert(typeof window.MeMath.createBlockMath === 'function', 'createBlockMath is a function');
    assert(typeof window.MeMath.createInlineMath === 'function', 'createInlineMath is a function');
}

// ======================================================
// 13. Dialog builds on first open
// ======================================================
console.log('\n13. Dialog builds on demand');
{
    // Before opening, dialog shouldn't exist
    var overlayBefore = document.querySelector('.me-math-dialog-overlay');
    // It may or may not exist depending on if other tests triggered it
    // Call openDialog to ensure it builds
    window.MeMath.openDialog('\\frac{1}{2}', 'yes', null);

    var overlay = document.querySelector('.me-math-dialog-overlay');
    assert(overlay !== null, 'Dialog overlay created after openDialog');
    var dlg = document.querySelector('.me-math-dialog');
    assert(dlg !== null, 'Dialog container created');
    var tabs = dlg.querySelectorAll('.me-math-tab');
    assert(tabs.length === 10, `Dialog has 10 tabs (got ${tabs.length})`);
    var grid = document.getElementById('me-symbol-grid');
    assert(grid !== null, 'Symbol grid container exists');
    assert(grid.children.length > 0, 'Symbol grid has buttons');
    var field = dlg.querySelector('.me-math-dialog-field');
    assert(field !== null, 'MathLive input field exists');

    // Close it
    var closeBtn = dlg.querySelector('.me-math-dialog-close');
    assert(closeBtn !== null, 'Close button exists');

    // Clean up: hide overlay
    overlay.style.display = 'none';
}

// ======================================================
// 14. Multiple math nodes + correct count
// ======================================================
console.log('\n14. Multiple math nodes');
{
    var canvas = document.querySelector('.me-canvas');
    canvas.innerHTML = '<p>Equation 1:</p>';

    var b1 = window.MeMath.createBlockMath('a^2 + b^2 = c^2');
    canvas.appendChild(b1);

    var p2 = document.createElement('p');
    p2.textContent = 'Then inline ';
    var i1 = window.MeMath.createInlineMath('\\pi');
    p2.appendChild(i1);
    p2.appendChild(document.createTextNode(' and '));
    var i2 = window.MeMath.createInlineMath('e');
    p2.appendChild(i2);
    canvas.appendChild(p2);

    var b2 = window.MeMath.createBlockMath('\\int_0^1 x\\,dx = \\frac{1}{2}');
    canvas.appendChild(b2);

    window.MeStats.update();
    var mathEl = document.getElementById('stat-math');
    // 2 block + 2 inline = 4
    assert(mathEl.textContent === '4', `stat-math shows "4" for 4 math nodes (got "${mathEl.textContent}")`);
}

// ======================================================
// 15. Zoom label updates
// ======================================================
console.log('\n15. Zoom');
{
    var zoomLabel = document.getElementById('zoom-label');
    var initialZoom = zoomLabel.textContent;
    assert(initialZoom === '100%', `Initial zoom is 100% (got "${initialZoom}")`);
}

// ======================================================
// 16. Export dropdown toggle
// ======================================================
console.log('\n16. Export dropdown');
{
    var exportBtn = document.querySelector('.me-btn-export');
    var exportMenu = document.querySelector('.me-export-menu');
    assert(exportBtn !== null, 'Export button exists');
    assert(exportMenu !== null, 'Export menu exists');

    // Click to toggle
    exportBtn.click();
    assert(exportMenu.classList.contains('show'), 'Export menu opens on click');

    // Click document to close
    document.body.click();
    assert(!exportMenu.classList.contains('show'), 'Export menu closes on outside click');
}

// ======================================================
// 17. Dialog INSERT flow — block math
// ======================================================
console.log('\n17. Dialog insert flow — block math');
{
    var canvas = document.querySelector('.me-canvas');
    canvas.innerHTML = '<p>Before insert</p>';
    var countBefore = canvas.querySelectorAll('.me-math-node').length;
    assert(countBefore === 0, 'Canvas starts with 0 math nodes');

    // Open dialog for block math
    window.MeMath.openDialog('', 'yes', null);
    var overlay = document.querySelector('.me-math-dialog-overlay');
    assert(overlay.style.display !== 'none', 'Dialog is visible after openDialog');

    // Simulate typing into the math-field
    var field = document.querySelector('.me-math-dialog-field');
    assert(field !== null, 'Dialog math-field exists');
    field.value = 'x^2 + 1';

    // Click insert button
    var insertBtn = document.querySelector('.me-math-dialog-insert');
    assert(insertBtn !== null, 'Insert button exists');
    insertBtn.click();

    // Verify: dialog closed, math node appeared in canvas
    assert(overlay.style.display === 'none', 'Dialog closes after insert');
    var mathNodes = canvas.querySelectorAll('.me-math-node.me-math-display');
    assert(mathNodes.length === 1, `1 block math node in canvas (got ${mathNodes.length})`);
    assert(mathNodes[0].getAttribute('data-latex') === 'x^2 + 1', 'Inserted node has correct LaTeX');

    // Paragraph added after block for continued typing
    var pAfter = mathNodes[0].nextElementSibling;
    assert(pAfter !== null && pAfter.tagName === 'P', 'Paragraph added after block math');
}

// ======================================================
// 18. Dialog INSERT flow — inline math (fallback path)
// ======================================================
console.log('\n18. Dialog insert flow — inline math');
{
    var canvas = document.querySelector('.me-canvas');
    canvas.innerHTML = '<p>The value is </p>';

    // Open dialog for inline math
    window.MeMath.openDialog('', 'no', null);
    var field = document.querySelector('.me-math-dialog-field');
    field.value = '\\pi';

    // Insert — no cursor in canvas so hits fallback path (append to last <p>)
    var insertBtn = document.querySelector('.me-math-dialog-insert');
    insertBtn.click();

    var inlineNodes = canvas.querySelectorAll('.me-math-node.me-math-inline');
    assert(inlineNodes.length === 1, `1 inline math node in canvas (got ${inlineNodes.length})`);
    assert(inlineNodes[0].getAttribute('data-latex') === '\\pi', 'Inline node has correct LaTeX');

    // In jsdom without a real selection, the fallback appends to the last <p> OR canvas
    // Either location is valid — just check it exists somewhere in canvas
    assert(canvas.querySelector('.me-math-inline') !== null, 'Inline math exists in canvas');
}

// ======================================================
// 19. Dialog EDIT flow — update existing node
// ======================================================
console.log('\n19. Dialog edit flow — update existing');
{
    var canvas = document.querySelector('.me-canvas');
    canvas.innerHTML = '<p>Text</p>';
    var existingNode = window.MeMath.createBlockMath('a + b');
    canvas.appendChild(existingNode);
    canvas.appendChild(document.createElement('p')).innerHTML = '<br>';

    assert(existingNode.getAttribute('data-latex') === 'a + b', 'Original LaTeX is a + b');

    // Open dialog to edit the existing node
    window.MeMath.openDialog('a + b', 'yes', existingNode);

    // The button text update happens inside requestAnimationFrame, which jsdom
    // doesn't fire synchronously. We verify the edit flow works regardless.
    var field = document.querySelector('.me-math-dialog-field');
    // Change the LaTeX
    field.value = 'a + b + c';

    var insertBtn = document.querySelector('.me-math-dialog-insert');
    // Note: button text "Update Equation" is set in rAF — may still say "Insert" in jsdom
    assert(insertBtn !== null, 'Insert/Update button exists');

    insertBtn.click();

    // The OLD node should be replaced, not a new one added
    var allMath = canvas.querySelectorAll('.me-math-node');
    assert(allMath.length === 1, `Still 1 math node after edit (got ${allMath.length})`);
    assert(allMath[0].getAttribute('data-latex') === 'a + b + c', 'LaTeX updated to "a + b + c"');
}

// ======================================================
// 20. Dialog CANCEL — empty insert does nothing
// ======================================================
console.log('\n20. Dialog cancel / empty insert');
{
    var canvas = document.querySelector('.me-canvas');
    canvas.innerHTML = '<p>No math here</p>';

    window.MeMath.openDialog('', 'yes', null);
    var field = document.querySelector('.me-math-dialog-field');
    field.value = ''; // empty

    var insertBtn = document.querySelector('.me-math-dialog-insert');
    insertBtn.click();

    var mathNodes = canvas.querySelectorAll('.me-math-node');
    assert(mathNodes.length === 0, 'No math node inserted when LaTeX is empty');
}

// ======================================================
// 21. $ trigger opens dialog (dialog-based approach)
// ======================================================
console.log('\n21. $ trigger → dialog');
{
    // The $ key now opens the dialog instead of spawning a live editor.
    // We verify that openDialog can be called for both block and inline modes
    // and that the dialog is reusable across calls.

    window.MeMath.openDialog('', 'yes', null);
    var overlay = document.querySelector('.me-math-dialog-overlay');
    assert(overlay.style.display !== 'none', 'Dialog opens for block mode via $');
    overlay.style.display = 'none'; // close

    window.MeMath.openDialog('', 'no', null);
    assert(overlay.style.display !== 'none', 'Dialog opens for inline mode via $');
    overlay.style.display = 'none'; // close
}

// ======================================================
// 22. Save + load round-trip with math nodes
// ======================================================
console.log('\n22. Save/load with math nodes');
{
    var canvas = document.querySelector('.me-canvas');
    canvas.innerHTML = '<p>Equation:</p>';
    var block = window.MeMath.createBlockMath('F = ma');
    canvas.appendChild(block);
    canvas.appendChild(document.createElement('p')).textContent = 'End';

    // Save
    window.MeAutosave.save();

    // Destroy canvas
    canvas.innerHTML = '<p>Wiped</p>';
    assert(canvas.querySelectorAll('.me-math-node').length === 0, 'Canvas wiped');

    // Load
    window.MeAutosave.load();
    var restored = canvas.querySelectorAll('.me-math-node');
    assert(restored.length === 1, `1 math node restored from save (got ${restored.length})`);
    assert(restored[0].getAttribute('data-latex') === 'F = ma', 'Restored LaTeX is correct');
}

// ======================================================
// 23. Stats count correctly after insert flow
// ======================================================
console.log('\n23. Stats after full insert flow');
{
    var canvas = document.querySelector('.me-canvas');
    canvas.innerHTML = '<p>Start</p>';

    // Insert 2 blocks and 1 inline via dialog
    window.MeMath.openDialog('', 'yes', null);
    document.querySelector('.me-math-dialog-field').value = 'a^2';
    document.querySelector('.me-math-dialog-insert').click();

    window.MeMath.openDialog('', 'yes', null);
    document.querySelector('.me-math-dialog-field').value = 'b^2';
    document.querySelector('.me-math-dialog-insert').click();

    window.MeMath.openDialog('', 'no', null);
    document.querySelector('.me-math-dialog-field').value = 'c';
    document.querySelector('.me-math-dialog-insert').click();

    window.MeStats.update();
    var mathEl = document.getElementById('stat-math');
    assert(mathEl.textContent === '3', `stat-math is 3 after 2 blocks + 1 inline (got "${mathEl.textContent}")`);
}

// ======================================================
// SUMMARY
// ======================================================
console.log('\n' + '='.repeat(50));
console.log(`Results: ${pass} passed, ${fail} failed out of ${pass + fail} checks`);

if (fail > 0) {
    console.log('\n⚠ FAILURES:');
    errors.forEach(function(e) { console.log('  - ' + e); });
}

console.log();
dom.window.close();
process.exit(fail > 0 ? 1 : 0);
