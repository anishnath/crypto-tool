<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Understanding SAML – Complete Guide to SAML 2.0 | 8gwifi.org</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Comprehensive guide to SAML 2.0: Learn about Identity Providers, Service Providers, Assertions, Bindings, XML Signatures, and SSO authentication flows. Essential reference for developers.">
    <meta name="keywords" content="saml guide, saml 2.0, saml tutorial, saml explained, identity provider, service provider, saml assertion, saml binding, sso authentication, xml signature, saml security">

    <!-- Open Graph -->
    <meta property="og:title" content="Understanding SAML – Complete Guide to SAML 2.0 | 8gwifi.org">
    <meta property="og:description" content="Comprehensive guide to SAML 2.0 covering Identity Providers, Service Providers, Assertions, Bindings, and security best practices.">
    <meta property="og:type" content="article">
    <meta property="og:url" content="https://8gwifi.org/saml-guide.jsp">
    <meta property="og:image" content="https://8gwifi.org/images/site/saml-guide.png">

    <!-- Twitter -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="Understanding SAML – Complete Guide | 8gwifi.org">
    <meta name="twitter:description" content="Complete SAML 2.0 reference guide for developers. Learn SSO, assertions, bindings, and security.">

    <!-- Canonical URL -->
    <link rel="canonical" href="https://8gwifi.org/saml-guide.jsp">

    <%@ include file="header-script.jsp"%>

    <!-- JSON-LD -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@graph": [
            {
                "@type": "TechArticle",
                "@id": "https://8gwifi.org/saml-guide.jsp#article",
                "headline": "Understanding SAML 2.0 – Complete Developer Guide",
                "description": "Comprehensive guide to SAML 2.0 covering Identity Providers, Service Providers, Assertions, Bindings, XML Signatures, and security best practices.",
                "url": "https://8gwifi.org/saml-guide.jsp",
                "author": {
                    "@type": "Person",
                    "name": "Anish Nath",
                    "url": "https://x.com/anish2good"
                },
                "datePublished": "2025-01-28",
                "dateModified": "2025-01-28",
                "publisher": {
                    "@type": "Organization",
                    "name": "8gwifi.org",
                    "url": "https://8gwifi.org"
                }
            },
            {
                "@type": "FAQPage",
                "mainEntity": [
                    {
                        "@type": "Question",
                        "name": "What is SAML?",
                        "acceptedAnswer": {
                            "@type": "Answer",
                            "text": "SAML (Security Assertion Markup Language) is an XML-based open standard for exchanging authentication and authorization data between an Identity Provider (IdP) and a Service Provider (SP). It enables Single Sign-On (SSO) across different domains."
                        }
                    },
                    {
                        "@type": "Question",
                        "name": "What is the difference between SAML and OAuth?",
                        "acceptedAnswer": {
                            "@type": "Answer",
                            "text": "SAML is primarily used for enterprise SSO and authentication, while OAuth is designed for authorization (granting access to resources). SAML uses XML and is typically used in browser-based flows, while OAuth uses JSON and is common in API access scenarios."
                        }
                    },
                    {
                        "@type": "Question",
                        "name": "What are SAML bindings?",
                        "acceptedAnswer": {
                            "@type": "Answer",
                            "text": "SAML bindings define how SAML messages are transported between parties. Common bindings include HTTP-POST (messages in form fields), HTTP-Redirect (messages in URL query strings with deflate compression), and SOAP (for back-channel communication)."
                        }
                    }
                ]
            }
        ]
    }
    </script>

    <style>
        :root {
            --theme-primary: #ea580c;
            --theme-secondary: #f97316;
            --theme-gradient: linear-gradient(135deg, #ea580c 0%, #f97316 100%);
            --theme-light: #fff7ed;
        }

        .hero-section {
            background: var(--theme-gradient);
            color: white;
            padding: 3rem 0;
            margin-bottom: 2rem;
        }
        .hero-section h1 {
            font-weight: 700;
            margin-bottom: 1rem;
        }

        .guide-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            margin-bottom: 1.5rem;
            transition: box-shadow 0.2s;
        }
        .guide-card:hover {
            box-shadow: 0 4px 20px rgba(0,0,0,0.12);
        }

        .card-header-custom {
            background: var(--theme-gradient);
            color: white;
            border-radius: 12px 12px 0 0 !important;
            padding: 1rem 1.25rem;
        }
        .card-header-custom h5 {
            margin: 0;
            font-weight: 600;
        }

        .section-header {
            background: var(--theme-light);
            border-left: 4px solid var(--theme-primary);
            padding: 0.75rem 1rem;
            margin-bottom: 1rem;
        }
        .section-header h5 {
            margin: 0;
            color: var(--theme-primary);
            font-weight: 600;
        }

        .info-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 0.25rem 0.6rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
            margin-right: 0.5rem;
            margin-bottom: 0.5rem;
        }

        .concept-card {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 1.25rem;
            margin-bottom: 1rem;
            border-left: 4px solid var(--theme-primary);
        }
        .concept-card h6 {
            color: var(--theme-primary);
            font-weight: 600;
            margin-bottom: 0.75rem;
        }

        .flow-step {
            display: flex;
            align-items: flex-start;
            margin-bottom: 1rem;
            padding: 1rem;
            background: white;
            border-radius: 8px;
            border: 1px solid #e5e7eb;
        }
        .flow-step-number {
            background: var(--theme-gradient);
            color: white;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            flex-shrink: 0;
            margin-right: 1rem;
        }
        .flow-step-content h6 {
            margin-bottom: 0.25rem;
            font-weight: 600;
        }
        .flow-step-content p {
            margin: 0;
            color: #6c757d;
            font-size: 0.9rem;
        }

        .binding-card {
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1rem;
            transition: all 0.2s;
        }
        .binding-card:hover {
            border-color: var(--theme-primary);
            background: var(--theme-light);
        }
        .binding-card h6 {
            color: var(--theme-primary);
            margin-bottom: 0.5rem;
        }
        .binding-card .badge {
            font-size: 0.7rem;
        }

        .xml-example {
            background: #1e293b;
            color: #e2e8f0;
            border-radius: 8px;
            padding: 1rem;
            font-size: 0.8rem;
            overflow-x: auto;
        }
        .xml-example .tag { color: #f472b6; }
        .xml-example .attr { color: #67e8f9; }
        .xml-example .value { color: #a5f3fc; }
        .xml-example .comment { color: #6b7280; }

        .security-tip {
            background: #fef3c7;
            border-left: 4px solid #f59e0b;
            padding: 1rem;
            margin-bottom: 1rem;
            border-radius: 0 8px 8px 0;
        }
        .security-tip h6 {
            color: #92400e;
            margin-bottom: 0.5rem;
        }

        .tools-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 1rem;
        }
        .tool-link {
            display: block;
            padding: 1rem;
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            text-decoration: none;
            color: inherit;
            transition: all 0.2s;
        }
        .tool-link:hover {
            border-color: var(--theme-primary);
            background: var(--theme-light);
            text-decoration: none;
            color: inherit;
        }
        .tool-link h6 {
            color: var(--theme-primary);
            margin-bottom: 0.25rem;
        }
        .tool-link p {
            font-size: 0.8rem;
            color: #6c757d;
            margin: 0;
        }

        .toc-nav {
            position: sticky;
            top: 80px;
        }
        .toc-nav .nav-link {
            color: #6c757d;
            padding: 0.5rem 1rem;
            border-left: 2px solid #e5e7eb;
            font-size: 0.9rem;
        }
        .toc-nav .nav-link:hover,
        .toc-nav .nav-link.active {
            color: var(--theme-primary);
            border-left-color: var(--theme-primary);
            background: var(--theme-light);
        }

        .comparison-table th {
            background: var(--theme-light);
            color: var(--theme-primary);
        }

        .eeat-badge {
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 0.35rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        @media (max-width: 991.98px) {
            .toc-nav {
                position: relative;
                top: 0;
                margin-bottom: 1.5rem;
            }
        }
    </style>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="pgp-menu-nav.jsp"%>

<!-- Hero Section -->
<div class="hero-section">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-8">
                <h1><i class="fas fa-book-open me-3"></i>Understanding SAML 2.0</h1>
                <p class="lead mb-3">A comprehensive guide to Security Assertion Markup Language – the enterprise standard for Single Sign-On (SSO) authentication.</p>
                <div>
                    <span class="info-badge"><i class="fas fa-shield-alt"></i> Authentication</span>
                    <span class="info-badge"><i class="fas fa-exchange-alt"></i> SSO</span>
                    <span class="info-badge"><i class="fas fa-code"></i> XML-Based</span>
                    <span class="info-badge"><i class="fas fa-building"></i> Enterprise</span>
                </div>
            </div>
            <div class="col-lg-4 text-lg-end mt-3 mt-lg-0">
                <span class="eeat-badge">
                    <i class="fas fa-user-check"></i>
                    <span>By Anish Nath</span>
                </span>
            </div>
        </div>
    </div>
</div>

<div class="container">
    <div class="row">
        <!-- Table of Contents - Sidebar -->
        <div class="col-lg-3 mb-4">
            <div class="toc-nav">
                <nav class="nav flex-column">
                    <a class="nav-link" href="#what-is-saml">What is SAML?</a>
                    <a class="nav-link" href="#key-components">Key Components</a>
                    <a class="nav-link" href="#saml-flow">Authentication Flow</a>
                    <a class="nav-link" href="#saml-bindings">SAML Bindings</a>
                    <a class="nav-link" href="#message-types">Message Types</a>
                    <a class="nav-link" href="#assertions">SAML Assertions</a>
                    <a class="nav-link" href="#xml-signatures">XML Signatures</a>
                    <a class="nav-link" href="#security">Security Best Practices</a>
                    <a class="nav-link" href="#saml-vs-others">SAML vs OAuth/OIDC</a>
                    <a class="nav-link" href="#troubleshooting">Troubleshooting</a>
                    <a class="nav-link" href="#tools">SAML Tools</a>
                </nav>
            </div>
        </div>

        <!-- Main Content -->
        <div class="col-lg-9">
            <!-- What is SAML -->
            <section id="what-is-saml" class="mb-5">
                <div class="section-header">
                    <h5><i class="fas fa-question-circle me-2"></i>What is SAML?</h5>
                </div>
                <p><strong>SAML (Security Assertion Markup Language)</strong> is an XML-based open standard for exchanging authentication and authorization data between parties. Developed by OASIS, SAML 2.0 (released in 2005) is the current version widely used in enterprise environments.</p>

                <div class="concept-card">
                    <h6><i class="fas fa-lightbulb me-2"></i>Key Concept</h6>
                    <p class="mb-0">SAML enables <strong>Single Sign-On (SSO)</strong> – users authenticate once with an Identity Provider and can access multiple Service Providers without re-entering credentials. This is especially valuable in enterprise environments with many applications.</p>
                </div>

                <div class="row mt-4">
                    <div class="col-md-6">
                        <div class="concept-card">
                            <h6><i class="fas fa-check-circle text-success me-2"></i>Benefits</h6>
                            <ul class="mb-0 small">
                                <li>Single Sign-On across applications</li>
                                <li>Centralized identity management</li>
                                <li>Reduced password fatigue</li>
                                <li>Improved security posture</li>
                                <li>Cross-domain authentication</li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="concept-card">
                            <h6><i class="fas fa-industry text-primary me-2"></i>Common Use Cases</h6>
                            <ul class="mb-0 small">
                                <li>Enterprise SSO (Okta, Azure AD, OneLogin)</li>
                                <li>Cloud application access</li>
                                <li>Federated identity across organizations</li>
                                <li>Government and healthcare systems</li>
                                <li>B2B partner integrations</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Key Components -->
            <section id="key-components" class="mb-5">
                <div class="section-header">
                    <h5><i class="fas fa-puzzle-piece me-2"></i>Key Components</h5>
                </div>

                <div class="row">
                    <div class="col-md-4 mb-3">
                        <div class="card h-100 guide-card">
                            <div class="card-body text-center">
                                <i class="fas fa-id-card fa-3x mb-3" style="color: var(--theme-primary);"></i>
                                <h5>Identity Provider (IdP)</h5>
                                <p class="small text-muted mb-0">The authority that authenticates users and issues SAML assertions. Examples: Okta, Azure AD, OneLogin, ADFS, Ping Identity.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 mb-3">
                        <div class="card h-100 guide-card">
                            <div class="card-body text-center">
                                <i class="fas fa-server fa-3x mb-3" style="color: var(--theme-primary);"></i>
                                <h5>Service Provider (SP)</h5>
                                <p class="small text-muted mb-0">The application that relies on the IdP for authentication. It consumes SAML assertions to grant access. Examples: Salesforce, Slack, AWS.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 mb-3">
                        <div class="card h-100 guide-card">
                            <div class="card-body text-center">
                                <i class="fas fa-user fa-3x mb-3" style="color: var(--theme-primary);"></i>
                                <h5>Principal (User)</h5>
                                <p class="small text-muted mb-0">The end user who wants to access a service. They authenticate with the IdP and are redirected to the SP with a SAML assertion.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="concept-card mt-3">
                    <h6><i class="fas fa-file-alt me-2"></i>SAML Metadata</h6>
                    <p>Both IdP and SP publish metadata XML files containing:</p>
                    <ul class="mb-0 small">
                        <li><strong>Entity ID:</strong> Unique identifier for the IdP or SP</li>
                        <li><strong>Endpoints:</strong> URLs for SSO, SLO, and Artifact Resolution services</li>
                        <li><strong>Certificates:</strong> X.509 certificates for signing and encryption</li>
                        <li><strong>Supported bindings:</strong> HTTP-POST, HTTP-Redirect, etc.</li>
                        <li><strong>Name ID formats:</strong> Email, persistent, transient identifiers</li>
                    </ul>
                </div>
            </section>

            <!-- SAML Authentication Flow -->
            <section id="saml-flow" class="mb-5">
                <div class="section-header">
                    <h5><i class="fas fa-project-diagram me-2"></i>SAML Authentication Flow</h5>
                </div>
                <p>There are two main flows: <strong>SP-Initiated</strong> (most common) and <strong>IdP-Initiated</strong>.</p>

                <h6 class="mt-4 mb-3"><i class="fas fa-arrow-right me-2"></i>SP-Initiated SSO Flow</h6>
                <div class="flow-step">
                    <div class="flow-step-number">1</div>
                    <div class="flow-step-content">
                        <h6>User Accesses SP</h6>
                        <p>User tries to access a protected resource on the Service Provider (e.g., app.example.com).</p>
                    </div>
                </div>
                <div class="flow-step">
                    <div class="flow-step-number">2</div>
                    <div class="flow-step-content">
                        <h6>SP Generates AuthnRequest</h6>
                        <p>SP creates a SAML AuthnRequest and redirects user to IdP with the request (via HTTP-Redirect or HTTP-POST binding).</p>
                    </div>
                </div>
                <div class="flow-step">
                    <div class="flow-step-number">3</div>
                    <div class="flow-step-content">
                        <h6>User Authenticates at IdP</h6>
                        <p>IdP presents login page. User enters credentials (or uses existing session if already logged in).</p>
                    </div>
                </div>
                <div class="flow-step">
                    <div class="flow-step-number">4</div>
                    <div class="flow-step-content">
                        <h6>IdP Generates Response</h6>
                        <p>IdP creates a SAML Response containing an Assertion with user attributes and signs it with its private key.</p>
                    </div>
                </div>
                <div class="flow-step">
                    <div class="flow-step-number">5</div>
                    <div class="flow-step-content">
                        <h6>Response Sent to SP</h6>
                        <p>User's browser POSTs the SAML Response to the SP's Assertion Consumer Service (ACS) URL.</p>
                    </div>
                </div>
                <div class="flow-step">
                    <div class="flow-step-number">6</div>
                    <div class="flow-step-content">
                        <h6>SP Validates & Grants Access</h6>
                        <p>SP verifies the signature, checks conditions (time validity, audience), extracts user info, and creates a local session.</p>
                    </div>
                </div>

                <div class="security-tip mt-4">
                    <h6><i class="fas fa-exclamation-triangle me-2"></i>IdP-Initiated Flow</h6>
                    <p class="mb-0 small">In IdP-initiated SSO, the user starts at the IdP portal and clicks on an application. The IdP sends an unsolicited SAML Response to the SP. This flow is less secure as there's no AuthnRequest to tie the response to, making replay attacks easier.</p>
                </div>
            </section>

            <!-- SAML Bindings -->
            <section id="saml-bindings" class="mb-5">
                <div class="section-header">
                    <h5><i class="fas fa-link me-2"></i>SAML Bindings</h5>
                </div>
                <p>Bindings define how SAML messages are transported between IdP and SP.</p>

                <div class="row">
                    <div class="col-md-6">
                        <div class="binding-card">
                            <h6><i class="fas fa-envelope me-2"></i>HTTP-POST Binding</h6>
                            <span class="badge bg-success me-1">Most Common</span>
                            <span class="badge bg-info">Large Messages</span>
                            <p class="small mt-2 mb-2">Messages are Base64-encoded and sent in HTML form fields. Supports large payloads (signed responses with assertions).</p>
                            <pre class="xml-example mb-0"><code>&lt;form method="POST" action="https://sp.example.com/acs"&gt;
  &lt;input type="hidden" name="SAMLResponse" value="PHNhbWxwOl..."/&gt;
  &lt;input type="hidden" name="RelayState" value="..."/&gt;
&lt;/form&gt;</code></pre>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="binding-card">
                            <h6><i class="fas fa-share me-2"></i>HTTP-Redirect Binding</h6>
                            <span class="badge bg-warning text-dark me-1">URL Length Limit</span>
                            <span class="badge bg-secondary">Requests Only</span>
                            <p class="small mt-2 mb-2">Messages are DEFLATE-compressed, Base64-encoded, and URL-encoded in query parameters. Used for AuthnRequests.</p>
                            <pre class="xml-example mb-0"><code>https://idp.example.com/sso?
  SAMLRequest=fZJNT8Mw...&amp;
  RelayState=...&amp;
  SigAlg=...&amp;
  Signature=...</code></pre>
                        </div>
                    </div>
                </div>

                <div class="row mt-3">
                    <div class="col-md-6">
                        <div class="binding-card">
                            <h6><i class="fas fa-network-wired me-2"></i>SOAP Binding</h6>
                            <span class="badge bg-secondary">Back-channel</span>
                            <p class="small mt-2 mb-0">Direct server-to-server communication using SOAP. Used for Artifact Resolution and Attribute Queries. Not browser-based.</p>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="binding-card">
                            <h6><i class="fas fa-ticket-alt me-2"></i>Artifact Binding</h6>
                            <span class="badge bg-secondary">Reference-based</span>
                            <p class="small mt-2 mb-0">Instead of sending the full message, a small artifact (reference) is passed. SP resolves the artifact via back-channel to retrieve the actual message.</p>
                        </div>
                    </div>
                </div>

                <div class="concept-card mt-4">
                    <h6><i class="fas fa-compress-alt me-2"></i>HTTP-Redirect Encoding Process</h6>
                    <ol class="mb-0 small">
                        <li><strong>Start:</strong> Raw XML message</li>
                        <li><strong>Deflate:</strong> Compress using DEFLATE algorithm (RFC 1951)</li>
                        <li><strong>Base64:</strong> Encode the compressed bytes</li>
                        <li><strong>URL Encode:</strong> Make safe for URL query string</li>
                        <li><strong>Sign (optional):</strong> Add signature as separate query parameter</li>
                    </ol>
                </div>
            </section>

            <!-- Message Types -->
            <section id="message-types" class="mb-5">
                <div class="section-header">
                    <h5><i class="fas fa-envelope-open-text me-2"></i>SAML Message Types</h5>
                </div>

                <table class="table table-bordered">
                    <thead class="table-light">
                        <tr>
                            <th>Message</th>
                            <th>Sender</th>
                            <th>Purpose</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><code>AuthnRequest</code></td>
                            <td>SP → IdP</td>
                            <td>Request authentication of a user</td>
                        </tr>
                        <tr>
                            <td><code>Response</code></td>
                            <td>IdP → SP</td>
                            <td>Contains authentication result and user assertions</td>
                        </tr>
                        <tr>
                            <td><code>LogoutRequest</code></td>
                            <td>SP/IdP</td>
                            <td>Request termination of user session (Single Logout)</td>
                        </tr>
                        <tr>
                            <td><code>LogoutResponse</code></td>
                            <td>SP/IdP</td>
                            <td>Acknowledge logout request</td>
                        </tr>
                        <tr>
                            <td><code>AttributeQuery</code></td>
                            <td>SP → IdP</td>
                            <td>Request additional user attributes</td>
                        </tr>
                        <tr>
                            <td><code>ArtifactResolve</code></td>
                            <td>SP → IdP</td>
                            <td>Retrieve full message from artifact reference</td>
                        </tr>
                    </tbody>
                </table>

                <h6 class="mt-4"><i class="fas fa-code me-2"></i>Example AuthnRequest</h6>
                <pre class="xml-example"><code><span class="tag">&lt;samlp:AuthnRequest</span>
    <span class="attr">xmlns:samlp</span>=<span class="value">"urn:oasis:names:tc:SAML:2.0:protocol"</span>
    <span class="attr">ID</span>=<span class="value">"_abc123"</span>
    <span class="attr">Version</span>=<span class="value">"2.0"</span>
    <span class="attr">IssueInstant</span>=<span class="value">"2025-01-28T10:00:00Z"</span>
    <span class="attr">Destination</span>=<span class="value">"https://idp.example.com/sso"</span>
    <span class="attr">AssertionConsumerServiceURL</span>=<span class="value">"https://sp.example.com/acs"</span>
    <span class="attr">ProtocolBinding</span>=<span class="value">"urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"</span><span class="tag">&gt;</span>
    <span class="tag">&lt;saml:Issuer&gt;</span>https://sp.example.com<span class="tag">&lt;/saml:Issuer&gt;</span>
    <span class="tag">&lt;samlp:NameIDPolicy</span>
        <span class="attr">Format</span>=<span class="value">"urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"</span>
        <span class="attr">AllowCreate</span>=<span class="value">"true"</span><span class="tag">/&gt;</span>
<span class="tag">&lt;/samlp:AuthnRequest&gt;</span></code></pre>
            </section>

            <!-- SAML Assertions -->
            <section id="assertions" class="mb-5">
                <div class="section-header">
                    <h5><i class="fas fa-certificate me-2"></i>SAML Assertions</h5>
                </div>
                <p>An Assertion is the core of SAML – it contains statements about the user made by the IdP.</p>

                <div class="row">
                    <div class="col-md-4">
                        <div class="concept-card h-100">
                            <h6><i class="fas fa-user-check text-success me-2"></i>Authentication Statement</h6>
                            <p class="small mb-0">Confirms the user was authenticated at a specific time using a specific method (password, MFA, certificate, etc.).</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="concept-card h-100">
                            <h6><i class="fas fa-tags text-primary me-2"></i>Attribute Statement</h6>
                            <p class="small mb-0">Contains user attributes like email, name, groups, roles. These are used by SP for authorization decisions.</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="concept-card h-100">
                            <h6><i class="fas fa-shield-alt text-warning me-2"></i>Authorization Decision</h6>
                            <p class="small mb-0">States whether the user is permitted/denied access to a specific resource. Rarely used in practice.</p>
                        </div>
                    </div>
                </div>

                <h6 class="mt-4"><i class="fas fa-code me-2"></i>Assertion Structure</h6>
                <pre class="xml-example"><code><span class="tag">&lt;saml:Assertion</span> <span class="attr">ID</span>=<span class="value">"_xyz789"</span> <span class="attr">IssueInstant</span>=<span class="value">"2025-01-28T10:00:30Z"</span><span class="tag">&gt;</span>
  <span class="tag">&lt;saml:Issuer&gt;</span>https://idp.example.com<span class="tag">&lt;/saml:Issuer&gt;</span>
  <span class="tag">&lt;ds:Signature&gt;</span>...<span class="tag">&lt;/ds:Signature&gt;</span>

  <span class="tag">&lt;saml:Subject&gt;</span>
    <span class="tag">&lt;saml:NameID</span> <span class="attr">Format</span>=<span class="value">"emailAddress"</span><span class="tag">&gt;</span>user@example.com<span class="tag">&lt;/saml:NameID&gt;</span>
    <span class="tag">&lt;saml:SubjectConfirmation</span> <span class="attr">Method</span>=<span class="value">"bearer"</span><span class="tag">&gt;</span>
      <span class="tag">&lt;saml:SubjectConfirmationData</span>
        <span class="attr">NotOnOrAfter</span>=<span class="value">"2025-01-28T10:05:30Z"</span>
        <span class="attr">Recipient</span>=<span class="value">"https://sp.example.com/acs"</span><span class="tag">/&gt;</span>
    <span class="tag">&lt;/saml:SubjectConfirmation&gt;</span>
  <span class="tag">&lt;/saml:Subject&gt;</span>

  <span class="tag">&lt;saml:Conditions</span> <span class="attr">NotBefore</span>=<span class="value">"..."</span> <span class="attr">NotOnOrAfter</span>=<span class="value">"..."</span><span class="tag">&gt;</span>
    <span class="tag">&lt;saml:AudienceRestriction&gt;</span>
      <span class="tag">&lt;saml:Audience&gt;</span>https://sp.example.com<span class="tag">&lt;/saml:Audience&gt;</span>
    <span class="tag">&lt;/saml:AudienceRestriction&gt;</span>
  <span class="tag">&lt;/saml:Conditions&gt;</span>

  <span class="tag">&lt;saml:AuthnStatement</span> <span class="attr">AuthnInstant</span>=<span class="value">"..."</span><span class="tag">&gt;</span>
    <span class="tag">&lt;saml:AuthnContext&gt;</span>
      <span class="tag">&lt;saml:AuthnContextClassRef&gt;</span>PasswordProtectedTransport<span class="tag">&lt;/saml:AuthnContextClassRef&gt;</span>
    <span class="tag">&lt;/saml:AuthnContext&gt;</span>
  <span class="tag">&lt;/saml:AuthnStatement&gt;</span>

  <span class="tag">&lt;saml:AttributeStatement&gt;</span>
    <span class="tag">&lt;saml:Attribute</span> <span class="attr">Name</span>=<span class="value">"firstName"</span><span class="tag">&gt;</span>
      <span class="tag">&lt;saml:AttributeValue&gt;</span>John<span class="tag">&lt;/saml:AttributeValue&gt;</span>
    <span class="tag">&lt;/saml:Attribute&gt;</span>
    <span class="tag">&lt;saml:Attribute</span> <span class="attr">Name</span>=<span class="value">"groups"</span><span class="tag">&gt;</span>
      <span class="tag">&lt;saml:AttributeValue&gt;</span>admin<span class="tag">&lt;/saml:AttributeValue&gt;</span>
      <span class="tag">&lt;saml:AttributeValue&gt;</span>users<span class="tag">&lt;/saml:AttributeValue&gt;</span>
    <span class="tag">&lt;/saml:Attribute&gt;</span>
  <span class="tag">&lt;/saml:AttributeStatement&gt;</span>
<span class="tag">&lt;/saml:Assertion&gt;</span></code></pre>

                <div class="concept-card mt-4">
                    <h6><i class="fas fa-id-badge me-2"></i>Name ID Formats</h6>
                    <table class="table table-sm mb-0">
                        <tr><td><code>emailAddress</code></td><td>User's email address</td></tr>
                        <tr><td><code>persistent</code></td><td>Opaque, stable identifier across sessions</td></tr>
                        <tr><td><code>transient</code></td><td>Temporary identifier, changes per session</td></tr>
                        <tr><td><code>unspecified</code></td><td>Any format, IdP decides</td></tr>
                    </table>
                </div>
            </section>

            <!-- XML Digital Signatures -->
            <section id="xml-signatures" class="mb-5">
                <div class="section-header">
                    <h5><i class="fas fa-file-signature me-2"></i>XML Digital Signatures</h5>
                </div>
                <p>SAML uses XML Digital Signatures (XMLDSig) to ensure message integrity and authenticity.</p>

                <div class="row">
                    <div class="col-md-6">
                        <div class="concept-card">
                            <h6><i class="fas fa-lock me-2"></i>What Gets Signed?</h6>
                            <ul class="mb-0 small">
                                <li><strong>Response:</strong> Entire SAML Response element</li>
                                <li><strong>Assertion:</strong> Just the Assertion element</li>
                                <li><strong>Both:</strong> Some IdPs sign both</li>
                                <li><strong>AuthnRequest:</strong> Can be signed for non-repudiation</li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="concept-card">
                            <h6><i class="fas fa-cogs me-2"></i>Signature Process</h6>
                            <ol class="mb-0 small">
                                <li>Canonicalize XML (C14N)</li>
                                <li>Compute digest of canonicalized content</li>
                                <li>Create SignedInfo with digest</li>
                                <li>Sign SignedInfo with private key</li>
                                <li>Embed signature in document</li>
                            </ol>
                        </div>
                    </div>
                </div>

                <h6 class="mt-4"><i class="fas fa-code me-2"></i>Signature Structure</h6>
                <pre class="xml-example"><code><span class="tag">&lt;ds:Signature</span> <span class="attr">xmlns:ds</span>=<span class="value">"http://www.w3.org/2000/09/xmldsig#"</span><span class="tag">&gt;</span>
  <span class="tag">&lt;ds:SignedInfo&gt;</span>
    <span class="tag">&lt;ds:CanonicalizationMethod</span> <span class="attr">Algorithm</span>=<span class="value">"...xml-exc-c14n#"</span><span class="tag">/&gt;</span>
    <span class="tag">&lt;ds:SignatureMethod</span> <span class="attr">Algorithm</span>=<span class="value">"...rsa-sha256"</span><span class="tag">/&gt;</span>
    <span class="tag">&lt;ds:Reference</span> <span class="attr">URI</span>=<span class="value">"#_assertionId"</span><span class="tag">&gt;</span>
      <span class="tag">&lt;ds:Transforms&gt;</span>
        <span class="tag">&lt;ds:Transform</span> <span class="attr">Algorithm</span>=<span class="value">"...enveloped-signature"</span><span class="tag">/&gt;</span>
        <span class="tag">&lt;ds:Transform</span> <span class="attr">Algorithm</span>=<span class="value">"...xml-exc-c14n#"</span><span class="tag">/&gt;</span>
      <span class="tag">&lt;/ds:Transforms&gt;</span>
      <span class="tag">&lt;ds:DigestMethod</span> <span class="attr">Algorithm</span>=<span class="value">"...sha256"</span><span class="tag">/&gt;</span>
      <span class="tag">&lt;ds:DigestValue&gt;</span>base64-encoded-digest<span class="tag">&lt;/ds:DigestValue&gt;</span>
    <span class="tag">&lt;/ds:Reference&gt;</span>
  <span class="tag">&lt;/ds:SignedInfo&gt;</span>
  <span class="tag">&lt;ds:SignatureValue&gt;</span>base64-encoded-signature<span class="tag">&lt;/ds:SignatureValue&gt;</span>
  <span class="tag">&lt;ds:KeyInfo&gt;</span>
    <span class="tag">&lt;ds:X509Data&gt;</span>
      <span class="tag">&lt;ds:X509Certificate&gt;</span>base64-encoded-cert<span class="tag">&lt;/ds:X509Certificate&gt;</span>
    <span class="tag">&lt;/ds:X509Data&gt;</span>
  <span class="tag">&lt;/ds:KeyInfo&gt;</span>
<span class="tag">&lt;/ds:Signature&gt;</span></code></pre>

                <div class="security-tip mt-4">
                    <h6><i class="fas fa-shield-alt me-2"></i>Signature Validation Steps</h6>
                    <ol class="mb-0 small">
                        <li>Extract the certificate from KeyInfo or use pre-configured IdP certificate</li>
                        <li>Verify the certificate is trusted (chain validation)</li>
                        <li>Canonicalize the signed element using specified algorithm</li>
                        <li>Compute digest and compare with DigestValue</li>
                        <li>Verify SignatureValue using the public key</li>
                    </ol>
                </div>
            </section>

            <!-- Security Best Practices -->
            <section id="security" class="mb-5">
                <div class="section-header">
                    <h5><i class="fas fa-shield-alt me-2"></i>Security Best Practices</h5>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="security-tip">
                            <h6><i class="fas fa-check me-2"></i>Always Validate</h6>
                            <ul class="mb-0 small">
                                <li>Verify XML signature using IdP certificate</li>
                                <li>Check NotBefore and NotOnOrAfter conditions</li>
                                <li>Validate Audience matches your SP Entity ID</li>
                                <li>Verify Destination matches your ACS URL</li>
                                <li>Check InResponseTo matches your AuthnRequest ID</li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="security-tip">
                            <h6><i class="fas fa-times me-2"></i>Common Vulnerabilities</h6>
                            <ul class="mb-0 small">
                                <li><strong>XML Signature Wrapping:</strong> Moving signed content</li>
                                <li><strong>XXE:</strong> XML External Entity injection</li>
                                <li><strong>Replay Attacks:</strong> Reusing valid assertions</li>
                                <li><strong>Comment Injection:</strong> Bypassing canonicalization</li>
                                <li><strong>Missing Validation:</strong> Skipping security checks</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <div class="concept-card mt-3">
                    <h6><i class="fas fa-clock me-2"></i>Time-Based Security</h6>
                    <table class="table table-sm mb-0">
                        <tr>
                            <td><code>NotBefore</code></td>
                            <td>Assertion is not valid before this time</td>
                        </tr>
                        <tr>
                            <td><code>NotOnOrAfter</code></td>
                            <td>Assertion expires at this time (typically 5 minutes)</td>
                        </tr>
                        <tr>
                            <td><code>SessionNotOnOrAfter</code></td>
                            <td>When to force re-authentication</td>
                        </tr>
                    </table>
                    <p class="small mt-2 mb-0"><strong>Clock Skew:</strong> Allow 1-2 minutes tolerance for server time differences.</p>
                </div>
            </section>

            <!-- SAML vs OAuth/OIDC -->
            <section id="saml-vs-others" class="mb-5">
                <div class="section-header">
                    <h5><i class="fas fa-balance-scale me-2"></i>SAML vs OAuth 2.0 vs OpenID Connect</h5>
                </div>

                <table class="table table-bordered comparison-table">
                    <thead>
                        <tr>
                            <th>Aspect</th>
                            <th>SAML 2.0</th>
                            <th>OAuth 2.0</th>
                            <th>OpenID Connect</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><strong>Purpose</strong></td>
                            <td>Authentication + Attributes</td>
                            <td>Authorization</td>
                            <td>Authentication (on top of OAuth)</td>
                        </tr>
                        <tr>
                            <td><strong>Format</strong></td>
                            <td>XML</td>
                            <td>JSON</td>
                            <td>JSON + JWT</td>
                        </tr>
                        <tr>
                            <td><strong>Token</strong></td>
                            <td>SAML Assertion</td>
                            <td>Access Token</td>
                            <td>ID Token (JWT)</td>
                        </tr>
                        <tr>
                            <td><strong>Transport</strong></td>
                            <td>Browser redirects/POSTs</td>
                            <td>HTTP APIs</td>
                            <td>HTTP APIs</td>
                        </tr>
                        <tr>
                            <td><strong>Best For</strong></td>
                            <td>Enterprise SSO, Legacy</td>
                            <td>API Authorization, Mobile</td>
                            <td>Modern SSO, Consumer Apps</td>
                        </tr>
                        <tr>
                            <td><strong>Complexity</strong></td>
                            <td>High</td>
                            <td>Medium</td>
                            <td>Medium</td>
                        </tr>
                    </tbody>
                </table>

                <div class="concept-card">
                    <h6><i class="fas fa-lightbulb me-2"></i>When to Use What?</h6>
                    <ul class="mb-0 small">
                        <li><strong>SAML:</strong> Enterprise environments, existing IdPs (Okta, Azure AD), legacy systems, cross-domain SSO</li>
                        <li><strong>OAuth 2.0:</strong> API access, mobile apps, third-party integrations (e.g., "Login with Google to access your Drive")</li>
                        <li><strong>OpenID Connect:</strong> Modern web apps, mobile apps, when you need both authentication and simple API access</li>
                    </ul>
                </div>
            </section>

            <!-- Troubleshooting -->
            <section id="troubleshooting" class="mb-5">
                <div class="section-header">
                    <h5><i class="fas fa-bug me-2"></i>Troubleshooting Common Issues</h5>
                </div>

                <div class="accordion" id="troubleshootingAccordion">
                    <div class="card mb-2">
                        <div class="card-header" id="headingOne">
                            <h6 class="mb-0">
                                <button class="btn btn-link text-left w-100" type="button" data-toggle="collapse" data-target="#collapseOne">
                                    <i class="fas fa-exclamation-triangle text-warning me-2"></i>Signature Verification Failed
                                </button>
                            </h6>
                        </div>
                        <div id="collapseOne" class="collapse show" data-parent="#troubleshootingAccordion">
                            <div class="card-body small">
                                <ul>
                                    <li>Ensure you're using the correct IdP certificate (not SP certificate)</li>
                                    <li>Check if IdP certificate has been rotated/renewed</li>
                                    <li>Verify you're checking the right element (Response vs Assertion)</li>
                                    <li>Look for XML modifications during transport (whitespace, encoding)</li>
                                    <li>Check canonicalization algorithm compatibility</li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <div class="card mb-2">
                        <div class="card-header" id="headingTwo">
                            <h6 class="mb-0">
                                <button class="btn btn-link text-left w-100 collapsed" type="button" data-toggle="collapse" data-target="#collapseTwo">
                                    <i class="fas fa-clock text-danger me-2"></i>Assertion Expired / NotBefore Error
                                </button>
                            </h6>
                        </div>
                        <div id="collapseTwo" class="collapse" data-parent="#troubleshootingAccordion">
                            <div class="card-body small">
                                <ul>
                                    <li>Check server clocks on both IdP and SP (use NTP)</li>
                                    <li>Configure clock skew tolerance (1-2 minutes)</li>
                                    <li>Verify timezone settings are correct</li>
                                    <li>Check if assertion validity period is too short</li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <div class="card mb-2">
                        <div class="card-header" id="headingThree">
                            <h6 class="mb-0">
                                <button class="btn btn-link text-left w-100 collapsed" type="button" data-toggle="collapse" data-target="#collapseThree">
                                    <i class="fas fa-users text-info me-2"></i>Audience Restriction Failure
                                </button>
                            </h6>
                        </div>
                        <div id="collapseThree" class="collapse" data-parent="#troubleshootingAccordion">
                            <div class="card-body small">
                                <ul>
                                    <li>Verify your SP Entity ID matches exactly what IdP expects</li>
                                    <li>Check for trailing slashes in Entity ID</li>
                                    <li>Ensure case sensitivity matches</li>
                                    <li>Update IdP configuration if SP Entity ID changed</li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <div class="card mb-2">
                        <div class="card-header" id="headingFour">
                            <h6 class="mb-0">
                                <button class="btn btn-link text-left w-100 collapsed" type="button" data-toggle="collapse" data-target="#collapseFour">
                                    <i class="fas fa-link text-primary me-2"></i>Invalid Destination
                                </button>
                            </h6>
                        </div>
                        <div id="collapseFour" class="collapse" data-parent="#troubleshootingAccordion">
                            <div class="card-body small">
                                <ul>
                                    <li>Verify ACS URL in IdP config matches your actual endpoint</li>
                                    <li>Check for HTTP vs HTTPS mismatch</li>
                                    <li>Verify URL path is correct (case sensitive)</li>
                                    <li>Ensure no load balancer is rewriting URLs</li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <div class="card mb-2">
                        <div class="card-header" id="headingFive">
                            <h6 class="mb-0">
                                <button class="btn btn-link text-left w-100 collapsed" type="button" data-toggle="collapse" data-target="#collapseFive">
                                    <i class="fas fa-code text-secondary me-2"></i>Cannot Decode SAML Message
                                </button>
                            </h6>
                        </div>
                        <div id="collapseFive" class="collapse" data-parent="#troubleshootingAccordion">
                            <div class="card-body small">
                                <ul>
                                    <li>HTTP-Redirect: Needs URL decode → Base64 decode → Inflate</li>
                                    <li>HTTP-POST: Just needs Base64 decode</li>
                                    <li>Check for double-encoding issues</li>
                                    <li>Use our <a href="samlverifysign.jsp">SAML Decoder tool</a> to test</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Tools -->
            <section id="tools" class="mb-5">
                <div class="section-header">
                    <h5><i class="fas fa-tools me-2"></i>SAML Tools</h5>
                </div>
                <p>Use these tools to work with SAML messages:</p>

                <div class="tools-grid">
                    <a href="samlfunctions.jsp" class="tool-link">
                        <h6><i class="fas fa-file-signature me-2"></i>SAML Sign</h6>
                        <p>Sign SAML XML messages with your private key</p>
                    </a>
                    <a href="samlverifysign.jsp" class="tool-link">
                        <h6><i class="fas fa-check-double me-2"></i>SAML Verify & Decode</h6>
                        <p>Verify signatures and decode Base64/deflated messages</p>
                    </a>
                    <a href="PemParserFunctions.jsp" class="tool-link">
                        <h6><i class="fas fa-certificate me-2"></i>PEM Parser</h6>
                        <p>Parse and decode X.509 certificates</p>
                    </a>
                    <a href="rsafunctions.jsp" class="tool-link">
                        <h6><i class="fas fa-key me-2"></i>RSA Tools</h6>
                        <p>RSA key generation, encryption, signing</p>
                    </a>
                    <a href="base64.jsp" class="tool-link">
                        <h6><i class="fas fa-exchange-alt me-2"></i>Base64 Encoder</h6>
                        <p>Encode and decode Base64 strings</p>
                    </a>
                    <a href="xmlsignverify.jsp" class="tool-link">
                        <h6><i class="fas fa-file-code me-2"></i>XML Sign/Verify</h6>
                        <p>Generic XML digital signature tools</p>
                    </a>
                </div>
            </section>

            <!-- References -->
            <div class="card guide-card">
                <div class="card-header bg-light">
                    <h6 class="mb-0"><i class="fas fa-book me-2"></i>Further Reading</h6>
                </div>
                <div class="card-body small">
                    <ul class="mb-0">
                        <li><a href="https://docs.oasis-open.org/security/saml/v2.0/" target="_blank" rel="noopener">OASIS SAML 2.0 Specification</a></li>
                        <li><a href="https://www.w3.org/TR/xmldsig-core1/" target="_blank" rel="noopener">W3C XML Signature Syntax and Processing</a></li>
                        <li><a href="https://wiki.oasis-open.org/security/FrontPage" target="_blank" rel="noopener">OASIS Security Services Wiki</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <hr class="mt-5">
    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>
    <%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>
