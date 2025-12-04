<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="org.apache.http.impl.client.DefaultHttpClient" %>
<%@ page import="org.apache.http.client.methods.HttpGet" %>
<%@ page import="org.apache.http.HttpResponse" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="z.y.x.Security.elgamlpojo" %>
<%@ page import="z.y.x.r.LoadPropertyFileFunctionality" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>ElGamal Encryption Decryption Online | Free Key Generator & Calculator | 8gwifi.org</title>
    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="keywords" content="elgamal encryption online, elgamal decryption calculator, elgamal key generator, discrete logarithm encryption, public key cryptography tool, asymmetric encryption online, elgamal algorithm calculator, diffie-hellman encryption, taher elgamal cryptosystem, pgp elgamal, gnu privacy guard elgamal, elgamal vs rsa, free elgamal encrypt decrypt, elgamal public private key pair generator, homomorphic encryption elgamal, elgamal digital signature, ec-elgamal elliptic curve" />
    <meta name="description" content="Free ElGamal encryption and decryption calculator online. Generate ElGamal public-private key pairs instantly. Based on Diffie-Hellman discrete logarithm - used in PGP & GPG. Compare ElGamal vs RSA asymmetric encryption." />
    <meta name="robots" content="index,follow" />
    <meta name="googlebot" content="index,follow" />
    <meta name="resource-type" content="document" />
    <meta name="classification" content="tools" />
    <meta name="language" content="en" />

    <!-- Open Graph for Social Sharing -->
    <meta property="og:title" content="ElGamal Encryption Decryption Online | Free Key Generator" />
    <meta property="og:description" content="Free ElGamal encryption calculator. Generate key pairs, encrypt & decrypt using discrete logarithm cryptography. Used in PGP/GPG." />
    <meta property="og:type" content="website" />
    <meta property="og:url" content="https://8gwifi.org/elgamalfunctions.jsp" />

    <!-- Twitter Card -->
    <meta name="twitter:card" content="summary" />
    <meta name="twitter:title" content="ElGamal Encryption Decryption Online | Free Calculator" />
    <meta name="twitter:description" content="Free ElGamal encryption tool. Generate key pairs, encrypt & decrypt messages using public-key cryptography." />
    <meta name="twitter:creator" content="@anish2good" />

    <!-- JSON-LD WebApplication Schema -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "ElGamal Encryption Decryption Calculator Online",
        "alternateName": ["ElGamal Key Generator", "ElGamal Cryptosystem Tool", "Discrete Logarithm Encryption"],
        "description": "Free online ElGamal encryption and decryption calculator. Generate ElGamal public-private key pairs, encrypt and decrypt messages using Taher Elgamal's asymmetric cryptosystem based on Diffie-Hellman discrete logarithm problem. Compatible with PGP and GNU Privacy Guard.",
        "url": "https://8gwifi.org/elgamalfunctions.jsp",
        "applicationCategory": "SecurityApplication",
        "applicationSubCategory": "Cryptography",
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
        "publisher": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org"
        },
        "datePublished": "2018-04-02",
        "dateModified": "2025-01-28",
        "keywords": "ElGamal encryption, ElGamal decryption, key generator, discrete logarithm, public key cryptography, asymmetric encryption, Diffie-Hellman, PGP, GPG",
        "featureList": ["ElGamal Key Pair Generation", "Message Encryption", "Message Decryption", "Multiple Padding Modes", "EC-ElGamal Support", "Base64 Output"]
    }
    </script>

    <!-- JSON-LD FAQPage Schema -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "FAQPage",
        "mainEntity": [
            {
                "@type": "Question",
                "name": "What is ElGamal encryption and how does it work?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "ElGamal is an asymmetric public-key encryption algorithm invented by Taher Elgamal in 1985, based on the Diffie-Hellman key exchange. It uses the discrete logarithm problem for security. The encryption process involves: 1) Key Generation: choose prime p, generator g, private key x, compute public key y=g^x mod p. 2) Encryption: choose random k, compute c1=g^k mod p, c2=m*y^k mod p. 3) Decryption: compute m=c2*(c1^x)^-1 mod p. The ciphertext is twice the size of plaintext."
                }
            },
            {
                "@type": "Question",
                "name": "What key sizes are recommended for ElGamal encryption?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "For standard ElGamal over finite fields, NIST recommends 2048-bit keys minimum for adequate security (equivalent to 112-bit symmetric). For EC-ElGamal (elliptic curve variant), 256-bit keys provide equivalent security to 3072-bit RSA. The tool supports 160-bit and 320-bit EC-ElGamal keys for testing purposes."
                }
            },
            {
                "@type": "Question",
                "name": "Is ElGamal encryption used in PGP and GPG?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Yes, ElGamal encryption is widely used in GNU Privacy Guard (GPG) and recent versions of PGP (Pretty Good Privacy). It's the default public-key algorithm for encryption in GPG. ElGamal provides semantic security (randomized encryption), making it more secure than deterministic schemes for the same key size."
                }
            },
            {
                "@type": "Question",
                "name": "What is the difference between ElGamal and RSA encryption?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "ElGamal and RSA differ in: 1) Mathematical basis - RSA uses integer factorization, ElGamal uses discrete logarithm. 2) Ciphertext size - ElGamal produces 2x plaintext size, RSA matches key size. 3) Security property - ElGamal is semantically secure (randomized), basic RSA is deterministic. 4) Performance - RSA is generally faster for encryption. 5) Usage - RSA dominates TLS/SSL, ElGamal is preferred in PGP/GPG."
                }
            },
            {
                "@type": "Question",
                "name": "Can ElGamal be used for digital signatures?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "Yes, the ElGamal signature scheme is a variant used for digital signatures. DSA (Digital Signature Algorithm), which is a US government standard, is derived from the ElGamal signature scheme. Both provide authentication and non-repudiation based on the discrete logarithm problem."
                }
            },
            {
                "@type": "Question",
                "name": "What is the discrete logarithm problem in ElGamal?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "The discrete logarithm problem (DLP) is the mathematical foundation of ElGamal security. Given g, p, and y=g^x mod p, finding x is computationally infeasible for large primes. This one-way function makes it easy to compute y from x but practically impossible to reverse. The best known algorithms (index calculus) have sub-exponential complexity."
                }
            }
        ]
    }
    </script>

    <!-- JSON-LD HowTo Schema for Rich Snippets -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "HowTo",
        "name": "How to Encrypt a Message with ElGamal",
        "description": "Step-by-step guide to encrypt messages using the ElGamal cryptosystem online",
        "step": [
            {
                "@type": "HowToStep",
                "position": 1,
                "name": "Generate or Enter Keys",
                "text": "Generate a new ElGamal key pair by selecting key size (160-bit or 320-bit), or paste your existing public/private keys in PEM format."
            },
            {
                "@type": "HowToStep",
                "position": 2,
                "name": "Enter Your Message",
                "text": "Type or paste the plaintext message you want to encrypt in the message input field."
            },
            {
                "@type": "HowToStep",
                "position": 3,
                "name": "Select Cipher Mode",
                "text": "Choose the cipher mode: ELGAMAL (default), ECB/PKCS1, NONE/NoPadding, or PKCS1 padding."
            },
            {
                "@type": "HowToStep",
                "position": 4,
                "name": "Process Encryption",
                "text": "Click the Process button. The encrypted ciphertext will appear in Base64 format, ready to share securely."
            }
        ],
        "tool": {
            "@type": "HowToTool",
            "name": "ElGamal Encryption Tool"
        }
    }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        :root {
            --theme-primary: #059669;
            --theme-secondary: #10b981;
            --theme-gradient: linear-gradient(135deg, #059669 0%, #10b981 100%);
            --theme-light: #ecfdf5;
        }

        .tool-card {
            border: none;
            box-shadow: 0 2px 15px rgba(0,0,0,0.08);
            border-radius: 12px;
            transition: box-shadow 0.2s ease;
        }
        .tool-card:hover {
            box-shadow: 0 4px 20px rgba(0,0,0,0.12);
        }

        .card-header-custom {
            background: var(--theme-gradient);
            color: white;
            border-radius: 12px 12px 0 0 !important;
            padding: 1rem 1.25rem;
        }

        .form-section {
            background: var(--theme-light);
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1rem;
        }

        .form-section-title {
            font-weight: 600;
            color: var(--theme-primary);
            margin-bottom: 0.75rem;
            font-size: 0.9rem;
        }

        .result-card {
            border: 2px dashed #dee2e6;
            border-radius: 12px;
            min-height: 200px;
        }

        .result-placeholder {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 200px;
            color: #6c757d;
        }

        .result-placeholder i {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .result-content {
            display: none;
        }

        .hash-output {
            font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, monospace;
            font-size: 0.85rem;
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 1rem;
            word-break: break-all;
            position: relative;
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
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            background: var(--theme-light);
            color: var(--theme-primary);
            padding: 0.25rem 0.6rem;
            border-radius: 12px;
            font-size: 0.7rem;
            font-weight: 500;
            margin-right: 0.35rem;
        }

        .btn-generate {
            background: var(--theme-gradient);
            border: none;
            color: white;
            padding: 0.75rem 2rem;
            border-radius: 8px;
            font-weight: 600;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .btn-generate:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(5, 150, 105, 0.4);
            color: white;
        }

        .btn-action {
            background: transparent;
            border: 2px solid var(--theme-primary);
            color: var(--theme-primary);
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.2s;
        }
        .btn-action:hover {
            background: var(--theme-primary);
            color: white;
        }

        .related-tools {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 1rem;
        }

        .related-tool-card {
            display: block;
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 8px;
            text-decoration: none;
            color: inherit;
            transition: all 0.2s;
            border: 1px solid transparent;
        }
        .related-tool-card:hover {
            background: var(--theme-light);
            border-color: var(--theme-primary);
            text-decoration: none;
            color: inherit;
        }
        .related-tool-card h6 {
            color: var(--theme-primary);
            margin-bottom: 0.25rem;
        }
        .related-tool-card p {
            font-size: 0.8rem;
            color: #6c757d;
            margin: 0;
        }

        .key-radio-group {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .key-radio-group .form-check {
            padding: 0.5rem 1rem;
            background: white;
            border-radius: 8px;
            border: 2px solid #dee2e6;
            cursor: pointer;
            transition: all 0.2s;
        }

        .key-radio-group .form-check:has(input:checked) {
            border-color: var(--theme-primary);
            background: var(--theme-light);
        }

        .cipher-options {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 0.5rem;
        }

        @media (max-width: 768px) {
            .cipher-options {
                grid-template-columns: 1fr;
            }
        }

        /* UX Improvements */
        .sticky-result {
            position: sticky;
            top: 80px;
            z-index: 100;
        }

        .collapsible-section {
            cursor: pointer;
            user-select: none;
        }

        .collapsible-section .collapse-icon {
            transition: transform 0.2s ease;
        }

        .collapsible-section.collapsed .collapse-icon {
            transform: rotate(-90deg);
        }

        .key-section-collapsed .key-content {
            display: none;
        }

        .key-section-collapsed .key-preview {
            display: block !important;
        }

        .key-preview {
            display: none;
            font-size: 0.75rem;
            color: #6c757d;
            background: #f8f9fa;
            padding: 0.5rem;
            border-radius: 4px;
            font-family: monospace;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        /* Floating Process Button for Mobile */
        .floating-action-btn {
            display: none;
            position: fixed;
            bottom: 20px;
            right: 20px;
            z-index: 1000;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: var(--theme-gradient);
            color: white;
            border: none;
            box-shadow: 0 4px 15px rgba(5, 150, 105, 0.4);
            font-size: 1.5rem;
        }

        @media (max-width: 991px) {
            .floating-action-btn {
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .sticky-result {
                position: relative;
                top: 0;
            }
        }

        /* Quick input highlight */
        .message-input-highlight {
            border: 2px solid var(--theme-primary) !important;
            box-shadow: 0 0 0 3px rgba(5, 150, 105, 0.1);
        }

        /* Compact mode for keys */
        .compact-textarea {
            transition: all 0.2s ease;
        }

        .compact-textarea:not(:focus) {
            max-height: 60px;
            overflow: hidden;
        }

        .compact-textarea:focus {
            max-height: 150px;
        }
    </style>

    <%
        String pubKey = "";
        String privKey = "";
        String checkedKey = "160";
        boolean k1 = false;
        boolean k2 = false;

        if (request.getSession().getAttribute("pubkey") == null) {
            Gson gson = new Gson();
            DefaultHttpClient httpClient = new DefaultHttpClient();
            String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "elgamal/" + 160;

            HttpGet getRequest = new HttpGet(url1);
            getRequest.addHeader("accept", "application/json");

            HttpResponse response1 = httpClient.execute(getRequest);

            BufferedReader br = new BufferedReader(
                new InputStreamReader((response1.getEntity().getContent()))
            );

            StringBuilder content = new StringBuilder();
            String line;
            while (null != (line = br.readLine())) {
                content.append(line);
            }
            elgamlpojo elgamlpojo = (elgamlpojo)gson.fromJson(content.toString(), elgamlpojo.class);
            pubKey = elgamlpojo.getPublicKey();
            privKey = elgamlpojo.getPrivateKey();
            k1 = true;
        } else {
            pubKey = (String)request.getSession().getAttribute("pubkey");
            privKey = (String)request.getSession().getAttribute("privKey");
            checkedKey = (String)request.getSession().getAttribute("keysize");
        }

        if ("160".equals(checkedKey)) {
            k1 = true;
        }
        if ("320".equals(checkedKey)) {
            k2 = true;
        }
    %>

    <script type="text/javascript">
        var lastResult = null;
        var lastOperation = '';
        var lastCiphertext = '';

        $(document).ready(function() {
            // Key size form submission
            $('#form1').on('change', 'input[name="keysize"]', function() {
                $('#form1').submit();
            });

            // Main form submission on input changes
            $('#publickeyparam, #privatekeyparam, #message').on('input', debounce(function() {
                if ($('#message').val().trim() !== '') {
                    $('#form').submit();
                }
            }, 500));

            // Cipher parameter changes
            $('input[name="cipherparameter"]').change(function() {
                if ($('#message').val().trim() !== '') {
                    $('#form').submit();
                }
            });

            // Encrypt/Decrypt toggle
            $('input[name="encryptdecryptparameter"]').change(function() {
                updateMessageLabel();
                if ($('#message').val().trim() !== '') {
                    $('#form').submit();
                }
            });

            // Form submission
            $('#form').submit(function(event) {
                event.preventDefault();

                var message = $('#message').val().trim();
                if (!message) {
                    showToast('Please enter a message');
                    return;
                }

                $('.result-placeholder').html('<i class="fas fa-spinner fa-spin"></i><span>Processing...</span>').show();
                $('.result-content').hide();

                $.ajax({
                    type: "POST",
                    url: "ELGAMALFunctionality",
                    data: $("#form").serialize(),
                    dataType: "json",
                    success: function(response) {
                        lastResult = response;
                        lastOperation = response.operation;
                        renderResult(response);
                    },
                    error: function(xhr, status, error) {
                        showToast('An error occurred. Please try again.');
                        $('.result-placeholder').html('<i class="fas fa-lock"></i><span>Result will appear here</span>').show();
                        $('.result-content').hide();
                    }
                });
            });

            updateMessageLabel();
        });

        function renderResult(response) {
            $('.result-placeholder').hide();
            var $content = $('.result-content');
            $content.empty();

            if (!response.success) {
                // Error response
                $content.html(
                    '<div class="alert alert-danger mb-0">' +
                    '<i class="fas fa-exclamation-circle me-2"></i>' +
                    '<strong>Error:</strong> ' + escapeHtml(response.errorMessage) +
                    '</div>'
                );
                $content.show();
                return;
            }

            var html = '';

            if (response.operation === 'encrypt') {
                lastCiphertext = response.ciphertext;
                html = '<div class="mb-3">' +
                    '<div class="d-flex justify-content-between align-items-center mb-2">' +
                    '<label class="small font-weight-bold text-success"><i class="fas fa-lock me-1"></i>Encrypted Ciphertext (Base64)</label>' +
                    '<span class="badge bg-success">' + escapeHtml(response.algorithm) + '</span>' +
                    '</div>' +
                    '<div class="hash-output">' +
                    '<textarea class="form-control" rows="5" readonly id="resultCiphertext" name="encrypedmessagetextarea">' + escapeHtml(response.ciphertext) + '</textarea>' +
                    '</div>' +
                    '<div class="mt-2">' +
                    '<button class="btn btn-sm btn-outline-success me-1" onclick="copyToClipboard(\'resultCiphertext\')">' +
                    '<i class="fas fa-copy me-1"></i>Copy</button>' +
                    '<button class="btn btn-sm btn-outline-primary" onclick="useEncryptedForDecrypt()">' +
                    '<i class="fas fa-redo me-1"></i>Decrypt This</button>' +
                    '</div>' +
                    '</div>';
            } else if (response.operation === 'decrypt') {
                html = '<div class="mb-3">' +
                    '<div class="d-flex justify-content-between align-items-center mb-2">' +
                    '<label class="small font-weight-bold text-primary"><i class="fas fa-unlock me-1"></i>Decrypted Plaintext</label>' +
                    '<span class="badge bg-primary">' + escapeHtml(response.algorithm) + '</span>' +
                    '</div>' +
                    '<div class="hash-output">' +
                    '<textarea class="form-control" rows="5" readonly id="resultPlaintext">' + escapeHtml(response.plaintext) + '</textarea>' +
                    '</div>' +
                    '<div class="mt-2">' +
                    '<button class="btn btn-sm btn-outline-primary" onclick="copyToClipboard(\'resultPlaintext\')">' +
                    '<i class="fas fa-copy me-1"></i>Copy</button>' +
                    '</div>' +
                    '</div>';
            }

            $content.html(html).show();

            // Auto-scroll to result on mobile
            scrollToResult();
        }

        function debounce(func, wait) {
            var timeout;
            return function() {
                var context = this, args = arguments;
                clearTimeout(timeout);
                timeout = setTimeout(function() {
                    func.apply(context, args);
                }, wait);
            };
        }

        function updateMessageLabel() {
            var isEncrypt = $('input[name="encryptdecryptparameter"]:checked').val() === 'encrypt';
            $('#messageLabel').html(isEncrypt ? '<i class="fas fa-comment me-1"></i>Plaintext Message' : '<i class="fas fa-lock me-1"></i>Ciphertext (Base64)');
            $('#message').attr('placeholder', isEncrypt ? 'Enter message to encrypt...' : 'Enter Base64 encoded ciphertext to decrypt...');
        }

        function useEncryptedForDecrypt() {
            if (lastCiphertext) {
                $('#message').val(lastCiphertext);
                $('#decryptparameter').prop('checked', true);
                updateMessageLabel();
                $('#form').submit();
            } else {
                showToast('No encrypted result available');
            }
        }

        function copyToClipboard(elementId) {
            var text = document.getElementById(elementId).value;
            if (text) {
                navigator.clipboard.writeText(text).then(function() {
                    showToast('Copied to clipboard!');
                });
            }
        }

        function copyResult() {
            var text = $('#resultCiphertext').val() || $('#resultPlaintext').val();
            if (text) {
                navigator.clipboard.writeText(text).then(function() {
                    showToast('Copied to clipboard!');
                });
            } else {
                showToast('No result to copy');
            }
        }

        function clearAll() {
            $('#message').val('');
            $('.result-placeholder').html('<i class="fas fa-lock"></i><span>Result will appear here</span>').show();
            $('.result-content').hide().empty();
            lastResult = null;
            lastCiphertext = '';
        }

        function showToast(message) {
            var toast = $('<div class="position-fixed" style="bottom: 20px; right: 20px; z-index: 9999;">' +
                '<div class="toast show"><div class="toast-body text-white rounded" style="background: var(--theme-gradient);">' +
                '<i class="fas fa-info-circle me-2"></i>' + message + '</div></div></div>');
            $('body').append(toast);
            setTimeout(function() { toast.fadeOut(function() { toast.remove(); }); }, 2000);
        }

        function escapeHtml(text) {
            if (!text) return '';
            var div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        // Download result as file
        function downloadResult() {
            if (!lastResult || !lastResult.success) {
                showToast('No result to download');
                return;
            }

            var content, filename, mimeType;

            if (lastResult.operation === 'encrypt') {
                content = lastResult.ciphertext;
                filename = 'elgamal-ciphertext.txt';
                mimeType = 'text/plain';
            } else {
                content = lastResult.plaintext;
                filename = 'elgamal-plaintext.txt';
                mimeType = 'text/plain';
            }

            // Create download
            var blob = new Blob([content], { type: mimeType });
            var url = URL.createObjectURL(blob);
            var a = document.createElement('a');
            a.href = url;
            a.download = filename;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            URL.revokeObjectURL(url);

            showToast('Downloaded: ' + filename);
        }

        // Open share URL modal
        function shareUrl() {
            if (!lastResult || !lastResult.success) {
                showToast('No result to share. Please encrypt or decrypt first.');
                return;
            }

            // Reset checkboxes
            $('#includePublicKey').prop('checked', true);
            $('#includePrivateKey').prop('checked', false);

            // Update modal content based on operation
            if (lastResult.operation === 'encrypt') {
                $('#shareIncludesCiphertext').show();
                $('#shareIncludesPlaintext').hide();
            } else {
                $('#shareIncludesCiphertext').hide();
                $('#shareIncludesPlaintext').show();
            }

            $('#shareAlgorithm').text(lastResult.algorithm || 'ELGAMAL');

            // Generate initial URL
            updateShareUrl();

            // Update tweet button
            var tweetText = 'Check out this free ElGamal Encryption/Decryption tool! @anish2good';
            var tweetUrl = 'https://twitter.com/intent/tweet?text=' + encodeURIComponent(tweetText) + '&url=' + encodeURIComponent('https://8gwifi.org/elgamalfunctions.jsp');
            $('#tweetShareBtn').attr('href', tweetUrl);

            // Show modal
            $('#shareUrlModal').modal('show');
        }

        // Update share URL based on selected options
        function updateShareUrl() {
            var params = {};

            // Add result data
            if (lastResult.operation === 'encrypt') {
                params.ciphertext = lastResult.ciphertext;
            } else {
                params.plaintext = lastResult.plaintext;
            }

            params.algo = $('input[name="cipherparameter"]:checked').val() || 'ELGAMAL';
            params.op = lastResult.operation;

            // Include public key if checked
            if ($('#includePublicKey').is(':checked')) {
                var pubKey = $('#publickeyparam').val().trim();
                if (pubKey) {
                    params.pubkey = btoa(pubKey); // Base64 encode
                    $('#shareIncludesPublicKey').show();
                } else {
                    $('#shareIncludesPublicKey').hide();
                }
            } else {
                $('#shareIncludesPublicKey').hide();
            }

            // Include private key if checked (with warning)
            if ($('#includePrivateKey').is(':checked')) {
                var privKey = $('#privatekeyparam').val().trim();
                if (privKey) {
                    params.privkey = btoa(privKey); // Base64 encode
                    $('#shareIncludesPrivateKey').show();
                    $('#privateKeyWarning').show();
                } else {
                    $('#shareIncludesPrivateKey').hide();
                    $('#privateKeyWarning').hide();
                }
            } else {
                $('#shareIncludesPrivateKey').hide();
                $('#privateKeyWarning').hide();
            }

            // Build URL
            var baseUrl = window.location.origin + window.location.pathname;
            var queryString = Object.keys(params).map(function(key) {
                return encodeURIComponent(key) + '=' + encodeURIComponent(params[key]);
            }).join('&');

            var shareUrl = baseUrl + '?' + queryString;
            $('#shareUrlText').val(shareUrl);
        }

        // Copy share URL to clipboard
        function copyShareUrl() {
            var urlText = $('#shareUrlText').val();
            if (urlText) {
                navigator.clipboard.writeText(urlText).then(function() {
                    $('#copyShareUrlBtn').html('<i class="fas fa-check me-1"></i>Copied!');
                    setTimeout(function() {
                        $('#copyShareUrlBtn').html('<i class="fas fa-copy me-1"></i>Copy');
                    }, 2000);
                    showToast('Share URL copied to clipboard!');
                });
            }
        }

        // Load from URL parameters on page load
        function loadFromUrl() {
            var urlParams = new URLSearchParams(window.location.search);

            // Check if we have shared data
            var ciphertext = urlParams.get('ciphertext');
            var plaintext = urlParams.get('plaintext');
            var algo = urlParams.get('algo');
            var op = urlParams.get('op');
            var pubkey = urlParams.get('pubkey');
            var privkey = urlParams.get('privkey');

            if (!ciphertext && !plaintext) {
                return; // No shared data
            }

            // Set algorithm
            if (algo) {
                $('input[name="cipherparameter"][value="' + algo + '"]').prop('checked', true);
            }

            // Decode and set public key
            if (pubkey) {
                try {
                    var decodedPubKey = atob(pubkey);
                    $('#publickeyparam').val(decodedPubKey);
                } catch (e) {
                    console.error('Failed to decode public key');
                }
            }

            // Decode and set private key (with warning)
            if (privkey) {
                try {
                    var decodedPrivKey = atob(privkey);
                    $('#privatekeyparam').val(decodedPrivKey);
                    showToast('Warning: Private key loaded from URL. Be cautious!');
                } catch (e) {
                    console.error('Failed to decode private key');
                }
            }

            // Display the shared result
            if (ciphertext) {
                // Show encrypted result
                lastResult = {
                    success: true,
                    operation: 'encrypt',
                    ciphertext: ciphertext,
                    algorithm: algo || 'ELGAMAL'
                };
                lastCiphertext = ciphertext;
                $('#encryptparameter').prop('checked', true);
                renderResult(lastResult);
                showToast('Loaded shared ciphertext from URL');
            } else if (plaintext) {
                // Show decrypted result
                lastResult = {
                    success: true,
                    operation: 'decrypt',
                    plaintext: plaintext,
                    algorithm: algo || 'ELGAMAL'
                };
                $('#decryptparameter').prop('checked', true);
                renderResult(lastResult);
                showToast('Loaded shared plaintext from URL');
            }

            updateMessageLabel();
        }

        // Initialize loadFromUrl on page load
        $(window).on('load', function() {
            loadFromUrl();
        });

        // Toggle keys section expand/collapse
        function toggleKeys() {
            var $section = $('#keysSection');
            var $toggle = $section.find('.collapsible-section');

            $section.toggleClass('key-section-collapsed');
            $toggle.toggleClass('collapsed');
        }

        // Scroll to result after processing
        function scrollToResult() {
            var $result = $('#resultCard');
            if ($result.length) {
                // On mobile, scroll to result
                if ($(window).width() < 992) {
                    $('html, body').animate({
                        scrollTop: $result.offset().top - 20
                    }, 300);
                }
            }
        }

        // Floating action button handler
        function floatingProcess() {
            $('#form').submit();
        }
    </script>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="pgp-menu-nav.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<div class="container-fluid py-4">
    <!-- Page Header -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h1 class="h4 mb-1">ElGamal Encryption & Decryption</h1>
            <div class="mt-1">
                <span class="info-badge"><i class="fas fa-key"></i> Public-Key</span>
                <span class="info-badge"><i class="fas fa-shield-alt"></i> Asymmetric</span>
                <span class="info-badge"><i class="fas fa-lock"></i> Discrete Log</span>
            </div>
        </div>
        <div class="eeat-badge">
            <i class="fas fa-user-check"></i>
            <span>Anish Nath</span>
        </div>
    </div>

    <div class="row">
        <!-- Left Column - Input -->
        <div class="col-lg-5 mb-4">
            <!-- Key Generation Card -->
            <div class="card tool-card mb-3">
                <div class="card-header card-header-custom py-2">
                    <h6 class="mb-0"><i class="fas fa-key me-2"></i>Key Generation</h6>
                </div>
                <div class="card-body">
                    <form id="form1" method="GET" action="ELGAMALFunctionality?q=setNeKey">
                        <label class="form-section-title"><i class="fas fa-ruler me-1"></i>Key Size</label>
                        <div class="key-radio-group">
                            <div class="form-check">
                                <input class="form-check-input" id="keysize1" type="radio" name="keysize" value="160" <%= k1 ? "checked" : "" %>>
                                <label class="form-check-label" for="keysize1"><strong>160-bit</strong></label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" id="keysize2" type="radio" name="keysize" value="320" <%= k2 ? "checked" : "" %>>
                                <label class="form-check-label" for="keysize2"><strong>320-bit</strong></label>
                            </div>
                        </div>
                        <small class="text-muted mt-2 d-block">160-bit EC-ElGamal ≈ 1024-bit RSA security</small>
                    </form>
                </div>
            </div>

            <!-- Encryption/Decryption Card -->
            <div class="card tool-card">
                <div class="card-header card-header-custom">
                    <h6 class="mb-0"><i class="fas fa-lock me-2"></i>Encrypt / Decrypt</h6>
                </div>
                <div class="card-body">
                    <form id="form" method="POST">
                        <input type="hidden" name="methodName" id="methodName" value="CALCULATE_ELGAMAL">

                        <!-- MESSAGE FIRST - Most Important -->
                        <div class="form-section message-input-highlight mb-3">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <label class="form-section-title mb-0" id="messageLabel"><i class="fas fa-comment me-1"></i>Plaintext Message</label>
                                <div class="d-flex gap-2">
                                    <div class="form-check form-check-inline mb-0">
                                        <input class="form-check-input" id="encryptparameter" type="radio" name="encryptdecryptparameter" value="encrypt" checked>
                                        <label class="form-check-label small" for="encryptparameter">Encrypt</label>
                                    </div>
                                    <div class="form-check form-check-inline mb-0">
                                        <input class="form-check-input" id="decryptparameter" type="radio" name="encryptdecryptparameter" value="decryprt">
                                        <label class="form-check-label small" for="decryptparameter">Decrypt</label>
                                    </div>
                                </div>
                            </div>
                            <textarea class="form-control" rows="3" name="message" id="message" placeholder="Enter message to encrypt..." autofocus></textarea>
                            <div class="d-flex gap-2 mt-2">
                                <button type="submit" class="btn btn-generate btn-sm flex-grow-1">
                                    <i class="fas fa-play me-1"></i> Process
                                </button>
                                <button type="button" class="btn btn-action btn-sm" onclick="clearAll()">
                                    <i class="fas fa-eraser"></i>
                                </button>
                            </div>
                        </div>

                        <!-- Keys Section - Collapsible -->
                        <div class="form-section key-section-collapsed" id="keysSection">
                            <div class="collapsible-section collapsed d-flex justify-content-between align-items-center" onclick="toggleKeys()">
                                <label class="form-section-title mb-0"><i class="fas fa-key me-1"></i>Keys <small class="text-muted">(auto-generated)</small></label>
                                <i class="fas fa-chevron-down collapse-icon"></i>
                            </div>
                            <div class="key-preview mt-2" id="keyPreview">
                                <i class="fas fa-check-circle text-success me-1"></i>Keys loaded (click to expand)
                            </div>
                            <div class="key-content mt-2">
                                <div class="form-group mb-2">
                                    <label for="publickeyparam" class="small font-weight-bold">Public Key</label>
                                    <textarea class="form-control compact-textarea" rows="4" name="publickeyparam" id="publickeyparam" placeholder="Paste public key in PEM format..."><%= pubKey %></textarea>
                                </div>
                                <div class="form-group">
                                    <label for="privatekeyparam" class="small font-weight-bold">Private Key</label>
                                    <textarea class="form-control compact-textarea" rows="4" name="privatekeyparam" id="privatekeyparam" placeholder="Paste private key in PEM format..."><%= privKey %></textarea>
                                </div>
                            </div>
                        </div>

                        <!-- Cipher Mode - Inline -->
                        <div class="form-section mt-3">
                            <label class="form-section-title"><i class="fas fa-cog me-1"></i>Cipher Mode</label>
                            <div class="cipher-options">
                                <div class="form-check">
                                    <input class="form-check-input" id="cipherparameter3" type="radio" name="cipherparameter" value="ELGAMAL" checked>
                                    <label class="form-check-label" for="cipherparameter3">ELGAMAL</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" id="cipherparameter1" type="radio" name="cipherparameter" value="ELGAMAL/ECB/PKCS1PADDING">
                                    <label class="form-check-label" for="cipherparameter1">ECB/PKCS1</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" id="cipherparameter2" type="radio" name="cipherparameter" value="ELGAMAL/NONE/NOPADDING">
                                    <label class="form-check-label" for="cipherparameter2">NONE/NoPadding</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" id="cipherparameter4" type="radio" name="cipherparameter" value="ELGAMAL/PKCS1">
                                    <label class="form-check-label" for="cipherparameter4">PKCS1</label>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Right Column - Results (Sticky on Desktop) -->
        <div class="col-lg-7 mb-4">
            <!-- Result Card - Sticky -->
            <div class="card tool-card mb-3 sticky-result" id="resultCard">
                <div class="card-header bg-light d-flex justify-content-between align-items-center">
                    <h6 class="mb-0"><i class="fas fa-check-circle me-2 text-success"></i>Result</h6>
                    <div>
                        <button class="btn btn-sm btn-outline-secondary me-1" onclick="copyResult()" title="Copy Result">
                            <i class="fas fa-copy"></i>
                        </button>
                        <button class="btn btn-sm btn-outline-secondary me-1" onclick="downloadResult()" title="Download Result">
                            <i class="fas fa-download"></i>
                        </button>
                        <button class="btn btn-sm btn-outline-primary me-1" onclick="shareUrl()" title="Share URL">
                            <i class="fas fa-share-alt"></i>
                        </button>
                        <button class="btn btn-sm btn-outline-secondary" onclick="useEncryptedForDecrypt()" title="Use for Decrypt">
                            <i class="fas fa-redo"></i>
                        </button>
                    </div>
                </div>
                <div class="card-body result-card" style="border: none; border-radius: 0 0 12px 12px;">
                    <div class="result-placeholder">
                        <i class="fas fa-lock"></i>
                        <span>Result will appear here</span>
                    </div>
                    <div class="result-content"></div>
                </div>
            </div>

            <!-- Security Notice -->
            <div class="alert alert-warning mb-3">
                <strong><i class="fas fa-exclamation-triangle me-1"></i>Security Note:</strong>
                <p class="mb-0 small">All cryptographic operations are performed server-side. For production use, generate keys locally and never transmit private keys over the network.</p>
            </div>

            <!-- Parameter Guide Card -->
            <div class="card tool-card">
                <div class="card-header bg-light py-2">
                    <h6 class="mb-0"><i class="fas fa-info-circle me-2"></i>ElGamal Parameter Guide</h6>
                </div>
                <div class="card-body">
                    <table class="table table-sm table-bordered mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Parameter</th>
                                <th>Description</th>
                                <th>Recommendation</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>160-bit</strong></td>
                                <td>EC-ElGamal key size</td>
                                <td><span class="badge bg-success">Good for testing</span></td>
                            </tr>
                            <tr>
                                <td><strong>320-bit</strong></td>
                                <td>Larger EC-ElGamal key</td>
                                <td><span class="badge bg-primary">Better security</span></td>
                            </tr>
                            <tr>
                                <td><strong>PKCS1</strong></td>
                                <td>Standard padding mode</td>
                                <td><span class="badge bg-success">Recommended</span></td>
                            </tr>
                            <tr>
                                <td><strong>NoPadding</strong></td>
                                <td>No padding applied</td>
                                <td><span class="badge bg-warning text-dark">Use with caution</span></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Related Cryptography Tools (links from pgp-menu-nav.jsp) -->
    <div class="card tool-card mb-4">
        <div class="card-header bg-light py-2">
            <h6 class="mb-0"><i class="fas fa-tools me-2"></i>Related Cryptography Tools</h6>
        </div>
        <div class="card-body">
            <div class="related-tools">
                <!-- RSA & Asymmetric from pgp-menu-nav.jsp -->
                <a href="rsafunctions.jsp" class="related-tool-card">
                    <h6><i class="fas fa-key text-success me-1"></i>RSA Encrypt/Decrypt</h6>
                    <p>RSA encryption with various padding modes</p>
                </a>
                <a href="rsasignverifyfunctions.jsp" class="related-tool-card">
                    <h6><i class="fas fa-signature text-success me-1"></i>RSA Sign/Verify</h6>
                    <p>RSA digital signature operations</p>
                </a>
                <!-- Elliptic Curve from pgp-menu-nav.jsp -->
                <a href="ecfunctions.jsp" class="related-tool-card">
                    <h6><i class="fas fa-chart-line text-success me-1"></i>EC Encrypt/Decrypt</h6>
                    <p>Elliptic curve encryption operations</p>
                </a>
                <a href="ecsignverify.jsp" class="related-tool-card">
                    <h6><i class="fas fa-pen-fancy text-success me-1"></i>EC Sign/Verify</h6>
                    <p>Elliptic curve digital signatures</p>
                </a>
                <!-- Other Algorithms from pgp-menu-nav.jsp -->
                <a href="dsafunctions.jsp" class="related-tool-card">
                    <h6><i class="fas fa-fingerprint text-success me-1"></i>DSA Keygen/Sign/Verify</h6>
                    <p>Digital Signature Algorithm operations</p>
                </a>
                <a href="DHFunctions.jsp" class="related-tool-card">
                    <h6><i class="fas fa-exchange-alt text-success me-1"></i>Diffie-Hellman</h6>
                    <p>DH key exchange operations</p>
                </a>
                <a href="ntrufunctions.jsp" class="related-tool-card">
                    <h6><i class="fas fa-cube text-success me-1"></i>NTRU Lattice Crypto</h6>
                    <p>Post-quantum lattice cryptography</p>
                </a>
                <!-- Symmetric & Utils from pgp-menu-nav.jsp -->
                <a href="CipherFunctions.jsp" class="related-tool-card">
                    <h6><i class="fas fa-shield-alt text-success me-1"></i>AES/DES Encryption</h6>
                    <p>Symmetric block cipher operations</p>
                </a>
                <a href="PemParserFunctions.jsp" class="related-tool-card">
                    <h6><i class="fas fa-file-code text-danger me-1"></i>PEM Parser</h6>
                    <p>Parse and decode PEM keys</p>
                </a>
                <a href="sshfunctions.jsp" class="related-tool-card">
                    <h6><i class="fas fa-terminal me-1"></i>SSH-Keygen</h6>
                    <p>Generate SSH key pairs</p>
                </a>
            </div>
        </div>
    </div>

    <!-- Educational Content Section -->
    <div class="card tool-card mb-4">
        <div class="card-header bg-light">
            <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding ElGamal Encryption</h5>
        </div>
        <div class="card-body">
            <h6>What is ElGamal Encryption?</h6>
            <p>ElGamal is an asymmetric key encryption algorithm based on the Diffie-Hellman key exchange, developed by Taher Elgamal in 1985. It provides semantic security, meaning that encrypting the same message twice produces different ciphertexts, making it resistant to chosen-plaintext attacks.</p>

            <h6 class="mt-4">How ElGamal Works</h6>
            <div class="row">
                <div class="col-md-4 mb-3">
                    <div class="p-3 bg-light rounded">
                        <strong><i class="fas fa-key text-primary"></i> Key Generation</strong>
                        <ol class="small mb-0 mt-2">
                            <li>Choose large prime p and generator g</li>
                            <li>Select random private key x</li>
                            <li>Compute public key y = g<sup>x</sup> mod p</li>
                        </ol>
                    </div>
                </div>
                <div class="col-md-4 mb-3">
                    <div class="p-3 bg-light rounded">
                        <strong><i class="fas fa-lock text-success"></i> Encryption</strong>
                        <ol class="small mb-0 mt-2">
                            <li>Choose random k</li>
                            <li>Compute c1 = g<sup>k</sup> mod p</li>
                            <li>Compute c2 = m * y<sup>k</sup> mod p</li>
                        </ol>
                    </div>
                </div>
                <div class="col-md-4 mb-3">
                    <div class="p-3 bg-light rounded">
                        <strong><i class="fas fa-unlock text-warning"></i> Decryption</strong>
                        <ol class="small mb-0 mt-2">
                            <li>Compute shared secret s = c1<sup>x</sup></li>
                            <li>Compute m = c2 * s<sup>-1</sup> mod p</li>
                            <li>Recover original message m</li>
                        </ol>
                    </div>
                </div>
            </div>

            <h6 class="mt-4">ElGamal vs Other Asymmetric Algorithms</h6>
            <table class="table table-sm table-bordered">
                <thead class="table-light">
                    <tr>
                        <th>Algorithm</th>
                        <th>Security Basis</th>
                        <th>Ciphertext Size</th>
                        <th>Semantic Security</th>
                        <th>Performance</th>
                    </tr>
                </thead>
                <tbody>
                    <tr class="table-success">
                        <td><strong>ElGamal</strong></td>
                        <td>Discrete Logarithm</td>
                        <td>2x plaintext</td>
                        <td><span class="badge bg-success">Yes</span></td>
                        <td>Moderate</td>
                    </tr>
                    <tr>
                        <td>RSA</td>
                        <td>Integer Factorization</td>
                        <td>= key size</td>
                        <td><span class="badge bg-warning text-dark">With OAEP</span></td>
                        <td>Fast</td>
                    </tr>
                    <tr>
                        <td>ECC</td>
                        <td>Elliptic Curve DLP</td>
                        <td>Smaller keys</td>
                        <td><span class="badge bg-success">Yes</span></td>
                        <td>Very Fast</td>
                    </tr>
                </tbody>
            </table>

            <h6 class="mt-4">Code Examples</h6>
            <div class="row">
                <div class="col-md-6 mb-3">
                    <p class="small mb-1"><strong>Java (Bouncy Castle)</strong></p>
                    <pre class="bg-dark text-light p-2 rounded small"><code>Security.addProvider(new BouncyCastleProvider());
KeyPairGenerator kpg = KeyPairGenerator.getInstance("ElGamal", "BC");
kpg.initialize(1024);
KeyPair kp = kpg.generateKeyPair();

Cipher cipher = Cipher.getInstance("ElGamal/None/NoPadding", "BC");
cipher.init(Cipher.ENCRYPT_MODE, kp.getPublic());
byte[] ciphertext = cipher.doFinal(plaintext);</code></pre>
                </div>
                <div class="col-md-6 mb-3">
                    <p class="small mb-1"><strong>Python (PyCryptodome)</strong></p>
                    <pre class="bg-dark text-light p-2 rounded small"><code>from Crypto.PublicKey import ElGamal
from Crypto.Random import get_random_bytes

# Generate key pair
key = ElGamal.generate(2048, get_random_bytes)
public_key = key.publickey()

# ElGamal is typically used with hybrid encryption
# combining with symmetric ciphers like AES</code></pre>
                </div>
            </div>

            <h6 class="mt-4">Use Cases and Best Practices</h6>
            <ul class="small">
                <li><strong>Hybrid Encryption:</strong> Use ElGamal to encrypt symmetric keys (AES), then encrypt the actual data with AES. This combines ElGamal's security with AES's speed.</li>
                <li><strong>Digital Signatures:</strong> ElGamal can be adapted for digital signatures (ElGamal signature scheme), though DSA (derived from ElGamal) is more commonly used.</li>
                <li><strong>Key Exchange:</strong> ElGamal is closely related to Diffie-Hellman and can be used for secure key exchange protocols.</li>
                <li><strong>Key Size:</strong> For standard ElGamal, use at least 2048-bit keys. For EC-ElGamal, 256-bit curves provide equivalent security.</li>
            </ul>
        </div>
    </div>

    <!-- Comments Section -->
    <div class="sharethis-inline-share-buttons mb-4"></div>
    <%@ include file="thanks.jsp"%>
    <%@ include file="addcomments.jsp"%>
</div>

<!-- Share URL Modal -->
<div class="modal fade" id="shareUrlModal" tabindex="-1" role="dialog" aria-labelledby="shareUrlModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header" style="background: var(--theme-gradient); color: white;">
                <h5 class="modal-title" id="shareUrlModalLabel">
                    <i class="fas fa-share-alt me-2"></i>Share ElGamal Result
                </h5>
                <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close" style="opacity: 1;">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <!-- Support Request -->
                <div class="alert alert-info mb-3">
                    <div class="d-flex align-items-center">
                        <i class="fab fa-twitter fa-2x me-3 text-primary"></i>
                        <div>
                            <strong>Support 8gwifi.org!</strong>
                            <p class="mb-2 small">If you find this tool useful, please consider following or sharing on Twitter/X to help others discover it.</p>
                            <a href="https://twitter.com/intent/follow?screen_name=anish2good" target="_blank" class="btn btn-sm btn-primary me-2">
                                <i class="fab fa-twitter me-1"></i>Follow @anish2good
                            </a>
                            <a href="#" id="tweetShareBtn" target="_blank" class="btn btn-sm btn-outline-primary">
                                <i class="fas fa-retweet me-1"></i>Tweet This Tool
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Security Warning -->
                <div class="alert alert-danger mb-3" id="privateKeyWarning" style="display: none;">
                    <strong><i class="fas fa-exclamation-triangle me-1"></i>Security Warning!</strong>
                    <p class="mb-0 small">The share URL includes your <strong>private key</strong>. Private keys should NEVER be shared publicly. Only share this URL with trusted parties who need to decrypt your message.</p>
                </div>

                <!-- What's Being Shared -->
                <div class="alert alert-success mb-3">
                    <strong><i class="fas fa-shield-alt me-1"></i>What's Being Shared:</strong>
                    <ul class="mb-0 mt-2 small">
                        <li id="shareIncludesCiphertext" style="display: none;"><i class="fas fa-check text-success me-1"></i><strong>Ciphertext:</strong> The encrypted message (Base64)</li>
                        <li id="shareIncludesPlaintext" style="display: none;"><i class="fas fa-check text-success me-1"></i><strong>Plaintext:</strong> The decrypted message</li>
                        <li id="shareIncludesPublicKey" style="display: none;"><i class="fas fa-check text-success me-1"></i><strong>Public Key:</strong> For encryption verification</li>
                        <li id="shareIncludesPrivateKey" style="display: none;"><i class="fas fa-exclamation-triangle text-danger me-1"></i><strong>Private Key:</strong> <span class="text-danger">Included (Be careful!)</span></li>
                        <li><i class="fas fa-check text-success me-1"></i><strong>Algorithm:</strong> <span id="shareAlgorithm">ELGAMAL</span></li>
                    </ul>
                </div>

                <!-- Share URL -->
                <label class="small font-weight-bold mb-1">Shareable URL:</label>
                <div class="input-group mb-3">
                    <input type="text" class="form-control" id="shareUrlText" readonly style="font-size: 0.85rem;">
                    <div class="input-group-append">
                        <button class="btn btn-success" id="copyShareUrlBtn" onclick="copyShareUrl()">
                            <i class="fas fa-copy me-1"></i>Copy
                        </button>
                    </div>
                </div>

                <!-- Share Options -->
                <div class="d-flex flex-wrap gap-2">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="includePublicKey" checked onchange="updateShareUrl()">
                        <label class="form-check-label small" for="includePublicKey">Include Public Key</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="includePrivateKey" onchange="updateShareUrl()">
                        <label class="form-check-label small text-danger" for="includePrivateKey">Include Private Key (Dangerous!)</label>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-success" onclick="copyShareUrl()">
                    <i class="fas fa-copy me-1"></i>Copy URL
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Floating Action Button (Mobile) -->
<button class="floating-action-btn" onclick="floatingProcess()" title="Process">
    <i class="fas fa-play"></i>
</button>

<%@ include file="footer_adsense.jsp"%>
</div>
<%@ include file="body-close.jsp"%>