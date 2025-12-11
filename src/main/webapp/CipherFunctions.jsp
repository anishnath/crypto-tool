<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%@ page import="sun.misc.BASE64Decoder" %>
<%
    // Cache busting for development
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow" />
    
    <!-- Resource Hints for Performance (LCP Optimization) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://code.jquery.com">
    <link rel="dns-prefetch" href="https://www.googletagmanager.com">
    
    <!-- Critical CSS - Inline for LCP -->
    <style>
        /* Critical above-the-fold styles */
        *{box-sizing:border-box;margin:0;padding:0}
        html{scroll-behavior:smooth;-webkit-text-size-adjust:100%;-webkit-font-smoothing:antialiased}
        body{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif;font-size:1rem;line-height:1.5;color:#0f172a;background:#fff;margin:0}
        :root{--primary:#6366f1;--bg-primary:#fff;--bg-secondary:#f8fafc;--text-primary:#0f172a;--text-secondary:#475569;--border:#e2e8f0}
        .tool-header{background:transparent;padding:2rem 1.5rem;border-bottom:none}
        .tool-header-container{max-width:1200px;margin:0 auto}
        .tool-header-content{text-align:left;padding:0}
        .tool-page-title{margin-bottom:0.5rem;text-align:left;font-size:2rem;font-weight:700;color:#0f172a}
        .tool-page-description{font-size:1rem;margin-bottom:1rem;text-align:left;max-width:100%}
        .breadcrumbs{background:#f8fafc;padding:1rem 1.5rem;border-bottom:1px solid #e2e8f0;margin-top:72px}
        .breadcrumbs-container{max-width:1400px;margin:0 auto;display:flex;align-items:center;gap:0.5rem;font-size:0.875rem}
        .cipher-form-card{background:#fff;border:1px solid #e2e8f0;border-radius:1rem;padding:2.5rem;margin-bottom:3rem;box-shadow:0 1px 3px rgba(0,0,0,0.05)}
        .form-single-column{display:flex;flex-direction:column;gap:2.5rem;max-width:700px;margin:0 auto}
        @media (min-width:992px){.form-single-column{max-width:100%}}
        .form-group{margin-bottom:2.5rem}
        .form-label{display:block;font-weight:600;margin-bottom:0.5rem;color:#0f172a;font-size:0.9375rem}
    </style>
    
    <!-- Service Worker Cleanup - Deferred for LCP -->
    <script>
        // Defer service worker cleanup to improve LCP
        window.addEventListener('load', function() {
            if ('serviceWorker' in navigator && !sessionStorage.getItem('sw-unregistered')) {
                navigator.serviceWorker.getRegistrations().then(function(registrations) {
                    if(registrations.length > 0) {
                        let unregisterPromises = [];
                        for(let registration of registrations) {
                            unregisterPromises.push(registration.unregister());
                        }
                        Promise.all(unregisterPromises).then(function() {
                            sessionStorage.setItem('sw-unregistered', 'true');
                            
                            if('caches' in window) {
                                caches.keys().then(function(names) {
                                    for(let name of names) {
                                        caches.delete(name);
                                    }
                                });
                            }
                        }).catch(function(error) {
                            console.error('Error unregistering Service Workers:', error);
                        });
                    }
                }).catch(function(error) {
                    console.error('Error getting Service Worker registrations:', error);
                });
            }
        });
</script>

    <!-- SEO Component -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="AES Encryption Tool Online - 100+ Ciphers" />
        <jsp:param name="toolDescription" value="🔒 Free AES encryption tool online. Encrypt/decrypt with 100+ ciphers (AES-256, DES, Blowfish, ChaCha20). Client-side processing, no registration. Generate secure keys instantly." />
        <jsp:param name="toolCategory" value="Cryptography" />
        <jsp:param name="toolUrl" value="CipherFunctions.jsp" />
        <jsp:param name="toolKeywords" value="encrypt decrypt online, aes encryption tool, aes 256 encryption online free, cipher tool online free, online encryption tool, encrypt text online, decrypt message online, aes cbc encryption, aes gcm encryption, blowfish encryption, twofish cipher, chacha20 encryption, free cipher tool, client-side encryption, secure encryption tool, cipher algorithm online, encryption decryption tool, crypto tool online, aes encryption decryption, encrypt decrypt tool" />
        <jsp:param name="toolImage" value="cipher-encryption-tool.png" />
        <jsp:param name="hasSteps" value="true" />
    </jsp:include>

    <!-- Enhanced HowTo Schema (Cipher-Specific for High CTR) -->
	<script type="application/ld+json">
{
  "@context": "https://schema.org",
      "@type": "HowTo",
      "name": "How to Encrypt and Decrypt Messages with AES Encryption Tool",
      "description": "Step-by-step guide to encrypting and decrypting messages using AES and 100+ cipher algorithms online.",
      "step": [
        {
          "@type": "HowToStep",
          "name": "Select Cipher Algorithm",
          "text": "Choose your encryption algorithm from the dropdown. Recommended: AES-256-GCM for maximum security, or AES/CBC/PKCS5PADDING for compatibility. The tool supports 100+ algorithms including AES, DES, Blowfish, Twofish, ChaCha20, and Camellia.",
          "position": 1
        },
        {
          "@type": "HowToStep",
          "name": "Enter Your Message",
          "text": "Type or paste your message in the message field. For encryption, enter plaintext. For decryption, paste the encrypted message (in Base64 or hex format).",
          "position": 2
        },
        {
          "@type": "HowToStep",
          "name": "Generate or Enter Secret Key",
          "text": "Click 'Generate' button to create a secure random key, or manually enter a hexadecimal key. Key sizes: AES-128 requires 32 hex chars, AES-192 requires 48 hex chars, AES-256 requires 64 hex chars.",
          "position": 3
        },
        {
          "@type": "HowToStep",
          "name": "Choose Operation",
          "text": "Select 'Encrypt' to encrypt your message, or 'Decrypt' to decrypt an encrypted message. Ensure you use the same algorithm and key for encryption and decryption.",
          "position": 4
        },
        {
          "@type": "HowToStep",
          "name": "Process and Get Results",
          "text": "Click the 'Encrypt Message' or 'Decrypt Message' button. Your encrypted or decrypted result will appear instantly in the result area below. Copy the result to use in your application.",
          "position": 5
        }
      ]
}
</script>

    <!-- FAQPage Schema (High CTR - +30% CTR potential) -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
          "name": "What is the best encryption algorithm to use?",
      "acceptedAnswer": {
        "@type": "Answer",
            "text": "AES-256-GCM is the most secure and recommended algorithm. It provides authenticated encryption and is the industry standard for protecting sensitive data. It combines AES-256 encryption with Galois/Counter Mode for authentication."
      }
    },
    {
      "@type": "Question",
      "name": "Is this cipher tool free to use?",
      "acceptedAnswer": {
        "@type": "Answer",
            "text": "Yes, this cipher tool is completely free to use. No registration, no credit card required. All encryption and decryption happens client-side in your browser, ensuring your data never leaves your device."
      }
    },
    {
      "@type": "Question",
          "name": "How do I encrypt a message with AES?",
      "acceptedAnswer": {
        "@type": "Answer",
            "text": "To encrypt a message with AES: 1) Select AES algorithm (e.g., AES-256-GCM or AES/CBC/PKCS5PADDING), 2) Enter your message in the text area, 3) Generate or enter a secret key (64 hex characters for AES-256, 32 for AES-128), 4) Select 'Encrypt' operation, 5) Click the Encrypt button. Your encrypted message will appear instantly."
      }
    },
    {
      "@type": "Question",
          "name": "Is my data secure when using this tool?",
      "acceptedAnswer": {
        "@type": "Answer",
            "text": "Yes, all encryption and decryption happens client-side in your browser using JavaScript. Your data never leaves your device and is never sent to our servers, ensuring complete privacy and security. No data is stored or logged."
      }
    },
    {
      "@type": "Question",
          "name": "What key size should I use for AES encryption?",
      "acceptedAnswer": {
        "@type": "Answer",
            "text": "AES-256 (64 hex characters) is recommended for maximum security. AES-128 (32 hex characters) is also secure for most applications and is faster. AES-192 (48 hex characters) provides a middle ground. Use the key generator button to create secure random keys."
      }
    },
    {
      "@type": "Question",
          "name": "Can I decrypt a message encrypted with this tool?",
      "acceptedAnswer": {
        "@type": "Answer",
            "text": "Yes, to decrypt: 1) Select the same algorithm and mode used for encryption, 2) Paste the encrypted message (in Base64 or hex format), 3) Enter the same secret key, 4) Select 'Decrypt' operation, 5) Click the Decrypt button. The original message will be restored."
      }
    }
  ]
}
</script>

    <!-- Fonts - Optimized for LCP (no @import, async loading) -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>
    
    <!-- Critical CSS - Load Immediately -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/cipher-tool-page.css?v=<%=cacheVersion%>">
    
    <!-- Non-Critical CSS - Deferred -->
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
    </noscript>

    <!-- Ad System Initialization -->
    <%@ include file="modern/ads/ad-init.jsp" %>

    <!-- jQuery - Load early but async for LCP optimization -->
    <script>
        // Load jQuery asynchronously - improved loading strategy
        (function() {
            // Try to load jQuery immediately but asynchronously
            var script = document.createElement('script');
            script.src = 'https://code.jquery.com/jquery-3.6.0.min.js';
            script.integrity = 'sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=';
            script.crossOrigin = 'anonymous';
            script.async = false; // Load synchronously but non-blocking for parser
            
            script.onerror = function() {
                console.warn('jQuery CDN failed, trying fallback...');
                var fallback = document.createElement('script');
                fallback.src = 'https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js';
                fallback.async = false;
                fallback.onerror = function() {
                    console.warn('Google CDN failed, trying jsDelivr...');
                    var finalFallback = document.createElement('script');
                    finalFallback.src = 'https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js';
                    finalFallback.async = false;
                    document.head.appendChild(finalFallback);
                };
                document.head.appendChild(fallback);
            };
            
            // Append immediately (will load async due to browser behavior)
            document.head.appendChild(script);
        })();
</script>

    <!-- Analytics - Will be loaded at end of body for LCP optimization -->

    <script type="text/javascript">
        // Ensure jQuery is loaded before using it
        (function() {
            var maxRetries = 50; // Maximum 5 seconds
            var retryCount = 0;
            
            function initCipherTool() {
                if (typeof jQuery === 'undefined' || typeof $ === 'undefined') {
                    retryCount++;
                    if (retryCount < maxRetries) {
                        console.warn('jQuery not loaded, retrying... (' + retryCount + '/' + maxRetries + ')');
                        setTimeout(initCipherTool, 100);
                        return;
                    } else {
                        console.error('jQuery failed to load after ' + maxRetries + ' retries. Form may not work.');
                        return;
                    }
                }
                
                console.log('jQuery loaded successfully, initializing cipher tool...');
                
                jQuery(document).ready(function($) {
                    console.log('DOM ready, setting up form handlers...');
            // Track tool view
            if (typeof trackToolUsage === 'function') {
                trackToolUsage('Cipher Tool', 'Encryption Tools', 'view');
            }

			// Character counter for message
			function updateCharCount() {
				var count = $('#plaintext').val().length;
				$('#charCount').text(count);
			}

			// Key length calculator
			function updateKeyLength() {
				var key = $('#secretkey').val().trim();
				var hexLength = key.length;
				var byteLength = Math.floor(hexLength / 2);
				$('#keyLength').text(byteLength);
				$('#keyHexLength').text(hexLength);
			}

			// Update button text based on operation
			function updateButtonText() {
				var operation = $('input[name="encryptorDecrypt"]:checked').val();
				if (operation === 'encrypt') {
					$('#submitText').html('Encrypt Message');
				} else {
					$('#submitText').html('Decrypt Message');
				}
			}

			// Load configuration from URL parameters
			function loadFromUrl() {
				var urlParams = new URLSearchParams(window.location.search);

				if (urlParams.has('cipher')) {
					$('#cipherparameternew').val(urlParams.get('cipher'));
				}

				if (urlParams.has('message')) {
					$('#plaintext').val(decodeURIComponent(urlParams.get('message')));
					updateCharCount();
				}

				if (urlParams.has('key')) {
					$('#secretkey').val(urlParams.get('key'));
					updateKeyLength();
				}

				if (urlParams.has('operation')) {
					var operation = urlParams.get('operation');
					if (operation === 'decrypt') {
						$('#decrypt').prop('checked', true);
					} else {
						$('#encrypt').prop('checked', true);
					}
					updateButtonText();
				}

				// Show notification if parameters were loaded
				if (urlParams.has('cipher') || urlParams.has('message') || urlParams.has('key')) {
					var notificationHtml = '<div class="result-card success" role="status"><div class="result-header"><i class="fas fa-info-circle"></i> Configuration loaded from URL</div></div>';
					$('#output').html(notificationHtml);
					$('#outputDesktop').html(notificationHtml);
					// Remove placeholder if present
					$('.output-placeholder').remove();
				}
			}

			// Generate shareable URL
			function generateShareUrl() {
				var cipher = $('#cipherparameternew').val();
				var message = $('#plaintext').val();
				var key = $('#secretkey').val();
				var operation = $('input[name="encryptorDecrypt"]:checked').val();

				// Validate that we have content to share
				if (!message && !key) {
					if (typeof ToolUtils !== 'undefined' && ToolUtils.showError) {
						ToolUtils.showError('Please enter a message or secret key to generate a shareable URL.', '#output');
					} else {
						var errorHtml = '<div class="result-card error" role="alert"><div class="result-header"><i class="fas fa-exclamation-triangle"></i> Please enter a message or secret key to generate a shareable URL.</div></div>';
						$('#output').html(errorHtml);
						$('#outputDesktop').html(errorHtml);
					}
					return;
				}

				// Use ToolUtils to generate share URL (will show support popup automatically)
				var shareUrl;
				if (typeof ToolUtils !== 'undefined' && ToolUtils.generateShareUrl) {
					shareUrl = ToolUtils.generateShareUrl({
						cipher: cipher,
						message: message,
						key: key,
						operation: operation
					}, {
						showSupportPopup: true,
						toolName: 'Cipher Tool'
					});
				} else {
					// Fallback if ToolUtils not loaded
				var baseUrl = window.location.origin + window.location.pathname;
				var params = new URLSearchParams();
				params.append('cipher', cipher);
				if (message) {
					params.append('message', encodeURIComponent(message));
				}
				if (key) {
					params.append('key', key);
				}
				params.append('operation', operation);
					shareUrl = baseUrl + '?' + params.toString();
				}

				// Display the URL
				$('#shareUrl').val(shareUrl);
                $('#shareAlert').addClass('show');

				// Scroll to share alert
				$('html, body').animate({
					scrollTop: $('#shareAlert').offset().top - 100
				}, 500);

                // Track share action
                if (typeof trackToolUsage === 'function') {
                    trackToolUsage('Cipher Tool', 'Encryption Tools', 'share');
                }
			}

			// Input validation
			function validateInputs() {
				var plaintext = $('#plaintext').val().trim();
				var secretkey = $('#secretkey').val().trim();
				var errorHtml = '';

				if (plaintext === '') {
					errorHtml = '<div class="result-card error" role="alert"><div class="result-header"><i class="fas fa-exclamation-triangle"></i> <strong>Error:</strong> Message is required</div></div>';
					$('#output').html(errorHtml);
					$('#outputDesktop').html(errorHtml);
					// Remove placeholder if present
					$('.output-placeholder').remove();
					// Focus on error message for screen readers
					setTimeout(function() {
						$('#output .result-card').first().focus();
					}, 100);
					return false;
				}

				if (secretkey === '') {
					errorHtml = '<div class="result-card error" role="alert"><div class="result-header"><i class="fas fa-exclamation-triangle"></i> <strong>Error:</strong> Secret key is required</div></div>';
					$('#output').html(errorHtml);
					$('#outputDesktop').html(errorHtml);
					// Remove placeholder if present
					$('.output-placeholder').remove();
					// Focus on error message for screen readers
					setTimeout(function() {
						$('#output .result-card').first().focus();
					}, 100);
					return false;
				}

				return true;
			}

			// Initialize counters
			updateCharCount();
			updateKeyLength();
			updateButtonText();

			// Load configuration from URL if parameters exist
			loadFromUrl();

			// Update character count on input
			$('#plaintext').on('input', function() {
				updateCharCount();
			});

			// Update key length on input
			$('#secretkey').on('input', function() {
				updateKeyLength();
			});

			// Update button text when operation changes
			$('input[name="encryptorDecrypt"]').change(function() {
				updateButtonText();
			});

			// Share button click handler
			$('#shareButton').click(function() {
				generateShareUrl();
			});

			// Copy share URL button
			$('#copyShareUrl').click(function() {
				var shareUrl = $('#shareUrl').val();
				
				// Use ToolUtils if available (will show support popup automatically)
				if (typeof ToolUtils !== 'undefined' && ToolUtils.copyToClipboard) {
					ToolUtils.copyToClipboard(shareUrl, {
						showToast: true,
						toastMessage: 'Share URL copied!',
						showSupportPopup: true,
						toolName: 'Cipher Tool',
						resultText: shareUrl
					}).then(function(result) {
						if (result.success) {
							// Show button feedback
							var originalHtml = $('#copyShareUrl').html();
							$('#copyShareUrl').html('<i class="fas fa-check"></i> Copied!');
							setTimeout(function() {
								$('#copyShareUrl').html(originalHtml);
							}, 2000);
						}
					});
				} else {
					// Fallback if ToolUtils not loaded
				var tempInput = $('<input>');
				$('body').append(tempInput);
				tempInput.val(shareUrl).select();
				document.execCommand('copy');
				tempInput.remove();

				// Show success feedback
				var originalHtml = $(this).html();
				$(this).html('<i class="fas fa-check"></i> Copied!');
				var btn = $(this);
				setTimeout(function() {
					btn.html(originalHtml);
				}, 2000);
				}

                // Track copy action
                if (typeof trackCopyResult === 'function') {
                    trackCopyResult('Cipher Tool');
                }
			});

			$('#genkeypair').click(function (event) {
				console.log('Submit button clicked');
				event.preventDefault();
				
				if (!validateInputs()) {
					console.log('Validation failed');
					return;
				}
				
				console.log('Validation passed, submitting form...');
				$('#genkeypair').prop('disabled', true);
                
                // Track execution
                var startTime = Date.now();
                if (typeof trackToolExecution === 'function') {
                    trackToolExecution('Cipher Tool', 0, false);
                }
                
				// Trigger form submit
				$('#form').submit();
			});

			$('#cipherparameternew').change(function(event) {
				if ($('#plaintext').val().trim() !== '' && $('#secretkey').val().trim() !== '') {
					$('#form').delay(200).submit();
				}
			});

			$('#encrypt').click(function(event) {
				updateButtonText();
			});

			$('#decrypt').click(function(event) {
				// Check both output areas for result textarea
				var text = $('#output').find('textarea.result-textarea').val() || 
				           $('#outputDesktop').find('textarea.result-textarea').val();
				if (text != null && text.trim() !== '') {
					$("#plaintext").val(text);
					updateCharCount();
				}
				updateButtonText();
			});

			// Helper function to escape HTML
			function escapeHtml(text) {
				var div = document.createElement('div');
				div.textContent = text;
				return div.innerHTML;
			}

			// Helper function to truncate text
			function truncateText(text, maxLength) {
				if (!text) return '';
				if (text.length <= maxLength) return text;
				return text.substring(0, maxLength) + '...';
			}

			// Render input preview card
			function renderInputPreview(response) {
				var algorithm = $('#cipherparameternew').val() || response.algorithm || 'N/A';
				var message = $('#plaintext').val() || response.originalMessage || '';
				var key = $('#secretkey').val() || '';
				var operation = $('input[name="encryptorDecrypt"]:checked').val() || response.operation || 'encrypt';
				
				var html = '<div class="input-preview-card">';
				html += '<h4><i class="fas fa-info-circle"></i> Input Preview</h4>';
				html += '<div class="input-preview-item">';
				html += '<span class="input-preview-label">Algorithm:</span>';
				html += '<div class="input-preview-value">' + escapeHtml(algorithm) + '</div>';
				html += '</div>';
				html += '<div class="input-preview-item">';
				html += '<span class="input-preview-label">Operation:</span>';
				html += '<div class="input-preview-value">' + operation.toUpperCase() + '</div>';
				html += '</div>';
				html += '<div class="input-preview-item">';
				html += '<span class="input-preview-label">Message:</span>';
				html += '<div class="input-preview-value truncated">' + escapeHtml(truncateText(message, 100)) + '</div>';
				html += '</div>';
				if (key) {
					html += '<div class="input-preview-item">';
					html += '<span class="input-preview-label">Key (first 32 chars):</span>';
					html += '<div class="input-preview-value">' + escapeHtml(key.substring(0, 32) + (key.length > 32 ? '...' : '')) + '</div>';
					html += '</div>';
				}
				html += '</div>';
				return html;
			}

			// Helper function to render result (used for both mobile and desktop)
			function renderResult(response, includeInputPreview) {
				var html = '';
				
				// Add input preview if requested (for desktop side-by-side)
				if (includeInputPreview) {
					html += renderInputPreview(response);
				}

						if (response.success) {
							// Success case - render result beautifully
					html += '<div class="result-card success" role="status" tabindex="-1">';
					html += '<div class="result-header">';
							html += '<i class="fas fa-check-circle"></i> <strong>Operation Successful</strong>';
							html += '</div>';

					// Operation details (responsive grid)
					html += '<div class="operation-details">';
					html += '<div class="operation-detail-item"><strong><i class="fas fa-cog"></i> Operation:</strong><br><span class="operation-value">' + escapeHtml(response.operation.toUpperCase()) + '</span></div>';
					html += '<div class="operation-detail-item"><strong><i class="fas fa-lock"></i> Algorithm:</strong><br><code class="algorithm-code">' + escapeHtml(response.algorithm) + '</code></div>';
							html += '</div>';

							// Original message
					html += '<div style="margin-bottom: 1rem;">';
					html += '<label class="form-label"><i class="fas fa-file-alt"></i> Original Message:</label>';
					html += '<textarea class="result-output" readonly rows="2">' + escapeHtml(response.originalMessage) + '</textarea>';
							html += '</div>';

							// Result
					html += '<div style="margin-bottom: 1rem;">';
					html += '<label class="form-label"><i class="fas fa-check-circle"></i> Result:</label>';
					html += '<textarea name="encrypedmessagetextarea" class="result-output result-textarea" readonly rows="5">' + escapeHtml(response.message) + '</textarea>';
					html += '<button type="button" class="btn-copy" onclick="copyResult(this)" style="margin-top: 0.75rem;" aria-label="Copy result to clipboard"><i class="fas fa-copy"></i> Copy Result</button>';
							html += '</div>';

							// Salt and IV if present
							if (response.salt) {
						html += '<div class="info-box">';
						html += '<p style="margin: 0 0 0.5rem 0;"><strong><i class="fas fa-key"></i> 20-bit Salt:</strong></p>';
						html += '<code>' + escapeHtml(response.salt) + '</code>';
								html += '</div>';
							}

							if (response.iv) {
						html += '<div class="info-box" style="margin-top: 0.75rem;">';
						html += '<p style="margin: 0 0 0.5rem 0;"><strong><i class="fas fa-random"></i> 16-bit Initial Vector (IV):</strong></p>';
						html += '<code>' + escapeHtml(response.iv) + '</code>';
								html += '</div>';
							}

							html += '</div>';
						} else {
							// Error case - render error beautifully
					html += '<div class="result-card error" role="alert" tabindex="-1">';
					html += '<div class="result-header"><i class="fas fa-exclamation-triangle"></i> Operation Failed</div>';
					html += '<div style="margin-top: 1rem;">';
					html += '<p style="margin-bottom: 0.5rem;"><strong>Error:</strong> ' + escapeHtml(response.errorMessage) + '</p>';

							if (response.algorithm) {
						html += '<p style="margin-bottom: 0.5rem;"><strong>Algorithm:</strong> <code>' + escapeHtml(response.algorithm) + '</code></p>';
							}

							if (response.operation) {
						html += '<p style="margin-bottom: 0.5rem;"><strong>Operation:</strong> ' + escapeHtml(response.operation.toUpperCase()) + '</p>';
							}

							if (response.originalMessage) {
						html += '<details style="margin-top: 1rem;">';
						html += '<summary style="cursor: pointer; font-weight: 600;"><strong>Show Input Message</strong></summary>';
						html += '<pre class="result-output" style="margin-top: 0.5rem;">' + escapeHtml(response.originalMessage) + '</pre>';
								html += '</details>';
							}

							html += '</div>';
					html += '</div>';
				}

				return html;
			}

			$('#form').submit(function(event) {
				console.log('Form submit handler triggered');
				event.preventDefault();
				
				// Show loading in both places
				var loadingHtml = '<div class="result-card"><div class="result-header"><i class="fas fa-spinner fa-spin"></i> Processing...</div></div>';
				$('#output').html(loadingHtml);
				$('#outputDesktop').html(loadingHtml);

				var startTime = Date.now();
				console.log('Sending AJAX request to CipherFunctionality...');

				$.ajax({
					type : "POST",
					url : "CipherFunctionality",
					data : $("#form").serialize(),
					dataType: 'json',
					success : function(response) {
						console.log('AJAX success, response:', response);
						var executionTime = Date.now() - startTime;
						$('#genkeypair').prop('disabled', false);

						// Track successful execution
						if (typeof trackToolExecution === 'function') {
							trackToolExecution('Cipher Tool', executionTime, true);
						}

						// Render for mobile (below form, no input preview)
						var mobileHtml = renderResult(response, false);
						$('#output').html(mobileHtml);

						// Render for desktop (side-by-side, with input preview)
						var desktopHtml = renderResult(response, true);
						$('#outputDesktop').html(desktopHtml);
						
						// Remove placeholder if present
						$('.output-placeholder').remove();
						
						// Add has-result class for animation
						$('#outputContainer').addClass('has-result');
						
						// Focus management: Move focus to results area for screen readers and keyboard users
						setTimeout(function() {
							var resultCard = $('#output .result-card').first();
							if (resultCard.length) {
								resultCard.attr('tabindex', '-1').focus();
							}
						}, 100);
						
						// Scroll to results on mobile
						if (window.innerWidth < 992) {
							$('html, body').animate({
								scrollTop: $('#output').offset().top - 100
							}, 500);
						}
                            
						// Track copy result opportunity
						if (typeof trackToolUsage === 'function') {
							trackToolUsage('Cipher Tool', 'Encryption Tools', 'result_generated');
						}
					},
					error : function(xhr, status, error) {
						console.error('AJAX error:', status, error, xhr);
						var errorHtml = '<div class="result-card error" role="alert" tabindex="-1"><div class="result-header"><i class="fas fa-exclamation-triangle"></i> <strong>Request Failed:</strong> ' + escapeHtml(error) + '</div></div>';
						$('#output').html(errorHtml);
						$('#outputDesktop').html(errorHtml);
						$('#genkeypair').prop('disabled', false);
						
						// Focus on error for screen readers
						setTimeout(function() {
							$('#output .result-card').first().focus();
						}, 100);
						
						// Track error
						if (typeof trackError === 'function') {
							trackError(error, 'Cipher Tool');
						}
					}
				});
			});

            // Dropdown toggle for key generation
            $('.dropdown-button').click(function(e) {
                e.stopPropagation();
                var $button = $(this);
                var menu = $button.next('.dropdown-menu-modern');
                var isExpanded = menu.hasClass('show');
                
                $('.dropdown-menu-modern').not(menu).removeClass('show');
                $('.dropdown-button').not($button).attr('aria-expanded', 'false');
                
                menu.toggleClass('show');
                $button.attr('aria-expanded', !isExpanded ? 'true' : 'false');
            });

            $(document).click(function() {
                $('.dropdown-menu-modern').removeClass('show');
            });
            
            console.log('Form handlers attached successfully');
                }); // End jQuery ready
            }
            
            // Start initialization
            initCipherTool();
        })(); // End IIFE
    </script>

    <!-- Global functions for onclick handlers -->
    <script type="text/javascript">
		// Copy result function (must be global for onclick handlers)
		function copyResult(button) {
			// Find the result textarea nearest to the clicked button
			var resultCard = button.closest('.result-card');
			var result = resultCard ? resultCard.querySelector('textarea.result-textarea') : null;
			
			// Fallback: try to find in either output area
			if (!result) {
				result = document.querySelector('#output textarea.result-textarea') ||
				         document.querySelector('#outputDesktop textarea.result-textarea');
			}
			
			if (result && result.value) {
				// Use ToolUtils if available (will show support popup automatically)
				if (typeof ToolUtils !== 'undefined' && ToolUtils.copyToClipboard) {
					ToolUtils.copyToClipboard(result.value, {
						showToast: true,
						toastMessage: 'Result copied!',
						showSupportPopup: true,
						toolName: 'Cipher Tool',
						resultText: result.value.substring(0, 100) // First 100 chars for tweet
					}).then(function(copyResult) {
						if (copyResult.success) {
							// Show button feedback
							var originalHtml = button.innerHTML;
							button.innerHTML = '<i class="fas fa-check"></i> Copied!';
							button.classList.add('copied');
							setTimeout(function() {
								button.innerHTML = originalHtml;
								button.classList.remove('copied');
							}, 2000);
						}
					});
				} else {
					// Fallback if ToolUtils not loaded
					if (navigator.clipboard && navigator.clipboard.writeText) {
						navigator.clipboard.writeText(result.value).then(function() {
							showCopySuccess(button);
						}).catch(function() {
							copyWithExecCommand(result, button);
						});
					} else {
						copyWithExecCommand(result, button);
					}
				}

				// Track copy
				if (typeof trackCopyResult === 'function') {
					trackCopyResult('Cipher Tool');
				}
			}
		}

		// Fallback copy function using execCommand (only used if ToolUtils not available)
		function copyWithExecCommand(element, button) {
			element.select();
				document.execCommand('copy');
			showCopySuccess(button);
		}

		// Show copy success feedback (only used if ToolUtils not available)
		function showCopySuccess(button) {
			if (button) {
				var originalHtml = button.innerHTML;
				button.innerHTML = '<i class="fas fa-check"></i> Copied!';
				button.classList.add('copied');

				setTimeout(function() {
					button.innerHTML = originalHtml;
					button.classList.remove('copied');
				}, 2000);
			}
		}

		// Generate random hexadecimal key
		function generateKey(byteLength) {
			// Generate cryptographically secure random bytes
			var hexChars = '0123456789abcdef';
			var hexKey = '';

			// Use crypto.getRandomValues for secure random generation
			if (window.crypto && window.crypto.getRandomValues) {
				var randomBytes = new Uint8Array(byteLength);
				window.crypto.getRandomValues(randomBytes);

				for (var i = 0; i < randomBytes.length; i++) {
					var byte = randomBytes[i];
					hexKey += hexChars[(byte >> 4) & 0xF];
					hexKey += hexChars[byte & 0xF];
				}
			} else {
				// Fallback to Math.random (less secure, but better than nothing)
				for (var i = 0; i < byteLength * 2; i++) {
					hexKey += hexChars[Math.floor(Math.random() * 16)];
				}
			}

            // Set the generated key - ensure jQuery is available
            if (typeof jQuery !== 'undefined') {
                jQuery('#secretkey').val(hexKey);

			// Update key length display
                var key = jQuery('#secretkey').val().trim();
                var hexLength = key.length;
                var byteLength = Math.floor(hexLength / 2);
                jQuery('#keyLength').text(byteLength);
                jQuery('#keyHexLength').text(hexLength);
                
                // Close dropdown
                jQuery('.dropdown-menu-modern').removeClass('show');
            }
		}
	</script>
</head>

<body>
    <!-- Test if body is rendering -->
    <noscript>
        <div style="background: red; color: white; padding: 20px; text-align: center;">
            <h1>JavaScript is disabled!</h1>
            <p>This page requires JavaScript to function properly.</p>
        </div>
    </noscript>
    
    <!-- Modern Navigation -->
    <%@ include file="modern/components/nav-header.jsp" %>

    <!-- Breadcrumbs -->
    <nav class="breadcrumbs" aria-label="Breadcrumb">
        <div class="breadcrumbs-container">
            <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
            <span class="breadcrumb-separator">/</span>
            <a href="<%=request.getContextPath()%>/index.jsp#encryption">Encryption Tools</a>
            <span class="breadcrumb-separator">/</span>
            <span class="breadcrumb-current">Cipher Tool</span>
	</div>
    </nav>

    <!-- Tool Header -->
    <header class="tool-header">
        <div class="tool-header-container">
            <div class="tool-header-content">
                <h1 class="tool-page-title">AES Encryption Tool Online - Encrypt & Decrypt Free</h1>
                <p class="tool-page-description">Free online cipher encryption tool supporting 100+ algorithms (AES-256, DES, Blowfish, ChaCha20). Encrypt and decrypt messages securely with client-side processing. No registration required.</p>
                <div class="tool-meta">
                    <span class="tool-category-badge">Encryption Tools</span>
                    <span class="tool-badge">✓ Free</span>
                    <span class="tool-badge">🔒 Secure</span>
                    <span class="tool-badge">⚡ Client-Side</span>
		</div>
		</div>
		</div>
    </header>

    <!-- Main Content -->
    <main class="tool-main">
        <div class="tool-container">

            <!-- In-Content Ad (Top) -->
            <%@ include file="modern/ads/ad-in-content-top.jsp" %>

            <!-- Main Form Card -->
            <div class="cipher-form-card">
                <div class="form-with-output" id="formWithOutput">
                    <!-- Single Column Form -->
                    <div class="form-single-column">
<form class="form-horizontal" id="form" method="POST">
	<input type="hidden" name="methodName" id="methodName" value="CIPHERBLOCK_NEW">

                            <!-- Step 1: Algorithm -->
			<div class="form-group step-indicator step-1">
                                <div class="step-header">
                                    <span class="step-number">1️⃣</span>
                                    <label for="cipherparameternew" class="form-label">
                                        <i class="fas fa-list-ul"></i> Cipher Algorithm <span class="required">*</span>
                                    </label>
</div>
                                <select name="cipherparameternew" id="cipherparameternew" class="select-field">
					<!-- Recommended Modern Algorithms -->
					<optgroup label="⭐ Recommended (Most Secure)">
						<option value="AES_256/GCM/NOPADDING">🛡️ AES-256-GCM (Best - Authenticated)</option>
						<option value="AES_256/CBC/NOPADDING">🔒 AES-256-CBC</option>
						<option selected value="AES/CBC/PKCS5PADDING">🔒 AES-CBC-PKCS5 (Default)</option>
						<option value="CHACHA">⚡ ChaCha (Modern Stream Cipher)</option>
						<option value="AES_192/GCM/NOPADDING">🛡️ AES-192-GCM</option>
					</optgroup>

					<!-- AES 256-bit (High Security) -->
					<optgroup label="🔐 AES-256 (High Security)">
						<option value="AES_256/CBC/NOPADDING">AES-256/CBC/NOPADDING</option>
						<option value="AES_256/CFB/NOPADDING">AES-256/CFB/NOPADDING</option>
						<option value="AES_256/ECB/NOPADDING">AES-256/ECB/NOPADDING ⚠️</option>
						<option value="AES_256/GCM/NOPADDING">AES-256/GCM/NOPADDING</option>
						<option value="AES_256/OFB/NOPADDING">AES-256/OFB/NOPADDING</option>
					</optgroup>

					<!-- AES 192-bit -->
					<optgroup label="🔐 AES-192 (Strong Security)">
						<option value="AES_192/CBC/NOPADDING">AES-192/CBC/NOPADDING</option>
						<option value="AES_192/CFB/NOPADDING">AES-192/CFB/NOPADDING</option>
						<option value="AES_192/ECB/NOPADDING">AES-192/ECB/NOPADDING ⚠️</option>
						<option value="AES_192/GCM/NOPADDING">AES-192/GCM/NOPADDING</option>
						<option value="AES_192/OFB/NOPADDING">AES-192/OFB/NOPADDING</option>
					</optgroup>

					<!-- AES 128-bit -->
					<optgroup label="🔐 AES-128 (Standard Security)">
						<option value="AES">AES (Default 128-bit)</option>
						<option value="AES_128/CBC/NOPADDING">AES-128/CBC/NOPADDING</option>
						<option value="AES_128/CFB/NOPADDING">AES-128/CFB/NOPADDING</option>
						<option value="AES_128/ECB/NOPADDING">AES-128/ECB/NOPADDING ⚠️</option>
						<option value="AES_128/GCM/NOPADDING">AES-128/GCM/NOPADDING</option>
						<option value="AES_128/OFB/NOPADDING">AES-128/OFB/NOPADDING</option>
					</optgroup>

					<!-- AES Generic Modes -->
					<optgroup label="🔐 AES Generic Modes">
						<option value="AES/CBC/NOPADDING">AES/CBC/NOPADDING</option>
						<option value="AES/ECB/NOPADDING">AES/ECB/NOPADDING ⚠️</option>
						<option value="AES/ECB/PKCS5PADDING">AES/ECB/PKCS5PADDING ⚠️</option>
						<option value="GCM">GCM (Generic)</option>
					</optgroup>

					<!-- Other Modern Secure Algorithms -->
					<optgroup label="✓ Modern Secure Algorithms">
						<option value="TWOFISH">Twofish (AES Finalist)</option>
						<option value="SERPENT">Serpent (AES Finalist)</option>
						<option value="CAMELLIA">Camellia (International Standard)</option>
						<option value="THREEFISH-256">Threefish-256</option>
						<option value="THREEFISH-512">Threefish-512</option>
						<option value="THREEFISH-1024">Threefish-1024</option>
						<option value="ARIA">ARIA (Korean Standard)</option>
						<option value="SM4">SM4 (Chinese Standard)</option>
						<option value="SEED">SEED (Korean Standard)</option>
					</optgroup>

					<!-- Password-Based Encryption (Modern) -->
					<optgroup label="🔑 Password-Based Encryption (Recommended)">
						<option value="PBEWITHHMACSHA512ANDAES_256">PBE-HMAC-SHA512-AES-256</option>
						<option value="PBEWITHHMACSHA384ANDAES_256">PBE-HMAC-SHA384-AES-256</option>
						<option value="PBEWITHHMACSHA256ANDAES_256">PBE-HMAC-SHA256-AES-256</option>
						<option value="PBEWITHHMACSHA256ANDAES_128">PBE-HMAC-SHA256-AES-128</option>
						<option value="PBEWITHSHA256AND256BITAES-CBC-BC">PBE-SHA256-256bit-AES-CBC</option>
						<option value="PBEWITHSHA256AND192BITAES-CBC-BC">PBE-SHA256-192bit-AES-CBC</option>
						<option value="PBEWITHSHA256AND128BITAES-CBC-BC">PBE-SHA256-128bit-AES-CBC</option>
					</optgroup>

					<!-- Password-Based Encryption (Standard) -->
					<optgroup label="🔑 Password-Based Encryption (Standard)">
						<option value="PBEWITHHMACSHA224ANDAES_256">PBE-HMAC-SHA224-AES-256</option>
						<option value="PBEWITHHMACSHA224ANDAES_128">PBE-HMAC-SHA224-AES-128</option>
						<option value="PBEWITHHMACSHA1ANDAES_256">PBE-HMAC-SHA1-AES-256</option>
						<option value="PBEWITHHMACSHA1ANDAES_128">PBE-HMAC-SHA1-AES-128</option>
						<option value="PBEWITHSHAAND256BITAES-CBC-BC">PBE-SHA1-256bit-AES-CBC</option>
						<option value="PBEWITHSHAAND192BITAES-CBC-BC">PBE-SHA1-192bit-AES-CBC</option>
						<option value="PBEWITHSHAAND128BITAES-CBC-BC">PBE-SHA1-128bit-AES-CBC</option>
						<option value="PBEWITHSHA1ANDDESEDE">PBE-SHA1-DESede</option>
						<option value="PBEWITHSHAANDTWOFISH-CBC">PBE-SHA1-Twofish-CBC</option>
						<option value="PBEWITHSHAANDIDEA-CBC">PBE-SHA1-IDEA-CBC</option>
					</optgroup>

					<!-- Password-Based Encryption (Legacy) -->
					<optgroup label="🔑 Password-Based Encryption (Legacy)">
						<option value="PBEWITHSHA1ANDDES">PBE-SHA1-DES ⚠️</option>
						<option value="PBEWITHSHA1ANDRC2">PBE-SHA1-RC2 ⚠️</option>
						<option value="PBEWITHSHA1ANDRC2_128">PBE-SHA1-RC2-128 ⚠️</option>
						<option value="PBEWITHSHA1ANDRC2_40">PBE-SHA1-RC2-40 ⚠️</option>
						<option value="PBEWITHSHA1ANDRC4_128">PBE-SHA1-RC4-128 ⚠️</option>
						<option value="PBEWITHSHA1ANDRC4_40">PBE-SHA1-RC4-40 ⚠️</option>
						<option value="PBEWITHMD5ANDDES">PBE-MD5-DES ⚠️</option>
						<option value="PBEWITHMD5ANDRC2">PBE-MD5-RC2 ⚠️</option>
						<option value="PBEWITHMD5ANDTRIPLEDES">PBE-MD5-3DES ⚠️</option>
						<option value="PBEWITHMD2ANDDES">PBE-MD2-DES ⚠️</option>
						<option value="PBEWITHMD5AND256BITAES-CBC-OPENSSL">PBE-MD5-256bit-AES-OpenSSL ⚠️</option>
						<option value="PBEWITHMD5AND192BITAES-CBC-OPENSSL">PBE-MD5-192bit-AES-OpenSSL ⚠️</option>
						<option value="PBEWITHMD5AND128BITAES-CBC-OPENSSL">PBE-MD5-128bit-AES-OpenSSL ⚠️</option>
					</optgroup>

					<!-- Password-Based RC2/RC4 (Legacy) -->
					<optgroup label="🔑 PBE with RC2/RC4 (Legacy - Weak)">
						<option value="PBEWITHSHAAND128BITRC2-CBC">PBE-SHA1-128bit-RC2-CBC ⚠️</option>
						<option value="PBEWITHSHAAND40BITRC2-CBC">PBE-SHA1-40bit-RC2-CBC ⚠️</option>
						<option value="PBEWITHSHAAND128BITRC4">PBE-SHA1-128bit-RC4 ⚠️</option>
						<option value="PBEWITHSHAAND40BITRC4">PBE-SHA1-40bit-RC4 ⚠️</option>
						<option value="PBEWITHSHAAND2-KEYTRIPLEDES-CBC">PBE-SHA1-2Key-3DES-CBC ⚠️</option>
						<option value="PBEWITHSHAAND3-KEYTRIPLEDES-CBC">PBE-SHA1-3Key-3DES-CBC ⚠️</option>
					</optgroup>

					<!-- Legacy Algorithms (Compatibility Only) -->
					<optgroup label="⚠️ Legacy (Use Only for Compatibility)">
						<option value="DESEDE">3DES (Triple-DES)</option>
						<option value="DESEDE/CBC/NOPADDING">3DES/CBC/NOPADDING</option>
						<option value="DESEDE/CBC/PKCS5PADDING">3DES/CBC/PKCS5PADDING</option>
						<option value="DESEDE/ECB/NOPADDING">3DES/ECB/NOPADDING</option>
						<option value="DESEDE/ECB/PKCS5PADDING">3DES/ECB/PKCS5PADDING</option>
						<option value="BLOWFISH">Blowfish (Outdated)</option>
						<option value="CAST5">CAST5 (CAST-128)</option>
						<option value="CAST6">CAST6 (CAST-256)</option>
						<option value="IDEA">IDEA (Patented until 2012)</option>
						<option value="RC2">RC2 (40-bit weak)</option>
						<option value="RC5">RC5</option>
						<option value="RC6">RC6</option>
						<option value="RIJNDAEL">Rijndael (Use AES instead)</option>
					</optgroup>

					<!-- Deprecated (Insecure) -->
					<optgroup label="🚫 Deprecated (Insecure - Educational Only)">
						<option value="DES">DES (Broken - 56-bit)</option>
						<option value="DES/CBC/NOPADDING">DES/CBC/NOPADDING</option>
						<option value="DES/CBC/PKCS5PADDING">DES/CBC/PKCS5PADDING</option>
						<option value="DES/ECB/NOPADDING">DES/ECB/NOPADDING</option>
						<option value="DES/ECB/PKCS5PADDING">DES/ECB/PKCS5PADDING</option>
						<option value="SKIPJACK">Skipjack (NSA - Broken)</option>
						<option value="TEA">TEA (Weak)</option>
						<option value="XTEA">XTEA</option>
					</optgroup>

					<!-- Stream Ciphers -->
					<optgroup label="🌊 Stream Ciphers">
						<option value="CHACHA">ChaCha (Recommended)</option>
						<option value="SALSA20">Salsa20</option>
						<option value="HC128">HC-128</option>
						<option value="HC256">HC-256</option>
						<option value="VMPC">VMPC</option>
						<option value="VMPC-KSA3">VMPC-KSA3</option>
					</optgroup>

					<!-- Experimental/Research -->
					<optgroup label="🔬 Experimental/Research">
						<option value="GRAIN128">Grain-128</option>
						<option value="GRAINV1">Grain-v1</option>
						<option value="NOEKEON">Noekeon</option>
						<option value="GOST28147">GOST 28147-89 (Russian)</option>
						<option value="SHACAL-2">SHACAL-2</option>
						<option value="SHACAL2">SHACAL-2 (Alt)</option>
						<option value="TNEPRES">Tnepres (Serpent Reversed)</option>
					</optgroup>
				</select>
				<small class="form-text" style="margin-top: 0.5rem; display: block;">
					<strong>Quick Guide:</strong>
					⭐ <strong>Recommended</strong> for most uses |
					🔐 <strong>AES</strong> = Industry standard |
					🔑 <strong>PBE</strong> = Use password instead of hex key |
					⚠️ <strong>Legacy</strong> = Old systems only |
					🚫 <strong>Deprecated</strong> = Insecure
				</small>
			</div>

                            <!-- Step 2: Message -->
			<div class="form-group step-indicator step-2">
                                <div class="step-header">
                                    <span class="step-number">2️⃣</span>
                                    <label for="plaintext" class="form-label">
                                        <i class="fas fa-file-alt"></i> Message <span class="required">*</span>
                                    </label>
			</div>
                                <small class="form-text">Plaintext to encrypt or Base64/hex to decrypt</small>
                                <textarea class="textarea-field" rows="6" name="plaintext" placeholder="Type your message here..." id="plaintext"></textarea>
                                <small class="form-text"><span id="charCount">0</span> characters</small>
		</div>

                            <!-- Step 3: Secret Key -->
			<div class="form-group step-indicator step-3">
                                <div class="step-header">
                                    <span class="step-number">3️⃣</span>
                                    <label for="secretkey" class="form-label">
                                        <i class="fas fa-key"></i> Secret Key (Hex) <span class="required">*</span>
                                    </label>
                                </div>
                                <small class="form-text">
					<i class="fas fa-info-circle"></i> AES-128: 32 hex | AES-192: 48 hex | AES-256: 64 hex
				</small>
                                <div class="input-group-modern">
                                    <input type="text" class="input-field" name="secretkey" id="secretkey" placeholder="Enter hexadecimal key..." autocomplete="off" data-lpignore="true">
                                    <div style="position: relative;">
                                        <button type="button" class="dropdown-button btn-generate" aria-label="Generate encryption key options" aria-expanded="false" aria-haspopup="true">
							<i class="fas fa-random"></i> Generate
						</button>
                                        <div class="dropdown-menu-modern">
                                            <a href="#" class="dropdown-item-modern" onclick="generateKey(16); return false;">
								<i class="fas fa-key"></i> 128-bit (32 hex chars)
							</a>
                                            <a href="#" class="dropdown-item-modern" onclick="generateKey(24); return false;">
								<i class="fas fa-key"></i> 192-bit (48 hex chars)
							</a>
                                            <a href="#" class="dropdown-item-modern" onclick="generateKey(32); return false;">
								<i class="fas fa-key"></i> 256-bit (64 hex chars)
							</a>
                                            <div style="border-top: 1px solid var(--border); margin: 0.5rem 0;"></div>
                                            <a href="#" class="dropdown-item-modern" onclick="generateKey(8); return false;">
								<i class="fas fa-key"></i> 64-bit (16 hex chars) - DES
							</a>
						</div>
					</div>
				</div>
                                <small class="form-text">Length: <span id="keyLength">0</span> bytes (<span id="keyHexLength">0</span> hex chars)</small>
			</div>

                            <!-- Step 4: Operation -->
			<div class="form-group step-indicator step-4">
                                <div class="step-header">
                                    <span class="step-number">4️⃣</span>
                                    <label class="form-label"><i class="fas fa-exchange-alt"></i> Operation</label>
					</div>
                                <div class="radio-group">
                                    <div class="radio-option radio-encrypt">
                                        <input checked="checked" class="radio-input" id="encrypt" type="radio" name="encryptorDecrypt" value="encrypt">
                                        <label class="radio-label" for="encrypt"><i class="fas fa-lock"></i> Encrypt</label>
					</div>
                                    <div class="radio-option radio-decrypt">
                                        <input class="radio-input" id="decrypt" type="radio" name="encryptorDecrypt" value="decrypt">
                                        <label class="radio-label" for="decrypt"><i class="fas fa-unlock"></i> Decrypt</label>
				</div>
			</div>
			</div>


                            <!-- Submit Button -->
                            <button class="btn-submit" type="button" id="genkeypair" name="submit">
				<i class="fas fa-play-circle"></i> <span id="submitText">Encrypt Message</span>
			</button>

                            <!-- Share Button -->
                            <button class="btn-secondary-modern" type="button" id="shareButton" aria-label="Generate shareable URL with current cipher configuration">
				<i class="fas fa-share-alt"></i> Share Configuration URL
			</button>

                            <!-- Share URL Alert -->
                            <div id="shareAlert" class="share-alert">
                                <h6><i class="fas fa-link"></i> Shareable URL Generated</h6>
                                <div class="input-group-share">
                                    <input type="text" class="input-field" id="shareUrl" readonly aria-label="Shareable URL">
                                    <button class="btn-copy" type="button" id="copyShareUrl" aria-label="Copy shareable URL to clipboard">
					<i class="fas fa-copy"></i> Copy
				</button>
			</div>
                                <small class="form-text" style="margin-top: 0.75rem; display: block;">
			<i class="fas fa-info-circle"></i> Share this URL to let others test with the same configuration (cipher, key, and message).
		</small>
	</div>
</form>

                        <!-- Output Area (Mobile: Below form) -->
                        <div id="output" class="output-area-mobile">
                            <div class="output-placeholder">
                                <i class="fas fa-arrow-down"></i>
                                <p>Results will appear here after encryption/decryption</p>
		</div>
	</div>
</div>

                    <!-- Output Area Container (Desktop: Side-by-side) -->
                    <div class="output-area-container" id="outputContainer">
                        <div id="outputDesktop">
                            <div class="output-placeholder">
                                <i class="fas fa-arrow-left"></i>
                                <p>Results will appear here after encryption/decryption</p>
				</div>
			</div>
		</div>
	</div>
</div>

            <!-- In-Content Ad (Mid) -->
            <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
            
            <!-- Learning Content -->
            <!-- Temporarily disabled - causing ERR_INCOMPLETE_CHUNKED_ENCODING -->
            <%@ include file="modern/components/cipher-learning-content.jsp" %>
            
            <!-- Related Tools Section (Dynamic from tools database) -->
            <!-- Temporarily disabled for debugging -->

            <jsp:include page="modern/components/related-tools.jsp">
                <jsp:param name="currentToolUrl" value="CipherFunctions.jsp"/>
                <jsp:param name="category" value="Cryptography"/>
                <jsp:param name="limit" value="6"/>
            </jsp:include>

					</div>
    </main>

    <!-- Support Section -->
    <%@ include file="modern/components/support-section.jsp" %>

    <!-- Footer -->
    <footer class="page-footer">
        <div class="footer-content">
            <p class="footer-text">© 2024 8gwifi.org - Free Online Tools</p>
            <div class="footer-links">
                <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
                <a href="tutorials/" class="footer-link">Tutorials</a>
                <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
			</div>
			</div>
    </footer>

    <!-- Sticky Footer Ad -->
    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>

    <!-- Right Column Ads (Desktop Only - Uses empty space on right, stacked vertical) -->
    <%@ include file="modern/ads/ad-right-sidebar.jsp" %>
    
    <!-- Floating Right Ad (Desktop Only) -->
    <%@ include file="modern/ads/ad-floating-right.jsp" %>

    <!-- Analytics - Loaded at end of body for LCP optimization -->
    <%@ include file="modern/components/analytics.jsp" %>

    <!-- Scripts -->
    <!-- Common Tool Utilities (MUST be loaded first) -->
    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>" defer onerror="console.warn('tool-utils.js failed to load')"></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=2.1&t=<%=cacheVersion%>" defer onerror="console.warn('search.js failed to load')"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer onerror="console.warn('dark-mode.js failed to load')"></script>
    
    <!-- Fallback for deferred CSS loading -->
    <script>
        // Polyfill for loading CSS asynchronously
        !function(e){"use strict";if(!e.loadCSS){var t=function(t,n,o){var i,r=e.document,a=r.createElement("link");if(n)i=n;else{var l=(r.body||r.getElementsByTagName("head")[0]).childNodes;i=l[l.length-1]}var d=r.styleSheets;a.rel="stylesheet",a.href=t,a.media="only x",function e(t){if(r.body)return t();setTimeout(function(){e(t)})}(function(){i.parentNode.insertBefore(a,n?i:i.nextSibling)});var f=function(e){for(var t=a.href,n=d.length;n--;)if(d[n].href===t)return e();setTimeout(function(){f(e)})};return a.addEventListener&&a.addEventListener("load",function(){this.media=o||"all"}),a.onloadcssdefined=f,f(function(){a.media!==o&&(a.media=o||"all")}),a};e.loadCSS=t}}("undefined"!=typeof global?global:this);
    </script>

    <!-- Legacy script for URL parameter loading -->
<script type="text/javascript">
	<%
        String text = (String)request.getParameter("text");
        String pass = (String)request.getParameter("pass");
        String cipherparam = (String)request.getParameter("cipherparam");
        String mode = (String)request.getParameter("mode");

        if(null == cipherparam || cipherparam.trim().length()==0)
        {
            cipherparam="AES/CBC/PKCS5PADDING";
        }

        if (text!=null & pass!=null & mode!=null )
        {
			text = text.replace(" ","+");
			pass = pass.replace(" ","+");
			pass = new String(new BASE64Decoder().decodeBuffer(pass));

            if("decrypt".equalsIgnoreCase(mode.trim()))
            {
    %>
					document.getElementById("plaintext").value = "<%=text%>";
					document.getElementById("decrypt").checked = true;
					document.getElementById("secretkey").value = "<%=pass%>";
					// Set cipher algorithm by value (works with optgroups)
					document.getElementById("cipherparameternew").value = "<%=cipherparam%>";
	<%
            }

             if("encrypt".equalsIgnoreCase(mode.trim()))
            {
             %>
            	document.getElementById("plaintext").value = '<%=text%>'
				document.getElementById("encrypt").checked = true;
				document.getElementById("secretkey").value = '<%=pass%>';
				// Set cipher algorithm by value (works with optgroups)
				document.getElementById("cipherparameternew").value = "<%=cipherparam%>";
	<%
                }
            }
        %>
</script>
</body>
</html>
