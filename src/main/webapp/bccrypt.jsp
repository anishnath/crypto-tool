<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>BCrypt Hash Generator & Verifier Online – Free | 8gwifi.org</title>
    <meta name="description" content="Generate and verify BCrypt password hashes online. Adjust cost factor for security. BCrypt is a secure password hashing function based on Blowfish cipher." />
    <meta name="keywords" content="bcrypt online, bcrypt hash generator, bcrypt verifier, bcrypt password hash, bcrypt cost factor, password hashing, blowfish hash" />
    <meta name="robots" content="index,follow" />
    <meta name="author" content="Anish Nath" />
    <link rel="canonical" href="https://8gwifi.org/bccrypt.jsp" />

    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "WebApplication",
            "name": "BCrypt Hash Generator",
            "description": "Generate and verify BCrypt password hashes with adjustable cost factor.",
            "url": "https://8gwifi.org/bccrypt.jsp",
            "applicationCategory": "SecurityApplication",
            "operatingSystem": "Any",
            "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
            "author": {"@type": "Person", "name": "Anish Nath", "url": "https://x.com/anish2good"},
            "datePublished": "2018-01-18",
            "dateModified": "2025-01-15"
        }
    </script>

    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "FAQPage",
            "mainEntity": [
                {
                    "@type": "Question",
                    "name": "What is BCrypt?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "BCrypt is a password hashing function designed by Niels Provos and David Mazières in 1999, based on the Blowfish cipher. It's designed to be computationally expensive to resist brute-force attacks."
                    }
                },
                {
                    "@type": "Question",
                    "name": "What is the BCrypt cost factor?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "The cost factor (work factor) determines how many iterations BCrypt performs. A cost of 10 means 2^10 = 1024 iterations. Higher values are more secure but slower. Cost 12 is recommended for most applications in 2024."
                    }
                },
                {
                    "@type": "Question",
                    "name": "What do the BCrypt prefixes $2a$, $2b$, $2y$ mean?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "$2a$ is the original BCrypt specification. $2b$ and $2y$ fix implementation bugs. $2y$ is PHP-specific. All three are compatible and equally secure in modern implementations."
                    }
                }
            ]
        }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        :root {
            --theme-primary: #dc2626;
            --theme-secondary: #ef4444;
            --theme-gradient: linear-gradient(135deg, #dc2626 0%, #ef4444 50%, #f87171 100%);
            --theme-light: #fef2f2;
        }
        .tool-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(220, 38, 38, 0.15);
            transition: box-shadow 0.3s ease;
        }
        .tool-card:hover {
            box-shadow: 0 4px 20px rgba(220, 38, 38, 0.25);
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
        .cost-btn {
            border: 2px solid #e9ecef;
            background: white;
            padding: 0.4rem 0.75rem;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s;
            text-align: center;
            font-weight: 600;
        }
        .cost-btn:hover {
            border-color: var(--theme-primary);
        }
        .cost-btn.active {
            border-color: var(--theme-primary);
            background: var(--theme-light);
            color: var(--theme-primary);
        }
        .cost-btn input {
            display: none;
        }
        .cost-label {
            font-size: 0.65rem;
            color: #6c757d;
            display: block;
        }
        .hash-anatomy {
            font-family: monospace;
            background: #1e1e1e;
            color: #d4d4d4;
            padding: 1rem;
            border-radius: 8px;
            font-size: 0.85rem;
            overflow-x: auto;
        }
        .hash-anatomy .prefix { color: #569cd6; }
        .hash-anatomy .cost { color: #4ec9b0; }
        .hash-anatomy .salt { color: #ce9178; }
        .hash-anatomy .hash { color: #dcdcaa; }
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
            box-shadow: 0 2px 8px rgba(220, 38, 38, 0.2);
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
    </style>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="pgp-menu-nav.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-2">
    <div>
        <h1 class="h4 mb-0">BCrypt Hash Generator</h1>
        <div class="mt-1">
            <span class="info-badge"><i class="fas fa-lock"></i> Blowfish</span>
            <span class="info-badge"><i class="fas fa-cog"></i> Adjustable Cost</span>
            <span class="info-badge"><i class="fas fa-shield-alt"></i> 192-bit</span>
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
                <h5><i class="fas fa-hashtag me-2"></i>Generate BCrypt Hash</h5>
            </div>
            <div class="card-body">
                <form id="bcryptForm">
                    <input type="hidden" name="methodName" value="CALCULATE_BCCRYPT">

                    <!-- Password Input -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-key me-1"></i>Password</div>
                        <div class="input-group">
                            <input type="password" class="form-control" name="password" id="password" placeholder="Enter password to hash" required>
                            <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('password', 'toggleIcon1')">
                                <i class="fas fa-eye" id="toggleIcon1"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Cost Factor Selection -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-tachometer-alt me-1"></i>Cost Factor (2<sup>n</sup> iterations)</div>
                        <div class="row g-2">
                            <div class="col-2-4" style="flex: 0 0 20%; max-width: 20%;">
                                <label class="cost-btn w-100 active">
                                    <input type="radio" name="workload" value="10" checked>
                                    <div>10</div>
                                    <span class="cost-label">1K</span>
                                </label>
                            </div>
                            <div class="col-2-4" style="flex: 0 0 20%; max-width: 20%;">
                                <label class="cost-btn w-100">
                                    <input type="radio" name="workload" value="11">
                                    <div>11</div>
                                    <span class="cost-label">2K</span>
                                </label>
                            </div>
                            <div class="col-2-4" style="flex: 0 0 20%; max-width: 20%;">
                                <label class="cost-btn w-100">
                                    <input type="radio" name="workload" value="12">
                                    <div>12</div>
                                    <span class="cost-label">4K</span>
                                </label>
                            </div>
                            <div class="col-2-4" style="flex: 0 0 20%; max-width: 20%;">
                                <label class="cost-btn w-100">
                                    <input type="radio" name="workload" value="13">
                                    <div>13</div>
                                    <span class="cost-label">8K</span>
                                </label>
                            </div>
                            <div class="col-2-4" style="flex: 0 0 20%; max-width: 20%;">
                                <label class="cost-btn w-100">
                                    <input type="radio" name="workload" value="14">
                                    <div>14</div>
                                    <span class="cost-label">16K</span>
                                </label>
                            </div>
                        </div>
                        <small class="text-muted mt-2 d-block"><i class="fas fa-info-circle me-1"></i>Cost 12 recommended for 2024. Higher = slower but more secure.</small>
                    </div>

                    <button type="submit" class="btn w-100" id="generateBtn" style="background: var(--theme-gradient); color: white; font-weight: 600;">
                        <i class="fas fa-cogs me-2"></i>Generate BCrypt Hash
                    </button>
                </form>

                <hr class="my-3">

                <!-- Verify Hash -->
                <form id="verifyForm">
                    <input type="hidden" name="methodName" value="CALCULATE_BCCRYPT">
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-check-circle me-1"></i>Verify Hash</div>
                        <div class="input-group mb-2">
                            <input type="password" class="form-control" name="password" id="verifyPassword" placeholder="Password">
                            <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('verifyPassword', 'toggleIcon2')">
                                <i class="fas fa-eye" id="toggleIcon2"></i>
                            </button>
                        </div>
                        <input type="text" class="form-control font-monospace" name="hash" id="verifyHash" placeholder="$2a$10$..." style="font-size: 0.75rem;">
                    </div>
                    <button type="submit" class="btn btn-outline-danger w-100" id="verifyBtn">
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
                <h5 class="mb-0"><i class="fas fa-fingerprint me-2"></i>BCrypt Hash Output</h5>
                <button class="btn btn-sm btn-light" onclick="copyResult()" id="copyBtn" style="display: none;">
                    <i class="fas fa-copy"></i>
                </button>
            </div>
            <div class="card-body">
                <div class="result-placeholder" id="resultPlaceholder">
                    <div class="text-center">
                        <i class="fas fa-fingerprint fa-3x mb-3 text-muted"></i>
                        <p class="mb-0">BCrypt hash will appear here</p>
                        <small class="text-muted">Enter a password to generate hash</small>
                    </div>
                </div>
                <div class="result-content" id="resultContent"></div>
            </div>
        </div>

        <!-- Hash Anatomy -->
        <div class="card tool-card mt-3">
            <div class="card-header bg-dark text-white py-2">
                <h6 class="mb-0"><i class="fas fa-microscope me-2"></i>BCrypt Hash Anatomy</h6>
            </div>
            <div class="card-body p-0">
                <div class="hash-anatomy">
                    <span class="prefix">$2a$</span><span class="cost">10</span>$<span class="salt">N9qo8uLOickgx2ZMRZoMy</span><span class="hash">ejhYJH9cRpPsJvp2O5arBFpTIxRVyqk</span>
                </div>
                <div class="p-3">
                    <div class="row small">
                        <div class="col-6 mb-2">
                            <span class="badge" style="background: #569cd6;">$2a$</span> Algorithm version
                        </div>
                        <div class="col-6 mb-2">
                            <span class="badge" style="background: #4ec9b0;">10</span> Cost factor (2<sup>10</sup> rounds)
                        </div>
                        <div class="col-6 mb-2">
                            <span class="badge" style="background: #ce9178;">22 chars</span> Base64 salt (128-bit)
                        </div>
                        <div class="col-6 mb-2">
                            <span class="badge" style="background: #dcdcaa; color: #333;">31 chars</span> Base64 hash (184-bit)
                        </div>
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
            <a href="scrypt.jsp" class="related-tool-card">
                <h6><i class="fas fa-memory me-1"></i>Scrypt</h6>
                <p>Memory-hard password hashing</p>
            </a>
            <a href="argon2.jsp" class="related-tool-card">
                <h6><i class="fas fa-shield-alt me-1"></i>Argon2</h6>
                <p>Modern password hashing winner</p>
            </a>
            <a href="htpasswd.jsp" class="related-tool-card">
                <h6><i class="fas fa-server me-1"></i>htpasswd</h6>
                <p>Apache/Nginx auth file generator</p>
            </a>
            <a href="pbe.jsp" class="related-tool-card">
                <h6><i class="fas fa-key me-1"></i>PBKDF2</h6>
                <p>Password-based key derivation</p>
            </a>
        </div>
    </div>
</div>

<%@ include file="thanks.jsp"%>

<!-- Educational Content -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light">
        <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding BCrypt</h5>
    </div>
    <div class="card-body">
        <h6>What is BCrypt?</h6>
        <p>BCrypt is a password hashing function designed by Niels Provos and David Mazières in 1999, based on the Blowfish cipher. It was first implemented in OpenBSD and is now widely used across platforms.</p>

        <h6 class="mt-4">Key Features</h6>
        <div class="row">
            <div class="col-md-6">
                <ul class="small">
                    <li><strong>Adaptive Cost:</strong> Adjustable work factor to increase computational time as hardware improves</li>
                    <li><strong>Built-in Salt:</strong> 128-bit random salt stored within the hash itself</li>
                    <li><strong>Fixed Output:</strong> Always produces 60-character string (192-bit hash)</li>
                </ul>
            </div>
            <div class="col-md-6">
                <ul class="small">
                    <li><strong>Slow by Design:</strong> Intentionally CPU-intensive to resist brute-force attacks</li>
                    <li><strong>GPU Resistant:</strong> Memory access patterns make GPU attacks less effective than SHA-based hashes</li>
                    <li><strong>72-byte Limit:</strong> Only first 72 bytes of password are used</li>
                </ul>
            </div>
        </div>

        <h6 class="mt-4">Cost Factor Recommendations</h6>
        <div class="table-responsive">
            <table class="table table-sm table-bordered">
                <thead class="table-light">
                <tr>
                    <th>Cost</th>
                    <th>Iterations</th>
                    <th>~Time (2024 hardware)</th>
                    <th>Use Case</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>10</td>
                    <td>1,024</td>
                    <td>~100ms</td>
                    <td>High-traffic APIs, mobile apps</td>
                </tr>
                <tr class="table-success">
                    <td><strong>12</strong></td>
                    <td>4,096</td>
                    <td>~300ms</td>
                    <td><strong>Recommended default</strong></td>
                </tr>
                <tr>
                    <td>14</td>
                    <td>16,384</td>
                    <td>~1s</td>
                    <td>High-security applications</td>
                </tr>
                <tr>
                    <td>16</td>
                    <td>65,536</td>
                    <td>~4s</td>
                    <td>Extreme security (key derivation)</td>
                </tr>
                </tbody>
            </table>
        </div>

        <h6 class="mt-4">Version Prefixes</h6>
        <div class="table-responsive">
            <table class="table table-sm table-bordered">
                <thead class="table-light">
                <tr>
                    <th>Prefix</th>
                    <th>Description</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td><code>$2$</code></td>
                    <td>Original specification (obsolete)</td>
                </tr>
                <tr>
                    <td><code>$2a$</code></td>
                    <td>Updated spec with UTF-8 support. Most common.</td>
                </tr>
                <tr>
                    <td><code>$2b$</code></td>
                    <td>OpenBSD fix for wraparound bug (2014)</td>
                </tr>
                <tr>
                    <td><code>$2y$</code></td>
                    <td>PHP-specific fix. Equivalent to $2b$ in practice.</td>
                </tr>
                </tbody>
            </table>
        </div>

        <h6 class="mt-4">Code Examples</h6>
        <div class="row">
            <div class="col-md-6">
                <p class="small mb-1"><strong>Java (Spring Security)</strong></p>
                <pre class="bg-dark text-light p-2 rounded small"><code>BCryptPasswordEncoder encoder =
    new BCryptPasswordEncoder(12);
String hash = encoder.encode(password);
boolean match = encoder.matches(
    password, hash);</code></pre>
            </div>
            <div class="col-md-6">
                <p class="small mb-1"><strong>Python</strong></p>
                <pre class="bg-dark text-light p-2 rounded small"><code>import bcrypt
hash = bcrypt.hashpw(
    password.encode(),
    bcrypt.gensalt(rounds=12))
bcrypt.checkpw(password, hash)</code></pre>
            </div>
        </div>
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
                    <i class="fas fa-share-alt"></i> Share BCrypt Hash
                </h5>
                <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="alert alert-info mb-3">
                    <strong><i class="fas fa-shield-alt"></i> What's Being Shared:</strong>
                    <ul class="mb-0 mt-2">
                        <li><strong>BCrypt Hash:</strong> The generated password hash</li>
                        <li><strong>Cost Factor:</strong> The work factor used</li>
                        <li><strong class="text-success">NOT Included:</strong> Your original password (kept secure)</li>
                    </ul>
                </div>
                <div class="alert alert-warning mb-3">
                    <strong><i class="fas fa-info-circle"></i> Security Note:</strong>
                    <p class="mb-0">BCrypt hashes are designed to be shared safely. The recipient can use this URL to verify if they know the correct password.</p>
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
    var lastHash = '';
    var lastPassword = '';
    var lastCost = 10;

    $(document).ready(function() {
        // Check for URL parameters on page load
        loadFromUrl();

        // Cost factor selection styling
        $('.cost-btn').click(function() {
            $('.cost-btn').removeClass('active');
            $(this).addClass('active');
        });

        // Generate form submission
        $('#bcryptForm').submit(function(event) {
            event.preventDefault();
            if (!$('#password').val()) {
                showToast('Please enter a password');
                return;
            }

            $('#generateBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Hashing...');

            $.ajax({
                type: "POST",
                url: "BCCryptFunctionality",
                data: $(this).serialize(),
                dataType: "json",
                success: function(response) {
                    if (!response.success) {
                        showToast(response.errorMessage || 'Error generating hash');
                        $('#generateBtn').prop('disabled', false).html('<i class="fas fa-cogs me-2"></i>Generate BCrypt Hash');
                        return;
                    }

                    lastHash = response.hash;
                    lastPassword = $('#password').val();
                    lastCost = response.costFactor || 10;

                    var html = renderBcryptResult(response);
                    $('#resultPlaceholder').hide();
                    $('#resultContent').html(html).show();
                    $('#copyBtn').show();
                    $('#generateBtn').prop('disabled', false).html('<i class="fas fa-cogs me-2"></i>Generate BCrypt Hash');
                },
                error: function() {
                    showToast('Error generating hash');
                    $('#generateBtn').prop('disabled', false).html('<i class="fas fa-cogs me-2"></i>Generate BCrypt Hash');
                }
            });
        });

        // Verify form submission
        $('#verifyForm').submit(function(event) {
            event.preventDefault();
            if (!$('#verifyPassword').val() || !$('#verifyHash').val().trim()) {
                showToast('Please enter password and hash');
                return;
            }

            $('#verifyBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Verifying...');

            $.ajax({
                type: "POST",
                url: "BCCryptFunctionality",
                data: $(this).serialize(),
                dataType: "json",
                success: function(response) {
                    var html = renderBcryptResult(response);
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

    function renderBcryptResult(response) {
        var html = '';

        if (!response.success) {
            html = '<div class="alert alert-danger">';
            html += '<i class="fas fa-exclamation-circle me-2"></i>';
            html += response.errorMessage || 'Error processing request';
            html += '</div>';
            return html;
        }

        // Show verification result if present
        if (response.verified !== null && response.verified !== undefined) {
            var alertClass = response.verified ? 'alert-success' : 'alert-danger';
            var icon = response.verified ? 'fa-check-circle' : 'fa-times-circle';
            html += '<div class="alert ' + alertClass + ' mb-3">';
            html += '<i class="fas ' + icon + ' me-2"></i>';
            html += '<strong>' + (response.verified ? 'Verified!' : 'Failed!') + '</strong> ';
            html += response.verificationMessage || '';
            html += '</div>';
        }

        // Show generated hash
        if (response.hash) {
            html += '<div class="mb-3">';
            html += '<label class="small text-muted mb-1">BCrypt Hash</label>';
            html += '<div class="position-relative">';
            html += '<textarea class="form-control font-monospace" rows="2" readonly style="font-size: 0.8rem; background: #f8fafc;">' + escapeHtml(response.hash) + '</textarea>';
            html += '<button class="btn btn-sm btn-outline-secondary position-absolute" style="top: 5px; right: 5px;" onclick="copyHash()">';
            html += '<i class="fas fa-copy"></i></button>';
            html += '</div>';
            html += '</div>';

            // Action buttons
            html += '<div class="d-flex gap-2 mb-3">';
            html += '<button class="btn btn-sm btn-outline-primary" onclick="useForVerify()">';
            html += '<i class="fas fa-check-circle me-1"></i>Use for Verify</button>';
            html += '<button class="btn btn-sm btn-outline-secondary" onclick="shareUrl()">';
            html += '<i class="fas fa-share-alt me-1"></i>Share URL</button>';
            html += '</div>';

            // Hash breakdown
            if (response.prefix || response.salt || response.hashValue) {
                html += '<div class="hash-anatomy p-3 mb-3">';
                if (response.prefix) {
                    html += '<span class="prefix">' + escapeHtml(response.prefix) + '</span>';
                }
                if (response.costFactor) {
                    html += '<span class="cost">' + response.costFactor + '</span>$';
                }
                if (response.salt) {
                    html += '<span class="salt">' + escapeHtml(response.salt) + '</span>';
                }
                if (response.hashValue) {
                    html += '<span class="hash">' + escapeHtml(response.hashValue) + '</span>';
                }
                html += '</div>';

                // Component breakdown
                html += '<div class="row small">';
                html += '<div class="col-6 mb-2">';
                html += '<span class="badge" style="background: #569cd6;">Version</span> ';
                html += '<code>' + escapeHtml(response.prefix || 'N/A') + '</code>';
                html += '</div>';
                html += '<div class="col-6 mb-2">';
                html += '<span class="badge" style="background: #4ec9b0;">Cost</span> ';
                html += '<code>' + (response.costFactor || 'N/A') + '</code> (2<sup>' + (response.costFactor || '?') + '</sup> = ' + Math.pow(2, response.costFactor || 0).toLocaleString() + ' rounds)';
                html += '</div>';
                html += '<div class="col-6 mb-2">';
                html += '<span class="badge" style="background: #ce9178;">Salt</span> ';
                html += '<code>' + (response.salt ? response.salt.length + ' chars' : 'N/A') + '</code>';
                html += '</div>';
                html += '<div class="col-6 mb-2">';
                html += '<span class="badge" style="background: #dcdcaa; color: #333;">Hash</span> ';
                html += '<code>' + (response.hashValue ? response.hashValue.length + ' chars' : 'N/A') + '</code>';
                html += '</div>';
                html += '</div>';
            }
        }

        return html;
    }

    function escapeHtml(text) {
        if (!text) return '';
        var div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    function copyHash() {
        navigator.clipboard.writeText(lastHash).then(function() {
            showToast('Hash copied to clipboard!');
        });
    }

    function togglePassword(inputId, iconId) {
        var input = $('#' + inputId);
        var icon = $('#' + iconId);
        if (input.attr('type') === 'password') {
            input.attr('type', 'text');
            icon.removeClass('fa-eye').addClass('fa-eye-slash');
        } else {
            input.attr('type', 'password');
            icon.removeClass('fa-eye-slash').addClass('fa-eye');
        }
    }

    function copyResult() {
        navigator.clipboard.writeText(lastHash).then(function() {
            showToast('Hash copied!');
        });
    }

    function showToast(message) {
        var toast = $('<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999;">' +
            '<div class="toast show"><div class="toast-body text-white rounded" style="background: var(--theme-gradient);">' +
            '<i class="fas fa-info-circle me-2"></i>' + message + '</div></div></div>');
        $('body').append(toast);
        setTimeout(function() { toast.fadeOut(function() { toast.remove(); }); }, 2000);
    }

    function useForVerify() {
        if (!lastHash) {
            showToast('Generate a hash first');
            return;
        }
        $('#verifyPassword').val(lastPassword);
        $('#verifyHash').val(lastHash);
        // Scroll to verify section
        $('html, body').animate({
            scrollTop: $('#verifyForm').offset().top - 100
        }, 300);
        showToast('Hash copied to verify form');
    }

    function shareUrl() {
        if (!lastHash) {
            showToast('Generate a hash first');
            return;
        }
        var params = new URLSearchParams();
        params.set('hash', lastHash);
        params.set('cost', lastCost);
        var url = window.location.origin + window.location.pathname + '?' + params.toString();

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
        var cost = params.get('cost');

        if (hash) {
            $('#verifyHash').val(hash);
            showToast('Hash loaded from URL - enter password to verify');
        }
        if (cost) {
            // Select the matching cost button
            $('.cost-btn').removeClass('active');
            $('.cost-btn input[value="' + cost + '"]').parent().addClass('active');
            $('.cost-btn input[value="' + cost + '"]').prop('checked', true);
        }
    }
</script>

<%@ include file="body-close.jsp"%>
