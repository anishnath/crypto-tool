/*
 * Crypto-viz frontend. Drives the OneCompiler /crypto/* API entirely from data:
 *   1. GET  action=crypto_algorithms -> catalog (a form schema)
 *   2. build the algorithm picker + dynamic input form from that schema
 *   3. POST action=crypto_trace { algorithm, mode, message, key }
 *   4. render the returned { panels[], steps[] } as matrices + a step player
 *
 * The protocol is panel/step based (NOT the language-viz {key,method,args}),
 * so this renderer is dedicated. Step shape, by op:
 *   load    : after
 *   xor     : operands[{panel:"rk", values:[4x4]}], detail[{cell,a,b,result}]
 *   sub     : operands[{panel:"sbox", lookups:[{row,col}]}], detail[{cell,...}]
 *   permute : detail[{from:[r,c], to:[r,c]}]
 *   mix     : detail[{col, in[4], out[4], matrix[4x4]}]
 *   emit    : after
 */
(function () {
  'use strict';

  var ENDPOINT = (window.CV_CTX || '') + '/OneCompilerVizFunctionality';

  // Human labels for the op legend (only ops present in a trace are shown).
  var OP_LABELS = {
    load: 'Load', expand: 'Expand schedule', sub: 'Substitute (S-box)',
    permute: 'Permute', mix: 'Mix', xor: 'Add round key',
    round: 'Compression round', add: 'Add to state', emit: 'Output'
  };

  // ---- tiny DOM helpers -----------------------------------------------------
  function el(tag, cls, txt) {
    var e = document.createElement(tag);
    if (cls) e.className = cls;
    if (txt != null) e.textContent = txt;
    return e;
  }
  function $(sel) { return document.querySelector(sel); }
  function clear(node) { while (node.firstChild) node.removeChild(node.firstChild); }

  // ---- state ----------------------------------------------------------------
  var catalog = [];       // algorithms[]
  var current = null;     // selected algorithm
  var trace = null;       // last trace result
  var stepIdx = 0;
  var playing = false;
  var playTimer = null;
  var panelsById = {};    // id -> { meta, root, cellEls[][] }

  // ===========================================================================
  // 1. CATALOG + PICKER
  // ===========================================================================
  function loadCatalog() {
    setStatus('Loading algorithms…');
    fetch(ENDPOINT + '?action=crypto_algorithms', { headers: { 'Accept': 'application/json' } })
      .then(function (r) { return r.json(); })
      .then(function (data) {
        catalog = (data && data.algorithms) || [];
        renderPicker();
        var firstAvail = catalog.filter(function (a) { return a.status === 'available'; })[0];
        if (firstAvail) selectAlgorithm(firstAvail.id);
        setStatus('');
      })
      .catch(function (e) { setStatus('Failed to load algorithms: ' + e.message, true); });
  }

  function renderPicker() {
    var wrap = $('#cvPicker');
    clear(wrap);
    catalog.forEach(function (a) {
      var card = el('button', 'cv-algo' + (a.status !== 'available' ? ' cv-algo--soon' : ''));
      card.type = 'button';
      card.appendChild(el('span', 'cv-algo-name', a.name));
      card.appendChild(el('span', 'cv-algo-cat', a.category));
      if (a.status !== 'available') {
        card.appendChild(el('span', 'cv-soon-badge', 'soon'));
        card.disabled = true;
      } else {
        card.onclick = function () { selectAlgorithm(a.id); };
      }
      card.setAttribute('data-id', a.id);
      wrap.appendChild(card);
    });
  }

  function selectAlgorithm(id) {
    current = catalog.filter(function (a) { return a.id === id; })[0];
    if (!current) return;
    Array.prototype.forEach.call(document.querySelectorAll('.cv-algo'), function (c) {
      c.classList.toggle('cv-algo--active', c.getAttribute('data-id') === id);
    });
    $('#cvAlgoDesc').textContent = current.description || '';
    $('#cvAboutAlgo').textContent = current.description || '';
    clear($('#cvLegend')); // ops (and thus the legend) are known only after a trace
    buildForm();
    resetTrace();
  }

  // Build the "what the colors mean" legend from the ops actually in this trace.
  function buildLegend() {
    var lg = $('#cvLegend');
    clear(lg);
    var seen = {};
    trace.steps.forEach(function (s) {
      if (seen[s.op]) return;
      seen[s.op] = 1;
      var item = el('span');
      item.appendChild(el('i', 'cv-swatch cv-op-' + s.op));
      item.appendChild(el('span', null, ' ' + (OP_LABELS[s.op] || s.op)));
      lg.appendChild(item);
    });
  }

  // ===========================================================================
  // 2. DYNAMIC FORM (from current.params, honoring `when` conditions)
  // ===========================================================================
  function buildForm() {
    var form = $('#cvForm');
    clear(form);
    (current.params || []).forEach(function (f, i) {
      var row = el('div', 'cv-field');
      row.setAttribute('data-name', f.name);
      if (f.when) { row.setAttribute('data-when-field', f.when.field); row.setAttribute('data-when-eq', f.when.equals); }

      var lab = el('label', 'cv-label', f.label || f.name);
      row.appendChild(lab);

      var input;
      if (f.type === 'select') {
        input = el('select', 'cv-input');
        (f.options || []).forEach(function (o) {
          var opt = el('option', null, o.label || o.value);
          opt.value = o.value;
          input.appendChild(opt);
        });
        if (f.default) input.value = f.default;
        input.onchange = applyConditions;
      } else {
        input = el('input', 'cv-input');
        input.type = (f.type === 'number') ? 'number' : 'text';
        if (f.placeholder) input.placeholder = f.placeholder;
        if (f.default) input.value = f.default;
        if (f.pattern) input.setAttribute('data-pattern', f.pattern);
        if (f.bytes) input.setAttribute('data-bytes', f.bytes);
        if (f.type === 'hex') input.spellcheck = false;
      }
      input.setAttribute('data-field', f.name);
      input.id = 'cvf_' + f.name + '_' + i;
      row.appendChild(input);

      if (f.help) row.appendChild(el('div', 'cv-help', f.help));
      form.appendChild(row);
    });
    applyConditions();
  }

  // Collect current field values (mode etc.) and toggle conditional rows.
  function formValues() {
    var vals = {};
    Array.prototype.forEach.call(document.querySelectorAll('#cvForm [data-field]'), function (inp) {
      var row = inp.closest('.cv-field');
      if (row && row.style.display === 'none') return; // hidden -> not submitted
      vals[inp.getAttribute('data-field')] = inp.value.trim();
    });
    return vals;
  }

  function applyConditions() {
    // First pass: read all field values regardless of visibility.
    var raw = {};
    Array.prototype.forEach.call(document.querySelectorAll('#cvForm [data-field]'), function (inp) {
      raw[inp.getAttribute('data-field')] = inp.value;
    });
    Array.prototype.forEach.call(document.querySelectorAll('#cvForm .cv-field'), function (row) {
      var wf = row.getAttribute('data-when-field');
      if (!wf) { row.style.display = ''; return; }
      row.style.display = (raw[wf] === row.getAttribute('data-when-eq')) ? '' : 'none';
    });
  }

  function validate(vals) {
    var errs = [];
    (current.params || []).forEach(function (f) {
      var row = document.querySelector('#cvForm .cv-field[data-name="' + f.name + '"]');
      // Skip validation for fields not currently submitted (hidden duplicates).
      if (!(f.name in vals)) return;
      var v = vals[f.name] || '';
      if (f.required && !v) errs.push((f.label || f.name) + ' is required');
      if (v && f.pattern && !new RegExp(f.pattern).test(v)) {
        errs.push((f.label || f.name) + ' is not in the expected format');
      }
    });
    return errs;
  }

  // ===========================================================================
  // 3. RUN -> TRACE
  // ===========================================================================
  function run() {
    if (!current) return;
    var vals = formValues();
    var errs = validate(vals);
    if (errs.length) { setStatus(errs[0], true); return; }

    var payload = { algorithm: current.id };
    Object.keys(vals).forEach(function (k) { payload[k] = vals[k]; });

    setStatus('Tracing…');
    $('#cvRun').disabled = true;
    fetch(ENDPOINT + '?action=crypto_trace', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
      body: JSON.stringify(payload)
    })
      .then(function (r) { return r.json().then(function (j) { return { ok: r.ok, j: j }; }); })
      .then(function (res) {
        $('#cvRun').disabled = false;
        if (!res.ok || res.j.error) { setStatus(res.j.error || 'Trace failed', true); return; }
        trace = res.j;
        setStatus('');
        renderTrace();
      })
      .catch(function (e) { $('#cvRun').disabled = false; setStatus('Trace failed: ' + e.message, true); });
  }

  function resetTrace() {
    trace = null; stepIdx = 0; stopPlay();
    $('#cvStage').style.display = 'none';
  }

  // ===========================================================================
  // 4. RENDER PANELS + STEP PLAYER
  // ===========================================================================
  function renderTrace() {
    // Must be an explicit value: the stylesheet has `#cvStage{display:none}`,
    // so clearing the inline style ('') would fall back to that rule and stay hidden.
    $('#cvStage').style.display = 'block';
    // header summary
    $('#cvTraceTitle').textContent = trace.algorithm || current.name;
    var outWrap = $('#cvOutput');
    clear(outWrap);
    if (trace.output) {
      Object.keys(trace.output).forEach(function (k) {
        var chip = el('span', 'cv-out-chip');
        chip.appendChild(el('span', 'cv-out-k', k));
        chip.appendChild(el('span', 'cv-out-v', trace.output[k]));
        outWrap.appendChild(chip);
      });
    }

    buildPanels();
    buildLegend();
    stepIdx = 0;
    applyStep(0, true);
  }

  function buildPanels() {
    var host = $('#cvPanels');
    clear(host);
    panelsById = {};
    (trace.panels || []).forEach(function (p) {
      var card = el('div', 'cv-panel');
      var head = el('div', 'cv-panel-head');
      head.appendChild(el('span', 'cv-panel-label', p.label || p.id));
      head.appendChild(el('span', 'cv-panel-kind', p.kind));
      card.appendChild(head);

      var rows = p.rows || (p.values ? p.values.length : 4);
      var cols = p.cols || 4;

      // optional column-label header (e.g. a..h, H0..H7)
      if (p.labels && p.labels.length) {
        var hdr = el('div', 'cv-collabels');
        hdr.style.gridTemplateColumns = 'repeat(' + cols + ', 1fr)';
        p.labels.forEach(function (lab) { hdr.appendChild(el('span', 'cv-collabel', lab)); });
        card.appendChild(hdr);
      }

      var grid = el('div', 'cv-grid cv-grid--' + p.kind);
      grid.style.gridTemplateColumns = 'repeat(' + cols + ', 1fr)';

      var cellEls = [];
      for (var r = 0; r < rows; r++) {
        cellEls[r] = [];
        for (var c = 0; c < cols; c++) {
          var cell = el('div', 'cv-cell');
          var val = (p.values && p.values[r]) ? p.values[r][c] : '';
          cell.textContent = val || '';
          grid.appendChild(cell);
          cellEls[r][c] = cell;
        }
      }
      card.appendChild(grid);
      host.appendChild(card);
      panelsById[p.id] = { meta: p, root: card, cells: cellEls };
    });
  }

  function setPanel(id, matrix) {
    var P = panelsById[id];
    if (!P || !matrix) return;
    for (var r = 0; r < matrix.length; r++) {
      for (var c = 0; c < matrix[r].length; c++) {
        if (P.cells[r] && P.cells[r][c]) P.cells[r][c].textContent = matrix[r][c];
      }
    }
  }

  function clearHighlights() {
    Object.keys(panelsById).forEach(function (id) {
      panelsById[id].cells.forEach(function (row) {
        row.forEach(function (cell) {
          cell.className = 'cv-cell';
        });
      });
    });
  }

  // Replay deterministically from the load step up to idx so the state is exact
  // regardless of how the user scrubbed (cheap: <=42 steps).
  function applyStep(idx, hard) {
    if (!trace || !trace.steps.length) return;
    idx = Math.max(0, Math.min(idx, trace.steps.length - 1));
    stepIdx = idx;

    // Rebuild target panels from snapshots up to idx (exact, no drift).
    var prevByPanel = {};
    for (var i = 0; i <= idx; i++) {
      var s = trace.steps[i];
      if (s.after && s.target) { setPanel(s.target, s.after); prevByPanel[s.target] = s.after; }
    }
    clearHighlights();
    decorate(trace.steps[idx]);
    renderStepInfo(trace.steps[idx], idx);
    renderTimeline(idx);
  }

  // op-specific highlighting on top of the freshly-set panels.
  function decorate(s) {
    var op = s.op;
    var tgt = panelsById[s.target];
    var accent = 'cv-hl-' + op;

    if (op === 'xor' && s.operands) {
      s.operands.forEach(function (o) {
        if (o.panel && o.values) setPanel(o.panel, o.values);
        var P = panelsById[o.panel];
        if (P) flashAll(P, 'cv-hl-operand');
      });
      if (tgt) flashAll(tgt, accent);
    } else if (op === 'sub' && s.operands) {
      // highlight the s-box lookups
      s.operands.forEach(function (o) {
        var P = panelsById[o.panel];
        if (P && o.lookups) o.lookups.forEach(function (lk) {
          if (P.cells[lk.row] && P.cells[lk.row][lk.col]) P.cells[lk.row][lk.col].classList.add('cv-hl-lookup');
        });
      });
      if (tgt) flashAll(tgt, accent);
    } else if (op === 'permute' && s.detail) {
      // mark cells that moved
      if (tgt) s.detail.forEach(function (d) {
        var to = d.to; if (to && tgt.cells[to[0]] && tgt.cells[to[0]][to[1]]) tgt.cells[to[0]][to[1]].classList.add(accent);
      });
    } else if (op === 'mix' && s.detail) {
      if (tgt) flashAll(tgt, accent);
    } else if (op === 'expand') {
      // highlight just the row derived this step (newRow>=0), else the whole panel
      if (tgt && s.newRow != null && s.newRow >= 0 && tgt.cells[s.newRow]) {
        tgt.cells[s.newRow].forEach(function (cell) { cell.classList.add('cv-hl-expand'); });
      } else if (tgt) {
        flashAll(tgt, 'cv-hl-expand');
      }
    } else if (tgt) {
      flashAll(tgt, accent);
    }
  }

  function flashAll(P, cls) {
    P.cells.forEach(function (row) { row.forEach(function (cell) { cell.classList.add(cls); }); });
  }

  function renderStepInfo(s, idx) {
    $('#cvStepNo').textContent = (idx + 1) + ' / ' + trace.steps.length;
    $('#cvPhase').textContent = s.phase || '';
    var opBadge = $('#cvOp'); opBadge.textContent = s.op; opBadge.className = 'cv-op-badge cv-op-' + s.op;
    $('#cvStepTitle').textContent = s.title || '';
    $('#cvFormula').textContent = s.formula || '';
    $('#cvFormula').style.display = s.formula ? '' : 'none';
    $('#cvExplain').textContent = s.explain || '';

    // detail table (compact, op-aware)
    var dt = $('#cvDetail'); clear(dt);
    if (s.op === 'mix' && s.detail) {
      s.detail.forEach(function (d) {
        dt.appendChild(el('div', 'cv-detail-line',
          'col ' + d.col + ':  [' + d.in.join(' ') + ']  →  [' + d.out.join(' ') + ']'));
      });
    } else if (s.op === 'xor' && s.detail) {
      var line = s.detail.slice(0, 4).map(function (d) { return d.a + '⊕' + d.b + '=' + d.result; }).join('   ');
      dt.appendChild(el('div', 'cv-detail-line', line + (s.detail.length > 4 ? '   …' : '')));
    } else if (s.op === 'expand' && s.detail) {
      var cap = 6;
      s.detail.slice(0, cap).forEach(function (d) {
        if (d.kind === 'g') {
          dt.appendChild(el('div', 'cv-detail-line',
            'w' + d.word + ' = ' + d.wprev4 + ' ⊕ g(' + d.prev + ')   ·   RotWord→' + d.rot +
            '   SubWord→' + d.sub + '   ⊕Rcon ' + d.rcon + ' = ' + d.temp + '   ⇒ ' + d.result));
        } else if (d.kind === 'sched') {
          dt.appendChild(el('div', 'cv-detail-line',
            'W' + d.word + ' = σ1(' + d.s1 + ') + W[t-7] ' + d.wm7 + ' + σ0(' + d.s0 + ') + W[t-16] ' + d.wm16 + ' = ' + d.result));
        } else if (d.kind === 'xor') {
          dt.appendChild(el('div', 'cv-detail-line',
            'w' + d.word + ' = ' + d.a + ' ⊕ ' + d.b + ' = ' + d.result));
        } else {
          dt.appendChild(el('div', 'cv-detail-line', 'w' + d.word + ' = ' + d.result + '   (from cipher key)'));
        }
      });
      if (s.detail.length > cap) dt.appendChild(el('div', 'cv-detail-line', '… +' + (s.detail.length - cap) + ' more'));
    } else if (s.op === 'round' && s.detail) {
      var d = s.detail[0];
      dt.appendChild(el('div', 'cv-detail-line',
        'T1 = h + Σ1 ' + d.S1 + ' + Ch ' + d.ch + ' + K ' + d.K + ' + W ' + d.W + '  =  ' + d.t1));
      dt.appendChild(el('div', 'cv-detail-line',
        'T2 = Σ0 ' + d.S0 + ' + Maj ' + d.maj + '  =  ' + d.t2 + '      → a = T1+T2, e = d+T1'));
    } else if (s.op === 'add' && s.detail) {
      var line = s.detail.map(function (d) { return 'H' + d.idx + '=' + d.old + '+' + d.add + '=' + d.result; });
      dt.appendChild(el('div', 'cv-detail-line', line.slice(0, 4).join('   ')));
      dt.appendChild(el('div', 'cv-detail-line', line.slice(4).join('   ')));
    }
  }

  function renderTimeline(idx) {
    var tl = $('#cvTimeline');
    if (tl.childElementCount !== trace.steps.length) {
      clear(tl);
      trace.steps.forEach(function (s, i) {
        var dot = el('button', 'cv-tl-dot cv-op-' + s.op);
        dot.type = 'button';
        dot.title = (s.phase || '') + ' — ' + (s.title || s.op);
        dot.onclick = function () { stopPlay(); applyStep(i); };
        tl.appendChild(dot);
      });
    }
    Array.prototype.forEach.call(tl.children, function (d, i) {
      d.classList.toggle('cv-tl-active', i === idx);
    });
  }

  // ---- player controls ------------------------------------------------------
  function next() { if (trace) { if (stepIdx >= trace.steps.length - 1) { stopPlay(); return; } applyStep(stepIdx + 1); } }
  function prev() { if (trace) applyStep(stepIdx - 1); }
  function first() { if (trace) applyStep(0); }
  function last() { if (trace) applyStep(trace.steps.length - 1); }

  function togglePlay() { playing ? stopPlay() : startPlay(); }
  function startPlay() {
    if (!trace) return;
    if (stepIdx >= trace.steps.length - 1) applyStep(0);
    playing = true; $('#cvPlay').innerHTML = '<i class="fas fa-pause"></i>';
    var speed = parseInt($('#cvSpeed').value, 10) || 900;
    playTimer = setInterval(function () {
      if (stepIdx >= trace.steps.length - 1) { stopPlay(); return; }
      applyStep(stepIdx + 1);
    }, speed);
  }
  function stopPlay() {
    playing = false; if (playTimer) clearInterval(playTimer); playTimer = null;
    var b = $('#cvPlay'); if (b) b.innerHTML = '<i class="fas fa-play"></i>';
  }

  // ---- status ---------------------------------------------------------------
  function setStatus(msg, isErr) {
    var s = $('#cvStatus');
    s.textContent = msg || '';
    s.className = 'cv-status' + (isErr ? ' cv-status--err' : '') + (msg ? ' show' : '');
  }

  // ---- wire up ---------------------------------------------------------------
  function init() {
    $('#cvRun').onclick = run;
    $('#cvNext').onclick = function () { stopPlay(); next(); };
    $('#cvPrev').onclick = function () { stopPlay(); prev(); };
    $('#cvFirst').onclick = function () { stopPlay(); first(); };
    $('#cvLast').onclick = function () { stopPlay(); last(); };
    $('#cvPlay').onclick = togglePlay;
    document.addEventListener('keydown', function (e) {
      if (!trace) return;
      if (e.target && /INPUT|SELECT|TEXTAREA/.test(e.target.tagName)) return;
      if (e.key === 'ArrowRight') { stopPlay(); next(); }
      else if (e.key === 'ArrowLeft') { stopPlay(); prev(); }
      else if (e.key === ' ') { e.preventDefault(); togglePlay(); }
    });
    loadCatalog();
  }

  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
  else init();
})();
