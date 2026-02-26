/**
 * ODE Solver Calculator - DOM/UI logic
 * Solves first-order, second-order ODEs and plots direction fields via SymPy on OneCompiler.
 * 3 modes: First-Order, Second-Order, Direction Field
 * Requires: KaTeX (loaded by JSP)
 * Context path: set window.ODE_CALC_CTX before load
 */
(function() {
    'use strict';

    // ========== DOM References ==========
    var firstOrderInput   = document.getElementById('ode-first-expr');
    var firstICCheck      = document.getElementById('ode-first-ic-check');
    var firstICFields     = document.getElementById('ode-first-ic-fields');
    var firstICx0         = document.getElementById('ode-first-ic-x0');
    var firstICy0         = document.getElementById('ode-first-ic-y0');

    var secondOrderInput  = document.getElementById('ode-second-expr');
    var secondICCheck     = document.getElementById('ode-second-ic-check');
    var secondICFields    = document.getElementById('ode-second-ic-fields');
    var secondICx0        = document.getElementById('ode-second-ic-x0');
    var secondICy0        = document.getElementById('ode-second-ic-y0');
    var secondICdy0       = document.getElementById('ode-second-ic-dy0');

    var fieldInput        = document.getElementById('ode-field-expr');
    var fieldXmin         = document.getElementById('ode-field-xmin');
    var fieldXmax         = document.getElementById('ode-field-xmax');
    var fieldYmin         = document.getElementById('ode-field-ymin');
    var fieldYmax         = document.getElementById('ode-field-ymax');
    var fieldCurveCheck   = document.getElementById('ode-field-curve-check');
    var fieldCurveFields  = document.getElementById('ode-field-curve-fields');
    var fieldCurveX0      = document.getElementById('ode-field-curve-x0');
    var fieldCurveY0      = document.getElementById('ode-field-curve-y0');

    var previewEl      = document.getElementById('ode-preview');
    var computeBtn     = document.getElementById('ode-compute-btn');
    var resultContent  = document.getElementById('ode-result-content');
    var resultActions  = document.getElementById('ode-result-actions');
    var emptyState     = document.getElementById('ode-empty-state');
    var graphHint      = document.getElementById('ode-graph-hint');

    var currentMode = 'first';
    var currentOrder = 2;
    var lastResultLatex = '';
    var lastResultText = '';
    var compilerLoaded = false;
    var pendingGraph = null;

    // ========== Utility ==========
    function escapeHtml(str) {
        var div = document.createElement('div');
        div.appendChild(document.createTextNode(str));
        return div.innerHTML;
    }

    function exprToPython(expr) {
        var py = (expr || '').trim()
            .replace(/e\^(\([^)]+\))/g, 'exp$1')
            .replace(/e\^([a-zA-Z0-9_]+)/g, 'exp($1)')
            .replace(/\^/g, '**')
            .replace(/(\d)([a-zA-Z])/g, '$1*$2')
            .replace(/\)(\()/g, ')*$1')
            .replace(/\)([a-zA-Z])/g, ')*$1');
        py = py.replace(/\bln\(/g, 'log(');
        return py;
    }

    function normalizeExpr(expr) {
        if (!expr || typeof expr !== 'string') return expr;
        var s = expr.trim();
        s = s.replace(/\u00b2/g, '^2').replace(/\u00b3/g, '^3')
             .replace(/\u2074/g, '^4').replace(/\u2075/g, '^5')
             .replace(/\u2076/g, '^6').replace(/\u2077/g, '^7')
             .replace(/\u2078/g, '^8').replace(/\u2079/g, '^9')
             .replace(/\u2070/g, '^0').replace(/\u00b9/g, '^1')
             .replace(/\u03c0/g, 'pi')
             .replace(/\u221a/g, 'sqrt')
             .replace(/\u00b7/g, '*').replace(/\u22c5/g, '*')
             .replace(/\u2212/g, '-')
             .replace(/\u00d7/g, '*');
        var FUNS = 'sin|cos|tan|sec|csc|cot|sinh|cosh|tanh|log|ln|sqrt|asin|acos|atan|exp';
        s = s.replace(new RegExp('(' + FUNS + ')\\s*(\\d+)\\s*([a-zA-Z])(?=[+\\-*/^)\\s,]|$)', 'g'), '$1($2*$3)');
        s = s.replace(new RegExp('(' + FUNS + ')\\s*([a-zA-Z])(?=[+\\-*/^)\\s,]|$)', 'g'), '$1($2)');
        s = s.replace(/e\^(\d+)([a-zA-Z])(?=[+\-*\/^)\s,]|$)/g, 'e^($1*$2)');
        s = s.replace(/([a-zA-Z])e\^/g, '$1*e^');
        s = s.replace(new RegExp('([b-dB-Df-wF-W])(' + FUNS + ')\\(', 'g'), '$1*$2(');
        s = s.replace(new RegExp('(\\d)(' + FUNS + ')\\(', 'g'), '$1*$2(');
        s = s.replace(/(\d)([a-wA-W])/g, '$1*$2');
        s = s.replace(/\bln\(/g, 'log(');
        return s;
    }

    /**
     * Enhanced expression-to-LaTeX converter.
     * Tokenizes, then uses recursive descent to produce real math:
     *   (x-y)/x      → \frac{x-y}{x}
     *   sin(x)/y      → \frac{\sin(x)}{y}
     *   2*x*y         → 2xy
     *   y*(1-y)       → y(1-y)
     *   exp(-x)       → e^{-x}
     *   yp            → y'
     */
    var LATEX_FUNS = { sin:'\\sin', cos:'\\cos', tan:'\\tan', sec:'\\sec', csc:'\\csc', cot:'\\cot',
        sinh:'\\sinh', cosh:'\\cosh', tanh:'\\tanh', asin:'\\arcsin', acos:'\\arccos', atan:'\\arctan',
        log:'\\ln', ln:'\\ln', sqrt:'\\sqrt', abs:'\\left|' };
    var LATEX_FUN_NAMES = Object.keys(LATEX_FUNS).sort(function(a,b){ return b.length - a.length; });
    var LATEX_FUN_RE = new RegExp('^(' + LATEX_FUN_NAMES.join('|') + ')\\(');

    function tokenize(s) {
        var tokens = [], i = 0;
        s = s.replace(/\*\*/g, '^'); // normalize power
        while (i < s.length) {
            var ch = s[i];
            if (/\s/.test(ch)) { i++; continue; }
            // number (including decimals)
            if (/[0-9]/.test(ch) || (ch === '.' && i+1 < s.length && /[0-9]/.test(s[i+1]))) {
                var num = '';
                while (i < s.length && /[0-9.]/.test(s[i])) num += s[i++];
                tokens.push({ type: 'num', val: num });
                continue;
            }
            // named function
            var fm = s.slice(i).match(LATEX_FUN_RE);
            if (fm) {
                tokens.push({ type: 'fn', val: fm[1] });
                i += fm[1].length; // skip name, leave '(' for next iteration
                continue;
            }
            // exp special: render as e^{...}
            if (s.slice(i, i+4) === 'exp(') {
                tokens.push({ type: 'fn', val: 'exp' });
                i += 3; continue;
            }
            // Higher-order derivative aliases (check longest first)
            if (s.slice(i, i+4) === 'yppp' && (i+4 >= s.length || !/[a-zA-Z0-9_]/.test(s[i+4]))) {
                tokens.push({ type: 'var', val: "y'''" });
                i += 4; continue;
            }
            if (s.slice(i, i+3) === 'ypp' && (i+3 >= s.length || !/[a-zA-Z0-9_]/.test(s[i+3]))) {
                tokens.push({ type: 'var', val: "y''" });
                i += 3; continue;
            }
            if (s.slice(i, i+2) === 'yp' && (i+2 >= s.length || !/[a-zA-Z0-9_]/.test(s[i+2]))) {
                tokens.push({ type: 'var', val: "y'" });
                i += 2; continue;
            }
            if (s.slice(i, i+2) === 'y5' && (i+2 >= s.length || !/[a-zA-Z0-9_]/.test(s[i+2]))) {
                tokens.push({ type: 'var', val: "y^{(5)}" });
                i += 2; continue;
            }
            if (s.slice(i, i+2) === 'y4' && (i+2 >= s.length || !/[a-zA-Z0-9_]/.test(s[i+2]))) {
                tokens.push({ type: 'var', val: "y^{(4)}" });
                i += 2; continue;
            }
            // pi → π constant
            if (s.slice(i, i+2) === 'pi' && (i+2 >= s.length || !/[a-zA-Z0-9_]/.test(s[i+2]))) {
                tokens.push({ type: 'var', val: '\\pi' });
                i += 2; continue;
            }
            // variable letter
            if (/[a-zA-Z_]/.test(ch)) {
                tokens.push({ type: 'var', val: ch });
                i++; continue;
            }
            // operators & parens
            if ('+-*/^()'.indexOf(ch) !== -1) {
                tokens.push({ type: 'op', val: ch });
                i++; continue;
            }
            i++; // skip unknown
        }
        return tokens;
    }

    function parseExpr(tokens, pos) { return parseAdd(tokens, pos); }

    function parseAdd(tokens, pos) {
        var r = parseMul(tokens, pos);
        var node = r.node; pos = r.pos;
        while (pos < tokens.length && tokens[pos].type === 'op' && (tokens[pos].val === '+' || tokens[pos].val === '-')) {
            var op = tokens[pos].val; pos++;
            var r2 = parseMul(tokens, pos);
            node = { type: 'binop', op: op, left: node, right: r2.node };
            pos = r2.pos;
        }
        return { node: node, pos: pos };
    }

    function parseMul(tokens, pos) {
        var r = parseUnary(tokens, pos);
        var node = r.node; pos = r.pos;
        while (pos < tokens.length) {
            var t = tokens[pos];
            if (t.type === 'op' && t.val === '*') {
                pos++;
                var r2 = parseUnary(tokens, pos);
                node = { type: 'binop', op: '*', left: node, right: r2.node };
                pos = r2.pos;
            } else if (t.type === 'op' && t.val === '/') {
                pos++;
                var r2 = parseUnary(tokens, pos);
                node = { type: 'binop', op: '/', left: node, right: r2.node };
                pos = r2.pos;
            }
            // implicit multiply: num·var, var·var, )·(, )·var, num·fn, var·fn, )·fn
            else if (t.type === 'num' || t.type === 'var' || t.type === 'fn' || (t.type === 'op' && t.val === '(')) {
                var prev = node.type;
                var canImplicit = (prev === 'num' || prev === 'var' || prev === 'fn' || prev === 'paren' || prev === 'power');
                if (canImplicit) {
                    var r2 = parseUnary(tokens, pos);
                    node = { type: 'binop', op: '*', left: node, right: r2.node };
                    pos = r2.pos;
                } else break;
            } else break;
        }
        return { node: node, pos: pos };
    }

    function parseUnary(tokens, pos) {
        if (pos < tokens.length && tokens[pos].type === 'op' && tokens[pos].val === '-') {
            pos++;
            var r = parseUnary(tokens, pos);
            return { node: { type: 'unary', op: '-', child: r.node }, pos: r.pos };
        }
        if (pos < tokens.length && tokens[pos].type === 'op' && tokens[pos].val === '+') {
            pos++;
            return parseUnary(tokens, pos);
        }
        return parsePower(tokens, pos);
    }

    function parsePower(tokens, pos) {
        var r = parseAtom(tokens, pos);
        var node = r.node; pos = r.pos;
        if (pos < tokens.length && tokens[pos].type === 'op' && tokens[pos].val === '^') {
            pos++;
            var r2 = parseUnary(tokens, pos); // right-associative
            node = { type: 'power', base: node, exp: r2.node };
            pos = r2.pos;
        }
        return { node: node, pos: pos };
    }

    function parseAtom(tokens, pos) {
        if (pos >= tokens.length) return { node: { type: 'var', val: '?' }, pos: pos };
        var t = tokens[pos];
        // number
        if (t.type === 'num') {
            return { node: { type: 'num', val: t.val }, pos: pos + 1 };
        }
        // variable
        if (t.type === 'var') {
            return { node: { type: 'var', val: t.val }, pos: pos + 1 };
        }
        // function call
        if (t.type === 'fn') {
            var fname = t.val;
            pos++;
            if (pos < tokens.length && tokens[pos].type === 'op' && tokens[pos].val === '(') {
                pos++; // skip (
                var r = parseExpr(tokens, pos);
                pos = r.pos;
                if (pos < tokens.length && tokens[pos].type === 'op' && tokens[pos].val === ')') pos++;
                return { node: { type: 'fn', name: fname, arg: r.node }, pos: pos };
            }
            return { node: { type: 'fn', name: fname, arg: { type: 'var', val: '' } }, pos: pos };
        }
        // parenthesized group
        if (t.type === 'op' && t.val === '(') {
            pos++;
            var r = parseExpr(tokens, pos);
            pos = r.pos;
            if (pos < tokens.length && tokens[pos].type === 'op' && tokens[pos].val === ')') pos++;
            return { node: { type: 'paren', child: r.node }, pos: pos };
        }
        return { node: { type: 'var', val: t.val }, pos: pos + 1 };
    }

    function astToLatex(node) {
        if (!node) return '';
        switch (node.type) {
            case 'num': return node.val;
            case 'var': return node.val;
            case 'unary':
                var child = astToLatex(node.child);
                // wrap additions in parens after negation
                if (node.child.type === 'binop' && (node.child.op === '+' || node.child.op === '-'))
                    return '-\\left(' + child + '\\right)';
                return '-' + child;
            case 'binop':
                var left = astToLatex(node.left);
                var right = astToLatex(node.right);
                if (node.op === '/') {
                    // unwrap redundant parens inside \frac — the fraction bar groups visually
                    var numNode = node.left.type === 'paren' ? node.left.child : node.left;
                    var denNode = node.right.type === 'paren' ? node.right.child : node.right;
                    return '\\frac{' + astToLatex(numNode) + '}{' + astToLatex(denNode) + '}';
                }
                if (node.op === '*') {
                    // smart multiply: use implicit juxtaposition or \cdot
                    var needDot = (node.left.type === 'num' && node.right.type === 'num');
                    return left + (needDot ? ' \\cdot ' : '') + right;
                }
                if (node.op === '+') return left + ' + ' + right;
                if (node.op === '-') return left + ' - ' + right;
                return left + ' ' + node.op + ' ' + right;
            case 'power':
                var base = astToLatex(node.base);
                // unwrap redundant parens in exponent — ^{} braces already group
                var expNode = node.exp.type === 'paren' ? node.exp.child : node.exp;
                var exp = astToLatex(expNode);
                // wrap complex bases in parens
                if (node.base.type === 'binop' || node.base.type === 'unary')
                    base = '\\left(' + base + '\\right)';
                return base + '^{' + exp + '}';
            case 'paren':
                return '\\left(' + astToLatex(node.child) + '\\right)';
            case 'fn':
                var arg = astToLatex(node.arg);
                if (node.name === 'exp') {
                    return 'e^{' + arg + '}';
                }
                if (node.name === 'sqrt') {
                    return '\\sqrt{' + arg + '}';
                }
                if (node.name === 'abs') {
                    return '\\left|' + arg + '\\right|';
                }
                var ltx = LATEX_FUNS[node.name] || '\\mathrm{' + node.name + '}';
                return ltx + '\\left(' + arg + '\\right)';
            default: return '';
        }
    }

    function exprToLatex(expr) {
        if (!expr) return '';
        try {
            var tokens = tokenize(expr);
            if (tokens.length === 0) return '';
            var result = parseExpr(tokens, 0);
            return astToLatex(result.node);
        } catch (e) {
            // fallback: basic string replace
            return expr
                .replace(/\*\*/g, '^').replace(/\*/g, ' \\cdot ')
                .replace(/sqrt\(([^)]+)\)/g, '\\sqrt{$1}')
                .replace(/sin\(/g, '\\sin(').replace(/cos\(/g, '\\cos(')
                .replace(/tan\(/g, '\\tan(').replace(/log\(/g, '\\ln(')
                .replace(/exp\(([^)]+)\)/g, 'e^{$1}')
                .replace(/\^([a-zA-Z0-9]+)/g, '^{$1}');
        }
    }

    function prepareLatexForKatex(latex) {
        if (!latex || typeof latex !== 'string') return latex;
        latex = latex.replace(/\\\\/g, '\\');
        var hasLatex = /\\|[\^_]|\{[^}]*\}/.test(latex);
        if (!hasLatex) {
            return '\\text{' + latex.replace(/\\/g, '\\\\').replace(/}/g, '\\}') + '}';
        }
        return latex;
    }

    // ========== FAQ ==========
    window.toggleFaq = function(btn) {
        btn.parentElement.classList.toggle('open');
    };

    // ========== Mode Toggle ==========
    var modeBtns = document.querySelectorAll('.ode-mode-btn');
    var firstWrap  = document.getElementById('ode-first-wrap');
    var secondWrap = document.getElementById('ode-second-wrap');
    var fieldWrap  = document.getElementById('ode-field-wrap');

    modeBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var mode = this.getAttribute('data-mode');
            if (mode === currentMode) return;
            currentMode = mode;
            modeBtns.forEach(function(b) { b.classList.remove('active'); });
            this.classList.add('active');
            firstWrap.style.display  = mode === 'first'  ? '' : 'none';
            secondWrap.style.display = mode === 'second' ? '' : 'none';
            fieldWrap.style.display  = mode === 'field'  ? '' : 'none';
            updatePreview();
            updateExamples();
        });
    });

    // ========== IC Checkboxes ==========
    if (firstICCheck) {
        firstICCheck.addEventListener('change', function() {
            firstICFields.classList.toggle('open', this.checked);
        });
    }
    if (secondICCheck) {
        secondICCheck.addEventListener('change', function() {
            secondICFields.classList.toggle('open', this.checked);
        });
    }
    if (fieldCurveCheck) {
        fieldCurveCheck.addEventListener('change', function() {
            fieldCurveFields.classList.toggle('open', this.checked);
        });
    }

    // ========== Order Selector ==========
    var orderBtns = document.querySelectorAll('.ode-order-btn');
    var secondLabel = document.getElementById('ode-second-label');
    var secondHint = document.getElementById('ode-second-hint');
    var secondICLabel = document.getElementById('ode-second-ic-label');
    var extraICFields = document.getElementById('ode-extra-ic-fields');

    orderBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var order = parseInt(this.getAttribute('data-order'), 10);
            if (order === currentOrder) return;
            currentOrder = order;
            orderBtns.forEach(function(b) { b.classList.remove('active'); });
            this.classList.add('active');
            updateHigherOrderUI();
            updatePreview();
            updateExamples();
        });
    });

    function getOrdinalSuffix(n) {
        if (n === 2) return '2nd';
        if (n === 3) return '3rd';
        return n + 'th';
    }

    function getDerivNotation(n) {
        if (n === 2) return 'd\u00B2y/dx\u00B2';
        if (n === 3) return 'd\u00B3y/dx\u00B3';
        return 'd' + '\u207F' + 'y/dx' + '\u207F';
    }

    function getDerivAliases(order) {
        var aliases = ['yp = y\''];
        if (order >= 2) aliases.push('ypp = y\'\'');
        if (order >= 3) aliases.push('yppp = y\'\'\'');
        if (order >= 4) aliases.push('y4 = y\u2074');
        if (order >= 5) aliases.push('y5 = y\u2075');
        return aliases;
    }

    function updateHigherOrderUI() {
        var n = currentOrder;
        var ordLabel = getOrdinalSuffix(n);

        // Update expression label
        if (secondLabel) {
            var derivStr;
            if (n === 2) derivStr = 'd&sup2;y/dx&sup2;';
            else if (n === 3) derivStr = 'd&sup3;y/dx&sup3;';
            else derivStr = 'd<sup>' + n + '</sup>y/dx<sup>' + n + '</sup>';
            var rhsVars = 'f(x, y';
            for (var i = 1; i < n; i++) {
                if (i === 1) rhsVars += ", y'";
                else if (i === 2) rhsVars += ", y''";
                else if (i === 3) rhsVars += ", y'''";
                else rhsVars += ', y<sup>(' + i + ')</sup>';
            }
            rhsVars += ')';
            secondLabel.innerHTML = derivStr + ' = ' + rhsVars + ' &mdash; enter the RHS';
        }

        // Update syntax hint
        if (secondHint) {
            var aliases = getDerivAliases(n);
            secondHint.innerHTML = 'Use <code>y</code> for y(x), ' + aliases.map(function(a) { return '<code>' + a.split(' = ')[0] + '</code> for ' + a.split(' = ')[1]; }).join(', ');
        }

        // Update IC label
        if (secondICLabel) {
            var icParts = ['y(x\u2080)=y\u2080'];
            for (var i = 1; i < n; i++) {
                if (i === 1) icParts.push("y'(x\u2080)=y'\u2080");
                else if (i === 2) icParts.push("y''(x\u2080)=y''\u2080");
                else if (i === 3) icParts.push("y'''(x\u2080)=y'''\u2080");
                else icParts.push('y\u207D' + i + '\u207E(x\u2080)=y\u207D' + i + '\u207E\u2080');
            }
            secondICLabel.textContent = 'Initial conditions ' + icParts.join(', ');
        }

        // Inject/remove extra IC input fields for order > 2
        if (extraICFields) {
            extraICFields.innerHTML = '';
            if (n > 2) {
                for (var i = 2; i < n; i++) {
                    var primeLabel;
                    if (i === 2) primeLabel = "y''\u2080";
                    else if (i === 3) primeLabel = "y'''\u2080";
                    else primeLabel = 'y\u207D' + i + '\u207E\u2080';
                    var fieldId = 'ode-second-ic-d' + i + 'y0';
                    var div = document.createElement('div');
                    div.className = 'tool-form-group';
                    div.innerHTML = '<label class="tool-form-label" for="' + fieldId + '">' + primeLabel + '</label>' +
                        '<input type="text" class="tool-input tool-input-mono" id="' + fieldId + '" value="0" style="width:100%;">';
                    extraICFields.appendChild(div);
                    // Bind preview input
                    var inp = div.querySelector('input');
                    if (inp) bindPreviewInput(inp);
                }
            }
        }
    }

    // ========== Output Tabs ==========
    var tabBtns = document.querySelectorAll('.ode-output-tab');
    var panels  = document.querySelectorAll('.ode-panel');
    tabBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var panel = this.getAttribute('data-panel');
            tabBtns.forEach(function(b) { b.classList.remove('active'); });
            panels.forEach(function(p) { p.classList.remove('active'); });
            this.classList.add('active');
            document.getElementById('ode-panel-' + panel).classList.add('active');

            if (panel === 'graph' && pendingGraph) {
                loadPlotly(function() { renderGraph(pendingGraph); });
            }
            if (panel === 'python' && !compilerLoaded) {
                loadCompilerWithTemplate();
                compilerLoaded = true;
            }
        });
    });

    // ========== Collapsible toggles ==========
    function setupToggle(btnId, contentId) {
        var btn = document.getElementById(btnId);
        var content = document.getElementById(contentId);
        if (!btn || !content) return;
        btn.addEventListener('click', function() {
            content.classList.toggle('open');
            var chevron = btn.querySelector('svg');
            if (chevron) chevron.style.transform = content.classList.contains('open') ? 'rotate(180deg)' : '';
        });
    }
    setupToggle('ode-syntax-btn', 'ode-syntax-content');
    setupToggle('ode-formulas-btn', 'ode-formulas-content');

    // ========== Render Reference Table ==========
    var formulasData = [
        ['Separable', "y' = f(x)g(y)", '\\int\\frac{dy}{g(y)} = \\int f(x)\\,dx'],
        ['1st Linear', "y' + P(x)y = Q(x)", '\\mu = e^{\\int P\\,dx}'],
        ['Bernoulli', "y' + Py = Qy^n", 'v = y^{1-n}'],
        ['Exact', 'M\\,dx + N\\,dy = 0', 'F_x = M,\\; F_y = N'],
        ['Homogeneous', "y' = f(y/x)", 'v = y/x'],
        ['2nd Const Coeff', "ay'' + by' + cy = 0", 'ar^2 + br + c = 0'],
        ['Non-Homogeneous', "y'' + py' + qy = g(x)", 'y = y_h + y_p'],
        ['Cauchy-Euler', "ax^2y'' + bxy' + cy = 0", 'x = e^t'],
        ['3rd Const Coeff', "ay''' + by'' + cy' + dy = 0", 'ar^3 + br^2 + cr + d = 0'],
        ['4th Order (Beam)', "EI\\,y'''' = q(x)", '\\text{Euler-Bernoulli beam}']
    ];
    for (var i = 0; i < formulasData.length; i++) {
        try {
            var fEl = document.getElementById('ode-formula-f' + i);
            if (fEl) katex.render(formulasData[i][1], fEl, { throwOnError: false });
            var mEl = document.getElementById('ode-formula-m' + i);
            if (mEl) katex.render(formulasData[i][2], mEl, { throwOnError: false });
        } catch(e) {}
    }

    // ========== Quick Examples ==========
    var firstExamples = [
        { label: "y'=y", rhs: 'y', ic: false },
        { label: "y'=-2xy", rhs: '-2*x*y', ic: false },
        { label: "y'=y(1-y)", rhs: 'y*(1-y)', ic: false },
        { label: "y'+2y=4", rhs: '4-2*y', ic: true, x0: '0', y0: '1' },
        { label: "y'=sin(x)/y", rhs: 'sin(x)/y', ic: false },
        { label: "y'=(x-y)/x", rhs: '(x-y)/x', ic: false },
        { label: "y'=y\u00B2 IVP", rhs: 'y**2', ic: true, x0: '0', y0: '1' },
        { label: "y'=x+y IVP", rhs: 'x+y', ic: true, x0: '0', y0: '0' }
    ];
    var secondExamples = [
        { label: "y''+y=0", rhs: '-y', ic: false },
        { label: "y''-y=0", rhs: 'y', ic: false },
        { label: "crit damped", rhs: '-2*yp-y', ic: false },
        { label: "y''-3y'+2y=0", rhs: '3*yp-2*y', ic: false },
        { label: "resonance", rhs: '-y+cos(x)', ic: false },
        { label: "const forcing", rhs: '-4*y+8', ic: true, x0: '0', y0: '0', dy0: '0' },
        { label: "y''-y=e\u02E3", rhs: 'y+exp(x)', ic: false },
        { label: "y''+y=sin(x)", rhs: '-y+sin(x)', ic: true, x0: '0', y0: '1', dy0: '0' }
    ];
    var fieldExamples = [
        { label: 'x+y', rhs: 'x+y' },
        { label: '-x/y', rhs: '-x/y' },
        { label: 'x*y', rhs: 'x*y' },
        { label: 'y(1-y)', rhs: 'y*(1-y)' },
        { label: 'sin(x)', rhs: 'sin(x)' },
        { label: 'x\u00B2-y', rhs: 'x**2-y' },
        { label: 'x/y', rhs: 'x/y' },
        { label: '(x-y)/(x+y)', rhs: '(x-y)/(x+y)' }
    ];

    // Higher-order examples per order
    var thirdExamples = [
        { label: "y'''+y=0", rhs: '-y', ic: false },
        { label: "y'''-6y''+11y'-6y=0", rhs: '6*ypp-11*yp+6*y', ic: false },
        { label: "y'''+y''+y'+y=0", rhs: '-ypp-yp-y', ic: false },
        { label: "y'''=sin(x)", rhs: 'sin(x)', ic: false },
        { label: "y'''-y=0", rhs: 'y', ic: false }
    ];
    var fourthExamples = [
        { label: "y''''+y=0", rhs: '-y', ic: false },
        { label: "y''''=1 (beam)", rhs: '1', ic: false },
        { label: "y''''-y=0", rhs: 'y', ic: false },
        { label: "y''''+2y''+y=0", rhs: '-2*ypp-y', ic: false }
    ];
    var fifthExamples = [
        { label: "y⁵+y=0", rhs: '-y', ic: false },
        { label: "y⁵-y=0", rhs: 'y', ic: false }
    ];

    // Random pools (superset)
    var randomThird = [
        { rhs: '-y' }, { rhs: '6*ypp-11*yp+6*y' }, { rhs: '-ypp-yp-y' },
        { rhs: 'sin(x)' }, { rhs: 'y' }, { rhs: '-3*ypp+3*yp-y' },
        { rhs: '-ypp-y' }, { rhs: 'exp(x)' }
    ];
    var randomFourth = [
        { rhs: '-y' }, { rhs: '1' }, { rhs: 'y' }, { rhs: '-2*ypp-y' },
        { rhs: '-ypp' }, { rhs: 'sin(x)' }, { rhs: '-4*yppp+6*ypp-4*yp+y' },
        { rhs: 'cos(x)' }
    ];
    var randomFifth = randomFourth; // reuse order 4 pool for order 5

    var randomFirst = [
        { rhs: 'y' }, { rhs: '-2*x*y' }, { rhs: 'y*(1-y)' },
        { rhs: '4-2*y', ic: true, x0: '0', y0: '1' },
        { rhs: 'sin(x)/y' }, { rhs: '(x-y)/x' },
        { rhs: 'y**2', ic: true, x0: '0', y0: '1' },
        { rhs: 'x+y', ic: true, x0: '0', y0: '0' },
        { rhs: 'x*y' }, { rhs: '-y+x**2' },
        { rhs: 'exp(-x)*y' }, { rhs: 'y/x' },
        { rhs: 'x**2+y**2' }, { rhs: 'cos(x)-y' },
        { rhs: '1/(1+y**2)', ic: true, x0: '0', y0: '0' },
        { rhs: 'x*exp(-y)' }
    ];
    var randomSecond = [
        { rhs: '-y' }, { rhs: 'y' }, { rhs: '-2*yp-y' },
        { rhs: '3*yp-2*y' }, { rhs: '-y+cos(x)' },
        { rhs: '-4*y+8', ic: true, x0: '0', y0: '0', dy0: '0' },
        { rhs: 'y+exp(x)' },
        { rhs: '-y+sin(x)', ic: true, x0: '0', y0: '1', dy0: '0' },
        { rhs: '-9*y' }, { rhs: '-yp-2*y' },
        { rhs: '-3*yp-2*y+sin(x)' }, { rhs: '-y+x' },
        { rhs: '2*yp-y+exp(x)' }, { rhs: '-4*yp-4*y' },
        { rhs: '-yp+y+cos(2*x)' }, { rhs: '-5*yp-6*y' }
    ];
    var randomField = [
        { rhs: 'x+y' }, { rhs: '-x/y' }, { rhs: 'x*y' },
        { rhs: 'y*(1-y)' }, { rhs: 'sin(x)' }, { rhs: 'x**2-y' },
        { rhs: 'x/y' }, { rhs: '(x-y)/(x+y)' },
        { rhs: 'y-x' }, { rhs: '-y/x' }, { rhs: 'x-y**2' },
        { rhs: 'sin(y)' }, { rhs: 'cos(x)*y' },
        { rhs: 'exp(-x)*y' }, { rhs: 'x**2+y' }, { rhs: '-x*y' }
    ];

    // ========== Random Button ==========
    document.getElementById('ode-random-btn').addEventListener('click', function() {
        if (currentMode === 'first') {
            var ex = randomFirst[Math.floor(Math.random() * randomFirst.length)];
            firstOrderInput.value = ex.rhs;
            if (ex.ic) {
                firstICCheck.checked = true;
                firstICFields.classList.add('open');
                firstICx0.value = ex.x0 || '0';
                firstICy0.value = ex.y0 || '0';
            } else {
                firstICCheck.checked = false;
                firstICFields.classList.remove('open');
            }
        } else if (currentMode === 'second') {
            var pool;
            if (currentOrder === 3) pool = randomThird;
            else if (currentOrder === 4) pool = randomFourth;
            else if (currentOrder === 5) pool = randomFifth;
            else pool = randomSecond;
            var ex = pool[Math.floor(Math.random() * pool.length)];
            secondOrderInput.value = ex.rhs;
            if (ex.ic) {
                secondICCheck.checked = true;
                secondICFields.classList.add('open');
                secondICx0.value = ex.x0 || '0';
                secondICy0.value = ex.y0 || '0';
                secondICdy0.value = ex.dy0 || '0';
            } else {
                secondICCheck.checked = false;
                secondICFields.classList.remove('open');
            }
        } else {
            var ex = randomField[Math.floor(Math.random() * randomField.length)];
            fieldInput.value = ex.rhs;
        }
        updatePreview();
    });

    function updateExamples() {
        var container = document.getElementById('ode-examples');
        var html = '';
        if (currentMode === 'first') {
            for (var i = 0; i < firstExamples.length; i++) {
                var ex = firstExamples[i];
                html += '<button type="button" class="ode-example-chip" data-rhs="' + escapeHtml(ex.rhs) + '"'
                    + (ex.ic ? ' data-ic="1" data-x0="' + ex.x0 + '" data-y0="' + ex.y0 + '"' : '')
                    + '>' + escapeHtml(ex.label) + '</button>';
            }
        } else if (currentMode === 'second') {
            var exArr;
            if (currentOrder === 3) exArr = thirdExamples;
            else if (currentOrder === 4) exArr = fourthExamples;
            else if (currentOrder === 5) exArr = fifthExamples;
            else exArr = secondExamples;
            for (var i = 0; i < exArr.length; i++) {
                var ex = exArr[i];
                html += '<button type="button" class="ode-example-chip" data-rhs="' + escapeHtml(ex.rhs) + '"'
                    + (ex.ic ? ' data-ic="1" data-x0="' + ex.x0 + '" data-y0="' + ex.y0 + '" data-dy0="' + (ex.dy0 || '0') + '"' : '')
                    + '>' + escapeHtml(ex.label) + '</button>';
            }
        } else {
            for (var i = 0; i < fieldExamples.length; i++) {
                var ex = fieldExamples[i];
                html += '<button type="button" class="ode-example-chip" data-rhs="' + escapeHtml(ex.rhs) + '">' + escapeHtml(ex.label) + '</button>';
            }
        }
        container.innerHTML = html;
    }
    updateExamples();

    document.getElementById('ode-examples').addEventListener('click', function(e) {
        var chip = e.target.closest('.ode-example-chip');
        if (!chip) return;
        var rhs = chip.getAttribute('data-rhs');
        if (currentMode === 'first') {
            firstOrderInput.value = rhs;
            if (chip.getAttribute('data-ic') === '1') {
                firstICCheck.checked = true;
                firstICFields.classList.add('open');
                firstICx0.value = chip.getAttribute('data-x0') || '0';
                firstICy0.value = chip.getAttribute('data-y0') || '0';
            } else {
                firstICCheck.checked = false;
                firstICFields.classList.remove('open');
            }
        } else if (currentMode === 'second') {
            secondOrderInput.value = rhs;
            if (chip.getAttribute('data-ic') === '1') {
                secondICCheck.checked = true;
                secondICFields.classList.add('open');
                secondICx0.value = chip.getAttribute('data-x0') || '0';
                secondICy0.value = chip.getAttribute('data-y0') || '0';
                secondICdy0.value = chip.getAttribute('data-dy0') || '0';
            } else {
                secondICCheck.checked = false;
                secondICFields.classList.remove('open');
            }
        } else {
            fieldInput.value = rhs;
        }
        updatePreview();
    });

    // ========== Live Preview ==========
    var previewTimer = null;
    function bindPreviewInput(el) {
        if (!el) return;
        el.addEventListener('input', function() {
            clearTimeout(previewTimer);
            previewTimer = setTimeout(updatePreview, 200);
        });
    }
    bindPreviewInput(firstOrderInput);
    bindPreviewInput(secondOrderInput);
    bindPreviewInput(fieldInput);
    bindPreviewInput(firstICx0);
    bindPreviewInput(firstICy0);
    bindPreviewInput(secondICx0);
    bindPreviewInput(secondICy0);
    bindPreviewInput(secondICdy0);
    // Also update preview when IC checkboxes toggle
    if (firstICCheck) firstICCheck.addEventListener('change', function() { updatePreview(); });
    if (secondICCheck) secondICCheck.addEventListener('change', function() { updatePreview(); });

    function buildLeibnizLHS(order) {
        if (order === 1) return '\\frac{dy}{dx}';
        return '\\frac{d^{' + order + '}y}{dx^{' + order + '}}';
    }

    function buildICLatex(order, x0, vals) {
        var parts = [];
        parts.push('y(' + x0 + ')=' + (vals[0] || '0'));
        for (var i = 1; i < order; i++) {
            var v = vals[i] || '0';
            if (i === 1) parts.push("y'(" + x0 + ')=' + v);
            else if (i === 2) parts.push("y''(" + x0 + ')=' + v);
            else if (i === 3) parts.push("y'''(" + x0 + ')=' + v);
            else parts.push('y^{(' + i + ')}(' + x0 + ')=' + v);
        }
        return parts.join(',\\; ');
    }

    function updatePreview() {
        try {
            var latex;
            if (currentMode === 'first') {
                var expr = normalizeExpr(firstOrderInput.value.trim());
                if (!expr) {
                    previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Enter RHS of dy/dx = f(x,y)\u2026</span>';
                    return;
                }
                latex = buildLeibnizLHS(1) + ' = ' + exprToLatex(expr);
                // Append IC if checked
                if (firstICCheck && firstICCheck.checked) {
                    var x0 = firstICx0.value.trim() || '0';
                    var y0 = firstICy0.value.trim() || '0';
                    latex += ',\\quad y(' + x0 + ')=' + y0;
                }
            } else if (currentMode === 'second') {
                var n = currentOrder;
                var expr = normalizeExpr(secondOrderInput.value.trim());
                if (!expr) {
                    previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Enter RHS of ' + getDerivNotation(n) + ' = f(x,y,\u2026)\u2026</span>';
                    return;
                }
                latex = buildLeibnizLHS(n) + ' = ' + exprToLatex(expr);
                // Append ICs if checked
                if (secondICCheck && secondICCheck.checked) {
                    var x0 = secondICx0.value.trim() || '0';
                    var icVals = [secondICy0.value.trim() || '0', secondICdy0.value.trim() || '0'];
                    // Gather extra IC field values
                    for (var i = 2; i < n; i++) {
                        var el = document.getElementById('ode-second-ic-d' + i + 'y0');
                        icVals.push(el ? el.value.trim() || '0' : '0');
                    }
                    latex += ',\\quad ' + buildICLatex(n, x0, icVals);
                }
            } else {
                var expr = normalizeExpr(fieldInput.value.trim());
                if (!expr) {
                    previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Enter RHS of dy/dx = f(x,y)\u2026</span>';
                    return;
                }
                latex = "\\frac{dy}{dx} = " + exprToLatex(expr);
            }
            katex.render(latex, previewEl, { displayMode: true, throwOnError: false });
        } catch (e) {
            previewEl.innerHTML = '<span style="color:var(--text-muted);font-size:0.8125rem;">Invalid expression</span>';
        }
    }

    // ========== Build SymPy Code ==========
    function buildSympyCode(mode) {
        var code = 'from sympy import *\nimport json, numpy as np\n\n';
        code += 'x = symbols("x")\n';
        code += 'y = Function("y")\n\n';

        if (mode === 'first') {
            var rhs = exprToPython(normalizeExpr(firstOrderInput.value.trim()));
            var hasIC = firstICCheck.checked;
            var x0 = firstICx0.value.trim() || '0';
            var y0 = firstICy0.value.trim() || '0';

            code += '_ns = {"x": x, "y": y(x), "sin": sin, "cos": cos, "tan": tan, "exp": exp, "log": log, "sqrt": sqrt, "pi": pi, "e": E, "asin": asin, "acos": acos, "atan": atan, "sinh": sinh, "cosh": cosh, "tanh": tanh, "Abs": Abs}\n';
            code += 'rhs_expr = eval("' + rhs.replace(/\\/g, '\\\\').replace(/"/g, '\\"') + '", {"__builtins__": {}}, _ns)\n';
            code += 'ode = Eq(y(x).diff(x), rhs_expr)\n\n';

            code += 'try:\n';
            code += '    classification = classify_ode(ode, y(x))\n';
            code += '    cls_str = ", ".join(classification[:3]) if len(classification) > 3 else ", ".join(classification)\n';
            code += 'except:\n';
            code += '    cls_str = "unknown"\n\n';

            if (hasIC) {
                code += 'try:\n';
                code += '    sol = dsolve(ode, y(x), ics={y(' + x0 + '): ' + y0 + '})\n';
                code += 'except:\n';
                code += '    try:\n';
                code += '        sol_gen = dsolve(ode, y(x))\n';
                code += '        C1 = symbols("C1")\n';
                code += '        eq = sol_gen.rhs.subs(x, ' + x0 + ') - ' + y0 + '\n';
                code += '        c1_val = solve(eq, C1)\n';
                code += '        if c1_val:\n';
                code += '            sol = Eq(y(x), sol_gen.rhs.subs(C1, c1_val[0]))\n';
                code += '        else:\n';
                code += '            sol = sol_gen\n';
                code += '    except Exception as e:\n';
                code += '        print("ERROR:" + str(e))\n';
                code += '        import sys; sys.exit(0)\n\n';
            } else {
                code += 'try:\n';
                code += '    sol = dsolve(ode, y(x))\n';
                code += 'except Exception as e:\n';
                code += '    print("ERROR:" + str(e))\n';
                code += '    import sys; sys.exit(0)\n\n';
            }

            code += 'try:\n';
            code += '    verified = checkodesol(ode, sol)[0]\n';
            code += 'except:\n';
            code += '    verified = False\n\n';

            code += 'print("RESULT:" + latex(sol))\n';
            code += 'print("TEXT:" + str(sol))\n';
            code += 'print("CLASSIFY:" + cls_str)\n';
            code += 'print("VERIFIED:" + str(verified))\n';
            code += 'print("ODE:" + latex(ode))\n\n';

            // Steps
            code += 'steps = []\n';
            code += 'steps.append({"title": "Given ODE", "latex": latex(ode)})\n';
            code += 'steps.append({"title": "Classification", "latex": "\\\\text{" + cls_str.replace("_", " ") + "}"})\n';
            if (hasIC) {
                code += 'steps.append({"title": "Initial condition", "latex": "y(' + x0 + ') = ' + y0 + '"})\n';
            }
            code += 'steps.append({"title": "Solution", "latex": latex(sol)})\n';
            code += 'steps.append({"title": "Verification", "latex": "\\\\text{Verified: " + str(verified) + "}"})\n';
            code += 'print("STEPS:" + json.dumps(steps))\n\n';

            // Plot data
            code += 'try:\n';
            code += '    from sympy import lambdify\n';
            code += '    C1 = symbols("C1")\n';
            code += '    sol_rhs = sol.rhs\n';
            code += '    if C1 in sol_rhs.free_symbols:\n';
            code += '        sol_rhs = sol_rhs.subs(C1, 1)\n';
            code += '    f_num = lambdify(x, sol_rhs, modules=["numpy"])\n';
            code += '    x_vals = np.linspace(-5, 5, 300)\n';
            code += '    y_vals = np.array([float(f_num(xi)) if np.isfinite(f_num(xi)) else float("nan") for xi in x_vals])\n';
            code += '    y_vals = np.clip(y_vals, -50, 50)\n';
            code += '    mask = np.isfinite(y_vals)\n';
            code += '    print("PLOT_X:" + json.dumps(x_vals[mask].tolist()))\n';
            code += '    print("PLOT_Y:" + json.dumps(y_vals[mask].tolist()))\n';
            code += 'except Exception as e:\n';
            code += '    print("PLOT_X:[]")\n';
            code += '    print("PLOT_Y:[]")\n';

        } else if (mode === 'second') {
            var n = currentOrder;
            var rhs = exprToPython(normalizeExpr(secondOrderInput.value.trim()));
            var hasIC = secondICCheck.checked;
            var x0 = secondICx0.value.trim() || '0';
            var y0 = secondICy0.value.trim() || '0';
            var dy0 = secondICdy0.value.trim() || '0';

            // Build namespace with derivative aliases based on order
            var nsEntries = '"x": x, "y": y(x), "yp": y(x).diff(x)';
            if (n >= 2) nsEntries += ', "ypp": y(x).diff(x, 2)';
            if (n >= 3) nsEntries += ', "yppp": y(x).diff(x, 3)';
            if (n >= 4) nsEntries += ', "y4": y(x).diff(x, 4)';
            if (n >= 5) nsEntries += ', "y5": y(x).diff(x, 5)';
            nsEntries += ', "sin": sin, "cos": cos, "tan": tan, "exp": exp, "log": log, "sqrt": sqrt, "pi": pi, "e": E, "asin": asin, "acos": acos, "atan": atan, "sinh": sinh, "cosh": cosh, "tanh": tanh, "Abs": Abs';
            code += '_ns = {' + nsEntries + '}\n';
            code += 'rhs_expr = eval("' + rhs.replace(/\\/g, '\\\\').replace(/"/g, '\\"') + '", {"__builtins__": {}}, _ns)\n';
            code += 'ode = Eq(y(x).diff(x, ' + n + '), rhs_expr)\n\n';

            code += 'try:\n';
            code += '    classification = classify_ode(ode, y(x))\n';
            code += '    cls_str = ", ".join(classification[:3]) if len(classification) > 3 else ", ".join(classification)\n';
            code += 'except:\n';
            code += '    cls_str = "unknown"\n\n';

            if (hasIC) {
                // Build ICS dict
                var icsDict = 'y(' + x0 + '): ' + y0;
                icsDict += ', y(x).diff(x).subs(x, ' + x0 + '): ' + dy0;
                for (var i = 2; i < n; i++) {
                    var el = document.getElementById('ode-second-ic-d' + i + 'y0');
                    var val = el ? el.value.trim() || '0' : '0';
                    icsDict += ', y(x).diff(x, ' + i + ').subs(x, ' + x0 + '): ' + val;
                }

                code += 'try:\n';
                code += '    sol = dsolve(ode, y(x), ics={' + icsDict + '})\n';
                code += 'except:\n';
                code += '    try:\n';
                code += '        sol_gen = dsolve(ode, y(x))\n';
                // Build constants list
                var cSyms = [];
                for (var ci = 1; ci <= n; ci++) cSyms.push('C' + ci);
                code += '        ' + cSyms.join(', ') + ' = symbols("' + cSyms.join(' ') + '")\n';
                // Build equations for each IC
                code += '        eq_ic = []\n';
                code += '        eq_ic.append(sol_gen.rhs.subs(x, ' + x0 + ') - ' + y0 + ')\n';
                code += '        eq_ic.append(diff(sol_gen.rhs, x).subs(x, ' + x0 + ') - ' + dy0 + ')\n';
                for (var i = 2; i < n; i++) {
                    var el = document.getElementById('ode-second-ic-d' + i + 'y0');
                    var val = el ? el.value.trim() || '0' : '0';
                    code += '        eq_ic.append(diff(sol_gen.rhs, x, ' + i + ').subs(x, ' + x0 + ') - ' + val + ')\n';
                }
                code += '        consts = solve(eq_ic, [' + cSyms.join(', ') + '])\n';
                code += '        if consts:\n';
                code += '            sol = Eq(y(x), sol_gen.rhs.subs(consts))\n';
                code += '        else:\n';
                code += '            sol = sol_gen\n';
                code += '    except Exception as e:\n';
                code += '        print("ERROR:" + str(e))\n';
                code += '        import sys; sys.exit(0)\n\n';
            } else {
                code += 'try:\n';
                code += '    sol = dsolve(ode, y(x))\n';
                code += 'except Exception as e:\n';
                code += '    print("ERROR:" + str(e))\n';
                code += '    import sys; sys.exit(0)\n\n';
            }

            code += 'try:\n';
            code += '    verified = checkodesol(ode, sol)[0]\n';
            code += 'except:\n';
            code += '    verified = False\n\n';

            code += 'print("RESULT:" + latex(sol))\n';
            code += 'print("TEXT:" + str(sol))\n';
            code += 'print("CLASSIFY:" + cls_str)\n';
            code += 'print("VERIFIED:" + str(verified))\n';
            code += 'print("ODE:" + latex(ode))\n';
            code += 'print("ORDER:' + n + '")\n\n';

            // Steps
            code += 'steps = []\n';
            code += 'steps.append({"title": "Given ODE", "latex": latex(ode)})\n';
            code += 'steps.append({"title": "Classification", "latex": "\\\\text{" + cls_str.replace("_", " ") + "}"})\n';
            if (hasIC) {
                var icLatexParts = ['y(' + x0 + ') = ' + y0, "y\\'(" + x0 + ') = ' + dy0];
                for (var i = 2; i < n; i++) {
                    var el = document.getElementById('ode-second-ic-d' + i + 'y0');
                    var val = el ? el.value.trim() || '0' : '0';
                    if (i === 2) icLatexParts.push("y\\'\\'(" + x0 + ') = ' + val);
                    else if (i === 3) icLatexParts.push("y\\'\\'\\'(" + x0 + ') = ' + val);
                    else icLatexParts.push('y^{(' + i + ')}(' + x0 + ') = ' + val);
                }
                code += 'steps.append({"title": "Initial conditions", "latex": "' + icLatexParts.join(',\\\\; ') + '"})\n';
            }
            code += 'steps.append({"title": "Solution", "latex": latex(sol)})\n';
            code += 'steps.append({"title": "Verification", "latex": "\\\\text{Verified: " + str(verified) + "}"})\n';
            code += 'print("STEPS:" + json.dumps(steps))\n\n';

            // Plot data
            code += 'try:\n';
            code += '    from sympy import lambdify\n';
            var cSymsPlot = [];
            for (var ci = 1; ci <= n; ci++) cSymsPlot.push('C' + ci);
            code += '    ' + cSymsPlot.join(', ') + ' = symbols("' + cSymsPlot.join(' ') + '")\n';
            code += '    sol_rhs = sol.rhs\n';
            for (var ci = 0; ci < cSymsPlot.length; ci++) {
                var cName = cSymsPlot[ci];
                var defaultVal = ci === 0 ? '1' : '0';
                code += '    if ' + cName + ' in sol_rhs.free_symbols:\n';
                code += '        sol_rhs = sol_rhs.subs(' + cName + ', ' + defaultVal + ')\n';
            }
            code += '    f_num = lambdify(x, sol_rhs, modules=["numpy"])\n';
            code += '    x_vals = np.linspace(-5, 5, 300)\n';
            code += '    y_vals = np.array([float(f_num(xi)) if np.isfinite(f_num(xi)) else float("nan") for xi in x_vals])\n';
            code += '    y_vals = np.clip(y_vals, -50, 50)\n';
            code += '    mask = np.isfinite(y_vals)\n';
            code += '    print("PLOT_X:" + json.dumps(x_vals[mask].tolist()))\n';
            code += '    print("PLOT_Y:" + json.dumps(y_vals[mask].tolist()))\n';
            code += 'except Exception as e:\n';
            code += '    print("PLOT_X:[]")\n';
            code += '    print("PLOT_Y:[]")\n';

        } else {
            // Direction field mode
            var rhs = exprToPython(normalizeExpr(fieldInput.value.trim()));
            var xmin = parseFloat(fieldXmin.value) || -5;
            var xmax = parseFloat(fieldXmax.value) || 5;
            var ymin = parseFloat(fieldYmin.value) || -5;
            var ymax = parseFloat(fieldYmax.value) || 5;
            var hasCurve = fieldCurveCheck.checked;
            var cx0 = fieldCurveX0.value.trim() || '0';
            var cy0 = fieldCurveY0.value.trim() || '0';

            code += 'from sympy import Symbol\n';
            code += 'y_sym = Symbol("y")\n';
            code += '_ns = {"x": x, "y": y_sym, "sin": sin, "cos": cos, "tan": tan, "exp": exp, "log": log, "sqrt": sqrt, "pi": pi, "e": E, "asin": asin, "acos": acos, "atan": atan, "Abs": Abs}\n';
            code += 'rhs_expr = eval("' + rhs.replace(/\\/g, '\\\\').replace(/"/g, '\\"') + '", {"__builtins__": {}}, _ns)\n\n';

            code += 'f_num = lambdify((x, y_sym), rhs_expr, modules=["numpy"])\n\n';

            code += 'N = 20\n';
            code += 'x_grid = np.linspace(' + xmin + ', ' + xmax + ', N)\n';
            code += 'y_grid = np.linspace(' + ymin + ', ' + ymax + ', N)\n';
            code += 'X, Y = np.meshgrid(x_grid, y_grid)\n';
            code += 'try:\n';
            code += '    U = np.ones_like(X)\n';
            code += '    V = np.vectorize(lambda xi, yi: float(f_num(xi, yi)))(X, Y)\n';
            code += '    mag = np.sqrt(U**2 + V**2)\n';
            code += '    mag[mag == 0] = 1\n';
            code += '    U = U / mag\n';
            code += '    V = V / mag\n';
            code += '    V = np.clip(V, -10, 10)\n';
            code += '    U = np.clip(U, -10, 10)\n';
            code += 'except Exception as e:\n';
            code += '    print("ERROR:" + str(e))\n';
            code += '    import sys; sys.exit(0)\n\n';

            code += 'print("FIELD_X:" + json.dumps(X.flatten().tolist()))\n';
            code += 'print("FIELD_Y:" + json.dumps(Y.flatten().tolist()))\n';
            code += 'print("FIELD_U:" + json.dumps(U.flatten().tolist()))\n';
            code += 'print("FIELD_V:" + json.dumps(V.flatten().tolist()))\n';

            if (hasCurve) {
                code += '\n# Solution curve via Euler method\n';
                code += 'try:\n';
                code += '    cx0, cy0 = ' + cx0 + ', ' + cy0 + '\n';
                code += '    dt = 0.05\n';
                code += '    curve_x, curve_y = [cx0], [cy0]\n';
                code += '    # Forward\n';
                code += '    xc, yc = cx0, cy0\n';
                code += '    for _ in range(200):\n';
                code += '        try:\n';
                code += '            s = float(f_num(xc, yc))\n';
                code += '            if not np.isfinite(s) or abs(s) > 1e6: break\n';
                code += '        except: break\n';
                code += '        xc += dt\n';
                code += '        yc += dt * s\n';
                code += '        if abs(yc) > 50 or xc > ' + xmax + ': break\n';
                code += '        curve_x.append(xc)\n';
                code += '        curve_y.append(yc)\n';
                code += '    # Backward\n';
                code += '    xc, yc = cx0, cy0\n';
                code += '    bx, by = [], []\n';
                code += '    for _ in range(200):\n';
                code += '        try:\n';
                code += '            s = float(f_num(xc, yc))\n';
                code += '            if not np.isfinite(s) or abs(s) > 1e6: break\n';
                code += '        except: break\n';
                code += '        xc -= dt\n';
                code += '        yc -= dt * s\n';
                code += '        if abs(yc) > 50 or xc < ' + xmin + ': break\n';
                code += '        bx.insert(0, xc)\n';
                code += '        by.insert(0, yc)\n';
                code += '    curve_x = bx + curve_x\n';
                code += '    curve_y = by + curve_y\n';
                code += '    print("CURVE_X:" + json.dumps(curve_x))\n';
                code += '    print("CURVE_Y:" + json.dumps(curve_y))\n';
                code += 'except Exception as e:\n';
                code += '    pass\n';
            }

            code += '\nprint("RESULT:Direction field computed")\n';
            code += 'print("TEXT:dy/dx = ' + rhs.replace(/"/g, '\\"') + '")\n';
        }
        return code;
    }

    // ========== Compute ==========
    computeBtn.addEventListener('click', doCompute);
    firstOrderInput.addEventListener('keydown', function(e) { if (e.key === 'Enter') doCompute(); });
    secondOrderInput.addEventListener('keydown', function(e) { if (e.key === 'Enter') doCompute(); });
    fieldInput.addEventListener('keydown', function(e) { if (e.key === 'Enter') doCompute(); });

    function doCompute() {
        var valid = false;
        if (currentMode === 'first') valid = !!firstOrderInput.value.trim();
        else if (currentMode === 'second') valid = !!secondOrderInput.value.trim();
        else valid = !!fieldInput.value.trim();

        if (!valid) {
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Please enter an expression.', 2000, 'warning');
            return;
        }

        resultActions.classList.remove('visible');
        var orderNames2 = { 2: 'second', 3: 'third', 4: 'fourth', 5: 'fifth' };
        var modeLabels = { first: 'first-order ODE', second: (orderNames2[currentOrder] || currentOrder + 'th') + '-order ODE', field: 'direction field' };
        resultContent.innerHTML = '<div style="text-align:center;padding:2rem;">' +
            '<div class="ode-spinner" style="width:24px;height:24px;border-width:3px;margin:0 auto 1rem;"></div>' +
            '<p style="color:var(--text-secondary);font-size:0.9375rem;">Solving ' + modeLabels[currentMode] + '...</p></div>';
        if (emptyState) emptyState.style.display = 'none';

        var code = buildSympyCode(currentMode);
        var mode = currentMode;

        var controller = new AbortController();
        var timeoutId = setTimeout(function() { controller.abort(); }, 90000);

        fetch((window.ODE_CALC_CTX || '') + '/OneCompilerFunctionality?action=execute', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ language: 'python', version: '3.10', code: code }),
            signal: controller.signal
        })
        .then(function(r) { return r.json(); })
        .then(function(data) {
            clearTimeout(timeoutId);
            var stdout = (data.Stdout || data.stdout || '').trim();
            var stderr = (data.Stderr || data.stderr || '').trim();

            if (!stdout || (stderr && /error|exception|traceback/i.test(stderr) && !stdout)) {
                showError(stderr || 'Computation failed. Check your input.');
                return;
            }

            var errMatch = stdout.match(/ERROR:(.+)/);
            if (errMatch) {
                showError(errMatch[1].trim());
                return;
            }

            parseAndShowResult(mode, stdout);
        })
        .catch(function(err) {
            clearTimeout(timeoutId);
            showError(err.name === 'AbortError' ? 'Request timed out' : err.message);
        });
    }

    // ========== Parse & Display Result ==========
    function parseAndShowResult(mode, stdout) {
        var stepsMatch = stdout.match(/STEPS:(\[[\s\S]*?\])(?=\n|$)/);
        var steps = [];
        try { if (stepsMatch) steps = JSON.parse(stepsMatch[1]); } catch(e) {}

        var rMatch = stdout.match(/RESULT:([^\n]*)/);
        var tMatch = stdout.match(/TEXT:([^\n]*)/);
        var result = rMatch ? rMatch[1].trim() : '';
        var text = tMatch ? tMatch[1].trim() : result;

        if (mode === 'first' || mode === 'second') {
            var classifyMatch = stdout.match(/CLASSIFY:([^\n]*)/);
            var verifiedMatch = stdout.match(/VERIFIED:([^\n]*)/);
            var classify = classifyMatch ? classifyMatch[1].trim() : '';
            var verified = verifiedMatch ? verifiedMatch[1].trim() === 'True' : false;

            showODEResult(result, text, classify, verified, steps, mode);

            // Graph: solution curve
            var plotXMatch = stdout.match(/PLOT_X:(\[[\s\S]*?\])(?=\n|$)/);
            var plotYMatch = stdout.match(/PLOT_Y:(\[[\s\S]*?\])(?=\n|$)/);
            var plotX = [], plotY = [];
            try { if (plotXMatch) plotX = JSON.parse(plotXMatch[1]); } catch(e) {}
            try { if (plotYMatch) plotY = JSON.parse(plotYMatch[1]); } catch(e) {}

            if (plotX.length > 0) {
                pendingGraph = { type: 'solution', x: plotX, y: plotY };
                if (graphHint) graphHint.style.display = 'none';
                var graphPanel = document.getElementById('ode-panel-graph');
                if (graphPanel.classList.contains('active')) {
                    loadPlotly(function() { renderGraph(pendingGraph); });
                }
            }
        } else {
            // Direction field
            showFieldResult(text, stdout);

            var fxMatch = stdout.match(/FIELD_X:(\[[\s\S]*?\])(?=\n|$)/);
            var fyMatch = stdout.match(/FIELD_Y:(\[[\s\S]*?\])(?=\n|$)/);
            var fuMatch = stdout.match(/FIELD_U:(\[[\s\S]*?\])(?=\n|$)/);
            var fvMatch = stdout.match(/FIELD_V:(\[[\s\S]*?\])(?=\n|$)/);
            var fieldX = [], fieldY = [], fieldU = [], fieldV = [];
            try { if (fxMatch) fieldX = JSON.parse(fxMatch[1]); } catch(e) {}
            try { if (fyMatch) fieldY = JSON.parse(fyMatch[1]); } catch(e) {}
            try { if (fuMatch) fieldU = JSON.parse(fuMatch[1]); } catch(e) {}
            try { if (fvMatch) fieldV = JSON.parse(fvMatch[1]); } catch(e) {}

            var curveXMatch = stdout.match(/CURVE_X:(\[[\s\S]*?\])(?=\n|$)/);
            var curveYMatch = stdout.match(/CURVE_Y:(\[[\s\S]*?\])(?=\n|$)/);
            var curveX = [], curveY = [];
            try { if (curveXMatch) curveX = JSON.parse(curveXMatch[1]); } catch(e) {}
            try { if (curveYMatch) curveY = JSON.parse(curveYMatch[1]); } catch(e) {}

            if (fieldX.length > 0) {
                pendingGraph = { type: 'field', fx: fieldX, fy: fieldY, fu: fieldU, fv: fieldV, curveX: curveX, curveY: curveY };
                if (graphHint) graphHint.style.display = 'none';
                // Auto-switch to graph tab for direction fields
                var graphTab = document.querySelector('.ode-output-tab[data-panel="graph"]');
                if (graphTab) graphTab.click();
            }
        }

        resultActions.classList.add('visible');
    }

    function showODEResult(resultLatex, resultText, classify, verified, steps, mode) {
        lastResultLatex = resultLatex;
        lastResultText = resultText;

        var orderLabel;
        if (mode === 'first') {
            orderLabel = 'First-Order';
        } else {
            var orderNames = { 2: 'Second', 3: 'Third', 4: 'Fourth', 5: 'Fifth' };
            orderLabel = (orderNames[currentOrder] || currentOrder + 'th') + '-Order';
        }
        var html = '<div class="ode-result-math">';
        html += '<div class="ode-result-label">' + orderLabel + ' ODE Solution</div>';
        html += '<div class="ode-result-main" id="ode-r-result"></div>';
        html += '<div class="ode-result-detail">';
        html += '<span class="ode-method-badge">SymPy dsolve</span>';
        if (classify) {
            var cls = classify.split(',')[0].trim().replace(/_/g, ' ');
            html += '<span class="ode-classify-badge">' + escapeHtml(cls) + '</span>';
        }
        if (verified) {
            html += '<span class="ode-verified-badge">\u2713 Verified</span>';
        }
        html += '</div>';
        html += '<button type="button" class="ode-steps-btn" id="ode-steps-btn">&#128221; Show Steps</button>';
        html += '<div id="ode-steps-area"></div>';
        html += '</div>';
        resultContent.innerHTML = html;

        try {
            katex.render(prepareLatexForKatex(resultLatex), document.getElementById('ode-r-result'), { displayMode: true, throwOnError: false });
        } catch(e) {
            document.getElementById('ode-r-result').textContent = resultText;
        }

        var stepsBtn = document.getElementById('ode-steps-btn');
        if (stepsBtn) {
            stepsBtn.addEventListener('click', function() {
                renderSteps(steps);
                this.style.display = 'none';
            });
        }

        // Show scroll hint if the result math overflows horizontally
        requestAnimationFrame(function() {
            var mainEl = document.getElementById('ode-r-result');
            if (mainEl && mainEl.scrollWidth > mainEl.clientWidth + 4) {
                var hint = document.createElement('div');
                hint.className = 'ode-result-scroll-hint';
                hint.textContent = '\u2190 scroll to see full solution \u2192';
                mainEl.parentElement.insertBefore(hint, mainEl.nextSibling);
            }
        });
    }

    function showFieldResult(text, stdout) {
        lastResultLatex = text;
        lastResultText = text;

        var html = '<div class="ode-result-math">';
        html += '<div class="ode-result-label">Direction Field</div>';
        html += '<div class="ode-result-main" style="font-size:1.1rem;color:var(--tool-primary);">' + escapeHtml(text) + '</div>';
        html += '<div class="ode-result-detail"><span class="ode-method-badge">20\u00D720 Grid</span></div>';
        html += '<p style="font-size:0.8125rem;color:var(--text-secondary);margin-top:0.75rem;">Switch to the <strong>Graph</strong> tab to view the direction field plot.</p>';
        html += '</div>';
        resultContent.innerHTML = html;
    }

    // ========== Steps ==========
    function renderSteps(steps) {
        var container = document.getElementById('ode-steps-area');
        if (!container || !steps || steps.length === 0) {
            if (container) container.innerHTML = '<div style="padding:0.75rem;font-size:0.8125rem;color:var(--text-muted);">No steps available.</div>';
            return;
        }

        var html = '<div class="ode-steps-container">';
        html += '<div class="ode-steps-header">';
        html += '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;flex-shrink:0;"><path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>';
        html += 'Solution Steps <span style="font-weight:400;color:var(--text-muted);margin-left:0.25rem;">(' + steps.length + ')</span>';
        html += '<span class="ode-steps-sympy-badge">CAS</span>';
        html += '</div>';

        for (var i = 0; i < steps.length; i++) {
            html += '<div class="ode-step">';
            html += '<span class="ode-step-num">' + (i + 1) + '</span>';
            html += '<div class="ode-step-body">';
            html += '<div class="ode-step-title">' + escapeHtml(steps[i].title) + '</div>';
            html += '<div class="ode-step-math" id="ode-step-math-' + i + '"></div>';
            html += '</div></div>';
        }
        html += '</div>';
        container.innerHTML = html;

        for (var j = 0; j < steps.length; j++) {
            var el = document.getElementById('ode-step-math-' + j);
            if (el && steps[j].latex) {
                try {
                    katex.render(prepareLatexForKatex(steps[j].latex), el, { displayMode: true, throwOnError: false });
                } catch (e) {
                    el.textContent = steps[j].latex;
                }
            }
        }
    }

    // ========== Error State ==========
    function showError(msg) {
        resultActions.classList.remove('visible');
        var html = '<div class="ode-error">';
        html += '<h4>Computation Error</h4>';
        html += '<p>' + escapeHtml(msg) + '</p>';
        html += '<ul>';
        html += '<li>Check expression syntax (see Syntax Help)</li>';
        html += '<li>Use <code>y</code> for y(x), <code>yp</code> for y\', <code>ypp</code> for y\'\', <code>yppp</code> for y\'\'\', <code>y4</code>/<code>y5</code> for higher</li>';
        html += '<li>Use explicit multiplication: <code>2*x</code> not <code>2x</code></li>';
        html += '<li>Use <code>**</code> or <code>^</code> for powers</li>';
        html += '<li>Some ODEs may not have closed-form solutions</li>';
        html += '</ul>';
        html += '</div>';
        resultContent.innerHTML = html;
        if (emptyState) emptyState.style.display = 'none';
    }

    // ========== Graph ==========
    function renderGraph(cfg) {
        if (!window.Plotly || !cfg) return;
        var container = document.getElementById('ode-graph-container');
        var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
        var bgColor = isDark ? '#1e293b' : '#fff';
        var gridColor = isDark ? '#334155' : '#e2e8f0';
        var textColor = isDark ? '#cbd5e1' : '#475569';
        var zeroColor = isDark ? '#475569' : '#94a3b8';

        var layout = {
            margin: { t: 30, r: 20, b: 50, l: 60 },
            xaxis: { gridcolor: gridColor, color: textColor, zerolinecolor: zeroColor, title: 'x' },
            yaxis: { gridcolor: gridColor, color: textColor, zerolinecolor: zeroColor, title: 'y' },
            paper_bgcolor: bgColor,
            plot_bgcolor: bgColor,
            font: { family: 'Inter, sans-serif', size: 12, color: textColor },
            legend: { x: 0.02, y: 0.98 }
        };

        var traces = [];

        if (cfg.type === 'solution') {
            traces.push({
                x: cfg.x, y: cfg.y, type: 'scatter', mode: 'lines',
                line: { color: '#db2777', width: 2.5 }, name: 'y(x)'
            });
        } else if (cfg.type === 'field') {
            // Direction field as cone/quiver using annotations
            var scale = 0.3;
            var annotations = [];
            for (var i = 0; i < cfg.fx.length; i++) {
                if (!isFinite(cfg.fu[i]) || !isFinite(cfg.fv[i])) continue;
                annotations.push({
                    x: cfg.fx[i],
                    y: cfg.fy[i],
                    ax: cfg.fx[i] + scale * cfg.fu[i],
                    ay: cfg.fy[i] + scale * cfg.fv[i],
                    xref: 'x', yref: 'y', axref: 'x', ayref: 'y',
                    showarrow: true,
                    arrowhead: 2,
                    arrowsize: 1,
                    arrowwidth: 1.5,
                    arrowcolor: isDark ? '#94a3b8' : '#64748b'
                });
            }
            layout.annotations = annotations;

            // Add invisible trace for axis scaling
            traces.push({
                x: [cfg.fx[0], cfg.fx[cfg.fx.length - 1]],
                y: [cfg.fy[0], cfg.fy[cfg.fy.length - 1]],
                type: 'scatter', mode: 'markers',
                marker: { size: 0.1, opacity: 0 },
                showlegend: false
            });

            // Solution curve overlay
            if (cfg.curveX && cfg.curveX.length > 0) {
                traces.push({
                    x: cfg.curveX, y: cfg.curveY, type: 'scatter', mode: 'lines',
                    line: { color: '#db2777', width: 2.5 }, name: 'Solution curve'
                });
            }
        }

        Plotly.newPlot(container, traces, layout, { responsive: true, displayModeBar: true, modeBarButtonsToRemove: ['lasso2d', 'select2d'] });
    }

    // ========== Python Compiler ==========
    function buildCompilerCode() {
        var code = 'from sympy import *\n\nx = symbols("x")\ny = Function("y")\n\n';
        if (currentMode === 'first') {
            var rhs = exprToPython(normalizeExpr(firstOrderInput.value.trim())) || 'y(x)';
            code += '# First-order ODE: y\' = f(x, y)\n';
            code += 'ode = Eq(y(x).diff(x), ' + rhs.replace(/\by\b/g, 'y(x)') + ')\n';
            code += 'print("ODE:", ode)\n\n';
            code += '# Classify\n';
            code += 'print("Classification:", classify_ode(ode, y(x)))\n\n';
            code += '# Solve\n';
            code += 'sol = dsolve(ode, y(x))\n';
            code += 'print("Solution:", sol)\n\n';
            code += '# Verify\n';
            code += 'print("Verified:", checkodesol(ode, sol))\n';
        } else if (currentMode === 'second') {
            var n = currentOrder;
            var rhs = exprToPython(normalizeExpr(secondOrderInput.value.trim())) || '-y(x)';
            rhs = rhs.replace(/\byppp\b/g, "y(x).diff(x,3)").replace(/\bypp\b/g, "y(x).diff(x,2)").replace(/\byp\b/g, "y(x).diff(x)").replace(/\by5\b/g, "y(x).diff(x,5)").replace(/\by4\b/g, "y(x).diff(x,4)").replace(/\by\b/g, 'y(x)');
            var ordSuffix = { 2: 'Second', 3: 'Third', 4: 'Fourth', 5: 'Fifth' };
            code += '# ' + (ordSuffix[n] || n + 'th') + '-order ODE\n';
            code += 'ode = Eq(y(x).diff(x, ' + n + '), ' + rhs + ')\n';
            code += 'print("ODE:", ode)\n\n';
            code += '# Solve\n';
            code += 'sol = dsolve(ode, y(x))\n';
            code += 'print("Solution:", sol)\n\n';
            code += '# Verify\n';
            code += 'print("Verified:", checkodesol(ode, sol))\n';
        } else {
            var rhs = exprToPython(normalizeExpr(fieldInput.value.trim())) || 'x + y';
            code += 'import numpy as np\nimport matplotlib\nmatplotlib.use("Agg")\nimport matplotlib.pyplot as plt\n\n';
            code += '# Direction field for dy/dx = ' + rhs + '\n';
            code += 'x_sym, y_sym = symbols("x y")\n';
            code += 'f = lambdify((x_sym, y_sym), ' + rhs + ', "numpy")\n\n';
            code += 'X, Y = np.meshgrid(np.linspace(-5, 5, 20), np.linspace(-5, 5, 20))\n';
            code += 'U = np.ones_like(X)\n';
            code += 'V = f(X, Y)\n';
            code += 'N = np.sqrt(U**2 + V**2)\n';
            code += 'N[N == 0] = 1\n';
            code += 'print("Direction field computed for dy/dx =", "' + rhs + '")\n';
            code += 'print("Grid: 20x20 from (-5,-5) to (5,5)")\n';
        }
        return code;
    }

    function loadCompilerWithTemplate() {
        var code = buildCompilerCode();
        var b64Code = btoa(unescape(encodeURIComponent(code)));
        var config = JSON.stringify({ lang: 'python', code: b64Code });
        var iframe = document.getElementById('ode-compiler-iframe');
        iframe.src = (window.ODE_CALC_CTX || '') + '/onecompiler-embed.jsp?c=' + encodeURIComponent(config);
    }

    // ========== Copy / Share / PDF ==========
    document.getElementById('ode-copy-latex-btn').addEventListener('click', function() {
        if (typeof ToolUtils !== 'undefined') {
            ToolUtils.copyToClipboard(lastResultLatex, 'LaTeX copied!');
        } else {
            navigator.clipboard.writeText(lastResultLatex);
        }
    });

    document.getElementById('ode-download-pdf-btn').addEventListener('click', function() {
        downloadResultPdf();
    });

    function downloadResultPdf() {
        if (!lastResultLatex) {
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('No result to download', 2000, 'warning');
            return;
        }

        var container = document.createElement('div');
        container.style.cssText = 'position:absolute;left:-9999px;top:0;width:700px;padding:40px;background:#fff;font-family:Inter,-apple-system,BlinkMacSystemFont,sans-serif;color:#0f172a;';
        document.body.appendChild(container);

        var title = document.createElement('div');
        title.style.cssText = 'font-size:22px;font-weight:700;margin-bottom:8px;color:#db2777;';
        title.textContent = 'ODE Solver Calculator \u2014 8gwifi.org';
        container.appendChild(title);

        var divider = document.createElement('div');
        divider.style.cssText = 'height:2px;background:linear-gradient(90deg,#db2777,#f472b6,transparent);margin-bottom:24px;';
        container.appendChild(divider);

        var orderNamesP = { 2: 'Second', 3: 'Third', 4: 'Fourth', 5: 'Fifth' };
        var modeLabels = { first: 'First-Order ODE', second: (orderNamesP[currentOrder] || currentOrder + 'th') + '-Order ODE', field: 'Direction Field' };
        var qLabel = document.createElement('div');
        qLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:8px;';
        qLabel.textContent = modeLabels[currentMode];
        container.appendChild(qLabel);

        var aMath = document.createElement('div');
        aMath.style.cssText = 'font-size:22px;margin-bottom:16px;padding:16px;background:#fdf2f8;border-radius:8px;';
        container.appendChild(aMath);
        try {
            katex.render(prepareLatexForKatex(lastResultLatex), aMath, { displayMode: true, throwOnError: false });
        } catch (e) {
            aMath.textContent = lastResultText;
        }

        var stepsArea = document.getElementById('ode-steps-area');
        if (stepsArea && stepsArea.children.length > 0) {
            var stepsLabel = document.createElement('div');
            stepsLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:12px;border-top:1px solid #e2e8f0;padding-top:16px;';
            stepsLabel.textContent = 'Step-by-Step Solution';
            container.appendChild(stepsLabel);

            var stepEls = stepsArea.querySelectorAll('.ode-step');
            for (var i = 0; i < stepEls.length; i++) {
                var stepRow = document.createElement('div');
                stepRow.style.cssText = 'display:flex;gap:12px;margin-bottom:12px;';

                var stepNum = document.createElement('div');
                stepNum.style.cssText = 'width:24px;height:24px;background:#db2777;color:#fff;border-radius:50%;font-size:12px;font-weight:700;display:flex;align-items:center;justify-content:center;flex-shrink:0;';
                stepNum.textContent = (i + 1);
                stepRow.appendChild(stepNum);

                var stepBody = document.createElement('div');
                stepBody.style.cssText = 'flex:1;';

                var titleEl = stepEls[i].querySelector('.ode-step-title');
                if (titleEl) {
                    var sTitle = document.createElement('div');
                    sTitle.style.cssText = 'font-size:13px;font-weight:600;color:#334155;margin-bottom:4px;';
                    sTitle.textContent = titleEl.textContent;
                    stepBody.appendChild(sTitle);
                }

                var mathEl = stepEls[i].querySelector('.ode-step-math');
                if (mathEl) {
                    var sMath = document.createElement('div');
                    sMath.style.cssText = 'font-size:16px;';
                    var katexAnnotation = mathEl.querySelector('annotation');
                    if (katexAnnotation) {
                        katex.render(katexAnnotation.textContent, sMath, { displayMode: true, throwOnError: false });
                    } else {
                        sMath.innerHTML = mathEl.innerHTML;
                    }
                    stepBody.appendChild(sMath);
                }

                stepRow.appendChild(stepBody);
                container.appendChild(stepRow);
            }
        }

        var footer = document.createElement('div');
        footer.style.cssText = 'margin-top:24px;padding-top:12px;border-top:1px solid #e2e8f0;font-size:11px;color:#94a3b8;display:flex;justify-content:space-between;';
        footer.innerHTML = '<span>Generated by 8gwifi.org ODE Solver Calculator</span><span>' + new Date().toLocaleDateString() + '</span>';
        container.appendChild(footer);

        if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Generating PDF...', 1500, 'info');

        var loadHtml2Canvas = (typeof html2canvas !== 'undefined')
            ? Promise.resolve()
            : ToolUtils._loadScript('https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js');

        loadHtml2Canvas.then(function() {
            return ToolUtils._loadScript('https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js');
        }).then(function() {
            return html2canvas(container, { scale: 2, backgroundColor: '#ffffff', useCORS: true, logging: false });
        }).then(function(canvas) {
            document.body.removeChild(container);

            var imgData = canvas.toDataURL('image/png');
            var pdf = new jspdf.jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' });
            var pageWidth = pdf.internal.pageSize.getWidth();
            var pageHeight = pdf.internal.pageSize.getHeight();
            var margin = 10;
            var usableWidth = pageWidth - margin * 2;
            var imgWidth = usableWidth;
            var imgHeight = (canvas.height * usableWidth) / canvas.width;
            var usableHeight = pageHeight - margin * 2;
            if (imgHeight > usableHeight) {
                imgHeight = usableHeight;
                imgWidth = (canvas.width * usableHeight) / canvas.height;
            }
            var xPos = (pageWidth - imgWidth) / 2;
            pdf.addImage(imgData, 'PNG', xPos, margin, imgWidth, imgHeight);
            pdf.save('ode-solver-' + currentMode + '.pdf');
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('PDF downloaded!', 2000, 'success');
        }).catch(function(err) {
            console.error('PDF generation failed:', err);
            if (container.parentNode) document.body.removeChild(container);
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('PDF generation failed: ' + err.message, 3000, 'error');
        });
    }

    // ========== Print Worksheet ==========
    function openOdeWorksheet() {
        if (typeof WorksheetEngine !== 'undefined') {
            WorksheetEngine.open({
                jsonUrl: 'worksheet/math/calculus/ode.json',
                title: 'Ordinary Differential Equations',
                accentColor: '#db2777',
                branding: '8gwifi.org',
                defaultCount: 20
            });
        }
    }
    var odeWsBtn = document.getElementById('ode-worksheet-btn');
    if (odeWsBtn) odeWsBtn.addEventListener('click', openOdeWorksheet);

    document.getElementById('ode-share-btn').addEventListener('click', function() {
        var params = { mode: currentMode };
        if (currentMode === 'first') {
            params.f = firstOrderInput.value;
            if (firstICCheck.checked) { params.ic = '1'; params.x0 = firstICx0.value; params.y0 = firstICy0.value; }
        } else if (currentMode === 'second') {
            params.f = secondOrderInput.value;
            params.order = currentOrder;
            if (secondICCheck.checked) {
                params.ic = '1'; params.x0 = secondICx0.value; params.y0 = secondICy0.value; params.dy0 = secondICdy0.value;
                for (var i = 2; i < currentOrder; i++) {
                    var el = document.getElementById('ode-second-ic-d' + i + 'y0');
                    if (el) params['d' + i + 'y0'] = el.value;
                }
            }
        } else {
            params.f = fieldInput.value;
        }
        if (typeof ToolUtils !== 'undefined') {
            var url = ToolUtils.generateShareUrl(params, { toolName: 'ODE Solver Calculator' });
            ToolUtils.copyToClipboard(url, 'Share URL copied!');
        }
    });

    // ========== URL Params (Share restore) ==========
    try {
        var urlParams = new URLSearchParams(window.location.search);
        var shareMode = urlParams.get('mode');
        if (shareMode && (shareMode === 'first' || shareMode === 'second' || shareMode === 'field')) {
            var btn = document.querySelector('.ode-mode-btn[data-mode="' + shareMode + '"]');
            if (btn) btn.click();
            var f = urlParams.get('f');
            if (shareMode === 'first') {
                if (f) firstOrderInput.value = f;
                if (urlParams.get('ic') === '1') {
                    firstICCheck.checked = true;
                    firstICFields.classList.add('open');
                    firstICx0.value = urlParams.get('x0') || '0';
                    firstICy0.value = urlParams.get('y0') || '0';
                }
            } else if (shareMode === 'second') {
                var shareOrder = parseInt(urlParams.get('order'), 10);
                if (shareOrder >= 2 && shareOrder <= 5) {
                    currentOrder = shareOrder;
                    var orderBtn = document.querySelector('.ode-order-btn[data-order="' + shareOrder + '"]');
                    if (orderBtn) {
                        orderBtns.forEach(function(b) { b.classList.remove('active'); });
                        orderBtn.classList.add('active');
                    }
                    updateHigherOrderUI();
                }
                if (f) secondOrderInput.value = f;
                if (urlParams.get('ic') === '1') {
                    secondICCheck.checked = true;
                    secondICFields.classList.add('open');
                    secondICx0.value = urlParams.get('x0') || '0';
                    secondICy0.value = urlParams.get('y0') || '0';
                    secondICdy0.value = urlParams.get('dy0') || '0';
                    for (var si = 2; si < currentOrder; si++) {
                        var sEl = document.getElementById('ode-second-ic-d' + si + 'y0');
                        if (sEl) sEl.value = urlParams.get('d' + si + 'y0') || '0';
                    }
                }
            } else {
                if (f) fieldInput.value = f;
            }
            updatePreview();
        }
    } catch(e) {}

})();
