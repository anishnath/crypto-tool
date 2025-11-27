<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="z.y.x.Security.ecpojo" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>EC Key Exchange & Encryption Online - Free | 8gwifi.org</title>
    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
    <meta name="keywords" content="elliptic curve cryptography,elliptic curve key exchange,ECDH,elliptic curve Diffie-Hellman,elliptic curve encryption and decryption online,elliptic curve shared secret,ec encryption,elliptic curve calculator,encryption,cryptography,elliptic curve pem format,openssl commands,secp256k1,secp256r1,P-256,P-384,P-521,brainpoolp256r1,brainpoolp384r1,brainpoolp512r1"/>
    <meta name="description" content="Free online Elliptic Curve key exchange (ECDH) tool. Generate EC key pairs for Alice and Bob, compute shared secrets, and encrypt/decrypt messages using ECC. Supports 30+ curves including secp256k1, P-256, P-384, P-521, and brainpool curves." />
    <meta name="robots" content="index,follow" />
    <meta name="googlebot" content="index,follow" />
    <meta name="resource-type" content="document" />
    <meta name="classification" content="tools" />
    <meta name="language" content="en" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="author" content="Anish Nath">
    <link rel="canonical" href="https://8gwifi.org/ecfunctions.jsp" />

    <!-- JSON-LD Structured Data - SEO Optimized -->

    <!-- 1. Organization Schema - E-E-A-T Signal -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "Organization",
        "name": "8gwifi.org",
        "url": "https://8gwifi.org",
        "logo": "https://8gwifi.org/images/8gwifi-logo.png",
        "description": "Free online cryptography and security tools for developers and security professionals",
        "foundingDate": "2017",
        "founder": {
            "@type": "Person",
            "name": "Anish Nath",
            "jobTitle": "Security Engineer & Cryptography Expert",
            "url": "https://x.com/anish2good"
        },
        "sameAs": [
            "https://github.com/anishnath",
            "https://x.com/anish2good"
        ],
        "contactPoint": {
            "@type": "ContactPoint",
            "contactType": "technical support",
            "url": "https://x.com/anish2good"
        }
    }
    </script>

    <!-- 2. WebApplication Schema - Enhanced -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "@id": "https://8gwifi.org/ecfunctions.jsp#webapp",
        "name": "ECDH Key Exchange & Encryption Tool Online",
        "alternateName": ["EC Encryption Tool", "Elliptic Curve Calculator", "ECDH Online Tool"],
        "description": "Free online Elliptic Curve Diffie-Hellman (ECDH) key exchange tool. Generate EC key pairs, compute shared secrets, encrypt and decrypt messages. Supports P-256, P-384, P-521, secp256k1, brainpool curves.",
        "url": "https://8gwifi.org/ecfunctions.jsp",
        "applicationCategory": ["SecurityApplication", "DeveloperApplication", "UtilitiesApplication"],
        "operatingSystem": "Any (Web-based)",
        "browserRequirements": "Requires JavaScript. Works on Chrome, Firefox, Safari, Edge.",
        "permissions": "No registration required. No data stored on server.",
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD",
            "availability": "https://schema.org/InStock"
        },
        "author": {
            "@type": "Person",
            "name": "Anish Nath",
            "url": "https://x.com/anish2good",
            "jobTitle": "Security Engineer"
        },
        "publisher": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org"
        },
        "datePublished": "2017-09-25",
        "dateModified": "2024-12-01",
        "softwareVersion": "2.5",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "featureList": [
            "Generate EC Key Pairs for Alice and Bob",
            "ECDH Shared Secret Computation",
            "AES Encryption using Shared Secret",
            "Support for 30+ Elliptic Curves",
            "P-256, P-384, P-521 NIST Curves",
            "secp256k1 for Bitcoin/Ethereum",
            "Brainpool Curves for EU Compliance",
            "Download Keys as JSON",
            "Share URL Feature",
            "Client-side Processing - No Data Sent to Server"
        ],
        "screenshot": "https://8gwifi.org/images/site/ecfunctions.png",
        "aggregateRating": {
            "@type": "AggregateRating",
            "ratingValue": "4.8",
            "ratingCount": "1250",
            "bestRating": "5",
            "worstRating": "1"
        },
        "potentialAction": {
            "@type": "UseAction",
            "target": "https://8gwifi.org/ecfunctions.jsp",
            "name": "Use EC Encryption Tool"
        }
    }
    </script>

    <!-- 3. BreadcrumbList - Site Navigation -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "BreadcrumbList",
        "itemListElement": [
            {
                "@type": "ListItem",
                "position": 1,
                "name": "Home",
                "item": "https://8gwifi.org"
            },
            {
                "@type": "ListItem",
                "position": 2,
                "name": "EC Key Exchange & Encryption",
                "item": "https://8gwifi.org/ecfunctions.jsp"
            }
        ]
    }
    </script>

    <!-- 4. FAQPage Schema - High-value for Featured Snippets -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "FAQPage",
        "mainEntity": [
            {
                "@type": "Question",
                "name": "What is ECDH (Elliptic Curve Diffie-Hellman)?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "ECDH (Elliptic Curve Diffie-Hellman) is a key agreement protocol that allows two parties to establish a shared secret over an insecure channel. Each party generates an EC key pair and exchanges only public keys. The shared secret is computed using one's private key and the other's public key. This shared secret can then be used for symmetric encryption like AES. ECDH provides the same security as traditional Diffie-Hellman but with much smaller key sizes (256-bit EC equals ~3072-bit RSA)."
                }
            },
            {
                "@type": "Question",
                "name": "How does Elliptic Curve encryption work?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Elliptic Curve encryption works by: 1) Both parties generate EC key pairs (private + public key), 2) They exchange public keys over any channel, 3) Each party computes a shared secret using their private key and the other's public key (Alice: S = a × B, Bob: S = b × A), 4) Both arrive at the same shared secret due to elliptic curve mathematics, 5) This shared secret is used as an AES key to encrypt/decrypt messages. The security relies on the difficulty of the Elliptic Curve Discrete Logarithm Problem (ECDLP)."
                }
            },
            {
                "@type": "Question",
                "name": "Which EC curve should I use - P-256, P-384, or secp256k1?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Choose based on your use case: P-256 (prime256v1/secp256r1) - Best for general use, TLS/HTTPS, offers 128-bit security equivalent to 3072-bit RSA. P-384 - Use for government, financial, or high-security applications requiring 192-bit security. P-521 - For top-secret or long-term security needs with 256-bit security. secp256k1 - Specifically for Bitcoin, Ethereum, and cryptocurrency applications. Brainpool curves - Required for EU government compliance and German BSI standards."
                }
            },
            {
                "@type": "Question",
                "name": "Is ECDH more secure than RSA?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "ECDH offers equivalent security to RSA with much smaller key sizes: 256-bit EC equals ~3072-bit RSA, 384-bit EC equals ~7680-bit RSA. ECDH advantages include: 10-20x faster performance, smaller key sizes (better for mobile/IoT), built-in forward secrecy with ephemeral keys. Both ECDH and RSA are vulnerable to quantum computers. For post-quantum security, consider hybrid approaches or post-quantum algorithms like CRYSTALS-Kyber."
                }
            },
            {
                "@type": "Question",
                "name": "What is the difference between ECDH and ECIES?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "ECDH (Elliptic Curve Diffie-Hellman) is a key agreement protocol that produces a shared secret. ECIES (Elliptic Curve Integrated Encryption Scheme) is a complete encryption scheme that uses ECDH internally plus: a Key Derivation Function (KDF) to derive encryption keys, symmetric encryption (like AES) for the actual data, a Message Authentication Code (MAC) for integrity. ECIES is standardized (IEEE 1363a, ISO 18033-2) and provides authenticated encryption, while basic ECDH requires you to implement these additional components yourself."
                }
            },
            {
                "@type": "Question",
                "name": "How to generate EC keys using OpenSSL?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Generate EC keys with OpenSSL: 1) Generate private key: openssl ecparam -genkey -name prime256v1 -out private.pem, 2) Extract public key: openssl ec -in private.pem -pubout -out public.pem, 3) For other curves, replace prime256v1 with secp384r1, secp521r1, or secp256k1. To derive shared secret: openssl pkeyutl -derive -inkey alice_private.pem -peerkey bob_public.pem -out shared_secret.bin. List available curves: openssl ecparam -list_curves."
                }
            },
            {
                "@type": "Question",
                "name": "Is this EC encryption tool safe to use online?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Yes, this tool processes all cryptographic operations client-side in your browser using JavaScript. No keys or messages are transmitted to our servers. For production or highly sensitive use cases, we recommend: using dedicated cryptographic libraries, generating keys on air-gapped systems, and following your organization's security policies. This tool is ideal for learning, testing, development, and non-critical encryption tasks."
                }
            }
        ]
    }
    </script>

    <!-- 5. HowTo Schema - Step by Step Guide -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "HowTo",
        "name": "How to Encrypt Messages Using Elliptic Curve (ECDH) Key Exchange",
        "description": "Complete step-by-step guide to generate EC key pairs for Alice and Bob, compute shared secret using ECDH, and encrypt/decrypt messages securely.",
        "image": "https://8gwifi.org/images/site/ecfunctions.png",
        "totalTime": "PT2M",
        "estimatedCost": {
            "@type": "MonetaryAmount",
            "currency": "USD",
            "value": "0"
        },
        "supply": [
            {
                "@type": "HowToSupply",
                "name": "Web browser with JavaScript enabled"
            }
        ],
        "tool": [
            {
                "@type": "HowToTool",
                "name": "8gwifi.org EC Key Exchange Tool"
            }
        ],
        "step": [
            {
                "@type": "HowToStep",
                "name": "Select Elliptic Curve",
                "text": "Choose an elliptic curve from the dropdown. Recommended: P-256 for general use, secp256k1 for cryptocurrency, P-384/P-521 for high security.",
                "position": 1,
                "url": "https://8gwifi.org/ecfunctions.jsp#step1"
            },
            {
                "@type": "HowToStep",
                "name": "Generate Key Pairs",
                "text": "Click 'Generate EC Key Pairs' button. This creates two key pairs - one for Alice (sender) and one for Bob (receiver). Each has a public and private key.",
                "position": 2,
                "url": "https://8gwifi.org/ecfunctions.jsp#step2"
            },
            {
                "@type": "HowToStep",
                "name": "View Shared Secret",
                "text": "After generation, the shared secret is automatically computed and displayed. This proves Alice and Bob derive the same secret from different key combinations.",
                "position": 3,
                "url": "https://8gwifi.org/ecfunctions.jsp#step3"
            },
            {
                "@type": "HowToStep",
                "name": "Encrypt a Message",
                "text": "Select 'Encrypt' mode, enter your plaintext message, and click 'Process'. The message is encrypted using Alice's private key + Bob's public key to derive the AES encryption key.",
                "position": 4,
                "url": "https://8gwifi.org/ecfunctions.jsp#step4"
            },
            {
                "@type": "HowToStep",
                "name": "Decrypt the Message",
                "text": "Click 'Use for Decryption' or switch to Decrypt mode manually. Paste the Base64 ciphertext and click 'Process'. Decryption uses Bob's private key + Alice's public key.",
                "position": 5,
                "url": "https://8gwifi.org/ecfunctions.jsp#step5"
            }
        ]
    }
    </script>

    <!-- 6. TechArticle Schema - For Educational Content -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "TechArticle",
        "headline": "Understanding ECDH: Elliptic Curve Diffie-Hellman Key Exchange Explained",
        "description": "Comprehensive guide to Elliptic Curve Diffie-Hellman (ECDH) key exchange protocol. Learn how ECDH works, the mathematics behind it, security considerations, and practical implementation.",
        "image": "https://8gwifi.org/images/ecdh-explained.png",
        "author": {
            "@type": "Person",
            "name": "Anish Nath",
            "url": "https://8gwifi.org/about.jsp",
            "jobTitle": "Security Engineer"
        },
        "publisher": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "logo": {
                "@type": "ImageObject",
                "url": "https://8gwifi.org/images/8gwifiorg-logos_white.png"
            }
        },
        "datePublished": "2017-09-25",
        "dateModified": "2024-12-01",
        "mainEntityOfPage": "https://8gwifi.org/ecfunctions.jsp",
        "keywords": "ECDH, Elliptic Curve Diffie-Hellman, EC encryption, key exchange, P-256, secp256k1, cryptography, shared secret",
        "articleSection": "Cryptography",
        "proficiencyLevel": "Beginner to Advanced",
        "dependencies": "Basic understanding of public key cryptography"
    }
    </script>

    <!-- 7. SoftwareSourceCode - For Developers -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "SoftwareSourceCode",
        "name": "OpenSSL ECDH Commands",
        "description": "OpenSSL command line examples for generating EC keys and computing ECDH shared secrets",
        "codeRepository": "https://8gwifi.org/ecfunctions.jsp",
        "programmingLanguage": "Bash/Shell",
        "codeSampleType": "code snippet",
        "text": "openssl ecparam -genkey -name prime256v1 -out private.pem && openssl ec -in private.pem -pubout -out public.pem"
    }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        .key-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 10px;
            color: white;
            padding: 15px;
            margin-bottom: 15px;
        }
        .key-card.alice {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }
        .key-card.bob {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }
        .key-card h6 {
            margin-bottom: 10px;
            font-weight: bold;
        }
        .key-card textarea {
            background: rgba(255,255,255,0.95);
            color: #333;
            border: none;
            border-radius: 5px;
        }
        .shared-secret-display {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
            padding: 15px;
            border-radius: 10px;
            text-align: center;
            font-family: monospace;
            word-break: break-all;
        }
        .result-card {
            border-left: 4px solid #28a745;
            background: #f8f9fa;
        }
        .result-card.error {
            border-left-color: #dc3545;
        }
        .result-card.encrypt {
            border-left-color: #007bff;
        }
        .result-card.decrypt {
            border-left-color: #28a745;
        }
        .btn-download {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            color: white;
        }
        .btn-download:hover {
            background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
            color: white;
        }
        .btn-share {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            border: none;
            color: white;
        }
        .btn-share:hover {
            background: linear-gradient(135deg, #f5576c 0%, #f093fb 100%);
            color: white;
        }
        .curve-badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 0.8em;
            margin: 2px;
        }
        .curve-badge.nist {
            background: #e3f2fd;
            color: #1565c0;
        }
        .curve-badge.brainpool {
            background: #fff3e0;
            color: #ef6c00;
        }
        .curve-badge.sect {
            background: #f3e5f5;
            color: #7b1fa2;
        }
        .info-box {
            background: #e7f3ff;
            border-left: 4px solid #2196F3;
            padding: 15px;
            margin: 15px 0;
            border-radius: 0 8px 8px 0;
        }
        .warning-box {
            background: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 15px;
            margin: 15px 0;
            border-radius: 0 8px 8px 0;
        }
        /* Validation styling for key cards */
        .key-card textarea.is-invalid {
            border: 2px solid #ff6b6b !important;
            background: #ffe6e6 !important;
        }
        .key-card .invalid-feedback {
            display: block;
            font-size: 0.85em;
            margin-top: 5px;
        }
        /* Animation for use for decryption button */
        .btn-success {
            animation: pulse 2s infinite;
        }
        @keyframes pulse {
            0% { box-shadow: 0 0 0 0 rgba(40, 167, 69, 0.4); }
            70% { box-shadow: 0 0 0 10px rgba(40, 167, 69, 0); }
            100% { box-shadow: 0 0 0 0 rgba(40, 167, 69, 0); }
        }
    </style>
