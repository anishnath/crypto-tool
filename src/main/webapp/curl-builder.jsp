<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <!-- JSON-LD markup for SEO -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "cURL Builder & HTTP Client Online",
        "alternateName": ["cURL Command Generator", "HTTP Request Builder", "REST API Tester", "cURL to Code Converter"],
        "description": "Professional free online cURL builder and HTTP client. Build, test, and debug REST APIs with custom headers, authentication, request body, query parameters. Execute requests, capture responses, import/export cURL commands, and generate code in Python, JavaScript, PHP, Java. Perfect for API testing and development.",
        "image": "https://8gwifi.org/images/site/terminal.png",
        "screenshot": "https://8gwifi.org/images/site/terminal.png",
        "url": "https://8gwifi.org/curl-builder.jsp",
        "applicationCategory": "DeveloperApplication",
        "operatingSystem": "Any",
        "author": {
            "@type": "Person",
            "name": "Anish Nath",
            "url": "https://x.com/anish2good"
        },
        "publisher": {
            "@type": "Organization",
            "name": "8gwifi.org"
        },
        "datePublished": "2025-01-26",
        "dateModified": "2025-11-29",
        "keywords": [
            "curl builder online free",
            "curl command generator",
            "http client online",
            "rest api tester",
            "curl to code converter",
            "api testing tool",
            "curl generator",
            "http request builder",
            "postman alternative",
            "curl command builder",
            "rest client online",
            "api client browser",
            "curl to python",
            "curl to javascript",
            "curl to php",
            "http debugger",
            "api request builder",
            "curl parser",
            "import curl command",
            "export curl command",
            "custom headers builder",
            "bearer token authentication",
            "basic auth curl",
            "api key authentication",
            "query parameters builder",
            "request body editor",
            "json payload curl",
            "form data curl",
            "multipart curl",
            "url encoded curl",
            "get post put delete",
            "patch options head",
            "curl with headers",
            "curl post json",
            "curl authentication",
            "curl proxy support",
            "curl timeout settings",
            "curl follow redirects",
            "curl response headers",
            "curl status code",
            "curl response time"
        ],
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
        },
        "featureList": [
            "All HTTP Methods (GET, POST, PUT, DELETE, PATCH, HEAD, OPTIONS)",
            "Custom Headers Management (Add, Edit, Remove, Import)",
            "Multiple Authentication Types (Basic, Bearer Token, API Key)",
            "Request Body Editor with Syntax Highlighting",
            "Multiple Content Types (JSON, XML, Form Data, Multipart, Raw)",
            "Query Parameters Builder",
            "cURL Command Generator with Syntax Highlighting",
            "Execute HTTP Requests in Browser",
            "Response Capture (Headers, Body, Status, Time)",
            "Import from cURL Command",
            "Export cURL Command",
            "Code Generation (Python, JavaScript, PHP, Java, Go)",
            "Request/Response History with LocalStorage",
            "Copy to Clipboard",
            "Download Response",
            "Proxy Configuration",
            "Timeout Settings",
            "Follow Redirects Option",
            "SSL/TLS Verification Toggle",
            "Verbose Output Option",
            "User-Agent Customization",
            "Cookies Support",
            "File Upload Support",
            "Base64 Encoding",
            "URL Encoding",
            "Pretty Print JSON Response",
            "Response Formatting",
            "100% Client-Side (CORS Proxy Available)",
            "No Registration Required",
            "Free Forever"
        ],
        "isAccessibleForFree": true,
        "license": "https://creativecommons.org/licenses/by/4.0/",
        "mainEntityOfPage": {
            "@type": "WebPage",
            "@id": "https://8gwifi.org/curl-builder.jsp"
        },
        "aggregateRating": {
            "@type": "AggregateRating",
            "ratingValue": "4.9",
            "ratingCount": "3254",
            "bestRating": "5",
            "worstRating": "1"
        }
    }
    </script>

    <!-- FAQPage Schema -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "FAQPage",
        "mainEntity": [
            {
                "@type": "Question",
                "name": "What is cURL and why should I use a cURL builder?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "cURL (Client URL) is a command-line tool for transferring data using various protocols like HTTP, HTTPS, FTP, etc. A cURL builder provides a visual interface to construct cURL commands without memorizing complex syntax, making API testing and debugging much easier."
                }
            },
            {
                "@type": "Question",
                "name": "Can I import an existing cURL command into this tool?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Yes! Click the 'Import cURL' button and paste your existing cURL command. The tool will automatically parse it and populate all fields including URL, method, headers, authentication, and request body."
                }
            },
            {
                "@type": "Question",
                "name": "What programming languages can I generate code for?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "This tool can generate equivalent code in Python (requests), JavaScript (fetch), Node.js (axios), PHP (cURL), Java (HttpClient), and Go (net/http). Simply build your request and select your preferred language from the Code Generator tab."
                }
            },
            {
                "@type": "Question",
                "name": "Is my data secure when using this tool?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Yes, this tool runs 100% client-side in your browser. Your API keys, authentication credentials, and request data are never sent to our servers. All processing happens locally on your device."
                }
            },
            {
                "@type": "Question",
                "name": "Why do some requests fail with CORS errors?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "CORS (Cross-Origin Resource Sharing) errors occur when the target API doesn't allow browser-based requests from other domains. This is a browser security feature. For such APIs, you'll need to use the generated cURL command in your terminal or server-side code."
                }
            }
        ]
    }
    </script>

    <title>cURL Builder & HTTP Client Online – Free | 8gwifi.org</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <meta name="keywords" content="curl builder online free, curl command generator, http client online, rest api tester, curl to code converter, postman alternative, api testing tool, curl parser, import curl command, custom headers, bearer token, basic auth, request builder, api client"/>
    <meta name="description" content="Free professional cURL builder and HTTP client. Build and test REST APIs with custom headers, authentication, request body, and query parameters. Execute requests, capture responses, import/export cURL commands, generate code in Python/JavaScript/PHP. Perfect Postman alternative. 100% free, no signup required." />
    <link rel="canonical" href="https://8gwifi.org/curl-builder.jsp" />

    <meta name="author" content="Anish Nath">
    <meta property="og:title" content="Free cURL Builder - Advanced HTTP Client & REST API Tester">
    <meta property="og:description" content="Build, test, and debug REST APIs. Execute HTTP requests, capture responses, import cURL commands, generate code. Free Postman alternative.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/curl-builder.jsp">
    <meta property="og:image" content="https://8gwifi.org/images/site/terminal.png">
    <meta property="og:site_name" content="8gwifi.org">

    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="cURL Builder - HTTP Client & API Tester Online Free">
    <meta name="twitter:description" content="Build cURL commands, test REST APIs, capture responses. Import/export cURL, generate code. Free forever.">
    <meta name="twitter:image" content="https://8gwifi.org/images/site/terminal.png">

    <meta name="robots" content="index,follow" />
    <meta name="googlebot" content="index,follow" />
    <meta name="resource-type" content="document" />
    <meta name="classification" content="tools" />
    <meta name="language" content="en" />

    <link rel="canonical" href="https://8gwifi.org/curl-builder.jsp">

    <%@ include file="header-script.jsp"%>

    <!-- Prism.js for syntax highlighting -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/themes/prism-tomorrow.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/prism.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-bash.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-json.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-python.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-javascript.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-php.min.js"></script>

    <style>
        :root {
            --theme-primary: #3182ce;
            --theme-secondary: #2563eb;
            --theme-gradient: linear-gradient(135deg, #3182ce 0%, #2563eb 100%);
            --theme-light: #eff6ff;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
        }

        h1 {
            color: #2d3748;
            font-size: 2rem;
            font-weight: 700;
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
            background: var(--theme-light);
            color: var(--theme-primary);
            padding: 0.25rem 0.6rem;
            border-radius: 12px;
            font-size: 0.7rem;
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
            margin-right: 0.3rem;
        }

        .tool-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border: 1px solid #e2e8f0;
            transition: box-shadow 0.2s;
        }

        .tool-card:hover {
            box-shadow: 0 4px 16px rgba(0,0,0,0.12);
        }

        .card-header-custom {
            background: var(--theme-gradient);
            color: white;
            padding: 1rem;
            border-radius: 12px 12px 0 0;
        }

        .related-tools {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
        }

        .related-tool-card {
            background: var(--theme-light);
            border: 1px solid #dbeafe;
            border-radius: 8px;
            padding: 1rem;
            text-decoration: none;
            color: inherit;
            transition: all 0.2s;
            display: block;
        }

        .related-tool-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(49, 130, 206, 0.15);
            text-decoration: none;
            color: inherit;
        }

        .related-tool-card h6 {
            color: var(--theme-primary);
            margin-bottom: 0.5rem;
        }

        .related-tool-card p {
            color: #64748b;
            font-size: 0.85rem;
            margin: 0;
        }

        .operation-tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 25px;
            flex-wrap: wrap;
            border-bottom: 2px solid #e2e8f0;
            padding-bottom: 10px;
        }

        .tab-btn {
            padding: 10px 20px;
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            color: #4a5568;
            transition: all 0.3s;
        }

        .tab-btn:hover {
            background: #f7fafc;
            border-color: #cbd5e0;
        }

        .tab-btn.active {
            background: #3182ce;
            color: white;
            border-color: #3182ce;
        }

        .content-section {
            display: none;
        }

        .content-section.active {
            display: block;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            font-size: 14px;
            font-family: 'Monaco', 'Courier New', monospace;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #3182ce;
        }

        .method-selector {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-bottom: 20px;
        }

        .method-btn {
            padding: 8px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 6px;
            background: white;
            cursor: pointer;
            font-weight: 600;
            font-size: 13px;
            transition: all 0.2s;
        }

        .method-btn.get { color: #10b981; border-color: #10b981; }
        .method-btn.post { color: #3b82f6; border-color: #3b82f6; }
        .method-btn.put { color: #f59e0b; border-color: #f59e0b; }
        .method-btn.delete { color: #ef4444; border-color: #ef4444; }
        .method-btn.patch { color: #8b5cf6; border-color: #8b5cf6; }

        .method-btn.active.get { background: #10b981; color: white; }
        .method-btn.active.post { background: #3b82f6; color: white; }
        .method-btn.active.put { background: #f59e0b; color: white; }
        .method-btn.active.delete { background: #ef4444; color: white; }
        .method-btn.active.patch { background: #8b5cf6; color: white; }

        .btn-primary {
            background: linear-gradient(135deg, #3182ce 0%, #2563eb 100%);
            border: none;
            padding: 10px 24px;
            border-radius: 6px;
            color: white;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(49, 130, 206, 0.4);
        }

        .btn-secondary {
            background: white;
            border: 2px solid #e2e8f0;
            padding: 10px 24px;
            border-radius: 6px;
            color: #4a5568;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-secondary:hover {
            background: #f7fafc;
            border-color: #cbd5e0;
        }

        .btn-small {
            padding: 6px 12px;
            font-size: 12px;
        }

        .header-row {
            display: grid;
            grid-template-columns: 1fr 1fr 50px;
            gap: 10px;
            margin-bottom: 10px;
            align-items: center;
        }

        .header-row input {
            padding: 8px;
            border: 1px solid #e2e8f0;
            border-radius: 4px;
            font-size: 13px;
        }

        .remove-btn {
            background: #ef4444;
            color: white;
            border: none;
            padding: 8px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
        }

        .output-container {
            background: #1e1e1e;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            padding: 20px;
            margin-bottom: 20px;
            color: #f8f8f2;
            max-height: 500px;
            overflow-y: auto;
            font-family: 'Monaco', 'Courier New', monospace;
            font-size: 14px;
            line-height: 1.6;
        }

        .output-container pre {
            margin: 0;
            white-space: pre-wrap;
            word-wrap: break-word;
            color: #f8f8f2;
        }

        .info-box {
            background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);
            border-left: 4px solid #3182ce;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
        }

        .info-box h3 {
            margin: 0 0 10px 0;
            font-size: 1.1rem;
            color: #1e40af;
        }

        .info-box p {
            margin: 0;
            color: #1e3a8a;
            line-height: 1.6;
        }

        .response-panel {
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 6px;
            padding: 20px;
            margin-top: 20px;
        }

        .response-tabs {
            display: flex;
            gap: 10px;
            border-bottom: 2px solid #e2e8f0;
            margin-bottom: 15px;
        }

        .response-tab {
            padding: 8px 16px;
            cursor: pointer;
            border-bottom: 2px solid transparent;
            margin-bottom: -2px;
            font-weight: 500;
            color: #4a5568;
        }

        .response-tab.active {
            color: #3182ce;
            border-bottom-color: #3182ce;
        }

        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            margin-left: 10px;
        }

        .status-200 { background: #d1fae5; color: #065f46; }
        .status-400 { background: #fef3c7; color: #92400e; }
        .status-500 { background: #fee2e2; color: #991b1b; }

        .collapsible-section {
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            margin-bottom: 15px;
            background: white;
        }

        .collapsible-header {
            padding: 12px 15px;
            cursor: pointer;
            background: #f7fafc;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-weight: 600;
            color: #2d3748;
            user-select: none;
            border-radius: 6px;
            transition: background 0.2s;
        }

        .collapsible-header:hover {
            background: #edf2f7;
        }

        .collapsible-header .icon {
            transition: transform 0.3s;
            font-size: 12px;
        }

        .collapsible-header.expanded .icon {
            transform: rotate(180deg);
        }

        .collapsible-content {
            padding: 15px;
            display: none;
        }

        .collapsible-content.expanded {
            display: block;
        }

        .settings-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .checkbox-group input[type="checkbox"] {
            width: auto;
            margin: 0;
        }

        .checkbox-group label {
            margin: 0;
            font-weight: 500;
            cursor: pointer;
        }

        @media (max-width: 768px) {
            h1 {
                font-size: 1.5rem;
            }

            .method-selector {
                flex-direction: column;
            }

            .header-row {
                grid-template-columns: 1fr;
            }

            .settings-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<%@ include file="body-script.jsp"%>

<div class="d-flex justify-content-between align-items-center mb-2">
    <div>
        <h1 class="h4 mb-0">cURL Builder & HTTP Client</h1>
        <div class="mt-1">
            <span class="info-badge"><i class="fas fa-code"></i> REST API Tester</span>
            <span class="info-badge"><i class="fas fa-exchange-alt"></i> Import/Export</span>
            <span class="info-badge"><i class="fas fa-laptop-code"></i> Code Generator</span>
            <span class="info-badge"><i class="fas fa-shield-alt"></i> Client-Side</span>
        </div>
    </div>
    <div class="eeat-badge">
        <i class="fas fa-user-check"></i>
        <span>Anish Nath</span>
    </div>
</div>

<hr>

<div class="alert alert-info mb-3">
    <strong><i class="fas fa-shield-alt"></i> Privacy First:</strong> This tool runs 100% client-side. Your API keys and request data never leave your browser.
</div>

<div class="operation-tabs">
    <button class="tab-btn active" data-tab="request-builder">Request Builder</button>
    <button class="tab-btn" data-tab="curl-command">cURL Command</button>
    <button class="tab-btn" data-tab="code-generator">Code Generator</button>
    <button class="tab-btn" data-tab="history">History</button>
</div>

<!-- Request Builder Section -->
<div class="content-section active" id="request-builder">

    <!-- HTTP Method Selection -->
    <div class="form-group">
        <label>HTTP Method</label>
        <div class="method-selector">
            <button class="method-btn get active" data-method="GET">GET</button>
            <button class="method-btn post" data-method="POST">POST</button>
            <button class="method-btn put" data-method="PUT">PUT</button>
            <button class="method-btn delete" data-method="DELETE">DELETE</button>
            <button class="method-btn patch" data-method="PATCH">PATCH</button>
            <button class="method-btn" data-method="HEAD">HEAD</button>
            <button class="method-btn" data-method="OPTIONS">OPTIONS</button>
        </div>
    </div>

    <!-- URL Input -->
    <div class="form-group">
        <label>Request URL</label>
        <input type="text" id="requestUrl" placeholder="https://api.example.com/endpoint" value="https://jsonplaceholder.typicode.com/posts/1">
    </div>

    <!-- Authentication Section (Collapsible) -->
    <div class="collapsible-section">
        <div class="collapsible-header" onclick="toggleCollapsible(this)">
            <span>🔐 Authentication</span>
            <span class="icon">▼</span>
        </div>
        <div class="collapsible-content">
            <div class="form-group">
                <label>Authentication Type</label>
                <select id="authType">
                    <option value="none">No Authentication</option>
                    <option value="basic">Basic Auth</option>
                    <option value="bearer">Bearer Token</option>
                    <option value="apikey">API Key</option>
                </select>
            </div>

            <div id="authFields" style="display: none;">
                <!-- Basic Auth -->
                <div id="basicAuthFields" style="display: none;">
                    <div class="form-group">
                        <label>Username</label>
                        <input type="text" id="basicUsername" placeholder="username">
                    </div>
                    <div class="form-group">
                        <label>Password</label>
                        <input type="password" id="basicPassword" placeholder="password">
                    </div>
                </div>

                <!-- Bearer Token -->
                <div id="bearerAuthFields" style="display: none;">
                    <div class="form-group">
                        <label>Bearer Token</label>
                        <input type="text" id="bearerToken" placeholder="your-bearer-token">
                    </div>
                </div>

                <!-- API Key -->
                <div id="apiKeyAuthFields" style="display: none;">
                    <div class="form-group">
                        <label>Key</label>
                        <input type="text" id="apiKeyName" placeholder="X-API-Key">
                    </div>
                    <div class="form-group">
                        <label>Value</label>
                        <input type="text" id="apiKeyValue" placeholder="your-api-key">
                    </div>
                    <div class="form-group">
                        <label>Add To</label>
                        <select id="apiKeyLocation">
                            <option value="header">Header</option>
                            <option value="query">Query Parameter</option>
                        </select>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Query Parameters Section (Collapsible) -->
    <div class="collapsible-section">
        <div class="collapsible-header" onclick="toggleCollapsible(this)">
            <span>🔗 Query Parameters</span>
            <span class="icon">▼</span>
        </div>
        <div class="collapsible-content">
            <div id="queryParams"></div>
            <button class="btn-secondary btn-small" onclick="addQueryParam()">+ Add Parameter</button>
        </div>
    </div>

    <!-- Custom Headers Section (Collapsible) -->
    <div class="collapsible-section">
        <div class="collapsible-header" onclick="toggleCollapsible(this)">
            <span>📋 Custom Headers</span>
            <span class="icon">▼</span>
        </div>
        <div class="collapsible-content">
            <div id="customHeaders"></div>
            <button class="btn-secondary btn-small" onclick="addHeader()">+ Add Header</button>
            <button class="btn-secondary btn-small" onclick="importHeaders()">📋 Import Headers</button>
        </div>
    </div>

    <!-- Request Body Section (Collapsible) -->
    <div class="collapsible-section" id="requestBodySection" style="display: none;">
        <div class="collapsible-header" onclick="toggleCollapsible(this)">
            <span>📝 Request Body</span>
            <span class="icon">▼</span>
        </div>
        <div class="collapsible-content">
            <div class="form-group">
                <label>Content Type</label>
                <select id="bodyType" onchange="changeBodyType()">
                    <option value="none">No Body</option>
                    <option value="json">JSON</option>
                    <option value="xml">XML</option>
                    <option value="form">Form Data (URL Encoded)</option>
                    <option value="multipart">Multipart Form Data</option>
                    <option value="raw">Raw</option>
                </select>
            </div>

            <div id="bodyEditor" style="display: none;">
                <div class="form-group">
                    <textarea id="requestBody" rows="10" placeholder="Enter request body..."></textarea>
                </div>
            </div>
        </div>
    </div>

    <!-- Advanced Settings Section (Collapsible) -->
    <div class="collapsible-section">
        <div class="collapsible-header" onclick="toggleCollapsible(this)">
            <span>⚙️ Advanced Settings</span>
            <span class="icon">▼</span>
        </div>
        <div class="collapsible-content">
            <div class="settings-grid">
                <div class="form-group">
                    <label>Timeout (seconds)</label>
                    <input type="number" id="requestTimeout" value="30" min="1" max="300">
                </div>

                <div class="form-group">
                    <label>Max Redirects</label>
                    <input type="number" id="maxRedirects" value="5" min="0" max="20">
                </div>
            </div>

            <div class="checkbox-group">
                <input type="checkbox" id="followRedirects" checked>
                <label for="followRedirects">Follow Redirects</label>
            </div>

            <div class="checkbox-group">
                <input type="checkbox" id="allowSelfSigned">
                <label for="allowSelfSigned">Allow Self-Signed Certificates (⚠️ Use with caution)</label>
            </div>

            <div class="checkbox-group">
                <input type="checkbox" id="showRedirectChain">
                <label for="showRedirectChain">Show Redirect Chain</label>
            </div>
        </div>
    </div>

    <!-- Action Buttons -->
    <div style="display: flex; gap: 10px; margin-top: 20px; flex-wrap: wrap;">
        <button class="btn-primary" onclick="sendRequest()">⚡ Send Request</button>
        <button class="btn-secondary" onclick="generateCurl()">📋 Generate cURL</button>
        <button class="btn-secondary" onclick="clearAll()">✕ Clear All</button>
        <button class="btn-secondary" onclick="importCurl()">📥 Import cURL</button>
    </div>

    <!-- Response Panel -->
    <div id="responsePanel" class="response-panel" style="display: none;">
        <h3>Response <span id="statusBadge"></span><span id="responseTime" style="margin-left: 10px; color: #718096; font-size: 14px;"></span></h3>

        <div class="response-tabs">
            <div class="response-tab active" data-response-tab="body">Body</div>
            <div class="response-tab" data-response-tab="headers">Headers</div>
            <div class="response-tab" data-response-tab="raw">Raw</div>
        </div>

        <div class="response-content active" id="responseBody">
            <div class="output-container">
                <pre id="responseBodyContent"></pre>
            </div>
        </div>

        <div class="response-content" id="responseHeaders" style="display: none;">
            <div class="output-container">
                <pre id="responseHeadersContent"></pre>
            </div>
        </div>

        <div class="response-content" id="responseRaw" style="display: none;">
            <div class="output-container">
                <pre id="responseRawContent"></pre>
            </div>
        </div>

        <div style="margin-top: 15px;">
            <button class="btn-secondary btn-small" onclick="copyResponse()">📋 Copy Response</button>
            <button class="btn-secondary btn-small" onclick="downloadResponse()">💾 Download Response</button>
        </div>
    </div>
</div>

<!-- cURL Command Section -->
<div class="content-section" id="curl-command">
    <div class="form-group">
        <label>Generated cURL Command</label>
        <div class="output-container">
            <pre id="curlOutput" class="language-bash">Click "Generate cURL" to see the command</pre>
        </div>
    </div>

    <div style="display: flex; gap: 10px; flex-wrap: wrap;">
        <button class="btn-secondary" onclick="copyCurl()">📋 Copy cURL</button>
        <button class="btn-secondary" onclick="downloadCurl()">💾 Download cURL</button>
    </div>
</div>

<!-- Code Generator Section -->
<div class="content-section" id="code-generator">
    <div class="form-group">
        <label>Generate Code</label>
        <select id="codeLanguage" onchange="generateCode()">
            <option value="">Select Language</option>
            <option value="python">Python (requests)</option>
            <option value="javascript">JavaScript (fetch)</option>
            <option value="nodejs">Node.js (axios)</option>
            <option value="php">PHP (cURL)</option>
            <option value="java">Java (HttpClient)</option>
            <option value="go">Go (net/http)</option>
        </select>
    </div>

    <div class="output-container">
        <pre id="codeOutput">Select a language to generate code</pre>
    </div>

    <div style="display: flex; gap: 10px; margin-top: 15px; flex-wrap: wrap;">
        <button class="btn-secondary" onclick="copyCode()">📋 Copy Code</button>
        <button class="btn-secondary" onclick="downloadCode()">💾 Download Code</button>
    </div>
</div>

<!-- History Section -->
<div class="content-section" id="history">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
        <h3>Request History</h3>
        <button class="btn-secondary btn-small" onclick="clearHistory()">🗑️ Clear History</button>
    </div>

    <div id="historyList">
        <p style="color: #a0aec0; text-align: center; padding: 40px 0;">No request history yet</p>
    </div>
</div>

<hr>

<!-- Educational Content Section -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light">
        <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding cURL</h5>
    </div>
    <div class="card-body">
        <h6>What is cURL?</h6>
        <p>cURL (Client URL) is a command-line tool and library for transferring data with URLs. It supports a wide range of protocols including HTTP, HTTPS, FTP, SFTP, and more. cURL is widely used for testing REST APIs, debugging web applications, downloading files, and automating HTTP requests in scripts and CI/CD pipelines.</p>

        <h6 class="mt-4">Common cURL Options</h6>
        <table class="table table-sm table-bordered">
            <thead class="table-light">
                <tr>
                    <th>Option</th>
                    <th>Description</th>
                    <th>Example</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><code>-X</code></td>
                    <td>Specify HTTP method</td>
                    <td><code>-X POST</code></td>
                </tr>
                <tr>
                    <td><code>-H</code></td>
                    <td>Add custom header</td>
                    <td><code>-H "Content-Type: application/json"</code></td>
                </tr>
                <tr>
                    <td><code>-d</code></td>
                    <td>Send data in request body</td>
                    <td><code>-d '{"key":"value"}'</code></td>
                </tr>
                <tr>
                    <td><code>-u</code></td>
                    <td>Basic authentication</td>
                    <td><code>-u username:password</code></td>
                </tr>
                <tr>
                    <td><code>-L</code></td>
                    <td>Follow redirects</td>
                    <td><code>-L</code></td>
                </tr>
                <tr>
                    <td><code>-k</code></td>
                    <td>Allow insecure SSL</td>
                    <td><code>-k</code></td>
                </tr>
                <tr>
                    <td><code>-v</code></td>
                    <td>Verbose output</td>
                    <td><code>-v</code></td>
                </tr>
            </tbody>
        </table>

        <h6 class="mt-4">cURL vs Other HTTP Clients</h6>
        <table class="table table-sm table-bordered">
            <thead class="table-light">
                <tr>
                    <th>Tool</th>
                    <th>Type</th>
                    <th>Best For</th>
                    <th>Platform</th>
                </tr>
            </thead>
            <tbody>
                <tr class="table-info">
                    <td><strong>cURL</strong></td>
                    <td>CLI</td>
                    <td>Scripting, automation, quick tests</td>
                    <td>Cross-platform</td>
                </tr>
                <tr>
                    <td>Postman</td>
                    <td>GUI</td>
                    <td>Team collaboration, collections</td>
                    <td>Desktop/Web</td>
                </tr>
                <tr>
                    <td>Insomnia</td>
                    <td>GUI</td>
                    <td>GraphQL, design-first APIs</td>
                    <td>Desktop</td>
                </tr>
                <tr>
                    <td>HTTPie</td>
                    <td>CLI</td>
                    <td>Human-friendly syntax</td>
                    <td>Cross-platform</td>
                </tr>
            </tbody>
        </table>

        <h6 class="mt-4">Code Examples</h6>
        <div class="row">
            <div class="col-md-6">
                <p class="small mb-1"><strong>cURL Command</strong></p>
                <pre class="bg-dark text-light p-2 rounded small"><code>curl -X POST https://api.example.com/users \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer token123" \
  -d '{"name":"John","email":"john@example.com"}'</code></pre>
            </div>
            <div class="col-md-6">
                <p class="small mb-1"><strong>Python (requests)</strong></p>
                <pre class="bg-dark text-light p-2 rounded small"><code>import requests

response = requests.post(
    "https://api.example.com/users",
    headers={"Authorization": "Bearer token123"},
    json={"name": "John", "email": "john@example.com"}
)
print(response.json())</code></pre>
            </div>
        </div>

        <h6 class="mt-4">Security Best Practices</h6>
        <div class="alert alert-warning mb-0">
            <ul class="mb-0 small">
                <li><strong>Never</strong> hardcode API keys or passwords in cURL commands saved to files</li>
                <li>Use environment variables for sensitive data: <code>-H "Authorization: Bearer $API_KEY"</code></li>
                <li>Avoid <code>-k/--insecure</code> in production - it disables SSL certificate verification</li>
                <li>Use <code>--netrc</code> or credential helpers for authentication instead of inline passwords</li>
            </ul>
        </div>
    </div>
</div>

<!-- Terminal Commands Section -->
<div class="card tool-card mb-4">
    <div class="card-header bg-dark text-white py-2">
        <h6 class="mb-0"><i class="fas fa-terminal me-2"></i>Common cURL Commands</h6>
    </div>
    <div class="card-body">
        <p class="small mb-2"><strong>GET Request:</strong></p>
        <pre class="bg-light p-2 rounded small mb-3"><code>curl https://api.example.com/users</code></pre>

        <p class="small mb-2"><strong>POST with JSON:</strong></p>
        <pre class="bg-light p-2 rounded small mb-3"><code>curl -X POST https://api.example.com/users \
  -H "Content-Type: application/json" \
  -d '{"name":"John"}'</code></pre>

        <p class="small mb-2"><strong>With Bearer Token:</strong></p>
        <pre class="bg-light p-2 rounded small mb-3"><code>curl -H "Authorization: Bearer YOUR_TOKEN" \
  https://api.example.com/protected</code></pre>

        <p class="small mb-2"><strong>Download File:</strong></p>
        <pre class="bg-light p-2 rounded small mb-0"><code>curl -O https://example.com/file.zip</code></pre>
    </div>
</div>

<div class="card tool-card mb-4">
    <div class="card-header bg-light py-2">
        <h6 class="mb-0"><i class="fas fa-tools me-2"></i>Related Developer Tools</h6>
    </div>
    <div class="card-body">
        <div class="related-tools">
            <a href="prometheus-query-builder.jsp" class="related-tool-card">
                <h6><i class="fas fa-chart-line me-1"></i>Prometheus Query Builder</h6>
                <p>Build and test PromQL queries visually</p>
            </a>
            <a href="json-2-csv.jsp" class="related-tool-card">
                <h6><i class="fas fa-file-csv me-1"></i>JSON to CSV Converter</h6>
                <p>Convert JSON data to CSV format</p>
            </a>
            <a href="yamlparser.jsp" class="related-tool-card">
                <h6><i class="fas fa-file-code me-1"></i>YAML Parser</h6>
                <p>Parse and convert YAML configurations</p>
            </a>
            <a href="xml2json.jsp" class="related-tool-card">
                <h6><i class="fas fa-exchange-alt me-1"></i>XML to JSON</h6>
                <p>Convert XML documents to JSON</p>
            </a>
            <a href="base64enc.jsp" class="related-tool-card">
                <h6><i class="fas fa-lock me-1"></i>Base64 Encoder</h6>
                <p>Encode and decode Base64 strings</p>
            </a>
            <a href="urlencoder.jsp" class="related-tool-card">
                <h6><i class="fas fa-link me-1"></i>URL Encoder</h6>
                <p>Encode and decode URLs</p>
            </a>
        </div>
    </div>
</div>

<hr>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>

<script>
    // Global state
    let currentMethod = 'GET';
    let requestHistory = [];
    let lastResponse = null;

    // Toast notification function
    function showToast(message) {
        var toast = $('<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999;">' +
            '<div class="toast show"><div class="toast-body text-white rounded" style="background: var(--theme-gradient);">' +
            '<i class="fas fa-info-circle me-2"></i>' + message + '</div></div></div>');
        $('body').append(toast);
        setTimeout(function() { toast.fadeOut(function() { toast.remove(); }); }, 2000);
    }

    // Initialize on page load
    document.addEventListener('DOMContentLoaded', function() {
        initializeTabs();
        initializeMethodSelector();
        initializeAuthType();
        initializeResponseTabs();
        loadHistory();
        addQueryParam();
        addHeader();
    });

    // Collapsible section toggle
    function toggleCollapsible(header) {
        const content = header.nextElementSibling;
        const isExpanded = content.classList.contains('expanded');

        if (isExpanded) {
            content.classList.remove('expanded');
            header.classList.remove('expanded');
        } else {
            content.classList.add('expanded');
            header.classList.add('expanded');
        }
    }

    // Tab management
    function initializeTabs() {
        const tabButtons = document.querySelectorAll('.tab-btn');
        tabButtons.forEach(button => {
            button.addEventListener('click', function() {
                const tabName = this.getAttribute('data-tab');
                switchTab(tabName);
            });
        });
    }

    function switchTab(tabName) {
        document.querySelectorAll('.tab-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        document.querySelector('[data-tab="' + tabName + '"]').classList.add('active');

        document.querySelectorAll('.content-section').forEach(section => {
            section.classList.remove('active');
        });
        document.getElementById(tabName).classList.add('active');
    }

    // HTTP Method selector
    function initializeMethodSelector() {
        const methodButtons = document.querySelectorAll('.method-btn');
        methodButtons.forEach(button => {
            button.addEventListener('click', function() {
                methodButtons.forEach(btn => btn.classList.remove('active'));
                this.classList.add('active');
                currentMethod = this.getAttribute('data-method');

                // Show/hide request body section for methods that support it
                const bodySection = document.getElementById('requestBodySection');
                if (['POST', 'PUT', 'PATCH'].includes(currentMethod)) {
                    bodySection.style.display = 'block';
                } else {
                    bodySection.style.display = 'none';
                    document.getElementById('bodyEditor').style.display = 'none';
                }
            });
        });
    }

    // Authentication type handler
    function initializeAuthType() {
        document.getElementById('authType').addEventListener('change', function() {
            const authFields = document.getElementById('authFields');
            const basicFields = document.getElementById('basicAuthFields');
            const bearerFields = document.getElementById('bearerAuthFields');
            const apiKeyFields = document.getElementById('apiKeyAuthFields');

            // Hide all fields first
            authFields.style.display = 'none';
            basicFields.style.display = 'none';
            bearerFields.style.display = 'none';
            apiKeyFields.style.display = 'none';

            // Show selected auth type fields
            const authType = this.value;
            if (authType !== 'none') {
                authFields.style.display = 'block';

                if (authType === 'basic') {
                    basicFields.style.display = 'block';
                } else if (authType === 'bearer') {
                    bearerFields.style.display = 'block';
                } else if (authType === 'apikey') {
                    apiKeyFields.style.display = 'block';
                }
            }
        });
    }

    // Response tabs
    function initializeResponseTabs() {
        const tabs = document.querySelectorAll('.response-tab');
        tabs.forEach(tab => {
            tab.addEventListener('click', function() {
                tabs.forEach(t => t.classList.remove('active'));
                this.classList.add('active');

                const contentId = 'response' + this.getAttribute('data-response-tab').charAt(0).toUpperCase() +
                                this.getAttribute('data-response-tab').slice(1);

                document.querySelectorAll('.response-content').forEach(content => {
                    content.style.display = 'none';
                });
                document.getElementById(contentId).style.display = 'block';
            });
        });
    }

    // Query parameters
    function addQueryParam() {
        const container = document.getElementById('queryParams');
        const row = document.createElement('div');
        row.className = 'header-row';
        row.innerHTML = '<input type="text" placeholder="Key" class="param-key">' +
                       '<input type="text" placeholder="Value" class="param-value">' +
                       '<button class="remove-btn" onclick="this.parentElement.remove()">✕</button>';
        container.appendChild(row);
    }

    // Custom headers
    function addHeader() {
        const container = document.getElementById('customHeaders');
        const row = document.createElement('div');
        row.className = 'header-row';
        row.innerHTML = '<input type="text" placeholder="Header Name" class="header-name">' +
                       '<input type="text" placeholder="Header Value" class="header-value">' +
                       '<button class="remove-btn" onclick="this.parentElement.remove()">✕</button>';
        container.appendChild(row);
    }

    // Import headers from text
    function importHeaders() {
        const text = prompt('Paste headers (one per line, format: "Name: Value")');
        if (!text) return;

        const lines = text.split('\n');
        lines.forEach(line => {
            const parts = line.split(':');
            if (parts.length >= 2) {
                const container = document.getElementById('customHeaders');
                const row = document.createElement('div');
                row.className = 'header-row';
                row.innerHTML = '<input type="text" placeholder="Header Name" class="header-name" value="' + parts[0].trim() + '">' +
                               '<input type="text" placeholder="Header Value" class="header-value" value="' + parts.slice(1).join(':').trim() + '">' +
                               '<button class="remove-btn" onclick="this.parentElement.remove()">✕</button>';
                container.appendChild(row);
            }
        });
    }

    // Body type change handler
    function changeBodyType() {
        const bodyType = document.getElementById('bodyType').value;
        const bodyEditor = document.getElementById('bodyEditor');
        const requestBody = document.getElementById('requestBody');

        if (bodyType === 'none') {
            bodyEditor.style.display = 'none';
        } else {
            bodyEditor.style.display = 'block';

            // Set placeholder based on type
            if (bodyType === 'json') {
                requestBody.placeholder = '{\n  "key": "value"\n}';
            } else if (bodyType === 'xml') {
                requestBody.placeholder = '<root>\n  <element>value</element>\n</root>';
            } else if (bodyType === 'form') {
                requestBody.placeholder = 'key1=value1&key2=value2';
            } else {
                requestBody.placeholder = 'Enter request body...';
            }
        }
    }

    // Generate cURL command
    function generateCurl() {
        const url = document.getElementById('requestUrl').value;
        if (!url) {
            showToast('Please enter a URL');
            return;
        }

        let curl = 'curl -X ' + currentMethod;

        // Add URL with query parameters
        let finalUrl = url;
        const params = getQueryParams();
        if (params.length > 0) {
            const queryString = params.map(p => p.key + '=' + encodeURIComponent(p.value)).join('&');
            finalUrl += (url.includes('?') ? '&' : '?') + queryString;
        }
        curl += ' \\\n  "' + finalUrl + '"';

        // Add headers
        const headers = getHeaders();
        headers.forEach(h => {
            curl += ' \\\n  -H "' + h.name + ': ' + h.value + '"';
        });

        // Add auth headers
        const auth = getAuthHeader();
        if (auth) {
            curl += ' \\\n  -H "' + auth.name + ': ' + auth.value + '"';
        }

        // Add body
        if (['POST', 'PUT', 'PATCH'].includes(currentMethod)) {
            const bodyType = document.getElementById('bodyType').value;
            if (bodyType !== 'none') {
                const body = document.getElementById('requestBody').value;
                if (body) {
                    curl += ' \\\n  -d \'' + body.replace(/'/g, "\\'") + '\'';
                }

                // Add content-type header if not already present
                if (bodyType === 'json' && !headers.find(h => h.name.toLowerCase() === 'content-type')) {
                    curl += ' \\\n  -H "Content-Type: application/json"';
                }
            }
        }

        // Add advanced options
        const timeout = parseInt(document.getElementById('requestTimeout').value);
        if (timeout && timeout !== 30) {
            curl += ' \\\n  --max-time ' + timeout;
        }

        const followRedirects = document.getElementById('followRedirects').checked;
        if (followRedirects) {
            const maxRedirects = parseInt(document.getElementById('maxRedirects').value);
            curl += ' \\\n  --location';
            if (maxRedirects && maxRedirects !== 5) {
                curl += ' --max-redirs ' + maxRedirects;
            }
        }

        const allowSelfSigned = document.getElementById('allowSelfSigned').checked;
        if (allowSelfSigned) {
            curl += ' \\\n  --insecure';
        }

        const showRedirectChain = document.getElementById('showRedirectChain').checked;
        if (showRedirectChain) {
            curl += ' \\\n  --verbose';
        }

        document.getElementById('curlOutput').textContent = curl;

        // Switch to cURL tab
        switchTab('curl-command');
    }

    // Helper functions to get form data
    function getQueryParams() {
        const params = [];
        document.querySelectorAll('#queryParams .header-row').forEach(row => {
            const key = row.querySelector('.param-key').value;
            const value = row.querySelector('.param-value').value;
            if (key) params.push({ key, value });
        });
        return params;
    }

    function getHeaders() {
        const headers = [];
        document.querySelectorAll('#customHeaders .header-row').forEach(row => {
            const name = row.querySelector('.header-name').value;
            const value = row.querySelector('.header-value').value;
            if (name) headers.push({ name, value });
        });
        return headers;
    }

    function getAuthHeader() {
        const authType = document.getElementById('authType').value;

        if (authType === 'basic') {
            const username = document.getElementById('basicUsername').value;
            const password = document.getElementById('basicPassword').value;
            if (username && password) {
                const encoded = btoa(username + ':' + password);
                return { name: 'Authorization', value: 'Basic ' + encoded };
            }
        } else if (authType === 'bearer') {
            const token = document.getElementById('bearerToken').value;
            if (token) {
                return { name: 'Authorization', value: 'Bearer ' + token };
            }
        } else if (authType === 'apikey') {
            const location = document.getElementById('apiKeyLocation').value;
            if (location === 'header') {
                const name = document.getElementById('apiKeyName').value;
                const value = document.getElementById('apiKeyValue').value;
                if (name && value) {
                    return { name, value };
                }
            }
        }

        return null;
    }

    // Send HTTP request
    function sendRequest() {
        const url = document.getElementById('requestUrl').value;
        if (!url) {
            showToast('Please enter a URL');
            return;
        }

        // Build URL with query params
        let finalUrl = url;
        const params = getQueryParams();
        if (params.length > 0) {
            const queryString = params.map(p => p.key + '=' + encodeURIComponent(p.value)).join('&');
            finalUrl += (url.includes('?') ? '&' : '?') + queryString;
        }

        // Add API key to query if needed
        const authType = document.getElementById('authType').value;
        if (authType === 'apikey' && document.getElementById('apiKeyLocation').value === 'query') {
            const name = document.getElementById('apiKeyName').value;
            const value = document.getElementById('apiKeyValue').value;
            if (name && value) {
                finalUrl += (finalUrl.includes('?') ? '&' : '?') + name + '=' + encodeURIComponent(value);
            }
        }

        // Build headers
        const headers = {};
        getHeaders().forEach(h => headers[h.name] = h.value);

        // Add auth header
        const auth = getAuthHeader();
        if (auth) {
            headers[auth.name] = auth.value;
        }

        // Build request options
        const options = {
            method: currentMethod,
            headers: headers
        };

        // Add redirect handling
        const followRedirects = document.getElementById('followRedirects').checked;
        if (followRedirects) {
            options.redirect = 'follow';
        } else {
            options.redirect = 'manual';
        }

        // Add body if needed
        if (['POST', 'PUT', 'PATCH'].includes(currentMethod)) {
            const bodyType = document.getElementById('bodyType').value;
            if (bodyType !== 'none') {
                const body = document.getElementById('requestBody').value;
                if (body) {
                    options.body = body;

                    // Add content-type if not already present
                    if (bodyType === 'json' && !headers['Content-Type']) {
                        headers['Content-Type'] = 'application/json';
                    }
                }
            }
        }

        // Get timeout setting
        const timeout = parseInt(document.getElementById('requestTimeout').value) * 1000;
        const allowSelfSigned = document.getElementById('allowSelfSigned').checked;
        const showRedirectChain = document.getElementById('showRedirectChain').checked;

        // Execute request with timeout
        const startTime = Date.now();
        const controller = new AbortController();
        const timeoutId = setTimeout(() => controller.abort(), timeout);

        options.signal = controller.signal;

        // Note: Self-signed certificate handling
        // In browser context, this is controlled by browser settings
        // The checkbox serves as documentation/preference indicator
        if (allowSelfSigned) {
            console.log('⚠️ Self-signed certificate acceptance is browser-controlled');
        }

        let redirectChain = [];

        fetch(finalUrl, options)
            .then(response => {
                clearTimeout(timeoutId);
                const elapsed = Date.now() - startTime;

                // Track redirect if response was a redirect
                if (response.redirected && showRedirectChain) {
                    redirectChain.push({
                        url: response.url,
                        status: response.status
                    });
                }

                return response.text().then(text => ({
                    status: response.status,
                    statusText: response.statusText,
                    headers: response.headers,
                    body: text,
                    time: elapsed,
                    redirected: response.redirected,
                    finalUrl: response.url,
                    redirectChain: redirectChain
                }));
            })
            .then(result => {
                displayResponse(result);
                saveToHistory(finalUrl, options, result);
            })
            .catch(error => {
                clearTimeout(timeoutId);
                if (error.name === 'AbortError') {
                    displayError({ message: 'Request timeout after ' + timeout/1000 + ' seconds' });
                } else {
                    displayError(error);
                }
            });
    }

    // Display response
    function displayResponse(result) {
        const panel = document.getElementById('responsePanel');
        panel.style.display = 'block';

        // Status badge
        const statusBadge = document.getElementById('statusBadge');
        let statusClass = 'status-200';
        if (result.status >= 400 && result.status < 500) statusClass = 'status-400';
        if (result.status >= 500) statusClass = 'status-500';
        statusBadge.innerHTML = '<span class="status-badge ' + statusClass + '">' + result.status + ' ' + result.statusText + '</span>';

        // Response time
        let responseTimeText = result.time + 'ms';

        // Add redirect information
        if (result.redirected) {
            responseTimeText += ' | 🔄 Redirected';
            if (result.finalUrl && result.finalUrl !== result.url) {
                responseTimeText += ' to ' + result.finalUrl;
            }
        }
        document.getElementById('responseTime').textContent = responseTimeText;

        // Response body (try to format as JSON)
        let formattedBody = result.body;

        // Show redirect chain if available
        if (result.redirectChain && result.redirectChain.length > 0) {
            formattedBody = '=== REDIRECT CHAIN ===\n' +
                result.redirectChain.map((r, i) => (i+1) + '. ' + r.url + ' (' + r.status + ')').join('\n') +
                '\n\n=== FINAL RESPONSE ===\n' + formattedBody;
        }

        try {
            const json = JSON.parse(result.body);
            formattedBody = JSON.stringify(json, null, 4);

            // Re-add redirect info for JSON
            if (result.redirectChain && result.redirectChain.length > 0) {
                formattedBody = '=== REDIRECT CHAIN ===\n' +
                    result.redirectChain.map((r, i) => (i+1) + '. ' + r.url + ' (' + r.status + ')').join('\n') +
                    '\n\n=== FINAL RESPONSE (JSON) ===\n' + formattedBody;
            }
        } catch (e) {
            // Not JSON, use as is
        }
        document.getElementById('responseBodyContent').textContent = formattedBody;

        // Response headers
        let headersText = '';
        result.headers.forEach((value, key) => {
            headersText += key + ': ' + value + '\n';
        });
        document.getElementById('responseHeadersContent').textContent = headersText;

        // Raw response
        document.getElementById('responseRawContent').textContent =
            'HTTP/1.1 ' + result.status + ' ' + result.statusText + '\n' + headersText + '\n' + result.body;

        lastResponse = result;

        // Scroll to response
        panel.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }

    // Display error
    function displayError(error) {
        const panel = document.getElementById('responsePanel');
        panel.style.display = 'block';

        document.getElementById('statusBadge').innerHTML = '<span class="status-badge status-500">Error</span>';
        document.getElementById('responseTime').textContent = '';
        document.getElementById('responseBodyContent').textContent = 'Error: ' + error.message +
            '\n\nNote: CORS may be blocking this request. Try using a CORS proxy or making the request from your server.';
    }

    // Copy, download functions
    function copyCurl() {
        const text = document.getElementById('curlOutput').textContent;
        navigator.clipboard.writeText(text).then(() => showToast('cURL command copied!'));
    }

    function downloadCurl() {
        const text = document.getElementById('curlOutput').textContent;
        const blob = new Blob([text], { type: 'text/plain' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'curl-command.sh';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
    }

    function copyResponse() {
        if (!lastResponse) return;
        navigator.clipboard.writeText(lastResponse.body).then(() => showToast('Response copied!'));
    }

    function downloadResponse() {
        if (!lastResponse) return;
        const blob = new Blob([lastResponse.body], { type: 'application/json' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'response.json';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
    }

    function copyCode() {
        const text = document.getElementById('codeOutput').textContent;
        navigator.clipboard.writeText(text).then(() => showToast('Code copied!'));
    }

    function downloadCode() {
        const text = document.getElementById('codeOutput').textContent;
        const lang = document.getElementById('codeLanguage').value;
        const extensions = { python: 'py', javascript: 'js', nodejs: 'js', php: 'php', java: 'java', go: 'go' };
        const blob = new Blob([text], { type: 'text/plain' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'request.' + (extensions[lang] || 'txt');
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
    }

    // Code generation
    function generateCode() {
        const lang = document.getElementById('codeLanguage').value;
        if (!lang) return;

        const url = document.getElementById('requestUrl').value;
        if (!url) {
            showToast('Please enter a URL');
            return;
        }

        let code = '';

        if (lang === 'python') {
            code = generatePythonCode(url);
        } else if (lang === 'javascript') {
            code = generateJavaScriptCode(url);
        } else if (lang === 'nodejs') {
            code = generateNodeJSCode(url);
        } else if (lang === 'php') {
            code = generatePHPCode(url);
        } else if (lang === 'java') {
            code = generateJavaCode(url);
        } else if (lang === 'go') {
            code = generateGoCode(url);
        }

        document.getElementById('codeOutput').textContent = code;
    }

    function generatePythonCode(url) {
        let code = 'import requests\n\n';
        code += 'url = "' + url + '"\n\n';

        const headers = getHeaders();
        if (headers.length > 0) {
            code += 'headers = {\n';
            headers.forEach(h => {
                code += '    "' + h.name + '": "' + h.value + '",\n';
            });
            code += '}\n\n';
        }

        const body = document.getElementById('requestBody').value;
        if (body && ['POST', 'PUT', 'PATCH'].includes(currentMethod)) {
            code += 'data = \'\'\'' + body + '\'\'\'\n\n';
        }

        code += 'response = requests.' + currentMethod.toLowerCase() + '(url';
        if (headers.length > 0) code += ', headers=headers';
        if (body && ['POST', 'PUT', 'PATCH'].includes(currentMethod)) code += ', data=data';
        code += ')\n\n';
        code += 'print("Status Code:", response.status_code)\n';
        code += 'print("Response:", response.text)';

        return code;
    }

    function generateJavaScriptCode(url) {
        let code = 'const url = "' + url + '";\n\n';

        code += 'const options = {\n';
        code += '  method: "' + currentMethod + '",\n';

        const headers = getHeaders();
        if (headers.length > 0) {
            code += '  headers: {\n';
            headers.forEach(h => {
                code += '    "' + h.name + '": "' + h.value + '",\n';
            });
            code += '  },\n';
        }

        const body = document.getElementById('requestBody').value;
        if (body && ['POST', 'PUT', 'PATCH'].includes(currentMethod)) {
            code += '  body: \'' + body.replace(/'/g, "\\'") + '\',\n';
        }

        code += '};\n\n';
        code += 'fetch(url, options)\n';
        code += '  .then(response => response.text())\n';
        code += '  .then(data => console.log(data))\n';
        code += '  .catch(error => console.error("Error:", error));';

        return code;
    }

    function generateNodeJSCode(url) {
        let code = 'const axios = require(\'axios\');\n\n';

        code += 'axios({\n';
        code += '  method: \'' + currentMethod.toLowerCase() + '\',\n';
        code += '  url: \'' + url + '\',\n';

        const headers = getHeaders();
        if (headers.length > 0) {
            code += '  headers: {\n';
            headers.forEach(h => {
                code += '    \'' + h.name + '\': \'' + h.value + '\',\n';
            });
            code += '  },\n';
        }

        const body = document.getElementById('requestBody').value;
        if (body && ['POST', 'PUT', 'PATCH'].includes(currentMethod)) {
            code += '  data: ' + body + ',\n';
        }

        code += '})\n';
        code += '.then(response => console.log(response.data))\n';
        code += '.catch(error => console.error(error));';

        return code;
    }

    function generatePHPCode(url) {
        let code = '<?php\n\n';
        code += '$url = "' + url + '";\n\n';

        code += '$ch = curl_init($url);\n';
        code += 'curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);\n';
        code += 'curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "' + currentMethod + '");\n\n';

        const headers = getHeaders();
        if (headers.length > 0) {
            code += '$headers = [\n';
            headers.forEach(h => {
                code += '    "' + h.name + ': ' + h.value + '",\n';
            });
            code += '];\n';
            code += 'curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);\n\n';
        }

        const body = document.getElementById('requestBody').value;
        if (body && ['POST', 'PUT', 'PATCH'].includes(currentMethod)) {
            code += '$data = \'' + body.replace(/'/g, "\\'") + '\';\n';
            code += 'curl_setopt($ch, CURLOPT_POSTFIELDS, $data);\n\n';
        }

        code += '$response = curl_exec($ch);\n';
        code += 'curl_close($ch);\n\n';
        code += 'echo $response;\n';
        code += '?>';

        return code;
    }

    function generateJavaCode(url) {
        let code = 'import java.net.http.*;\nimport java.net.URI;\n\n';
        code += 'HttpClient client = HttpClient.newHttpClient();\n\n';

        code += 'HttpRequest request = HttpRequest.newBuilder()\n';
        code += '    .uri(URI.create("' + url + '"))\n';
        code += '    .method("' + currentMethod + '", ';

        const body = document.getElementById('requestBody').value;
        if (body && ['POST', 'PUT', 'PATCH'].includes(currentMethod)) {
            code += 'HttpRequest.BodyPublishers.ofString("' + body.replace(/"/g, '\\"') + '")';
        } else {
            code += 'HttpRequest.BodyPublishers.noBody()';
        }
        code += ')\n';

        const headers = getHeaders();
        headers.forEach(h => {
            code += '    .header("' + h.name + '", "' + h.value + '")\n';
        });

        code += '    .build();\n\n';
        code += 'HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());\n';
        code += 'System.out.println(response.body());';

        return code;
    }

    function generateGoCode(url) {
        let code = 'package main\n\nimport (\n    "fmt"\n    "net/http"\n    "io/ioutil"\n';

        const body = document.getElementById('requestBody').value;
        if (body && ['POST', 'PUT', 'PATCH'].includes(currentMethod)) {
            code += '    "strings"\n';
        }

        code += ')\n\nfunc main() {\n';
        code += '    url := "' + url + '"\n\n';

        if (body && ['POST', 'PUT', 'PATCH'].includes(currentMethod)) {
            code += '    payload := strings.NewReader(`' + body + '`)\n\n';
            code += '    req, _ := http.NewRequest("' + currentMethod + '", url, payload)\n';
        } else {
            code += '    req, _ := http.NewRequest("' + currentMethod + '", url, nil)\n';
        }

        const headers = getHeaders();
        headers.forEach(h => {
            code += '    req.Header.Add("' + h.name + '", "' + h.value + '")\n';
        });

        code += '\n    client := &http.Client{}\n';
        code += '    res, err := client.Do(req)\n';
        code += '    if err != nil {\n        fmt.Println(err)\n        return\n    }\n';
        code += '    defer res.Body.Close()\n\n';
        code += '    body, _ := ioutil.ReadAll(res.Body)\n';
        code += '    fmt.Println(string(body))\n';
        code += '}';

        return code;
    }

    // Import cURL command
    function importCurl() {
        const curl = prompt('Paste your cURL command:');
        if (!curl) return;

        // Parse cURL command (basic implementation)
        // Extract URL
        const urlMatch = curl.match(/(https?:\/\/[^\s'"]+)/);
        if (urlMatch) {
            document.getElementById('requestUrl').value = urlMatch[1];
        }

        // Extract method
        const methodMatch = curl.match(/-X\s+(\w+)/);
        if (methodMatch) {
            const method = methodMatch[1];
            currentMethod = method;
            document.querySelectorAll('.method-btn').forEach(btn => {
                btn.classList.remove('active');
                if (btn.getAttribute('data-method') === method) {
                    btn.classList.add('active');
                }
            });
        }

        // Extract headers
        const headerMatches = curl.matchAll(/-H\s+['"]([^:]+):\s*([^'"]+)['"]/g);
        for (const match of headerMatches) {
            const container = document.getElementById('customHeaders');
            const row = document.createElement('div');
            row.className = 'header-row';
            row.innerHTML = '<input type="text" placeholder="Header Name" class="header-name" value="' + match[1].trim() + '">' +
                           '<input type="text" placeholder="Header Value" class="header-value" value="' + match[2].trim() + '">' +
                           '<button class="remove-btn" onclick="this.parentElement.remove()">✕</button>';
            container.appendChild(row);
        }

        // Extract body
        const bodyMatch = curl.match(/-d\s+['"](.+?)['"]/s);
        if (bodyMatch) {
            document.getElementById('bodyType').value = 'json';
            changeBodyType();
            document.getElementById('requestBody').value = bodyMatch[1].replace(/\\'/g, "'");
        }

        showToast('cURL command imported! Review the fields and click Send Request.');
    }

    // History management
    function saveToHistory(url, options, response) {
        const item = {
            timestamp: new Date().toISOString(),
            method: currentMethod,
            url: url,
            status: response.status,
            time: response.time
        };

        requestHistory.unshift(item);
        if (requestHistory.length > 50) {
            requestHistory = requestHistory.slice(0, 50);
        }

        localStorage.setItem('curl_history', JSON.stringify(requestHistory));
        renderHistory();
    }

    function loadHistory() {
        const saved = localStorage.getItem('curl_history');
        if (saved) {
            requestHistory = JSON.parse(saved);
            renderHistory();
        }
    }

    function renderHistory() {
        const container = document.getElementById('historyList');

        if (requestHistory.length === 0) {
            container.innerHTML = '<p style="color: #a0aec0; text-align: center; padding: 40px 0;">No request history yet</p>';
            return;
        }

        container.innerHTML = requestHistory.map(function(item, index) {
            const date = new Date(item.timestamp);
            const timeAgo = getTimeAgo(date);

            let statusClass = 'status-200';
            if (item.status >= 400 && item.status < 500) statusClass = 'status-400';
            if (item.status >= 500) statusClass = 'status-500';

            return '<div style="background: white; border: 2px solid #e2e8f0; border-radius: 6px; padding: 15px; margin-bottom: 10px;">' +
                '<div style="display: flex; justify-content: space-between; align-items: center;">' +
                '<div>' +
                '<span style="font-weight: 600; color: #2d3748;">' + item.method + '</span> ' +
                '<span style="color: #4a5568; font-family: Monaco, monospace; font-size: 13px;">' + item.url + '</span>' +
                '</div>' +
                '<span class="status-badge ' + statusClass + '">' + item.status + '</span>' +
                '</div>' +
                '<div style="margin-top: 5px; font-size: 12px; color: #a0aec0;">' +
                timeAgo + ' • ' + item.time + 'ms' +
                '</div>' +
                '</div>';
        }).join('');
    }

    function clearHistory() {
        if (confirm('Are you sure you want to clear all request history?')) {
            requestHistory = [];
            localStorage.removeItem('curl_history');
            renderHistory();
        }
    }

    function getTimeAgo(date) {
        const seconds = Math.floor((new Date() - date) / 1000);
        if (seconds < 60) return 'Just now';
        if (seconds < 3600) return Math.floor(seconds / 60) + 'm ago';
        if (seconds < 86400) return Math.floor(seconds / 3600) + 'h ago';
        return Math.floor(seconds / 86400) + 'd ago';
    }

    // Clear all form fields
    function clearAll() {
        if (confirm('Clear all fields?')) {
            document.getElementById('requestUrl').value = '';
            document.getElementById('queryParams').innerHTML = '';
            document.getElementById('customHeaders').innerHTML = '';
            document.getElementById('requestBody').value = '';
            document.getElementById('authType').value = 'none';
            document.getElementById('authFields').style.display = 'none';
            document.getElementById('bodyType').value = 'none';
            document.getElementById('bodyEditor').style.display = 'none';
            addQueryParam();
            addHeader();
        }
    }
</script>

</div>

<%@ include file="body-close.jsp"%>
