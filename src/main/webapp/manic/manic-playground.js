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
  var lastVideoUrl = null;   // signed URL of the most recent rendered mp4
  var theme = localStorage.getItem(LS_THEME) || 'dark';

  // ── DOM ────────────────────────────────────────────────────────
  var $ = function (id) { return document.getElementById(id); };
  var el = {};

  document.addEventListener('DOMContentLoaded', function () {
    el = {
      editor: $('manic-editor'), fileList: $('file-list'), newFile: $('new-file-btn'),
      run: $('run-btn'), quality: $('quality-select'), planInfo: $('plan-info'),
      themeBtn: $('theme-btn'), status: $('status-line'), video: $('result-video'),
      videoWrap: $('video-wrap'), errorBox: $('error-box'), downloadBtn: $('download-btn'),
      toast: $('toast'), placeholder: $('output-placeholder'),
      examplesBtn: $('examples-btn'), examplesOverlay: $('examples-overlay'),
      examplesBody: $('examples-body'), examplesClose: $('examples-close'),
      welcomeOverlay: $('welcome-overlay'), welcomeClose: $('welcome-close'),
      welcomeStart: $('welcome-start'), welcomeExamples: $('welcome-examples'),
      helpBtn: $('help-btn'),
      renderOverlay: $('render-overlay'), renderStatus: $('render-status'),
      renderBar: $('render-bar'), renderElapsed: $('render-elapsed'),
      renderRemaining: $('render-remaining'), renderTip: $('render-tip'),
      renderHide: $('render-hide'),
      errPanel: $('editor-errors'), errCount: $('editor-errors-count'), errList: $('editor-errors-list'),
      btnShare: $('btn-share'),
      shareOverlay: $('share-overlay'), shareClose: $('share-close'),
      shareUrl: $('share-url'), shareCopy: $('share-copy'), shareSocial: $('share-social')
    };
    if (el.renderHide) el.renderHide.onclick = hideRenderModal;
    if (el.btnShare) el.btnShare.onclick = shareCurrent;
    if (el.shareClose) el.shareClose.onclick = closeShareModal;
    if (el.shareOverlay) el.shareOverlay.addEventListener('click', function (e) {
      if (e.target === el.shareOverlay) closeShareModal();
    });
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
    maybeLoadShared();   // if the URL has ?s=<id>, open that shared file
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
    if (el.downloadBtn) el.downloadBtn.onclick = downloadVideo;
    if (el.examplesBtn) el.examplesBtn.onclick = openExamples;
    if (el.examplesClose) el.examplesClose.onclick = closeExamples;
    if (el.examplesOverlay) el.examplesOverlay.addEventListener('click', function (e) {
      if (e.target === el.examplesOverlay) closeExamples();
    });
    document.addEventListener('keydown', function (e) {
      if (e.key !== 'Escape') return;
      if (el.shareOverlay && el.shareOverlay.classList.contains('show')) closeShareModal();
      else if (el.renderOverlay && el.renderOverlay.classList.contains('show')) hideRenderModal();
      else if (el.examplesOverlay && el.examplesOverlay.classList.contains('show')) closeExamples();
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

  // ── share: store the open file as a snippet, get a ?s=<id> link ──
  // Reuses the OneCompiler snippet servlet (a generic { language, code, title }
  // store) — the same call code-playground uses. Shares only the active file.
  async function shareCurrent() {
    if (!activeName || !models[activeName]) return;
    var code = models[activeName].getValue();
    if (!code.trim()) { toast('nothing to share yet'); return; }
    toast('creating a share link…');
    try {
      var res = await fetch(CFG.ctx + '/OneCompilerFunctionality?action=snippet_create', {
        method: 'POST', headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ language: 'manic', code: code, title: activeName })
      });
      var data = null; try { data = await res.json(); } catch (e) {}
      if (!res.ok || !data || !data.id) throw new Error('no id');
      var url = location.origin + location.pathname + '?s=' + encodeURIComponent(data.id);
      openShareModal(url);
    } catch (e) { toast('could not create a share link'); }
  }

  // Share modal: the link + copy, plus one-click posting to each network.
  var SHARE_TITLE = 'A manic animation';
  var SHARE_TEXT = 'I made this animation with manic — text to video. ✨';
  function enc(s) { return encodeURIComponent(s); }
  var SHARE_NETS = [
    { label: 'X', color: '#1d9bf0', href: function (u) { return 'https://twitter.com/intent/tweet?text=' + enc(SHARE_TEXT) + '&url=' + enc(u); } },
    { label: 'LinkedIn', color: '#0a66c2', href: function (u) { return 'https://www.linkedin.com/sharing/share-offsite/?url=' + enc(u); } },
    { label: 'Reddit', color: '#ff4500', href: function (u) { return 'https://www.reddit.com/submit?url=' + enc(u) + '&title=' + enc(SHARE_TITLE); } },
    { label: 'Facebook', color: '#1877f2', href: function (u) { return 'https://www.facebook.com/sharer/sharer.php?u=' + enc(u); } },
    { label: 'WhatsApp', color: '#25d366', href: function (u) { return 'https://wa.me/?text=' + enc(SHARE_TEXT + ' ' + u); } },
    { label: 'Telegram', color: '#2aabee', href: function (u) { return 'https://t.me/share/url?url=' + enc(u) + '&text=' + enc(SHARE_TEXT); } },
    { label: 'Email', color: '#8b86b0', href: function (u) { return 'mailto:?subject=' + enc(SHARE_TITLE) + '&body=' + enc(SHARE_TEXT + '\n\n' + u); } }
  ];
  function openShareModal(url) {
    if (!el.shareOverlay) { copyShareLink(url); return; }   // fallback if markup absent
    if (el.shareUrl) el.shareUrl.value = url;
    if (el.shareCopy) el.shareCopy.onclick = function () { copyShareLink(url); };
    if (el.shareSocial) {
      el.shareSocial.innerHTML = '';
      // OS share sheet (mobile) first, when the browser supports it
      if (navigator.share) {
        var nb = document.createElement('button');
        nb.className = 'mp-share-net'; nb.style.background = 'var(--cyan)'; nb.style.color = '#04121a';
        nb.innerHTML = '<span class="mp-share-dot"></span>Share…';
        nb.onclick = function () { navigator.share({ title: SHARE_TITLE, text: SHARE_TEXT, url: url }).catch(function () {}); };
        el.shareSocial.appendChild(nb);
      }
      SHARE_NETS.forEach(function (n) {
        var b = document.createElement('button');
        b.className = 'mp-share-net'; b.style.background = n.color;
        b.innerHTML = '<span class="mp-share-dot"></span>' + n.label;
        b.onclick = function () { window.open(n.href(url), '_blank', 'noopener,noreferrer,width=640,height=620'); };
        el.shareSocial.appendChild(b);
      });
    }
    el.shareOverlay.classList.add('show');
    if (el.shareUrl) { el.shareUrl.focus(); el.shareUrl.select(); }
  }
  function closeShareModal() { if (el.shareOverlay) el.shareOverlay.classList.remove('show'); }
  function copyShareLink(url) {
    var msg = 'Share link copied — anyone can open this file';
    if (window.ToolUtils && ToolUtils.copyToClipboard) {
      ToolUtils.copyToClipboard(url, { toastMessage: msg, toolName: 'manic' }); return;
    }
    if (navigator.clipboard && navigator.clipboard.writeText) {
      navigator.clipboard.writeText(url).then(function () { toast(msg); },
        function () { toast('Copy failed — link: ' + url); });
    } else { toast('Share link: ' + url); }
  }
  // On load, if the URL has ?s=<id>, fetch that snippet and open it as a file.
  function maybeLoadShared() {
    var m = /[?&]s=([^&]+)/.exec(location.search);
    if (!m) return;
    var id = decodeURIComponent(m[1]);
    setStatus('loading shared file…');
    fetch(CFG.ctx + '/OneCompilerFunctionality?action=snippet_get&id=' + encodeURIComponent(id))
      .then(function (r) { return r.ok ? r.json() : Promise.reject(); })
      .then(function (data) {
        var code = data.code ||
          (data.files && data.files[0] && (data.files[0].content || data.files[0].code)) || '';
        if (!code) throw new Error('empty');
        var base = (data.title && /\.manic$/.test(data.title)) ? data.title : 'shared.manic';
        var name = base, i = 2;
        while (models[name]) { name = base.replace(/\.manic$/, '') + '-' + i + '.manic'; i++; }
        addModel(name, code);
        switchFile(name);
        renderFileRail();
        setStatus('ready');
        toast('opened shared file');
      })
      .catch(function () { setStatus('ready'); toast('could not open that shared link'); });
  }

  // ── bridge for the AI assistant (manic-ai.js) ─────────────────
  function exposeBridge() {
    window.manicBridge = {
      getCode: function () {
        return (activeName && models[activeName]) ? models[activeName].getValue() : '';
      },
      setCode: function (code) {
        if (!activeName || !models[activeName]) return;
        var src = String(code == null ? '' : code);
        // Auto-correct the AI's mechanical slips (glued `*`, nearest name) before
        // it lands in the editor — the model needn't get every char right.
        var res = (ME.autofix ? ME.autofix(src) : { code: src, fixed: 0 });
        // Always apply — auto-fix is best-effort, not a gate. Whatever it can't
        // mechanically repair lands in the editor and shows as live diagnostics
        // for the user (or the AI assistant) to fix the normal way.
        models[activeName].setValue(res.code);
        persistFiles();
        var remaining = 0;
        try {
          remaining = (JSON.parse(ME.wasm.check(res.code)) || [])
            .filter(function (e) { return e.severity !== 'warning'; }).length;
        } catch (e) { /* check unavailable — leave the editor's own markers to speak */ }
        if (res.fixed > 0 && remaining > 0) {
          toast('auto-corrected ' + res.fixed + ', ' + remaining + ' left to fix');
        } else if (res.fixed > 0) {
          toast('auto-corrected ' + res.fixed + ' issue' + (res.fixed > 1 ? 's' : ''));
        } else if (remaining > 0) {
          toast(remaining + ' issue' + (remaining > 1 ? 's' : '') + ' to fix — see the editor');
        }
        if (editor) editor.focus();
      },
      fileName: function () { return activeName || ''; },
      // Error diagnostics for the active file (same WASM check the editor runs)
      // → [{ message, line }]. Lets the AI assistant fix the real errors.
      diagnostics: function () {
        var code = (activeName && models[activeName]) ? models[activeName].getValue() : '';
        return code ? checkNow(code) : [];
      }
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
      catch (e) {
        setStatus('poll failed; retrying…');
        setRenderStatus('connection hiccup — retrying…');
        pollTimer = setTimeout(tick, 5000); return;   // quick retry on a transient failure
      }

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
        setRenderStatus(friendlyStatus(job.status));
        // check the backend every ~10s — long enough not to hammer it, short
        // enough that a finished job shows up quickly.
        pollTimer = setTimeout(tick, 10000);
      }
    };
    tick();
  }

  function stopPolling() {
    currentJobId = null;
    if (pollTimer) { clearTimeout(pollTimer); pollTimer = null; }
  }

  // ── render progress modal (keeps the wait engaging) ───────────
  var RENDER_ESTIMATE = 210;   // seconds — a render usually takes ~3–4 min
  var RENDER_TIPS = [
    '💡 Press ⌘/Ctrl+Space in the editor for autocomplete.',
    '✨ Ask the AI (top bar) to describe an animation in plain English.',
    '🎬 Every 3D word ends in 3 — cube3, orbit3, morph3.',
    '🔁 One  for i in 0..N { … }  can draw a hundred shapes.',
    '🏷️ Tag shapes, then animate the whole group: flash(dots, cyan).',
    '🌀 morph3 turns a cube into a sphere — or a saddle into a bowl.',
    '📈 plot("sin(x)") graphs any formula on labeled axes.',
    '🧵 thick(id, r) turns a curve into a glowing 3D tube.',
    '🎨 Neon palette by name, or hue(id, degrees) for a gradient.',
    '⏳ Renders are studio quality — worth the little wait.'
  ];
  var renderStart = 0, renderTimer = null, tipTimer = null, tipIdx = 0;

  function fmtClock(sec) {
    var m = Math.floor(sec / 60), s = Math.floor(sec % 60);
    return m + ':' + (s < 10 ? '0' : '') + s;
  }
  function openRenderModal() {
    if (!el.renderOverlay || el.renderOverlay.classList.contains('show')) return;
    renderStart = Date.now();
    tipIdx = Math.floor(Math.random() * RENDER_TIPS.length);
    if (el.renderTip) el.renderTip.textContent = RENDER_TIPS[tipIdx];
    if (el.renderBar) el.renderBar.style.width = '0%';
    el.renderOverlay.classList.add('show');
    clearInterval(renderTimer); clearInterval(tipTimer);
    renderTimer = setInterval(renderModalTick, 1000);
    tipTimer = setInterval(rotateTip, 6000);
    renderModalTick();
  }
  function renderModalTick() {
    var elapsed = (Date.now() - renderStart) / 1000;
    if (el.renderElapsed) el.renderElapsed.textContent = fmtClock(elapsed);
    var left = RENDER_ESTIMATE - elapsed;
    if (el.renderRemaining) {
      el.renderRemaining.textContent = left > 55 ? '~' + Math.ceil(left / 60) + ' min left'
        : left > 8 ? 'less than a minute…' : 'almost there — wrapping up…';
    }
    if (el.renderBar) {
      el.renderBar.style.width = (Math.min(elapsed / RENDER_ESTIMATE, 0.92) * 100).toFixed(1) + '%';
    }
  }
  function rotateTip() {
    if (!el.renderTip) return;
    el.renderTip.style.opacity = '0';
    setTimeout(function () {
      tipIdx = (tipIdx + 1) % RENDER_TIPS.length;
      el.renderTip.textContent = RENDER_TIPS[tipIdx];
      el.renderTip.style.opacity = '1';
    }, 300);
  }
  function stopRenderTimers() {
    clearInterval(renderTimer); renderTimer = null;
    clearInterval(tipTimer); tipTimer = null;
  }
  // Render finished / errored: fill the bar, stop timers, hide.
  function closeRenderModal() {
    stopRenderTimers();
    if (el.renderBar) el.renderBar.style.width = '100%';
    if (el.renderOverlay) el.renderOverlay.classList.remove('show');
  }
  // "Hide" button: dismiss the modal but keep polling in the background.
  function hideRenderModal() {
    stopRenderTimers();
    if (el.renderOverlay) el.renderOverlay.classList.remove('show');
    toast('rendering in the background — the video appears here when ready');
  }
  function setRenderStatus(t) { if (el.renderStatus) el.renderStatus.textContent = t; }
  function friendlyStatus(s) {
    switch (String(s || '').toLowerCase()) {
      case 'queued': case 'pending': return 'In the queue…';
      case 'rendering': case 'running': case 'processing': case 'in_progress': return 'Rendering your frames…';
      case 'encoding': case 'uploading': return 'Encoding the video…';
      default: return (s ? s.charAt(0).toUpperCase() + s.slice(1) : 'Working') + '…';
    }
  }

  // ── output rendering ───────────────────────────────────────────
  function clearOutput() {
    if (el.errorBox) { el.errorBox.style.display = 'none'; el.errorBox.textContent = ''; }
    if (el.errPanel) el.errPanel.classList.remove('show');
    if (el.videoWrap) el.videoWrap.style.display = 'none';
    if (el.placeholder) el.placeholder.style.display = 'none';
    if (el.video) { try { el.video.pause(); } catch (e) {} el.video.removeAttribute('src'); el.video.load(); }
    lastVideoUrl = null;
  }

  function showVideo(job) {
    if (job.video && job.video.signed_url && el.video) {
      lastVideoUrl = job.video.signed_url;
      el.video.src = lastVideoUrl;
      el.videoWrap.style.display = 'block';
      el.video.load();
    }
  }

  // Download the rendered mp4. Tries a blob download (nice filename); if the
  // signed URL blocks fetch (CORS), falls back to opening it in a new tab.
  function downloadVideo() {
    if (!lastVideoUrl) return;
    var fname = (activeName || 'manic').replace(/\.manic$/, '') + '.mp4';
    fetch(lastVideoUrl).then(function (r) {
      if (!r.ok) throw new Error('http ' + r.status);
      return r.blob();
    }).then(function (blob) {
      var obj = URL.createObjectURL(blob);
      var a = document.createElement('a');
      a.href = obj; a.download = fname;
      document.body.appendChild(a); a.click(); a.remove();
      setTimeout(function () { URL.revokeObjectURL(obj); }, 5000);
    }).catch(function () {
      window.open(lastVideoUrl, '_blank');
    });
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
      showErrorPanel();               // spell the errors out up front — no hovering
    } else {
      hideErrorPanel();
      if (errShown && !running && !currentJobId) { setStatus('ready'); errShown = false; }
    }
  }

  // A prominent, always-visible list of the current errors (message + line),
  // each clickable to jump to the offending line. This is the first place a
  // beginner should look — they never have to hunt for a red squiggle.
  function showErrorPanel() {
    if (!el.errPanel || !el.errList) return;
    var code = (activeName && models[activeName]) ? models[activeName].getValue() : '';
    var errs = checkNow(code);
    if (!errs.length) { hideErrorPanel(); return; }
    el.errList.innerHTML = '';
    errs.forEach(function (e) {
      var line = e.line || 1;
      var li = document.createElement('li');
      li.title = 'Go to line ' + line;
      var ln = document.createElement('span'); ln.className = 'mp-err-ln'; ln.textContent = 'line ' + line;
      var m = document.createElement('span'); m.className = 'mp-err-msg'; m.textContent = e.message || 'error';
      li.appendChild(ln); li.appendChild(m);
      li.onclick = function () { jumpToLine(line); };
      el.errList.appendChild(li);
    });
    if (el.errCount) el.errCount.textContent = errs.length + (errs.length === 1 ? ' error' : ' errors');
    el.errPanel.classList.add('show');
    if (el.placeholder) el.placeholder.style.display = 'none';
  }
  function hideErrorPanel() {
    if (el.errPanel) el.errPanel.classList.remove('show');
    // restore the placeholder only if there's no video on screen
    if (el.placeholder && el.videoWrap && el.videoWrap.style.display !== 'block') {
      el.placeholder.style.display = '';
    }
  }
  function jumpToLine(line) {
    if (!editor || !line) return;
    try {
      editor.revealLineInCenter(line);
      editor.setPosition({ lineNumber: line, column: 1 });
      editor.focus();
    } catch (e) {}
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
    // The progress modal tracks the whole render: open while it runs, close
    // (fill the bar) the moment it finishes, fails, or errors.
    if (on) openRenderModal(); else closeRenderModal();
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