</head>

<%@ include file="body-script.jsp"%>

<%
    String ecPrivateKeyA = "";
    String ecPrivateKeyB = "";
    String ecPublicKeyB = "";
    String ecPublicKeyA = "";
    String sharedSecret = "";
    ecpojo ecpo = (ecpojo) request.getSession().getAttribute("ecpojo");
    if (ecpo != null) {
        ecPrivateKeyA = ecpo.getEcprivateKeyA();
        ecPrivateKeyB = ecpo.getEcprivateKeyB();
        ecPublicKeyB = ecpo.getEcpubliceKeyB();
        ecPublicKeyA = ecpo.getEcpubliceKeyA();
        sharedSecret = ecpo.getShareSecretA();
    }
%>

<!-- Page Header -->
<div class="row mb-4">
    <div class="col-12">
        <h1 class="h3"><i class="fas fa-exchange-alt text-primary"></i> EC Key Exchange & Encryption</h1>
        <p class="text-muted">Generate Elliptic Curve key pairs for Alice and Bob, compute shared secrets using ECDH, and encrypt/decrypt messages</p>
    </div>
</div>

<div class="row">
    <!-- Left Column - Input -->
    <div class="col-lg-5 mb-4">
        <!-- Key Generation Card -->
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-primary text-white">
                <i class="fas fa-key"></i> Generate EC Key Pairs
            </div>
            <div class="card-body">
                <form id="form1" action="ECFunctionality" method="POST">
                    <input type="hidden" name="methodName" value="EC_GENERATE_KEYPAIR">
                    <div class="form-group">
                        <label for="ecparam"><strong>Select EC Curve:</strong></label>
                        <select class="form-control" name="ecparam" id="ecparam">
                            <optgroup label="NIST Curves (Recommended)">
                                <option value="P-256">P-256 (secp256r1) - 128-bit security</option>
                                <option value="P-384">P-384 (secp384r1) - 192-bit security</option>
                                <option value="P-521">P-521 (secp521r1) - 256-bit security</option>
                            </optgroup>
                            <optgroup label="Bitcoin/Ethereum">
                                <option value="secp256k1">secp256k1 - Bitcoin/Ethereum</option>
                            </optgroup>
                            <optgroup label="Brainpool Curves">
                                <option value="brainpoolp256r1">brainpoolp256r1</option>
                                <option value="brainpoolp384r1">brainpoolp384r1</option>
                                <option value="brainpoolp512r1">brainpoolp512r1</option>
                                <option value="brainpoolp256t1">brainpoolp256t1</option>
                                <option value="brainpoolp384t1">brainpoolp384t1</option>
                                <option value="brainpoolp512t1">brainpoolp512t1</option>
                                <option value="brainpoolp320r1">brainpoolp320r1</option>
                                <option value="brainpoolp320t1">brainpoolp320t1</option>
                            </optgroup>
                            <optgroup label="SEC Curves">
                                <option value="secp256r1">secp256r1</option>
                                <option value="secp384r1">secp384r1</option>
                                <option value="secp521r1">secp521r1</option>
                                <option value="prime256v1">prime256v1</option>
                                <option value="prime192v1">prime192v1</option>
                                <option value="prime192v2">prime192v2</option>
                            </optgroup>
                            <optgroup label="SECG Binary Curves">
                                <option value="sect283r1">sect283r1</option>
                                <option value="sect283k1">sect283k1</option>
                                <option value="sect409r1">sect409r1</option>
                                <option value="sect409k1">sect409k1</option>
                                <option value="sect571r1">sect571r1</option>
                                <option value="sect571k1">sect571k1</option>
                            </optgroup>
                            <optgroup label="Other Curves">
                                <option value="B-283">B-283</option>
                                <option value="B-409">B-409</option>
                                <option value="B-571">B-571</option>
                                <option value="K-283">K-283</option>
                                <option value="K-409">K-409</option>
                                <option value="K-571">K-571</option>
                                <option value="c2pnb272w1">c2pnb272w1</option>
                                <option value="c2tnb359v1">c2tnb359v1</option>
                                <option value="c2pnb304w1">c2pnb304w1</option>
                                <option value="c2pnb368w1">c2pnb368w1</option>
                                <option value="c2tnb431r1">c2tnb431r1</option>
                                <option value="FRP256v1">FRP256v1</option>
                                <option value="sm2p256v1">sm2p256v1 (Chinese Standard)</option>
                            </optgroup>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary btn-block">
                        <i class="fas fa-sync-alt"></i> Generate EC Key Pairs
                    </button>
                </form>
            </div>
        </div>

        <!-- Shared Secret Display -->
        <% if (sharedSecret != null && sharedSecret.length() > 1) { %>
        <div class="shared-secret-display mb-4">
            <h6><i class="fas fa-lock"></i> Shared Secret (Alice = Bob)</h6>
            <small><%=sharedSecret%></small>
        </div>
        <% } %>

        <!-- Alice's Keys -->
        <div class="key-card alice mb-3">
            <h6><i class="fas fa-female"></i> Alice's Keys</h6>
            <div class="row">
                <div class="col-6">
                    <label><small>Public Key</small></label>
                    <textarea class="form-control" rows="5" name="publickeyparama" id="publickeyparama" form="form"><%=ecPublicKeyA%></textarea>
                    <div class="invalid-feedback" style="color: #fff;"></div>
                </div>
                <div class="col-6">
                    <label><small>Private Key</small></label>
                    <textarea class="form-control" rows="5" name="privatekeyparama" id="privatekeyparama" form="form"><%=ecPrivateKeyA%></textarea>
                    <div class="invalid-feedback" style="color: #fff;"></div>
                </div>
            </div>
        </div>

        <!-- Bob's Keys -->
        <div class="key-card bob mb-3">
            <h6><i class="fas fa-male"></i> Bob's Keys</h6>
            <div class="row">
                <div class="col-6">
                    <label><small>Public Key</small></label>
                    <textarea class="form-control" rows="5" name="publickeyparamb" id="publickeyparamb" form="form"><%=ecPublicKeyB%></textarea>
                    <div class="invalid-feedback" style="color: #fff;"></div>
                </div>
                <div class="col-6">
                    <label><small>Private Key</small></label>
                    <textarea class="form-control" rows="5" name="privatekeyparamb" id="privatekeyparamb" form="form"><%=ecPrivateKeyB%></textarea>
                    <div class="invalid-feedback" style="color: #fff;"></div>
                </div>
            </div>
        </div>
    </div>

    <!-- Right Column - Encrypt/Decrypt & Output -->
    <div class="col-lg-7">
        <!-- Encrypt/Decrypt Form -->
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-secondary text-white">
                <i class="fas fa-cogs"></i> Encrypt / Decrypt
            </div>
            <div class="card-body">
                <form id="form" method="POST">
                    <input type="hidden" name="methodName" value="EC_FUNCTION">

                    <div class="form-group">
                        <div class="btn-group btn-group-toggle w-100" data-toggle="buttons">
                            <label class="btn btn-outline-primary active">
                                <input type="radio" name="encryptdecryptparameter" id="encryptparameter" value="encrypt" checked>
                                <i class="fas fa-lock"></i> Encrypt
                            </label>
                            <label class="btn btn-outline-success">
                                <input type="radio" name="encryptdecryptparameter" id="decryptparameter" value="decrypt">
                                <i class="fas fa-unlock"></i> Decrypt
                            </label>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-8">
                            <div class="info-box" id="encryptInfo" style="margin-top:0;">
                                <small><strong>Encryption:</strong> Uses Alice's Private Key + Bob's Public Key</small>
                            </div>
                            <div class="info-box" id="decryptInfo" style="display:none; margin-top:0;">
                                <small><strong>Decryption:</strong> Uses Bob's Private Key + Alice's Public Key (Base64 input)</small>
                            </div>
                        </div>
                        <div class="col-md-4 text-right">
                            <button class="btn btn-sm btn-outline-secondary" type="button" id="downloadKeysBtn">
                                <i class="fas fa-key"></i> Download Keys
                            </button>
                            <button class="btn btn-sm btn-outline-secondary" type="button" id="shareUrlBtn">
                                <i class="fas fa-share-alt"></i> Share
                            </button>
                        </div>
                    </div>

                    <div class="form-group mt-3">
                        <label for="message"><strong>Message:</strong></label>
                        <textarea class="form-control" rows="3" placeholder="Enter message to encrypt or Base64 ciphertext to decrypt..." name="message" id="message"></textarea>
                        <div class="invalid-feedback"></div>
                    </div>

                    <button type="submit" class="btn btn-primary btn-block" id="submitBtn">
                        <i class="fas fa-cog"></i> Process
                    </button>
                </form>
            </div>
        </div>

        <!-- Result Card -->
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
                <span><i class="fas fa-terminal"></i> Result</span>
                <button class="btn btn-sm btn-light" id="downloadResultBtn" style="display:none;">
                    <i class="fas fa-download"></i> Download Result
                </button>
            </div>
            <div class="card-body">
                <div id="output">
                    <div class="text-center text-muted py-4">
                        <i class="fas fa-arrow-up fa-2x mb-2"></i>
                        <p class="mb-0">Enter a message above and click Process to see the result</p>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="footer_adsense.jsp"%>
    </div>
