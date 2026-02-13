// ========== SOLVER ENGINE ==========
function formatNum(n) {
    if (Math.abs(n - Math.round(n)) < 1e-9) return String(Math.round(n));
    return String(Math.round(n * 100) / 100);
}

function findMatchingParen(s, pos) {
    var depth = 0;
    for (var i = pos; i < s.length; i++) {
        if (s.charAt(i) === '(') depth++;
        else if (s.charAt(i) === ')') { depth--; if (depth === 0) return i; }
    }
    return -1;
}

function makeCard(val, left, right, op) {
    var expr = '(' + left.expr + ' ' + op + ' ' + right.expr + ')';
    var steps = left.steps.concat(right.steps);
    steps.push(left.expr + ' ' + op + ' ' + right.expr + ' = ' + formatNum(val));
    return { val: val, expr: expr, steps: steps };
}

function getAllCombinations(a, b) {
    var r = [];
    r.push(makeCard(a.val + b.val, a, b, '+'));
    r.push(makeCard(a.val * b.val, a, b, '\u00d7'));
    r.push(makeCard(a.val - b.val, a, b, '\u2212'));
    r.push(makeCard(b.val - a.val, b, a, '\u2212'));
    if (Math.abs(b.val) > 1e-9) r.push(makeCard(a.val / b.val, a, b, '\u00f7'));
    if (Math.abs(a.val) > 1e-9) r.push(makeCard(b.val / a.val, b, a, '\u00f7'));
    return r;
}

function solveGame(numbers, target) {
    var solutions = [];
    var seen = {};

    function helper(cards) {
        if (cards.length === 1) {
            if (Math.abs(cards[0].val - target) < 1e-9) {
                var expr = cards[0].expr;
                if (expr.charAt(0) === '(' && findMatchingParen(expr, 0) === expr.length - 1) {
                    expr = expr.substring(1, expr.length - 1);
                }
                if (!seen[expr]) {
                    seen[expr] = true;
                    solutions.push({ expr: expr, steps: cards[0].steps });
                }
            }
            return;
        }
        for (var i = 0; i < cards.length; i++) {
            for (var j = i + 1; j < cards.length; j++) {
                var rest = [];
                for (var k = 0; k < cards.length; k++) {
                    if (k !== i && k !== j) rest.push(cards[k]);
                }
                var combos = getAllCombinations(cards[i], cards[j]);
                for (var c = 0; c < combos.length; c++) {
                    rest.push(combos[c]);
                    helper(rest);
                    rest.pop();
                }
            }
        }
    }

    var init = [];
    for (var i = 0; i < numbers.length; i++) {
        init.push({ val: numbers[i], expr: String(numbers[i]), steps: [] });
    }
    helper(init);
    return solutions;
}

// ========== DOM & STATE ==========
var num1El = document.getElementById('game-num1');
var num2El = document.getElementById('game-num2');
var num3El = document.getElementById('game-num3');
var num4El = document.getElementById('game-num4');
var targetEl = document.getElementById('game-target');
var resultContent = document.getElementById('game-result-content');
var resultActions = document.getElementById('game-result-actions');
var lastResultText = '';
var allSolutions = [];
var currentNumbers = [];
var currentTarget = 24;

// ========== PROCESS ==========
function processGame() {
    currentNumbers = [
        parseInt(num1El.value) || 0,
        parseInt(num2El.value) || 0,
        parseInt(num3El.value) || 0,
        parseInt(num4El.value) || 0
    ];
    currentTarget = parseInt(targetEl.value) || 24;

    for (var i = 0; i < 4; i++) {
        if (currentNumbers[i] < 1 || currentNumbers[i] > 99) {
            resultContent.innerHTML = '<div class="game-warn">Enter numbers between 1 and 99</div>';
            resultActions.classList.remove('visible');
            return;
        }
    }

    allSolutions = solveGame(currentNumbers, currentTarget);
    displaySolutions(false);
}

// ========== DISPLAY ==========
function getDifficulty(count) {
    if (count === 0) return { label: 'Impossible', cls: 'game-diff-impossible' };
    if (count <= 2) return { label: 'Expert', cls: 'game-diff-expert' };
    if (count <= 5) return { label: 'Hard', cls: 'game-diff-hard' };
    if (count <= 12) return { label: 'Medium', cls: 'game-diff-medium' };
    return { label: 'Easy', cls: 'game-diff-easy' };
}

