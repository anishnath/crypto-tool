/**
 * autosave.js — API-backed save + localStorage fallback
 * Debounced 2.5s, min 15s between API calls
 */
(function () {
  'use strict';

  var titleInput = document.querySelector('.me-doc-title-input');
  var saveDot = document.querySelector('.me-save-dot');
  var saveStatus = document.querySelector('.me-save-status');

  var saveTimeout = null;
  var lastApiSave = 0;
  var DEBOUNCE_MS = 2500;
  var MIN_API_INTERVAL_MS = 15000;

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
        break;
      case 'saved':
        saveDot.style.background = '';
        saveStatus.classList.add('me-status-saved');
        setStatusText('Saved');
        window._meSaveStatusTimer = setTimeout(function () {
          saveStatus.classList.add('me-status-faded');
        }, 3000);
        break;
      case 'error':
        saveDot.classList.add('me-save-error');
        saveStatus.classList.add('me-status-error');
        setStatusText('Save failed');
        break;
      case 'local':
        saveStatus.classList.add('me-status-saved');
        setStatusText('Saved locally');
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
    } catch (e) {}
  }

  function getVisibility() {
    var v = getState().visibility;
    return (v === 'public' || v === 'unlisted') ? v : 'private';
  }

  function save() {
    var editor = window.MeEditor;
    if (!editor) return;

    var title = titleInput ? titleInput.value : 'Untitled';
    var content = editor.getHTML();
    var state = getState();
    var docId = state.id || getDocId();
    var api = window.MathAPI;
    var canEdit = state.canEdit !== false;
    var visibility = getVisibility();

    function onSuccess() {
      lastApiSave = Date.now();
      showStatus('saved');
      saveToLocalStorage('matheditor_doc_' + (docId || 'draft'), { version: 2, title: title, content: content, savedAt: new Date().toISOString() });
    }

    function onError(useLocalMsg) {
      saveToLocalStorage('matheditor_doc_' + (docId || 'draft'), { version: 2, title: title, content: content, savedAt: new Date().toISOString() });
      showStatus(useLocalMsg ? 'local' : 'error');
    }

    if (docId && !canEdit) {
      saveToLocalStorage('matheditor_doc_' + (docId || 'draft'), { version: 2, title: title, content: content, savedAt: new Date().toISOString() });
      showStatus('local');
      return;
    }

    showStatus('saving');

    if (api) {
      if (docId) {
        api.update(docId, { title: title, content: content, visibility: visibility }, { editToken: state.editToken, userId: state.userId })
          .then(function (r) {
            if (r.ok) onSuccess();
            else onError(true);
          })
          .catch(function () { onError(true); });
      } else {
        api.create({ doc_type: 'math', title: title, content: content, content_type: 'text/html', visibility: visibility }, { userId: state.userId })
          .then(function (r) {
            if (r.ok) {
              return r.json().then(function (data) {
                if (data.success && data.document) {
                  var id = data.document.id;
                  var token = data.document.edit_token;
                  window.MeDocState = { id: id, editToken: token, userId: state.userId, canEdit: true, visibility: visibility };
                  if (token) sessionStorage.setItem('me_edit_token_' + id, token);
                  var u = new URL(window.location.href);
                  u.searchParams.set('id', id);
                  window.history.replaceState({}, '', u.pathname + u.search);
                  onSuccess();
              } else onError(true);
            });
          } else onError(true);
        })
        .catch(function () { onError(true); });
      }
    } else {
      onError(true);
    }
  }

  function scheduleSave() {
    if (saveTimeout) clearTimeout(saveTimeout);
    saveTimeout = setTimeout(function () {
      saveTimeout = null;
      var now = Date.now();
      if (lastApiSave && (now - lastApiSave) < MIN_API_INTERVAL_MS) {
        saveTimeout = setTimeout(scheduleSave, MIN_API_INTERVAL_MS - (now - lastApiSave));
        return;
      }
      save();
    }, DEBOUNCE_MS);
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

  window.addEventListener('beforeunload', function () { save(); });
  if (titleInput) titleInput.addEventListener('input', scheduleSave);

  document.addEventListener('me:editor-ready', function () {
    var editor = window.MeEditor;
    if (!editor) return;

    editor.on('update', scheduleSave);

    if (!getDocId()) {
      if (loadFromStorage()) showStatus('saved');
      else showStatus('saved');
    } else {
      showStatus('saved');
    }
  });

  window.MeAutosave = { save: save, load: loadFromStorage };
})();