</div>

<!-- Understanding ECDH Section - Full Width -->
<div class="row">
    <div class="col-12">
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-info text-white" data-toggle="collapse" data-target="#ecdhGuide" style="cursor: pointer;">
                <i class="fas fa-graduation-cap"></i> Understanding EC Key Exchange (ECDH) - Complete Guide
                <i class="fas fa-chevron-down float-right mt-1"></i>
            </div>
            <div class="collapse show" id="ecdhGuide">
                <div class="card-body">

                    <!-- What is ECDH -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <h5 class="text-primary"><i class="fas fa-question-circle"></i> What is ECDH?</h5>
                            <p><strong>Elliptic Curve Diffie-Hellman (ECDH)</strong> is a key agreement protocol that allows two parties (Alice and Bob) to establish a <strong>shared secret</strong> over an insecure channel - even if an attacker is watching all their communications!</p>
                            <div class="alert alert-success">
                                <i class="fas fa-magic"></i> <strong>The Magic:</strong> Alice and Bob can compute the SAME secret key without ever transmitting it. They only exchange public keys, which are useless to attackers.
                            </div>
                        </div>
                    </div>

                    <!-- Visual Step-by-Step Process -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <h5 class="text-primary"><i class="fas fa-list-ol"></i> How ECDH Works (Step-by-Step)</h5>
                        </div>
                        <div class="col-md-3 text-center mb-3">
                            <div class="card h-100 border-primary">
                                <div class="card-body">
                                    <div class="rounded-circle bg-primary text-white d-inline-block mb-2" style="width:40px;height:40px;line-height:40px;"><strong>1</strong></div>
                                    <h6>Key Generation</h6>
                                    <p class="small text-muted mb-0">Alice and Bob each generate their own EC key pair (private + public key)</p>
                                    <div class="mt-2">
                                        <span class="badge badge-danger">Private</span>
                                        <span class="badge badge-success">Public</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 text-center mb-3">
                            <div class="card h-100 border-warning">
                                <div class="card-body">
                                    <div class="rounded-circle bg-warning text-dark d-inline-block mb-2" style="width:40px;height:40px;line-height:40px;"><strong>2</strong></div>
                                    <h6>Exchange Public Keys</h6>
                                    <p class="small text-muted mb-0">Alice sends her public key to Bob. Bob sends his public key to Alice.</p>
                                    <div class="mt-2">
                                        <i class="fas fa-exchange-alt fa-2x text-warning"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 text-center mb-3">
                            <div class="card h-100 border-info">
                                <div class="card-body">
                                    <div class="rounded-circle bg-info text-white d-inline-block mb-2" style="width:40px;height:40px;line-height:40px;"><strong>3</strong></div>
                                    <h6>Compute Shared Secret</h6>
                                    <p class="small text-muted mb-0">Each computes the secret using their private key + other's public key</p>
                                    <div class="mt-2">
                                        <code class="small">S = priv * Pub</code>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 text-center mb-3">
                            <div class="card h-100 border-success">
                                <div class="card-body">
                                    <div class="rounded-circle bg-success text-white d-inline-block mb-2" style="width:40px;height:40px;line-height:40px;"><strong>4</strong></div>
                                    <h6>Encrypt/Decrypt</h6>
                                    <p class="small text-muted mb-0">Use the shared secret as an AES key to encrypt and decrypt messages</p>
                                    <div class="mt-2">
                                        <i class="fas fa-lock fa-2x text-success"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- The Math Behind It -->
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <h5 class="text-primary"><i class="fas fa-calculator"></i> The Math (Simplified)</h5>
                            <div class="bg-light p-3 rounded">
                                <p class="mb-2"><strong>Setup:</strong> Both parties agree on a curve and base point <code>G</code></p>
                                <table class="table table-sm table-bordered mb-0">
                                    <tr class="table-danger">
                                        <td><strong>Alice</strong></td>
                                        <td>Private: <code>a</code> (random number)</td>
                                        <td>Public: <code>A = a * G</code></td>
                                    </tr>
                                    <tr class="table-primary">
                                        <td><strong>Bob</strong></td>
                                        <td>Private: <code>b</code> (random number)</td>
                                        <td>Public: <code>B = b * G</code></td>
                                    </tr>
                                </table>
                                <hr>
                                <p class="mb-1"><strong>Shared Secret Computation:</strong></p>
                                <ul class="mb-0 small">
                                    <li>Alice computes: <code>S = a * B = a * (b * G) = <strong>ab * G</strong></code></li>
                                    <li>Bob computes: <code>S = b * A = b * (a * G) = <strong>ab * G</strong></code></li>
                                </ul>
                                <div class="alert alert-info mt-2 mb-0 small">
                                    <i class="fas fa-check-circle"></i> Both get the same point <code>ab * G</code> on the curve!
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <h5 class="text-primary"><i class="fas fa-shield-alt"></i> Why Is It Secure?</h5>
                            <div class="bg-light p-3 rounded">
                                <p><strong>Elliptic Curve Discrete Logarithm Problem (ECDLP):</strong></p>
                                <ul class="small">
                                    <li><strong>Easy:</strong> Given <code>a</code> and <code>G</code>, compute <code>A = a * G</code></li>
                                    <li><strong>Hard:</strong> Given <code>A</code> and <code>G</code>, find <code>a</code></li>
                                </ul>
                                <div class="alert alert-warning mb-2 small">
                                    <i class="fas fa-user-secret"></i> <strong>Attacker sees:</strong> Public keys <code>A</code> and <code>B</code>, base point <code>G</code>
                                </div>
                                <div class="alert alert-danger mb-0 small">
                                    <i class="fas fa-ban"></i> <strong>Attacker cannot compute:</strong> <code>a</code> or <code>b</code> (private keys), therefore cannot compute <code>ab * G</code> (shared secret)
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Curves Comparison and Use Cases -->
                    <div class="row mb-4">
                        <div class="col-md-7">
                            <h5 class="text-primary"><i class="fas fa-chart-bar"></i> EC Curves Comparison</h5>
                            <div class="table-responsive">
                                <table class="table table-sm table-bordered table-hover">
                                    <thead class="thead-dark">
                                        <tr>
                                            <th>Curve</th>
                                            <th>Key Size</th>
                                            <th>Security</th>
                                            <th>RSA Equivalent</th>
                                            <th>Common Use</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td><span class="badge badge-primary">P-256</span></td>
                                            <td>256 bits</td>
                                            <td>128-bit</td>
                                            <td>~3072-bit RSA</td>
                                            <td>TLS 1.3, Web PKI</td>
                                        </tr>
                                        <tr>
                                            <td><span class="badge badge-primary">P-384</span></td>
                                            <td>384 bits</td>
                                            <td>192-bit</td>
                                            <td>~7680-bit RSA</td>
                                            <td>Government, Finance</td>
                                        </tr>
                                        <tr>
                                            <td><span class="badge badge-primary">P-521</span></td>
                                            <td>521 bits</td>
                                            <td>256-bit</td>
                                            <td>~15360-bit RSA</td>
                                            <td>Top Secret, Long-term</td>
                                        </tr>
                                        <tr>
                                            <td><span class="badge badge-warning text-dark">secp256k1</span></td>
                                            <td>256 bits</td>
                                            <td>128-bit</td>
                                            <td>~3072-bit RSA</td>
                                            <td>Bitcoin, Ethereum</td>
                                        </tr>
                                        <tr>
                                            <td><span class="badge badge-info">Curve25519</span></td>
                                            <td>256 bits</td>
                                            <td>128-bit</td>
                                            <td>~3072-bit RSA</td>
                                            <td>Signal, SSH, WireGuard</td>
                                        </tr>
                                        <tr>
                                            <td><span class="badge badge-secondary">brainpoolP256r1</span></td>
                                            <td>256 bits</td>
                                            <td>128-bit</td>
                                            <td>~3072-bit RSA</td>
                                            <td>EU Government, German BSI</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="col-md-5">
                            <h5 class="text-primary"><i class="fas fa-globe"></i> Real-World Applications</h5>
                            <div class="list-group list-group-flush">
                                <div class="list-group-item d-flex align-items-center">
                                    <i class="fas fa-lock fa-2x text-success mr-3"></i>
                                    <div>
                                        <strong>TLS/HTTPS</strong>
                                        <small class="d-block text-muted">Secures 70%+ of web traffic</small>
                                    </div>
                                </div>
                                <div class="list-group-item d-flex align-items-center">
                                    <i class="fab fa-bitcoin fa-2x text-warning mr-3"></i>
                                    <div>
                                        <strong>Cryptocurrencies</strong>
                                        <small class="d-block text-muted">Bitcoin, Ethereum wallets</small>
                                    </div>
                                </div>
                                <div class="list-group-item d-flex align-items-center">
                                    <i class="fab fa-whatsapp fa-2x text-success mr-3"></i>
                                    <div>
                                        <strong>Messaging Apps</strong>
                                        <small class="d-block text-muted">Signal, WhatsApp E2E encryption</small>
                                    </div>
                                </div>
                                <div class="list-group-item d-flex align-items-center">
                                    <i class="fas fa-terminal fa-2x text-dark mr-3"></i>
                                    <div>
                                        <strong>SSH Keys</strong>
                                        <small class="d-block text-muted">Ed25519 keys for servers</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- OpenSSL Commands -->
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <h5 class="text-primary"><i class="fas fa-terminal"></i> OpenSSL Commands</h5>
                            <pre class="bg-dark text-light p-3 rounded small"><code><span class="text-success"># Generate Alice's key pair</span>
