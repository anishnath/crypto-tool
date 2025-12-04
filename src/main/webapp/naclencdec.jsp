<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="z.y.x.Security.Utils" %>
<!DOCTYPE html>
<div lang="en">
<head>
    <title>NaCl XSalsa20 Encryption Decryption Online | Libsodium Stream Cipher | 8gwifi.org</title>
    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="keywords" content="nacl xsalsa20 encryption online, libsodium encryption decryption, nacl stream cipher, crypto_stream_xsalsa20_xor, salsa20 encryption tool, nacl cryptography online, secret key encryption, symmetric encryption nacl, xsalsa20 calculator, libsodium online tool" />
    <meta name="description" content="Free NaCl XSalsa20 encryption and decryption tool online. Encrypt messages using libsodium's crypto_stream_xsalsa20_xor stream cipher. Secure symmetric encryption with 256-bit keys and 192-bit nonces." />
    <meta name="robots" content="index,follow" />
    <meta name="googlebot" content="index,follow" />
    <meta name="resource-type" content="document" />
    <meta name="classification" content="tools" />
    <meta name="language" content="en" />

    <!-- Open Graph -->
    <meta property="og:title" content="NaCl XSalsa20 Encryption Decryption Online | Free Tool" />
    <meta property="og:description" content="Free NaCl/libsodium XSalsa20 stream cipher encryption tool. Symmetric encryption with 256-bit keys." />
    <meta property="og:type" content="website" />
    <meta property="og:url" content="https://8gwifi.org/naclencdec.jsp" />

    <!-- Twitter Card -->
    <meta name="twitter:card" content="summary" />
    <meta name="twitter:title" content="NaCl XSalsa20 Encryption Online | Libsodium" />
    <meta name="twitter:description" content="Free NaCl XSalsa20 stream cipher encryption and decryption tool online." />
    <meta name="twitter:creator" content="@anish2good" />

    <!-- JSON-LD WebApplication Schema -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "NaCl XSalsa20 Encryption Decryption Tool",
        "alternateName": ["Libsodium XSalsa20 Encryptor", "NaCl Stream Cipher Tool", "crypto_stream_xsalsa20_xor"],
        "description": "Free online NaCl XSalsa20 encryption and decryption tool. Uses libsodium's crypto_stream_xsalsa20_xor for symmetric stream cipher encryption with 256-bit keys and 192-bit nonces.",
        "url": "https://8gwifi.org/naclencdec.jsp",
        "applicationCategory": "SecurityApplication",
        "applicationSubCategory": "Cryptography",
        "operatingSystem": "Any",
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
        "datePublished": "2018-12-19",
        "dateModified": "2025-01-28",
        "featureList": ["XSalsa20 Stream Cipher", "256-bit Key Support", "192-bit Nonce", "Hex Output", "Real-time Encryption"]
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
                "name": "What is NaCl XSalsa20 encryption?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "XSalsa20 is an extended-nonce variant of the Salsa20 stream cipher used in NaCl (Networking and Cryptography library) and libsodium. It uses a 256-bit key and 192-bit nonce, providing high security with excellent performance."
                }
            },
            {
                "@type": "Question",
                "name": "What is the difference between Salsa20 and XSalsa20?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "XSalsa20 extends Salsa20's nonce from 64 bits to 192 bits. This larger nonce allows safe random nonce generation without collision risk, making it suitable for high-volume encryption."
                }
            },
            {
                "@type": "Question",
                "name": "What key and nonce sizes does XSalsa20 use?",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "XSalsa20 uses a 256-bit (32-byte) secret key and a 192-bit (24-byte) nonce. The nonce must be unique for each message encrypted with the same key."
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
            --theme-gradient: linear-gradient(135deg, #7c3aed 0%, #8b5cf6 100%);
            --theme-light: #f5f3ff;
        }
        .tool-card { border: none; box-shadow: 0 2px 15px rgba(0,0,0,0.08); border-radius: 12px; }
        .tool-card:hover { box-shadow: 0 4px 20px rgba(0,0,0,0.12); }
        .card-header-custom { background: var(--theme-gradient); color: white; border-radius: 12px 12px 0 0 !important; padding: 1rem 1.25rem; }
        .form-section { background: var(--theme-light); border-radius: 8px; padding: 1rem; margin-bottom: 1rem; }
        .form-section-title { font-weight: 600; color: var(--theme-primary); margin-bottom: 0.75rem; font-size: 0.9rem; }
        .result-placeholder { display: flex; flex-direction: column; align-items: center; justify-content: center; height: 150px; color: #6c757d; }
        .result-placeholder i { font-size: 2.5rem; margin-bottom: 0.75rem; opacity: 0.5; }
        .result-content { display: none; }
        .eeat-badge { background: var(--theme-gradient); color: white; padding: 0.35rem 0.75rem; border-radius: 20px; font-size: 0.75rem; display: inline-flex; align-items: center; gap: 0.5rem; }
        .info-badge { display: inline-flex; align-items: center; gap: 0.25rem; background: var(--theme-light); color: var(--theme-primary); padding: 0.25rem 0.6rem; border-radius: 12px; font-size: 0.7rem; font-weight: 500; margin-right: 0.35rem; }
        .btn-generate { background: var(--theme-gradient); border: none; color: white; padding: 0.6rem 1.5rem; border-radius: 8px; font-weight: 600; }
        .btn-generate:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(124, 58, 237, 0.4); color: white; }
        .btn-action { background: transparent; border: 2px solid var(--theme-primary); color: var(--theme-primary); padding: 0.5rem 1rem; border-radius: 8px; }
        .btn-action:hover { background: var(--theme-primary); color: white; }
        .related-tools { display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); gap: 0.75rem; }
        .related-tool-card { display: block; padding: 0.75rem; background: #f8f9fa; border-radius: 8px; text-decoration: none; color: inherit; border: 1px solid transparent; }
        .related-tool-card:hover { background: var(--theme-light); border-color: var(--theme-primary); text-decoration: none; }
        .related-tool-card h6 { color: var(--theme-primary); margin-bottom: 0.25rem; font-size: 0.85rem; }
        .related-tool-card p { font-size: 0.75rem; color: #6c757d; margin: 0; }
        .sticky-result { position: sticky; top: 80px; z-index: 100; }
        @media (max-width: 991px) { .sticky-result { position: relative; top: 0; } }
        .message-input-highlight { border: 2px solid var(--theme-primary) !important; box-shadow: 0 0 0 3px rgba(124, 58, 237, 0.1); }
    </style>

    <% String hex = Utils.toHexEncoded(Utils.getIV(24)); %>

    <script type="text/javascript">
        var lastResult = null;
        var lastCiphertext = '';

        $(document).ready(function() {
            $('#plaintext, #secretkey, #nonce').on('input', debounce(function() {
                if ($('#plaintext').val().trim() !== '' && $('#secretkey').val().trim() !== '') {
                    $('#form').submit();
                }
            }, 500));

            $('input[name="encryptorDecrypt"]').change(function() {
                updateMessageLabel();
                if ($('#plaintext').val().trim() !== '') { $('#form').submit(); }
            });

            $('#form').submit(function(event) {
                event.preventDefault();
                if (!$('#plaintext').val().trim()) { showToast('Please enter a message'); return; }
                $('.result-placeholder').html('<i class="fas fa-spinner fa-spin"></i><span>Processing...</span>').show();
                $('.result-content').hide();
                $.ajax({
                    type: "POST", url: "NaclFunctionality", data: $("#form").serialize(), dataType: "json",
                    success: function(response) { lastResult = response; renderResult(response); },
                    error: function() { showToast('An error occurred'); $('.result-placeholder').html('<i class="fas fa-lock"></i><span>Result will appear here</span>').show(); }
                });
            });
            updateMessageLabel();
        });

        function renderResult(response) {
            $('.result-placeholder').hide();
            var $content = $('.result-content');
            $content.empty();
            if (!response.success) {
                $content.html('<div class="alert alert-danger mb-0"><i class="fas fa-exclamation-circle me-2"></i><strong>Error:</strong> ' + escapeHtml(response.errorMessage) + '</div>');
                $content.show(); return;
            }
            var html = '';
            if (response.operation === 'encrypt') {
                lastCiphertext = response.ciphertext;
                html = '<div class="mb-2"><div class="d-flex justify-content-between align-items-center mb-2"><label class="small font-weight-bold text-success"><i class="fas fa-lock me-1"></i>Encrypted (Hex)</label><span class="badge" style="background: var(--theme-gradient); color: white;">' + escapeHtml(response.algorithm) + '</span></div><textarea class="form-control" rows="4" readonly id="resultOutput">' + escapeHtml(response.ciphertext) + '</textarea><div class="mt-2 d-flex gap-2 flex-wrap"><button class="btn btn-sm btn-outline-success" onclick="copyToClipboard(\'resultOutput\')"><i class="fas fa-copy me-1"></i>Copy</button><button class="btn btn-sm btn-outline-primary" onclick="useForDecrypt()"><i class="fas fa-redo me-1"></i>Decrypt This</button></div></div>';
            } else {
                html = '<div class="mb-2"><div class="d-flex justify-content-between align-items-center mb-2"><label class="small font-weight-bold text-primary"><i class="fas fa-unlock me-1"></i>Decrypted</label><span class="badge" style="background: var(--theme-gradient); color: white;">' + escapeHtml(response.algorithm) + '</span></div><textarea class="form-control" rows="4" readonly id="resultOutput">' + escapeHtml(response.plaintext) + '</textarea><div class="mt-2"><button class="btn btn-sm btn-outline-primary" onclick="copyToClipboard(\'resultOutput\')"><i class="fas fa-copy me-1"></i>Copy</button></div></div>';
            }
            $content.html(html).show();
            if ($(window).width() < 992) { $('html, body').animate({ scrollTop: $('#resultCard').offset().top - 20 }, 300); }
        }

        function debounce(func, wait) { var timeout; return function() { var context = this, args = arguments; clearTimeout(timeout); timeout = setTimeout(function() { func.apply(context, args); }, wait); }; }
        function updateMessageLabel() { var isEncrypt = $('input[name="encryptorDecrypt"]:checked').val() === 'encrypt'; $('#messageLabel').html(isEncrypt ? '<i class="fas fa-comment me-1"></i>Plaintext Message' : '<i class="fas fa-lock me-1"></i>Ciphertext (Hex)'); $('#plaintext').attr('placeholder', isEncrypt ? 'Enter message to encrypt...' : 'Enter hex ciphertext to decrypt...'); }
        function useForDecrypt() { if (lastCiphertext) { $('#plaintext').val(lastCiphertext); $('#decrypt').prop('checked', true); updateMessageLabel(); $('#form').submit(); } }
        function copyToClipboard(elementId) { var text = document.getElementById(elementId).value; if (text) { navigator.clipboard.writeText(text).then(function() { showToast('Copied to clipboard!'); }); } }
        function downloadResult() { if (!lastResult || !lastResult.success) { showToast('No result to download'); return; } var content = lastResult.ciphertext || lastResult.plaintext; var filename = lastResult.operation === 'encrypt' ? 'nacl-xsalsa20-ciphertext.txt' : 'nacl-xsalsa20-plaintext.txt'; var blob = new Blob([content], { type: 'text/plain' }); var url = URL.createObjectURL(blob); var a = document.createElement('a'); a.href = url; a.download = filename; document.body.appendChild(a); a.click(); document.body.removeChild(a); URL.revokeObjectURL(url); showToast('Downloaded: ' + filename); }
        function shareUrl() { if (!lastResult || !lastResult.success) { showToast('No result to share'); return; } var params = { ciphertext: lastResult.ciphertext || '', nonce: $('#nonce').val(), algo: 'xsalsa20' }; var baseUrl = window.location.origin + window.location.pathname; var queryString = Object.keys(params).map(function(key) { return encodeURIComponent(key) + '=' + encodeURIComponent(params[key]); }).join('&'); navigator.clipboard.writeText(baseUrl + '?' + queryString).then(function() { showToast('Share URL copied! (Note: Does not include secret key)'); }); }
        function clearAll() { $('#plaintext').val(''); $('.result-placeholder').html('<i class="fas fa-lock"></i><span>Result will appear here</span>').show(); $('.result-content').hide().empty(); lastResult = null; lastCiphertext = ''; }
        function showToast(message) { var toast = $('<div class="position-fixed" style="bottom: 20px; right: 20px; z-index: 9999;"><div class="toast show"><div class="toast-body text-white rounded" style="background: var(--theme-gradient);"><i class="fas fa-info-circle me-2"></i>' + message + '</div></div></div>'); $('body').append(toast); setTimeout(function() { toast.fadeOut(function() { toast.remove(); }); }, 2500); }
        function escapeHtml(text) { if (!text) return ''; var div = document.createElement('div'); div.textContent = text; return div.innerHTML; }
    </script>
</head>

<%@ include file="body-script.jsp"%>

<div class="container-fluid py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h1 class="h4 mb-1">NaCl XSalsa20 Encryption & Decryption</h1>
            <div class="mt-1">
                <span class="info-badge"><i class="fas fa-key"></i> Symmetric</span>
                <span class="info-badge"><i class="fas fa-stream"></i> Stream Cipher</span>
                <span class="info-badge"><i class="fas fa-shield-alt"></i> 256-bit Key</span>
            </div>
        </div>
        <div class="eeat-badge"><i class="fas fa-user-check"></i><span>Anish Nath</span></div>
    </div>

    <div class="row">
        <div class="col-lg-5 mb-4">
            <div class="card tool-card">
                <div class="card-header card-header-custom">
                    <h6 class="mb-0"><i class="fas fa-lock me-2"></i>XSalsa20 Stream Cipher</h6>
                </div>
                <div class="card-body">
                    <form id="form" method="POST">
                        <input type="hidden" name="methodName" id="methodName" value="NACL_crypto_stream_xsalsa20_xor">
                        <div class="form-section message-input-highlight">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <label class="form-section-title mb-0" id="messageLabel"><i class="fas fa-comment me-1"></i>Plaintext Message</label>
                                <div class="d-flex gap-2">
                                    <div class="form-check form-check-inline mb-0">
                                        <input class="form-check-input" id="encrypt" type="radio" name="encryptorDecrypt" value="encrypt" checked>
                                        <label class="form-check-label small" for="encrypt">Encrypt</label>
                                    </div>
                                    <div class="form-check form-check-inline mb-0">
                                        <input class="form-check-input" id="decrypt" type="radio" name="encryptorDecrypt" value="decrypt">
                                        <label class="form-check-label small" for="decrypt">Decrypt</label>
                                    </div>
                                </div>
                            </div>
                            <textarea class="form-control" rows="3" name="plaintext" id="plaintext" placeholder="Enter message to encrypt..." autofocus></textarea>
                        </div>
                        <div class="form-section">
                            <label class="form-section-title"><i class="fas fa-key me-1"></i>Secret Key (32 chars)</label>
                            <input type="password" class="form-control mb-3" name="secretkey" id="secretkey" placeholder="32-character secret key" value="thisismystrongpasswordof32bitkey">
                            <small class="text-muted d-block mb-3">Key must be exactly 32 characters (256 bits)</small>
                            <label class="form-section-title"><i class="fas fa-random me-1"></i>Nonce (24 bytes hex)</label>
                            <input type="text" class="form-control" name="nonce" id="nonce" placeholder="48 hex characters (24 bytes)" value="<%= hex %>">
                            <small class="text-muted">192-bit nonce in hexadecimal. Must be unique per message!</small>
                        </div>
                        <div class="d-flex gap-2 flex-wrap">
                            <button type="submit" class="btn btn-generate"><i class="fas fa-play me-1"></i> Process</button>
                            <button type="button" class="btn btn-action" onclick="clearAll()"><i class="fas fa-eraser me-1"></i> Clear</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-lg-7 mb-4">
            <div class="card tool-card mb-3 sticky-result" id="resultCard">
                <div class="card-header bg-light d-flex justify-content-between align-items-center">
                    <h6 class="mb-0"><i class="fas fa-check-circle me-2 text-success"></i>Result</h6>
                    <div>
                        <button class="btn btn-sm btn-outline-secondary me-1" onclick="downloadResult()" title="Download"><i class="fas fa-download"></i></button>
                        <button class="btn btn-sm btn-outline-primary" onclick="shareUrl()" title="Share URL"><i class="fas fa-share-alt"></i></button>
                    </div>
                </div>
                <div class="card-body" style="min-height: 150px;">
                    <div class="result-placeholder"><i class="fas fa-lock"></i><span>Result will appear here</span></div>
                    <div class="result-content"></div>
                </div>
            </div>
            <div class="card tool-card">
                <div class="card-header bg-light py-2"><h6 class="mb-0"><i class="fas fa-info-circle me-2"></i>XSalsa20 Parameters</h6></div>
                <div class="card-body">
                    <table class="table table-sm table-bordered mb-0">
                        <thead class="table-light"><tr><th>Parameter</th><th>Size</th><th>Description</th></tr></thead>
                        <tbody>
                            <tr><td><strong>Key</strong></td><td>256 bits (32 bytes)</td><td>Secret symmetric key</td></tr>
                            <tr><td><strong>Nonce</strong></td><td>192 bits (24 bytes)</td><td>Unique per message</td></tr>
                            <tr><td><strong>Output</strong></td><td>Same as input</td><td>XOR with keystream</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Related NaCl Tools -->
    <div class="card tool-card mb-4">
        <div class="card-header bg-light py-2"><h6 class="mb-0"><i class="fas fa-tools me-2"></i>Related NaCl/Libsodium Tools</h6></div>
        <div class="card-body">
            <div class="related-tools">
                <a href="naclencdec.jsp" class="related-tool-card" style="background: var(--theme-light); border-color: var(--theme-primary);"><h6><i class="fas fa-stream me-1"></i>XSalsa20</h6><p>Stream cipher (current)</p></a>
                <a href="naclaead.jsp" class="related-tool-card"><h6><i class="fas fa-shield-alt me-1"></i>AEAD</h6><p>Authenticated encryption</p></a>
                <a href="naclboxenc.jsp" class="related-tool-card"><h6><i class="fas fa-box me-1"></i>Box</h6><p>Public-key authenticated</p></a>
                <a href="naclsealboxenc.jsp" class="related-tool-card"><h6><i class="fas fa-envelope me-1"></i>SealedBox</h6><p>Anonymous public-key</p></a>
                <a href="CipherFunctions.jsp" class="related-tool-card"><h6><i class="fas fa-lock me-1"></i>AES/DES</h6><p>Block cipher encryption</p></a>
                <a href="fernet.jsp" class="related-tool-card"><h6><i class="fas fa-key me-1"></i>Fernet</h6><p>Python symmetric encryption</p></a>
            </div>
        </div>
    </div>

    <!-- Educational Content -->
    <div class="card tool-card mb-4">
        <div class="card-header bg-light"><h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding NaCl XSalsa20</h5></div>
        <div class="card-body">
            <h6>What is XSalsa20?</h6>
            <p>XSalsa20 is a stream cipher designed by Daniel J. Bernstein. It's an extended-nonce variant of Salsa20, used in NaCl (Networking and Cryptography library) and libsodium. The "X" indicates the extended 192-bit nonce (vs Salsa20's 64-bit nonce).</p>
            <h6 class="mt-4">How crypto_stream_xsalsa20_xor Works</h6>
            <div class="row">
                <div class="col-md-6"><div class="p-3 bg-light rounded mb-3"><strong><i class="fas fa-lock text-success"></i> Encryption</strong><ol class="small mb-0 mt-2"><li>Generate keystream from key + nonce</li><li>XOR plaintext with keystream</li><li>Output ciphertext (same length)</li></ol></div></div>
                <div class="col-md-6"><div class="p-3 bg-light rounded mb-3"><strong><i class="fas fa-unlock text-primary"></i> Decryption</strong><ol class="small mb-0 mt-2"><li>Generate same keystream (key + nonce)</li><li>XOR ciphertext with keystream</li><li>Recover original plaintext</li></ol></div></div>
            </div>
            <h6 class="mt-4">NaCl Stream Ciphers Comparison</h6>
            <table class="table table-sm table-bordered">
                <thead class="table-light"><tr><th>Function</th><th>Primitive</th><th>Key Size</th><th>Nonce Size</th></tr></thead>
                <tbody>
                    <tr class="table-success"><td><strong>crypto_stream_xsalsa20</strong></td><td>XSalsa20/20</td><td>32 bytes</td><td>24 bytes</td></tr>
                    <tr><td>crypto_stream_salsa20</td><td>Salsa20/20</td><td>32 bytes</td><td>8 bytes</td></tr>
                    <tr><td>crypto_stream_salsa2012</td><td>Salsa20/12</td><td>32 bytes</td><td>8 bytes</td></tr>
                    <tr><td>crypto_stream_aes128ctr</td><td>AES-128-CTR</td><td>16 bytes</td><td>16 bytes</td></tr>
                </tbody>
            </table>
            <div class="alert alert-warning mt-4"><strong><i class="fas fa-exclamation-triangle me-1"></i>Security Note:</strong> XSalsa20 provides <strong>confidentiality only</strong>, not authentication. For authenticated encryption, use <a href="naclaead.jsp">NaCl secretbox (AEAD)</a>.</div>
        </div>
    </div>

    <div class="sharethis-inline-share-buttons mb-4"></div>
    <%@ include file="thanks.jsp"%>

    <%-- Common NaCl Information Section --%>
    <%@ include file="nacl-info.jsp"%>

    <%@ include file="addcomments.jsp"%>
</div>

<%@ include file="footer_adsense.jsp"%>
</div>
<%@ include file="body-close.jsp"%>
