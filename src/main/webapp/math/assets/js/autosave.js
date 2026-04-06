/**
 * autosave.js — Two-tier save strategy
 *   Tier 1: localStorage — debounced 2.5s after last edit (instant, no network)
 *   Tier 2: API          — every 60s at most (protects server at scale)
 * Ctrl+S and beforeunload always trigger an immediate API save.
 */
(function () {
  'use strict';

  var titleInput = document.querySelector('.me-doc-title-input');
  var saveDot = document.querySelector('.me-save-dot');
  var saveStatus = document.querySelector('.me-save-status');

  var localSaveTimeout = null;
  var apiSaveTimeout = null;
  var lastApiSave = 0;
  var dirtyForApi = false;          // true when local save happened but API hasn't synced yet
  var LOCAL_DEBOUNCE_MS = 2500;
  var API_INTERVAL_MS = 60000;      // 1 minute between API calls

  // -- 13.6 fix: cache HTML to avoid re-serializing megabytes of base64 on every tick --
  var _cachedHTML = null;
  var _editorUpdateCounter = 0;
  var _lastSerializedAt = 0;        // counter value when we last called getHTML()

  function getEditorHTML(editor) {
    if (_editorUpdateCounter === _lastSerializedAt && _cachedHTML !== null) {
      return _cachedHTML;
    }
    _cachedHTML = editor.getHTML();
    _lastSerializedAt = _editorUpdateCounter;
    return _cachedHTML;
  }

  function getDocId() {
    var p = new URLSearchParams(window.location.search);
    return p.get('id');
  }

  function getState() {
    return window.MeDocState || {};
  }

  function showStatus(state) {
    if (!saveDot || !saveStatus) return;
    var statusTimer = window._meSaveStatusTimer;
    if (statusTimer) clearTimeout(statusTimer);

    saveDot.classList.remove('saving', 'me-save-error');
    saveStatus.classList.remove('me-status-saving', 'me-status-saved', 'me-status-error');

    switch (state) {
      case 'saving':
        saveDot.classList.add('saving');
        saveStatus.classList.add('me-status-saving');
        setStatusText('Saving...');
        saveStatus.removeAttribute('title');
        break;
      case 'saved':
        saveDot.style.background = '';
        saveStatus.classList.add('me-status-saved');
        setStatusText('Saved');
        // 2.1 fix: explain what "Saved" means
        saveStatus.setAttribute('title', 'Document synced to server');
        window._meSaveStatusTimer = setTimeout(function () {
          saveStatus.classList.add('me-status-faded');
        }, 3000);
        break;
      case 'error':
        saveDot.classList.add('me-save-error');
        saveStatus.classList.add('me-status-error');
        setStatusText('Save failed');
        saveStatus.removeAttribute('title');
        break;
      case 'local':
        saveStatus.classList.add('me-status-saved');
        setStatusText('Saved locally');
        // 2.1 fix: explain what "Saved locally" means
        saveStatus.setAttribute('title', 'Saved in your browser only — not yet synced to server');
        break;
      case 'local-warning':
        // 10.1 fix: localStorage quota exceeded warning
        saveDot.classList.add('me-save-error');
        saveStatus.classList.add('me-status-error');
        setStatusText('Storage full — local save failed');
        saveStatus.setAttribute('title', 'Browser storage is full. Old drafts were cleared. Your work will sync to the server on the next API save.');
        break;
      case 'new':
        // 2.2 fix: brand-new empty document
        saveDot.style.background = '';
        saveStatus.classList.add('me-status-saved');
        setStatusText('New document');
        saveStatus.setAttribute('title', 'Start typing — your work is auto-saved');
        window._meSaveStatusTimer = setTimeout(function () {
          saveStatus.classList.add('me-status-faded');
        }, 3000);
        break;
    }
  }

  function setStatusText(text) {
    saveStatus.classList.remove('me-status-faded');
    var nodes = [];
    saveStatus.childNodes.forEach(function (n) {
      if (n.nodeType === Node.TEXT_NODE) nodes.push(n);
    });
    nodes.forEach(function (n) { n.remove(); });
    saveStatus.appendChild(document.createTextNode(' ' + text));
  }

  function saveToLocalStorage(key, data) {
    try {
      localStorage.setItem(key, JSON.stringify(data));
      return true;
    } catch (e) {
      if (e && (e.name === 'QuotaExceededError' || e.code === 22 || e.code === 1014)) {
        // 10.1 fix: storage full — try to clear old drafts and retry once
        _purgeOldDrafts(key);
        try {
          localStorage.setItem(key, JSON.stringify(data));
          return true;
        } catch (e2) {
          // Still full after purge — warn user
          showStatus('local-warning');
          return false;
        }
      }
      // Non-quota error (e.g. private browsing blocking storage)
      showStatus('local-warning');
      return false;
    }
  }

  /** Remove matheditor drafts other than `keepKey`, oldest first. */
  function _purgeOldDrafts(keepKey) {
    var drafts = [];
    for (var i = 0; i < localStorage.length; i++) {
      var k = localStorage.key(i);
      if (k && k.indexOf('matheditor_doc_') === 0 && k !== keepKey) {
        try {
          var d = JSON.parse(localStorage.getItem(k));
          drafts.push({ key: k, time: d && d.savedAt ? d.savedAt : '' });
        } catch (_) {
          drafts.push({ key: k, time: '' });
        }
      }
    }
    // Sort oldest first
    drafts.sort(function (a, b) { return a.time < b.time ? -1 : a.time > b.time ? 1 : 0; });
    for (var j = 0; j < drafts.length; j++) {
      localStorage.removeItem(drafts[j].key);
    }
  }

  function getVisibility() {
    var v = getState().visibility;
    return (v === 'public' || v === 'unlisted') ? v : 'private';
  }

  // -----------------------------------------------------------
  //  Blank-document check — skip save when editor is empty
  // -----------------------------------------------------------
  function isBlankDocument(title, content) {
    // Strip HTML tags and whitespace to check if content has any real text
    var text = (content || '').replace(/<[^>]*>/g, '').replace(/&nbsp;/g, ' ').trim();
    return text.length < 10;
  }

  // -----------------------------------------------------------
  //  Tier 1: localStorage save (fast, every 2.5s debounce)
  // -----------------------------------------------------------
  function saveLocal() {
    var editor = window.MeEditor;
    if (!editor) return;

    var title = titleInput ? titleInput.value : 'Untitled';
    var content = getEditorHTML(editor); // 13.6 fix: use cached HTML
    var state = getState();
    var docId = state.id || getDocId();

    // Don't save blank new documents to localStorage or server
    if (!docId && isBlankDocument(title, content)) return;

    var ok = saveToLocalStorage('matheditor_doc_' + (docId || 'draft'), {
      version: 2, title: title, content: content,
      savedAt: new Date().toISOString()
    });

    dirtyForApi = true;
    if (ok) showStatus('local');  // 10.1: only show "local" if save actually succeeded
    scheduleApiSave();
  }

  // -----------------------------------------------------------
  //  Tier 2: API save (at most once per API_INTERVAL_MS)
  // -----------------------------------------------------------
  function saveToApi() {
    var editor = window.MeEditor;
    if (!editor) return;
    var state = getState();
    var docId = state.id || getDocId();
    var api = window.MathAPI;
    var canEdit = state.canEdit !== false;

    if (!dirtyForApi) return;

    // View-only — already saved locally, nothing to push
    if (docId && !canEdit) { dirtyForApi = false; return; }

    var title = titleInput ? titleInput.value : 'Untitled';
    var content = getEditorHTML(editor); // 13.6 fix: use cached HTML

    // Don't create a new server document for blank content
    if (!docId && isBlankDocument(title, content)) { dirtyForApi = false; return; }

    var visibility = getVisibility();

    function onSuccess() {
      lastApiSave = Date.now();
      dirtyForApi = false;
      showStatus('saved');
      // Sync local copy with what we just sent
      saveToLocalStorage('matheditor_doc_' + (docId || 'draft'), {
        version: 2, title: title, content: content,
        savedAt: new Date().toISOString()
      });
    }

    function onError() {
      // Already in localStorage — show local status, will retry next cycle
      showStatus('local');
    }

    showStatus('saving');

    if (api) {
      if (docId) {
        api.update(docId, { title: title, content: content, visibility: visibility }, { editToken: state.editToken, userId: state.userId })
          .then(function (r) { if (r.ok) onSuccess(); else onError(); })
          .catch(onError);
      } else {
        api.create({ doc_type: 'math', title: title, content: content, content_type: 'text/html', visibility: visibility }, { userId: state.userId })
          .then(function (r) {
            if (r.ok) {
              return r.json().then(function (data) {
                if (data.success && data.document) {
                  var id = data.document.id;
                  var token = data.document.edit_token;
                  window.MeDocState = { id: id, editToken: token, userId: state.userId, canEdit: true, visibility: visibility };
                  docId = id;
                  if (token) sessionStorage.setItem('me_edit_token_' + id, token);
                  var u = new URL(window.location.href);
                  u.searchParams.set('id', id);
                  window.history.replaceState({}, '', u.pathname + u.search);
                  onSuccess();
                } else onError();
              });
            } else onError();
          })
          .catch(onError);
      }
    } else {
      onError();
    }
  }

  // -----------------------------------------------------------
  //  Scheduling
  // -----------------------------------------------------------
  function scheduleLocalSave() {
    if (localSaveTimeout) clearTimeout(localSaveTimeout);
    localSaveTimeout = setTimeout(function () {
      localSaveTimeout = null;
      saveLocal();
    }, LOCAL_DEBOUNCE_MS);
  }

  function scheduleApiSave() {
    if (apiSaveTimeout) return;   // already scheduled
    var now = Date.now();
    var elapsed = now - lastApiSave;
    var delay = elapsed >= API_INTERVAL_MS ? 0 : API_INTERVAL_MS - elapsed;
    apiSaveTimeout = setTimeout(function () {
      apiSaveTimeout = null;
      saveToApi();
    }, delay);
  }

  // Ctrl+S / beforeunload: flush immediately to API
  function saveNow() {
    if (localSaveTimeout) { clearTimeout(localSaveTimeout); localSaveTimeout = null; }
    saveLocal();
    if (apiSaveTimeout) { clearTimeout(apiSaveTimeout); apiSaveTimeout = null; }
    saveToApi();
  }

  function loadFromStorage() {
    var editor = window.MeEditor;
    if (!editor || !editor.commands) return false;
    var docId = getDocId();
    var key = 'matheditor_doc_' + (docId || 'draft');
    var raw = localStorage.getItem(key);
    if (!raw) return false;
    try {
      var data = JSON.parse(raw);
      if (data.version !== 2) return false;
      if (data.title && titleInput) titleInput.value = data.title;
      if (data.content) editor.commands.setContent(data.content);
      return true;
    } catch (e) {
      return false;
    }
  }

  window.addEventListener('beforeunload', function () { saveNow(); });
  if (titleInput) titleInput.addEventListener('input', scheduleLocalSave);

  document.addEventListener('me:editor-ready', function () {
    var editor = window.MeEditor;
    if (!editor) return;

    // 13.6 fix: bump update counter so we know when to re-serialize
    editor.on('update', function () {
      _editorUpdateCounter++;
      scheduleLocalSave();
    });

    // 2.2 fix: don't show "Saved" on a brand-new empty document
    if (!getDocId()) {
      if (loadFromStorage()) showStatus('local');
      else showStatus('new');
    } else {
      showStatus('saved');
    }
  });

  window.MeAutosave = { save: saveNow, load: loadFromStorage };
})();