function displaySolutions(showAll) {
    var solutions = allSolutions;
    var target = currentTarget;

    if (solutions.length === 0) {
        resultContent.innerHTML = '<div class="game-no-solution"><strong>No Solution</strong><br><span style="font-size:0.8125rem;font-weight:400;">The numbers [' + currentNumbers.join(', ') + '] cannot make ' + target + '. Try different numbers or click Random Puzzle.</span></div>';
        resultActions.classList.remove('visible');
        lastResultText = '';
        return;
    }

    var diff = getDifficulty(solutions.length);
    var limit = showAll ? solutions.length : Math.min(10, solutions.length);
    var html = '';

    // Stats bar
    html += '<div class="game-stats">';
    html += '<div class="game-stat"><span class="game-stat-val">' + solutions.length + '</span><span class="game-stat-lbl">Solutions</span></div>';
    html += '<div class="game-stat"><span class="game-stat-val">' + currentNumbers.join(', ') + '</span><span class="game-stat-lbl">Numbers</span></div>';
    html += '<div class="game-stat"><span class="game-stat-val ' + diff.cls + '">' + diff.label + '</span><span class="game-stat-lbl">Difficulty</span></div>';
    html += '</div>';

    // Solutions
    for (var i = 0; i < limit; i++) {
        html += buildSolutionCard(solutions[i], i, target);
    }

    if (solutions.length > 10 && !showAll) {
        html += '<button type="button" class="game-show-more" onclick="displaySolutions(true)">Show all ' + solutions.length + ' solutions</button>';
    }

    resultContent.innerHTML = html;
    lastResultText = solutions.slice(0, limit).map(function(s) { return s.expr + ' = ' + target; }).join('\n');
    resultActions.classList.add('visible');
}

function buildSolutionCard(sol, idx, target) {
    var h = '<div class="game-solution">';
    h += '<div class="game-solution-num">' + (idx + 1) + '</div>';
    h += '<div class="game-solution-body">';
    h += '<div class="game-solution-expr">' + escapeHtml(sol.expr) + ' = ' + target + '</div>';
    if (sol.steps.length > 1) {
        h += '<div class="game-solution-steps">';
        for (var s = 0; s < sol.steps.length; s++) {
            h += '<div class="game-step"><span class="game-step-badge">' + (s + 1) + '</span>' + escapeHtml(sol.steps[s]) + '</div>';
        }
        h += '</div>';
    }
    h += '</div></div>';
    return h;
}

// ========== GENERATORS ==========
function setInputs(nums) {
    num1El.value = nums[0];
    num2El.value = nums[1];
    num3El.value = nums[2];
    num4El.value = nums[3];
}

function generateRandom() {
    var t = parseInt(targetEl.value) || 24;
    for (var a = 0; a < 100; a++) {
        var nums = [
            Math.floor(Math.random() * 13) + 1,
            Math.floor(Math.random() * 13) + 1,
            Math.floor(Math.random() * 13) + 1,
            Math.floor(Math.random() * 13) + 1
        ];
        if (solveGame(nums, t).length > 0) {
            setInputs(nums);
            processGame();
            return;
        }
    }
    setInputs([3, 3, 8, 8]);
    processGame();
}

function generateHard() {
    var t = parseInt(targetEl.value) || 24;
    for (var a = 0; a < 300; a++) {
        var nums = [
            Math.floor(Math.random() * 9) + 1,
            Math.floor(Math.random() * 9) + 1,
            Math.floor(Math.random() * 9) + 1,
            Math.floor(Math.random() * 9) + 1
        ];
        var sols = solveGame(nums, t);
        if (sols.length >= 1 && sols.length <= 2) {
            setInputs(nums);
            processGame();
            return;
        }
    }
    setInputs([1, 5, 5, 5]);
    processGame();
}

function clearAll() {
    num1El.value = '';
    num2El.value = '';
    num3El.value = '';
    num4El.value = '';
    targetEl.value = 24;
    resultContent.innerHTML = document.getElementById('game-empty-state') ? document.getElementById('game-empty-state').outerHTML : '<div class="tool-empty-state"><h3>Enter 4 numbers to solve</h3></div>';
    resultActions.classList.remove('visible');
    lastResultText = '';
    allSolutions = [];
}

function copyResult() {
    if (!lastResultText) return;
    if (typeof ToolUtils !== 'undefined' && ToolUtils.copyToClipboard) {
        ToolUtils.copyToClipboard(lastResultText);
        ToolUtils.showToast('Copied to clipboard!');
    } else {
        navigator.clipboard.writeText(lastResultText);
    }
}

function shareUrl() {
    if (!allSolutions.length && !currentNumbers.some(function(n) { return n > 0; })) {
        if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Solve a puzzle first to share', 2000, 'warning');
        return;
    }
    var params = {
        n1: num1El.value,
        n2: num2El.value,
        n3: num3El.value,
        n4: num4El.value
    };
    if (currentTarget !== 24) params.target = currentTarget;

    if (typeof ToolUtils !== 'undefined' && ToolUtils.generateShareUrl) {
        var url = ToolUtils.generateShareUrl(params, { showSupportPopup: true, toolName: '24 Game Solver' });
        ToolUtils.copyToClipboard(url, { showToast: true, toastMessage: 'Share URL copied to clipboard!', showSupportPopup: false });
    } else {
        var qs = Object.keys(params).map(function(k) { return k + '=' + encodeURIComponent(params[k]); }).join('&');
        var url = window.location.origin + window.location.pathname + '?' + qs;
        navigator.clipboard.writeText(url);
    }
}

