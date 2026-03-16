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

  function getVisibility() {
    var state = window.MeDocState || {};
    var v = state.visibility;
    return (v === 'public' || v === 'unlisted' || v === 'private') ? v : 'private';
  }

  function setVisibility(value) {
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
    menu.querySelectorAll('.me-visibility-item').forEach(function (item) {
      item.classList.toggle('active', item.getAttribute('data-visibility') === v);
    });
  }

  function init() {
    var btn = document.getElementById('me-btn-visibility');
    var menu = document.getElementById('me-visibility-menu');
    if (!btn || !menu) return;

    if (!window.MeDocState) window.MeDocState = {};
    if (!window.MeDocState.visibility) window.MeDocState.visibility = 'private';
    var visWrap = btn.closest('.me-visibility-dropdown');
    if (visWrap && window.MeDocState.canEdit === false) visWrap.style.display = 'none';
    updateUI();

    btn.addEventListener('click', function (e) {
      e.stopPropagation();
      var wrap = btn.closest('.me-visibility-dropdown');
      wrap.classList.toggle('open');
    });

    menu.querySelectorAll('.me-visibility-item').forEach(function (item) {
      item.addEventListener('click', function (e) {
        e.stopPropagation();
        var v = item.getAttribute('data-visibility');
        if (v) setVisibility(v);
        btn.closest('.me-visibility-dropdown').classList.remove('open');
      });
    });

    document.addEventListener('click', function () {
      btn.closest('.me-visibility-dropdown').classList.remove('open');
    });
  }

  document.addEventListener('me:editor-ready', init);
  document.addEventListener('me:doc-loaded', updateUI);
})();
