<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>DNS Propagation Checker – Multi‑Resolver Lookup (Free) | 8gwifi.org</title>
    <meta name="description" content="Free online multi-resolver DNS lookup tool. Query multiple DNS servers (Google, Cloudflare, Quad9, OpenDNS) simultaneously and compare results for A, AAAA, MX, NS, TXT records." />
    <meta name="keywords" content="dns resolver, multi dns lookup, dns comparison, dns propagation, cloudflare dns, google dns, quad9, opendns, dns checker, dns records" />
    <meta name="robots" content="index,follow" />
    <meta name="author" content="Anish Nath" />
    <link rel="canonical" href="https://8gwifi.org/dnsresolver.jsp" />

    <!-- Open Graph for social sharing -->
    <meta property="og:title" content="Multi-Resolver DNS Lookup - Compare DNS Servers" />
    <meta property="og:description" content="Query multiple DNS servers simultaneously and compare results. Check DNS propagation across Cloudflare, Google, Quad9, and more." />
    <meta property="og:type" content="website" />
    <meta property="og:url" content="https://8gwifi.org/dnsresolver.jsp" />
    <meta property="og:image" content="https://8gwifi.org/images/site/dns.png" />
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content="DNS Propagation Checker – Multi‑Resolver Lookup" />
    <meta name="twitter:description" content="Query Cloudflare, Google, Quad9, OpenDNS and more. Compare DNS answers and propagation for A, AAAA, MX, NS, TXT, CNAME." />
    <meta name="twitter:image" content="https://8gwifi.org/images/site/dns.png" />

    <!-- JSON-LD WebApplication Schema -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "Multi-Resolver DNS Lookup Tool",
        "alternateName": ["DNS Propagation Checker", "DNS Server Comparison", "Multi-DNS Query Tool"],
        "description": "Advanced DNS resolver tool that queries multiple DNS servers simultaneously. Compare responses from Cloudflare, Google, Quad9, OpenDNS, AdGuard, and custom resolvers with consensus analysis.",
        "url": "https://8gwifi.org/dnsresolver.jsp",
        "image": "https://8gwifi.org/images/site/dns.png",
        "applicationCategory": "NetworkApplication",
        "operatingSystem": "Any",
        "browserRequirements": "Requires JavaScript",
        "softwareVersion": "2.0",
        "featureList": [
            "Multi-resolver DNS lookup",
            "DNS propagation checking",
            "Consensus analysis",
            "Response time comparison",
            "A, AAAA, MX, NS, TXT, CNAME record types",
            "Cloudflare DNS support",
            "Google Public DNS support",
            "Quad9 DNS support",
            "OpenDNS support",
            "Custom resolver support"
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
            "audienceType": "Network Administrators, DNS Engineers, DevOps Engineers, Security Researchers, System Administrators"
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
                "name": "Why query multiple DNS resolvers?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Querying multiple DNS resolvers helps verify DNS propagation, detect inconsistencies, and troubleshoot DNS issues. Different resolvers may have different cached values or TTLs. By comparing results from Cloudflare, Google, Quad9, and others, you can identify propagation delays, misconfigurations, or DNS poisoning attempts."
                }
            },
            {
                "@type": "Question",
                "name": "What is DNS consensus?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "DNS consensus means all queried DNS resolvers return the same answer for a query. When there's consensus, it indicates the DNS record has fully propagated and is consistent across the internet. Lack of consensus may indicate ongoing DNS changes, propagation delays, or potential DNS hijacking."
                }
            },
            {
                "@type": "Question",
                "name": "Which DNS resolver is fastest?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "DNS resolver speed varies by location and network conditions. Generally, Cloudflare (1.1.1.1) and Google (8.8.8.8) are among the fastest public DNS resolvers globally. However, your ISP's DNS or a geographically closer resolver might be faster for your specific location. This tool measures response times to help you compare."
                }
            },
            {
                "@type": "Question",
                "name": "What is DNS propagation?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "DNS propagation is the time it takes for DNS changes to spread across the internet's DNS servers. When you update a DNS record, it can take 24-48 hours for all DNS servers worldwide to reflect the change, depending on TTL values. During propagation, different resolvers may return old or new values."
                }
            },
            {
                "@type": "Question",
                "name": "What's the difference between Cloudflare and Google DNS?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Cloudflare DNS (1.1.1.1) focuses on privacy and speed, promising not to log queries. Google DNS (8.8.8.8) offers reliability and global reach but logs some data for analytics. Both support DNSSEC and DNS over HTTPS (DoH). Cloudflare often has slightly lower latency, while Google has extensive infrastructure."
                }
            },
            {
                "@type": "Question",
                "name": "What is Quad9 DNS?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Quad9 (9.9.9.9) is a free public DNS resolver that blocks known malicious domains using threat intelligence. It's operated by a nonprofit foundation and focuses on security and privacy. Quad9 automatically blocks access to known phishing, malware, and exploit kit domains while respecting user privacy."
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
        "name": "How to Check DNS Propagation",
        "description": "Step-by-step guide to query multiple DNS servers and check propagation",
        "step": [
            {
                "@type": "HowToStep",
                "name": "Enter Domain Name",
                "text": "Enter the domain name you want to look up (e.g., example.com)"
            },
            {
                "@type": "HowToStep",
                "name": "Select Record Type",
                "text": "Choose the DNS record type (A, AAAA, MX, NS, TXT, or CNAME)"
            },
            {
                "@type": "HowToStep",
                "name": "Choose Resolvers",
                "text": "Select DNS resolver presets or enter custom resolver IPs"
            },
            {
                "@type": "HowToStep",
                "name": "Compare Results",
                "text": "Review results from each resolver and check for consensus"
            }
        ]
    }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        :root {
            --theme-primary: #d97706;
            --theme-secondary: #f59e0b;
            --theme-gradient: linear-gradient(135deg, #d97706 0%, #f59e0b 100%);
            --theme-light: #fffbeb;
        }
        .tool-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(217, 119, 6, 0.15);
            transition: box-shadow 0.3s ease;
        }
        .tool-card:hover {
            box-shadow: 0 4px 20px rgba(217, 119, 6, 0.25);
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
        .resolver-btn {
            padding: 0.5rem 0.75rem;
            border: 2px solid #dee2e6;
            border-radius: 8px;
            background: white;
            cursor: pointer;
            font-size: 0.75rem;
            transition: all 0.2s;
            text-align: center;
        }
        .resolver-btn:hover {
            border-color: var(--theme-primary);
            background: var(--theme-light);
        }
        .resolver-btn.active {
            border-color: var(--theme-primary);
            background: var(--theme-gradient);
            color: white;
        }
        .resolver-btn .resolver-name { font-weight: 600; display: block; }
        .resolver-btn .resolver-ip { font-size: 0.65rem; opacity: 0.8; }
        .record-type-btn {
            padding: 0.4rem 0.75rem;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            background: white;
            cursor: pointer;
            font-size: 0.8rem;
            transition: all 0.2s;
        }
        .record-type-btn:hover {
            border-color: var(--theme-primary);
            background: var(--theme-light);
        }
        .record-type-btn.active {
            border-color: var(--theme-primary);
            background: var(--theme-primary);
            color: white;
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
        .provider-badge {
            display: inline-block;
            padding: 0.2rem 0.5rem;
            border-radius: 4px;
            font-size: 0.7rem;
            font-weight: 600;
        }
        .provider-cloudflare { background: #f48120; color: white; }
        .provider-google { background: #4285f4; color: white; }
        .provider-quad9 { background: #0062cc; color: white; }
        .provider-opendns { background: #e15e1c; color: white; }
        .provider-adguard { background: #68bc71; color: white; }
        .provider-controld { background: #6366f1; color: white; }
        .provider-default { background: #6c757d; color: white; }
        .consensus-badge {
            padding: 0.3rem 0.6rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        .consensus-yes { background: #dcfce7; color: #166534; }
        .consensus-no { background: #fef2f2; color: #991b1b; }
        .duration-badge {
            background: #e9ecef;
            color: #495057;
            padding: 0.15rem 0.4rem;
            border-radius: 4px;
            font-size: 0.7rem;
            font-family: monospace;
        }
        .answer-cell {
            font-family: monospace;
            font-size: 0.8rem;
            word-break: break-all;
        }
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 0.75rem;
            margin-bottom: 1rem;
        }
        .summary-item {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 0.75rem;
            text-align: center;
        }
        .summary-item label {
            font-size: 0.7rem;
            color: #6c757d;
            margin-bottom: 0.25rem;
            display: block;
        }
        .summary-item .value {
            font-weight: 600;
            color: var(--theme-primary);
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
            box-shadow: 0 2px 8px rgba(217, 119, 6, 0.2);
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
        <h1 class="h4 mb-0">Multi-Resolver DNS Lookup</h1>
        <div class="mt-1">
            <span class="info-badge"><i class="fas fa-server"></i> Multi-DNS</span>
            <span class="info-badge"><i class="fas fa-check-double"></i> Consensus</span>
            <span class="info-badge"><i class="fas fa-clock"></i> Propagation</span>
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
                <h5><i class="fas fa-layer-group me-2"></i>DNS Query</h5>
            </div>
            <div class="card-body">
                <form id="dnsForm">
                    <!-- Domain Input -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-globe me-1"></i>Domain Name</div>
                        <input type="text" class="form-control" id="name" name="name" placeholder="e.g., google.com, example.org" required>
                    </div>

                    <!-- Record Type -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-tags me-1"></i>Record Type</div>
                        <div class="d-flex gap-2 flex-wrap">
                            <button type="button" class="record-type-btn active" data-type="A">A</button>
                            <button type="button" class="record-type-btn" data-type="AAAA">AAAA</button>
                            <button type="button" class="record-type-btn" data-type="MX">MX</button>
                            <button type="button" class="record-type-btn" data-type="NS">NS</button>
                            <button type="button" class="record-type-btn" data-type="TXT">TXT</button>
                            <button type="button" class="record-type-btn" data-type="CNAME">CNAME</button>
                        </div>
                        <input type="hidden" id="type" name="type" value="A">
                    </div>

                    <!-- DNS Resolvers -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-server me-1"></i>DNS Resolvers</div>
                        <div class="row g-2 mb-2">
                            <div class="col-6">
                                <div class="resolver-btn active" data-resolver="1.1.1.1">
                                    <span class="resolver-name">Cloudflare</span>
                                    <span class="resolver-ip">1.1.1.1</span>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="resolver-btn active" data-resolver="8.8.8.8">
                                    <span class="resolver-name">Google</span>
                                    <span class="resolver-ip">8.8.8.8</span>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="resolver-btn active" data-resolver="9.9.9.9">
                                    <span class="resolver-name">Quad9</span>
                                    <span class="resolver-ip">9.9.9.9</span>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="resolver-btn active" data-resolver="208.67.222.222">
                                    <span class="resolver-name">OpenDNS</span>
                                    <span class="resolver-ip">208.67.222.222</span>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="resolver-btn" data-resolver="94.140.14.14">
                                    <span class="resolver-name">AdGuard</span>
                                    <span class="resolver-ip">94.140.14.14</span>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="resolver-btn" data-resolver="76.76.2.0">
                                    <span class="resolver-name">ControlD</span>
                                    <span class="resolver-ip">76.76.2.0</span>
                                </div>
                            </div>
                        </div>
                        <input type="hidden" id="resolvers" name="resolvers" value="1.1.1.1,8.8.8.8,9.9.9.9,208.67.222.222">
                        <small class="text-muted">Click to toggle resolvers. At least one must be selected.</small>
                    </div>

                    <button type="submit" class="btn w-100" id="resolveBtn" style="background: var(--theme-gradient); color: white; font-weight: 600;">
                        <i class="fas fa-search me-2"></i>Resolve DNS
                    </button>
                </form>
            </div>
        </div>

        <!-- Resolver Info -->
        <div class="card tool-card mt-3">
            <div class="card-header bg-dark text-white py-2">
                <h6 class="mb-0"><i class="fas fa-info-circle me-2"></i>About Resolvers</h6>
            </div>
            <div class="card-body small">
                <p class="mb-2"><strong><span class="provider-badge provider-cloudflare">CF</span> Cloudflare:</strong> Fast, privacy-focused (1.1.1.1)</p>
                <p class="mb-2"><strong><span class="provider-badge provider-google">G</span> Google:</strong> Reliable, global reach (8.8.8.8)</p>
                <p class="mb-2"><strong><span class="provider-badge provider-quad9">Q9</span> Quad9:</strong> Security-focused, blocks malware (9.9.9.9)</p>
                <p class="mb-0"><strong><span class="provider-badge provider-opendns">OD</span> OpenDNS:</strong> Filtering options (208.67.222.222)</p>
            </div>
        </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-7 mb-4">
        <div class="card tool-card result-card">
            <div class="card-header card-header-custom d-flex justify-content-between align-items-center">
                <h5 class="mb-0"><i class="fas fa-list me-2"></i>Resolution Results</h5>
                <div id="resultActions" style="display: none;">
                    <button class="btn btn-sm btn-light me-1" onclick="shareResults()"><i class="fas fa-share-alt"></i></button>
                    <button class="btn btn-sm btn-light" onclick="copyResults()"><i class="fas fa-copy"></i></button>
                </div>
            </div>
            <div class="card-body">
                <div class="result-placeholder" id="resultPlaceholder">
                    <div class="text-center">
                        <i class="fas fa-layer-group fa-3x mb-3 text-muted"></i>
                        <p class="mb-0">DNS results will appear here</p>
                        <small class="text-muted">Enter a domain and click Resolve DNS</small>
                    </div>
                </div>
                <div class="result-content" id="resultContent">
                    <!-- Summary -->
                    <div class="summary-grid" id="summaryGrid">
                        <div class="summary-item">
                            <label>Domain</label>
                            <div class="value" id="queryName">-</div>
                        </div>
                        <div class="summary-item">
                            <label>Record Type</label>
                            <div class="value" id="recordType">-</div>
                        </div>
                        <div class="summary-item">
                            <label>Consensus</label>
                            <div class="value" id="consensus">-</div>
                        </div>
                        <div class="summary-item">
                            <label>Unique Answers</label>
                            <div class="value" id="uniqueAnswers">-</div>
                        </div>
                    </div>

                    <!-- Results Table -->
                    <div class="table-responsive">
                        <table class="table table-hover result-table mb-0">
                            <thead>
                            <tr>
                                <th>Provider</th>
                                <th>Resolver</th>
                                <th>Answer(s)</th>
                                <th>Time</th>
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
                        <span>Query specific resolver with dig</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand('dig @1.1.1.1 google.com A')"><i class="fas fa-copy"></i></button>
                    </div>
                    <div class="terminal-body">$ dig <code>@1.1.1.1 google.com A</code></div>
                </div>
                <div class="terminal-block mt-2">
                    <div class="terminal-header">
                        <span>Query multiple resolvers</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand('for ns in 1.1.1.1 8.8.8.8 9.9.9.9; do dig @$ns google.com A +short; done')"><i class="fas fa-copy"></i></button>
                    </div>
                    <div class="terminal-body">$ for ns in 1.1.1.1 8.8.8.8 9.9.9.9; do dig @$ns <code>google.com A +short</code>; done</div>
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
                <p>Simple DNS record query</p>
            </a>
            <a href="revdns.jsp" class="related-tool-card">
                <h6><i class="fas fa-undo me-1"></i>Reverse DNS</h6>
                <p>IP to hostname lookup</p>
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
        </div>
    </div>
</div>

<%@ include file="thanks.jsp"%>

<!-- Educational Content -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light">
        <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding Multi-Resolver DNS</h5>
    </div>
    <div class="card-body">
        <h6>Why Use Multiple DNS Resolvers?</h6>
        <p>Different DNS resolvers may return different results due to caching, TTL expiration, or geographic distribution. Querying multiple resolvers helps you:</p>
        <ul>
            <li><strong>Verify DNS propagation</strong> after making DNS changes</li>
            <li><strong>Detect inconsistencies</strong> that could indicate issues</li>
            <li><strong>Compare response times</strong> to find the fastest resolver for your location</li>
            <li><strong>Identify DNS poisoning</strong> or hijacking attempts</li>
        </ul>

        <h6 class="mt-4">Public DNS Resolvers Comparison</h6>
        <div class="table-responsive">
            <table class="table table-bordered table-sm">
                <thead class="table-light">
                <tr><th>Provider</th><th>Primary</th><th>Secondary</th><th>Focus</th></tr>
                </thead>
                <tbody class="small">
                <tr><td><strong>Cloudflare</strong></td><td>1.1.1.1</td><td>1.0.0.1</td><td>Speed & Privacy</td></tr>
                <tr><td><strong>Google</strong></td><td>8.8.8.8</td><td>8.8.4.4</td><td>Reliability & Global reach</td></tr>
                <tr><td><strong>Quad9</strong></td><td>9.9.9.9</td><td>149.112.112.112</td><td>Security (malware blocking)</td></tr>
                <tr><td><strong>OpenDNS</strong></td><td>208.67.222.222</td><td>208.67.220.220</td><td>Content filtering</td></tr>
                <tr><td><strong>AdGuard</strong></td><td>94.140.14.14</td><td>94.140.15.15</td><td>Ad blocking</td></tr>
                <tr><td><strong>ControlD</strong></td><td>76.76.2.0</td><td>76.76.10.0</td><td>Customizable filtering</td></tr>
                </tbody>
            </table>
        </div>

        <div class="row mt-4">
            <div class="col-md-6">
                <div class="alert alert-info">
                    <h6><i class="fas fa-check-double me-1"></i>What is Consensus?</h6>
                    <p class="small mb-0">Consensus means all queried resolvers return identical answers. Full consensus indicates the DNS record has propagated globally and is consistent across all resolvers.</p>
                </div>
            </div>
            <div class="col-md-6">
                <div class="alert alert-warning">
                    <h6><i class="fas fa-clock me-1"></i>Propagation Time</h6>
                    <p class="small mb-0">DNS changes can take 24-48 hours to propagate globally. During this time, different resolvers may return old or new values depending on their cache TTL.</p>
                </div>
            </div>
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
                <h5 class="modal-title"><i class="fas fa-share-alt"></i> Share DNS Query</h5>
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
    var lastQuery = null;
    var lastResults = null;

    $(document).ready(function() {
        loadFromUrl();

        // Record type selection
        $('.record-type-btn').click(function() {
            $('.record-type-btn').removeClass('active');
            $(this).addClass('active');
            $('#type').val($(this).data('type'));
        });

        // Resolver toggle
        $('.resolver-btn').click(function() {
            $(this).toggleClass('active');
            updateResolvers();
        });

        $('#dnsForm').submit(function(e) {
            e.preventDefault();
            performResolve();
        });

        $('#copyShareUrl').click(function() {
            navigator.clipboard.writeText($('#shareUrlText').val()).then(function() {
                $('#copyShareUrl').html('<i class="fas fa-check"></i> Copied!');
                setTimeout(function() { $('#copyShareUrl').html('<i class="fas fa-copy"></i> Copy'); }, 1500);
            });
        });
    });

    function updateResolvers() {
        var resolvers = [];
        $('.resolver-btn.active').each(function() {
            resolvers.push($(this).data('resolver'));
        });
        $('#resolvers').val(resolvers.join(','));
    }

    function performResolve() {
        var name = $('#name').val().trim();
        if (!name) { showToast('Please enter a domain name'); return; }

        var resolvers = $('#resolvers').val();
        if (!resolvers) { showToast('Please select at least one resolver'); return; }

        lastQuery = {
            name: name,
            type: $('#type').val(),
            resolvers: resolvers
        };

        $('#resolveBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Resolving...');

        $.ajax({
            type: 'GET',
            url: 'DnsResolverFunctionality',
            data: lastQuery,
            dataType: 'json',
            success: function(data) {
                $('#resolveBtn').prop('disabled', false).html('<i class="fas fa-search me-2"></i>Resolve DNS');
                lastResults = data;
                renderResults(data);
            },
            error: function(xhr) {
                $('#resolveBtn').prop('disabled', false).html('<i class="fas fa-search me-2"></i>Resolve DNS');
                var msg = 'DNS lookup failed. Please try again.';
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

        // Update summary
        $('#queryName').text(data.name || '-');
        $('#recordType').text(data.record_type || '-');
        $('#uniqueAnswers').text(data.unique_answer_sets || 0);

        var consensusHtml = data.consensus
            ? '<span class="consensus-badge consensus-yes"><i class="fas fa-check me-1"></i>Yes</span>'
            : '<span class="consensus-badge consensus-no"><i class="fas fa-times me-1"></i>No</span>';
        $('#consensus').html(consensusHtml);

        // Render results table
        var rows = '';
        for (var i = 0; i < data.results.length; i++) {
            var r = data.results[i];
            var providerClass = getProviderClass(r.provider);
            var answers = (r.answers && r.answers.length) ? r.answers.join('<br>') : '<span class="text-muted">No records</span>';
            var duration = (typeof r.duration_seconds !== 'undefined')
                ? '<span class="duration-badge">' + r.duration_seconds.toFixed(3) + 's</span>'
                : '-';

            rows += '<tr>' +
                '<td><span class="provider-badge ' + providerClass + '">' + (r.provider || 'Unknown') + '</span></td>' +
                '<td><code>' + (r.resolver_ip || '') + '</code></td>' +
                '<td class="answer-cell">' + answers + '</td>' +
                '<td>' + duration + '</td>' +
                '</tr>';
        }

        $('#resultsBody').html(rows);
        $('#resultPlaceholder').hide();
        $('#resultContent').show();
        $('#resultActions').show();
    }

    function getProviderClass(provider) {
        if (!provider) return 'provider-default';
        var p = provider.toLowerCase();
        if (p.includes('cloudflare')) return 'provider-cloudflare';
        if (p.includes('google')) return 'provider-google';
        if (p.includes('quad9')) return 'provider-quad9';
        if (p.includes('opendns')) return 'provider-opendns';
        if (p.includes('adguard')) return 'provider-adguard';
        if (p.includes('controld')) return 'provider-controld';
        return 'provider-default';
    }

    function showError(message) {
        var html = '<div class="alert alert-danger"><i class="fas fa-exclamation-circle me-2"></i>' + message + '</div>';
        $('#resultPlaceholder').hide();
        $('#resultsBody').empty();
        $('#resultContent').html(html).show();
    }

    function shareResults() {
        if (!lastQuery) return;
        var url = window.location.origin + window.location.pathname +
            '?name=' + encodeURIComponent(lastQuery.name) +
            '&type=' + encodeURIComponent(lastQuery.type);
        $('#shareUrlText').val(url);
        $('#shareUrlModal').modal('show');
    }

    function copyResults() {
        if (!lastResults || !lastResults.results) return;
        var text = 'Domain: ' + lastResults.name + '\nType: ' + lastResults.record_type + '\nConsensus: ' + (lastResults.consensus ? 'Yes' : 'No') + '\n\n';
        text += lastResults.results.map(function(r) {
            return r.provider + ' (' + r.resolver_ip + '): ' + (r.answers ? r.answers.join(', ') : 'No records');
        }).join('\n');
        navigator.clipboard.writeText(text).then(function() { showToast('Results copied!'); });
    }

    function loadFromUrl() {
        var params = new URLSearchParams(window.location.search);
        var name = params.get('name');
        var type = params.get('type');
        if (name) {
            $('#name').val(name);
            if (type) {
                $('.record-type-btn').removeClass('active');
                $('.record-type-btn[data-type="' + type + '"]').addClass('active');
                $('#type').val(type);
            }
            setTimeout(function() { performResolve(); }, 500);
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
