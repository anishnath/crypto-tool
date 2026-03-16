/**
 * Advanced Graphing Tool Engine
 * Reusable JavaScript library using Math.js and Plotly.js
 */

/** Escape a string for safe insertion into HTML attributes/content */
function escapeHtml(str) {
    if (!str) return '';
    return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}

/* =========================================================================
   MathQuill ↔ Math.js bridge
   ========================================================================= */

/** Registry of active MathQuill field instances keyed by expression id */
var _mqFields = {};

/** Per-expression input mode: 'math' (MathQuill) or 'text' (plain input) */
var _mqInputMode = {};

/** Types that support MathQuill rich input */
var _mqSupportedTypes = ['cartesian', 'equation', 'inequality', 'polar', 'implicit', 'parametric', 'surface', 'limit'];

/** Guard flag: true while _initMathQuillField is setting initial content (suppress edit handler) */
var _mqInitializing = false;

/** Debounce timer for undo saves — declared here so MathQuill edit handler can access it */
var _undoSaveTimer = null;

/**
 * Convert MathQuill LaTeX output → Math.js-compatible plain-text expression.
 * This is the critical bridge: MathQuill produces LaTeX; the engine needs plain math.
 */
function latexToMathJS(latex) {
    if (!latex || typeof latex !== 'string') return '';
    let s = latex.trim();
    if (!s) return '';

    // ── Fractions: \frac{a}{b} → (a)/(b) ──
    // Handle nested fractions by iterating
    for (let i = 0; i < 10; i++) {
        const prev = s;
        s = s.replace(/\\frac\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}/g, '(($1)/($2))');
        if (s === prev) break;
    }

    // ── Square root: \sqrt{...} → sqrt(...), \sqrt[n]{...} → nthRoot(..., n) ──
    s = s.replace(/\\sqrt\[([^\]]+)\]\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}/g, 'nthRoot($2, $1)');
    s = s.replace(/\\sqrt\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}/g, 'sqrt($1)');

    // ── Definite integral: \int_{a}^{b} expr dx → int(expr, a, b) ──
    // MUST happen BEFORE exponent/subscript processing — MathQuill produces \int_{0}^{1}x^{2}dx
    // and the subscript stripper would destroy _{0} if we don't extract it first.
    // Strip \, \; \! thin spaces near dx/d\theta to avoid breaking the match
    s = s.replace(/\\[,;!]\s*d([a-zA-Z])/g, ' d$1');
    s = s.replace(/\\[,;!]\s*d\\([a-zA-Z]+)/g, ' dx');
    // Normalize d\theta, d\alpha etc. → dx (treat as single-char variable for integral matching)
    s = s.replace(/d\\(theta|alpha|beta|gamma|delta|phi|omega|tau|sigma|rho|lambda|mu|nu|xi|eta|epsilon|zeta|iota|kappa|chi|psi|pi|upsilon)\b\s*$/g, 'dx');
    // Normalize MathQuill mixed-brace bounds on \int, \sum, \prod
    // MQ omits braces for single-char bounds: \int_0^{10} → \int_{0}^{10}
    s = s.replace(/(\\(?:int|sum|prod)\s*)_([^{\s\\])(\^)/g, '$1_{$2}$3');
    // Match with braces: \int_{0}^{10} x^2 dx → int(x^2, 0, 10)
    s = s.replace(/\\int\s*_\{([^{}]*)\}\^\{([^{}]*)\}\s*(.+?)\s+d([a-zA-Z])\s*$/g, 'int($3, $1, $2)');
    // Without space before dx: \int_{0}^{10}x^2dx
    s = s.replace(/\\int\s*_\{([^{}]*)\}\^\{([^{}]*)\}\s*(.+?)d([a-zA-Z])\s*$/g, 'int($3, $1, $2)');
    // Mixed: braced lower, unbraced single-char upper: \int_{0}^1x^2dx
    s = s.replace(/\\int\s*_\{([^{}]*)\}\^([^{}\s])\s*(.+?)\s+d([a-zA-Z])\s*$/g, 'int($3, $1, $2)');
    s = s.replace(/\\int\s*_\{([^{}]*)\}\^([^{}\s])\s*(.+?)d([a-zA-Z])\s*$/g, 'int($3, $1, $2)');
    // Without braces (plain text): \int_0^1 x^2 dx
    s = s.replace(/\\int\s*_([^{}\s])\^([^{}\s])\s*(.+?)\s+d([a-zA-Z])\s*$/g, 'int($3, $1, $2)');
    s = s.replace(/\\int\s*_([^{}\s])\^([^{}\s])\s*(.+?)d([a-zA-Z])\s*$/g, 'int($3, $1, $2)');
    // MathQuill no-dx: \int_{0}^{10} expr → int(expr, 0, 10)
    s = s.replace(/\\int\s*_\{([^{}]+)\}\^\{([^{}]+)\}\s*(.+)$/g, 'int($3, $1, $2)');
    s = s.replace(/\\int\s*_\{([^{}]+)\}\^\{([^{}]+)\}$/g, 'int(x, $1, $2)');
    // No-dx mixed: \int_{0}^1 expr or \int_{0}^1
    s = s.replace(/\\int\s*_\{([^{}]+)\}\^([^{}\s])\s*(.+)$/g, 'int($3, $1, $2)');
    s = s.replace(/\\int\s*_\{([^{}]+)\}\^([^{}\s])$/g, 'int(x, $1, $2)');
    // Indefinite integral: \int expr dx → just the expression (antiderivative handled by engine)
    s = s.replace(/\\int\s*(.+?)\s*d([a-zA-Z])\s*$/g, '$1');

    // ── Limit: \lim_{x\to a} expr → lim(expr, x, a) ──
    // MathQuill produces: \lim_{x\to 0}\frac{\sin x}{x} or \lim_{x\to\infty}(1+1/x)^x
    // Braced subscript with \to or \rightarrow
    s = s.replace(/\\lim\s*_\{([a-zA-Z])\s*(?:\\to|\\rightarrow)\s*([^}]+)\}\s*(.+)$/g, 'lim($3, $1, $2)');
    // Unbraced single-char approach value: \lim_{x\to 0} expr (MQ mixed-brace)
    s = s.replace(/\\lim\s*_\{([a-zA-Z])\s*(?:\\to|\\rightarrow)\s*\}\s*(.+)$/g, '$2');
    // Plain text \lim without subscript → pass through as expression
    // (don't strip \lim if no subscript — let the cleanup handle it)

    // ── Summation: \sum_{n=1}^{10} body → sum(n, 1, 10, body) ──
    // MUST happen BEFORE subscript stripping
    s = s.replace(/\\sum_\{([a-zA-Z])=([^}]+)\}\^\{([^}]+)\}\s*(.+)$/g, 'sum($1, $2, $3, $4)');
    s = s.replace(/\\sum_([a-zA-Z])=(\d+)\^(\d+)\s*(.+)$/g, 'sum($1, $2, $3, $4)');

    // ── Product: \prod_{n=1}^{10} body → prod(n, 1, 10, body) ──
    s = s.replace(/\\prod_\{([a-zA-Z])=([^}]+)\}\^\{([^}]+)\}\s*(.+)$/g, 'prod($1, $2, $3, $4)');
    s = s.replace(/\\prod_([a-zA-Z])=(\d+)\^(\d+)\s*(.+)$/g, 'prod($1, $2, $3, $4)');

    // ── Exponents: x^{...} → x^(...), handle single char x^2 already fine ──
    s = s.replace(/\^\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}/g, '^($1)');

    // ── Subscripts: remove them (common in variable names, not math) ──
    s = s.replace(/_\{[^{}]*\}/g, '');
    s = s.replace(/_[a-zA-Z0-9]/g, '');

    // ── Absolute value: \left|...\right| → abs(...) ──
    s = s.replace(/\\left\|([^|]*?)\\right\|/g, 'abs($1)');
    s = s.replace(/\|([^|]+)\|/g, 'abs($1)');

    // ── Parentheses: \left( \right) → ( ) ──
    s = s.replace(/\\left\s*([(\[{|])/g, '$1');
    s = s.replace(/\\right\s*([)\]}|])/g, '$1');
    s = s.replace(/\\left\s*\./g, '');
    s = s.replace(/\\right\s*\./g, '');

    // ── Operators — MUST come before Greek letters (so \cdot\gamma doesn't merge) ──
    s = s.replace(/\\cdot(?![a-z])/g, '*');
    s = s.replace(/\\times/g, '*');
    s = s.replace(/\\div(?![a-z])/g, '/');
    s = s.replace(/\\pm/g, '+');
    s = s.replace(/\\mp/g, '-');
    // ── Comparisons / relations ──
    s = s.replace(/\\leq/g, '<=');
    s = s.replace(/\\geq/g, '>=');
    s = s.replace(/\\le(?![a-z])/g, '<=');
    s = s.replace(/\\ge(?![a-z])/g, '>=');
    s = s.replace(/\\neq/g, '!=');
    s = s.replace(/\\ne(?![a-z])/g, '!=');
    s = s.replace(/\\lt(?![a-z])/g, '<');
    s = s.replace(/\\gt(?![a-z])/g, '>');
    s = s.replace(/\\approx/g, '≈');
    s = s.replace(/\\sim/g, '~');
    // ── Calculus symbols ──
    s = s.replace(/\\partial/g, 'd');
    s = s.replace(/\\nabla/g, 'nabla');
    // ── Logic ──
    s = s.replace(/\\neg/g, 'not ');
    s = s.replace(/\\wedge/g, ' and ');
    s = s.replace(/\\vee/g, ' or ');
    // ── Set notation ──
    s = s.replace(/\\cup/g, ' union ');
    s = s.replace(/\\cap/g, ' intersect ');
    s = s.replace(/\\setminus/g, ' \\ ');
    s = s.replace(/\\emptyset/g, '{}');
    s = s.replace(/\\subseteq/g, ' subseteq ');
    s = s.replace(/\\supseteq/g, ' supseteq ');
    s = s.replace(/\\subset/g, ' subset ');
    s = s.replace(/\\supset/g, ' supset ');
    s = s.replace(/\\notin/g, ' notin ');
    s = s.replace(/\\in(?![a-z])/g, ' in ');
    s = s.replace(/\\forall/g, 'forall ');
    s = s.replace(/\\exists/g, 'exists ');
    // ── Arrows (strip) ──
    s = s.replace(/\\(?:to|rightarrow|Rightarrow|leftarrow|Leftarrow|leftrightarrow|Leftrightarrow|mapsto|uparrow|downarrow|longrightarrow|longleftarrow)\b/g, '');
    // ── Floor / ceiling brackets ──
    s = s.replace(/\\lfloor\s*/g, 'floor(');
    s = s.replace(/\\rfloor/g, ')');
    s = s.replace(/\\lceil\s*/g, 'ceil(');
    s = s.replace(/\\rceil/g, ')');
    s = s.replace(/\\langle/g, '(');
    s = s.replace(/\\rangle/g, ')');
    // ── Dots ──
    s = s.replace(/\\(?:ldots|cdots|ddots|vdots)/g, '...');
    // ── Number sets ──
    s = s.replace(/\\mathbb\{([A-Z])\}/g, '$1');

    // ── Greek letters (lowercase) — AFTER operators so \cdot\gamma works ──
    s = s.replace(/\\(alpha|beta|gamma|delta|epsilon|zeta|eta|theta|iota|kappa|lambda|mu|nu|xi|pi|rho|sigma|tau|chi|psi|phi|omega|varepsilon|varphi|varsigma|vartheta|varpi|varrho|upsilon|digamma)\b/g, '$1');
    // ── Greek letters (uppercase) ──
    s = s.replace(/\\(Gamma|Delta|Theta|Lambda|Xi|Pi|Sigma|Phi|Psi|Omega|Upsilon)\b/g, '$1');
    // ── Special constants ──
    s = s.replace(/\\infty/g, 'Infinity');
    s = s.replace(/\\infin/g, 'Infinity');

    // ── Trig / log / math functions ──
    s = s.replace(/\\(sin|cos|tan|sec|csc|cot|arcsin|arccos|arctan|sinh|cosh|tanh|coth|sech|csch|ln|log|exp|abs|min|max|floor|ceil|sign|round|mod|gcd|lcm|det|dim|ker|arg|hom|deg)\b/g, '$1');
    // ── Limit operator names ──
    s = s.replace(/\\(lim|limsup|liminf|sup|inf)\b/g, '$1');

    // ── Braces cleanup ──
    s = s.replace(/\{/g, '(');
    s = s.replace(/\}/g, ')');

    // ── Collapse empty parens from mid-entry states like \frac{}{} ──
    s = s.replace(/\(\s*\)/g, '');

    // ── e^{...} → exp(...) when 'e' is Euler's number ──
    s = s.replace(/(?<![a-zA-Z])e\^\(([^)]+)\)/g, 'exp($1)');
    s = s.replace(/(?<![a-zA-Z])e\^([a-zA-Z0-9])/g, 'exp($1)');

    // ── Cleanup LaTeX artifacts ──
    s = s.replace(/\\ /g, ' ');       // escaped spaces
    s = s.replace(/\\,/g, '');        // thin space
    s = s.replace(/\\;/g, '');        // medium space
    s = s.replace(/\\!/g, '');        // negative thin space
    s = s.replace(/\\quad/g, ' ');
    s = s.replace(/\\qquad/g, ' ');
    s = s.replace(/~/g, ' ');         // non-breaking space
    s = s.replace(/\\text\{([^}]*)\}/g, '$1');  // \text{...}
    s = s.replace(/\\mathrm\{([^}]*)\}/g, '$1');
    s = s.replace(/\\operatorname\{([^}]*)\}/g, '$1');

    // ── Remove any remaining backslash commands we don't recognize ──
    s = s.replace(/\\[a-zA-Z]+/g, '');

    // ── Whitespace cleanup ──
    s = s.replace(/\s+/g, ' ').trim();

    return s;
}

/**
 * Convert Math.js plain-text expression → LaTeX for writing into MathQuill.
 * This is the reverse direction: when loading a sample or restoring state.
 */
function mathJSToLatex(expr) {
    if (!expr || typeof expr !== 'string') return '';

    // ── Special forms: int/sum/prod/deriv → LaTeX before general processing ──
    var intMatch = expr.match(/^\s*int\s*\(\s*(.+?)\s*,\s*(.+?)\s*,\s*(.+?)\s*\)\s*$/i);
    if (intMatch) {
        var body = mathJSToLatex(intMatch[1].trim());
        return '\\int_{' + intMatch[2].trim() + '}^{' + intMatch[3].trim() + '}' + body + '\\,dx';
    }
    var sumMatch = expr.match(/^\s*sum\s*\(\s*([a-zA-Z])\s*,\s*(.+?)\s*,\s*(.+?)\s*,\s*(.+)\s*\)\s*$/i);
    if (sumMatch) {
        var sBody = mathJSToLatex(sumMatch[4].trim());
        return '\\sum_{' + sumMatch[1] + '=' + sumMatch[2].trim() + '}^{' + sumMatch[3].trim() + '}' + sBody;
    }
    var prodMatch = expr.match(/^\s*prod\s*\(\s*([a-zA-Z])\s*,\s*(.+?)\s*,\s*(.+?)\s*,\s*(.+)\s*\)\s*$/i);
    if (prodMatch) {
        var pBody = mathJSToLatex(prodMatch[4].trim());
        return '\\prod_{' + prodMatch[1] + '=' + prodMatch[2].trim() + '}^{' + prodMatch[3].trim() + '}' + pBody;
    }

    // lim(expr, var, value) → \lim_{var\to value} expr
    var limMatch = expr.match(/^\s*lim\s*\(\s*(.+?)\s*,\s*([a-zA-Z])\s*,\s*(.+?)\s*\)\s*$/i);
    if (limMatch) {
        var lBody = mathJSToLatex(limMatch[1].trim());
        var lVal = limMatch[3].trim();
        // Convert Infinity → \infty for LaTeX
        lVal = lVal.replace(/^Infinity$/i, '\\infty').replace(/^-Infinity$/i, '-\\infty');
        return '\\lim_{' + limMatch[2] + '\\to ' + lVal + '}' + lBody;
    }

    // For comma-separated expressions (parametric like "cos(t), sin(t)"),
    // convert each part separately and rejoin
    if (expr.includes(',') && !expr.includes('(') || (expr.match(/,/g) || []).length > (expr.match(/\(/g) || []).length) {
        // Count commas outside of parentheses
        let depth = 0, topCommas = [];
        for (let i = 0; i < expr.length; i++) {
            if (expr[i] === '(') depth++;
            else if (expr[i] === ')') depth--;
            else if (expr[i] === ',' && depth === 0) topCommas.push(i);
        }
        if (topCommas.length > 0) {
            const parts = [];
            let start = 0;
            for (const ci of topCommas) {
                parts.push(expr.substring(start, ci).trim());
                start = ci + 1;
            }
            parts.push(expr.substring(start).trim());
            return parts.map(p => mathJSToLatex(p)).join(', ');
        }
    }

    try {
        // Use Math.js built-in toTex for most expressions
        const node = math.parse(expr);
        let tex = node.toTex();
        // Fix common issues with Math.js LaTeX output
        tex = tex.replace(/\\mathrm\{pi\}/g, '\\pi');
        tex = tex.replace(/\\mathrm\{theta\}/g, '\\theta');
        tex = tex.replace(/\\mathrm\{e\}/g, 'e');
        tex = tex.replace(/~\\cdot~/g, '\\cdot ');
        return tex;
    } catch (_) {
        // Fallback: basic regex conversion
        let s = expr;
        s = s.replace(/\bpi\b/g, '\\pi');
        s = s.replace(/\btheta\b/g, '\\theta');
        s = s.replace(/\bsqrt\(([^)]+)\)/g, '\\sqrt{$1}');
        s = s.replace(/\b(sin|cos|tan|log|ln|exp|sec|csc|cot)\b/g, '\\$1');
        return s;
    }
}

/**
 * Check if MathQuill is loaded and ready
 */
function isMathQuillReady() {
    return typeof window.MQ !== 'undefined' && window.MQ && typeof window.MQ.MathField === 'function';
}

/**
 * Initialize MathQuill field for a given expression id.
 * Called after innerHTML is set and the mount div exists in DOM.
 */
function _initMathQuillField(id) {
    if (!isMathQuillReady()) return;
    const mountEl = document.getElementById(`mq-field-${id}`);
    if (!mountEl) return;

    const mq = window.MQ.MathField(mountEl, {
        spaceBehavesLikeTab: true,
        leftRightIntoCmdGoes: 'up',
        restrictMismatchedBrackets: true,
        supSubsRequireOperand: true,
        autoCommands: 'pi theta sqrt int sum prod coprod oint'
            + ' alpha beta gamma delta epsilon zeta eta iota kappa lambda mu nu xi rho sigma tau chi psi phi omega'
            + ' varepsilon varphi varsigma vartheta varpi varrho'
            + ' Gamma Delta Theta Lambda Xi Pi Sigma Phi Psi Omega Upsilon'
            + ' infty pm mp times div cdot le leq ge geq neq approx sim simeq cong equiv'
            + ' subset supset subseteq supseteq in notin cup cap setminus emptyset'
            + ' forall exists nexists neg wedge vee oplus otimes'
            + ' to rightarrow Rightarrow leftarrow Leftarrow leftrightarrow Leftrightarrow'
            + ' uparrow downarrow mapsto'
            + ' partial nabla infin aleph'
            + ' lfloor rfloor lceil rceil langle rangle'
            + ' ldots cdots ddots vdots'
            + ' star diamond triangle square circ bullet angle perp parallel'
            + ' quad qquad',
        autoOperatorNames: 'sin cos tan sec csc cot'
            + ' arcsin arccos arctan'
            + ' sinh cosh tanh coth sech csch'
            + ' ln log exp'
            + ' abs floor ceil sign round min max mod gcd lcm'
            + ' det dim ker lim limsup liminf sup inf'
            + ' arg deg hom'
            + ' nthRoot factorial deriv',
        handlers: {
            edit: function() {
                _onMathQuillEdit(id);
            }
        }
    });

    _mqFields[id] = mq;

    // Set initial content if expression already has a value
    const expr = engine.expressions.find(e => e.id === id);
    if (expr) {
        // Prefer _originalInput for round-tripping int/sum/prod/deriv through MathQuill
        const sourceExpr = (expr._originalInput && expr._originalInput.trim()) || expr.expression;
        if (sourceExpr && sourceExpr.trim()) {
            const latex = mathJSToLatex(sourceExpr);
            if (latex) {
                _mqInitializing = true;
                mq.latex(latex);
                _mqInitializing = false;
            }
        }
    }

    // Set placeholder via data attribute
    const editableEl = mountEl.querySelector('.mq-editable-field');
    if (editableEl) {
        editableEl.setAttribute('data-mq-placeholder', 'Type math: x², sin(x), fractions...');
    }
}

/**
 * Called on every MathQuill edit event.
 * Converts LaTeX → Math.js and feeds into the existing engine pipeline.
 */
function _onMathQuillEdit(id) {
    if (_mqInitializing) return; // suppress during _initMathQuillField setup
    const mq = _mqFields[id];
    if (!mq) return;

    const latex = mq.latex();
    const mathExpr = latexToMathJS(latex);

    // Skip empty/whitespace-only expressions (mid-entry states)
    if (!mathExpr || !mathExpr.trim()) {
        engine.updateExpression(id, { expression: '' });
        try { updateGraph(); } catch (_) {}
        return;
    }

    // Store the plain-text expression in the engine
    engine.updateExpression(id, { expression: mathExpr });

    // Debounced undo save
    if (_undoSaveTimer) clearTimeout(_undoSaveTimer);
    else saveUndoState();
    _undoSaveTimer = setTimeout(() => { _undoSaveTimer = null; }, 500);

    // Auto-detect type change
    const expr = engine.expressions.find(e => e.id === id);
    if (expr) {
        const detected = autoDetectType(mathExpr, expr.type);
        if (detected && detected !== expr.type && !_mqSupportedTypes.includes(detected)) {
            // Switch to plain text mode if detected type doesn't support MathQuill
            expr.type = detected;
            const typeSel = document.getElementById(`type-${id}`);
            if (typeSel) typeSel.value = detected;
            const badge = document.getElementById(`type-badge-${id}`);
            if (badge) badge.textContent = _getTypeBadgeLabel(detected);
            _mqInputMode[id] = 'text';
            createInputForType(id, detected);
            const newInput = document.getElementById(`expr-${id}`);
            if (newInput) newInput.value = mathExpr;
            const calcToggles = document.getElementById(`calculus-toggles-${id}`);
            if (calcToggles) calcToggles.style.display = (detected === 'cartesian') ? '' : 'none';
            try { updateGraph(); } catch (_) {}
            return;
        }
        if (detected && detected !== expr.type) {
            expr.type = detected;
            const typeSel = document.getElementById(`type-${id}`);
            if (typeSel) typeSel.value = detected;
            const badge2 = document.getElementById(`type-badge-${id}`);
            if (badge2) badge2.textContent = _getTypeBadgeLabel(detected);
            const calcToggles = document.getElementById(`calculus-toggles-${id}`);
            if (calcToggles) calcToggles.style.display = (detected === 'cartesian') ? '' : 'none';
        }
    }

    // Handle variable assignment from MQ (switches to plain text since variable type isn't MQ-supported)
    if (expr && expr.type === 'variable') {
        _handleVariableExpression(id, mathExpr);
        try { updateGraph(); } catch (_) {}
        return;
    }

    // Handle piecewise brace syntax from MQ
    if (expr && expr.type === 'piecewise' && /\{[^}]*:[^}]+\}/.test(mathExpr)) {
        _parsePiecewiseBraceSyntax(id, mathExpr);
        try { updateGraph(); } catch (_) {}
        return;
    }

    // Handle list type from MQ (switches to plain text)
    if (expr && expr.type === 'list') {
        _handleListExpression(id, mathExpr);
        try { updateGraph(); } catch (_) {}
        return;
    }

    // Handle inline int/sum/prod/deriv from MathQuill — connect to graph + numeric result
    if (expr && expr.type === 'cartesian') {
        var handled = _handleSpecialSyntaxFromInput(id, mathExpr);
        if (handled) {
            try { updateGraph(); } catch (_) {}
            return;
        }
    }

    // Detect and create sliders for parameters (a, b, c, etc.)
    if (expr && ['cartesian', 'equation', 'implicit', 'polar', 'parametric', 'surface', 'inequality'].includes(expr.type)) {
        detectAndCreateSliders(id, mathExpr);
    }

    // For limit type, trigger limit evaluation (reads from MQ via updateLimitExpression)
    if (expr && expr.type === 'limit') {
        try { updateLimitExpression(id); } catch (_) {}
        return; // updateLimitExpression calls updateGraph internally
    }

    // Numeric evaluation (Desmos-style: "2+3" → "= 5")
    _evaluateNumeric(id, mathExpr);

    // Update the graph — no separate preview needed, MathQuill IS the preview
    try { updateGraph(); } catch (_) {}
}

/**
 * Initialize all pending MathQuill fields (called when MathQuill finishes loading).
 * Rebuilds the input DOM for expressions that were created before MQ was ready.
 */
function _initMathQuillFields() {
    if (!isMathQuillReady()) return;
    engine.expressions.forEach(expr => {
        if (_mqSupportedTypes.includes(expr.type) && _mqInputMode[expr.id] !== 'text') {
            if (!_mqFields[expr.id]) {
                // Rebuild the input DOM — it was rendered as plain text because MQ wasn't ready.
                // createInputForType will now detect MQ is ready, render the mq-field div,
                // and call _initMathQuillField internally.
                createInputForType(expr.id, expr.type);
            }
        }
    });
}

/**
 * Toggle between MathQuill (rich) and plain text input modes.
 */
function toggleInputMode(id) {
    const expr = engine.expressions.find(e => e.id === id);
    if (!expr) return;

    const currentMode = _mqInputMode[id] || 'math';
    if (currentMode === 'math') {
        // Switch to plain text
        _mqInputMode[id] = 'text';
        // Destroy MathQuill field
        if (_mqFields[id]) {
            delete _mqFields[id];
        }
        createInputForType(id, expr.type);
        const input = document.getElementById(`expr-${id}`);
        if (input) input.value = expr.expression || '';
    } else {
        // Switch to MathQuill
        _mqInputMode[id] = 'math';
        if (isMathQuillReady() && _mqSupportedTypes.includes(expr.type)) {
            createInputForType(id, expr.type);
        }
    }
}

/**
 * Load a sample expression into MathQuill field or plain input.
 * sampleLatex: optional LaTeX version for MathQuill; if omitted, converts from plain.
 */
function loadSampleMQ(id, plainExpr, sampleLatex) {
    const mq = _mqFields[id];
    if (mq && _mqInputMode[id] !== 'text') {
        // Write LaTeX into MathQuill
        const latex = sampleLatex || mathJSToLatex(plainExpr);
        mq.latex(latex);
        // MathQuill edit handler will fire automatically
    } else {
        // Fallback to plain text
        loadSample(id, plainExpr);
    }
}

class GraphingEngine {
    constructor(containerId) {
        this.containerId = containerId;
        this.expressions = [];
        this.nextId = 1;
        this.colors = [
            '#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd',
            '#8c564b', '#e377c2', '#7f7f7f', '#bcbd22', '#17becf'
        ];
        this.colorIndex = 0;
        this._sympyPending = 0; // track in-flight SymPy requests
        this._compiledCache = {}; // expression → compiled math.js node
        this.globalScope = {}; // shared variable assignments: { a: 3, b: 5 }
    }

    /**
     * Rebuild globalScope from all variable-type expressions.
     * Called whenever a variable expression changes or is deleted.
     */
    rebuildGlobalScope() {
        this.globalScope = {};
        for (var i = 0; i < this.expressions.length; i++) {
            var e = this.expressions[i];
            if (e.type === 'variable' && e._varName && e._varValue != null) {
                this.globalScope[e._varName] = e._varValue;
            }
            if (e.type === 'list' && e._listName && e._listValues) {
                this.globalScope[e._listName] = e._listValues;
            }
        }
    }

    /** Compile a math.js expression with caching */
    _compile(expr) {
        if (!this._compiledCache[expr]) {
            this._compiledCache[expr] = math.compile(expr);
        }
        return this._compiledCache[expr];
    }

    /**
     * Generate trace for sum(var, start, end, body) or prod(var, start, end, body)
     * where body can contain x — creates a plot of the sum/product as function of x.
     */
    _generateSumProductTrace(expression, type, xMin, xMax, expr) {
        const pattern = type === 'sum'
            ? /^\s*sum\s*\(\s*([a-zA-Z])\s*,\s*(.+?)\s*,\s*(.+?)\s*,\s*(.+)\s*\)\s*$/
            : /^\s*prod\s*\(\s*([a-zA-Z])\s*,\s*(.+?)\s*,\s*(.+?)\s*,\s*(.+)\s*\)\s*$/;
        const m = expression.match(pattern);
        if (!m) return null;

        const [, varName, startExpr, endExpr, bodyExpr] = m;
        try {
            const start = Math.round(math.evaluate(startExpr));
            const end = Math.round(math.evaluate(endExpr));
            if (end - start > 10000) return null; // safety limit
            const compiled = math.compile(bodyExpr);

            const numPoints = 500;
            const xs = [];
            const ys = [];
            const step = (xMax - xMin) / numPoints;
            const containsX = /(?<![a-zA-Z])x(?![a-zA-Z])/.test(bodyExpr);

            for (let i = 0; i <= numPoints; i++) {
                const x = xMin + i * step;
                let result = type === 'sum' ? 0 : 1;
                let valid = true;
                for (let n = start; n <= end; n++) {
                    const scope = {};
                    scope[varName] = n;
                    if (containsX) scope.x = x;
                    try {
                        const val = compiled.evaluate(scope);
                        if (type === 'sum') result += val;
                        else result *= val;
                        if (!isFinite(result)) { valid = false; break; }
                    } catch (_) { valid = false; break; }
                }
                xs.push(x);
                ys.push(valid ? result : NaN);
            }

            // If body doesn't contain x, it's a constant — still plot as horizontal line
            return [{
                x: xs, y: ys,
                type: 'scatter', mode: 'lines',
                name: expr.expression,
                line: { color: expr.color, width: 2 },
                connectgaps: false
            }];
        } catch (e) {
            return null;
        }
    }

    // ==================== SymPy Fallback Helpers ====================

    /** Convert math expression to Python/SymPy syntax */
    static _toPython(s) {
        if (!s) return '';
        s = s.trim();
        s = s.replace(/\^/g, '**');
        s = s.replace(/(\d)([a-zA-Z])/g, '$1*$2');
        s = s.replace(/\)\s*\(/g, ')*(');
        s = s.replace(/\)\s*([a-zA-Z\d])/g, ')*$1');
        return s;
    }

    /** Execute Python code via OneCompilerFunctionality and return stdout */
    _sympyExec(code) {
        const ctx = (document.querySelector('meta[name="context-path"]') || {}).content || '';
        const controller = new AbortController();
        const timeoutId = setTimeout(() => controller.abort(), 30000);
        return fetch(ctx + '/OneCompilerFunctionality?action=execute', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ language: 'python', version: '3.10', code }),
            signal: controller.signal
        })
        .then(r => r.json())
        .then(data => {
            clearTimeout(timeoutId);
            return (data.Stdout || data.stdout || '').trim();
        })
        .catch(err => {
            clearTimeout(timeoutId);
            console.error('SymPy exec failed:', err);
            return '';
        });
    }

    /** Show/hide SymPy computing indicator */
    _showSympyIndicator(msg) {
        let el = document.getElementById('gc-sympy-indicator');
        if (!el) {
            el = document.createElement('div');
            el.id = 'gc-sympy-indicator';
            el.style.cssText = 'position:absolute;top:12px;left:50%;transform:translateX(-50%);z-index:100;' +
                'background:rgba(99,102,241,0.95);color:#fff;padding:6px 16px;border-radius:20px;font-size:13px;' +
                'font-weight:500;pointer-events:none;transition:opacity 0.3s;box-shadow:0 2px 8px rgba(0,0,0,0.2);';
            const graphDiv = document.getElementById(this.containerId);
            if (graphDiv && graphDiv.parentElement) {
                graphDiv.parentElement.style.position = 'relative';
                graphDiv.parentElement.appendChild(el);
            }
        }
        el.textContent = msg || 'Solving...';
        el.style.opacity = '1';
    }

    _hideSympyIndicator() {
        const el = document.getElementById('gc-sympy-indicator');
        if (el) {
            el.style.opacity = '0';
            setTimeout(() => el.remove(), 300);
        }
    }

    /**
     * Add a new expression to plot
     */
    addExpression(expression, type = 'cartesian', color = null) {
        const expr = {
            id: this.nextId++,
            expression: expression,
            type: type,
            color: color || this.colors[this.colorIndex++ % this.colors.length],
            visible: true,
            data: null
        };

        this.expressions.push(expr);
        return expr;
    }

    /**
     * Update an existing expression
     */
    updateExpression(id, updates) {
        const expr = this.expressions.find(e => e.id === id);
        if (expr) {
            // Clear stale computed data when expression changes
            if (updates.expression && updates.expression !== expr.expression) {
                delete expr._areaBetween;
                delete expr._tableXValues;
                delete expr._tablePoints;
            }
            Object.assign(expr, updates);
        }
    }

    /**
     * Remove an expression
     */
    removeExpression(id) {
        this.expressions = this.expressions.filter(e => e.id !== id);
    }

    /**
     * Normalize common user-input patterns into valid math.js syntax.
     *  - ** → ^ (Python-style exponent)
     *  - ln( → log( (natural log alias)
     *  - Strip leading "y =" / "y=" from Cartesian input
     */
    normalizeExpression(expr) {
        if (!expr || typeof expr !== 'string') return expr;
        let s = expr.trim();
        // Unicode math symbols → ASCII equivalents
        s = s.replace(/π/g, 'pi');
        s = s.replace(/√\s*/g, 'sqrt');
        s = s.replace(/²/g, '^2');
        s = s.replace(/³/g, '^3');
        s = s.replace(/⁴/g, '^4');
        s = s.replace(/θ/g, 'theta');
        // |x| absolute value bars → abs(x)
        s = s.replace(/\|([^|]+)\|/g, 'abs($1)');
        // Python-style exponent
        s = s.replace(/\*\*/g, '^');
        // e^(...) → exp(...) when 'e' is Euler's number (not part of a word)
        s = s.replace(/(?<![a-zA-Z])e\^(\()/g, 'exp$1');
        s = s.replace(/(?<![a-zA-Z])e\^([a-zA-Z0-9])/g, 'exp($1)');
        // ln → log  (math.js log is natural log)
        s = s.replace(/\bln\s*\(/g, 'log(');
        // arcsin/arccos/arctan → asin/acos/atan
        s = s.replace(/\barcsin\s*\(/gi, 'asin(');
        s = s.replace(/\barccos\s*\(/gi, 'acos(');
        s = s.replace(/\barctan\s*\(/gi, 'atan(');
        // log10(x) → log(x)/log(10)
        s = s.replace(/\blog10\s*\(([^)]+)\)/gi, '(log($1)/log(10))');
        // digit × opening paren: 2(x+1) → 2*(x+1)
        s = s.replace(/(\d)\s*\(/g, '$1*(');
        // closing paren × opening paren: )(  → )*(
        s = s.replace(/\)\s*\(/g, ')*(');
        // closing paren × digit or letter: )2 → )*2, )x → )*x
        s = s.replace(/\)\s*(\w)/g, ')*$1');
        // digit × known function name: 2sin(x) → 2*sin(x), 3cos(x) → 3*cos(x)
        s = s.replace(/(\d)\s*(sin|cos|tan|asin|acos|atan|sinh|cosh|tanh|sec|csc|cot|log|exp|sqrt|abs|ceil|floor|sign|round)\s*\(/gi,
            '$1*$2(');
        // negative coefficient × letter: -2x → -2*x (handles leading minus)
        s = s.replace(/(^|[+\-*/^(,])\s*(-?\d+\.?\d*)([a-zA-Z])/g, (m, pre, num, letter) => {
            if (/[a-zA-Z]/.test(pre)) return m; // Don't break function names
            return pre + num + '*' + letter;
        });
        // digit × single letter (not part of function): 2x → 2*x, 3y → 3*y
        s = s.replace(/(\d)([a-zA-Z])/g, '$1*$2');
        // Implicit multiplication between adjacent single-letter variables:
        //   xy → x*y,  but not "sin", "cos", "pi", etc.
        s = s.replace(/(?<![a-zA-Z])([a-zA-Z])([a-zA-Z])(?![a-zA-Z(])/g, (m, a, b) => {
            if ((a + b).toLowerCase() === 'pi') return m;
            return a + '*' + b;
        });
        // Variable × function name: xsin(x) → x*sin(x), ycos(t) → y*cos(t)
        // Exclude known multi-letter function prefixes (asin, acos, atan, sinh, cosh, tanh)
        s = s.replace(/(?<![a-zA-Z])([a-zA-Z])(sin|cos|tan|log|exp|sqrt|abs|ceil|floor|sign|round|sec|csc|cot)\s*\(/gi, (m, letter, fn) => {
            const combined = (letter + fn).toLowerCase();
            // Don't split known compound functions
            if (['asin','acos','atan','sinh','cosh','tanh'].includes(combined)) return m;
            return letter + '*' + fn + '(';
        });
        // Function juxtaposition: sin(x)cos(x) → sin(x)*cos(x)
        s = s.replace(/\)\s*(sin|cos|tan|asin|acos|atan|sinh|cosh|tanh|sec|csc|cot|log|exp|sqrt|abs)\s*\(/gi, ')*$1(');
        return s;
    }

    /**
     * Strip "y = " prefix that users often type for Cartesian input.
     */
    stripCartesianPrefix(expr) {
        if (!expr || typeof expr !== 'string') return expr;
        // Strip "y = ", "f(x) = ", "g(x) = " prefixes
        return expr.replace(/^\s*(?:y|f\s*\(\s*x\s*\)|g\s*\(\s*x\s*\))\s*=\s*/i, '');
    }

    /**
     * Strip domain restriction from expression: "x^2 {x > 0}" → ["x^2", condition]
     * Supports: {x > 0}, {-2 < x < 5}, {x >= 0 and x <= 10}
     */
    parseDomainRestriction(expression) {
        if (!expression || typeof expression !== 'string') return { expr: expression, restriction: null };
        const m = expression.match(/^(.*?)\s*\{([^}]+)\}\s*$/);
        if (!m) return { expr: expression, restriction: null };
        return { expr: m[1].trim(), restriction: m[2].trim() };
    }

    /**
     * Evaluate a domain restriction string for a given x value.
     * e.g., "x > 0", "-2 < x < 5", "x >= 0 and x <= 10"
     */
    evaluateDomainRestriction(restriction, xVal) {
        if (!restriction) return true;
        try {
            // Handle compound: "x > 0 and x < 5"
            const parts = restriction.split(/\s+and\s+/i);
            for (const part of parts) {
                const p = part.trim();
                // Double inequality: -2 < x < 5
                const dbl = p.match(/^([+-]?\d+\.?\d*)\s*(<=?)\s*x\s*(<=?)\s*([+-]?\d+\.?\d*)$/);
                if (dbl) {
                    const lo = parseFloat(dbl[1]), hi = parseFloat(dbl[4]);
                    const loStrict = dbl[2] === '<', hiStrict = dbl[3] === '<';
                    if (loStrict ? xVal <= lo : xVal < lo) return false;
                    if (hiStrict ? xVal >= hi : xVal > hi) return false;
                    continue;
                }
                // Single inequality: x > 0, x <= 5, 3 < x
                const sng = p.match(/^(x|[+-]?\d+\.?\d*)\s*(>=?|<=?|!=)\s*(x|[+-]?\d+\.?\d*)$/);
                if (sng) {
                    const left = sng[1] === 'x' ? xVal : parseFloat(sng[1]);
                    const right = sng[3] === 'x' ? xVal : parseFloat(sng[3]);
                    const op = sng[2];
                    if (op === '>' && !(left > right)) return false;
                    if (op === '>=' && !(left >= right)) return false;
                    if (op === '<' && !(left < right)) return false;
                    if (op === '<=' && !(left <= right)) return false;
                    if (op === '!=' && !(left !== right)) return false;
                    continue;
                }
                // If can't parse, ignore (allow all)
            }
            return true;
        } catch (_) {
            return true;
        }
    }

    /**
     * Compute area between two curves f(x) and g(x)
     */
    areaBetweenCurves(expr1, expr2, xMin, xMax, numPoints = 1000) {
        try {
            if (!expr1 || !expr2) return null;
            const p1 = this.parseDomainRestriction(expr1);
            const p2 = this.parseDomainRestriction(expr2);
            const c1 = this._compile(this.normalizeExpression(this.stripCartesianPrefix(p1.expr)));
            const c2 = this._compile(this.normalizeExpression(this.stripCartesianPrefix(p2.expr)));
            const step = (xMax - xMin) / numPoints;
            let area = 0;
            const xTop = [], yTop = [], xBot = [], yBot = [];

            for (let i = 0; i <= numPoints; i++) {
                const x = xMin + i * step;
                try {
                    if (p1.restriction && !this.evaluateDomainRestriction(p1.restriction, x)) continue;
                    if (p2.restriction && !this.evaluateDomainRestriction(p2.restriction, x)) continue;
                    const y1 = c1.evaluate({ x });
                    const y2 = c2.evaluate({ x });
                    if (isFinite(y1) && isFinite(y2)) {
                        const top = Math.max(y1, y2);
                        const bot = Math.min(y1, y2);
                        xTop.push(x); yTop.push(top);
                        xBot.push(x); yBot.push(bot);
                        if (i > 0) area += Math.abs(y1 - y2) * step;
                    }
                } catch (_) {}
            }

            // Build closed polygon for shading: top curve forward, bottom curve backward
            const shadeX = [...xTop, ...xBot.slice().reverse()];
            const shadeY = [...yTop, ...yBot.slice().reverse()];

            return { area, shadeX, shadeY };
        } catch (error) {
            console.error('Error computing area between curves:', error);
            return null;
        }
    }

    /**
     * Generate a table of values for an expression object.
     * Supports cartesian, equation, polar, parametric types with parameter substitution.
     * @param {object} exprObj - Full expression object (with .expression, .type, .parameters, etc.)
     * @param {number} xMin
     * @param {number} xMax
     * @param {number} numPoints
     * @returns {Array<{x:number|string, y:number|string, y2?:number|string}>|null}
     */
    generateTableOfValues(exprObj, xMin = -10, xMax = 10, numPoints = 21) {
        try {
            // Support legacy call: generateTableOfValues("x^2", -10, 10)
            const isLegacy = typeof exprObj === 'string';
            const expression = isLegacy ? exprObj : exprObj.expression;
            const type = isLegacy ? 'cartesian' : (exprObj.type || 'cartesian');
            const parameters = isLegacy ? null : exprObj.parameters;

            if (!expression || typeof expression !== 'string' || expression.trim() === '') return null;

            // Substitute parameters
            let substituted = this.normalizeExpression(expression);
            if (parameters) {
                Object.keys(parameters).forEach(param => {
                    const re = new RegExp(`\\b${param}\\b`, 'g');
                    substituted = substituted.replace(re, String(parameters[param]));
                });
            }

            const { expr: cleanExpr, restriction } = this.parseDomainRestriction(substituted);
            const step = (xMax - xMin) / (numPoints - 1);
            const rows = [];

            if (type === 'parametric') {
                // Parametric: table of t, x(t), y(t)
                const parts = cleanExpr.split(',').map(s => s.trim());
                if (parts.length < 2) return null;
                const tMin = exprObj.tMin != null ? exprObj.tMin : 0;
                const tMax = exprObj.tMax != null ? exprObj.tMax : 2 * Math.PI;
                const tStep = (tMax - tMin) / (numPoints - 1);
                const cx = this._compile(this.normalizeExpression(parts[0]));
                const cy = this._compile(this.normalizeExpression(parts[1]));
                for (let i = 0; i < numPoints; i++) {
                    const t = tMin + i * tStep;
                    try {
                        const xv = cx.evaluate({ t });
                        const yv = cy.evaluate({ t });
                        rows.push({
                            x: isFinite(xv) ? +xv.toFixed(4) : 'undef',
                            y: isFinite(yv) ? +yv.toFixed(4) : 'undef',
                            t: +t.toFixed(4)
                        });
                    } catch (_) {
                        rows.push({ t: +t.toFixed(4), x: 'undef', y: 'undef' });
                    }
                }
                return rows;
            }

            if (type === 'polar') {
                // Polar: table of θ, r, (x, y)
                const thetaMin = exprObj.thetaMin != null ? exprObj.thetaMin : 0;
                const thetaMax = exprObj.thetaMax != null ? exprObj.thetaMax : 2 * Math.PI;
                const tStep = (thetaMax - thetaMin) / (numPoints - 1);
                const stripped = cleanExpr.replace(/^\s*r\s*=\s*/i, '');
                const compiled = this._compile(this.normalizeExpression(stripped));
                for (let i = 0; i < numPoints; i++) {
                    const theta = thetaMin + i * tStep;
                    try {
                        const r = compiled.evaluate({ theta });
                        if (typeof r === 'number' && isFinite(r)) {
                            rows.push({
                                theta: +theta.toFixed(4),
                                r: +r.toFixed(4),
                                x: +(r * Math.cos(theta)).toFixed(4),
                                y: +(r * Math.sin(theta)).toFixed(4)
                            });
                        } else {
                            rows.push({ theta: +theta.toFixed(4), r: 'undef', x: 'undef', y: 'undef' });
                        }
                    } catch (_) {
                        rows.push({ theta: +theta.toFixed(4), r: 'undef', x: 'undef', y: 'undef' });
                    }
                }
                return rows;
            }

            if (type === 'equation' || type === 'implicit') {
                // Equation: solve for y branches, show x, y₁, y₂, ...
                if (typeof nerdamer !== 'undefined' && cleanExpr.includes('=')) {
                    try {
                        const parts = cleanExpr.split('=');
                        const eqExpr = '(' + parts[0].trim() + ')-(' + parts[1].trim() + ')';
                        const ySolved = nerdamer.solve(eqExpr, 'y');
                        const yText = ySolved.text().replace(/^\[|\]$/g, '');
                        if (yText) {
                            const yExprs = yText.split(',').map(s => s.trim()).filter(Boolean);
                            const compiled = yExprs.map(ye => {
                                try { return math.compile(this.normalizeExpression(ye)); } catch(_) { return null; }
                            });
                            for (let i = 0; i < numPoints; i++) {
                                const x = xMin + i * step;
                                if (restriction && !this.evaluateDomainRestriction(restriction, x)) continue;
                                const row = { x: +x.toFixed(4) };
                                compiled.forEach((c, bi) => {
                                    const key = compiled.length === 1 ? 'y' : `y${bi + 1}`;
                                    if (!c) { row[key] = 'undef'; return; }
                                    try {
                                        const v = c.evaluate({ x });
                                        row[key] = (typeof v === 'number' && isFinite(v)) ? +v.toFixed(4) : 'undef';
                                    } catch (_) { row[key] = 'undef'; }
                                });
                                rows.push(row);
                            }
                            return rows;
                        }
                    } catch (_) { /* fall through to implicit grid */ }
                }
                // Implicit fallback: can't easily generate a simple table
                return null;
            }

            // Default: cartesian y = f(x)
            const stripped = this.stripCartesianPrefix(cleanExpr);
            const compiled = this._compile(this.normalizeExpression(stripped));
            for (let i = 0; i < numPoints; i++) {
                const x = xMin + i * step;
                if (restriction && !this.evaluateDomainRestriction(restriction, x)) continue;
                try {
                    const y = compiled.evaluate({ x });
                    if (typeof y === 'number' && isFinite(y)) {
                        rows.push({ x: +x.toFixed(4), y: +y.toFixed(4) });
                    } else {
                        rows.push({ x: +x.toFixed(4), y: 'undef' });
                    }
                } catch (_) {
                    rows.push({ x: +x.toFixed(4), y: 'undef' });
                }
            }
            return rows;
        } catch (error) {
            console.error('Error generating table of values:', error);
            return null;
        }
    }

    /**
     * Generate data for Cartesian plot (y = f(x))
     */
    generateCartesian(expression, xMin = -10, xMax = 10, numPoints = 500) {
        try {
            // Validate expression
            if (!expression || typeof expression !== 'string' || expression.trim() === '') {
                return null;
            }

            // Parse domain restriction if present: "x^2 {x > 0}"
            const { expr: rawExpr, restriction } = this.parseDomainRestriction(expression);

            let expr = this.normalizeExpression(rawExpr);
            expr = this.stripCartesianPrefix(expr);

            const x = [];
            const y = [];
            const step = (xMax - xMin) / numPoints;

            // Compile expression once
            const compiledExpr = this._compile(expr);

            for (let i = 0; i <= numPoints; i++) {
                const xVal = xMin + i * step;

                // Apply domain restriction
                if (restriction && !this.evaluateDomainRestriction(restriction, xVal)) {
                    x.push(xVal);
                    y.push(null);
                    continue;
                }

                try {
                    const yVal = compiledExpr.evaluate({ x: xVal });
                    if (typeof yVal === 'number' && isFinite(yVal)) {
                        x.push(xVal);
                        y.push(yVal);
                    } else {
                        x.push(xVal);
                        y.push(null);
                    }
                } catch (e) {
                    x.push(xVal);
                    y.push(null);
                }
            }

            // Asymptote detection: large jumps with sign change → insert null gap
            const asymptotes = [];
            const yValid = y.filter(v => v !== null && isFinite(v));
            let yRangeMax = -Infinity, yRangeMin = Infinity;
            for (let i = 0; i < yValid.length; i++) {
                if (yValid[i] > yRangeMax) yRangeMax = yValid[i];
                if (yValid[i] < yRangeMin) yRangeMin = yValid[i];
            }
            const yRange = (yValid.length > 0 ? yRangeMax - yRangeMin : 0) || 20;
            const jumpThreshold = yRange * 0.5;
            for (let i = 1; i < y.length; i++) {
                if (y[i] !== null && y[i-1] !== null) {
                    const dy = Math.abs(y[i] - y[i-1]);
                    // Large jump with sign change = likely asymptote
                    if (dy > jumpThreshold && y[i] * y[i-1] < 0) {
                        asymptotes.push((x[i] + x[i-1]) / 2);
                        y[i-1] = null; // break the line
                    }
                }
            }

            return { x, y, asymptotes };
        } catch (error) {
            console.error('Error generating Cartesian plot:', error);
            return null;
        }
    }

    /**
     * Calculate numerical integration (area under curve) using trapezoidal rule
     */
    numericalIntegration(expression, xMin, xMax, numPoints = 1000) {
        try {
            if (!expression || typeof expression !== 'string' || expression.trim() === '') {
                return null;
            }

            // Ensure even number of intervals for Simpson's rule
            if (numPoints % 2 !== 0) numPoints++;
            const compiledExpr = this._compile(this.normalizeExpression(this.stripCartesianPrefix(expression)));
            const step = (xMax - xMin) / numPoints;
            let area = 0;

            // Composite Simpson's 1/3 rule: ∫ ≈ h/3 [f(x0) + 4f(x1) + 2f(x2) + 4f(x3) + ... + f(xn)]
            for (let i = 0; i <= numPoints; i++) {
                const x = xMin + i * step;
                try {
                    const y = compiledExpr.evaluate({ x });
                    if (isFinite(y)) {
                        if (i === 0 || i === numPoints) {
                            area += y;
                        } else if (i % 2 === 1) {
                            area += 4 * y;
                        } else {
                            area += 2 * y;
                        }
                    }
                } catch (e) {
                    // Skip invalid points
                }
            }

            area = (area * step) / 3;

            // Generate points for shading
            const x = [];
            const y = [];
            for (let i = 0; i <= numPoints; i++) {
                const xVal = xMin + i * step;
                try {
                    const yVal = compiledExpr.evaluate({ x: xVal });
                    if (isFinite(yVal)) {
                        x.push(xVal);
                        y.push(yVal);
                    }
                } catch (e) {
                    // Skip
                }
            }

            return { area, x, y };
        } catch (error) {
            console.error('Error calculating integration:', error);
            return null;
        }
    }

    /**
     * Generate Riemann sum rectangles (or trapezoids) for visualisation.
     * @param {string} expression - math expression in x
     * @param {number} a - left bound
     * @param {number} b - right bound
     * @param {number} n - number of subdivisions
     * @param {'left'|'right'|'midpoint'|'trapezoidal'} method
     * @returns {{shapes: Array, area: number}|null}
     */
    generateRiemannSum(expression, a, b, n, method) {
        try {
            if (!expression || typeof expression !== 'string' || expression.trim() === '') return null;
            const compiled = this._compile(this.normalizeExpression(this.stripCartesianPrefix(expression)));
            const dx = (b - a) / n;
            const shapes = []; // each shape: {x: [...], y: [...]}
            let area = 0;

            const f = (xv) => {
                try {
                    const v = compiled.evaluate({ x: xv });
                    return isFinite(v) ? v : 0;
                } catch (_) { return 0; }
            };

            for (let i = 0; i < n; i++) {
                const xi = a + i * dx;
                const xi1 = xi + dx;

                if (method === 'trapezoidal') {
                    const yL = f(xi);
                    const yR = f(xi1);
                    shapes.push({ x: [xi, xi, xi1, xi1, xi], y: [0, yL, yR, 0, 0] });
                    area += (yL + yR) * dx / 2;
                } else {
                    let sampleX;
                    if (method === 'left') sampleX = xi;
                    else if (method === 'right') sampleX = xi1;
                    else /* midpoint */ sampleX = xi + dx / 2;
                    const h = f(sampleX);
                    shapes.push({ x: [xi, xi, xi1, xi1, xi], y: [0, h, h, 0, 0] });
                    area += h * dx;
                }
            }
            return { shapes, area };
        } catch (error) {
            console.error('Error generating Riemann sum:', error);
            return null;
        }
    }

    /**
     * Calculate derivative of expression using numerical differentiation
     */
    generateDerivative(expression, xMin = -10, xMax = 10, numPoints = 500) {
        try {
            if (!expression || typeof expression !== 'string' || expression.trim() === '') {
                return null;
            }

            const { expr: rawExpr, restriction } = this.parseDomainRestriction(expression);
            const x = [];
            const y = [];
            const step = (xMax - xMin) / numPoints;
            const h = 0.001;

            const compiledExpr = this._compile(this.normalizeExpression(this.stripCartesianPrefix(rawExpr)));

            for (let i = 0; i <= numPoints; i++) {
                const xVal = xMin + i * step;

                if (restriction && !this.evaluateDomainRestriction(restriction, xVal)) {
                    x.push(xVal); y.push(null); continue;
                }

                try {
                    const yPlus = compiledExpr.evaluate({ x: xVal + h });
                    const yMinus = compiledExpr.evaluate({ x: xVal - h });
                    const derivative = (yPlus - yMinus) / (2 * h);

                    if (isFinite(derivative)) {
                        x.push(xVal);
                        y.push(derivative);
                    } else {
                        x.push(xVal);
                        y.push(null);
                    }
                } catch (e) {
                    x.push(xVal);
                    y.push(null);
                }
            }

            return { x, y };
        } catch (error) {
            console.error('Error generating derivative:', error);
            return null;
        }
    }

    /**
     * Generate second derivative f''(x) using numerical differentiation
     */
    generateSecondDerivative(expression, xMin = -10, xMax = 10, numPoints = 500) {
        try {
            if (!expression || typeof expression !== 'string' || expression.trim() === '') return null;
            const { expr: rawExpr, restriction } = this.parseDomainRestriction(expression);
            const x = [];
            const y = [];
            const step = (xMax - xMin) / numPoints;
            const h = 0.001;
            const compiledExpr = this._compile(this.normalizeExpression(this.stripCartesianPrefix(rawExpr)));

            for (let i = 0; i <= numPoints; i++) {
                const xVal = xMin + i * step;
                if (restriction && !this.evaluateDomainRestriction(restriction, xVal)) {
                    x.push(xVal); y.push(null); continue;
                }
                try {
                    // f''(x) ≈ (f(x+h) - 2f(x) + f(x-h)) / h²
                    const yPlus = compiledExpr.evaluate({ x: xVal + h });
                    const yCenter = compiledExpr.evaluate({ x: xVal });
                    const yMinus = compiledExpr.evaluate({ x: xVal - h });
                    const d2 = (yPlus - 2 * yCenter + yMinus) / (h * h);
                    if (isFinite(d2)) { x.push(xVal); y.push(d2); }
                    else { x.push(xVal); y.push(null); }
                } catch (e) { x.push(xVal); y.push(null); }
            }
            return { x, y };
        } catch (error) {
            console.error('Error generating second derivative:', error);
            return null;
        }
    }

    /**
     * Find critical points where f'(x) ≈ 0 and classify as local min/max
     */
    findCriticalPoints(expression, xMin = -10, xMax = 10, numPoints = 1000) {
        try {
            if (!expression || typeof expression !== 'string' || expression.trim() === '') return [];
            const { expr: rawExpr, restriction } = this.parseDomainRestriction(expression);
            const compiledExpr = this._compile(this.normalizeExpression(this.stripCartesianPrefix(rawExpr)));
            const h = 0.0001;
            const step = (xMax - xMin) / numPoints;
            const points = [];

            const f = (xv) => { try { const v = compiledExpr.evaluate({ x: xv }); return isFinite(v) ? v : null; } catch (_) { return null; } };
            const fp = (xv) => { const a = f(xv + h), b = f(xv - h); return (a !== null && b !== null) ? (a - b) / (2 * h) : null; };
            const fpp = (xv) => { const a = f(xv + h), c = f(xv), b = f(xv - h); return (a !== null && c !== null && b !== null) ? (a - 2 * c + b) / (h * h) : null; };

            let prevDeriv = fp(xMin);
            for (let i = 1; i <= numPoints; i++) {
                const xVal = xMin + i * step;
                const curDeriv = fp(xVal);
                if (prevDeriv !== null && curDeriv !== null) {
                    // Detect critical point: sign change OR derivative ≈ 0 at grid point
                    const signChange = prevDeriv * curDeriv < 0;
                    const nearZero = Math.abs(curDeriv) < 1e-6 && (prevDeriv !== 0 || i === numPoints);
                    if (signChange || nearZero) {
                        let cx;
                        if (signChange) {
                            // Bisect to find precise zero
                            let lo = xVal - step, hi = xVal;
                            for (let j = 0; j < 50; j++) {
                                const mid = (lo + hi) / 2;
                                const midD = fp(mid);
                                if (midD === null) break;
                                if (midD * fp(lo) < 0) hi = mid; else lo = mid;
                            }
                            cx = (lo + hi) / 2;
                        } else {
                            cx = xVal; // already at/near zero
                        }
                        // Check domain restriction
                        if (restriction && !this.evaluateDomainRestriction(restriction, cx)) continue;
                        const cy = f(cx);
                        if (cy !== null && Math.abs(cy) < 1e8) {
                            const d2 = fpp(cx);
                            let type = 'critical';
                            if (d2 !== null && Math.abs(d2) < 1e8) {
                                if (d2 > 0.01) type = 'min';
                                else if (d2 < -0.01) type = 'max';
                            }
                            // Verify it's a real critical point: f'(cx) should be near zero
                            const fpAtCx = fp(cx);
                            if (fpAtCx !== null && Math.abs(fpAtCx) < 0.1) {
                                // Avoid duplicates
                                if (!points.some(p => Math.abs(p.x - cx) < step * 2)) {
                                    points.push({ x: cx, y: cy, type });
                                }
                            }
                        }
                    }
                }
                prevDeriv = curDeriv;
            }
            return points;
        } catch (error) {
            console.error('Error finding critical points:', error);
            return [];
        }
    }

    /**
     * Find inflection points where f''(x) changes sign
     */
    findInflectionPoints(expression, xMin = -10, xMax = 10, numPoints = 1000) {
        try {
            if (!expression || typeof expression !== 'string' || expression.trim() === '') return [];
            const { expr: rawExpr, restriction } = this.parseDomainRestriction(expression);
            const compiledExpr = this._compile(this.normalizeExpression(this.stripCartesianPrefix(rawExpr)));
            const h = 0.0001;
            const step = (xMax - xMin) / numPoints;
            const points = [];

            const f = (xv) => { try { const v = compiledExpr.evaluate({ x: xv }); return isFinite(v) ? v : null; } catch (_) { return null; } };
            const fpp = (xv) => { const a = f(xv + h), c = f(xv), b = f(xv - h); return (a !== null && c !== null && b !== null) ? (a - 2 * c + b) / (h * h) : null; };

            let prevD2 = fpp(xMin);
            for (let i = 1; i <= numPoints; i++) {
                const xVal = xMin + i * step;
                const curD2 = fpp(xVal);
                if (prevD2 !== null && curD2 !== null && prevD2 * curD2 < 0) {
                    // Bisect
                    let lo = xVal - step, hi = xVal;
                    for (let j = 0; j < 50; j++) {
                        const mid = (lo + hi) / 2;
                        const midD2 = fpp(mid);
                        if (midD2 === null) break;
                        if (midD2 * fpp(lo) < 0) hi = mid; else lo = mid;
                    }
                    const ix = (lo + hi) / 2;
                    const iy = f(ix);
                    if (iy !== null && (!restriction || this.evaluateDomainRestriction(restriction, ix)) && !points.some(p => Math.abs(p.x - ix) < step * 2)) {
                        points.push({ x: ix, y: iy });
                    }
                }
                prevD2 = curD2;
            }
            return points;
        } catch (error) {
            console.error('Error finding inflection points:', error);
            return [];
        }
    }

    /**
     * Detect horizontal and oblique asymptotes by evaluating limits at large |x|
     */
    findHorizontalAsymptotes(expression, xMin = -10, xMax = 10) {
        try {
            if (!expression || typeof expression !== 'string' || expression.trim() === '') return [];
            const { expr: rawExpr, restriction } = this.parseDomainRestriction(expression);
            const compiledExpr = this._compile(this.normalizeExpression(this.stripCartesianPrefix(rawExpr)));
            const asymptotes = [];

            const f = (xv) => {
                try {
                    if (restriction && !this.evaluateDomainRestriction(restriction, xv)) return null;
                    const v = compiledExpr.evaluate({ x: xv });
                    return isFinite(v) ? v : null;
                } catch (_) { return null; }
            };

            // Check limits at +∞ and -∞ using large x values
            for (const sign of [1, -1]) {
                const vals = [1000, 5000, 10000, 50000].map(v => f(sign * v));
                if (vals.every(v => v !== null)) {
                    // Check if converging to a constant (horizontal asymptote)
                    const spread = Math.abs(vals[3] - vals[0]);
                    if (spread < 0.01) {
                        const yAsym = vals[3];
                        // Avoid duplicate
                        if (!asymptotes.some(a => a.type === 'horizontal' && Math.abs(a.y - yAsym) < 0.01)) {
                            asymptotes.push({ type: 'horizontal', y: yAsym, direction: sign > 0 ? '+∞' : '-∞' });
                        }
                    } else {
                        // Check for oblique: y/x converging (slope m = lim f(x)/x)
                        const slopes = [1000, 5000, 10000, 50000].map((v, i) => vals[i] / (sign * v));
                        const slopeSpread = Math.abs(slopes[3] - slopes[0]);
                        if (slopeSpread < 0.001 && Math.abs(slopes[3]) > 0.001) {
                            const m = slopes[3];
                            // Intercept: lim (f(x) - mx) as x→±∞
                            const intercepts = [1000, 5000, 10000, 50000].map((v, i) => vals[i] - m * (sign * v));
                            const intSpread = Math.abs(intercepts[3] - intercepts[0]);
                            if (intSpread < 0.1) {
                                const b = intercepts[3];
                                if (!asymptotes.some(a => a.type === 'oblique' && Math.abs(a.m - m) < 0.01 && Math.abs(a.b - b) < 0.1)) {
                                    asymptotes.push({ type: 'oblique', m, b, direction: sign > 0 ? '+∞' : '-∞' });
                                }
                            }
                        }
                    }
                }
            }
            return asymptotes;
        } catch (error) {
            console.error('Error finding horizontal asymptotes:', error);
            return [];
        }
    }

    /**
     * Find vertical asymptotes by detecting where |f(x)| → ∞ (sign change in 1/f or f jumps).
     */
    findVerticalAsymptotes(expression, xMin = -10, xMax = 10, numPoints = 2000) {
        try {
            if (!expression || typeof expression !== 'string' || expression.trim() === '') return [];
            const { expr: rawExpr, restriction } = this.parseDomainRestriction(expression);
            const compiled = this._compile(this.normalizeExpression(this.stripCartesianPrefix(rawExpr)));
            const asymptotes = [];
            const step = (xMax - xMin) / numPoints;

            let prevY = null;
            let prevX = null;
            for (let i = 0; i <= numPoints; i++) {
                const x = xMin + i * step;
                if (restriction && !this.evaluateDomainRestriction(restriction, x)) { prevY = null; continue; }
                try {
                    const y = compiled.evaluate({ x });
                    if (prevY !== null && isFinite(prevY)) {
                        // Detect large jump (potential vertical asymptote):
                        // 1. y is non-finite (Infinity/NaN)
                        // 2. Sign change with large values on both sides
                        // 3. Sudden jump where |y - prevY| >> |prevY| (catches 1/x at x=0)
                        const bigJump = isFinite(y) && Math.abs(prevY) > 0.01 && Math.abs(y / prevY) > 1000 && Math.sign(y) !== Math.sign(prevY);
                        if (!isFinite(y) || bigJump || (Math.abs(y) > 1e6 && Math.abs(prevY) > 1e6 && Math.sign(y) !== Math.sign(prevY))) {
                            // Bisect to refine the x location
                            let lo = prevX, hi = x;
                            for (let b = 0; b < 30; b++) {
                                const mid = (lo + hi) / 2;
                                try {
                                    const ym = compiled.evaluate({ x: mid });
                                    if (!isFinite(ym) || Math.abs(ym) > 1e10) { hi = mid; }
                                    else if (Math.abs(ym) > Math.abs(prevY) * 2) { lo = mid; }
                                    else { lo = mid; }
                                } catch (_) { hi = mid; }
                            }
                            const xAsym = +((lo + hi) / 2).toFixed(6);
                            // Avoid duplicates
                            if (!asymptotes.some(a => Math.abs(a.x - xAsym) < step * 2)) {
                                asymptotes.push({ x: xAsym });
                            }
                        }
                    }
                    prevY = y;
                    prevX = x;
                } catch (_) {
                    // Evaluation error often means asymptote (e.g., division by zero)
                    if (prevY !== null && isFinite(prevY)) {
                        const xAsym = +((prevX + x) / 2).toFixed(6);
                        if (!asymptotes.some(a => Math.abs(a.x - xAsym) < step * 2)) {
                            asymptotes.push({ x: xAsym });
                        }
                    }
                    prevY = null;
                    prevX = x;
                }
            }
            return asymptotes;
        } catch (error) {
            console.error('Error finding vertical asymptotes:', error);
            return [];
        }
    }

    /**
     * Find roots (x-intercepts) of f(x) = 0 using sign-change detection + bisection.
     */
    findRoots(expression, xMin = -10, xMax = 10, numPoints = 1000) {
        try {
            if (!expression || typeof expression !== 'string' || expression.trim() === '') return [];
            const { expr: rawExpr, restriction } = this.parseDomainRestriction(expression);
            const compiled = this._compile(this.normalizeExpression(this.stripCartesianPrefix(rawExpr)));
            const roots = [];
            const step = (xMax - xMin) / numPoints;

            const f = (xv) => {
                if (restriction && !this.evaluateDomainRestriction(restriction, xv)) return null;
                try { const v = compiled.evaluate({ x: xv }); return isFinite(v) ? v : null; } catch (_) { return null; }
            };

            let prevVal = f(xMin);
            for (let i = 1; i <= numPoints; i++) {
                const x = xMin + i * step;
                const val = f(x);
                if (val === null) { prevVal = null; continue; }

                // Near-zero detection
                if (Math.abs(val) < 1e-10) {
                    if (!roots.some(r => Math.abs(r.x - x) < step * 2)) {
                        roots.push({ x: +x.toFixed(6), y: 0 });
                    }
                    prevVal = val; continue;
                }

                // Sign change → bisect
                if (prevVal !== null && prevVal * val < 0) {
                    let lo = x - step, hi = x;
                    for (let b = 0; b < 50; b++) {
                        const mid = (lo + hi) / 2;
                        const fm = f(mid);
                        if (fm === null) break;
                        if (Math.abs(fm) < 1e-12) { lo = hi = mid; break; }
                        if (fm * f(lo) < 0) hi = mid; else lo = mid;
                    }
                    const rx = +((lo + hi) / 2).toFixed(6);
                    if (!roots.some(r => Math.abs(r.x - rx) < step * 2)) {
                        roots.push({ x: rx, y: 0 });
                    }
                }
                prevVal = val;
            }
            return roots;
        } catch (error) {
            console.error('Error finding roots:', error);
            return [];
        }
    }

    /**
     * Compute tangent line at a given x-value: y = f'(a)(x - a) + f(a)
     * Returns { slope, intercept, x0, y0, equation }
     */
    tangentLineAt(expression, x0, xMin = -10, xMax = 10) {
        try {
            if (!expression || typeof expression !== 'string') return null;
            const { expr: rawExpr, restriction } = this.parseDomainRestriction(expression);
            const compiled = this._compile(this.normalizeExpression(this.stripCartesianPrefix(rawExpr)));

            if (restriction && !this.evaluateDomainRestriction(restriction, x0)) return null;

            const y0 = compiled.evaluate({ x: x0 });
            if (!isFinite(y0)) return null;

            // Central difference for derivative
            const h = 1e-7;
            const yp = compiled.evaluate({ x: x0 + h });
            const ym = compiled.evaluate({ x: x0 - h });
            if (!isFinite(yp) || !isFinite(ym)) return null;
            const slope = (yp - ym) / (2 * h);

            const intercept = y0 - slope * x0;
            const eq = `y = ${slope.toFixed(4)}(x - ${x0.toFixed(4)}) + ${y0.toFixed(4)}`;

            // Generate line points across the range
            const lineX = [xMin, xMax];
            const lineY = [slope * xMin + intercept, slope * xMax + intercept];

            return { slope, intercept, x0, y0: +y0.toFixed(6), equation: eq, lineX, lineY };
        } catch (error) {
            console.error('Error computing tangent line:', error);
            return null;
        }
    }

    /**
     * Generate symbolic antiderivative F(x) using Nerdamer
     */
    generateAntiderivative(expression, xMin = -10, xMax = 10, numPoints = 500) {
        try {
            if (typeof nerdamer === 'undefined') return null;
            if (!expression || typeof expression !== 'string' || expression.trim() === '') return null;

            const expr = this.stripCartesianPrefix(this.normalizeExpression(expression));
            const antideriv = nerdamer('integrate(' + expr + ', x)');
            const antiText = antideriv.text();
            if (!antiText) return null;

            const x = [], y = [];
            const step = (xMax - xMin) / numPoints;

            for (let i = 0; i <= numPoints; i++) {
                const xVal = xMin + i * step;
                try {
                    nerdamer.setVar('x', String(xVal));
                    const yVal = parseFloat(nerdamer(antiText).evaluate().text());
                    nerdamer.clearVars();
                    if (isFinite(yVal)) { x.push(xVal); y.push(yVal); }
                    else { x.push(xVal); y.push(null); }
                } catch (_) {
                    nerdamer.clearVars();
                    x.push(xVal); y.push(null);
                }
            }

            return { x, y, symbolic: antiText };
        } catch (error) {
            console.error('Error generating antiderivative:', error);
            return null;
        }
    }

    /**
     * SymPy fallback for antiderivative when Nerdamer fails.
     * Returns a Promise that resolves to { x, y, symbolic } or null.
     */
    generateAntiderivativeSymPy(expression, xMin = -10, xMax = 10, numPoints = 500) {
        const pyExpr = GraphingEngine._toPython(this.stripCartesianPrefix(this.normalizeExpression(expression)));
        const code =
            'from sympy import *\n' +
            'import json\n' +
            'x = symbols("x")\n' +
            'try:\n' +
            '    expr = ' + pyExpr + '\n' +
            '    F = integrate(expr, x)\n' +
            '    sym = str(F)\n' +
            '    xs = [' + xMin + ' + i*' + ((xMax - xMin) / numPoints) + ' for i in range(' + (numPoints + 1) + ')]\n' +
            '    ys = []\n' +
            '    for xv in xs:\n' +
            '        try:\n' +
            '            yv = float(F.subs(x, xv))\n' +
            '            ys.append(yv if abs(yv) < 1e15 else None)\n' +
            '        except: ys.append(None)\n' +
            '    print("ANTI:" + json.dumps({"symbolic": sym, "x": xs, "y": ys}))\n' +
            'except Exception as e:\n' +
            '    print("ERROR:" + str(e))';
        return this._sympyExec(code).then(stdout => {
            const m = stdout.match(/ANTI:([\s\S]*)/);
            if (!m) return null;
            try {
                const data = JSON.parse(m[1].trim());
                return { x: data.x, y: data.y, symbolic: data.symbolic };
            } catch (e) { return null; }
        });
    }

    /**
     * Evaluate a limit using Nerdamer: limit(expr, variable, value)
     */
    evaluateLimit(expression, variable, value) {
        try {
            if (typeof nerdamer === 'undefined') return null;
            const expr = this.normalizeExpression(expression);
            const result = nerdamer('limit(' + expr + ', ' + variable + ', ' + value + ')');
            const text = result.text();
            const numVal = parseFloat(nerdamer(text).evaluate().text());
            return { symbolic: text, numeric: isFinite(numVal) ? numVal : null };
        } catch (error) {
            console.error('Error evaluating limit:', error);
            return null;
        }
    }

    /**
     * SymPy fallback for limit evaluation.
     * Returns a Promise that resolves to { symbolic, numeric } or null.
     */
    evaluateLimitSymPy(expression, variable, value) {
        const pyExpr = GraphingEngine._toPython(this.normalizeExpression(expression));
        // Handle ±infinity
        let pyVal = String(value).trim();
        if (pyVal === 'Infinity' || pyVal === 'inf' || pyVal === '∞') pyVal = 'oo';
        else if (pyVal === '-Infinity' || pyVal === '-inf' || pyVal === '-∞') pyVal = '-oo';
        const code =
            'from sympy import *\n' +
            'import json\n' +
            variable + ' = symbols("' + variable + '")\n' +
            'try:\n' +
            '    expr = ' + pyExpr + '\n' +
            '    L = limit(expr, ' + variable + ', ' + pyVal + ')\n' +
            '    sym = str(L)\n' +
            '    try: num = float(L)\n' +
            '    except: num = None\n' +
            '    print("LIMIT:" + json.dumps({"symbolic": sym, "numeric": num}))\n' +
            'except Exception as e:\n' +
            '    print("ERROR:" + str(e))';
        return this._sympyExec(code).then(stdout => {
            const m = stdout.match(/LIMIT:([\s\S]*)/);
            if (!m) return null;
            try {
                const data = JSON.parse(m[1].trim());
                return { symbolic: data.symbolic, numeric: data.numeric };
            } catch (e) { return null; }
        });
    }

    /**
     * Calculate tangent line at specific point
     */
    calculateTangent(expression, xPoint, xMin = -10, xMax = 10) {
        try {
            const compiledExpr = math.compile(this.normalizeExpression(this.stripCartesianPrefix(expression)));
            const h = 0.001;

            // Calculate y value at point
            const yPoint = compiledExpr.evaluate({ x: xPoint });

            // Calculate derivative (slope) at point
            const yPlus = compiledExpr.evaluate({ x: xPoint + h });
            const yMinus = compiledExpr.evaluate({ x: xPoint - h });
            const slope = (yPlus - yMinus) / (2 * h);

            // Generate tangent line: y - y0 = m(x - x0)
            // y = m(x - x0) + y0
            const x = [xMin, xMax];
            const y = [
                slope * (xMin - xPoint) + yPoint,
                slope * (xMax - xPoint) + yPoint
            ];

            return { x, y, slope, point: { x: xPoint, y: yPoint } };
        } catch (error) {
            console.error('Error calculating tangent:', error);
            return null;
        }
    }

    /**
     * Generate data for Parametric plot (x(t), y(t))
     */
    generateParametric(xExpr, yExpr, tMin = 0, tMax = 2 * Math.PI, numPoints = 500) {
        try {
            // Validate expressions
            if (!xExpr || !yExpr || typeof xExpr !== 'string' || typeof yExpr !== 'string') {
                return null;
            }

            const xCompiled = math.compile(this.normalizeExpression(xExpr.trim()));
            const yCompiled = math.compile(this.normalizeExpression(yExpr.trim()));

            const x = [];
            const y = [];
            const step = (tMax - tMin) / numPoints;

            for (let i = 0; i <= numPoints; i++) {
                const t = tMin + i * step;

                try {
                    const xVal = xCompiled.evaluate({ t: t });
                    const yVal = yCompiled.evaluate({ t: t });

                    if (isFinite(xVal) && isFinite(yVal)) {
                        x.push(xVal);
                        y.push(yVal);
                    }
                } catch (e) {
                    // Skip invalid points
                }
            }

            return { x, y };
        } catch (error) {
            console.error('Error generating Parametric plot:', error);
            return null;
        }
    }

    /**
     * Generate data for Polar plot (r(θ))
     */
    generatePolar(expression, thetaMin = 0, thetaMax = 2 * Math.PI, numPoints = 500) {
        try {
            // Validate expression
            if (!expression || typeof expression !== 'string' || expression.trim() === '') {
                return null;
            }
            // Strip "r = " prefix if present
            let cleaned = expression.replace(/^\s*r\s*=\s*/i, '');
            const compiledExpr = math.compile(this.normalizeExpression(cleaned));

            const x = [];
            const y = [];
            const step = (thetaMax - thetaMin) / numPoints;

            for (let i = 0; i <= numPoints; i++) {
                const theta = thetaMin + i * step;

                try {
                    const r = compiledExpr.evaluate({
                        theta: theta,
                        θ: theta  // Support both theta and θ
                    });

                    if (isFinite(r)) {
                        x.push(r * Math.cos(theta));
                        y.push(r * Math.sin(theta));
                    }
                } catch (e) {
                    // Skip invalid points
                }
            }

            return { x, y };
        } catch (error) {
            console.error('Error generating Polar plot:', error);
            return null;
        }
    }

    /**
     * Generate data for Implicit Functions (e.g., x^2 + y^2 = 25)
     */
    generateImplicit(expression, xMin = -10, xMax = 10, yMin = -10, yMax = 10, resolution = 400) {
        try {
            // Parse expression like "x^2 + y^2 = 25" into left - right = 0
            let leftExpr, rightExpr;

            if (expression.includes('=')) {
                const parts = expression.split('=');
                leftExpr = parts[0].trim();
                rightExpr = parts[1].trim();
            } else {
                leftExpr = expression.trim();
                rightExpr = '0';
            }

            const leftCompiled = math.compile(this.normalizeExpression(leftExpr));
            const rightCompiled = math.compile(this.normalizeExpression(rightExpr));

            const xStep = (xMax - xMin) / resolution;
            const yStep = (yMax - yMin) / resolution;

            // Evaluate f(x,y) = left - right on the grid
            const grid = [];
            for (let i = 0; i <= resolution; i++) {
                const row = [];
                for (let j = 0; j <= resolution; j++) {
                    const xVal = xMin + j * xStep;
                    const yVal = yMin + i * yStep;
                    try {
                        const scope = { x: xVal, y: yVal };
                        const diff = leftCompiled.evaluate(scope) - rightCompiled.evaluate(scope);
                        row.push(isFinite(diff) ? diff : NaN);
                    } catch (_) {
                        row.push(NaN);
                    }
                }
                grid.push(row);
            }

            // Marching squares with line segments — produces connected contour lines.
            // Each cell with a sign change yields one or two line segments.
            // Edge interpolation points (indexed 0-3: bottom, right, top, left):
            const xs = [], ys = [];
            const interp = (v1, v2, p1, p2) => p1 + (p2 - p1) * v1 / (v1 - v2);

            for (let i = 0; i < resolution; i++) {
                for (let j = 0; j < resolution; j++) {
                    const z00 = grid[i][j], z10 = grid[i][j+1];
                    const z01 = grid[i+1][j], z11 = grid[i+1][j+1];
                    if (isNaN(z00) || isNaN(z10) || isNaN(z01) || isNaN(z11)) continue;

                    const x0 = xMin + j * xStep, x1 = x0 + xStep;
                    const y0 = yMin + i * yStep, y1 = y0 + yStep;

                    // Classify corners: 0 = negative, 1 = positive
                    const config = (z00 > 0 ? 1 : 0) | (z10 > 0 ? 2 : 0) |
                                   (z11 > 0 ? 4 : 0) | (z01 > 0 ? 8 : 0);
                    if (config === 0 || config === 15) continue;

                    // Interpolated edge points
                    const bottom = [interp(z00, z10, x0, x1), y0];
                    const right  = [x1, interp(z10, z11, y0, y1)];
                    const top    = [interp(z01, z11, x0, x1), y1];
                    const left   = [x0, interp(z00, z01, y0, y1)];

                    // Marching squares lookup — each config yields 1 or 2 segments
                    const segments = [];
                    switch (config) {
                        case 1: case 14: segments.push([bottom, left]); break;
                        case 2: case 13: segments.push([bottom, right]); break;
                        case 3: case 12: segments.push([left, right]); break;
                        case 4: case 11: segments.push([right, top]); break;
                        case 5: segments.push([bottom, right], [left, top]); break;
                        case 6: case 9:  segments.push([bottom, top]); break;
                        case 7: case 8:  segments.push([left, top]); break;
                        case 10: segments.push([bottom, left], [right, top]); break;
                    }

                    // Add segments separated by null (gap) for Plotly disconnected lines
                    for (const seg of segments) {
                        xs.push(seg[0][0], seg[1][0], null);
                        ys.push(seg[0][1], seg[1][1], null);
                    }
                }
            }

            return xs.length > 0 ? { x: xs, y: ys, mode: 'lines' } : null;
        } catch (error) {
            console.error('Error generating implicit function:', error);
            return null;
        }
    }

    /**
     * Generate data for Piecewise Functions
     */
    generatePiecewise(pieces, xMin = -10, xMax = 10, numPoints = 500) {
        try {
            if (!pieces || pieces.length === 0) {
                return null;
            }

            // Substitute global scope variables into piece expressions and conditions
            var resolvedPieces = pieces;
            if (this.globalScope && Object.keys(this.globalScope).length > 0) {
                resolvedPieces = pieces.map(p => {
                    var expr = p.expression, cond = p.condition;
                    Object.keys(this.globalScope).forEach(v => {
                        if (typeof this.globalScope[v] === 'number') {
                            var re = new RegExp('\\b' + v + '\\b', 'g');
                            expr = expr.replace(re, '(' + this.globalScope[v] + ')');
                            if (cond) cond = cond.replace(re, '(' + this.globalScope[v] + ')');
                        }
                    });
                    return { expression: expr, condition: cond };
                });
            }

            const x = [];
            const y = [];
            const step = (xMax - xMin) / numPoints;

            for (let i = 0; i <= numPoints; i++) {
                const xVal = xMin + i * step;
                let yVal = null;

                // Find which piece applies to this x value
                for (const piece of resolvedPieces) {
                    const { expression, condition } = piece;

                    try {
                        // Evaluate condition
                        const conditionMet = this.evaluateCondition(xVal, condition);

                        if (conditionMet) {
                            const compiled = math.compile(this.normalizeExpression(expression));
                            yVal = compiled.evaluate({ x: xVal });
                            break;
                        }
                    } catch (e) {
                        // Skip
                    }
                }

                if (yVal !== null && isFinite(yVal)) {
                    x.push(xVal);
                    y.push(yVal);
                } else {
                    x.push(xVal);
                    y.push(null);
                }
            }

            return { x, y };
        } catch (error) {
            console.error('Error generating piecewise function:', error);
            return null;
        }
    }

    /**
     * Evaluate piecewise condition (e.g., "x < 0", "x >= -2 and x < 2")
     */
    evaluateCondition(xVal, condition) {
        try {
            if (!condition || condition === 'true' || condition.trim() === '') {
                return true; // Default condition
            }

            // Math.js supports 'and' / 'or' natively; convert '&&' / '||' to those
            let cond = condition.replace(/&&/g, ' and ').replace(/\|\|/g, ' or ');

            // Create a safe evaluation context
            const scope = { x: xVal };
            const compiled = math.compile(cond);
            const result = compiled.evaluate(scope);

            return Boolean(result);
        } catch (e) {
            console.error('Error evaluating condition:', e);
            return false;
        }
    }

    /**
     * Generate data for Inequality (y > f(x), y < f(x), etc.)
     */
    generateInequality(leftExpr, operator, rightExpr, xMin = -10, xMax = 10, yMin = -10, yMax = 10, resolution = 100) {
        try {
            // Validate expressions
            if (!leftExpr || !rightExpr || typeof leftExpr !== 'string' || typeof rightExpr !== 'string') {
                return null;
            }

            const leftCompiled = math.compile(this.normalizeExpression(leftExpr.trim()));
            const rightCompiled = math.compile(this.normalizeExpression(rightExpr.trim()));

            const x = [];
            const y = [];
            const z = [];

            const xStep = (xMax - xMin) / resolution;
            const yStep = (yMax - yMin) / resolution;

            for (let i = 0; i <= resolution; i++) {
                const xRow = [];
                const yRow = [];
                const zRow = [];

                for (let j = 0; j <= resolution; j++) {
                    const xVal = xMin + j * xStep;
                    const yVal = yMin + i * yStep;
                    const scope = { x: xVal, y: yVal };

                    try {
                        const leftVal = leftCompiled.evaluate(scope);
                        const rightVal = rightCompiled.evaluate(scope);

                        let satisfies = false;
                        switch (operator) {
                            case '>': satisfies = leftVal > rightVal; break;
                            case '<': satisfies = leftVal < rightVal; break;
                            case '>=': satisfies = leftVal >= rightVal; break;
                            case '<=': satisfies = leftVal <= rightVal; break;
                            case '=': satisfies = Math.abs(leftVal - rightVal) < 0.1; break;
                        }

                        xRow.push(xVal);
                        yRow.push(yVal);
                        zRow.push(satisfies ? 1 : 0);
                    } catch (e) {
                        xRow.push(xVal);
                        yRow.push(yVal);
                        zRow.push(0);
                    }
                }

                x.push(xRow);
                y.push(yRow);
                z.push(zRow);
            }

            return { x, y, z };
        } catch (error) {
            console.error('Error generating Inequality:', error);
            return null;
        }
    }

    /**
     * Parse table data (comma or newline separated x,y pairs)
     */
    parseTableData(text) {
        try {
            const x = [];
            const y = [];

            // Split by newlines or semicolons
            const rows = text.split(/[\n;]/).filter(r => r.trim());

            for (const row of rows) {
                // Split by comma or space
                const values = row.split(/[,\s]+/).map(v => parseFloat(v.trim()));

                if (values.length >= 2 && isFinite(values[0]) && isFinite(values[1])) {
                    x.push(values[0]);
                    y.push(values[1]);
                }
            }

            return { x, y };
        } catch (error) {
            console.error('Error parsing table data:', error);
            return null;
        }
    }

    /**
     * Statistical Distribution Functions
     */

    // Normal (Gaussian) Distribution PDF
    normalDistribution(x, mean = 0, stdDev = 1) {
        const coefficient = 1 / (stdDev * Math.sqrt(2 * Math.PI));
        const exponent = -Math.pow(x - mean, 2) / (2 * Math.pow(stdDev, 2));
        return coefficient * Math.exp(exponent);
    }

    // Chi-squared Distribution PDF
    chiSquaredDistribution(x, k) {
        if (x <= 0) return 0;
        const numerator = Math.pow(x, k/2 - 1) * Math.exp(-x/2);
        const denominator = Math.pow(2, k/2) * this.gamma(k/2);
        return numerator / denominator;
    }

    // Uniform Distribution PDF
    uniformDistribution(x, a = 0, b = 1) {
        if (x < a || x > b) return 0;
        return 1 / (b - a);
    }

    // Exponential Distribution PDF
    exponentialDistribution(x, lambda = 1) {
        if (x < 0) return 0;
        return lambda * Math.exp(-lambda * x);
    }

    // Binomial Distribution PMF
    binomialDistribution(k, n, p) {
        if (k < 0 || k > n) return 0;
        return this.binomialCoefficient(n, k) * Math.pow(p, k) * Math.pow(1 - p, n - k);
    }

    // Poisson Distribution PMF
    poissonDistribution(k, lambda) {
        if (k < 0) return 0;
        return (Math.pow(lambda, k) * Math.exp(-lambda)) / this.factorial(k);
    }

    // Student's t-distribution PDF
    tDistribution(x, df) {
        const numerator = this.gamma((df + 1) / 2);
        const denominator = Math.sqrt(df * Math.PI) * this.gamma(df / 2);
        const factor = Math.pow(1 + (x * x) / df, -(df + 1) / 2);
        return (numerator / denominator) * factor;
    }

    // Beta Distribution PDF
    betaDistribution(x, alpha, beta) {
        if (x <= 0 || x >= 1) return 0;
        const numerator = Math.pow(x, alpha - 1) * Math.pow(1 - x, beta - 1);
        const denominator = this.betaFunction(alpha, beta);
        return numerator / denominator;
    }

    // Gamma Distribution PDF
    gammaDistribution(x, shape, scale = 1) {
        if (x <= 0) return 0;
        const numerator = Math.pow(x, shape - 1) * Math.exp(-x / scale);
        const denominator = Math.pow(scale, shape) * this.gamma(shape);
        return numerator / denominator;
    }

    // Helper: Factorial
    factorial(n) {
        if (n <= 1) return 1;
        let result = 1;
        for (let i = 2; i <= n; i++) {
            result *= i;
        }
        return result;
    }

    // Helper: Binomial Coefficient
    binomialCoefficient(n, k) {
        return this.factorial(n) / (this.factorial(k) * this.factorial(n - k));
    }

    // Helper: Gamma function (Stirling's approximation)
    gamma(z) {
        if (z === 1) return 1;
        if (z === 0.5) return Math.sqrt(Math.PI);

        // Lanczos approximation
        const g = 7;
        const C = [
            0.99999999999980993,
            676.5203681218851,
            -1259.1392167224028,
            771.32342877765313,
            -176.61502916214059,
            12.507343278686905,
            -0.13857109526572012,
            9.9843695780195716e-6,
            1.5056327351493116e-7
        ];

        if (z < 0.5) {
            return Math.PI / (Math.sin(Math.PI * z) * this.gamma(1 - z));
        }

        z -= 1;
        let x = C[0];
        for (let i = 1; i < g + 2; i++) {
            x += C[i] / (z + i);
        }

        const t = z + g + 0.5;
        return Math.sqrt(2 * Math.PI) * Math.pow(t, z + 0.5) * Math.exp(-t) * x;
    }

    // Helper: Beta function
    betaFunction(alpha, beta) {
        return (this.gamma(alpha) * this.gamma(beta)) / this.gamma(alpha + beta);
    }

    /**
     * Generate 3D surface data for z = f(x,y)
     */
    generateSurface(expression, xMin = -5, xMax = 5, yMin = -5, yMax = 5, resolution = 60) {
        try {
            if (!expression || typeof expression !== 'string') return null;
            let expr = expression.trim().replace(/^\s*z\s*=\s*/i, '');
            const compiled = math.compile(this.normalizeExpression(expr));

            const xArr = [], yArr = [], zGrid = [];
            const xStep = (xMax - xMin) / resolution;
            const yStep = (yMax - yMin) / resolution;

            for (let i = 0; i <= resolution; i++) {
                xArr.push(xMin + i * xStep);
            }
            for (let j = 0; j <= resolution; j++) {
                yArr.push(yMin + j * yStep);
            }

            for (let j = 0; j <= resolution; j++) {
                const row = [];
                for (let i = 0; i <= resolution; i++) {
                    try {
                        const zVal = compiled.evaluate({ x: xArr[i], y: yArr[j] });
                        row.push(typeof zVal === 'number' && isFinite(zVal) ? zVal : null);
                    } catch (_) {
                        row.push(null);
                    }
                }
                zGrid.push(row);
            }

            return { x: xArr, y: yArr, z: zGrid };
        } catch (error) {
            console.error('Error generating surface:', error);
            return null;
        }
    }

    /**
     * Generate distribution data
     */
    generateDistribution(type, params, xMin, xMax, numPoints = 500) {
        const x = [];
        const y = [];

        // For discrete distributions (binomial, poisson)
        if (type === 'binomial' || type === 'poisson') {
            const maxK = type === 'binomial' ? params.n : Math.ceil(params.lambda * 3);
            for (let k = 0; k <= maxK; k++) {
                x.push(k);
                if (type === 'binomial') {
                    y.push(this.binomialDistribution(k, params.n, params.p));
                } else {
                    y.push(this.poissonDistribution(k, params.lambda));
                }
            }
            return { x, y, discrete: true };
        }

        // For continuous distributions
        const step = (xMax - xMin) / numPoints;

        for (let i = 0; i <= numPoints; i++) {
            const xVal = xMin + i * step;
            let yVal = 0;

            switch (type) {
                case 'normal':
                    yVal = this.normalDistribution(xVal, params.mean, params.stdDev);
                    break;
                case 'chi2':
                    yVal = this.chiSquaredDistribution(xVal, params.k);
                    break;
                case 'uniform':
                    yVal = this.uniformDistribution(xVal, params.a, params.b);
                    break;
                case 'exponential':
                    yVal = this.exponentialDistribution(xVal, params.lambda);
                    break;
                case 't':
                    yVal = this.tDistribution(xVal, params.df);
                    break;
                case 'beta':
                    yVal = this.betaDistribution(xVal, params.alpha, params.beta);
                    break;
                case 'gamma':
                    yVal = this.gammaDistribution(xVal, params.shape, params.scale);
                    break;
            }

            // Only add points with valid, non-zero y values (to avoid invisible flat lines)
            if (isFinite(yVal) && yVal > 1e-10) {
                x.push(xVal);
                y.push(yVal);
            }
        }

        return { x, y, discrete: false };
    }

    /**
     * Find intersection points between two expressions
     */
    findIntersections(expr1, expr2, xMin = -10, xMax = 10, tolerance = 0.01) {
        try {
            const compiled1 = math.compile(this.normalizeExpression(this.stripCartesianPrefix(expr1)));
            const compiled2 = math.compile(this.normalizeExpression(this.stripCartesianPrefix(expr2)));
            const intersections = [];
            const numSamples = 1000;
            const step = (xMax - xMin) / numSamples;

            let prevSign = null;

            for (let i = 0; i <= numSamples; i++) {
                const x = xMin + i * step;

                try {
                    const y1 = compiled1.evaluate({ x });
                    const y2 = compiled2.evaluate({ x });
                    const diff = y1 - y2;

                    if (!isFinite(diff)) continue;

                    const currentSign = Math.sign(diff);

                    // Check for sign change (indicates intersection)
                    if (prevSign !== null && prevSign !== currentSign && currentSign !== 0) {
                        // Use bisection method to refine intersection
                        const intersection = this.bisectionMethod(
                            compiled1, compiled2,
                            x - step, x,
                            tolerance
                        );

                        if (intersection) {
                            intersections.push(intersection);
                        }
                    }

                    // Check for exact zero
                    if (Math.abs(diff) < tolerance) {
                        const y = compiled1.evaluate({ x });
                        intersections.push({ x, y });
                    }

                    prevSign = currentSign;
                } catch (e) {
                    // Skip points where evaluation fails
                }
            }

            // Remove duplicate points
            const unique = [];
            for (const point of intersections) {
                const isDuplicate = unique.some(p =>
                    Math.abs(p.x - point.x) < tolerance * 10
                );
                if (!isDuplicate) {
                    unique.push(point);
                }
            }

            return unique;
        } catch (error) {
            console.error('Error finding intersections:', error);
            return [];
        }
    }

    /**
     * Bisection method to refine intersection point
     */
    bisectionMethod(compiled1, compiled2, xLeft, xRight, tolerance) {
        let left = xLeft;
        let right = xRight;
        let iterations = 0;
        const maxIterations = 50;

        while (iterations < maxIterations && (right - left) > tolerance) {
            const mid = (left + right) / 2;

            try {
                const y1Left = compiled1.evaluate({ x: left });
                const y2Left = compiled2.evaluate({ x: left });
                const diffLeft = y1Left - y2Left;

                const y1Mid = compiled1.evaluate({ x: mid });
                const y2Mid = compiled2.evaluate({ x: mid });
                const diffMid = y1Mid - y2Mid;

                if (Math.abs(diffMid) < tolerance) {
                    return { x: mid, y: y1Mid };
                }

                if (Math.sign(diffLeft) !== Math.sign(diffMid)) {
                    right = mid;
                } else {
                    left = mid;
                }
            } catch (e) {
                return null;
            }

            iterations++;
        }

        const x = (left + right) / 2;
        try {
            const y = compiled1.evaluate({ x });
            return { x, y };
        } catch (e) {
            return null;
        }
    }

    /**
     * Calculate statistics for data
     */
    calculateStatistics(x, y) {
        if (!x || !y || x.length === 0 || y.length === 0) {
            return null;
        }

        const n = x.length;

        // Mean
        const meanX = math.mean(x);
        const meanY = math.mean(y);

        // Standard deviation
        const stdX = math.std(x);
        const stdY = math.std(y);

        // Min/Max
        const minX = math.min(x);
        const maxX = math.max(x);
        const minY = math.min(y);
        const maxY = math.max(y);

        // Correlation coefficient (Pearson's r)
        let correlation = 0;
        if (x.length === y.length && x.length > 1) {
            const numerator = x.reduce((sum, xi, i) =>
                sum + (xi - meanX) * (y[i] - meanY), 0);
            const denominator = Math.sqrt(
                x.reduce((sum, xi) => sum + Math.pow(xi - meanX, 2), 0) *
                y.reduce((sum, yi) => sum + Math.pow(yi - meanY, 2), 0)
            );
            correlation = denominator !== 0 ? numerator / denominator : 0;
        }

        // Linear regression (y = mx + b)
        let slope = 0, intercept = 0;
        if (x.length === y.length && x.length > 1) {
            const numerator = x.reduce((sum, xi, i) =>
                sum + (xi - meanX) * (y[i] - meanY), 0);
            const denominator = x.reduce((sum, xi) =>
                sum + Math.pow(xi - meanX, 2), 0);
            slope = denominator !== 0 ? numerator / denominator : 0;
            intercept = meanY - slope * meanX;
        }

        return {
            n,
            meanX: meanX.toFixed(4),
            meanY: meanY.toFixed(4),
            stdX: stdX.toFixed(4),
            stdY: stdY.toFixed(4),
            minX: minX.toFixed(4),
            maxX: maxX.toFixed(4),
            minY: minY.toFixed(4),
            maxY: maxY.toFixed(4),
            correlation: correlation.toFixed(4),
            slope: slope.toFixed(4),
            intercept: intercept.toFixed(4),
            regressionEquation: `y = ${slope.toFixed(4)}x + ${intercept.toFixed(4)}`
        };
    }

    /**
     * Generate regression line
     */
    generateRegression(x, y) {
        const stats = this.calculateStatistics(x, y);
        if (!stats) return null;

        const minX = Math.min(...x);
        const maxX = Math.max(...x);

        const xReg = [minX, maxX];
        const yReg = [
            parseFloat(stats.slope) * minX + parseFloat(stats.intercept),
            parseFloat(stats.slope) * maxX + parseFloat(stats.intercept)
        ];

        return { x: xReg, y: yReg };
    }

    /**
     * Generate multiple regression types and return the best fit.
     * @param {number[]} x - data x values
     * @param {number[]} y - data y values
     * @param {string} regressionType - 'auto'|'linear'|'quadratic'|'cubic'|'exponential'|'logarithmic'|'power'
     * @returns {{x: number[], y: number[], equation: string, r2: number, type: string}|null}
     */
    generateRegressionExtended(x, y, regressionType = 'auto') {
        if (!x || !y || x.length < 2 || x.length !== y.length) return null;

        const minX = Math.min(...x), maxX = Math.max(...x);
        const numPts = 200;
        const step = (maxX - minX) / numPts;
        const xPlot = [];
        for (let i = 0; i <= numPts; i++) xPlot.push(minX + i * step);

        // Helper: calculate R² for a model
        const calcR2 = (predicted) => {
            const meanY = y.reduce((s, v) => s + v, 0) / y.length;
            const ssTot = y.reduce((s, v) => s + (v - meanY) ** 2, 0);
            const ssRes = y.reduce((s, v, i) => s + (v - predicted[i]) ** 2, 0);
            return ssTot > 0 ? 1 - ssRes / ssTot : 0;
        };

        // Polynomial regression using normal equations (least squares)
        const polyFit = (degree) => {
            const n = x.length;
            // Build Vandermonde matrix
            const X = x.map(xi => { const row = []; for (let d = 0; d <= degree; d++) row.push(xi ** d); return row; });
            // X^T * X
            const XtX = Array.from({ length: degree + 1 }, (_, i) =>
                Array.from({ length: degree + 1 }, (_, j) =>
                    X.reduce((s, row) => s + row[i] * row[j], 0)));
            // X^T * y
            const Xty = Array.from({ length: degree + 1 }, (_, i) =>
                X.reduce((s, row, k) => s + row[i] * y[k], 0));
            // Solve via Gaussian elimination
            const aug = XtX.map((row, i) => [...row, Xty[i]]);
            const m = degree + 1;
            for (let col = 0; col < m; col++) {
                let maxRow = col;
                for (let row = col + 1; row < m; row++) if (Math.abs(aug[row][col]) > Math.abs(aug[maxRow][col])) maxRow = row;
                [aug[col], aug[maxRow]] = [aug[maxRow], aug[col]];
                if (Math.abs(aug[col][col]) < 1e-12) return null;
                for (let row = col + 1; row < m; row++) {
                    const f = aug[row][col] / aug[col][col];
                    for (let j = col; j <= m; j++) aug[row][j] -= f * aug[col][j];
                }
            }
            const coeffs = new Array(m);
            for (let i = m - 1; i >= 0; i--) {
                coeffs[i] = aug[i][m];
                for (let j = i + 1; j < m; j++) coeffs[i] -= aug[i][j] * coeffs[j];
                coeffs[i] /= aug[i][i];
            }
            const evalPoly = (xv) => coeffs.reduce((s, c, d) => s + c * xv ** d, 0);
            const predicted = x.map(evalPoly);
            const yPlot = xPlot.map(evalPoly);
            return { coeffs, predicted, yPlot, evalPoly };
        };

        const fits = [];

        // Linear (degree 1)
        if (regressionType === 'auto' || regressionType === 'linear') {
            const p = polyFit(1);
            if (p) {
                const r2 = calcR2(p.predicted);
                const eq = `y = ${p.coeffs[1].toFixed(4)}x + ${p.coeffs[0].toFixed(4)}`;
                fits.push({ x: xPlot, y: p.yPlot, equation: eq, r2, type: 'linear' });
            }
        }

        // Quadratic (degree 2)
        if (regressionType === 'auto' || regressionType === 'quadratic') {
            const p = polyFit(2);
            if (p) {
                const r2 = calcR2(p.predicted);
                const eq = `y = ${p.coeffs[2].toFixed(4)}x² + ${p.coeffs[1].toFixed(4)}x + ${p.coeffs[0].toFixed(4)}`;
                fits.push({ x: xPlot, y: p.yPlot, equation: eq, r2, type: 'quadratic' });
            }
        }

        // Cubic (degree 3)
        if (regressionType === 'auto' || regressionType === 'cubic') {
            if (x.length >= 4) {
                const p = polyFit(3);
                if (p) {
                    const r2 = calcR2(p.predicted);
                    const eq = `y = ${p.coeffs[3].toFixed(4)}x³ + ${p.coeffs[2].toFixed(4)}x² + ${p.coeffs[1].toFixed(4)}x + ${p.coeffs[0].toFixed(4)}`;
                    fits.push({ x: xPlot, y: p.yPlot, equation: eq, r2, type: 'cubic' });
                }
            }
        }

        // Exponential: y = a * e^(bx) — linearize via ln(y) = ln(a) + bx
        if (regressionType === 'auto' || regressionType === 'exponential') {
            const posY = y.every(v => v > 0);
            if (posY) {
                const lnY = y.map(v => Math.log(v));
                const n = x.length;
                const sumX = x.reduce((s, v) => s + v, 0);
                const sumLnY = lnY.reduce((s, v) => s + v, 0);
                const sumXLnY = x.reduce((s, v, i) => s + v * lnY[i], 0);
                const sumX2 = x.reduce((s, v) => s + v * v, 0);
                const denom = n * sumX2 - sumX * sumX;
                if (Math.abs(denom) > 1e-12) {
                    const b = (n * sumXLnY - sumX * sumLnY) / denom;
                    const lnA = (sumLnY - b * sumX) / n;
                    const a = Math.exp(lnA);
                    const predicted = x.map(xv => a * Math.exp(b * xv));
                    const r2 = calcR2(predicted);
                    const yPlot = xPlot.map(xv => a * Math.exp(b * xv));
                    const eq = `y = ${a.toFixed(4)}e^(${b.toFixed(4)}x)`;
                    fits.push({ x: xPlot, y: yPlot, equation: eq, r2, type: 'exponential' });
                }
            }
        }

        // Logarithmic: y = a + b*ln(x)
        if (regressionType === 'auto' || regressionType === 'logarithmic') {
            const posX = x.every(v => v > 0);
            if (posX) {
                const lnX = x.map(v => Math.log(v));
                const n = x.length;
                const sumLnX = lnX.reduce((s, v) => s + v, 0);
                const sumY = y.reduce((s, v) => s + v, 0);
                const sumLnXY = lnX.reduce((s, v, i) => s + v * y[i], 0);
                const sumLnX2 = lnX.reduce((s, v) => s + v * v, 0);
                const denom = n * sumLnX2 - sumLnX * sumLnX;
                if (Math.abs(denom) > 1e-12) {
                    const b = (n * sumLnXY - sumLnX * sumY) / denom;
                    const a = (sumY - b * sumLnX) / n;
                    const predicted = x.map(xv => a + b * Math.log(xv));
                    const r2 = calcR2(predicted);
                    const posPlot = xPlot.filter(v => v > 0);
                    const yPlot = posPlot.map(xv => a + b * Math.log(xv));
                    const eq = `y = ${a.toFixed(4)} + ${b.toFixed(4)}ln(x)`;
                    fits.push({ x: posPlot, y: yPlot, equation: eq, r2, type: 'logarithmic' });
                }
            }
        }

        // Power: y = a * x^b — linearize via ln(y) = ln(a) + b*ln(x)
        if (regressionType === 'auto' || regressionType === 'power') {
            const posXY = x.every(v => v > 0) && y.every(v => v > 0);
            if (posXY) {
                const lnX = x.map(v => Math.log(v));
                const lnY = y.map(v => Math.log(v));
                const n = x.length;
                const sumLnX = lnX.reduce((s, v) => s + v, 0);
                const sumLnY = lnY.reduce((s, v) => s + v, 0);
                const sumLnXLnY = lnX.reduce((s, v, i) => s + v * lnY[i], 0);
                const sumLnX2 = lnX.reduce((s, v) => s + v * v, 0);
                const denom = n * sumLnX2 - sumLnX * sumLnX;
                if (Math.abs(denom) > 1e-12) {
                    const b = (n * sumLnXLnY - sumLnX * sumLnY) / denom;
                    const lnA = (sumLnY - b * sumLnX) / n;
                    const a = Math.exp(lnA);
                    const predicted = x.map(xv => a * xv ** b);
                    const r2 = calcR2(predicted);
                    const posPlot = xPlot.filter(v => v > 0);
                    const yPlot = posPlot.map(xv => a * xv ** b);
                    const eq = `y = ${a.toFixed(4)}x^${b.toFixed(4)}`;
                    fits.push({ x: posPlot, y: yPlot, equation: eq, r2, type: 'power' });
                }
            }
        }

        if (fits.length === 0) return null;

        // For 'auto', return best R²
        if (regressionType === 'auto') {
            fits.sort((a, b) => b.r2 - a.r2);
            return fits[0];
        }
        return fits[0];
    }

    /**
     * Create Plotly trace for an expression
     */
    createTrace(expr, settings = {}) {
        const { xMin = -10, xMax = 10, yMin = -10, yMax = 10 } = settings;

        let trace = null;

        // Work with raw expression first for special forms (before normalization mangles function names)
        let rawExprStr = expr.expression;
        if (rawExprStr && typeof rawExprStr === 'string') {
            // Substitute global scope + per-expression parameters into raw expression for special forms
            let rawSubstituted = rawExprStr;
            if (this.globalScope) {
                Object.keys(this.globalScope).forEach(varName => {
                    if (typeof this.globalScope[varName] === 'number') {
                        const regex = new RegExp(`\\b${varName}\\b`, 'g');
                        rawSubstituted = rawSubstituted.replace(regex, '(' + this.globalScope[varName] + ')');
                    }
                });
            }
            if (expr.parameters) {
                Object.keys(expr.parameters).forEach(param => {
                    const regex = new RegExp(`\\b${param}\\b`, 'g');
                    rawSubstituted = rawSubstituted.replace(regex, expr.parameters[param]);
                });
            }

            // Handle Fourier series: fourier(expr, N) — must match before normalizeExpression
            const fourierMatch = rawSubstituted.match(/^\s*fourier\s*\(\s*(.+?)\s*,\s*(\d+)\s*\)\s*$/i);
            if (fourierMatch) {
                const bodyExpr = fourierMatch[1];
                const nTerms = parseInt(fourierMatch[2]);
                trace = generateFourierTrace(bodyExpr, nTerms, xMin, xMax, expr.color);
                if (trace) return trace;
            }

            // Handle int()/deriv() — _handleSpecialSyntaxFromInput should have stripped these,
            // but during mid-entry in MathQuill the expression may still be int(...)/deriv(...).
            // Skip plotting to avoid Math.js compile errors.
            if (/^\s*(int|deriv|lim)\s*\(/i.test(rawSubstituted)) {
                return null;
            }

            // Handle sum/prod — must match before normalizeExpression
            if (/^\s*sum\s*\(/i.test(rawSubstituted)) {
                const sumTrace = this._generateSumProductTrace(rawSubstituted, 'sum', xMin, xMax, expr);
                if (sumTrace) { trace = sumTrace; return trace; }
            }
            if (/^\s*prod\s*\(/i.test(rawSubstituted)) {
                const prodTrace = this._generateSumProductTrace(rawSubstituted, 'prod', xMin, xMax, expr);
                if (prodTrace) { trace = prodTrace; return trace; }
            }
        }

        // Normalize the expression into a local variable (don't mutate expr.expression)
        let normalizedExpr = expr.expression;
        if (normalizedExpr && typeof normalizedExpr === 'string') {
            // Resolve function composition (f(f(x)), g(f(x)), etc.)
            // But skip if this expression IS a function definition (e.g. f(x)=x^2)
            const isFuncDef = /^\s*[a-zA-Z]\s*\(\s*x\s*\)\s*=/.test(normalizedExpr);
            if (!isFuncDef) {
                normalizedExpr = resolveFunctionComposition(normalizedExpr);
            }
            normalizedExpr = this.normalizeExpression(normalizedExpr);
        }

        // Substitute global scope variables first (shared across expressions)
        if (this.globalScope && normalizedExpr && typeof normalizedExpr === 'string') {
            Object.keys(this.globalScope).forEach(varName => {
                if (typeof this.globalScope[varName] === 'number') {
                    const regex = new RegExp(`\\b${varName}\\b`, 'g');
                    normalizedExpr = normalizedExpr.replace(regex, '(' + this.globalScope[varName] + ')');
                }
            });
        }

        // Substitute parameters (sliders) for all expression types
        if (expr.parameters && normalizedExpr && typeof normalizedExpr === 'string') {
            Object.keys(expr.parameters).forEach(param => {
                const regex = new RegExp(`\\b${param}\\b`, 'g');
                normalizedExpr = normalizedExpr.replace(regex, expr.parameters[param]);
            });
        }

        // Skip plotting for variable and list types — they don't produce traces
        if (expr.type === 'variable' || expr.type === 'list') {
            return null;
        }

        switch (expr.type) {
            case 'cartesian': {
                let expression = normalizedExpr;

                // Detect "x = <constant>" vertical line pattern
                const vertMatch = expression.match(/^\s*x\s*=\s*([+-]?\d+\.?\d*)\s*$/);
                if (vertMatch) {
                    const xConst = parseFloat(vertMatch[1]);
                    trace = [{
                        x: [xConst, xConst],
                        y: [yMin, yMax],
                        type: 'scatter',
                        mode: 'lines',
                        name: expr.expression,
                        line: { color: expr.color, width: 2, dash: 'dash' }
                    }];
                    break;
                }

                const data = this.generateCartesian(expression, xMin, xMax);
                if (data) {
                    trace = [{
                        x: data.x,
                        y: data.y,
                        type: 'scatter',
                        mode: 'lines',
                        name: expr.expression,
                        line: { color: expr.color, width: 2 },
                        connectgaps: false,
                        hovertemplate: 'x = %{x:.4f}<br>y = %{y:.4f}<extra>%{fullData.name}</extra>'
                    }];

                    // Add vertical asymptote lines
                    if (data.asymptotes && data.asymptotes.length > 0) {
                        for (const ax of data.asymptotes) {
                            trace.push({
                                x: [ax, ax], y: [yMin, yMax],
                                type: 'scatter', mode: 'lines',
                                line: { color: '#94a3b8', width: 1, dash: 'dot' },
                                showlegend: false, hoverinfo: 'skip'
                            });
                        }
                    }

                    // Add derivative if enabled
                    if (expr.showDerivative) {
                        const derivData = this.generateDerivative(expression, xMin, xMax);
                        if (derivData) {
                            trace.push({
                                x: derivData.x,
                                y: derivData.y,
                                type: 'scatter',
                                mode: 'lines',
                                name: `f'(${expr.expression})`,
                                line: { color: expr.color, width: 2, dash: 'dash' },
                                connectgaps: false
                            });
                        } else if (!expr._sympyDerivResolved) {
                            // Queue SymPy fallback for derivative
                            expr._sympyDerivNeeded = { expression, xMin, xMax };
                        }
                    }

                    // Add second derivative if enabled
                    if (expr.showSecondDerivative) {
                        const d2Data = this.generateSecondDerivative(expression, xMin, xMax);
                        if (d2Data) {
                            trace.push({
                                x: d2Data.x,
                                y: d2Data.y,
                                type: 'scatter',
                                mode: 'lines',
                                name: `f''(${expr.expression})`,
                                line: { color: expr.color, width: 2, dash: 'dashdot' },
                                connectgaps: false
                            });
                        }
                    }

                    // Add critical points (local min/max) if enabled
                    if (expr.showCriticalPoints) {
                        const cps = this.findCriticalPoints(expression, xMin, xMax);
                        if (cps.length > 0) {
                            const minPts = cps.filter(p => p.type === 'min');
                            const maxPts = cps.filter(p => p.type === 'max');
                            const otherPts = cps.filter(p => p.type === 'critical');
                            if (minPts.length > 0) {
                                trace.push({
                                    x: minPts.map(p => p.x), y: minPts.map(p => p.y),
                                    type: 'scatter', mode: 'markers+text',
                                    name: 'Local Min',
                                    marker: { color: '#22c55e', size: 10, symbol: 'triangle-up' },
                                    text: minPts.map(p => `min(${p.x.toFixed(2)}, ${p.y.toFixed(2)})`),
                                    textposition: 'bottom center', textfont: { size: 10 },
                                    showlegend: true
                                });
                            }
                            if (maxPts.length > 0) {
                                trace.push({
                                    x: maxPts.map(p => p.x), y: maxPts.map(p => p.y),
                                    type: 'scatter', mode: 'markers+text',
                                    name: 'Local Max',
                                    marker: { color: '#ef4444', size: 10, symbol: 'triangle-down' },
                                    text: maxPts.map(p => `max(${p.x.toFixed(2)}, ${p.y.toFixed(2)})`),
                                    textposition: 'top center', textfont: { size: 10 },
                                    showlegend: true
                                });
                            }
                            if (otherPts.length > 0) {
                                trace.push({
                                    x: otherPts.map(p => p.x), y: otherPts.map(p => p.y),
                                    type: 'scatter', mode: 'markers',
                                    name: 'Critical Points',
                                    marker: { color: '#f59e0b', size: 8, symbol: 'diamond' },
                                    showlegend: true
                                });
                            }
                        }
                    }

                    // Add inflection points if enabled
                    if (expr.showInflectionPoints) {
                        const ips = this.findInflectionPoints(expression, xMin, xMax);
                        if (ips.length > 0) {
                            trace.push({
                                x: ips.map(p => p.x), y: ips.map(p => p.y),
                                type: 'scatter', mode: 'markers+text',
                                name: 'Inflection Points',
                                marker: { color: '#8b5cf6', size: 10, symbol: 'square' },
                                text: ips.map(p => `(${p.x.toFixed(2)}, ${p.y.toFixed(2)})`),
                                textposition: 'top center', textfont: { size: 10 },
                                showlegend: true
                            });
                        }
                    }

                    // Add horizontal/oblique asymptotes
                    {
                        const hAsym = this.findHorizontalAsymptotes(expression, xMin, xMax);
                        for (const a of hAsym) {
                            if (a.type === 'horizontal') {
                                trace.push({
                                    x: [xMin, xMax], y: [a.y, a.y],
                                    type: 'scatter', mode: 'lines',
                                    line: { color: '#f59e0b', width: 1, dash: 'dash' },
                                    name: `y = ${a.y.toFixed(2)}`,
                                    showlegend: false, hoverinfo: 'name'
                                });
                            } else if (a.type === 'oblique') {
                                trace.push({
                                    x: [xMin, xMax], y: [a.m * xMin + a.b, a.m * xMax + a.b],
                                    type: 'scatter', mode: 'lines',
                                    line: { color: '#f59e0b', width: 1, dash: 'dash' },
                                    name: `y = ${a.m.toFixed(2)}x + ${a.b.toFixed(2)}`,
                                    showlegend: false, hoverinfo: 'name'
                                });
                            }
                        }
                    }

                    // Add roots (x-intercepts) if enabled
                    if (expr.showRoots) {
                        const roots = this.findRoots(expression, xMin, xMax);
                        if (roots.length > 0) {
                            trace.push({
                                x: roots.map(r => r.x),
                                y: roots.map(() => 0),
                                type: 'scatter', mode: 'markers+text',
                                marker: { color: '#10b981', size: 9, symbol: 'x', line: { width: 2 } },
                                text: roots.map(r => `(${r.x}, 0)`),
                                textposition: 'top center',
                                textfont: { size: 10, color: '#10b981' },
                                name: 'Zeros', showlegend: false,
                                hovertemplate: 'Root: x = %{x:.6f}<extra></extra>'
                            });
                        }
                    }

                    // Add vertical asymptotes if enabled
                    if (expr.showVerticalAsymptotes) {
                        const vAsym = this.findVerticalAsymptotes(expression, xMin, xMax);
                        for (const a of vAsym) {
                            trace.push({
                                x: [a.x, a.x], y: [yMin, yMax],
                                type: 'scatter', mode: 'lines',
                                line: { color: '#ef4444', width: 1.5, dash: 'dashdot' },
                                name: `x = ${a.x}`,
                                showlegend: false,
                                hovertemplate: `Vertical asymptote: x = ${a.x}<extra></extra>`
                            });
                        }
                    }

                    // Add tangent line if enabled
                    if (expr.showTangent && expr.tangentX != null) {
                        const tg = this.tangentLineAt(expression, expr.tangentX, xMin, xMax);
                        if (tg) {
                            // Tangent line
                            trace.push({
                                x: tg.lineX, y: tg.lineY,
                                type: 'scatter', mode: 'lines',
                                line: { color: '#f59e0b', width: 2, dash: 'dash' },
                                name: `Tangent: slope=${tg.slope.toFixed(4)}`,
                                showlegend: false,
                                hovertemplate: tg.equation + '<extra></extra>'
                            });
                            // Point of tangency
                            trace.push({
                                x: [tg.x0], y: [tg.y0],
                                type: 'scatter', mode: 'markers',
                                marker: { color: '#f59e0b', size: 10, symbol: 'circle' },
                                name: `(${tg.x0.toFixed(4)}, ${tg.y0})`,
                                showlegend: false,
                                hovertemplate: `Tangent at (${tg.x0.toFixed(4)}, ${tg.y0})<br>Slope: ${tg.slope.toFixed(4)}<extra></extra>`
                            });
                        }
                    }

                    // Add antiderivative F(x) if enabled
                    if (expr.showAntiderivative) {
                        const antiData = this.generateAntiderivative(expression, xMin, xMax);
                        if (antiData) {
                            const legendName = antiData.symbolic
                                ? `F(x) = ${antiData.symbolic} + C`
                                : `F(x) = ∫${expr.expression} dx`;
                            trace.push({
                                x: antiData.x,
                                y: antiData.y,
                                type: 'scatter',
                                mode: 'lines',
                                name: legendName,
                                line: { color: expr.color, width: 2, dash: 'dot' },
                                connectgaps: false
                            });
                            // Show symbolic antiderivative in numeric result panel
                            const resultEl = document.getElementById('numeric-result-' + expr.id);
                            if (resultEl && antiData.symbolic && !expr.showIntegration) {
                                resultEl.innerHTML = 'F(x) = ' + antiData.symbolic + ' + C';
                                resultEl.style.display = 'block';
                            }
                        } else if (!expr._sympyAntiResolved) {
                            // Queue SymPy fallback for antiderivative
                            expr._sympyAntiNeeded = { expression, xMin, xMax };
                        }
                    }

                    // Add intersection points if they exist
                    if (expr.intersections && expr.intersections.length > 0) {
                        const intersX = expr.intersections.map(p => p.x);
                        const intersY = expr.intersections.map(p => p.y);
                        trace.push({
                            x: intersX,
                            y: intersY,
                            type: 'scatter',
                            mode: 'markers',
                            name: 'Intersections',
                            marker: { color: 'red', size: 10, symbol: 'circle' },
                            showlegend: false
                        });
                    }

                    // Add solution points if they exist
                    if (expr.solutions && expr.solutions.length > 0) {
                        const solX = expr.solutions.map(p => p.x);
                        const solY = expr.solutions.map(p => p.y);
                        trace.push({
                            x: solX,
                            y: solY,
                            type: 'scatter',
                            mode: 'markers',
                            name: 'Solutions',
                            marker: { color: 'green', size: 10, symbol: 'star' },
                            showlegend: false
                        });
                    }

                    // Add integration shading if enabled
                    if (expr.showIntegration && expr.integrationBounds) {
                        const { a, b } = expr.integrationBounds;
                        const integrationData = this.numericalIntegration(expression, a, b);

                        if (integrationData) {
                            // Add shaded area
                            const shadedX = [a, ...integrationData.x, b, a];
                            const shadedY = [0, ...integrationData.y, 0, 0];

                            trace.push({
                                x: shadedX,
                                y: shadedY,
                                type: 'scatter',
                                fill: 'toself',
                                fillcolor: expr.color + '30', // Add transparency
                                line: { width: 0 },
                                name: `Area = ${integrationData.area.toFixed(4)}`,
                                showlegend: true,
                                hoverinfo: 'skip'
                            });
                        }
                    }

                    // Add Riemann sum rectangles/trapezoids if enabled
                    if (expr.showIntegration && expr.integrationBounds && expr.riemannMethod && expr.riemannMethod !== 'none') {
                        const { a, b } = expr.integrationBounds;
                        const rN = expr.riemannN || 10;
                        const riemannData = this.generateRiemannSum(expression, a, b, rN, expr.riemannMethod);
                        if (riemannData) {
                            const methodLabels = { left: 'Left', right: 'Right', midpoint: 'Midpoint', trapezoidal: 'Trap' };
                            riemannData.shapes.forEach((shape, idx) => {
                                trace.push({
                                    x: shape.x,
                                    y: shape.y,
                                    type: 'scatter',
                                    fill: 'toself',
                                    fillcolor: expr.color + '22',
                                    line: { color: expr.color, width: 1 },
                                    showlegend: idx === 0,
                                    name: idx === 0 ? `${methodLabels[expr.riemannMethod]} Riemann (n=${rN}) ≈ ${riemannData.area.toFixed(4)}` : '',
                                    hoverinfo: 'skip'
                                });
                            });
                        }
                    }

                    // Render area between curves shading if computed
                    if (expr._areaBetween) {
                        const ab = expr._areaBetween;
                        trace.push({
                            x: ab.shadeX,
                            y: ab.shadeY,
                            type: 'scatter',
                            fill: 'toself',
                            fillcolor: expr.color + '25',
                            line: { width: 0 },
                            name: `Area ≈ ${ab.area.toFixed(4)}`,
                            showlegend: true,
                            hoverinfo: 'skip'
                        });
                    }
                }
                break;
            }

            case 'implicit': {
                const data = this.generateImplicit(normalizedExpr, xMin, xMax, yMin, yMax);
                if (data) {
                    trace = {
                        x: data.x,
                        y: data.y,
                        type: 'scatter',
                        mode: data.mode || 'lines',
                        name: expr.expression,
                        line: { color: expr.color, width: 2 },
                        connectgaps: false,
                        hovertemplate: 'x = %{x:.4f}<br>y = %{y:.4f}<extra>%{fullData.name}</extra>'
                    };
                }
                break;
            }

            case 'piecewise': {
                if (expr.pieces) {
                    const data = this.generatePiecewise(expr.pieces, xMin, xMax);
                    if (data) {
                        trace = {
                            x: data.x,
                            y: data.y,
                            type: 'scatter',
                            mode: 'lines',
                            name: expr.expression || 'Piecewise Function',
                            line: { color: expr.color, width: 2 },
                            connectgaps: false
                        };
                    }
                }
                break;
            }

            case 'surface': {
                if (!_fullPlotlyLoaded) {
                    // Full Plotly not yet loaded — trigger load and re-plot when ready
                    _ensureFullPlotly(function() { updateGraph(); });
                    break;
                }
                const surfData = this.generateSurface(normalizedExpr, xMin, xMax, yMin, yMax);
                if (surfData) {
                    trace = {
                        x: surfData.x, y: surfData.y, z: surfData.z,
                        type: 'surface',
                        name: expr.expression,
                        colorscale: 'Viridis',
                        showscale: true
                    };
                }
                break;
            }

            case 'parametric': {
                // Strip optional "x(t) = " and "y(t) = " prefixes; also support semicolon separator
                const paramParts = normalizedExpr.replace(/;/g, ',').split(',').map(e =>
                    e.trim().replace(/^\s*[xy]\s*\(\s*t\s*\)\s*=\s*/i, '')
                );
                const [xExpr, yExpr] = paramParts;
                const tMin = expr.tMin != null ? expr.tMin : 0;
                const tMax = expr.tMax != null ? expr.tMax : 2 * Math.PI;
                const data = this.generateParametric(xExpr, yExpr, tMin, tMax);
                if (data) {
                    trace = {
                        x: data.x,
                        y: data.y,
                        type: 'scatter',
                        mode: 'lines',
                        name: expr.expression,
                        line: { color: expr.color, width: 2 }
                    };
                }
                break;
            }

            case 'polar': {
                const thetaMin = expr.thetaMin != null ? expr.thetaMin : 0;
                const thetaMax = expr.thetaMax != null ? expr.thetaMax : 2 * Math.PI;
                const numPts = thetaMax - thetaMin > 4 * Math.PI ? 2000 : 500;
                const data = this.generatePolar(normalizedExpr, thetaMin, thetaMax, numPts);
                if (data) {
                    trace = {
                        x: data.x,
                        y: data.y,
                        type: 'scatter',
                        mode: 'lines',
                        name: expr.expression,
                        line: { color: expr.color, width: 2 }
                    };
                }
                break;
            }

            case 'inequality': {
                const match = normalizedExpr.match(/(.+?)(>=|<=|>|<|=)(.+)/);
                if (match) {
                    const data = this.generateInequality(
                        match[1].trim(),
                        match[2],
                        match[3].trim(),
                        xMin, xMax, yMin, yMax
                    );
                    if (data) {
                        // Use heatmap for continuous shaded region instead of point cloud
                        const xFlat = data.x[0]; // all rows share same x values
                        const yFlat = data.y.map(row => row[0]); // each row has same y
                        // Convert hex color to rgba for the colorscale
                        const c = expr.color;
                        const r = parseInt(c.slice(1,3), 16), g = parseInt(c.slice(3,5), 16), b = parseInt(c.slice(5,7), 16);
                        trace = {
                            x: xFlat,
                            y: yFlat,
                            z: data.z,
                            type: 'heatmap',
                            colorscale: [
                                [0, 'rgba(0,0,0,0)'],
                                [1, `rgba(${r},${g},${b},0.3)`]
                            ],
                            showscale: false,
                            name: expr.expression,
                            hoverinfo: 'name'
                        };
                    }
                }
                break;
            }

            case 'table': {
                const data = this.parseTableData(expr.expression);
                if (data) {
                    trace = {
                        x: data.x,
                        y: data.y,
                        type: 'scatter',
                        mode: 'markers',
                        name: 'Data Points',
                        marker: { color: expr.color, size: 8 }
                    };
                }
                break;
            }

            case 'statistics': {
                const data = this.parseTableData(normalizedExpr);
                if (data) {
                    trace = [{
                        x: data.x,
                        y: data.y,
                        type: 'scatter',
                        mode: 'markers',
                        name: 'Data Points',
                        marker: { color: expr.color, size: 8 }
                    }];

                    // Use extended regression (respects user-selected type or auto-best)
                    const regType = expr.regressionType || 'auto';
                    const extReg = this.generateRegressionExtended(data.x, data.y, regType);
                    if (extReg) {
                        trace.push({
                            x: extReg.x,
                            y: extReg.y,
                            type: 'scatter',
                            mode: 'lines',
                            name: `${extReg.type} (R²=${extReg.r2.toFixed(4)})`,
                            line: { color: expr.color, width: 2, dash: 'dash' }
                        });
                        // Store extended info for stats display
                        expr._regressionResult = extReg;
                    }

                    // Store stats for display
                    expr.stats = this.calculateStatistics(data.x, data.y);
                    if (extReg) {
                        expr.stats.regressionEquation = extReg.equation;
                        expr.stats.regressionType = extReg.type;
                        expr.stats.r2 = extReg.r2.toFixed(4);
                    }
                }
                break;
            }

            case 'point': {
                // Parse points: "(2,3)" or "[(1,2),(3,4),(5,6)]" or "(2,3), (4,5)"
                const pointRegex = /\(\s*(-?[\d.]+)\s*,\s*(-?[\d.]+)\s*\)/g;
                const px = [], py = [], labels = [];
                let pm;
                while ((pm = pointRegex.exec(normalizedExpr)) !== null) {
                    const xv = parseFloat(pm[1]), yv = parseFloat(pm[2]);
                    if (isFinite(xv) && isFinite(yv)) {
                        px.push(xv); py.push(yv);
                        labels.push(`(${pm[1]}, ${pm[2]})`);
                    }
                }
                if (px.length > 0) {
                    trace = {
                        x: px, y: py,
                        type: 'scatter', mode: 'markers+text',
                        marker: { color: expr.color, size: 10, symbol: 'circle', line: { color: '#fff', width: 1.5 } },
                        text: labels,
                        textposition: 'top center',
                        textfont: { size: 10, color: expr.color },
                        name: expr.expression,
                        hovertemplate: '(%{x}, %{y})<extra></extra>'
                    };
                }
                break;
            }

            case 'vector': {
                // Parse vectors: <2,3> or <2,3> @ (1,1) or [<1,2>, <3,4>]
                // Each vector is an arrow from origin (default 0,0) in direction <dx,dy>
                const vecRegex = /<\s*(-?[\d.]+)\s*,\s*(-?[\d.]+)\s*>/g;
                const originRegex = /@\s*\(\s*(-?[\d.]+)\s*,\s*(-?[\d.]+)\s*\)/;
                const vectors = [];
                let vm;
                const rawStr = normalizedExpr || '';
                while ((vm = vecRegex.exec(rawStr)) !== null) {
                    vectors.push({ dx: parseFloat(vm[1]), dy: parseFloat(vm[2]) });
                }
                // Check for origin specification
                const om = rawStr.match(originRegex);
                const defaultOx = om ? parseFloat(om[1]) : 0;
                const defaultOy = om ? parseFloat(om[2]) : 0;

                if (vectors.length > 0) {
                    trace = [];
                    vectors.forEach((v, idx) => {
                        const ox = defaultOx + (idx > 0 && !om ? 0 : 0);
                        const oy = defaultOy;
                        // Arrow line
                        trace.push({
                            x: [ox, ox + v.dx], y: [oy, oy + v.dy],
                            type: 'scatter', mode: 'lines',
                            line: { color: expr.color, width: 2.5 },
                            showlegend: idx === 0,
                            name: expr.expression,
                            hovertemplate: `⟨${v.dx}, ${v.dy}⟩<extra></extra>`
                        });
                        // Arrowhead (triangle at tip)
                        const len = Math.sqrt(v.dx * v.dx + v.dy * v.dy);
                        if (len > 0) {
                            const ux = v.dx / len, uy = v.dy / len;
                            const headLen = Math.min(0.3, len * 0.2);
                            const tipX = ox + v.dx, tipY = oy + v.dy;
                            const baseX = tipX - headLen * ux, baseY = tipY - headLen * uy;
                            const perpX = -uy * headLen * 0.4, perpY = ux * headLen * 0.4;
                            trace.push({
                                x: [baseX + perpX, tipX, baseX - perpX, baseX + perpX],
                                y: [baseY + perpY, tipY, baseY - perpY, baseY + perpY],
                                type: 'scatter', mode: 'lines', fill: 'toself',
                                fillcolor: expr.color, line: { color: expr.color, width: 1 },
                                showlegend: false, hoverinfo: 'skip'
                            });
                        }
                        // Origin dot
                        trace.push({
                            x: [ox], y: [oy],
                            type: 'scatter', mode: 'markers',
                            marker: { color: expr.color, size: 5 },
                            showlegend: false, hoverinfo: 'skip'
                        });
                    });
                }
                break;
            }

            case 'vectorfield': {
                // Parse vector field: <expr_x, expr_y> or F(x,y) = <expr_x, expr_y>
                let fieldStr = normalizedExpr || '';
                // Strip F(x,y) = prefix
                fieldStr = fieldStr.replace(/^\s*\w+\s*\(\s*x\s*,\s*y\s*\)\s*=\s*/, '');
                const fieldMatch = fieldStr.match(/<\s*(.+?)\s*,\s*(.+?)\s*>/);
                if (fieldMatch) {
                    try {
                        const fxExpr = math.compile(this.normalizeExpression(fieldMatch[1]));
                        const fyExpr = math.compile(this.normalizeExpression(fieldMatch[2]));
                        const gridN = 15; // 15x15 grid of arrows
                        const xStep = (xMax - xMin) / gridN;
                        const yStep = (yMax - yMin) / gridN;
                        const scale = Math.min(xStep, yStep) * 0.8;

                        trace = [];
                        for (let i = 0; i <= gridN; i++) {
                            for (let j = 0; j <= gridN; j++) {
                                const gx = xMin + i * xStep;
                                const gy = yMin + j * yStep;
                                try {
                                    let dx = fxExpr.evaluate({ x: gx, y: gy });
                                    let dy = fyExpr.evaluate({ x: gx, y: gy });
                                    if (!isFinite(dx) || !isFinite(dy)) continue;
                                    // Normalize and scale
                                    const mag = Math.sqrt(dx * dx + dy * dy);
                                    if (mag === 0) continue;
                                    const nDx = (dx / mag) * scale;
                                    const nDy = (dy / mag) * scale;
                                    // Arrow shaft
                                    trace.push({
                                        x: [gx, gx + nDx], y: [gy, gy + nDy],
                                        type: 'scatter', mode: 'lines',
                                        line: { color: expr.color, width: 1.2 },
                                        showlegend: false, hoverinfo: 'skip'
                                    });
                                    // Small arrowhead
                                    const ux = nDx / scale, uy = nDy / scale;
                                    const hl = scale * 0.25;
                                    const tipX = gx + nDx, tipY = gy + nDy;
                                    trace.push({
                                        x: [tipX - hl * ux + hl * 0.3 * uy, tipX, tipX - hl * ux - hl * 0.3 * uy],
                                        y: [tipY - hl * uy - hl * 0.3 * ux, tipY, tipY - hl * uy + hl * 0.3 * ux],
                                        type: 'scatter', mode: 'lines',
                                        line: { color: expr.color, width: 1.2 },
                                        showlegend: false, hoverinfo: 'skip'
                                    });
                                } catch (_) { /* skip this grid point */ }
                            }
                        }
                        if (trace.length === 0) trace = null;
                    } catch (_) {
                        trace = null;
                    }
                }
                break;
            }

            case 'distribution': {
                if (expr.distParams) {
                    const data = this.generateDistribution(
                        expr.distParams.type,
                        expr.distParams.params,
                        xMin,
                        xMax
                    );

                    if (data) {
                        trace = {
                            x: data.x,
                            y: data.y,
                            type: 'scatter',
                            mode: data.discrete ? 'markers+lines' : 'lines',
                            name: expr.expression || `${expr.distParams.type} distribution`,
                            line: { color: expr.color, width: 2 }
                        };

                        // Only add marker for discrete distributions
                        if (data.discrete) {
                            trace.marker = { color: expr.color, size: 8 };
                        }
                    }
                }
                break;
            }

            case 'equation': {
                // Use Nerdamer to solve an equation for y, then plot each branch
                if (typeof nerdamer === 'undefined') {
                    // Fallback to implicit contour if Nerdamer not loaded
                    const implData = this.generateImplicit(normalizedExpr, xMin, xMax, yMin, yMax);
                    if (implData) {
                        trace = {
                            x: implData.x, y: implData.y,
                            type: 'scatter', mode: implData.mode || 'lines',
                            name: expr.expression,
                            line: { color: expr.color, width: 2 },
                            connectgaps: false,
                            hovertemplate: 'x = %{x:.4f}<br>y = %{y:.4f}<extra>%{fullData.name}</extra>'
                        };
                    }
                    break;
                }
                trace = this.solveAndPlot(normalizedExpr, expr.color, xMin, xMax);
                // If Nerdamer failed, fall back to implicit contour (no auto SymPy — implicit is sufficient)
                if (!trace) {
                    const implData = this.generateImplicit(normalizedExpr, xMin, xMax, yMin, yMax);
                    if (implData) {
                        trace = {
                            x: implData.x, y: implData.y,
                            type: 'scatter', mode: implData.mode || 'lines',
                            name: expr.expression,
                            line: { color: expr.color, width: 2 },
                            connectgaps: false,
                            hovertemplate: 'x = %{x:.4f}<br>y = %{y:.4f}<extra>%{fullData.name}</extra>'
                        };
                    }
                    // Don't auto-fire SymPy — the implicit plot is visually correct.
                    // SymPy equation solving only triggers via explicit user action (Solve button).
                }
                break;
            }

            case 'limit': {
                // Plot f(x) and annotate the limit point
                const limitExpr = expr.limitExpr || expr.expression;
                if (!limitExpr) break;
                const limitVar = expr.limitVar || 'x';
                const limitVal = expr.limitVal != null ? expr.limitVal : 0;

                // Plot the function
                const normExpr = this.normalizeExpression(limitExpr);
                try {
                    const compiled = math.compile(normExpr);
                    const xs = [], ys = [];
                    const step = (xMax - xMin) / 500;
                    for (let i = 0; i <= 500; i++) {
                        const xv = xMin + i * step;
                        try {
                            const yv = compiled.evaluate({ x: xv });
                            if (typeof yv === 'number' && isFinite(yv)) { xs.push(xv); ys.push(yv); }
                            else { xs.push(xv); ys.push(null); }
                        } catch (_) { xs.push(xv); ys.push(null); }
                    }

                    trace = [{
                        x: xs, y: ys, type: 'scatter', mode: 'lines',
                        name: 'f(x) = ' + limitExpr,
                        line: { color: expr.color, width: 2 },
                        connectgaps: false
                    }];

                    // Evaluate the limit using Nerdamer (with SymPy fallback)
                    let limitResult = this.evaluateLimit(limitExpr, limitVar, limitVal);
                    if (!limitResult && !expr._sympyLimitResolved) {
                        expr._sympyLimitNeeded = { limitExpr, limitVar, limitVal, xMin, xMax, yMin, yMax };
                    }
                    // Use SymPy result if available
                    if (!limitResult && expr._sympyLimitResult) {
                        limitResult = expr._sympyLimitResult;
                        // Keep _sympyLimitResult so it persists across re-plots (pan/zoom)
                    }
                    if (limitResult && limitResult.numeric != null) {
                        const lx = parseFloat(limitVal);
                        const ly = limitResult.numeric;
                        // Add marker at the limit point
                        trace.push({
                            x: [lx], y: [ly], type: 'scatter', mode: 'markers+text',
                            name: `lim → ${limitResult.symbolic}`,
                            marker: { color: expr.color, size: 12, symbol: 'circle-open', line: { width: 3, color: expr.color } },
                            text: [`L = ${limitResult.symbolic}`],
                            textposition: 'top center',
                            textfont: { size: 13, color: expr.color },
                            showlegend: true
                        });
                        // Dashed horizontal line at y = L
                        trace.push({
                            x: [xMin, xMax], y: [ly, ly], type: 'scatter', mode: 'lines',
                            name: `y = ${limitResult.symbolic}`,
                            line: { color: expr.color, width: 1, dash: 'dash' },
                            showlegend: false
                        });
                        // Dashed vertical line at x = a
                        trace.push({
                            x: [lx, lx], y: [yMin, yMax], type: 'scatter', mode: 'lines',
                            name: `x = ${limitVal}`,
                            line: { color: '#94a3b8', width: 1, dash: 'dot' },
                            showlegend: false
                        });
                    }
                } catch (e) {
                    console.error('Limit plot error:', e);
                }
                break;
            }
        }

        // Render table points as scatter dots if the table is active for this expression
        if (expr._tablePoints && expr._tablePoints.x.length > 0) {
            const dotTrace = {
                x: expr._tablePoints.x,
                y: expr._tablePoints.y,
                type: 'scatter',
                mode: 'markers',
                marker: { color: expr.color, size: 8, line: { color: '#fff', width: 1.5 } },
                name: 'Table points',
                showlegend: false,
                hovertemplate: '(%{x:.4f}, %{y:.4f})<extra></extra>'
            };
            if (Array.isArray(trace)) {
                trace.push(dotTrace);
            } else if (trace) {
                trace = [trace, dotTrace];
            } else {
                trace = [dotTrace];
            }
        }

        return trace;
    }

    /**
     * Solve an equation for y using Nerdamer, return Plotly traces for each branch.
     */
    solveAndPlot(equation, color, xMin, xMax, numPoints = 400) {
        try {
            const parts = equation.split('=');
            if (parts.length !== 2) return null;
            const expr = '(' + parts[0].trim() + ')-(' + parts[1].trim() + ')';

            const ySolved = nerdamer.solve(expr, 'y');
            const yText = ySolved.text().replace(/^\[|\]$/g, '');
            if (!yText) return null;

            const yExprs = yText.split(',').map(s => s.trim()).filter(Boolean);
            const traces = [];

            for (let ve = 0; ve < yExprs.length; ve++) {
                const yExpr = yExprs[ve];
                const xs = [], ys = [];

                // Try Math.js first (100x faster than Nerdamer per-point)
                let compiled = null;
                try {
                    compiled = math.compile(this.normalizeExpression(yExpr));
                } catch (_) {
                    // Math.js can't parse — fall back to Nerdamer per-point
                }

                for (let j = 0; j <= numPoints; j++) {
                    const xv = xMin + (xMax - xMin) * j / numPoints;
                    try {
                        let yv;
                        if (compiled) {
                            yv = compiled.evaluate({ x: xv });
                        } else {
                            nerdamer.setVar('x', String(xv));
                            yv = parseFloat(nerdamer(yExpr).evaluate().text());
                            nerdamer.clearVars();
                        }
                        if (typeof yv === 'number' && isFinite(yv)) { xs.push(xv); ys.push(yv); }
                        else              { xs.push(null); ys.push(null); }
                    } catch (_) {
                        if (!compiled) nerdamer.clearVars();
                        xs.push(null); ys.push(null);
                    }
                }

                const branchSuffix = yExprs.length > 1 ? ` (branch ${ve + 1})` : '';
                traces.push({
                    x: xs, y: ys,
                    type: 'scatter', mode: 'lines',
                    name: equation + branchSuffix,
                    line: { color, width: 2 },
                    connectgaps: false
                });
            }

            return traces.length > 0 ? traces : null;
        } catch (e) {
            console.error('Nerdamer solve failed for:', equation, e);
            return null;
        }
    }

    /**
     * SymPy fallback for equation solving — solves for y and returns plot data.
     * Returns a Promise that resolves to array of Plotly traces or null.
     */
    solveAndPlotSymPy(equation, color, xMin, xMax, numPoints = 400) {
        const parts = equation.split('=');
        if (parts.length !== 2) return Promise.resolve(null);
        const lhs = GraphingEngine._toPython(parts[0].trim());
        const rhs = GraphingEngine._toPython(parts[1].trim());
        const step = (xMax - xMin) / numPoints;
        const code =
            'from sympy import *\n' +
            'import json, math\n' +
            'x, y = symbols("x y")\n' +
            'try:\n' +
            '    eq = (' + lhs + ')-(' + rhs + ')\n' +
            '    sols = solve(eq, y)\n' +
            '    if not sols:\n' +
            '        print("NOSOL")\n' +
            '    else:\n' +
            '        branches = []\n' +
            '        for s in sols:\n' +
            '            xs, ys = [], []\n' +
            '            for i in range(' + (numPoints + 1) + '):\n' +
            '                xv = ' + xMin + ' + i*' + step + '\n' +
            '                try:\n' +
            '                    yv = complex(s.subs(x, xv))\n' +
            '                    if abs(yv.imag) < 1e-10 and abs(yv.real) < 1e15:\n' +
            '                        xs.append(xv); ys.append(yv.real)\n' +
            '                    else:\n' +
            '                        xs.append(xv); ys.append(None)\n' +
            '                except:\n' +
            '                    xs.append(xv); ys.append(None)\n' +
            '            branches.append({"expr": str(s), "x": xs, "y": ys})\n' +
            '        print("EQSOL:" + json.dumps(branches))\n' +
            'except Exception as e:\n' +
            '    print("ERROR:" + str(e))';
        return this._sympyExec(code).then(stdout => {
            const m = stdout.match(/EQSOL:([\s\S]*)/);
            if (!m) return null;
            try {
                const branches = JSON.parse(m[1].trim());
                return branches.map((b, i) => ({
                    x: b.x, y: b.y,
                    type: 'scatter', mode: 'lines',
                    name: equation + (branches.length > 1 ? ` (branch ${i + 1})` : ''),
                    line: { color, width: 2 },
                    connectgaps: false
                }));
            } catch (e) { return null; }
        });
    }

    /**
     * SymPy fallback for symbolic derivative.
     * Returns a Promise that resolves to { x, y, symbolic } or null.
     */
    generateDerivativeSymPy(expression, xMin = -10, xMax = 10, numPoints = 500) {
        const pyExpr = GraphingEngine._toPython(this.stripCartesianPrefix(this.normalizeExpression(expression)));
        const code =
            'from sympy import *\n' +
            'import json\n' +
            'x = symbols("x")\n' +
            'try:\n' +
            '    expr = ' + pyExpr + '\n' +
            '    d = diff(expr, x)\n' +
            '    sym = str(d)\n' +
            '    xs = [' + xMin + ' + i*' + ((xMax - xMin) / numPoints) + ' for i in range(' + (numPoints + 1) + ')]\n' +
            '    ys = []\n' +
            '    for xv in xs:\n' +
            '        try:\n' +
            '            yv = float(d.subs(x, xv))\n' +
            '            ys.append(yv if abs(yv) < 1e15 else None)\n' +
            '        except: ys.append(None)\n' +
            '    print("DERIV:" + json.dumps({"symbolic": sym, "x": xs, "y": ys}))\n' +
            'except Exception as e:\n' +
            '    print("ERROR:" + str(e))';
        return this._sympyExec(code).then(stdout => {
            const m = stdout.match(/DERIV:([\s\S]*)/);
            if (!m) return null;
            try {
                const data = JSON.parse(m[1].trim());
                return { x: data.x, y: data.y, symbolic: data.symbolic };
            } catch (e) { return null; }
        });
    }

    /**
     * Plot all expressions
     */
    plot(settings = {}) {
        const {
            xMin = -10,
            xMax = 10,
            yMin = -10,
            yMax = 10,
            showGrid = true,
            showLegend = true
        } = settings;

        const traces = [];

        for (const expr of this.expressions) {
            if (!expr.visible) continue;

            // Use cached SymPy equation traces if already resolved
            if (expr._sympyResolved && expr._sympyTraces) {
                traces.push(...expr._sympyTraces);
                continue;
            }

            const trace = this.createTrace(expr, { xMin, xMax, yMin, yMax });

            if (trace) {
                if (Array.isArray(trace)) {
                    traces.push(...trace);
                } else {
                    traces.push(trace);
                }
            }

            // Inject cached SymPy antiderivative if resolved
            if (expr._sympyAntiResolved && expr._sympyAntiData) {
                const ad = expr._sympyAntiData;
                const adName = ad.symbolic
                    ? `F(x) = ${ad.symbolic} + C`
                    : `F(x) = ∫${expr.expression} dx`;
                traces.push({
                    x: ad.x, y: ad.y,
                    type: 'scatter', mode: 'lines',
                    name: adName,
                    line: { color: expr.color, width: 2, dash: 'dot' },
                    connectgaps: false
                });
            }

            // Inject cached SymPy derivative if resolved
            if (expr._sympyDerivResolved && expr._sympyDerivData) {
                const dd = expr._sympyDerivData;
                traces.push({
                    x: dd.x, y: dd.y,
                    type: 'scatter', mode: 'lines',
                    name: `f'(${expr.expression})`,
                    line: { color: expr.color, width: 2, dash: 'dash' },
                    connectgaps: false
                });
            }
        }

        const dark = !!(typeof window !== 'undefined' && window.GC_DARK);
        const is3D = traces.some(t => t.type === 'surface');

        // Preserve user zoom/pan: read current axis range from Plotly if available
        const graphDiv = document.getElementById(this.containerId);
        let effectiveXRange = [xMin, xMax];
        let effectiveYRange = [yMin, yMax];
        if (graphDiv && graphDiv.layout && !settings._forceRange) {
            const curX = graphDiv.layout.xaxis && graphDiv.layout.xaxis.range;
            const curY = graphDiv.layout.yaxis && graphDiv.layout.yaxis.range;
            if (curX && curX.length === 2) effectiveXRange = curX;
            if (curY && curY.length === 2) effectiveYRange = curY;
        }

        let layout;
        if (is3D) {
            layout = {
                margin: { t: 8, r: 8, b: 8, l: 8 },
                scene: {
                    xaxis: { title: 'x', showgrid: showGrid, gridcolor: dark ? '#374151' : '#e0e0e0', color: dark ? '#e5e7eb' : '#111827' },
                    yaxis: { title: 'y', showgrid: showGrid, gridcolor: dark ? '#374151' : '#e0e0e0', color: dark ? '#e5e7eb' : '#111827' },
                    zaxis: { title: 'z', showgrid: showGrid, gridcolor: dark ? '#374151' : '#e0e0e0', color: dark ? '#e5e7eb' : '#111827' },
                    bgcolor: dark ? '#0b1220' : '#fafafa'
                },
                showlegend: showLegend,
                paper_bgcolor: dark ? '#0b0f14' : 'white',
                font: { color: dark ? '#e5e7eb' : '#111827' }
            };
        } else {
            layout = {
                margin: { t: 8, r: 16, b: 32, l: 40 },
                xaxis: {
                    range: effectiveXRange,
                    zeroline: true,
                    showgrid: showGrid,
                    gridcolor: dark ? '#374151' : '#e0e0e0',
                    color: dark ? '#e5e7eb' : '#111827'
                },
                yaxis: {
                    range: effectiveYRange,
                    zeroline: true,
                    showgrid: showGrid,
                    gridcolor: dark ? '#374151' : '#e0e0e0',
                    color: dark ? '#e5e7eb' : '#111827',
                    scaleanchor: 'x'
                },
                showlegend: showLegend,
                legend: {
                    x: 1,
                    xanchor: 'right',
                    y: 1,
                    bgcolor: 'rgba(0,0,0,0)',
                    font: { size: 11, color: dark ? '#e5e7eb' : '#111827' }
                },
                hovermode: 'closest',
                plot_bgcolor: dark ? '#0b1220' : '#fafafa',
                paper_bgcolor: dark ? '#0b0f14' : 'white',
                font: { color: dark ? '#e5e7eb' : '#111827' }
            };
        }

        const config = {
            responsive: true,
            scrollZoom: true,
            displayModeBar: true,
            modeBarButtonsToRemove: is3D ? [] : ['lasso2d', 'select2d'],
            displaylogo: false
        };

        // 3D surface needs full Plotly (not plotly-basic). Lazy-load if needed.
        if (is3D && typeof Plotly.newPlot === 'function' && !Plotly.register) {
            // plotly-basic doesn't have surface — check if it's available
            console.warn('3D surface requires full Plotly. Attempting to load...');
        }

        if (graphDiv && graphDiv.data) {
            Plotly.react(this.containerId, traces, layout, config);
        } else {
            Plotly.newPlot(this.containerId, traces, layout, config);
        }

        // Trigger draw-on animation for line traces
        if (this._animateNext) {
            this._animateNext = false;
            this._animateTraces(traces, layout, config);
        }

        // SymPy async fallback for expressions that Nerdamer couldn't handle
        this._runSympyFallbacks(settings);
    }

    /**
     * Run SymPy fallbacks for any expressions flagged with _sympyNeeded.
     * Each fallback resolves async, then re-triggers a plot to update traces.
     */
    _runSympyFallbacks(settings) {
        const { xMin = -10, xMax = 10, yMin = -10, yMax = 10 } = settings;
        const promises = [];
        let count = 0;

        for (const expr of this.expressions) {
            if (!expr.visible) continue;

            // Equation solving fallback
            if (expr._sympyNeeded === 'equation' && !expr._sympyInFlight) {
                delete expr._sympyNeeded;
                expr._sympyInFlight = true;
                count++;
                const eqExpr = expr;
                promises.push(this.solveAndPlotSymPy(expr.expression, expr.color, xMin, xMax).then(traces => {
                    eqExpr._sympyInFlight = false;
                    if (traces && traces.length > 0) {
                        eqExpr._sympyTraces = traces;
                        eqExpr._sympyResolved = true;
                    }
                }));
            }

            // Antiderivative fallback
            if (expr._sympyAntiNeeded && !expr._sympyAntiInFlight) {
                const { expression, xMin: aMin, xMax: aMax } = expr._sympyAntiNeeded;
                delete expr._sympyAntiNeeded;
                expr._sympyAntiInFlight = true;
                count++;
                const antiExpr = expr;
                promises.push(this.generateAntiderivativeSymPy(expression, aMin, aMax).then(data => {
                    antiExpr._sympyAntiInFlight = false;
                    if (data) {
                        antiExpr._sympyAntiData = data;
                        antiExpr._sympyAntiResolved = true;
                    }
                }));
            }

            // Derivative fallback
            if (expr._sympyDerivNeeded && !expr._sympyDerivInFlight) {
                const { expression: dExpr, xMin: dMin, xMax: dMax } = expr._sympyDerivNeeded;
                delete expr._sympyDerivNeeded;
                expr._sympyDerivInFlight = true;
                count++;
                const derivExpr = expr;
                promises.push(this.generateDerivativeSymPy(dExpr, dMin, dMax).then(data => {
                    derivExpr._sympyDerivInFlight = false;
                    if (data) {
                        derivExpr._sympyDerivData = data;
                        derivExpr._sympyDerivResolved = true;
                    }
                }));
            }

            // Limit fallback
            if (expr._sympyLimitNeeded && !expr._sympyLimitInFlight) {
                const { limitExpr, limitVar, limitVal } = expr._sympyLimitNeeded;
                delete expr._sympyLimitNeeded;
                expr._sympyLimitInFlight = true;
                count++;
                const limExpr = expr;
                promises.push(this.evaluateLimitSymPy(limitExpr, limitVar, limitVal).then(result => {
                    limExpr._sympyLimitInFlight = false;
                    if (result) {
                        limExpr._sympyLimitResult = result;
                        limExpr._sympyLimitResolved = true;
                    }
                }));
            }
        }

        if (count === 0) return;
        this._sympyPending += count;
        this._showSympyIndicator('Solving...');

        Promise.all(promises).then(() => {
            this._sympyPending -= count;
            if (this._sympyPending <= 0) {
                this._sympyPending = 0;
                this._hideSympyIndicator();
            }
            // Re-plot with SymPy results
            const hasResults = this.expressions.some(e => e._sympyResolved || e._sympyAntiResolved || e._sympyLimitResolved);
            if (hasResults) {
                this._replotWithSymPy(settings);
            }
        });
    }

    /**
     * Re-plot incorporating SymPy-resolved traces.
     * For equation types, replaces the whole trace set.
     * For antiderivative/limit, adds to the existing createTrace output.
     */
    _replotWithSymPy(settings) {
        const { xMin = -10, xMax = 10, yMin = -10, yMax = 10, showGrid = true, showLegend = true } = settings;
        const traces = [];

        for (const expr of this.expressions) {
            if (!expr.visible) continue;

            // Use SymPy-resolved equation traces (keep data for future re-plots)
            if (expr._sympyResolved && expr._sympyTraces) {
                traces.push(...expr._sympyTraces);
                continue;
            }

            const trace = this.createTrace(expr, { xMin, xMax, yMin, yMax });
            if (trace) {
                if (Array.isArray(trace)) traces.push(...trace);
                else traces.push(trace);
            }

            // Inject SymPy antiderivative data as additional trace (keep data for future re-plots)
            if (expr._sympyAntiResolved && expr._sympyAntiData) {
                const ad = expr._sympyAntiData;
                const adName = ad.symbolic
                    ? `F(x) = ${ad.symbolic} + C`
                    : `F(x) = ∫${expr.expression} dx`;
                traces.push({
                    x: ad.x, y: ad.y,
                    type: 'scatter', mode: 'lines',
                    name: adName,
                    line: { color: expr.color, width: 2, dash: 'dot' },
                    connectgaps: false
                });
            }

            // Inject SymPy derivative data as additional trace
            if (expr._sympyDerivResolved && expr._sympyDerivData) {
                const dd = expr._sympyDerivData;
                traces.push({
                    x: dd.x, y: dd.y,
                    type: 'scatter', mode: 'lines',
                    name: `f'(${expr.expression})`,
                    line: { color: expr.color, width: 2, dash: 'dash' },
                    connectgaps: false
                });
            }
        }

        const dark = !!(typeof window !== 'undefined' && window.GC_DARK);
        const layout = {
            margin: { t: 8, r: 16, b: 32, l: 40 },
            xaxis: { range: [xMin, xMax], zeroline: true, showgrid: showGrid, gridcolor: dark ? '#374151' : '#e0e0e0', color: dark ? '#e5e7eb' : '#111827' },
            yaxis: { range: [yMin, yMax], zeroline: true, showgrid: showGrid, gridcolor: dark ? '#374151' : '#e0e0e0', color: dark ? '#e5e7eb' : '#111827', scaleanchor: 'x' },
            showlegend: showLegend,
            legend: { x: 1, xanchor: 'right', y: 1, bgcolor: 'rgba(0,0,0,0)', font: { size: 11, color: dark ? '#e5e7eb' : '#111827' } },
            hovermode: 'closest',
            plot_bgcolor: dark ? '#0b1220' : '#fafafa',
            paper_bgcolor: dark ? '#0b0f14' : 'white',
            font: { color: dark ? '#e5e7eb' : '#111827' }
        };
        const config = { responsive: true, scrollZoom: true, displayModeBar: true, modeBarButtonsToRemove: ['lasso2d', 'select2d'], displaylogo: false };
        Plotly.react(this.containerId, traces, layout, config);
    }

    /**
     * Animate traces drawing on progressively (curve draw-on effect)
     */
    _animateTraces(fullTraces, layout, config) {
        const lineTraces = [];
        const staticTraces = [];

        fullTraces.forEach((t, i) => {
            if ((t.mode === 'lines' || t.mode === 'markers') && t.x && t.x.length > 10) {
                lineTraces.push({ index: i, trace: t });
            } else {
                staticTraces.push({ index: i, trace: t });
            }
        });

        if (lineTraces.length === 0) return;

        const totalFrames = 60;
        let frame = 0;
        const containerId = this.containerId;

        // Start with empty line traces + all static traces
        const initialTraces = fullTraces.map((t, i) => {
            const lt = lineTraces.find(l => l.index === i);
            if (lt) {
                return Object.assign({}, t, { x: [], y: [] });
            }
            return t;
        });

        Plotly.react(containerId, initialTraces, layout, config);

        const step = () => {
            frame++;
            const progress = frame / totalFrames;
            // Ease-out cubic for smooth deceleration
            const eased = 1 - Math.pow(1 - progress, 3);

            const updatedTraces = fullTraces.map((t, i) => {
                const lt = lineTraces.find(l => l.index === i);
                if (lt) {
                    const len = Math.floor(eased * t.x.length);
                    return Object.assign({}, t, {
                        x: t.x.slice(0, len),
                        y: t.y.slice(0, len)
                    });
                }
                return t;
            });

            Plotly.react(containerId, updatedTraces, layout, config);

            if (frame < totalFrames) {
                requestAnimationFrame(step);
            }
        };

        requestAnimationFrame(step);
    }
}

// Global state
let engine;
let expressionElements = {};
let animationState = {
    isPlaying: false,
    animationId: null,
    paramName: null,
    exprId: null,
    currentValue: -10,
    speed: 0.1
};
let traceModeActive = false;

// Undo/redo state
const undoStack = [];
const redoStack = [];
const MAX_UNDO = 50;

/**
 * Save current expression state for undo
 */
/** Serialize current expression state (shared by undo/redo/save) */
function _serializeExpressions() {
    return engine.expressions.map(function(e) {
        return {
            id: e.id, expression: e.expression, type: e.type,
            color: e.color, visible: e.visible,
            parameters: e.parameters ? Object.assign({}, e.parameters) : undefined,
            _sliderRanges: e._sliderRanges ? JSON.parse(JSON.stringify(e._sliderRanges)) : undefined,
            _varName: e._varName, _varValue: e._varValue,
            _listValues: e._listValues, _listName: e._listName,
            pieces: e.pieces ? JSON.parse(JSON.stringify(e.pieces)) : undefined,
            showDerivative: e.showDerivative || false,
            showSecondDerivative: e.showSecondDerivative || false,
            showCriticalPoints: e.showCriticalPoints || false,
            showInflectionPoints: e.showInflectionPoints || false,
            showRoots: e.showRoots || false,
            showVerticalAsymptotes: e.showVerticalAsymptotes || false,
            showTangent: e.showTangent || false,
            tangentX: e.tangentX,
            showIntegration: e.showIntegration || false,
            integrationBounds: e.integrationBounds,
            showAntiderivative: e.showAntiderivative || false,
            _originalInput: e._originalInput || undefined
        };
    });
}

function saveUndoState() {
    const state = _serializeExpressions();
    undoStack.push(JSON.stringify(state));
    if (undoStack.length > MAX_UNDO) undoStack.shift();
    redoStack.length = 0; // clear redo on new action
}

/**
 * Undo last expression change
 */
function undo() {
    if (undoStack.length === 0) return;
    redoStack.push(JSON.stringify(_serializeExpressions()));
    const prevState = JSON.parse(undoStack.pop());
    restoreState(prevState);
}

/**
 * Redo last undone change
 */
function redo() {
    if (redoStack.length === 0) return;
    undoStack.push(JSON.stringify(_serializeExpressions()));
    const nextState = JSON.parse(redoStack.pop());
    restoreState(nextState);
}

/**
 * Restore expressions from saved state
 */
function restoreState(state) {
    // Clear existing UI
    const container = document.getElementById('expressions-list');
    if (container) container.innerHTML = '';
    expressionElements = {};

    // Cleanup all MathQuill fields and input mode flags
    Object.keys(_mqFields).forEach(k => delete _mqFields[k]);
    Object.keys(_mqInputMode).forEach(k => delete _mqInputMode[k]);

    // Stop any running animation
    if (animationState.isPlaying) stopAnimation();

    // Restore expressions
    engine.expressions = [];
    engine.nextId = 1;
    state.forEach(s => {
        const expr = engine.addExpression(s.expression || '', s.type || 'cartesian');
        expr.color = s.color || expr.color;
        expr.visible = s.visible !== false;
        if (s.parameters) expr.parameters = s.parameters;
        if (s._sliderRanges) expr._sliderRanges = s._sliderRanges;
        if (s._varName) { expr._varName = s._varName; expr._varValue = s._varValue; }
        if (s._listValues) { expr._listValues = s._listValues; expr._listName = s._listName; }
        if (s.pieces) expr.pieces = s.pieces;
        if (s.showDerivative) expr.showDerivative = true;
        if (s.showRoots) expr.showRoots = true;
        if (s.showVerticalAsymptotes) expr.showVerticalAsymptotes = true;
        if (s.showTangent) { expr.showTangent = true; expr.tangentX = s.tangentX; }
        if (s.showIntegration) { expr.showIntegration = true; expr.integrationBounds = s.integrationBounds; }
        if (s.showAntiderivative) expr.showAntiderivative = true;
        if (s._originalInput) expr._originalInput = s._originalInput;
        createExpressionElement(expr);
        // Set type dropdown
        const typeSel = document.getElementById(`type-${expr.id}`);
        if (typeSel) typeSel.value = expr.type;
        // Set expression input (plain text fallback — MQ fields are populated by _initMathQuillField)
        if (!_mqFields[expr.id]) {
            const input = document.getElementById(`expr-${expr.id}`);
            if (input) input.value = expr.expression || '';
        }
        // Set color
        const colorPicker = document.getElementById(`color-${expr.id}`);
        if (colorPicker) colorPicker.value = expr.color;
        // Restore checkbox states
        if (s.showRoots) { const cb = document.getElementById(`show-roots-${expr.id}`); if (cb) cb.checked = true; }
        if (s.showVerticalAsymptotes) { const cb = document.getElementById(`show-vasym-${expr.id}`); if (cb) cb.checked = true; }
        if (s.showTangent) { const cb = document.getElementById(`show-tangent-${expr.id}`); if (cb) cb.checked = true; }
        if (s.showDerivative) { const cb = document.getElementById(`show-derivative-${expr.id}`); if (cb) cb.checked = true; }
        if (s.showIntegration) { const cb = document.getElementById(`show-integration-${expr.id}`); if (cb) cb.checked = true; }
        if (s.showAntiderivative) { const cb = document.getElementById(`show-antiderivative-${expr.id}`); if (cb) cb.checked = true; }
        // Auto-open calc drawer if any calculus feature is active
        if (s.showDerivative || s.showIntegration || s.showAntiderivative || s.showRoots || s.showVerticalAsymptotes || s.showTangent) {
            const item = document.getElementById(`expr-item-${expr.id}`);
            if (item) {
                item.classList.add('gc-calc-open');
                const calcBtn = item.querySelector('.gc-calc-toggle-btn');
                if (calcBtn) {
                    calcBtn.setAttribute('aria-expanded', 'true');
                    calcBtn.innerHTML = '<i class="fas fa-chevron-up"></i> Calc';
                }
            }
        }
    });
    // Rebuild global scope from any restored variable/list expressions
    engine.rebuildGlobalScope();
    // Re-process variable and list expressions to populate their UI
    engine.expressions.forEach(function(ex) {
        if (ex.type === 'variable' && ex.expression) _handleVariableExpression(ex.id, ex.expression);
        if (ex.type === 'list' && ex.expression) _handleListExpression(ex.id, ex.expression);
    });
    updateGraph();
}

/**
 * Initialize keyboard shortcuts
 */
function initKeyboardShortcuts() {
    document.addEventListener('keydown', function(e) {
        var active = document.activeElement;
        var inInput = active && (active.tagName === 'INPUT' || active.tagName === 'TEXTAREA' || active.isContentEditable);
        var mod = e.ctrlKey || e.metaKey;

        // ---- Global shortcuts (work everywhere) ----

        // Ctrl/Cmd + Enter = Add new expression
        if (mod && e.key === 'Enter') {
            e.preventDefault();
            addExpression();
            // Focus the new expression's input
            setTimeout(function() {
                var exprs = engine.expressions;
                if (exprs.length > 0) {
                    var lastId = exprs[exprs.length - 1].id;
                    var inp = document.getElementById('expr-' + lastId);
                    if (inp) inp.focus();
                    else if (_mqFields[lastId]) _mqFields[lastId].focus();
                }
            }, 50);
            return;
        }

        // Escape = Close calc drawer, close trace mode, blur active input
        if (e.key === 'Escape') {
            // Close any open calc drawer first
            var openDrawer = document.querySelector('.gc-calc-open');
            if (openDrawer) {
                var drawerId = openDrawer.id.replace('expr-item-', '');
                if (drawerId) toggleCalcDrawer(parseInt(drawerId));
                return;
            }
            if (traceModeActive) { toggleTraceMode(); return; }
            if (inInput && active) { active.blur(); return; }
            return;
        }

        // Ctrl/Cmd + S = Save to localStorage (prevent browser save dialog)
        if (mod && e.key === 's') {
            e.preventDefault();
            if (typeof saveState === 'function') {
                var name = prompt('Save name:');
                if (name) saveState(name);
            }
            return;
        }

        // Ctrl/Cmd + E = Export PNG
        if (mod && !e.shiftKey && e.key === 'e') {
            e.preventDefault();
            if (typeof exportGraph === 'function') exportGraph('png');
            return;
        }

        // Ctrl/Cmd + Shift + E = Export SVG
        if (mod && e.shiftKey && e.key === 'E') {
            e.preventDefault();
            if (typeof exportGraph === 'function') exportGraph('svg');
            return;
        }

        // ---- Non-input shortcuts (only when not in a text field) ----
        if (!inInput) {
            // Ctrl/Cmd + Z = Undo
            if (mod && !e.shiftKey && e.key === 'z') {
                e.preventDefault(); undo(); return;
            }
            // Ctrl/Cmd + Shift + Z or Ctrl/Cmd + Y = Redo
            if (mod && ((e.shiftKey && (e.key === 'z' || e.key === 'Z')) || e.key === 'y')) {
                e.preventDefault(); redo(); return;
            }
            // T = Toggle trace mode
            if (e.key === 't' || e.key === 'T') {
                e.preventDefault();
                if (typeof toggleTraceMode === 'function') toggleTraceMode();
                return;
            }
            // D = Toggle dark mode
            if (e.key === 'd' || e.key === 'D') {
                e.preventDefault();
                if (typeof toggleDarkMode === 'function') toggleDarkMode();
                return;
            }
            // G = Toggle grid
            if (e.key === 'g' || e.key === 'G') {
                e.preventDefault();
                var gridCb = document.getElementById('showGrid');
                if (gridCb) { gridCb.checked = !gridCb.checked; updateGraph(); }
                return;
            }
            // F = Fit/reset zoom
            if (e.key === 'f' || e.key === 'F') {
                e.preventDefault();
                if (typeof resetZoom === 'function') resetZoom();
                return;
            }
            // / (slash) = Focus search / first expression input
            if (e.key === '/') {
                e.preventDefault();
                if (engine.expressions.length > 0) {
                    var firstId = engine.expressions[0].id;
                    var firstInput = document.getElementById('expr-' + firstId);
                    if (firstInput) firstInput.focus();
                    else if (_mqFields[firstId]) _mqFields[firstId].focus();
                }
                return;
            }
            // ? = Show keyboard shortcuts help
            if (e.key === '?') {
                e.preventDefault();
                _showKeyboardShortcutsHelp();
                return;
            }
        }

        // ---- Expression input shortcuts (when inside an expression field) ----
        if (inInput) {
            // Find which expression we're in
            var exprItem = active.closest ? active.closest('.expression-item') : null;
            var exprId = exprItem ? parseInt(exprItem.id.replace('expr-item-', '')) : null;

            // Alt + Up / Alt + Down = Navigate between expressions
            if (e.altKey && (e.key === 'ArrowUp' || e.key === 'ArrowDown')) {
                e.preventDefault();
                var ids = engine.expressions.map(function(ex) { return ex.id; });
                var idx = ids.indexOf(exprId);
                if (idx === -1) return;
                var nextIdx = e.key === 'ArrowUp' ? idx - 1 : idx + 1;
                if (nextIdx < 0 || nextIdx >= ids.length) return;
                var nextId = ids[nextIdx];
                var nextInput = document.getElementById('expr-' + nextId);
                if (nextInput) nextInput.focus();
                else if (_mqFields[nextId]) _mqFields[nextId].focus();
                return;
            }

            // Alt + Backspace / Alt + Delete = Delete current expression
            if (e.altKey && (e.key === 'Backspace' || e.key === 'Delete') && exprId !== null) {
                e.preventDefault();
                // Focus next expression before deleting
                var ids2 = engine.expressions.map(function(ex) { return ex.id; });
                var idx2 = ids2.indexOf(exprId);
                var focusId = idx2 < ids2.length - 1 ? ids2[idx2 + 1] : (idx2 > 0 ? ids2[idx2 - 1] : null);
                deleteExpression(exprId);
                if (focusId !== null) {
                    var focusInput = document.getElementById('expr-' + focusId);
                    if (focusInput) focusInput.focus();
                    else if (_mqFields[focusId]) _mqFields[focusId].focus();
                }
                return;
            }

            // Alt + H = Toggle visibility of current expression
            if (e.altKey && (e.key === 'h' || e.key === 'H') && exprId !== null) {
                e.preventDefault();
                var eObj = engine.expressions.find(function(ex) { return ex.id === exprId; });
                if (eObj) {
                    eObj.visible = !eObj.visible;
                    updateGraph();
                }
                return;
            }

            // Alt + C = Open calculus drawer for current expression
            if (e.altKey && (e.key === 'c' || e.key === 'C') && exprId !== null) {
                e.preventDefault();
                toggleCalcDrawer(exprId);
                return;
            }
        }
    });
}

/**
 * Show a modal/toast with keyboard shortcuts
 */
function _showKeyboardShortcutsHelp() {
    var existing = document.getElementById('gc-shortcuts-modal');
    if (existing) { existing.remove(); return; }

    var overlay = document.createElement('div');
    overlay.id = 'gc-shortcuts-modal';
    overlay.style.cssText = 'position:fixed;inset:0;z-index:10000;display:flex;align-items:center;justify-content:center;background:rgba(0,0,0,0.5);';
    overlay.onclick = function(ev) { if (ev.target === overlay) overlay.remove(); };

    var isDark = typeof GC_DARK !== 'undefined' && GC_DARK;
    var bg = isDark ? '#1e1e2e' : '#fff';
    var fg = isDark ? '#cdd6f4' : '#333';
    var kbd = isDark ? '#313244' : '#eee';

    overlay.innerHTML = '<div style="background:' + bg + ';color:' + fg + ';border-radius:12px;padding:24px 32px;max-width:480px;width:90%;max-height:80vh;overflow-y:auto;box-shadow:0 8px 32px rgba(0,0,0,0.3);">' +
        '<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">' +
        '<h3 style="margin:0;font-size:16px;">Keyboard Shortcuts</h3>' +
        '<button onclick="this.closest(\'#gc-shortcuts-modal\').remove()" style="border:none;background:none;font-size:18px;cursor:pointer;color:' + fg + ';">&times;</button></div>' +
        '<table style="width:100%;font-size:13px;border-collapse:collapse;">' +
        _shortcutRow('Ctrl+Enter', 'Add new expression', kbd) +
        _shortcutRow('Escape', 'Close drawer / blur input', kbd) +
        _shortcutRow('Ctrl+Z', 'Undo', kbd) +
        _shortcutRow('Ctrl+Shift+Z', 'Redo', kbd) +
        _shortcutRow('Ctrl+S', 'Save state', kbd) +
        _shortcutRow('Ctrl+E', 'Export PNG', kbd) +
        _shortcutRow('Ctrl+Shift+E', 'Export SVG', kbd) +
        '<tr><td colspan="2" style="padding:8px 0 4px;font-weight:600;border-top:1px solid ' + kbd + ';">When not in input</td></tr>' +
        _shortcutRow('T', 'Toggle trace mode', kbd) +
        _shortcutRow('D', 'Toggle dark mode', kbd) +
        _shortcutRow('G', 'Toggle grid', kbd) +
        _shortcutRow('F', 'Reset zoom / fit', kbd) +
        _shortcutRow('/', 'Focus first expression', kbd) +
        _shortcutRow('?', 'Show this help', kbd) +
        '<tr><td colspan="2" style="padding:8px 0 4px;font-weight:600;border-top:1px solid ' + kbd + ';">When in expression input</td></tr>' +
        _shortcutRow('Alt+Up/Down', 'Navigate expressions', kbd) +
        _shortcutRow('Alt+Backspace', 'Delete expression', kbd) +
        _shortcutRow('Alt+H', 'Toggle visibility', kbd) +
        _shortcutRow('Alt+C', 'Toggle calculus drawer', kbd) +
        '</table></div>';

    document.body.appendChild(overlay);
}

function _shortcutRow(key, desc, kbdColor) {
    return '<tr><td style="padding:4px 8px 4px 0;"><kbd style="background:' + kbdColor + ';padding:2px 6px;border-radius:3px;font-size:11px;font-family:monospace;">' + key + '</kbd></td><td style="padding:4px 0;">' + desc + '</td></tr>';
}

/**
 * Initialize the graphing engine
 */
function initGraph() {
    if (typeof math === 'undefined') {
        console.error('Math.js not loaded!');
        return;
    }

    if (typeof Plotly === 'undefined') {
        console.error('Plotly.js not loaded!');
        return;
    }

    engine = new GraphingEngine('graph');

    // Prevent sample chip buttons from stealing focus (fixes :focus-within timing)
    const exprList = document.getElementById('expressions-list');
    if (exprList) {
        exprList.addEventListener('mousedown', function(e) {
            if (e.target.closest('.gc-sample-chips')) {
                e.preventDefault();
            }
        });
    }

    // Try to load from URL first
    loadFromURL();

    // If nothing loaded from URL, add default expression
    if (engine.expressions.length === 0) {
        addExpression();
    }

    // Update graph
    updateGraph();

    // Auto-focus the first expression input
    const firstInput = document.querySelector('.expression-input');
    if (firstInput) firstInput.focus();

    // Initialize keyboard shortcuts (Ctrl+Z undo, Ctrl+Shift+Z redo, Ctrl+Enter add expr)
    initKeyboardShortcuts();
}

/**
 * Add a new expression input
 */
function addExpression() {
    saveUndoState();
    const expr = engine.addExpression('', 'cartesian');
    createExpressionElement(expr);
}

/**
 * Add a collapsible folder/group for organizing expressions
 */
let _folderIdCounter = 0;
function addFolder() {
    _folderIdCounter++;
    const folderId = _folderIdCounter;
    const container = document.getElementById('expressions-list');
    if (!container) return;

    const div = document.createElement('div');
    div.className = 'gc-folder';
    div.id = `folder-${folderId}`;
    div.style.cssText = 'border:1px solid #ddd;border-radius:6px;margin:6px 0;background:#fafafa;';

    div.innerHTML = `
        <div class="d-flex align-items-center gap-2 p-2" style="cursor:pointer;background:#f0f0f0;border-radius:6px 6px 0 0;" onclick="toggleFolder(${folderId})">
            <i class="fas fa-chevron-down" id="folder-icon-${folderId}" style="font-size:10px;transition:transform 0.2s;"></i>
            <input type="text" class="form-control form-control-sm" value="Group ${folderId}" id="folder-name-${folderId}"
                   style="border:none;background:transparent;font-weight:600;font-size:12px;width:auto;flex:1;" onclick="event.stopPropagation()">
            <button class="btn btn-sm" style="font-size:10px;padding:0 4px;color:#888;" onclick="event.stopPropagation();addExprToFolder(${folderId})" title="Add expression to folder">
                <i class="fas fa-plus"></i>
            </button>
            <button class="btn btn-sm" style="font-size:10px;padding:0 4px;color:#c00;" onclick="event.stopPropagation();removeFolder(${folderId})" title="Remove folder">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div id="folder-content-${folderId}" class="p-1" style=""></div>
    `;
    container.appendChild(div);
}

function toggleFolder(folderId) {
    const content = document.getElementById(`folder-content-${folderId}`);
    const icon = document.getElementById(`folder-icon-${folderId}`);
    if (!content) return;
    const isHidden = content.style.display === 'none';
    content.style.display = isHidden ? '' : 'none';
    if (icon) icon.style.transform = isHidden ? '' : 'rotate(-90deg)';
}

function addExprToFolder(folderId) {
    const folderContent = document.getElementById(`folder-content-${folderId}`);
    if (!folderContent) return;

    const expr = engine.addExpression('', 'cartesian');
    // Create the element in the folder instead of the main list
    const div = document.createElement('div');
    div.className = 'expression-item';
    div.id = `expr-item-${expr.id}`;
    div.setAttribute('role', 'group');
    div.setAttribute('aria-label', `Expression ${expr.id}`);
    expressionElements[expr.id] = div;
    folderContent.appendChild(div);

    // Reuse createExpressionElement logic for the content
    _populateExpressionDiv(div, expr);
}

function removeFolder(folderId) {
    saveUndoState();
    const folder = document.getElementById(`folder-${folderId}`);
    if (!folder) return;
    // Delete all expressions in the folder
    const items = folder.querySelectorAll('.expression-item');
    items.forEach(item => {
        const idMatch = item.id.match(/expr-item-(\d+)/);
        if (idMatch) {
            const exprId = parseInt(idMatch[1]);
            if (_tableExprId === exprId) _closeTable();
            engine.removeExpression(exprId);
            delete expressionElements[exprId];
        }
    });
    folder.remove();
    updateGraph();
}

/**
 * Short label for expression type badge
 */
function _getTypeBadgeLabel(type) {
    const labels = {
        cartesian: 'y=f', equation: 'EQ', parametric: 'PAR', polar: 'POL',
        inequality: 'INQ', limit: 'LIM', piecewise: 'PCW', implicit: 'IMP',
        surface: '3D', point: 'PT', table: 'TBL', statistics: 'REG',
        distribution: 'DST', vector: 'VEC', vectorfield: 'VFD',
        variable: 'VAR', list: 'LST'
    };
    return labels[type] || type;
}

/**
 * Toggle calculus drawer open/closed
 */
function toggleCalcDrawer(id) {
    const item = document.getElementById(`expr-item-${id}`);
    if (!item) return;
    item.classList.toggle('gc-calc-open');
    const btn = item.querySelector('.gc-calc-toggle-btn');
    if (btn) {
        const isOpen = item.classList.contains('gc-calc-open');
        btn.setAttribute('aria-expanded', isOpen);
        btn.innerHTML = isOpen
            ? '<i class="fas fa-chevron-up"></i> Calc'
            : '<i class="fas fa-sliders"></i> Calc';
    }
}

/**
 * Open the type select dropdown via the type badge click
 */
function openTypeSelect(id) {
    const sel = document.getElementById(`type-${id}`);
    if (!sel) return;
    // showPicker() is modern; fallback to focus+click
    if (typeof sel.showPicker === 'function') {
        try { sel.showPicker(); return; } catch (_) {}
    }
    sel.focus();
    sel.click();
}

/* =========================================================================
   Drag & Drop Reorder
   ========================================================================= */
var _dragState = { draggedId: null, placeholder: null };

function _initDragHandlers(div, exprId) {
    div.setAttribute('draggable', 'false'); // only drag handle initiates
    const handle = div.querySelector('.gc-drag-handle');
    if (!handle) return;

    handle.addEventListener('mousedown', function() { div.setAttribute('draggable', 'true'); });
    handle.addEventListener('touchstart', function() { div.setAttribute('draggable', 'true'); }, { passive: true });

    div.addEventListener('dragstart', function(e) {
        _dragState.draggedId = exprId;
        div.classList.add('gc-dragging');
        e.dataTransfer.effectAllowed = 'move';
        e.dataTransfer.setData('text/plain', String(exprId));
        // Create placeholder
        const ph = document.createElement('div');
        ph.className = 'gc-drag-placeholder';
        _dragState.placeholder = ph;
    });

    div.addEventListener('dragend', function() {
        div.setAttribute('draggable', 'false');
        div.classList.remove('gc-dragging');
        if (_dragState.placeholder && _dragState.placeholder.parentNode) {
            _dragState.placeholder.remove();
        }
        _dragState.draggedId = null;
        _dragState.placeholder = null;
    });

    div.addEventListener('dragover', function(e) {
        e.preventDefault();
        e.dataTransfer.dropEffect = 'move';
        if (_dragState.draggedId == null || _dragState.draggedId === exprId) return;
        const rect = div.getBoundingClientRect();
        const midY = rect.top + rect.height / 2;
        const container = div.parentNode;
        if (_dragState.placeholder && _dragState.placeholder.parentNode) {
            _dragState.placeholder.remove();
        }
        if (e.clientY < midY) {
            container.insertBefore(_dragState.placeholder, div);
        } else {
            container.insertBefore(_dragState.placeholder, div.nextSibling);
        }
    });

    div.addEventListener('drop', function(e) {
        e.preventDefault();
        const fromId = _dragState.draggedId;
        if (fromId == null || fromId === exprId) return;
        const fromDiv = document.getElementById(`expr-item-${fromId}`);
        if (!fromDiv || !_dragState.placeholder) return;

        // Insert dragged element at placeholder position (works in folders too)
        const targetContainer = _dragState.placeholder.parentNode;
        if (targetContainer) {
            targetContainer.insertBefore(fromDiv, _dragState.placeholder);
            _dragState.placeholder.remove();
        }

        // Reorder engine.expressions to match DOM order
        _syncExpressionOrder();
        updateGraph();
    });
}

function _syncExpressionOrder() {
    const container = document.getElementById('expressions-list');
    if (!container) return;
    const items = container.querySelectorAll('.expression-item');
    const newOrder = [];
    items.forEach(item => {
        const match = item.id.match(/expr-item-(\d+)/);
        if (match) {
            const id = parseInt(match[1]);
            const expr = engine.expressions.find(e => e.id === id);
            if (expr) newOrder.push(expr);
        }
    });
    // Preserve any expressions not in the DOM (e.g., in folders)
    engine.expressions.forEach(e => {
        if (!newOrder.find(n => n.id === e.id)) newOrder.push(e);
    });
    engine.expressions = newOrder;
}

/* =========================================================================
   Numeric Evaluation (Desmos-style: type "2+3" → shows "= 5")
   Handles special forms: int(), sum(), prod(), deriv(), nCr(), nPr()
   ========================================================================= */

/** Format a numeric result for display */
function _formatNumericResult(val) {
    if (typeof val !== 'number' || !isFinite(val)) return null;
    if (Number.isInteger(val)) return '= ' + val;
    return '= ' + parseFloat(val.toPrecision(10));
}

/** Show a numeric result (number or complex) in the result element */
function _showNumericResult(resultEl, result) {
    if (typeof result === 'number' && isFinite(result)) {
        resultEl.textContent = _formatNumericResult(result);
        resultEl.style.display = '';
        return true;
    }
    if (typeof result === 'object' && result && typeof result.re === 'number') {
        var re = parseFloat(result.re.toPrecision(8));
        var im = parseFloat(result.im.toPrecision(8));
        if (im === 0) resultEl.textContent = '= ' + re;
        else if (re === 0) resultEl.textContent = '= ' + im + 'i';
        else resultEl.textContent = '= ' + re + (im > 0 ? ' + ' : ' - ') + Math.abs(im) + 'i';
        resultEl.style.display = '';
        return true;
    }
    return false;
}

/**
 * Numerically integrate f(x) from a to b using composite Simpson's rule (1000 intervals)
 */
function _numericIntegrate(exprStr, a, b) {
    try {
        var normalized = engine.normalizeExpression(exprStr);
        // Substitute global scope
        if (engine.globalScope) {
            Object.keys(engine.globalScope).forEach(function(v) {
                if (typeof engine.globalScope[v] === 'number') {
                    normalized = normalized.replace(new RegExp('\\b' + v + '\\b', 'g'), '(' + engine.globalScope[v] + ')');
                }
            });
        }
        var compiled = math.compile(normalized);
        var n = 1000;
        var h = (b - a) / n;
        var sum = compiled.evaluate({ x: a }) + compiled.evaluate({ x: b });
        for (var i = 1; i < n; i++) {
            var xi = a + i * h;
            sum += (i % 2 === 0 ? 2 : 4) * compiled.evaluate({ x: xi });
        }
        return (h / 3) * sum;
    } catch (_) {
        return null;
    }
}

/**
 * Numerically evaluate sum(varName, start, end, body)
 */
function _numericSum(varName, start, end, bodyExpr) {
    try {
        var normalized = engine.normalizeExpression(bodyExpr);
        if (engine.globalScope) {
            Object.keys(engine.globalScope).forEach(function(v) {
                if (typeof engine.globalScope[v] === 'number') {
                    normalized = normalized.replace(new RegExp('\\b' + v + '\\b', 'g'), '(' + engine.globalScope[v] + ')');
                }
            });
        }
        var compiled = math.compile(normalized);
        var total = 0;
        for (var i = start; i <= end; i++) {
            var scope = {};
            scope[varName] = i;
            total += compiled.evaluate(scope);
        }
        return total;
    } catch (_) {
        return null;
    }
}

/**
 * Numerically evaluate prod(varName, start, end, body)
 */
function _numericProd(varName, start, end, bodyExpr) {
    try {
        var normalized = engine.normalizeExpression(bodyExpr);
        if (engine.globalScope) {
            Object.keys(engine.globalScope).forEach(function(v) {
                if (typeof engine.globalScope[v] === 'number') {
                    normalized = normalized.replace(new RegExp('\\b' + v + '\\b', 'g'), '(' + engine.globalScope[v] + ')');
                }
            });
        }
        var compiled = math.compile(normalized);
        var total = 1;
        for (var i = start; i <= end; i++) {
            var scope = {};
            scope[varName] = i;
            total *= compiled.evaluate(scope);
        }
        return total;
    } catch (_) {
        return null;
    }
}

/**
 * Numerical derivative of f(x) at x=x0 using central difference
 */
function _numericDeriv(exprStr, x0) {
    try {
        var normalized = engine.normalizeExpression(exprStr);
        if (engine.globalScope) {
            Object.keys(engine.globalScope).forEach(function(v) {
                if (typeof engine.globalScope[v] === 'number') {
                    normalized = normalized.replace(new RegExp('\\b' + v + '\\b', 'g'), '(' + engine.globalScope[v] + ')');
                }
            });
        }
        var compiled = math.compile(normalized);
        var h = 0.0001;
        var fPlus = compiled.evaluate({ x: x0 + h });
        var fMinus = compiled.evaluate({ x: x0 - h });
        return (fPlus - fMinus) / (2 * h);
    } catch (_) {
        return null;
    }
}

function _evaluateNumeric(id, exprStr) {
    var resultEl = document.getElementById('numeric-result-' + id);
    if (!resultEl) return;

    // Only evaluate for types where a numeric result makes sense
    var exprObjCheck = engine.expressions.find(function(e) { return e.id === id; });
    if (exprObjCheck && !['cartesian', 'limit'].includes(exprObjCheck.type)) {
        resultEl.style.display = 'none';
        resultEl.textContent = '';
        return;
    }
    if (!exprStr || !exprStr.trim()) {
        resultEl.style.display = 'none';
        resultEl.textContent = '';
        return;
    }

    var s = exprStr.trim();

    // ── Special forms: evaluate BEFORE free-variable check ──

    // int(expr, a, b) → definite integral (bounds can be expressions like pi, 2*pi, e)
    var intMatch = s.match(/^\s*int\s*\(\s*(.+?)\s*,\s*(.+?)\s*,\s*(.+?)\s*\)\s*$/i);
    if (intMatch) {
        var intA = _parseBound(intMatch[2]);
        var intB = _parseBound(intMatch[3]);
        if (!isNaN(intA) && !isNaN(intB)) {
            var area = _numericIntegrate(intMatch[1], intA, intB);
            if (area !== null && isFinite(area)) {
                resultEl.textContent = '∫ ≈ ' + parseFloat(area.toPrecision(10));
                resultEl.style.display = '';
            } else {
                resultEl.style.display = 'none';
            }
        } else {
            resultEl.style.display = 'none';
        }
        return;
    }

    // sum(var, start, end, body) — evaluate when body has no x
    var sumMatch = s.match(/^\s*sum\s*\(\s*([a-zA-Z])\s*,\s*(.+?)\s*,\s*(.+?)\s*,\s*(.+)\s*\)\s*$/i);
    if (sumMatch) {
        var sumVar = sumMatch[1];
        var bodyHasX = /(?<![a-zA-Z])x(?![a-zA-Z])/.test(sumMatch[4]);
        if (!bodyHasX) {
            try {
                var start = Math.round(math.evaluate(sumMatch[2]));
                var end = Math.round(math.evaluate(sumMatch[3]));
                if (end - start <= 100000) {
                    var total = _numericSum(sumVar, start, end, sumMatch[4]);
                    if (total !== null && isFinite(total)) {
                        _showNumericResult(resultEl, total);
                        return;
                    }
                }
            } catch (_) {}
        }
        resultEl.style.display = 'none';
        return;
    }

    // prod(var, start, end, body) — evaluate when body has no x
    var prodMatch = s.match(/^\s*prod\s*\(\s*([a-zA-Z])\s*,\s*(.+?)\s*,\s*(.+?)\s*,\s*(.+)\s*\)\s*$/i);
    if (prodMatch) {
        var prodVar = prodMatch[1];
        var prodBodyHasX = /(?<![a-zA-Z])x(?![a-zA-Z])/.test(prodMatch[4]);
        if (!prodBodyHasX) {
            try {
                var pStart = Math.round(math.evaluate(prodMatch[2]));
                var pEnd = Math.round(math.evaluate(prodMatch[3]));
                if (pEnd - pStart <= 100000) {
                    var pTotal = _numericProd(prodVar, pStart, pEnd, prodMatch[4]);
                    if (pTotal !== null && isFinite(pTotal)) {
                        _showNumericResult(resultEl, pTotal);
                        return;
                    }
                }
            } catch (_) {}
        }
        resultEl.style.display = 'none';
        return;
    }

    // lim(expr, var, value) → limit at a point
    var limMatch = s.match(/^\s*lim\s*\(\s*(.+?)\s*,\s*([a-zA-Z])\s*,\s*(.+?)\s*\)\s*$/i);
    if (limMatch) {
        var limResult = _numericLimit(limMatch[1], limMatch[2], limMatch[3]);
        if (limResult !== null && isFinite(limResult)) {
            resultEl.textContent = 'lim ≈ ' + parseFloat(limResult.toPrecision(10));
            resultEl.style.display = '';
        } else {
            resultEl.style.display = 'none';
        }
        return;
    }

    // deriv(expr, x0) or d/dx(expr) at x=x0 → derivative at a point
    var derivMatch = s.match(/^\s*deriv\s*\(\s*(.+?)\s*,\s*(.+?)\s*\)\s*$/i);
    if (derivMatch) {
        var x0 = _parseBound(derivMatch[2]);
        if (!isNaN(x0)) {
            var dResult = _numericDeriv(derivMatch[1], x0);
            if (dResult !== null && isFinite(dResult)) {
                resultEl.textContent = "f'(" + x0 + ') ≈ ' + parseFloat(dResult.toPrecision(10));
                resultEl.style.display = '';
            } else {
                resultEl.style.display = 'none';
            }
        } else {
            resultEl.style.display = 'none';
        }
        return;
    }

    // nCr(n, r) → combinations
    var nCrMatch = s.match(/^\s*nCr\s*\(\s*(\d+)\s*,\s*(\d+)\s*\)\s*$/i);
    if (nCrMatch) {
        try {
            var nVal = parseInt(nCrMatch[1]), rVal = parseInt(nCrMatch[2]);
            var comb = math.evaluate('combinations(' + nVal + ',' + rVal + ')');
            _showNumericResult(resultEl, comb);
        } catch (_) { resultEl.style.display = 'none'; }
        return;
    }

    // nPr(n, r) → permutations
    var nPrMatch = s.match(/^\s*nPr\s*\(\s*(\d+)\s*,\s*(\d+)\s*\)\s*$/i);
    if (nPrMatch) {
        try {
            var nP = parseInt(nPrMatch[1]), rP = parseInt(nPrMatch[2]);
            var perm = math.evaluate('permutations(' + nP + ',' + rP + ')');
            _showNumericResult(resultEl, perm);
        } catch (_) { resultEl.style.display = 'none'; }
        return;
    }

    // ── Standard numeric evaluation (no special forms) ──

    // Check for free variables (x, y, t, theta, r)
    var freeVars = ['x', 'y', 't', 'theta', 'r'];
    var stripPattern = '\\b(sin|cos|tan|log|ln|exp|sqrt|abs|floor|ceil|sign|round|min|max|asin|acos|atan|sinh|cosh|tanh|factorial|nthRoot|cbrt|sec|csc|cot|arcsin|arccos|arctan|pi|e';
    if (engine.globalScope) {
        Object.keys(engine.globalScope).forEach(function(v) { stripPattern += '|' + v; });
    }
    stripPattern += ')\\b';
    var normalized = exprStr.replace(new RegExp(stripPattern, 'gi'), '');
    var hasFreeVar = freeVars.some(function(v) {
        return new RegExp('\\b' + v + '\\b', 'i').test(normalized);
    });
    if (hasFreeVar) {
        resultEl.style.display = 'none';
        resultEl.textContent = '';
        return;
    }

    // Skip equations/inequalities
    if (/[<>=!]/.test(exprStr)) {
        resultEl.style.display = 'none';
        resultEl.textContent = '';
        return;
    }

    try {
        // Substitute global scope variables, then slider parameters
        var evalExpr = exprStr;
        if (engine.globalScope) {
            Object.keys(engine.globalScope).forEach(function(varName) {
                if (typeof engine.globalScope[varName] === 'number') {
                    evalExpr = evalExpr.replace(new RegExp('\\b' + varName + '\\b', 'g'), '(' + engine.globalScope[varName] + ')');
                }
            });
        }
        var exprObj = engine.expressions.find(function(e) { return e.id === id; });
        if (exprObj && exprObj.parameters) {
            Object.keys(exprObj.parameters).forEach(function(param) {
                evalExpr = evalExpr.replace(new RegExp('\\b' + param + '\\b', 'g'), String(exprObj.parameters[param]));
            });
        }
        var result = math.evaluate(evalExpr);
        if (!_showNumericResult(resultEl, result)) {
            resultEl.style.display = 'none';
        }
    } catch (_) {
        resultEl.style.display = 'none';
        resultEl.textContent = '';
    }
}

/**
 * Create UI element for an expression (appends to main expressions-list)
 */
function createExpressionElement(expr) {
    const container = document.getElementById('expressions-list');

    const div = document.createElement('div');
    div.className = 'expression-item';
    div.id = `expr-item-${expr.id}`;

    container.appendChild(div);
    expressionElements[expr.id] = div;
    _populateExpressionDiv(div, expr);
}

/**
 * Populate an expression div with all UI controls (shared by main list and folders)
 * Three-zone layout: color rail | body (input + meta) | calc drawer
 */
function _populateExpressionDiv(div, expr) {
    div.setAttribute('role', 'group');
    div.setAttribute('aria-label', `Expression ${expr.id}`);

    const exprType = expr.type || 'cartesian';
    const isCartesian = (exprType === 'cartesian');
    const badgeLabel = _getTypeBadgeLabel(exprType);

    div.innerHTML = `
        <div class="gc-expr-left-rail">
            <span class="gc-drag-handle" title="Drag to reorder"><i class="fas fa-grip-vertical"></i></span>
            <button class="gc-color-swatch" style="background:${expr.color}" title="Change color" aria-label="Expression color"
                    onclick="document.getElementById('color-${expr.id}').click()">
                <input type="color" id="color-${expr.id}" value="${expr.color}"
                       onchange="updateExpressionColor(${expr.id})" aria-label="Line color">
            </button>
        </div>
        <div class="gc-expr-body">
            <div class="gc-expr-top-row">
                <div class="gc-expr-input-wrap" id="input-container-${expr.id}"></div>
                <button class="gc-delete-btn" onclick="deleteExpression(${expr.id})" aria-label="Delete expression" title="Delete"><i class="fas fa-times"></i></button>
            </div>
            <div class="gc-numeric-result" id="numeric-result-${expr.id}" style="display:none;"></div>
            <div class="gc-expr-meta">
                <span class="gc-type-badge" id="type-badge-${expr.id}" title="Change type">${badgeLabel}
                    <select class="gc-type-select-hidden plot-type-select" id="type-${expr.id}" onchange="updateExpressionType(${expr.id})" aria-label="Expression type">
                    <option value="cartesian">y = f(x)</option>
                    <option value="equation">Equation</option>
                    <option value="parametric">Parametric</option>
                    <option value="polar">Polar</option>
                    <option value="inequality">Inequality</option>
                    <option value="limit">Limit</option>
                    <option value="piecewise">Piecewise</option>
                    <option value="implicit">Implicit</option>
                    <option value="surface">3D Surface</option>
                    <option value="point">Point(s)</option>
                    <option value="table">Table</option>
                    <option value="statistics">Regression</option>
                    <option value="distribution">Distribution</option>
                    <option value="vector">Vector(s)</option>
                    <option value="vectorfield">Vector Field</option>
                    <option value="variable">Variable (a=3)</option>
                    <option value="list">List [1,2,3]</option>
                </select></span>
                ${isCartesian ? `<button class="gc-calc-toggle-btn" onclick="toggleCalcDrawer(${expr.id})" aria-expanded="false" title="Calculus options"><i class="fas fa-sliders"></i> Calc</button>` : ''}
                <button class="gc-latex-copy-btn" onclick="copyAsLaTeX(${expr.id})" title="Copy as LaTeX">LaTeX</button>
            </div>
            <div id="sliders-container-${expr.id}"></div>
            <div id="expr-error-${expr.id}" class="gc-expr-error" style="display:none;"></div>
        </div>
        <div class="gc-calc-drawer" id="calc-drawer-${expr.id}">
            <span id="calculus-toggles-${expr.id}" class="gc-calculus-toggles">
                <div class="gc-calc-drawer-row">
                    <label class="gc-toggle-label"><input class="form-check-input" type="checkbox" id="show-derivative-${expr.id}" onchange="toggleDerivative(${expr.id})"> f'(x)</label>
                    <label class="gc-toggle-label"><input class="form-check-input" type="checkbox" id="show-second-derivative-${expr.id}" onchange="toggleSecondDerivative(${expr.id})"> f''(x)</label>
                    <label class="gc-toggle-label"><input class="form-check-input" type="checkbox" id="show-critical-points-${expr.id}" onchange="toggleCriticalPoints(${expr.id})"> Min/Max</label>
                    <label class="gc-toggle-label"><input class="form-check-input" type="checkbox" id="show-inflection-points-${expr.id}" onchange="toggleInflectionPoints(${expr.id})"> Inflect</label>
                    <label class="gc-toggle-label"><input class="form-check-input" type="checkbox" id="show-roots-${expr.id}" onchange="toggleRoots(${expr.id})"> Zeros</label>
                    <label class="gc-toggle-label"><input class="form-check-input" type="checkbox" id="show-vasym-${expr.id}" onchange="toggleVerticalAsymptotes(${expr.id})"> V.Asym</label>
                </div>
                <div class="gc-calc-drawer-row">
                    <label class="gc-toggle-label"><input class="form-check-input" type="checkbox" id="show-integration-${expr.id}" onchange="toggleIntegration(${expr.id})"> ∫</label>
                    <label class="gc-toggle-label"><input class="form-check-input" type="checkbox" id="show-antiderivative-${expr.id}" onchange="toggleAntiderivative(${expr.id})"> F(x)</label>
                    <label class="gc-toggle-label"><input class="form-check-input" type="checkbox" id="show-table-${expr.id}" onchange="toggleTableForExpr(${expr.id})"> Table</label>
                    <label class="gc-toggle-label"><input class="form-check-input" type="checkbox" id="show-tangent-${expr.id}" onchange="toggleTangentLine(${expr.id})"> Tangent</label>
                </div>
            </span>
            <div id="integration-controls-${expr.id}" style="display: none;" class="mt-1">
                <div class="d-flex gap-2 align-items-center flex-wrap">
                    <small class="text-muted">∫ from</small>
                    <input type="number" class="form-control form-control-sm" id="integration-a-${expr.id}" placeholder="a" value="-2" step="0.5" style="width:65px;" oninput="updateIntegrationBounds(${expr.id})">
                    <small class="text-muted">to</small>
                    <input type="number" class="form-control form-control-sm" id="integration-b-${expr.id}" placeholder="b" value="2" step="0.5" style="width:65px;" oninput="updateIntegrationBounds(${expr.id})">
                </div>
                <div class="d-flex gap-2 align-items-center flex-wrap mt-1">
                    <small class="text-muted">Riemann</small>
                    <select class="form-select form-select-sm" id="riemann-method-${expr.id}" style="width:auto;" onchange="updateRiemannMethod(${expr.id})">
                        <option value="none">None</option>
                        <option value="left">Left</option>
                        <option value="midpoint">Midpoint</option>
                        <option value="right">Right</option>
                        <option value="trapezoidal">Trapezoidal</option>
                    </select>
                    <small class="text-muted">n=</small>
                    <input type="number" class="form-control form-control-sm" id="riemann-n-${expr.id}" value="10" min="1" max="500" step="1" style="width:60px;" oninput="updateRiemannN(${expr.id})">
                </div>
            </div>
            <div id="tangent-controls-${expr.id}"></div>
        </div>
    `;

    createInputForType(expr.id, exprType);

    // Hide calculus toggles for non-cartesian types
    if (!isCartesian) {
        const calcToggles = document.getElementById(`calculus-toggles-${expr.id}`);
        if (calcToggles) calcToggles.style.display = 'none';
    }

    // Set the type select to match
    const typeSel = document.getElementById(`type-${expr.id}`);
    if (typeSel) typeSel.value = exprType;

    // Init drag-and-drop reorder
    _initDragHandlers(div, expr.id);

    // Initial numeric evaluation
    if (expr.expression) _evaluateNumeric(expr.id, expr.expression);
}

/**
 * Create input field based on type
 */
function createInputForType(id, type) {
    const container = document.getElementById(`input-container-${id}`);

    // Get current expression value if it exists
    const expr = engine.expressions.find(e => e.id === id);
    const currentValue = expr && expr.expression ? expr.expression : '';

    // Cleanup old MathQuill field if switching away
    if (_mqFields[id]) {
        delete _mqFields[id];
    }

    container.innerHTML = '';

    // Determine input mode: use MathQuill for supported types when MQ is loaded
    const useMQ = isMathQuillReady() && _mqSupportedTypes.includes(type) && _mqInputMode[id] !== 'text';

    switch (type) {
        case 'cartesian':
            if (useMQ) {
                container.innerHTML = `
                    <div class="gc-mq-wrapper">
                        <div class="gc-mq-field" id="mq-field-${id}"></div>
                        <button class="gc-input-mode-toggle" onclick="toggleInputMode(${id})" title="Switch to plain text input">abc</button>
                    </div>
                    <div class="gc-sample-chips gc-on-focus">
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSampleMQ(${id}, 'sin(x)', '\\\\sin\\\\left(x\\\\right)')">sin</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSampleMQ(${id}, 'cos(x)', '\\\\cos\\\\left(x\\\\right)')">cos</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSampleMQ(${id}, 'x^2', 'x^2')">x²</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSampleMQ(${id}, 'x^3 - 3*x^2 + 2*x', 'x^3-3x^2+2x')">cubic</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSampleMQ(${id}, 'exp(x)', 'e^x')">eˣ</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSampleMQ(${id}, 'log(x)', '\\\\ln\\\\left(x\\\\right)')">ln</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSampleMQ(${id}, 'sqrt(x)', '\\\\sqrt{x}')">√x</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSampleMQ(${id}, '1/(1+exp(-x))', '\\\\frac{1}{1+e^{-x}}')">sigmoid</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="toggleInputMode(${id}); loadSample(${id}, 'sum(n, 1, 10, x^n/factorial(n))')">Σ</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="toggleInputMode(${id}); loadSample(${id}, 'fourier(x, 5)')">fourier</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="toggleInputMode(${id}); loadSample(${id}, 'int(x^2, 0, 1)')">∫</button>
                    </div>
                `;
                _initMathQuillField(id);
            } else {
                container.innerHTML = `
                    <div class="gc-mq-wrapper">
                        <input type="text" class="expression-input" id="expr-${id}"
                               placeholder="Type expression: x^2, sin(x), 2x+3y=8 ..." value="${escapeHtml(currentValue)}"
                               oninput="updateExpressionValue(${id})"
                               onchange="updateExpressionValue(${id})">
                        ${isMathQuillReady() && _mqSupportedTypes.includes(type) ? `<button class="gc-input-mode-toggle" onclick="toggleInputMode(${id})" title="Switch to rich math input">f(x)</button>` : ''}
                    </div>
                    <div class="math-preview" id="math-preview-${id}"></div>
                    <div class="gc-sample-chips gc-on-focus">
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'sin(x)')">sin</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'cos(x)')">cos</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'x^2')">x²</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'x^3 - 3*x^2 + 2*x')">cubic</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'exp(x)')">eˣ</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'log(x)')">ln</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'sqrt(x)')">√x</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, '1/(1+exp(-x))')">sigmoid</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'sum(n, 1, 10, x^n/factorial(n))')">Σ</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'fourier(x, 5)')">fourier</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'int(x^2, 0, 1)')">∫</button>
                    </div>
                `;
            }
            break;

        case 'equation':
            if (useMQ) {
                container.innerHTML = `
                    <div class="gc-mq-wrapper">
                        <div class="gc-mq-field" id="mq-field-${id}"></div>
                        <button class="gc-input-mode-toggle" onclick="toggleInputMode(${id})" title="Switch to plain text input">abc</button>
                    </div>
                    <small class="text-muted">Any equation — solved symbolically</small>
                    <div class="gc-sample-chips gc-on-focus">
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSampleMQ(${id}, '2x + 3y = 8', '2x+3y=8')">2x+3y=8</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSampleMQ(${id}, 'x^2 + y^2 = 25', 'x^2+y^2=25')">Circle</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSampleMQ(${id}, 'x^2/4 + y^2/9 = 1', '\\\\frac{x^2}{4}+\\\\frac{y^2}{9}=1')">Ellipse</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSampleMQ(${id}, 'x^2 - y^2 = 1', 'x^2-y^2=1')">Hyperbola</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSampleMQ(${id}, 'x*y = 4', 'xy=4')">xy=4</button>
                    </div>
                `;
                _initMathQuillField(id);
            } else {
                container.innerHTML = `
                    <div class="gc-mq-wrapper">
                        <input type="text" class="expression-input" id="expr-${id}"
                               placeholder="e.g., 2x + 3y = 8 or x^2 + y^2 = 25" value="${escapeHtml(currentValue)}"
                               oninput="updateExpressionValue(${id})"
                               onchange="updateExpressionValue(${id})">
                        ${isMathQuillReady() ? `<button class="gc-input-mode-toggle" onclick="toggleInputMode(${id})" title="Switch to rich math input">f(x)</button>` : ''}
                    </div>
                    <small class="text-muted">Any equation — solved symbolically</small>
                    <div class="gc-sample-chips gc-on-focus">
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, '2x + 3y = 8')">2x+3y=8</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'x^2 + y^2 = 25')">Circle</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'x^2/4 + y^2/9 = 1')">Ellipse</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'x^2 - y^2 = 1')">Hyperbola</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'x*y = 4')">xy=4</button>
                    </div>
                `;
            }
            break;

        case 'limit':
            if (useMQ) {
                container.innerHTML = `
                    <div class="gc-mq-wrapper">
                        <div class="gc-mq-field" id="mq-field-${id}"></div>
                        <button class="gc-input-mode-toggle" onclick="toggleInputMode(${id})" title="Switch to plain text input">abc</button>
                    </div>
                    <div class="d-flex gap-2 mt-1 align-items-center" style="font-size:0.8rem;">
                        <span style="color:var(--gc-tool);font-weight:600;">lim</span>
                        <span class="text-muted">x →</span>
                        <input type="text" class="form-control form-control-sm" id="limit-val-${id}"
                               placeholder="0" value="0" style="width: 60px; text-align:center;"
                               oninput="updateLimitExpression(${id})"
                               onchange="updateLimitExpression(${id})">
                        <span style="color:var(--gc-tool);font-weight:600;">=</span>
                        <span id="limit-result-${id}" style="color:var(--gc-tool);font-weight:700;">?</span>
                    </div>
                    <div class="gc-sample-chips gc-on-focus">
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadLimitSample(${id}, 'sin(x)/x', '0')">sin(x)/x</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadLimitSample(${id}, '(exp(x)-1)/x', '0')">(eˣ-1)/x</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadLimitSample(${id}, '(1+1/x)^x', 'Infinity')">(1+1/x)ˣ→∞</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadLimitSample(${id}, '(x^2-1)/(x-1)', '1')">(x²-1)/(x-1)</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadLimitSample(${id}, 'tan(x)/x', '0')">tan(x)/x</button>
                    </div>
                `;
                _initMathQuillField(id);
            } else {
                container.innerHTML = `
                    <div class="gc-mq-wrapper">
                        <input type="text" class="expression-input" id="expr-${id}"
                               placeholder="e.g., sin(x)/x" value="${escapeHtml(currentValue)}"
                               oninput="updateLimitExpression(${id})"
                               onchange="updateLimitExpression(${id})">
                        ${isMathQuillReady() ? `<button class="gc-input-mode-toggle" onclick="toggleInputMode(${id})" title="Switch to rich math input">f(x)</button>` : ''}
                    </div>
                    <div class="d-flex gap-2 mt-1 align-items-center" style="font-size:0.8rem;">
                        <span style="color:var(--gc-tool);font-weight:600;">lim</span>
                        <span class="text-muted">x →</span>
                        <input type="text" class="form-control form-control-sm" id="limit-val-${id}"
                               placeholder="0" value="0" style="width: 60px; text-align:center;"
                               oninput="updateLimitExpression(${id})"
                               onchange="updateLimitExpression(${id})">
                        <span style="color:var(--gc-tool);font-weight:600;">=</span>
                        <span id="limit-result-${id}" style="color:var(--gc-tool);font-weight:700;">?</span>
                    </div>
                    <div class="gc-sample-chips gc-on-focus">
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadLimitSample(${id}, 'sin(x)/x', '0')">sin(x)/x</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadLimitSample(${id}, '(exp(x)-1)/x', '0')">(eˣ-1)/x</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadLimitSample(${id}, '(1+1/x)^x', 'Infinity')">(1+1/x)ˣ→∞</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadLimitSample(${id}, '(x^2-1)/(x-1)', '1')">(x²-1)/(x-1)</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadLimitSample(${id}, 'tan(x)/x', '0')">tan(x)/x</button>
                    </div>
                `;
            }
            break;

        case 'parametric':
            if (useMQ) {
                container.innerHTML = `
                    <div class="gc-mq-wrapper">
                        <div class="gc-mq-field" id="mq-field-${id}"></div>
                        <button class="gc-input-mode-toggle" onclick="toggleInputMode(${id})" title="Switch to plain text input">abc</button>
                    </div>
                    <small class="text-muted">Format: x(t), y(t)</small>
                    <div class="d-flex align-items-center gap-2 mt-2">
                        <small class="text-muted">t:</small>
                        <input type="number" class="form-control form-control-sm" id="tmin-${id}" value="0" step="0.1"
                               style="width:70px" onchange="updateParamRange(${id})">
                        <small class="text-muted">to</small>
                        <input type="number" class="form-control form-control-sm" id="tmax-${id}" value="${(2*Math.PI).toFixed(4)}" step="0.1"
                               style="width:70px" onchange="updateParamRange(${id})">
                    </div>
                    <div class="gc-sample-chips gc-on-focus">
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'cos(t), sin(t)')">Circle</button>
                        <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadSample(${id}, 't*cos(t), t*sin(t)')">Spiral</button>
                        <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadParamSample(${id}, 't, t^2', -5, 5)">Parabola</button>
                    </div>
                `;
                _initMathQuillField(id);
            } else {
                container.innerHTML = `
                    <div class="gc-mq-wrapper">
                        <input type="text" class="expression-input" id="expr-${id}"
                               placeholder="e.g., cos(t), sin(t)" value="${escapeHtml(currentValue)}"
                               oninput="updateExpressionValue(${id})"
                               onchange="updateExpressionValue(${id})">
                        ${isMathQuillReady() ? `<button class="gc-input-mode-toggle" onclick="toggleInputMode(${id})" title="Switch to rich math input">f(x)</button>` : ''}
                    </div>
                    <small class="text-muted">Format: x(t), y(t)</small>
                    <div class="d-flex align-items-center gap-2 mt-2">
                        <small class="text-muted">t:</small>
                        <input type="number" class="form-control form-control-sm" id="tmin-${id}" value="0" step="0.1"
                               style="width:70px" onchange="updateParamRange(${id})">
                        <small class="text-muted">to</small>
                        <input type="number" class="form-control form-control-sm" id="tmax-${id}" value="${(2*Math.PI).toFixed(4)}" step="0.1"
                               style="width:70px" onchange="updateParamRange(${id})">
                    </div>
                    <div class="mt-2">
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'cos(t), sin(t)')">Circle</button>
                        <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadSample(${id}, 't*cos(t), t*sin(t)')">Spiral</button>
                        <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadParamSample(${id}, 't, t^2', -5, 5)">Parabola</button>
                    </div>
                `;
            }
            break;

        case 'point':
            container.innerHTML = `
                <input type="text" class="expression-input" id="expr-${id}"
                       placeholder="e.g., (2, 3) or [(1,2),(3,4)]" value="${escapeHtml(currentValue)}"
                       oninput="updateExpressionValue(${id})"
                       onchange="updateExpressionValue(${id})">
                <small class="text-muted">Plot points: (x,y) or [(x₁,y₁),(x₂,y₂),...]</small>
                <div class="gc-sample-chips gc-on-focus">
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, '(0, 0)')">(0,0)</button>
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, '(1,1), (2,4), (3,9)')">Points</button>
                </div>
            `;
            break;

        case 'vector':
            container.innerHTML = `
                <input type="text" class="expression-input" id="expr-${id}"
                       placeholder="e.g., &lt;3, 4&gt; or &lt;2,3&gt; @ (1,1)" value="${escapeHtml(currentValue)}"
                       oninput="updateExpressionValue(${id})"
                       onchange="updateExpressionValue(${id})">
                <small class="text-muted">Vectors: &lt;dx,dy&gt; or &lt;dx,dy&gt; @ (ox,oy)</small>
                <div class="gc-sample-chips gc-on-focus">
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, '&lt;3, 4&gt;')">⟨3,4⟩</button>
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, '&lt;2,3&gt; @ (1,1)')">with origin</button>
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, '&lt;1,0&gt;, &lt;0,1&gt;, &lt;1,1&gt;')">basis</button>
                </div>
            `;
            break;

        case 'vectorfield':
            container.innerHTML = `
                <input type="text" class="expression-input" id="expr-${id}"
                       placeholder="e.g., &lt;-y, x&gt; or F(x,y) = &lt;x^2, -x*y&gt;" value="${escapeHtml(currentValue)}"
                       oninput="updateExpressionValue(${id})"
                       onchange="updateExpressionValue(${id})">
                <small class="text-muted">Vector field: &lt;P(x,y), Q(x,y)&gt;</small>
                <div class="gc-sample-chips gc-on-focus">
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, '&lt;-y, x&gt;')">rotation</button>
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, '&lt;x, y&gt;')">radial</button>
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, '&lt;-y/(x^2+y^2), x/(x^2+y^2)&gt;')">vortex</button>
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, '&lt;sin(y), cos(x)&gt;')">wave</button>
                </div>
            `;
            break;

        case 'polar':
            if (useMQ) {
                container.innerHTML = `
                    <div class="gc-mq-wrapper">
                        <div class="gc-mq-field" id="mq-field-${id}"></div>
                        <button class="gc-input-mode-toggle" onclick="toggleInputMode(${id})" title="Switch to plain text input">abc</button>
                    </div>
                    <small class="text-muted">Use theta or θ</small>
                    <div class="d-flex align-items-center gap-2 mt-2">
                        <small class="text-muted">θ:</small>
                        <input type="number" class="form-control form-control-sm" id="thetamin-${id}" value="0" step="0.1"
                               style="width:70px" onchange="updatePolarRange(${id})">
                        <small class="text-muted">to</small>
                        <input type="number" class="form-control form-control-sm" id="thetamax-${id}" value="${(2*Math.PI).toFixed(4)}" step="0.1"
                               style="width:70px" onchange="updatePolarRange(${id})">
                    </div>
                    <div class="mt-2">
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSampleMQ(${id}, '2 + 2*cos(theta)', '2+2\\\\cos\\\\left(\\\\theta\\\\right)')">Heart</button>
                        <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadSampleMQ(${id}, '1 + cos(theta)', '1+\\\\cos\\\\left(\\\\theta\\\\right)')">Cardioid</button>
                        <button class="btn btn-sm btn-outline-secondary ms-1" onclick="toggleInputMode(${id}); loadPolarSample(${id}, 'theta', 0, 25.13)">Spiral 4π</button>
                    </div>
                `;
                _initMathQuillField(id);
            } else {
                container.innerHTML = `
                    <div class="gc-mq-wrapper">
                        <input type="text" class="expression-input" id="expr-${id}"
                               placeholder="e.g., 2 + 2*cos(theta)" value="${escapeHtml(currentValue)}"
                               oninput="updateExpressionValue(${id})"
                               onchange="updateExpressionValue(${id})">
                        ${isMathQuillReady() ? `<button class="gc-input-mode-toggle" onclick="toggleInputMode(${id})" title="Switch to rich math input">f(x)</button>` : ''}
                    </div>
                    <small class="text-muted">Use theta or θ</small>
                    <div class="d-flex align-items-center gap-2 mt-2">
                        <small class="text-muted">θ:</small>
                        <input type="number" class="form-control form-control-sm" id="thetamin-${id}" value="0" step="0.1"
                               style="width:70px" onchange="updatePolarRange(${id})">
                        <small class="text-muted">to</small>
                        <input type="number" class="form-control form-control-sm" id="thetamax-${id}" value="${(2*Math.PI).toFixed(4)}" step="0.1"
                               style="width:70px" onchange="updatePolarRange(${id})">
                    </div>
                    <div class="mt-2">
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, '2 + 2*cos(theta)')">Heart</button>
                        <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadSample(${id}, '1 + cos(theta)')">Cardioid</button>
                        <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadPolarSample(${id}, 'theta', 0, 25.13)">Spiral 4π</button>
                    </div>
                `;
            }
            break;

        case 'implicit':
            if (useMQ) {
                container.innerHTML = `
                    <div class="gc-mq-wrapper">
                        <div class="gc-mq-field" id="mq-field-${id}"></div>
                        <button class="gc-input-mode-toggle" onclick="toggleInputMode(${id})" title="Switch to plain text input">abc</button>
                    </div>
                    <small class="text-muted">Implicit equation in x and y</small>
                    <div class="mt-2">
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSampleMQ(${id}, 'x^2 + y^2 = 25', 'x^2+y^2=25')">Circle</button>
                        <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadSampleMQ(${id}, 'x^2/16 + y^2/9 = 1', '\\\\frac{x^2}{16}+\\\\frac{y^2}{9}=1')">Ellipse</button>
                        <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadSampleMQ(${id}, '(x^2 + y^2 - 1)^3 = x^2*y^3', '\\\\left(x^2+y^2-1\\\\right)^3=x^2y^3')">Heart</button>
                        <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadSampleMQ(${id}, 'x^2 - y^2 = 1', 'x^2-y^2=1')">Hyperbola</button>
                    </div>
                `;
                _initMathQuillField(id);
            } else {
                container.innerHTML = `
                    <div class="gc-mq-wrapper">
                        <input type="text" class="expression-input" id="expr-${id}"
                               placeholder="e.g., x^2 + y^2 = 25" value="${escapeHtml(currentValue)}"
                               oninput="updateExpressionValue(${id})"
                               onchange="updateExpressionValue(${id})">
                        ${isMathQuillReady() ? `<button class="gc-input-mode-toggle" onclick="toggleInputMode(${id})" title="Switch to rich math input">f(x)</button>` : ''}
                    </div>
                    <small class="text-muted">Implicit equation in x and y</small>
                    <div class="mt-2">
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'x^2 + y^2 = 25')">Circle</button>
                        <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadSample(${id}, 'x^2/16 + y^2/9 = 1')">Ellipse</button>
                        <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadSample(${id}, '(x^2 + y^2 - 1)^3 = x^2*y^3')">Heart</button>
                        <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadSample(${id}, 'x^2 - y^2 = 1')">Hyperbola</button>
                    </div>
                `;
            }
            break;

        case 'surface':
            if (useMQ) {
                container.innerHTML = `
                    <div class="gc-mq-wrapper">
                        <div class="gc-mq-field" id="mq-field-${id}"></div>
                        <button class="gc-input-mode-toggle" onclick="toggleInputMode(${id})" title="Switch to plain text input">abc</button>
                    </div>
                    <small class="text-muted">z = f(x, y) — 3D surface plot</small>
                    <div class="gc-sample-chips gc-on-focus">
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'sin(sqrt(x^2 + y^2))')">Ripple</button>
                        <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadSample(${id}, 'x^2 - y^2')">Saddle</button>
                        <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadSample(${id}, 'cos(x) * sin(y)')">Waves</button>
                        <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadSample(${id}, 'exp(-(x^2 + y^2))')">Gaussian</button>
                    </div>
                `;
                _initMathQuillField(id);
            } else {
                container.innerHTML = `
                    <div class="gc-mq-wrapper">
                        <input type="text" class="expression-input" id="expr-${id}"
                               placeholder="e.g., sin(sqrt(x^2 + y^2))" value="${escapeHtml(currentValue)}"
                               oninput="updateExpressionValue(${id})"
                               onchange="updateExpressionValue(${id})">
                        ${isMathQuillReady() ? `<button class="gc-input-mode-toggle" onclick="toggleInputMode(${id})" title="Switch to rich math input">f(x)</button>` : ''}
                    </div>
                    <small class="text-muted">z = f(x, y) — 3D surface plot</small>
                    <div class="mt-2">
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'sin(sqrt(x^2 + y^2))')">Ripple</button>
                        <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadSample(${id}, 'x^2 - y^2')">Saddle</button>
                        <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadSample(${id}, 'cos(x) * sin(y)')">Waves</button>
                        <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadSample(${id}, 'exp(-(x^2 + y^2))')">Gaussian</button>
                    </div>
                `;
            }
            break;

        case 'piecewise':
            // Check if using inline brace syntax
            if (currentValue && /\{[^}]*:[^}]+\}/.test(currentValue)) {
                container.innerHTML = `
                    <input type="text" class="expression-input" id="expr-${id}"
                           placeholder="e.g., {x<0: -x, x>=0: x}" value="${escapeHtml(currentValue)}"
                           oninput="updateExpressionValue(${id})"
                           onchange="updateExpressionValue(${id})">
                    <small class="text-muted">Inline piecewise: {condition: expr, condition: expr}</small>
                    <div class="gc-sample-chips gc-on-focus">
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, '{x<0: -x, x>=0: x}')">|x|</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, '{x<0: 0, x>=0: 1}')">step</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, '{x<-1: -1, x>=-1: x, x>1: 1}')">clamp</button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="_switchToPiecewiseUI(${id})">piece UI</button>
                    </div>
                `;
                // Parse the brace syntax
                _parsePiecewiseBraceSyntax(id, currentValue);
            } else {
                container.innerHTML = `
                    <div id="piecewise-pieces-${id}">
                        <div class="mb-2 p-2" style="background: #f8f9fa; border-radius: 4px;">
                            <small class="text-muted"><strong>Piece 1:</strong></small>
                            <input type="text" class="form-control form-control-sm mb-1" id="piece-expr-${id}-0"
                                   placeholder="Expression (e.g., x^2)" value="x^2" oninput="updatePiecewise(${id})">
                            <input type="text" class="form-control form-control-sm" id="piece-cond-${id}-0"
                                   placeholder="Condition (e.g., x < 0)" value="x < 0" oninput="updatePiecewise(${id})">
                        </div>
                        <div class="mb-2 p-2" style="background: #f8f9fa; border-radius: 4px;">
                            <small class="text-muted"><strong>Piece 2:</strong></small>
                            <input type="text" class="form-control form-control-sm mb-1" id="piece-expr-${id}-1"
                                   placeholder="Expression (e.g., sin(x))" value="sin(x)" oninput="updatePiecewise(${id})">
                            <input type="text" class="form-control form-control-sm" id="piece-cond-${id}-1"
                                   placeholder="Condition (e.g., x >= 0)" value="x >= 0" oninput="updatePiecewise(${id})">
                        </div>
                    </div>
                    <button class="btn btn-sm btn-outline-primary mt-1" onclick="addPiecewisePiece(${id})">
                        <i class="fas fa-plus"></i> Add Piece
                    </button>
                    <div class="mt-2">
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadPiecewiseSample(${id}, 'abs')">|x|</button>
                        <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadPiecewiseSample(${id}, 'step')">Step</button>
                        <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadPiecewiseSample(${id}, 'sawtooth')">Sawtooth</button>
                        <button class="btn btn-sm btn-outline-secondary ms-1" onclick="_switchToBraceSyntax(${id})">{...}</button>
                    </div>
                `;
                // Initialize piecewise data
                updatePiecewise(id);
            }
            break;

        case 'inequality':
            if (useMQ) {
                container.innerHTML = `
                    <div class="gc-mq-wrapper">
                        <div class="gc-mq-field" id="mq-field-${id}"></div>
                        <button class="gc-input-mode-toggle" onclick="toggleInputMode(${id})" title="Switch to plain text input">abc</button>
                    </div>
                    <div class="mt-2">
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSampleMQ(${id}, 'y > x^2', 'y>x^2')">Parabola</button>
                        <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadSampleMQ(${id}, 'y < sin(x)', 'y<\\\\sin\\\\left(x\\\\right)')">Sine Wave</button>
                    </div>
                `;
                _initMathQuillField(id);
            } else {
                container.innerHTML = `
                    <div class="gc-mq-wrapper">
                        <input type="text" class="expression-input" id="expr-${id}"
                               placeholder="e.g., y > x^2" value="${escapeHtml(currentValue)}"
                               oninput="updateExpressionValue(${id})"
                               onchange="updateExpressionValue(${id})">
                        ${isMathQuillReady() ? `<button class="gc-input-mode-toggle" onclick="toggleInputMode(${id})" title="Switch to rich math input">f(x)</button>` : ''}
                    </div>
                    <div class="mt-2">
                        <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'y > x^2')">Parabola</button>
                        <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadSample(${id}, 'y < sin(x)')">Sine Wave</button>
                    </div>
                `;
            }
            break;

        case 'table':
            container.innerHTML = `
                <textarea class="table-input form-control" id="expr-${id}" rows="4"
                          placeholder="Enter x,y pairs (one per line):&#10;1, 2&#10;2, 4&#10;3, 9"
                          oninput="updateExpressionValue(${id})"
                          onchange="updateExpressionValue(${id})">${currentValue}</textarea>
                <div class="mt-2">
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadTableSample(${id}, 'random')">Random Data</button>
                    <button class="btn btn-sm btn-outline-secondary ms-1" onclick="loadTableSample(${id}, 'linear')">Linear Data</button>
                </div>
            `;
            break;

        case 'statistics':
            container.innerHTML = `
                <textarea class="table-input form-control" id="expr-${id}" rows="4"
                          placeholder="Enter x,y pairs for regression:&#10;1, 2&#10;2, 4&#10;3, 9"
                          oninput="updateExpressionValue(${id})"
                          onchange="updateExpressionValue(${id})">${currentValue}</textarea>
                <div class="mt-2 d-flex gap-2 align-items-center flex-wrap">
                    <small class="text-muted">Fit:</small>
                    <select class="form-select form-select-sm" id="regression-type-${id}" style="width:auto;" onchange="updateRegressionType(${id})">
                        <option value="auto">Auto (Best R²)</option>
                        <option value="linear">Linear</option>
                        <option value="quadratic">Quadratic</option>
                        <option value="cubic">Cubic</option>
                        <option value="exponential">Exponential</option>
                        <option value="logarithmic">Logarithmic</option>
                        <option value="power">Power</option>
                    </select>
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadTableSample(${id}, 'regression')">Sample</button>
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadTableSample(${id}, 'exponential')">Exp Data</button>
                </div>
                <div id="stats-${id}" class="stats-output" style="display:none;"></div>
            `;
            break;

        case 'distribution':
            container.innerHTML = `
                <select class="form-select form-select-sm mb-2" id="dist-type-${id}" onchange="updateDistributionType(${id})">
                    <option value="normal">Normal (Gaussian)</option>
                    <option value="chi2">Chi-Squared (χ²)</option>
                    <option value="uniform">Uniform</option>
                    <option value="exponential">Exponential</option>
                    <option value="binomial">Binomial</option>
                    <option value="poisson">Poisson</option>
                    <option value="t">Student's t</option>
                    <option value="beta">Beta</option>
                    <option value="gamma">Gamma</option>
                </select>
                <div id="dist-params-${id}"></div>
            `;
            updateDistributionType(id);
            break;

        case 'variable':
            container.innerHTML = `
                <input type="text" class="expression-input" id="expr-${id}"
                       placeholder="e.g., a = 3 (creates global slider)" value="${escapeHtml(currentValue)}"
                       oninput="updateExpressionValue(${id})"
                       onchange="updateExpressionValue(${id})"
                       style="font-weight:600;">
                <small class="text-muted" style="color:var(--gc-tool);">Global variable — usable in all expressions</small>
                <div class="gc-sample-chips gc-on-focus">
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'a = 3')">a = 3</button>
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'k = 1')">k = 1</button>
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'n = 5')">n = 5</button>
                </div>
            `;
            break;

        case 'list':
            container.innerHTML = `
                <input type="text" class="expression-input" id="expr-${id}"
                       placeholder="e.g., [1, 2, 3, 4, 5] or [1...10]" value="${escapeHtml(currentValue)}"
                       oninput="updateExpressionValue(${id})"
                       onchange="updateExpressionValue(${id})">
                <small class="text-muted">List of values. Named: L = [1,2,3]. Range: [1...10]</small>
                <div class="gc-sample-chips gc-on-focus">
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, '[1, 4, 9, 16, 25]')">squares</button>
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, '[1...10]')">1..10</button>
                    <button class="btn btn-sm btn-outline-secondary" onclick="loadSample(${id}, 'L = [2, 3, 5, 7, 11, 13]')">primes</button>
                </div>
            `;
            break;
    }
}

/**
 * Update distribution type and show appropriate parameter inputs
 */
function updateDistributionType(id) {
    const distType = document.getElementById(`dist-type-${id}`).value;
    const paramsContainer = document.getElementById(`dist-params-${id}`);

    let paramsHTML = '';

    switch (distType) {
        case 'normal':
            paramsHTML = `
                <div class="mb-2">
                    <label class="form-label" style="font-size: 12px;">Mean (μ)</label>
                    <input type="number" class="form-control form-control-sm" id="param-mean-${id}" value="0" step="0.1" oninput="updateDistributionParams(${id})" onchange="updateDistributionParams(${id})">
                </div>
                <div class="mb-2">
                    <label class="form-label" style="font-size: 12px;">Std Dev (σ)</label>
                    <input type="number" class="form-control form-control-sm" id="param-stdDev-${id}" value="1" step="0.1" min="0.01" oninput="updateDistributionParams(${id})" onchange="updateDistributionParams(${id})">
                </div>
            `;
            break;

        case 'chi2':
            paramsHTML = `
                <div class="mb-2">
                    <label class="form-label" style="font-size: 12px;">Degrees of Freedom (k)</label>
                    <input type="number" class="form-control form-control-sm" id="param-k-${id}" value="3" step="1" min="1" oninput="updateDistributionParams(${id})" onchange="updateDistributionParams(${id})">
                </div>
            `;
            break;

        case 'uniform':
            paramsHTML = `
                <div class="mb-2">
                    <label class="form-label" style="font-size: 12px;">Min (a)</label>
                    <input type="number" class="form-control form-control-sm" id="param-a-${id}" value="0" step="0.1" oninput="updateDistributionParams(${id})" onchange="updateDistributionParams(${id})">
                </div>
                <div class="mb-2">
                    <label class="form-label" style="font-size: 12px;">Max (b)</label>
                    <input type="number" class="form-control form-control-sm" id="param-b-${id}" value="1" step="0.1" oninput="updateDistributionParams(${id})" onchange="updateDistributionParams(${id})">
                </div>
            `;
            break;

        case 'exponential':
            paramsHTML = `
                <div class="mb-2">
                    <label class="form-label" style="font-size: 12px;">Rate (λ)</label>
                    <input type="number" class="form-control form-control-sm" id="param-lambda-${id}" value="1" step="0.1" min="0.01" oninput="updateDistributionParams(${id})" onchange="updateDistributionParams(${id})">
                </div>
            `;
            break;

        case 'binomial':
            paramsHTML = `
                <div class="mb-2">
                    <label class="form-label" style="font-size: 12px;">Trials (n)</label>
                    <input type="number" class="form-control form-control-sm" id="param-n-${id}" value="10" step="1" min="1" oninput="updateDistributionParams(${id})" onchange="updateDistributionParams(${id})">
                </div>
                <div class="mb-2">
                    <label class="form-label" style="font-size: 12px;">Probability (p)</label>
                    <input type="number" class="form-control form-control-sm" id="param-p-${id}" value="0.5" step="0.01" min="0" max="1" oninput="updateDistributionParams(${id})" onchange="updateDistributionParams(${id})">
                </div>
            `;
            break;

        case 'poisson':
            paramsHTML = `
                <div class="mb-2">
                    <label class="form-label" style="font-size: 12px;">Rate (λ)</label>
                    <input type="number" class="form-control form-control-sm" id="param-lambda-${id}" value="3" step="0.1" min="0.01" oninput="updateDistributionParams(${id})" onchange="updateDistributionParams(${id})">
                </div>
            `;
            break;

        case 't':
            paramsHTML = `
                <div class="mb-2">
                    <label class="form-label" style="font-size: 12px;">Degrees of Freedom (df)</label>
                    <input type="number" class="form-control form-control-sm" id="param-df-${id}" value="5" step="1" min="1" oninput="updateDistributionParams(${id})" onchange="updateDistributionParams(${id})">
                </div>
            `;
            break;

        case 'beta':
            paramsHTML = `
                <div class="mb-2">
                    <label class="form-label" style="font-size: 12px;">Alpha (α)</label>
                    <input type="number" class="form-control form-control-sm" id="param-alpha-${id}" value="2" step="0.1" min="0.01" oninput="updateDistributionParams(${id})" onchange="updateDistributionParams(${id})">
                </div>
                <div class="mb-2">
                    <label class="form-label" style="font-size: 12px;">Beta (β)</label>
                    <input type="number" class="form-control form-control-sm" id="param-beta-${id}" value="2" step="0.1" min="0.01" oninput="updateDistributionParams(${id})" onchange="updateDistributionParams(${id})">
                </div>
            `;
            break;

        case 'gamma':
            paramsHTML = `
                <div class="mb-2">
                    <label class="form-label" style="font-size: 12px;">Shape (k)</label>
                    <input type="number" class="form-control form-control-sm" id="param-shape-${id}" value="2" step="0.1" min="0.01" oninput="updateDistributionParams(${id})" onchange="updateDistributionParams(${id})">
                </div>
                <div class="mb-2">
                    <label class="form-label" style="font-size: 12px;">Scale (θ)</label>
                    <input type="number" class="form-control form-control-sm" id="param-scale-${id}" value="2" step="0.1" min="0.01" oninput="updateDistributionParams(${id})" onchange="updateDistributionParams(${id})">
                </div>
            `;
            break;
    }

    paramsContainer.innerHTML = paramsHTML;
    updateDistributionParams(id);
}

/**
 * Update distribution parameters and refresh graph
 */
function updateDistributionParams(id) {
    const distTypeElement = document.getElementById(`dist-type-${id}`);

    if (!distTypeElement) {
        console.error('Distribution type element not found for id:', id);
        return;
    }

    const distType = distTypeElement.value;
    const params = {};

    switch (distType) {
        case 'normal':
            params.mean = parseFloat(document.getElementById(`param-mean-${id}`).value);
            params.stdDev = parseFloat(document.getElementById(`param-stdDev-${id}`).value);
            break;
        case 'chi2':
            params.k = parseInt(document.getElementById(`param-k-${id}`).value);
            break;
        case 'uniform':
            params.a = parseFloat(document.getElementById(`param-a-${id}`).value);
            params.b = parseFloat(document.getElementById(`param-b-${id}`).value);
            break;
        case 'exponential':
            params.lambda = parseFloat(document.getElementById(`param-lambda-${id}`).value);
            break;
        case 'binomial':
            params.n = parseInt(document.getElementById(`param-n-${id}`).value);
            params.p = parseFloat(document.getElementById(`param-p-${id}`).value);
            break;
        case 'poisson':
            params.lambda = parseFloat(document.getElementById(`param-lambda-${id}`).value);
            break;
        case 't':
            params.df = parseInt(document.getElementById(`param-df-${id}`).value);
            break;
        case 'beta':
            params.alpha = parseFloat(document.getElementById(`param-alpha-${id}`).value);
            params.beta = parseFloat(document.getElementById(`param-beta-${id}`).value);
            break;
        case 'gamma':
            params.shape = parseFloat(document.getElementById(`param-shape-${id}`).value);
            params.scale = parseFloat(document.getElementById(`param-scale-${id}`).value);
            break;
    }

    engine.updateExpression(id, {
        distParams: { type: distType, params },
        expression: `${distType} distribution`
    });

    updateGraph();
}

/**
 * Load sample data/expression
 */
function loadSample(id, value) {
    // MQ-aware: write into MathQuill field if active, otherwise plain input
    const mq = _mqFields[id];
    if (mq && _mqInputMode[id] !== 'text') {
        engine.updateExpression(id, { expression: value });
        const latex = mathJSToLatex(value);
        _mqInitializing = true;
        mq.latex(latex || value);
        _mqInitializing = false;
        detectAndCreateSliders(id, value);
        _evaluateNumeric(id, value);
        updateGraph();
    } else {
        const element = document.getElementById(`expr-${id}`);
        if (element) {
            element.value = value;
            updateExpressionValue(id); // already calls _evaluateNumeric
        }
    }
}

/** Update parametric t range from UI inputs */
function updateParamRange(id) {
    const expr = engine.expressions.find(e => e.id === id);
    if (!expr) return;
    const tMinEl = document.getElementById(`tmin-${id}`);
    const tMaxEl = document.getElementById(`tmax-${id}`);
    if (tMinEl) expr.tMin = parseFloat(tMinEl.value);
    if (tMaxEl) expr.tMax = parseFloat(tMaxEl.value);
    updateGraph();
}

/** Update polar θ range from UI inputs */
function updatePolarRange(id) {
    const expr = engine.expressions.find(e => e.id === id);
    if (!expr) return;
    const tMinEl = document.getElementById(`thetamin-${id}`);
    const tMaxEl = document.getElementById(`thetamax-${id}`);
    if (tMinEl) expr.thetaMin = parseFloat(tMinEl.value);
    if (tMaxEl) expr.thetaMax = parseFloat(tMaxEl.value);
    updateGraph();
}

/** Load parametric sample with custom t range */
function loadParamSample(id, value, tMin, tMax) {
    const expr = engine.expressions.find(e => e.id === id);
    if (expr) { expr.tMin = tMin; expr.tMax = tMax; }
    const tMinEl = document.getElementById(`tmin-${id}`);
    const tMaxEl = document.getElementById(`tmax-${id}`);
    if (tMinEl) tMinEl.value = tMin;
    if (tMaxEl) tMaxEl.value = tMax;
    loadSample(id, value);
}

/** Load polar sample with custom θ range */
function loadPolarSample(id, value, thetaMin, thetaMax) {
    const expr = engine.expressions.find(e => e.id === id);
    if (expr) { expr.thetaMin = thetaMin; expr.thetaMax = thetaMax; }
    const tMinEl = document.getElementById(`thetamin-${id}`);
    const tMaxEl = document.getElementById(`thetamax-${id}`);
    if (tMinEl) tMinEl.value = thetaMin;
    if (tMaxEl) tMaxEl.value = thetaMax;
    loadSample(id, value);
}

/**
 * Load sample table data
 */
function loadTableSample(id, type) {
    const element = document.getElementById(`expr-${id}`);
    if (!element) return;

    let sampleData = '';

    switch (type) {
        case 'random':
            // Random scattered data
            for (let i = 1; i <= 10; i++) {
                const x = i;
                const y = Math.round((2 * i + Math.random() * 5) * 10) / 10;
                sampleData += `${x}, ${y}\n`;
            }
            break;

        case 'linear':
            // Perfect linear relationship
            for (let i = 1; i <= 8; i++) {
                sampleData += `${i}, ${i * 2 + 1}\n`;
            }
            break;

        case 'regression':
            // Data with clear linear trend
            sampleData = `1, 2.3
2, 4.1
3, 5.8
4, 7.9
5, 10.2
6, 11.8
7, 14.1
8, 15.9
9, 18.2
10, 20.1`;
            break;

        case 'exponential':
            // Exponential growth pattern
            for (let i = 0; i <= 6; i++) {
                const x = i;
                const y = Math.round(Math.exp(i * 0.5) * 10) / 10;
                sampleData += `${x}, ${y}\n`;
            }
            break;
    }

    element.value = sampleData.trim();
    updateExpressionValue(id);
}

/**
 * Update expression type
 */
function updateExpressionType(id) {
    const type = document.getElementById(`type-${id}`).value;
    engine.updateExpression(id, { type });
    createInputForType(id, type);
    // Sync type badge label
    const badge = document.getElementById(`type-badge-${id}`);
    if (badge) badge.textContent = _getTypeBadgeLabel(type);
    // Show/hide calc toggle button (only for cartesian)
    const item = document.getElementById(`expr-item-${id}`);
    const calcBtn = item ? item.querySelector('.gc-calc-toggle-btn') : null;
    if (type === 'cartesian' && !calcBtn && item) {
        // Inject calc button into meta row if switching to cartesian
        const metaRow = item.querySelector('.gc-expr-meta');
        if (metaRow) {
            const btn = document.createElement('button');
            btn.className = 'gc-calc-toggle-btn';
            btn.setAttribute('aria-expanded', 'false');
            btn.title = 'Calculus options';
            btn.onclick = function() { toggleCalcDrawer(id); };
            btn.innerHTML = '<i class="fas fa-sliders"></i> Calc';
            metaRow.insertBefore(btn, metaRow.querySelector('.gc-latex-copy-btn'));
        }
    } else if (type !== 'cartesian' && calcBtn) {
        calcBtn.remove();
        if (item) item.classList.remove('gc-calc-open');
    }
    // Show calculus toggles only for cartesian type
    const calcToggles = document.getElementById(`calculus-toggles-${id}`);
    if (calcToggles) calcToggles.style.display = (type === 'cartesian') ? '' : 'none';
    // Show/hide integration controls
    const intControls = document.getElementById(`integration-controls-${id}`);
    if (intControls && type !== 'cartesian') intControls.style.display = 'none';
    // Lazy-load full Plotly for 3D surface
    if (type === 'surface') _ensureFullPlotly(updateGraph);
    else updateGraph();
}

/** Lazy-load full Plotly.js (with gl3d) when 3D surface is needed */
var _fullPlotlyLoaded = false;
function _ensureFullPlotly(cb) {
    if (_fullPlotlyLoaded) { if (cb) cb(); return; }
    // Check if current Plotly already supports surface (full bundle)
    if (typeof Plotly !== 'undefined' && Plotly.PlotSchema && Plotly.PlotSchema.get) {
        try {
            const schema = Plotly.PlotSchema.get();
            if (schema.traces && schema.traces.surface) {
                _fullPlotlyLoaded = true; if (cb) cb(); return;
            }
        } catch(_) {}
    }
    // Load full Plotly
    const script = document.createElement('script');
    script.src = 'https://cdn.plot.ly/plotly-2.27.0.min.js';
    script.onload = function() { _fullPlotlyLoaded = true; if (cb) cb(); };
    script.onerror = function() {
        console.error('Failed to load full Plotly for 3D');
        if (cb) cb();
    };
    document.head.appendChild(script);
}

/**
 * Convert math expression to LaTeX for KaTeX rendering using Math.js
 */
function convertToLaTeX(expression) {
    if (!expression || expression.trim() === '') {
        return '';
    }

    try {
        // Parse the expression using Math.js
        const node = math.parse(expression);

        // Convert to LaTeX using Math.js built-in function
        let latex = node.toTex();

        // Additional formatting improvements
        // Replace cdot with a nicer multiplication symbol
        latex = latex.replace(/\\cdot/g, '\\cdot');

        // Convert common constants
        latex = latex.replace(/\\mathrm\{pi\}/g, '\\pi');
        latex = latex.replace(/\\mathrm\{e\}/g, 'e');

        return latex;
    } catch (error) {
        // Fallback: if parsing fails, do basic conversion
        let latex = expression;

        // Basic conversions
        latex = latex.replace(/\^/g, '^');
        latex = latex.replace(/\*/g, ' \\cdot ');
        latex = latex.replace(/sqrt/g, '\\sqrt');
        latex = latex.replace(/pi/g, '\\pi');
        latex = latex.replace(/theta/g, '\\theta');

        // Common functions
        const funcs = ['sin', 'cos', 'tan', 'log', 'ln', 'exp'];
        funcs.forEach(func => {
            const regex = new RegExp('\\b' + func + '\\b', 'g');
            latex = latex.replace(regex, '\\' + func);
        });

        return latex;
    }
}

/**
 * Render math preview using KaTeX
 */
function renderMathPreview(id, expression) {
    const previewElement = document.getElementById(`math-preview-${id}`);

    if (!previewElement) {
        return;
    }

    if (!expression || expression.trim() === '') {
        previewElement.innerHTML = '';
        return;
    }

    try {
        const latex = convertToLaTeX(expression);
        // Only prepend "y = " for simple f(x) expressions (no = sign already)
        const prefix = expression.includes('=') ? '' : 'y = ';
        katex.render(prefix + latex, previewElement, {
            throwOnError: false,
            displayMode: true
        });
    } catch (error) {
        previewElement.innerHTML = `<span style="color: #666;">${expression}</span>`;
    }
}

/**
 * Auto-detect whether an expression should be cartesian, implicit, or inequality.
 * Returns null if the current type should not be changed.
 */
function autoDetectType(value, currentType) {
    if (!value || typeof value !== 'string') return null;
    const s = value.trim();
    if (!s) return null;

    // Variable assignment: "a = 3", "k = -2.5" — detect from any type
    // Must be single letter (not x/y/t/e/X/Y/T/E/r/R) = numeric value
    if (/^\s*([a-df-wA-DF-W])\s*=\s*([+-]?\d+\.?\d*)\s*$/.test(s)) {
        return 'variable';
    }

    // List literal: [1, 2, 3] or [1, 2, 3, 4, 5]
    if (/^\s*\[[\d\s,.\-+]+\]\s*$/.test(s)) {
        return 'list';
    }
    // List range: [1...10] or [1..10]
    if (/^\s*\[\s*-?\d+\.?\d*\s*\.{2,3}\s*-?\d+\.?\d*\s*\]\s*$/.test(s)) {
        return 'list';
    }

    // Piecewise brace syntax: {x<0: -x, x>=0: x} — detect the colon-separated condition:expr pattern
    if (/\{[^}]*:[^}]+\}/.test(s) && !(/^\s*[a-zA-Z]\s*=/).test(s)) {
        return 'piecewise';
    }

    // Only auto-switch from cartesian (the default type) for other patterns
    if (currentType !== 'cartesian') return null;

    // Point(s): (2,3) or [(1,2),(3,4)] or (1,2),(3,4) — detect before other checks
    if (/^\s*\(?\s*-?\d+\.?\d*\s*,\s*-?\d+\.?\d*\s*\)?\s*$/.test(s)) return 'point';
    // Multi-point without brackets: (1,2), (3,4), ...
    if (/^\s*(\(\s*-?[\d.]+\s*,\s*-?[\d.]+\s*\)\s*,?\s*){2,}$/.test(s)) return 'point';
    if (/^\s*\[?\s*\(\s*-?\d/.test(s) && s.includes(')') && !(/(?<![a-zA-Z])t(?![a-zA-Z])/.test(s))) return 'point';

    // Vector: <3,4> or <2,3> @ (1,1)
    if (/^\s*<\s*-?[\d.]+\s*,\s*-?[\d.]+\s*>/.test(s)) return 'vector';
    // Vector field: <expr, expr> containing x or y (but not just numbers)
    if (/^\s*(?:\w+\s*\(\s*x\s*,\s*y\s*\)\s*=\s*)?<\s*.+,\s*.+>/.test(s) &&
        (/(?<![a-zA-Z])x(?![a-zA-Z])/.test(s) || /(?<![a-zA-Z])y(?![a-zA-Z])/.test(s)) &&
        s.includes('<') && s.includes('>')) return 'vectorfield';

    // Inequality operators (but not <=, >=, != inside other contexts)
    if (/[^<>=!](>=|<=|>(?!=)|<(?!=))[^<>=]/.test(' ' + s + ' ')) return 'inequality';

    // "y = <expr>" where the RHS is a function of x only → stay cartesian
    if (/^\s*y\s*=\s*/i.test(s)) {
        const rhs = s.replace(/^\s*y\s*=\s*/i, '');
        // If RHS contains y, it's an equation needing CAS; otherwise cartesian
        if (/(?<![a-zA-Z])y(?![a-zA-Z])/.test(rhs)) return 'equation';
        return null; // stay cartesian
    }

    // Has "=" AND contains y → equation (Nerdamer solves for y)
    // e.g. "2x + 3y = 8", "x^2 + y^2 = 25"
    if (s.includes('=') && /(?<![a-zA-Z])y(?![a-zA-Z])/.test(s)) return 'equation';

    // Polar: contains "theta" or "θ" (and no comma — not parametric)
    // e.g. "2*cos(theta)", "1 + sin(θ)", "r = 2cos(theta)"
    if (!s.includes(',') && (/(?<![a-zA-Z])theta(?![a-zA-Z])/.test(s) || s.includes('θ'))) {
        return 'polar';
    }

    // Parametric: comma-separated with "t" variable
    // e.g. "cos(t), sin(t)", "t^2, t^3"
    if (s.includes(',') && /(?<![a-zA-Z])t(?![a-zA-Z])/.test(s)) {
        return 'parametric';
    }

    // Contains both x and y but no "=" → surface z = f(x, y)
    // e.g. "sin(x)*cos(y)", "x^2 + y^2", "exp(-(x^2+y^2)/2)"
    if (/(?<![a-zA-Z])x(?![a-zA-Z])/.test(s) && /(?<![a-zA-Z])y(?![a-zA-Z])/.test(s)) {
        return 'surface';
    }

    return null;
}

// ==================== Special Calculus Syntax Handler ====================

/**
 * Parse a bound value that may be a number or a math expression (e.g. "pi", "2*pi", "e")
 */
function _parseBound(s) {
    if (!s) return NaN;
    s = s.trim();
    try { return math.evaluate(s); } catch (_) { return NaN; }
}

/**
 * Handle special calculus syntax typed in an expression input.
 * Shared by both MathQuill and plain-text input paths.
 * Returns true if handled (caller should updateGraph and return).
 *
 * Supported:
 *   int(expr, a, b)    → plot expr with shaded definite integral, show ≈ area
 *   sum(n, a, b, body) → if body has x: plot as function; else show numeric result
 *   prod(n, a, b, body)→ same
 *   deriv(expr, x0)    → plot expr, show tangent at x0, show f'(x0) ≈ value
 *   lim(expr, var, val) → show numeric + symbolic limit result
 */
function _handleSpecialSyntaxFromInput(id, value) {
    var expr = engine.expressions.find(function(e) { return e.id === id; });
    if (!expr) return false;
    var s = value.trim();

    // ── int(expression, a, b) ──
    var intMatch = s.match(/^\s*int\s*\(\s*(.+?)\s*,\s*(.+?)\s*,\s*(.+?)\s*\)\s*$/i);
    if (intMatch) {
        var intExpr = intMatch[1].trim();
        var intA = _parseBound(intMatch[2]);
        var intB = _parseBound(intMatch[3]);
        if (isNaN(intA) || isNaN(intB)) return false; // can't parse bounds

        // Store full form for MathQuill round-tripping, but set expression to just integrand for plotting
        expr._originalInput = s;
        expr.expression = intExpr;
        engine.updateExpression(id, { expression: intExpr });
        expr.showIntegration = true;
        expr.integrationBounds = { a: intA, b: intB };

        // Open calc drawer and sync UI
        _openCalcDrawerForExpr(id);
        var intCb = document.getElementById('show-integration-' + id);
        if (intCb) intCb.checked = true;
        var intControls = document.getElementById('integration-controls-' + id);
        if (intControls) intControls.style.display = 'block';
        var intAInput = document.getElementById('integration-a-' + id);
        var intBInput = document.getElementById('integration-b-' + id);
        if (intAInput) intAInput.value = intA;
        if (intBInput) intBInput.value = intB;

        // Compute and show numeric integral result + symbolic antiderivative
        _showIntegrationResult(id, intExpr, intA, intB);
        return true;
    }

    // ── deriv(expression, x0) ──
    var derivMatch = s.match(/^\s*deriv\s*\(\s*(.+?)\s*,\s*(.+?)\s*\)\s*$/i);
    if (derivMatch) {
        var derivExpr = derivMatch[1].trim();
        var x0 = _parseBound(derivMatch[2]);
        if (isNaN(x0)) return false;

        // Set underlying expression to the function, enable tangent at x0
        expr.expression = derivExpr;
        engine.updateExpression(id, { expression: derivExpr });
        expr.showTangent = true;
        expr.tangentX = x0;
        expr.showDerivative = true;

        // Open calc drawer and sync UI
        _openCalcDrawerForExpr(id);
        var tangCb = document.getElementById('show-tangent-' + id);
        if (tangCb) tangCb.checked = true;
        var derivCb = document.getElementById('show-derivative-' + id);
        if (derivCb) derivCb.checked = true;

        // Show numeric derivative result
        var resultEl2 = document.getElementById('numeric-result-' + id);
        if (resultEl2) {
            var dVal = _numericDeriv(derivExpr, x0);
            if (dVal !== null && isFinite(dVal)) {
                resultEl2.textContent = "f'(" + x0 + ') ≈ ' + parseFloat(dVal.toPrecision(10));
            } else {
                resultEl2.textContent = "f'(" + x0 + ')';
            }
            resultEl2.style.display = 'block';
        }
        return true;
    }

    // ── lim(expression, variable, value) ──
    var limMatch = s.match(/^\s*lim\s*\(\s*(.+?)\s*,\s*([a-zA-Z])\s*,\s*(.+?)\s*\)\s*$/i);
    if (limMatch) {
        var limExpr = limMatch[1].trim();
        var limVar = limMatch[2];
        var limValStr = limMatch[3].trim();

        // Store full form for MathQuill round-tripping
        expr._originalInput = s;

        // Switch to limit type and set limit-specific fields
        expr.type = 'limit';
        expr.expression = limExpr;
        expr.limitExpr = limExpr;
        expr.limitVar = limVar;
        expr.limitVal = limValStr;
        engine.updateExpression(id, { expression: limExpr });

        // Update type badge
        var typeSel = document.getElementById('type-' + id);
        if (typeSel) typeSel.value = 'limit';
        var badge = document.getElementById('type-badge-' + id);
        if (badge) badge.textContent = 'LIM';

        // Evaluate limit numerically and show result
        _showLimitResult(id, limExpr, limVar, limValStr);
        return true;
    }

    // ── sum(var, start, end, body) — only intercept if body has NO x (pure numeric sum) ──
    // If body has x, let the engine's _generateSumProductTrace handle it as a plotted function
    var sumMatch = s.match(/^\s*sum\s*\(\s*([a-zA-Z])\s*,\s*(.+?)\s*,\s*(.+?)\s*,\s*(.+)\s*\)\s*$/i);
    if (sumMatch && !/(?<![a-zA-Z])x(?![a-zA-Z])/.test(sumMatch[4])) {
        // Pure numeric sum — show result inline
        try {
            var start = Math.round(_parseBound(sumMatch[2]));
            var end = Math.round(_parseBound(sumMatch[3]));
            if (!isNaN(start) && !isNaN(end) && end - start <= 100000) {
                var total = _numericSum(sumMatch[1], start, end, sumMatch[4]);
                var resultEl3 = document.getElementById('numeric-result-' + id);
                if (resultEl3 && total !== null && isFinite(total)) {
                    _showNumericResult(resultEl3, total);
                    return true;
                }
            }
        } catch (_) {}
        return false; // fall through to normal handling
    }

    // ── prod(var, start, end, body) — same logic ──
    var prodMatch = s.match(/^\s*prod\s*\(\s*([a-zA-Z])\s*,\s*(.+?)\s*,\s*(.+?)\s*,\s*(.+)\s*\)\s*$/i);
    if (prodMatch && !/(?<![a-zA-Z])x(?![a-zA-Z])/.test(prodMatch[4])) {
        try {
            var pStart = Math.round(_parseBound(prodMatch[2]));
            var pEnd = Math.round(_parseBound(prodMatch[3]));
            if (!isNaN(pStart) && !isNaN(pEnd) && pEnd - pStart <= 100000) {
                var pTotal = _numericProd(prodMatch[1], pStart, pEnd, prodMatch[4]);
                var resultEl4 = document.getElementById('numeric-result-' + id);
                if (resultEl4 && pTotal !== null && isFinite(pTotal)) {
                    _showNumericResult(resultEl4, pTotal);
                    return true;
                }
            }
        } catch (_) {}
        return false;
    }

    return false;
}

/**
 * Open the calc drawer for an expression and sync the button state
 */
function _openCalcDrawerForExpr(id) {
    var item = document.getElementById('expr-item-' + id);
    if (item && !item.classList.contains('gc-calc-open')) {
        item.classList.add('gc-calc-open');
        var calcBtn = item.querySelector('.gc-calc-toggle-btn');
        if (calcBtn) {
            calcBtn.setAttribute('aria-expanded', 'true');
            calcBtn.innerHTML = '<i class="fas fa-chevron-up"></i> Calc';
        }
    }
}

/**
 * Show integration area result (and optional symbolic antiderivative) in the numeric result panel.
 * Called when toggling ∫ checkbox or changing bounds in the Calc drawer.
 */
function _showIntegrationResult(id, expression, a, b) {
    var resultEl = document.getElementById('numeric-result-' + id);
    if (!resultEl) return;
    var area = _numericIntegrate(expression, a, b);
    var parts = [];
    var areaStr = null;
    if (area !== null && isFinite(area)) {
        areaStr = Number.isInteger(area) ? String(area) : parseFloat(area.toPrecision(10)).toString();
        parts.push('∫ [' + a + ', ' + b + '] ≈ ' + areaStr);
    }
    // Try symbolic antiderivative via Nerdamer
    try {
        if (typeof nerdamer !== 'undefined' && expression) {
            var normExpr = engine.stripCartesianPrefix(engine.normalizeExpression(expression));
            var antideriv = nerdamer('integrate(' + normExpr + ', x)');
            var sym = antideriv.text();
            if (sym) {
                parts.push('F(x) = ' + sym + ' + C');
                if (areaStr !== null) {
                    parts.push('FTC: ∫[' + a + ', ' + b + '] f(x)dx = F(' + b + ') - F(' + a + ') ≈ ' + areaStr);
                }
            }
        }
    } catch (_) { /* Nerdamer can't integrate — that's fine */ }
    if (parts.length > 0) {
        resultEl.innerHTML = parts.join('<br>');
        resultEl.style.display = 'block';
    } else {
        resultEl.style.display = 'none';
    }
}

/**
 * Evaluate a limit and show the result in the numeric result panel.
 * Uses numerical approach (evaluate near the point) with Nerdamer symbolic fallback.
 */
function _showLimitResult(id, expression, variable, value) {
    var resultEl = document.getElementById('numeric-result-' + id);
    if (!resultEl) return;

    var parts = [];

    // Numerical limit via successive approach
    var numericLimit = _numericLimit(expression, variable, value);
    if (numericLimit !== null && isFinite(numericLimit)) {
        var limStr = Number.isInteger(numericLimit) ? String(numericLimit) : parseFloat(numericLimit.toPrecision(10)).toString();
        parts.push('lim(' + variable + '→' + value + ') ≈ ' + limStr);
    }

    // Symbolic via Nerdamer
    try {
        if (typeof nerdamer !== 'undefined' && expression) {
            var normExpr = engine.stripCartesianPrefix(engine.normalizeExpression(expression));
            var result = nerdamer('limit(' + normExpr + ', ' + variable + ', ' + value + ')');
            var sym = result.text();
            if (sym) {
                parts.push('L = ' + sym);
            }
        }
    } catch (_) { /* Nerdamer can't evaluate — that's fine */ }

    if (parts.length > 0) {
        resultEl.innerHTML = parts.join('<br>');
        resultEl.style.display = 'block';
    } else {
        resultEl.style.display = 'none';
    }
}

/**
 * Numerically evaluate a limit by approaching the point from both sides.
 * Returns the averaged value if both sides converge, or null.
 */
function _numericLimit(expression, variable, value) {
    try {
        var a = _parseBound(value);
        var normExpr = engine ? engine.normalizeExpression(expression) : expression;
        var node = math.parse(normExpr);

        // Handle infinity: approach from large values
        if (!isFinite(a)) {
            var sign = a > 0 ? 1 : -1;
            var vals = [1e2, 1e4, 1e6, 1e8].map(function(n) {
                var scope = {}; scope[variable] = sign * n;
                try { return node.evaluate(scope); } catch (_) { return NaN; }
            });
            var last = vals[vals.length - 1];
            if (isFinite(last)) return last;
            return null;
        }

        // Approach from left and right
        var deltas = [0.1, 0.01, 0.001, 0.0001, 0.00001, 0.000001];
        var leftVals = [], rightVals = [];
        for (var i = 0; i < deltas.length; i++) {
            var scopeL = {}; scopeL[variable] = a - deltas[i];
            var scopeR = {}; scopeR[variable] = a + deltas[i];
            try { leftVals.push(node.evaluate(scopeL)); } catch (_) { leftVals.push(NaN); }
            try { rightVals.push(node.evaluate(scopeR)); } catch (_) { rightVals.push(NaN); }
        }
        var lLast = leftVals[leftVals.length - 1];
        var rLast = rightVals[rightVals.length - 1];
        if (isFinite(lLast) && isFinite(rLast) && Math.abs(lLast - rLast) < 1e-4) {
            return (lLast + rLast) / 2;
        }
        if (isFinite(lLast)) return lLast;
        if (isFinite(rLast)) return rLast;
        return null;
    } catch (_) { return null; }
}

// ==================== Variable Assignment Handler ====================

/**
 * Handle variable-type expression: "a = 3" → global slider
 */
function _handleVariableExpression(id, value) {
    var expr = engine.expressions.find(function(e) { return e.id === id; });
    if (!expr) return;

    var m = value.trim().match(/^\s*([a-df-wA-DF-W])\s*=\s*([+-]?\d+\.?\d*)\s*$/);
    if (!m) {
        // Not a valid assignment — clear variable state
        delete expr._varName;
        delete expr._varValue;
        engine.rebuildGlobalScope();
        var errorDiv = document.getElementById('expr-error-' + id);
        if (errorDiv) {
            errorDiv.textContent = 'Expected: letter = number (e.g. a = 3)';
            errorDiv.style.display = 'block';
        }
        return;
    }

    var varName = m[1];
    var varValue = parseFloat(m[2]);
    expr._varName = varName;
    expr._varValue = varValue;
    engine.rebuildGlobalScope();

    // Clear error
    var errorDiv = document.getElementById('expr-error-' + id);
    if (errorDiv) { errorDiv.style.display = 'none'; errorDiv.textContent = ''; }

    // Show numeric result
    var resultEl = document.getElementById('numeric-result-' + id);
    if (resultEl) {
        resultEl.textContent = '= ' + varValue;
        resultEl.style.display = 'block';
    }

    // Build a global slider for this variable
    var slidersContainer = document.getElementById('sliders-container-' + id);
    if (slidersContainer) {
        var prevRange = expr._sliderRanges && expr._sliderRanges[varName];
        var sMin = prevRange ? prevRange.min : -10;
        var sMax = prevRange ? prevRange.max : 10;
        var sStep = prevRange ? prevRange.step : 0.1;
        slidersContainer.innerHTML = '<div class="mt-2"><small class="text-muted" style="color:var(--gc-tool);font-weight:600;">Global variable</small></div>' +
            '<div class="mb-2">' +
            '<div class="d-flex align-items-center gap-1">' +
            '<label class="form-label mb-0" style="font-size:12px;">' + varName + ' = <span id="param-value-' + varName + '-' + id + '">' + varValue.toFixed(1) + '</span></label>' +
            '<button class="btn btn-sm" style="font-size:9px;padding:0 3px;color:#888;" onclick="toggleSliderRange(' + id + ',\'' + varName + '\')" title="Customize range">&#9881;</button>' +
            '</div>' +
            '<input type="range" class="form-range" id="param-' + varName + '-' + id + '"' +
            ' min="' + sMin + '" max="' + sMax + '" step="' + sStep + '" value="' + varValue + '"' +
            ' aria-label="Variable ' + varName + ' slider"' +
            ' oninput="_updateGlobalVariable(' + id + ',\'' + varName + '\',this.value)">' +
            '<div id="slider-range-' + varName + '-' + id + '" style="display:none;" class="d-flex gap-1 align-items-center mt-1">' +
            '<input type="number" class="form-control form-control-sm" style="width:55px;font-size:10px;" value="' + sMin + '" id="slider-min-' + varName + '-' + id + '" onchange="updateSliderRange(' + id + ',\'' + varName + '\')" placeholder="min">' +
            '<span style="font-size:10px;">to</span>' +
            '<input type="number" class="form-control form-control-sm" style="width:55px;font-size:10px;" value="' + sMax + '" id="slider-max-' + varName + '-' + id + '" onchange="updateSliderRange(' + id + ',\'' + varName + '\')" placeholder="max">' +
            '<span style="font-size:10px;">step</span>' +
            '<input type="number" class="form-control form-control-sm" style="width:55px;font-size:10px;" value="' + sStep + '" id="slider-step-' + varName + '-' + id + '" onchange="updateSliderRange(' + id + ',\'' + varName + '\')" placeholder="step" min="0.001" step="0.01">' +
            '</div>' +
            '</div>';
    }
}

/**
 * Update a global variable value from its slider
 */
function _updateGlobalVariable(id, varName, value) {
    var numVal = parseFloat(value);
    var expr = engine.expressions.find(function(e) { return e.id === id; });
    if (expr) {
        expr._varValue = numVal;
        expr.expression = varName + ' = ' + numVal;
        engine.rebuildGlobalScope();
    }
    // Update display
    var valSpan = document.getElementById('param-value-' + varName + '-' + id);
    if (valSpan) valSpan.textContent = numVal.toFixed(1);
    var inputEl = document.getElementById('expr-' + id);
    if (inputEl) inputEl.value = varName + ' = ' + numVal;
    var resultEl = document.getElementById('numeric-result-' + id);
    if (resultEl) { resultEl.textContent = '= ' + numVal; resultEl.style.display = 'block'; }
    updateGraph();
}

// ==================== Piecewise Brace Syntax Parser ====================

/**
 * Parse Desmos-style piecewise brace syntax: "{x<0: -x, x>=0: x}" or "y = {x<0: x^2, x>=0: sin(x)}"
 * Converts to expr.pieces array used by generatePiecewise.
 */
function _parsePiecewiseBraceSyntax(id, value) {
    var expr = engine.expressions.find(function(e) { return e.id === id; });
    if (!expr) return;

    // Strip optional "y =" or "f(x) =" prefix
    var s = value.trim().replace(/^\s*(?:y\s*=\s*|[a-zA-Z]\s*\(\s*x\s*\)\s*=\s*)/, '');

    // Extract content inside outermost braces (balanced extraction)
    var braceStart = s.indexOf('{');
    if (braceStart === -1) return;
    var braceDepth = 0, braceEnd = -1;
    for (var bi = braceStart; bi < s.length; bi++) {
        if (s[bi] === '{') braceDepth++;
        else if (s[bi] === '}') { braceDepth--; if (braceDepth === 0) { braceEnd = bi; break; } }
    }
    if (braceEnd === -1) return;
    var inner = s.substring(braceStart + 1, braceEnd).trim();
    if (!inner) return;

    // Split on comma that separates pieces — but not commas inside function calls
    // Strategy: split on ", " followed by a condition pattern (letter or digit then comparison op)
    var pieces = [];
    var segments = _splitPiecewiseSegments(inner);

    for (var i = 0; i < segments.length; i++) {
        var seg = segments[i].trim();
        if (!seg) continue;
        // Each segment is "condition: expression" or just "expression" (else clause)
        var colonIdx = seg.indexOf(':');
        if (colonIdx > 0) {
            var cond = seg.substring(0, colonIdx).trim();
            var exprStr = seg.substring(colonIdx + 1).trim();
            pieces.push({ condition: cond, expression: exprStr });
        } else {
            // No colon — treat as else/default clause
            pieces.push({ condition: 'true', expression: seg });
        }
    }

    if (pieces.length > 0) {
        expr.pieces = pieces;
        // Clear error
        var errorDiv = document.getElementById('expr-error-' + id);
        if (errorDiv) { errorDiv.style.display = 'none'; errorDiv.textContent = ''; }
        // Show piece count in numeric result
        var resultEl = document.getElementById('numeric-result-' + id);
        if (resultEl) {
            resultEl.textContent = pieces.length + ' piece' + (pieces.length > 1 ? 's' : '');
            resultEl.style.display = 'block';
        }
    }
}

/**
 * Split piecewise segments on commas that separate condition:expr pairs.
 * Respects parentheses nesting so "sin(x,y)" commas are not split.
 */
function _splitPiecewiseSegments(s) {
    var segments = [];
    var depth = 0;
    var current = '';
    for (var i = 0; i < s.length; i++) {
        var ch = s[i];
        if (ch === '(' || ch === '[') depth++;
        else if (ch === ')' || ch === ']') depth--;
        else if (ch === ',' && depth === 0) {
            segments.push(current);
            current = '';
            continue;
        }
        current += ch;
    }
    if (current.trim()) segments.push(current);
    return segments;
}

/**
 * Switch from inline brace syntax to multi-piece piecewise UI
 */
function _switchToPiecewiseUI(id) {
    var expr = engine.expressions.find(function(e) { return e.id === id; });
    if (!expr) return;
    // Clear the inline syntax so createInputForType renders the piece UI
    expr.expression = '';
    createInputForType(id, 'piecewise');
}

/**
 * Switch from multi-piece UI to inline brace syntax
 */
function _switchToBraceSyntax(id) {
    var expr = engine.expressions.find(function(e) { return e.id === id; });
    if (!expr) return;
    // Build brace syntax from existing pieces
    var braceSyntax = '{';
    if (expr.pieces && expr.pieces.length > 0) {
        for (var i = 0; i < expr.pieces.length; i++) {
            if (i > 0) braceSyntax += ', ';
            var cond = expr.pieces[i].condition || 'true';
            braceSyntax += cond + ': ' + (expr.pieces[i].expression || '0');
        }
    } else {
        braceSyntax += 'x<0: -x, x>=0: x';
    }
    braceSyntax += '}';
    expr.expression = braceSyntax;
    createInputForType(id, 'piecewise');
    var input = document.getElementById('expr-' + id);
    if (input) input.value = braceSyntax;
    _parsePiecewiseBraceSyntax(id, braceSyntax);
    updateGraph();
}

// ==================== List Expression Handler ====================

/**
 * Handle list-type expression: "[1, 2, 3]" or "[1...10]"
 * Stores parsed list in engine.globalScope as a named list or in expr._listValues.
 */
function _handleListExpression(id, value) {
    var expr = engine.expressions.find(function(e) { return e.id === id; });
    if (!expr) return;

    var s = value.trim();
    var listValues = null;

    // Check for named list: "L = [1,2,3]" or "L1 = [1,2,3]"
    var namedMatch = s.match(/^\s*([a-zA-Z]\w*)\s*=\s*\[(.+)\]\s*$/);
    var listName = null;
    var innerStr = null;

    if (namedMatch) {
        listName = namedMatch[1];
        innerStr = namedMatch[2];
    } else {
        // Anonymous list: "[1,2,3]"
        var anonMatch = s.match(/^\s*\[(.+)\]\s*$/);
        if (anonMatch) innerStr = anonMatch[1];
    }

    if (innerStr !== null) {
        // Check for range syntax: "1...10" or "1..10"
        var rangeMatch = innerStr.match(/^\s*(-?\d+\.?\d*)\s*\.{2,3}\s*(-?\d+\.?\d*)\s*$/);
        if (rangeMatch) {
            var start = parseFloat(rangeMatch[1]);
            var end = parseFloat(rangeMatch[2]);
            listValues = [];
            var step = start <= end ? 1 : -1;
            for (var v = start; step > 0 ? v <= end : v >= end; v += step) {
                listValues.push(v);
                if (listValues.length > 10000) break; // safety
            }
        } else {
            // Parse comma-separated values
            var parts = innerStr.split(',');
            listValues = [];
            for (var i = 0; i < parts.length; i++) {
                var p = parts[i].trim();
                if (p === '') continue;
                try {
                    var val = math.evaluate(p);
                    if (typeof val === 'number' && isFinite(val)) listValues.push(val);
                } catch (_) {
                    // skip non-numeric
                }
            }
        }
    }

    expr._listValues = listValues;
    expr._listName = listName;

    // Store in globalScope if named
    if (listName && listValues) {
        engine.globalScope[listName] = listValues;
    }

    // Show list info
    var resultEl = document.getElementById('numeric-result-' + id);
    if (resultEl && listValues) {
        var preview = '[' + (listValues.length <= 8 ? listValues.join(', ') : listValues.slice(0, 6).join(', ') + ', ... ' + listValues[listValues.length - 1]) + ']';
        resultEl.textContent = preview + '  (' + listValues.length + ' items)';
        resultEl.style.display = 'block';
    }

    // Show basic stats
    if (listValues && listValues.length > 0) {
        var sum = 0, min = listValues[0], max = listValues[0];
        for (var j = 0; j < listValues.length; j++) {
            sum += listValues[j];
            if (listValues[j] < min) min = listValues[j];
            if (listValues[j] > max) max = listValues[j];
        }
        var mean = sum / listValues.length;
        var slidersContainer = document.getElementById('sliders-container-' + id);
        if (slidersContainer) {
            slidersContainer.innerHTML = '<div class="mt-2" style="font-size:11px;color:var(--text-muted,#888);">' +
                '<strong>Stats:</strong> mean=' + mean.toFixed(2) + ', min=' + min + ', max=' + max + ', n=' + listValues.length +
                '</div>';
        }
    }

    // Clear error
    var errorDiv = document.getElementById('expr-error-' + id);
    if (errorDiv) { errorDiv.style.display = 'none'; errorDiv.textContent = ''; }
}

/**
 * Update expression value
 */
function updateExpressionValue(id) {
    const element = document.getElementById(`expr-${id}`);

    if (!element) {
        console.error('Input element not found for id:', id);
        return;
    }

    // Debounced undo save — captures state 500ms after last keystroke
    if (_undoSaveTimer) clearTimeout(_undoSaveTimer);
    else saveUndoState(); // save before first change in this burst
    _undoSaveTimer = setTimeout(() => { _undoSaveTimer = null; }, 500);

    const value = element.value;
    engine.updateExpression(id, { expression: value });

    // Auto-detect and switch type FIRST (before validation, so we validate the right type)
    const expr = engine.expressions.find(e => e.id === id);
    if (expr) {
        const detected = autoDetectType(value, expr.type);
        if (detected && detected !== expr.type) {
            expr.type = detected;
            const typeSel = document.getElementById(`type-${id}`);
            if (typeSel) typeSel.value = detected;
            const badge = document.getElementById(`type-badge-${id}`);
            if (badge) badge.textContent = _getTypeBadgeLabel(detected);
            // Show/hide calculus toggles based on new type
            const calcToggles = document.getElementById(`calculus-toggles-${id}`);
            if (calcToggles) calcToggles.style.display = (detected === 'cartesian') ? '' : 'none';
            // Rebuild the input UI for the new type (but preserve the expression text)
            createInputForType(id, detected);
            // Restore the expression value in the new input (plain text fallback — MQ populated by _initMathQuillField)
            if (!_mqFields[id]) {
                const newInput = document.getElementById(`expr-${id}`);
                if (newInput && newInput.value !== value) newInput.value = value;
            }
            // Lazy-load full Plotly for 3D surface
            if (detected === 'surface') {
                _ensureFullPlotly(updateGraph);
                return; // updateGraph will be called by _ensureFullPlotly callback
            }
        }
    }

    // Handle variable assignment type: "a = 3" → store in globalScope, show slider
    if (expr && expr.type === 'variable') {
        _handleVariableExpression(id, value);
        updateGraph();
        return;
    }

    // Handle inline piecewise brace syntax: "{x<0: -x, x>=0: x}"
    if (expr && expr.type === 'piecewise' && /\{[^}]*:[^}]+\}/.test(value)) {
        _parsePiecewiseBraceSyntax(id, value);
        updateGraph();
        return;
    }

    // Handle list type: "[1, 2, 3]" or "[1...10]"
    if (expr && expr.type === 'list') {
        _handleListExpression(id, value);
        updateGraph();
        return;
    }

    // Handle special calculus syntax: int(), sum(), prod(), deriv()
    if (expr && expr.type === 'cartesian') {
        var handled = _handleSpecialSyntaxFromInput(id, value);
        if (handled) { updateGraph(); return; }
    }

    // Validate expression and show error feedback
    const errorDiv = document.getElementById(`expr-error-${id}`);
    const exprObj = engine.expressions.find(e => e.id === id);
    // Only validate types where math.parse can handle the syntax
    // equation/implicit/inequality/polar/parametric have their own parsers
    const validatableTypes = ['cartesian', 'limit'];
    // Skip validation for special expression types that math.parse can't handle
    const isSpecialExpr = value.trim() && (/^\s*(sum|prod|fourier)\s*\(/i.test(value.trim()));
    if (errorDiv && value.trim() && exprObj && validatableTypes.includes(exprObj.type) && !isSpecialExpr) {
        try {
            // Strip domain restriction before parsing: "x^2 {x > 0}" → "x^2"
            const { expr: cleanExpr } = engine.parseDomainRestriction(value);
            // Resolve function composition before validation
            let resolved = resolveFunctionComposition(cleanExpr);
            let normalized = engine.normalizeExpression(resolved);
            let stripped = engine.stripCartesianPrefix(normalized);
            // Substitute global scope variables for validation
            if (engine.globalScope) {
                Object.keys(engine.globalScope).forEach(varName => {
                    if (typeof engine.globalScope[varName] === 'number') {
                        const re = new RegExp(`\\b${varName}\\b`, 'g');
                        stripped = stripped.replace(re, String(engine.globalScope[varName]));
                    }
                });
            }
            // Substitute parameters so "4ax" with slider a=1 parses as "4*1*x"
            if (exprObj.parameters) {
                Object.keys(exprObj.parameters).forEach(param => {
                    const re = new RegExp(`\\b${param}\\b`, 'g');
                    stripped = stripped.replace(re, String(exprObj.parameters[param]));
                });
            }
            math.parse(stripped);
            errorDiv.style.display = 'none';
            errorDiv.textContent = '';
            element.classList.remove('gc-input-error');
        } catch (parseErr) {
            const msg = (parseErr.message || 'Invalid expression').replace(/^.*?Error:\s*/, '');
            errorDiv.textContent = msg;
            errorDiv.style.display = 'block';
            element.classList.add('gc-input-error');
        }
    } else if (errorDiv) {
        errorDiv.style.display = 'none';
        if (element) element.classList.remove('gc-input-error');
    }

    // Render math preview for cartesian expressions (skip when MathQuill is active — it IS the preview)
    if (expr && expr.type === 'cartesian' && _mqInputMode[id] !== 'math' && !_mqFields[id]) {
        renderMathPreview(id, value);
    }

    // Detect and create sliders for parameters (all plottable types)
    if (expr && ['cartesian', 'equation', 'implicit', 'polar', 'parametric', 'inequality'].includes(expr.type)) {
        detectAndCreateSliders(id, value);
    }

    // Update stats if statistics type
    if (expr && expr.type === 'statistics' && expr.stats) {
        displayStatistics(id, expr.stats);
    }

    // Numeric evaluation (Desmos-style)
    _evaluateNumeric(id, value);

    updateGraph();
}

/**
 * Update expression color
 */
function updateExpressionColor(id) {
    const color = document.getElementById(`color-${id}`).value;
    engine.updateExpression(id, { color });
    // Sync the color swatch in the left rail
    const swatch = document.querySelector(`#expr-item-${id} .gc-color-swatch`);
    if (swatch) swatch.style.background = color;
    updateGraph();
}

/**
 * Delete expression
 */
function deleteExpression(id) {
    saveUndoState();
    // Stop animation if it's running for this expression
    if (animationState.isPlaying && animationState.exprId === id) stopAnimation();
    // Close table if it's showing this expression
    if (_tableExprId === id) _closeTable();
    // Cleanup MathQuill field
    if (_mqFields[id]) delete _mqFields[id];
    if (_mqInputMode[id]) delete _mqInputMode[id];
    // Check if this is a variable or list expression — rebuild global scope after removal
    var wasGlobal = false;
    var delExpr = engine.expressions.find(function(e) { return e.id === id; });
    if (delExpr && (delExpr.type === 'variable' || delExpr.type === 'list')) wasGlobal = true;
    engine.removeExpression(id);
    if (wasGlobal) engine.rebuildGlobalScope();
    const element = expressionElements[id];
    if (element) {
        element.remove();
        delete expressionElements[id];
    }
    updateGraph();
}

/**
 * Update regression type for statistics expression
 */
function updateRegressionType(id) {
    const select = document.getElementById(`regression-type-${id}`);
    const expr = engine.expressions.find(e => e.id === id);
    if (expr && select) {
        expr.regressionType = select.value;
        updateGraph();
        // Re-display stats after re-render
        if (expr.stats) displayStatistics(id, expr.stats);
    }
}

/**
 * Display statistics
 */
function displayStatistics(id, stats) {
    const statsDiv = document.getElementById(`stats-${id}`);
    if (statsDiv && stats) {
        statsDiv.style.display = 'block';
        let html = `
            <strong>Statistics:</strong><br>
            n = ${stats.n}<br>
            Mean: (${stats.meanX}, ${stats.meanY})<br>
            Std Dev: (${stats.stdX}, ${stats.stdY})<br>
            Correlation: ${stats.correlation}<br>
            ${stats.regressionEquation}`;
        if (stats.r2) html += `<br>R² = ${stats.r2}`;
        if (stats.regressionType) html += ` <small>(${stats.regressionType})</small>`;
        statsDiv.innerHTML = html;
    }
}

/**
 * Update the graph
 */
function updateGraph() {
    const xMin = parseFloat(document.getElementById('xMin').value);
    const xMax = parseFloat(document.getElementById('xMax').value);
    const yMin = parseFloat(document.getElementById('yMin').value);
    const yMax = parseFloat(document.getElementById('yMax').value);
    const showGrid = document.getElementById('showGrid').checked;
    const showLegend = document.getElementById('showLegend').checked;

    engine.plot({ xMin, xMax, yMin, yMax, showGrid, showLegend });

    // Auto-refresh table of values if visible
    if (typeof _refreshTable === 'function') _refreshTable();
}

/**
 * Reset view to default
 */
function resetView() {
    document.getElementById('xMin').value = -10;
    document.getElementById('xMax').value = 10;
    document.getElementById('yMin').value = -10;
    document.getElementById('yMax').value = 10;
    updateGraphForceRange();
}

/**
 * Re-plot with forced range from input fields (ignores Plotly zoom state)
 */
function updateGraphForceRange() {
    const xMin = parseFloat(document.getElementById('xMin').value);
    const xMax = parseFloat(document.getElementById('xMax').value);
    const yMin = parseFloat(document.getElementById('yMin').value);
    const yMax = parseFloat(document.getElementById('yMax').value);
    const showGrid = document.getElementById('showGrid').checked;
    const showLegend = document.getElementById('showLegend').checked;

    engine.plot({ xMin, xMax, yMin, yMax, showGrid, showLegend, _forceRange: true });
}

// Initialize: DOM may already be ready if script was loaded async after DOMContentLoaded
// Skip boot when loaded as a library (e.g., from math editor's graph-insert.js)
function _gcBoot() {
    if (window._gcSkipBoot) return;
    initGraph();
    ['xMin', 'xMax', 'yMin', 'yMax'].forEach(id => {
        const el = document.getElementById(id);
        if (el) el.addEventListener('change', updateGraphForceRange);
    });

    // Start auto-demo if user hasn't typed anything (idle showcase)
    _startAutoDemo();
}
if (document.readyState === 'loading') {
    window.addEventListener('DOMContentLoaded', _gcBoot);
} else {
    _gcBoot();
}

// ============================================
// Auto-Demo Carousel — showcases presets on idle
// Stops permanently on any user interaction
// ============================================
var _autoDemoTimer = null;
var _autoDemoRunning = false;
var _autoDemoIndex = 0;
var _autoDemoCycleTimer = null;

var _autoDemoPresets = [
    'heart', 'butterfly', 'spirograph', 'lissajous',
    'polar_flowers', 'rose_curves', 'golden_spiral', 'deltoid'
];

function _startAutoDemo() {
    // Don't start in embed mode, if URL has shared state, or user already typed something
    if (window.EMBED_MODE) return;
    if (window.location.hash || window.location.search) return;
    var firstInput = document.querySelector('.expression-input');
    if (firstInput && firstInput.value && firstInput.value.trim() !== '') return;

    _autoDemoRunning = true;

    // Show demo badge
    _showDemoBadge();

    // First demo fires after 8 seconds of idle
    _autoDemoTimer = setTimeout(function() {
        if (!_autoDemoRunning) return;
        _runNextDemo();
        // Then cycle every 6 seconds
        _autoDemoCycleTimer = setInterval(function() {
            if (!_autoDemoRunning) { clearInterval(_autoDemoCycleTimer); return; }
            _runNextDemo();
        }, 6000);
    }, 8000);

    // Stop on any user interaction
    var stopEvents = ['keydown', 'mousedown', 'touchstart', 'pointerdown'];
    function stopDemo() {
        _stopAutoDemo();
        stopEvents.forEach(function(ev) { document.removeEventListener(ev, stopDemo, true); });
    }
    stopEvents.forEach(function(ev) { document.addEventListener(ev, stopDemo, true); });
}

function _runNextDemo() {
    if (!_autoDemoRunning || !engine) return;
    var preset = _autoDemoPresets[_autoDemoIndex % _autoDemoPresets.length];
    _autoDemoIndex++;

    // Enable animation for this render
    engine._animateNext = true;

    if (typeof gcQuickPreset === 'function') {
        gcQuickPreset(preset);
    }
}

function _stopAutoDemo() {
    var wasRunning = _autoDemoRunning;
    _autoDemoRunning = false;
    if (_autoDemoTimer) { clearTimeout(_autoDemoTimer); _autoDemoTimer = null; }
    if (_autoDemoCycleTimer) { clearInterval(_autoDemoCycleTimer); _autoDemoCycleTimer = null; }
    _hideDemoBadge();

    // If demo was cycling, reset to clean state so user starts fresh
    if (wasRunning && _autoDemoIndex > 0 && typeof gcClearAll === 'function') {
        gcClearAll();
    }
}

function _showDemoBadge() {
    var existing = document.getElementById('gc-demo-badge');
    if (existing) return;
    var badge = document.createElement('div');
    badge.id = 'gc-demo-badge';
    badge.textContent = 'Auto-Demo — click anywhere to start graphing';
    badge.style.cssText = 'position:absolute;top:8px;left:50%;transform:translateX(-50%);z-index:10;' +
        'background:rgba(37,99,235,0.9);color:#fff;padding:6px 16px;border-radius:20px;' +
        'font-size:13px;font-weight:500;pointer-events:none;opacity:0;transition:opacity 0.5s;';
    var graphDiv = document.getElementById('graph');
    if (graphDiv && graphDiv.parentElement) {
        graphDiv.parentElement.style.position = 'relative';
        graphDiv.parentElement.appendChild(badge);
        requestAnimationFrame(function() { badge.style.opacity = '1'; });
    }
}

function _hideDemoBadge() {
    var badge = document.getElementById('gc-demo-badge');
    if (badge) {
        badge.style.opacity = '0';
        setTimeout(function() { if (badge.parentElement) badge.parentElement.removeChild(badge); }, 500);
    }
}

/**
 * Toggle derivative display for an expression
 */
function toggleDerivative(id) {
    const checkbox = document.getElementById(`show-derivative-${id}`);
    const expr = engine.expressions.find(e => e.id === id);

    if (expr) {
        expr.showDerivative = checkbox.checked;
        updateGraph();
    }
}

/**
 * Toggle second derivative display
 */
function toggleSecondDerivative(id) {
    const checkbox = document.getElementById(`show-second-derivative-${id}`);
    const expr = engine.expressions.find(e => e.id === id);
    if (expr) {
        expr.showSecondDerivative = checkbox.checked;
        updateGraph();
    }
}

/**
 * Toggle critical points (local min/max) display
 */
function toggleCriticalPoints(id) {
    const checkbox = document.getElementById(`show-critical-points-${id}`);
    const expr = engine.expressions.find(e => e.id === id);
    if (expr) {
        expr.showCriticalPoints = checkbox.checked;
        updateGraph();
    }
}

/**
 * Toggle inflection points display
 */
function toggleInflectionPoints(id) {
    const checkbox = document.getElementById(`show-inflection-points-${id}`);
    const expr = engine.expressions.find(e => e.id === id);
    if (expr) {
        expr.showInflectionPoints = checkbox.checked;
        updateGraph();
    }
}

/**
 * Toggle roots (x-intercepts) display
 */
function toggleRoots(id) {
    const checkbox = document.getElementById(`show-roots-${id}`);
    const expr = engine.expressions.find(e => e.id === id);
    if (expr) {
        expr.showRoots = checkbox.checked;
        updateGraph();
    }
}

/**
 * Toggle vertical asymptotes display
 */
function toggleVerticalAsymptotes(id) {
    const checkbox = document.getElementById(`show-vasym-${id}`);
    const expr = engine.expressions.find(e => e.id === id);
    if (expr) {
        expr.showVerticalAsymptotes = checkbox.checked;
        updateGraph();
    }
}

/**
 * Toggle tangent line display — shows input for x-value
 */
function toggleTangentLine(id) {
    const checkbox = document.getElementById(`show-tangent-${id}`);
    const expr = engine.expressions.find(e => e.id === id);
    if (!expr) return;
    expr.showTangent = checkbox.checked;

    // Use the dedicated mount point
    const mount = document.getElementById(`tangent-controls-${id}`);
    if (checkbox.checked) {
        if (mount) {
            mount.innerHTML = `
                <div class="d-flex gap-2 align-items-center flex-wrap mt-1">
                    <small class="text-muted">Tangent at x =</small>
                    <input type="number" class="form-control form-control-sm" id="tangent-x-${id}"
                           value="${expr.tangentX != null ? expr.tangentX : 0}" step="0.5" style="width:80px;"
                           oninput="updateTangentX(${id})">
                    <small class="text-muted" id="tangent-info-${id}"></small>
                </div>`;
        }
        if (expr.tangentX == null) expr.tangentX = 0;
    } else {
        if (mount) mount.innerHTML = '';
        delete expr.tangentX;
    }
    updateGraph();
}

function updateTangentX(id) {
    const expr = engine.expressions.find(e => e.id === id);
    const input = document.getElementById(`tangent-x-${id}`);
    if (expr && input) {
        expr.tangentX = parseFloat(input.value) || 0;
        updateGraph();
    }
}

/**
 * Toggle integration display for an expression
 */
function toggleIntegration(id) {
    const checkbox = document.getElementById(`show-integration-${id}`);
    const controls = document.getElementById(`integration-controls-${id}`);
    const expr = engine.expressions.find(e => e.id === id);

    if (expr) {
        expr.showIntegration = checkbox.checked;

        if (checkbox.checked) {
            controls.style.display = 'block';
            // Initialize default bounds
            const a = parseFloat(document.getElementById(`integration-a-${id}`).value);
            const b = parseFloat(document.getElementById(`integration-b-${id}`).value);
            expr.integrationBounds = { a, b };
            // Show area value in numeric result panel
            _showIntegrationResult(id, expr.expression, a, b);
        } else {
            controls.style.display = 'none';
            // Clear integration result from numeric panel
            var resultEl = document.getElementById('numeric-result-' + id);
            if (resultEl) { resultEl.style.display = 'none'; resultEl.textContent = ''; }
        }

        updateGraph();
    }
}

/**
 * Update integration bounds
 */
function updateIntegrationBounds(id) {
    const a = parseFloat(document.getElementById(`integration-a-${id}`).value);
    const b = parseFloat(document.getElementById(`integration-b-${id}`).value);
    const expr = engine.expressions.find(e => e.id === id);

    if (expr && !isNaN(a) && !isNaN(b)) {
        expr.integrationBounds = { a, b };
        // Update area value in numeric result panel
        if (expr.showIntegration) {
            _showIntegrationResult(id, expr.expression, a, b);
        }
        updateGraph();
    }
}

/**
 * Update Riemann sum method for an expression
 */
function updateRiemannMethod(id) {
    const select = document.getElementById(`riemann-method-${id}`);
    const expr = engine.expressions.find(e => e.id === id);
    if (expr && select) {
        expr.riemannMethod = select.value;
        updateGraph();
    }
}

/**
 * Update Riemann sum subdivision count
 */
function updateRiemannN(id) {
    const input = document.getElementById(`riemann-n-${id}`);
    const expr = engine.expressions.find(e => e.id === id);
    if (expr && input) {
        const n = parseInt(input.value, 10);
        if (n > 0 && n <= 500) {
            expr.riemannN = n;
            updateGraph();
        }
    }
}

/**
 * Toggle antiderivative F(x) display for an expression
 */
function toggleAntiderivative(id) {
    const checkbox = document.getElementById(`show-antiderivative-${id}`);
    const expr = engine.expressions.find(e => e.id === id);

    if (expr) {
        expr.showAntiderivative = checkbox.checked;
        updateGraph();
    }
}

/**
 * Update limit expression parameters
 */
function updateLimitExpression(id) {
    const input = document.getElementById(`expr-${id}`);
    const valInput = document.getElementById(`limit-val-${id}`);
    const resultSpan = document.getElementById(`limit-result-${id}`);
    const expr = engine.expressions.find(e => e.id === id);

    if (!expr) return;

    // Read expression from MathQuill or plain input
    let limitExpr;
    const mq = _mqFields[id];
    if (mq && _mqInputMode[id] !== 'text') {
        limitExpr = latexToMathJS(mq.latex()).trim();
    } else if (input) {
        limitExpr = input.value.trim();
    } else {
        return;
    }
    const limitVal = valInput ? valInput.value.trim() : '0';

    expr.expression = limitExpr;
    expr.limitExpr = limitExpr;
    expr.limitVar = 'x';
    expr.limitVal = limitVal;

    // Evaluate limit and show result (Nerdamer first, then SymPy fallback)
    if (limitExpr) {
        let result = null;
        if (typeof nerdamer !== 'undefined') {
            result = engine.evaluateLimit(limitExpr, 'x', limitVal);
        }
        if (result && resultSpan) {
            resultSpan.textContent = result.symbolic + (result.numeric != null ? ' ≈ ' + result.numeric.toFixed(6) : '');
        } else if (resultSpan) {
            resultSpan.textContent = 'evaluating...';
            engine.evaluateLimitSymPy(limitExpr, 'x', limitVal).then(sympyResult => {
                if (sympyResult && resultSpan) {
                    resultSpan.textContent = sympyResult.symbolic + (sympyResult.numeric != null ? ' ≈ ' + sympyResult.numeric.toFixed(6) : '');
                    // Store for the plot
                    expr._sympyLimitResult = sympyResult;
                    expr._sympyLimitResolved = true;
                    updateGraph();
                } else if (resultSpan) {
                    resultSpan.textContent = '?';
                }
            });
        }
    }

    updateGraph();
}

/**
 * Load a limit sample (expression + approach value)
 */
function loadLimitSample(id, expression, value) {
    const valInput = document.getElementById(`limit-val-${id}`);
    if (valInput) valInput.value = value;
    // Set expression via MQ-aware loadSample, then trigger limit evaluation
    loadSample(id, expression);
    // Also update limit-specific state
    const expr = engine.expressions.find(e => e.id === id);
    if (expr) {
        expr.limitExpr = expression;
        expr.limitVar = 'x';
        expr.limitVal = value;
    }
    updateLimitExpression(id);
}

/**
 * Update piecewise function
 */
function updatePiecewise(id) {
    const pieces = [];
    let pieceIndex = 0;

    // Collect all pieces
    while (true) {
        const exprElem = document.getElementById(`piece-expr-${id}-${pieceIndex}`);
        const condElem = document.getElementById(`piece-cond-${id}-${pieceIndex}`);

        if (!exprElem || !condElem) break;

        const expression = exprElem.value.trim();
        const condition = condElem.value.trim();

        if (expression) {
            pieces.push({ expression, condition });
        }

        pieceIndex++;
    }

    const expr = engine.expressions.find(e => e.id === id);
    if (expr) {
        expr.pieces = pieces;
        expr.expression = `Piecewise (${pieces.length} pieces)`;
        updateGraph();
    }
}

/**
 * Add a new piece to piecewise function
 */
function addPiecewisePiece(id) {
    const container = document.getElementById(`piecewise-pieces-${id}`);

    // Count existing pieces
    let pieceCount = 0;
    while (document.getElementById(`piece-expr-${id}-${pieceCount}`)) {
        pieceCount++;
    }

    const newPiece = document.createElement('div');
    newPiece.className = 'mb-2 p-2';
    newPiece.style.cssText = 'background: #f8f9fa; border-radius: 4px;';
    newPiece.innerHTML = `
        <small class="text-muted"><strong>Piece ${pieceCount + 1}:</strong></small>
        <input type="text" class="form-control form-control-sm mb-1" id="piece-expr-${id}-${pieceCount}"
               placeholder="Expression" oninput="updatePiecewise(${id})">
        <input type="text" class="form-control form-control-sm" id="piece-cond-${id}-${pieceCount}"
               placeholder="Condition" oninput="updatePiecewise(${id})">
    `;

    container.appendChild(newPiece);
}

/**
 * Text-to-Graph: Convert text to equations that draw letters
 */
function textToGraph() {
    const text = prompt('Enter a word to graph (max 6 letters):\n\nSupported: A-Z\nBest results: MATH, CODE, LOVE, HI, YO');
    if (!text) return;

    const word = text.toUpperCase().replace(/[^A-Z]/g, '').substring(0, 6);

    if (word.length === 0) {
        alert('Please enter at least one letter (A-Z)');
        return;
    }

    // Clear existing expressions
    const confirmed = confirm(`This will replace current expressions with "${word}".\n\nContinue?`);
    if (!confirmed) return;

    engine.expressions = [];
    document.getElementById('expressions-list').innerHTML = '';
    expressionElements = {};

    // Generate letter equations
    const letterWidth = 3;
    const letterSpacing = 1;

    for (let i = 0; i < word.length; i++) {
        const letter = word[i];
        const offsetX = i * (letterWidth + letterSpacing);
        addLetterToGraph(letter, offsetX);
    }

    // Adjust view to fit text
    const totalWidth = word.length * (letterWidth + letterSpacing);
    document.getElementById('xMin').value = -2;
    document.getElementById('xMax').value = totalWidth + 2;
    document.getElementById('yMin').value = -1;
    document.getElementById('yMax').value = 8;

    updateGraph();
    alert(`"${word}" has been graphed!\n\nEach letter is made from mathematical equations.`);
}

/**
 * Add a letter to the graph using equations
 */
function addLetterToGraph(letter, offsetX = 0) {
    const x0 = offsetX;
    const w = 3; // width
    const mid = x0 + w/2; // middle x position

    switch (letter) {
        case 'A':
            // V shape
            addCartesian(`2*(x - ${x0})`, `x >= ${x0} and x <= ${mid}`);
            addCartesian(`${2*w} - 2*(x - ${x0})`, `x >= ${mid} and x <= ${x0 + w}`);
            // Crossbar
            addCartesian(`${3}`, `x >= ${x0 + w*0.3} and x <= ${x0 + w*0.7}`);
            break;

        case 'C':
            // Circle with gap (implicit)
            addImplicit(`(x - ${mid})^2 + (y - 3)^2 = 4`);
            break;

        case 'D':
            // Semicircle
            addCartesian(`sqrt(4 - (x - ${x0})^2) + 3`, `x >= ${x0} and x <= ${x0 + 2}`);
            addCartesian(`-sqrt(4 - (x - ${x0})^2) + 3`, `x >= ${x0} and x <= ${x0 + 2}`);
            break;

        case 'E':
            // Three horizontal lines at different heights
            addCartesian(`${6}`, `x >= ${x0} and x <= ${x0 + w}`);
            addCartesian(`${3}`, `x >= ${x0} and x <= ${x0 + w*0.8}`);
            addCartesian(`${0}`, `x >= ${x0} and x <= ${x0 + w}`);
            break;

        case 'H':
            // Two vertical lines with crossbar
            addCartesian(`${x0}`, `x >= ${x0 - 0.1} and x <= ${x0 + 0.1}`);
            addCartesian(`${x0 + w}`, `x >= ${x0 + w - 0.1} and x <= ${x0 + w + 0.1}`);
            addCartesian(`${3}`, `x >= ${x0} and x <= ${x0 + w}`);
            break;

        case 'I':
            // Single vertical line
            addCartesian(`${mid}`, `x >= ${mid - 0.1} and x <= ${mid + 0.1}`);
            break;

        case 'L':
            // L shape
            addCartesian(`${x0}`, `x >= ${x0 - 0.1} and x <= ${x0 + 0.1}`);
            addCartesian(`${0}`, `x >= ${x0} and x <= ${x0 + w}`);
            break;

        case 'M':
            // M shape with peaks
            addCartesian(`2*(x - ${x0})`, `x >= ${x0} and x <= ${x0 + w*0.25}`);
            addCartesian(`${w*0.5} - 2*(x - ${x0})`, `x >= ${x0 + w*0.25} and x <= ${mid}`);
            addCartesian(`2*(x - ${x0}) - ${w*0.5}`, `x >= ${mid} and x <= ${x0 + w*0.75}`);
            addCartesian(`${w*1.5} - 2*(x - ${x0})`, `x >= ${x0 + w*0.75} and x <= ${x0 + w}`);
            break;

        case 'N':
            // Diagonal line
            addCartesian(`2*(x - ${x0})`, `x >= ${x0} and x <= ${x0 + w}`);
            break;

        case 'O':
            // Circle
            addImplicit(`(x - ${mid})^2 + (y - 3)^2 = 4`);
            break;

        case 'T':
            // T shape
            addCartesian(`${6}`, `x >= ${x0} and x <= ${x0 + w}`);
            addCartesian(`${mid}`, `x >= ${mid - 0.1} and x <= ${mid + 0.1}`);
            break;

        case 'U':
            // Parabola
            addCartesian(`0.7*(x - ${mid})^2 + 1`, `x >= ${x0} and x <= ${x0 + w}`);
            break;

        case 'V':
            // V shape
            addCartesian(`${6} - 2*(x - ${x0})`, `x >= ${x0} and x <= ${mid}`);
            addCartesian(`2*(x - ${x0}) - ${w}`, `x >= ${mid} and x <= ${x0 + w}`);
            break;

        case 'W':
            // W shape
            addCartesian(`${6} - 2*(x - ${x0})`, `x >= ${x0} and x <= ${x0 + w*0.25}`);
            addCartesian(`2*(x - ${x0}) - ${w*0.5}`, `x >= ${x0 + w*0.25} and x <= ${mid}`);
            addCartesian(`${w*1.5} - 2*(x - ${x0})`, `x >= ${mid} and x <= ${x0 + w*0.75}`);
            addCartesian(`2*(x - ${x0}) - ${w}`, `x >= ${x0 + w*0.75} and x <= ${x0 + w}`);
            break;

        case 'X':
            // Two diagonals
            addCartesian(`2*(x - ${x0})`, `x >= ${x0} and x <= ${x0 + w}`);
            addCartesian(`${2*w} - 2*(x - ${x0})`, `x >= ${x0} and x <= ${x0 + w}`);
            break;

        case 'Y':
            // Y shape
            addCartesian(`${6} - 2*(x - ${x0})`, `x >= ${x0} and x <= ${mid}`);
            addCartesian(`2*(x - ${x0}) - ${w}`, `x >= ${mid} and x <= ${x0 + w}`);
            addCartesian(`${mid}`, `x >= ${mid - 0.1} and x <= ${mid + 0.1}`);
            break;

        case 'Z':
            // Z shape
            addCartesian(`${6}`, `x >= ${x0} and x <= ${x0 + w}`);
            addCartesian(`${2*w} - 2*(x - ${x0})`, `x >= ${x0} and x <= ${x0 + w}`);
            addCartesian(`${0}`, `x >= ${x0} and x <= ${x0 + w}`);
            break;

        default:
            // Space or unknown
            break;
    }
}

/**
 * Helper: Add a Cartesian expression with optional condition
 */
function addCartesian(expression, condition = null) {
    if (condition) {
        // Use piecewise for conditional expressions
        const expr = engine.addExpression(`Segment`, 'piecewise');
        expr.pieces = [{ expression, condition }];
        createExpressionElement(expr);

        // Update the type dropdown
        setTimeout(() => {
            const typeElem = document.getElementById(`type-${expr.id}`);
            if (typeElem) typeElem.value = 'piecewise';
            updateExpressionType(expr.id);
        }, 10);
    } else {
        const expr = engine.addExpression(expression, 'cartesian');
        createExpressionElement(expr);
        // Plain text fallback — MQ fields populated by _initMathQuillField via createExpressionElement
        if (!_mqFields[expr.id]) {
            const inputElement = document.getElementById(`expr-${expr.id}`);
            if (inputElement) inputElement.value = expression;
        }
    }
}

/**
 * Helper: Add an implicit function
 */
function addImplicit(expression) {
    const expr = engine.addExpression(expression, 'implicit');
    createExpressionElement(expr);

    setTimeout(() => {
        // Plain text fallback — MQ fields populated by _initMathQuillField
        if (!_mqFields[expr.id]) {
            const inputElement = document.getElementById(`expr-${expr.id}`);
            if (inputElement) inputElement.value = expression;
        }
        const typeElem = document.getElementById(`type-${expr.id}`);
        if (typeElem) typeElem.value = 'implicit';
        updateExpressionType(expr.id);
    }, 10);
}

/**
 * Load piecewise sample functions
 */
function loadPiecewiseSample(id, type) {
    const container = document.getElementById(`piecewise-pieces-${id}`);

    switch (type) {
        case 'abs':
            // Absolute value function
            document.getElementById(`piece-expr-${id}-0`).value = '-x';
            document.getElementById(`piece-cond-${id}-0`).value = 'x < 0';
            document.getElementById(`piece-expr-${id}-1`).value = 'x';
            document.getElementById(`piece-cond-${id}-1`).value = 'x >= 0';
            break;

        case 'step':
            // Step function
            document.getElementById(`piece-expr-${id}-0`).value = '-1';
            document.getElementById(`piece-cond-${id}-0`).value = 'x < 0';
            document.getElementById(`piece-expr-${id}-1`).value = '1';
            document.getElementById(`piece-cond-${id}-1`).value = 'x >= 0';
            break;

        case 'sawtooth':
            // Sawtooth wave
            document.getElementById(`piece-expr-${id}-0`).value = 'x % 2';
            document.getElementById(`piece-cond-${id}-0`).value = 'x >= 0';
            document.getElementById(`piece-expr-${id}-1`).value = '-((-x) % 2)';
            document.getElementById(`piece-cond-${id}-1`).value = 'x < 0';
            break;
    }

    updatePiecewise(id);
}

/**
 * Find and display intersection points
 */
function findIntersections() {
    const cartesianExprs = engine.expressions.filter(e => e.type === 'cartesian' && e.expression && e.visible);

    if (cartesianExprs.length < 2) {
        alert('Please add at least 2 Cartesian expressions to find intersections.');
        return;
    }

    const xMin = parseFloat(document.getElementById('xMin').value);
    const xMax = parseFloat(document.getElementById('xMax').value);

    console.log('Finding intersections between', cartesianExprs.length, 'functions...');

    // Find intersections between all pairs
    for (let i = 0; i < cartesianExprs.length; i++) {
        for (let j = i + 1; j < cartesianExprs.length; j++) {
            const intersections = engine.findIntersections(
                cartesianExprs[i].expression,
                cartesianExprs[j].expression,
                xMin,
                xMax
            );

            if (intersections.length > 0) {
                console.log(`Intersections between "${cartesianExprs[i].expression}" and "${cartesianExprs[j].expression}":`, intersections);

                // Store intersections for display
                if (!cartesianExprs[i].intersections) {
                    cartesianExprs[i].intersections = [];
                }
                cartesianExprs[i].intersections.push(...intersections);
            }
        }
    }

    updateGraph();
}

/**
 * Compute and display area between two curves
 */
function areaBetweenCurves() {
    const cartExprs = engine.expressions.filter(e => e.type === 'cartesian' && e.expression && e.visible);
    if (cartExprs.length < 2) {
        alert('Need at least 2 visible Cartesian expressions to compute area between curves.');
        return;
    }

    // Use first two cartesian expressions
    const e1 = cartExprs[0], e2 = cartExprs[1];
    const xMin = parseFloat(document.getElementById('xMin').value);
    const xMax = parseFloat(document.getElementById('xMax').value);

    // Ask user for bounds (default to current x range)
    const boundsStr = prompt(`Area between: "${e1.expression}" and "${e2.expression}"\n\nEnter bounds (a, b):`, `${xMin}, ${xMax}`);
    if (!boundsStr) return;
    const [aStr, bStr] = boundsStr.split(',').map(s => s.trim());
    const a = parseFloat(aStr), b = parseFloat(bStr);
    if (isNaN(a) || isNaN(b) || a >= b) { alert('Invalid bounds.'); return; }

    const result = engine.areaBetweenCurves(e1.expression, e2.expression, a, b);
    if (!result) { alert('Could not compute area between curves.'); return; }

    // Store shading on the first expression for rendering
    e1._areaBetween = {
        shadeX: result.shadeX,
        shadeY: result.shadeY,
        area: result.area,
        otherExpr: e2.expression,
        a, b
    };

    updateGraph();
    alert(`Area between curves from x=${a} to x=${b}:\n≈ ${result.area.toFixed(6)}`);
}

/**
 * Show/hide table of values panel for the first cartesian expression
 */
// Track which expression the table is showing (for auto-refresh)
var _tableExprId = null;

/**
 * Toggle table for a specific expression (from the per-expression checkbox).
 */
function toggleTableForExpr(id) {
    const checkbox = document.getElementById(`show-table-${id}`);
    const isOn = checkbox && checkbox.checked;

    if (isOn) {
        const exprObj = engine.expressions.find(e => e.id === id);
        if (!exprObj || !exprObj.expression) return;
        _tableExprId = id;
        _renderTableForExpr(exprObj);
    } else {
        _closeTable();
    }
}

/**
 * Toggle table from the sidebar button (picks expression automatically or prompts).
 */
function toggleTableOfValues() {
    let panel = document.getElementById('gc-table-panel');
    if (panel && panel.style.display !== 'none') {
        _closeTable();
        return;
    }

    // Find all visible expressions that can produce a table
    const tableable = engine.expressions.filter(e =>
        e.expression && e.visible &&
        ['cartesian', 'equation', 'implicit', 'polar', 'parametric'].includes(e.type)
    );
    if (tableable.length === 0) {
        alert('No visible expression to generate a table.');
        return;
    }

    // If multiple expressions, let user pick
    let chosen;
    if (tableable.length === 1) {
        chosen = tableable[0];
    } else {
        const options = tableable.map((e, i) => `${i + 1}. ${e.expression} (${e.type})`).join('\n');
        const pick = prompt('Choose expression:\n' + options, '1');
        if (!pick) return;
        const idx = parseInt(pick, 10) - 1;
        if (idx < 0 || idx >= tableable.length) return;
        chosen = tableable[idx];
    }

    _tableExprId = chosen.id;
    // Sync checkbox
    const cb = document.getElementById(`show-table-${chosen.id}`);
    if (cb) cb.checked = true;
    _renderTableForExpr(chosen);
}

/**
 * Render an editable Desmos-style table for a given expression.
 * User can type custom x-values; y is auto-computed. Points appear as dots on the graph.
 */
function _renderTableForExpr(exprObj) {
    if (!exprObj || !exprObj.expression) return;

    // Initialize custom x-values array on the expression if not present
    if (!exprObj._tableXValues) {
        // Seed with some default values from the current range
        const xMin = parseFloat(document.getElementById('xMin').value) || -10;
        const xMax = parseFloat(document.getElementById('xMax').value) || 10;
        const step = (xMax - xMin) / 10;
        exprObj._tableXValues = [];
        for (let i = 0; i <= 10; i++) {
            exprObj._tableXValues.push(+(xMin + i * step).toFixed(2));
        }
    }

    let panel = document.getElementById('gc-table-panel');
    if (!panel) {
        panel = document.createElement('div');
        panel.id = 'gc-table-panel';
        const graphCard = document.querySelector('.gc-graph-card');
        if (graphCard) graphCard.parentElement.appendChild(panel);
        else {
            const col = document.querySelector('.tool-output-column');
            if (col) col.appendChild(panel);
            else document.body.appendChild(panel);
        }
    }

    const dark = !!(window.GC_DARK);
    const borderColor = dark ? '#2d3a4d' : '#e5e7eb';
    const headerBg = dark ? '#1a2436' : '#f3f4f6';
    const accentColor = dark ? '#a78bfa' : '#7c3aed';
    const textColor = dark ? '#e5e7eb' : '#111827';
    const inputBg = dark ? '#1e293b' : '#fff';
    const rowBgEven = dark ? '#111827' : '#fafafa';
    const rowBgOdd = dark ? '#151d2b' : '#fff';

    panel.style.cssText = `
        margin-top:0.5rem; max-height:350px; overflow-y:auto;
        border:1px solid ${borderColor};
        border-radius:8px; background:${dark ? '#151d2b' : '#fff'};
        font-size:0.8125rem;
    `;

    // Compute y-values for each x
    const computedRows = _computeTableRows(exprObj);

    // Determine columns dynamically from computed data
    const allCols = computedRows.length > 0 ? Object.keys(computedRows[0]) : ['x', 'y'];
    const colLabels = { x: 'x', y: 'f(x)', y1: 'y₁', y2: 'y₂', y3: 'y₃', y4: 'y₄', t: 't', theta: 'θ', r: 'r' };
    // The first column is the editable input (x, t, or theta)
    const inputCol = allCols[0];
    const outputCols = allCols.slice(1);

    const thStyle = `padding:0.375rem 0.5rem;text-align:center;border-bottom:2px solid ${borderColor};color:${accentColor};font-weight:600;`;
    const inputStyle = `width:100%;border:none;background:transparent;text-align:right;font-family:monospace;font-size:0.8125rem;color:${textColor};outline:none;padding:0.25rem 0.375rem;`;

    const inputPlaceholder = colLabels[inputCol] || inputCol;
    let html = `<table style="width:100%;border-collapse:collapse;">
        <thead><tr style="position:sticky;top:0;background:${headerBg};z-index:1;">
            <th style="${thStyle}width:35%;">${colLabels[inputCol] || inputCol}</th>`;
    for (const col of outputCols) {
        html += `<th style="${thStyle}">${colLabels[col] || col}</th>`;
    }
    html += `<th style="${thStyle}width:28px;"></th></tr></thead><tbody>`;

    computedRows.forEach((r, i) => {
        const bg = i % 2 === 0 ? rowBgEven : rowBgOdd;
        const inputVal = r[inputCol];
        html += `<tr style="background:${bg};">`;
        // Editable input cell (x, t, or theta)
        html += `<td style="padding:0;border-bottom:1px solid ${borderColor};">
            <input type="text" value="${inputVal !== '' && inputVal != null ? inputVal : ''}"
                   style="${inputStyle}"
                   placeholder="${inputPlaceholder}"
                   data-row="${i}"
                   onfocus="this.select()"
                   oninput="_tableXInput(${exprObj.id}, ${i}, this.value)"
                   onkeydown="_tableKeyDown(event, ${exprObj.id}, ${i})">
        </td>`;
        // Computed output cells (read-only)
        for (const col of outputCols) {
            const val = r[col];
            const isUndef = val === 'undef' || val === '';
            const color = isUndef ? '#ef4444' : textColor;
            html += `<td style="padding:0.25rem 0.375rem;text-align:right;font-family:monospace;color:${color};border-bottom:1px solid ${borderColor};">${val != null && val !== '' ? val : ''}</td>`;
        }
        // Delete button
        html += `<td style="padding:0;text-align:center;border-bottom:1px solid ${borderColor};">
            <button onclick="_tableDeleteRow(${exprObj.id}, ${i})" title="Remove row"
                    style="background:none;border:none;cursor:pointer;color:#9ca3af;font-size:0.75rem;padding:0 2px;">&times;</button>
        </td>`;
        html += `</tr>`;
    });

    // Empty row at bottom for adding new values (like Desmos)
    const newIdx = computedRows.length;
    const emptyBg = newIdx % 2 === 0 ? rowBgEven : rowBgOdd;
    html += `<tr style="background:${emptyBg};">
        <td style="padding:0;border-bottom:1px solid ${borderColor};">
            <input type="text" value="" style="${inputStyle}" placeholder="add ${inputPlaceholder}..."
                   data-row="${newIdx}"
                   oninput="_tableXInput(${exprObj.id}, ${newIdx}, this.value)"
                   onkeydown="_tableKeyDown(event, ${exprObj.id}, ${newIdx})">
        </td>`;
    for (const col of outputCols) {
        html += `<td style="padding:0.25rem 0.375rem;text-align:right;font-family:monospace;color:#9ca3af;border-bottom:1px solid ${borderColor};"></td>`;
    }
    html += `<td style="border-bottom:1px solid ${borderColor};"></td></tr>`;

    html += `</tbody></table>`;

    const typeLabel = exprObj.type !== 'cartesian' ? ` (${exprObj.type})` : '';
    const pointCount = computedRows.filter(r => {
        const firstKey = Object.keys(r)[0];
        if (r[firstKey] === '' || r[firstKey] === null) return false;
        const yKeys = Object.keys(r).filter(k => k.startsWith('y') || k === 'r');
        return yKeys.some(k => r[k] !== 'undef' && r[k] !== '');
    }).length;
    panel.innerHTML = `<div style="display:flex;justify-content:space-between;align-items:center;padding:0.375rem 0.75rem;border-bottom:2px solid ${borderColor};background:${headerBg};border-radius:8px 8px 0 0;">
        <strong style="font-size:0.8125rem;color:${accentColor};">Table: ${exprObj.expression}${typeLabel}</strong>
        <div style="display:flex;gap:0.25rem;align-items:center;">
            <span style="font-size:0.7rem;color:#9ca3af;">${pointCount} pts</span>
            <button onclick="_tableAutoFill(${exprObj.id})" title="Auto-fill with even spacing" style="background:none;border:none;cursor:pointer;color:${dark ? '#9ca3af' : '#6b7280'};font-size:0.8rem;">⟳</button>
            <button onclick="_tableAddRow(${exprObj.id})" title="Add row" style="background:none;border:none;cursor:pointer;color:${dark ? '#9ca3af' : '#6b7280'};font-size:1rem;">+</button>
            <button onclick="_closeTable()" title="Close" style="background:none;border:none;cursor:pointer;color:${dark ? '#9ca3af' : '#6b7280'};font-size:1rem;">&times;</button>
        </div>
    </div>` + html;
    panel.style.display = 'block';

    // Update table points on the graph
    _updateTablePoints(exprObj);
}

/**
 * Compute y-values for each x in the expression's _tableXValues.
 */
function _computeTableRows(exprObj) {
    const xValues = exprObj._tableXValues || [];
    const rows = [];

    // Prepare the expression with parameter substitution
    let substituted = engine.normalizeExpression(exprObj.expression);
    if (exprObj.parameters) {
        Object.keys(exprObj.parameters).forEach(param => {
            const re = new RegExp(`\\b${param}\\b`, 'g');
            substituted = substituted.replace(re, String(exprObj.parameters[param]));
        });
    }
    const { expr: cleanExpr, restriction } = engine.parseDomainRestriction(substituted);

    if (exprObj.type === 'polar') {
        // Polar: values are theta → r, x, y
        const stripped = cleanExpr.replace(/^\s*r\s*=\s*/i, '');
        let compiled;
        try { compiled = engine._compile(engine.normalizeExpression(stripped)); } catch(_) { return rows; }
        for (const tv of xValues) {
            if (tv === '' || tv === null || tv === undefined || isNaN(tv)) { rows.push({ theta: '', r: '', x: '', y: '' }); continue; }
            const theta = parseFloat(tv);
            try {
                const r = compiled.evaluate({ theta });
                if (typeof r === 'number' && isFinite(r)) {
                    rows.push({ theta: tv, r: +r.toFixed(4), x: +(r * Math.cos(theta)).toFixed(4), y: +(r * Math.sin(theta)).toFixed(4) });
                } else {
                    rows.push({ theta: tv, r: 'undef', x: 'undef', y: 'undef' });
                }
            } catch (_) { rows.push({ theta: tv, r: 'undef', x: 'undef', y: 'undef' }); }
        }
        return rows;
    }

    if (exprObj.type === 'parametric') {
        // Parametric: values are t → x(t), y(t)
        const parts = cleanExpr.split(',').map(s => s.trim());
        if (parts.length < 2) return rows;
        let cx, cy;
        try { cx = engine._compile(engine.normalizeExpression(parts[0])); } catch(_) { return rows; }
        try { cy = engine._compile(engine.normalizeExpression(parts[1])); } catch(_) { return rows; }
        for (const tv of xValues) {
            if (tv === '' || tv === null || tv === undefined || isNaN(tv)) { rows.push({ t: '', x: '', y: '' }); continue; }
            const t = parseFloat(tv);
            try {
                const xv = cx.evaluate({ t });
                const yv = cy.evaluate({ t });
                rows.push({
                    t: tv,
                    x: (typeof xv === 'number' && isFinite(xv)) ? +xv.toFixed(4) : 'undef',
                    y: (typeof yv === 'number' && isFinite(yv)) ? +yv.toFixed(4) : 'undef'
                });
            } catch (_) { rows.push({ t: tv, x: 'undef', y: 'undef' }); }
        }
        return rows;
    }

    if ((exprObj.type === 'equation' || exprObj.type === 'implicit') && typeof nerdamer !== 'undefined' && cleanExpr.includes('=')) {
        // Equation: solve for y branches
        try {
            const parts = cleanExpr.split('=');
            const eqExpr = '(' + parts[0].trim() + ')-(' + parts[1].trim() + ')';
            const ySolved = nerdamer.solve(eqExpr, 'y');
            const yText = ySolved.text().replace(/^\[|\]$/g, '');
            const yExprs = yText ? yText.split(',').map(s => s.trim()).filter(Boolean) : [];
            const compiled = yExprs.map(ye => { try { return math.compile(engine.normalizeExpression(ye)); } catch(_) { return null; } });

            for (const xv of xValues) {
                if (xv === '' || xv === null || xv === undefined || isNaN(xv)) { rows.push({ x: '' }); continue; }
                const row = { x: xv };
                compiled.forEach((c, bi) => {
                    const key = compiled.length === 1 ? 'y' : `y${bi + 1}`;
                    if (!c) { row[key] = 'undef'; return; }
                    try {
                        const v = c.evaluate({ x: parseFloat(xv) });
                        row[key] = (typeof v === 'number' && isFinite(v)) ? +v.toFixed(4) : 'undef';
                    } catch (_) { row[key] = 'undef'; }
                });
                rows.push(row);
            }
            return rows;
        } catch (_) { /* fall through to cartesian */ }
    }

    // Cartesian: y = f(x)
    const stripped = engine.stripCartesianPrefix(cleanExpr);
    let compiled;
    try { compiled = engine._compile(engine.normalizeExpression(stripped)); } catch(_) { return rows; }

    for (const xv of xValues) {
        if (xv === '' || xv === null || xv === undefined || isNaN(xv)) { rows.push({ x: '', y: '' }); continue; }
        const x = parseFloat(xv);
        if (restriction && !engine.evaluateDomainRestriction(restriction, x)) {
            rows.push({ x: xv, y: 'undef' });
            continue;
        }
        try {
            const y = compiled.evaluate({ x });
            rows.push({ x: xv, y: (typeof y === 'number' && isFinite(y)) ? +y.toFixed(4) : 'undef' });
        } catch (_) {
            rows.push({ x: xv, y: 'undef' });
        }
    }
    return rows;
}

/**
 * Handle x-value input in the table.
 */
function _tableXInput(exprId, rowIdx, value) {
    const exprObj = engine.expressions.find(e => e.id === exprId);
    if (!exprObj) return;
    if (!exprObj._tableXValues) exprObj._tableXValues = [];

    const num = value.trim() === '' ? '' : parseFloat(value);
    if (rowIdx >= exprObj._tableXValues.length) {
        // Adding to the empty row at bottom
        if (value.trim() !== '' && !isNaN(num)) {
            exprObj._tableXValues.push(num);
            _renderTableForExpr(exprObj);
            // Focus the next empty row
            setTimeout(() => {
                const inputs = document.querySelectorAll('#gc-table-panel input[data-row]');
                const last = inputs[inputs.length - 1];
                if (last) last.focus();
            }, 50);
        }
    } else {
        if (value.trim() === '') {
            exprObj._tableXValues[rowIdx] = '';
        } else if (!isNaN(num)) {
            exprObj._tableXValues[rowIdx] = num;
        }
        // Debounce: recompute after a short pause
        clearTimeout(exprObj._tableDebounce);
        exprObj._tableDebounce = setTimeout(() => {
            _renderTableForExpr(exprObj);
            // Restore focus
            const input = document.querySelector(`#gc-table-panel input[data-row="${rowIdx}"]`);
            if (input) { input.focus(); input.selectionStart = input.selectionEnd = input.value.length; }
        }, 300);
    }
}

/**
 * Handle keyboard navigation in the table (Enter → next row, Tab → next col).
 */
function _tableKeyDown(event, exprId, rowIdx) {
    if (event.key === 'Enter') {
        event.preventDefault();
        const exprObj = engine.expressions.find(e => e.id === exprId);
        if (!exprObj) return;
        // Move to next row
        const nextInput = document.querySelector(`#gc-table-panel input[data-row="${rowIdx + 1}"]`);
        if (nextInput) nextInput.focus();
    }
}

/**
 * Delete a row from the table.
 */
function _tableDeleteRow(exprId, rowIdx) {
    const exprObj = engine.expressions.find(e => e.id === exprId);
    if (!exprObj || !exprObj._tableXValues) return;
    exprObj._tableXValues.splice(rowIdx, 1);
    _renderTableForExpr(exprObj);
}

/**
 * Add an empty row at the end.
 */
function _tableAddRow(exprId) {
    const exprObj = engine.expressions.find(e => e.id === exprId);
    if (!exprObj) return;
    if (!exprObj._tableXValues) exprObj._tableXValues = [];
    // Add next logical value (increment from last)
    const last = exprObj._tableXValues.filter(v => v !== '' && !isNaN(v));
    let next;
    if (last.length >= 2) {
        next = +(last[last.length - 1] + (last[last.length - 1] - last[last.length - 2])).toFixed(2);
    } else if (last.length === 1) {
        next = +(last[0] + 1).toFixed(2);
    } else {
        const xMin = parseFloat(document.getElementById('xMin').value) || -10;
        next = xMin;
    }
    exprObj._tableXValues.push(next);
    _renderTableForExpr(exprObj);
    // Focus the new row
    setTimeout(() => {
        const idx = exprObj._tableXValues.length - 1;
        const input = document.querySelector(`#gc-table-panel input[data-row="${idx}"]`);
        if (input) { input.focus(); input.select(); }
    }, 50);
}

/**
 * Auto-fill the table with evenly-spaced x values from the current range.
 */
function _tableAutoFill(exprId) {
    const exprObj = engine.expressions.find(e => e.id === exprId);
    if (!exprObj) return;
    const xMin = parseFloat(document.getElementById('xMin').value) || -10;
    const xMax = parseFloat(document.getElementById('xMax').value) || 10;
    const step = (xMax - xMin) / 10;
    exprObj._tableXValues = [];
    for (let i = 0; i <= 10; i++) {
        exprObj._tableXValues.push(+(xMin + i * step).toFixed(2));
    }
    _renderTableForExpr(exprObj);
}

/**
 * Close the table panel.
 */
function _closeTable() {
    const panel = document.getElementById('gc-table-panel');
    if (panel) panel.style.display = 'none';
    // Uncheck checkbox and clear table points from graph
    if (_tableExprId) {
        const cb = document.getElementById(`show-table-${_tableExprId}`);
        if (cb) cb.checked = false;
        const exprObj = engine.expressions.find(e => e.id === _tableExprId);
        if (exprObj) {
            delete exprObj._tablePoints;
            updateGraph();
        }
    }
    _tableExprId = null;
}

/**
 * Update the table points scatter trace on the graph.
 * Stores points on exprObj._tablePoints for createTrace to render.
 */
function _updateTablePoints(exprObj) {
    if (!exprObj) return;
    if (!exprObj._tableXValues) {
        delete exprObj._tablePoints;
        return;
    }
    const rows = _computeTableRows(exprObj);
    const points = { x: [], y: [] };
    for (const r of rows) {
        // All row types have an 'x' key (cartesian, equation, polar, parametric)
        // For polar/parametric, x and y are the Cartesian coordinates
        const xv = r.x;
        const yv = r.y;
        if (xv === '' || xv === null || xv === undefined || xv === 'undef') continue;
        // For equations with branches (y1, y2, ...), plot all y-values at this x
        const yKeys = Object.keys(r).filter(k => k === 'y' || /^y\d+$/.test(k));
        if (yKeys.length > 0) {
            for (const yk of yKeys) {
                const val = r[yk];
                if (val !== 'undef' && val !== '' && val != null && !isNaN(val)) {
                    points.x.push(parseFloat(xv));
                    points.y.push(parseFloat(val));
                }
            }
        }
    }
    exprObj._tablePoints = points.x.length > 0 ? points : null;
    // Only trigger graph update if not already in a refresh cycle
    if (!_tableRefreshing) updateGraph();
}

/**
 * Refresh the table if it's currently visible (called from updateGraph).
 */
var _tableRefreshing = false;
function _refreshTable() {
    if (!_tableExprId || _tableRefreshing) return;
    const panel = document.getElementById('gc-table-panel');
    if (!panel || panel.style.display === 'none') return;
    const exprObj = engine.expressions.find(e => e.id === _tableExprId);
    if (!exprObj || !exprObj.expression || !exprObj.visible) {
        panel.style.display = 'none';
        const cb = document.getElementById(`show-table-${_tableExprId}`);
        if (cb) cb.checked = false;
        _tableExprId = null;
        return;
    }
    _tableRefreshing = true;
    try {
        _renderTableForExpr(exprObj);
    } finally {
        _tableRefreshing = false;
    }
}

/**
 * Detect parameters in expression (like a, b, c) and create sliders
 */
function detectAndCreateSliders(id, expression) {
    const slidersContainer = document.getElementById(`sliders-container-${id}`);

    if (!slidersContainer || !expression) {
        return;
    }

    // Find parameters (single letters except x, y, t, e, pi)
    // Normalize first so implicit multiplication is explicit (4ax → 4*a*x)
    // This ensures \b word boundaries work correctly for parameter detection
    const normalizedForDetect = engine.normalizeExpression(expression) || expression;
    const params = new Set();
    const regex = /\b([a-df-zA-Z])\b/g;
    let match;

    while ((match = regex.exec(normalizedForDetect)) !== null) {
        const param = match[1];
        // Exclude common variables, constants, and global scope variables
        if (param !== 'x' && param !== 'y' && param !== 't' && param !== 'e' && param !== 'pi'
            && !(engine.globalScope && param in engine.globalScope)) {
            params.add(param);
        }
    }

    if (params.size === 0) {
        slidersContainer.innerHTML = '';
        return;
    }

    // Create sliders for each parameter
    let slidersHTML = '<div class="mt-2"><small class="text-muted">Parameters:</small></div>';

    params.forEach(param => {
        // Restore previous range settings if they exist
        const exprObj = engine.expressions.find(e => e.id === id);
        const prevRange = exprObj && exprObj._sliderRanges && exprObj._sliderRanges[param];
        const sMin = prevRange ? prevRange.min : -10;
        const sMax = prevRange ? prevRange.max : 10;
        const sStep = prevRange ? prevRange.step : 0.1;
        const sVal = (exprObj && exprObj.parameters && exprObj.parameters[param] != null) ? exprObj.parameters[param] : 1;
        slidersHTML += `
            <div class="mb-2">
                <div class="d-flex align-items-center gap-1">
                    <label class="form-label mb-0" style="font-size: 12px;">
                        ${param} = <span id="param-value-${param}-${id}">${parseFloat(sVal).toFixed(1)}</span>
                    </label>
                    <button class="btn btn-sm" style="font-size:9px;padding:0 3px;color:#888;" onclick="toggleSliderRange(${id},'${param}')" title="Customize range">⚙</button>
                </div>
                <input type="range" class="form-range" id="param-${param}-${id}"
                       min="${sMin}" max="${sMax}" step="${sStep}" value="${sVal}"
                       aria-label="Parameter ${param} slider"
                       oninput="updateParameter(${id}, '${param}', this.value)">
                <div id="slider-range-${param}-${id}" style="display:none;" class="d-flex gap-1 align-items-center mt-1">
                    <input type="number" class="form-control form-control-sm" style="width:55px;font-size:10px;" value="${sMin}" id="slider-min-${param}-${id}" onchange="updateSliderRange(${id},'${param}')" placeholder="min">
                    <span style="font-size:10px;">to</span>
                    <input type="number" class="form-control form-control-sm" style="width:55px;font-size:10px;" value="${sMax}" id="slider-max-${param}-${id}" onchange="updateSliderRange(${id},'${param}')" placeholder="max">
                    <span style="font-size:10px;">step</span>
                    <input type="number" class="form-control form-control-sm" style="width:55px;font-size:10px;" value="${sStep}" id="slider-step-${param}-${id}" onchange="updateSliderRange(${id},'${param}')" placeholder="step" min="0.001" step="0.01">
                </div>
            </div>
        `;
    });

    slidersContainer.innerHTML = slidersHTML;

    // Initialize parameter values in expression
    const expr = engine.expressions.find(e => e.id === id);
    if (expr) {
        if (!expr.parameters) {
            expr.parameters = {};
        }
        params.forEach(param => {
            if (!(param in expr.parameters)) {
                expr.parameters[param] = 1;
            }
        });
    }

    // Add animation controls for first parameter
    if (params.size > 0) {
        const firstParam = Array.from(params)[0];
        slidersHTML = `
            <div class="mt-3 p-2" style="background: #f0f0f0; border-radius: 4px;">
                <small class="text-muted"><strong>Animation Controls</strong></small>
                <div class="d-flex gap-2 mt-2">
                    <button class="btn btn-sm btn-primary" onclick="toggleAnimation(${id}, '${firstParam}')">
                        <i class="fas fa-play" id="anim-icon-${id}-${firstParam}"></i>
                    </button>
                    <select class="form-select form-select-sm" id="anim-speed-${id}-${firstParam}" style="width: auto;">
                        <option value="0.05">Slow</option>
                        <option value="0.1" selected>Normal</option>
                        <option value="0.2">Fast</option>
                    </select>
                    <span class="align-self-center" style="font-size: 11px;">Param: ${firstParam}</span>
                </div>
            </div>
        `;
        slidersContainer.innerHTML += slidersHTML;
    }
}

/**
 * Update parameter value from slider
 */
function updateParameter(id, param, value) {
    const valueSpan = document.getElementById(`param-value-${param}-${id}`);
    if (valueSpan) {
        valueSpan.textContent = parseFloat(value).toFixed(1);
    }

    const expr = engine.expressions.find(e => e.id === id);
    if (expr) {
        if (!expr.parameters) {
            expr.parameters = {};
        }
        expr.parameters[param] = parseFloat(value);
        updateGraph();
    }
}

/**
 * Toggle animation for a parameter
 */
function toggleAnimation(id, param) {
    const icon = document.getElementById(`anim-icon-${id}-${param}`);
    const speedSelect = document.getElementById(`anim-speed-${id}-${param}`);

    if (animationState.isPlaying && animationState.exprId === id && animationState.paramName === param) {
        // Stop animation
        stopAnimation();
        icon.className = 'fas fa-play';
    } else {
        // Stop any existing animation
        if (animationState.isPlaying) {
            stopAnimation();
            // Reset previous icon
            const prevIcon = document.getElementById(`anim-icon-${animationState.exprId}-${animationState.paramName}`);
            if (prevIcon) prevIcon.className = 'fas fa-play';
        }

        // Start new animation
        animationState.isPlaying = true;
        animationState.exprId = id;
        animationState.paramName = param;
        const startSlider = document.getElementById(`param-${param}-${id}`);
        animationState.currentValue = startSlider ? parseFloat(startSlider.min) : -10;
        animationState.speed = parseFloat(speedSelect.value);
        icon.className = 'fas fa-pause';

        animate();
    }
}

/**
 * Animation loop
 */
function animate() {
    if (!animationState.isPlaying) return;

    const { exprId, paramName, speed } = animationState;

    // Stop if expression was deleted
    if (!engine.expressions.find(e => e.id === exprId)) {
        stopAnimation();
        return;
    }

    // Update parameter value
    animationState.currentValue += speed;

    // Loop back to start using slider range
    const animSlider = document.getElementById(`param-${paramName}-${exprId}`);
    const animMin = animSlider ? parseFloat(animSlider.min) : -10;
    const animMax = animSlider ? parseFloat(animSlider.max) : 10;
    if (animationState.currentValue > animMax) {
        animationState.currentValue = animMin;
    }

    // Update slider and parameter
    const slider = document.getElementById(`param-${paramName}-${exprId}`);
    if (slider) {
        slider.value = animationState.currentValue;
        updateParameter(exprId, paramName, animationState.currentValue);
    }

    // Continue animation
    animationState.animationId = requestAnimationFrame(animate);
}

/**
 * Stop animation
 */
function stopAnimation() {
    animationState.isPlaying = false;
    if (animationState.animationId) {
        cancelAnimationFrame(animationState.animationId);
        animationState.animationId = null;
    }
}

/**
 * Toggle slider range editor visibility
 */
function toggleSliderRange(id, param) {
    const rangeDiv = document.getElementById(`slider-range-${param}-${id}`);
    if (rangeDiv) rangeDiv.style.display = rangeDiv.style.display === 'none' ? 'flex' : 'none';
}

/**
 * Update slider min/max/step from range inputs
 */
function updateSliderRange(id, param) {
    const minEl = document.getElementById(`slider-min-${param}-${id}`);
    const maxEl = document.getElementById(`slider-max-${param}-${id}`);
    const stepEl = document.getElementById(`slider-step-${param}-${id}`);
    const slider = document.getElementById(`param-${param}-${id}`);
    if (!minEl || !maxEl || !stepEl || !slider) return;

    const sMin = parseFloat(minEl.value) || -10;
    const sMax = parseFloat(maxEl.value) || 10;
    const sStep = parseFloat(stepEl.value) || 0.1;

    slider.min = sMin;
    slider.max = sMax;
    slider.step = sStep;

    // Clamp current value to new range
    let val = parseFloat(slider.value);
    if (val < sMin) val = sMin;
    if (val > sMax) val = sMax;
    slider.value = val;
    updateParameter(id, param, val);

    // Persist range on expression object
    const expr = engine.expressions.find(e => e.id === id);
    if (expr) {
        if (!expr._sliderRanges) expr._sliderRanges = {};
        expr._sliderRanges[param] = { min: sMin, max: sMax, step: sStep };
    }
}

/**
 * Copy expression as LaTeX to clipboard
 */
function copyAsLaTeX(id) {
    const expr = engine.expressions.find(e => e.id === id);
    if (!expr || !expr.expression) return;

    const latex = expressionToLaTeX(expr.expression);

    function showFeedback(success) {
        const btn = document.querySelector(`[onclick="copyAsLaTeX(${id})"]`);
        if (btn) {
            const orig = btn.textContent;
            btn.textContent = success ? '✓' : '✗';
            setTimeout(() => { btn.textContent = orig; }, 1500);
        }
    }

    function fallbackCopy() {
        try {
            const ta = document.createElement('textarea');
            ta.value = latex;
            ta.style.position = 'fixed';
            ta.style.opacity = '0';
            document.body.appendChild(ta);
            ta.select();
            document.execCommand('copy');
            document.body.removeChild(ta);
            showFeedback(true);
        } catch (_) {
            showFeedback(false);
        }
    }

    if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(latex)
            .then(() => showFeedback(true))
            .catch(() => fallbackCopy());
    } else {
        fallbackCopy();
    }
}

/**
 * Convert expression string to LaTeX notation
 */
function expressionToLaTeX(expr) {
    if (!expr || typeof expr !== 'string') return expr;
    let s = expr.trim();

    // Replace common functions with LaTeX equivalents
    s = s.replace(/\bsqrt\(([^)]+)\)/g, '\\sqrt{$1}');
    s = s.replace(/\babs\(([^)]+)\)/g, '\\left|$1\\right|');
    s = s.replace(/\bsin\(/g, '\\sin(');
    s = s.replace(/\bcos\(/g, '\\cos(');
    s = s.replace(/\btan\(/g, '\\tan(');
    s = s.replace(/\basin\(/g, '\\arcsin(');
    s = s.replace(/\bacos\(/g, '\\arccos(');
    s = s.replace(/\batan\(/g, '\\arctan(');
    s = s.replace(/\bsinh\(/g, '\\sinh(');
    s = s.replace(/\bcosh\(/g, '\\cosh(');
    s = s.replace(/\btanh\(/g, '\\tanh(');
    s = s.replace(/\blog\(/g, '\\ln(');
    s = s.replace(/\bexp\(([^)]+)\)/g, 'e^{$1}');
    s = s.replace(/\bpi\b/g, '\\pi');
    s = s.replace(/\btheta\b/g, '\\theta');
    s = s.replace(/\binf\b/gi, '\\infty');

    // x^2 → x^{2}, x^(2+n) → x^{2+n}
    s = s.replace(/\^(\d+)/g, '^{$1}');
    s = s.replace(/\^\(([^)]+)\)/g, '^{$1}');

    // Fractions: a/b → \frac{a}{b} for simple cases
    s = s.replace(/(\w+)\/(\w+)/g, '\\frac{$1}{$2}');

    // *  → \cdot (optional, for display)
    s = s.replace(/\*/g, ' \\cdot ');

    return s;
}

/**
 * Resolve function composition across expressions.
 * Scans all expressions for named functions like "f(x) = ..." or "g(x) = ..."
 * and substitutes them into the given expression string.
 * e.g., if expr1 is "f(x)=x^2" and we get "f(f(x))", returns "((x^2))^2"
 */
function resolveFunctionComposition(expression) {
    if (!expression || typeof expression !== 'string') return expression;

    // Build a map of named functions from all expressions
    const funcDefs = {};
    engine.expressions.forEach(e => {
        if (!e.expression || typeof e.expression !== 'string') return;
        // Match f(x) = ..., g(x) = ..., h(x) = ...
        const m = e.expression.match(/^\s*([a-zA-Z])\s*\(\s*x\s*\)\s*=\s*(.+)$/);
        if (m) {
            const fname = m[1];
            const fbody = m[2].trim();
            // Skip self-referential definitions (e.g. f(x) = f(x) + 1) to prevent infinite loops
            const selfRefPattern = new RegExp(`(?<![a-zA-Z])${fname}\\s*\\(`);
            if (!selfRefPattern.test(fbody)) {
                funcDefs[fname] = fbody;
            }
        }
    });

    if (Object.keys(funcDefs).length === 0) return expression;

    // Iteratively substitute function calls (up to 10 iterations for nested composition)
    let result = expression;
    for (let iter = 0; iter < 10; iter++) {
        let changed = false;
        for (const [fname, fbody] of Object.entries(funcDefs)) {
            // Match fname(...) — need to handle nested parens
            const pattern = new RegExp(`(?<![a-zA-Z])${fname}\\(`, 'g');
            let match;
            const newResult = [];
            let lastIdx = 0;
            const str = result;
            pattern.lastIndex = 0;
            while ((match = pattern.exec(str)) !== null) {
                const start = match.index;
                const argStart = start + match[0].length;
                // Find matching closing paren
                let depth = 1;
                let i = argStart;
                while (i < str.length && depth > 0) {
                    if (str[i] === '(') depth++;
                    else if (str[i] === ')') depth--;
                    i++;
                }
                if (depth !== 0) continue; // unbalanced
                const arg = str.substring(argStart, i - 1);
                // Substitute: replace x in fbody with (arg)
                const substituted = fbody.replace(/(?<![a-zA-Z])x(?![a-zA-Z])/g, `(${arg})`);
                newResult.push(str.substring(lastIdx, start));
                newResult.push(`(${substituted})`);
                lastIdx = i;
                changed = true;
            }
            if (changed) {
                newResult.push(str.substring(lastIdx));
                result = newResult.join('');
            }
        }
        if (!changed) break;
    }
    return result;
}

/**
 * Evaluate summation: sum(var, start, end, body)
 * e.g. sum(n, 1, 10, 1/n^2)
 */
function evaluateSum(expr, scope) {
    const m = expr.match(/\bsum\s*\(\s*([a-zA-Z])\s*,\s*(.+?)\s*,\s*(.+?)\s*,\s*(.+)\s*\)$/);
    if (!m) return null;
    const [, varName, startExpr, endExpr, bodyExpr] = m;
    try {
        const start = Math.round(math.evaluate(startExpr, scope));
        const end = Math.round(math.evaluate(endExpr, scope));
        const compiled = math.compile(bodyExpr);
        let total = 0;
        for (let i = start; i <= end; i++) {
            const s = Object.assign({}, scope);
            s[varName] = i;
            total += compiled.evaluate(s);
        }
        return total;
    } catch (e) {
        return null;
    }
}

/**
 * Evaluate product: prod(var, start, end, body)
 * e.g. prod(n, 1, 5, n)
 */
function evaluateProduct(expr, scope) {
    const m = expr.match(/\bprod\s*\(\s*([a-zA-Z])\s*,\s*(.+?)\s*,\s*(.+?)\s*,\s*(.+)\s*\)$/);
    if (!m) return null;
    const [, varName, startExpr, endExpr, bodyExpr] = m;
    try {
        const start = Math.round(math.evaluate(startExpr, scope));
        const end = Math.round(math.evaluate(endExpr, scope));
        const compiled = math.compile(bodyExpr);
        let total = 1;
        for (let i = start; i <= end; i++) {
            const s = Object.assign({}, scope);
            s[varName] = i;
            total *= compiled.evaluate(s);
        }
        return total;
    } catch (e) {
        return null;
    }
}

/**
 * Compute Fourier series approximation: fourier(f(x), N)
 * Computes the first N terms of the Fourier series of f(x) on [-pi, pi].
 * Returns a function string.
 */
function computeFourierCoefficients(bodyExpr, nTerms, period) {
    const L = period / 2;
    const numPoints = 200;
    const dx = period / numPoints;

    try {
        const compiled = math.compile(bodyExpr);

        // a0
        let a0 = 0;
        for (let i = 0; i < numPoints; i++) {
            const x = -L + (i + 0.5) * dx;
            a0 += compiled.evaluate({ x });
        }
        a0 = a0 * dx / L;

        const an = [];
        const bn = [];
        for (let n = 1; n <= nTerms; n++) {
            let aSum = 0, bSum = 0;
            for (let i = 0; i < numPoints; i++) {
                const x = -L + (i + 0.5) * dx;
                const fx = compiled.evaluate({ x });
                aSum += fx * Math.cos(n * Math.PI * x / L);
                bSum += fx * Math.sin(n * Math.PI * x / L);
            }
            an.push(aSum * dx / L);
            bn.push(bSum * dx / L);
        }
        return { a0, an, bn, L };
    } catch (e) {
        return null;
    }
}

/**
 * Generate Fourier series data for plotting
 */
function generateFourierTrace(bodyExpr, nTerms, xMin, xMax, color) {
    const period = 2 * Math.PI;
    const coeffs = computeFourierCoefficients(bodyExpr, nTerms, period);
    if (!coeffs) return null;

    const { a0, an, bn, L } = coeffs;
    const numPoints = 500;
    const xs = [];
    const ys = [];
    const step = (xMax - xMin) / numPoints;

    for (let i = 0; i <= numPoints; i++) {
        const x = xMin + i * step;
        let y = a0 / 2;
        for (let n = 0; n < an.length; n++) {
            y += an[n] * Math.cos((n + 1) * Math.PI * x / L);
            y += bn[n] * Math.sin((n + 1) * Math.PI * x / L);
        }
        xs.push(x);
        ys.push(y);
    }

    return [{
        x: xs, y: ys,
        type: 'scatter', mode: 'lines',
        name: `Fourier(${nTerms} terms)`,
        line: { color: color || '#e74c3c', width: 2 }
    }];
}

/**
 * Toggle trace mode
 */
function toggleTraceMode() {
    traceModeActive = !traceModeActive;
    const button = document.querySelector('[onclick="toggleTraceMode()"]');
    if (!button) return;

    if (traceModeActive) {
        button.style.background = 'var(--gc-light)';
        button.style.borderColor = 'var(--gc-tool)';
        button.style.color = 'var(--gc-tool)';
        button.title = 'Trace Mode: ON';
        enableTraceMode();
    } else {
        button.style.background = '';
        button.style.borderColor = '';
        button.style.color = '';
        button.title = 'Trace Mode';
        disableTraceMode();
    }
}

// Store trace mode handlers for proper cleanup
var _traceHandlers = { hover: null, unhover: null, click: null };
// Store pinned annotations so they survive re-plots
var _tracePinnedAnnotations = [];

/**
 * Enable trace mode with snap-to-curve, crosshair, slope display
 */
function enableTraceMode() {
    const graphDiv = document.getElementById('graph');

    // Create tooltip element if it doesn't exist
    if (!document.getElementById('trace-tooltip')) {
        const tooltip = document.createElement('div');
        tooltip.id = 'trace-tooltip';
        tooltip.style.cssText = `
            position: fixed;
            top: 100px;
            right: 30px;
            background: rgba(0, 0, 0, 0.9);
            color: white;
            padding: 12px 16px;
            border-radius: 8px;
            font-family: 'Courier New', monospace;
            font-size: 13px;
            z-index: 1000;
            display: none;
            box-shadow: 0 4px 12px rgba(0,0,0,0.4);
            line-height: 1.5;
            min-width: 180px;
        `;
        document.body.appendChild(tooltip);
    }

    // Remove old handlers if any (prevent stacking)
    if (_traceHandlers.hover) graphDiv.removeListener('plotly_hover', _traceHandlers.hover);
    if (_traceHandlers.unhover) graphDiv.removeListener('plotly_unhover', _traceHandlers.unhover);
    if (_traceHandlers.click) graphDiv.removeListener('plotly_click', _traceHandlers.click);

    // Enhanced hover: snap to nearest curve and show crosshair
    _traceHandlers.hover = function(data) {
        if (!traceModeActive || !data || !data.points || !data.points[0]) return;
        const point = data.points[0];

        let x = point.x, y = point.y;
        let slopeText = '', curveName = point.data.name || '';

        // Try to snap: find the cartesian expression and evaluate at exact x
        const expr = engine.expressions.find(e =>
            e.expression === point.data.name ||
            e.visible && e.type === 'cartesian' && point.data.name && point.data.name.includes(e.expression)
        );
        if (expr && expr.type === 'cartesian') {
            try {
                const { expr: cleanExpr } = engine.parseDomainRestriction(expr.expression);
                const compiled = engine._compile(engine.normalizeExpression(engine.stripCartesianPrefix(cleanExpr)));
                const yExact = compiled.evaluate({ x });
                if (typeof yExact === 'number' && isFinite(yExact)) {
                    y = yExact; // snap to curve
                }
                const h = 0.001;
                const slope = (compiled.evaluate({ x: x + h }) - compiled.evaluate({ x: x - h })) / (2 * h);
                if (isFinite(slope)) {
                    slopeText = `dy/dx: ${slope.toFixed(4)}`;
                    const angle = Math.atan(slope) * 180 / Math.PI;
                    slopeText += ` (${angle.toFixed(1)}°)`;
                }
            } catch (_) {}
        }

        // Draw crosshair lines
        if (graphDiv.layout && graphDiv.layout.xaxis && graphDiv.layout.yaxis) {
            const xRange = graphDiv.layout.xaxis.range;
            const yRange = graphDiv.layout.yaxis.range;
            Plotly.relayout(graphDiv, {
                shapes: [
                    { type: 'line', x0: x, x1: x, y0: yRange[0], y1: yRange[1], line: { color: '#a78bfa', width: 1, dash: 'dot' } },
                    { type: 'line', x0: xRange[0], x1: xRange[1], y0: y, y1: y, line: { color: '#a78bfa', width: 1, dash: 'dot' } }
                ]
            });
        }

        const tooltip = document.getElementById('trace-tooltip');
        if (tooltip) {
            tooltip.innerHTML = `
                <div style="color:#a78bfa;font-weight:bold;margin-bottom:4px;">${curveName}</div>
                <div>x = ${x.toFixed(6)}</div>
                <div>y = ${y.toFixed(6)}</div>
                ${slopeText ? '<div style="margin-top:4px;color:#93c5fd;">' + slopeText + '</div>' : ''}
            `;
            tooltip.style.display = 'block';
        }
    };

    _traceHandlers.unhover = function() {
        const tooltip = document.getElementById('trace-tooltip');
        if (tooltip) tooltip.style.display = 'none';
        // Remove crosshair but keep pinned annotations
        Plotly.relayout(graphDiv, { shapes: [], annotations: _tracePinnedAnnotations.slice() });
    };

    // Click to place a persistent marker
    _traceHandlers.click = function(data) {
        if (!traceModeActive || !data || !data.points || !data.points[0]) return;
        const pt = data.points[0];
        let x = pt.x, y = pt.y;

        // Snap to curve
        const expr = engine.expressions.find(e => e.expression === pt.data.name);
        if (expr && expr.type === 'cartesian') {
            try {
                const { expr: cleanExpr } = engine.parseDomainRestriction(expr.expression);
                const compiled = engine._compile(engine.normalizeExpression(engine.stripCartesianPrefix(cleanExpr)));
                const yExact = compiled.evaluate({ x });
                if (typeof yExact === 'number' && isFinite(yExact)) y = yExact;
            } catch (_) {}
        }

        // Store annotation persistently
        _tracePinnedAnnotations.push({
            x, y,
            text: `(${x.toFixed(3)}, ${y.toFixed(3)})`,
            showarrow: true, arrowhead: 2, arrowsize: 1, arrowcolor: '#a78bfa',
            font: { size: 11, color: '#a78bfa' },
            bgcolor: 'rgba(0,0,0,0.7)',
            borderpad: 4
        });
        Plotly.relayout(graphDiv, { annotations: _tracePinnedAnnotations.slice() });
    };

    graphDiv.on('plotly_hover', _traceHandlers.hover);
    graphDiv.on('plotly_unhover', _traceHandlers.unhover);
    graphDiv.on('plotly_click', _traceHandlers.click);
}

/**
 * Disable trace mode
 */
function disableTraceMode() {
    const tooltip = document.getElementById('trace-tooltip');
    if (tooltip) tooltip.style.display = 'none';
    const graphDiv = document.getElementById('graph');
    if (graphDiv) {
        // Remove handlers properly
        if (_traceHandlers.hover) graphDiv.removeListener('plotly_hover', _traceHandlers.hover);
        if (_traceHandlers.unhover) graphDiv.removeListener('plotly_unhover', _traceHandlers.unhover);
        if (_traceHandlers.click) graphDiv.removeListener('plotly_click', _traceHandlers.click);
        _traceHandlers = { hover: null, unhover: null, click: null };
        // Clear visuals
        _tracePinnedAnnotations = [];
        Plotly.relayout(graphDiv, { shapes: [], annotations: [] });
    }
}

/**
 * Solve equation (find roots where y = 0 or y = targetY)
 */
function solveEquation() {
    const cartesianExprs = engine.expressions.filter(e => e.type === 'cartesian' && e.expression && e.visible);

    if (cartesianExprs.length === 0) {
        alert('Please add at least one Cartesian expression first!\n\nSteps:\n1. Click "Add Expression"\n2. Enter a function like: x^2 - 4\n3. Click "Solve Equation" again');
        return;
    }

    // Prompt for which expression to solve
    let message = 'Select expression to solve:\n\n';
    cartesianExprs.forEach((expr, index) => {
        message += `${index + 1}. ${expr.expression}\n`;
    });

    const selection = prompt(message + `\nEnter a number between 1 and ${cartesianExprs.length}:`);

    if (selection === null) return; // User cancelled

    const index = parseInt(selection) - 1;

    if (isNaN(index) || index < 0 || index >= cartesianExprs.length) {
        alert(`Invalid selection!\n\nYou entered: "${selection}"\nPlease enter a number between 1 and ${cartesianExprs.length}`);
        return;
    }

    const expr = cartesianExprs[index];

    // Prompt for target y value
    const targetYStr = prompt('Solve for y = ? (default: 0 to find roots)', '0');
    if (targetYStr === null) return;

    const targetY = parseFloat(targetYStr) || 0;

    const xMin = parseFloat(document.getElementById('xMin').value);
    const xMax = parseFloat(document.getElementById('xMax').value);

    // Find solutions
    const solutions = findSolutions(expr.expression, targetY, xMin, xMax);

    if (solutions.length === 0) {
        alert(`No solutions found for ${expr.expression} = ${targetY} in range [${xMin}, ${xMax}]`);
        return;
    }

    // Display solutions
    let resultMsg = `Solutions for ${expr.expression} = ${targetY}:\n\n`;
    solutions.forEach((x, i) => {
        resultMsg += `${i + 1}. x = ${x.toFixed(6)}\n`;
    });

    alert(resultMsg);

    // Mark solutions on graph
    if (!expr.solutions) {
        expr.solutions = [];
    }
    expr.solutions = solutions.map(x => ({ x, y: targetY }));

    updateGraph();
}

/**
 * Find solutions using root-finding algorithm
 */
function findSolutions(expression, targetY, xMin, xMax, tolerance = 0.001) {
    try {
        const compiled = math.compile(engine.normalizeExpression(engine.stripCartesianPrefix(expression)));
        const solutions = [];
        const numSamples = 1000;
        const step = (xMax - xMin) / numSamples;

        let prevSign = null;

        for (let i = 0; i <= numSamples; i++) {
            const x = xMin + i * step;

            try {
                const y = compiled.evaluate({ x });
                const diff = y - targetY;

                if (!isFinite(diff)) continue;

                const currentSign = Math.sign(diff);

                // Check for sign change (indicates crossing)
                if (prevSign !== null && prevSign !== currentSign && currentSign !== 0) {
                    // Use bisection method to refine solution
                    const solution = bisectionSolve(
                        compiled,
                        targetY,
                        x - step,
                        x,
                        tolerance
                    );

                    if (solution !== null) {
                        solutions.push(solution);
                    }
                }

                // Check for exact solution
                if (Math.abs(diff) < tolerance) {
                    solutions.push(x);
                }

                prevSign = currentSign;
            } catch (e) {
                // Skip points where evaluation fails
            }
        }

        // Remove duplicates
        const unique = [];
        for (const sol of solutions) {
            const isDuplicate = unique.some(s => Math.abs(s - sol) < tolerance * 10);
            if (!isDuplicate) {
                unique.push(sol);
            }
        }

        return unique;
    } catch (error) {
        console.error('Error finding solutions:', error);
        return [];
    }
}

/**
 * Bisection method for finding solutions
 */
function bisectionSolve(compiled, targetY, xLeft, xRight, tolerance) {
    let left = xLeft;
    let right = xRight;
    let iterations = 0;
    const maxIterations = 50;

    while (iterations < maxIterations && (right - left) > tolerance) {
        const mid = (left + right) / 2;

        try {
            const yLeft = compiled.evaluate({ x: left });
            const diffLeft = yLeft - targetY;

            const yMid = compiled.evaluate({ x: mid });
            const diffMid = yMid - targetY;

            if (Math.abs(diffMid) < tolerance) {
                return mid;
            }

            if (Math.sign(diffLeft) !== Math.sign(diffMid)) {
                right = mid;
            } else {
                left = mid;
            }
        } catch (e) {
            return null;
        }

        iterations++;
    }

    return (left + right) / 2;
}

/**
 * Export graph as PNG image
 */
function exportAsPNG() {
    Plotly.downloadImage('graph', {
        format: 'png',
        width: 1200,
        height: 800,
        filename: 'graph-' + Date.now()
    });
}

/**
 * Export graph as SVG image
 */
function exportAsSVG() {
    Plotly.downloadImage('graph', {
        format: 'svg',
        width: 1200,
        height: 800,
        filename: 'graph-' + Date.now()
    });
}

/**
 * Save current expression set to localStorage
 */
function saveExpressionSet() {
    const name = prompt('Enter a name for this expression set:');
    if (!name) return;

    const data = {
        name: name,
        timestamp: Date.now(),
        expressions: engine.expressions.map(expr => ({
            expression: expr.expression,
            type: expr.type,
            color: expr.color,
            visible: expr.visible,
            showDerivative: expr.showDerivative,
            showSecondDerivative: expr.showSecondDerivative,
            showCriticalPoints: expr.showCriticalPoints,
            showInflectionPoints: expr.showInflectionPoints,
            showAntiderivative: expr.showAntiderivative,
            regressionType: expr.regressionType,
            limitExpr: expr.limitExpr,
            limitVar: expr.limitVar,
            limitVal: expr.limitVal,
            parameters: expr.parameters,
            distParams: expr.distParams
        })),
        settings: {
            xMin: document.getElementById('xMin').value,
            xMax: document.getElementById('xMax').value,
            yMin: document.getElementById('yMin').value,
            yMax: document.getElementById('yMax').value,
            showGrid: document.getElementById('showGrid').checked,
            showLegend: document.getElementById('showLegend').checked
        }
    };

    // Get existing saved sets
    const saved = JSON.parse(localStorage.getItem('savedExpressionSets') || '[]');
    saved.push(data);
    localStorage.setItem('savedExpressionSets', JSON.stringify(saved));

    alert(`Expression set "${name}" saved successfully!`);
}

/**
 * Load expression set from localStorage
 */
function loadExpressionSet() {
    const saved = JSON.parse(localStorage.getItem('savedExpressionSets') || '[]');

    if (saved.length === 0) {
        alert('No saved expression sets found.');
        return;
    }

    // Create selection dialog
    let message = 'Select an expression set to load:\n\n';
    saved.forEach((set, index) => {
        const date = new Date(set.timestamp).toLocaleString();
        message += `${index + 1}. ${set.name} (${date})\n`;
    });

    const selection = prompt(message + '\nEnter number:');
    const index = parseInt(selection) - 1;

    if (isNaN(index) || index < 0 || index >= saved.length) {
        alert('Invalid selection.');
        return;
    }

    const data = saved[index];

    // Clear current expressions and MQ state
    engine.expressions = [];
    Object.keys(_mqFields).forEach(k => delete _mqFields[k]);
    Object.keys(_mqInputMode).forEach(k => delete _mqInputMode[k]);
    document.getElementById('expressions-list').innerHTML = '';
    expressionElements = {};

    // Restore expressions
    data.expressions.forEach(exprData => {
        const expr = engine.addExpression(
            exprData.expression,
            exprData.type,
            exprData.color
        );
        expr.visible = exprData.visible;
        expr.showDerivative = exprData.showDerivative;
        expr.showSecondDerivative = exprData.showSecondDerivative;
        expr.showCriticalPoints = exprData.showCriticalPoints;
        expr.showInflectionPoints = exprData.showInflectionPoints;
        expr.showAntiderivative = exprData.showAntiderivative;
        expr.regressionType = exprData.regressionType;
        expr.limitExpr = exprData.limitExpr;
        expr.limitVar = exprData.limitVar;
        expr.limitVal = exprData.limitVal;
        expr.parameters = exprData.parameters;
        expr.distParams = exprData.distParams;

        createExpressionElement(expr);

        // Restore input value (plain text fallback — MQ fields populated by _initMathQuillField)
        if (!_mqFields[expr.id]) {
            const inputElement = document.getElementById(`expr-${expr.id}`);
            if (inputElement) inputElement.value = exprData.expression || '';
        }

        // Restore checkboxes
        if (exprData.showDerivative) {
            const cb = document.getElementById(`show-derivative-${expr.id}`);
            if (cb) cb.checked = true;
        }
        if (exprData.showSecondDerivative) {
            const cb = document.getElementById(`show-second-derivative-${expr.id}`);
            if (cb) cb.checked = true;
        }
        if (exprData.showCriticalPoints) {
            const cb = document.getElementById(`show-critical-points-${expr.id}`);
            if (cb) cb.checked = true;
        }
        if (exprData.showInflectionPoints) {
            const cb = document.getElementById(`show-inflection-points-${expr.id}`);
            if (cb) cb.checked = true;
        }
        if (exprData.regressionType) {
            const sel = document.getElementById(`regression-type-${expr.id}`);
            if (sel) sel.value = exprData.regressionType;
        }
    });

    // Restore settings
    if (data.settings) {
        document.getElementById('xMin').value = data.settings.xMin;
        document.getElementById('xMax').value = data.settings.xMax;
        document.getElementById('yMin').value = data.settings.yMin;
        document.getElementById('yMax').value = data.settings.yMax;
        document.getElementById('showGrid').checked = data.settings.showGrid;
        document.getElementById('showLegend').checked = data.settings.showLegend;
    }

    updateGraph();
    alert(`Expression set "${data.name}" loaded successfully!`);
}

/**
 * Delete saved expression sets
 */
function manageSavedSets() {
    const saved = JSON.parse(localStorage.getItem('savedExpressionSets') || '[]');

    if (saved.length === 0) {
        alert('No saved expression sets found.');
        return;
    }

    let message = 'Saved expression sets:\n\n';
    saved.forEach((set, index) => {
        const date = new Date(set.timestamp).toLocaleString();
        message += `${index + 1}. ${set.name} (${date})\n`;
    });

    message += '\nEnter number to delete (or "all" to delete all, or cancel):';
    const selection = prompt(message);

    if (!selection) return;

    if (selection.toLowerCase() === 'all') {
        if (confirm('Are you sure you want to delete ALL saved sets?')) {
            localStorage.removeItem('savedExpressionSets');
            alert('All saved sets deleted.');
        }
    } else {
        const index = parseInt(selection) - 1;
        if (isNaN(index) || index < 0 || index >= saved.length) {
            alert('Invalid selection.');
            return;
        }

        const setName = saved[index].name;
        if (confirm(`Delete expression set "${setName}"?`)) {
            saved.splice(index, 1);
            localStorage.setItem('savedExpressionSets', JSON.stringify(saved));
            alert(`Expression set "${setName}" deleted.`);
        }
    }
}

/**
 * Generate shareable link with URL encoding
 */
function generateShareableLink() {
    const data = {
        expressions: engine.expressions.map(expr => ({
            expression: expr.expression,
            type: expr.type,
            color: expr.color,
            showDerivative: expr.showDerivative,
            showSecondDerivative: expr.showSecondDerivative,
            showCriticalPoints: expr.showCriticalPoints,
            showInflectionPoints: expr.showInflectionPoints,
            showAntiderivative: expr.showAntiderivative,
            showIntegration: expr.showIntegration,
            integrationBounds: expr.integrationBounds,
            riemannMethod: expr.riemannMethod,
            riemannN: expr.riemannN,
            regressionType: expr.regressionType,
            limitExpr: expr.limitExpr,
            limitVar: expr.limitVar,
            limitVal: expr.limitVal,
            parameters: expr.parameters,
            distParams: expr.distParams
        })),
        settings: {
            xMin: document.getElementById('xMin').value,
            xMax: document.getElementById('xMax').value,
            yMin: document.getElementById('yMin').value,
            yMax: document.getElementById('yMax').value
        }
    };

    // Encode data to base64 (handle Unicode via encodeURIComponent)
    const jsonString = JSON.stringify(data);
    const base64 = btoa(unescape(encodeURIComponent(jsonString)));

    // Create URL
    const url = window.location.origin + window.location.pathname + '?data=' + encodeURIComponent(base64);

    // Copy to clipboard
    navigator.clipboard.writeText(url).then(() => {
        alert('Shareable link copied to clipboard!\n\nYou can now paste and share this link.');
    }).catch(err => {
        // Fallback: show URL in prompt
        prompt('Copy this shareable link:', url);
    });
}

/**
 * Load from URL parameter
 */
function loadFromURL() {
    const urlParams = new URLSearchParams(window.location.search);
    const dataParam = urlParams.get('data');

    if (!dataParam) return;

    try {
        const jsonString = decodeURIComponent(escape(atob(decodeURIComponent(dataParam))));
        const data = JSON.parse(jsonString);

        // Clear current expressions and MQ state
        engine.expressions = [];
        Object.keys(_mqFields).forEach(k => delete _mqFields[k]);
        Object.keys(_mqInputMode).forEach(k => delete _mqInputMode[k]);
        document.getElementById('expressions-list').innerHTML = '';
        expressionElements = {};

        // Restore expressions
        data.expressions.forEach(exprData => {
            const expr = engine.addExpression(
                exprData.expression,
                exprData.type,
                exprData.color
            );
            expr.showDerivative = exprData.showDerivative;
            expr.showSecondDerivative = exprData.showSecondDerivative;
            expr.showCriticalPoints = exprData.showCriticalPoints;
            expr.showInflectionPoints = exprData.showInflectionPoints;
            expr.showAntiderivative = exprData.showAntiderivative;
            expr.regressionType = exprData.regressionType;
            expr.limitExpr = exprData.limitExpr;
            expr.limitVar = exprData.limitVar;
            expr.limitVal = exprData.limitVal;
            expr.parameters = exprData.parameters;
            expr.distParams = exprData.distParams;

            createExpressionElement(expr);

            // Restore input value (plain text fallback — MQ fields populated by _initMathQuillField)
            if (!_mqFields[expr.id]) {
                const inputElement = document.getElementById(`expr-${expr.id}`);
                if (inputElement) inputElement.value = exprData.expression || '';
            }

            // Restore checkboxes
            if (exprData.showDerivative) {
                const checkbox = document.getElementById(`show-derivative-${expr.id}`);
                if (checkbox) checkbox.checked = true;
            }
            if (exprData.showSecondDerivative) {
                const cb = document.getElementById(`show-second-derivative-${expr.id}`);
                if (cb) cb.checked = true;
            }
            if (exprData.showCriticalPoints) {
                const cb = document.getElementById(`show-critical-points-${expr.id}`);
                if (cb) cb.checked = true;
            }
            if (exprData.showInflectionPoints) {
                const cb = document.getElementById(`show-inflection-points-${expr.id}`);
                if (cb) cb.checked = true;
            }
            if (exprData.regressionType) {
                const sel = document.getElementById(`regression-type-${expr.id}`);
                if (sel) sel.value = exprData.regressionType;
            }
        });

        // Restore settings
        if (data.settings) {
            document.getElementById('xMin').value = data.settings.xMin;
            document.getElementById('xMax').value = data.settings.xMax;
            document.getElementById('yMin').value = data.settings.yMin;
            document.getElementById('yMax').value = data.settings.yMax;
        }

        updateGraph();
    } catch (error) {
        console.error('Error loading from URL:', error);
    }
}

// ============================================
// Embed Code Generator
// ============================================

/**
 * Show the embed code modal with current graph state
 */
function showEmbedCode() {
    var modal = document.getElementById('gc-embed-modal');
    if (!modal) return;
    modal.style.display = 'flex';
    updateEmbedPreview();
}

/**
 * Build embed iframe code from current expressions and options
 */
function updateEmbedPreview() {
    var output = document.getElementById('embed-code-output');
    if (!output) return;

    var width = document.getElementById('embed-width').value || '800';
    var height = document.getElementById('embed-height').value || '500';
    var showInputs = document.getElementById('embed-opt-inputs').checked;
    var showGrid = document.getElementById('embed-opt-grid').checked;
    var showLegend = document.getElementById('embed-opt-legend').checked;
    var darkTheme = document.getElementById('embed-opt-dark').checked;

    // Build params from current graph state
    var params = [];

    if (engine && engine.expressions && engine.expressions.length > 0) {
        var exprs = [], types = [], colors = [];
        engine.expressions.forEach(function(e) {
            if (e.expression) {
                exprs.push(e.expression);
                types.push(e.type || 'cartesian');
                colors.push(e.color || '#2563eb');
            }
        });
        if (exprs.length > 0) {
            params.push('expr=' + encodeURIComponent(exprs.join('|')));
            params.push('type=' + encodeURIComponent(types.join('|')));
            params.push('color=' + encodeURIComponent(colors.join('|')));
        }
    }

    // Range
    var xMin = document.getElementById('xMin').value;
    var xMax = document.getElementById('xMax').value;
    var yMin = document.getElementById('yMin').value;
    var yMax = document.getElementById('yMax').value;
    if (xMin !== '-10') params.push('xmin=' + xMin);
    if (xMax !== '10') params.push('xmax=' + xMax);
    if (yMin !== '-10') params.push('ymin=' + yMin);
    if (yMax !== '10') params.push('ymax=' + yMax);

    // Options
    if (!showInputs) params.push('inputs=0');
    if (!showGrid) params.push('grid=0');
    if (!showLegend) params.push('legend=0');
    if (darkTheme) params.push('theme=dark');

    var cp = (document.querySelector('meta[name="context-path"]') || {}).content || '';
    var baseUrl = window.location.origin + cp + '/graphing-calculator-embed.jsp';
    var url = baseUrl + (params.length > 0 ? '?' + params.join('&') : '');

    var iframe = '<iframe src="' + url + '" width="' + width + '" height="' + height + '" ' +
        'style="border:1px solid #e5e7eb;border-radius:8px;" ' +
        'allowfullscreen loading="lazy" ' +
        'title="Graphing Calculator - 8gwifi.org"></iframe>';

    output.value = iframe;
}

/**
 * Copy embed code to clipboard
 */
function copyEmbedCode() {
    var output = document.getElementById('embed-code-output');
    if (!output) return;
    output.select();
    document.execCommand('copy');
    var btn = output.parentElement.nextElementSibling.querySelector('button');
    if (btn) {
        var orig = btn.innerHTML;
        btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
        setTimeout(function() { btn.innerHTML = orig; }, 2000);
    }
}