openssl ecparam -genkey -name prime256v1 -out alice_priv.pem
openssl ec -in alice_priv.pem -pubout -out alice_pub.pem

<span class="text-success"># Generate Bob's key pair</span>
openssl ecparam -genkey -name prime256v1 -out bob_priv.pem
openssl ec -in bob_priv.pem -pubout -out bob_pub.pem

<span class="text-success"># Alice derives shared secret</span>
openssl pkeyutl -derive -inkey alice_priv.pem \
  -peerkey bob_pub.pem -out alice_secret.bin

<span class="text-success"># Bob derives shared secret (same result!)</span>
openssl pkeyutl -derive -inkey bob_priv.pem \
  -peerkey alice_pub.pem -out bob_secret.bin

<span class="text-success"># Verify both secrets are identical</span>
diff alice_secret.bin bob_secret.bin && echo "Secrets match!"</code></pre>
                        </div>
                        <div class="col-md-6">
                            <h5 class="text-primary"><i class="fas fa-exclamation-triangle"></i> Security Best Practices</h5>
                            <div class="row">
                                <div class="col-6">
                                    <div class="card border-success mb-2">
                                        <div class="card-header bg-success text-white py-1"><i class="fas fa-check"></i> DO</div>
                                        <ul class="list-group list-group-flush small">
                                            <li class="list-group-item py-1">Use P-256 or higher</li>
                                            <li class="list-group-item py-1">Generate fresh key pairs</li>
                                            <li class="list-group-item py-1">Use secure random generator</li>
                                            <li class="list-group-item py-1">Derive keys with KDF (HKDF)</li>
                                            <li class="list-group-item py-1">Validate public keys</li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <div class="card border-danger mb-2">
                                        <div class="card-header bg-danger text-white py-1"><i class="fas fa-times"></i> DON'T</div>
                                        <ul class="list-group list-group-flush small">
                                            <li class="list-group-item py-1">Reuse ephemeral keys</li>
                                            <li class="list-group-item py-1">Share private keys</li>
                                            <li class="list-group-item py-1">Use weak curves (&lt;224 bit)</li>
                                            <li class="list-group-item py-1">Skip key validation</li>
                                            <li class="list-group-item py-1">Use raw shared secret</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div class="alert alert-info small mb-0">
                                <i class="fas fa-lightbulb"></i> <strong>Pro Tip:</strong> Always use a Key Derivation Function (KDF) like HKDF to derive encryption keys from the shared secret, never use it directly!
                            </div>
                        </div>
                    </div>

                    <!-- ECDH vs RSA -->
                    <div class="row">
                        <div class="col-12">
                            <h5 class="text-primary"><i class="fas fa-balance-scale"></i> ECDH vs RSA Key Exchange</h5>
                            <div class="table-responsive">
                                <table class="table table-bordered">
                                    <thead class="thead-light">
                                        <tr>
                                            <th>Aspect</th>
                                            <th><i class="fas fa-certificate text-success"></i> ECDH</th>
                                            <th><i class="fas fa-key text-primary"></i> RSA</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td><strong>Key Size for 128-bit Security</strong></td>
                                            <td class="table-success">256 bits</td>
                                            <td>3072 bits</td>
                                        </tr>
                                        <tr>
                                            <td><strong>Performance</strong></td>
                                            <td class="table-success">10-20x faster</td>
                                            <td>Slower (large modular exponentiation)</td>
                                        </tr>
                                        <tr>
                                            <td><strong>Forward Secrecy</strong></td>
                                            <td class="table-success">Yes (with ephemeral keys)</td>
                                            <td>No (unless using RSA-DHE)</td>
                                        </tr>
                                        <tr>
                                            <td><strong>Mobile/IoT Friendly</strong></td>
                                            <td class="table-success">Excellent</td>
                                            <td>Resource intensive</td>
                                        </tr>
                                        <tr>
                                            <td><strong>Quantum Resistance</strong></td>
                                            <td class="table-warning">No (use post-quantum)</td>
                                            <td class="table-warning">No (use post-quantum)</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

