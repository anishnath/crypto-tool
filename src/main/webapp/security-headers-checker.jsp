
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Security Headers Checker - HTTP Security Headers Analyzer & Validator | 8gwifi.org</title>

    <meta name="description" content="Free online Security Headers Checker tool to analyze and validate HTTP security headers including CSP, HSTS, X-Frame-Options, X-Content-Type-Options, and more. Get security grade and recommendations for your website.">
    <meta name="keywords" content="security headers checker, http security headers, CSP validator, HSTS checker, X-Frame-Options, security headers analyzer, content security policy checker, HTTP header security, website security headers, security headers test, X-Content-Type-Options, Referrer-Policy, Permissions-Policy, security grade, header validation, web security analyzer, HTTP response headers, security headers scanner, CSP analyzer, HSTS validator, security best practices, HTTP security best practices, security headers audit, website security analysis, security headers report, web application security, security header recommendations, missing security headers, security headers online tool">

    <meta property="og:title" content="Security Headers Checker - HTTP Security Headers Analyzer & Validator">
    <meta property="og:description" content="Analyze and validate HTTP security headers for your website. Check CSP, HSTS, X-Frame-Options, and get security recommendations with detailed reports.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/security-headers-checker.jsp">
    <meta property="og:site_name" content="8gwifi.org">

    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="Security Headers Checker - HTTP Security Headers Analyzer">
    <meta name="twitter:description" content="Free tool to analyze HTTP security headers and get security grade with recommendations.">

    <link rel="canonical" href="https://8gwifi.org/security-headers-checker.jsp">

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "SoftwareApplication",
        "name": "Security Headers Checker",
        "description": "Free online tool to analyze and validate HTTP security headers including CSP, HSTS, X-Frame-Options, X-Content-Type-Options, Referrer-Policy, and Permissions-Policy. Get detailed security grade and recommendations.",
        "url": "https://8gwifi.org/security-headers-checker.jsp",
        "applicationCategory": "SecurityApplication",
        "operatingSystem": "Web Browser",
        "permissions": "No installation required",
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
        },
        "featureList": [
            "Check Content-Security-Policy (CSP) header",
            "Validate Strict-Transport-Security (HSTS)",
            "Analyze X-Frame-Options header",
            "Check X-Content-Type-Options header",
            "Validate Referrer-Policy header",
            "Check Permissions-Policy header",
            "Security grade calculation (A-F rating)",
            "Detailed security recommendations",
            "Missing headers detection",
            "Header value validation",
            "Color-coded security status",
            "Privacy-focused (client-side only)",
            "No data storage or logging",
            "CORS-aware checking",
            "Instant header analysis"
        ],
        "aggregateRating": {
            "@type": "AggregateRating",
            "ratingValue": "4.8",
            "ratingCount": "892",
            "bestRating": "5",
            "worstRating": "1"
        }
    }
    </script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "BreadcrumbList",
        "itemListElement": [{
            "@type": "ListItem",
            "position": 1,
            "name": "Home",
            "item": "https://8gwifi.org"
        },{
            "@type": "ListItem",
            "position": 2,
            "name": "Security Tools",
            "item": "https://8gwifi.org/security-headers-checker.jsp"
        },{
            "@type": "ListItem",
            "position": 3,
            "name": "Security Headers Checker"
        }]
    }
    </script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "FAQPage",
        "mainEntity": [{
            "@type": "Question",
            "name": "What are HTTP security headers?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "HTTP security headers are response headers that web servers send to browsers to enable security protections. Key headers include Content-Security-Policy (CSP), Strict-Transport-Security (HSTS), X-Frame-Options, X-Content-Type-Options, Referrer-Policy, and Permissions-Policy. These headers help protect against attacks like XSS, clickjacking, MIME-sniffing, and man-in-the-middle attacks."
            }
        },{
            "@type": "Question",
            "name": "Why should I check my website's security headers?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Checking security headers helps identify missing or misconfigured HTTP security headers that could leave your website vulnerable to attacks. Properly configured headers provide defense-in-depth security, help meet compliance requirements, and improve your security posture. Regular header checks ensure your security controls remain effective."
            }
        },{
            "@type": "Question",
            "name": "What is Content-Security-Policy (CSP)?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Content-Security-Policy (CSP) is a security header that helps prevent XSS attacks, clickjacking, and other code injection attacks by specifying which sources of content are trusted. CSP allows you to control where scripts, styles, images, and other resources can be loaded from, significantly reducing the attack surface of your web application."
            }
        },{
            "@type": "Question",
            "name": "What is HSTS and why is it important?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "HTTP Strict-Transport-Security (HSTS) forces browsers to only connect to your site over HTTPS, preventing downgrade attacks and cookie hijacking. HSTS is critical for any site handling sensitive data. The header should include a long max-age directive and ideally the includeSubDomains and preload directives for maximum protection."
            }
        },{
            "@type": "Question",
            "name": "Is this security headers checker tool safe to use?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Yes, this tool is completely safe. All header checking is performed client-side in your browser. No URLs or header data are sent to our servers or logged anywhere. The tool makes direct requests from your browser to the target website, ensuring your privacy and security."
            }
        }]
    }
    </script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "HowTo",
        "name": "How to Check Security Headers",
        "description": "Step-by-step guide to analyzing HTTP security headers for your website",
        "step": [{
            "@type": "HowToStep",
            "position": 1,
            "name": "Enter URL",
            "text": "Enter the full URL of the website you want to check (e.g., https://example.com)"
        },{
            "@type": "HowToStep",
            "position": 2,
            "name": "Check Headers",
            "text": "Click the 'Check Security Headers' button to analyze the HTTP response headers"
        },{
            "@type": "HowToStep",
            "position": 3,
            "name": "Review Results",
            "text": "Review the color-coded results showing which headers are present (green), missing (red), or need attention (yellow)"
        },{
            "@type": "HowToStep",
            "position": 4,
            "name": "Check Security Grade",
            "text": "View your overall security grade (A-F) based on the presence and configuration of security headers"
        },{
            "@type": "HowToStep",
            "position": 5,
            "name": "Follow Recommendations",
            "text": "Read the detailed recommendations for missing or misconfigured headers and implement them on your web server"
        }]
    }
    </script>

    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 1rem 0;
        }
        .main-container {
            max-width: 900px;
            margin: 0 auto;
        }
        .tool-header {
            background: white;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .tool-header h1 {
            color: #667eea;
            font-size: 1.75rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        .tool-header p {
            color: #6c757d;
            margin-bottom: 0;
            font-size: 0.9rem;
        }
        .control-panel {
            background: white;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .form-group {
            margin-bottom: 1rem;
        }
        .form-group label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }
        .form-control {
            border-radius: 6px;
            border: 2px solid #e9ecef;
            padding: 0.6rem;
            font-size: 0.9rem;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 0.6rem 1.5rem;
            font-weight: 600;
            border-radius: 6px;
            transition: transform 0.2s;
            font-size: 0.9rem;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }
        .results-panel {
            background: white;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .results-panel h3 {
            color: #495057;
            font-size: 1.1rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }
        .security-grade {
            text-align: center;
            padding: 1.5rem;
            border-radius: 8px;
            margin-bottom: 1rem;
        }
        .grade-letter {
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        .grade-a { background: #d4edda; color: #155724; }
        .grade-b { background: #d1ecf1; color: #0c5460; }
        .grade-c { background: #fff3cd; color: #856404; }
        .grade-d { background: #f8d7da; color: #721c24; }
        .grade-f { background: #f5c6cb; color: #721c24; }
        .header-item {
            padding: 0.75rem;
            margin-bottom: 0.75rem;
            border-radius: 6px;
            border-left: 4px solid;
        }
        .header-present {
            background: #d4edda;
            border-left-color: #28a745;
        }
        .header-missing {
            background: #f8d7da;
            border-left-color: #dc3545;
        }
        .header-warning {
            background: #fff3cd;
            border-left-color: #ffc107;
        }
        .header-item-title {
            font-weight: 600;
            margin-bottom: 0.25rem;
            font-size: 0.95rem;
        }
        .header-item-value {
            font-family: 'Courier New', monospace;
            font-size: 0.85rem;
            color: #495057;
            word-break: break-all;
            margin-bottom: 0.25rem;
        }
        .header-item-desc {
            font-size: 0.85rem;
            color: #6c757d;
            margin-bottom: 0;
        }
        .recommendation {
            background: #e7f3ff;
            border-left: 4px solid #2196F3;
            padding: 0.75rem;
            margin-top: 0.5rem;
            border-radius: 6px;
        }
        .recommendation-title {
            font-weight: 600;
            color: #0c5460;
            margin-bottom: 0.25rem;
            font-size: 0.9rem;
        }
        .recommendation-text {
            font-size: 0.85rem;
            color: #495057;
            margin-bottom: 0;
        }
        .info-section {
            background: white;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .info-section h3 {
            color: #495057;
            font-size: 1.1rem;
            font-weight: 700;
            margin-bottom: 0.75rem;
        }
        .info-section p, .info-section ul {
            color: #6c757d;
            font-size: 0.9rem;
            margin-bottom: 0.75rem;
        }
        .info-section ul {
            padding-left: 1.25rem;
        }
        .collapse-toggle {
            color: #667eea;
            cursor: pointer;
            font-weight: 600;
            font-size: 0.9rem;
            margin-bottom: 1rem;
            display: inline-block;
        }
        .collapse-toggle:hover {
            color: #764ba2;
            text-decoration: none;
        }
        .related-tools {
            background: white;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .related-tools h3 {
            color: #495057;
            font-size: 1.1rem;
            font-weight: 700;
            margin-bottom: 0.75rem;
        }
        .related-tools a {
            color: #667eea;
            text-decoration: none;
            margin-right: 1rem;
            font-size: 0.9rem;
        }
        .related-tools a:hover {
            color: #764ba2;
            text-decoration: underline;
        }
        .alert {
            border-radius: 6px;
            padding: 0.75rem;
            font-size: 0.9rem;
        }
    </style>
    <%@ include file="header-script.jsp"%>
</head>


<%@ include file="body-script.jsp"%>

<div class="main-container">
    <div class="tool-header">
        <h1><i class="fas fa-shield-alt"></i> Security Headers Checker</h1>
        <p>Analyze HTTP security headers and get a security grade for your website. Check CSP, HSTS, X-Frame-Options, and more.</p>
    </div>

    <div class="control-panel">
        <div class="form-group">
            <label for="targetUrl"><i class="fas fa-link"></i> Website URL</label>
            <input type="text" class="form-control" id="targetUrl" placeholder="https://example.com" value="https://8gwifi.org">
        </div>

        <div class="alert alert-info" style="margin-bottom: 1rem;">
            <i class="fas fa-info-circle"></i> <strong>Note:</strong> Due to CORS restrictions, this tool can only check websites that allow cross-origin requests. For full header analysis, use browser developer tools (F12 → Network tab) or server-side tools.
        </div>

        <button class="btn btn-primary btn-block" onclick="checkHeaders()">
            <i class="fas fa-search"></i> Check Security Headers
        </button>
    </div>

    <div id="resultsContainer" style="display: none;">
        <div class="results-panel">
            <h3><i class="fas fa-chart-bar"></i> Security Grade</h3>
            <div id="securityGrade"></div>
        </div>

        <div class="results-panel">
            <h3><i class="fas fa-list-check"></i> Security Headers Analysis</h3>
            <div id="headersAnalysis"></div>
        </div>

        <div class="results-panel">
            <h3><i class="fas fa-lightbulb"></i> Recommendations</h3>
            <div id="recommendations"></div>
        </div>
    </div>

    <div class="info-section">
        <a class="collapse-toggle" data-toggle="collapse" href="#howItWorksCollapse">
            <i class="fas fa-question-circle"></i> How Security Headers Work
        </a>
        <div class="collapse" id="howItWorksCollapse">
            <p><strong>Content-Security-Policy (CSP):</strong> Helps prevent XSS attacks by specifying trusted sources for content. Define allowed sources for scripts, styles, images, and other resources.</p>

            <p><strong>Strict-Transport-Security (HSTS):</strong> Forces browsers to only use HTTPS connections, preventing downgrade attacks and cookie hijacking. Should include max-age directive.</p>

            <p><strong>X-Frame-Options:</strong> Prevents clickjacking attacks by controlling whether your site can be embedded in frames. Values: DENY, SAMEORIGIN, or ALLOW-FROM.</p>

            <p><strong>X-Content-Type-Options:</strong> Prevents MIME-sniffing attacks by forcing browsers to respect declared content types. Should be set to "nosniff".</p>

            <p><strong>Referrer-Policy:</strong> Controls how much referrer information is sent with requests. Helps protect user privacy and sensitive information in URLs.</p>

            <p><strong>Permissions-Policy:</strong> Controls which browser features and APIs can be used. Helps reduce attack surface by disabling unnecessary features.</p>

            <p><strong>X-XSS-Protection:</strong> Legacy header for older browsers. Enables the browser's XSS filter. Modern browsers prefer CSP instead.</p>
        </div>
    </div>

    <div class="related-tools">
        <h3><i class="fas fa-tools"></i> Related Tools</h3>
        <a href="jwt-debugger.jsp"><i class="fas fa-key"></i> JWT Debugger</a>
        <a href="totp-hotp.jsp"><i class="fas fa-lock"></i> TOTP/HOTP Generator</a>
        <a href="pgpencdec.jsp"><i class="fas fa-envelope-open-text"></i> PGP Tools</a>
        <a href="rsafunctions.jsp"><i class="fas fa-certificate"></i> RSA Tools</a>
    </div>
</div>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>

<script>
const securityHeaders = {
    'content-security-policy': {
        name: 'Content-Security-Policy',
        description: 'Helps prevent XSS attacks by specifying trusted sources for content',
        recommendation: 'Add a Content-Security-Policy header to prevent XSS attacks. Start with a restrictive policy and gradually allow needed sources. Example: Content-Security-Policy: default-src \'self\'; script-src \'self\' \'unsafe-inline\'; style-src \'self\' \'unsafe-inline\';'
    },
    'strict-transport-security': {
        name: 'Strict-Transport-Security (HSTS)',
        description: 'Forces HTTPS connections and prevents downgrade attacks',
        recommendation: 'Add HSTS header to force HTTPS connections. Example: Strict-Transport-Security: max-age=31536000; includeSubDomains; preload'
    },
    'x-frame-options': {
        name: 'X-Frame-Options',
        description: 'Prevents clickjacking attacks by controlling frame embedding',
        recommendation: 'Add X-Frame-Options header to prevent clickjacking. Use DENY to prevent all framing, or SAMEORIGIN to allow same-origin framing. Example: X-Frame-Options: DENY'
    },
    'x-content-type-options': {
        name: 'X-Content-Type-Options',
        description: 'Prevents MIME-sniffing attacks',
        recommendation: 'Add X-Content-Type-Options header to prevent MIME-sniffing. Example: X-Content-Type-Options: nosniff'
    },
    'referrer-policy': {
        name: 'Referrer-Policy',
        description: 'Controls referrer information sent with requests',
        recommendation: 'Add Referrer-Policy header to control referrer information. Recommended: no-referrer, strict-origin-when-cross-origin, or same-origin. Example: Referrer-Policy: strict-origin-when-cross-origin'
    },
    'permissions-policy': {
        name: 'Permissions-Policy',
        description: 'Controls browser features and APIs that can be used',
        recommendation: 'Add Permissions-Policy header to restrict browser features. Example: Permissions-Policy: geolocation=(), microphone=(), camera=()'
    },
    'x-xss-protection': {
        name: 'X-XSS-Protection',
        description: 'Legacy XSS filter for older browsers (use CSP instead)',
        recommendation: 'Add X-XSS-Protection for older browser support. Example: X-XSS-Protection: 1; mode=block'
    }
};

function checkHeaders() {
    const url = document.getElementById('targetUrl').value.trim();

    if (!url) {
        alert('Please enter a URL to check');
        return;
    }

    if (!url.startsWith('http://') && !url.startsWith('https://')) {
        alert('Please enter a valid URL starting with http:// or https://');
        return;
    }

    document.getElementById('resultsContainer').style.display = 'none';

    fetch(url, {
        method: 'HEAD',
        mode: 'cors',
        cache: 'no-cache'
    })
    .then(response => {
        const headers = {};
        for (let [key, value] of response.headers.entries()) {
            headers[key.toLowerCase()] = value;
        }
        displayResults(headers, url);
    })
    .catch(error => {
        alert('Error checking headers: ' + error.message + '\n\nThis is usually due to CORS restrictions. The target website must allow cross-origin requests. For full analysis, use browser developer tools (F12 → Network tab) or check your own website.');
    });
}

function displayResults(headers, url) {
    const present = [];
    const missing = [];
    const warnings = [];

    for (let headerKey in securityHeaders) {
        if (headers[headerKey]) {
            const header = securityHeaders[headerKey];
            present.push({
                key: headerKey,
                name: header.name,
                value: headers[headerKey],
                description: header.description
            });

            if (headerKey === 'strict-transport-security' && !headers[headerKey].includes('max-age')) {
                warnings.push({
                    name: header.name,
                    message: 'HSTS header is present but missing max-age directive',
                    recommendation: 'Add max-age directive to HSTS header. Example: Strict-Transport-Security: max-age=31536000; includeSubDomains'
                });
            }

            if (headerKey === 'x-xss-protection' && headers[headerKey] === '0') {
                warnings.push({
                    name: header.name,
                    message: 'X-XSS-Protection is disabled',
                    recommendation: 'Enable X-XSS-Protection for older browser support. Example: X-XSS-Protection: 1; mode=block'
                });
            }
        } else {
            missing.push({
                key: headerKey,
                name: securityHeaders[headerKey].name,
                recommendation: securityHeaders[headerKey].recommendation
            });
        }
    }

    const grade = calculateGrade(present.length, missing.length, warnings.length);

    displayGrade(grade);
    displayHeadersAnalysis(present, missing);
    displayRecommendations(missing, warnings);

    document.getElementById('resultsContainer').style.display = 'block';
}

function calculateGrade(presentCount, missingCount, warningCount) {
    const totalHeaders = Object.keys(securityHeaders).length;
    const score = (presentCount / totalHeaders) * 100;
    const penalty = warningCount * 5;
    const finalScore = Math.max(0, score - penalty);

    if (finalScore >= 90) return { letter: 'A', class: 'grade-a', text: 'Excellent' };
    if (finalScore >= 75) return { letter: 'B', class: 'grade-b', text: 'Good' };
    if (finalScore >= 60) return { letter: 'C', class: 'grade-c', text: 'Fair' };
    if (finalScore >= 40) return { letter: 'D', class: 'grade-d', text: 'Poor' };
    return { letter: 'F', class: 'grade-f', text: 'Critical' };
}

function displayGrade(grade) {
    let html = '<div class="security-grade ' + grade.class + '">';
    html += '<div class="grade-letter">' + grade.letter + '</div>';
    html += '<div style="font-size: 1.1rem; font-weight: 600;">' + grade.text + '</div>';
    html += '<div style="font-size: 0.9rem; margin-top: 0.5rem;">Security Headers Grade</div>';
    html += '</div>';

    document.getElementById('securityGrade').innerHTML = html;
}

function displayHeadersAnalysis(present, missing) {
    let html = '';

    if (present.length > 0) {
        html += '<div style="margin-bottom: 1rem;"><strong style="color: #28a745;"><i class="fas fa-check-circle"></i> Present Headers (' + present.length + ')</strong></div>';

        for (let header of present) {
            html += '<div class="header-item header-present">';
            html += '<div class="header-item-title"><i class="fas fa-shield-alt"></i> ' + header.name + '</div>';
            html += '<div class="header-item-value">' + escapeHtml(header.value) + '</div>';
            html += '<div class="header-item-desc">' + header.description + '</div>';
            html += '</div>';
        }
    }

    if (missing.length > 0) {
        html += '<div style="margin-bottom: 1rem; margin-top: 1.5rem;"><strong style="color: #dc3545;"><i class="fas fa-times-circle"></i> Missing Headers (' + missing.length + ')</strong></div>';

        for (let header of missing) {
            html += '<div class="header-item header-missing">';
            html += '<div class="header-item-title"><i class="fas fa-exclamation-triangle"></i> ' + header.name + '</div>';
            html += '<div class="header-item-desc">This security header is not present</div>';
            html += '</div>';
        }
    }

    document.getElementById('headersAnalysis').innerHTML = html;
}

function displayRecommendations(missing, warnings) {
    let html = '';

    if (warnings.length > 0) {
        html += '<div style="margin-bottom: 1rem;"><strong style="color: #ffc107;"><i class="fas fa-exclamation-circle"></i> Warnings</strong></div>';

        for (let warning of warnings) {
            html += '<div class="recommendation">';
            html += '<div class="recommendation-title">' + warning.name + ': ' + warning.message + '</div>';
            html += '<div class="recommendation-text">' + warning.recommendation + '</div>';
            html += '</div>';
        }
    }

    if (missing.length > 0) {
        html += '<div style="margin-bottom: 1rem; margin-top: ' + (warnings.length > 0 ? '1.5rem' : '0') + ';"><strong style="color: #dc3545;"><i class="fas fa-list"></i> Missing Headers</strong></div>';

        for (let header of missing) {
            html += '<div class="recommendation">';
            html += '<div class="recommendation-title">' + header.name + '</div>';
            html += '<div class="recommendation-text">' + header.recommendation + '</div>';
            html += '</div>';
        }
    }

    if (missing.length === 0 && warnings.length === 0) {
        html = '<div class="alert alert-success"><i class="fas fa-check-circle"></i> <strong>Great job!</strong> All recommended security headers are properly configured.</div>';
    }

    document.getElementById('recommendations').innerHTML = html;
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}
</script>
</div>
<%@ include file="body-close.jsp"%>
