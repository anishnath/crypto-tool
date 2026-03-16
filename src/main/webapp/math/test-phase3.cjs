/**
 * Phase 3 Math Editor — JS Bug Audit
 * Run: node test-phase3.cjs
 *
 * This script reads all JS files and the JSP, then checks for known
 * integration / logic bugs without needing a browser.
 */

const fs = require('fs');
const path = require('path');

const BASE = path.join(__dirname);
const JS = path.join(BASE, 'assets', 'js');

function read(file) {
    return fs.readFileSync(file, 'utf8');
}

let pass = 0;
let fail = 0;

function assert(condition, label) {
    if (condition) {
        console.log(`  ✓ ${label}`);
        pass++;
    } else {
        console.log(`  ✗ FAIL: ${label}`);
        fail++;
    }
}

// ======================================================
// Load sources
// ======================================================
const editorCore   = read(path.join(JS, 'editor-core.js'));
const toolbar      = read(path.join(JS, 'toolbar.js'));
const mathlive     = read(path.join(JS, 'mathlive-init.js'));
const autosave     = read(path.join(JS, 'autosave.js'));
const slashMenu    = read(path.join(JS, 'slash-menu.js'));
const editorJsp    = read(path.join(BASE, 'editor.jsp'));

console.log('\n=== Phase 3 Math Editor — Bug Audit ===\n');

