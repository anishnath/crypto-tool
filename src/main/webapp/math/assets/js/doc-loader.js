/**
 * doc-loader.js — Load document from API when editor has ?id=xxx
 * Runs on me:editor-ready. Sets window.MeDocState { id, editToken, userId, canEdit }
 */
(function () {
  'use strict';

  function getUrlParams() {
    var p = new URLSearchParams(window.location.search);
    return { id: p.get('id'), token: p.get('token') };
  }

  function showOverlay(show) {
    var el = document.getElementById('me-doc-loading-overlay');
    if (el) el.style.display = show ? 'flex' : 'none';
  }

  function showError(show) {
    var el = document.getElementById('me-doc-load-error');
    if (el) el.style.display = show ? 'flex' : 'none';
  }

  document.addEventListener('me:editor-ready', function () {
    var editor = window.MeEditor;
    var titleInput = document.querySelector('.me-doc-title-input');
    if (!editor || !window.MathAPI) return;

    var params = getUrlParams();
    var docId = params.id;
    var token = params.token || (docId && sessionStorage.getItem('me_edit_token_' + docId));

    if (!docId) {
      window.MeDocState = { id: null, editToken: null, userId: null, canEdit: true, visibility: 'private' };
      return;
    }

    showOverlay(true);
    showError(false);
    window.MeDocState = { id: docId, editToken: token, userId: null, canEdit: false };

    MathAPI.checkSession().then(function (session) {
      if (session && session.logged_in) {
        window.MeDocState.userId = session.user_id || session.user_sub;
      }
      return MathAPI.get(docId, { editToken: token, userId: window.MeDocState.userId });
    }).then(function (r) {
      showOverlay(false);
      if (!r.ok) {
        showError(true);
        console.warn('Failed to load document:', r.status);
        return;
      }
      return r.json().then(function (data) {
        if (data.success && data.document) {
          var doc = data.document;
          window.MeDocState.canEdit = !!(doc.owned_by_me || token);
          window.MeDocState.visibility = (doc.visibility === 'public' || doc.visibility === 'unlisted') ? doc.visibility : 'private';
          var banner = document.getElementById('me-view-only-banner');
          if (banner) banner.style.display = window.MeDocState.canEdit ? 'none' : 'inline-block';
          var visWrap = document.querySelector('.me-visibility-dropdown');
          if (visWrap) visWrap.style.display = window.MeDocState.canEdit ? '' : 'none';
          document.dispatchEvent(new CustomEvent('me:doc-loaded'));
          if (doc.content && editor.commands) {
            editor.commands.setContent(doc.content);
          }
          if (doc.title && titleInput) {
            titleInput.value = doc.title;
          }
          if (params.token) {
            sessionStorage.setItem('me_edit_token_' + docId, params.token);
          }
        } else {
          showError(true);
        }
      });
    }).catch(function (e) {
      showOverlay(false);
      showError(true);
      console.warn('Doc load error:', e);
    });
  });
})();
