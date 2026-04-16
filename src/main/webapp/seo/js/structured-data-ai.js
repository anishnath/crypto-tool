/* Structured Data AI Fix Suggestions — Uses /ai proxy */

'use strict';

var StructuredDataAI = (function () {

    var SYSTEM_PROMPT =
        'You are an expert in Schema.org structured data, JSON-LD, Open Graph, and Twitter Cards. ' +
        'Given a specific validation failure and the page URL, provide a concise, actionable fix. ' +
        'Include the exact JSON-LD snippet, meta tag, or code to add/modify. ' +
        'Use markdown code blocks for all code. Keep responses under 200 words. ' +
        'Do not explain what structured data is — just give the fix.';

    function buildPrompt(group, failedTests, pageUrl, rawData) {
        var parts = [];
        parts.push('Page URL: ' + pageUrl);
        parts.push('Schema: ' + group.name + ' (' + group.source + ')');
        parts.push('Score: ' + group.pct + '% (' + group.passed + ' passed, ' +
            group.failed + ' failed, ' + group.warnings + ' warnings out of ' + group.total + ')');
        parts.push('');

        // Categorize issues by severity
        var critical = [];
        var warnings = [];
        failedTests.forEach(function (t) {
            var line = t.label;
            // Add reason
            if (t.label.indexOf('Invalid format') !== -1) {
                line += ' — value found but wrong format';
                if (t.value) line += ': "' + String(t.value).substring(0, 80) + '"';
            } else if (t.label.indexOf('not a valid property') !== -1) {
                line += ' — this property does not belong on this schema type';
            } else if (t.label.indexOf('draft schema') !== -1) {
                line += ' — pending/experimental property, may not be recognized by search engines';
            }
            // Add schema.org description
            if (t.description) {
                line += '\n    Schema.org: ' + t.description;
            }
            if (t.status === 'fail') critical.push(line);
            else warnings.push(line);
        });

        if (critical.length > 0) {
            parts.push('REQUIRED — must fix (' + critical.length + '):');
            critical.forEach(function (l) { parts.push('  ✗ ' + l); });
            parts.push('');
        }
        if (warnings.length > 0) {
            parts.push('RECOMMENDED — should fix (' + warnings.length + '):');
            warnings.forEach(function (l) { parts.push('  ▲ ' + l); });
            parts.push('');
        }

        // Include what already exists (passed tests) so AI doesn't duplicate
        var passed = group.tests.filter(function (t) { return t.status === 'pass'; });
        if (passed.length > 0) {
            parts.push('Already present (do NOT regenerate these):');
            passed.forEach(function (t) {
                var v = t.value;
                if (v && typeof v === 'object') v = JSON.stringify(v);
                if (v && String(v).length > 60) v = String(v).substring(0, 57) + '...';
                parts.push('  ✓ ' + t.label + (v ? ' = ' + v : ''));
            });
            parts.push('');
        }

        // Include the actual raw data for context
        if (rawData) {
            if (group.source === 'JSON-LD' && rawData.jsonld && rawData.jsonld.length > 0) {
                var relevant = rawData.jsonld.filter(function (item) {
                    var types = [].concat(item['@type'] || []);
                    return types.some(function (t) { return group.name.indexOf(t) !== -1 || t.indexOf(group.name) !== -1; });
                });
                if (relevant.length > 0) {
                    var json = JSON.stringify(relevant[0], null, 2);
                    if (json.length > 2000) json = json.substring(0, 2000) + '\n... (truncated)';
                    parts.push('Current JSON-LD on page:');
                    parts.push(json);
                    parts.push('');
                }
            }
            if (group.source === 'Meta Tags' && rawData.metatags) {
                var relevantTags = {};
                var prefix = group.name === 'Open Graph' ? 'og:' : (group.name === 'Twitter Card' ? 'twitter:' : '');
                Object.keys(rawData.metatags).forEach(function (k) {
                    if (!prefix || k.indexOf(prefix) === 0) relevantTags[k] = rawData.metatags[k];
                });
                if (Object.keys(relevantTags).length > 0) {
                    parts.push('Current meta tags:');
                    parts.push(JSON.stringify(relevantTags, null, 2));
                    parts.push('');
                }
            }
        }

        parts.push('Generate the exact code to fix ONLY the issues listed above.');
        parts.push('For JSON-LD: show the complete corrected <script type="application/ld+json"> block.');
        parts.push('For meta tags: show the exact <meta> tags to add.');
        parts.push('Do not remove or change properties that already pass.');
        return parts.join('\n');
    }

    function requestFix(group, pageUrl, rawData, containerEl, triggerBtn) {
        var failedTests = group.tests.filter(function (t) { return t.status !== 'pass'; });
        if (failedTests.length === 0) return;

        if (triggerBtn) {
            triggerBtn.disabled = true;
            triggerBtn.textContent = 'Analyzing…';
        }

        containerEl.innerHTML = '<div class="sd-ai-loading"><span class="sd-ai-spinner"></span> AI is analyzing ' + failedTests.length + ' issue(s)…</div>';
        containerEl.style.display = 'block';

        var prompt = buildPrompt(group, failedTests, pageUrl, rawData);

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
        .then(function (r) {
            if (r.status === 429) throw new Error('AI rate limit reached. Try again in a minute.');
            if (!r.ok) throw new Error('AI service unavailable');
            return r.json();
        })
        .then(function (data) {
            var text = '';
            if (data.message && data.message.content) text = data.message.content;
            else if (data.response) text = data.response;
            else if (data.choices && data.choices[0]) text = data.choices[0].message ? data.choices[0].message.content : (data.choices[0].text || '');

            if (!text) throw new Error('Empty AI response');

            if (triggerBtn) { triggerBtn.disabled = false; triggerBtn.textContent = '\u2728 AI Fix'; }

            containerEl.innerHTML =
                '<div class="sd-ai-response">' +
                '  <div class="sd-ai-header"><span class="sd-ai-badge">AI Fix</span></div>' +
                '  <div class="sd-ai-body">' + renderMarkdown(text) + '</div>' +
                '  <button class="sd-ai-close" onclick="this.closest(\'.sd-ai-response\').parentNode.style.display=\'none\'">Dismiss</button>' +
                '</div>';
        })
        .catch(function (err) {
            if (triggerBtn) { triggerBtn.disabled = false; triggerBtn.textContent = '\u2728 AI Fix'; }
            containerEl.innerHTML =
                '<div class="sd-ai-error">' + escapeHtml(err.message) +
                ' <button class="sd-ai-close" onclick="this.closest(\'.sd-ai-error\').parentNode.style.display=\'none\'">Dismiss</button></div>';
        });
    }

    function renderMarkdown(text) {
        var html = escapeHtml(text);
        html = html.replace(/```(\w*)\n([\s\S]*?)```/g, '<pre class="sd-ai-code"><code>$2</code></pre>');
        html = html.replace(/`([^`]+)`/g, '<code class="sd-ai-inline">$1</code>');
        html = html.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>');
        html = html.replace(/\n/g, '<br>');
        return html;
    }

    function escapeHtml(str) {
        if (!str) return '';
        var div = document.createElement('div');
        div.textContent = str;
        return div.innerHTML;
    }

    return { requestFix: requestFix };

})();
