<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>WHOIS Lookup – Domain Registration & Ownership (Free) | 8gwifi.org</title>
    <meta name="description" content="Free online WHOIS lookup tool to find domain registration information, registrar details, creation and expiration dates, name servers, and ownership data." />
    <meta name="keywords" content="whois lookup, domain lookup, domain registration, registrar lookup, domain expiry, name servers, domain ownership, domain information" />
    <meta name="robots" content="index,follow" />
    <meta name="author" content="Anish Nath" />
    <link rel="canonical" href="https://8gwifi.org/whois.jsp" />

    <!-- Open Graph for social sharing -->
    <meta property="og:title" content="WHOIS Lookup Tool - Domain Registration Information" />
    <meta property="og:description" content="Find domain registration details, ownership information, expiration dates, and name servers with our free WHOIS lookup tool." />
    <meta property="og:type" content="website" />
    <meta property="og:url" content="https://8gwifi.org/whois.jsp" />
    <meta property="og:image" content="https://8gwifi.org/images/site/logo.png" />
<!-- JSON-LD FAQPage Schema (additions matching visible FAQs) -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "FAQPage",
      "mainEntity": [
        {"@type": "Question","name": "What is WHOIS?","acceptedAnswer": {"@type": "Answer","text": "WHOIS is a public directory of domain registration data: registrar, registrant (if not redacted), name servers, creation and expiry dates."}},
        {"@type": "Question","name": "Why is some data hidden?","acceptedAnswer": {"@type": "Answer","text": "Privacy/GDPR masking or proxy services often redact registrant info. Use registrar-provided contact forms if needed."}},
        {"@type": "Question","name": "How current is WHOIS data?","acceptedAnswer": {"@type": "Answer","text": "WHOIS reflects registry/registrar records; updates depend on provider propagation and cache refresh intervals."}}
      ]
    }
    </script>
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content="WHOIS Lookup – Domain Registration & Ownership" />
    <meta name="twitter:description" content="Free WHOIS lookup. Find domain registration details, ownership info, expiration dates, and name servers." />
    <meta name="twitter:image" content="https://8gwifi.org/images/site/logo.png" />

    <!-- JSON-LD WebApplication Schema -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "WHOIS Lookup Tool",
        "alternateName": ["Domain WHOIS", "Domain Lookup", "Registrar Lookup", "Domain Registration Checker"],
        "description": "Free online WHOIS lookup tool to find domain registration information including registrar, creation date, expiration date, name servers, and ownership details.",
        "url": "https://8gwifi.org/whois.jsp",
        "image": "https://8gwifi.org/images/site/whois.png",
        "applicationCategory": "NetworkApplication",
        "operatingSystem": "Any",
        "browserRequirements": "Requires JavaScript",
        "softwareVersion": "2.0",
        "featureList": [
            "Domain registration lookup",
            "Registrar information",
            "Creation and expiration dates",
            "Name server details",
            "Domain status codes",
            "Raw WHOIS data"
        ],
        "screenshot": "https://8gwifi.org/images/site/whois.png",
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
            "audienceType": "Domain Owners, Network Administrators, Security Researchers, Legal Professionals, IT Professionals"
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
                "name": "What is WHOIS and what information does it provide?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "WHOIS is a query and response protocol used to look up domain registration information. It provides details like the domain registrar, registration and expiration dates, name servers, registrant contact information (if not privacy-protected), and domain status codes indicating transfer or update restrictions."
                }
            },
            {
                "@type": "Question",
                "name": "Why does WHOIS show privacy protection instead of owner details?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Many domain registrars offer WHOIS privacy or proxy services that replace the registrant's personal information with generic contact details. This is common due to GDPR compliance and to protect domain owners from spam, identity theft, and unwanted solicitations."
                }
            },
            {
                "@type": "Question",
                "name": "What do WHOIS domain status codes mean?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Status codes indicate the domain's current state: 'clientTransferProhibited' prevents unauthorized transfers, 'clientDeleteProhibited' prevents deletion, 'pendingDelete' means the domain is scheduled for deletion, and 'redemptionPeriod' means it's in a grace period after expiry where the owner can still reclaim it."
                }
            },
            {
                "@type": "Question",
                "name": "How often is WHOIS information updated?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "WHOIS databases are typically updated within 24-48 hours after domain registration or modification. However, some registrars update their records more frequently. Changes to contact information, name servers, or status codes should appear within a day or two."
                }
            },
            {
                "@type": "Question",
                "name": "Can I use WHOIS to find when a domain expires?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Yes, WHOIS lookup shows the domain's expiration date in the 'Registry Expiry Date' or 'Expiration Date' field. This is useful for monitoring domain availability, planning renewals, or identifying potentially abandoned domains."
                }
            },
            {
                "@type": "Question",
                "name": "What are name servers and why are they important in WHOIS?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Name servers are DNS servers that translate domain names to IP addresses. WHOIS shows which name servers a domain uses, which indicates where the domain's DNS is hosted. This is important for troubleshooting DNS issues and understanding a domain's infrastructure."
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
        "name": "How to Lookup Domain Registration Information",
        "description": "Step-by-step guide to find domain WHOIS information",
        "step": [
            {
                "@type": "HowToStep",
                "name": "Enter Domain Name",
                "text": "Enter the domain name you want to lookup (e.g., google.com, github.com)"
            },
            {
                "@type": "HowToStep",
                "name": "Click Lookup Domain",
                "text": "Click the lookup button to query the WHOIS database"
            },
            {
                "@type": "HowToStep",
                "name": "Review Results",
                "text": "Analyze the registration details, dates, name servers, and status codes"
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
            box-shadow: 0 2px 8px rgba(217, 119, 6, 0.2);
            text-decoration: none;
        }
        .related-tool-card h6 { color: var(--theme-primary); margin-bottom: 0.25rem; font-size: 0.9rem; }
        .related-tool-card p { font-size: 0.75rem; color: #6c757d; margin: 0; }
        .terminal-block { background: #1e1e1e; border-radius: 8px; overflow: hidden; }
        .terminal-header { background: #323232; color: #d4d4d4; padding: 0.5rem 1rem; font-size: 0.75rem; display: flex; justify-content: space-between; align-items: center; }
        .terminal-body { padding: 1rem; color: #4ec9b0; font-family: monospace; font-size: 0.8rem; }
        .terminal-body code { color: #ce9178; }
        .info-card {
            background: var(--theme-light);
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1rem;
        }
        .info-card h6 {
            color: var(--theme-primary);
            font-size: 0.85rem;
            margin-bottom: 0.5rem;
        }
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 0.35rem 0;
            border-bottom: 1px dashed #e9ecef;
            font-size: 0.85rem;
        }
        .info-row:last-child { border-bottom: none; }
        .info-row .label { color: #6c757d; }
        .info-row .value { font-weight: 500; color: #1f2937; word-break: break-all; text-align: right; max-width: 60%; }
        .ns-badge {
            display: inline-block;
            background: #f3f4f6;
            color: #374151;
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            font-size: 0.75rem;
            margin: 0.15rem;
            font-family: monospace;
        }
        .status-badge {
            display: inline-block;
            padding: 0.2rem 0.5rem;
            border-radius: 4px;
            font-size: 0.7rem;
            margin: 0.1rem;
        }
        .status-active { background: #d1fae5; color: #059669; }
        .status-warning { background: #fef3c7; color: #d97706; }
        .status-danger { background: #fee2e2; color: #dc2626; }
        .raw-data-table {
            font-size: 0.8rem;
        }
        .raw-data-table th {
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
        <h1 class="h4 mb-0">WHOIS Lookup Tool</h1>
        <div class="mt-1">
            <span class="info-badge"><i class="fas fa-id-card"></i> Registration</span>
            <span class="info-badge"><i class="fas fa-calendar"></i> Expiration</span>
            <span class="info-badge"><i class="fas fa-server"></i> Name Servers</span>
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
                <h5><i class="fas fa-search me-2"></i>WHOIS Lookup</h5>
            </div>
            <div class="card-body">
                <form id="whoisForm">
                    <!-- Domain Input -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-globe me-1"></i>Domain Name</div>
                        <input type="text" class="form-control" id="domain" name="domain" value="google.com" placeholder="e.g., google.com, github.com">
                        <small class="text-muted">Enter domain without http/https</small>
                    </div>

                    <!-- Quick Presets -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-bookmark me-1"></i>Quick Presets</div>
                        <div class="d-flex gap-2 flex-wrap mb-2">
                            <button type="button" class="preset-btn" onclick="applyPreset('google.com')">google.com</button>
                            <button type="button" class="preset-btn" onclick="applyPreset('github.com')">github.com</button>
                            <button type="button" class="preset-btn" onclick="applyPreset('amazon.com')">amazon.com</button>
                        </div>
                        <div class="d-flex gap-2 flex-wrap">
                            <button type="button" class="preset-btn" onclick="applyPreset('cloudflare.com')">cloudflare.com</button>
                            <button type="button" class="preset-btn" onclick="applyPreset('microsoft.com')">microsoft.com</button>
                        </div>
                    </div>

                    <button type="submit" class="btn w-100" id="whoisBtn" style="background: var(--theme-gradient); color: white; font-weight: 600;">
                        <i class="fas fa-search me-2"></i>Lookup Domain
                    </button>
                </form>
            </div>
        </div>

        <!-- Domain Status Reference -->
        <div class="card tool-card mt-3">
            <div class="card-header bg-dark text-white py-2">
                <h6 class="mb-0"><i class="fas fa-info-circle me-2"></i>Common Status Codes</h6>
            </div>
            <div class="card-body small p-2">
                <div class="d-flex justify-content-between mb-1">
                    <span><code>clientTransferProhibited</code></span>
                    <span class="text-muted">Transfer locked</span>
                </div>
                <div class="d-flex justify-content-between mb-1">
                    <span><code>clientDeleteProhibited</code></span>
                    <span class="text-muted">Delete locked</span>
                </div>
                <div class="d-flex justify-content-between mb-1">
                    <span><code>clientUpdateProhibited</code></span>
                    <span class="text-muted">Update locked</span>
                </div>
                <div class="d-flex justify-content-between mb-1">
                    <span><code>pendingDelete</code></span>
                    <span class="text-muted">Being deleted</span>
                </div>
                <div class="d-flex justify-content-between">
                    <span><code>redemptionPeriod</code></span>
                    <span class="text-muted">Grace period</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-7 mb-4">
        <div class="card tool-card result-card">
            <div class="card-header card-header-custom d-flex justify-content-between align-items-center">
                <h5 class="mb-0"><i class="fas fa-id-card me-2"></i>WHOIS Results</h5>
                <div id="resultActions" style="display: none;">
                    <button class="btn btn-sm btn-light me-1" onclick="shareResults()"><i class="fas fa-share-alt"></i></button>
                    <button class="btn btn-sm btn-light" onclick="copyResults()"><i class="fas fa-copy"></i></button>
                </div>
            </div>
            <div class="card-body">
                <div class="result-placeholder" id="resultPlaceholder">
                    <div class="text-center">
                        <i class="fas fa-id-card fa-3x mb-3 text-muted"></i>
                        <p class="mb-0">WHOIS results will appear here</p>
                        <small class="text-muted">Enter a domain and click Lookup Domain</small>
                    </div>
                </div>
                <div class="result-content" id="resultContent">
                    <!-- Domain Info Card -->
                    <div class="info-card" id="domainInfoCard">
                        <h6><i class="fas fa-globe me-1"></i>Domain Information</h6>
                        <div class="info-row"><span class="label">Domain</span><span class="value" id="lookedUpDomain">-</span></div>
                        <div class="info-row"><span class="label">Registrar</span><span class="value" id="registrar">-</span></div>
                        <div class="info-row"><span class="label">Status</span><span class="value" id="domainStatus">-</span></div>
                    </div>

                    <!-- Dates Card -->
                    <div class="info-card">
                        <h6><i class="fas fa-calendar-alt me-1"></i>Important Dates</h6>
                        <div class="info-row"><span class="label">Created</span><span class="value" id="createdDate">-</span></div>
                        <div class="info-row"><span class="label">Updated</span><span class="value" id="updatedDate">-</span></div>
                        <div class="info-row"><span class="label">Expires</span><span class="value" id="expiryDate">-</span></div>
                    </div>

                    <!-- Name Servers Card -->
                    <div class="info-card">
                        <h6><i class="fas fa-server me-1"></i>Name Servers</h6>
                        <div id="nameServers"></div>
                    </div>

                    <!-- Raw Data (Collapsible) -->
                    <div class="mt-3">
                        <button class="btn btn-sm btn-outline-secondary w-100" type="button" data-toggle="collapse" data-target="#rawDataCollapse">
                            <i class="fas fa-code me-1"></i>View Raw WHOIS Data
                        </button>
                        <div class="collapse mt-2" id="rawDataCollapse">
                            <div class="table-responsive">
                                <table class="table table-sm table-bordered raw-data-table mb-0">
                                    <thead><tr><th>Field</th><th>Value</th></tr></thead>
                                    <tbody id="rawData"></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div id="errorMsg" class="alert alert-danger" style="display: none;"></div>
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
                        <span>WHOIS lookup (Linux/Mac)</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand('whois google.com')"><i class="fas fa-copy"></i></button>
                    </div>
                    <div class="terminal-body">$ whois <code>google.com</code></div>
                </div>
                <div class="terminal-block mt-2">
                    <div class="terminal-header">
                        <span>Using specific WHOIS server</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand('whois -h whois.verisign-grs.com google.com')"><i class="fas fa-copy"></i></button>
                    </div>
                    <div class="terminal-body">$ whois <code>-h whois.verisign-grs.com google.com</code></div>
                </div>
                <div class="terminal-block mt-2">
                    <div class="terminal-header">
                        <span>Windows nslookup for NS</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand('nslookup -type=NS google.com')"><i class="fas fa-copy"></i></button>
                    </div>
                    <div class="terminal-body">C:\> nslookup <code>-type=NS google.com</code></div>
                </div>
            </div>
        </div>
    </div>

</div>

<!-- Related Tools -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light py-2">
        <h6 class="mb-0"><i class="fas fa-tools me-2"></i>Related Domain & Network Tools</h6>
    </div>
    <div class="card-body">
        <div class="related-tools">
            <a href="dns.jsp" class="related-tool-card">
                <h6><i class="fas fa-search me-1"></i>DNS Lookup</h6>
                <p>Query all DNS record types</p>
            </a>
            <a href="dmarc.jsp" class="related-tool-card">
                <h6><i class="fas fa-shield-alt me-1"></i>DMARC Checker</h6>
                <p>Email authentication policy</p>
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
            <a href="curlfunctions.jsp" class="related-tool-card">
                <h6><i class="fas fa-globe me-1"></i>Curl Tool</h6>
                <p>HTTP connectivity test</p>
            </a>
        </div>
    </div>
</div>
<!-- Visible FAQs (bottom) -->
<h2 class="mt-4" id="faqs">FAQs</h2>
<div class="accordion" id="whoisFaqs">
    <div class="card"><div class="card-header"><h6 class="mb-0">What is WHOIS?</h6></div><div class="card-body small text-muted">WHOIS is a public directory of domain registration data: registrar, registrant (if not redacted), name servers, creation/expiry.</div></div>
    <div class="card"><div class="card-header"><h6 class="mb-0">Why is some data hidden?</h6></div><div class="card-body small text-muted">Privacy/GDPR masking or proxy services often redact registrant info. Use registrar contact forms if needed.</div></div>
    <div class="card"><div class="card-header"><h6 class="mb-0">How current is WHOIS data?</h6></div><div class="card-body small text-muted">WHOIS reflects registry/registrar records; updates depend on provider propagation and cache refresh.</div></div>
</div>

<%@ include file="thanks.jsp"%>

<!-- Educational Content -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light">
        <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding WHOIS</h5>
    </div>
    <div class="card-body">
        <h6>What is WHOIS?</h6>
        <p>WHOIS is a query and response protocol used to access databases containing information about registered domain names and IP addresses. It provides details about domain ownership, registration dates, expiration dates, name servers, and registrar information.</p>

        <h6 class="mt-4">WHOIS Information Fields</h6>
        <div class="table-responsive">
            <table class="table table-bordered table-sm">
                <thead class="table-light">
                <tr><th>Field</th><th>Description</th><th>Example</th></tr>
                </thead>
                <tbody class="small">
                <tr><td>Registrar</td><td>Company that registered the domain</td><td>MarkMonitor Inc.</td></tr>
                <tr><td>Creation Date</td><td>When the domain was first registered</td><td>1997-09-15</td></tr>
                <tr><td>Expiration Date</td><td>When the registration expires</td><td>2028-09-14</td></tr>
                <tr><td>Updated Date</td><td>Last modification to WHOIS record</td><td>2019-09-09</td></tr>
                <tr><td>Name Servers</td><td>DNS servers hosting the domain</td><td>ns1.google.com</td></tr>
                <tr><td>Domain Status</td><td>Current state and restrictions</td><td>clientTransferProhibited</td></tr>
                </tbody>
            </table>
        </div>

        <div class="row mt-4">
            <div class="col-md-6">
                <div class="alert alert-info">
                    <h6><i class="fas fa-shield-alt me-1"></i>WHOIS Privacy</h6>
                    <p class="small mb-0">Many domains use privacy protection services (like "Domains By Proxy" or "WhoisGuard") to hide personal contact information from public WHOIS queries, replacing it with generic registrar contact details.</p>
                </div>
            </div>
            <div class="col-md-6">
                <div class="alert alert-warning">
                    <h6><i class="fas fa-exclamation-triangle me-1"></i>GDPR Impact</h6>
                    <p class="small mb-0">Due to GDPR and privacy regulations, many WHOIS servers now redact personal information (email, phone, address) for domains owned by individuals in the EU and other privacy-regulated regions.</p>
                </div>
            </div>
        </div>

        <h6 class="mt-4">Domain Lifecycle</h6>
        <div class="table-responsive">
            <table class="table table-bordered table-sm">
                <thead class="table-light">
                <tr><th>Phase</th><th>Duration</th><th>Description</th></tr>
                </thead>
                <tbody class="small">
                <tr><td>Active</td><td>Registration period</td><td>Domain is registered and functional</td></tr>
                <tr><td>Expired</td><td>~30-45 days</td><td>Grace period - can be renewed at normal price</td></tr>
                <tr><td>Redemption</td><td>~30 days</td><td>Can be recovered with additional fee</td></tr>
                <tr><td>Pending Delete</td><td>~5 days</td><td>Cannot be recovered, awaiting deletion</td></tr>
                <tr><td>Available</td><td>After deletion</td><td>Domain can be registered by anyone</td></tr>
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
                <h5 class="modal-title"><i class="fas fa-share-alt"></i> Share WHOIS Lookup</h5>
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

        $('#whoisForm').submit(function(e) {
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
        $('#domain').val(domain);
        showToast('Applied: ' + domain);
    }

    function performLookup() {
        var domain = $('#domain').val().trim();
        if (!domain) { showToast('Please enter a domain name'); return; }

        lastDomain = domain;
        $('#whoisBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Looking up...');
        $('#errorMsg').hide();

        $.ajax({
            type: 'GET',
            url: 'WhoisFunctionality',
            data: { domain: domain },
            dataType: 'json',
            success: function(data) {
                $('#whoisBtn').prop('disabled', false).html('<i class="fas fa-search me-2"></i>Lookup Domain');
                lastResult = data;
                displayResults(data);
                $('#resultPlaceholder').hide();
                $('#resultContent').show();
                $('#resultActions').show();
            },
            error: function(xhr, status, error) {
                $('#whoisBtn').prop('disabled', false).html('<i class="fas fa-search me-2"></i>Lookup Domain');
                var errorMsg = 'An error occurred while looking up domain information.';
                if (xhr.responseJSON && xhr.responseJSON.error) {
                    errorMsg = xhr.responseJSON.error;
                } else if (xhr.status === 400) {
                    errorMsg = 'Invalid domain format. Please check your input.';
                } else if (xhr.status === 404) {
                    errorMsg = 'Domain not found or lookup failed.';
                }
                $('#errorMsg').text(errorMsg).show();
                $('#resultPlaceholder').hide();
                $('#resultContent').hide();
            }
        });
    }

    function displayResults(data) {
        // Basic info
        $('#lookedUpDomain').text(data.domain || '-');
        $('#registrar').text(data.registrar || 'N/A');
        $('#domainStatus').html(formatStatus(data.domain_status));

        // Dates
        $('#createdDate').text(formatDate(data.created) || 'N/A');
        $('#updatedDate').text(formatDate(data.updated) || 'N/A');
        $('#expiryDate').text(formatDate(data.expires) || 'N/A');

        // Name servers
        var nsHtml = '';
        if (data.name_servers && data.name_servers.length > 0) {
            for (var i = 0; i < data.name_servers.length; i++) {
                nsHtml += '<span class="ns-badge">' + escapeHtml(data.name_servers[i]) + '</span>';
            }
        } else {
            nsHtml = '<span class="text-muted small">No name servers found</span>';
        }
        $('#nameServers').html(nsHtml);

        // Raw data
        var rawHtml = '';
        if (data.raw_data && data.raw_data.length > 0) {
            for (var i = 0; i < data.raw_data.length; i++) {
                var item = data.raw_data[i];
                rawHtml += '<tr><td><strong>' + escapeHtml(item.field || 'Unknown') + '</strong></td>';
                rawHtml += '<td>' + escapeHtml(item.value || 'N/A') + '</td></tr>';
            }
        } else {
            rawHtml = '<tr><td colspan="2" class="text-center text-muted">No raw data available</td></tr>';
        }
        $('#rawData').html(rawHtml);
    }

    function formatDate(dateString) {
        if (!dateString) return 'N/A';
        try {
            var date = new Date(dateString);
            return date.toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' });
        } catch (e) {
            return dateString;
        }
    }

    function formatStatus(status) {
        if (!status) return '<span class="text-muted">N/A</span>';
        var statuses = status.split(/[,;]\s*/);
        var html = '';
        statuses.forEach(function(s) {
            s = s.trim();
            var badgeClass = 'status-active';
            if (s.toLowerCase().includes('prohibited')) badgeClass = 'status-warning';
            if (s.toLowerCase().includes('pending') || s.toLowerCase().includes('redemption')) badgeClass = 'status-danger';
            html += '<span class="status-badge ' + badgeClass + '">' + escapeHtml(s) + '</span> ';
        });
        return html;
    }

    function escapeHtml(text) {
        if (!text) return '';
        var div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    function shareResults() {
        if (!lastDomain) return;
        var url = window.location.origin + window.location.pathname + '?domain=' + encodeURIComponent(lastDomain);
        $('#shareUrlText').val(url);
        $('#shareUrlModal').modal('show');
    }

    function copyResults() {
        if (!lastResult) return;
        var text = 'WHOIS Results for ' + lastResult.domain + '\n';
        text += '========================\n';
        text += 'Registrar: ' + (lastResult.registrar || 'N/A') + '\n';
        text += 'Created: ' + (formatDate(lastResult.created) || 'N/A') + '\n';
        text += 'Updated: ' + (formatDate(lastResult.updated) || 'N/A') + '\n';
        text += 'Expires: ' + (formatDate(lastResult.expires) || 'N/A') + '\n';
        text += 'Status: ' + (lastResult.domain_status || 'N/A') + '\n';
        if (lastResult.name_servers && lastResult.name_servers.length > 0) {
            text += '\nName Servers:\n';
            lastResult.name_servers.forEach(function(ns) { text += '  ' + ns + '\n'; });
        }
        navigator.clipboard.writeText(text).then(function() { showToast('Results copied!'); });
    }

    function loadFromUrl() {
        var params = new URLSearchParams(window.location.search);
        var domain = params.get('domain');
        if (domain) {
            $('#domain').val(domain);
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
