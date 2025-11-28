<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Argon2 Hash Generator & Verifier Online – Free | 8gwifi.org</title>
    <meta name="description" content="Generate and verify Argon2 password hashes online. PHC winner supporting Argon2i, Argon2d, and Argon2id variants. Configurable memory, time, and parallelism parameters." />
    <meta name="keywords" content="argon2 online, argon2 hash generator, argon2id, argon2i, argon2d, password hashing, PHC winner, memory-hard hashing" />
    <meta name="robots" content="index,follow" />
    <meta name="author" content="Anish Nath" />
    <link rel="canonical" href="https://8gwifi.org/argon2.jsp" />

    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "WebApplication",
            "name": "Argon2 Hash Generator",
            "description": "Generate and verify Argon2 password hashes with configurable parameters. PHC 2015 winner.",
            "url": "https://8gwifi.org/argon2.jsp",
            "applicationCategory": "SecurityApplication",
            "operatingSystem": "Any",
            "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
            "author": {"@type": "Person", "name": "Anish Nath", "url": "https://x.com/anish2good"},
            "datePublished": "2024-01-15",
            "dateModified": "2025-01-28"
        }
    </script>

    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "FAQPage",
            "mainEntity": [
                {
                    "@type": "Question",
                    "name": "What is Argon2?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "Argon2 is a key derivation function that won the Password Hashing Competition (PHC) in 2015. It's designed to be resistant to GPU, ASIC, and side-channel attacks, making it the most secure password hashing algorithm available."
                    }
                },
                {
                    "@type": "Question",
                    "name": "Which Argon2 variant should I use?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "Argon2id is recommended for most use cases as it combines the benefits of Argon2d (GPU resistance) and Argon2i (side-channel resistance). Use Argon2d for cryptocurrency applications or Argon2i for strict side-channel requirements."
                    }
                },
                {
                    "@type": "Question",
                    "name": "What parameters should I use for Argon2?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "For most applications: memory=64MB, iterations=3, parallelism=4. For interactive logins: memory=4MB. For sensitive data: memory=256MB, iterations=5. Adjust based on your security requirements and hardware."
                    }
                }
            ]
        }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        :root {
            --theme-primary: #667eea;
            --theme-secondary: #764ba2;
            --theme-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --theme-light: #f0f0ff;
        }
        .tool-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(102, 126, 234, 0.15);
            transition: box-shadow 0.3s ease;
        }
        .tool-card:hover {
            box-shadow: 0 4px 20px rgba(102, 126, 234, 0.25);
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
        .variant-btn {
            flex: 1;
            padding: 0.5rem;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            background: white;
            cursor: pointer;
            transition: all 0.2s;
            text-align: center;
        }
        .variant-btn:hover {
            border-color: var(--theme-primary);
        }
        .variant-btn.active {
            background: var(--theme-gradient);
            color: white;
            border-color: var(--theme-primary);
        }
        .variant-btn strong {
            display: block;
            font-size: 0.85rem;
        }
        .variant-btn small {
            font-size: 0.7rem;
            opacity: 0.8;
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
        .param-slider {
            margin-bottom: 0.75rem;
        }
        .param-slider label {
            display: flex;
            justify-content: space-between;
            font-size: 0.8rem;
            margin-bottom: 0.25rem;
        }
        .param-slider .value {
            color: var(--theme-primary);
            font-weight: 700;
        }
        .param-slider input[type="range"] {
            width: 100%;
            height: 6px;
            border-radius: 3px;
            background: #e9ecef;
            outline: none;
            -webkit-appearance: none;
        }
        .param-slider input[type="range"]::-webkit-slider-thumb {
            -webkit-appearance: none;
            width: 16px;
            height: 16px;
            border-radius: 50%;
            background: var(--theme-gradient);
            cursor: pointer;
        }
        .hash-output {
            background: #f8f9fa;
            border: 2px solid var(--theme-primary);
            border-radius: 8px;
            padding: 0.75rem;
            font-family: monospace;
            font-size: 0.75rem;
            word-break: break-all;
            position: relative;
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
            box-shadow: 0 2px 8px rgba(102, 126, 234, 0.2);
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
        <h1 class="h4 mb-0">Argon2 Hash Generator</h1>
        <div class="mt-1">
            <span class="info-badge"><i class="fas fa-trophy"></i> PHC Winner</span>
            <span class="info-badge"><i class="fas fa-memory"></i> Memory-Hard</span>
            <span class="info-badge"><i class="fas fa-shield-alt"></i> Side-Channel Safe</span>
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
                <h5><i class="fas fa-hashtag me-2"></i>Generate Argon2 Hash</h5>
            </div>
            <div class="card-body">
                <!-- Variant Selection -->
                <div class="form-section">
                    <div class="form-section-title"><i class="fas fa-code-branch me-1"></i>Algorithm Variant</div>
                    <div class="d-flex gap-2">
                        <button class="variant-btn" onclick="selectVariant(0)" id="variantBtn0">
                            <strong>Argon2d</strong>
                            <small>GPU Resistant</small>
                        </button>
                        <button class="variant-btn" onclick="selectVariant(1)" id="variantBtn1">
                            <strong>Argon2i</strong>
                            <small>Side-Channel Safe</small>
                        </button>
                        <button class="variant-btn active" onclick="selectVariant(2)" id="variantBtn2">
                            <strong>Argon2id</strong>
                            <small>Recommended</small>
                        </button>
                    </div>
                </div>

                <!-- Password Input -->
                <div class="form-section">
                    <div class="form-section-title"><i class="fas fa-key me-1"></i>Password</div>
                    <div class="input-group">
                        <input type="password" class="form-control" id="password" placeholder="Enter password to hash" required>
                        <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('password', 'toggleIcon1')">
                            <i class="fas fa-eye" id="toggleIcon1"></i>
                        </button>
                    </div>
                </div>

                <!-- Salt -->
                <div class="form-section">
                    <div class="form-section-title"><i class="fas fa-random me-1"></i>Salt</div>
                    <div class="input-group">
                        <input type="text" class="form-control" id="salt" placeholder="Leave empty for random salt">
                        <button class="btn btn-outline-secondary" type="button" onclick="generateSalt()">
                            <i class="fas fa-sync-alt"></i>
                        </button>
                    </div>
                    <small class="text-muted">Random 16-byte salt generated if empty</small>
                </div>

                <!-- Presets -->
                <div class="form-section">
                    <div class="form-section-title"><i class="fas fa-sliders-h me-1"></i>Security Presets</div>
                    <div class="d-flex gap-2 flex-wrap">
                        <button class="preset-btn" onclick="applyPreset('interactive')">
                            <i class="fas fa-bolt"></i> Interactive
                        </button>
                        <button class="preset-btn" onclick="applyPreset('moderate')">
                            <i class="fas fa-balance-scale"></i> Moderate
                        </button>
                        <button class="preset-btn" onclick="applyPreset('sensitive')">
                            <i class="fas fa-shield-alt"></i> Sensitive
                        </button>
                    </div>
                </div>

                <!-- Parameters -->
                <div class="form-section">
                    <div class="form-section-title"><i class="fas fa-cog me-1"></i>Parameters</div>

                    <div class="param-slider">
                        <label>
                            <span>Memory Cost (KB)</span>
                            <span class="value" id="memoryValue">65536</span>
                        </label>
                        <input type="range" id="memorySlider" min="4096" max="262144" step="4096" value="65536" oninput="updateParam('memory')">
                        <small class="text-muted">64 MB default</small>
                    </div>

                    <div class="param-slider">
                        <label>
                            <span>Time Cost (Iterations)</span>
                            <span class="value" id="timeValue">3</span>
                        </label>
                        <input type="range" id="timeSlider" min="1" max="10" step="1" value="3" oninput="updateParam('time')">
                    </div>

                    <div class="param-slider">
                        <label>
                            <span>Parallelism</span>
                            <span class="value" id="parallelValue">4</span>
                        </label>
                        <input type="range" id="parallelSlider" min="1" max="8" step="1" value="4" oninput="updateParam('parallel')">
                    </div>

                    <div class="param-slider">
                        <label>
                            <span>Hash Length (bytes)</span>
                            <span class="value" id="hashLenValue">32</span>
                        </label>
                        <input type="range" id="hashLenSlider" min="16" max="64" step="4" value="32" oninput="updateParam('hashLen')">
                    </div>
                </div>

                <button type="button" class="btn w-100" id="generateBtn" onclick="generateHash()" style="background: var(--theme-gradient); color: white; font-weight: 600;">
                    <i class="fas fa-cogs me-2"></i>Generate Argon2 Hash
                </button>

                <hr class="my-3">

                <!-- Verify Hash -->
                <div class="form-section">
                    <div class="form-section-title"><i class="fas fa-check-circle me-1"></i>Verify Hash</div>
                    <input type="password" class="form-control mb-2" id="verifyPassword" placeholder="Password to verify">
                    <input type="text" class="form-control font-monospace" id="verifyHash" placeholder="$argon2id$v=19$m=65536,t=3,p=4$..." style="font-size: 0.75rem;">
                </div>
                <button type="button" class="btn btn-outline-primary w-100" id="verifyBtn" onclick="verifyPassword()">
                    <i class="fas fa-check me-2"></i>Verify Hash
                </button>
            </div>
        </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-7 mb-4">
        <div class="card tool-card result-card">
            <div class="card-header card-header-custom d-flex justify-content-between align-items-center">
                <h5 class="mb-0"><i class="fas fa-fingerprint me-2"></i>Argon2 Hash Output</h5>
                <button class="btn btn-sm btn-light" onclick="copyResult()" id="copyBtn" style="display: none;">
                    <i class="fas fa-copy"></i>
                </button>
            </div>
            <div class="card-body">
                <div class="result-placeholder" id="resultPlaceholder">
                    <div class="text-center">
                        <i class="fas fa-shield-alt fa-3x mb-3 text-muted"></i>
                        <p class="mb-0">Argon2 hash will appear here</p>
                        <small class="text-muted">Enter a password and click Generate</small>
                    </div>
                </div>
                <div class="result-content" id="resultContent"></div>
            </div>
        </div>

        <!-- Parameter Guide -->
        <div class="card tool-card mt-3">
            <div class="card-header bg-dark text-white py-2">
                <h6 class="mb-0"><i class="fas fa-book me-2"></i>Recommended Parameters</h6>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-sm table-bordered mb-0">
                        <thead class="table-light">
                        <tr>
                            <th>Use Case</th>
                            <th>Memory</th>
                            <th>Time</th>
                            <th>Parallel</th>
                        </tr>
                        </thead>
                        <tbody class="small">
                        <tr>
                            <td>Interactive login</td>
                            <td>4 MB</td>
                            <td>3</td>
                            <td>1</td>
                        </tr>
                        <tr class="table-primary">
                            <td><strong>Moderate (Default)</strong></td>
                            <td><strong>64 MB</strong></td>
                            <td><strong>3</strong></td>
                            <td><strong>4</strong></td>
                        </tr>
                        <tr>
                            <td>Sensitive data</td>
                            <td>256 MB</td>
                            <td>5</td>
                            <td>4</td>
                        </tr>
                        </tbody>
                    </table>
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
                <p>Blowfish-based password hashing</p>
            </a>
            <a href="scrypt.jsp" class="related-tool-card">
                <h6><i class="fas fa-memory me-1"></i>Scrypt</h6>
                <p>Memory-hard key derivation</p>
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
        <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding Argon2</h5>
    </div>
    <div class="card-body">
        <h6>What is Argon2?</h6>
        <p>Argon2 is a password hashing algorithm that won the Password Hashing Competition (PHC) in 2015. Designed by Alex Biryukov, Daniel Dinu, and Dmitry Khovratovich, it's specifically built to resist GPU, ASIC, and side-channel attacks.</p>

        <h6 class="mt-4">Algorithm Variants</h6>
        <div class="row">
            <div class="col-md-4 mb-3">
                <div class="p-3 rounded h-100" style="background: #fff3cd; border: 2px solid #ffc107;">
                    <h6 class="text-center" style="color: #856404;"><strong>Argon2d</strong></h6>
                    <p class="small mb-0">Data-dependent memory access. Maximum GPU resistance but vulnerable to side-channel attacks. Best for cryptocurrencies and backend applications.</p>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="p-3 rounded h-100" style="background: #d1ecf1; border: 2px solid #17a2b8;">
                    <h6 class="text-center" style="color: #0c5460;"><strong>Argon2i</strong></h6>
                    <p class="small mb-0">Data-independent memory access. Resistant to side-channel attacks but less GPU resistant. Good for key derivation.</p>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="p-3 rounded h-100" style="background: #d4edda; border: 2px solid #28a745;">
                    <h6 class="text-center" style="color: #155724;"><strong>Argon2id</strong> <span class="badge bg-success">Recommended</span></h6>
                    <p class="small mb-0">Hybrid approach combining both. First pass uses Argon2i, subsequent passes use Argon2d. Best for password hashing.</p>
                </div>
            </div>
        </div>

        <h6 class="mt-4">Parameter Guidelines</h6>
        <div class="alert alert-info small">
            <strong>Memory (m):</strong> Higher = more secure but slower. Start with 64MB.<br>
            <strong>Time (t):</strong> Number of iterations. 3 is a good default.<br>
            <strong>Parallelism (p):</strong> Number of threads. Match your CPU cores.<br>
            <strong>Hash Length:</strong> 32 bytes (256 bits) is standard.
        </div>

        <h6 class="mt-4">Argon2 vs Other Algorithms</h6>
        <div class="table-responsive">
            <table class="table table-sm table-bordered">
                <thead class="table-light">
                <tr>
                    <th>Algorithm</th>
                    <th>Memory-Hard</th>
                    <th>GPU Resistant</th>
                    <th>Side-Channel Safe</th>
                    <th>Recommendation</th>
                </tr>
                </thead>
                <tbody class="small">
                <tr class="table-success">
                    <td><strong>Argon2id</strong></td>
                    <td><span class="badge bg-success">Yes</span></td>
                    <td><span class="badge bg-success">High</span></td>
                    <td><span class="badge bg-success">Yes</span></td>
                    <td><strong>Best choice for new applications</strong></td>
                </tr>
                <tr>
                    <td>Scrypt</td>
                    <td><span class="badge bg-success">Yes</span></td>
                    <td><span class="badge bg-success">High</span></td>
                    <td><span class="badge bg-warning text-dark">Partial</span></td>
                    <td>Good alternative, proven in production</td>
                </tr>
                <tr>
                    <td>BCrypt</td>
                    <td><span class="badge bg-warning text-dark">Limited</span></td>
                    <td><span class="badge bg-warning text-dark">Medium</span></td>
                    <td><span class="badge bg-success">Yes</span></td>
                    <td>Still widely used, fixed 4KB memory</td>
                </tr>
                <tr>
                    <td>PBKDF2</td>
                    <td><span class="badge bg-danger">No</span></td>
                    <td><span class="badge bg-danger">Low</span></td>
                    <td><span class="badge bg-success">Yes</span></td>
                    <td>Legacy, avoid for new applications</td>
                </tr>
                </tbody>
            </table>
        </div>

        <h6 class="mt-4">Code Examples</h6>
        <div class="row">
            <div class="col-md-6">
                <p class="small mb-1"><strong>Python (argon2-cffi)</strong></p>
                <pre class="bg-dark text-light p-2 rounded small"><code>from argon2 import PasswordHasher
ph = PasswordHasher()
hash = ph.hash("password")
ph.verify(hash, "password")</code></pre>
            </div>
            <div class="col-md-6">
                <p class="small mb-1"><strong>Node.js (argon2)</strong></p>
                <pre class="bg-dark text-light p-2 rounded small"><code>const argon2 = require('argon2');
const hash = await argon2.hash("password");
const valid = await argon2.verify(hash, "password");</code></pre>
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
                    <i class="fas fa-share-alt"></i> Share Argon2 Hash
                </h5>
                <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="alert alert-info mb-3">
                    <strong><i class="fas fa-shield-alt"></i> What's Being Shared:</strong>
                    <ul class="mb-0 mt-2">
                        <li><strong>Argon2 Hash:</strong> The encoded hash string</li>
                        <li><strong>Variant:</strong> <span id="shareVariant">-</span></li>
                        <li><strong>Parameters:</strong> Embedded in hash string</li>
                        <li><strong class="text-success">NOT Included:</strong> Your original password (kept secure)</li>
                    </ul>
                </div>
                <div class="alert alert-warning mb-3">
                    <strong><i class="fas fa-info-circle"></i> Security Note:</strong>
                    <p class="mb-0">Argon2 hashes are safe to share. The recipient can verify if they know the correct password. Your password is <strong>never</strong> included in the URL.</p>
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

<!-- Load argon2-browser library -->
<script src="https://cdn.jsdelivr.net/npm/argon2-browser@1.18.0/dist/argon2-bundled.min.js"></script>

<script>
    var currentVariant = 2; // Default to Argon2id
    var lastEncodedHash = '';
    var lastPassword = '';

    $(document).ready(function() {
        loadFromUrl();

        // Copy Share URL handler
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
    });

    function selectVariant(variant) {
        currentVariant = variant;
        $('.variant-btn').removeClass('active');
        $('#variantBtn' + variant).addClass('active');
    }

    function updateParam(param) {
        var value = $('#' + param + 'Slider').val();
        $('#' + param + 'Value').text(value);
    }

    function generateSalt() {
        var array = new Uint8Array(16);
        crypto.getRandomValues(array);
        var salt = Array.from(array, function(byte) {
            return ('0' + byte.toString(16)).slice(-2);
        }).join('');
        $('#salt').val(salt);
    }

    function applyPreset(preset) {
        var presets = {
            'interactive': { memory: 4096, time: 3, parallel: 1 },
            'moderate': { memory: 65536, time: 3, parallel: 4 },
            'sensitive': { memory: 262144, time: 5, parallel: 4 }
        };
        var config = presets[preset];
        $('#memorySlider').val(config.memory);
        $('#timeSlider').val(config.time);
        $('#parallelSlider').val(config.parallel);
        $('#memoryValue').text(config.memory);
        $('#timeValue').text(config.time);
        $('#parallelValue').text(config.parallel);
        showToast('Applied ' + preset + ' preset');
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

    async function generateHash() {
        if (typeof argon2 === 'undefined') {
            showToast('Argon2 library loading, please wait...');
            return;
        }

        var password = $('#password').val();
        if (!password) {
            showToast('Please enter a password');
            return;
        }

        var salt = $('#salt').val().trim();
        if (!salt) {
            generateSalt();
            salt = $('#salt').val();
        }

        var memory = parseInt($('#memorySlider').val());
        var time = parseInt($('#timeSlider').val());
        var parallel = parseInt($('#parallelSlider').val());
        var hashLen = parseInt($('#hashLenSlider').val());

        $('#generateBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Computing...');

        try {
            var startTime = performance.now();
            var result = await argon2.hash({
                pass: password,
                salt: new TextEncoder().encode(salt),
                time: time,
                mem: memory,
                parallelism: parallel,
                hashLen: hashLen,
                type: currentVariant
            });
            var duration = (performance.now() - startTime).toFixed(0);

            lastEncodedHash = result.encoded;
            lastPassword = password;

            var variantNames = ['Argon2d', 'Argon2i', 'Argon2id'];
            var html = renderHashResult(result, variantNames[currentVariant], duration, memory, time, parallel);

            $('#resultPlaceholder').hide();
            $('#resultContent').html(html).show();
            $('#copyBtn').show();

        } catch (error) {
            var html = '<div class="alert alert-danger">';
            html += '<i class="fas fa-exclamation-circle me-2"></i>';
            html += '<strong>Error:</strong> ' + error.message;
            html += '</div>';
            $('#resultPlaceholder').hide();
            $('#resultContent').html(html).show();
        }

        $('#generateBtn').prop('disabled', false).html('<i class="fas fa-cogs me-2"></i>Generate Argon2 Hash');
    }

    function renderHashResult(result, variant, duration, memory, time, parallel) {
        var html = '';

        // Success banner
        html += '<div class="alert alert-success mb-3">';
        html += '<i class="fas fa-check-circle me-2"></i>';
        html += '<strong>Hash Generated!</strong> Computed in ' + duration + 'ms';
        html += '</div>';

        // Encoded hash
        html += '<div class="mb-3">';
        html += '<label class="small text-muted mb-1">Encoded Hash (for storage)</label>';
        html += '<div class="hash-output">';
        html += '<span id="encodedHash">' + escapeHtml(result.encoded) + '</span>';
        html += '<button class="btn btn-sm btn-outline-secondary position-absolute" style="top: 5px; right: 5px;" onclick="copyHash(\'encoded\')">';
        html += '<i class="fas fa-copy"></i></button>';
        html += '</div>';
        html += '</div>';

        // Raw hash
        html += '<div class="mb-3">';
        html += '<label class="small text-muted mb-1">Raw Hash (hex)</label>';
        html += '<div class="hash-output">';
        html += '<span id="rawHash">' + result.hashHex + '</span>';
        html += '<button class="btn btn-sm btn-outline-secondary position-absolute" style="top: 5px; right: 5px;" onclick="copyHash(\'raw\')">';
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
        html += '<div class="row small">';
        html += '<div class="col-6 mb-2">';
        html += '<span class="badge" style="background: var(--theme-gradient);">' + variant + '</span>';
        html += '</div>';
        html += '<div class="col-6 mb-2">';
        html += '<strong>Memory:</strong> ' + (memory / 1024).toFixed(0) + ' MB';
        html += '</div>';
        html += '<div class="col-6 mb-2">';
        html += '<strong>Time:</strong> ' + time + ' iterations';
        html += '</div>';
        html += '<div class="col-6 mb-2">';
        html += '<strong>Parallelism:</strong> ' + parallel + ' threads';
        html += '</div>';
        html += '</div>';

        return html;
    }

    async function verifyPassword() {
        if (typeof argon2 === 'undefined') {
            showToast('Argon2 library loading, please wait...');
            return;
        }

        var password = $('#verifyPassword').val();
        var hash = $('#verifyHash').val().trim();

        if (!password || !hash) {
            showToast('Please enter password and hash');
            return;
        }

        if (!hash.startsWith('$argon2')) {
            showToast('Invalid Argon2 hash format');
            return;
        }

        $('#verifyBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Verifying...');

        try {
            var startTime = performance.now();
            await argon2.verify({ pass: password, encoded: hash });
            var duration = (performance.now() - startTime).toFixed(0);

            var html = '<div class="alert alert-success">';
            html += '<i class="fas fa-check-circle me-2"></i>';
            html += '<strong>Verified!</strong> Password matches the hash.';
            html += '<br><small class="text-muted">Verified in ' + duration + 'ms</small>';
            html += '</div>';

            $('#resultPlaceholder').hide();
            $('#resultContent').html(html).show();

        } catch (error) {
            var html = '<div class="alert alert-danger">';
            html += '<i class="fas fa-times-circle me-2"></i>';
            html += '<strong>Failed!</strong> Password does not match the hash.';
            html += '</div>';

            $('#resultPlaceholder').hide();
            $('#resultContent').html(html).show();
        }

        $('#verifyBtn').prop('disabled', false).html('<i class="fas fa-check me-2"></i>Verify Hash');
    }

    function useForVerify() {
        if (!lastEncodedHash) {
            showToast('Generate a hash first');
            return;
        }
        $('#verifyPassword').val(lastPassword);
        $('#verifyHash').val(lastEncodedHash);
        $('html, body').animate({
            scrollTop: $('#verifyBtn').offset().top - 100
        }, 300);
        showToast('Hash copied to verify form');
    }

    function shareUrl() {
        if (!lastEncodedHash) {
            showToast('Generate a hash first');
            return;
        }

        var variantNames = ['Argon2d', 'Argon2i', 'Argon2id'];
        var params = new URLSearchParams();
        params.set('hash', lastEncodedHash);
        var url = window.location.origin + window.location.pathname + '?' + params.toString();

        $('#shareVariant').text(variantNames[currentVariant]);
        $('#shareUrlText').val(url);
        $('#shareUrlModal').modal('show');
    }

    function copyHash(type) {
        var text = type === 'encoded' ? lastEncodedHash : $('#rawHash').text();
        navigator.clipboard.writeText(text).then(function() {
            showToast('Hash copied to clipboard!');
        });
    }

    function copyResult() {
        navigator.clipboard.writeText(lastEncodedHash).then(function() {
            showToast('Hash copied!');
        });
    }

    function escapeHtml(text) {
        if (!text) return '';
        var div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    function loadFromUrl() {
        var params = new URLSearchParams(window.location.search);
        var hash = params.get('hash');

        if (hash) {
            $('#verifyHash').val(hash);
            showToast('Hash loaded from URL - enter password to verify');
            setTimeout(function() {
                $('html, body').animate({
                    scrollTop: $('#verifyBtn').offset().top - 100
                }, 300);
            }, 500);
        }
    }

    function showToast(message) {
        var toast = $('<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999;">' +
            '<div class="toast show"><div class="toast-body text-white rounded" style="background: var(--theme-gradient);">' +
            '<i class="fas fa-info-circle me-2"></i>' + message + '</div></div></div>');
        $('body').append(toast);
        setTimeout(function() { toast.fadeOut(function() { toast.remove(); }); }, 2000);
    }
</script>

<%@ include file="body-close.jsp"%>
