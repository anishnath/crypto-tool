/**
 * Loads integral-calculator-core.js from the JSP webapp.
 * Uses vm to execute the actual JSP source file (avoids Node ESM/CJS resolution).
 */
const path = require('path');
const fs = require('fs');
const vm = require('vm');

const corePath = path.join(__dirname, '..', 'src', 'main', 'webapp', 'modern', 'js', 'integral-calculator-core.js');
const code = fs.readFileSync(corePath, 'utf8');

const sandbox = {
    module: { exports: {} },
    exports: {},
    console, Math, parseFloat, String, RegExp,
    undefined, global,
    window: typeof window !== 'undefined' ? window : {},
    self: typeof self !== 'undefined' ? self : {}
};

vm.createContext(sandbox);
vm.runInContext(code, sandbox);

module.exports = sandbox.module.exports;
