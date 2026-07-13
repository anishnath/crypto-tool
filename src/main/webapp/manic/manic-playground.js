/*
 * manic-playground.js — app shell for the manic playground.
 *
 * Owns: multi-file workspace (localStorage drafts + Monaco models), the render
 * loop against the manic API (submit → poll → play video) via the
 * /ManicFunctionality proxy, the plan/quality selector fed by the API `options`,
 * and structured-error handling per MANIC_API.md's UI Error Catalog.
 *
 * Depends on window.ManicEditor (manic-editor.js) and window.MANIC (index.jsp).
 */
(function () {
  'use strict';

  var CFG = window.MANIC || {};
  var SERVLET = CFG.servlet;                 // e.g. /ctx/ManicFunctionality
  var EXAMPLES_BASE = (CFG.ctx || '') + '/manic/examples/';
  var LS_FILES = 'manic_files_v1';
  var LS_ACTIVE = 'manic_active_v1';
  var LS_BID = 'manic_bid';
  var LS_THEME = 'manic_theme';

  console.log('Manic Playground v' + CFG.version + ' (MANIC_API.md)');

  var SAMPLE =
    'title("Playground");\n' +
    'canvas(1280, 720);\n\n' +
    '// builtin (cyan), variable id (white), color (green)\n' +
    'circle(sun, (640, 360), 90);\n' +
    'color(sun, cyan);\n\n' +
    'for i in 0..5 {\n' +
    '  dot(p{i}, (200 + i*180, 620), 6);\n' +
    '}\n\n' +
    'show(sun, 0.6);\n';

  // ── state ──────────────────────────────────────────────────────
  var ME = window.ManicEditor;
  var monaco = null;
  var editor = null;
  var models = {};          // fileName -> monaco model
  var activeName = null;
  var browserId = null;
  var userId = null;
  var plan = (CFG.plan || 'free');   // display only — the SERVER decides the real plan (loadLimits)
  var atLimit = false;   // usage quota exhausted
  var hasError = false;  // active file has error-severity diagnostics
  var running = false;   // a render is in flight
  var errShown = false;  // status line currently shows an editor error
  var options = [];         // render tiers from the API
  var pollTimer = null;
  var currentJobId = null;
  var theme = localStorage.getItem(LS_THEME) || 'dark';

  // ── DOM ────────────────────────────────────────────────────────
  var $ = function (id) { return document.getElementById(id); };
  var el = {};

  document.addEventListener('DOMContentLoaded', function () {
    el = {
      editor: $('manic-editor'), fileList: $('file-list'), newFile: $('new-file-btn'),
      run: $('run-btn'), quality: $('quality-select'), planInfo: $('plan-info'),
      themeBtn: $('theme-btn'), status: $('status-line'), video: $('result-video'),
      videoWrap: $('video-wrap'), errorBox: $('error-box'), sourceLink: $('source-link'),
      toast: $('toast'), placeholder: $('output-placeholder'),
      examplesBtn: $('examples-btn'), examplesOverlay: $('examples-overlay'),
      examplesBody: $('examples-body'), examplesClose: $('examples-close'),
      welcomeOverlay: $('welcome-overlay'), welcomeClose: $('welcome-close'),
      welcomeStart: $('welcome-start'), welcomeExamples: $('welcome-examples'),
      helpBtn: $('help-btn')
    };
    initBrowserId();
    boot();
  });

  function initBrowserId() {
    browserId = localStorage.getItem(LS_BID);
    if (!browserId) {
      var rnd = (window.crypto && crypto.randomUUID)
        ? crypto.randomUUID()
        : (Date.now().toString(36) + Math.random().toString(36).slice(2));
      browserId = 'bid-' + rnd;
      localStorage.setItem(LS_BID, browserId);
    }
    userId = browserId;
  }

  async function boot() {
    setStatus('loading editor…');
    try {
      var b = await ME.boot();
      monaco = b.monaco;
    } catch (e) {
      setStatus('failed to load editor: ' + e.message, true);
      return;
    }
    createEditor();
    wireDiagnostics();
    loadFiles();
    wireToolbar();
    wireSplitter();
    exposeBridge();
    loadLimits();
    maybeShowWelcome();
    setStatus('ready');
  }

  // ── editor + files ─────────────────────────────────────────────
  function createEditor() {
    editor = monaco.editor.create(el.editor, {
      value: '', language: 'manic',
      theme: theme === 'light' ? ME.THEME_LIGHT : ME.THEME_DARK,
      fontSize: 13, minimap: { enabled: false }, automaticLayout: true,
      scrollBeyondLastLine: false, lineNumbers: 'on', tabSize: 2,
      padding: { top: 10 }, renderWhitespace: 'selection'
    });
    editor.addCommand(monaco.KeyMod.CtrlCmd | monaco.KeyCode.Enter, render);
    document.body.classList.toggle('light', theme === 'light');
  }

  function loadFiles() {
    var saved = {};
    try { saved = JSON.parse(localStorage.getItem(LS_FILES) || '{}'); } catch (e) { saved = {}; }
    var names = Object.keys(saved);
    if (!names.length) { saved = { 'playground.manic': SAMPLE }; names = ['playground.manic']; }
    names.forEach(function (name) { addModel(name, saved[name]); });
    var active = localStorage.getItem(LS_ACTIVE);
    switchFile(models[active] ? active : names[0]);
    renderFileRail();
  }

  function addModel(name, content) {
    var uri = monaco.Uri.parse('inmemory://manic/' + encodeURIComponent(name));
    var model = monaco.editor.getModel(uri) || monaco.editor.createModel(content || '', 'manic', uri);
    model.onDidChangeContent(function () {
      ME.onModelChanged(model);
      schedulePersist();
    });
    models[name] = model;
    return model;
  }

  function switchFile(name) {
    if (!models[name]) return;
    activeName = name;
    ME.setActiveModel(models[name]); // seed token cache first…
    editor.setModel(models[name]);   // …then show it (Monaco tokenizes with the fresh cache)
    localStorage.setItem(LS_ACTIVE, name);
    renderFileRail();
    refreshDiagnosticsState();        // re-gate Render for the newly-active file
    editor.focus();
  }

  function newFile() {
    var base = 'untitled', i = 1, name;
    do { name = base + (i > 1 ? i : '') + '.manic'; i++; } while (models[name]);
    var input = prompt('New file name:', name);
    if (input == null) return;
    name = input.trim(); if (!name) return;
    if (!/\.manic$/.test(name)) name += '.manic';
    if (models[name]) { toast('“' + name + '” already exists'); switchFile(name); return; }
    addModel(name, '');
    switchFile(name);
    persistFiles();
  }

  function deleteFile(name) {
    if (!models[name]) return;
    if (Object.keys(models).length === 1) { toast('keep at least one file'); return; }
    if (!confirm('Delete “' + name + '”?')) return;
    models[name].dispose();
    delete models[name];
    if (activeName === name) switchFile(Object.keys(models)[0]);
    persistFiles();
    renderFileRail();
  }

  function renameFile(name) {
    var input = prompt('Rename “' + name + '” to:', name);
    if (input == null) return;
    var next = input.trim(); if (!next) return;
    if (!/\.manic$/.test(next)) next += '.manic';
    if (next === name) return;
    if (models[next]) { toast('“' + next + '” already exists'); return; }
    var content = models[name].getValue();
    models[name].dispose(); delete models[name];
    addModel(next, content);
    switchFile(next);
    persistFiles();
  }

  var persistTimer = null;
  function schedulePersist() {
    if (persistTimer) clearTimeout(persistTimer);
    persistTimer = setTimeout(persistFiles, 400);
  }
  function persistFiles() {
    var out = {};
    Object.keys(models).forEach(function (n) { out[n] = models[n].getValue(); });
    try { localStorage.setItem(LS_FILES, JSON.stringify(out)); } catch (e) { /* quota */ }
  }

  function renderFileRail() {
    if (!el.fileList) return;
    el.fileList.innerHTML = '';
    Object.keys(models).forEach(function (name) {
      var li = document.createElement('li');
      li.className = 'file-item' + (name === activeName ? ' active' : '');
      var label = document.createElement('span');
      label.className = 'file-name'; label.textContent = name;
      label.onclick = function () { switchFile(name); };
      label.ondblclick = function () { renameFile(name); };
      var del = document.createElement('button');
      del.className = 'file-del'; del.title = 'Delete'; del.innerHTML = '&times;';
      del.onclick = function (e) { e.stopPropagation(); deleteFile(name); };
      li.appendChild(label); li.appendChild(del);
      el.fileList.appendChild(li);
    });
  }

  // ── toolbar ────────────────────────────────────────────────────
  function wireToolbar() {
    if (el.newFile) el.newFile.onclick = newFile;
    if (el.run) el.run.onclick = render;
    if (el.themeBtn) el.themeBtn.onclick = toggleTheme;
    if (el.examplesBtn) el.examplesBtn.onclick = openExamples;
    if (el.examplesClose) el.examplesClose.onclick = closeExamples;
    if (el.examplesOverlay) el.examplesOverlay.addEventListener('click', function (e) {
      if (e.target === el.examplesOverlay) closeExamples();
    });
    document.addEventListener('keydown', function (e) {
      if (e.key !== 'Escape') return;
      if (el.examplesOverlay && el.examplesOverlay.classList.contains('show')) closeExamples();
      else if (el.welcomeOverlay && el.welcomeOverlay.classList.contains('show')) closeWelcome();
    });
    // welcome modal
    if (el.helpBtn) el.helpBtn.onclick = openWelcome;
    if (el.welcomeClose) el.welcomeClose.onclick = closeWelcome;
    if (el.welcomeStart) el.welcomeStart.onclick = function () { closeWelcome(); if (editor) editor.focus(); };
    if (el.welcomeExamples) el.welcomeExamples.onclick = function () { closeWelcome(); openExamples(); };
    if (el.welcomeOverlay) el.welcomeOverlay.addEventListener('click', function (e) {
      if (e.target === el.welcomeOverlay) closeWelcome();
    });
  }

  // ── welcome modal (first visit) ────────────────────────────────
  var LS_WELCOME = 'manic_welcomed_v1';
  function maybeShowWelcome() {
    var seen = false;
    try { seen = localStorage.getItem(LS_WELCOME) === '1'; } catch (e) {}
    if (!seen && el.welcomeOverlay) el.welcomeOverlay.classList.add('show');
  }
  function openWelcome() {
    if (el.welcomeOverlay) el.welcomeOverlay.classList.add('show');
  }
  function closeWelcome() {
    if (el.welcomeOverlay) el.welcomeOverlay.classList.remove('show');
    try { localStorage.setItem(LS_WELCOME, '1'); } catch (e) {}
  }

  // ── examples picker ────────────────────────────────────────────
  var examplesManifest = null;
  async function openExamples() {
    if (el.examplesOverlay) el.examplesOverlay.classList.add('show');
    if (examplesManifest) return;
    if (el.examplesBody) el.examplesBody.innerHTML = '<div style="color:var(--dim);padding:12px">loading…</div>';
    try {
      var res = await fetch(EXAMPLES_BASE + 'index.json', { cache: 'force-cache' });
      examplesManifest = await res.json();
    } catch (e) {
      if (el.examplesBody) el.examplesBody.innerHTML = '<div style="color:var(--magenta);padding:12px">could not load examples</div>';
      return;
    }
    renderExamples(examplesManifest);
  }

  var ACCENTS = ['#00e6ff', '#ff2d95', '#7cff6b', '#ffd166', '#b388ff', '#ff8a5c'];
  function renderExamples(m) {
    if (!el.examplesBody) return;
    el.examplesBody.innerHTML = '';
    (m.categories || []).forEach(function (cat, ci) {
      var wrap = document.createElement('div');
      wrap.className = 'mp-cat';
      wrap.style.setProperty('--accent', ACCENTS[ci % ACCENTS.length]);
      var h = document.createElement('div');
      h.className = 'mp-cat-title'; h.textContent = cat.title;
      wrap.appendChild(h);
      var grid = document.createElement('div'); grid.className = 'mp-cat-grid';
      (cat.examples || []).forEach(function (ex) {
        var card = document.createElement('button');
        card.className = 'mp-ex-card';
        card.innerHTML = '<b>' + esc(ex.title) + '</b><code>' + esc(ex.file) + '</code>' +
          '<span>' + esc(ex.desc || '') + '</span>';
        card.onclick = function () { loadExample(ex); };
        grid.appendChild(card);
      });
      wrap.appendChild(grid);
      el.examplesBody.appendChild(wrap);
    });
  }

  async function loadExample(ex) {
    var fileName = ex.file;
    if (models[fileName]) { switchFile(fileName); closeExamples(); toast('opened ' + fileName); return; }
    try {
      var res = await fetch(EXAMPLES_BASE + fileName, { cache: 'force-cache' });
      if (!res.ok) throw new Error('http ' + res.status);
      var code = await res.text();
      addModel(fileName, code);
      switchFile(fileName);
      persistFiles();
      closeExamples();
      toast('loaded ' + fileName);
    } catch (e) { toast('could not load ' + fileName); }
  }

  function closeExamples() {
    if (el.examplesOverlay) el.examplesOverlay.classList.remove('show');
  }

  function esc(s) {
    return String(s == null ? '' : s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
  }

  // ── bridge for the AI assistant (manic-ai.js) ─────────────────
  function exposeBridge() {
    window.manicBridge = {
      getCode: function () {
        return (activeName && models[activeName]) ? models[activeName].getValue() : '';
      },
      setCode: function (code) {
        if (!activeName || !models[activeName]) return;
        models[activeName].setValue(String(code == null ? '' : code));
        persistFiles();
        if (editor) editor.focus();
      },
      fileName: function () { return activeName || ''; }
    };
  }

  // ── draggable editor / output splitter ────────────────────────
  var LS_SPLIT = 'manic_split_v1';
  function isNarrow() { return window.matchMedia('(max-width: 860px)').matches; }

  function wireSplitter() {
    var split = $('split-eo');
    var out = $('mp-output');
    var body = document.querySelector('.mp-body');
    if (!split || !out || !body) return;

    // restore a saved width (wide layout only)
    var saved = parseInt(localStorage.getItem(LS_SPLIT) || '', 10);
    if (saved && !isNarrow()) applyOutWidth(out, body, saved);

    var dragging = false;
    split.addEventListener('pointerdown', function (e) {
      if (isNarrow()) return;
      dragging = true;
      try { split.setPointerCapture(e.pointerId); } catch (_) {}
      document.body.classList.add('mp-dragging');
      e.preventDefault();
    });
    split.addEventListener('pointermove', function (e) {
      if (!dragging) return;
      var rect = body.getBoundingClientRect();
      applyOutWidth(out, body, rect.right - e.clientX);
      if (editor) editor.layout();
    });
    var end = function (e) {
      if (!dragging) return;
      dragging = false;
      try { split.releasePointerCapture(e.pointerId); } catch (_) {}
      document.body.classList.remove('mp-dragging');
      localStorage.setItem(LS_SPLIT, String(Math.round(out.getBoundingClientRect().width)));
      if (editor) editor.layout();
    };
    split.addEventListener('pointerup', end);
    split.addEventListener('pointercancel', end);

    // when collapsing to the stacked layout, drop the inline width
    window.addEventListener('resize', function () {
      if (isNarrow()) { out.style.flex = ''; out.style.maxWidth = ''; }
      else if (!out.style.flex) {
        var w = parseInt(localStorage.getItem(LS_SPLIT) || '', 10);
        if (w) applyOutWidth(out, body, w);
      }
    });
  }

  function applyOutWidth(out, body, w) {
    var total = body.getBoundingClientRect().width;
    var max = total - 360; // leave room for the rail + a usable editor
    var min = 260;
    if (max < min) max = min;
    w = Math.max(min, Math.min(w, max));
    out.style.flex = '0 0 ' + w + 'px';
    out.style.maxWidth = 'none';
  }

  function toggleTheme() {
    theme = (theme === 'light') ? 'dark' : 'light';
    monaco.editor.setTheme(theme === 'light' ? ME.THEME_LIGHT : ME.THEME_DARK);
    document.body.classList.toggle('light', theme === 'light');
    localStorage.setItem(LS_THEME, theme);
  }

  // ── limits / quality selector ──────────────────────────────────
  async function loadLimits() {
    try {
      // No plan/user params: the servlet resolves the caller's real plan + id
      // from their login/subscription and injects them.
      var r = await api('limits', {});
      if (r.status !== 200) return;
      var info = r.json || {};
      if (info.plan) plan = info.plan;
      if (info.user_id) userId = info.user_id;
      options = info.options || [];
      fillQuality(options);
      showPlanInfo(info);
    } catch (e) { /* limits are optional; render still works */ }
  }

  function fillQuality(opts) {
    if (!el.quality) return;
    el.quality.innerHTML = '';
    if (!opts.length) {
      el.quality.innerHTML = '<option value="">default</option>';
      return;
    }
    opts.forEach(function (o) {
      var opt = document.createElement('option');
      opt.value = o.plan;
      var res = o.resolution ? (' · ' + o.resolution) : '';
      var fps = o.fps ? (' · ' + o.fps + 'fps') : '';
      opt.textContent = (o.label || o.plan) + res + fps + (o.branded ? '' : ' · unbranded');
      if (o['default']) opt.selected = true;
      el.quality.appendChild(opt);
    });
  }

  function showPlanInfo(info) {
    if (!el.planInfo) return;
    if (info.daily_limit == null) { el.planInfo.textContent = ''; return; }
    el.planInfo.textContent = (info.label || plan) + ' · ' +
      (info.daily_remaining != null ? info.daily_remaining : '?') + '/' +
      info.daily_limit + ' today';
    // gate Render when the account is out of daily/monthly quota
    atLimit = (info.daily_remaining != null && info.daily_remaining <= 0) ||
              (info.monthly_remaining != null && info.monthly_remaining <= 0);
    updateRunState();
  }

  // ── render loop ────────────────────────────────────────────────
  async function render() {
    if (!activeName) return;
    stopPolling();
    clearOutput();
    var dsl = models[activeName].getValue();
    if (!dsl.trim()) { toast('nothing to render'); return; }

    // Hard pre-flight: run the WASM checker RIGHT NOW, straight from the DSL,
    // independent of the marker/listener pipeline. This is the authoritative
    // gate — the server is never hit while there are errors.
    var errs = checkNow(dsl);
    if (errs.length) {
      hasError = true;
      updateRunState();
      var f = errs[0];
      setStatus(errs.length + (errs.length === 1 ? ' error' : ' errors') +
        ' · ' + f.message + (f.line ? ' (line ' + f.line + ')' : ''), true);
      errShown = true;
      toast('fix the ' + (errs.length === 1 ? 'error' : 'errors') + ' in your file first');
      return;
    }
    if (atLimit) { toast('render limit reached — upgrade or try again tomorrow'); return; }
    setRunning(true);
    setStatus('submitting…');

    // plan + userid are injected server-side by the servlet from the login/
    // subscription — the client only chooses the render tier (preset).
    var body = {
      dsl: dsl,
      file_name: activeName,
      identifier: activeName.replace(/\.manic$/, '')
    };
    var preset = el.quality ? el.quality.value : '';
    if (preset) body.preset = preset;

    var r;
    try { r = await api('submit', { method: 'POST', body: body }); }
    catch (e) { setRunning(false); setStatus('network error', true); return; }

    if (r.status === 202 && r.json && r.json.job_id) {
      if (r.json.user_id) userId = r.json.user_id;
      setStatus('queued (job #' + r.json.job_id + ')…');
      pollJob(r.json.job_id);
      return;
    }
    setRunning(false);
    handleApiError(r);
  }

  function pollJob(id) {
    currentJobId = id;
    var tick = async function () {
      if (currentJobId !== id) return;
      var r;
      try { r = await api('job', { query: '&id=' + id }); }
      catch (e) { setStatus('poll failed; retrying…'); pollTimer = setTimeout(tick, 2000); return; }

      if (r.status !== 200) { setRunning(false); handleApiError(r); return; }
      var job = r.json || {};
      if (job.status === 'done') {
        setRunning(false);
        showVideo(job);
        setStatus('done ✓');
        loadLimits();
      } else if (job.status === 'failed') {
        setRunning(false);
        showError('render_failed', job.error || 'render failed', {});
        setStatus('failed', true);
      } else {
        setStatus(job.status + '…');
        pollTimer = setTimeout(tick, 1500);
      }
    };
    tick();
  }

  function stopPolling() {
    currentJobId = null;
    if (pollTimer) { clearTimeout(pollTimer); pollTimer = null; }
  }

  // ── output rendering ───────────────────────────────────────────
  function clearOutput() {
    if (el.errorBox) { el.errorBox.style.display = 'none'; el.errorBox.textContent = ''; }
    if (el.videoWrap) el.videoWrap.style.display = 'none';
    if (el.sourceLink) el.sourceLink.style.display = 'none';
    if (el.placeholder) el.placeholder.style.display = 'none';
    if (el.video) { try { el.video.pause(); } catch (e) {} el.video.removeAttribute('src'); el.video.load(); }
  }

  function showVideo(job) {
    if (job.video && job.video.signed_url && el.video) {
      el.video.src = job.video.signed_url;
      el.videoWrap.style.display = 'block';
      el.video.load();
    }
    if (job.source && job.source.signed_url && el.sourceLink) {
      el.sourceLink.href = job.source.signed_url;
      el.sourceLink.style.display = 'inline';
    }
  }

  function showError(code, message, details) {
    if (!el.errorBox) { toast(message); return; }
    el.errorBox.style.display = 'block';
    el.errorBox.textContent = message + (code ? ' (' + code + ')' : '');
  }

  // ── API error catalog (MANIC_API.md) ───────────────────────────
  function handleApiError(r) {
    var j = r.json || {};
    var code = j.code || 'error';
    var msg = j.message || ('request failed (' + r.status + ')');
    var d = j.details || {};
    switch (code) {
      case 'render_in_progress':
        setStatus('already rendering job #' + d.job_id + '…');
        if (d.job_id) { setRunning(true); pollJob(d.job_id); return; }
        break;
      case 'render_limit_exceeded':
        toast('render limit reached for ' + (d.plan || plan));
        loadLimits();
        break;
      case 'preset_not_allowed':
        toast('that quality needs a higher plan');
        loadLimits();
        break;
      case 'render_queue_full':
        toast('busy — retrying shortly'); setTimeout(render, 3000); return;
    }
    showError(code, msg, d);
    setStatus('error', true);
  }

  // ── helpers ────────────────────────────────────────────────────
  function api(action, opts) {
    opts = opts || {};
    var url = SERVLET + '?action=' + encodeURIComponent(action) + (opts.query || '');
    var init = {
      method: opts.method || 'GET',
      headers: { 'X-Browser-Id': browserId, 'Accept': 'application/json' }
    };
    if (opts.body != null) {
      init.headers['Content-Type'] = 'application/json';
      init.body = JSON.stringify(opts.body);
    }
    return fetch(url, init).then(function (res) {
      return res.text().then(function (t) {
        var json = null; try { json = t ? JSON.parse(t) : null; } catch (e) { json = null; }
        return { status: res.status, json: json, text: t };
      });
    });
  }

  // ── diagnostics → Render gating ────────────────────────────────
  // The editor pushes the error count from every check() straight here (no
  // reading markers back out of Monaco — that path was unreliable).
  function wireDiagnostics() {
    if (ME.setDiagnosticsListener) {
      ME.setDiagnosticsListener(function (model, errorCount, firstErr) {
        var forActive = !editor || model === editor.getModel();
        console.log('[manic] diag listener: errorCount=' + errorCount + ' forActiveFile=' + forActive);
        // only gate on the file currently shown in the editor
        if (!forActive) return;
        applyDiag(errorCount || 0, firstErr);
      });
    } else {
      console.warn('[manic] ME.setDiagnosticsListener missing — Render won\'t auto-disable (stale JS?)');
    }
  }

  function applyDiag(errorCount, firstErr) {
    hasError = errorCount > 0;
    updateRunState();
    if (hasError) {
      var at = firstErr && firstErr.line ? (' (line ' + firstErr.line + ')') : '';
      var msg = firstErr && firstErr.message ? (' · ' + firstErr.message) : '';
      setStatus(errorCount + (errorCount === 1 ? ' error' : ' errors') + msg + at, true);
      errShown = true;
    } else if (errShown && !running && !currentJobId) {
      setStatus('ready');
      errShown = false;
    }
  }

  // Force a re-check of the visible file (fires the listener above).
  function refreshDiagnosticsState() {
    if (ME.refreshMarkers && editor && editor.getModel()) ME.refreshMarkers(editor.getModel());
  }

  // Direct, synchronous WASM check of the given DSL → array of error diagnostics.
  // Does NOT depend on Monaco markers or the reactive listener.
  function checkNow(dsl) {
    if (!ME.wasm || typeof ME.wasm.check !== 'function') {
      console.warn('[manic] checkNow: wasm.check not available');
      return [];
    }
    var raw;
    try { raw = JSON.parse(ME.wasm.check(dsl)); }
    catch (e) { console.warn('[manic] checkNow: check() threw', e); return []; }
    var out = [];
    for (var i = 0; i < raw.length; i++) {
      if (raw[i].severity !== 'warning') {
        out.push({ message: raw[i].message || 'error', line: lineOf(dsl, raw[i].start || 0) });
      }
    }
    console.log('[manic] checkNow →', out.length, 'error(s)', out);
    return out;
  }
  function lineOf(text, off) {
    var n = 1;
    for (var i = 0; i < off && i < text.length; i++) if (text.charCodeAt(i) === 10) n++;
    return n;
  }

  function updateRunState() {
    if (!el.run) { console.warn('[manic] updateRunState: #run-btn not found'); return; }
    el.run.disabled = running || atLimit || hasError;
    console.log('[manic] updateRunState → disabled=' + el.run.disabled +
      ' {running:' + running + ', atLimit:' + atLimit + ', hasError:' + hasError + '}');
    el.run.classList.toggle('busy', running);
    el.run.textContent = running ? 'Rendering…' : 'Render';
    el.run.title = hasError ? 'Fix the errors in your file to render'
      : atLimit ? 'Daily / monthly render limit reached'
      : 'Render (⌘/Ctrl+Enter)';
  }

  function setRunning(on) {
    running = on;
    updateRunState();
  }

  function setStatus(msg, isErr) {
    if (!el.status) return;
    el.status.textContent = msg;
    el.status.classList.toggle('err', !!isErr);
  }

  var toastTimer = null;
  function toast(msg) {
    if (!el.toast) return;
    el.toast.textContent = msg;
    el.toast.classList.add('show');
    if (toastTimer) clearTimeout(toastTimer);
    toastTimer = setTimeout(function () { el.toast.classList.remove('show'); }, 2400);
  }
})();
