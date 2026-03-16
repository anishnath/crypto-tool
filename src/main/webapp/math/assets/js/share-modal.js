/**
 * share-modal.js — Share document: copy view link / edit link (with token)
 * Edit link gives full edit access — share only with people you trust
 */
(function () {
  'use strict';

  function getBaseUrl() {
    return window.location.origin + (window.ME_CTX || '');
  }

  function openModal() {
    var overlay = document.getElementById('me-share-overlay');
    var noId = document.getElementById('me-share-no-id');
    var links = document.getElementById('me-share-links');
    var editRow = document.getElementById('me-share-edit-row');
    var viewInput = document.getElementById('me-share-view-url');
    var editInput = document.getElementById('me-share-edit-url');

    if (!overlay || !noId || !links) return;

    var state = window.MeDocState || {};
    var id = state.id || (new URLSearchParams(window.location.search).get('id'));
    var token = state.editToken || sessionStorage.getItem('me_edit_token_' + id);

    if (!id) {
      noId.style.display = 'block';
      links.style.display = 'none';
    } else {
      noId.style.display = 'none';
      links.style.display = 'block';
      var base = getBaseUrl() + '/math/editor.jsp';
      var viewUrl = base + '?id=' + encodeURIComponent(id);
      viewInput.value = viewUrl;
      if (token) {
        editRow.style.display = 'block';
        editInput.value = base + '?id=' + encodeURIComponent(id) + '&token=' + encodeURIComponent(token);
      } else {
        editRow.style.display = 'none';
      }
    }
    overlay.style.display = 'flex';
  }

  function closeModal() {
    var overlay = document.getElementById('me-share-overlay');
    if (overlay) overlay.style.display = 'none';
  }

  function copyToClipboard(text, btn) {
    if (!navigator.clipboard) {
      var input = document.createElement('input');
      input.value = text;
      document.body.appendChild(input);
      input.select();
      document.execCommand('copy');
      document.body.removeChild(input);
    } else {
      navigator.clipboard.writeText(text);
    }
    var orig = btn.textContent;
    btn.textContent = 'Copied!';
    setTimeout(function () { btn.textContent = orig; }, 2000);
  }

  function init() {
    var shareBtn = document.querySelector('.me-btn-share');
    var closeBtn = document.getElementById('me-share-close');
    var overlay = document.getElementById('me-share-overlay');

    if (shareBtn) shareBtn.addEventListener('click', openModal);
    if (closeBtn) closeBtn.addEventListener('click', closeModal);
    if (overlay) {
      overlay.addEventListener('click', function (e) {
        if (e.target === overlay) closeModal();
      });
    }

    document.addEventListener('click', function (e) {
      var btn = e.target.closest('.me-btn-copy');
      if (!btn) return;
      var which = btn.getAttribute('data-copy');
      var input = which === 'view' ? document.getElementById('me-share-view-url') : document.getElementById('me-share-edit-url');
      if (input && input.value) copyToClipboard(input.value, btn);
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
