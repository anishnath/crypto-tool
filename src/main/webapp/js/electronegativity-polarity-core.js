/**
 * Electronegativity & Polarity Checker - Core Orchestration
 * State management, events, PDF, share URL
 */
(function() {
'use strict';

var R = window.EPRender;

// ==================== State ====================

var state = {
    formula: '',
    lastFormula: ''
};

// ==================== Helpers ====================

function $(id) { return document.getElementById(id); }

// ==================== Calculate ====================

function calculate() {
    var container = $('ep-result-content');
    if (!container) return;

    var empty = $('ep-empty-state');
    if (empty) empty.style.display = 'none';

    var actions = $('ep-result-actions');
    if (actions) actions.style.display = 'flex';

    var formulaEl = $('ep-formula');
    state.formula = formulaEl ? formulaEl.value.trim() : '';
    if (!state.formula) {
        R.showError(container, 'Please enter a chemical formula or molecule name.');
        return;
    }
    state.lastFormula = state.formula;
    R.renderByFormula(container, state.formula);
    updateGeometryLink(state.formula);
}

// ==================== Geometry Link ====================

function updateGeometryLink(formula) {
    var btn = $('ep-geometry-btn');
    if (!btn) return;
    if (formula) {
        btn.href = 'molecular-geometry-calculator.jsp?d=' + btoa(JSON.stringify({ mode: 'formula', f: formula }));
        btn.style.display = '';
    } else {
        btn.style.display = 'none';
    }
}

// ==================== Database ====================

function filterTable() {
    var searchEl = $('ep-search');
    var tbody = $('ep-table-body');
    R.renderMoleculeTable(tbody, searchEl ? searchEl.value : '');
}

function loadMolecule(formula) {
    var formulaEl = $('ep-formula');
    if (formulaEl) formulaEl.value = formula;
    state.formula = formula;
    state.lastFormula = formula;

    var container = $('ep-result-content');
    if (container) {
        var empty = $('ep-empty-state');
        if (empty) empty.style.display = 'none';
        var actions = $('ep-result-actions');
        if (actions) actions.style.display = 'flex';
        R.renderByFormula(container, formula);
        updateGeometryLink(formula);
    }
    // Switch to result tab
    var tabs = document.querySelectorAll('.ep-output-tab');
    var panels = document.querySelectorAll('.ep-panel');
    for (var t = 0; t < tabs.length; t++) {
        tabs[t].classList.toggle('active', tabs[t].getAttribute('data-panel') === 'result');
    }
    for (var p = 0; p < panels.length; p++) {
        panels[p].classList.toggle('active', panels[p].id === 'ep-panel-result');
    }
}

// ==================== Examples ====================

function loadExample(formula) {
    var formulaEl = $('ep-formula');
    if (formulaEl) formulaEl.value = formula;
    state.formula = formula;
    calculate();
}

// ==================== Clear ====================

function clearAll() {
    var formulaEl = $('ep-formula');
    if (formulaEl) formulaEl.value = '';

    var content = $('ep-result-content');
    if (content) {
        content.innerHTML = '<div class="tool-empty-state" id="ep-empty-state">' +
            '<div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#9889;</div>' +
            '<h3>Enter a molecule</h3>' +
            '<p>Check electronegativity differences and determine if a molecule is polar or nonpolar.</p></div>';
    }

    var actions = $('ep-result-actions');
    if (actions) actions.style.display = 'none';
    updateGeometryLink('');
}

// ==================== URL State ====================

function loadFromURL() {
    var params = new URLSearchParams(window.location.search);
    // Support ?f=H2O shorthand
    var f = params.get('f');
    if (f) {
        var formulaEl = $('ep-formula');
        if (formulaEl) formulaEl.value = f;
        state.formula = f;
        calculate();
        return true;
    }
    // Also support ?d=base64json
    var d = params.get('d');
    if (d) {
        try {
            var data = JSON.parse(atob(d));
            if (data.f) {
                var el = $('ep-formula');
                if (el) el.value = data.f;
                state.formula = data.f;
                calculate();
                return true;
            }
        } catch (e) { /* ignore */ }
    }
    return false;
}

// ==================== Share ====================

function buildShareUrl() {
    return window.location.origin + window.location.pathname + '?f=' + encodeURIComponent(state.formula);
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
    var resultContent = $('ep-result-content');
    if (!resultContent || resultContent.querySelector('.tool-empty-state')) {
        if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('No result to download. Check polarity first.', 2000, 'warning');
        return;
    }

    var container = document.createElement('div');
    container.style.cssText = 'position:absolute;left:-9999px;top:0;width:700px;padding:40px;background:#fff;font-family:Inter,-apple-system,BlinkMacSystemFont,sans-serif;color:#0f172a;';
    document.body.appendChild(container);

    // Title
    var title = document.createElement('div');
    title.style.cssText = 'font-size:22px;font-weight:700;margin-bottom:8px;color:#4f46e5;';
    title.textContent = 'Electronegativity & Polarity Analysis \u2014 8gwifi.org';
    container.appendChild(title);

    var divider = document.createElement('div');
    divider.style.cssText = 'height:2px;background:linear-gradient(90deg,#4f46e5,#818cf8,transparent);margin-bottom:24px;';
    container.appendChild(divider);

    // Subtitle
    var subtitle = document.createElement('div');
    subtitle.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:12px;';
    subtitle.textContent = 'Formula: ' + (state.lastFormula || state.formula);
    container.appendChild(subtitle);

    // Badge
    var badge = resultContent.querySelector('.ep-verdict-badge');
    if (badge) {
        var badgeEl = document.createElement('div');
        badgeEl.style.cssText = 'display:inline-block;background:#4f46e5;color:#fff;padding:6px 16px;border-radius:12px;font-size:14px;font-weight:600;margin-bottom:20px;';
        badgeEl.textContent = badge.textContent;
        container.appendChild(badgeEl);
    }

    // Result grid
    var items = resultContent.querySelectorAll('.ep-result-item');
    if (items.length > 0) {
        var grid = document.createElement('div');
        grid.style.cssText = 'display:grid;grid-template-columns:1fr 1fr 1fr;gap:12px;margin-bottom:20px;';
        for (var g = 0; g < items.length; g++) {
            var cell = document.createElement('div');
            cell.style.cssText = 'padding:10px;background:#eef2ff;border-radius:8px;text-align:center;';
            var label = items[g].querySelector('.ep-result-label');
            var value = items[g].querySelector('.ep-result-value');
            cell.innerHTML = '<div style="font-size:10px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:4px;">' +
                (label ? label.textContent : '') + '</div>' +
                '<div style="font-size:16px;font-weight:700;color:#0f172a;">' + (value ? value.textContent : '') + '</div>';
            grid.appendChild(cell);
        }
        container.appendChild(grid);
    }

    // Bond table
    var bondTableWrap = resultContent.querySelector('.ep-bond-table-wrap');
    if (bondTableWrap) {
        var tableLabel = document.createElement('div');
        tableLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:8px;';
        tableLabel.textContent = 'Bond Polarity Analysis';
        container.appendChild(tableLabel);

        var tableClone = bondTableWrap.cloneNode(true);
        tableClone.style.cssText = 'margin-bottom:20px;border:1px solid #e2e8f0;border-radius:8px;overflow:hidden;';
        container.appendChild(tableClone);
    }

    // 3D snapshot
    var viewerCanvas = resultContent.querySelector('.ep-3d-viewer canvas');
    if (viewerCanvas) {
        try {
            var modelLabel = document.createElement('div');
            modelLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:8px;';
            modelLabel.textContent = '3D Molecular Model';
            container.appendChild(modelLabel);

            var modelImg = document.createElement('img');
            modelImg.src = viewerCanvas.toDataURL('image/png');
            modelImg.style.cssText = 'width:100%;max-height:360px;object-fit:contain;border:1px solid #e2e8f0;border-radius:8px;margin-bottom:20px;display:block;';
            container.appendChild(modelImg);
        } catch (e) { /* canvas capture failed */ }
    }

    // Steps
    var steps = resultContent.querySelectorAll('.ep-step');
    if (steps.length > 0) {
        var stepsLabel = document.createElement('div');
        stepsLabel.style.cssText = 'font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:#64748b;margin-bottom:12px;border-top:1px solid #e2e8f0;padding-top:16px;';
        stepsLabel.textContent = 'Step-by-Step Analysis';
        container.appendChild(stepsLabel);

        for (var s = 0; s < steps.length; s++) {
            var stepRow = document.createElement('div');
            stepRow.style.cssText = 'display:flex;gap:12px;margin-bottom:10px;align-items:flex-start;';

            var stepNum = document.createElement('div');
            stepNum.style.cssText = 'width:24px;height:24px;background:#4f46e5;color:#fff;border-radius:50%;font-size:12px;font-weight:700;display:flex;align-items:center;justify-content:center;flex-shrink:0;';
            var numEl = steps[s].querySelector('.ep-step-number');
            stepNum.textContent = numEl ? numEl.textContent : (s + 1);
            stepRow.appendChild(stepNum);

            var stepBody = document.createElement('div');
            stepBody.style.cssText = 'flex:1;';
            var descEl = steps[s].querySelector('.ep-step-desc');
            if (descEl) {
                var sDesc = document.createElement('div');
                sDesc.style.cssText = 'font-size:13px;font-weight:600;color:#334155;margin-bottom:2px;';
                sDesc.textContent = descEl.textContent;
                stepBody.appendChild(sDesc);
            }
            var mathEl = steps[s].querySelector('.ep-step-math');
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
    footer.innerHTML = '<span>Generated by 8gwifi.org Electronegativity &amp; Polarity Checker</span><span>' + new Date().toLocaleDateString() + '</span>';
    container.appendChild(footer);

    // Generate PDF
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

            var filename = 'polarity-' + (state.lastFormula || 'result').replace(/[^a-zA-Z0-9]/g, '_');
            pdf.save(filename + '.pdf');

            if (typeof ToolUtils !== 'undefined') {
                ToolUtils.showToast('PDF downloaded!', 2000, 'success');
                setTimeout(function() {
                    ToolUtils.showSupportPopup('Polarity Checker', 'Downloaded: ' + filename + '.pdf');
                }, 500);
            }
        })
        .catch(function(err) {
            if (container.parentNode) document.body.removeChild(container);
            console.error('PDF generation failed:', err);
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('PDF generation failed: ' + (err.message || ''), 3000, 'error');
        });
}

// ==================== EN Table Resource ====================

function showENTable() {
    var container = $('ep-result-content');
    if (!container) return;

    var empty = $('ep-empty-state');
    if (empty) empty.style.display = 'none';

    container.innerHTML = '';

    var header = document.createElement('h4');
    header.style.cssText = 'font-size:0.9375rem;font-weight:600;margin:0 0 0.75rem;color:var(--text-primary);';
    header.textContent = 'Pauling Electronegativity Values';
    container.appendChild(header);

    var wrap = document.createElement('div');
    wrap.className = 'ep-bond-table-wrap';
    var table = document.createElement('table');
    table.className = 'ep-bond-table';
    table.innerHTML = '<thead><tr><th>Element</th><th>EN</th><th>Color</th></tr></thead>';
    var tbody = document.createElement('tbody');

    var sorted = Object.keys(R.EN).sort(function(a, b) { return R.EN[b] - R.EN[a]; });
    for (var i = 0; i < sorted.length; i++) {
        var sym = sorted[i];
        var en = R.EN[sym];
        var color = R.enToColor(en);
        var tr = document.createElement('tr');
        tr.innerHTML = '<td style="font-family:var(--font-mono);font-weight:600;">' + sym + '</td>' +
            '<td>' + en.toFixed(2) + '</td>' +
            '<td><div style="width:3rem;height:1.25rem;border-radius:0.25rem;background:' + color + ';border:1px solid var(--border);"></div></td>';
        tbody.appendChild(tr);
    }
    table.appendChild(tbody);
    wrap.appendChild(table);
    container.appendChild(wrap);
}

// ==================== Initialization ====================

function init() {
    // Solve & Clear
    var solveBtn = $('ep-solve-btn');
    if (solveBtn) solveBtn.addEventListener('click', calculate);

    var clearBtn = $('ep-clear-btn');
    if (clearBtn) clearBtn.addEventListener('click', clearAll);

    // Output tabs
    var tabs = document.querySelectorAll('.ep-output-tab');
    for (var t = 0; t < tabs.length; t++) {
        tabs[t].addEventListener('click', function() {
            var panel = this.getAttribute('data-panel');
            for (var j = 0; j < tabs.length; j++) tabs[j].classList.remove('active');
            this.classList.add('active');
            var panels = document.querySelectorAll('.ep-panel');
            for (var k = 0; k < panels.length; k++) {
                panels[k].classList.toggle('active', panels[k].id === 'ep-panel-' + panel);
            }
            if (panel === 'database') filterTable();
        });
    }

    // Enter key
    var formulaInput = $('ep-formula');
    if (formulaInput) {
        formulaInput.addEventListener('keydown', function(e) {
            if (e.key === 'Enter') calculate();
        });
    }

    // Database search
    var searchEl = $('ep-search');
    if (searchEl) searchEl.addEventListener('input', filterTable);

    // Table view buttons (delegated)
    var tableBody = $('ep-table-body');
    if (tableBody) {
        tableBody.addEventListener('click', function(e) {
            var btn = e.target.closest('.ep-table-btn');
            if (btn) loadMolecule(btn.getAttribute('data-formula'));
        });
    }

    // Share button
    var shareBtn = $('ep-share-btn');
    if (shareBtn) shareBtn.addEventListener('click', copyShareUrl);

    // PDF button
    var pdfBtn = $('ep-download-pdf-btn');
    if (pdfBtn) pdfBtn.addEventListener('click', downloadPdf);

    // Resource buttons
    var enTableBtn = $('ep-en-table-btn');
    if (enTableBtn) enTableBtn.addEventListener('click', showENTable);

    // Example chips
    var chips = document.querySelectorAll('.ep-example-chip');
    for (var c = 0; c < chips.length; c++) {
        chips[c].addEventListener('click', function() {
            loadExample(this.getAttribute('data-formula'));
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

    // Load from URL
    loadFromURL();
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
} else {
    init();
}

})();
