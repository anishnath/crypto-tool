<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>DMARC Record Lookup & Validator – Free | 8gwifi.org</title>
    <meta name="description" content="Free online DMARC record checker and validator. Lookup DMARC policies, analyze email authentication settings, and verify domain email security configuration." />
    <meta name="keywords" content="dmarc lookup, dmarc record checker, dmarc validator, email authentication, dmarc policy, email security, spf dkim dmarc, domain email protection" />
    <meta name="robots" content="index,follow" />
    <meta name="author" content="Anish Nath" />
    <link rel="canonical" href="https://8gwifi.org/dmarc.jsp" />

    <!-- Open Graph for social sharing -->
    <meta property="og:title" content="DMARC Record Checker - Email Authentication Lookup" />
    <meta property="og:description" content="Validate and analyze DMARC records for any domain. Check email authentication policies and security configuration." />
    <meta property="og:type" content="website" />
    <meta property="og:url" content="https://8gwifi.org/dmarc.jsp" />
    <meta property="og:image" content="https://8gwifi.org/images/site/dmarc.png" />
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content="DMARC Record Lookup & Validator" />
    <meta name="twitter:description" content="Check and validate DMARC records (SPF/DKIM alignment, policy, rua/ruf). Free DMARC checker for domain email security." />
    <meta name="twitter:image" content="https://8gwifi.org/images/site/dmarc.png" />

    <!-- JSON-LD WebApplication Schema -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "DMARC Record Checker",
        "alternateName": ["DMARC Lookup", "DMARC Validator", "Email Authentication Checker", "DMARC Policy Analyzer"],
        "description": "Free online DMARC record checker to lookup and validate email authentication policies. Analyze DMARC, SPF, and DKIM configurations for domain email security.",
        "url": "https://8gwifi.org/dmarc.jsp",
        "image": "https://8gwifi.org/images/site/dmarc.png",
        "applicationCategory": "NetworkApplication",
        "operatingSystem": "Any",
        "browserRequirements": "Requires JavaScript",
        "softwareVersion": "2.0",
        "featureList": [
            "DMARC record lookup",
            "Policy tag analysis",
            "Reporting URI extraction",
            "Alignment mode detection",
            "Email security validation",
            "TXT record parsing"
        ],
        "screenshot": "https://8gwifi.org/images/site/dmarc.png",
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
            "audienceType": "Email Administrators, Security Professionals, Domain Owners, IT Professionals, DevOps Engineers"
        }
    }
    </script>

    <!-- JSON-LD FAQPage Schema -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "FAQPage",
        "mainEntity": [
            {
                "@type": "Question",
                "name": "What is DMARC and why is it important?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "DMARC (Domain-based Message Authentication, Reporting & Conformance) is an email authentication protocol that helps prevent email spoofing and phishing. It builds on SPF and DKIM to tell receiving mail servers what to do when authentication fails, protecting your domain from being used in fraudulent emails."
                }
            },
            {
                "@type": "Question",
                "name": "What does a DMARC policy of 'none', 'quarantine', or 'reject' mean?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "The DMARC policy (p=) tells receivers how to handle failed messages: 'none' monitors without action (good for initial deployment), 'quarantine' sends failures to spam/junk folder, and 'reject' blocks the message entirely. Start with 'none' to collect reports, then gradually move to 'reject' for maximum protection."
                }
            },
            {
                "@type": "Question",
                "name": "What are rua and ruf in DMARC records?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "rua (Reporting URI for Aggregate reports) specifies where to send daily aggregate reports about email authentication results. ruf (Reporting URI for Forensic reports) specifies where to send detailed failure reports for individual messages. Both use mailto: URIs like 'mailto:dmarc@example.com'."
                }
            },
            {
                "@type": "Question",
                "name": "How do I create a DMARC record for my domain?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Create a TXT record at _dmarc.yourdomain.com with your policy. A basic record looks like: 'v=DMARC1; p=none; rua=mailto:dmarc@yourdomain.com'. Start with p=none to monitor, ensure SPF and DKIM are properly configured, then upgrade to p=quarantine or p=reject after reviewing reports."
                }
            },
            {
                "@type": "Question",
                "name": "What is DMARC alignment and why does it matter?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "DMARC alignment ensures the domain in the From header matches domains used in SPF and DKIM authentication. 'Relaxed' alignment (aspf=r, adkim=r) allows subdomains to match, while 'strict' (aspf=s, adkim=s) requires exact domain matches. Relaxed is default and usually sufficient."
                }
            },
            {
                "@type": "Question",
                "name": "How long does it take for DMARC changes to take effect?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "DMARC record changes depend on DNS TTL (Time To Live). Typically, changes propagate within 24-48 hours, but can be faster if you set a lower TTL before making changes. The 'ri' tag in DMARC specifies the reporting interval (default 86400 seconds = 24 hours)."
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
        "name": "How to Check DMARC Records for a Domain",
        "description": "Step-by-step guide to lookup and analyze DMARC email authentication policies",
        "step": [
            {
                "@type": "HowToStep",
                "name": "Enter Domain Name",
                "text": "Enter the domain name you want to check (e.g., google.com, microsoft.com)"
            },
            {
                "@type": "HowToStep",
                "name": "Click DMARC Lookup",
                "text": "Click the lookup button to query the _dmarc TXT record for the domain"
            },
            {
                "@type": "HowToStep",
                "name": "Analyze Results",
                "text": "Review the DMARC policy tags including p (policy), rua (aggregate reports), aspf/adkim (alignment modes)"
            }
        ]
    }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        :root {
            --theme-primary: #4f46e5;
            --theme-secondary: #6366f1;
            --theme-gradient: linear-gradient(135deg, #4f46e5 0%, #6366f1 100%);
            --theme-light: #eef2ff;
        }
        .tool-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(79, 70, 229, 0.15);
            transition: box-shadow 0.3s ease;
        }
        .tool-card:hover {
            box-shadow: 0 4px 20px rgba(79, 70, 229, 0.25);
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
            min-height: 400px;
        }
        .result-placeholder {
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
            min-height: 350px;
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
            box-shadow: 0 2px 8px rgba(79, 70, 229, 0.2);
            text-decoration: none;
        }
        .related-tool-card h6 { color: var(--theme-primary); margin-bottom: 0.25rem; font-size: 0.9rem; }
        .related-tool-card p { font-size: 0.75rem; color: #6c757d; margin: 0; }
        .terminal-block { background: #1e1e1e; border-radius: 8px; overflow: hidden; }
        .terminal-header { background: #323232; color: #d4d4d4; padding: 0.5rem 1rem; font-size: 0.75rem; display: flex; justify-content: space-between; align-items: center; }
        .terminal-body { padding: 1rem; color: #4ec9b0; font-family: monospace; font-size: 0.8rem; }
        .terminal-body code { color: #ce9178; }
        .dmarc-output {
            background: #f8fafc;
            border-radius: 8px;
            padding: 1rem;
            max-height: 500px;
            overflow-y: auto;
        }
        .dmarc-output table {
            font-size: 0.85rem;
        }
        .tag-table th {
            background: var(--theme-light);
            color: var(--theme-primary);
        }
    </style>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="network-tools-navbar.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-2">
    <div>
        <h1 class="h4 mb-0">DMARC Record Checker</h1>
        <div class="mt-1">
            <span class="info-badge"><i class="fas fa-shield-alt"></i> Email Security</span>
            <span class="info-badge"><i class="fas fa-envelope"></i> Authentication</span>
            <span class="info-badge"><i class="fas fa-file-alt"></i> TXT Record</span>
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
                <h5><i class="fas fa-shield-alt me-2"></i>DMARC Lookup</h5>
            </div>
            <div class="card-body">
                <form id="dmarcForm">
                    <input type="hidden" name="methodName" value="NETWORKDNSCOMMANDDMARC">

                    <!-- Domain Input -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-globe me-1"></i>Domain Name</div>
                        <input type="text" class="form-control" id="ipaddress" name="ipaddress" value="google.com" placeholder="e.g., google.com, microsoft.com">
                        <small class="text-muted">Enter domain without _dmarc prefix</small>
                    </div>

                    <!-- Quick Presets -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-bookmark me-1"></i>Quick Presets</div>
                        <div class="d-flex gap-2 flex-wrap mb-2">
                            <button type="button" class="preset-btn" onclick="applyPreset('google.com')">google.com</button>
                            <button type="button" class="preset-btn" onclick="applyPreset('microsoft.com')">microsoft.com</button>
                            <button type="button" class="preset-btn" onclick="applyPreset('amazon.com')">amazon.com</button>
                        </div>
                        <div class="d-flex gap-2 flex-wrap">
                            <button type="button" class="preset-btn" onclick="applyPreset('github.com')">github.com</button>
                            <button type="button" class="preset-btn" onclick="applyPreset('cloudflare.com')">cloudflare.com</button>
                            <button type="button" class="preset-btn" onclick="applyPreset('paypal.com')">paypal.com</button>
                        </div>
                    </div>

                    <button type="submit" class="btn w-100" id="dmarcBtn" style="background: var(--theme-gradient); color: white; font-weight: 600;">
                        <i class="fas fa-search me-2"></i>Lookup DMARC
                    </button>
                </form>
            </div>
        </div>

        <!-- DMARC Tags Reference -->
        <div class="card tool-card mt-3">
            <div class="card-header bg-dark text-white py-2">
                <h6 class="mb-0"><i class="fas fa-tags me-2"></i>Common DMARC Tags</h6>
            </div>
            <div class="card-body small p-2">
                <div class="d-flex justify-content-between mb-1">
                    <span><code>v</code> Version</span>
                    <span class="text-muted">DMARC1</span>
                </div>
                <div class="d-flex justify-content-between mb-1">
                    <span><code>p</code> Policy</span>
                    <span class="text-muted">none/quarantine/reject</span>
                </div>
                <div class="d-flex justify-content-between mb-1">
                    <span><code>rua</code> Aggregate Reports</span>
                    <span class="text-muted">mailto:...</span>
                </div>
                <div class="d-flex justify-content-between mb-1">
                    <span><code>ruf</code> Forensic Reports</span>
                    <span class="text-muted">mailto:...</span>
                </div>
                <div class="d-flex justify-content-between mb-1">
                    <span><code>pct</code> Percentage</span>
                    <span class="text-muted">0-100</span>
                </div>
                <div class="d-flex justify-content-between">
                    <span><code>sp</code> Subdomain Policy</span>
                    <span class="text-muted">none/quarantine/reject</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-7 mb-4">
        <div class="card tool-card result-card">
            <div class="card-header card-header-custom d-flex justify-content-between align-items-center">
                <h5 class="mb-0"><i class="fas fa-file-alt me-2"></i>DMARC Results</h5>
                <div id="resultActions" style="display: none;">
                    <button class="btn btn-sm btn-light me-1" onclick="shareResults()"><i class="fas fa-share-alt"></i></button>
                    <button class="btn btn-sm btn-light" onclick="copyResults()"><i class="fas fa-copy"></i></button>
                </div>
            </div>
            <div class="card-body">
                <div class="result-placeholder" id="resultPlaceholder">
                    <div class="text-center">
                        <i class="fas fa-shield-alt fa-3x mb-3 text-muted"></i>
                        <p class="mb-0">DMARC results will appear here</p>
                        <small class="text-muted">Enter a domain and click Lookup DMARC</small>
                    </div>
                </div>
                <div class="result-content" id="resultContent">
                    <div class="dmarc-output" id="dmarcOutput"></div>
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
                        <span>Lookup DMARC with dig</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand('dig TXT _dmarc.google.com +short')"><i class="fas fa-copy"></i></button>
                    </div>
                    <div class="terminal-body">$ dig TXT <code>_dmarc.google.com</code> +short</div>
                </div>
                <div class="terminal-block mt-2">
                    <div class="terminal-header">
                        <span>Using nslookup</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand('nslookup -type=TXT _dmarc.google.com')"><i class="fas fa-copy"></i></button>
                    </div>
                    <div class="terminal-body">$ nslookup <code>-type=TXT _dmarc.google.com</code></div>
                </div>
                <div class="terminal-block mt-2">
                    <div class="terminal-header">
                        <span>Using host command</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand('host -t TXT _dmarc.google.com')"><i class="fas fa-copy"></i></button>
                    </div>
                    <div class="terminal-body">$ host <code>-t TXT _dmarc.google.com</code></div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Related Tools -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light py-2">
        <h6 class="mb-0"><i class="fas fa-tools me-2"></i>Related Email & DNS Tools</h6>
    </div>
    <div class="card-body">
        <div class="related-tools">
            <a href="dns.jsp" class="related-tool-card">
                <h6><i class="fas fa-search me-1"></i>DNS Lookup</h6>
                <p>Query all DNS record types</p>
            </a>
            <a href="revdns.jsp" class="related-tool-card">
                <h6><i class="fas fa-undo me-1"></i>Reverse DNS</h6>
                <p>IP to hostname lookup</p>
            </a>
            <a href="dnsresolver.jsp" class="related-tool-card">
                <h6><i class="fas fa-server me-1"></i>DNS Resolver</h6>
                <p>Multi-resolver comparison</p>
            </a>
            <a href="mtr.jsp" class="related-tool-card">
                <h6><i class="fas fa-route me-1"></i>MTR Traceroute</h6>
                <p>Network path analysis</p>
            </a>
            <a href="whois.jsp" class="related-tool-card">
                <h6><i class="fas fa-user me-1"></i>WHOIS Lookup</h6>
                <p>Domain registration info</p>
            </a>
            <a href="curlfunctions.jsp" class="related-tool-card">
                <h6><i class="fas fa-globe me-1"></i>Curl Tool</h6>
                <p>HTTP connectivity test</p>
            </a>
        </div>
    </div>
</div>

<%@ include file="thanks.jsp"%>

<!-- Educational Content -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light">
        <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding DMARC</h5>
    </div>
    <div class="card-body">
        <h6>What is DMARC?</h6>
        <p>DMARC (Domain-based Message Authentication, Reporting & Conformance) is an email authentication protocol that builds on SPF and DKIM. It allows domain owners to specify how receiving mail servers should handle emails that fail authentication checks, helping prevent email spoofing and phishing attacks.</p>

        <h6 class="mt-4">DMARC Policy Levels</h6>
        <div class="table-responsive">
            <table class="table table-bordered table-sm tag-table">
                <thead>
                <tr><th>Policy</th><th>Action</th><th>Use Case</th></tr>
                </thead>
                <tbody class="small">
                <tr><td><code>p=none</code></td><td>Monitor only, no action</td><td>Initial deployment, collecting reports</td></tr>
                <tr><td><code>p=quarantine</code></td><td>Send to spam/junk</td><td>Intermediate protection level</td></tr>
                <tr><td><code>p=reject</code></td><td>Block the message</td><td>Maximum protection, full enforcement</td></tr>
                </tbody>
            </table>
        </div>

        <div class="row mt-4">
            <div class="col-md-6">
                <div class="alert alert-info">
                    <h6><i class="fas fa-lightbulb me-1"></i>Implementation Tip</h6>
                    <p class="small mb-0">Start with <code>p=none</code> to collect aggregate reports, analyze email sources, then gradually move to <code>p=quarantine</code> and finally <code>p=reject</code> for full protection.</p>
                </div>
            </div>
            <div class="col-md-6">
                <div class="alert alert-warning">
                    <h6><i class="fas fa-exclamation-triangle me-1"></i>Common Mistake</h6>
                    <p class="small mb-0">Jumping directly to <code>p=reject</code> without proper SPF/DKIM setup can cause legitimate emails to be blocked. Always test with <code>p=none</code> first.</p>
                </div>
            </div>
        </div>

        <h6 class="mt-4">Complete DMARC Tag Reference</h6>
        <div class="table-responsive">
            <table class="table table-bordered table-sm tag-table">
                <thead>
                <tr><th>Tag</th><th>Required</th><th>Description</th><th>Example</th></tr>
                </thead>
                <tbody class="small">
                <tr><td><code>v</code></td><td>Yes</td><td>DMARC version</td><td><code>v=DMARC1</code></td></tr>
                <tr><td><code>p</code></td><td>Yes</td><td>Policy for domain</td><td><code>p=reject</code></td></tr>
                <tr><td><code>sp</code></td><td>No</td><td>Subdomain policy</td><td><code>sp=quarantine</code></td></tr>
                <tr><td><code>rua</code></td><td>No</td><td>Aggregate report URI</td><td><code>rua=mailto:dmarc@example.com</code></td></tr>
                <tr><td><code>ruf</code></td><td>No</td><td>Forensic report URI</td><td><code>ruf=mailto:forensic@example.com</code></td></tr>
                <tr><td><code>pct</code></td><td>No</td><td>Percentage of messages</td><td><code>pct=100</code></td></tr>
                <tr><td><code>aspf</code></td><td>No</td><td>SPF alignment mode</td><td><code>aspf=r</code> (relaxed)</td></tr>
                <tr><td><code>adkim</code></td><td>No</td><td>DKIM alignment mode</td><td><code>adkim=r</code> (relaxed)</td></tr>
                <tr><td><code>fo</code></td><td>No</td><td>Failure reporting options</td><td><code>fo=1</code></td></tr>
                <tr><td><code>ri</code></td><td>No</td><td>Report interval (seconds)</td><td><code>ri=86400</code></td></tr>
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
                <h5 class="modal-title"><i class="fas fa-share-alt"></i> Share DMARC Lookup</h5>
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
    var lastDomain = null;

    $(document).ready(function() {
        loadFromUrl();

        $('#dmarcForm').submit(function(e) {
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

    function applyPreset(domain) {
        $('#ipaddress').val(domain);
        showToast('Applied: ' + domain);
    }

    function performLookup() {
        var domain = $('#ipaddress').val().trim();
        if (!domain) { showToast('Please enter a domain name'); return; }

        lastDomain = domain;
        $('#dmarcBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Looking up...');

        $.ajax({
            type: 'POST',
            url: 'NetworkFunctionality',
            data: $('#dmarcForm').serialize(),
            success: function(response) {
                $('#dmarcBtn').prop('disabled', false).html('<i class="fas fa-search me-2"></i>Lookup DMARC');
                $('#dmarcOutput').html(response);
                $('#resultPlaceholder').hide();
                $('#resultContent').show();
                $('#resultActions').show();
            },
            error: function(xhr, status, error) {
                $('#dmarcBtn').prop('disabled', false).html('<i class="fas fa-search me-2"></i>Lookup DMARC');
                showError('Lookup failed: ' + error);
            }
        });
    }

    function showError(message) {
        $('#dmarcOutput').html('<div class="alert alert-danger"><i class="fas fa-exclamation-triangle me-2"></i>' + message + '</div>');
        $('#resultPlaceholder').hide();
        $('#resultContent').show();
    }

    function shareResults() {
        if (!lastDomain) return;
        var url = window.location.origin + window.location.pathname + '?domain=' + encodeURIComponent(lastDomain);
        $('#shareUrlText').val(url);
        $('#shareUrlModal').modal('show');
    }

    function copyResults() {
        var text = $('#dmarcOutput').text();
        navigator.clipboard.writeText(text).then(function() { showToast('Results copied!'); });
    }

    function loadFromUrl() {
        var params = new URLSearchParams(window.location.search);
        var domain = params.get('domain');
        if (domain) {
            $('#ipaddress').val(domain);
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
