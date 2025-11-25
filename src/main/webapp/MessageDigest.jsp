<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div>
<head>

    <!-- JSON-LD markup with EEAT signals -->
    <script type="application/ld+json">
{
  "@context" : "https://schema.org",
  "@type" : "WebApplication",
  "name" : "Message Digest Calculator - Online Hash Generator",
  "alternateName" : "Hash Calculator, Message Digest Generator, Hash Function Tool",
  "description" : "Free online message digest calculator supporting 50+ hash algorithms including MD5, SHA-1, SHA-256, SHA-512, SHA-3, RIPEMD, BLAKE2b, Keccak, GOST, and more. Generate and verify message digests instantly.",
  "image" : "https://8gwifi.org/images/site/hash.png",
  "url" : "https://8gwifi.org/MessageDigest.jsp",
  "applicationCategory" : "SecurityApplication",
  "applicationSubCategory" : "Cryptography Tool",
  "browserRequirements" : "Requires JavaScript. Works with Chrome 90+, Firefox 88+, Safari 14+, Edge 90+",
  "operatingSystem" : "Any (Web-based)",
  "softwareVersion" : "2.0",
  "datePublished" : "2017-09-25",
  "dateModified" : "2025-01-23",
  "author" : {
    "@type" : "Person",
    "name" : "Anish Nath",
    "url" : "https://8gwifi.org",
    "sameAs" : "https://x.com/anish2good",
    "jobTitle" : "Security Engineer & Cryptography Expert",
    "description" : "Experienced security professional specializing in cryptographic implementations and network security tools"
  },
  "publisher" : {
    "@type" : "Organization",
    "name" : "8gwifi.org",
    "url" : "https://8gwifi.org",
    "logo" : {
      "@type" : "ImageObject",
      "url" : "https://8gwifi.org/images/site/logo.png"
    },
    "description" : "Provider of professional online cryptography and network security tools"
  },
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD",
    "availability": "https://schema.org/InStock",
    "description": "Free online message digest calculator with no registration required"
  },
  "featureList" : [
    "50+ hash algorithms supported",
    "MD5, SHA-1, SHA-224, SHA-256, SHA-384, SHA-512",
    "SHA-3 (Keccak) variants",
    "RIPEMD (128, 160, 256, 320)",
    "BLAKE2b variants",
    "GOST hash functions",
    "SKEIN hash family",
    "TIGER and Whirlpool",
    "Multiple algorithm selection",
    "Hex and Base64 output formats",
    "One-click copy to clipboard",
    "No registration required",
    "Privacy-first approach"
  ],
  "keywords" : "message digest calculator, hash calculator, md5 generator, sha256 calculator, sha512 generator, hash function online, message digest online, hash algorithm calculator, sha1 calculator, sha3 calculator, ripemd calculator, blake2b calculator, keccak calculator, gost hash, hash generator, digest calculator",
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.7",
    "ratingCount": "1245",
    "bestRating": "5",
    "worstRating": "1"
  },
  "review": {
    "@type": "Review",
    "reviewRating": {
      "@type": "Rating",
      "ratingValue": "5",
      "bestRating": "5"
    },
    "author": {
      "@type": "Person",
      "name": "Developer Community"
    },
    "reviewBody": "Comprehensive hash calculator supporting all major algorithms. Essential tool for developers and security professionals."
  },
  "potentialAction": {
    "@type": "UseAction",
    "target": {
      "@type": "EntryPoint",
      "urlTemplate": "https://8gwifi.org/MessageDigest.jsp",
      "actionPlatform": [
        "http://schema.org/DesktopWebPlatform",
        "http://schema.org/MobileWebPlatform"
      ]
    },
    "name": "Calculate Message Digest Online"
  },
  "audience": {
    "@type": "ProfessionalAudience",
    "audienceType": "Developers, System Administrators, DevOps Engineers, Security Professionals"
  },
  "isAccessibleForFree": true,
  "inLanguage": "en-US"
}
</script>

    <title>Message Digest Calculator Online – Free | 8gwifi.org</title>
    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
    <meta name="description" content="Free online message digest calculator supporting 50+ hash algorithms: MD5, SHA-1, SHA-256, SHA-512, SHA-3, RIPEMD, BLAKE2b, Keccak, GOST, and more. Generate hex and Base64 hashes instantly.">
    <meta name="keywords" content="message digest calculator, hash calculator, md5 generator, sha256 calculator, sha512 generator, hash function online, message digest online, hash algorithm calculator, sha1 calculator, sha3 calculator, ripemd calculator, blake2b calculator">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="robots" content="index,follow">
    <meta name="author" content="Anish Nath">
    
    <!-- Open Graph / Facebook -->
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/MessageDigest.jsp">
    <meta property="og:title" content="Message Digest Calculator - Online Hash Generator | 8gwifi.org">
    <meta property="og:description" content="Free online message digest calculator supporting 50+ hash algorithms: MD5, SHA-1, SHA-256, SHA-512, SHA-3, RIPEMD, BLAKE2b, Keccak, GOST, and more.">
    <meta property="og:image" content="https://8gwifi.org/images/site/hash.png">
    
    <!-- Twitter -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:url" content="https://8gwifi.org/MessageDigest.jsp">
    <meta name="twitter:title" content="Message Digest Calculator - Online Hash Generator | 8gwifi.org">
    <meta name="twitter:description" content="Free online message digest calculator supporting 50+ hash algorithms: MD5, SHA-1, SHA-256, SHA-512, SHA-3, RIPEMD, BLAKE2b, Keccak, GOST, and more.">
    <meta name="twitter:image" content="https://8gwifi.org/images/site/hash.png">
    
    <!-- Canonical URL -->
    <link rel="canonical" href="https://8gwifi.org/MessageDigest.jsp">
    
    <%@ include file="header-script.jsp"%>

    <%
        String[] validList = { "md2","md4","ripemd128","sha","sha-1","sha-224","sha-256","sha-384","sha-512","sha-512/224","sha-512/256","sha3-224","sha3-256","sha3-384","sha3-512","ripemd160","ripemd256","ripemd320","sm3","skein-1024-1024","skein-1024-384","skein-1024-512","skein-256-128","skein-256-160","skein-256-224","skein-256-256","skein-512-128","skein-512-160","skein-512-224","skein-512-256","skein-512-384","skein-512-512","tiger","whirlpool","blake2b-160","blake2b-256","blake2b-384","blake2b-512","dstu7564-256","dstu7564-384","dstu7564-512","gost3411","gost3411-2012-256","gost3411-2012-512","keccak-224","keccak-256","keccak-288","keccak-384","keccak-512",
                "1.2.804.2.1.1.1.1.2.2.1","1.2.804.2.1.1.1.1.2.2.2","1.2.804.2.1.1.1.1.2.2.3","2.16.840.1.101.3.4.2.10","2.16.840.1.101.3.4.2.7","2.16.840.1.101.3.4.2.8","2.16.840.1.101.3.4.2.9","oid.1.2.804.2.1.1.1.1.2.2.1","oid.1.2.804.2.1.1.1.1.2.2.2","oid.1.2.804.2.1.1.1.1.2.2.3","oid.2.16.840.1.101.3.4.2.10","oid.2.16.840.1.101.3.4.2.7","oid.2.16.840.1.101.3.4.2.8","oid.2.16.840.1.101.3.4.2.9"};
    %>

    <style>
        .algorithm-category {
            margin-bottom: 15px;
        }
        .algorithm-category h6 {
            color: #495057;
            font-weight: 600;
            margin-bottom: 8px;
            padding-bottom: 5px;
            border-bottom: 1px solid #dee2e6;
        }
        .algorithm-option {
            padding: 5px 10px;
            margin: 2px 0;
            cursor: pointer;
            border-radius: 4px;
            transition: background-color 0.2s;
        }
        .algorithm-option:hover {
            background-color: #f8f9fa;
        }
        .hash-result-card {
            margin-bottom: 15px;
            border-left: 4px solid #007bff;
        }
        .hash-value {
            font-family: 'Courier New', monospace;
            font-size: 0.9em;
            word-break: break-all;
        }
        .copy-btn {
            margin-left: 10px;
        }
        .loading-spinner {
            display: none;
            text-align: center;
            padding: 20px;
        }
        .loading-spinner.active {
            display: block;
        }
        .security-strength {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-weight: 600;
            font-size: 0.85em;
        }
        .strength-weak {
            background-color: #ffc107;
            color: #000;
        }
        .strength-medium {
            background-color: #ff9800;
            color: #fff;
        }
        .strength-strong {
            background-color: #4caf50;
            color: #fff;
        }
        .strength-very-strong {
            background-color: #2196f3;
            color: #fff;
        }
        .strength-excellent {
            background-color: #9c27b0;
            color: #fff;
        }
        .hash-algorithm-row {
            transition: background-color 0.2s;
        }
        .hash-algorithm-row:hover {
            background-color: #f8f9fa;
        }
        .algorithm-badge {
            display: inline-block;
            padding: 2px 6px;
            border-radius: 3px;
            font-size: 0.75em;
            font-weight: 600;
            margin-left: 5px;
        }
        .badge-md {
            background-color: #6c757d;
            color: #fff;
        }
        .badge-sha {
            background-color: #007bff;
            color: #fff;
        }
        .badge-sha3 {
            background-color: #28a745;
            color: #fff;
        }
        .search-box {
            margin-bottom: 15px;
        }
        .security-property-row {
            transition: background-color 0.2s;
        }
        .security-property-row:hover {
            background-color: #f8f9fa;
        }
        .algorithm-header {
            font-weight: 600;
            color: #495057;
        }
        .tooltip-icon {
            cursor: help;
            color: #6c757d;
            margin-left: 5px;
        }
    </style>

    <script type="text/javascript">
        // Global function for copy to clipboard
        function copyToClipboard(text, buttonElement) {
            if (navigator.clipboard && navigator.clipboard.writeText) {
                navigator.clipboard.writeText(text).then(function() {
                    var originalHtml = $(buttonElement).html();
                    $(buttonElement).html('<i class="fas fa-check"></i> Copied!');
                    $(buttonElement).removeClass('btn-outline-secondary').addClass('btn-success');
                    setTimeout(function() {
                        $(buttonElement).html(originalHtml);
                        $(buttonElement).removeClass('btn-success').addClass('btn-outline-secondary');
                    }, 2000);
                }).catch(function(err) {
                    fallbackCopy(text, buttonElement);
                });
            } else {
                fallbackCopy(text, buttonElement);
            }
        }

        function fallbackCopy(text, buttonElement) {
            var textarea = document.createElement('textarea');
            textarea.value = text;
            textarea.style.position = 'fixed';
            textarea.style.opacity = '0';
            document.body.appendChild(textarea);
            textarea.select();
            try {
                document.execCommand('copy');
                var originalHtml = $(buttonElement).html();
                $(buttonElement).html('<i class="fas fa-check"></i> Copied!');
                $(buttonElement).removeClass('btn-outline-secondary').addClass('btn-success');
                setTimeout(function() {
                    $(buttonElement).html(originalHtml);
                    $(buttonElement).removeClass('btn-success').addClass('btn-outline-secondary');
                }, 2000);
            } catch (err) {
                alert('Failed to copy: ' + err);
            }
            document.body.removeChild(textarea);
        }

        function copyAllResults() {
            var results = [];
            $('.hash-result-card').each(function() {
                var algo = $(this).find('.algorithm-name').text();
                var hex = $(this).find('.hex-value').text();
                var base64 = $(this).find('.base64-value').text();
                results.push(algo + ':');
                results.push('  Hex: ' + hex);
                results.push('  Base64: ' + base64);
                results.push('');
            });
            var allText = results.join('\n') + '\n---\nGenerated using: https://8gwifi.org/MessageDigest.jsp';
            copyToClipboard(allText, $('#copyAllBtn')[0]);
        }

        function generateShareUrl() {
            var inputText = $('#inputtext').val();
            var selectedAlgorithms = [];
            $('#cipherparameternew option:selected').each(function() {
                selectedAlgorithms.push($(this).val());
            });
            
            if (!inputText || inputText.trim().length === 0) {
                alert('Please enter a message first');
                return;
            }
            
            if (selectedAlgorithms.length === 0) {
                alert('Please select at least one algorithm');
                return;
            }
            
            var params = new URLSearchParams();
            params.append('msg', inputText);
            params.append('algos', selectedAlgorithms.join(','));
            
            var shareUrl = window.location.origin + window.location.pathname + '?' + params.toString();
            
            $('#shareUrlInput').val(shareUrl);
            $('#shareUrlModal').modal('show');
        }

        function copyShareUrl() {
            var shareUrl = $('#shareUrlInput').val();
            if (shareUrl) {
                copyToClipboard(shareUrl, $('#copyShareUrl')[0]);
            }
        }

        $(document).ready(function() {
            // Handle URL parameters
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.has('msg')) {
                var msg = urlParams.get('msg');
                $('#inputtext').val(msg);
                $('#inputtext').addClass('border-warning');
                setTimeout(function() {
                    $('#inputtext').removeClass('border-warning');
                }, 3000);
            }
            
            if (urlParams.has('algos')) {
                var algos = urlParams.get('algos').split(',');
                $('#cipherparameternew option').each(function() {
                    if (algos.indexOf($(this).val()) !== -1) {
                        $(this).prop('selected', true);
                    }
                });
                // Trigger form submission after a short delay
                setTimeout(function() {
                    $('#form').submit();
                }, 500);
            }

            $('#cipherparameternew').change(function(event) {
                $('#form').delay(200).submit();
            });

            $('#inputtext').keyup(function (event) {
                $('#form').delay(200).submit();
            });

            $('#form').submit(function (event) {
                event.preventDefault();
                
                var inputText = $('#inputtext').val();
                if (!inputText || inputText.trim().length === 0) {
                    $('#output').html('<div class="alert alert-warning"><i class="fas fa-exclamation-triangle"></i> Please enter a message to hash</div>');
                    return;
                }
                
                var selectedAlgorithms = $('#cipherparameternew option:selected').length;
                if (selectedAlgorithms === 0) {
                    $('#output').html('<div class="alert alert-warning"><i class="fas fa-exclamation-triangle"></i> Please select at least one hash algorithm</div>');
                    return;
                }
                
                $('.loading-spinner').addClass('active');
                $('#output').html('');
                
                $.ajax({
                    type: "POST",
                    url: "MDFunctionality",
                    data: $("#form").serialize(),
                    dataType: "json",
                    success: function(response) {
                        $('.loading-spinner').removeClass('active');
                        $('#output').empty();
                        
                        if (response.success && response.results && response.results.length > 0) {
                            var html = '<div class="card mb-3"><div class="card-header bg-primary text-white"><h5 class="mb-0"><i class="fas fa-hashtag"></i> Hash Results for: <code>' + escapeHtml(response.inputText) + '</code></h5></div><div class="card-body">';
                            
                            response.results.forEach(function(result) {
                                html += '<div class="card hash-result-card mb-3">';
                                html += '<div class="card-body">';
                                html += '<h6 class="algorithm-name mb-3"><i class="fas fa-key"></i> ' + escapeHtml(result.algorithm) + '</h6>';
                                
                                html += '<div class="form-group mb-3">';
                                html += '<label class="font-weight-bold">Hex Encoded:</label>';
                                html += '<div class="input-group">';
                                html += '<textarea class="form-control hash-value hex-value" rows="2" readonly>' + escapeHtml(result.hexEncoded) + '</textarea>';
                                html += '<div class="input-group-append">';
                                html += '<button class="btn btn-outline-secondary copy-btn" type="button" data-copy-text="' + escapeHtml(result.hexEncoded).replace(/'/g, "&#39;") + '"><i class="fas fa-copy"></i> Copy</button>';
                                html += '</div></div></div>';
                                
                                html += '<div class="form-group mb-0">';
                                html += '<label class="font-weight-bold">Base64 Encoded:</label>';
                                html += '<div class="input-group">';
                                html += '<textarea class="form-control hash-value base64-value" rows="2" readonly>' + escapeHtml(result.base64Encoded) + '</textarea>';
                                html += '<div class="input-group-append">';
                                html += '<button class="btn btn-outline-secondary copy-btn" type="button" data-copy-text="' + escapeHtml(result.base64Encoded).replace(/'/g, "&#39;") + '"><i class="fas fa-copy"></i> Copy</button>';
                                html += '</div></div></div>';
                                
                                html += '</div></div>';
                            });
                            
                            html += '<div class="mt-3">';
                            html += '<button class="btn btn-primary mr-2" id="copyAllBtn" onclick="copyAllResults()"><i class="fas fa-copy"></i> Copy All Results</button>';
                            html += '<button class="btn btn-info" onclick="generateShareUrl()"><i class="fas fa-share-alt"></i> Share URL</button>';
                            html += '</div>';
                            
                            html += '</div></div>';
                            $('#output').html(html);
                            
                            // Attach click handlers for copy buttons
                            $('.copy-btn[data-copy-text]').click(function() {
                                var textToCopy = $(this).attr('data-copy-text');
                                copyToClipboard(textToCopy, this);
                            });
                        } else {
                            var errorMsg = response.errorMessage || 'No results generated. Please check your input and selected algorithms.';
                            $('#output').html('<div class="alert alert-danger"><i class="fas fa-exclamation-triangle"></i> <strong>Error:</strong> ' + escapeHtml(errorMsg) + '</div>');
                        }
                    },
                    error: function(xhr, status, error) {
                        $('.loading-spinner').removeClass('active');
                        $('#output').html('<div class="alert alert-danger"><i class="fas fa-exclamation-triangle"></i> <strong>Error:</strong> Failed to calculate message digest. Please try again.</div>');
                        console.error('AJAX Error:', error);
                    }
                });
            });
        });

        function escapeHtml(text) {
            var map = {
                '&': '&amp;',
                '<': '&lt;',
                '>': '&gt;',
                '"': '&quot;',
                "'": '&#039;'
            };
            return text ? text.replace(/[&<>"']/g, function(m) { return map[m]; }) : '';
        }

        // Initialize tooltips
        $(document).ready(function() {
            $('[data-toggle="tooltip"]').tooltip();
            
            // Hash functions search functionality
            $('#hashSearchInput').on('keyup', function() {
                var searchTerm = $(this).val().toLowerCase();
                var hasResults = false;
                
                if (searchTerm.length === 0) {
                    $('#clearSearchBtn').hide();
                    $('.hash-algorithm-row').show();
                    return;
                }
                
                $('#clearSearchBtn').show();
                
                $('.hash-algorithm-row').each(function() {
                    var name = $(this).data('name') ? $(this).data('name').toLowerCase() : '';
                    var category = $(this).data('category') ? $(this).data('category').toLowerCase() : '';
                    var text = $(this).text().toLowerCase();
                    
                    if (name.indexOf(searchTerm) !== -1 || category.indexOf(searchTerm) !== -1 || text.indexOf(searchTerm) !== -1) {
                        $(this).show();
                        hasResults = true;
                    } else {
                        $(this).hide();
                    }
                });
                
                // Show message if no results
                if (!hasResults) {
                    if ($('#noResultsMessage').length === 0) {
                        $('#hashFunctionsTable tbody').append('<tr id="noResultsMessage"><td colspan="3" class="text-center text-muted py-4"><i class="fas fa-search"></i> No hash functions found matching "' + escapeHtml(searchTerm) + '"</td></tr>');
                    }
                } else {
                    $('#noResultsMessage').remove();
                }
            });
            
            $('#clearSearchBtn').on('click', function() {
                $('#hashSearchInput').val('');
                $('#hashSearchInput').trigger('keyup');
            });
        });
    </script>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="pgp-menu-nav.jsp"%>
<div class="container mt-4">
    <!-- EEAT Header -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card bg-light">
                <div class="card-body">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <h1 class="h3 mb-2"><i class="fas fa-hashtag text-primary"></i> Message Digest Calculator</h1>
                            <p class="text-muted mb-0">Generate message digests using 50+ hash algorithms including MD5, SHA-1, SHA-256, SHA-512, SHA-3, RIPEMD, BLAKE2b, and more.</p>
                        </div>
                        <div class="col-md-4 text-right">
                            <small class="text-muted d-block"><i class="fas fa-user"></i> Author: <strong>Anish Nath</strong></small>
                            <small class="text-muted d-block"><i class="fas fa-calendar"></i> Last Updated: <strong>January 2025</strong></small>
                            <small class="text-muted d-block"><i class="fas fa-shield-alt"></i> <strong>Privacy-First</strong> - No data stored</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <form id="form" method="POST">
        <input type="hidden" name="methodName" id="methodName" value="CALCULATE_MD">
        
        <div class="row">
            <!-- Left Column: Input -->
            <div class="col-lg-6 col-md-12 mb-4">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-edit"></i> Input Message</h5>
                    </div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="inputtext"><strong>Enter Message to Hash</strong></label>
                            <textarea class="form-control" id="inputtext" name="text" rows="4" placeholder="Type or paste your message here to generate message digest..."></textarea>
                            <small class="form-text text-muted"><i class="fas fa-info-circle"></i> Enter any text to calculate its hash using selected algorithms</small>
                        </div>
                        
                        <div class="form-group">
                            <label for="cipherparameternew"><strong>Select Hash Algorithms</strong> <span class="badge badge-info">Multiple selection</span></label>
                            <select size="12" multiple name="cipherparameternew" id="cipherparameternew" class="form-control">
                                <option selected value="MD5">MD5</option>
                                <%
                                    for (int i = 0; i < validList.length; i++) {
                                        String param = validList[i];
                                %>
                                <option value="<%=param%>"><%=param%></option>
                                <%}%>
                            </select>
                            <small class="form-text text-muted"><i class="fas fa-info-circle"></i> Hold Ctrl/Cmd to select multiple algorithms. Results update automatically as you type.</small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Column: Output -->
            <div class="col-lg-6 col-md-12 mb-4">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0"><i class="fas fa-terminal"></i> Hash Results</h5>
                    </div>
                    <div class="card-body">
                        <div class="loading-spinner">
                            <div class="spinner-border text-primary" role="status">
                                <span class="sr-only">Loading...</span>
                            </div>
                            <p class="mt-2">Calculating message digest...</p>
                        </div>
                        <div id="output">
                            <div class="text-center text-muted py-5">
                                <i class="fas fa-hashtag fa-4x mb-3 opacity-25"></i>
                                <p class="lead">Hash results will appear here</p>
                                <p class="small">Enter your message and select algorithms to generate hashes</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <hr>

    <!-- Share URL Modal -->
    <div class="modal fade" id="shareUrlModal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-share-alt"></i> Share URL</h5>
                    <button type="button" class="close" data-dismiss="modal">
                        <span>&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p>Share this URL to allow others to generate the same hash results:</p>
                    <div class="input-group">
                        <input type="text" class="form-control" id="shareUrlInput" readonly>
                        <div class="input-group-append">
                            <button class="btn btn-primary" type="button" id="copyShareUrl" onclick="copyShareUrl()"><i class="fas fa-copy"></i> Copy</button>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <hr>
    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>
    
    <!-- Educational Content -->
    <div class="row mt-4">
        <div class="col-12">
            <div class="card shadow-sm">
                <div class="card-header text-white" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                    <h5 class="mb-0"><i class="fas fa-graduation-cap"></i> About Message Digests</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6 mb-4">
                            <div class="alert alert-warning border-left-warning" style="border-left: 4px solid #ffc107;">
                                <h6 class="alert-heading"><i class="fas fa-exclamation-triangle"></i> Important Distinction</h6>
                                <p class="mb-0"><strong>Hashing is NOT encryption.</strong> There is no secret, no key in hashing.</p>
                            </div>
                            
                            <div class="card border-primary mb-3">
                                <div class="card-body">
                                    <h6 class="card-title"><i class="fas fa-lightbulb text-primary"></i> What is a Hash Function?</h6>
                                    <p class="card-text mb-0">A hash function is a mathematical function that converts an input (message) of arbitrary length into a fixed-size output (hash value or digest).</p>
                                </div>
                            </div>
                            
                            <div class="card border-info">
                                <div class="card-body">
                                    <h6 class="card-title"><i class="fas fa-cogs text-info"></i> Key Characteristics</h6>
                                    <ul class="mb-0">
                                        <li><strong>Deterministic:</strong> Same input always produces same output</li>
                                        <li><strong>Fixed Output Size:</strong> Output length is constant regardless of input size</li>
                                        <li><strong>One-Way Function:</strong> Cannot reverse to get original input</li>
                                        <li><strong>Fast Computation:</strong> Efficient to calculate hash value</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-6 mb-4">
                            <div class="card border-success">
                                <div class="card-body">
                                    <h6 class="card-title"><i class="fas fa-shield-alt text-success"></i> Common Use Cases</h6>
                                    <ul class="mb-3">
                                        <li><i class="fas fa-check-circle text-success"></i> <strong>Data Integrity:</strong> Verify files haven't been modified</li>
                                        <li><i class="fas fa-check-circle text-success"></i> <strong>Password Storage:</strong> Store hashed passwords (with salt)</li>
                                        <li><i class="fas fa-check-circle text-success"></i> <strong>Digital Signatures:</strong> Sign documents and messages</li>
                                        <li><i class="fas fa-check-circle text-success"></i> <strong>Blockchain:</strong> Link blocks in cryptocurrency</li>
                                        <li><i class="fas fa-check-circle text-success"></i> <strong>Deduplication:</strong> Identify duplicate files</li>
                                    </ul>
                                </div>
                            </div>
                            
                            <div class="card border-danger mt-3">
                                <div class="card-body">
                                    <h6 class="card-title"><i class="fas fa-ban text-danger"></i> What Hashing is NOT</h6>
                                    <ul class="mb-0">
                                        <li><i class="fas fa-times-circle text-danger"></i> <strong>Not Encryption:</strong> Cannot decrypt to get original</li>
                                        <li><i class="fas fa-times-circle text-danger"></i> <strong>Not Compression:</strong> Output can be larger than input</li>
                                        <li><i class="fas fa-times-circle text-danger"></i> <strong>Not Reversible:</strong> One-way function only</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <hr class="my-4">
                    
                    <div class="row">
                        <div class="col-12">
                            <div class="card bg-light">
                                <div class="card-body">
                                    <h6 class="card-title"><i class="fas fa-book text-primary"></i> Technical Definition</h6>
                                    <p class="mb-0">
                                        <strong>Hashing</strong> is a function from some bit string (usually variable length) to another bit string 
                                        (usually smaller, and of fixed length). The output is called a <strong>hash value</strong>, 
                                        <strong>hash code</strong>, <strong>digest</strong>, or simply <strong>hash</strong>.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row mt-3">
                        <div class="col-md-4">
                            <div class="card text-center border-primary">
                                <div class="card-body">
                                    <i class="fas fa-arrow-down fa-2x text-primary mb-2"></i>
                                    <h6>Input</h6>
                                    <p class="text-muted mb-0 small">Variable length message</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card text-center border-info">
                                <div class="card-body">
                                    <i class="fas fa-cogs fa-2x text-info mb-2"></i>
                                    <h6>Hash Function</h6>
                                    <p class="text-muted mb-0 small">Mathematical transformation</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card text-center border-success">
                                <div class="card-body">
                                    <i class="fas fa-fingerprint fa-2x text-success mb-2"></i>
                                    <h6>Output</h6>
                                    <p class="text-muted mb-0 small">Fixed length hash value</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <hr class="my-4">
                    
                    <div class="row">
                        <div class="col-12">
                            <div class="card border-secondary">
                                <div class="card-header bg-secondary text-white">
                                    <h6 class="mb-0"><i class="fas fa-book"></i> References & Further Reading</h6>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <h6 class="text-primary"><i class="fas fa-file-alt"></i> Standards & Specifications</h6>
                                            <ul class="list-unstyled">
                                                <li><i class="fas fa-external-link-alt text-muted"></i> <a href="https://csrc.nist.gov/publications/detail/fips/180/4/final" target="_blank" rel="noopener">NIST FIPS 180-4: Secure Hash Standard (SHS)</a></li>
                                                <li><i class="fas fa-external-link-alt text-muted"></i> <a href="https://csrc.nist.gov/publications/detail/fips/202/final" target="_blank" rel="noopener">NIST FIPS 202: SHA-3 Standard</a></li>
                                                <li><i class="fas fa-external-link-alt text-muted"></i> <a href="https://www.rfc-editor.org/rfc/rfc6234" target="_blank" rel="noopener">RFC 6234: US Secure Hash Algorithms</a></li>
                                                <li><i class="fas fa-external-link-alt text-muted"></i> <a href="https://www.rfc-editor.org/rfc/rfc7693" target="_blank" rel="noopener">RFC 7693: The BLAKE2 Cryptographic Hash</a></li>
                                                <li><i class="fas fa-external-link-alt text-muted"></i> <a href="https://www.rfc-editor.org/rfc/rfc1319" target="_blank" rel="noopener">RFC 1319: The MD2 Message-Digest Algorithm</a></li>
                                                <li><i class="fas fa-external-link-alt text-muted"></i> <a href="https://www.rfc-editor.org/rfc/rfc1320" target="_blank" rel="noopener">RFC 1320: The MD4 Message-Digest Algorithm</a></li>
                                                <li><i class="fas fa-external-link-alt text-muted"></i> <a href="https://www.rfc-editor.org/rfc/rfc1321" target="_blank" rel="noopener">RFC 1321: The MD5 Message-Digest Algorithm</a></li>
                                            </ul>
                                        </div>
                                        <div class="col-md-6">
                                            <h6 class="text-success"><i class="fas fa-graduation-cap"></i> Educational Resources</h6>
                                            <ul class="list-unstyled">
                                                <li><i class="fas fa-external-link-alt text-muted"></i> <a href="https://en.wikipedia.org/wiki/Cryptographic_hash_function" target="_blank" rel="noopener">Wikipedia: Cryptographic Hash Function</a></li>
                                                <li><i class="fas fa-external-link-alt text-muted"></i> <a href="https://csrc.nist.gov/projects/hash-functions" target="_blank" rel="noopener">NIST Hash Functions Project</a></li>
                                                <li><i class="fas fa-external-link-alt text-muted"></i> <a href="https://www.schneier.com/blog/archives/2004/08/cryptanalysis_o.html" target="_blank" rel="noopener">Schneier on Security: Hash Functions</a></li>
                                                <li><i class="fas fa-external-link-alt text-muted"></i> <a href="https://keccak.team/" target="_blank" rel="noopener">Keccak Team - SHA-3 Official Site</a></li>
                                                <li><i class="fas fa-external-link-alt text-muted"></i> <a href="https://blake2.net/" target="_blank" rel="noopener">BLAKE2 Official Website</a></li>
                                            </ul>
                                            
                                            <h6 class="text-info mt-3"><i class="fas fa-shield-alt"></i> Security Advisories</h6>
                                            <ul class="list-unstyled">
                                                <li><i class="fas fa-external-link-alt text-muted"></i> <a href="https://csrc.nist.gov/Projects/Hash-Functions/NIST-Policy-on-Hash-Functions" target="_blank" rel="noopener">NIST Policy on Hash Functions</a></li>
                                                <li><i class="fas fa-external-link-alt text-muted"></i> <a href="https://www.schneier.com/blog/archives/2005/02/sha1_broken.html" target="_blank" rel="noopener">SHA-1 Collision Attack (2017)</a></li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <hr>

    <div class="row mt-4">
        <div class="col-12">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0"><i class="fas fa-shield-alt"></i> Strengths of the Security Properties of the Approved Hash Algorithms</h5>
                </div>
                <div class="card-body">
                    <p class="text-muted mb-3"><i class="fas fa-info-circle"></i> This table shows the cryptographic strength of different SHA algorithms. Higher bit values indicate stronger security.</p>
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover" id="securityPropertiesTable">
                            <thead class="thead-dark">
                                <tr>
                                    <th style="min-width: 250px;">Security Property <i class="fas fa-question-circle tooltip-icon" data-toggle="tooltip" title="Different types of cryptographic resistance properties"></i></th>
                                    <th class="text-center algorithm-header">SHA-1 <span class="badge badge-warning">Deprecated</span></th>
                                    <th class="text-center algorithm-header">SHA-224</th>
                                    <th class="text-center algorithm-header">SHA-256</th>
                                    <th class="text-center algorithm-header">SHA-384</th>
                                    <th class="text-center algorithm-header">SHA-512</th>
                                    <th class="text-center algorithm-header">SHA-512/224</th>
                                    <th class="text-center algorithm-header">SHA-512/256</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr class="security-property-row">
                                    <td><strong><i class="fas fa-lock"></i> Collision Resistance</strong> <i class="fas fa-question-circle tooltip-icon" data-toggle="tooltip" title="Resistance to finding two different inputs that produce the same hash"></i></td>
                                    <td class="text-center"><span class="security-strength strength-weak">&lt; 80 bits</span></td>
                                    <td class="text-center"><span class="security-strength strength-medium">112 bits</span></td>
                                    <td class="text-center"><span class="security-strength strength-strong">128 bits</span></td>
                                    <td class="text-center"><span class="security-strength strength-very-strong">192 bits</span></td>
                                    <td class="text-center"><span class="security-strength strength-excellent">256 bits</span></td>
                                    <td class="text-center"><span class="security-strength strength-medium">112 bits</span></td>
                                    <td class="text-center"><span class="security-strength strength-strong">128 bits</span></td>
                                </tr>
                                <tr class="security-property-row">
                                    <td><strong><i class="fas fa-key"></i> Preimage Resistance</strong> <i class="fas fa-question-circle tooltip-icon" data-toggle="tooltip" title="Resistance to finding an input that produces a given hash output"></i></td>
                                    <td class="text-center"><span class="security-strength strength-medium">160 bits</span></td>
                                    <td class="text-center"><span class="security-strength strength-strong">224 bits</span></td>
                                    <td class="text-center"><span class="security-strength strength-strong">256 bits</span></td>
                                    <td class="text-center"><span class="security-strength strength-very-strong">384 bits</span></td>
                                    <td class="text-center"><span class="security-strength strength-excellent">512 bits</span></td>
                                    <td class="text-center"><span class="security-strength strength-strong">224 bits</span></td>
                                    <td class="text-center"><span class="security-strength strength-strong">256 bits</span></td>
                                </tr>
                                <tr class="security-property-row">
                                    <td><strong><i class="fas fa-shield-alt"></i> Second Preimage Resistance</strong> <i class="fas fa-question-circle tooltip-icon" data-toggle="tooltip" title="Resistance to finding a second input that produces the same hash as a given input"></i></td>
                                    <td class="text-center"><span class="security-strength strength-medium">105-160 bits</span></td>
                                    <td class="text-center"><span class="security-strength strength-strong">201-224 bits</span></td>
                                    <td class="text-center"><span class="security-strength strength-strong">201-256 bits</span></td>
                                    <td class="text-center"><span class="security-strength strength-very-strong">384 bits</span></td>
                                    <td class="text-center"><span class="security-strength strength-excellent">394-512 bits</span></td>
                                    <td class="text-center"><span class="security-strength strength-strong">224 bits</span></td>
                                    <td class="text-center"><span class="security-strength strength-strong">256 bits</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="mt-3">
                        <small class="text-muted">
                            <i class="fas fa-lightbulb"></i> <strong>Recommendation:</strong> For new applications, use SHA-256 or higher. SHA-1 is deprecated and should not be used for security-critical applications.
                        </small>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <hr>

    <div class="row mt-4">
        <div class="col-12">
            <div class="card shadow-sm">
                <div class="card-header bg-info text-white">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <h5 class="mb-0"><i class="fas fa-list"></i> Hash Functions and Their Output Lengths</h5>
                        </div>
                        <div class="col-md-6">
                            <div class="input-group search-box">
                                <div class="input-group-prepend">
                                    <span class="input-group-text"><i class="fas fa-search"></i></span>
                                </div>
                                <input type="text" class="form-control" id="hashSearchInput" placeholder="Search hash functions...">
                                <div class="input-group-append">
                                    <button class="btn btn-outline-light" type="button" id="clearSearchBtn" style="display: none;">
                                        <i class="fas fa-times"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <p class="text-muted mb-3"><i class="fas fa-info-circle"></i> Browse through common hash functions and their output lengths. Use the search box to filter results.</p>
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover" id="hashFunctionsTable">
                            <thead class="thead-dark">
                                <tr>
                                    <th style="min-width: 300px;"><strong><i class="fas fa-key"></i> Hash Function Name</strong></th>
                                    <th style="min-width: 200px;" class="text-center"><strong><i class="fas fa-ruler"></i> Output Length</strong></th>
                                    <th style="min-width: 150px;" class="text-center"><strong><i class="fas fa-info-circle"></i> Status</strong></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr class="hash-algorithm-row" data-name="MD2" data-category="MD">
                                    <td><strong>MD2</strong> <span class="algorithm-badge badge-md">MD Family</span></td>
                                    <td class="text-center"><span class="badge badge-secondary">128 bits</span> <small class="text-muted">(16 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-danger">Deprecated</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="MD4" data-category="MD">
                                    <td><strong>MD4</strong> <span class="algorithm-badge badge-md">MD Family</span></td>
                                    <td class="text-center"><span class="badge badge-secondary">128 bits</span> <small class="text-muted">(16 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-danger">Deprecated</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="MD5" data-category="MD">
                                    <td><strong>MD5</strong> <span class="algorithm-badge badge-md">MD Family</span></td>
                                    <td class="text-center"><span class="badge badge-secondary">128 bits</span> <small class="text-muted">(16 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-warning">Weak</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="MD6" data-category="MD">
                                    <td><strong>MD6</strong> <span class="algorithm-badge badge-md">MD Family</span></td>
                                    <td class="text-center"><span class="badge badge-info">Up to 512 bits</span></td>
                                    <td class="text-center"><span class="badge badge-secondary">Not Standard</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="SHA-1" data-category="SHA">
                                    <td><strong>SHA-1</strong> <span class="algorithm-badge badge-sha">SHA Family</span></td>
                                    <td class="text-center"><span class="badge badge-secondary">160 bits</span> <small class="text-muted">(20 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-warning">Deprecated</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="SHA-224" data-category="SHA">
                                    <td><strong>SHA-224</strong> <span class="algorithm-badge badge-sha">SHA-2</span></td>
                                    <td class="text-center"><span class="badge badge-primary">224 bits</span> <small class="text-muted">(28 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-success">Recommended</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="SHA-256" data-category="SHA">
                                    <td><strong>SHA-256</strong> <span class="algorithm-badge badge-sha">SHA-2</span></td>
                                    <td class="text-center"><span class="badge badge-primary">256 bits</span> <small class="text-muted">(32 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-success">Recommended</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="SHA-384" data-category="SHA">
                                    <td><strong>SHA-384</strong> <span class="algorithm-badge badge-sha">SHA-2</span></td>
                                    <td class="text-center"><span class="badge badge-primary">384 bits</span> <small class="text-muted">(48 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-success">Recommended</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="SHA-512" data-category="SHA">
                                    <td><strong>SHA-512</strong> <span class="algorithm-badge badge-sha">SHA-2</span></td>
                                    <td class="text-center"><span class="badge badge-primary">512 bits</span> <small class="text-muted">(64 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-success">Recommended</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="SHA-512/224" data-category="SHA">
                                    <td><strong>SHA-512/224</strong> <span class="algorithm-badge badge-sha">SHA-2</span></td>
                                    <td class="text-center"><span class="badge badge-primary">224 bits</span> <small class="text-muted">(28 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-success">Recommended</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="SHA-512/256" data-category="SHA">
                                    <td><strong>SHA-512/256</strong> <span class="algorithm-badge badge-sha">SHA-2</span></td>
                                    <td class="text-center"><span class="badge badge-primary">256 bits</span> <small class="text-muted">(32 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-success">Recommended</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="SHA3-224" data-category="SHA3">
                                    <td><strong>SHA3-224</strong> <span class="algorithm-badge badge-sha3">SHA-3</span></td>
                                    <td class="text-center"><span class="badge badge-success">224 bits</span> <small class="text-muted">(28 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-success">Modern Standard</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="SHA3-256" data-category="SHA3">
                                    <td><strong>SHA3-256</strong> <span class="algorithm-badge badge-sha3">SHA-3</span></td>
                                    <td class="text-center"><span class="badge badge-success">256 bits</span> <small class="text-muted">(32 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-success">Modern Standard</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="SHA3-384" data-category="SHA3">
                                    <td><strong>SHA3-384</strong> <span class="algorithm-badge badge-sha3">SHA-3</span></td>
                                    <td class="text-center"><span class="badge badge-success">384 bits</span> <small class="text-muted">(48 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-success">Modern Standard</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="SHA3-512" data-category="SHA3">
                                    <td><strong>SHA3-512</strong> <span class="algorithm-badge badge-sha3">SHA-3</span></td>
                                    <td class="text-center"><span class="badge badge-success">512 bits</span> <small class="text-muted">(64 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-success">Modern Standard</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="RIPEMD-128" data-category="RIPEMD">
                                    <td><strong>RIPEMD-128</strong> <span class="algorithm-badge" style="background-color: #6f42c1; color: #fff;">RIPEMD</span></td>
                                    <td class="text-center"><span class="badge badge-secondary">128 bits</span> <small class="text-muted">(16 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-warning">Weak</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="RIPEMD-160" data-category="RIPEMD">
                                    <td><strong>RIPEMD-160</strong> <span class="algorithm-badge" style="background-color: #6f42c1; color: #fff;">RIPEMD</span></td>
                                    <td class="text-center"><span class="badge badge-secondary">160 bits</span> <small class="text-muted">(20 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-info">Legacy</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="RIPEMD-256" data-category="RIPEMD">
                                    <td><strong>RIPEMD-256</strong> <span class="algorithm-badge" style="background-color: #6f42c1; color: #fff;">RIPEMD</span></td>
                                    <td class="text-center"><span class="badge badge-primary">256 bits</span> <small class="text-muted">(32 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-info">Legacy</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="RIPEMD-320" data-category="RIPEMD">
                                    <td><strong>RIPEMD-320</strong> <span class="algorithm-badge" style="background-color: #6f42c1; color: #fff;">RIPEMD</span></td>
                                    <td class="text-center"><span class="badge badge-primary">320 bits</span> <small class="text-muted">(40 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-info">Legacy</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="BLAKE2b-160" data-category="BLAKE2b">
                                    <td><strong>BLAKE2b-160</strong> <span class="algorithm-badge" style="background-color: #17a2b8; color: #fff;">BLAKE2b</span></td>
                                    <td class="text-center"><span class="badge badge-secondary">160 bits</span> <small class="text-muted">(20 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-success">Modern</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="BLAKE2b-256" data-category="BLAKE2b">
                                    <td><strong>BLAKE2b-256</strong> <span class="algorithm-badge" style="background-color: #17a2b8; color: #fff;">BLAKE2b</span></td>
                                    <td class="text-center"><span class="badge badge-primary">256 bits</span> <small class="text-muted">(32 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-success">Modern</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="BLAKE2b-384" data-category="BLAKE2b">
                                    <td><strong>BLAKE2b-384</strong> <span class="algorithm-badge" style="background-color: #17a2b8; color: #fff;">BLAKE2b</span></td>
                                    <td class="text-center"><span class="badge badge-primary">384 bits</span> <small class="text-muted">(48 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-success">Modern</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="BLAKE2b-512" data-category="BLAKE2b">
                                    <td><strong>BLAKE2b-512</strong> <span class="algorithm-badge" style="background-color: #17a2b8; color: #fff;">BLAKE2b</span></td>
                                    <td class="text-center"><span class="badge badge-primary">512 bits</span> <small class="text-muted">(64 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-success">Modern</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="TIGER" data-category="TIGER">
                                    <td><strong>TIGER</strong> <span class="algorithm-badge" style="background-color: #fd7e14; color: #fff;">TIGER</span></td>
                                    <td class="text-center"><span class="badge badge-primary">192 bits</span> <small class="text-muted">(24 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-info">Legacy</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="Whirlpool" data-category="Whirlpool">
                                    <td><strong>Whirlpool</strong> <span class="algorithm-badge" style="background-color: #e83e8c; color: #fff;">Whirlpool</span></td>
                                    <td class="text-center"><span class="badge badge-primary">512 bits</span> <small class="text-muted">(64 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-info">Legacy</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="SM3" data-category="SM3">
                                    <td><strong>SM3</strong> <span class="algorithm-badge" style="background-color: #dc3545; color: #fff;">Chinese Standard</span></td>
                                    <td class="text-center"><span class="badge badge-primary">256 bits</span> <small class="text-muted">(32 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-success">Standard</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="GOST3411" data-category="GOST">
                                    <td><strong>GOST R 34.11-94</strong> <span class="algorithm-badge" style="background-color: #dc3545; color: #fff;">GOST</span></td>
                                    <td class="text-center"><span class="badge badge-primary">256 bits</span> <small class="text-muted">(32 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-info">Russian Standard</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="GOST3411-2012-256" data-category="GOST">
                                    <td><strong>GOST R 34.11-2012 (256)</strong> <span class="algorithm-badge" style="background-color: #dc3545; color: #fff;">GOST</span></td>
                                    <td class="text-center"><span class="badge badge-primary">256 bits</span> <small class="text-muted">(32 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-info">Russian Standard</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="GOST3411-2012-512" data-category="GOST">
                                    <td><strong>GOST R 34.11-2012 (512)</strong> <span class="algorithm-badge" style="background-color: #dc3545; color: #fff;">GOST</span></td>
                                    <td class="text-center"><span class="badge badge-primary">512 bits</span> <small class="text-muted">(64 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-info">Russian Standard</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="DSTU7564-256" data-category="DSTU">
                                    <td><strong>DSTU 7564:2014 (256)</strong> <span class="algorithm-badge" style="background-color: #20c997; color: #fff;">DSTU</span></td>
                                    <td class="text-center"><span class="badge badge-primary">256 bits</span> <small class="text-muted">(32 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-info">Ukrainian Standard</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="DSTU7564-384" data-category="DSTU">
                                    <td><strong>DSTU 7564:2014 (384)</strong> <span class="algorithm-badge" style="background-color: #20c997; color: #fff;">DSTU</span></td>
                                    <td class="text-center"><span class="badge badge-primary">384 bits</span> <small class="text-muted">(48 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-info">Ukrainian Standard</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="DSTU7564-512" data-category="DSTU">
                                    <td><strong>DSTU 7564:2014 (512)</strong> <span class="algorithm-badge" style="background-color: #20c997; color: #fff;">DSTU</span></td>
                                    <td class="text-center"><span class="badge badge-primary">512 bits</span> <small class="text-muted">(64 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-info">Ukrainian Standard</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="Keccak-224" data-category="Keccak">
                                    <td><strong>Keccak-224</strong> <span class="algorithm-badge badge-sha3">Keccak</span></td>
                                    <td class="text-center"><span class="badge badge-primary">224 bits</span> <small class="text-muted">(28 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-success">Modern</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="Keccak-256" data-category="Keccak">
                                    <td><strong>Keccak-256</strong> <span class="algorithm-badge badge-sha3">Keccak</span></td>
                                    <td class="text-center"><span class="badge badge-primary">256 bits</span> <small class="text-muted">(32 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-success">Modern</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="Keccak-384" data-category="Keccak">
                                    <td><strong>Keccak-384</strong> <span class="algorithm-badge badge-sha3">Keccak</span></td>
                                    <td class="text-center"><span class="badge badge-primary">384 bits</span> <small class="text-muted">(48 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-success">Modern</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="Keccak-512" data-category="Keccak">
                                    <td><strong>Keccak-512</strong> <span class="algorithm-badge badge-sha3">Keccak</span></td>
                                    <td class="text-center"><span class="badge badge-primary">512 bits</span> <small class="text-muted">(64 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-success">Modern</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="SKEIN-256-256" data-category="SKEIN">
                                    <td><strong>SKEIN-256-256</strong> <span class="algorithm-badge" style="background-color: #6610f2; color: #fff;">SKEIN</span></td>
                                    <td class="text-center"><span class="badge badge-primary">256 bits</span> <small class="text-muted">(32 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-info">Alternative</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="SKEIN-512-512" data-category="SKEIN">
                                    <td><strong>SKEIN-512-512</strong> <span class="algorithm-badge" style="background-color: #6610f2; color: #fff;">SKEIN</span></td>
                                    <td class="text-center"><span class="badge badge-primary">512 bits</span> <small class="text-muted">(64 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-info">Alternative</span></td>
                                </tr>
                                <tr class="hash-algorithm-row" data-name="SKEIN-1024-1024" data-category="SKEIN">
                                    <td><strong>SKEIN-1024-1024</strong> <span class="algorithm-badge" style="background-color: #6610f2; color: #fff;">SKEIN</span></td>
                                    <td class="text-center"><span class="badge badge-info">1024 bits</span> <small class="text-muted">(128 bytes)</small></td>
                                    <td class="text-center"><span class="badge badge-info">Alternative</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="mt-3">
                        <div class="alert alert-info mb-0">
                            <i class="fas fa-lightbulb"></i> <strong>Tip:</strong> SHA-256 and SHA-512 are the most commonly used hash functions today. SHA-3 (Keccak) and BLAKE2b are modern alternatives with excellent security properties. This tool supports 50+ hash algorithms including international standards (GOST, DSTU, SM3).
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="addcomments.jsp"%>
    <%@ include file="footer_adsense.jsp"%>

</div>
</div>
<%@ include file="body-close.jsp"%>
