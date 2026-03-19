/**
 * share-modal.js — Share document: copy view link / edit link (with token)
 * Edit link gives full edit access — share only with people you trust
 */
(function () {
  'use strict';

  function getBaseUrl() {
    return window.location.origin + (window.ME_CTX || '');
  }

  /* ── Focus trap helpers ────────────────────────────────── */
  function getFocusableElements(container) {
    return Array.prototype.slice.call(
      container.querySelectorAll(
        'a[href], button:not([disabled]), input:not([disabled]), select:not([disabled]), textarea:not([disabled]), [tabindex]:not([tabindex="-1"])'
      )
    ).filter(function (el) {
      return el.offsetParent !== null; // visible only
    });
  }

  function trapFocus(e) {
    var overlay = document.getElementById('me-share-overlay');
    if (!overlay || overlay.style.display === 'none') return;
    if (e.key !== 'Tab') return;

    var focusable = getFocusableElements(overlay);
    if (focusable.length === 0) return;

    var first = focusable[0];
    var last = focusable[focusable.length - 1];

    if (e.shiftKey) {
      if (document.activeElement === first) {
        e.preventDefault();
        last.focus();
      }
    } else {
      if (document.activeElement === last) {
        e.preventDefault();
        first.focus();
      }
    }
  }

  function handleEscapeKey(e) {
    if (e.key === 'Escape') {
      var overlay = document.getElementById('me-share-overlay');
      if (overlay && overlay.style.display !== 'none') {
        closeModal();
      }
    }
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

    // ARIA attributes for dialog role (MAJOR 9.6)
    overlay.setAttribute('role', 'dialog');
    overlay.setAttribute('aria-modal', 'true');
    var titleEl = overlay.querySelector('.me-share-title, h2, h3');
    if (titleEl) {
      if (!titleEl.id) titleEl.id = 'me-share-modal-title';
      overlay.setAttribute('aria-labelledby', titleEl.id);
    }

    overlay.style.display = 'flex';

    // Focus trap: focus first focusable element (MAJOR 7.3)
    document.addEventListener('keydown', trapFocus);
    document.addEventListener('keydown', handleEscapeKey);
    requestAnimationFrame(function () {
      var focusable = getFocusableElements(overlay);
      if (focusable.length > 0) focusable[0].focus();
    });
  }

  function closeModal() {
    var overlay = document.getElementById('me-share-overlay');
    if (overlay) overlay.style.display = 'none';
    document.removeEventListener('keydown', trapFocus);
    document.removeEventListener('keydown', handleEscapeKey);
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

  /* ── Regenerate link (MAJOR 7.1) ──────────────────────── */
  function regenerateLink() {
    var state = window.MeDocState || {};
    var id = state.id;
    if (!id) return;

    if (window.MathAPI && typeof MathAPI.regenerateEditToken === 'function') {
      MathAPI.regenerateEditToken(id).then(function (r) {
        if (r && r.token) {
          window.MeDocState.editToken = r.token;
          sessionStorage.setItem('me_edit_token_' + id, r.token);
          // Refresh the modal to show the new link
          openModal();
        }
      }).catch(function () {
        alert('Could not regenerate link. To revoke access, change the document visibility to Private.');
      });
    } else {
      alert('To revoke access, change the document visibility to Private.');
    }
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

    // Regenerate link button (MAJOR 7.1)
    document.addEventListener('click', function (e) {
      var btn = e.target.closest('.me-btn-regenerate-link');
      if (btn) regenerateLink();
    });

    // Inject the regenerate button + revoke note into the edit row if it exists
    if (overlay) {
      var editRow = document.getElementById('me-share-edit-row');
      if (editRow && !editRow.querySelector('.me-btn-regenerate-link')) {
        var regenBtn = document.createElement('button');
        regenBtn.className = 'me-btn-regenerate-link';
        regenBtn.textContent = 'Regenerate link';
        regenBtn.title = 'Generate a new edit link, invalidating the old one';
        regenBtn.style.cssText = 'margin-left:8px;padding:4px 10px;font-size:13px;border:1px solid #d1d5db;border-radius:6px;background:#f9fafb;cursor:pointer;';
        editRow.appendChild(regenBtn);

        var note = document.createElement('p');
        note.className = 'me-share-revoke-note';
        note.textContent = 'To revoke access, change the document visibility to Private.';
        note.style.cssText = 'margin-top:6px;font-size:12px;color:#6b7280;';
        editRow.appendChild(note);
      }
    }
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
