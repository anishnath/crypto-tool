/**
 * Molecular Geometry Calculator - Core Orchestration
 * State management, events, integration with Render module
 */
(function() {
'use strict';

var R = window.MolGeomRender;

// ==================== State ====================

var state = {
    mode: 'pairs',
    bp: 4,
    lp: 0,
    formula: '',
    lastFormula: '' // tracks the formula used for last result (for Lewis link + PDF)
};

// ==================== Helpers ====================

function $(id) { return document.getElementById(id); }

function intVal(id, fallback) {
    var el = $(id);
    if (!el) return fallback || 0;
    return parseInt(el.value) || fallback || 0;
}

// ==================== Lewis Structure Link ====================

function updateLewisLink(formula) {
    var btn = $('mg-lewis-btn');
    if (!btn) return;
    if (formula) {
        // Strip charge for Lewis URL (lewis page handles neutral formulas)
        var cleanFormula = formula.replace(/[+()\-\d]*$/, '') || formula;
        btn.href = 'lewis-structure-generator.jsp?formula=' + encodeURIComponent(formula);
        btn.style.display = '';
        state.lastFormula = formula;
    } else {
        btn.style.display = 'none';
        state.lastFormula = '';
    }
}

// ==================== Mode Switching ====================

function switchMode(mode) {
    state.mode = mode;
    var btns = document.querySelectorAll('.mg-mode-btn');
    for (var i = 0; i < btns.length; i++) {
        btns[i].classList.toggle('active', btns[i].getAttribute('data-mode') === mode);
    }
    var forms = document.querySelectorAll('.mg-mode-form');
    for (var j = 0; j < forms.length; j++) {
        forms[j].classList.toggle('active', forms[j].id === 'mg-form-' + mode);
    }
}

// ==================== Calculate ====================

function calculate() {
    var container = $('mg-result-content');
    if (!container) return;

    var empty = $('mg-empty-state');
    if (empty) empty.style.display = 'none';

    var actions = $('mg-result-actions');
    if (actions) actions.style.display = 'flex';

    if (state.mode === 'pairs') {
        state.bp = intVal('mg-bp', 4);
        state.lp = intVal('mg-lp', 0);
        R.renderByPairs(container, state.bp, state.lp);
        // No specific formula for pairs mode — hide Lewis link
        updateLewisLink('');
    } else if (state.mode === 'formula') {
        var formulaEl = $('mg-formula');
        state.formula = formulaEl ? formulaEl.value.trim() : '';
        if (!state.formula) {
            R.showError(container, 'Please enter a chemical formula.');
            return;
        }
        R.renderByFormula(container, state.formula);
        updateLewisLink(state.formula);
    } else if (state.mode === 'database') {
        return;
    }
}

// ==================== Database ====================

function filterTable() {
    var searchEl = $('mg-search');
    var tbody = $('mg-table-body');
    R.renderMoleculeTable(tbody, searchEl ? searchEl.value : '');
}

function loadMolecule(formula) {
    var formulaEl = $('mg-formula');
    if (formulaEl) formulaEl.value = formula;
    switchMode('formula');
    state.mode = 'formula';
    state.formula = formula;
    var container = $('mg-result-content');
    if (container) {
        var empty = $('mg-empty-state');
        if (empty) empty.style.display = 'none';
        var actions = $('mg-result-actions');
        if (actions) actions.style.display = 'flex';
        R.renderByFormula(container, formula);
        updateLewisLink(formula);
    }
    // Switch to result tab
    var tabs = document.querySelectorAll('.mg-output-tab');
    var panels = document.querySelectorAll('.mg-panel');
    for (var t = 0; t < tabs.length; t++) {
        tabs[t].classList.toggle('active', tabs[t].getAttribute('data-panel') === 'result');
    }
    for (var p = 0; p < panels.length; p++) {
        panels[p].classList.toggle('active', panels[p].id === 'mg-panel-result');
    }
}

// ==================== Examples ====================

function loadExample(name) {
    var examples = {
        'ch4':  { mode: 'formula', formula: 'CH4' },
        'h2o':  { mode: 'formula', formula: 'H2O' },
        'nh3':  { mode: 'formula', formula: 'NH3' },
        'sf6':  { mode: 'formula', formula: 'SF6' },
        'co2':  { mode: 'formula', formula: 'CO2' },
        'bf3':  { mode: 'formula', formula: 'BF3' },
        'xef4': { mode: 'formula', formula: 'XeF4' },
        'pcl5': { mode: 'formula', formula: 'PCl5' },
        'nh4+': { mode: 'formula', formula: 'NH4+' },
        'sf4':  { mode: 'formula', formula: 'SF4' },
        'clf3': { mode: 'formula', formula: 'ClF3' },
        'if7':  { mode: 'formula', formula: 'IF7' }
    };
    var ex = examples[name];
    if (!ex) return;
    switchMode('formula');
    var formulaEl = $('mg-formula');
    if (formulaEl) formulaEl.value = ex.formula;
    state.formula = ex.formula;
    calculate();
}

// ==================== Clear ====================

function clearAll() {
    var bpEl = $('mg-bp');
    var lpEl = $('mg-lp');
    var formulaEl = $('mg-formula');
    if (bpEl) bpEl.value = '4';
    if (lpEl) lpEl.value = '0';
    if (formulaEl) formulaEl.value = '';

    var content = $('mg-result-content');
    if (content) {
        content.innerHTML = '<div class="tool-empty-state" id="mg-empty-state">' +
            '<div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#9883;</div>' +
            '<h3>Enter molecule details</h3>' +
            '<p>Determine molecular geometry using VSEPR theory with step-by-step analysis.</p></div>';
    }

    var actions = $('mg-result-actions');
    if (actions) actions.style.display = 'none';

    updateLewisLink('');
    switchMode('pairs');
}

// ==================== URL State ====================

function loadFromURL() {
    var params = new URLSearchParams(window.location.search);
    var d = params.get('d');
    if (!d) return false;
    try {
        var data = JSON.parse(atob(d));
        if (data.mode) switchMode(data.mode);
        if (data.mode === 'pairs') {
            var bpEl = $('mg-bp');
            var lpEl = $('mg-lp');
            if (bpEl && data.bp !== undefined) bpEl.value = data.bp;
            if (lpEl && data.lp !== undefined) lpEl.value = data.lp;
        } else if (data.mode === 'formula' && data.f) {
            var formulaEl = $('mg-formula');
            if (formulaEl) formulaEl.value = data.f;
            state.formula = data.f;
        }
        calculate();
        return true;
    } catch (e) {
        return false;
    }
}

// ==================== Share ====================

function buildShareUrl() {
    var data = { mode: state.mode };
    if (state.mode === 'pairs') { data.bp = state.bp; data.lp = state.lp; }
    else if (state.mode === 'formula') { data.f = state.formula; }
    return window.location.origin + window.location.pathname + '?d=' + btoa(JSON.stringify(data));
}

function copyShareUrl() {
    var url = buildShareUrl();
    if (typeof ToolUtils !== 'undefined') {
        ToolUtils.copyToClipboard(url, { toastMessage: 'Share link copied!' });
    } else if (navigator.clipboard) {
        navigator.clipboard.writeText(url);
    }
}

// ==================== Download PDF ====================

function downloadPdf() {
    var resultContent = $('mg-result-content');
    if (!resultContent || resultContent.querySelector('.tool-empty-state')) {
        if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('No result to download. Calculate first.', 2000, 'warning');
        return;
    }

    // Build off-screen styled container
    var container = document.createElement('div');
    container.style.cssText = 'position:absolute;left:-9999px;top:0;width:700px;padding:40px;background:#fff;font-family:Inter,-apple-system,BlinkMacSystemFont,sans-serif;color:#0f172a;';
    document.body.appendChild(container);

    // Title bar
    var title = document.createElement('div');
    title.style.cssText = 'font-size:22px;font-weight:700;margin-bottom:8px;color:#059669;';
    title.textContent = 'Molecular Geometry \u2014 8gwifi.org';
    container.appendChild(title);

    var divider = document.createElement('div');
    divider.style.cssText = 'height:2px;background:linear-gradient(90deg,#059669,#10b981,transparent);margin-bottom:24px;';
    container.appendChild(divider);

    // Subtitle — formula or BP/LP
    var subtitle = document.createElement('div');
    subtitle.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:12px;';
    if (state.mode === 'formula' && state.formula) {
        subtitle.textContent = 'Formula: ' + state.formula;
    } else {
        subtitle.textContent = 'Bonding Pairs: ' + state.bp + '  |  Lone Pairs: ' + state.lp;
    }
    container.appendChild(subtitle);

    // Badge — geometry name
    var badge = resultContent.querySelector('.mg-badge');
    if (badge) {
        var badgeEl = document.createElement('div');
        badgeEl.style.cssText = 'display:inline-block;background:#059669;color:#fff;padding:6px 16px;border-radius:12px;font-size:14px;font-weight:600;margin-bottom:20px;';
        badgeEl.textContent = badge.textContent;
        container.appendChild(badgeEl);
    }

    // Result grid values
    var items = resultContent.querySelectorAll('.mg-result-item');
    if (items.length > 0) {
        var grid = document.createElement('div');
        grid.style.cssText = 'display:grid;grid-template-columns:1fr 1fr 1fr;gap:12px;margin-bottom:20px;';
        for (var g = 0; g < items.length; g++) {
            var cell = document.createElement('div');
            cell.style.cssText = 'padding:10px;background:#ecfdf5;border-radius:8px;text-align:center;';
            var label = items[g].querySelector('.mg-result-label');
            var value = items[g].querySelector('.mg-result-value');
            cell.innerHTML = '<div style="font-size:10px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:4px;">' +
                (label ? label.textContent : '') + '</div>' +
                '<div style="font-size:16px;font-weight:700;color:#0f172a;">' + (value ? value.textContent : '') + '</div>';
            grid.appendChild(cell);
        }
        container.appendChild(grid);
    }

    // ASCII diagram
    var diagram = resultContent.querySelector('.mg-diagram');
    if (diagram) {
        var diagramEl = document.createElement('div');
        diagramEl.style.cssText = 'padding:16px;background:#f8fafc;border:1px solid #e2e8f0;border-radius:8px;font-family:JetBrains Mono,monospace;font-size:14px;white-space:pre;text-align:center;margin-bottom:20px;';
        diagramEl.textContent = diagram.textContent;
        container.appendChild(diagramEl);
    }

    // Steps
    var steps = resultContent.querySelectorAll('.mg-step');
    if (steps.length > 0) {
        var stepsLabel = document.createElement('div');
        stepsLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:12px;border-top:1px solid #e2e8f0;padding-top:16px;';
        stepsLabel.textContent = 'Step-by-Step Analysis';
        container.appendChild(stepsLabel);

        for (var s = 0; s < steps.length; s++) {
            var stepRow = document.createElement('div');
            stepRow.style.cssText = 'display:flex;gap:12px;margin-bottom:10px;align-items:flex-start;';

            var stepNum = document.createElement('div');
            stepNum.style.cssText = 'width:24px;height:24px;background:#059669;color:#fff;border-radius:50%;font-size:12px;font-weight:700;display:flex;align-items:center;justify-content:center;flex-shrink:0;';
            var numEl = steps[s].querySelector('.mg-step-number');
            stepNum.textContent = numEl ? numEl.textContent : (s + 1);
            stepRow.appendChild(stepNum);

            var stepBody = document.createElement('div');
            stepBody.style.cssText = 'flex:1;';
            var descEl = steps[s].querySelector('.mg-step-desc');
            if (descEl) {
                var sDesc = document.createElement('div');
                sDesc.style.cssText = 'font-size:13px;font-weight:600;color:#334155;margin-bottom:2px;';
                sDesc.textContent = descEl.textContent;
                stepBody.appendChild(sDesc);
            }
            var mathEl = steps[s].querySelector('.mg-step-math');
            if (mathEl) {
                var sMath = document.createElement('div');
                sMath.style.cssText = 'font-size:12px;color:#64748b;';
                sMath.textContent = mathEl.textContent;
                stepBody.appendChild(sMath);
            }
            stepRow.appendChild(stepBody);
            container.appendChild(stepRow);
        }
    }

    // Footer
    var footer = document.createElement('div');
    footer.style.cssText = 'margin-top:24px;padding-top:12px;border-top:1px solid #e2e8f0;font-size:11px;color:#94a3b8;display:flex;justify-content:space-between;';
    footer.innerHTML = '<span>Generated by 8gwifi.org Molecular Geometry Calculator</span><span>' + new Date().toLocaleDateString() + '</span>';
    container.appendChild(footer);

    // Generate PDF via html2canvas + jsPDF
    if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Generating PDF...', 1500, 'info');

    var loadHtml2Canvas = (typeof html2canvas !== 'undefined') ? Promise.resolve() : ToolUtils._loadScript('https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js');
    loadHtml2Canvas
        .then(function() { return ToolUtils._loadScript('https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js'); })
        .then(function() { return html2canvas(container, { scale: 2, backgroundColor: '#ffffff', useCORS: true, logging: false }); })
        .then(function(canvas) {
            document.body.removeChild(container);
            var imgData = canvas.toDataURL('image/png');
            var pdf = new jspdf.jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' });
            var pageWidth = pdf.internal.pageSize.getWidth();
            var margin = 10;
            var usableWidth = pageWidth - margin * 2;
            var imgWidth = usableWidth;
            var imgHeight = (canvas.height * usableWidth) / canvas.width;
            var usableHeight = pdf.internal.pageSize.getHeight() - margin * 2;
            if (imgHeight > usableHeight) {
                imgHeight = usableHeight;
                imgWidth = (canvas.width * usableHeight) / canvas.height;
            }
            var x = (pageWidth - imgWidth) / 2;
            pdf.addImage(imgData, 'PNG', x, margin, imgWidth, imgHeight);

            var filename = 'molecular-geometry';
            if (state.mode === 'formula' && state.formula) {
                filename += '-' + state.formula.replace(/[^a-zA-Z0-9]/g, '_');
            } else {
                filename += '-' + state.bp + 'BP-' + state.lp + 'LP';
            }
            pdf.save(filename + '.pdf');

            if (typeof ToolUtils !== 'undefined') {
                ToolUtils.showToast('PDF downloaded!', 2000, 'success');
                setTimeout(function() {
                    ToolUtils.showSupportPopup('Molecular Geometry Calculator', 'Downloaded: ' + filename + '.pdf');
                }, 500);
            }
        })
        .catch(function(err) {
            if (container.parentNode) document.body.removeChild(container);
            console.error('PDF generation failed:', err);
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('PDF generation failed: ' + (err.message || ''), 3000, 'error');
        });
}

// ==================== Download Chart (VSEPR Reference Poster) ====================

function shuffleArray(arr) {
    var a = arr.slice();
    for (var i = a.length - 1; i > 0; i--) {
        var j = Math.floor(Math.random() * (i + 1));
        var tmp = a[i]; a[i] = a[j]; a[j] = tmp;
    }
    return a;
}

// The 13 main VSEPR molecular geometry types to show on chart
var chartGeometries = [
    { key: '2-0', label: 'Linear', color: '#059669' },
    { key: '3-0', label: 'Trigonal Planar', color: '#0891b2' },
    { key: '2-1', label: 'Bent (sp\u00b2)', color: '#7c3aed' },
    { key: '4-0', label: 'Tetrahedral', color: '#2563eb' },
    { key: '3-1', label: 'Trigonal Pyramidal', color: '#d97706' },
    { key: '2-2', label: 'Bent (sp\u00b3)', color: '#dc2626' },
    { key: '5-0', label: 'Trigonal Bipyramidal', color: '#059669' },
    { key: '4-1', label: 'See-Saw', color: '#0891b2' },
    { key: '3-2', label: 'T-Shaped', color: '#7c3aed' },
    { key: '2-3', label: 'Linear (from TBP)', color: '#2563eb' },
    { key: '6-0', label: 'Octahedral', color: '#d97706' },
    { key: '5-1', label: 'Square Pyramidal', color: '#dc2626' },
    { key: '4-2', label: 'Square Planar', color: '#059669' }
];

function downloadChart() {
    if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Generating VSEPR chart...', 2000, 'info');

    var mols = R.molecules;
    var gData = R.geometryData;

    var container = document.createElement('div');
    container.style.cssText = 'position:absolute;left:-9999px;top:0;width:800px;padding:32px;background:#fff;font-family:Inter,-apple-system,BlinkMacSystemFont,sans-serif;color:#0f172a;';
    document.body.appendChild(container);

    // Title
    var title = document.createElement('div');
    title.style.cssText = 'text-align:center;margin-bottom:6px;';
    title.innerHTML = '<div style="font-size:24px;font-weight:800;color:#059669;">VSEPR Molecular Geometry Reference Chart</div>';
    container.appendChild(title);

    var sub = document.createElement('div');
    sub.style.cssText = 'text-align:center;font-size:12px;color:#94a3b8;margin-bottom:20px;';
    sub.textContent = '8gwifi.org \u2014 Randomized examples \u2014 ' + new Date().toLocaleDateString();
    container.appendChild(sub);

    // Grid of geometry cards
    var grid = document.createElement('div');
    grid.style.cssText = 'display:grid;grid-template-columns:1fr 1fr;gap:12px;';

    for (var g = 0; g < chartGeometries.length; g++) {
        var cg = chartGeometries[g];
        var geo = gData[cg.key];
        if (!geo) continue;

        // Find molecules matching this bp-lp
        var parts = cg.key.split('-');
        var bp = parseInt(parts[0]), lp = parseInt(parts[1]);
        var matching = [];
        for (var m = 0; m < mols.length; m++) {
            if (mols[m].bp === bp && mols[m].lp === lp) matching.push(mols[m]);
        }
        var picked = shuffleArray(matching).slice(0, 2);

        var card = document.createElement('div');
        card.style.cssText = 'border:1px solid #e2e8f0;border-radius:10px;padding:14px;background:#fafafa;';

        // Card header
        var hdr = '<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px;">' +
            '<div style="font-size:14px;font-weight:700;color:' + cg.color + ';">' + cg.label + '</div>' +
            '<div style="font-size:11px;color:#94a3b8;background:#f1f5f9;padding:2px 8px;border-radius:10px;">' + geo.notation + '</div>' +
        '</div>';

        // Diagram
        var diag = '<div style="font-family:JetBrains Mono,Courier New,monospace;font-size:12px;white-space:pre;background:#fff;border:1px solid #e2e8f0;border-radius:6px;padding:8px;text-align:center;margin-bottom:8px;line-height:1.3;color:#334155;">' +
            geo.diagram + '</div>';

        // Info row
        var info = '<div style="display:flex;gap:8px;margin-bottom:8px;font-size:11px;">' +
            '<div style="background:#ecfdf5;padding:3px 8px;border-radius:6px;"><strong>Angle:</strong> ' + geo.angle + '</div>' +
            '<div style="background:#eff6ff;padding:3px 8px;border-radius:6px;"><strong>Hybrid:</strong> ' + geo.hybridization + '</div>' +
            '<div style="background:#fef3c7;padding:3px 8px;border-radius:6px;"><strong>BP:</strong> ' + bp + ' <strong>LP:</strong> ' + lp + '</div>' +
        '</div>';

        // Examples
        var exHtml = '';
        if (picked.length > 0) {
            exHtml = '<div style="display:flex;gap:6px;flex-wrap:wrap;">';
            for (var p = 0; p < picked.length; p++) {
                exHtml += '<div style="background:' + cg.color + ';color:#fff;padding:3px 10px;border-radius:12px;font-size:12px;font-weight:600;">' +
                    picked[p].display + ' <span style="font-weight:400;opacity:0.85;">' + picked[p].name + '</span></div>';
            }
            exHtml += '</div>';
        } else {
            exHtml = '<div style="font-size:11px;color:#94a3b8;font-style:italic;">Rare / theoretical</div>';
        }

        card.innerHTML = hdr + diag + info + exHtml;
        grid.appendChild(card);
    }
    container.appendChild(grid);

    // Footer
    var footer = document.createElement('div');
    footer.style.cssText = 'margin-top:16px;padding-top:10px;border-top:1px solid #e2e8f0;font-size:11px;color:#94a3b8;display:flex;justify-content:space-between;';
    footer.innerHTML = '<span>Generated by 8gwifi.org Molecular Geometry Calculator</span><span>Click again for new random examples!</span>';
    container.appendChild(footer);

    // Render to PDF
    var loadHtml2Canvas = (typeof html2canvas !== 'undefined') ? Promise.resolve() : ToolUtils._loadScript('https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js');
    loadHtml2Canvas
        .then(function() { return ToolUtils._loadScript('https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js'); })
        .then(function() { return html2canvas(container, { scale: 2, backgroundColor: '#ffffff', useCORS: true, logging: false }); })
        .then(function(canvas) {
            document.body.removeChild(container);
            var imgData = canvas.toDataURL('image/png');
            var pdf = new jspdf.jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' });
            var pageWidth = pdf.internal.pageSize.getWidth();
            var margin = 8;
            var usableWidth = pageWidth - margin * 2;
            var imgWidth = usableWidth;
            var imgHeight = (canvas.height * usableWidth) / canvas.width;
            var usableHeight = pdf.internal.pageSize.getHeight() - margin * 2;
            if (imgHeight > usableHeight) {
                imgHeight = usableHeight;
                imgWidth = (canvas.width * usableHeight) / canvas.height;
            }
            var x = (pageWidth - imgWidth) / 2;
            pdf.addImage(imgData, 'PNG', x, margin, imgWidth, imgHeight);
            pdf.save('vsepr-reference-chart.pdf');
            if (typeof ToolUtils !== 'undefined') {
                ToolUtils.showToast('VSEPR chart downloaded!', 2000, 'success');
                setTimeout(function() {
                    ToolUtils.showSupportPopup('VSEPR Reference Chart', 'Downloaded: vsepr-reference-chart.pdf');
                }, 500);
            }
        })
        .catch(function(err) {
            if (container.parentNode) document.body.removeChild(container);
            console.error('Chart generation failed:', err);
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Chart generation failed', 3000, 'error');
        });
}

// ==================== Practice Sheet ====================

// Pick one random molecule per geometry type for balanced coverage
function pickPracticeProblems() {
    var mols = R.molecules;
    var gData = R.geometryData;

    // Group molecules by bp-lp key (only common geometry types)
    var targetKeys = ['2-0', '3-0', '2-1', '4-0', '3-1', '2-2', '5-0', '4-1', '3-2', '2-3', '6-0', '5-1', '4-2'];
    var byKey = {};
    for (var k = 0; k < targetKeys.length; k++) byKey[targetKeys[k]] = [];
    for (var i = 0; i < mols.length; i++) {
        var key = mols[i].bp + '-' + mols[i].lp;
        if (byKey[key]) byKey[key].push(mols[i]);
    }

    // Pick one random from each type
    var problems = [];
    for (var j = 0; j < targetKeys.length; j++) {
        var pool = byKey[targetKeys[j]];
        if (pool.length > 0) {
            var pick = pool[Math.floor(Math.random() * pool.length)];
            var geo = gData[targetKeys[j]];
            problems.push({
                formula: pick.display,
                name: pick.name,
                hint: pick.bp + ' bonding pair' + (pick.bp !== 1 ? 's' : '') + ', ' + pick.lp + ' lone pair' + (pick.lp !== 1 ? 's' : '') + ' \u2014 ' + geo.notation
            });
        }
    }
    return shuffleArray(problems);
}

function downloadPracticeSheet() {
    if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Generating practice sheet...', 1500, 'info');

    var problems = pickPracticeProblems();

    var container = document.createElement('div');
    container.style.cssText = 'position:absolute;left:-9999px;top:0;width:750px;padding:40px;background:#fff;font-family:Inter,-apple-system,BlinkMacSystemFont,sans-serif;color:#0f172a;';
    document.body.appendChild(container);

    // Header
    var header = document.createElement('div');
    header.style.cssText = 'text-align:center;margin-bottom:24px;';
    header.innerHTML = '<div style="font-size:22px;font-weight:700;color:#059669;margin-bottom:4px;">VSEPR Molecular Geometry Practice Worksheet</div>' +
        '<div style="font-size:12px;color:#94a3b8;">8gwifi.org \u2014 Randomized problems \u2014 ' + new Date().toLocaleDateString() + '</div>';
    container.appendChild(header);

    // Student info
    var info = document.createElement('div');
    info.style.cssText = 'display:flex;gap:24px;margin-bottom:20px;padding-bottom:16px;border-bottom:2px solid #059669;';
    info.innerHTML = '<div style="flex:1;font-size:13px;"><strong>Name:</strong> ___________________________</div>' +
        '<div style="font-size:13px;"><strong>Date:</strong> _______________</div>' +
        '<div style="font-size:13px;"><strong>Score:</strong> ____/' + problems.length + '</div>';
    container.appendChild(info);

    // Instructions
    var instr = document.createElement('div');
    instr.style.cssText = 'padding:12px 16px;background:#ecfdf5;border:1px solid #a7f3d0;border-radius:8px;font-size:12px;margin-bottom:20px;line-height:1.5;';
    instr.innerHTML = '<strong>Instructions:</strong> For each molecule below, determine: (1) the number of bonding pairs and lone pairs on the central atom, (2) the electron geometry, (3) the molecular geometry, (4) the bond angle, and (5) the hybridization.';
    container.appendChild(instr);

    // Problems grid
    var grid = document.createElement('div');
    grid.style.cssText = 'display:grid;grid-template-columns:1fr 1fr;gap:14px;';

    for (var i = 0; i < problems.length; i++) {
        var p = problems[i];
        var card = document.createElement('div');
        card.style.cssText = 'border:1px solid #e2e8f0;border-radius:8px;padding:12px;';

        card.innerHTML =
            '<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px;">' +
                '<div style="font-weight:700;font-size:14px;color:#059669;">' + (i + 1) + '. ' + p.formula + '</div>' +
                '<div style="font-size:11px;color:#94a3b8;">' + p.name + '</div>' +
            '</div>' +
            '<div style="font-size:11px;color:#64748b;font-style:italic;margin-bottom:8px;">Hint: ' + p.hint + '</div>' +
            '<div style="display:grid;grid-template-columns:1fr 1fr;gap:6px;font-size:12px;">' +
                '<div>Bonding pairs: ______</div>' +
                '<div>Lone pairs: ______</div>' +
                '<div>Electron geom: ____________</div>' +
                '<div>Molecular geom: ____________</div>' +
                '<div style="grid-column:span 2;">Bond angle: ______\u00b0 &nbsp;&nbsp; Hybridization: ______</div>' +
            '</div>';

        grid.appendChild(card);
    }
    container.appendChild(grid);

    // Footer
    var footer = document.createElement('div');
    footer.style.cssText = 'margin-top:20px;padding-top:12px;border-top:1px solid #e2e8f0;font-size:11px;color:#94a3b8;display:flex;justify-content:space-between;';
    footer.innerHTML = '<span>Generated by 8gwifi.org Molecular Geometry Calculator</span><span>Click again for new random problems!</span>';
    container.appendChild(footer);

    // Generate PDF
    var loadHtml2Canvas = (typeof html2canvas !== 'undefined') ? Promise.resolve() : ToolUtils._loadScript('https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js');
    loadHtml2Canvas
        .then(function() { return ToolUtils._loadScript('https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js'); })
        .then(function() { return html2canvas(container, { scale: 2, backgroundColor: '#ffffff', useCORS: true, logging: false }); })
        .then(function(canvas) {
            document.body.removeChild(container);
            var imgData = canvas.toDataURL('image/png');
            var pdf = new jspdf.jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' });
            var pageWidth = pdf.internal.pageSize.getWidth();
            var margin = 10;
            var usableWidth = pageWidth - margin * 2;
            var imgWidth = usableWidth;
            var imgHeight = (canvas.height * usableWidth) / canvas.width;
            var usableHeight = pdf.internal.pageSize.getHeight() - margin * 2;
            if (imgHeight > usableHeight) {
                imgHeight = usableHeight;
                imgWidth = (canvas.width * usableHeight) / canvas.height;
            }
            var x = (pageWidth - imgWidth) / 2;
            pdf.addImage(imgData, 'PNG', x, margin, imgWidth, imgHeight);
            pdf.save('vsepr-practice-worksheet.pdf');
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Practice sheet downloaded!', 2000, 'success');
        })
        .catch(function(err) {
            if (container.parentNode) document.body.removeChild(container);
            console.error('Practice sheet generation failed:', err);
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Practice sheet failed: ' + (err.message || ''), 3000, 'error');
        });
}

// ==================== Initialization ====================

function init() {
    // Mode toggle
    var modeBtns = document.querySelectorAll('.mg-mode-btn');
    for (var i = 0; i < modeBtns.length; i++) {
        modeBtns[i].addEventListener('click', function() {
            switchMode(this.getAttribute('data-mode'));
        });
    }

    // Solve & Clear
    var solveBtn = $('mg-solve-btn');
    if (solveBtn) solveBtn.addEventListener('click', calculate);

    var clearBtn = $('mg-clear-btn');
    if (clearBtn) clearBtn.addEventListener('click', clearAll);

    // Output tabs
    var tabs = document.querySelectorAll('.mg-output-tab');
    for (var t = 0; t < tabs.length; t++) {
        tabs[t].addEventListener('click', function() {
            var panel = this.getAttribute('data-panel');
            for (var j = 0; j < tabs.length; j++) tabs[j].classList.remove('active');
            this.classList.add('active');
            var panels = document.querySelectorAll('.mg-panel');
            for (var k = 0; k < panels.length; k++) {
                panels[k].classList.toggle('active', panels[k].id === 'mg-panel-' + panel);
            }
            if (panel === 'database') filterTable();
        });
    }

    // Enter key to calculate
    var inputs = document.querySelectorAll('.mg-input, .mg-formula-input');
    for (var q = 0; q < inputs.length; q++) {
        inputs[q].addEventListener('keydown', function(e) {
            if (e.key === 'Enter') calculate();
        });
    }

    // Database search
    var searchEl = $('mg-search');
    if (searchEl) searchEl.addEventListener('input', filterTable);

    // Table view buttons (delegated)
    var tableBody = $('mg-table-body');
    if (tableBody) {
        tableBody.addEventListener('click', function(e) {
            var btn = e.target.closest('.mg-table-btn');
            if (btn) loadMolecule(btn.getAttribute('data-formula'));
        });
    }

    // Share button
    var shareBtn = $('mg-share-btn');
    if (shareBtn) {
        shareBtn.addEventListener('click', copyShareUrl);
    }

    // Download PDF button
    var pdfBtn = $('mg-download-pdf-btn');
    if (pdfBtn) {
        pdfBtn.addEventListener('click', downloadPdf);
    }

    // Download Chart button
    var chartBtn = $('mg-download-chart-btn');
    if (chartBtn) {
        chartBtn.addEventListener('click', downloadChart);
    }

    // Practice Sheet button
    var practiceBtn = $('mg-practice-btn');
    if (practiceBtn) {
        practiceBtn.addEventListener('click', downloadPracticeSheet);
    }

    // Example chips
    var chips = document.querySelectorAll('.mg-example-chip');
    for (var c = 0; c < chips.length; c++) {
        chips[c].addEventListener('click', function() {
            loadExample(this.getAttribute('data-example'));
        });
    }

    // FAQ
    if (typeof window.toggleFaq === 'undefined') {
        window.toggleFaq = function(btn) {
            var item = btn.parentElement;
            var answer = item.querySelector('.faq-answer');
            var chevron = btn.querySelector('.faq-chevron');
            var isOpen = answer.style.maxHeight && answer.style.maxHeight !== '0px';
            answer.style.maxHeight = isOpen ? '0px' : answer.scrollHeight + 'px';
            answer.style.padding = isOpen ? '0 1rem' : '0.75rem 1rem';
            if (chevron) chevron.style.transform = isOpen ? '' : 'rotate(180deg)';
        };
    }

    // Initialize table
    filterTable();

    // Load from URL or default
    if (!loadFromURL()) {
        // default state ready
    }
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
} else {
    init();
}

})();
