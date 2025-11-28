<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Scrypt Hash Generator & Verifier Online – Free | 8gwifi.org</title>
    <meta name="description" content="Generate and verify Scrypt password hashes online. Memory-hard key derivation function designed to be resistant to GPU and ASIC attacks. Configurable N, r, p parameters." />
    <meta name="keywords" content="scrypt online, scrypt hash generator, scrypt password hash, memory-hard hashing, scrypt N r p, password hashing, key derivation" />
    <meta name="robots" content="index,follow" />
    <meta name="author" content="Anish Nath" />
    <link rel="canonical" href="https://8gwifi.org/scrypt.jsp" />

    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "WebApplication",
            "name": "Scrypt Hash Generator",
            "description": "Generate and verify Scrypt password hashes with configurable N, r, p parameters.",
            "url": "https://8gwifi.org/scrypt.jsp",
            "applicationCategory": "SecurityApplication",
            "operatingSystem": "Any",
            "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
            "author": {"@type": "Person", "name": "Anish Nath", "url": "https://x.com/anish2good"},
            "datePublished": "2018-02-22",
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
                    "name": "What is Scrypt?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "Scrypt is a memory-hard key derivation function designed by Colin Percival in 2009. It's designed to require large amounts of memory, making it resistant to GPU and ASIC-based attacks that plague SHA-based hashing."
                    }
                },
                {
                    "@type": "Question",
                    "name": "What do N, r, and p parameters mean in Scrypt?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "N (CPU/memory cost) must be a power of 2. r (block size) affects memory usage. p (parallelization) allows parallel computation. Memory usage is approximately 128 * N * r bytes."
                    }
                },
                {
                    "@type": "Question",
                    "name": "What are recommended Scrypt parameters?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "For interactive logins in 2024: N=16384 (2^14), r=8, p=1 requiring ~16MB memory. For high-security: N=1048576 (2^20), r=8, p=1 requiring ~1GB memory."
                    }
                }
            ]
        }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        :root {
            --theme-primary: #0891b2;
            --theme-secondary: #06b6d4;
            --theme-gradient: linear-gradient(135deg, #0891b2 0%, #06b6d4 50%, #22d3ee 100%);
            --theme-light: #ecfeff;
        }
        .tool-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(8, 145, 178, 0.15);
            transition: box-shadow 0.3s ease;
        }
        .tool-card:hover {
            box-shadow: 0 4px 20px rgba(8, 145, 178, 0.25);
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
        .param-card {
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 0.5rem;
            text-align: center;
            background: white;
        }
        .param-card label {
            font-weight: 700;
            color: var(--theme-primary);
            font-size: 0.9rem;
            display: block;
        }
        .param-card small {
            color: #6c757d;
            font-size: 0.65rem;
        }
        .param-card select {
            text-align: center;
            font-weight: 600;
        }
        .memory-indicator {
            background: var(--theme-light);
            border: 1px solid var(--theme-primary);
            border-radius: 6px;
            padding: 0.5rem;
            text-align: center;
            font-size: 0.85rem;
        }
        .memory-indicator .value {
            font-weight: 700;
            color: var(--theme-primary);
            font-size: 1.1rem;
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
            box-shadow: 0 2px 8px rgba(8, 145, 178, 0.2);
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
        <h1 class="h4 mb-0">Scrypt Hash Generator</h1>
        <div class="mt-1">
            <span class="info-badge"><i class="fas fa-memory"></i> Memory-Hard</span>
            <span class="info-badge"><i class="fas fa-microchip"></i> ASIC Resistant</span>
            <span class="info-badge"><i class="fas fa-sliders-h"></i> Configurable</span>
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
                <h5><i class="fas fa-hashtag me-2"></i>Generate Scrypt Hash</h5>
            </div>
            <div class="card-body">
                <form id="scryptForm">
                    <input type="hidden" name="methodName" value="CALCULATE_SCRYPT">

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

                    <!-- Salt -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-random me-1"></i>Salt</div>
                        <div class="input-group">
                            <input type="text" class="form-control" name="salt" id="salt" value="randomsaltvalue" placeholder="Enter salt">
                            <button class="btn btn-outline-secondary" type="button" onclick="generateSalt()">
                                <i class="fas fa-sync-alt"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Scrypt Parameters -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-sliders-h me-1"></i>Scrypt Parameters</div>
                        <div class="row g-2 mb-2">
                            <div class="col-4">
                                <div class="param-card">
                                    <label>N</label>
                                    <small>CPU/Memory Cost</small>
                                    <select class="form-select form-select-sm mt-1" name="workparam" id="workparam">
                                        <option value="1024">1024 (2<sup>10</sup>)</option>
                                        <option value="2048" selected>2048 (2<sup>11</sup>)</option>
                                        <option value="4096">4096 (2<sup>12</sup>)</option>
                                        <option value="8192">8192 (2<sup>13</sup>)</option>
                                        <option value="16384">16384 (2<sup>14</sup>)</option>
                                        <option value="32768">32768 (2<sup>15</sup>)</option>
                                        <option value="65536">65536 (2<sup>16</sup>)</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-4">
                                <div class="param-card">
                                    <label>r</label>
                                    <small>Block Size</small>
                                    <select class="form-select form-select-sm mt-1" name="memoryparam" id="memoryparam">
                                        <option value="1">1</option>
                                        <option value="4">4</option>
                                        <option value="8" selected>8</option>
                                        <option value="16">16</option>
                                        <option value="32">32</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-4">
                                <div class="param-card">
                                    <label>p</label>
                                    <small>Parallelization</small>
                                    <select class="form-select form-select-sm mt-1" name="parallelizationparam" id="parallelizationparam">
                                        <option value="1" selected>1</option>
                                        <option value="2">2</option>
                                        <option value="4">4</option>
                                        <option value="8">8</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- Memory Calculator -->
                        <div class="memory-indicator">
                            <i class="fas fa-memory me-1"></i>Memory Required: <span class="value" id="memoryRequired">2 MB</span>
                        </div>

                        <!-- Output Length -->
                        <div class="row mt-2">
                            <div class="col-12">
                                <label class="small text-muted">Output Length (bytes)</label>
                                <select class="form-select form-select-sm" name="length" id="length">
                                    <option value="16">16</option>
                                    <option value="32" selected>32</option>
                                    <option value="64">64</option>
                                    <option value="128">128</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn w-100" id="generateBtn" style="background: var(--theme-gradient); color: white; font-weight: 600;">
                        <i class="fas fa-cogs me-2"></i>Generate Scrypt Hash
                    </button>
                </form>

                <hr class="my-3">

                <!-- Verify Hash -->
                <form id="verifyForm">
                    <input type="hidden" name="methodName" value="CALCULATE_SCRYPT">
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-check-circle me-1"></i>Verify Hash</div>
                        <input type="password" class="form-control mb-2" name="password" id="verifyPassword" placeholder="Password">
                        <input type="text" class="form-control mb-2" name="salt" id="verifySalt" placeholder="Salt used">
                        <input type="text" class="form-control font-monospace" name="hash" id="verifyHash" placeholder="Scrypt hash (hex)" style="font-size: 0.75rem;">
                    </div>
                    <button type="submit" class="btn btn-outline-info w-100" id="verifyBtn">
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
                <h5 class="mb-0"><i class="fas fa-fingerprint me-2"></i>Scrypt Hash Output</h5>
                <button class="btn btn-sm btn-light" onclick="copyResult()" id="copyBtn" style="display: none;">
                    <i class="fas fa-copy"></i>
                </button>
            </div>
            <div class="card-body">
                <div class="result-placeholder" id="resultPlaceholder">
                    <div class="text-center">
                        <i class="fas fa-memory fa-3x mb-3 text-muted"></i>
                        <p class="mb-0">Scrypt hash will appear here</p>
                        <small class="text-muted">Enter a password and configure parameters</small>
                    </div>
                </div>
                <div class="result-content" id="resultContent"></div>
            </div>
        </div>

        <!-- Parameter Guide -->
        <div class="card tool-card mt-3">
            <div class="card-header bg-dark text-white py-2">
                <h6 class="mb-0"><i class="fas fa-book me-2"></i>Parameter Guide</h6>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-sm table-bordered mb-0">
                        <thead class="table-light">
                        <tr>
                            <th>Use Case</th>
                            <th>N</th>
                            <th>r</th>
                            <th>p</th>
                            <th>Memory</th>
                        </tr>
                        </thead>
                        <tbody class="small">
                        <tr>
                            <td>Interactive login</td>
                            <td>16384</td>
                            <td>8</td>
                            <td>1</td>
                            <td>~16 MB</td>
                        </tr>
                        <tr class="table-info">
                            <td><strong>Recommended</strong></td>
                            <td><strong>32768</strong></td>
                            <td><strong>8</strong></td>
                            <td><strong>1</strong></td>
                            <td><strong>~32 MB</strong></td>
                        </tr>
                        <tr>
                            <td>Sensitive storage</td>
                            <td>65536</td>
                            <td>8</td>
                            <td>1</td>
                            <td>~64 MB</td>
                        </tr>
                        <tr>
                            <td>High security</td>
                            <td>1048576</td>
                            <td>8</td>
                            <td>1</td>
                            <td>~1 GB</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <small class="text-muted mt-2 d-block">Memory = 128 × N × r bytes</small>
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
                <p>Blowfish-based password hashing</p>
            </a>
            <a href="argon2.jsp" class="related-tool-card">
                <h6><i class="fas fa-shield-alt me-1"></i>Argon2</h6>
                <p>PHC winner, modern hashing</p>
            </a>
            <a href="htpasswd.jsp" class="related-tool-card">
                <h6><i class="fas fa-server me-1"></i>htpasswd</h6>
                <p>Apache/Nginx auth generator</p>
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
        <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding Scrypt</h5>
    </div>
    <div class="card-body">
        <h6>What is Scrypt?</h6>
        <p>Scrypt is a password-based key derivation function created by Colin Percival in 2009 for the Tarsnap backup service. It's designed to be memory-hard, requiring significant RAM to compute, making it resistant to large-scale custom hardware attacks (GPUs, FPGAs, ASICs).</p>

        <h6 class="mt-4">Key Parameters</h6>
        <div class="row">
            <div class="col-md-4 mb-3">
                <div class="p-3 rounded h-100" style="background: #ecfeff; border: 2px solid #0891b2;">
                    <h6 class="text-center" style="color: #0891b2;"><strong>N</strong> - CPU/Memory Cost</h6>
                    <p class="small mb-0">Must be a power of 2. Determines overall memory and CPU usage. Doubling N doubles both time and memory. Primary parameter to increase security.</p>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="p-3 rounded h-100" style="background: #fef3c7; border: 2px solid #f59e0b;">
                    <h6 class="text-center" style="color: #d97706;"><strong>r</strong> - Block Size</h6>
                    <p class="small mb-0">Controls memory read size. Affects memory bandwidth usage. Typical value is 8. Higher values increase memory per-block but may reduce parallelism benefits.</p>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="p-3 rounded h-100" style="background: #f3e8ff; border: 2px solid #9333ea;">
                    <h6 class="text-center" style="color: #7c3aed;"><strong>p</strong> - Parallelization</h6>
                    <p class="small mb-0">Allows parallel computation. Each parallel thread needs N×r memory. Useful for multi-core systems. Usually kept at 1 for password hashing.</p>
                </div>
            </div>
        </div>

        <h6 class="mt-4">Memory Calculation</h6>
        <div class="alert alert-info small">
            <strong>Memory = 128 × N × r bytes</strong><br>
            Example: N=16384, r=8 → 128 × 16384 × 8 = 16,777,216 bytes = <strong>16 MB</strong>
        </div>

        <h6 class="mt-4">Scrypt vs Other Algorithms</h6>
        <div class="table-responsive">
            <table class="table table-sm table-bordered">
                <thead class="table-light">
                <tr>
                    <th>Algorithm</th>
                    <th>Memory-Hard</th>
                    <th>GPU Resistant</th>
                    <th>Configurable</th>
                    <th>Notes</th>
                </tr>
                </thead>
                <tbody class="small">
                <tr>
                    <td><strong>Scrypt</strong></td>
                    <td><span class="badge bg-success">Yes</span></td>
                    <td><span class="badge bg-success">High</span></td>
                    <td><span class="badge bg-success">N, r, p</span></td>
                    <td>Good choice, proven in production (Litecoin, Tarsnap)</td>
                </tr>
                <tr>
                    <td><strong>Argon2</strong></td>
                    <td><span class="badge bg-success">Yes</span></td>
                    <td><span class="badge bg-success">High</span></td>
                    <td><span class="badge bg-success">t, m, p</span></td>
                    <td>PHC winner (2015), recommended for new applications</td>
                </tr>
                <tr>
                    <td><strong>BCrypt</strong></td>
                    <td><span class="badge bg-warning text-dark">Limited</span></td>
                    <td><span class="badge bg-warning text-dark">Medium</span></td>
                    <td><span class="badge bg-warning text-dark">Cost only</span></td>
                    <td>Fixed 4KB memory, still widely used</td>
                </tr>
                <tr>
                    <td><strong>PBKDF2</strong></td>
                    <td><span class="badge bg-danger">No</span></td>
                    <td><span class="badge bg-danger">Low</span></td>
                    <td><span class="badge bg-warning text-dark">Iterations</span></td>
                    <td>NIST recommended but GPU-vulnerable</td>
                </tr>
                </tbody>
            </table>
        </div>

        <h6 class="mt-4">Code Examples</h6>
        <div class="row">
            <div class="col-md-6">
                <p class="small mb-1"><strong>Python</strong></p>
                <pre class="bg-dark text-light p-2 rounded small"><code>import hashlib
dk = hashlib.scrypt(
    password.encode(),
    salt=salt.encode(),
    n=16384, r=8, p=1,
    dklen=32
)</code></pre>
            </div>
            <div class="col-md-6">
                <p class="small mb-1"><strong>Node.js</strong></p>
                <pre class="bg-dark text-light p-2 rounded small"><code>const crypto = require('crypto');
crypto.scrypt(password, salt, 32,
  { N: 16384, r: 8, p: 1 },
  (err, key) => {
    console.log(key.toString('hex'));
  });</code></pre>
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
                    <i class="fas fa-share-alt"></i> Share Scrypt Hash
                </h5>
                <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="alert alert-info mb-3">
                    <strong><i class="fas fa-shield-alt"></i> What's Being Shared:</strong>
                    <ul class="mb-0 mt-2">
                        <li><strong>Scrypt Hash:</strong> The generated password hash</li>
                        <li><strong>Salt:</strong> <span id="shareSalt">-</span></li>
                        <li><strong>Parameters:</strong> N=<span id="shareN">-</span>, r=<span id="shareR">-</span>, p=<span id="shareP">-</span></li>
                        <li><strong>Output Length:</strong> <span id="shareLen">-</span> bytes</li>
                        <li><strong class="text-success">NOT Included:</strong> Your original password (kept secure)</li>
                    </ul>
                </div>
                <div class="alert alert-warning mb-3">
                    <strong><i class="fas fa-info-circle"></i> Security Note:</strong>
                    <p class="mb-0">Scrypt hashes are designed to be shared safely. The recipient needs the same parameters (N, r, p, salt) to verify the password. All parameters are included in this URL.</p>
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
    var lastSalt = '';
    var lastParams = { n: 2048, r: 8, p: 1, len: 32 };

    $(document).ready(function() {
        // Check for URL parameters on page load
        loadFromUrl();

        // Update memory indicator when parameters change
        $('#workparam, #memoryparam').change(updateMemory);
        updateMemory();

        // Generate form submission
        $('#scryptForm').submit(function(event) {
            event.preventDefault();
            if (!$('#password').val()) {
                showToast('Please enter a password');
                return;
            }

            $('#generateBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Computing...');

            $.ajax({
                type: "POST",
                url: "BCCryptFunctionality",
                data: $(this).serialize(),
                dataType: "json",
                success: function(response) {
                    if (!response.success) {
                        showToast(response.errorMessage || 'Error generating hash');
                        $('#generateBtn').prop('disabled', false).html('<i class="fas fa-cogs me-2"></i>Generate Scrypt Hash');
                        return;
                    }

                    // Store values for later use
                    lastHash = response.hash || '';
                    lastPassword = $('#password').val();
                    lastSalt = $('#salt').val();
                    lastParams = {
                        n: response.cpuCost || parseInt($('#workparam').val()),
                        r: response.memoryCost || parseInt($('#memoryparam').val()),
                        p: response.parallelization || parseInt($('#parallelizationparam').val()),
                        len: response.keyLength || parseInt($('#length').val())
                    };

                    var html = renderScryptResult(response);
                    $('#resultPlaceholder').hide();
                    $('#resultContent').html(html).show();
                    $('#copyBtn').show();
                    $('#generateBtn').prop('disabled', false).html('<i class="fas fa-cogs me-2"></i>Generate Scrypt Hash');
                },
                error: function() {
                    showToast('Error generating hash');
                    $('#generateBtn').prop('disabled', false).html('<i class="fas fa-cogs me-2"></i>Generate Scrypt Hash');
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

            // Copy parameters from generate form for verification
            var formData = $(this).serialize();
            formData += '&workparam=' + $('#workparam').val();
            formData += '&memoryparam=' + $('#memoryparam').val();
            formData += '&parallelizationparam=' + $('#parallelizationparam').val();
            formData += '&length=' + $('#length').val();

            $('#verifyBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Verifying...');

            $.ajax({
                type: "POST",
                url: "BCCryptFunctionality",
                data: formData,
                dataType: "json",
                success: function(response) {
                    var html = renderScryptResult(response);
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

    function renderScryptResult(response) {
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
            html += '<label class="small text-muted mb-1">Scrypt Hash (Hex)</label>';
            html += '<div class="position-relative">';
            html += '<textarea class="form-control font-monospace" rows="3" readonly style="font-size: 0.75rem; background: #f8fafc; word-break: break-all;">' + escapeHtml(response.hash) + '</textarea>';
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

            // Parameters used
            html += '<div class="row small mb-3">';
            html += '<div class="col-12 mb-2"><strong>Parameters Used:</strong></div>';

            if (response.cpuCost) {
                html += '<div class="col-4">';
                html += '<span class="badge" style="background: #0891b2;">N</span> ';
                html += '<code>' + response.cpuCost.toLocaleString() + '</code>';
                html += '</div>';
            }
            if (response.memoryCost) {
                html += '<div class="col-4">';
                html += '<span class="badge" style="background: #f59e0b;">r</span> ';
                html += '<code>' + response.memoryCost + '</code>';
                html += '</div>';
            }
            if (response.parallelization) {
                html += '<div class="col-4">';
                html += '<span class="badge" style="background: #9333ea;">p</span> ';
                html += '<code>' + response.parallelization + '</code>';
                html += '</div>';
            }
            html += '</div>';

            // Memory and key length
            html += '<div class="row small">';
            if (response.memoryRequired) {
                html += '<div class="col-6">';
                html += '<i class="fas fa-memory me-1" style="color: #0891b2;"></i>';
                html += '<strong>Memory:</strong> ' + response.memoryRequired;
                html += '</div>';
            }
            if (response.keyLength) {
                html += '<div class="col-6">';
                html += '<i class="fas fa-ruler me-1" style="color: #0891b2;"></i>';
                html += '<strong>Output:</strong> ' + response.keyLength + ' bytes';
                html += '</div>';
            }
            html += '</div>';

            // Salt info
            if (response.scryptSalt) {
                html += '<div class="mt-2 small">';
                html += '<i class="fas fa-random me-1" style="color: #0891b2;"></i>';
                html += '<strong>Salt:</strong> <code>' + escapeHtml(response.scryptSalt) + '</code>';
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

    function updateMemory() {
        var n = parseInt($('#workparam').val());
        var r = parseInt($('#memoryparam').val());
        var memory = (128 * n * r) / (1024 * 1024);
        var unit = 'MB';
        if (memory >= 1024) {
            memory = memory / 1024;
            unit = 'GB';
        }
        $('#memoryRequired').text(memory.toFixed(memory < 10 ? 1 : 0) + ' ' + unit);
    }

    function generateSalt() {
        var chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        var salt = '';
        for (var i = 0; i < 16; i++) {
            salt += chars.charAt(Math.floor(Math.random() * chars.length));
        }
        $('#salt').val(salt);
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
        $('#verifySalt').val(lastSalt);
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
        params.set('salt', lastSalt);
        params.set('n', lastParams.n);
        params.set('r', lastParams.r);
        params.set('p', lastParams.p);
        params.set('len', lastParams.len);
        var url = window.location.origin + window.location.pathname + '?' + params.toString();

        // Update modal content
        $('#shareSalt').text(lastSalt);
        $('#shareN').text(lastParams.n.toLocaleString());
        $('#shareR').text(lastParams.r);
        $('#shareP').text(lastParams.p);
        $('#shareLen').text(lastParams.len);
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
        var salt = params.get('salt');
        var n = params.get('n');
        var r = params.get('r');
        var p = params.get('p');
        var len = params.get('len');

        if (hash) {
            $('#verifyHash').val(hash);
            showToast('Hash loaded from URL - enter password to verify');
        }
        if (salt) {
            $('#salt').val(salt);
            $('#verifySalt').val(salt);
        }
        if (n) {
            $('#workparam').val(n);
        }
        if (r) {
            $('#memoryparam').val(r);
        }
        if (p) {
            $('#parallelizationparam').val(p);
        }
        if (len) {
            $('#length').val(len);
        }
        // Update memory display after loading params
        if (n || r) {
            updateMemory();
        }
    }
</script>

<%@ include file="body-close.jsp"%>
