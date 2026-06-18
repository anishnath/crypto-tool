/* Structured Data AI Fix Suggestions — inline fix via shared SeoAiFixClient */

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

        var critical = [];
        var warnings = [];
        failedTests.forEach(function (t) {
            var line = t.label;
            if (t.label.indexOf('Invalid format') !== -1) {
                line += ' — value found but wrong format';
                if (t.value) line += ': "' + String(t.value).substring(0, 80) + '"';
            } else if (t.label.indexOf('not a valid property') !== -1) {
                line += ' — this property does not belong on this schema type';
            } else if (t.label.indexOf('draft schema') !== -1) {
                line += ' — pending/experimental property, may not be recognized by search engines';
            }
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

        if (typeof SeoAiFixClient === 'undefined') {
            console.error('SeoAiFixClient not loaded');
            return;
        }

        SeoAiFixClient.requestFix({
            systemPrompt: SYSTEM_PROMPT,
            userPrompt: buildPrompt(group, failedTests, pageUrl, rawData),
            containerEl: containerEl,
            triggerBtn: triggerBtn,
            buttonLabel: '\u2728 AI Fix',
            analyzingLabel: 'Analyzing…',
            badgeLabel: 'AI Fix',
            cssPrefix: 'sd-ai',
            loadingHtml: '<div class="sd-ai-loading"><span class="sd-ai-spinner"></span> AI is analyzing ' + failedTests.length + ' issue(s)…</div>'
        });
    }

    return { requestFix: requestFix };

})();
