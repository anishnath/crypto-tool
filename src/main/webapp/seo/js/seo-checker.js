/* SEO Checker — Main application logic
   Form submission, polling, results rendering, drilldown, export */

'use strict';

(function() {

    var state = 'idle';
    var crawlId = null;
    var crawledUrl = '';
    var pollTimer = null;
    var pollCount = 0;
    var MAX_POLLS = 300;
    var findingsData = null;
    var statusData = null;
    var currentDrilldownType = null;

    document.addEventListener('DOMContentLoaded', function() {
        document.getElementById('seo-crawl-form').addEventListener('submit', function(e) {
            e.preventDefault();
            startCrawl();
        });

        document.getElementById('seo-back-btn').addEventListener('click', function() {
            showSection('results');
        });

        document.getElementById('seo-new-scan-btn').addEventListener('click', function() {
            resetState();
        });

        document.getElementById('seo-rescan-btn').addEventListener('click', function() {
            // Pre-fill the URL and go back to input
            var urlInput = document.getElementById('seo-url');
            if (urlInput && crawledUrl) urlInput.value = crawledUrl;
            resetState();
        });

        document.getElementById('seo-export-btn').addEventListener('click', function() {
            exportCSV();
        });

        document.getElementById('seo-cancel-btn').addEventListener('click', function() {
            cancelCrawl();
        });

        // Advanced options toggle
        document.getElementById('seo-advanced-btn').addEventListener('click', function() {
            var panel = document.getElementById('seo-advanced-panel');
            var visible = panel.style.display !== 'none';
            panel.style.display = visible ? 'none' : 'flex';
            this.textContent = visible ? 'Advanced Options' : 'Hide Options';
        });

        // Share button
        document.getElementById('seo-share-btn').addEventListener('click', function() {
            shareResults();
        });

        // Check URL hash for shared crawl on load
        loadFromHash();

        // Load recent scan history
        loadHistory();
    });

    // ── State Management ──

    function showSection(name) {
        state = name;
        ['input', 'progress', 'results', 'drilldown'].forEach(function(s) {
            var el = document.getElementById('seo-' + s + '-section');
            if (el) el.style.display = (s === name) ? 'block' : 'none';
        });
    }

    function resetState() {
        stopPolling();
        crawlId = null;
        pollCount = 0;
        findingsData = null;
        statusData = null;
        setButtonEnabled(true);
        window.location.hash = '';
        showSection('input');
    }

    function cancelCrawl() {
        stopPolling();
        if (crawlId) {
            // Fire and forget — tell backend to stop
            fetch(getContextPath() + '/SEOCrawlFunctionality?action=cancel&id=' + crawlId, { method: 'POST' })
            .catch(function() {}); // ignore errors
        }
        resetState();
    }

    function stopPolling() {
        if (pollTimer) { clearTimeout(pollTimer); pollTimer = null; }
    }

    function setButtonEnabled(enabled) {
        var btn = document.getElementById('seo-start-btn');
        if (btn) btn.disabled = !enabled;
    }

    // ── Share / Load from URL hash ──

    function loadFromHash() {
        var hash = window.location.hash;

        // Support both #url=https://... and legacy #crawl=N
        var urlMatch = hash.match(/url=(.+)/);
        var crawlMatch = hash.match(/crawl=(\d+)/);

        if (urlMatch) {
            var sharedUrl = decodeURIComponent(urlMatch[1]);
            crawledUrl = sharedUrl;
            showSection('progress');
            updateProgress(-1, 'Loading results for ' + sharedUrl + '...');

            // Look up the latest crawl for this URL
            fetch(getContextPath() + '/SEOCrawlFunctionality?action=history&url=' + encodeURIComponent(sharedUrl) + '&limit=1')
            .then(function(r) { return r.json(); })
            .then(function(data) {
                if (!data.crawls || data.crawls.length === 0) {
                    // No crawl exists — pre-fill URL and show input
                    var urlInput = document.getElementById('seo-url');
                    if (urlInput) urlInput.value = sharedUrl;
                    showSection('input');
                    showError('No results found for this URL yet. Click Analyze to scan it.');
                    return;
                }

                var latest = data.crawls[0];
                crawlId = latest.crawl_id;
                statusData = latest;

                if (latest.crawling === true) {
                    pollStatus();
                    return;
                }

                fetchFindings();
            })
            .catch(function(err) {
                showSection('input');
                showError('Could not load results: ' + err.message);
            });
            return;
        }

        if (crawlMatch) {
            var sharedCrawlId = parseInt(crawlMatch[1]);
            if (isNaN(sharedCrawlId)) return;

            crawlId = sharedCrawlId;
            showSection('progress');
            updateProgress(-1, 'Loading shared results...');

            fetch(getContextPath() + '/SEOCrawlFunctionality?action=status&id=' + crawlId)
            .then(function(r) {
                if (!r.ok) throw new Error('Crawl not found');
                return r.json();
            })
            .then(function(data) {
                if (data.error) throw new Error(data.error);
                statusData = data;

                if (data.crawling === true) {
                    pollStatus();
                    return;
                }

                fetchFindings();
            })
            .catch(function(err) {
                crawlId = null;
                showSection('input');
                showError('Could not load shared results: ' + err.message);
            });
        }
    }

    function shareResults() {
        if (!crawledUrl) return;
        var shareUrl = window.location.origin + window.location.pathname + '#url=' + encodeURIComponent(crawledUrl);

        if (navigator.clipboard && navigator.clipboard.writeText) {
            navigator.clipboard.writeText(shareUrl).then(function() {
                showShareToast('Link copied to clipboard!');
            }).catch(function() {
                showSharePrompt(shareUrl);
            });
        } else {
            showSharePrompt(shareUrl);
        }
    }

    function showShareToast(msg) {
        var toast = document.createElement('div');
        toast.className = 'seo-share-toast';
        toast.textContent = msg;
        document.body.appendChild(toast);
        setTimeout(function() {
            toast.classList.add('seo-toast-fade');
            setTimeout(function() { toast.remove(); }, 300);
        }, 2000);
    }

    function showSharePrompt(url) {
        prompt('Copy this link to share your SEO report:', url);
    }

    // ── Start Crawl ──

    // ── URL Validation ──

    function validateUrl(url) {
        // Must start with http:// or https://
        if (!/^https?:\/\/.+/i.test(url)) {
            return 'Please enter a valid URL starting with http:// or https://';
        }

        // Parse and validate structure
        try {
            var parsed = new URL(url);

            // Must have a real hostname (not empty, not just a dot)
            if (!parsed.hostname || parsed.hostname.length < 2) {
                return 'Invalid hostname. Please enter a valid domain.';
            }

            // Block localhost / private IPs
            var host = parsed.hostname.toLowerCase();
            if (host === 'localhost' || host === '127.0.0.1' || host === '0.0.0.0' ||
                host === '::1' || host.startsWith('192.168.') || host.startsWith('10.') ||
                host.startsWith('172.16.') || host.startsWith('172.17.') || host.startsWith('172.18.') ||
                host.startsWith('172.19.') || host.startsWith('172.2') || host.startsWith('172.30.') ||
                host.startsWith('172.31.') || host.endsWith('.local') || host.endsWith('.internal')) {
                return 'Cannot scan private/local addresses.';
            }

            // Must have a TLD (at least one dot in hostname)
            if (host.indexOf('.') === -1) {
                return 'Please enter a full domain with TLD (e.g., example.com).';
            }

            // Block common non-website schemes that might slip through
            if (parsed.protocol !== 'http:' && parsed.protocol !== 'https:') {
                return 'Only http:// and https:// URLs are supported.';
            }

        } catch (e) {
            return 'Invalid URL format.';
        }

        return null; // valid
    }

    function startCrawl() {
        var urlInput = document.getElementById('seo-url');
        var url = urlInput ? urlInput.value.trim() : '';
        if (!url) return;

        // Client-side validation
        var validationError = validateUrl(url);
        if (validationError) {
            showError(validationError);
            return;
        }

        crawledUrl = url;
        setButtonEnabled(false);
        showSection('progress');

        var urlEl = document.getElementById('seo-progress-url');
        if (urlEl) urlEl.textContent = url;
        updateProgress(-1, 'Checking if site is reachable...');

        // Preflight: check if URL is reachable before starting crawl
        fetch(getContextPath() + '/SEOCrawlFunctionality?action=preflight&url=' + encodeURIComponent(url))
        .then(function(r) { return r.json(); })
        .then(function(data) {
            if (data.reachable === false) {
                throw new Error(data.error || 'Site is not reachable. Please check the URL.');
            }
            // Site is reachable — start the crawl
            updateProgress(-1, 'Starting crawl...');
            return submitCrawl(url);
        })
        .catch(function(err) {
            setButtonEnabled(true);
            showSection('input');
            showError(err.message);
        });
    }

    function submitCrawl(url) {
        var body = { url: url };
        if (isChecked('seo-opt-sitemap')) body.crawl_sitemap = true;
        if (isChecked('seo-opt-external')) body.check_external_links = true;
        if (isChecked('seo-opt-nofollow')) body.follow_nofollow = true;
        if (isChecked('seo-opt-noindex')) body.include_noindex = true;
        if (isChecked('seo-opt-robots')) body.ignore_robots_txt = true;
        if (isChecked('seo-opt-subdomains')) body.allow_subdomains = true;

        return fetch(getContextPath() + '/SEOCrawlFunctionality?action=crawl', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(body)
        })
        .then(function(r) {
            if (r.status === 429) {
                return r.json().then(function(data) {
                    throw new Error(data.error || 'Rate limit exceeded. Please wait a few minutes.');
                });
            }
            if (!r.ok) {
                return r.json().then(function(data) {
                    throw new Error(data.error || 'API returned ' + r.status);
                }).catch(function() { throw new Error('API returned ' + r.status); });
            }
            return r.json();
        })
        .then(function(data) {
            if (data.error) throw new Error(data.error);
            crawlId = data.crawl_id;
            pollCount = 0;
            pollStatus();
        })
        .catch(function(err) {
            setButtonEnabled(true);
            showSection('input');
            showError(err.message);
        });
    }

    // ── Poll Status ──

    function pollStatus() {
        if (!crawlId) return;

        fetch(getContextPath() + '/SEOCrawlFunctionality?action=status&id=' + crawlId)
        .then(function(r) {
            if (!r.ok) throw new Error('Status check failed');
            return r.json();
        })
        .then(function(data) {
            if (data.error) throw new Error(data.error);
            statusData = data;

            if (data.crawling === false) {
                stopPolling();
                updateProgress(100, 'Crawl complete! Loading results...', false);
                fetchFindings();
                return;
            }

            var urls = data.total_urls || 0;
            var msg = 'Crawling... ' + urls + ' URL' + (urls !== 1 ? 's' : '') + ' discovered';
            if (pollCount > 30) msg += ' (large site, please wait)';
            updateProgress(-1, msg, true);

            pollCount++;
            if (pollCount < MAX_POLLS) {
                pollTimer = setTimeout(pollStatus, 2000);
            } else {
                stopPolling();
                updateProgress(-1, 'Crawl is taking longer than expected. It will continue in the background.', false);
            }
        })
        .catch(function(err) {
            stopPolling();
            if (pollCount < 3) {
                pollCount++;
                pollTimer = setTimeout(pollStatus, 3000);
                return;
            }
            setButtonEnabled(true);
            showSection('input');
            showError('Error checking crawl status: ' + err.message);
        });
    }

    // ── Fetch Findings ──

    function fetchFindings() {
        fetch(getContextPath() + '/SEOCrawlFunctionality?action=findings&id=' + crawlId)
        .then(function(r) {
            if (!r.ok) throw new Error('Failed to fetch results');
            return r.json();
        })
        .then(function(data) {
            if (data.error) throw new Error(data.error);
            findingsData = data;
            // Set URL hash for sharing
            // Set shareable URL hash
            if (crawledUrl) {
                window.location.hash = 'url=' + encodeURIComponent(crawledUrl);
            } else {
                window.location.hash = 'crawl=' + crawlId;
            }
            renderResults(data);
            showSection('results');
        })
        .catch(function(err) {
            setButtonEnabled(true);
            showSection('input');
            showError('Error fetching results: ' + err.message);
        });
    }

    // ── Render Results ──

    function renderResults(data) {
        var score = calculateSeoScore(data);
        var grade = getScoreGrade(score);

        // Show analyzed URL in results header
        var resultsUrlEl = document.getElementById('seo-results-url');
        if (resultsUrlEl) {
            resultsUrlEl.innerHTML = '<span class="seo-results-url-label">Results for</span> <a href="' + escapeHtml(crawledUrl) + '" target="_blank" rel="noopener" class="seo-results-url-link">' + escapeHtml(crawledUrl) + '</a>';
            if (statusData) {
                resultsUrlEl.innerHTML += '<span class="seo-results-meta">' + (statusData.total_urls || 0) + ' pages crawled';
                if (statusData.robotstxt_exists) resultsUrlEl.innerHTML += ' &middot; robots.txt found';
                if (statusData.sitemap_exists) resultsUrlEl.innerHTML += ' &middot; sitemap found';
                resultsUrlEl.innerHTML += '</span>';
            }
        }

        // Score circle
        var scoreEl = document.getElementById('seo-score-container');
        if (scoreEl) {
            var circumference = 2 * Math.PI * 54;
            scoreEl.innerHTML =
                '<div class="seo-score-card">' +
                '  <svg class="seo-score-svg" viewBox="0 0 120 120">' +
                '    <circle cx="60" cy="60" r="54" fill="none" stroke="#e2e8f0" stroke-width="8"/>' +
                '    <circle cx="60" cy="60" r="54" fill="none" stroke="' + grade.color + '" stroke-width="8" ' +
                '      stroke-dasharray="' + circumference + '" stroke-dashoffset="' + circumference + '" ' +
                '      stroke-linecap="round" transform="rotate(-90 60 60)" class="seo-score-ring" ' +
                '      style="transition:stroke-dashoffset 1.2s ease;"/>' +
                '    <text x="60" y="55" text-anchor="middle" font-size="28" font-weight="700" fill="' + grade.color + '">' + score + '</text>' +
                '    <text x="60" y="72" text-anchor="middle" font-size="10" font-weight="500" fill="#64748b">' + grade.label + '</text>' +
                '  </svg>' +
                '</div>';
            requestAnimationFrame(function() {
                requestAnimationFrame(function() {
                    var ring = scoreEl.querySelector('.seo-score-ring');
                    if (ring) ring.setAttribute('stroke-dashoffset', circumference - (score / 100) * circumference);
                });
            });
        }

        // Summary counts
        var summaryEl = document.getElementById('seo-summary');
        if (summaryEl) {
            var critCount = countIssues(data.critical);
            var alertCount = countIssues(data.alert);
            var warnCount = countIssues(data.warning);
            summaryEl.innerHTML =
                '<div class="seo-summary-stat seo-stat-critical"><span class="seo-stat-num">' + critCount + '</span><span class="seo-stat-label">Critical</span></div>' +
                '<div class="seo-summary-stat seo-stat-alert"><span class="seo-stat-num">' + alertCount + '</span><span class="seo-stat-label">Alerts</span></div>' +
                '<div class="seo-summary-stat seo-stat-warning"><span class="seo-stat-num">' + warnCount + '</span><span class="seo-stat-label">Warnings</span></div>';
        }

        // Issue groups
        var issuesEl = document.getElementById('seo-issues-container');
        if (issuesEl) {
            var html = '';
            var groups = [
                { key: 'critical', label: 'Critical Issues', cls: 'critical' },
                { key: 'alert', label: 'Alerts', cls: 'alert' },
                { key: 'warning', label: 'Warnings', cls: 'warning' }
            ];

            groups.forEach(function(group) {
                var issues = data[group.key] || [];
                if (issues.length === 0) return;
                html += renderIssueGroup(group, issues);
            });

            if (!html) {
                html = '<div class="seo-no-issues">No issues found! Your site looks great.</div>';
            }

            issuesEl.innerHTML = html;

            // Event delegation
            issuesEl.addEventListener('click', function(e) {
                var row = e.target.closest('.seo-issue-row');
                if (row) {
                    var type = row.getAttribute('data-type');
                    if (type) showDrilldown(type);
                }
            });
        }

        // Passed checks
        renderPassedChecks(data);
    }

    function renderIssueGroup(group, issues) {
        var html = '<div class="seo-issue-group seo-group-' + group.cls + '">';
        html += '<h3 class="seo-group-title seo-group-title-' + group.cls + '">' + escapeHtml(group.label) + ' <span class="seo-group-count">' + issues.length + ' types</span></h3>';

        issues.forEach(function(issue) {
            var meta = getIssueMeta(issue.error_type);
            html += '<div class="seo-issue-row" data-type="' + escapeHtml(issue.error_type) + '">';
            html += '  <div class="seo-issue-info">';
            html += '    <span class="seo-issue-title">' + escapeHtml(meta.title) + '</span>';
            html += '    <span class="seo-issue-desc">' + escapeHtml(meta.desc) + '</span>';
            html += '  </div>';
            html += '  <div class="seo-issue-right">';
            html += '    <span class="seo-issue-count">' + issue.count + ' page' + (issue.count !== 1 ? 's' : '') + '</span>';
            html += '    <svg class="seo-issue-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"/></svg>';
            html += '  </div>';
            html += '</div>';
        });

        html += '</div>';
        return html;
    }

    // ── Passed Checks ──

    function renderPassedChecks(data) {
        var passedEl = document.getElementById('seo-passed-container');
        if (!passedEl) return;

        // Collect all issue types that were found
        var foundTypes = {};
        ['critical', 'alert', 'warning'].forEach(function(group) {
            (data[group] || []).forEach(function(issue) {
                foundTypes[issue.error_type] = true;
            });
        });

        // Find all known types that are NOT in the findings
        var passed = [];
        Object.keys(SEO_ISSUES).forEach(function(type) {
            if (!foundTypes[type]) {
                passed.push({ type: type, meta: SEO_ISSUES[type] });
            }
        });

        if (passed.length === 0) {
            passedEl.innerHTML = '';
            return;
        }

        var html = '<div class="seo-issue-group seo-group-passed">';
        html += '<h3 class="seo-group-title seo-group-title-passed">Passed Checks <span class="seo-group-count">' + passed.length + ' checks</span></h3>';
        html += '<div class="seo-passed-grid">';
        passed.forEach(function(p) {
            html += '<span class="seo-passed-tag">' + escapeHtml(p.meta.title) + '</span>';
        });
        html += '</div></div>';
        passedEl.innerHTML = html;
    }

    // ── Drill-down ──

    function showDrilldown(errorType) {
        currentDrilldownType = errorType;
        var meta = getIssueMeta(errorType);
        var titleEl = document.getElementById('seo-drilldown-title');
        var descEl = document.getElementById('seo-drilldown-desc');
        var pagesEl = document.getElementById('seo-drilldown-pages');

        if (titleEl) titleEl.textContent = meta.title;
        if (descEl) descEl.textContent = meta.desc;
        if (pagesEl) pagesEl.innerHTML = '<div class="seo-loading">Loading affected pages...</div>';

        showSection('drilldown');

        fetch(getContextPath() + '/SEOCrawlFunctionality?action=pages&id=' + crawlId + '&type=' + encodeURIComponent(errorType))
        .then(function(r) {
            if (!r.ok) throw new Error('Failed to load pages');
            return r.json();
        })
        .then(function(data) {
            if (data.error) throw new Error(data.error);
            var pages = data.pages || [];
            var html = '';

            if (pages.length === 0) {
                html = '<div class="seo-no-issues">No pages found for this issue.</div>';
            } else {
                html = '<div class="seo-pages-header">' + data.page_count + ' affected page' + (data.page_count !== 1 ? 's' : '') + '</div>';
                html += '<div class="seo-pages-list">';
                pages.forEach(function(page) {
                    var statusCls = page.status_code >= 400 ? 'seo-status-error' : (page.status_code >= 300 ? 'seo-status-redirect' : 'seo-status-ok');
                    html += '<div class="seo-page-row">';
                    html += '  <span class="seo-page-status ' + statusCls + '">' + page.status_code + '</span>';
                    html += '  <div class="seo-page-info">';
                    if (page.title) html += '<span class="seo-page-title">' + escapeHtml(page.title) + '</span>';
                    html += '    <a class="seo-page-url" href="' + escapeHtml(page.url) + '" target="_blank" rel="noopener">' + escapeHtml(page.url) + '</a>';
                    html += '  </div>';
                    html += '  <button class="seo-detail-btn" data-pid="' + page.id + '">Details</button>';
                    html += '</div>';
                });
                html += '</div>';
            }

            if (pagesEl) {
                pagesEl.innerHTML = html;
                pagesEl.addEventListener('click', function(e) {
                    var btn = e.target.closest('.seo-detail-btn');
                    if (btn) {
                        e.preventDefault();
                        var pid = btn.getAttribute('data-pid');
                        if (pid) showPageDetail(pid, btn.closest('.seo-page-row'));
                    }
                });
            }
        })
        .catch(function(err) {
            if (pagesEl) pagesEl.innerHTML = '<div class="seo-error">Failed to load pages: ' + escapeHtml(err.message) + '</div>';
        });
    }

    // ── Page Detail Panel ──

    function showPageDetail(pageId, rowEl) {
        var existing = document.querySelector('.seo-page-detail');
        if (existing) existing.remove();

        var panel = document.createElement('div');
        panel.className = 'seo-page-detail';
        panel.innerHTML = '<div class="seo-loading">Loading page details...</div>';
        rowEl.parentNode.insertBefore(panel, rowEl.nextSibling);

        fetch(getContextPath() + '/SEOCrawlFunctionality?action=page&id=' + crawlId + '&pid=' + pageId)
        .then(function(r) {
            if (!r.ok) throw new Error('Failed to load page details');
            return r.json();
        })
        .then(function(p) {
            if (p.error) throw new Error(p.error);
            var html = '<div class="seo-detail-grid">';

            html += '<div class="seo-detail-section">';
            html += '<h4>Page Info</h4>';
            html += detailRow('Title', p.title, p.title_length ? ' (' + p.title_length + ' chars)' : '');
            html += detailRow('Description', p.description ? (p.description.substring(0, 120) + (p.description.length > 120 ? '...' : '')) : '(none)', p.description_length ? ' (' + p.description_length + ' chars)' : '');
            html += detailRow('H1', p.h1 || '(none)');
            html += detailRow('H2', p.h2 || '(none)');
            html += detailRow('Canonical', p.canonical || '(none)');
            html += detailRow('Language', p.lang || '(none)');
            html += detailRow('Words', p.words);
            if (p.redirect_url) html += detailRow('Redirects to', p.redirect_url);
            html += '</div>';

            html += '<div class="seo-detail-section">';
            html += '<h4>Technical</h4>';
            html += detailRow('Status', p.status_code);
            html += detailRow('Content Type', p.content_type);
            html += detailRow('Size', p.size_bytes ? Math.round(p.size_bytes / 1024) + ' KB' : '?');
            html += detailRow('TTFB', p.ttfb_ms ? p.ttfb_ms + ' ms' : '?');
            html += detailRow('Depth', p.depth);
            html += detailRow('Robots', p.robots || '(none)');
            html += detailRow('In Sitemap', p.in_sitemap ? 'Yes' : 'No');
            html += detailRow('Blocked', p.blocked_by_robotstxt ? 'Yes' : 'No');
            html += '</div>';

            html += '</div>';

            if (p.issues && p.issues.length > 0) {
                html += '<div class="seo-detail-issues">';
                html += '<h4>Issues on this page (' + p.issues.length + ')</h4>';
                p.issues.forEach(function(issueType) {
                    var meta = getIssueMeta(issueType);
                    html += '<span class="seo-detail-issue-tag">' + escapeHtml(meta.title) + '</span>';
                });
                html += '</div>';
            }

            if (p.images && p.images.length > 0) {
                html += '<div class="seo-detail-images">';
                html += '<h4>Images (' + p.images.length + ', ' + (p.images_missing_alt_count || 0) + ' missing alt)</h4>';
                p.images.slice(0, 10).forEach(function(img) {
                    html += '<div class="seo-detail-img-row">';
                    html += '<span class="seo-detail-img-alt">' + (img.alt ? escapeHtml(img.alt) : '<em>no alt</em>') + '</span>';
                    html += '<span class="seo-detail-img-url">' + escapeHtml(img.url) + '</span>';
                    html += '</div>';
                });
                if (p.images.length > 10) html += '<div style="font-size:0.7rem;color:#94a3b8;padding:0.2rem 0;">...and ' + (p.images.length - 10) + ' more</div>';
                html += '</div>';
            }

            // AI Fix button + response container
            html += '<div class="seo-ai-section">';
            html += '<button class="seo-ai-fix-btn">AI Fix Suggestion</button>';
            html += '<div class="seo-ai-container" style="display:none;"></div>';
            html += '</div>';

            html += '<button class="seo-detail-close" onclick="this.closest(\'.seo-page-detail\').remove()">Close</button>';
            panel.innerHTML = html;

            // Wire AI Fix button — store page data in closure, not in HTML attribute
            var pageData = p;
            var aiBtn = panel.querySelector('.seo-ai-fix-btn');
            if (aiBtn) {
                aiBtn.addEventListener('click', function() {
                    var aiContainer = this.parentNode.querySelector('.seo-ai-container');
                    if (typeof SeoAI !== 'undefined' && currentDrilldownType) {
                        SeoAI.requestFix(currentDrilldownType, pageData, aiContainer);
                    }
                });
            }
        })
        .catch(function(err) {
            panel.innerHTML = '<div class="seo-error">' + escapeHtml(err.message) + '</div>';
        });
    }

    function detailRow(label, value, suffix) {
        return '<div class="seo-detail-row"><span class="seo-detail-label">' + escapeHtml(label) + '</span><span class="seo-detail-value">' + escapeHtml(String(value || '')) + (suffix ? escapeHtml(suffix) : '') + '</span></div>';
    }

    // ── Export CSV ──

    function exportCSV() {
        if (!findingsData) return;
        var rows = [['Severity', 'Issue Type', 'Title', 'Affected Pages']];
        ['critical', 'alert', 'warning'].forEach(function(group) {
            (findingsData[group] || []).forEach(function(issue) {
                var meta = getIssueMeta(issue.error_type);
                rows.push([group.toUpperCase(), issue.error_type, meta.title, issue.count]);
            });
        });

        var csv = rows.map(function(r) {
            return r.map(function(cell) {
                return '"' + String(cell).replace(/"/g, '""') + '"';
            }).join(',');
        }).join('\n');

        var blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
        var url = URL.createObjectURL(blob);
        var a = document.createElement('a');
        a.href = url;
        a.download = '8gwifi-seo-report-' + new Date().toISOString().slice(0, 10) + '.csv';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
    }

    // ── Helpers ──

    function countIssues(arr) {
        return (arr || []).reduce(function(s, i) { return s + i.count; }, 0);
    }

    function updateProgress(percent, message) {
        var barEl = document.getElementById('seo-progress-bar');
        var textEl = document.getElementById('seo-progress-text');
        if (textEl) textEl.textContent = message;
        if (barEl) {
            if (percent < 0) {
                barEl.style.width = '100%';
                barEl.classList.add('seo-progress-indeterminate');
            } else {
                barEl.classList.remove('seo-progress-indeterminate');
                barEl.style.width = percent + '%';
            }
        }
    }

    function showError(msg) {
        var el = document.getElementById('seo-error-msg');
        if (el) {
            el.textContent = msg;
            el.style.display = 'block';
            // Don't auto-hide — user must dismiss or it stays visible
        }
    }

    function isChecked(id) {
        var el = document.getElementById(id);
        return el ? el.checked : false;
    }

    function getContextPath() {
        var meta = document.querySelector('meta[name="ctx"]');
        return meta ? meta.getAttribute('content') : '';
    }

    function escapeHtml(str) {
        if (!str) return '';
        var div = document.createElement('div');
        div.textContent = str;
        return div.innerHTML;
    }

    // ── History ──

    function loadHistory() {
        var el = document.getElementById('seo-history');
        if (!el) return;

        fetch(getContextPath() + '/SEOCrawlFunctionality?action=history&limit=5')
        .then(function(r) { return r.ok ? r.json() : null; })
        .then(function(data) {
            if (!data || !data.crawls || data.crawls.length === 0) return;

            var html = '<div class="seo-history-title">Recent Scans</div>';
            html += '<div class="seo-history-list">';
            data.crawls.forEach(function(c) {
                var score = 100;
                // Estimate score from aggregate counts
                score -= (c.critical_issues || 0) * 10;
                score -= (c.alert_issues || 0) * 3;
                score -= (c.warning_issues || 0) * 1;
                score = Math.max(0, Math.min(100, score));
                var grade = getScoreGrade(score);

                var domain = c.url.replace(/^https?:\/\//, '').replace(/\/.*$/, '');
                var date = c.finished_at || c.started_at || '';

                html += '<a class="seo-history-item" href="#crawl=' + c.crawl_id + '" onclick="location.hash=\'crawl=' + c.crawl_id + '\';location.reload();return false;">';
                html += '<span class="seo-history-score" style="color:' + grade.color + '">' + score + '</span>';
                html += '<span class="seo-history-domain">' + escapeHtml(domain) + '</span>';
                html += '<span class="seo-history-pages">' + (c.total_urls || 0) + ' pages</span>';
                if (date) html += '<span class="seo-history-date">' + escapeHtml(date.split(' ')[0]) + '</span>';
                html += '</a>';
            });
            html += '</div>';
            el.innerHTML = html;
        })
        .catch(function() {}); // silent fail — history is optional
    }

})();
