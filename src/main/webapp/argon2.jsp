<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<div lang="en">
<head>
    <title>Argon2 Password Hash Generator - Secure Password Hashing | 8gwifi.org</title>

    <!-- JSON-LD markup -->
    <script type="application/ld+json">
{
  "@context" : "https://schema.org",
  "@type" : "SoftwareApplication",
  "name" : "Argon2 Password Hash Generator - Secure Password Hashing Tool",
  "alternateName" : "Argon2id Hash Generator Online",
  "description" : "Advanced Argon2 password hash generator supporting Argon2i, Argon2d, and Argon2id variants. Free online tool for secure password hashing with customizable memory cost, time cost, and parallelism parameters. Winner of Password Hashing Competition 2015.",
  "url" : "https://8gwifi.org/argon2.jsp",
  "image" : "https://8gwifi.org/images/argon2.png",
  "screenshot" : "https://8gwifi.org/images/argon2-screenshot.png",
  "applicationCategory" : "SecurityApplication",
  "applicationSubCategory" : "Password Hashing Tool",
  "operatingSystem" : "Any (Web-based)",
  "softwareVersion" : "2.0",
  "datePublished" : "2024-01-15",
  "dateModified" : "2025-01-28",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  },
  "author" : {
    "@type" : "Person",
    "name" : "Anish Nath",
    "url" : "https://8gwifi.org"
  },
  "publisher" : {
    "@type" : "Organization",
    "name" : "8gwifi.org",
    "url" : "https://8gwifi.org",
    "logo": {
      "@type": "ImageObject",
      "url": "https://8gwifi.org/images/logo.png"
    }
  },
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.8",
    "ratingCount": "256",
    "bestRating": "5",
    "worstRating": "1"
  },
  "featureList" : [
    "Argon2d - Data-dependent variant for GPU resistance",
    "Argon2i - Data-independent variant for side-channel resistance",
    "Argon2id - Hybrid variant (recommended)",
    "Adjustable memory cost (1MB to 256MB)",
    "Configurable time cost and parallelism",
    "Random salt generation",
    "Password verification",
    "Security presets (Interactive, Moderate, Sensitive)",
    "Real-time hash computation",
    "Copy to clipboard functionality",
    "No data storage - 100% client-side processing"
  ],
  "browserRequirements" : "Requires JavaScript and HTML5 support",
  "permissions" : "No special permissions required",
  "inLanguage" : "en-US",
  "isAccessibleForFree" : true,
  "keywords" : "argon2, argon2i, argon2d, argon2id, password hash, password hashing, secure hash, phc winner, memory-hard function, key derivation, kdf, password security, bcrypt alternative, scrypt alternative, pbkdf2 alternative"
}
    </script>

    <!-- Additional BreadcrumbList for SEO -->
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
    "name": "Cryptography Tools",
    "item": "https://8gwifi.org/cryptography-tools.jsp"
  },{
    "@type": "ListItem",
    "position": 3,
    "name": "Argon2 Password Hash Generator",
    "item": "https://8gwifi.org/argon2.jsp"
  }]
}
    </script>

    <!-- HowTo Schema for better search visibility -->
    <script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "HowTo",
  "name": "How to Generate Secure Password Hash with Argon2",
  "description": "Step-by-step guide to generate secure password hashes using Argon2 algorithm",
  "totalTime": "PT2M",
  "step": [{
    "@type": "HowToStep",
    "name": "Select Algorithm Variant",
    "text": "Choose between Argon2d (fast, GPU-resistant), Argon2i (side-channel resistant), or Argon2id (hybrid, recommended)",
    "position": 1
  },{
    "@type": "HowToStep",
    "name": "Enter Password",
    "text": "Type or paste the password you want to hash securely",
    "position": 2
  },{
    "@type": "HowToStep",
    "name": "Configure Parameters",
    "text": "Adjust memory cost, time cost, parallelism, and hash length, or use security presets (Interactive, Moderate, Sensitive)",
    "position": 3
  },{
    "@type": "HowToStep",
    "name": "Generate Hash",
    "text": "Click 'Generate Argon2 Hash' button to create the secure password hash",
    "position": 4
  },{
    "@type": "HowToStep",
    "name": "Copy and Store",
    "text": "Copy the encoded hash to your database or authentication system",
    "position": 5
  }]
}
    </script>

    <!-- FAQ Schema for rich snippets -->
    <script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [{
    "@type": "Question",
    "name": "What is Argon2 and why should I use it?",
    "acceptedAnswer": {
      "@type": "Answer",
      "text": "Argon2 is a key derivation function that won the Password Hashing Competition in 2015. It is designed to be resistant to GPU, ASIC, and side-channel attacks. Argon2 is recommended by security experts as the most secure password hashing algorithm available today, superior to bcrypt, scrypt, and PBKDF2."
    }
  },{
    "@type": "Question",
    "name": "Which Argon2 variant should I use?",
    "acceptedAnswer": {
      "@type": "Answer",
      "text": "Argon2id is recommended for most use cases as it combines the benefits of Argon2d (GPU resistance) and Argon2i (side-channel resistance). Use Argon2d for cryptocurrency and applications requiring maximum GPU resistance, or Argon2i for applications with strict side-channel attack requirements."
    }
  },{
    "@type": "Question",
    "name": "What parameters should I use for Argon2?",
    "acceptedAnswer": {
      "@type": "Answer",
      "text": "For most applications, use the Moderate preset (64MB memory, 3 iterations, 4 parallelism). For real-time authentication, use Interactive preset (4MB memory). For highly sensitive data, use Sensitive preset (256MB memory, 5 iterations). Adjust based on your security requirements and available hardware."
    }
  },{
    "@type": "Question",
    "name": "Is Argon2 better than bcrypt or scrypt?",
    "acceptedAnswer": {
      "@type": "Answer",
      "text": "Yes, Argon2 is considered more secure than both bcrypt and scrypt. It was specifically designed to resist modern attack vectors including GPU, ASIC, and side-channel attacks. Argon2 won the Password Hashing Competition in 2015 and is recommended by OWASP and security professionals worldwide."
    }
  },{
    "@type": "Question",
    "name": "How do I verify a password against an Argon2 hash?",
    "acceptedAnswer": {
      "@type": "Answer",
      "text": "Use the Verify Password section of this tool. Simply enter the password you want to verify and paste the Argon2 hash string (starting with $argon2i$, $argon2d$, or $argon2id$). The tool will verify if the password matches the hash and display the result."
    }
  }]
}
    </script>

    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
    <meta name="description" content="Advanced Argon2 password hash generator with support for Argon2i, Argon2d, and Argon2id variants. Adjust memory cost, time cost, parallelism, and salt. Winner of Password Hashing Competition.">
    <meta name="keywords" content="argon2, password hash, argon2i, argon2d, argon2id, password hashing, secure hash, PHC winner, memory-hard function, password security">
    <meta name="author" content="Anish Nath" />
    <meta name="robots" content="index,follow" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <%@ include file="header-script.jsp"%>

    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --card-shadow: 0 5px 15px rgba(0,0,0,0.08);
            --border-radius: 8px;
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }

        .main-wrapper {
            max-width: 1400px;
            margin: 0 auto;
            padding: 1rem;
        }

        .split-layout {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
            align-items: start;
        }

        .page-header-compact {
            background: transparent;
            color: white;
            padding: 1.5rem 0;
            text-align: center;
            margin-bottom: 1.5rem;
        }

        .page-header-compact h1 {
            font-size: 1.75rem;
            margin-bottom: 0.3rem;
            font-weight: 700;
        }

        .page-header-compact p {
            font-size: 0.9rem;
            margin: 0;
            opacity: 0.95;
        }

        .tool-description-compact {
            background: white;
            border-radius: var(--border-radius);
            padding: 0.75rem 1rem;
            margin-top: 1rem;
            box-shadow: var(--card-shadow);
            font-size: 0.8rem;
        }

        .tool-description-compact h4 {
            font-size: 0.9rem;
            margin-bottom: 0.4rem;
            color: #667eea;
        }

        .tool-description-compact p {
            margin-bottom: 0.4rem;
            line-height: 1.4;
        }

        .tool-description-compact p:last-child {
            margin-bottom: 0;
        }

        .argon2-panel {
            background: white;
            border-radius: var(--border-radius);
            padding: 1rem;
            box-shadow: var(--card-shadow);
            margin-bottom: 1rem;
        }

        .argon2-panel h3 {
            font-size: 1rem;
            margin-bottom: 0.75rem;
            color: #495057;
        }

        .input-group-custom {
            margin-bottom: 0.75rem;
        }

        .input-group-custom label {
            display: block;
            font-weight: 600;
            margin-bottom: 0.3rem;
            font-size: 0.85rem;
            color: #495057;
        }

        .input-group-custom small {
            display: block;
            color: #6c757d;
            font-size: 0.75rem;
            margin-top: 0.2rem;
        }

        .argon2-input {
            width: 100%;
            padding: 0.5rem;
            border: 2px solid #dee2e6;
            border-radius: var(--border-radius);
            font-size: 0.85rem;
            font-family: 'Courier New', monospace;
        }

        .argon2-input:focus {
            outline: none;
            border-color: #667eea;
        }

        .variant-selector {
            display: flex;
            gap: 0.4rem;
            margin-bottom: 0.75rem;
        }

        .variant-btn {
            flex: 1;
            padding: 0.5rem 0.3rem;
            background: white;
            border: 2px solid #dee2e6;
            border-radius: var(--border-radius);
            cursor: pointer;
            transition: all 0.3s;
            font-weight: 500;
            font-size: 0.8rem;
        }

        .variant-btn strong {
            font-size: 0.85rem;
        }

        .variant-btn small {
            font-size: 0.7rem;
        }

        .variant-btn:hover {
            border-color: #667eea;
            background: #f8f9ff;
        }

        .variant-btn.active {
            background: var(--primary-gradient);
            color: white;
            border-color: #667eea;
        }

        .params-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 0.75rem;
            margin-bottom: 0.75rem;
        }

        .param-control {
            display: flex;
            flex-direction: column;
        }

        .param-label {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.2rem;
            font-size: 0.75rem;
            font-weight: 600;
            color: #495057;
        }

        .param-value {
            color: #667eea;
            font-weight: 700;
        }

        .range-input {
            width: 100%;
            height: 6px;
            border-radius: 3px;
            background: #e9ecef;
            outline: none;
            -webkit-appearance: none;
        }

        .range-input::-webkit-slider-thumb {
            -webkit-appearance: none;
            appearance: none;
            width: 18px;
            height: 18px;
            border-radius: 50%;
            background: var(--primary-gradient);
            cursor: pointer;
        }

        .range-input::-moz-range-thumb {
            width: 18px;
            height: 18px;
            border-radius: 50%;
            background: var(--primary-gradient);
            cursor: pointer;
            border: none;
        }

        .argon2-btn {
            background: var(--primary-gradient);
            color: white;
            border: none;
            padding: 0.6rem 1rem;
            border-radius: var(--border-radius);
            cursor: pointer;
            font-weight: 600;
            font-size: 0.9rem;
            transition: transform 0.2s;
            width: 100%;
        }

        .argon2-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .argon2-btn:disabled {
            background: #6c757d;
            cursor: not-allowed;
            transform: none;
        }

        .argon2-btn.secondary {
            background: #6c757d;
            margin-top: 0.5rem;
        }

        .result-section {
            display: none;
            margin-top: 1rem;
        }

        .result-section.active {
            display: block;
        }

        .hash-output {
            background: #f8f9fa;
            border: 2px solid #667eea;
            border-radius: var(--border-radius);
            padding: 1rem;
            margin-bottom: 1rem;
            word-break: break-all;
            font-family: 'Courier New', monospace;
            font-size: 0.85rem;
        }

        .hash-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }

        .hash-value {
            color: #667eea;
            user-select: all;
        }

        .verify-section {
            background: white;
            border-radius: var(--border-radius);
            padding: 1.5rem;
            box-shadow: var(--card-shadow);
            margin-bottom: 1.5rem;
        }

        .verify-result {
            padding: 1rem;
            border-radius: var(--border-radius);
            margin-top: 1rem;
            font-weight: 600;
            text-align: center;
        }

        .verify-success {
            background: #d1f4d1;
            color: #0a5c0a;
            border: 2px solid #28a745;
        }

        .verify-failure {
            background: #ffd7d5;
            color: #c41a16;
            border: 2px solid #dc3545;
        }

        .info-badge {
            display: inline-block;
            background: #e7f3ff;
            color: #0d6efd;
            padding: 0.3rem 0.6rem;
            border-radius: 4px;
            font-size: 0.8rem;
            font-weight: 600;
            margin-right: 0.5rem;
        }

        .loading-spinner {
            display: none;
            text-align: center;
            padding: 1rem;
        }

        .loading-spinner.active {
            display: block;
        }

        .spinner {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #667eea;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
            margin: 0 auto;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .preset-buttons {
            display: flex;
            gap: 0.4rem;
            margin-bottom: 0.75rem;
            flex-wrap: wrap;
        }

        .preset-btn {
            padding: 0.3rem 0.6rem;
            background: white;
            border: 1px solid #dee2e6;
            border-radius: var(--border-radius);
            cursor: pointer;
            font-size: 0.75rem;
            transition: all 0.2s;
        }

        .preset-btn:hover {
            border-color: #667eea;
            background: #f8f9ff;
        }

        .output-panel {
            position: sticky;
            top: 1rem;
        }

        .output-placeholder {
            background: rgba(255, 255, 255, 0.1);
            border: 2px dashed rgba(255, 255, 255, 0.3);
            border-radius: var(--border-radius);
            padding: 3rem 2rem;
            text-align: center;
            color: white;
            min-height: 400px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .output-placeholder i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.6;
        }

        .output-placeholder h4 {
            font-size: 1.2rem;
            margin-bottom: 0.5rem;
        }

        .output-placeholder p {
            font-size: 0.9rem;
            opacity: 0.8;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        @keyframes slideIn {
            from {
                transform: translateX(400px);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        @keyframes slideOut {
            from {
                transform: translateX(0);
                opacity: 1;
            }
            to {
                transform: translateX(400px);
                opacity: 0;
            }
        }

        @media (max-width: 1024px) {
            .split-layout {
                grid-template-columns: 1fr;
            }

            .output-panel {
                position: static;
            }
        }

        @media (max-width: 768px) {
            .params-grid {
                grid-template-columns: 1fr;
            }

            .variant-selector {
                flex-direction: column;
            }
        }
    </style>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<div class="main-wrapper">
    <div class="page-header-compact">
        <h1><i class="fas fa-shield-alt"></i> Argon2 Password Hash Generator</h1>
        <p>Secure password hashing with the PHC winner algorithm</p>
    </div>

    <!-- Split Layout: Inputs Left, Outputs Right -->
    <div class="split-layout">
        <!-- LEFT SIDE: Input Panel -->
        <div class="input-panel">
            <!-- Hash Generation Panel -->
            <div class="argon2-panel">
        <h3><i class="fas fa-lock"></i> Generate Argon2 Hash</h3>

        <!-- Variant Selector -->
        <div class="input-group-custom">
            <label>Algorithm Variant</label>
            <div class="variant-selector">
                <button class="variant-btn" onclick="selectVariant(0)">
                    <strong>Argon2d</strong><br>
                    <small>Data-Dependent</small>
                </button>
                <button class="variant-btn active" onclick="selectVariant(1)">
                    <strong>Argon2i</strong><br>
                    <small>Data-Independent</small>
                </button>
                <button class="variant-btn" onclick="selectVariant(2)">
                    <strong>Argon2id</strong><br>
                    <small>Hybrid (Recommended)</small>
                </button>
            </div>
            <small>
                <strong>Argon2d</strong> is faster and resistant to GPU attacks, but vulnerable to side-channel attacks.<br>
                <strong>Argon2i</strong> is resistant to side-channel attacks but slower.<br>
                <strong>Argon2id</strong> is a hybrid that combines the best of both (recommended for most use cases).
            </small>
        </div>

        <!-- Password Input -->
        <div class="input-group-custom">
            <label for="passwordInput"><i class="fas fa-key"></i> Password</label>
            <input type="password" id="passwordInput" class="argon2-input" placeholder="Enter password to hash" />
            <small>The password you want to hash securely</small>
        </div>

        <!-- Salt Input -->
        <div class="input-group-custom">
            <label for="saltInput"><i class="fas fa-random"></i> Salt (Optional)</label>
            <div style="display: flex; gap: 0.5rem;">
                <input type="text" id="saltInput" class="argon2-input" placeholder="Leave empty for random salt" style="flex: 1;" />
                <button class="argon2-btn secondary" onclick="generateRandomSalt()" style="width: auto; padding: 0.6rem 1rem; margin: 0;">
                    <i class="fas fa-dice"></i> Random
                </button>
            </div>
            <small>Random salt will be generated if left empty (recommended)</small>
        </div>

        <!-- Preset Buttons -->
        <div class="input-group-custom">
            <label>Security Presets</label>
            <div class="preset-buttons">
                <button class="preset-btn" onclick="applyPreset('interactive')">
                    <i class="fas fa-bolt"></i> Interactive (Fast)
                </button>
                <button class="preset-btn" onclick="applyPreset('moderate')">
                    <i class="fas fa-balance-scale"></i> Moderate (Default)
                </button>
                <button class="preset-btn" onclick="applyPreset('sensitive')">
                    <i class="fas fa-shield-alt"></i> Sensitive (High Security)
                </button>
            </div>
        </div>

        <!-- Parameters -->
        <div class="input-group-custom">
            <label>Advanced Parameters</label>
            <div class="params-grid">
                <div class="param-control">
                    <div class="param-label">
                        <span>Memory Cost (KB)</span>
                        <span class="param-value" id="memoryValue">65536</span>
                    </div>
                    <input type="range" id="memorySlider" class="range-input" min="1024" max="262144" step="1024" value="65536" oninput="updateParamDisplay('memory', this.value)" />
                    <small style="margin-top: 0.3rem;">Amount of memory used (64 MB default)</small>
                </div>

                <div class="param-control">
                    <div class="param-label">
                        <span>Time Cost (Iterations)</span>
                        <span class="param-value" id="timeValue">3</span>
                    </div>
                    <input type="range" id="timeSlider" class="range-input" min="1" max="10" step="1" value="3" oninput="updateParamDisplay('time', this.value)" />
                    <small style="margin-top: 0.3rem;">Number of iterations (3 default)</small>
                </div>

                <div class="param-control">
                    <div class="param-label">
                        <span>Parallelism</span>
                        <span class="param-value" id="parallelValue">4</span>
                    </div>
                    <input type="range" id="parallelSlider" class="range-input" min="1" max="8" step="1" value="4" oninput="updateParamDisplay('parallel', this.value)" />
                    <small style="margin-top: 0.3rem;">Number of parallel threads (4 default)</small>
                </div>

                <div class="param-control">
                    <div class="param-label">
                        <span>Hash Length (bytes)</span>
                        <span class="param-value" id="hashLenValue">32</span>
                    </div>
                    <input type="range" id="hashLenSlider" class="range-input" min="16" max="64" step="4" value="32" oninput="updateParamDisplay('hashLen', this.value)" />
                    <small style="margin-top: 0.3rem;">Output hash length (32 bytes default)</small>
                </div>
            </div>
        </div>

        <button class="argon2-btn" onclick="generateHash()">
            <i class="fas fa-lock"></i> Generate Argon2 Hash
        </button>
            </div>

            <!-- Verify Panel -->
            <div class="argon2-panel" style="margin-top: 1.5rem;">
        <h3><i class="fas fa-check-circle"></i> Verify Password</h3>

        <div class="input-group-custom">
            <label for="verifyPassword"><i class="fas fa-key"></i> Password to Verify</label>
            <input type="password" id="verifyPassword" class="argon2-input" placeholder="Enter password" />
        </div>

        <div class="input-group-custom">
            <label for="verifyHash"><i class="fas fa-hashtag"></i> Argon2 Hash</label>
            <input type="text" id="verifyHash" class="argon2-input" placeholder="Paste Argon2 hash here" />
            <small>Paste the full Argon2 hash string (e.g., $argon2id$v=19$m=65536,t=3,p=4$...)</small>
        </div>

        <button class="argon2-btn" onclick="verifyPassword()">
            <i class="fas fa-check"></i> Verify Password
        </button>

        <div style="margin-top: 0.5rem; padding: 0.5rem 0.75rem; background: #e7f3ff; border-radius: 6px; font-size: 0.7rem;">
            <strong><i class="fas fa-info-circle"></i> Note:</strong> Verifies hashes from this tool. External implementations may differ.
        </div>
            </div>
        </div>

        <!-- RIGHT SIDE: Output Panel -->
        <div class="output-panel">
            <!-- Hash Output -->
            <div id="hashOutputArea">
                <div class="output-placeholder">
                    <i class="fas fa-arrow-left"></i>
                    <h4>Generate or Verify Hash</h4>
                    <p>Fill in the form on the left and click "Generate Argon2 Hash"<br>to see your results here.</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Related Tools -->
    <div style="background: white; border-radius: 8px; padding: 0.75rem 1rem; margin-top: 1rem; box-shadow: 0 5px 15px rgba(0,0,0,0.08);">
        <h4 style="font-size: 0.95rem; margin-bottom: 0.5rem;"><i class="fas fa-link"></i> Related Tools</h4>
        <div class="row" style="font-size: 0.8rem;">
            <div class="col-md-6">
                <ul class="list-unstyled mb-0" style="line-height: 1.8;">
                    <li><i class="fas fa-lock text-muted"></i> <a href="bccrypt.jsp">BCrypt Password Hash</a></li>
                    <li><i class="fas fa-key text-muted"></i> <a href="scrypt.jsp">SCrypt Password Hash</a></li>
                    <li><i class="fas fa-shield text-muted"></i> <a href="pbkdf.jsp">PBKDF2 Key Derivation</a></li>
                </ul>
            </div>
            <div class="col-md-6">
                <ul class="list-unstyled mb-0" style="line-height: 1.8;">
                    <li><i class="fas fa-fingerprint text-muted"></i> <a href="MessageDigest.jsp">Hash Calculator</a></li>
                    <li><i class="fas fa-random text-muted"></i> <a href="passwdgen.jsp">Password Generator</a></li>
                    <li><i class="fas fa-database text-muted"></i> <a href="htpasswd.jsp">.htpasswd Generator</a></li>
                </ul>
            </div>
        </div>
    </div>

    <!-- About Argon2 -->
    <div class="tool-description-compact">
        <h4><i class="fas fa-info-circle"></i> About Argon2</h4>
        <p><strong>Argon2</strong> is a key derivation function that won the Password Hashing Competition in 2015. It is designed to be resistant to GPU, ASIC, and side-channel attacks. Argon2 comes in three variants: Argon2d (data-dependent), Argon2i (data-independent), and Argon2id (hybrid).</p>
        <p class="mb-0"><strong>Use cases:</strong> Password storage, key derivation, cryptocurrency wallets, authentication systems.</p>
    </div>

    <div style="margin-top: 0.75rem;">
        <div class="sharethis-inline-share-buttons"></div>
        <%@ include file="thanks.jsp"%>
        <%@ include file="addcomments.jsp"%>
    </div>
</div>

<!-- Load argon2-browser library from CDN (UMD build - works without module system) -->
<script src="https://cdn.jsdelivr.net/npm/argon2-browser@1.18.0/dist/argon2-bundled.min.js"></script>

<script>
    // Global variables
    var currentVariant = 1; // Default to Argon2i

    // Variant selection
    function selectVariant(variant) {
        currentVariant = variant;
        var buttons = document.querySelectorAll('.variant-btn');
        buttons.forEach(function(btn, idx) {
            if (idx === variant) {
                btn.classList.add('active');
            } else {
                btn.classList.remove('active');
            }
        });
    }

    // Update parameter displays
    function updateParamDisplay(param, value) {
        document.getElementById(param + 'Value').textContent = value;
    }

    // Generate random salt
    function generateRandomSalt() {
        var array = new Uint8Array(16);
        crypto.getRandomValues(array);
        var salt = Array.from(array, function(byte) {
            return ('0' + byte.toString(16)).slice(-2);
        }).join('');
        document.getElementById('saltInput').value = salt;
    }

    // Apply security presets
    function applyPreset(preset) {
        var presets = {
            'interactive': { memory: 4096, time: 3, parallel: 1 },
            'moderate': { memory: 65536, time: 3, parallel: 4 },
            'sensitive': { memory: 262144, time: 5, parallel: 4 }
        };

        var config = presets[preset];
        document.getElementById('memorySlider').value = config.memory;
        document.getElementById('timeSlider').value = config.time;
        document.getElementById('parallelSlider').value = config.parallel;

        updateParamDisplay('memory', config.memory);
        updateParamDisplay('time', config.time);
        updateParamDisplay('parallel', config.parallel);
    }

    // Helper functions
    function copyToClipboard(text) {
        navigator.clipboard.writeText(text).then(function() {
            alert('Hash copied to clipboard!');
        }).catch(function(err) {
            console.error('Failed to copy:', err);
            // Fallback method
            var textarea = document.createElement('textarea');
            textarea.value = text;
            document.body.appendChild(textarea);
            textarea.select();
            document.execCommand('copy');
            document.body.removeChild(textarea);
            alert('Hash copied to clipboard!');
        });
    }

    function copyToVerify(hash) {
        var password = document.getElementById('passwordInput').value;
        document.getElementById('verifyPassword').value = password;
        document.getElementById('verifyHash').value = hash;

        // Scroll to verify section
        document.querySelector('.argon2-panel[style*="margin-top"]').scrollIntoView({ behavior: 'smooth', block: 'center' });

        // Highlight the verify button briefly
        setTimeout(function() {
            alert('Hash and password copied to verification form. Click "Verify Password" to test.');
        }, 500);
    }

    function clearResults() {
        document.getElementById('passwordInput').value = '';
        document.getElementById('saltInput').value = '';
        document.getElementById('hashOutputArea').innerHTML = '<div class="output-placeholder">' +
            '<i class="fas fa-arrow-left"></i>' +
            '<h4>Generate or Verify Hash</h4>' +
            '<p>Fill in the form on the left and click "Generate Argon2 Hash"<br>to see your results here.</p>' +
            '</div>';
    }

    function showLoading(message) {
        document.getElementById('hashOutputArea').innerHTML =
            '<div style="background: white; border-radius: 8px; padding: 3rem; text-align: center; box-shadow: 0 5px 15px rgba(0,0,0,0.08);">' +
            '<div class="spinner" style="border: 4px solid #f3f3f3; border-top: 4px solid #667eea; border-radius: 50%; width: 40px; height: 40px; animation: spin 1s linear infinite; margin: 0 auto 1rem;"></div>' +
            '<p style="color: #495057; margin: 0;">' + message + '</p>' +
            '</div>';
    }

    // Generate hash
    async function generateHash() {
        if (typeof argon2 === 'undefined') {
            alert('Argon2 library is still loading. Please wait a moment and try again.');
            return;
        }

        var password = document.getElementById('passwordInput').value;
        if (!password) {
            alert('Please enter a password');
            return;
        }

        var salt = document.getElementById('saltInput').value.trim();

        // If no salt provided, generate a random one
        if (!salt || salt.length === 0) {
            var array = new Uint8Array(16);
            crypto.getRandomValues(array);
            salt = Array.from(array, function(byte) {
                return ('0' + byte.toString(16)).slice(-2);
            }).join('');
            document.getElementById('saltInput').value = salt;
        }

        var memory = parseInt(document.getElementById('memorySlider').value);
        var time = parseInt(document.getElementById('timeSlider').value);
        var parallel = parseInt(document.getElementById('parallelSlider').value);
        var hashLen = parseInt(document.getElementById('hashLenSlider').value);

        showLoading('Computing hash...');

        try {
            var variantType = currentVariant; // 0=Argon2d, 1=Argon2i, 2=Argon2id

            var options = {
                pass: password,
                salt: new TextEncoder().encode(salt),
                time: time,
                mem: memory,
                parallelism: parallel,
                hashLen: hashLen,
                type: variantType
            };

            var startTime = performance.now();
            var result = await argon2.hash(options);
            var endTime = performance.now();
            var duration = (endTime - startTime).toFixed(2);

            var variantNames = ['Argon2d', 'Argon2i', 'Argon2id'];
            var resultHtml = '<div style="background: white; border-radius: 8px; padding: 1.5rem; box-shadow: 0 5px 15px rgba(0,0,0,0.08);">' +
                '<h3 style="font-size: 1.2rem; margin-bottom: 1rem; color: #28a745;"><i class="fas fa-check-circle"></i> Hash Generated Successfully</h3>' +
                '<div style="margin-bottom: 1rem;">' +
                '<span class="info-badge">' + variantNames[variantType] + '</span>' +
                '<span class="info-badge">v19</span>' +
                '<span class="info-badge">' + duration + ' ms</span>' +
                '</div>' +
                '<div class="hash-output" style="background: #f8f9fa; border: 2px solid #667eea; border-radius: 8px; padding: 1rem; margin-bottom: 1rem;">' +
                '<div class="hash-label" style="font-weight: 600; margin-bottom: 0.5rem; font-size: 0.9rem; color: #495057;">Encoded Hash (for storage):</div>' +
                '<div class="hash-value" style="color: #667eea; word-break: break-all; font-family: monospace; font-size: 0.85rem; user-select: all;">' + result.encoded + '</div>' +
                '</div>' +
                '<div class="hash-output" style="background: #f8f9fa; border: 2px solid #667eea; border-radius: 8px; padding: 1rem; margin-bottom: 1rem;">' +
                '<div class="hash-label" style="font-weight: 600; margin-bottom: 0.5rem; font-size: 0.9rem; color: #495057;">Raw Hash (hex):</div>' +
                '<div class="hash-value" style="color: #667eea; word-break: break-all; font-family: monospace; font-size: 0.85rem; user-select: all;">' + result.hashHex + '</div>' +
                '</div>' +
                '<div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 0.5rem;">' +
                '<button class="argon2-btn secondary" onclick="copyToClipboard(\'' + result.encoded.replace(/'/g, "\\'") + '\')" style="width: auto; margin: 0;">' +
                '<i class="fas fa-copy"></i> Copy' +
                '</button>' +
                '<button class="argon2-btn secondary" onclick="copyToVerify(\'' + result.encoded.replace(/'/g, "\\'") + '\')" style="width: auto; margin: 0;">' +
                '<i class="fas fa-check"></i> Verify' +
                '</button>' +
                '<button class="argon2-btn secondary" onclick="generateShareableLink()" style="width: auto; margin: 0;">' +
                '<i class="fas fa-share-alt"></i> Share' +
                '</button>' +
                '<button class="argon2-btn secondary" onclick="clearResults()" style="width: auto; margin: 0; grid-column: 1 / -1;">' +
                '<i class="fas fa-redo"></i> Clear' +
                '</button>' +
                '</div>' +
                '</div>';

            document.getElementById('hashOutputArea').innerHTML = resultHtml;

        } catch (error) {
            console.error('Hash generation error:', error);
            document.getElementById('hashOutputArea').innerHTML =
                '<div style="background: white; border-radius: 8px; padding: 1.5rem; box-shadow: 0 5px 15px rgba(0,0,0,0.08);">' +
                '<h3 style="font-size: 1.2rem; margin-bottom: 1rem; color: #dc3545;"><i class="fas fa-exclamation-circle"></i> Error</h3>' +
                '<div style="background: #ffd7d5; border: 2px solid #dc3545; padding: 1rem; border-radius: 8px;">' +
                '<strong>Error:</strong> ' + error.message + '<br><br>' +
                '<small>Please ensure all parameters are valid. If the problem persists, try refreshing the page.</small>' +
                '</div>' +
                '<details style="margin-top: 1rem; font-size: 0.85rem;">' +
                '<summary style="cursor: pointer; color: #6c757d;">Technical Details</summary>' +
                '<pre style="background: #f8f9fa; padding: 0.5rem; border-radius: 4px; margin-top: 0.5rem; overflow-x: auto;">' +
                'Error: ' + error.message + '\\n' +
                'Stack: ' + (error.stack || 'N/A') +
                '</pre>' +
                '</details>' +
                '</div>';
        }
    }

    // Verify password
    async function verifyPassword() {
        if (typeof argon2 === 'undefined') {
            alert('Argon2 library is still loading. Please wait a moment and try again.');
            return;
        }

        var password = document.getElementById('verifyPassword').value;
        var hash = document.getElementById('verifyHash').value.trim();

        if (!password || !hash) {
            alert('Please enter both password and hash');
            return;
        }

        // Validate hash format
        if (!hash.startsWith('$argon2')) {
            alert('Invalid Argon2 hash format. Hash should start with $argon2i$, $argon2d$, or $argon2id$');
            return;
        }

        showLoading('Verifying password...');

        try {
            console.log('Starting verification...');
            console.log('Password:', password);
            console.log('Hash:', hash);

            var startTime = performance.now();

            // argon2.verify() resolves (no return value) if password matches,
            // or rejects (throws error) if password doesn't match
            await argon2.verify({ pass: password, encoded: hash });

            var endTime = performance.now();
            var duration = (endTime - startTime).toFixed(2);

            console.log('Verification succeeded - password matches!');
            console.log('Duration:', duration, 'ms');

            // If we reach here, verification succeeded
            var resultColor = '#28a745';
            var resultBg = '#d1f4d1';
            var resultBorder = '#28a745';
            var resultIcon = 'fa-check-circle';
            var resultText = 'Password Verified!';
            var resultMsg = 'The password matches the provided hash.';

            document.getElementById('hashOutputArea').innerHTML =
                '<div style="background: white; border-radius: 8px; padding: 1.5rem; box-shadow: 0 5px 15px rgba(0,0,0,0.08);">' +
                '<h3 style="font-size: 1.2rem; margin-bottom: 1rem; color: ' + resultColor + ';"><i class="fas ' + resultIcon + '"></i> Verification Result</h3>' +
                '<div style="background: ' + resultBg + '; border: 2px solid ' + resultBorder + '; border-radius: 8px; padding: 2rem; text-align: center;">' +
                '<i class="fas ' + resultIcon + '" style="font-size: 3rem; margin-bottom: 1rem; color: ' + resultColor + ';"></i><br>' +
                '<strong style="font-size: 1.3rem; color: ' + resultColor + ';">' + resultText + '</strong><br>' +
                '<p style="font-size: 1rem; margin: 1rem 0; color: #495057;">' + resultMsg + '</p>' +
                '<span class="info-badge" style="background: ' + resultBg + '; color: ' + resultColor + '; border: 1px solid ' + resultBorder + ';">Verified in ' + duration + ' ms</span>' +
                '</div>' +
                '</div>';

        } catch (error) {
            console.log('Verification failed - password does not match');
            console.error('Verification error:', error);

            var endTime = performance.now();
            var duration = (endTime - startTime).toFixed(2);

            // If we reach here, verification failed (password doesn't match)
            var resultColor = '#dc3545';
            var resultBg = '#ffd7d5';
            var resultBorder = '#dc3545';
            var resultIcon = 'fa-times-circle';
            var resultText = 'Password Does Not Match';
            var resultMsg = 'The password does not match the provided hash.';

            document.getElementById('hashOutputArea').innerHTML =
                '<div style="background: white; border-radius: 8px; padding: 1.5rem; box-shadow: 0 5px 15px rgba(0,0,0,0.08);">' +
                '<h3 style="font-size: 1.2rem; margin-bottom: 1rem; color: ' + resultColor + ';"><i class="fas ' + resultIcon + '"></i> Verification Result</h3>' +
                '<div style="background: ' + resultBg + '; border: 2px solid ' + resultBorder + '; border-radius: 8px; padding: 2rem; text-align: center;">' +
                '<i class="fas ' + resultIcon + '" style="font-size: 3rem; margin-bottom: 1rem; color: ' + resultColor + ';"></i><br>' +
                '<strong style="font-size: 1.3rem; color: ' + resultColor + ';">' + resultText + '</strong><br>' +
                '<p style="font-size: 1rem; margin: 1rem 0; color: #495057;">' + resultMsg + '</p>' +
                '<span class="info-badge" style="background: ' + resultBg + '; color: ' + resultColor + '; border: 1px solid ' + resultBorder + ';">Verified in ' + duration + ' ms</span>' +
                '<br><br>' +
                '<details style="text-align: left; margin-top: 1rem;">' +
                '<summary style="cursor: pointer; color: #6c757d;">Technical Details</summary>' +
                '<pre style="background: #f8f9fa; padding: 0.5rem; border-radius: 4px; margin-top: 0.5rem; font-size: 0.8rem; overflow-x: auto;">' + error.message + '</pre>' +
                '</details>' +
                '</div>' +
                '</div>';
        }
    }

    // Helper function to test hash generation with the same password
    async function testGenerateForVerify() {
        var password = document.getElementById('verifyPassword').value;
        if (!password) {
            alert('Please enter a password first');
            return;
        }

        // Set the password in the generation form
        document.getElementById('passwordInput').value = password;

        // Scroll to generation section
        window.scrollTo({ top: 0, behavior: 'smooth' });

        alert('Password copied to generation form. Click "Generate Argon2 Hash" to create a hash for this password.');
    }

    // Generate shareable link
    function generateShareableLink() {
        var password = document.getElementById('passwordInput').value;
        var salt = document.getElementById('saltInput').value;
        var memory = document.getElementById('memorySlider').value;
        var time = document.getElementById('timeSlider').value;
        var parallel = document.getElementById('parallelSlider').value;
        var hashLen = document.getElementById('hashLenSlider').value;

        // Create URL with parameters
        var params = new URLSearchParams({
            p: btoa(password), // base64 encode password for URL safety
            s: btoa(salt),
            m: memory,
            t: time,
            pl: parallel,
            hl: hashLen,
            v: currentVariant
        });

        var shareUrl = window.location.origin + window.location.pathname + '?' + params.toString();

        // Copy to clipboard
        navigator.clipboard.writeText(shareUrl).then(function() {
            // Show success message in output area
            document.getElementById('hashOutputArea').innerHTML =
                '<div style="background: white; border-radius: 8px; padding: 1.5rem; box-shadow: 0 5px 15px rgba(0,0,0,0.08);">' +
                '<h3 style="font-size: 1.2rem; margin-bottom: 1rem; color: #28a745;"><i class="fas fa-link"></i> Shareable Link Generated</h3>' +
                '<div style="background: #d1f4d1; border: 2px solid #28a745; border-radius: 8px; padding: 1.5rem; text-align: center;">' +
                '<i class="fas fa-check-circle" style="font-size: 2rem; margin-bottom: 1rem; color: #28a745;"></i><br>' +
                '<strong style="font-size: 1.1rem; color: #28a745;">Link Copied to Clipboard!</strong><br>' +
                '<p style="font-size: 0.9rem; margin: 1rem 0; color: #495057;">Share this link with others to load the exact same configuration.</p>' +
                '</div>' +
                '<div style="background: #f8f9fa; border: 2px solid #667eea; border-radius: 8px; padding: 1rem; margin-top: 1rem; word-break: break-all;">' +
                '<div style="font-weight: 600; margin-bottom: 0.5rem; font-size: 0.9rem; color: #495057;">Shareable URL:</div>' +
                '<div style="color: #667eea; font-family: monospace; font-size: 0.75rem; user-select: all;">' + shareUrl + '</div>' +
                '</div>' +
                '<button class="argon2-btn secondary" onclick="copyToClipboard(\'' + shareUrl.replace(/'/g, "\\'") + '\')" style="width: 100%; margin-top: 1rem;">' +
                '<i class="fas fa-copy"></i> Copy Link Again' +
                '</button>' +
                '</div>';
        }).catch(function(err) {
            console.error('Failed to copy:', err);
            alert('Link generated but failed to copy. Please copy manually:\n\n' + shareUrl);
        });
    }

    // Load parameters from URL on page load
    function loadFromUrl() {
        var params = new URLSearchParams(window.location.search);

        if (params.has('p')) {
            try {
                document.getElementById('passwordInput').value = atob(params.get('p'));
                document.getElementById('saltInput').value = atob(params.get('s'));
                document.getElementById('memorySlider').value = params.get('m') || 65536;
                document.getElementById('timeSlider').value = params.get('t') || 3;
                document.getElementById('parallelSlider').value = params.get('pl') || 4;
                document.getElementById('hashLenSlider').value = params.get('hl') || 32;

                // Update displays
                updateParamDisplay('memory', params.get('m') || 65536);
                updateParamDisplay('time', params.get('t') || 3);
                updateParamDisplay('parallel', params.get('pl') || 4);
                updateParamDisplay('hashLen', params.get('hl') || 32);

                // Select variant
                var variant = parseInt(params.get('v')) || 1;
                selectVariant(variant);

                // Show notification that config was loaded
                setTimeout(function() {
                    var notification = document.createElement('div');
                    notification.style.cssText = 'position: fixed; top: 20px; right: 20px; background: #667eea; color: white; padding: 1rem 1.5rem; border-radius: 8px; box-shadow: 0 5px 15px rgba(0,0,0,0.3); z-index: 9999; animation: slideIn 0.3s ease-out;';
                    notification.innerHTML = '<i class="fas fa-check-circle"></i> Configuration loaded from shared link!';
                    document.body.appendChild(notification);

                    setTimeout(function() {
                        notification.style.animation = 'slideOut 0.3s ease-out';
                        setTimeout(function() {
                            document.body.removeChild(notification);
                        }, 300);
                    }, 3000);
                }, 500);
            } catch (e) {
                console.error('Error loading parameters from URL:', e);
            }
        }
    }

    // Load from URL when page loads
    window.addEventListener('load', loadFromUrl);
</script>

</div>
<%@ include file="body-close.jsp"%>

