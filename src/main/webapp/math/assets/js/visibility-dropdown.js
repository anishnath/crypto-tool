/**
 * visibility-dropdown.js — Document visibility selector (private / unlisted / public)
 * Updates MeDocState.visibility and triggers save via MeAutosave
 */
(function () {
  'use strict';

  var LABELS = {
    private: 'Private',
    unlisted: 'Unlisted',
    public: 'Public'
  };

  var CONFIRM_MESSAGES = {
    public: 'Make this document public? Anyone will be able to find it.',
    unlisted: 'Make this document unlisted? Anyone with the link can view it.'
  };

  function getVisibility() {
    var state = window.MeDocState || {};
    var v = state.visibility;
    return (v === 'public' || v === 'unlisted' || v === 'private') ? v : 'private';
  }

  function setVisibility(value) {
    var current = getVisibility();

    // Confirmation when changing from private to public/unlisted (MAJOR 2.7)
    if (current === 'private' && (value === 'public' || value === 'unlisted')) {
      if (!confirm(CONFIRM_MESSAGES[value])) return;
    }

    window.MeDocState = window.MeDocState || {};
    window.MeDocState.visibility = value;
    updateUI();
    if (window.MeAutosave && window.MeAutosave.save) {
      window.MeAutosave.save();
    }
  }

  function updateUI() {
    var btn = document.getElementById('me-btn-visibility');
    var menu = document.getElementById('me-visibility-menu');
    if (!btn || !menu) return;
    var v = getVisibility();
    var label = btn.querySelector('.me-visibility-label');
    if (label) label.textContent = LABELS[v];

    var wrap = btn.closest('.me-visibility-dropdown');
    var isOpen = wrap && wrap.classList.contains('open');

    // Update aria-expanded (MAJOR 9.5)
    btn.setAttribute('aria-expanded', isOpen ? 'true' : 'false');

    menu.querySelectorAll('.me-visibility-item').forEach(function (item) {
      item.classList.toggle('active', item.getAttribute('data-visibility') === v);
    });
  }

  function closeDropdown(btn) {
    var wrap = btn.closest('.me-visibility-dropdown');
    if (wrap) wrap.classList.remove('open');
    btn.setAttribute('aria-expanded', 'false');
  }

  function openDropdown(btn) {
    var wrap = btn.closest('.me-visibility-dropdown');
    if (wrap) wrap.classList.add('open');
    btn.setAttribute('aria-expanded', 'true');
    // Focus the first menu item
    var menu = document.getElementById('me-visibility-menu');
    if (menu) {
      var firstItem = menu.querySelector('.me-visibility-item');
      if (firstItem) firstItem.focus();
    }
  }

  function init() {
    var btn = document.getElementById('me-btn-visibility');
    var menu = document.getElementById('me-visibility-menu');
    if (!btn || !menu) return;

    if (!window.MeDocState) window.MeDocState = {};
    if (!window.MeDocState.visibility) window.MeDocState.visibility = 'private';
    var visWrap = btn.closest('.me-visibility-dropdown');
    if (visWrap && window.MeDocState.canEdit === false) visWrap.style.display = 'none';

    // ARIA attributes (MAJOR 9.5)
    btn.setAttribute('aria-haspopup', 'listbox');
    btn.setAttribute('aria-expanded', 'false');
    menu.setAttribute('role', 'listbox');
    menu.querySelectorAll('.me-visibility-item').forEach(function (item) {
      item.setAttribute('role', 'option');
      item.setAttribute('tabindex', '-1');
    });

    updateUI();

    btn.addEventListener('click', function (e) {
      e.stopPropagation();
      var wrap = btn.closest('.me-visibility-dropdown');
      if (wrap.classList.contains('open')) {
        closeDropdown(btn);
      } else {
        openDropdown(btn);
      }
    });

    // Keyboard navigation on the toggle button (MAJOR 9.5)
    btn.addEventListener('keydown', function (e) {
      var wrap = btn.closest('.me-visibility-dropdown');
      var isOpen = wrap && wrap.classList.contains('open');

      if (e.key === 'Enter' || e.key === ' ') {
        e.preventDefault();
        e.stopPropagation();
        if (isOpen) {
          closeDropdown(btn);
        } else {
          openDropdown(btn);
        }
        return;
      }
      if (e.key === 'Escape' && isOpen) {
        e.preventDefault();
        e.stopPropagation();
        closeDropdown(btn);
        btn.focus();
        return;
      }
      if ((e.key === 'ArrowDown' || e.key === 'ArrowUp') && !isOpen) {
        e.preventDefault();
        e.stopPropagation();
        openDropdown(btn);
        return;
      }
    });

    // Keyboard navigation within menu items (MAJOR 9.5)
    menu.addEventListener('keydown', function (e) {
      var items = Array.prototype.slice.call(menu.querySelectorAll('.me-visibility-item'));
      var current = document.activeElement;
      var idx = items.indexOf(current);

      if (e.key === 'ArrowDown') {
        e.preventDefault();
        e.stopPropagation();
        var next = (idx + 1) % items.length;
        items[next].focus();
        return;
      }
      if (e.key === 'ArrowUp') {
        e.preventDefault();
        e.stopPropagation();
        var prev = (idx - 1 + items.length) % items.length;
        items[prev].focus();
        return;
      }
      if (e.key === 'Enter' || e.key === ' ') {
        e.preventDefault();
        e.stopPropagation();
        if (current && current.classList.contains('me-visibility-item')) {
          var v = current.getAttribute('data-visibility');
          if (v) setVisibility(v);
          closeDropdown(btn);
          btn.focus();
        }
        return;
      }
      if (e.key === 'Escape') {
        e.preventDefault();
        e.stopPropagation();
        closeDropdown(btn);
        btn.focus();
        return;
      }
    });

    menu.querySelectorAll('.me-visibility-item').forEach(function (item) {
      item.addEventListener('click', function (e) {
        e.stopPropagation();
        var v = item.getAttribute('data-visibility');
        if (v) setVisibility(v);
        closeDropdown(btn);
      });
    });

    document.addEventListener('click', function () {
      closeDropdown(btn);
    });
  }

  document.addEventListener('me:editor-ready', init);
  document.addEventListener('me:doc-loaded', updateUI);
})();
