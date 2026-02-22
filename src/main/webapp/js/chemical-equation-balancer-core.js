/**
 * Chemical Equation Balancer — Core Orchestration Module
 * Exposed as window.CEBCore
 * Requires: CEBRender
 */
window.CEBCore = (function () {
    'use strict';

    var R = window.CEBRender;

    /* ===== State ===== */
    var state = { left: [], right: [], mode: 'atom' };
    var balanceTimer = null;

    /* ===== DOM Helpers ===== */
    function $(id) { return document.getElementById(id); }

    /* ===== Chip Management ===== */
    function buildStateFromInput() {
        try {
            var parsed = R.parseEquation(($('cb-eq').value || '').trim());
            state.left = parsed.left.map(function (x) { return { coef: Math.max(1, x.coef || 1), formula: x.formula }; });
            state.right = parsed.right.map(function (x) { return { coef: Math.max(1, x.coef || 1), formula: x.formula }; });
        } catch (e) {
            var raw = ($('cb-eq').value || '').split(/=>|->/);
            var L = (raw[0] || '').split('+').map(function (s) { return s.trim(); }).filter(Boolean);
            var Ri = (raw[1] || '').split('+').map(function (s) { return s.trim(); }).filter(Boolean);
            state.left = L.map(function (f) { return { coef: 1, formula: f }; });
            state.right = Ri.map(function (f) { return { coef: 1, formula: f }; });
        }
    }

    function applyStateToInput() {
        function sideToText(arr) {
            return arr.map(function (x) { return (x.coef > 1 ? x.coef + '' : '') + x.formula; }).join(' + ');
        }
        var eq = sideToText(state.left) + ' -> ' + sideToText(state.right);
        eq = eq.replace(/^\s*\+\s*/, '').replace(/\+\s*$/, '');
        $('cb-eq').value = eq;
        renderEqPreview();
        if ($('cb-optAuto') && $('cb-optAuto').checked) debounceBalance();
    }

    function renderChips() {
        var cL = $('cb-chipsLeft');
        var cR = $('cb-chipsRight');
        if (!cL || !cR) return;

        function chipHTML(x, idx, side) {
            return '<span class="cb-chip" data-side="' + side + '" data-idx="' + idx + '">' +
                '<button type="button" class="cb-chip-btn" data-act="dec" data-side="' + side + '" data-idx="' + idx + '">&minus;</button>' +
                '<span class="cb-chip-coeff">' + x.coef + '</span>' +
                '<span class="cb-chip-formula" data-act="edit" data-side="' + side + '" data-idx="' + idx + '">' + R.formatFormulaHTML(x.formula) + '</span>' +
                '<button type="button" class="cb-chip-btn" data-act="inc" data-side="' + side + '" data-idx="' + idx + '">+</button>' +
                '<button type="button" class="cb-chip-btn cb-chip-del" data-act="del" data-side="' + side + '" data-idx="' + idx + '">&times;</button>' +
                '</span>';
        }
        cL.innerHTML = state.left.map(function (x, i) { return chipHTML(x, i, 'left'); }).join('');
        cR.innerHTML = state.right.map(function (x, i) { return chipHTML(x, i, 'right'); }).join('');
    }

    function handleChipAction(e) {
        var btn = e.target.closest('[data-act]');
        if (!btn) return;
        var act = btn.getAttribute('data-act');
        var side = btn.getAttribute('data-side');
        var idx = parseInt(btn.getAttribute('data-idx'), 10);
        var arr = state[side];
        if (!arr || !arr[idx]) return;

        if (act === 'inc') { arr[idx].coef = Math.max(1, (arr[idx].coef || 1) + 1); }
        else if (act === 'dec') { arr[idx].coef = Math.max(1, (arr[idx].coef || 1) - 1); }
        else if (act === 'del') { arr.splice(idx, 1); }
        else if (act === 'edit') {
            var val = prompt('Edit formula', arr[idx].formula);
            if (val != null) arr[idx].formula = val.trim();
        }
        renderChips();
        applyStateToInput();
    }

    function addSpecies(side) {
        var inp = $(side === 'left' ? 'cb-addLeft' : 'cb-addRight');
        if (!inp) return;
        var v = (inp.value || '').trim();
        if (!v) return;
        state[side].push({ coef: 1, formula: v });
        inp.value = '';
        renderChips();
        applyStateToInput();
    }

    /* ===== Equation Preview ===== */
    function renderEqPreview() {
        var el = $('cb-eq');
        var prev = $('cb-eqPreview');
        if (!el || !prev) return;
        var text = el.value || '';
        if (!text.trim()) { prev.innerHTML = ''; return; }
        try {
            var parsed = R.parseEquation(text);
            var arrowSymbol = (parsed.arrow === '=>' || parsed.arrow === '⇒') ? '&rArr;' : '&rarr;';
            function fmt(side) {
                return side.map(function (s) {
                    return (s.coef > 1 ? '<span class="cb-coeff">' + s.coef + '</span>' : '') + R.formatFormulaHTML(s.formula);
                }).join(' + ');
            }
            prev.innerHTML = fmt(parsed.left) + ' ' + arrowSymbol + ' ' + fmt(parsed.right);
        } catch (e2) {
            var out = R.formatFormulaHTML(text);
            out = out.replace(/(=&gt;|=&gt;|=&gt;|&gt;|→|⇒)/g, '&rarr;');
            prev.innerHTML = out;
        }
    }

    /* ===== Balance ===== */
    function debounceBalance() { clearTimeout(balanceTimer); balanceTimer = setTimeout(balanceEquation, 350); }

    function balanceEquation() {
        var inp = ($('cb-eq').value || '').trim();
        var res = $('cb-result-content');
        if (!res) return;
        try {
            var parsed = R.parseEquation(inp);
            var elements = R.uniqueElements(parsed.left, parsed.right);
            if (elements.length === 0) throw new Error('Could not find any chemical elements.');
            var A = R.buildMatrix(elements, parsed.left, parsed.right);
            var coeffs = R.nullspaceInt(A);

            var opts = {
                hide1: $('cb-optHide1') && $('cb-optHide1').checked,
                showFrac: $('cb-optFrac') && $('cb-optFrac').checked
            };
            var result = R.buildResultDOM(parsed.left, parsed.right, coeffs, elements, parsed.arrow, opts);
            res.innerHTML = result.html;
            res.dataset.balanced = result.data.balanced;
            res.dataset.latex = result.data.latex;
            res.dataset.pretty = result.data.pretty;
            saveHistory(inp);
        } catch (e) {
            if (e && e.message === 'NO_ARROW') {
                res.innerHTML = R.buildSingleSideAnalysis(inp);
                return;
            }
            res.innerHTML = '<div class="cb-alert cb-alert-warning">' + R.escapeHtml(e.message || 'Error parsing equation') + '</div>';
        }
    }

    /* ===== Helpers for ToolUtils fallback ===== */
    function _toast(msg, dur, type) {
        if (typeof ToolUtils !== 'undefined' && ToolUtils.showToast) {
            ToolUtils.showToast(msg, dur || 2000, type || 'success');
        }
    }
    function _copy(text, label) {
        if (typeof ToolUtils !== 'undefined' && ToolUtils.copyToClipboard) {
            ToolUtils.copyToClipboard(text, { toastMessage: label + ' copied!' });
        } else if (navigator.clipboard) {
            navigator.clipboard.writeText(text);
        }
    }

    /* ===== Actions ===== */
    function handleActions(e) {
        var btn = e.target.closest('[data-action]');
        if (!btn) return;
        var action = btn.getAttribute('data-action');
        var res = $('cb-result-content');
        if (!res) return;

        if (action === 'copy') {
            var text = res.dataset.balanced || '';
            if (text) _copy(text, 'Equation');
        } else if (action === 'latex') {
            var tex = res.dataset.latex || '';
            if (tex) _copy(tex, 'LaTeX');
        } else if (action === 'png') {
            var resultCard = res.closest('.tool-result-card') || res;
            if (typeof ToolUtils !== 'undefined' && ToolUtils.downloadCanvasAsImage) {
                ToolUtils.downloadCanvasAsImage(resultCard, 'balanced-equation.png', 'Chemical Equation Balancer');
            } else {
                // Fallback: simple canvas from text
                var pretty = res.dataset.pretty || '';
                if (!pretty) return;
                var pad = 20, font = '20px Arial';
                var canvas = document.createElement('canvas'), ctx = canvas.getContext('2d');
                var tmp = document.createElement('canvas').getContext('2d');
                tmp.font = font;
                var w = tmp.measureText(pretty).width, h = 34;
                canvas.width = Math.ceil(w) + pad * 2;
                canvas.height = h + pad * 2;
                ctx.fillStyle = '#ffffff';
                ctx.fillRect(0, 0, canvas.width, canvas.height);
                ctx.fillStyle = '#000000';
                ctx.font = font;
                ctx.fillText(pretty, pad, pad + h * 0.7);
                var a = document.createElement('a');
                a.href = canvas.toDataURL('image/png');
                a.download = 'balanced-equation.png';
                a.click();
            }
        } else if (action === 'share') {
            var inp = ($('cb-eq').value || '').trim();
            var url = new URL(window.location.href.split('#')[0]);
            url.searchParams.set('q', inp);
            if ($('cb-optAuto') && $('cb-optAuto').checked) url.searchParams.set('auto', '1');
            if ($('cb-optHide1') && $('cb-optHide1').checked) url.searchParams.set('hide1', '1');
            if ($('cb-optFrac') && $('cb-optFrac').checked) url.searchParams.set('frac', '1');
            _copy(url.toString(), 'Share link');
            window.history.replaceState({}, '', url.toString());
        } else if (action === 'pdf') {
            downloadPDF();
        }
    }

    /* ===== Random Example ===== */
    function loadRandomExample() {
        var allEqs = DATABASE.map(function (d) { return d.unbalanced; });
        var rand = allEqs[Math.floor(Math.random() * allEqs.length)];
        loadExample(rand);
        _toast('Random equation loaded!', 1500, 'info');
    }

    /* ===== PDF Download ===== */
    function downloadPDF() {
        var res = $('cb-result-content');
        if (!res || !res.dataset.balanced) {
            _toast('Balance an equation first.', 2000, 'warning');
            return;
        }
        _toast('Generating PDF...', 1500, 'info');
        var loadHtml2Canvas = (typeof html2canvas !== 'undefined') ? Promise.resolve() : (typeof ToolUtils !== 'undefined' && ToolUtils._loadScript ? ToolUtils._loadScript('https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js') : Promise.reject('No loader'));
        loadHtml2Canvas
            .then(function () {
                var jsPDFLoad = (typeof window.jspdf !== 'undefined') ? Promise.resolve() : (typeof ToolUtils !== 'undefined' && ToolUtils._loadScript ? ToolUtils._loadScript('https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js') : Promise.reject('No loader'));
                return jsPDFLoad;
            })
            .then(function () {
                var target = res.closest('.tool-result-card') || res;
                return html2canvas(target, { scale: 2, backgroundColor: '#ffffff', useCORS: true });
            })
            .then(function (canvas) {
                var jsPDF = window.jspdf.jsPDF;
                var imgData = canvas.toDataURL('image/png');
                var pdf = new jsPDF('l', 'mm', 'a4');
                var pW = pdf.internal.pageSize.getWidth() - 20;
                var pH = (canvas.height / canvas.width) * pW;
                pdf.setFontSize(16);
                pdf.text('Chemical Equation Balancer — 8gwifi.org', 10, 12);
                pdf.addImage(imgData, 'PNG', 10, 18, pW, pH);
                pdf.save('balanced-equation.pdf');
                _toast('PDF downloaded!', 2000, 'success');
                if (typeof ToolUtils !== 'undefined' && ToolUtils.showSupportPopup) {
                    ToolUtils.showSupportPopup('Chemical Equation Balancer', 'Downloaded: balanced-equation.pdf');
                }
            })
            .catch(function (err) {
                _toast('PDF generation failed: ' + (err.message || err), 3000, 'error');
            });
    }

    /* ===== Print Worksheet ===== */
    function generateWorksheet() {
        // Pick a configurable number of random equations
        var count = parseInt(($('cb-worksheet-count') || {}).value || '10', 10);
        count = Math.max(3, Math.min(count, DATABASE.length));
        var shuffled = DATABASE.slice().sort(function () { return 0.5 - Math.random(); });
        var selected = shuffled.slice(0, count);

        var html = '<!DOCTYPE html><html><head><meta charset="UTF-8">' +
            '<title>Chemical Equation Balancing Worksheet</title>' +
            '<style>' +
            'body{font-family:Georgia,serif;max-width:800px;margin:0 auto;padding:2rem;color:#222;}' +
            'h1{text-align:center;font-size:1.5rem;margin-bottom:0.25rem;}' +
            '.subtitle{text-align:center;color:#666;font-size:0.9rem;margin-bottom:2rem;}' +
            '.info-bar{display:flex;justify-content:space-between;border-top:2px solid #222;border-bottom:2px solid #222;padding:0.5rem 0;margin-bottom:1.5rem;font-size:0.9rem;}' +
            'table{width:100%;border-collapse:collapse;margin-bottom:2rem;}' +
            'th{background:#f5f5f5;border:1px solid #ccc;padding:0.5rem 0.75rem;text-align:left;font-size:0.8rem;text-transform:uppercase;letter-spacing:0.05em;}' +
            'td{border:1px solid #ccc;padding:0.625rem 0.75rem;font-size:0.95rem;vertical-align:top;}' +
            'td.num{width:2rem;text-align:center;font-weight:bold;color:#666;}' +
            'td.type{width:6rem;font-size:0.8rem;color:#888;}' +
            'td.eq{font-family:"Courier New",monospace;}' +
            'td.answer{min-width:12rem;height:2.5rem;}' +
            '.footer{text-align:center;color:#999;font-size:0.75rem;margin-top:1rem;border-top:1px solid #ddd;padding-top:0.75rem;}' +
            'h2{font-size:1.1rem;margin:2rem 0 0.75rem;page-break-before:always;}' +
            '.answer-key td.answer{font-family:"Courier New",monospace;font-weight:bold;color:#059669;}' +
            '@media print{body{padding:1rem;}.no-print{display:none !important;}}' +
            '</style></head><body>';

        html += '<h1>Chemical Equation Balancing Worksheet</h1>';
        html += '<p class="subtitle">Balance each equation by adding the correct integer coefficients</p>';
        html += '<div class="info-bar"><span>Name: _________________________</span><span>Date: ______________</span><span>Score: ___ / ' + count + '</span></div>';

        // Questions table
        html += '<table><thead><tr><th>#</th><th>Type</th><th>Unbalanced Equation</th><th>Balanced Equation</th></tr></thead><tbody>';
        selected.forEach(function (d, i) {
            html += '<tr><td class="num">' + (i + 1) + '</td><td class="type">' + R.escapeHtml(d.type) + '</td><td class="eq">' + R.escapeHtml(d.unbalanced).replace(/->/g, '\u2192') + '</td><td class="answer"></td></tr>';
        });
        html += '</tbody></table>';

        // Answer key on second page
        html += '<h2>Answer Key</h2>';
        html += '<table class="answer-key"><thead><tr><th>#</th><th>Type</th><th>Unbalanced</th><th>Balanced (Answer)</th></tr></thead><tbody>';
        selected.forEach(function (d, i) {
            html += '<tr><td class="num">' + (i + 1) + '</td><td class="type">' + R.escapeHtml(d.type) + '</td><td class="eq">' + R.escapeHtml(d.unbalanced).replace(/->/g, '\u2192') + '</td><td class="answer">' + R.escapeHtml(d.balanced).replace(/->/g, '\u2192') + '</td></tr>';
        });
        html += '</tbody></table>';

        html += '<div class="footer">Generated by Chemical Equation Balancer &mdash; 8gwifi.org</div>';
        html += '<div class="no-print" style="text-align:center;margin-top:1rem;"><button onclick="window.print()" style="padding:0.5rem 2rem;font-size:1rem;cursor:pointer;border:2px solid #ec4899;background:#fff;color:#ec4899;border-radius:0.5rem;">Print Worksheet</button></div>';
        html += '</body></html>';

        var win = window.open('', '_blank');
        if (win) {
            win.document.write(html);
            win.document.close();
            _toast('Worksheet generated!', 2000, 'success');
        } else {
            _toast('Pop-up blocked. Allow pop-ups and try again.', 3000, 'warning');
        }
    }

    /* ===== Tab Switching ===== */
    function switchTab(panel) {
        var tabs = document.querySelectorAll('.cb-output-tab');
        var panels = document.querySelectorAll('.cb-panel');
        tabs.forEach(function (t) {
            t.classList.toggle('active', t.getAttribute('data-panel') === panel);
        });
        panels.forEach(function (p) {
            p.classList.toggle('active', p.id === 'cb-panel-' + panel);
        });
    }

    /* ===== Examples ===== */
    var EXAMPLES = [
        { label: 'Combustion', eq: 'C3H8 + O2 -> CO2 + H2O' },
        { label: 'Oxidation', eq: 'Fe + O2 -> Fe2O3' },
        { label: 'Acid-Base', eq: 'Ca(OH)2 + H3PO4 -> Ca3(PO4)2 + H2O' },
        { label: 'Hydrate', eq: 'CuSO4.5H2O -> CuSO4 + H2O' },
        { label: 'Single Repl.', eq: 'Zn + HCl -> ZnCl2 + H2' },
        { label: 'Double Repl.', eq: 'AgNO3 + NaCl -> AgCl + NaNO3' },
        { label: 'Decomposition', eq: 'KClO3 -> KCl + O2' },
        { label: 'Synthesis', eq: 'H2 + O2 -> H2O' },
        { label: 'Neutralization', eq: 'HCl + NaOH -> NaCl + H2O' },
        { label: 'Photosynthesis', eq: 'CO2 + H2O -> C6H12O6 + O2' },
        { label: 'Polyatomic', eq: 'Al2(SO4)3 + Ca(OH)2 -> Al(OH)3 + CaSO4' },
        { label: 'Precipitation', eq: 'BaCl2 + Al2(SO4)3 -> BaSO4 + AlCl3' }
    ];

    /* Database entries — comprehensive collection for education */
    var DATABASE = [
        /* Combustion */
        { type: 'Combustion', unbalanced: 'C3H8 + O2 -> CO2 + H2O', balanced: 'C3H8 + 5O2 -> 3CO2 + 4H2O' },
        { type: 'Combustion', unbalanced: 'CH4 + O2 -> CO2 + H2O', balanced: 'CH4 + 2O2 -> CO2 + 2H2O' },
        { type: 'Combustion', unbalanced: 'C2H6 + O2 -> CO2 + H2O', balanced: '2C2H6 + 7O2 -> 4CO2 + 6H2O' },
        { type: 'Combustion', unbalanced: 'C6H12O6 + O2 -> CO2 + H2O', balanced: 'C6H12O6 + 6O2 -> 6CO2 + 6H2O' },
        { type: 'Combustion', unbalanced: 'C2H5OH + O2 -> CO2 + H2O', balanced: 'C2H5OH + 3O2 -> 2CO2 + 3H2O' },
        { type: 'Combustion', unbalanced: 'C4H10 + O2 -> CO2 + H2O', balanced: '2C4H10 + 13O2 -> 8CO2 + 10H2O' },
        /* Oxidation */
        { type: 'Oxidation', unbalanced: 'Fe + O2 -> Fe2O3', balanced: '4Fe + 3O2 -> 2Fe2O3' },
        { type: 'Oxidation', unbalanced: 'Al + O2 -> Al2O3', balanced: '4Al + 3O2 -> 2Al2O3' },
        { type: 'Oxidation', unbalanced: 'Mg + O2 -> MgO', balanced: '2Mg + O2 -> 2MgO' },
        /* Acid-Base / Neutralization */
        { type: 'Acid-Base', unbalanced: 'Ca(OH)2 + H3PO4 -> Ca3(PO4)2 + H2O', balanced: '3Ca(OH)2 + 2H3PO4 -> Ca3(PO4)2 + 6H2O' },
        { type: 'Neutralization', unbalanced: 'HCl + NaOH -> NaCl + H2O', balanced: 'HCl + NaOH -> NaCl + H2O' },
        { type: 'Neutralization', unbalanced: 'H2SO4 + NaOH -> Na2SO4 + H2O', balanced: 'H2SO4 + 2NaOH -> Na2SO4 + 2H2O' },
        { type: 'Neutralization', unbalanced: 'H3PO4 + KOH -> K3PO4 + H2O', balanced: 'H3PO4 + 3KOH -> K3PO4 + 3H2O' },
        { type: 'Neutralization', unbalanced: 'HNO3 + Ca(OH)2 -> Ca(NO3)2 + H2O', balanced: '2HNO3 + Ca(OH)2 -> Ca(NO3)2 + 2H2O' },
        /* Hydrate */
        { type: 'Hydrate', unbalanced: 'CuSO4.5H2O -> CuSO4 + H2O', balanced: 'CuSO4.5H2O -> CuSO4 + 5H2O' },
        { type: 'Hydrate', unbalanced: 'Na2CO3.10H2O -> Na2CO3 + H2O', balanced: 'Na2CO3.10H2O -> Na2CO3 + 10H2O' },
        /* Single Replacement */
        { type: 'Single Repl.', unbalanced: 'Zn + HCl -> ZnCl2 + H2', balanced: 'Zn + 2HCl -> ZnCl2 + H2' },
        { type: 'Single Repl.', unbalanced: 'Fe + CuSO4 -> FeSO4 + Cu', balanced: 'Fe + CuSO4 -> FeSO4 + Cu' },
        { type: 'Single Repl.', unbalanced: 'Cu + AgNO3 -> Cu(NO3)2 + Ag', balanced: 'Cu + 2AgNO3 -> Cu(NO3)2 + 2Ag' },
        /* Double Replacement */
        { type: 'Double Repl.', unbalanced: 'AgNO3 + NaCl -> AgCl + NaNO3', balanced: 'AgNO3 + NaCl -> AgCl + NaNO3' },
        { type: 'Double Repl.', unbalanced: 'Pb(NO3)2 + KI -> PbI2 + KNO3', balanced: 'Pb(NO3)2 + 2KI -> PbI2 + 2KNO3' },
        { type: 'Double Repl.', unbalanced: 'Na2SO4 + BaCl2 -> BaSO4 + NaCl', balanced: 'Na2SO4 + BaCl2 -> BaSO4 + 2NaCl' },
        /* Decomposition */
        { type: 'Decomposition', unbalanced: 'KClO3 -> KCl + O2', balanced: '2KClO3 -> 2KCl + 3O2' },
        { type: 'Decomposition', unbalanced: 'H2O2 -> H2O + O2', balanced: '2H2O2 -> 2H2O + O2' },
        { type: 'Decomposition', unbalanced: 'CaCO3 -> CaO + CO2', balanced: 'CaCO3 -> CaO + CO2' },
        { type: 'Decomposition', unbalanced: 'NaHCO3 -> Na2CO3 + H2O + CO2', balanced: '2NaHCO3 -> Na2CO3 + H2O + CO2' },
        /* Synthesis */
        { type: 'Synthesis', unbalanced: 'H2 + O2 -> H2O', balanced: '2H2 + O2 -> 2H2O' },
        { type: 'Synthesis', unbalanced: 'N2 + H2 -> NH3', balanced: 'N2 + 3H2 -> 2NH3' },
        { type: 'Synthesis', unbalanced: 'Na + Cl2 -> NaCl', balanced: '2Na + Cl2 -> 2NaCl' },
        { type: 'Synthesis', unbalanced: 'Fe + S -> FeS', balanced: 'Fe + S -> FeS' },
        /* Photosynthesis / Respiration */
        { type: 'Photosynthesis', unbalanced: 'CO2 + H2O -> C6H12O6 + O2', balanced: '6CO2 + 6H2O -> C6H12O6 + 6O2' },
        { type: 'Respiration', unbalanced: 'C6H12O6 + O2 -> CO2 + H2O', balanced: 'C6H12O6 + 6O2 -> 6CO2 + 6H2O' },
        /* Precipitation */
        { type: 'Precipitation', unbalanced: 'BaCl2 + Al2(SO4)3 -> BaSO4 + AlCl3', balanced: '3BaCl2 + Al2(SO4)3 -> 3BaSO4 + 2AlCl3' },
        { type: 'Precipitation', unbalanced: 'CaCl2 + Na2CO3 -> CaCO3 + NaCl', balanced: 'CaCl2 + Na2CO3 -> CaCO3 + 2NaCl' },
        /* Redox */
        { type: 'Redox', unbalanced: 'KMnO4 + HCl -> KCl + MnCl2 + Cl2 + H2O', balanced: '2KMnO4 + 16HCl -> 2KCl + 2MnCl2 + 5Cl2 + 8H2O' },
        { type: 'Redox', unbalanced: 'Cu + HNO3 -> Cu(NO3)2 + NO + H2O', balanced: '3Cu + 8HNO3 -> 3Cu(NO3)2 + 2NO + 4H2O' },
        /* Organic */
        { type: 'Organic', unbalanced: 'C2H4 + O2 -> CO2 + H2O', balanced: 'C2H4 + 3O2 -> 2CO2 + 2H2O' },
        { type: 'Organic', unbalanced: 'C6H6 + O2 -> CO2 + H2O', balanced: '2C6H6 + 15O2 -> 12CO2 + 6H2O' },
        /* Thermite / Industrial */
        { type: 'Thermite', unbalanced: 'Al + Fe2O3 -> Al2O3 + Fe', balanced: '2Al + Fe2O3 -> Al2O3 + 2Fe' },
        { type: 'Industrial', unbalanced: 'N2 + O2 -> NO', balanced: 'N2 + O2 -> 2NO' },
        { type: 'Industrial', unbalanced: 'SO2 + O2 -> SO3', balanced: '2SO2 + O2 -> 2SO3' }
    ];

    function loadExample(eq) {
        switchTab('result');
        var el = $('cb-eq');
        if (!el) return false;
        el.value = eq;
        buildStateFromInput();
        renderChips();
        renderEqPreview();
        balanceEquation();
        saveHistory(eq);
        try { el.focus(); el.scrollIntoView({ behavior: 'smooth', block: 'center' }); } catch (e) { }
        return false;
    }

    /* ===== History ===== */
    function saveHistory(eq) {
        try {
            var key = 'chem_eq_history';
            var arr = JSON.parse(localStorage.getItem(key) || '[]');
            if (eq && arr[0] !== eq) arr.unshift(eq);
            while (arr.length > 10) arr.pop();
            localStorage.setItem(key, JSON.stringify(arr));
            renderHistory();
        } catch (e) { }
    }

    function renderHistory() {
        try {
            var key = 'chem_eq_history';
            var arr = JSON.parse(localStorage.getItem(key) || '[]');
            var el = $('cb-historyList');
            if (!el) return;
            el.innerHTML = arr.map(function (x) {
                return '<a class="cb-history-item" href="#" data-eq="' + R.escapeHtml(x) + '">' + R.escapeHtml(x) + '</a>';
            }).join('');
        } catch (e) { }
    }

    function clearHistory() {
        localStorage.removeItem('chem_eq_history');
        renderHistory();
    }

    /* ===== Redox ===== */
    function combineRedox() {
        var out = $('cb-redoxResult');
        if (!out) return;
        try {
            var oxText = ($('cb-halfOx').value || '').trim();
            var redText = ($('cb-halfRed').value || '').trim();
            var netHtml = R.combineHalfReactions(oxText, redText);
            out.innerHTML = '<div style="padding:0.75rem;"><strong>Net Reaction (beta):</strong><br>' + netHtml + '</div>';
        } catch (e) {
            out.innerHTML = '<div class="cb-alert cb-alert-warning" style="margin:0.75rem;">' + R.escapeHtml(e.message) + '</div>';
        }
    }

    function resetRedox() {
        if ($('cb-halfOx')) $('cb-halfOx').value = '';
        if ($('cb-halfRed')) $('cb-halfRed').value = '';
        if ($('cb-redoxResult')) $('cb-redoxResult').innerHTML = '';
    }

    /* ===== Database Tab ===== */
    function renderDatabase(filter) {
        var tbody = $('cb-db-body');
        if (!tbody) return;
        filter = (filter || '').toLowerCase();
        var rows = DATABASE.filter(function (d) {
            if (!filter) return true;
            return d.type.toLowerCase().indexOf(filter) !== -1 ||
                d.unbalanced.toLowerCase().indexOf(filter) !== -1 ||
                d.balanced.toLowerCase().indexOf(filter) !== -1;
        });
        tbody.innerHTML = rows.map(function (d) {
            return '<tr data-eq="' + R.escapeHtml(d.unbalanced) + '">' +
                '<td style="font-family:var(--font-sans);font-weight:500">' + R.escapeHtml(d.type) + '</td>' +
                '<td>' + R.formatFormulaHTML(d.unbalanced.replace(/->/g, '\u2192')) + '</td>' +
                '<td>' + R.formatFormulaHTML(d.balanced.replace(/->/g, '\u2192')) + '</td>' +
                '</tr>';
        }).join('');
    }

    /* ===== FAQ Toggle ===== */
    function toggleFaq(btn) {
        var item = btn.closest('.cb-faq-item');
        if (item) item.classList.toggle('open');
    }

    /* ===== Init ===== */
    function init() {
        // URL params
        var params = new URLSearchParams(window.location.search);
        var q = params.get('q');
        if (q && $('cb-eq')) $('cb-eq').value = q;
        if (params.get('auto') === '1' && $('cb-optAuto')) $('cb-optAuto').checked = true;
        if (params.get('hide1') === '1' && $('cb-optHide1')) $('cb-optHide1').checked = true;
        if (params.get('frac') === '1' && $('cb-optFrac')) $('cb-optFrac').checked = true;

        // Equation input
        var eqInput = $('cb-eq');
        if (eqInput) {
            eqInput.addEventListener('input', function () {
                renderEqPreview();
                buildStateFromInput();
                renderChips();
                if ($('cb-optAuto') && $('cb-optAuto').checked) debounceBalance();
            });
        }

        // Balance button
        var balBtn = $('cb-balance-btn');
        if (balBtn) balBtn.addEventListener('click', balanceEquation);

        // Reset button
        var resetBtn = $('cb-reset-btn');
        if (resetBtn) resetBtn.addEventListener('click', function () {
            if ($('cb-eq')) $('cb-eq').value = '';
            state.left = [];
            state.right = [];
            renderChips();
            renderEqPreview();
            var res = $('cb-result-content');
            if (res) res.innerHTML = '<div class="tool-empty-state" id="cb-empty-state"><div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#8652;</div><h3>Enter an equation</h3><p>Type a chemical equation above to balance it automatically.</p></div>';
        });

        // Chip events (delegated)
        var chipsLeft = $('cb-chipsLeft');
        var chipsRight = $('cb-chipsRight');
        if (chipsLeft) chipsLeft.addEventListener('click', handleChipAction);
        if (chipsRight) chipsRight.addEventListener('click', handleChipAction);

        // Add species buttons
        var addLeftBtn = $('cb-addLeftBtn');
        var addRightBtn = $('cb-addRightBtn');
        if (addLeftBtn) addLeftBtn.addEventListener('click', function () { addSpecies('left'); });
        if (addRightBtn) addRightBtn.addEventListener('click', function () { addSpecies('right'); });
        // Enter key on add inputs
        var addLeftInp = $('cb-addLeft');
        var addRightInp = $('cb-addRight');
        if (addLeftInp) addLeftInp.addEventListener('keydown', function (e) { if (e.key === 'Enter') { e.preventDefault(); addSpecies('left'); } });
        if (addRightInp) addRightInp.addEventListener('keydown', function (e) { if (e.key === 'Enter') { e.preventDefault(); addSpecies('right'); } });

        // Options checkboxes
        ['cb-optAuto', 'cb-optHide1', 'cb-optFrac'].forEach(function (id) {
            var el = $(id);
            if (el) el.addEventListener('change', function () { if ($('cb-optAuto') && $('cb-optAuto').checked) debounceBalance(); });
        });

        // Tab switching
        document.querySelectorAll('.cb-output-tab').forEach(function (tab) {
            tab.addEventListener('click', function () { switchTab(tab.getAttribute('data-panel')); });
        });

        // Example chips
        document.querySelectorAll('.cb-example-chip').forEach(function (chip) {
            chip.addEventListener('click', function () {
                var eq = chip.getAttribute('data-eq');
                if (eq) loadExample(eq);
            });
        });

        // Result actions (delegated)
        var resContent = $('cb-result-content');
        if (resContent) resContent.addEventListener('click', handleActions);

        // Random example button
        var randomBtn = $('cb-random-btn');
        if (randomBtn) randomBtn.addEventListener('click', loadRandomExample);

        // Worksheet button
        var worksheetBtn = $('cb-worksheet-btn');
        if (worksheetBtn) worksheetBtn.addEventListener('click', generateWorksheet);

        // Redox
        var redoxBtn = $('cb-redox-combine');
        if (redoxBtn) redoxBtn.addEventListener('click', combineRedox);
        var redoxResetBtn = $('cb-redox-reset');
        if (redoxResetBtn) redoxResetBtn.addEventListener('click', resetRedox);

        // Database
        renderDatabase('');
        var searchInput = $('cb-db-search');
        if (searchInput) searchInput.addEventListener('input', function () { renderDatabase(searchInput.value); });
        var dbBody = $('cb-db-body');
        if (dbBody) dbBody.addEventListener('click', function (e) {
            var tr = e.target.closest('tr[data-eq]');
            if (tr) loadExample(tr.getAttribute('data-eq'));
        });

        // History
        var histList = $('cb-historyList');
        if (histList) histList.addEventListener('click', function (e) {
            var a = e.target.closest('[data-eq]');
            if (a) { e.preventDefault(); loadExample(a.getAttribute('data-eq')); }
        });
        var histClear = $('cb-historyClear');
        if (histClear) histClear.addEventListener('click', clearHistory);

        // FAQ
        document.querySelectorAll('.cb-faq-question').forEach(function (btn) {
            btn.addEventListener('click', function () { toggleFaq(btn); });
        });

        // Build initial state
        buildStateFromInput();
        renderChips();
        renderEqPreview();
        renderHistory();
        if (q) balanceEquation();

        // Scroll animations
        var anims = document.querySelectorAll('.cb-anim');
        if (anims.length) {
            if ('IntersectionObserver' in window) {
                var obs = new IntersectionObserver(function (entries) {
                    entries.forEach(function (e) {
                        if (e.isIntersecting) { e.target.classList.add('cb-visible'); obs.unobserve(e.target); }
                    });
                }, { threshold: 0.15 });
                anims.forEach(function (el) { obs.observe(el); });
            } else {
                anims.forEach(function (el) { el.classList.add('cb-visible'); });
            }
        }
    }

    // Auto-init on DOMContentLoaded
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }

    /* ===== Public API ===== */
    return {
        loadExample: loadExample,
        loadRandomExample: loadRandomExample,
        balanceEquation: balanceEquation,
        generateWorksheet: generateWorksheet,
        downloadPDF: downloadPDF,
        state: state,
        DATABASE: DATABASE
    };
})();
