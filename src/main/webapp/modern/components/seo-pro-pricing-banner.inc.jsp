<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%--
  SEO Pro pricing announcement banner ($3/mo).
  Optional request attribute before include:
    seoProBannerVariant — "compact" | "idx" (default compact)

  Works with seo/js/seo-ai-fix-client.js (styles in seo/css/seo-ai-fix.css).
--%><%
String seoProBannerVariant = request.getParameter("variant");
if (seoProBannerVariant == null) {
  Object attr = request.getAttribute("seoProBannerVariant");
  seoProBannerVariant = attr != null ? String.valueOf(attr) : "compact";
}
String seoProBannerClass = "seo-pro-banner seo-pro-banner--" + seoProBannerVariant;
%>
<aside class="<%= seoProBannerClass %>" id="seo-pro-banner" aria-label="SEO Pro upgrade offer" hidden>
  <div class="seo-pro-banner-inner">
    <div class="seo-pro-banner-glow" aria-hidden="true"></div>

    <div class="seo-pro-banner-content">
      <div class="seo-pro-banner-badge-row">
        <span class="seo-pro-banner-badge">SEO Pro</span>
        <span class="seo-pro-banner-launch">Limited launch</span>
      </div>
      <h2 class="seo-pro-banner-title">
        Crawl up to <strong>20,000 pages</strong> per site + <strong>10&times; AI fixes</strong>
      </h2>
      <p class="seo-pro-banner-sub">
        Stop hitting free limits mid-audit. Pro unlocks deep full-site crawls, priority scans,
        and enough AI Fix power to patch every issue — for less than a coffee.
      </p>
      <ul class="seo-pro-banner-perks">
        <li>20,000 page scans / website</li>
        <li>10&times; higher AI monthly limit</li>
        <li>Priority crawl &amp; audit queue</li>
        <li>Cancel anytime</li>
      </ul>
    </div>

    <div class="seo-pro-banner-cta-block">
      <div class="seo-pro-banner-price" aria-label="Three dollars per month">
        <span class="seo-pro-banner-price-val">$3</span>
        <span class="seo-pro-banner-price-unit">/mo</span>
      </div>
      <button type="button" class="seo-pro-banner-cta" data-seo-pro-upgrade>
        Upgrade to Pro
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" aria-hidden="true">
          <path d="M5 12h14M13 6l6 6-6 6" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </button>
      <p class="seo-pro-banner-trust">Secure checkout &middot; Instant access</p>
    </div>
  </div>
</aside>
