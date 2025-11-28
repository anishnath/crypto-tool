<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Reverse DNS Lookup Tool Online - PTR Record, IP to Hostname | 8gwifi.org</title>
    <meta name="description" content="Free online Reverse DNS lookup tool. Convert IP addresses to hostnames using PTR records. Supports bulk IP lookups for IPv4 addresses." />
    <meta name="keywords" content="reverse dns lookup, ptr record lookup, ip to hostname, rdns lookup, reverse ip lookup, ptr lookup, ip to domain, reverse dns checker" />
    <meta name="robots" content="index,follow" />
    <meta name="author" content="Anish Nath" />
    <link rel="canonical" href="https://8gwifi.org/revdns.jsp" />

    <!-- Open Graph for social sharing -->
    <meta property="og:title" content="Reverse DNS Lookup - IP to Hostname Converter" />
    <meta property="og:description" content="Convert IP addresses to hostnames using PTR records. Free online reverse DNS lookup tool with bulk IP support." />
    <meta property="og:type" content="website" />
    <meta property="og:url" content="https://8gwifi.org/revdns.jsp" />
    <meta property="og:image" content="https://8gwifi.org/images/site/dns.png" />

    <!-- JSON-LD WebApplication Schema -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "Reverse DNS Lookup Tool",
        "alternateName": ["PTR Record Lookup", "IP to Hostname Converter", "rDNS Lookup", "Reverse IP Lookup"],
        "description": "Online reverse DNS (PTR) lookup tool to find hostnames associated with IP addresses. Supports bulk IP lookups for network analysis and security research.",
        "url": "https://8gwifi.org/revdns.jsp",
        "image": "https://8gwifi.org/images/site/dns.png",
        "applicationCategory": "NetworkApplication",
        "operatingSystem": "Any",
        "browserRequirements": "Requires JavaScript",
        "softwareVersion": "2.0",
        "featureList": [
            "Single IP reverse DNS lookup",
            "Bulk IP address processing",
            "PTR record resolution",
            "IP to hostname conversion",
            "Lookup duration tracking",
            "JSON API support",
            "IPv4 address support"
        ],
        "screenshot": "https://8gwifi.org/images/site/dns.png",
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
        },
        "author": {
            "@type": "Person",
            "name": "Anish Nath",
            "url": "https://x.com/anish2good"
        },
        "publisher": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org"
        },
        "datePublished": "2021-02-08",
        "dateModified": "2025-01-28",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "audience": {
            "@type": "Audience",
            "audienceType": "Network Administrators, Security Researchers, System Administrators, IT Professionals, DevOps Engineers"
        }
    }
    </script>

    <!-- JSON-LD FAQPage Schema for Rich Snippets -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "FAQPage",
        "mainEntity": [
            {
                "@type": "Question",
                "name": "What is reverse DNS lookup?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Reverse DNS lookup is the process of resolving an IP address back to its associated hostname. Unlike forward DNS that converts domain names to IP addresses, reverse DNS does the opposite - it finds the domain name associated with an IP address by querying PTR (Pointer) records in the in-addr.arpa or ip6.arpa zones."
                }
            },
            {
                "@type": "Question",
                "name": "What is a PTR record?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "A PTR (Pointer) record is a DNS record type used for reverse DNS lookups. It maps an IP address to a canonical hostname. PTR records are stored in special zones: for IPv4, the IP octets are reversed and appended to 'in-addr.arpa' (e.g., 1.1.168.192.in-addr.arpa for 192.168.1.1). PTR records are essential for email server verification and network troubleshooting."
                }
            },
            {
                "@type": "Question",
                "name": "Why is reverse DNS important for email servers?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Reverse DNS is crucial for email delivery. Most email servers check if the sending server's IP address has a valid PTR record that matches its hostname (Forward-Confirmed reverse DNS or FCrDNS). Emails from servers without proper reverse DNS are often rejected or marked as spam. This helps prevent email spoofing and spam."
                }
            },
            {
                "@type": "Question",
                "name": "How do I set up reverse DNS for my server?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Reverse DNS records are typically managed by your IP address provider (ISP or hosting company), not your domain registrar. Contact your IP provider and request them to create a PTR record for your IP address pointing to your hostname. For cloud providers like AWS, GCP, or Azure, you can usually configure reverse DNS through their control panel."
                }
            },
            {
                "@type": "Question",
                "name": "What does 'no PTR record' mean?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "When a reverse DNS lookup returns 'no PTR record' or an error, it means no hostname is configured for that IP address. This is common for consumer ISP connections, some cloud instances by default, or misconfigured servers. While not always problematic, missing PTR records can cause issues with email delivery and may be flagged by security tools."
                }
            },
            {
                "@type": "Question",
                "name": "Can an IP address have multiple PTR records?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "While technically possible to have multiple PTR records for a single IP, it's not recommended and rarely done. RFC 1035 suggests only one PTR record per IP address. Multiple PTR records can cause unpredictable behavior in applications that expect a single hostname and may cause issues with email server verification."
                }
            }
        ]
    }
    </script>

    <!-- JSON-LD HowTo Schema -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "HowTo",
        "name": "How to Perform a Reverse DNS Lookup",
        "description": "Step-by-step guide to convert IP addresses to hostnames",
        "step": [
            {
                "@type": "HowToStep",
                "name": "Enter IP Address",
                "text": "Enter one or more IP addresses (comma-separated for bulk lookup)"
            },
            {
                "@type": "HowToStep",
                "name": "Click Lookup",
                "text": "Click the Reverse DNS Lookup button to query PTR records"
            },
            {
                "@type": "HowToStep",
                "name": "Review Results",
                "text": "Review the hostnames associated with each IP address, along with any errors and lookup duration"
            }
        ]
    }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        :root {
            --theme-primary: #7c3aed;
            --theme-secondary: #8b5cf6;
            --theme-gradient: linear-gradient(135deg, #7c3aed 0%, #8b5cf6 100%);
            --theme-light: #f5f3ff;
        }
        .tool-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(124, 58, 237, 0.15);
            transition: box-shadow 0.3s ease;
        }
        .tool-card:hover {
            box-shadow: 0 4px 20px rgba(124, 58, 237, 0.25);
        }
        .card-header-custom {
            background: var(--theme-gradient);
            color: white;
            border-radius: 12px 12px 0 0 !important;
            padding: 0.75rem 1rem;
        }
        .card-header-custom h5 {
            margin: 0;
            font-weight: 600;
            font-size: 1rem;
        }
        .form-section {
            background: var(--theme-light);
            border-radius: 8px;
            padding: 0.75rem;
            margin-bottom: 0.75rem;
        }
        .form-section-title {
            font-weight: 600;
            color: var(--theme-primary);
            margin-bottom: 0.5rem;
            font-size: 0.85rem;
        }
        .result-card {
            border: 2px dashed #dee2e6;
            border-radius: 12px;
            min-height: 350px;
        }
        .result-placeholder {
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
            min-height: 300px;
        }
        .result-content {
            display: none;
        }
        .eeat-badge {
            background: var(--theme-gradient);
            color: white;
            padding: 0.35rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        .info-badge {
            display: inline-block;
            background: var(--theme-light);
            color: var(--theme-primary);
            padding: 0.2rem 0.5rem;
            border-radius: 20px;
            font-size: 0.7rem;
            margin-right: 0.25rem;
        }
        .preset-btn {
            padding: 0.4rem 0.75rem;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            background: white;
            cursor: pointer;
            font-size: 0.75rem;
            transition: all 0.2s;
        }
        .preset-btn:hover {
            border-color: var(--theme-primary);
            background: var(--theme-light);
        }
        .result-table {
            font-size: 0.85rem;
        }
        .result-table th {
            background: var(--theme-light);
            color: var(--theme-primary);
            font-weight: 600;
            padding: 0.5rem;
        }
        .result-table td {
            padding: 0.5rem;
            vertical-align: middle;
        }
        .hostname-cell {
            font-family: monospace;
            font-size: 0.85rem;
            word-break: break-all;
        }
        .ip-cell {
            font-family: monospace;
            font-weight: 600;
            color: var(--theme-primary);
        }
        .duration-badge {
            background: #e9ecef;
            color: #495057;
            padding: 0.15rem 0.4rem;
            border-radius: 4px;
            font-size: 0.7rem;
            font-family: monospace;
        }
        .status-success { color: #059669; }
        .status-error { color: #dc2626; }
        .related-tools {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 1rem;
        }
        .related-tool-card {
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 1rem;
            text-decoration: none;
            color: inherit;
            transition: all 0.2s;
        }
        .related-tool-card:hover {
            border-color: var(--theme-primary);
            box-shadow: 0 2px 8px rgba(124, 58, 237, 0.2);
            text-decoration: none;
        }
        .related-tool-card h6 { color: var(--theme-primary); margin-bottom: 0.25rem; font-size: 0.9rem; }
        .related-tool-card p { font-size: 0.75rem; color: #6c757d; margin: 0; }
        .terminal-block { background: #1e1e1e; border-radius: 8px; overflow: hidden; }
        .terminal-header { background: #323232; color: #d4d4d4; padding: 0.5rem 1rem; font-size: 0.75rem; display: flex; justify-content: space-between; align-items: center; }
        .terminal-body { padding: 1rem; color: #4ec9b0; font-family: monospace; font-size: 0.8rem; }
        .terminal-body code { color: #ce9178; }
    </style>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="network-tools-navbar.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-2">
    <div>
        <h1 class="h4 mb-0">Reverse DNS Lookup</h1>
        <div class="mt-1">
            <span class="info-badge"><i class="fas fa-exchange-alt"></i> PTR</span>
            <span class="info-badge"><i class="fas fa-server"></i> IP to Host</span>
            <span class="info-badge"><i class="fas fa-list"></i> Bulk</span>
        </div>
    </div>
    <div class="eeat-badge">
        <i class="fas fa-user-check"></i>
        <span>Anish Nath</span>
    </div>
</div>

<div class="row">
    <!-- Left Column: Input Form -->
    <div class="col-lg-5 mb-4">
        <div class="card tool-card">
            <div class="card-header card-header-custom">
                <h5><i class="fas fa-undo me-2"></i>Reverse DNS Lookup</h5>
            </div>
            <div class="card-body">
                <form id="revdnsForm">
                    <!-- IP Address Input -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-network-wired me-1"></i>IP Address(es)</div>
                        <textarea class="form-control" id="ips" name="ips" rows="3" placeholder="Enter IP addresses (one per line or comma-separated)&#10;e.g., 8.8.8.8&#10;or 8.8.8.8, 1.1.1.1, 9.9.9.9"></textarea>
                        <small class="text-muted">Supports single IP or multiple IPs (comma-separated)</small>
                    </div>

                    <!-- Quick Examples -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-bookmark me-1"></i>Popular DNS Servers</div>
                        <div class="d-flex gap-2 flex-wrap">
                            <button type="button" class="preset-btn" onclick="applyPreset('8.8.8.8')">Google (8.8.8.8)</button>
                            <button type="button" class="preset-btn" onclick="applyPreset('1.1.1.1')">Cloudflare (1.1.1.1)</button>
                            <button type="button" class="preset-btn" onclick="applyPreset('9.9.9.9')">Quad9 (9.9.9.9)</button>
                            <button type="button" class="preset-btn" onclick="applyPreset('208.67.222.222')">OpenDNS</button>
                        </div>
                    </div>

                    <!-- Bulk Examples -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-layer-group me-1"></i>Bulk Lookup</div>
                        <button type="button" class="preset-btn w-100" onclick="applyBulk()">
                            <i class="fas fa-list me-1"></i>Load Multiple DNS Servers
                        </button>
                    </div>

                    <button type="submit" class="btn w-100" id="lookupBtn" style="background: var(--theme-gradient); color: white; font-weight: 600;">
                        <i class="fas fa-search me-2"></i>Reverse DNS Lookup
                    </button>
                </form>
            </div>
        </div>

        <!-- How PTR Works -->
        <div class="card tool-card mt-3">
            <div class="card-header bg-dark text-white py-2">
                <h6 class="mb-0"><i class="fas fa-info-circle me-2"></i>How Reverse DNS Works</h6>
            </div>
            <div class="card-body small">
                <p class="mb-2"><strong>1. IP Reversal:</strong> The IP octets are reversed</p>
                <code class="d-block mb-2 p-2 bg-light">192.168.1.1 → 1.1.168.192</code>
                <p class="mb-2"><strong>2. Zone Append:</strong> Added to in-addr.arpa</p>
                <code class="d-block mb-2 p-2 bg-light">1.1.168.192.in-addr.arpa</code>
                <p class="mb-0"><strong>3. PTR Query:</strong> DNS returns hostname</p>
            </div>
        </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-7 mb-4">
        <div class="card tool-card result-card">
            <div class="card-header card-header-custom d-flex justify-content-between align-items-center">
                <h5 class="mb-0"><i class="fas fa-list me-2"></i>PTR Records <span id="queryCount" class="badge bg-light text-dark ms-2" style="display:none;">0</span></h5>
                <div id="resultActions" style="display: none;">
                    <button class="btn btn-sm btn-light me-1" onclick="shareResults()"><i class="fas fa-share-alt"></i></button>
                    <button class="btn btn-sm btn-light" onclick="copyResults()"><i class="fas fa-copy"></i></button>
                </div>
            </div>
            <div class="card-body">
                <div class="result-placeholder" id="resultPlaceholder">
                    <div class="text-center">
                        <i class="fas fa-exchange-alt fa-3x mb-3 text-muted"></i>
                        <p class="mb-0">PTR records will appear here</p>
                        <small class="text-muted">Enter IP address(es) and click Reverse DNS Lookup</small>
                    </div>
                </div>
                <div class="result-content" id="resultContent">
                    <div class="table-responsive">
                        <table class="table table-hover result-table mb-0">
                            <thead>
                            <tr>
                                <th>IP Address</th>
                                <th>Hostname(s)</th>
                                <th>Duration</th>
                            </tr>
                            </thead>
                            <tbody id="resultsBody"></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- CLI Commands -->
        <div class="card tool-card mt-3">
            <div class="card-header bg-dark text-white py-2">
                <h6 class="mb-0"><i class="fas fa-terminal me-2"></i>CLI Commands</h6>
            </div>
            <div class="card-body p-0">
                <div class="terminal-block">
                    <div class="terminal-header">
                        <span>Linux/Mac: Reverse DNS with dig</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand('dig -x 8.8.8.8')"><i class="fas fa-copy"></i></button>
                    </div>
                    <div class="terminal-body">$ dig <code>-x 8.8.8.8</code></div>
                </div>
                <div class="terminal-block mt-2">
                    <div class="terminal-header">
                        <span>Linux/Mac: Using host command</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand('host 8.8.8.8')"><i class="fas fa-copy"></i></button>
                    </div>
                    <div class="terminal-body">$ host <code>8.8.8.8</code></div>
                </div>
                <div class="terminal-block mt-2">
                    <div class="terminal-header">
                        <span>Windows: Reverse DNS with nslookup</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand('nslookup 8.8.8.8')"><i class="fas fa-copy"></i></button>
                    </div>
                    <div class="terminal-body">C:\> nslookup <code>8.8.8.8</code></div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Related Tools -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light py-2">
        <h6 class="mb-0"><i class="fas fa-tools me-2"></i>Related Network Tools</h6>
    </div>
    <div class="card-body">
        <div class="related-tools">
            <a href="dns.jsp" class="related-tool-card">
                <h6><i class="fas fa-search me-1"></i>DNS Lookup</h6>
                <p>Query DNS records for domains</p>
            </a>
            <a href="dmarc.jsp" class="related-tool-card">
                <h6><i class="fas fa-envelope me-1"></i>DMARC Lookup</h6>
                <p>Check email authentication</p>
            </a>
            <a href="whois.jsp" class="related-tool-card">
                <h6><i class="fas fa-user me-1"></i>Whois Lookup</h6>
                <p>Domain registration info</p>
            </a>
            <a href="SubnetFunctions.jsp" class="related-tool-card">
                <h6><i class="fas fa-calculator me-1"></i>Subnet Calculator</h6>
                <p>Calculate IP subnets</p>
            </a>
            <a href="pingfunctions.jsp" class="related-tool-card">
                <h6><i class="fas fa-satellite-dish me-1"></i>Ping Tool</h6>
                <p>Test host reachability</p>
            </a>
            <a href="portscan.jsp" class="related-tool-card">
                <h6><i class="fas fa-shield-alt me-1"></i>Port Scanner</h6>
                <p>Scan open ports on host</p>
            </a>
        </div>
    </div>
</div>

<%@ include file="thanks.jsp"%>

<!-- Educational Content -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light">
        <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding Reverse DNS</h5>
    </div>
    <div class="card-body">
        <h6>What is Reverse DNS?</h6>
        <p>Reverse DNS (rDNS) is a DNS lookup that resolves an IP address to its associated hostname. Unlike forward DNS that translates domain names to IP addresses, reverse DNS does the opposite. It uses PTR (Pointer) records stored in special zones like in-addr.arpa (IPv4) or ip6.arpa (IPv6).</p>

        <h6 class="mt-4">Common Use Cases</h6>
        <div class="row">
            <div class="col-md-6">
                <div class="alert alert-info">
                    <h6><i class="fas fa-envelope me-1"></i>Email Server Verification</h6>
                    <p class="small mb-0">Most mail servers check reverse DNS to verify sender legitimacy. Missing or mismatched PTR records often result in emails being rejected or marked as spam.</p>
                </div>
            </div>
            <div class="col-md-6">
                <div class="alert alert-warning">
                    <h6><i class="fas fa-file-alt me-1"></i>Server Logging</h6>
                    <p class="small mb-0">Web servers and network devices use reverse DNS to log hostnames instead of IP addresses, making logs more readable and easier to analyze.</p>
                </div>
            </div>
        </div>

        <h6 class="mt-4">Forward-Confirmed Reverse DNS (FCrDNS)</h6>
        <p>FCrDNS is a security verification where the reverse DNS hostname must also resolve back to the original IP address. This two-way verification helps prevent IP spoofing and is commonly required by email servers.</p>

        <div class="table-responsive mt-3">
            <table class="table table-bordered table-sm">
                <thead class="table-light">
                <tr><th>Check</th><th>Description</th><th>Example</th></tr>
                </thead>
                <tbody class="small">
                <tr><td><strong>Step 1</strong></td><td>Reverse lookup: IP → Hostname</td><td>8.8.8.8 → dns.google</td></tr>
                <tr><td><strong>Step 2</strong></td><td>Forward lookup: Hostname → IP</td><td>dns.google → 8.8.8.8</td></tr>
                <tr><td><strong>Result</strong></td><td>If both match, FCrDNS passes</td><td>Verified sender</td></tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@ include file="addcomments.jsp"%>
</div>

<!-- Share URL Modal -->
<div class="modal fade" id="shareUrlModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header" style="background: var(--theme-gradient); color: white;">
                <h5 class="modal-title"><i class="fas fa-share-alt"></i> Share Reverse DNS Lookup</h5>
                <button type="button" class="close text-white" data-dismiss="modal"><span>&times;</span></button>
            </div>
            <div class="modal-body">
                <div class="input-group">
                    <input type="text" class="form-control" id="shareUrlText" readonly>
                    <button class="btn btn-success" type="button" id="copyShareUrl"><i class="fas fa-copy"></i> Copy</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    var lastIps = null;
    var lastResults = null;

    $(document).ready(function() {
        loadFromUrl();

        $('#revdnsForm').submit(function(e) {
            e.preventDefault();
            performLookup();
        });

        $('#copyShareUrl').click(function() {
            navigator.clipboard.writeText($('#shareUrlText').val()).then(function() {
                $('#copyShareUrl').html('<i class="fas fa-check"></i> Copied!');
                setTimeout(function() { $('#copyShareUrl').html('<i class="fas fa-copy"></i> Copy'); }, 1500);
            });
        });
    });

    function applyPreset(ip) {
        $('#ips').val(ip);
        showToast('Applied: ' + ip);
    }

    function applyBulk() {
        $('#ips').val('8.8.8.8, 8.8.4.4, 1.1.1.1, 1.0.0.1, 9.9.9.9, 208.67.222.222');
        showToast('Loaded multiple DNS servers');
    }

    function performLookup() {
        var ips = $('#ips').val().trim();
        if (!ips) { showToast('Please enter IP address(es)'); return; }

        // Normalize input: replace newlines with commas
        ips = ips.replace(/[\n\r]+/g, ',').replace(/\s+/g, '');
        lastIps = ips;

        $('#lookupBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Looking up...');

        $.ajax({
            type: 'GET',
            url: 'RevDnsFunctionality',
            data: { ip: ips },
            dataType: 'json',
            success: function(data) {
                $('#lookupBtn').prop('disabled', false).html('<i class="fas fa-search me-2"></i>Reverse DNS Lookup');
                lastResults = data;
                renderResults(data);
            },
            error: function(xhr) {
                $('#lookupBtn').prop('disabled', false).html('<i class="fas fa-search me-2"></i>Reverse DNS Lookup');
                var msg = 'Lookup failed. Please try again.';
                if (xhr.responseJSON && xhr.responseJSON.error) {
                    msg = xhr.responseJSON.error;
                }
                showError(msg);
            }
        });
    }

    function renderResults(data) {
        if (!data || !data.results) {
            showError('Empty response received.');
            return;
        }

        var rows = '';
        for (var i = 0; i < data.results.length; i++) {
            var r = data.results[i];
            var hostnames = '';
            var statusClass = 'status-success';

            if (r.hostnames && r.hostnames.length) {
                hostnames = r.hostnames.map(function(h) {
                    return '<span class="hostname-cell">' + h + '</span>';
                }).join('<br>');
            } else if (r.error) {
                hostnames = '<span class="status-error"><i class="fas fa-exclamation-circle me-1"></i>' + r.error + '</span>';
                statusClass = 'status-error';
            } else {
                hostnames = '<span class="text-muted">No PTR record</span>';
            }

            var duration = (typeof r.duration_seconds !== 'undefined')
                ? '<span class="duration-badge">' + r.duration_seconds + 's</span>'
                : '-';

            rows += '<tr>' +
                '<td class="ip-cell">' + (r.ip || '') + '</td>' +
                '<td>' + hostnames + '</td>' +
                '<td>' + duration + '</td>' +
                '</tr>';
        }

        $('#resultsBody').html(rows);
        $('#queryCount').text(data.query_count || data.results.length || 0).show();
        $('#resultPlaceholder').hide();
        $('#resultContent').show();
        $('#resultActions').show();
    }

    function showError(message) {
        var html = '<div class="alert alert-danger"><i class="fas fa-exclamation-circle me-2"></i>' + message + '</div>';
        $('#resultPlaceholder').hide();
        $('#resultsBody').empty();
        $('#resultContent').html(html).show();
    }

    function shareResults() {
        if (!lastIps) return;
        var url = window.location.origin + window.location.pathname + '?ip=' + encodeURIComponent(lastIps);
        $('#shareUrlText').val(url);
        $('#shareUrlModal').modal('show');
    }

    function copyResults() {
        if (!lastResults || !lastResults.results) return;
        var text = lastResults.results.map(function(r) {
            var host = (r.hostnames && r.hostnames.length) ? r.hostnames.join(', ') : (r.error || 'No PTR');
            return r.ip + ' → ' + host;
        }).join('\n');
        navigator.clipboard.writeText(text).then(function() { showToast('Results copied!'); });
    }

    function loadFromUrl() {
        var params = new URLSearchParams(window.location.search);
        var ip = params.get('ip');
        if (ip) {
            $('#ips').val(ip);
            setTimeout(function() { performLookup(); }, 500);
        }
    }

    function copyCommand(cmd) {
        navigator.clipboard.writeText(cmd).then(function() { showToast('Command copied!'); });
    }

    function showToast(message) {
        var toast = $('<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999;"><div class="toast show"><div class="toast-body text-white rounded" style="background: var(--theme-gradient);"><i class="fas fa-info-circle me-2"></i>' + message + '</div></div></div>');
        $('body').append(toast);
        setTimeout(function() { toast.fadeOut(function() { toast.remove(); }); }, 2000);
    }
</script>

<%@ include file="body-close.jsp"%>
