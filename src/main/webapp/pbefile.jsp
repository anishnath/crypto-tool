<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>PBE File Encryption Decryption Online - Free | 8gwifi.org</title>
    <meta name="description" content="Encrypt and decrypt files using Password-Based Encryption (PBE). Upload files up to 10MB and secure them with PBKDF algorithms like AES-256, DES, RC2, and more. Free online PBE file encryption tool." />
    <meta name="keywords" content="PBE file encryption, password based file encryption, encrypt file online, decrypt file online, PBKDF2 file encryption, AES file encryption, secure file encryption" />
    <meta name="robots" content="index,follow" />
    <meta name="author" content="Anish Nath" />
    <link rel="canonical" href="https://8gwifi.org/pbefile.jsp" />

    <%
        String[] validList = { "PBEWITHMD5ANDDES", "PBEWITHMD5ANDRC2", "PBEWITHSHA1ANDRC2",
                "PBEWITHSHA1ANDDES", "PBEWITHSHA1ANDRC2_128", "PBEWITHSHA1ANDRC2_40",
                "PBEWITHSHA1ANDRC4_128", "PBEWITHSHA1ANDRC4_40", "PBEWITHSHA1ANDDESEDE",
                "PBEWITHSHAANDIDEA-CBC", "PBEWITHSHAAND128BITRC4", "PBEWITHMD5ANDTRIPLEDES",
                "PBEWITHSHAAND40BITRC4", "PBEWITHMD5AND128BITAES-CBC-OPENSSL",
                "PBEWITHMD5AND192BITAES-CBC-OPENSSL", "PBEWITHMD5AND256BITAES-CBC-OPENSSL",
                "PBEWITHSHA256AND128BITAES-CBC-BC", "PBEWITHSHA256AND192BITAES-CBC-BC",
                "PBEWITHSHA256AND256BITAES-CBC-BC", "PBEWITHSHAAND128BITAES-CBC-BC",
                "PBEWITHSHAAND128BITRC2-CBC", "PBEWITHSHAAND192BITAES-CBC-BC",
                "PBEWITHSHAAND2-KEYTRIPLEDES-CBC", "PBEWITHSHAAND256BITAES-CBC-BC",
                "PBEWITHSHAAND3-KEYTRIPLEDES-CBC", "PBEWITHSHAAND40BITRC2-CBC" };
    %>

    <!-- JSON-LD Structured Data -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "PBE File Encryption/Decryption Tool",
        "description": "Encrypt and decrypt files using Password-Based Encryption (PBE). Supports multiple PBKDF algorithms including AES-256, DES, RC2, and more.",
        "url": "https://8gwifi.org/pbefile.jsp",
        "applicationCategory": "SecurityApplication",
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
        "datePublished": "2018-01-17",
        "dateModified": "2025-01-15"
    }
    </script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "HowTo",
        "name": "How to Encrypt a File Using PBE",
        "description": "Step-by-step guide to encrypt files using Password-Based Encryption",
        "step": [
            {
                "@type": "HowToStep",
                "name": "Upload File",
                "text": "Select and upload the file you want to encrypt (max 10MB)"
            },
            {
                "@type": "HowToStep",
                "name": "Set Password",
                "text": "Enter a strong password that will be used to derive the encryption key"
            },
            {
                "@type": "HowToStep",
                "name": "Configure Rounds",
                "text": "Set the number of iterations for key derivation"
            },
            {
                "@type": "HowToStep",
                "name": "Select Algorithm",
                "text": "Choose a PBE cipher algorithm from the list"
            },
            {
                "@type": "HowToStep",
                "name": "Encrypt",
                "text": "Click Encrypt to process the file and download the encrypted result"
            }
        ],
        "tool": {
            "@type": "HowToTool",
            "name": "8gwifi.org PBE File Encryption Tool"
        }
    }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        :root {
            --theme-primary: #6366f1;
            --theme-secondary: #8b5cf6;
            --theme-gradient: linear-gradient(135deg, #6366f1 0%, #8b5cf6 50%, #a855f7 100%);
            --theme-light: #eef2ff;
        }
        .tool-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(99, 102, 241, 0.15);
            transition: box-shadow 0.3s ease;
        }
        .tool-card:hover {
            box-shadow: 0 4px 20px rgba(99, 102, 241, 0.25);
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
            min-height: 300px;
            display: flex;
            flex-direction: column;
        }
        .result-placeholder {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
        }
        .result-content {
            display: none;
        }
        .cipher-select {
            max-height: 150px;
            overflow-y: auto;
            font-size: 0.8rem;
        }
        .cipher-select option {
            padding: 0.35rem;
        }
        .cipher-select option:checked {
            background: var(--theme-gradient);
            color: white;
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
            margin-bottom: 0.25rem;
        }
        .mode-toggle {
            display: flex;
            gap: 0;
            margin-bottom: 0.75rem;
        }
        .mode-toggle .btn {
            flex: 1;
            border-radius: 0;
            padding: 0.35rem 0.75rem;
            font-size: 0.85rem;
        }
        .mode-toggle .btn:first-child {
            border-radius: 8px 0 0 8px;
        }
        .mode-toggle .btn:last-child {
            border-radius: 0 8px 8px 0;
        }
        .mode-toggle .btn.active {
            background: var(--theme-gradient);
            border-color: transparent;
            color: white;
        }
        .file-upload-area {
            border: 2px dashed var(--theme-primary);
            border-radius: 8px;
            padding: 1.5rem;
            text-align: center;
            background: #fafaff;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .file-upload-area:hover {
            background: var(--theme-light);
            border-color: var(--theme-secondary);
        }
        .file-upload-area.dragover {
            background: var(--theme-light);
            border-color: var(--theme-secondary);
        }
        .file-upload-area i {
            color: var(--theme-primary);
        }
        .file-info {
            background: #e8f5e9;
            border-radius: 8px;
            padding: 0.75rem;
            display: none;
        }
        .file-info.show {
            display: block;
        }
        .loading-spinner {
            display: none;
            text-align: center;
            padding: 2rem;
        }
        .success-message {
            background: #e8f5e9;
            border: 1px solid #4caf50;
            border-radius: 8px;
            padding: 1rem;
            color: #2e7d32;
        }
        .error-message {
            background: #fff5f5;
            border: 1px solid #fc8181;
            border-radius: 8px;
            padding: 1rem;
            color: #c53030;
        }
        .download-btn {
            background: var(--theme-gradient);
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        .download-btn:hover {
            color: white;
            opacity: 0.9;
        }
        .terminal-block {
            background: #1e1e1e;
            border-radius: 8px;
            overflow: hidden;
            margin-bottom: 1rem;
        }
        .terminal-header {
            background: #323232;
            color: #d4d4d4;
            padding: 0.5rem 1rem;
            font-size: 0.75rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .terminal-body {
            padding: 1rem;
            color: #4ec9b0;
            font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
            font-size: 0.85rem;
        }
        .terminal-body code {
            color: #ce9178;
        }
        .cmd-description {
            color: #6a9955;
            font-size: 0.8rem;
        }
        .related-tools {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 1rem;
        }
        .related-tool-card {
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 1rem;
            text-decoration: none;
            color: inherit;
            transition: all 0.2s ease;
        }
        .related-tool-card:hover {
            border-color: var(--theme-primary);
            box-shadow: 0 2px 8px rgba(99, 102, 241, 0.2);
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
    </style>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="pgp-menu-nav.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-2">
    <div>
        <h1 class="h4 mb-0">PBE File Encryption/Decryption</h1>
        <div class="mt-1">
            <span class="info-badge"><i class="fas fa-file"></i> Max 10MB</span>
            <span class="info-badge"><i class="fas fa-lock"></i> 26 Algorithms</span>
            <span class="info-badge"><i class="fas fa-key"></i> PBKDF</span>
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
                <h5><i class="fas fa-file-lock me-2"></i>PBE File Encrypt/Decrypt</h5>
            </div>
            <div class="card-body">
                <form id="pbeFileForm" action="PBEFunctionality" enctype="multipart/form-data" method="POST">
                    <input type="hidden" name="methodName" value="PBEBLOCK">

                    <!-- Mode Toggle -->
                    <div class="mode-toggle">
                        <button type="button" class="btn btn-outline-secondary active" id="encryptMode" onclick="setMode('encrypt')">
                            <i class="fas fa-lock me-1"></i>Encrypt
                        </button>
                        <button type="button" class="btn btn-outline-secondary" id="decryptMode" onclick="setMode('decrypt')">
                            <i class="fas fa-unlock me-1"></i>Decrypt
                        </button>
                    </div>
                    <input type="hidden" name="encryptorDecrypt" id="encryptorDecrypt" value="encrypt">

                    <!-- File Upload -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-file-upload me-1"></i>Upload File</div>
                        <div class="file-upload-area" id="dropZone" onclick="document.getElementById('fileInput').click();">
                            <i class="fas fa-cloud-upload-alt fa-2x mb-2"></i>
                            <p class="mb-1">Click to upload or drag & drop</p>
                            <small class="text-muted">Maximum file size: 10MB</small>
                        </div>
                        <input type="file" name="upfile" id="fileInput" style="display: none;" required>
                        <div class="file-info mt-2" id="fileInfo">
                            <i class="fas fa-file text-success me-2"></i>
                            <span id="fileName">No file selected</span>
                            <span class="badge bg-secondary ms-2" id="fileSize"></span>
                            <button type="button" class="btn btn-sm btn-outline-danger float-end" onclick="clearFile()">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Password & Rounds Row -->
                    <div class="row g-2 mb-2">
                        <div class="col-8">
                            <div class="form-section mb-0">
                                <div class="form-section-title"><i class="fas fa-key me-1"></i>Password</div>
                                <div class="input-group input-group-sm">
                                    <input type="password" class="form-control" id="secretkey" name="secretkey" required placeholder="Enter password">
                                    <button class="btn btn-outline-secondary" type="button" id="togglePassword" title="Show/Hide">
                                        <i class="fas fa-eye" id="toggleIcon"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                        <div class="col-4">
                            <div class="form-section mb-0">
                                <div class="form-section-title"><i class="fas fa-sync-alt me-1"></i>Rounds</div>
                                <input type="number" class="form-control form-control-sm" id="rounds" name="rounds" value="1000" min="1" max="5000">
                            </div>
                        </div>
                    </div>

                    <!-- Algorithm Selection -->
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-cogs me-1"></i>Algorithm</div>
                        <select class="form-control cipher-select" name="cipherparameter" id="cipherparameter" size="6">
                            <% for (int i = 0; i < validList.length; i++) {
                                String param = validList[i];
                                String selected = (i == 0) ? "selected" : "";
                            %>
                            <option <%=selected%> value="<%=param%>"><%=param%></option>
                            <% } %>
                        </select>
                    </div>

                    <button type="submit" class="btn w-100" id="submitBtn" style="background: var(--theme-gradient); color: white; font-weight: 600;">
                        <i class="fas fa-lock me-2"></i>Encrypt File
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- Right Column: Results -->
    <div class="col-lg-7 mb-4">
        <div class="card tool-card result-card">
            <div class="card-header card-header-custom">
                <h5><i class="fas fa-file-alt me-2"></i>Result</h5>
            </div>
            <div class="card-body" style="overflow-y: auto;">
                <div class="result-placeholder" id="resultPlaceholder">
                    <div class="text-center">
                        <i class="fas fa-file-lock fa-3x mb-3 text-muted"></i>
                        <p class="mb-0">Encryption result will appear here</p>
                        <small class="text-muted">Upload a file, enter password, then click Encrypt</small>
                    </div>
                </div>

                <div class="loading-spinner" id="loadingSpinner">
                    <div class="spinner-border" style="color: var(--theme-primary);" role="status">
                        <span class="visually-hidden">Processing...</span>
                    </div>
                    <p class="mt-2 mb-0">Processing file...</p>
                </div>

                <div class="result-content" id="resultContent">
                    <%
                        String msg = (String) session.getAttribute("msg");
                        String downloadLink = (String) session.getAttribute("downloadlink");
                        if (msg != null && msg.length() > 0) {
                            // Check if it's a success or error message
                            boolean isSuccess = msg.contains("Successfully");
                    %>
                    <div class="<%= isSuccess ? "success-message" : "error-message" %> mb-3">
                        <i class="fas <%= isSuccess ? "fa-check-circle" : "fa-exclamation-circle" %> me-2"></i>
                        <%= msg.replaceAll("<[^>]*>", "") %>
                    </div>
                    <% if (downloadLink != null && downloadLink.length() > 0) { %>
                    <div class="text-center">
                        <a href="/PBEFunctionality?uid=<%= downloadLink %>" class="download-btn">
                            <i class="fas fa-download"></i>
                            Download Processed File
                        </a>
                    </div>
                    <% }
                        // Clear session attributes
                        session.removeAttribute("msg");
                        session.removeAttribute("downloadlink");
                    } %>
                </div>
            </div>
        </div>

        <!-- OpenSSL Commands Reference -->
        <div class="card tool-card mt-4">
            <div class="card-header bg-dark text-white">
                <h5 class="mb-0"><i class="fas fa-terminal me-2"></i>OpenSSL File Encryption</h5>
            </div>
            <div class="card-body p-0">
                <div class="terminal-block">
                    <div class="terminal-header">
                        <span>Encrypt File with AES-256-CBC</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="openssl enc -aes-256-cbc -salt -pbkdf2 -iter 10000 -in file.txt -out file.enc">
                            <i class="fas fa-copy"></i>
                        </button>
                    </div>
                    <div class="terminal-body">
                        <div class="cmd-description"># Encrypt file using PBKDF2</div>
                        <div>$ openssl enc -aes-256-cbc -salt -pbkdf2 -iter <code>10000</code> \<br>  -in <code>file.txt</code> -out <code>file.enc</code></div>
                    </div>
                </div>

                <div class="terminal-block">
                    <div class="terminal-header">
                        <span>Decrypt File</span>
                        <button class="btn btn-sm btn-outline-light" onclick="copyCommand(this)" data-cmd="openssl enc -aes-256-cbc -d -pbkdf2 -iter 10000 -in file.enc -out file.txt">
                            <i class="fas fa-copy"></i>
                        </button>
                    </div>
                    <div class="terminal-body">
                        <div class="cmd-description"># Decrypt file using same parameters</div>
                        <div>$ openssl enc -aes-256-cbc -d -pbkdf2 -iter <code>10000</code> \<br>  -in <code>file.enc</code> -out <code>file.txt</code></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Related Tools -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light">
        <h5 class="mb-0"><i class="fas fa-tools me-2"></i>Related Encryption Tools</h5>
    </div>
    <div class="card-body">
        <div class="related-tools">
            <a href="pbe.jsp" class="related-tool-card">
                <h6><i class="fas fa-user-lock me-1"></i>PBE Message Encryption</h6>
                <p>Encrypt/decrypt text messages with PBE</p>
            </a>
            <a href="CipherFunctions.jsp" class="related-tool-card">
                <h6><i class="fas fa-lock me-1"></i>AES Encryption</h6>
                <p>Encrypt/decrypt with AES cipher modes</p>
            </a>
            <a href="pbkdf.jsp" class="related-tool-card">
                <h6><i class="fas fa-key me-1"></i>PBKDF2 Key Derivation</h6>
                <p>Derive encryption keys from passwords</p>
            </a>
            <a href="hmacgen.jsp" class="related-tool-card">
                <h6><i class="fas fa-fingerprint me-1"></i>HMAC Generator</h6>
                <p>Generate HMAC signatures</p>
            </a>
        </div>
    </div>
</div>

<%@ include file="thanks.jsp"%>

<!-- Educational Content -->
<div class="card tool-card mb-4">
    <div class="card-header bg-light">
        <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding PBE File Encryption</h5>
    </div>
    <div class="card-body">
        <h6>What is Password-Based File Encryption?</h6>
        <p>Password-Based Encryption (PBE) as specified in PKCS#5 (RFC 2898) allows you to encrypt files using a password instead of managing complex cryptographic keys. The password is combined with a salt and processed through multiple iterations to derive a secure encryption key.</p>

        <h6 class="mt-4">How It Works</h6>
        <div class="row mb-4">
            <div class="col-md-3 text-center mb-3">
                <div class="p-3 bg-light rounded h-100">
                    <i class="fas fa-file fa-2x mb-2" style="color: var(--theme-primary);"></i>
                    <div><strong>1. Upload File</strong></div>
                    <small class="text-muted">Select the file to encrypt/decrypt</small>
                </div>
            </div>
            <div class="col-md-3 text-center mb-3">
                <div class="p-3 bg-light rounded h-100">
                    <i class="fas fa-key fa-2x mb-2" style="color: var(--theme-primary);"></i>
                    <div><strong>2. Password</strong></div>
                    <small class="text-muted">Enter a strong password</small>
                </div>
            </div>
            <div class="col-md-3 text-center mb-3">
                <div class="p-3 bg-light rounded h-100">
                    <i class="fas fa-cogs fa-2x mb-2" style="color: var(--theme-primary);"></i>
                    <div><strong>3. Process</strong></div>
                    <small class="text-muted">PBKDF derives key & encrypts</small>
                </div>
            </div>
            <div class="col-md-3 text-center mb-3">
                <div class="p-3 bg-light rounded h-100">
                    <i class="fas fa-download fa-2x mb-2" style="color: var(--theme-primary);"></i>
                    <div><strong>4. Download</strong></div>
                    <small class="text-muted">Get encrypted/decrypted file</small>
                </div>
            </div>
        </div>

        <h6 class="mt-4">Security Recommendations</h6>
        <div class="row">
            <div class="col-md-6">
                <div class="alert alert-success mb-0">
                    <strong><i class="fas fa-check-circle me-1"></i> Recommended:</strong>
                    <ul class="mb-0 mt-2 small">
                        <li>PBEWITHSHA256AND256BITAES-CBC-BC</li>
                        <li>PBEWITHMD5AND256BITAES-CBC-OPENSSL</li>
                        <li>Use 1000+ iterations</li>
                        <li>Use strong, unique passwords</li>
                    </ul>
                </div>
            </div>
            <div class="col-md-6">
                <div class="alert alert-warning mb-0">
                    <strong><i class="fas fa-exclamation-triangle me-1"></i> Avoid:</strong>
                    <ul class="mb-0 mt-2 small">
                        <li>PBEWITHMD5ANDDES (weak)</li>
                        <li>RC4-based algorithms</li>
                        <li>Low iteration counts</li>
                        <li>Simple or reused passwords</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="addcomments.jsp"%>

</div>

<script>
var currentMode = 'encrypt';

function setMode(mode) {
    currentMode = mode;
    $('#encryptorDecrypt').val(mode);

    if (mode === 'encrypt') {
        $('#encryptMode').addClass('active');
        $('#decryptMode').removeClass('active');
        $('#submitBtn').html('<i class="fas fa-lock me-2"></i>Encrypt File');
    } else {
        $('#decryptMode').addClass('active');
        $('#encryptMode').removeClass('active');
        $('#submitBtn').html('<i class="fas fa-unlock me-2"></i>Decrypt File');
    }
}

// File upload handling
var dropZone = document.getElementById('dropZone');
var fileInput = document.getElementById('fileInput');

['dragenter', 'dragover', 'dragleave', 'drop'].forEach(function(eventName) {
    dropZone.addEventListener(eventName, function(e) {
        e.preventDefault();
        e.stopPropagation();
    }, false);
});

['dragenter', 'dragover'].forEach(function(eventName) {
    dropZone.addEventListener(eventName, function() {
        dropZone.classList.add('dragover');
    }, false);
});

['dragleave', 'drop'].forEach(function(eventName) {
    dropZone.addEventListener(eventName, function() {
        dropZone.classList.remove('dragover');
    }, false);
});

dropZone.addEventListener('drop', function(e) {
    var files = e.dataTransfer.files;
    if (files.length > 0) {
        fileInput.files = files;
        showFileInfo(files[0]);
    }
}, false);

fileInput.addEventListener('change', function() {
    if (this.files.length > 0) {
        showFileInfo(this.files[0]);
    }
});

function showFileInfo(file) {
    var maxSize = 10 * 1024 * 1024; // 10MB
    if (file.size > maxSize) {
        showToast('File size exceeds 10MB limit');
        clearFile();
        return;
    }

    $('#fileName').text(file.name);
    $('#fileSize').text(formatFileSize(file.size));
    $('#fileInfo').addClass('show');
    $('#dropZone').hide();
}

function clearFile() {
    fileInput.value = '';
    $('#fileInfo').removeClass('show');
    $('#dropZone').show();
}

function formatFileSize(bytes) {
    if (bytes === 0) return '0 Bytes';
    var k = 1024;
    var sizes = ['Bytes', 'KB', 'MB', 'GB'];
    var i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
}

// Toggle password visibility
$('#togglePassword').click(function() {
    var input = $('#secretkey');
    var icon = $('#toggleIcon');
    if (input.attr('type') === 'password') {
        input.attr('type', 'text');
        icon.removeClass('fa-eye').addClass('fa-eye-slash');
    } else {
        input.attr('type', 'password');
        icon.removeClass('fa-eye-slash').addClass('fa-eye');
    }
});

// Form submission
$('#pbeFileForm').submit(function(event) {
    var file = fileInput.files[0];
    var password = $('#secretkey').val();

    if (!file) {
        event.preventDefault();
        showToast('Please select a file');
        return;
    }
    if (!password) {
        event.preventDefault();
        showToast('Please enter a password');
        return;
    }

    // Show loading state
    $('#resultPlaceholder').hide();
    $('#resultContent').hide();
    $('#loadingSpinner').show();
    $('#submitBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Processing...');
});

function copyCommand(btn) {
    var cmd = $(btn).data('cmd');
    navigator.clipboard.writeText(cmd).then(function() {
        showToast('Command copied!');
    });
}

function showToast(message) {
    var toast = $('<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999;">' +
        '<div class="toast show" role="alert">' +
        '<div class="toast-body text-white rounded" style="background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);">' +
        '<i class="fas fa-info-circle me-2"></i>' + message +
        '</div></div></div>');
    $('body').append(toast);
    setTimeout(function() {
        toast.fadeOut(function() { toast.remove(); });
    }, 2000);
}

// Show result if session has data
$(document).ready(function() {
    var resultContent = $('#resultContent').html().trim();
    if (resultContent.length > 0) {
        $('#resultPlaceholder').hide();
        $('#resultContent').show();
    }
});
</script>

<%@ include file="body-close.jsp"%>