function printWorksheet() {
    if (!allSolutions.length) {
        if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Solve a puzzle first to print', 2000, 'warning');
        return;
    }

    var nums = currentNumbers;
    var target = currentTarget;
    var diff = getDifficulty(allSolutions.length);
    var limit = Math.min(allSolutions.length, 20);

    var html = '<div class="print-title">24 Game Worksheet</div>';
    html += '<div class="print-info">Numbers: ' + nums.join(', ') + ' &nbsp;|&nbsp; Target: ' + target + ' &nbsp;|&nbsp; ' + allSolutions.length + ' solution' + (allSolutions.length !== 1 ? 's' : '') + ' (' + diff.label + ')</div>';

    // Solutions table
    html += '<table class="print-grid"><tr><th style="border:2px solid #000;padding:0.5rem;font-size:0.875rem;">#</th><th style="border:2px solid #000;padding:0.5rem;font-size:0.875rem;text-align:left;">Expression</th><th style="border:2px solid #000;padding:0.5rem;font-size:0.875rem;text-align:left;">Steps</th></tr>';
    for (var i = 0; i < limit; i++) {
        var sol = allSolutions[i];
        var stepsText = sol.steps.length > 1 ? sol.steps.join(' → ') : '';
        html += '<tr><td style="border:2px solid #000;padding:0.375rem;text-align:center;font-weight:600;">' + (i + 1) + '</td>';
        html += '<td style="border:2px solid #000;padding:0.375rem;font-family:monospace;font-size:0.9rem;">' + escapeHtml(sol.expr) + ' = ' + target + '</td>';
        html += '<td style="border:2px solid #000;padding:0.375rem;font-family:monospace;font-size:0.8rem;color:#555;">' + escapeHtml(stepsText) + '</td></tr>';
    }
    if (allSolutions.length > limit) {
        html += '<tr><td colspan="3" style="border:2px solid #000;padding:0.375rem;text-align:center;font-style:italic;color:#888;">... and ' + (allSolutions.length - limit) + ' more solutions</td></tr>';
    }
    html += '</table>';

    // Practice exercise
    html += '<div class="print-exercise">';
    html += '<h3 style="margin:0 0 0.75rem;font-size:1.1rem;">Practice Exercise</h3>';
    html += '<p style="margin-bottom:0.75rem;">Using the numbers <strong>' + nums.join(', ') + '</strong>, write your own expressions that equal <strong>' + target + '</strong>:</p>';
    for (var e = 0; e < 4; e++) {
        html += '<div style="margin-bottom:0.75rem;">' + (e + 1) + '. <span class="print-exercise-blank" style="width:280px;"></span> = ' + target + '</div>';
    }
    html += '</div>';

    html += '<div class="print-footer">Generated by 8gwifi.org/24-game-solver.jsp</div>';

    var printArea = document.createElement('div');
    printArea.id = 'printArea';
    printArea.innerHTML = html;
    document.body.appendChild(printArea);
    window.print();
    setTimeout(function() { printArea.remove(); }, 1000);
}

// ========== UTILS ==========
function escapeHtml(str) {
    if (!str) return '';
    var div = document.createElement('div');
    div.appendChild(document.createTextNode(str));
    return div.innerHTML;
}

function toggleFaq(btn) {
    var item = btn.closest('.faq-item');
    if (item) item.classList.toggle('open');
}

// ========== EVENT LISTENERS ==========
document.getElementById('game-solve-btn').addEventListener('click', processGame);
document.getElementById('game-random-btn').addEventListener('click', generateRandom);
document.getElementById('game-hard-btn').addEventListener('click', generateHard);
document.getElementById('game-clear-btn').addEventListener('click', clearAll);
document.getElementById('game-copy-btn').addEventListener('click', copyResult);
document.getElementById('game-share-btn').addEventListener('click', shareUrl);
document.getElementById('game-print-btn').addEventListener('click', printWorksheet);

// Enter key on any number input
var numInputs = document.querySelectorAll('.game-num-input');
for (var n = 0; n < numInputs.length; n++) {
    numInputs[n].addEventListener('keydown', function(e) {
        if (e.key === 'Enter') { e.preventDefault(); processGame(); }
    });
}

// Sample chips
var chips = document.querySelectorAll('.game-chip');
for (var c = 0; c < chips.length; c++) {
    chips[c].addEventListener('click', function() {
        var nums = this.getAttribute('data-nums').split(',').map(Number);
        setInputs(nums);
        processGame();
    });
}

// URL param support: ?n1=3&n2=3&n3=8&n4=8&target=24
(function() {
    var p = new URLSearchParams(window.location.search);
    var n1 = p.get('n1'), n2 = p.get('n2'), n3 = p.get('n3'), n4 = p.get('n4');
    if (n1 && n2 && n3 && n4) {
        num1El.value = n1;
        num2El.value = n2;
        num3El.value = n3;
        num4El.value = n4;
        var t = p.get('target');
        if (t) targetEl.value = t;
        processGame();
    }
})();
