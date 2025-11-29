<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
    <title>Steganography Tool - Hide Secret Messages in Images | 8gwifi.org</title>
    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
    <meta name="description" content="Free online steganography tool to hide and extract secret messages in images using LSB encoding. Supports password protection, multiple image formats, and works entirely in your browser.">
    <meta name="keywords" content="steganography, hide message in image, LSB encoding, data hiding, image steganography, secret message, covert communication, image encryption, online steganography tool">
    <meta name="author" content="Anish Nath">
    <meta name="robots" content="index,follow">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="canonical" href="https://8gwifi.org/steganography-tool.jsp">

    <meta property="og:title" content="Steganography Tool - Hide Secret Messages in Images | 8gwifi.org">
    <meta property="og:description" content="Hide and extract secret messages in images using LSB encoding. Free, client-side, no upload required.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/steganography-tool.jsp">
    <meta property="og:image" content="https://8gwifi.org/images/steganography.png">
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="Steganography Tool - Hide Secret Messages in Images">
    <meta name="twitter:description" content="Hide and extract secret messages in images using LSB encoding. 100% client-side.">

    <%@ include file="header-script.jsp"%>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Steganography Tool - Hide Secret Messages in Images",
      "description": "Online steganography tool to hide and extract secret messages in images using LSB (Least Significant Bit) encoding. Supports password protection and multiple image formats.",
      "url": "https://8gwifi.org/steganography-tool.jsp",
      "image": "https://8gwifi.org/images/steganography.png",
      "applicationCategory": "SecurityApplication",
      "operatingSystem": "Any",
      "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
      "author": {"@type": "Person", "name": "Anish Nath", "url": "https://x.com/anish2good"},
      "datePublished": "2025-01-28",
      "dateModified": "2025-01-30",
      "featureList": [
        "LSB (Least Significant Bit) encoding",
        "Password protection with XOR encryption",
        "Multiple image format support (PNG, JPEG, BMP)",
        "Real-time capacity meter",
        "100% client-side processing",
        "Compatible with other steganography tools"
      ]
    }
    </script>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "FAQPage",
      "mainEntity": [
        {"@type": "Question", "name": "What is steganography?", "acceptedAnswer": {"@type": "Answer", "text": "Steganography is the practice of hiding secret messages within ordinary, non-secret data like images. Unlike encryption which scrambles data, steganography conceals the very existence of the message."}},
        {"@type": "Question", "name": "How does LSB steganography work?", "acceptedAnswer": {"@type": "Answer", "text": "LSB (Least Significant Bit) encoding modifies the least significant bits of image pixels to store message data. Since these bits have minimal visual impact, the changes are invisible to the human eye."}},
        {"@type": "Question", "name": "Is this tool secure?", "acceptedAnswer": {"@type": "Answer", "text": "All processing happens in your browser - no data is uploaded to any server. For additional security, you can password-protect your hidden messages with XOR encryption."}},
        {"@type": "Question", "name": "What image formats are supported?", "acceptedAnswer": {"@type": "Answer", "text": "PNG is recommended for best quality as it uses lossless compression. JPEG and BMP are also supported, but JPEG compression may affect hidden data quality."}}
      ]
    }
    </script>

