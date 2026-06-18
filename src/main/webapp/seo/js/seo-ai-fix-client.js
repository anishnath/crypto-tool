/**
 * Shared inline SEO AI Fix client — gateway headers, sign-in gate, one-shot fixes.
 * Used by lighthouse-ai.js, seo-ai.js, structured-data-ai.js.
 *
 * Expects window.seoAiBoot from seo-ai-boot.inc.jsp.
 */
'use strict';

var SeoAiFixClient = (function () {

  var ANON_KEY = 'llm_anonymous_id';

  function boot() {
    return window.seoAiBoot || {};
  }

  function ctxPath() {
    var b = boot();
    if (b.ctx) return b.ctx;
    var meta = document.querySelector('meta[name="ctx"]');
    return meta ? meta.getAttribute('content') || '' : '';
  }

  function aiUrl() {
    var b = boot();
    return b.aiUrl || (ctxPath() + (b.useGateway ? '/ai-gateway' : '/ai'));
  }

  function isLoggedIn() {
    return !!(boot().userId);
  }

  function requireSignIn() {
    return boot().requireSignIn === true;
  }

  function loginHref() {
    var redirect = window.location.pathname + window.location.search + window.location.hash;
    return ctxPath() + '/GoogleOAuthFunctionality?action=login&redirect='
      + encodeURIComponent(redirect);
  }

  function getAnonymousId() {
    var id = localStorage.getItem(ANON_KEY);
    if (!id) {
      id = (typeof crypto !== 'undefined' && crypto.randomUUID)
        ? crypto.randomUUID()
        : 'anon-' + Date.now() + '-' + Math.random().toString(36).slice(2, 11);
      localStorage.setItem(ANON_KEY, id);
    }
    return id;
  }

  function buildHeaders() {
    var b = boot();
    var url = aiUrl();
    var useGateway = b.useGateway === true || url.indexOf('/ai-gateway') !== -1;
    var headers = { 'Content-Type': 'application/json' };
    if (useGateway) {
      if (b.userId) {
        headers['X-User-Id'] = b.userId;
      } else {
        headers['X-Anonymous-Id'] = getAnonymousId();
      }
      if (b.toolId) headers['X-Tool-Id'] = b.toolId;
    }
    return headers;
  }

  function escapeHtml(str) {
    if (!str) return '';
    var div = document.createElement('div');
    div.textContent = str;
    return div.innerHTML;
  }

  function renderMarkdown(text, cssPrefix) {
    var prefix = cssPrefix || 'seo-ai-fix';
    var html = escapeHtml(text);
    html = html.replace(/```(\w*)\n([\s\S]*?)```/g, function (_m, _lang, code) {
      return '<pre class="' + prefix + '-code"><code>' + code + '</code></pre>';
    });
    html = html.replace(/`([^`\n]+)`/g, '<code class="' + prefix + '-inline">$1</code>');
    html = html.replace(/\*\*([^*\n]+)\*\*/g, '<strong>$1</strong>');
    html = html.replace(/\n/g, '<br>');
    return html;
  }

  function stripThinkingTags(text) {
    return String(text || '').replace(/<think>[\s\S]*?<\/think>/g, '').trim();
  }

  function parseResponseText(data) {
    var text = '';
    if (data.message && data.message.content) text = data.message.content;
    else if (data.content) text = data.content;
    else if (data.response) text = data.response;
    else if (data.choices && data.choices[0]) {
      text = data.choices[0].message
        ? data.choices[0].message.content
        : (data.choices[0].text || '');
    }
    return stripThinkingTags(text);
  }

  function formatError(err) {
    if (err && err.status === 429) {
      return 'AI rate limit reached. Try again in a minute.';
    }
    if (err && (err.status === 402 || err.code === 'ai_quota_exceeded')) {
      return isLoggedIn()
        ? 'Monthly AI limit reached. Upgrade to Pro for more requests.'
        : 'AI limit reached. Sign in for a higher limit or try again later.';
    }
    return (err && err.message) ? err.message : 'AI service unavailable';
  }

  function wireDismiss(containerEl) {
    var closeBtn = containerEl.querySelector('[data-seo-ai-dismiss]');
    if (closeBtn) {
      closeBtn.addEventListener('click', function () {
        containerEl.style.display = 'none';
        containerEl.innerHTML = '';
      });
    }
  }

  function showSignInGate(containerEl) {
    containerEl.style.display = 'block';
    containerEl.innerHTML =
      '<div class="seo-ai-fix-signin">' +
      '  <p>Sign in with Google to use AI Fix on this tool.</p>' +
      '  <div class="seo-ai-fix-signin-actions">' +
      '    <a class="seo-ai-fix-signin-link" href="' + escapeHtml(loginHref()) + '">Sign in with Google</a>' +
      '    <button type="button" class="seo-ai-fix-dismiss" data-seo-ai-dismiss>Dismiss</button>' +
      '  </div>' +
      '</div>';
    wireDismiss(containerEl);
  }

  function showError(containerEl, message, cssPrefix) {
    var prefix = cssPrefix || 'seo-ai-fix';
    containerEl.innerHTML =
      '<div class="' + prefix + '-error">' + escapeHtml(message) +
      ' <button type="button" class="' + prefix + '-close" data-seo-ai-dismiss>Dismiss</button></div>';
    wireDismiss(containerEl);
  }

  /**
   * @param {object} opts
   * @param {string} opts.systemPrompt
   * @param {string} opts.userPrompt
   * @param {HTMLElement} opts.containerEl
   * @param {HTMLButtonElement} [opts.triggerBtn]
   * @param {string} [opts.buttonLabel='AI Fix']
   * @param {string} [opts.analyzingLabel='Analyzing…']
   * @param {string} [opts.badgeLabel='AI Fix']
   * @param {string} [opts.cssPrefix='seo-ai-fix'] — lh-ai, seo-ai, sd-ai for themed CSS
   * @param {string} [opts.loadingHtml] — optional custom loading markup
   */
  function requestFix(opts) {
    if (!opts || !opts.containerEl) return;

    var containerEl = opts.containerEl;
    var triggerBtn = opts.triggerBtn || null;
    var buttonLabel = opts.buttonLabel || 'AI Fix';
    var analyzingLabel = opts.analyzingLabel || 'Analyzing…';
    var badgeLabel = opts.badgeLabel || 'AI Fix';
    var cssPrefix = opts.cssPrefix || 'seo-ai-fix';

    if (requireSignIn() && !isLoggedIn()) {
      if (triggerBtn) {
        triggerBtn.disabled = false;
        triggerBtn.textContent = buttonLabel;
      }
      showSignInGate(containerEl);
      return;
    }

    if (triggerBtn) {
      triggerBtn.disabled = true;
      triggerBtn.textContent = analyzingLabel;
    }

    containerEl.style.display = 'block';
    containerEl.innerHTML = opts.loadingHtml ||
      '<div class="seo-ai-fix-loading"><span class="seo-ai-fix-spinner"></span> AI is analyzing…</div>';

    fetch(aiUrl(), {
      method: 'POST',
      headers: buildHeaders(),
      body: JSON.stringify({
        messages: [
          { role: 'system', content: opts.systemPrompt },
          { role: 'user', content: opts.userPrompt }
        ],
        stream: false
      })
    })
      .then(function (r) {
        return r.json().catch(function () { return {}; }).then(function (data) {
          if (!r.ok) {
            var err = new Error(data.error || data.hint || ('AI request failed (' + r.status + ')'));
            err.status = r.status;
            err.code = data.code;
            throw err;
          }
          return data;
        });
      })
      .then(function (data) {
        var text = parseResponseText(data);
        if (!text) throw new Error('Empty AI response');

        if (triggerBtn) {
          triggerBtn.disabled = false;
          triggerBtn.textContent = buttonLabel;
        }

        containerEl.innerHTML =
          '<div class="' + cssPrefix + '-response">' +
          '  <div class="' + cssPrefix + '-header"><span class="' + cssPrefix + '-badge">' + escapeHtml(badgeLabel) + '</span></div>' +
          '  <div class="' + cssPrefix + '-body">' + renderMarkdown(text, cssPrefix) + '</div>' +
          '  <button type="button" class="' + cssPrefix + '-close" data-seo-ai-dismiss>Dismiss</button>' +
          '</div>';
        wireDismiss(containerEl);
      })
      .catch(function (err) {
        if (triggerBtn) {
          triggerBtn.disabled = false;
          triggerBtn.textContent = buttonLabel;
        }
        showError(containerEl, formatError(err), cssPrefix);
      });
  }

  return {
    requestFix: requestFix,
    renderMarkdown: renderMarkdown,
    escapeHtml: escapeHtml
  };

})();
