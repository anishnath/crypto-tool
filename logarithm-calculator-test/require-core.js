/**
 * Loads the inline IIFE from logarithm-calculator.jsp into a sandbox that
 * mimics the bits of `window` and `document` it needs at parse time.
 *
 * Strategy:
 *   1. Read the JSP, extract the SECOND <script> ... </script> block (the
 *      legacy IIFE — the first one is the Python template).
 *   2. Strip JSP scriptlets like <%=request.getContextPath()%> by replacing
 *      them with a stub string.
 *   3. Set `window._LC_TEST_HOOK = true` and run the IIFE in a vm context
 *      that has minimal DOM stubs.  The IIFE will export pure helpers
 *      under `window.LogarithmCalculator.__test`.
 *
 * Returns the populated `window` so tests can grab handles.
 */
const path = require('path');
const fs = require('fs');
const vm = require('vm');

const JSP_PATH = path.resolve(__dirname,
    '../src/main/webapp/logarithm-calculator.jsp');

function loadCore() {
    const jsp = fs.readFileSync(JSP_PATH, 'utf-8');

    // Find the SECOND <script>...</script> block (skipping the first which
    // is the Python template marked with type="text/x-python").  We want
    // the un-typed <script> that wraps the legacy IIFE.
    const re = /<script(?:\s+type="[^"]*")?[^>]*>([\s\S]*?)<\/script>/g;
    const scripts = [];
    let m;
    while ((m = re.exec(jsp)) !== null) {
        scripts.push(m[1]);
    }
    // The first match in the JSP body is type="text/x-python" (the SymPy
    // template).  The next un-typed <script> is the legacy IIFE.  Find it
    // by searching for the IIFE signature.
    let iife = null;
    for (const body of scripts) {
        if (body.indexOf("(function() {") !== -1
            && body.indexOf("'use strict';") !== -1
            && body.indexOf("findMatchingParen") !== -1) {
            iife = body;
            break;
        }
    }
    if (!iife) throw new Error('Legacy IIFE not found in logarithm-calculator.jsp');

    // Strip JSP scriptlets — replace `<%= ... %>` with a stub literal so the
    // resulting JS is parseable.  The endpoint URL is the only one used.
    iife = iife.replace(/<%=request\.getContextPath\(\)%>/g, '/test-ctx');

    // Stub DOM/document/fetch — the IIFE looks up DOM elements at top-level
    // (e.g. document.getElementById('lc-input')).  Many will be null in our
    // sandbox.  The bottom-of-IIFE event-binding will throw on `.addEventListener`
    // calls against null, so we stub a minimal element factory.
    function makeStub() {
        const stub = {
            value: '', textContent: '', innerHTML: '', placeholder: '',
            style: {}, dataset: {}, classList: {
                add() {}, remove() {}, toggle() {}, contains() { return false; }
            },
            attributes: {},
            children: [],
            addEventListener() {}, removeEventListener() {},
            appendChild(c) { this.children.push(c); return c; },
            querySelector() { return null; },
            querySelectorAll() { return []; },
            getAttribute(k) { return this.attributes[k]; },
            setAttribute(k, v) { this.attributes[k] = v; },
            removeAttribute(k) { delete this.attributes[k]; },
            focus() {}, blur() {}, click() {},
            getBoundingClientRect() { return { top:0, left:0, width:0, height:0 }; },
            dispatchEvent() { return true; },
            closest() { return null; },
            cloneNode() { return makeStub(); },
            insertBefore() {},
            replaceChild() {},
            removeChild() {},
            parentNode: null,
            selectionStart: 0,
            selectionEnd: 0,
            setSelectionRange() {}
        };
        return stub;
    }

    // Special stub for the SymPy template: must return its text content.
    const SYMPY_TEMPLATE_TEXT = (function() {
        const tplRe = /<script type="text\/x-python" id="lc-sympy-template">([\s\S]*?)<\/script>/;
        const tm = jsp.match(tplRe);
        return tm ? tm[1].trim() : '';
    })();

    const documentStub = {
        addEventListener() {},
        removeEventListener() {},
        querySelectorAll(sel) {
            // The IIFE iterates `.lc-mode-btn`, `.lc-example-chip`,
            // `.lc-output-tab`, `.lc-panel` at init.  Return empty so the
            // forEach loops are no-ops.
            return [];
        },
        querySelector() { return null; },
        getElementById(id) {
            if (id === 'lc-sympy-template') {
                const t = makeStub();
                t.textContent = SYMPY_TEMPLATE_TEXT;
                return t;
            }
            return makeStub();
        },
        documentElement: makeStub(),
        body: makeStub(),
        head: makeStub(),
        createElement(tag) { return makeStub(); },
        readyState: 'complete'
    };

    const windowStub = {
        location: { search: '', origin: 'http://test', pathname: '/log' },
        document: documentStub,
        addEventListener() {}, removeEventListener() {},
        setTimeout: () => 0, clearTimeout: () => {},
        AbortController: function() { this.abort = () => {}; this.signal = {}; },
        fetch: () => Promise.resolve({ json: () => Promise.resolve({}) }),
        URLSearchParams: globalThis.URLSearchParams,
        btoa: globalThis.btoa || ((s) => Buffer.from(s, 'binary').toString('base64')),
        unescape: globalThis.unescape || ((s) => decodeURIComponent(s)),
        encodeURIComponent: globalThis.encodeURIComponent,
        _LC_TEST_HOOK: true,
        // Minimal nerdamer stub — the JS-side filter calls
        // nerdamer(...).sub(...).evaluate().text('decimals').  The real
        // nerdamer is loaded by tests that need it; here we offer a
        // pass-through stub.
        nerdamer: null,
        katex: { render() {} },
        Plotly: null,
        ToolUtils: { showToast() {}, copyToClipboard() {} },
        loadPlotly: function(cb) { if (cb) cb(); },
        URLSearchParams: globalThis.URLSearchParams,
        Event: function(name, opts) { this.name = name; this.bubbles = (opts||{}).bubbles; }
    };
    windowStub.window = windowStub;

    const ctx = vm.createContext(windowStub);
    vm.runInContext(iife, ctx, { filename: 'logarithm-calculator-iife.js' });

    return windowStub;
}

module.exports = { loadCore, JSP_PATH };
