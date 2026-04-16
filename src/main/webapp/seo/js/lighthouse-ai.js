/* Lighthouse AI Fix Suggestions — generates actionable fixes for failed audits.
   Uses /ai proxy. Per-audit button → streaming response → markdown rendered inline. */

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
        if (triggerBtn) {
            triggerBtn.disabled = true;
            triggerBtn.textContent = 'Analyzing…';
        }

        containerEl.innerHTML = '<div class="lh-ai-loading"><span class="lh-ai-spinner"></span> AI is analyzing this audit&hellip;</div>';
        containerEl.style.display = 'block';

        var ctx = document.querySelector('meta[name="ctx"]');
        var ctxPath = ctx ? ctx.getAttribute('content') : '';
        var prompt = buildPrompt(audit, context);

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
        .then(function (r) {
            if (r.status === 429) throw new Error('AI rate limit reached. Try again in a minute.');
            if (!r.ok) throw new Error('AI service unavailable');
            return r.json();
        })
        .then(function (data) {
            var text = '';
            if (data.message && data.message.content) text = data.message.content;
            else if (data.response) text = data.response;
            else if (data.choices && data.choices[0]) {
                text = data.choices[0].message ? data.choices[0].message.content : (data.choices[0].text || '');
            }
            if (!text) throw new Error('Empty AI response');

            // Strip Qwen <think>…</think> tags if present
            text = text.replace(/<think>[\s\S]*?<\/think>/g, '').trim();

            if (triggerBtn) { triggerBtn.disabled = false; triggerBtn.textContent = 'AI Fix'; }

            containerEl.innerHTML =
                '<div class="lh-ai-response">' +
                '  <div class="lh-ai-header"><span class="lh-ai-badge">&#10024; AI Fix</span></div>' +
                '  <div class="lh-ai-body">' + renderMarkdown(text) + '</div>' +
                '  <button class="lh-ai-close" type="button">Dismiss</button>' +
                '</div>';

            var closeBtn = containerEl.querySelector('.lh-ai-close');
            if (closeBtn) closeBtn.addEventListener('click', function () {
                containerEl.style.display = 'none';
                containerEl.innerHTML = '';
            });
        })
        .catch(function (err) {
            if (triggerBtn) { triggerBtn.disabled = false; triggerBtn.textContent = 'AI Fix'; }

            containerEl.innerHTML =
                '<div class="lh-ai-error">' + escapeHtml(err.message) +
                ' <button class="lh-ai-close" type="button">Dismiss</button></div>';
            var closeBtn = containerEl.querySelector('.lh-ai-close');
            if (closeBtn) closeBtn.addEventListener('click', function () {
                containerEl.style.display = 'none';
                containerEl.innerHTML = '';
            });
        });
    }

    // Markdown → HTML (code blocks, inline code, bold, line breaks)
    function renderMarkdown(text) {
        var html = escapeHtml(text);
        html = html.replace(/```(\w*)\n([\s\S]*?)```/g, '<pre class="lh-ai-code"><code>$2</code></pre>');
        html = html.replace(/`([^`\n]+)`/g, '<code class="lh-ai-inline">$1</code>');
        html = html.replace(/\*\*([^*\n]+)\*\*/g, '<strong>$1</strong>');
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
