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
    round: 'Compression round', add: 'Add to state', feistel: 'Feistel round', modexp: 'Square & multiply',
    ecmul: 'Scalar mult (double & add)', msg: 'Handshake message', emit: 'Output'
  };

  // Per-algorithm "full flow" — the structural map (loops collapsed). Each stage
  // matches on the step's `phase`; the active stage lights up as you step, and
  // clicking a stage jumps to it. Keyed by catalog id. (Protocols use the swimlane.)
  var FLOWS = {
    'aes-128': { stages: [
      { label: 'Key schedule', sub: 'expand key → 11 round keys', m: 'Key Schedule' },
      { label: 'Load block', sub: 'plaintext → 4×4 state', m: 'Setup' },
      { label: 'Rounds', loop: '×10', sub: 'SubBytes · ShiftRows · MixColumns · AddRoundKey', m: /^Round /, note: 'last round: no MixColumns' },
      { label: 'Output', sub: 'read out ciphertext', m: 'Output' }
    ]},
    'des': { stages: [
      { label: 'Key schedule', sub: 'PC-1 · shifts · PC-2 → 16 subkeys', m: 'Key schedule' },
      { label: 'Initial Permutation', sub: 'IP', m: 'Setup' },
      { label: 'Feistel rounds', loop: '×16', sub: 'expand · ⊕key · S-boxes · permute · swap', m: /^Round / },
      { label: 'Final Permutation', sub: 'IP⁻¹ → output', m: 'Output' }
    ]},
    'blowfish': { stages: [
      { label: 'Key schedule', sub: 'key ⊕ π · 521 encryptions → P/S', m: 'Key Schedule' },
      { label: 'Feistel rounds', loop: '×16', sub: 'L ⊕ P · F-function · swap', m: ['Encrypt', 'Decrypt'] },
      { label: 'Output', sub: 'final whitening → block', m: 'Output' }
    ]},
    'sha256': { stages: [
      { label: 'Initialize', sub: 'H = 8 constants', m: 'Initialize' },
      { label: 'Per 512-bit block', loop: 'per block', sub: 'expand W0-63 · 64 compression rounds · add to H', m: /^Block / },
      { label: 'Digest', sub: 'H0…H7', m: 'Output' }
    ]},
    'md5': { stages: [
      { label: 'Initialize', sub: 'A,B,C,D', m: 'Initialize' },
      { label: 'Per 512-bit block', loop: 'per block', sub: '64 ops (F/G/H/I) · add to state', m: /^Block / },
      { label: 'Digest', sub: 'A,B,C,D → 128-bit', m: 'Output' }
    ]},
    'rsa': { stages: [
      { label: 'Key generation', sub: 'p,q → n · φ · e · d', m: 'Key Generation' },
      { label: 'Modular exponentiation', loop: 'square & multiply', sub: 'result = base^exp mod n', m: ['Encrypt', 'Decrypt'] },
      { label: 'Output', sub: 'ciphertext / recovered message', m: 'Output' }
    ]},
    'dh': { stages: [
      { label: 'Public params', sub: 'prime p · generator g', m: 'Public parameters' },
      { label: 'Alice', sub: 'a → A = gᵃ mod p', m: 'Alice' },
      { label: 'Bob', sub: 'b → B = gᵇ mod p', m: 'Bob' },
      { label: 'Exchange', sub: 'swap A, B', m: 'Exchange' },
      { label: 'Shared secret', sub: 'Bᵃ = Aᵇ = g^(ab)', m: ['Shared secret', 'Output'] }
    ]},
    'ecc': { stages: [
      { label: 'The curve', sub: 'y² = x³ + ax + b mod p', m: 'The curve' },
      { label: 'Point ops', sub: 'add · double (geometry)', m: 'Point operations' },
      { label: 'Scalar multiply', loop: 'double & add', sub: 'Q = d·G', m: ['Key generation', 'Alice', 'Bob', 'Shared secret'] },
      { label: 'Output', sub: 'public key / shared secret', m: 'Output' }
    ]}
  };

  // MD5's four nonlinear round functions, shown so users see what each does.
  var MD5_DEF = {
    F: '(b ∧ c) ∨ (¬b ∧ d)', G: '(b ∧ d) ∨ (c ∧ ¬d)',
    H: 'b ⊕ c ⊕ d', I: 'c ⊕ (b ∨ ¬d)'
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
  var flowStages = [];    // [{el, stage}] for the "full flow" strip

  // ===========================================================================
  // 1. CATALOG + PICKER
  // ===========================================================================
  function loadCatalog() {
    setStatus('Loading algorithms…');
    fetch(ENDPOINT + '?action=crypto_algorithms', { headers: { 'Accept': 'application/json' } })
      .then(function (r) { return r.json(); })
      .then(function (data) {
        catalog = (data && data.algorithms) || [];
        appendStaticAlgorithms(); // TLS handshakes: recorded static captures, no backend
        renderPicker();
        var firstAvail = catalog.filter(function (a) { return a.status === 'available'; })[0];
        if (firstAvail) selectAlgorithm(firstAvail.id);
        setStatus('');
      })
      .catch(function (e) { setStatus('Failed to load algorithms: ' + e.message, true); });
  }

  // Append algorithms whose traces are pre-recorded static files (not the live
  // Docker API) — keeps everything in the same page/picker with no backend change.
  function appendStaticAlgorithms() {
    catalog.push({
      id: 'tls', name: 'SSL / TLS handshake', category: 'protocol', status: 'available',
      description: 'Real TLS handshakes captured with openssl (-msg) over loopback, replayed exactly. Step through the Client↔Server message flow and compare versions.',
      directions: ['handshake'],
      _static: (window.CV_CTX || '') + '/crypto-viz/data/tls/',
      params: [{
        name: 'version', label: 'Protocol version', type: 'select', required: true, default: 'tls_1_3',
        options: [
          { value: 'tls_1_3', label: 'TLS 1.3  (1-RTT, modern)' },
          { value: 'tls_1_2', label: 'TLS 1.2' },
          { value: 'tls_1_1', label: 'TLS 1.1' },
          { value: 'tls_1_0', label: 'TLS 1.0' }
        ], help: 'Each is a real recorded handshake — notice how 1.3 needs far fewer round trips.'
      }],
      output: { name: 'result', label: 'Result', type: 'text' }
    });
    catalog.push({
      id: 'grpc', name: 'gRPC (over HTTP/2)', category: 'protocol', status: 'available',
      description: 'A real gRPC unary call captured at the HTTP/2 frame level (h2c loopback). Shows the two layers people conflate: HTTP/2 framing (SETTINGS/HEADERS/DATA/streams) and gRPC message framing + Protobuf on top.',
      directions: ['rpc'],
      _static: (window.CV_CTX || '') + '/crypto-viz/data/grpc/',
      params: [{
        name: 'version', label: 'Call type', type: 'select', required: true, default: 'grpc_unary',
        options: [{ value: 'grpc_unary', label: 'Unary RPC (SayHello)' }],
        help: 'A single request → single response RPC over one HTTP/2 stream.'
      }],
      output: { name: 'result', label: 'Result', type: 'text' }
    });
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

    // Static (pre-recorded) algorithms: load the captured JSON, no API call.
    if (current._static) {
      var url = current._static + (vals.version || (current.params[0] && current.params[0].default)) + '.json';
      setStatus('Loading capture…');
      $('#cvRun').disabled = true;
      fetch(url, { headers: { 'Accept': 'application/json' } })
        .then(function (r) { return r.json(); })
        .then(function (j) { $('#cvRun').disabled = false; trace = j; setStatus(''); renderTrace(); })
        .catch(function (e) { $('#cvRun').disabled = false; setStatus('Failed to load capture: ' + e.message, true); });
      return;
    }

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

    buildFlow();
    buildPanels();
    buildLegend();
    stepIdx = 0;
    applyStep(0, true);
  }

  function stageMatch(m, phase) {
    if (!phase) return false;
    if (m instanceof RegExp) return m.test(phase);
    if (Array.isArray(m)) return m.indexOf(phase) >= 0;
    return phase === m || phase.indexOf(m) === 0;
  }

  // Render the "full flow" strip for the current algorithm (structural overview +
  // click-to-jump). Skipped for protocol swimlanes — there the swimlane IS the flow.
  function buildFlow() {
    var host = $('#cvFlow');
    clear(host);
    flowStages = [];
    var spec = FLOWS[current && current.id];
    var hasSwim = (trace.panels || []).some(function (p) { return p.kind === 'swimlane'; });
    if (!spec || hasSwim) { host.style.display = 'none'; return; }
    host.style.display = '';
    host.appendChild(el('div', 'cv-flow-title', 'FULL FLOW'));
    var track = el('div', 'cv-flow-track');
    spec.stages.forEach(function (st) {
      var firstIdx = -1;
      for (var k = 0; k < trace.steps.length; k++) { if (stageMatch(st.m, trace.steps[k].phase)) { firstIdx = k; break; } }
      if (firstIdx < 0) return; // stage didn't occur in this particular run
      if (track.childElementCount) track.appendChild(el('span', 'cv-flow-arrow', '→'));
      var box = el('div', 'cv-flow-stage');
      var lab = el('div', 'cv-flow-stage-label');
      lab.appendChild(el('span', null, st.label));
      if (st.loop) lab.appendChild(el('span', 'cv-flow-loop', '⟳ ' + st.loop));
      box.appendChild(lab);
      if (st.sub) box.appendChild(el('div', 'cv-flow-sub', st.sub));
      if (st.note) box.appendChild(el('div', 'cv-flow-note', st.note));
      box.title = 'Jump to: ' + st.label;
      box.onclick = (function (idx) { return function () { stopPlay(); applyStep(idx); }; })(firstIdx);
      track.appendChild(box);
      flowStages.push({ el: box, m: st.m });
    });
    host.appendChild(track);
  }

  function highlightFlow(s) {
    flowStages.forEach(function (fs) {
      fs.el.classList.toggle('cv-flow-active', !!(s && stageMatch(fs.m, s.phase)));
    });
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

      // TLS handshake swimlane: Client↔Server message sequence, revealed per step
      if (p.kind === 'swimlane') {
        var swim = el('div', 'cv-swim');
        var head = el('div', 'cv-swim-head');
        head.appendChild(el('span', 'cv-swim-lane', (p.lanes && p.lanes[0]) || 'Client'));
        head.appendChild(el('span', 'cv-swim-lane', (p.lanes && p.lanes[1]) || 'Server'));
        swim.appendChild(head);
        var rowEls = [];
        (p.messages || []).forEach(function (m, i) {
          var row = el('div', 'cv-msg cv-msg-' + m.dir);
          var arw = el('div', 'cv-arrow');
          var top = el('div', 'cv-arrow-top');
          top.appendChild(el('span', 'cv-arrow-name', m.name));
          top.appendChild(el('span', 'cv-arrow-bytes', m.bytes + ' B'));
          arw.appendChild(top);
          if (m.annot) arw.appendChild(el('div', 'cv-arrow-annot', m.annot));
          row.appendChild(arw);
          swim.appendChild(row);
          rowEls[i] = row;
        });
        card.appendChild(swim);
        host.appendChild(card);
        panelsById[p.id] = { meta: p, root: card, kind: 'swimlane', cells: [], rows: rowEls };
        return;
      }

      // elliptic-curve scatter plot (teaching curve): SVG of all points + per-step highlights
      if (p.kind === 'curve') {
        var cinfo = { meta: p, root: card, kind: 'curve', cells: [], ptmap: {}, lines: [] };
        if (document.createElementNS) {
          var SZ = 320, PAD = 26, span = SZ - 2 * PAD, pp = p.p || 17, sc = span / pp;
          var ns = 'http://www.w3.org/2000/svg';
          var svg = document.createElementNS(ns, 'svg');
          svg.setAttribute('viewBox', '0 0 ' + SZ + ' ' + SZ);
          svg.setAttribute('class', 'cv-plot');
          cinfo.svgns = ns; cinfo.svg = svg;
          cinfo.map = function (x, y) { return [PAD + x * sc, SZ - PAD - y * sc]; };
          var ax = document.createElementNS(ns, 'path');
          ax.setAttribute('d', 'M' + PAD + ' ' + (SZ - PAD) + ' H' + (SZ - PAD) + ' M' + PAD + ' ' + (SZ - PAD) + ' V' + PAD);
          ax.setAttribute('class', 'cv-plot-axis'); svg.appendChild(ax);
          (p.points || []).forEach(function (pt) {
            var xy = cinfo.map(pt[0], pt[1]);
            var c = document.createElementNS(ns, 'circle');
            c.setAttribute('cx', xy[0]); c.setAttribute('cy', xy[1]); c.setAttribute('r', 5);
            c.setAttribute('class', 'cv-pt'); svg.appendChild(c);
            cinfo.ptmap[pt[0] + ',' + pt[1]] = c;
          });
          card.appendChild(svg);
        }
        host.appendChild(card);
        panelsById[p.id] = cinfo;
        return;
      }

      // key/value panel (RSA big numbers): row label + scrollable value box
      if (p.kind === 'kv') {
        var kvWrap = el('div', 'cv-kv');
        var kvCells = [];
        (p.rowLabels || []).forEach(function (lab, r) {
          var row = el('div', 'cv-kv-row');
          row.appendChild(el('span', 'cv-kv-label', lab));
          var val = el('div', 'cv-kv-val');
          row.appendChild(val);
          kvWrap.appendChild(row);
          kvCells[r] = [val];
        });
        card.appendChild(kvWrap);
        host.appendChild(card);
        panelsById[p.id] = { meta: p, root: card, cells: kvCells };
        return;
      }

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
    // strip only cv-hl-* so base classes (cv-cell / cv-kv-val) survive
    Object.keys(panelsById).forEach(function (id) {
      panelsById[id].cells.forEach(function (row) {
        row.forEach(function (cell) {
          cell.className = cell.className.split(' ').filter(function (c) { return c && c.indexOf('cv-hl-') !== 0; }).join(' ');
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
    renderPlot(trace.steps[idx]);
    renderSwimlane(trace.steps[idx]);
    highlightFlow(trace.steps[idx]);
    renderStepInfo(trace.steps[idx], idx);
    renderTimeline(idx);
  }

  // reveal handshake messages up to the current step and highlight the active one
  function renderSwimlane(s) {
    var sp = null;
    Object.keys(panelsById).forEach(function (id) { if (panelsById[id].kind === 'swimlane') sp = panelsById[id]; });
    if (!sp || !sp.rows) return;
    var idx = (s && s.idx != null) ? s.idx : -1;
    sp.rows.forEach(function (r, i) {
      r.classList.remove('cv-msg-active');
      r.style.opacity = (i <= idx) ? '1' : '0.25';
      if (i === idx) r.classList.add('cv-msg-active');
    });
  }

  // update the EC scatter plot: reset all points, then color this step's highlights + reflection line
  function renderPlot(s) {
    var cp = null;
    Object.keys(panelsById).forEach(function (id) { if (panelsById[id].kind === 'curve') cp = panelsById[id]; });
    if (!cp || !cp.svg) return;
    Object.keys(cp.ptmap).forEach(function (k) { cp.ptmap[k].setAttribute('class', 'cv-pt'); });
    (cp.lines || []).forEach(function (l) { if (l.parentNode) l.parentNode.removeChild(l); });
    cp.lines = [];
    var plot = s && s.plot;
    if (!plot) return;
    (plot.hi || []).forEach(function (h) {
      var c = cp.ptmap[h.x + ',' + h.y];
      if (c) c.setAttribute('class', 'cv-pt cv-pt-' + h.role);
    });
    if (plot.line && cp.map) {
      var a = cp.map(plot.line[0][0], plot.line[0][1]), b = cp.map(plot.line[1][0], plot.line[1][1]);
      var ln = document.createElementNS(cp.svgns, 'line');
      ln.setAttribute('x1', a[0]); ln.setAttribute('y1', a[1]); ln.setAttribute('x2', b[0]); ln.setAttribute('y2', b[1]);
      ln.setAttribute('class', 'cv-plot-line'); cp.svg.appendChild(ln); cp.lines.push(ln);
    }
  }

  // op-specific highlighting on top of the freshly-set panels.
  function decorate(s) {
    var op = s.op;
    var tgt = panelsById[s.target];
    var accent = 'cv-hl-' + op;

    // Generic operand highlighting — works for ANY op that references other
    // panels: AES round key (values) + S-box lookups, SHA K[t]/W[t], Blowfish P[i].
    if (s.operands) {
      s.operands.forEach(function (o) {
        var P = panelsById[o.panel];
        if (!P) return;
        if (o.values) { setPanel(o.panel, o.values); flashAll(P, 'cv-hl-operand'); }
        if (o.lookups) o.lookups.forEach(function (lk) {
          if (P.cells[lk.row] && P.cells[lk.row][lk.col]) P.cells[lk.row][lk.col].classList.add('cv-hl-lookup');
        });
      });
    }

    // Target-panel highlight by op.
    if (op === 'permute' && s.detail) {
      if (tgt) s.detail.forEach(function (d) {
        var to = d.to; if (to && tgt.cells[to[0]] && tgt.cells[to[0]][to[1]]) tgt.cells[to[0]][to[1]].classList.add(accent);
      });
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
      // SHA message schedule: define the small-sigma functions once at the top
      if (s.detail[0] && s.detail[0].kind === 'sched') {
        dt.appendChild(el('div', 'cv-detail-line', 'σ0(x) = ROTR7 ⊕ ROTR18 ⊕ SHR3      σ1(x) = ROTR17 ⊕ ROTR19 ⊕ SHR10'));
      }
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
      if (d.func) { // MD5 op — show the active nonlinear function's definition + live value
        dt.appendChild(el('div', 'cv-detail-line', d.func + '(b,c,d) = ' + (MD5_DEF[d.func] || '') + '  =  ' + d.fval));
        dt.appendChild(el('div', 'cv-detail-line',
          'b += ((a + ' + d.func + ' + M[' + d.g + '] ' + d.m + ' + T[' + d.i + '] ' + d.k + ') <<< ' + d.s + ')  =  ' + d.result));
      } else { // SHA-256 round — show each function definition alongside its result
        dt.appendChild(el('div', 'cv-detail-line', 'Ch(e,f,g) = (e ∧ f) ⊕ (¬e ∧ g)  =  ' + d.ch));
        dt.appendChild(el('div', 'cv-detail-line', 'Maj(a,b,c) = (a∧b) ⊕ (a∧c) ⊕ (b∧c)  =  ' + d.maj));
        dt.appendChild(el('div', 'cv-detail-line', 'Σ1(e) = ROTR6 ⊕ ROTR11 ⊕ ROTR25  =  ' + d.S1));
        dt.appendChild(el('div', 'cv-detail-line', 'Σ0(a) = ROTR2 ⊕ ROTR13 ⊕ ROTR22  =  ' + d.S0));
        dt.appendChild(el('div', 'cv-detail-line', 'T1 = h + Σ1 + Ch + K + W = ' + d.t1 + '      T2 = Σ0 + Maj = ' + d.t2 + '   → a=T1+T2, e=d+T1'));
      }
    } else if (s.op === 'add' && s.detail) {
      var line = s.detail.map(function (d) { return 'H' + d.idx + '=' + d.old + '+' + d.add + '=' + d.result; });
      dt.appendChild(el('div', 'cv-detail-line', line.slice(0, 4).join('   ')));
      dt.appendChild(el('div', 'cv-detail-line', line.slice(4).join('   ')));
    } else if (s.op === 'modexp' && s.detail) {
      var md = s.detail[0];
      dt.appendChild(el('div', 'cv-detail-line',
        'exponent bit ' + (md.pos != null ? md.pos : '?') + ' = ' + md.bit + '  →  ' + (md.op || (md.bit ? 'square, then multiply' : 'square'))));
    } else if (s.op === 'ecmul' && s.detail) {
      var ec = s.detail[0];
      dt.appendChild(el('div', 'cv-detail-line',
        (ec.op || '') + (ec.bit != null ? '   ·   scalar bit = ' + ec.bit : '')));
    } else if (s.op === 'msg' && s.detail) {
      var mm = s.detail[0];
      dt.appendChild(el('div', 'cv-detail-line', mm.record + ' record · ' + mm.bytes + ' bytes on the wire'));
      dt.appendChild(el('div', 'cv-detail-line cv-hex', mm.hex));
    } else if (s.op === 'feistel' && s.detail) {
      var fd = s.detail[0];
      if (fd.sboxes) { // DES
        dt.appendChild(el('div', 'cv-detail-line', 'round key K = ' + fd.rk));
        dt.appendChild(el('div', 'cv-detail-line',
          'S-boxes:  ' + fd.sboxes.map(function (x) { return 'S' + x.i + ' ' + x.in + '→' + x.out; }).join('   ')));
        dt.appendChild(el('div', 'cv-detail-line', 'f(R,K) = ' + fd.f + '   → newR = L ⊕ f(R,K), then swap'));
      } else { // Blowfish
        dt.appendChild(el('div', 'cv-detail-line', 'L ⊕ P = ' + fd.xl + '   → into F'));
        dt.appendChild(el('div', 'cv-detail-line',
          'S0[' + fd.a + ']=' + fd.s0 + '   S1[' + fd.b + ']=' + fd.s1 + '   S2[' + fd.c + ']=' + fd.s2 + '   S3[' + fd.d + ']=' + fd.s3));
        dt.appendChild(el('div', 'cv-detail-line', 'F = ((S0+S1) ⊕ S2) + S3 = ' + fd.f + '   → R ⊕= F, then swap'));
      }
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