<style>
:root {
    --theme-primary: #0284c7;
    --theme-secondary: #0ea5e9;
    --theme-gradient: linear-gradient(135deg, #0284c7 0%, #0ea5e9 100%);
    --theme-light: #f0f9ff;
}

.tool-card {
    background: #fff;
    border: none;
    border-radius: 12px;
    box-shadow: 0 2px 12px rgba(2, 132, 199, 0.08);
    transition: box-shadow 0.2s ease;
}

.tool-card:hover {
    box-shadow: 0 4px 20px rgba(2, 132, 199, 0.15);
}

.card-header-custom {
    background: var(--theme-gradient);
    color: white;
    border-radius: 12px 12px 0 0 !important;
    padding: 0.875rem 1.25rem;
    font-weight: 600;
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
    background: var(--theme-light);
    color: var(--theme-primary);
    padding: 0.25rem 0.6rem;
    border-radius: 12px;
    font-size: 0.7rem;
    margin-right: 0.5rem;
    display: inline-flex;
    align-items: center;
    gap: 0.25rem;
}

.btn-generate {
    background: var(--theme-gradient);
    border: none;
    color: white;
    padding: 0.75rem 2rem;
    border-radius: 8px;
    font-weight: 600;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.btn-generate:hover {
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(2, 132, 199, 0.3);
    color: white;
}

.btn-generate:disabled {
    background: #94a3b8;
    transform: none;
    box-shadow: none;
}

.btn-action {
    background: white;
    border: 1px solid #e2e8f0;
    color: #64748b;
    padding: 0.5rem 1rem;
    border-radius: 6px;
    font-size: 0.85rem;
    transition: all 0.2s ease;
}

.btn-action:hover {
    border-color: var(--theme-primary);
    color: var(--theme-primary);
    background: var(--theme-light);
}

.mode-selector {
    display: flex;
    gap: 0.75rem;
    margin-bottom: 1rem;
}

.mode-btn {
    flex: 1;
    padding: 1rem;
    background: white;
    border: 2px solid #e2e8f0;
    border-radius: 8px;
    cursor: pointer;
    transition: all 0.2s ease;
    text-align: center;
}

.mode-btn:hover {
    border-color: var(--theme-primary);
    background: var(--theme-light);
}

.mode-btn.active {
    background: var(--theme-gradient);
    color: white;
    border-color: var(--theme-primary);
}

.mode-btn i {
    font-size: 1.5rem;
    display: block;
    margin-bottom: 0.5rem;
}

.mode-btn h6 {
    margin: 0;
    font-size: 0.9rem;
}

.mode-btn p {
    margin: 0.25rem 0 0;
    font-size: 0.75rem;
    opacity: 0.8;
}

.upload-zone {
    border: 2px dashed #cbd5e1;
    border-radius: 8px;
    padding: 2rem;
    text-align: center;
    cursor: pointer;
    transition: all 0.2s ease;
    background: #f8fafc;
}

.upload-zone:hover,
.upload-zone.dragover {
    border-color: var(--theme-primary);
    background: var(--theme-light);
}

.upload-zone input[type="file"] {
    display: none;
}

.upload-zone i {
    font-size: 2.5rem;
    color: var(--theme-primary);
    margin-bottom: 0.5rem;
}

.image-preview-container {
    display: none;
    margin-top: 1rem;
}

.image-preview-container.active {
    display: block;
}

.image-preview {
    max-width: 100%;
    max-height: 300px;
    border: 2px solid #e2e8f0;
    border-radius: 8px;
    display: block;
    margin: 0 auto 0.75rem;
}

.image-info {
    background: var(--theme-light);
    padding: 0.75rem;
    border-radius: 8px;
    font-size: 0.8rem;
}

.image-info-item {
    display: flex;
    justify-content: space-between;
    padding: 0.25rem 0;
    border-bottom: 1px solid #e0f2fe;
}

.image-info-item:last-child {
    border-bottom: none;
}

.capacity-meter {
    background: var(--theme-light);
    padding: 0.75rem;
    border-radius: 8px;
    margin-top: 0.75rem;
}

.capacity-bar {
    height: 10px;
    background: #e2e8f0;
    border-radius: 5px;
    overflow: hidden;
    margin-top: 0.5rem;
}

.capacity-fill {
    height: 100%;
    background: var(--theme-gradient);
    transition: width 0.3s ease;
    border-radius: 5px;
}

.stego-panel {
    display: none;
}

.stego-panel.active {
    display: block;
}

.result-section {
    display: none;
    margin-top: 1rem;
}

.result-section.active {
    display: block;
}

.result-message {
    background: linear-gradient(135deg, #ecfdf5 0%, #d1fae5 100%);
    border: 1px solid #a7f3d0;
    border-radius: 8px;
    padding: 1rem;
    margin-bottom: 1rem;
}

.result-message h5 {
    color: #065f46;
    margin-bottom: 0.5rem;
}

.result-error {
    background: linear-gradient(135deg, #fef2f2 0%, #fee2e2 100%);
    border: 1px solid #fecaca;
    border-radius: 8px;
    padding: 1rem;
    margin-bottom: 1rem;
}

.result-error h5 {
    color: #991b1b;
}

.extracted-message {
    background: white;
    border: 2px solid var(--theme-primary);
    border-radius: 8px;
    padding: 1rem;
    font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
    white-space: pre-wrap;
    word-break: break-all;
    max-height: 300px;
    overflow-y: auto;
}

.loading-spinner {
    display: none;
    text-align: center;
    padding: 2rem;
}

.loading-spinner.active {
    display: block;
}

.spinner {
    border: 3px solid #e2e8f0;
    border-top: 3px solid var(--theme-primary);
    border-radius: 50%;
    width: 40px;
    height: 40px;
    animation: spin 1s linear infinite;
    margin: 0 auto 0.5rem;
}

@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}

.alert-security {
    background: linear-gradient(135deg, #ecfdf5 0%, #d1fae5 100%);
    border: 1px solid #a7f3d0;
    border-radius: 8px;
    color: #065f46;
}

.options-section {
    background: var(--theme-light);
    border-radius: 8px;
    padding: 1rem;
    margin: 1rem 0;
}

.form-check-input:checked {
    background-color: var(--theme-primary);
    border-color: var(--theme-primary);
}

.related-tools {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
    gap: 1rem;
}

.related-tool-card {
    background: var(--theme-light);
    border: 1px solid #e0f2fe;
    border-radius: 8px;
    padding: 1rem;
    text-decoration: none;
    transition: all 0.2s ease;
    display: block;
}

.related-tool-card:hover {
    border-color: var(--theme-primary);
    box-shadow: 0 2px 8px rgba(2, 132, 199, 0.15);
    text-decoration: none;
    transform: translateY(-2px);
}

.related-tool-card h6 {
    color: var(--theme-primary);
    margin-bottom: 0.25rem;
    font-size: 0.85rem;
}

.related-tool-card p {
    color: #64748b;
    font-size: 0.75rem;
    margin: 0;
}

.result-placeholder {
    background: var(--theme-light);
    border: 2px dashed #bae6fd;
    border-radius: 12px;
    padding: 3rem;
    text-align: center;
    color: #64748b;
}

.result-placeholder i {
    font-size: 3rem;
    color: #bae6fd;
    margin-bottom: 1rem;
}

.code-example {
    background: #1e293b;
    border-radius: 8px;
    padding: 1rem;
    color: #e2e8f0;
    font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
    font-size: 0.8rem;
    overflow-x: auto;
}

@media (max-width: 768px) {
    .mode-selector {
        flex-direction: column;
    }
}
</style>
</head>

<%@ include file="body-script.jsp"%>

<div class="container mt-4">
    <!-- Page Header -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h1 class="h4 mb-1"><i class="fas fa-user-secret me-2" style="color: var(--theme-primary);"></i>Steganography Tool</h1>
            <div class="mt-2">
                <span class="info-badge"><i class="fas fa-lock"></i> Client-Side</span>
                <span class="info-badge"><i class="fas fa-eye-slash"></i> LSB Encoding</span>
                <span class="info-badge"><i class="fas fa-key"></i> Password Protection</span>
                <span class="info-badge"><i class="fas fa-image"></i> PNG/JPEG/BMP</span>
            </div>
        </div>
        <div class="eeat-badge">
            <i class="fas fa-user-check"></i>
            <span>Anish Nath</span>
        </div>
    </div>

    <!-- Security Notice -->
    <div class="alert alert-security mb-4">
        <i class="fas fa-shield-alt me-2"></i>
        <strong>Secure:</strong> All processing happens in your browser. No images or messages are uploaded to any server.
    </div>

    <div class="row">
        <!-- Left Column - Input -->
        <div class="col-lg-5">
            <!-- Mode Selector -->
            <div class="card tool-card mb-3">
                <div class="card-header-custom">
                    <i class="fas fa-cog me-2"></i>Select Mode
                </div>
                <div class="card-body">
                    <div class="mode-selector">
                        <div class="mode-btn active" onclick="switchMode('encode', this)">
                            <i class="fas fa-lock"></i>
                            <h6>Encode</h6>
                            <p>Hide message in image</p>
                        </div>
                        <div class="mode-btn" onclick="switchMode('decode', this)">
                            <i class="fas fa-unlock"></i>
                            <h6>Decode</h6>
                            <p>Extract hidden message</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Encode Panel -->
            <div id="encodePanel" class="stego-panel active">
                <!-- Image Upload Card -->
                <div class="card tool-card mb-3">
                    <div class="card-header-custom">
                        <i class="fas fa-image me-2"></i>Cover Image
                    </div>
                    <div class="card-body">
                        <div class="upload-zone" id="encodeUploadZone">
                            <input type="file" id="encodeImageInput" accept="image/png,image/jpeg,image/bmp">
                            <i class="fas fa-cloud-upload-alt"></i>
                            <h6>Upload Cover Image</h6>
                            <p class="text-muted small mb-0">Click or drag & drop (PNG recommended)</p>
                        </div>

                        <div class="image-preview-container" id="encodePreviewContainer">
                            <canvas id="encodeCanvas" class="image-preview"></canvas>
                            <div class="image-info" id="encodeImageInfo"></div>
                        </div>
                    </div>
                </div>

                <!-- Message Input Card -->
                <div class="card tool-card mb-3">
                    <div class="card-header-custom">
                        <i class="fas fa-comment-dots me-2"></i>Secret Message
                    </div>
                    <div class="card-body">
                        <textarea id="messageInput" class="form-control" rows="5" placeholder="Enter your secret message here..."></textarea>
                        <div class="capacity-meter" id="capacityMeter" style="display: none;">
                            <div class="d-flex justify-content-between small">
                                <span><strong>Capacity:</strong></span>
                                <span id="capacityText">0 / 0 bytes</span>
                            </div>
                            <div class="capacity-bar">
                                <div class="capacity-fill" id="capacityFill" style="width: 0%;"></div>
                            </div>
                            <small class="text-muted" id="capacityDetails"></small>
                        </div>
                    </div>
                </div>

                <!-- Options Card -->
                <div class="card tool-card mb-3">
                    <div class="card-header-custom">
                        <i class="fas fa-sliders-h me-2"></i>Options
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <label for="encodePassword" class="form-label small fw-medium">
                                <i class="fas fa-key me-1"></i> Password (optional)
                            </label>
                            <input type="password" id="encodePassword" class="form-control" placeholder="Enter password to encrypt message">
                            <small class="text-muted">Password required to decode if set</small>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="encodeCompression" checked>
                            <label class="form-check-label small" for="encodeCompression">
                                Enable message compression
                            </label>
                        </div>
                    </div>
                </div>

                <button class="btn btn-generate btn-lg w-100 mb-3" id="encodeBtn" onclick="encodeMessage()" disabled>
                    <i class="fas fa-lock me-2"></i>Hide Message in Image
                </button>
            </div>

            <!-- Decode Panel -->
            <div id="decodePanel" class="stego-panel">
                <!-- Image Upload Card -->
                <div class="card tool-card mb-3">
                    <div class="card-header-custom">
                        <i class="fas fa-image me-2"></i>Image with Hidden Message
                    </div>
                    <div class="card-body">
                        <div class="upload-zone" id="decodeUploadZone">
                            <input type="file" id="decodeImageInput" accept="image/png,image/jpeg,image/bmp">
                            <i class="fas fa-cloud-upload-alt"></i>
                            <h6>Upload Image</h6>
                            <p class="text-muted small mb-0">Upload image containing hidden message</p>
                        </div>

                        <div class="image-preview-container" id="decodePreviewContainer">
                            <canvas id="decodeCanvas" class="image-preview"></canvas>
                            <div class="image-info" id="decodeImageInfo"></div>
                        </div>
                    </div>
                </div>

                <!-- Password Card -->
                <div class="card tool-card mb-3" id="decodePasswordSection" style="display: none;">
                    <div class="card-header-custom">
                        <i class="fas fa-key me-2"></i>Password
                    </div>
                    <div class="card-body">
                        <input type="password" id="decodePassword" class="form-control" placeholder="Enter password if message is encrypted">
                    </div>
                </div>

                <button class="btn btn-generate btn-lg w-100 mb-3" id="decodeBtn" onclick="decodeMessage()" disabled>
                    <i class="fas fa-unlock me-2"></i>Extract Hidden Message
                </button>
            </div>
        </div>

        <!-- Right Column - Output -->
        <div class="col-lg-7">
            <!-- Result Card -->
            <div class="card tool-card mb-3">
                <div class="card-header-custom">
                    <i class="fas fa-file-alt me-2"></i>Result
                </div>
                <div class="card-body">
                    <!-- Placeholder -->
                    <div id="resultPlaceholder" class="result-placeholder">
                        <i class="fas fa-user-secret"></i>
                        <p class="mb-0">Upload an image and enter a message to hide,<br>or upload an image to extract a hidden message.</p>
                    </div>

                    <!-- Loading -->
                    <div class="loading-spinner" id="loadingSpinner">
                        <div class="spinner"></div>
                        <p class="text-muted">Processing...</p>
                    </div>

                    <!-- Encode Result -->
                    <div class="result-section" id="encodeResult"></div>

                    <!-- Decode Result -->
                    <div class="result-section" id="decodeResult"></div>
                </div>
            </div>

            <!-- How It Works Card -->
            <div class="card tool-card mb-3">
                <div class="card-header bg-light">
                    <h6 class="mb-0"><i class="fas fa-info-circle me-2" style="color: var(--theme-primary);"></i>How It Works</h6>
                </div>
                <div class="card-body">
                    <h6>LSB (Least Significant Bit) Encoding</h6>
                    <p class="small text-muted">This tool uses LSB steganography to hide messages in images. Each pixel's color values (RGB) are modified slightly by changing the least significant bit. These tiny changes are invisible to the human eye but can store binary data.</p>

                    <div class="row g-3 mt-2">
                        <div class="col-md-6">
                            <div class="options-section text-center">
                                <i class="fas fa-lock fa-2x mb-2" style="color: var(--theme-primary);"></i>
                                <h6 class="small fw-bold">Encoding</h6>
                                <p class="small text-muted mb-0">Your message is converted to binary and embedded into the image pixels.</p>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="options-section text-center">
                                <i class="fas fa-unlock fa-2x mb-2" style="color: var(--theme-primary);"></i>
                                <h6 class="small fw-bold">Decoding</h6>
                                <p class="small text-muted mb-0">The hidden bits are extracted and converted back to readable text.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tips Card -->
            <div class="card tool-card mb-3">
                <div class="card-header bg-light">
                    <h6 class="mb-0"><i class="fas fa-lightbulb me-2" style="color: var(--theme-primary);"></i>Tips</h6>
                </div>
                <div class="card-body">
                    <ul class="small text-muted mb-0">
                        <li><strong>Use PNG format</strong> - JPEG compression can destroy hidden data</li>
                        <li><strong>Larger images = more capacity</strong> - More pixels means more storage</li>
                        <li><strong>Use a password</strong> - Adds XOR encryption for extra security</li>
                        <li><strong>Don't edit the output image</strong> - Resizing or filtering will corrupt the hidden data</li>
                        <li><strong>Compatible with other tools</strong> - Works with stylesuxx and similar LSB tools</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <!-- Related Tools -->
    <div class="card tool-card mb-4">
        <div class="card-header bg-light py-2">
            <h6 class="mb-0"><i class="fas fa-tools me-2" style="color: var(--theme-primary);"></i>Related Tools</h6>
        </div>
        <div class="card-body">
            <div class="related-tools">
                <a href="CipherFunctions.jsp" class="related-tool-card">
                    <h6><i class="fas fa-lock me-1"></i>AES Encryption</h6>
                    <p>Encrypt text with AES</p>
                </a>
                <a href="rsafunctions.jsp" class="related-tool-card">
                    <h6><i class="fas fa-key me-1"></i>RSA Encryption</h6>
                    <p>Public key encryption</p>
                </a>
                <a href="file-encrypt.jsp" class="related-tool-card">
                    <h6><i class="fas fa-file-archive me-1"></i>File Encryption</h6>
                    <p>Encrypt files securely</p>
                </a>
                <a href="MessageDigest.jsp" class="related-tool-card">
                    <h6><i class="fas fa-fingerprint me-1"></i>Hash Calculator</h6>
                    <p>MD5, SHA-256, SHA-512</p>
                </a>
                <a href="HexToStringFunctions.jsp" class="related-tool-card">
                    <h6><i class="fas fa-exchange-alt me-1"></i>Hex Converters</h6>
                    <p>Hex to string conversion</p>
                </a>
                <a href="qr-code.jsp" class="related-tool-card">
                    <h6><i class="fas fa-qrcode me-1"></i>QR Code</h6>
                    <p>Generate QR codes</p>
                </a>
            </div>
        </div>
    </div>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
</div>

<%@ include file="addcomments.jsp"%>

<script>
// Global variables
var currentMode = 'encode';
var encodeImage = null;
var decodeImage = null;
var maxCapacity = 0;

// Mode switching
function switchMode(mode, btn) {
    currentMode = mode;
    document.querySelectorAll('.mode-btn').forEach(function(b) { b.classList.remove('active'); });
    btn.classList.add('active');

    document.getElementById('encodePanel').classList.toggle('active', mode === 'encode');
    document.getElementById('decodePanel').classList.toggle('active', mode === 'decode');

    // Reset results
    document.getElementById('resultPlaceholder').style.display = 'block';
    document.getElementById('encodeResult').classList.remove('active');
    document.getElementById('decodeResult').classList.remove('active');
}

// Setup encode upload
(function() {
    var zone = document.getElementById('encodeUploadZone');
    var input = document.getElementById('encodeImageInput');

    zone.addEventListener('click', function() { input.click(); });
    zone.addEventListener('dragover', function(e) { e.preventDefault(); zone.classList.add('dragover'); });
    zone.addEventListener('dragleave', function() { zone.classList.remove('dragover'); });
    zone.addEventListener('drop', function(e) {
        e.preventDefault();
        zone.classList.remove('dragover');
        if (e.dataTransfer.files.length > 0) processEncodeImage(e.dataTransfer.files[0]);
    });
    input.addEventListener('change', function(e) {
        if (e.target.files.length > 0) processEncodeImage(e.target.files[0]);
    });
    document.getElementById('messageInput').addEventListener('input', updateCapacityMeter);
})();

// Setup decode upload
(function() {
    var zone = document.getElementById('decodeUploadZone');
    var input = document.getElementById('decodeImageInput');

    zone.addEventListener('click', function() { input.click(); });
    zone.addEventListener('dragover', function(e) { e.preventDefault(); zone.classList.add('dragover'); });
    zone.addEventListener('dragleave', function() { zone.classList.remove('dragover'); });
    zone.addEventListener('drop', function(e) {
        e.preventDefault();
        zone.classList.remove('dragover');
        if (e.dataTransfer.files.length > 0) processDecodeImage(e.dataTransfer.files[0]);
    });
    input.addEventListener('change', function(e) {
        if (e.target.files.length > 0) processDecodeImage(e.target.files[0]);
    });
})();

function processEncodeImage(file) {
    if (!file.type.match('image.*')) { showToast('Please select an image file', 'warning'); return; }

    var reader = new FileReader();
    reader.onload = function(e) {
        var img = new Image();
        img.onload = function() {
            var canvas = document.getElementById('encodeCanvas');
            var ctx = canvas.getContext('2d');
            canvas.width = img.width;
            canvas.height = img.height;
            ctx.drawImage(img, 0, 0);

            encodeImage = ctx.getImageData(0, 0, canvas.width, canvas.height);
            maxCapacity = Math.floor((img.width * img.height * 3) / 8) - 100;

            document.getElementById('encodePreviewContainer').classList.add('active');
            document.getElementById('encodeImageInfo').innerHTML =
                '<div class="image-info-item"><span>Filename:</span><span>' + file.name + '</span></div>' +
                '<div class="image-info-item"><span>Dimensions:</span><span>' + img.width + ' x ' + img.height + '</span></div>' +
                '<div class="image-info-item"><span>Max capacity:</span><span>' + formatBytes(maxCapacity) + '</span></div>';

            document.getElementById('capacityMeter').style.display = 'block';
            document.getElementById('encodeBtn').disabled = false;
            updateCapacityMeter();
        };
        img.src = e.target.result;
    };
    reader.readAsDataURL(file);
}

function processDecodeImage(file) {
    if (!file.type.match('image.*')) { showToast('Please select an image file', 'warning'); return; }

    var reader = new FileReader();
    reader.onload = function(e) {
        var img = new Image();
        img.onload = function() {
            var canvas = document.getElementById('decodeCanvas');
            var ctx = canvas.getContext('2d');
            canvas.width = img.width;
            canvas.height = img.height;
            ctx.drawImage(img, 0, 0);

            decodeImage = ctx.getImageData(0, 0, canvas.width, canvas.height);

            document.getElementById('decodePreviewContainer').classList.add('active');
            document.getElementById('decodeImageInfo').innerHTML =
                '<div class="image-info-item"><span>Filename:</span><span>' + file.name + '</span></div>' +
                '<div class="image-info-item"><span>Dimensions:</span><span>' + img.width + ' x ' + img.height + '</span></div>';

            document.getElementById('decodePasswordSection').style.display = 'block';
            document.getElementById('decodeBtn').disabled = false;
        };
        img.src = e.target.result;
    };
    reader.readAsDataURL(file);
}

function updateCapacityMeter() {
    var message = document.getElementById('messageInput').value;
    var messageLength = new Blob([message]).size;
    var percentage = Math.min((messageLength / maxCapacity) * 100, 100);

    document.getElementById('capacityText').textContent = formatBytes(messageLength) + ' / ' + formatBytes(maxCapacity);
    document.getElementById('capacityFill').style.width = percentage + '%';

    if (percentage > 90) {
        document.getElementById('capacityFill').style.background = 'linear-gradient(135deg, #dc2626 0%, #b91c1c 100%)';
        document.getElementById('capacityDetails').textContent = 'Warning: Near capacity limit';
    } else if (percentage > 70) {
        document.getElementById('capacityFill').style.background = 'linear-gradient(135deg, #f59e0b 0%, #d97706 100%)';
        document.getElementById('capacityDetails').textContent = percentage.toFixed(1) + '% used';
    } else {
        document.getElementById('capacityFill').style.background = 'var(--theme-gradient)';
        document.getElementById('capacityDetails').textContent = percentage.toFixed(1) + '% used';
    }
}

function encodeMessage() {
    var message = document.getElementById('messageInput').value;
    if (!message) { showToast('Please enter a message', 'warning'); return; }
    if (!encodeImage) { showToast('Please upload an image', 'warning'); return; }

    var messageLength = new Blob([message]).size;
    if (messageLength > maxCapacity) {
        showToast('Message too large for this image', 'warning');
        return;
    }

    document.getElementById('resultPlaceholder').style.display = 'none';
    document.getElementById('loadingSpinner').classList.add('active');
    document.getElementById('encodeBtn').disabled = true;

    setTimeout(function() {
        try {
            var password = document.getElementById('encodePassword').value;
            var useCompression = document.getElementById('encodeCompression').checked;

            var processedMessage = message;
            if (password) processedMessage = xorEncrypt(message, password);
            if (useCompression) processedMessage = btoa(processedMessage);

            var encodedData = encodeLSB(encodeImage, processedMessage);

            var canvas = document.getElementById('encodeCanvas');
            var ctx = canvas.getContext('2d');
            ctx.putImageData(encodedData, 0, 0);

            canvas.toBlob(function(blob) {
                var url = URL.createObjectURL(blob);
                var filename = 'stego-' + Date.now() + '.png';

                document.getElementById('encodeResult').innerHTML =
                    '<div class="result-message">' +
                    '<h5><i class="fas fa-check-circle me-2"></i>Message Hidden Successfully!</h5>' +
                    '<p class="small mb-0">Your secret message has been embedded in the image.</p>' +
                    '</div>' +
                    '<canvas id="resultCanvas" class="image-preview"></canvas>' +
                    '<div class="d-flex gap-2 mt-3">' +
                    '<button class="btn btn-generate" onclick="downloadImage(\'' + url + '\', \'' + filename + '\')">' +
                    '<i class="fas fa-download me-2"></i>Download Image</button>' +
                    '<button class="btn btn-action" onclick="resetEncode()">' +
                    '<i class="fas fa-redo me-2"></i>New</button></div>';

                var resultCanvas = document.getElementById('resultCanvas');
                resultCanvas.width = canvas.width;
                resultCanvas.height = canvas.height;
                resultCanvas.getContext('2d').putImageData(encodedData, 0, 0);

                document.getElementById('loadingSpinner').classList.remove('active');
                document.getElementById('encodeResult').classList.add('active');
                showToast('Message hidden successfully!', 'success');
            }, 'image/png');

        } catch (err) {
            document.getElementById('loadingSpinner').classList.remove('active');
            document.getElementById('encodeResult').innerHTML =
                '<div class="result-error"><h5><i class="fas fa-exclamation-triangle me-2"></i>Encoding Failed</h5>' +
                '<p class="small mb-0">' + err.message + '</p></div>';
            document.getElementById('encodeResult').classList.add('active');
            document.getElementById('encodeBtn').disabled = false;
        }
    }, 100);
}

function decodeMessage() {
    if (!decodeImage) { showToast('Please upload an image', 'warning'); return; }

    document.getElementById('resultPlaceholder').style.display = 'none';
    document.getElementById('loadingSpinner').classList.add('active');
    document.getElementById('decodeBtn').disabled = true;

    setTimeout(function() {
        try {
            var encodedMessage = decodeLSB(decodeImage);
            if (!encodedMessage) throw new Error('No hidden message found');

            var password = document.getElementById('decodePassword').value;
            var processedMessage = encodedMessage;

            try { processedMessage = atob(encodedMessage); } catch(e) {}
            if (password) processedMessage = xorEncrypt(processedMessage, password);

            document.getElementById('decodeResult').innerHTML =
                '<div class="result-message">' +
                '<h5><i class="fas fa-check-circle me-2"></i>Message Extracted!</h5>' +
                '</div>' +
                '<div class="extracted-message">' + escapeHtml(processedMessage) + '</div>' +
                '<div class="d-flex gap-2 mt-3">' +
                '<button class="btn btn-action" onclick="copyToClipboard(\'' + escapeHtml(processedMessage).replace(/'/g, "\\'") + '\')">' +
                '<i class="fas fa-copy me-2"></i>Copy</button>' +
                '<button class="btn btn-action" onclick="resetDecode()">' +
                '<i class="fas fa-redo me-2"></i>New</button></div>';

            document.getElementById('loadingSpinner').classList.remove('active');
            document.getElementById('decodeResult').classList.add('active');
            showToast('Message extracted!', 'success');

        } catch (err) {
            document.getElementById('loadingSpinner').classList.remove('active');
            document.getElementById('decodeResult').innerHTML =
                '<div class="result-error"><h5><i class="fas fa-exclamation-triangle me-2"></i>Decoding Failed</h5>' +
                '<p class="small">' + err.message + '</p>' +
                '<ul class="small mb-0"><li>No hidden message in image</li><li>Wrong password</li><li>Image was modified after encoding</li></ul></div>';
            document.getElementById('decodeResult').classList.add('active');
            document.getElementById('decodeBtn').disabled = false;
        }
    }, 100);
}

// LSB Encoding
function encodeLSB(imageData, message) {
    var data = new Uint8ClampedArray(imageData.data);
    var msgLength = message.length;
    var header = [(msgLength >> 24) & 0xFF, (msgLength >> 16) & 0xFF, (msgLength >> 8) & 0xFF, msgLength & 0xFF];
    var fullMessage = header.concat(Array.from(new TextEncoder().encode(message)));
    var bitIndex = 0;

    for (var i = 0; i < fullMessage.length; i++) {
        var byte = fullMessage[i];
        for (var bit = 7; bit >= 0; bit--) {
            var bitValue = (byte >> bit) & 1;
            var pixelIndex = Math.floor(bitIndex / 3) * 4 + (bitIndex % 3);
            data[pixelIndex] = (data[pixelIndex] & 0xFE) | bitValue;
            bitIndex++;
        }
    }
    return new ImageData(data, imageData.width, imageData.height);
}

// LSB Decoding - Multi-method
function decodeLSB(imageData) {
    try { var r = decodeWithLengthHeader(imageData); if (r && r.length > 0) return r; } catch(e) {}
    try { var r = decodeNullTerminated(imageData); if (r && r.length > 0) return r; } catch(e) {}
    try { var r = decodeWithDelimiter(imageData); if (r && r.length > 0) return r; } catch(e) {}
    try { var r = decodePrintableASCII(imageData); if (r && r.length > 0) return r; } catch(e) {}
    throw new Error('No hidden message found or unsupported format');
}

function decodeWithLengthHeader(imageData) {
    var data = imageData.data, bitIndex = 0, bytes = [];
    for (var i = 0; i < 4; i++) {
        var byte = 0;
        for (var bit = 7; bit >= 0; bit--) {
            var pixelIndex = Math.floor(bitIndex / 3) * 4 + (bitIndex % 3);
            byte = (byte << 1) | (data[pixelIndex] & 1);
            bitIndex++;
        }
        bytes.push(byte);
    }
    var msgLength = (bytes[0] << 24) | (bytes[1] << 16) | (bytes[2] << 8) | bytes[3];
    if (msgLength <= 0 || msgLength > 100000) throw new Error('Invalid length');
    bytes = [];
    for (var i = 0; i < msgLength; i++) {
        var byte = 0;
        for (var bit = 7; bit >= 0; bit--) {
            var pixelIndex = Math.floor(bitIndex / 3) * 4 + (bitIndex % 3);
            byte = (byte << 1) | (data[pixelIndex] & 1);
            bitIndex++;
        }
        bytes.push(byte);
    }
    return new TextDecoder().decode(new Uint8Array(bytes));
}

function decodeNullTerminated(imageData) {
    var data = imageData.data, bitIndex = 0, bytes = [];
    for (var i = 0; i < 100000; i++) {
        var byte = 0;
        for (var bit = 7; bit >= 0; bit--) {
            var pixelIndex = Math.floor(bitIndex / 3) * 4 + (bitIndex % 3);
            if (pixelIndex >= data.length) break;
            byte = (byte << 1) | (data[pixelIndex] & 1);
            bitIndex++;
        }
        if (byte === 0) break;
        bytes.push(byte);
    }
    if (bytes.length === 0) throw new Error('No message');
    var text = new TextDecoder().decode(new Uint8Array(bytes));
    var printable = text.split('').filter(function(c) { var code = c.charCodeAt(0); return (code >= 32 && code <= 126) || code === 10 || code === 13; }).length;
    if (printable / text.length < 0.8) throw new Error('Not text');
    return text;
}

function decodeWithDelimiter(imageData) {
    var data = imageData.data, bitIndex = 0, bytes = [], delimiter = '#&#';
    for (var i = 0; i < 100000; i++) {
        var byte = 0;
        for (var bit = 7; bit >= 0; bit--) {
            var pixelIndex = Math.floor(bitIndex / 3) * 4 + (bitIndex % 3);
            if (pixelIndex >= data.length) break;
            byte = (byte << 1) | (data[pixelIndex] & 1);
            bitIndex++;
        }
        bytes.push(byte);
        if (bytes.length >= delimiter.length) {
            var tail = String.fromCharCode.apply(null, bytes.slice(-delimiter.length));
            if (tail === delimiter) { bytes = bytes.slice(0, -delimiter.length); break; }
        }
    }
    if (bytes.length === 0) throw new Error('No message');
    return new TextDecoder('utf-8', {fatal: false}).decode(new Uint8Array(bytes)).replace(/\0+$/, '');
}

function decodePrintableASCII(imageData) {
    var data = imageData.data, bitIndex = 0, bytes = [], consecutiveNonPrintable = 0;
    for (var i = 0; i < 50000; i++) {
        var byte = 0;
        for (var bit = 7; bit >= 0; bit--) {
            var pixelIndex = Math.floor(bitIndex / 3) * 4 + (bitIndex % 3);
            if (pixelIndex >= data.length) break;
            byte = (byte << 1) | (data[pixelIndex] & 1);
            bitIndex++;
        }
        if ((byte >= 32 && byte <= 126) || byte === 10 || byte === 13 || byte === 9) {
            bytes.push(byte); consecutiveNonPrintable = 0;
        } else if (byte === 0 && bytes.length > 0) break;
        else { consecutiveNonPrintable++; if (consecutiveNonPrintable > 10 && bytes.length > 0) break; if (consecutiveNonPrintable > 50) throw new Error('Not text'); }
    }
    if (bytes.length < 1) throw new Error('No message');
    return new TextDecoder().decode(new Uint8Array(bytes)).trim();
}

function xorEncrypt(message, password) {
    var result = '';
    for (var i = 0; i < message.length; i++) {
        result += String.fromCharCode(message.charCodeAt(i) ^ password.charCodeAt(i % password.length));
    }
    return result;
}

function formatBytes(bytes) {
    if (bytes === 0) return '0 B';
    var k = 1024, sizes = ['B', 'KB', 'MB'];
    var i = Math.floor(Math.log(bytes) / Math.log(k));
    return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
}

function escapeHtml(text) {
    var map = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#039;' };
    return text.replace(/[&<>"']/g, function(m) { return map[m]; });
}

function downloadImage(url, filename) {
    var a = document.createElement('a');
    a.href = url; a.download = filename; a.click();
}

function copyToClipboard(text) {
    navigator.clipboard.writeText(text).then(function() { showToast('Copied to clipboard', 'success'); });
}

function resetEncode() {
    document.getElementById('encodeImageInput').value = '';
    document.getElementById('messageInput').value = '';
    document.getElementById('encodePassword').value = '';
    document.getElementById('encodePreviewContainer').classList.remove('active');
    document.getElementById('encodeResult').classList.remove('active');
    document.getElementById('capacityMeter').style.display = 'none';
    document.getElementById('encodeBtn').disabled = true;
    document.getElementById('resultPlaceholder').style.display = 'block';
    encodeImage = null;
}

function resetDecode() {
    document.getElementById('decodeImageInput').value = '';
    document.getElementById('decodePassword').value = '';
    document.getElementById('decodePreviewContainer').classList.remove('active');
    document.getElementById('decodeResult').classList.remove('active');
    document.getElementById('decodePasswordSection').style.display = 'none';
    document.getElementById('decodeBtn').disabled = true;
    document.getElementById('resultPlaceholder').style.display = 'block';
    decodeImage = null;
}

function showToast(message, type) {
    var bgColor = type === 'success' ? 'var(--theme-gradient)' : 'linear-gradient(135deg, #f59e0b 0%, #fbbf24 100%)';
    var icon = type === 'success' ? 'check-circle' : 'exclamation-circle';
    var toast = $('<div class="position-fixed" style="bottom: 20px; right: 20px; z-index: 9999;">' +
        '<div class="toast show" style="background: ' + bgColor + '; border: none; border-radius: 8px;">' +
        '<div class="toast-body text-white" style="padding: 0.75rem 1rem;">' +
        '<i class="fas fa-' + icon + ' me-2"></i>' + message + '</div></div></div>');
    $('body').append(toast);
    setTimeout(function() { toast.fadeOut(function() { toast.remove(); }); }, 2500);
}
</script>
</div>
<%@ include file="body-close.jsp"%>
