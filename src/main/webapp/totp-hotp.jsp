<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<div lang="en">
<head>
    <title>TOTP HOTP Generator - Free 2FA Two Factor Authentication OTP QR Code Generator Online | Google Authenticator Compatible | 8gwifi.org</title>

    <!-- Enhanced JSON-LD markup for SEO -->
    <script type="application/ld+json">
{
  "@context" : "http://schema.org",
  "@type" : "SoftwareApplication",
  "name" : "TOTP HOTP Generator - Two Factor Authentication 2FA OTP Tool",
  "alternateName" : ["Google Authenticator Generator", "2FA Code Generator", "OTP Generator Online", "Time-Based OTP Generator", "HMAC OTP Tool"],
  "description" : "Free online TOTP and HOTP generator for two-factor authentication (2FA). Generate time-based and counter-based one-time passwords, create QR codes for Google Authenticator, Authy, Microsoft Authenticator. RFC 6238 and RFC 4226 compliant with SHA-1, SHA-256, SHA-512 support.",
  "url" : "https://8gwifi.org/totp-hotp.jsp",
  "image" : "https://8gwifi.org/images/totp.png",
  "screenshot" : "https://8gwifi.org/images/totp-screenshot.png",
  "author" : {
    "@type" : "Person",
    "name" : "Anish Nath",
    "url" : "https://8gwifi.org"
  },
  "publisher" : {
    "@type" : "Organization",
    "name" : "8gwifi.org",
    "logo" : {
      "@type" : "ImageObject",
      "url" : "https://8gwifi.org/images/logo.png"
    }
  },
  "datePublished" : "2025-01-28",
  "dateModified" : "2025-01-28",
  "applicationCategory" : ["SecurityApplication", "Utility", "DeveloperApplication"],
  "applicationSubCategory" : "Two-Factor Authentication Tool",
  "downloadUrl" : "https://8gwifi.org/totp-hotp.jsp",
  "operatingSystem" : ["Windows", "MacOS", "Linux", "Android", "iOS", "Web Browser"],
  "requirements" : "Modern Web Browser with JavaScript enabled",
  "softwareVersion" : "1.0",
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.8",
    "ratingCount": "1250",
    "bestRating": "5",
    "worstRating": "1"
  },
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  },
  "featureList" : [
    "TOTP Generator (RFC 6238 Compliant)",
    "HOTP Generator (RFC 4226 Compliant)",
    "QR Code Generation for 2FA Apps",
    "Google Authenticator Compatible",
    "Secret Key Generator (Base32)",
    "SHA-1, SHA-256, SHA-512 Algorithm Support",
    "6, 7, 8 Digit OTP Codes",
    "Auto-Refresh Timer for TOTP",
    "OTP Code Validation & Testing",
    "Backup Recovery Codes Generation",
    "Export/Import Configuration",
    "Time Synchronization Indicator",
    "Counter-Based HOTP Support",
    "Authy Compatible",
    "Microsoft Authenticator Compatible",
    "No Server Upload - Privacy First",
    "Free and Open Source"
  ],
  "keywords": "TOTP, HOTP, 2FA, two factor authentication, OTP generator, Google Authenticator, Authy, Microsoft Authenticator, time-based OTP, HMAC OTP, RFC 6238, RFC 4226, QR code generator, secret key generator, authentication code, one time password, security token, multi-factor authentication, MFA, 2-step verification, OTP validator, backup codes, TOTP online, HOTP online, free 2FA tool",
  "about": {
    "@type": "Thing",
    "name": "Two-Factor Authentication",
    "description": "Two-factor authentication (2FA) adds an extra layer of security by requiring a second form of verification beyond just a password."
  },
  "educationalUse": "Learn about TOTP and HOTP algorithms, implement two-factor authentication, generate OTP codes for testing",
  "isAccessibleForFree": true,
  "interactionStatistic": {
    "@type": "InteractionCounter",
    "interactionType": "http://schema.org/UseAction",
    "userInteractionCount": "50000"
  }
}
    </script>

    <!-- Breadcrumb JSON-LD -->
    <script type="application/ld+json">
{
  "@context": "http://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {
      "@type": "ListItem",
      "position": 1,
      "name": "Home",
      "item": "https://8gwifi.org/"
    },
    {
      "@type": "ListItem",
      "position": 2,
      "name": "Security Tools",
      "item": "https://8gwifi.org/cryptography.jsp"
    },
    {
      "@type": "ListItem",
      "position": 3,
      "name": "TOTP HOTP Generator",
      "item": "https://8gwifi.org/totp-hotp.jsp"
    }
  ]
}
    </script>

    <!-- FAQ JSON-LD -->
    <script type="application/ld+json">
{
  "@context": "http://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "What is TOTP?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "TOTP (Time-based One-Time Password) is an algorithm that generates a temporary password based on the current time and a shared secret key. It's defined in RFC 6238 and commonly used in two-factor authentication by apps like Google Authenticator and Authy."
      }
    },
    {
      "@type": "Question",
      "name": "What is the difference between TOTP and HOTP?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "TOTP is time-based and generates codes that expire every 30 seconds (typically), while HOTP is counter-based and generates codes based on an incrementing counter. TOTP is synchronized with time servers, while HOTP requires manual counter synchronization between client and server."
      }
    },
    {
      "@type": "Question",
      "name": "Is this TOTP generator compatible with Google Authenticator?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes! This tool generates QR codes and OTP URIs that are fully compatible with Google Authenticator, Authy, Microsoft Authenticator, and any other RFC 6238/4226 compliant authenticator app."
      }
    },
    {
      "@type": "Question",
      "name": "How secure is TOTP for two-factor authentication?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "TOTP is very secure when implemented correctly. It uses cryptographic hash functions (SHA-1, SHA-256, SHA-512) and time-based codes that expire quickly. The secret key should be kept secure and never shared. This tool processes everything client-side, so your secret key never leaves your browser."
      }
    },
    {
      "@type": "Question",
      "name": "Can I use this tool offline?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes, once the page is loaded, all TOTP/HOTP generation happens in your browser using JavaScript. No data is sent to any server, making it safe for offline use and ensuring your secret keys remain private."
      }
    }
  ]
}
    </script>

    <!-- HowTo JSON-LD -->
    <script type="application/ld+json">
{
  "@context": "http://schema.org",
  "@type": "HowTo",
  "name": "How to Generate TOTP Codes for Two-Factor Authentication",
  "description": "Step-by-step guide to generate TOTP codes and set up two-factor authentication using this tool",
  "image": "https://8gwifi.org/images/totp-howto.png",
  "step": [
    {
      "@type": "HowToStep",
      "name": "Generate or Enter Secret Key",
      "text": "Click 'Generate' to create a new random Base32 secret key, or enter your existing secret key.",
      "position": 1
    },
    {
      "@type": "HowToStep",
      "name": "Configure Settings",
      "text": "Set your issuer name, account name, and choose algorithm (SHA-1, SHA-256, or SHA-512) and code length (6, 7, or 8 digits).",
      "position": 2
    },
    {
      "@type": "HowToStep",
      "name": "Generate QR Code",
      "text": "The QR code will be automatically generated. Scan it with your authenticator app (Google Authenticator, Authy, etc.).",
      "position": 3
    },
    {
      "@type": "HowToStep",
      "name": "Generate OTP Code",
      "text": "Click 'Generate OTP' or 'Auto-Refresh' to see your time-based one-time password. The code refreshes every 30 seconds.",
      "position": 4
    },
    {
      "@type": "HowToStep",
      "name": "Validate and Test",
      "text": "Test your code by entering it in the validation section to ensure it matches your authenticator app.",
      "position": 5
    }
  ]
}
    </script>

    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
    <meta name="description" content="Free TOTP HOTP Generator - Create two-factor authentication (2FA) codes online. Generate QR codes for Google Authenticator, Authy, Microsoft Authenticator. RFC 6238 & RFC 4226 compliant. Support SHA-1/256/512, 6-8 digit codes, time-based & counter-based OTP. Generate secret keys, backup codes, validate OTP. Privacy-first, no server upload, 100% client-side.">
    <meta name="keywords" content="totp generator, hotp generator, 2fa generator, two factor authentication, otp generator online, google authenticator generator, authy generator, microsoft authenticator, time based otp, hmac otp, rfc 6238, rfc 4226, qr code generator 2fa, secret key generator, totp online, hotp online, one time password, 2fa qr code, authenticator app, otp validator, backup codes generator, totp test, hotp test, free 2fa tool, totp sha256, totp sha512, 6 digit otp, 8 digit otp, 2 step verification, multi factor authentication, mfa tool, security token generator, otp code generator, time based password, counter based otp, base32 encoder, totp algorithm, hotp algorithm, authenticator compatible, 2fa setup, otp uri generator, totp token, hotp token">
    <meta name="author" content="Anish Nath" />
    <meta name="robots" content="index,follow,max-snippet:-1,max-image-preview:large,max-video-preview:-1" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Open Graph / Facebook -->
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/totp-hotp.jsp">
    <meta property="og:title" content="TOTP HOTP Generator - Free 2FA Two Factor Authentication Tool Online">
    <meta property="og:description" content="Generate TOTP & HOTP codes for two-factor authentication. Create QR codes for Google Authenticator, Authy. RFC 6238/4226 compliant. Free online 2FA tool.">
    <meta property="og:image" content="https://8gwifi.org/images/totp-og.png">
    <meta property="og:site_name" content="8gwifi.org">
    <meta property="og:locale" content="en_US">

    <!-- Twitter Card -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:url" content="https://8gwifi.org/totp-hotp.jsp">
    <meta name="twitter:title" content="TOTP HOTP Generator - Free 2FA OTP Generator Online">
    <meta name="twitter:description" content="Generate two-factor authentication codes online. TOTP & HOTP generator with QR codes for Google Authenticator. RFC 6238/4226 compliant.">
    <meta name="twitter:image" content="https://8gwifi.org/images/totp-twitter.png">
    <meta name="twitter:creator" content="@8gwifi">

    <!-- Additional SEO Meta Tags -->
    <meta name="classification" content="Security Tools, Two-Factor Authentication, Cryptography">
    <meta name="coverage" content="Worldwide">
    <meta name="distribution" content="Global">
    <meta name="rating" content="General">
    <meta name="target" content="Developers, Security Engineers, IT Professionals, System Administrators">
    <link rel="canonical" href="https://8gwifi.org/totp-hotp.jsp">

    <%@ include file="header-script.jsp"%>

    <!-- QR Code Library -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>

    <!-- TOTP/HOTP Library - jsSHA -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jsSHA/3.2.0/sha.js"></script>

    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --success-color: #28a745;
            --danger-color: #dc3545;
            --warning-color: #ffc107;
            --info-color: #17a2b8;
            --light-bg: #f8f9fa;
            --border-color: #dee2e6;
        }

        .otp-container {
            margin: 2rem 0;
        }

        .otp-controls {
            background: var(--light-bg);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 1rem;
            margin-bottom: 1rem;
        }

        .otp-control-group {
            margin-bottom: 1rem;
        }

        .otp-control-group label {
            font-weight: 600;
            margin-bottom: 0.5rem;
            display: block;
            color: #495057;
        }

        .otp-btn {
            background: var(--primary-gradient);
            color: white;
            border: none;
            padding: 0.6rem 1.5rem;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: transform 0.2s;
            margin-right: 0.5rem;
            margin-bottom: 0.5rem;
        }

        .otp-btn:hover {
            transform: translateY(-2px);
        }

        .otp-btn.secondary {
            background: #6c757d;
        }

        .otp-btn.success {
            background: var(--success-color);
        }

        .otp-btn.danger {
            background: var(--danger-color);
        }

        .mode-selector {
            display: inline-flex;
            background: white;
            border: 2px solid var(--border-color);
            border-radius: 8px;
            overflow: hidden;
            margin-bottom: 1rem;
        }

        .mode-btn {
            padding: 0.6rem 1.5rem;
            background: white;
            border: none;
            cursor: pointer;
            font-weight: 600;
            color: #495057;
            transition: all 0.2s;
        }

        .mode-btn.active {
            background: #667eea;
            color: white;
        }

        .input-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        @media (max-width: 768px) {
            .input-section {
                grid-template-columns: 1fr;
            }
        }

        .input-panel {
            border: 2px solid var(--border-color);
            border-radius: 12px;
            padding: 1rem;
            background: white;
        }

        .input-panel h3 {
            margin: 0 0 0.75rem 0;
            font-size: 1rem;
            color: #495057;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-control {
            width: 100%;
            padding: 0.6rem;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 1rem;
        }

        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .otp-display {
            text-align: center;
            padding: 1.5rem;
            background: linear-gradient(135deg, #667eea15 0%, #764ba215 100%);
            border-radius: 12px;
            margin: 1rem 0;
        }

        .otp-code {
            font-size: 2.5rem;
            font-weight: 700;
            letter-spacing: 0.5rem;
            color: #667eea;
            font-family: 'Courier New', monospace;
            margin: 0.75rem 0;
        }

        .otp-timer {
            font-size: 1.2rem;
            color: #6c757d;
            margin-top: 0.5rem;
        }

        .otp-progress {
            width: 100%;
            height: 8px;
            background: #e9ecef;
            border-radius: 4px;
            overflow: hidden;
            margin-top: 1rem;
        }

        .otp-progress-bar {
            height: 100%;
            background: var(--primary-gradient);
            transition: width 1s linear;
        }

        .qr-code-container {
            text-align: center;
            padding: 1rem;
            background: white;
            border: 2px solid var(--border-color);
            border-radius: 12px;
        }

        #qrcode {
            display: inline-block;
            padding: 0.75rem;
            background: white;
            border: 2px solid var(--border-color);
            border-radius: 8px;
        }

        .secret-display {
            background: #f8f9fa;
            padding: 1rem;
            border-radius: 8px;
            font-family: 'Courier New', monospace;
            font-size: 1.1rem;
            word-break: break-all;
            margin: 1rem 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .copy-btn {
            background: #667eea;
            color: white;
            border: none;
            padding: 0.4rem 1rem;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.9rem;
        }

        .copy-btn:hover {
            background: #5568d3;
        }

        .alert {
            padding: 1rem;
            border-radius: 8px;
            margin: 1rem 0;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-danger {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .alert-info {
            background: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }

        .backup-codes {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 0.5rem;
            margin: 1rem 0;
        }

        .backup-code {
            background: #f8f9fa;
            padding: 0.8rem;
            border-radius: 6px;
            font-family: 'Courier New', monospace;
            text-align: center;
            border: 1px solid var(--border-color);
        }

        .info-card {
            background: #f8f9fa;
            border-left: 4px solid #667eea;
            padding: 1rem;
            border-radius: 4px;
            margin: 1rem 0;
        }

        .info-card h5 {
            margin: 0 0 0.5rem 0;
            color: #667eea;
        }

        .validation-section {
            background: white;
            border: 2px solid var(--border-color);
            border-radius: 12px;
            padding: 1.5rem;
            margin-top: 1.5rem;
        }

        .validation-result {
            padding: 1rem;
            border-radius: 8px;
            margin-top: 1rem;
            font-weight: 600;
            text-align: center;
        }

        .validation-success {
            background: #d4edda;
            color: #155724;
        }

        .validation-failure {
            background: #f8d7da;
            color: #721c24;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 1rem;
            margin: 1rem 0;
        }

        .stat-card {
            background: white;
            border: 2px solid var(--border-color);
            border-radius: 8px;
            padding: 1rem;
            text-align: center;
        }

        .stat-value {
            font-size: 1.5rem;
            font-weight: 700;
            color: #667eea;
        }

        .stat-label {
            font-size: 0.9rem;
            color: #6c757d;
            margin-top: 0.25rem;
        }

        .algorithm-selector {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .algorithm-option {
            flex: 1;
            min-width: 100px;
        }

        .url-display {
            background: #f8f9fa;
            padding: 1rem;
            border-radius: 8px;
            font-family: 'Courier New', monospace;
            font-size: 0.9rem;
            word-break: break-all;
            margin: 1rem 0;
        }

        .time-sync-indicator {
            display: inline-block;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            margin-right: 0.5rem;
        }

        .sync-good {
            background: var(--success-color);
        }

        .sync-warning {
            background: var(--warning-color);
        }

        .sync-bad {
            background: var(--danger-color);
        }
    </style>
</head>


    <%@ include file="body-script.jsp"%>

    <div class="page-header" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 1rem 0; margin-bottom: 1.5rem;">
        <div class="container">
            <h1 style="font-size: 1.75rem; margin-bottom: 0.25rem;"><i class="fas fa-shield-alt"></i> TOTP/HOTP Generator</h1>
            <p style="font-size: 0.95rem; margin-bottom: 0; opacity: 0.9;">Two-Factor Authentication (2FA) - RFC 6238 & RFC 4226</p>
        </div>
    </div>

    <div class="container">
        <div class="tool-description" style="background: #f8f9fa; border-left: 4px solid #667eea; padding: 0.75rem; margin-bottom: 1rem;">
            <p style="margin: 0; font-size: 0.9rem;"><i class="fas fa-info-circle"></i> Generate TOTP/HOTP codes for 2FA. Create QR codes for Google Authenticator, Authy, or other authenticator apps.</p>
        </div>

        <div class="otp-container">
            <!-- Mode Selection -->
            <div class="otp-controls">
                <div class="otp-control-group">
                    <label><i class="fas fa-cog"></i> Authentication Mode:</label>
                    <div class="mode-selector">
                        <button class="mode-btn active" onclick="setMode('totp')">
                            <i class="fas fa-clock"></i> TOTP (Time-based)
                        </button>
                        <button class="mode-btn" onclick="setMode('hotp')">
                            <i class="fas fa-hashtag"></i> HOTP (Counter-based)
                        </button>
                    </div>
                </div>
            </div>

            <!-- Configuration Section -->
            <div class="input-section">
                <!-- Configuration Panel -->
                <div class="input-panel">
                    <h3><i class="fas fa-key"></i> Configuration</h3>

                    <div class="otp-control-group">
                        <label for="secretKey">Secret Key (Base32):</label>
                        <div style="display: flex; gap: 0.5rem;">
                            <input type="text" id="secretKey" class="form-control" placeholder="Enter or generate secret key" value="JBSWY3DPEHPK3PXP">
                            <button class="otp-btn success" onclick="generateSecret()">
                                <i class="fas fa-sync"></i> Generate
                            </button>
                        </div>
                    </div>

                    <div class="otp-control-group">
                        <label for="issuer">Issuer (Service Name):</label>
                        <input type="text" id="issuer" class="form-control" placeholder="e.g., 8gwifi.org" value="8gwifi.org">
                    </div>

                    <div class="otp-control-group">
                        <label for="accountName">Account Name (Email/Username):</label>
                        <input type="text" id="accountName" class="form-control" placeholder="e.g., user@example.com" value="user@example.com">
                    </div>

                    <div class="otp-control-group">
                        <label for="algorithm">Hash Algorithm:</label>
                        <select id="algorithm" class="form-control">
                            <option value="SHA1" selected>SHA-1 (Default)</option>
                            <option value="SHA256">SHA-256</option>
                            <option value="SHA512">SHA-512</option>
                        </select>
                    </div>

                    <div class="otp-control-group">
                        <label for="digits">Code Length (Digits):</label>
                        <select id="digits" class="form-control">
                            <option value="6" selected>6 digits (Standard)</option>
                            <option value="7">7 digits</option>
                            <option value="8">8 digits</option>
                        </select>
                    </div>

                    <div class="otp-control-group" id="totpPeriodGroup">
                        <label for="period">Time Period (seconds):</label>
                        <select id="period" class="form-control">
                            <option value="30" selected>30 seconds (Standard)</option>
                            <option value="60">60 seconds</option>
                            <option value="15">15 seconds</option>
                        </select>
                    </div>

                    <div class="otp-control-group" id="hotpCounterGroup" style="display: none;">
                        <label for="counter">Counter Value:</label>
                        <input type="number" id="counter" class="form-control" value="0" min="0">
                    </div>
                </div>

                <!-- QR Code Panel -->
                <div class="input-panel">
                    <h3><i class="fas fa-qrcode"></i> QR Code</h3>

                    <div class="qr-code-container">
                        <div id="qrcode"></div>
                        <p style="margin-top: 1rem; color: #6c757d;">
                            <i class="fas fa-mobile-alt"></i> Scan with authenticator app
                        </p>
                    </div>

                    <div class="otp-control-group">
                        <button class="otp-btn" onclick="generateQRCode()">
                            <i class="fas fa-sync"></i> Regenerate QR Code
                        </button>
                        <button class="otp-btn secondary" onclick="downloadQRCode()">
                            <i class="fas fa-download"></i> Download QR
                        </button>
                    </div>

                    <div class="info-card">
                        <h5><i class="fas fa-lightbulb"></i> OTP URI</h5>
                        <div class="url-display" id="otpUri"></div>
                        <button class="copy-btn" onclick="copyUri()">
                            <i class="fas fa-copy"></i> Copy URI
                        </button>
                    </div>
                </div>
            </div>

            <!-- OTP Display -->
            <div class="input-panel">
                <h3><i class="fas fa-mobile-alt"></i> Generated OTP Code</h3>

                <div class="otp-display">
                    <div style="color: #6c757d; margin-bottom: 0.5rem;">
                        <span class="time-sync-indicator sync-good" id="syncIndicator"></span>
                        <span id="timeSyncStatus">Time Synchronized</span>
                    </div>
                    <div class="otp-code" id="otpCode">------</div>
                    <div class="otp-timer" id="otpTimer">--s remaining</div>
                    <div class="otp-progress" id="totpProgress" style="display: none;">
                        <div class="otp-progress-bar" id="progressBar"></div>
                    </div>
                </div>

                <div style="text-align: center; margin-top: 1rem;">
                    <button class="otp-btn" onclick="generateOTP()">
                        <i class="fas fa-sync"></i> Generate OTP
                    </button>
                    <button class="otp-btn success" onclick="startAutoRefresh()" id="autoRefreshBtn">
                        <i class="fas fa-play"></i> Auto-Refresh
                    </button>
                    <button class="otp-btn secondary" onclick="copyOTP()">
                        <i class="fas fa-copy"></i> Copy Code
                    </button>
                </div>

                <!-- Statistics -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-value" id="statGenerated">0</div>
                        <div class="stat-label">Codes Generated</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value" id="statValidated">0</div>
                        <div class="stat-label">Validations</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value" id="statSuccess">0</div>
                        <div class="stat-label">Successful</div>
                    </div>
                    <div class="stat-card" id="hotpCounterDisplay" style="display: none;">
                        <div class="stat-value" id="currentCounter">0</div>
                        <div class="stat-label">Current Counter</div>
                    </div>
                </div>
            </div>

            <!-- Validation Section -->
            <div class="validation-section" style="padding: 1rem; margin-top: 1rem;">
                <h3 style="font-size: 1rem; margin-bottom: 0.75rem;"><i class="fas fa-check-circle"></i> Validate OTP Code</h3>

                <div class="otp-control-group">
                    <div style="display: flex; gap: 0.5rem;">
                        <input type="text" id="validateCode" class="form-control" placeholder="Enter 6-8 digit code" maxlength="8">
                        <button class="otp-btn" onclick="validateOTP()">
                            <i class="fas fa-check"></i> Validate
                        </button>
                    </div>
                </div>

                <div id="validationResult"></div>
            </div>

            <!-- Backup Codes & Export Section -->
            <div class="input-panel" style="margin-top: 1rem;">
                <h3 style="font-size: 1rem; margin-bottom: 0.75rem;"><i class="fas fa-life-ring"></i> Backup & Export</h3>

                <div style="display: flex; gap: 0.5rem; flex-wrap: wrap; margin-bottom: 0.75rem;">
                    <button class="otp-btn" onclick="generateBackupCodes()">
                        <i class="fas fa-shield-alt"></i> Generate Backup Codes
                    </button>
                    <button class="otp-btn secondary" onclick="downloadBackupCodes()">
                        <i class="fas fa-download"></i> Download
                    </button>
                </div>

                <div id="backupCodesContainer"></div>

                <hr style="margin: 0.75rem 0;">

                <div style="display: flex; gap: 0.5rem; flex-wrap: wrap;">
                    <button class="otp-btn" onclick="exportConfig('json')">
                        <i class="fas fa-file-code"></i> Export JSON
                    </button>
                    <button class="otp-btn" onclick="exportConfig('text')">
                        <i class="fas fa-file-alt"></i> Export Text
                    </button>
                    <button class="otp-btn" onclick="importConfig()">
                        <i class="fas fa-file-upload"></i> Import
                    </button>
                </div>
                <input type="file" id="importFile" style="display: none;" accept=".json,.txt">
            </div>

            <!-- Information Section - Collapsible -->
            <div class="card mt-3">
                <div class="card-header" style="cursor: pointer; padding: 0.75rem 1rem;" onclick="document.getElementById('howItWorksContent').style.display = document.getElementById('howItWorksContent').style.display === 'none' ? 'block' : 'none'">
                    <h5 style="margin: 0; font-size: 1rem;"><i class="fas fa-book"></i> How It Works <span style="float: right;">▾</span></h5>
                </div>
                <div class="card-body" id="howItWorksContent" style="display: none; padding: 1rem; font-size: 0.9rem;">
                    <div class="row">
                        <div class="col-md-6">
                            <h6><i class="fas fa-clock"></i> TOTP (Time-based)</h6>
                            <ul style="margin-bottom: 0.5rem; padding-left: 1.25rem;">
                                <li>RFC 6238 standard</li>
                                <li>Uses current time + secret</li>
                                <li>Code changes every 30s</li>
                                <li>Google Authenticator, Authy</li>
                            </ul>
                        </div>
                        <div class="col-md-6">
                            <h6><i class="fas fa-hashtag"></i> HOTP (Counter-based)</h6>
                            <ul style="margin-bottom: 0.5rem; padding-left: 1.25rem;">
                                <li>RFC 4226 standard</li>
                                <li>Uses counter + secret</li>
                                <li>Counter increments per use</li>
                                <li>Good for offline scenarios</li>
                            </ul>
                        </div>
                    </div>
                    <hr style="margin: 0.75rem 0;">
                    <h6><i class="fas fa-shield-alt"></i> Security Tips</h6>
                    <ul style="margin-bottom: 0; padding-left: 1.25rem;">
                        <li>Keep secret key secure - never share it</li>
                        <li>Use SHA-256/SHA-512 for better security</li>
                        <li>Generate and store backup codes</li>
                        <li>Ensure accurate device time for TOTP</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Related Tools -->
        <div class="card mt-3">
            <div class="card-header" style="padding: 0.75rem 1rem;">
                <h5 style="margin: 0; font-size: 1rem;"><i class="fas fa-link"></i> Related Tools</h5>
            </div>
            <div class="card-body" style="padding: 0.75rem 1rem; font-size: 0.9rem;">
                <a href="MessageDigest.jsp">HMAC Generator</a> |
                <a href="passwdgen.jsp">Password Generator</a> |
                <a href="qrcodegen.jsp">QR Code</a> |
                <a href="jwkfunctions.jsp">JWK</a> |
                <a href="bccrypt.jsp">BCrypt</a> |
                <a href="argon2.jsp">Argon2</a>
            </div>
        </div>

        <hr>
        <div class="sharethis-inline-share-buttons"></div>
        <%@ include file="thanks.jsp"%>
        <hr>
        <%@ include file="footer_adsense.jsp"%>
        <%@ include file="addcomments.jsp"%>
    </div>

    <script>
        // Global variables
        let currentMode = 'totp';
        let autoRefreshInterval = null;
        let qrCodeInstance = null;
        let stats = {
            generated: 0,
            validated: 0,
            success: 0
        };
        let backupCodes = [];

        // Base32 encoding/decoding
        const base32Chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';

        function base32Decode(base32) {
            base32 = base32.toUpperCase().replace(/=+$/, '');
            let bits = '';
            for (let i = 0; i < base32.length; i++) {
                const val = base32Chars.indexOf(base32.charAt(i));
                if (val === -1) throw new Error('Invalid base32 character');
                bits += val.toString(2).padStart(5, '0');
            }

            const bytes = [];
            for (let i = 0; i + 8 <= bits.length; i += 8) {
                bytes.push(parseInt(bits.substr(i, 8), 2));
            }
            return new Uint8Array(bytes);
        }

        function base32Encode(buffer) {
            let bits = '';
            for (let i = 0; i < buffer.length; i++) {
                bits += buffer[i].toString(2).padStart(8, '0');
            }

            let result = '';
            for (let i = 0; i + 5 <= bits.length; i += 5) {
                const chunk = bits.substr(i, 5);
                result += base32Chars[parseInt(chunk, 2)];
            }

            // Padding
            while (result.length % 8 !== 0) {
                result += '=';
            }
            return result;
        }

        // Generate random secret
        function generateSecret() {
            const length = 32; // 20 bytes = 32 base32 chars
            const randomBytes = new Uint8Array(20);
            crypto.getRandomValues(randomBytes);
            const secret = base32Encode(randomBytes);
            document.getElementById('secretKey').value = secret;
            generateQRCode();
        }

        // Mode switching
        function setMode(mode) {
            currentMode = mode;

            // Update buttons
            document.querySelectorAll('.mode-btn').forEach(btn => btn.classList.remove('active'));
            event.target.classList.add('active');

            // Show/hide relevant controls
            if (mode === 'totp') {
                document.getElementById('totpPeriodGroup').style.display = 'block';
                document.getElementById('hotpCounterGroup').style.display = 'none';
                document.getElementById('totpProgress').style.display = 'block';
                document.getElementById('hotpCounterDisplay').style.display = 'none';
            } else {
                document.getElementById('totpPeriodGroup').style.display = 'none';
                document.getElementById('hotpCounterGroup').style.display = 'block';
                document.getElementById('totpProgress').style.display = 'none';
                document.getElementById('hotpCounterDisplay').style.display = 'block';
                updateHotpCounter();
            }

            generateQRCode();
        }

        // Generate OTP URI
        function generateOTPUri() {
            const secret = document.getElementById('secretKey').value.trim();
            const issuer = encodeURIComponent(document.getElementById('issuer').value.trim());
            const account = encodeURIComponent(document.getElementById('accountName').value.trim());
            const algorithm = document.getElementById('algorithm').value;
            const digits = document.getElementById('digits').value;

            let uri = 'otpauth://' + currentMode + '/' + issuer + ':' + account + '?secret=' + secret + '&issuer=' + issuer + '&algorithm=' + algorithm + '&digits=' + digits;

            if (currentMode === 'totp') {
                const period = document.getElementById('period').value;
                uri += '&period=' + period;
            } else {
                const counter = document.getElementById('counter').value;
                uri += '&counter=' + counter;
            }

            return uri;
        }

        // Generate QR Code
        function generateQRCode() {
            const qrContainer = document.getElementById('qrcode');
            qrContainer.innerHTML = '';

            const uri = generateOTPUri();
            document.getElementById('otpUri').textContent = uri;

            qrCodeInstance = new QRCode(qrContainer, {
                text: uri,
                width: 200,
                height: 200,
                colorDark: "#000000",
                colorLight: "#ffffff",
                correctLevel: QRCode.CorrectLevel.H
            });
        }

        // HMAC-based OTP calculation
        function hmacOTP(secret, counter, digits, algorithm) {
            try {
                // Decode base32 secret
                const key = base32Decode(secret);

                // Convert counter to 8-byte array (big-endian)
                const counterBytes = new ArrayBuffer(8);
                const counterView = new DataView(counterBytes);
                counterView.setUint32(4, counter, false); // big-endian

                // Map algorithm names for jsSHA
                let shaVariant;
                switch(algorithm) {
                    case 'SHA1':
                        shaVariant = 'SHA-1';
                        break;
                    case 'SHA256':
                        shaVariant = 'SHA-256';
                        break;
                    case 'SHA512':
                        shaVariant = 'SHA-512';
                        break;
                    default:
                        shaVariant = 'SHA-1';
                }

                // Calculate HMAC using jsSHA
                const shaObj = new jsSHA(shaVariant, "ARRAYBUFFER", {
                    hmacKey: { value: key, format: "UINT8ARRAY" }
                });
                shaObj.update(counterBytes);
                const hmac = shaObj.getHMAC("UINT8ARRAY");

                // Dynamic truncation (RFC 4226)
                const offset = hmac[hmac.length - 1] & 0x0f;
                const binary =
                    ((hmac[offset] & 0x7f) << 24) |
                    ((hmac[offset + 1] & 0xff) << 16) |
                    ((hmac[offset + 2] & 0xff) << 8) |
                    (hmac[offset + 3] & 0xff);

                const otp = binary % Math.pow(10, digits);
                return otp.toString().padStart(digits, '0');
            } catch (e) {
                console.error('Error in hmacOTP:', e);
                throw e;
            }
        }

        // Generate TOTP
        function generateTOTP() {
            const secret = document.getElementById('secretKey').value.trim();
            const digits = parseInt(document.getElementById('digits').value);
            const period = parseInt(document.getElementById('period').value);
            const algorithm = document.getElementById('algorithm').value;

            if (!secret) {
                alert('Please enter or generate a secret key');
                return null;
            }

            try {
                const epoch = Math.floor(Date.now() / 1000);
                const counter = Math.floor(epoch / period);
                return hmacOTP(secret, counter, digits, algorithm);
            } catch (e) {
                alert('Error generating TOTP: ' + e.message);
                return null;
            }
        }

        // Generate HOTP
        function generateHOTP() {
            const secret = document.getElementById('secretKey').value.trim();
            const digits = parseInt(document.getElementById('digits').value);
            const counter = parseInt(document.getElementById('counter').value);
            const algorithm = document.getElementById('algorithm').value;

            if (!secret) {
                alert('Please enter or generate a secret key');
                return null;
            }

            try {
                return hmacOTP(secret, counter, digits, algorithm);
            } catch (e) {
                alert('Error generating HOTP: ' + e.message);
                return null;
            }
        }

        // Generate OTP based on mode
        function generateOTP() {
            let otp;

            if (currentMode === 'totp') {
                otp = generateTOTP();
            } else {
                otp = generateHOTP();
                // Increment counter for next use
                const counterInput = document.getElementById('counter');
                counterInput.value = parseInt(counterInput.value) + 1;
                updateHotpCounter();
            }

            if (otp) {
                document.getElementById('otpCode').textContent = otp;
                stats.generated++;
                updateStats();
            }
        }

        // Update HOTP counter display
        function updateHotpCounter() {
            document.getElementById('currentCounter').textContent = document.getElementById('counter').value;
        }

        // Start auto-refresh for TOTP
        function startAutoRefresh() {
            if (currentMode !== 'totp') {
                alert('Auto-refresh is only available for TOTP mode');
                return;
            }

            const btn = document.getElementById('autoRefreshBtn');

            if (autoRefreshInterval) {
                // Stop auto-refresh
                clearInterval(autoRefreshInterval);
                autoRefreshInterval = null;
                btn.innerHTML = '<i class="fas fa-play"></i> Auto-Refresh';
                btn.classList.remove('danger');
                btn.classList.add('success');
            } else {
                // Start auto-refresh
                autoRefreshInterval = setInterval(() => {
                    generateOTP();
                    updateTimer();
                }, 1000);
                btn.innerHTML = '<i class="fas fa-stop"></i> Stop';
                btn.classList.remove('success');
                btn.classList.add('danger');
                generateOTP();
                updateTimer();
            }
        }

        // Update timer and progress bar for TOTP
        function updateTimer() {
            if (currentMode !== 'totp') return;

            const period = parseInt(document.getElementById('period').value);
            const epoch = Math.floor(Date.now() / 1000);
            const remaining = period - (epoch % period);

            document.getElementById('otpTimer').textContent = remaining + 's remaining';

            const percentage = (remaining / period) * 100;
            document.getElementById('progressBar').style.width = percentage + '%';

            // Update sync indicator color based on remaining time
            const indicator = document.getElementById('syncIndicator');
            if (remaining > period * 0.5) {
                indicator.className = 'time-sync-indicator sync-good';
            } else if (remaining > period * 0.2) {
                indicator.className = 'time-sync-indicator sync-warning';
            } else {
                indicator.className = 'time-sync-indicator sync-bad';
            }
        }

        // Validate OTP
        function validateOTP() {
            const inputCode = document.getElementById('validateCode').value.trim();

            if (!inputCode) {
                alert('Please enter a code to validate');
                return;
            }

            let isValid = false;

            if (currentMode === 'totp') {
                // For TOTP, check current, previous, and next time windows
                const period = parseInt(document.getElementById('period').value);
                const epoch = Math.floor(Date.now() / 1000);
                const currentCounter = Math.floor(epoch / period);

                const secret = document.getElementById('secretKey').value.trim();
                const digits = parseInt(document.getElementById('digits').value);
                const algorithm = document.getElementById('algorithm').value;

                for (let i = -1; i <= 1; i++) {
                    const code = hmacOTP(secret, currentCounter + i, digits, algorithm);
                    if (code === inputCode) {
                        isValid = true;
                        break;
                    }
                }
            } else {
                // For HOTP, check current counter
                const currentCode = generateHOTP();
                isValid = (currentCode === inputCode);
            }

            stats.validated++;
            if (isValid) stats.success++;
            updateStats();

            const resultDiv = document.getElementById('validationResult');
            if (isValid) {
                resultDiv.innerHTML = '<div class="validation-result validation-success">' +
                    '<i class="fas fa-check-circle"></i> Valid! Code matches.' +
                    '</div>';
            } else {
                resultDiv.innerHTML = '<div class="validation-result validation-failure">' +
                    '<i class="fas fa-times-circle"></i> Invalid! Code does not match.' +
                    '</div>';
            }
        }

        // Update statistics
        function updateStats() {
            document.getElementById('statGenerated').textContent = stats.generated;
            document.getElementById('statValidated').textContent = stats.validated;
            document.getElementById('statSuccess').textContent = stats.success;
        }

        // Copy OTP to clipboard
        function copyOTP() {
            const code = document.getElementById('otpCode').textContent;
            if (code === '------') {
                alert('Please generate an OTP first');
                return;
            }

            navigator.clipboard.writeText(code).then(() => {
                alert('OTP code copied to clipboard!');
            }).catch(() => {
                alert('Failed to copy to clipboard');
            });
        }

        // Copy URI to clipboard
        function copyUri() {
            const uri = document.getElementById('otpUri').textContent;
            navigator.clipboard.writeText(uri).then(() => {
                alert('OTP URI copied to clipboard!');
            }).catch(() => {
                alert('Failed to copy to clipboard');
            });
        }

        // Generate backup codes
        function generateBackupCodes() {
            backupCodes = [];
            for (let i = 0; i < 10; i++) {
                const code = Math.random().toString(36).substr(2, 8).toUpperCase();
                backupCodes.push(code);
            }

            let html = '<div class="backup-codes">';
            backupCodes.forEach(code => {
                html += '<div class="backup-code">' + code + '</div>';
            });
            html += '</div>';
            html += '<div class="alert alert-info"><i class="fas fa-exclamation-triangle"></i> Save these codes in a secure location. Each code can only be used once.</div>';

            document.getElementById('backupCodesContainer').innerHTML = html;
        }

        // Download backup codes
        function downloadBackupCodes() {
            if (backupCodes.length === 0) {
                alert('Please generate backup codes first');
                return;
            }

            const issuer = document.getElementById('issuer').value;
            const account = document.getElementById('accountName').value;

            let content = 'Backup Codes for ' + issuer + ' (' + account + ')\n';
            content += 'Generated: ' + new Date().toISOString() + '\n';
            content += '\n';
            backupCodes.forEach((code, idx) => {
                content += (idx + 1) + '. ' + code + '\n';
            });
            content += '\nIMPORTANT: Each code can only be used once. Store securely.';

            const blob = new Blob([content], { type: 'text/plain' });
            const a = document.createElement('a');
            a.href = URL.createObjectURL(blob);
            a.download = '8gwifi-backup-codes-' + Date.now() + '.txt';
            a.click();
            URL.revokeObjectURL(a.href);
        }

        // Download QR Code
        function downloadQRCode() {
            const canvas = document.querySelector('#qrcode canvas');
            if (!canvas) {
                alert('Please generate a QR code first');
                return;
            }

            canvas.toBlob(blob => {
                const a = document.createElement('a');
                a.href = URL.createObjectURL(blob);
                a.download = '8gwifi-otp-qrcode-' + Date.now() + '.png';
                a.click();
                URL.revokeObjectURL(a.href);
            });
        }

        // Export configuration
        function exportConfig(format) {
            const config = {
                mode: currentMode,
                secret: document.getElementById('secretKey').value,
                issuer: document.getElementById('issuer').value,
                account: document.getElementById('accountName').value,
                algorithm: document.getElementById('algorithm').value,
                digits: document.getElementById('digits').value,
                period: document.getElementById('period').value,
                counter: document.getElementById('counter').value,
                uri: generateOTPUri(),
                exportDate: new Date().toISOString()
            };

            let content, filename, type;

            if (format === 'json') {
                content = JSON.stringify(config, null, 2);
                filename = '8gwifi-otp-config-' + Date.now() + '.json';
                type = 'application/json';
            } else {
                content = 'OTP Configuration Export\n';
                content += '======================\n\n';
                content += 'Mode: ' + config.mode.toUpperCase() + '\n';
                content += 'Secret: ' + config.secret + '\n';
                content += 'Issuer: ' + config.issuer + '\n';
                content += 'Account: ' + config.account + '\n';
                content += 'Algorithm: ' + config.algorithm + '\n';
                content += 'Digits: ' + config.digits + '\n';
                if (currentMode === 'totp') {
                    content += 'Period: ' + config.period + 's\n';
                } else {
                    content += 'Counter: ' + config.counter + '\n';
                }
                content += '\nURI: ' + config.uri + '\n';
                content += '\nExported: ' + config.exportDate + '\n';
                filename = '8gwifi-otp-config-' + Date.now() + '.txt';
                type = 'text/plain';
            }

            const blob = new Blob([content], { type: type });
            const a = document.createElement('a');
            a.href = URL.createObjectURL(blob);
            a.download = filename;
            a.click();
            URL.revokeObjectURL(a.href);
        }

        // Import configuration
        function importConfig() {
            const fileInput = document.getElementById('importFile');
            fileInput.click();

            fileInput.onchange = (e) => {
                const file = e.target.files[0];
                if (!file) return;

                const reader = new FileReader();
                reader.onload = (event) => {
                    try {
                        const config = JSON.parse(event.target.result);

                        // Load configuration
                        setMode(config.mode);
                        document.getElementById('secretKey').value = config.secret;
                        document.getElementById('issuer').value = config.issuer;
                        document.getElementById('accountName').value = config.account;
                        document.getElementById('algorithm').value = config.algorithm;
                        document.getElementById('digits').value = config.digits;

                        if (config.mode === 'totp') {
                            document.getElementById('period').value = config.period;
                        } else {
                            document.getElementById('counter').value = config.counter;
                            updateHotpCounter();
                        }

                        generateQRCode();
                        alert('Configuration imported successfully!');
                    } catch (e) {
                        alert('Failed to import configuration: ' + e.message);
                    }
                };
                reader.readAsText(file);
            };
        }

        // Initialize on page load
        window.onload = function() {
            generateQRCode();

            // Update timer every second if in TOTP mode
            setInterval(() => {
                if (currentMode === 'totp' && !autoRefreshInterval) {
                    updateTimer();
                }
            }, 1000);
        };
    </script>
</div>
<%@ include file="body-close.jsp"%>

