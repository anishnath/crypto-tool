/* Lighthouse AI Fix Suggestions — inline fix via shared SeoAiFixClient */

'use strict';

var LighthouseAI = (function () {

    var SYSTEM_PROMPT =
        'You are a senior web performance engineer. Given a failed Google Lighthouse audit and the page context, give a concise, copy-paste-ready fix. ' +
        'Be specific: include exact code (HTML, CSS, JS, nginx, Apache, headers) when relevant. ' +
        'For Core Web Vitals issues (LCP, FCP, CLS, TBT, INP, TTFB), explain what causes the metric to be slow on this kind of page and the most impactful fix. ' +
        'For accessibility/SEO/best-practices, give the exact tag, attribute, or config change. ' +
        'Keep responses under 180 words. Use markdown for code blocks. Do not explain what Lighthouse is — just give the fix.';

    function buildPrompt(audit, context) {
        var parts = [];
        parts.push('Failed Lighthouse audit: ' + audit.title);
        parts.push('Audit ID: ' + audit.id);
        if (audit.description) parts.push('Audit description: ' + stripMarkdownLinks(audit.description));
        if (typeof audit.score === 'number') parts.push('Score: ' + audit.score + ' (0 = fail, 1 = pass)');
        if (audit.display_value) parts.push('Measured value: ' + audit.display_value);

        if (context) {
            parts.push('\nPage being audited: ' + context.url);
            parts.push('Strategy: ' + context.strategy);
            if (context.scores) {
                parts.push('Overall scores — Performance: ' + (context.scores.performance || 'n/a') +
                    ', Accessibility: ' + (context.scores.accessibility || 'n/a') +
                    ', Best Practices: ' + (context.scores.best_practices || 'n/a') +
                    ', SEO: ' + (context.scores.seo || 'n/a'));
            }
            if (context.core_web_vitals) {
                var vitals = Object.keys(context.core_web_vitals).map(function (k) {
                    return k + '=' + context.core_web_vitals[k];
                }).join(', ');
                parts.push('Core Web Vitals: ' + vitals);
            }
        }

        parts.push('\nProvide the specific fix for this audit on this page.');
        return parts.join('\n');
    }

    function stripMarkdownLinks(s) {
        return String(s || '').replace(/\[([^\]]+)\]\([^)]+\)/g, '$1');
    }

    function requestFix(audit, context, containerEl, triggerBtn) {
        if (typeof SeoAiFixClient === 'undefined') {
            console.error('SeoAiFixClient not loaded');
            return;
        }
        SeoAiFixClient.requestFix({
            systemPrompt: SYSTEM_PROMPT,
            userPrompt: buildPrompt(audit, context),
            containerEl: containerEl,
            triggerBtn: triggerBtn,
            buttonLabel: 'AI Fix',
            analyzingLabel: 'Analyzing…',
            badgeLabel: '\u2728 AI Fix',
            cssPrefix: 'lh-ai',
            loadingHtml: '<div class="lh-ai-loading"><span class="lh-ai-spinner"></span> AI is analyzing this audit&hellip;</div>'
        });
    }

    return {
        requestFix: requestFix
    };
})();
