/**
 * Probability Calculator — Orchestration IIFE
 * Depends on: StatsCommon (C), StatsGraph (G), StatsExport (E)
 * Pure JS computation — no jStat or Plotly needed.
 */
(function() {
    'use strict';

    var C = window.StatsCommon;
    var G = window.StatsGraph;
    var E = window.StatsExport;

    /* ===== State ===== */
    var state = {
        mode: 'basic',
        result: null
    };

    /* ===== DOM ===== */
    var els = {};

    function initDOM() {
        els.resultContent  = document.getElementById('prob-result-content');
        els.resultActions  = document.getElementById('prob-result-actions');
        els.compilerIframe = document.getElementById('prob-compiler-iframe');
        els.calcBtn        = document.getElementById('prob-calc-btn');
        els.clearBtn       = document.getElementById('prob-clear-btn');

        els.modeBasic       = document.getElementById('prob-mode-basic');
        els.modeConditional = document.getElementById('prob-mode-conditional');
        els.modeBayes       = document.getElementById('prob-mode-bayes');
        els.modeMultiple    = document.getElementById('prob-mode-multiple');

        els.panelBasic       = document.getElementById('prob-input-basic');
        els.panelConditional = document.getElementById('prob-input-conditional');
        els.panelBayes       = document.getElementById('prob-input-bayes');
        els.panelMultiple    = document.getElementById('prob-input-multiple');
    }

    /* ===== Tabs ===== */
    function initTabs() {
        var tabs = document.querySelectorAll('.stat-output-tab');
        for (var i = 0; i < tabs.length; i++) {
            tabs[i].addEventListener('click', function() {
                var target = this.getAttribute('data-tab');
                document.querySelectorAll('.stat-output-tab').forEach(function(t) { t.classList.remove('active'); });
                document.querySelectorAll('.stat-panel').forEach(function(p) { p.classList.remove('active'); });
                this.classList.add('active');
                var panel = document.getElementById(target);
                if (panel) panel.classList.add('active');
                if (target === 'prob-compiler-panel') {
                    if (!els.compilerIframe.getAttribute('src') || els.compilerIframe.getAttribute('src') === '') loadCompiler();
                }
            });
        }
    }

    /* ===== Mode Toggle ===== */
    function initModes() {
        els.modeBasic.addEventListener('click', function() { setMode('basic'); });
        els.modeConditional.addEventListener('click', function() { setMode('conditional'); });
        els.modeBayes.addEventListener('click', function() { setMode('bayes'); });
        els.modeMultiple.addEventListener('click', function() { setMode('multiple'); });
    }

    function setMode(m) {
        state.mode = m;
        els.modeBasic.classList.toggle('active', m === 'basic');
        els.modeConditional.classList.toggle('active', m === 'conditional');
        els.modeBayes.classList.toggle('active', m === 'bayes');
        els.modeMultiple.classList.toggle('active', m === 'multiple');
        els.panelBasic.style.display = m === 'basic' ? '' : 'none';
        els.panelConditional.style.display = m === 'conditional' ? '' : 'none';
        els.panelBayes.style.display = m === 'bayes' ? '' : 'none';
        els.panelMultiple.style.display = m === 'multiple' ? '' : 'none';
    }

    /* ===== Calculate ===== */
    function calculate() {
        try { doCalculate(); } catch(e) { C.showError(els.resultContent, 'Calculation error: ' + e.message); }
    }

    function doCalculate() {
        var r;

        if (state.mode === 'basic') {
            var favorable = parseFloat(document.getElementById('prob-favorable').value);
            var total = parseFloat(document.getElementById('prob-total').value);
            if (isNaN(favorable) || favorable < 0) { C.showError(els.resultContent, 'Enter a valid number of favorable outcomes (\u2265 0).'); return; }
            if (isNaN(total) || total <= 0) { C.showError(els.resultContent, 'Enter a valid total number of outcomes (> 0).'); return; }
            if (favorable > total) { C.showError(els.resultContent, 'Favorable outcomes cannot exceed total outcomes.'); return; }
            var prob = favorable / total;
            var complement = 1 - prob;
            var oddsFor = complement > 0 ? prob / complement : Infinity;
            var oddsAgainst = prob > 0 ? complement / prob : Infinity;
            r = {
                favorable: favorable, total: total,
                prob: prob, complement: complement,
                percentage: prob * 100,
                oddsFor: oddsFor, oddsAgainst: oddsAgainst
            };
            renderBasicResult(r);

        } else if (state.mode === 'conditional') {
            var pAandB = parseFloat(document.getElementById('prob-a-and-b').value);
            var pB = parseFloat(document.getElementById('prob-b').value);
            if (isNaN(pAandB) || pAandB < 0 || pAandB > 1) { C.showError(els.resultContent, 'Enter a valid P(A\u2229B) between 0 and 1.'); return; }
            if (isNaN(pB) || pB <= 0 || pB > 1) { C.showError(els.resultContent, 'Enter a valid P(B) between 0 and 1 (must be > 0).'); return; }
            if (pAandB > pB) { C.showError(els.resultContent, 'P(A\u2229B) cannot exceed P(B).'); return; }
            var pAgivenB = pAandB / pB;
            r = {
                pAandB: pAandB, pB: pB,
                pAgivenB: pAgivenB,
                percentage: pAgivenB * 100
            };
            renderConditionalResult(r);

        } else if (state.mode === 'bayes') {
            var pA = parseFloat(document.getElementById('prob-prior-a').value);
            var pBgivenA = parseFloat(document.getElementById('prob-b-given-a').value);
            var pBgivenNotA = parseFloat(document.getElementById('prob-b-given-not-a').value);
            if (isNaN(pA) || pA < 0 || pA > 1) { C.showError(els.resultContent, 'Enter a valid prior P(A) between 0 and 1.'); return; }
            if (isNaN(pBgivenA) || pBgivenA < 0 || pBgivenA > 1) { C.showError(els.resultContent, 'Enter a valid P(B|A) between 0 and 1.'); return; }
            if (isNaN(pBgivenNotA) || pBgivenNotA < 0 || pBgivenNotA > 1) { C.showError(els.resultContent, 'Enter a valid P(B|\u00ACA) between 0 and 1.'); return; }
            var pNotA = 1 - pA;
            var pBmarginal = pBgivenA * pA + pBgivenNotA * pNotA;
            if (pBmarginal === 0) { C.showError(els.resultContent, 'P(B) is zero \u2014 cannot apply Bayes\u2019 theorem.'); return; }
            var posterior = (pBgivenA * pA) / pBmarginal;
            var likelihoodRatio = pBgivenNotA > 0 ? pBgivenA / pBgivenNotA : Infinity;
            r = {
                pA: pA, pNotA: pNotA,
                pBgivenA: pBgivenA, pBgivenNotA: pBgivenNotA,
                pBmarginal: pBmarginal,
                posterior: posterior,
                likelihoodRatio: likelihoodRatio,
                priorPosteriorChange: posterior - pA
            };
            renderBayesResult(r);

        } else {
            var pA = parseFloat(document.getElementById('prob-pa').value);
            var pB = parseFloat(document.getElementById('prob-pb').value);
            var relation = document.getElementById('prob-relation').value;
            if (isNaN(pA) || pA < 0 || pA > 1) { C.showError(els.resultContent, 'Enter a valid P(A) between 0 and 1.'); return; }
            if (isNaN(pB) || pB < 0 || pB > 1) { C.showError(els.resultContent, 'Enter a valid P(B) between 0 and 1.'); return; }
            var pAandB, pAorB;
            if (relation === 'independent') {
                pAandB = pA * pB;
            } else {
                pAandB = 0;
            }
            pAorB = pA + pB - pAandB;
            if (pAorB > 1) pAorB = 1;
            var pNotA = 1 - pA;
            var pNotB = 1 - pB;
            var pNotAandNotB = (relation === 'independent') ? pNotA * pNotB : 1 - pAorB;
            r = {
                pA: pA, pB: pB, relation: relation,
                pAandB: pAandB, pAorB: pAorB,
                pNotA: pNotA, pNotB: pNotB,
                pNotAandNotB: pNotAandNotB
            };
            renderMultipleResult(r);
        }

        state.result = r;

        E.renderActionButtons(els.resultActions, {
            toolName: 'Probability Calculator',
            getLatex: function() {
                var s = state.result;
                if (!s) return '';
                var lines = [];
                lines.push('\\textbf{Probability Calculator}\\\\[4pt]');
                if (state.mode === 'basic') {
                    lines.push('\\text{Favorable} = ' + s.favorable + '\\\\');
                    lines.push('\\text{Total} = ' + s.total + '\\\\');
                    lines.push('P(A) = \\frac{' + s.favorable + '}{' + s.total + '} = ' + C.fmt(s.prob, 6) + '\\\\');
                    lines.push('P(\\neg A) = ' + C.fmt(s.complement, 6) + '\\\\');
                } else if (state.mode === 'conditional') {
                    lines.push('P(A \\cap B) = ' + C.fmt(s.pAandB, 6) + '\\\\');
                    lines.push('P(B) = ' + C.fmt(s.pB, 6) + '\\\\');
                    lines.push('P(A|B) = \\frac{P(A \\cap B)}{P(B)} = ' + C.fmt(s.pAgivenB, 6) + '\\\\');
                } else if (state.mode === 'bayes') {
                    lines.push('P(A) = ' + C.fmt(s.pA, 6) + '\\\\');
                    lines.push('P(B|A) = ' + C.fmt(s.pBgivenA, 6) + '\\\\');
                    lines.push('P(B|\\neg A) = ' + C.fmt(s.pBgivenNotA, 6) + '\\\\');
                    lines.push('P(B) = ' + C.fmt(s.pBmarginal, 6) + '\\\\');
                    lines.push('P(A|B) = \\frac{P(B|A) \\cdot P(A)}{P(B)} = ' + C.fmt(s.posterior, 6) + '\\\\');
                } else {
                    var rel = s.relation === 'independent' ? 'Independent' : 'Mutually Exclusive';
                    lines.push('P(A) = ' + C.fmt(s.pA, 6) + ',\\; P(B) = ' + C.fmt(s.pB, 6) + '\\; \\text{(' + rel + ')}\\\\');
                    lines.push('P(A \\cap B) = ' + C.fmt(s.pAandB, 6) + '\\\\');
                    lines.push('P(A \\cup B) = ' + C.fmt(s.pAorB, 6) + '\\\\');
                    lines.push('P(\\neg A) = ' + C.fmt(s.pNotA, 6) + ',\\; P(\\neg B) = ' + C.fmt(s.pNotB, 6) + '\\\\');
                }
                return lines.join('\n');
            },
            getShareState: function() {
                var s = state.result;
                if (!s) return null;
                var shared = { mode: state.mode };
                if (state.mode === 'basic') {
                    shared.favorable = s.favorable;
                    shared.total = s.total;
                } else if (state.mode === 'conditional') {
                    shared.pAandB = s.pAandB;
                    shared.pB = s.pB;
                } else if (state.mode === 'bayes') {
                    shared.pA = s.pA;
                    shared.pBgivenA = s.pBgivenA;
                    shared.pBgivenNotA = s.pBgivenNotA;
                } else {
                    shared.pA = s.pA;
                    shared.pB = s.pB;
                    shared.relation = s.relation;
                }
                return shared;
            },
            resultEl: '#prob-result-content'
        });

        var compilerTab = document.querySelector('[data-tab="prob-compiler-panel"]');
        if (compilerTab && compilerTab.classList.contains('active')) loadCompiler();
        else els.compilerIframe.removeAttribute('src');
    }

    /* ===== Render: Basic P(A) ===== */
    function renderBasicResult(r) {
        var h = '<div class="stat-hero"><span class="stat-hero-value">' + C.fmt(r.prob, 6) + '</span><span class="stat-hero-label">P(A)</span></div>';
        h += buildSection('Basic Probability', [
            ['Favorable Outcomes', r.favorable],
            ['Total Outcomes', r.total],
            ['P(A)', C.fmt(r.prob, 6)],
            ['P(\u00ACA)', C.fmt(r.complement, 6)],
            ['Percentage', C.fmt(r.percentage, 2) + '%'],
            ['Odds For', C.fmt(r.favorable, 0) + ':' + C.fmt(r.total - r.favorable, 0)],
            ['Odds Against', C.fmt(r.total - r.favorable, 0) + ':' + C.fmt(r.favorable, 0)]
        ]);
        h += buildSteps('basic', r);
        var interp = r.prob === 0 ? 'The event is impossible.'
            : r.prob === 1 ? 'The event is certain.'
            : r.prob < 0.1 ? 'The event is very unlikely.'
            : r.prob < 0.4 ? 'The event is somewhat unlikely.'
            : r.prob <= 0.6 ? 'The event has a roughly even chance.'
            : r.prob < 0.9 ? 'The event is somewhat likely.'
            : 'The event is very likely.';
        h += '<div class="stat-interpretation stat-interpretation-normal"><strong>Interpretation:</strong> With ' + r.favorable + ' favorable outcomes out of ' + r.total + ', the probability is ' + C.fmt(r.percentage, 2) + '%. ' + interp + '</div>';
        els.resultContent.innerHTML = h;
        renderKaTeX();
    }

    /* ===== Render: Conditional P(A|B) ===== */
    function renderConditionalResult(r) {
        var h = '<div class="stat-hero"><span class="stat-hero-value">' + C.fmt(r.pAgivenB, 6) + '</span><span class="stat-hero-label">P(A|B)</span></div>';
        h += buildSection('Conditional Probability', [
            ['P(A\u2229B)', C.fmt(r.pAandB, 6)],
            ['P(B)', C.fmt(r.pB, 6)],
            ['P(A|B)', C.fmt(r.pAgivenB, 6)],
            ['Percentage', C.fmt(r.percentage, 2) + '%']
        ]);
        h += buildSteps('conditional', r);
        h += '<div class="stat-interpretation stat-interpretation-normal"><strong>Interpretation:</strong> Given that event B has occurred, the probability of event A is ' + C.fmt(r.percentage, 2) + '%.</div>';
        els.resultContent.innerHTML = h;
        renderKaTeX();
    }

    /* ===== Render: Bayes P(A|B) ===== */
    function renderBayesResult(r) {
        var h = '<div class="stat-hero"><span class="stat-hero-value">' + C.fmt(r.posterior, 6) + '</span><span class="stat-hero-label">Posterior P(A|B)</span></div>';
        var changeStr = r.priorPosteriorChange >= 0 ? '+' + C.fmt(r.priorPosteriorChange, 6) : C.fmt(r.priorPosteriorChange, 6);
        h += buildSection('Bayes\u2019 Theorem', [
            ['Prior P(A)', C.fmt(r.pA, 6)],
            ['P(B|A)', C.fmt(r.pBgivenA, 6)],
            ['P(B|\u00ACA)', C.fmt(r.pBgivenNotA, 6)],
            ['P(B) Marginal', C.fmt(r.pBmarginal, 6)],
            ['Posterior P(A|B)', C.fmt(r.posterior, 6)],
            ['Likelihood Ratio', r.likelihoodRatio === Infinity ? '\u221E' : C.fmt(r.likelihoodRatio, 4)],
            ['Prior \u2192 Posterior Change', changeStr]
        ]);
        h += buildSteps('bayes', r);
        var direction = r.posterior > r.pA ? 'increased' : r.posterior < r.pA ? 'decreased' : 'remained the same';
        h += '<div class="stat-interpretation stat-interpretation-normal"><strong>Interpretation:</strong> After observing evidence B, the probability of A ' + direction + ' from ' + C.fmt(r.pA * 100, 2) + '% to ' + C.fmt(r.posterior * 100, 2) + '%. The likelihood ratio is ' + (r.likelihoodRatio === Infinity ? '\u221E' : C.fmt(r.likelihoodRatio, 2)) + '.</div>';
        els.resultContent.innerHTML = h;
        renderKaTeX();
    }

    /* ===== Render: Multiple Events ===== */
    function renderMultipleResult(r) {
        var heroVal = r.pAorB;
        var heroLabel = 'P(A \u222A B)';
        var h = '<div class="stat-hero"><span class="stat-hero-value">' + C.fmt(heroVal, 6) + '</span><span class="stat-hero-label">' + heroLabel + '</span></div>';
        var relLabel = r.relation === 'independent' ? 'Independent' : 'Mutually Exclusive';
        h += buildSection('Multiple Events', [
            ['P(A)', C.fmt(r.pA, 6)],
            ['P(B)', C.fmt(r.pB, 6)],
            ['Relationship', relLabel],
            ['P(A \u2229 B)', C.fmt(r.pAandB, 6)],
            ['P(A \u222A B)', C.fmt(r.pAorB, 6)],
            ['P(\u00ACA)', C.fmt(r.pNotA, 6)],
            ['P(\u00ACB)', C.fmt(r.pNotB, 6)],
            ['P(\u00ACA \u2229 \u00ACB)', C.fmt(r.pNotAandNotB, 6)]
        ]);
        h += buildSteps('multiple', r);
        var interpRel = r.relation === 'independent'
            ? 'Since A and B are independent, P(A\u2229B) = P(A)\u00B7P(B) = ' + C.fmt(r.pAandB, 4) + '.'
            : 'Since A and B are mutually exclusive, P(A\u2229B) = 0.';
        h += '<div class="stat-interpretation stat-interpretation-normal"><strong>Interpretation:</strong> ' + interpRel + ' The probability of at least one occurring is P(A\u222AB) = ' + C.fmt(r.pAorB * 100, 2) + '%.</div>';
        els.resultContent.innerHTML = h;
        renderKaTeX();
    }

    /* ===== Helpers ===== */
    function buildSection(title, rows) {
        var h = '<div class="stat-section"><div class="stat-section-title">' + title + '</div>';
        for (var i = 0; i < rows.length; i++) {
            h += '<div class="stat-row"><span class="stat-label">' + rows[i][0] + '</span><span class="stat-value">' + rows[i][1] + '</span></div>';
        }
        return h + '</div>';
    }

    function buildSteps(mode, r) {
        var h = '<div class="stat-section"><div class="stat-section-title">Calculation Steps</div>';
        if (mode === 'basic') {
            h += step(1, 'Set Up', '<span class="stat-katex" data-tex="P(A) = \\frac{\\text{favorable}}{\\text{total}} = \\frac{' + r.favorable + '}{' + r.total + '}"></span>');
            h += step(2, 'Divide', '<span class="stat-katex" data-tex="P(A) = ' + C.fmt(r.prob, 6) + '"></span>');
            h += step(3, 'Complement', '<span class="stat-katex" data-tex="P(\\neg A) = 1 - P(A) = 1 - ' + C.fmt(r.prob, 6) + ' = ' + C.fmt(r.complement, 6) + '"></span>');
        } else if (mode === 'conditional') {
            h += step(1, 'Given', '<span class="stat-katex" data-tex="P(A \\cap B) = ' + C.fmt(r.pAandB, 6) + ',\\; P(B) = ' + C.fmt(r.pB, 6) + '"></span>');
            h += step(2, 'Apply Formula', '<span class="stat-katex" data-tex="P(A|B) = \\frac{P(A \\cap B)}{P(B)} = \\frac{' + C.fmt(r.pAandB, 6) + '}{' + C.fmt(r.pB, 6) + '}"></span>');
            h += step(3, 'Result', '<span class="stat-katex" data-tex="P(A|B) = ' + C.fmt(r.pAgivenB, 6) + '"></span>');
        } else if (mode === 'bayes') {
            h += step(1, 'Prior and Likelihoods', '<span class="stat-katex" data-tex="P(A) = ' + C.fmt(r.pA, 6) + ',\\; P(B|A) = ' + C.fmt(r.pBgivenA, 6) + ',\\; P(B|\\neg A) = ' + C.fmt(r.pBgivenNotA, 6) + '"></span>');
            h += step(2, 'Marginal P(B)', '<span class="stat-katex" data-tex="P(B) = P(B|A)P(A) + P(B|\\neg A)P(\\neg A) = ' + C.fmt(r.pBgivenA, 4) + ' \\cdot ' + C.fmt(r.pA, 4) + ' + ' + C.fmt(r.pBgivenNotA, 4) + ' \\cdot ' + C.fmt(r.pNotA, 4) + ' = ' + C.fmt(r.pBmarginal, 6) + '"></span>');
            h += step(3, 'Apply Bayes\' Theorem', '<span class="stat-katex" data-tex="P(A|B) = \\frac{P(B|A) \\cdot P(A)}{P(B)} = \\frac{' + C.fmt(r.pBgivenA, 4) + ' \\cdot ' + C.fmt(r.pA, 4) + '}{' + C.fmt(r.pBmarginal, 6) + '}"></span>');
            h += step(4, 'Result', '<span class="stat-katex" data-tex="P(A|B) = ' + C.fmt(r.posterior, 6) + '"></span>');
        } else {
            var relLabel = r.relation === 'independent' ? 'Independent' : 'Mutually Exclusive';
            h += step(1, 'Given', '<span class="stat-katex" data-tex="P(A) = ' + C.fmt(r.pA, 6) + ',\\; P(B) = ' + C.fmt(r.pB, 6) + '\\; (' + relLabel + ')"></span>');
            if (r.relation === 'independent') {
                h += step(2, 'AND (Independent)', '<span class="stat-katex" data-tex="P(A \\cap B) = P(A) \\cdot P(B) = ' + C.fmt(r.pA, 4) + ' \\cdot ' + C.fmt(r.pB, 4) + ' = ' + C.fmt(r.pAandB, 6) + '"></span>');
            } else {
                h += step(2, 'AND (Mutually Exclusive)', '<span class="stat-katex" data-tex="P(A \\cap B) = 0"></span>');
            }
            h += step(3, 'OR (Addition Rule)', '<span class="stat-katex" data-tex="P(A \\cup B) = P(A) + P(B) - P(A \\cap B) = ' + C.fmt(r.pA, 4) + ' + ' + C.fmt(r.pB, 4) + ' - ' + C.fmt(r.pAandB, 4) + ' = ' + C.fmt(r.pAorB, 6) + '"></span>');
            h += step(4, 'Complements', '<span class="stat-katex" data-tex="P(\\neg A) = ' + C.fmt(r.pNotA, 6) + ',\\; P(\\neg B) = ' + C.fmt(r.pNotB, 6) + '"></span>');
        }
        return h + '</div>';
    }

    function step(num, title, content) {
        return '<div class="stat-step"><div class="stat-step-number">' + num + '</div><div class="stat-step-content"><strong>' + title + '</strong><div style="margin-top:0.25rem">' + content + '</div></div></div>';
    }

    function renderKaTeX() {
        var spans = document.querySelectorAll('.stat-katex');
        for (var i = 0; i < spans.length; i++) {
            var tex = spans[i].getAttribute('data-tex');
            if (tex && window.katex) {
                try { window.katex.render(tex, spans[i], { throwOnError: false }); } catch(e) {}
            }
        }
    }

    /* ===== Python Compiler ===== */
    function loadCompiler() {
        if (!state.result) return;
        var r = state.result;
        var lines = [];

        if (state.mode === 'basic') {
            lines.push('# Basic Probability Calculator');
            lines.push('favorable = ' + r.favorable);
            lines.push('total = ' + r.total);
            lines.push('');
            lines.push('prob = favorable / total');
            lines.push('complement = 1 - prob');
            lines.push('odds_for = prob / complement if complement > 0 else float("inf")');
            lines.push('odds_against = complement / prob if prob > 0 else float("inf")');
            lines.push('');
            lines.push('print(f"P(A) = {prob:.6f}")');
            lines.push('print(f"P(not A) = {complement:.6f}")');
            lines.push('print(f"Percentage = {prob * 100:.2f}%")');
            lines.push('print(f"Odds For = {favorable}:{total - favorable}")');
            lines.push('print(f"Odds Against = {total - favorable}:{favorable}")');
        } else if (state.mode === 'conditional') {
            lines.push('# Conditional Probability P(A|B)');
            lines.push('p_a_and_b = ' + r.pAandB);
            lines.push('p_b = ' + r.pB);
            lines.push('');
            lines.push('p_a_given_b = p_a_and_b / p_b');
            lines.push('');
            lines.push('print(f"P(A intersect B) = {p_a_and_b:.6f}")');
            lines.push('print(f"P(B) = {p_b:.6f}")');
            lines.push('print(f"P(A|B) = {p_a_given_b:.6f}")');
            lines.push('print(f"Percentage = {p_a_given_b * 100:.2f}%")');
        } else if (state.mode === 'bayes') {
            lines.push('# Bayes\' Theorem Calculator');
            lines.push('p_a = ' + r.pA);
            lines.push('p_b_given_a = ' + r.pBgivenA);
            lines.push('p_b_given_not_a = ' + r.pBgivenNotA);
            lines.push('');
            lines.push('p_not_a = 1 - p_a');
            lines.push('p_b = p_b_given_a * p_a + p_b_given_not_a * p_not_a');
            lines.push('posterior = (p_b_given_a * p_a) / p_b');
            lines.push('lr = p_b_given_a / p_b_given_not_a if p_b_given_not_a > 0 else float("inf")');
            lines.push('');
            lines.push('print(f"Prior P(A) = {p_a:.6f}")');
            lines.push('print(f"P(B) marginal = {p_b:.6f}")');
            lines.push('print(f"Posterior P(A|B) = {posterior:.6f}")');
            lines.push('print(f"Likelihood Ratio = {lr:.4f}")');
            lines.push('print(f"Change = {posterior - p_a:+.6f}")');
        } else {
            var rel = r.relation === 'independent' ? 'Independent' : 'Mutually Exclusive';
            lines.push('# Multiple Events (' + rel + ')');
            lines.push('p_a = ' + r.pA);
            lines.push('p_b = ' + r.pB);
            lines.push('relation = "' + r.relation + '"');
            lines.push('');
            if (r.relation === 'independent') {
                lines.push('p_a_and_b = p_a * p_b  # independent');
            } else {
                lines.push('p_a_and_b = 0  # mutually exclusive');
            }
            lines.push('p_a_or_b = p_a + p_b - p_a_and_b');
            lines.push('p_not_a = 1 - p_a');
            lines.push('p_not_b = 1 - p_b');
            lines.push('');
            lines.push('print(f"P(A AND B) = {p_a_and_b:.6f}")');
            lines.push('print(f"P(A OR B) = {p_a_or_b:.6f}")');
            lines.push('print(f"P(NOT A) = {p_not_a:.6f}")');
            lines.push('print(f"P(NOT B) = {p_not_b:.6f}")');
        }

        var code = lines.join('\n');
        var contextPath = document.querySelector('meta[name="context-path"]');
        var cp = contextPath ? contextPath.getAttribute('content') : '';
        els.compilerIframe.src = E.getCompilerUrl(code, null, cp);
    }

    /* ===== Clear ===== */
    function clearAll() {
        C.showEmpty(els.resultContent, '\uD83C\uDFB2', 'No Result Yet', 'Enter parameters and click Calculate');
        E.hideActionButtons(els.resultActions);
        els.compilerIframe.removeAttribute('src');
        state.result = null;
    }

    /* ===== Quick Examples ===== */
    function applyExample(ex) {
        if (ex === 'dice') {
            setMode('basic');
            document.getElementById('prob-favorable').value = '2';
            document.getElementById('prob-total').value = '6';
        } else if (ex === 'medical') {
            setMode('bayes');
            document.getElementById('prob-prior-a').value = '0.01';
            document.getElementById('prob-b-given-a').value = '0.95';
            document.getElementById('prob-b-given-not-a').value = '0.05';
        } else if (ex === 'cards') {
            setMode('basic');
            document.getElementById('prob-favorable').value = '13';
            document.getElementById('prob-total').value = '52';
        } else if (ex === 'weather') {
            setMode('conditional');
            document.getElementById('prob-a-and-b').value = '0.12';
            document.getElementById('prob-b').value = '0.30';
        }
        calculate();
    }

    /* ===== Restore from URL ===== */
    function restoreFromUrl() {
        var shared = E.parseShareUrl();
        if (!shared || !shared.mode) return false;

        setMode(shared.mode);

        if (shared.mode === 'basic') {
            if (shared.favorable != null) document.getElementById('prob-favorable').value = shared.favorable;
            if (shared.total != null) document.getElementById('prob-total').value = shared.total;
        } else if (shared.mode === 'conditional') {
            if (shared.pAandB != null) document.getElementById('prob-a-and-b').value = shared.pAandB;
            if (shared.pB != null) document.getElementById('prob-b').value = shared.pB;
        } else if (shared.mode === 'bayes') {
            if (shared.pA != null) document.getElementById('prob-prior-a').value = shared.pA;
            if (shared.pBgivenA != null) document.getElementById('prob-b-given-a').value = shared.pBgivenA;
            if (shared.pBgivenNotA != null) document.getElementById('prob-b-given-not-a').value = shared.pBgivenNotA;
        } else if (shared.mode === 'multiple') {
            if (shared.pA != null) document.getElementById('prob-pa').value = shared.pA;
            if (shared.pB != null) document.getElementById('prob-pb').value = shared.pB;
            if (shared.relation) document.getElementById('prob-relation').value = shared.relation;
        }

        calculate();
        return true;
    }

    /* ===== Init ===== */
    function init() {
        initDOM();
        initTabs();
        initModes();

        els.calcBtn.addEventListener('click', calculate);
        els.clearBtn.addEventListener('click', clearAll);

        var inputs = document.querySelectorAll('.prob-input');
        for (var i = 0; i < inputs.length; i++) {
            inputs[i].addEventListener('keypress', function(e) { if (e.key === 'Enter') calculate(); });
        }

        // Quick examples
        document.querySelectorAll('[data-prob-example]').forEach(function(el) {
            el.addEventListener('click', function() {
                applyExample(this.getAttribute('data-prob-example'));
            });
        });

        // Scroll animations
        if ('IntersectionObserver' in window) {
            var observer = new IntersectionObserver(function(entries) {
                entries.forEach(function(e) { if (e.isIntersecting) { e.target.classList.add('stat-visible'); observer.unobserve(e.target); }});
            }, { threshold: 0.1 });
            document.querySelectorAll('.stat-anim').forEach(function(el) { observer.observe(el); });
        }

        setMode('basic');

        // Restore shared state from URL or run default calculation
        if (!restoreFromUrl()) {
            calculate();
        }
    }

    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
    else init();
})();
