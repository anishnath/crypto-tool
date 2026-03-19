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

  /* ── Error display with specific messages (MAJOR 2.6) ─── */
  function showError(show, options) {
    var el = document.getElementById('me-doc-load-error');
    if (!el) return;
    el.style.display = show ? 'flex' : 'none';
    if (!show) return;

    options = options || {};
    var message = options.message || 'Something went wrong loading this document';
    var showRetry = !!options.retry;

    // Build error content
    var html = '<p style="margin:0 0 8px;font-size:15px;color:#374151;">' + message + '</p>';
    if (showRetry) {
      html += '<button class="me-doc-retry-btn" style="padding:6px 16px;font-size:14px;border:1px solid #d1d5db;border-radius:6px;background:#f9fafb;cursor:pointer;">Try again</button>';
    }
    el.innerHTML = html;

    if (showRetry) {
      var retryBtn = el.querySelector('.me-doc-retry-btn');
      if (retryBtn) {
        retryBtn.addEventListener('click', function () {
          window.location.reload();
        });
      }
    }
  }

  function getErrorInfo(status, isNetworkError) {
    if (isNetworkError) {
      return {
        message: 'Could not connect to the server \u2014 check your internet connection',
        retry: true
      };
    }
    if (status === 404) {
      return {
        message: 'Document not found \u2014 it may have been deleted',
        retry: false
      };
    }
    if (status === 403) {
      return {
        message: 'You don\u2019t have permission to view this document',
        retry: false
      };
    }
    return {
      message: 'Something went wrong loading this document',
      retry: true
    };
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
        var errInfo = getErrorInfo(r.status, false);
        showError(true, errInfo);
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
          showError(true, { message: 'Something went wrong loading this document', retry: true });
        }
      });
    }).catch(function (e) {
      showOverlay(false);
      var errInfo = getErrorInfo(null, true);
      showError(true, errInfo);
      console.warn('Doc load error:', e);
    });
  });
})();