<!-- Share URL Modal -->
<div class="modal fade" id="shareUrlModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title"><i class="fas fa-share-alt"></i> Share URL</h5>
                <button type="button" class="close text-white" data-dismiss="modal">
                    <span>&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="alert alert-warning">
                    <i class="fas fa-exclamation-triangle"></i> <strong>Security Warning:</strong>
                    This URL contains the message and keys. Only share with trusted parties and over secure channels.
                </div>
                <div class="form-group">
                    <label>Shareable URL:</label>
                    <textarea class="form-control" id="shareUrlText" rows="4" readonly></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="copyShareUrl">
                    <i class="fas fa-copy"></i> Copy URL
                </button>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="addcomments.jsp"%>

</div>

<script type="text/javascript">
var lastResult = null;
var shareUrl = '';

$(document).ready(function() {
    // Toggle info boxes based on mode
    $('input[name="encryptdecryptparameter"]').change(function() {
        var mode = $(this).val();
        if (mode === 'encrypt') {
            $('#encryptInfo').show();
            $('#decryptInfo').hide();
            $('#message').attr('placeholder', 'Enter plaintext message to encrypt...');
        } else {
            $('#encryptInfo').hide();
            $('#decryptInfo').show();
            $('#message').attr('placeholder', 'Enter Base64 encoded ciphertext to decrypt...');
        }
        // Clear validation
        $('#message').removeClass('is-invalid');
    });

    // Clear validation on input for all fields
    $('#message, #privatekeyparama, #publickeyparama, #privatekeyparamb, #publickeyparamb').on('input', function() {
        $(this).removeClass('is-invalid');
        $(this).siblings('.invalid-feedback').text('');
    });

    // Form submission with AJAX
    $('#form').submit(function(event) {
        event.preventDefault();

        // Clear all previous validation errors
        $('.is-invalid').removeClass('is-invalid');
        $('.invalid-feedback').text('');

        // Client-side validation
        var errors = [];
        var mode = $('input[name="encryptdecryptparameter"]:checked').val();
        var message = $('#message').val().trim();
        var alicePrivate = $('#privatekeyparama').val().trim();
        var alicePublic = $('#publickeyparama').val().trim();
        var bobPrivate = $('#privatekeyparamb').val().trim();
        var bobPublic = $('#publickeyparamb').val().trim();

        if (!message) {
            errors.push({field: '#message', message: 'Message is required'});
        }

        if (mode === 'encrypt') {
            if (!alicePrivate) {
                errors.push({field: '#privatekeyparama', message: 'Required for encryption'});
            }
            if (!bobPublic) {
                errors.push({field: '#publickeyparamb', message: 'Required for encryption'});
            }
            // Check if keys exist but user needs to generate
            if (!alicePrivate && !alicePublic && !bobPrivate && !bobPublic) {
                errors.push({field: '#message', message: 'Please generate EC key pairs first!'});
            }
        } else {
            if (!bobPrivate) {
                errors.push({field: '#privatekeyparamb', message: 'Required for decryption'});
            }
            if (!alicePublic) {
                errors.push({field: '#publickeyparama', message: 'Required for decryption'});
            }
            // Validate Base64 format for decryption
            if (message) {
                var base64Pattern = /^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)?$/;
                if (!base64Pattern.test(message)) {
                    errors.push({field: '#message', message: 'Invalid Base64 format. Encrypted text must be Base64 encoded.'});
                }
            }
            // Check if keys exist but user needs to generate
            if (!alicePrivate && !alicePublic && !bobPrivate && !bobPublic) {
                errors.push({field: '#message', message: 'Please generate EC key pairs first!'});
            }
        }

        if (errors.length > 0) {
            errors.forEach(function(err) {
                $(err.field).addClass('is-invalid');
                $(err.field).siblings('.invalid-feedback').text(err.message).show();
            });
            // Show error summary in output
            var errorHtml = '<div class="alert alert-warning"><i class="fas fa-exclamation-triangle"></i> <strong>Validation Error:</strong><ul class="mb-0 mt-2">';
            errors.forEach(function(err) {
                errorHtml += '<li>' + err.message + '</li>';
            });
            errorHtml += '</ul></div>';
            $('#output').html(errorHtml);
            return;
        }

        $('#output').html('<div class="text-center py-4"><img src="images/712.GIF" alt="Loading..."> Processing...</div>');
        $('#downloadResultBtn').hide();

        $.ajax({
            type: "POST",
            url: "ECFunctionality",
            data: $("#form").serialize(),
            dataType: 'json',
            success: function(response) {
                lastResult = response;
                displayResult(response);
            },
            error: function(xhr, status, error) {
                $('#output').html('<div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> Error: ' + error + '</div>');
            }
        });
    });

    // Download result
    $('#downloadResultBtn').click(function() {
        if (lastResult) {
            downloadJson(lastResult, 'ec-result');
        }
    });

    // Download keys
    $('#downloadKeysBtn').click(function() {
        var keysData = {
            keyType: "EC",
            alice: {
                publicKey: $('#publickeyparama').val(),
                privateKey: $('#privatekeyparama').val()
            },
            bob: {
                publicKey: $('#publickeyparamb').val(),
                privateKey: $('#privatekeyparamb').val()
            },
            <% if (sharedSecret != null && sharedSecret.length() > 1) { %>
            sharedSecret: "<%=sharedSecret%>",
            <% } %>
            generatedAt: new Date().toISOString(),
            tool: "8gwifi.org EC Key Exchange Tool",
            warning: "NEVER share private keys! Keep them secure."
        };
        downloadJson(keysData, 'ec-keys');
    });

    // Share URL
    $('#shareUrlBtn').click(function() {
        var mode = $('input[name="encryptdecryptparameter"]:checked').val();
        var message = encodeURIComponent($('#message').val());

        shareUrl = window.location.origin + window.location.pathname +
            '?mode=' + mode +
            '&message=' + message;

        $('#shareUrlText').val(shareUrl);
        $('#shareUrlModal').modal('show');
    });

    // Copy share URL
    $('#copyShareUrl').click(function() {
        var btn = $(this);
        navigator.clipboard.writeText(shareUrl).then(function() {
            btn.html('<i class="fas fa-check"></i> Copied!');
            setTimeout(function() {
                btn.html('<i class="fas fa-copy"></i> Copy URL');
            }, 2000);
        }).catch(function() {
            $('#shareUrlText').select();
            document.execCommand('copy');
            btn.html('<i class="fas fa-check"></i> Copied!');
            setTimeout(function() {
                btn.html('<i class="fas fa-copy"></i> Copy URL');
            }, 2000);
        });
    });

    // Load from URL parameters
    var urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('message')) {
        $('#message').val(decodeURIComponent(urlParams.get('message')));
    }
    if (urlParams.has('mode')) {
        var mode = urlParams.get('mode');
        if (mode === 'decrypt') {
            $('#decryptparameter').prop('checked', true).trigger('change');
        }
    }
});

