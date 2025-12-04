<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>DNS Lookup – Query A, AAAA, MX, NS, TXT, CNAME (Free) | 8gwifi.org</title>
    <meta name="description" content="Free online DNS lookup tool. Query A, AAAA, MX, NS, TXT, CNAME, CAA, SOA, and other DNS records for any domain. Fast and comprehensive DNS checker." />
    <meta name="keywords" content="dns lookup, dns checker, domain lookup, a record lookup, mx record lookup, ns record lookup, txt record lookup, cname lookup, dns query, dns records" />
    <meta name="robots" content="index,follow" />
    <meta name="author" content="Anish Nath" />
    <link rel="canonical" href="https://8gwifi.org/dns.jsp" />

    <!-- Open Graph for social sharing -->
    <meta property="og:title" content="DNS Lookup Tool - Query DNS Records Online" />
    <meta property="og:description" content="Query A, AAAA, MX, NS, TXT, CNAME and other DNS records for any domain. Free online DNS checker tool." />
    <meta property="og:type" content="website" />
    <meta property="og:url" content="https://8gwifi.org/dns.jsp" />
    <meta property="og:image" content="https://8gwifi.org/images/site/dns.png" />
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content="DNS Lookup – Query A, AAAA, MX, NS, TXT, CNAME" />
    <meta name="twitter:description" content="Free DNS lookup. Query A, AAAA, MX, NS, TXT, CNAME, CAA, SOA, DNSKEY and more. Direct authoritative queries." />
    <meta name="twitter:image" content="https://8gwifi.org/images/site/dns.png" />

    <!-- JSON-LD WebApplication Schema -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "DNS Lookup Tool",
        "alternateName": ["DNS Checker", "Domain Lookup", "DNS Query Tool", "DNS Records Lookup"],
        "description": "Online DNS lookup tool to query A, AAAA, MX, NS, TXT, CNAME, CAA, SOA, DNSKEY, and other DNS records for any domain. Essential for network administrators and web developers.",
        "url": "https://8gwifi.org/dns.jsp",
        "image": "https://8gwifi.org/images/site/dns.png",
        "applicationCategory": "NetworkApplication",
        "operatingSystem": "Any",
        "browserRequirements": "Requires JavaScript",
        "softwareVersion": "2.0",
        "featureList": [
            "A record lookup (IPv4)",
            "AAAA record lookup (IPv6)",
            "MX record lookup (mail servers)",
            "NS record lookup (name servers)",
            "TXT record lookup (SPF, DKIM)",
            "CNAME record lookup (aliases)",
            "CAA record lookup (certificate authority)",
            "SOA record lookup",
            "DNSKEY record lookup (DNSSEC)",
            "PTR record lookup (reverse DNS)"
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
            "audienceType": "Network Administrators, Web Developers, System Administrators, IT Professionals, DevOps Engineers"
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
                "name": "What is a DNS lookup?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "A DNS lookup is the process of querying the Domain Name System to retrieve information about a domain name. It translates human-readable domain names (like example.com) into IP addresses and retrieves various DNS records including A, AAAA, MX, NS, TXT, and CNAME records that control how the domain functions."
                }
            },
            {
                "@type": "Question",
                "name": "What is an A record in DNS?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "An A (Address) record maps a domain name to its IPv4 address. It's the most fundamental DNS record type, telling browsers and applications which server IP address to connect to when accessing a domain. For example, example.com might have an A record pointing to 93.184.216.34."
                }
            },
            {
                "@type": "Question",
                "name": "What is an MX record used for?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "MX (Mail Exchanger) records specify the mail servers responsible for receiving email for a domain. They include a priority value (lower = higher priority) so if one mail server is unavailable, email can be routed to backup servers. For example, a domain might have MX records pointing to mail1.example.com (priority 10) and mail2.example.com (priority 20)."
                }
            },
            {
                "@type": "Question",
                "name": "What is a TXT record?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "TXT records store arbitrary text data associated with a domain. They're commonly used for email authentication (SPF, DKIM, DMARC), domain ownership verification (Google, Microsoft), and other verification purposes. For example, an SPF record might be: 'v=spf1 include:_spf.google.com ~all'."
                }
            },
            {
                "@type": "Question",
                "name": "What is the difference between A and AAAA records?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "A records map domain names to IPv4 addresses (32-bit, like 192.168.1.1), while AAAA records map to IPv6 addresses (128-bit, like 2001:0db8:85a3:0000:0000:8a2e:0370:7334). AAAA records are essential for IPv6 connectivity and are increasingly important as IPv4 addresses become scarce."
                }
            },
            {
                "@type": "Question",
                "name": "What is a CNAME record?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "A CNAME (Canonical Name) record creates an alias from one domain name to another. It's useful for pointing subdomains to the main domain or to external services. For example, www.example.com might have a CNAME pointing to example.com, or blog.example.com might point to example.wordpress.com."
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
        "name": "How to Perform a DNS Lookup",
        "description": "Step-by-step guide to query DNS records for any domain",
        "step": [
            {
                "@type": "HowToStep",
                "name": "Enter Domain Name",
                "text": "Enter the domain name you want to look up (e.g., google.com, example.org)"
            },
            {
                "@type": "HowToStep",
                "name": "Click Lookup",
                "text": "Click the DNS Lookup button to query all DNS record types"
            },
            {
                "@type": "HowToStep",
                "name": "Review Results",
                "text": "Review the DNS records including A, AAAA, MX, NS, TXT, CNAME, and other record types"
            }
        ]
    }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        :root {
            --theme-primary: #2563eb;
            --theme-secondary: #3b82f6;
            --theme-gradient: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
            --theme-light: #eff6ff;
        }
        .tool-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(37, 99, 235, 0.15);
            transition: box-shadow 0.3s ease;
        }
        .tool-card:hover {
            box-shadow: 0 4px 20px rgba(37, 99, 235, 0.25);
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
        .dns-record-table {
            font-size: 0.85rem;
            margin-bottom: 1rem;
        }
        .dns-record-table th {
            background: var(--theme-light);
            color: var(--theme-primary);
            font-weight: 600;
            padding: 0.5rem;
        }
        .dns-record-table td {
            padding: 0.5rem;
            font-family: monospace;
            word-break: break-all;
        }
        .record-type-badge {
            display: inline-block;
            padding: 0.2rem 0.5rem;
            border-radius: 4px;
            font-weight: 600;
            font-size: 0.75rem;
            min-width: 60px;
            text-align: center;
        }
        .record-type-A { background: #dcfce7; color: #166534; }
        .record-type-AAAA { background: #dbeafe; color: #1e40af; }
        .record-type-MX { background: #fef3c7; color: #92400e; }
        .record-type-NS { background: #e0e7ff; color: #3730a3; }
        .record-type-TXT { background: #f3e8ff; color: #6b21a8; }
        .record-type-CNAME { background: #fce7f3; color: #9d174d; }
        .record-type-CAA { background: #ffedd5; color: #9a3412; }
        .record-type-SOA { background: #f1f5f9; color: #475569; }
        .record-type-default { background: #f3f4f6; color: #374151; }
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
            box-shadow: 0 2px 8px rgba(37, 99, 235, 0.2);
            text-decoration: none;
        }
        .related-tool-card h6 { color: var(--theme-primary); margin-bottom: 0.25rem; font-size: 0.9rem; }
        .related-tool-card p { font-size: 0.75rem; color: #6c757d; margin: 0; }
        .terminal-block { background: #1e1e1e; border-radius: 8px; overflow: hidden; }
        .terminal-header { background: #323232; color: #d4d4d4; padding: 0.5rem 1rem; font-size: 0.75rem; display: flex; justify-content: space-between; align-items: center; }
        .terminal-body { padding: 1rem; color: #4ec9b0; font-family: monospace; font-size: 0.8rem; }
        .terminal-body code { color: #ce9178; }
        .record-section {
            margin-bottom: 1rem;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            overflow: hidden;
        }
        .record-section-header {
            background: #f8f9fa;
            padding: 0.5rem 0.75rem;
            font-weight: 600;
            font-size: 0.85rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            cursor: pointer;
        }
        .record-section-body {
            padding: 0.5rem;
        }
        .ttl-badge {
            background: #e9ecef;
            color: #495057;
            padding: 0.15rem 0.4rem;
            border-radius: 4px;
            font-size: 0.7rem;
            font-family: monospace;
        }
    </style>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="network-tools-navbar.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-2">
    <div>
        <h1 class="h4 mb-0">DNS Lookup Tool</h1>
        <div class="mt-1">
            <span class="info-badge"><i class="fas fa-globe"></i> DNS</span>
            <span class="info-badge"><i class="fas fa-search"></i> Records</span>
            <span class="info-badge"><i class="fas fa-server"></i> Domain</span>
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
                <h5><i class="fas fa-search me-2"></i>DNS Lookup</h5>
            </div>
            <div class="card-body">
                <form id="dnsForm">
                    <input type="hidden" name="methodName" value="NETWORKDNSCOMMAND">
                    <input type="hidden" name="getClientIpAddr" value="true">

                    <!-- Domain Input -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-globe me-1"></i>Domain Name</div>
                        <input type="text" class="form-control" id="ipaddress" name="ipaddress" value="google.com" placeholder="e.g., google.com, example.org">
                        <small class="text-muted">Enter domain name without http:// or www</small>
                    </div>

                    <!-- Common Domain Presets -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-bookmark me-1"></i>Quick Examples</div>
                        <div class="d-flex gap-2 flex-wrap">
                            <button type="button" class="preset-btn" onclick="applyPreset('google.com')">google.com</button>
                            <button type="button" class="preset-btn" onclick="applyPreset('cloudflare.com')">cloudflare.com</button>
                            <button type="button" class="preset-btn" onclick="applyPreset('github.com')">github.com</button>
                            <button type="button" class="preset-btn" onclick="applyPreset('amazon.com')">amazon.com</button>
                        </div>
                    </div>

                    <button type="submit" class="btn w-100" id="lookupBtn" style="background: var(--theme-gradient); color: white; font-weight: 600;">
                        <i class="fas fa-search me-2"></i>DNS Lookup
                    </button>
                </form>
            </div>
        </div>

        <!-- DNS Record Types Reference -->
        <div class="card tool-card mt-3">
            <div class="card-header bg-dark text-white py-2">
                <h6 class="mb-0"><i class="fas fa-table me-2"></i>DNS Record Types</h6>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-sm table-striped mb-0 small">
                        <thead class="table-light">
                        <tr><th>Type</th><th>Description</th></tr>
                        </thead>
                        <tbody>
                        <tr><td><span class="record-type-badge record-type-A">A</span></td><td>IPv4 address mapping</td></tr>
                        <tr><td><span class="record-type-badge record-type-AAAA">AAAA</span></td><td>IPv6 address mapping</td></tr>
                        <tr><td><span class="record-type-badge record-type-MX">MX</span></td><td>Mail server records</td></tr>
                        <tr><td><span class="record-type-badge record-type-NS">NS</span></td><td>Name server records</td></tr>
                        <tr><td><span class="record-type-badge record-type-TXT">TXT</span></td><td>Text records (SPF, DKIM)</td></tr>
                        <tr><td><span class="record-type-badge record-type-CNAME">CNAME</span></td><td>Canonical name (alias)</td></tr>
                        <tr><td><span class="record-type-badge record-type-CAA">CAA</span></td><td>Certificate Authority</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-7 mb-4">
        <div class="card tool-card result-card">
            <div class="card-header card-header-custom d-flex justify-content-between align-items-center">
                <h5 class="mb-0"><i class="fas fa-list me-2"></i>DNS Records</h5>
                <div id="resultActions" style="display: none;">
                    <button class="btn btn-sm btn-light me-1" onclick="shareResults()"><i class="fas fa-share-alt"></i></button>
                    <button class="btn btn-sm btn-light" onclick="copyResults()"><i class="fas fa-copy"></i></button>
                </div>
            </div>
            <div class="card-body">
                <div class="result-placeholder" id="resultPlaceholder">
                    <div class="text-center">
                        <i class="fas fa-globe fa-3x mb-3 text-muted"></i>
                        <p class="mb-0">DNS records will appear here</p>
                        <small class="text-muted">Enter a domain name and click DNS Lookup</small>
                    </div>
                </div>
                <div class="result-content" id="resultContent"></div>
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
                        <span>Linux/Mac: Query DNS with dig</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand('dig google.com ANY')"><i class="fas fa-copy"></i></button>
                    </div>
                    <div class="terminal-body">$ dig <code>google.com ANY</code></div>
                </div>
                <div class="terminal-block mt-2">
                    <div class="terminal-header">
                        <span>Windows: Query DNS with nslookup</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand('nslookup -type=any google.com')"><i class="fas fa-copy"></i></button>
                    </div>
                    <div class="terminal-body">C:\> nslookup <code>-type=any google.com</code></div>
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
            <a href="revdns.jsp" class="related-tool-card">
                <h6><i class="fas fa-undo me-1"></i>Reverse DNS</h6>
                <p>IP to hostname lookup</p>
            </a>
            <a href="dmarc.jsp" class="related-tool-card">
                <h6><i class="fas fa-envelope me-1"></i>DMARC Lookup</h6>
                <p>Check DMARC records</p>
            </a>
            <a href="dnsresolver.jsp" class="related-tool-card">
                <h6><i class="fas fa-link me-1"></i>Multi-Resolver</h6>
                <p>Query multiple DNS servers</p>
            </a>
            <a href="whois.jsp" class="related-tool-card">
                <h6><i class="fas fa-user me-1"></i>Whois Lookup</h6>
                <p>Domain registration info</p>
            </a>
            <a href="SubnetFunctions.jsp" class="related-tool-card">
                <h6><i class="fas fa-calculator me-1"></i>Subnet Calculator</h6>
                <p>Calculate IP subnets</p>
            </a>
            <a href="subdomain.jsp" class="related-tool-card">
                <h6><i class="fas fa-sitemap me-1"></i>Subdomain Finder</h6>
                <p>Discover subdomains</p>
            </a>
        </div>
    </div>
</div>

<%@ include file="thanks.jsp"%>

<!-- Educational Content -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light">
        <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding DNS Records</h5>
    </div>
    <div class="card-body">
        <h6>What is DNS?</h6>
        <p>The Domain Name System (DNS) is the internet's phonebook. It translates human-readable domain names (like google.com) into IP addresses that computers use to communicate. When you type a URL in your browser, DNS servers work behind the scenes to find the correct IP address.</p>

        <h6 class="mt-4">Common DNS Record Types</h6>
        <div class="table-responsive">
            <table class="table table-bordered table-sm">
                <thead class="table-light">
                <tr><th>Record</th><th>Purpose</th><th>Example</th></tr>
                </thead>
                <tbody class="small">
                <tr><td><strong>A</strong></td><td>Maps domain to IPv4 address</td><td>example.com → 93.184.216.34</td></tr>
                <tr><td><strong>AAAA</strong></td><td>Maps domain to IPv6 address</td><td>example.com → 2606:2800:220:1:...</td></tr>
                <tr><td><strong>MX</strong></td><td>Specifies mail servers</td><td>mail.example.com (priority 10)</td></tr>
                <tr><td><strong>NS</strong></td><td>Delegates DNS zone to nameservers</td><td>ns1.example.com</td></tr>
                <tr><td><strong>TXT</strong></td><td>Stores text data (SPF, DKIM, verification)</td><td>v=spf1 include:_spf.google.com ~all</td></tr>
                <tr><td><strong>CNAME</strong></td><td>Creates alias to another domain</td><td>www → example.com</td></tr>
                <tr><td><strong>CAA</strong></td><td>Specifies allowed certificate authorities</td><td>0 issue "letsencrypt.org"</td></tr>
                <tr><td><strong>SOA</strong></td><td>Contains zone administration info</td><td>Primary NS, admin email, serial</td></tr>
                </tbody>
            </table>
        </div>

        <div class="row mt-4">
            <div class="col-md-6">
                <div class="alert alert-info">
                    <h6><i class="fas fa-shield-alt me-1"></i>DNSSEC</h6>
                    <p class="small mb-0">DNSSEC adds cryptographic signatures to DNS records, allowing resolvers to verify that responses haven't been tampered with. DNSKEY and DS records are used to establish a chain of trust.</p>
                </div>
            </div>
            <div class="col-md-6">
                <div class="alert alert-warning">
                    <h6><i class="fas fa-clock me-1"></i>TTL (Time To Live)</h6>
                    <p class="small mb-0">TTL specifies how long DNS records are cached. Lower TTL means faster propagation of changes but more DNS queries. Typical values range from 300 (5 min) to 86400 (24 hours).</p>
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
                <h5 class="modal-title"><i class="fas fa-share-alt"></i> Share DNS Lookup</h5>
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
    var lastResult = null;

    $(document).ready(function() {
        loadFromUrl();

        $('#dnsForm').submit(function(e) {
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

        // Remove protocol if present
        domain = domain.replace(/^https?:\/\//, '').replace(/^www\./, '').split('/')[0];
        $('#ipaddress').val(domain);
        lastDomain = domain;

        $('#lookupBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Looking up...');

        $.ajax({
            type: "POST",
            url: "NetworkFunctionality",
            data: $('#dnsForm').serialize(),
            success: function(response) {
                $('#lookupBtn').prop('disabled', false).html('<i class="fas fa-search me-2"></i>DNS Lookup');
                lastResult = response;
                $('#resultPlaceholder').hide();
                $('#resultContent').html(response).show();
                $('#resultActions').show();

                // Add some styling to the tables
                $('#resultContent table').addClass('table table-sm dns-record-table');
            },
            error: function(xhr, status, error) {
                $('#lookupBtn').prop('disabled', false).html('<i class="fas fa-search me-2"></i>DNS Lookup');
                showError('Request failed: ' + error);
            }
        });
    }

    function showError(message) {
        var html = '<div class="alert alert-danger"><i class="fas fa-exclamation-circle me-2"></i>' + message + '</div>';
        $('#resultPlaceholder').hide();
        $('#resultContent').html(html).show();
    }

    function shareResults() {
        if (!lastDomain) return;
        var url = window.location.origin + window.location.pathname + '?domain=' + encodeURIComponent(lastDomain);
        $('#shareUrlText').val(url);
        $('#shareUrlModal').modal('show');
    }

    function copyResults() {
        var text = $('#resultContent').text();
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
