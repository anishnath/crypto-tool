/**
 * Loads window.MathInput.latexToAscii from the JSP partial without
 * starting a browser — the sanitizer is a pure JS function so we can
 * extract it via regex and run it in a Node sandbox.
 *
 * Mirrors integral-calculator-test/require-core.js but targets a JSP
 * <script> block instead of a plain .js file.
 *
 * Exports:
 *   latexToAscii(s)   — strips LaTeX commands MathLive leaks into
 *                       getValue('ascii-math')
 *   fullSanitize(s)   — latexToAscii + smart-mode "sin → s∈" repair
 *                       (the second step of the JSP's sanitizeAscii)
 */
const path = require('path');
const fs = require('fs');

const jspPath = path.join(
    __dirname, '..',
    'src', 'main', 'webapp', 'math', 'partials', 'math-input-multi.jsp'
);
const jsp = fs.readFileSync(jspPath, 'utf8');

const fnMatch = jsp.match(/function latexToAscii\(s\) \{[\s\S]*?\n    \}/);
if (!fnMatch) {
    throw new Error('Could not extract latexToAscii from ' + jspPath +
        ' — has the function signature changed?');
}

// Eval the extracted function inside an IIFE so the local `function`
// declaration doesn't pollute the test runner's scope.
const latexToAscii = new Function(
    'return (function () { ' + fnMatch[0] + ' return latexToAscii; })()'
)();

// Mirror the second step of sanitizeAscii in math-input-multi.jsp —
// repairs the smart-mode "sin → s\in" mis-parse.  Pattern requires
// `s` + an `in` variant + `(` so legitimate set-membership stays intact.
function fullSanitize(s) {
    s = latexToAscii(s);
    return s.replace(/\bs\s*(?:\\in|\u2208|in)\s*\(/g, 'sin(');
}

module.exports = {
    latexToAscii: latexToAscii,
    fullSanitize: fullSanitize
};