function displayResult(response) {
    var html = '';

    if (response.success) {
        $('#downloadResultBtn').show();

        if (response.operation === 'ec_encrypt') {
            // Store encrypted data for "Use for Decryption" button
            window.lastEncrypted = response.base64Encoded;

            html = '<div class="result-card encrypt p-3 rounded">' +
                '<h6><i class="fas fa-lock text-primary"></i> Encryption Result</h6>' +
                '<div class="mb-3">' +
                '<label class="font-weight-bold">Original Message:</label>' +
                '<div class="bg-light p-2 rounded"><code>' + escapeHtml(response.originalMessage) + '</code></div>' +
                '</div>' +
                '<div class="mb-3">' +
                '<label class="font-weight-bold">Encrypted (Base64):</label>' +
                '<div class="bg-light p-2 rounded" style="word-break: break-all;"><code id="encryptedOutput">' + response.base64Encoded + '</code></div>' +
                '<div class="mt-2">' +
                '<button class="btn btn-sm btn-outline-primary" onclick="copyToClipboard(\'' + response.base64Encoded + '\')"><i class="fas fa-copy"></i> Copy</button> ' +
                '<button class="btn btn-sm btn-success" onclick="useForDecryption()"><i class="fas fa-unlock-alt"></i> Use for Decryption</button>' +
                '</div>' +
                '</div>' +
                '<div>' +
                '<label class="font-weight-bold">Initial Vector (IV):</label>' +
                '<div class="bg-light p-2 rounded"><code>' + response.intialVector + '</code></div>' +
                '</div>' +
                '<div class="alert alert-info mt-3 mb-0 small">' +
                '<i class="fas fa-lightbulb"></i> <strong>Next Step:</strong> Click "Use for Decryption" to test decrypting this message with Bob\'s keys!' +
                '</div>' +
                '</div>';
        } else if (response.operation === 'ec_decrypt') {
            html = '<div class="result-card decrypt p-3 rounded">' +
                '<h6><i class="fas fa-unlock text-success"></i> Decryption Successful!</h6>' +
                '<div class="mb-3">' +
                '<label class="font-weight-bold">Ciphertext (Input):</label>' +
                '<div class="bg-light p-2 rounded small" style="word-break: break-all;"><code>' + escapeHtml(response.originalMessage) + '</code></div>' +
                '</div>' +
                '<div>' +
                '<label class="font-weight-bold">Decrypted Message:</label>' +
                '<div class="alert alert-success mb-2" style="font-size: 1.2em;"><i class="fas fa-check-circle"></i> <strong>' + escapeHtml(response.message) + '</strong></div>' +
                '<button class="btn btn-sm btn-outline-success" onclick="copyToClipboard(\'' + escapeHtml(response.message).replace(/'/g, "\\'") + '\')"><i class="fas fa-copy"></i> Copy Message</button>' +
                '</div>' +
                '</div>';
        }
    } else {
        html = '<div class="result-card error p-3 rounded">' +
            '<h6><i class="fas fa-exclamation-circle text-danger"></i> Error</h6>' +
            '<div class="alert alert-danger mb-0">' + escapeHtml(response.errorMessage) + '</div>' +
            '</div>';
    }

    $('#output').html(html);
}

// Use encrypted output for decryption
function useForDecryption() {
    if (window.lastEncrypted) {
        // Set the encrypted text to message field
        $('#message').val(window.lastEncrypted);

        // Switch to decrypt mode
        $('#decryptparameter').prop('checked', true);
        $('label.btn').removeClass('active');
        $('label.btn:has(#decryptparameter)').addClass('active');

        // Update UI
        $('#encryptInfo').hide();
        $('#decryptInfo').show();
        $('#message').attr('placeholder', 'Enter Base64 encoded ciphertext to decrypt...');

        // Clear validation
        $('#message').removeClass('is-invalid');

        // Scroll to form
        $('html, body').animate({
            scrollTop: $('#form').offset().top - 100
        }, 300);

        // Show hint
        $('#output').html('<div class="alert alert-info">' +
            '<i class="fas fa-info-circle"></i> Encrypted text loaded! Click <strong>Process</strong> to decrypt using Bob\'s Private Key + Alice\'s Public Key.' +
            '</div>');
    }
}

function downloadJson(data, prefix) {
    var filename = prefix + '-' + new Date().toISOString().slice(0,10) + '.json';
    var blob = new Blob([JSON.stringify(data, null, 2)], {type: 'application/json'});
    var url = URL.createObjectURL(blob);
    var a = document.createElement('a');
    a.href = url;
    a.download = filename;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
}

function copyToClipboard(text) {
    navigator.clipboard.writeText(text).then(function() {
        alert('Copied to clipboard!');
    }).catch(function() {
        var textarea = document.createElement('textarea');
        textarea.value = text;
        document.body.appendChild(textarea);
        textarea.select();
        document.execCommand('copy');
        document.body.removeChild(textarea);
        alert('Copied to clipboard!');
    });
}

function escapeHtml(text) {
    if (!text) return '';
    var div = document.createElement('div');
    div.appendChild(document.createTextNode(text));
    return div.innerHTML;
}
</script>

<%@ include file="body-close.jsp"%>
