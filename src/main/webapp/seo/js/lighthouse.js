/* Lighthouse Audit — main app
   Submits audit, waits for JSON response (~30-90s), renders gauges + audits */

'use strict';

(function () {

    var state = 'idle';
    var auditId = null;
    var jobId = null;
    var pollTimer = null;
    var pollCount = 0;
    var MAX_POLLS = 180;  // 180 * 2s = 6 min max
    var auditedUrl = '';
    var elapsedTimer = null;
    var elapsedSeconds = 0;
    var currentResult = null;

    document.addEventListener('DOMContentLoaded', function () {
        document.getElementById('lh-form').addEventListener('submit', function (e) {
            e.preventDefault();
            startAudit();
        });

        document.getElementById('lh-new-btn').addEventListener('click', resetState);
        document.getElementById('lh-rescan-btn').addEventListener('click', function () {
            var urlInput = document.getElementById('lh-url');
            if (urlInput && auditedUrl) urlInput.value = auditedUrl;
            resetState();
        });
        document.getElementById('lh-share-btn').addEventListener('click', shareResults);

        var cancelBtn = document.getElementById('lh-cancel-btn');
        if (cancelBtn) cancelBtn.addEventListener('click', function () {
            // Note: backend has no cancel endpoint — we just stop polling on the client.
            // The job keeps running server-side and result will be available in history.
            resetState();
        });

        // Strategy toggle (mobile / desktop)
        document.querySelectorAll('.lh-strategy-btn').forEach(function (btn) {
            btn.addEventListener('click', function () {
                document.querySelectorAll('.lh-strategy-btn').forEach(function (b) { b.classList.remove('active'); });
                this.classList.add('active');
            });
        });

        loadFromHash();
        loadHistory();
    });

    // ── State management ──

    var leftRailLoaded = false;

    function showSection(name) {
        state = name;
        ['input', 'progress', 'results'].forEach(function (s) {
            var el = document.getElementById('lh-' + s + '-section');
            if (el) el.style.display = (s === name) ? 'block' : 'none';
        });
        // Show/hide left rail ad with results section
        var rail = document.getElementById('lh-left-rail-ad');
        if (rail) {
            if (name === 'results') {
                rail.classList.remove('hidden');
                if (!leftRailLoaded) {
                    leftRailLoaded = true;
                    if (typeof googletag !== 'undefined' && googletag.cmd) {
                        googletag.cmd.push(function () {
                            googletag.display('site_8gwifi_org_lh_left_rail');
                        });
                    }
                }
            } else {
                rail.classList.add('hidden');
            }
        }
        // Start/stop ambient results background
        if (typeof LighthouseResultsBg !== 'undefined') {
            if (name === 'results') LighthouseResultsBg.start();
            else LighthouseResultsBg.stop();
        }
    }

    function resetState() {
        stopElapsed();
        stopPolling();
        auditId = null;
        jobId = null;
        pollCount = 0;
        elapsedSeconds = 0;
        currentResult = null;
        setButtonEnabled(true);
        window.location.hash = '';
        showSection('input');
    }

    function stopPolling() {
        if (pollTimer) { clearTimeout(pollTimer); pollTimer = null; }
    }

    function setButtonEnabled(enabled) {
        var btn = document.getElementById('lh-start-btn');
        btn.disabled = !enabled;
        btn.textContent = enabled ? 'Audit' : 'Auditing…';
    }

    function showError(msg) {
        var el = document.getElementById('lh-error-msg');
        el.textContent = msg;
        el.classList.add('show');
        setTimeout(function () { el.classList.remove('show'); }, 8000);
    }

    function getContextPath() {
        var meta = document.querySelector('meta[name="ctx"]');
        return meta ? meta.content : '';
    }

    // ── Audit submit ──

    // Robust URL validation (mirrors backend SSRF rules)
    function validateUrl(raw) {
        if (!raw || !raw.trim()) return { ok: false, error: 'Enter a URL' };
        var s = raw.trim();
        if (s.length > 2048) return { ok: false, error: 'URL is too long' };
        if (!/^https?:\/\//i.test(s)) s = 'https://' + s;

        var parsed;
        try { parsed = new URL(s); }
        catch (e) { return { ok: false, error: 'Invalid URL format' }; }

        var scheme = parsed.protocol.toLowerCase();
        if (scheme !== 'http:' && scheme !== 'https:') {
            return { ok: false, error: 'Only http and https URLs are supported' };
        }

        var host = parsed.hostname.toLowerCase();
        if (!host) return { ok: false, error: 'URL is missing a hostname' };

        var blocked = ['localhost', '127.0.0.1', '0.0.0.0', '::1', '[::1]'];
        if (blocked.indexOf(host) !== -1) {
            return { ok: false, error: 'Cannot audit local addresses' };
        }
        if (host.startsWith('192.168.') || host.startsWith('10.') ||
            /^172\.(1[6-9]|2[0-9]|3[0-1])\./.test(host) ||
            host.endsWith('.local') || host.endsWith('.internal')) {
            return { ok: false, error: 'Cannot audit private network addresses' };
        }
        // Must contain at least one dot (avoid bare names)
        if (host.indexOf('.') === -1) {
            return { ok: false, error: 'Hostname must include a domain (e.g. example.com)' };
        }

        return { ok: true, url: s };
    }

    function startAudit() {
        var urlEl = document.getElementById('lh-url');
        var v = validateUrl(urlEl.value);
        if (!v.ok) { showError(v.error); urlEl.focus(); return; }
        var url = v.url;
        urlEl.value = url;

        auditedUrl = url;
        var strategy = document.querySelector('.lh-strategy-btn.active').dataset.strategy;
        var categories = [];
        document.querySelectorAll('.lh-cat-checkbox input:checked').forEach(function (cb) {
            categories.push(cb.value);
        });
        if (categories.length === 0) {
            categories = ['performance', 'accessibility', 'best-practices', 'seo'];
        }

        setButtonEnabled(false);
        showSection('progress');
        document.getElementById('lh-progress-url').textContent = url;
        document.getElementById('lh-progress-text').textContent = 'Enqueuing audit…';
        startElapsed();

        // Step 1: enqueue (returns 202 with job_id immediately)
        fetch(getContextPath() + '/LighthouseFunctionality?action=audit', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ url: url, strategy: strategy, categories: categories })
        })
            .then(function (r) {
                if (r.status === 429) return r.json().then(function (d) { throw new Error(d.error || 'Server busy. Try again in a minute.'); });
                if (!r.ok) return r.json().then(function (d) { throw new Error(d.error || 'Could not enqueue audit'); });
                return r.json();
            })
            .then(function (data) {
                if (!data.job_id) throw new Error('Invalid response from server');
                jobId = data.job_id;
                pollCount = 0;

                var depth = data.queue_depth;
                if (depth && depth > 1) {
                    document.getElementById('lh-progress-text').textContent = 'Queued (position ' + depth + ')…';
                } else {
                    document.getElementById('lh-progress-text').textContent = 'Running Lighthouse audit…';
                }
                // Step 2: poll
                schedulePoll(1500);
            })
            .catch(function (err) {
                stopElapsed();
                showSection('input');
                setButtonEnabled(true);
                showError(err.message || 'Audit failed');
            });
    }

    function schedulePoll(delayMs) {
        stopPolling();
        pollTimer = setTimeout(pollJob, delayMs);
    }

    function pollJob() {
        if (!jobId) return;
        pollCount++;
        if (pollCount > MAX_POLLS) {
            stopElapsed();
            showSection('input');
            setButtonEnabled(true);
            showError('Audit is taking too long. Check your history page later.');
            return;
        }

        fetch(getContextPath() + '/LighthouseFunctionality?action=job&id=' + jobId)
            .then(function (r) {
                if (!r.ok) return r.json().then(function (d) { throw new Error(d.error || 'Job lookup failed'); });
                return r.json();
            })
            .then(function (data) {
                var status = data.status;

                if (status === 'queued') {
                    document.getElementById('lh-progress-text').textContent = 'Queued — waiting for worker…';
                    schedulePoll(2500);
                    return;
                }

                if (status === 'running') {
                    document.getElementById('lh-progress-text').textContent = 'Running Lighthouse audit…';
                    schedulePoll(2500);
                    return;
                }

                if (status === 'done' && data.result) {
                    stopPolling();
                    stopElapsed();
                    currentResult = data.result;
                    auditId = data.result.audit_id;
                    renderResults(data.result);
                    window.location.hash = 'id=' + data.result.audit_id;
                    showSection('results');
                    setButtonEnabled(true);
                    loadHistory();
                    return;
                }

                if (status === 'failed') {
                    stopPolling();
                    stopElapsed();
                    showSection('input');
                    setButtonEnabled(true);
                    showError(data.error || 'Audit failed. The page may be unreachable or too slow.');
                    return;
                }

                // Unknown status — keep polling
                schedulePoll(3000);
            })
            .catch(function (err) {
                stopPolling();
                stopElapsed();
                showSection('input');
                setButtonEnabled(true);
                showError(err.message || 'Could not check audit status');
            });
    }

    function startElapsed() {
        elapsedSeconds = 0;
        var el = document.getElementById('lh-elapsed');
        el.textContent = '0s';
        elapsedTimer = setInterval(function () {
            elapsedSeconds += 1;
            el.textContent = elapsedSeconds + 's';
        }, 1000);
    }

    function stopElapsed() {
        if (elapsedTimer) { clearInterval(elapsedTimer); elapsedTimer = null; }
    }

    // ── Render ──

    function renderResults(data) {
        // Header URL + meta
        var urlEl = document.getElementById('lh-results-url');
        urlEl.innerHTML = '<span class="lh-results-url-label">Audited:</span>' +
            '<a href="' + escAttr(data.url) + '" class="lh-results-url-link" target="_blank" rel="noopener">' + escHtml(data.url) + '</a>' +
            '<span class="lh-results-meta">' + (data.strategy || 'mobile') + ' &middot; ' + formatDate(data.fetched_at) + '</span>';

        // Category header: gauges | separator | screenshot
        var headerEl = document.getElementById('lh-category-header');
        var gauges = document.getElementById('lh-gauges');
        var ssWrap = document.getElementById('lh-screenshot-wrap');
        var sepEl = document.getElementById('lh-header-separator');
        gauges.innerHTML = '';
        var scoreOrder = ['performance', 'accessibility', 'best_practices', 'seo'];
        var labels = { performance: 'Performance', accessibility: 'Accessibility', best_practices: 'Best Practices', seo: 'SEO' };
        scoreOrder.forEach(function (k) {
            var v = data.scores && data.scores[k];
            if (v == null) return;
            gauges.appendChild(buildGaugeCard(labels[k], v));
        });

        // Final screenshot (beside gauges)
        if (data.screenshot && data.screenshot.data) {
            headerEl.classList.remove('no-screenshot');
            sepEl.style.display = '';
            ssWrap.style.display = '';
            ssWrap.innerHTML = '<img src="' + escAttr(data.screenshot.data) +
                '" class="lh-final-screenshot" alt="Final page screenshot">';
        } else {
            headerEl.classList.add('no-screenshot');
            sepEl.style.display = 'none';
            ssWrap.style.display = 'none';
        }

        // Filmstrip thumbnails
        var filmSection = document.getElementById('lh-filmstrip-section');
        var filmStrip = document.getElementById('lh-filmstrip-strip');
        if (data.thumbnails && data.thumbnails.length > 0 && filmSection && filmStrip) {
            filmSection.style.display = '';
            filmStrip.innerHTML = '';
            var minTs = data.thumbnails[0].timestamp;
            data.thumbnails.forEach(function (t) { if (t.timestamp < minTs) minTs = t.timestamp; });
            data.thumbnails.forEach(function (t) {
                var frame = document.createElement('div');
                frame.className = 'lh-filmstrip-frame';
                var relMs = t.timestamp - minTs;
                var label = relMs < 1000 ? Math.round(relMs) + ' ms' : (relMs / 1000).toFixed(1) + ' s';
                frame.innerHTML =
                    '<img src="' + escAttr(t.data) + '" class="lh-filmstrip-thumb" alt="' + escAttr(label) + '" loading="lazy">' +
                    '<span class="lh-filmstrip-ts">' + escHtml(label) + '</span>';
                filmStrip.appendChild(frame);
            });
        } else if (filmSection) {
            filmSection.style.display = 'none';
        }

        // Performance metrics (2-col grid with colored indicators)
        var cwvSection = document.getElementById('lh-cwv-section');
        if (data.core_web_vitals && Object.keys(data.core_web_vitals).length > 0) {
            cwvSection.style.display = '';
            var grid = document.getElementById('lh-cwv-grid');
            grid.innerHTML = '';
            // Ordered metrics matching Lighthouse
            var metricOrder = ['FCP', 'LCP', 'TBT', 'CLS', 'Speed Index', 'TTI', 'TTFB'];
            metricOrder.forEach(function (key) {
                var val = data.core_web_vitals[key];
                if (val == null) return;
                var color = metricScoreClass(key, val);
                var div = document.createElement('div');
                div.className = 'lh-metric';
                div.innerHTML =
                    '<div class="lh-metric-inner">' +
                    '  <div class="lh-metric-icon ' + color + '"></div>' +
                    '  <div class="lh-metric-title">' + escHtml(metricLabel(key)) + '</div>' +
                    '  <div class="lh-metric-value ' + color + '">' + escHtml(val) + '</div>' +
                    '</div>';
                grid.appendChild(div);
            });
            // Any remaining keys not in metricOrder
            Object.keys(data.core_web_vitals).forEach(function (key) {
                if (metricOrder.indexOf(key) !== -1) return;
                var val = data.core_web_vitals[key];
                var div = document.createElement('div');
                div.className = 'lh-metric';
                div.innerHTML =
                    '<div class="lh-metric-inner">' +
                    '  <div class="lh-metric-icon info"></div>' +
                    '  <div class="lh-metric-title">' + escHtml(key) + '</div>' +
                    '  <div class="lh-metric-value">' + escHtml(val) + '</div>' +
                    '</div>';
                grid.appendChild(div);
            });
        } else {
            cwvSection.style.display = 'none';
        }

        // Failed audits
        renderAuditSection('lh-failed-section', 'lh-failed-list', 'lh-failed-count',
            data.failed_audits || [], 'fail');

        // Passed audits
        renderAuditSection('lh-passed-section', 'lh-passed-list', 'lh-passed-count',
            data.passed_audits || [], 'pass');
    }

    // Full metric labels
    function metricLabel(key) {
        var map = {
            FCP: 'First Contentful Paint', LCP: 'Largest Contentful Paint',
            TBT: 'Total Blocking Time', CLS: 'Cumulative Layout Shift',
            TTI: 'Time to Interactive', TTFB: 'Time to First Byte'
        };
        return map[key] || key;
    }

    // Color-code metrics based on Web Vitals thresholds
    function metricScoreClass(key, displayValue) {
        var num = parseFloat(String(displayValue).replace(/[^\d.]/g, ''));
        if (isNaN(num)) return 'info';
        var isSec = /\bs\b/.test(displayValue) && !/\bms\b/.test(displayValue);
        var ms = isSec ? num * 1000 : num;
        // Thresholds: [good, needs-improvement] — above NI = fail
        var thresholds = {
            FCP: [1800, 3000], LCP: [2500, 4000], TBT: [200, 600],
            CLS: [0.1, 0.25], TTI: [3800, 7300], TTFB: [800, 1800],
            'Speed Index': [3400, 5800]
        };
        var t = thresholds[key];
        if (!t) return 'info';
        var val = (key === 'CLS') ? num : ms;
        if (val <= t[0]) return 'pass';
        if (val <= t[1]) return 'warn';
        return 'fail';
    }

    function buildGaugeCard(label, score0to100) {
        var card = document.createElement('div');
        card.className = 'lh-gauge-card';
        var color = scoreClass(score0to100);
        var circumference = 2 * Math.PI * 42;
        var dash = (score0to100 / 100) * circumference;
        card.innerHTML =
            '<div class="lh-gauge">' +
            '  <svg viewBox="0 0 100 100">' +
            '    <circle cx="50" cy="50" r="42" fill="none" stroke-width="8" class="lh-gauge-bg"></circle>' +
            '    <circle cx="50" cy="50" r="42" fill="none" stroke-width="8" class="lh-gauge-arc lh-' + color + '-bg"' +
            '      stroke-dasharray="' + dash + ' ' + (circumference - dash) + '"></circle>' +
            '  </svg>' +
            '  <div class="lh-gauge-value lh-' + color + '">' + score0to100 + '</div>' +
            '</div>' +
            '<div class="lh-gauge-label">' + escHtml(label) + '</div>';
        return card;
    }

    function scoreClass(score0to100) {
        if (score0to100 >= 90) return 'score-pass';
        if (score0to100 >= 50) return 'score-warn';
        return 'score-fail';
    }

    function renderAuditSection(sectionId, listId, countId, audits, kind) {
        var section = document.getElementById(sectionId);
        var listEl = document.getElementById(listId);
        var countEl = document.getElementById(countId);
        if (!section || !listEl || !countEl) return;
        if (!audits.length) { section.style.display = 'none'; return; }
        section.style.display = '';
        countEl.textContent = '(' + audits.length + ')';

        // Severity sort
        var sorted = audits.slice().sort(function (a, b) {
            var sa = (a.score == null) ? 1 : a.score;
            var sb = (b.score == null) ? 1 : b.score;
            return sa - sb;
        });

        listEl.innerHTML = '';
        sorted.forEach(function (a, idx) {
            var marker = kind === 'pass' ? 'pass' : (a.score === 0 ? 'fail' : (a.score == null ? 'info' : 'warn'));
            var dvColor = kind === 'pass' ? 'pass' : (a.score === 0 ? 'fail' : (a.score == null ? '' : 'warn'));
            var aiBtnId = sectionId + '-ai-' + idx;
            var aiCntId = sectionId + '-aic-' + idx;
            var hasBody = (a.description || a.details) && kind !== 'pass';

            var item = document.createElement('details');
            item.className = 'lh-audit-item';
            if (kind !== 'pass' && idx === 0) item.open = true;

            var summaryHtml =
                '<summary class="lh-audit-item-header">' +
                '  <span class="lh-audit-marker ' + marker + '"></span>' +
                '  <div class="lh-audit-title">' + escHtml(a.title) + '</div>' +
                (a.display_value ? '<div class="lh-audit-display-value ' + dvColor + '">' + escHtml(a.display_value) + '</div>' : '') +
                '  <span class="lh-audit-chev">&#9662;</span>' +
                '</summary>';

            var bodyHtml = '';
            if (hasBody) {
                bodyHtml += '<div class="lh-audit-body">';
                if (a.description) bodyHtml += '<div class="lh-audit-desc">' + linkify(a.description) + '</div>';
                if (a.details) bodyHtml += renderAuditDetails(a.details);
                if (kind !== 'pass' && typeof LighthouseAI !== 'undefined') {
                    bodyHtml +=
                        '<div class="lh-audit-actions">' +
                        '  <button class="lh-ai-fix-btn" id="' + aiBtnId + '" type="button">' +
                        '    <span aria-hidden="true">&#10024;</span> AI Fix' +
                        '  </button>' +
                        '</div>' +
                        '<div class="lh-ai-container" id="' + aiCntId + '" style="display:none;"></div>';
                }
                bodyHtml += '</div>';
            }

            item.innerHTML = summaryHtml + bodyHtml;
            listEl.appendChild(item);

            if (kind !== 'pass' && typeof LighthouseAI !== 'undefined') {
                var btn = document.getElementById(aiBtnId);
                var cnt = document.getElementById(aiCntId);
                if (btn && cnt) {
                    btn.addEventListener('click', function () {
                        LighthouseAI.requestFix(a, currentResult, cnt, btn);
                    });
                }
            }
        });

        var header = section.querySelector('.lh-audit-header');
        if (header && !header._wired) {
            header.addEventListener('click', function () { section.classList.toggle('collapsed'); });
            header._wired = true;
        }
        if (kind === 'pass') section.classList.add('collapsed');
        else section.classList.remove('collapsed');
    }

    // Render Lighthouse audit.details — dispatches on details.type
    // Handles: table, opportunity, list (with nested sections/tables), network-tree, criticalrequestchain
    function renderAuditDetails(details) {
        if (!details || !details.type) return '';
        var type = details.type;

        if (type === 'table' || type === 'opportunity') {
            var html = '';
            if (type === 'opportunity' && details.overall_savings_ms) {
                html += '<div class="lh-audit-savings">Est. savings: ' + formatMs(details.overall_savings_ms) + '</div>';
            }
            html += renderTableDetails(details.items || [], details.headings);
            return html;
        }

        if (type === 'list' || type === 'list-section') {
            // Each item may itself be a table / network-tree / list-section
            var items = details.items || [];
            if (!items.length) return '';
            return items.map(function (it) {
                // Nested table inside list
                if (it && it.type === 'table') {
                    return renderTableDetails(it.items || [], it.headings);
                }
                // Nested list-section with a value that is itself a details payload
                if (it && it.type === 'list-section') {
                    var label = it.label ? '<div class="lh-details-label">' + escHtml(it.label) + '</div>' : '';
                    return label + renderAuditDetails(it.value || it);
                }
                // Plain item
                return '<div class="lh-details-plain">' + escHtml(summarizeItem(it)) + '</div>';
            }).join('');
        }

        if (type === 'network-tree' || details.chains) {
            return renderNetworkTree(details.chains || {});
        }

        if (type === 'criticalrequestchain' && details.chains) {
            return renderNetworkTree(details.chains);
        }

        if (type === 'checklist' && details.items) {
            return '<ul class="lh-audit-details-list">' + details.items.map(function (it) {
                var ok = it.value === true || it.passed === true;
                return '<li class="' + (ok ? 'pass' : 'fail') + '">' +
                    '<span class="lh-check-mark">' + (ok ? '✓' : '✗') + '</span> ' +
                    escHtml(it.label || '') + '</li>';
            }).join('') + '</ul>';
        }

        if (type === 'code') {
            return '<pre class="lh-audit-code"><code>' + escHtml(details.value || '') + '</code></pre>';
        }

        return '';
    }

    function renderTableDetails(items, headings) {
        if (!items || !items.length) return '';
        var MAX = 8;
        var shown = items.slice(0, MAX);

        var keys, labels = {}, valueTypes = {};
        if (headings && headings.length) {
            keys = headings.map(function (h) { return h.key; }).filter(Boolean);
            headings.forEach(function (h) {
                if (h.key) {
                    labels[h.key] = h.label || h.text || h.key;
                    if (h.valueType) valueTypes[h.key] = h.valueType;
                }
            });
        } else {
            keys = Object.keys(shown[0] || {}).filter(function (k) { return k !== 'debugData' && k !== 'subItems'; });
        }
        if (!keys.length) return '';

        var html = '<div class="lh-audit-details-wrap"><table class="lh-audit-details-table"><thead><tr>';
        keys.forEach(function (k) {
            html += '<th>' + escHtml(labels[k] || humanize(k)) + '</th>';
        });
        html += '</tr></thead><tbody>';

        shown.forEach(function (it) {
            html += '<tr>';
            keys.forEach(function (k) {
                html += '<td>' + renderCellValue(it[k], k, valueTypes[k]) + '</td>';
            });
            html += '</tr>';
        });
        html += '</tbody></table>';

        if (items.length > MAX) {
            html += '<div class="lh-audit-more">+ ' + (items.length - MAX) + ' more rows</div>';
        }
        html += '</div>';
        return html;
    }

    // Render a cell value using the heading's valueType when available
    function renderCellValue(v, key, valueType) {
        if (v == null || v === '') return '';

        // Heading-driven rendering (preferred)
        if (valueType === 'url') {
            return linkCell(String(v));
        }
        if (valueType === 'bytes') {
            return formatBytes(Number(v) || 0);
        }
        if (valueType === 'ms' || valueType === 'timespanMs') {
            return formatMs(Number(v) || 0);
        }
        if (valueType === 'numeric') {
            return escHtml((Number(v) || 0).toLocaleString());
        }
        if (valueType === 'node' || (v && v.type === 'node')) {
            return renderNodeCell(v);
        }
        if (valueType === 'source-location' || (v && v.type === 'source-location')) {
            return renderSourceLocation(v);
        }
        if (valueType === 'code') {
            return '<code>' + escHtml(truncate(String(v), 120)) + '</code>';
        }
        if (valueType === 'link' && v && typeof v === 'object' && v.url) {
            return linkCell(v.url, v.text);
        }

        // Fallback: infer from value shape
        if (typeof v === 'number') {
            if (/bytes|size/i.test(key)) return formatBytes(v);
            if (/ms$|time|duration|latency/i.test(key) || /Ms$/.test(key)) return formatMs(v);
            return escHtml(v.toLocaleString());
        }
        if (typeof v === 'string') {
            if (/^https?:\/\//.test(v)) return linkCell(v);
            return escHtml(truncate(v, 100));
        }
        if (typeof v === 'object') {
            if (v.type === 'node') return renderNodeCell(v);
            if (v.type === 'source-location') return renderSourceLocation(v);
            if (v.snippet) return '<code>' + escHtml(truncate(v.snippet, 100)) + '</code>';
            if (v.selector) return '<code>' + escHtml(v.selector) + '</code>';
            if (v.url) return linkCell(v.url);
            return escHtml(truncate(JSON.stringify(v), 100));
        }
        return escHtml(String(v));
    }

    function linkCell(url, label) {
        if (!url) return '';
        var display = label || truncate(url, 70);
        return '<a href="' + escAttr(url) + '" target="_blank" rel="noopener" class="lh-audit-details-link" title="' + escAttr(url) + '">' + escHtml(display) + '</a>';
    }

    function renderNodeCell(n) {
        if (!n) return '';
        // Prefer showing the most identifying info: label > selector > snippet
        var lines = [];
        if (n.nodeLabel) lines.push('<div class="lh-node-label">' + escHtml(truncate(n.nodeLabel, 80)) + '</div>');
        if (n.selector) lines.push('<code class="lh-node-selector">' + escHtml(n.selector) + '</code>');
        if (n.snippet) lines.push('<div class="lh-node-snippet"><code>' + escHtml(truncate(n.snippet, 140)) + '</code></div>');
        return '<div class="lh-node-cell">' + lines.join('') + '</div>';
    }

    function renderSourceLocation(s) {
        if (!s || !s.url) return '';
        var loc = s.url;
        if (s.line != null) loc += ':' + s.line;
        if (s.column != null) loc += ':' + s.column;
        return linkCell(s.url, loc);
    }

    // Render a recursive network tree (used by network-dependency-tree + critical-request-chain)
    function renderNetworkTree(chains) {
        if (!chains || typeof chains !== 'object') return '';
        var keys = Object.keys(chains);
        if (!keys.length) return '';

        function renderChain(chain) {
            if (!chain) return '';
            var u = chain.url || '';
            var time = chain.navStartToEndTime || chain.duration || 0;
            var bytes = chain.transferSize || 0;
            var isLongest = chain.isLongest;
            var lbl = truncate(u, 90);
            var host = '';
            try { host = new URL(u).host; } catch (e) { host = ''; }

            var meta = [];
            if (time) meta.push(formatMs(time));
            if (bytes) meta.push(formatBytes(bytes));

            var html =
                '<li class="lh-net-node' + (isLongest ? ' lh-net-longest' : '') + '">' +
                '  <div class="lh-net-row">' +
                '    <a href="' + escAttr(u) + '" target="_blank" rel="noopener" class="lh-net-link" title="' + escAttr(u) + '">' +
                (host ? '<span class="lh-net-host">' + escHtml(host) + '</span> ' : '') +
                '<span class="lh-net-path">' + escHtml(lbl) + '</span>' +
                '    </a>' +
                (meta.length ? '<span class="lh-net-meta">' + meta.join(' &middot; ') + '</span>' : '') +
                (isLongest ? '<span class="lh-net-badge">longest</span>' : '') +
                '  </div>';

            var kids = chain.children || {};
            var kkeys = Object.keys(kids);
            if (kkeys.length) {
                html += '<ul class="lh-net-children">';
                kkeys.forEach(function (k) { html += renderChain(kids[k]); });
                html += '</ul>';
            }
            html += '</li>';
            return html;
        }

        var out = '<ul class="lh-net-tree">';
        keys.forEach(function (k) { out += renderChain(chains[k]); });
        out += '</ul>';
        return out;
    }

    function summarizeItem(it) {
        if (typeof it === 'string') return it;
        if (!it) return '';
        return it.url || it.source || it.text || it.label || JSON.stringify(it);
    }

    function formatBytes(n) {
        if (!n) return '0 B';
        if (n < 1024) return n + ' B';
        if (n < 1024 * 1024) return (n / 1024).toFixed(1) + ' KB';
        return (n / 1024 / 1024).toFixed(2) + ' MB';
    }

    function formatMs(n) {
        if (n < 1000) return Math.round(n) + ' ms';
        return (n / 1000).toFixed(2) + ' s';
    }

    function humanize(s) {
        return String(s).replace(/([A-Z])/g, ' $1').replace(/_/g, ' ').replace(/^./, function (c) { return c.toUpperCase(); });
    }

    function truncate(s, max) {
        if (!s) return '';
        return s.length > max ? s.substring(0, max - 1) + '…' : s;
    }

    // ── Share / hash deep-link ──

    function shareResults() {
        if (!auditId) return;
        var url = location.origin + location.pathname + '#id=' + auditId;
        if (navigator.clipboard && navigator.clipboard.writeText) {
            navigator.clipboard.writeText(url).then(function () {
                alert('Link copied to clipboard');
            }, function () { fallbackCopy(url); });
        } else {
            fallbackCopy(url);
        }
    }

    function fallbackCopy(s) {
        var ta = document.createElement('textarea');
        ta.value = s;
        document.body.appendChild(ta);
        ta.select();
        try { document.execCommand('copy'); alert('Link copied'); }
        catch (e) { prompt('Copy this link:', s); }
        document.body.removeChild(ta);
    }

    function loadFromHash() {
        var m = (location.hash || '').match(/id=(\d+)/);
        if (!m) return;
        loadAuditById(m[1]);
    }

    // ── History ──

    function loadHistory() {
        fetch(getContextPath() + '/LighthouseFunctionality?action=audits&limit=5')
            .then(function (r) { return r.ok ? r.json() : null; })
            .then(function (data) {
                if (!data || !data.audits || data.audits.length === 0) return;
                var el = document.getElementById('lh-history');
                if (!el) return;
                var html = '<div class="lh-history-title">Recent Audits</div><div class="lh-history-list">';
                data.audits.forEach(function (a) {
                    var perf = (a.scores && a.scores.performance) || 0;
                    var color = scoreClass(perf);
                    var domain = a.url.replace(/^https?:\/\//, '').replace(/\/.*$/, '');
                    var date = a.fetched_at ? formatDate(a.fetched_at) : '';
                    html += '<a class="lh-history-item" href="#id=' + a.audit_id + '" data-audit-id="' + a.audit_id + '">' +
                        '<span class="lh-history-score lh-' + color + '">' + perf + '</span>' +
                        '<span class="lh-history-url">' + escHtml(domain) + '</span>' +
                        '<span class="lh-history-strategy">' + escHtml(a.strategy || 'mobile') + '</span>' +
                        '<span class="lh-history-date">' + escHtml(date.split(',')[0]) + '</span>' +
                        '</a>';
                });
                html += '</div>';
                el.innerHTML = html;

                // Wire click handlers — load the audit inline, no reload
                el.querySelectorAll('.lh-history-item').forEach(function (a) {
                    a.addEventListener('click', function (e) {
                        e.preventDefault();
                        var id = this.getAttribute('data-audit-id');
                        if (id) loadAuditById(id);
                    });
                });
            })
            .catch(function () { /* silent */ });
    }

    // Load a saved audit by id — reuses the same flow as loadFromHash
    function loadAuditById(id) {
        resetState();  // clear any in-flight polling
        window.location.hash = 'id=' + id;
        showSection('progress');
        document.getElementById('lh-progress-text').textContent = 'Loading saved audit…';
        document.getElementById('lh-progress-hint').textContent = '';
        document.getElementById('lh-progress-url').textContent = '';

        fetch(getContextPath() + '/LighthouseFunctionality?action=get&id=' + id)
            .then(function (r) {
                if (!r.ok) throw new Error('Audit not found');
                return r.json();
            })
            .then(function (data) {
                currentResult = data;
                auditId = data.audit_id;
                auditedUrl = data.url;
                renderResults(data);
                showSection('results');
                // Scroll to top of results so the user sees the gauges
                window.scrollTo({ top: 0, behavior: 'smooth' });
            })
            .catch(function () {
                window.location.hash = '';
                showSection('input');
                showError('Could not load audit. It may have been deleted.');
            });
    }

    // ── Helpers ──

    function escHtml(s) {
        return String(s == null ? '' : s)
            .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    }
    function escAttr(s) {
        return escHtml(s).replace(/"/g, '&quot;');
    }
    function linkify(s) {
        // Lighthouse descriptions include markdown-style links and `code`
        var out = escHtml(s);
        out = out.replace(/`([^`\n]+)`/g, '<code>$1</code>');
        out = out.replace(/\[([^\]]+)\]\((https?:\/\/[^)]+)\)/g, '<a href="$2" target="_blank" rel="noopener">$1</a>');
        return out;
    }
    function formatDate(iso) {
        if (!iso) return '';
        try {
            var d = new Date(iso);
            return d.toLocaleString();
        } catch (e) { return iso; }
    }

})();
