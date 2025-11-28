<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Htpasswd Generator Online – Free | 8gwifi.org</title>
    <meta name="description" content="Generate Apache/Nginx htpasswd compatible password hashes online. Support for bcrypt, SHA-256, SHA-512, APR-MD5, and crypt algorithms. Verify existing htpasswd hashes." />
    <meta name="keywords" content="htpasswd generator, htpasswd online, apache htpasswd, nginx basic auth, bcrypt htpasswd, sha512 htpasswd, password hash generator" />
    <meta name="robots" content="index,follow" />
    <meta name="author" content="Anish Nath" />
    <link rel="canonical" href="https://8gwifi.org/htpasswd.jsp" />

    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "WebApplication",
            "name": "Htpasswd Generator",
            "description": "Generate Apache/Nginx htpasswd compatible password hashes with bcrypt, SHA-256, SHA-512, APR-MD5, and crypt algorithms.",
            "url": "https://8gwifi.org/htpasswd.jsp",
            "applicationCategory": "SecurityApplication",
            "operatingSystem": "Any",
            "browserRequirements": "Requires JavaScript",
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
            "datePublished": "2020-02-06",
            "dateModified": "2025-01-15"
        }
    </script>

    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "HowTo",
            "name": "How to Generate htpasswd Hash",
            "description": "Generate password hashes for Apache/Nginx basic authentication",
            "step": [
                {"@type": "HowToStep", "name": "Enter Username", "text": "Enter the username for authentication"},
                {"@type": "HowToStep", "name": "Enter Password", "text": "Enter the password to hash"},
                {"@type": "HowToStep", "name": "Select Algorithm", "text": "Choose the hashing algorithm (bcrypt recommended)"},
                {"@type": "HowToStep", "name": "Generate Hash", "text": "Click generate to create the htpasswd entry"}
            ]
        }
    </script>

    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "FAQPage",
            "mainEntity": [
                {
                    "@type": "Question",
                    "name": "What is htpasswd?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "htpasswd is a utility used to create and update flat-files storing usernames and passwords for basic authentication of HTTP users in Apache and Nginx web servers."
                    }
                },
                {
                    "@type": "Question",
                    "name": "Which htpasswd algorithm is most secure?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "bcrypt ($2y$) is the most secure algorithm for htpasswd. It's designed to be computationally expensive, making brute-force attacks difficult. SHA-512 ($6$) is also a good choice."
                    }
                },
                {
                    "@type": "Question",
                    "name": "What do the prefixes like $2y$, $apr1$, $6$ mean?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "These are Modular Crypt Format identifiers: $2y$ = bcrypt, $apr1$ = Apache MD5, $5$ = SHA-256, $6$ = SHA-512, $sha1$ = SHA-1. The prefix tells the server which algorithm to use for verification."
                    }
                }
            ]
        }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        :root {
            --theme-primary: #7c3aed;
            --theme-secondary: #8b5cf6;
            --theme-gradient: linear-gradient(135deg, #7c3aed 0%, #8b5cf6 50%, #a78bfa 100%);
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
            min-height: 200px;
        }
        .result-placeholder {
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
            min-height: 150px;
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
        .algo-btn {
            border: 2px solid #e9ecef;
            background: white;
            padding: 0.5rem 0.75rem;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s;
            text-align: center;
        }
        .algo-btn:hover {
            border-color: var(--theme-primary);
        }
        .algo-btn.active {
            border-color: var(--theme-primary);
            background: var(--theme-light);
        }
        .algo-btn input {
            display: none;
        }
        .algo-prefix {
            font-family: monospace;
            font-size: 0.75rem;
            color: #6c757d;
        }
        .terminal-block {
            background: #1e1e1e;
            border-radius: 8px;
            overflow: hidden;
            margin-bottom: 1rem;
        }
        .terminal-header {
            background: #323232;
            color: #d4d4d4;
            padding: 0.5rem 1rem;
            font-size: 0.75rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .terminal-body {
            padding: 1rem;
            color: #4ec9b0;
            font-family: 'Monaco', 'Menlo', monospace;
            font-size: 0.8rem;
            overflow-x: auto;
        }
        .terminal-body code {
            color: #ce9178;
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
            box-shadow: 0 2px 8px rgba(124, 58, 237, 0.2);
            text-decoration: none;
        }
        .related-tool-card h6 {
            color: var(--theme-primary);
            margin-bottom: 0.25rem;
            font-size: 0.9rem;
        }
        .related-tool-card p {
            font-size: 0.75rem;
            color: #6c757d;
            margin: 0;
        }
        .hash-output {
            font-family: monospace;
            font-size: 0.85rem;
            word-break: break-all;
            background: #f8fafc;
            padding: 0.75rem;
            border-radius: 6px;
            border: 1px solid #e2e8f0;
        }
    </style>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="pgp-menu-nav.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-2">
    <div>
        <h1 class="h4 mb-0">Htpasswd Generator</h1>
        <div class="mt-1">
            <span class="info-badge"><i class="fas fa-server"></i> Apache/Nginx</span>
            <span class="info-badge"><i class="fas fa-shield-alt"></i> Basic Auth</span>
            <span class="info-badge"><i class="fas fa-lock"></i> Secure Hash</span>
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
                <h5><i class="fas fa-key me-2"></i>Generate htpasswd</h5>
            </div>
            <div class="card-body">
                <form id="htpasswdForm">
                    <input type="hidden" name="methodName" value="HTPASSWORD_GENERATE">

                    <!-- Username & Password -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-user me-1"></i>Credentials</div>
                        <div class="row g-2">
                            <div class="col-5">
                                <label class="small text-muted mb-1">Username</label>
                                <input type="text" class="form-control" name="username" id="username" placeholder="admin" required>
                            </div>
                            <div class="col-7">
                                <label class="small text-muted mb-1">Password</label>
                                <div class="input-group">
                                    <input type="password" class="form-control" name="password" id="password" placeholder="Enter password" required>
                                    <button class="btn btn-outline-secondary" type="button" onclick="togglePassword()">
                                        <i class="fas fa-eye" id="toggleIcon"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Algorithm Selection -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-cog me-1"></i>Algorithm</div>
                        <div class="row g-2">
                            <div class="col-6">
                                <label class="algo-btn w-100 active" id="algo-bcrypt">
                                    <input type="radio" name="workload" value="bcrypt" checked>
                                    <div><strong>bcrypt</strong></div>
                                    <div class="algo-prefix">$2y$</div>
                                </label>
                            </div>
                            <div class="col-6">
                                <label class="algo-btn w-100" id="algo-sha512">
                                    <input type="radio" name="workload" value="sha512">
                                    <div><strong>SHA-512</strong></div>
                                    <div class="algo-prefix">$6$</div>
                                </label>
                            </div>
                            <div class="col-6">
                                <label class="algo-btn w-100" id="algo-sha256">
                                    <input type="radio" name="workload" value="sha256">
                                    <div><strong>SHA-256</strong></div>
                                    <div class="algo-prefix">$5$</div>
                                </label>
                            </div>
                            <div class="col-6">
                                <label class="algo-btn w-100" id="algo-apr">
                                    <input type="radio" name="workload" value="apr">
                                    <div><strong>APR-MD5</strong></div>
                                    <div class="algo-prefix">$apr1$</div>
                                </label>
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn w-100" id="generateBtn" style="background: var(--theme-gradient); color: white; font-weight: 600;">
                        <i class="fas fa-cogs me-2"></i>Generate htpasswd
                    </button>
                </form>

                <hr class="my-3">

                <!-- Verify Hash -->
                <form id="verifyForm">
                    <input type="hidden" name="methodName" value="HTPASSWORD_GENERATE">
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-check-circle me-1"></i>Verify Existing Hash</div>
                        <input type="text" class="form-control mb-2" name="password" id="verifyPassword" placeholder="Password to verify">
                        <input type="text" class="form-control font-monospace" name="hash" id="verifyHash" placeholder="$2y$10$..." style="font-size: 0.8rem;">
                    </div>
                    <button type="submit" class="btn btn-outline-primary w-100" id="verifyBtn">
                        <i class="fas fa-check me-2"></i>Verify Hash
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-7 mb-4">
        <div class="card tool-card result-card">
            <div class="card-header card-header-custom d-flex justify-content-between align-items-center">
                <h5 class="mb-0"><i class="fas fa-file-alt me-2"></i>Generated .htpasswd Entry</h5>
                <button class="btn btn-sm btn-light" onclick="copyResult()" id="copyBtn" style="display: none;">
                    <i class="fas fa-copy"></i>
                </button>
            </div>
            <div class="card-body">
                <div class="result-placeholder" id="resultPlaceholder">
                    <div class="text-center">
                        <i class="fas fa-file-code fa-3x mb-3 text-muted"></i>
                        <p class="mb-0">htpasswd entry will appear here</p>
                        <small class="text-muted">Enter username and password to generate</small>
                    </div>
                </div>
                <div class="result-content" id="resultContent"></div>
            </div>
        </div>

        <!-- OpenSSL Commands -->
        <div class="card tool-card mt-3">
            <div class="card-header bg-dark text-white py-2">
                <h6 class="mb-0"><i class="fas fa-terminal me-2"></i>htpasswd Commands</h6>
            </div>
            <div class="card-body p-0">
                <div class="terminal-block mb-0">
                    <div class="terminal-header">
                        <span>Generate bcrypt hash</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCmd('htpasswd -B -c .htpasswd admin')"><i class="fas fa-copy"></i></button>
                    </div>
                    <div class="terminal-body">
                        $ htpasswd -B -c <code>.htpasswd</code> <code>admin</code>
                    </div>
                </div>
                <div class="terminal-block mb-0">
                    <div class="terminal-header">
                        <span>Generate SHA-512 hash (OpenSSL)</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCmd('openssl passwd -6 -salt $(openssl rand -base64 8)')"><i class="fas fa-copy"></i></button>
                    </div>
                    <div class="terminal-body">
                        $ openssl passwd -6 -salt $(openssl rand -base64 8)
                    </div>
                </div>
                <div class="terminal-block mb-0">
                    <div class="terminal-header">
                        <span>Generate APR-MD5 hash</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCmd('openssl passwd -apr1')"><i class="fas fa-copy"></i></button>
                    </div>
                    <div class="terminal-body">
                        $ openssl passwd -apr1
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Related Tools -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light py-2">
        <h6 class="mb-0"><i class="fas fa-tools me-2"></i>Related Password Hashing Tools</h6>
    </div>
    <div class="card-body">
        <div class="related-tools">
            <a href="bccrypt.jsp" class="related-tool-card">
                <h6><i class="fas fa-lock me-1"></i>BCrypt</h6>
                <p>BCrypt password hashing</p>
            </a>
            <a href="scrypt.jsp" class="related-tool-card">
                <h6><i class="fas fa-memory me-1"></i>Scrypt</h6>
                <p>Memory-hard password hashing</p>
            </a>
            <a href="argon2.jsp" class="related-tool-card">
                <h6><i class="fas fa-shield-alt me-1"></i>Argon2</h6>
                <p>Modern password hashing</p>
            </a>
            <a href="pbe.jsp" class="related-tool-card">
                <h6><i class="fas fa-key me-1"></i>PBE</h6>
                <p>Password-based encryption</p>
            </a>
        </div>
    </div>
</div>

<%@ include file="thanks.jsp"%>

<!-- Educational Content -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light">
        <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding htpasswd</h5>
    </div>
    <div class="card-body">
        <h6>What is htpasswd?</h6>
        <p>The <code>htpasswd</code> utility creates and updates flat-files storing usernames and passwords for basic HTTP authentication in Apache and Nginx web servers.</p>

        <h6 class="mt-4">Modular Crypt Format</h6>
        <p class="small">htpasswd uses the Modular Crypt Format (MCF) which identifies the algorithm by a prefix:</p>
        <div class="table-responsive">
            <table class="table table-sm table-bordered">
                <thead class="table-light">
                <tr>
                    <th>Prefix</th>
                    <th>Algorithm</th>
                    <th>Security</th>
                    <th>Notes</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td><code>$2y$</code> / <code>$2a$</code></td>
                    <td>bcrypt</td>
                    <td><span class="badge bg-success">Excellent</span></td>
                    <td>Recommended. Adjustable cost factor.</td>
                </tr>
                <tr>
                    <td><code>$6$</code></td>
                    <td>SHA-512</td>
                    <td><span class="badge bg-success">Very Good</span></td>
                    <td>5000 rounds default. Good alternative.</td>
                </tr>
                <tr>
                    <td><code>$5$</code></td>
                    <td>SHA-256</td>
                    <td><span class="badge bg-primary">Good</span></td>
                    <td>5000 rounds default.</td>
                </tr>
                <tr>
                    <td><code>$apr1$</code></td>
                    <td>APR-MD5</td>
                    <td><span class="badge bg-warning text-dark">Fair</span></td>
                    <td>Apache-specific MD5. Legacy support.</td>
                </tr>
                <tr>
                    <td><code>{SHA}</code></td>
                    <td>SHA-1</td>
                    <td><span class="badge bg-danger">Weak</span></td>
                    <td>Unsalted. Not recommended.</td>
                </tr>
                <tr>
                    <td>(none)</td>
                    <td>crypt(3)</td>
                    <td><span class="badge bg-danger">Weak</span></td>
                    <td>DES-based. 8 char max. Avoid.</td>
                </tr>
                </tbody>
            </table>
        </div>

        <h6 class="mt-4">Nginx Configuration</h6>
        <pre class="bg-dark text-light p-3 rounded small"><code>location /protected {
    auth_basic "Restricted Area";
    auth_basic_user_file /etc/nginx/.htpasswd;
}</code></pre>

        <h6 class="mt-4">Apache Configuration</h6>
        <pre class="bg-dark text-light p-3 rounded small"><code>&lt;Directory "/var/www/protected"&gt;
    AuthType Basic
    AuthName "Restricted Area"
    AuthUserFile /etc/apache2/.htpasswd
    Require valid-user
&lt;/Directory&gt;</code></pre>
    </div>
</div>

<%@ include file="addcomments.jsp"%>
</div>

<!-- Share URL Modal -->
<div class="modal fade" id="shareUrlModal" tabindex="-1" role="dialog" aria-labelledby="shareUrlModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header" style="background: var(--theme-gradient); color: white;">
                <h5 class="modal-title" id="shareUrlModalLabel">
                    <i class="fas fa-share-alt"></i> Share htpasswd Hash
                </h5>
                <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="alert alert-info mb-3">
                    <strong><i class="fas fa-shield-alt"></i> What's Being Shared:</strong>
                    <ul class="mb-0 mt-2">
                        <li><strong>htpasswd Hash:</strong> The generated password hash</li>
                        <li><strong>Algorithm:</strong> <span id="shareAlgoName">-</span></li>
                        <li><strong>Username:</strong> <span id="shareUsername">-</span></li>
                        <li><strong class="text-success">NOT Included:</strong> Your original password (kept secure)</li>
                    </ul>
                </div>
                <div class="alert alert-warning mb-3">
                    <strong><i class="fas fa-info-circle"></i> Security Note:</strong>
                    <p class="mb-0">htpasswd hashes are designed to be stored in authentication files. The recipient can use this URL to verify if they know the correct password.</p>
                </div>

                <label class="font-weight-bold mb-2">Share URL:</label>
                <div class="input-group mb-3">
                    <input type="text" class="form-control" id="shareUrlText" readonly style="font-size: 11px; font-family: monospace;">
                    <div class="input-group-append">
                        <button class="btn btn-success" type="button" id="copyShareUrl">
                            <i class="fas fa-copy"></i> Copy
                        </button>
                    </div>
                </div>

                <small class="text-muted">
                    <i class="fas fa-lightbulb"></i> <strong>Tip:</strong> Use a URL shortener if the link is too long.
                </small>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script>
    var lastResult = '';
    var lastPassword = '';
    var lastUsername = '';
    var lastHashes = {}; // Store hashes by algorithm

    $(document).ready(function() {
        // Check for URL parameters on page load
        loadFromUrl();

        // Algorithm selection styling
        $('.algo-btn').click(function() {
            $('.algo-btn').removeClass('active');
            $(this).addClass('active');
        });

        // Generate form submission
        $('#htpasswdForm').submit(function(event) {
            event.preventDefault();
            var username = $('#username').val().trim();
            var password = $('#password').val();

            if (!username || !password) {
                showToast('Please enter username and password');
                return;
            }

            $('#generateBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Generating...');

            $.ajax({
                type: "POST",
                url: "BCCryptFunctionality",
                data: $(this).serialize(),
                dataType: "json",
                success: function(response) {
                    if (!response.success) {
                        showToast(response.errorMessage || 'Error generating hash');
                        $('#generateBtn').prop('disabled', false).html('<i class="fas fa-cogs me-2"></i>Generate htpasswd');
                        return;
                    }

                    // Store values for later use
                    lastPassword = $('#password').val();
                    lastUsername = $('#username').val();
                    lastHashes = {};
                    if (response.htpasswdEntries) {
                        response.htpasswdEntries.forEach(function(entry) {
                            lastHashes[entry.algorithm] = entry.fullEntry;
                        });
                    }

                    var html = renderHtpasswdResult(response);
                    lastResult = html;
                    $('#resultPlaceholder').hide();
                    $('#resultContent').html(html).show();
                    $('#copyBtn').show();
                    $('#generateBtn').prop('disabled', false).html('<i class="fas fa-cogs me-2"></i>Generate htpasswd');
                },
                error: function() {
                    showToast('Error generating hash');
                    $('#generateBtn').prop('disabled', false).html('<i class="fas fa-cogs me-2"></i>Generate htpasswd');
                }
            });
        });

        // Verify form submission
        $('#verifyForm').submit(function(event) {
            event.preventDefault();
            var password = $('#verifyPassword').val();
            var hash = $('#verifyHash').val().trim();

            if (!password || !hash) {
                showToast('Please enter password and hash to verify');
                return;
            }

            $('#verifyBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Verifying...');

            $.ajax({
                type: "POST",
                url: "BCCryptFunctionality",
                data: $(this).serialize(),
                dataType: "json",
                success: function(response) {
                    var html = renderVerifyResult(response);
                    $('#resultPlaceholder').hide();
                    $('#resultContent').html(html).show();
                    $('#verifyBtn').prop('disabled', false).html('<i class="fas fa-check me-2"></i>Verify Hash');
                },
                error: function() {
                    showToast('Error verifying hash');
                    $('#verifyBtn').prop('disabled', false).html('<i class="fas fa-check me-2"></i>Verify Hash');
                }
            });
        });
    });

    function renderHtpasswdResult(response) {
        var html = '';

        // Show verification result if present
        if (response.verified !== null && response.verified !== undefined) {
            var alertClass = response.verified ? 'alert-success' : 'alert-danger';
            var icon = response.verified ? 'fa-check-circle' : 'fa-times-circle';
            html += '<div class="alert ' + alertClass + ' mb-3">';
            html += '<i class="fas ' + icon + ' me-2"></i>';
            html += '<strong>' + (response.verified ? 'Verified!' : 'Failed!') + '</strong> ';
            html += response.verificationMessage || '';
            if (response.verified && response.algorithm) {
                html += '<br><small class="text-muted">Algorithm detected: ' + response.algorithm + '</small>';
            }
            html += '</div>';
        }

        // Show generated hashes
        if (response.htpasswdEntries && response.htpasswdEntries.length > 0) {
            html += '<div class="mb-2 small text-muted">Generated for: <strong>' + (response.username || 'no username') + '</strong></div>';

            response.htpasswdEntries.forEach(function(entry) {
                html += '<div class="mb-3">';
                html += '<div class="d-flex justify-content-between align-items-center mb-1">';
                html += '<span class="badge" style="background: var(--theme-gradient);">' + entry.algorithm + '</span>';
                html += '<code class="small text-muted">' + entry.prefix + '</code>';
                html += '</div>';
                html += '<div class="hash-output position-relative">';
                html += '<span class="hash-text">' + escapeHtml(entry.fullEntry) + '</span>';
                html += '<button class="btn btn-sm btn-outline-secondary position-absolute" style="top: 5px; right: 5px;" onclick="copyHash(\'' + escapeJs(entry.fullEntry) + '\')">';
                html += '<i class="fas fa-copy"></i></button>';
                html += '</div>';
                html += '<div class="mt-1">';
                html += '<button class="btn btn-sm btn-outline-primary me-1" onclick="useForVerify(\'' + entry.algorithm + '\')">';
                html += '<i class="fas fa-check-circle me-1"></i>Verify</button>';
                html += '<button class="btn btn-sm btn-outline-secondary" onclick="shareUrl(\'' + entry.algorithm + '\')">';
                html += '<i class="fas fa-share-alt me-1"></i>Share</button>';
                html += '</div>';
                html += '</div>';
            });
        }

        return html;
    }

    function renderVerifyResult(response) {
        var html = '';

        if (!response.success) {
            html = '<div class="alert alert-danger">';
            html += '<i class="fas fa-exclamation-circle me-2"></i>';
            html += response.errorMessage || 'Error verifying hash';
            html += '</div>';
            return html;
        }

        if (response.verified !== null && response.verified !== undefined) {
            var alertClass = response.verified ? 'alert-success' : 'alert-danger';
            var icon = response.verified ? 'fa-check-circle' : 'fa-times-circle';
            html += '<div class="alert ' + alertClass + '">';
            html += '<i class="fas ' + icon + ' me-2"></i>';
            html += '<strong>' + (response.verified ? 'Hash Verified!' : 'Verification Failed!') + '</strong><br>';
            html += response.verificationMessage || '';
            if (response.verified && response.algorithm) {
                html += '<hr class="my-2"><small>Algorithm: <code>' + response.algorithm + '</code></small>';
            }
            html += '</div>';
        }

        // Also show generated hashes for reference
        if (response.htpasswdEntries && response.htpasswdEntries.length > 0) {
            html += '<hr><div class="small text-muted mb-2">Generated hashes for comparison:</div>';
            response.htpasswdEntries.forEach(function(entry) {
                html += '<div class="mb-2">';
                html += '<span class="badge bg-secondary me-2">' + entry.algorithm + '</span>';
                html += '<code class="small" style="word-break: break-all;">' + escapeHtml(entry.hash).substring(0, 40) + '...</code>';
                html += '</div>';
            });
        }

        return html;
    }

    function escapeHtml(text) {
        var div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    function escapeJs(text) {
        return text.replace(/'/g, "\\'").replace(/"/g, '\\"');
    }

    function copyHash(hash) {
        navigator.clipboard.writeText(hash).then(function() {
            showToast('Hash copied to clipboard!');
        });
    }

    function togglePassword() {
        var input = $('#password');
        var icon = $('#toggleIcon');
        if (input.attr('type') === 'password') {
            input.attr('type', 'text');
            icon.removeClass('fa-eye').addClass('fa-eye-slash');
        } else {
            input.attr('type', 'password');
            icon.removeClass('fa-eye-slash').addClass('fa-eye');
        }
    }

    function copyResult() {
        var text = $('#resultContent').text().trim();
        navigator.clipboard.writeText(text).then(function() {
            showToast('Copied to clipboard!');
        });
    }

    function copyCmd(cmd) {
        navigator.clipboard.writeText(cmd).then(function() {
            showToast('Command copied!');
        });
    }

    function showToast(message) {
        var toast = $('<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999;">' +
            '<div class="toast show"><div class="toast-body text-white rounded" style="background: var(--theme-gradient);">' +
            '<i class="fas fa-info-circle me-2"></i>' + message + '</div></div></div>');
        $('body').append(toast);
        setTimeout(function() { toast.fadeOut(function() { toast.remove(); }); }, 2000);
    }

    function useForVerify(algorithm) {
        var hash = lastHashes[algorithm];
        if (!hash) {
            showToast('Generate a hash first');
            return;
        }
        $('#verifyPassword').val(lastPassword);
        $('#verifyHash').val(hash);
        // Scroll to verify section
        $('html, body').animate({
            scrollTop: $('#verifyForm').offset().top - 100
        }, 300);
        showToast(algorithm + ' hash copied to verify form');
    }

    function shareUrl(algorithm) {
        var hash = lastHashes[algorithm];
        if (!hash) {
            showToast('Generate a hash first');
            return;
        }
        var params = new URLSearchParams();
        params.set('hash', hash);
        params.set('algo', algorithm);
        if (lastUsername) {
            params.set('user', lastUsername);
        }
        var url = window.location.origin + window.location.pathname + '?' + params.toString();

        // Update modal content
        $('#shareAlgoName').text(algorithm);
        $('#shareUsername').text(lastUsername || '(none)');
        $('#shareUrlText').val(url);
        $('#shareUrlModal').modal('show');
    }

    // Copy Share URL from modal
    $('#copyShareUrl').click(function() {
        var url = $('#shareUrlText').val();
        var btn = $(this);
        navigator.clipboard.writeText(url).then(function() {
            btn.html('<i class="fas fa-check"></i> Copied!');
            setTimeout(function() {
                btn.html('<i class="fas fa-copy"></i> Copy');
            }, 1500);
        });
    });

    function loadFromUrl() {
        var params = new URLSearchParams(window.location.search);
        var hash = params.get('hash');
        var algo = params.get('algo');
        var user = params.get('user');

        if (hash) {
            $('#verifyHash').val(hash);
            showToast('Hash loaded from URL - enter password to verify');
        }
        if (user) {
            $('#username').val(user);
        }
        if (algo) {
            // Select the matching algorithm button
            $('.algo-btn').removeClass('active');
            $('#algo-' + algo.toLowerCase()).addClass('active');
            $('#algo-' + algo.toLowerCase() + ' input').prop('checked', true);
        }
    }
</script>

<%@ include file="body-close.jsp"%>
