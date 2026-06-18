/* SEO AI Fix Suggestions — inline fix via shared SeoAiFixClient */

'use strict';

var SeoAI = (function() {

    var SYSTEM_PROMPT = 'You are an expert SEO consultant. Given a specific SEO issue and page evidence, provide a concise, actionable fix. Be specific — include the exact corrected code, header value, or text. Keep responses under 150 words. Use markdown for code blocks. Do not explain what SEO is — just give the fix.';

    function buildPrompt(issueType, issueMeta, pageData) {
        var parts = [];
        parts.push('SEO Issue: ' + issueMeta.title);
        parts.push('Issue Type: ' + issueType);
        parts.push('URL: ' + pageData.url);

        if (pageData.title) parts.push('Current Title (' + (pageData.title_length || '?') + ' chars): ' + pageData.title);
        if (pageData.description) parts.push('Current Description (' + (pageData.description_length || '?') + ' chars): ' + pageData.description);
        if (pageData.h1) parts.push('H1: ' + pageData.h1);
        if (pageData.canonical) parts.push('Canonical: ' + pageData.canonical);
        if (pageData.lang) parts.push('Lang: ' + pageData.lang);
        if (pageData.status_code) parts.push('Status: ' + pageData.status_code);
        if (pageData.redirect_url) parts.push('Redirects to: ' + pageData.redirect_url);
        if (pageData.ttfb_ms) parts.push('TTFB: ' + pageData.ttfb_ms + 'ms');
        if (pageData.words) parts.push('Word count: ' + pageData.words);
        if (pageData.robots) parts.push('Robots: ' + pageData.robots);

        if (issueType.indexOf('IMAGE') !== -1 || issueType.indexOf('ALT') !== -1 || issueType.indexOf('IMG') !== -1) {
            if (pageData.images && pageData.images.length > 0) {
                var imgSample = pageData.images.slice(0, 5).map(function(img) {
                    return (img.alt ? 'alt="' + img.alt + '"' : 'NO ALT') + ' src=' + img.url;
                }).join('\n');
                parts.push('Images (sample):\n' + imgSample);
            }
            if (pageData.images_missing_alt_count) parts.push('Images missing alt: ' + pageData.images_missing_alt_count);
        }

        parts.push('\nProvide the specific fix for this issue on this page.');
        return parts.join('\n');
    }

    function requestFix(issueType, pageData, containerEl) {
        if (typeof SeoAiFixClient === 'undefined') {
            console.error('SeoAiFixClient not loaded');
            return;
        }
        var meta = (typeof getIssueMeta === 'function') ? getIssueMeta(issueType) : { title: issueType, desc: '' };
        var triggerBtn = containerEl.parentNode ? containerEl.parentNode.querySelector('.seo-ai-fix-btn') : null;

        SeoAiFixClient.requestFix({
            systemPrompt: SYSTEM_PROMPT,
            userPrompt: buildPrompt(issueType, meta, pageData),
            containerEl: containerEl,
            triggerBtn: triggerBtn,
            buttonLabel: 'AI Fix Suggestion',
            analyzingLabel: 'Analyzing...',
            badgeLabel: 'AI Fix',
            cssPrefix: 'seo-ai',
            loadingHtml: '<div class="seo-ai-loading"><span class="seo-ai-spinner"></span> AI is analyzing this issue...</div>'
        });
    }

    return {
        requestFix: requestFix
    };

})();
