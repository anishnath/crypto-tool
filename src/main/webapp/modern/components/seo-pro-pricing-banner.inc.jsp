<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%--
  SEO Pro pricing strip ($3/mo). Optional: seoProBannerVariant = "compact" | "idx"
  Styles + logic: seo/css/seo-ai-fix.css, seo/js/seo-ai-fix-client.js
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
    <div class="seo-pro-banner-main">
      <span class="seo-pro-banner-badge">SEO Pro</span>
      <p class="seo-pro-banner-copy">
        <strong>20,000 pages</strong> per site &middot; <strong>10&times; AI fixes</strong> &middot; priority scans
      </p>
    </div>
    <button type="button" class="seo-pro-banner-cta" data-seo-pro-upgrade>
      Upgrade &mdash; $3/mo
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" aria-hidden="true">
        <path d="M5 12h14M13 6l6 6-6 6" stroke-linecap="round" stroke-linejoin="round"/>
      </svg>
    </button>
  </div>
</aside>
