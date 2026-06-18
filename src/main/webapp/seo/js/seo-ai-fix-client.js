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
    if (err && err.message) return err.message;
    return 'AI service unavailable';
  }

  function isQuotaExceeded(err) {
    return !!(err && (err.status === 402 || err.code === 'ai_quota_exceeded'));
  }

  function isRateLimited(err) {
    return !!(err && (err.status === 429 || err.code === 'rate_limited'));
  }

  function isLimitError(err) {
    return isQuotaExceeded(err) || isRateLimited(err);
  }

  function limitMessage(err) {
    if (err && err.message) return err.message;
    if (isRateLimited(err)) return 'AI rate limit reached. Try again in a minute.';
    if (isQuotaExceeded(err)) {
      return isLoggedIn()
        ? 'You\'ve used your free AI Fix quota. Go Pro for 10× more AI + 20,000 page scans per site — just $3/mo.'
        : 'AI limit reached. Sign in free for more — or go Pro ($3/mo) for 20,000 page scans & 10× AI fixes.';
    }
    return formatError(err);
  }

  function quotaDetail(err) {
    var q = err && err.quota;
    if (!q || q.is_unlimited) return '';
    if (q.tokens_limit) {
      return 'Used ' + Number(q.tokens_used || 0).toLocaleString()
        + ' / ' + Number(q.tokens_limit).toLocaleString() + ' tokens this month.';
    }
    return '';
  }

  function startProCheckout() {
    var ctx = ctxPath();
    if (!isLoggedIn()) {
      window.location.href = loginHref();
      return Promise.resolve();
    }
    var returnPath = window.location.pathname + window.location.search;
    var cancelPath = returnPath;
    var sep = returnPath.indexOf('?') >= 0 ? '&' : '?';
    if (returnPath.indexOf('checkout=') < 0) {
      returnPath += sep + 'checkout=1';
    }
    return fetch(ctx + '/api/dodo/checkout', {
      method: 'POST',
      credentials: 'same-origin',
      headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
      body: JSON.stringify({
        plan: 'monthly',
        tool_id: boot().toolId || 'seo/pro',
        return_path: returnPath,
        cancel_path: cancelPath
      })
    }).then(function (r) {
      return r.json().catch(function () { return {}; }).then(function (data) {
        if (!r.ok) {
          var msg = data.error || data.hint || ('Checkout failed (' + r.status + ')');
          if (r.status === 401) {
            window.location.href = loginHref();
            return;
          }
          throw new Error(msg);
        }
        if (!data.checkout_url) throw new Error('Checkout URL missing');
        window.location.href = data.checkout_url;
      });
    });
  }

  function wireUpgrade(containerEl, cssPrefix) {
    var btn = containerEl.querySelector('[data-seo-ai-upgrade]');
    if (!btn) return;
    btn.addEventListener('click', function () {
      if (btn.disabled) return;
      btn.disabled = true;
      btn.textContent = 'Starting checkout…';
      startProCheckout().catch(function (e) {
        btn.disabled = false;
        btn.textContent = 'Upgrade to Pro — $3/mo';
        showError(containerEl, e.message || 'Checkout failed', cssPrefix, null);
      });
    });
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

  function showError(containerEl, message, cssPrefix, err) {
    if (err && isLimitError(err)) {
      showLimitError(containerEl, err, cssPrefix);
      return;
    }
    var prefix = cssPrefix || 'seo-ai-fix';
    containerEl.innerHTML =
      '<div class="' + prefix + '-error seo-ai-fix-error-panel">' +
      '  <p class="seo-ai-fix-error-msg">' + escapeHtml(message) + '</p>' +
      '  <div class="seo-ai-fix-signin-actions">' +
      '    <button type="button" class="seo-ai-fix-dismiss" data-seo-ai-dismiss>Dismiss</button>' +
      '  </div>' +
      '</div>';
    wireDismiss(containerEl);
  }

  function showLimitError(containerEl, err, cssPrefix) {
    var prefix = cssPrefix || 'seo-ai-fix';
    var loggedIn = isLoggedIn();
    var detail = quotaDetail(err);
    var hint = (err && err.hint) ? String(err.hint) : '';
    var sub = detail || hint;

    var actions = '';
    if (loggedIn) {
      actions =
        '<button type="button" class="seo-ai-fix-upgrade-btn" data-seo-ai-upgrade>Upgrade to Pro — $3/mo</button>';
    } else {
      actions =
        '<a class="seo-ai-fix-signin-link" href="' + escapeHtml(loginHref()) + '">Sign in with Google</a>' +
        '<button type="button" class="seo-ai-fix-upgrade-btn" data-seo-ai-upgrade>Go Pro — $3/mo</button>';
    }
    actions += '<button type="button" class="seo-ai-fix-dismiss" data-seo-ai-dismiss>Dismiss</button>';

    containerEl.style.display = 'block';
    containerEl.innerHTML =
      '<div class="' + prefix + '-error seo-ai-fix-error-panel seo-ai-fix-limit">' +
      '  <p class="seo-ai-fix-error-msg">' + escapeHtml(limitMessage(err)) + '</p>' +
      (sub ? '<p class="seo-ai-fix-error-sub">' + escapeHtml(sub) + '</p>' : '') +
      '  <div class="seo-ai-fix-signin-actions">' + actions + '</div>' +
      '</div>';
    wireDismiss(containerEl);
    wireUpgrade(containerEl, prefix);
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
            err.hint = data.hint;
            err.quota = data.quota;
            err.upgrade = data.upgrade === true;
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
        showError(containerEl, formatError(err), cssPrefix, err);
      });
  }

  var BANNER_CTA_HTML = 'Upgrade &mdash; $3/mo<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" aria-hidden="true"><path d="M5 12h14M13 6l6 6-6 6" stroke-linecap="round" stroke-linejoin="round"/></svg>';

  function isProSubscriber(data) {
    return !!(data && (data.is_premium === true || data.is_premium === 'true'));
  }

  function fetchBillingPremium() {
    return fetch(ctxPath() + '/api/billing/status', {
      method: 'GET',
      credentials: 'same-origin',
      headers: { Accept: 'application/json' }
    }).then(function (r) {
      if (r.status === 401) return false;
      if (!r.ok) return false;
      return r.json().then(function (data) {
        return isProSubscriber(data);
      });
    }).catch(function () {
      return false;
    });
  }

  function updatePricingBannerVisibility(banner) {
    fetchBillingPremium().then(function (isPro) {
      banner.hidden = isPro;
    });
  }

  function wirePricingBanner(banner) {
    var cta = banner.querySelector('[data-seo-pro-upgrade]');
    if (cta) {
      cta.addEventListener('click', function () {
        if (cta.disabled) return;
        cta.disabled = true;
        cta.textContent = 'Starting checkout…';
        startProCheckout().catch(function (err) {
          cta.disabled = false;
          cta.innerHTML = BANNER_CTA_HTML;
          alert(err.message || 'Could not start checkout. Please try again.');
        });
      });
    }
  }

  function initPricingBanner() {
    var banner = document.getElementById('seo-pro-banner');
    if (!banner) return;

    /* Clear legacy dismiss flag — banner stays until Pro upgrade */
    try { localStorage.removeItem('seo_pro_banner_dismissed'); } catch (e) { /* ignore */ }

    wirePricingBanner(banner);
    updatePricingBannerVisibility(banner);

    /* Re-check after checkout return or bfcache back-navigation */
    window.addEventListener('pageshow', function () {
      updatePricingBannerVisibility(banner);
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initPricingBanner);
  } else {
    initPricingBanner();
  }

  return {
    requestFix: requestFix,
    renderMarkdown: renderMarkdown,
    escapeHtml: escapeHtml,
    startProCheckout: startProCheckout,
    isLoggedIn: isLoggedIn,
    ctxPath: ctxPath,
    initPricingBanner: initPricingBanner
  };

})();
