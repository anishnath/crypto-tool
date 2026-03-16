/**
 * math-api.js — Documents API client via CFExamMarkerFunctionality
 * Uses window.ME_CTX (context path) from editor/dashboard JSP
 */
(function () {
  'use strict';

  var CTX = typeof window !== 'undefined' && window.ME_CTX ? window.ME_CTX : '';

  function apiUrl(path, params) {
    var url = CTX + '/CFExamMarkerFunctionality?action=proxy&path=' + encodeURIComponent(path);
    if (params && Object.keys(params).length) {
      var q = Object.keys(params).map(function (k) {
        return encodeURIComponent(k) + '=' + encodeURIComponent(params[k]);
      }).join('&');
      url += '&' + q;
    }
    return url;
  }

  function headers(editToken, userId) {
    var h = { 'Content-Type': 'application/json' };
    if (editToken) h['X-Edit-Token'] = editToken;
    if (userId) h['X-User-Id'] = userId;
    return h;
  }

  /**
   * GET /api/documents — list (public when no user; user's docs when logged in)
   */
  function listDocuments(opts) {
    opts = opts || {};
    var params = {};
    if (opts.limit) params.limit = opts.limit;
    if (opts.offset) params.offset = opts.offset;
    if (opts.sort) params.sort = opts.sort;
    if (opts.doc_type) params.doc_type = opts.doc_type;
    if (opts.user_id) params.user_id = opts.user_id;
    var url = apiUrl('/api/documents', params);
    return fetch(url, {
      method: 'GET',
      headers: headers(null, opts.user_id),
      credentials: 'include'
    });
  }

  /**
   * GET /api/documents/:id
   */
  function getDocument(id, opts) {
    opts = opts || {};
    return fetch(apiUrl('/api/documents/' + id), {
      method: 'GET',
      headers: headers(opts.editToken, opts.userId),
      credentials: 'include'
    });
  }

  /**
   * POST /api/documents — create
   */
  function createDocument(body, opts) {
    opts = opts || {};
    return fetch(apiUrl('/api/documents'), {
      method: 'POST',
      headers: headers(null, opts.userId),
      credentials: 'include',
      body: JSON.stringify(body)
    });
  }

  /**
   * PUT /api/documents/:id — update (claim flow when anonymous + userId)
   */
  function updateDocument(id, body, opts) {
    opts = opts || {};
    return fetch(apiUrl('/api/documents/' + id), {
      method: 'PUT',
      headers: headers(opts.editToken, opts.userId),
      credentials: 'include',
      body: JSON.stringify(body)
    });
  }

  /**
   * DELETE /api/documents/:id
   */
  function deleteDocument(id, opts) {
    opts = opts || {};
    return fetch(apiUrl('/api/documents/' + id), {
      method: 'DELETE',
      headers: headers(opts.editToken, opts.userId),
      credentials: 'include'
    });
  }

  /**
   * Check session — for login status
   */
  function checkSession() {
    return fetch(CTX + '/GoogleOAuthFunctionality?action=check_session', {
      method: 'GET',
      credentials: 'include'
    }).then(function (r) { return r.json(); });
  }

  window.MathAPI = {
    list: listDocuments,
    get: getDocument,
    create: createDocument,
    update: updateDocument,
    delete: deleteDocument,
    checkSession: checkSession,
    getCtx: function () { return CTX; }
  };
})();
