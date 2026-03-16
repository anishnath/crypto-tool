/**
 * export-auth.js — Auth check before Export (PDF / LaTeX)
 * Shows login popup when user is not authenticated
 */
(function () {
    'use strict';

    function getLoginUrl() {
        var ctx = window.ME_CTX || '';
        var path = window.location.pathname || '/math/editor.jsp';
        var search = window.location.search || '';
        // redirect_path must be relative to context root (e.g. /math/editor.jsp)
        // OAuth servlet prepends contextPath, so do NOT include context in redirect_path
        if (ctx && path.indexOf(ctx) === 0) {
            path = path.substring(ctx.length) || '/';
        }
        var redirectPath = path + search;
        return ctx + '/GoogleOAuthFunctionality?action=login&redirect_path=' + encodeURIComponent(redirectPath);
    }

    function showExportLoginModal(options) {
        options = options || {};
        var exportType = options.exportType || 'PDF';
        var allowWithoutAccount = options.allowWithoutAccount || false;
        var onExportAnyway = options.onExportAnyway || null;

        var overlay = document.getElementById('me-export-login-overlay');
        if (!overlay) {
            overlay = document.createElement('div');
            overlay.id = 'me-export-login-overlay';
            overlay.className = 'me-share-overlay';
            overlay.innerHTML =
                '<div class="me-share-modal me-export-login-modal" id="me-export-login-modal">' +
                '  <div class="me-share-header">' +
                '    <h3>Login required</h3>' +
                '    <button class="me-share-close" id="me-export-login-close" aria-label="Close">&times;</button>' +
                '  </div>' +
                '  <div class="me-share-body">' +
                '    <p class="me-export-login-msg">Login with Google to export documents.</p>' +
                '    <div class="me-export-login-actions">' +
                '      <a class="me-btn me-btn-primary" id="me-export-login-btn">Login with Google</a>' +
                '      <button class="me-btn me-btn-secondary me-export-anyway-btn" id="me-export-anyway-btn" style="display:none;">Download LaTeX anyway</button>' +
                '    </div>' +
                '  </div>' +
                '</div>';
            document.body.appendChild(overlay);
        }

        var msg = overlay.querySelector('.me-export-login-msg');
        var loginBtn = overlay.querySelector('#me-export-login-btn');
        var anywayBtn = overlay.querySelector('#me-export-anyway-btn');
        var closeBtn = overlay.querySelector('#me-export-login-close');

        msg.textContent = 'Login with Google to export documents.';
        anywayBtn.style.display = allowWithoutAccount && onExportAnyway ? '' : 'none';

        function hide() {
            overlay.style.display = 'none';
        }

        loginBtn.onclick = function () {
            window.location.href = getLoginUrl();
        };

        if (allowWithoutAccount && onExportAnyway) {
            anywayBtn.onclick = function () {
                hide();
                onExportAnyway();
            };
        }

        closeBtn.onclick = hide;
        overlay.onclick = function (e) {
            if (e.target === overlay) hide();
        };

        overlay.style.display = 'flex';
    }

    /**
     * Check session before export. If not logged in, show login modal. Else run the export.
     * @param {string} exportType - 'pdf' | 'latex'
     * @param {function} doExport - callback to run when authenticated (or when allowWithoutAccount for LaTeX)
     */
    function requireAuthForExport(exportType, doExport) {
        if (!window.MathAPI || !window.MathAPI.checkSession) {
            doExport();
            return;
        }
        window.MathAPI.checkSession().then(function (session) {
            var loggedIn = session && session.logged_in && (session.user_id || session.user_sub);
            if (loggedIn) {
                doExport();
                return;
            }
            var isLatex = (exportType || '').toLowerCase() === 'latex';
            showExportLoginModal({
                exportType: exportType,
                allowWithoutAccount: isLatex,
                onExportAnyway: isLatex ? doExport : null
            });
        }).catch(function () {
            var isLatex = (exportType || '').toLowerCase() === 'latex';
            showExportLoginModal({
                exportType: exportType,
                allowWithoutAccount: isLatex,
                onExportAnyway: isLatex ? doExport : null
            });
        });
    }

    window.MeExportAuth = {
        requireAuthForExport: requireAuthForExport,
        showExportLoginModal: showExportLoginModal,
        getLoginUrl: getLoginUrl
    };

})();
