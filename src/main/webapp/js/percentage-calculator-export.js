/**
 * Percentage Calculator - Export & Python Compiler
 * LaTeX copy, share URLs, Python compiler templates
 */
(function() {
'use strict';

var R = window.PctCalcRender;

// ==================== LaTeX ====================

function buildLatex(mode, params) {
    if (mode === 'percentOf') {
        var r = (params.x / 100) * params.y;
        return R.fmt(params.x) + '\\% \\text{ of } ' + R.fmt(params.y) + ' = ' + R.fmt(r);
    }
    if (mode === 'whatPercent') {
        var pct = params.y !== 0 ? (params.x / params.y) * 100 : 0;
        return R.fmt(params.x) + ' \\text{ is } ' + R.fmt(pct) + '\\% \\text{ of } ' + R.fmt(params.y);
    }
    if (mode === 'percentChange') {
        var ch = params.a !== 0 ? ((params.b - params.a) / params.a) * 100 : 0;
        return '\\frac{' + R.fmt(params.b) + ' - ' + R.fmt(params.a) + '}{' + R.fmt(params.a) + '} \\times 100 = ' + R.fmt(ch) + '\\%';
    }
    if (mode === 'increaseBy') {
        return R.fmt(params.y) + ' \\times (1 + ' + R.fmt(params.x / 100) + ') = ' + R.fmt(params.y * (1 + params.x / 100));
    }
    if (mode === 'decreaseBy') {
        return R.fmt(params.y) + ' \\times (1 - ' + R.fmt(params.x / 100) + ') = ' + R.fmt(params.y * (1 - params.x / 100));
    }
    if (mode === 'reversePct') {
        var div = 1 - params.discPct / 100;
        return '\\frac{' + R.fmt(params.finalPrice) + '}{' + R.fmt(div) + '} = ' + R.fmt(params.finalPrice / div);
    }
    return '';
}

function copyLatex(mode, params) {
    var latex = buildLatex(mode, params);
    if (typeof ToolUtils !== 'undefined') {
        ToolUtils.copyToClipboard(latex, { toastMessage: 'LaTeX copied!' });
    } else if (navigator.clipboard) {
        navigator.clipboard.writeText(latex);
    }
}

// ==================== Share URL ====================

function buildShareUrl(state) {
    var data = { mode: state.mode };
    if (state.mode === 'percentOf' || state.mode === 'whatPercent' || state.mode === 'increaseBy' || state.mode === 'decreaseBy') {
        data.x = state.x; data.y = state.y;
    } else if (state.mode === 'percentChange') {
        data.a = state.a; data.b = state.b;
    } else if (state.mode === 'reversePct') {
        data.dp = state.discPct; data.fp = state.finalPrice;
    } else if (state.mode === 'discountSim') {
        data.bp = state.basePrice; data.dp = state.discPctSim; data.tp = state.taxPctSim; data.q = state.qty;
    } else if (state.mode === 'chain') {
        data.s = state.chainStart; data.st = state.chainSteps;
    }
    var encoded = btoa(JSON.stringify(data));
    return window.location.origin + window.location.pathname + '?d=' + encoded;
}

function parseShareUrl() {
    var params = new URLSearchParams(window.location.search);
    var d = params.get('d');
    if (!d) return null;
    try { return JSON.parse(atob(d)); } catch (e) { return null; }
}

function copyShareUrl(state) {
    var url = buildShareUrl(state);
    if (typeof ToolUtils !== 'undefined') {
        ToolUtils.copyToClipboard(url, { toastMessage: 'Share link copied!' });
    } else if (navigator.clipboard) {
        navigator.clipboard.writeText(url);
    }
}

// ==================== Python Compiler Templates ====================

function buildBasicPctCode(x, y) {
    return '# Percentage Calculator - Basic Operations\n\n' +
        'x = ' + x + '  # percent value\n' +
        'y = ' + y + '  # base value\n\n' +
        '# 1. X% of Y\n' +
        'result = (x / 100) * y\n' +
        'print(f"{x}% of {y} = {result}")\n\n' +
        '# 2. X is what % of Y\n' +
        'pct = (x / y) * 100 if y != 0 else 0\n' +
        'print(f"{x} is {pct:.2f}% of {y}")\n\n' +
        '# 3. Increase Y by X%\n' +
        'increased = y * (1 + x / 100)\n' +
        'print(f"{y} increased by {x}% = {increased}")\n\n' +
        '# 4. Decrease Y by X%\n' +
        'decreased = y * (1 - x / 100)\n' +
        'print(f"{y} decreased by {x}% = {decreased}")\n\n' +
        '# 5. Percent change from X to Y\n' +
        'if x != 0:\n' +
        '    change = ((y - x) / x) * 100\n' +
        '    sign = "+" if change >= 0 else ""\n' +
        '    print(f"% change from {x} to {y} = {sign}{change:.2f}%")\n\n' +
        '# 6. Reverse percentage\n' +
        'discount = 20  # example discount %\n' +
        'final_price = 80\n' +
        'original = final_price / (1 - discount / 100)\n' +
        'print(f"\\nOriginal before {discount}% discount = {original:.2f}")\n';
}

function buildDiscountSimCode(basePrice, discPct, taxPct, qty) {
    return '# Discount + Tax Simulator\n\n' +
        'base_price = ' + basePrice + '\n' +
        'discount_pct = ' + discPct + '\n' +
        'tax_pct = ' + taxPct + '\n' +
        'quantity = ' + qty + '\n\n' +
        '# Step 1: Discount\n' +
        'discount_amt = base_price * (discount_pct / 100)\n' +
        'print(f"Discount: {base_price} x {discount_pct}% = {discount_amt:.2f}")\n\n' +
        '# Step 2: After discount\n' +
        'after_discount = base_price - discount_amt\n' +
        'print(f"After discount: {base_price} - {discount_amt:.2f} = {after_discount:.2f}")\n\n' +
        '# Step 3: Tax\n' +
        'tax_amt = after_discount * (tax_pct / 100)\n' +
        'print(f"Tax: {after_discount:.2f} x {tax_pct}% = {tax_amt:.2f}")\n\n' +
        '# Step 4: Final per unit\n' +
        'final_each = after_discount + tax_amt\n' +
        'print(f"Final per unit: {after_discount:.2f} + {tax_amt:.2f} = {final_each:.2f}")\n\n' +
        '# Step 5: Grand total\n' +
        'grand_total = final_each * quantity\n' +
        'print(f"\\nGrand total ({quantity} units): {grand_total:.2f}")\n' +
        'print(f"You save: {discount_amt * quantity:.2f}")\n';
}

function buildChainCode(start, steps) {
    return '# Chained Percentage Steps\n\n' +
        'import re\n\n' +
        'start = ' + start + '\n' +
        'steps = "' + (steps || '+10%, -5%, +8%') + '".split(",")\n' +
        'steps = [s.strip() for s in steps if s.strip()]\n\n' +
        'current = start\n' +
        'print(f"Start: {current}")\n\n' +
        'for i, step in enumerate(steps, 1):\n' +
        '    prev = current\n' +
        '    step = step.strip()\n' +
        '    if step.endswith("%"):\n' +
        '        p = float(step[:-1])\n' +
        '        current = current * (1 + p / 100)\n' +
        '        print(f"Step {i}: {step} -> {prev:.2f} x {1 + p/100:.4f} = {current:.2f}")\n' +
        '    else:\n' +
        '        n = float(step)\n' +
        '        current = current + n\n' +
        '        print(f"Step {i}: {step} -> {prev:.2f} + {n} = {current:.2f}")\n\n' +
        'total_change = ((current - start) / start) * 100 if start != 0 else 0\n' +
        'sign = "+" if total_change >= 0 else ""\n' +
        'print(f"\\nFinal: {current:.2f} ({sign}{total_change:.2f}% overall)")\n';
}

function getCompilerUrl(template, state, contextPath) {
    var code;
    switch (template) {
        case 'discount-sim':
            code = buildDiscountSimCode(state.basePrice || 1000, state.discPctSim || 15, state.taxPctSim || 5, state.qty || 1);
            break;
        case 'chain-steps':
            code = buildChainCode(state.chainStart || 100, state.chainSteps || '+10%, -5%, +8%');
            break;
        default:
            code = buildBasicPctCode(state.x || 10, state.y || 200);
    }
    var b64Code = btoa(unescape(encodeURIComponent(code)));
    var config = JSON.stringify({ lang: 'python', code: b64Code });
    return (contextPath || '') + '/onecompiler-embed.jsp?c=' + encodeURIComponent(config);
}

// ==================== Exports ====================

window.PctCalcExport = {
    buildLatex: buildLatex,
    copyLatex: copyLatex,
    buildShareUrl: buildShareUrl,
    parseShareUrl: parseShareUrl,
    copyShareUrl: copyShareUrl,
    getCompilerUrl: getCompilerUrl
};

})();