// ======================================================
// 1. Script load order in JSP
// ======================================================
console.log('1. Script load order in editor.jsp');
{
    const scripts = [];
    const re = /src="[^"]*\/js\/([^"?]+)/g;
    let m;
    while ((m = re.exec(editorJsp)) !== null) scripts.push(m[1]);
    assert(scripts.length === 5, `Found ${scripts.length} JS scripts (expected 5)`);
    const expected = ['editor-core.js', 'toolbar.js', 'mathlive-init.js', 'autosave.js', 'slash-menu.js'];
    assert(JSON.stringify(scripts) === JSON.stringify(expected),
        `Load order: ${scripts.join(' → ')} matches expected`);
}

// ======================================================
// 2. Status bar text duplication bug (stat-words/chars/math)
// ======================================================
console.log('\n2. Status bar stat text duplication');
{
    const setsWordsNumberOnly = /statWords\.textContent\s*=\s*words\s*;/.test(editorCore);
    const setsCharsNumberOnly = /statChars\.textContent\s*=\s*chars\s*;/.test(editorCore);
    const setsMathNumberOnly = /statMath\.textContent\s*=\s*mathBlocks\s*;/.test(editorCore);

    const jspHasExternalLabel = /id="stat-words">[^<]*<\/span>\s*words/.test(editorJsp);
    assert(jspHasExternalLabel, 'JSP has label text OUTSIDE the stat span');

    assert(setsWordsNumberOnly, 'stat-words: JS sets only the number (no duplicate label)');
    assert(setsCharsNumberOnly, 'stat-chars: JS sets only the number (no duplicate label)');
    assert(setsMathNumberOnly, 'stat-math: JS sets only the number (no duplicate label)');
}

// ======================================================
// 3. Math dialog approach (bablu22-style)
// ======================================================
console.log('\n3. Math Equation Dialog structure');
{
    assert(/me-math-dialog-overlay/.test(mathlive), 'Dialog overlay element created');
    assert(/me-math-dialog-header/.test(mathlive), 'Dialog has header');
    assert(/me-math-dialog-tabs/.test(mathlive), 'Dialog has tab bar');
    assert(/me-math-dialog-symbols/.test(mathlive), 'Dialog has symbol grid');
    assert(/me-math-presets/.test(mathlive), 'Dialog has preset equations');
    assert(/me-math-dialog-field/.test(mathlive), 'Dialog has MathLive input field');
    assert(/me-math-dialog-footer/.test(mathlive), 'Dialog has footer with buttons');
    assert(/me-math-dialog-insert/.test(mathlive), 'Dialog has Insert button');
    assert(/me-math-dialog-cancel/.test(mathlive), 'Dialog has Cancel button');
    assert(/me-math-dialog-close/.test(mathlive), 'Dialog has close (×) button');
}

// ======================================================
// 4. Symbol tabs and presets
// ======================================================
console.log('\n4. Symbol palette data');
{
    assert(/var TABS\s*=/.test(mathlive), 'TABS data object defined');
    assert(/basic:/.test(mathlive), 'Has basic tab');
    assert(/fractions:/.test(mathlive), 'Has fractions tab');
    assert(/powers:/.test(mathlive), 'Has powers tab');
    assert(/trig:/.test(mathlive), 'Has trig tab');
    assert(/logs:/.test(mathlive), 'Has logs tab');
    assert(/greek:/.test(mathlive), 'Has greek tab');
    assert(/calculus:/.test(mathlive), 'Has calculus tab');
    assert(/symbols:/.test(mathlive), 'Has symbols tab');
    assert(/geometry:/.test(mathlive), 'Has geometry tab');
    assert(/brackets:/.test(mathlive), 'Has brackets tab');
    assert(/var PRESETS\s*=/.test(mathlive), 'PRESETS array defined');
    assert(/General Math/.test(mathlive), 'Has General Math presets');
    assert(/Higher Math/.test(mathlive), 'Has Higher Math presets');
    assert(/Physics/.test(mathlive), 'Has Physics presets');
    assert(/Chemistry/.test(mathlive), 'Has Chemistry presets');
}

// ======================================================
// 5. Rendered math uses <math-field readonly>
// ======================================================
console.log('\n5. Rendered math nodes');
{
    assert(/me-math-node/.test(mathlive), 'Uses me-math-node class');
    assert(/me-math-inline/.test(mathlive), 'Has me-math-inline class');
    assert(/me-math-display/.test(mathlive), 'Has me-math-display class');
    assert(/me-mathfield-rendered/.test(mathlive), 'Has me-mathfield-rendered class');
    assert(/setAttribute\('readonly'/.test(mathlive), 'Sets math-field readonly attribute');
    assert(/data-latex/.test(mathlive), 'Stores latex in data-latex attribute');
    assert(/data-display/.test(mathlive), 'Stores display mode in data-display attribute');
}

// ======================================================
// 6. Dollar sign trigger → opens dialog
// ======================================================
console.log('\n6. Dollar sign trigger → dialog');
{
    assert(/lastDollarTime/.test(mathlive), 'Tracks double-$ timing for block mode');
    assert(/e\.key\s*!==\s*'\$'/.test(mathlive) || /e\.key\s*===\s*'\$'/.test(mathlive),
        '$ keydown listener exists');
    assert(/openDialog\('',\s*'yes'/.test(mathlive), '$$ opens block dialog');
    assert(/openDialog\('',\s*'no'/.test(mathlive), '$ opens inline dialog');
    // math-field CANNOT be a child of contenteditable — dialog is the correct approach
    assert(!/spawnLiveEditor/.test(mathlive), 'No spawnLiveEditor (broken pattern removed)');
}

// ======================================================
// 7. Click-to-edit existing math
// ======================================================
console.log('\n7. Click-to-edit');
{
    assert(/addEventListener\('click'/.test(mathlive) && /openDialog/.test(mathlive),
        'Click on math node opens dialog');
    assert(/editingNode/.test(mathlive), 'Tracks editingNode for update vs insert');
    assert(/replaceChild/.test(mathlive), 'replaceChild used to update existing node');
    assert(/Update Equation/.test(mathlive), 'Button text changes to "Update Equation" when editing');
}

// ======================================================
// 8. Slash menu filtering
// ======================================================
console.log('\n8. Slash menu filtering');
{
    const hasInputListener = /addEventListener\s*\(\s*['"]input['"]/.test(slashMenu);
    const hasFilterLogic = /indexOf|label.*toLowerCase|filter.*label/i.test(slashMenu);
    assert(hasInputListener, 'Slash menu has input listener for filtering');
    assert(hasFilterLogic, 'Slash menu has filter logic to match typed text against labels');
}

// ======================================================
// 9. Exposed APIs — all modules expose expected globals
// ======================================================
console.log('\n9. Global API exposure');
{
    assert(/window\.MeEditorCore\s*=/.test(editorCore), 'editor-core.js exposes MeEditorCore');
    assert(/window\.MeStats\s*=/.test(editorCore), 'editor-core.js exposes MeStats');
    assert(/window\.MeToolbar\s*=/.test(toolbar), 'toolbar.js exposes MeToolbar');
    assert(/window\.MeMath\s*=/.test(mathlive), 'mathlive-init.js exposes MeMath');
    assert(/window\.MeAutosave\s*=/.test(autosave), 'autosave.js exposes MeAutosave');
    assert(/window\.MeSlashMenu\s*=/.test(slashMenu), 'slash-menu.js exposes MeSlashMenu');
}

// ======================================================
// 10. MeMath API methods
// ======================================================
console.log('\n10. MeMath API completeness');
{
    assert(/openDialog/.test(mathlive), 'MeMath has openDialog');
    assert(/insertBlock:/.test(mathlive), 'MeMath has insertBlock');
    assert(/insertInline:/.test(mathlive), 'MeMath has insertInline');
    assert(/editBlock:/.test(mathlive), 'MeMath has editBlock');
    assert(/editInline:/.test(mathlive), 'MeMath has editInline');
    assert(/createBlockMath/.test(mathlive), 'MeMath has createBlockMath');
    assert(/createInlineMath/.test(mathlive), 'MeMath has createInlineMath');
}

// ======================================================
// 11. Cross-module references
// ======================================================
console.log('\n11. Cross-module references');
{
    // editor-core references
    assert(/MeToolbar\.sync/.test(editorCore), 'editor-core → MeToolbar.sync()');
    assert(/MeMath\.insertBlock/.test(editorCore), 'editor-core → MeMath.insertBlock()');
    assert(/MeMath\.insertInline/.test(editorCore), 'editor-core → MeMath.insertInline()');
    assert(/MeAutosave\.save/.test(editorCore), 'editor-core → MeAutosave.save()');
    assert(/MeSlashMenu\.(toggle|close)/.test(editorCore), 'editor-core → MeSlashMenu');

    // mathlive-init references
    assert(/MeStats\.update/.test(mathlive), 'mathlive-init → MeStats.update()');
    assert(/MeEditorCore\.updateOutline/.test(mathlive), 'mathlive-init → MeEditorCore.updateOutline()');

    // toolbar references
    assert(/MeEditorCore\.updateOutline/.test(toolbar), 'toolbar → MeEditorCore.updateOutline()');

    // autosave references
    assert(/MeMath\.editBlock/.test(autosave), 'autosave → MeMath.editBlock()');
    assert(/MeMath\.editInline/.test(autosave), 'autosave → MeMath.editInline()');
    assert(/MeStats\.update/.test(autosave), 'autosave → MeStats.update()');
    assert(/MeEditorCore\.(updateOutline|getDocId)/.test(autosave), 'autosave → MeEditorCore');

    // slash-menu references
    assert(/MeMath\.insertBlock/.test(slashMenu), 'slash-menu → MeMath.insertBlock()');
    assert(/MeMath\.insertInline/.test(slashMenu), 'slash-menu → MeMath.insertInline()');
    assert(/MeToolbar\.sync/.test(slashMenu), 'slash-menu → MeToolbar.sync()');
    assert(/MeToolbar\.insertCodeBlock/.test(slashMenu), 'slash-menu → MeToolbar.insertCodeBlock()');
    assert(/MeToolbar\.insertTable/.test(slashMenu), 'slash-menu → MeToolbar.insertTable()');
}

// ======================================================
// 12. DOM selector consistency (JSP ↔ JS)
// ======================================================
console.log('\n12. DOM selector consistency');
{
    // Canvas
    assert(/class="me-canvas"/.test(editorJsp), 'JSP has .me-canvas');
    assert(/\.me-canvas/.test(editorCore), 'JS queries .me-canvas');

    // Title input
    assert(/class="me-doc-title-input"/.test(editorJsp), 'JSP has .me-doc-title-input');
    assert(/\.me-doc-title-input/.test(editorCore), 'JS queries .me-doc-title-input');

    // Save status
    assert(/class="me-save-dot"/.test(editorJsp), 'JSP has .me-save-dot');
    assert(/class="me-save-status"/.test(editorJsp), 'JSP has .me-save-status');

    // Stat elements
    assert(/id="stat-words"/.test(editorJsp), 'JSP has #stat-words');
    assert(/id="stat-chars"/.test(editorJsp), 'JSP has #stat-chars');
    assert(/id="stat-math"/.test(editorJsp), 'JSP has #stat-math');
    assert(/getElementById\('stat-words'\)/.test(editorCore), 'JS gets #stat-words');
    assert(/getElementById\('stat-chars'\)/.test(editorCore), 'JS gets #stat-chars');
    assert(/getElementById\('stat-math'\)/.test(editorCore), 'JS gets #stat-math');

    // Zoom
    assert(/id="zoom-in"/.test(editorJsp), 'JSP has #zoom-in');
    assert(/id="zoom-out"/.test(editorJsp), 'JSP has #zoom-out');
    assert(/id="zoom-label"/.test(editorJsp), 'JSP has #zoom-label');

    // Panel tabs
    assert(/class="me-outline-tab"/.test(editorJsp), 'JSP has .me-outline-tab');
    assert(/class="me-comments-tab"/.test(editorJsp), 'JSP has .me-comments-tab');
    assert(/class="me-history-tab"/.test(editorJsp), 'JSP has .me-history-tab');
    assert(/\.me-outline-tab/.test(editorCore), 'JS queries .me-outline-tab');
    assert(/\.me-comments-tab/.test(editorCore), 'JS queries .me-comments-tab');
    assert(/\.me-history-tab/.test(editorCore), 'JS queries .me-history-tab');

    // Toolbar buttons
    assert(/title="Bold"/.test(editorJsp), 'JSP has Bold button');
    assert(/title="Insert Display Math"/.test(editorJsp), 'JSP has Insert Display Math button');
    assert(/title="Insert Inline Math"/.test(editorJsp), 'JSP has Insert Inline Math button');
    assert(/title="Insert Code Block"/.test(editorJsp), 'JSP has Insert Code Block button');
    assert(/title="Insert Table"/.test(editorJsp), 'JSP has Insert Table button');

    // Export dropdown
    assert(/class="me-btn-export"/.test(editorJsp), 'JSP has .me-btn-export');
    assert(/class="me-export-menu"/.test(editorJsp), 'JSP has .me-export-menu');
    assert(/\.me-btn-export/.test(editorCore), 'JS queries .me-btn-export');
    assert(/\.me-export-menu/.test(editorCore), 'JS queries .me-export-menu');
}

// ======================================================
// 13. Export menu CSS class toggle
// ======================================================
console.log('\n13. Export dropdown CSS');
{
    const editorCss = read(path.join(BASE, 'assets', 'css', 'editor.css'));
    const hasShowClass = /\.me-export-menu\.show/.test(editorCss);
    assert(hasShowClass, 'CSS has .me-export-menu.show rule for dropdown visibility');
}

// ======================================================
// 14. CDN dependencies in JSP
// ======================================================
console.log('\n14. CDN dependencies');
{
    assert(/katex\.min\.css/.test(editorJsp), 'KaTeX CSS loaded');
    assert(/katex\.min\.js/.test(editorJsp), 'KaTeX JS loaded');
    assert(/mathlive\.min\.js/.test(editorJsp), 'MathLive JS loaded');
    const katexJsPos = editorJsp.indexOf('katex.min.js');
    const mathliveInitPos = editorJsp.indexOf('mathlive-init.js');
    assert(katexJsPos < mathliveInitPos, 'KaTeX JS loaded before mathlive-init.js');
}

// ======================================================
// 15. Autosave storage key and reinit
// ======================================================
console.log('\n15. Autosave storage key & reinit');
{
    assert(/STORAGE_KEY\s*=\s*'matheditor_doc_'\s*\+\s*getDocId/.test(autosave), 'Autosave uses getDocId for storage key');
    assert(/MeEditorCore.*getDocId/.test(autosave), 'Autosave getDocId checks MeEditorCore first');
    // New: reinitMathBlocks handles .me-math-node (not old .me-rendered-math)
    assert(/\.me-math-node/.test(autosave), 'reinitMathBlocks uses .me-math-node selector');
    assert(/data-latex/.test(autosave), 'reinitMathBlocks reads data-latex attribute');
    assert(/data-display/.test(autosave), 'reinitMathBlocks reads data-display attribute');
}

// ======================================================
// 16. Dialog CSS exists
// ======================================================
console.log('\n16. Dialog CSS');
{
    const editorCss = read(path.join(BASE, 'assets', 'css', 'editor.css'));
    assert(/\.me-math-dialog-overlay/.test(editorCss), 'CSS has dialog overlay styles');
    assert(/\.me-math-dialog\b/.test(editorCss), 'CSS has dialog container styles');
    assert(/\.me-math-dialog-tabs/.test(editorCss), 'CSS has dialog tabs styles');
    assert(/\.me-math-symbol-btn/.test(editorCss), 'CSS has symbol button styles');
    assert(/\.me-math-dialog-field/.test(editorCss), 'CSS has MathLive field styles');
    assert(/\.me-math-dialog-insert/.test(editorCss), 'CSS has insert button styles');
    assert(/\.me-math-node/.test(editorCss), 'CSS has rendered math node styles');
    assert(/\.me-math-inline/.test(editorCss), 'CSS has inline math styles');
    assert(/\.me-math-display/.test(editorCss), 'CSS has display math styles');
    assert(/\.me-mathfield-rendered/.test(editorCss), 'CSS has rendered mathfield styles');
}

// ======================================================
// SUMMARY
// ======================================================
console.log('\n' + '='.repeat(50));
console.log(`Results: ${pass} passed, ${fail} failed out of ${pass + fail} checks`);

if (fail > 0) {
    console.log('\n⚠ FAILURES DETECTED — see above');
}

console.log();
process.exit(fail > 0 ? 1 : 0);
