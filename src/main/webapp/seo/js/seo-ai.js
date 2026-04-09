/* SEO AI Fix Suggestions — Uses /ai proxy to generate actionable fixes */

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

        // Images context for image-related issues
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
        var meta = (typeof getIssueMeta === 'function') ? getIssueMeta(issueType) : { title: issueType, desc: '' };

        // Disable the button that triggered this
        var triggerBtn = containerEl.parentNode ? containerEl.parentNode.querySelector('.seo-ai-fix-btn') : null;
        if (triggerBtn) {
            triggerBtn.disabled = true;
            triggerBtn.textContent = 'Analyzing...';
        }

        // Show loading state
        containerEl.innerHTML = '<div class="seo-ai-loading"><span class="seo-ai-spinner"></span> AI is analyzing this issue...</div>';
        containerEl.style.display = 'block';

        var prompt = buildPrompt(issueType, meta, pageData);

        var ctx = document.querySelector('meta[name="ctx"]');
        var ctxPath = ctx ? ctx.getAttribute('content') : '';

        fetch(ctxPath + '/ai', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                messages: [
                    { role: 'system', content: SYSTEM_PROMPT },
                    { role: 'user', content: prompt }
                ],
                stream: false
            })
        })
        .then(function(r) {
            if (r.status === 429) throw new Error('AI rate limit reached. Try again in a minute.');
            if (!r.ok) throw new Error('AI service unavailable');
            return r.json();
        })
        .then(function(data) {
            var text = '';
            // Ollama response format
            if (data.message && data.message.content) {
                text = data.message.content;
            } else if (data.response) {
                text = data.response;
            } else if (data.choices && data.choices[0]) {
                text = data.choices[0].message ? data.choices[0].message.content : (data.choices[0].text || '');
            }

            if (!text) throw new Error('Empty AI response');

            if (triggerBtn) { triggerBtn.disabled = false; triggerBtn.textContent = 'AI Fix Suggestion'; }

            containerEl.innerHTML =
                '<div class="seo-ai-response">' +
                '  <div class="seo-ai-header"><span class="seo-ai-badge">AI Fix</span></div>' +
                '  <div class="seo-ai-body">' + renderMarkdown(text) + '</div>' +
                '  <button class="seo-ai-close" onclick="this.closest(\'.seo-ai-response\').parentNode.style.display=\'none\'">Dismiss</button>' +
                '</div>';
        })
        .catch(function(err) {
            if (triggerBtn) { triggerBtn.disabled = false; triggerBtn.textContent = 'AI Fix Suggestion'; }

            containerEl.innerHTML =
                '<div class="seo-ai-error">' + escapeHtml(err.message) +
                ' <button class="seo-ai-close" onclick="this.closest(\'.seo-ai-error\').parentNode.style.display=\'none\'">Dismiss</button></div>';
        });
    }

    // Simple markdown → HTML (code blocks, inline code, bold, line breaks)
    function renderMarkdown(text) {
        var html = escapeHtml(text);
        // Code blocks: ```...```
        html = html.replace(/```(\w*)\n([\s\S]*?)```/g, '<pre class="seo-ai-code"><code>$2</code></pre>');
        // Inline code: `...`
        html = html.replace(/`([^`]+)`/g, '<code class="seo-ai-inline">$1</code>');
        // Bold: **...**
        html = html.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>');
        // Line breaks
        html = html.replace(/\n/g, '<br>');
        return html;
    }

    function escapeHtml(str) {
        if (!str) return '';
        var div = document.createElement('div');
        div.textContent = str;
        return div.innerHTML;
    }

    return {
        requestFix: requestFix
    };

})();
