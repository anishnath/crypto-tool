/**
 * Optical Designer — UI Controller
 * ES5 IIFE, depends on ODModel + ODTrace + ODRender
 *
 * Exports:  window.ODUI
 *   .init(canvasId, tableId, opts)  — bootstrap the tool
 *   .getDesign()                     — current Design instance
 */
;(function (win) {
  'use strict';

  var M = win.ODModel;
  var T = win.ODTrace;
  var R = win.ODRender;

  var design = null;
  var canvas = null;
  var selectedSurface = -1;
  var currentView = 'cross-section';  // 'cross-section' | 'spot' | 'aberration' | 'chromatic'
  var rafPending = false;

  /* ---- DOM refs (set during init) ---- */
  var els = {};

  /* ================================================================
   *  INIT
   * ================================================================ */

  function init(opts) {
    opts = opts || {};

    canvas = document.getElementById(opts.canvasId || 'od-canvas');

    els.table       = document.getElementById(opts.tableId || 'od-surface-table');
    els.addBtn      = document.getElementById('od-add-surface');
    els.removeBtn   = document.getElementById('od-remove-surface');
    els.presetSel   = document.getElementById('od-preset-select');
    els.viewSel     = document.getElementById('od-view-select');

    // Environment inputs
    els.beamRadius     = document.getElementById('od-beam-radius');
    els.raysPerBeam    = document.getElementById('od-rays-per-beam');
    els.fovAngle       = document.getElementById('od-fov-angle');
    els.symBeams       = document.getElementById('od-sym-beams');
    els.wlCenter       = document.getElementById('od-wl-center');
    els.wlShort        = document.getElementById('od-wl-short');
    els.wlLong         = document.getElementById('od-wl-long');
    els.imageRadius    = document.getElementById('od-image-radius');
    els.autofocus      = document.getElementById('od-autofocus');

    // Metric display
    els.metricFL       = document.getElementById('od-metric-fl');
    els.metricFNum     = document.getElementById('od-metric-fnum');
    els.metricNA       = document.getElementById('od-metric-na');
    els.metricLen      = document.getElementById('od-metric-len');
    els.metricPower    = document.getElementById('od-metric-power');
    els.chromContainer = document.getElementById('od-chrom-container');

    // Export / import
    els.exportBtn      = document.getElementById('od-export-json');
    els.importBtn      = document.getElementById('od-import-json');
    els.importFile     = document.getElementById('od-import-file');
    els.exportPng      = document.getElementById('od-export-png');

    // Load default preset
    loadPreset('Achromatic Doublet');

    // Event wiring
    wireEvents();
  }

  /* ================================================================
   *  EVENTS
   * ================================================================ */

  function wireEvents() {
    // Add / Remove surface
    if (els.addBtn) els.addBtn.addEventListener('click', function () {
      var idx = selectedSurface >= 0 ? selectedSurface + 1 : design.surfaces.length;
      design.addSurface(new M.Surface({ thickness: 5 }), idx);
      selectedSurface = idx;
      refreshAll();
    });

    if (els.removeBtn) els.removeBtn.addEventListener('click', function () {
      if (selectedSurface >= 0 && selectedSurface < design.surfaces.length) {
        design.removeSurface(selectedSurface);
        if (selectedSurface >= design.surfaces.length) selectedSurface = design.surfaces.length - 1;
        refreshAll();
      }
    });

    // Preset
    if (els.presetSel) els.presetSel.addEventListener('change', function () {
      var name = this.value;
      if (name && M.PRESETS[name]) {
        loadPreset(name);
      }
    });

    // View mode
    if (els.viewSel) els.viewSel.addEventListener('change', function () {
      currentView = this.value;
      scheduleRepaint();
    });

    // Environment inputs — auto-update on change
    var envIds = ['od-beam-radius', 'od-rays-per-beam', 'od-fov-angle',
                  'od-wl-center', 'od-wl-short', 'od-wl-long',
                  'od-image-radius'];
    for (var i = 0; i < envIds.length; i++) {
      var el = document.getElementById(envIds[i]);
      if (el) el.addEventListener('input', onEnvChange);
    }

    if (els.symBeams) els.symBeams.addEventListener('change', onEnvChange);
    if (els.autofocus) els.autofocus.addEventListener('change', onEnvChange);

    // Export JSON
    if (els.exportBtn) els.exportBtn.addEventListener('click', function () {
      var json = design.toJSON();
      var blob = new Blob([json], { type: 'application/json' });
      var a = document.createElement('a');
      a.href = URL.createObjectURL(blob);
      a.download = 'optical-design.json';
      a.click();
      URL.revokeObjectURL(a.href);
    });

    // Import JSON
    if (els.importBtn && els.importFile) {
      els.importBtn.addEventListener('click', function () {
        els.importFile.click();
      });
      els.importFile.addEventListener('change', function (e) {
        var file = e.target.files[0];
        if (!file) return;
        var reader = new FileReader();
        reader.onload = function (ev) {
          try {
            design = M.Design.fromJSON(ev.target.result);
            selectedSurface = -1;
            refreshAll();
          } catch (err) {
            alert('Invalid design file: ' + err.message);
          }
        };
        reader.readAsText(file);
        e.target.value = '';
      });
    }

    // PNG/SVG/Share handled by ToolUtils in JSP inline script

    // Canvas resize
    var resizeTimer = null;
    window.addEventListener('resize', function () {
      clearTimeout(resizeTimer);
      resizeTimer = setTimeout(function () { scheduleRepaint(); }, 100);
    });
  }

  function onEnvChange() {
    readEnvFromDOM();
    refreshAll();
  }

  /* ================================================================
   *  SURFACE TABLE
   * ================================================================ */

  function buildTable() {
    if (!els.table) return;
    var tbody = els.table.querySelector('tbody');
    if (!tbody) {
      // Create full table structure
      els.table.innerHTML = '';
      var thead = document.createElement('thead');
      thead.innerHTML =
        '<tr>' +
        '<th class="od-th">#</th>' +
        '<th class="od-th">R (mm)</th>' +
        '<th class="od-th">Aper (mm)</th>' +
        '<th class="od-th">Thick (mm)</th>' +
        '<th class="od-th">Material</th>' +
        '<th class="od-th">Conic K</th>' +
        '</tr>';
      els.table.appendChild(thead);
      tbody = document.createElement('tbody');
      els.table.appendChild(tbody);
    }

    tbody.innerHTML = '';

    for (var i = 0; i < design.surfaces.length; i++) {
      var s = design.surfaces[i];
      var tr = document.createElement('tr');
      tr.className = 'od-tr' + (i === selectedSurface ? ' od-tr-selected' : '');
      tr.setAttribute('data-idx', i);

      var rVal = (Math.abs(s.radius) > 1e12) ? 'Inf' : s.radius.toFixed(2);

      tr.innerHTML =
        '<td class="od-td od-td-idx">' + (i + 1) + '</td>' +
        '<td class="od-td"><input class="od-cell" data-field="radius" value="' + rVal + '"></td>' +
        '<td class="od-td"><input class="od-cell" data-field="aperture" value="' + s.aperture.toFixed(2) + '"></td>' +
        '<td class="od-td"><input class="od-cell" data-field="thickness" value="' + s.thickness.toFixed(2) + '"></td>' +
        '<td class="od-td"><select class="od-cell od-mat-select" data-field="material">' + materialOptions(s.material.name) + '</select></td>' +
        '<td class="od-td"><input class="od-cell" data-field="conic" value="' + s.conic + '"></td>';

      tbody.appendChild(tr);
    }

    // Wire cell events
    var cells = tbody.querySelectorAll('.od-cell');
    for (var ci = 0; ci < cells.length; ci++) {
      cells[ci].addEventListener('change', onCellChange);
      cells[ci].addEventListener('input', onCellInput);
    }

    // Row click to select
    var rows = tbody.querySelectorAll('.od-tr');
    for (var ri = 0; ri < rows.length; ri++) {
      rows[ri].addEventListener('click', onRowClick);
    }
  }

  function materialOptions(selectedName) {
    var html = '';
    var names = Object.keys(M.MATERIALS);
    for (var i = 0; i < names.length; i++) {
      var name = names[i];
      html += '<option value="' + name + '"' + (name === selectedName ? ' selected' : '') + '>' + name + '</option>';
    }
    return html;
  }

  function onRowClick(e) {
    // Don't steal focus from inputs or selects — let them work normally
    if (e.target.tagName === 'INPUT' || e.target.tagName === 'SELECT') return;
    var tr = e.target.closest('.od-tr');
    if (!tr) return;
    var idx = parseInt(tr.getAttribute('data-idx'), 10);
    if (isNaN(idx)) return;
    selectedSurface = idx;
    // Highlight row without rebuilding table (which would destroy open selects)
    var rows = els.table.querySelectorAll('.od-tr');
    for (var r = 0; r < rows.length; r++) {
      rows[r].className = 'od-tr' + (r === idx ? ' od-tr-selected' : '');
    }
    scheduleRepaint();
  }

  /** Live editing: update on every keystroke for numeric fields */
  var inputDebounce = null;
  function onCellInput(e) {
    clearTimeout(inputDebounce);
    inputDebounce = setTimeout(function () {
      applyCellValue(e.target);
    }, 200);
  }

  function onCellChange(e) {
    clearTimeout(inputDebounce);
    applyCellValue(e.target);
  }

  function applyCellValue(el) {
    var tr = el.closest('.od-tr');
    if (!tr) return;
    var idx = parseInt(tr.getAttribute('data-idx'), 10);
    if (isNaN(idx) || idx >= design.surfaces.length) return;

    // Auto-select the row being edited (visual only, no rebuild)
    if (selectedSurface !== idx) {
      selectedSurface = idx;
      var rows = els.table.querySelectorAll('.od-tr');
      for (var r = 0; r < rows.length; r++) {
        rows[r].className = 'od-tr' + (r === idx ? ' od-tr-selected' : '');
      }
    }

    var field = el.getAttribute('data-field');
    var s = design.surfaces[idx];

    if (field === 'material') {
      s.material = M.MATERIALS[el.value] || M.AIR;
    } else if (field === 'radius') {
      var v = el.value.trim();
      if (v === 'Inf' || v === 'inf' || v === '') {
        s.radius = Infinity;
      } else if (v === '-Inf' || v === '-inf') {
        s.radius = -Infinity;
      } else {
        var num = parseFloat(v);
        if (!isNaN(num)) s.radius = num;
      }
    } else {
      var val = parseFloat(el.value);
      if (!isNaN(val)) s[field] = val;
    }

    // Don't rebuild table (would lose focus), just repaint
    design.applyAutofocus();
    updateMetrics();
    scheduleRepaint();
  }

  /* ================================================================
   *  ENVIRONMENT ← DOM
   * ================================================================ */

  function readEnvFromDOM() {
    if (els.beamRadius)  design.beamRadius  = parseFloat(els.beamRadius.value)  || 10;
    if (els.raysPerBeam) design.raysPerBeam = parseInt(els.raysPerBeam.value, 10) || 5;
    if (els.fovAngle)    design.fovAngle    = parseFloat(els.fovAngle.value)    || 0;
    if (els.symBeams)    design.symBeams    = els.symBeams.checked;
    if (els.wlCenter)    design.wavelengthCenter = parseFloat(els.wlCenter.value) || 0.55;
    if (els.wlShort)     design.wavelengthShort  = parseFloat(els.wlShort.value)  || 0.44;
    if (els.wlLong)      design.wavelengthLong   = parseFloat(els.wlLong.value)   || 0.62;
    if (els.imageRadius) design.imageRadius = parseFloat(els.imageRadius.value) || 21.6;
    if (els.autofocus)   design.autofocus   = els.autofocus.value;
  }

  function writeEnvToDOM() {
    if (els.beamRadius)  els.beamRadius.value  = design.beamRadius;
    if (els.raysPerBeam) els.raysPerBeam.value = design.raysPerBeam;
    if (els.fovAngle)    els.fovAngle.value    = design.fovAngle;
    if (els.symBeams)    els.symBeams.checked  = design.symBeams;
    if (els.wlCenter)    els.wlCenter.value    = design.wavelengthCenter;
    if (els.wlShort)     els.wlShort.value     = design.wavelengthShort;
    if (els.wlLong)      els.wlLong.value      = design.wavelengthLong;
    if (els.imageRadius) els.imageRadius.value = design.imageRadius;
    if (els.autofocus)   els.autofocus.value   = design.autofocus;
  }

  /* ================================================================
   *  METRICS DISPLAY
   * ================================================================ */

  function updateMetrics() {
    var m = T.computeMetrics(design);
    if (els.metricFL)    els.metricFL.textContent    = isFinite(m.focalLength) ? m.focalLength.toFixed(2) + ' mm' : '∞';
    if (els.metricFNum)  els.metricFNum.textContent  = isFinite(m.fNumber) ? 'f/' + m.fNumber.toFixed(2) : '—';
    if (els.metricNA)    els.metricNA.textContent    = isFinite(m.NA) ? m.NA.toFixed(4) : '—';
    if (els.metricLen)   els.metricLen.textContent   = m.totalLength.toFixed(2) + ' mm';
    if (els.metricPower) els.metricPower.textContent = isFinite(m.power) ? m.power.toFixed(2) + ' D' : '—';
  }

  /* ================================================================
   *  PRESET LOADER
   * ================================================================ */

  function loadPreset(name) {
    if (!M.PRESETS[name]) return;
    design = M.PRESETS[name]();
    design.applyAutofocus();
    selectedSurface = -1;
    refreshAll();
  }

  /* ================================================================
   *  REPAINT
   * ================================================================ */

  function scheduleRepaint() {
    if (rafPending) return;
    rafPending = true;
    requestAnimationFrame(function () {
      rafPending = false;
      repaint();
    });
  }

  function repaint() {
    if (!canvas || !design) return;

    switch (currentView) {
      case 'cross-section':
        R.paintCrossSection(canvas, design, { selectedSurface: selectedSurface });
        break;
      case 'spot':
        var spotAngles = [0];
        if (design.fovAngle > 0.1) {
          spotAngles.push(design.fovAngle / 4);
          spotAngles.push(design.fovAngle / 2);
        }
        R.paintSpotDiagram(canvas, design, { fieldAngles: spotAngles });
        break;
      case 'aberration':
        var abAngles = [0];
        if (design.fovAngle > 0.1) {
          abAngles.push(design.fovAngle / 4);
          abAngles.push(design.fovAngle / 2);
        }
        R.paintRayAberration(canvas, design, { fieldAngles: abAngles });
        break;
      case 'chromatic':
        R.paintCrossSection(canvas, design, { selectedSurface: selectedSurface });
        if (els.chromContainer) R.paintChromaticTable(els.chromContainer, design);
        break;
    }
  }

  function refreshAll() {
    writeEnvToDOM();
    buildTable();
    design.applyAutofocus();
    updateMetrics();
    scheduleRepaint();
  }

  /* ================================================================
   *  EXPORT
   * ================================================================ */

  win.ODUI = {
    init:      init,
    getDesign: function () { return design; },
    loadPreset: loadPreset,
    refreshAll: refreshAll,
    selectSurface: function (idx) { selectedSurface = idx; refreshAll(); }
  };

})(window);
