/* Structured Data Testing Tool — main app */
'use strict';

(function () {

    var state = 'idle';
    var currentData = null;
    var currentResults = null;

    document.addEventListener('DOMContentLoaded', function () {
        document.getElementById('sd-form').addEventListener('submit', function (e) {
            e.preventDefault();
            startTest();
        });
        document.getElementById('sd-new-btn').addEventListener('click', resetState);

        // Pre-load schema.org data for property validation
        if (typeof StructuredDataTests !== 'undefined' && StructuredDataTests.loadSchemaData) {
            StructuredDataTests.loadSchemaData(getContextPath());
        }
    });

    // ── State ──

    function showSection(name) {
        state = name;
        ['input', 'progress', 'results'].forEach(function (s) {
            var el = document.getElementById('sd-' + s + '-section');
            if (el) el.style.display = (s === name) ? 'block' : 'none';
        });
    }

    function resetState() {
        currentData = null;
        currentResults = null;
        showSection('input');
    }

    function getContextPath() {
        var meta = document.querySelector('meta[name="ctx"]');
        return meta ? meta.content : '';
    }

    function showError(msg) {
        var el = document.getElementById('sd-error-msg');
        el.textContent = msg;
        el.classList.add('show');
        setTimeout(function () { el.classList.remove('show'); }, 8000);
    }

    // ── URL validation (same as lighthouse) ──

    function validateUrl(raw) {
        if (!raw || !raw.trim()) return { ok: false, error: 'Enter a URL' };
        var s = raw.trim();
        if (s.length > 2048) return { ok: false, error: 'URL is too long' };
        if (!/^https?:\/\//i.test(s)) s = 'https://' + s;
        var parsed;
        try { parsed = new URL(s); }
        catch (e) { return { ok: false, error: 'Invalid URL format' }; }
        var host = parsed.hostname.toLowerCase();
        if (!host || host.indexOf('.') === -1) return { ok: false, error: 'Enter a valid domain (e.g. example.com)' };
        var blocked = ['localhost', '127.0.0.1', '0.0.0.0', '::1'];
        if (blocked.indexOf(host) !== -1) return { ok: false, error: 'Cannot test local addresses' };
        if (host.startsWith('192.168.') || host.startsWith('10.') || host.endsWith('.local'))
            return { ok: false, error: 'Cannot test private addresses' };
        return { ok: true, url: s };
    }

    // ── Reachability ──

    function checkReachable(url) {
        var controller = typeof AbortController !== 'undefined' ? new AbortController() : null;
        var tid;
        if (controller) tid = setTimeout(function () { controller.abort(); }, 6000);
        return fetch(url, { method: 'HEAD', mode: 'no-cors', cache: 'no-store', signal: controller ? controller.signal : undefined })
            .then(function () { if (tid) clearTimeout(tid); return { ok: true }; })
            .catch(function (err) {
                if (tid) clearTimeout(tid);
                return { ok: false, error: err.name === 'AbortError' ? 'Site took too long to respond.' : 'Site appears unreachable.' };
            });
    }

    // ── Submit ──

    function startTest() {
        var urlEl = document.getElementById('sd-url');
        var v = validateUrl(urlEl.value);
        if (!v.ok) { showError(v.error); urlEl.focus(); return; }
        urlEl.value = v.url;

        var btn = document.getElementById('sd-start-btn');
        btn.disabled = true;
        btn.textContent = 'Checking…';

        checkReachable(v.url).then(function (r) {
            if (!r.ok) {
                btn.disabled = false;
                btn.textContent = 'Test';
                showError(r.error);
                urlEl.focus();
                return;
            }

            showSection('progress');
            document.getElementById('sd-progress-url').textContent = v.url;
            document.getElementById('sd-progress-text').textContent = 'Extracting structured data…';

            fetch(getContextPath() + '/StructuredDataFunctionality?action=extract', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ url: v.url })
            })
            .then(function (resp) {
                if (!resp.ok) return resp.json().then(function (d) { throw new Error(d.error || 'Extraction failed'); });
                return resp.json();
            })
            .then(function (data) {
                currentData = data;
                currentResults = StructuredDataTests.runAll(data);
                renderResults(data, currentResults);
                showSection('results');
                btn.disabled = false;
                btn.textContent = 'Test';
            })
            .catch(function (err) {
                showSection('input');
                btn.disabled = false;
                btn.textContent = 'Test';
                showError(err.message || 'Could not extract structured data');
            });
        });
    }

    // ── Render ──

    function renderResults(data, results) {
        // URL bar
        document.getElementById('sd-results-url').innerHTML =
            '<span class="sd-results-label">Tested:</span>' +
            '<a href="' + esc(data.url) + '" class="sd-results-link" target="_blank" rel="noopener">' + esc(data.url) + '</a>';

        // Detection summary badges
        var det = results.detected;
        var badgesHtml =
            badge('JSON-LD', det.jsonld) +
            badge('Microdata', det.microdata) +
            badge('RDFa', det.rdfa) +
            badge('Meta Tags', det.metatags);
        document.getElementById('sd-detection-badges').innerHTML = badgesHtml;

        // Score
        var s = results.summary;
        var pct = s.total > 0 ? Math.round(s.passed / s.total * 100) : 0;
        var scoreColor = pct >= 80 ? 'pass' : (pct >= 50 ? 'warn' : 'fail');
        document.getElementById('sd-score').innerHTML =
            '<div class="sd-score-num ' + scoreColor + '">' + pct + '%</div>' +
            '<div class="sd-score-detail">' +
            '<span class="sd-stat pass">' + s.passed + ' passed</span>' +
            '<span class="sd-stat fail">' + s.failed + ' failed</span>' +
            '<span class="sd-stat warn">' + s.warnings + ' warnings</span>' +
            '</div>';

        // Test groups
        var groupsEl = document.getElementById('sd-groups');
        groupsEl.innerHTML = '';

        if (results.groups.length === 0) {
            groupsEl.innerHTML = '<div class="sd-empty">No structured data found on this page.</div>';
            return;
        }

        results.groups.forEach(function (g, gIdx) {
            var groupDiv = document.createElement('div');
            groupDiv.className = 'sd-group' + (gIdx > 0 ? ' collapsed' : '');

            var headerColor = g.failed > 0 ? 'fail' : (g.warnings > 0 ? 'warn' : 'pass');
            var headerHtml =
                '<div class="sd-group-header ' + headerColor + '" data-toggle="group">' +
                '  <div class="sd-group-left">' +
                '    <span class="sd-group-name">' + esc(g.name) + '</span>' +
                '    <span class="sd-group-source">' + esc(g.source) + '</span>' +
                '  </div>' +
                '  <div class="sd-group-right">' +
                '    <span class="sd-group-pct">' + g.pct + '%</span>' +
                '    <span class="sd-group-counts">' + g.passed + '/' + g.total + '</span>' +
                '    <span class="sd-group-chev">&#9662;</span>' +
                '  </div>' +
                '</div>';

            var testsHtml = '<div class="sd-group-tests">';
            g.tests.forEach(function (t) {
                var icon = t.status === 'pass' ? '<span class="sd-icon pass">&#10003;</span>'
                         : t.status === 'warning' ? '<span class="sd-icon warn">&#9650;</span>'
                         : '<span class="sd-icon fail">&#10007;</span>';
                var valStr = '';
                if (t.passed && t.value != null) {
                    var v = typeof t.value === 'object' ? JSON.stringify(t.value) : String(t.value);
                    if (v.length > 120) v = v.substring(0, 117) + '…';
                    valStr = '<span class="sd-test-value">' + esc(v) + '</span>';
                }
                var descStr = '';
                if (t.description) {
                    descStr = '<div class="sd-test-desc">' + esc(t.description) + '</div>';
                }
                testsHtml += '<div class="sd-test ' + t.status + '">' +
                    icon +
                    '<div class="sd-test-content">' +
                    '  <span class="sd-test-label">' + esc(t.label) + '</span>' +
                    valStr +
                    descStr +
                    '</div>' +
                    '</div>';
            });
            // AI Fix button for groups with failures/warnings
            var hasIssues = g.tests.some(function (t) { return t.status !== 'pass'; });
            if (hasIssues && typeof StructuredDataAI !== 'undefined') {
                var aiId = 'sd-ai-' + groupsEl.children.length;
                testsHtml +=
                    '<div class="sd-ai-actions">' +
                    '  <button class="sd-ai-fix-btn" id="' + aiId + '-btn" type="button">' +
                    '    <span aria-hidden="true">&#10024;</span> AI Fix' +
                    '  </button>' +
                    '</div>' +
                    '<div class="sd-ai-container" id="' + aiId + '-cnt" style="display:none;"></div>';
            }

            testsHtml += '</div>';

            groupDiv.innerHTML = headerHtml + testsHtml;
            groupsEl.appendChild(groupDiv);

            // Wire AI button
            if (hasIssues && typeof StructuredDataAI !== 'undefined') {
                (function (group, aiIdLocal) {
                    var btn = document.getElementById(aiIdLocal + '-btn');
                    var cnt = document.getElementById(aiIdLocal + '-cnt');
                    if (btn && cnt) {
                        btn.addEventListener('click', function () {
                            StructuredDataAI.requestFix(group, data.url, data, cnt, btn);
                        });
                    }
                })(g, 'sd-ai-' + (groupsEl.children.length - 1));
            }

            // Toggle collapse
            groupDiv.querySelector('.sd-group-header').addEventListener('click', function () {
                groupDiv.classList.toggle('collapsed');
            });
        });

        // Raw data viewer
        var rawEl = document.getElementById('sd-raw-data');
        rawEl.textContent = JSON.stringify(data, null, 2);
    }

    function badge(label, count) {
        var cls = count > 0 ? 'found' : 'none';
        return '<span class="sd-badge ' + cls + '">' + esc(label) + ': ' + count + '</span>';
    }

    function esc(s) {
        if (s == null) return '';
        return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    }

})();
